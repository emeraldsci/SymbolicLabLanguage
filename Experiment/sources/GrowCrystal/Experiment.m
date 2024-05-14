
(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentGrowCrystal*)


(* ::Subsubsection::Closed:: *)
(*ExperimentGrowCrystal Options and Messages*)


DefineOptions[ExperimentGrowCrystal,
	Options :> {
		(*=== General Information ===*)
		{
			OptionName -> PreparedPlate,
			Default -> Automatic,
			Description -> "Indicates if the plate containing the samples for crystallization experiment has been previously transferred with samples and reagents and does not need to run sample preparation step to construct the crystallization plate. Once PreparedPlate is set to True, the provided plate is put into crystal incubator directly without sample preparation step and scheduled for daily imaging.",
			ResolutionDescription -> "Automatically set PreparedPlate to True if all samples are in one crystallization plate.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "General"
		},
		{
			OptionName -> CrystallizationTechnique,
			Default -> Automatic,
			Description -> "The technique that is used to construct crystallization plate and promote the sample solution to nucleate and grow during the incubation. For a crystal to nucleate and grow, the solution needs to reach the nucleation zone first, after which it can continue to grow. There are two common techniques: Vapor Diffusion and Microbatch. Both techniques are set up by a drop composed of a mixture of sample and reagents (such as precipitants, salts, additives) in the attempt to form the crystals of the input sample in the drop. In the Vapor Diffusion technique, two separate wells are connected by headspace for vapor: a drop well and a reservoir well. Water vapor leaves the drop during the incubation step and ends up in the reservoir containing higher concentration of precipitant, thus the change in concentration may lead to crystallization. In Microbatch technique, only the drop well is filled. Overtime, the droplet begins to evaporate causing the concentration of the drop to increase. Alternatively, some oil, like paraffin oil, can be added on top of the drop to seal the vapors in so that no significant concentration of the sample nor the reagents change overtime. See Figure 3.1 for more information about the set up for different Crystallization techniques and their courses on phase diagram.",
			ResolutionDescription -> "Automatically set CrystallizationTechnique to a technique that matches with CrystallizationPlate and technique-specific options. If CrystallizationPlate is set to a model which is only compatible with one technique, then set CrystallizationTechnique to that technique. If ReservoirDispensingInstrument or ReservoirBufferVolume is specified, automatically set CrystallizationTechnique to SittingDropVaporDiffusion. Likewise, if Oil or OilVolume is specified, automatically set CrystallizationTechnique to MicrobatchUnderOil. If none of these options are specified, set to CrystallizationTechnique default to SittingDropVaporDiffusion.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> CrystallizationTechniqueP(*SittingDropVaporDiffusion, MicrobatchWithoutOil, MicrobatchUnderOil*)
			],
			Category -> "General"
		},
		{
			OptionName -> CrystallizationStrategy,
			Default -> Automatic,
			Description -> "The end goal for setting up the crystallization plate, either Screening, Optimization, or Preparation. Screening is a multi-dimensional search for crystallization conditions by varying sample concentration, pH, ionic strengths, precipitants, additives to see which combination of variables produces crystals. While Optimization is after finding a set or multiple sets of factors that held some low-quality crystals, to fine-tune the conditions to obtain the best possible crystal for diffraction. Both Screening and Optimization provide multiple conditions for the same input sample. Preparation is preparing the crystallization plate with a fixed set of factors. See Figure 3.2 for more information about suggested options for different strategies.",
			ResolutionDescription -> "Automatically set to Null if PreparedPlate is True, set to Preparation if there is only one set of options for the input sample, set to Screening if there are multiple sets of options and SampleVolumes are all less than 1 Microliter, and set to Optimization if there are multiple sets of options and SampleVolumes is equal to or larger than 1 Microliter.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> CrystallizationStrategyP (*Screening, Optimization, Preparation*)
			],
			Category -> "General"
		},
		{
			OptionName -> CrystallizationPlate,
			Default -> Automatic,
			Description -> "The container that the input sample and other reagents that are transferred into. After the container is constructed by pipetting, it is incubated and imaged to monitor the growth of crystals of the input sample.",
			ResolutionDescription -> "If PreparedPlate is True, automatically set CrystallizationPlate to the input container. If PreparedPlate is False and CrystallizationTechnique is MicrobatchUnderOil, set CrystallizationPlate to Model[Container, Plate, Irregular, Crystallization, \"MRC UnderOil 96 Well Plate\"]. For other crystallization techniques, set CrystallizationPlate to Model[Container, Plate, Irregular, Crystallization, \"MiTeGen 1 Drop Plate\"] if CrystallizationStrategy is Screening, or set CrystallizationPlate to Model[Container, Plate, Irregular, Crystallization, \"MRC Maxi 48 Well Plate\"] if CrystallizationStrategy is Optimization or Preparation.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"X-Ray Crystallography",
						"Labware",
						"Containers",
						"Crystallization Plates"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> CrystallizationPlateLabel,
			Default -> Automatic,
			Description -> "A user defined word or phrase used to identify the CrystallizationPlate that the input sample and other reagents that are transferred into and incubated and imaged to monitor the growth of crystals of the input sample, for use in downstream unit operations.",
			ResolutionDescription -> "If PreparedPlate is True, automatically set CrystallizationPlateLabel to \"Prepared Crystallization Plate #\". If PreparedPlate is False, automatically set CrystallizationPlateLabel to \"Crystallization Plate #\".",
			AllowNull -> False,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			UnitOperation -> True,
			Category -> "General"
		},
		{
			OptionName -> CrystallizationCover,
			Default -> Model[Item, PlateSeal, "Crystal Clear Sealing Film"],
			Description -> "The thin film that is placed over the top of the CrystallizationPlate after the container is constructed by pipetting. The sealed CrystallizationPlate is then incubated and imaged to monitor the growth of crystals of the input sample. CrystallizationCover separates the contents inside of CrystallizationPlate from environment and each other to prevent contamination, evaporation and cross-contamination.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, PlateSeal], Object[Item, PlateSeal]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"X-Ray Crystallography",
						"Labware",
						"Consumables",
						"Crystallization Covers"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> ReservoirDispensingInstrument,
			Default -> Automatic,
			Description -> "The instrument for transferring reservoir buffers to the reservoir wells of crystallization plate during the sample preparation step of the crystallization experiment if CrystallizationTechnique is SittingDropVaporDiffusion.",
			ResolutionDescription -> "Automatically set to Model[Instrument, LiquidHandler, \"Super STAR\"] if CrystallizationTechnique is SittingDropVaporDiffusion and PreparedPlate is False.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Liquid Handling",
						"Robotic Liquid Handlers"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> DropSetterInstrument,
			Default -> Automatic,
			Description -> "The instrument which transfers the input sample and other reagents to the drop wells of crystallization plate during the sample preparation step of the crystallization experiment. The instrument is often an acoustic liquid handler that transfers very small volumes of liquid in nanoliter range accurately via acoustic ejection. Alternatively, a robotic liquid handler that transfers larger volumes of liquid in microliter range using micropipettes can be used.",
			ResolutionDescription -> "Automatically set to Model[Instrument, LiquidHandler, \"Super STAR\"] if CrystallizationStrategy is Optimization or Preparation, or set to Model[Instrument, LiquidHandler, AcousticLiquidHandler, \"Labcyte Echo 650\"] if CrystallizationStrategy is Screening.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Model[Instrument, LiquidHandler],
					Object[Instrument, LiquidHandler],
					Model[Instrument, LiquidHandler, AcousticLiquidHandler],
					Object[Instrument, LiquidHandler, AcousticLiquidHandler]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Liquid Handling",
						"Robotic Liquid Handlers"
					},
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Liquid Handling",
						"Acoustic Liquid Handlers"
					}
				}
			],
			Category -> "General"
		},
		{
			(* This option is a placeholder in case we have multiple crystal incubator in the future *)
			OptionName -> ImagingInstrument,
			Default -> Model[Instrument, CrystalIncubator, "Formulatrix Rock Imager"],
			Description -> "The instrument for monitoring the growth of crystals of an input sample, which is placed in a crystallization plate. This is achieved by capturing daily images of the drop that contains the sample, using visible light, ultraviolet light and cross polarized light.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, CrystalIncubator], Object[Instrument, CrystalIncubator]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"X-Ray Crystallography",
						"Crystal Imager"
					}
				}
			],
			Category -> "General"
		},
		(*Index-matching options*)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(*=== Sample Preparation ===*)
			{
				OptionName -> CrystallizationScreeningMethod,
				Default -> Automatic,
				Description -> "The file containing a set of reagents is used to construct a crystallization plate for screening crystal conditions of the input sample. One set of screening reagents, consisting of ReservoirBuffers, Additives or CoCrystallizationReagents, is used to construct the crystal conditions for one input sample to limit the dimensions of uncertainty.  Other options including DilutionBuffer and SeedingSolution can be provided and combined with the sets of reagents in CrystallizationScreeningMethod. These combinations are then transferred in a multiplexed manner to create a unique drop composition for each well.",
				ResolutionDescription -> "Automatically set CrystallizationScreeningMethod to a screening method varying ReservoirBuffers based on the analytes of sample properties (i.e., protein and organic small molecule) if CrystallizationStrategy is Screening or Optimization and the options (such as ReservoirBuffers, Additives, CoCrystallizationReagents) required to construct the plate are not specified in sample preparation options, set CrystallizationScreeningMethod to None if CrystallizationStrategy is Preparation, or set CrystallizationScreeningMethod to Custom if no existing methods have desired ReservoirBuffers, Additives, or CoCrystallizationReagents and those options are to be specified directly.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Existing Screening Method" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Method, CrystallizationScreening]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Crystallization",
								"Reservoir Screening Kits"
							}
						}
				],
				"None or Custom" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[None, Custom]
					]
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> SampleVolumes,
				Default -> Automatic,
				Description -> "The amount(s) of the input sample that is transferred into the drop well of CrystallizationPlate as part of the drop setting step in sample preparation. When there are multiple SampleVolumes provided, each input sample is combined with other buffers such as DilutionBuffer, ReservoirBuffers, Additives, CoCrystallizationReagents, and SeedingSolution. These combinations are then transferred in a multiplexed manner to create a unique drop composition for each well. Please use ExperimentGrowCrystalPreview to check if the combinations are as you expected.",
				ResolutionDescription -> "If CrystallizationStrategy is set to Screening, SampleVolumes is automatically set to 200 Nanoliters. Otherwise, SampleVolumes is automatically set to 2 Microliters.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Fixed conditions" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
							Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
						],
						Orientation -> Horizontal
					],
					"Condition screening" -> {
						"Sample Volume Range" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
								Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
								Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
							]
						],
						"Sample Volume Increment" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
							Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
						]
					}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> ReservoirBuffers,
				Default -> Automatic,
				Description -> "The cocktail solution which contains high concentration of precipitants, salts and pH buffers. The ReservoirBuffer provides a specific combination of reagents that are designed to facilitate the crystallization of the input sample. Please use ExperimentGrowCrystalPreview to check if the combinations are as you expected.",
				ResolutionDescription -> "Automatically set to match the ReservoirBuffers field in the CrystallizationScreeningMethod, or set to Model[Sample, StockSolution, \"300mM Sodium Chloride\"] if CrystallizationScreeningMethod is Custom or None.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Buffers" -> Adder[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Materials",
									"Reagents",
									"Crystallization",
									"Reservoir Buffers"
								}
							}
						],
						Orientation -> Horizontal
					],
					"None" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> ReservoirBufferVolume,
				Default -> Automatic,
				Description -> "The amount of ReservoirBuffers that is transferred into the reservoir well of CrystallizationPlate, during the reservoir filling step of sample preparation before any drop well is set if CrystallizationTechnique is SittingDropVaporDiffusion. In such a plate configuration, the drops sharing headspace with each reservoir well have the same precipitant composition. The reservoir buffer placed in the reservoir well is designed to drive the supersaturation of samples in the drop wells that share the same headspace with the reservoir.",
				ResolutionDescription -> "Automatically set to 20 Microliters if CrystallizationStrategy is Screening and CrystallizationTechnique is SittingDropVaporDiffusion, or set to 200 Microliters if CrystallizationStrategy is Optimization or Preparation and CrystallizationTechnique is SittingDropVaporDiffusion.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinRoboticTransferVolume, $MaxCrystallizationPlateReservoirVolume],
					Units -> {Microliter, {Nanoliter, Microliter, Milliliter}}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> ReservoirDropVolume,
				Default -> Automatic,
				Description -> "The amount of ReservoirBuffers that is transferred into the drop well of CrystallizationPlate as part of the drop setting step of sample preparation. The reservoir buffer provides a specific combination of reagents that are designed to facilitate the crystallization of the input sample when mixed together.",
				ResolutionDescription -> "Automatically set to 200 Nanoliters if CrystallizationStrategy is Screening, or set to 2 Microliters if CrystallizationStrategy is Optimization or Preparation.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
					Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionBuffer,
				Default -> Automatic,
				Description -> "The solution to bring the concentration of the input sample down by mixing with the input sample as part of the drop setting step of sample preparation.",
				ResolutionDescription -> "Automatically set to None if PreparedPlate is False.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Buffer" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Buffers",
								"Biological Buffers"
							},
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Buffers",
								"Buffer Components"
							},
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Crystallization",
								"pH Buffer Components"
							}
						}
					],
					"None" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[None]
						]
					],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionBufferVolume,
				Default -> Automatic,
				Description -> "The amount of DilutionBuffer that is transferred into the drop well of CrystallizationPlate to bring down the concentration of the input sample as part of the drop setting step of sample preparation.",
				ResolutionDescription -> "If DilutionBuffer is specified, automatically set DilutionBufferVolume to 100 Nanoliters if CrystallizationStrategy is Screening, or set DilutionBufferVolume to 1 Microliters if CrystallizationStrategy is Optimization or Preparation.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
					Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> Additives,
				Default -> Automatic,
				Description -> "The solution that is transferred into the drop well of CrystallizationPlate to change the solubility of the input sample with the objective of improving crystal quality as part of the drop setting step of sample preparation. Additives can include a wide range of compounds, such as organic solvents, salts, amino acids, and polymers. When there are multiple Additives provided, each additive is combined with the input sample and other buffers such as DilutionBuffer, ReservoirBuffers, CoCrystallizationReagents, and SeedingSolution. These combinations are then transferred in a multiplexed manner to create a unique drop composition for each well. Please use ExperimentGrowCrystalPreview to check if the combinations are as you expected.",
				ResolutionDescription -> "Additives is automatically set to match the Additives field in the CrystallizationScreeningMethod if a method is specified, otherwise Additives is automatically set to None.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Additives" -> Adder[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Materials"
								}
							}
						],
						Orientation -> Horizontal
					],
					"None" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> AdditiveVolume,
				Default -> Automatic,
				Description -> "The amount of Additives that is transferred into the drop well of CrystallizationPlate with the objective of improving crystal quality as part of the drop setting step of sample preparation.",
				ResolutionDescription -> "If Additives is specified, automatically set AdditiveVolume to 50 Nanoliters if CrystallizationStrategy is Screening, or set AdditiveVolume to 500 Nanoliters if CrystallizationStrategy is Optimization or Preparation.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
					Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> CoCrystallizationReagents,
				Default -> Automatic,
				Description -> "The solution that is transferred into the drop well of CrystallizationPlate containing compounds such as small molecule drugs, metal salts, antibodies or other ligands that solidify together with the input sample. If CoCrystallizationAirDry is False, CoCrystallizationReagents are added to the drop during the drop setting step of sample preparation. Alternatively, CoCrystallizationReagents are added before the reservoir filling step of sample preparation when CoCrystallizationAirDry is True. Please use ExperimentGrowCrystalPreview to check if the combinations are as you expected.",
				ResolutionDescription -> "Automatically set CoCrystallizationReagents to match the CoCrystallizationReagents field in the CrystallizationScreeningMethod if a method is specified, otherwise set CoCrystallizationReagents to None.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Buffers" -> Adder[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Materials"
								}
							}
						],
						Orientation -> Horizontal
						],
					"None" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> CoCrystallizationReagentVolume,
				Default -> Automatic,
				Description -> "The amount of CoCrystallizationReagents that is transferred into the drop well of CrystallizationPlate containing small molecule drugs, metal salts, antibodies or other ligands with the objective of solidifying together with the input sample in a crystal form during the drop setting step of sample preparation if CoCrystallizationAirDry is False or before the reservoir filling step of sample preparation if CoCrystallizationAirDry is True.",
				ResolutionDescription -> "If CoCrystallizationReagents is specified, CoCrystallizationReagentVolume is automatically set to 50 Nanoliters when CrystallizationStrategy is Screening, or CoCrystallizationReagentVolume is set to 500 Nanoliters when CrystallizationStrategy is Optimization or Preparation.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
					Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> CoCrystallizationAirDry,
				Default -> Automatic,
				Description -> "Indicates if the CoCrystallizationReagents are added to an empty crystallization plate and fully evaporated prior to filling the reservoir well and drop well of the crystallization plate.",
				ResolutionDescription -> "Automatically set to the False if CoCrystallizationReagents if specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Sample Preparation"
			}
		],
		(*Non Index-matching sample preparation options*)
		{
			OptionName -> CoCrystallizationAirDryTime,
			Default -> Automatic,
			Description -> "The length of time for which the CoCrystallizationReagents are held inside the FumeHood or LiquidHandler enclosure with blower to allow the solvent to be fully evaporated from the crystallization plate prior to filling the reservoir well and drop well of the crystallization plate.",
			ResolutionDescription -> "Automatically set to half an hour if CoCrystallizationAirDry is True.",
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Hour, $MaxExperimentTime], Units -> {Hour, {Minute, Hour, Day}}],
			Category -> "Sample Preparation"
		},
		{
			OptionName -> CoCrystallizationAirDryTemperature,
			Default -> Automatic,
			Description -> "The temperature for which the CoCrystallizationReagents are held inside the FumeHood or on HeatBlock of LiquidHandler to allow the solvent to be fully evaporated from the crystallization plate prior to filling the reservoir well and drop well of the crystallization plate.",
			ResolutionDescription -> "Automatically set to $AmbientTemperature if CoCrystallizationAirDryTime is longer than an hour, or 40 degrees Celsius if CoCrystallizationAirDryTime is within an hour.",
			AllowNull -> True,
			Widget -> Alternatives[
				"Ambient Room Temperature" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]],
				"Set Heater Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$AmbientTemperature, $MaxRoboticIncubationTemperature], Units -> Alternatives[Celsius, Fahrenheit, Kelvin]]
			],
			Category -> "Sample Preparation"
		},
		(*Index-matching options*)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SeedingSolution,
				Default -> Automatic,
				Description -> "The solution that is transferred into the drop well of CrystallizationPlate containing micro crystals of the input sample as part of drop setting step. The micro crystals serve as nucleates to facilitate crystallization process.",
				ResolutionDescription -> "Automatically set to None if PreparedPlate is False.",
				AllowNull -> True,
				Widget -> Alternatives[
					"SeedingSolution" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
					],
					"None" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> SeedingSolutionVolume,
				Default -> Automatic,
				Description -> "The amount of SeedingSolution that is transferred into the drop well of CrystallizationPlate containing micro crystals of the input sample that serves as templates for the growth of larger crystals to facilitate crystallization during the drop setting step of sample preparation.",
				ResolutionDescription -> "If SeedingSolution is specified, SeedingSolutionVolume is automatically set to 50 Nanoliters if CrystallizationStrategy is Screening, or SeedingSolutionVolume is set to 500 Nanoliters if CrystallizationStrategy is Optimization or Preparation.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Nanoliter, $MaxCrystallizationPlateDropVolume],
					Units -> {Nanoliter, {Nanoliter, Microliter, Milliliter}}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> Oil,
				Default -> Automatic,
				Description -> "The fluid that is dispensed to cover the droplet containing sample and other reagents (DilutionBuffer, Additives, ReservoirBuffers, CoCrystallizationReagents) to control the evaporation of water after the drop setting step of sample preparation if CrystallizationTechnique is MicrobatchUnderOil.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Mineral Oil\"] if CrystallizationTechnique is MicrobatchUnderOil.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Crystallization",
							"Inert Oil"
						}
					}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> OilVolume,
				Default -> Automatic,
				Description -> "The amount of Oil that is dispensed to cover the droplet containing sample and other reagents (DilutionBuffer, Additives, ReservoirBuffers, CoCrystallizationReagents) to control the evaporation of water after the drop setting step of sample preparation if CrystallizationTechnique is MicrobatchUnderOil.",
				ResolutionDescription -> "Automatically set to 16 Microliter if Oil is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinRoboticTransferVolume, $MaxCrystallizationPlateReservoirVolume],
					Units -> {Microliter, {Nanoliter, Microliter, Milliliter}}
				],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DropSamplesOutLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the output samples in drop wells to grow crystal, for use in downstream unit operations.",
				ResolutionDescription -> "If PreparedPlate is True and the sample is in drop well, automatically set DropSamplesOutLabel to {\"PreparedPlate #N Sample Well M DropSamplesOut\"} where #N is the number of unique PreparedPlate and M is the well position of the sample. If PreparedPlate is False, automatically set DropSamplesOutLabel to a list {\"Crystallization Sample #N Headspace Group #M Drop Position #K\"...} where #N is the number of unique input sample, #M is the number of the unique headspace and #K is the unique drop position within the headspace.",
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]],
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> ReservoirSamplesOutLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the output samples in reservoir wells to facilitate crystal growth in the nearby drop wells, for use in downstream unit operations.",
				ResolutionDescription -> "If PreparedPlate is True and the sample is in reservoir well, automatically set ReservoirSamplesOutLabel to {\"PreparedPlate #N Sample Well M ReservoirSamplesOut\"} where #N is the number of unique PreparedPlate and M is the well position of the sample. If PreparedPlate is False and CrystallizationTechnique is SittingDropVaporDiffusion, automatically set ReservoirSamplesOutLabel to a list {\"Crystallization Sample #N Headsapce Group #M ReservoirSamplesOut\"...} where #N is the number of unique input sample and #M is the number of the unique headspace.",
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]],
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> DropDestination,
				Default -> Automatic,
				Description -> "The desired well content location for DropSamplesOut. See Figure 3.3 for more information.",
				ResolutionDescription -> "If PreparedPlate is True, automatically set DropDestination to the well locations of samples. If PreparedPlate is False, set DropDestination based on the configuration of CrystallizationPlate, CrystallizationTechnique and the total number of unique drop compositions.",
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Enumeration, Pattern :> CrystallizationWellContentsP]],
				Category -> "Sample Preparation"
			}
		],
		(*=== Non Index-matching options ===*)
		{
			OptionName -> PreMixBuffer,
			Default -> Automatic,
			Description -> "Indicates if various type of buffers (including DilutionBuffer, ReservoirBuffers, unevaporated CoCrystallizationReagents, Additives, SeedingSolution) should be premixed before being added to the drop wells of a CrystallizationPlate. When PreMixBuffer is set to True, these buffers are combined to generate mixtures that share components as DropSamplesOut, except no input samples included. The buffer mixtures are then transferred to the drop wells of CrystallizationPlate, followed by the direct transfer of input samples directly to the drop wells. This process ensures that unique drop compositions for DropSamplesOut are prepared. However, in some cases where the total volume of all the buffer components is below 1 Microliter while the volume of the input Sample component is equal to or greater than 1 Microliter, a different transfer approach is taken after the buffer mixtures are prepared. Instead of adding the buffer mixtures and input samples directly to the drop wells, they are first mixed together and then transferred to drop wells of CrystallizationPlate. The purpose of premixing the buffers is to reduce the sample preparation time for CrystallizationPlate during drop setting step of sample preparation. By premixing, the overall transfer time is minimized, improving the efficiency of the process. See Figure 3.4 for more information about PreMixBuffer.",
			ResolutionDescription -> "Automatically set PreMixBuffer to the Null if PreparedPlate is True or when there are less than two buffer components in DropSamplesOut, otherwise automatically set PreMixBuffer to True.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Sample Preparation"
		},
		(*=== Hidden ===*)
		{
			OptionName -> DropCompositionTable,
			Default -> Automatic,
			Description -> "All buffer types and their volumes as well as Sample and SampleVolume involved for DropSamplesOut. The buffer type includes DilutionBuffer, ReservoirBuffer, CoCrystallizationReagent, Additive, SeedingSolution and Oil. This Hidden table is used to populate composition field for DropSamplesOut as well as for ExperimentGrowCrystalPreview visualization.",
			ResolutionDescription -> "Set DropCompositionTable to Null if PreparedPlate is True, otherwise automatically fill DropCompositionTable with resolved sample preparation options.",
			AllowNull -> True,
			Widget -> Adder[
				(* The format of DropCompositionTable is 1)DropSampleOutLabel 2)DestinationWell 3)Sample 4)SampleVolume *)
				(* 5)DilutionBuffer 6)DilutionBufferVolume 7)ReservoirBuffer 8)ReservoirDropVolume 9)CoCrystallizationReagent *)
				(* 10)CoCrystallizationReagentVolume 11)CoCrystallizationAirDry 12)Additive 13)AdditiveVolume 14)SeedingSolution 15)SeedingSolutionVolume 16)Oil 17)OilVolume. *)
				{
					"DropSampleOutLabel" -> Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					],
					"DestinationWell" -> Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					],
					"Sample" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Sample]],
						ObjectTypes -> {Object[Sample]}
					],
					"SampleVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxCrystallizationPlateDropVolume],
						Units :> Nanoliter
					],
					"DilutionBuffer" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes -> {Model[Sample], Object[Sample]}
					],
					"DilutionBufferVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxCrystallizationPlateDropVolume],
						Units :> Nanoliter
					],
					"ReservoirBuffer" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes -> {Model[Sample], Object[Sample]}
					],
					"ReservoirDropVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxCrystallizationPlateDropVolume],
						Units :> Nanoliter
					],
					"CoCrystallizationReagent" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes -> {Model[Sample], Object[Sample]}
					],
					"CoCrystallizationReagentVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxCrystallizationPlateDropVolume],
						Units :> Nanoliter
					],
					"CoCrystallizationReagentAirDry" -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					"Additive" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes -> {Model[Sample], Object[Sample]}
					],
					"AdditiveVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxCrystallizationPlateDropVolume],
						Units :> Nanoliter
					],
					"SeedingSolution" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes -> {Model[Sample], Object[Sample]}
					],
					"SeedingSolutionVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxCrystallizationPlateDropVolume],
						Units :> Nanoliter
					],
					"Oil" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes -> {Model[Sample], Object[Sample]}
					],
					"OilVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinRoboticTransferVolume, $MaxCrystallizationPlateReservoirVolume],
						Units :> Microliter
					]
				},
				Orientation -> Vertical
			],
			Category -> "Hidden"
		},
		{
			OptionName -> BufferPreparationTable,
			Default -> Automatic,
			Description -> "The sequences of premixing or aliquoting solutions involved in step1:AirDryCoCrystallizationReagent or step3:SetDrop to a target container. This includes mixing buffers together, mixing buffers wit samples, or aliquoting both buffers and samples into an Echo-qualified SourcePlate when Acoustic Liquid Handling is required.",
			ResolutionDescription -> "Automatically set BufferPreparationTable to Null when PreparedPlate is True or when PreMixBuffer is set to False and no aliquoting to Echo-qualified SourcePlate is required, otherwise automatically fill BufferPreparationTable with transfer sequences of solutions to TargetContainer(s).",
			AllowNull -> True,
			Widget -> Adder[
				(* The format of BufferPreparationTable is 1)Step 2) Source(Link/PreMixSolutionLabel) 3)TransferVolume 4)TargetContainer 5)DestinationWells 6)TargetContainerLabel 7)PreparedSolutionsLabel. The flatten version of this option is uploaded to BufferPreparationTable of Object[Protocol, GrowCrystal]. *)
				{
					"Sample Preparation Step" -> Widget[
						Type -> Enumeration,
						Pattern :> CrystallizationStepP(*SetDrop, AirDryCoCrystallizationReagent*)
					],
					"Solution" -> Alternatives[
						"Sample or Buffer" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							ObjectTypes -> {Model[Sample], Object[Sample]}
						],
						"PreMixSolutionLabel" -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						]
					],
					"TransferVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
						Units :> Microliter
					],
					"TargetContainer" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container, Plate], Object[Container, Plate]}]
					],
					"DestinationWells" -> Adder[
         		Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						]
					],
					"TargetContainerLabel" -> Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					],
					"PreparedSolutionsLabel" -> Adder[
						Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Orientation -> Vertical
					]
				},
				Orientation -> Vertical
			],
			Category -> "Hidden"
		},
		{
			OptionName -> TransferTable,
			Default -> Automatic,
			Description -> "The sequences involved in preparing CrystallizationPlate with samples, DilutionBuffer, ReservoirBuffers, Additives, CoCrystallizationReagents, SeedingSolution and Oil or their mixtures prepared using BufferPreparationTable. The steps AirDryCoCrystallizationReagent, FillReservoir and CoverWithOil are not always required and automatically skipped when CoCrystallizationAirDry is False, and ReservoirBufferVolume is Null, or OilVolume is Null.",
			ResolutionDescription -> "Set TransferTable to Null if PreparedPlate is True, otherwise set TransferTable according to related sample preparation options with at least one loading entry for the SetDrop step. ",
			AllowNull -> True,
			Widget -> Adder[
				(* The format of TransferTable is 1)Step 2)TransferType3)Source(Link/PreparedSolutionLabel) 4)TransferVolume 5)DestinationWells 6)SamplesOutLabel. The flatten version of this option (split 3Source to 2 keys) is uploaded to TransferTables of Object[Protocol, GrowCrystal]. *)
				{
					"Sample Preparation Step" -> Widget[
						Type -> Enumeration,
						Pattern :> CrystallizationStepP(*SetDrop, AirDryCoCrystallizationReagent, FillReservoir, CoverWithOil*)
					],
					"TransferType" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[AcousticLiquidHandling, LiquidHandling]
					],
					"Solution" -> Alternatives[
						"Sample or Buffer" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							ObjectTypes -> {Model[Sample], Object[Sample]}
						],
						"PreparedSolutionLabel" -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						]
					],
					"TransferVolume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxCrystallizationPlateReservoirVolume],
						Units :> Nanoliter
					],
					"DestinationWells" -> Adder[
						Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
						]
					],
					"SamplesOutLabel" -> Adder[
						Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Orientation -> Vertical
					]
				},
				Orientation -> Vertical
			],
			Category -> "Hidden"
		},
		(*=== Incubation ===*)
		{
			OptionName -> MaxCrystallizationTime,
			Default -> 11 Day,
			Description -> "The max length of time for which the sample is held inside the crystal incubator to allow the growth of the crystals.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Day, 6 Month], Units -> {Day, {Hour, Day, Month}}],
			Category -> "Incubation"
		},
		{
			OptionName -> CrystallizationPlateStorageCondition,
			Default -> CrystalIncubation,
			AllowNull -> False,
			Widget -> Alternatives[
				"Storage Type" -> Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP
				],
				"Storage Object" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]]
				]
			],
			Description -> "The condition under which the CrystallizationPlate will be stored inside of the crystal incubator after the protocol is completed. During the storage, it is incubated and imaged to monitor the growth of crystals of the input sample.",
			Category -> "Hidden"
		},
		(*=== Imaging ===*)
		{
			OptionName -> UVImaging,
			Default -> Automatic,
			Description -> "Indicates if UV fluorescence images are scheduled to be captured. UV Imaging harnesses the intrinsic fluorescence of tryptophan excited by UV light at 280nm and emitted at 350nm to signify the presence of a protein, reducing false positive and false negative identification of protein crystals.",
			ResolutionDescription -> "Automatically set to True if the range of transparent wavelength of CrystallizationPlate covers 280nm-350nm and ImagingInstrument is cable of taking images at UVImaging mode.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Imaging"
		},
		{
			OptionName -> CrossPolarizedImaging,
			Default -> Automatic,
			Description -> "Indicates if images by cross polarized light of crystallization plate are scheduled to be captured. The polarizers aid in the identification of crystals by harnessing a crystal's natural birefringence properties, providing a kaleidoscope of colors on the crystal's planes to differentiate a crystal from the plate surface and mother liquor.",
			ResolutionDescription -> "Automatically set to True if the ImagingInstrument is cable of taking images at CrossPolarizedImaging mode.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Imaging"
		},
		(*=== Shared Options ===*)
		ProtocolOptions,
		SamplesInStorageOptions,
		SimulationOption,
		SamplePrepOptions,
		AliquotOptions
	}
];

(* Hamilton LH has a flat 50 Nanoliter error when using 50ul tip to transfer volume below 5 Microliter. *)
(* To increase precision, we limit the usage of Hamilton LH to volume greater or equal to 1 Microliter when adding solutions. *)
(* This is the threshold above which we use Hamilton LiquidHandler to transfer directly. *)
(* We also scale up any PreMixSolution volume to 30 Microliter when using Hamilton. *)
$RoboticTransferVolumeThreshold = 1 Microliter;
$RoboticPreMixVolumeThreshold = 30 Microliter;
(* We use less than 1 Microliter of samples when doing Screening CrystallizationStrategy to save samples when we are not sure about crystallization conditions. *)
(* When the end goal is to produce the best crystal for diffraction, we want to use greater than or equal to 1 Microliter of samples to produce larger crystals. *)
$CrystallizationScreeningVolumeThreshold = 1 Microliter;

Error::GrowCrystalPreparationNotSupported = "Currently only a prepared crystallization plate is supported as input, please use PreparatoryUnitOperations option of ExperimentGrowCrystal or ExperimentSamplePreparation to construct a prepared crystallization plate with samples beforehand. We will bring out ExperimentGrowCrystal built-in crystallization plate preparation soon.";
Error::InvalidPlateSample = "Sample(s) `1` found in the CrystallizationPlate are not specified as input sample. Since a CrystallizationPlate is stored inside of the crystal incubator as a whole during crystallization process, please transfer the sample(s) out beforehand.";
Error::InvalidPreparedPlateModel = "PreparedPlate `1` is not in one plate designed for Crystallization. When using a prepared plate, the samples must all be in the same Model[Container, Plate, Irregular, Crystallization] Plate. Please transfer the samples from `2` to a single crystallization plate or set PreparedPlate option to False.";
Error::InvalidPreparedPlateVolume = "Sample(s) `1` have volume `2` on a prepared plate, which is not in the range of 0 Microliter to `3`. When using a prepared plate, the volume of samples should be in the range of 0 to MaxVolume of the plate. Please ensure that the input samples have valid volumes.";
Error::InvalidInstrumentModels = "The specified instrument has model `1` that is not supporting liquid transfer. Please select a different instrument or let the experiment resolve automatically.";
Error::GrowCrystalTooManySamples = "The number of the input samples cannot fit into one plate in a single protocol. Please split them to several protocols.";
Error::ConflictingPreparedPlateWithInstrument = "The instrument option `1` is set to `2` and PreparedPlate is set to `3`. When PreparedPlate is set to True, neither DropSetterInstrument nor ReservoirDispensingInstrument should be used. When PreparedPlate is set to False, DropSetterInstrument must be used. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingPreparedPlateWithPreparation = "Sample preparation option(s) `1` of `2` are set to `3` and conflict with PreparedPlate option which is set to `4`. When PreparedPlate is True, no Buffers or CrystallizationScreeningMethod should be specified. When PreparedPlate is False, SampleVolumes, DropDestination and CrystallizationScreeningMethod must be specified. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingCrystallizationPlateWithTechnique = "Specified CrystallizationTechnique `1` is not one of CompatibleCrystallizationTechniques of the model of specified CrystallizationPlate `2`. Please select a different CrystallizationPlate.";
Error::ConflictingCrystallizationPlateWithInstrument = "Specified CrystallizationPlate `1` has dimension `3` while specified Instrument `2` has MaxPlateDimensions `4`. Please select a different CrystallizationPlate that is a SBS format plate with a height smaller than the instrument MaxPlateHeight.";
Error::ConflictingCrystallizationTechniqueWithPreparation = "The sample(s) `1` at indices '4' have specified buffer `2` at volume `3` while CrystallizationTechnique is set to `5`. When CrystallizationTechnique is set to MicrobatchUnderOil, Oil and Oil Volume should be specified. When CrystallizationTechnique is set to SittingDropVaporDiffusion, ReservoirBufferVolume should be specified and ReservoirBuffers should be non empty. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingPreparedPlateWithCrystallizationPlate = "Specified CrystallizationPlate `2` is not the same `1` as the specified input sample container. Please transfer the samples to the specified crystallization plate or change PreparedPlate option to False.";
Error::ConflictingDropSetterWithStrategy = "Specified DropSetterInstrument `1` is conflicting with the specified CrystallizationStrategy `2`. AcousticLiquidHandler should be picked as DropSetterInstrument when CrystallizationStrategy is set to Screening, and a robotic LiquidHandler should be picked When CrystallizationStrategy is set to Preparation or Optimization. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingReservoirDispenserWithTechnique = "Specified ReservoirDispensingInstrument `1` is conflicting with the specified CrystallizationTechnique `2`. ReservoirDispensingInstrument should only be picked when CrystallizationTechnique is set to SittingDropVaporDiffusion. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingDropSetterWithReservoirDispenser = "Specified DropSetterInstrument `1` is conflicting with the specified ReservoirDispensingInstrument `2`. To reduce the sample preparation time, if DropSettingInstrument is HamiltonLiquidHandler, ReservoirDispensingInstrument should be the same if needed. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingUVImaging = "If UVImaging is True, specified option `1` with value `2` can not used. When UVImaging is set to True, the ImagingInstrument should have UVImaging as one of the ImagingModes, and selected CrystallizationPlate and CrystallizationCover should allow UV to pass through.";
Error::ConflictingCrossPolarizedImaging = "If CrossPolarizedImaging is True, specified ImagingInstrument `1` can not used. When CrossPolarizedImaging is set to True, the ImagingInstrument should have CrossPolarizedImaging as one of the ImagingModes. Please change ImagingInstrument or set CrossPolarizedImaging to False.";
Error::ConflictingVisibleLightImaging = "Specified CrystallizationCover is `1` and CrystallizationPlate is `2`. To monitor the growth of crystal, images are taken daily at VisibleLightImagingMode and both plate and cover should not be opaque. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingPreMixBuffer = "PreMixBuffer option `2`  is conflicting with PreparedPlate option `1`. If PreparedPlate is True, PreMixBuffer should be Null. And if PreparedPlate set to False, PreMixBuffer should be True when more than one buffer components are specified one DropSamplesOut and the total volume of all buffer components are less than 1 Microliter. Please change PreMixBuffer option to specify a valid experiment.:";
Error::ConflictingCrystallizationCoverWithContainer = "Specified CrystallizationCover `1` does not fit on top of the specified CrystallizationPlate `2`. Please choose a different CrystallizationCover or let the experiment resolve automatically.";
Error::ConflictingScreeningMethodWithBuffers = "The sample(s) `1` at indices `4` has specified CrystallizationScreeningMethod `2`. The CrystallizationScreeningMethod contains field `3` with `5`, and it is conflicting with option `3` with value `6`. When a method file is specified, the ReservoirBuffers, Additives, CoCrystallizationReagents fields in the method file should be the same as ReservoirBuffers, Additives, CoCrystallizationReagents options. When CrystallizationScreeningMethod is set to None, only one set of ReservoirBuffers, Additives, CoCrystallizationReagents should be specified. When CrystallizationScreeningMethod is set to Custom, multiple sets of ReservoirBuffers, Additives, CoCrystallizationReagents can be specified directly. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingScreeningMethodWithStrategy = "The sample(s) `1` at indices `3` has specified CrystallizationScreeningMethod `2` which conflict with CrystallizationStrategy set to `4`. When CrystallizationStrategy is set to Preparation, only and only one set of crystal condition should be specified, therefor CrystallizationScreeningMethod should be None. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingSampleVolumes = "The sample(s) `1` at indices `3` contain SampleVolumes `3` outside of range `4` to `5`. Please make sure SampleVolumes is in the range `4` to `5`.";
Error::ConflictingDilutionBuffer = "The Sample(s) `1` at indices `4` have DilutionBuffer `2` and DilutionBufferVolume `3`. When DilutionBuffer is specified, DilutionBufferVolume should be specified in th range of 0 Nanoliter to `5`. When DilutionBuffer is Null or None, DilutionBufferVolume should be Null as well. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingReservoirOptions = "The Sample(s) `1` at indices `5` have ReservoirBuffers `2`, ReservoirBufferVolume `3` and ReservoirDropVolume `4`. When ReservoirBuffers is specified, ReservoirBufferVolume can be in the range of 1 Microliter to `6` and ReservoirDropVolume in the range of 0 Nanoliter to `7`, or one of the ReservoirBufferVolume and ReservoirDropVolume options can be Null. When ReservoirBuffers is None or Null, ReservoirBufferVolume and ReservoirDropVolume should be Null. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingSeedingSolution = "The Sample(s) `1` at indices `4` have SeedingSolution `2` and SeedingSolutionVolume `3`. When SeedingSolution is specified, SeedingSolutionVolume should be specified in the range of 0 Nanoliter to `5`. When SeedingSolution is Null or None, SeedingSolutionVolume should be Null as well. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingCoCrystallizationReagents = "The Sample(s) `1` at indices `4` have CoCrystallizationReagents `2` and CoCrystallizationReagentVolume `3`. When CoCrystallizationReagents is specified, CoCrystallizationReagentVolume should be specified in the range of 0 Nanoliter to `5`. When CoCrystallizationReagents is Null or None, CoCrystallizationReagentVolume should be Null as well. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingCoCrystallizationAirDry = "Specified CoCrystallizationAirDry related option `3` with value `1` is conflicting with specified option `4` with `2`. CoCrystallizationAirDryTime and CoCrystallizationAirDryTemperature are set when at least one sample has CoCrystallizationReagents that need to be air dried. All the CoCrystallizationReagents which need to be air dried have to be either all greater equal to 1 Microliter or all less than 5 Microliter at the same time. Please fix the error or let the experiment resolve automatically.";
Error::ConflictingOilOption = "The Sample(s) `1` at indices `4` have Oil `2` and OilVolume `3`. When Oil is specified, OilVolume should be specified in the range of `5` to `6`. When Oil is Null, OilVolume should be Null as well. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingTotalDropVolume = "The Sample(s) `1` at indices `3` have a max total drop volume `2` which is more than MaxVolume `5` of the Plate `4`. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingSamplesOutLabel = "The sample(s) `1` at indices `4` has `2` number of DropSamplesOutLabel and `3` number ReservoirSamplesOutLabel while the number of DropSampleOut is `5` and the number of ReservoirSamplesOut is `6`. The number of SamplesOutLabel must match the number of SamplesOut. Please fix the conflicting options or let the experiment resolve labels automatically.";
Error::DuplicatedBuffers = "The Sample(s) `1` at indices `3` contains duplicated buffers `2`. Please ensure that all the buffers are unique. If you really want to repeat one crystallization condition, please either add the desired condition to a new input sample for this protocol or submit a new protocol.";
Error::DiscardedBuffers = "Specified Buffers `1` are discarded. Please ensure that all buffers specified for this experiment are available.";
Error::DeprecatedBufferModels = "Specified Buffer Models `1` are deprecated. Please ensure that all buffers have non-deprecated models or set FastTrack to True.";
Error::NonLiquidBuffers = "Specified Buffers `1` are in a non liquid state. Please ensure that all buffers are liquid.";
Error::ConflictingDropDestination = "The Sample(s) `1` at indices `4` have `3` unique crystallization conditions, and have set DropDestination to `2` and CrystallizationPlate to `5`. Model of the CrystallizationPlate has `6` well position that can be used as drop destinations. Please fix these conflicting options or let the experiment resolve automatically.";
Error::GrowCrystalTooManyConditions = "There are `1` DropSamplesOut and `3` ReservoirSamplesOut generated in `5` number of HeadspaceSharing subdivisions. However, the CrystallizationPlate `7` only has `2` drop wells and `4` reservoir wells in `6` number of HeadspaceSharing subdivisions. Crystallization conditions cannot fit into one plate in a single protocol. Please select fewer conditions or input samples to run this protocol.";
Warning::DropVolumePrecision = "The sample(s) `1` at indices `2` have machine precision `3` for option `6`. Therefore `4` will have to be rounded from `4` to `5` to proceed. If you don't wish rounding to occur automatically, please supply a value within the given resolution.";
Warning::DropSamplePreMixed = "The sample(s) `1` at indices `2` need to be premixed with buffers since SampleVolumes for  `1` is `4` but total buffer volume is `3` during sample preparation set drop step of the protocol. When the total volume of all the buffer components is below 1 Microliter while the volume of the input Sample component is equal to or greater than 1 Microliter, sample needs to be mixed with buffers and then transferred to drop wells of CrystallizationPlate. If you don't wish premixing to occur automatically, please increase the buffer volume to 1 Microliter.";
Warning::DropSampleAliquoted = "The sample(s) `1` and buffer(s) `2` have been aliquoted to `3` prior adding to CrystallizationPlate. If you don't wish aliquoting to occur automatically, please transfer `1` and `2` to one of AcousticLiquidHandler compatible container models `4` before the experiment.";
Warning::CoCrystallizationReagentsAliquotedBeforeAirDry = "The CoCrystallizationReagents `1` have been scaled up from the required total volume `2` to aliquoted volume `3`, and aliquoted to `4` prior adding to CrystallizationPlate for air drying. If you don't wish aliquoting to occur automatically, please transfer `1` to AcousticLiquidHandler compatible container models `5` before the experiment.";
Warning::RiskOfEvaporation = "The number of combinations of the input samples and crystallization conditions requires `1` to transfer in a single protocol. The longer it takes to transfer, the higher risk of evaporation for the drops. Please consider selecting fewer crystallization conditions or input samples.";

(* ::Subsubsection::Closed:: *)
(* ExperimentGrowCrystal *)


(*---container objects as sample inputs---*)
ExperimentGrowCrystal[myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String|{LocationPositionP, _String|ObjectP[Object[Container]]}], myOptions:OptionsPattern[ExperimentGrowCrystal]] := Module[
	{
		outputSpecification, output, gatherTests, messages, listedInputs, listedOptions, validSamplePreparationResult,
		myInputsWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation, containerToSampleResult,
		containerToSampleOutput, containerToSampleSimulation, containerToSampleTests, samples, sampleOptions
	},
	(* Determine the requested return value from the function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Remove temporal links. *)
	(* Make sure we're working with a list of options/inputs. *)
	{listedInputs, listedOptions} = removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{myInputsWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentGrowCrystal,
			listedInputs,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentGrowCrystal,
			myInputsWithPreparedSamplesNamed,
			myOptionsWithPreparedSamplesNamed,
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
				ExperimentGrowCrystal,
				myInputsWithPreparedSamplesNamed,
				myOptionsWithPreparedSamplesNamed,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* If containerToSampleOptions failed - return $Failed. *)
		outputSpecification/.{
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
		ExperimentGrowCrystal[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
		]
	];

(*---Main function accepting sample objects as inputs---*)
ExperimentGrowCrystal[mySamples:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[ExperimentGrowCrystal]] := Module[
	{
		outputSpecification, output, gatherTests, messages, listedSamples, listedOptions, validSamplePreparationResult,
		mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation, safeOpsNamed,
		safeOpsTests, mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples, validLengths, validLengthTests,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cache, optionsWithObjects, allObjects, methodObjects,
		buffersInsideMethodObjects, defaultBufferObjects, defaultInstrumentObjects, coverObjects, modelIrregularPlateFields,
		modelCrystallizationPlateFields, modelImagerFields, modelLiquidHandlerFields, objectSampleFields, modelSampleFields,
		modelContainerObjects, objectContainerObjects, instrumentObjects, modelSampleObjects, sampleObjects, modelInstrumentObjects,
		objectContainerFields, modelContainerFields, modelInstrumentFields, modelCoverFields, allCrystallizationScreeningMethods,
		allCrystallizationScreeningPlates, liquidHandlerContainers, downloadedCache, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, returnEarlyQ, performSimulationQ, resultQ,
		resourcePackets, simulatedProtocol, simulation, protocolObject, resourcePacketTests
	},
	(* Determine the requested return value from the function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Remove temporal links. *)
	(* Make sure we're working with a list of options/inputs. *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentGrowCrystal,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew]; Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern. *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentGrowCrystal, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentGrowCrystal, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Call sanitize-inputs to clean any named objects. *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed. *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length. *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentGrowCrystal, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentGrowCrystal, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point). *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions. *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentGrowCrystal, {ToList[mySamplesWithPreparedSamples]}, ToList[myOptionsWithPreparedSamples], Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentGrowCrystal, {ToList[mySamplesWithPreparedSamples]}, ToList[myOptionsWithPreparedSamples]], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* Expand index-matching options. *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentGrowCrystal, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(* Fetch the cache from expandedSafeOps. *)
	cache = Lookup[expandedSafeOps, Cache, {}];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	(* Any options whose values could be an object. *)
	optionsWithObjects = {
		CrystallizationPlate,
		CrystallizationCover,
		ReservoirDispensingInstrument,
		DropSetterInstrument,
		ImagingInstrument,
		CrystallizationScreeningMethod,
		ReservoirBuffers,
		DilutionBuffer,
		Additives,
		CoCrystallizationReagents,
		SeedingSolution,
		Oil
	};

	(* Get a list of all the possible CrystallizationScreeningMethod we may resolve to using memoized search. *)
	(*
	{allCrystallizationScreeningMethods, allCrystallizationScreeningPlates} = crystallizationMethodsSearch["Memoization"];
	*)

	(* As of Jan 02 2024, Search might not return all the plates. Hard code here until Search is fixed. *)
	allCrystallizationScreeningMethods = {
		Object[Method, CrystallizationScreening, "id:n0k9mGkmxKnk"],(*"Hampton Research GRAS Screen 2"*)
		Object[Method, CrystallizationScreening, "id:Z1lqpMl96G50"],(*"Hampton Research SaltRx HT Screen"*)
		Object[Method, CrystallizationScreening, "id:Vrbp1jbPEJ7m"],(*"Hampton Research SaltRx 1 Screen"*)
		Object[Method, CrystallizationScreening, "id:8qZ1VWZ3bKBA"],(*"Hampton Research SaltRx 2 Screen"*)
		Object[Method, CrystallizationScreening, "id:D8KAEvKJrW3l"],(*"Hampton Research MembFac HT Screen"*)
		Object[Method, CrystallizationScreening, "id:Vrbp1jbPl7Lq"],(*"Hampton Research MembFac Screen"*)
		Object[Method, CrystallizationScreening, "id:rea9jlaDMNap"](*"Hampton Research Crystal Screen Lite"*)
	};
	allCrystallizationScreeningPlates = {
		Model[Container, Plate, Irregular, Crystallization, "id:E8zoYvzbBO1w"],(*"MRC Maxi 48 Well Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:01G6nvG865ad"],(*"48 Intelli 3 Drop Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:GmzlKjzbj4wM"],(*"96 MRC 2 Drop Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:4pO6dMO8A6lM"],(*"96 Intelli 3 Drop Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:O81aEB1ezmDx"],(*"96 MRC Under Oil Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:L8kPEjkEmXzw"],(*"MiTeGen 1 Drop Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:qdkmxzkxmWJp"],(*"MiTeGen 2 Drop Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:M8n3rxnr3x3m"],(*"MiTeGen 4 Drop Plate"*)
		Model[Container, Plate, Irregular, Crystallization, "id:aXRlGnRGlnNj"](*"MiTeGen 6 Drop Plate"*)
	};

	(* Expose any objects whose values are embedded in the method file. *)
	methodObjects = DeleteDuplicates@Join[Cases[Lookup[expandedSafeOps, CrystallizationScreeningMethod], ObjectP[]], allCrystallizationScreeningMethods];
	buffersInsideMethodObjects = Download[Flatten@Download[methodObjects, {ReservoirBuffers, Additives, CoCrystallizationReagents}, Cache -> cache, Date -> Now], Object];

	(* Get a list of preferred, liquid handler-compatible container models. *)
	(* Note all the crystallization plates are in this list as well. *)
	liquidHandlerContainers = DeleteDuplicates@Join[
		PreferredContainer[All, Type -> All, LiquidHandlerCompatible -> True],
		PreferredContainer[All, Type -> All, AcousticLiquidHandlerCompatible -> True],
		allCrystallizationScreeningPlates
	];

	(* Default buffer models from resolver. *)
	defaultBufferObjects = {
		Model[Sample, StockSolution, "id:n0k9mG8Bx7kW"], (*"300mM Sodium Chloride"*)
		Model[Sample, "id:kEJ9mqR8MnBe"](*"Mineral Oil"*)
	};

	(* Default instrument models from resolver. *)
	defaultInstrumentObjects = {
		Model[Instrument, LiquidHandler, AcousticLiquidHandler, "id:o1k9jAGrz9MG"],(*"Super STAR"*)
		Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"],(*"Labcyte Echo 650"*)
		Model[Instrument, CrystalIncubator, "id:6V0npvmnzzGG"](*"Formulatrix Rock Imager"*)
	};

	coverObjects = Join[
		(* Expose any covers come with sample containers. *)
			Download[
				Quiet[
					Download[
						DeleteDuplicates[
							Download[
								Download[ToList[mySamplesWithPreparedSamples], Container, Cache -> cache, Simulation -> samplePreparationSimulation],
								Object
							]
						],
					Cover,
					Cache -> cache,
					Simulation -> samplePreparationSimulation
				]
			],
			Object
		],
		(* User specified cover or the default PlateSeal from resolver:"Crystal Clear Sealing Film". *)
		{Lookup[expandedSafeOps, CrystallizationCover]}
	];

	(* All the objects. *)
	(* NOTE: Include the default samples, containers, methods and instruments that we can use since we want their packets as well. *)
	allObjects = DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				ToList[mySamplesWithPreparedSamples],
				Lookup[expandedSafeOps, optionsWithObjects],
				Cases[coverObjects, ObjectP[]],
				buffersInsideMethodObjects,
				liquidHandlerContainers,
				defaultBufferObjects,
				defaultInstrumentObjects
			],
			ObjectP[]
		],
		Object,
		Date -> Now
	];

	(* Create the Packet Download syntax for our Object and Model. *)
	modelIrregularPlateFields = {MaxVolumes, HeadspaceSharingWells, LiquidHandlerIncompatible, MinTransparentWavelength, Positions};
	modelCrystallizationPlateFields = {LabeledRows, LabeledColumns, CompatibleCrystallizationTechniques, WellContents};
	modelImagerFields = {MinTemperature, MaxTemperature, MaxPlateDimensions, ImagingModes};
	modelLiquidHandlerFields = {MinPlateHeight, MaxPlateHeight, MaxFlangeHeight, Scale, LiquidHandlerType, MaxVolume, MinVolume, WettedMaterials};

	objectSampleFields = Union[{Volume, Composition, Solvent, IncompatibleMaterials, Position, Notebook}, SamplePreparationCacheFields[Object[Sample]]];
	modelSampleFields = Union[{IncompatibleMaterials, Products, Composition, Solvent, UsedAsSolvent, Preparable, State}, SamplePreparationCacheFields[Model[Sample]]];
	objectContainerFields = Union[{Notebook}, SamplePreparationCacheFields[Object[Container]]];
	modelContainerFields = Union[modelIrregularPlateFields, modelCrystallizationPlateFields, SamplePreparationCacheFields[Model[Container]]];
	modelInstrumentFields = Union[{Name}, modelImagerFields, modelLiquidHandlerFields];
	modelCoverFields = {CoverType, CoverFootprint, SealType, Opaque, MinTransparentWavelength, MaxTransparentWavelength, Dimensions, Reusability, EngineDefault, Name};

	sampleObjects = Cases[allObjects, ObjectP[Object[Sample]]];
	modelSampleObjects = Cases[allObjects, ObjectP[Model[Sample]]];
	instrumentObjects = Cases[allObjects, ObjectP[Object[Instrument]]];
	modelInstrumentObjects = Cases[allObjects, ObjectP[Model[Instrument]]];
	objectContainerObjects = Cases[allObjects, ObjectP[Object[Container]]];
	modelContainerObjects = Cases[allObjects, ObjectP[Model[Container]]];

	(* Combine our simulated cache and download cache. *)
	downloadedCache = Quiet[
		Download[
			{
				sampleObjects,
				modelSampleObjects,
				instrumentObjects,
				modelInstrumentObjects,
				objectContainerObjects,
				modelContainerObjects,
				Cases[coverObjects, ObjectP[]],
				methodObjects
			},
			{
				{
					Evaluate[Packet@@objectSampleFields],
					Packet[Model[modelSampleFields]],
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]]
				},
				{
					Evaluate[Packet@@modelSampleFields]
				},
				{
					Packet[Name, Status, Model, DefaultTemperature, Contents],
					Packet[Model[modelInstrumentFields]]
				},
				{
					Evaluate[Packet@@modelInstrumentFields]
				},
				{
					Evaluate[Packet@@objectContainerFields],
					Packet[Model[modelContainerFields]]
				},
				{
					Evaluate[Packet@@modelContainerFields]
				},
				{
					Evaluate[Packet@@modelCoverFields],
					Packet[Name, Model],
					Packet[Model[modelCoverFields]]
				},
				{
					Packet[ReservoirBuffers, Additives, CoCrystallizationReagents]
				}
			},
			Cache -> cache,
			Simulation -> samplePreparationSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	cacheBall = FlattenCachePackets[{
		cache,
		downloadedCache
	}];

	(* Build the resolved options. *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentGrowCrystalOptions[
			mySamplesWithPreparedSamples,
			expandedSafeOps,
			Cache -> cacheBall,
			Simulation -> samplePreparationSimulation,
			Output -> {Result, Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {
				resolveExperimentGrowCrystalOptions[
					mySamplesWithPreparedSamples,
					expandedSafeOps,
					Cache -> cacheBall,
					Simulation -> samplePreparationSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options. *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentGrowCrystal,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];


	(* Run all the tests from the resolution; if any of them were False, then we should return early here. *)
	(* We need to do this because if we are collecting tests then the Check wouldn't have caught it. *)
	(* Basically, if _not_ all the tests are passing, then we do need to return early. *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			True,
		gatherTests,
			Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True,
			False
	];

	(* NOTE: We need to perform simulation if Result is asked for in GrowCrystal since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation. *)
	resultQ = MemberQ[output, Result]|| MatchQ[$CurrentSimulation, SimulationP];

	(* If option resolution failed, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentGrowCrystal, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources. *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourcePackets, resourcePacketTests} = If[returnEarlyQ,
		{$Failed, {}},
		If[gatherTests,
			growCrystalResourcePackets[
				mySamplesWithPreparedSamples,
				expandedSafeOps,
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> samplePreparationSimulation,
				Output -> {Result, Tests}
			],
			{
				growCrystalResourcePackets[
					mySamplesWithPreparedSamples,
					expandedSafeOps,
					resolvedOptions,
					Cache -> cacheBall,
					Simulation -> samplePreparationSimulation
				],
				{}
			}
		]
	];


	(* If we were asked for a simulation, also return a simulation. *)
	(* Even if resourcePackets is $Failed, simulation for resources is robust. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentGrowCrystal[
			resourcePackets,
			listedSamples,
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> samplePreparationSimulation
		],
		{Null, Null}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentGrowCrystal, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourcePackets, $Failed]||MatchQ[resolvedOptionsResult, $Failed],
			$Failed,
		(* If we're in global script simulation mode, we want to upload our simulation to the global simulation. *)
		MatchQ[$CurrentSimulation, SimulationP],
			Module[{},
				UpdateSimulation[$CurrentSimulation, simulation];
				If[MatchQ[Lookup[safeOps, Upload], False],
					Lookup[simulation[[1]], Packets],
					simulatedProtocol
				]
			],
		(* Otherwise, upload a real protocol that's ready to be run. *)
		True,
			UploadProtocol[
				resourcePackets,
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol, GrowCrystal],
				Cache -> cacheBall,
				Simulation -> simulation
			]
	];

	(* Return requested output. *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentGrowCrystal, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}
];


(* ::Subsubsection::Closed:: *)
(*crystallizationMethodsSearch*)

(* NOTE: We also cache our search because we will do it multiple times. *)
crystallizationMethodsSearch[dummyString_] := crystallizationMethodsSearch[dummyString] = Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`crystallizationMethodsSearch],
		AppendTo[$Memoization, Experiment`Private`crystallizationMethodsSearch]
	];

	Search[
		{
			Object[Method, CrystallizationScreening],
			Model[Container, Plate, Irregular, Crystallization]
		},
		{
			Notebook == Null,
			DeveloperObject != True && Deprecated != True
		}
	]
];

(* ::Subsubsection::Closed:: *)
(*ExperimentGrowCrystalOptions*)


DefineOptions[ExperimentGrowCrystalOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentGrowCrystal}
];

Authors[ExperimentGrowCrystalOptions] := {"lige.tonggu", "thomas"};

ExperimentGrowCrystalOptions[myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentGrowCrystal *)
	options = ExperimentGrowCrystal[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentGrowCrystal],
		options
	]
];

(* ::Subsubsection:: *)
(*Resolver*)


DefineOptions[
	resolveExperimentGrowCrystalOptions,
	Options :> {
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

resolveExperimentGrowCrystalOptions[
	myInputs:{ObjectP[{Object[Container], Object[Sample]}]..},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentGrowCrystalOptions]
] := Module[
	{
		(* General start *)
		outputSpecification, output, gatherTests, messagesQ, notInEngine, cache, fastTrack, currentSimulation, samplePrepOptions,
		growCrystalOptions, simulatedSamples, resolvedSamplePrepOptions, simulatedCache, growCrystalOptionsAssociation,
		(* Download info *)
		preparedPlate, suppliedSampleVolumes, minSuppliedSampleVolume, maxSuppliedSampleVolume, suppliedReservoirDispensingInstrument,
		suppliedDropSetterInstrument, suppliedImager, suppliedDilutionBuffer, suppliedReservoirBuffers, suppliedAdditives,
		suppliedCoCrystallizationReagents, suppliedSeedingSolution, suppliedOil, suppliedCrystallizationScreeningMethod,
		suppliedCrystallizationCover, suppliedCrystallizationPlate, uniqueReservoirBufferObjects, uniqueAdditiveObjects,
		uniqueCoCrystallizationReagentObjects, objectSamplePacketFields, modelSamplePacketFields, objectContainerFields,
		modelContainerFields, samplePackets, sampleModelPackets, sampleContainerPackets, sampleContainerModelPackets,
		sampleAnalytesPackets, sampleSolventPackets, sampleComponentPackets, 	reservoirDispensingInstrumentPackets,
		dropSetterInstrumentPackets, imagerPackets, getEchoSourcePlateWorkingVolume, getEchoSourcePlateDeadVolume, cacheBall, fastAssoc,
		(* Input Checks I *)
		preparedOnlyError, preparedOnlyTest, discardedSamplePackets, discardedInvalidInputs, discardedTest, sampleModelPacketsToCheck,
		deprecatedSampleModelPackets, deprecatedInvalidInputs, deprecatedTest,
		(* Rounded Options I *)
		partiallyRoundedGrowCrystalOptions, precisionTests1,
		(* Resolve general options *)
		resolvedPreparedPlate, resolvedCrystallizationTechnique, resolvedCrystallizationStrategy, resolvedCrystallizationPlate,
		resolvedPlateModelPacket, numberOfDropWells, numberOfReservoirWells, numberOfDropWellsPerSubdivision,
		maxResolvedPlateDropVolume, maxResolvedPlateReservoirVolume, userSpecifiedLabels, resolvedCrystallizationPlateLabel,
		resolvedCrystallizationCover, resolvedCoverModelPacket, resolvedDropSetterInstrument, resolvedDropSetterModelPacket,
		resolvedReservoirDispensingInstrument, resolvedReservoirDispenserModelPacket, resolvedImager, resolvedImagerModelPacket,
		resolvedUVImaging, resolvedCrossPolarizedImaging, resolvedMaxCrystallizationTime, resolvedCrystallizationPlateStorageCondition,
		resolvedGeneralOptions,
		(* Conflicting option checks I *)
		nonLiquidSamplePackets, nonLiquidInvalidInputs, nonLiquidTest, conflictingCrystallizationTechniqueWithPlateErrors,
		conflictingCrystallizationTechniquePlateTest, conflictingCrystallizationPlateWithInstrumentErrors, conflictingCrystallizationPlateWithInstrumentTest,
		conflictingDropSetterWithStrategyErrors, conflictingDropSetterTest, conflictingReservoirDispenserWithTechniqueErrors,
		conflictingReservoirDispenserTest, conflictingDropSetterWithReservoirDispenserErrors, conflictingDropSetterWithReservoirDispenserTest,
		conflictingUVImaging, conflictingUVImagingTest, conflictingCrossPolarizedImaging, conflictingCrossPolarizedImagingTest,
		conflictingPreMixBuffer, conflictingPreMixBufferTest, conflictingCoverContainerErrors, coverTest, conflictingVisibleLightImagingErrors,
		conflictingVisibleLightImagingTest, invalidInstrumentModels, invalidInstrumentModelsTest, plateInvalidSampleInputs,
		validPlateSampleTest, conflictingPreparedPlateWithInstrumentErrors, conflictingPreparedPlateInstrumentTest,
		conflictingPreparedPlateWithCrystallizationPlateErrors, conflictingCrystallizationPlateTest,
		(* Input Checks II *)
		tooManySamplesQ, tooManySamplesInvalidInputs, tooManySamplesTest, validPreparedPlateContainerQ, preparedPlateInvalidContainerInputs,
		validPreparedPlateContainerTest, preparedPlateInvalidVolumeInputs, validPreparedPlateVolumeTest,
		(* MapThread and checks *)
		mapThreadFriendlyOptions, resolvedCrystallizationScreeningMethod, resolvedSampleVolumes, resolvedReservoirBuffers,
		resolvedReservoirBufferVolume, resolvedReservoirDropVolume, resolvedDilutionBuffer, resolvedDilutionBufferVolume,
		resolvedAdditives, resolvedAdditiveVolume, resolvedCoCrystallizationReagents, resolvedCoCrystallizationReagentVolume,
		resolvedCoCrystallizationAirDry, resolvedCoCrystallizationAirDryTime, resolvedCoCrystallizationAirDryTemperature,
		resolvedSeedingSolution, resolvedSeedingSolutionVolume, resolvedOil, resolvedOilVolume, indexedDropDestinationCheck,
		resolvedDropSamplesOutLabel, resolvedReservoirSamplesOutLabel, resolvedDropDestination, indexedSamplesOutLabelingCheck,
		preMixRequired, preMixWithSampleRequired, partiallyResolvedTransferTable, indexedDropLabelToConditionAssociations,
		indexedNoDuplicatedBufferCheck, indexedTransferCheck, samplePrepTests, indexedNumberOfSubdivisions,
		resolvedMapThreadOptions, mapThreadFriendlyResolvedOptions,
		(* Unresolved checks *)
		resolvedLabelToWellRules, resolvedDropCompositionTable, step1TransferTable, step1BufferPreparationTable,
		step2TransferTable, step3DropCompositionAssocs, nonEmptySolutionComponentAssoc, resolvedPreMixBuffer,
		step3TransferTable, step3BufferPreparationTable, step4TransferTable, resolvedBufferPreparationTable,
		resolvedTransferTable, resolvedOptions,

		(* Conflicting option checks II *)
		conflictingPreparedPlateWithPreparationErrors, conflictingPreparedPlatePreparationTest,
		conflictingCrystallizationTechniqueWithPreparationErrors, conflictingCrystallizationTechniquePreparationTest,
		conflictingScreeningMethodErrors, conflictingScreeningMethodInputs, conflictingScreeningMethodTest,
		conflictingScreeningMethodStrategyErrors, conflictingScreeningMethodStrategyTest, conflictingSampleVolumesErrors,
		conflictingSampleVolumesTest, conflictingDilutionBufferErrors, conflictingDilutionBufferTest, conflictingReservoirErrors,
		conflictingReservoirTest, conflictingCoCrystallizationReagentsErrors, conflictingCoCrystallizationReagentsTest,
		conflictingCoCrystallizationAirDryErrors, conflictingCoCrystallizationAirDryTest, airDiredCoCrystallizationReagentsAliquotWarnings,
		airDiredCoCrystallizationReagentsAliquotTest, conflictingSeedingSolutionErrors, conflictingSeedingSolutionTest,
		conflictingOilErrors, conflictingOilTest, conflictingDropVolumeErrors, conflictingDropVolumeTest, duplicatedInvalidBufferErrors,
		duplicatedBuffersTest, allBufferObjects, discardedInvalidBuffers, discardedBufferTest, allBufferModels,
		deprecatedInvalidBufferModels, deprecatedBufferTest, nonLiquidBuffers, nonLiquidBufferTest, conflictingLabelErrors,
		conflictingLabelTest, conflictingDropDestinationErrors, conflictingDropDestinationTest, tooManyConditionsErrors,
		tooManyConditionsTest,
		(* Rounding, PreMix, Aliquot checks and CMQ checks *)
		volumeRoundingWarnings, sampleWithRoundedVolumes, precisionTests2, preMixWarnings, preMixTest, dropAliquotWarnings,
		dropAliquotTest, highEvaporationErrors, highEvaporationTest, targetContainers, targetAmounts, resolvedAliquotOptions,
		aliquotTests, compatibleMaterialsBool1, compatibleMaterialsBool2, compatibleMaterialsTests1, compatibleMaterialsTests2,
		compatibleMaterialsTests, compatibleMaterialsInvalidOption, specifiedOperator, upload, specifiedEmail, specifiedName,
		resolvedEmail, resolvedOperator, nameInvalidBool, nameInvalidOption, nameInvalidTest, resolvedAllOptions,
		(* All tests *)
		invalidInputs, invalidOptions, allTests
	},

	(*--- SETUP OUR USER SPECIFIED OPTIONS AND CACHE ---*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messagesQ = !gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings. *)
	notInEngine = !MatchQ[$ECLApplication, Engine];

	(* Pull out the Cache, FastTrack and Simulation options for the resolver. *)
	{cache, fastTrack, currentSimulation} = {
		Lookup[ToList[myResolutionOptions], Cache, {}],
		Lookup[ToList[myResolutionOptions], FastTrack, False],
		Lookup[ToList[myResolutionOptions], Simulation, Simulation[]]
	};

	(* Separate out our GrowCrystal options from our Sample Prep options. *)
	(* Sample Prep options include Incubate, centrifuge, filter, aliquot. *)
	{samplePrepOptions, growCrystalOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options including Incubate, centrifuge, filter, but not aliquot. *)
	(* After this step, use simulatedSamples which rep the state of the input samples after sample prep steps and before crystallization. *)
	{{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentGrowCrystal, myInputs, samplePrepOptions, Cache -> cache, Simulation -> currentSimulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentGrowCrystal, myInputs, samplePrepOptions, Cache -> cache, Simulation -> currentSimulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	growCrystalOptionsAssociation = Association[growCrystalOptions];

	(* Pull out options from myOptions. *)
	{
		preparedPlate,
		suppliedSampleVolumes,
		suppliedReservoirDispensingInstrument,
		suppliedDropSetterInstrument,
		suppliedImager,
		suppliedDilutionBuffer,
		suppliedReservoirBuffers,
		suppliedAdditives,
		suppliedCoCrystallizationReagents,
		suppliedSeedingSolution,
		suppliedOil,
		suppliedCrystallizationScreeningMethod,
		suppliedCrystallizationCover,
		suppliedCrystallizationPlate
	} = Lookup[growCrystalOptionsAssociation,
		{
			PreparedPlate,
			SampleVolumes,
			ReservoirDispensingInstrument,
			DropSetterInstrument,
			ImagingInstrument,
			DilutionBuffer,
			ReservoirBuffers,
			Additives,
			CoCrystallizationReagents,
			SeedingSolution,
			Oil,
			CrystallizationScreeningMethod,
			CrystallizationCover,
			CrystallizationPlate
		}
	];

	(* Pull out min and max SampleVolumes before rounding, We will check those options' precision after the MapThread. *)
	(* We will use the user-specified SampleVolumes to determine general options before resolving it in the MapThread. *)
	minSuppliedSampleVolume = If[MemberQ[Flatten@suppliedSampleVolumes, VolumeP],
		Min[Cases[Flatten@suppliedSampleVolumes, VolumeP]],
		Null
	];
	maxSuppliedSampleVolume = If[MemberQ[Flatten@suppliedSampleVolumes, VolumeP],
		Max[Cases[Flatten@suppliedSampleVolumes, VolumeP]],
		Null
	];

	(* Determine which fields we need to download from the input Objects. *)
	(* Create the Packet Download syntax for our Object and Model samples and containers. *)
	objectSamplePacketFields = Union[{Volume, Composition, Solvent, IncompatibleMaterials, Position}, SamplePreparationCacheFields[Object[Sample]]];
	modelSamplePacketFields = Union[{IncompatibleMaterials, Products, Composition, Solvent, UsedAsSolvent, Preparable}, SamplePreparationCacheFields[Model[Sample]]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = Union[{LabeledRows, LabeledColumns, CompatibleCrystallizationTechniques, WellContents, HeadspaceSharingWells, MinTransparentWavelength, MaxVolumes, LiquidHandlerIncompatible, MaxTemperature}, SamplePreparationCacheFields[Model[Container]]];

	(* Extract the packets that we need from our downloaded cache. *)
	(* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
	{
		(* Input sample related packets *)
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleAnalytesPackets,
		sampleSolventPackets,
		sampleComponentPackets,
		(* Instrument related packets *)
		(* Download the default instruments as well as supplied instruments to the same packets *)
		reservoirDispensingInstrumentPackets,
		dropSetterInstrumentPackets,
		imagerPackets
	} = Quiet[
		Download[
			(* objects argument *)
			{
				simulatedSamples,
				simulatedSamples,
				simulatedSamples,
				simulatedSamples,
				simulatedSamples,
				simulatedSamples,
				simulatedSamples,
				(* Instrument related packets *)
				(* Download the default instruments as well as supplied instruments to the same packets *)
				Union[
					Cases[ToList[suppliedReservoirDispensingInstrument], ObjectP[]],
					{Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]}(*Super STAR*)
				],
				Union[
					Cases[ToList[suppliedDropSetterInstrument], ObjectP[]],
					{
						Model[Instrument, LiquidHandler, AcousticLiquidHandler, "id:o1k9jAGrz9MG"], (*Super STAR*)
						Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"](*Labcyte Echo 650*)
					}
				],
				Union[
					Cases[ToList[suppliedImager], ObjectP[]],
					{Model[Instrument, CrystalIncubator, "id:6V0npvmnzzGG"]}(*Formulatrix Rock Imager*)
				]
			},
			(* fieldLists argument *)
			{
				(* Input sample related packets *)
				{Evaluate[Packet@@objectSamplePacketFields]},
				{Packet[Model[modelSamplePacketFields]]},
				{Packet[Container[objectContainerFields]]},
				{Packet[Container[Model[modelContainerFields]]]},
				{Packet[Analytes[{Object, Molecule, MolecularWeight}]]},
				{Packet[Solvent[{Density, Composition}]]},
				{Packet[Composition[[All, 2]][{Density, MolecularWeight}]]},
				(* Instrument related packets *)
				{
					Packet[Model, Name],
					Packet[Model[{Scale, LiquidHandlerType, MaxVolume, MinVolume}]],
					Packet[Scale, LiquidHandlerType, MaxVolume, MinVolume]
				},
				{
					Packet[Model, Name],
					Packet[Model[{MinPlateHeight, MaxPlateHeight, LiquidHandlerType, MaxVolume, MinVolume}]],
					Packet[MinPlateHeight, MaxPlateHeight, LiquidHandlerType, MaxVolume, MinVolume]
				},
				{
					Packet[Model, Name, DefaultTemperature],
					Packet[Model[{MaxPlateDimensions, ImagingModes}]],
					Packet[MaxPlateDimensions, ImagingModes]
				}
			},
			Cache -> cache,
			Simulation -> simulatedCache
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Flatten the list of Packets. *)
	{
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleAnalytesPackets,
		sampleSolventPackets,
		sampleComponentPackets,
		reservoirDispensingInstrumentPackets,
		dropSetterInstrumentPackets,
		imagerPackets
	} = Flatten /@ {
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleAnalytesPackets,
		sampleSolventPackets,
		sampleComponentPackets,
		reservoirDispensingInstrumentPackets,
		dropSetterInstrumentPackets,
		imagerPackets
	};

	cacheBall = FlattenCachePackets[{
		cache,
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleAnalytesPackets,
		sampleSolventPackets,
		sampleComponentPackets,
		(* Instrument related packets *)
		reservoirDispensingInstrumentPackets,
		dropSetterInstrumentPackets,
		imagerPackets
	}];

	(* Generate a fast cache association. *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Expose ReservoirBuffers, Additives and CoCrystallizationReagents from user specified method files to a flatten list. *)
	(* When CrystallizationScreeningMethod is populated, the fields in the method file are pulled to the unique values as well. *)
	uniqueReservoirBufferObjects = DeleteDuplicates[Join[Cases[Flatten@suppliedReservoirBuffers, ObjectP[]],
		Download[Flatten[fastAssocLookup[fastAssoc, #, {ReservoirBuffers}]& /@ Cases[suppliedCrystallizationScreeningMethod, ObjectP[], {}]], Object]]];
	uniqueAdditiveObjects = DeleteDuplicates[Join[Cases[Flatten@suppliedAdditives, ObjectP[]],
		Download[Flatten[fastAssocLookup[fastAssoc, #, {Additives}]& /@ Cases[suppliedCrystallizationScreeningMethod, ObjectP[], {}]], Object]]];
	uniqueCoCrystallizationReagentObjects = DeleteDuplicates[Join[Cases[Flatten@suppliedCoCrystallizationReagents, ObjectP[]],
		Download[Flatten[fastAssocLookup[fastAssoc, #, {CoCrystallizationReagents}]& /@ Cases[suppliedCrystallizationScreeningMethod, ObjectP[], {}]], Object]]];

	(* The DeadVolume of container is specific for Echo AcousticLiquidHandler, which is different from MinVolume for Hamilton Liquid Handler. *)
	(* The WorkingVolume of container is specific for Echo AcousticLiquidHandler for Buffer/Protein fluid, which is different from MaxVolume (which is DeadVolume+WorkingVolume). *)
	(* For DMSO fluid, the working volumes are larger (50 Microliter instead of 30 Microliter, 9.5 Microliter instead of 6 Microliter). *)
	(* However, we are using the smallest working volumes here to guarantee all buffers fit in the plate. *)
	(* We get the values from Echo AcousticLiquidHandler UserManual. *)
	getEchoSourcePlateWorkingVolume[containerModel_]:= Which[
		MatchQ[containerModel, ObjectP[Model[Container, Plate, "id:7X104vn56dLX"]]],(*"384-well Polypropylene Echo Qualified Plate"*)
			30 Microliter,
		MatchQ[containerModel, ObjectP[Model[Container, Plate, "id:01G6nvwNDARA"]]],(*"384-well Low Dead Volume Echo Qualified Plate"*)
			6 Microliter,
		True,
			fastAssocLookup[fastAssoc, containerModel, MaxVolume]
	];
	getEchoSourcePlateDeadVolume[containerModel_]:= Which[
		MatchQ[containerModel, ObjectP[Model[Container, Plate, "id:7X104vn56dLX"]]],(*"384-well Polypropylene Echo Qualified Plate"*)
			20 Microliter,
		MatchQ[containerModel, ObjectP[Model[Container, Plate, "id:01G6nvwNDARA"]]],(*"384-well Low Dead Volume Echo Qualified Plate"*)
			6 Microliter,
		True,
			fastAssocLookup[fastAssoc, containerModel, MinVolume]
	];


	(*-- INPUT VALIDATION CHECKS I--*)
	(*--Discarded input check--*)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded. *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[discardedInvalidInputs]>0 && messagesQ,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[simulatedSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputs, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*--Deprecated input check--*)
	(* Get the model packets from simulatedSamples that will be checked for whether they are deprecated. *)
	sampleModelPacketsToCheck = Cases[Flatten[sampleModelPackets], PacketP[Model[Sample]]];

	(* Get the model packets from simulatedSamples that are deprecated; if on the FastTrack, skip this check. *)
	deprecatedSampleModelPackets = If[!fastTrack,
		Select[sampleModelPacketsToCheck, TrueQ[Lookup[#, Deprecated]]&],
		{}
	];

	(* Set deprecatedInvalidInputs to the input objects whose models are Deprecated. *)
	deprecatedInvalidInputs = If[MatchQ[deprecatedSampleModelPackets, {}],
		{},
		Lookup[deprecatedSampleModelPackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[deprecatedInvalidInputs]>0 && messagesQ,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[simulatedSamples],
				Nothing,
				Test["Our input samples have models " <> ObjectToString[Complement[myInputs, deprecatedInvalidInputs], Cache -> cacheBall] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(*--- OPTION PRECISION CHECKS I---*)
	(* Round the options that have precision which do not depend on transfer procedures which need to be resolved later. *)
	(* NOTE: The precision for SampleVolumes, DilutionBufferVolume, ReservoirDropVolume, AdditiveVolume, CoCrystallizationReagentVolume, *)
	(* and SeedingSolutionVolume depends on which instrument is used for transfer, so we don't check their precisions here. *)
	(* Another Option Precision Checks block will throw warnings for those options after the MapThread. *)
	{partiallyRoundedGrowCrystalOptions, precisionTests1} = If[gatherTests,
		RoundOptionPrecision[
			growCrystalOptionsAssociation,
			{
				ReservoirBufferVolume,
				OilVolume,
				CoCrystallizationAirDryTemperature,
				CoCrystallizationAirDryTime,
				MaxCrystallizationTime
			},
			{
				$LiquidHandlerVolumeTransferPrecision,
				$LiquidHandlerVolumeTransferPrecision,
				1 Celsius,
				1 Minute,
				1 Day
			},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				growCrystalOptionsAssociation,
				{
					ReservoirBufferVolume,
					OilVolume,
					CoCrystallizationAirDryTemperature,
					CoCrystallizationAirDryTime,
					MaxCrystallizationTime
				},
				{
					$LiquidHandlerVolumeTransferPrecision,
					$LiquidHandlerVolumeTransferPrecision,
					1 Celsius,
					1 Minute,
					1 Day
				}
			],
			{}
		}
	];


	(*--- Resolve non-IndexMatching General options ---*)

	(* Determine if the input samples are in a prepared plate. *)
	resolvedPreparedPlate = Which[
		(* Is PreparedPlate specified by the user? *)
		!MatchQ[preparedPlate, Automatic],
			preparedPlate,
		(* Are input samples all in the same container which is compatible with crystallization? If not, not a prepared plate. *)
		Or[
			MemberQ[Lookup[sampleContainerPackets, Model], Except[ObjectP[Model[Container, Plate, Irregular, Crystallization]]]],
			!SameQ@@Lookup[sampleContainerPackets, Object]
		],
			False,
		(* Are all the contents of the container given as samples? There should not be other objects in a prepared plate. *)
		(* Since the whole plate is incubated in crystal incubator during crystallization and we are unable to separate other objects out. *)
		GreaterQ[Length[DeleteDuplicates@Download[Cases[Flatten@Lookup[sampleContainerPackets, Contents], ObjectP[]], Object]], Length[simulatedSamples]],
			False,
		(* Is CrystallizationPlate specified by the user? If it is not the same model as the input container, it is not a prepared plate. *)
		And[
			MatchQ[suppliedCrystallizationPlate, ObjectP[]],
			MatchQ[Lookup[sampleContainerPackets, Model], {ObjectP[Model[Container, Plate, Irregular, Crystallization]]..}],
			SameQ@@Lookup[sampleContainerPackets, Object],
			!MemberQ[Lookup[sampleContainerPackets, Model], suppliedCrystallizationPlate],
			!MatchQ[Lookup[sampleContainerPackets, Object], suppliedCrystallizationPlate]
		],
 			False,
		(* Is either ReservoirDispensingInstrument or DropSetterInstrument specified by the user? A prepared plate should not have those options specified. *)
		Or[
			MatchQ[suppliedReservoirDispensingInstrument, ObjectP[]],
			MatchQ[suppliedDropSetterInstrument, ObjectP[]]
		],
			False,
		(* Are there any sample preparation options specified by the users? A prepared plate should not have those options specified. *)
		(* NOTE: Here we don't check CrystallizationScreening Method file since the fields of any method file have been exposed to uniqueBlahObjects. *)
		Or[
			MemberQ[suppliedDilutionBuffer, ObjectP[]],
			MemberQ[suppliedSeedingSolution, ObjectP[]],
			MemberQ[suppliedOil, ObjectP[]],
			MemberQ[uniqueReservoirBufferObjects, ObjectP[]],
			MemberQ[uniqueAdditiveObjects, ObjectP[]],
			MemberQ[uniqueCoCrystallizationReagentObjects, ObjectP[]]
		],
			False,
		(* Otherwise *)
		True,
			True
	];

	(* Determine CrystallizationTechnique option. *)
	resolvedCrystallizationTechnique = Which[
		(* Is CrystallizationTechnique specified by the user? *)
		!MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CrystallizationTechnique], Automatic],
			Lookup[partiallyRoundedGrowCrystalOptions, CrystallizationTechnique],
		(* Is resolvedPreparedPlate True? We will fill the technique based on the compatibleCrystallizationTechniques field of container. *)
		MatchQ[resolvedPreparedPlate, True],
			Which[
				(* Is any of the samples in Reservoir wells? *)
				!MatchQ[Lookup[samplePackets, Position], {}] && MemberQ[StringContainsQ[#, "Reservoir"]& /@ Lookup[samplePackets, Position], True],
					SittingDropVaporDiffusion,
				(* Is any sampleVolume larger than $MaxCrystallizationPlateDropVolume? This only occurs when using MicrobatchUnderOil. *)
				!MatchQ[Lookup[samplePackets, Volume], {}] && MemberQ[Lookup[samplePackets, Volume], GreaterP[$MaxCrystallizationPlateDropVolume]],
					MicrobatchUnderOil,
				(* Otherwise, take the first non-SittingDropVaporDiffusion technique of the CompatibleCrystallizationTechniques of the plate model. *)
				True,
					FirstOrDefault[DeleteCases[Flatten@Lookup[sampleContainerModelPackets, CompatibleCrystallizationTechniques], SittingDropVaporDiffusion], MicrobatchWithoutOil]
			],
		(* Are there any technique-specific options, such as ReservoirDispensingInstrument, ReservoirBufferVolume, Oil options specified by the user? *)
		(* If user has specified ReservoirDispensingInstrument or ReservoirBufferVolume, resolve to SittingDropVaporDiffusion. *)
		Or[
			MatchQ[suppliedReservoirDispensingInstrument, ObjectP[]],
			MemberQ[Lookup[partiallyRoundedGrowCrystalOptions, ReservoirBufferVolume], VolumeP]
		],
			SittingDropVaporDiffusion,
		(* If user has specified Oil or OilVolume, resolve to MicrobatchUnderOil. *)
		Or[
			MemberQ[suppliedOil, ObjectP[]],
			MemberQ[Lookup[partiallyRoundedGrowCrystalOptions, OilVolume], VolumeP]
		],
			MicrobatchUnderOil,
		(* If user has specified not to use ReservoirBuffers in either method or ReservoirBuffers option, resolve to MicrobatchWithOil. *)
		Or[
			MemberQ[suppliedReservoirBuffers, None] && !MatchQ[uniqueReservoirBufferObjects, {ObjectP[]..}],
			MemberQ[suppliedCrystallizationScreeningMethod, ObjectP[]] && !MatchQ[uniqueReservoirBufferObjects, {ObjectP[]..}]
		],
			MicrobatchWithoutOil,
		(* Is CrystallizationPlate specified by the user? If so, use one of the CompatibleCrystallizationTechniques of the plate model. *)
		MatchQ[suppliedCrystallizationPlate, ObjectP[]],
			If[MatchQ[suppliedCrystallizationPlate, ObjectP[Object[Container, Plate]]],
				FirstOrDefault[fastAssocLookup[fastAssoc, suppliedCrystallizationPlate, {Model, CompatibleCrystallizationTechniques}], MicrobatchWithoutOil],
				FirstOrDefault[fastAssocLookup[fastAssoc, suppliedCrystallizationPlate, CompatibleCrystallizationTechniques], MicrobatchWithoutOil]
			],
		(* If user has specified nothing to help us select technique, use vapor diffusion technique since it is the most popular technique for protein crystallography. *)
		True,
			SittingDropVaporDiffusion
	];

	(* Resolve CrystallizationStrategy option. *)
	resolvedCrystallizationStrategy = Which[
		(* Is CrystallizationStrategy specified by the user? *)
		!MatchQ[Lookup[growCrystalOptionsAssociation, CrystallizationStrategy], Automatic],
			Lookup[growCrystalOptionsAssociation, CrystallizationStrategy],
		(* Is resolvedPreparedPlate True? Then we do not need Sample Preparation Strategy. *)
		MatchQ[resolvedPreparedPlate, True],
			Null,
		(* If user has specified DropSetter as Echo, select Screening strategy. *)
		MatchQ[suppliedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
			Screening,
		(* If user has specified SampleVolumes smaller than 1 Microliter, select Screening strategy. *)
		LessQ[minSuppliedSampleVolume, $CrystallizationScreeningVolumeThreshold],
			Screening,
		(* Is CrystallizationScreeningMethod None? When not screening any crystallization conditions, strategy is Preparation. *)
		(* For preparation Strategy, the crystallization condition is usually from literature or previous screening experiments. *)
		MemberQ[suppliedCrystallizationScreeningMethod, None],
			Preparation,
		(* Are any multiple sample preparation options, such as SampleVolumes, ReservoirBuffers, Additives, CoCrystallizationReagents options specified by the user ? *)
		Or[
			MemberQ[uniqueReservoirBufferObjects, ObjectP[]],
			MatchQ[Lookup[partiallyRoundedGrowCrystalOptions,ReservoirBufferVolume], {VolumeP..}],
			MemberQ[uniqueAdditiveObjects, ObjectP[]],
			MemberQ[uniqueCoCrystallizationReagentObjects, ObjectP[]],
			!MatchQ[suppliedSampleVolumes, {}]
		],
			Module[{specifiedBufferVolumes},
				specifiedBufferVolumes = Cases[Flatten@
					Lookup[partiallyRoundedGrowCrystalOptions,
						{
							DilutionBufferVolume,
							ReservoirDropVolume,
							AdditiveVolume,
							CoCrystallizationReagentVolume,
							SeedingSolutionVolume
						}
					],
					VolumeP
				];
				If[
					(* Is the minimum value of the SampleVolumes or any buffer (other than Oil) specified by the user larger than 1 Microliter? *)
					(* Or is ReservoirBuffer Volume larger than 40 Microliter? *)
					(* Or does the user-specified CrystallizationPlate have a maxVolume larger than 2 Microliter? *)
					(* Or has the user specified Hamilton LH as DropSetter? *)
					Or[
						GreaterEqualQ[minSuppliedSampleVolume, $CrystallizationScreeningVolumeThreshold],
						MemberQ[specifiedBufferVolumes, GreaterEqualP[$CrystallizationScreeningVolumeThreshold]],
						MemberQ[Lookup[partiallyRoundedGrowCrystalOptions, ReservoirBufferVolume], GreaterEqualP[40 Microliter]],
						And[
							MatchQ[suppliedSampleVolumes, {}],
							MatchQ[specifiedBufferVolumes, {}],
							MatchQ[suppliedCrystallizationPlate, ObjectP[Object[Container, Plate, Irregular]]],
							GreaterQ[Min[Flatten@fastAssocLookup[fastAssoc, suppliedCrystallizationPlate, {Model, MaxVolumes}]], 2*$CrystallizationScreeningVolumeThreshold]
						],
						And[
							MatchQ[suppliedSampleVolumes, {}],
							MatchQ[specifiedBufferVolumes, {}],
							MatchQ[suppliedCrystallizationPlate, ObjectP[Model[Container, Plate, Irregular]]],
							GreaterQ[Min[Flatten@fastAssocLookup[fastAssoc, suppliedCrystallizationPlate, {MaxVolumes}]], 2*$CrystallizationScreeningVolumeThreshold]
						],
						MatchQ[suppliedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]]
					],
						(* Does any of the sample preparation options have multiple values which will result in a combination of crystallization conditions? *)
						If[And[
								MatchQ[suppliedCrystallizationScreeningMethod, {Automatic..}],
								MatchQ[{Length[suppliedReservoirBuffers[[#]]], Length[suppliedAdditives[[#]]], Length[suppliedCoCrystallizationReagents[[#]]], Length[suppliedSampleVolumes[[#]]]} & /@ Range[Length[simulatedSamples]], {{Alternatives[0,1]..}..}]
							],
							Preparation,
							Optimization
						],
					Screening
				]
			],
		(* Otherwise, if user has specified nothing to help us select strategy, use Screening. *)
		True,
			Screening
	];

	(* Resolve CrystallizationPlate option and create a model packet. *)
	resolvedCrystallizationPlate = Which[
		(* Is CrystallizationPlate specified by the user? *)
		MatchQ[suppliedCrystallizationPlate, ObjectP[]],
			suppliedCrystallizationPlate,
		(* Is resolvedPreparedPlate True? Use the input sample container then. *)
		MatchQ[resolvedPreparedPlate, True],
			First[DeleteDuplicates@Lookup[sampleContainerPackets, Object]],
		(* Is resolvedCrystallizationTechnique MicrobatchUnderOil? *)
		(* "MRC UnderOil 96 Well Plate" is designed for both nanoliter crystallization screening and microliter optimization. *)
		MatchQ[resolvedCrystallizationTechnique, MicrobatchUnderOil],
			Model[Container, Plate, Irregular, Crystallization, "id:O81aEB1ezmDx"],(*"MRC UnderOil 96 Well Plate"*)
		(* Is resolvedCrystallizationStrategy Screening? *)
		(* NOTE: Most CrystallizationPlates are compatible with both MicrobatchWithoutOil and SittingDropVaporDiffusion. *)
		MatchQ[resolvedCrystallizationStrategy, Screening],
			Model[Container, Plate, Irregular, Crystallization, "id:L8kPEjkEmXzw"],(*"MiTeGen In Situ-1 Plate-1 Drop Layout"*)
		True,
			Model[Container, Plate, Irregular, Crystallization, "id:E8zoYvzbBO1w"](*"MRC Maxi 48 Well Plate"*)
	];

	(* Put the model information in a packet. *)
	resolvedPlateModelPacket = If[MatchQ[resolvedCrystallizationPlate, ObjectP[Object[Container]]],
		fetchPacketFromFastAssoc[Download[fastAssocLookup[fastAssoc, resolvedCrystallizationPlate, Model], Object], fastAssoc],
		fetchPacketFromFastAssoc[resolvedCrystallizationPlate, fastAssoc]
	];

	(* Determine how many drop wells & reservoirs wells this plate has. *)
	(* Pull out information about the HeadspaceSharing groups (subdivision) of this plate. *)
	{numberOfDropWells, numberOfReservoirWells} = Module[{wellContents},
		wellContents = If[MatchQ[Lookup[resolvedPlateModelPacket, Type], Model[Container, Plate, Irregular, Crystallization]],
			Lookup[resolvedPlateModelPacket, WellContents],
			(* If the CrystallizationPlate is not an Irregular CrystallizationPlate, don't check WellContents field. *)
			(* We will throw an error in conflicting option section. *)
			{}
		];
		If[!MatchQ[wellContents, {}],
			(* WellContents of a crystallizationPlate is DropN or Reservoir. *)
			{Length[Cases[wellContents, Except[Reservoir]]], Length[Cases[wellContents, Reservoir]]},
			(* If there is no WellContents, we will extract the NumberOfWells of the plate. *)
			{Lookup[resolvedPlateModelPacket, NumberOfWells], 0}
		]
	];
	numberOfDropWellsPerSubdivision = If[!EqualQ[numberOfReservoirWells, 0], numberOfDropWells/numberOfReservoirWells, 1];

	(* Pull out information about the MaxVolume for drop well and reservoir well of this plate. *)
	{maxResolvedPlateDropVolume, maxResolvedPlateReservoirVolume} = Which[
		(* For irregular plate, every well has a MaxVolume in the list of MaxVolumes. *)
		MatchQ[Lookup[resolvedPlateModelPacket, Type], Model[Container, Plate, Irregular, Crystallization]] && GreaterQ[numberOfReservoirWells, 0],
			{Min[Flatten@Lookup[resolvedPlateModelPacket, MaxVolumes]], Max[Flatten@Lookup[resolvedPlateModelPacket, MaxVolumes]]},
		MatchQ[Lookup[resolvedPlateModelPacket, Type], Model[Container, Plate, Irregular, Crystallization]],
			{Min[Flatten@Lookup[resolvedPlateModelPacket, MaxVolumes]], 0 Microliter},
		(* If user has specified a regular plate, we will use the MaxVolume value and constants MaxDrop/ReservoirVolume. *)
		True,
			{Min[$MaxCrystallizationPlateDropVolume, Lookup[resolvedPlateModelPacket, MaxVolume]], 0 Microliter}
	];

	(* Get all of the user specified labels. *)
	userSpecifiedLabels = DeleteDuplicates@Cases[
		Flatten@Lookup[
			partiallyRoundedGrowCrystalOptions,
			{CrystallizationPlateLabel, ReservoirSamplesOutLabel, DropSamplesOutLabel}
		],
		_String
	];

	(* Resolve the CrystallizationPlateLabel option. *)
	resolvedCrystallizationPlateLabel = Which[
		(* If user has specified CrystallizationPlateLabel, resolve to it. *)
		MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CrystallizationPlateLabel], Except[Automatic]],
			Lookup[partiallyRoundedGrowCrystalOptions, CrystallizationPlateLabel],
		(* If we are in a global simulation, look up the upstream label. *)
		MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[resolvedCrystallizationPlate, Object]], _String],
			LookupObjectLabel[currentSimulation, resolvedCrystallizationPlate],
		(* If the CrystallizationPlate is the same as ContainersIn and use has specified Name for ContainersIn, keep the name. *)
		And[
			MatchQ[resolvedPreparedPlate, True],
			MatchQ[resolvedCrystallizationPlate, ObjectP[Object[Container, Plate]]],
			MatchQ[Lookup[fetchPacketFromFastAssoc[resolvedCrystallizationPlate, fastAssoc], Name], _String]
		],
			Lookup[fetchPacketFromFastAssoc[resolvedCrystallizationPlate, fastAssoc], Name],
		And[
			MatchQ[resolvedPreparedPlate, True],
			MatchQ[resolvedCrystallizationPlate, ObjectP[Model[Container, Plate]]],
			MatchQ[Lookup[fetchPacketFromFastAssoc[First[DeleteDuplicates@Lookup[sampleContainerPackets, Object]], fastAssoc], Name], _String]
		],
			Lookup[fetchPacketFromFastAssoc[First[DeleteDuplicates@Lookup[sampleContainerPackets, Object]], fastAssoc], Name],
		(* If the CrystallizationPlate is the same as ContainersIn but user has not specified name. *)
		MatchQ[resolvedPreparedPlate, True],
			CreateUniqueLabel["Prepared Crystallization Plate", UserSpecifiedLabels -> userSpecifiedLabels],
		(* Otherwise, for unprepared plate, label it as "Crystallization Plate #". *)
		True,
			CreateUniqueLabel["Crystallization Plate", UserSpecifiedLabels -> userSpecifiedLabels]
	];

	(* Resolve CrystallizationCover option and create a model packet. *)
	resolvedCrystallizationCover = Which[
		MatchQ[suppliedCrystallizationCover, ObjectP[]],
			suppliedCrystallizationCover,
		(* Even if the samples are in a prepared plate, if user does not specify cover, we will recover it with crystal clear sealing film. *)
		True,
			Model[Item, PlateSeal, "id:8qZ1VWZNLJPp"](*"Crystal Clear Sealing Film"*)
	];

	(* Put the model information in a packet. *)
	resolvedCoverModelPacket = If[MatchQ[resolvedCrystallizationCover, ObjectP[Object[Item]]],
		fetchPacketFromFastAssoc[Download[fastAssocLookup[fastAssoc, resolvedCrystallizationCover, Model], Object], fastAssoc],
		fetchPacketFromFastAssoc[resolvedCrystallizationCover, fastAssoc]
	];

	(* Resolve DropSetterInstrument option and create a model packet. *)
	resolvedDropSetterInstrument = Which[
		(* Is DropSetterInstrument specified by the user? *)
		MatchQ[suppliedDropSetterInstrument, ObjectP[]],
			suppliedDropSetterInstrument,
		(* Is this a prepared plate? If so, DropSetter should be Null. *)
		MatchQ[resolvedPreparedPlate, True],
			Null,
		(* Is the strategy Screening? If so, we use Echo to dispense nanoliter range of samples. *)
		MatchQ[resolvedCrystallizationStrategy, Screening],
			Model[Instrument, LiquidHandler, AcousticLiquidHandler, "id:o1k9jAGrz9MG"],(*Labcyte Echo 650*)
		(* Otherwise, we use Hamilton Super Star to dispense microliter range of samples. *)
		True,
			Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"](*Super STAR*)
	];

	(* Put the model information in a packet. *)
	resolvedDropSetterModelPacket = Which[
		MatchQ[resolvedDropSetterInstrument, ObjectP[Object[Instrument]]],
			fetchPacketFromFastAssoc[Download[fastAssocLookup[fastAssoc, resolvedDropSetterInstrument, Model], Object], fastAssoc],
		MatchQ[resolvedDropSetterInstrument, ObjectP[Model[Instrument]]],
			fetchPacketFromFastAssoc[resolvedDropSetterInstrument, fastAssoc],
		True,
			<||>
	];

	(* Resolve ReservoirDispensingInstrument option and create a model packet. *)
	resolvedReservoirDispensingInstrument = Which[
		(* Is ReservoirDispensingInstrument specified by the user? *)
		MatchQ[suppliedReservoirDispensingInstrument, ObjectP[]],
			suppliedReservoirDispensingInstrument,
		(* Is this a prepared plate? If so, ReservoirDispensingInstrument should be Null. *)
		MatchQ[resolvedPreparedPlate, True],
			Null,
		(* Is resolvedCrystallizationTechnique SittingDropVaporDiffusion? *)
		(* If DropSetter is also Hamilton LH, resolve to the same one for ReservoirDispensingInstrument. *)
		And[
			MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
			MatchQ[Lookup[resolvedDropSetterModelPacket, Type], Model[Instrument, LiquidHandler]]
		],
			resolvedDropSetterInstrument,
		(* If not, pick Super STAR. *)
		MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
			Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"], (*Super STAR*)
		(* ReservoirDispensingInstrument should be Null when we are using MicrobatchUnderOil or MicrobatchWithoutOil technique. *)
		True,
			Null
	];

	(* Put the model information in a packet. *)
	resolvedReservoirDispenserModelPacket = Which[
		MatchQ[resolvedReservoirDispensingInstrument, ObjectP[Object[Instrument]]],
			fetchPacketFromFastAssoc[Download[fastAssocLookup[fastAssoc, resolvedReservoirDispensingInstrument, Model], Object], fastAssoc],
		MatchQ[resolvedReservoirDispensingInstrument, ObjectP[Model[Instrument]]],
			fetchPacketFromFastAssoc[resolvedReservoirDispensingInstrument, fastAssoc],
		True,
			<||>
	];

	(* Resolve ImagingInstrument option and create a model packet. *)
	(* NOTE: We only have one model for now which is set at 4 C and capable of UVImaging and CrossPolarizedImaging. *)
	resolvedImager = If[MatchQ[suppliedImager, ObjectP[]],
		suppliedImager,
		Model[Instrument, CrystalIncubator, "id:6V0npvmnzzGG"](*"Formulatrix Rock Imager"*)
	];

	(* Put the model information in a packet. *)
	resolvedImagerModelPacket = If[MatchQ[resolvedImager, ObjectP[Object[Instrument]]],
		fetchPacketFromFastAssoc[Download[fastAssocLookup[fastAssoc, resolvedImager, Model], Object], fastAssoc],
		fetchPacketFromFastAssoc[resolvedImager, fastAssoc]
	];

	(* Resolve UVImaging option. *)
	resolvedUVImaging = Which[
		MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, UVImaging], BooleanP],
			Lookup[partiallyRoundedGrowCrystalOptions, UVImaging],
		(* Is the imager capable of UVImaging? *)
		!MemberQ[Lookup[resolvedImagerModelPacket, ImagingModes], UVImaging],
			False,
		(* Is the crystallization plate transparent for UV (240nm-320nm)? *)
		(* If the plate does not have information for MinTransparentWavelength, we assume it is not transparent to UV. *)
		MatchQ[Lookup[resolvedPlateModelPacket, MinTransparentWavelength], Alternatives[Null, GreaterP[260 Nanometer]]],
			False,
		(* Is the crystallization cover transparent for UV (240nm-320nm)? *)
		(* If there is no information about transparent wavelength from the model of cover, we assume it is not transparent. *)
		MatchQ[Lookup[resolvedCoverModelPacket, MinTransparentWavelength], Alternatives[Null, GreaterP[260 Nanometer]]],
			False,
		True,
			True
	];

	(* Resolve CrossPolarizedImaging option. *)
	resolvedCrossPolarizedImaging = Which[
		MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CrossPolarizedImaging], BooleanP],
			Lookup[partiallyRoundedGrowCrystalOptions, CrossPolarizedImaging],
		(* If CMU site, we do not support CrossPolarizedImage *)
		MatchQ[$Site, ObjectP[Object[Container, Site, "id:P5ZnEjZpRlK4"]]],(*"ECL-CMU"*)
			False,
		(* Is the imager capable of CrossPolarizedImaging? *)
		!MemberQ[Lookup[resolvedImagerModelPacket, ImagingModes], CrossPolarizedImaging],
			False,
		(* Otherwise *)
		True,
			True
	];

	(* Resolve MaxCrystallizationTime option. *)
	(* Most protein crystallization experiments are finished within 3 weeks. We default to 2 months before throwing away the crystallization plate. *)
	resolvedMaxCrystallizationTime = If[MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, MaxCrystallizationTime], TimeP],
		Lookup[partiallyRoundedGrowCrystalOptions, MaxCrystallizationTime],
		60 Day
	];

	(* Resolve CrystallizationPlateStorageCondition option. *)
	(* NOTE: We only have one model for now which is set at 4 C. *)
	resolvedCrystallizationPlateStorageCondition = If[MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CrystallizationPlateStorageCondition], ObjectP[Model[StorageCondition]]|SampleStorageTypeP|Disposal],
		Lookup[partiallyRoundedGrowCrystalOptions, CrystallizationPlateStorageCondition],
		CrystalIncubation
	];

	(* Gather the resolved options above together in a list. *)
	resolvedGeneralOptions = {
		PreparedPlate -> resolvedPreparedPlate,
		CrystallizationTechnique -> resolvedCrystallizationTechnique,
		CrystallizationStrategy -> resolvedCrystallizationStrategy,
		CrystallizationPlate -> resolvedCrystallizationPlate,
		CrystallizationPlateLabel -> resolvedCrystallizationPlateLabel,
		CrystallizationCover -> resolvedCrystallizationCover,
		DropSetterInstrument -> resolvedDropSetterInstrument,
		ReservoirDispensingInstrument -> resolvedReservoirDispensingInstrument,
		ImagingInstrument -> resolvedImager,
		UVImaging -> resolvedUVImaging,
		CrossPolarizedImaging -> resolvedCrossPolarizedImaging,
		MaxCrystallizationTime -> resolvedMaxCrystallizationTime,
		CrystallizationPlateStorageCondition -> resolvedCrystallizationPlateStorageCondition
	};

	(*--- CONFLICTING OPTIONS CHECKS I---*)

	(*--Feature flag check--*)
	(* If the $GrowCrystalPreparedOnly is set to True, no unprepared plate is accepted. *)
	preparedOnlyError = If[Not[gatherTests] && TrueQ[$GrowCrystalPreparedOnly] && MatchQ[resolvedPreparedPlate, False],
		Message[Error::GrowCrystalPreparationNotSupported];
		{resolvedPreparedPlate},
		{}
	];

	preparedOnlyTest = If[Not[gatherTests] && TrueQ[$GrowCrystalPreparedOnly],
		Test["PreparedPlate is not set to False while it is not yet supported:",
			resolvedPreparedPlate,
			False
		]
	];

	(*--Solid input check--*)
	(* If the CrystallizationPlate is not prepared, make sure all the samples are liquid. *)
	(* Get the sample packets from SimulatedSamples that are not liquid. *)
	nonLiquidSamplePackets = Select[samplePackets, Not[MatchQ[Lookup[#, State], Liquid]]&];

	(* Set solidInvalidInputs to the input objects whose states are Solid *)
	(* NOTE: We allow solid samples in a prepared CrystallizationPlate to be the input, in case user is just interested in imaging crystal samples with ImagingInstrument. *)
	nonLiquidInvalidInputs = If[MatchQ[nonLiquidSamplePackets, {}] || MatchQ[resolvedPreparedPlate, True],
		{},
		Lookup[nonLiquidSamplePackets, Object]
	];

	(*If there are invalid inputs and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid inputs*)
	If[Length[nonLiquidInvalidInputs]>0 && messagesQ,
		Message[Error::SolidSamplesUnsupported, ObjectToString[nonLiquidInvalidInputs, Cache -> cacheBall], ExperimentGrowCrystal]
	];

	(*If we are gathering tests, create a passing and/or failing test with the appropriate result*)
	nonLiquidTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[nonLiquidInvalidInputs, Cache -> cacheBall] <> " are liquid:", True, False]
			];

			passingTest = If[Length[nonLiquidInvalidInputs] == Length[simulatedSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputs, nonLiquidInvalidInputs], Cache -> cacheBall] <> " are liquid:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Error::ConflictingCrystallizationPlateWithTechnique *)
	(* CrystallizationPlate & CrystallizationTechnique conflict. *)
	(* If the resolved CrystallizationPlate is not compatible with the resolved CrystallizationTechnique, return the options that mismatch. *)
	conflictingCrystallizationTechniqueWithPlateErrors = If[
		And[
			MatchQ[resolvedPreparedPlate, False],
			!MemberQ[Lookup[resolvedPlateModelPacket, CompatibleCrystallizationTechniques], resolvedCrystallizationTechnique]
		],
		{{resolvedCrystallizationTechnique, resolvedCrystallizationPlate}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingCrystallizationTechniqueWithPlateErrors]>0 && messagesQ,
		Message[
			Error::ConflictingCrystallizationPlateWithTechnique,
			ToString[conflictingCrystallizationTechniqueWithPlateErrors[[All, 1]]],
			ObjectToString[conflictingCrystallizationTechniqueWithPlateErrors[[All, 2]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingCrystallizationTechniquePlateTest = If[gatherTests,
		Test["If CrystallizationStrategy specified, it must be one of the CompatibleCrystallizationTechniques of the specified CrystallizationPlate:",
			MatchQ[conflictingCrystallizationTechniqueWithPlateErrors, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingCrystallizationPlateWithInstrument *)
	(* CrystallizationPlate & Instruments(DropSetter/Imager) conflict. *)
	(* If the resolved CrystallizationPlate is too tall for instruments, return the options that mismatch. *)
	conflictingCrystallizationPlateWithInstrumentErrors =
	{
		If[And[
				MatchQ[resolvedPreparedPlate, False],
				MatchQ[Lookup[resolvedDropSetterModelPacket, Type], Model[Instrument, LiquidHandler, AcousticLiquidHandler]],
				MatchQ[Lookup[resolvedPlateModelPacket, Dimensions], {_, _, GreaterP[Lookup[resolvedDropSetterModelPacket, MaxPlateHeight]]}]
			],
			{resolvedCrystallizationPlate, resolvedDropSetterInstrument, Lookup[resolvedPlateModelPacket, Dimensions][[3]], Lookup[resolvedDropSetterModelPacket, MaxPlateHeight]},
			Nothing
		],
		If[And[
				MatchQ[resolvedPreparedPlate, False],
				!MatchQ[Lookup[resolvedPlateModelPacket, Dimensions] - Lookup[resolvedImagerModelPacket, MaxPlateDimensions], {LessP[0 Millimeter], LessP[0 Millimeter], LessP[0 Millimeter]}]
			],
			{resolvedCrystallizationPlate, resolvedImager, Lookup[resolvedPlateModelPacket, Dimensions], Lookup[resolvedImagerModelPacket, MaxPlateDimensions]},
			Nothing
		]
	};

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingCrystallizationPlateWithInstrumentErrors]>0 && messagesQ,
		Message[
			Error::ConflictingCrystallizationPlateWithInstrument,
			ObjectToString[conflictingCrystallizationPlateWithInstrumentErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingCrystallizationPlateWithInstrumentErrors[[All, 2]], Cache -> cacheBall],
			conflictingCrystallizationPlateWithInstrumentErrors[[All, 3]],
			conflictingCrystallizationPlateWithInstrumentErrors[[All, 4]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingCrystallizationPlateWithInstrumentTest = If[gatherTests,
		Test["If CrystallizationPlate is specified, its dimensions are equal or less than the MaxPlateDimensions of Imager and DropSetter:",
			MatchQ[conflictingCrystallizationPlateWithInstrumentErrors, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingDropSetterWithStrategy *)
	(* DropSetterInstrument & CrystallizationStrategy conflict. *)
	conflictingDropSetterWithStrategyErrors = If[
		Or[
			And[
				MatchQ[resolvedCrystallizationStrategy, Alternatives[Optimization, Preparation]],
				MatchQ[Lookup[resolvedDropSetterModelPacket, Type], Model[Instrument, LiquidHandler, AcousticLiquidHandler]]
			],
			And[
				MatchQ[resolvedCrystallizationStrategy, Screening],
				!MatchQ[Lookup[resolvedDropSetterModelPacket, Type], Model[Instrument, LiquidHandler, AcousticLiquidHandler]]
			]
		],
		{{resolvedDropSetterInstrument, resolvedCrystallizationStrategy}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingDropSetterWithStrategyErrors]>0 && messagesQ,
		Message[
			Error::ConflictingDropSetterWithStrategy,
			ObjectToString[conflictingDropSetterWithStrategyErrors[[All, 1]], Cache -> cacheBall],
			conflictingDropSetterWithStrategyErrors[[All, 2]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingDropSetterTest = If[gatherTests,
		Test["If DropSetterInstrument is specified, it matches the scale of the specified CrystallizationStrategy:",
			MatchQ[conflictingDropSetterWithStrategyErrors, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingReservoirDispenserWithTechnique *)
	(* ReservoirDispensingInstrument & CrystallizationTechnique conflict. *)
	(* If resolved sample preparation instrument and resolved CrystallizationTechnique mismatch. *)
	conflictingReservoirDispenserWithTechniqueErrors = If[
		And[
			MatchQ[resolvedReservoirDispensingInstrument, ObjectP[]],
			MatchQ[resolvedCrystallizationTechnique, MicrobatchUnderOil | MicrobatchWithoutOil]
		],
		{{resolvedReservoirDispensingInstrument, resolvedCrystallizationTechnique}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingReservoirDispenserWithTechniqueErrors]>0 && messagesQ,
		Message[
			Error::ConflictingReservoirDispenserWithTechnique,
			ObjectToString[conflictingReservoirDispenserWithTechniqueErrors[[All, 1]], Cache -> cacheBall],
			conflictingReservoirDispenserWithTechniqueErrors[[All, 2]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingReservoirDispenserTest = If[gatherTests,
		Test["If ReservoirDispensingInstrument is set only when CrystallizationTechnique is set to SittingDropVaporDiffusion:",
			MatchQ[conflictingReservoirDispenserWithTechniqueErrors, {}],
			True
		],
		Nothing
	];

	(* Error::ConflictingDropSetterWithReservoirDispenser *)
	(* DropSetterInstrument & ReservoirDispensingInstrument conflict. *)
	conflictingDropSetterWithReservoirDispenserErrors = If[
		And[
			MatchQ[resolvedPreparedPlate, False],
			MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
			MatchQ[Lookup[resolvedDropSetterModelPacket, Type], Model[Instrument, LiquidHandler]],
			!MatchQ[resolvedReservoirDispensingInstrument, ObjectP[resolvedDropSetterInstrument]]
		],
		{{resolvedDropSetterInstrument, resolvedReservoirDispensingInstrument}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingDropSetterWithReservoirDispenserErrors]>0 && messagesQ,
		Message[
			Error::ConflictingDropSetterWithReservoirDispenser,
			ObjectToString[conflictingDropSetterWithReservoirDispenserErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingDropSetterWithReservoirDispenserErrors[[All, 2]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingDropSetterWithReservoirDispenserTest = If[gatherTests,
		Test["If both DropSetterInstrument and ReservoirDispensingInstrument are specified as Robotic LiquidHandler, they are the same:",
			MatchQ[conflictingDropSetterWithReservoirDispenserErrors, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingUVImaging *)
	(* UVImaging & ImagingInstrument/CrystallizationPlate/CrystallizationCover conflict. *)
	conflictingUVImaging =
	{
		If[
			And[
				MatchQ[resolvedUVImaging, True],
				!MemberQ[Lookup[resolvedImagerModelPacket, ImagingModes], UVImaging]
			],
			{"ImagingInstrument", resolvedImager},
			Nothing
		],
		If[
			And[
				MatchQ[resolvedUVImaging, True],
				MatchQ[Lookup[resolvedPlateModelPacket, MinTransparentWavelength], Alternatives[Null, GreaterP[260 Nanometer]]]
			],
			{"CrystallizationPlate", resolvedCrystallizationPlate},
			Nothing
		],
		If[
			And[
				MatchQ[resolvedUVImaging, True],
				MatchQ[Lookup[resolvedCoverModelPacket, MinTransparentWavelength], Alternatives[Null, GreaterP[260 Nanometer]]]
			],
			{"CrystallizationCover", resolvedCrystallizationCover},
			Nothing
		]
	};

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingUVImaging]>0 && messagesQ,
		Message[
			Error::ConflictingUVImaging,
			conflictingUVImaging[[All, 1]],
			ObjectToString[conflictingUVImaging[[All, 2]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingUVImagingTest = If[gatherTests,
		Test["If UVImaging is True, the imager must be able to take UV images and the CrystallizationPlate and its cover are transparent to UV:",
			MatchQ[conflictingUVImaging, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingCrossPolarizedImaging *)
	(* CrossPolarizedImaging & ImagingInstrument conflict. *)
	(* Note: CMU RI1000 is the same model of instrument without polarizer module. We might update the instruemnt in the near future. Currently keeping them the same model. *)
	conflictingCrossPolarizedImaging = If[
		And[
			MatchQ[resolvedCrossPolarizedImaging, True],
			!MemberQ[Lookup[resolvedImagerModelPacket, ImagingModes], CrossPolarizedImaging] || MatchQ[$Site, ObjectP[Object[Container, Site, "id:P5ZnEjZpRlK4"]]]
		],
		{{resolvedImager}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingCrossPolarizedImaging]>0 && messagesQ,
		Message[
			Error::ConflictingCrossPolarizedImaging,
			ObjectToString[conflictingCrossPolarizedImaging[[All, 1]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingCrossPolarizedImagingTest = If[gatherTests,
		Test["If CrossPolarizedImaging is True, the imager must be able to take Cross Polarized images:",
			MatchQ[conflictingCrossPolarizedImaging, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingCrystallizationCoverWithContainer *)
	(* CrystallizationCover & CrystallizationPlate conflict. *)
	conflictingCoverContainerErrors = If[!MemberQ[Lookup[resolvedPlateModelPacket, CoverFootprints], Lookup[resolvedCoverModelPacket, CoverFootprint]],
		{{resolvedCrystallizationCover, resolvedCrystallizationPlate}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingCoverContainerErrors]>0 && messagesQ,
		Message[
			Error::ConflictingCrystallizationCoverWithContainer,
			ObjectToString[conflictingCoverContainerErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingCoverContainerErrors[[All, 2]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	coverTest = If[gatherTests,
		Test["The CrystallizationCover matches the CoverFootprints of CrystallizationPlate:",
			MatchQ[conflictingCoverContainerErrors, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingVisibleLightImaging *)
	(* CrystallizationCover/Plate conflicts with Imaging setting. *)
	conflictingVisibleLightImagingErrors = If[
		Or[
			MatchQ[Lookup[resolvedCoverModelPacket, Opaque], True],
			MatchQ[Lookup[resolvedPlateModelPacket, Opaque], True],
			(* PlateSeal and Plate must be clear to take images at VisibleLightImaging mode. *)
			(* Visible Light wavelength is 400nm-750nm *)
			And[
				!NullQ[Lookup[resolvedCoverModelPacket, MinTransparentWavelength]],
				MatchQ[Lookup[resolvedCoverModelPacket, MinTransparentWavelength], GreaterP[400 Nanometer]],
				MatchQ[Lookup[resolvedCoverModelPacket, MaxTransparentWavelength], LessP[750 Nanometer]]
			],
			And[
				!NullQ[Lookup[resolvedPlateModelPacket, MinTransparentWavelength]],
				MatchQ[Lookup[resolvedPlateModelPacket, MinTransparentWavelength], GreaterP[400 Nanometer]],
				MatchQ[Lookup[resolvedPlateModelPacket, MaxTransparentWavelength], LessP[750 Nanometer]]
			]
		],
		{{resolvedCrystallizationCover, resolvedCrystallizationPlate}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingVisibleLightImagingErrors]>0 && messagesQ,
		Message[
			Error::ConflictingVisibleLightImaging,
			ObjectToString[conflictingVisibleLightImagingErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingVisibleLightImagingErrors[[All, 2]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingVisibleLightImagingTest = If[gatherTests,
		Test["The CrystallizationCover and CrystallizationPlate are both not opaque:",
			MatchQ[conflictingVisibleLightImagingErrors, {}],
			True
		],
		Nothing
	];


	(* Error::InvalidInstrumentModels *)
	(* Check if the transfer instruments resolved are valid. *)
	(* Get the transfer instrument models that are not for liquid. *)
	invalidInstrumentModels = Lookup[
		Select[{resolvedDropSetterModelPacket, resolvedReservoirDispenserModelPacket}, (!MatchQ[Lookup[#, LiquidHandlerType], LiquidHandling] && !MatchQ[#, <||>])&],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[invalidInstrumentModels]>0 && messagesQ,
		Message[Error::InvalidInstrumentModels, ObjectToString[Lookup[invalidInstrumentModels, Object], Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidInstrumentModelsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidInstrumentModels] == 0,
				Nothing,
				Test["Our specified transfer instruments have models " <> ObjectToString[Lookup[invalidInstrumentModels, Object], Cache -> cacheBall] <> " that supporting liquid handling:", True, False]
			];

			passingTest = If[Length[invalidInstrumentModels] == Length[Cases[{resolvedDropSetterInstrument, resolvedReservoirDispensingInstrument}, ObjectP[]]],
				Nothing,
				Test["Our specified transfer instruments have models " <> ObjectToString[Complement[Cases[{resolvedDropSetterInstrument, resolvedReservoirDispensingInstrument}, ObjectP[]], invalidInstrumentModels], Cache -> cacheBall] <> " that supporting liquid handling:", True, True]
			];

			(* Return our created tests. *)
			{failingTest, passingTest}
		],

		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::InvalidPlateSample *)
	(* The contents in a prepared plate must be included as samples. *)
	(* There should be no contents in a CrystallizationPlate if PreparedPlate is set to False. *)
	plateInvalidSampleInputs = Which[
		MatchQ[resolvedPreparedPlate, True],
			Complement[DeleteDuplicates@Download[Cases[Flatten@Lookup[sampleContainerPackets, Contents], ObjectP[]], Object], simulatedSamples],
		MatchQ[resolvedPreparedPlate, False] && MatchQ[resolvedCrystallizationPlate, ObjectP[Object[Container]]],
			Download[Cases[Flatten@Lookup[fetchPacketFromCache[resolvedCrystallizationPlate, cacheBall], Contents], ObjectP[]], Object],
		True,
			{}
	];

	(* Throw error if the prepared plate check is false. *)
	If[Length[plateInvalidSampleInputs]>0 && messagesQ,
		Message[
			Error::InvalidPlateSample,
			ObjectToString[plateInvalidSampleInputs, Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create a test for a prepared plate error. *)
	validPlateSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			passingTest = If[Length[plateInvalidSampleInputs] == 0,
				Test["Our input samples " <> ObjectToString[simulatedSamples, Cache -> cacheBall] <> " include everything for final CrystallizationPlate:", True, True],
				Nothing
			];

			failingTest = If[Length[plateInvalidSampleInputs] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[plateInvalidSampleInputs, Cache -> cacheBall] <> " are not included in our input samples but are found in the CrystallizationPlate:", True, False]
			];

			{failingTest, passingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingPreparedPlateInstrument *)
	(* PreparedPlate & DropSetterInstrument/ReservoirDispensingInstrument conflict. *)
	conflictingPreparedPlateWithInstrumentErrors =
	{
		(* If there is a drop setter or reservoir dispensing instrument and PreparedPlate is True, return the options that mismatch. *)
		If[
			MatchQ[resolvedDropSetterInstrument, ObjectP[]] && MatchQ[resolvedPreparedPlate, True],
			{"DropSetterInstrument", resolvedDropSetterInstrument, resolvedPreparedPlate},
			Nothing
		],
		If[
			MatchQ[resolvedReservoirDispensingInstrument, ObjectP[]] && MatchQ[resolvedPreparedPlate, True],
			{"ReservoirDispensingInstrument", resolvedReservoirDispensingInstrument, resolvedPreparedPlate},
			Nothing
		],
		(* If there is no drop setter and PreparedPlate is False, return the options that mismatch. *)
		If[
			NullQ[resolvedDropSetterInstrument] && MatchQ[resolvedPreparedPlate, False],
			{"DropSetterInstrument", resolvedDropSetterInstrument, resolvedPreparedPlate},
			Nothing
		]
	};

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingPreparedPlateWithInstrumentErrors]>0 && messagesQ,
		Message[
			Error::ConflictingPreparedPlateWithInstrument,
			conflictingPreparedPlateWithInstrumentErrors[[All, 1]],
			ObjectToString[conflictingPreparedPlateWithInstrumentErrors[[All, 2]], Cache -> cacheBall],
			conflictingPreparedPlateWithInstrumentErrors[[All, 3]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingPreparedPlateInstrumentTest = If[gatherTests,
		Test["The drop setter and reservoir dispensing instruments are only specified when PreparedPlate is True:",
			MatchQ[conflictingPreparedPlateWithInstrumentErrors, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingPreparedPlateWithCrystallizationPlate *)
	(* PreparedPlate & CrystallizationPlate conflict. *)
	(* If there is a CrystallizationPlate specified which is different from the prepared plate, return the options that mismatch. *)
	conflictingPreparedPlateWithCrystallizationPlateErrors = If[
		And[
			MatchQ[resolvedPreparedPlate, True],
 			!MemberQ[Lookup[sampleContainerPackets, Object], ObjectP[resolvedCrystallizationPlate]]
		],
		{{resolvedPreparedPlate, resolvedCrystallizationPlate}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingPreparedPlateWithCrystallizationPlateErrors]>0 && !gatherTests,
		Message[
			Error::ConflictingPreparedPlateWithCrystallizationPlate,
			conflictingPreparedPlateWithCrystallizationPlateErrors[[All, 1]],
			ObjectToString[conflictingPreparedPlateWithCrystallizationPlateErrors[[All, 2]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingCrystallizationPlateTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingPreparedPlateWithCrystallizationPlateErrors]>0,
				Test["If a PreparedPlate specified, CrystallizationPlate should be the same container:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingPreparedPlateWithCrystallizationPlateErrors]>0,
				Test["If a PreparedPlate specified, CrystallizationPlate should be the same container:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(*--- INPUT VALIDATION CHECKS II ---*)

	(*--Too many samples check--*)
	(* Error::GrowCrystalTooManySamples *)
	(* Check if there are too many samples for resolvedCrystallizationPlate. *)
	tooManySamplesQ = If[MatchQ[resolvedPreparedPlate, False],
		Length[simulatedSamples] > numberOfDropWells,
		!SameQ@@Lookup[sampleContainerPackets, Object]
	];

	(* Set tooManySamplesInvalidInputs to all sample objects. *)
	tooManySamplesInvalidInputs = If[tooManySamplesQ,
		Lookup[samplePackets, Object],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[tooManySamplesInvalidInputs] > 0 && messagesQ,
		Message[Error::GrowCrystalTooManySamples]
	];

	(* If we are gathering tests, create a test for too many samples. *)
	tooManySamplesTest = If[gatherTests,
		Test["There are fewer input samples than the number of Drop wells of a single plate:",
			tooManySamplesQ,
			False
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];

	(*--Prepared plate checks--*)

	(* Error::InvalidPreparedPlateModel *)
	(* The prepared plate must contain all the samples and is compatible to crystallization. *)
	validPreparedPlateContainerQ = If[MatchQ[resolvedPreparedPlate, True],
		And[
			MatchQ[Lookup[sampleContainerPackets, Model], {ObjectP[Model[Container, Plate, Irregular, Crystallization]]..}],
			SameQ@@Lookup[sampleContainerPackets, Object]
		],
		True
	];

	(* If prepared plate test fails, treat all of the input samples as invalid. *)
	preparedPlateInvalidContainerInputs = If[!validPreparedPlateContainerQ,
		Lookup[samplePackets, Object],
		{}
	];

	(* Throw error if the prepared plate check is false. *)
	If[!validPreparedPlateContainerQ && messagesQ,
		Message[
			Error::InvalidPreparedPlateModel,
			ObjectToString[preparedPlateInvalidContainerInputs, Cache -> cacheBall],
			ObjectToString[DeleteDuplicates[Lookup[sampleContainerPackets, Object]], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create a test for a prepared plate error. *)
	validPreparedPlateContainerTest = If[gatherTests,
		Test["When using a prepared plate, the input samples are all in the same Model[Container, Plate, Irregular, Crystallization] crystallization plate:",
			validPreparedPlateContainerQ,
			True
		],
		Nothing
	];


	(* Error::InvalidPreparedPlateVolume *)
	(* All the drop samples in a prepared plate should have volume information if they are liquid and the value should be less than the MaxVolumes of the container. *)
	(* NOTE: We don't care about the reservoir wells for prepared plate since we are not imaging reservoir wells during storage. *)
	preparedPlateInvalidVolumeInputs = Module[
		{sampleVolumeToPositionList, checkDropWell, dropSampleToVolumeToList},

		(* Associate sample to its Volume and Position if it is liquid. *)
		sampleVolumeToPositionList = If[!MatchQ[Lookup[samplePackets, Volume], {}] && !MatchQ[Lookup[samplePackets, Position], {}],
			MapThread[
				If[MatchQ[#4, Liquid],
					{#1, #2, #3},
					Nothing
				]&,
				{Lookup[samplePackets, Object], Lookup[samplePackets, Volume], Lookup[samplePackets, Position], Lookup[samplePackets, State]}
			],
			{}
		];
		(* Helper function to extract Volume and Position from sampleVolumeToPositionList if the sample is in drop well. *)
		checkDropWell[{sample:ObjectP[], volume:_Quantity, position:_String}] := If[MatchQ[resolvedPreparedPlate, True] && !StringContainsQ[position, "Reservoir"],
			{sample, volume},
			Nothing
		];
		dropSampleToVolumeToList = If[!MatchQ[sampleVolumeToPositionList, {}],
			checkDropWell[#]& /@ sampleVolumeToPositionList,
			{}
		];
		Which[
			MatchQ[resolvedPreparedPlate, False],
				{},
			(* All liquid prepared samples should have volume. *)
			!MatchQ[sampleVolumeToPositionList, {}] && MemberQ[dropSampleToVolumeToList[[All, 2]], Null],
				PickList[dropSampleToVolumeToList, NullQ& /@dropSampleToVolumeToList[[All, 2]], True],
			(* All liquid prepared samples should be LessEqual to the max volume of the plate. *)
			MemberQ[dropSampleToVolumeToList[[All, 2]], GreaterP[maxResolvedPlateDropVolume]],
				PickList[dropSampleToVolumeToList, GreaterQ[#, maxResolvedPlateDropVolume]& /@dropSampleToVolumeToList[[All, 2]], True],
			True,
				{}
		]
	];

	(* Throw error if the prepared plate check is false. *)
	If[Length[preparedPlateInvalidVolumeInputs]>0 && messagesQ,
		Message[
			Error::InvalidPreparedPlateVolume,
			ObjectToString[preparedPlateInvalidVolumeInputs[[All, 1]], Cache -> cacheBall],
			ToString[preparedPlateInvalidVolumeInputs[[All, 2]]],
			maxResolvedPlateDropVolume
		]
	];

	(* If we are gathering tests, create a test for a prepared plate error. *)
	validPreparedPlateVolumeTest = If[gatherTests && Length[preparedPlateInvalidVolumeInputs]>0,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[preparedPlateInvalidVolumeInputs] == 0,
				Test["When using a prepared plate, all the input samples have volume less equal than the MaxVolume of the plate:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[preparedPlateInvalidVolumeInputs]>0,
				Test["When using a prepared plate, the input samples " <> ObjectToString[preparedPlateInvalidVolumeInputs[[All, 1]], Cache -> cacheBall] <> " are not in the range of 0 to MaxVolume of the plate:",
					True,
					False
				],
				Nothing
			];

			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(*--- RESOLVE INDEXMATCHING OPTIONS ---*)

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentGrowCrystal, partiallyRoundedGrowCrystalOptions];
	(* Resolve our map thread options. *)
	{
		(*1*)resolvedCrystallizationScreeningMethod,
		(*2*)resolvedSampleVolumes,
		(*3*)resolvedReservoirBuffers,
		(*4*)resolvedReservoirBufferVolume,
		(*5*)resolvedReservoirDropVolume,
		(*6*)resolvedDilutionBuffer,
		(*7*)resolvedDilutionBufferVolume,
		(*8*)resolvedAdditives,
		(*9*)resolvedAdditiveVolume,
		(*10*)resolvedCoCrystallizationReagents,
		(*11*)resolvedCoCrystallizationReagentVolume,
		(*12*)resolvedCoCrystallizationAirDry,
		(*13*)resolvedSeedingSolution,
		(*14*)resolvedSeedingSolutionVolume,
		(*15*)resolvedOil,
		(*16*)resolvedOilVolume,
		(*17*)resolvedDropSamplesOutLabel,
		(*18*)resolvedReservoirSamplesOutLabel,
		(*19*)resolvedDropDestination,
		(*20*)indexedNumberOfSubdivisions,
		(*21*)indexedDropDestinationCheck,
		(*22*)indexedSamplesOutLabelingCheck,
		(*23*)preMixRequired,
		(*24*)preMixWithSampleRequired,
		(*25*)partiallyResolvedTransferTable,
		(*26*)indexedDropLabelToConditionAssociations,
		(*27*)indexedNoDuplicatedBufferCheck,
		(*28*)indexedTransferCheck
	} = Transpose@MapThread[
		Function[
			{
				simulatedSampleObject,
				originalInputSampleObject,
				samplePacket,
				options,
				index
			},
			Module[
				{
					(* I:Crystallization conditions/recipe *)
					preparedPosition, matchedCrystallizationScreeningMethod, matchedSampleVolumes, matchedReservoirBuffers,
					matchedReservoirBufferVolume, matchedReservoirDropVolume, matchedDilutionBuffer, matchedDilutionBufferVolume,
					matchedAdditives, matchedAdditiveVolume, matchedCoCrystallizationReagents, matchedCoCrystallizationReagentVolume,
					matchedCoCrystallizationAirDry, matchedSeedingSolution, matchedSeedingSolutionVolume, matchedOil, matchedOilVolume,
					internalNoDuplicatedBuffersPass,
					(* II:CrystallizationPlate configuration *)
					tuplesOfCrystallizationConditions, tuplesOfCrystallizationConditionsWithoutReservoirBuffers,
					totalNumberOfCrystallizationConditions, totalNumberOfDropsPerSubdivision, totalNumberOfSubdivisions,
					dropDestination, internalDropDestinationPass,
					(* III: input and output sample labels *)
					dropSamplesOutLabel, reservoirSamplesOutLabel, dropLabelToPlateConfiguration, expandedReservoirLabels,
					dropLabelAndConditionLists, dropLabelToConditionAssociations, dropLabelsGroupedBySampleVolume, internalLabelingPass,
					(* IV: TransferTable and BufferPreparationTable *)
					transferQ, matchedStep2TransferTable, matchedStep4TransferTable, matchedTransferTable,
					nonEmptyBufferObjectDropVolumeRules, nonEmptyBufferTypeDropVolumeRules, bufferTypeToBufferVolumeAssoc,
					bufferTypeToBufferObjectsAssoc, matchedStep3PreMixQ, matchedStep3PreMixWithSampleQ

				},

				(*-----------------------------------------------------I------------------------------------------------------*)
				(* Resolve Crystallization conditions/recipe *)

				(* If the simulatedSampleObject if from a prepared plate, extract the position on the prepared plate. *)
				(* Position information is needed for resolving SampleVolumes, DropDestination and DropSamplesOutLabel. *)
				preparedPosition = If[MatchQ[resolvedPreparedPlate, True] && !MatchQ[Lookup[samplePacket, Position], {}],
					Lookup[samplePacket, Position],
					Null
				];

				(* Resolve the CrystallizationScreeningMethod option. *)
				matchedCrystallizationScreeningMethod = Module[{sampleAnalytesPacket, sampleComponentPacket},
					(* Pull out packets containing the Analytes and Composition of the input sample. *)
					sampleAnalytesPacket = If[MatchQ[resolvedPreparedPlate, False],
						Select[fetchPacketFromCache[#, sampleAnalytesPackets]& /@ Download[Lookup[fetchPacketFromCache[simulatedSampleObject, samplePackets], Analytes], Object], AssociationQ],
						{}
					];
					sampleComponentPacket = If[MatchQ[resolvedPreparedPlate, False],
						Select[fetchPacketFromCache[#, sampleComponentPackets]& /@ Download[Lookup[fetchPacketFromCache[simulatedSampleObject, samplePackets], Composition][[All, 2]], Object], AssociationQ],
						{}
					];
					Which[
						(* Is CrystallizationScreeningMethod specified by the user? *)
						MatchQ[Lookup[options, CrystallizationScreeningMethod], Except[Automatic]],
							Lookup[options, CrystallizationScreeningMethod],
						(* Is resolvedPreparedPlate True? *)
						MatchQ[resolvedPreparedPlate, True],
							Null,
						(* Is ReservoirBuffers specified by the user? And there are at least two ReservoirBuffers to screen? *)
						(* Or has the user specified ReservoirDropVolume to be Null? *)
						Or[
							MatchQ[Lookup[options, ReservoirBuffers], {ObjectP[], ObjectP[]..}],
							NullQ[Lookup[options, ReservoirDropVolume]]
							],
							Custom,
						(* Is Additives specified by the user? And there are at least two Additives to screen? *)
						MatchQ[Lookup[options, Additives], {ObjectP[], ObjectP[]..}],
							Custom,
						(* Is CoCrystallizationReagents specified by the user? And there are at least two CoCrystallizationReagents to screen? *)
						MatchQ[Lookup[options, CoCrystallizationReagents], {ObjectP[], ObjectP[]..}],
							Custom,
						(* Is resolvedCrystallizationStrategy Preparation? *)
						MatchQ[resolvedCrystallizationStrategy, Preparation],
							None,
						(* Are ReservoirBuffers/Additives/CoCrystallizationReagents specified as None or a single object? *)
						Or[
							MatchQ[Lookup[options, ReservoirBuffers], {ObjectP[]}|None],
							MatchQ[Lookup[options, Additives], {ObjectP[]}|None],
							MatchQ[Lookup[options, CoCrystallizationReagents], {ObjectP[]}|None]
						],
							None,
						(* Has the user populated Analytes of the sample? *)
						MatchQ[Lookup[sampleAnalytesPacket, Object], {ObjectP[]..}],
							Which[
								(* Is the Analytes of sample biological macromolecule? *)
								(* If we want to get crystals of protein complexes or DNA RNA complexes, use Hampton Research MembFac HT Screen (96 conditions). *)
								(* or Crystal Screen Lite(48 conditions). *)
								MemberQ[Lookup[sampleAnalytesPacket, Type], Model[Molecule, Protein]|Model[Molecule, Oligomer]],
									If[MatchQ[resolvedCrystallizationStrategy, Screening],
										(* MembFac HT contains all 48 reagents from MembFac and reagents 1-48 from Crystal Screen Lite *)
										Object[Method, CrystallizationScreening, "id:D8KAEvKJrW3l"],(*"Hampton Research MembFac HT Screen"*)
										(* Crystal Screen Lite is a sparse matrix of trial crystallization reagent conditions based upon the Crystal Screen(TM). The primary screen variables are salt, pH, and precipitant (salts, polymers, volatile organics, and non-volatile organics)*)
										Object[Method, CrystallizationScreening, "id:rea9jlaDMNap"](*"Hampton Research Crystal Screen Lite"*)
									],
								(* Is the Analytes of sample monoclonal antibody? *)
								MemberQ[Lookup[sampleAnalytesPacket, Type], Model[Molecule, Protein, Antibody]],
									If[MatchQ[resolvedCrystallizationStrategy, Screening],
										(* Generally Recognized As Safe (GRAS) screen formulation is based on data mining databases such as the Protein Data Bank (PDB), and Hampton Research data and input from academic and pharma colleagues. The primary crystallization reagents in GRAS Screen 2 are Polyethylene glycol versus 24 unique secondary salts, sampling pH 4 to 9 without an added buffer. *)
										Object[Method, CrystallizationScreening, "id:n0k9mGkmxKnk"],(*Hampton Research GRAS Screen 2*)
										Object[Method, CrystallizationScreening, "id:rea9jlaDMNap"](*"Hampton Research Crystal Screen Lite"*)
									],
								(* Otherwise *)
								True,
									If[MatchQ[resolvedCrystallizationStrategy, Screening],
										(* Salt screen evaluates a broad portfolio of crystallization salts of varying concentration and pH. *)
										(* SaltRx 1 containers reagents 1-48 from SaltRx HT. *)
										Object[Method, CrystallizationScreening, "id:Z1lqpMl96G50"],(*"Hampton Research SaltRX HT Screen"*)
										Object[Method, CrystallizationScreening, "id:Vrbp1jbPEJ7m"](*"Hampton Research SaltRx 1 Screen"*)
									]
								],
						(* Does sample composition field give hints of Analytes? *)
						MatchQ[Lookup[sampleComponentPacket, Object], {ObjectP[]..}],
							Which[
								MemberQ[Lookup[sampleComponentPacket, Type], Model[Molecule, Protein]|Model[Molecule, Oligomer]],
									If[MatchQ[resolvedCrystallizationStrategy, Screening],
										Object[Method, CrystallizationScreening, "id:D8KAEvKJrW3l"],(*"Hampton Research MembFac HT Screen"*)
										Object[Method, CrystallizationScreening, "id:rea9jlaDMNap"](*"Hampton Research Crystal Screen Lite"*)
									],
								(* Does compositions consist of monoclonal antibody? *)
								MemberQ[Lookup[sampleComponentPacket, Type], Model[Molecule, Protein, Antibody]],
									If[MatchQ[resolvedCrystallizationStrategy, Screening],
										Object[Method, CrystallizationScreening, "id:n0k9mGkmxKnk"],(*Hampton Research GRAS Screen 2*)
										Object[Method, CrystallizationScreening, "id:rea9jlaDMNap"](*"Hampton Research Crystal Screen Lite"*)
									],
								(* Otherwise *)
								True,
									If[MatchQ[resolvedCrystallizationStrategy, Screening],
										Object[Method, CrystallizationScreening, "id:Z1lqpMl96G50"],(*"Hampton Research SaltRX HT Screen"*)
										Object[Method, CrystallizationScreening, "id:Vrbp1jbPEJ7m"](*"Hampton Research SaltRx 1 Screen"*)
									]
							],
						(* Otherwise *)
						True,
							If[MatchQ[resolvedCrystallizationStrategy, Screening],
								Object[Method, CrystallizationScreening, "id:Z1lqpMl96G50"],(*"Hampton Research SaltRX HT Screen"*)
								Object[Method, CrystallizationScreening, "id:Vrbp1jbPEJ7m"](*"Hampton Research SaltRx 1 Screen"*)
							]
					]
				];

				(* Resolve the SampleVolumes option. *)
				matchedSampleVolumes = Which[
					MatchQ[Lookup[options, SampleVolumes], {VolumeP..}],
						Which[
							(* Round ths SampleVolumes based on the precision of DropSetterInstrument. *)
							(* Avoid Round volume to 0 by using SafeRound option AvoidZero -> True. *)
							(* SafeRound is what RoundOptionPrecision used. *)
							(* Warning will be thrown after MapThread in Option Precision II block. *)
							MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
								SafeRound[Lookup[options, SampleVolumes], $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							MatchQ[resolvedDropSetterInstrument, ObjectP[]],
								SafeRound[Lookup[options, SampleVolumes], $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							(* When there is no DropSetter(a prepared plate), we don't round the SampleVolumes specified by the user. *)
							True,
								Lookup[options, SampleVolumes]
						],
					(* Is SampleVolumes specified by the user as Null? *)
					MatchQ[Lookup[options, SampleVolumes], Null],
						Null,
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						(* Is this simulatedSampleObjec a DropSamplesOut? *)
						Which[
							(*NOTE: We don't care about reservoir samples since we won't monitor them. Set their volumes to Null. *)
							StringContainsQ[preparedPosition, "Reservoir"],
								Null,
							(* For solid DropSample, set SampleVolume as Null. *)
							NullQ[Lookup[samplePacket, Volume]],
								Null,
							True,
								{Lookup[samplePacket, Volume]}
						],
					(* Has user specified SampleVolumes for other inputs? If so, use the minimum value. *)
					!NullQ[minSuppliedSampleVolume],
						(* Round ths SampleVolumes based on the precision DropSetterInstrument *)
						(* Warning will be thrown after MapThread *)
						If[MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
							{SafeRound[minSuppliedSampleVolume, $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True]},
							{SafeRound[minSuppliedSampleVolume, $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True]}
						],
					(* Otherwise *)
					True,
						(* Default to 200 Nanoliter if CrystallizationStrategy is Screening, and 2 Microliter otherwise. *)
						If[MatchQ[resolvedCrystallizationStrategy, Screening],
							{200 Nanoliter},
							{2 Microliter}
						]
				];

				(* Resolve the ReservoirBuffers option. *)
				matchedReservoirBuffers = Which[
					(* Is ReservoirBuffers specified by the user? *)
					MatchQ[Lookup[options, ReservoirBuffers], Except[Automatic]],
						Lookup[options, ReservoirBuffers],
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						Null,
					(* Is matchedCrystallizationScreeningMethod Populated? *)
					MatchQ[matchedCrystallizationScreeningMethod, ObjectP[]],
						If[Length[Download[fastAssocLookup[fastAssoc, matchedCrystallizationScreeningMethod, ReservoirBuffers], Object]]>0,
							Download[fastAssocLookup[fastAssoc, matchedCrystallizationScreeningMethod, ReservoirBuffers], Object],
							Null
						],
					(* Otherwise *)
					True,
						{Model[Sample, StockSolution, "id:n0k9mG8Bx7kW"]}(*"300mM Sodium Chloride"*)
				];

				(* Resolve the ReservoirBufferVolume option. *)
				matchedReservoirBufferVolume = Which[
					(* Is ReservoirBufferVolume specified by the user? *)
					MatchQ[Lookup[options, ReservoirBufferVolume], Except[Automatic]],
						Lookup[options, ReservoirBufferVolume],
					(* Is resolvedCrystallizationTechnique SittingDropVaporDiffusion? *)
					!MatchQ[matchedReservoirBuffers, Null|None] && MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
						(* Default to 20 Microliter if CrystallizationStrategy is Screening, and 200 Microliter otherwise. *)
						If[MatchQ[resolvedCrystallizationStrategy, Screening],
							Min[maxResolvedPlateReservoirVolume, 20 Microliter],
							Min[maxResolvedPlateReservoirVolume, 200 Microliter]
						],
					(* Otherwise *)
					True,
						Null
				];

				(* Resolve the ReservoirDropVolume option. *)
				matchedReservoirDropVolume = Which[
					(* Is ReservoirDropVolume specified by the user as a Volume? *)
					(* Round user-specified volume and Warning will be thrown after MapThread *)
					MatchQ[Lookup[options, ReservoirDropVolume], VolumeP],
						Which[
							MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
								SafeRound[Lookup[options, ReservoirDropVolume], $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							MatchQ[resolvedDropSetterInstrument, ObjectP[]],
								SafeRound[Lookup[options, ReservoirDropVolume], $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							(* If there is no DropSetter, we don't round the volume. *)
							True,
								Lookup[options, ReservoirDropVolume]
						],
					(* Is ReservoirDropVolume specified by the user as Null? *)
					MatchQ[Lookup[options, ReservoirDropVolume], Null],
						Null,
					(* Is ReservoirBuffers populated? *)
					!MatchQ[matchedReservoirBuffers, Null|None],
						(* Default to 200 Nanoliter if CrystallizationStrategy is Screening, and 2 Microliter otherwise. *)
						If[MatchQ[resolvedCrystallizationStrategy, Screening],
							200 Nanoliter,
							2 Microliter
						],
					(* Otherwise *)
					True,
						Null
				];

				(* Resolve the DilutionBuffer option. *)
				matchedDilutionBuffer = Which[
					MatchQ[Lookup[options, DilutionBuffer], Except[Automatic]],
						Lookup[options, DilutionBuffer],
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						Null,
					True,
						None
				];

				(* Resolve the ReservoirDropVolume option. *)
				matchedDilutionBufferVolume = Which[
					(* Is ReservoirDropVolume specified by the user as a volume? *)
					MatchQ[Lookup[options, DilutionBufferVolume], VolumeP],
						Which[
							MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
								SafeRound[Lookup[options, DilutionBufferVolume], $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							MatchQ[resolvedDropSetterInstrument, ObjectP[]],
								SafeRound[Lookup[options, DilutionBufferVolume], $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							(* If there is no DropSetter, we don't round the volume. *)
							True,
								Lookup[options, DilutionBufferVolume]
						],
					(* Is ReservoirDropVolume specified by the user as Null? *)
					NullQ[Lookup[options, DilutionBufferVolume]],
						Null,
					(* Is DilutionBuffer populated? *)
					MatchQ[matchedDilutionBuffer, ObjectP[]],
						(* Default to 100 Nanoliter if CrystallizationStrategy is Screening, and 1 Microliter otherwise. *)
						If[MatchQ[resolvedCrystallizationStrategy, Screening],
							100 Nanoliter,
							1 Microliter
						],
					(* Otherwise *)
					True,
						Null
				];

				(* Resolve the Additives option. *)
				matchedAdditives = Which[
					(* Is Additives specified by the user? *)
					MatchQ[Lookup[options, Additives], Except[Automatic]],
						Lookup[options, Additives],
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						Null,
					(* Is matchedCrystallizationScreeningMethod Populated? *)
					MatchQ[matchedCrystallizationScreeningMethod, ObjectP[]],
						If[Length[Download[fastAssocLookup[fastAssoc, matchedCrystallizationScreeningMethod, Additives], Object]]>0,
							Download[fastAssocLookup[fastAssoc, matchedCrystallizationScreeningMethod, Additives], Object],
							Null
						],
					(* Otherwise *)
					True,
						None
				];

				(* Resolve the AdditiveVolume option. *)
				matchedAdditiveVolume = Which[
					(* Is AdditiveVolume specified by the user? *)
					MatchQ[Lookup[options, AdditiveVolume], VolumeP],
						Which[
							MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
								SafeRound[Lookup[options, AdditiveVolume], $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							MatchQ[resolvedDropSetterInstrument, ObjectP[]],
								SafeRound[Lookup[options, AdditiveVolume], $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							(* If there is no DropSetter, that means a PreparedPlate. A conflicting error is thrown. We don't round the volume. *)
							True,
								Lookup[options, AdditiveVolume]
						],
					(* Is AdditiveVolume specified by the user as Null? *)
					NullQ[Lookup[options, AdditiveVolume]],
						Null,
					(* Is Additives populated? *)
					!MatchQ[matchedAdditives, Alternatives[Null, None]],
						(* Default to 50 Nanoliter if CrystallizationStrategy is Screening, and 500 Nanoliter otherwise. *)
						If[MatchQ[resolvedCrystallizationStrategy, Screening],
							50 Nanoliter,
							500 Nanoliter
						],
					(* Otherwise *)
					True,
						Null
				];

				(* Resolve the CoCrystallizationReagents option. *)
				matchedCoCrystallizationReagents = Which[
					(* Is CrystallizationReagents specified by the user? *)
					MatchQ[Lookup[options, CoCrystallizationReagents], Except[Automatic]],
						Lookup[options, CoCrystallizationReagents],
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						Null,
					(* Is matchedCrystallizationScreeningMethod Populated? *)
					MatchQ[matchedCrystallizationScreeningMethod, ObjectP[]],
						If[Length[Download[fastAssocLookup[fastAssoc, matchedCrystallizationScreeningMethod, CoCrystallizationReagents], Object]]>0,
							Download[fastAssocLookup[fastAssoc, matchedCrystallizationScreeningMethod, CoCrystallizationReagents], Object],
							Null
						],
					(* Otherwise *)
					True,
						None
				];

				(* Resolve the CoCrystallizationAirDry option. *)
				(* Samples can have a mix of CoCrystallizationAirDry True or False. *)
				(* However, CoCrystallizationAirDryTime/Temperature can only be one TimeP/TemperatureP since all samples share the CrystallizationPlate. *)
				(* Samples with CoCrystallizationAirDry True have step1:AirDryCoCrystallizationReagent, while others have CoCrystallizationReagents added at Step3:SetDrop. *)
				matchedCoCrystallizationAirDry = Which[
					MatchQ[Lookup[options, CoCrystallizationAirDry], BooleanP],
						Lookup[options, CoCrystallizationAirDry],
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						Null,
					(* Is resolvedCoCrystallizationReagents not populated? *)
					MatchQ[matchedCoCrystallizationReagents, Alternatives[Null, None]],
						Null,
					(* Is there user-specified coCrystallizationAirDryTime and only one input sample? *)
					MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CoCrystallizationAirDryTime], TimeP] && Length[myInputs] == 1,
						True,
					(* Is there user-specified coCrystallizationAirDryTemperature and only one input sample? *)
					MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CoCrystallizationAirDryTemperature], TemperatureP|Ambient] && Length[myInputs] == 1,
						True,
					(* Otherwise *)
					True,
						False
				];

				(* Resolve the CoCrystallizationReagentVolume option. *)
				matchedCoCrystallizationReagentVolume = Which[
					(* Is CoCrystallizationReagentVolume specified by the user as Volume? *)
					MatchQ[Lookup[options, CoCrystallizationReagentVolume], VolumeP],
						Which[
							(* When CoCrystallizationReagents are added in Step1:AirDryCoCrystallizationReagent, use CoCrystallizationReagentVolume to determine the rounding precision. *)
							MatchQ[matchedCoCrystallizationAirDry, True],
								If[GreaterEqualQ[Lookup[options, CoCrystallizationReagentVolume], $RoboticTransferVolumeThreshold],
									SafeRound[Lookup[options, CoCrystallizationReagentVolume], $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
									SafeRound[Lookup[options, CoCrystallizationReagentVolume], $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True]
								],
							(* When CoCrystallizationReagents are added in Step3:SetDrop, use the DropSetter's precision for rounding. *)
							MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
								SafeRound[Lookup[options, CoCrystallizationReagentVolume], $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							MatchQ[resolvedDropSetterInstrument, ObjectP[]],
								SafeRound[Lookup[options, CoCrystallizationReagentVolume], $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							(* If it is a PreparedPlate or no DropSetter, we don't round the volume. *)
							True,
								Lookup[options, CoCrystallizationReagentVolume]
						],
					(* Is CoCrystallizationReagentVolume specified by the user as Null? *)
					NullQ[Lookup[options, CoCrystallizationReagentVolume]],
						Null,
					(* Is CoCrystallizationReagents populated? *)
					!MatchQ[matchedCoCrystallizationReagents, Alternatives[Null, None]],
						(* Default to 50 Nanoliter if CrystallizationStrategy is Screening, and 500 Nanoliter otherwise. *)
						If[MatchQ[resolvedCrystallizationStrategy, Screening],
							50 Nanoliter,
							500 Nanoliter
						],
					(* Otherwise *)
					True,
						Null
				];

				(* Resolve the SeedingSolution option. *)
				matchedSeedingSolution = Which[
					MatchQ[Lookup[options, SeedingSolution], Except[Automatic]],
						Lookup[options, SeedingSolution],
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						Null,
					(* Otherwise *)
					True,
						None
				];

				(* Resolve the SeedingSolutionVolume option. *)
				matchedSeedingSolutionVolume = Which[
					(* Is SeedingSolutionVolume specified by the user as Volume? *)
					MatchQ[Lookup[options, SeedingSolutionVolume], VolumeP],
						Which[
							MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
								SafeRound[Lookup[options, SeedingSolutionVolume], $AcousticLiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							MatchQ[resolvedDropSetterInstrument, ObjectP[]],
								SafeRound[Lookup[options, SeedingSolutionVolume], $LiquidHandlerVolumeTransferPrecision, AvoidZero -> True],
							(* If there is no DropSetter, we don't round the volume. *)
							True,
								Lookup[options, SeedingSolutionVolume]
						],
					(* Is SeedingSolutionVolume specified by the user as Null? *)
					NullQ[Lookup[options, SeedingSolutionVolume]],
						Null,
					(* Is SeedingSolution populated? *)
					!MatchQ[matchedSeedingSolution, Alternatives[Null, None]],
					(* Default to 50 Nanoliter if CrystallizationStrategy is Screening, and 500 Nanoliter otherwise. *)
						If[MatchQ[resolvedCrystallizationStrategy, Screening],
							50 Nanoliter,
							500 Nanoliter
						],
					(* Otherwise *)
					True,
						Null
				];

				(* Resolve the Oil option. *)
				matchedOil = Which[
					MatchQ[Lookup[options, Oil], Except[Automatic]],
						Lookup[options, Oil],
					(* Is resolvedPreparedPlate True? *)
					MatchQ[resolvedPreparedPlate, True],
						Null,
					(* Is resolvedCrystallizationTechnique MicrobatchUnderOil? *)
					MatchQ[resolvedCrystallizationTechnique, MicrobatchUnderOil],
						Model[Sample, "id:kEJ9mqR8MnBe"], (*"Mineral Oil"*)
					True,
						Null
				];

				(* Resolve the OilVolume option. *)
				matchedOilVolume = Which[
					(* Is OilVolume specified by the user? *)
					MatchQ[Lookup[options, OilVolume], Except[Automatic]],
						Lookup[options, OilVolume],
					(* Is Oil populated? Default to 16 Microliter *)
					!NullQ[matchedOil],
						16 Microliter,
					(* Otherwise *)
					True,
						Null
				];

				(* For an unprepared plate, we check all the multiple options (ReservoirBuffers, CoCrystallizationReagents, Additives) *)
				(* to make sure no duplicate buffer exist within the option or two identical buffers exist across different options. *)
				(* If the user has specified Object[Sample] instead of Model[Sample], it is okay two buffers have the same Model but different Objects. *)
				internalNoDuplicatedBuffersPass = If[MatchQ[resolvedPreparedPlate, False],
					Module[{allBuffers, duplicatedBuffers},
						allBuffers = Select[Flatten@Join[{matchedDilutionBuffer, matchedSeedingSolution, matchedReservoirBuffers, matchedCoCrystallizationReagents, matchedAdditives}], MatchQ[#, ObjectP[]]&];
						duplicatedBuffers = Select[Tally[allBuffers], Last[#]>1&][[All, 1]];
						EqualQ[Length@duplicatedBuffers, 0]
					],
					True
				];

				(*--------------------------------------------------II--------------------------------------------------------*)
				(* After crystallization conditions/recipes are resolved, we determine the configuration of the plate. *)

				(* Determine the total number of drops and drop destination for constructing the crystallization plate. *)
				(* For a prepared plate or unprepared plate with Preparation CrystallizationStrategy, Length[tuplesOfCrystallizationConditions] is equal to 1. *)
				(* When there are multiple SampleVolumes, ReservoirBuffers, Additives, CoCrystallizationReagents provided, *)
				(* each option is combined with other options in a multiplexed manner to create a unique crystallization condition. *)
				(* For example, we have SampleVolumes 100nl&200nl, CoCrystallizationReagent CR1, CR2, CR3, Additives AD1&AD2, that is a total of 2X3X2 conditions. *)
				(* We generate DropSamplesOut in the order of 1:{100nl, CR1, AD1}, 2:{100nl, CR1, AD2}, 3:{100nl, CR2, AD1}, 4:{100nl, CR2, AD2}, *)
				(* 5:{100nl, CR3, AD1}, 6:{100nl, CR3, AD2}, 7:{200nl, CR1, AD1}, 8:{200nl, CR1, AD2}, 9:{200nl, CR2, AD1}, 10:{200nl, CR2, AD2} *)
				(* 11:{200nl, CR3, AD1}, 12:{200nl, CR3, AD2} and repeat for each ReservoirBuffer. *)
				tuplesOfCrystallizationConditionsWithoutReservoirBuffers = Tuples[{
					ToList@matchedDilutionBuffer,
					ToList@matchedSeedingSolution,
					ToList@matchedSampleVolumes,
					ToList@matchedCoCrystallizationReagents,
					ToList@matchedAdditives
				}];
				tuplesOfCrystallizationConditions = Tuples[{
					ToList@matchedDilutionBuffer, (*1*)
					ToList@matchedSeedingSolution, (*2*)
					ToList@matchedReservoirBuffers, (*3*)
					ToList@matchedSampleVolumes, (*4*)
					ToList@matchedCoCrystallizationReagents, (*5*)
					ToList@matchedAdditives(*6*)
				}];
				totalNumberOfCrystallizationConditions = Length[tuplesOfCrystallizationConditions];

				(* CrystallizationPlate is special since it can have headspace above the wells connecting wells in the same subdivision. *)
				(* Each subdivision may have multiple wells (one-to-many drop well(s) or 0-to-1 reservoir well). *)
				(* We pulled out that information from model plate to variable numberOfDropWellsPerSubdivision earlier. *)
				(* Wells in the same subdivision share the base name of well position, such as A1Drop1, A1Reservoir. *)
				(* For the above example, if totalNumberOfDropsPerSubdivision is 1, the 12 conditions are all in their own subdivision. *)
				(* For the above example, if totalNumberOfDropsPerSubdivision is 3, the 12 conditions are consolidated to 4 subdivisions. *)
				(* For the above example, if user has specified DropDestination as {Drop1, Drop2}, the 12 conditions are consolidated to 6 subdivisions. *)
				{totalNumberOfDropsPerSubdivision, totalNumberOfSubdivisions} = Which[
					(* If the sample is from a PreparedPlate, we don't need to transfer, set totalNumberOfDropsPerSubdivision & totalNumberOfSubdivisions to 1. *)
					MatchQ[resolvedPreparedPlate, True],
						{1, 1},
					(* Sample at different crystallization conditions using Microbatch technique should be put in non headspace sharing wells (A1Drop1, A2Drop1). *)
					MatchQ[resolvedCrystallizationTechnique, MicrobatchUnderOil|MicrobatchWithoutOil],
						{1, totalNumberOfCrystallizationConditions},
					(* Droplets with the same sample & reservoir buffer but multiple tuplesOfCrystallizationConditionsWithoutReservoirBuffers can be put in the same subdivision. *)
					(* Has user specified DropDestination? *)
					MatchQ[Lookup[options, DropDestination], {CrystallizationWellContentsP..}],
						If[LessEqualQ[Length[tuplesOfCrystallizationConditionsWithoutReservoirBuffers], Length[Lookup[options, DropDestination]]],
							{Length[tuplesOfCrystallizationConditionsWithoutReservoirBuffers], Length[ToList@matchedReservoirBuffers]},
							(* If there are more tuplesOfCrystallizationConditionsWithoutReservoirBuffers than the number of user specified DropDestinations, *)
							(* we need to split those conditions to several subdivisions. *)
							If[EqualQ[Mod[Length[tuplesOfCrystallizationConditionsWithoutReservoirBuffers], Length[Lookup[options, DropDestination]]], 0],
								{Length[Lookup[options, DropDestination]], totalNumberOfCrystallizationConditions/Length[Lookup[options, DropDestination]]},
								{1, totalNumberOfCrystallizationConditions}
							]
						],
					(* Otherwise *)
					True,
						If[LessEqualQ[Length[tuplesOfCrystallizationConditionsWithoutReservoirBuffers], numberOfDropWellsPerSubdivision],
							{Length[tuplesOfCrystallizationConditionsWithoutReservoirBuffers], Length[ToList@matchedReservoirBuffers]},
							(* If there are more tuplesOfCrystallizationConditionsWithoutReservoirBuffers than the numberOfDropWellsPerSubdivision, *)
							(* we need to split those conditions to several subdivisions. *)
							If[EqualQ[Mod[Length[tuplesOfCrystallizationConditionsWithoutReservoirBuffers], numberOfDropWellsPerSubdivision], 0],
								{numberOfDropWellsPerSubdivision, totalNumberOfCrystallizationConditions/numberOfDropWellsPerSubdivision},
								{1, totalNumberOfCrystallizationConditions}
								]
						]
				];

				(* Resolve DropDestination. *)
				dropDestination = Which[
					(* NOTE: All user specified DropDestinations should be occupied by crystallization conditions. *)
					(* For example, for a plate with WellContents:Drop1&Drop2, if there are 5 total Crystal conditions, *)
					(* the user can only assign DropSamplesOut to Drop1 or Drop2 instead of both. *)
					MatchQ[Lookup[options, DropDestination], Except[Automatic]],
						Lookup[options, DropDestination],
					(* Extract the WellContents of sample on PreparedPlate if it is in drop well. *)
					(* We still care about the prepared sample position since we want to monitor the prepared samples daily using imager. *)
					(* The format of WellContents is DropN (N is from 1 to 9). *)
					And[
						MatchQ[resolvedPreparedPlate, True],
						MatchQ[resolvedCrystallizationPlate, ObjectP[{Object[Container, Plate, Irregular, Crystallization], Model[Container, Plate, Irregular, Crystallization]}]],
						!StringContainsQ[preparedPosition, "Reservoir"]
					],
						If[StringContainsQ[preparedPosition, "Drop"],
							{ToExpression@StringTake[preparedPosition, -5]},
							(* If the plate is MicrobatchUnderOil plate where no reservoir well exists, set DropDestination to Drop1. *)
							{Drop1}
						],
					(* We don't care about reservoir buffer any more after plate preparation. Imager will only take images of drop wells. *)
					And[
						MatchQ[resolvedPreparedPlate, True],
						MatchQ[resolvedCrystallizationPlate, ObjectP[{Object[Container, Plate, Irregular, Crystallization], Model[Container, Plate, Irregular, Crystallization]}]],
						StringContainsQ[preparedPosition, "Reservoir"]
					],
						Null,
					(* If we are preparing samples, take the first totalNumberOfDropsPerSubdivision Drop wells as destination. *)
					(* If the plate is not a valid crystallization plate with well contents populated, set DropDestination to Drop1. *)
					True,
						Take[List@@CrystallizationWellContentsP, totalNumberOfDropsPerSubdivision]
				];

				internalDropDestinationPass = If[MatchQ[resolvedPreparedPlate, False],
					EqualQ[Length[dropDestination], totalNumberOfDropsPerSubdivision],
					True
				];

				(*--------------------------------------------------III---------------------------------------------------*)
				(* After We determine the configuration of the plate, we can determine the label and transfer sequences. *)

				(* Resolve DropSamplesOutLabel and ReservoirSamplesOutLabel. *)
				{dropSamplesOutLabel, reservoirSamplesOutLabel, dropLabelToPlateConfiguration} = Module[
					{sampleBase, subdivisionBase, dropDestinationBase, combinedDropOutLabel, combinedReservoirOutLabel, dropLabelToDropDestination},

					(* Decide the base name for SamplesOutLabel. *)
					sampleBase = If[MatchQ[resolvedPreparedPlate, False],
						CreateUniqueLabel["Crystallization Sample", UserSpecifiedLabels -> userSpecifiedLabels],
						resolvedCrystallizationPlateLabel
					];
					subdivisionBase = If[!MatchQ[resolvedPreparedPlate, True],
						StringJoin[" Headspace Group ", ToString[#]]& /@ Range[totalNumberOfSubdivisions],
						Null
					];
					dropDestinationBase = If[!MatchQ[resolvedPreparedPlate, True],
						StringJoin[" Drop Position ", ToString[#]]& /@ dropDestination,
						Null
					];
					(* For DropSamplesOut from prepared plate, naming example is "Prepared Crystallization Plate 1 Well A1Drop1 DropSamplesOut 1". *)
					(* While DropSamplesOut we are preparing has this label convention:sampleBase_subdivisionBase_dropDestinationBase_#. *)
					(* For example, "Crystallization Sample 122 Headspace Group 9 Drop Position 1 DropSamplesOut 1". *)
					combinedDropOutLabel = Which[
						MatchQ[Lookup[options, DropSamplesOutLabel], Except[Automatic]],
							Lookup[options, DropSamplesOutLabel],
						(* For plate with both Drop well and reservoir well: *)
						MatchQ[resolvedPreparedPlate, True] && StringContainsQ[preparedPosition, "Drop"] && MatchQ[Lookup[samplePacket, Name], _String],
							{Lookup[samplePacket, Name]},
						MatchQ[resolvedPreparedPlate, True] && StringContainsQ[preparedPosition, "Drop"],
							{CreateUniqueLabel[StringJoin[sampleBase, " Well ", preparedPosition, " DropSamplesOut"], UserSpecifiedLabels -> userSpecifiedLabels]},
						MatchQ[resolvedPreparedPlate, True] && StringContainsQ[preparedPosition, "Reservoir"],
							Null,
						(* For plate only with Drop well: *)
						MatchQ[resolvedPreparedPlate, True] && validPreparedPlateContainerQ && MatchQ[Lookup[samplePacket, Name], _String],
							{Lookup[samplePacket, Name]},
						MatchQ[resolvedPreparedPlate, True] && validPreparedPlateContainerQ,
							{CreateUniqueLabel[StringJoin[sampleBase, " Well ", preparedPosition, " DropSamplesOut"], UserSpecifiedLabels -> userSpecifiedLabels]},
						MatchQ[resolvedPreparedPlate, False],
							CreateUniqueLabel[StringJoin[sampleBase, Sequence@#, " DropSamplesOut"], UserSpecifiedLabels -> userSpecifiedLabels]& /@ Tuples[{subdivisionBase, dropDestinationBase}],
						True,
							{CreateUniqueLabel["Invalid Prepared Crystallization Plate SamplesOut", UserSpecifiedLabels -> userSpecifiedLabels]}
					];
					dropLabelToDropDestination = If[MatchQ[resolvedPreparedPlate, False] && EqualQ[Length@combinedDropOutLabel, Length[Tuples[{subdivisionBase, dropDestinationBase}]]],
						Module[{dropOutLabelToBases},
							dropOutLabelToBases = MapThread[
								#1 -> #2&,
								{combinedDropOutLabel, Tuples[{StringJoin[ToString[index], #]& /@ subdivisionBase, ToString[#]& /@ dropDestination}]}
							]
						],
						{}
					];

					(* For ReservoirSamplesOut from prepared plate, naming example is "PreparedPlate Sample Well A1Reservoir ReservoirSamples out 1". *)
					(* While ReservoirSamplesOut we are preparing has this label convention:sampleBase_subdivisionBase. *)
					(* For example, "Crystallization Sample 122 Headspace Group 9 ReservoirSamplesOut 1". *)
					combinedReservoirOutLabel = Which[
						MatchQ[Lookup[options, ReservoirSamplesOutLabel], Except[Automatic]],
							Lookup[options, ReservoirSamplesOutLabel],
						MatchQ[resolvedPreparedPlate, True] && StringContainsQ[preparedPosition, "Reservoir"] && MatchQ[Lookup[samplePacket, Name], _String],
							{Lookup[samplePacket, Name]},
						MatchQ[resolvedPreparedPlate, True] && StringContainsQ[preparedPosition, "Reservoir"],
							{CreateUniqueLabel[StringJoin[sampleBase, " Well ", preparedPosition, " ReservoirSamplesOut"], UserSpecifiedLabels -> userSpecifiedLabels]},
						MatchQ[resolvedPreparedPlate, True] && StringContainsQ[preparedPosition, "Drop"],
							Null,
						MatchQ[matchedReservoirBuffers, Alternatives[Null, None]],
							Null,
						!MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
							Null,
						MatchQ[resolvedPreparedPlate, False],
							CreateUniqueLabel[StringJoin[sampleBase, #, " ReservoirSamplesOut"], UserSpecifiedLabels -> userSpecifiedLabels]& /@ subdivisionBase,
						True,
							Null
					];

					{combinedDropOutLabel, combinedReservoirOutLabel, dropLabelToDropDestination}
				];


				(* We now map the SamplesOutLabel to the plate configuration, this information is needed to check sample preparation sequences. *)
				(* We first expand the ReservoirSamplesOutLabel so that each DropsSamplesOut have its matching ReservoirSamplesOut. *)
				(* If any label options has been specified wrongly, we won't throw an error within the MapThread but we won't calculate TransferTable. *)
				expandedReservoirLabels = Which[
					And[
						MatchQ[resolvedPreparedPlate, False],
						MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
						!NullQ[reservoirSamplesOutLabel],
						EqualQ[Length[dropSamplesOutLabel], Length[tuplesOfCrystallizationConditions]]
						],
						Flatten[PadRight[{#}, Length[tuplesOfCrystallizationConditions]/totalNumberOfSubdivisions, #]& /@ reservoirSamplesOutLabel],
					(* ReservoirSamplesOut can be Null for Microbatch techniques, in that case there is no ReservoirSamplesOutLabel. *)
					And[
						MatchQ[resolvedPreparedPlate, False],
						!MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
						NullQ[reservoirSamplesOutLabel],
						!NullQ[dropSamplesOutLabel],
						EqualQ[Length[dropSamplesOutLabel], Length[tuplesOfCrystallizationConditions]]
					],
						ConstantArray[Null, Length[dropSamplesOutLabel]],
					(* For prepared plate or when user has specified mismatched number of DropSamplesOutLabel, we set expandedReservoirLabels to Null. *)
					True,
						Null
				];
				dropLabelAndConditionLists = If[!MatchQ[expandedReservoirLabels, Null],
					Transpose[{dropSamplesOutLabel, tuplesOfCrystallizationConditions, expandedReservoirLabels}],
					(* For prepared plate, labeling conflicting and duplicated multiple buffer fields, we set dropLabelAndConditionLists to {}. *)
					{}
				];

				(* For labeling conflicting cases, we set internalLabelingPass to False. *)
				(* Error for any conflicting samplesout labeling is thrown after the MapThread. *)
				(* The format is {True/False, expectedNumberOfDropSamplesOutLabel, expectedNumberOfReservoirSamplesOutLabel} *)
				internalLabelingPass = If[MatchQ[resolvedPreparedPlate, False],
						{!MatchQ[expandedReservoirLabels, Null], Length[tuplesOfCrystallizationConditions], totalNumberOfSubdivisions},
					(* For a prepared plate, one and only one SamplesOutLabel should be specified. *)
					If[StringContainsQ[preparedPosition, "Reservoir"],
						{EqualQ[Length@reservoirSamplesOutLabel, 1] && NullQ[dropSamplesOutLabel], 0, 1},
						{EqualQ[Length@dropSamplesOutLabel, 1] && NullQ[reservoirSamplesOutLabel], 1, 0}
					]
				];

				(* We rearrange dropLabelAndConditionLists to a list of associations, with each element of tuples of crystallization conditions, *)
				(* as well as SamplesOutLabel as keys. Buffers in dropLabelToConditionAssociation are in the same order as how tuplesOfCrystallizationConditions is set up. *)
				(* For prepared plate and labeling conflicting cases, since dropLabelAndConditionLists is {}, dropLabelToConditionAssociations is also {}. *)
				dropLabelToConditionAssociations = Association[
						DropSampleOutLabel -> #[[1]],
					  PlateConfiguration -> Lookup[dropLabelToPlateConfiguration, #[[1]]],
						DilutionBuffer -> #[[2]][[1]],
						DilutionBufferVolume -> matchedDilutionBufferVolume,
						SeedingSolution -> #[[2]][[2]],
						SeedingSolutionVolume -> matchedSeedingSolutionVolume,
						ReservoirBuffer -> #[[2]][[3]],
						ReservoirDropVolume -> matchedReservoirDropVolume,
						Sample -> originalInputSampleObject,
						SampleVolume -> #[[2]][[4]],
						CoCrystallizationReagent -> #[[2]][[5]],
						CoCrystallizationReagentVolume -> matchedCoCrystallizationReagentVolume,
						CoCrystallizationAirDry -> matchedCoCrystallizationAirDry,
						Additive -> #[[2]][[6]],
						AdditiveVolume -> matchedAdditiveVolume,
						ReservoirSampleOutLabel -> #[[3]]
					]& /@ dropLabelAndConditionLists;

				(* Now we sort all the DropSamplesOutLabel based on the same SampleVolume. *)
				(* Sort the DropSamplesOutLabel so that conditions with the same SampleVolume stay in the same sublist. *)
				dropLabelsGroupedBySampleVolume = If[TrueQ[internalNoDuplicatedBuffersPass] && TrueQ[internalLabelingPass[[1]]],
					Lookup[Cases[dropLabelToConditionAssociations, KeyValuePattern[{SampleVolume -> #}]], DropSampleOutLabel]& /@ matchedSampleVolumes,
					{}
				];


				(*-----------------------------------------------------IV-----------------------------------------------------*)
				(* We will further organize the above information in a table(TransferTable) or two tables (BufferPreparationTable, TransferTable). *)
				(* All the premixing and aliquoting are recorded using BufferPreparationTable. *)
				(* We might need to premix buffers or transfer samples/buffers to Echo qualified SourcePlate prior adding them to final CrystallizationPlate. *)
				(* All the transfers to final CrystallizationPlate are recorded using TransferTable. *)
				(* There are four type of steps might be required for sample preparation. *)
				(* Step1:AirDryCoCrystallizationReagent, Step2:FillReservoir, Step3:SetDrop, Step4:CoverWithOil. *)
				(* Among them, step3 is required for all the experiments when PreparedPlate is False. *)

				(* We don't generate TransferTable if PreparedPlate is True or any internal checks fail. *)
				(* Errors for any conflicting options which set TransferQ to False for an unprepared plate are thrown after the MapThread. *)
				(* Here we check within the MapThread to determine whether we continue evaluating. *)
				transferQ = And[
					(* PreparedPlate *)
					MatchQ[resolvedPreparedPlate, False],
					(* Internal checks *)
					!NullQ[matchedSampleVolumes],
					TrueQ[internalNoDuplicatedBuffersPass],
					TrueQ[internalDropDestinationPass],
					TrueQ[internalLabelingPass[[1]]],
					(* Volume match checks *)
					Or[
						MatchQ[matchedDilutionBuffer, ObjectP[]] && MatchQ[matchedDilutionBufferVolume, VolumeP],
						MatchQ[matchedDilutionBuffer, Null|None] && MatchQ[matchedDilutionBufferVolume, Null]
					],
					Or[
						MatchQ[matchedSeedingSolution, ObjectP[]] && MatchQ[matchedSeedingSolutionVolume, VolumeP],
						MatchQ[matchedSeedingSolution, Null|None] && MatchQ[matchedSeedingSolutionVolume, Null]
					],
					Or[
						MatchQ[matchedReservoirBuffers, {ObjectP[]..}] && MatchQ[matchedReservoirBufferVolume, VolumeP],
						MatchQ[matchedReservoirBuffers, {ObjectP[]..}] && MatchQ[matchedReservoirDropVolume, VolumeP],
						MatchQ[matchedReservoirBuffers, Null|None] && MatchQ[matchedReservoirBufferVolume, Null] && MatchQ[matchedReservoirDropVolume, Null]
					],
					Or[
						MatchQ[matchedCoCrystallizationReagents, {ObjectP[]..}] && MatchQ[matchedCoCrystallizationReagentVolume, VolumeP],
						MatchQ[matchedCoCrystallizationReagents, Null|None] && MatchQ[matchedCoCrystallizationReagentVolume, Null]
					],
					Or[
						MatchQ[matchedAdditives, {ObjectP[]..}] && MatchQ[matchedAdditiveVolume, VolumeP],
						MatchQ[matchedAdditives, Null|None] && MatchQ[matchedAdditiveVolume, Null]
					],
					Or[
						MatchQ[matchedOil, ObjectP[]] && MatchQ[matchedOilVolume, VolumeP],
						MatchQ[matchedOil, Null] && MatchQ[matchedOilVolume, Null]
					],
					(* CoCrystallizationAirDryCheck *)
					Or[
						MatchQ[matchedCoCrystallizationAirDry, True] && MatchQ[matchedCoCrystallizationReagents, {ObjectP[]..}],
						!MatchQ[matchedCoCrystallizationAirDry, True]
					]
				];


				(* 2.Partially generate transfer sequences for step2: FillReservoir. *)
				(* The volume transfer for this step should be in the range of $RoboticTransferVolumeThreshold to $MaxCrystallizationPlateReservoirVolume, always use Hamilton. *)
				matchedStep2TransferTable = If[
					And[
						MatchQ[transferQ, True],
						MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
						!NullQ[matchedReservoirBufferVolume]
					],
					MapThread[
						{
							FillReservoir, (*Step*)
							LiquidHandling, (*TransferType*)
							#1, (*Sources*)
							matchedReservoirBufferVolume, (*TransferVolume*)
							Null,
							DeleteDuplicates@#2 (*ReservoirSamplesOutLabel*)
						}&,
						{matchedReservoirBuffers, Lookup[Cases[dropLabelToConditionAssociations, KeyValuePattern[{ReservoirBuffer -> #}]], ReservoirSampleOutLabel]& /@ matchedReservoirBuffers}],
					{Nothing}
				];


				(* 3.Generate transfer sequences for step3: SetDrop *)

				(* Determine bufferType to resolved buffer Volume/probability for one buffer to present in the final well for optimization problem later. *)
				(* Because buffer are transferred to final CrystallizationPlate in a multiplex manner, the probability of one BufferObject is 1/N, *)
				(* Where N is the number of total BufferObjects in the same BufferType. *)
				{bufferTypeToBufferVolumeAssoc, bufferTypeToBufferObjectsAssoc} = {
					<|
						DilutionBuffer -> matchedDilutionBufferVolume,
						SeedingSolution -> matchedSeedingSolutionVolume,
						CoCrystallizationReagent -> matchedCoCrystallizationReagentVolume,
						ReservoirBuffer -> matchedReservoirDropVolume,
						Additive -> matchedAdditiveVolume
					|>,
					<|
						DilutionBuffer -> {matchedDilutionBuffer},
						SeedingSolution -> {matchedSeedingSolution},
						CoCrystallizationReagent -> matchedCoCrystallizationReagents,
						ReservoirBuffer -> matchedReservoirBuffers,
						Additive -> matchedAdditives
					|>
				};

				(* Extract all the buffers and their volumes that need go to the drop well during Set Drop step of Sample Preparation. *)
				(* If the CoCrystallizationReagents are added to CrystallizationPlate in Step1:AirDryCoCrystallizationReagent, we don't add again here. *)
				nonEmptyBufferTypeDropVolumeRules = If[MatchQ[matchedCoCrystallizationAirDry, True],
					KeyDrop[DeleteCases[bufferTypeToBufferVolumeAssoc, Null], CoCrystallizationReagent],
					DeleteCases[bufferTypeToBufferVolumeAssoc, Null]
				];

				(* Flatten out multiple values for the same buffer type as a list of rules from Object to volume/DropSamplesOutLabel. *)
        nonEmptyBufferObjectDropVolumeRules = Flatten[
					MapThread[
							Function[{objectList, objectVolume},
								If[GreaterQ[Length[objectList], 1],
									(# -> objectVolume)& /@ objectList,
									{First@objectList -> objectVolume}
								]
							],
							{Lookup[bufferTypeToBufferObjectsAssoc, #]& /@ Keys[nonEmptyBufferTypeDropVolumeRules], Values@nonEmptyBufferTypeDropVolumeRules}
						],
					1
				];

				(* Check whether this originInputSample need to premix solutions to bypass the Hamilton $RoboticTransferVolumeThreshold. *)
				(* Hamilton LiquidHandler has 50 Nanoliter error when using 50ul tip to transfer solutions. *)
				(* To increase precision, we limit the usage of Hamilton LH to transfer volume greater or equal to $RoboticTransferVolumeThreshold. *)
				(* Note: The PreMixQ here are our Hamilton LH-limit, if we buy a LiquidHandler with both nanoliter and microliter scale later, *)
				(* we can remove this requirement. *)
				{matchedStep3PreMixQ, matchedStep3PreMixWithSampleQ} = Which[
					(* Is Echo ALH selected to dispense samples to this plate, aka Screening Strategy? *)
					(* If so, there is no lower limit of transfer volume, we don't have to premix. *)
					And[
						MatchQ[transferQ, True],
						MatchQ[resolvedCrystallizationStrategy, Screening]
					],
						{False, False},
					(* Is Hamilton LH used to dispense solutions to this plate? *)
					(* For Preparation and Optimization strategies, if minimum solution volume is above 1 Microliter or there is no buffer, we don't have to premix buffer or sample. *)
					And[
						MatchQ[transferQ, True],
						!MatchQ[resolvedCrystallizationStrategy, Screening],
						MatchQ[nonEmptyBufferTypeDropVolumeRules, {}] || GreaterEqualQ[Min[Values@nonEmptyBufferTypeDropVolumeRules], $RoboticTransferVolumeThreshold](*1 Microliter*)
					],
						{False, False},
					(* Is Hamilton LH used to dispense solutions to this plate? *)
					(* If there is only one Buffer but its volume is smaller than 1 Microliter, we premix the buffer with input sample. *)
					And[
						MatchQ[transferQ, True],
						!MatchQ[resolvedCrystallizationStrategy, Screening],
						EqualQ[Length[nonEmptyBufferTypeDropVolumeRules], 1] && MatchQ[Values@nonEmptyBufferTypeDropVolumeRules, {LessP[$RoboticTransferVolumeThreshold]}](*1 Microliter*)
					],
						{False, True},
					(* Is Hamilton LH used to dispense solutions to this plate? *)
					(* PreMixCase1:If at least one buffer has volume smaller than 1 Microliter but the total buffer volume is greater or equal to 1 Microliter, we need to premix buffers. *)
					And[
						MatchQ[transferQ, True],
						!MatchQ[resolvedCrystallizationStrategy, Screening],
						MemberQ[Values@nonEmptyBufferTypeDropVolumeRules, {LessP[$RoboticTransferVolumeThreshold]}],(*1 Microliter*)
						GreaterQ[Total[Values@nonEmptyBufferTypeDropVolumeRules], $RoboticTransferVolumeThreshold](*1 Microliter*)
					],
						{True, False},
					(*PreMixCase2:If the total buffer volume is less than 1 Microliter, we need to premix the buffers first, then premix with samples. *)
					And[
						!MatchQ[resolvedCrystallizationStrategy, Screening],
						LessQ[Total[Values@nonEmptyBufferTypeDropVolumeRules], $RoboticTransferVolumeThreshold](*1 Microliter*)
					],
						{True, True},
					(* Is this plate a PreparedPlate or having failed internal checks? *)
					True,
						{False, False}
				];

				(* Partially generate transfer transfer sequences for step4: CoverWithOil *)
				(* The volume transfer for this step should be in the range of 1 Microliter to 1 Millimeter, always use Hamilton. *)
				matchedStep4TransferTable = If[
					And[
						MatchQ[transferQ, True],
						MatchQ[resolvedCrystallizationTechnique, MicrobatchUnderOil],
						MatchQ[matchedOil, ObjectP[]]
					],
					{{
						CoverWithOil, (*Step*)
						LiquidHandling, (*TransferType*)
						matchedOil, (*Sources *)
						matchedOilVolume, (*TransferVolume*)
						Null,
						dropSamplesOutLabel (*DropSamplesOutLabel*)
					}},
					{Nothing}
				];

				(* Finally, partially resolve TransferTable by combining step2&4 steps. *)
				(* The format is 1)Step2)TransferType3)Sources/PreMixSolutionLabel4)TransferVolume5)Null6)SamplesOutLabel. *)
				matchedTransferTable = If[
					And[
						MatchQ[transferQ, True],
						MemberQ[{matchedStep2TransferTable, matchedStep4TransferTable}, {__}]
					],
					Join[matchedStep2TransferTable, matchedStep4TransferTable],
					(*Join[matchedStep1TransferTable, matchedStep2TransferTable, matchedStep3TransferTable, matchedStep4TransferTable],*)
					(* Failing of any internal checks (transferQ) will result in a Null TransferTable. *)
					(* Other conflicting options at one step, such as CoCrystallizationAirDry and CoCrystallizationReagents, or CrystallizationTechnique and Oil, *)
					(* Only result in that step is set to {}. However, if every single step has conflicts or no entry, we set the TransferTable to Null as well. *)
					Null
				];


				{
					(*1*)matchedCrystallizationScreeningMethod,
					(*2*)matchedSampleVolumes,
					(*3*)matchedReservoirBuffers,
					(*4*)matchedReservoirBufferVolume,
					(*5*)matchedReservoirDropVolume,
					(*6*)matchedDilutionBuffer,
					(*7*)matchedDilutionBufferVolume,
					(*8*)matchedAdditives,
					(*9*)matchedAdditiveVolume,
					(*10*)matchedCoCrystallizationReagents,
					(*11*)matchedCoCrystallizationReagentVolume,
					(*12*)matchedCoCrystallizationAirDry,
					(*13*)matchedSeedingSolution,
					(*14*)matchedSeedingSolutionVolume,
					(*15*)matchedOil,
					(*16*)matchedOilVolume,
					(*17*)dropSamplesOutLabel,
					(*18*)reservoirSamplesOutLabel,
					(*19*)dropDestination,
					(*20*)totalNumberOfSubdivisions,
					(*21*)internalDropDestinationPass,
					(*22*)internalLabelingPass,
					(*23*)matchedStep3PreMixQ,
					(*24*)matchedStep3PreMixWithSampleQ,
					(*25*)matchedTransferTable,
					(*26*)dropLabelToConditionAssociations,
					(*27*)internalNoDuplicatedBuffersPass,
					(*28*)transferQ
				}
			]
		],
		{
			simulatedSamples,
			myInputs,
			samplePackets,
			mapThreadFriendlyOptions,
			Range[Length[simulatedSamples]]
		}
	];


	(* Gather these options together in a list. *)
	resolvedMapThreadOptions = {
		DropSamplesOutLabel -> resolvedDropSamplesOutLabel,
		ReservoirSamplesOutLabel -> resolvedReservoirSamplesOutLabel,
		DropDestination -> resolvedDropDestination,
		CrystallizationScreeningMethod -> resolvedCrystallizationScreeningMethod,
		SampleVolumes -> resolvedSampleVolumes,
		ReservoirBuffers -> resolvedReservoirBuffers,
		ReservoirBufferVolume -> resolvedReservoirBufferVolume,
		ReservoirDropVolume -> resolvedReservoirDropVolume,
		DilutionBuffer -> resolvedDilutionBuffer,
		DilutionBufferVolume -> resolvedDilutionBufferVolume,
		Additives -> resolvedAdditives,
		AdditiveVolume -> resolvedAdditiveVolume,
		CoCrystallizationReagents -> resolvedCoCrystallizationReagents,
		CoCrystallizationReagentVolume -> resolvedCoCrystallizationReagentVolume,
		CoCrystallizationAirDry -> resolvedCoCrystallizationAirDry,
		SeedingSolution -> resolvedSeedingSolution,
		SeedingSolutionVolume -> resolvedSeedingSolutionVolume,
		Oil -> resolvedOil,
		OilVolume -> resolvedOilVolume,
		SamplesInStorageCondition -> Lookup[myOptions, SamplesInStorageCondition]
	};

	mapThreadFriendlyResolvedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentGrowCrystal, resolvedMapThreadOptions];


	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Resolve general options related to CoCrystallizationAirDry. *)
	(* Resolve the CoCrystallizationAirDryTime option. *)
	(* This resolution has to be outside of the MapThread because AirDryTime and Temperature are not index-matching to samples. *)
	(* Samples can have a mix of CoCrystallizationAirDry True or False. *)
	(* CoCrystallizationAirDryTime/Temperature must be populated when at least one sample with CoCrystallizationAirDry True. *)
	resolvedCoCrystallizationAirDryTime = Which[
		MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CoCrystallizationAirDryTime], TimeP],
			Lookup[partiallyRoundedGrowCrystalOptions, CoCrystallizationAirDryTime],
		(* Is resolvedCoCrystallizationAirDry not True for any input sample? *)
		!MemberQ[resolvedCoCrystallizationAirDry, True],
			Null,
		True,
			30 Minute
	];

	(* Resolve the CoCrystallizationAirDryTemperature option. *)
	resolvedCoCrystallizationAirDryTemperature = Which[
		MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, CoCrystallizationAirDryTemperature], TemperatureP|Ambient],
			Lookup[partiallyRoundedGrowCrystalOptions, CoCrystallizationAirDryTemperature],
		(* Is resolvedCoCrystallizationAirDry not True for any input sample? *)
		!MemberQ[resolvedCoCrystallizationAirDry, True],
			Null,
		(* Is resolvedCoCrystallizationAirDryTime longer than 1 Hour? If so, we will put CrystallizationPlate in fume hood at Ambient Temperature. *)
		GreaterQ[resolvedCoCrystallizationAirDryTime, 1 Hour],
			Ambient,
		(* Is the MaxTemperature of the resolved CrystallizationPlate higher than 40 degrees Celsius? *)
		(* If we are also using Hamilton at one point during sample preparation, we can put the plate on HeaterCooler module of Hamilton to facilitate air dry. *)
		And[
			GreaterQ[Lookup[resolvedPlateModelPacket, MaxTemperature], 40 Celsius],
			MemberQ[resolvedCoCrystallizationReagentVolume, VolumeP],
			Or[
				GreaterEqualQ[Min[Cases[resolvedCoCrystallizationReagentVolume, VolumeP]], $RoboticTransferVolumeThreshold], (*Hamilton for step1:AirDryCoCrystallizationReagent*)
				MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion], (*Hamilton for step2:FillReservoir*)
				!MatchQ[resolvedCrystallizationStrategy, Screening], (*Hamilton for step3:StepDrop*)
				MatchQ[resolvedCrystallizationStrategy, Screening] && MatchQ[preMixRequired, True](*Hamilton for step3:StepDrop*)
			]
		],
			40 Celsius,
		True,
			Ambient
	];


	(* Resolve the destination wells for DropSamplesOut and ReservoirSamplesOut. *)
	(* This resolution has to be outside of the MapThread because we pack SamplesOut of different sampleIn into the same plate. *)
	resolvedLabelToWellRules = Which[
		MatchQ[resolvedPreparedPlate, True] && MatchQ[indexedSamplesOutLabelingCheck[[All, 1]], {True..}],
		(* For prepared plate, we do not re-assign well position. Instead, we extract position from samplePacket. *)
			MapThread[
				If[!NullQ[#2], First[#2], First[#3]] -> If[!MatchQ[Lookup[#1, Position], {}], Lookup[#1, Position], Null]&,
				{samplePackets, resolvedDropSamplesOutLabel, resolvedReservoirSamplesOutLabel}
			],
		(* We will assign destination wells on CrystallizationPlate to those labels for newly prepared samples. *)
		(* For tooManySamples, tooManyConditions, conflictingSamplesOutLabel and conflictingDropDestination cases, we don't proceed. *)
		(* As tooManyConditions, conflictingSamplesOutLabel and conflictingDropDestination are checked later, we do a precheck here using resolved options and internal checks. *)
		And[
			MatchQ[resolvedPreparedPlate, False],
			MatchQ[indexedTransferCheck, {True..}],
			MatchQ[tooManySamplesQ, False],
			LessEqualQ[Length[Flatten@Cases[resolvedDropSamplesOutLabel, {___}]], numberOfDropWells],
			LessEqualQ[Length[Flatten@Cases[resolvedReservoirSamplesOutLabel, {___}]], numberOfReservoirWells],
			LessEqualQ[Total[indexedNumberOfSubdivisions], Length[Lookup[resolvedPlateModelPacket, HeadspaceSharingWells]]],
			SubsetQ[DeleteDuplicates@Lookup[resolvedPlateModelPacket, WellContents], DeleteDuplicates@Flatten[resolvedDropDestination]]
		],
			Module[
			{
				reservedHeadspaceLabels, reservedHeadspaceLabelToWells, flattenedDropLabelToConditionAssociations, destinationDropWellRules, destinationReservoirWellRules
			},
			(* Flatten the list of associations mapping DropSamplesOut to its composition and plate configuration. *)
			flattenedDropLabelToConditionAssociations = Flatten[indexedDropLabelToConditionAssociations, 1];
			(* Extract the unique Headspace base names. *)
			reservedHeadspaceLabels = DeleteDuplicates[Lookup[flattenedDropLabelToConditionAssociations, PlateConfiguration][[All, 1]]];
			(* We have already checked TooManySamplesQ, so all reservedHeadspaces should be able on fit in one plate. *)
			(* We are assigning HeadspaceLabels to actually Headspace on CrystallizationPlate. *)
			reservedHeadspaceLabelToWells = MapThread[
				#1 -> #2&,
				{reservedHeadspaceLabels, Lookup[resolvedPlateModelPacket, HeadspaceSharingWells][[;;Length[Flatten@reservedHeadspaceLabels]]]}
			];
			destinationDropWellRules = Map[
				Function[{dropLabel},
					Module[{destinationHeadspaceLabel, destinationWellPosition},
						{destinationHeadspaceLabel,  destinationWellPosition} = Flatten@Lookup[Cases[flattenedDropLabelToConditionAssociations, KeyValuePattern[DropSampleOutLabel -> dropLabel]], PlateConfiguration];
						If[EqualQ[Max[Length[#]& /@ Lookup[resolvedPlateModelPacket, HeadspaceSharingWells]], 1],
							(* If the plate is Microbatch plate where no reservoir well exists, select the well in the reserved Headspace. *)
							dropLabel -> First@Lookup[reservedHeadspaceLabelToWells, destinationHeadspaceLabel],
							(* Otherwise, select the well at desired DropDestination in the reserved Headspace. *)
							dropLabel -> First@Select[Lookup[reservedHeadspaceLabelToWells, destinationHeadspaceLabel], StringContainsQ[#, destinationWellPosition]&]
						]
					]
				],
				Flatten[resolvedDropSamplesOutLabel]
			];
			destinationReservoirWellRules = If[MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
				Flatten@Map[
					Function[{reservoirLabel},
						Module[{nonDuplicatedReservoirPositions},
							(* Multiple DropSamplesOut can link to the same ReservoirSamplesOut, remove extra copies. *)
							nonDuplicatedReservoirPositions = Select[Flatten@DeleteDuplicates[Lookup[reservedHeadspaceLabelToWells, Lookup[Cases[flattenedDropLabelToConditionAssociations, KeyValuePattern[ReservoirSampleOutLabel -> reservoirLabel]], PlateConfiguration][[All, 1]]]], StringContainsQ[#, "Reservoir"]&];
							(reservoirLabel -> #)& /@ nonDuplicatedReservoirPositions
						]
					],
					Flatten[resolvedReservoirSamplesOutLabel]
				],
				{Nothing}
			];
			Join[destinationDropWellRules, destinationReservoirWellRules]
		],
		True,
			(* If any internal checks fail, we don't proceed. *)
			{}
	];

	(* Resolve DropCompositionTable. *)
	(* The format of DropCompositionTable is 1)DropSampleOutLabel 2)DestinationWell 3)Sample 4)SampleVolume *)
	(* 5)DilutionBuffer 6)DilutionBufferVolume 7)ReservoirBuffer 8)ReservoirDropVolume 9)CoCrystallizationReagent *)
	(* 10)CoCrystallizationReagentVolume 11)CoCrystallizationAirDry 12)Additive 13)AdditiveVolume 14)SeedingSolution *)
	(* 15)SeedingSolutionVolume 16)Oil 17)OilVolume. *)
	(* If there is no buffer object specified for one buffer type (None/Null), mark it as Null. *)
	resolvedDropCompositionTable = Which[
		(* For DropSamplesOut on a prepared plate, we can extract SampleVolume and WellPosition if the input prepared plate passed validations. *)
		(* We will other buffer fields with Null. *)
		(* NOTE: For solid DropSample, the SampleVolue is Null. *)
		And[
			MatchQ[resolvedPreparedPlate, True],
			MatchQ[indexedSamplesOutLabelingCheck[[All, 1]], {True..}],
			MatchQ[preparedPlateInvalidVolumeInputs, {}]
		],
			PadRight[
				{
					#, (*1*)
					Lookup[resolvedLabelToWellRules, #], (*2*)
					myInputs[[First[Flatten@Position[resolvedDropSamplesOutLabel, #]]]], (*3*)
					FirstOrDefault@resolvedSampleVolumes[[First[Flatten@Position[resolvedDropSamplesOutLabel, #]]]] (*4*)
				},
				17,
				Null
			]& /@ Flatten@Cases[resolvedDropSamplesOutLabel, {_}],
		(* For DropSamplesOut on an unprepared plate, we can extract drop receipt from indexedDropLabelToConditionAssociations. *)
		MatchQ[resolvedPreparedPlate, False] && !MatchQ[resolvedLabelToWellRules, {}],
			{
				Lookup[#, DropSampleOutLabel],(*1*)
				Lookup[resolvedLabelToWellRules, Lookup[#, DropSampleOutLabel]],(*2*)
				Lookup[#, Sample],(*3*)
				Lookup[#, SampleVolume],(*4*)
				If[MatchQ[Lookup[#, DilutionBuffer], Null|ObjectP[]], Lookup[#, DilutionBuffer], Null],(*5*)
				Lookup[#, DilutionBufferVolume],(*6*)
				If[MatchQ[Lookup[#, ReservoirBuffer], Null|ObjectP[]], Lookup[#, ReservoirBuffer], Null],(*7*)
				Lookup[#, ReservoirDropVolume],(*8*)
				If[MatchQ[Lookup[#, CoCrystallizationReagent], Null|ObjectP[]], Lookup[#, CoCrystallizationReagent], Null],(*9*)
				Lookup[#, CoCrystallizationReagentVolume],(*10*)
				Lookup[#, CoCrystallizationAirDry],(*11*)
				If[MatchQ[Lookup[#, Additive], Null|ObjectP[]], Lookup[#, Additive], Null],(*12*)
				Lookup[#, AdditiveVolume],(*13*)
				If[MatchQ[Lookup[#, SeedingSolution], Null|ObjectP[]], Lookup[#, SeedingSolution], Null],(*14*)
				Lookup[#, SeedingSolutionVolume],(*15*)
				Part[resolvedOil, First[Flatten@Position[resolvedDropSamplesOutLabel, Lookup[#, DropSampleOutLabel]]]],(*16*)
				Part[resolvedOilVolume, First[Flatten@Position[resolvedDropSamplesOutLabel, Lookup[#, DropSampleOutLabel]]]](*17*)
			}& /@ Flatten[indexedDropLabelToConditionAssociations, 1],
		True,
			Null
	];


	(* We has partially resolved TransferTable in the MapThread, we will resolve BufferPreparationTable and the rest of TransferTable here. *)
	(* The full format of BufferPreparationTable is 1)Step 2) Source(Link/PreparedSolutionLabel) 3)TransferVolume 4)TargetContainer 5)DestinationWells 6)TargetContainerLabel 7)PreparedSolutionsLabel. *)
	(* The format of TransferTable is 1)Step 2)TransferType3)Source(Link/PreparedSolutionLabel) 4)TransferVolume 5)DestinationWells 6)SamplesOutLabel. *)

	(* 1.Generate transfer and aliquot sequences for step1: AirDryCoCrystallizationReagent. *)
	(* We will resolve TransferTable here if at least one sample has CoCrystallizationAirDry set to True. *)
	(* We will resolve BufferPreparationTable here if aliquoting to Echo-compatible source plate is required. *)
	(* As ConflictingCoCrystallizationAirDry options are checked later, we do a precheck here using resolved options and internal check. *)
	{step1TransferTable, step1BufferPreparationTable}= If[
		And[
			MatchQ[indexedTransferCheck, {True..}],
			!MatchQ[resolvedLabelToWellRules, {}],
			MemberQ[resolvedCoCrystallizationAirDry, True],
			MatchQ[Cases[resolvedCoCrystallizationReagentVolume, VolumeP], {LessEqualP[First@Cases[Lookup[Cases[dropSetterInstrumentPackets, KeyValuePattern[{Type -> Model[Instrument, LiquidHandler, AcousticLiquidHandler]}]], MaxVolume], VolumeP]]..}|{GreaterEqualP[$RoboticTransferVolumeThreshold]..}]
		],
		(* Hamilton LH has a flat 50 Nanoliter error when using 50ul tip to transfer volume below 5 Microliter. *)
		(* To increase precision, we limit the usage of Hamilton LH to volume greater or equal to $RoboticTransferVolumeThreshold (1 Microliter). *)
		(* When the min CoCrystallizationReagentVolume is lower than $RoboticTransferVolumeThreshold, we use Acoustic Liquid Handler. *)
		(* Echo Acoustic Liquid Handler has a MinVolume 2.5 Nanoliter and MaxVolume 5 Microliter. *)
		(* If specified CoCrystallizationReagentVolumes are ranging from volume below 1 Microlter to volume above 5 Microliter, throw error in ConflictingCoCrystallizationAirDry check later. *)
		Module[
			{
				dropsWithAirDriedCoCrystallizationReagents, airDriedCoCrystallizationReagents, airDriedCoCrystallizationReagentVolumes,
				airDriedCoCrystallizationDropLabels, aliquotQ, airDriedCoCrystallizationReagentToVolumeAssocs, targetContainerModel,
				totalNumberOfWells, targetContainerLabels, requiredAliquotedAmounts, coCrystallizationReagentToAliquotedLabels,
				aliquotedSolutionLabels, aliquotedSolutionToDestinationRules, dropLabelToAliquotedLabelAssocs, filledStep1TransferEntries,
				groupedStep1TransferEntries, transferTable, aliquotTable
			},
			(* Pull out the DropSamplesOut that have CoCrystallizationAirDry set to True from DropCompositionTable. *)
			dropsWithAirDriedCoCrystallizationReagents = Cases[resolvedDropCompositionTable, {__, True, __}];
			(* Extract the CoCrystallizationReagents. *)
			airDriedCoCrystallizationReagents = dropsWithAirDriedCoCrystallizationReagents[[All, 9]];
			(* Extract the CoCrystallizationReagentVolume. *)
			airDriedCoCrystallizationReagentVolumes = dropsWithAirDriedCoCrystallizationReagents[[All, 10]];
			(* Extract the DropSamplesOutLabel. *)
			airDriedCoCrystallizationDropLabels = dropsWithAirDriedCoCrystallizationReagents[[All, 1]];
			(* Determine if we need to aliquot CoCrystallizationReagents to Echo-qualified SourcePlate. *)
			aliquotQ = Module[{airDriedCoCrystallizationReagentContainers, airDriedCoCrystallizationReagentContainerModels},
				(* Extract the container for CoCrystallizationReagents if they are Object[Sample]. *)
				airDriedCoCrystallizationReagentContainers = If[MemberQ[airDriedCoCrystallizationReagents, ObjectP[Object[Sample]]],
					Download[Lookup[fetchPacketFromCache[#, cacheBall], Container], Object]& /@ Cases[airDriedCoCrystallizationReagents, ObjectP[Object[Sample]]],
					{}
				];
				(* Extract the container model for CoCrystallizationReagents if they are Object[Sample]. *)
				airDriedCoCrystallizationReagentContainerModels = Download[Lookup[fetchPacketFromCache[#, cacheBall], Model]& /@airDriedCoCrystallizationReagentContainers, Object];
				(* If any of the airDriedCoCrystallizationReagents is Model[Sample], or any airDriedCoCrystallizationReagents that is Object[Sample] has AcousticLiquidHandlerIncompatible container, we need to aliquot airDriedCoCrystallizationReagents to AcousticLiquidHandlerCompatible when using AcousticLiquidHandler. *)
				And[
					Or[
						MemberQ[airDriedCoCrystallizationReagents, ObjectP[Model[Sample]]],
						And@@(!MemberQ[PreferredContainer[All, Type -> All, AcousticLiquidHandlerCompatible -> True], #]& /@ airDriedCoCrystallizationReagentContainerModels)
						],
					LessQ[Min[PickList[resolvedCoCrystallizationReagentVolume, resolvedCoCrystallizationAirDry]], $RoboticTransferVolumeThreshold]
				]
			];
			(* Group the same CoCrystallizationReagents Together. *)
			airDriedCoCrystallizationReagentToVolumeAssocs = GroupBy[Transpose[{airDriedCoCrystallizationReagents, airDriedCoCrystallizationReagentVolumes}], First];
			(* Pre-calculate the total amount of CoCrystallizationReagents that needed for each unique airDriedCoCrystallizationReagent. *)
			(* We add 10% extra here. *)
			requiredAliquotedAmounts = If[MatchQ[aliquotQ, True],
				1.1*Total[Lookup[airDriedCoCrystallizationReagentToVolumeAssocs, #][[All, 2]]]& /@ Keys[airDriedCoCrystallizationReagentToVolumeAssocs],
				Null
			];
			(* NOTE: Here we chose Echo Source Plate:"384-well Low Dead Volume Echo Qualified Plate" as aliquot container. *)
			(* The plate model has a dead volume 6 Microliter and working volume range is 6 Microliter to 12 Microliter. *)
			(* We defined the source plate working volume as MaxVolume and dead volume as DeadVolume in the big download of this option resolver earlier. *)
			targetContainerModel = Model[Container, Plate, "id:01G6nvwNDARA"];(*"384-well Low Dead Volume Echo Qualified Plate"*)
			(* totalNumberOfWells should be 384 here, we just add this variable in case we use 1536-well SourcePlate in the future. *)
			totalNumberOfWells = fastAssocLookup[fastAssoc, targetContainerModel, NumberOfWells];
			(* Resolved labels for aliquoted solutions. *)
			(* We might need more than one labels for one kind of CoCrystallizationReagent if the total volume is more than one well's working volume. *)
			coCrystallizationReagentToAliquotedLabels = If[MatchQ[aliquotQ, True],
				MapThread[
					Function[{requiredAmount, coCrystallizationReagent},
						coCrystallizationReagent -> (CreateUniqueLabel["ExperimentGrowCrystal AliquotedSolution", UserSpecifiedLabels -> userSpecifiedLabels]& /@ Range[Ceiling[requiredAmount/getEchoSourcePlateWorkingVolume[Model[Container, Plate, "id:01G6nvwNDARA"]]]])
					],
					{requiredAliquotedAmounts, Keys[airDriedCoCrystallizationReagentToVolumeAssocs]}
				],
				{}
			];
			(* After we resolve all the AliquotedSolutionLabels, we can assign AliquotedSolutions to destination wells on targetContainer. *)
			aliquotedSolutionLabels = If[MatchQ[aliquotQ, True], Flatten@Values[coCrystallizationReagentToAliquotedLabels], {}];
			(* Resolved labels for targetContainer. *)
			(* We might need more than one container if the total number of aliquoted solutions are more than totalNumberOfWells. *)
			targetContainerLabels = If[MatchQ[aliquotQ, True],
				CreateUniqueLabel["ExperimentGrowCrystal AliquotedContainer"]& /@ Range[Ceiling[Length[aliquotedSolutionLabels]/totalNumberOfWells]],
				{}
			];
			(* When we pack aliquotedSolutions to targetContainer, if multiple containers are needed, we pack every wells in the first container, then start pack the next one. *)
			(* The format of aliquotedSolutionToDestinationRules is {AliquotedSolutionLabel1->{WellPosition1, targetContainerLabel},..}*)
			aliquotedSolutionToDestinationRules = If[MatchQ[aliquotQ, True],
				MapThread[
					#1-> {#2, targetContainerLabels[[Ceiling[#3/totalNumberOfWells]]]}&,
					{
						aliquotedSolutionLabels,
						If[EqualQ[Length[targetContainerLabels], 1],
							Flatten[AllWells[NumberOfWells -> totalNumberOfWells]][[;;Length@aliquotedSolutionLabels]],
							PadLeft[AllWells[NumberOfWells -> totalNumberOfWells][[;;Mod[Length@aliquotedSolutionLabels, totalNumberOfWells]]], Length[aliquotedSolutionLabels], AllWells[NumberOfWells -> totalNumberOfWells]]
						],
						Range[Length[aliquotedSolutionLabels]]
					}
				],
				{}
			];
			(* If the total required amount is more than the working volume range of one well, we will divide the required amount evenly across all the occupied wells. *)
			(* If only one aliquoted well is needed, all DropSamplesOut are associated with this well. *)
			dropLabelToAliquotedLabelAssocs = If[MatchQ[aliquotQ, True],
				Flatten@Map[
					Function[{coCrystallizationReagent},
						Module[{coCrystallizationReagentVolumeToDropLabels, numberOfAlquotedWells, splitDropLabels},
							(* Group all the DropSamplesOutLabel with the same CoCrystallizationReagent and its Volume together. *)
							(* e.g. <|0.1Microliter -> {"myDropSamplesOut 1","myDropSamplesOut 3"}|>. *)
							coCrystallizationReagentVolumeToDropLabels = Merge[Cases[resolvedDropCompositionTable, {x_, __, coCrystallizationReagent, y_, True, __} -> (y -> x)], Identity];
							(* For each volume group above, we partition the DropSamplesOut to the number of total occupied aliquoted wells. *)
							numberOfAlquotedWells = Length[Lookup[coCrystallizationReagentToAliquotedLabels, coCrystallizationReagent]];
							(* Split DropSamplesOut evenly to each aliquoted well. *)
							splitDropLabels = Transpose[PartitionRemainder[#, Ceiling[Length[#]/numberOfAlquotedWells]]& /@ Values[coCrystallizationReagentVolumeToDropLabels]];
							(* Link the split DropLabel groups to aliquoted solution label. *)
							MapThread[
								Function[{aliquotedSolutionLabel, groupedDropLabels},
									# -> aliquotedSolutionLabel& /@ Flatten[groupedDropLabels]
								],
								{Lookup[coCrystallizationReagentToAliquotedLabels, coCrystallizationReagent], splitDropLabels}
							]
						]
					],
					Keys[airDriedCoCrystallizationReagentToVolumeAssocs]
				],
				{}
			];
			(* After we divide DropSamplesOut evenly to aliquoted wells, we add the dead volume of targetContainer to each of them, *)
			(* and round it up based on Hamilton Precision. *)
			aliquotTable = If[MatchQ[aliquotQ, True],
				Flatten[
					MapThread[
						Function[{coCrystallizationReagent, requiredAmount},
							Module[{groupedDestination, destinationWells, targetContainerLabels, deadVolume, workingVolume},
								groupedDestination = GatherBy[Lookup[aliquotedSolutionToDestinationRules, #]& /@Lookup[coCrystallizationReagentToAliquotedLabels, coCrystallizationReagent], Last];
								destinationWells = Flatten[#[[All, 1]]]& /@ groupedDestination;
								targetContainerLabels = First@Flatten[#[[All, 2]]]& /@ groupedDestination;
								deadVolume = getEchoSourcePlateDeadVolume[targetContainerModel];
								workingVolume = getEchoSourcePlateWorkingVolume[targetContainerModel];
								(* To ensure the first aliquoted well assigned with all the remainders during partition has enough solution, we use Floor instead of Ceiling in the SourceVolume below and add one extra copy. *)
								MapThread[
									{
										AirDryCoCrystallizationReagent,(*Step*)
										coCrystallizationReagent,(*Source*)
										Min[SafeRound[requiredAmount/Max[1, Floor[requiredAmount/workingVolume]] + deadVolume + Total@DeleteDuplicates[Lookup[airDriedCoCrystallizationReagentToVolumeAssocs, coCrystallizationReagent][[All, 2]]], $LiquidHandlerVolumeTransferPrecision, Round -> Up], workingVolume + deadVolume],(*SourceVolume*)
										targetContainerModel,(*AliquotContainerModel*)
										#1,(*DestinationWells*)
										#2,(*AliquotContainerLabel*)
										Lookup[coCrystallizationReagentToAliquotedLabels, coCrystallizationReagent](*AliquotedSolutionLabels*)
									}&,
									{destinationWells, targetContainerLabels}
								]
							]
						],
						{Keys[airDriedCoCrystallizationReagentToVolumeAssocs], requiredAliquotedAmounts}
					],
					1
				],
				{Nothing}
			];
			filledStep1TransferEntries = If[MatchQ[aliquotQ, True],
				Flatten[
					MapThread[
						Function[{coCrystallizationReagent, coCrystallizationReagentVolume, dropCompositionTableEntry},
							{
								AirDryCoCrystallizationReagent, (*Step*)
								AcousticLiquidHandling, (*TransferType*)
								Lookup[dropLabelToAliquotedLabelAssocs, dropCompositionTableEntry[[1]]],(*AliquotedSolutionLabel*)
								coCrystallizationReagentVolume,(*TransferVolume*)
								{dropCompositionTableEntry[[2]]},(*DestinationWell*)
								{dropCompositionTableEntry[[1]]} (*DropSamplesOutLabel*)
							}& /@ Lookup[coCrystallizationReagentToAliquotedLabels, coCrystallizationReagent]
						],
						{airDriedCoCrystallizationReagents, airDriedCoCrystallizationReagentVolumes, dropsWithAirDriedCoCrystallizationReagents}
					],
					1
				],
				MapThread[
					{
						AirDryCoCrystallizationReagent, (*Step*)
						If[GreaterEqualQ[#2, $RoboticTransferVolumeThreshold], LiquidHandling, AcousticLiquidHandling], (*TransferType*)
						#1, (*Source*)
						#2, (*TransferVolume*)
						{#3[[2]]},(*DestinationWell*)
						{#3[[1]]} (*DropSamplesOutLabel*)
					}&,
					{airDriedCoCrystallizationReagents, airDriedCoCrystallizationReagentVolumes, dropsWithAirDriedCoCrystallizationReagents}
				]
			];
			(* Group same source and transferVolume together. *)
			groupedStep1TransferEntries = GatherBy[filledStep1TransferEntries, #[[;; 4]]&];
			transferTable = If[GreaterQ[Length[#], 1],
				ReplacePart[First@#, {5 -> Flatten@#[[All, 5]], 6 -> Flatten@#[[All, 6]]}],
				First@#
			]& /@ groupedStep1TransferEntries;
			{transferTable, aliquotTable}
		],
		{{Nothing}, {Nothing}}
	];

	(* 2.Generate transfer sequences for step2: FillReservoir. *)
	(* An index-matching transfer sequence for Step2:FillReservoir has been partially resolved inside of MapThread. *)
	(* Here we flatten the transfer sequences and add DestinationWells. *)
	step2TransferTable = If[
		And[
			MatchQ[indexedTransferCheck, {True..}],
			!MatchQ[resolvedLabelToWellRules, {}],
			MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion],
			!MatchQ[Cases[Flatten[partiallyResolvedTransferTable, 1], {FillReservoir, ___}], {}]
		],
		Module[{filledStep2TransferEntries, groupedStep2TransferEntries},
			(* Replace the destinationWells with the assigned WellPositions from resolvedLabelToWellRules. *)
			filledStep2TransferEntries = Map[
				Function[{transferEntry},
					Module[{reservoirLabels, destinationWells},
						reservoirLabels = Last@transferEntry;
						destinationWells = Lookup[resolvedLabelToWellRules, reservoirLabels];
						ReplacePart[transferEntry, {5 -> destinationWells}]
						]
				],
				Cases[Flatten[partiallyResolvedTransferTable, 1], {FillReservoir, ___}]
			];
			(* Group same source and transferVolume together. *)
			groupedStep2TransferEntries = GatherBy[filledStep2TransferEntries, #[[;; 4]]&];
			If[GreaterQ[Length[#], 1],
				ReplacePart[First@#, {5 -> Flatten@#[[All, 5]], 6 -> Flatten@#[[All, 6]]}],
				First@#
			]& /@ groupedStep2TransferEntries
		],
		{Nothing}
	];


	(* Generate transfer sequences for step3: SetDrop. *)

	(* The format of DropCompositionTable is 1)DropSampleOutLabel 2)DestinationWell 3)Sample 4)SampleVolume *)
	(* 5)DilutionBuffer 6)DilutionBufferVolume 7)ReservoirBuffer 8)ReservoirDropVolume 9)CoCrystallizationReagent *)
	(* 10)CoCrystallizationReagentVolume 11)CoCrystallizationAirDry 12)Additive 13)AdditiveVolume 14)SeedingSolution *)
	(* 15)SeedingSolutionVolume 16)Oil 17)OilVolume. *)
	(* From there, pull out all the buffer components as well as sample that need to add to CrystallizationPlate at SetDrop step of Sample Preparation. *)
	(* If one entry in DropCompositionTable has CoCrystallizationAirDry set at True, then CoCrystallizationReagent has been added in step1:AirDryCoCrystallizationReagent. *)
	(* We will remove it. We also remove Oil and OilVolume. *)
	step3DropCompositionAssocs = If[MatchQ[indexedTransferCheck, {True..}] && !MatchQ[resolvedLabelToWellRules, {}],
		<|
			DropSampleOutLabel -> #[[1]],(*1*)
			DestinationWell -> #[[2]],(*2*)
			Sample -> #[[3]],(*3*)
			SampleVolume -> #[[4]],(*4*)
			DilutionBuffer -> #[[5]],(*5*)
			DilutionBufferVolume -> #[[6]],(*6*)
			ReservoirBuffer -> #[[7]],(*7*)
			ReservoirDropVolume -> #[[8]],(*8*)
			CoCrystallizationReagent -> If[MatchQ[#[[11]], False], #[[9]], Null],(*9*)
			CoCrystallizationReagentVolume -> If[MatchQ[#[[11]], False], #[[10]], Null],(*10*)
			Additive -> #[[12]],(*12*)
			AdditiveVolume -> #[[13]],(*13*)
			SeedingSolution -> #[[14]],(*14*)
			SeedingSolutionVolume -> #[[15]](*15*)
		|>& /@ resolvedDropCompositionTable,
		{<||>}
	];

	(* Remove all the Keys whose values are Null in step3DropCompositionAssocs. *)
	nonEmptySolutionComponentAssoc = Map[
		Function[{dropAssoc},
			Select[dropAssoc, !NullQ[#]&]
		],
		step3DropCompositionAssocs
	];

	(* Resolve PreMixBuffer option. *)
	resolvedPreMixBuffer = Which[
		MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, PreMixBuffer], BooleanP|Null],
			Lookup[partiallyRoundedGrowCrystalOptions, PreMixBuffer],
		(* Is resolvedPreparedPlate True? *)
		MatchQ[resolvedPreparedPlate, True],
			Null,
		(* Are all input samples have less than or equal to one buffer component other than evaporated CoCrystallizationReagents in the drop composition ? *)
		MatchQ[indexedTransferCheck, {True..}] && LessEqualQ[Max[Length[#]& /@ nonEmptySolutionComponentAssoc], 6],
			Null,
		(* Otherwise, for any preparing plate, if it fails indexedTransferCheck or more than one buffer component exist in DropSamplesOut, set PreMixBuffer to True. *)
		True,
			True
	];

	{step3TransferTable, step3BufferPreparationTable} = Which[
		(* When PreMixBuffer is not True and we are using HamiltonLH (Optimization or Preparation Strategy). *)
		And[
			MatchQ[indexedTransferCheck, {True..}],
			!MatchQ[resolvedLabelToWellRules, {}],
			!MatchQ[resolvedPreMixBuffer, True],
			!MatchQ[resolvedCrystallizationStrategy, Screening]
		],
		(* We first divide all the DropSamplesOut based on whether it has multiple buffer components. *)
			Module[{
				groupedDropLabelsByComponents, dropEntriesWithMultipleBufferComponents, dropEntriesWithLessThan2BufferComponents,
				groupedSingleComponentByBufferVolume, dropEntriesToMixSamples, dropEntriesNotToMixSamples, validQ, transferTable,
				filledStep3PreMixEntries, groupedStep3PreMixEntries, preMixTable, filledStep3TransferEntries, groupedStep3TransferEntries
			},
				groupedDropLabelsByComponents = GroupBy[nonEmptySolutionComponentAssoc, LessEqualQ[Length[#], 6]&];
				(* When they are 6 keys in the nonEmptySolutionComponentAssoc, there is one buffer component. *)
				dropEntriesWithLessThan2BufferComponents = Lookup[groupedDropLabelsByComponents, True, {}];
				dropEntriesWithMultipleBufferComponents = Lookup[groupedDropLabelsByComponents, False, {}];
				(* We further divide dropEntriesWithLessThan2BufferComponents based on whether buffer is required to mixed with samples. *)
				(* This happens if there is one buffer component and the volume of the buffer is less than 1 Microltier. *)
				groupedSingleComponentByBufferVolume = GroupBy[dropEntriesWithLessThan2BufferComponents, MatchQ[Cases[Values[KeyDrop[#, SampleVolume]], VolumeP], {}] ||GreaterEqualQ[First@Cases[Values[KeyDrop[#, SampleVolume]], VolumeP], $RoboticTransferVolumeThreshold] &];
				dropEntriesNotToMixSamples = Lookup[groupedSingleComponentByBufferVolume, True, {}];
				dropEntriesToMixSamples = Lookup[groupedSingleComponentByBufferVolume, False, {}];
				(* Since conflicting volume checks are thrown later, we do a precheck here. *)
				validQ = If[!MatchQ[dropEntriesWithMultipleBufferComponents, {}],
					MatchQ[Cases[Flatten[Query[All, Values]@dropEntriesWithMultipleBufferComponents], VolumeP], {GreaterEqualP[$RoboticTransferVolumeThreshold]...}],
					True
				];
				(* If validQ is True, we will resolve TransferTable and BufferPreparationTable. *)
				(* In total, we have 3 groups: dropEntriesWithMultipleBufferComponents, dropEntriesNotToMixSamples, dropEntriesToMixSamples. *)
				filledStep3PreMixEntries = If[MatchQ[validQ, True] && !MatchQ[dropEntriesToMixSamples, {}],
					Module[{preMixContainer, preMixSolutionLabels, preMixContainerLabels, preMixSolutionToDestinationRules, scalingFactors},
						(* We pick a 96-well Deep Well Plate as PreMixContainer where we prepare mixtures of buffer with sample. *)
						preMixContainer = Model[Container, Plate, "id:L8kPEjkmLbvW"]; (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
						(* Generate labels for mixtures of all DropSamplesOut. *)
						preMixSolutionLabels = CreateUniqueLabel["ExperimentGrowCrystal PreMixSolution", UserSpecifiedLabels -> userSpecifiedLabels]& /@ Range[Length@dropEntriesToMixSamples];
						(* Resolved labels for targetContainer. *)
						(* We might need more than one container if the total number of preMixSolutions are more than 96. *)
						preMixContainerLabels = CreateUniqueLabel["ExperimentGrowCrystal PreMixContainer"]& /@ Range[Ceiling[Length[preMixSolutionLabels]/96]];
						(* When we pack preMixSolutions to preMixContainer, if multiple containers are needed, we pack every wells in the first container, then start pack the next one. *)
						(* The format of preMixSolutionsToDestinationRules is {PreMixSolutionsSolutionLabel1->{WellPosition1, preMixContainerLabel},..}*)
						preMixSolutionToDestinationRules = MapThread[
							#1-> {#2, preMixContainerLabels[[Ceiling[#3/96]]]}&,
							{
								preMixSolutionLabels,
								If[EqualQ[Length[preMixContainerLabels], 1],
									Flatten[AllWells[NumberOfWells -> 96]][[;;Length@preMixSolutionLabels]],
									PadLeft[AllWells[NumberOfWells -> 96][[;;Mod[Length@preMixSolutionLabels, 96]]], Length[preMixSolutionLabels], AllWells[NumberOfWells -> 96]]
								],
								Range[Length[preMixSolutionLabels]]
							}
						];
						(* We scale the total volume up to $RoboticPreMixVolumeThreshold (30 Microliter) or individual buffer volume up to 1 Microliter, whichever is greater. *)
						scalingFactors = Max[$RoboticPreMixVolumeThreshold/Total[Cases[Values@#, VolumeP]], $RoboticTransferVolumeThreshold/First@Cases[Values[KeyDrop[#, SampleVolume]], VolumeP]]& /@ dropEntriesToMixSamples;
						(* Generate entries for BufferPreparationTable(PreMixTable). *)
						Flatten[
							MapThread[
								Function[{dropEntry, scalingFactor, preMixSolutionLabel},
									Module[{sampleSource, sampleVolume, bufferSource, bufferVolume},
										sampleSource = Lookup[dropEntry, Sample];
										sampleVolume = Lookup[dropEntry, SampleVolume];
										bufferSource = First[Cases[Values@KeyDrop[dropEntry, Sample], ObjectP[]]];
										bufferVolume = First[Cases[Values@KeyDrop[dropEntry, SampleVolume], VolumeP]];
										{
											{
												SetDrop,(*1Step*)
												sampleSource,(*2Source*)
												SafeRound[scalingFactor*sampleVolume, $LiquidHandlerVolumeTransferPrecision],(*3SourceVolume*)
												preMixContainer,(*4TargetContainerModel*)
												{Lookup[preMixSolutionToDestinationRules, preMixSolutionLabel][[1]]},(*5DestinationWells*)
												Lookup[preMixSolutionToDestinationRules, preMixSolutionLabel][[2]],(*6PreMixContainerLabel*)
												{preMixSolutionLabel}(*7PreMixSolutionsLabel*)
											},
											{
												SetDrop,(*1Step*)
												bufferSource,(*2Source*)
												SafeRound[scalingFactor*bufferVolume, $LiquidHandlerVolumeTransferPrecision],(*3SourceVolume*)
												preMixContainer,(*4TargetContainerModel*)
												{Lookup[preMixSolutionToDestinationRules, preMixSolutionLabel][[1]]},(*5DestinationWells*)
												Lookup[preMixSolutionToDestinationRules, preMixSolutionLabel][[2]],(*6PreMixContainerLabel*)
												{preMixSolutionLabel}(*7PreMixSolutionsLabel*)
											}
										}
									]
								],
								{dropEntriesToMixSamples, scalingFactors, preMixSolutionLabels}
							],
							1
						]
					],
					{Nothing}
				];
				(* same source and transferVolume together. *)
				groupedStep3PreMixEntries = GatherBy[filledStep3PreMixEntries, Drop[Most@#, {5}]&];
				preMixTable = If[GreaterQ[Length[#], 1],
					ReplacePart[First@#, {5 -> Flatten@#[[All, 5]], 7 -> Flatten@#[[All, 7]]}],
					First@#
				]& /@ groupedStep3PreMixEntries;
				(* Generate TransferTable for each of the three groups(dropEntriesToMixSample, dropEntriesNotToMixSamples & dropEntriesWithMultipleBufferComponents).*)
				filledStep3TransferEntries = If[MatchQ[validQ, True],
					Join[
						(* For dropEntriesToMixSample *)
						MapThread[
							{
								SetDrop, (*Step*)
								LiquidHandling, (*TransferType*)
								First@Flatten[#2[[All, 7]]], (*Source*)
								Total[Cases[Values@#1, VolumeP]], (*TransferVolume*)
								{Lookup[#1, DestinationWell]},(*DestinationWell*)
								{Lookup[#1, DropSampleOutLabel]}(*DropSamplesOutLabel*)
							}&,
							{dropEntriesToMixSamples, Partition[filledStep3PreMixEntries, 2]}
						],
						(* For dropEntriesNotToMixSamples & dropEntriesWithMultipleBufferComponents *)
						Flatten[
							Map[
								Function[{dropEntry},
									Module[{sampleSource, sampleVolume, bufferSources, bufferVolumes, bufferSourceAndVolumePairs},
										sampleSource = Lookup[dropEntry, Sample];
										sampleVolume = Lookup[dropEntry, SampleVolume];
										(* Since 0 to multiple buffer components might exist in the entry, we first pair bufferObject with its volume. *)
										bufferSources = Lookup[dropEntry, {DilutionBuffer, ReservoirBuffer, CoCrystallizationReagent, Additive, SeedingSolution}, Null];
										bufferVolumes = Lookup[dropEntry, {DilutionBufferVolume, ReservoirDropVolume, CoCrystallizationReagentVolume, AdditiveVolume, SeedingSolutionVolume}, Null];
										bufferSourceAndVolumePairs = If[!MatchQ[bufferSources, {Null..}],
											Cases[Transpose[{bufferSources, bufferVolumes}], {ObjectP[], VolumeP}],
											{}
										];
										{
											SetDrop, (*Step*)
											LiquidHandling, (*TransferType*)
											#[[1]], (*Sources*)
											#[[2]], (*TransferVolume*)
											{Lookup[dropEntry, DestinationWell]},(*DestinationWell*)
											{Lookup[dropEntry, DropSampleOutLabel]} (*DropSamplesOutLabel*)
										}& /@ Join[{{sampleSource, sampleVolume}}, bufferSourceAndVolumePairs]
									]
								],
								Join[dropEntriesNotToMixSamples, dropEntriesWithMultipleBufferComponents]
							],
							1
						]
					],
					{Nothing}
				];
				(* Group same source and transferVolume together. *)
				groupedStep3TransferEntries = GatherBy[filledStep3TransferEntries, #[[;; 4]]&];
				transferTable = If[GreaterQ[Length[#], 1],
					ReplacePart[First@#, {5 -> Flatten@#[[All, 5]], 6 -> Flatten@#[[All, 6]]}],
					First@#
				]& /@ groupedStep3TransferEntries;
				{transferTable, preMixTable}
			],
		(* When PreMixBuffer is not True and we are using Echo(Screening Strategy). *)
		And[
			MatchQ[indexedTransferCheck, {True..}],
			!MatchQ[resolvedLabelToWellRules, {}],
			!MatchQ[resolvedPreMixBuffer, True],
			MatchQ[resolvedCrystallizationStrategy, Screening]
		],
		(* We first check if we need to aliquot sample/buffers to source plate. *)
			Module[
				{
					aliquotQ, uniqueSamples, requiredAmountsOfUniqueSamples, dropBuffers, dropBufferVolumes, dropBufferAndVolumePairs,
					dropBufferToVolumeRules, uniqueBuffers, requiredAmountsOfUniqueBuffers, deadVolume, workingVolume, totalNumberOfWells,
					requiredDestinationWells, originalSolutionToAliquotedLabels, targetContainerLabels, aliquotedSolutionToDestinationRules,
					filledStep3AliquotEntries, groupedStep3AliquotEntries, aliquotTable, targetContainerModel, filledStep3TransferEntries,
					dropLabelToAliquotedLabelAssocs, groupedStep3TransferEntries, transferTable
				},
				(* Determine if we need to aliquot Samples and buffers to Echo-qualified SourcePlate. *)
				aliquotQ = Module[{solutionContainers, solutionContainerModels},
					(* Extract the container for buffers and samples if they are Object[Sample]. *)
					solutionContainers = DeleteDuplicates[Download[Lookup[fetchPacketFromCache[#, cacheBall], Container], Object]& /@ Cases[Flatten[Values@nonEmptySolutionComponentAssoc],
						ObjectP[Object[Sample]]]];
					(* Extract the container model for Solutions that need to be added to CrystallizationPlate at SetDrop step if they are Object[Sample]. *)
					solutionContainerModels = DeleteDuplicates[Download[Lookup[fetchPacketFromCache[#, cacheBall], Model]& /@solutionContainers, Object]];
					(* If any of the buffers is Model[Sample], or any solutions that are Object[Sample] not in the same AcousticLiquidHandlerCompatible container, we need to aliquot both samples and buffers to AcousticLiquidHandlerCompatible when using AcousticLiquidHandler. *)
					Or[
						MemberQ[Cases[Flatten[Values@nonEmptySolutionComponentAssoc], ObjectP[]], ObjectP[Model[Sample]]],
						GreaterQ[Length[solutionContainers], 1],
						And@@(!MemberQ[PreferredContainer[All, Type -> All, AcousticLiquidHandlerCompatible -> True], #]& /@ solutionContainerModels)
					]
				];
				(* Pre-calculate the total amount of sample that needed for this experiment. *)
				(* We add 10% extra here. *)
				uniqueSamples = DeleteDuplicates[Lookup[#, Sample]& /@ nonEmptySolutionComponentAssoc];
				requiredAmountsOfUniqueSamples = 1.1*Total@Lookup[Cases[nonEmptySolutionComponentAssoc, KeyValuePattern[{Sample -> #}]], SampleVolume]& /@ uniqueSamples;
				(* We pick Echo Qualified SourcePlate as targetContainer when using Echo. *)
				(* The most precious thing is the samples, most of buffers are commercial kits. *)
				(* We want to save the amount of samples, so choose whichever plate model with less aliquoted dead volumes. *)
				(* It is not always 384-well Low Dead Volume Echo Qualified Plate because we might have too much required samples so we have to aliquot samples to several wells. *)
				targetContainerModel = If[GreaterQ[Total[Ceiling[requiredAmountsOfUniqueSamples/getEchoSourcePlateWorkingVolume[Model[Container, Plate, "id:01G6nvwNDARA"]]]*getEchoSourcePlateDeadVolume[Model[Container, Plate, "id:01G6nvwNDARA"]]], Total[Ceiling[requiredAmountsOfUniqueSamples/getEchoSourcePlateWorkingVolume[Model[Container, Plate, "id:7X104vn56dLX"]]]*getEchoSourcePlateDeadVolume[Model[Container, Plate, "id:7X104vn56dLX"]]]],
					Model[Container, Plate, "id:7X104vn56dLX"], (*"384-well Polypropylene Echo Qualified Plate"*)
					Model[Container, Plate, "id:01G6nvwNDARA"](*"384-well Low Dead Volume Echo Qualified Plate"*)
				];
				(* totalNumberOfWells should be 384 here, we just add this variable in case we use 1536-well SourcePlate in the future. *)
				totalNumberOfWells = fastAssocLookup[fastAssoc, targetContainerModel, NumberOfWells];
				deadVolume = getEchoSourcePlateDeadVolume[targetContainerModel];
				workingVolume = getEchoSourcePlateWorkingVolume[targetContainerModel];
				(* Pre-calculate the amount of buffers that need aliquoting. *)
				(* We add 10% extra to Echo SourcePlate here. And we will add an extra bufferVolume/sampleVolumes to BufferPreparationTable entry for each buffer/sample. *)
				dropBuffers = Lookup[#, {DilutionBuffer, ReservoirBuffer, CoCrystallizationReagent, Additive, SeedingSolution}, Null]& /@ nonEmptySolutionComponentAssoc;
				dropBufferVolumes = Lookup[#, {DilutionBufferVolume, ReservoirDropVolume, CoCrystallizationReagentVolume, AdditiveVolume, SeedingSolutionVolume}, Null]& /@ nonEmptySolutionComponentAssoc;
				dropBufferAndVolumePairs = MapThread[
					If[!MatchQ[#1, {Null..}],
						Cases[Transpose[{#1, #2}], {ObjectP[], VolumeP}],
						{}
					]&,
					{dropBuffers, dropBufferVolumes}
				];
				dropBufferToVolumeRules = Map[
					If[!MatchQ[#, {}],
						First[#] -> Last[#]& /@ #,
						{}
					]&,
					dropBufferAndVolumePairs
				];
				(* Pull out the unique buffer objects from dropBufferToVolumeRules. *)
				uniqueBuffers = DeleteDuplicates[Flatten[Keys@dropBufferToVolumeRules]];
				(* Pull out the total amount of unqiue buffer across all DropSamplesOut. *)
				requiredAmountsOfUniqueBuffers = 1.1*Total@Lookup[dropBufferToVolumeRules, #, 0 Microliter]& /@ uniqueBuffers;
				(* We are able to calculate how many wells do we need to aliquot both samples and buffers. *)
				requiredDestinationWells = If[MatchQ[aliquotQ, True],
					Ceiling[Join[requiredAmountsOfUniqueSamples, requiredAmountsOfUniqueBuffers]/workingVolume],
					0
				];
				(* Resolved labels for aliquoted solutions. *)
				(* We might need more than one labels for one kind of unique sample/buffer if the total volume is more than one well's working volume. *)
				originalSolutionToAliquotedLabels = If[MatchQ[aliquotQ, True],
					MapThread[
							#1 -> (CreateUniqueLabel["ExperimentGrowCrystal AliquotedSolution", UserSpecifiedLabels -> userSpecifiedLabels]& /@ Range[#2])&,
						{Join[uniqueSamples, uniqueBuffers], requiredDestinationWells}
					],
					{}
				];
				(* Resolved labels for targetContainer. *)
				(* We might need more than one container if the total number of aliquoted solutions are more than totalNumberOfWells. *)
				(* It is extremely unlike given the solution amount for screening is in nanoliter range. *)
				(* We have multiple format here just in case user forced us to use Echo to dispense microliter range of solutions. *)
				targetContainerLabels = If[MatchQ[aliquotQ, True],
					CreateUniqueLabel["ExperimentGrowCrystal AliquotedContainer"]& /@ Range[Ceiling[Total[requiredDestinationWells]/totalNumberOfWells]],
					{}
				];
				(* When we pack aliquotedSolutions to targetContainer, if multiple containers are needed, we pack every wells in the first container, then start pack the next one. *)
				(* The format of aliquotedSolutionToDestinationRules is {AliquotedSolutionLabel1->{WellPosition1, targetContainerLabel},..}*)
				aliquotedSolutionToDestinationRules = If[MatchQ[aliquotQ, True],
					MapThread[
						#1-> {#2, targetContainerLabels[[Ceiling[#3/totalNumberOfWells]]]}&,
						{
							Flatten[Values@originalSolutionToAliquotedLabels],
							If[EqualQ[Length[targetContainerLabels], 1],
								Flatten[AllWells[NumberOfWells -> totalNumberOfWells]][[;;Length@Flatten[Values@originalSolutionToAliquotedLabels]]],
								PadLeft[AllWells[NumberOfWells -> totalNumberOfWells][[;;Mod[Length@Flatten[Values@originalSolutionToAliquotedLabels], totalNumberOfWells]]], Length[Flatten[Values@originalSolutionToAliquotedLabels]], AllWells[NumberOfWells -> totalNumberOfWells]]
							],
							Range[Length[Flatten[Values@originalSolutionToAliquotedLabels]]]
						}
					],
					{}
				];
				(* Generate BufferPreparationTable *)
				filledStep3AliquotEntries = If[MatchQ[aliquotQ, True],
					Flatten[
						MapThread[
							Function[{source, totalSourceVolume, sourceType, aliquotedSourceLabels},
								{
									SetDrop,(*1Step*)
									source, (*2Sources*)
									If[MatchQ[sourceType, Buffer],
										Min[SafeRound[totalSourceVolume/Max[1, Floor[totalSourceVolume/workingVolume]] + deadVolume + Total[Lookup[dropBufferToVolumeRules, source, 0 Microliter]], $LiquidHandlerVolumeTransferPrecision, Round -> Up], workingVolume + deadVolume],
										Min[SafeRound[totalSourceVolume/Max[1, Floor[totalSourceVolume/workingVolume]] + deadVolume + Total[resolvedSampleVolumes, 2], $LiquidHandlerVolumeTransferPrecision, Round -> Up], workingVolume + deadVolume]
									],(*3SourceVolume*)
									targetContainerModel,(*4AliquotContainer*)
									{Lookup[aliquotedSolutionToDestinationRules, #][[1]]},(*5DestinationWells*)
									Lookup[aliquotedSolutionToDestinationRules, #][[2]],(*6AliquotContainerLabel*)
									{#} (*7AliquotedSolutionLabels*)
								}& /@ aliquotedSourceLabels
							],
							{Join[uniqueSamples, uniqueBuffers], Join[requiredAmountsOfUniqueSamples, requiredAmountsOfUniqueBuffers], Join[ConstantArray[Sample, Length[uniqueSamples]], ConstantArray[Buffer, Length[uniqueBuffers]]], Values@originalSolutionToAliquotedLabels}
						],
						1
					],
					{Nothing}
				];
				(* Now we sort filledStep3AliquotEntries based on source and aliquoteContainerLabels*)
				groupedStep3AliquotEntries = GatherBy[filledStep3AliquotEntries, Drop[Most@#, {5}]&];
				aliquotTable = If[GreaterQ[Length[#], 1],
					ReplacePart[First@#, {5 -> Flatten@#[[All, 5]], 7 -> Flatten@#[[All, 7]]}],
					First@#
				]& /@ groupedStep3AliquotEntries;
				(* One Solution (either Sample or Buffer) might have multiple aliquotedSolutionLabels associated with it. *)
				(* If the total required amount is more than the working volume range of one well, we will divide the required amount evenly across all the occupied wells. *)
				(* If only one aliquoted well is needed, all DropSamplesOut are associated with this well. *)
				dropLabelToAliquotedLabelAssocs = If[MatchQ[aliquotQ, True],
					Flatten@Join[
						MapThread[
							Function[{sample, totalSampleVolume},
								Module[{dropEntriesWithSample, sampleVolumeGroups, sampleVolumeToDropLabels, numberOfAlquotedWells, splitDropLabels},
									(* Extract all the DropSamplesOut with the same Sample. *)
									dropEntriesWithSample = Cases[nonEmptySolutionComponentAssoc, KeyValuePattern[Sample -> sample]];
									sampleVolumeGroups = DeleteDuplicates[Lookup[#, SampleVolume] & /@ dropEntriesWithSample];
									(* Group all the DropSamplesOutLabel with the same Sample and SampleVolume together. *)
									(* e.g. <|{sample, 0.1Microliter} -> {"myDropSamplesOut 1","myDropSamplesOut 3"}|>. *)
									sampleVolumeToDropLabels = Map[
										{sample, #} -> Lookup[Cases[dropEntriesWithSample, KeyValuePattern[SampleVolume -> #]], DropSampleOutLabel]&,
										sampleVolumeGroups
									];
									(* For each volume group above, we partition the DropSamplesOut to the number of total occupied aliquoted wells. *)
									numberOfAlquotedWells = Ceiling[totalSampleVolume/workingVolume];
									(* Split DropSamplesOut evenly to each aliquoted well. *)
									splitDropLabels = Transpose[PartitionRemainder[#, Ceiling[Length[#]/numberOfAlquotedWells]]& /@ Values[sampleVolumeToDropLabels]];
									(* Link the split DropLabel groups to aliquoted solution label. *)
									MapThread[
										Function[{aliquotedSolutionLabel, groupedDropLabels},
											{#, Sample} -> aliquotedSolutionLabel& /@ Flatten[groupedDropLabels]
										],
										{Lookup[Take[originalSolutionToAliquotedLabels, Length[uniqueSamples]], sample], splitDropLabels}
									]
								]
							],
							{uniqueSamples, requiredAmountsOfUniqueSamples}
						],
						MapThread[
							Function[{buffer, totalBufferVolume},
								Module[
									{
									dropEntriesWithBuffer, bufferKeyOfDropEntries, bufferVolumeKeyofDropEntries, bufferVolumeGroups,
									bufferVolumeAndDropLabels, bufferVolumeToDropLabels, numberOfAlquotedWells, splitDropLabels
									},
									(* Extract all the DropSamplesOut with the same Buffer. *)
									dropEntriesWithBuffer = Select[KeyDrop[nonEmptySolutionComponentAssoc, Sample], MemberQ[#, buffer]&];
									bufferKeyOfDropEntries = Cases[Normal@#, (x_-> buffer) -> x]& /@ dropEntriesWithBuffer;
									bufferVolumeKeyofDropEntries = #/.{DilutionBuffer -> DilutionBufferVolume, SeedingSolution -> SeedingSolutionVolume, ReservoirBuffer -> ReservoirDropVolume, Additive -> AdditiveVolume, CoCrystallizationReagent -> CoCrystallizationReagentVolume}& /@ bufferKeyOfDropEntries;
									bufferVolumeAndDropLabels = MapThread[Lookup[#1, {DropSampleOutLabel, #2}]&, {dropEntriesWithBuffer, bufferVolumeKeyofDropEntries}];
									bufferVolumeGroups = DeleteDuplicates[bufferVolumeAndDropLabels[[All, 2]]];
									(* Group all the DropSamplesOutLabel with the same Buffer and BufferVolume together. *)
									(* e.g. <|{buffer, 0.1Microliter} -> {"myDropSamplesOut 1","myDropSamplesOut 3"}|>. *)
									bufferVolumeToDropLabels = Map[
										{buffer, #} -> Cases[bufferVolumeAndDropLabels, {x_, #} -> x]&,
										bufferVolumeGroups
									];
									(* For each volume group above, we partition the DropSamplesOut to the number of total occupied aliquoted wells. *)
									numberOfAlquotedWells = Ceiling[totalBufferVolume/workingVolume];
									(* Split DropSamplesOut evenly to each aliquoted well. *)
									splitDropLabels = Transpose[PartitionRemainder[#, Ceiling[Length[#]/numberOfAlquotedWells]]& /@ Values[bufferVolumeToDropLabels]];
									(* Link the split DropLabel groups to aliquoted solution label. *)
									MapThread[
										Function[{aliquotedSolutionLabel, groupedDropLabels},
											{#, buffer} -> aliquotedSolutionLabel& /@ Flatten[groupedDropLabels]
										],
										{Lookup[Drop[originalSolutionToAliquotedLabels, Length[uniqueSamples]], buffer], splitDropLabels}
									]
								]
							],
							{uniqueBuffers, requiredAmountsOfUniqueBuffers}
						]
					],
					{}
				];
				(* Generate TransferTable. *)
				filledStep3TransferEntries = Flatten[
					Map[
						Function[{dropEntry},
							Module[{dropLabel, sampleSource, sampleVolume, bufferSources, bufferVolumes, bufferSourceAndVolumePairs},
								dropLabel = Lookup[dropEntry, DropSampleOutLabel];
								sampleSource = If[MatchQ[aliquotQ, True],
									Lookup[dropLabelToAliquotedLabelAssocs, Key[{dropLabel, Sample}]],
									Lookup[dropEntry, Sample]
									];
								sampleVolume = Lookup[dropEntry, SampleVolume];
								(* Since 0 to multiple buffer components might exist in the entry, we first pair bufferObject with its volume. *)
								bufferSources =  If[MatchQ[aliquotQ, True],
									Lookup[dropLabelToAliquotedLabelAssocs, Key[{dropLabel, #}]]& /@ Lookup[dropEntry, {DilutionBuffer, ReservoirBuffer, CoCrystallizationReagent, Additive, SeedingSolution}, Null],
									Lookup[dropEntry, {DilutionBuffer, ReservoirBuffer, CoCrystallizationReagent, Additive, SeedingSolution}, Null]
									];
								bufferVolumes = Lookup[dropEntry, {DilutionBufferVolume, ReservoirDropVolume, CoCrystallizationReagentVolume, AdditiveVolume, SeedingSolutionVolume}, Null];
								bufferSourceAndVolumePairs = If[!MatchQ[bufferSources, {Null..}],
									Cases[Transpose[{bufferSources, bufferVolumes}], {ObjectP[]|_String, VolumeP}],
									{}
								];
								{
									SetDrop, (*Step*)
									AcousticLiquidHandling, (*TransferType*)
									#[[1]], (*Sources*)
									#[[2]], (*TransferVolume*)
									{Lookup[dropEntry, DestinationWell]},(*DestinationWell*)
									{Lookup[dropEntry, DropSampleOutLabel]} (*DropSamplesOutLabel*)
								}& /@ Join[{{sampleSource, sampleVolume}}, bufferSourceAndVolumePairs]
							]
						],
						nonEmptySolutionComponentAssoc
						],
						1
				];
				(* Group same source and transferVolume together. *)
				groupedStep3TransferEntries = GatherBy[filledStep3TransferEntries, #[[;; 4]]&];
				transferTable = If[GreaterQ[Length[#], 1],
					ReplacePart[First@#, {5 -> Flatten@#[[All, 5]], 6 -> Flatten@#[[All, 6]]}],
					First@#
				]& /@ groupedStep3TransferEntries;
				(* Return two tables. *)
				{transferTable, aliquotTable}
			],
		True,
			{{}, {}}
	];

	(* Generate transfer sequences for step4: CoverWithOil. *)
	(* An index-matching transfer sequence for Step4:CoverWithOil has been partially resolved inside of MapThread. *)
	(* Here we flatten the transfer sequences and add DestinationWells. *)
	step4TransferTable = If[
		And[
			MatchQ[indexedTransferCheck, {True..}],
			!MatchQ[resolvedLabelToWellRules, {}],
			MatchQ[resolvedCrystallizationTechnique, MicrobatchUnderOil],
			!MatchQ[Cases[Flatten[partiallyResolvedTransferTable, 1], {CoverWithOil, ___}], {}]
		],
		Module[{filledStep4TransferEntries, groupedStep4TransferEntries},
			(* Replace the destinationWells with the assigned WellPositions from resolvedLabelToWellRules. *)
			filledStep4TransferEntries = Map[
				Function[{transferEntry},
					Module[{dropLabels, destinationWells},
						dropLabels = Last@transferEntry;
						destinationWells = Lookup[resolvedLabelToWellRules, dropLabels];
						ReplacePart[transferEntry, {5 -> destinationWells}]
					]
				],
				Cases[Flatten[partiallyResolvedTransferTable, 1], {CoverWithOil, ___}]
			];
			(* Group same source and transferVolume together. *)
			groupedStep4TransferEntries = GatherBy[filledStep4TransferEntries, #[[;; 4]]&];
			If[GreaterQ[Length[#], 1],
				ReplacePart[First@#, {5 -> Flatten@#[[All, 5]], 6 -> Flatten@#[[All, 6]]}],
				First@#
			]& /@ groupedStep4TransferEntries
		],
		{Nothing}
	];


	(* Resolve BufferPreparationTable by combining different steps. *)
	(* The format is 1)Step2)Source(Link/PreMixSolutionLabel)3)TransferVolume4)PreMixContainerModel5)Null6)Null7)PreMixSolutionsLabel. *)
	resolvedBufferPreparationTable = If[MemberQ[{step1BufferPreparationTable, step3BufferPreparationTable}, {__}],
		Join[step1BufferPreparationTable, step3BufferPreparationTable],
		(* Failing of any internal checks (transferQ) will result in a Null BufferPreparationTable. *)
		Null
	];

	(* Resolve TransferTable by combining each steps. *)
	(* The format is 1)Step2)TransferType3)Sources/PreMixSolutionLabel4)TransferVolume5)Null6)SamplesOutLabel. *)
	resolvedTransferTable = If[MemberQ[{step1TransferTable, step2TransferTable, step3TransferTable, step4TransferTable}, {__}],
		Join[step1TransferTable, step2TransferTable, step3TransferTable, step4TransferTable],
		(*Join[matchedStep1TransferTable, matchedStep2TransferTable, matchedStep3TransferTable, matchedStep4TransferTable],*)
		(* Failing of any internal checks will result in a Null TransferTable. *)
		(* Other conflicting options at one step, such as CoCrystallizationAirDry and CoCrystallizationReagents, or CrystallizationTechnique and Oil, *)
		(* Only result in that step is set to {}. However, if every single step has conflicts or no entry, we set the TransferTable to Null as well. *)
		Null
	];


	(* Gather all unique options for ExperimentGrowCrystal together in a list. *)
	resolvedOptions = Join[
		resolvedGeneralOptions,
		resolvedMapThreadOptions,
		{
			CoCrystallizationAirDryTime -> resolvedCoCrystallizationAirDryTime,
			CoCrystallizationAirDryTemperature -> resolvedCoCrystallizationAirDryTemperature,
			DropCompositionTable -> resolvedDropCompositionTable,
			TransferTable -> resolvedTransferTable,
			BufferPreparationTable -> resolvedBufferPreparationTable,
			PreMixBuffer -> resolvedPreMixBuffer
		}
	];


	(*--- CONFLICTING OPTIONS CHECKS II---*)

	(* Error::ConflictingPreMixBuffer *)
	(* PreMixBuffer & PreparedPlate/TotalBufferVolume conflict. *)
	conflictingPreMixBuffer= If[Or[
		MatchQ[resolvedPreparedPlate, True] && !NullQ[resolvedPreMixBuffer],
		And[
			MatchQ[resolvedPreparedPlate, False],
			!MatchQ[resolvedPreMixBuffer, True],
			!MatchQ[resolvedCrystallizationStrategy, Screening],
			MemberQ[preMixRequired, True]
		]
	],
		{{resolvedPreparedPlate, resolvedPreMixBuffer}},
		{Nothing}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingPreMixBuffer]>0 && messagesQ,
		Message[
			Error::ConflictingPreMixBuffer,
			conflictingPreMixBuffer[[All, 1]],
			conflictingPreMixBuffer[[All, 2]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingPreMixBufferTest = If[gatherTests,
		Module[{preparedPlateTest, preparingPlateTest},
			preparedPlateTest = If[MatchQ[resolvedPreparedPlate, True],
				Test["If PreparedPlate is True, PreMixBuffer should be Null. And if PreparedPlate is False, PreMixBuffer should be be True or False:", MatchQ[conflictingPreMixBuffer, {}], True],
				Nothing
			];
			preparingPlateTest = If[!MatchQ[resolvedPreparedPlate, True],
				Test["If PreparedPlate is False, PreMixBuffer should be be True if total buffer volume is less than 1 Microliter while SampleVolume is equal to or greater than 1 Microliter:", MatchQ[conflictingPreMixBuffer, {}], True],
				Nothing
			];
			{preparedPlateTest, preparingPlateTest}
		],
		Nothing
	];


	(* Error::ConflictingPreparedPlateWithPreparation *)
	(* PreparedPlate & CrystallizationScreeningMethod/DilutionBuffer/ReservoirBuffers/Additives/SeedingSolution/Oil conflict. *)
	conflictingPreparedPlateWithPreparationErrors =
			{
				(* If there is any buffer options specified and PreparedPlate is True, return the options that mismatch. *)
				If[And[
						MatchQ[resolvedPreparedPlate, True],
						MemberQ[resolvedCrystallizationScreeningMethod, {ObjectP[]..}|Custom]
					],
					{"CrystallizationScreeningMethod", PickList[myInputs, MatchQ[#, {ObjectP[]..}|Custom]& /@resolvedCrystallizationScreeningMethod, True], Cases[resolvedCrystallizationScreeningMethod, {ObjectP[]..}|Custom], resolvedPreparedPlate},
					Nothing
				],
				If[And[
						MatchQ[resolvedPreparedPlate, True],
						MemberQ[resolvedDilutionBuffer, ObjectP[]]
					],
					{"DilutionBuffer", PickList[myInputs, MatchQ[#, ObjectP[]]& /@resolvedDilutionBuffer, True], Cases[resolvedDilutionBuffer, ObjectP[]], resolvedPreparedPlate},
					Nothing
				],
				If[And[
						MatchQ[resolvedPreparedPlate, True],
						MemberQ[resolvedReservoirBuffers, {ObjectP[]..}]
					],
					{"ReservoirBuffers", PickList[myInputs, MatchQ[#, {ObjectP[]..}]& /@resolvedReservoirBuffers, True], Cases[resolvedReservoirBuffers, {ObjectP[]..}], resolvedPreparedPlate},
					Nothing
				],
				If[And[
						MatchQ[resolvedPreparedPlate, True],
						MemberQ[resolvedAdditives, {ObjectP[]..}]
					],
					{"Additives", PickList[myInputs, MatchQ[#, {ObjectP[]..}]& /@resolvedAdditives, True], Cases[resolvedAdditives, {ObjectP[]..}], resolvedPreparedPlate},
					Nothing
				],
				If[And[
						MatchQ[resolvedPreparedPlate, True],
						MemberQ[resolvedOil, ObjectP[]]
					],
					{"Oil", PickList[myInputs, MatchQ[#, ObjectP[]]& /@resolvedOil, True], Cases[resolvedOil, ObjectP[]], resolvedPreparedPlate},
					Nothing
				],
				If[And[
						MatchQ[resolvedPreparedPlate, True],
						MemberQ[resolvedSeedingSolution, ObjectP[]]
					],
					{"SeedingSolution", PickList[myInputs, MatchQ[#, ObjectP[]]& /@resolvedSeedingSolution, True], Cases[resolvedSeedingSolution, ObjectP[]], resolvedPreparedPlate},
					Nothing
				],
				(* If there is no SampleVolumes specified and preparedPlate is False, return the input sample. *)
				If[And[
						MatchQ[resolvedPreparedPlate, False],
						NullQ[resolvedSampleVolumes]
					],
					{"SampleVolumes", PickList[myInputs, NullQ[#]& /@resolvedSampleVolumes, True], Null, resolvedPreparedPlate},
					Nothing
				],
				(* If there is no DropDestination specified and preparedPlate is False, return the input sample. *)
				If[And[
					MatchQ[resolvedPreparedPlate, False],
					NullQ[resolvedDropDestination]
				],
					{"DropDestination", PickList[myInputs, NullQ[#]& /@resolvedDropDestination, True], Null, resolvedPreparedPlate},
					Nothing
				],
				(* If there is no CrystallizationScreeningMethod specified and preparedPlate is False, return the mismatch. *)
				If[And[
					MatchQ[resolvedPreparedPlate, False],
					NullQ[resolvedCrystallizationScreeningMethod]
				],
					{"CrystallizationScreeningMethod", PickList[myInputs, NullQ[#]& /@resolvedCrystallizationScreeningMethod, True], Null, resolvedPreparedPlate},
					Nothing
				]
			};

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingPreparedPlateWithPreparationErrors]>0 && messagesQ,
		Message[
			Error::ConflictingPreparedPlateWithPreparation,
			conflictingPreparedPlateWithPreparationErrors[[All, 1]],
			ObjectToString[conflictingPreparedPlateWithPreparationErrors[[All, 2]], Cache -> cacheBall],
			ObjectToString[conflictingPreparedPlateWithPreparationErrors[[All, 3]], Cache -> cacheBall],
			conflictingPreparedPlateWithPreparationErrors[[All, 4]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingPreparedPlatePreparationTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{preparedTest, preparingTest},
			(* Create a test for a PreparedPlate. *)
			preparedTest = If[MatchQ[resolvedPreparedPlate, True],
				Test["If a PreparedPlate specified, all the sample preparation options are Null:", Length[conflictingPreparedPlateWithPreparationErrors] == 0, True],
				Nothing
			];

			(* Create a test for a PreparingPlate. *)
			preparingTest = If[MatchQ[resolvedPreparedPlate, False],
				Test["When preparing a plate, SampleVolumes and CrystallizationScreeningMethod must be specified:", Length[conflictingPreparedPlateWithPreparationErrors] == 0, True],
				Nothing
			];
			(* Return our created tests. *)
			{preparedTest, preparingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingCrystallizationTechniqueWithPreparation *)
	(* CrystallizationTechnique & Sample Preparation options conflict. *)
	conflictingCrystallizationTechniqueWithPreparationErrors = Join[
		MapThread[
			Function[{sample, oil, oilVolume, index},
				If[And[
					MatchQ[oil, ObjectP[]] || MatchQ[oilVolume, VolumeP],
					MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion|MicrobatchWithoutOil]
				],
					{sample, oil, oilVolume, index, resolvedCrystallizationTechnique},
					Nothing
				]
			],
			{myInputs, resolvedOil, resolvedOilVolume, Range[Length[myInputs]]}
		],
		MapThread[
			Function[{sample, reservoirBuffers, reservoirBufferVolume, index},
				If[Or[
					And[
						MemberQ[reservoirBuffers, None|Null],
						MatchQ[resolvedCrystallizationTechnique, SittingDropVaporDiffusion]
					],
					And[
						MatchQ[reservoirBufferVolume, VolumeP],
						MatchQ[resolvedCrystallizationTechnique, MicrobatchUnderOil|MicrobatchWithoutOil]
					]
				],
					{sample, reservoirBuffers, reservoirBufferVolume, index, resolvedCrystallizationTechnique},
					Nothing
				]
			],
			{myInputs, resolvedReservoirBuffers, resolvedReservoirBufferVolume, Range[Length[myInputs]]}
		]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingCrystallizationTechniqueWithPreparationErrors]>0 && messagesQ,
		Message[
			Error::ConflictingCrystallizationTechniqueWithPreparation,
			ObjectToString[conflictingCrystallizationTechniqueWithPreparationErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingCrystallizationTechniqueWithPreparationErrors[[All, 2]], Cache -> cacheBall],
			conflictingCrystallizationTechniqueWithPreparationErrors[[All, 3]],
			conflictingCrystallizationTechniqueWithPreparationErrors[[All, 4]],
			resolvedCrystallizationTechnique
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingCrystallizationTechniquePreparationTest = If[gatherTests,
		Test["If CrystallizationTechnique is specified, the technique-related sample preparation options are matched:",
			MatchQ[conflictingCrystallizationTechniqueWithPreparationErrors, {}],
			True
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingScreeningMethodWithBuffers *)
	(* CrystallizationScreeningMethod & non-singleton buffer options conflict. *)
	conflictingScreeningMethodErrors = Flatten[Join@MapThread[
			Function[{myInput, crystallizationScreeningMethod, reservoirBuffers, additives, coCrystallizationReagents, index},
				{
					(* When method is None, up to one ReservoirBuffers/Additives/CoCrystallizationReagents can be specified. *)
					If[MatchQ[crystallizationScreeningMethod, None] && GreaterQ[Length[reservoirBuffers], 1],
						{myInput, crystallizationScreeningMethod, "ReservoirBuffers", index, Null, reservoirBuffers},
						Nothing
					],
					If[MatchQ[crystallizationScreeningMethod, None] && GreaterQ[Length[additives], 1],
						{myInput, crystallizationScreeningMethod, "Additives", index, Null, additives},
						Nothing
					],
					If[MatchQ[crystallizationScreeningMethod, None] && GreaterQ[Length[coCrystallizationReagents], 1],
						{myInput, crystallizationScreeningMethod, "CoCrystallizationReagents", index, Null, coCrystallizationReagents},
						Nothing
					],
					(* When method is given, it will overwrite ReservoirBuffers/Additives/CoCrystallizationReagents. Do not give both sets of values. *)
					If[MatchQ[crystallizationScreeningMethod, ObjectP[]] && !NullQ[reservoirBuffers] && !MatchQ[reservoirBuffers, {OrderlessPatternSequence @@ (ObjectP[#]& /@ Download[Flatten[fastAssocLookup[fastAssoc, crystallizationScreeningMethod, {ReservoirBuffers}]], Object])}],
						{myInput, crystallizationScreeningMethod, "ReservoirBuffers", index, Download[Flatten[fastAssocLookup[fastAssoc, crystallizationScreeningMethod, {ReservoirBuffers}]], Object], reservoirBuffers},
						Nothing
					],
					If[MatchQ[crystallizationScreeningMethod, ObjectP[]] && !NullQ[additives] && !MatchQ[additives, {OrderlessPatternSequence @@ (ObjectP[#]& /@ Download[Flatten[fastAssocLookup[fastAssoc, crystallizationScreeningMethod, {Additives}]], Object])}],
						{myInput, crystallizationScreeningMethod, "Additives", index, Download[Flatten[fastAssocLookup[fastAssoc, crystallizationScreeningMethod, {Additives}]], Object], additives},
						Nothing
					],
					If[MatchQ[crystallizationScreeningMethod, ObjectP[]] && !NullQ[coCrystallizationReagents] && !MatchQ[coCrystallizationReagents, {OrderlessPatternSequence @@ (ObjectP[#]& /@ Download[Flatten[fastAssocLookup[fastAssoc, crystallizationScreeningMethod, {CoCrystallizationReagents}]], Object])}],
						{myInput, crystallizationScreeningMethod, "CoCrystallizationReagents", index, Download[Flatten[fastAssocLookup[fastAssoc, crystallizationScreeningMethod, {CoCrystallizationReagents}]], Object], coCrystallizationReagents},
						Nothing
					],
					(* When method is Custom, ScreeningReagents ReservoirBuffers/Additives/CoCrystallizationReagents is either None or a list of values. *)
					If[MatchQ[crystallizationScreeningMethod, Custom] && NullQ[reservoirBuffers],
						{myInput, crystallizationScreeningMethod, "ReservoirBuffers", index, Null, reservoirBuffers},
						Nothing
					],
					If[MatchQ[crystallizationScreeningMethod, Custom] && NullQ[additives],
						{myInput, crystallizationScreeningMethod, "Additives", index, Null, additives},
						Nothing
					],
					If[MatchQ[crystallizationScreeningMethod, Custom] && NullQ[coCrystallizationReagents],
						{myInput, crystallizationScreeningMethod, "CoCrystallizationReagents", index, Null, coCrystallizationReagents},
						Nothing
					]
				}
			],
			{myInputs, resolvedCrystallizationScreeningMethod, resolvedReservoirBuffers, resolvedAdditives, resolvedCoCrystallizationReagents, Range[Length[myInputs]]}
		],
		1
	];

	conflictingScreeningMethodInputs = DeleteDuplicates[conflictingScreeningMethodErrors[[All, 1]]]
	;
	If[Length[conflictingScreeningMethodErrors]>0 && messagesQ,
		Message[
			Error::ConflictingScreeningMethodWithBuffers,
			ObjectToString[conflictingScreeningMethodErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingScreeningMethodErrors[[All, 2]], Cache -> cacheBall],
			conflictingScreeningMethodErrors[[All, 3]],
			conflictingScreeningMethodErrors[[All, 4]],
			ObjectToString[conflictingScreeningMethodErrors[[All, 5]], Cache -> cacheBall],
			ObjectToString[conflictingScreeningMethodErrors[[All, 6]], Cache -> cacheBall]
		]
	];

	conflictingScreeningMethodTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingScreeningMethodErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingScreeningMethodInputs], Cache -> cacheBall] <> " have method matches with option values of screening reagents:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingScreeningMethodErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingScreeningMethodInputs, Cache -> cacheBall] <> " have method matches with option values of screening reagents:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingScreeningMethodWithStrategy *)
	(* CrystallizationScreeningMethod & CrystallizationStrategy conflict. *)
	conflictingScreeningMethodStrategyErrors = MapThread[
		Function[{myInput, crystallizationScreeningMethod, index},
			(* No method should be given when CrystallizationStrategy is Preparation. Only one condition should output per sample in this case. *)
			If[MatchQ[resolvedCrystallizationStrategy, Preparation] && !MatchQ[crystallizationScreeningMethod, None],
				{myInput, crystallizationScreeningMethod, index, resolvedCrystallizationStrategy},
				Nothing
			]
		],
		{myInputs, resolvedCrystallizationScreeningMethod, Range[Length[myInputs]]}
	];

	If[Length[conflictingScreeningMethodStrategyErrors]>0 && messagesQ,
		Message[
			Error::ConflictingScreeningMethodWithStrategy,
			ObjectToString[conflictingScreeningMethodStrategyErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingScreeningMethodStrategyErrors[[All, 2]], Cache -> cacheBall],
			conflictingScreeningMethodStrategyErrors[[All, 3]],
			resolvedCrystallizationStrategy
		]
	];

	conflictingScreeningMethodStrategyTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingScreeningMethodErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingScreeningMethodStrategyErrors[[All, 1]]], Cache -> cacheBall] <> " have CrystallizationScreeningMethod matched with CrystallizationStrategy " <> ObjectToString[resolvedCrystallizationStrategy, Cache -> cacheBall]":", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingScreeningMethodErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingScreeningMethodStrategyErrors[[All, 1]], Cache -> cacheBall] <> " have CrystallizationScreeningMethod mismatched with CrystallizationStrategy " <> ObjectToString[resolvedCrystallizationStrategy, Cache -> cacheBall]":", True, False]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingSampleVolumes *)
	(* For an unprepared plate, SampleVolumes must below the MaxVolume of drop well and match with Strategy. *)
	(* For a prepared plate, we have checked SampleVolumes already in Error::InvalidPreparedPlateVolume. *)
	conflictingSampleVolumesErrors = Module[{upperVolumeThreshold, lowerVolumeThreshold, preparingSampleVolumeErrors},
		upperVolumeThreshold = If[MatchQ[resolvedCrystallizationStrategy, Screening],
			Min[maxResolvedPlateDropVolume, $CrystallizationScreeningVolumeThreshold],(*1 Microliter*)
			maxResolvedPlateDropVolume
		];
		lowerVolumeThreshold = If[MatchQ[resolvedCrystallizationStrategy, Screening],
			0 Nanoliter,
			$CrystallizationScreeningVolumeThreshold
		];
		preparingSampleVolumeErrors = MapThread[
			Function[{myInput, sampleVolumes, index},
				If[And[
					MatchQ[resolvedPreparedPlate, False],
					!NullQ[sampleVolumes],
					!MatchQ[sampleVolumes, {RangeP[lowerVolumeThreshold, upperVolumeThreshold]..}]
				],
					{myInput, Cases[sampleVolumes, LessP[lowerVolumeThreshold]|GreaterP[upperVolumeThreshold]], index},
					Nothing
				]
			],
			{myInputs, resolvedSampleVolumes, Range[Length[myInputs]]}
		];

		If[Length[preparingSampleVolumeErrors]>0 && messagesQ,
			Message[Error::ConflictingSampleVolumes,
				ObjectToString[preparingSampleVolumeErrors[[All, 1]], Cache -> cacheBall],
				preparingSampleVolumeErrors[[All, 2]],
				preparingSampleVolumeErrors[[All, 3]],
				lowerVolumeThreshold,
				upperVolumeThreshold
			]
		];

		(* Return the Errors. *)
		preparingSampleVolumeErrors
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingSampleVolumesTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingSampleVolumesErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingSampleVolumesErrors[[All, 1]]], Cache -> cacheBall] <> " have matching DilutionBufferVolume and DilutionBuffer:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingSampleVolumesErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingSampleVolumesErrors[[All, 1]], Cache -> cacheBall] <> " have matching DilutionBufferVolume and DilutionBuffer:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingDilutionBuffer *)
	(* Check for conflicting dilution buffer options. *)
	conflictingDilutionBufferErrors = MapThread[
		Function[{myInput, dilutionBuffer, dilutionBufferVolume, index},
			If[
				Or[
					!MatchQ[dilutionBuffer, None|Null] && NullQ[dilutionBufferVolume],
					!MatchQ[dilutionBuffer, None|Null] && GreaterQ[dilutionBufferVolume, maxResolvedPlateDropVolume],
					MatchQ[dilutionBuffer, None|Null] && !NullQ[dilutionBufferVolume]
				],
				{myInput, dilutionBuffer, dilutionBufferVolume, index},
				Nothing
			]
		],
		{myInputs, resolvedDilutionBuffer, resolvedDilutionBufferVolume, Range[Length[myInputs]]}
	];

	If[Length[conflictingDilutionBufferErrors]>0 && messagesQ,
		Message[
			Error::ConflictingDilutionBuffer,
			ObjectToString[conflictingDilutionBufferErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingDilutionBufferErrors[[All, 2]], Cache -> cacheBall],
			conflictingDilutionBufferErrors[[All, 3]],
			conflictingDilutionBufferErrors[[All, 4]],
			maxResolvedPlateDropVolume
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingDilutionBufferTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingDilutionBufferErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingDilutionBufferErrors[[All, 1]]], Cache -> cacheBall] <> " have matching DilutionBufferVolume and DilutionBuffer:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingDilutionBufferErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingDilutionBufferErrors[[All, 1]], Cache -> cacheBall] <> " have matching DilutionBufferVolume and DilutionBuffer:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingReservoirOptions *)
	(* Check for conflicting reservoir options. *)
	conflictingReservoirErrors = MapThread[
		Function[{myInput, reservoirBuffers, reservoirBufferVolume, reservoirDropVolume, index},
			If[
				Or[
					MatchQ[reservoirBufferVolume, VolumeP] && GreaterQ[reservoirBufferVolume, maxResolvedPlateReservoirVolume],
					MatchQ[reservoirDropVolume, VolumeP] && GreaterQ[reservoirDropVolume, maxResolvedPlateDropVolume],
					!NullQ[reservoirBufferVolume] && MatchQ[reservoirBuffers, None|Null],
					MatchQ[reservoirBuffers, {ObjectP[]..}] && NullQ[reservoirBufferVolume] && NullQ[reservoirDropVolume],
					GreaterQ[Length[reservoirBuffers], 1] && !NullQ[reservoirBufferVolume] && NullQ[reservoirDropVolume]
				],
				{myInput, reservoirBuffers, reservoirBufferVolume, reservoirDropVolume, index},
				Nothing
			]
		],
		{myInputs, resolvedReservoirBuffers, resolvedReservoirBufferVolume, resolvedReservoirDropVolume, Range[Length[myInputs]]}
	];

	If[Length[conflictingReservoirErrors]>0 && messagesQ,
		Message[
			Error::ConflictingReservoirOptions,
			ObjectToString[conflictingReservoirErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingReservoirErrors[[All, 2]], Cache -> cacheBall],
			conflictingReservoirErrors[[All, 3]],
			conflictingReservoirErrors[[All, 4]],
			conflictingReservoirErrors[[All, 5]],
			maxResolvedPlateReservoirVolume,
			maxResolvedPlateDropVolume
		]
	];

	conflictingReservoirTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingReservoirErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingReservoirErrors[[All, 1]]], Cache -> cacheBall] <> " have matching ReservoirBuffers and ReservoirBufferVolume/ReservoirDropVolume:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingReservoirErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingReservoirErrors[[All, 1]], Cache -> cacheBall] <> " have matching ReservoirBuffers and ReservoirBufferVolume/ReservoirDropVolume:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingCoCrystallizationReagents *)
	(* Check for conflicting seeding solution options. *)
	conflictingCoCrystallizationReagentsErrors = MapThread[
		Function[{myInput, coCrystallizationReagents, coCrystallizationReagentsVolume, index},
			If[
				Or[
					!MatchQ[coCrystallizationReagents, None|Null] && NullQ[coCrystallizationReagentsVolume],
					!MatchQ[coCrystallizationReagents, None|Null] && GreaterQ[coCrystallizationReagentsVolume, maxResolvedPlateDropVolume],
					MatchQ[coCrystallizationReagents, None|Null] && !NullQ[coCrystallizationReagentsVolume]
				],
				{myInput, coCrystallizationReagents, coCrystallizationReagentsVolume, index},
				Nothing
			]
		],
		{myInputs, resolvedCoCrystallizationReagents, resolvedCoCrystallizationReagentVolume, Range[Length[myInputs]]}
	];

	If[Length[conflictingCoCrystallizationReagentsErrors]>0 && messagesQ,
		Message[
			Error::ConflictingCoCrystallizationReagents,
			ObjectToString[conflictingCoCrystallizationReagentsErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingCoCrystallizationReagentsErrors[[All, 2]], Cache -> cacheBall],
			conflictingCoCrystallizationReagentsErrors[[All, 3]],
			conflictingCoCrystallizationReagentsErrors[[All, 4]],
			maxResolvedPlateDropVolume
		]
	];

	conflictingCoCrystallizationReagentsTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingCoCrystallizationReagentsErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingCoCrystallizationReagentsErrors[[All, 1]]], Cache -> cacheBall] <> " have matching CoCrystallizationReagents and CoCrystallizationReagentVolume:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingCoCrystallizationReagentsErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingCoCrystallizationReagentsErrors[[All, 1]], Cache -> cacheBall] <> " have matching CoCrystallizationReagents and CoCrystallizationReagentVolume:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingCoCrystallizationAirDry *)
	(* CoCrystallizationAirDryTime must be Null for all the samples with CoCrystallizationAirDry False. *)
	(* CoCrystallizationAirDryTemperature must be Null for all the samples with CoCrystallizationAirDry False. *)
	conflictingCoCrystallizationAirDryErrors = Join[
		(* If user has not specified any CoCrystallizationReagents in either ScreeningMethod file or in CoCrystallizationReagents option, *)
		(* but has specified any CoCrystallizationAirDry related options, throws an error. *)
		MapThread[
			If[
				MatchQ[#2, Null|None] && MatchQ[#3, True],
				{#1, #2, "CoCrystallizationReagents", "CoCrystallizationAirDry"},
				Nothing
			]&,
			{myInputs, resolvedCoCrystallizationReagents, resolvedCoCrystallizationAirDry}
		],
		{
			If[
				And[
					!MemberQ[resolvedCoCrystallizationReagents, {ObjectP[]..}],
					!NullQ[resolvedCoCrystallizationAirDryTime]
				],
				{resolvedCoCrystallizationReagents, resolvedCoCrystallizationAirDryTime, "CoCrystallizationReagents", "CoCrystallizationAirDryTime"},
				Nothing
			],
			If[
				And[
					!MemberQ[resolvedCoCrystallizationReagents, {ObjectP[]..}],
					!NullQ[resolvedCoCrystallizationAirDryTemperature]
				],
				{resolvedCoCrystallizationReagents, resolvedCoCrystallizationAirDryTemperature, "CoCrystallizationReagents", "CoCrystallizationAirDryTemperature"},
				Nothing
			],
			(* If user has specified to air dry CoCrystallizationReagents in either ScreeningMethod file or in CoCrystallizationReagents option *)
			(* for at least one input sample, but there is no value CoCrystallizationAirDry time or temperature, throws an error. *)
			If[
				And[
					MemberQ[resolvedCoCrystallizationAirDry, True],
					NullQ[resolvedCoCrystallizationAirDryTime]
				],
				{resolvedCoCrystallizationAirDry, resolvedCoCrystallizationAirDryTime, "CoCrystallizationAirDry", "CoCrystallizationAirDryTime"},
				Nothing
			],
			If[
				And[
					MatchQ[resolvedCoCrystallizationAirDry, {False..}],
					!NullQ[resolvedCoCrystallizationAirDryTime]
				],
				{resolvedCoCrystallizationAirDry, resolvedCoCrystallizationAirDryTime, "CoCrystallizationAirDry", "CoCrystallizationAirDryTime"},
				Nothing
			],
			If[
				And[
					MemberQ[resolvedCoCrystallizationAirDry, True],
					NullQ[resolvedCoCrystallizationAirDryTemperature]
				],
				{resolvedCoCrystallizationAirDry, resolvedCoCrystallizationAirDryTemperature, "CoCrystallizationAirDry", "CoCrystallizationAirDryTemperature"},
				Nothing
			],
			If[
				And[
					MatchQ[resolvedCoCrystallizationAirDry, {False..}],
					!MatchQ[resolvedCoCrystallizationAirDryTemperature, Automatic|Null]
				],
				{resolvedCoCrystallizationAirDry, resolvedCoCrystallizationAirDryTemperature, "CoCrystallizationAirDry", "CoCrystallizationAirDryTemperature"},
				Nothing
			],
			(* If user has specified to air dry temperature higher than $AmbientTemperature for longer than an hour, throws an error. *)
			If[
				And[
					GreaterQ[resolvedCoCrystallizationAirDryTemperature, $AmbientTemperature + 1 Celsius],
					GreaterQ[resolvedCoCrystallizationAirDryTime, 1 Hour + 1 Minute]
				],
				{resolvedCoCrystallizationAirDryTime, resolvedCoCrystallizationAirDryTemperature, "CoCrystallizationAirDryTime", "CoCrystallizationAirDryTemperature"},
				Nothing
			],
			(* If user has specified to air dry temperature higher than MaxTemperature for CrystallizationPlate, throws an error. *)
			If[GreaterQ[resolvedCoCrystallizationAirDryTemperature, Lookup[resolvedPlateModelPacket, MaxTemperature]],
				{resolvedCrystallizationPlate, Lookup[partiallyRoundedGrowCrystalOptions , CoCrystallizationAirDryTemperature], "CrystallizationPlate", "CoCrystallizationAirDryTemperature"},
				Nothing
			],
			(* If there are multiple input samples and user has specified different transfer models for step1 air dry, throws an error. *)
			Module[{airDryCoCrystallizationReagentVolume, groupedCoCrystallizationReagentVolume},
				airDryCoCrystallizationReagentVolume = If[!MemberQ[resolvedCoCrystallizationAirDry, Null],
					Cases[PickList[resolvedCoCrystallizationReagentVolume, resolvedCoCrystallizationAirDry, True], VolumeP],
					{}
				];
				groupedCoCrystallizationReagentVolume = If[LessQ[Min[airDryCoCrystallizationReagentVolume], $RoboticTransferVolumeThreshold],(*1 Microliter*)
					GatherBy[airDryCoCrystallizationReagentVolume, GreaterEqualQ[#, First[Cases[Lookup[Cases[dropSetterInstrumentPackets, KeyValuePattern[{Type -> Model[Instrument, LiquidHandler, AcousticLiquidHandler]}]], MaxVolume], VolumeP]]]&],(* MaxVolume of Echo Acoustic Liquid Handler is 5 Microliter. *)
					{airDryCoCrystallizationReagentVolume}
				];
				If[GreaterQ[Length@groupedCoCrystallizationReagentVolume, 1],
				{groupedCoCrystallizationReagentVolume[[1]], groupedCoCrystallizationReagentVolume[[2]], "CoCrystallizationReagentVolume", "CoCrystallizationReagentVolume"},
				Nothing
				]
			]
		}
	];

	If[Length[conflictingCoCrystallizationAirDryErrors]>0 && messagesQ,
		Message[
			Error::ConflictingCoCrystallizationAirDry,
			ObjectToString[conflictingCoCrystallizationAirDryErrors[[All, 1]], Cache -> cacheBall],
			conflictingCoCrystallizationAirDryErrors[[All, 2]],
			conflictingCoCrystallizationAirDryErrors[[All, 3]],
			conflictingCoCrystallizationAirDryErrors[[All, 4]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingCoCrystallizationAirDryTest = If[gatherTests,
		Test["If CoCrystallizationAirDryTime or Temperature is specified, CoCrystallizationAirDry is required for at least one sample:",
			MatchQ[conflictingCoCrystallizationAirDryErrors, {}],
			True
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];

	(* Note: The aliquoting of CoCrystallizationReagents to AirDry to Echo Source Plate generate tests and warnings. *)
	airDiredCoCrystallizationReagentsAliquotWarnings = If[MemberQ[step1BufferPreparationTable, {AirDryCoCrystallizationReagent, ___}],
		{step1BufferPreparationTable[[All, 2]], Total[Cases[resolvedDropCompositionTable, {__, #, x_, True, __}->x]]& /@step1BufferPreparationTable[[All, 2]], step1BufferPreparationTable[[All, 3]], step1BufferPreparationTable[[All, 4]]},
		{Nothing}
	];

	If[Length[airDiredCoCrystallizationReagentsAliquotWarnings]>0 && messagesQ,
		Message[
			Warning::CoCrystallizationReagentsAliquotedBeforeAirDry,
			ObjectToString[airDiredCoCrystallizationReagentsAliquotWarnings[[1]], Cache -> cacheBall],
			airDiredCoCrystallizationReagentsAliquotWarnings[[2]],
			airDiredCoCrystallizationReagentsAliquotWarnings[[3]],
			ObjectToString[airDiredCoCrystallizationReagentsAliquotWarnings[[4]], Cache -> cacheBall],
			ObjectToString[PreferredContainer[All, Type -> All, AcousticLiquidHandlerCompatible -> True], Cache -> cacheBall]
		];
	];

	(* If we are gathering tests, create test if CoCrystallizationAirDry contains True. *)
	airDiredCoCrystallizationReagentsAliquotTest = If[gatherTests && MemberQ[resolvedCoCrystallizationAirDry, True],
		Test["If CoCrystallizationAirDry is True and AcousticLiquidHandler is used to dispense CoCrystallizationReagents, CoCrystallizationReagents need to be aliquoted to AcousticLiquidHandlerCompatible container if their containers are not:",
			MatchQ[airDiredCoCrystallizationReagentsAliquotWarnings, {}],
			True
		],
		Nothing
	];


	(* Error::ConflictingSeedingSolution *)
	(* Check for conflicting seeding solution options. *)
	conflictingSeedingSolutionErrors = MapThread[
		Function[{myInput, seedingSolution, seedingSolutionVolume, index},
			If[
				Or[
					!MatchQ[seedingSolution, None|Null] && NullQ[seedingSolutionVolume],
					!MatchQ[seedingSolution, None|Null] && GreaterQ[seedingSolutionVolume, maxResolvedPlateDropVolume],
					MatchQ[seedingSolution, None|Null] && !NullQ[seedingSolutionVolume]
				],
				{myInput, seedingSolution, seedingSolutionVolume, index},
				Nothing
			]
		],
		{myInputs, resolvedSeedingSolution, resolvedSeedingSolutionVolume, Range[Length[myInputs]]}
	];

	If[Length[conflictingSeedingSolutionErrors]>0 && messagesQ,
		Message[
			Error::ConflictingSeedingSolution,
			ObjectToString[conflictingSeedingSolutionErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingSeedingSolutionErrors[[All, 2]], Cache -> cacheBall],
			conflictingSeedingSolutionErrors[[All, 3]],
			conflictingSeedingSolutionErrors[[All, 4]],
			maxResolvedPlateDropVolume
		]
	];

	conflictingSeedingSolutionTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingSeedingSolutionErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingSeedingSolutionErrors[[All, 1]]], Cache -> cacheBall] <> " have matching SeedingSolution and SeedingSolutionVolume:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingSeedingSolutionErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingSeedingSolutionErrors[[All, 1]], Cache -> cacheBall] <> " have matching SeedingSolution and SeedingSolutionVolume:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingOilOption *)
	(* Check for conflicting oil options. *)
	conflictingOilErrors = MapThread[
		Function[
			{
				myInput, oil, oilVolume, sampleVolumes, reservoirDropVolume, dilutionBufferVolume, additiveVolume,
				coCrystallizationReagentVolume, seedingSolutionVolume, coCrystallizationAirDry, index
			},
			Module[{maxTotalDropVolumeWithoutOil},
				maxTotalDropVolumeWithoutOil = If[MatchQ[coCrystallizationAirDry, True],
					Total[{Max[sampleVolumes], reservoirDropVolume, dilutionBufferVolume, additiveVolume, seedingSolutionVolume}/.Null -> 0 Nanoliter],
					Total[{Max[sampleVolumes], reservoirDropVolume, dilutionBufferVolume, additiveVolume, coCrystallizationReagentVolume, seedingSolutionVolume}/.Null -> 0 Nanoliter]
				];
				If[
					Or[
						NullQ[oil] && !NullQ[oilVolume],
						!NullQ[oil] && NullQ[oilVolume],
						(* Not enough oil to cover aqueous drop (should be at least 4 times bigger than aqueous volume). *)
						!NullQ[oil] && MatchQ[oilVolume, LessP[4*maxTotalDropVolumeWithoutOil]|GreaterP[maxResolvedPlateDropVolume]]
					],
						{myInput, oil, oilVolume, index, 4*maxTotalDropVolumeWithoutOil, maxResolvedPlateDropVolume},
						Nothing
				]
			]
		],
		{myInputs, resolvedOil, resolvedOilVolume, resolvedSampleVolumes, resolvedReservoirDropVolume, resolvedDilutionBufferVolume, resolvedAdditiveVolume,
			resolvedCoCrystallizationReagentVolume, resolvedSeedingSolutionVolume, resolvedCoCrystallizationAirDry, Range[Length[myInputs]]}
	];

	If[Length[conflictingOilErrors]>0 && messagesQ,
		Message[
			Error::ConflictingOilOption,
			ObjectToString[conflictingOilErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[conflictingOilErrors[[All, 2]], Cache -> cacheBall],
			conflictingOilErrors[[All, 3]],
			conflictingOilErrors[[All, 4]],
			conflictingOilErrors[[All, 5]],
			conflictingOilErrors[[All, 6]]
		]
	];

	conflictingOilTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingOilErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingOilErrors[[All, 1]]], Cache -> cacheBall] <> " have matching Oil and OilVolume:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingOilErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingOilErrors[[All, 1]], Cache -> cacheBall] <> " have matching Oil and OilVolume:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingTotalDropVolume *)
	(* Check for conflicting total drop volume. *)
	(* If CoCrystallizationAirDry is True, don't count CoCrystallizationReagentVolume in totalDropVolume. *)
	conflictingDropVolumeErrors = MapThread[
		Function[{myInput, sampleVolumes, reservoirDropVolume, dilutionBufferVolume, additiveVolume, coCrystallizationReagentVolume, seedingSolutionVolume, oilVolume, coCrystallizationAirDry, index},
			Module[{maxSampleVolume, minSampleVolume, maxTotalDropVolume},
				maxSampleVolume = If[Length[sampleVolumes]>0, Max[sampleVolumes], sampleVolumes];
				minSampleVolume = If[Length[sampleVolumes]>0, Min[sampleVolumes], sampleVolumes];
				maxTotalDropVolume = If[MatchQ[coCrystallizationAirDry, True],
					Total[{maxSampleVolume, reservoirDropVolume, dilutionBufferVolume, additiveVolume, seedingSolutionVolume, oilVolume}/.Null -> 0 Nanoliter],
					Total[{maxSampleVolume, reservoirDropVolume, dilutionBufferVolume, additiveVolume, coCrystallizationReagentVolume, seedingSolutionVolume, oilVolume}/.Null -> 0 Nanoliter]
				];
				If[MatchQ[resolvedPreparedPlate, False] && GreaterQ[maxTotalDropVolume, maxResolvedPlateDropVolume],
						{myInput, maxTotalDropVolume, index, resolvedCrystallizationPlate},
					Nothing
				]
			]
		],
		{myInputs, resolvedSampleVolumes, resolvedReservoirDropVolume, resolvedDilutionBufferVolume, resolvedAdditiveVolume, resolvedCoCrystallizationReagentVolume, resolvedSeedingSolutionVolume, resolvedOilVolume, resolvedCoCrystallizationAirDry, Range[Length[myInputs]]}
	];

	If[Length[conflictingDropVolumeErrors]>0 && messagesQ,
		Message[
			Error::ConflictingTotalDropVolume,
			ObjectToString[conflictingDropVolumeErrors[[All, 1]], Cache -> cacheBall],
			conflictingDropVolumeErrors[[All, 2]],
			conflictingDropVolumeErrors[[All, 3]],
			ObjectToString[conflictingDropVolumeErrors[[All, 4]], Cache -> cacheBall],
			maxResolvedPlateDropVolume
		]
	];

	conflictingDropVolumeTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			passingTest = If[Length[conflictingDropVolumeErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingDropVolumeErrors[[All, 1]]], Cache -> cacheBall] <> " have valid total drop volumes:", True, True]
			];
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingDropVolumeErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingDropVolumeErrors[[All, 1]], Cache -> cacheBall] <> " have total drop volumes larger than the MaxVolume of the plate:", False, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(*--Duplicated buffer check--*)
	duplicatedInvalidBufferErrors = If[MatchQ[resolvedPreparedPlate, False],
		MapThread[
			Function[{myInput, dilutionBuffer, seedingSolution, reservoirBuffers, coCrystallizationReagents, additives, index},
				Module[{allBuffers, duplicatedBuffers},
					allBuffers = Select[Flatten@Join[{dilutionBuffer, seedingSolution, reservoirBuffers, coCrystallizationReagents, additives}], MatchQ[#, ObjectP[]]&];
					duplicatedBuffers = Join[Select[Tally[allBuffers], Last[#]>1&][[All, 1]], Flatten[Cases[allBuffers, ObjectP[#]]& /@ myInputs]];
					If[!MatchQ[duplicatedBuffers, {}],
						{myInput, duplicatedBuffers, index},
						Nothing
					]
				]
			],
			{myInputs, resolvedDilutionBuffer, resolvedSeedingSolution, resolvedReservoirBuffers, resolvedCoCrystallizationReagents, resolvedAdditives, Range[Length[myInputs]]}],
		{Nothing}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[duplicatedInvalidBufferErrors]>0 && messagesQ,
		Message[
			Error::DuplicatedBuffers,
			ObjectToString[duplicatedInvalidBufferErrors[[All, 1]], Cache -> cacheBall],
			ObjectToString[duplicatedInvalidBufferErrors[[All, 2]], Cache -> cacheBall],
			duplicatedInvalidBufferErrors[[All, 3]]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	duplicatedBuffersTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the passing inputs. *)
			failingTest = If[Length[duplicatedInvalidBufferErrors] == 0,
				Nothing,
				Test["Specified buffers for samples " <> ObjectToString[duplicatedInvalidBufferErrors[[All, 1]], Cache -> cacheBall] <> " contain duplicated buffers:", True, False]
			];
			passingTest = If[Length[duplicatedInvalidBufferErrors] == Length[myInputs],
				Nothing,
				Test["Specified buffers for samples " <> ObjectToString[Complement[myInputs, duplicatedInvalidBufferErrors[[All, 1]]], Cache -> cacheBall] <> " do not contain duplicated buffers:", True, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(*--Discarded buffer check--*)
	(* Get the buffers that are discarded. *)
	allBufferObjects = Cases[DeleteDuplicates[Flatten@Join[resolvedReservoirBuffers, resolvedDilutionBuffer, resolvedAdditives, resolvedCoCrystallizationReagents, resolvedSeedingSolution, resolvedOil]], ObjectP[Object[Sample]]];
	discardedInvalidBuffers = If[MatchQ[resolvedPreparedPlate, False],
		PickList[allBufferObjects, fastAssocLookup[fastAssoc, #, Status]& /@ allBufferObjects, Discarded],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[discardedInvalidBuffers]>0 && messagesQ,
		Message[Error::DiscardedBuffers, ObjectToString[discardedInvalidBuffers, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedBufferTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidBuffers] == 0,
				Nothing,
				Test["Our buffers " <> ObjectToString[discardedInvalidBuffers, Cache -> cacheBall] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidBuffers] == Length[allBufferObjects],
				Nothing,
				Test["Our buffers " <> ObjectToString[Complement[allBufferObjects, discardedInvalidBuffers], Cache -> cacheBall] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],

		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(*--Deprecated Buffer check--*)
	(* Get the buffers that will be checked for whether they are deprecated. *)
	allBufferModels = Cases[DeleteDuplicates[Flatten@Join[resolvedReservoirBuffers, resolvedDilutionBuffer, resolvedAdditives, resolvedCoCrystallizationReagents, resolvedSeedingSolution, resolvedOil]], ObjectP[Model[Sample]]];
	(* Get the deprecatedInvalidBufferModels; if on the FastTrack, skip this check. *)
	deprecatedInvalidBufferModels = If[!fastTrack && MatchQ[resolvedPreparedPlate, False],
		Join[
			PickList[allBufferObjects, fastAssocLookup[fastAssoc, #, {Model, Deprecated}]& /@ allBufferObjects, True],
			PickList[allBufferModels, fastAssocLookup[fastAssoc, #, Deprecated]& /@ allBufferModels, True]
		],
		{}
	];

	(* If there are invalid buffers and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[deprecatedInvalidBufferModels]>0 && messagesQ,
		Message[Error::DeprecatedBufferModels, ObjectToString[deprecatedInvalidBufferModels, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedBufferTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidBufferModels] == 0,
				Nothing,
				Test["Our input buffers have models " <> ObjectToString[deprecatedInvalidBufferModels, Cache -> cacheBall] <> " that are not deprecated:", True, False]
			];
			passingTest = If[Length[deprecatedInvalidBufferModels] == Length[Join[allBufferObjects, allBufferModels]],
				Nothing,
				Test["Our input buffers have models " <> ObjectToString[Complement[Join[Download[Download[allBufferObjects, Model, cache -> cacheBall], Object], allBufferModels], deprecatedInvalidBufferModels], Cache -> cacheBall] <> " that are not deprecated:", True, True]
			];
			{failingTest, passingTest}
		],

		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(*--Solid buffer check--*)
	(* Make sure the buffers are liquid. *)
	(* Get the buffers that are not liquid. *)
	nonLiquidBuffers = If[MatchQ[resolvedPreparedPlate, False],
		Join[
			PickList[allBufferObjects, fastAssocLookup[fastAssoc, #, State]& /@ allBufferObjects, Except[Liquid]],
			PickList[allBufferModels, fastAssocLookup[fastAssoc, #, State]& /@ allBufferModels, Except[Liquid]]
		],
		{}
	];

	(* If there are invalid buffers and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid buffers. *)
	If[Length[nonLiquidBuffers]>0 && messagesQ,
		Message[Error::NonLiquidBuffers, ObjectToString[nonLiquidBuffers, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonLiquidBufferTest = If[And[
			gatherTests,
			!MatchQ[allBufferObjects, {}] || !MatchQ[allBufferModels, {}]
		],
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidBuffers] == 0,
				Nothing,
				Test["Our buffers " <> ObjectToString[nonLiquidBuffers, Cache -> cacheBall] <> " are liquid:", True, False]
			];
			passingTest = If[Length[nonLiquidBuffers] == Length[simulatedSamples],
				Nothing,
				Test["Our buffers " <> ObjectToString[Complement[Join[Download[Download[allBufferObjects, Model, cache -> cacheBall], Object], allBufferModels], nonLiquidBuffers], Cache -> cacheBall] <> " are liquid:", True, True]
			];

			{failingTest, passingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingDropDestination *)
	(* Check for conflicting DropDestination. *)
	conflictingDropDestinationErrors = MapThread[
		Function[{sample, samplePacket, dropDestination, validDropDestination, index, sampleVolumes, reservoirBuffers, reservoirDropVolume, additives, coCrystallizationReagents},
			Module[{numberOfCrystalConditions},
				numberOfCrystalConditions = Which[
					MatchQ[resolvedPreparedPlate, True],
						If[!StringContainsQ[Lookup[samplePacket, Position], "Reservoir"],
							1,
							0
						],
					MatchQ[reservoirDropVolume, VolumeP],
						Length[ToList@sampleVolumes] * Length[ToList@reservoirBuffers] * Length[ToList@additives] * Length[ToList@coCrystallizationReagents],
					True,
						Length[ToList@sampleVolumes] * Length[ToList@additives] * Length[ToList@coCrystallizationReagents]
				];
				If[Or[
					MatchQ[validDropDestination, False],
					validPreparedPlateContainerQ && !NullQ[dropDestination] && !SubsetQ[DeleteDuplicates@Lookup[resolvedPlateModelPacket, WellContents], dropDestination]
				],
					{sample, dropDestination, numberOfCrystalConditions, index},
					Nothing
				]
			]
		],
		{myInputs, samplePackets, resolvedDropDestination, indexedDropDestinationCheck, Range[Length[myInputs]], resolvedSampleVolumes, resolvedReservoirBuffers, resolvedReservoirDropVolume, resolvedAdditives, resolvedCoCrystallizationReagents}
	];

	If[Length[conflictingDropDestinationErrors]>0 && messagesQ,
		Message[
			Error::ConflictingDropDestination,
			ObjectToString[conflictingDropDestinationErrors[[All, 1]], Cache -> cacheBall],
			conflictingDropDestinationErrors[[All, 2]],
			conflictingDropDestinationErrors[[All, 3]],
			conflictingDropDestinationErrors[[All, 4]],
			ObjectToString[resolvedCrystallizationPlate, Cache -> cacheBall],
			Cases[DeleteDuplicates@Lookup[resolvedPlateModelPacket, WellContents],	Except[Reservoir]]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingDropDestinationTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingDropDestinationErrors] == 0,
				Nothing,
				Test["Samples " <> ObjectToString[conflictingDropDestinationErrors[[All, 1]], Cache -> cacheBall] <> " have DropDestination assigned not correctly:", True, False]
			];
			(* Create a test for the non-passing inputs. *)
			passingTest = If[Length[conflictingDropDestinationErrors] == Length[myInputs],
				Nothing,
				Test["Samples " <> ObjectToString[Complement[myInputs, conflictingDropDestinationErrors[[All, 1]]], Cache -> cacheBall] <> " have DropDestination assigned correctly:", True, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::ConflictingSamplesOutLabel *)
	(* Check for conflicting label options. *)
	(* NOTE: Invalid DropDestination will result in invalid DropSamplesOutLabel as well.*)
	(* If the conflictingSamplesOutLabel is resolved from user-specified invalid DropDestination, *)
	(* We do not throw error since fixing DropDestination will automatically fix labels. *)
	(* If the conflictingSamplesOutLabel is directly specified by the user, we throw error message. *)
	(* The format of indexedSamplesOutLabelingCheck is {True/False, expectedNumberOfDropSamplesOutLabel, expectedNumberOfReservoirSamplesOutLabel} *)
	conflictingLabelErrors = MapThread[
		Function[{sample, dropSamplesOutLabel, reservoirSamplesOutLabel, validLabeling, index, userSpecifiedOptions},
			If[And[
					MatchQ[validLabeling[[1]], False],
					Or[
						MatchQ[Lookup[userSpecifiedOptions, DropSamplesOutLabel], Except[Automatic]],
						MatchQ[Lookup[userSpecifiedOptions, ReservoirSamplesOutLabel], Except[Automatic]]
					]
				],
				{sample, Length@dropSamplesOutLabel, Length@reservoirSamplesOutLabel, index, validLabeling[[2]],validLabeling[[3]] },
				Nothing
			]
		],
		{myInputs, resolvedDropSamplesOutLabel, resolvedReservoirSamplesOutLabel, indexedSamplesOutLabelingCheck, Range[Length[myInputs]], mapThreadFriendlyOptions}
	];

	If[Length[conflictingLabelErrors]>0 && messagesQ,
		Message[
			Error::ConflictingSamplesOutLabel,
			ObjectToString[conflictingLabelErrors[[All, 1]], Cache -> cacheBall],
			conflictingLabelErrors[[All, 2]],
			conflictingLabelErrors[[All, 3]],
			conflictingLabelErrors[[All, 4]],
			conflictingLabelErrors[[All, 5]],
			conflictingLabelErrors[[All, 6]]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingLabelTest = If[gatherTests,
		(* We're gathering tests.Create the appropriate tests. *)
		Module[{passingTest, failingTest},
			(* Create a test for the non-passing inputs. *)
			failingTest = If[Length[conflictingLabelErrors] == 0,
				Nothing,
				Test["SamplesOutLabel for " <> ObjectToString[conflictingLabelErrors[[All, 1]], Cache -> cacheBall] <> " are not labeled correctly:", True, False]
			];
			(* Create a test for the non-passing inputs. *)
			passingTest = If[Length[conflictingLabelErrors] == Length[myInputs],
				Nothing,
				Test["SamplesOutLabel for " <> ObjectToString[Complement[myInputs, conflictingLabelErrors[[All, 1]]], Cache -> cacheBall] <> " are labeled correctly:", True, True]
			];
			(* Return our created tests. *)
			{passingTest, failingTest}
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Error::GrowCrystalTooManyCondition *)
	(* Check for too many conditions (combinations of samples and buffers). *)
	tooManyConditionsErrors = If[
		And[
			MatchQ[resolvedPreparedPlate, False],
			MatchQ[tooManySamplesQ, False],
			!NullQ[resolvedDropSamplesOutLabel],
			MatchQ[indexedSamplesOutLabelingCheck[[All, 1]], {True..}],
			Or[
				GreaterQ[Length[Flatten@Cases[resolvedDropSamplesOutLabel, {___}]], numberOfDropWells],
				GreaterQ[Length[Flatten@Cases[resolvedReservoirSamplesOutLabel, {___}]], numberOfReservoirWells],
				GreaterQ[Total[indexedNumberOfSubdivisions], Length[Lookup[resolvedPlateModelPacket, HeadspaceSharingWells]]]
			]
		],
			{
				Length[Flatten@Cases[resolvedDropSamplesOutLabel, {___}]],
				numberOfDropWells,
				Length[Flatten@Cases[resolvedReservoirSamplesOutLabel, {___}]],
				numberOfReservoirWells,
				Total[indexedNumberOfSubdivisions],
				Length[Lookup[resolvedPlateModelPacket, HeadspaceSharingWells]]
			},
			{Nothing}
	];

	If[Length[tooManyConditionsErrors]>0 && messagesQ,
		Message[Error::GrowCrystalTooManyConditions,
			tooManyConditionsErrors[[1]],
			tooManyConditionsErrors[[2]],
			tooManyConditionsErrors[[3]],
			tooManyConditionsErrors[[4]],
			tooManyConditionsErrors[[5]],
			tooManyConditionsErrors[[6]],
			ObjectToString[resolvedCrystallizationPlate, Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyConditionsTest = If[gatherTests,
		Test["If SamplesOut is created with the combination of input samples and buffers, the number must below the maximum number of wells of the plate:",
			MatchQ[tooManyConditionsErrors, {}],
			True
		],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Warning::RiskOfEvaporation *)
	(* Check for too many transfers for drop setting step. *)
	(* PreMixing runtime does not count here since when samples are at bulk volume, evaporation can be ignored. *)
	(* Since we don't have humidifier during the transfers, the longer total transfer is, the more sample evaporates. *)
	highEvaporationErrors = Module[
		{
			allDropTransferEntries, numberOfTotalDropTransfer, dropSetterRunTime, totalTransferVolume, preMixContainerLabels
		},
		allDropTransferEntries = Cases[resolvedTransferTable, {SetDrop, __}];
		numberOfTotalDropTransfer = If[!NullQ[resolvedTransferTable],
			Length[Flatten@allDropTransferEntries[[All, 6]]],
			(* For prepared plate, set the numberOfTotalDropTransfer to 0. *)
			(* Errors leading to the empty transferTable have been checked by other tests, no need to throw another one here. *)
			0
		];
		preMixContainerLabels = DeleteDuplicates[Cases[resolvedBufferPreparationTable, {SetDrop,__}][[All, 6]]];
		Which[
		(* If TooManySamples and TooManyConditions tests failed, we don't need to throw warning for high evaporation. *)
		MatchQ[tooManySamplesQ, True]||!MatchQ[tooManyConditionsErrors, {}],
			{Nothing},
		(* Echo drop setter runtime depends on both how many transfers and how much volume. *)
		(* To break down, changing SourcePlate each time takes 1 minute. *)
		(* It is 1.25ul/s at fixed location, 2.33 mounts/s for moving to multiple destination. *)
		GreaterQ[numberOfTotalDropTransfer, 0] && MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
			totalTransferVolume = Total[#[[4]]*Length[#[[5]]]& /@ allDropTransferEntries];
			dropSetterRunTime = 1Minute*Length[preMixContainerLabels] + totalTransferVolume/(1.25 Microliter) Second + numberOfTotalDropTransfer/2.33 Second;
			If[GreaterEqualQ[dropSetterRunTime, 5 Minute],
				{ToString[dropSetterRunTime]},
				{Nothing}
			],
		(*Hamilton runtime depends on how many transfers:5s/transfer roughly. *)
		(* Since on Hamilton, we put CrystallizationPlate to HeatCool Module at 4 Celsius, the evaporation is slowed down. We extend the warning threshold to 10 Minutes. *)
		GreaterQ[numberOfTotalDropTransfer, 0] && MatchQ[resolvedDropSetterInstrument, ObjectP[]],
			dropSetterRunTime = numberOfTotalDropTransfer*5 Second;
			If[GreaterEqualQ[dropSetterRunTime, 10 Minute],
				{ToString[dropSetterRunTime]},
				{Nothing}
			],
		True,
			{Nothing}
		]
	];

	If[Length[highEvaporationErrors]>0 && messagesQ,
		Message[
			Warning::RiskOfEvaporation,
			highEvaporationErrors
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	highEvaporationTest = If[gatherTests && MatchQ[resolvedPreparedPlate, False],
		Test["If all buffers specified for drop well is transferred within 3 Minutes with Screening Strategy or 10 Minutes with Preparation or Optimization Strategy:",
			MatchQ[highEvaporationErrors, {}],
			True
		],
		(* We aren't gathering tests or not transferring samples. No tests to create. *)
		Nothing
	];


	(*--- OPTION PRECISION CHECKS AND ALIQUOT CHECKS ---*)
	(* Note: The rounding of the volumes (SampleVolumes, DilutionBufferVolume, ReservoirDropVolume, AdditiveVolume, *)
	(* CoCrystallizationReagentVolume, and SeedingSolutionVolume) has already been executed in the mapThreadOptions. *)
	(* Here we generate tests and warnings of the RoundOptionPrecision outside of the MapThread *)
	volumeRoundingWarnings = Join@@MapThread[
		Function[{sample, options, roundedOptions, index},
			Module[
				{
					precisionOfDropSetter, specifiedSampleVolumes, specifiedDilutionBufferVolume, specifiedReservoirDropVolume, specifiedAdditiveVolume,
					specifiedCoCrystallizationReagentVolume, specifiedSeedingSolutionVolume, roundedSampleVolumes, roundedDilutionBufferVolume,
					roundedReservoirDropVolume, roundedAdditiveVolume, roundedCoCrystallizationReagentVolume, roundedSeedingSolutionVolume
				},
				precisionOfDropSetter = Which[
					MatchQ[resolvedDropSetterInstrument, ObjectP[{Model[Instrument, LiquidHandler, AcousticLiquidHandler], Object[Instrument, LiquidHandler, AcousticLiquidHandler]}]],
					$AcousticLiquidHandlerVolumeTransferPrecision,
					MatchQ[resolvedDropSetterInstrument, ObjectP[]],
					$LiquidHandlerVolumeTransferPrecision,
					True,
					Null
				];
				{
					specifiedSampleVolumes,
					specifiedDilutionBufferVolume,
					specifiedReservoirDropVolume,
					specifiedAdditiveVolume,
					specifiedCoCrystallizationReagentVolume,
					specifiedSeedingSolutionVolume
				} = Lookup[options,
					{
						SampleVolumes,
						DilutionBufferVolume,
						ReservoirDropVolume,
						AdditiveVolume,
						CoCrystallizationReagentVolume,
						SeedingSolutionVolume
					}
				];
				{
					roundedSampleVolumes,
					roundedDilutionBufferVolume,
					roundedReservoirDropVolume,
					roundedAdditiveVolume,
					roundedCoCrystallizationReagentVolume,
					roundedSeedingSolutionVolume
				} = Lookup[roundedOptions,
					{
						SampleVolumes,
						DilutionBufferVolume,
						ReservoirDropVolume,
						AdditiveVolume,
						CoCrystallizationReagentVolume,
						SeedingSolutionVolume
					}
				];
				{
					If[MatchQ[specifiedSampleVolumes, {VolumeP..}] && !MatchQ[specifiedSampleVolumes, roundedSampleVolumes],
						{sample, index, precisionOfDropSetter, specifiedSampleVolumes, roundedSampleVolumes, "SampleVolumes"},
						Nothing
					],
					If[MatchQ[specifiedDilutionBufferVolume, VolumeP] && !MatchQ[specifiedDilutionBufferVolume, roundedDilutionBufferVolume],
						{sample, index, precisionOfDropSetter, specifiedDilutionBufferVolume, roundedDilutionBufferVolume, "BufferVolume"},
						Nothing
					],
					If[MatchQ[specifiedReservoirDropVolume, VolumeP] && !MatchQ[specifiedReservoirDropVolume, roundedReservoirDropVolume],
						{sample, index, precisionOfDropSetter, specifiedReservoirDropVolume, roundedReservoirDropVolume, "ReservoirDropVolume"},
						Nothing
					],
					If[MatchQ[specifiedAdditiveVolume, VolumeP] && !MatchQ[specifiedAdditiveVolume, roundedAdditiveVolume],
						{sample, index, precisionOfDropSetter, specifiedAdditiveVolume, roundedAdditiveVolume, "AdditiveVolume"},
						Nothing
					],
					If[MatchQ[specifiedCoCrystallizationReagentVolume, VolumeP] && !MatchQ[specifiedCoCrystallizationReagentVolume, roundedCoCrystallizationReagentVolume],
						If[MatchQ[Lookup[roundedOptions, CoCrystallizationAirDry], True],
							{sample, index, If[GreaterEqualQ[specifiedCoCrystallizationReagentVolume, $RoboticTransferVolumeThreshold], $LiquidHandlerVolumeTransferPrecision, $AcousticLiquidHandlerVolumeTransferPrecision], specifiedCoCrystallizationReagentVolume, roundedCoCrystallizationReagentVolume, "CoCrystallizationReagentVolume"},
							{sample, index, precisionOfDropSetter, specifiedCoCrystallizationReagentVolume, roundedCoCrystallizationReagentVolume, "CoCrystallizationReagentVolume"}
						],
						Nothing
					],
					If[MatchQ[specifiedSeedingSolutionVolume, VolumeP] && !MatchQ[specifiedSeedingSolutionVolume, roundedSeedingSolutionVolume],
						{sample, index, precisionOfDropSetter, specifiedSeedingSolutionVolume, roundedSeedingSolutionVolume, "SeedingSolutionVolume"},
						Nothing
					]
				}
			]
		],
		{simulatedSamples, mapThreadFriendlyOptions, mapThreadFriendlyResolvedOptions, Range[Length[simulatedSamples]]}
	];

	If[Length[volumeRoundingWarnings]>0 && messagesQ,
		Message[
			Warning::DropVolumePrecision,
			ObjectToString[volumeRoundingWarnings[[All,1]], Cache -> cacheBall],
			volumeRoundingWarnings[[All,2]],
			volumeRoundingWarnings[[All,3]],
			volumeRoundingWarnings[[All,4]],
			volumeRoundingWarnings[[All,5]],
			volumeRoundingWarnings[[All,6]]
		];
	];

	sampleWithRoundedVolumes = DeleteDuplicates[volumeRoundingWarnings[[All,1]]];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	precisionTests2 = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[sampleWithRoundedVolumes] == 0,
				Nothing,
				Test["Our specified volumes for sample " <> ObjectToString[sampleWithRoundedVolumes, Cache -> cacheBall] <> " are automatic rounded:", True, False]
			];

			passingTest = If[Length[sampleWithRoundedVolumes] == Length[myInputs],
				Nothing,
				Test["All specified volumes for drop wells of sample " <> ObjectToString[Complement[simulatedSamples, sampleWithRoundedVolumes], Cache -> cacheBall] <> " are within the given machine resolution:", True, True]
			];

			(* Return our created tests. *)
			{failingTest, passingTest}
		],

		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Note: The preMixing of buffers with samples generate tests and warnings. *)
	(* This is only case where DropSetter is set to Hamilton LH but total buffer volume is below 1 Microliter. *)
	preMixWarnings = If[MatchQ[resolvedCrystallizationStrategy, Screening] || MatchQ[resolvedPreparedPlate, True],
		{Nothing},
		MapThread[
			Function[{sample, samplePreMixed, sampleVolumes, index, reservoirDropVolume, dilutionBufferVolume, additiveVolume, coCrystallizationReagentVolume, seedingSolutionVolume, coCrystallizationAirDry},
				Module[{totalBufferVolume},
					totalBufferVolume = If[MatchQ[coCrystallizationAirDry, True],
						Total[{reservoirDropVolume, dilutionBufferVolume, additiveVolume, seedingSolutionVolume}/.Null -> 0 Nanoliter],
						Total[{reservoirDropVolume, dilutionBufferVolume, additiveVolume, coCrystallizationReagentVolume, seedingSolutionVolume}/.Null -> 0 Nanoliter]
					];
					If[MatchQ[samplePreMixed, True],
						{sample, index, totalBufferVolume, sampleVolumes},
						Nothing
					]
				]
			],
			{simulatedSamples, preMixWithSampleRequired, resolvedSampleVolumes, Range[Length[simulatedSamples]], resolvedReservoirDropVolume, resolvedDilutionBufferVolume, resolvedAdditiveVolume, resolvedCoCrystallizationReagentVolume, resolvedSeedingSolutionVolume, resolvedCoCrystallizationAirDry}
		]
	];

	If[Length[preMixWarnings]>0 && messagesQ,
		Message[
			Warning::DropSamplePreMixed,
			ObjectToString[preMixWarnings[[All,1]], Cache -> cacheBall],
			preMixWarnings[[All,2]],
			preMixWarnings[[All,3]],
			preMixWarnings[[All,4]]
		];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	preMixTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[preMixWarnings] == 0,
				Nothing,
				Test["Crystallization Conditions for sample " <> ObjectToString[preMixWarnings[[All, 1]], Cache -> cacheBall] <> " are premixed with sample:", True, False]
			];

			passingTest = If[Length[preMixWarnings] == Length[simulatedSamples],
				Nothing,
				Test["Crystallization Conditions for sample " <> ObjectToString[Complement[simulatedSamples, preMixWarnings[[All, 1]]], Cache -> cacheBall] <> " are added to plate without premixing with sample:", True, True]
			];

			(* Return our created tests. *)
			{failingTest, passingTest}
		],

		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* NOTE: Aliquoting of buffers (with samples) to Echo Source Plate generate tests and warnings only when customer specified PreMixBuffer is False. *)
	(* If the option is Automatic, Null or True, we will aliquot without throwing message. *)
	(* Since this behaviour has been mentioned in Usage/MoreInformation already. *)
	dropAliquotWarnings = If[And[
		MatchQ[resolvedCrystallizationStrategy, Screening],
		MatchQ[Lookup[partiallyRoundedGrowCrystalOptions, PreMixBuffer], False],
		MemberQ[resolvedBufferPreparationTable, {SetDrop, __}]
		],
		{simulatedSamples, DeleteDuplicates[Cases[Flatten@Join[resolvedSeedingSolution, resolvedDilutionBuffer, PickList[resolvedCoCrystallizationReagents, resolvedCoCrystallizationAirDry, False], resolvedAdditives, PickList[resolvedReservoirBuffers, !NullQ[#]& /@ resolvedReservoirDropVolume]], ObjectP[]]], Part[First@Cases[resolvedBufferPreparationTable, {SetDrop, __}], 4]},
		{Nothing}
	];

	If[Length[dropAliquotWarnings]>0 && messagesQ,
		Message[
			Warning::DropSampleAliquoted,
			ObjectToString[dropAliquotWarnings[[1]], Cache -> cacheBall],
			ObjectToString[dropAliquotWarnings[[2]], Cache -> cacheBall],
			ObjectToString[dropAliquotWarnings[[3]], Cache -> cacheBall],
			ObjectToString[PreferredContainer[All, Type -> All, AcousticLiquidHandlerCompatible -> True], Cache -> cacheBall]
		];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	dropAliquotTest = If[gatherTests && !MatchQ[dropAliquotWarnings, {}],
		Test["Crystallization Conditions as well as samples " <> ObjectToString[Flatten@Take[dropAliquotWarnings, 2], Cache -> cacheBall] <> " are aliquoted to Echo qualified Source Plate:", True, False],
		(* We aren't gathering tests. No tests to create. *)
		Nothing
	];


	(* Resolve RequiredAliquotContainers, since no matter which drop setter we use, samples must be transferred into SBS plates or vessels accepted by the instrument *)
	(* We check if the input samples are already in liquid handler compatible container. If so, do nothing. *)
	(* If not, we need to aliquot input samples to liquid handler compatible container. *)
	{targetContainers, targetAmounts} = Transpose[
		MapThread[
			Function[{mySample, myContainerModelPacket},
				If[Or[
						MatchQ[Lookup[myContainerModelPacket, Footprint], LiquidHandlerCompatibleFootprintP],
						MatchQ[resolvedPreparedPlate, True]
					],
					(* New AutoDeck feature will check Positions field of a model and build it for Hamilton LH as long as the Footprint works. *)
					{Null, Null},
					(* We need to consider the dead volumes and scaling up of sample volume by checking BufferPreparationTable. *)
					(* We increase 10% of the amount required for aliquoting. *)
					If[!MatchQ[Cases[resolvedBufferPreparationTable, {SetDrop, ObjectP[mySample], __}], {}],
						{PreferredContainer[1.1*Total[#[[3]]*Length[Last@#]& /@Cases[resolvedBufferPreparationTable, {SetDrop, ObjectP[mySample], __}]], LiquidHandlerCompatible -> True], 1.1*Total[#[[3]]*Length[Last@#]& /@Cases[resolvedBufferPreparationTable, {ObjectP[mySample], __}]]},
						{PreferredContainer[1.1*Total[#[[4]]*Length[Last@#]& /@Cases[resolvedTransferTable, {SetDrop, LiquidHandling, ObjectP[mySample], __}]], LiquidHandlerCompatible -> True], 1.1*Total[#[[4]]*Length[Last@#]& /@Cases[resolvedTransferTable, {SetDrop, LiquidHandling, ObjectP[mySample], __}]]}
					]
				]
			],
			{simulatedSamples, sampleContainerModelPackets}
		]
	];

	(* Resolve aliquot options and make tests *)
	{resolvedAliquotOptions, aliquotTests} = Which[
		MatchQ[resolvedPreparedPlate, True] && gatherTests,
			(* we are cool with having solids here *)
			resolveAliquotOptions[
				ExperimentGrowCrystal,
				Download[myInputs, Object],
				simulatedSamples,
				ReplaceRule[myOptions, resolvedSamplePrepOptions],
				Cache -> cacheBall,
				Simulation -> simulatedCache,
				RequiredAliquotAmounts -> targetAmounts,
				RequiredAliquotContainers -> targetContainers,
				AllowSolids -> True,
				Output -> {Result, Tests}
			],
		MatchQ[resolvedPreparedPlate, True],
			(* we are cool with having solids here *)
			{
				resolveAliquotOptions[
					ExperimentGrowCrystal,
					Download[myInputs, Object],
					simulatedSamples,
					ReplaceRule[myOptions, resolvedSamplePrepOptions],
					Cache -> cacheBall,
					Simulation -> simulatedCache,
					RequiredAliquotAmounts -> targetAmounts,
					RequiredAliquotContainers -> targetContainers,
					AllowSolids -> True,
					Output -> Result],
				{}
			},
		(* we are cool with having solids here *)
		gatherTests,
			resolveAliquotOptions[
				ExperimentGrowCrystal,
				Download[myInputs, Object],
				simulatedSamples,
				ReplaceRule[myOptions, resolvedSamplePrepOptions],
				Cache -> cacheBall,
				Simulation -> simulatedCache,
				RequiredAliquotAmounts -> targetAmounts,
				RequiredAliquotContainers -> targetContainers,
				Output -> {Result, Tests}
			],
		True,
			{
				resolveAliquotOptions[
					ExperimentGrowCrystal,
					Download[myInputs, Object],
					simulatedSamples,
					ReplaceRule[myOptions, resolvedSamplePrepOptions],
					Cache -> cacheBall,
					Simulation -> simulatedCache,
					RequiredAliquotAmounts -> targetAmounts,
					RequiredAliquotContainers -> targetContainers,
					Output -> Result],
				{}
			}
	];


	(*---Call CompatibleMaterialsQ to determine if the instruments and buffers are chemically compatible with each other---*)
	{compatibleMaterialsBool1, compatibleMaterialsTests1} = Which[
		gatherTests && !NullQ[resolvedDropSetterInstrument],
			CompatibleMaterialsQ[resolvedDropSetterInstrument, If[!MatchQ[allBufferObjects, {}], Join[simulatedSamples, allBufferObjects], simulatedSamples], Output -> {Result, Tests}, Simulation -> simulatedCache, Cache -> cacheBall],
		!gatherTests && !NullQ[resolvedDropSetterInstrument],
			{CompatibleMaterialsQ[resolvedDropSetterInstrument, If[!MatchQ[allBufferObjects, {}], Join[simulatedSamples, allBufferObjects], simulatedSamples], Messages -> messagesQ, Simulation -> simulatedCache, Cache -> cacheBall], {}},
		True,
			{True, {}}
	];
	{compatibleMaterialsBool2, compatibleMaterialsTests2} = Which[
		gatherTests && !NullQ[resolvedReservoirDispensingInstrument],
			CompatibleMaterialsQ[resolvedReservoirDispensingInstrument, If[!MatchQ[allBufferObjects, {}], Join[simulatedSamples, allBufferObjects], simulatedSamples], Output -> {Result, Tests}, Simulation -> simulatedCache, Cache -> cacheBall],
		!gatherTests && !NullQ[resolvedReservoirDispensingInstrument],
			{CompatibleMaterialsQ[resolvedReservoirDispensingInstrument, If[!MatchQ[allBufferObjects, {}], Join[simulatedSamples, allBufferObjects], simulatedSamples], Messages -> messagesQ, Simulation -> simulatedCache, Cache -> cacheBall], {}},
		True,
			{True, {}}
	];

	compatibleMaterialsTests = Join[compatibleMaterialsTests1, compatibleMaterialsTests2];

	(* If the materials are incompatible, then return the option. *)
	compatibleMaterialsInvalidOption = Which[
		!compatibleMaterialsBool1 && messagesQ,
			{DropSetterInstrument},
		!compatibleMaterialsBool2 && messagesQ,
			{ReservoirDispensingInstrument},
		True,
			{}
	];


	(*---SHARED OPTIONS AND CHECKS---*)

	(* Get the options needed to resolve Email and Operator and to check for Error::DuplicateName. *)
	{
		specifiedOperator,
		upload,
		specifiedEmail,
		specifiedName
	} = Lookup[myOptions, {Operator, Upload, Email, Name}];

	(* Adjust the email option based on the upload option *)
	resolvedEmail = If[!MatchQ[specifiedEmail, Automatic],
		specifiedEmail,
		upload && MemberQ[output, Result]
	];

	(* Resolve the operator option. *)
	resolvedOperator = If[NullQ[specifiedOperator], Model[User, Emerald, Operator, "Level 2"], specifiedOperator];

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameInvalidBool = StringQ[specifiedName] && TrueQ[DatabaseMemberQ[Append[Object[Protocol, GrowCrystal], specifiedName]]];

	(* NOTE: unique *)
	(* If the name is invalid, will add it to the list if invalid options later. *)
	nameInvalidOption = If[nameInvalidBool && messagesQ,
		(
			Message[Error::DuplicateName, Object[Protocol, GrowCrystal]];
			{Name}
		),
		{}
	];
	nameInvalidTest = If[gatherTests,
		Test["The specified Name is unique:", False, nameInvalidBool],
		Nothing
	];

	(* Get the final resolved options  *)
	resolvedAllOptions = ReplaceRule[
		myOptions,
		Join[
			{
				Name -> specifiedName,
				Email -> resolvedEmail,
				Operator -> resolvedOperator
			},
			resolvedOptions,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions
		]
	];

	(*-- SUMMARY OF CHECKS --*)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		nonLiquidInvalidInputs,
		tooManySamplesInvalidInputs,
		plateInvalidSampleInputs,
		preparedPlateInvalidContainerInputs,
		preparedPlateInvalidVolumeInputs[[All, 1]]
	}]];

	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOption,
		If[Length[preparedOnlyError]>0,
			{PreparedPlate},
			Nothing
		],
		If[Length[conflictingCrystallizationTechniqueWithPlateErrors]>0,
			{CrystallizationTechnique, CrystallizationPlate},
			Nothing
		],
		If[Length[conflictingCrystallizationPlateWithInstrumentErrors]>0,
			{CrystallizationPlate},
			Nothing
		],
		If[Length[conflictingCrystallizationTechniqueWithPreparationErrors]>0,
			{CrystallizationTechnique},
			Nothing
		],
		If[Length[conflictingDropSetterWithStrategyErrors]>0,
			{DropSetterInstrument},
			Nothing
		],
		If[Length[conflictingReservoirDispenserWithTechniqueErrors]>0,
			{ReservoirDispensingInstrument},
			Nothing
		],
		If[Length[conflictingDropSetterWithReservoirDispenserErrors]>0,
			{DropSetterInstrument, ReservoirDispensingInstrument},
			Nothing
		],
		If[Length[conflictingUVImaging]>0,
			{UVImaging},
			Nothing
		],
		If[Length[conflictingCrossPolarizedImaging]>0,
			{CrossPolarizedImaging},
			Nothing
		],
		If[Length[conflictingVisibleLightImagingErrors]>0,
			{CrystallizationCover, CrystallizationPlate},
			Nothing
		],
		If[Length[conflictingPreMixBuffer]>0,
			{PreMixBuffer, PreparedPlate},
			Nothing
		],
		If[Length[conflictingCoverContainerErrors]>0,
			{CrystallizationCover, CrystallizationPlate},
			Nothing
		],
		If[Length[invalidInstrumentModels]>0,
			{DropSetterInstrument, ReservoirDispensingInstrument},
			Nothing
		],
		If[Length[conflictingPreparedPlateWithInstrumentErrors]>0,
			{PreparedPlate},
			Nothing
		],
		If[Length[conflictingPreparedPlateWithPreparationErrors]>0,
			{PreparedPlate},
			Nothing
		],
		If[Length[conflictingPreparedPlateWithCrystallizationPlateErrors]>0,
			{PreparedPlate},
			Nothing
		],
		If[Length[conflictingSampleVolumesErrors]>0,
			{SampleVolumes},
			Nothing
		],
		If[Length[conflictingCoCrystallizationAirDryErrors]>0,
			{CoCrystallizationAirDry},
			Nothing
		],
		If[Length[conflictingCoCrystallizationReagentsErrors]>0,
			{CoCrystallizationReagents},
			Nothing
		],
		If[Length[conflictingDilutionBufferErrors]>0,
			{DilutionBuffer},
			Nothing
		],
		If[Length[conflictingSeedingSolutionErrors]>0,
			{SeedingSolution},
			Nothing
		],
		If[Length[conflictingOilErrors]>0,
			{Oil},
			Nothing
		],
		If[Length[conflictingScreeningMethodErrors]>0,
			{CrystallizationScreeningMethod},
			Nothing
		],
		If[Length[conflictingScreeningMethodStrategyErrors]>0,
			{CrystallizationScreeningMethod, CrystallizationStrategy},
			Nothing
		],
		If[Length[conflictingDropVolumeErrors]>0,
			{SampleVolumes},
			Nothing
		],
		If[Length[conflictingReservoirErrors]>0,
			{ReservoirBuffers},
			Nothing
		],
		If[Length[conflictingLabelErrors]>0,
			{DropSamplesOutLabel, ReservoirSamplesOutLabel},
			Nothing
		],
		If[Length[duplicatedInvalidBufferErrors]>0,
			{ReservoirBuffers, Additives, CoCrystallizationReagents, DilutionBuffer, SeedingSolution},
			Nothing
		],
		If[Length[discardedInvalidBuffers]>0,
			{ReservoirBuffers, Additives, CoCrystallizationReagents, DilutionBuffer, SeedingSolution, Oil},
			Nothing
		],
		If[Length[deprecatedInvalidBufferModels]>0,
			{ReservoirBuffers, Additives, CoCrystallizationReagents, DilutionBuffer, SeedingSolution, Oil},
			Nothing
		],
		If[Length[nonLiquidBuffers]>0,
			{ReservoirBuffers, Additives, CoCrystallizationReagents, DilutionBuffer, SeedingSolution, Oil},
			Nothing
		],
		If[Length[conflictingDropDestinationErrors]>0,
			{DropDestination},
			Nothing
		],
		If[Length[tooManyConditionsErrors]>0,
			{SampleVolumes, ReservoirBuffers, Additives, CoCrystallizationReagents},
			Nothing
		],
		compatibleMaterialsInvalidOption
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0 && messagesQ,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0 && messagesQ,
		Message[Error::InvalidOption, invalidOptions]
	];


	(* Get all the tests together. *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		preparedOnlyTest,
		discardedTest,
		deprecatedTest,
		nonLiquidTest,
		precisionTests1,
		conflictingCrystallizationTechniquePlateTest,
		conflictingCrystallizationPlateWithInstrumentTest,
		conflictingCrystallizationTechniquePreparationTest,
		conflictingDropSetterTest,
		conflictingReservoirDispenserTest,
		conflictingDropSetterWithReservoirDispenserTest,
		conflictingUVImagingTest,
		conflictingCrossPolarizedImagingTest,
		conflictingPreMixBufferTest,
		coverTest,
		conflictingVisibleLightImagingTest,
		invalidInstrumentModelsTest,
		tooManySamplesTest,
		validPreparedPlateContainerTest,
		validPreparedPlateVolumeTest,
		conflictingPreparedPlateInstrumentTest,
		conflictingPreparedPlatePreparationTest,
		conflictingCrystallizationPlateTest,
		precisionTests2,
		preMixTest,
		dropAliquotTest,
		conflictingSampleVolumesTest,
		conflictingCoCrystallizationAirDryTest,
		conflictingCoCrystallizationReagentsTest,
		airDiredCoCrystallizationReagentsAliquotTest,
		conflictingDilutionBufferTest,
		conflictingSeedingSolutionTest,
		conflictingOilTest,
		conflictingScreeningMethodTest,
		conflictingScreeningMethodStrategyTest,
		conflictingDropVolumeTest,
		conflictingReservoirTest,
		conflictingLabelTest,
		highEvaporationTest,
		duplicatedBuffersTest,
		discardedBufferTest,
		deprecatedBufferTest,
		nonLiquidBufferTest,
		conflictingDropDestinationTest,
		tooManyConditionsTest,
		aliquotTests,
		compatibleMaterialsTests,
		nameInvalidTest
	}], TestP];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedAllOptions,
		Tests -> allTests
	}
];

DefineOptions[growCrystalResourcePackets,
	Options :> {
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

Authors[growCrystalResourcePackets] := {"lige.tonggu"};

growCrystalResourcePackets[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myOptions:OptionsPattern[growCrystalResourcePackets]
] := Module[
	{
		outputSpecification, output, gatherTests, messages, inheritedCache, parentProtocol, expandedInputs, expandedResolvedOptions,
		unresolvedOptionsNoHidden, resolvedOptionsNoHidden, liquidHandlerContainers, uniqueContainersIn, uniqueContainersInModels,
		uniqueContainersInCovers, liquidHandlerContainerMaxVolumes, liquidHandlerContainerMinVolumes, uniqueSampleResourceLookup,
		preparedPlate, reservoirBuffers, dilutionBuffers, additives, seedingSolutions, coCrystallizationReagents, oils,
		dropCompositionTable, transferTable, bufferPreparationTable, reformedDropCompositionTable, reformedTransferTable,
		reformedBufferPreparationTable, uniqueSamples, uniqueSampleAmounts, uniqueSamplesInAndVolumesAssoc, samplesInResources,
		containersInResources, uniqueSampleResourceReplacements, uniqueBufferReplacements, uniqueBuffers, uniqueBufferVolumes,
		dropDestinations, bufferSourceVesselDeadVolume, uniqueBuffersAndVolumeAssoc, bufferResources, updatedReservoirBuffers,
		updatedDilutionBuffers, updatedAdditives, updatedSeedingSolutions, updatedCoCrystallizationReagents, updatedOils,
		updatedTransferTable, updatedBufferPreparationTable, crystallizationPlateResource, crystallizationCoverResource,
		crystallizationCoverPaddleResource, uniqueAssayPlates, uniqueAssayPlateReplacements, uniqueAssayPlateResources, imagerResource,
		runTime, updatedDropCompositionTable, fumeHood, fumeHoodResource, manualProtocolPacket, simulation, sharedFieldPacket,
		finalizedPacket, allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, resultRule, testsRule
	},

	(* expand the resolved options if they weren't expanded already *)
	{{expandedInputs}, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentGrowCrystal, {myListedSamples}, myResolvedOptions];

	(* Get the collapsed unresolved index-matching options that don't include hidden options *)
	unresolvedOptionsNoHidden = RemoveHiddenOptions[ExperimentGrowCrystal, myUnresolvedOptions];

	(* Get the collapsed resolved index-matching options that don't include hidden options *)
	(* Ignore to collapse those options that are set in expandedsafeoptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentGrowCrystal,
		RemoveHiddenOptions[ExperimentGrowCrystal, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Determine the requested output format of this function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Get the inherited cache *)
	inheritedCache = Lookup[ToList[myOptions], Cache, {}];
	simulation = Lookup[ToList[myOptions], Simulation, {}];

	(* Look up the resolved option values we need *)
	parentProtocol = Lookup[myResolvedOptions, ParentProtocol];

	(* Extract options. *)
	preparedPlate = Lookup[expandedResolvedOptions, PreparedPlate];
	dropDestinations = Cases[DeleteDuplicates@Flatten[Lookup[expandedResolvedOptions, DropDestination]], CrystallizationWellContentsP];
	dropCompositionTable = Lookup[expandedResolvedOptions, DropCompositionTable];
	transferTable = Lookup[expandedResolvedOptions, TransferTable];
	bufferPreparationTable = Lookup[expandedResolvedOptions, BufferPreparationTable];
	reservoirBuffers = Lookup[expandedResolvedOptions, ReservoirBuffers];
	dilutionBuffers = Lookup[expandedResolvedOptions, DilutionBuffer];
	additives = Lookup[expandedResolvedOptions, Additives];
	seedingSolutions = Lookup[expandedResolvedOptions, SeedingSolution];
	coCrystallizationReagents = Lookup[expandedResolvedOptions, CoCrystallizationReagents];
	oils = Lookup[expandedResolvedOptions, Oil];


	(* Reformat Tables with keys. *)
	(* The DropCompositionTable, TransferTable, BufferPreparationTable options for ExperimentGrowCrystal are lists of lists. *)
	(* While those fields for Protocol are lists of associations. We reformat them here. *)

	(* The format of resolved option DropCompositionTable is 1)DropSampleOutLabel 2)DestinationWell 3)Sample 4)SampleVolume *)
	(* 5)DilutionBuffer 6)DilutionBufferVolume 7)ReservoirBuffer 8)ReservoirDropVolume 9)CoCrystallizationReagent *)
	(* 10)CoCrystallizationReagentVolume 11)CoCrystallizationAirDry 12)Additive 13)AdditiveVolume 14)SeedingSolution*)
	(* 15)SeedingSolutionVolume 16)Oil 17)OilVolume. *)
  reformedDropCompositionTable = <|
		DropSampleOutLabel -> #[[1]],
		DestinationWell ->#[[2]],
		Sample -> #[[3]],
		SampleVolume -> #[[4]],
		DilutionBuffer -> #[[5]],
		DilutionBufferVolume -> #[[6]],
		ReservoirBuffer -> #[[7]],
		ReservoirDropVolume -> #[[8]],
		CoCrystallizationReagent -> #[[9]],
		CoCrystallizationReagentVolume -> #[[10]],
		CoCrystallizationAirDry -> #[[11]],
		Additive -> #[[12]],
		AdditiveVolume -> #[[13]],
		SeedingSolution -> #[[14]],
		SeedingSolutionVolume -> #[[15]],
		Oil -> #[[16]],
		OilVolume -> #[[17]]
		|>&	/@ dropCompositionTable;

	(* The format of resolved option BufferPreparationTable is 1)Step 2) Source(Link/PreMixSolutionLabel) 3)TransferVolume *)
	(* 4)TargetContainer 5)DestinationWells 6)TargetContainerLabel 7)PreparedSolutionsLabel. *)
	reformedBufferPreparationTable = <|
		Step -> #[[1]],
		Source -> If[MatchQ[#[[2]], ObjectP[]], #[[2]], Null],
		PreMixSolutionLabel -> If[MatchQ[#[[2]], _String], #[[2]], Null],
		TransferVolume -> #[[3]],
		TargetContainer -> #[[4]],
		DestinationWells -> #[[5]],
		TargetContainerLabel -> #[[6]],
		PreparedSolutionsLabel -> #[[7]]
	|>&	/@ bufferPreparationTable;

	(* The format of resolved option TransferTable is 1)Step 2)TransferType3)Source(Link/PreparedSolutionLabel) *)
	(* 4)TransferVolume 5)DestinationWells 6)SamplesOutLabel. *)
	reformedTransferTable = <|
		Step -> #[[1]],
		TransferType -> #[[2]],
		Source -> If[MatchQ[#[[3]], ObjectP[]], #[[3]], Null],
		PreparedSolutionLabel -> If[MatchQ[#[[3]], _String], #[[3]], Null],
		TransferVolume -> #[[4]],
		DestinationWells -> #[[5]],
		SamplesOutLabel -> #[[6]]
	|>&	/@ transferTable;

	(* FumeHood model can be automatically selected. *)
	fumeHood = If[And[
		MatchQ[Lookup[expandedResolvedOptions, CoCrystallizationAirDryTemperature], Ambient|$AmbientTemperature],
		GreaterQ[Lookup[expandedResolvedOptions, CoCrystallizationAirDryTime], 1 Hour]
		],
		(* find all the non-deprecated fume hood models *)
		Search[Model[Instrument,FumeHood], Deprecated != True],
		Null
	];
	fumeHoodResource = If[!NullQ[fumeHood],
		Resource[Name -> ToString[Unique[]], Instrument -> fumeHood, Time -> Lookup[expandedResolvedOptions, CoCrystallizationAirDryTime]]
	];


	(*---Generate all the resources for the experiment---*)

	(* Pull out all the liquid handler-compatible container models. *)
	liquidHandlerContainers = hamiltonAliquotContainers["Memoization"];
	liquidHandlerContainerMaxVolumes = If[MatchQ[#, ObjectP[Model[Container, Plate, Irregular]]],
		Max@Lookup[fetchPacketFromCache[#, inheritedCache], MaxVolumes, Null],
		Lookup[fetchPacketFromCache[#, inheritedCache], MaxVolume, Null]]& /@liquidHandlerContainers;
	liquidHandlerContainerMinVolumes = Lookup[fetchPacketFromCache[#, inheritedCache], MinVolume, 0 Microliter]& /@liquidHandlerContainers;
	uniqueContainersIn = DeleteDuplicates[Download[Lookup[fetchPacketFromCache[#, inheritedCache], Container], Object]& /@ myListedSamples];
	uniqueContainersInModels = DeleteDuplicates[Flatten[Download[Lookup[fetchPacketFromCache[#, inheritedCache], Model], Object]& /@ uniqueContainersIn]];
	uniqueContainersInCovers = DeleteDuplicates[Flatten[Download[Cases[Lookup[fetchPacketFromCache[#, inheritedCache], Cover], ObjectP[]], Object]& /@ uniqueContainersIn]];

	(* A helper function to generate resource. *)
	(* Generate a resource for each unique sample, returning a lookup table of sample -> resource *)
	uniqueSampleResourceLookup[uniqueSamplesAndVolumes_Association] := KeyValueMap[
		Function[{object, amount},
			Module[{containers},

				If[ObjectQ[object] && VolumeQ[amount],

					(* If we need to make a resource, figure out which liquid handler compatible containers can be used for this resource *)
					containers = PickList[liquidHandlerContainers, liquidHandlerContainerMaxVolumes, GreaterEqualP[amount]];

					(* Return a resource rule *)
					object -> Resource[Sample -> object, Amount -> amount, Name -> ToString[Unique[]], Container -> containers],

					(* If we don't need to make a resource, return a rule with the same object *)
					object -> object
				]
			]
		],
		uniqueSamplesAndVolumes
	];

	(*--Generate the samples in resources--*)

	(* Generate sample volume rules *)
	uniqueSamples = DeleteDuplicates[dropCompositionTable[[All, 3]]];
	uniqueSampleAmounts = Map[
		Function[{uniqueSample},
			If[MatchQ[preparedPlate, True],
				(* For prepared plate, only look for DropSamplesOut(sample in drop wells). *)
				If[!NullQ[First@Lookup[Cases[reformedDropCompositionTable, KeyValuePattern[{Sample -> ObjectP[uniqueSample]}]], SampleVolume]],
					First@Lookup[Cases[reformedDropCompositionTable, KeyValuePattern[{Sample -> ObjectP[uniqueSample]}]], SampleVolume],
					(* NOTE: We allow solid samples on prepared plate. *)
					Lookup[fetchPacketFromCache[uniqueSample, inheritedCache], Mass]
				],
				(* For unprepared plate, calculate the total required volume of each unique sample. *)
					Module[{sampleVolumeFromPrepTable, sampleVolumeFromTransferTable},
						(* Now extract the SampleVolume. *)
						sampleVolumeFromPrepTable = If[!NullQ[bufferPreparationTable],
							Total@Map[
								Lookup[#, TransferVolume]*Length@Lookup[#, PreparedSolutionsLabel]&,
								Cases[reformedBufferPreparationTable, KeyValuePattern[{Step -> SetDrop, Source -> ObjectP[uniqueSample]}]]
							]/.(0 -> 0 Microliter),
							0 Microliter
						];
						sampleVolumeFromTransferTable =  If[!NullQ[transferTable],
							Total@Map[
								Lookup[#, TransferVolume]*Length@Lookup[#, SamplesOutLabel]&,
								Cases[reformedTransferTable, KeyValuePattern[{Step -> SetDrop, Source -> ObjectP[uniqueSample]}]]
							]/.(0 -> 0 Microliter),
							0 Microliter
						];
						(* We add 10% extra Plus flat 5 Microliter here *)
						1.1*(sampleVolumeFromPrepTable + sampleVolumeFromTransferTable) + 5 Microliter
					]
			]
		],
		uniqueSamples
	];
	uniqueSamplesInAndVolumesAssoc = Merge[MapThread[#1 -> #2 &, {uniqueSamples, uniqueSampleAmounts}], Total];

	(* Make the resources *)
	uniqueSampleResourceReplacements = uniqueSampleResourceLookup[uniqueSamplesInAndVolumesAssoc];
	samplesInResources = Replace[myListedSamples, uniqueSampleResourceReplacements, {1}];

	(*--Generate the containers in resources--*)
	containersInResources = Resource[Sample -> #]& /@ uniqueContainersIn;

	(*--Generate the Buffer in resources --*)

	(* Get the Buffer. *)
	uniqueBuffers = DeleteDuplicates@Cases[Flatten[Drop[#, 3]& /@ dropCompositionTable], ObjectP[]];
	(* Calculate the total BufferVolume needed, plus 10% extra. *)
	uniqueBufferVolumes = Map[
		Function[{uniqueBuffer},
			Module[{bufferVolumeFromPrepTable, bufferVolumeFromTransferTable},
				(* Now extract the BufferVolume associated with dropLabels. *)
				bufferVolumeFromPrepTable = If[!NullQ[bufferPreparationTable],
					Total@Map[
						Lookup[#, TransferVolume]*Length@Lookup[#, PreparedSolutionsLabel]&,
						PickList[reformedBufferPreparationTable, MemberQ[#, ObjectP[uniqueBuffer]]& /@ Values[reformedBufferPreparationTable]]
					]/.(0 -> 0 Microliter),
					0 Microliter
				];
				bufferVolumeFromTransferTable = If[!NullQ[transferTable],
					Total@Map[
						Lookup[#, TransferVolume]*Length@Lookup[#, SamplesOutLabel]&,
						PickList[reformedTransferTable, MemberQ[#, ObjectP[uniqueBuffer]]& /@ Values[reformedTransferTable]]
					]/.(0 -> 0 Microliter),
					0 Microliter
				 ];
				(* We add 10% extra Plus flat 20 Microliter here *)
				1.1*(bufferVolumeFromPrepTable + bufferVolumeFromTransferTable) + 20 Microliter
			]
		],
		uniqueBuffers
	];

	(* Figure out what liquid handler compatible container may be used for the uniqueBuffer *)
	bufferSourceVesselDeadVolume = MapThread[
		If[And[
			MatchQ[#1, ObjectP[Object[Sample]]],
			MemberQ[liquidHandlerContainers, ObjectP[Lookup[fetchPacketFromCache[Lookup[fetchPacketFromCache[#1, inheritedCache], Container], inheritedCache], Model]]]
			],
			(* If the buffer is already in a liquid handler compatible container, don't need to pick preferred container. *)
			0 Microliter,
			(* Calculate buffer source vessel dead volume: MinVolume is added to ensure complete transfer to all prep wells is possible *)
			PreferredContainer[#2, LiquidHandlerCompatible -> True]/.Thread[liquidHandlerContainers -> liquidHandlerContainerMinVolumes]
		]&,
		{uniqueBuffers, uniqueBufferVolumes}
	];

	(* Generate Buffer and Buffer volume association *)
	uniqueBuffersAndVolumeAssoc = Merge[MapThread[#1 -> #2 &, {uniqueBuffers, uniqueBufferVolumes + bufferSourceVesselDeadVolume}], Total];

	(* Make the Buffer resource *)
	uniqueBufferReplacements = uniqueSampleResourceLookup[uniqueBuffersAndVolumeAssoc];
	bufferResources = Replace[uniqueBuffers, uniqueBufferReplacements, {1}];

	(*--Generate AssayPlates and cover resources--*)

	(* Get the CrystallizationPlate and use the same CrystallizationPlateLabel as name for the plate resource. *)
	crystallizationPlateResource = If[MatchQ[preparedPlate, True],
		First@containersInResources,
		Resource[Sample -> Lookup[expandedResolvedOptions, CrystallizationPlate], Name -> Lookup[expandedResolvedOptions, CrystallizationPlateLabel]]
	];

	(* If our resolved PreparedPlate is True, there are two possible cases: *)
	(* 1 is we have a prepared container with a plate seal suitable for long-term storage that can be directly used for the experiment; *)
	(* 2 is that we have a prepared container with a cover not suitable for long-term storage, we need to update the cover. *)
	crystallizationCoverResource = Which[
		And[
		MatchQ[preparedPlate, True],
		!MatchQ[uniqueContainersInCovers, {}|{Null..}],
		Or[
			MatchQ[Lookup[fetchPacketFromCache[uniqueContainersInCovers[[1]], inheritedCache], Model], ObjectP[Lookup[expandedResolvedOptions, CrystallizationCover]]],
			MatchQ[uniqueContainersInCovers[[1]], ObjectP[Lookup[expandedResolvedOptions, CrystallizationCover]]]
			]
		],
			(* If the samples are in a covered prepared plate, we don't need to reapply PlateSeal to the container *)
			Null,
		MatchQ[preparedPlate, True],
			(* we have to cover this prepared plate with new PlateSeal *)
			Resource[Sample -> Lookup[expandedResolvedOptions, CrystallizationCover], Name -> CreateUniqueLabel["Picked CrystallizationCover"]],
		True,
			Resource[Sample -> Lookup[expandedResolvedOptions, CrystallizationCover], Name -> CreateUniqueLabel["Picked CrystallizationCover"]]
	];
	(* If we apply new PlateSeal, we need PlateSealPaddle as well. *)
	crystallizationCoverPaddleResource = If[NullQ[crystallizationCoverResource],
		Null,
		Resource[Sample -> Model[Item, PlateSealRoller, "id:XnlV5jlmLBYB"], Name -> ToString[Unique[]], Rent -> True](*"Film Sealing Paddle"*)
	];

	(*Get the assay plate*)
	uniqueAssayPlates = If[NullQ[reformedBufferPreparationTable],
		{},
		DeleteDuplicates[Lookup[reformedBufferPreparationTable, {TargetContainer, TargetContainerLabel}]]
	];
	uniqueAssayPlateReplacements = # -> Resource[Sample -> First@#, Name -> CreateUniqueLabel["Picked AssayPlate"]]& /@ uniqueAssayPlates;
	uniqueAssayPlateResources = If[MatchQ[uniqueAssayPlateReplacements, {}],
		Null,
		Values@uniqueAssayPlateReplacements
	];

	(*--Generate ImagingInstrument in resources--*)
	(* Note:we want to check at CCD protocol generation time to see if there are available plate slots in CrystalIncubator. *)
	(* Note:we won't pick the ImagingInstrument at Resource Picking step at the beginning of protocol, we will do ReadyCheck on the CrystalIncubator before we pick it. *)
	imagerResource = Resource[Instrument -> Lookup[expandedResolvedOptions, ImagingInstrument], Time -> 1 Hour, Name -> CreateUUID["Picked ImagingInstrument"]];

	(* Estimate RunTime. *)
	runTime = If[MatchQ[preparedPlate, True],
		(* For a prepared plate, we only need to check plate seal. *)
		5 Minute,
		(* For an unprepared plate, we need to set up drop setter and transfer samples and reagents. *)
		0.5 Minute * (Length[transferTable] + Length[bufferPreparationTable]) + 40 Minute + Lookup[expandedResolvedOptions, CoCrystallizationAirDryTime]/.(Null -> 0 Minute)
	];

	(* There are multiple fields which have the same resources above, populate here. *)
	(* Update all the solution resources with uniqueSampleResources, bufferResources as well as uniqueAssayPlateResources. *)
	updatedReservoirBuffers = Cases[Flatten[reservoirBuffers], ObjectP[]]/.uniqueBufferReplacements;
	updatedDilutionBuffers = Cases[dilutionBuffers, ObjectP[]]/.uniqueBufferReplacements;
	updatedAdditives = Cases[Flatten[additives], ObjectP[]]/.uniqueBufferReplacements;
	updatedSeedingSolutions = Cases[seedingSolutions, ObjectP[]]/.uniqueBufferReplacements;
	updatedCoCrystallizationReagents = Cases[Flatten[coCrystallizationReagents], ObjectP[]]/.uniqueBufferReplacements;
	updatedOils  = Cases[oils, ObjectP[]]/.uniqueBufferReplacements;
	updatedDropCompositionTable = reformedDropCompositionTable/.Join[uniqueSampleResourceReplacements, uniqueBufferReplacements];
	updatedTransferTable = reformedTransferTable/.Join[uniqueSampleResourceReplacements, uniqueBufferReplacements];
	updatedBufferPreparationTable = If[!NullQ[reformedBufferPreparationTable],
		Module[{bufferTableWithSolutionResources, assayPlateResources},
			(* Update all the solution objects to resource blob. *)
			bufferTableWithSolutionResources = reformedBufferPreparationTable/.Join[uniqueSampleResourceReplacements, uniqueBufferReplacements];
			assayPlateResources = Lookup[Association@uniqueAssayPlateReplacements, Key[{Lookup[#, TargetContainer], Lookup[#, TargetContainerLabel]}]]& /@ bufferTableWithSolutionResources;
			(* Update the value for TargetContainer with the assay plate resource. *)
			MapThread[
				Association[ReplaceRule[Normal@#1, {TargetContainer -> #2}]]&,(*todo:wait for new ReplaceRule update, then ReplaceRule[#1, TargetContainer -> #2].*)
				{bufferTableWithSolutionResources, assayPlateResources}
			]
		]
	];


	(* NOTE: We don't generate resources for Instruments here. Instead, subprotocols will pick and generate instrument resources. *)
	(*---Make all the packets for the experiment---*)

	(*--Make the protocol and unit operation packets--*)
	manualProtocolPacket = <|
		(*=== Organizational Information ===*)
		Object -> CreateID[Object[Protocol, GrowCrystal]],
		Type -> Object[Protocol, GrowCrystal],
		Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
		Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
		Author -> If[MatchQ[parentProtocol, Null], Link[$PersonID, ProtocolsAuthored]],
		ParentProtocol -> If[MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], Link[parentProtocol, Subprotocols]],
		Name -> If[MatchQ[Lookup[expandedResolvedOptions, Name], _String], Lookup[expandedResolvedOptions, Name]],

		(*=== Options Handling ===*)
		UnresolvedOptions -> unresolvedOptionsNoHidden,
		ResolvedOptions -> resolvedOptionsNoHidden,

		(*=== Resources ===*)
		Replace[Checkpoints] -> {
			{"Preparing Samples", 45 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 45 Minute]]},
			{"Picking Resources", 45 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 45 Minute]]},
			{"Preparing CrystallizationPlate", runTime, "Loading CrystallizationPlate with samples and buffers.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> runTime]]},
			{"Storing CrystallizationPlate to Crystal Incubator", 1 Hour, "The CrystallizationPlate is stored in Crystal incubator and imaging schedule is set", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Hour]]},
			{"Returning Materials", 1 Hour, "Extra samples and buffers are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Hour]]}
		},

		(*=== General ===*)
		ReservoirDispensingInstrument -> Link[Lookup[expandedResolvedOptions, ReservoirDispensingInstrument]],
		DropSetterInstrument -> Link[Lookup[expandedResolvedOptions, DropSetterInstrument]],
		ImagingInstrument -> Link[imagerResource],
		FumeHood -> Link[fumeHoodResource],
		CrystallizationTechnique -> Lookup[expandedResolvedOptions, CrystallizationTechnique],
		CrystallizationStrategy -> Lookup[expandedResolvedOptions, CrystallizationStrategy],
		Replace[AssayPlates] -> If[!NullQ[uniqueAssayPlateResources], Link /@ uniqueAssayPlateResources, Null],
		CrystallizationCover -> Link[crystallizationCoverResource],
		PlateSealPaddle -> Link[crystallizationCoverPaddleResource],
		CrystallizationPlate -> Link[crystallizationPlateResource],

		(*=== Sample Preparation ===*)
		PreparedPlate -> preparedPlate,
		PreMixBuffer -> Lookup[expandedResolvedOptions, PreMixBuffer],
		Replace[DropCompositionTable] -> Map[If[MatchQ[#, _Resource|ObjectP[]], Link[#], #]&, updatedDropCompositionTable, {2}],
		Replace[TransferTable] -> If[!NullQ[transferTable], Map[If[MatchQ[#, _Resource|ObjectP[]], Link[#], #]&, updatedTransferTable, {2}], Null],
		Replace[BufferPreparationTable] -> If[!NullQ[bufferPreparationTable], Map[If[MatchQ[#, _Resource|ObjectP[]], Link[#], #]&, updatedBufferPreparationTable, {2}], Null],
		Replace[ReservoirBuffers] -> If[!MatchQ[updatedReservoirBuffers, {}], Link /@ updatedReservoirBuffers, Null],
		Replace[DilutionBuffers] -> If[!MatchQ[updatedDilutionBuffers, {}], Link /@ updatedDilutionBuffers, Null],
		Replace[Additives] -> If[!MatchQ[updatedAdditives, {}], Link /@ updatedAdditives, Null],
		Replace[CoCrystallizationReagents] -> If[!MatchQ[updatedCoCrystallizationReagents, {}], Link /@ updatedCoCrystallizationReagents, Null],
		CoCrystallizationAirDryTime -> Lookup[expandedResolvedOptions, CoCrystallizationAirDryTime],
		CoCrystallizationAirDryTemperature -> Lookup[expandedResolvedOptions, CoCrystallizationAirDryTemperature],
		Replace[SeedingSolutions] -> If[!MatchQ[updatedSeedingSolutions, {}], Link /@ updatedSeedingSolutions, Null],
		Replace[Oils] -> If[!MatchQ[updatedOils, {}], Link /@ updatedOils, Null],

		(*=== Imaging Info ===*)
		UVImaging -> Lookup[expandedResolvedOptions, UVImaging],
		CrossPolarizedImaging -> Lookup[expandedResolvedOptions, CrossPolarizedImaging],
		DropDestinations -> dropDestinations,
		(*=== Incubation Info ===*)
		MaxCrystallizationTime -> Lookup[expandedResolvedOptions, MaxCrystallizationTime],
		SamplesOutStorageCondition -> If[MatchQ[Lookup[expandedResolvedOptions, CrystallizationPlateStorageCondition], SampleStorageTypeP],
			Lookup[expandedResolvedOptions, CrystallizationPlateStorageCondition],
			Link[Lookup[expandedResolvedOptions, CrystallizationPlateStorageCondition]]
			]
	|>;

	(*--Make a packet with the shared fields--*)
	sharedFieldPacket = populateSamplePrepFields[myListedSamples, expandedResolvedOptions, Cache -> inheritedCache, Simulation -> simulation];

	(*--Merge the specific fields with the shared fields--*)
	finalizedPacket = Join[manualProtocolPacket, sharedFieldPacket];

	(*--Gather all the resource symbolic representations--*)

	(* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(*---Call fulfillableResourceQ on all the resources we created---*)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[
				allResourceBlobs,
				Output -> {Result, Tests},
				FastTrack -> Lookup[myResolvedOptions, FastTrack],
				Site -> Lookup[myResolvedOptions, Site],
				Cache -> inheritedCache,
				Simulation -> simulation
			],
		True,
			{
				Resources`Private`fulfillableResourceQ[
					allResourceBlobs,
					FastTrack -> Lookup[myResolvedOptions, FastTrack],
					Site -> Lookup[myResolvedOptions, Site],
					Messages -> messages,
					Cache -> inheritedCache,
					Simulation -> simulation
				],
				Null
			}
	];

	(*---Return our options, packets, and tests---*)

	(* Generate the preview output rule; Preview is always Null *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* Generate the tests output rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule, optionsRule, resultRule, testsRule}
];


(* ::Subsubsection::Closed:: *)
(*simulateExperimentGrowCrystal*)

DefineOptions[
	simulateExperimentGrowCrystal,
	Options :> {CacheOption, SimulationOption}
];

simulateExperimentGrowCrystal[
	myProtocolPacket: (PacketP[Object[Protocol, GrowCrystal], {Object, ResolvedOptions}]|$Failed),
	mySamples: {ObjectP[Object[Sample]]...},
	myResolvedOptions: {_Rule...},
	myResolutionOptions: OptionsPattern[simulateExperimentGrowCrystal]
] := Module[
	{
		protocolObject, cache, inheritedSimulation, parentProtocol, fastAssoc, resolvedReservoirBuffers, resolvedCrystallizationPlate,
		currentSimulation, samplePackets, simulatedProtocolPackets, mapThreadFriendlyOptions, simulatedDropSamplesOut,
		simulatedReservoirSamplesOut, dropToReservoirLabels, plateAllowedPositions, emptyPositions, emptyDropPositions,
		samplesOutLabelToWellRules, emptyReservoirPositions, numberOfDropPositionsPerSubdivision,
		currentOccupiedReservoirPositions, currentOccupiedDropPositions, allEmptySamplePackets, simulatedCrystallizationPlate,
		reservoirSampleTransferSimulation, dropSampleTransferSimulation, simulationWithLabels
	},

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed *)
	protocolObject = If[MatchQ[myProtocolPacket, $Failed],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver *)
		SimulateCreateID[Object[Protocol, GrowCrystal]],
		Lookup[myProtocolPacket, Object]
	];

	(* Pull out the cache and simulation from the resolution options *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	inheritedSimulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	parentProtocol = Lookup[ToList[myResolutionOptions], ParentProtocol, Null];

	(* Make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
		ExperimentGrowCrystal,
		myResolvedOptions
	];

	(* Look up our resolved options that we might update in simulation. *)
	resolvedCrystallizationPlate = Download[Lookup[myResolvedOptions, CrystallizationPlate], Object];
	resolvedReservoirBuffers = Map[If[MatchQ[#, {ObjectP[]..}], Download[#, Object], #]&, Lookup[mapThreadFriendlyOptions, ReservoirBuffers]];

	(* Gather allowed sample positions from crystallization plate model. *)
	plateAllowedPositions = If[MatchQ[resolvedCrystallizationPlate, ObjectP[Model[Container]]],
		Lookup[fastAssocLookup[fastAssoc, resolvedCrystallizationPlate, Positions], Name],
		Lookup[fastAssocLookup[fastAssoc, resolvedCrystallizationPlate, {Model, Positions}], Name]
		];
	(* Since simulation needs to be robust, we will remove occupied wells from CrystallizationPlate here. *)
	(* Note: used CrystallizationPlate is not allowed when generate protocol. *)
	emptyPositions = If[MatchQ[resolvedCrystallizationPlate, ObjectP[Object[Container]]],
		Module[{occupiedPositions},
			occupiedPositions = Lookup[fetchPacketFromFastAssoc[resolvedCrystallizationPlate, fastAssoc], Contents][[All, 1]];
			(* Remove occupied WellPositions from AllowedPositions. *)
			Complement[plateAllowedPositions, occupiedPositions]
		],
		plateAllowedPositions
	];
	(* Pull out empty positions for drops from a given plate. *)
	emptyDropPositions = If[MemberQ[plateAllowedPositions, "A1Drop1"],
		(* For irregular crystallization plate, there might be both drop wells and reservoir wells, or just drop wells. *)
		PickList[emptyPositions, StringContainsQ[#, "Drop"]& /@ emptyPositions],
		emptyPositions
	];
	(* Pull out empty positions for reservoirs from a given plate. *)
	emptyReservoirPositions = Complement[emptyPositions, emptyDropPositions];
	numberOfDropPositionsPerSubdivision =If[MemberQ[plateAllowedPositions, "A1Drop1"],
		Length[PickList[plateAllowedPositions, StringContainsQ[#, "Drop"]& /@ plateAllowedPositions]]/Length[PickList[plateAllowedPositions, StringContainsQ[#, "Reservoir"]& /@ plateAllowedPositions]],
		1
	];

	(* Generate rules from DropSamplesOutLabel to ReservoirSamplesOutLabel for any new SamplesOut. *)
	(* Populate Initial occupied well positions before assigning any samples. *)
	currentOccupiedDropPositions = {};
	currentOccupiedReservoirPositions = {};
	(* Populate DropSample label to ReservoirSample label for each SamplesIn considering available wells. *)
	dropToReservoirLabels = Map[
		Function[{indexedResolvedOptions},
			Module[{dropLabels, reservoirLabels, previousEmptyDropPositions, previousEmptyReservoirPositions, previousEmptyNumberOfSubdivisions, assignedLabels},
				dropLabels = Lookup[indexedResolvedOptions, DropSamplesOutLabel];
				reservoirLabels = Lookup[indexedResolvedOptions, ReservoirSamplesOutLabel];
				previousEmptyDropPositions = Complement[emptyDropPositions, currentOccupiedDropPositions];
				previousEmptyReservoirPositions = Complement[emptyReservoirPositions, currentOccupiedReservoirPositions];
				previousEmptyNumberOfSubdivisions = If[MemberQ[plateAllowedPositions, "A1Drop1"],
					(* If a plate has A1Drop1 as allowed position, each subdivision has 1 reservoir well. *)
					Min[Length[previousEmptyReservoirPositions], Floor[Length[previousEmptyDropPositions]/numberOfDropPositionsPerSubdivision]],
					(* If a plate has no A1Drop1, each subdivision has 1 drop well. *)
					Length[previousEmptyDropPositions]
				];
				(* Assign labels to available wells on CrystallizationPlate *)
				assignedLabels = Which[
					Or[
						NullQ[reservoirLabels] && NullQ[dropLabels],
						MatchQ[Lookup[myResolvedOptions, PreparedPlate], True]
					],
					(* For a prepared plate, there is no new samples. *)
						{},
					Or[
						NullQ[reservoirLabels],
						MatchQ[emptyReservoirPositions, {}],
						MatchQ[Lookup[indexedResolvedOptions, ReservoirBuffers], Null|None],
						MatchQ[Lookup[myResolvedOptions, CrystallizationTechnique], Except[SittingDropVaporDiffusion]]
					],
						(* Note: We can have ConflictingReservoir errors. What we do here is robust. *)
						(# -> Null)& /@ Take[dropLabels, Min[Length[dropLabels], Length[previousEmptyDropPositions]]],
					NullQ[dropLabels],
						(Null -> #)& /@ Take[reservoirLabels, Min[Length[reservoirLabels], Length[previousEmptyReservoirPositions]]],
					GreaterQ[Length@reservoirLabels, Min[Length[dropLabels], previousEmptyNumberOfSubdivisions]],
						(* Note: We can have TooManySamples or TooManyConditions errors. What we do here is robust. *)
						(* If mismatched new samples have been specified, we proceed with the corrected portion. *)
						Normal@AssociationThread[Take[dropLabels, Min[Length[dropLabels], numberOfDropPositionsPerSubdivision*previousEmptyNumberOfSubdivisions]], Take[reservoirLabels, Min[Length[dropLabels], previousEmptyNumberOfSubdivisions]]],
					True,
						Flatten[
							MapThread[
								Function[{dropLableLists, reservoirLabel},
									(# -> reservoirLabel)& /@ dropLableLists
								],
								{PartitionRemainder[dropLabels, Ceiling[Length[dropLabels]/Length[reservoirLabels]]], reservoirLabels}
							],
							1
						]
				];
				(* Add our label to the tracking *)
				currentOccupiedDropPositions = Join[currentOccupiedDropPositions, Take[previousEmptyDropPositions, Length[Keys[assignedLabels]]]];
				currentOccupiedReservoirPositions = Join[currentOccupiedReservoirPositions, Take[previousEmptyReservoirPositions, Length[Cases[DeleteDuplicates@Values[assignedLabels], Except[Null]]]]];
				assignedLabels
			]
		],
		mapThreadFriendlyOptions
	];

	(* Simulate the fulfillment of all resources by the procedure *)
	(* NOTE: This is an excerpt from the resource packets function, just for the important fields that are error proof. *)
	currentSimulation = If[MatchQ[myProtocolPacket, $Failed],
		(* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving and skipped resource packet generation. *)
		(* Just make a shell protocol object so that we can call SimulateResources *)
		Module[{nonEmptyReservoirObjects, associatedLabelRules, matchedRequiredReservoirAmount, expandedRequiredReservoirResources},
			(* SimulateResource required Amount for any model sample. *)
			nonEmptyReservoirObjects = PickList[resolvedReservoirBuffers, resolvedReservoirBuffers, Except[Null|None]];
			associatedLabelRules = PickList[dropToReservoirLabels, resolvedReservoirBuffers, Except[Null|None]];
			matchedRequiredReservoirAmount = If[MatchQ[Lookup[myResolvedOptions, PreparedPlate], False] && MemberQ[resolvedReservoirBuffers, {__}],
				MapThread[
					1.1*Total[{Length[DeleteDuplicates[Keys[#2]]]*(Lookup[#3, ReservoirDropVolume]/.Null -> 0 Microliter), Length[DeleteDuplicates[Values[#2]]]*(Lookup[#3, ReservoirBufferVolume]/.Null -> 0 Microliter)}]/Length[#1]&,
					{nonEmptyReservoirObjects, associatedLabelRules, mapThreadFriendlyOptions}
				],
				{}
			];
			expandedRequiredReservoirResources = If[MatchQ[Lookup[myResolvedOptions, PreparedPlate], False] && MemberQ[resolvedReservoirBuffers, {__}],
				Flatten@MapThread[
					Function[{reservoirBuffers, reservoirBufferAmount},
						If[!MatchQ[reservoirBuffers, {}] && GreaterQ[reservoirBufferAmount, 0 Microliter],
							Resource[Sample -> #, Amount -> reservoirBufferAmount]& /@reservoirBuffers,
							Nothing
						]
					],
					{nonEmptyReservoirObjects, matchedRequiredReservoirAmount}
				],
				Null
			];
			(* Because there might be conflicting options, we do not update DilutionBuffers,Additives,SeedingSolutions,CoCrystallizationReagents,Oils here *)
			SimulateResources[
				<|
					Object -> protocolObject,
					Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
					Replace[ReservoirBuffers] -> expandedRequiredReservoirResources,
					CrystallizationPlate -> Resource[Sample -> resolvedCrystallizationPlate],
					ResolvedOptions -> myResolvedOptions
				|>,
				Cache -> cache,
				Simulation -> inheritedSimulation
			]
		],
		(* Otherwise, our resource packets went fine and we have an Object[Protocol, GrowCrystal] *)
		SimulateResources[
			myProtocolPacket,
			Cache -> cache,
			Simulation -> inheritedSimulation
		]
	];

	(* Update our simulation *)
	currentSimulation = UpdateSimulation[inheritedSimulation, currentSimulation];

	(* Download containers from our sample packets and download from simulated resources *)
	{samplePackets, simulatedProtocolPackets} = Quiet[
		Download[
			{
				mySamples,
				ToList[protocolObject]
			},
			{
				{Packet[Container, Position]},
				{
					Packet[
						CrystallizationPlate,
						ReservoirBuffers
					]
				}
			},
			Cache -> cache,
			Simulation -> currentSimulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];
	simulatedProtocolPackets = Flatten[simulatedProtocolPackets];

	simulatedCrystallizationPlate = Download[Lookup[First@simulatedProtocolPackets, CrystallizationPlate], Object];

	(* Resolve the destination wells for DropSamplesOut and ReservoirSamplesOut. *)
	samplesOutLabelToWellRules = Which[
		MatchQ[Lookup[myResolvedOptions, PreparedPlate], True],
		(* For prepared plate, we do not re-assign well position. Instead, we extract position from samplePacket. *)
			MapThread[
				If[!NullQ[#2], First[#2], First[#3]] -> If[!MatchQ[Lookup[#1, Position], {}], First@Lookup[#1, Position], Null]&,
				{samplePackets, Lookup[myResolvedOptions, DropSamplesOutLabel], Lookup[myResolvedOptions, ReservoirSamplesOutLabel]}
			],
		(* We will assign destination wells on CrystallizationPlate for new SamplesOut. *)
		!MatchQ[myProtocolPacket, $Failed],
			Module[{resolvedDropWellRules, matchedReservoirLabels, matchedReservoirWells, resolvedReservoirWellRules},
				(* If option resolving is successful, we extract the LabelToWellRules for DropSamplesOut from DropCompositionTable. *)
				(* The first position in DropCompositionTable is DropSampleOutLabel and the second is assigned WellPosition. *)
				resolvedDropWellRules = MapThread[Rule, Transpose[Take[#, 2]& /@ Lookup[myResolvedOptions, DropCompositionTable]]];
				matchedReservoirLabels = Lookup[Flatten@dropToReservoirLabels, #]& /@ Keys[resolvedDropWellRules];
				(* Extract ReservoirSamples corresponding to the subdivision for each resolvedDropWellRules. *)
				matchedReservoirWells = If[!NullQ[matchedReservoirLabels],
					(* For HangingDropVaporDiffusion, the subdivision of plate only contains ReservoirWell in the format of A1.*)
					(* However, we don't have this CrystallizationTechnique now in lab. We have the logic here for further implement. *)
					(* All the reservoir wells currently should be in the format of A1Reservoir. *)
					If[StringContainsQ[#, "Drop"], StringJoin[StringDrop[#, -5], "Reservoir"], #]& /@ Values[resolvedDropWellRules],
					(* There might be no ReservoirSamplesOut, in that case return {}. *)
					{}
				];
				(* Identical ReservoirSamplesOut can appear since multiple DropSamplesOut can link to the same ReservoirSampleOut. *)
				resolvedReservoirWellRules = If[!NullQ[matchedReservoirLabels],
					Normal@AssociationThread[DeleteDuplicates@matchedReservoirLabels, DeleteDuplicates@matchedReservoirWells],
					{}
				];
				Join[resolvedDropWellRules, resolvedReservoirWellRules]
			],
		True,
			(* If option resoling is not successful, we assign destinations here. *)
			(* Note: the well positions are random here just for simulate purpose.*)
			Module[{flattenedDropLabels, flattenedReservoirLabels, occupiedNumberOfDropWells, occupiedNumberOfReservoirWells},
				(* Flatten the list of DropSamplesOut. *)
				flattenedDropLabels = Cases[Keys[Flatten@dropToReservoirLabels], _String];
				flattenedReservoirLabels = Cases[DeleteDuplicates@Values[Flatten@dropToReservoirLabels], _String];
				occupiedNumberOfDropWells = Min[Length[flattenedDropLabels], Length@emptyDropPositions];
				occupiedNumberOfReservoirWells = Min[Length[flattenedReservoirLabels], Length@emptyReservoirPositions];
				Join[
					If[GreaterQ[occupiedNumberOfDropWells, 0],
						Normal@AssociationThread[Take[flattenedDropLabels, occupiedNumberOfDropWells], Take[emptyDropPositions, occupiedNumberOfDropWells]],
						{}
					],
					If[GreaterQ[occupiedNumberOfReservoirWells, 0],
						Normal@AssociationThread[Take[flattenedReservoirLabels, occupiedNumberOfReservoirWells], Take[emptyReservoirPositions, occupiedNumberOfReservoirWells]],
						{}
					]
				]
			]
	];

	(* Upload "Empty" sample to any destination samples (both DropSamplesOut and ReservoirSamplesOut). ) *)
	allEmptySamplePackets = If[MatchQ[Lookup[myResolvedOptions, PreparedPlate], True],
		{},
		UploadSample[
			(* NOTE: UploadSample takes in {} instead of Null if there is no model. *)
			ConstantArray[{}, Length[samplesOutLabelToWellRules]],
			{Last[#], simulatedCrystallizationPlate}& /@ samplesOutLabelToWellRules,
			Name -> samplesOutLabelToWellRules[[All, 1]],
			State -> Liquid,
			InitialAmount -> ConstantArray[Null, Length[samplesOutLabelToWellRules]],
			UpdatedBy -> protocolObject,
			Simulation -> currentSimulation,
			SimulationMode -> True,
			FastTrack -> True,
			Upload -> False
		]
	];

	(* Update our simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[allEmptySamplePackets]];

	(* Retrieve SamplesOutIDs inside of CrystallizationPlate in the format of index-matching to input samples. *)
	{simulatedDropSamplesOut, simulatedReservoirSamplesOut} = Module[{allSampleContents, simulatedSampleContents},
		(* Retrieve all samples from CrystallizationPlate(including both new samples and existing samples) and remove Links *)
		allSampleContents = Transpose[
			{
				Download[simulatedCrystallizationPlate, Contents, Simulation -> currentSimulation][[All, 1]],
				Download[Download[simulatedCrystallizationPlate, Contents, Simulation -> currentSimulation][[All, 2]], Object]
			}
		];
		(* Retrieve SimulationID and Positions for new samples *)
		simulatedSampleContents = PickList[allSampleContents, allSampleContents[[All, 1]], _?(MemberQ[Values[samplesOutLabelToWellRules], #] &)];
		(* Split the SampleIDs based on whether it is DropSample or ReservoirSample *)
		Transpose@MapThread[
			Module[
				{
					trimmedDropSamplesOutLabel, trimmedReservoirSamplesOutLabel, assignedDropWells, assignedReservoirWells,
					simulatedDropSampleIDs, simulatedReservoirSampleIDs
				},
				(* Retrieve SamplesOutLabel. *)
				trimmedDropSamplesOutLabel = #3[[All, 1]];
				(* Identical ReservoirSamplesOut can appear since multiple DropSamplesOut can link to the same ReservoirSampleOut. *)
				trimmedReservoirSamplesOutLabel = DeleteDuplicates[#3[[All, 2]]];
				(* Look up the assigned WellPosition for SamplesOut. *)
				assignedDropWells = Lookup[samplesOutLabelToWellRules, trimmedDropSamplesOutLabel];
				assignedReservoirWells = Lookup[samplesOutLabelToWellRules, trimmedReservoirSamplesOutLabel];
				(* Retrieve Object ID for simulated samples. *)
				(* If there is no SamplesOut, return Null. *)
				simulatedDropSampleIDs = Which[
					MatchQ[Lookup[myResolvedOptions, PreparedPlate], False],
						Flatten[Cases[simulatedSampleContents, {#, newObject_:ObjectP[]} :> newObject]& /@ assignedDropWells],
					!NullQ[trimmedDropSamplesOutLabel] && MatchQ[Lookup[myResolvedOptions, PreparedPlate], True],
						{#1},
					True,
						Null
				];
				simulatedReservoirSampleIDs = Which[
					MatchQ[Lookup[myResolvedOptions, PreparedPlate], False],
						Flatten[Cases[simulatedSampleContents, {#, newObject_:ObjectP[]} :> newObject]& /@ assignedReservoirWells],
					!NullQ[trimmedReservoirSamplesOutLabel] && MatchQ[Lookup[myResolvedOptions, PreparedPlate], True],
						{#1},
					True,
						Null
				];
				{simulatedDropSampleIDs, simulatedReservoirSampleIDs}
			]&,
			{mySamples, mapThreadFriendlyOptions, dropToReservoirLabels}
		]
	];

	(* More Simulation: Call UploadSampleTransfer *)
	(* Transfer sample to reservoir wells first *)
	reservoirSampleTransferSimulation = If[Or[
			MatchQ[Lookup[myResolvedOptions, PreparedPlate], True],
			MatchQ[Cases[Values[Flatten@dropToReservoirLabels], _String], {}],
			!MemberQ[resolvedReservoirBuffers, {__}]
		],
		{},
		Module[{modelReservoirBufferToSimulationRules, expandedReservoirBufferVolume, expandedReservoirBufferIn},
			(* Expanded ReservoirBufferVolume so each new ReservoirSampleOut has a volume value. *)
      expandedReservoirBufferVolume = Flatten@MapThread[ConstantArray[#1, Length[#2]]&, {Lookup[mapThreadFriendlyOptions, ReservoirBufferVolume], simulatedReservoirSamplesOut}];
			(* Expanded SampleIn for ReservoirBuffers so each new ReservoirSampleOut has a SampleIn. *)
			expandedReservoirBufferIn = Flatten@MapThread[
				If[GreaterEqualQ[Length[#2], Length[#1]],
					ConstantArray[#1, Ceiling[Length[#2]/Length[#1]]],
					Take[#1, Length[#2]]
				]&,
				{resolvedReservoirBuffers, simulatedReservoirSamplesOut}
			];
			(* Replace the model of ReservoirBuffers to simulated ReservoirBuffers. *)
			modelReservoirBufferToSimulationRules = Normal@AssociationThread[Take[Flatten@Cases[resolvedReservoirBuffers, {ObjectP[]..}], Length[First@Lookup[simulatedProtocolPackets, ReservoirBuffers]]], First@Lookup[simulatedProtocolPackets, ReservoirBuffers]];
			(* Simulate Transfer *)
			UploadSampleTransfer[
				(* convert all reservoir buffer models into Object[Sample] form *)
				expandedReservoirBufferIn/.modelReservoirBufferToSimulationRules,
				Flatten@simulatedReservoirSamplesOut,
				expandedReservoirBufferVolume,
				Upload -> False,
				FastTrack -> True,
				Simulation -> currentSimulation
			]
		]
	];

	(* UpdateSimulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[reservoirSampleTransferSimulation]];

	(* More Simulation: Call UploadSampleTransfer *)
	(* Transfer sample to drop wells then *)
	dropSampleTransferSimulation = If[MatchQ[Lookup[myResolvedOptions, PreparedPlate], True] || MatchQ[simulatedDropSamplesOut, {{}..}],
		(* What we do here is robust, if there is conflictingSampleOutLabel and no label is given to new DropSamplesOut, skip this transfer. *)
		{},
		Module[{expandedSamplesIn, expandedSampleVolumes},
			(* Expanded SampleIn so each new DropSampleOut has a SampleIn. *)
			expandedSamplesIn = Flatten@MapThread[ConstantArray[#1, Length[Keys[#2]]]&, {mySamples, dropToReservoirLabels}];
			(* Expanded SampleVolumes so each new DropSampleOut has a volume value. *)
			(* Since we need to be robust, if user-specified SampleVolumes is Null or mismatch, we set it as 0 Microliter here. *)
			expandedSampleVolumes = Flatten@MapThread[
				If[NullQ[#1],
					PadRight[ToList[#1], Length[Keys[#2]], 0 Microliter]/.Null -> 0 Microliter,
					PadRight[#1, Length[Keys[#2]], #1]/.Null -> 0 Microliter
				]&,
				{Lookup[mapThreadFriendlyOptions, SampleVolumes], dropToReservoirLabels}
			];
			(* Simulate Transfer *)
			(* What we do here is robust, if there is nonEmpty well on the destination CrystallizationPlate, skip that transfer. *)
			UploadSampleTransfer[
				expandedSamplesIn[[;;Length[Flatten@simulatedDropSamplesOut]]],
				Flatten@simulatedDropSamplesOut,
				expandedSampleVolumes[[;;Length[Flatten@simulatedDropSamplesOut]]],
				Upload -> False,
				FastTrack -> True,
				Simulation -> currentSimulation
			]
		]
	];

	(* UpdateSimulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[dropSampleTransferSimulation]];

	(* Label options *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule@@@Cases[{{Lookup[myResolvedOptions, CrystallizationPlateLabel], simulatedCrystallizationPlate}}, {_String, ObjectP[]}],
			(* Because DropSamplesOut and ReservoirSamplesOut are list of list, we need to flatten them and apply rule. *)
			Apply[Rule, #]& /@ Cases[Partition[Riffle[Flatten[Lookup[myResolvedOptions, DropSamplesOutLabel]], Flatten[simulatedDropSamplesOut]], 2], {_String, ObjectP[]}],
			Apply[Rule, #]& /@ Cases[Partition[Riffle[Flatten[Lookup[myResolvedOptions, ReservoirSamplesOutLabel]], Flatten[simulatedReservoirSamplesOut]], 2], {_String, ObjectP[]}]
		],
		LabelFields -> Join[
      Rule@@@Cases[
				{Lookup[myResolvedOptions, CrystallizationPlateLabel], (Field[CrystallizationPlateLink])},
				{_String,_}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, DropSamplesOutLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, ReservoirSamplesOutLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, ObjectP[]}
			]
		]
	];

	(* Merge our packets with our labels *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];


(* ::Subsection:: *)
(* ExperimentGrowCrystalPreview *)


DefineOptions[ExperimentGrowCrystalPreview,
	SharedOptions :> {ExperimentGrowCrystal}
];

Authors[ExperimentGrowCrystalPreview] := {"lige.tonggu", "thomas"};

ExperimentGrowCrystalPreview[
	myInputs : ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* Get the options as a list*)
	listedOptions = ToList[myOptions];

	(* Remove the Output options before passing to the main function. *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(*PlotContents, MouseOver, Tooltip*)
	(* Return only the preview for ExperimentGrowCrystal *)
	ExperimentGrowCrystal[myInputs, Append[noOutputOptions, Output -> Preview]]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentGrowCrystalQ*)


DefineOptions[ValidExperimentGrowCrystalQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentGrowCrystal}
];

Authors[ValidExperimentGrowCrystalQ] := {"lige.tonggu", "thomas"};

ValidExperimentGrowCrystalQ[myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions:OptionsPattern[]] := Module[
	{
		listedOptions, preparedOptions, experimentGrowCrystalTests, initialTestDescription, allTests, verbose, outputFormat
	},

	(* Get the options as a list. *)
	listedOptions = ToList[myOptions];

	(* Remove the Output option before passing to the core function because it doesn't make sense here. *)
	preparedOptions = DeleteCases[listedOptions, (Output|Verbose|OutputFormat) -> _];

	(* Return only the tests for ExperimentGrowCrystal. *)
	experimentGrowCrystalTests = ExperimentGrowCrystal[myInputs, Append[preparedOptions, Output -> Tests]];

	(* Define the general test description. *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all the tests, including the blanket test. *)
	allTests = If[MatchQ[experimentGrowCrystalTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{
				initialTest, validObjectBooleans, voqWarnings, inputObjects, inputStrands, inputSequences, validStrandBooleans,
				validStrandsWarnings, validSequenceBooleans, validSequencesWarnings
			},

			(* Generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* Sort inputs by what kind of input this is. *)
			inputObjects = Cases[ToList[myInputs], ObjectP[]];
			inputStrands = Cases[ToList[myInputs], StrandP[]];
			inputSequences = Cases[ToList[myInputs], SequenceP[]];

			(* Create warnings for invalid objects. *)
			validObjectBooleans = If[Length[inputObjects]>0,
				ValidObjectQ[inputObjects, OutputFormat -> Boolean],
				{}
			];
			voqWarnings = If[Length[inputObjects]>0,
				Module[{},
					MapThread[
						Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
							#2,
							True
						]&,
					{inputObjects, validObjectBooleans}
					]
				],
				{}
			];

			(* Create warnings for invalid Strands. *)
			validStrandBooleans = If[Length[inputStrands]>0,
				ValidStrandQ[inputStrands],
				{}
			];
			validStrandsWarnings = If[Length[inputStrands]>0,
				Module[{},
					MapThread[
						Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidStrandQ for more detailed information):"],
							#2,
						True
						]&,
					{inputStrands, validStrandBooleans}
					]
				],
				{}
			];

			(* Create warnings for invalid Strands. *)
			validSequenceBooleans = If[Length[inputSequences]>0,
				ValidSequenceQ[inputSequences],
				{}
			];
			validSequencesWarnings = If[Length[inputSequences]>0,
				Module[{},
					MapThread[
						Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidSequenceQ for more detailed information):"],
							#2,
							True
						]&,
					{inputSequences, validSequenceBooleans}
					]
				],
				{}
			];

			(* Get all the tests/warnings. *)
			DeleteCases[Flatten[{initialTest, experimentGrowCrystalTests, voqWarnings, validStrandsWarnings, validSequencesWarnings}], Null]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense. *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run all the tests as requested. *)
	Lookup[RunUnitTest[<|"ValidExperimentGrowCrystalQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentGrowCrystalQ"]
];



(* ::Subsubsection::Closed:: *)
