(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)
Authors[resolveExperimentSolidPhaseExtractionOptions] := {"steven","nont.kosaisawe"};
Authors[solidPhaseExtractionResourcePackets] := {"steven","nont.kosaisawe"};


(* ::Subsection:: *)
(*PresetOptions*)
DefineOptionSet[PreFlushOptions :> {
	(* IndexMatch to SampleIn *)
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> PreFlushing,
			Default -> True,
			AllowNull -> False,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if sorbent should be washed with PreFlushingSolution prior to Conditioning."
		},
		{
			OptionName -> PreFlushingSolution,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
				  {
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)",
					"PreFlushing Solution"
				  }
				}
			],
			Description -> "The solution that is used to wash the sorbent clean of any residues from manufacturing or storage processes, prior to Conditioning.",
			ResolutionDescription -> "Automatically set to match ElutingSolution if ExtractionStrategy is Positive. And automatically set to match SampleIn's Solvent field if ExtractionStrategy is Negative.",
			NestedIndexMatching -> False
		},
		{
			OptionName -> PreFlushingSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0. * Milliliter, $MaxTransferVolume],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			],
			Description -> "The amount of PreFlushingSolution is flushed through the sorbent to remove any residues prior to Conditioning.",
			ResolutionDescription -> "Automatically set to MaxVolume of ExtractionCartridge or MaxVolume of CollectionContainer, which ever is smaller.",
			NestedIndexMatching -> False
		},
		{
			OptionName -> PreFlushingSolutionTemperature,
			Default -> Ambient,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
					Units -> {Celsius, {Celsius}}
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			],
			Description -> "The set temperature that PreFlushingSolution is incubated for PreFlushingTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of PreFlushingSolution is assumed to equilibrate with the set PreFlushingSolutionTemperature."
		},
		{
			OptionName -> PreFlushingSolutionTemperatureEquilibrationTime,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Minute, $MaxExperimentTime],
				Units -> {Minute, {Second, Minute, Hour}}
			],
			Description -> "The amount of time that PreFlushingSolution is incubated to achieve the set PreFlushingTemperature. The final temperature of PreFlushingSolution is assumed to equilibrate with the the set PreFlushingTemperature.",
			ResolutionDescription -> "Automatically set to 3 Minutes, if PreFlushingTemperature is not Ambient."
		},
		{
			OptionName -> CollectPreFlushingSolution,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the PreFlushingSolution is collected after flushed through the sorbent.",
			NestedIndexMatching -> False
		},
		{
			OptionName -> PreFlushingSolutionCollectionContainer,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				ObjectTypes -> {Model[Container], Object[Container]},
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers"
					}
				}
			],
			(* TODO check for lidded container -> OpenContainer *)
			Description -> "The container that is used to accumulates any flow through solution in PreFlushing step. The collected volume might be less than PreFlushingSolutionVolume because some of PreFlushingSolution left in cartrdige (the solution is not purged through the sorbent).",
			ResolutionDescription -> "Automatically set to Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"] if Instrument is set to a Gilson liquid handler.  Automatically set to Model[Container, Vessel, \"15mL Tube\"] if Instrument is set to a Biotage PressureManifold. Automatically set to Model[Container, Plate, \"96-well UV-Star Plate\"] if Instrument is a VSpin Centrifuge.  Automatically set to Model[Container, Plate, \"96-well flat bottom plate, Sterile, Nuclease-Free\"] if Instrument is set to a HiG4 Centrifuge.  Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] otherwise.",
			NestedIndexMatching -> False
		},
		(* Injection specific *)
		{
			OptionName -> PreFlushingSolutionDispenseRate,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Quantity,
				(*TODO check syringe pump rate -> has to resolve by max rate of each equipment*)
				Pattern :> RangeP[0 * Milliliter / Minute, 1180 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Microliter, Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			],
			Description -> "The rate at which the PreFlushingSolution is applied to the sorbent by Instrument during Preflushing step.",
			ResolutionDescription -> "Automatically set to 3*Milliliter/Minute.",
			NestedIndexMatching -> False
		},
		(* TODO do it based on equipment *)
		{
			OptionName -> PreFlushingSolutionDrainTime,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Minute, $MaxExperimentTime],
				Units -> {Minute, {Second, Minute, Hour}}
			],
			Description -> "The amount of time for PreFlushingSolution to be flushed through the sorbent. If PreFlushingSolutionUntilDrained is set to True, then PreFlushingSolution is continually flushed through the ExtractionCartridge in cycle of PreFlushingSolutionDrainTime until it is drained entirely. If PreFlushingSolutionUntilDrained is set to False, then PreFlushingSolution is flushed through ExtractionCartridge for PreFlushingSolutionDrainTime once.",
			ResolutionDescription -> "If the Volume and Rate is given then it is calculate by Volume/Rate. Otherwise automatically set to 2 minutes, or the value of MaxPreFlushingSolutionDrainTime, whichever is shorter.",
			NestedIndexMatching -> False
		},
		{
			OptionName -> PreFlushingSolutionUntilDrained,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if PreFlushingSolution is continually flushed through the cartridge in cycle of every PreFlushingDrainTime until it is drained entirely, or until MaxPreFlushingDrainTime has been reached.",
			ResolutionDescription -> "Automatically set to True if ExtractionMethod are Gravity, Pressure, Vacuum or Centrifuge."
		},
		{
			OptionName -> MaxPreFlushingSolutionDrainTime,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Minute],
				Units -> {Minute, {Second, Minute, Hour}}
			],
			Description -> "Indicates the maximum amount of time to flush PreFlushingSolution through sorbent. PreFlushingSolution is flushed in cycles of PreFlushingDrainTime until either PreFlushingSolution is entirely drained or MaxPreFlushingDrainTime has been reached.",
			ResolutionDescription -> "Automatically set to 3 time of the maximum of PreFlushingDrainTime."
		},
		(* Centrifuge Specific *)
		{
			OptionName -> PreFlushingSolutionCentrifugeIntensity,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Alternatives[
				(*TODO set max -> make/check $MaxCentrifugeMaxSpeed -> 80000 RPM...sth *)
				"Speed" -> Widget[Type -> Quantity, Pattern :> RangeP[0 * RPM, 10000 * RPM], Units -> {RPM, {RPM}}],
				(*TODO - find max bound of this *)
				"Force" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}]
			],
			Description -> "The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush PreFlushingSolution through the sorbent.",
			(*TODO change to G not RPM -> max of VSpin*)
			ResolutionDescription -> "Automatically set to 50% of Centrifuge's MaxRotationRate or, if ExtractionMethod is Centrifuge."
		},
		(* Pressure Specific*)
		{
			OptionName -> PreFlushingSolutionPressure,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PreFlushing",
			Widget -> Alternatives[
				"Filter Block" -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				"Biotage or MPE2" -> Widget[
					Type -> Quantity,
					(*TODO find max pressure*)
					Pattern :> RangeP[0 * PSI, 100 * PSI, 1 * PSI],
					Units -> {PSI, {PSI, Bar, Pascal}}
				]
			],
			Description -> "The target pressure applied to the ExtractionCartridge to flush PreFlushingSolution through the sorbent. If Instrument is Model[Instrument,PressureManifold,\"MPE2\"], the PreFlushingSolutionPressure is set to be LoadingSamplePressure (Pressure of Model[Instrument,PressureManifold,\"MPE2\"] cannot be changed while the Experiment is running).",
			ResolutionDescription -> "Automatically set to 10 PSI if ExtractionMethod is Pressure, unless using a FilterBlock, in which case it is True."
		}
	]
}];
(* ::Subsection:: *)
(*OptionDefinition*)
DefineOptions[ExperimentSolidPhaseExtraction,
	Options :> {
		(* Index Matching Options to SampleIn *)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* --- STANDARD LABEL OPTIONS --- *)
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "The label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				NestedIndexMatching -> True,
				UnitOperation->True
			},
			{
				OptionName -> SourceContainerLabel,
				Default -> Automatic,
				Description -> "The label of the source container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				NestedIndexMatching -> True,
				UnitOperation->True
			},
			{
				OptionName -> PreFlushingSolutionLabel,
				Default -> Automatic,
				Description -> "The label of the PreFlushingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> ConditioningSolutionLabel,
				Default -> Automatic,
				Description -> "The label of the ConditioningSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> WashingSolutionLabel,
				Default -> Automatic,
				Description -> "The label of the WashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> SecondaryWashingSolutionLabel,
				Default -> Automatic,
				Description -> "The label of the SecondaryWashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> TertiaryWashingSolutionLabel,
				Default -> Automatic,
				Description -> "The label of the TertiaryWashingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> ElutingSolutionLabel,
				Default -> Automatic,
				Description -> "The label of the ElutingSolution that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				Description -> "The label of all collected flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> PreFlushingSampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the collected PreFlushingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> ConditioningSampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the collected ConditioningSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> LoadingSampleFlowthroughSampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the collected LoadingSample flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> WashingSampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the collected WashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> SecondaryWashingSampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the collected SecondaryWashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> TertiaryWashingSampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the collected TertiaryWashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> ElutingSampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the collected ElutingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> ContainerOutLabel,
				Default -> Automatic,
				Description -> "The label of the destination container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> ExtractionCartridgeLabel,
				Default -> Automatic,
				Description -> "The label of the ExtractionCartridge that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation->True
			},
			{
				OptionName -> SourceContainer,
				Default -> Automatic,
				ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Existing Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Container]]
					],
					"New Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Container]]
					]
				],
				Description -> "The container that the source sample will be located in during the transfer.",
				Category -> "Hidden"
			},
			(* Solid Phase Options *)
			{
				OptionName -> ExtractionStrategy,
				Default -> Positive,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Positive, Negative]
				],
				Category -> "General",
				Description -> "Strategy for SolidPhaseExtraction, where Positive means analytes of interest are adsorbed on sorbent component. Negative means that impurities adsorb onto sorbent and analytes pass through unretained. See figures..."
			},

			{
				OptionName -> ExtractionMode,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					(* TODO - there is no chiral column for now *)
					Pattern :> SeparationModeP
				],
				Category -> "General",
				Description -> "The strategy used to select the mobile phase and solid support intended to maximally separate impurities from analytes. ReversePhase separates compounds based on polarity. Sorbent material retains non-polar molecules on its surface. NormalPhase separates compounds based on polarity. Sorbent material retains polar molecules on its surface. IonExchange separates compounds based charge. Sorbent material retains charged molecules on its surface. Affinity separates compounds based on \"Lock-and-Key\" model between molecules and sorbent materials. Sorbent material selectively retains molecules of interest.",
				ResolutionDescription -> "Automatically set to match with solution and ExtractionSorbent selected."
			},

			{
				OptionName -> ExtractionSorbent,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> SolidPhaseExtractionFunctionalGroupP
					(* TODO After catalog *)
					(*)
					OpenPaths -> {
					  {
						Object[Catalog, "Root"],
						"Materials",
						"Solid Phase Extraction (SPE) Sorbent"
					  }
					}
					*)
				],
				Category -> "General",
				Description -> "The material that adsorb analytes or impurities of interest.",
				ResolutionDescription -> "Automatically resolved to C18, unless ExtractionCartridge or ExtractionSorbent is specified."
			},

			{
				OptionName -> ExtractionCartridge,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						(* Cartridges *)
						Model[Container, ExtractionCartridge], Object[Container, ExtractionCartridge],
						(* Spin column *)
						(* TODO -> need to move Model[container,vessel,SolidPhaseExtraction]*)
						Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
						(* Filter Plate *)
						(* TODO -> need to move Model[container,vessel,SolidPhaseExtractionPlate]*)
						Model[Container, Plate, Filter], Object[Container, Plate, Filter]
						(* SPE Tips *)
						(* TODO Model[Item,Tips,SolidPhaseExtraction] *)
						(* Syringe Cartridge *)
						(*						Model[Item, ExtractionCartridge]*)
					}],
					OpenPaths -> {
					  {
						Object[Catalog, "Root"],
						"Materials",
						"Solid Phase Extraction (SPE)",
						"ExtractionCartridges"
					  }
					}
				],
				Category -> "General",
				Description -> "The sorbent-packed container that forms the stationary phase of the extraction for each sample pool. Samples within the same pool are added to the same ExtractionCartridge's well or vessel, depends on the type of ExtractionCartridge (this is where pooling occurs in SolidPhaseExtraction).",
				ResolutionDescription -> "Automatically ExtractionCartridge that has C18 ExtractionSorbent, that also fit with the Instrument."
			},

			{
				OptionName -> Instrument,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler],
						Model[Instrument, PressureManifold], Object[Instrument, PressureManifold],
						Model[Instrument, Centrifuge], Object[Instrument, Centrifuge],
						Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Solid Phase Extraction (SPE)",
							"Instruments"
						}
					}
				],
				Category -> "General",
				Description -> "The Instrument that generate force to drive the fluid through the sorbent during PreFlushing, Conditioning, LoadingSample, Washing and Eluting steps.",
				ResolutionDescription -> "Automatically set to match the number of SamplesIn, Volume of all mobile phase solution and collection condition. In case that we cannot find the most compatible instrument, it will default to Gilson GX271 LiquidHandler."
			},
			{
				OptionName -> ExtractionMethod,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> SolidPhaseExtractionMethodP
				],
				Category -> "General",
				Description -> "The type of force that is used to flush fluid or sample through the sorbent.",
				ResolutionDescription -> "Automatically set to match with the chosen Instrument to run SolidPhaseExtraction."
			},
			{
				OptionName -> ExtractionTemperature,
				Default -> Ambient,
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-20 Celsius, 60 Celsius],
						Units -> {Celsius, {Celsius, Fahrenheit}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The environmental temperature where the Instrument is set up for ExperimentSolidPhaseExtraction to be performed. The solutions' temperture can be different from ExtractionTemperature."
			},
			{
				OptionName -> ExtractionCartridgeStorageCondition,
				Default -> Disposal,
				AllowNull -> True,
				Widget -> Alternatives[
					"Storage Type" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[SampleStorageTypeP, Disposal]
					],
					"Storage Object" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]],
						OpenPaths -> {
							{Object[Catalog, "Root"], "Storage Conditions"}
						}
					]
				],
				Description -> "The conditions under which ExtractionCartridges used by this experiment is stored after the protocol is completed.",
				Category -> "General"
			}
		],

		(* PreFlush Options - Start *)
		(* These options are defined in DefineOptionSet and will be adapted for all other mobile phase related options *)
		PreFlushOptions,
		(* PreFlush Options - End *)

		(* Conditioning Options - Start *)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			ModifyOptions[
				PreFlushOptions,
				PreFlushing,
				{
					Default -> True,
					Description -> "Indicates if sorbent is equilibrate with ConditioningSolution in order to chemically prepare the sorbent to bind either to analytes if ExtractionStrategy is Positive, or to impurities if ExtractionStrategy is Negative.",
					Category -> "Conditioning"
				}
			] /. {PreFlushing -> Conditioning},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolution,
				{
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
						OpenPaths -> {
						  {
							Object[Catalog, "Root"],
							"Materials",
							"Solid Phase Extraction (SPE)",
							"Conditioning Solution"
						  }
						}
					],
					Description -> "The solution that is flushed through the sorbent in order to chemically prepare the sorbent to bind either to analytes if ExtractionStrategy is Positive, or to impurities if ExtractionStrategy is Negative.",
					(*TODO Resolution description*)
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolution -> ConditioningSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionVolume,
				{
					Description -> "The amount of ConditioningSolution that is flushed through the sorbent to chemically prepare it to bind either analytes if ExtractionStrategy is Positive, or impurities if ExtractionStrategy is Negative.",
					ResolutionDescription -> "Automatically set to MaxVolume of ExtractionCartridge or MaxVolume of CollectionContainer, which ever is smaller.",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionVolume -> ConditioningSolutionVolume},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperature,
				{
					Description -> "The set temperature that ConditioningSolution is incubated for ConditioningSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of ConditioningSolution is assumed to equilibrate with the set ConditioningSolutionTemperature.",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionTemperature -> ConditioningSolutionTemperature},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperatureEquilibrationTime,
				{
					Description -> "The amount of time that ConditioningSolution is incubated to achieve the set ConditioningSolutionTemperature. The final temperature of ConditioningSolution is assumed to equilibrate with the the set ConditioningSolutionTemperature.",
					ResolutionDescription -> "Automatically set to 3 Minutes, if ConditioningSolutionTemperature is not Ambient.",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionTemperatureEquilibrationTime -> ConditioningSolutionTemperatureEquilibrationTime},
			(* Conditioning Specific *)
			(*			ModifyOptions[*)
			(*				PreFlushOptions,*)
			(*				PreFlushingEquilibrationTime,*)
			(*				{*)
			(*					Description -> "The amount of time that ConditioningSolution sits with the sorbent, to ensure that the sorbent's binding capacity is maximized.",*)
			(*					Category -> "Conditioning"*)
			(*				}*)
			(*			] /. {PreFlushingEquilibrationTime -> ConditioningEquilibrationTime},*)
			ModifyOptions[
				PreFlushOptions,
				CollectPreFlushingSolution,
				{
					Description -> "Indicates if the ConditioningSolution is collected and saved after flushing through the sorbent.",
					Category -> "Conditioning"
				}
			] /. {CollectPreFlushingSolution -> CollectConditioningSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCollectionContainer,
				{
					Description -> "The container that is used to accumulates any flow through solution in Conditioning step. The collected volume might be less than ConditioningSolutionVolume because some of ConditioningSolution left in cartrdige (the solution is not purged through the sorbent).",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionCollectionContainer -> ConditioningSolutionCollectionContainer},
			(* Injection Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDispenseRate,
				{
					Description -> "The rate at which the ConditioningSolution is applied to the sorbent by Instrument during Conditioning step.",
					ResolutionDescription -> "Automatically set to 3*Milliliter/Minute.",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionDispenseRate -> ConditioningSolutionDispenseRate},
			(* Injection, Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDrainTime,
				{
					Description -> "The amount of time to set on the Instrument for ConditioningSolution to be flushed through the sorbent. If ConditioningSolutionUntilDrained is set to True, then ConditioningSolution is continually flushed through the ExtractionCartridge in cycle of ConditioningSolutionDrainTime until it is drained entirely. If ConditioningSolutionUntilDrained is set to False, then ConditioningSolution is flushed through ExtractionCartridge for ConditioningSolutionDrainTime once.",
					ResolutionDescription -> "If the Volume and Rate is given then it is calculate by Volume/Rate. Otherwise automatically set to 2 minutes, or the value of MaxConditioningSolutionDrainTime, whichever is shorter.",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionDrainTime -> ConditioningSolutionDrainTime},
			(* Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionUntilDrained,
				{
					Description -> "Indicates if ConditioningSolution is continually flushed through the cartridge in cycle of ConditioningSolutionDrainTime until it is drained entirely, or until MaxConditioningSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to True if ExtractionMethod are Gravity, Pressure, Vacuum or Centrifuge.",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionUntilDrained -> ConditioningSolutionUntilDrained},
			ModifyOptions[
				PreFlushOptions,
				MaxPreFlushingSolutionDrainTime,
				{
					Description -> "Indicates the maximum amount of time to flush ConditioningSolution through sorbent. ConditioningSolution is flushed in cycles of every ConditioningSolutionDrainTime until MaxConditioningSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to 3 times of maximum ConditioningSolutionDrainTime.",
					Category -> "Conditioning"
				}
			] /. {MaxPreFlushingSolutionDrainTime -> MaxConditioningSolutionDrainTime},
			(* Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCentrifugeIntensity,
				{
					Description -> "The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush ConditioningSolution through the sorbent.",
					ResolutionDescription -> "Automatically set to 50% of Centrifuge's MaxRotationRate or, if ExtractionMethod is Centrifuge.",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionCentrifugeIntensity -> ConditioningSolutionCentrifugeIntensity},
			(* Pressure Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionPressure,
				{
					Description -> "The target pressure applied to the ExtractionCartridge to flush ConditioningSolution through the sorbent. If Instrument is Model[Instrument,PressureManifold,\"MPE2\"], the ConditioningSolutionPressure is set to be LoadingSamplePressure (Pressure of Model[Instrument,PressureManifold,\"MPE2\"] cannot be changed while the Experiment is running).",
					Category -> "Conditioning"
				}
			] /. {PreFlushingSolutionPressure -> ConditioningSolutionPressure},
			(* Conditioning Options - End *)

			(* LoadingSample Options - Start *)
			{
				OptionName -> LoadingSampleVolume,
				Default -> Automatic,
				AllowNull -> False,
				Category -> "LoadingSample",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter, $MaxTransferVolume],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				(* TODO still sounds weird *)
				Description -> "The amount of each individual input sample that is applied into the sorbent. LoadingSampleVolume is set to All, then all of pooled sample will be loaded in to ExtractionCartridge. If multiple samples are included in the same pool, individual samples are loaded sequentially.",
				ResolutionDescription -> "Automatically set to the whole volume of the sample or MaxVolume of ExtractionCartridge, whichever is smaller. When All is specified, it is set to the smaller of 105% of the volume of the sample or MaxVolume of ExtractionCartridge, to ensure the complete transfer.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> QuantitativeLoadingSample,
				Default -> False,
				AllowNull -> False,
				Category -> "LoadingSample",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if each individual sample source containers are rinsed with QuantitativeLoadingSampleSolution, and then that rinsed solution is applied into the sorbent to help ensure that all SampleIn is transferred to the sorbent. Only applies when LoadingSampleVolume is set to All.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> QuantitativeLoadingSampleSolution,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "LoadingSample",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Solid Phase Extraction (SPE)",
							"Conditioning Solution"
						}
					}
				],
				Description -> "Solution that is used to rinse each individual sample source containers to ensure that all SampleIn is transferred to the sorbent.",
				ResolutionDescription -> "Automatically set to ConditioningSolution.",
				NestedIndexMatching -> True
			},
			{
				OptionName -> QuantitativeLoadingSampleVolume,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "LoadingSample",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter, $MaxTransferVolume],
					Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
				],
				(* TODO change description *)
				Description -> "The amount of QuantitativeLoadingSampleSolution to added and rinsed source container of each individual sample to ensure that all SampleIn is transferred to the sorbent.",
				ResolutionDescription -> "Automatically set to 20% of volume of each individual samples or 20% of MaxVolume of source container, whichever is smaller, if QuantitativeLoadingSample is set to True.",
				NestedIndexMatching -> True
			},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperature,
				{
					Description -> "The set temperature that individual SampleIn is incubated for LoadingSampleTemperatureEquilibrationTime before being loaded into the sorbent.",
					Category -> "LoadingSample",
					NestedIndexMatching -> True
				}
			] /. {PreFlushingSolutionTemperature -> LoadingSampleTemperature},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperatureEquilibrationTime,
				{
					Description -> "The amount of time that individual samples are incubated at LoadingSampleTemperature.",
					ResolutionDescription -> "Automatically set to 3 Minutes, if LoadingSampleTemperature is not Ambient.",
					Category -> "LoadingSample",
					NestedIndexMatching -> True
				}
			] /. {PreFlushingSolutionTemperatureEquilibrationTime -> LoadingSampleTemperatureEquilibrationTime},
			ModifyOptions[
				PreFlushOptions,
				CollectPreFlushingSolution,
				{
					Default -> Automatic,
					AllowNull -> False,
					Description -> "Indicates if the any material that exit the sorbent is collected while sample is being loaded into the sorbent.",
					ResolutionDescription -> "Automatically set to True, if ExtractionStrategy is Negative. And automastically set to False, if ExtractionStrategy is Positive.",
					Category -> "LoadingSample"
				}
			] /. {CollectPreFlushingSolution -> CollectLoadingSampleFlowthrough},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCollectionContainer,
				{
					AllowNull -> True,
					Description -> "The container that is used to accumulates any material that exit the sorbent while sample is being loaded into the sorbent. The collected pooled sample flowthrough volume might be less than LoadingSampleVolume because some of SampleIn left in cartrdige (the pooled SampleIn is not purged through the sorbent).",
					Category -> "LoadingSample"
				}
			] /. {PreFlushingSolutionCollectionContainer -> LoadingSampleFlowthroughContainer},
			(* Injection specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDispenseRate,
				{
					Description -> "The rate at which individual samples are dispensed into the sorbent during sample loading.",
					ResolutionDescription -> "Automatically set to match with (Table machine).",
					Category -> "LoadingSample"
				}
			] /. {PreFlushingSolutionDispenseRate -> LoadingSampleDispenseRate},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDrainTime,
				{
					AllowNull -> False,
					Description -> "The amount of time that the sample is flushed through the sorbent after sample loading.",
					ResolutionDescription -> "If the LoadingSampleVolume and LoadingSampleDispenseRate is given then it is calculate by Volume/Rate. Otherwise automatically set to 2 minutes, or the value of SampleMaxDrainTime, whichever is shorter.",
					Category -> "LoadingSample"
				}
			] /. {PreFlushingSolutionDrainTime -> LoadingSampleDrainTime},
			(* Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionUntilDrained,
				{
					Description -> "Indicates if the sample is continually flushed through the cartridge in cycle of LoadingSampleDrainTime until it is drained entirely, or until MaxSampleDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to True if ExtractionMethod is Gravity, Pressure, Vacuum or Centrifuge.",
					Category -> "LoadingSample"
				}
			] /. {PreFlushingSolutionUntilDrained -> LoadingSampleUntilDrained},
			ModifyOptions[
				PreFlushOptions,
				MaxPreFlushingSolutionDrainTime,
				{
					Description -> "Indicates the maximum amount of time to flush the sample through sorbent. Sample is flushed in cycles of LoadingSampleDrainTime until either LoadingSampleVolume is entirely drained or MaxLoadingSampleDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to 3 * of the maximum of LoadingSampleDrainTime.",
					Category -> "LoadingSample"
				}
			] /. {MaxPreFlushingSolutionDrainTime -> MaxLoadingSampleDrainTime},
			(* Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCentrifugeIntensity,
				{
					Description -> "The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush pooled sample through the sorbent.",
					Category -> "LoadingSample"
				}
			] /. {PreFlushingSolutionCentrifugeIntensity -> LoadingSampleCentrifugeIntensity},
			(* Pressure Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionPressure,
				{
					Description -> "The target pressure applied to the ExtractionCartridge to flush pooled SampleIn through the sorbent. If Instrument is Model[Instrument,PressureManifold,\"MPE2\"], the LoadingSamplePressure applies to PreFlushingSolutionPressure, ConditioningSolutionPressure, WashingSolutionPressure and ElutingSolutionPressure as well (Pressure of Model[Instrument,PressureManifold,\"MPE2\"] cannot be changed while the Experiment is running).",
					Category -> "LoadingSample"
				}
			] /. {PreFlushingSolutionPressure -> LoadingSamplePressure},
			(* LoadSample Options - End *)

			(* Washing Options - Start *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushing,
				{
					Default -> Automatic,
					Description -> "Indicates if analyte-bound-sorbent is flushed with WashingSolution to get rid non-specific binding and and improve extraction purity.",
					ResolutionDescription -> "Automatically set to True, if ExtractionStrategy is Positive",
					Category -> "Washing"
				}
			] /. {PreFlushing -> Washing},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolution,
				{
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
						OpenPaths -> {
						  {
							Object[Catalog, "Root"],
							"Materials",
							"Solid Phase Extraction (SPE)",
							"Wash Buffers"
						  }
						}
					],
					Description -> "The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolution -> WashingSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionVolume,
				{
					Description -> "The amount of WashingSolution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
					ResolutionDescription -> "Automatically set to 10 times of MaxVolume of ExtractionCartridge or 10 times MaxVolume of WashingSolutionCollectionContainer, which ever is smaller.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionVolume -> WashingSolutionVolume},

			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperature,
				{
					Description -> "The set temperature that WashingSolution is incubated for WashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of WashingSolution is assumed to equilibrate with the set WashingSolutionTemperature.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionTemperature -> WashingSolutionTemperature},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperatureEquilibrationTime,
				{
					Description -> "The amount of time that WashingSolution is incubated to achieve the set WashingSolutionTemperature. The final temperature of WashingSolution is assumed to equilibrate with the the set WashingSolutionTemperature.",
					ResolutionDescription -> "Automatically set to 3 Minutes, if WashingSolutionTemperature is not Ambient.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionTemperatureEquilibrationTime -> WashingSolutionTemperatureEquilibrationTime},
			(* Washing Specific *)
			ModifyOptions[
				PreFlushOptions,
				CollectPreFlushingSolution,
				{
					Description -> "Indicates if the WashingSolution is collected and saved after flushing through the sorbent.",
					Category -> "Washing"
				}
			] /. {CollectPreFlushingSolution -> CollectWashingSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCollectionContainer,
				{
					Description -> "The container that is used to accumulates any flow through solution in Washing step. The collected volume might be less than WashingSolutionVolume because some of WashingSolution left in cartrdige (the solution is not purged through the sorbent).",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionCollectionContainer -> WashingSolutionCollectionContainer},
			(* Injection Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDispenseRate,
				{
					Description -> "The rate at which the WashingSolution is applied to the sorbent by Instrument during Washing step.",
					ResolutionDescription -> "Automatically set to 3*Milliliter/Minute.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionDispenseRate -> WashingSolutionDispenseRate},
			(* Injection, Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDrainTime,
				{
					Description -> "The amount of time to set on the Instrument for WashingSolution to be flushed through the sorbent. If WashingSolutionUntilDrained is set to True, then WashingSolution is continually flushed thorugh the ExtractionCartridge in cycle of WashingSolutionDrainTime until it is drained entirely. If WashingSolutionUntilDrained is set to False, then WashingSolution is flushed through ExtractionCartridge for WashingSolutionDrainTime once.",
					ResolutionDescription -> "If the Volume and Rate is given then it is calculate by Volume/Rate. Otherwise automatically set to 2 minutes, or the value of MaxWashingSolutionDrainTime, whichever is shorter.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionDrainTime -> WashingSolutionDrainTime},
			(* Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionUntilDrained,
				{
					Description -> "Indicates if WashingSolution is continually flushed through the cartridge in cycle of WashingSolutionDrainTime until it is drained entirely, or until MaxWashingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to True if ExtractionMethod are Gravity, Pressure, Vacuum or Centrifuge.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionUntilDrained -> WashingSolutionUntilDrained},
			ModifyOptions[
				PreFlushOptions,
				MaxPreFlushingSolutionDrainTime,
				{
					Description -> "Indicates the maximum amount of time to flush WashingSolution through sorbent. WashingSolution is flushed in cycles of every WashingSolutionDrainTime until MaxWashingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to 3 times of maximum WashingSolutionDrainTime.",
					Category -> "Washing"
				}
			] /. {MaxPreFlushingSolutionDrainTime -> MaxWashingSolutionDrainTime},
			(* Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCentrifugeIntensity,
				{
					Description -> "The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush WashingSolution through the sorbent.",
					ResolutionDescription -> "Automatically set to 50% of Centrifuge's MaxRotationRate or, if ExtractionMethod is Centrifuge.",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionCentrifugeIntensity -> WashingSolutionCentrifugeIntensity},
			(* Pressure Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionPressure,
				{
					Description -> "The target pressure applied to the ExtractionCartridge to flush WashingSolution through the sorbent. If Instrument is Model[Instrument,PressureManifold,\"MPE2\"], the WashingSolutionPressure is set to be LoadingSamplePressure (Pressure of Model[Instrument,PressureManifold,\"MPE2\"] cannot be changed while the Experiment is running).",
					Category -> "Washing"
				}
			] /. {PreFlushingSolutionPressure -> WashingSolutionPressure},
			(* Washing Options - End *)

			(* SecondaryWashing Options - Start *)
			(*NOT IndexMatch to SampleIn*)
			ModifyOptions[
				PreFlushOptions,
				PreFlushing,
				{
					Default -> Automatic,
					Description -> "Indicates if analyte-bound-sorbent is flushed with SecondaryWashingSolution to get rid non-specific binding and and improve extraction purity.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushing -> SecondaryWashing},

			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolution,
				{
					Default -> Automatic,
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Solid Phase Extraction (SPE)",
								"Wash Buffers"
							}
						}
					],
					Description -> "The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolution.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolution -> SecondaryWashingSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionVolume,
				{
					Default -> Automatic,
					Description -> "The amount of SecondaryWashingSolution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionVolume.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionVolume -> SecondaryWashingSolutionVolume},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperature,
				{
					Default -> Automatic,
					Description -> "The set temperature that SecondaryWashingSolution is incubated for SecondaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of SecondaryWashingSolution is assumed to equilibrate with the set SecondaryWashingSolutionTemperature.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionTemperature.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionTemperature -> SecondaryWashingSolutionTemperature},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperatureEquilibrationTime,
				{
					Default -> Automatic,
					Description -> "The amount of time that SecondaryWashingSolution is incubated to achieve the set SecondaryWashingSolutionTemperature. The final temperature of SecondaryWashingSolution is assumed to equilibrate with the the set SecondaryWashingSolutionTemperature.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionTemperatureEquilibrationTime.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionTemperatureEquilibrationTime -> SecondaryWashingSolutionTemperatureEquilibrationTime},
			ModifyOptions[
				PreFlushOptions,
				CollectPreFlushingSolution,
				{
					Default -> Automatic,
					Description -> "Indicates if the SecondaryWashingSolution is collected and saved after flushing through the sorbent.",
					ResolutionDescription -> "Automatically set to be the same as CollectionWashingSolution.",
					Category -> "SecondaryWashing"
				}
			] /. {CollectPreFlushingSolution -> CollectSecondaryWashingSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCollectionContainer,
				{
					Default -> Automatic,
					Description -> "The container that is used to accumulates any flow through solution in SecondaryWashing step. The collected volume might be less than SecondaryWashingSolutionVolume because some of SecondaryWashingSolution left in cartrdige (the solution is not purged through the sorbent).",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionCollectionContainer",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionCollectionContainer -> SecondaryWashingSolutionCollectionContainer},
			(* Injection Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDispenseRate,
				{
					Default -> Automatic,
					Description -> "The rate at which the SecondaryWashingSolution is applied to the sorbent by Instrument during SecondaryWashing step.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionDispenseRate.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionDispenseRate -> SecondaryWashingSolutionDispenseRate},
			(* Injection, Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDrainTime,
				{
					Default -> Automatic,
					Description -> "The amount of time to set on the Instrument for SecondaryWashingSolution to be flushed through the sorbent. If SecondaryWashingSolutionUntilDrained is set to True, then SecondaryWashingSolution is continually flushed thorugh the ExtractionCartridge in cycle of SecondaryWashingSolutionDrainTime until it is drained entirely. If SecondaryWashingSolutionUntilDrained is set to False, then SecondaryWashingSolution is flushed through ExtractionCartridge for SecondaryWashingSolutionDrainTime once.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionDrainTime.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionDrainTime -> SecondaryWashingSolutionDrainTime},
			(* Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionUntilDrained,
				{
					Default -> Automatic,
					Description -> "Indicates if SecondaryWashingSolution is continually flushed through the cartridge in cycle of SecondaryWashingSolutionDrainTime until it is drained entirely, or until MaxSecondaryWashingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionUntilDrained.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionUntilDrained -> SecondaryWashingSolutionUntilDrained},
			ModifyOptions[
				PreFlushOptions,
				MaxPreFlushingSolutionDrainTime,
				{
					Default -> Automatic,
					Description -> "Indicates the maximum amount of time to flush SecondaryWashingSolution through sorbent. SecondaryWashingSolution is flushed in cycles of every SecondaryWashingSolutionDrainTime until MaxSecondaryWashingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to be the same as MaxWashingSolutionDrainTime.",
					Category -> "SecondaryWashing"
				}
			] /. {MaxPreFlushingSolutionDrainTime -> MaxSecondaryWashingSolutionDrainTime},
			(* Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCentrifugeIntensity,
				{
					Default -> Automatic,
					Description -> "The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush SecondaryWashingSolution through the sorbent.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionCentrifugeIntensity.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionCentrifugeIntensity -> SecondaryWashingSolutionCentrifugeIntensity},
			(* Pressure Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionPressure,
				{
					Default -> Automatic,
					Description -> "The target pressure applied to the ExtractionCartridge to flush SecondaryWashingSolution through the sorbent. If Instrument is Model[Instrument,PressureManifold,\"MPE2\"], the SecondaryWashingSolutionPressure is set to be LoadingSamplePressure (Pressure of Model[Instrument,PressureManifold,\"MPE2\"] cannot be changed while the Experiment is running).",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionPressure.",
					Category -> "SecondaryWashing"
				}
			] /. {PreFlushingSolutionPressure -> SecondaryWashingSolutionPressure},
			(* SecondaryWashing Options - End *)

			(* TertiaryWashing Options - Start *)
			(*NOT IndexMatch to SampleIn*)
			ModifyOptions[
				PreFlushOptions,
				PreFlushing,
				{
					Default -> Automatic,
					Description -> "Indicates if analyte-bound-sorbent is flushed with TertiaryWashingSolution to get rid non-specific binding and and improve extraction purity.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushing -> TertiaryWashing},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolution,
				{
					Default -> Automatic,
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Solid Phase Extraction (SPE)",
								"Wash Buffers"
							}
						}
					],
					Description -> "The solution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolution.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolution -> TertiaryWashingSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionVolume,
				{
					Default -> Automatic,
					Description -> "The amount of TertiaryWashingSolution that is flushed through the analyte-bound-sorbent to get rid of non-specific binding and improve extraction purity.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionVolume.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionVolume -> TertiaryWashingSolutionVolume},
			(* NOT IndexMatch to SampleIn *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperature,
				{
					Default -> Automatic,
					Description -> "The set temperature that TertiaryWashingSolution is incubated for TertiaryWashingSolutionTemperatureEquilibrationTime before being flushed through the sorbent. The final temperature of TertiaryWashingSolution is assumed to equilibrate with the set TertiaryWashingSolutionTemperature.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionTemperature.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionTemperature -> TertiaryWashingSolutionTemperature},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperatureEquilibrationTime,
				{
					Default -> Automatic,
					Description -> "The amount of time that TertiaryWashingSolution is incubated to achieve the set TertiaryWashingSolutionTemperature. The final temperature of TertiaryWashingSolution is assumed to equilibrate with the the set TertiaryWashingSolutionTemperature.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionTemperatureEquilibrationTime.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionTemperatureEquilibrationTime -> TertiaryWashingSolutionTemperatureEquilibrationTime},
			ModifyOptions[
				PreFlushOptions,
				CollectPreFlushingSolution,
				{
					Default -> Automatic,
					Description -> "Indicates if the TertiaryWashingSolution is collected and saved after flushing through the sorbent.",
					ResolutionDescription -> "Automatically set to be the same as CollectionWashingSolution.",
					Category -> "TertiaryWashing"
				}
			] /. {CollectPreFlushingSolution -> CollectTertiaryWashingSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCollectionContainer,
				{
					Default -> Automatic,
					Description -> "The container that is used to accumulates any flow through solution in TertiaryWashing step. The collected volume might be less than TertiaryWashingSolutionVolume because some of TertiaryWashingSolution left in cartrdige (the solution is not purged through the sorbent).",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionCollectionContainer",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionCollectionContainer -> TertiaryWashingSolutionCollectionContainer},
			(* Injection Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDispenseRate,
				{
					Default -> Automatic,
					Description -> "The rate at which the TertiaryWashingSolution is applied to the sorbent by Instrument during TertiaryWashing step.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionDispenseRate.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionDispenseRate -> TertiaryWashingSolutionDispenseRate},
			(* Injection, Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDrainTime,
				{
					Default -> Automatic,
					Description -> "The amount of time to set on the Instrument for TertiaryWashingSolution to be flushed through the sorbent. If TertiaryWashingSolutionUntilDrained is set to True, then TertiaryWashingSolution is continually flushed thorugh the ExtractionCartridge in cycle of TertiaryWashingSolutionDrainTime until it is drained entirely. If TertiaryWashingSolutionUntilDrained is set to False, then TertiaryWashingSolution is flushed through ExtractionCartridge for TertiaryWashingSolutionDrainTime once.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionDrainTime.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionDrainTime -> TertiaryWashingSolutionDrainTime},
			(* Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionUntilDrained,
				{
					Default -> Automatic,
					Description -> "Indicates if TertiaryWashingSolution is continually flushed through the cartridge in cycle of TertiaryWashingSolutionDrainTime until it is drained entirely, or until MaxTertiaryWashingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionUntilDrained.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionUntilDrained -> TertiaryWashingSolutionUntilDrained},
			ModifyOptions[
				PreFlushOptions,
				MaxPreFlushingSolutionDrainTime,
				{
					Default -> Automatic,
					Description -> "Indicates the maximum amount of time to flush TertiaryWashingSolution through sorbent. TertiaryWashingSolution is flushed in cycles of every TertiaryWashingSolutionDrainTime until MaxTertiaryWashingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to be the same as MaxWashingSolutionDrainTime.",
					Category -> "TertiaryWashing"
				}
			] /. {MaxPreFlushingSolutionDrainTime -> MaxTertiaryWashingSolutionDrainTime},
			(* Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCentrifugeIntensity,
				{
					Default -> Automatic,
					Description -> "The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush TertiaryWashingSolution through the sorbent.",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionCentrifugeIntensity.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionCentrifugeIntensity -> TertiaryWashingSolutionCentrifugeIntensity},
			(* Pressure Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionPressure,
				{
					Default -> Automatic,
					Description -> "The target pressure applied to the ExtractionCartridge to flush TertiaryWashingSolution through the sorbent. If Instrument is Model[Instrument,PressureManifold,\"MPE2\"], the TertiaryWashingSolutionPressure is set to be LoadingSamplePressure (Pressure of Model[Instrument,PressureManifold,\"MPE2\"] cannot be changed while the Experiment is running).",
					ResolutionDescription -> "Automatically set to be the same as WashingSolutionPressure.",
					Category -> "TertiaryWashing"
				}
			] /. {PreFlushingSolutionPressure -> TertiaryWashingSolutionPressure},
			(* TertiaryWashing Options - End *)

			(* Eluting Options - Start *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushing,
				{
					(*Default to False, since it won't be used in Negative Strategy*)
					Default -> Automatic,
					Description -> "Indicates if sorbent is flushed with ElutingSolution to release bound analyte from the sorbent.",
					ResolutionDescription -> "Automatically set to True, if ExtractionStrategy is Positive",
					Category -> "Eluting"
				}
			] /. {PreFlushing -> Eluting},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolution,
				{
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Solid Phase Extraction (SPE)",
								"Elution Buffers"
							}
						}
					],
					Description -> "The solution that is used to flush and release bound analyte from the sorbent.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolution -> ElutingSolution},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionVolume,
				{
					Description -> "The amount of EluteSolution that is flushed through the sorbent to release analyte from the sorbent.",
					ResolutionDescription -> "Automatically set to 25% of MaxVolume of ExtractionCartridge.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionVolume -> ElutingSolutionVolume},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperature,
				{
					Description -> "The set temperature that ElutingSolution is incubated for ElutingSolutionTemperatureEquilibrationTime before being loaded into the sorbent.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionTemperature -> ElutingSolutionTemperature},
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionTemperatureEquilibrationTime,
				{
					Description -> "The amount of time that ElutingSolution is incubated to achieve the set ElutingSolutionTemperature. The final temperature of ElutingSolution is assumed to equilibrate with the the set ElutingSolutionTemperature.",
					ResolutionDescription -> "Automatically set to 3 Minutes, if ElutingSolutionTemperature is not Ambient.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionTemperatureEquilibrationTime -> ElutingSolutionTemperatureEquilibrationTime},
			ModifyOptions[
				PreFlushOptions,
				CollectPreFlushingSolution,
				{
					Default -> Automatic,
					Description -> "Indicates if the ElutingSolution is collected and saved after flushing through the sorbent.",
					ResolutionDescription -> "Automatically set to True, if ExtractionStrategy is Positive.",
					Category -> "Eluting"
				}
			] /. {CollectPreFlushingSolution -> CollectElutingSolution},
			(* Eluting Specific *)
			(* TODO - add purge option -> may be not if we allow user use max spin/Pressure/Vacuum *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCollectionContainer,
				{
					Description -> "The container that is used to accumulates any flow through solution in Eluting step. The collected volume might be less than ElutingSolutionVolume because some of ElutingSolution left in cartrdige (the solution is not purged through the sorbent).",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionCollectionContainer -> ElutingSolutionCollectionContainer},
			(* Injection Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDispenseRate,
				{
					Description -> "The rate at which the ElutingSolution is applied to the sorbent by Instrument during Eluting step.",
					ResolutionDescription -> "Automatically set to 3*Milliliter/Minute.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionDispenseRate -> ElutingSolutionDispenseRate},
			(* Injection, Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionDrainTime,
				{
					Description -> "The amount of time to set on the Instrument for ElutingSolution to be flushed through the sorbent. If ElutingSolutionUntilDrained is set to True, then ElutingSolution is continually flushed thorugh the ExtractionCartridge in cycle of ElutingSolutionDrainTime until it is drained entirely. If ElutingSolutionUntilDrained is set to False, then ElutingSolution is flushed through ExtractionCartridge for ElutingSolutionDrainTime once.",
					ResolutionDescription -> "If the Volume and Rate is given then it is calculate by Volume/Rate. Otherwise automatically set to 2 minutes, or the value of MaxElutingSolutionDrainTime, whichever is shorter.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionDrainTime -> ElutingSolutionDrainTime},
			(* Gravity, Pressure, Vacuum and Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionUntilDrained,
				{
					Description -> "Indicates if ElutingSolution is continually flushed through the cartridge in cycle of ElutingSolutionDrainTime until it is drained entirely, or until MaxElutingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to True if ExtractionMethod are Gravity, Pressure, Vacuum or Centrifuge.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionUntilDrained -> ElutingSolutionUntilDrained},
			ModifyOptions[
				PreFlushOptions,
				MaxPreFlushingSolutionDrainTime,
				{
					Description -> "Indicates the maximum amount of time to flush ElutingSolution through sorbent. ElutingSolution is flushed in cycles of every ElutingSolutionDrainTime until MaxElutingSolutionDrainTime has been reached.",
					ResolutionDescription -> "Automatically set to 3 times of maximum ElutingSolutionDrainTime.",
					Category -> "Eluting"
				}
			] /. {MaxPreFlushingSolutionDrainTime -> MaxElutingSolutionDrainTime},
			(* Centrifuge Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionCentrifugeIntensity,
				{
					Description -> "The rotational speed or gravitational force at which the ExtractionCartridge is centrifuged to flush ElutingSolution through the sorbent.",
					ResolutionDescription -> "Automatically set to 50% of Centrifuge's MaxRotationRate or, if ExtractionMethod is Centrifuge.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionCentrifugeIntensity -> ElutingSolutionCentrifugeIntensity},
			(* Pressure Specific *)
			ModifyOptions[
				PreFlushOptions,
				PreFlushingSolutionPressure,
				{
					Description -> "The target pressure applied to the ExtractionCartridge to flush ElutingSolution through the sorbent. If Instrument is Model[Instrument,PressureManifold,\"MPE2\"], the ElutingSolutionPressure is set to be LoadingSamplePressure (Pressure of Model[Instrument,PressureManifold,\"MPE2\"] cannot be changed while the Experiment is running).",
					ResolutionDescription -> "Automatically set to 10 PSI. Applies to ExtractionMethod : Pressure.",
					Category -> "Eluting"
				}
			] /. {PreFlushingSolutionPressure -> ElutingSolutionPressure},

			(*Hidden options to pass between options resolver and packet*)
			{
				OptionName -> SPEBatchID,
				Default -> Null,
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> Expression,
					Pattern :> _String | Null,
					Size -> Line
				],
				Description -> "Indicate the batch that SampleIn will be run together."
			},
			(* TODO what is this option?? *)
			{
				OptionName -> AliquotTargets,
				Default -> Null,
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Adder[Alternatives[
					Widget[
						Type -> Expression,
						Pattern :> {WellPositionP, _?QuantityQ, _String, ObjectP[]},
						Size -> Line
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					]
				]],
				NestedIndexMatching -> True,
				Description -> "Indicate the target aliquot volume, wells and container to be used before running SPE."
			},
			{
				OptionName -> CartridgePlacement,
				Default -> Null,
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> Expression,
					Pattern :> _String | WellPositionP | _?NumericQ,
					Size -> Line
				],
				Description -> "Indicate the location of ExtractionCartridge where the pooled SamplesIn will go into."
			},
			{
				OptionName -> PreFlushingCollectionContainerOutLabel,
				Default -> Null,
				Description -> "The label of the collection container for PreFlushingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ConditioningCollectionContainerOutLabel,
				Default -> Null,
				Description -> "The label of the collection container for ConditioningSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> LoadingSampleFlowthroughCollectionContainerOutLabel,
				Default -> Null,
				Description -> "The label of the collection container for LoadingSample flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> WashingCollectionContainerOutLabel,
				Default -> Null,
				Description -> "The label of the collection container for WashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SecondaryWashingCollectionContainerOutLabel,
				Default -> Null,
				Description -> "The label of the collection container for SecondaryWashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				]
			},
			{
				OptionName -> TertiaryWashingCollectionContainerOutLabel,
				Default -> Null,
				Description -> "The label of the collection container for TertiaryWashingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ElutingCollectionContainerOutLabel,
				Default -> Null,
				Description -> "The label of the collection container for ElutingSolution flowthrough sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ContainerOutWellAssignment,
				Default -> Null,
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> Expression,
					Pattern :> _String | WellPositionP | _?NumericQ,
					Size -> Line
				],
				Description -> "Indicate the target well that SamplesOut will be filled in the container."
			}
		],
		(* Shared Options *)
		WorkCellOption,
		ProtocolOptions,
		ModifyOptions[
			ModelInputOptions,
			{
				{
					OptionName -> PreparedModelAmount,
					NestedIndexMatching -> True
				},
				{
					OptionName -> PreparedModelContainer,
					NestedIndexMatching -> True
				}
			}
		],
		SamplePrepOptionsNestedIndexMatching,
		NonBiologyPostProcessingOptions,
		PooledSamplesInStorageOption,
		SamplesOutStorageOptions,
		PreparationOption,
		SimulationOption, (* TODO: Remove this and add to ProtocolOptions when it is time to blitz. Also add SimulateProcedureOption. *)
		PrimitiveOutputOption
	}
];

(* ::Subsection:: *)
(*ErrorDefinition*)
Warning::mtwarningExtractionStrategyElutingIncompatible = "ExtractionStrategy Negative for SamplesIn `1` are now switched to Positive because Eluting is set to True or ElutingSolution was defined.";
Error::TooLargeRequestVolume = "The requested LoadingSampleVolume of `1` for samples `3` are larger than the actual sample volume `2`.";
Error::ConflictingMobilePhaseOptions = "The following options `1` are conflicting with each other and cannot be supported by existing Instrument. Please allow these options to be automatic.";
Error::SPECannotSupportVolume = "Currently, SolidPhaseExtraction cannot support LoadingSampleVolume of `1`.";
Error::GX271tooManyCollectionPlate = "The maximum number of collection plate on the deck of `1` is 1, please consider changing the following options `2`.";
Error::SPECannotSupportExtractionMethod = "SolidPhaseExtraction cannot support the following ExtractionMethod `1`.";
Error::SPECannotSupportSamples = "SolidPhaseExtraction cannot find supporting Instrument for SamplesIn `1`, because one of the following Options `2` are conflicting. Please consider changing these options to be Automatic.";
Error::SPECentrifugeIntensityTooHigh = "The centrifuge options `3` with value `1` is above the limit of Instrument `2` OR we do not have Instrument that can support that specified CentrifugeIntensity.";
Error::SPEExtractionCartidgeTooLargeForInstrument = "The following extraction cartridges `1` cannot run SolidPhaseExtraction with the following instrument `2` because the size is too big. Only 3 ml cartridge can fit on the current instrument.";
Warning::SPEExtractionCartridgeAndSorbentMismatch = "The supplied ExtractionCartridge `1` do not have the same ExtractionSorbent as supplied `2`.";
Warning::PressureMustBeBoolean = "The option `2` for following Instrument `1` has to be True or False, and it is now converted to True.";
Error::DispenseRateOutOfBound = "The DispenseRate that the following Instrument `1` can generate are `2`. Your current setting for Option `3` are `4`. Please adjust the DispenseRate to be within Instrument limits.";
Error::errorAmbientOnlyInstrument = "The following Instruments `1` can only run SolidPhaseExtraction at Ambient temperature only and they cannot support the following ExtractionTemperature `2`. Please consider using other instrument that can support the indicated ExtractionTemperature, or set ExtractionTemperature to Ambient.";
Error::ExtractionTemperatureOutOfBound = "The following Instruments `1` can only run SolidPhaseExtraction at temperature `2`. The following ExtractionTemperature `3` is out of Instrument limits. Please consider using other instrument that can support the indicated ExtractionTemperature, or set ExtractionTemperature to be within Instrument limits.";
Error::incompatibleInstrumentAndCollectionContainer = "The following container `1` in Option `2` is not compatible with Instrument `3`. Instrument `3` can support the following container `4`. Please change `2` accordingly.";
Warning::PositiveStrategyWithoutEluting = "ExtractionStrategy for SamplesIn `1` are Positive, however you are not eluting purified samples out. Please consider changing Options Eluting or CollectElutingSolution to True or define ElutingSolution.";
Warning::ExtractionStrategyTertiaryWashingSwitchIncompatible = "ExtractionStrategy Negative for SamplesIn `1` are now switched to Positive because TertiaryWashing is set to True or TertiaryWashingSolution was defined.";
Warning::ExtractionStrategySecondaryWashingSwitchIncompatible = "ExtractionStrategy Negative for SamplesIn `1` are now switched to Positive because SecondaryWashing is set to True or SecondaryWashingSolution was defined.";
Warning::ExtractionStrategyWashingSwitchIncompatible = "ExtractionStrategy Negative for SamplesIn `1` are now switched to Positive because Washing is set to True or WashingSolution was defined.";
Error::skippedSecondaryWashingError = "TertiaryWashing step is used, while the SecondaryWashing step has not been used yet. Please change the following Options `1` to Automatic or set SecondaryWashing Option to True";
Error::skippedWashingError = "SecondaryWashing step is used, while the Washing step has not been used yet. Please change the following Options `1` to Automatic or set Washing Option to True";
Error::GX271tooManySolutionBottle = "The maximum number of solution type on the deck of `1` is 4, please consider changing the following options `2` to be the same type of Solution so that there will be enough room to fit all the solution bottle.";
Error::SPEInstrumentCannotSupportRinseAndReload = "The current Instrument `1` cannot support QuantitativeLoadingSample, please considering specify Instrument to `2` or change the following options `3`."
Error::SPEInstrumentCannotSupportSolution = "The current Instrument `1` can only support QuantitativeLoadingSampleSolution that match with ConditioningSolution.";
Error::NotSPECartridge = "The following cartrdige(s) `1` are not SolidPhaseExtraction Cartridge ";
Error::SPECannotSupportSolutionVolume = "SolidPhaseExtraction cannot find supporting Instrument for SamplesIn `1`, the volume of `2` is too large.";
Error::SPEInstrumentCannotSupportSolutionVolume = "Following ExtractionCartridge `1` or CollectionContainer `2` cannot support `3` because `4` are too large. The minimum of the MaxVolume of these cartridges/collection containers are `5`.";
Error::NotSPEInstrument = "The following Instrument(s) `1` are not Instrument for SolidPhaseExtraction.";
Error::SPEInstrumentNotSupportSolutionTemperature = "SolidPhaseExtraction cannot support `1` at `2` setting, because temperature setting is only allowed on Instrument `3`.";
Error::SPEcannotFindCartridgeWithSorbentError = "SolidPhaseExtraction cannot find ExtractionCartridge with ExtractionSorbent `1`,please change `2` option";
Error::SPEInputLiquidHandlerIncompatible = "The following input sample(s) `1` have LiquidHandlerIncompatible -> True, but the Preparation option is set to Robotic.  Please set Preparation to Manual, or use different samples that are compatible with robotic liquid handling.";
Error::SPESolutionsLiquidHandlerIncompatible = "The following PreWashing, Conditioning, Washing, or Eluting sample(s) `1` have LiquidHandlerIncompatible -> True, but the Preparation option is set to Robotic.  Please set Preparation to Manual, or use different solutions that are compatible with robotic liquid handling.";

Error::DiscardedSPESolutions = "The following solutions `1` are discarded and cannot be used in SolidPhaseExtraction.";
Error::DuplicateSPECartridgeObjects = "The following supplied Cartridge Objects, `1`, are present more than once in the Cartridge Option. Each sample pool must be associated with a unique Cartridge Object. Please ensure there are no duplicate Object[Container]s in the Cartridge.";
Error::SPEManualCurrentlyNotSupported = "The Preparation option was either set to Manual directly, or samples or options were specified that caused it to be automatically set to Manual.  Currently only Robotic SolidPhaseExtraction is supported, and Manual SolidPhaseExtraction is coming soon.  Please set Preparation -> Robotic and allow Instrument to be set automatically.";


(* ::Subsection:: *)
(*ExperimentSolidPhaseExtraction (Mix Overload)*)
(* Mixed Input *)
ExperimentSolidPhaseExtraction[mySemiPooledInputs : ListableP[ListableP[Alternatives[ObjectP[{Object[Sample], Object[Container], Model[Sample]}], _String]]], myOptions : OptionsPattern[]] := Module[
	{outputSpecification, output, gatherTests,
		(* Inputs and Options Lists*)
		listedOptions, semiPooledSamplesObjects, listedInputs,
		validSamplePreparationResult, containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation,
		(* Container Outputs *)
		containerToSampleResult, containerToSampleOutput,
		containerToSampleTests, samples, sampleOptions
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links and named objects. *)
	{semiPooledSamplesObjects, listedOptions} = {ToList[mySemiPooledInputs], ToList[myOptions]};

	(* Wrap a list around any single inputs to make pools *)
	listedInputs = Map[
		If[
			(* Except, if Object is Plate, don't wrap list on it, otherwise it will be a pooled sample*)
			Not[MatchQ[#, ObjectP[Object[Container, Plate]]]],
			ToList[#],
			#
		]&,
		ToList[semiPooledSamplesObjects]
	];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentSolidPhaseExtraction,
			listedInputs,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];
		Return[$Failed]
	];

	(* for each group, mapping containerToSampleOptions over each group to get the samples out *)
	(* ignoring the options, since'll use the ones from from ExpandIndexMatchedInputs *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = pooledContainerToSampleOptions[
			ExperimentSolidPhaseExtraction,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore,we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation, containerToSampleTests} = Append[
				pooledContainerToSampleOptions[
					ExperimentSolidPhaseExtraction,
					mySamplesWithPreparedSamples,
					myOptionsWithPreparedSamples,
					Output -> {Result, Simulation},
					Simulation -> updatedSimulation
				],
				{}
			],
			$Failed,
			{Error::EmptyContainers}
		]
	];

	(* If we were given an empty container,return early. *)
	If[ContainsAny[containerToSampleResult, {$Failed}],
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

		(* take the samples from the mapped containerToSampleOptions, and the options from expandedOptions, this way we'll end up
		 index matching each grouping to an option *)
		ExperimentSolidPhaseExtractionCore[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];
(* ::Subsection:: *)
(*ExperimentSolidPhaseExtraction (Sample overload)*)
ExperimentSolidPhaseExtractionCore[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ExperimentSolidPhaseExtraction]] := Module[
	{
		(* type of function output*)
		outputSpecification, output, gatherTests,
		(* clean up input *)
		pooledSamples, listedOptions, cacheBall, cacheOption,
		(* sample simulation *)
		validSamplePreparationResult, mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed,
		(* call safe options *)
		safeOpsNamed, safeOpsTests,
		(* sanitized inputs *)
		mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples,
		validLengths, validLengthTests,
		(* template options *)
		templatedOptions, templateTests, inheritedOptions, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, expandedSafeOps,
		(* resolved options *)
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests,
		collapsedResolvedOptions,
		(* cache details *)
		packetSampleObject,
		packetSampleObjectModel,
		packetSampleContainerObject,
		packetSampleContainerModel,
		packetSampleModel,
		packetContainerObject,
		packetContainerObjectModel,
		packetContainerModel,
		packetCartridgeModel,
		packetCartridgeObjectModel,
		packetInstrumentModel,
		packetInstrumentObjectModel,
		mainDownloadCache, tableExtractionOptions,
		allPreDefinedInstrumentModels,
		specifiedInstrumentObject,
		specifiedInstrumentModel,
		allExtractionCartridgeType,
		allPreDefinedExtractionCartridgeModels,
		specifiedCartridgeModel,
		specifiedCartridgeObject,
		flatSampleList,
		preferredContainersModels,
		defaultContainerFromTable,
		allContainerOptions,
		specifiedContainerObjects,
		specifiedContainerModels,
		objectSampleFields,
		modelContainerFields,
		objectContainerFields,
		cartridgeFields,
		instrumentFields,
		defaultPlateContainer,
		gilsonContainers,
		solutionSamples,
		allSolutionOptions,
		solutionSamplesModel,
		solutionContainers,
		modelSampleFields,
		allSamplesObjectList,
		allSamplesModelList,
		allContainerObjectList,
		allContainerModelList,
		allCartridgeModel,
		allInstrumentModel,
		(* resource picking and simulation *)
		resourcePackets, runTime, resourcePacketTests, postResourcePacketsSimulation,
		updatedSimulation,
		resolvedPreparation,
		returnEarlyQ,
		performSimulationQ, resourcePacketsResult,
		simulatedProtocol, resultQ,
		simulation,
		result,
		postProcessingOptions
	},

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links and named objects. *)
	{pooledSamples, listedOptions} = removeLinks[ToList[myPooledSamples], ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption = ToList[Lookup[listedOptions, Cache, {}]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentSolidPhaseExtraction,
			pooledSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentSolidPhaseExtraction, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentSolidPhaseExtraction, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Sanitize named inputs *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentSolidPhaseExtraction, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentSolidPhaseExtraction, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
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
		ApplyTemplateOptions[ExperimentSolidPhaseExtraction, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentSolidPhaseExtraction, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
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

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentSolidPhaseExtraction, {mySamplesWithPreparedSamples}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* -- search for relevant items -- *)
	(* the main reason why speTableFunction exist, there are 2 places that all instrument got called 1. here, 2. inside resolver *)
	tableExtractionOptions = speTableFunction["speExtractionOptions"];

	(* list all instrument and cartridge models by calling the table *)
	allPreDefinedInstrumentModels = Union[Lookup[tableExtractionOptions, "Instrument"]];
	(* any Object options that user might specified, list it here *)
	specifiedInstrumentObject = Cases[Lookup[expandedSafeOps, {Instrument, CentrifugeInstrument}], ObjectReferenceP[Object], Infinity];
	specifiedInstrumentModel = Cases[Lookup[expandedSafeOps, {Instrument, CentrifugeInstrument}], ObjectReferenceP[Model], Infinity];

	(* for extraction cartridge, look for all type of cartridge that could fit *)
	allExtractionCartridgeType = Flatten[Union[Lookup[tableExtractionOptions, "ExtractionCartridgeType"]]];
	(* query for all SPE cartridge *)
	allPreDefinedExtractionCartridgeModels = Search[allExtractionCartridgeType, SeparationMode != Null];
	(* do the same thing as Instrument *)
	specifiedCartridgeModel = Cases[Lookup[expandedSafeOps, ExtractionCartridge], ObjectReferenceP[Model], Infinity];
	specifiedCartridgeObject = Cases[Lookup[expandedSafeOps, ExtractionCartridge], ObjectReferenceP[Object], Infinity];

	(* all solution options also give us container and samples too *)
	allSolutionOptions = {PreFlushingSolution, ConditioningSolution, WashingSolution, SecondaryWashingSolution, TertiaryWashingSolution, ElutingSolution};
	solutionSamples = Cases[Lookup[expandedSafeOps, allSolutionOptions], ObjectReferenceP[Object[Sample]], Infinity];
	solutionSamplesModel = Cases[Lookup[expandedSafeOps, allSolutionOptions], ObjectReferenceP[Model[Sample]], Infinity];
	solutionContainers = Cases[Lookup[expandedSafeOps, allSolutionOptions], ObjectReferenceP[Object[Container]], Infinity];

	(* all sample related download *)
	(* to make the download easier, flatten all the samples *)
	flatSampleList = Flatten[mySamplesWithPreparedSamples];

	(* obtain all containers that resolver might use *)
	preferredContainersModels = DeleteDuplicates[
		Flatten[{
			PreferredContainer[All, Type -> All],
			hamiltonAliquotContainers["Memoization"]
		}]
	];
	defaultContainerFromTable = DeleteDuplicates[Flatten[Lookup[tableExtractionOptions, "DefaultContainer"]]];
	gilsonContainers = {
		Model[Container, Vessel, "Gilson Reagent Bottle"],
		Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
		Model[Container, Vessel, "10L Polypropylene Carboy"]
	};
	(* this is in case give us any SBS filter palte that's not 96 well*)
	defaultPlateContainer = {
		Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"],
		Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"],
		Model[Container, Plate, "96-well 2mL Deep Well Plate"],
		Model[Container, Vessel, "Biotage Pressure+48 Waste Tub"]
	};
	(* list all options that associate with container *)
	allContainerOptions = {SourceContainer, PreFlushingSolutionCollectionContainer, ConditioningSolutionCollectionContainer, WashingSolutionCollectionContainer, SecondaryWashingSolutionCollectionContainer, TertiaryWashingSolutionCollectionContainer, ElutingSolutionCollectionContainer};
	(* compile all container that user specified, in case its not listed in preferred container  *)
	specifiedContainerObjects = Cases[Lookup[expandedSafeOps, allContainerOptions], ObjectReferenceP[Object]];
	specifiedContainerModels = Cases[Lookup[expandedSafeOps, allContainerOptions], ObjectReferenceP[Model]];

	(* now we group things base on type *)
	(* since any input solution are input samples to so just combine them *)
	allSamplesObjectList = DeleteDuplicates[Flatten[{flatSampleList, solutionSamples}]];
	allSamplesModelList = DeleteDuplicates[Flatten[{solutionSamplesModel}]];
	allContainerObjectList = DeleteDuplicates[Flatten[{specifiedContainerObjects, solutionContainers}]];
	allContainerModelList = DeleteDuplicates[Flatten[{specifiedContainerModels, defaultPlateContainer, gilsonContainers, defaultContainerFromTable, preferredContainersModels}]];
	allCartridgeModel = DeleteDuplicates[Flatten[{allPreDefinedExtractionCartridgeModels, specifiedCartridgeModel}]];
	allInstrumentModel = DeleteDuplicates[Flatten[{allPreDefinedInstrumentModels, specifiedInstrumentModel}]];

	(*articulate all the fields needed*)
	modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]]];
	objectSampleFields = Union[SamplePreparationCacheFields[Object[Sample]]];
	modelContainerFields = Union[SamplePreparationCacheFields[Model[Container]], {AllowedPositions}];
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]], {Dimensions, CrossSectionalShape, Footprint, NumberOfWells, Rows, Columns}];
	cartridgeFields = {SeparationMode, FunctionalGroup, Type, MaxVolume, BedWeight, NumberOfWells, Rows, Columns, Footprint, Dimensions, CrossSectionalShape};
	instrumentFields = {MinFlowRate, MaxFlowRate, MinPressure, MaxPressure, MaxPressureWithFlowControl, MaxTemperature, MinTemperature, MaxRotationRate, MinRotationRate, MaxTime, SpeedResolution, CentrifugeType, AsepticHandling};

	packetSampleObject = Packet[Sequence @@ objectSampleFields,Living];
	packetSampleObjectModel = Packet[Model[modelSampleFields]];
	packetSampleContainerObject = Packet[Container[objectContainerFields]];
	packetSampleContainerModel = Packet[Container[Model][modelContainerFields]];
	packetSampleModel = Packet[Sequence @@ modelSampleFields];
	packetContainerObject = Packet[Sequence @@ objectContainerFields];
	packetContainerObjectModel = Packet[Model[modelContainerFields]];
	packetContainerModel = Packet[Sequence @@ modelContainerFields];
	packetCartridgeModel = Packet[Sequence @@ cartridgeFields];
	packetCartridgeObjectModel = Packet[Model[cartridgeFields]];
	packetInstrumentModel = Packet[Sequence @@ instrumentFields];
	packetInstrumentObjectModel = Packet[Model[instrumentFields]];


	(* -- giant download -- *)
	mainDownloadCache = Quiet[
		Download[
			{
				allSamplesObjectList,
				allSamplesObjectList,
				allSamplesObjectList,
				allSamplesObjectList,
				allSamplesModelList,
				allContainerObjectList,
				allContainerObjectList,
				allContainerModelList,
				allCartridgeModel,
				specifiedCartridgeObject,
				allInstrumentModel,
				specifiedInstrumentObject
			},
			{
				packetSampleObject,
				packetSampleObjectModel,
				packetSampleContainerObject,
				packetSampleContainerModel,
				packetSampleModel,
				packetContainerObject,
				packetContainerObjectModel,
				packetContainerModel,
				packetCartridgeModel,
				packetCartridgeObjectModel,
				packetInstrumentModel,
				packetInstrumentObjectModel
			},
			Cache -> cacheOption,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	(* convert all failed to Null to make life easy *)
	cacheBall = Sequence @@ ({FlattenCachePackets[{
		cacheOption,
		mainDownloadCache
	}]} /. $Failed -> Null);

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentSolidPhaseExtractionOptions[ToList[mySamplesWithPreparedSamples], expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveExperimentSolidPhaseExtractionOptions[ToList[mySamplesWithPreparedSamples], expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentSolidPhaseExtraction,
		resolvedOptions,
		Ignore -> ToList[myOptions],
		Messages -> False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	(*performSimulationQ = MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];*)
	performSimulationQ = MemberQ[output, Result | Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> If[MatchQ[resolvedPreparation, Robotic],
				resolvedOptions,
				RemoveHiddenOptions[ExperimentSolidPhaseExtraction, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	resourcePacketsResult = Check[
		{{resourcePackets,runTime}, postResourcePacketsSimulation, resourcePacketTests} = Which[

			returnEarlyQ,
				{{$Failed,Null}, updatedSimulation, {}},

			gatherTests,
				solidPhaseExtractionResourcePackets[
					mySamplesWithPreparedSamples,
					templatedOptions,
					resolvedOptions,
					Cache -> cacheBall,
					Simulation -> updatedSimulation,
					Output -> {Result, Simulation, Tests}
				],

			True,
				{
					Sequence @@ solidPhaseExtractionResourcePackets[
						mySamplesWithPreparedSamples,
						templatedOptions,
						resolvedOptions,
						Cache -> cacheBall,
						Simulation -> updatedSimulation,
						Output -> {Result, Simulation}
					],
					{}
				}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(*	If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation *)
	resultQ = MemberQ[output, Result];

	(*	If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[resourcePackets, $Failed], {$Failed, Simulation[]},

		performSimulationQ,
			simulateExperimentSolidPhaseExtraction[
				(* protocolPacket *)
				resourcePackets[[1]],
				(* unitOperationPackets *)
				Flatten[ToList[resourcePackets[[2]]]],
				(* sample *)
				ToList[mySamplesWithPreparedSamples],
				(* resolved options *)
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> postResourcePacketsSimulation
			],
		(* if we don't run simulation return Null *)
		True, {Null, postResourcePacketsSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentSolidPhaseExtraction, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation,
			RunTime -> runTime
		}]
	];

	postProcessingOptions = Map[
		If[
			MatchQ[Lookup[resolvedOptions, #], Except[Automatic]],
			# -> Lookup[resolvedOptions, #],
			Nothing
		]&,
		{ImageSample, MeasureVolume, MeasureWeight}
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourcePackets, $Failed] || MatchQ[resourcePacketsResult, $Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[resolvedOptions, Upload], False],
			resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive, nonHiddenOptions, samplesMaybeWithModels},

				(* convert the samples to models if we had model inputs originally *)
				(* if we don't have a simulation or a single prep unit op, then we know we didn't have a model input *)
				(* NOTE: this is important. Need to use updatedSimulation here and not simulation.  This is because mySamples needs to get converted to model via the simulation _before_ SimulateResources is called in simulateExperimentFilter *)
				(* otherwise, the same label will point at two different IDs, and that's going to cause problems *)
				samplesMaybeWithModels = If[NullQ[updatedSimulation] || Not[MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}]],
					myPooledSamples,
					simulatedSamplesToModels[
						Lookup[resolvedOptions, PreparatoryUnitOperations][[1, 1]],
						updatedSimulation,
						myPooledSamples
					]
				];

				(* Create our SPE primitive to feed into RoboticSamplePreparation. *)
				primitive = SolidPhaseExtraction @@ Join[
					{
						Sample -> samplesMaybeWithModels
					},
					RemoveHiddenPrimitiveOptions[SolidPhaseExtraction, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentSolidPhaseExtraction, resolvedOptions];

				(* Memoize the value of ExperimentSolidPhaseExtraction so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentSolidPhaseExtraction, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache = <||>;

					DownValues[ExperimentSolidPhaseExtraction] = {};

					ExperimentSolidPhaseExtraction[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> resourcePackets[[2]],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> runTime
						}
					];
					Module[{experimentFunction, resolvedWorkCell},
						(* look up which workcell we've chosen *)
						resolvedWorkCell = Lookup[resolvedOptions, WorkCell];

						(* pick the corresponding function from the association above *)
						experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];

						experimentFunction[
							{primitive},
							Join[
								{
									Name -> Lookup[nonHiddenOptions, Name],
									Upload -> Lookup[safeOps, Upload],
									Confirm -> Lookup[safeOps, Confirm],
									CanaryBranch -> Lookup[safeOps, CanaryBranch],
									ParentProtocol -> Lookup[safeOps, ParentProtocol],
									Priority -> Lookup[safeOps, Priority],
									StartDate -> Lookup[safeOps, StartDate],
									HoldOrder -> Lookup[safeOps, HoldOrder],
									QueuePosition -> Lookup[safeOps, QueuePosition],
									Cache -> cacheBall,
									Simulation -> simulation
								},
								postProcessingOptions
							]
						]
					]
				]
			],

		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation or standalone manually. *)
		True,
			UploadProtocol[
				(* protocol packet *)
				resourcePackets[[1]],
				(* unit operation packets *)
				resourcePackets[[2]],
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> {Object[Protocol, SolidPhaseExtraction]},
				Cache -> cacheBall,
				Simulation -> simulation
			]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> If[MatchQ[resolvedPreparation, Robotic],
			collapsedResolvedOptions,
			RemoveHiddenOptions[ExperimentSolidPhaseExtraction, collapsedResolvedOptions]
		],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> runTime
	}

];
(* ::Subsection::Closed:: *)
(*resolveExperimentSolidPhaseExtractionOptions*)

DefineOptions[
	resolveExperimentSolidPhaseExtractionOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentSolidPhaseExtractionOptions[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentSolidPhaseExtractionOptions]] := Module[
	{
		outputSpecification, output, upload, flatSampleList, gatherTests, messages, cache, samplePrepOptions, mySPEOptions, simulatedSamples, flatSimulatedSamples, resolvedSamplePrepOptions, simulatedCache, samplePrepTests, simulation, invalidOptions, invalidInputs,
		suppliedAliquotAmount, suppliedAssayVolume, samplePackets, sampleContainers, sampleContainerModels, sampleAnalytePackets, sampleCompositionPackets, discardedSamplePackets, discardedInvalidInputs, discardedTest, missingVolumeSamplePackets, missingVolumeInvalidInputs, missingVolumeTest, actualSampleVolumes, nonLiquidSamplePackets, nonLiquidSampleInvalidInputs, nonLiquidSampleTest,
		optionsWithBatch, groupedByInstrument, optionsWithBatchList, originalOrderOfOptions, reorderOptionsWithBatch, speResolvedOptionsRulesWithBatch, speResolvedOptionsRules,
		groupedByBatchID, aliquotAndContainerOptions, aliquotAndContainerOptionsList, orderingSamplesIndex, fullyResolvedOptionsRulesWithBatch,
		fullyResolvedOptionsRulesWithBatchNoSamples, noDupPreparation, bothManualAndRoboticError, resolvedPostProcessingOptions,unitScaleDisregardNull, resolvedOptions,
		expandedSamplesInStorage, badVolumeQs, resolvedPreparation, mobilePhaseSamplePackets, speOptionsResolveReplaced, allowedWorkCells, resolvedWorkCell,
		mobilePhaseOptionValues, mobilePhasePackets, mobilePhaseContainer, mobilePhaseSamples, mobilePhasePacketsFromContainer, mobilePhasePacketsFromSamples, discardedMobilePhasePackets,
		discardedInvalidMobilePhase, discardedInvalidMobilePhaseGivenObject, missingVolumeMobilePhasePackets, missingVolumeInvalidMobilePhase, invalidMobilePhaseVolumeGivenObject, nonLiquidMobilePhasePackets,
		nonLiquidSampleInvalidMobilePhase, nonLiquidMobilePhaseVolumeGivenObject, resolvedOptionsWithoutRounding,
		suppliedCartridge, suppliedCartridgeObjects, duplicateCartridgeObjects, invalidDuplicateCartridgeObjectOptions,
		discardedMobilePhaseTest, conflictingMobilePhaseTest, missingVolumeMobilePhaseTest, nonLiquidMobilePhaseTest,
		tableExtractionOptions, tablePreferredExtractionSorbent, tableIonExchangeDefinition, tableDefaultSolutionDefinition,
		timeOptionsPrecisions, roundedSPEOptions, precisionTests,
		mapThreadFriendlyOptions,
		incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName, badInstrument, badExtractionMethod, badExtractionCartridge,
		centrifugeIndex, centrifugeIndexFlat, ctInstrument,
		ctPreFlushingSolutionCentrifugeIntensity, ctConditioningSolutionCentrifugeIntensity, ctWashingSolutionCentrifugeIntensity, ctSecondaryWashingSolutionCentrifugeIntensity, ctTertiaryWashingSolutionCentrifugeIntensity,
		ctElutingSolutionCentrifugeIntensity, ctLoadingSampleCentrifugeIntensity, ctPreFlushingSwitch, ctConditioningSwitch, ctWashingSwitch,
		ctSecondaryWashingSwitch, ctTertiaryWashingSwitch, ctElutingSwitch, ctLoadingSampleSwitch, stackedFakeIntensity,
		stackedSwitch, stackedPosition, stackedInstrument, stackAllToCentrifuge, partResolvedIntensity, partPosition,
		forOptionReplacement, centrifugeOptionIntensity, badValue, impliedCollectByContainer,
		sampleLiquidHandlerIncompatibleValues, samplesLiquidHandlerIncompatible, allResolvedSolutions,
		allResolvedSolutionLiquidHandlerIncompatibleValues, solutionsLiquidHandlerIncompatible, samplesLiquidHandlerIncompatibleInputs,
		samplesLiquidHandlerIncompatibleTests, solutionsLiquidHandlerIncompatibleOptions, solutionsLiquidHandlerIncompatibleTests,
		resolvedPreFlushingSolutionCentrifugeIntensity, resolvedConditioningSolutionCentrifugeIntensity, resolvedWashingSolutionCentrifugeIntensity, resolvedSecondaryWashingSolutionCentrifugeIntensity,
		resolvedTertiaryWashingSolutionCentrifugeIntensity, resolvedElutingSolutionCentrifugeIntensity, resolvedLoadingSampleCentrifugeIntensity, resolvedAliquotTargets,
		resolvedPreFlushingContainerLabel, resolvedConditioningContainerLabel, resolvedWashingContainerLabel, resolvedSecondaryContainerLabel, resolvedTertiaryContainerLabel,
		resolvedElutingContainerLabel, resolvedLoadingSampleFlowthroughContainerLabel, resolvedContainerOutWellAssignment,
		(* MAPTHREAD *)
		mtInstrument, mtExtractionMethod, mtExtractionCartridgeType, mtExtractionCartridge, mtExtractionSorbent, mtExtractionMode,
		mtPreFlushingSwitch, mtConditioningSwitch, mtWashingSwitch, mtSecondaryWashingSwitch, mtTertiaryWashingSwitch, mtElutingSwitch,
		mtExtractionStrategy, mtPreFlushingSolution, mtConditioningSolution, mtWashingSolution, mtSecondaryWashingSolution, mtTertiaryWashingSolution, mtElutingSolution,
		mtPreFlushingSolutionVolume, mtConditioningSolutionVolume, mtWashingSolutionVolume, mtSecondaryWashingSolutionVolume, mtTertiaryWashingSolutionVolume, mtElutingSolutionVolume, mtPreFlushingSolutionTemperature,
		mtConditioningSolutionTemperature, mtWashingSolutionTemperature, mtSecondaryWashingSolutionTemperature, mtTertiaryWashingSolutionTemperature, mtElutingSolutionTemperature,
		mtPreFlushingSolutionTemperatureEquilibrationTime,
		mtConditioningSolutionTemperatureEquilibrationTime,
		mtWashingSolutionTemperatureEquilibrationTime,
		mtSecondaryWashingSolutionTemperatureEquilibrationTime,
		mtTertiaryWashingSolutionTemperatureEquilibrationTime,
		mtElutingSolutionTemperatureEquilibrationTime,
		mtPreFlushingSolutionDispenseRate,
		mtConditioningSolutionDispenseRate,
		mtWashingSolutionDispenseRate,
		mtSecondaryWashingSolutionDispenseRate,
		mtTertiaryWashingSolutionDispenseRate,
		mtElutingSolutionDispenseRate,
		mtPreFlushingSolutionPressure,
		mtConditioningSolutionPressure,
		mtWashingSolutionPressure,
		mtSecondaryWashingSolutionPressure,
		mtTertiaryWashingSolutionPressure,
		mtElutingSolutionPressure,
		mtCollectPreFlushingSolution,
		mtCollectConditioningSolution,
		mtCollectWashingSolution,
		mtCollectSecondaryWashingSolution,
		mtCollectTertiaryWashingSolution,
		mtCollectElutingSolution,
		mtCollectLoadingSampleFlowthrough,
		mtPreFlushingSolutionUntilDrained,
		mtConditioningSolutionUntilDrained,
		mtWashingSolutionUntilDrained,
		mtSecondaryWashingSolutionUntilDrained,
		mtTertiaryWashingSolutionUntilDrained,
		mtElutingSolutionUntilDrained,
		mtPreFlushingSolutionDrainTime,
		mtConditioningSolutionDrainTime,
		mtWashingSolutionDrainTime,
		mtSecondaryWashingSolutionDrainTime,
		mtTertiaryWashingSolutionDrainTime,
		mtElutingSolutionDrainTime,
		mtMaxPreFlushingSolutionDrainTime,
		mtMaxConditioningSolutionDrainTime,
		mtMaxWashingSolutionDrainTime,
		mtMaxSecondaryWashingSolutionDrainTime,
		mtMaxTertiaryWashingSolutionDrainTime,
		mtMaxElutingSolutionDrainTime,
		mtExtractionTemperature,
		mtQuantitativeLoadingSample,
		mtQuantitativeLoadingSampleSolution,
		mtQuantitativeLoadingSampleVolume,
		mtLoadingSampleVolume,
		mtLoadingSampleTemperatureEquilibrationTime,
		mtLoadingSampleTemperature,
		mtLoadingSamplePressure,
		mtLoadingSampleDispenseRate,
		mtLoadingSampleDrainTime,
		mtMaxLoadingSampleDrainTime,
		mtPreFlushingSolutionCollectionContainer,
		mtConditioningSolutionCollectionContainer,
		mtWashingSolutionCollectionContainer,
		mtSecondaryWashingSolutionCollectionContainer,
		mtTertiaryWashingSolutionCollectionContainer,
		mtElutingSolutionCollectionContainer,
		mtLoadingSampleFlowthroughContainer,
		mtPreFlushingSolutionCentrifugeIntensity,
		mtConditioningSolutionCentrifugeIntensity,
		mtWashingSolutionCentrifugeIntensity,
		mtSecondaryWashingSolutionCentrifugeIntensity,
		mtTertiaryWashingSolutionCentrifugeIntensity,
		mtElutingSolutionCentrifugeIntensity,
		mtLoadingSampleCentrifugeIntensity,
		mtPreparation,
		mtSampleLabel,
		mtSourceContainerLabel,
		mtCartridgeLabel,
		mtPreFlushingSampleOutLabel,
		mtConditioningSampleOutLabel,
		mtLoadingSampleFlowthroughSampleOutLabel,
		mtWashingSampleOutLabel,
		mtSecondaryWashingSampleOutLabel,
		mtTertiaryWashingSampleOutLabel,
		mtElutingSampleOutLabel,
		mtPreFlushingSolutionLabel,
		mtConditioningSolutionLabel,
		mtWashingSolutionLabel,
		mtSecondaryWashingSolutionLabel,
		mtTertiaryWashingSolutionLabel,
		mtElutingSolutionLabel,
		mtSamplesInStorageCondition,
		mtSamplesOutStorageCondition,
		mtLoadingSampleUntilDrained,
		(* error and warning *)
		mtunequalLoadingSampleVolumeLengthError,
		mtincompatibleInstrumentSampleVolumeError,
		mtincompatibleCartridgeInstrumentError,
		mtincompatibleExtractionMethodSampleVolumeError,
		mtincompatibleExtractionCartridgeError,
		mtincompatibleInstrumentAndMethodError,
		mtincompatibleInstrumentAndExtractionCartridgeError,
		mtincompatibleExtractionMethodAndExtractionCartridgeError,
		mtincompatibleInstrumentExtractionMethodExtractionCartridgeError,
		mtwarningExtractionStrategyWashingSwitchIncompatible,
		mtskippedWashingError,
		mtwarningExtractionStrategySecondaryWashingSwitchIncompatible,
		mtskippedSecondaryWashingError,
		mtwarningExtractionStrategyTertiaryWashingSwitchIncompatible,
		mtwarningPositiveStrategyWithoutEluting,
		mtwarningExtractionStrategyElutingIncompatible,
		mterrorPreFlushingPressureTooLow,
		mterrorPreFlushingPressureTooHigh,
		mterrorPreFlushingDispenseRateTooLow,
		mterrorPreFlushingDispenseRateTooHigh,
		mterrorConditioningPressureTooLow,
		mterrorConditioningPressureTooHigh,
		mterrorConditioningDispenseRateTooLow,
		mterrorConditioningDispenseRateTooHigh,
		mterrorWashingPressureTooLow,
		mterrorWashingPressureTooHigh,
		mterrorWashingDispenseRateTooLow,
		mterrorWashingDispenseRateTooHigh,
		mterrorElutingPressureTooLow,
		mterrorElutingPressureTooHigh,
		mterrorElutingDispenseRateTooLow,
		mterrorElutingDispenseRateTooHigh,
		mterrorSecondaryWashingPressureTooLow,
		mterrorSecondaryWashingPressureTooHigh,
		mterrorSecondaryWashingDispenseRateTooLow,
		mterrorSecondaryWashingDispenseRateTooHigh,
		mterrorTertiaryWashingPressureTooLow,
		mterrorTertiaryWashingPressureTooHigh,
		mterrorTertiaryWashingDispenseRateTooLow,
		mterrorTertiaryWashingDispenseRateTooHigh,
		mterrorAmbientOnlyInstrument,
		mterrorExtractionTemperatureTooLow,
		mterrorExtractionTemperatureTooHigh,
		mtunequalLengthQuantitativeLoadingSampleError,
		mtunequalLengthQuantitativeLoadingSampleSolutionError,
		mtunequalLengthQuantitativeLoadingSampleVolumeError,
		mtunequalLengthLoadingSampleTemperatureError,
		mtunequalLengthLoadingSampleTemperatureEquilibrationTimeError,
		mterrorLoadingSamplePressureTooLow,
		mterrorLoadingSamplePressureTooHigh,
		mterrorLoadingSampleDispenseRateTooLow,
		mterrorLoadingSampleDispenseRateTooHigh,
		mtwarningIncompatiblePreFlushingSolutionCollectionContainer,
		mtwarningIncompatibleConditioningSolutionCollectionContainer,
		mtwarningIncompatibleWashingSolutionCollectionContainer,
		mtwarningIncompatibleSecondaryWashingSolutionCollectionContainer,
		mtwarningIncompatibleTertiaryWashingSolutionCollectionContainer,
		mtwarningIncompatibleElutingSolutionCollectionContainer,
		mtwarningIncompatibleLoadingSampleFlowthroughContainer,
		mtincompatibleExtractionCartridgeSampleVolumeError,
		mtwarningVolumeTooHigh,
		mtconflictingCartridgeSorbentWarning,
		mtwarningExtractionStrategyChange,
		mtwarningPreFlushingPressureMustBeBoolean,
		mtwarningConditioningPressureMustBeBoolean,
		mtwarningWashingPressureMustBeBoolean,
		mtwarningElutingPressureMustBeBoolean,
		mtwarningSecondaryWashingPressureMustBeBoolean,
		mtwarningTertiaryWashingPressureMustBeBoolean,
		mtwarningLoadingSamplePressureMustBeBoolean,
		preFlushingSolutionCentrifugeIntensityError,
		conditioningSolutionCentrifugeIntensityError,
		washingSolutionCentrifugeIntensityError,
		secondaryWashingSolutionCentrifugeIntensityError,
		tertiaryWashingSolutionCentrifugeIntensityError,
		elutingSolutionCentrifugeIntensityError,
		loadingSampleCentrifugeIntensityError,
		(* error single *)
		(* intermediate variable *)
		mtnumberOfPreFlushingSolutionCollectionContainer,
		mtnumberOfConditioningSolutionCollectionContainer,
		mtnumberOfWashingSolutionCollectionContainer,
		mtnumberOfSecondaryWashingSolutionCollectionContainer,
		mtnumberOfTertiaryWashingSolutionCollectionContainer,
		mtnumberOfElutingSolutionCollectionContainer,
		mtnumberOfLoadingSampleFlowthroughContainer,
		mtinstrumentModel,
		mtpooledSampleVolumes,
		mtpoolsize,
		mtsampleVolumes,
		mtconflictingMobilePhaseOptionName,
		mtnumberOfCollection,
		mtimpliedCollectionNameError,
		mtvolumeTooLargeWarning,
		mtconflictingMethodInferringMobilePhaseOptionsError,
		mtconflictingSuppliedMethodAndImpliedMethodError,
		mtspeCannotSupportVolumeError,
		mtspeCannotSupportCollectionError,
		mtspeCannotSupportCartridgeError,
		mtspeCannotSupportMethodError,
		stackedInstrumentModel,
		totalNumberOfSamples,
		unresolvedEmail, unresolvedWorkCell,
		unresolvedName,
		samplesInStorage,
		samplesOutStorage,
		resolvedEmail,
		nameValidBool,
		nameOptionInvalid,
		nameUniquenessTest,
		pooledError,
		pooledErrorOptionName,
		pooledLengthErrorOptionName,
		possibleOptionName,
		badWashing, badWashingSolution,
		useBadWashing, useBadWashingSolution,
		badSecondaryWashing, badSecondaryWashingSolution,
		useBadSecondaryWashing, useBadSecondaryWashingSolution,
		(* tests *)
		unequalLengthPooledSamplesInOptionsTest,
		incompatibleInstrumentAndMethodErrorOptionNameTest,
		incompatibleInstrumentAndExtractionCartridgeErrorOptionNameTest,
		incompatibleExtractionMethodAndExtractionCartridgeErrorOptionNameTest,
		warningExtractionStrategyWashingSwitchIncompatibleTest,
		warningExtractionStrategySecondaryWashingSwitchIncompatibleTest,
		skippedWashingErrorOptionNameTest,
		skippedSecondaryWashingErrorOptionNameTest,
		warningExtractionStrategyTertiaryWashingSwitchIncompatibleTest,
		warningExtractionStrategyElutingIncompatibleTest,
		pressureOutOfBoundTest,
		dispenseRateOutOfBoundTest,
		ambientOnlyInstrumentErrorOptionNameTest,
		extractionTemperatureOutOfBoundOptionNameTest,
		roboticOnlyOptions, roboticOnlyTests,
		incompatibleInstrumentAndMethodErrorOptionName,
		incompatibleInstrumentAndExtractionCartridgeErrorOptionName,
		incompatibleInstrumentExtractionMethodExtractionCartridgeErrorOptionName,
		skippedWashingErrorOptionName,
		skippedSecondaryWashingErrorOptionName,
		errorPreFlushingPressureOptionName,
		errorConditioningPressureOptionName,
		errorWashingPressureOptionName,
		errorSecondaryWashingPressureOptionName,
		errorTertiaryWashingPressureOptionName,
		errorElutingPressureOptionName,
		errorLoadingSamplePressureOptionName,
		allPressureOption,
		allPressureErrorOptionName,
		allPressureErrorSwitch,
		allPressureErrorQ,
		badPressure,
		badInstrumentModel,
		lowLimitPressureInstrument,
		highLimitPressureInstrument,
		limitPressureInstrument,
		badSuppliedPressure,
		errorPreFlushingDispenseRateOptionName,
		errorConditioningDispenseRateOptionName,
		errorWashingDispenseRateOptionName,
		errorSecondaryWashingDispenseRateOptionName,
		errorTertiaryWashingDispenseRateOptionName,
		errorElutingDispenseRateOptionName,
		errorLoadingSampleDispenseRateOptionName,
		allDispenseRateOption,
		allDispenseRateErrorOptionName,
		allDispenseRateErrorSwitch,
		allDispenseRateErrorQ,
		badDispenseRate,
		lowLimitDispenseRateInstrument,
		highLimitDispenseRateInstrument,
		limitDispenseRateInstrument,
		badSuppliedDispenseRate,
		ambientOnlyInstrumentErrorOptionName,
		badExtractionTemperature,
		extractionTemperatureOutOfBoundOptionName,
		allContainerErrorOptionName,
		temperatureLimits,
		badExtractionTemperatureIndex,
		allContainerErrorTracker,
		allContainerOption,
		suggestedContainer,
		badContainer,
		uniqueError,
		errorPreFlushingPressureMustBeBooleanOptionName,
		errorConditioningPressureMustBeBooleanOptionName,
		errorWashingPressureMustBeBooleanOptionName,
		errorSecondaryWashingPressureMustBeBooleanOptionName,
		errorTertiaryWashingPressureMustBeBooleanOptionName,
		errorElutingPressureMustBeBooleanOptionName,
		errorLoadingSamplePressureMustBeBooleanOptionName,
		allPressureMustBeBooleanOption,
		allPressureMustBeBooleanOptionName,
		allPressureMustBeBooleanSwitch,
		allPressureMustBeBooleanQ,
		pressureMustBeBooleanTest,
		tooLargeLoadingSampleVolumeTest,
		conflictingMethodInferringMobilePhaseOptionsTest,
		conflictingSuppliedMethodAndImpliedMethodErrorTest,
		mtspeCannotSupportVolumeErrorTest,
		mtspeCannotSupportCollectionTest,
		mtconflictingSuppliedMethodAndImpliedMethodErrorOptionName,
		mtspeCannotSupportVolumeErrorOptionName,
		mtspeCannotSupportCollectionOptionName,
		mtspeCannotSupportCartridgeOptionName,
		mtspeCannotSupportCartridgeTest,
		mtspeCannotSupportMethodOptionName,
		mtspeCannotSupportMethodTest,
		mtnoCompatibleInstrumentError,
		mtnoCompatibleInstrumentErrorTest,
		mtwarningVolumeTooHighOptionName,
		mtwarningVolumeTooHighErrorTest,
		badCentrifugeIntensityOptionName,
		centrifugeIntensityTest,
		mtvolumeTooLargeWarningOptionsName,
		mtconflictingSuppliedMethodAndImpliedMethodErrorTest,
		mtbadLoadingSampleVolume,
		mtnoCompatibleInstrumentErrorName,
		mttooBigCartridgeError,
		mttooBigCartridgeErrorOptionName,
		mttooBigCartridgeErrorTest,
		mttooManyCollectionPlateOnGX271DeckError,
		mttooManyCollectionPlateOnGX271DeckOptionName,
		mttooManyTypeOfSolutionOnGX271OptionName,
		mttooManyCollectionPlateOnGX271DeckErrorTest,
		mttooManyTypeOfSolutionOnGX271Error,
		mttooManyTypeOfSolutionOnGX271ErrorTest,
		mtcannotSupportQuantitativeLoadingError,
		mtcannotSupportQuantitativeLoadingErrorOptionName,
		mtquantitativeLoadingSampleSolutionError,
		mtcannotSupportQuantitativeLoadingErrorTest,
		quantitativeLoadingSampleSolutionErrorTest,
		mtnotSPECartridgeError,
		mtspeCannotSupportPreFlushVolume,
		mtspeCannotSupportConditionVolume,
		mtspeCannotSupportWashVolume,
		mtspeCannotSupportSecondaryWashVolume,
		mtspeCannotSupportTertiaryWashVolume,
		mtspeCannotSupportEluteVolume,
		mtspeCannotSupportQuantVolume,
		mtspeCannotSupportInstrumentError,
		mtbadVolumePreFlushName,
		mtbadVolumeConditionName,
		mtbadVolumeWashName,
		mtbadVolumeSecWashName,
		mtbadVolumeTerWashName,
		mtbadVolumeEluteName,
		mtbadVolumeQuantLoadName,
		mtbadInstrumentName,
		mterrorPreFlushingVolumeInstrument,
		mterrorConditioningVolumeInstrument,
		mterrorWashingVolumeInstrument,
		mterrorElutingVolumeInstrument,
		mterrorSecondaryWashingVolumeInstrument,
		mterrorTertiaryWashingVolumeInstrument,
		mterrorLoadingSampleVolumeInstrument,
		notSPECartridgeOptionName,
		notSPECartridgeTest,
		solutionVolumeTooLargeTest,
		solutionVolumeTooLargeForInstrumentTest,
		partResolvedIntensityWithError,
		partResolvedIntensityError,
		nullPlaceHolderForReplacement,
		centrifugeOptionIntensityError,
		preresolvedPreFlushingSolutionCentrifugeIntensity,
		preresolvedConditioningSolutionCentrifugeIntensity,
		preresolvedWashingSolutionCentrifugeIntensity,
		preresolvedSecondaryWashingSolutionCentrifugeIntensity,
		preresolvedTertiaryWashingSolutionCentrifugeIntensity,
		preresolvedElutingSolutionCentrifugeIntensity,
		preresolvedLoadingSampleCentrifugeIntensity,
		prepreFlushingSolutionCentrifugeIntensityError,
		preconditioningSolutionCentrifugeIntensityError,
		prewashingSolutionCentrifugeIntensityError,
		presecondaryWashingSolutionCentrifugeIntensityError,
		pretertiaryWashingSolutionCentrifugeIntensityError,
		preelutingSolutionCentrifugeIntensityError,
		preloadingSampleCentrifugeIntensityError,
		ctresolvedPreFlushingSolutionCentrifugeIntensity,
		ctresolvedConditioningSolutionCentrifugeIntensity,
		ctresolvedWashingSolutionCentrifugeIntensity,
		ctresolvedSecondaryWashingSolutionCentrifugeIntensity,
		ctresolvedTertiaryWashingSolutionCentrifugeIntensity,
		ctresolvedElutingSolutionCentrifugeIntensity,
		ctresolvedLoadingSampleCentrifugeIntensity,
		ctpreFlushingSolutionCentrifugeIntensityError,
		ctconditioningSolutionCentrifugeIntensityError,
		ctwashingSolutionCentrifugeIntensityError,
		ctsecondaryWashingSolutionCentrifugeIntensityError,
		cttertiaryWashingSolutionCentrifugeIntensityError,
		ctelutingSolutionCentrifugeIntensityError,
		ctloadingSampleCentrifugeIntensityError,
		notSPEInstrumentTest,
		mterrorPreFlushingInstrumentSolutionTemperature,
		mterrorConditioningInstrumentSolutionTemperature,
		mterrorWashingInstrumentSolutionTemperature,
		mterrorElutingInstrumentSolutionTemperature,
		mterrorSecondaryWashingInstrumentSolutionTemperature,
		mterrorTertiaryWashingInstrumentSolutionTemperature,
		mterrorLoadingSampleInstrumentSolutionTemperature,
		cannotSupportSolutionTemperatureOptionName,
		cannotSupportSolutionTemperatureTest,
		mtcannotFindCartridgeWithSuppliedError,
		mtcannotFindCartridgeWithSuppliedErrorOptionName,
		mtcannotFindCartridgeWithSuppliedErrorTest,
		mtresolvedExtractionCartridgeStorageCondition,
		incompatibleExtractionMethodAndExtractionCartridgeErrorNameTest
	},

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];
	flatSampleList = Flatten[myPooledSamples];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our experimental options from our Sample Prep options *)
	{samplePrepOptions, mySPEOptions} = splitPrepOptions[
		myOptions,
		PrepOptionSets -> {CentrifugePrepOptionsNew, IncubatePrepOptionsNew, FilterPrepOptionsNew}
	];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTests,
		resolvePooledSamplePrepOptions[ExperimentSolidPhaseExtraction, myPooledSamples, samplePrepOptions, Cache -> cache, Output -> {Result, Tests}],
		{resolvePooledSamplePrepOptions[ExperimentSolidPhaseExtraction, myPooledSamples, samplePrepOptions, Cache -> cache, Output -> Result], {}}
	];

	(* samplesIn *)
	simulatedCache = DeleteDuplicates[simulatedCache];
	flatSimulatedSamples = Flatten[simulatedSamples];
	(* other Solutions *)
	(* if user supply any of these buffer, check whether they are liquid or not *)
	mobilePhaseOptionValues = Flatten[Lookup[mySPEOptions, {PreFlushingSolution, ConditioningSolution, WashingSolution, SecondaryWashingSolution, TertiaryWashingSolution, ElutingSolution}]];
	mobilePhaseContainer = Cases[mobilePhaseOptionValues, ObjectReferenceP[Object[Container]]];
	mobilePhaseSamples = Cases[mobilePhaseOptionValues, ObjectReferenceP[{Object[Sample], Model[Sample]}]];
	(*-- INPUT VALIDATION CHECKS --*)

	(* will need these since they could influence the total volume of the sample we're actually SPEing*)
	{suppliedAliquotAmount, suppliedAssayVolume} = Lookup[samplePrepOptions, {AliquotAmount, AssayVolume}];

	(* Extract the packets that we need from our downloaded cache. *)
	{{
		samplePackets,
		sampleContainers,
		sampleContainerModels,
		sampleAnalytePackets,
		sampleCompositionPackets,
		mobilePhasePacketsFromSamples,
		mobilePhasePacketsFromContainer
	}} = Flatten[Quiet[Download[
		{
			flatSimulatedSamples,
			flatSimulatedSamples,
			flatSimulatedSamples,
			flatSimulatedSamples,
			flatSimulatedSamples,
			mobilePhaseSamples,
			mobilePhaseContainer
		},
		{
			{Packet[Volume, Status, Container, State]},
			{Packet[Container[{Object, Model}]]},
			{Packet[Container[Model[{MaxVolume}]]]},
			{Packet[Analytes[{Object, PolymerType, MolecularWeight}]]},
			{Packet[Composition[[All, 2]][{Object, Name, PolymerType, MolecularWeight}]]},
			{Packet[Volume, Status, Container, State]},
			{Packet[Contents[[All, 2]][{Volume, Status, Container, State}]]}
		},
		Cache -> simulatedCache,
		Date -> Now
	], {Download::FieldDoesntExist}], {3}
	];
	(* put them together because mobile phase can be samples or container *)
	mobilePhasePackets = DeleteDuplicates[Flatten[{mobilePhasePacketsFromContainer, mobilePhasePacketsFromSamples}]];
	mobilePhaseSamplePackets = Cases[mobilePhasePackets, ObjectP[Object[Sample]]];

	(* SamplesIn Tests *)
	(* 1. MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)
	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];
	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}], {}, Lookup[discardedSamplePackets, Object]];
	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages, Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> simulatedCache]]];
	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> simulatedCache] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[flatSampleList],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[flatSampleList, discardedInvalidInputs], Cache -> simulatedCache] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		], Nothing
	];
	(* 2. MAKE SURE THE SAMPLES HAVE A VOLUME IF THEY'RE a LIQUID - *)
	(* Get the samples that do not have a volume but are a liquid *)
	missingVolumeSamplePackets = Cases[samplePackets, KeyValuePattern[{Volume -> Null}]];
	(* Keep track of samples that do not have volume but are a liquid *)
	missingVolumeInvalidInputs = If[MatchQ[missingVolumeSamplePackets, {}], {}, Lookup[missingVolumeSamplePackets, Object]];
	(* If there are invalid inputs and we are throwing messages,do so *)
	If[
		And[Length[missingVolumeInvalidInputs] > 0, messages, Not[MatchQ[$ECLApplication, Engine]]],
		Message[Error::MissingVolumeInformation, ObjectToString[missingVolumeInvalidInputs, Cache -> simulatedCache]];
	];
	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	missingVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[missingVolumeInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[missingVolumeInvalidInputs, Cache -> simulatedCache] <> " are not missing volume information:", True, False]
			];

			passingTest = If[Length[missingVolumeInvalidInputs] == Length[flatSampleList],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[flatSampleList, missingVolumeInvalidInputs], Cache -> simulatedCache] <> " are not missing volume information:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];
	(* make sure we have a volume to work with (either volume of the sample or if that is not possible than the max volume
	 of container the sample is in, this is here just for the map thread portion of the resolver as currently we cannot proceed without a volume*)
	actualSampleVolumes = MapThread[
		If[NullQ[#1], #2, #1]&,
		{
			Lookup[samplePackets, Volume],
			Lookup[sampleContainerModels, MaxVolume]
		}
	];
	(* 3. MAKE SURE THE SAMPLES ARE LIQUID - *)
	(* Get the samples that are not liquids, cannot spe those *)
	nonLiquidSamplePackets = Map[
		If[
			Not[MatchQ[Lookup[#, State], Alternatives[Liquid, Null]]],
			#,
			Nothing
		]&,
		samplePackets
	];
	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs = If[MatchQ[nonLiquidSamplePackets, {}], {}, Lookup[nonLiquidSamplePackets, Object]];
	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs] > 0 && messages,
		Message[Error::NonLiquidSample, ObjectToString[nonLiquidSampleInvalidInputs, Cache -> simulatedCache]];
	];
	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidSampleInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[nonLiquidSampleInvalidInputs, Cache -> simulatedCache] <> " have a Liquid State:", True, False]
			];

			passingTest = If[Length[nonLiquidSampleInvalidInputs] == Length[flatSampleList],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[flatSampleList, nonLiquidSampleInvalidInputs], Cache -> simulatedCache] <> " have a Liquid State:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* All other liquid Tests *)
	(* 1. MAKE SURE NONE OF THE MOBILEPHASE LIQUID ARE DISCARDED - *)
	(* Get the samples from samplePackets that are discarded. *)
	discardedMobilePhasePackets = Cases[mobilePhaseSamplePackets, KeyValuePattern[Status -> Discarded]];
	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidMobilePhase = If[MatchQ[discardedMobilePhasePackets, {}], {}, Lookup[discardedMobilePhasePackets, Object]];
	(* because all these mobile phase can be either container, or samples we have to turn it to original input that user gave us *)
	discardedInvalidMobilePhaseGivenObject = DeleteDuplicates[Flatten[
		Map[
			If[MemberQ[#1, Lookup[mobilePhaseSamplePackets, Object]],
				(* if it is a sample object, just return it *)
				#1,
				(* if not, look for it's container *)
				Lookup[Cases[mobilePhasePacketsFromContainer, KeyValuePattern[Object -> #1]], Container]
			]&,
			discardedInvalidMobilePhase
		]
	]];
	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidMobilePhase] > 0 && messages, Message[Error::DiscardedSPESolutions, ObjectToString[discardedInvalidMobilePhaseGivenObject, Cache -> simulatedCache]]];
	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedMobilePhaseTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidMobilePhaseGivenObject] == 0,
				Nothing,
				Test["Our input solutions " <> ObjectToString[discardedInvalidMobilePhaseGivenObject, Cache -> simulatedCache] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidMobilePhaseGivenObject] == Length[mobilePhaseSamplePackets],
				Nothing,
				Test["Our input solutions " <> ObjectToString[Complement[Lookup[mobilePhaseSamplePackets, Object], discardedInvalidMobilePhaseGivenObject], Cache -> simulatedCache] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		], Nothing
	];
	(* 2. MAKE SURE THE SAMPLES HAVE A VOLUME IF THEY'RE a LIQUID - *)
	(* Get the samples that do not have a volume but are a liquid *)
	missingVolumeMobilePhasePackets = Cases[mobilePhaseSamplePackets, KeyValuePattern[{Volume -> Null}]];
	(* Keep track of samples that do not have volume but are a liquid *)
	missingVolumeInvalidMobilePhase = If[MatchQ[missingVolumeMobilePhasePackets , {}], {}, Lookup[missingVolumeMobilePhasePackets, Object]];
	invalidMobilePhaseVolumeGivenObject = DeleteDuplicates[Flatten[
		Map[
			If[MemberQ[#1, mobilePhaseSamples],
				(* if it is a sample object, just return it *)
				#1,
				(* if not, look for it's container *)
				Lookup[Cases[mobilePhasePacketsFromContainer, KeyValuePattern[Object -> #1]], Container]
			]&,
			missingVolumeInvalidMobilePhase
		]
	]];
	(* If there are invalid inputs and we are throwing messages,do so *)
	If[
		And[Length[invalidMobilePhaseVolumeGivenObject] > 0, messages, Not[MatchQ[$ECLApplication, Engine]]],
		Message[Error::MissingVolumeInformation, ObjectToString[invalidMobilePhaseVolumeGivenObject, Cache -> simulatedCache]];
	];
	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	missingVolumeMobilePhaseTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidMobilePhaseVolumeGivenObject] == 0,
				Nothing,
				Test["Our input solutions " <> ObjectToString[invalidMobilePhaseVolumeGivenObject, Cache -> simulatedCache] <> " are not missing volume information:", True, False]
			];

			passingTest = If[Length[invalidMobilePhaseVolumeGivenObject] == Length[mobilePhaseSamplePackets],
				Nothing,
				Test["Our input solutions " <> ObjectToString[Complement[Lookup[mobilePhaseSamplePackets, Object], invalidMobilePhaseVolumeGivenObject], Cache -> simulatedCache] <> " are not missing volume information:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];
	(* 3. MAKE SURE THE SAMPLES ARE LIQUID - *)
	(* Get the samples that are not liquids, cannot spe those *)
	nonLiquidMobilePhasePackets = Map[
		If[
			Not[MatchQ[Lookup[#, State], Alternatives[Liquid, Null]]],
			#,
			Nothing
		]&,
		mobilePhasePackets
	];
	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidMobilePhase = If[MatchQ[nonLiquidMobilePhasePackets, {}], {}, Lookup[mobilePhasePackets, Object]];
	nonLiquidMobilePhaseVolumeGivenObject = DeleteDuplicates[Flatten[
		Map[
			If[MemberQ[#1, mobilePhaseSamples],
				(* if it is a sample object, just return it *)
				#1,
				(* if not, look for it's container *)
				Lookup[Cases[mobilePhasePacketsFromContainer, KeyValuePattern[Object -> #1]], Container]
			]&,
			nonLiquidSampleInvalidMobilePhase
		]
	]];
	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidMobilePhaseVolumeGivenObject] > 0 && messages,
		Message[Error::NonLiquidSample, ObjectToString[nonLiquidMobilePhaseVolumeGivenObject, Cache -> simulatedCache]];
	];
	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidMobilePhaseTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidMobilePhaseVolumeGivenObject] == 0,
				Nothing,
				Test["Our input solutions " <> ObjectToString[nonLiquidMobilePhaseVolumeGivenObject, Cache -> simulatedCache] <> " have a Liquid State:", True, False]
			];
			passingTest = If[Length[nonLiquidMobilePhaseVolumeGivenObject] == Length[mobilePhasePackets],
				Nothing,
				Test["Our input solutions " <> ObjectToString[Complement[Lookup[mobilePhasePackets, Object], nonLiquidMobilePhaseVolumeGivenObject], Cache -> simulatedCache] <> " have a Liquid State:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* -- Error if there are any duplicate Objects (duplicate Models ok) in the supplied Cartridge option -- *)
	(* Make a list of all of the Object[Container]s present in the Cartridge option *)
	suppliedCartridge = Lookup[mySPEOptions, ExtractionCartridge];
	suppliedCartridgeObjects = Cases[suppliedCartridge, ObjectP[{Object[Container, ExtractionCartridge], Object[Item, ExtractionCartridge]}]];
	(* Make a list of any cartridge Objects for which there are more than one present in the option *)
	duplicateCartridgeObjects = Map[
		FirstOrDefault[#, {}]&,
		Cases[Tally[suppliedCartridgeObjects], {_, GreaterP[1]}]
	];
	(* Set the invalid option variable *)
	invalidDuplicateCartridgeObjectOptions = If[Length[duplicateCartridgeObjects] > 0,
		{ExtractionCartridge},
		{}
	];
	(* If there are any invalidDuplicateCartridgeObjectOptions and we are throwing messages, throw an Error  *)
	If[Length[invalidDuplicateCartridgeObjectOptions] > 0 && messages,
		Message[Error::DuplicateSPECartridgeObjects, ObjectToString[duplicateCartridgeObjects, Cache -> simulatedCache]]
	];

	totalNumberOfSamples = Length[simulatedSamples];
	(*-- OPTION PRECISION CHECKS --*)
	(* check only with time for now, because we have other options are Instrument dependent, we can not set it arbitrarily *)
	(* TODO add all numerical options here *)
	timeOptionsPrecisions = {
		{PreFlushingSolutionTemperatureEquilibrationTime, 1 Second},
		{PreFlushingSolutionDrainTime, 1 Second},
		{ConditioningSolutionTemperatureEquilibrationTime, 1 Second},
		{ConditioningSolutionDrainTime, 1 Second},
		{MaxConditioningSolutionDrainTime, 1 Second},
		{LoadingSampleTemperatureEquilibrationTime, 1 Second},
		{LoadingSampleDrainTime, 1 Second},
		{MaxPreFlushingSolutionDrainTime, 1 Second},
		{WashingSolutionTemperatureEquilibrationTime, 1 Second},
		{WashingSolutionDrainTime, 1 Second},
		{MaxWashingSolutionDrainTime, 1 Second},
		{SecondaryWashingSolutionTemperatureEquilibrationTime, 1 Second},
		{SecondaryWashingSolutionDrainTime, 1 Second},
		{MaxSecondaryWashingSolutionDrainTime, 1 Second},
		{TertiaryWashingSolutionTemperatureEquilibrationTime, 1 Second},
		{TertiaryWashingSolutionDrainTime, 1 Second},
		{MaxTertiaryWashingSolutionDrainTime, 1 Second},
		{ElutingSolutionTemperatureEquilibrationTime, 1 Second},
		{ElutingSolutionDrainTime, 1 Second},
		{MaxElutingSolutionDrainTime, 1 Second}
	};
	(* round to defined precision *)
	{roundedSPEOptions, precisionTests} = If[gatherTests,
		OptionsHandling`Private`roundPooledOptionPrecision[Association[mySPEOptions], timeOptionsPrecisions[[All, 1]], timeOptionsPrecisions[[All, 2]], Output -> {Result, Tests}],
		{OptionsHandling`Private`roundPooledOptionPrecision[Association[mySPEOptions], timeOptionsPrecisions[[All, 1]], timeOptionsPrecisions[[All, 2]]], Null}
	];

	(* RESOLVE - MAPPING *)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentSolidPhaseExtraction, roundedSPEOptions];
	(* call neccessary lookup table before MapThread *)
	tablePreferredExtractionSorbent = speTableFunction["spePreferredExtractionSorbent"];
	tableIonExchangeDefinition = speTableFunction["speIonExchangeDefinition"];
	tableDefaultSolutionDefinition = speTableFunction["speDefaultSolutionDefinition"];
	tableExtractionOptions = speTableFunction["speExtractionOptions"];

	(* giant map thread *)
	{
		(*1*)mtInstrument,
		(*2*)mtExtractionMethod,
		(*3*)mtExtractionCartridgeType,
		(*4*)mtExtractionCartridge,
		(*5*)mtExtractionSorbent,
		(*6*)mtExtractionMode,
		(*7*)mtPreFlushingSwitch,
		(*8*)mtConditioningSwitch,
		(*9*)mtWashingSwitch,
		(*10*)mtSecondaryWashingSwitch,
		(*11*)mtTertiaryWashingSwitch,
		(*12*)mtElutingSwitch,
		(*13*)mtExtractionStrategy,
		(*14*)mtPreFlushingSolution,
		(*15*)mtConditioningSolution,
		(*16*)mtWashingSolution,
		(*17*)mtSecondaryWashingSolution,
		(*18*)mtTertiaryWashingSolution,
		(*19*)mtElutingSolution,
		(*20*)mtPreFlushingSolutionVolume,
		(*21*)mtConditioningSolutionVolume,
		(*22*)mtWashingSolutionVolume,
		(*23*)mtSecondaryWashingSolutionVolume,
		(*24*)mtTertiaryWashingSolutionVolume,
		(*25*)mtElutingSolutionVolume,
		(*26*)mtPreFlushingSolutionTemperature,
		(*27*)mtConditioningSolutionTemperature,
		(*28*)mtWashingSolutionTemperature,
		(*29*)mtSecondaryWashingSolutionTemperature,
		(*30*)mtTertiaryWashingSolutionTemperature,
		(*31*)mtElutingSolutionTemperature,
		(*32*)mtPreFlushingSolutionTemperatureEquilibrationTime,
		(*33*)mtConditioningSolutionTemperatureEquilibrationTime,
		(*34*)mtWashingSolutionTemperatureEquilibrationTime,
		(*35*)mtSecondaryWashingSolutionTemperatureEquilibrationTime,
		(*36*)mtTertiaryWashingSolutionTemperatureEquilibrationTime,
		(*37*)mtElutingSolutionTemperatureEquilibrationTime,
		(*38*)mtPreFlushingSolutionDispenseRate,
		(*39*)mtConditioningSolutionDispenseRate,
		(*40*)mtWashingSolutionDispenseRate,
		(*41*)mtSecondaryWashingSolutionDispenseRate,
		(*42*)mtTertiaryWashingSolutionDispenseRate,
		(*43*)mtElutingSolutionDispenseRate,
		(*44*)mtPreFlushingSolutionPressure,
		(*45*)mtConditioningSolutionPressure,
		(*46*)mtWashingSolutionPressure,
		(*47*)mtSecondaryWashingSolutionPressure,
		(*48*)mtTertiaryWashingSolutionPressure,
		(*49*)mtElutingSolutionPressure,
		(*50*)mtCollectPreFlushingSolution,
		(*51*)mtCollectConditioningSolution,
		(*52*)mtCollectWashingSolution,
		(*53*)mtCollectSecondaryWashingSolution,
		(*54*)mtCollectTertiaryWashingSolution,
		(*55*)mtCollectElutingSolution,
		(*56*)mtCollectLoadingSampleFlowthrough,
		(*57*)mtPreFlushingSolutionUntilDrained,
		(*58*)mtConditioningSolutionUntilDrained,
		(*59*)mtWashingSolutionUntilDrained,
		(*60*)mtSecondaryWashingSolutionUntilDrained,
		(*61*)mtTertiaryWashingSolutionUntilDrained,
		(*62*)mtElutingSolutionUntilDrained,
		(*63*)mtPreFlushingSolutionDrainTime,
		(*64*)mtConditioningSolutionDrainTime,
		(*65*)mtWashingSolutionDrainTime,
		(*66*)mtSecondaryWashingSolutionDrainTime,
		(*67*)mtTertiaryWashingSolutionDrainTime,
		(*68*)mtElutingSolutionDrainTime,
		(*69*)mtMaxPreFlushingSolutionDrainTime,
		(*70*)mtMaxConditioningSolutionDrainTime,
		(*71*)mtMaxWashingSolutionDrainTime,
		(*72*)mtMaxSecondaryWashingSolutionDrainTime,
		(*73*)mtMaxTertiaryWashingSolutionDrainTime,
		(*74*)mtMaxElutingSolutionDrainTime,
		(*75*)mtExtractionTemperature,
		(*76*)mtQuantitativeLoadingSample,
		(*77*)mtQuantitativeLoadingSampleSolution,
		(*78*)mtQuantitativeLoadingSampleVolume,
		(*79*)mtLoadingSampleVolume,
		(*80*)mtLoadingSampleTemperatureEquilibrationTime,
		(*81*)mtLoadingSampleTemperature,
(*		mtMixLoadingSampleFlowthrough,*)
		(*82*)mtLoadingSamplePressure,
		(*83*)mtLoadingSampleDispenseRate,
		(*84*)mtLoadingSampleDrainTime,
		(*85*)mtMaxLoadingSampleDrainTime,
		(*86*)mtPreFlushingSolutionCollectionContainer,
		(*87*)mtConditioningSolutionCollectionContainer,
		(*88*)mtWashingSolutionCollectionContainer,
		(*89*)mtSecondaryWashingSolutionCollectionContainer,
		(*90*)mtTertiaryWashingSolutionCollectionContainer,
		(*91*)mtElutingSolutionCollectionContainer,
		(*92*)mtLoadingSampleFlowthroughContainer,
		(*93*)mtPreparation,
		(*94*)mtSampleLabel,
		(*95*)mtSourceContainerLabel,
		(*96*)mtCartridgeLabel,
		(*97*)mtPreFlushingSampleOutLabel,
		(*98*)mtConditioningSampleOutLabel,
		(*99*)mtLoadingSampleFlowthroughSampleOutLabel,
		(*100*)mtWashingSampleOutLabel,
		(*101*)mtSecondaryWashingSampleOutLabel,
		(*102*)mtTertiaryWashingSampleOutLabel,
		(*103*)mtElutingSampleOutLabel,
		(*104*)mtPreFlushingSolutionLabel,
		(*105*)mtConditioningSolutionLabel,
		(*106*)mtWashingSolutionLabel,
		(*107*)mtSecondaryWashingSolutionLabel,
		(*108*)mtTertiaryWashingSolutionLabel,
		(*109*)mtElutingSolutionLabel,
		(*110*)mtSamplesInStorageCondition,
		(*111*)mtSamplesOutStorageCondition,
		(*112*)mtLoadingSampleUntilDrained,
		(* error and warning *)
		(*113*)mtunequalLoadingSampleVolumeLengthError,
		(*114*)mtincompatibleInstrumentSampleVolumeError,
		(*115*)mtincompatibleCartridgeInstrumentError,
		(*116*)mtincompatibleExtractionMethodSampleVolumeError,
		(*117*)mtincompatibleExtractionCartridgeError,
		(*118*)mtincompatibleInstrumentAndMethodError,
		(*119*)mtincompatibleInstrumentAndExtractionCartridgeError,
		(*120*)mtincompatibleExtractionMethodAndExtractionCartridgeError,
		(*121*)mtincompatibleInstrumentExtractionMethodExtractionCartridgeError,
		(*122*)mtwarningExtractionStrategyWashingSwitchIncompatible,
		(*123*)mtskippedWashingError,
		(*124*)mtwarningExtractionStrategySecondaryWashingSwitchIncompatible,
		(*125*)mtskippedSecondaryWashingError,
		(*126*)mtwarningExtractionStrategyTertiaryWashingSwitchIncompatible,
		(*127*)mtwarningPositiveStrategyWithoutEluting,
		(*128*)mtwarningExtractionStrategyElutingIncompatible,
		(*129*)mterrorPreFlushingPressureTooLow,
		(*130*)mterrorPreFlushingPressureTooHigh,
		(*131*)mterrorPreFlushingDispenseRateTooLow,
		(*132*)mterrorPreFlushingDispenseRateTooHigh,
		(*133*)mterrorConditioningPressureTooLow,
		(*134*)mterrorConditioningPressureTooHigh,
		(*135*)mterrorConditioningDispenseRateTooLow,
		(*136*)mterrorConditioningDispenseRateTooHigh,
		(*137*)mterrorWashingPressureTooLow,
		(*138*)mterrorWashingPressureTooHigh,
		(*139*)mterrorWashingDispenseRateTooLow,
		(*140*)mterrorWashingDispenseRateTooHigh,
		(*141*)mterrorElutingPressureTooLow,
		(*142*)mterrorElutingPressureTooHigh,
		(*143*)mterrorElutingDispenseRateTooLow,
		(*144*)mterrorElutingDispenseRateTooHigh,
		(*145*)mterrorSecondaryWashingPressureTooLow,
		(*146*)mterrorSecondaryWashingPressureTooHigh,
		(*147*)mterrorSecondaryWashingDispenseRateTooLow,
		(*148*)mterrorSecondaryWashingDispenseRateTooHigh,
		(*149*)mterrorTertiaryWashingPressureTooLow,
		(*150*)mterrorTertiaryWashingPressureTooHigh,
		(*151*)mterrorTertiaryWashingDispenseRateTooLow,
		(*152*)mterrorTertiaryWashingDispenseRateTooHigh,
		(*153*)mterrorAmbientOnlyInstrument,
		(*154*)mterrorExtractionTemperatureTooLow,
		(*155*)mterrorExtractionTemperatureTooHigh,
		(*156*)mtunequalLengthQuantitativeLoadingSampleError,
		(*157*)mtunequalLengthQuantitativeLoadingSampleSolutionError,
		(*158*)mtunequalLengthQuantitativeLoadingSampleVolumeError,
		(*159*)mtunequalLengthLoadingSampleTemperatureError,
		(*160*)mtunequalLengthLoadingSampleTemperatureEquilibrationTimeError,
		(*161*)mterrorLoadingSamplePressureTooLow,
		(*162*)mterrorLoadingSamplePressureTooHigh,
		(*163*)mterrorLoadingSampleDispenseRateTooLow,
		(*164*)mterrorLoadingSampleDispenseRateTooHigh,
		(*165*)mtwarningIncompatiblePreFlushingSolutionCollectionContainer,
		(*166*)mtwarningIncompatibleConditioningSolutionCollectionContainer,
		(*167*)mtwarningIncompatibleWashingSolutionCollectionContainer,
		(*168*)mtwarningIncompatibleSecondaryWashingSolutionCollectionContainer,
		(*169*)mtwarningIncompatibleTertiaryWashingSolutionCollectionContainer,
		(*170*)mtwarningIncompatibleElutingSolutionCollectionContainer,
		(*171*)mtwarningIncompatibleLoadingSampleFlowthroughContainer,
		(*172*)mtincompatibleExtractionCartridgeSampleVolumeError,
		(*173*)mtwarningVolumeTooHigh,
		(*174*)mtconflictingCartridgeSorbentWarning,
		(*175*)mtwarningExtractionStrategyChange,
		(*176*)mtwarningPreFlushingPressureMustBeBoolean,
		(*177*)mtwarningConditioningPressureMustBeBoolean,
		(*178*)mtwarningWashingPressureMustBeBoolean,
		(*179*)mtwarningElutingPressureMustBeBoolean,
		(*180*)mtwarningSecondaryWashingPressureMustBeBoolean,
		(*181*)mtwarningTertiaryWashingPressureMustBeBoolean,
		(*182*)mtwarningLoadingSamplePressureMustBeBoolean,
		(*183*)mtvolumeTooLargeWarning,
		(*184*)mtconflictingMethodInferringMobilePhaseOptionsError,
		(*185*)mtconflictingSuppliedMethodAndImpliedMethodError,
		(*186*)mtspeCannotSupportVolumeError,
		(*187*)mtspeCannotSupportCollectionError,
		(*188*)mtspeCannotSupportCartridgeError,
		(*189*)mtspeCannotSupportMethodError,
		(*190*)mtspeCannotSupportCartridgeError,
		(*191*)mtspeCannotSupportMethodError,
		(*192*)mtnoCompatibleInstrumentError,
		(*193*)mtconflictingCartridgeSorbentWarning,
		(*194*)mtconflictingSuppliedMethodAndImpliedMethodErrorOptionName,
		(*195*)mtbadLoadingSampleVolume,
		(*196*)mtnoCompatibleInstrumentErrorName,
		(*197*)mttooBigCartridgeError,
		(*198*)mttooManyCollectionPlateOnGX271DeckError,
		(*199*)mttooManyCollectionPlateOnGX271DeckOptionName,
		(*200*)mttooManyTypeOfSolutionOnGX271OptionName,
		(*201*)mttooManyTypeOfSolutionOnGX271Error,
		(*202*)mtcannotSupportQuantitativeLoadingError,
		(*203*)mtcannotSupportQuantitativeLoadingErrorOptionName,
		(*204*)mtquantitativeLoadingSampleSolutionError,
		(*205*)mtnotSPECartridgeError,
		(*206*)mtspeCannotSupportPreFlushVolume,
		(*207*)mtspeCannotSupportConditionVolume,
		(*208*)mtspeCannotSupportWashVolume,
		(*209*)mtspeCannotSupportSecondaryWashVolume,
		(*210*)mtspeCannotSupportTertiaryWashVolume,
		(*211*)mtspeCannotSupportEluteVolume,
		(*212*)mtspeCannotSupportQuantVolume,
		(*213*)mtspeCannotSupportInstrumentError,
		(*214*)mtbadVolumePreFlushName,
		(*215*)mtbadVolumeConditionName,
		(*216*)mtbadVolumeWashName,
		(*217*)mtbadVolumeSecWashName,
		(*218*)mtbadVolumeTerWashName,
		(*219*)mtbadVolumeEluteName,
		(*220*)mtbadVolumeQuantLoadName,
		(*221*)mtbadInstrumentName,
		(*222*)mterrorPreFlushingVolumeInstrument,
		(*223*)mterrorConditioningVolumeInstrument,
		(*224*)mterrorWashingVolumeInstrument,
		(*225*)mterrorElutingVolumeInstrument,
		(*226*)mterrorSecondaryWashingVolumeInstrument,
		(*227*)mterrorTertiaryWashingVolumeInstrument,
		(*228*)mterrorLoadingSampleVolumeInstrument,
		(*229*)mterrorPreFlushingInstrumentSolutionTemperature,
		(*230*)mterrorConditioningInstrumentSolutionTemperature,
		(*231*)mterrorWashingInstrumentSolutionTemperature,
		(*232*)mterrorElutingInstrumentSolutionTemperature,
		(*233*)mterrorSecondaryWashingInstrumentSolutionTemperature,
		(*234*)mterrorTertiaryWashingInstrumentSolutionTemperature,
		(*235*)mterrorLoadingSampleInstrumentSolutionTemperature,
		(*236*)mtcannotFindCartridgeWithSuppliedError,
		(* intermediate variable *)
		(*237*)mtnumberOfPreFlushingSolutionCollectionContainer,
		(*238*)mtnumberOfConditioningSolutionCollectionContainer,
		(*239*)mtnumberOfWashingSolutionCollectionContainer,
		(*240*)mtnumberOfSecondaryWashingSolutionCollectionContainer,
		(*241*)mtnumberOfTertiaryWashingSolutionCollectionContainer,
		(*242*)mtnumberOfElutingSolutionCollectionContainer,
		(*243*)mtnumberOfLoadingSampleFlowthroughContainer,
		(*244*)mtinstrumentModel,
		(*245*)mtpooledSampleVolumes,
		(*246*)mtpoolsize,
		(*247*)mtsampleVolumes,
		(*248*)mtconflictingMobilePhaseOptionName,
		(*249*)mtnumberOfCollection,
		(*250*)mtimpliedCollectionNameError,
		(*251*)mtresolvedExtractionCartridgeStorageCondition
	} = Transpose[
		MapThread[
			Function[{samplePacket, options},
				Module[
					(* Local variables *)
					{
						(* unresolved variables *)
						unresolvedLoadingSampleVolume,
						unresolvedInstrument, unresolvedInstrumentModel,
						unresolvedExtractionCartridge,
						unresolvedExtractionCartridgeType,
						unresolvedExtractionMethod,
						unresolvedExtractionSorbent,
						unresolvedExtractionMode,
						unresolvedExtractionStrategy,
						unresolvedPreFlushingSwitch,
						unresolvedConditioningSwitch,
						unresolvedWashingSwitch,
						unresolvedSecondaryWashingSwitch,
						unresolvedTertiaryWashingSwitch,
						unresolvedElutingSwitch,
						unresolvedPreFlushingSolution,
						unresolvedConditioningSolution,
						unresolvedWashingSolution,
						unresolvedSecondaryWashingSolution,
						unresolvedTertiaryWashingSolution,
						unresolvedElutingSolution,
						unresolvedPreFlushingSolutionVolume,
						unresolvedConditioningSolutionVolume,
						unresolvedWashingSolutionVolume,
						unresolvedSecondaryWashingSolutionVolume,
						unresolvedTertiaryWashingSolutionVolume,
						unresolvedElutingSolutionVolume,
						unresolvedPreFlushingSolutionTemperature,
						unresolvedConditioningSolutionTemperature,
						unresolvedWashingSolutionTemperature,
						unresolvedSecondaryWashingSolutionTemperature,
						unresolvedTertiaryWashingSolutionTemperature,
						unresolvedElutingSolutionTemperature,
						unresolvedPreFlushingSolutionTemperatureEquilibrationTime,
						unresolvedConditioningSolutionTemperatureEquilibrationTime,
						unresolvedWashingSolutionTemperatureEquilibrationTime,
						unresolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
						unresolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
						unresolvedElutingSolutionTemperatureEquilibrationTime,
						unresolvedPreFlushingSolutionDispenseRate,
						unresolvedConditioningSolutionDispenseRate,
						unresolvedWashingSolutionDispenseRate,
						unresolvedSecondaryWashingSolutionDispenseRate,
						unresolvedTertiaryWashingSolutionDispenseRate,
						unresolvedElutingSolutionDispenseRate,
						unresolvedPreFlushingSolutionPressure,
						unresolvedConditioningSolutionPressure,
						unresolvedWashingSolutionPressure,
						unresolvedSecondaryWashingSolutionPressure,
						unresolvedTertiaryWashingSolutionPressure,
						unresolvedElutingSolutionPressure,
						unresolvedPreFlushingSolutionUntilDrained,
						unresolvedConditioningSolutionUntilDrained,
						unresolvedWashingSolutionUntilDrained,
						unresolvedSecondaryWashingSolutionUntilDrained,
						unresolvedTertiaryWashingSolutionUntilDrained,
						unresolvedElutingSolutionUntilDrained,
						unresolvedPreFlushingSolutionDrainTime,
						unresolvedConditioningSolutionDrainTime,
						unresolvedWashingSolutionDrainTime,
						unresolvedSecondaryWashingSolutionDrainTime,
						unresolvedTertiaryWashingSolutionDrainTime,
						unresolvedElutingSolutionDrainTime,
						unresolvedMaxPreFlushingSolutionDrainTime,
						unresolvedMaxConditioningSolutionDrainTime,
						unresolvedMaxWashingSolutionDrainTime,
						unresolvedMaxSecondaryWashingSolutionDrainTime,
						unresolvedMaxTertiaryWashingSolutionDrainTime,
						unresolvedMaxElutingSolutionDrainTime,
						unresolvedExtractionTemperature,
						unresolvedQuantitativeLoadingSample,
						unresolvedQuantitativeLoadingSampleSolution,
						unresolvedQuantitativeLoadingSampleVolume,
						unresolvedLoadingSampleUntilDrained,
						unresolvedLoadingSampleTemperature,
						unresolvedLoadingSampleTemperatureEquilibrationTime,
						unresolvedCollectLoadingSampleFlowthrough,
						unresolvedLoadingSamplePressure,
						unresolvedLoadingSampleDispenseRate,
						unresolvedLoadingSampleDrainTime,
						unresolvedMaxLoadingSampleDrainTime,
						unresolvedPreFlushingSolutionCollectionContainer,
						unresolvedConditioningSolutionCollectionContainer,
						unresolvedWashingSolutionCollectionContainer,
						unresolvedSecondaryWashingSolutionCollectionContainer,
						unresolvedTertiaryWashingSolutionCollectionContainer,
						unresolvedElutingSolutionCollectionContainer,
						unresolvedLoadingSampleFlowthroughContainer,
						unresolvedCollectSecondaryWashingSolution,
						unresolvedCollectTertiaryWashingSolution,
						unresolvedCollectPreFlushingSolution,
						unresolvedCollectConditioningSolution,
						unresolvedCollectWashingSolution,
						unresolvedCollectElutingSolution,
						unresolvedSampleLabel,
						unresolvedSourceContainerLabel,
						unresolvedExtractionCartridgeLabel,
						unresolvedPreFlushingSampleOutLabel,
						unresolvedConditioningSampleOutLabel,
						unresolvedLoadingSampleFlowthroughSampleOutLabel,
						unresolvedWashingSampleOutLabel,
						unresolvedSecondaryWashingSampleOutLabel,
						unresolvedTertiaryWashingSampleOutLabel,
						unresolvedElutingSampleOutLabel,
						unresolvedSampleOutLabel,
						unresolvedPreFlushingSolutionLabel,
						unresolvedConditioningSolutionLabel,
						unresolvedWashingSolutionLabel,
						unresolvedSecondaryWashingSolutionLabel,
						unresolvedTertiaryWashingSolutionLabel,
						unresolvedElutingSolutionLabel,
						unresolvedSamplesInStorageCondition,
						unresolvedSamplesOutStorageCondition,
						unresolvedPreFlushingSolutionCentrifugeIntensity,
						unresolvedConditioningSolutionCentrifugeIntensity,
						unresolvedLoadingSampleCentrifugeIntensity,
						unresolvedWashingSolutionCentrifugeIntensity,
						unresolvedSecondaryWashingSolutionCentrifugeIntensity,
						unresolvedTertiaryWashingSolutionCentrifugeIntensity,
						unresolvedElutingSolutionCentrifugeIntensity,
						semiResolvedLoadingSampleFlowthroughSampleOutLabel,semiResolvedElutingSampleOutLabel,
						resolvedPreFlushingSampleOutLabel, resolvedConditioningSampleOutLabel, resolvedLoadingSampleFlowthroughSampleOutLabel,
						resolvedWashingSampleOutLabel, resolvedSecondaryWashingSampleOutLabel, resolvedTertiaryWashingSampleOutLabel, resolvedElutingSampleOutLabel,
						(* error checking variables *)
						unequalLoadingSampleVolumeLengthError,
						incompatibleInstrumentSampleVolumeError,
						incompatibleCartridgeInstrumentError,
						incompatibleExtractionMethodSampleVolumeError,
						incompatibleExtractionCartridgeError,
						incompatibleInstrumentAndMethodError,
						incompatibleInstrumentAndExtractionCartridgeError,
						incompatibleExtractionMethodAndExtractionCartridgeError,
						incompatibleInstrumentExtractionMethodExtractionCartridgeError,
						warningExtractionStrategyWashingSwitchIncompatible,
						skippedWashingError,
						warningExtractionStrategySecondaryWashingSwitchIncompatible,
						skippedSecondaryWashingError,
						warningExtractionStrategyTertiaryWashingSwitchIncompatible,
						warningPositiveStrategyWithoutEluting,
						warningExtractionStrategyElutingIncompatible,
						errorPreFlushingPressureTooLow,
						errorPreFlushingPressureTooHigh,
						errorPreFlushingDispenseRateTooLow,
						errorPreFlushingDispenseRateTooHigh,
						errorConditioningPressureTooLow,
						errorConditioningPressureTooHigh,
						errorConditioningDispenseRateTooLow,
						errorConditioningDispenseRateTooHigh,
						errorWashingPressureTooLow,
						errorWashingPressureTooHigh,
						errorWashingDispenseRateTooLow,
						errorWashingDispenseRateTooHigh,
						errorElutingPressureTooLow,
						errorElutingPressureTooHigh,
						errorElutingDispenseRateTooLow,
						errorElutingDispenseRateTooHigh,
						errorSecondaryWashingPressureTooLow,
						errorSecondaryWashingPressureTooHigh,
						errorSecondaryWashingDispenseRateTooLow,
						errorSecondaryWashingDispenseRateTooHigh,
						errorTertiaryWashingPressureTooLow,
						errorTertiaryWashingPressureTooHigh,
						errorTertiaryWashingDispenseRateTooLow,
						errorTertiaryWashingDispenseRateTooHigh,
						errorAmbientOnlyInstrument,
						errorExtractionTemperatureTooLow,
						errorExtractionTemperatureTooHigh,
						unequalLengthQuantitativeLoadingSampleError,
						unequalLengthQuantitativeLoadingSampleSolutionError,
						unequalLengthQuantitativeLoadingSampleVolumeError,
						unequalLengthLoadingSampleTemperatureError,
						unequalLengthLoadingSampleTemperatureEquilibrationTimeError,
						errorLoadingSamplePressureTooLow,
						errorLoadingSamplePressureTooHigh,
						errorLoadingSampleDispenseRateTooLow,
						errorLoadingSampleDispenseRateTooHigh,
						warningIncompatiblePreFlushingSolutionCollectionContainer,
						warningIncompatibleConditioningSolutionCollectionContainer,
						warningIncompatibleWashingSolutionCollectionContainer,
						warningIncompatibleSecondaryWashingSolutionCollectionContainer,
						warningIncompatibleTertiaryWashingSolutionCollectionContainer,
						warningIncompatibleElutingSolutionCollectionContainer,
						warningIncompatibleLoadingSampleFlowthroughContainer,
						incompatibleExtractionCartridgeSampleVolumeError,
						warningVolumeTooHigh,
						conflictingCartridgeSorbentWarning,
						warningExtractionStrategyChange,
						errorNotCollectingElutionFromPositiveSPE,
						conflictingSuppliedMethodAndImpliedMethodError,
						noCompatibleInstrumentError,
						unsortedIntersection,
						suggestedInstrument,
						failToSuggestInstrumentError,
						speCannotSupportVolumeError,
						speCannotSupportCollectionError,
						speCannotSupportCartridgeError,
						speCannotSupportMethodError,
						(* pooled error tracking varialbles *)
						volumeTooLargeWarning,
						(* resolved variables *)
						resolvedInstrument,
						resolvedExtractionMethod,
						resolvedExtractionCartridgeType,
						resolvedExtractionCartridge,
						resolvedExtractionSorbent,
						resolvedExtractionMode,
						resolvedPreFlushingSwitch,
						resolvedConditioningSwitch,
						resolvedWashingSwitch,
						resolvedSecondaryWashingSwitch,
						resolvedTertiaryWashingSwitch,
						resolvedElutingSwitch,
						resolvedExtractionStrategy,
						resolvedPreFlushingSolution,
						resolvedConditioningSolution,
						resolvedWashingSolution,
						resolvedSecondaryWashingSolution,
						resolvedTertiaryWashingSolution,
						resolvedElutingSolution,
						resolvedPreFlushingSolutionVolume,
						resolvedConditioningSolutionVolume,
						resolvedWashingSolutionVolume,
						resolvedSecondaryWashingSolutionVolume,
						resolvedTertiaryWashingSolutionVolume,
						resolvedElutingSolutionVolume,
						resolvedPreFlushingSolutionTemperature,
						resolvedConditioningSolutionTemperature,
						resolvedWashingSolutionTemperature,
						resolvedSecondaryWashingSolutionTemperature,
						resolvedTertiaryWashingSolutionTemperature,
						resolvedElutingSolutionTemperature,
						resolvedPreFlushingSolutionTemperatureEquilibrationTime,
						resolvedConditioningSolutionTemperatureEquilibrationTime,
						resolvedWashingSolutionTemperatureEquilibrationTime,
						resolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
						resolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
						resolvedElutingSolutionTemperatureEquilibrationTime,
						resolvedPreFlushingSolutionDispenseRate,
						resolvedConditioningSolutionDispenseRate,
						resolvedWashingSolutionDispenseRate,
						resolvedSecondaryWashingSolutionDispenseRate,
						resolvedTertiaryWashingSolutionDispenseRate,
						resolvedElutingSolutionDispenseRate,
						resolvedPreFlushingSolutionPressure,
						resolvedConditioningSolutionPressure,
						resolvedWashingSolutionPressure,
						resolvedSecondaryWashingSolutionPressure,
						resolvedTertiaryWashingSolutionPressure,
						resolvedElutingSolutionPressure,
						resolvedCollectPreFlushingSolution,
						resolvedCollectConditioningSolution,
						resolvedCollectWashingSolution,
						resolvedCollectSecondaryWashingSolution,
						resolvedCollectTertiaryWashingSolution,
						resolvedCollectElutingSolution,
						resolvedPreFlushingSolutionUntilDrained,
						resolvedConditioningSolutionUntilDrained,
						resolvedWashingSolutionUntilDrained,
						resolvedSecondaryWashingSolutionUntilDrained,
						resolvedTertiaryWashingSolutionUntilDrained,
						resolvedElutingSolutionUntilDrained,
						resolvedPreFlushingSolutionDrainTime,
						resolvedConditioningSolutionDrainTime,
						resolvedWashingSolutionDrainTime,
						resolvedSecondaryWashingSolutionDrainTime,
						resolvedTertiaryWashingSolutionDrainTime,
						resolvedElutingSolutionDrainTime,
						resolvedMaxPreFlushingSolutionDrainTime,
						resolvedMaxConditioningSolutionDrainTime,
						resolvedMaxWashingSolutionDrainTime,
						resolvedMaxSecondaryWashingSolutionDrainTime,
						resolvedMaxTertiaryWashingSolutionDrainTime,
						resolvedMaxElutingSolutionDrainTime,
						resolvedInstrumentModel,
						resolvedExtractionTemperature,
						resolvedQuantitativeLoadingSample,
						resolvedQuantitativeLoadingSampleSolution,
						resolvedQuantitativeLoadingSampleVolume,
						resolvedLoadingSampleVolume,
						resolvedLoadingSampleUntilDrained,
						resolvedCollectLoadingSampleFlowthrough,
						resolvedLoadingSamplePressure,
						resolvedLoadingSampleDispenseRate,
						resolvedLoadingSampleDrainTime,
						resolvedMaxLoadingSampleDrainTime,
						resolvedPreFlushingSolutionCollectionContainer,
						resolvedConditioningSolutionCollectionContainer,
						resolvedWashingSolutionCollectionContainer,
						resolvedSecondaryWashingSolutionCollectionContainer,
						resolvedTertiaryWashingSolutionCollectionContainer,
						resolvedElutingSolutionCollectionContainer,
						resolvedLoadingSampleFlowthroughContainer,
						resolvedPreparation,
						resolvedSampleLabel,
						resolvedSourceContainerLabel,
						resolvedCartridgeLabel,
						resolvedPreFlushingSolutionLabel,
						resolvedConditioningSolutionLabel,
						resolvedWashingSolutionLabel,
						resolvedSecondaryWashingSolutionLabel,
						resolvedTertiaryWashingSolutionLabel,
						resolvedElutingSolutionLabel,
						resolvedSamplesInStorageCondition,
						resolvedSamplesOutStorageCondition,
						(* intermediate variables *)
						poolsize,
						sampleVolumes,
						pooledSampleVolumes,
						expandedUnresolvedLoadingSampleVolume,
						determinedByInstrument,
						instrumentModelByVolume,
						instrumentModelByCollection,
						instrumentModelByCartridge,
						instrumentModelByMethod,
						suggestInstrumentList,
						determinedByInstrumentSuggestion,
						unresolvedExtractionCartridgeModel,
						resolvedExtractionCartridgeModel,
						actualRunningMode,
						copiedSecondaryWashingSolution, copiedSecondaryWashingSolutionVolume,
						copiedSecondaryWashingSolutionTemperature,
						copiedSecondaryWashingSolutionTemperatureEquilibrationTime,
						copiedCollectSecondaryWashingSolution,
						copiedSecondaryWashingSolutionPressure,
						copiedSecondaryWashingSolutionDispenseRate,
						copiedSecondaryWashingSolutionDrainTime,
						copiedSecondaryWashingSolutionUntilDrained,
						copiedMaxSecondaryWashingSolutionDrainTime,
						copiedTertiaryWashingSolution, copiedTertiaryWashingSolutionVolume,
						copiedTertiaryWashingSolutionTemperature,
						copiedTertiaryWashingSolutionTemperatureEquilibrationTime,
						copiedCollectTertiaryWashingSolution,
						copiedTertiaryWashingSolutionPressure,
						copiedTertiaryWashingSolutionDispenseRate,
						copiedTertiaryWashingSolutionDrainTime,
						copiedTertiaryWashingSolutionUntilDrained,
						copiedMaxTertiaryWashingSolutionDrainTime,
						copiedSecondaryWashingSolutionLabel,
						copiedTertiaryWashingSolutionLabel,
						copiedSecondaryWashingSolutionCollectionContainer, copiedTertiaryWashingSolutionCollectionContainer,
						primaryOptions,
						secondaryOptions,
						tertiaryOptions,
						semiResolvedExtractionTemperature,
						instrumentAmbientOnly,
						considerAmbientExtraction,
						minInstrumentTemp,
						maxInstrumentTemp,
						expandedQuantitativeLoadingSample,
						expandedQuantitativeLoadingSampleSolution,
						expandedQuantitativeLoadingSampleVolume,
						resolvedPooledLoadingSampleVolume,
						individualSampleContainerObject,
						individualSampleContainerMaxVolume,
						almostSuggestedQuantitativeVolume,
						expandedLoadingSampleTemperature,
						expandedLoadingSampleTemperatureEquilibrationTime,
						pooledResolvedLoadingSampleVolume,
						resolvedLoadingSampleTemperatureEquilibrationTime,
						pooledResolvedLoadingSamplePressure,
						pooledResolvedLoadingSampleDispenseRate,
						pooledResolvedLoadingSampleDrainTime,
						pooledResolvedMaxLoadingSampleDrainTime,
						resolvedLoadingSampleTemperature,
						poolederrorLoadingSamplePressureTooLow,
						poolederrorLoadingSamplePressureTooHigh,
						poolederrorLoadingSampleDispenseRateTooLow,
						poolederrorLoadingSampleDispenseRateTooHigh,
						numberOfPreFlushingSolutionCollectionContainer,
						numberOfConditioningSolutionCollectionContainer,
						numberOfWashingSolutionCollectionContainer,
						numberOfSecondaryWashingSolutionCollectionContainer,
						numberOfTertiaryWashingSolutionCollectionContainer,
						numberOfElutingSolutionCollectionContainer,
						totalLoadingSampleVolume,
						pooledResolvedQuantitativeLoadingSampleVolume,
						numberOfLoadingSampleFlowthroughContainer,
						finalExpandedUnresolvedLoadingSampleVolume,
						semiResolvedCollectLoadingSampleFlowthrough,
						pooledSamplePackets,
						sampleContainerPackets,
						semiResolvedCollectElutingSolution,
						ignoredLoadingSampleLabel,
						defaultSampleStorageCondition,
						warningPreFlushingPressureMustBeBoolean,
						warningConditioningPressureMustBeBoolean,
						warningWashingPressureMustBeBoolean,
						warningElutingPressureMustBeBoolean,
						warningSecondaryWashingPressureMustBeBoolean,
						warningTertiaryWashingPressureMustBeBoolean,
						warningLoadingSamplePressureMustBeBoolean,
						pooledwarningLoadingSamplePressureMustBeBoolean,
						impliedCollectByContainerOptionName,
						impliedCollectByOptionOptionName,
						impliedCollectionNameError,
						conflictingSuppliedMethodAndImpliedMethodErrorOptionName,
						badLoadingSampleVolume,
						badVolumeOptionName,
						badCollectionOptionName,
						badCartidgeName,
						badMethodName,
						noCompatibleInstrumentErrorName,
						instrumentModelByPrepartion, badPreparationName,
						unresolvedPreparation,
						tooBigCartridgeError,
						tooManyCollectionPlateOnGX271DeckOptionName,
						tooManyTypeOfSolutionOnGX271OptionName,
						tooManyTypeOfSolutionOnGX271Error,
						enableQuantitativeLoadingSample,
						suppliedOptionsForCollection,
						nCollectionContainer, nTypesOfSolution, allSolutionTypes,
						userDefineQuantQ,
						cannotSupportQuantitativeLoadingError,
						cannotSupportQuantitativeLoadingErrorOptionName,
						quantitativeLoadingSampleSolutionError,
						resolvedQuantitativeLoadingSampleSolutionAndError,
						extractionCartridgeMaxVolume,
						notSPECartridgeError,
						instrumentModelByPreFlush, badVolumePreFlushName,
						instrumentModelByCondition, badVolumeConditionName,
						instrumentModelByWash, badVolumeWashName,
						instrumentModelBySecWash, badVolumeSecWashName,
						instrumentModelByTerWash, badVolumeTerWashName,
						instrumentModelByElute, badVolumeEluteName,
						instrumentModelByQuantLoad, badVolumeQuantLoadName,
						instrumentModelByInstrument, badInstrumentName,
						speCannotSupportPreFlushVolume,
						speCannotSupportConditionVolume,
						speCannotSupportWashVolume,
						speCannotSupportSecondaryWashVolume,
						speCannotSupportTertiaryWashVolume,
						speCannotSupportEluteVolume,
						speCannotSupportQuantVolume,
						speCannotSupportInstrumentError,
						anySuppliedVolume,
						errorPreFlushingVolumeInstrument,
						errorConditioningVolumeInstrument,
						errorWashingVolumeInstrument,
						errorElutingVolumeInstrument,
						errorSecondaryWashingVolumeInstrument,
						errorTertiaryWashingVolumeInstrument,
						poolederrorLoadingSampleVolumeInstrument,
						errorLoadingSampleVolumeInstrument,
						pooledUnresolvedQuantitativeLoadingSampleVolume,
						possibleInstrument,
						poolederrorLoadingSampleInstrumentSolutionTemperature,
						errorPreFlushingInstrumentSolutionTemperature,
						errorConditioningInstrumentSolutionTemperature,
						errorWashingInstrumentSolutionTemperature,
						errorElutingInstrumentSolutionTemperature,
						errorSecondaryWashingInstrumentSolutionTemperature,
						errorTertiaryWashingInstrumentSolutionTemperature,
						errorLoadingSampleInstrumentSolutionTemperature,
						cannotFindCartridgeWithSuppliedError,
						conflictingMobilePhaseOptionName,
						resolvedExtractionCartridgeStorageCondition,
						unresolvedExtractionCartridgeStorageCondition,
						individualSampleContainerModel,
						numberOfCollection, conflictingMethodInferringMobilePhaseOptionsError, tooManyCollectionPlateOnGX271DeckError,
						impliedCollectByOption, impliedCollection, semiResolvedExtractionMethod, inferInstrumentFromMethod,
						mobilePhaseOptionsName, conflictingMobilePhaseOptionsIndex, mobilePhaseOptionsValue,
						inferExtractionMethod, existInjectionOptionsQ, existCentrifugeOptionsQ, existPressureOptionsQ,
						injectionOptionsName, centrifugeOptionsName, pressureOptionsName,
						injectionOptions, centrifugeOptions, pressureOptions
					},

					(* initialize Error checking variables -- non pooled -- *)
					{
						unequalLoadingSampleVolumeLengthError,
						incompatibleInstrumentSampleVolumeError,
						incompatibleCartridgeInstrumentError,
						incompatibleExtractionMethodSampleVolumeError,
						incompatibleExtractionCartridgeError,
						incompatibleInstrumentAndMethodError,
						incompatibleInstrumentAndExtractionCartridgeError,
						incompatibleExtractionMethodAndExtractionCartridgeError,
						incompatibleInstrumentExtractionMethodExtractionCartridgeError,
						warningExtractionStrategyWashingSwitchIncompatible,
						skippedWashingError,
						warningExtractionStrategySecondaryWashingSwitchIncompatible,
						skippedSecondaryWashingError,
						warningExtractionStrategyTertiaryWashingSwitchIncompatible,
						warningPositiveStrategyWithoutEluting,
						warningExtractionStrategyElutingIncompatible,
						errorPreFlushingPressureTooLow,
						errorPreFlushingPressureTooHigh,
						errorPreFlushingDispenseRateTooLow,
						errorPreFlushingDispenseRateTooHigh,
						errorConditioningPressureTooLow,
						errorConditioningPressureTooHigh,
						errorConditioningDispenseRateTooLow,
						errorConditioningDispenseRateTooHigh,
						errorWashingPressureTooLow,
						errorWashingPressureTooHigh,
						errorWashingDispenseRateTooLow,
						errorWashingDispenseRateTooHigh,
						errorElutingPressureTooLow,
						errorElutingPressureTooHigh,
						errorElutingDispenseRateTooLow,
						errorElutingDispenseRateTooHigh,
						errorSecondaryWashingPressureTooLow,
						errorSecondaryWashingPressureTooHigh,
						errorSecondaryWashingDispenseRateTooLow,
						errorSecondaryWashingDispenseRateTooHigh,
						errorTertiaryWashingPressureTooLow,
						errorTertiaryWashingPressureTooHigh,
						errorTertiaryWashingDispenseRateTooLow,
						errorTertiaryWashingDispenseRateTooHigh,
						errorAmbientOnlyInstrument,
						errorExtractionTemperatureTooLow,
						errorExtractionTemperatureTooHigh,
						unequalLengthQuantitativeLoadingSampleError,
						unequalLengthQuantitativeLoadingSampleSolutionError,
						unequalLengthQuantitativeLoadingSampleVolumeError,
						unequalLengthLoadingSampleTemperatureError,
						unequalLengthLoadingSampleTemperatureEquilibrationTimeError,
						errorLoadingSamplePressureTooLow,
						errorLoadingSamplePressureTooHigh,
						errorLoadingSampleDispenseRateTooLow,
						errorLoadingSampleDispenseRateTooHigh,
						warningIncompatiblePreFlushingSolutionCollectionContainer,
						warningIncompatibleConditioningSolutionCollectionContainer,
						warningIncompatibleWashingSolutionCollectionContainer,
						warningIncompatibleSecondaryWashingSolutionCollectionContainer,
						warningIncompatibleTertiaryWashingSolutionCollectionContainer,
						warningIncompatibleElutingSolutionCollectionContainer,
						warningIncompatibleLoadingSampleFlowthroughContainer,
						incompatibleExtractionCartridgeSampleVolumeError,
						warningVolumeTooHigh,
						conflictingCartridgeSorbentWarning,
						errorNotCollectingElutionFromPositiveSPE,
						noCompatibleInstrumentError,
						failToSuggestInstrumentError,
						speCannotSupportVolumeError,
						speCannotSupportCollectionError,
						speCannotSupportCartridgeError,
						speCannotSupportMethodError,
						warningPreFlushingPressureMustBeBoolean,
						warningConditioningPressureMustBeBoolean,
						warningWashingPressureMustBeBoolean,
						warningElutingPressureMustBeBoolean,
						warningSecondaryWashingPressureMustBeBoolean,
						warningTertiaryWashingPressureMustBeBoolean,
						warningLoadingSamplePressureMustBeBoolean,
						tooBigCartridgeError
					} = ConstantArray[False, 77];
					(* pull all unresolved options *)
					{
						(*1*)
						unresolvedLoadingSampleVolume,
						unresolvedInstrument,
						unresolvedExtractionCartridge,
						unresolvedExtractionMethod,
						unresolvedExtractionSorbent,
						unresolvedExtractionMode,
						unresolvedExtractionStrategy,
						unresolvedPreFlushingSwitch,
						unresolvedConditioningSwitch,
						unresolvedWashingSwitch,
						(*11*)
						unresolvedSecondaryWashingSwitch,
						unresolvedTertiaryWashingSwitch,
						unresolvedElutingSwitch,
						unresolvedPreFlushingSolution,
						unresolvedConditioningSolution,
						unresolvedWashingSolution,
						unresolvedSecondaryWashingSolution,
						unresolvedTertiaryWashingSolution,
						unresolvedElutingSolution,
						unresolvedPreFlushingSolutionVolume,
						(*21*)
						unresolvedConditioningSolutionVolume,
						unresolvedWashingSolutionVolume,
						unresolvedSecondaryWashingSolutionVolume,
						unresolvedTertiaryWashingSolutionVolume,
						unresolvedElutingSolutionVolume,
						unresolvedPreFlushingSolutionTemperature,
						unresolvedConditioningSolutionTemperature,
						unresolvedWashingSolutionTemperature,
						unresolvedSecondaryWashingSolutionTemperature,
						unresolvedTertiaryWashingSolutionTemperature,
						(*31*)
						unresolvedElutingSolutionTemperature,
						unresolvedPreFlushingSolutionTemperatureEquilibrationTime,
						unresolvedConditioningSolutionTemperatureEquilibrationTime,
						unresolvedWashingSolutionTemperatureEquilibrationTime,
						unresolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
						unresolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
						unresolvedElutingSolutionTemperatureEquilibrationTime,
						unresolvedPreFlushingSolutionDispenseRate,
						unresolvedConditioningSolutionDispenseRate,
						unresolvedWashingSolutionDispenseRate,
						(*41*)
						unresolvedSecondaryWashingSolutionDispenseRate,
						unresolvedTertiaryWashingSolutionDispenseRate,
						unresolvedElutingSolutionDispenseRate,
						unresolvedPreFlushingSolutionPressure,
						unresolvedConditioningSolutionPressure,
						unresolvedWashingSolutionPressure,
						unresolvedSecondaryWashingSolutionPressure,
						unresolvedTertiaryWashingSolutionPressure,
						unresolvedElutingSolutionPressure,
						unresolvedCollectPreFlushingSolution,
						(*51*)
						unresolvedCollectConditioningSolution,
						unresolvedCollectWashingSolution,
						unresolvedCollectSecondaryWashingSolution,
						unresolvedCollectTertiaryWashingSolution,
						unresolvedCollectElutingSolution,
						(*61*)
						unresolvedPreFlushingSolutionUntilDrained,
						unresolvedConditioningSolutionUntilDrained,
						unresolvedWashingSolutionUntilDrained,
						unresolvedSecondaryWashingSolutionUntilDrained,
						unresolvedTertiaryWashingSolutionUntilDrained,
						unresolvedElutingSolutionUntilDrained,
						unresolvedPreFlushingSolutionDrainTime,
						unresolvedConditioningSolutionDrainTime,
						unresolvedWashingSolutionDrainTime,
						(*71*)
						unresolvedSecondaryWashingSolutionDrainTime,
						unresolvedTertiaryWashingSolutionDrainTime,
						unresolvedElutingSolutionDrainTime,
						unresolvedMaxPreFlushingSolutionDrainTime,
						unresolvedMaxConditioningSolutionDrainTime,
						unresolvedMaxWashingSolutionDrainTime,
						unresolvedMaxSecondaryWashingSolutionDrainTime,
						unresolvedMaxTertiaryWashingSolutionDrainTime,
						unresolvedMaxElutingSolutionDrainTime,
						unresolvedExtractionTemperature,
						(*81*)
						unresolvedQuantitativeLoadingSample,
						unresolvedQuantitativeLoadingSampleSolution,
						unresolvedQuantitativeLoadingSampleVolume,
						unresolvedLoadingSampleUntilDrained,
						(*91*)
						unresolvedLoadingSampleTemperature,
						unresolvedLoadingSampleTemperatureEquilibrationTime,
						unresolvedCollectLoadingSampleFlowthrough,
						unresolvedLoadingSamplePressure,
						unresolvedLoadingSampleDispenseRate,
						unresolvedLoadingSampleDrainTime,
						unresolvedMaxLoadingSampleDrainTime,
						unresolvedPreFlushingSolutionCollectionContainer,
						(*101*)
						unresolvedConditioningSolutionCollectionContainer,
						unresolvedWashingSolutionCollectionContainer,
						unresolvedSecondaryWashingSolutionCollectionContainer,
						unresolvedTertiaryWashingSolutionCollectionContainer,
						unresolvedElutingSolutionCollectionContainer,
						unresolvedLoadingSampleFlowthroughContainer,
						unresolvedSampleLabel,
						unresolvedSourceContainerLabel,
						unresolvedExtractionCartridgeLabel,
						unresolvedPreFlushingSampleOutLabel,
						(*111*)
						unresolvedConditioningSampleOutLabel,
						unresolvedLoadingSampleFlowthroughSampleOutLabel,
						unresolvedWashingSampleOutLabel,
						unresolvedSecondaryWashingSampleOutLabel,
						unresolvedTertiaryWashingSampleOutLabel,
						unresolvedElutingSampleOutLabel,
						unresolvedSampleOutLabel,
						unresolvedPreFlushingSolutionLabel,
						unresolvedConditioningSolutionLabel,
						unresolvedWashingSolutionLabel,
						unresolvedSecondaryWashingSolutionLabel,
						(*122*)
						unresolvedTertiaryWashingSolutionLabel,
						unresolvedElutingSolutionLabel,
						unresolvedSamplesInStorageCondition,
						unresolvedSamplesOutStorageCondition,
						unresolvedPreFlushingSolutionCentrifugeIntensity,
						unresolvedConditioningSolutionCentrifugeIntensity,
						unresolvedLoadingSampleCentrifugeIntensity,
						unresolvedWashingSolutionCentrifugeIntensity,
						unresolvedSecondaryWashingSolutionCentrifugeIntensity,
						unresolvedTertiaryWashingSolutionCentrifugeIntensity,
						(*132*)
						unresolvedElutingSolutionCentrifugeIntensity,
						unresolvedPreparation,
						unresolvedExtractionCartridgeStorageCondition
					} = Lookup[options,
						{
							(*1*)
							LoadingSampleVolume,
							Instrument,
							ExtractionCartridge,
							ExtractionMethod,
							ExtractionSorbent,
							ExtractionMode,
							ExtractionStrategy,
							PreFlushing,
							Conditioning,
							Washing,
							(*11*)
							SecondaryWashing,
							TertiaryWashing,
							Eluting,
							PreFlushingSolution,
							ConditioningSolution,
							WashingSolution,
							SecondaryWashingSolution,
							TertiaryWashingSolution,
							ElutingSolution,
							PreFlushingSolutionVolume,
							(*21*)
							ConditioningSolutionVolume,
							WashingSolutionVolume,
							SecondaryWashingSolutionVolume,
							TertiaryWashingSolutionVolume,
							ElutingSolutionVolume,
							PreFlushingSolutionTemperature,
							ConditioningSolutionTemperature,
							WashingSolutionTemperature,
							SecondaryWashingSolutionTemperature,
							TertiaryWashingSolutionTemperature,
							(*31*)
							ElutingSolutionTemperature,
							PreFlushingSolutionTemperatureEquilibrationTime,
							ConditioningSolutionTemperatureEquilibrationTime,
							WashingSolutionTemperatureEquilibrationTime,
							SecondaryWashingSolutionTemperatureEquilibrationTime,
							TertiaryWashingSolutionTemperatureEquilibrationTime,
							ElutingSolutionTemperatureEquilibrationTime,
							PreFlushingSolutionDispenseRate,
							ConditioningSolutionDispenseRate,
							WashingSolutionDispenseRate,
							(*41*)
							SecondaryWashingSolutionDispenseRate,
							TertiaryWashingSolutionDispenseRate,
							ElutingSolutionDispenseRate,
							PreFlushingSolutionPressure,
							ConditioningSolutionPressure,
							WashingSolutionPressure,
							SecondaryWashingSolutionPressure,
							TertiaryWashingSolutionPressure,
							ElutingSolutionPressure,
							CollectPreFlushingSolution,
							(*51*)
							CollectConditioningSolution,
							CollectWashingSolution,
							CollectSecondaryWashingSolution,
							CollectTertiaryWashingSolution,
							CollectElutingSolution,
							(*61*)
							PreFlushingSolutionUntilDrained,
							ConditioningSolutionUntilDrained,
							WashingSolutionUntilDrained,
							SecondaryWashingSolutionUntilDrained,
							TertiaryWashingSolutionUntilDrained,
							ElutingSolutionUntilDrained,
							PreFlushingSolutionDrainTime,
							ConditioningSolutionDrainTime,
							WashingSolutionDrainTime,
							(*71*)
							SecondaryWashingSolutionDrainTime,
							TertiaryWashingSolutionDrainTime,
							ElutingSolutionDrainTime,
							MaxPreFlushingSolutionDrainTime,
							MaxConditioningSolutionDrainTime,
							MaxWashingSolutionDrainTime,
							MaxSecondaryWashingSolutionDrainTime,
							MaxTertiaryWashingSolutionDrainTime,
							MaxElutingSolutionDrainTime,
							ExtractionTemperature,
							(*81*)
							QuantitativeLoadingSample,
							QuantitativeLoadingSampleSolution,
							QuantitativeLoadingSampleVolume,
							LoadingSampleUntilDrained,
							(*91*)
							LoadingSampleTemperature,
							LoadingSampleTemperatureEquilibrationTime,
							CollectLoadingSampleFlowthrough,
							LoadingSamplePressure,
							LoadingSampleDispenseRate,
							LoadingSampleDrainTime,
							MaxLoadingSampleDrainTime,
							PreFlushingSolutionCollectionContainer,
							(*101*)
							ConditioningSolutionCollectionContainer,
							WashingSolutionCollectionContainer,
							SecondaryWashingSolutionCollectionContainer,
							TertiaryWashingSolutionCollectionContainer,
							ElutingSolutionCollectionContainer,
							LoadingSampleFlowthroughContainer,
							SampleLabel,
							SourceContainerLabel,
							ExtractionCartridgeLabel,
							PreFlushingSampleOutLabel,
							(*111*)
							ConditioningSampleOutLabel,
							LoadingSampleFlowthroughSampleOutLabel,
							WashingSampleOutLabel,
							SecondaryWashingSampleOutLabel,
							TertiaryWashingSampleOutLabel,
							ElutingSampleOutLabel,
							SampleOutLabel,
							PreFlushingSolutionLabel,
							ConditioningSolutionLabel,
							WashingSolutionLabel,
							SecondaryWashingSolutionLabel,
							(*122*)
							TertiaryWashingSolutionLabel,
							ElutingSolutionLabel,
							SamplesInStorageCondition,
							SamplesOutStorageCondition,
							PreFlushingSolutionCentrifugeIntensity,
							ConditioningSolutionCentrifugeIntensity,
							LoadingSampleCentrifugeIntensity,
							WashingSolutionCentrifugeIntensity,
							SecondaryWashingSolutionCentrifugeIntensity,
							TertiaryWashingSolutionCentrifugeIntensity,
							(*132*)
							ElutingSolutionCentrifugeIntensity,
							Preparation,
							ExtractionCartridgeStorageCondition
						}
					];

					(* --1-- semi-resolve Sample Volume to find proper cartridge and instrument*)
					poolsize = Length[samplePacket];
					sampleVolumes = Map[cacheLookup[simulatedCache, #[Object], Volume]&, samplePacket];
					pooledSampleVolumes = Total[sampleVolumes];
					(* we have to do the same thing for loading sample volume be cause it is a pooled options *)
					pooledUnresolvedQuantitativeLoadingSampleVolume = Total[Flatten[unresolvedQuantitativeLoadingSampleVolume /. {Null | Automatic -> 0 Milliliter}]];

					(* expand the volume option to make sure that we won't have unequal length problem later *)
					(* this is to force function to run to the end in case the use give us shorter than pooled LoadingSampleVolume*)
					expandedUnresolvedLoadingSampleVolume = ReplacePart[
						ConstantArray[All, Length[sampleVolumes]],
						MapThread[#1 -> #2&, {Array[# &, Length[ToList[unresolvedLoadingSampleVolume]]], ToList[unresolvedLoadingSampleVolume]}]
					];

					(* change all automatic to all*)
					expandedUnresolvedLoadingSampleVolume /. Automatic -> All;

					(* check if LoadingSampleVolumeLength is equal with Length of pooled sample or Not *)
					{unequalLoadingSampleVolumeLengthError, finalExpandedUnresolvedLoadingSampleVolume} = Which[

						Length[ToList[expandedUnresolvedLoadingSampleVolume]] < poolsize,
						{
							True,
							ReplacePart[
								ConstantArray[All, poolsize],
								Transpose[{Array[#&, Length[ToList[unresolvedLoadingSampleVolume]]], ToList[unresolvedLoadingSampleVolume]}]
							]
						},

						Length[ToList[expandedUnresolvedLoadingSampleVolume]] > poolsize,
						{
							True,
							Take[ToList[unresolvedLoadingSampleVolume], poolsize]
						},

						True,
						{
							False,
							ToList[unresolvedLoadingSampleVolume]
						}
					];
					(* resolve loading volume, and check if the requested volume is larger than what the sample has *)
					{resolvedLoadingSampleVolume, volumeTooLargeWarning} = Transpose[MapThread[
						Which[
							(* if all is used in any context, then it is the total sample volume *)
							MatchQ[#1, All | Automatic],
							{#2, False},
							(* if the supplied volume is more than actual sample, change it to total sample volume, and throw warning *)
							MatchQ[#1, GreaterP[#2]],
							{#2, True},
							(* otherwise return the supplied value *)
							MatchQ[#1, LessEqualP[#2]],
							{#1, False}
						]&, {finalExpandedUnresolvedLoadingSampleVolume, sampleVolumes}
					]];
					(* once the loading quantity is all known, then we will use pooled volume to guide the type of cartridge and instrument to run SPE on *)
					resolvedPooledLoadingSampleVolume = Total[resolvedLoadingSampleVolume];

					(* --2-- find compatible ExtractionInstrument and ExtractionCartridge and Collection Volume *)
					(* Key Logic - once Instrument is known, we will just try our best to accommodate it *)
					(* as long as the supplied values not automatic or null, we can infer*)
					injectionOptions = {
						unresolvedPreFlushingSolutionDispenseRate,
						unresolvedConditioningSolutionDispenseRate,
						unresolvedLoadingSampleDispenseRate,
						unresolvedWashingSolutionDispenseRate,
						unresolvedSecondaryWashingSolutionDispenseRate,
						unresolvedTertiaryWashingSolutionDispenseRate,
						unresolvedElutingSolutionDispenseRate
					};
					centrifugeOptions = {
						unresolvedPreFlushingSolutionCentrifugeIntensity,
						unresolvedConditioningSolutionCentrifugeIntensity,
						unresolvedLoadingSampleCentrifugeIntensity,
						unresolvedWashingSolutionCentrifugeIntensity,
						unresolvedSecondaryWashingSolutionCentrifugeIntensity,
						unresolvedTertiaryWashingSolutionCentrifugeIntensity,
						unresolvedElutingSolutionCentrifugeIntensity
					};
					pressureOptions = {
						unresolvedPreFlushingSolutionPressure,
						unresolvedConditioningSolutionPressure,
						unresolvedLoadingSamplePressure,
						unresolvedWashingSolutionPressure,
						unresolvedSecondaryWashingSolutionPressure,
						unresolvedTertiaryWashingSolutionPressure,
						unresolvedElutingSolutionPressure
					};
					injectionOptionsName = {
						PreFlushingSolutionDispenseRate,
						ConditioningSolutionDispenseRate,
						LoadingSampleDispenseRate,
						WashingSolutionDispenseRate,
						SecondaryWashingSolutionDispenseRate,
						TertiaryWashingSolutionDispenseRate,
						ElutingSolutionDispenseRate
					};
					centrifugeOptionsName = {
						PreFlushingSolutionCentrifugeIntensity,
						ConditioningSolutionCentrifugeIntensity,
						LoadingSampleCentrifugeIntensity,
						WashingSolutionCentrifugeIntensity,
						SecondaryWashingSolutionCentrifugeIntensity,
						TertiaryWashingSolutionCentrifugeIntensity,
						ElutingSolutionCentrifugeIntensity
					};
					pressureOptionsName = {
						PreFlushingSolutionPressure,
						ConditioningSolutionPressure,
						LoadingSamplePressure,
						WashingSolutionPressure,
						SecondaryWashingSolutionPressure,
						TertiaryWashingSolutionPressure,
						ElutingSolutionPressure
					};
					existInjectionOptionsQ = AnyTrue[injectionOptions, Not[MatchQ[#, Automatic | Null]]&];
					existCentrifugeOptionsQ = AnyTrue[centrifugeOptions, Not[MatchQ[#, Automatic | Null]]&];
					existPressureOptionsQ = AnyTrue[pressureOptions, Not[MatchQ[#, Automatic | Null]]&];
					(* pull all the options name and value, it case we have to throw error *)
					mobilePhaseOptionsValue = Flatten[{injectionOptions, centrifugeOptions, pressureOptions}];
					mobilePhaseOptionsName = Flatten[{injectionOptionsName, centrifugeOptionsName, pressureOptionsName}];
					conflictingMobilePhaseOptionsIndex = Map[Not[MatchQ[#, Automatic | Null]]&, mobilePhaseOptionsValue];
					(* use blahOptionsQ to infer ExtractionMethod and Instrument *)
					{inferInstrumentFromMethod, inferExtractionMethod, conflictingMethodInferringMobilePhaseOptionsError} = Switch[{existInjectionOptionsQ, existCentrifugeOptionsQ, existPressureOptionsQ},

						{True, False, False},
						{Automatic, Injection, False},

						{False, True, False},
						{Automatic, Centrifuge, False},

						{False, False, True},
						{Automatic, Pressure, False},

						(* this is special case for Biotage that can control both rate and pressure *)
						{True, False, True},
						{Model[Instrument, PressureManifold, "id:zGj91a7mElrL"], Pressure, False},

						(* if nothing is supplied, we don't infer anything *)
						{False, False, False},
						{Automatic, Automatic, False},

						(* other than these possibilities we will check in the conflicting options *)
						_,
						{Automatic, Automatic, True}
					];

					(* get conflicting mobile phase option names *)
					conflictingMobilePhaseOptionName = If[conflictingMethodInferringMobilePhaseOptionsError,
						(
							PickList[mobilePhaseOptionsName, conflictingMobilePhaseOptionsIndex]
						),
						(* give empty list, if the error is off *)
						{}
					];

					(* because we can implied the method, check first if we run into conflict or not *)
					{semiResolvedExtractionMethod, conflictingSuppliedMethodAndImpliedMethodError} = Switch[{unresolvedExtractionMethod, inferExtractionMethod},

						{Automatic | Null, Automatic | Null},
						{Automatic, False},

						(*if the method is supplied and we can infer the method, we have to check if they are confliting or not*)
						{Except[Automatic | Null], Except[Automatic | Null]},
						{
							unresolvedExtractionMethod,
							If[MatchQ[unresolvedExtractionMethod, inferExtractionMethod],
								False,
								True
							]
						},

						{Except[Automatic | Null], Automatic | Null},
						{
							unresolvedExtractionMethod,
							False
						},

						{Automatic | Null, Except[Automatic | Null]},
						{
							inferExtractionMethod,
							False
						}
					];
					(* get conflicting mobile phase option names *)
					conflictingSuppliedMethodAndImpliedMethodErrorOptionName = If[conflictingSuppliedMethodAndImpliedMethodError,
						(
							(* search for the name of that conflicting error, and then mix with ExtractionMethod*)
							{ExtractionMethod, PickList[mobilePhaseOptionsName, conflictingMobilePhaseOptionsIndex]}
						),
						(* give empty list, if the error is off *)
						{}
					];

					unresolvedExtractionCartridgeType = Switch[unresolvedExtractionCartridge,

						ObjectP[Model],
						cacheLookup[simulatedCache, unresolvedExtractionCartridge, Type],

						ObjectP[Object],
						cacheLookup[simulatedCache, cacheLookup[simulatedCache, unresolvedExtractionCartridge, Model], Type],

						Automatic,
						Automatic
					];
					(* check if this SPE cartridge or not, if the supplied cartridge does not have functional group, flip the error on *)
					notSPECartridgeError = Switch[unresolvedExtractionCartridge,

						ObjectReferenceP[Model],
						!MatchQ[cacheLookup[simulatedCache, unresolvedExtractionCartridge, FunctionalGroup], SolidPhaseExtractionFunctionalGroupP],

						ObjectReferenceP[Object],
						!MatchQ[cacheLookup[simulatedCache, unresolvedExtractionCartridge, {Model, FunctionalGroup}], SolidPhaseExtractionFunctionalGroupP],

						Automatic | Null,
						False

					];

					(* resolve buffer master switches *)
					(* The logic is, if user supplied information about buffer in any of mobile phase step, then we assume that they really want to run it even if if conflicts with ExtractionStrategy and each mobile phase master switches. The key option that tells whether the buffer swtich gonna be true or false, is whether the user tell us specific buffer to use in that step *)
					(* we have to check every switch whether it is supplied or not *)
					resolvedPreFlushingSwitch = Switch[{unresolvedPreFlushingSolution, unresolvedPreFlushingSwitch},
						(* if user don't specified the buffer, we just resolve the switch accordingly *)
						{Automatic, _},
						unresolvedPreFlushingSwitch,
						(* if user specified buffer, they definitely gonna run it *)
						{ObjectP[], _},
						True
					];

					resolvedConditioningSwitch = Switch[{unresolvedConditioningSolution, unresolvedConditioningSwitch},
						(* if user don't specified the buffer, we just resolve the switch accordingly *)
						{Automatic, _},
						unresolvedConditioningSwitch,
						(* if user specified buffer, they definitely gonna run it *)
						{ObjectP[], _},
						True
					];

					(* group the options we have specified for the primary, secondary, and tertiary wash; we'll use these way lower down but at this point the purpose is to resolve the Boolean for whether we do the washes at all *)
					(* note that this does NOT include the actual solution *)
					primaryOptions = {
						unresolvedWashingSolution,
						unresolvedWashingSolutionVolume,
						unresolvedWashingSolutionTemperature,
						unresolvedWashingSolutionTemperatureEquilibrationTime,
						unresolvedCollectWashingSolution,
						unresolvedWashingSolutionPressure,
						unresolvedWashingSolutionDispenseRate,
						unresolvedWashingSolutionDrainTime,
						unresolvedWashingSolutionUntilDrained,
						unresolvedMaxWashingSolutionDrainTime,
						unresolvedWashingSolutionLabel,
						unresolvedWashingSolutionCollectionContainer
					};
					secondaryOptions = {
						unresolvedSecondaryWashingSolution,
						unresolvedSecondaryWashingSolutionVolume,
						unresolvedSecondaryWashingSolutionTemperature,
						unresolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
						unresolvedCollectSecondaryWashingSolution,
						unresolvedSecondaryWashingSolutionPressure,
						unresolvedSecondaryWashingSolutionDispenseRate,
						unresolvedSecondaryWashingSolutionDrainTime,
						unresolvedSecondaryWashingSolutionUntilDrained,
						unresolvedMaxSecondaryWashingSolutionDrainTime,
						unresolvedSecondaryWashingSolutionLabel,
						unresolvedSecondaryWashingSolutionCollectionContainer
					};
					tertiaryOptions = {
						unresolvedTertiaryWashingSolution,
						unresolvedTertiaryWashingSolutionVolume,
						unresolvedTertiaryWashingSolutionTemperature,
						unresolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
						unresolvedCollectTertiaryWashingSolution,
						unresolvedTertiaryWashingSolutionPressure,
						unresolvedTertiaryWashingSolutionDispenseRate,
						unresolvedTertiaryWashingSolutionDrainTime,
						unresolvedTertiaryWashingSolutionUntilDrained,
						unresolvedMaxTertiaryWashingSolutionDrainTime,
						unresolvedTertiaryWashingSolutionLabel,
						unresolvedTertiaryWashingSolutionCollectionContainer
					};

					(* resolve the Washing option *)
					resolvedWashingSwitch = Which[
						(* if it was specified, just go with that *)
						BooleanQ[unresolvedWashingSwitch], unresolvedWashingSwitch,
						(* if the user specified any washing options, then we go with True *)
						MemberQ[primaryOptions, Except[Automatic|Null|False|Ambient]], True,
						(* if the user specified the extraction strategy as Positive, resolve to True *)
						MatchQ[unresolvedExtractionStrategy, Positive], True,
						(* otherwise resolve to False *)
						True, False
					];
					warningExtractionStrategyWashingSwitchIncompatible = resolvedWashingSwitch && MatchQ[unresolvedExtractionStrategy, Negative];

					(* resolve the SecondaryWashing option; only do True if the prior step is already True *)
					resolvedSecondaryWashingSwitch = Which[
						(* if it was specified, just go with that *)
						BooleanQ[unresolvedSecondaryWashingSwitch], unresolvedSecondaryWashingSwitch,
						(* if the user specified any secondary washing options, then we go with True *)
						MemberQ[secondaryOptions, Except[Automatic|Null|False|Ambient]], True,
						(* otherwise, resolve to False *)
						True, False
					];
					(* flip an error switch if we resolved to True but Washing is False since you can't do that *)
					skippedWashingError = Not[resolvedWashingSwitch] && resolvedSecondaryWashingSwitch;
					(* flip an error switch if the user specified ExtractionStrategy -> Negative but we're washing *)
					warningExtractionStrategySecondaryWashingSwitchIncompatible = resolvedSecondaryWashingSwitch && MatchQ[unresolvedExtractionStrategy, Negative];

					(* resolve the TertiaryWashing option; only do True if the prior step is already True *)
					resolvedTertiaryWashingSwitch = Which[
						(* if it was specified, just go with that *)
						BooleanQ[unresolvedTertiaryWashingSwitch], unresolvedTertiaryWashingSwitch,
						(* if the user specified any tertiary washing options, then we go with True *)
						MemberQ[tertiaryOptions, Except[Automatic|Null|False|Ambient]], True,
						(* otherwise, resolve to False *)
						True, False
					];
					(* flip an error switch if we resolved to True but Washing is False since you can't do that *)
					skippedSecondaryWashingError = Not[resolvedSecondaryWashingSwitch] && resolvedTertiaryWashingSwitch;
					(* flip an error switch if the user specified ExtractionStrategy -> Negative but we're washing *)
					warningExtractionStrategyTertiaryWashingSwitchIncompatible = resolvedTertiaryWashingSwitch && MatchQ[unresolvedExtractionStrategy, Negative];


					resolvedElutingSwitch = Switch[{unresolvedExtractionStrategy, unresolvedElutingSolution, unresolvedElutingSwitch},
						(* if user don't specified the buffer, we just resolve the switch accordingly *)
						{Positive, Automatic, Automatic},
						True,

						(* if you run positive strategy, surely you want to elute your stuff out, otherwise what's the point *)
						{Positive, Automatic, False},
						warningPositiveStrategyWithoutEluting = True;
						False,

						{Positive, Automatic, True},
						True,

						(* if user specified buffer, they definitely gonna run it *)
						{Positive, ObjectP[], _},
						True,

						{Negative, Automatic, Automatic},
						False,

						{Negative, Automatic, True},
						warningExtractionStrategyElutingIncompatible = True;
						True,

						{Negative, ObjectP[], _},
						warningExtractionStrategyElutingIncompatible = True;
						True,

						(*otherwise*)
						{_, _, _},
						False
					];

					(* If any mobile phases steps after LoadingSample is used, you are definitely in Positive strategy *)
					resolvedExtractionStrategy = If[MemberQ[{resolvedWashingSwitch, resolvedSecondaryWashingSwitch, resolvedTertiaryWashingSwitch, resolvedElutingSwitch}, True],
						Positive,
						Negative
					];
					warningExtractionStrategyChange = If[MatchQ[unresolvedExtractionStrategy, resolvedExtractionStrategy],
						False,
						True
					];

					(* if we run in Negative strategy, definitely want to collect sample flowthrough *)
					semiResolvedCollectLoadingSampleFlowthrough = Switch[{resolvedExtractionStrategy, unresolvedCollectLoadingSampleFlowthrough},

						(* don't overwrite what the user says *)
						{_, Except[Automatic|Null]},
							unresolvedCollectLoadingSampleFlowthrough,

						(* otherwise always collect for Negative and don't for positive *)
						{Negative, Automatic},
							True,
						{Positive, Automatic},
							False
					];

					(* if we run in Positive strategy, definitely want to collect sample flowthrough *)
					{semiResolvedCollectElutingSolution, warningPositiveStrategyWithoutEluting} = Switch[{resolvedExtractionStrategy, unresolvedCollectElutingSolution},

						(* don't overwrite what the user says but do throw a warning if they want this to be False but you're doing Positive*)
						{Positive, False},
							{unresolvedCollectElutingSolution, True},

						(* don't overwrite what the user says *)
						{_, Except[Automatic|Null]},
							{unresolvedCollectElutingSolution, False},

						(* otherwise always don't collect for Negative and collect for Positive *)
						{Negative, _},
							{False, False},

						{Positive, Automatic},
							{True, False}
					];

					(* if user specify container, flip collection switch to true*)
					{
						resolvedCollectPreFlushingSolution,
						resolvedCollectConditioningSolution,
						resolvedCollectWashingSolution,
						resolvedCollectSecondaryWashingSolution,
						resolvedCollectTertiaryWashingSolution,
						resolvedCollectElutingSolution,
						resolvedCollectLoadingSampleFlowthrough
					} = MapThread[
						Which[
							(* always allow what the user says *)
							BooleanQ[#3], #3,
							(* if we run that step and we call for collection container, the collection switch is true*)
							MatchQ[#1, True] && MatchQ[#2, ObjectP[]],
								True,
							(* if we're doing this step but don't have a collection container, then we're False *)
							MatchQ[#1, True] && Not[MatchQ[#2, ObjectP[]]],
								False,
							(* if we're not doing this step then obviously False*)
							MatchQ[#1, False | Null],
								False,
							(*shouldn't get this far, but default to False if we can't figure it out otherwise *)
							True,
								False
						]&,
						{
							{
								resolvedPreFlushingSwitch,
								resolvedConditioningSwitch,
								resolvedWashingSwitch,
								resolvedSecondaryWashingSwitch,
								resolvedTertiaryWashingSwitch,
								resolvedElutingSwitch,
								(* we always load sample *)
								True
							},
							{
								unresolvedPreFlushingSolutionCollectionContainer,
								unresolvedConditioningSolutionCollectionContainer,
								unresolvedWashingSolutionCollectionContainer,
								unresolvedSecondaryWashingSolutionCollectionContainer,
								unresolvedTertiaryWashingSolutionCollectionContainer,
								unresolvedElutingSolutionCollectionContainer,
								unresolvedLoadingSampleFlowthroughContainer
							},
							{
								unresolvedCollectPreFlushingSolution,
								unresolvedCollectConditioningSolution,
								unresolvedCollectWashingSolution,
								unresolvedCollectSecondaryWashingSolution,
								unresolvedCollectTertiaryWashingSolution,
								semiResolvedCollectElutingSolution,
								semiResolvedCollectLoadingSampleFlowthrough
							}
						}
					];

					impliedCollectByContainerOptionName = {
						PreFlushingSolutionCollectionContainer,
						ConditioningSolutionCollectionContainer,
						WashingSolutionCollectionContainer,
						SecondaryWashingSolutionCollectionContainer,
						TertiaryWashingSolutionCollectionContainer,
						ElutingSolutionCollectionContainer,
						LoadingSampleFlowthroughContainer
					};
					impliedCollectByOptionOptionName = {
						CollectPreFlushingSolution,
						CollectConditioningSolution,
						CollectWashingSolution,
						CollectSecondaryWashingSolution,
						CollectTertiaryWashingSolution,
						CollectElutingSolution,
						CollectLoadingSampleFlowthrough
					};
					impliedCollectByContainer = {
						unresolvedPreFlushingSolutionCollectionContainer,
						unresolvedConditioningSolutionCollectionContainer,
						unresolvedWashingSolutionCollectionContainer,
						unresolvedSecondaryWashingSolutionCollectionContainer,
						unresolvedTertiaryWashingSolutionCollectionContainer,
						unresolvedElutingSolutionCollectionContainer,
						unresolvedLoadingSampleFlowthroughContainer
					};
					impliedCollectByOption = {
						unresolvedCollectPreFlushingSolution,
						unresolvedCollectConditioningSolution,
						unresolvedCollectWashingSolution,
						unresolvedCollectSecondaryWashingSolution,
						unresolvedCollectTertiaryWashingSolution,
						semiResolvedCollectElutingSolution,
						semiResolvedCollectLoadingSampleFlowthrough
					};

					(* count the total flowthough that we have to collect *)
					numberOfCollection = Count[{resolvedCollectPreFlushingSolution,
						resolvedCollectConditioningSolution,
						resolvedCollectWashingSolution,
						resolvedCollectSecondaryWashingSolution,
						resolvedCollectTertiaryWashingSolution,
						resolvedCollectElutingSolution,
						resolvedCollectLoadingSampleFlowthrough}, True];

					(* get the instrument model in question *)
					unresolvedInstrumentModel = If[MatchQ[unresolvedInstrument, ObjectP[Object[Instrument]]],
						cacheLookup[simulatedCache, unresolvedInstrument, Model],
						unresolvedInstrument
					];

					(* cartridge, preparation, collection and method will guide us what Instrument we can support *)
					(* TODO I hate this so much *)
					{
						{instrumentModelByCollection, badCollectionOptionName},
						{instrumentModelByCartridge, badCartidgeName},
						{instrumentModelByMethod, badMethodName},
						{instrumentModelByPrepartion, badPreparationName},
						{instrumentModelByInstrument, badInstrumentName}
					} = MapThread[
						If[MatchQ[#2, (Automatic | Null)],
							(* if it cannot be implied by the option, we have to return the whole list of instrument that we can support *)
							{ToList[Lookup[tableExtractionOptions, "Instrument"]], {}},
							possibleInstrument = ToList[Lookup[speGetTableAll[tableExtractionOptions, ToList[#1], ToList[#2]], "Instrument", Null]];
							{possibleInstrument, #3}
						]&,
						{
							{
								"CollectionStep",
								"ExtractionCartridgeType",
								"ExtractionMethod",
								"Preparation",
								"InstrumentPattern"
							},
							{
								numberOfCollection,
								unresolvedExtractionCartridgeType,
								semiResolvedExtractionMethod,
								unresolvedPreparation,
								unresolvedInstrumentModel
							},
							{
								PickList[
									Flatten[{impliedCollectByContainerOptionName, impliedCollectByOptionOptionName}],
									Flatten[{impliedCollectByContainer, impliedCollectByOption}],
									Except[Automatic | Null | False]
								],
								{ExtractionCartridge},
								{ExtractionMethod},
								{Preparation},
								{Instrument}
							}
						}
					];
					(* volume also guide us which instrument to choose and also, it depends on whether to collect the sample or not,
					if you collect, it's not just the instrument that control, it's the collection container *)
					{
						{instrumentModelByVolume, badVolumeOptionName},
						{instrumentModelByPreFlush, badVolumePreFlushName},
						{instrumentModelByCondition, badVolumeConditionName},
						{instrumentModelByWash, badVolumeWashName},
						{instrumentModelBySecWash, badVolumeSecWashName},
						{instrumentModelByTerWash, badVolumeTerWashName},
						{instrumentModelByElute, badVolumeEluteName},
						{instrumentModelByQuantLoad, badVolumeQuantLoadName}
					} = MapThread[
						If[MatchQ[#1, (Automatic | Null)],
							(* if it cannot be implied by the option, we have to return the whole list of instrument that we can support *)
							{ToList[Lookup[tableExtractionOptions, "Instrument"]], {}},
							(
								possibleInstrument = If[MatchQ[#3, False],
									(* if you don't collect, just check the limit of the instrument *)
									ToList[Lookup[speGetTableAll[tableExtractionOptions, ToList["VolumeOfSample"], ToList[#1]], "Instrument", Null]],
									(* if you collect, we have to check with the maximum that collection container can take*)
									ToList[Lookup[speGetTableAll[tableExtractionOptions, ToList["MaxVolumeIfCollect"], ToList[#1]], "Instrument", Null]]
								];
								{possibleInstrument, #2}
							)
						]&,
						{
							{
								resolvedPooledLoadingSampleVolume,
								unresolvedPreFlushingSolutionVolume,
								unresolvedConditioningSolutionVolume,
								unresolvedWashingSolutionVolume,
								unresolvedSecondaryWashingSolutionVolume,
								unresolvedTertiaryWashingSolutionVolume,
								unresolvedElutingSolutionVolume,
								pooledUnresolvedQuantitativeLoadingSampleVolume
							},
							{
								{LoadingSampleVolume},
								{PreFlushingSolutionVolume},
								{ConditioningSolutionVolume},
								{WashingSolutionVolume},
								{SecondaryWashingSolutionVolume},
								{TertiaryWashingSolutionVolume},
								{ElutingSolutionVolume},
								{QuantitativeLoadingSampleVolume}
							},
							{
								resolvedCollectLoadingSampleFlowthrough,
								resolvedCollectPreFlushingSolution,
								resolvedCollectConditioningSolution,
								resolvedCollectWashingSolution,
								resolvedCollectSecondaryWashingSolution,
								resolvedCollectTertiaryWashingSolution,
								resolvedCollectElutingSolution,
								(* never collect rinse and reload *)
								False
							}
						}
					];

					(* throw error if we cannot find supporting instrument *)
					{speCannotSupportVolumeError, badLoadingSampleVolume} = If[MatchQ[instrumentModelByVolume, {Null} | Null],
						{True, resolvedLoadingSampleVolume},
						{False, {}}
					];
					speCannotSupportCollectionError = If[MatchQ[instrumentModelByCollection, {Null} | Null],
						True,
						False
					];
					speCannotSupportCartridgeError = If[MatchQ[instrumentModelByCartridge, {Null} | Null],
						True,
						False
					];
					speCannotSupportMethodError = If[MatchQ[instrumentModelByMethod, {Null} | Null],
						True,
						False
					];
					speCannotSupportInstrumentError = If[MatchQ[instrumentModelByInstrument, {Null} | Null],
						True, False
					];

					impliedCollectionNameError = If[MatchQ[speCannotSupportCollectionError, True],
						{
							PickList[impliedCollectByContainerOptionName, impliedCollection],
							PickList[impliedCollectByOptionOptionName, impliedCollection]
						},
						{}
					];
					{
						speCannotSupportPreFlushVolume,
						speCannotSupportConditionVolume,
						speCannotSupportWashVolume,
						speCannotSupportSecondaryWashVolume,
						speCannotSupportTertiaryWashVolume,
						speCannotSupportEluteVolume,
						speCannotSupportQuantVolume,
						speCannotSupportVolumeError
					} = Map[If[MatchQ[#1, {Null} | Null], True, False]&,
						{
							instrumentModelByPreFlush,
							instrumentModelByCondition,
							instrumentModelByWash,
							instrumentModelBySecWash,
							instrumentModelByTerWash,
							instrumentModelByElute,
							instrumentModelByQuantLoad,
							instrumentModelByVolume
						}
					];

					(* with all the mobile phase and collection plates, we give a list of compatible instrument, and then find the best instrument*)
					suggestedInstrument = UnsortedIntersection[
						instrumentModelByCollection,
						instrumentModelByPrepartion,
						instrumentModelByVolume,
						instrumentModelByCartridge,
						instrumentModelByMethod,
						instrumentModelByPreFlush,
						instrumentModelByCondition,
						instrumentModelByWash,
						instrumentModelBySecWash,
						instrumentModelByTerWash,
						instrumentModelByElute,
						instrumentModelByQuantLoad,
						instrumentModelByInstrument
					];

					(* if we cannot find the best instrument for the user, we issue an error and then use gilson to force the function to run through *)
					{noCompatibleInstrumentError, suggestInstrumentList} = If[MatchQ[suggestedInstrument, {}],
						{True, {Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]}},
						{False, suggestedInstrument}
					];

					(* also we have to list all the bad option name here, and tell user that one of them cause error if we cannot find instrument for them *)
					noCompatibleInstrumentErrorName = If[MatchQ[noCompatibleInstrumentError, True],
						DeleteDuplicates[Flatten[{
							badCollectionOptionName,
							badPreparationName,
							badVolumeOptionName,
							badCartidgeName,
							badMethodName,
							badVolumePreFlushName,
							badVolumeConditionName,
							badVolumeWashName,
							badVolumeSecWashName,
							badVolumeTerWashName,
							badVolumeEluteName,
							badVolumeQuantLoadName,
							badInstrumentName
						}]],
						{}
					];

					(* with all these extraction method and extraction mobile phase options, we can finally find the best instrument, in case it's not given*)
					(* TODO we have to add extracion temperature too, but right now all instrument are room temp, except centrifuge *)
					determinedByInstrumentSuggestion = DeleteDuplicates[Flatten[
						Map[
							speGetTableAll[tableExtractionOptions, {"InstrumentPattern"}, {#}]&,
							Flatten[suggestInstrumentList]
						]
					]];
					(* if the instrument is automatic, or the supplied instrument does not fit with SPE, we just pick the default one*)
					resolvedInstrument = If[MatchQ[unresolvedInstrument, Automatic] || speCannotSupportInstrumentError == True,
						First[Lookup[determinedByInstrumentSuggestion, "Instrument"]],
						unresolvedInstrument
					];

					(* get instrument model, so that we can use it for further option resolution *)
					resolvedInstrumentModel = If[MatchQ[resolvedInstrument, ObjectReferenceP[Object]],
						Experiment`Private`cacheLookup[simulatedCache, resolvedInstrument, Model],
						resolvedInstrument
					];

					(* once we know the instrument, we can get the type of cartridge and the method that would fit *)
					determinedByInstrument = speGetTableFirstRow[tableExtractionOptions, {"Instrument"}, {resolvedInstrumentModel}];
					{resolvedExtractionMethod, resolvedExtractionCartridgeType} = Flatten[Lookup[determinedByInstrument, {"ExtractionMethod", "ExtractionCartridgeType"}]];

					(* check if the resolved instrument, method, and cartridge is permitted by volume or not *)
					(*					volumeCheck = speGetTableFirstRow[tableExtractionOptions,*)
					(*						{"InstrumentPattern", "ExtractionMethod", "ExtractionCartridgeTypePattern", "VolumeOfSample"},*)
					(*						{resolvedInstrument, resolvedExtractionMethod, resolvedExtractionCartridgeType, resolvedPooledLoadingSampleVolume}];*)
					(*					warningVolumeTooHigh = If[MatchQ[volumeCheck, {}],*)
					(*						True,*)
					(*						False*)
					(*					];*)

					(* resolve reparation options - based on instrument *)
					resolvedPreparation = Sequence @@ Lookup[speGetTableFirstRow[tableExtractionOptions, "Instrument", resolvedInstrumentModel], "Preparation"];

					(* --3-- once we know the type of ExtractionCartridge we will find the correct functional group and fully resolve ExtractionCartridge *)
					unresolvedExtractionCartridgeModel = If[MatchQ[unresolvedExtractionCartridge, ObjectReferenceP[Object]],
						(* if it's an object, get a model *)
						cacheLookup[simulatedCache, unresolvedExtractionCartridge, Model],
						(* otherwise just leave it as is*)
						unresolvedExtractionCartridge
					];

					(* list all the volume that we have, we will use this guide the size of cartridge to use*)
					anySuppliedVolume = {
						unresolvedPreFlushingSolutionVolume,
						unresolvedConditioningSolutionVolume,
						unresolvedWashingSolutionVolume,
						unresolvedSecondaryWashingSolutionVolume,
						unresolvedTertiaryWashingSolutionVolume,
						unresolvedElutingSolutionVolume,
						resolvedPooledLoadingSampleVolume
					};

					{resolvedExtractionCartridge, resolvedExtractionSorbent, resolvedExtractionMode} = Flatten[Switch[{unresolvedExtractionCartridgeModel, unresolvedExtractionSorbent, unresolvedExtractionMode},
						(* if the Model of Cartridge is specified, Sorbent will be define by the cartridge, how ever it could run in any mode the user want. So if it is mode is Automatic, just use whatever defined in the cartridge field *)
						{ObjectP[Model], _, Automatic},
							Module[{cartridgePacket, cartridgeMaxVolume},
								cartridgePacket = fetchPacketFromCache[unresolvedExtractionCartridgeModel, simulatedCache];
								cartridgeMaxVolume = Lookup[cartridgePacket, MaxVolume];
								(* we have to check if we can support the size or not *)
								tooBigCartridgeError = Switch[resolvedInstrumentModel,
									(* for gilson, we can only fit 3 ml cartridge *)
									ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]],
									MatchQ[cartridgeMaxVolume, GreaterP[3. Milliliter]],
									(* Biotage, the biggest cartridge is 6 mL *)
									ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]],
									MatchQ[cartridgeMaxVolume, GreaterP[6. Milliliter]],
									(* other instruemtent, there is no limit on size *)
									_,
									False
								];
								{unresolvedExtractionCartridge, Lookup[cartridgePacket, FunctionalGroup], Lookup[cartridgePacket, SeparationMode]}
							],

						(* if the sorbent is defined, we find the best fit cartridge*)
						{Automatic, SolidPhaseExtractionFunctionalGroupP, Automatic},
							Module[{defaultcartridgePacket, bestCartridgePacket, cartridgePacket},
								cartridgePacket = Cases[simulatedCache, KeyValuePattern[{FunctionalGroup -> unresolvedExtractionSorbent, Type -> resolvedExtractionCartridgeType}]];
								{cannotFindCartridgeWithSuppliedError, defaultcartridgePacket} = If[MatchQ[cartridgePacket, {}],
									{True, Cases[simulatedCache, KeyValuePattern[{FunctionalGroup -> 18, Type -> resolvedExtractionCartridgeType}]]},
									{False, cartridgePacket}
								];
								bestCartridgePacket = Switch[resolvedInstrumentModel,
									(* we can only fit 3 ml cartridge for now on GX271*)
									ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]],
									FirstCase[defaultcartridgePacket, KeyValuePattern[{MaxVolume -> 3. Milliliter}]],
									(* for Biotage, we will check the largest supply volume and go for that size *)
									ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]],
									(* choose the cartridge that can fit the volume *)
									If[MemberQ[anySuppliedVolume, GreaterP[3 Milliliter]&],
										FirstCase[defaultcartridgePacket, KeyValuePattern[{MaxVolume -> 6. Milliliter}]],
										FirstCase[defaultcartridgePacket, KeyValuePattern[{MaxVolume -> 3. Milliliter}]]
									],
									(* other instrument, just pick one *)
									_,
									First[defaultcartridgePacket]
								];
								{Lookup[bestCartridgePacket, Object], Lookup[bestCartridgePacket, FunctionalGroup], Lookup[bestCartridgePacket, SeparationMode]}
							],

						(* in case the user, we will just follow what user says *)
						(* TODO there should be a courtesy check if the mode and the sorbent make sense of not *)
						{ObjectP[Model], _, SeparationModeP},
							Module[{cartridgePacket, cartridgeMaxVolume},
								cartridgePacket = fetchPacketFromCache[unresolvedExtractionCartridgeModel, simulatedCache];
								cartridgeMaxVolume = Lookup[cartridgePacket, MaxVolume];
								tooBigCartridgeError = Switch[resolvedInstrumentModel,
									(* for gilson, we can only fit 3 ml cartridge *)
									ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]],
									MatchQ[cartridgeMaxVolume, GreaterP[3. Milliliter]],
									(* Biotage, the biggest cartridge is 6 mL *)
									ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]],
									MatchQ[cartridgeMaxVolume, GreaterP[6. Milliliter]],
									(* other instruemtent, there is no limit on size *)
									_,
									False
								];
								{unresolvedExtractionCartridge, Lookup[cartridgePacket, FunctionalGroup], unresolvedExtractionMode}
							],

						(* if only separation mode is defined, then we just pick the default sorbent *)
						{Automatic, Automatic, SeparationModeP},
							Module[{bestExtractionSorbent, cartridgePacket, bestCartridgePacket},
								bestExtractionSorbent = Lookup[tablePreferredExtractionSorbent, unresolvedExtractionMode];
								cartridgePacket = Cases[simulatedCache, KeyValuePattern[{FunctionalGroup -> bestExtractionSorbent, Type -> resolvedExtractionCartridgeType}]];
								(* this is to make sure that if there are more than one cartridge that fit the criteria, then we have to make a preference in term of cartridge size *)
								bestCartridgePacket = Switch[resolvedInstrumentModel,
									(* we can only fit 3 ml cartridge for now on GX271*)
									ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]],
									FirstCase[cartridgePacket, KeyValuePattern[{MaxVolume -> 3. Milliliter}]],
									(* for Biotage, we will check the largest supply volume and go for that size *)
									ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]],
									(*chosse the cartridge that can fit the volume *)
									If[AnyTrue[anySuppliedVolume, # > 3 Milliliter&],
										FirstCase[cartridgePacket, KeyValuePattern[{MaxVolume -> 6. Milliliter}]],
										FirstCase[cartridgePacket, KeyValuePattern[{MaxVolume -> 3. Milliliter}]]
									],
									(* other instrument, just pick one *)
									_,
									First[cartridgePacket]
								];
								{Lookup[bestCartridgePacket, Object], Lookup[bestCartridgePacket, FunctionalGroup], Lookup[bestCartridgePacket, SeparationMode]}
							],

						{Automatic, Automatic, Automatic},
						(* TODO - we should be able to guess this base on the solvent of sample *)
							Module[
								{semiResolvedExtractionSorbent, cartridgePacket, bestCartridgePacket},

								(* if sorbent is not given, assume that we will run C18 (unless we're on robot because we don't have any robotic C18 plates now) *)
								semiResolvedExtractionSorbent = Which[
									MatchQ[resolvedPreparation, Manual] && MatchQ[unresolvedExtractionSorbent, Automatic], C18,
									MatchQ[unresolvedExtractionSorbent, Automatic], Automatic,
									True, unresolvedExtractionSorbent
								];

								cartridgePacket = Cases[
									simulatedCache,
									KeyValuePattern[{
										FunctionalGroup -> If[MatchQ[semiResolvedExtractionSorbent, Automatic], Except[Null], semiResolvedExtractionSorbent],
										Type -> resolvedExtractionCartridgeType,
										If[MatchQ[resolvedPreparation, Robotic], LiquidHandlerPrefix -> Except[Null], Nothing],
										SeparationMode -> If[MatchQ[unresolvedExtractionMode, Automatic], Except[Null], unresolvedExtractionMode]
									}]
								];
								(* this is to make sure that if there are more than one cartridge that fit the criteria, try to pick the one with max volume *)
								bestCartridgePacket = Switch[resolvedInstrumentModel,
									(* we can only fit 3 ml cartridge for now on GX271*)
									ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]],
										FirstCase[cartridgePacket, KeyValuePattern[{MaxVolume -> 3. Milliliter}]],
									(* for Biotage, we will check the largest supply volume and go for that size *)
									ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]],
										(* choose the cartridge that can fit the volume *)
										If[MemberQ[anySuppliedVolume, GreaterP[3 Milliliter]&],
											FirstCase[cartridgePacket, KeyValuePattern[{MaxVolume -> 6. Milliliter}]],
											FirstCase[cartridgePacket, KeyValuePattern[{MaxVolume -> 3. Milliliter}]]
										],
									(* other instrument, just pick one *)
									_,
										FirstOrDefault[cartridgePacket]
								];

								{Lookup[bestCartridgePacket, Object], Lookup[bestCartridgePacket, FunctionalGroup], Lookup[bestCartridgePacket, SeparationMode]}
							]



					]];

					(* conflict options tracking *)
					conflictingCartridgeSorbentWarning = If[Not[MatchQ[unresolvedExtractionSorbent, resolvedExtractionSorbent | Automatic]],
						True,
						False
					];

					(* --5-- Buffer selection for each mobile phase step *)
					(* special case for ion exchange *)
					actualRunningMode = If[MatchQ[resolvedExtractionMode, IonExchange],
						(* because ion exchnage can be either cationic or anionic, we resolve preset buffer based on sorbent instead *)
						First[Keys[Select[tableIonExchangeDefinition, MemberQ[#, resolvedExtractionSorbent] &]],Null],
						resolvedExtractionMode
					];

					resolvedPreFlushingSolution = Switch[{resolvedPreFlushingSwitch, unresolvedPreFlushingSolution},
						(* If use this step but the actual buffer is not specified, look up in out basic buffer definition *)
						{True, Automatic},
							Lookup[Lookup[tableDefaultSolutionDefinition, actualRunningMode], PreFlushing],

						{True, ObjectP[]},
							unresolvedPreFlushingSolution,

						{False, _},
						Null
					];

					resolvedConditioningSolution = Switch[{resolvedConditioningSwitch, unresolvedConditioningSolution},
						(* If use this step but the actual buffer is not specified, look up in out basic buffer definition *)
						{True, Automatic},
						Lookup[Lookup[tableDefaultSolutionDefinition, actualRunningMode], Conditioning],

						{True, ObjectP[]},
						unresolvedConditioningSolution,

						{False, _},
						Null
					];

					resolvedWashingSolution = Switch[{resolvedWashingSwitch, unresolvedWashingSolution},
						(* If use this step but the actual buffer is not specified, look up in out basic buffer definition *)
						{True, Automatic},
						Lookup[Lookup[tableDefaultSolutionDefinition, actualRunningMode], Washing],

						{True, ObjectP[]},
						unresolvedWashingSolution,

						{False, _},
						Null
					];

					resolvedSecondaryWashingSolution = Switch[{resolvedSecondaryWashingSwitch, unresolvedSecondaryWashingSolution},
						(* If use this step but the actual buffer is not specified, just use the same buffer as washing step *)
						{True, Automatic},
						resolvedWashingSolution,

						{True, ObjectP[]},
						unresolvedSecondaryWashingSolution,

						{False, _},
						Null
					];

					resolvedTertiaryWashingSolution = Switch[{resolvedTertiaryWashingSwitch, unresolvedTertiaryWashingSolution},
						(* If use this step but the actual buffer is not specified, just use the same buffer as washing step *)
						{True, Automatic},
						resolvedWashingSolution,

						{True, ObjectP[]},
						unresolvedTertiaryWashingSolution,

						{False, _},
						Null
					];

					resolvedElutingSolution = Switch[{resolvedElutingSwitch, unresolvedElutingSolution},
						(* If use this step but the actual buffer is not specified, look up in out basic buffer definition *)
						{True, Automatic},
						Lookup[Lookup[tableDefaultSolutionDefinition, actualRunningMode], Eluting],

						{True, ObjectP[]},
						unresolvedElutingSolution,

						{False, _},
						Null
					];

					(* --6-- resolve of all the untildrained swtich *)
					{
						resolvedPreFlushingSolutionUntilDrained,
						resolvedConditioningSolutionUntilDrained,
						resolvedWashingSolutionUntilDrained,
						resolvedSecondaryWashingSolutionUntilDrained,
						resolvedTertiaryWashingSolutionUntilDrained,
						resolvedElutingSolutionUntilDrained,
						resolvedLoadingSampleUntilDrained
					} = MapThread[
						Switch[{resolvedExtractionMethod, #1, #2},
							(* any method, that we cannot guarantee the flow from a true rate control, we have to flip untildrained on*)
							{Alternatives[Gravity, Pressure, Vacuum, Centrifuge], True, Automatic | Null},
							True,

							{Alternatives[Gravity, Pressure, Vacuum, Centrifuge], True, BooleanP},
							#2,

							(* otherwise set to False*)
							{_, True, _},
							False,

							(* if that step is not used then set it to Null *)
							{_, False, _},
							Null
						]&,
						{
							{
								resolvedPreFlushingSwitch,
								resolvedConditioningSwitch,
								resolvedWashingSwitch,
								resolvedSecondaryWashingSwitch,
								resolvedTertiaryWashingSwitch,
								resolvedElutingSwitch,
								(* you always load sample in SPE*)
								True
							},
							{unresolvedPreFlushingSolutionUntilDrained,
								unresolvedConditioningSolutionUntilDrained,
								unresolvedWashingSolutionUntilDrained,
								unresolvedSecondaryWashingSolutionUntilDrained,
								unresolvedTertiaryWashingSolutionUntilDrained,
								unresolvedElutingSolutionUntilDrained,
								unresolvedLoadingSampleUntilDrained
							}
						}
					];

					(* --7-- Now we will fill all buffer related parameters *EXCEPT* centrifuge -> we have to call experiment centrifuge for that *)
					resolvedExtractionCartridgeModel = If[MatchQ[resolvedExtractionCartridge, ObjectP[Object]],
						Download[resolvedExtractionCartridge, Model[Object]],
						resolvedExtractionCartridge
					];
					resolvedInstrumentModel = If[MatchQ[resolvedInstrument, ObjectP[Object]],
						Download[resolvedInstrument, Model[Object]],
						resolvedInstrument
					];

					(* PreFlushing *)
					{
						resolvedPreFlushingSolutionVolume,
						resolvedPreFlushingSolutionTemperatureEquilibrationTime,
						resolvedPreFlushingSolutionPressure,
						resolvedPreFlushingSolutionDispenseRate,
						resolvedPreFlushingSolutionDrainTime,
						resolvedMaxPreFlushingSolutionDrainTime,
						resolvedPreFlushingSolutionTemperature,
						resolvedPreFlushingSolutionLabel,
						errorPreFlushingPressureTooLow,
						errorPreFlushingPressureTooHigh,
						errorPreFlushingDispenseRateTooLow,
						errorPreFlushingDispenseRateTooHigh,
						warningPreFlushingPressureMustBeBoolean,
						errorPreFlushingVolumeInstrument,
						errorPreFlushingInstrumentSolutionTemperature
					} = speSolutionResolver[simulatedCache, tableExtractionOptions, resolvedExtractionCartridgeModel, resolvedInstrumentModel, resolvedExtractionMethod,
						resolvedPreFlushingSwitch, unresolvedPreFlushingSolutionVolume,
						unresolvedPreFlushingSolutionTemperature, unresolvedPreFlushingSolutionTemperatureEquilibrationTime,
						resolvedCollectPreFlushingSolution,
						unresolvedPreFlushingSolutionPressure, unresolvedPreFlushingSolutionDispenseRate,
						unresolvedPreFlushingSolutionDrainTime, resolvedPreFlushingSolutionUntilDrained, unresolvedMaxPreFlushingSolutionDrainTime,
						unresolvedPreFlushingSolutionLabel, resolvedPreparation, resolvedPreFlushingSolution
					];
					(* Conditioning *)
					{
						resolvedConditioningSolutionVolume,
						resolvedConditioningSolutionTemperatureEquilibrationTime,
						resolvedConditioningSolutionPressure,
						resolvedConditioningSolutionDispenseRate,
						resolvedConditioningSolutionDrainTime,
						resolvedMaxConditioningSolutionDrainTime,
						resolvedConditioningSolutionTemperature,
						resolvedConditioningSolutionLabel,
						errorConditioningPressureTooLow,
						errorConditioningPressureTooHigh,
						errorConditioningDispenseRateTooLow,
						errorConditioningDispenseRateTooHigh,
						warningConditioningPressureMustBeBoolean,
						errorConditioningVolumeInstrument,
						errorConditioningInstrumentSolutionTemperature
					} = speSolutionResolver[simulatedCache, tableExtractionOptions, resolvedExtractionCartridgeModel, resolvedInstrumentModel, resolvedExtractionMethod,
						resolvedConditioningSwitch, unresolvedConditioningSolutionVolume,
						unresolvedConditioningSolutionTemperature, unresolvedConditioningSolutionTemperatureEquilibrationTime,
						resolvedCollectConditioningSolution,
						unresolvedConditioningSolutionPressure, unresolvedConditioningSolutionDispenseRate,
						unresolvedConditioningSolutionDrainTime, resolvedConditioningSolutionUntilDrained, unresolvedMaxConditioningSolutionDrainTime,
						unresolvedConditioningSolutionLabel, resolvedPreparation, resolvedConditioningSolution
					];
					(* Washing *)
					{
						resolvedWashingSolutionVolume,
						resolvedWashingSolutionTemperatureEquilibrationTime,
						resolvedWashingSolutionPressure,
						resolvedWashingSolutionDispenseRate,
						resolvedWashingSolutionDrainTime,
						resolvedMaxWashingSolutionDrainTime,
						resolvedWashingSolutionTemperature,
						resolvedWashingSolutionLabel,
						errorWashingPressureTooLow,
						errorWashingPressureTooHigh,
						errorWashingDispenseRateTooLow,
						errorWashingDispenseRateTooHigh,
						warningWashingPressureMustBeBoolean,
						errorWashingVolumeInstrument,
						errorWashingInstrumentSolutionTemperature
					} = speSolutionResolver[simulatedCache, tableExtractionOptions, resolvedExtractionCartridgeModel, resolvedInstrumentModel, resolvedExtractionMethod,
						resolvedWashingSwitch, unresolvedWashingSolutionVolume,
						unresolvedWashingSolutionTemperature, unresolvedWashingSolutionTemperatureEquilibrationTime,
						resolvedCollectWashingSolution,
						unresolvedWashingSolutionPressure, unresolvedWashingSolutionDispenseRate,
						unresolvedWashingSolutionDrainTime, resolvedWashingSolutionUntilDrained, unresolvedMaxWashingSolutionDrainTime,
						unresolvedWashingSolutionLabel, resolvedPreparation, resolvedWashingSolution
					];
					(* ELuting *)
					{
						resolvedElutingSolutionVolume,
						resolvedElutingSolutionTemperatureEquilibrationTime,
						resolvedElutingSolutionPressure,
						resolvedElutingSolutionDispenseRate,
						resolvedElutingSolutionDrainTime,
						resolvedMaxElutingSolutionDrainTime,
						resolvedElutingSolutionTemperature,
						resolvedElutingSolutionLabel,
						errorElutingPressureTooLow,
						errorElutingPressureTooHigh,
						errorElutingDispenseRateTooLow,
						errorElutingDispenseRateTooHigh,
						warningElutingPressureMustBeBoolean,
						errorElutingVolumeInstrument,
						errorElutingInstrumentSolutionTemperature
					} = speSolutionResolver[simulatedCache, tableExtractionOptions, resolvedExtractionCartridgeModel, resolvedInstrumentModel, resolvedExtractionMethod,
						resolvedElutingSwitch, unresolvedElutingSolutionVolume,
						unresolvedElutingSolutionTemperature, unresolvedElutingSolutionTemperatureEquilibrationTime,
						resolvedCollectElutingSolution,
						unresolvedElutingSolutionPressure, unresolvedElutingSolutionDispenseRate,
						unresolvedElutingSolutionDrainTime, resolvedElutingSolutionUntilDrained, unresolvedMaxElutingSolutionDrainTime,
						unresolvedElutingSolutionLabel, resolvedPreparation, resolvedElutingSolution
					];
					(* --8-- for secondary and tertiary washing, we should set it according to the wash if no other info is given *)
					(* REDUNDANT -> probably will need to write a subfunction of this at some point *)
					(* change anything 'automatic' inside secondary option to exact same thing as washing then resolve it *)

					(* replace all automatic with value from primary wash options *)
					{
						copiedSecondaryWashingSolution,
						copiedSecondaryWashingSolutionVolume,
						copiedSecondaryWashingSolutionTemperature,
						copiedSecondaryWashingSolutionTemperatureEquilibrationTime,
						copiedCollectSecondaryWashingSolution,
						copiedSecondaryWashingSolutionPressure,
						copiedSecondaryWashingSolutionDispenseRate,
						copiedSecondaryWashingSolutionDrainTime,
						copiedSecondaryWashingSolutionUntilDrained,
						copiedMaxSecondaryWashingSolutionDrainTime,
						copiedSecondaryWashingSolutionLabel,
						copiedSecondaryWashingSolutionCollectionContainer
					} = MapThread[ReplaceAll[#1, Automatic -> #2]&, {secondaryOptions, primaryOptions}];
					{
						copiedTertiaryWashingSolution,
						copiedTertiaryWashingSolutionVolume,
						copiedTertiaryWashingSolutionTemperature,
						copiedTertiaryWashingSolutionTemperatureEquilibrationTime,
						copiedCollectTertiaryWashingSolution,
						copiedTertiaryWashingSolutionPressure,
						copiedTertiaryWashingSolutionDispenseRate,
						copiedTertiaryWashingSolutionDrainTime,
						copiedTertiaryWashingSolutionUntilDrained,
						copiedMaxTertiaryWashingSolutionDrainTime,
						copiedTertiaryWashingSolutionLabel,
						copiedTertiaryWashingSolutionCollectionContainer
					} = MapThread[ReplaceAll[#1, Automatic -> #2]&, {tertiaryOptions, primaryOptions}];

					(* pass to speSolutionResolver as usual *)
					{
						resolvedSecondaryWashingSolutionVolume,
						resolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
						resolvedSecondaryWashingSolutionPressure,
						resolvedSecondaryWashingSolutionDispenseRate,
						resolvedSecondaryWashingSolutionDrainTime,
						resolvedMaxSecondaryWashingSolutionDrainTime,
						resolvedSecondaryWashingSolutionTemperature,
						resolvedSecondaryWashingSolutionLabel,
						errorSecondaryWashingPressureTooLow,
						errorSecondaryWashingPressureTooHigh,
						errorSecondaryWashingDispenseRateTooLow,
						errorSecondaryWashingDispenseRateTooHigh,
						warningSecondaryWashingPressureMustBeBoolean,
						errorSecondaryWashingVolumeInstrument,
						errorSecondaryWashingInstrumentSolutionTemperature
					} = speSolutionResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedExtractionCartridgeModel,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedSecondaryWashingSwitch,
						copiedSecondaryWashingSolutionVolume,
						copiedSecondaryWashingSolutionTemperature,
						copiedSecondaryWashingSolutionTemperatureEquilibrationTime,
						copiedCollectSecondaryWashingSolution,
						copiedSecondaryWashingSolutionPressure,
						copiedSecondaryWashingSolutionDispenseRate,
						copiedSecondaryWashingSolutionDrainTime,
						copiedSecondaryWashingSolutionUntilDrained,
						copiedMaxSecondaryWashingSolutionDrainTime,
						copiedSecondaryWashingSolutionLabel,
						resolvedPreparation,
						resolvedSecondaryWashingSolution
					];

					{
						resolvedTertiaryWashingSolutionVolume,
						resolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
						resolvedTertiaryWashingSolutionPressure,
						resolvedTertiaryWashingSolutionDispenseRate,
						resolvedTertiaryWashingSolutionDrainTime,
						resolvedMaxTertiaryWashingSolutionDrainTime,
						resolvedTertiaryWashingSolutionTemperature,
						resolvedTertiaryWashingSolutionLabel,
						errorTertiaryWashingPressureTooLow,
						errorTertiaryWashingPressureTooHigh,
						errorTertiaryWashingDispenseRateTooLow,
						errorTertiaryWashingDispenseRateTooHigh,
						warningTertiaryWashingPressureMustBeBoolean,
						errorTertiaryWashingVolumeInstrument,
						errorTertiaryWashingInstrumentSolutionTemperature
					} = speSolutionResolver[simulatedCache, tableExtractionOptions, resolvedExtractionCartridgeModel, resolvedInstrumentModel, resolvedExtractionMethod,
						resolvedTertiaryWashingSwitch, copiedTertiaryWashingSolutionVolume,
						copiedTertiaryWashingSolutionTemperature, copiedTertiaryWashingSolutionTemperatureEquilibrationTime,
						copiedCollectTertiaryWashingSolution,
						copiedTertiaryWashingSolutionPressure, copiedTertiaryWashingSolutionDispenseRate,
						copiedTertiaryWashingSolutionDrainTime, copiedTertiaryWashingSolutionUntilDrained, copiedMaxTertiaryWashingSolutionDrainTime,
						copiedTertiaryWashingSolutionLabel, resolvedPreparation, resolvedTertiaryWashingSolution
					];

					(* --9-- resolve for extraction temperature -> this is mainly for instrument temperature setup *)
					(* convert all expression option to numerical value *)
					semiResolvedExtractionTemperature = unresolvedExtractionTemperature /. Ambient -> $AmbientTemperature;
					(* this is instrument specific now, so check the instrument temperature limit first *)

					{minInstrumentTemp, maxInstrumentTemp} = Lookup[fetchPacketFromCache[resolvedInstrumentModel, simulatedCache], {MinTemperature, MaxTemperature}];
					instrumentAmbientOnly = If[
						MatchQ[{minInstrumentTemp, maxInstrumentTemp}, {Null, Null}],
						True,
						False
					];
					considerAmbientExtraction = If[MatchQ[semiResolvedExtractionTemperature, RangeP[22 Celsius, 25 Celsius]],
						True,
						False
					];
					resolvedExtractionTemperature = Switch[{instrumentAmbientOnly, considerAmbientExtraction},

						(* if the instrument is ambient only, and the requested temperature is considered ambient -> leave it *)
						{True, True},
						semiResolvedExtractionTemperature,

						(* if you request temperature control, on instrument that cannot control temperature, then trigger warning. and then return ambient temperature still *)
						{True, False},
						errorAmbientOnlyInstrument = True;
						$AmbientTemperature,

						(* if this instrument can control temperature then, return the value of extraction temperature, considering instrument limit *)
						{False, _},
						Which[

							MatchQ[semiResolvedExtractionTemperature, LessP[minInstrumentTemp]],
							errorExtractionTemperatureTooLow = True;
							semiResolvedExtractionTemperature,

							MatchQ[semiResolvedExtractionTemperature, GreaterP[maxInstrumentTemp]],
							errorExtractionTemperatureTooHigh = True;
							semiResolvedExtractionTemperature,

							True,
							semiResolvedExtractionTemperature
						]
					];

					(* --10-- now resolve for quantitative loading sample and sample temperature manipulation first *)
					(* these are all pool options *)
					(* we have to expand to poolsize for all options related to Quantitative loading sample first *)
					{expandedQuantitativeLoadingSample,
						expandedQuantitativeLoadingSampleSolution,
						expandedQuantitativeLoadingSampleVolume,
						expandedLoadingSampleTemperature,
						expandedLoadingSampleTemperatureEquilibrationTime} = Map[

						Switch[Length[#],

							EqualP[1],
							Flatten[ConstantArray[#, poolsize]],

							EqualP[poolsize],
							Flatten[#],

							RangeP[2, poolsize - 1],
							Flatten[ConstantArray[Null, poolsize]],

							GreaterP[poolsize],
							Flatten[Take[#, poolsize]]
						]&, {ToList[unresolvedQuantitativeLoadingSample],
							ToList[unresolvedQuantitativeLoadingSampleSolution],
							ToList[unresolvedQuantitativeLoadingSampleVolume],
							ToList[unresolvedLoadingSampleTemperature],
							ToList[unresolvedLoadingSampleTemperatureEquilibrationTime]}
					];
					(* set error switch on, when the length is wrong *)
					{unequalLengthQuantitativeLoadingSampleError,
						unequalLengthQuantitativeLoadingSampleSolutionError,
						unequalLengthQuantitativeLoadingSampleVolumeError,
						unequalLengthLoadingSampleTemperatureError,
						unequalLengthLoadingSampleTemperatureEquilibrationTimeError} = Map[
						If[AllTrue[#, NullQ], True, False]&,
						{expandedQuantitativeLoadingSample,
							expandedQuantitativeLoadingSampleSolution,
							expandedQuantitativeLoadingSampleVolume,
							expandedLoadingSampleTemperature,
							expandedLoadingSampleTemperatureEquilibrationTime
						}
					];
					(* --10.1-- finish the quantitative loading parameter first *)
					(* a switch to allow which  equipment can perform quantitative loading sample *)
					enableQuantitativeLoadingSample = Switch[resolvedInstrumentModel,
						Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], True,
						Model[Instrument, Centrifuge, "id:eGakldJEz14E"], False,
						Model[Instrument, FilterBlock, "id:rea9jl1orrGr"], False,
						Model[Instrument, PressureManifold, "id:zGj91a7mElrL"], True
					];
					(* we have to throw error here, if user request quant loading sample when we cannot support *)
					userDefineQuantQ = {MemberQ[expandedQuantitativeLoadingSampleVolume, GreaterP[0 Milliliter]], MemberQ[expandedQuantitativeLoadingSampleSolution, ObjectP[]], MemberQ[expandedQuantitativeLoadingSample, True]};
					{cannotSupportQuantitativeLoadingError, cannotSupportQuantitativeLoadingErrorOptionName} = If[
						enableQuantitativeLoadingSample == False && MemberQ[userDefineQuantQ, True],
						{True, PickList[{QuantitativeLoadingSampleVolume, QuantitativeLoadingSampleSolution, QuantitativeLoadingSample}, userDefineQuantQ]},
						{False, {}}
					];
					(* main switch for rinse and reload. -> this has to be pooled of the original sample *)
					resolvedQuantitativeLoadingSample = MapThread[
						(* if volume, or solution is supplied, flip the switch on *)
						If[(MatchQ[#1, GreaterP[0 Milliliter]] || MatchQ[#2, ObjectP[]] || MatchQ[#3, True]) && enableQuantitativeLoadingSample,
							True,
							False
						]&, {expandedQuantitativeLoadingSampleVolume, expandedQuantitativeLoadingSampleSolution, expandedQuantitativeLoadingSample}
					];
					(* once we know the switch, we figure out what buffer to rinse the source container *)
					resolvedQuantitativeLoadingSampleSolutionAndError = MapThread[
						Switch[{#1, #2},
							(* if this is automatic, we have to check whether we know what conditioning solution we are running on*)
							{True, Automatic},
							If[MatchQ[resolvedConditioningSolution, ObjectP[]],
								(* if we already know the conditioning solution, just follow it*)
								{resolvedConditioningSolution, False},
								(* otherwise, we just pick the default solution, based on extraction mode *)
								{Lookup[Lookup[tableDefaultSolutionDefinition, resolvedExtractionMode], Conditioning], False}
							],
							(* if user define the solution, follow it *)
							{True, ObjectP[]},
							Which[
								(* if the solution is given and it is the same as conditioning solution then this is Ok*)
								MatchQ[resolvedInstrumentModel, Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]] && MatchQ[#2, ObjectP[resolvedConditioningSolution]] && MatchQ[resolvedConditioningSolution, ObjectP[]],
								{#2, False},
								(* if solution is given but conditioning solution is not use this is OK too *)
								MatchQ[resolvedInstrumentModel, Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]] && MatchQ[resolvedConditioningSolution, Except[ObjectP[]]],
								{#2, False},
								(* otherwise, for GX271, we just don't allow it, quantitiative solution must be in 2nd bottle sadly *)
								MatchQ[resolvedInstrumentModel, Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]] && !MatchQ[#2, ObjectP[resolvedConditioningSolution]],
								{#2, True},
								(*other instrument, there is no limitation *)
								True,
								{#2, False}
							],

							{False, _},
							{Null, False}
						]&, {resolvedQuantitativeLoadingSample, expandedQuantitativeLoadingSampleSolution}
					];
					resolvedQuantitativeLoadingSampleSolution = resolvedQuantitativeLoadingSampleSolutionAndError[[All, 1]];
					quantitativeLoadingSampleSolutionError = resolvedQuantitativeLoadingSampleSolutionAndError[[All, 2]];
					(* figure out the volume to rinse the each sample container *)
					(* now we check the volume of sample container *)
					individualSampleContainerObject = Map[cacheLookup[simulatedCache, #[Object], Container]&, samplePacket];
					individualSampleContainerModel = Map[cacheLookup[simulatedCache, #, Model]&, individualSampleContainerObject];
					individualSampleContainerMaxVolume = Map[cacheLookup[simulatedCache, #, MaxVolume]&, individualSampleContainerModel];
					extractionCartridgeMaxVolume = ConstantArray[cacheLookup[simulatedCache, resolvedExtractionCartridgeModel, MaxVolume], Length[samplePacket]];
					(* and define the default rinseandreload volume *)
					almostSuggestedQuantitativeVolume = Map[Min, Transpose[{individualSampleContainerMaxVolume, resolvedLoadingSampleVolume, extractionCartridgeMaxVolume}]];
					(* making sure that the rinse reload volume is not to small, by not allowing it to go lower that 10% of container volume*)
					(*					suggestedQuantitativeVolume = MapThread[#1 /. LessP[#2] -> #2&, {almostSuggestedQuantitativeVolume, 0.1*individualSampleContainerMaxVolume};*)
					resolvedQuantitativeLoadingSampleVolume = MapThread[
						If[MatchQ[#1, True],
							#2 /. {GreaterP[#3] -> #3, Automatic -> #4},
							Null
						]&,
						{
							resolvedQuantitativeLoadingSample,
							expandedQuantitativeLoadingSampleVolume,
							individualSampleContainerMaxVolume,
							almostSuggestedQuantitativeVolume
						}
					];

					(* --12-- now we will resolve all loading sample related options *)
					(* we can just use the speSolutionResolver to get theoretical output first *)
					(* since we put the temperature resolver inside this speSolutionResolver (what a stupid move), so now we have to mapthread the whole thing, then collapse later *)
					{
						pooledResolvedLoadingSampleVolume,
						resolvedLoadingSampleTemperatureEquilibrationTime,
						(*						pooledResolvedMixLoadingSampleFlowthrough,*)
						pooledResolvedLoadingSamplePressure,
						pooledResolvedLoadingSampleDispenseRate,
						pooledResolvedLoadingSampleDrainTime,
						pooledResolvedMaxLoadingSampleDrainTime,
						resolvedLoadingSampleTemperature,
						ignoredLoadingSampleLabel, (* this is only for solution, not for the actual sample*)
						poolederrorLoadingSamplePressureTooLow,
						poolederrorLoadingSamplePressureTooHigh,
						poolederrorLoadingSampleDispenseRateTooLow,
						poolederrorLoadingSampleDispenseRateTooHigh,
						pooledwarningLoadingSamplePressureMustBeBoolean,
						poolederrorLoadingSampleVolumeInstrument,
						poolederrorLoadingSampleInstrumentSolutionTemperature
					} = Transpose[MapThread[
						speSolutionResolver[simulatedCache, tableExtractionOptions, resolvedExtractionCartridgeModel, resolvedInstrumentModel, resolvedExtractionMethod,
							True, #1,
							#2, #3,
							resolvedCollectLoadingSampleFlowthrough,
							unresolvedLoadingSamplePressure, unresolvedLoadingSampleDispenseRate,
							unresolvedLoadingSampleDrainTime, resolvedLoadingSampleUntilDrained, unresolvedMaxLoadingSampleDrainTime,
							unresolvedSampleLabel, resolvedPreparation, Null]&,
						{resolvedLoadingSampleVolume, expandedLoadingSampleTemperature, expandedLoadingSampleTemperatureEquilibrationTime}
					]];
					(* collapse non-pool resolved options, just have to indexmatch to pooled samples *)
					{
						(*						resolvedMixLoadingSampleFlowthrough,*)
						resolvedLoadingSamplePressure,
						resolvedLoadingSampleDispenseRate,
						resolvedLoadingSampleDrainTime,
						resolvedMaxLoadingSampleDrainTime,
						errorLoadingSamplePressureTooLow,
						errorLoadingSamplePressureTooHigh,
						errorLoadingSampleDispenseRateTooLow,
						errorLoadingSampleDispenseRateTooHigh,
						warningLoadingSamplePressureMustBeBoolean,
						errorLoadingSampleVolumeInstrument,
						errorLoadingSampleInstrumentSolutionTemperature
					} = Map[Sequence @@ Union[#]&,
						{
							(*							pooledResolvedMixLoadingSampleFlowthrough,*)
							pooledResolvedLoadingSamplePressure,
							pooledResolvedLoadingSampleDispenseRate,
							pooledResolvedLoadingSampleDrainTime,
							pooledResolvedMaxLoadingSampleDrainTime,
							poolederrorLoadingSamplePressureTooLow,
							poolederrorLoadingSamplePressureTooHigh,
							poolederrorLoadingSampleDispenseRateTooLow,
							poolederrorLoadingSampleDispenseRateTooHigh,
							pooledwarningLoadingSamplePressureMustBeBoolean,
							poolederrorLoadingSampleVolumeInstrument,
							poolederrorLoadingSampleInstrumentSolutionTemperature
						}
					];

					pooledResolvedQuantitativeLoadingSampleVolume = Total[resolvedQuantitativeLoadingSampleVolume];
					totalLoadingSampleVolume = Total[Flatten[{resolvedPooledLoadingSampleVolume, pooledResolvedQuantitativeLoadingSampleVolume}]];

					(* --13-- we will resolve for container out for each sample for now, then we will to batch later *)
					(* TODO there must be a step where we check whether we have to do things in batch or not *)
					(* TODO also, we have to pull all index that use the same equipment and resolve them as a batch *)

					{resolvedPreFlushingSolutionCollectionContainer,
						warningIncompatiblePreFlushingSolutionCollectionContainer,
						numberOfPreFlushingSolutionCollectionContainer} = speContainerResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedCollectPreFlushingSolution,
						resolvedPreFlushingSolutionVolume,
						unresolvedPreFlushingSolutionCollectionContainer,
						resolvedExtractionCartridgeModel,
						resolvedPreFlushingSwitch
					];

					{
						resolvedConditioningSolutionCollectionContainer,
						warningIncompatibleConditioningSolutionCollectionContainer,
						numberOfConditioningSolutionCollectionContainer
					} = speContainerResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedCollectConditioningSolution,
						resolvedConditioningSolutionVolume,
						unresolvedConditioningSolutionCollectionContainer,
						resolvedExtractionCartridgeModel,
						resolvedConditioningSwitch
					];

					{
						resolvedWashingSolutionCollectionContainer,
						warningIncompatibleWashingSolutionCollectionContainer,
						numberOfWashingSolutionCollectionContainer
					} = speContainerResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedCollectWashingSolution,
						resolvedWashingSolutionVolume,
						unresolvedWashingSolutionCollectionContainer,
						resolvedExtractionCartridgeModel,
						resolvedWashingSwitch
					];

					{
						resolvedSecondaryWashingSolutionCollectionContainer,
						warningIncompatibleSecondaryWashingSolutionCollectionContainer,
						numberOfSecondaryWashingSolutionCollectionContainer
					} = speContainerResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedCollectSecondaryWashingSolution,
						resolvedSecondaryWashingSolutionVolume,
						unresolvedSecondaryWashingSolutionCollectionContainer,
						resolvedExtractionCartridgeModel,
						resolvedSecondaryWashingSwitch
					];

					{
						resolvedTertiaryWashingSolutionCollectionContainer,
						warningIncompatibleTertiaryWashingSolutionCollectionContainer,
						numberOfTertiaryWashingSolutionCollectionContainer
					} = speContainerResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedCollectTertiaryWashingSolution,
						resolvedTertiaryWashingSolutionVolume,
						unresolvedTertiaryWashingSolutionCollectionContainer,
						resolvedExtractionCartridgeModel,
						resolvedTertiaryWashingSwitch
					];

					{
						resolvedElutingSolutionCollectionContainer,
						warningIncompatibleElutingSolutionCollectionContainer,
						numberOfElutingSolutionCollectionContainer
					} = speContainerResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedCollectElutingSolution,
						resolvedElutingSolutionVolume,
						unresolvedElutingSolutionCollectionContainer,
						resolvedExtractionCartridgeModel,
						resolvedElutingSwitch
					];

					{
						resolvedLoadingSampleFlowthroughContainer,
						warningIncompatibleLoadingSampleFlowthroughContainer,
						numberOfLoadingSampleFlowthroughContainer
					} = speContainerResolver[
						simulatedCache,
						tableExtractionOptions,
						resolvedInstrumentModel,
						resolvedExtractionMethod,
						resolvedCollectLoadingSampleFlowthrough,
						totalLoadingSampleVolume,
						unresolvedLoadingSampleFlowthroughContainer,
						resolvedExtractionCartridgeModel,
						True
					];

					(* resolve the label options *)
					(* for Sample/ContainerLabel options, automatically resolve to Null *)
					(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
					(* labels if we have duplicates. *)

					(* resolve the sample label and sample container label options *)
					(* this is separate because of the pooled option *)
					{
						pooledSamplePackets,
						sampleContainerPackets
					} = Quiet[Download[
						{
							samplePacket,
							samplePacket
						},
						{
							Packet[Object],
							Packet[Container[Object]]
						},
						Cache -> simulatedCache,
						Date -> Now
					], {Download::FieldDoesntExist}];
					{
						resolvedSampleLabel,
						resolvedSourceContainerLabel
					} = Transpose[MapThread[
						Function[{individualSamplePacket, individualSampleContainer, sourceLabelOption, sourceContainerLabelOption},
							Module[{resolvedIndividualSampleLabel, resolvedIndividualSourceContainerLabel},

								(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
								(* labels if we have duplicates. *)
								resolvedIndividualSampleLabel = Which[
									Not[MatchQ[sourceLabelOption, Automatic]],
									sourceLabelOption,
									MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[individualSamplePacket, Object]],
									Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[individualSamplePacket, Object]],
									True,
									"SPE sample label " <> StringDrop[Lookup[individualSamplePacket, ID], 3]
								];
								resolvedIndividualSourceContainerLabel = Which[
									Not[MatchQ[sourceContainerLabelOption, Automatic]],
									sourceContainerLabelOption,
									MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[individualSampleContainer, Object]],
									Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[individualSampleContainer, Object]],
									True,
									"SPE sample container label " <> StringDrop[Lookup[individualSampleContainer, ID], 3]
								];
								{
									resolvedIndividualSampleLabel,
									resolvedIndividualSourceContainerLabel
								}
							]
						],
						{pooledSamplePackets, sampleContainerPackets, unresolvedSampleLabel, unresolvedSourceContainerLabel}
					]];
					(* The following labels are repetitive, in which, if the label is not defined by user we just create them *)
					(* cartridge label *)
					resolvedCartridgeLabel = Which[
						Not[MatchQ[unresolvedExtractionCartridgeLabel, Automatic]],
							unresolvedExtractionCartridgeLabel,
						MatchQ[resolvedExtractionCartridgeModel, ObjectP[Model[Container, Plate]]],
							"SPE ExtractionCartridge label for " <> ToString[resolvedExtractionCartridgeModel],
						True,
							CreateUniqueLabel["SPE ExtractionCartridge label"]
					];
					(*Semi-resolve Eluting or flow through sample out label if SampleOutLabel is specified*)
					{semiResolvedLoadingSampleFlowthroughSampleOutLabel,semiResolvedElutingSampleOutLabel} = If[
						(*If SampleOutLabel is specified, semi-resolve based on extractionStrategy*)
						MatchQ[unresolvedSampleOutLabel,Except[Automatic|Null]],
						If[MatchQ[resolvedExtractionStrategy,Negative],
							(* For negative selection, flow through gets the specified sampleout label*)
							{unresolvedSampleOutLabel,unresolvedElutingSampleOutLabel},
							(* Otherwise, eluting sample gets the specified sample out label*)
							{unresolvedLoadingSampleFlowthroughSampleOutLabel,unresolvedSampleOutLabel}
						],
						(*If sampleout label is not specified, no need to touch*)
						{unresolvedLoadingSampleFlowthroughSampleOutLabel,unresolvedElutingSampleOutLabel}
					];
					(* create label for all sample out *)
					{
						resolvedPreFlushingSampleOutLabel,
						resolvedConditioningSampleOutLabel,
						resolvedLoadingSampleFlowthroughSampleOutLabel,
						resolvedWashingSampleOutLabel,
						resolvedSecondaryWashingSampleOutLabel,
						resolvedTertiaryWashingSampleOutLabel,
						resolvedElutingSampleOutLabel
					} = Map[
						Function[{solutionlabel},
							Module[
								{collectionswitch, collectionprefix, suppliedlabel},
								collectionswitch = solutionlabel[[1]];
								collectionprefix = solutionlabel[[2]];
								suppliedlabel = solutionlabel[[3]];
								Switch[{collectionswitch, suppliedlabel},
									(* if you collect it, create a label for it *)
									{True, Automatic | Null},
									CreateUniqueLabel[("SPE " <> collectionprefix <> " SampleOut")],
									(* if user supply one, use one *)
									{True, _String},
									suppliedlabel,
									{False, _},
									Null
								]
							]],
						{
							{resolvedCollectPreFlushingSolution, "PreFlushing", unresolvedPreFlushingSampleOutLabel},
							{resolvedCollectConditioningSolution, "Conditioning", unresolvedConditioningSampleOutLabel},
							{resolvedCollectLoadingSampleFlowthrough, "LoadingSampleFlowthrough", semiResolvedLoadingSampleFlowthroughSampleOutLabel},
							{resolvedCollectWashingSolution, "Washing", unresolvedWashingSampleOutLabel},
							{resolvedCollectSecondaryWashingSolution, "SecondaryWashing", unresolvedSecondaryWashingSampleOutLabel},
							{resolvedCollectTertiaryWashingSolution, "TertiaryWashing", unresolvedTertiaryWashingSampleOutLabel},
							{resolvedCollectElutingSolution, "Eluting", semiResolvedElutingSampleOutLabel}
						}
					];

					(* resolve samplein and sampleout storage condition, we have to expand for the sampplesin side to be pooled too*)
					defaultSampleStorageCondition = Map[cacheLookup[simulatedCache, #, StorageCondition]&, samplePacket];

					resolvedSamplesInStorageCondition = If[MatchQ[unresolvedSamplesInStorageCondition, Null],
						(* if it is not given, just store in default condition of the sample *)
						(*						Flatten[defaultSampleStorageCondition[Object]],*)
						ConstantArray[Null, Length[samplePacket]],
						(* other wise, just follow what the users say *)
						Which[

							!ListQ[unresolvedSamplesInStorageCondition],
							ConstantArray[unresolvedSamplesInStorageCondition, Length[samplePacket]],

							Length[unresolvedSamplesInStorageCondition] < Length[samplePacket],
							Flatten[ConstantArray[First[unresolvedSamplesInStorageCondition[[1]]], Length[samplePacket]]],

							Length[unresolvedSamplesInStorageCondition] == Length[samplePacket],
							unresolvedSamplesInStorageCondition,

							Length[unresolvedSamplesInStorageCondition] > Length[samplePacket],
							Take[unresolvedSamplesInStorageCondition, Length[samplePacket]]
						]
					];
					resolvedSamplesOutStorageCondition = If[MatchQ[unresolvedSamplesOutStorageCondition, SampleStorageTypeP],
						unresolvedSamplesOutStorageCondition,
						Null
					];

					resolvedExtractionCartridgeStorageCondition = If[MatchQ[unresolvedExtractionCartridgeStorageCondition, SampleStorageTypeP],
						unresolvedExtractionCartridgeStorageCondition,
						Null
					];

					(* Instrument specific errors *)
					(*GX271 has the following constraints
						1 - can take 5 different buffer bottle; 4 in 500 mL Gilson bottle and one in 10L carboy
						2 - has only 1 plate out deck
						3 - can either take 3 cc or 6 cc syringe type cartrdige but not at the same time
						4.1 - if use 3 cc syringe cartridge - we can take 48 samples in
						4.2 - if use 6 cc syringe cartridge - we can take 20 samples in *)
					allSolutionTypes = {
						resolvedPreFlushingSolution,
						resolvedConditioningSolution,
						resolvedWashingSolution,
						resolvedSecondaryWashingSolution,
						resolvedTertiaryWashingSolution,
						resolvedElutingSolution,
						resolvedQuantitativeLoadingSampleSolution
					};
					(* this is weird for GX271, we decide that PreFLush, Condition, Washing and Eluting buffer bottle will be fixed position, so the extra buffer will go to the 4th postion *)
					nTypesOfSolution = Length[DeleteDuplicates[
						{
							resolvedSecondaryWashingSolution,
							resolvedTertiaryWashingSolution
						} /. {Automatic | Null -> Nothing}]] + 3 ;

					nCollectionContainer = Count[{resolvedCollectPreFlushingSolution,
						resolvedCollectConditioningSolution,
						resolvedCollectWashingSolution,
						resolvedCollectSecondaryWashingSolution,
						resolvedCollectTertiaryWashingSolution,
						resolvedCollectElutingSolution,
						resolvedCollectLoadingSampleFlowthrough
					}, True];
					(* the is only 1 collection deck on GX271 *)
					suppliedOptionsForCollection = PickList[
						Flatten[{impliedCollectByContainerOptionName, impliedCollectByOptionOptionName}],
						Flatten[{impliedCollectByContainer, impliedCollectByOption}],
						Except[Automatic | Null | False]
					];

					{tooManyCollectionPlateOnGX271DeckError, tooManyCollectionPlateOnGX271DeckOptionName} = If[(MatchQ[resolvedInstrumentModel, ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]]] && nCollectionContainer > 1),
						{True, suppliedOptionsForCollection},
						{False, {}}
					];
					(* the is only 1 collection deck on GX271 *)
					{tooManyTypeOfSolutionOnGX271Error, tooManyTypeOfSolutionOnGX271OptionName} = If[MatchQ[resolvedInstrumentModel, ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]]] && nTypesOfSolution > 4,
						{True, PickList[{SecondaryWashingSolution, TertiaryWashingSolution}, {resolvedSecondaryWashingSolution, resolvedTertiaryWashingSolution}, ObjectP[]]},
						{False, {}}
					];
					(* -- Manual Transfer Dependent check  -- *)
					(* for the following instrument, all of the transfer will be performed by ExperimentTransfer, which we won't loop and max volume is *)

					(* MapThread output *)
					{
						(* resolved option output *)
						(*1*)resolvedInstrument,
						(*2*)resolvedExtractionMethod,
						(*3*)resolvedExtractionCartridgeType,
						(*4*)resolvedExtractionCartridge,
						(*5*)resolvedExtractionSorbent,
						(*6*)resolvedExtractionMode,
						(*7*)resolvedPreFlushingSwitch,
						(*8*)resolvedConditioningSwitch,
						(*9*)resolvedWashingSwitch,
						(*10*)resolvedSecondaryWashingSwitch,
						(*11*)resolvedTertiaryWashingSwitch,
						(*12*)resolvedElutingSwitch,
						(*13*)resolvedExtractionStrategy,
						(*14*)resolvedPreFlushingSolution,
						(*15*)resolvedConditioningSolution,
						(*16*)resolvedWashingSolution,
						(*17*)resolvedSecondaryWashingSolution,
						(*18*)resolvedTertiaryWashingSolution,
						(*19*)resolvedElutingSolution,
						(*20*)resolvedPreFlushingSolutionVolume,
						(*21*)resolvedConditioningSolutionVolume,
						(*22*)resolvedWashingSolutionVolume,
						(*23*)resolvedSecondaryWashingSolutionVolume,
						(*24*)resolvedTertiaryWashingSolutionVolume,
						(*25*)resolvedElutingSolutionVolume,
						(*26*)resolvedPreFlushingSolutionTemperature,
						(*27*)resolvedConditioningSolutionTemperature,
						(*28*)resolvedWashingSolutionTemperature,
						(*29*)resolvedSecondaryWashingSolutionTemperature,
						(*30*)resolvedTertiaryWashingSolutionTemperature,
						(*31*)resolvedElutingSolutionTemperature,
						(*32*)resolvedPreFlushingSolutionTemperatureEquilibrationTime,
						(*33*)resolvedConditioningSolutionTemperatureEquilibrationTime,
						(*34*)resolvedWashingSolutionTemperatureEquilibrationTime,
						(*35*)resolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
						(*36*)resolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
						(*37*)resolvedElutingSolutionTemperatureEquilibrationTime,
						(*38*)resolvedPreFlushingSolutionDispenseRate,
						(*39*)resolvedConditioningSolutionDispenseRate,
						(*40*)resolvedWashingSolutionDispenseRate,
						(*41*)resolvedSecondaryWashingSolutionDispenseRate,
						(*42*)resolvedTertiaryWashingSolutionDispenseRate,
						(*43*)resolvedElutingSolutionDispenseRate,
						(*44*)resolvedPreFlushingSolutionPressure,
						(*45*)resolvedConditioningSolutionPressure,
						(*46*)resolvedWashingSolutionPressure,
						(*47*)resolvedSecondaryWashingSolutionPressure,
						(*48*)resolvedTertiaryWashingSolutionPressure,
						(*49*)resolvedElutingSolutionPressure,
						(*50*)resolvedCollectPreFlushingSolution,
						(*51*)resolvedCollectConditioningSolution,
						(*52*)resolvedCollectWashingSolution,
						(*53*)resolvedCollectSecondaryWashingSolution,
						(*54*)resolvedCollectTertiaryWashingSolution,
						(*55*)resolvedCollectElutingSolution,
						(*56*)resolvedCollectLoadingSampleFlowthrough,
						(*57*)resolvedPreFlushingSolutionUntilDrained,
						(*58*)resolvedConditioningSolutionUntilDrained,
						(*59*)resolvedWashingSolutionUntilDrained,
						(*60*)resolvedSecondaryWashingSolutionUntilDrained,
						(*61*)resolvedTertiaryWashingSolutionUntilDrained,
						(*62*)resolvedElutingSolutionUntilDrained,
						(*63*)resolvedPreFlushingSolutionDrainTime,
						(*64*)resolvedConditioningSolutionDrainTime,
						(*65*)resolvedWashingSolutionDrainTime,
						(*66*)resolvedSecondaryWashingSolutionDrainTime,
						(*67*)resolvedTertiaryWashingSolutionDrainTime,
						(*68*)resolvedElutingSolutionDrainTime,
						(*69*)resolvedMaxPreFlushingSolutionDrainTime,
						(*70*)resolvedMaxConditioningSolutionDrainTime,
						(*71*)resolvedMaxWashingSolutionDrainTime,
						(*72*)resolvedMaxSecondaryWashingSolutionDrainTime,
						(*73*)resolvedMaxTertiaryWashingSolutionDrainTime,
						(*74*)resolvedMaxElutingSolutionDrainTime,
						(*75*)resolvedExtractionTemperature,
						(*76*)resolvedQuantitativeLoadingSample,
						(*77*)resolvedQuantitativeLoadingSampleSolution,
						(*78*)resolvedQuantitativeLoadingSampleVolume,
						(*79*)resolvedLoadingSampleVolume,
						(*80*)resolvedLoadingSampleTemperatureEquilibrationTime,
						(*81*)resolvedLoadingSampleTemperature,
						(*82*)resolvedLoadingSamplePressure,
						(*83*)resolvedLoadingSampleDispenseRate,
						(*84*)resolvedLoadingSampleDrainTime,
						(*85*)resolvedMaxLoadingSampleDrainTime,
						(*86*)resolvedPreFlushingSolutionCollectionContainer,
						(*87*)resolvedConditioningSolutionCollectionContainer,
						(*88*)resolvedWashingSolutionCollectionContainer,
						(*89*)resolvedSecondaryWashingSolutionCollectionContainer,
						(*90*)resolvedTertiaryWashingSolutionCollectionContainer,
						(*91*)resolvedElutingSolutionCollectionContainer,
						(*92*)resolvedLoadingSampleFlowthroughContainer,
						(*93*)resolvedPreparation,
						(*94*)resolvedSampleLabel,
						(*95*)resolvedSourceContainerLabel,
						(*96*)resolvedCartridgeLabel,
						(*97*)resolvedPreFlushingSampleOutLabel,
						(*98*)resolvedConditioningSampleOutLabel,
						(*99*)resolvedLoadingSampleFlowthroughSampleOutLabel,
						(*100*)resolvedWashingSampleOutLabel,
						(*101*)resolvedSecondaryWashingSampleOutLabel,
						(*102*)resolvedTertiaryWashingSampleOutLabel,
						(*103*)resolvedElutingSampleOutLabel,
						(*104*)resolvedPreFlushingSolutionLabel,
						(*105*)resolvedConditioningSolutionLabel,
						(*106*)resolvedWashingSolutionLabel,
						(*107*)resolvedSecondaryWashingSolutionLabel,
						(*108*)resolvedTertiaryWashingSolutionLabel,
						(*109*)resolvedElutingSolutionLabel,
						(*110*)resolvedSamplesInStorageCondition,
						(*111*)resolvedSamplesOutStorageCondition,
						(*112*)resolvedLoadingSampleUntilDrained,
						(* error and warning *)
						(*113*)unequalLoadingSampleVolumeLengthError,
						(*114*)incompatibleInstrumentSampleVolumeError, (**)
						(*115*)incompatibleCartridgeInstrumentError, (**)
						(*116*)incompatibleExtractionMethodSampleVolumeError, (**)
						(*117*)incompatibleExtractionCartridgeError, (**)
						(*118*)incompatibleInstrumentAndMethodError,
						(*119*)incompatibleInstrumentAndExtractionCartridgeError,
						(*120*)incompatibleExtractionMethodAndExtractionCartridgeError,
						(*121*)incompatibleInstrumentExtractionMethodExtractionCartridgeError,
						(*122*)warningExtractionStrategyWashingSwitchIncompatible,
						(*123*)skippedWashingError,
						(*124*)warningExtractionStrategySecondaryWashingSwitchIncompatible,
						(*125*)skippedSecondaryWashingError,
						(*126*)warningExtractionStrategyTertiaryWashingSwitchIncompatible,
						(*127*)warningPositiveStrategyWithoutEluting,
						(*128*)warningExtractionStrategyElutingIncompatible,
						(*129*)errorPreFlushingPressureTooLow,
						(*130*)errorPreFlushingPressureTooHigh,
						(*131*)errorPreFlushingDispenseRateTooLow,
						(*132*)errorPreFlushingDispenseRateTooHigh,
						(*133*)errorConditioningPressureTooLow,
						(*134*)errorConditioningPressureTooHigh,
						(*135*)errorConditioningDispenseRateTooLow,
						(*136*)errorConditioningDispenseRateTooHigh,
						(*137*)errorWashingPressureTooLow,
						(*138*)errorWashingPressureTooHigh,
						(*139*)errorWashingDispenseRateTooLow,
						(*140*)errorWashingDispenseRateTooHigh,
						(*141*)errorElutingPressureTooLow,
						(*142*)errorElutingPressureTooHigh,
						(*143*)errorElutingDispenseRateTooLow,
						(*144*)errorElutingDispenseRateTooHigh,
						(*145*)errorSecondaryWashingPressureTooLow,
						(*146*)errorSecondaryWashingPressureTooHigh,
						(*147*)errorSecondaryWashingDispenseRateTooLow,
						(*148*)errorSecondaryWashingDispenseRateTooHigh,
						(*149*)errorTertiaryWashingPressureTooLow,
						(*150*)errorTertiaryWashingPressureTooHigh,
						(*151*)errorTertiaryWashingDispenseRateTooLow,
						(*152*)errorTertiaryWashingDispenseRateTooHigh,
						(*153*)errorAmbientOnlyInstrument,
						(*154*)errorExtractionTemperatureTooLow,
						(*155*)errorExtractionTemperatureTooHigh,
						(*156*)unequalLengthQuantitativeLoadingSampleError,
						(*157*)unequalLengthQuantitativeLoadingSampleSolutionError,
						(*158*)unequalLengthQuantitativeLoadingSampleVolumeError,
						(*159*)unequalLengthLoadingSampleTemperatureError,
						(*160*)unequalLengthLoadingSampleTemperatureEquilibrationTimeError,
						(*161*)errorLoadingSamplePressureTooLow,
						(*162*)errorLoadingSamplePressureTooHigh,
						(*163*)errorLoadingSampleDispenseRateTooLow,
						(*164*)errorLoadingSampleDispenseRateTooHigh,
						(*165*)warningIncompatiblePreFlushingSolutionCollectionContainer,
						(*166*)warningIncompatibleConditioningSolutionCollectionContainer,
						(*167*)warningIncompatibleWashingSolutionCollectionContainer,
						(*168*)warningIncompatibleSecondaryWashingSolutionCollectionContainer,
						(*169*)warningIncompatibleTertiaryWashingSolutionCollectionContainer,
						(*170*)warningIncompatibleElutingSolutionCollectionContainer,
						(*171*)warningIncompatibleLoadingSampleFlowthroughContainer,
						(*172*)incompatibleExtractionCartridgeSampleVolumeError,
						(*173*)warningVolumeTooHigh,
						(*174*)conflictingCartridgeSorbentWarning,
						(*175*)warningExtractionStrategyChange,
						(*176*)warningPreFlushingPressureMustBeBoolean,
						(*177*)warningConditioningPressureMustBeBoolean,
						(*178*)warningWashingPressureMustBeBoolean,
						(*179*)warningElutingPressureMustBeBoolean,
						(*180*)warningSecondaryWashingPressureMustBeBoolean,
						(*181*)warningTertiaryWashingPressureMustBeBoolean,
						(*182*)warningLoadingSamplePressureMustBeBoolean,
						(*183*)volumeTooLargeWarning,
						(*184*)conflictingMethodInferringMobilePhaseOptionsError,
						(*185*)conflictingSuppliedMethodAndImpliedMethodError,
						(*186*)speCannotSupportVolumeError,
						(*187*)speCannotSupportCollectionError,
						(*188*)speCannotSupportCartridgeError,
						(*189*)speCannotSupportMethodError,
						(*190*)speCannotSupportCartridgeError,
						(*191*)speCannotSupportMethodError,
						(*192*)noCompatibleInstrumentError,
						(*193*)conflictingCartridgeSorbentWarning,
						(*194*)conflictingSuppliedMethodAndImpliedMethodErrorOptionName,
						(*195*)badLoadingSampleVolume,
						(*196*)noCompatibleInstrumentErrorName,
						(*197*)tooBigCartridgeError,
						(*198*)tooManyCollectionPlateOnGX271DeckError,
						(*199*)tooManyCollectionPlateOnGX271DeckOptionName,
						(*200*)tooManyTypeOfSolutionOnGX271OptionName,
						(*201*)tooManyTypeOfSolutionOnGX271Error,
						(*202*)cannotSupportQuantitativeLoadingError,
						(*203*)cannotSupportQuantitativeLoadingErrorOptionName,
						(*204*)quantitativeLoadingSampleSolutionError,
						(*205*)notSPECartridgeError,
						(*206*)speCannotSupportPreFlushVolume,
						(*207*)speCannotSupportConditionVolume,
						(*208*)speCannotSupportWashVolume,
						(*209*)speCannotSupportSecondaryWashVolume,
						(*210*)speCannotSupportTertiaryWashVolume,
						(*211*)speCannotSupportEluteVolume,
						(*212*)speCannotSupportQuantVolume,
						(*213*)speCannotSupportInstrumentError,
						(*214*)badVolumePreFlushName,
						(*215*)badVolumeConditionName,
						(*216*)badVolumeWashName,
						(*217*)badVolumeSecWashName,
						(*218*)badVolumeTerWashName,
						(*219*)badVolumeEluteName,
						(*220*)badVolumeQuantLoadName,
						(*221*)badInstrumentName,
						(*222*)errorPreFlushingVolumeInstrument,
						(*223*)errorConditioningVolumeInstrument,
						(*224*)errorWashingVolumeInstrument,
						(*225*)errorElutingVolumeInstrument,
						(*226*)errorSecondaryWashingVolumeInstrument,
						(*227*)errorTertiaryWashingVolumeInstrument,
						(*228*)errorLoadingSampleVolumeInstrument,
						(*229*)errorPreFlushingInstrumentSolutionTemperature,
						(*230*)errorConditioningInstrumentSolutionTemperature,
						(*231*)errorWashingInstrumentSolutionTemperature,
						(*232*)errorElutingInstrumentSolutionTemperature,
						(*233*)errorSecondaryWashingInstrumentSolutionTemperature,
						(*234*)errorTertiaryWashingInstrumentSolutionTemperature,
						(*235*)errorLoadingSampleInstrumentSolutionTemperature,
						(*236*)cannotFindCartridgeWithSuppliedError,
						(* intermediate variables *)
						(*237*)numberOfPreFlushingSolutionCollectionContainer,
						(*238*)numberOfConditioningSolutionCollectionContainer,
						(*239*)numberOfWashingSolutionCollectionContainer,
						(*240*)numberOfSecondaryWashingSolutionCollectionContainer,
						(*241*)numberOfTertiaryWashingSolutionCollectionContainer,
						(*242*)numberOfElutingSolutionCollectionContainer,
						(*243*)numberOfLoadingSampleFlowthroughContainer,
						(*244*)resolvedInstrumentModel,
						(*245*)pooledSampleVolumes,
						(*246*)poolsize,
						(*247*)sampleVolumes,
						(*248*)conflictingMobilePhaseOptionName,
						(*249*)numberOfCollection,
						(*250*)impliedCollectionNameError,
						(*251*)resolvedExtractionCartridgeStorageCondition
					}
				](* end module *)
			], (* end function *)
			{myPooledSamples, mapThreadFriendlyOptions}
		](* end mapthread *)
	]; (* end transpose to get resolved option for each sample *)

	(* CENTRIFUGE related resolver *)
	(* TODO at first, I want to use Experiment Centrifuge to resolve all centrifuge options, but ran into a problem of haveing to simulate sample that doesn't exist such as
	PreFlushingSolution and so on, so end up not using it. Thus the reason for all the weirdness below *)
	(* preset centrifuge output option resolution *)
	{preresolvedPreFlushingSolutionCentrifugeIntensity,
		preresolvedConditioningSolutionCentrifugeIntensity,
		preresolvedWashingSolutionCentrifugeIntensity,
		preresolvedSecondaryWashingSolutionCentrifugeIntensity,
		preresolvedTertiaryWashingSolutionCentrifugeIntensity,
		preresolvedElutingSolutionCentrifugeIntensity,
		preresolvedLoadingSampleCentrifugeIntensity
	} = Table[ConstantArray[Null, Length[myPooledSamples]], 7];
	{prepreFlushingSolutionCentrifugeIntensityError,
		preconditioningSolutionCentrifugeIntensityError,
		prewashingSolutionCentrifugeIntensityError,
		presecondaryWashingSolutionCentrifugeIntensityError,
		pretertiaryWashingSolutionCentrifugeIntensityError,
		preelutingSolutionCentrifugeIntensityError,
		preloadingSampleCentrifugeIntensityError
	} = Table[ConstantArray[False, Length[myPooledSamples]], 7];

	(* for anything related with centrifuge we will use experiment centrifuge to resolve, but first we have to group all sample that have centrifuge-related options together, instead of resolving one by one to save time *)
	centrifugeIndex = Position[mtInstrument, ObjectP[Model[Instrument, Centrifuge]] | ObjectP[Object[Instrument, Centrifuge]]];
	centrifugeIndexFlat = Flatten[centrifugeIndex];

	(* switch, if there is nothing for ExperimentCentrifuge to resolve, skip it*)
	{
		resolvedPreFlushingSolutionCentrifugeIntensity,
		resolvedConditioningSolutionCentrifugeIntensity,
		resolvedWashingSolutionCentrifugeIntensity,
		resolvedSecondaryWashingSolutionCentrifugeIntensity,
		resolvedTertiaryWashingSolutionCentrifugeIntensity,
		resolvedElutingSolutionCentrifugeIntensity,
		resolvedLoadingSampleCentrifugeIntensity,
		preFlushingSolutionCentrifugeIntensityError,
		conditioningSolutionCentrifugeIntensityError,
		washingSolutionCentrifugeIntensityError,
		secondaryWashingSolutionCentrifugeIntensityError,
		tertiaryWashingSolutionCentrifugeIntensityError,
		elutingSolutionCentrifugeIntensityError,
		loadingSampleCentrifugeIntensityError
	} = If[Not[MatchQ[centrifugeIndex, {}]],
		(
			(* get all centrifuge related options that are not fully resolved *)
			{
				mtPreFlushingSolutionCentrifugeIntensity,
				mtConditioningSolutionCentrifugeIntensity,
				mtWashingSolutionCentrifugeIntensity,
				mtSecondaryWashingSolutionCentrifugeIntensity,
				mtTertiaryWashingSolutionCentrifugeIntensity,
				mtElutingSolutionCentrifugeIntensity,
				mtLoadingSampleCentrifugeIntensity
			} =	Transpose[
				Lookup[mapThreadFriendlyOptions,
					{
						PreFlushingSolutionCentrifugeIntensity,
						ConditioningSolutionCentrifugeIntensity,
						WashingSolutionCentrifugeIntensity,
						SecondaryWashingSolutionCentrifugeIntensity,
						TertiaryWashingSolutionCentrifugeIntensity,
						ElutingSolutionCentrifugeIntensity,
						LoadingSampleCentrifugeIntensity
					}
				]
			];

			(* get all centrifuge related index to pass to ExperimentCentrifuge *)
			{
				ctInstrument,
				ctPreFlushingSolutionCentrifugeIntensity,
				ctConditioningSolutionCentrifugeIntensity,
				ctWashingSolutionCentrifugeIntensity,
				ctSecondaryWashingSolutionCentrifugeIntensity,
				ctTertiaryWashingSolutionCentrifugeIntensity,
				ctElutingSolutionCentrifugeIntensity,
				ctLoadingSampleCentrifugeIntensity,
				ctPreFlushingSwitch,
				ctConditioningSwitch,
				ctWashingSwitch,
				ctSecondaryWashingSwitch,
				ctTertiaryWashingSwitch,
				ctElutingSwitch,
				ctLoadingSampleSwitch
			} = Map[#[[centrifugeIndexFlat]]&,
				{
					mtInstrument,
					mtPreFlushingSolutionCentrifugeIntensity,
					mtConditioningSolutionCentrifugeIntensity,
					mtWashingSolutionCentrifugeIntensity,
					mtSecondaryWashingSolutionCentrifugeIntensity,
					mtTertiaryWashingSolutionCentrifugeIntensity,
					mtElutingSolutionCentrifugeIntensity,
					mtLoadingSampleCentrifugeIntensity,
					mtPreFlushingSwitch,
					mtConditioningSwitch,
					mtWashingSwitch,
					mtSecondaryWashingSwitch,
					mtTertiaryWashingSwitch,
					mtElutingSwitch,
					Flatten[ConstantArray[True, Length[myPooledSamples]]]
				}
			];

			stackedFakeIntensity = Flatten[{
				ctPreFlushingSolutionCentrifugeIntensity,
				ctConditioningSolutionCentrifugeIntensity,
				ctWashingSolutionCentrifugeIntensity,
				ctSecondaryWashingSolutionCentrifugeIntensity,
				ctTertiaryWashingSolutionCentrifugeIntensity,
				ctElutingSolutionCentrifugeIntensity,
				ctLoadingSampleCentrifugeIntensity
			}];

			stackedSwitch = Flatten[{
				ctPreFlushingSwitch,
				ctConditioningSwitch,
				ctWashingSwitch,
				ctSecondaryWashingSwitch,
				ctTertiaryWashingSwitch,
				ctElutingSwitch,
				ctLoadingSampleSwitch
			}];

			stackedPosition = Range[Length[stackedSwitch]];
			(* because there are 7 steps *)
			stackedInstrument = Flatten[ConstantArray[ctInstrument, 7]];
			(* put them all together and pick only steps that will be run on centrifuge *)
			stackAllToCentrifuge = PickList[Transpose[{stackedInstrument, stackedFakeIntensity, stackedPosition}], stackedSwitch];
			(*			stackedFakeObject = Flatten[ConstantArray[fakeLiquidObject, Count[stackedSwitch, True]]];*)

			(* simulated samples doesn't work we just hard code it for now *)
			stackedInstrumentModel = Map[If[MatchQ[#, ObjectP[Object]],
				cacheLookup[simulatedCache, #, Model],
				#
			]&, stackAllToCentrifuge[[All, 1]]
			];

			partResolvedIntensityWithError = MapThread[
				Module[
					{maxRotationRate},
					maxRotationRate = Switch[#2,
						(* TODO hard code this for now, because I don't know how to find max speed for plate swing arm, which is 4250 RPM *)
						ObjectP[Model[Instrument, Centrifuge, "id:eGakldJEz14E"]], 4250 RPM,
						(*other instrument, just check the max intensity *)
						_, cacheLookup[simulatedCache, #2, MaxRotationRate]
					];
					Which[
						(*if its Automatic, set it to 50% of the max rotation rate and don't throw error*)
						MatchQ[#1, Automatic], {0.5 * maxRotationRate, False},

						(*if it is in units of GravitationalAcceleration, leave it set to that and don't throw error (we don't have a MaxG to compare it to...)*)
						MatchQ[#1, Except[Automatic | Null]] && MatchQ[Units[#1], 1 GravitationalAcceleration], {#1, False},

						(*if it is in units of RPM, check that the set RPM is less than the max rotation rate*)
						MatchQ[#1, Except[Automatic | Null]] && #1 < maxRotationRate, {#1, False},

						True, {#1, True}
					]
				]&,
				{stackAllToCentrifuge[[All, 2]], stackedInstrumentModel}
			];
			partResolvedIntensity = partResolvedIntensityWithError[[All, 1]];
			partResolvedIntensityError = partResolvedIntensityWithError[[All, 2]];

			partPosition = stackAllToCentrifuge[[;;, 3]];
			forOptionReplacement = Transpose[{partPosition, partResolvedIntensity, partResolvedIntensityError}];

			nullPlaceHolderForReplacement = Table[Null, Length[stackedInstrument] * Length[centrifugeIndexFlat]];

			centrifugeOptionIntensity = ReplacePart[nullPlaceHolderForReplacement, Flatten[Map[Rule @@ #&, forOptionReplacement[[;;, {1, 2}]]]]];
			centrifugeOptionIntensityError = ReplacePart[nullPlaceHolderForReplacement, Flatten[Map[Rule @@ #&, forOptionReplacement[[;;, {1, 3}]]]]];

			{ctresolvedPreFlushingSolutionCentrifugeIntensity,
				ctresolvedConditioningSolutionCentrifugeIntensity,
				ctresolvedWashingSolutionCentrifugeIntensity,
				ctresolvedSecondaryWashingSolutionCentrifugeIntensity,
				ctresolvedTertiaryWashingSolutionCentrifugeIntensity,
				ctresolvedElutingSolutionCentrifugeIntensity,
				ctresolvedLoadingSampleCentrifugeIntensity
			} = TakeList[centrifugeOptionIntensity, ConstantArray[Length[centrifugeIndexFlat], 7]];

			{ctpreFlushingSolutionCentrifugeIntensityError,
				ctconditioningSolutionCentrifugeIntensityError,
				ctwashingSolutionCentrifugeIntensityError,
				ctsecondaryWashingSolutionCentrifugeIntensityError,
				cttertiaryWashingSolutionCentrifugeIntensityError,
				ctelutingSolutionCentrifugeIntensityError,
				ctloadingSampleCentrifugeIntensityError
			} = TakeList[centrifugeOptionIntensityError, ConstantArray[Length[centrifugeIndexFlat], 7]];
			(* now we have to replace part to the origin resolved options that are not just centrifuge *)
			MapThread[
				Function[{mainVariable, ctVariable},
					ReplacePart[mainVariable, Flatten[MapThread[#1 -> #2&, {centrifugeIndexFlat, ctVariable}]]]
				],
				{
					{
						preresolvedPreFlushingSolutionCentrifugeIntensity,
						preresolvedConditioningSolutionCentrifugeIntensity,
						preresolvedWashingSolutionCentrifugeIntensity,
						preresolvedSecondaryWashingSolutionCentrifugeIntensity,
						preresolvedTertiaryWashingSolutionCentrifugeIntensity,
						preresolvedElutingSolutionCentrifugeIntensity,
						preresolvedLoadingSampleCentrifugeIntensity,
						prepreFlushingSolutionCentrifugeIntensityError,
						preconditioningSolutionCentrifugeIntensityError,
						prewashingSolutionCentrifugeIntensityError,
						presecondaryWashingSolutionCentrifugeIntensityError,
						pretertiaryWashingSolutionCentrifugeIntensityError,
						preelutingSolutionCentrifugeIntensityError,
						preloadingSampleCentrifugeIntensityError
					},
					{
						ctresolvedPreFlushingSolutionCentrifugeIntensity,
						ctresolvedConditioningSolutionCentrifugeIntensity,
						ctresolvedWashingSolutionCentrifugeIntensity,
						ctresolvedSecondaryWashingSolutionCentrifugeIntensity,
						ctresolvedTertiaryWashingSolutionCentrifugeIntensity,
						ctresolvedElutingSolutionCentrifugeIntensity,
						ctresolvedLoadingSampleCentrifugeIntensity,
						ctpreFlushingSolutionCentrifugeIntensityError,
						ctconditioningSolutionCentrifugeIntensityError,
						ctwashingSolutionCentrifugeIntensityError,
						ctsecondaryWashingSolutionCentrifugeIntensityError,
						cttertiaryWashingSolutionCentrifugeIntensityError,
						ctelutingSolutionCentrifugeIntensityError,
						ctloadingSampleCentrifugeIntensityError
					}
				}
			]
		),
		(* if there is no centrifuge options, just give Null *)
		Join[
			ConstantArray[ConstantArray[Null, Length[mtExtractionCartridge]], 7],
			ConstantArray[ConstantArray[False, Length[mtExtractionCartridge]], 7]
		]
	];

	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];
	(*local helper function to use UnitScale on resolved volume options that could potentially contain Nulls*)
	unitScaleDisregardNull[resolvedVolume:ListableP[Null|VolumeP,2]]:= resolvedVolume /. (volume:VolumeP):>UnitScale[volume,Simplify -> False];

	speResolvedOptionsRules = DeleteDuplicates[{
		ExtractionStrategy -> mtExtractionStrategy,
		ExtractionMode -> mtExtractionMode,
		ExtractionSorbent -> mtExtractionSorbent,
		ExtractionCartridge -> mtExtractionCartridge,
		Instrument -> mtInstrument,
		ExtractionMethod -> mtExtractionMethod,
		ExtractionTemperature -> mtExtractionTemperature,
		PreFlushing -> mtPreFlushingSwitch,
		PreFlushingSolution -> mtPreFlushingSolution,
		PreFlushingSolutionVolume -> unitScaleDisregardNull[mtPreFlushingSolutionVolume],
		PreFlushingSolutionTemperature -> mtPreFlushingSolutionTemperature,
		PreFlushingSolutionTemperatureEquilibrationTime -> mtPreFlushingSolutionTemperatureEquilibrationTime,
		CollectPreFlushingSolution -> mtCollectPreFlushingSolution,
		PreFlushingSolutionDispenseRate -> mtPreFlushingSolutionDispenseRate,
		PreFlushingSolutionDrainTime -> mtPreFlushingSolutionDrainTime,
		PreFlushingSolutionUntilDrained -> mtPreFlushingSolutionUntilDrained,
		MaxPreFlushingSolutionDrainTime -> mtMaxPreFlushingSolutionDrainTime,
		PreFlushingSolutionPressure -> mtPreFlushingSolutionPressure,
		Conditioning -> mtConditioningSwitch,
		ConditioningSolution -> mtConditioningSolution,
		ConditioningSolutionVolume -> unitScaleDisregardNull[mtConditioningSolutionVolume],
		ConditioningSolutionTemperature -> mtConditioningSolutionTemperature,
		ConditioningSolutionTemperatureEquilibrationTime -> mtConditioningSolutionTemperatureEquilibrationTime,
		CollectConditioningSolution -> mtCollectConditioningSolution,
		ConditioningSolutionDispenseRate -> mtConditioningSolutionDispenseRate,
		ConditioningSolutionDrainTime -> mtConditioningSolutionDrainTime,
		ConditioningSolutionUntilDrained -> mtConditioningSolutionUntilDrained,
		MaxConditioningSolutionDrainTime -> mtMaxConditioningSolutionDrainTime,
		ConditioningSolutionPressure -> mtConditioningSolutionPressure,
		Washing -> mtWashingSwitch,
		WashingSolution -> mtWashingSolution,
		WashingSolutionVolume -> unitScaleDisregardNull[mtWashingSolutionVolume],
		WashingSolutionTemperature -> mtWashingSolutionTemperature,
		WashingSolutionTemperatureEquilibrationTime -> mtWashingSolutionTemperatureEquilibrationTime,
		CollectWashingSolution -> mtCollectWashingSolution,
		WashingSolutionDispenseRate -> mtWashingSolutionDispenseRate,
		WashingSolutionDrainTime -> mtWashingSolutionDrainTime,
		WashingSolutionUntilDrained -> mtWashingSolutionUntilDrained,
		MaxWashingSolutionDrainTime -> mtMaxWashingSolutionDrainTime,
		WashingSolutionPressure -> mtWashingSolutionPressure,
		SecondaryWashing -> mtSecondaryWashingSwitch,
		SecondaryWashingSolution -> mtSecondaryWashingSolution,
		SecondaryWashingSolutionVolume -> unitScaleDisregardNull[mtSecondaryWashingSolutionVolume],
		SecondaryWashingSolutionTemperature -> mtSecondaryWashingSolutionTemperature,
		SecondaryWashingSolutionTemperatureEquilibrationTime -> mtSecondaryWashingSolutionTemperatureEquilibrationTime,
		SecondaryWashingSolutionDispenseRate -> mtSecondaryWashingSolutionDispenseRate,
		SecondaryWashingSolutionDrainTime -> mtSecondaryWashingSolutionDrainTime,
		SecondaryWashingSolutionUntilDrained -> mtSecondaryWashingSolutionUntilDrained,
		MaxSecondaryWashingSolutionDrainTime -> mtMaxSecondaryWashingSolutionDrainTime,
		SecondaryWashingSolutionPressure -> mtSecondaryWashingSolutionPressure,
		TertiaryWashing -> mtTertiaryWashingSwitch,
		TertiaryWashingSolution -> mtTertiaryWashingSolution,
		TertiaryWashingSolutionVolume -> unitScaleDisregardNull[mtTertiaryWashingSolutionVolume],
		TertiaryWashingSolutionTemperature -> mtTertiaryWashingSolutionTemperature,
		TertiaryWashingSolutionTemperatureEquilibrationTime -> mtTertiaryWashingSolutionTemperatureEquilibrationTime,
		TertiaryWashingSolutionDispenseRate -> mtTertiaryWashingSolutionDispenseRate,
		TertiaryWashingSolutionDrainTime -> mtTertiaryWashingSolutionDrainTime,
		TertiaryWashingSolutionUntilDrained -> mtTertiaryWashingSolutionUntilDrained,
		MaxTertiaryWashingSolutionDrainTime -> mtMaxTertiaryWashingSolutionDrainTime,
		TertiaryWashingSolutionPressure -> mtTertiaryWashingSolutionPressure,
		Eluting -> mtElutingSwitch,
		ElutingSolution -> mtElutingSolution,
		ElutingSolutionVolume -> unitScaleDisregardNull[mtElutingSolutionVolume],
		ElutingSolutionTemperature -> mtElutingSolutionTemperature,
		ElutingSolutionTemperatureEquilibrationTime -> mtElutingSolutionTemperatureEquilibrationTime,
		CollectElutingSolution -> mtCollectElutingSolution,
		ElutingSolutionDispenseRate -> mtElutingSolutionDispenseRate,
		ElutingSolutionDrainTime -> mtElutingSolutionDrainTime,
		ElutingSolutionUntilDrained -> mtElutingSolutionUntilDrained,
		MaxElutingSolutionDrainTime -> mtMaxElutingSolutionDrainTime,
		ElutingSolutionPressure -> mtElutingSolutionPressure,
		QuantitativeLoadingSample -> mtQuantitativeLoadingSample,
		QuantitativeLoadingSampleSolution -> mtQuantitativeLoadingSampleSolution,
		QuantitativeLoadingSampleVolume -> unitScaleDisregardNull[mtQuantitativeLoadingSampleVolume],
		LoadingSampleVolume -> unitScaleDisregardNull[mtLoadingSampleVolume],
		LoadingSampleTemperatureEquilibrationTime -> mtLoadingSampleTemperatureEquilibrationTime,
		LoadingSampleTemperature -> mtLoadingSampleTemperature,
		LoadingSamplePressure -> mtLoadingSamplePressure,
		LoadingSampleDispenseRate -> mtLoadingSampleDispenseRate,
		LoadingSampleDrainTime -> mtLoadingSampleDrainTime,
		MaxLoadingSampleDrainTime -> mtMaxLoadingSampleDrainTime,
		PreFlushingSolutionCentrifugeIntensity -> resolvedPreFlushingSolutionCentrifugeIntensity,
		ConditioningSolutionCentrifugeIntensity -> resolvedConditioningSolutionCentrifugeIntensity,
		WashingSolutionCentrifugeIntensity -> resolvedWashingSolutionCentrifugeIntensity,
		SecondaryWashingSolutionCentrifugeIntensity -> resolvedSecondaryWashingSolutionCentrifugeIntensity,
		TertiaryWashingSolutionCentrifugeIntensity -> resolvedTertiaryWashingSolutionCentrifugeIntensity,
		ElutingSolutionCentrifugeIntensity -> resolvedElutingSolutionCentrifugeIntensity,
		LoadingSampleCentrifugeIntensity -> resolvedLoadingSampleCentrifugeIntensity,
		PreFlushingSolutionCollectionContainer -> mtPreFlushingSolutionCollectionContainer,
		ConditioningSolutionCollectionContainer -> mtConditioningSolutionCollectionContainer,
		WashingSolutionCollectionContainer -> mtWashingSolutionCollectionContainer,
		SecondaryWashingSolutionCollectionContainer -> mtSecondaryWashingSolutionCollectionContainer,
		TertiaryWashingSolutionCollectionContainer -> mtTertiaryWashingSolutionCollectionContainer,
		ElutingSolutionCollectionContainer -> mtElutingSolutionCollectionContainer,
		LoadingSampleFlowthroughContainer -> mtLoadingSampleFlowthroughContainer,
		(* we will check if evey sample using the same preparation later *)
		Preparation -> mtPreparation,
		SampleLabel -> mtSampleLabel,
		SourceContainerLabel -> mtSourceContainerLabel,
		ExtractionCartridgeLabel -> mtCartridgeLabel,
		CollectLoadingSampleFlowthrough -> mtCollectLoadingSampleFlowthrough,
		PreFlushingSampleOutLabel -> mtPreFlushingSampleOutLabel,
		ConditioningSampleOutLabel -> mtConditioningSampleOutLabel,
		LoadingSampleFlowthroughSampleOutLabel -> mtLoadingSampleFlowthroughSampleOutLabel,
		WashingSampleOutLabel -> mtWashingSampleOutLabel,
		SecondaryWashingSampleOutLabel -> mtSecondaryWashingSampleOutLabel,
		TertiaryWashingSampleOutLabel -> mtTertiaryWashingSampleOutLabel,
		ElutingSampleOutLabel -> mtElutingSampleOutLabel,
		SampleOutLabel -> mtElutingSampleOutLabel,
		CollectPreFlushingSolution -> mtCollectPreFlushingSolution,
		CollectConditioningSolution -> mtCollectConditioningSolution,
		CollectWashingSolution -> mtCollectWashingSolution,
		CollectSecondaryWashingSolution -> mtCollectSecondaryWashingSolution,
		CollectTertiaryWashingSolution -> mtCollectTertiaryWashingSolution,
		CollectElutingSolution -> mtCollectElutingSolution,
		CollectLoadingSampleFlowthrough -> mtCollectLoadingSampleFlowthrough,
		PreFlushingSolutionLabel -> mtPreFlushingSolutionLabel,
		ConditioningSolutionLabel -> mtConditioningSolutionLabel,
		WashingSolutionLabel -> mtWashingSolutionLabel,
		SecondaryWashingSolutionLabel -> mtSecondaryWashingSolutionLabel,
		TertiaryWashingSolutionLabel -> mtTertiaryWashingSolutionLabel,
		ElutingSolutionLabel -> mtElutingSolutionLabel,
		LoadingSampleUntilDrained -> mtLoadingSampleUntilDrained,
		ExtractionCartridgeStorageCondition -> mtresolvedExtractionCartridgeStorageCondition,
		(*Add in the container out labels so that it can be grouped by batch to get resolved later. Note that other container labels for specific stages are hidden options, so no neded to look up their value.*)
		ContainerOutLabel -> Lookup[myOptions,ContainerOutLabel]
	}];

	(* determine whether the volume is too much for all the options for each sample; we already calculated this above, just need to combine it *)
	badVolumeQs = Map[
		MemberQ[#, True]&,
		Transpose[{mtspeCannotSupportVolumeError, mtspeCannotSupportPreFlushVolume, mtspeCannotSupportConditionVolume, mtspeCannotSupportWashVolume, mtspeCannotSupportSecondaryWashVolume, mtspeCannotSupportTertiaryWashVolume, mtspeCannotSupportEluteVolume, mtspeCannotSupportQuantVolume}]
	];


	(* group all samples and options based on running instrument *)
	groupedByInstrument = Experiment`Private`groupByKey[
		Join[
			{
				Samples -> simulatedSamples,
				SamplesIndex -> Table[n, {n, Length[myPooledSamples]}],
				InstrumentModel -> mtinstrumentModel,
				BadVolumeQ -> badVolumeQs
			},
			speResolvedOptionsRules
		],
		{Instrument, InstrumentModel}
	];

	(* then we run loop across all options to best determine the batch depending each instrument limitation *)
	optionsWithBatch = Map[
		Function[{optionsPerInstrument},
			Module[{currentInstrumentModel, optionsWithBatchByInstrument, badVolumeQ},
				(* get the instrument model, and whether the volume is too high  *)
				currentInstrumentModel = Lookup[optionsPerInstrument[[1]], InstrumentModel];
				badVolumeQ = Lookup[optionsPerInstrument[[2]], BadVolumeQ];

				(* determine batch base on the model *)
				optionsWithBatchByInstrument = Switch[{currentInstrumentModel, badVolumeQ},

					(* don't batch anything if the input sample is too big to fit anyway *)
					{_, _?(MemberQ[#, True]&)},
						optionsPerInstrument[[2]],

					(* call batch calculator for GX271*)
					{ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]], _},
					speBatchCalculatorForGX271[optionsPerInstrument[[2]], simulatedCache],

					(* call batch calculator for syringpump *)
					{ObjectP[Model[Instrument, SyringePump, "id:GmzlKjPzN9l4"]], _},
					speBatchCalculatorSyringePumpOne[optionsPerInstrument[[2]], simulatedCache],

					(* call batch calculator centrifuge *)
					{ObjectP[Model[Instrument, Centrifuge, "id:eGakldJEz14E"]], _},
					speBatchCalculatorCentrifugePlateManual[optionsPerInstrument[[2]], simulatedCache],

					(* call batch calculator for Vaccummanifold *)
					{ObjectP[Model[Instrument, VacuumManifold, "id:qdkmxz0V139V"]], _},
					speBatchCalculatorVaccumManifold[optionsPerInstrument[[2]], simulatedCache],

					(* call batch calculator for FilterBlock *)
					{ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]], _},
					speBatchCalculatorFilterBlockManual[optionsPerInstrument[[2]], simulatedCache],

					{ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]], _},
					speBatchCalculatorForBiotage48[optionsPerInstrument[[2]], simulatedCache],

					(* if does match anything give batch for each sample *)
					{_, _},
					optionsPerInstrument[[2]]
				];
				(* flat one layer, because we might have more than one object instrument with the same model *)
				Merge[optionsWithBatchByInstrument, Flatten[#, 1]&]
			]
		],
		groupedByInstrument
	];

	(* merge all the resolved batch from each instrument model *)
	optionsWithBatchList = Merge[optionsWithBatch, Flatten[#, 1]&] /. Association[x___] -> List[x];
	(* return it to list *)
	originalOrderOfOptions = ToList[Ordering[Lookup[optionsWithBatchList, SamplesIndex]]];
	reorderOptionsWithBatch = MapThread[#1 -> #2[[originalOrderOfOptions]] &, {Keys[optionsWithBatchList], Values[optionsWithBatchList]}];

	speResolvedOptionsRulesWithBatch = Join[
		speResolvedOptionsRules,
		{
			Samples -> simulatedSamples,
			SamplesIndex -> Table[n, {n, Length[myPooledSamples]}],
			SPEBatchID -> Lookup[reorderOptionsWithBatch, SPEBatchID, ConstantArray[Null, Length[myPooledSamples]]],
			AliquotTargets -> Lookup[reorderOptionsWithBatch, AliquotTargets, ConstantArray[Null, Length[myPooledSamples]]],
			CartridgePlacement -> Lookup[reorderOptionsWithBatch, CartridgePlacement, ConstantArray[Null, Length[myPooledSamples]]]
		}
	];

	(* once we know the batch and type of instrument, we can just assign the well of sample out and trasfer location base on instrument and also all information about collection container *)
	groupedByBatchID = Experiment`Private`groupByKey[
		speResolvedOptionsRulesWithBatch,
		{SPEBatchID}
	];
	aliquotAndContainerOptions = Map[
		Function[{optionByBatchID},
			Module[
				{instrument, instrumentModel, samples, poolLength, flatSamples, samplesContainer, samplesContainerModel, volumeToTransfer, samplesAliquotTarget, cartridgePosition,
					allPlateQ, twoPlateOnlyQ, mustTransfer, updatedAliquotTargets, samplesIndex, preFlushCollectContainer, conditioningCollectContainer, washingCollectContainer,
					secondaryWashingCollectContainer, tertiaryWashingCollectContainer, elutingCollectContainer,
					 specifiedContainerOutLabel,semiResolvedElutingCollectContainerLabel,semiResolvedFlowthroughCollectContainerLabel,
					flowthroughCollectContainer, preFlushCollectContainerLabel, nPool,
					conditioningCollectContainerLabel, washingCollectContainerLabel, secondaryWashingCollectContainerLabel, tertiaryWashingCollectContainerLabel, elutingCollectContainerLabel,
					flowthroughCollectContainerLabel, dwp48AllowedPosition, cartridgeToWellRule,
					containerOutWell
				},
				(* get instrument model *)
				instrument = First[Lookup[optionByBatchID[[2]], Instrument]];
				instrumentModel = If[MatchQ[instrument, ObjectP[Object]],
					Experiment`Private`cacheLookup[simulatedCache, instrument, Model],
					instrument
				];
				samples = Lookup[optionByBatchID[[2]], Samples];
				nPool = Length[samples];
				poolLength = Length /@ samples;
				flatSamples = Flatten[samples];
				samplesContainer = Map[Experiment`Private`cacheLookup[simulatedCache, #, Container]&, flatSamples];
				samplesContainerModel = Map[Experiment`Private`cacheLookup[simulatedCache, #, Model]&, DeleteDuplicates[samplesContainer]];
				volumeToTransfer = Flatten[Lookup[optionByBatchID[[2]], LoadingSampleVolume]];
				samplesAliquotTarget = Lookup[optionByBatchID[[2]], AliquotTargets];
				cartridgePosition = Lookup[optionByBatchID[[2]], CartridgePlacement];
				samplesIndex = Lookup[optionByBatchID[[2]], SamplesIndex];
				preFlushCollectContainer = First[Lookup[optionByBatchID[[2]], PreFlushingSolutionCollectionContainer]];
				conditioningCollectContainer = First[Lookup[optionByBatchID[[2]], ConditioningSolutionCollectionContainer]];
				washingCollectContainer = First[Lookup[optionByBatchID[[2]], WashingSolutionCollectionContainer]];
				secondaryWashingCollectContainer = First[Lookup[optionByBatchID[[2]], SecondaryWashingSolutionCollectionContainer]];
				tertiaryWashingCollectContainer = First[Lookup[optionByBatchID[[2]], TertiaryWashingSolutionCollectionContainer]];
				elutingCollectContainer = First[Lookup[optionByBatchID[[2]], ElutingSolutionCollectionContainer]];
				flowthroughCollectContainer = First[Lookup[optionByBatchID[[2]], LoadingSampleFlowthroughContainer]];

				specifiedContainerOutLabel = Lookup[optionByBatchID[[2]], ContainerOutLabel];
				(*these are hidden options so no need to check specification*)
				{semiResolvedFlowthroughCollectContainerLabel,semiResolvedElutingCollectContainerLabel} = If[MatchQ[specifiedContainerOutLabel,Except[ListableP[Null|Automatic]]],
					(*If the ContainerOutLabel is specified, semi-resolve the flowthrough or eluting container label based on selection strategy*)
					If[MatchQ[First[Lookup[optionByBatchID[[2]], ExtractionStrategy]],Negative],
						(*For negative selection, flow through collection container gets the specified container out label*)
						{specifiedContainerOutLabel,Null},
						(*Otherwise, elution container gets the specified container out label*)
						{Null,specifiedContainerOutLabel}
					],
					(*If the ContainerOutLabel is not specified, no change before resolving*)
					{Null,Null}
				];

				(* branch for each instrument *)
				Switch[instrumentModel,

					(* for GX271, we can only take dwp, so in each batch, we have to check whether all sample are in just 2 plates or not *)
					ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]],
					(
						(* 1 are all sample in the right type of plate *)
						allPlateQ = MatchQ[samplesContainerModel, {ObjectReferenceP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]...}];
						(* 2 are there just 2 plates to fit on the machine? *)
						twoPlateOnlyQ = LessEqualQ[Length[DeleteDuplicates[samplesContainer]], 2];
						(* if both criteria don't fit, then we will transfer it, regardless, we will move to a new plate *)
						mustTransfer = Not[allPlateQ && twoPlateOnlyQ];
						updatedAliquotTargets = If[mustTransfer,
							samplesAliquotTarget,
							samplesAliquotTarget /. {{_String, _?QuantityQ, _String, ObjectReferenceP[]} -> Null}
						];
						(* setup container out for GX271 *)
						{
							preFlushCollectContainerLabel,
							conditioningCollectContainerLabel,
							washingCollectContainerLabel,
							secondaryWashingCollectContainerLabel,
							tertiaryWashingCollectContainerLabel,
							elutingCollectContainerLabel,
							flowthroughCollectContainerLabel
						} = Map[
							Module[{samplePerContainerOut, containerOutNumber, containerOutNumberUnique, containerOutLabelUnique, containerOutLabelRules},
								(*If the label is specified, leave it as it is*)
								If[MatchQ[#[[2]], Except[ListableP[Null]]],
									#[[2]],
									(*Otherwise resolve*)
									If[Not[MatchQ[#[[1]], Null]],
										(* if this is an actual container*)
										(
											samplePerContainerOut = PartitionRemainder[samples, Length[Experiment`Private`cacheLookup[simulatedCache, #[[1]], AllowedPositions]]];
											containerOutNumber = Flatten[MapIndexed[ConstantArray[#2, Length[#1]]&, samplePerContainerOut]];
											containerOutNumberUnique = DeleteDuplicates[containerOutNumber];
											containerOutLabelUnique = Map[CreateUniqueLabel["SPE ContainerOut"]&, containerOutNumberUnique];
											containerOutLabelRules = MapThread[#1 -> #2&, {containerOutNumberUnique, containerOutLabelUnique}];
											(* change the number to rules *)
											containerOutNumber /. containerOutLabelRules
										),
										(* otherwise just return null with the same length as sample *)
										Flatten[ConstantArray[Null, nPool]]
									]
								]
							]&,
							{
								{preFlushCollectContainer,Null},
								{conditioningCollectContainer,Null},
								{washingCollectContainer,Null},
								{secondaryWashingCollectContainer,Null},
								{tertiaryWashingCollectContainer,Null},
								{elutingCollectContainer,semiResolvedElutingCollectContainerLabel},
								{flowthroughCollectContainer,semiResolvedFlowthroughCollectContainerLabel}
							}
						];

						(* container out wells location *)
						dwp48AllowedPosition = List @@ Experiment`Private`cacheLookup[cache, Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"], AllowedPositions];
						cartridgeToWellRule = MapThread[#1 -> #2&, {Table[n, {n, Length[dwp48AllowedPosition]}], dwp48AllowedPosition}];
						containerOutWell = Lookup[optionByBatchID[[2]], CartridgePlacement] /. cartridgeToWellRule;
						{
							SampleIndex -> samplesIndex,
							AliquotTargets -> updatedAliquotTargets,
							PreFlushingContainerLabel -> preFlushCollectContainerLabel,
							ConditioningContainerLabel -> conditioningCollectContainerLabel,
							WashingContainerLabel -> washingCollectContainerLabel,
							SecondaryContainerLabel -> secondaryWashingCollectContainerLabel,
							TertiaryContainerLabel -> tertiaryWashingCollectContainerLabel,
							ElutingContainerLabel -> elutingCollectContainerLabel,
							LoadingSampleFlowthroughContainerLabel -> flowthroughCollectContainerLabel,
							ContainerOutWellAssignment -> containerOutWell
						}
					), (* end for GX271 *)

					(* for all centrifuge and filter block there is no aliquoting here *)
					ObjectP[{Model[Instrument, FilterBlock], Model[Instrument, Centrifuge]}],
					(
						(* we just have to create label for all container out *)
						{
							preFlushCollectContainerLabel,
							conditioningCollectContainerLabel,
							washingCollectContainerLabel,
							secondaryWashingCollectContainerLabel,
							tertiaryWashingCollectContainerLabel,
							elutingCollectContainerLabel,
							flowthroughCollectContainerLabel
						} = Map[
							Module[{samplePerContainerOut, containerOutNumber, containerOutNumberUnique, containerOutLabelUnique, containerOutLabelRules},
								(*If the label is specified, leave it as it is*)
								If[MatchQ[#[[2]], Except[ListableP[Null]]],
									#[[2]],
									(*Otherwise resolve*)
									If[Not[MatchQ[#[[1]], Null]],
									(* if this is an actual container *)
									(
										samplePerContainerOut = PartitionRemainder[samples, Length[Experiment`Private`cacheLookup[simulatedCache, #[[1]], AllowedPositions]]];
										containerOutNumber = Flatten[MapIndexed[ConstantArray[#2, Length[#1]]&, samplePerContainerOut]];
										containerOutNumberUnique = DeleteDuplicates[containerOutNumber];
										containerOutLabelUnique = Map[CreateUniqueLabel["SPE ContainerOut"]&, containerOutNumberUnique];
										containerOutLabelRules = MapThread[#1 -> #2&, {containerOutNumberUnique, containerOutLabelUnique}];
										(* change the number to rules *)
										containerOutNumber /. containerOutLabelRules
									),
									(* otherwise just return null with the same length as sample *)
									Flatten[ConstantArray[Null, nPool]]
									]
								]
							]&,
							{
								{preFlushCollectContainer,Null},
								{conditioningCollectContainer,Null},
								{washingCollectContainer,Null},
								{secondaryWashingCollectContainer,Null},
								{tertiaryWashingCollectContainer,Null},
								{elutingCollectContainer,semiResolvedElutingCollectContainerLabel},
								{flowthroughCollectContainer,semiResolvedFlowthroughCollectContainerLabel}
							}
						];

						containerOutWell = Lookup[optionByBatchID[[2]], CartridgePlacement];
						{
							SampleIndex -> samplesIndex,
							(* there is no aliquoting *)
							AliquotTargets -> samplesAliquotTarget,
							PreFlushingContainerLabel -> preFlushCollectContainerLabel,
							ConditioningContainerLabel -> conditioningCollectContainerLabel,
							WashingContainerLabel -> washingCollectContainerLabel,
							SecondaryContainerLabel -> secondaryWashingCollectContainerLabel,
							TertiaryContainerLabel -> tertiaryWashingCollectContainerLabel,
							ElutingContainerLabel -> elutingCollectContainerLabel,
							LoadingSampleFlowthroughContainerLabel -> flowthroughCollectContainerLabel,
							ContainerOutWellAssignment -> containerOutWell
						}
					), (* end for centrifuge manual *)

					(* for Biotage, there is no aliquot too *)
					(* also true for MPE2, so just doing it for all pressure manifolds *)
					ObjectP[Model[Instrument, PressureManifold]],
					(
						(* we just have to create label for all container out *)
						{
							preFlushCollectContainerLabel,
							conditioningCollectContainerLabel,
							washingCollectContainerLabel,
							secondaryWashingCollectContainerLabel,
							tertiaryWashingCollectContainerLabel,
							elutingCollectContainerLabel,
							flowthroughCollectContainerLabel
						} = Map[
							Module[{samplePerContainerOut, containerOutNumber, containerOutNumberUnique, containerOutLabelUnique, containerOutLabelRules},
								Which[

									(* if this is waste, then don't assign the label *)
									MatchQ[#[[1]], ObjectP[Model[Container, Vessel, "Biotage Pressure+48 Waste Tub"]]],
									Flatten[ConstantArray[Null, nPool]],
									(*If the label is specified, leave it as it is *)
									MatchQ[#[[2]], Except[ListableP[Null]]],
									#[[2]],
									Not[MatchQ[#[[1]], Null]],
									(
										samplePerContainerOut = PartitionRemainder[samples, Length[Experiment`Private`cacheLookup[simulatedCache, #[[1]], AllowedPositions]]];
										containerOutNumber = Flatten[MapIndexed[ConstantArray[#2, Length[#1]]&, samplePerContainerOut]];
										containerOutNumberUnique = DeleteDuplicates[containerOutNumber];
										containerOutLabelUnique = Map[CreateUniqueLabel["SPE ContainerOut"]&, containerOutNumberUnique];
										containerOutLabelRules = MapThread[#1 -> #2&, {containerOutNumberUnique, containerOutLabelUnique}];
										(* change the number to rules *)
										containerOutNumber /. containerOutLabelRules
									),

									(* otherwise just return null with the same length as sample *)
									True,
									Flatten[ConstantArray[Null, nPool]]
								]
							]&,
							{
								{preFlushCollectContainer,Null},
								{conditioningCollectContainer,Null},
								{washingCollectContainer,Null},
								{secondaryWashingCollectContainer,Null},
								{tertiaryWashingCollectContainer,Null},
								{elutingCollectContainer,semiResolvedElutingCollectContainerLabel},
								{flowthroughCollectContainer,semiResolvedFlowthroughCollectContainerLabel}
							}
						];
						containerOutWell = Flatten[ConstantArray["A1", nPool]];
						{
							SampleIndex -> samplesIndex,
							(* there is no aliquoting *)
							AliquotTargets -> samplesAliquotTarget,
							PreFlushingContainerLabel -> preFlushCollectContainerLabel,
							ConditioningContainerLabel -> conditioningCollectContainerLabel,
							WashingContainerLabel -> washingCollectContainerLabel,
							SecondaryContainerLabel -> secondaryWashingCollectContainerLabel,
							TertiaryContainerLabel -> tertiaryWashingCollectContainerLabel,
							ElutingContainerLabel -> elutingCollectContainerLabel,
							LoadingSampleFlowthroughContainerLabel -> flowthroughCollectContainerLabel,
							ContainerOutWellAssignment -> containerOutWell
						}
					), (* end for pressure manifold *)

					Model[Instrument, SyringePump, "id:GmzlKjPzN9l4"],
					(
						(* we just have to create label for all container out *)
						{
							preFlushCollectContainerLabel,
							conditioningCollectContainerLabel,
							washingCollectContainerLabel,
							secondaryWashingCollectContainerLabel,
							tertiaryWashingCollectContainerLabel,
							elutingCollectContainerLabel,
							flowthroughCollectContainerLabel
						} = Map[
							Module[{samplePerContainerOut, containerOutNumber, containerOutNumberUnique, containerOutLabelUnique, containerOutLabelRules},
								(*If the label is specified, leave it as it is*)
								If[MatchQ[#[[2]], Except[ListableP[Null]]],
									#[[2]],
									(*Otherwise resolve*)
									If[Not[MatchQ[#[[1]], Null]],
									(* if this is an actual container *)
									(
										samplePerContainerOut = PartitionRemainder[samples, Length[Experiment`Private`cacheLookup[simulatedCache, #[[1]], AllowedPositions]]];
										containerOutNumber = Flatten[MapIndexed[ConstantArray[#2, Length[#1]]&, samplePerContainerOut]];
										containerOutNumberUnique = DeleteDuplicates[containerOutNumber];
										containerOutLabelUnique = Map[CreateUniqueLabel["SPE ContainerOut"]&, containerOutNumberUnique];
										containerOutLabelRules = MapThread[#1 -> #2&, {containerOutNumberUnique, containerOutLabelUnique}];
										(* change the number to rules *)
										containerOutNumber /. containerOutLabelRules
									),
									(* otherwise just return null with the same length as sample *)
									Flatten[ConstantArray[Null, nPool]]
									]
								]
							]&,
							{
								{preFlushCollectContainer,Null},
								{conditioningCollectContainer,Null},
								{washingCollectContainer,Null},
								{secondaryWashingCollectContainer,Null},
								{tertiaryWashingCollectContainer,Null},
								{elutingCollectContainer,semiResolvedElutingCollectContainerLabel},
								{flowthroughCollectContainer,semiResolvedFlowthroughCollectContainerLabel}
							}
						];
						containerOutWell = Flatten[ConstantArray["A1", nPool]];
						{
							SampleIndex -> samplesIndex,
							(* there is no aliquoting for this manual filter *)
							AliquotTargets -> samplesAliquotTarget,
							PreFlushingContainerLabel -> preFlushCollectContainerLabel,
							ConditioningContainerLabel -> conditioningCollectContainerLabel,
							WashingContainerLabel -> washingCollectContainerLabel,
							SecondaryContainerLabel -> secondaryWashingCollectContainerLabel,
							TertiaryContainerLabel -> tertiaryWashingCollectContainerLabel,
							ElutingContainerLabel -> elutingCollectContainerLabel,
							LoadingSampleFlowthroughContainerLabel -> flowthroughCollectContainerLabel,
							ContainerOutWellAssignment -> containerOutWell
						}
					) (* end for Syringe Pump *)

				]
			]
		],
		groupedByBatchID
	];

	(* return the aliquot target and all the container label options to index match with samples in order *)
	aliquotAndContainerOptionsList = Merge[aliquotAndContainerOptions, Flatten[#, 1]&] /. Association[x___] -> List[x];
	orderingSamplesIndex = Ordering[Flatten[Lookup[aliquotAndContainerOptionsList, SampleIndex]]];
	{
		resolvedAliquotTargets,
		resolvedPreFlushingContainerLabel,
		resolvedConditioningContainerLabel,
		resolvedWashingContainerLabel,
		resolvedSecondaryContainerLabel,
		resolvedTertiaryContainerLabel,
		resolvedElutingContainerLabel,
		resolvedLoadingSampleFlowthroughContainerLabel,
		resolvedContainerOutWellAssignment
	} = Map[
		Lookup[aliquotAndContainerOptionsList, #][[orderingSamplesIndex]]&,
		{
			AliquotTargets,
			PreFlushingContainerLabel,
			ConditioningContainerLabel,
			WashingContainerLabel,
			SecondaryContainerLabel,
			TertiaryContainerLabel,
			ElutingContainerLabel,
			LoadingSampleFlowthroughContainerLabel,
			ContainerOutWellAssignment
		}
	];

	(* put it in the original options format *)
	resolvedPreparation = FirstOrDefault[Flatten[mtPreparation], Manual];
	fullyResolvedOptionsRulesWithBatch = ReplaceRule[speResolvedOptionsRulesWithBatch,
		Join[
			{
				AliquotTargets -> resolvedAliquotTargets,
				PreFlushingCollectionContainerOutLabel -> resolvedPreFlushingContainerLabel,
				ConditioningCollectionContainerOutLabel -> resolvedConditioningContainerLabel,
				WashingCollectionContainerOutLabel -> resolvedWashingContainerLabel,
				SecondaryWashingCollectionContainerOutLabel -> resolvedSecondaryContainerLabel,
				TertiaryWashingCollectionContainerOutLabel -> resolvedTertiaryContainerLabel,
				ElutingCollectionContainerOutLabel -> resolvedElutingContainerLabel,
				LoadingSampleFlowthroughCollectionContainerOutLabel -> resolvedLoadingSampleFlowthroughContainerLabel,
				ContainerOutLabel ->resolvedElutingContainerLabel,
				ContainerOutWellAssignment -> resolvedContainerOutWellAssignment,
				Preparation -> resolvedPreparation
			},
			resolvedSamplePrepOptions,
			resolvedPostProcessingOptions
		]
	];
	(* drop all keys that are not the options of SPE *)
	fullyResolvedOptionsRulesWithBatchNoSamples = KeyDrop[fullyResolvedOptionsRulesWithBatch, {Samples, SamplesIndex}] /. Association[x___] -> List[x];

	{
		unresolvedEmail,
		unresolvedName,
		samplesInStorage,
		samplesOutStorage,
		upload,
		unresolvedWorkCell
	} = Lookup[
		myOptions,
		{
			Email,
			Name,
			SamplesInStorageCondition,
			SamplesOutStorageCondition,
			Upload,
			WorkCell
		}
	];
	(* Adjust the email option based on the upload option *)
	resolvedEmail = If[!MatchQ[unresolvedEmail, Automatic],
		unresolvedEmail,
		upload && MemberQ[output, Result]
	];
	expandedSamplesInStorage = Flatten@MapThread[ConstantArray[#2, Length[#1]]&, {myPooledSamples, samplesInStorage}];

	(* replace the specified SPE options with the resolved ones *)
	speOptionsResolveReplaced = ReplaceRule[mySPEOptions, fullyResolvedOptionsRulesWithBatchNoSamples];

	(* resolve the work cell option *)
	allowedWorkCells = If[MatchQ[resolvedPreparation, Robotic],
		resolveSolidPhaseExtractionWorkCell[Null, speOptionsResolveReplaced],
		Null
	];
	resolvedWorkCell = Which[
		(*choose user selected workcell if the user selected one *)
		MatchQ[unresolvedWorkCell, Except[Automatic]], unresolvedWorkCell,
		(*if we are doing the protocol by hand, then there is no robotic workcell *)
		MatchQ[resolvedPreparation, Manual], Null,
		(*choose the first workcell that is presented *)
		MatchQ[resolvedPreparation, Robotic] && Length[allowedWorkCells] > 0, First[allowedWorkCells],
		(* failsafe, choose STAR otherwise *)
		True, STAR
	];

	(* Option resolver output*)
	resolvedOptionsWithoutRounding = ReplaceRule[
		Flatten[{
			speOptionsResolveReplaced,
			resolvedSamplePrepOptions,
			resolvedPostProcessingOptions
		}],
		{
			Name -> unresolvedName,
			Email -> resolvedEmail,
			WorkCell -> resolvedWorkCell,
			SamplesInStorageCondition -> mtSamplesInStorageCondition,
			SamplesOutStorageCondition -> mtSamplesOutStorageCondition
		}
	];

	(* round the options precision here; ultimately we want to do this automatically, but for now need to do it manually:*)
	resolvedOptions = Normal[
		RoundOptionPrecision[
			Association[resolvedOptionsWithoutRounding],
			{
				(*1*)PreFlushingSolutionDrainTime,
				(*2*)MaxPreFlushingSolutionDrainTime,
				(*3*)ConditioningSolutionDrainTime,
				(*4*)MaxConditioningSolutionDrainTime,
				(*5*)LoadingSampleDrainTime,
				(*6*)MaxLoadingSampleDrainTime,
				(*7*)WashingSolutionDrainTime,
				(*8*)MaxWashingSolutionDrainTime,
				(*9*)SecondaryWashingSolutionDrainTime,
				(*10*)MaxSecondaryWashingSolutionDrainTime,
				(*11*)TertiaryWashingSolutionDrainTime,
				(*12*)MaxTertiaryWashingSolutionDrainTime,
				(*13*)ElutingSolutionDrainTime,
				(*14*)MaxElutingSolutionDrainTime,
				(*15*)PreFlushingSolutionVolume,
				(*16*)ConditioningSolutionVolume,
				(*17*)LoadingSampleVolume,
				(*18*)WashingSolutionVolume,
				(*19*)SecondaryWashingSolutionVolume,
				(*20*)TertiaryWashingSolutionVolume,
				(*21*)ElutingSolutionVolume
			},
			{
				(*1*)10^-1 Minute,
				(*2*)10^-1 Minute,
				(*3*)10^-1 Minute,
				(*4*)10^-1 Minute,
				(*5*)10^-1 Minute,
				(*6*)10^-1 Minute,
				(*7*)10^-1 Minute,
				(*8*)10^-1 Minute,
				(*9*)10^-1 Minute,
				(*10*)10^-1 Minute,
				(*11*)10^-1 Minute,
				(*12*)10^-1 Minute,
				(*13*)10^-1 Minute,
				(*14*)10^-1 Minute,
				(*15*)10^0 Microliter,
				(*16*)10^0 Microliter,
				(*17*)10^0 Microliter,
				(*18*)10^0 Microliter,
				(*19*)10^0 Microliter,
				(*20*)10^0 Microliter,
				(*21*)10^0 Microliter
			},
			Messages -> False,
			AvoidZero -> True
		],
		Association
	];

	(* with current SamplePreparation script, we cannot allow Robotic and Manual sample prep run at the same time, so if we find that we have to throw error *)
	noDupPreparation = DeleteDuplicates[mtPreparation];
	bothManualAndRoboticError = If[Length[noDupPreparation] > 1,
		True,
		False
	];
	(* TODO add error and test here *)

	(* ERROR and WARNING messages to user *)
	(* ERRORs *)
	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameValidBool = TrueQ[DatabaseMemberQ[Append[Object[Protocol, SolidPhaseExtraction], unresolvedName]]];
	(* NOTE: unique *)
	(* If the name is invalid, will add it to the list if invalid options later *)
	nameOptionInvalid = If[nameValidBool, Name, Nothing];
	nameUniquenessTest = If[nameValidBool,
		(* Give a failing test or throw a message if the user specified a name that is in use *)
		If[gatherTests,
			Test["The specified name is unique.", False, True],
			Message[Error::DuplicateName, Object[Protocol, SolidPhaseExtraction]];
			Nothing
		],
		(* Give a passing test or do nothing otherwise. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[unresolvedName],
			Test["The specified name is unique.", False, True],
			Nothing
		]
	];
	(* check if the Loading Sample volume is more than what the sammples have or not *)
	If[MemberQ[Flatten[mtvolumeTooLargeWarning], True] && messages,
		Module[{requestedVolume, volumeTooSmall, sampleTooSmall},
			requestedVolume = PickList[Flatten[Lookup[resolvedOptions, LoadingSampleVolume]], Flatten[mtvolumeTooLargeWarning]];
			volumeTooSmall = PickList[Flatten[actualSampleVolumes], Flatten[mtvolumeTooLargeWarning]];
			sampleTooSmall = PickList[Flatten[myPooledSamples], Flatten[mtvolumeTooLargeWarning]];
			Message[Error::TooLargeRequestVolume, ToString[requestedVolume], ToString[volumeTooSmall], sampleTooSmall]
		]
	];
	mtvolumeTooLargeWarningOptionsName = If[MemberQ[Flatten[mtvolumeTooLargeWarning], True], {LoadingSampleVolume}, {}];
	tooLargeLoadingSampleVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[mtvolumeTooLargeWarningOptionsName] > 0,
				Test["The requested" <> ToString[mtvolumeTooLargeWarningOptionsName] <> " is more than the volume of SamplesIn", True, False],
				Nothing
			];

			passingTest = If[Length[mtvolumeTooLargeWarningOptionsName] == 0,
				Test["There is enough sample for requested LoadingSampleVolume", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];
	(* with all the mobile phase option, we have to check if we can try to support it or not *)
	If[MemberQ[Flatten[mtnoCompatibleInstrumentError], True] && messages,
		Module[{badvalue, badoptions},
			badvalue = PickList[myPooledSamples, Flatten[mtnoCompatibleInstrumentError]];
			badoptions = PickList[mtnoCompatibleInstrumentErrorName, Flatten[mtnoCompatibleInstrumentError]];
			Message[Error::SPECannotSupportSamples, ToString[badvalue], ToString[badoptions]]
		]
	];
	mtnoCompatibleInstrumentErrorTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtnoCompatibleInstrumentError], True],
				Test["SolidPhaseExtraction cannot find supporting Instrument for SamplesIn " <>
					ToString[PickList[myPooledSamples, Flatten[mtnoCompatibleInstrumentError]]],
					True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtnoCompatibleInstrumentError], True]],
				Test["SolidPhaseExtraction can support the supplied SamplesIn", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];
	(* conflicting options, between instrument and mobile phase *)
	If[MemberQ[Flatten[mtconflictingMethodInferringMobilePhaseOptionsError], True] && messages,
		Module[{badoptionname},
			badoptionname = PickList[mtconflictingMobilePhaseOptionName, Flatten[mtconflictingMethodInferringMobilePhaseOptionsError]];
			Message[Error::ConflictingMobilePhaseOptions, ToString[badoptionname]]
		]
	];
	conflictingMethodInferringMobilePhaseOptionsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtconflictingMethodInferringMobilePhaseOptionsError], True],
				Test["The following options are incompatible " <> ToString[mtconflictingMobilePhaseOptionName], True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtconflictingMethodInferringMobilePhaseOptionsError], True]],
				Test["All solution options are compatible", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* test if extractionMethod and any of Mobile phase options are confliting or not *)
	If[MemberQ[Flatten[mtconflictingSuppliedMethodAndImpliedMethodError], True] && messages,
		Module[{badoptionname},
			badoptionname = PickList[mtconflictingSuppliedMethodAndImpliedMethodErrorOptionName,
				Flatten[mtconflictingSuppliedMethodAndImpliedMethodError]];
			Message[Error::ConflictingMobilePhaseOptions, ToString[badoptionname]]
		]
	];
	mtconflictingSuppliedMethodAndImpliedMethodErrorTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtconflictingSuppliedMethodAndImpliedMethodError], True],
				Test["The following options are incompatible " <> ToString[mtconflictingSuppliedMethodAndImpliedMethodErrorOptionName], True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtconflictingSuppliedMethodAndImpliedMethodError], True]],
				Test["All solution options are compatible", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];
	(* check if any of the loading sample volume go above what SPE as a whole can take or not *)
	If[MemberQ[Flatten[mtspeCannotSupportVolumeError], True] && messages,
		Module[{badoptionvalue},
			badoptionvalue = PickList[mtbadLoadingSampleVolume, Flatten[mtspeCannotSupportVolumeError]];
			Message[Error::SPECannotSupportVolume, ToString[badoptionvalue]]
		]
	];
	mtspeCannotSupportVolumeErrorOptionName = If[MemberQ[Flatten[mtspeCannotSupportVolumeError], True], {LoadingSampleVolume}, {}];
	mtspeCannotSupportVolumeErrorTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtspeCannotSupportVolumeError], True],
				Test["LoadingSampleVolume cannot be supported by SolidPhaseExtraction.", True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtspeCannotSupportVolumeError], True]],
				Test["LoadingSampleVolume can supported by SolidPhaseExtraction.", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];
	(* *)
	If[MemberQ[Flatten[mtspeCannotSupportCollectionError], True] && messages,
		Module[{badnumber, badoptions},
			badnumber = PickList[mtnumberOfCollection, Flatten[mtspeCannotSupportVolumeError]];
			badoptions = PickList[mtimpliedCollectionNameError, Flatten[mtspeCannotSupportVolumeError]];
			Message[Error::SPECannotSupportNumberOfCollection, badnumber, badoptions]
		]
	];
	mtspeCannotSupportCollectionOptionName = If[MemberQ[Flatten[mtspeCannotSupportCollectionError], True],
		{Flatten[mtimpliedCollectionNameError]},
		{}
	];

	mtspeCannotSupportCollectionTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtspeCannotSupportCollectionError], True],
				Test["SolidPhaseExtraction cannot support more than 7 collection steps.", True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtspeCannotSupportVolumeError], True]],
				Test["SolidPhaseExtraction can support requested collection steps.", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	If[MemberQ[Flatten[mtspeCannotSupportCartridgeError], True] && messages,
		Module[{badcartridge, badoptions},
			badcartridge = PickList[Flatten[Lookup[resolvedOptions, ExtractionCartridge]], Flatten[mtspeCannotSupportCartridgeError]];
			Message[Error::SPECannotSupportCartridge, badcartridge]
		]
	];
	mtspeCannotSupportCartridgeOptionName = If[MemberQ[Flatten[mtspeCannotSupportCartridgeError], True],
		{ExtractionCartridge},
		{}
	];
	mtspeCannotSupportCartridgeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtspeCannotSupportCartridgeError], True],
				Test["SolidPhaseExtraction cannot support the following ExtractionCartridge " <> ToString[PickList[Flatten[Lookup[resolvedOptions, ExtractionCartridge]], Flatten[mtspeCannotSupportCartridgeError]]], True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtspeCannotSupportCartridgeError], True]],
				Test["SolidPhaseExtraction can support the supply ExtractionCartridge", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	If[MemberQ[Flatten[mtspeCannotSupportMethodError], True] && messages,
		Module[{badmethod, badoptions},
			badmethod = PickList[Flatten[Lookup[resolvedOptions, ExtractionMethod]], Flatten[mtspeCannotSupportMethodError]];
			Message[Error::SPECannotSupportExtractionMethod, badmethod]
		]
	];
	mtspeCannotSupportMethodOptionName = If[MemberQ[Flatten[mtspeCannotSupportCartridgeError], True],
		{ExtractionMethod},
		{}
	];
	mtspeCannotSupportMethodTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtspeCannotSupportMethodError], True],
				Test["SolidPhaseExtraction cannot support the following ExtractionMethod " <>
					ToString[PickList[Flatten[Lookup[resolvedOptions, ExtractionMethod]], Flatten[mtspeCannotSupportMethodError]]],
					True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtspeCannotSupportMethodError], True]],
				Test["SolidPhaseExtraction can support the supply ExtractionMethod", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* check if the cartridge is too large for the instrument or not *)
	Module[{badvalue, badinstrument},
		If[MemberQ[Flatten[mttooBigCartridgeError], True] && messages,
			badvalue = PickList[Lookup[resolvedOptions, ExtractionCartridge], Flatten[mttooBigCartridgeError]];
			badinstrument = PickList[Lookup[resolvedOptions, Instrument], Flatten[mttooBigCartridgeError]];
			Message[Error::SPEExtractionCartidgeTooLargeForInstrument, ToString[badvalue], ToString[badinstrument]]
		];
		mttooBigCartridgeErrorOptionName = If[MemberQ[Flatten[mttooBigCartridgeError], True],
			{ExtractionCartridge},
			{}
		];
		mttooBigCartridgeErrorTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[Flatten[mttooBigCartridgeError], True],
					Test["ExtractionCartridge " <> ToString[badvalue] <> " are too big for Instrument " <> ToString[badInstrument], True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mtnoCompatibleInstrumentError], True]],
					Test["All ExtractionCartridge can fit in SolidPhaseExtraction Instrument", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];
	(* warning for mismatch cartridge and sorbent *)
	Module[{badvalue, badsorbent},
		If[MemberQ[Flatten[mtconflictingCartridgeSorbentWarning], True] && messages,
			badvalue = PickList[Lookup[resolvedOptions, ExtractionCartridge], Flatten[mtconflictingCartridgeSorbentWarning]];
			badsorbent = PickList[Lookup[resolvedOptions, ExtractionSorbent], Flatten[mtconflictingCartridgeSorbentWarning]];
			Message[Warning::SPEExtractionCartridgeAndSorbentMismatch, ToString[badvalue], ToString[badsorbent]]
		];
	];
	(* warning when running extraction strategy negative but washing is turned on *)
	If[MemberQ[Flatten[mtwarningVolumeTooHigh], True] && messages,
		Module[{badvalue, badinstrument},
			badvalue = PickList[Lookup[resolvedOptions, LoadingSampleVolume], Flatten[mtwarningVolumeTooHigh]];
			badinstrument = PickList[Flatten[Lookup[resolvedOptions, Instrument]], Flatten[mtwarningVolumeTooHigh]];
			Message[Error::SPELoadingSampleVolumeTooHighInstrument, ToString[badvalue], ToString[badinstrument]]
		]
	];
	mtwarningVolumeTooHighOptionName = If[MemberQ[Flatten[mtwarningVolumeTooHigh], True],
		{LoadingSampleVolume, Instrument},
		{}
	];
	mtwarningVolumeTooHighErrorTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[Flatten[mtwarningVolumeTooHigh], True],
				Test["SolidPhaseExtraction cannot find supporting Instrument for " <>
					ToString[PickList[Flatten[Lookup[resolvedOptions, LoadingSampleVolume]], Flatten[mtwarningVolumeTooHigh]]],
					True, False],
				Nothing
			];
			passingTest = If[Not[MemberQ[Flatten[mtwarningVolumeTooHigh], True]],
				Test["SolidPhaseExtraction can support the supply LoadingSampleVolume", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	badCentrifugeIntensityOptionName = Flatten[MapThread[
		Module[{badvalue, badOption, badInstrument, badCentrifugeOptionName},
			If[MemberQ[#2, True] && messages,
				badvalue = PickList[Flatten[Lookup[resolvedOptions, #1]], #2];
				badOption = #1;
				badInstrument = PickList[Flatten[Lookup[resolvedOptions, Instrument]], #2];
				Message[Error::SPECentrifugeIntensityTooHigh, badvalue, badInstrument, badOption]
			];
			If[MemberQ[#2, True], {#1}, {}]
		]&,
		{
			{
				PreFlushingSolutionCentrifugeIntensity,
				ConditioningSolutionCentrifugeIntensity,
				WashingSolutionCentrifugeIntensity,
				SecondaryWashingSolutionCentrifugeIntensity,
				TertiaryWashingSolutionCentrifugeIntensity,
				ElutingSolutionCentrifugeIntensity,
				LoadingSampleCentrifugeIntensity
			},
			{
				preFlushingSolutionCentrifugeIntensityError,
				conditioningSolutionCentrifugeIntensityError,
				washingSolutionCentrifugeIntensityError,
				secondaryWashingSolutionCentrifugeIntensityError,
				tertiaryWashingSolutionCentrifugeIntensityError,
				elutingSolutionCentrifugeIntensityError,
				loadingSampleCentrifugeIntensityError
			}
		}
	]];
	centrifugeIntensityTest = Map[
		If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[Flatten[mtspeCannotSupportMethodError], True],
					Test["SolidPhaseExtraction cannot support the following ExtractionMethod " <>
						ToString[PickList[Flatten[Lookup[resolvedOptions, ExtractionMethod]], Flatten[mtspeCannotSupportMethodError]]],
						True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mtspeCannotSupportMethodError], True]],
					Test["SolidPhaseExtraction can support the supply ExtractionMethod", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		]&,
		(badCentrifugeIntensityOptionName /. {} -> Nothing)
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	unequalLengthPooledSamplesInOptionsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[pooledLengthErrorOptionName] > 0,
				Nothing,
				Test["The pooled Options " <> ToString[pooledLengthErrorOptionName] <> " do not have equal length as SamplesIn", True, False]
			];
			passingTest = If[Length[pooledLengthErrorOptionName] == 0,
				Test["The pooled options have equal length as SamplesIn", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	incompatibleInstrumentAndMethodErrorOptionName = If[MemberQ[mtincompatibleInstrumentAndMethodError, True],
		{Instrument, ExtractionMethod},
		{}
	];
	If[MemberQ[mtincompatibleInstrumentAndMethodError, True] && messages,
		badInstrument = PickList[Lookup[mapThreadFriendlyOptions, Instrument], mtincompatibleInstrumentAndMethodError];
		badExtractionMethod = PickList[Lookup[mapThreadFriendlyOptions, ExtractionMethod], mtincompatibleInstrumentAndMethodError];
		badValue = DeleteDuplicates[Transpose[{badInstrument, badExtractionMethod}]];
		Message[Error::incompatibleInstrumentAndMethodError, badValue[[;;, 1]], badValue[[;;, 2]], incompatibleInstrumentAndMethodErrorOptionName];
	];
	incompatibleInstrumentAndMethodErrorOptionNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[incompatibleInstrumentAndMethodErrorOptionName] > 0,
				Test["The following Instrument " <> ObjectToString[DeleteDuplicates[badInstrument], Cache -> simulatedCache] <>
					"cannot support the selected ExtractionMethod " <> ToString[DeleteDuplicates[badExtractionMethod]], True, False],
				Nothing
			];

			passingTest = If[Length[incompatibleInstrumentAndMethodErrorOptionName] == 0,
				Test["The following Instrument can support the supplied ExtractionMethod", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	incompatibleInstrumentAndExtractionCartridgeErrorOptionName = If[MemberQ[mtincompatibleInstrumentAndExtractionCartridgeError, True],
		{Instrument, ExtractionCartridge},
		{}
	];
	If[MemberQ[mtincompatibleInstrumentAndExtractionCartridgeError, True] && messages,
		badInstrument = PickList[Lookup[mapThreadFriendlyOptions, Instrument], mtincompatibleInstrumentAndExtractionCartridgeError];
		badExtractionCartridge = PickList[Lookup[mapThreadFriendlyOptions, ExtractionCartridge], mtincompatibleInstrumentAndExtractionCartridgeError];
		badValue = DeleteDuplicates[Transpose[{badInstrument, badExtractionCartridge}]];
		Message[Error::incompatibleInstrumentAndCartridgeError, badValue[[;;, 1]], badValue[[;;, 2]], incompatibleInstrumentAndExtractionCartridgeErrorOptionName];
	];
	incompatibleInstrumentAndExtractionCartridgeErrorOptionNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[incompatibleInstrumentAndExtractionCartridgeErrorOptionName] > 0,
				Test["The following Instrument " <> ObjectToString[DeleteDuplicates[badInstrument], Cache -> simulatedCache] <>
					"cannot support the supplied ExtractionCartridge " <> ObjectToString[DeleteDuplicates[badExtractionCartridge], Cache -> simulatedCache], True, False],
				Nothing
			];

			passingTest = If[Length[incompatibleInstrumentAndExtractionCartridgeErrorOptionName] == 0,
				Test["The Instrument can support the supplied ExtractionCartridge", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName = If[MemberQ[mtincompatibleExtractionMethodAndExtractionCartridgeError, True],
		{ExtractionMethod, ExtractionCartridge},
		{}
	];
	If[MemberQ[mtincompatibleExtractionMethodAndExtractionCartridgeError, True] && messages,
		badExtractionMethod = PickList[Lookup[mapThreadFriendlyOptions, ExtractionMethod], mtincompatibleExtractionMethodAndExtractionCartridgeError];
		badExtractionCartridge = PickList[Lookup[mapThreadFriendlyOptions, ExtractionCartridge], mtincompatibleExtractionMethodAndExtractionCartridgeError];
		badValue = DeleteDuplicates[Transpose[{badExtractionMethod, badExtractionCartridge}]];
		Message[Error::incompatibleExtractionMethodAndExtractionCartridgeError, badValue[[;;, 2]], badValue[[;;, 1]], incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName];
	];
	incompatibleExtractionMethodAndExtractionCartridgeErrorNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName] > 0,
				Test["The following ExtrationMethod " <> ToString[DeleteDuplicates[badExtractionMethod]] <>
					"cannot be performed with the supplied ExtractionCartridge " <> ObjectToString[DeleteDuplicates[badExtractionCartridge], Cache -> simulatedCache], True, False],
				Nothing
			];

			passingTest = If[Length[incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName] == 0,
				Test["The supplied ExtractionMethod can support the supplied ExtractionCartridge", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw error when Instrument, ExtractionCartridge, ExtractionMethod are in conflict *)
	incompatibleInstrumentExtractionMethodExtractionCartridgeErrorOptionName = If[MemberQ[mtincompatibleInstrumentExtractionMethodExtractionCartridgeError, True],
		{Instrument, ExtractionMethod, ExtractionCartridge},
		{}
	];
	If[MemberQ[mtincompatibleInstrumentExtractionMethodExtractionCartridgeError, True] && messages,
		{badInstrument, badExtractionMethod, badExtractionCartridge} = Map[PickList[Lookup[mapThreadFriendlyOptions, #], mtincompatibleInstrumentExtractionMethodExtractionCartridgeError]&, {Instrument, ExtractionMethod, ExtractionCartridge}];
		badValue = DeleteDuplicates[Transpose[{badInstrument, badExtractionMethod, badExtractionCartridge}]];
		Message[Error::incompatibleInstrumentExtractionMethodExtractionCartridgeError, badValue[[;;, 1]], badValue[[;;, 3]], badValue[[;;, 2]], incompatibleInstrumentExtractionMethodExtractionCartridgeErrorOptionName];
	];
	incompatibleExtractionMethodAndExtractionCartridgeErrorOptionNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName] > 0,
				Test["The following Instrument " <> ObjectToString[DeleteDuplicates[badInstrument], Cache -> simulatedCache] <>
					"cannot be performed SolidPhaseExtraction with ExtractionMethod " <> ToString[DeleteDuplicates[badExtractionMethod]] <>
					"with the supplied ExtractionCartridge " <> ObjectToString[DeleteDuplicates[badExtractionCartridge], Cache -> simulatedCache], True, False],
				Nothing
			];
			passingTest = If[Length[incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName] == 0,
				Test["The Instrument can perform SolidPhaseExtraction with supplied ExtractionMethod and supplied ExtractionCartridge ", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw warning when Washing swtich is True for index that ExtractionStrategy is Negative *)
	If[MemberQ[mtwarningExtractionStrategyWashingSwitchIncompatible, True] && messages,
		Message[Warning::ExtractionStrategyWashingSwitchIncompatible, ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategyWashingSwitchIncompatible], Cache -> simulatedCache]];
	];
	warningExtractionStrategyWashingSwitchIncompatibleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[mtwarningExtractionStrategyWashingSwitchIncompatible, True],
				Nothing,
				Warning["ExtractionStrategy Negative for SamplesIn " <> ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategyWashingSwitchIncompatible], Cache -> simulatedCache]
					<> " are now switched to Positive because Washing is set to True or WashingSolution was defined.", True, False]
			];
			passingTest = If[Not[MemberQ[mtwarningExtractionStrategyWashingSwitchIncompatible, True]],
				Warning["ExtractionStrategy Negative as Washing is set to False or WashingSolution was not defined.", True, True],
				Nothing

			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* when Secondary wash was defined while  Washing is not used throw an error *)
	skippedWashingErrorOptionName = If[MemberQ[mtskippedWashingError, True],
		(* this could happen for 2 reason, either user trigger Washing to True, or define WashingSolution, no matter what we check what acctually trigger this error and tell them *)
		possibleOptionName = {SecondaryWashing, SecondaryWashingSolution};
		{badWashing, badWashingSolution} = Map[PickList[Lookup[mapThreadFriendlyOptions, #], mtskippedWashingError]&, possibleOptionName];
		useBadWashing = If[MemberQ[badWashing, True], True, False];
		useBadWashingSolution = If[MemberQ[badWashingSolution, ObjectP[]], True, False];

		PickList[possibleOptionName, {useBadWashing, useBadWashingSolution}],
		{}
	];
	If[MemberQ[mtskippedWashingError, True] && messages,
		Message[Error::skippedWashingError, skippedWashingErrorOptionName]
	];
	skippedWashingErrorOptionNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[MemberQ[mtskippedWashingError, True]],
				Nothing,
				Test["SecondaryWashing step is used, while the Washing step has not been used yet. Please change the following Options "
					<> ToString[skippedWashingErrorOptionName] <> " to Automatic or set Washing Option to True", True, False]
			];
			passingTest = If[Not[MemberQ[mtskippedWashingError, True]],
				Test["SecondaryWashing step is used with Washing set to True or WashingSolution is defined"  True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw warning when SecondaryWashing swtich is True for index that ExtractionStrategy is Negative *)
	If[MemberQ[mtwarningExtractionStrategySecondaryWashingSwitchIncompatible, True] && messages,
		Message[Warning::ExtractionStrategySecondaryWashingSwitchIncompatible, ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategySecondaryWashingSwitchIncompatible], Cache -> simulatedCache]];
	];
	warningExtractionStrategySecondaryWashingSwitchIncompatibleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[mtwarningExtractionStrategySecondaryWashingSwitchIncompatible, True],
				Nothing,
				Warning["ExtractionStrategy Negative for SamplesIn " <> ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategySecondaryWashingSwitchIncompatible], Cache -> simulatedCache] <>
					" are now switched to Positive because SecondaryWashing is set to True or SecondaryWashingSolution was defined.", True, False]
			];
			passingTest = If[Not[MemberQ[mtwarningExtractionStrategySecondaryWashingSwitchIncompatible, True]],
				Warning["ExtractionStrategy Negative as SecondaryWashing is set to False or SecondaryWashingSolution was not defined.", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* when Tertiary wash was defined while SecondaryWashing is not used throw an error *)
	skippedSecondaryWashingErrorOptionName = If[MemberQ[mtskippedSecondaryWashingError, True],
		(* this could happen for 2 reason, either user trigger Washing to True, or define WashingSolution, no matter what we check what acctually trigger this error and tell them *)
		possibleOptionName = {TertiaryWashing, TertiaryWashingSolution};
		{badSecondaryWashing, badSecondaryWashingSolution} = Map[PickList[Lookup[mapThreadFriendlyOptions, #], mtskippedSecondaryWashingError]&, possibleOptionName];
		useBadSecondaryWashing = If[MemberQ[badSecondaryWashing, True], True, False];
		useBadSecondaryWashingSolution = If[MemberQ[badSecondaryWashingSolution, ObjectP[]], True, False];

		PickList[possibleOptionName, {useBadSecondaryWashing, useBadSecondaryWashingSolution}],
		{}
	];
	If[MemberQ[mtskippedSecondaryWashingError, True] && messages,
		Message[Error::skippedSecondaryWashingError, skippedSecondaryWashingErrorOptionName]
	];
	skippedSecondaryWashingErrorOptionNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Not[MemberQ[mtskippedWashingError, True]],
				Nothing,
				Test["TertiaryWashing step is used, while the SecondaryWashing step has not been used yet. Please change the following Options "
					<> ToString[skippedSecondaryWashingErrorOptionName] <> " to Automatic or set SecondaryWashing Option to True", True, False]
			];
			passingTest = If[MemberQ[MemberQ[mtskippedWashingError, True]],
				Test["TertiaryWashing step is used, while the SecondaryWashing is used.", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw warning when TertiaryWashing swtich is True for index that ExtractionStrategy is Negative *)
	If[MemberQ[mtwarningExtractionStrategyTertiaryWashingSwitchIncompatible, True] && messages,
		Message[Warning::ExtractionStrategyTertiaryWashingSwitchIncompatible, ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategyTertiaryWashingSwitchIncompatible], Cache -> simulatedCache]];
	];
	warningExtractionStrategyTertiaryWashingSwitchIncompatibleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Not[MemberQ[mtwarningExtractionStrategySecondaryWashingSwitchIncompatible, True]],
				Nothing,
				Warning["ExtractionStrategy Negative for SamplesIn " <>
					ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategyTertiaryWashingSwitchIncompatible], Cache -> simulatedCache] <>
					" are now switched to Positive because TertiaryWashing is set to True or TertiaryWashingSolution was defined.", True, False]
			];
			passingTest = If[MemberQ[mtwarningExtractionStrategySecondaryWashingSwitchIncompatible, True],
				Warning["ExtractionStrategy Negative is used while SecondaryWashing is not defined.", True, True],
				Nothing

			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* if user specifically say False for eluting in Positive strategy, then we have to warn them that it is weird*)
	If[MemberQ[mtwarningPositiveStrategyWithoutEluting, True] && messages,
		Message[Warning::PositiveStrategyWithoutEluting, ObjectToString[PickList[myPooledSamples, mtwarningPositiveStrategyWithoutEluting], Cache -> simulatedCache]];
	];
	warningExtractionStrategyTertiaryWashingSwitchIncompatibleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Not[MemberQ[mtwarningPositiveStrategyWithoutEluting, True]],
				Nothing,
				Warning["ExtractionStrategy for SamplesIn " <> ObjectToString[PickList[myPooledSamples, mtwarningPositiveStrategyWithoutEluting], Cache -> simulatedCache] <>
					" are Positive but Eluting is False.", True, False]
			];
			passingTest = If[MemberQ[mtwarningPositiveStrategyWithoutEluting, True],
				Warning["ExtractionStrategy Negative is used while TertiaryWashing is not defined.", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* throw warning when Eluting swtich is True for index that ExtractionStrategy is Negative *)
	If[MemberQ[mtwarningExtractionStrategyElutingIncompatible, True] && messages,
		Message[Warning::mtwarningExtractionStrategyElutingIncompatible, ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategyElutingIncompatible], Cache -> simulatedCache]];
	];
	warningExtractionStrategyElutingIncompatibleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Not[MemberQ[mtwarningExtractionStrategyElutingIncompatible, True]],
				Nothing,
				Warning["ExtractionStrategy for SamplesIn " <> ObjectToString[PickList[myPooledSamples, mtwarningExtractionStrategyElutingIncompatible], Cache -> simulatedCache]
					<> " are now Positive because Eluting is set to True or ElutingSolution was defined.", True, False]
			];
			passingTest = If[MemberQ[mtwarningExtractionStrategyElutingIncompatible, True],
				Warning["ExtractionStrategy Negative is used while Eluting is not defined.", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw error for pressure options *)
	errorPreFlushingPressureOptionName = If[MemberQ[mterrorPreFlushingPressureTooLow, True] || MemberQ[mterrorPreFlushingPressureTooHigh, True],
		{PreFlushingSolutionPressure},
		{}
	];
	errorConditioningPressureOptionName = If[MemberQ[mterrorConditioningPressureTooLow, True] || MemberQ[mterrorConditioningPressureTooHigh, True],
		{ConditioningSolutionPressure},
		{}
	];
	errorWashingPressureOptionName = If[MemberQ[mterrorWashingPressureTooLow, True] || MemberQ[mterrorWashingPressureTooHigh, True],
		{WashingSolutionPressure},
		{}
	];
	errorSecondaryWashingPressureOptionName = If[MemberQ[mterrorSecondaryWashingPressureTooLow, True] || MemberQ[mterrorSecondaryWashingPressureTooHigh, True],
		{SecondaryWashingSolutionPressure},
		{}
	];
	errorTertiaryWashingPressureOptionName = If[MemberQ[mterrorTertiaryWashingPressureTooLow, True] || MemberQ[mterrorTertiaryWashingPressureTooHigh, True],
		{TertiaryWashingSolutionPressure},
		{}
	];
	errorElutingPressureOptionName = If[MemberQ[mterrorElutingPressureTooLow, True] || MemberQ[mterrorElutingPressureTooHigh, True],
		{ElutingSolutionPressure},
		{}
	];
	errorLoadingSamplePressureOptionName = If[MemberQ[mterrorLoadingSamplePressureTooLow, True] || MemberQ[mterrorLoadingSamplePressureTooHigh, True],
		{LoadingSamplePressure},
		{}
	];
	allPressureOption = {PreFlushingSolutionPressure, ConditioningSolutionPressure, WashingSolutionPressure, SecondaryWashingSolutionPressure, TertiaryWashingSolutionPressure, ElutingSolutionPressure, LoadingSamplePressure};
	allPressureErrorOptionName = {errorPreFlushingPressureOptionName, errorConditioningPressureOptionName, errorWashingPressureOptionName, errorSecondaryWashingPressureOptionName, errorTertiaryWashingPressureOptionName, errorElutingPressureOptionName, errorLoadingSamplePressureOptionName};
	allPressureErrorSwitch = {mterrorPreFlushingPressureTooLow, mterrorPreFlushingPressureTooHigh, mterrorConditioningPressureTooLow, mterrorConditioningPressureTooHigh, mterrorWashingPressureTooLow, mterrorWashingPressureTooHigh, mterrorSecondaryWashingPressureTooLow, mterrorSecondaryWashingPressureTooHigh, mterrorTertiaryWashingPressureTooLow, mterrorTertiaryWashingPressureTooHigh, mterrorElutingPressureTooLow, mterrorElutingPressureTooHigh, mterrorLoadingSamplePressureTooLow, mterrorLoadingSamplePressureTooHigh};
	allPressureErrorQ = MemberQ[Flatten[allPressureErrorSwitch], True];
	If[MatchQ[allPressureErrorQ, True] && messages,
		badPressure = Flatten[Map[MemberQ[#, True]&, Transpose[allPressureErrorSwitch]]];
		badInstrument = DeleteDuplicates[PickList[mtInstrument, badPressure]];
		badInstrumentModel = Map[
			If[MatchQ[#, ObjectP[Object]],
				cacheLookup[simulatedCache, #, Model],
				#
			]&,
			badInstrument
		];
		lowLimitPressureInstrument = cacheLookup[simulatedCache, badInstrumentModel, MinPressure];
		highLimitPressureInstrument = cacheLookup[simulatedCache, badInstrumentModel, MaxPressure];
		limitPressureInstrument = Transpose[{lowLimitPressureInstrument, highLimitPressureInstrument}];
		badSuppliedPressure = MapThread[
			If[MatchQ[#1, Except[{}]],
				PickList[Lookup[resolvedOptions, #2], badPressure],
				Nothing
			]&,
			{allPressureErrorOptionName, allPressureOption}
		];
		(*issue error*)
		Message[Error::PressureOutOfBound, badInstrument, limitPressureInstrument, Flatten[Cases[allPressureErrorOptionName, Except[{}]]], badSuppliedPressure]
	];
	pressureOutOfBoundTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[badInstrument] > 0,
				Nothing,
				Test["The Pressure supplied for the following Instrument" <> ObjectToString[badInstrument, Cache -> simulatedCache] <>
					" out of Instrument boundary", True, False]
			];
			passingTest = If[Length[badInstrument] == 0,
				Warning["Thre Pressure Options supplied are compatible with the Instrument", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw error for pressure options *)
	errorPreFlushingPressureMustBeBooleanOptionName = If[MemberQ[mtwarningPreFlushingPressureMustBeBoolean, True],
		{PreFlushingSolutionPressure},
		{}
	];
	errorConditioningPressureMustBeBooleanOptionName = If[MemberQ[mtwarningConditioningPressureMustBeBoolean, True],
		{ConditioningSolutionPressure},
		{}
	];
	errorWashingPressureMustBeBooleanOptionName = If[MemberQ[mtwarningWashingPressureMustBeBoolean, True],
		{WashingSolutionPressure},
		{}
	];
	errorSecondaryWashingPressureMustBeBooleanOptionName = If[MemberQ[mtwarningSecondaryWashingPressureMustBeBoolean, True],
		{SecondaryWashingSolutionPressure},
		{}
	];
	errorTertiaryWashingPressureMustBeBooleanOptionName = If[MemberQ[mtwarningTertiaryWashingPressureMustBeBoolean, True],
		{TertiaryWashingSolutionPressure},
		{}
	];
	errorElutingPressureMustBeBooleanOptionName = If[MemberQ[mtwarningElutingPressureMustBeBoolean, True],
		{ElutingSolutionPressure},
		{}
	];
	errorLoadingSamplePressureMustBeBooleanOptionName = If[MemberQ[mtwarningLoadingSamplePressureMustBeBoolean, True],
		{LoadingSamplePressure},
		{}
	];
	allPressureMustBeBooleanOption = {PreFlushingSolutionPressure, ConditioningSolutionPressure, WashingSolutionPressure, SecondaryWashingSolutionPressure, TertiaryWashingSolutionPressure, ElutingSolutionPressure, LoadingSamplePressure};
	allPressureMustBeBooleanOptionName = {
		errorPreFlushingPressureMustBeBooleanOptionName,
		errorConditioningPressureMustBeBooleanOptionName,
		errorWashingPressureMustBeBooleanOptionName,
		errorSecondaryWashingPressureMustBeBooleanOptionName,
		errorTertiaryWashingPressureMustBeBooleanOptionName,
		errorElutingPressureMustBeBooleanOptionName,
		errorLoadingSamplePressureMustBeBooleanOptionName};
	allPressureMustBeBooleanSwitch = {mtwarningPreFlushingPressureMustBeBoolean,
		mtwarningConditioningPressureMustBeBoolean,
		mtwarningWashingPressureMustBeBoolean,
		mtwarningSecondaryWashingPressureMustBeBoolean,
		mtwarningTertiaryWashingPressureMustBeBoolean,
		mtwarningElutingPressureMustBeBoolean,
		mtwarningLoadingSamplePressureMustBeBoolean};
	allPressureMustBeBooleanQ = MemberQ[Flatten[allPressureMustBeBooleanSwitch], True];
	If[MatchQ[allPressureMustBeBooleanQ, True] && messages,
		badPressure = Flatten[Map[MemberQ[#, True]&, Transpose[allPressureMustBeBooleanSwitch]]];
		badInstrument = DeleteDuplicates[PickList[mtInstrument, badPressure]];
		badInstrumentModel = Map[
			If[MatchQ[#, ObjectP[Object]],
				cacheLookup[simulatedCache, #, Model],
				#
			]&,
			badInstrument
		];
		(*issue error*)
		Message[Warning::PressureMustBeBoolean, badInstrument, Flatten[DeleteDuplicates[allPressureMustBeBooleanOptionName]]]
	];
	pressureMustBeBooleanTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[badInstrument] > 0,
				Nothing,
				Warning["The Pressure supplied for the following Instrument" <> ObjectToString[badInstrument, Cache -> simulatedCache] <>
					" must be True or False", True, False]
			];
			passingTest = If[Length[badInstrument] == 0,
				Warning["Thre Pressure Options supplied are compatible with the Instrument", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw error for DispenseRate options *)
	errorPreFlushingDispenseRateOptionName = If[MemberQ[mterrorPreFlushingDispenseRateTooLow, True] || MemberQ[mterrorPreFlushingDispenseRateTooHigh, True],
		{PreFlushingSolutionDispenseRate},
		{}
	];
	errorConditioningDispenseRateOptionName = If[MemberQ[mterrorConditioningDispenseRateTooLow, True] || MemberQ[mterrorConditioningDispenseRateTooHigh, True],
		{ConditioningSolutionDispenseRate},
		{}
	];
	errorWashingDispenseRateOptionName = If[MemberQ[mterrorWashingDispenseRateTooLow, True] || MemberQ[mterrorWashingDispenseRateTooHigh, True],
		{WashingSolutionDispenseRate},
		{}
	];
	errorSecondaryWashingDispenseRateOptionName = If[MemberQ[mterrorSecondaryWashingDispenseRateTooLow, True] || MemberQ[mterrorSecondaryWashingDispenseRateTooHigh, True],
		{SecondaryWashingSolutionDispenseRate},
		{}
	];
	errorTertiaryWashingDispenseRateOptionName = If[MemberQ[mterrorTertiaryWashingDispenseRateTooLow, True] || MemberQ[mterrorTertiaryWashingDispenseRateTooHigh, True],
		{TertiaryWashingSolutionDispenseRate},
		{}
	];
	errorElutingDispenseRateOptionName = If[MemberQ[mterrorElutingDispenseRateTooLow, True] || MemberQ[mterrorElutingDispenseRateTooHigh, True],
		{ElutingSolutionDispenseRate},
		{}
	];
	errorLoadingSampleDispenseRateOptionName = If[MemberQ[mterrorLoadingSampleDispenseRateTooLow, True] || MemberQ[mterrorLoadingSampleDispenseRateTooHigh, True],
		{LoadingSampleDispenseRate},
		{}
	];
	allDispenseRateOption = {PreFlushingSolutionDispenseRate, ConditioningSolutionDispenseRate, WashingSolutionDispenseRate, SecondaryWashingSolutionDispenseRate, TertiaryWashingSolutionDispenseRate, ElutingSolutionDispenseRate, LoadingSampleDispenseRate};
	allDispenseRateErrorOptionName = {errorPreFlushingDispenseRateOptionName, errorConditioningDispenseRateOptionName, errorWashingDispenseRateOptionName, errorSecondaryWashingDispenseRateOptionName, errorTertiaryWashingDispenseRateOptionName, errorElutingDispenseRateOptionName, errorLoadingSampleDispenseRateOptionName};
	allDispenseRateErrorSwitch = {mterrorPreFlushingDispenseRateTooLow, mterrorPreFlushingDispenseRateTooHigh, mterrorConditioningDispenseRateTooLow, mterrorConditioningDispenseRateTooHigh, mterrorWashingDispenseRateTooLow, mterrorWashingDispenseRateTooHigh, mterrorSecondaryWashingDispenseRateTooLow, mterrorSecondaryWashingDispenseRateTooHigh, mterrorTertiaryWashingDispenseRateTooLow, mterrorTertiaryWashingDispenseRateTooHigh, mterrorElutingDispenseRateTooLow, mterrorElutingDispenseRateTooHigh, mterrorLoadingSampleDispenseRateTooLow, mterrorLoadingSampleDispenseRateTooHigh};
	allDispenseRateErrorQ = MemberQ[Flatten[allDispenseRateErrorSwitch], True];
	If[MatchQ[allDispenseRateErrorQ, True] && messages,
		badDispenseRate = Flatten[Map[MemberQ[#, True]&, Transpose[allDispenseRateErrorSwitch]]];
		badInstrument = DeleteDuplicates[PickList[mtInstrument, badDispenseRate]];
		badInstrumentModel = Map[
			If[MatchQ[#, ObjectP[Object]],
				cacheLookup[simulatedCache, #, Model],
				#
			]&,
			badInstrument
		];
		lowLimitDispenseRateInstrument = cacheLookup[simulatedCache, badInstrumentModel, MinFlowRate];
		highLimitDispenseRateInstrument = cacheLookup[simulatedCache, badInstrumentModel, MaxFlowRate];
		limitDispenseRateInstrument = Transpose[{lowLimitDispenseRateInstrument, highLimitDispenseRateInstrument}];
		badSuppliedDispenseRate = MapThread[
			If[MatchQ[#1, Except[{}]],
				PickList[Lookup[resolvedOptions, #2], badDispenseRate],
				Nothing
			]&,
			{allDispenseRateErrorOptionName, allDispenseRateOption}
		];
		(*issue error*)
		Message[Error::DispenseRateOutOfBound, badInstrument, limitDispenseRateInstrument, Flatten[Cases[allDispenseRateErrorOptionName, Except[{}]]], badSuppliedDispenseRate]
	];
	dispenseRateOutOfBoundTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[badInstrument] > 0,
				Nothing,
				Test["The DispenseRate supplied for the following Instrument" <> ObjectToString[badInstrument, Cache -> simulatedCache] <>
					" out of Instrument boundary", True, False]
			];
			passingTest = If[Length[badInstrument] == 0,
				Test["The DispenseRate Options supplied are compatible with the Instrument" , True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw error when Instrument are ambient only *)
	ambientOnlyInstrumentErrorOptionName = If[MemberQ[mterrorAmbientOnlyInstrument, True],
		{ExtractionTemperature},
		{}
	];
	If[MemberQ[mterrorAmbientOnlyInstrument, True] && messages,
		badExtractionTemperature = PickList[Lookup[resolvedOptions, ExtractionTemperature], mterrorAmbientOnlyInstrument];
		badInstrument = PickList[mtInstrument, mterrorAmbientOnlyInstrument];
		badValue = DeleteDuplicates[Transpose[{badInstrument, badExtractionTemperature}]];
		Message[Error::errorAmbientOnlyInstrument, badValue[[;;, 1]], badValue[[;;, 2]]];
	];
	ambientOnlyInstrumentErrorOptionNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[badInstrument] > 0,
				Nothing,
				Test["The following Instrument" <> ObjectToString[badInstrument, Cache -> simulatedCache] <>
					" can only support SolidPhaseExtraction at Ambient temperature", True, False]
			];
			passingTest = If[Length[badInstrument] == 0,
				Test["The Instrument can support SolidPhaseExtraction at Ambient temperature" , True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* error for temperature limits *)
	extractionTemperatureOutOfBoundOptionName = If[MemberQ[mterrorExtractionTemperatureTooLow, True] || MemberQ[mterrorExtractionTemperatureTooHigh, True],
		{ExtractionTemperature},
		{}
	];
	If[(MemberQ[mterrorExtractionTemperatureTooLow, True] || MemberQ[mterrorExtractionTemperatureTooHigh, True]) && messages,
		badExtractionTemperatureIndex = Flatten[Map[MemberQ[#, True]&, Transpose[{mterrorExtractionTemperatureTooLow, mterrorExtractionTemperatureTooHigh}]]];
		badExtractionTemperature = PickList[Lookup[resolvedOptions, ExtractionTemperature], badExtractionTemperatureIndex];
		badInstrument = PickList[mtInstrument, badExtractionTemperatureIndex];
		badInstrumentModel = PickList[mtinstrumentModel, badExtractionTemperatureIndex];
		badValue = DeleteDuplicates[Transpose[{badInstrument, mtinstrumentModel, badExtractionTemperature}]];
		temperatureLimits = Transpose[Map[
			ToList[cacheLookup[simulatedCache, badValue[[;;, 2]], #]]&,
			{MinTemperature, MaxTemperature}
		]];
		Message[Error::ExtractionTemperatureOutOfBound, badValue[[;;, 1]], temperatureLimits, badValue[[;;, 3]]];
	];
	extractionTemperatureOutOfBoundOptionNameTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[badInstrument] == 0,
				Nothing,
				Test["The following Instrument" <> ObjectToString[badInstrument, Cache -> simulatedCache] <>
					" cannot support requested ExtractionTemperature" <> ToString[badExtractionTemperature], True, False]
			];
			passingTest = If[Length[badInstrument] > 0,
				Test["The Instrument can support SolidPhaseExtraction at supplied Temperature" , True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* container errors *)
	allContainerErrorTracker = {mtwarningIncompatiblePreFlushingSolutionCollectionContainer,
		mtwarningIncompatibleConditioningSolutionCollectionContainer,
		mtwarningIncompatibleWashingSolutionCollectionContainer,
		mtwarningIncompatibleSecondaryWashingSolutionCollectionContainer,
		mtwarningIncompatibleTertiaryWashingSolutionCollectionContainer,
		mtwarningIncompatibleElutingSolutionCollectionContainer,
		mtwarningIncompatibleLoadingSampleFlowthroughContainer
	};
	allContainerOption = {PreFlushingSolutionCollectionContainer,
		ConditioningSolutionCollectionContainer,
		WashingSolutionCollectionContainer,
		SecondaryWashingSolutionCollectionContainer,
		TertiaryWashingSolutionCollectionContainer,
		ElutingSolutionCollectionContainer,
		LoadingSampleFlowthroughContainer
	};
	(* get the name of option that container error *)
	allContainerErrorOptionName = MapThread[If[MemberQ[Flatten[#1], True],
		{#2},
		{}
	]&, {allContainerErrorTracker, allContainerOption}];
	MapThread[
		If[MemberQ[Flatten[#1], True],
			badContainer = Lookup[resolvedOptions, #2];
			badInstrument = PickList[mtInstrument, #1];
			suggestedContainer = Map[
				Lookup[speGetTableFirstRow[tableExtractionOptions, "InstrumentPattern", #], "DefaultContainer"]&,
				badInstrument
			];
			uniqueError = DeleteDuplicates[Transpose[{badContainer, badInstrument, suggestedContainer}]];
			Message[Error::incompatibleInstrumentAndCollectionContainer, uniqueError[[;;, 1]], #2, uniqueError[[;;, 2]], uniqueError[[;;, 3]], #2];
		]&, {allContainerErrorTracker, allContainerOption}
	];

	(* check if we have too many plates or not *)
	Module[{badcollection, badinstrument},
		If[MemberQ[Flatten[mttooManyCollectionPlateOnGX271DeckError], True] && messages,
			badinstrument = PickList[Lookup[resolvedOptions, Instrument], Flatten[mttooManyCollectionPlateOnGX271DeckError]];
			badcollection = PickList[mttooManyCollectionPlateOnGX271DeckOptionName, Flatten[mttooManyCollectionPlateOnGX271DeckError]];
			Message[Error::GX271tooManyCollectionPlate, ToString[badinstrument], ToString[badcollection]]
		];
		mttooManyCollectionPlateOnGX271DeckErrorTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[Flatten[mttooManyCollectionPlateOnGX271DeckError], True],
					Test["There are too many collection plate on the deck of " <> ToString[badinstrument], True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mttooManyCollectionPlateOnGX271DeckError], True]],
					Test["All collection plates can fit on " <> ToString[badinstrument], True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];
	(* check if we have too many solution or not *)
	Module[{badsolution, badinstrument},
		If[MemberQ[Flatten[mttooManyTypeOfSolutionOnGX271Error], True] && messages,
			badinstrument = PickList[Lookup[resolvedOptions, Instrument], Flatten[mttooManyTypeOfSolutionOnGX271Error]];
			badsolution = PickList[mttooManyTypeOfSolutionOnGX271OptionName, Flatten[mttooManyTypeOfSolutionOnGX271Error]];
			Message[Error::GX271tooManySolutionBottle, ToString[badinstrument], ToString[badsolution]]
		];
		mttooManyTypeOfSolutionOnGX271ErrorTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[Flatten[mttooManyTypeOfSolutionOnGX271Error], True],
					Test["There are too types of solution on the deck of " <> ToString[badinstrument], True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mttooManyTypeOfSolutionOnGX271Error], True]],
					Test["All solution containers can fit on the deck of " <> ToString[badinstrument], True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];
	(* check if we can support QuantitativeLoadingSamples *)
	Module[{badsolution, badinstrument, mapmtcannotSupportQuantitativeLoadingError},
		mapmtcannotSupportQuantitativeLoadingError = Map[MemberQ[#, True] || MatchQ[#, True] &, mtcannotSupportQuantitativeLoadingError];
		If[MemberQ[Flatten[mapmtcannotSupportQuantitativeLoadingError], True] && messages,
			badinstrument = PickList[mtInstrument, Flatten[mapmtcannotSupportQuantitativeLoadingError]];
			badsolution = PickList[mtcannotSupportQuantitativeLoadingErrorOptionName, Flatten[mapmtcannotSupportQuantitativeLoadingError]];
			Message[Error::SPEInstrumentCannotSupportRinseAndReload,
				ToString[badinstrument],
				ToString[{Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]}],
				ToString[badsolution]
			]
		];
		mtcannotSupportQuantitativeLoadingErrorTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[mapmtcannotSupportQuantitativeLoadingError, True],
					Test["The Instrument " <> ToString[badinstrument] <> " cannot support QunatitativeLoadingSample." , True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mapmtcannotSupportQuantitativeLoadingError], True]],
					Test["QuantititaveLoadingSample can be supported.", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];
	(* check if we can support the solution chosen for quantitiative loading sample *)
	Module[{badinstrument, mapquantitativeLoadingSampleSolutionError},
		mapquantitativeLoadingSampleSolutionError = Map[MemberQ[#, True] || MatchQ[#, True] &, mtquantitativeLoadingSampleSolutionError];
		If[MemberQ[Flatten[mapquantitativeLoadingSampleSolutionError], True] && messages,
			badinstrument = PickList[mtInstrument, Flatten[mapquantitativeLoadingSampleSolutionError]];
			Message[Error::SPEInstrumentCannotSupportSolution, ToString[badinstrument]]
		];
		quantitativeLoadingSampleSolutionErrorTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[mapquantitativeLoadingSampleSolutionError, True],
					Test["The Instrument " <> ToString[badinstrument] <> " can only support QuantitativeLoadingSampleSolution that match with ConditioningSolution." , True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mapquantitativeLoadingSampleSolutionError], True]],
					Test["The Instrument " <> ToString[badinstrument] <> " can support QuantitativeLoadingSampleSolution", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];
	(* check if the cartridge is SPE cartridge *)
	Module[{badcartridge},
		If[MemberQ[Flatten[mtnotSPECartridgeError], True] && messages,
			badcartridge = PickList[Lookup[resolvedOptions, ExtractionCartridge], Flatten[mtnotSPECartridgeError]];
			Message[Error::NotSPECartridge, ToString[badcartridge]]
		];
		notSPECartridgeOptionName = If[MemberQ[Flatten[mtnotSPECartridgeError], True], {ExtractionCartridge}, {}];
		notSPECartridgeTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[Flatten[mtnotSPECartridgeError], True],
					Test["The ExtractionCartridge" <> ToString[badcartridge] <> " are not SolidPhaseExtraction Cartridge." , True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mtnotSPECartridgeError], True]],
					Test["All supplied ExtractionCartridge are SolidPhaseExtraction Cartridge.", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];
	(* check for any buffer options if the volume is too large *)
	solutionVolumeTooLargeTest = Module[
		{badvalue, failingTest, passingTest},
		MapThread[
			(
				If[MemberQ[Flatten[#1], True] && messages,
					badvalue = PickList[Lookup[resolvedOptions, #2], Flatten[#1]];
					Message[Error::SPECannotSupportSolutionVolume, ToString[badvalue], ToString[#2]]
				];
				If[gatherTests,
					failingTest = If[MemberQ[Flatten[#1], True],
						Test["The Volume of " <> ToString[#2] <> " is too large for solidPhaseExtraction Instrument to operate with." , True, False],
						Nothing
					];
					passingTest = If[!MemberQ[Flatten[#1], True],
						Test["All solution volume can be supported by SolidPhaseExtraction.", True, True],
						Nothing
					];
					{failingTest, passingTest}
				]
			)&,
			{
				{
					mtspeCannotSupportPreFlushVolume,
					mtspeCannotSupportConditionVolume,
					mtspeCannotSupportWashVolume,
					mtspeCannotSupportSecondaryWashVolume,
					mtspeCannotSupportTertiaryWashVolume,
					mtspeCannotSupportEluteVolume,
					mtspeCannotSupportQuantVolume
				},
				{
					PreFlushingSolutionVolume,
					ConditioningSolutionVolume,
					WashingSolutionVolume,
					SecondaryWashingSolutionVolume,
					TertiaryWashingSolutionVolume,
					ElutingSolutionVolume,
					QuantitativeLoadingSampleVolume
				}
			}
		]
	];
	(*	 check if the instrument that user gives is for SPE or not *)
	Module[{badinstrument},
		If[MemberQ[Flatten[mtspeCannotSupportInstrumentError], True] && messages,
			badinstrument = PickList[Lookup[resolvedOptions, Instrument], Flatten[mtspeCannotSupportInstrumentError]];
			Message[Error::NotSPEInstrument, ToString[badinstrument]]
		];
		notSPEInstrumentTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[Flatten[mtspeCannotSupportInstrumentError], True],
					Test["The Instrument " <> ToString[badinstrument] <> " are not SolidPhaseExtraction Instrument." , True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mtspeCannotSupportInstrumentError], True]],
					Test["All supplied Instrument(s) are SolidPhaseExtraction Instrument.", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];
	(* check for any buffer options if the volume is too large *)
	solutionVolumeTooLargeForInstrumentTest = Module[
		{badvalue, badinstrument, badcartridge, maxvolume, indexMatchError, failingTest, passingTest, badCollectionContainer},
		MapThread[
			Function[{indexederror, optionname},
				If[MemberQ[Flatten[indexederror], True] && messages,
					(* sometimes we work with pooled options *)
					indexMatchError = If[ListQ[#], First[#], #]& /@ indexederror;
					badvalue = PickList[Lookup[resolvedOptions, optionname], Flatten[indexederror]];
					badinstrument = PickList[mtInstrument, indexMatchError];
					badcartridge = PickList[mtExtractionCartridge, indexMatchError];

					(* note that this is only one of the multiple collection containers here; it's not 100% clear that this is sufficient, but I don't really want to list ALL of them *)
					badCollectionContainer = PickList[mtElutingSolutionCollectionContainer, indexMatchError];
					maxvolume = Flatten[MapThread[
						Min[{
							cacheLookup[simulatedCache, #1, MaxVolume],
							cacheLookup[simulatedCache, #2, MaxVolume]
						}]&,
						{badcartridge, badCollectionContainer}
					]];
					Message[Error::SPEInstrumentCannotSupportSolutionVolume,
						ObjectToString[badcartridge, Cache -> simulatedCache], ObjectToString[badCollectionContainer, Cache -> simulatedCache], ObjectToString[optionname], ObjectToString[badvalue], ObjectToString[maxvolume]]
				];
				If[gatherTests,
					failingTest = If[MemberQ[Flatten[indexederror], True],
						Test["The Volume of " <> ToString[optionname] <> " is too large for ExtractionCartridge to operate with." , True, False],
						Nothing
					];
					passingTest = If[!MemberQ[Flatten[indexederror], True],
						Test["All solution volume can be supported by ExtractionCartridge.", True, True],
						Nothing
					];
					{failingTest, passingTest}
				]
			],
			{
				{
					mterrorPreFlushingVolumeInstrument,
					mterrorConditioningVolumeInstrument,
					mterrorWashingVolumeInstrument,
					mterrorElutingVolumeInstrument,
					mterrorSecondaryWashingVolumeInstrument,
					mterrorTertiaryWashingVolumeInstrument,
					mterrorLoadingSampleVolumeInstrument
				},
				{
					PreFlushingSolutionVolume,
					ConditioningSolutionVolume,
					WashingSolutionVolume,
					ElutingSolutionVolume,
					SecondaryWashingSolutionVolume,
					TertiaryWashingSolutionVolume,
					LoadingSampleVolume
				}
			}
		]
	];
	(* check if we can support  solution temperature *)
	Module[{badtemperature, badoption},
		badoption = MapThread[
			If[MemberQ[Flatten[#1], True] && messages,
				(
					badtemperature = PickList[Lookup[resolvedOptions, #2], Flatten[#1]];
					Message[Error::SPEInstrumentNotSupportSolutionTemperature , ToString[#2], ToString[badtemperature], ToString[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]];
					#2
				),
				{}
			]&,
			{
				{
					mterrorPreFlushingInstrumentSolutionTemperature,
					mterrorConditioningInstrumentSolutionTemperature,
					mterrorWashingInstrumentSolutionTemperature,
					mterrorElutingInstrumentSolutionTemperature,
					mterrorSecondaryWashingInstrumentSolutionTemperature,
					mterrorTertiaryWashingInstrumentSolutionTemperature,
					mterrorLoadingSampleInstrumentSolutionTemperature
				},
				{
					PreFlushingSolutionTemperature,
					ConditioningSolutionTemperature,
					WashingSolutionTemperature,
					ElutingSolutionTemperature,
					SecondaryWashingSolutionTemperature,
					TertiaryWashingSolutionTemperature,
					LoadingSampleSolutionTemperature
				}
			}
		];
		cannotSupportSolutionTemperatureOptionName = Flatten[badoption];
		cannotSupportSolutionTemperatureTest = Map[
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest = If[MemberQ[Flatten[mtnotSPECartridgeError], True],
						Test["SolidPhaseExtraction cannot support the supplied SolutionTemperature " <> ToString[badtemperature] , True, False],
						Nothing
					];
					passingTest = If[Not[MemberQ[Flatten[mtnotSPECartridgeError], True]],
						Test["SolidPhaseExtraction can support the supplied SolutionTemperature.", True, True],
						Nothing
					];
					{failingTest, passingTest}
				],
				Nothing
			]&,
			{
				mterrorPreFlushingInstrumentSolutionTemperature,
				mterrorConditioningInstrumentSolutionTemperature,
				mterrorWashingInstrumentSolutionTemperature,
				mterrorElutingInstrumentSolutionTemperature,
				mterrorSecondaryWashingInstrumentSolutionTemperature,
				mterrorTertiaryWashingInstrumentSolutionTemperature,
				mterrorLoadingSampleInstrumentSolutionTemperature
			}
		];
	];
	(* check if we have cartridge with indicated sorbent or not *)
	Module[{badsorbent},
		If[MemberQ[Flatten[mtcannotFindCartridgeWithSuppliedError], True] && messages,
			badsorbent = PickList[Lookup[resolvedOptions, ExtractionSorbent], Flatten[mtcannotFindCartridgeWithSuppliedError]];
			Message[Error::SPEcannotFindCartridgeWithSorbentError, ToString[badsorbent], ExtractionSorbent]
		];
		mtcannotFindCartridgeWithSuppliedErrorOptionName = If[MemberQ[Flatten[mtcannotFindCartridgeWithSuppliedError], True],
			ExtractionSorbent,
			{}
		];
		mtcannotFindCartridgeWithSuppliedErrorTest = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[Flatten[mtcannotFindCartridgeWithSuppliedError], True],
					Test["SolidPhaseExtraction cannot find supporting ExtractionCartridge with ExtractionSorbent " <> ToString[badsorbent], True, False],
					Nothing
				];
				passingTest = If[Not[MemberQ[Flatten[mttooManyTypeOfSolutionOnGX271Error], True]],
					Test["All ExtractionSorbent can be supported by SolidPhaseExtraction", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];
	];

	 (* check whether any of the input samples or resolved buffers are LiquidHandlerIncompatible *)
	sampleLiquidHandlerIncompatibleValues = cacheLookup[simulatedCache, #, LiquidHandlerIncompatible]& /@ flatSimulatedSamples;
	samplesLiquidHandlerIncompatible = If[MatchQ[resolvedPreparation, Robotic],
		PickList[flatSimulatedSamples, sampleLiquidHandlerIncompatibleValues, True],
		{}
	];

	(* check whether any of the resolved solutions are LiquidHandlerIncompatible *)
	allResolvedSolutions = Cases[Flatten[{
		mtPreFlushingSolution,
		mtConditioningSolution,
		mtWashingSolution,
		mtSecondaryWashingSolution,
		mtTertiaryWashingSolution,
		mtElutingSolution
	}], ObjectP[]];
	allResolvedSolutionLiquidHandlerIncompatibleValues = cacheLookup[simulatedCache, #, LiquidHandlerIncompatible]& /@ allResolvedSolutions;
	solutionsLiquidHandlerIncompatible = If[MatchQ[resolvedPreparation, Robotic],
		PickList[allResolvedSolutions, allResolvedSolutionLiquidHandlerIncompatibleValues, True],
		{}
	];

	(* throw message if the input samples can't go on the liquid handler *)
	samplesLiquidHandlerIncompatibleInputs = If[Not[gatherTests] && Not[MatchQ[samplesLiquidHandlerIncompatible, {}]],
		(
			Message[Error::SPEInputLiquidHandlerIncompatible, ObjectToString[samplesLiquidHandlerIncompatible, Cache -> simulatedCache]];
			samplesLiquidHandlerIncompatible
		),
		{}
	];
	samplesLiquidHandlerIncompatibleTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[sampleLiquidHandlerIncompatibleValues, True] && MatchQ[resolvedPreparation, Robotic],
				Test["If performing robotic SolidPhaseExtraction, all input samples do not have LiquidHandlerIncompatible -> True:", True, False],
				Nothing
			];
			passingTest = If[MemberQ[sampleLiquidHandlerIncompatibleValues, Except[True]] && MatchQ[resolvedPreparation, Robotic],
				Test["If performing robotic SolidPhaseExtraction, all input samples do not have LiquidHandlerIncompatible -> True:", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw message if the resolved solutions can't go on the liquid handler *)
	solutionsLiquidHandlerIncompatibleOptions = If[Not[gatherTests] && Not[MatchQ[solutionsLiquidHandlerIncompatible, {}]],
		(
			Message[Error::SPESolutionsLiquidHandlerIncompatible, ObjectToString[solutionsLiquidHandlerIncompatible, Cache -> simulatedCache]];
			{PreFlushingSolution, ConditioningSolution, WashingSolution, SecondaryWashingSolution, TertiaryWashingSolution, ElutingSolution}
		),
		{}
	];
	solutionsLiquidHandlerIncompatibleTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[allResolvedSolutionLiquidHandlerIncompatibleValues, True] && MatchQ[resolvedPreparation, Robotic],
				Test["If performing robotic SolidPhaseExtraction, all PreFlushing, Conditioning, Washing, and Eluting solutions do not have LiquidHandlerIncompatible -> True:", True, False],
				Nothing
			];
			passingTest = If[MemberQ[allResolvedSolutionLiquidHandlerIncompatibleValues, Except[True]] && MatchQ[resolvedPreparation, Robotic],
				Test["If performing robotic SolidPhaseExtraction, all PreFlushing, Conditioning, Washing, and Eluting solutions do not have LiquidHandlerIncompatible -> True:", True, True],
				Nothing
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* throw a message if Preparation -> Manual and $SPERoboticOnly is set to True *)
	roboticOnlyOptions = If[Not[gatherTests] && TrueQ[$SPERoboticOnly] && MatchQ[resolvedPreparation, Manual],
		(
			Message[Error::SPEManualCurrentlyNotSupported];
			{Preparation}
		),
		{}
	];
	roboticOnlyTests = If[gatherTests && TrueQ[$SPERoboticOnly],
		Test["Preparation is not set to Manual while it is not yet supported:",
			resolvedPreparation,
			Robotic
		]
	];

	(* Summarize all invalid inputs and options*)
	invalidInputs = DeleteDuplicates[Flatten[{{discardedInvalidInputs, samplesLiquidHandlerIncompatibleInputs}}]];

	invalidOptions = DeleteDuplicates[Flatten[{
		incompatibleInstrumentAndMethodErrorOptionName,
		incompatibleInstrumentAndExtractionCartridgeErrorOptionName,
		incompatibleExtractionMethodAndExtractionCartridgeErrorOptionName,
		incompatibleInstrumentExtractionMethodExtractionCartridgeErrorOptionName,
		skippedWashingErrorOptionName,
		skippedSecondaryWashingErrorOptionName,
		allPressureErrorOptionName,
		allDispenseRateErrorOptionName,
		ambientOnlyInstrumentErrorOptionName,
		extractionTemperatureOutOfBoundOptionName,
		allContainerErrorOptionName,
		mtvolumeTooLargeWarningOptionsName,
		mtconflictingMobilePhaseOptionName,
		mtconflictingSuppliedMethodAndImpliedMethodErrorOptionName,
		mtspeCannotSupportVolumeErrorOptionName,
		mtspeCannotSupportCollectionOptionName,
		mtspeCannotSupportMethodOptionName,
		mtspeCannotSupportCartridgeOptionName,
		mtwarningVolumeTooHighOptionName,
		badCentrifugeIntensityOptionName,
		mttooBigCartridgeErrorOptionName,
		mtnoCompatibleInstrumentErrorName,
		mttooManyCollectionPlateOnGX271DeckOptionName,
		mttooManyTypeOfSolutionOnGX271OptionName,
		mtcannotSupportQuantitativeLoadingErrorOptionName,
		notSPECartridgeOptionName,
		cannotSupportSolutionTemperatureOptionName,
		mtcannotFindCartridgeWithSuppliedErrorOptionName,
		solutionsLiquidHandlerIncompatibleOptions,
		roboticOnlyOptions
	}]];

	(*  Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];

	outputSpecification /. {
		Result -> resolvedOptions,
		Tests -> Cases[
			Flatten[
				{
					samplePrepTests,
					discardedTest,
					missingVolumeTest,
					nonLiquidSampleTest,
					discardedMobilePhaseTest,
					conflictingMobilePhaseTest,
					missingVolumeMobilePhaseTest,
					nonLiquidMobilePhaseTest,
					conflictingMobilePhaseTest,
					pressureMustBeBooleanTest,
					nameUniquenessTest,
					precisionTests,
					tooLargeLoadingSampleVolumeTest,
					conflictingMethodInferringMobilePhaseOptionsTest,
					conflictingSuppliedMethodAndImpliedMethodErrorTest,
					mtspeCannotSupportVolumeErrorTest,
					mtspeCannotSupportCollectionTest,
					mtspeCannotSupportCartridgeTest,
					mtspeCannotSupportCartridgeTest,
					mtspeCannotSupportMethodTest,
					mtnoCompatibleInstrumentErrorTest,
					mtwarningVolumeTooHighErrorTest,
					centrifugeIntensityTest,
					mttooBigCartridgeErrorTest,
					mttooManyCollectionPlateOnGX271DeckErrorTest,
					mttooManyTypeOfSolutionOnGX271ErrorTest,
					mtcannotSupportQuantitativeLoadingErrorTest,
					quantitativeLoadingSampleSolutionErrorTest,
					notSPECartridgeTest,
					solutionVolumeTooLargeTest,
					notSPEInstrumentTest,
					solutionVolumeTooLargeForInstrumentTest,
					cannotSupportSolutionTemperatureTest,
					solutionsLiquidHandlerIncompatibleTests,
					roboticOnlyTests
				}]
			, _EmeraldTest
		]
	}
];
(* end of optionresolver*)
(* ::Subsection::Closed:: *)
(*solidPhaseExtractionResourcePackets*)

DefineOptions[solidPhaseExtractionResourcePackets, Options :> {CacheOption, ExperimentOutputOption, SimulationOption}];

solidPhaseExtractionResourcePackets[
	myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}],
	myUnresolvedOptions : {___Rule},
	myResolvedOptions : {___Rule},
	myOptions : OptionsPattern[]] := Module[
	{
		safeOps, outputSpecification, output, gatherTests, messages, originalIndex,
		cache, poolLengths, samplesIn, samplesInResources, simulation, updatedSimulation,
		containersIn, containersInModels, containersInResources,
		pooledSamplesInResources, pooledContainersInResources, allPackets, oldSampleToLabelRules, oldSampleToModelRules,
		allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule, simulationRule,
		batchedOptions, unorderedResource, unorderedResourceMerged, originalOrder, orderedResource,
		totalEstimatedRunTime, protocolPacket, modelInputQ, labelSampleUOFromPreparedModels,
		oldObjectToNewResourceRules,
		(* bunch of resolved options variables *)
		resolvedExtractionStrategy,
		resolvedExtractionMode,
		resolvedExtractionSorbent,
		resolvedExtractionCartridge,
		resolvedInstrument,
		resolvedExtractionMethod,
		resolvedExtractionTemperature,
		resolvedExtractionCartridgeStorageCondition,
		resolvedPreFlushing,
		resolvedPreFlushingSolution,
		resolvedPreFlushingSolutionVolume,
		resolvedPreFlushingSolutionTemperature,
		resolvedPreFlushingSolutionTemperatureEquilibrationTime,
		resolvedCollectPreFlushingSolution,
		resolvedPreFlushingSolutionCollectionContainer,
		resolvedPreFlushingSolutionDispenseRate,
		resolvedPreFlushingSolutionDrainTime,
		resolvedPreFlushingSolutionUntilDrained,
		resolvedMaxPreFlushingSolutionDrainTime,
		resolvedPreFlushingSolutionCentrifugeIntensity,
		resolvedPreFlushingSolutionPressure,
		resolvedPreFlushingSolutionMixVolume,
		resolvedPreFlushingSolutionNumberOfMixes,
		resolvedConditioning,
		resolvedConditioningSolution,
		resolvedConditioningSolutionVolume,
		resolvedConditioningSolutionTemperature,
		resolvedConditioningSolutionTemperatureEquilibrationTime,
		resolvedCollectConditioningSolution,
		resolvedConditioningSolutionCollectionContainer,
		resolvedConditioningSolutionDispenseRate,
		resolvedConditioningSolutionDrainTime,
		resolvedConditioningSolutionUntilDrained,
		resolvedMaxConditioningSolutionDrainTime,
		resolvedConditioningSolutionCentrifugeIntensity,
		resolvedConditioningSolutionPressure,
		resolvedConditioningSolutionMixVolume,
		resolvedConditioningSolutionNumberOfMixes,
		resolvedLoadingSampleVolume,
		resolvedQuantitativeLoadingSample,
		resolvedQuantitativeLoadingSampleSolution,
		resolvedQuantitativeLoadingSampleVolume,
		resolvedLoadingSampleTemperature,
		resolvedLoadingSampleTemperatureEquilibrationTime,
		resolvedCollectLoadingSampleFlowthrough,
		resolvedLoadingSampleFlowthroughContainer,
		resolvedLoadingSampleDispenseRate,
		resolvedLoadingSampleDrainTime,
		resolvedLoadingSampleUntilDrained,
		resolvedMaxLoadingSampleDrainTime,
		resolvedLoadingSampleCentrifugeIntensity,
		resolvedLoadingSamplePressure,
		resolvedLoadingSampleMixVolume,
		resolvedLoadingSampleNumberOfMixes,
		resolvedWashing,
		resolvedWashingSolution,
		resolvedWashingSolutionVolume,
		resolvedWashingSolutionTemperature,
		resolvedWashingSolutionTemperatureEquilibrationTime,
		resolvedCollectWashingSolution,
		resolvedWashingSolutionCollectionContainer,
		resolvedWashingSolutionDispenseRate,
		resolvedWashingSolutionDrainTime,
		resolvedWashingSolutionUntilDrained,
		resolvedMaxWashingSolutionDrainTime,
		resolvedWashingSolutionCentrifugeIntensity,
		resolvedWashingSolutionPressure,
		resolvedWashingSolutionMixVolume,
		resolvedWashingSolutionNumberOfMixes,
		resolvedSecondaryWashing,
		resolvedSecondaryWashingSolution,
		resolvedSecondaryWashingSolutionVolume,
		resolvedSecondaryWashingSolutionTemperature,
		resolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
		resolvedCollectSecondaryWashingSolution,
		resolvedSecondaryWashingSolutionCollectionContainer,
		resolvedSecondaryWashingSolutionDispenseRate,
		resolvedSecondaryWashingSolutionDrainTime,
		resolvedSecondaryWashingSolutionUntilDrained,
		resolvedMaxSecondaryWashingSolutionDrainTime,
		resolvedSecondaryWashingSolutionCentrifugeIntensity,
		resolvedSecondaryWashingSolutionPressure,
		resolvedSecondaryWashingSolutionMixVolume,
		resolvedSecondaryWashingSolutionNumberOfMixes,
		resolvedTertiaryWashing,
		resolvedTertiaryWashingSolution,
		resolvedTertiaryWashingSolutionVolume,
		resolvedTertiaryWashingSolutionTemperature,
		resolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
		resolvedCollectTertiaryWashingSolution,
		resolvedTertiaryWashingSolutionCollectionContainer,
		resolvedTertiaryWashingSolutionDispenseRate,
		resolvedTertiaryWashingSolutionDrainTime,
		resolvedTertiaryWashingSolutionUntilDrained,
		resolvedMaxTertiaryWashingSolutionDrainTime,
		resolvedTertiaryWashingSolutionCentrifugeIntensity,
		resolvedTertiaryWashingSolutionPressure,
		resolvedTertiaryWashingSolutionMixVolume,
		resolvedTertiaryWashingSolutionNumberOfMixes,
		resolvedEluting,
		resolvedElutingSolution,
		resolvedElutingSolutionVolume,
		resolvedElutingSolutionTemperature,
		resolvedElutingSolutionTemperatureEquilibrationTime,
		resolvedCollectElutingSolution,
		resolvedElutingSolutionCollectionContainer,
		resolvedElutingSolutionDispenseRate,
		resolvedElutingSolutionDrainTime,
		resolvedElutingSolutionUntilDrained,
		resolvedMaxElutingSolutionDrainTime,
		resolvedElutingSolutionCentrifugeIntensity,
		resolvedElutingSolutionPressure,
		resolvedElutingSolutionMixVolume,
		resolvedElutingSolutionNumberOfMixes,
		resolvedPreparation,
		resolvedAliquotTargets,
		(* intermediate varibles*)
		resolvedExtractionCartridgeModel,
		resolvedExtractionCartridgeType,
		resolvedInstrumentModel,
		(* resource variables *)
		extractionCartridgeCapResources,
		mySPEResolvedOptions,
		(* unit op *)
		optionsAndResourceByBatch,
		unitOperationPackets,
		roboticFilterUnitOperationPackets,
		runTime,
		finalSPEUnitOperationPackets,
		(* local variable *)
		flatAliquotTarget,
		flatAliquotTargetNoNulls,
		aliquotLabelAndObject,
		uniqueAliquotLabelAndObject,
		aliquotContainerResource,
		aliquotContainerResourceLabelRule,
		destinationWell,
		destinationVolume,
		destinationContainerLabel,
		aliquotSampleLabel,
		destinationContainerResource,
		destinationContainerModel,
		aliquotLength,
		mySharedOptions,
		mySharedOptionsKeys,
		cartridgeSize, resolvedWorkCell, resolvedPrepUOs
	},

	(* get the safe options for this function *)
	safeOps = SafeOptions[solidPhaseExtractionResourcePackets, ToList[myOptions]];

	(* this is to make all option, even the non-index matched, becomes temporaliry index match to make pick resource base on batch easier *)
	mySPEResolvedOptions = KeyDrop[myResolvedOptions, {Cache, ImageSample, MeasureVolume, MeasureWeight}] /. <|x___|> -> {x};
	(* pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* lookup the cache *)
	{
		resolvedExtractionStrategy,
		resolvedExtractionMode,
		resolvedExtractionSorbent,
		resolvedExtractionCartridge,
		resolvedInstrument,
		resolvedExtractionMethod,
		resolvedExtractionTemperature,
		resolvedExtractionCartridgeStorageCondition,
		resolvedPreFlushing,
		resolvedPreFlushingSolution,
		resolvedPreFlushingSolutionVolume,
		resolvedPreFlushingSolutionTemperature,
		resolvedPreFlushingSolutionTemperatureEquilibrationTime,
		resolvedCollectPreFlushingSolution,
		resolvedPreFlushingSolutionCollectionContainer,
		resolvedPreFlushingSolutionDispenseRate,
		resolvedPreFlushingSolutionDrainTime,
		resolvedPreFlushingSolutionUntilDrained,
		resolvedMaxPreFlushingSolutionDrainTime,
		resolvedPreFlushingSolutionCentrifugeIntensity,
		resolvedPreFlushingSolutionPressure,
		resolvedPreFlushingSolutionMixVolume,
		resolvedPreFlushingSolutionNumberOfMixes,
		resolvedConditioning,
		resolvedConditioningSolution,
		resolvedConditioningSolutionVolume,
		resolvedConditioningSolutionTemperature,
		resolvedConditioningSolutionTemperatureEquilibrationTime,
		resolvedCollectConditioningSolution,
		resolvedConditioningSolutionCollectionContainer,
		resolvedConditioningSolutionDispenseRate,
		resolvedConditioningSolutionDrainTime,
		resolvedConditioningSolutionUntilDrained,
		resolvedMaxConditioningSolutionDrainTime,
		resolvedConditioningSolutionCentrifugeIntensity,
		resolvedConditioningSolutionPressure,
		resolvedConditioningSolutionMixVolume,
		resolvedConditioningSolutionNumberOfMixes,
		resolvedLoadingSampleVolume,
		resolvedQuantitativeLoadingSample,
		resolvedQuantitativeLoadingSampleSolution,
		resolvedQuantitativeLoadingSampleVolume,
		resolvedLoadingSampleTemperature,
		resolvedLoadingSampleTemperatureEquilibrationTime,
		resolvedCollectLoadingSampleFlowthrough,
		resolvedLoadingSampleFlowthroughContainer,
		resolvedLoadingSampleDispenseRate,
		resolvedLoadingSampleDrainTime,
		resolvedLoadingSampleUntilDrained,
		resolvedMaxLoadingSampleDrainTime,
		resolvedLoadingSampleCentrifugeIntensity,
		resolvedLoadingSamplePressure,
		resolvedLoadingSampleMixVolume,
		resolvedLoadingSampleNumberOfMixes,
		resolvedWashing,
		resolvedWashingSolution,
		resolvedWashingSolutionVolume,
		resolvedWashingSolutionTemperature,
		resolvedWashingSolutionTemperatureEquilibrationTime,
		resolvedCollectWashingSolution,
		resolvedWashingSolutionCollectionContainer,
		resolvedWashingSolutionDispenseRate,
		resolvedWashingSolutionDrainTime,
		resolvedWashingSolutionUntilDrained,
		resolvedMaxWashingSolutionDrainTime,
		resolvedWashingSolutionCentrifugeIntensity,
		resolvedWashingSolutionPressure,
		resolvedWashingSolutionMixVolume,
		resolvedWashingSolutionNumberOfMixes,
		resolvedSecondaryWashing,
		resolvedSecondaryWashingSolution,
		resolvedSecondaryWashingSolutionVolume,
		resolvedSecondaryWashingSolutionTemperature,
		resolvedSecondaryWashingSolutionTemperatureEquilibrationTime,
		resolvedCollectSecondaryWashingSolution,
		resolvedSecondaryWashingSolutionCollectionContainer,
		resolvedSecondaryWashingSolutionDispenseRate,
		resolvedSecondaryWashingSolutionDrainTime,
		resolvedSecondaryWashingSolutionUntilDrained,
		resolvedMaxSecondaryWashingSolutionDrainTime,
		resolvedSecondaryWashingSolutionCentrifugeIntensity,
		resolvedSecondaryWashingSolutionPressure,
		resolvedSecondaryWashingSolutionMixVolume,
		resolvedSecondaryWashingSolutionNumberOfMixes,
		resolvedTertiaryWashing,
		resolvedTertiaryWashingSolution,
		resolvedTertiaryWashingSolutionVolume,
		resolvedTertiaryWashingSolutionTemperature,
		resolvedTertiaryWashingSolutionTemperatureEquilibrationTime,
		resolvedCollectTertiaryWashingSolution,
		resolvedTertiaryWashingSolutionCollectionContainer,
		resolvedTertiaryWashingSolutionDispenseRate,
		resolvedTertiaryWashingSolutionDrainTime,
		resolvedTertiaryWashingSolutionUntilDrained,
		resolvedMaxTertiaryWashingSolutionDrainTime,
		resolvedTertiaryWashingSolutionCentrifugeIntensity,
		resolvedTertiaryWashingSolutionPressure,
		resolvedTertiaryWashingSolutionMixVolume,
		resolvedTertiaryWashingSolutionNumberOfMixes,
		resolvedEluting,
		resolvedElutingSolution,
		resolvedElutingSolutionVolume,
		resolvedElutingSolutionTemperature,
		resolvedElutingSolutionTemperatureEquilibrationTime,
		resolvedCollectElutingSolution,
		resolvedElutingSolutionCollectionContainer,
		resolvedElutingSolutionDispenseRate,
		resolvedElutingSolutionDrainTime,
		resolvedElutingSolutionUntilDrained,
		resolvedMaxElutingSolutionDrainTime,
		resolvedElutingSolutionCentrifugeIntensity,
		resolvedElutingSolutionPressure,
		resolvedElutingSolutionMixVolume,
		resolvedElutingSolutionNumberOfMixes,
		resolvedAliquotTargets,
		resolvedWorkCell,
		resolvedPrepUOs
	} = Lookup[myResolvedOptions,
		{
			ExtractionStrategy,
			ExtractionMode,
			ExtractionSorbent,
			ExtractionCartridge,
			Instrument,
			ExtractionMethod,
			ExtractionTemperature,
			ExtractionCartridgeStorageCondition,
			PreFlushing,
			PreFlushingSolution,
			PreFlushingSolutionVolume,
			PreFlushingSolutionTemperature,
			PreFlushingSolutionTemperatureEquilibrationTime,
			CollectPreFlushingSolution,
			PreFlushingSolutionCollectionContainer,
			PreFlushingSolutionDispenseRate,
			PreFlushingSolutionDrainTime,
			PreFlushingSolutionUntilDrained,
			MaxPreFlushingSolutionDrainTime,
			PreFlushingSolutionCentrifugeIntensity,
			PreFlushingSolutionPressure,
			PreFlushingSolutionMixVolume,
			PreFlushingSolutionNumberOfMixes,
			Conditioning,
			ConditioningSolution,
			ConditioningSolutionVolume,
			ConditioningSolutionTemperature,
			ConditioningSolutionTemperatureEquilibrationTime,
			CollectConditioningSolution,
			ConditioningSolutionCollectionContainer,
			ConditioningSolutionDispenseRate,
			ConditioningSolutionDrainTime,
			ConditioningSolutionUntilDrained,
			MaxConditioningSolutionDrainTime,
			ConditioningSolutionCentrifugeIntensity,
			ConditioningSolutionPressure,
			ConditioningSolutionMixVolume,
			ConditioningSolutionNumberOfMixes,
			LoadingSampleVolume,
			QuantitativeLoadingSample,
			QuantitativeLoadingSampleSolution,
			QuantitativeLoadingSampleVolume,
			LoadingSampleTemperature,
			LoadingSampleTemperatureEquilibrationTime,
			CollectLoadingSampleFlowthrough,
			LoadingSampleFlowthroughContainer,
			LoadingSampleDispenseRate,
			LoadingSampleDrainTime,
			LoadingSampleUntilDrained,
			MaxLoadingSampleDrainTime,
			LoadingSampleCentrifugeIntensity,
			LoadingSamplePressure,
			LoadingSampleMixVolume,
			LoadingSampleNumberOfMixes,
			Washing,
			WashingSolution,
			WashingSolutionVolume,
			WashingSolutionTemperature,
			WashingSolutionTemperatureEquilibrationTime,
			CollectWashingSolution,
			WashingSolutionCollectionContainer,
			WashingSolutionDispenseRate,
			WashingSolutionDrainTime,
			WashingSolutionUntilDrained,
			MaxWashingSolutionDrainTime,
			WashingSolutionCentrifugeIntensity,
			WashingSolutionPressure,
			WashingSolutionMixVolume,
			WashingSolutionNumberOfMixes,
			SecondaryWashing,
			SecondaryWashingSolution,
			SecondaryWashingSolutionVolume,
			SecondaryWashingSolutionTemperature,
			SecondaryWashingSolutionTemperatureEquilibrationTime,
			CollectSecondaryWashingSolution,
			SecondaryWashingSolutionCollectionContainer,
			SecondaryWashingSolutionDispenseRate,
			SecondaryWashingSolutionDrainTime,
			SecondaryWashingSolutionUntilDrained,
			MaxSecondaryWashingSolutionDrainTime,
			SecondaryWashingSolutionCentrifugeIntensity,
			SecondaryWashingSolutionPressure,
			SecondaryWashingSolutionMixVolume,
			SecondaryWashingSolutionNumberOfMixes,
			TertiaryWashing,
			TertiaryWashingSolution,
			TertiaryWashingSolutionVolume,
			TertiaryWashingSolutionTemperature,
			TertiaryWashingSolutionTemperatureEquilibrationTime,
			CollectTertiaryWashingSolution,
			TertiaryWashingSolutionCollectionContainer,
			TertiaryWashingSolutionDispenseRate,
			TertiaryWashingSolutionDrainTime,
			TertiaryWashingSolutionUntilDrained,
			MaxTertiaryWashingSolutionDrainTime,
			TertiaryWashingSolutionCentrifugeIntensity,
			TertiaryWashingSolutionPressure,
			TertiaryWashingSolutionMixVolume,
			TertiaryWashingSolutionNumberOfMixes,
			Eluting,
			ElutingSolution,
			ElutingSolutionVolume,
			ElutingSolutionTemperature,
			ElutingSolutionTemperatureEquilibrationTime,
			CollectElutingSolution,
			ElutingSolutionCollectionContainer,
			ElutingSolutionDispenseRate,
			ElutingSolutionDrainTime,
			ElutingSolutionUntilDrained,
			MaxElutingSolutionDrainTime,
			ElutingSolutionCentrifugeIntensity,
			ElutingSolutionPressure,
			ElutingSolutionMixVolume,
			ElutingSolutionNumberOfMixes,
			AliquotTargets,
			WorkCell,
			PreparatoryUnitOperations
		}
	];

	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* if we have a model input LabelSample here and we're on the robot, set this bool to True and use it below *)
	modelInputQ = MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedPrepUOs, {_[_LabelSample]}];

	{simulation, cache} = Lookup[ToList[myOptions], {Simulation, Cache}];
	(* determine the pool lengths*)
	poolLengths = Map[Length[#]&, myPooledSamples];
	originalIndex = Range[Length[myPooledSamples]];

	(* CREATE RESOURCE for options that do not require batching *)
	(* create the sample resource, only request the amount we're actually going to SPE *)
	samplesIn = Flatten[myPooledSamples];
	samplesInResources = MapThread[
		Resource[Name -> ToString[Unique[]], Sample -> #1, Amount -> #2]&,
		{samplesIn, Flatten[resolvedLoadingSampleVolume]}
	];
	pooledSamplesInResources = speRepool[samplesInResources, poolLengths];

	(* create the resource for containers in *)
	containersIn = Map[cacheLookup[cache, #, Container]&, samplesIn];
	containersInModels = Map[cacheLookup[cache, #, Model]&, containersIn];
	containersInResources = Map[Resource[Name -> ToString[#[ID]], Sample -> #]&, containersIn];
	pooledContainersInResources = speRepool[containersInResources, poolLengths];
	(* if we need to transfer sample , we will call ExperimentTransfer, there is no need for us to create resource of transfer plat e*)

	(* create the resource of ExtractionCartridge *)
	resolvedExtractionCartridgeModel = Map[
		If[MatchQ[#, ObjectP[Object]],
			cacheLookup[cache, #, Model],
			#
		]&,
		resolvedExtractionCartridge
	];
	resolvedExtractionCartridgeType = Map[cacheLookup[cache, #, Type]&, resolvedExtractionCartridgeModel];
	(* get resolved instrument models *)
	resolvedInstrumentModel = Map[
		If[MatchQ[#, ObjectP[Object]],
			cacheLookup[cache, #, Model],
			#
		]&,
		resolvedInstrument
	];

	(* create extractioncartridgecap resource*)
	extractionCartridgeCapResources = MapThread[
		Switch[{#1, #2},

			(*only need cap when we have to inject sample to syringe cartridge*)
			{TypeP[Model[Container, ExtractionCartridge]], ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]]},
			cartridgeSize = cacheLookup[cache, #3, MaxVolume];
			Switch[cartridgeSize,

				3. Milliliter,
				Resource[Sample -> Model[Item, Cap, "3 cc cartridge cap"]],

				6. Milliliter,
				Resource[Sample -> Model[Item, Cap, "6 cc cartridge cap"]]
			],

			_,
			Null
		]&,
		{resolvedExtractionCartridgeType, resolvedInstrumentModel, resolvedExtractionCartridgeModel}
	];
	(* create aliquot target container resource and associated targets *)
	(* flat twice because we are dealing with pool samples and each sample can end up in multiple wells *)
	flatAliquotTarget = If[NullQ[resolvedAliquotTargets],
		ConstantArray[Null, Length[Flatten[resolvedAliquotTargets, 2]]],
		Flatten[resolvedAliquotTargets, 2]
	];
	{
		aliquotSampleLabel,
		destinationContainerResource
	} = If[AllTrue[flatAliquotTarget, NullQ],
		(
			{
				ConstantArray[Null, Length[flatAliquotTarget]],
				ConstantArray[Null, Length[flatAliquotTarget]]
			}
		),
		(
			(* get a unique plate type and it's label *)
			flatAliquotTargetNoNulls = DeleteCases[flatAliquotTarget, NullP];
			aliquotLabelAndObject = flatAliquotTargetNoNulls[[All, 3 ;; 4]];
			uniqueAliquotLabelAndObject = DeleteDuplicates[aliquotLabelAndObject];
			(* create resource based on *)
			aliquotContainerResource = Map[
				Resource[
					Sample -> #[[2]],
					Name -> #[[1]]
				]&,
				uniqueAliquotLabelAndObject
			];
			aliquotContainerResourceLabelRule = Flatten[Map[#[Name] -> #&, aliquotContainerResource]];
			Transpose[Map[
				If[NullQ[#],
					{Null, Null},
					{"AliquotSample"<>ToString[Unique[]], #[[3]] /. aliquotContainerResourceLabelRule}
				]&,
				flatAliquotTarget
			]]
		)
	];

	{
		destinationWell,
		destinationVolume,
		destinationContainerLabel,
		destinationContainerModel
	} = Transpose[Map[
		If[NullQ[#],
			{Null, Null, Null, Null},
			#
		]&,
		flatAliquotTarget
	]];

	(* for each sample, it can go to multiple wells, so this is a pool of a pool *)
	(* we also have to replace 0 to 1, because ever if there is no aliquot needed, we still have to pick that one sample still *)
	aliquotLength = Map[Map[Function[{x}, Length[x]]], resolvedAliquotTargets] /. 0 -> 1;

	(* now we go everything by batch ID that we resolve *)
	batchedOptions = Experiment`Private`groupByKey[
		Flatten[{
			DeleteCases[myResolvedOptions, Alternatives @@ (Join[Keys[SafeOptions[ProtocolOptions]], {PreparatoryUnitOperations}]) -> _],
			Samples -> myPooledSamples,
			SamplesResource -> pooledSamplesInResources,
			SamplesIndex -> Table[n, {n, Length[myPooledSamples]}]
		}],
		If[MatchQ[resolvedPreparation, Robotic],
			{Instrument},
			{SPEBatchID, Instrument}
		]
	];

	(* get the resource that is batch dependent *)
	unorderedResource = Map[
		Function[{options},
			Module[{nPool, instrument, instrumentModel, batchID, timeRelatedKeys, solutionRelatedKeys, solutionVolumeRelatedKeys, timedOptionValue, estimatedRunTime, instrumentResource,
				TotalPreFlushingSolutionVolume, TotalConditioningSolutionVolume, TotalWashingSolutionVolume, TotalSecondaryWashingSolutionVolume, TotalTertiaryWashingSolutionVolume,
				TotalElutingSolutionVolume, TotalQuantitativeLoadingSampleSolutionVolume, typePreFlushingSolution, typeConditioningSolution, typeWashingSolution,
				typeSecondaryWashingSolution, typeTertiaryWashingSolution, typeElutingSolution, groupedSolution,
				uniqueVolume, uniqueBuffer, premodSolutionResource,
				preflushRes, conditionRes, washRes, secWashRes, terWashRes, eluteRes, quanLoadRes, primingRes,
				preflushPlace, conditionPlace, washPlace, secWashPlace, terWashPlace, elutePlace, quanLoadPlace, primingPlace,
				containerOutRelatedKeys, preFlushContainerOutResource, conditioningContainerOutResource, washingContainerOutResource,
				secondaryWashingContainerOutResource, tertiaryContainerOutResource, elutingContainerOutResource, loadingSampleContainerOutResource,
				sampleOrder, cartridgePlacement, expandedInstrumentResource, preFlushContainerOutDeckPlacement, conditioningContainerOutDeckPlacement,
				washingContainerOutDeckPlacement, secondaryWashingContainerOutDeckPlacement, tertiaryContainerOutDeckPlacement, elutingContainerOutDeckPlacement,
				loadingSampleContainerOutDeckPlacement, extractionCartridgeResource, wasteContainerResource, containerOutRelatedLabelKeys,
				allSolutionVolume, allSolutionType, solutionTemperatureRelatedKeys, allSolutionTemperature, allSolutionTemperatureWithQuant, uniqueBufferTemperature, quantitativeTemperature, poolLengthUnorderResource, resourceRulesAndNull
			},
				sampleOrder = Lookup[options[[2]], SamplesIndex];
				nPool = Length[Lookup[options[[2]], Samples]];
				poolLengthUnorderResource = Length /@ Lookup[options[[2]], Samples];
				instrument = Lookup[options[[1]], Instrument];
				instrumentModel = If[MatchQ[instrument, ObjectP[Object]],
					Experiment`Private`cacheLookup[cache, instrument, Model],
					instrument
				];

				batchID = Lookup[options[[1]], If[MatchQ[resolvedPreparation, Robotic], Preparation, SPEBatchID]];
				timeRelatedKeys = {
					PreFlushingSolutionDrainTime,
					MaxPreFlushingSolutionDrainTime,
					ConditioningSolutionTemperatureEquilibrationTime,
					ConditioningSolutionDrainTime,
					MaxConditioningSolutionDrainTime,
					LoadingSampleDrainTime,
					MaxLoadingSampleDrainTime,
					WashingSolutionDrainTime,
					MaxWashingSolutionDrainTime,
					SecondaryWashingSolutionDrainTime,
					MaxSecondaryWashingSolutionDrainTime,
					TertiaryWashingSolutionDrainTime,
					MaxTertiaryWashingSolutionDrainTime,
					ElutingSolutionDrainTime,
					MaxElutingSolutionDrainTime};
				solutionRelatedKeys = {
					PreFlushingSolution,
					ConditioningSolution,
					WashingSolution,
					SecondaryWashingSolution,
					TertiaryWashingSolution,
					ElutingSolution,
					QuantitativeLoadingSampleSolution
				};
				solutionVolumeRelatedKeys = {
					PreFlushingSolutionVolume,
					ConditioningSolutionVolume,
					WashingSolutionVolume,
					SecondaryWashingSolutionVolume,
					TertiaryWashingSolutionVolume,
					ElutingSolutionVolume,
					QuantitativeLoadingSampleVolume
				};
				solutionTemperatureRelatedKeys = {
					PreFlushingSolutionTemperature,
					ConditioningSolutionTemperature,
					WashingSolutionTemperature,
					SecondaryWashingSolutionTemperature,
					TertiaryWashingSolutionTemperature,
					ElutingSolutionTemperature
				};
				containerOutRelatedKeys = {
					PreFlushingSolutionCollectionContainer,
					ConditioningSolutionCollectionContainer,
					WashingSolutionCollectionContainer,
					SecondaryWashingSolutionCollectionContainer,
					TertiaryWashingSolutionCollectionContainer,
					ElutingSolutionCollectionContainer,
					LoadingSampleFlowthroughContainer
				};
				containerOutRelatedLabelKeys = {
					PreFlushingCollectionContainerOutLabel,
					ConditioningCollectionContainerOutLabel,
					WashingCollectionContainerOutLabel,
					SecondaryWashingCollectionContainerOutLabel,
					TertiaryWashingCollectionContainerOutLabel,
					ElutingCollectionContainerOutLabel,
					LoadingSampleFlowthroughCollectionContainerOutLabel
				};

				(* INSTRUMENT resource *)
				(* guesstimate time for instrument*)
				timedOptionValue = Lookup[options[[2]], timeRelatedKeys] /. Null -> 0 Minute;
				(* add 5% of time demand *)
				estimatedRunTime = Total[Flatten[timedOptionValue]] * 1.05;
				instrumentResource = Resource[
					Name -> "SPE Instrument " <> ToString[batchID],
					Instrument -> Download[Lookup[options[[1]], Instrument], Object],
					Time -> estimatedRunTime
				];
				(* expand instrument resource to index match *)
				expandedInstrumentResource = ConstantArray[instrumentResource, nPool];

				(* BUFFERs calculation; we try if possible, to group all the same buffer into one container
					Except - GX271, we will just force them to be in different tank because the way that we have separate sub-procedure for each step and that relies on tank opposition *)
				(*straighten out solution and volume *)
				allSolutionVolume = Flatten[Lookup[options[[2]], solutionVolumeRelatedKeys]] /. Null -> 0 Milliliter;
				allSolutionType = Flatten[Lookup[options[[2]], solutionRelatedKeys]];
				allSolutionTemperature = Flatten[Lookup[options[[2]], solutionTemperatureRelatedKeys]];
				(* because we don't allow user to define temperature of quantitative laoding sample solution, so we force it to be room temp *)
				quantitativeTemperature = Table[25 Celsius, Total[poolLengthUnorderResource]];
				allSolutionTemperatureWithQuant = Flatten[{allSolutionTemperature, quantitativeTemperature}];

				(* group buffer of the same type and temperature together -> we will use transport warm or transport chill later in compile *)
				groupedSolution = Experiment`Private`groupByKey[{
					SolutionObject -> allSolutionType,
					SolutionVolume -> allSolutionVolume,
					SolutionTemperature -> allSolutionTemperatureWithQuant
				}, {SolutionObject, SolutionTemperature}];
				(* sum volume of the same buffer *)
				uniqueVolume = Map[Total[Flatten[Lookup[#[[2]], SolutionVolume]]]&, groupedSolution];
				(* get all the unique  different type of the same buffer *)
				uniqueBuffer = Lookup[groupedSolution[[All, 1]], SolutionObject];
				uniqueBufferTemperature = Lookup[groupedSolution[[All, 1]], SolutionTemperature];
				premodSolutionResource = {
					SolutionObject -> PickList[uniqueBuffer, Map[!MatchQ[#, Null | {Null..}]&, uniqueBuffer]],
					SolutionVolume -> PickList[uniqueVolume, Map[!MatchQ[#, Null | {Null..}]&, uniqueBuffer]],
					SolutionTemperature -> PickList[uniqueBufferTemperature, Map[!MatchQ[#, Null | {Null..}]&, uniqueBuffer]]
				};
				(* set up cartridge placement *)
				cartridgePlacement = Lookup[options[[2]], CartridgePlacement];

				(* BUFFER MODIFIERs and create resource, base on each instrument constrains *)
				{
					{preflushRes, conditionRes, washRes, secWashRes, terWashRes, eluteRes, quanLoadRes, primingRes},
					{preflushPlace, conditionPlace, washPlace, secWashPlace, terWashPlace, elutePlace, quanLoadPlace, primingPlace}
				} = If[MatchQ[instrumentModel, ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]]],
					(*GX271 - there will be no attempt to pull solution together, placement is critical for sub procedure *)
					Module[
						{preFlushingResource, expandedPreFlushingResource, preFlushingPlacement, expandedPreFlushingPlacement, conditioningResource, conditioningPlacement, expandedConditioningResource, expandedConditioningPlacement,
							elutingResource, elutingPlacement, expandedElutingResource, expandedElutingPlacement, washingResource, washingPlacement, expandedWashingResource, expandedWashingPlacement, secondaryWashingResource,
							expandedSecondaryWashingResource, expandedSecondaryWashingPlacement, secondaryWashingPlacement, tertiaryWashingResource, tertiaryWashingPlacement, expandedTertiaryWashingResource, expandedTertiaryWashingPlacement,
							allOfWashVolume, semiWashingResource, expandedPrimingResource, expandedPrimingPlacement, typeQuantitativeLoadingSampleSolution,
							preFlushSampleContainer, preFlushSampleContainerModel, conditioningSampleContainer, conditioningSampleContainerModel,
							elutingSampleContainer, elutingSampleContainerModel, washingSampleContainer, washingSampleContainerModel, secWashSampleContainer,
							secWashSampleContainerModel, terWashSampleContainer, terWashSampleContainerModel},
						(* this is special for GX 271 where bottle is fixed, so we have to resolve it step by step *)
						{
							TotalPreFlushingSolutionVolume,
							TotalConditioningSolutionVolume,
							TotalWashingSolutionVolume,
							TotalSecondaryWashingSolutionVolume,
							TotalTertiaryWashingSolutionVolume,
							TotalElutingSolutionVolume,
							TotalQuantitativeLoadingSampleSolutionVolume
						} = Map[
							(Total[Flatten[#] /. Null -> 0 Milliliter])&,
							Lookup[options[[2]], solutionVolumeRelatedKeys]
						];
						(*type of buffer*)
						{
							typePreFlushingSolution,
							typeConditioningSolution,
							typeWashingSolution,
							typeSecondaryWashingSolution,
							typeTertiaryWashingSolution,
							typeElutingSolution,
							typeQuantitativeLoadingSampleSolution
						} = Map[First[Flatten[#]]&, Lookup[options[[2]], solutionRelatedKeys]];

						(* preflush, equilibrate and eluting are the same *)
						(* position of buffer bottles are fix to make batch calculation easier *)
						preFlushingResource = Switch[typePreFlushingSolution,
							(* if it is nothing leave it*)
							Null,
							Null,
							(* if it is a model, we have to put it in the right bottle *)
							ObjectP[Model[Sample]],
							(
								Resource[
									Name -> "PreFlushing Solution" <> ToString[batchID],
									Amount -> TotalPreFlushingSolutionVolume + 125 Milliliter,
									Sample -> typePreFlushingSolution,
									Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
									RentContainer -> True
								]
							),
							(* if it's an object sample, check what kind of contaier it's in, if it's already in Gilson bottle already, then leave it *)
							ObjectP[Object[Sample]],
							(
								preFlushSampleContainerModel = typePreFlushingSolution[Container][Object][Model][Object];
								If[MatchQ[preFlushSampleContainerModel, ObjectP[Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"]]],
									Resource[
										Name -> "PreFlushing Solution" <> ToString[batchID],
										Sample -> typePreFlushingSolution,
										RentContainer -> True
									],
									Resource[
										Name -> "PreFlushing Solution" <> ToString[batchID],
										Sample -> typePreFlushingSolution,
										Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
										Amount -> typePreFlushingSolution[Volume],
										RentContainer -> True
									]
								]
							)
						];
						preFlushingPlacement = If[MatchQ[typePreFlushingSolution, Null],
							Null,
							{"Deck Slot", "A1", "1"}
						];
						(* expand to index match *)
						expandedPreFlushingResource = ConstantArray[preFlushingResource, nPool];
						expandedPreFlushingPlacement = ConstantArray[preFlushingPlacement, nPool];

						conditioningResource = Switch[typeConditioningSolution,
							(* if it is nothing leave it*)
							Null,
							Null,
							(* if it is a model, we have to put it in the right bottle *)
							ObjectP[Model[Sample]],
							(
								Resource[
									Name -> "Conditioning Solution" <> ToString[batchID],
									Amount -> TotalConditioningSolutionVolume + 125 Milliliter,
									Sample -> typeConditioningSolution,
									Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
									RentContainer -> True
								]
							),
							(* if it's an object sample, check what kind of contaier it's in, if it's already in Gilson bottle already, then leave it *)
							ObjectP[Object[Sample]],
							(
								conditioningSampleContainerModel = typeConditioningSolution[Container][Object][Model][Object];
								If[MatchQ[conditioningSampleContainerModel, ObjectP[Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"]]],
									Resource[
										Name -> "Conditioning Solution" <> ToString[batchID],
										Sample -> typeConditioningSolution,
										RentContainer -> True
									],
									Resource[
										Name -> "Conditioning Solution" <> ToString[batchID],
										Sample -> typeConditioningSolution,
										Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
										Amount -> typeConditioningSolution[Volume],
										RentContainer -> True
									]
								]
							)
						];
						conditioningPlacement = If[MatchQ[typeConditioningSolution, Null],
							Null,
							{"Deck Slot", "A1", "2"}
						];

						(* expand to index match *)
						expandedConditioningResource = ConstantArray[conditioningResource, nPool];
						expandedConditioningPlacement = ConstantArray[conditioningPlacement, nPool];

						elutingResource = Switch[typeElutingSolution,
							(* if it is nothing leave it*)
							Null,
							Null,
							(* if it is a model, we have to put it in the right bottle *)
							ObjectP[Model[Sample]],
							(
								Resource[
									Name -> "Eluting Solution" <> ToString[batchID],
									Amount -> TotalElutingSolutionVolume + 125 Milliliter,
									Sample -> typeElutingSolution,
									Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
									RentContainer -> True
								]
							),
							(* if it's an object sample, check what kind of contaier it's in, if it's already in Gilson bottle already, then leave it *)
							ObjectP[Object[Sample]],
							(
								elutingSampleContainerModel = typeElutingSolution[Container][Object][Model][Object];
								If[MatchQ[elutingSampleContainerModel, ObjectP[Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"]]],
									Resource[
										Name -> "Eluting Solution" <> ToString[batchID],
										Sample -> typeElutingSolution,
										RentContainer -> True
									],
									Resource[
										Name -> "Eluting Solution" <> ToString[batchID],
										Sample -> typeElutingSolution,
										Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
										Amount -> typeElutingSolution[Volume],
										RentContainer -> True
									]
								]
							)
						];
						elutingPlacement = If[MatchQ[typeElutingSolution, Null],
							Null,
							{"Deck Slot", "A1", "3"}
						];
						(* expand to index match *)
						expandedElutingResource = ConstantArray[elutingResource, nPool];
						expandedElutingPlacement = ConstantArray[elutingPlacement, nPool];

						(* wash is a special case, because usually sec and ter wash are the same as pri wash, so better put them together *)
						allOfWashVolume = Total[Flatten[PickList[
							{TotalWashingSolutionVolume, TotalSecondaryWashingSolutionVolume, TotalTertiaryWashingSolutionVolume},
							{typeWashingSolution, typeSecondaryWashingSolution, typeTertiaryWashingSolution},
							ObjectReferenceP[typeWashingSolution]
						]]];

						(* wash solution *)
						{semiWashingResource, washingPlacement} = Switch[typeWashingSolution,
							(* we always need reservoir volume for priming pump *)
							Null,
							{
								Resource[
									Name -> "Pump Priming Solution" <> ToString[batchID],
									Amount -> 1500 Milliliter,
									Sample -> Model[Sample, "Milli-Q water"],
									Container -> Model[Container, Vessel, "10L Polypropylene Carboy"],
									RentContainer -> True
								],
								Null
							},

							(* otherwise, prepare as requested *)
							ObjectP[Model[Sample]],
							{
								Resource[
									Name -> "Washing Solution" <> ToString[batchID],
									Amount -> allOfWashVolume + 1500 Milliliter,
									Sample -> typeWashingSolution,
									Container -> Model[Container, Vessel, "10L Polypropylene Carboy"],
									RentContainer -> True
								],
								"Reservoir"
							},

							ObjectP[Object[Sample]],
							washingSampleContainerModel = typeWashingSolution[Container][Object][Model][Object];
							If[MatchQ[washingSampleContainerModel, Model[Container, Vessel, "10L Polypropylene Carboy"]],
								{
									Resource[
										Name -> "Washing Solution" <> ToString[batchID],
										Sample -> typeWashingSolution,
										RentContainer -> True
									],
									"Reservoir"
								},
								{
									Resource[
										Name -> "Washing Solution" <> ToString[batchID],
										Sample -> typeWashingSolution,
										Container -> Model[Container, Vessel, "10L Polypropylene Carboy"],
										Amount -> typeWashingSolution[Volume],
										RentContainer -> True
									],
									"Reservoir"
								}
							]
						];

						expandedPrimingResource = ConstantArray[semiWashingResource, nPool];
						expandedPrimingPlacement = ConstantArray[washingPlacement, nPool];
						(* expand to index match *)
						washingResource = If[MatchQ[typeWashingSolution, Null],
							Null,
							semiWashingResource
						];
						expandedWashingResource = ConstantArray[washingResource, nPool];
						expandedWashingPlacement = ConstantArray[washingPlacement, nPool];

						(* secondary wash solution *)
						{secondaryWashingResource, secondaryWashingPlacement} = Switch[typeSecondaryWashingSolution,

							Null,
							{Null, Null},

							(* if use the same wash buffer, no need to create any resource *)
							typeWashingSolution,
							{washingResource, washingPlacement},

							(* if it is a model, we have to put it in the right bottle *)
							ObjectP[Model[Sample]],
							{
								Resource[
									Name -> "Solution 4" <> ToString[batchID],
									Amount -> TotalSecondaryWashingSolutionVolume + 125 Milliliter,
									Sample -> typeSecondaryWashingSolution,
									Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
									RentContainer -> True
								],
								{"Deck Slot", "A1", "4"}
							},

							(* if it's an object sample, check what kind of contaier it's in, if it's already in Gilson bottle already, then leave it *)
							ObjectP[Object[Sample]],
							(
								secWashSampleContainerModel = typeSecondaryWashingSolution[Container][Object][Model][Object];
								If[MatchQ[secWashSampleContainerModel, ObjectP[Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"]]],
									{
										Resource[
											Name -> "Solution 4" <> ToString[batchID],
											Sample -> typeSecondaryWashingSolution,
											RentContainer -> True
										],
										{"Deck Slot", "A1", "4"}
									},
									{
										Resource[
											Name -> "Eluting Solution" <> ToString[batchID],
											Sample -> typeSecondaryWashingSolution,
											Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
											Amount -> typeSecondaryWashingSolution[Volume],
											RentContainer -> True
										],
										{"Deck Slot", "A1", "4"}
									}
								]
							)
						];
						(* expand to index match *)
						expandedSecondaryWashingResource = ConstantArray[secondaryWashingResource, nPool];
						expandedSecondaryWashingPlacement = ConstantArray[secondaryWashingPlacement, nPool];

						(* tertiary wash solution *)
						{tertiaryWashingResource, tertiaryWashingPlacement} = Switch[typeTertiaryWashingSolution,

							Null,
							{Null, Null},

							(* if use the same wash buffer, no need to create any resource *)
							typeWashingSolution,
							{washingResource, washingPlacement},

							typeSecondaryWashingSolution,
							{secondaryWashingResource, secondaryWashingPlacement},


							(* if it is a model, we have to put it in the right bottle *)
							ObjectP[Model[Sample]],
							{
								Resource[
									Name -> "Solution 4" <> ToString[batchID],
									Amount -> TotalTertiaryWashingSolutionVolume + 125 Milliliter,
									Sample -> typeTertiaryWashingSolution,
									Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
									RentContainer -> True
								],
								{"Deck Slot", "A1", "4"}
							},

							(* if it's an object sample, check what kind of contaier it's in, if it's already in Gilson bottle already, then leave it *)
							ObjectP[Object[Sample]],
							(
								terWashSampleContainerModel = typeTertiaryWashingSolution[Container][Object][Model][Object];
								If[MatchQ[terWashSampleContainerModel, ObjectP[Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"]]],
									{
										Resource[
											Name -> "Solution 4" <> ToString[batchID],
											Sample -> typeTertiaryWashingSolution,
											RentContainer -> True
										],
										{"Deck Slot", "A1", "4"}
									},
									{
										Resource[
											Name -> "Eluting Solution" <> ToString[batchID],
											Sample -> typeTertiaryWashingSolution,
											Container -> Model[Container, Vessel, "Gilson Reagent Bottle -  Tall"],
											Amount -> typeTertiarySolution[Volume],
											RentContainer -> True
										],
										{"Deck Slot", "A1", "4"}
									}
								]
							)
						];
						(* expand to index match *)
						expandedTertiaryWashingResource = ConstantArray[tertiaryWashingResource, nPool];
						expandedTertiaryWashingPlacement = ConstantArray[tertiaryWashingPlacement, nPool];

						(* output for GX271 *)
						{
							{
								expandedPreFlushingResource,
								expandedConditioningResource,
								expandedWashingResource,
								expandedSecondaryWashingResource,
								expandedTertiaryWashingResource,
								expandedElutingResource,
								(* we don't allow quantitative loading for GX271 for now *)
								ConstantArray[Null, nPool],
								expandedPrimingResource
							}
							,
							{
								expandedPreFlushingPlacement,
								expandedConditioningPlacement,
								expandedWashingPlacement,
								expandedSecondaryWashingPlacement,
								expandedTertiaryWashingPlacement,
								expandedElutingPlacement,
								(* we don't allow quantitative loading for GX271 for now *)
								ConstantArray[Null, nPool],
								expandedPrimingPlacement
							}
						}
					], (* end module for gx271*)

					(* All the non-GX271 branches *)
					Module[
						{modSolutionVolume, modSolutionType, modContainer, subSolutionResource, resourceRules, modSolutionTemperature,
						preFlushResource, conditioningResource, washingResource, secondaryWashingResource, tertiaryResource, elutingResource,
						quantitativeLoadingSampleResource, preFlushPlacement, conditioningPlacement, washingPlacement,
						secondaryWashingPlacement, tertiaryPlacement, elutingPlacement, quantitativeLoadingSamplePlacement, preFlushingSolution,
						conditioningSolution, washingSolution, secondaryWashingSolution, tertiaryWashingSolution, elutingSolution,
						quantitativeLoadingSampleSolution, preFlushingTemperature, conditioningTemperature, washingTemperature, secondaryWashingTemperature,
						tertiaryWashingTemperature, elutingTemperature, quantitativeLoadingSampleResourceUnpool, resName},

						modSolutionVolume = Lookup[premodSolutionResource, SolutionVolume] * 1.1;
						modSolutionType = Lookup[premodSolutionResource, SolutionObject];
						modSolutionTemperature = Lookup[premodSolutionResource, SolutionTemperature];
						modContainer = Map[PreferredContainer[#]&, modSolutionVolume];
						subSolutionResource = Map[
							(
								resName = "Buffer" <> ToString[Unique[]] <> ToString[batchID];
								Which[
									(* if it's a sample, don't move the container *)
									MatchQ[#1[[1]], ObjectP[Object[Sample]]],
									Resource[
										Name -> resName,
										Sample -> #1[[1]]
									],

									(* if it's a container, get the content as sample *)
									MatchQ[#1[[1]], ObjectP[Object[Container]]],
									Resource[
										Name -> resName,
										Sample -> #1[[1]]
									],

									(* if it's not a sample or a container, use the model to get the resource *)
									True,
									Resource[
										Name -> "Buffer" <> ToString[Unique[]] <> ToString[batchID],
										Sample -> #1[[1]],
										Amount -> #1[[2]],
										Container -> #1[[3]]
									]
								]
							)&,
							Transpose[{modSolutionType, modSolutionVolume, modContainer}]
						];
						(* set list of rules to change the resolve option  to resource *)
						resourceRules = MapThread[
							{#1, #2} -> #3&,
							{
								modSolutionType,
								modSolutionTemperature,
								subSolutionResource
							}
						];
						resourceRulesAndNull = Join[resourceRules, {{Null, _} -> Null}];

						(* loop across all resolved solutions step and replace with resource *)
						{
							preFlushingSolution,
							conditioningSolution,
							washingSolution,
							secondaryWashingSolution,
							tertiaryWashingSolution,
							elutingSolution,
							quantitativeLoadingSampleSolution
						} = Lookup[options[[2]], solutionRelatedKeys];
						{
							preFlushingTemperature,
							conditioningTemperature,
							washingTemperature,
							secondaryWashingTemperature,
							tertiaryWashingTemperature,
							elutingTemperature
						} = Lookup[options[[2]], solutionTemperatureRelatedKeys];

						{
							preFlushResource,
							conditioningResource,
							washingResource,
							secondaryWashingResource,
							tertiaryResource,
							elutingResource,
							quantitativeLoadingSampleResourceUnpool
						} = Map[# /. resourceRulesAndNull&,
							{
								Transpose[{preFlushingSolution, preFlushingTemperature}],
								Transpose[{conditioningSolution, conditioningTemperature}],
								Transpose[{washingSolution, washingTemperature}],
								Transpose[{secondaryWashingSolution, secondaryWashingTemperature}],
								Transpose[{tertiaryWashingSolution, tertiaryWashingTemperature}],
								Transpose[{elutingSolution, elutingTemperature}],
								Transpose[{Flatten[quantitativeLoadingSampleSolution], Flatten[quantitativeTemperature]}]
							}
						];
						quantitativeLoadingSampleResource = TakeList[quantitativeLoadingSampleResourceUnpool, poolLengthUnorderResource];
						(*						*)(* special case here *)
						(*						quantitativeLoadingSampleResource = Map[FirstOrDefault[#, #]&, quantitativeLoadingSampleSolution];*)

						(* set everything to Null*)
						{
							preFlushPlacement,
							conditioningPlacement,
							washingPlacement,
							secondaryWashingPlacement,
							tertiaryPlacement,
							elutingPlacement,
							quantitativeLoadingSamplePlacement
						} = Map[ConstantArray[(# /. {_ -> Null}), nPool]&,
							{
								preFlushingSolution,
								conditioningSolution,
								washingSolution,
								secondaryWashingSolution,
								tertiaryWashingSolution,
								elutingSolution,
								quantitativeLoadingSampleSolution
							}
						];

						(* output *)
						{
							{
								preFlushResource,
								conditioningResource,
								washingResource,
								secondaryWashingResource,
								tertiaryResource,
								elutingResource,
								quantitativeLoadingSampleResource,
								(* there is no pump priming in this branch *)
								ConstantArray[Null, nPool]
							},
							{
								preFlushPlacement,
								conditioningPlacement,
								washingPlacement,
								secondaryWashingPlacement,
								tertiaryPlacement,
								elutingPlacement,
								quantitativeLoadingSamplePlacement,
								(* there is no pump priming in this branch *)
								ConstantArray[Null, nPool]
							}
						}
					](* end module manual filter *)

				]; (* end of buffer switch*)

				(* Container out resource *)
				{
					preFlushContainerOutResource,
					conditioningContainerOutResource,
					washingContainerOutResource,
					secondaryWashingContainerOutResource,
					tertiaryContainerOutResource,
					elutingContainerOutResource,
					loadingSampleContainerOutResource,
					preFlushContainerOutDeckPlacement,
					conditioningContainerOutDeckPlacement,
					washingContainerOutDeckPlacement,
					secondaryWashingContainerOutDeckPlacement,
					tertiaryContainerOutDeckPlacement,
					elutingContainerOutDeckPlacement,
					loadingSampleContainerOutDeckPlacement,
					extractionCartridgeResource,
					wasteContainerResource
				} = Switch[instrumentModel,

					(*GX271 - this is simple, the well out will be assign by the column position and there can be only on plate at a time*)
					ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]],
						(* loop across all container out *)
						Module[
						{containerOut, containerOutUnique, containerOutResource, containerOutResourceRule, preFlushContainerOut,
							conditioningContainerOut,
							washingContainerOut,
							secondaryWashingContainerOut,
							tertiaryContainerOut,
							elutingContainerOut,
							loadingSampleContainerOut,
							preFlushContainerOutPlacement,
							conditioningContainerOutPlacement,
							washingContainerOutPlacement,
							secondaryWashingContainerOutPlacement,
							tertiaryContainerOutPlacement,
							elutingContainerOutPlacement,
							loadingSampleContainerOutPlacement,
							cartridgeResources,
							wasteContainer,
							containerOutLabel,
							containerOutAndLabel,
							containerOutAndLabelUnique
						},
						(* this is a fake waste container just for simulation *)
						wasteContainer = ConstantArray[
							Resource[
								Sample -> Model[Container, Vessel, "id:aXRlGnZmOOB9"],
								Name -> "simulated waste"
							],
							Length[Lookup[options[[2]], ExtractionCartridge]]
						];
						cartridgeResources = Map[Resource[Sample -> #]&, Lookup[options[[2]], ExtractionCartridge]];
						containerOut = Lookup[options[[2]], containerOutRelatedKeys];
						containerOutLabel = Lookup[options[[2]], containerOutRelatedLabelKeys];
						containerOutAndLabel = Transpose[{Flatten[containerOut], Flatten[containerOutLabel]}];
						containerOutAndLabelUnique = DeleteDuplicates[containerOutAndLabel];
						containerOutResource = Map[If[MatchQ[#[[1]], ObjectP[]],
							(
								Resource[
									Name -> #[[2]],
									Sample -> #[[1]]
								]
							),
							Nothing
						]&,
							containerOutAndLabelUnique
						];
						containerOutResourceRule = Map[#[Name] -> #&, containerOutResource];
						{
							preFlushContainerOut,
							conditioningContainerOut,
							washingContainerOut,
							secondaryWashingContainerOut,
							tertiaryContainerOut,
							elutingContainerOut,
							loadingSampleContainerOut
						} = Map[
							# /. containerOutResourceRule&,
							containerOutLabel
						];
						{
							preFlushContainerOutPlacement,
							conditioningContainerOutPlacement,
							washingContainerOutPlacement,
							secondaryWashingContainerOutPlacement,
							tertiaryContainerOutPlacement,
							elutingContainerOutPlacement,
							loadingSampleContainerOutPlacement
						} = Map[
							# /. ObjectP[] -> {"Deck Slot", "A3", "Collection Slot"}&,
							containerOut
						];

						(* output *)
						{
							preFlushContainerOut,
							conditioningContainerOut,
							washingContainerOut,
							secondaryWashingContainerOut,
							tertiaryContainerOut,
							elutingContainerOut,
							loadingSampleContainerOut,
							preFlushContainerOutPlacement,
							conditioningContainerOutPlacement,
							washingContainerOutPlacement,
							secondaryWashingContainerOutPlacement,
							tertiaryContainerOutPlacement,
							elutingContainerOutPlacement,
							loadingSampleContainerOutPlacement,
							cartridgeResources,
							wasteContainer
						}
					],

					(*These are all the branches that go down ExperimentFilter *)
					ObjectP[{Model[Instrument, Centrifuge], Model[Instrument, SyringePump], Model[Instrument, FilterBlock]}] | ObjectP[Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"]] | ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]], (* last two here are the MPE2 and the sterile MPE2 *)
						Module[
						{containerOut, containerOutResource, containerOutResourceRule, preFlushContainerOut,
							conditioningContainerOut,
							washingContainerOut,
							secondaryWashingContainerOut,
							tertiaryContainerOut,
							elutingContainerOut,
							loadingSampleContainerOut,
							preFlushContainerOutPlacement,
							conditioningContainerOutPlacement,
							washingContainerOutPlacement,
							secondaryWashingContainerOutPlacement,
							tertiaryContainerOutPlacement,
							elutingContainerOutPlacement,
							loadingSampleContainerOutPlacement,
							cartridgeResources,
							wasteContainer,
							containerOutLabel,
							containerOutAndLabel,
							containerOutAndLabelUnique
						},
						(* this is a fake waste container, just for simulation *)
						wasteContainer = ConstantArray[
							Resource[
								Sample -> Model[Container, Vessel, "id:aXRlGnZmOOB9"],
								Name -> "simulated waste"
							],
							Length[Lookup[options[[2]], ExtractionCartridge]]
						];

						cartridgeResources = Map[
							Resource[
								Sample -> #,
								Name -> "Cartridge" <> ToString[batchID]
							]&,
							Lookup[options[[2]], ExtractionCartridge]
						];
						containerOut = Lookup[options[[2]], containerOutRelatedKeys];
						containerOutLabel = Lookup[options[[2]], containerOutRelatedLabelKeys];
						containerOutAndLabel = Transpose[{Flatten[containerOut], Flatten[containerOutLabel]}];
						containerOutAndLabelUnique = DeleteDuplicates[containerOutAndLabel];
						containerOutResource = Map[If[MatchQ[#[[1]], ObjectP[]],
							(
								Resource[
									Name -> #[[2]],
									Sample -> #[[1]]
								]
							),
							Nothing
						]&,
							containerOutAndLabelUnique
						];

						containerOutResourceRule = Map[#[Name] -> #&, containerOutResource];

						{
							preFlushContainerOut,
							conditioningContainerOut,
							washingContainerOut,
							secondaryWashingContainerOut,
							tertiaryContainerOut,
							elutingContainerOut,
							loadingSampleContainerOut
						} = Map[# /. containerOutResourceRule&,
							containerOutLabel
						];
						{
							preFlushContainerOutPlacement,
							conditioningContainerOutPlacement,
							washingContainerOutPlacement,
							secondaryWashingContainerOutPlacement,
							tertiaryContainerOutPlacement,
							elutingContainerOutPlacement,
							loadingSampleContainerOutPlacement
						} = Map[
							ConstantArray[Null, nPool]&,
							containerOut
						];

						(* output *)
						{
							preFlushContainerOut,
							conditioningContainerOut,
							washingContainerOut,
							secondaryWashingContainerOut,
							tertiaryContainerOut,
							elutingContainerOut,
							loadingSampleContainerOut,
							preFlushContainerOutPlacement,
							conditioningContainerOutPlacement,
							washingContainerOutPlacement,
							secondaryWashingContainerOutPlacement,
							tertiaryContainerOutPlacement,
							elutingContainerOutPlacement,
							loadingSampleContainerOutPlacement,
							cartridgeResources,
							wasteContainer
						}
					], (* end module manual filter *)

					(* biotage cartrdighe is one by one and also the colection container *)
					ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]],
						Module[
							{containerOut, containerOutUnique, containerOutResource,
								containerOutResourceRule, preFlushContainerOut,
								conditioningContainerOut,
								washingContainerOut,
								secondaryWashingContainerOut,
								tertiaryContainerOut,
								elutingContainerOut,
								loadingSampleContainerOut,
								preFlushContainerOutPlacement,
								conditioningContainerOutPlacement,
								washingContainerOutPlacement,
								secondaryWashingContainerOutPlacement,
								tertiaryContainerOutPlacement,
								elutingContainerOutPlacement,
								loadingSampleContainerOutPlacement,
								cartridgeResources,
								wasteContainer,
								containerOutLabel,
								containerOutAndLabel,
								containerOutAndLabelUnique
							},

							(* for biotage, waste is always this type of type, and we already calculate by batch according this max volume of this tub alreayd *)
							wasteContainer = Table[
								Resource[
									Sample -> Model[Container, Vessel, "Biotage Pressure+48 Waste Tub"],
									Name -> "Biotage Waste" <> ToString[batchID]
								],
								nPool
							];
							cartridgeResources = Map[Resource[Sample -> #, Name -> "Cartridge" <> ToString[Unique[]]]&, Lookup[options[[2]], ExtractionCartridge]];

							containerOut = Lookup[options[[2]], containerOutRelatedKeys];
							containerOutLabel = Lookup[options[[2]], containerOutRelatedLabelKeys];
							containerOutAndLabel = Transpose[{Flatten[containerOut], Flatten[containerOutLabel]}];
							containerOutAndLabelUnique = DeleteDuplicates[containerOutAndLabel];
							containerOutResource = Map[If[
								MatchQ[#[[1]], ObjectP[]] && Not[NullQ[#[[2]]]],
								(
									Resource[
										Name -> #[[2]],
										Sample -> #[[1]]
									]
								),
								Nothing
							]&,
								containerOutAndLabelUnique
							];

							containerOutResourceRule = Map[#[Name] -> #&, containerOutResource];

							{
								preFlushContainerOut,
								conditioningContainerOut,
								washingContainerOut,
								secondaryWashingContainerOut,
								tertiaryContainerOut,
								elutingContainerOut,
								loadingSampleContainerOut
							} = Map[# /. containerOutResourceRule&,
								containerOutLabel
							];

							{
								preFlushContainerOutPlacement,
								conditioningContainerOutPlacement,
								washingContainerOutPlacement,
								secondaryWashingContainerOutPlacement,
								tertiaryContainerOutPlacement,
								elutingContainerOutPlacement,
								loadingSampleContainerOutPlacement
							} = Map[
								If[MatchQ[#, Null | {Null..}],
									ConstantArray[Null, nPool],
									cartridgePlacement
								]&,
								containerOut
							];

							(* output *)
							{
								preFlushContainerOut,
								conditioningContainerOut,
								washingContainerOut,
								secondaryWashingContainerOut,
								tertiaryContainerOut,
								elutingContainerOut,
								loadingSampleContainerOut,
								preFlushContainerOutPlacement,
								conditioningContainerOutPlacement,
								washingContainerOutPlacement,
								secondaryWashingContainerOutPlacement,
								tertiaryContainerOutPlacement,
								elutingContainerOutPlacement,
								loadingSampleContainerOutPlacement,
								cartridgeResources,
								wasteContainer
							}
						](* end of biotage *)

				]; (* end of switch for container *)

				(* output of big resource map *)
				{
					PreFlushingResource -> preflushRes,
					ConditioningResource -> conditionRes,
					WashingResource -> washRes,
					SecondaryWashingResource -> secWashRes,
					TertiaryWashingResource -> terWashRes,
					ElutingResource -> eluteRes,
					PrimingResource -> primingRes,
					QuantitativeLoadingResource -> quanLoadRes,
					PreFlushingPlacement -> preflushPlace,
					ConditioningPlacement -> conditionPlace,
					WashingPlacement -> washPlace,
					SecondaryWashingPlacement -> secWashPlace,
					TertiaryWashingPlacement -> terWashPlace,
					ElutingPlacement -> elutePlace,
					PrimingPlacement -> primingPlace,
					QuantitativeLoadingPlacement -> quanLoadPlace,
					PreFlushingContainerOutResource -> preFlushContainerOutResource,
					ConditioningContainerOutResource -> conditioningContainerOutResource,
					WashingContainerOutResource -> washingContainerOutResource,
					SecondaryWashingContainerOutResource -> secondaryWashingContainerOutResource,
					TertiaryWashingContainerOutResource -> tertiaryContainerOutResource,
					ElutingContainerOutResource -> elutingContainerOutResource,
					LoadingSampleContainerOutResource -> loadingSampleContainerOutResource,
					PreFlushingContainerOutPlacement -> preFlushContainerOutDeckPlacement,
					ConditioningContainerOutPlacement -> conditioningContainerOutDeckPlacement,
					WashingContainerOutPlacement -> washingContainerOutDeckPlacement,
					SecondaryWashingContainerOutPlacement -> secondaryWashingContainerOutDeckPlacement,
					TertiaryWashingContainerOutPlacement -> tertiaryContainerOutDeckPlacement,
					ElutingContainerOutPlacement -> elutingContainerOutDeckPlacement,
					LoadingSampleContainerOutPlacement -> loadingSampleContainerOutDeckPlacement,
					InstrumentResource -> expandedInstrumentResource,
					SampleOrder -> sampleOrder,
					Sample -> Lookup[options[[2]], Samples],
					SamplesResource -> Lookup[options[[2]], SamplesResource],
					ExtractionCartridgeResource -> extractionCartridgeResource,
					WasteContainerResource -> wasteContainerResource
				}
			]
		],
		batchedOptions
	];

	unorderedResourceMerged = Merge[unorderedResource, Flatten[#, 1]&] /. Association[x___] -> List[x];
	originalOrder = ToList[Ordering[Flatten[Lookup[unorderedResourceMerged, SampleOrder]]]];
	orderedResource = MapThread[
		#1 -> #2[[originalOrder]]&,
		{Keys[unorderedResourceMerged], Values[unorderedResourceMerged]}
	];
	totalEstimatedRunTime = Total[Map[#[Time]&, DeleteDuplicates[Lookup[orderedResource, InstrumentResource]]]];

	(* put both options and resource together then pull the batch out and loop to create unit operation by batch  *)
	optionsAndResourceByBatch = Experiment`Private`groupByKey[
		Join[
			DeleteCases[myResolvedOptions, Alternatives @@ (Join[Keys[SafeOptions[ProtocolOptions]], {PreparatoryUnitOperations}]) -> _],
			orderedResource,
			(* these are already in order with the original sample index*)
			{
				ExtractionCartridgeCapResource -> extractionCartridgeCapResources,
				AliquotLength -> aliquotLength
			}
		],
		{SPEBatchID}
	];

	(* we have to remove all the shared option from our resolved batched options *)
	mySharedOptions = {
		ProtocolOptions,
		SamplePrepOptionsNestedIndexMatching,
		ImageSampleOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		PreparationOption,
		SimulationOption,
		PrimitiveOutputOption,
		NonBiologyPostProcessingOptions
	};
	mySharedOptionsKeys = ToExpression /@ Keys[Flatten[Options /@ mySharedOptions]];

	(* Prepare unit operation*)

	unitOperationPackets = Module[
		{speUnitOp, speUnitOpNoResourcesIfRobotic},
		speUnitOp = Map[
			Function[{batchedResourceOptions},
				(* Only include non-hidden options from SPE. *)
				Module[{nonHiddenOptions, speOptions, optionsWithoutShared, instrument, instrumentModel, cartridgeModel,
					cartridge, cartridgeSize, speSharedOptions, valuesToBeFedIntoSPEUnitOpNoResources,	valuesToBeFedIntoSPEUnitOp},
					nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, SolidPhaseExtraction]];
					(* I have to get rid of shared options here *)
					optionsWithoutShared = KeyDrop[batchedResourceOptions[[2]], mySharedOptionsKeys];
					speOptions = optionsWithoutShared /. Association[x___] -> List[x];
					speSharedOptions = (KeyTake[batchedResourceOptions[[2]], mySharedOptionsKeys]) /. Association[x___] -> List[x];
					instrument = Lookup[speOptions, Instrument];
					instrumentModel = If[MatchQ[#, ObjectP[Object]],
						Experiment`Private`cacheLookup[cache, #, Model],
						#
					]& /@ instrument;
					cartridge = First[Lookup[speOptions, ExtractionCartridge]];
					cartridgeModel = If[MatchQ[cartridge, ObjectP[Object]],
						Experiment`Private`cacheLookup[cache, cartridge, Model],
						cartridge
					];
					cartridgeSize = Experiment`Private`cacheLookup[cache, cartridgeModel, MaxVolume];
					valuesToBeFedIntoSPEUnitOp = ReplaceRule[
						Cases[speOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
						(* TODO - add back all the quantitaative loading stuff *)
						{
							AliquotLength -> Flatten[Lookup[speOptions, AliquotLength]],
							PoolLengths -> Flatten[Length /@ Lookup[speOptions, Sample]],
							ExtractionTime -> (Length[Flatten[Lookup[speOptions, Sample]]] * 30 Minute),
							ExtractionTemperature -> Flatten[Lookup[speOptions, ExtractionTemperature]],
							QuantitativeLoadingSampleSolution -> Map[Link[#]&, Flatten[Lookup[speOptions, QuantitativeLoadingResource]]],
							QuantitativeLoadingSampleVolume -> Lookup[speOptions, QuantitativeLoadingSampleVolume],
							QuantitativeLoadingSample -> Lookup[speOptions, QuantitativeLoadingSample],

							(* TODO this is the input sample stuff *)
							Sample -> Lookup[speOptions, Sample],
							SampleLabel -> Lookup[speOptions, SampleLabel],
							Instrument -> (Link[#]& /@ Lookup[speOptions, InstrumentResource]),
							ExtractionCartridge -> Link /@ Lookup[speOptions, ExtractionCartridgeResource],
							ExtractionCartridgeCaps -> Link /@ Lookup[speOptions, ExtractionCartridgeCapResource],
							LoadingSampleVolume -> Lookup[speOptions, LoadingSampleVolume],
							ExtractionCartridgePositions -> Lookup[speOptions, CartridgePlacement],
							ExtractionCartridgePlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {{Null} -> Null}}&,
								{
									Lookup[speOptions, ExtractionCartridgeResource],
									Lookup[speOptions, CartridgePlacement]
								}
							],
							PurgePressure -> If[
								MatchQ[resolvedInstrumentModel, {ObjectReferenceP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]]..}],
								10 PSI,
								0 PSI
							],

							(* buffer *)
							PreFlushingSolution -> Link /@ Lookup[speOptions, PreFlushingResource],
							ConditioningSolution -> Link /@ Lookup[speOptions, ConditioningResource],
							WashingSolution -> Link /@ Lookup[speOptions, WashingResource],
							SecondaryWashingSolution -> Link /@ Lookup[speOptions, SecondaryWashingResource],
							TertiaryWashingSolution -> Link /@ Lookup[speOptions, TertiaryWashingResource],
							ElutingSolution -> Link /@ Lookup[speOptions, ElutingResource],
							PrimingSolution -> Link /@ Lookup[speOptions, PrimingResource],
							(* container placement *)
							PreFlushingSolutionContainerPlacements -> Transpose[{Link /@ Lookup[speOptions, PreFlushingResource], Lookup[speOptions, PreFlushingPlacement]}],
							ConditioningSolutionContainerPlacements -> Transpose[{Link /@ Lookup[speOptions, ConditioningResource], Lookup[speOptions, ConditioningPlacement]}],
							WashingSolutionContainerPlacements -> Transpose[{Link /@ Lookup[speOptions, WashingResource], Lookup[speOptions, WashingPlacement]}],
							SecondaryWashingSolutionContainerPlacements -> Transpose[{Link /@ Lookup[speOptions, SecondaryWashingResource], Lookup[speOptions, SecondaryWashingPlacement]}],
							TertiaryWashingSolutionContainerPlacements -> Transpose[{Link /@ Lookup[speOptions, TertiaryWashingResource], Lookup[speOptions, TertiaryWashingPlacement]}],
							ElutingSolutionContainerPlacements -> Transpose[{Link /@ Lookup[speOptions, ElutingResource], Lookup[speOptions, ElutingPlacement]}],
							PrimingSolutionContainerPlacements -> Transpose[{Link /@ Lookup[speOptions, PrimingResource], Lookup[speOptions, PrimingPlacement]}],
							(* buffer label *)
							PreFlushingSolutionLabel -> Lookup[speOptions, PreFlushingSolutionLabel],
							ConditioningSolutionLabel -> Lookup[speOptions, ConditioningSolutionLabel],
							WashingSolutionLabel -> Lookup[speOptions, WashingSolutionLabel],
							SecondaryWashingSolutionLabel -> Lookup[speOptions, SecondaryWashingSolutionLabel],
							TertiaryWashingSolutionLabel -> Lookup[speOptions, TertiaryWashingSolutionLabel],
							ElutingSolutionLabel -> Lookup[speOptions, ElutingSolutionLabel],
							(* volume *)
							PreFlushingSolutionVolume -> Lookup[speOptions, PreFlushingSolutionVolume],
							ConditioningSolutionVolume -> Lookup[speOptions, ConditioningSolutionVolume],
							WashingSolutionVolume -> Lookup[speOptions, WashingSolutionVolume],
							SecondaryWashingSolutionVolume -> Lookup[speOptions, SecondaryWashingSolutionVolume],
							TertiaryWashingSolutionVolume -> Lookup[speOptions, TertiaryWashingSolutionVolume],
							ElutingSolutionVolume -> Lookup[speOptions, ElutingSolutionVolume],
							(* container out model *)
							PreFlushingSolutionCollectionContainer -> Flatten[Link /@ Lookup[speOptions, PreFlushingContainerOutResource]],
							ConditioningSolutionCollectionContainer -> Flatten[Link /@ Lookup[speOptions, ConditioningContainerOutResource]],
							WashingSolutionCollectionContainer -> Flatten[Link /@ Lookup[speOptions, WashingContainerOutResource]],
							SecondaryWashingSolutionCollectionContainer -> Flatten[Link /@ Lookup[speOptions, SecondaryWashingContainerOutResource]],
							TertiaryWashingSolutionCollectionContainer -> Flatten[Link /@ Lookup[speOptions, TertiaryWashingContainerOutResource]],
							ElutingSolutionCollectionContainer -> Flatten[Link /@ Lookup[speOptions, ElutingContainerOutResource]],
							LoadingSampleFlowthroughContainer -> Flatten[Link /@ Lookup[speOptions, LoadingSampleContainerOutResource]],
							ContainerOut -> Link /@ Flatten[{
								Lookup[speOptions, PreFlushingContainerOutResource],
								Lookup[speOptions, ConditioningContainerOutResource],
								Lookup[speOptions, WashingContainerOutResource],
								Lookup[speOptions, SecondaryWashingContainerOutResource],
								Lookup[speOptions, TertiaryWashingContainerOutResource],
								Lookup[speOptions, ElutingContainerOutResource],
								Lookup[speOptions, LoadingSampleContainerOutResource]
							}],
							(* container out placement *)
							PreFlushingContainerOutPlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {Null} -> Null}&,
								{
									Lookup[speOptions, PreFlushingContainerOutResource],
									Lookup[speOptions, PreFlushingContainerOutPlacement]
								}
							],
							ConditioningContainerOutPlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {Null} -> Null}&,
								{
									Lookup[speOptions, ConditioningContainerOutResource],
									Lookup[speOptions, ConditioningContainerOutPlacement]
								}
							],
							LoadingSampleFlowthroughContainerOutPlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {Null} -> Null}&,
								{
									Lookup[speOptions, LoadingSampleContainerOutResource],
									Lookup[speOptions, LoadingSampleContainerOutPlacement]
								}
							],
							WashingContainerOutPlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {Null} -> Null}&,
								{
									Lookup[speOptions, WashingContainerOutResource],
									Lookup[speOptions, WashingContainerOutPlacement]
								}
							],
							SecondaryWashingContainerOutPlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {Null} -> Null}&,
								{
									Lookup[speOptions, SecondaryWashingContainerOutResource],
									Lookup[speOptions, SecondaryWashingContainerOutPlacement]
								}
							],
							TertiaryWashingContainerOutPlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {Null} -> Null}&,
								{
									Lookup[speOptions, TertiaryWashingContainerOutResource],
									Lookup[speOptions, TertiaryWashingContainerOutPlacement]
								}
							],
							ElutingContainerOutPlacements -> MapThread[
								{Link[#1], Flatten[{#2}] /. {Null} -> Null}&,
								{
									Lookup[speOptions, ElutingContainerOutResource],
									Lookup[speOptions, ElutingContainerOutPlacement]
								}
							],
							(* sample out *)
							ContainerOutWellAssignment -> Lookup[speOptions, ContainerOutWellAssignment],
							PreFlushingSampleOutLabel -> Lookup[speOptions, PreFlushingSampleOutLabel],
							ConditioningSampleOutLabel -> Lookup[speOptions, ConditioningSampleOutLabel],
							WashingSampleOutLabel -> Lookup[speOptions, WashingSampleOutLabel],
							SecondaryWashingSampleOutLabel -> Lookup[speOptions, SecondaryWashingSampleOutLabel],
							TertiaryWashingSampleOutLabel -> Lookup[speOptions, TertiaryWashingSampleOutLabel],
							ElutingSampleOutLabel -> Lookup[speOptions, ElutingSampleOutLabel],
							LoadingSampleFlowthroughSampleOutLabel -> Lookup[speOptions, LoadingSampleFlowthroughSampleOutLabel],
							(* centrifuge stuff *)
							PreFlushingSolutionCentrifugeIntensity -> Lookup[speOptions, PreFlushingSolutionCentrifugeIntensity],
							ConditioningSolutionCentrifugeIntensity -> Lookup[speOptions, ConditioningSolutionCentrifugeIntensity],
							WashingSolutionCentrifugeIntensity -> Lookup[speOptions, WashingSolutionCentrifugeIntensity],
							SecondaryWashingSolutionCentrifugeIntensity -> Lookup[speOptions, SecondaryWashingSolutionCentrifugeIntensity],
							TertiaryWashingSolutionCentrifugeIntensity -> Lookup[speOptions, TertiaryWashingSolutionCentrifugeIntensity],
							ElutingSolutionCentrifugeIntensity -> Lookup[speOptions, ElutingSolutionCentrifugeIntensity],
							LoadingSampleCentrifugeIntensity -> Lookup[speOptions, LoadingSampleCentrifugeIntensity],
							(* time stuff *)
							PreFlushingSolutionDrainTime -> Lookup[speOptions, PreFlushingSolutionDrainTime],
							ConditioningSolutionDrainTime -> Lookup[speOptions, ConditioningSolutionDrainTime],
							WashingSolutionDrainTime -> Lookup[speOptions, WashingSolutionDrainTime],
							SecondaryWashingSolutionDrainTime -> Lookup[speOptions, SecondaryWashingSolutionDrainTime],
							TertiaryWashingSolutionDrainTime -> Lookup[speOptions, TertiaryWashingSolutionDrainTime],
							ElutingSolutionDrainTime -> Lookup[speOptions, ElutingSolutionDrainTime],
							LoadingSampleDrainTime -> Lookup[speOptions, LoadingSampleDrainTime],
							PreFlushingSolutionDrainTimeSingle -> Lookup[speOptions, PreFlushingSolutionDrainTime][[1]],
							ConditioningSolutionDrainTimeSingle -> Lookup[speOptions, ConditioningSolutionDrainTime][[1]],
							WashingSolutionDrainTimeSingle -> Lookup[speOptions, WashingSolutionDrainTime][[1]],
							SecondaryWashingSolutionDrainTimeSingle -> Lookup[speOptions, SecondaryWashingSolutionDrainTime][[1]],
							TertiaryWashingSolutionDrainTimeSingle -> Lookup[speOptions, TertiaryWashingSolutionDrainTime][[1]],
							ElutingSolutionDrainTimeSingle -> Lookup[speOptions, ElutingSolutionDrainTime][[1]],
							LoadingSampleDrainTimeSingle -> Lookup[speOptions, LoadingSampleDrainTime][[1]],
							MaxPreFlushingSolutionDrainTimeSingle -> Lookup[speOptions, MaxPreFlushingSolutionDrainTime][[1]],
							MaxConditioningSolutionDrainTimeSingle -> Lookup[speOptions, MaxConditioningSolutionDrainTime][[1]],
							MaxWashingSolutionDrainTimeSingle -> Lookup[speOptions, MaxWashingSolutionDrainTime][[1]],
							MaxSecondaryWashingSolutionDrainTimeSingle -> Lookup[speOptions, MaxSecondaryWashingSolutionDrainTime][[1]],
							MaxTertiaryWashingSolutionDrainTimeSingle -> Lookup[speOptions, MaxTertiaryWashingSolutionDrainTime][[1]],
							MaxElutingSolutionDrainTimeSingle -> Lookup[speOptions, MaxElutingSolutionDrainTime][[1]],
							MaxLoadingSampleDrainTimeSingle -> Lookup[speOptions, MaxLoadingSampleDrainTime][[1]],
							(* solution incubation temperature *)
							PreFlushingSolutionTemperature -> Sequence @@ Flatten[Lookup[speOptions, PreFlushingSolutionTemperature]],
							ConditioningSolutionTemperature -> Sequence @@ Flatten[Lookup[speOptions, ConditioningSolutionTemperature]],
							WashingSolutionTemperature -> Sequence @@ Flatten[Lookup[speOptions, WashingSolutionTemperature]],
							SecondaryWashingSolutionTemperature -> Sequence @@ Flatten[Lookup[speOptions, SecondaryWashingSolutionTemperature]],
							TertiaryWashingSolutionTemperature -> Sequence @@ Flatten[Lookup[speOptions, TertiaryWashingSolutionTemperature]],
							ElutingSolutionTemperature -> Sequence @@ Flatten[Lookup[speOptions, ElutingSolutionTemperature]],
							LoadingSampleTemperature -> TakeList[Flatten[Lookup[speOptions, LoadingSampleTemperature]], Flatten[Length /@ Lookup[speOptions, Sample]]],
							(* solution incubation temperature time *)
							PreFlushingSolutionTemperatureEquilibrationTime -> Lookup[speOptions, PreFlushingSolutionTemperatureEquilibrationTime],
							ConditioningSolutionTemperatureEquilibrationTime -> Lookup[speOptions, ConditioningSolutionTemperatureEquilibrationTime],
							WashingSolutionTemperatureEquilibrationTime -> Lookup[speOptions, WashingSolutionTemperatureEquilibrationTime],
							SecondaryWashingSolutionTemperatureEquilibrationTime -> Lookup[speOptions, SecondaryWashingSolutionTemperatureEquilibrationTime],
							TertiaryWashingSolutionTemperatureEquilibrationTime -> Lookup[speOptions, TertiaryWashingSolutionTemperatureEquilibrationTime],
							ElutingSolutionTemperatureEquilibrationTime -> Lookup[speOptions, ElutingSolutionTemperatureEquilibrationTime],
							LoadingSampleTemperatureEquilibrationTime -> Lookup[speOptions, LoadingSampleTemperatureEquilibrationTime],
							(* we straighten sample out by the following order *)
							SampleOutLabel -> Flatten[Lookup[speOptions,
								{
									PreFlushingSampleOutLabel,
									ConditioningSampleOutLabel,
									LoadingSampleFlowthroughSampleOutLabel,
									WashingSampleOutLabel,
									SecondaryWashingSampleOutLabel,
									TertiaryWashingSampleOutLabel,
									ElutingSampleOutLabel
								}
							]],
							(* container out labels *)
							PreFlushingCollectionContainerOutLabel -> Lookup[speOptions, PreFlushingCollectionContainerOutLabel],
							ConditioningCollectionContainerOutLabel -> Lookup[speOptions, ConditioningCollectionContainerOutLabel],
							WashingCollectionContainerOutLabel -> Lookup[speOptions, WashingCollectionContainerOutLabel],
							SecondaryWashingCollectionContainerOutLabel -> Lookup[speOptions, SecondaryWashingCollectionContainerOutLabel],
							TertiaryWashingCollectionContainerOutLabel -> Lookup[speOptions, TertiaryWashingCollectionContainerOutLabel],
							ElutingCollectionContainerOutLabel -> Lookup[speOptions, ElutingCollectionContainerOutLabel],
							LoadingSampleFlowthroughCollectionContainerOutLabel -> Lookup[speOptions, LoadingSampleFlowthroughCollectionContainerOutLabel],
							(* we straighten sample out by the following order *)
							ContainerOutLabel -> Flatten[Lookup[speOptions,
								{
									PreFlushingCollectionContainerOutLabel,
									ConditioningCollectionContainerOutLabel,
									LoadingSampleFlowthroughCollectionContainerOutLabel,
									WashingCollectionContainerOutLabel,
									SecondaryWashingCollectionContainerOutLabel,
									TertiaryWashingCollectionContainerOutLabel,
									ElutingCollectionContainerOutLabel
								}
							]],
							(* upload pressure, make sure it's flat *)
							PreFlushingSolutionPressure -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]]..}],
								Lookup[speOptions, PreFlushingSolutionPressure] /. {GreaterP[0 PSI] -> True, EqualP[0 PSI] -> False},
								Lookup[speOptions, PreFlushingSolutionPressure]
							],
							ConditioningSolutionPressure -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]]..}],
								Lookup[speOptions, ConditioningSolutionPressure] /. {GreaterP[0 PSI] -> True, EqualP[0 PSI] -> False},
								Lookup[speOptions, ConditioningSolutionPressure]
							],
							WashingSolutionPressure -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]]..}],
								Lookup[speOptions, WashingSolutionPressure] /. {GreaterP[0 PSI] -> True, EqualP[0 PSI] -> False},
								Lookup[speOptions, WashingSolutionPressure]
							],
							SecondaryWashingSolutionPressure -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]]..}],
								Lookup[speOptions, SecondaryWashingSolutionPressure] /. {GreaterP[0 PSI] -> True, EqualP[0 PSI] -> False},
								Lookup[speOptions, SecondaryWashingSolutionPressure]
							],
							TertiaryWashingSolutionPressure -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]]..}],
								Lookup[speOptions, TertiaryWashingSolutionPressure] /. {GreaterP[0 PSI] -> True, EqualP[0 PSI] -> False},
								Lookup[speOptions, TertiaryWashingSolutionPressure]
							],
							ElutingSolutionPressure -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]]..}],
								Lookup[speOptions, ElutingSolutionPressure] /. {GreaterP[0 PSI] -> True, EqualP[0 PSI] -> False},
								Lookup[speOptions, ElutingSolutionPressure]
							],
							LoadingSamplePressure -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]]..}],
								Lookup[speOptions, LoadingSamplePressure] /. {GreaterP[0 PSI] -> True, EqualP[0 PSI] -> False},
								Lookup[speOptions, LoadingSamplePressure]
							],
							PreFlushingSolutionPressureSingle -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Lookup[speOptions, PreFlushingSolutionPressure][[1]],
								Null
							],
							ConditioningSolutionPressureSingle -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Lookup[speOptions, ConditioningSolutionPressure][[1]],
								Null
							],
							WashingSolutionPressureSingle -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Lookup[speOptions, WashingSolutionPressure][[1]],
								Null
							],
							SecondaryWashingSolutionPressureSingle -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Lookup[speOptions, SecondaryWashingSolutionPressure][[1]],
								Null
							],
							TertiaryWashingSolutionPressureSingle -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Lookup[speOptions, TertiaryWashingSolutionPressure][[1]],
								Null
							],
							ElutingSolutionPressureSingle -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Lookup[speOptions, ElutingSolutionPressure][[1]],
								Null
							],
							LoadingSamplePressureSingle -> If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Lookup[speOptions, LoadingSamplePressure][[1]],
								Null
							],
							(* fake waste container for simulation *)
							WasteContainer -> Map[Link[#]&, Lookup[speOptions, WasteContainerResource]],
							ImageSample -> Lookup[myResolvedOptions, ImageSample],
							MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
							MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
							(* special case for Biotage *)
							WasteContainerRack -> Link[If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Resource[Sample -> Model[Container, Rack, "Biotage Pressure+48 Waste Tub Rack"]],
								Null
							]],
							CartridgeContainerRack -> Link[Switch[{instrumentModel, cartridgeSize},

								{{ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}, 6. Milliliter},
								Resource[Sample -> Model[Container, Rack, "Biotage Pressure+48 6 mL Cartridge Rack"]],

								{{ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}, 3. Milliliter},
								Resource[Sample -> Model[Container, Rack, "Biotage Pressure+48 3 mL Cartridge Rack"]],

								_,
								Null
							]],
							ContainerOutRack -> Link[If[
								MatchQ[instrumentModel, {ObjectP[Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]]..}],
								Resource[Sample -> Model[Container, Rack, "Biotage Pressure+48 15 mL Container Rack"]],
								Null
							]]
							(*								SamplesOutStorageCondition -> Lookup[speOptions, SamplesOutStorageCondition]*)
						}
					];

					(* remove the resources if we're doing robotic because we don't make any ourselves here *)
					valuesToBeFedIntoSPEUnitOpNoResources = valuesToBeFedIntoSPEUnitOp /. {x_Resource :> Lookup[First[x], Sample, Lookup[First[x], Instrument]]};

					SolidPhaseExtraction @@ If[MatchQ[resolvedPreparation, Robotic],
						valuesToBeFedIntoSPEUnitOpNoResources,
						valuesToBeFedIntoSPEUnitOp
					]
				]
			],
			optionsAndResourceByBatch
		];
		(*TODO this is not correcty right now*)
		speUnitOpNoResourcesIfRobotic = If[MatchQ[resolvedPreparation, Robotic],
			(* convert to the sample or instrument objects that go in the resource *)
			speUnitOp /. {x_Resource :> Lookup[First[x], Sample, Lookup[First[x], Instrument]]},
			speUnitOp
		];

		(* upload unit operation *)
		UploadUnitOperation[
			speUnitOpNoResourcesIfRobotic,
			UnitOperationType -> Batched,
			Preparation -> Manual,
			FastTrack -> True,
			Upload -> False
		]
	];

	(* make the LabelSample unit operation; importantly here, we do NOT have resources; we just have models and labels *)
	(* also make rules converting model input samples to labels, and also those same model input samples back to their models *)
	{labelSampleUOFromPreparedModels, oldSampleToLabelRules, oldSampleToModelRules} = If[modelInputQ,
		Module[{resolvedUO, simLabelRules, labelToSampleRules, sampleToModelRules},
			resolvedUO = resolvedPrepUOs[[1, 1]];
			simLabelRules = simulation[[1]][Labels];
			labelToSampleRules = Flatten[Map[
				Function[{label},
					SelectFirst[simLabelRules, MatchQ[label, #[[1]]]&, {}]
				],
				Flatten[{resolvedUO[Label], resolvedUO[ContainerLabel]}]
			]];

			sampleToModelRules = MapThread[
				(#1 /. labelToSampleRules) -> #2 &,
				{
					Join[resolvedUO[Label], resolvedUO[ContainerLabel]],
					Join[resolvedUO[Sample], resolvedUO[Container]]
				}
			];

			{
				resolvedUO,
				Reverse /@ labelToSampleRules,
				sampleToModelRules
			}
		],
		{Null, {}, {}}
	];

	(* update the simulation to _not_ have the labels that we are adding above *)
	updatedSimulation = If[NullQ[simulation],
		Null,
		With[{oldLabelRules = Lookup[First[simulation], Labels], labelsToRemove = Values[oldSampleToLabelRules]},
			Simulation[
				Append[
					First[simulation],
					Labels -> Select[oldLabelRules, Not[MemberQ[labelsToRemove, #[[1]]]]&]
				]
			]
		]
	];


	(* need to generate a filter unit operation blob here for robotic *)
	(* mimicking what is happening in compileSolidPhaseExtraction *)
	{{roboticFilterUnitOperationPackets, runTime}, updatedSimulation} = If[MatchQ[resolvedPreparation, Robotic],
		Module[
			{preFlush, condition, wash, secWash,
				terWash, elute, poolLength, preFlushingSolutionVolume, conditioningSolutionVolume, washingSolutionVolume,
				secondaryWashingSolutionVolume, tertiaryWashingSolutionVolume, elutingSolutionVolume, loadingSampleVolume,
				cartridge, aliquotLength, instrument, preFlushingSolutionCentrifugeIntensity, conditioningSolutionCentrifugeIntensity, washingSolutionCentrifugeIntensity,
				secondaryWashingSolutionCentrifugeIntensity, tertiaryWashingSolutionCentrifugeIntensity, elutingSolutionCentrifugeIntensity, loadingSampleCentrifugeIntensity,
				preFlushingSolutionDrainTime, conditioningSolutionDrainTime, washingSolutionDrainTime, secondaryWashingSolutionDrainTime, tertiaryWashingSolutionDrainTime,
				elutingSolutionDrainTime, loadingSampleDrainTime, preFlushingSolutionCollectionContainer, conditioningSolutionCollectionContainer, loadingSampleFlowthroughContainer,
				washingSolutionCollectionContainer, secondaryWashingSolutionCollectionContainer, tertiaryWashingSolutionCollectionContainer, elutingSolutionCollectionContainer,
				extractionTemperature, indexStepToUse, filterReadyIntensityFlatIndexMatch, filterReadyTimeFlatIndexMatch, filterReadyContainerFlatIndexMatch,
				firstInFilterSamples, restInFilterSamples, firstInFilterIntensity, restInFilterIntensity, firstInFilterTime, restInFilterTime,
				firstInFilterContainer, restInFilterContainer, firstInFilterVolume, restInFilterVolume, filterUnitOp, initPressure, restPressure,
				pooledSamples, nPooled, preFlushingSolutionPressure, conditioningSolutionPressure, loadingSamplePressure, firstInFilterPressure, restInFilterPressure,
				washingSolutionPressure, secondaryWashingSolutionPressure, tertiaryWashingSolutionPressure, elutingSolutionPressure, sampleToFilter, intensityToFilter,
				pressureToFilter, timeToFilter, containerToFilter, volumeToFilter, initSample, restSample, initIntensity, restIntensity, initTime, restTime, initCont, restCont,
				initVol, restVol, filterReadySampleFlat, filterReadyIntensityFlat, filterReadyTimeFlat, filterReadyContainerFlat, filterReadyVolumeFlat,
				filterReadyPressureFlatIndexMatch, filterReadyPressureFlat, preFlushLabel, conditionLabel, pooledSampleLabel,
				washLabel, secondaryWashLabel, tertiaryWashLabel, elutionLabel, labelsToFilter, initLabel, restLabel, sampleRules,
				filterReadyLabelFlat, firstInLabel, restInLabel, filterReadySamplesOutLabelFlat, mergedSampleRules,
				experimentFunction,
				labelSampleUnitOp, preFlushContainerOutLabel, conditionContainerOutLabel, sampleContainerOutLabel, labelContainerContainerRules,
				washContainerOutLabel, secondaryWashContainerOutLabel, tertiaryWashContainerOutLabel, elutionContainerOutLabel,
				containerOutLabelsToFilter, initContainerLabel, restContainerLabel, filterReadyContainerLabelFlat, sampleOutLabelsToFilter,
				filterReadyContainerLabelFlatIndexMatch, firstInContainerLabel, restInContainerLabel, filterReadySamplesOutLabelFlatIndexMatch,
				sampleAndLabelsWithDupes, samplesAndLabels, extractionCartridgeLabel, preFlushSampleOutLabel, labelSampleAmount,
				conditionSampleOutLabel, initSampleOutLabel, restSampleOutLabel, loadingSampleOutLabel, washSampleOutLabel, secondarySampleOutLabel,
				tertiarySampleOutLabel, elutionSampleOutLabel, firstInSamplesOutLabel, restInSamplesOutLabel},

			(* retreive all information that we need from the our packets *)
			{
				(*1*)preFlush,
				(*2*)condition,
				(*3*)pooledSamples,
				(*4*)wash,
				(*5*)secWash,
				(*6*)terWash,
				(*7*)elute,
				(*8*)poolLength,
				(*9*)preFlushingSolutionVolume,
				(*10*)conditioningSolutionVolume,
				(*11*)washingSolutionVolume,
				(*12*)secondaryWashingSolutionVolume,
				(*13*)tertiaryWashingSolutionVolume,
				(*14*)elutingSolutionVolume,
				(*15*)loadingSampleVolume,
				(*16*)cartridge,
				(*17*)aliquotLength,
				(*18*)instrument,
				(*19*)preFlushingSolutionCentrifugeIntensity,
				(*20*)conditioningSolutionCentrifugeIntensity,
				(*21*)washingSolutionCentrifugeIntensity,
				(*22*)secondaryWashingSolutionCentrifugeIntensity,
				(*23*)tertiaryWashingSolutionCentrifugeIntensity,
				(*24*)elutingSolutionCentrifugeIntensity,
				(*25*)loadingSampleCentrifugeIntensity,
				(*26*)preFlushingSolutionDrainTime,
				(*27*)conditioningSolutionDrainTime,
				(*28*)washingSolutionDrainTime,
				(*29*)secondaryWashingSolutionDrainTime,
				(*30*)tertiaryWashingSolutionDrainTime,
				(*31*)elutingSolutionDrainTime,
				(*32*)loadingSampleDrainTime,
				(*33*)preFlushingSolutionCollectionContainer,
				(*34*)conditioningSolutionCollectionContainer,
				(*35*)loadingSampleFlowthroughContainer,
				(*36*)washingSolutionCollectionContainer,
				(*37*)secondaryWashingSolutionCollectionContainer,
				(*38*)tertiaryWashingSolutionCollectionContainer,
				(*39*)elutingSolutionCollectionContainer,
				(*40*)extractionTemperature,
				(*41*)preFlushingSolutionPressure,
				(*42*)conditioningSolutionPressure,
				(*43*)loadingSamplePressure,
				(*44*)washingSolutionPressure,
				(*45*)secondaryWashingSolutionPressure,
				(*46*)tertiaryWashingSolutionPressure,
				(*47*)elutingSolutionPressure,
				(*48*)preFlushLabel,
				(*49*)conditionLabel,
				(*50*)pooledSampleLabel,
				(*51*)washLabel,
				(*52*)secondaryWashLabel,
				(*53*)tertiaryWashLabel,
				(*54*)elutionLabel,
				(*55*)preFlushContainerOutLabel,
				(*56*)conditionContainerOutLabel,
				(*57*)sampleContainerOutLabel,
				(*58*)washContainerOutLabel,
				(*59*)secondaryWashContainerOutLabel,
				(*60*)tertiaryWashContainerOutLabel,
				(*61*)elutionContainerOutLabel,
				(*62*)extractionCartridgeLabel,
				(*63*)preFlushSampleOutLabel,
				(*64*)conditionSampleOutLabel,
				(*65*)loadingSampleOutLabel,
				(*66*)washSampleOutLabel,
				(*67*)secondarySampleOutLabel,
				(*68*)tertiarySampleOutLabel,
				(*69*)elutionSampleOutLabel
			} = Map[
				Lookup[First[unitOperationPackets], #]&,
				{
					(*1*)Replace[PreFlushingSolutionLink],
					(*2*)Replace[ConditioningSolutionLink],
					(*3*)Replace[SampleExpression],
					(*4*)Replace[WashingSolutionLink],
					(*5*)Replace[SecondaryWashingSolutionLink],
					(*6*)Replace[TertiaryWashingSolutionLink],
					(*7*)Replace[ElutingSolutionLink],
					(*8*)Replace[PoolLengths],
					(*9*)Replace[PreFlushingSolutionVolume],
					(*10*)Replace[ConditioningSolutionVolume],
					(*11*)Replace[WashingSolutionVolume],
					(*12*)Replace[SecondaryWashingSolutionVolume],
					(*13*)Replace[TertiaryWashingSolutionVolume],
					(*14*)Replace[ElutingSolutionVolume],
					(*15*)Replace[LoadingSampleVolume],
					(*16*)Replace[ExtractionCartridge],
					(*17*)Replace[AliquotLength],
					(*18*)Replace[Instrument],
					(*19*)Replace[PreFlushingSolutionCentrifugeIntensity],
					(*20*)Replace[ConditioningSolutionCentrifugeIntensity],
					(*21*)Replace[WashingSolutionCentrifugeIntensity],
					(*22*)Replace[SecondaryWashingSolutionCentrifugeIntensity],
					(*23*)Replace[TertiaryWashingSolutionCentrifugeIntensity],
					(*24*)Replace[ElutingSolutionCentrifugeIntensity],
					(*25*)Replace[LoadingSampleCentrifugeIntensity],
					(*26*)Replace[PreFlushingSolutionDrainTime],
					(*27*)Replace[ConditioningSolutionDrainTime],
					(*28*)Replace[WashingSolutionDrainTime],
					(*29*)Replace[SecondaryWashingSolutionDrainTime],
					(*30*)Replace[TertiaryWashingSolutionDrainTime],
					(*31*)Replace[ElutingSolutionDrainTime],
					(*32*)Replace[LoadingSampleDrainTime],
					(*33*)Replace[PreFlushingSolutionCollectionContainerLink],
					(*34*)Replace[ConditioningSolutionCollectionContainerLink],
					(*35*)Replace[LoadingSampleFlowthroughContainerLink],
					(*36*)Replace[WashingSolutionCollectionContainerLink],
					(*37*)Replace[SecondaryWashingSolutionCollectionContainerLink],
					(*38*)Replace[TertiaryWashingSolutionCollectionContainerLink],
					(*39*)Replace[ElutingSolutionCollectionContainerLink],
					(*40*)Replace[ExtractionTemperatureReal],
					(*41*)Replace[PreFlushingSolutionPressureReal],
					(*42*)Replace[ConditioningSolutionPressureReal],
					(*43*)Replace[LoadingSamplePressureReal],
					(*44*)Replace[WashingSolutionPressureReal],
					(*45*)Replace[SecondaryWashingSolutionPressureReal],
					(*46*)Replace[TertiaryWashingSolutionPressureReal],
					(*47*)Replace[ElutingSolutionPressureReal],
					(*48*)Replace[PreFlushingSolutionLabel],
					(*49*)Replace[ConditioningSolutionLabel],
					(*50*)Replace[SampleLabel],
					(*51*)Replace[WashingSolutionLabel],
					(*52*)Replace[SecondaryWashingSolutionLabel],
					(*53*)Replace[TertiaryWashingSolutionLabel],
					(*54*)Replace[ElutingSolutionLabel],
					(*55*)Replace[PreFlushingCollectionContainerOutLabel],
					(*56*)Replace[ConditioningCollectionContainerOutLabel],
					(*57*)Replace[LoadingSampleFlowthroughCollectionContainerOutLabel],
					(*58*)Replace[WashingCollectionContainerOutLabel],
					(*59*)Replace[SecondaryWashingCollectionContainerOutLabel],
					(*60*)Replace[TertiaryWashingCollectionContainerOutLabel],
					(*61*)Replace[ElutingCollectionContainerOutLabel],
					(*62*)Replace[ExtractionCartridgeLabel],
					(*63*)Replace[PreFlushingSampleOutLabel],
					(*64*)Replace[ConditioningSampleOutLabel],
					(*65*)Replace[LoadingSampleFlowthroughSampleOutLabel],
					(*66*)Replace[WashingSampleOutLabel],
					(*67*)Replace[SecondaryWashingSampleOutLabel],
					(*68*)Replace[TertiaryWashingSampleOutLabel],
					(*69*)Replace[ElutingSampleOutLabel]
				}
			];

			nPooled = Length[pooledSamples];

			(* which step that we are using *)
			indexStepToUse = Map[!MatchQ[#, {(Null | Automatic)..}]&, {
				preFlush,
				condition,
				pooledSamples,
				wash,
				secWash,
				terWash,
				elute
			}];

			{
				sampleToFilter,
				intensityToFilter,
				pressureToFilter,
				timeToFilter,
				containerToFilter,
				volumeToFilter,
				labelsToFilter,
				containerOutLabelsToFilter,
				sampleOutLabelsToFilter
			} = Map[
				PickList[#, indexStepToUse]&,
				{
					{
						preFlush,
						condition,
						(*have to use pool here to index match*)
						pooledSamples,
						wash,
						secWash,
						terWash,
						elute
					},
					{
						preFlushingSolutionCentrifugeIntensity,
						conditioningSolutionCentrifugeIntensity,
						loadingSampleCentrifugeIntensity,
						washingSolutionCentrifugeIntensity,
						secondaryWashingSolutionCentrifugeIntensity,
						tertiaryWashingSolutionCentrifugeIntensity,
						elutingSolutionCentrifugeIntensity
					},
					{
						preFlushingSolutionPressure,
						conditioningSolutionPressure,
						loadingSamplePressure,
						washingSolutionPressure,
						secondaryWashingSolutionPressure,
						tertiaryWashingSolutionPressure,
						elutingSolutionPressure
					},
					{
						preFlushingSolutionDrainTime,
						conditioningSolutionDrainTime,
						loadingSampleDrainTime,
						washingSolutionDrainTime,
						secondaryWashingSolutionDrainTime,
						tertiaryWashingSolutionDrainTime,
						elutingSolutionDrainTime
					},
					{
						preFlushingSolutionCollectionContainer,
						conditioningSolutionCollectionContainer,
						loadingSampleFlowthroughContainer,
						washingSolutionCollectionContainer,
						secondaryWashingSolutionCollectionContainer,
						tertiaryWashingSolutionCollectionContainer,
						elutingSolutionCollectionContainer
					},
					{
						preFlushingSolutionVolume,
						conditioningSolutionVolume,
						loadingSampleVolume,
						washingSolutionVolume,
						secondaryWashingSolutionVolume,
						tertiaryWashingSolutionVolume,
						elutingSolutionVolume
					},
					{
						preFlushLabel,
						conditionLabel,
						pooledSampleLabel,
						washLabel,
						secondaryWashLabel,
						tertiaryWashLabel,
						elutionLabel
					},
					{
						preFlushContainerOutLabel,
						conditionContainerOutLabel,
						sampleContainerOutLabel,
						washContainerOutLabel,
						secondaryWashContainerOutLabel,
						tertiaryWashContainerOutLabel,
						elutionContainerOutLabel
					},
					{
						preFlushSampleOutLabel,
						conditionSampleOutLabel,
						loadingSampleOutLabel,
						washSampleOutLabel,
						secondarySampleOutLabel,
						tertiarySampleOutLabel,
						elutionSampleOutLabel
					}
				}
			];

			{
				{initSample, restSample},
				{initIntensity, restIntensity},
				{initPressure, restPressure},
				{initTime, restTime},
				{initCont, restCont},
				{initVol, restVol},
				{initLabel, restLabel},
				{initContainerLabel, restContainerLabel},
				{initSampleOutLabel, restSampleOutLabel}
			} = Map[
				TakeDrop[#, 1]&,
				{
					sampleToFilter,
					intensityToFilter,
					pressureToFilter,
					timeToFilter,
					containerToFilter,
					volumeToFilter,
					labelsToFilter,
					containerOutLabelsToFilter,
					sampleOutLabelsToFilter
				}
			];

			(* since sample can still be pooled here, we have to make sure that the position is indexmatch to each flat sample *)
			filterReadySampleFlat = Flatten[{initSample, restSample}, 1];
			filterReadyIntensityFlat = Flatten[{initIntensity, restIntensity}, 1];
			filterReadyPressureFlat = Flatten[{initPressure, restPressure}, 1];
			filterReadyTimeFlat = Flatten[{initTime, restTime}, 1];
			filterReadyContainerFlat = Flatten[{initCont, restCont}, 1];
			filterReadyVolumeFlat = Flatten[{initVol, restVol}, 1];
			filterReadyLabelFlat = Flatten[{initLabel, restLabel}, 1];
			filterReadyContainerLabelFlat = Flatten[{initContainerLabel, restContainerLabel}, 1];
			filterReadySamplesOutLabelFlat = Flatten[{initSampleOutLabel, restSampleOutLabel}, 1];

			(* a mini function to flat all the pool options *)
			speFlatWashToIndexMatchSample[options_] := Module[
				{},
				MapThread[
					(
						Which[
							MatchQ[#1, ObjectP[]],
							#2,

							Length[#1] >= 1,
							ConstantArray[#2, Length[#1]]
						]
					)&,
					{
						Flatten[filterReadySampleFlat, 1],
						Flatten[options]
					}
				]
			];

			(* we have to make sure that the options that was not index match earlier, now index match to each sample *)
			filterReadyIntensityFlatIndexMatch = Partition[speFlatWashToIndexMatchSample[Flatten[filterReadyIntensityFlat]], nPooled];
			filterReadyPressureFlatIndexMatch = Partition[speFlatWashToIndexMatchSample[Flatten[filterReadyPressureFlat]], nPooled];
			filterReadyTimeFlatIndexMatch = Partition[speFlatWashToIndexMatchSample[Flatten[filterReadyTimeFlat]], nPooled];
			filterReadyContainerFlatIndexMatch = Partition[speFlatWashToIndexMatchSample[Flatten[filterReadyContainerFlat]], nPooled];
			filterReadyContainerLabelFlatIndexMatch = Partition[speFlatWashToIndexMatchSample[Flatten[filterReadyContainerLabelFlat]], nPooled];
			filterReadySamplesOutLabelFlatIndexMatch = Partition[speFlatWashToIndexMatchSample[Flatten[filterReadySamplesOutLabelFlat]], nPooled];

			(* now that we can be sure everything is flat, we can next pick the first thing and leave the rest as wash *)

			(* make sure that sample that go to each well has a flat sample at the beginning*)
			speFilterSeparateInitAndRest[myFilterOptions_] := Module[
				{eachWellPosition, first, rest, allFirst, allRest},
				(* for each well, we have to flat what will go in *)
				eachWellPosition = Map[Flatten[#]&, Transpose[myFilterOptions]];
				(* then we will loop across each well, and takedrop 1 *)
				(* allocate empty list, so that we can use it to store across multiple wells *)
				allFirst = {}; allRest = {};
				Map[
					(
						{first, rest} = TakeDrop[#, 1];
						(* we append across well *)
						allFirst = Append[allFirst, first];
						allRest = Append[allRest, rest];
					)&, eachWellPosition
				];
				(* return the re-arrange result *)
				{Flatten[allFirst], allRest}
			];

			{
				{firstInFilterSamples, restInFilterSamples},
				{firstInFilterIntensity, restInFilterIntensity},
				{firstInFilterPressure, restInFilterPressure},
				{firstInFilterTime, restInFilterTime},
				{firstInFilterContainer, restInFilterContainer},
				{firstInFilterVolume, restInFilterVolume},
				{firstInLabel, restInLabel},
				{firstInContainerLabel, restInContainerLabel},
				{firstInSamplesOutLabel, restInSamplesOutLabel}
			} = Map[
				speFilterSeparateInitAndRest[#]&,
				{
					filterReadySampleFlat,
					filterReadyIntensityFlatIndexMatch,
					filterReadyPressureFlatIndexMatch,
					filterReadyTimeFlatIndexMatch,
					filterReadyContainerFlatIndexMatch,
					filterReadyVolumeFlat,
					filterReadyLabelFlat,
					filterReadyContainerLabelFlatIndexMatch,
					filterReadySamplesOutLabelFlatIndexMatch
				}
			];

			(* get all the samples/volumes we need as inputs *)
			sampleRules = MapThread[
				{Download[#1, Object], #2} -> #3&,
				{Flatten[filterReadySampleFlat], Flatten[filterReadyLabelFlat], Flatten[filterReadyVolumeFlat]}
			];
			mergedSampleRules = Merge[
				sampleRules,
				Total
			];

			(* get the preferred container for each combination of samples *)
			labelContainerContainerRules = KeyValueMap[
				If[MatchQ[#1[[1]], ObjectP[Model[Sample]]],
					#1 -> PreferredContainer[#2],
					#1 -> cacheLookup[cache, First[#1], Container]
				]&,
				mergedSampleRules
			];

			(* get the samples and the like we need to DeleteDuplicates on before sending into LabelSample *)
			sampleAndLabelsWithDupes = MapThread[
				{
					#1,
					Lookup[mergedSampleRules, Key[{#1, #2}], #3],
					#2,
					Lookup[labelContainerContainerRules, Key[{#1, #2}], PreferredContainer[#3]],
					"Container for " <> ToString[#2]
				}&,
				{Download[Flatten[filterReadySampleFlat], Object], Flatten[filterReadyLabelFlat], Flatten[filterReadyVolumeFlat]}
			];
			samplesAndLabels = DeleteDuplicates[sampleAndLabelsWithDupes];

			(* for the Amount key, only give a value if we're dealing with a model; if we're dealing with a sample, then set this to Automatic because it messes with downstream stuff *)
			labelSampleAmount = MapThread[
				If[MatchQ[#1, ObjectP[Model]],
					#2,
					Automatic
				]&,
				{samplesAndLabels[[All, 1]], samplesAndLabels[[All, 2]]}
			];

			(* make LabelSample unit operation for the Samples such that the input is not a model here like it could be if we didn't do this *)
			labelSampleUnitOp = LabelSample[
				Sample -> samplesAndLabels[[All, 1]],
				Amount -> labelSampleAmount,
				Label -> samplesAndLabels[[All, 3]],
				Container -> samplesAndLabels[[All, 4]],
				ContainerLabel -> samplesAndLabels[[All, 5]]
			] /. oldSampleToLabelRules;

			(* get the filter unit op options *)
			filterUnitOp = Filter[
				Sample -> Flatten[firstInLabel],
				Instrument -> instrument,
				Filter -> cartridge,
				FilterLabel -> extractionCartridgeLabel,
				Intensity -> First[firstInFilterIntensity],
				Pressure -> First[firstInFilterPressure],
				Time -> First[firstInFilterTime],
				Volume -> Flatten[firstInFilterVolume],
				CollectionContainerLabel -> (If[NullQ[#], Automatic, StringJoin["Collection container for " <> #]]& /@ Flatten[firstInContainerLabel]), (* TODO change this back once I get CollectionContianer/FiltrateContainerOut/WashFlowThroughContainer to not go into CollectionContainer at every step *)
				FiltrateContainerLabel -> (Flatten[firstInContainerLabel] /. Null -> Automatic),
				FiltrateContainerOut -> (Flatten[firstInFilterContainer] /. Null -> Automatic),
				CollectionContainer -> (Flatten[firstInFilterContainer] /. Null -> Automatic),
				FiltrateLabel -> (Flatten[firstInSamplesOutLabel] /. Null -> Automatic),
				RetentateWashBuffer -> Map[Flatten[#]&, restInLabel]/.{}->Null,
				RetentateWashCentrifugeIntensity -> Map[Flatten[#]&, restInFilterIntensity]/.{}->Null,
				RetentateWashPressure -> Map[Flatten[#]&, restInFilterPressure]/.{}->Null,
				RetentateWashDrainTime -> Map[Flatten[#]&, restInFilterTime]/.{}->Null,
				RetentateWashVolume -> Map[Flatten[#]&, restInFilterVolume]/.{}->Null,
				WashFlowThroughContainer -> ((Map[Flatten[#]&, restInFilterContainer]) /.({}|Null) -> Automatic),
				WashFlowThroughContainerLabel -> (Map[Flatten[#]&, restInContainerLabel] /. Null :> CreateUniqueLabel["Wash Flow Through Container"])/.{}->Null,
				WashFlowThroughLabel -> (Map[Flatten[#]&, restInSamplesOutLabel] /. Null :> CreateUniqueLabel["Wash Flow Through Sample"])/.{}->Null,
				CollectRetentate -> False,
				Preparation -> Robotic,
				ImageSample -> False,
				MeasureWeight -> False,
				MeasureVolume -> False
			] /. oldSampleToLabelRules;

			experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell, ExperimentRoboticSamplePreparation];

			(* --- get the unit operation packets for the UOs made above; need to replicate what ExperimentRoboticCellPreparation does if that is what is happening (otherwise just do nothing) ---*)

			(* make unit operation packets for the UOs we just made here *)
			(* note that we do have two separate LabelSample UOs; the first one refers specifically to if there were labeled input models *)
			experimentFunction[
				{If[NullQ[labelSampleUOFromPreparedModels], Nothing, labelSampleUOFromPreparedModels], labelSampleUnitOp, filterUnitOp},
				UnitOperationPackets -> True,
				Output -> {Result, Simulation},
				FastTrack -> Lookup[myResolvedOptions, FastTrack],
				Name -> Lookup[myResolvedOptions, Name],
				ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol],
				Simulation -> updatedSimulation,
				Upload -> False,
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False,
				CoverAtEnd -> False,
				Priority -> Lookup[myResolvedOptions, Priority],
				StartDate -> Lookup[myResolvedOptions, StartDate],
				HoldOrder -> Lookup[myResolvedOptions, HoldOrder],
				QueuePosition -> Lookup[myResolvedOptions, QueuePosition]
			]

		],
		{{{},(Length[myPooledSamples]*20Second)}, updatedSimulation}
	];

	(* make our final SPE unit operation packets *)
	finalSPEUnitOperationPackets = ToList[If[MatchQ[resolvedPreparation, Robotic],
		Join[
			First[unitOperationPackets] /. oldSampleToModelRules,
			<|
				Replace[RoboticUnitOperations] -> Link[Lookup[roboticFilterUnitOperationPackets, Object]]
			|>
		],
		unitOperationPackets
	]];

	(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
	updatedSimulation=updateLabelFieldReferences[updatedSimulation,RoboticUnitOperations];

	(* finalize object protocol *)
	protocolPacket = Association[
		Type -> Object[Protocol, SolidPhaseExtraction],
		Object -> CreateID[Object[Protocol, SolidPhaseExtraction]],
		If[MatchQ[resolvedPreparation, Manual],
			Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ Lookup[finalSPEUnitOperationPackets, Object],
			Nothing
		],
		Replace[SPEBatchID] -> Lookup[myResolvedOptions, SPEBatchID],
		Replace[Instruments] -> Map[Link[#]&, Lookup[orderedResource, InstrumentResource]],
		Replace[ExtractionTime] -> Total[Map[#[Time]&, DeleteDuplicates[Lookup[orderedResource, InstrumentResource]]]],
		(* special case for GX217 *)
		Replace[PurgePressures] -> Map[
			If[MatchQ[#, ({ObjectReferenceP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]]..} | ObjectReferenceP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]])],
				10 PSI,
				0 PSI
			]&, resolvedInstrumentModel
		],
		Replace[ExtractionStrategy] -> Lookup[myResolvedOptions, ExtractionStrategy],
		Replace[ExtractionMode] -> Lookup[myResolvedOptions, ExtractionMode],
		Replace[ExtractionSorbent] -> Lookup[myResolvedOptions, ExtractionSorbent],
		Replace[ExtractionMethod] -> Lookup[myResolvedOptions, ExtractionMethod],
		Replace[ExtractionTemperature] -> Lookup[myResolvedOptions, ExtractionTemperature],
		(* sample in *)
		(* this is for pooled samples *)
		Replace[SampleExpression] -> Lookup[orderedResource, Sample],
		Replace[SampleLabel] -> Lookup[myResolvedOptions, SampleLabel],
		Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
		Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
		(* aliquot details *)
		Replace[AliquotContainer] -> Map[Link[#]&, destinationContainerResource],
		Replace[AliquotContainerLabel] -> destinationContainerLabel,
		Replace[AliquotSampleLabel] -> aliquotSampleLabel,
		Replace[AliquotWellDestination] -> destinationWell,
		Replace[AliquotVolume] -> destinationVolume,
		Replace[AliquotLength] -> Flatten[aliquotLength],
		Replace[PoolLengths] -> poolLengths,
		(* cartridge related fields *)
		Replace[ExtractionCartridge] -> Map[Link[#]&, Lookup[orderedResource, ExtractionCartridgeResource]],
		Replace[ExtractionCartridgeCaps] -> Map[Link[#]&, extractionCartridgeCapResources],
		Replace[ExtractionCartridgeStorageCondition] -> Lookup[myResolvedOptions, ExtractionCartridgeStorageCondition],
		(* dealing with solutions *)
		Replace[PreFlushingSolution] -> Map[Link[#]&, Lookup[orderedResource, PreFlushingResource]];
		Replace[PreFlushingSolutionVolume] -> Lookup[myResolvedOptions, PreFlushingSolutionVolume],
		Replace[PreFlushingSolutionDispenseRate] -> Lookup[myResolvedOptions, PreFlushingSolutionDispenseRate],
		Replace[PreFlushingSolutionDrainTime] -> Lookup[myResolvedOptions, PreFlushingSolutionDrainTime],
		Replace[PreFlushingSolutionUntilDrained] -> Lookup[myResolvedOptions, PreFlushingSolutionUntilDrained],
		Replace[MaxPreFlushingSolutionDrainTime] -> Lookup[myResolvedOptions, MaxPreFlushingSolutionDrainTime],

		Replace[ConditioningSolution] -> Map[Link[#]&, Lookup[orderedResource, ConditioningResource]];
		Replace[ConditioningSolutionVolume] -> Lookup[myResolvedOptions, ConditioningSolutionVolume],
		Replace[ConditioningSolutionDispenseRate] -> Lookup[myResolvedOptions, ConditioningSolutionDispenseRate],
		Replace[ConditioningSolutionDrainTime] -> Lookup[myResolvedOptions, ConditioningSolutionDrainTime],
		Replace[ConditioningSolutionUntilDrained] -> Lookup[myResolvedOptions, ConditioningSolutionUntilDrained],
		Replace[MaxConditioningSolutionDrainTime] -> Lookup[myResolvedOptions, MaxConditioningSolutionDrainTime],

		Replace[WashingSolution] -> Map[Link[#]&, Lookup[orderedResource, WashingResource]];
		Replace[WashingSolutionVolume] -> Lookup[myResolvedOptions, WashingSolutionVolume],
		Replace[WashingSolutionDispenseRate] -> Lookup[myResolvedOptions, WashingSolutionDispenseRate],
		Replace[WashingSolutionDrainTime] -> Lookup[myResolvedOptions, WashingSolutionDrainTime],
		Replace[WashingSolutionUntilDrained] -> Lookup[myResolvedOptions, WashingSolutionUntilDrained],
		Replace[MaxWashingSolutionDrainTime] -> Lookup[myResolvedOptions, MaxWashingSolutionDrainTime],

		Replace[SecondaryWashingSolution] -> Map[Link[#]&, Lookup[orderedResource, SecondaryWashingResource]];
		Replace[SecondaryWashingSolutionVolume] -> Lookup[myResolvedOptions, SecondaryWashingSolutionVolume],
		Replace[SecondaryWashingSolutionDispenseRate] -> Lookup[myResolvedOptions, SecondaryWashingSolutionDispenseRate],
		Replace[SecondaryWashingSolutionDrainTime] -> Lookup[myResolvedOptions, SecondaryWashingSolutionDrainTime],
		Replace[SecondaryWashingSolutionUntilDrained] -> Lookup[myResolvedOptions, SecondaryWashingSolutionUntilDrained],
		Replace[MaxSecondaryWashingSolutionDrainTime] -> Lookup[myResolvedOptions, MaxSecondaryWashingSolutionDrainTime],

		Replace[TertiaryWashingSolution] -> Map[Link[#]&, Lookup[orderedResource, TertiaryWashingResource]];
		Replace[TertiaryWashingSolutionVolume] -> Lookup[myResolvedOptions, TertiaryWashingSolutionVolume],
		Replace[TertiaryWashingSolutionDispenseRate] -> Lookup[myResolvedOptions, TertiaryWashingSolutionDispenseRate],
		Replace[TertiaryWashingSolutionDrainTime] -> Lookup[myResolvedOptions, TertiaryWashingSolutionDrainTime],
		Replace[TertiaryWashingSolutionUntilDrained] -> Lookup[myResolvedOptions, TertiaryWashingSolutionUntilDrained],
		Replace[MaxTertiaryWashingSolutionDrainTime] -> Lookup[myResolvedOptions, MaxTertiaryWashingSolutionDrainTime],

		Replace[ElutingSolution] -> Map[Link[#]&, Lookup[orderedResource, ElutingResource]];
		Replace[ElutingSolutionVolume] -> Lookup[myResolvedOptions, ElutingSolutionVolume],
		Replace[ElutingSolutionDispenseRate] -> Lookup[myResolvedOptions, ElutingSolutionDispenseRate],
		Replace[ElutingSolutionDrainTime] -> Lookup[myResolvedOptions, ElutingSolutionDrainTime],
		Replace[ElutingSolutionUntilDrained] -> Lookup[myResolvedOptions, ElutingSolutionUntilDrained],
		Replace[MaxElutingSolutionDrainTime] -> Lookup[myResolvedOptions, MaxElutingSolutionDrainTime],

		(* solution incubation temperature *)
		Replace[PreFlushingSolutionTemperature] -> Lookup[myResolvedOptions, PreFlushingSolutionTemperature],
		Replace[ConditioningSolutionTemperature] -> Lookup[myResolvedOptions, ConditioningSolutionTemperature],
		Replace[WashingSolutionTemperature] -> Lookup[myResolvedOptions, WashingSolutionTemperature],
		Replace[SecondaryWashingSolutionTemperature] -> Lookup[myResolvedOptions, SecondaryWashingSolutionTemperature],
		Replace[TertiaryWashingSolutionTemperature] -> Lookup[myResolvedOptions, TertiaryWashingSolutionTemperature],
		Replace[ElutingSolutionTemperature] -> Lookup[myResolvedOptions, ElutingSolutionTemperature],
		Replace[LoadingSampleTemperature] -> Lookup[myResolvedOptions, LoadingSampleTemperature],
		(* solution incubation temperature time *)
		Replace[PreFlushingSolutionTemperatureEquilibrationTime] -> Lookup[myResolvedOptions, PreFlushingSolutionTemperatureEquilibrationTime],
		Replace[ConditioningSolutionTemperatureEquilibrationTime] -> Lookup[myResolvedOptions, ConditioningSolutionTemperatureEquilibrationTime],
		Replace[WashingSolutionTemperatureEquilibrationTime] -> Lookup[myResolvedOptions, WashingSolutionTemperatureEquilibrationTime],
		Replace[SecondaryWashingSolutionTemperatureEquilibrationTime] -> Lookup[myResolvedOptions, SecondaryWashingSolutionTemperatureEquilibrationTime],
		Replace[TertiaryWashingSolutionTemperatureEquilibrationTime] -> Lookup[myResolvedOptions, TertiaryWashingSolutionTemperatureEquilibrationTime],
		Replace[ElutingSolutionTemperatureEquilibrationTime] -> Lookup[myResolvedOptions, ElutingSolutionTemperatureEquilibrationTime],
		Replace[LoadingSampleTemperatureEquilibrationTime] -> Lookup[myResolvedOptions, LoadingSampleTemperatureEquilibrationTime],

		Replace[PrimingSolution] -> Map[Link[#]&, Lookup[orderedResource, PrimingResource]];

		(* solution in labeling*)
		Replace[PreFlushingSolutionLabel] -> Lookup[myResolvedOptions, PreFlushingSolutionLabel],
		Replace[ConditioningSolutionLabel] -> Lookup[myResolvedOptions, ConditioningSolutionLabel],
		Replace[WashingSolutionLabel] -> Lookup[myResolvedOptions, WashingSolutionLabel],
		Replace[SecondaryWashingSolutionLabel] -> Lookup[myResolvedOptions, SecondaryWashingSolutionLabel],
		Replace[TertiaryWashingSolutionLabel] -> Lookup[myResolvedOptions, TertiaryWashingSolutionLabel],
		Replace[ElutingSolutionLabel] -> Lookup[myResolvedOptions, ElutingSolutionLabel],

		(* GX271 placement *)
		(* solution container placement *)
		Replace[PreFlushingSolutionContainerPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {PreFlushingResource, PreFlushingPlacement}]]
		],
		Replace[ConditioningSolutionContainerPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {ConditioningResource, ConditioningPlacement}]]
		],
		Replace[WashingSolutionContainerPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {WashingResource, WashingPlacement}]]
		],
		Replace[SecondaryWashingSolutionContainerPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {SecondaryWashingResource, SecondaryWashingPlacement}]]
		],
		Replace[TertiaryWashingSolutionContainerPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {TertiaryWashingResource, TertiaryWashingPlacement}]]
		],
		Replace[ElutingSolutionContainerPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {ElutingResource, ElutingPlacement}]]
		],
		Replace[PrimingSolutionContainerPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {PrimingResource, PrimingPlacement}]]
		],
		Replace[ExtractionCartridgePlacements] -> MapThread[
			{Link[#1], #2}&,
			{Lookup[orderedResource, ExtractionCartridgeResource], Lookup[myResolvedOptions, CartridgePlacement]}
		],
		Replace[PreFlushingContainerOutPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {PreFlushingContainerOutResource, PreFlushingContainerOutPlacement}]]
		],
		Replace[ConditioningContainerOutPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {ConditioningContainerOutResource, ConditioningContainerOutPlacement}]]
		],
		Replace[WashingContainerOutPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {WashingContainerOutResource, WashingContainerOutPlacement}]]
		],
		Replace[SecondaryWashingContainerOutPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {SecondaryWashingContainerOutResource, SecondaryWashingContainerOutPlacement}]]
		],
		Replace[TertiaryWashingContainerOutPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {TertiaryWashingContainerOutResource, TertiaryWashingContainerOutPlacement}]]
		],
		Replace[ElutingContainerOutPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {ElutingContainerOutResource, ElutingContainerOutPlacement}]]
		],
		Replace[LoadingSampleFlowthroughContainerOutPlacements] -> Map[
			{Link[#[[1]]], #[[2]]}&,
			Transpose[Lookup[orderedResource, {LoadingSampleContainerOutResource, LoadingSampleContainerOutPlacement}]]
		],
		(* centrifuing stuff *)
		Replace[PreFlushingSolutionCentrifugeIntensity] -> Lookup[myResolvedOptions, PreFlushingSolutionCentrifugeIntensity],
		Replace[ConditioningSolutionCentrifugeIntensity] -> Lookup[myResolvedOptions, ConditioningSolutionCentrifugeIntensity],
		Replace[WashingSolutionCentrifugeIntensity] -> Lookup[myResolvedOptions, WashingSolutionCentrifugeIntensity],
		Replace[SecondaryWashingSolutionCentrifugeIntensity] -> Lookup[myResolvedOptions, SecondaryWashingSolutionCentrifugeIntensity],
		Replace[TertiaryWashingSolutionCentrifugeIntensity] -> Lookup[myResolvedOptions, TertiaryWashingSolutionCentrifugeIntensity],
		Replace[ElutingSolutionCentrifugeIntensity] -> Lookup[myResolvedOptions, ElutingSolutionCentrifugeIntensity],
		Replace[LoadingSampleCentrifugeIntensity] -> Lookup[myResolvedOptions, LoadingSampleCentrifugeIntensity],

		(* time stuff *)
		Replace[PreFlushingSolutionDrainTime] -> Lookup[myResolvedOptions, PreFlushingSolutionDrainTime],
		Replace[ConditioningSolutionDrainTime] -> Lookup[myResolvedOptions, ConditioningSolutionDrainTime],
		Replace[WashingSolutionDrainTime] -> Lookup[myResolvedOptions, WashingSolutionDrainTime],
		Replace[SecondaryWashingSolutionDrainTime] -> Lookup[myResolvedOptions, SecondaryWashingSolutionDrainTime],
		Replace[TertiaryWashingSolutionDrainTime] -> Lookup[myResolvedOptions, TertiaryWashingSolutionDrainTime],
		Replace[ElutingSolutionDrainTime] -> Lookup[myResolvedOptions, ElutingSolutionDrainTime],
		Replace[LoadingSampleDrainTime] -> Lookup[myResolvedOptions, LoadingSampleDrainTime],

		(* dealing with sample loading *)
		Replace[LoadingSampleVolume] -> Lookup[myResolvedOptions, LoadingSampleVolume],
		Replace[LoadingSampleDispenseRate] -> Lookup[myResolvedOptions, LoadingSampleDispenseRate],
		Replace[QuantitativeLoadingSampleSolution] -> Map[Link[#]&, Flatten[Lookup[orderedResource, QuantitativeLoadingResource]]];
		Replace[QuantitativeLoadingSampleVolume] -> Lookup[myResolvedOptions, QuantitativeLoadingSampleVolume],

		(* fill in the solution out *)
		Replace[PreFlushingSampleOutLabel] -> Lookup[myResolvedOptions, PreFlushingSampleOutLabel],
		Replace[ConditioningSampleOutLabel] -> Lookup[myResolvedOptions, ConditioningSampleOutLabel],
		Replace[WashingSampleOutLabel] -> Lookup[myResolvedOptions, WashingSampleOutLabel],
		Replace[SecondaryWashingSampleOutLabel] -> Lookup[myResolvedOptions, SecondaryWashingSampleOutLabel],
		Replace[TertiaryWashingSampleOutLabel] -> Lookup[myResolvedOptions, TertiaryWashingSampleOutLabel],
		Replace[ElutingSampleOutLabel] -> Lookup[myResolvedOptions, ElutingSampleOutLabel],
		Replace[LoadingSampleFlowthroughSampleOutLabel] -> Lookup[myResolvedOptions, LoadingSampleFlowthroughSampleOutLabel],
		Replace[SampleOutLabel] -> Flatten[Lookup[myResolvedOptions,
			{
				PreFlushingSampleOutLabel,
				ConditioningSampleOutLabel,
				LoadingSampleFlowthroughSampleOutLabel,
				WashingSampleOutLabel,
				SecondaryWashingSampleOutLabel,
				TertiaryWashingSampleOutLabel,
				ElutingSampleOutLabel
			}
		]],

		(* well is fixed by the cartridge position/well *)
		Replace[PreFlushingContainerDestinationWell] -> Lookup[myResolvedOptions, ContainerOutWellAssignment],
		Replace[ConditioningContainerDestinationWell] -> Lookup[myResolvedOptions, ContainerOutWellAssignment],
		Replace[WashingContainerDestinationWell] -> Lookup[myResolvedOptions, ContainerOutWellAssignment],
		Replace[SecondaryWashingContainerDestinationWell] -> Lookup[myResolvedOptions, ContainerOutWellAssignment],
		Replace[TertiaryWashingContainerDestinationWell] -> Lookup[myResolvedOptions, ContainerOutWellAssignment],
		Replace[ElutingContainerDestinationWell] -> Lookup[myResolvedOptions, ContainerOutWellAssignment],
		Replace[LoadingSampleFlowthroughContainerDestinationWell] -> Lookup[myResolvedOptions, ContainerOutWellAssignment],

		Replace[PreFlushingSolutionCollectionContainer] -> Map[Link[#]&, Lookup[orderedResource, PreFlushingContainerOutResource]],
		Replace[ConditioningSolutionCollectionContainer] -> Map[Link[#]&, Lookup[orderedResource, ConditioningContainerOutResource]],
		Replace[WashingSolutionCollectionContainer] -> Map[Link[#]&, Lookup[orderedResource, WashingContainerOutResource]],
		Replace[SecondaryWashingSolutionCollectionContainer] -> Map[Link[#]&, Lookup[orderedResource, SecondaryWashingContainerOutResource]],
		Replace[TertiaryWashingSolutionCollectionContainer] -> Map[Link[#]&, Lookup[orderedResource, TertiaryWashingContainerOutResource]],
		Replace[ElutingSolutionCollectionContainer] -> Map[Link[#]&, Lookup[orderedResource, ElutingContainerOutResource]],
		Replace[LoadingSampleFlowthroughContainer] -> Map[Link[#]&, Lookup[orderedResource, LoadingSampleContainerOutResource]],

		Replace[PreFlushingCollectionContainerOutLabel] -> Lookup[myResolvedOptions, PreFlushingCollectionContainerOutLabel],
		Replace[ConditioningCollectionContainerOutLabel] -> Lookup[myResolvedOptions, ConditioningCollectionContainerOutLabel],
		Replace[WashingCollectionContainerOutLabel] -> Lookup[myResolvedOptions, WashingCollectionContainerOutLabel],
		Replace[SecondaryWashingCollectionContainerOutLabel] -> Lookup[myResolvedOptions, SecondaryWashingCollectionContainerOutLabel],
		Replace[TertiaryWashingCollectionContainerOutLabel] -> Lookup[myResolvedOptions, TertiaryWashingCollectionContainerOutLabel],
		Replace[ElutingCollectionContainerOutLabel] -> Lookup[myResolvedOptions, ElutingCollectionContainerOutLabel],
		Replace[LoadingSampleFlowthroughCollectionContainerOutLabel] -> Lookup[myResolvedOptions, LoadingSampleFlowthroughCollectionContainerOutLabel],
		Replace[ContainerOutLabel] -> Flatten[Lookup[myResolvedOptions,
			{
				PreFlushingCollectionContainerOutLabel,
				ConditioningCollectionContainerOutLabel,
				LoadingSampleFlowthroughCollectionContainerOutLabel,
				WashingCollectionContainerOutLabel,
				SecondaryWashingCollectionContainerOutLabel,
				TertiaryWashingCollectionContainerOutLabel,
				ElutingCollectionContainerOutLabel
			}
		]],
		Replace[WasteContainer] -> Map[Link[#]&, Lookup[orderedResource, WasteContainerResource]],

		(* not sure what these are *)
		populateSamplePrepFieldsPooledIndexMatched[myPooledSamples, myResolvedOptions],
		ResolvedOptions -> DeleteCases[myResolvedOptions,  (Verbatim[Simulation] -> _) | (Verbatim[Cache] -> _)],
		UnresolvedOptions -> DeleteCases[myUnresolvedOptions, (Verbatim[Simulation] -> _) | (Verbatim[Cache] -> _)],

		Replace[Checkpoints] -> {
			{"Picking Resources", 60 Minute, "Samples required to execute this protocol are gathered from storage.",
				Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 60 Minute]]},
			{"Preparing Instrumentation", 40 Minute, "The solid phase extractor is configured for the protocol and all required materials are placed on deck.",
				Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 40 Minute]]},
			{"Processing Materials", totalEstimatedRunTime, "Solid phase extraction is performed on the samples.",
				Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> totalEstimatedRunTime]]},
			{"Returning Materials", 10 Minute, "Samples are returned to storage.",
				Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 Minute]]},
			{"Sample Post-Processing", 100 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.",
				Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 100 Minute]]}
		},

		Replace[SamplesInStorage] -> Flatten[Lookup[myResolvedOptions, SamplesInStorageCondition]],
		Replace[SamplesOutStorage] -> Flatten[Lookup[myResolvedOptions, SamplesOutStorageCondition]]
	];

	(* combine the packets together, including the protocol and unit operation packets *)
	allPackets = If[MatchQ[resolvedPreparation, Robotic],
		{Null, Flatten[{finalSPEUnitOperationPackets, roboticFilterUnitOperationPackets}]},
		{protocolPacket, finalSPEUnitOperationPackets}
	];
	(* TODO somehow the Cover as the last of these three unit operations is making duplicate resources where it's fulfilling them from models to be objects and I don't understand why or how *)
	(* make list of all the resources we need to check in FRQ *)
	allResourceBlobs = DeleteDuplicates[Cases[allPackets, _Resource, Infinity]];

	(* Call FRQ *)
	(* note that we're only doing this for manual because robotic will have already called fulfillableResourceQ in the RSP call above *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine] || MatchQ[resolvedPreparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, Simulation -> updatedSimulation, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> cache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs, Simulation -> updatedSimulation, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache -> cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		myResolvedOptions,
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{allPackets,runTime},
		$Failed
	];

	(* generate the simulation rule *)
	simulationRule = Simulation -> updatedSimulation;

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule}
];


(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentSolidPhaseExtraction,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentSolidPhaseExtraction[
	myProtocolPacket : (PacketP[Object[Protocol, SolidPhaseExtraction], {Object, ResolvedOptions}] | $Failed | Null),
	myUnitOperationPackets : {PacketP[Object[UnitOperation]]..} | $Failed,
	mySamples : {{ObjectP[Object[Sample]] ...} ...} | {ObjectP[Object[Sample]] ...} ,
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentSolidPhaseExtraction]
] := Module[
	{mapThreadFriendlyOptions, resolvedPreparation, cache, simulation, samplePackets, protocolObject, currentSimulation, unitOperationPacketsToUse,
		unitOperationField, primitivePacketFieldSpec, simulatedPrimitivePacketsWithModels, simulatedInstrumentPackets, simulatedInstrumentPacketsUnique, allSampleOutPosition,
		allSampleOutState, allSampleOutVolume, allSampleOutLabel, allSampleOutPackets, allSourceSolution,
		allSampleOutPositionUnique, batchSampleStatesInAndOut, allSampleStatesInAndOut, allSampleOutContainerPacket, containersOutSamplesAlreadyInPlace,
		allSampleOutPositionUniqueNoSample, newSampleObjects, allSampleOutPositionToObjectRule, actualSampleOut, actualSampleOutUnpool,
		allSourceSolutionUnpool, allSampleOutVolumeUnpool, nonullSampleOut, nonullSourceSolution, nonullSolutionVolume,
		uploadSampleTransferPackets, sampleOutCompositionPackets, nullCompositionSampleOutPackets, allSourceSolutionLabel, allSampleContainerOutLabel,
		labelToObjectRules, labelToFieldRules, labelToFieldRulesWithSamples, labelToFieldRulesSampleIn, simulationWithLabels,
		allSampleOutPositionUniqueNoSampleNoNull, simulatedWasteContainerPackets, myPooledSamples, allSourceSolutionFilter, unitOperationSampleLinks,
		unitOperationSampleExpressions, unitOperationSamples, nestedUnitOpSamplePackets, flatUnitOpSamplePackets, unitOperationSamplePackets
	},

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Download containers from our sample packets. *)
	samplePackets = Download[
		mySamples,
		Packet[Container],
		Cache -> cache,
		Simulation -> simulation
	];

	(* Lookup our resolved preparation option. *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[

		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[myProtocolPacket, $Failed | Null] && MatchQ[resolvedPreparation, Robotic],
			SimulateCreateID[Object[Protocol, RoboticSamplePreparation]],

		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed | Null] && MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol, SolidPhaseExtraction]],

		True, Lookup[myProtocolPacket, Object]

	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
		ExperimentSolidPhaseExtraction,
		myResolvedOptions
	];

	(* create label to field rules, so that simulation can use label in the option to point to the right field in unit ops  *)
	labelToFieldRules = If[!MatchQ[resolvedPreparation, Manual],
		{},
		DeleteCases[Flatten[{
			Flatten[MapIndexed[
				Function[
					{option, index},
					KeyValueMap[
						Function[{optionName, optionFieldIndex},
							Module[
								{optionValue},
								(* get the label value from the resolved options *)
								optionValue = Lookup[option, optionName];
								Which[
									(* if the label exist, point to the correct field *)
									StringQ[optionValue],
									optionValue -> optionFieldIndex,
									(* if there is nothing, just leave nothing*)
									True,
									Nothing
								]
							]
						],
						<|
							(* non pool *)
							(* sample out *)
							PreFlushingSampleOutLabel -> Field[PreFlushingSampleOut[[index]]],
							ConditioningSampleOutLabel -> Field[ConditioningSampleOut[[index]]],
							LoadingSampleFlowthroughSampleOutLabel -> Field[LoadingSampleFlowthroughSampleOut[[index]]],
							WashingSampleOutLabel -> Field[WashingSampleOut[[index]]],
							SecondaryWashingSampleOutLabel -> Field[SecondaryWashingSampleOut[[index]]],
							TertiaryWashingSampleOutLabel -> Field[TertiaryWashingSampleOut[[index]]],
							ElutingSampleOutLabel -> Field[ElutingSampleOut[[index]]],
							(* container out*)
							PreFlushingCollectionContainerOutLabel -> Field[PreFlushingSolutionCollectionContainerLink[[index]]],
							ConditioningCollectionContainerOutLabel -> Field[ConditioningSolutionCollectionContainerLink[[index]]],
							LoadingSampleFlowthroughCollectionContainerOutLabel -> Field[LoadingSampleFlowthroughSolutionCollectionContainerLink[[index]]],
							WashingCollectionContainerOutLabel -> Field[WashingSolutionCollectionContainerLink[[index]]],
							SecondaryWashingCollectionContainerOutLabel -> Field[SecondaryWashingSolutionCollectionContainerLink[[index]]],
							TertiaryWashingCollectionContainerOutLabel -> Field[TertiaryWashingSolutionCollectionContainerLink[[index]]],
							ElutingCollectionContainerOutLabel -> Field[ElutingSolutionCollectionContainerLink[[index]]],
							(* solution in *)
							PreFlushingSolutionLabel -> Field[PreFlushingSolutionResource[[index]]],
							ConditioningSolutionLabel -> Field[ConditioningSolutionResource[[index]]],
							WashingSolutionLabel -> Field[WashingSolutionResource[[index]]],
							SecondaryWashingSolutionLabel -> Field[SecondaryWashingSolutionResource[[index]]],
							TertiaryWashingSolutionLabel -> Field[TertiaryWashingSolutionResource[[index]]],
							ElutingSolutionLabel -> Field[ElutingSolutionResource[[index]]]
						|>
					]
				],
				mapThreadFriendlyOptions
			]]
		}], Null],
		{}
	];
	(* TODO this is incorrect and will break if I don't fix it *)
	(* can't have the LabelFields rules point to an Expression field; must be a link (so I guess I need to flatten-populate the link fields at the end) *)
	labelToFieldRulesSampleIn = If[!MatchQ[resolvedPreparation, Manual],
		{},
		Module[
			{sampleInLabel, sampleInContainerLabel, sampleInLabelToField, sampleInContainerLabelToField},
			sampleInLabel = Flatten[Lookup[myResolvedOptions, SampleLabel]];
			sampleInContainerLabel = Flatten[Lookup[myResolvedOptions, SourceContainerLabel]];
			sampleInLabelToField = MapIndexed[
				#1 -> Field[SampleExpression[[#2]]]&,
				sampleInLabel
			];
			sampleInContainerLabelToField = MapIndexed[
				#1 -> Field[SampleExpression[[#2]][Container]]&,
				sampleInContainerLabel
			];
			DeleteCases[Flatten[{sampleInLabelToField, sampleInContainerLabelToField}], Null -> _]
		]
	];
	labelToFieldRulesWithSamples = Flatten[{labelToFieldRules, labelToFieldRulesSampleIn}];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = Which[

		(* Robotic Branch *)
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[Object[UnitOperation]]..}],
			Module[{protocolPacket},
				protocolPacket = <|
					Object -> protocolObject,
					Replace[OutputUnitOperations] -> (Link[#, Protocol]&) /@ Lookup[myUnitOperationPackets, Object],
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions -> {}
				|>;
				SimulateResources[
					protocolPacket,
					myUnitOperationPackets,
					ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
					Simulation -> simulation,
					PooledSamplesIn -> mySamples
				]
			],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, SolidPhaseExtraction]. *)
		True,
			myPooledSamples = Lookup[myProtocolPacket, Replace[SampleExpression]];
			SimulateResources[myProtocolPacket, myUnitOperationPackets, Simulation -> simulation, PooledSamplesIn -> myPooledSamples]
	];

	(* if we are doing robotic, then just return at this point because we already did the simulating in the resource packets function *)
	If[MatchQ[resolvedPreparation, Robotic],
		Return[{
			protocolObject,
			currentSimulation
		}]
	];

	(* Figure out what field to download from. *)
	unitOperationField = If[MatchQ[protocolObject, ObjectP[Object[Protocol, SolidPhaseExtraction]]],
		BatchedUnitOperations,
		OutputUnitOperations
	];

	(* get all the fields we want to Download from the simulated primitive packets *)
	primitivePacketFieldSpec = Packet[
		unitOperationField[{
			(* sample *)
			SampleLabel,
			SampleLink,
			SampleExpression,
			SourceContainerLabel,
			(* instrument and cartridge *)
			Instrument,
			ExtractionCartridge,
			ExtractionCartridgeLabel,
			(* preflush *)
			PreFlushingSolutionLink,
			PreFlushingSolutionExpression,
			PreFlushingSolutionLabel,
			(* conditioning *)
			ConditioningSolutionLink,
			ConditioningSolutionExpression,
			ConditioningSolutionLabel,
			(* washing *)
			WashingSolutionLink,
			WashingSolutionExpression,
			WashingSolutionLabel,
			(* secondary washing *)
			SecondaryWashingSolutionLink,
			SecondaryWashingSolutionExpression,
			SecondaryWashingSolutionLabel,
			(* tertiary washing *)
			TertiaryWashingSolutionLink,
			TertiaryWashingSolutionExpression,
			TertiaryWashingSolutionLabel,
			(* eluting *)
			ElutingSolutionLink,
			ElutingSolutionExpression,
			ElutingSolutionLabel,
			(* sample out *)
			SampleOutLabel,
			PreFlushingSampleOutLabel,
			ConditioningSampleOutLabel,
			LoadingSampleFlowthroughSampleOutLabel,
			WashingSampleOutLabel,
			SecondaryWashingSampleOutLabel,
			TertiaryWashingSampleOutLabel,
			ElutingSampleOutLabel,
			(* container out *)
			ContainerOutWellAssignment,
			ContainerOutLabel,
			PreFlushingCollectionContainerOutLabel,
			ConditioningCollectionContainerOutLabel,
			LoadingSampleFlowthroughCollectionContainerOutLabel,
			WashingCollectionContainerOutLabel,
			SecondaryWashingCollectionContainerOutLabel,
			TertiaryWashingCollectionContainerOutLabel,
			ElutingCollectionContainerOutLabel,
			(* container out *)
			PreFlushingSolutionCollectionContainerLink,
			ConditioningSolutionCollectionContainerLink,
			LoadingSampleFlowthroughContainerLink,
			WashingSolutionCollectionContainerLink,
			SecondaryWashingSolutionCollectionContainerLink,
			TertiaryWashingSolutionCollectionContainerLink,
			ElutingSolutionCollectionContainerLink,
			(* volume *)
			LoadingSampleVolume,
			PreFlushingSolutionVolume,
			ConditioningSolutionVolume,
			WashingSolutionVolume,
			SecondaryWashingSolutionVolume,
			TertiaryWashingSolutionVolume,
			ElutingSolutionVolume,
			WasteContainer
		}]
	];

	(* get the actual unit operation packet that we want to use *)
	unitOperationPacketsToUse = If[MatchQ[myUnitOperationPackets, $Failed],
		Select[Lookup[First[currentSimulation], Packets], MatchQ[#, PacketP[Object[UnitOperation, SolidPhaseExtraction]]] && MatchQ[Lookup[#, Protocol], ObjectP[protocolObject]]&],
		myUnitOperationPackets
	];

	(* pull out the samples we need to Download from; we can't necessarily go thorugh SampleLink because it's a multiple multiple field *)
	{
		unitOperationSampleLinks,
		unitOperationSampleExpressions
	} = Transpose[If[MatchQ[myUnitOperationPackets, $Failed],
		Lookup[unitOperationPacketsToUse, {SampleLink, SampleExpression}],
		Lookup[unitOperationPacketsToUse, {Replace[SampleLink], Replace[SampleExpression]}]
	]];

	(* combine everything together for the actual samples in *)
	unitOperationSamples = MapThread[
		If[NullQ[#1],
			#2,
			ToString[#1]
		]&,
		{unitOperationSampleLinks, unitOperationSampleExpressions}
	];

	(* get our simulated primitive packets *)
	{
		{{
			(* this is batched simulatePacket, everything has be run in map *)
			simulatedPrimitivePacketsWithModels,
			simulatedInstrumentPackets,
			simulatedWasteContainerPackets
		}},
		nestedUnitOpSamplePackets
	} = Quiet[
		With[{insertMe = unitOperationField},
			Download[
				{
					{protocolObject},
					Flatten[unitOperationSamples]
				},
				{
					{
						primitivePacketFieldSpec,
						Packet[insertMe[Instrument][{Model, Name, WasteContainer}]],
						Packet[insertMe[WasteContainer][{Model, Name, Contents}]]
					},
					{
						Packet[Container, Model]
					}
				},
				Simulation -> currentSimulation
			]],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];
	flatUnitOpSamplePackets = Flatten[nestedUnitOpSamplePackets];
	unitOperationSamplePackets = unitOperationSamples /. {x:ObjectReferenceP[]|LinkP[]:>SelectFirst[flatUnitOpSamplePackets, MatchQ[#, ObjectP[Download[x, Object]]]&]};

	(* packet with just the unique instrument*)
	simulatedInstrumentPacketsUnique = DeleteDuplicates[Flatten[DeleteDuplicates[simulatedInstrumentPackets]]];

	(* loop across batches for sample out *)
	batchSampleStatesInAndOut = Map[
		Function[{primitivePacket},
			Module[
				{allDestWell, allDestContainer, sampleOutPosition, sampleOutState, allVolume, sampleOutVolume, allVolumeWithPool,
					sampleOutLabel, sourceSolution, workingInstrument, instrumentModel, instrumentWasteContainer, workingInstrumentPacket, workingWasteContainer,
					allDestContainerWithWaste, allDestWellWithWaste, sampleContainerOutLabel, sourceSolutionLabel, allDestContainerNotIndexMatched, nPool, wasteContainer,
					wasteContainerPacket},
				(* we have to check what instrument we are working with, and identify the waste container *)
				nPool = Length[Lookup[primitivePacket, SampleExpression]];
				workingInstrument = Lookup[primitivePacket, Instrument][[1]][Object];
				workingInstrumentPacket = FirstCase[simulatedInstrumentPacketsUnique, KeyValuePattern[Object -> workingInstrument], <||>];
				instrumentModel = If[MatchQ[workingInstrument, ObjectP[Object]],
					Lookup[workingInstrumentPacket, Model],
					workingInstrument
				];
				wasteContainer = First[Lookup[primitivePacket, WasteContainer]];
				wasteContainerPacket = FirstCase[simulatedWasteContainerPackets, KeyValuePattern[Object -> workingInstrument], <||>];
				instrumentWasteContainer = Lookup[workingInstrumentPacket, WasteContainer];

				workingWasteContainer = wasteContainer[Object];

				(* get all container out*)
				allDestContainerNotIndexMatched = Lookup[primitivePacket, {
					PreFlushingSolutionCollectionContainerLink,
					ConditioningSolutionCollectionContainerLink,
					LoadingSampleFlowthroughContainerLink,
					WashingSolutionCollectionContainerLink,
					SecondaryWashingSolutionCollectionContainerLink,
					TertiaryWashingSolutionCollectionContainerLink,
					ElutingSolutionCollectionContainerLink
				}];

				(* get all well destination *)
				allDestWell = Flatten[Map[
					(
						If[MatchQ[Lookup[primitivePacket, #], {ObjectP[]..}],
							Lookup[primitivePacket, ContainerOutWellAssignment],
							ConstantArray[Null, Length[Lookup[primitivePacket, SampleExpression]]]
						]
					)&,
					{
						PreFlushingSolutionCollectionContainerLink,
						ConditioningSolutionCollectionContainerLink,
						LoadingSampleFlowthroughContainerLink,
						WashingSolutionCollectionContainerLink,
						SecondaryWashingSolutionCollectionContainerLink,
						TertiaryWashingSolutionCollectionContainerLink,
						ElutingSolutionCollectionContainerLink
					}
				]];
				(* because if everthing is Null then link turn it into single, have to replace it with Epxression again *)
				allDestContainer = Flatten[Map[
					If[MatchQ[#, {Null} | {}],
						ConstantArray[#, nPool],
						#
					]&,
					allDestContainerNotIndexMatched
				]];

				allDestContainerWithWaste = allDestContainer /. Null -> workingWasteContainer;

				(* well position of any waste container is A1 *)
				allDestWellWithWaste = allDestWell /. Null -> "A1";
				(* get all volume *)
				allVolumeWithPool = Lookup[primitivePacket, {
					PreFlushingSolutionVolume,
					ConditioningSolutionVolume,
					LoadingSampleVolume,
					WashingSolutionVolume,
					SecondaryWashingSolutionVolume,
					TertiaryWashingSolutionVolume,
					ElutingSolutionVolume
				}];
				(* loading sample volume can be pooled, so total it first *)
				allVolume = Flatten[Total[allVolumeWithPool, {3}]];
				(* put it in {well, object} format *)
				sampleOutPosition = MapThread[
					If[MatchQ[#1, WellP] && MatchQ[#2, ObjectP[Object]],
						{#1, #2},
						{Null, Null}
					]&, {allDestWellWithWaste, allDestContainerWithWaste}
				];

				(* all our sample out must be liquid*)
				sampleOutState = ConstantArray[Liquid, Length[sampleOutPosition]];
				(* volume, we assume no lost here, we have to keep the pool because we have to update each source *)
				sampleOutVolume = Flatten[allVolumeWithPool, 1];
				sampleContainerOutLabel = Flatten[Lookup[primitivePacket, {
					PreFlushingCollectionContainerOutLabel,
					ConditioningCollectionContainerOutLabel,
					LoadingSampleFlowthroughCollectionContainerOutLabel,
					WashingCollectionContainerOutLabel,
					SecondaryWashingCollectionContainerOutLabel,
					TertiaryWashingCollectionContainerOutLabel,
					ElutingCollectionContainerOutLabel
				}]];
				sampleOutLabel = Flatten[Lookup[primitivePacket, {
					PreFlushingSampleOutLabel,
					ConditioningSampleOutLabel,
					LoadingSampleFlowthroughSampleOutLabel,
					WashingSampleOutLabel,
					SecondaryWashingSampleOutLabel,
					TertiaryWashingSampleOutLabel,
					ElutingSampleOutLabel
				}]];

				(* source of each sample out, we have to keep the pool here *)
				(* flatten out just the step to index match the sampleout position *)
				sourceSolution = Flatten[Lookup[primitivePacket, {
					PreFlushingSolutionLink,
					ConditioningSolutionLink,
					SampleExpression,
					WashingSolutionLink,
					SecondaryWashingSolutionLink,
					TertiaryWashingSolutionLink,
					ElutingSolutionLink
				}], 1];
				sourceSolutionLabel = Flatten[Lookup[primitivePacket, {
					PreFlushingSolutionLabel,
					ConditioningSolutionLabel,
					SampleLabel,
					WashingSolutionLabel,
					SecondaryWashingSolutionLabel,
					TertiaryWashingSolutionLabel,
					ElutingSolutionLabel
				}], 1];
				(* output - have to put in sules, so that we can merge from each batch later *)
				{
					SampleOutPosition -> sampleOutPosition,
					SampleOutState -> sampleOutState,
					SampleOutVolume -> sampleOutVolume,
					SampleOutLabel -> sampleOutLabel,
					SourceSolution -> sourceSolution,
					SourceSolutionLabel -> sourceSolutionLabel,
					SampleContainerOutLabel -> sampleContainerOutLabel
				}
			]
		],
		simulatedPrimitivePacketsWithModels
	];
	(* merge everything from all batches *)
	allSampleStatesInAndOut = Merge[batchSampleStatesInAndOut, Flatten[#, 1]&] /. Association[x___] -> List[x];

	(* now we pool everything from every batch together, and then create object packet. Flat only for the batches *)
	{
		allSampleOutPosition,
		allSampleOutState,
		allSampleOutVolume,
		allSampleOutLabel,
		allSourceSolution,
		allSourceSolutionLabel,
		allSampleContainerOutLabel
	} = Map[Lookup[allSampleStatesInAndOut, #]&,
		{
			SampleOutPosition,
			SampleOutState,
			SampleOutVolume,
			SampleOutLabel,
			SourceSolution,
			SourceSolutionLabel,
			SampleContainerOutLabel
		}
	];

	(* now we should check, if all of our container out has sample in it already or not *)
	(* we have to do the download call here because of waste container for GX271 is known after the batch *)
	allSampleOutPositionUnique = DeleteDuplicates[allSampleOutPosition];
	allSampleOutContainerPacket = Quiet[Download[
		DeleteDuplicates[allSampleOutPositionUnique[[All, 2]]],
		Packet[Model, Name, Contents],
		Simulation -> currentSimulation
	], {Download::NotLinkField, Download::FieldDoesntExist}];
	(* get the sample that are already in the container that we will work with *)
	containersOutSamplesAlreadyInPlace = Map[
		Function[wellContainer,
			Module[
				{well, container, containerPacket, wellSample},
				{well, container} = {First[wellContainer, Null], Last[wellContainer, Null]};
				containerPacket = FirstCase[allSampleOutContainerPacket, KeyValuePattern[Object -> Download[container, Object]], <||>];
				(* find the sample already in the destination position and return them, otherwise return a Null *)
				wellSample = FirstCase[Lookup[containerPacket, Contents, {}], {well, _}, Null];
				Download[Last[wellSample, Null], Object]
			]
		],
		allSampleOutPositionUnique
	];
	(* for each unique position in any container, it is a new Object[Sample], thus we have to preallocate the sample accordingly *)
	allSampleOutPositionUniqueNoSample = PickList[allSampleOutPositionUnique, containersOutSamplesAlreadyInPlace, Null];
	(* because sometime we don't want to simulate a waste, we have to remove {Null,Null} out too *)
	allSampleOutPositionUniqueNoSampleNoNull = allSampleOutPositionUniqueNoSample /. {Null, Null} -> Nothing;

	(* create sample out packets for anything that doesn't have sample in it already, this is pre-allocation for UploadSampleTransfer *)
	allSampleOutPackets = UploadSample[
		(* Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
		ConstantArray[{}, Length[allSampleOutPositionUniqueNoSampleNoNull]],
		allSampleOutPositionUniqueNoSampleNoNull,
		State -> ConstantArray[Liquid, Length[allSampleOutPositionUniqueNoSampleNoNull]],
		InitialAmount -> ConstantArray[Null, Length[allSampleOutPositionUniqueNoSampleNoNull]],
		Simulation -> currentSimulation,
		UpdatedBy -> protocolObject,
		FastTrack -> True,
		Upload -> False,
		SimulationMode -> True
	];

	(* update simulation for these new sample out *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[allSampleOutPackets]];
	(* take just the new sample *)
	newSampleObjects = Take[
		Lookup[allSampleOutPackets, Object, {}],
		Length[allSampleOutPositionUniqueNoSampleNoNull]
	];
	(* now we pull all the new object object out of the packet, and we will use uploadsampletransfer to update sample states *)
	(* make rule to change from sample position to actual object *)
	allSampleOutPositionToObjectRule = MapThread[
		(
			If[MatchQ[#2, Null],
				(* if we don't already have an object, we will have to find matching object from the newly created object in this simulation *)
				(* newSampleObjects and allSampleOutPositionUnique are indexmatched *)
				#1 -> FirstOrDefault[PickList[newSampleObjects, allSampleOutPositionUniqueNoSampleNoNull, #1]],
				(* otherwise it will be the old object *)
				#1 -> FirstOrDefault[PickList[containersOutSamplesAlreadyInPlace, allSampleOutPositionUnique, #1]]
			]
		)&,
		{allSampleOutPositionUnique, containersOutSamplesAlreadyInPlace}
	];

	(* convert position to object *)
	actualSampleOut = allSampleOutPosition /. allSampleOutPositionToObjectRule;

	(* then we have to unpool the sample and make sure that the sampleOutObject index match with each one of them *)
	(* we need Null to keep the index match *)
	actualSampleOutUnpool = Flatten[Map[
		Module[
			{nSample},
			nSample = Length[#[[1]]];
			ConstantArray[#[[2]], nSample]
		]&,
		Transpose[{allSourceSolution, actualSampleOut}]
	] /. {} -> Null];
	allSourceSolutionUnpool = Flatten[allSourceSolution];
	allSourceSolutionFilter = MapThread[
		Not[NullQ[#1]] && Not[NullQ[#2]]&,
		{actualSampleOutUnpool, allSourceSolutionUnpool}
	];
	allSampleOutVolumeUnpool = Flatten[allSampleOutVolume];
	(* remove all Null, because those are the step that we don't use *)
	{
		nonullSampleOut,
		nonullSourceSolution,
		nonullSolutionVolume
	} = Map[
		PickList[#, allSourceSolutionFilter]&,
		{
			actualSampleOutUnpool,
			allSourceSolutionUnpool,
			allSampleOutVolumeUnpool
		}
	];
	(* update sample transfer status of all sample out *)
	uploadSampleTransferPackets = If[Length[nonullSampleOut] > 0,
		UploadSampleTransfer[
			nonullSourceSolution,
			nonullSampleOut,
			nonullSolutionVolume,
			Upload -> False,
			FastTrack -> True,
			Simulation -> currentSimulation,
			UpdatedBy -> protocolObject
		],
		{}
	];

	(* update our simulation with new volume and object state *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

	(* pull out the packets of all samples out with their new post-transfer compositions *)
	sampleOutCompositionPackets = Download[nonullSampleOut, Packet[Composition], Simulation -> currentSimulation];
	(* update composition *)
	nullCompositionSampleOutPackets = Map[
		<|Object -> Lookup[#, Object], Replace[Composition] -> (Lookup[#, Composition] /. {CompositionP :> Null})|>&,
		sampleOutCompositionPackets
	];
	(* update our simulation with the Null compositions *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[nullCompositionSampleOutPackets]];

	(* create label -> object rule for simulation *)
	(* TODO make the labels work for the other options too and not just SampleLabel and SourceContainerLabel *)
	labelToObjectRules = Join[
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePacketsWithModels, SampleLabel]], {}],
			{},
			Flatten[MapThread[
				Which[
					MatchQ[#2, ObjectP[]] && StringQ[#1[[1]]], #1[[1]] -> #2,
					MatchQ[#3, {ObjectP[]..}] && SameLengthQ[#1, #3], Rule @@@ Transpose[{#1, #3}],
					True, {}
				]&,
				{Join @@ Lookup[simulatedPrimitivePacketsWithModels, SampleLabel], Join @@ Lookup[simulatedPrimitivePacketsWithModels, SampleLink], Join @@ Lookup[simulatedPrimitivePacketsWithModels, SampleExpression]}
			]]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePacketsWithModels, SourceContainerLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePacketsWithModels, SourceContainerLabel]], Download[Lookup[Flatten[unitOperationSamplePackets], Container], Object]}
			]
		],
		If[MatchQ[Flatten[allSampleOutLabel], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[allSampleOutLabel], Flatten[actualSampleOut]}
			]
		],
		If[MatchQ[Flatten[allSourceSolutionLabel], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[allSourceSolutionLabel], Flatten[allSourceSolution]}
			]
		]
	];

	(* note that I don't actually need SampleOut/ContainerOut labels here because it is just all step container and sample out put together *)
	simulationWithLabels = Simulation[
		Labels -> labelToObjectRules,
		LabelFields -> labelToFieldRulesWithSamples
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}

];(* end of simulateExperimentSolidPhaseExtraction *)

(* ::Subsection::Closed:: *)
(* speTableFunction *)
(* Try to put all look up tables all in one place for easy future edits *)
(* TODO this is obviously crazy; we should try to not do this... *)
speTableFunction[output_String] := Module[
	{speExtractionOptionsList, queryInstrument},
	(* TABLE - define tableExtractionOptions as a general logic guide for options resolution *)
	speExtractionOptionsList =
		{
			{
				Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"], (* Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Extraction"] *)
				Injection,
				Model[Container, ExtractionCartridge],
				{1, Infinity},
				(* we can keep batching, so 1 sample can be distributed across 2 plates *)
				{0 Milliliter, 384 Milliliter},
				Manual,
				Model[Container, Plate, "id:E8zoYveRllM7"], (*Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"],*)
				1,
				{0 Milliliter, 2 Milliliter}
			},
			{
				Model[Instrument, PressureManifold, "id:zGj91a7mElrL"], (* Model[Instrument, PressureManifold, "Biotage PRESSURE+ 48 Positive Pressure Manifold"] *)
				Pressure,
				Model[Container, ExtractionCartridge],
				{1, Infinity},
				(* 30 mL because  most cartridges are 6 mL, 5 times loading *)
				{0 Milliliter, 6 Milliliter},
				Manual,
				Model[Container, Vessel, "id:xRO9n3vk11pw"], (*Model[Container, Vessel, "15mL Tube"],*)
				7,
				{0 Milliliter, 15 Milliliter}
			},
			{
				Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"], (* Model[Instrument, PressureManifold, "MPE2"] *)
				Pressure,
				Model[Container, Plate, Filter],
				{1, Infinity},
				{0 Milliliter, 2 Milliliter},
				Robotic,
				Model[Container, Plate, "id:L8kPEjkmLbvW"], (*Model[Container, Plate, "96-well 2mL Deep Well Plate"],*)
				4,
				{0 Milliliter, 2 Milliliter}
			},
			{
				Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"], (* Model[Instrument, PressureManifold, "MPE2 Sterile"] *)
				Pressure,
				Model[Container, Plate, Filter],
				{1, Infinity},
				{0 Milliliter, 2 Milliliter},
				Robotic,
				Model[Container, Plate, "id:n0k9mGkwbvG4"], (*Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],*)
				4,
				{0 Milliliter, 2 Milliliter}
			},
			{
				Model[Instrument, Centrifuge, "id:eGakldJEz14E"], (* Model[Instrument, Centrifuge, "Eppendorf 5920R"] *)
				Centrifuge,
				Model[Container, Plate, Filter],
				{1, Infinity},
				(* max at 10 mL because most filter max volume is 2 mL -> 5 times fill up is slow*)
				{0 Milliliter, 1.1 Milliliter},
				Manual,
				Model[Container, Plate, "id:L8kPEjkmLbvW"], (*Model[Container, Plate, "96-well 2mL Deep Well Plate"],*)
				7,
				{0 Milliliter, 2 Milliliter}
			},
			{
				Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"], (* Model[Instrument, Centrifuge, "VSpin"] *)
				Centrifuge,
				Model[Container, Plate, Filter],
				{1, Infinity},
				{0 Milliliter, 0.3 Milliliter},
				Robotic,
				Model[Container, Plate, "id:n0k9mGzRaaBn"], (*Model[Container, Plate, "96-well UV-Star Plate"],*)
				4,
				{0 Milliliter, 0.3 Milliliter}
			},
			{
				Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],  (* Model[Instrument, Centrifuge, "HiG4"] *)
				Centrifuge,
				Model[Container, Plate, Filter],
				{1, Infinity},
				(* max at 2 mL because of the aliquot plate *)
				{0 Milliliter, 0.3 Milliliter},
				Robotic,
				Model[Container, Plate, "id:4pO6dMOqKBaX"],(*Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"]*)
				4,
				{0 Milliliter, 0.3 Milliliter}
			},
			(*			{*)
			(*				Model[Instrument, SyringePump, "id:GmzlKjPzN9l4"],*) (* Model[Instrument, SyringePump, "NE-1010 Syringe Pump"] *)
			(*				Injection,*)
			(*				Model[Item, ExtractionCartridge],*)
			(*				{1, Infinity},*)
			(*				*)(* max at 60 mL, limit by Filter *)
			(*				{0 Milliliter, 60 Milliliter},*)
			(*				Manual,*)
			(*				Null,*)
			(*				7*)
			(*			},*)
			(* most likely this will run for DNA/RNA column *)
			(*			{Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"],*) (* Model[Instrument, Centrifuge, "Microfuge 16"] *)
			(*				Centrifuge,*)
			(*				Model[Container, Vessel, Filter],*)
			(*				{1, 16},*)
			(*				{0 Milliliter, 3.5 Milliliter},*)
			(*				Manual,*)
			(*				Null,*)
			(*				True},*)
			(*			{*)
			(*				Model[Instrument, VacuumManifold, "id:aXRlGnZmOdVm"],*) (* Model[Instrument, VacuumManifold, "12-port Vacuum Manifold"] *)
			(*				Vacuum,*)
			(*				Model[Container, ExtractionCartridge],*)
			(*				{1, 12},*)
			(*				{0 Millilter, 30 Milliliter},*)
			(*				Manual,*)
			(*				Model[Container, Vessel, "15mL Tube"],*)
			(*				Infinity*)
			(*			},*)
			(*			{*)
			(*				Model[Instrument, VacuumManifold, "id:qdkmxz0V139V"],*) (* Model[Instrument, VacuumManifold, "24-port Vacuum Manifold"] *)
			(*				Vacuum,*)
			(*				Model[Container, ExtractionCartridge],*)
			(*				{1, 24},*)
			(*				{0 Milliliter, 30 Milliliter},*)
			(*				Manual,*)
			(*				Model[Container, Vessel, "15mL Tube"],*)
			(*				Infinity*)
			(*			},*)
			{
				Model[Instrument, FilterBlock, "id:rea9jl1orrGr"], (* Model[Instrument, FilterBlock, "Filter Block"] *)
				Pressure,
				Model[Container, Plate, Filter],
				{1, Infinity},
				{0 Milliliter, 1.1 Milliliter},
				Manual,
				Model[Container, Plate, "id:L8kPEjkmLbvW"], (*Model[Container, Plate, "96-well 2mL Deep Well Plate"],*)
				7,
				{0 Milliliter, 2 Milliliter}
			}
			(*			{*)
			(*				Model[Instrument, VacuumManifold, "id:qdkmxz0V139V"],*) (* Model[Instrument, VacuumManifold, "24-port Vacuum Manifold"] *)
			(*				Gravity,*)
			(*				Model[Container, ExtractionCartridge],*)
			(*				{1, 24},*)
			(*				{0 Milliliter, 10 Milliliter},*)
			(*				Manual,*)
			(*				Model[Container, Vessel, "15mL Tube"],*)
			(*				Infinity*)
			(*			},*)
			(*			{*)
			(*				Model[Instrument, FilterBlock, "id:rea9jl1orrGr"],*) (* Model[Instrument, FilterBlock, "Filter Block"] *)
			(*				Gravity,*)
			(*				Model[Container, Plate, Filter],*)
			(*				{1, Infinity},*)
			(*				{0 Milliliter, 2 Milliliter},*)
			(*				Manual,*)
			(*				Model[Container, Plate, "96-well 2mL Deep Well Plate"],*)
			(*				7*)
			(*			}*)
		};

	(* setup output table*)
	Switch[output,

		(* if request for speExtractionOptions -> we will run search for proper instrument and put it in association format *)
		"speExtractionOptions",
		queryInstrument = Map[
			Search[Object[Instrument], Model == # && Status != Retired]&,
			speExtractionOptionsList[[;;, 1]]
		];
		(* have to put in MapThread because some how Search doesn't like numbers in Condition fields *)
		MapThread[
			<|
				"Instrument" -> #1[[1]],
				"InstrumentPattern" -> ObjectP[Flatten[{#1[[1]], #2}]],
				"InstrumentObjects" -> #2,
				"ExtractionMethod" -> #1[[2]],
				"ExtractionCartridgeType" -> #1[[3]],
				"ExtractionCartridgeTypePattern" -> TypeP[#1[[3]]],
				"NumberOfSamples" -> RangeP[Sequence @@ #1[[4]], 1],
				"VolumeOfSample" -> RangeP[Sequence @@ #1[[5]]],
				"MaxNumberOfSample" -> Last[#1[[4]]],
				"MaxVolumeOfSample" -> Last[#1[[5]]],
				"Preparation" -> #1[[6]],
				"DefaultContainer" -> #1[[7]],
				"CollectionStep" -> LessEqualP[#1[[8]]],
				"MaxVolumeIfCollect" -> RangeP[Sequence @@ #1[[9]]]
			|> &,
			{speExtractionOptionsList, queryInstrument}
		],

		(* TABLE - setup a preferred extraction sorbent for each extraction mode *)
		"spePreferredExtractionSorbent",
		<|
			NormalPhase -> Silica,
			ReversePhase -> C18,
			IonExchange -> QuaternaryAmmoniumIon
		|>,

		(* TABLE - this is special case for ion exchange, buffer selection is based on the sorbent not the extraction mode*)
		"speIonExchangeDefinition",
		<|
			AnionicExtraction -> Alternatives[QuaternaryAmmoniumIon],
			CationicExtraction -> Alternatives[Carboxylate]
		|>,

		(* TABLE - default buffer definition *)
		"speDefaultSolutionDefinition",
		<|
			ReversePhase ->
				{
					PreFlushing -> Model[Sample, StockSolution, "90% methanol"],
					Conditioning -> Model[Sample, "Milli-Q water"],
					Washing -> Model[Sample, StockSolution, "5% Methanol in Water"],
					Eluting -> Model[Sample, StockSolution, "90% methanol"]
				},
			NormalPhase ->
				{
					PreFlushing -> Model[Sample, "Dichloromethane, Reagent Grade"],
					Conditioning -> Model[Sample, "Hexanes"],
					Washing -> Model[Sample, StockSolution, "5% Dichloromethane in Hexane"],
					Eluting -> Model[Sample, StockSolution, "50% Dichloromethane in Hexane"]
				},
			AnionicExtraction ->
				{
					PreFlushing -> Model[Sample, StockSolution, "90% methanol"],
					Conditioning -> Model[Sample, "Milli-Q water"],
					Washing -> Model[Sample, StockSolution, "20mM Ammonium Acetate"],
					Eluting -> Model[Sample, StockSolution, "5% Formic Acid in Methanol"]
				},
			CationicExtraction ->
				{
					PreFlushing -> Model[Sample, StockSolution, "90% methanol"],
					Conditioning -> Model[Sample, "pH4 Water"],
					Washing -> Model[Sample, StockSolution, "0.1M HCl"],
					Eluting -> Model[Sample, StockSolution, "5% Ammonium Hydroxide in Methanol"]
				},
			Null -> {
				PreFlushing -> Model[Sample, "Milli-Q water"],
				Conditioning -> Model[Sample, "Milli-Q water"],
				Washing -> Model[Sample, "Milli-Q water"],
				Eluting -> Model[Sample, "Milli-Q water"]
			},
			SizeExclusion -> {
				PreFlushing -> Model[Sample, "Milli-Q water"],
				Conditioning -> Model[Sample, "Milli-Q water"],
				Washing -> Model[Sample, "Milli-Q water"],
				Eluting -> Model[Sample, "Milli-Q water"]
			},
			Affinity -> {
				PreFlushing -> Model[Sample, "Milli-Q water"],
				Conditioning -> Model[Sample, "Milli-Q water"],
				Washing -> Model[Sample, "Milli-Q water"],
				Eluting -> Model[Sample, "Milli-Q water"]
			},
			Chiral -> {
				PreFlushing -> Model[Sample, "Milli-Q water"],
				Conditioning -> Model[Sample, "Milli-Q water"],
				Washing -> Model[Sample, "Milli-Q water"],
				Eluting -> Model[Sample, "Milli-Q water"]
			}
		|>
	]
];
(* ::Subsection::Closed:: *)
(* speGetTableFirstRow *)
(* function to help query the table *)
speGetTableFirstRow[tableData_, searchColumn_, suppliedValue_] := Module[{subTable, matchedRows},
	subTable = Lookup[tableData, searchColumn];
	matchedRows = Flatten[Position[Map[MatchQ[suppliedValue, #] &, subTable], True]];
	(* if no matched index is found -> return empty list *)
	If[!MatchQ[matchedRows, {}],
		{tableData[[First[matchedRows]]]},
		{}
	]
];
speGetTableAll[tableData_, searchColumn_, suppliedValue_] := Module[{subTable, matchedRows},
	subTable = Lookup[tableData, searchColumn];
	matchedRows = Flatten[Position[Map[MatchQ[suppliedValue, #] &, subTable], True]];
	(* if no matched index is found -> return empty list *)
	If[!MatchQ[matchedRows, {}],
		Flatten[{tableData[[Sort[matchedRows]]]}],
		{}
	]
];

(* ::Subsection::Closed:: *)
(* speSolutionResolver *)
(* a sub-function to resolve solution-related options that is not instrument specific, the task is repetitive *)
(* TODO this function is dumb too and we should try to get rid of it *)
speSolutionResolver[
	downloadedstuff_,
	tableExtractionOptions_,
	cartridgeModel_,
	instrumentModel_,
	extractionMethod_,
	solutionSwitch_,
	solutionVolume_,
	solutionTemperature_,
	solutionTemperatureEquilibrationTime_,
	collectSolution_,
	solutionPressure_,
	solutionDispenseRate_,
	solutionDrainTime_,
	solutionUntilDrained_,
	solutionMaxDrainTime_,
	suppliedSolutionLabel_,
	resolvedPreparation_,
	resolvedSolution_
] := Module[
	(* interval variable for generic Solution Resolver*)
	{
		resolvedVolume, resolvedTemperatureEquilibrationTime, maxContainerVolume, instrumentContainerOut,
		resolvedSolutionDispenseRate, resolvedSolutionPressure, semiResolvedDrainTime, semiResolvedMaxDrainTime, resolvedSolutionTemperature, resolvedSolutionLabel,
		(* error and warning *)
		warningPressureTooLow, warningPressureTooHigh, warningDispenseRateTooLow, warningDispenseRateToHigh, warningPressureMustBeBoolean,
		(* intermediate variables *)
		cartridgeBedWeight,
		semiResolvedSolutionPressure, minPressure, maxPressure, maxPressureWithFlowControl, semiResolvedSolutionDispenseRate, minRate, maxRate,
		considerAmbient, cartridgeMaxVolume, defaultVolume, volumeInstrumentError,
		errorInstrumentSolutionTemperature, biotageQ, gilsonQ, mpe2Q, mpe2SterileQ, filterBlockQ
	},

	(* set error and warning variables *)
	{
		warningPressureTooLow,
		warningPressureTooHigh,
		warningDispenseRateTooLow,
		warningDispenseRateToHigh,
		warningPressureMustBeBoolean,
		volumeInstrumentError,
		errorInstrumentSolutionTemperature
	} = ConstantArray[False, 7];

	(* determine if we're in the gilson or biotage or mpe2 (or others I guess) *)
	biotageQ = MatchQ[instrumentModel, Model[Instrument, PressureManifold, "id:zGj91a7mElrL"]];
	gilsonQ = MatchQ[instrumentModel, Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]];
	mpe2Q = MatchQ[instrumentModel, Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"]];
	mpe2SterileQ = MatchQ[instrumentModel, Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]];
	filterBlockQ = MatchQ[instrumentModel, Model[Instrument, FilterBlock, "id:rea9jl1orrGr"]];

	(* get the bed weight *)
	cartridgeBedWeight = Lookup[fetchPacketFromCache[cartridgeModel, downloadedstuff], BedWeight];
	cartridgeMaxVolume = Lookup[fetchPacketFromCache[cartridgeModel, downloadedstuff], MaxVolume];
	(* default volume to half of cartridge or collection container *)
	defaultVolume = 0.5 * cartridgeMaxVolume;

	(* instrument specific container out *)
	instrumentContainerOut = Lookup[Cases[tableExtractionOptions, KeyValuePattern["Instrument" -> instrumentModel]], "DefaultContainer"];
	maxContainerVolume = cacheLookup[downloadedstuff, instrumentContainerOut, MaxVolume];

	(* if the master switch is true, then resolve it, otherwise set them all to null *)
	If[MatchQ[solutionSwitch, False],
		(* in case the master switch is False, leave everything as Null*)
		Join[ConstantArray[Null, 8], ConstantArray[False, 7]],
		(* if that step is used we have to actually resolve it *)
		(
			(* --1-- resolve theoretical volume first *)
			{resolvedVolume, volumeInstrumentError} = Which[
				(* if we have a max container volume, make sure we don't exceed it with defaultVolume; otherwise just go with that *)
				MatchQ[solutionVolume, Automatic] && VolumeQ[maxContainerVolume], {Min[{defaultVolume, maxContainerVolume}], False},
				MatchQ[solutionVolume, Automatic], {defaultVolume, False},
				(* if it's not automatic, then we have to check if volume are too large for cartridge or instrument or not *)
				(* note that for the gilson I DON'T care about the cartridge volume because customers can load more than its capacity because it drains quickly.  This is admitteldy kind of dumb but this is how it has always been so I don't want to remove the ability to do this now *)
				Not[gilsonQ] && VolumeQ[cartridgeMaxVolume] && solutionVolume > cartridgeMaxVolume, {solutionVolume, True},

				(* note also that we only care about the max container volume if we're actually collecting this; for the gilsons, again, we're not always doing that *)
				collectSolution && VolumeQ[maxContainerVolume] && solutionVolume > maxContainerVolume, {solutionVolume, True},
				True, {solutionVolume, False}
			];

			(* --2-- resolve solution temperature *)
			(* mainly change 'Ambient' to actual temperature *)
			resolvedSolutionTemperature = solutionTemperature /. Ambient -> $AmbientTemperature;
			(* we can only suppoet temperature for Biotage for now *)
			errorInstrumentSolutionTemperature = If[
				!biotageQ && !MatchQ[resolvedSolutionTemperature, EqualP[$AmbientTemperature]],
				True,
				False
			];
			(* if the temperature is around 22 - 25 C, just call it as Ambient *)
			considerAmbient = If[MatchQ[resolvedSolutionTemperature, RangeP[22 Celsius, 25 Celsius]], True, False];
			(* resolve the equilibration time *)
			resolvedTemperatureEquilibrationTime = Switch[{considerAmbient, solutionTemperatureEquilibrationTime},
				(* if it is ambient and the equilibration time is Automatic, skip this step *)
				{True, Automatic},
				Null,

				(* if user temperature is not ambient, but didn't tell how long. set the time to 3 minutes *)
				{False, Automatic},
				3 Minute,

				(* if user supply the time, leave it as is *)
				(* if user want ambient but somehow they supply the equilibration time, we have to do it*)
				(* TODO we should have a check whether sample is already at ambient temperature or not*)
				{_, Except[Automatic]},
				solutionTemperatureEquilibrationTime
			];

			(* --4-- resolve for pressure *)
			(* we have to resolve pressure first, since for biotage and the MPE2, it is required to detemine the flow rate later*)
			(* get all instrument that require pressure option to run *)

			semiResolvedSolutionPressure = Which[
				(biotageQ || mpe2Q || mpe2SterileQ) && MatchQ[solutionPressure, Automatic], 25 PSI,
				(* for filterblock it has to be Boolean *)
				filterBlockQ && MatchQ[solutionPressure, Automatic], True,
				filterBlockQ && MatchQ[solutionPressure, GreaterP[0 PSI]], True,
				filterBlockQ && MatchQ[solutionPressure, EqualP[0 PSI]], False,
				True, solutionPressure,
				(* if we are not using pressure instrument, set to null*)
				{_, _},
					solutionPressure
			];
			(* check for pressure error now *)
			{minPressure, maxPressure} = Lookup[fetchPacketFromCache[instrumentModel, downloadedstuff], {MinPressure, MaxPressure}] /. Null -> 0 PSI;
			resolvedSolutionPressure = Switch[semiResolvedSolutionPressure,

				(* if it is a quantity, check whether it is within operation limit or not*)
				_?QuantityQ,
					Which[
						semiResolvedSolutionPressure < minPressure,
						warningPressureTooLow = True;
						minPressure,

						semiResolvedSolutionPressure > maxPressure,
						warningPressureTooHigh = True;
						maxPressure,

						semiResolvedSolutionPressure >= minPressure && semiResolvedSolutionPressure <= maxPressure,
						semiResolvedSolutionPressure
					],

				BooleanP,
					If[MatchQ[solutionPressure, GreaterP[0 PSI]],
						(
							warningPressureMustBeBoolean = True;
							semiResolvedSolutionPressure
						),
						semiResolvedSolutionPressure
					],

				_,
					semiResolvedSolutionPressure /. {Automatic -> Null}

			];
			(* --5-- resolve for injection related parameters *)
			(* this is only semi resolve since it's still dependent on instrument, we just do it to make life easy *)

			(* we only really care about the flow MaxPressureWithFlowControl for the biotage *)
			maxPressureWithFlowControl = If[biotageQ,
				Lookup[fetchPacketFromCache[instrumentModel, downloadedstuff], MaxPressureWithFlowControl],
				Null
			];
			semiResolvedSolutionDispenseRate = Which[
				(* Biotage - special case *)
				(* if this is Biotage, we will check whether the pressure is above the flow control pressure or not*)
				(* if pressure is within the limit -> automatically set it to 100 -> this is so high because of the weird unit on rotometer *)
				biotageQ && resolvedSolutionPressure <= maxPressureWithFlowControl && MatchQ[solutionDispenseRate, Automatic],
					500 Milliliter / Minute,
				biotageQ && resolvedSolutionPressure <= maxPressureWithFlowControl,
					solutionDispenseRate,
				biotageQ && resolvedSolutionPressure > maxPressureWithFlowControl,
					Null,
				(* if user supplied the rate, return that number *)
				Not[MatchQ[solutionDispenseRate, Automatic]],
					solutionDispenseRate,
				(** Other injection based instrument **)
				(* default to 5 ml/min *)
				gilsonQ || MatchQ[instrumentModel, ObjectP[Model[Instrument, SyringePump]]],
					5 Milliliter / Minute,

				(* otherwise Null*)
				True, Null
			];

			(* we should check now whether the supplied number make sense or not *)
			{minRate, maxRate} = Lookup[fetchPacketFromCache[instrumentModel, downloadedstuff], {MinFlowRate, MaxFlowRate}];
			{resolvedSolutionDispenseRate, warningDispenseRateTooLow} = Which[

				MatchQ[semiResolvedSolutionDispenseRate, LessP[minRate]],
					{minRate, True},

				MatchQ[semiResolvedSolutionDispenseRate, GreaterP[maxRate]],
					{maxRate, True},

				MatchQ[semiResolvedSolutionDispenseRate, RangeP[minRate, maxRate]],
					{semiResolvedSolutionDispenseRate, False},

				True,
					{Null, False}

			];

			(* --6-- resolve for drain time *)
			(* can only be semi resolved, because we have to check equipment limit again *)
			semiResolvedDrainTime = Switch[{resolvedSolutionDispenseRate, solutionDrainTime},
				(* for equipment that cannot control rate *)
				{Null, Automatic},
					2 Minute,

				(* for equipment that can control rate *)
				{GreaterP[0 Milliliter / Minute], Automatic},
					If[biotageQ,
						1 Minute,
						(resolvedVolume) / (resolvedSolutionDispenseRate)
					],

				(* if rate is 0 -> this is problematic -> I guess you just want to run gravity on rate-controlled machine *)
				{EqualP[0 Milliliter / Minute], Automatic},
					1 Minute,

				(*if its not automatic, leave it as is*)
				{_, Except[Automatic]},
					solutionDrainTime
			];
			(* now we can deal with the MaxDrainTime *)
			semiResolvedMaxDrainTime = Switch[{semiResolvedDrainTime, solutionMaxDrainTime},

				{Except[Null], Automatic},
					3 * semiResolvedDrainTime,

				{Null, _},
					Null,

				{Except[Null], Except[Automatic]},
					solutionMaxDrainTime

			];

			(* --7-- resolve equilibration time *)
			(* only applicable if there is pause between liquid loading and force application (Vacuum/Centrifuge) *)
			(*			resolvedSolutionEquilibrationTime = Switch[{cartridgeModel, extractionMethod, solutionEquilibrationTime},*)

			(*				{ObjectP[Model[Container]], Vacuum | Centrifuge, Automatic},*)
			(*				0 Minute,*)

			(*				{ObjectP[Model[Container]], Vacuum | Centrifuge, Except[Automatic]},*)
			(*				solutionEquilibrationTime,*)

			(*				*)(* otherwise it has to be Null *)
			(*				{_, _, _},*)
			(*				Null*)
			(*			];*)
			(* --8-- resolve the solution label *)
			(* we want to resolve these so do it now if t's not already *)
			resolvedSolutionLabel = If[StringQ[suppliedSolutionLabel],
				suppliedSolutionLabel,
				ToString[resolvedSolution]
			];

			(* summarize the resolved output *)
			{
				(* resolved *)
				resolvedVolume,
				resolvedTemperatureEquilibrationTime,
				(*				resolvedMixCollectedSolution,*)
				resolvedSolutionPressure,
				resolvedSolutionDispenseRate,
				semiResolvedDrainTime,
				semiResolvedMaxDrainTime,
				resolvedSolutionTemperature,
				(*				resolvedSolutionEquilibrationTime,*)
				resolvedSolutionLabel,
				(* warning and error *)
				warningPressureTooLow,
				warningPressureTooHigh,
				warningDispenseRateTooLow,
				warningDispenseRateToHigh,
				warningPressureMustBeBoolean,
				volumeInstrumentError,
				errorInstrumentSolutionTemperature
			}
		)
	]
];
(* ::Subsection::Closed:: *)
(* speContainerResolver *)
speContainerResolver[downloadedstuff_, tableExtractionOptions_, instrumentModel_, extractionMethod_, collectionSwitch_, filtrateVolume_, suppliedContainer_, suppliedCartridge_, solutionSwitch_] := Module[
	{suppliedContainerModel,
		defaultContainer,
		containerOut,
		requiredParameters,
		defaultDimension, defaultCrossSection, defaultFootprint,
		suppliedDimension, suppliedCrossSection, suppliedFootprint,
		acceptableContainer,
		bestFitPlateModel,
		maxContainerVolume,
		containerOutModel,
		numberOfContainer,
		maxContainerModelVolume,
		(* error variables *)
		warningUnsupportedContainer},

	(* if the supplied container is a model ->  get the container model*)
	suppliedContainerModel = If[MatchQ[suppliedContainer, ObjectP[Object]],
		cacheLookup[downloadedstuff, suppliedContainer, Model],
		suppliedContainer
	];

	(* the selection depends entirely on instrument footprint *)
	(* get default container *)
	defaultContainer = Sequence @@ Lookup[speGetTableFirstRow[tableExtractionOptions, {"InstrumentPattern"}, {instrumentModel}], "DefaultContainer"];

	(* setup error variables *)
	{warningUnsupportedContainer} = ConstantArray[False, 1];

	{containerOut, warningUnsupportedContainer} = If[MatchQ[solutionSwitch, True],
		(
			Switch[instrumentModel,
				(* Gilson *)
				Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],
					Switch[{collectionSwitch, suppliedContainerModel},

						(* we will force user to use only 48 well plate, not allowing any tube to keep things simple *)
						{_, Except[Automatic|Null]},
							If[Not[MatchQ[suppliedContainerModel, ObjectP[defaultContainer]]],
								{defaultContainer, True},
								{suppliedContainer, False}
							],
						{_, Null},
							{Null, False},
						{False, Automatic},
						(* TODO check with the machine again *)
							{Null, False},

						{True, Automatic},
							{defaultContainer, False}
					],

				(* Biotage *)
				Model[Instrument, PressureManifold, "id:zGj91a7mElrL"] | Model[Instrument, VacuumManifold, "id:aXRlGnZmOdVm"] | Model[Instrument, VacuumManifold, "id:qdkmxz0V139V"],
					Switch[{collectionSwitch, suppliedContainerModel},

						(* don't overwrite what the customer tells you *)
						{_, Except[Automatic|Null]},
							(
								(* right now we just control the collection container to be 15mL Falcon only *)
								(* if it's not the exact model, we will check dimension that it will fit in the rack*)
								(* TODO -> in the future we will call the rack and check whether tube dimension fit in the rack holes or not, but for now we will just use 15 ml Falcon tube as standard *)
								requiredParameters = {Dimensions, CrossSectionalShape, Footprint};
								{defaultDimension, defaultCrossSection, defaultFootprint} = Map[cacheLookup[downloadedstuff, defaultContainer, #]&, requiredParameters];
								{suppliedDimension, suppliedCrossSection, suppliedFootprint} = Map[cacheLookup[downloadedstuff, suppliedContainerModel, #]&, requiredParameters];
								acceptableContainer = (AllTrue[MapThread[GreaterEqual[#1, 0.95 * #2]&, {suppliedDimension, defaultDimension}], TrueQ] && MatchQ[suppliedCrossSection, defaultCrossSection]) || MatchQ[suppliedFootprint, defaultFootprint];
								If[acceptableContainer,
									{suppliedContainer, False},
									{defaultContainer, True}
								]
							),

						{_, Null},
							{Null, False},

						{False, Automatic},
						(* if you don't collect go to waste please *)
							{Model[Container, Vessel, "Biotage Pressure+48 Waste Tub"], False},

						{True, Automatic},
							{defaultContainer, False}

					],

				(* MPE2 or sterile MPE2 *)
				Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"] | Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],
					(* must be plate, have the same number of wells and aspect ratios. we will ignore the height for now *)
					Which[
						(* MPE2 lower tray has waste suction *)
						Not[collectionSwitch], {Null, False},
						Not[MatchQ[suppliedContainerModel, Automatic]] && speCheckTopBottomPlateQ[downloadedstuff, suppliedCartridge, suppliedContainerModel], {suppliedContainer, False},
						speCheckTopBottomPlateQ[downloadedstuff, suppliedCartridge, defaultContainer], {defaultContainer, False},
						True, {speGetBestPlate[downloadedstuff, suppliedCartridge], True}
					],

				ObjectP[{Model[Instrument, Centrifuge], Model[Instrument, FilterBlock]}],
					(* for all centrifuge you need a collection plate no matter what *)
					Which[
							Not[collectionSwitch] || (collectionSwitch && MatchQ[suppliedContainerModel, Automatic]) && MatchQ[filtrateVolume, Except[Null | {Null..}]], {defaultContainer, False},
							Not[collectionSwitch] || (collectionSwitch && MatchQ[suppliedContainerModel, Automatic]), {Null, False},
							speCheckTopBottomPlateQ[downloadedstuff, suppliedCartridge, suppliedContainerModel], {suppliedContainer, False},
							speCheckTopBottomPlateQ[downloadedstuff, suppliedCartridge, defaultContainer], {defaultContainer, False},
							True, {speGetBestPlate[downloadedstuff, suppliedCartridge], True}
						],

				Model[Instrument, SyringePump, "id:GmzlKjPzN9l4"],
					Switch[{collectionSwitch, suppliedContainerModel},

						{_, Except[Automatic|Null]},
							(* check if max volume can take it or not *)
							maxContainerVolume = cacheLookup[downloadedstuff, suppliedContainerModel, MaxVolume];
							If[MatchQ[filtrateVolume, GreaterP[maxContainerVolume]],

								(* if the volume go over the supplied container, we will pick better one *)
								{PreferredContainer[filtrateVolume], True},

								(* otherwise just return it *)
								{suppliedContainer, False}
							],

						{False, _},
							{Null, False},

						{True, Automatic},
							{PreferredContainer[filtrateVolume], False}
					]
			]
		),
		(* if the solution was not used *)
		{Null, False}
	];

	(* check how many containers we actually need *)
	containerOutModel = If[MatchQ[containerOut, ObjectP[Object]],
		cacheLookup[downloadedstuff, containerOut, Model],
		containerOut
	];
	maxContainerModelVolume = If[Not[MatchQ[containerOutModel, Null]],
		cacheLookup[downloadedstuff, containerOutModel, MaxVolume],
		Null
	];
	(* if its just a waste container, set the number of container to 1*)
	numberOfContainer = If[Not[MatchQ[containerOut, Null]],
		Ceiling[filtrateVolume / maxContainerModelVolume],
		1
	];

	(* speContainerResolver output *)
	{containerOut, warningUnsupportedContainer, numberOfContainer}


];
(* ::Subsection::Closed:: *)
(* speGetBestPlate *)
(* find the best plate that has the same number of wells as the top plate *)
speGetBestPlate[downloadedstuff_, topplate_] := Module[
	(* internal variables *)
	{topplatePacket, bestFitPlate, bestFitPlateSort},

	(* we have to find plate that has the same number of wells as the cartridge *)
	topplatePacket = fetchPacketFromCache[topplate, downloadedstuff];
	bestFitPlate = Cases[downloadedstuff, KeyValuePattern[{NumberOfWells -> Lookup[topplatePacket, NumberOfWells], Type -> Model[Container, Plate]}]];
	(* sort to get deepest plate *)
	bestFitPlateSort = SortBy[bestFitPlate, Lookup[#, Dimensions][[3]]&];
	(* then pick the name of the model *)
	Lookup[Last[bestFitPlateSort], Object]
];
(* ::Subsection::Closed:: *)
(* speCheckTopBottomPlateQ *)
(* check if top and bottom plate and sit on top of each other *)
speCheckTopBottomPlateQ[downloadedstuff_, topplate_, bottomplate_] := Module[
	(* internal variable *)
	{topplatePacket, bottomplatePacket},

	topplatePacket = fetchPacketFromCache[topplate, downloadedstuff];
	bottomplatePacket = fetchPacketFromCache[bottomplate, downloadedstuff];
	AllTrue[{
		(* 1) equal number of rows and column *)
		MatchQ[Lookup[topplatePacket, {Rows, Columns}], Lookup[bottomplatePacket, {Rows, Columns}]],
		(* 2) equal number of wells *)
		MatchQ[Lookup[topplatePacket, {NumberOfWells}], Lookup[bottomplatePacket, {NumberOfWells}]],
		(* 3) footprint is plate, or at least dimension fit with SBS standard *)
		MatchQ[Lookup[bottomplatePacket, Footprint], Plate] || MatchQ[Lookup[bottomplatePacket, Dimensions][[1 ;; 2]], {RangeP[125.76 Millimeter, 129.76 Millimeter], RangeP[83.98 Millimeter, 87.98 Millimeter]}],
		(* 4) must be a container plate, not filter other other things that got thrown into Model[Container,Plate] subtype *)
		MatchQ[Lookup[bottomplatePacket, Type], Model[Container, Plate]]}
		, TrueQ]
];
(* ::Subsection::Closed:: *)
(* speRepool *)
speRepool[listToRepool_List, indexToRepool_List] := Module[
	{cumIndex, takeIndex},
	cumIndex = Accumulate[indexToRepool];
	takeIndex = Transpose[{indexToRepool, cumIndex}];
	Map[Take[listToRepool, {#[[2]] - #[[1]] + 1, #[[2]]}]&, takeIndex]
];
(* ::Subsection::Closed:: *)
(* speAssignWellAndContainerNumber *)
speAssignWellAndContainerNumber[pooledSamples_List, containerOutList_List, groupingParameter_List, labelPrefix_String, cache_] := Module[
	{currentContainer, currentContainerModel, wellPositions, numberOfWells, nSamples,
		tooManySamplesOutForContainerOutError, wellNameForSample, plateNumberForSample, batchedContainerOut, batchedContainerOutDetails, containerLabel,
		numberOfPlates, fullWellList, fullPlateNumberList, plateLabel, plateUniqueID, unorderedContainerIndex, originalIndex, orderedContainerIndex, pooledSamplesIndex, containerOut,
		wellName, plateNumber, tooManySampleOutError, maxNumberOfWells, numberOfSampleOut, InstrumentError, containerObject, containerObjectLabel, sampleOrderID, errorContainerOutOutput,
		uniqueContainerObject, groupingParameterRules, groupingParameterKeys},
	(* first we have to batch container together, based on the instrument and the container itself *)
	groupingParameterKeys = Table[ToExpression["groupingKeys" <> ToString[n]], {n, Length[groupingParameter]}];
	groupingParameterRules = MapThread[#1 -> #2&, {groupingParameterKeys, groupingParameter}];
	batchedContainerOut = Experiment`Private`groupByKey[
		Flatten[{{pooledSamplesIndex -> Range[Length[pooledSamples]], containerOut -> containerOutList}, groupingParameterRules}],
		Flatten[{containerOut, groupingParameterKeys}]
	];
	batchedContainerOutDetails = Map[Function[{containerOutInput},
		currentContainer = Lookup[containerOutInput[[1]], containerOut];
		currentContainerModel = If[MatchQ[currentContainer, ObjectP[Object]],
			Experiment`Private`cacheLookup[cache, currentContainer, Model],
			currentContainer
		];
		wellPositions = If[MatchQ[currentContainerModel, ObjectP[]],
			List @@ Experiment`Private`cacheLookup[cache, currentContainerModel, AllowedPositions],
			Null
		];
		numberOfWells = Length[wellPositions];
		nSamples = Length[Lookup[containerOutInput[[2]], pooledSamplesIndex]];
		(* trigger error first, this is only true for Object, if plate is a model we can keep adding *)
		tooManySamplesOutForContainerOutError = If[
			(MatchQ[currentContainer, ObjectP[Object]] && nSamples > numberOfWells),
			True,
			False
		];
		(* now we assign well, and plate number *)
		{wellNameForSample, plateNumberForSample, containerLabel} = If[MatchQ[currentContainerModel, ObjectP[Model]],
			(
				(* check how many containers we have to use *)
				numberOfPlates = Ceiling[nSamples / (numberOfWells /. 0 -> 1)];
				(* assign well and plate for each sample out *)
				fullWellList = Flatten[ConstantArray[wellPositions, numberOfPlates]];
				fullPlateNumberList = Flatten[Table[n * ConstantArray[1, numberOfWells], {n, numberOfPlates}]];
				plateUniqueID = Table[Unique[], numberOfPlates];
				plateLabel = MapThread[#1 <> ToString[plateUniqueID[[#2]]]&, {ConstantArray[labelPrefix, Length[fullWellList]], fullPlateNumberList}];
				{Take[fullWellList, nSamples], Take[fullPlateNumberList, nSamples], Take[plateLabel, nSamples]}
			),
			(
				ConstantArray[ConstantArray[Null, nSamples], 3]
			)
		];
		(* set output of map *)
		{
			wellName -> wellNameForSample,
			plateNumber -> plateNumberForSample,
			tooManySampleOutError -> tooManySamplesOutForContainerOutError,
			maxNumberOfWells -> numberOfWells,
			numberOfSampleOut -> nSamples,
			containerObject -> Lookup[containerOutInput[[2]], containerOut],
			uniqueContainerObject -> Lookup[containerOutInput[[1]], containerOut],
			containerObjectLabel -> containerLabel,
			sampleOrderID -> Lookup[containerOutInput[[2]], pooledSamplesIndex]
		}], batchedContainerOut
	];
	(* organize sampleout location in format of{wellname,containernumber,type of container, label} *)
	unorderedContainerIndex = Transpose[Map[Flatten[Lookup[batchedContainerOutDetails, #]]&, {wellName, plateNumber, containerObject, containerObjectLabel}]];
	errorContainerOutOutput = Transpose[Map[Lookup[batchedContainerOutDetails, #]&,
		{tooManySampleOutError, uniqueContainerObject, maxNumberOfWells, sampleOrderID}]];
	(* once we know the position and number of container we have to get, we will reorder it back to indexmatch with input sample *)
	originalIndex = Flatten[Lookup[batchedContainerOut[[;;, 2]], pooledSamplesIndex]];
	orderedContainerIndex = unorderedContainerIndex[[originalIndex]];
	(* output of speAssignWellAndContainerNumber function*)
	{orderedContainerIndex, errorContainerOutOutput}
];

speIndexMatchResource[resource_List, matchingKey_, valueToMatch_List, batchSize_] := Module[
	{resourcePatternToMatch, matchedResource},
	resourcePatternToMatch = Map[#[matchingKey]&, resource];
	matchedResource = Flatten[
		Map[
			If[Not[MatchQ[Null, #]],
				resource[[Flatten[Position[resourcePatternToMatch, #]]]],
				Null
			]&,
			Flatten[valueToMatch]
		]
	];
	(* expand to match the length of batch size*)
	Flatten[ConstantArray[matchedResource, batchSize]]
];
(* ::Subsection::Closed:: *)
(* speBatchCalculatorForGX271 *)
(* Subfunction to calculate batch for GX271 *)
speBatchCalculatorForGX271[myOptionsUsingGX271_List, cache_] := Module[
	{groupingParameters, cartridgeSize, quantitativeLoadingSampleSingle, optionsToBatch,
		groupedByGX271PhysicalProperties, updatedGX271Options, loadingSampleTemperatureSingle},

	cartridgeSize = Map[Experiment`Private`cacheLookup[cache, #, MaxVolume]&, Lookup[myOptionsUsingGX271, ExtractionCartridge]];
	(* we have to collapse pool options to single other wise, all pooled options will be group as different *)
	quantitativeLoadingSampleSingle = Flatten[Union /@ Lookup[myOptionsUsingGX271, QuantitativeLoadingSampleSolution]];
	loadingSampleTemperatureSingle = Flatten[Union /@ Lookup[myOptionsUsingGX271, LoadingSampleTemperature]];

	optionsToBatch = Join[
		myOptionsUsingGX271,
		{
			CartridgeSizeKey -> cartridgeSize,
			QuantitativeLoadingSampleSingle -> quantitativeLoadingSampleSingle,
			LoadingSampleTemperatureSingle -> loadingSampleTemperatureSingle
		}
	];
	groupingParameters = {
		Instrument,
		ExtractionMethod,
		ExtractionTemperature,
		PreFlushingSolution,
		PreFlushingSolutionTemperature,
		ConditioningSolution,
		ConditioningSolutionTemperature,
		(* these need to be single *)
		(*		QuantitativeLoadingSampleSolution,*)
		(*		LoadingSampleTemperature,*)
		WashingSolution,
		WashingSolutionTemperature,
		SecondaryWashingSolution,
		SecondaryWashingSolutionTemperature,
		TertiaryWashingSolution,
		TertiaryWashingSolutionTemperature,
		ElutingSolution,
		ElutingSolutionTemperature,
		PreFlushingSolutionCollectionContainer,
		ConditioningSolutionCollectionContainer,
		WashingSolutionCollectionContainer,
		SecondaryWashingSolutionCollectionContainer,
		TertiaryWashingSolutionCollectionContainer,
		ElutingSolutionCollectionContainer,
		LoadingSampleFlowthroughContainer,
		CartridgeSizeKey,
		QuantitativeLoadingSampleSingle,
		LoadingSampleTemperatureSingle,
		PreFlushingSolutionLabel,
		ConditioningSolutionLabel,
		WashingSolutionLabel,
		SecondaryWashingSolutionLabel,
		TertiaryWashingSolutionLabel,
		ElutingSolutionLabel
	};

	groupedByGX271PhysicalProperties = Experiment`Private`groupByKey[optionsToBatch, groupingParameters];

	updatedGX271Options = Map[
		Module[
			{batchID, cartridgeLocation, aliquotTargets, updatedOptions},

			{batchID, cartridgeLocation, aliquotTargets} = speSubBatchCalculatorForGX271[#, cache];
			(* return structure like group by key*)
			updatedOptions = Join[
				#[[2]],
				{
					SPEBatchID -> batchID,
					CartridgePlacement -> cartridgeLocation,
					AliquotTargets -> aliquotTargets
				}
			]
		]&,
		groupedByGX271PhysicalProperties
	];
	updatedGX271Options
];
(* ::Subsection::Closed:: *)
(* speSubBatchCalculatorForGX271 *)
speSubBatchCalculatorForGX271[subGroupedOptions_List, cache_] := Module[
	(* this is recursive part to check for buffer, plate, and number of cartridge whther it can be run in the same batch or not *)
	{originalSampleIndex, poolLength, currentIndexNumber, priWashSolution, secWashSolution, terWashSolution, allBatchBool, allBatchLabel, cartridgePosition, aliquotPosition, compileBatchLabel,
		batchByCartridge, batchByInputPlate, aliquotTarget, batchByPreFlushingSolution, batchByConditioningSolution, batchByElutingSolution, batchByWashingSolution, batchBySecondaryWashingSolution, batchByTertiaryWashingSolution,
		allBatchIdentifier, compileAliquotTarget, compileCartridgePosition},
	(* this is the original pooled sample index from user *)
	originalSampleIndex = Lookup[subGroupedOptions[[2]], SamplesIndex];
	(* be cause we have to flatten all the pool out, this is to preserve the pool so that we can go back and forth *)
	poolLength = Length /@ originalSampleIndex;
	(* current index number -> because this functyion is recurive, this parameter is to keep track if all the sample are assign batch already or not *)
	currentIndexNumber = Table[n, {n, Length[Lookup[subGroupedOptions[[2]], Samples]]}];
	priWashSolution = Lookup[subGroupedOptions[[1]], WashingSolution];
	secWashSolution = Lookup[subGroupedOptions[[1]], SecondaryWashingSolution];
	terWashSolution = Lookup[subGroupedOptions[[1]], TertiaryWashingSolution];
	(* preassign batch label *)
	compileBatchLabel = {}; compileCartridgePosition = {}; compileAliquotTarget = {};
	(* recursively batch until we run out of samples *)
	While[
		Length[currentIndexNumber] > 0,
		(
			{batchByCartridge, cartridgePosition} = speGX271BatchByCartridge[subGroupedOptions, currentIndexNumber];
			{batchByInputPlate, aliquotTarget} = speGX271BatchByInputPlate[subGroupedOptions, currentIndexNumber, cache];
			batchByPreFlushingSolution = speGX271BatchBySolutionSmall[subGroupedOptions, PreFlushingSolutionVolume, currentIndexNumber];
			batchByConditioningSolution = speGX271BatchBySolutionSmall[subGroupedOptions, ConditioningSolutionVolume, currentIndexNumber];
			batchByElutingSolution = speGX271BatchBySolutionSmall[subGroupedOptions, ElutingSolutionVolume, currentIndexNumber];
			batchByWashingSolution = speGX271BatchBySolutionBig[subGroupedOptions, currentIndexNumber];
			batchBySecondaryWashingSolution = If[Not[MatchQ[secWashSolution, ObjectP[priWashSolution]]] && Not[NullQ[secWashSolution]],
				speGX271BatchBySolutionSmall[subGroupedOptions, SecondaryWashingSolutionVolume, currentIndexNumber],
				ConstantArray[1, Length[currentIndexNumber]]
			];
			batchByTertiaryWashingSolution = If[Not[MatchQ[terWashSolution, ObjectP[priWashSolution]]] && Not[NullQ[terWashSolution]],
				speGX271BatchBySolutionSmall[subGroupedOptions, TertiaryWashingSolutionVolume, currentIndexNumber],
				ConstantArray[1, Length[currentIndexNumber]]
			];
			allBatchIdentifier = Transpose[{
				batchByCartridge,
				batchByInputPlate,
				batchByPreFlushingSolution,
				batchByConditioningSolution,
				batchByElutingSolution,
				batchByWashingSolution,
				batchBySecondaryWashingSolution,
				batchByTertiaryWashingSolution}];
			allBatchBool = Map[MatchQ[#, {1...}]&, allBatchIdentifier];
			allBatchLabel = PickList[allBatchBool /. True -> ("SPE batch " <> ToString[Unique[]]), allBatchBool];
			(* append all the output we will use further *)
			compileBatchLabel = Append[compileBatchLabel, allBatchLabel];
			compileCartridgePosition = Append[compileCartridgePosition, PickList[cartridgePosition, allBatchBool]];
			compileAliquotTarget = Append[compileAliquotTarget, PickList[aliquotTarget, allBatchBool]];
			(* reset loop condition *)
			(* if we're in an infinite loop, just break out *)
			If[currentIndexNumber === PickList[currentIndexNumber, Not /@ allBatchBool],
				Break[],
				currentIndexNumber = PickList[currentIndexNumber, Not /@ allBatchBool]
			];
		)
	];
	(* output *)
	(* flat to return the same strueture as input *)
	Map[Flatten[#, 1]&, {compileBatchLabel, compileCartridgePosition, compileAliquotTarget}]
];
(* ::Subsection::Closed:: *)
(* speGX271BatchByCartridge *)
speGX271BatchByCartridge[mycurrentoptions_, sampleID_] := Module[
	{cartridgeSizeValue, threeCCLocations, sixCCLocations, maxCartridgeNumber, possibleCartridgeLocation, cartridgeCountPerSample, batchNumber, cartridgePosition},
	(* predefine cartridge location *)
	cartridgeSizeValue = Lookup[mycurrentoptions[[1]], CartridgeSizeKey];
	threeCCLocations = Flatten[Table[{1, 2, 3, 4, 5, 6} + (i - 1), {i, 1, 48, 12}]];
	sixCCLocations = Flatten[Table[{1, 2, 3, 4, 5} + (i - 1), {i, 1, 20, 5}]];

	{maxCartridgeNumber, possibleCartridgeLocation} = Switch[cartridgeSizeValue,

		6. Milliliter,
		{20, sixCCLocations},

		3. Milliliter,
		{48, threeCCLocations}

	];
	cartridgeCountPerSample = Table[n, {n, Length[sampleID]}];
	(* give batch number that index match with sampleID *)
	batchNumber = Ceiling[cartridgeCountPerSample / maxCartridgeNumber];
	(* get the assigned cartridge position *)
	cartridgePosition = Take[Flatten[ConstantArray[possibleCartridgeLocation, Max[batchNumber]]], Length[sampleID]];
	(* output *)
	{batchNumber, cartridgePosition}
];
(* ::Subsection::Closed:: *)
(* speGX271BatchByInputPlate *)
speGX271BatchByInputPlate[mycurrentoptions_, sampleID_, cache_] := Module[
	{currentSamples, currentPoolLength, currentFlatSamples, currentSampleContainer, currentSampleContainerModel, gx271SupportQ, samePlateQ, maxWellVolume,
		maxWellNumber, eachSampleVolume, wellsNeeededEachSample, wellsNumberEachSample, plateNumber, repoolPlateNumber, batchByPlate, exactWellsNeededEachSample,
		allWellPositions, expandedAllWellPositions, wellToAliquot, volumeToAliquot, plateNumberToUniqueLabel, plateToAliquotID, typeOfPlate, aliquotDetails, aliquotDetailsRepool},
	(* it's very likely that we have to aliquot each sample into a new plate so, check if we go above 2 plates or not *)
	(* 1 - check if all sample is in plate or not, and if they do are they in the same plate *)
	(* 1.1 act as if you have to move everything *)
	(* unpool everything *)
	currentSamples = Lookup[mycurrentoptions[[2]], Samples][[sampleID]];
	currentFlatSamples = Flatten[currentSamples];
	eachSampleVolume = Flatten[Lookup[mycurrentoptions[[2]], LoadingSampleVolume][[sampleID]]];
	(* keep track of the pool*)
	currentPoolLength = Length /@ currentSamples;
	(* get container info *)
	currentSampleContainer = Map[Experiment`Private`cacheLookup[cache, #, Container]&, currentFlatSamples];
	currentSampleContainerModel = Map[Experiment`Private`cacheLookup[cache, #, Model]&, currentSampleContainer];


	(* are theses samples in the same container or not *)
	samePlateQ = If[Length[DeleteDuplicates[currentSampleContainer]] > 1, False, True];

	(* TODO this is terrible but if samples are not in the same container and that container are not supported by GX271,
	we move them all to a new plate, even if they are prepared plate *)
	maxWellVolume = Experiment`Private`cacheLookup[cache, Model[Container, Plate, "96-well 2mL Deep Well Plate"], MaxVolume];
	maxWellNumber = Experiment`Private`cacheLookup[cache, Model[Container, Plate, "96-well 2mL Deep Well Plate"], NumberOfWells];

	(* theoretically check how many plate that we need to run this experiment *)
	(* check the volume of each sample and divide that by max volume of the well, to determine how many wells we will need to aliquot *)
	exactWellsNeededEachSample = eachSampleVolume / maxWellVolume;
	wellsNeeededEachSample = Ceiling /@ exactWellsNeededEachSample;
	wellsNumberEachSample = Map[Table[n, {n, #}]&, wellsNeeededEachSample] + Drop[Join[{0}, Accumulate[Flatten[wellsNeeededEachSample]]], -1];
	plateNumber = Map[Max, Ceiling[wellsNumberEachSample / maxWellNumber]];
	repoolPlateNumber = Map[Max, Experiment`Private`speRepool[plateNumber, currentPoolLength]];
	(* we can take only 2 plates at a time *)
	batchByPlate = Ceiling[repoolPlateNumber / 2];

	(* get the well position for aliquot too *)
	allWellPositions = Experiment`Private`cacheLookup[cache, Model[Container, Plate, "96-well 2mL Deep Well Plate"], AllowedPositions];
	expandedAllWellPositions = Flatten[ConstantArray[List @@ allWellPositions, Max[plateNumber]]];
	wellToAliquot = Experiment`Private`speRepool[Take[expandedAllWellPositions, Total[wellsNeeededEachSample]], wellsNeeededEachSample];
	volumeToAliquot = Map[(Join[ConstantArray[1, Floor[#]], {Mod[#, 1]}] /. 0. -> Nothing) &, exactWellsNeededEachSample] * maxWellVolume;
	plateNumberToUniqueLabel = Table[n -> ("Target Container " <> ToString[Unique[]]), {n, Max[plateNumber]}];
	plateToAliquotID = MapThread[ConstantArray[#1, #2]&, {plateNumber /. plateNumberToUniqueLabel, wellsNeeededEachSample}];
	typeOfPlate = Experiment`Private`speRepool[ConstantArray[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Total[wellsNeeededEachSample]], wellsNeeededEachSample];
	(* compile aliquote details {well,volumeToAliquot,plateID,typeOfPlate,}*)
	aliquotDetails = Map[Transpose, Transpose[{wellToAliquot, volumeToAliquot, plateToAliquotID, typeOfPlate}]];
	(* repool for the last time to index match with input samples *)
	aliquotDetailsRepool = Experiment`Private`speRepool[aliquotDetails, currentPoolLength];
	(* output *)
	{batchByPlate, aliquotDetailsRepool}
];
(* ::Subsection::Closed:: *)
(* speGX271BatchBySolutionSmall *)
speGX271BatchBySolutionSmall[mycurrentoptions_, currentBuffer_, sampleID_] := Module[
	{currentBufferVolume, accumulatedBufferVolume, maxBufferVolume, batchByVolume},
	currentBufferVolume = Lookup[mycurrentoptions[[2]], currentBuffer][[sampleID]] /. Null -> 0 Milliliter;
	accumulatedBufferVolume = Accumulate[currentBufferVolume];
	maxBufferVolume = 500 Milliliter;
	batchByVolume = Ceiling[accumulatedBufferVolume / maxBufferVolume];
	(* if the buffer is not use, then volume will be 0, which will cause the batch calculator to stuck in while loop because of 0, so we have to change that here *)
	batchByVolume /. {0 -> 1}
];
(* ::Subsection::Closed:: *)
(* speGX271BatchBySolutionBig *)
speGX271BatchBySolutionBig[mycurrentoptions_, sampleID_] := Module[
	{accumulatedBufferVolume, maxBufferVolume, batchByVolume, currentWashBufferVolume,
		currentSecWashBufferVolume, currentTerWashBufferVolume, currentWashBuffer,
		currentSecWashBuffer, currentTerWashBuffer, sameSec, sameTer, allWashBufferVolume},
	(* we force wash buffer to go to big tank *)
	currentWashBufferVolume = Lookup[mycurrentoptions[[2]], WashingSolutionVolume][[sampleID]] /. Null -> 0 Milliliter;
	currentSecWashBufferVolume = Lookup[mycurrentoptions[[2]], SecondaryWashingSolutionVolume][[sampleID]] /. Null -> 0 Milliliter;
	currentTerWashBufferVolume = Lookup[mycurrentoptions[[2]], TertiaryWashingSolutionVolume][[sampleID]] /. Null -> 0 Milliliter;
	(* check the type of buffer, if any of them are the same put them together *)
	currentWashBuffer = Lookup[mycurrentoptions[[1]], WashingSolution];
	currentSecWashBuffer = Lookup[mycurrentoptions[[1]], SecondaryWashingSolution];
	currentTerWashBuffer = Lookup[mycurrentoptions[[1]], TertiaryWashingSolution];
	(* are we useing the same buffer, if we do we merge the volume together *)
	sameSec = If[MatchQ[currentWashBuffer, currentSecWashBuffer] && Not[NullQ[currentWashBuffer]], True, False];
	sameTer = If[MatchQ[currentWashBuffer, currentTerWashBuffer] && Not[NullQ[currentWashBuffer]], True, False];
	allWashBufferVolume = Flatten[Total /@ Transpose[PickList[{currentWashBufferVolume, currentSecWashBufferVolume, currentTerWashBufferVolume}, Flatten[{True, sameSec, sameTer}]]]];
	accumulatedBufferVolume = Accumulate[allWashBufferVolume];
	maxBufferVolume = 10000 Milliliter;
	batchByVolume = Ceiling[accumulatedBufferVolume / maxBufferVolume];
	(* if the buffer is not use, then volume will be 0, which will cause the batch calculator to stuck in while loop because of 0, so we have to change that here *)
	batchByVolume /. {0 -> 1}
];
(* ::Subsection::Closed:: *)
(* speBatchCalculatorCentrifugePlateManual *)
(* Subfunction to calculate batch for any manual centrifuge that take plates *)
speBatchCalculatorCentrifugePlateManual[myOptionForPlateCentrifuge_List, cache_] := Module[
	{groupingParameters,
		quantitativeLoadingSampleSingle,
		loadingSampleTemperatureSingle,
		optionsToBatch,
		groupedByPhysicalProperties,
		updatedCentrifugeManualOptions,
		nSample
	},

	(* we have to collapse pool options to single other wise, all pooled options will be group as different *)
	quantitativeLoadingSampleSingle = Flatten[Union /@ Lookup[myOptionForPlateCentrifuge, QuantitativeLoadingSampleSolution]];
	loadingSampleTemperatureSingle = Flatten[Union /@ Lookup[myOptionForPlateCentrifuge, LoadingSampleTemperature]];
	nSample = Length[Lookup[myOptionForPlateCentrifuge, Samples]];

	optionsToBatch = Join[
		myOptionForPlateCentrifuge,
		{
			CartridgeSizeKey -> ConstantArray[Null, nSample],
			QuantitativeLoadingSampleSingle -> quantitativeLoadingSampleSingle,
			LoadingSampleTemperatureSingle -> loadingSampleTemperatureSingle
		}
	];

	(* what kind of plate *)
	groupingParameters = {
		Instrument,
		ExtractionCartridge,
		ExtractionTemperature,
		PreFlushingSolutionTemperature,
		ConditioningSolutionTemperature,
		WashingSolutionTemperature,
		SecondaryWashingSolutionTemperature,
		TertiaryWashingSolutionTemperature,
		ElutingSolutionTemperature,
		PreFlushingSolutionCollectionContainer,
		ConditioningSolutionCollectionContainer,
		WashingSolutionCollectionContainer,
		SecondaryWashingSolutionCollectionContainer,
		TertiaryWashingSolutionCollectionContainer,
		ElutingSolutionCollectionContainer,
		LoadingSampleFlowthroughContainer,
		QuantitativeLoadingSampleSingle,
		LoadingSampleTemperatureSingle,
		PreFlushingSolutionCentrifugeIntensity,
		ConditioningSolutionCentrifugeIntensity,
		WashingSolutionCentrifugeIntensity,
		SecondaryWashingSolutionCentrifugeIntensity,
		TertiaryWashingSolutionCentrifugeIntensity,
		ElutingSolutionCentrifugeIntensity,
		LoadingSampleCentrifugeIntensity,
		PreFlushingSolutionDrainTime,
		ConditioningSolutionDrainTime,
		WashingSolutionDrainTime,
		SecondaryWashingSolutionDrainTime,
		TertiaryWashingSolutionDrainTime,
		ElutingSolutionDrainTime,
		LoadingSampleDrainTime,
		PreFlushingSolution,
		ConditioningSolution,
		WashingSolution,
		SecondaryWashingSolution,
		TertiaryWashingSolution,
		ElutingSolution
	};

	groupedByPhysicalProperties = Experiment`Private`groupByKey[optionsToBatch, groupingParameters];

	updatedCentrifugeManualOptions = Map[
		Function[{myBatchedOptions},
			Module[
				{filter, filterModel, batchID, singleOptions, indexMatchedOptions, nWellsOfCartridge, samples, intraLoopSampleNumber,
					batchNumberPerSample, batchNumberPerSampleUnique, batchNumberToBatchLabelRules, wellPositionOfPlates,
					expandedWellPositionsOfPlates, sampleMatchedWellPositionOfPlates, updatedOptions, maxPlatePerCentrifuge, flatSamples,
					aliquotTargetsFlat, aliquotTargetsPooled, poolLength},
				(* make life easy here, by calling all the options that grouped into a single value *)
				singleOptions = myBatchedOptions[[1]];
				indexMatchedOptions = myBatchedOptions[[2]];
				(* the only thing we have to add here is that we can only run number samples as much as there are wells in the filter *)
				filter = Lookup[singleOptions, ExtractionCartridge];
				filterModel = If[MatchQ[filter, ObjectReferenceP[Object]],
					Experiment`Private`cacheLookup[cache, filter, Model],
					filter
				];
				(* this is hard code, but swing arms can take up to 4 plates *)
				maxPlatePerCentrifuge = 1;
				nWellsOfCartridge = Experiment`Private`cacheLookup[cache, filterModel, NumberOfWells];
				wellPositionOfPlates = List @@ Experiment`Private`cacheLookup[cache, filterModel, AllowedPositions];
				samples = Lookup[indexMatchedOptions, Samples];
				intraLoopSampleNumber = Table[n, {n, Length[samples]}];
				batchNumberPerSample = Ceiling[intraLoopSampleNumber / (nWellsOfCartridge * maxPlatePerCentrifuge)];
				expandedWellPositionsOfPlates = Flatten[ConstantArray[wellPositionOfPlates, (Max[batchNumberPerSample] * maxPlatePerCentrifuge)]];
				sampleMatchedWellPositionOfPlates = Take[expandedWellPositionsOfPlates, Length[samples]];
				batchNumberPerSampleUnique = DeleteDuplicates[batchNumberPerSample];
				batchNumberToBatchLabelRules = Map[
					(# -> "SPE batch " <> ToString[Unique[]])
						&, batchNumberPerSampleUnique
				];
				(* return batchID for each sample *)
				batchID = batchNumberPerSample /. batchNumberToBatchLabelRules;
				(* there is no need for aliquoting *)
				poolLength = Map[Length[#]&, samples];
				flatSamples = Flatten[samples];
				aliquotTargetsFlat = Map[Null&, flatSamples];
				aliquotTargetsPooled = TakeList[aliquotTargetsFlat, poolLength];
				(* for plate SPE, cartridge placement is actually the well that each sample will go into *)
				updatedOptions = Join[
					indexMatchedOptions,
					{
						SPEBatchID -> batchID,
						CartridgePlacement -> sampleMatchedWellPositionOfPlates,
						(* this follow aliquot for GX271 *)
						AliquotTargets -> aliquotTargetsPooled
					}
				];
				(* output of map *)
				updatedOptions
			]
		],
		groupedByPhysicalProperties
	];

	(* output of batch calculator *)
	updatedCentrifugeManualOptions
];
(* ::Subsection::Closed:: *)
(* speBatchCalculatorFilterBlockManual *)
(* Subfunction to calculate batch for any manual centrifuge that take plates *)
speBatchCalculatorFilterBlockManual[myOptionForPlateCentrifuge_List, cache_] := Module[
	{groupingParameters,
		quantitativeLoadingSampleSingle,
		loadingSampleTemperatureSingle,
		optionsToBatch,
		groupedByPhysicalProperties,
		updatedFilterBlockOptions,
		nSample
	},

	(* we have to collapse pool options to single other wise, all pooled options will be group as different *)
	quantitativeLoadingSampleSingle = Flatten[Union /@ Lookup[myOptionForPlateCentrifuge, QuantitativeLoadingSampleSolution]];
	loadingSampleTemperatureSingle = Flatten[Union /@ Lookup[myOptionForPlateCentrifuge, LoadingSampleTemperature]];
	nSample = Length[Lookup[myOptionForPlateCentrifuge, Samples]];

	optionsToBatch = Join[
		myOptionForPlateCentrifuge,
		{
			CartridgeSizeKey -> ConstantArray[Null, nSample],
			QuantitativeLoadingSampleSingle -> quantitativeLoadingSampleSingle,
			LoadingSampleTemperatureSingle -> loadingSampleTemperatureSingle
		}
	];

	(* what kind of plate *)
	groupingParameters = {
		Instrument,
		ExtractionCartridge,
		ExtractionTemperature,
		PreFlushingSolutionTemperature,
		ConditioningSolutionTemperature,
		WashingSolutionTemperature,
		SecondaryWashingSolutionTemperature,
		TertiaryWashingSolutionTemperature,
		ElutingSolutionTemperature,
		PreFlushingSolutionCollectionContainer,
		ConditioningSolutionCollectionContainer,
		WashingSolutionCollectionContainer,
		SecondaryWashingSolutionCollectionContainer,
		TertiaryWashingSolutionCollectionContainer,
		ElutingSolutionCollectionContainer,
		LoadingSampleFlowthroughContainer,
		QuantitativeLoadingSampleSingle,
		LoadingSampleTemperatureSingle,
		PreFlushingSolutionPressure,
		ConditioningSolutionPressure,
		WashingSolutionPressure,
		SecondaryWashingSolutionPressure,
		TertiaryWashingSolutionPressure,
		ElutingSolutionPressure,
		LoadingSamplePressure,
		PreFlushingSolutionDrainTime,
		ConditioningSolutionDrainTime,
		WashingSolutionDrainTime,
		SecondaryWashingSolutionDrainTime,
		TertiaryWashingSolutionDrainTime,
		ElutingSolutionDrainTime,
		LoadingSampleDrainTime,
		PreFlushingSolution,
		ConditioningSolution,
		WashingSolution,
		SecondaryWashingSolution,
		TertiaryWashingSolution,
		ElutingSolution
	};

	groupedByPhysicalProperties = Experiment`Private`groupByKey[optionsToBatch, groupingParameters];

	updatedFilterBlockOptions = Map[
		Function[{myBatchedOptions},
			Module[
				{filter, filterModel, batchID, singleOptions, indexMatchedOptions, nWellsOfCartridge, samples, intraLoopSampleNumber,
					batchNumberPerSample, batchNumberPerSampleUnique, batchNumberToBatchLabelRules, wellPositionOfPlates,
					expandedWellPositionsOfPlates, sampleMatchedWellPositionOfPlates, updatedOptions, maxPlatePerCentrifuge, flatSamples,
					aliquotTargetsFlat, aliquotTargetsPooled, poolLength},
				(* make life easy here, by calling all the options that grouped into a single value *)
				singleOptions = myBatchedOptions[[1]];
				indexMatchedOptions = myBatchedOptions[[2]];
				(* the only thing we have to add here is that we can only run number samples as much as there are wells in the filter *)
				filter = Lookup[singleOptions, ExtractionCartridge];
				filterModel = If[MatchQ[filter, ObjectReferenceP[Object]],
					Experiment`Private`cacheLookup[cache, filter, Model],
					filter
				];
				(* this is hard code, but swing arms can take up to 4 plates *)
				maxPlatePerCentrifuge = 1;
				nWellsOfCartridge = Experiment`Private`cacheLookup[cache, filterModel, NumberOfWells];
				wellPositionOfPlates = List @@ Experiment`Private`cacheLookup[cache, filterModel, AllowedPositions];
				samples = Lookup[indexMatchedOptions, Samples];
				intraLoopSampleNumber = Table[n, {n, Length[samples]}];
				batchNumberPerSample = Ceiling[intraLoopSampleNumber / (nWellsOfCartridge * maxPlatePerCentrifuge)];
				expandedWellPositionsOfPlates = Flatten[ConstantArray[wellPositionOfPlates, (Max[batchNumberPerSample] * maxPlatePerCentrifuge)]];
				sampleMatchedWellPositionOfPlates = Take[expandedWellPositionsOfPlates, Length[samples]];
				batchNumberPerSampleUnique = DeleteDuplicates[batchNumberPerSample];
				batchNumberToBatchLabelRules = Map[
					(# -> "SPE batch " <> ToString[Unique[]])
						&, batchNumberPerSampleUnique
				];
				(* return batchID for each sample *)
				batchID = batchNumberPerSample /. batchNumberToBatchLabelRules;
				(* there is no need for aliquoting *)
				poolLength = Map[Length[#]&, samples];
				flatSamples = Flatten[samples];
				aliquotTargetsFlat = Map[Null&, flatSamples];
				aliquotTargetsPooled = TakeList[aliquotTargetsFlat, poolLength];
				(* for plate SPE, cartridge placement is actually the well that each sample will go into *)
				updatedOptions = Join[
					indexMatchedOptions,
					{
						SPEBatchID -> batchID,
						CartridgePlacement -> sampleMatchedWellPositionOfPlates,
						(* this follow aliquot for GX271 *)
						AliquotTargets -> aliquotTargetsPooled
					}
				];
				(* output of map *)
				updatedOptions
			]
		],
		groupedByPhysicalProperties
	];

	(* output of batch calculator *)
	updatedFilterBlockOptions
];
(* ::Subsection::Closed:: *)
(* speBatchCalculatorSyringePumpOne *)
(* Subfunction to calculate batch for SynringePump one head *)
speBatchCalculatorSyringePumpOne[myOptionForSyringePump_List, cache_] := Module[
	{samples, batchID, updatedOptions, poolLength , aliquotTargetsFlat, flatSamples, aliquotTargetsPooled},

	(* This one is easy, just go sample one by one, there is no physical constrain here *)
	samples = Lookup[myOptionForSyringePump, Samples];
	poolLength = Map[Length[#]&, samples];
	flatSamples = Flatten[samples];
	batchID = Table["SPE batch " <> ToString[Unique[]], Length[samples]];
	aliquotTargetsFlat = Map[Null&, flatSamples];
	aliquotTargetsPooled = TakeList[aliquotTargetsFlat, poolLength];
	(* for plate SPE, cartridge placement is actually the well that each sample will go into *)
	updatedOptions = Join[
		myOptionForSyringePump,
		{
			SPEBatchID -> batchID,
			CartridgePlacement -> ConstantArray["A1", Length[samples]],
			(* this follow aliquot for GX271, there is no aliquot for anything manual *)
			AliquotTargets -> aliquotTargetsPooled,
			CartridgeSize -> Table[Null, Length[batchID]]
		}
	];
	(* output of batchcalculator *)
	updatedOptions
];

speBatchCalculatorForBiotage48[myOptionsUsingBiotage48_List, cache_] := Module[
	{groupingParameters, cartridgeSize, quantitativeLoadingSampleSingle, optionsToBatch,
		loadingSampleTemperatureSingle, groupedByBiotage48PhysicalProperties,
		maxNumberOfCartridge, maxVolumeInWaste, solutionsVolumeOptions,
		solutionCollectionOptions, updatedBiotageOptions},

	cartridgeSize = Map[Experiment`Private`cacheLookup[cache, #, MaxVolume]&, Lookup[myOptionsUsingBiotage48, ExtractionCartridge]];
	(* we have to collapse pool options to single other wise, all pooled options will be group as different *)
	quantitativeLoadingSampleSingle = Flatten[Union /@ Lookup[myOptionsUsingBiotage48, QuantitativeLoadingSampleSolution]];
	loadingSampleTemperatureSingle = Flatten[Union /@ Lookup[myOptionsUsingBiotage48, LoadingSampleTemperature]];

	optionsToBatch = Join[
		myOptionsUsingBiotage48,
		{
			CartridgeSizeKey -> cartridgeSize,
			QuantitativeLoadingSampleSingle -> quantitativeLoadingSampleSingle,
			LoadingSampleTemperatureSingle -> loadingSampleTemperatureSingle
		}
	];
	groupingParameters = {
		Instrument,
		CartridgeSizeKey,

		CollectPreFlushingSolution,
		CollectConditioningSolution,
		CollectWashingSolution,
		CollectSecondaryWashingSolution,
		CollectTertiaryWashingSolution,
		CollectElutingSolution,
		CollectLoadingSampleFlowthrough,

		PreFlushingSolutionPressure,
		ConditioningSolutionPressure,
		WashingSolutionPressure,
		SecondaryWashingSolutionPressure,
		TertiaryWashingSolutionPressure,
		ElutingSolutionPressure,
		LoadingSamplePressure,

		PreFlushingSolutionDispenseRate,
		ConditioningSolutionDispenseRate,
		WashingSolutionDispenseRate,
		SecondaryWashingSolutionDispenseRate,
		TertiaryWashingSolutionDispenseRate,
		ElutingSolutionDispenseRate,
		LoadingSampleDispenseRate,

		PreFlushingSolutionPressure,
		ConditioningSolutionPressure,
		WashingSolutionPressure,
		SecondaryWashingSolutionPressure,
		TertiaryWashingSolutionPressure,
		ElutingSolutionPressure,
		LoadingSamplePressure,

		PreFlushingSolutionDrainTime,
		ConditioningSolutionDrainTime,
		WashingSolutionDrainTime,
		SecondaryWashingSolutionDrainTime,
		TertiaryWashingSolutionDrainTime,
		ElutingSolutionDrainTime,
		LoadingSampleDrainTime,

		MaxPreFlushingSolutionDrainTime,
		MaxConditioningSolutionDrainTime,
		MaxWashingSolutionDrainTime,
		MaxSecondaryWashingSolutionDrainTime,
		MaxTertiaryWashingSolutionDrainTime,
		MaxElutingSolutionDrainTime,
		MaxLoadingSampleDrainTime,

		PreFlushingSolutionUntilDrained,
		ConditioningSolutionUntilDrained,
		WashingSolutionUntilDrained,
		SecondaryWashingSolutionUntilDrained,
		TertiaryWashingSolutionUntilDrained,
		ElutingSolutionUntilDrained,
		LoadingSampleUntilDrained

	};

	groupedByBiotage48PhysicalProperties = Experiment`Private`groupByKey[optionsToBatch, groupingParameters];

	maxNumberOfCartridge = 48;
	maxVolumeInWaste = Experiment`Private`cacheLookup[cache, Model[Container, Vessel, "Biotage Pressure+48 Waste Tub"], MaxVolume];

	(* first calculate in each sample index that volume is going to waste *)
	solutionsVolumeOptions = {
		PreFlushingSolutionVolume,
		ConditioningSolutionVolume,
		WashingSolutionVolume,
		SecondaryWashingSolutionVolume,
		TertiaryWashingSolutionVolume,
		ElutingSolutionVolume,
		LoadingSampleVolume
	};
	solutionCollectionOptions = {
		CollectPreFlushingSolution,
		CollectConditioningSolution,
		CollectWashingSolution,
		CollectSecondaryWashingSolution,
		CollectTertiaryWashingSolution,
		CollectElutingSolution,
		CollectLoadingSampleFlowthrough
	};

	updatedBiotageOptions = Map[Function[{myBatchedOptions},
		Module[
			{cartridgeLocation, aliquotTargets, updatedOptions, singleOptions, indexMatchedOptions,
				allVolumeEachIndex, allCollectSwitchEachIndex, allVolumeToWasteEachIndex,
				totalVolumeToWasteEachIndex, sampleSubIndex, batchByCartridgeNumber,
				batchByVolumeToWaste, allBatchIdentifier, allBatchBool,
				allBatchLabel, poolLength, flatSamples,
				compileBatchLabel, aliquotTargetsFlat, aliquotTargetsPooled,
				compileCartridgePosition, samples,
				cartridgePositionOrigin, allVolumeToWasteEachIndexNoNull,
				currentIndexNumber, totalVolumeToWasteCurrentIndex, cartridgePosition},

			singleOptions = myBatchedOptions[[1]];
			indexMatchedOptions = myBatchedOptions[[2]];

			samples = Lookup[indexMatchedOptions, Samples];
			currentIndexNumber = Table[n, {n, Length[Lookup[indexMatchedOptions, ExtractionCartridge]]}];
			cartridgePosition = Map[StringJoin[#]&, Tuples[{{"A", "B", "C", "D"}, Map[ToString, Table[n, {n, 12}]]}]];
			cartridgePositionOrigin = Map[StringJoin[#]&, Tuples[{{"A", "B", "C", "D"}, Map[ToString, Table[n, {n, 12}]]}]];
			cartridgePosition = Take[Flatten[ConstantArray[cartridgePositionOrigin, Ceiling[Length[samples] / Length[cartridgePositionOrigin]]]], Length[samples]];
			allVolumeEachIndex = Lookup[indexMatchedOptions, solutionsVolumeOptions] /. {Null -> 0 Milliliter};
			allCollectSwitchEachIndex = Lookup[indexMatchedOptions, solutionCollectionOptions];

			(* if you don't collect, for sure the volume will; go to waste *)
			allVolumeToWasteEachIndex = MapThread[
				If[MatchQ[#2, {False.. | Null..}],
					#1,
					ConstantArray[0 Milliliter, Length[samples]]
				]&,
				{
					allVolumeEachIndex,
					allCollectSwitchEachIndex
				}
			];

			(* then sum the volume that will go to waste *)
			totalVolumeToWasteEachIndex = Map[Total[Flatten[#]]&, Transpose[allVolumeToWasteEachIndex]];

			(* preassign batch label *)
			compileBatchLabel = {}; compileCartridgePosition = {};
			(* recursively batch until we run out of samples *)
			While[
				Length[currentIndexNumber] > 0,
				(
					sampleSubIndex = Table[n, {n, Length[currentIndexNumber]}];
					batchByCartridgeNumber = Ceiling[sampleSubIndex / maxNumberOfCartridge];

					totalVolumeToWasteCurrentIndex = Accumulate[totalVolumeToWasteEachIndex[[currentIndexNumber]]];
					batchByVolumeToWaste = Ceiling[totalVolumeToWasteCurrentIndex / maxVolumeInWaste];

					allBatchIdentifier = Transpose[{
						batchByCartridgeNumber,
						batchByVolumeToWaste
					}];

					allBatchBool = Map[MatchQ[#, {1...}]&, (allBatchIdentifier /. 0 -> 1)];
					allBatchLabel = PickList[allBatchBool /. True -> ("SPE batch " <> ToString[Unique[]]), allBatchBool];

					(* append all the output we will use further *)
					compileBatchLabel = Append[compileBatchLabel, allBatchLabel];
					compileCartridgePosition = Append[compileCartridgePosition, PickList[cartridgePosition, allBatchBool]];
					(* reset loop condition *)
					currentIndexNumber = PickList[currentIndexNumber, Not /@ allBatchBool];
				)
			];

			(* there is no need for aliquoting *)
			poolLength = Map[Length[#]&, samples];
			flatSamples = Flatten[samples];
			aliquotTargetsFlat = Map[Null&, flatSamples];
			aliquotTargetsPooled = TakeList[aliquotTargetsFlat, poolLength];

			(* return structure like group by key*)
			updatedOptions = Join[
				indexMatchedOptions,
				{
					SPEBatchID -> Flatten[compileBatchLabel],
					CartridgePlacement -> Flatten[compileCartridgePosition],
					AliquotTargets -> aliquotTargetsPooled
				}
			];
			(* output of map *)
			updatedOptions

		]], groupedByBiotage48PhysicalProperties
	];
	updatedBiotageOptions
];


(* ::Subsubsection::Closed:: *)
(*resolveSolidPhaseExtractionWorkCell*)


(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options from there.*)
DefineOptions[resolveSolidPhaseExtractionWorkCell,
	SharedOptions:>{
		ExperimentSolidPhaseExtraction,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];


(*resolveSolidPhaseExtractionWorkCell*)
resolveSolidPhaseExtractionWorkCell[
	mySamples_ , myOptions : OptionsPattern[]
] := Module[{workCell, userChosenInstrument, fakeFilterOptions, filterWorkCells},

	(*get the specified work cells and instrument *)
	workCell = Lookup[myOptions, WorkCell, Automatic];
	userChosenInstrument = Flatten[Lookup[myOptions, {Instrument}, {}]];

	(* make some fake filter options; resolveSPEWorkCell will ultimately just call ExperimentFilter's work cell resolver and mimic its logic, so we just need to pass down the options that filter needs to make this decision *)
	fakeFilterOptions = {
		WorkCell -> workCell,
		Instrument -> userChosenInstrument,
		Intensity -> Flatten[{
			Lookup[myOptions, PreFlushingSolutionCentrifugeIntensity],
			Lookup[myOptions, ConditioningSolutionCentrifugeIntensity],
			Lookup[myOptions, LoadingSampleCentrifugeIntensity],
			Lookup[myOptions, WashingSolutionCentrifugeIntensity],
			Lookup[myOptions, SecondaryWashingSolutionCentrifugeIntensity],
			Lookup[myOptions, TertiaryWashingSolutionCentrifugeIntensity],
			Lookup[myOptions, ElutingSolutionCentrifugeIntensity]
		}]
	};

	(* get the work cells that filter would chose *)
	filterWorkCells = resolveExperimentFilterWorkCell[Null, fakeFilterOptions];

	filterWorkCells

];

(* ::Subsection::Closed:: *)
(*ExperimentSolidPhaseExtractionOptions*)
DefineOptions[ExperimentSolidPhaseExtractionOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentSolidPhaseExtraction}
];


ExperimentSolidPhaseExtractionOptions[myPooledSamples : ListableP[ListableP[Alternatives[ObjectP[Object[Sample]], ObjectP[Object[Container]], _String]]], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentSolidPhaseExtraction *)
	options = ExperimentSolidPhaseExtraction[myPooledSamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentSolidPhaseExtraction],
		options
	]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentSolidPhaseExtractionQ*)


DefineOptions[ValidExperimentSolidPhaseExtractionQ, Options :> {VerboseOption, OutputFormatOption}, SharedOptions :> {ExperimentSolidPhaseExtraction}];
ValidExperimentSolidPhaseExtractionQ[myPooledSamples : ListableP[ListableP[Alternatives[ObjectP[Object[Sample]], ObjectP[Object[Container]], _String]]], myOptions : OptionsPattern[]] := Module[
	{listedOptions, preparedOptions, experimentSolidPhaseExtractionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentSolidPhaseExtraction *)
	experimentSolidPhaseExtractionTests = ExperimentSolidPhaseExtraction[myPooledSamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[experimentSolidPhaseExtractionTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Flatten[DeleteCases[ToList[myPooledSamples], _String]], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Flatten[DeleteCases[ToList[myPooledSamples], _String]], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, experimentSolidPhaseExtractionTests, voqWarnings}]
		]
	];
	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentSolidPhaseExtractionQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentSolidPhaseExtractionQ"]
];

(* ::Subsection::Closed:: *)
(*ExperimentSolidPhaseExtractionPreview*)
DefineOptions[ExperimentSolidPhaseExtractionPreview, SharedOptions :> {ExperimentSolidPhaseExtraction}];
ExperimentSolidPhaseExtractionPreview[myPooledSamples : ListableP[ListableP[Alternatives[ObjectP[Object[Sample]], ObjectP[Object[Container]], _String]]], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentSolidPhaseExtraction *)
	ExperimentSolidPhaseExtraction[myPooledSamples, Append[noOutputOptions, Output -> Preview]]
];
