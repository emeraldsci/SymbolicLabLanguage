(* ::Package:: *)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExperimentCrossFlowFiltration*)

(* ::Subsection:: *)
(*Options*)

DefineOptions[ExperimentCrossFlowFiltration,
	Options:>{
		
		(* ---------- Input ---------- *)
		{
			OptionName -> Instrument,
			Default -> Automatic,(*Model[Instrument,CrossFlowFiltration,"KrosFlo KR2i"]*)
			AllowNull -> False,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Instrument, CrossFlowFiltration], Object[Instrument, CrossFlowFiltration]}]],
			Description -> "CrossFlow filtration apparatus that will be used to perform the filtration.",
			ResolutionDescription -> "Automatically set based on the SampleInVolume and number of samples. If multiple samples are specified, and all SampleInVolume is smaller than 200 Milliliter, this option is set to Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"]. If SampleInVolume is larger than 200 Milliliter, this option is set to Model[Instrument, CrossFlowFiltration, \"KrosFlo KR2i\"]. Note that since the instrument setup is very time-consuming, only one sample is allower if using Model[Instrument, CrossFlowFiltration, \"KrosFlo KR2i\"] as the Instrument. If using Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"] as the Instrument, ten samples are allowed for each experiment.", Category -> "Instrument Setup"
		},
		
		
		{
			OptionName->Sterile,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Whether the experiment will be performed under aseptic conditions.",
			ResolutionDescription->"Automatically set to True if the specified filter unit or the sample reservoir is sterile. If both are specified, the experiment will only set to sterile if both are sterile. Otherwise, it will set to the sterility of the sample.",
			Category->"General"
		},
		
		(* ---------- Instrument Tubings ---------- *)
		
		{
			OptionName->TubingType,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[PharmaPure] (* Model[Part, CuttingJig, "id:4pO6dMO93lq5"] *)
			],
			Description->"Material of tubes used to transport solutions during the experiment.",
			ResolutionDescription->"Automatically set to PharmaPure if the Instrument is Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"].",
			Category->"Instrument Setup"
		},
		
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being studied in ExperimentCrossFlowFiltration, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples that are being studied in ExperimentCrossFlowFiltration, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> RetentateContainerOutLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of RetentateContainerOut that are being studied in ExperimentCrossFlowFiltration, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> RetentateSampleOutLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the sample inside RetentateContainerOuts that are being studied in ExperimentCrossFlowFiltration, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> PermeateContainerOutLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of PermeateContainerOut that are being studied in ExperimentCrossFlowFiltration, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> PermeateSampleOutLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the sample inside PermeateContainerOut that are being studied in ExperimentCrossFlowFiltration, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName->SampleInVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[5 Milliliter,2 Liter],
					Units->Milliliter
				],
				Description->"Amount of sample that will be filtered in this experiment.",
				ResolutionDescription->"Automatically set to the entire volume of the chosen sample or the highest volume the specified system can handle.",
				Category->"General"
			},
			
			(* ---------- Mode Setup ---------- *)
			
			{
				OptionName->FiltrationMode,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>CrossFlowFiltrationModeP
				],
				Description->"The crossflow filtration recipe performed in the experiment. There are 4 modes Concentration,Diafiltration, ConcentrationDiafiltration, ConcentrationDiafiltrationConcentration. ",
				ResolutionDescription->"Automatically resolved based on DiafiltrationTarget, PrimaryConcentrationTarget, and SecondaryConcentrationTarget. If non of these values were specified, set to Concentration",
				Category->"Filtration"
			},
			
			(* ---------- Filter Options ---------- *)

			{
				OptionName->CrossFlowFilter,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Item,CrossFlowFilter],
						Object[Item,CrossFlowFilter],
						Model[Item, Filter, MicrofluidicChip],
						Object[Item, Filter, MicrofluidicChip]
					}]
				],
				Description->"Filter unit used to separate the sample during the experiment.",
				ResolutionDescription->"Automatically set to a filter unit that has a size cutoff between the two highest molecular weight components of the sample, and can accommodate the entire sample volume. Unless sterile is specified, a non-sterile filter will be selected.",
				Category->"General"
			},

			{
				OptionName->SizeCutoff,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>CrossFlowFilterCutoffP
				],
				Description->"Largest diameter or molecular weight of the molecules that can cross the membrane.",
				ResolutionDescription->"Automatically set to the value that cuts off the component with the highest molecular weight in the sample.",
				Category->"General"
			},
			{
				OptionName->DiafiltrationTarget,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Fold"->Widget[Type->Number,Pattern:>GreaterP[1]],
					"Volume"->Widget[Type->Quantity,Pattern:>RangeP[1 Milliliter,18 Liter],Units->Milliliter],
					"Weight"->Widget[Type->Quantity,Pattern:>GreaterP[1 Gram],Units->Gram]
				],
				Description->"The amount of DiafiltrationBuffer for Diafiltration, ConcentrationDiafiltration and ConcentrationDiafiltrationConcentration mode. This option can be specified as \"Fold\", \"Volume\" and \"Weight\". If specified as \"Volume\" and \"Weight\", the exact amount (in volume or mass) of DiafiltrationBuffer is used. If specified as \"Fold\" and FiltrationMode is Diafiltration, the experiment uses Fold * SampleInVolume for DiafiltrationBuffer. If specified as \"Fold\" and FiltrationMode is ConcentrationDiafiltration or ConcentrationDiafiltrationConcentration, the experiment uses Fold * (SampleInVolume - PrimaryConcentrationTarget) if PrimaryConcentrationTarget is specified as Volume, or Fold * (SampleInVolume / PrimaryConcentrationTarget) if PrimaryConcentrationTarget is specified as a Concentration Factor for DiafiltrationBuffer. For example, given {DiafiltrationTarget -> 5, FiltrationMode -> Diafiltration, SampleInVolume is 6 Milliliter}, the DiafiltrationBuffer volume is (5 * 6 =) 30 Milliliter; given {DiafiltrationTarget -> 5, FiltrationMode -> ConcentrationDiafiltration, SampleInVolume is 6 Milliliter, PrimaryConcentrationTarget -> 2 Milliliter}, the DiafiltrationBuffer volume is (5 * (6 - 2) =) 20 Milliliter; given {DiafiltrationTarget -> 5, FiltrationMode -> Diafiltration, SampleInVolume is 6 Milliliter, PrimaryConcentrationTarget -> 2}, the DiafiltrationBuffer volume is (5 * (6 / 2) =) 15 Milliliter.",
				ResolutionDescription->"Automatically set 5 if FiltrationMode is Diafiltration, ConcentrationDiafiltration or ConcentrationDiafiltrationConcentration.",
				Category->"Filtration"
			},
			{
				OptionName->PrimaryConcentrationTarget,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Concentration Factor"->Widget[Type->Number,Pattern:>GreaterEqualP[1]],
					"Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Milliliter,18 Liter],Units->Milliliter],
					"Weight"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Gram],Units->Gram]
				],
				Description->"The amount of volume or the factor of volume for the first concentration process of sample that will be removed from the sample to the permeate during concentration.",
				ResolutionDescription->"Automatically set to 10 if FiltrationMode is Concentration or ConcentrationDiafiltration and. Automatically set to 5 if FiltrationMode is ConcentrationDiafiltrationConcentration and SecondaryConcentrationTarget is not specified. If FiltrationMode is ConcentrationDiafiltrationConcentration SecondaryConcentrationTarget is specified, this option will set to (10/SecondaryConcentrationTarget) to result in a 10-fold concentration across both concentration steps.",
				Category->"General"
			},
			{
				OptionName->SecondaryConcentrationTarget,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Concentration Factor"->Widget[Type->Number,Pattern:>GreaterEqualP[1]],
					"Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Milliliter,18 Liter],Units->Milliliter],
					"Weight"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Gram],Units->Gram]
				],
				Description->"The amount of volume or the factor of volume for the second portion of sample that will be removed from the sample to the permeate during concentration.",
				ResolutionDescription->"Automatically set based on FiltrationMode and PrimaryConcentrationTarget. When PrimaryConcentrationTarget is not specified, this option is set to 2 if FiltrationMode is ConcentrationDiafiltrationConcentration. If PrimaryConcentrationTarget is specified, this option will set to (10/PrimaryConcentrationTarget) to result in a 10-fold concentration across both concentration steps.",
				Category->"General"
			},
			
			{
				OptionName->TransmembranePressureTarget,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 PSI,30 PSI],
					Units->Alternatives[PSI,Bar, Millibar]
				],
				Description->"Amount of pressure maintained across the filter during the experiment.",
				ResolutionDescription->"Automatically set to 20 PSI if the Instrument is Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"].",
				Category->"Instrument Setup"
			},
			{
				OptionName->PermeateAliquotVolume,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1 Milliliter,$MaxTransferVolume],
						Units->Alternatives[Microliter, Milliliter, Liter] (*Microliter and Liter*)
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				],
				Description->"Amount of permeate solution that is transferred into a new container after the experiment. Note that the balance of the instrument have the limit",
				Category->"Output"
			},
			{
				OptionName->PermeateContainerOut,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description->"Containers the permeate will be transferred into after the experiment.",
				ResolutionDescription->"Automatically set based on estimated permeation volume and PermeateStorageCondition if PermeateAliquotVolume is All, otherwise set to PreferredContainer[PermeateAliquotVolume].",
				Category->"Output"
			},
			{
				OptionName->PermeateStorageCondition,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Description->"How the permeate solution will be stored after the experiment.",
				ResolutionDescription->"Automatically set to the StorageCondition in the Object of sample if it's not Null, otherwise set to Refrigerator.",
				Category->"Output"
			},
			
			{
				OptionName->PrimaryPumpFlowRate,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Milliliter/Minute,2280 Milliliter/Minute],
					Units->Alternatives[Milliliter/Minute,Liter/Minute]
				],
				Description->"Volume of feed pumped through the Instrument per minute.",
				ResolutionDescription->"Automatically set to the DefaultFlowRate in the Model of CrossFlowFilter if the Instrument is Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"].",
				Category->"Instrument Setup"
			},
			
			(* ---------- Diafiltration Steps ---------- *)
			
			{
				OptionName->DiafiltrationBuffer,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Sample],
						Object[Sample]
					}]
				],
				Description->"The solution in the feed that used for buffer exchange in the Diafiltration process.",
				ResolutionDescription->"Automatically set to Milli-Q water if FiltrationMode contains Diafiltration, ConcentrationDiafiltration or ConcentrationDiafiltrationConcentration.",
				Category->"General"
			},
			
			{
				OptionName->DiafiltrationMode,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>CrossFlowFiltrationDiafiltrationModeP
				],
				Description->"The mode to diafiltrate the sample, In Discrete mode, the sample will be diafiltrated in a certain number of steps determined by DiafiltrationExchangeCount. Meanwhile, Continuous mode will diafiltrate continuously using a step size of 2 mL. This is an unique option when the Instrument is set to Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"].",
				ResolutionDescription->"Automatically set to Continuous if Instrument is set to Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"].",
				Category->"Filtration"
			},
			{
				OptionName->DiafiltrationExchangeCount,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Number,
						Pattern:>GreaterEqualP[1, 1]
					]
				],
				Description->"The number of steps during diafiltration process. For example, if you exchange 30 mL of buffer when DiafiltrationExchangeCount is set to 3 and start the buffer exchange at 20 mL, the sample will concentrated to 20 mL and then add 10 mL of buffer and concentrate back to 20 mL in 3 x 10 mL steps. ",
				ResolutionDescription->"Automatically set to 3 if DiafiltrationMode is Discrete.",
				Category->"Output"
			},
			{
				OptionName->SampleReservoir,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container,Vessel,CrossFlowContainer],
						Object[Container,Vessel,CrossFlowContainer],
						Model[Container,Vessel],
						Object[Container,Vessel]
					}]
				],
				Description->"Container used to store the sample during the experiment.",
				ResolutionDescription->"When using Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, automatically set to the smallest Object[Container, Vessel, CrossFlowContainer] that can accommodate the entire sample volume. Otherwise, set based on the container of SamplesIn, if the SamplesIn are contained in containers with a model Model[Container, Vessel, \"50mL Tube\"], set to the object of those containers, else set to Model[Container, Vessel, \"50mL Tube\"].",
				Category->"Instrument Setup"
			},
			{
				OptionName->DeadVolumeRecoveryMode,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>CrossFlowFiltrationDeadVolumeRecoveryModeP
				],
				Description->"The Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"] is equipped with a liquid recovery mode that operates after filtration is complete. This mode has three settings: Air, Buffer, and Null. In Air mode, the instrument flushes the filter with air to recover the trapped sample. In Buffer mode, the instrument flushes the filter with a small amount of buffer to recover the sample. In Null mode, the instrument does not recover the sample. This option is exclusive to Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"].",
				ResolutionDescription->"Automatically set to Continuous if Instrument is set to Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"].",
				Category->"Filtration"
			},
			(* ---------- Output ---------- *)

			{
				OptionName->RetentateContainerOut,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Container,Vessel],
						Object[Container,Vessel]
					}]
				],
				Description->"Container that retentate is transferred into after the experiment. Note if using Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, this option cannot be set to Null (the Retentate sample must be transferred into a new container after the experiment).",
				ResolutionDescription->"When using Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, automatically set to PreferredContainer[SampleInVolume] if RetentateAliquotVolume is All, otherwise set to PreferredContainer[RetentateAliquotVolume].",
				Category->"Output"
			},
			
			{
				OptionName->RetentateAliquotVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterEqualP[1 Milliliter],
						Units->Milliliter
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				],
				Description->"Amount of retentate solution that is transferred into a new container after the experiment. Note if using Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, this option cannot be set to Null.",
				ResolutionDescription->"When using Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, automatically set to All is SampleInVolume is smaller than $MaxTransferVolume, otherwise set to $MaxTransferVolume.",
				Category->"Output"
			},
			
			{
				OptionName->RetentateStorageCondition,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Description->"How the RetentateContainerOut will be kept after the experiment.  If you're using KR2i as the instrument, the sample should be transferred into a new RetentateContainerOut, and this option determines where the filtered samples will be stored. On the other hand, if you're using uPulse as the instrument, the SamplesIn won't be transferred into RetentateContainerOut automatically. Therefore, this option only determines the storage location for filtered samples when RetentateContainerOut is specified.",
				ResolutionDescription->"Automatically set to the StorageCondition in the Object of sample if it's not Null, otherwise set to Refrigerator.",
				Category->"Output"
			},
			
			{
				OptionName->FilterStorageCondition,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Description->"How the filter will be kept after the experiment.",
				ResolutionDescription->"Automatically set to Disposal if if the Instrument is Model[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"], else set to AmbientStorage.",
				Category->"Output"
			}
		],


		(* ---------- Priming ---------- *)

		{
			OptionName->FilterPrime,
			Default->True,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Whether the CrossFlowFilter and the Instrument will be wet and rinsed before the experiment.",
			Category->"Priming"
		},

		{
			OptionName->FilterPrimeBuffer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Sample],
					Object[Sample]
				}]
			],
			Description->"Solution used to wet and rinsed the CrossFlowFilter and the Instrument.",
			ResolutionDescription->"If FilterPrime is True, automatically set based on the MembraneMaterial and ModuleFamily fields in the Model of CrossFlowFilter. If MembraneMaterial is Polysulfone and ModuleFamily is either MicroKros, MidiKros, MidiKrosTC or MiniKrosSampler, this option is set to Model[Sample,StockSolution,\"20% Ethanol\"], otherwise set to Model[Sample,\"Milli-Q water\"].",
			Category->"Priming"
		},

		{
			OptionName->FilterPrimeVolume,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Milliliter,500 Milliliter],
				Units->Alternatives[Milliliter,Liter]
			],
			Description->"Volume of solution that is used to prime the Instrument, about half of which is expected to pass through the filter.",
			ResolutionDescription->"If FilterPrime is True, automatically set based on the MembraneMaterial and FilterSurfaceArea fields in the Model of CrossFlowFilter. When MembraneMaterial is Polysulfone, this option is set to 500 Milliliter if the FilterSurfaceArea is greater or equal to 250 square centimeter or set to 2 * FilterSurfaceArea Milliliter. When MembraneMaterial is not Polysulfone, this option is set to 500 Milliliter if the FilterSurfaceArea is greater or equal to 500 square centimeter or set to (1 * FilterSurfaceArea) Milliliter.",
			Category->"Priming"
		},

		{
			OptionName->FilterPrimeRinse,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Whether the CrossFlowFilter and the Instrument will be rinsed by one additional buffer solution after the filter priming.",
			ResolutionDescription->"If FilterPrime is True, automatically set to True if FilterPrimeBuffer is not water Model[Sample, \"Milli-Q water\"].",
			Category->"Priming"
		},
		{
			OptionName->FilterPrimeRinseBuffer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Sample],
					Object[Sample]
				}]
			],
			Description->"Solution used to rinse the membrane after priming.",
			ResolutionDescription->"If FilterPrime is True, automatically set to the first DiafiltrationBuffer if specified, otherwise resolves to Model[Sample, \"Milli-Q water\"].",
			Category->"Priming"
		},

		{
			OptionName->FilterPrimeFlowRate,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Milliliter/Minute,2280 Milliliter/Minute],
				Units->Alternatives[Milliliter/Minute,Liter/Minute]
			],
			Description->"Volume of priming buffer pumped through the Instrument per minute.",
			ResolutionDescription->"When usingModel[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, if FilterPrime is True, automatically set to DefaultFlowRate field in the Model of CrossFlowFilter.",
			Category->"Priming"
		},

		{
			OptionName->FilterPrimeTransmembranePressureTarget,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 PSI,20 PSI],
				Units->Alternatives[PSI,Bar]
			],
			Description->"Amount of pressure maintained across the filter during the filter prime step.",
			ResolutionDescription->"When usingModel[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, if FilterPrime is True, automatically set to 10 PSI.",
			Category->"Priming"
		},

		(* ---------- Filter Flush ---------- *)
		{
			OptionName->FilterFlush,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Whether the CrossFlowFilter and the Instrument will be flushed after the experiment.",
			ResolutionDescription->"Automatically set to True if FilterStorageCondition is not Disposal.",
			Category->"Flushing"
		},

		{
			OptionName->FilterFlushBuffer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Sample],
					Object[Sample]
				}]
			],
			Description->"Solution used to flush the CrossFlowFilter and the Instrument after the experiment.",
			ResolutionDescription->"If FilterFlush is True, automatically set to Model[Sample, \"Milli-Q water\"] if FilterFlush is True.",
			Category->"Flushing"
		},

		{
			OptionName->FilterFlushVolume,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Milliliter,500 Milliliter],
				Units->Alternatives[Milliliter,Liter]
			],
			Description->"Volume of solution that is pumped into the Instrument to flush the CrossFlowFilter, about half of which is expected to pass through the filter.",
			ResolutionDescription->"If FilterFlush is True, automatically set based on the FilterSurfaceArea filed in the Model of CrossFlowFilter. This option is set to 500 Milliliter if the FilterSurfaceArea is greater or equal to 250 square centimeter or set to 2 * FilterSurfaceAre Milliliter.",
			Category->"Flushing"
		},

		{
			OptionName->FilterFlushRinse,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Whether there will be a water wash step after the filter flush.",
			ResolutionDescription->"If FilterFlush is True, automatically set to True if FilterFlushBuffer is not Model[Sample, \"Milli-Q water\"] and FilterFlush is True.",
			Category->"Flushing"
		},

		{
			OptionName->FilterFlushFlowRate,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Milliliter/Minute,2280 Milliliter/Minute],
				Units->Alternatives[Milliliter/Minute,Liter/Minute]
			],
			Description->"Volume of flushing buffer pumped through the system per minute.",
			ResolutionDescription->"When usingModel[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, if FilterFlush is True, automatically set to DefaultFlowRate field in the Model of CrossFlowFilter..",
			Category->"Flushing"
		},

		{
			OptionName->FilterFlushTransmembranePressureTarget,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 PSI,20 PSI],
				Units->Alternatives[PSI,Bar]
			],
			Description->"Amount of pressure maintained across the filter during the filter flush step.",
			ResolutionDescription->"When usingModel[Instrument,CrossFlowFiltration,\"KrosFlo KR2i\"] as the Instrument, if FilterFlush is True, automatically set to 10 PSI.",
			Category->"Flushing"
		},
		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOption,
		SimulationOption
	}
];


(* ::Subsection:: *)
(* ExperimentCrossFlowFiltration Error Messages*)

Error::CrossFlowKR2ICannotRunMultipleSamples="Multiple samples are not supported at this time. Please specify a single sample.";
Error::CrossFlowMissingCompositionInformation="Sample \"`1`\" is missing composition information, which prevents CrossFlowFilter resolution. Please specify CrossFlowFilter or SizeCutoff, or enter composition information for sample \"`1`\" to automatically resolve options.";
Error::CrossFlowUnsupportedInstrument="The specified Instrument \"`1`\" is `2`. Please choose a different instrument.";
Error::CrossFlowIncompatibleTubing="The specified tubing types at indices `1` cannot be used for this experiment. Please choose different tubing types at these indices.";
Error::CrossFlowReservoirIncompatibleWithVolume="The specified SampleInVolume `1` is outside the capacity of the specified sample reservoir \"`2`\". Please choose a different reservoir or change the sample volume.";
Error::CrossFlowFilterIncompatibleWithVolume="The specified SampleInVolume `1` is outside the capacity of the specified filter \"`2`\". Please choose a different filter or change the sample volume.";
Error::CrossFlowInsufficientSampleVolume="The specified SampleInVolume of `1` is more than the total volume of the specified sample \"`2`\" (`3`). Please choose a different reservoir or change the sample volume.";
Error::CrossFlowRetentateVolumeExceedsContainer="Specified RetentateAliquotVolume of `1` is greater than the capacity of the specified RetentateContainerOut (`2`). Please pick a larger container or specify a smaller volume.";
Error::CrossFlowConcentrationFactorExceedsUnity="The cumulative concentration factors or amounts specified for Targets exceeds sample volume `1`. Please specify smaller targets, or increase sample volume. Please note that the Targets are specified based on the initial sample volume for each step if without units.";
Error::CrossFlowInvalidTarget="The concentration factor is invalid. Please specify targets less than 1 for concentration recipes.";(*TODO: this is irrelavant, right? *)
Error::CrossFlowPrimeOptionSpecifiedWithoutPrime="Option(s) `1` were specified with FilterPrime set to False. Please set FilterPrime to True, or remove specified values for `1`.";
Error::CrossFlowFlushOptionSpecifiedWithoutFlush="Option(s) `1` were specified with FilterFlush set to False. Please set FilterFlush to True, or remove specified values for `1`.";
Error::CrossFlowPermeateVolumeExceedsContainer="Specified PermeateAliquotVolume of `1` is greater than the capacity of the specified PermeateContainerOut `2` (`3`). Please specify a larger container or a smaller volume.";
Warning::CrossFlowNonSterileSampleReservoir="Resolved sample reservoir `1` is not available in a sterile form. If sterility is necessary beyond standard packaging for this experiment, please specify a sterile sample reservoir.";
Error::CrossFlowFilterPrimeVolumeTooLow="To effectively prime the system, `2` volume of the FilterPrimeBuffer is required. For now only `1` is specified to be used. Please specify more prime solution or leave this option as Automatic.";
Warning::CrossFlowAssumedDensity="Since the`1` density of the solvent`2` is unknown, it was assumed to be `3` based on a volumetrically weighted average of the liquid components. If this density is inaccurate, please specify the density of the sample, or specify Targets in volume or fold sample volume units.";
Warning::CrossFlowLongScanTime="The specified absorbance wavelength scan cannot be completed within AbsorbanceDataAcquisitionFrequency. The scan will be completed as requested, albeit less frequently than AbsorbanceDataAcquisitionFrequency.";
Warning::CrossFlowSampleVolumeExceedsCapacity="The specified sample `1` has a volume that exceeds the capacity of the experiment (`2`). The sample volume will be adjusted to `2`.";
Error::CrossFlowCannotResolveSampleVolume="Neither the specified sample `1` nor its container has volume information available. Please specify SampleInVolume or update the volume information of the sample.";
Error::CrossFlowRetentateExceedsSample="The specified RetentateAliquotVolume `1` exceeds the estimated sample volumes that the sample will have after the filtration (`2`). Please specify a lower retentate volume, or higher sample volume.";
Error::CrossFlowPermeateExceedsSample="The total volume of specified PermeateAliquotVolume exceeds the expected volume at the end of the recipe (`1`). Please specify a lower permeate volume, or a higher sample volume.";
Error::CrossFlowInvalidOutputVolumes="Specified options `1` are inconsistent. When `1` are specified, please ensure that `2`.";
Error::CrossFlowInvalidDiafiltrationBuffer="The specified diafiltration buffer `1` is not valid. Please specify either a Model[Sample] or an Object[Sample] as DiafiltrationBuffer.";
Error::CrossFlowInvalidSampleReservoir="For samples `1`, the specified SampleReservoir `2`, do not have a model of Model[Container, Vessel, \"50mL Tube\"]. However, since the Instrument is specified as `3` and the instrument can only take Model[Container, Vessel, \"50mL Tube\"] as the SampleReservoir. Please change SampleReservoir or leave this option Automatic.";
Warning::CrossFlowFilterSpecifiedMismatch="The specified filter `1` does not match specified option `2`, whose value is `3`. The specified option `2` will be ignored.";
Warning::CrossFlowNonOptimalSizeCutoff="The sample `1` does not have molecular weight information for some components, so the largest possible value for SizeCutoff will be returned (`2`). Please populate the MolecularWeight field for the relevant molecules in the Composition of `1`, or specify SizeCutoff or CrossFlowFilter options.";
Warning::CrossFlowDiafiltrationBufferIgnored="A diafiltration buffer was specified for a concentration only recipe. The specified buffer `1` will be ignored.";
Warning::CrossFlowDiafiltrationTubingIgnored="Tubing was specified for the diafiltration buffer for a concentration only recipe. The specified Tubing for the diafiltration buffer `1` will be ignored.";
Error::CrossFlowRetentateVolumeTooLow="The calculated final retentate volume `1` for sample(s) `2` is below the minimum amount that can be handled by the filtration container or filter `3` (`4`). Please increase the retentate volume by adjusting `1`, or decrease the input sample volume such that it can fit into a smaller filtration container.";
Warning::CrossFlowFilterUnavailableFilters="Even though the experiment resolved to Sterile, a sterile filter with the specified SizeCutoff `1` could not be found. A non-sterile filter with the specified cutoff will be returned. If a non-sterile filter is not acceptable for this experiment, please specify a CrossFlowFilter.";
Warning::CrossFlowDefaultFilterReturned="Since a filter with required sterility, volume range and size cutoff could not be found, a default filter will be returned. If this filter is not acceptable for this experiment, please specify a different SizeCutoff or a CrossFlowFilter.";
Error::CrossFlowDiafiltrationTubingMissing="The diafiltration tubing (last element of Tubing) was specified as Null even though a diafiltration is part of the requested recipe. Please change the last element of Tubing to a valid tubing object.";
Error::CrossFlowPermeateExceedsCapacity="The permeate volume exceeds the capacity of the instrument (18 liters). Please adjust DiafiltrationTarget, PrimaryConcentrationTarget, and/or SecondaryConcentrationTarget to decrease the amount of permeate volume generated in the experiment.";
Error::CrossFlowSampleDeadVolume="The Sample volume (`1`) and/or the expected retentate volume (`2`), are below the cross-filtration system's dead-volume plus the sample reservoirs minimum volume, (`3`). This will result in drawing air into the system and increasing pressures. Please increase the initial volume, decrease the target concentration factor, or let these options resolve automatically.";
Warning::CrossFlowPrimeBuffersIncompatible="The FilterPrimeRinseBuffer (`1`) and the first DiafiltrationBuffer (`2`) are not of the same model. Please make sure this is indeed desired and adjust the FilterPrimeRinseBuffer accordingly, or set it to Automatic.";
Error::CrossFlowInvalidTubing="The tubing specified for `1` is not appropriate. The specified tubing must be with the appropriate connectors (`2`) and lengths (`3`).";
Error::CrossFlowFilteConflictingFilterStorageCondition="The filter was specified multiple storage conditions `2`. The experiment cannot proceed with conflicting storage information.";
Error::CrossFlowFiltrationUnneededOptions="The specified option(s), `1`, is not required when the instrument is set to `2`. Please leave these options as Automatic.";
Error::CrossFlowFiltrationRequiredOptions="The specified option(s), `1`, cannot be set to Null when the instrument is set to `2`. Please leave these options as Automatic or set them accordingly.";
Error::CrossFlowFilterDoesNotMatchInstrument="The specified sample(s), `1`, has specified CrossFlowFilters `2` that cannot be used for the Instrument `3`. If using an Instrument with a Model of Model[Instrument, CrossFlowFiltration, \"KrosFlo KR2i\"], please use filters with the model of Model[Item,CrossFlowFilter]. If using an Instrument with a Model of Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"], please use filters with the model of Model[Item, Filter, MicrofluidicChip].";
Error::CrossFlowFilterInvalidDiafiltrationMode="When using uPulse, the specified sample(s), `1`, has specified FiltrationMode `2` that are conflicting with DiafiltrationMode `3`. DiafiltrationMode can only be specified if FiltrationMode is ConcentrationDiafiltrationConcentration, ConcentrationDiafiltration or Diafiltration.";
Error::CrossFlowFilterDiaFiltrationExchangeCount="When using uPulse, the specified sample(s), `1`, has specified DiafiltrationExchangeCount `2` that is conflicting with DiafiltrationMode `3`. DiafiltrationExchangeCount can only be specified if DiafiltrationMode is set to Discrete.";
Error::CrossFlowFilterInvalidDiaFiltrationMode="When using uPulse, the specified sample(s), `1`, has specified FiltrationMode `2` that are not supported by the Instrument `3`.";
Error::CrossFlowFilterInvalidDiafiltrationTarget="When using uPulse, the specified sample(s), `1`, has specified DiafiltrationTarget `2` that require exchange `3` volumes. However when using uPulse, the ExperimentCrossFlowFiltration only allows to exchange 45 milliliter when using uPulse as the instrument.";
Error::CrossFlowFilterInvalidDeadVolumeRecoveryMode="The specified sample(s), `1`, has specified DeadVolumeRecoveryMode `2` that conflict with the Instrument `3` and the FiltrationMode `4`. If using Model[Instrument, CrossFlowFiltration, \"KrosFlo KR2i\"] as the Instrument, this option can only be set to Null. If using Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"] as the Instrument, this option can be Air, Null or Buffer, but can only be set to Buffer when FiltrationMode requires Diafiltration (ConcentrationDiafiltrationConcentration or ConcentrationDiafiltration).";
Error::CrossFlowTooManySamples="When using `1` as the instrument, less or equal to 10 samples can be ran for each experiment. Please consider separate these samples into two experiment.";
Error::CrossFlowKR2ICannotRunMultipleSamples="When using `1` as the instrument, only 1 sample can be ran for each experiment, due to long instrument set-up time. Please separate these samples into multiple experiment. If sample volume is not too large (e.g. < 200 mL), consider using Model[Instrument, CrossFlowFiltration, \"\[Micro]PULSE - TFF\"] as the Instrument and filter these sample in multiple 50mL Tubes (Model[Container, Vessel, \"50mL Tube\"]).";

(* ::Subsection:: *)
(* Constants *)
$MinMicropulseRetentateVolume = 1.5 Milliliter;
$uPulseFilterRate = 1.5 Milliliter/Minute;
(* ::Subsection:: *)
(*List overload*)

(* ::Subsubsection::Closed:: *)
(* ExperimentCrossFlowFiltration (container input) *)


ExperimentCrossFlowFiltration[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions : OptionsPattern[ExperimentCrossFlowFiltration]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samplePreparationSimulation,containerToSampleSimulation,
		containerToSampleTests, messages, listedContainers, validSamplePreparationResult, myOptionsWithPreparedSamplesNamed,
		samples, sampleOptions, containerToSampleOutput, mySamplesWithPreparedSamplesNamed},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];
	
	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];
	
	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};
	
	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentCrossFlowFiltration,
			ToList[myContainers],
			ToList[myOptions]
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
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentCrossFlowFiltration,
			mySamplesWithPreparedSamplesNamed,
			myOptionsWithPreparedSamplesNamed,
			Output->{Result,Tests,Simulation},
			Simulation->samplePreparationSimulation
		];
		
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],
		
		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentCrossFlowFiltration,
				mySamplesWithPreparedSamplesNamed,
				myOptionsWithPreparedSamplesNamed,
				Output-> {Result,Simulation},
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;
		
		(* Call our main function with our samples and converted options. *)
		ExperimentCrossFlowFiltration[samples,ReplaceRule[sampleOptions, {Simulation -> containerToSampleSimulation}]]
	]
];

(* ::Subsection:: *)
(* Main Function *)

ExperimentCrossFlowFiltration[mySamples:ListableP[ObjectP[{Object[Sample]}]],myOptions:OptionsPattern[]]:=Module[
	{
		(* Initial options handling *)
		outputSpecification,output,gatherTests,messages,listedSamples,listedOptions,validSamplePreparationResult,samplePreparationSimulation,mySamplesWithPreparedSamplesNamed,validLengths,validLengthTests,safeOptionsNamed,safeOpsTests,myOptionsWithPreparedSamplesNamed,safeOps,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,expandedSafeOpsAssociation,allOtherObjects,
		
		(* Error checking for specified objects *)
		myOptionsWithPreparedSamples,mySamplesWithPreparedSamples,cache,
		
		(* Cacheball variables *)
		initialInstrument,instrumentModels,instrumentObjects,initialSampleReservoirs,sampleReservoirModels,initialFilter,filterModels,initialPrecutTubingObjects,initialPrecutTubingModels,initialTubing,tubingModels,precutTubingModels,initialContainers,moleculeModels,initialDiafiltrationBuffer,initialFilterPrimeRinseBuffer,objectSampleFields,objectContainerFields,modelContainerFields,packetObjectSample,packetObjectContainer,packetModelContainer,packetOutputContainer,downloadedPackets,cacheBall,outputContainerFields,outputContainerModels,
		
		(* Resolver and resource variables *)
		resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,protocolObject,uPulseFilterChipModels, filterObjects,
		reservoirObjects,performSimulationQ,simulatedProtocol,updatedSimulation
	},
	
	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	
	(* Determine if we are throwing messages *)
	messages=!gatherTests;
	
	(* Ensure that options and samples are in a list, and have no temporal links *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];
	
	(* Get the cache *)
	cache=Lookup[listedOptions,Cache,{}];
	
	
	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentCrossFlowFiltration,
			listedSamples,
			listedOptions
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
	
	(* Check if all options match their patterns *)
	{safeOptionsNamed,safeOpsTests}=If[
		gatherTests,
		SafeOptions[ExperimentCrossFlowFiltration,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentCrossFlowFiltration,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns, or option lengths are invalid, return $Failed *)
	If[
		FailureQ[safeOps],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* Check if all options are the right length *)
	{validLengths,validLengthTests}=If[
		gatherTests,
		ValidInputLengthsQ[ExperimentCrossFlowFiltration,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentCrossFlowFiltration,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests, validLengthTests],
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* Get the default values for unspecified options *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentCrossFlowFiltration,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentCrossFlowFiltration,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];
	
	
	(* If the template doesn't exist, return early *)
	If[
		FailureQ[templatedOptions],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* Replace safe options with templated options *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];
	
	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentCrossFlowFiltration,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];
	
	(* Make an association of the expandedSafeOps for lookups *)
	expandedSafeOpsAssociation=Association@@expandedSafeOps;
	
	(* ---------- Create and Download Cacheball ---------- *)
	
	(* ----- Find Instruments ----- *)
	
	(* Check if instrument is specified as an object *)
	initialInstrument=If[
		MatchQ[Lookup[expandedSafeOpsAssociation,Instrument,Null],ObjectP[Object[Instrument,CrossFlowFiltration]]],
		Lookup[expandedSafeOpsAssociation,Instrument],
		Null
	];
	
	(* Find all instrument models *)
	(* Find all sample reservoir models *)
	(* Find all filter models *)
	(* Find all output containers *)
	{
		instrumentModels,
		instrumentObjects,
		sampleReservoirModels,
		filterModels,
		tubingModels,
		precutTubingModels,
		moleculeModels,
		outputContainerModels,
		uPulseFilterChipModels
	}=Search[
		{
			Model[Instrument,CrossFlowFiltration],
			Object[Instrument,CrossFlowFiltration],
			Model[Container,Vessel,CrossFlowContainer],
			Model[Item,CrossFlowFilter],
			Model[Plumbing, Tubing],
			Model[Plumbing,PrecutTubing],
			Model[Molecule],
			Model[Container,Vessel],
			Model[Item,Filter,MicrofluidicChip]
		},
		{
			Deprecated!=True,
			DateRetired == Null && DeveloperObject != True,
			Deprecated!=True,
			Deprecated!=True,
			StringContainsQ[Name, "PharmaPure"]&&Deprecated!=True,
			StringContainsQ[Name,"PharmaPure #"]&&Deprecated!=True,
			State===Liquid&&Density>0Gram/Milliliter,
			Or[
				Name==(___~~"mL Tube")&&InternalBottomShape===VBottom,
				Name==(___~~"L Glass Bottle")&&MaxVolume>50 Milliliter&&SelfStanding==(True|Null),
				Name==(___~~"L Glass Bottle, Sterile")&&MaxVolume>50 Milliliter&&Sterile==True&&SelfStanding==(True|Null),
				Name==(___~~"Carboy")&&CleaningMethod===DishwashPlastic,
				Name==(___~~"Carboy, Sterile")&&CleaningMethod===DishwashPlastic&&Sterile==True
			],
			CleanerOnly == (False | Null) && (Deprecated!=True)
		},
		SubTypes-> {
			True,
			True,
			True,
			True,
			True,
			False,
			False,
			False,
			False
		}
	];
	
	(* ----- Find Sample Reservoirs ----- *)
	
	(* Check if sample reservoir is specified as an object *)
	initialSampleReservoirs=If[
		MatchQ[Lookup[expandedSafeOpsAssociation,SampleReservoir,Null],ObjectP[Object[Container,Vessel,CrossFlowContainer]]],
		Lookup[expandedSafeOpsAssociation,SampleReservoir],
		Nothing
	];
	
	
	(* ----- Find Filters ----- *)
	
	(* Check if filter is specified as an object *)
	initialFilter=Lookup[expandedSafeOpsAssociation,CrossFlowFilter];
	
	(* ----- Find Tubing ----- *)

	(* Check if tubing is specified *)
	initialTubing= Cases[Lookup[expandedSafeOpsAssociation,{DiafiltrationBufferContainerToFeedContainerTubing, FeedContainerToFeedPressureSensorTubing, PermeatePressureSensorToConductivitySensorTubing, RetentatePressureSensorToConductivitySensorTubing, RetentateConductivitySensorToFeedContainerTubing, AbsorbanceInTubing, AbsorbanceOutTubing},Null],ObjectP[]];

	initialPrecutTubingObjects = Cases[initialTubing, ObjectP[Object[Plumbing, PrecutTubing]]];
	initialPrecutTubingModels = Cases[initialTubing, ObjectP[Model[Plumbing, PrecutTubing]]];

	(* Find all tubing models *)
	
	(* ----- Find Output Containers ----- *)
	
	(* Create a list of output container objects to download based on which ones are specified *)
	initialContainers=Which[
		
		(* If only retentate container is specified *)
		MatchQ[Lookup[expandedSafeOpsAssociation,{RetentateContainerOut,PermeateContainerOut},Null],{Except[Automatic],Automatic}],
		Lookup[expandedSafeOpsAssociation,{RetentateContainerOut}],
		
		(* If only permeate container is specified *)
		MatchQ[Lookup[expandedSafeOpsAssociation,{RetentateContainerOut,PermeateContainerOut},Null],{Automatic,Except[Automatic]}],
		Lookup[expandedSafeOpsAssociation,PermeateContainerOut],
		
		(* If both containers are specified *)
		MatchQ[Lookup[expandedSafeOpsAssociation,{RetentateContainerOut,PermeateContainerOut},Null],{Except[Automatic],Except[Automatic]}],
		Flatten[Lookup[expandedSafeOpsAssociation,{RetentateContainerOut,PermeateContainerOut}]],
		
		(* If none are specified*)
		True,{}
	];
	
	
	
	(* Find diafiltration buffers *)
	initialDiafiltrationBuffer=If[
		MatchQ[Lookup[expandedSafeOpsAssociation,DiafiltrationBuffer,{}],ObjectP[{Object[Sample],Model[Sample]}]],
		Lookup[expandedSafeOpsAssociation,DiafiltrationBuffer],
		Nothing
	];

	(* find FilterPrimeRinseBuffers *)
	initialFilterPrimeRinseBuffer=If[
		MatchQ[Lookup[expandedSafeOpsAssociation,FilterPrimeRinseBuffer,Null],ObjectP[{Object[Sample],Model[Sample]}]],
		Lookup[expandedSafeOpsAssociation,FilterPrimeRinseBuffer],
		Nothing
	];

	(* Find the fields we need for the sample and its container *)
	{
		objectSampleFields,
		objectContainerFields,
		modelContainerFields
	}={
		Union[SamplePreparationCacheFields[Object[Sample]],{Name,Type,Volume,State,Status,Composition,IncompatibleMaterials,Container,StorageCondition,RequestedResources,Density}],
		Union[SamplePreparationCacheFields[Object[Container]],{Name,MaxVolume,WettedMaterials,RequestedResources,Connectors}],
		Union[SamplePreparationCacheFields[Model[Container]],{Name,MinVolume,MaxVolume,Sterile,CapConnectionTypes,CapConnectionSizes,Status,WettedMaterials,RequestedResources,Connectors}]
	};
	
	(* Convert the needed fields to packets *)
	{
		packetObjectSample,
		packetObjectContainer,
		packetModelContainer
	}={
		Evaluate[Packet[Sequence@@objectSampleFields]],
		Evaluate[Packet[Container[objectContainerFields]]],
		Evaluate[Packet[Container[Model][modelContainerFields]]]
	};
	
	(* Prepare a separate packet output container models -- if we do not have the sample prep fields in our output containers, it throws an error in the framework. Download::MissingCacheField only gets thrown when prep primitives are put in because the sample prep cache doesn't have MaxVolume field for the container. Since it's a developer only error, we are quieting it *)
	outputContainerFields=Union[SamplePreparationCacheFields[Model[Container]],{Name,MaxVolume,Sterile}];
	packetOutputContainer=Evaluate[Packet[Sequence@@outputContainerFields]];
	
	(* All filter objects *)
	filterObjects= Cases[initialFilter,ObjectReferenceP[Object[Item, Filter, MicrofluidicChip]]];
	reservoirObjects= Cases[initialSampleReservoirs,ObjectReferenceP[Object[Container]]];
	
	(* All other objects to download*)
	allOtherObjects= Cases[Flatten[{instrumentModels,initialInstrument,initialSampleReservoirs,initialFilter,DeleteDuplicates[initialContainers],initialDiafiltrationBuffer,initialFilterPrimeRinseBuffer}],ObjectP[]];
	
	(* Download all packets *)
	downloadedPackets=Quiet[
		Download[
			{
				instrumentObjects,
			sampleReservoirModels,
			filterModels,
			uPulseFilterChipModels,
			tubingModels,
			precutTubingModels,
			Flatten[{outputContainerModels,PreferredContainer[All]}],
			mySamplesWithPreparedSamples,
			mySamplesWithPreparedSamples,
			moleculeModels,
			initialPrecutTubingObjects,
			allOtherObjects
			},
			{
				{Packet[Name, Model]},
				{Packet[Name, MinVolume, MaxVolume, Sterile, CapConnectionTypes,CapConnectionSizes, Connectors, Deprecated, Footprint, Positions,SelfStanding, RentByDefault,DefaultStorageCondition, Aperture, InternalDepth, OpenContainer,Dimensions, InternalDimensions, InternalDiameter, MaxTemperature,MinTemperature, MaxCentrifugationForce, AvailableLayouts,LiquidHandlerAdapter, ContainerMaterials, Immobile,CompatibleCoverFootprints, AluminumFoil, Ampoule, BuiltInCover,CompatibleCoverTypes, Counterweights, EngineDefault, Hermetic,Opaque, Parafilm, RequestedResources, Reusable, RNaseFree,Squeezable, StorageBuffer, StorageBufferVolume, TareWeight,VolumeCalibrations, Model, Status, InletRetentateConnectionType,InletRetentateConnectionSize, PermeateConnectionType,PermeateConnectionSize, InnerDiameter, WettedMaterials,IncompatibleMaterials, DefaultFlowRate, SizeCutoff,FilterSurfaceArea, Density, MembraneMaterial, ModuleFamily,MolecularWeightCutoff]},
				{Packet[Name,ModuleFamily,SizeCutoff,MembraneMaterial,Sterile,FilterSurfaceArea,MinVolume,MaxVolume,InletRetentateConnectionType,InletRetentateConnectionSize,PermeateConnectionType,PermeateConnectionSize,DefaultFlowRate,Connectors,FilterType,RentByDefault]},
				{Packet[MolecularWeightCutoff,MaxVolumeOfUses,MembraneMaterial,Sterile,MinVolume]},
				{Packet[Name,InnerDiameter,Connectors,ParentTubing,Size]},
				{Packet[Name,InnerDiameter,Connectors,ParentTubing,Size]},
				{packetOutputContainer},
				{packetObjectSample,Packet[Composition[[All,2]][{Name,MolecularWeight,Density}]],Packet[StorageCondition[StorageCondition]],Packet[Model[{Name,Density,Deprecated,IncompatibleMaterials}]]},
				{packetObjectContainer},
				{Packet[Name,Density,Viscosity]},
				{Packet[Model]},
				{Packet[Model, VolumeOfUses],Packet[Model],Packet[DefaultStorageCondition, Aperture, InternalDepth, OpenContainer,Dimensions, InternalDimensions, InternalDiameter, MaxTemperature,MinTemperature, MaxCentrifugationForce, AvailableLayouts,LiquidHandlerAdapter, ContainerMaterials, Immobile,CompatibleCoverFootprints, AluminumFoil, Ampoule, BuiltInCover,CompatibleCoverTypes, Counterweights, EngineDefault, Hermetic,Opaque, Parafilm, RequestedResources, Reusable, RNaseFree,Squeezable, StorageBuffer, StorageBufferVolume, TareWeight,VolumeCalibrations, Name, Model, Status, MinVolume, MaxVolume,CapConnectionTypes, CapConnectionSizes, InletRetentateConnectionType,InletRetentateConnectionSize, PermeateConnectionType,PermeateConnectionSize, Connectors, InnerDiameter, WettedMaterials,IncompatibleMaterials, DefaultFlowRate, SizeCutoff,FilterSurfaceArea, Density, MembraneMaterial, ModuleFamily,MolecularWeightCutoff, Sterile, SelfStanding,RentByDefault]}
			},
			Cache->cache,
			Date->Now,
			Simulation->samplePreparationSimulation
		],
		{Download::FieldDoesntExist}
	];

	(* Clean up the cacheball *)
	cacheBall=DeleteDuplicates[FlattenCachePackets[Flatten[{downloadedPackets, cache}]]];
	
	(* Resolve experimental options *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[
			gatherTests,
			resolveExperimentCrossFlowFiltrationOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
			{resolveExperimentCrossFlowFiltrationOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->samplePreparationSimulation],{}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentCrossFlowFiltration,
		resolvedOptions,
		Messages->False
	];
	
	(* If option resolution failed, return early *)
	If[
		MatchQ[resolvedOptionsResult,$Failed]&&!performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests}],
			Options->RemoveHiddenOptions[ExperimentCrossFlowFiltration,collapsedResolvedOptions],
			Simulation->Simulation[],
			Preview->Null
		}]
	];
	
	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];
	
	
	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=Which[
		MatchQ[resolvedOptionsResult,$Failed],{$Failed,Null},
		gatherTests,crossFlowResourcePackets[mySamplesWithPreparedSamples,listedOptions,resolvedOptions,Cache->cacheBall,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
		True,{crossFlowResourcePackets[mySamplesWithPreparedSamples,listedOptions,resolvedOptions,Cache->cacheBall,Simulation->samplePreparationSimulation],{}}
	];
	
	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, updatedSimulation} = If[performSimulationQ,
		simulateExperimentCrossFlowFiltration[
			resourcePackets,
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->samplePreparationSimulation
		],
		{Null, Null}
	];
	
	
	(* If we are not returning the result, return everything else *)
	If[
		!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentCrossFlowFiltration,collapsedResolvedOptions],
			Simulation->updatedSimulation,
			Preview->Null
		}]
	];
	
	(* If we are returning the result, prepare the protocol packet and upload if requested *)
	protocolObject=If[
		!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[expandedSafeOps,Upload],
			Confirm->Lookup[expandedSafeOps,Confirm],
			CanaryBranch->Lookup[expandedSafeOps,CanaryBranch],
			Email->Lookup[expandedSafeOps,Email],
			ParentProtocol->Lookup[expandedSafeOps,ParentProtocol],
			ConstellationMessage->{Object[Protocol,CrossFlowFiltration]},
			Cache->cacheBall,
			Simulation->samplePreparationSimulation
		],
		$Failed
	];
	
	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentCrossFlowFiltration,collapsedResolvedOptions],
		Simulation->updatedSimulation,
		Preview->Null
	}
];


(* ::Subsection:: *)
(*resolveExperimentCrossFlowFiltrationOptions*)


DefineOptions[
	resolveExperimentCrossFlowFiltrationOptions,
	Options:>{
		HelperOutputOption,
		SimulationOption,
		CacheOption
	}
];


resolveExperimentCrossFlowFiltrationOptions[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentCrossFlowFiltrationOptions]]:=Module[
	{
		(* Framework variables *)
		outputSpecification,output,gatherTests,messages,cache,mySamplePrepOptions,myCrossFlowOptions,simulatedSamples,resolvedSamplePrepOptions,samplePrepTests,crossFlowOptionsAssociation,
		
		(* Initial values *)
		initialSampleInVolume,initialSterile,initialFiltrationMode,initialDiafiltrationTarget,initialPrimaryConcentrationTarget,initialSecondaryConcentrationTarget,
		initialTransmembranePressureTarget,initialPermeateAliquotVolume,initialPermeateContainersOut,initialPermeateStorageCondition,initialPrimaryPumpFlowRate,initialDiafiltrationBuffer,
		initialCrossFlowFilters,initialAbsorbanceDataAcquisitionFrequency,initialInstrument,initialSampleReservoirs,initialFilterPrime,initialFilterPrimeBuffer,
		initialFilterPrimeVolume,initialFilterPrimeRinse,initialFilterPrimeRinseBuffer,initialFilterPrimeFlowRate,initialFilterPrimeTransmembranePressureTarget,initialFilterFlush,
		initialFilterFlushBuffer,initialFilterFlushVolume,initialFilterFlushRinse,initialFilterFlushFlowRate,initialFilterFlushTransmembranePressureTarget,initialRetentateContainersOut,
		initialRetentateAliquotVolume,initialRetentateStorageCondition,initialFilterStorageConditions,initialName,initialFastTrack,invalidCompositionInputs,
		initialAbsorbanceChannel,separatedRoundedTargetsOptions,invalidVolumeInputs,
		simulation, updatedSimulation, implyK2RIQ,resolvedInstrument,resolvedInstrumentModel,uPulseQ,initialSizeCutoff,
		
		(* Cacheball extraction *)
		filterModelPackets,tubingModelPackets,precutTubingModelPackets,outputContainerModelPackets,solventModelPackets,instrumentModelPackets,sampleComponentPackets,simulatedSamplePackets,nonDeveloperSampleReservoirs,sampleReservoirModelPackets,sampleModelPackets,inputInstrumentPacket,inputFilterPackets,inputFilterModelPacket,inputSampleReservoirPackets,inputRetentateContainerPacket,inputPermeateContainerPackets,sampleNames,sampleStorageConditionModels,sampleStorageConditionExpression,
		
		(* Input validation check variables *)
		discardedInputs,discardedTest,sampleContainerPackets,sampleVolumes,volumeInformationValidQ,sampleMissingVolumeTest,volumeInformationValidTest,sampleWithoutCompositionList,sampleMissingCompositionTest,
		
		(* Option precision check variables *)
		roundedOptions,mapThreadSafeOptions,precisionTests,roundedSampleInVolumes,roundedFilterPrimeVolume,roundedRetentateAliquotVolume,roundedPermeateAliquotVolumes,roundedFilterFlushVolume,roundedPrimaryPumpFlowRate,roundedFilterPrimeFlowRate,roundedFilterFlushFlowRate,roundedTransmembranePressureTarget,roundedFilterPrimeTransmembranePressureTarget,roundedFilterFlushTransmembranePressureTarget,roundedDiafiltrationTarget,roundedPrimaryConcentrationTarget,roundedSecondaryConcentrationTarget,
		
		(* Conflicting options check variables *)
		validInstrumentQ,validInstrumentTest,resolvedSampleInVolumes,resolvedFiltrationModes,validSampleInVolumeList,crossFlowExceedCapacityList,validFiltrationModeList,validTargetAmountList,validTargetList,failedTargetStepsList, failedTargetValuesList,reservoirCompatibleWithVolumeList,filterCompatibleWithVolumeList,retentateVolumeValidList,permeateVolumeValidList,retentateVolumeSampleCompatibleList,permeateVolumeSampleCompatibleList,permeateVolumesScaleCompatibleList,
		validSampleInVolumeTest,solvent,liquidComponents,solventDensity,resolvedFiltrationMode,validFiltrationModeQ,defaultTotalConcentrationFactor,resolvedPrimaryConcentrationTargets,resolvedSecondaryConcentrationTargets,volumeOutputsValidList,
		resolvedDiafiltrationTargets,concentrationPermeateVolume,concentrationTargets,validTargetAmountsQ,validTargetAmountsTest,targetValidQList,validTargetQ,failedTargetSteps,failedTargetValues,validTargetQTest,inputSampleReservoirVolume,reservoirCompatibleWithVolumeQ,reservoirCompatibleTest,inputFilterVolume,filterCompatibleWithVolumeQ,filterCompatibleTest,inputRetentateContainerVolume,retentateVolumeValidTest,preResolvedPermeateContainerVolume,permeateVolumeValidQ,failedPermeateAliquotVolumes,failedPermeateContainer,failedPermeateContainerVolumes,permeateVolumeValidTest,retentateVolumeSampleCompatibleQ,retentateVolumeSampleCompatibleTest,permeateVolumeSampleCompatibleQ,permeateVolumeSampleCompatibleTest, totalPermeateVolume,permeateVolumesScaleCompatibleQ,permeateVolumesScaleCompatibleTest,specifiedVolumeOutput,
		minFilterVolumes,specifiedTargetOptionList,failingVolumeOutputs,failedRetentateMinSpecificationList,failedRetentateAboveMinOptionList,failedRetentateAboveMinVolumes,minSampleReservoirVolume,failingVolumeOutput,retentateVolumeAboveMinQ,failedRetentateAboveMinVolume,volumeOutputsValidQ,failedVolumeOutputOptionsList,volumeOutputsValidTest,failedRetentateAboveMinOption,failedRetentateMinSpecification,retentateVolumeAboveMinTest,diafiltrationBuffersValidList,diafiltrationBuffersValidQ,diafiltrationBuffersValidTest,filterPrimeOptionsValidList,filterPrimeOptionsValidQ,failedFilterPrimeOptionNames,filterPrimeOptionsValidTest,filterFlushOptionsValidList,filterFlushOptionsValidQ,failedFilterFlushOptionNames,filterFlushRinseValidTest, preResolvedSampleInVolumes,

		(* Options resolver variables *)
		resolvedSterile,resolvedTransmembranePressureTargets,resolvedPermeateContainerOuts,resolvedPermeateStorageConditions,resolvedDiafiltrationBuffers,crossFlowNonOptimalSizeCutoffList,
		 crossFlowFilterSterileUnavailableList, crossFlowDefaultFilterReturnedList,theoreticalRetentateVolume,retentateVolumeValidQ,resolvedRetentateContainersOut,
		componentMolecularWeights,elementSize,databaseDaltonSizeCutoffs,databaseMicronSizeCutoffs,maxSizeCutoff,resolvedFilterPacket,resolvedPrimaryPumpFlowRates,fittingSampleReservoirs,
		numberOfSmallestReservoirs,resolvedSampleReservoirs,resolvedSampleReservoirPacket,sampleReservoirSterileMatchQ,incompatibleInputs,
		resolvedFilterPrimeBuffer,resolvedFilterPrimeVolume,firstDiafiltrationBufferModel,primeSameAsDiafiltrationQ, resolvedFilterPrimeRinse,
		resolvedFilterPrimeRinseBuffer,compatibleFilterPrimeRinseBufferQ,resolvedFilterPrimeFlowRate,resolvedFilterPrimeTransmembranePressureTarget,resolvedFilterFlush, resolvedFilterFlushBuffer,
		resolvedFilterFlushRinse,resolvedFilterFlushVolume,resolvedFilterFlushFlowRate,resolvedFilterFlushTransmembranePressureTarget,resolvedRetentateStorageConditions, resolvedRetentateAliquotVolumes,


		(* Post-resolution error check variables *)
		compatibleSampleQ,incompatibleSampleTest,incompatibleDiafiltrationBuffer,incompatibleDiafiltrationBufferTest,incompatibleFilterPrimeBuffer,incompatibleFilterPrimeBufferTest,
		incompatibleFilterFlushBuffer,incompatibleFilterFlushBufferTest,nameNotUniqueQ,duplicateNameTest,retentateVolumeAboveMinList,sampleReservoirSterileMatchList,

		(* Post-processing and output variables *)
		invalidInputs,invalidOptionsList,invalidOptionErrors,invalidOptions,resolvedAliquotOptions,aliquotTests,resolvedPostProcessingOptions,allOptions,email,
		fastCacheBall, implyUPulseQ,resolvedOptions,allTests,testsRule,resultRule,firstDiafiltrationBuffer, firstFilterPacket, crossFlowSterileMisMatchList,
		maxSizeCutoffs, sizeCutoffsMatchList, specifiedFiltersSteriles,	specifiedSampleReservoirSteriles, specifiedSampleSteriles,kr2iUniqueOptions,
		uPulseUniqueOptions, specifiedKR2iOptions, specifieduPulseOptions, resolvedDiafiltrationModes,	resolvedDiaFiltrationExchangeCounts, preResolvedFilterStorageConditions,
		filterToStorageConditionRules, uniqueFilterToStorageConditionRules, conflictingFilterStorageConditionsList, resolvedFilterStorageConditions, resolvedTubingType,
		filterChipModelPackets, impliedRetentateAliquotQ,resolvedSizeCutoffs,resolvedFilters, uPulseDeadVolume, aliquotWarningMessage, requiredAliquotAmounts, requiredAliquotContainers,
		objectSampleFields,objectContainerFields,modelContainerFields,packetObjectSample,packetObjectContainer,packetModelContainer,allPackets, newCache, invalidSampleReservoirList,failedVolumeOutputErrorMessages,
		diafiltrationList,concentrationList, invalidSampleReservoirTest, conflictingFilterStorageConditionsTest,optionsConflictingWithInstrument,
		optionsConflictingWithInstrumentTest, nullifiedKR2iOptions, invalidFilterTypeList, instrumentRequiredOptions, requiredOptionsWithInstrumentTest,
		invalidCrossFlowFilterOptions, invalidCrossFlowFilterTest, invalidDiafiltrationModeList, invalidDiaFiltrationExchangeCountList,
		invalidDiafiltrationModeOptions, invalidDiafiltrationModeTest, invalidDiaFiltrationExchangeCountOptions, invalidDiaFiltrationExchangeCountTest,
		invalidNumSamplesQ, invalidNumSamplesInputs, invalidNumSamplesTest, allTargetTuples, roundedTargetsOptions, roundedTargetsTests, roundedOptionsNoTargets,
		precisionTestsNoTargets, theoreticalRetentateVolumes, invalidFiltrationModeList, invalidFiltrationModeOptions, invalidFiltrationModeTests,
		finalRetentateVolume, preparationResult, allowedPreparation, preparationTest, invalidDiaFiltrationVolumeList, diafiltrationVolumes,
		invalidDiafiltrationTargetOptions, invalidDiafiltrationTargetTests, resolvedDeadVolumeRecoveryModes, invalidDeadVolumeRecoveryModeList,
		invalidDeadVolumeRecoveryModeOptions, invalidDeadVolumeRecoveryModeTests,compatibleFilterPrimeRinseBufferWarning,crossFlowSterileMisMatchWarnings,
		crossFlowNonOptimalSizeCutoffWarnings,sizeCutoffsMatchWarnings,crossFlowFilterSterileUnavailableWarnings,crossFlowDefaultFilterReturnedWarnings,
		crossFlowExceedCapacityWarnings,resolvedSampleLabels,resolvedSampleContainerLabels,resolvedRetentateContainerOutLabels,resolvedPermeateContainerOutLabels,
		resolvedRetentateSampleOutLabels, resolvedPermeateSampleOutLabels,misMatchedSampleModels, deadVolumeErrorQ, finalRetentateVolumes
	},

	(* Determine the requested output format *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Fetch the cacheball *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

	(* Separate experimental options and sample prep options *)
	{mySamplePrepOptions,myCrossFlowOptions}=splitPrepOptions[myOptions];

	(* Resolve sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentCrossFlowFiltration,mySamples,mySamplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentCrossFlowFiltration,mySamples,mySamplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];
	
	(* Find the fields we need for the sample and its container *)
	{
		objectSampleFields,
		objectContainerFields,
		modelContainerFields
	}={
		Union[SamplePreparationCacheFields[Object[Sample]],{Name,Type,Volume,State,Status,Composition,IncompatibleMaterials,Container,StorageCondition,RequestedResources,Density}],
		Union[SamplePreparationCacheFields[Object[Container]],{Name,MaxVolume,WettedMaterials,RequestedResources,Connectors}],
		Union[SamplePreparationCacheFields[Model[Container]],{Name,MinVolume,MaxVolume,Sterile,CapConnectionTypes,CapConnectionSizes,Status,WettedMaterials,RequestedResources,Connectors}]
	};
	
	(* Convert the needed fields to packets *)
	{
		packetObjectSample,
		packetObjectContainer,
		packetModelContainer
	}={
		Evaluate[Packet[Sequence@@objectSampleFields]],
		Evaluate[Packet[Container[objectContainerFields]]],
		Evaluate[Packet[Container[Model][modelContainerFields]]]
	};
	
	(* make the up front Download call *)
	allPackets = Quiet[
		Download[
			{
				simulatedSamples
			},
			{
				{packetObjectSample,packetObjectContainer,packetModelContainer,Packet[Composition[[All,2]][{Name,MolecularWeight}]],Packet[StorageCondition[StorageCondition]],Packet[Model[{Name,Density,Deprecated,IncompatibleMaterials}]]}
			},
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];
	
	(* Download information we need in both the Options and ResourcePackets functions *)
	newCache = FlattenCachePackets[{cache, allPackets}];
	
	(* Get the fast cache ball *)
	fastCacheBall = makeFastAssocFromCache[newCache];

	(* Convert list of rules to association so we can Lookup, Append, and Join *)
	crossFlowOptionsAssociation=Association@@myCrossFlowOptions;

	(* Lookup the initial values of the options *)
	{
		(*1*)initialSampleInVolume,
		(*2*)initialSterile,
		(*3*)initialFiltrationMode,
		(*4*)initialDiafiltrationTarget,
		(*5*)initialPrimaryConcentrationTarget,
		(*6*)initialSecondaryConcentrationTarget,
		(*7*)initialTransmembranePressureTarget,
		(*8*)initialPermeateAliquotVolume,
		(*9*)initialPermeateContainersOut,
		(*10*)initialPermeateStorageCondition,
		(*11*)initialPrimaryPumpFlowRate,
		(*12*)initialDiafiltrationBuffer,
		(*13*)initialCrossFlowFilters,
		(*14*)initialSizeCutoff,
		(*15*)initialAbsorbanceDataAcquisitionFrequency,
		(*16*)initialInstrument,
		(*17*)initialSampleReservoirs,
		(*18*)initialFilterPrime,
		(*19*)initialFilterPrimeBuffer,
		(*20*)initialFilterPrimeVolume,
		(*21*)initialFilterPrimeRinse,
		(*22*)initialFilterPrimeRinseBuffer,
		(*23*)initialFilterPrimeFlowRate,
		(*24*)initialFilterPrimeTransmembranePressureTarget,
		(*25*)initialFilterFlush,
		(*26*)initialFilterFlushBuffer,
		(*27*)initialFilterFlushVolume,
		(*28*)initialFilterFlushRinse,
		(*29*)initialFilterFlushFlowRate,
		(*30*)initialFilterFlushTransmembranePressureTarget,
		(*31*)initialRetentateContainersOut,
		(*32*)initialRetentateAliquotVolume,
		(*33*)initialRetentateStorageCondition,
		(*34*)initialFilterStorageConditions,
		(*35*)initialName,
		(*36*)initialFastTrack,
		(*37*)initialAbsorbanceChannel
	}=Lookup[
		crossFlowOptionsAssociation,{
			(*1*)SampleInVolume,
			(*2*)Sterile,
			(*3*)FiltrationMode,
			(*4*)DiafiltrationTarget,
			(*5*)PrimaryConcentrationTarget,
			(*6*)SecondaryConcentrationTarget,
			(*7*)TransmembranePressureTarget,
			(*8*)PermeateAliquotVolume,
			(*9*)PermeateContainerOut,
			(*10*)PermeateStorageCondition,
			(*11*)PrimaryPumpFlowRate,
			(*12*)DiafiltrationBuffer,
			(*13*)CrossFlowFilter,
			(*14*)SizeCutoff,
			(*15*)AbsorbanceDataAcquisitionFrequency,
			(*16*)Instrument,
			(*17*)SampleReservoir,
			(*18*)FilterPrime,
			(*19*)FilterPrimeBuffer,
			(*20*)FilterPrimeVolume,
			(*21*)FilterPrimeRinse,
			(*22*)FilterPrimeRinseBuffer,
			(*23*)FilterPrimeFlowRate,
			(*24*)FilterPrimeTransmembranePressureTarget,
			(*25*)FilterFlush,
			(*26*)FilterFlushBuffer,
			(*27*)FilterFlushVolume,
			(*28*)FilterFlushRinse,
			(*29*)FilterFlushFlowRate,
			(*30*)FilterFlushTransmembranePressureTarget,
			(*31*)RetentateContainerOut,
			(*32*)RetentateAliquotVolume,
			(*33*)RetentateStorageCondition,
			(*34*)FilterStorageCondition,
			(*35*)Name,
			(*36*)FastTrack,
			(*37*)AbsorbanceChannel
		}
	];


	(* ---------- EXTRACT PACKETS ---------- *)

	(* Fetch packets that are always present *)
	{
		filterModelPackets,
		filterChipModelPackets,
		tubingModelPackets,
		precutTubingModelPackets,
		outputContainerModelPackets,
		solventModelPackets,
		instrumentModelPackets,
		sampleComponentPackets
	}={
		Select[newCache,MatchQ[Lookup[#,Type],Model[Item,CrossFlowFilter]]&],
		SortBy[Select[newCache,MatchQ[Lookup[#,Type],Model[Item,Filter,MicrofluidicChip]]&], Lookup[#, MolecularWeightCutoff]&],
		Select[newCache,MatchQ[Lookup[#,Type],Model[Plumbing,Tubing]]&],
		Select[newCache,MatchQ[Lookup[#,Type],Model[Plumbing,PrecutTubing]]&],
		Select[newCache,MatchQ[Lookup[#,Type],Model[Container,Vessel]]&],
		Select[newCache,KeyExistsQ[#,Density]&],
		Select[newCache,MatchQ[Lookup[#,Type],Model[Instrument,CrossFlowFiltration]]&],
		Select[newCache,KeyExistsQ[#,MolecularWeight]&]
	};
	
	
	(* Generate the simulatedSamplePackets *)
	simulatedSamplePackets=Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall]&/@simulatedSamples;

	(* We have to pull out the sample reservoirs separately here because if we just pull out the types like above, it also picks up the sample container model. We have to put the samples into a CrossFlowContainer to prevent FRQ warning saying it will be moved. However, if that container makes it into the models for resolution, it always resolves to the container its in already, even if it's a developer object that it should not resolve to, and causes issues with testing reservoir resolution. This shouldn't have real life consequences since we do not let the containers be used for storage *)
	nonDeveloperSampleReservoirs=Search[Model[Container,Vessel,CrossFlowContainer]];
	sampleReservoirModelPackets=Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall]&/@nonDeveloperSampleReservoirs;

	(* Make a packet for the sample model *)
	sampleModelPackets=Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall]&/@Lookup[simulatedSamplePackets,Model];

	(* ----- Check if any input packets exist and fetch them ----- *)

	(* Find the packet for the input instrument *)
	inputInstrumentPacket=If[
		MatchQ[initialInstrument,Except[Automatic]],
		Experiment`Private`fetchPacketFromFastAssoc[initialInstrument,fastCacheBall]
	];

	(* Find the packet for the input filter *)
	inputFilterPackets=If[
		MatchQ[#,Except[Automatic]],
		Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall],
		Null
	]&/@initialCrossFlowFilters;

	inputFilterModelPacket=If[
		NullQ[#],
		#,
		Experiment`Private`fetchPacketFromFastAssoc[Lookup[#,Model],fastCacheBall]
	]&/@inputFilterPackets;

	(* Find the packet for the input sample reservoir *)
	inputSampleReservoirPackets=If[
		MatchQ[#,Except[Automatic]],
		Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall],
		Null
	]&/@initialSampleReservoirs;


	(* Find the packet for the input retentate container *)
	inputRetentateContainerPacket=If[
		MatchQ[#,Except[Automatic]],
		Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall],
		Null
	]&/@initialRetentateContainersOut;

	(* Find the packet for the input permeate container(s) -- The ReplaceAll for empty association removes any objects that are missing from the database so that the lookups do not return errors *)
	inputPermeateContainerPackets=If[
		MatchQ[#,Except[Automatic]],
		Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall],
		Null
	]&/@initialPermeateContainersOut;

	(* Find sample details for nicer error reporting *)
	sampleNames=ToString/@Lookup[simulatedSamplePackets,Object];

	(* Find the sample storage condition model *)
	sampleStorageConditionModels=Download[Lookup[simulatedSamplePackets,StorageCondition,Null],Object];

	(* Look up the storage condition expression from the storage condition packet *)
	sampleStorageConditionExpression=If[
		MatchQ[sampleStorageConditionModels,ObjectP[Model[StorageCondition]]],
		Lookup[Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall]&/@sampleStorageConditionModels,StorageCondition],
		Refrigerator
	];

	(* ---------- INPUT VALIDATION CHECKS ---------- *)

	(* ----- Is sample discarded? ----- *)

	(* Check if sample is discarded *)
	discardedInputs=PickList[sampleNames,Lookup[simulatedSamplePackets,Status,Null],Discarded];

	(* If the sample is discarded and messages are on, throw an error *)
	If[
		(Length[discardedInputs]>0)&&messages,
		Message[Error::DiscardedSamples,discardedInputs]
	];

	(* If gathering tests, create a passing or failing test *)
	discardedTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(Length[discardedInputs]>0),Test["Specified sample "<>sampleNames<>" is not discarded:",True,False],
		gatherTests&&!(Length[discardedInputs]>0),Test["Specified sample "<>sampleNames<>" is not discarded:",True,True]
	];
	
	
	(* --- Resolve the sample preparation method --- *)
	(* -- Always need to be false -- *)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveCrossFlowFiltrationMethod[simulatedSamples, ReplaceRule[myOptions, {Cache->newCache,Simulation->simulation, Output->Result}]],
				{}
			},
			resolveCrossFlowFiltrationMethod[simulatedSamples, ReplaceRule[myOptions, {Cache->newCache,Simulation->simulation, Output->{Result, Tests}}]]
		],
		$Failed
	];
	
	
	(* ----- Does the sample have volume information? ----- *)

	(* Fetch the packet for sample container *)
	sampleContainerPackets=If[
		NullQ[#],
		Null,
		Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall]
	]&/@Download[Lookup[simulatedSamplePackets,Container],Object];

	(* Check if sample has volume information *)
	sampleVolumes=Lookup[simulatedSamplePackets,Volume,Null];

	(* Check if both sample and container volumes are null *)
	invalidVolumeInputs=PickList[sampleNames,sampleVolumes,Null];
	volumeInformationValidQ=Length[invalidVolumeInputs]==0;


	(* Throw a warning or error depending on how much information we have *)
	If[
		(* If neither sample nor container has volume information and messages are on, throw a hard error *)
		!volumeInformationValidQ&&messages,Message[Error::CrossFlowCannotResolveSampleVolume,PickList[sampleNames,sampleVolumes,Null]]
		
	];

	(* If gathering tests, create a passing or failing test *)
	sampleMissingVolumeTest=Which[
		!gatherTests,Nothing,
		gatherTests&&volumeInformationValidQ,Test["Specified sample "<>PickList[sampleNames,sampleVolumes,Null]<>" has volume information:",True,True],
		gatherTests&&!volumeInformationValidQ,Test["Specified sample "<>PickList[sampleNames,sampleVolumes,Null]<>" has volume information:",False,True]
	];

	(* If gathering tests, create a passing or failing test *)
	volumeInformationValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&volumeInformationValidQ,Test["If SampleInVolume is not specified, either the sample or the container has volume information available:",True,True],
		gatherTests&&!volumeInformationValidQ,Test["If SampleInVolume is not specified, either the sample or the container has volume information available:",True,False]
	];

	(* ----- Does the sample have composition information? ----- *)

	(* Check if sample has composition information *)
	sampleWithoutCompositionList=MapThread[
		And[

			(* Sample has composition information *)
			MatchQ[#1,{}],

			(* And filter or cutoff information is not provided -- we only care about the composition for resolving the filter. If the user specifies that, we can move forward *)
			MatchQ[#2,Automatic],
			MatchQ[#3,Automatic]
		]&,
		{
			Lookup[simulatedSamplePackets,Composition,{}],
			Lookup[crossFlowOptionsAssociation,CrossFlowFilter,Null],
			Lookup[crossFlowOptionsAssociation,SizeCutoff,Null]
		}
	];

	(* If the sample has no composition information and messages are on, throw an error *)
	If[
		And[
			AnyTrue[sampleWithoutCompositionList,TrueQ],
			messages,
			Not[MatchQ[$ECLApplication,Engine]]
		],
		Message[Error::CrossFlowMissingCompositionInformation,PickList[sampleNames,sampleWithoutCompositionList,True]]
	];
	
	invalidCompositionInputs = PickList[simulatedSamples,sampleWithoutCompositionList,True];

	(* If gathering tests, create a passing or failing test *)
	sampleMissingCompositionTest=Which[
		!gatherTests,Nothing,
		gatherTests&&sampleWithoutCompositionList,Test["If CrossFlowFilter or SizeCutoff is not specified, sample "<>sampleNames<>" has composition information:",True,False],
		gatherTests&&!sampleWithoutCompositionList,Test["If CrossFlowFilter or SizeCutoff is not specified, sample "<>sampleNames<>" has composition information:",True,True]
	];

	(* ---------- OPTION PRECISION CHECK ---------- *)

	(* ----- Are options specified within instrumental precision? ----- *)
	
	allTargetTuples = Transpose[
		{
			initialDiafiltrationTarget,initialPrimaryConcentrationTarget,initialSecondaryConcentrationTarget
		}
	];
	
	{separatedRoundedTargetsOptions,roundedTargetsTests}=Transpose@Map[
		Function[tuple,
			Module[
				{innterDiafiltrationTarget, innterPrimaryConcentrationTarget, innterSecondaryConcentrationTarget, targetPrecision},
				
				(* get different values from the  *)
				{
					innterDiafiltrationTarget,innterPrimaryConcentrationTarget,innterSecondaryConcentrationTarget
				}=tuple;
				
				(* If specified, find precision based on units, otherwise it doesnt matter, return 1 *)
				(* Find the correct target precision -- we have to hold the expressions because they get evaluated and cause issues with RoundOptionPrecision *)
				targetPrecision=Switch[Units[#],
					UnitsP[1],10^-2,
					UnitsP[Milliliter],0.1 Milliliter,
					_,10^-1 Gram
				]&/@{
					innterDiafiltrationTarget,innterPrimaryConcentrationTarget,innterSecondaryConcentrationTarget
				};
				
				If[
					gatherTests,
					RoundOptionPrecision[
						<|
							DiafiltrationTarget->innterDiafiltrationTarget,
							PrimaryConcentrationTarget->innterPrimaryConcentrationTarget,
							SecondaryConcentrationTarget->innterSecondaryConcentrationTarget
						|>,
						{
							DiafiltrationTarget,
							PrimaryConcentrationTarget,
							SecondaryConcentrationTarget
						},
						targetPrecision,
						Output->{Result,Tests}
					],
					{
						RoundOptionPrecision[
							<|
								DiafiltrationTarget->innterDiafiltrationTarget,
								PrimaryConcentrationTarget->innterPrimaryConcentrationTarget,
								SecondaryConcentrationTarget->innterSecondaryConcentrationTarget
							|>,
							{
								DiafiltrationTarget,
								PrimaryConcentrationTarget,
								SecondaryConcentrationTarget
							},
							targetPrecision,
							Output->Result
						],
						{}
					}
				]
			]
		],
		allTargetTuples
	];
	
	(* Merge all rounded options together *)
	roundedTargetsOptions = Merge[separatedRoundedTargetsOptions, Identity];
	
	(* Round the options *)
	{roundedOptionsNoTargets,precisionTestsNoTargets}=If[
		gatherTests,
		RoundOptionPrecision[
			crossFlowOptionsAssociation,
			{
				SampleInVolume,
				FilterPrimeVolume,
				RetentateAliquotVolume,
				PermeateAliquotVolume,
				FilterFlushVolume,
				PrimaryPumpFlowRate,
				FilterPrimeFlowRate,
				FilterFlushFlowRate,
				TransmembranePressureTarget,
				FilterPrimeTransmembranePressureTarget,
				FilterFlushTransmembranePressureTarget
			},
			{
				1 Milliliter,
				1 Milliliter,
				1 Milliliter,
				1 Milliliter,
				1 Milliliter,
				10^-1 Milliliter/Minute,
				10^-1 Milliliter/Minute,
				10^-1 Milliliter/Minute,
				10^-1 PSI,
				10^-1 PSI,
				10^-1 PSI
			},
			Output->{Result,Tests}
		],
		{
			RoundOptionPrecision[
				crossFlowOptionsAssociation,
				{
					SampleInVolume,
					FilterPrimeVolume,
					RetentateAliquotVolume,
					PermeateAliquotVolume,
					FilterFlushVolume,
					PrimaryPumpFlowRate,
					FilterPrimeFlowRate,
					FilterFlushFlowRate,
					TransmembranePressureTarget,
					FilterPrimeTransmembranePressureTarget,
					FilterFlushTransmembranePressureTarget
				},
				{
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					10^-1 Milliliter/Minute,
					10^-1 Milliliter/Minute,
					10^-1 Milliliter/Minute,
					10^-1 PSI,
					10^-1 PSI,
					10^-1 PSI
				},
				Output->Result
			],
			{}
		}
	
	];
	
	(* Merge all options and tests together *)
	roundedOptions = Join[roundedOptionsNoTargets,roundedTargetsOptions];
	precisionTests = Join[precisionTestsNoTargets,roundedTargetsTests];

	(* Update any rounded options *)
	{
		roundedSampleInVolumes,
		roundedFilterPrimeVolume,
		roundedRetentateAliquotVolume,
		roundedPermeateAliquotVolumes,
		roundedFilterFlushVolume,
		roundedPrimaryPumpFlowRate,
		roundedFilterPrimeFlowRate,
		roundedFilterFlushFlowRate,
		roundedTransmembranePressureTarget,
		roundedFilterPrimeTransmembranePressureTarget,
		roundedFilterFlushTransmembranePressureTarget,
		roundedDiafiltrationTarget,
		roundedPrimaryConcentrationTarget,
		roundedSecondaryConcentrationTarget
	}={
		Lookup[roundedOptions,SampleInVolume],
		Lookup[roundedOptions,FilterPrimeVolume],
		Lookup[roundedOptions,RetentateAliquotVolume],
		Lookup[roundedOptions,PermeateAliquotVolume],
		Lookup[roundedOptions,FilterFlushVolume],
		Lookup[roundedOptions,PrimaryPumpFlowRate],
		Lookup[roundedOptions,FilterPrimeFlowRate],
		Lookup[roundedOptions,FilterFlushFlowRate],
		Lookup[roundedOptions,TransmembranePressureTarget],
		Lookup[roundedOptions,FilterPrimeTransmembranePressureTarget],
		Lookup[roundedOptions,FilterFlushTransmembranePressureTarget],
		Lookup[roundedOptions,DiafiltrationTarget],
		Lookup[roundedOptions,PrimaryConcentrationTarget],
		Lookup[roundedOptions,SecondaryConcentrationTarget]
	};

	(* ---------- MISCELLANEOUS OPTION Resolver and Check ---------- *)
	(* first of all which instrument should we use *)

	(* First to check all the volume of the sample *)
	preResolvedSampleInVolumes=MapThread[
		Function[{sampleInVolume, aliquotAmount, samplePacket},
			Which[

				(* If SampleInVolume is defined, use it *)
				MatchQ[sampleInVolume,Except[Automatic]],sampleInVolume,
				
				(* If AliquotAmount is defined, use it *)
				MatchQ[aliquotAmount, UnitsP[Milliliter]],aliquotAmount,
				
				(* Otherwise,use the entire sample *)
				MatchQ[samplePacket,PacketP[]],
				If[
					MatchQ[Lookup[samplePacket,Volume],UnitsP[Milliliter]],
					Lookup[samplePacket,Volume],
					45 Milliliter
				],
				True,
				45 Milliliter
			]
		],
		{roundedSampleInVolumes, Lookup[mySamplePrepOptions,AliquotAmount],simulatedSamplePackets}

	];

	(* ---------- CONFLICTING OPTIONS CHECKS ---------- *)
	(* ----- Is Instrument Retired/Deprecated? ----- *)
	
	kr2iUniqueOptions = {
		TransmembranePressureTarget,
		PrimaryPumpFlowRate,
		TubingType,
		FilterPrimeFlowRate,
		FilterPrimeTransmembranePressureTarget,
		FilterFlushFlowRate,
		FilterFlushTransmembranePressureTarget
	};
	
	uPulseUniqueOptions = {DiafiltrationMode, DiafiltrationExchangeCount, DeadVolumeRecoveryMode};
	
	(* Check if user already specified any instrument specific options *)
	specifiedKR2iOptions= Map[
		Function[
			optionName,
			With[
				{value = Lookup[crossFlowOptionsAssociation, optionName]},
				MatchQ[value, Except[ListableP[(Automatic|Null)]]]
			]
		],
		kr2iUniqueOptions
	];
	
	specifieduPulseOptions= Map[
		Function[
			optionName,
			With[
				{value = Lookup[crossFlowOptionsAssociation, optionName]},
				MatchQ[value, Except[ListableP[(Automatic|Null)]]]
			]
		],
		uPulseUniqueOptions
	];
	
	(* Based on all these qualifications, check if user specified using any of the instrument *)
	implyUPulseQ=Or[Length[simulatedSamples]>1,AllTrue[preResolvedSampleInVolumes,LessEqualQ[#, 50 Milliliter]&]];
	implyK2RIQ=Or[AnyTrue[preResolvedSampleInVolumes, GreaterQ[#, 50 Milliliter]&]];
	
	
	(* Check if an instrument was specified and that it is not retired or deprecated *)
	resolvedInstrument=Which[

		(* Use user specified value *)
		MatchQ[initialInstrument,Except[Automatic]],initialInstrument,
		
		(* check if instrument specific options were specified *)
		Or@@specifieduPulseOptions,Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
		Or@@specifiedKR2iOptions,Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],

		(* check if user imply using either one of the instrument *)
		implyUPulseQ,Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
		implyK2RIQ,Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],

		(* If not, default to use the small crossflow instrument *)
		True,Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]
	];

	(* Get the model of resolved instrument*)
	resolvedInstrumentModel= If[
		MatchQ[resolvedInstrument,ObjectReferenceP[Model[Instrument]]],
		resolvedInstrument,
		Download[fastAssocLookup[fastCacheBall, resolvedInstrument, Model], Object]
	];

	(* build a boolean to indicate which instrument we are using *)
	uPulseQ = MatchQ[resolvedInstrumentModel, ObjectReferenceP[Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]]];
	
	(* check number of Samples is valid *)
	invalidNumSamplesQ= If[
		uPulseQ,
		Length[simulatedSamples] > 10,
		Length[simulatedSamples] > 1
	];
	
	(* If there are too many samples specified, and messages are on, throw a hard error *)
	invalidNumSamplesInputs=Which[
		
		invalidNumSamplesQ&&messages&&uPulseQ,
		Message[Error::CrossFlowTooManySamples,resolvedInstrumentModel,Length[simulatedSamples]];simulatedSamples,
		
		invalidNumSamplesQ&&messages,
		Message[Error::CrossFlowKR2ICannotRunMultipleSamples,resolvedInstrumentModel,Length[simulatedSamples]];simulatedSamples,
		
		True,
		Nothing
	];
	
	(* If gathering tests, create a passing or failing test *)
	invalidNumSamplesTest=Which[
		!gatherTests,Nothing,
		gatherTests&&uPulseQ,Test["Less than 10 samples are specified when using uPulse:",Not[invalidNumSamplesQ],True],
		gatherTests,Test["KR2i can only run one sample per time:",invalidNumSamplesQ,False]
	];
	
	(*	Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall]&/@simulatedSamples*)
	validInstrumentQ=If[
		MatchQ[resolvedInstrument ,ObjectP[Object[Instrument,CrossFlowFiltration]]],
		MatchQ[Lookup[inputInstrumentPacket,Status,Null],Except[Retired|Deprecated]],
		True
	];

	(* If the instrument is retired or deprecated and messages are on, throw an error *)
	If[
		!validInstrumentQ&&messages,
		Message[Error::CrossFlowUnsupportedInstrument,Lookup[inputInstrumentPacket,Name],Lookup[inputInstrumentPacket,Status]]
	];

	(* If gathering tests, create a passing or failing test *)
	validInstrumentTest=Which[
		!gatherTests,Nothing,
		gatherTests&&validInstrumentQ,Test["Specified instrument is not retired or deprecated:",True,True],
		gatherTests&&!validInstrumentQ,Test["Specified instrument is not retired or deprecated:",True,False]
	];
	
	(* Check if instrument specified options are conflicting with specified options *)
	optionsConflictingWithInstrument = If[
		uPulseQ,
		PickList[kr2iUniqueOptions,specifiedKR2iOptions,True],
		PickList[uPulseUniqueOptions,specifieduPulseOptions,True]
	];
	
	(* If there are specified options that conflict with the instrument and messages are on, throw an error *)
	If[
		(Length[optionsConflictingWithInstrument]>0)&&messages,
		Message[Error::CrossFlowFiltrationUnneededOptions,optionsConflictingWithInstrument,resolvedInstrument];
	];
	
	(* If gathering tests, create a passing or failing test *)
	optionsConflictingWithInstrumentTest=If[
		gatherTests,
		Test["Specified options are not conflicting with the Instrument",(Length[optionsConflictingWithInstrument]==0),True],
		Nothing
	];
	
	(* Some options cannot be specified as Null *)
	(* Check if user already specified any instrument specific options *)
	nullifiedKR2iOptions= Map[
		Function[
			optionName,
			With[
				{value = Lookup[crossFlowOptionsAssociation, optionName]},
				NullQ[value]
			]
		],
		{TransmembranePressureTarget, PrimaryPumpFlowRate, TubingType}
	];
	
	(* Check if instrument specified options are conflicting with specified options *)
	instrumentRequiredOptions = If[
		uPulseQ,
		{},
		PickList[{TransmembranePressureTarget, PrimaryPumpFlowRate, TubingType},nullifiedKR2iOptions,True]
	];
	
	(* If options are specified as null that can't be and messages are on, throw an error *)
	If[
		(Length[instrumentRequiredOptions]>0)&&messages,
		Message[Error::CrossFlowFiltrationRequiredOptions,instrumentRequiredOptions,resolvedInstrument];
	];
	
	(* If gathering tests, create a passing or failing test *)
	requiredOptionsWithInstrumentTest=If[
		gatherTests,
		Test["Specified options are not conflicting with options",(Length[optionsConflictingWithInstrument]==0),True],
		Nothing
	];
	
	(* ----- Resolve Sterile ----- *)
	specifiedFiltersSteriles = Map[
		Function[eachPacket,
			If[
				NullQ[eachPacket],
				False,
				Lookup[eachPacket,Sterile,False]
			]/.Null->False
		],
		inputFilterPackets
	];
	
	specifiedSampleReservoirSteriles = If[
		uPulseQ,
		False,
		Map[
			Function[eachPacket,
				If[
					NullQ[eachPacket],
					False,
					Lookup[eachPacket,Sterile,False]
				]/.Null->False
			],
			inputSampleReservoirPackets
		]
	];
	
	specifiedSampleSteriles = Map[
		Function[eachPacket,
			If[
				NullQ[eachPacket],
				False,
				Lookup[eachPacket,Sterile,False]
			]/.Null->False
		],
		simulatedSamplePackets
	];
	
	(* First check if *)
	resolvedSterile=Which[
		
		(* If Sterile is specified, use it *)
		MatchQ[initialSterile,Except[Automatic]],initialSterile,
		
		(* If both filter and sample reservoir is specified, go with sterile if both the filter and the reservoir are sterile *)
		MatchQ[initialCrossFlowFilters,Except[{Automatic..}]]&&MatchQ[initialSampleReservoirs,Except[{Automatic..}]],
		And@@(Flatten[{specifiedFiltersSteriles, specifiedSampleReservoirSteriles}]),
		
		(* If filter is specified, check if the filter sterility *)
		MatchQ[initialCrossFlowFilters,Except[{Automatic..}]],And@@specifiedFiltersSteriles,
		
		(* If sample reservoir is specified, check if it is sterile *)
		MatchQ[initialSampleReservoirs,Except[{Automatic..}]],And@@specifiedSampleReservoirSteriles,
		
		(* Otherwise, use the sample sterility *)
		True,And@@specifiedSampleSteriles
	];
	
	(* Resolve the tubing type *)
	resolvedTubingType = Which[
		
		(* Use user specified value *)
		MatchQ[Lookup[crossFlowOptionsAssociation,TubingType],Except[Automatic]],
		Lookup[crossFlowOptionsAssociation,TubingType],
		
		(* Else resolve based on the instrument, for uPulse, set to Null, for KR2i set to PharmaPure *)
		uPulseQ, Null,
		True, PharmaPure
	];
	
	(* transfer the options to be the mapThread Safe options *)
	mapThreadSafeOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCrossFlowFiltration,roundedOptions];
	
	(* The big mapthread *)
	{
		(*1*)resolvedSampleInVolumes,
		(*2*)resolvedFiltrationModes,
		(*3*)resolvedPrimaryConcentrationTargets,
		(*4*)resolvedSecondaryConcentrationTargets,
		(*5*)resolvedDiafiltrationTargets,
		(*6*)resolvedSizeCutoffs,
		(*7*)resolvedFilters,
		(*8*)resolvedSampleReservoirs,
		(*9*)resolvedTransmembranePressureTargets,
		(*10*)resolvedPermeateContainerOuts,
		(*11*)resolvedPermeateStorageConditions,
		(*12*)resolvedPrimaryPumpFlowRates,
		(*13*)resolvedDiafiltrationBuffers,
		(*14*)resolvedRetentateContainersOut,
		(*15*)resolvedRetentateStorageConditions,
		(*16*)resolvedRetentateAliquotVolumes,
		(*17*)resolvedDiafiltrationModes,
		(*18*)resolvedDiaFiltrationExchangeCounts,
		(*19*)resolvedDeadVolumeRecoveryModes,

		(* misc values *)
		(*1*)minFilterVolumes,
		(*2*)specifiedTargetOptionList,
		(*3*)failingVolumeOutputs,
		(*4*)failedRetentateAboveMinOptionList,
		(*5*)failedRetentateMinSpecificationList,
		(*6*)failedRetentateAboveMinVolumes,
		(*7*)maxSizeCutoffs,
		(*8*)diafiltrationList,
		(*9*)concentrationList,
		(*10*)theoreticalRetentateVolumes,
		(*11*)diafiltrationVolumes,
		(*12*)finalRetentateVolumes,

		(*valid checks*)
		(*1*)validSampleInVolumeList,
		(*2*)crossFlowExceedCapacityList,
		(*3*)validFiltrationModeList,
		(*4*)validTargetAmountList,
		(*5*)validTargetList,
		(*6*)failedTargetStepsList,
		(*7*)failedTargetValuesList,
		(*8*)reservoirCompatibleWithVolumeList,
		(*9*)filterCompatibleWithVolumeList,
		(*10*)retentateVolumeValidList,
		(*11*)permeateVolumeValidList,
		(*12*)retentateVolumeSampleCompatibleList,
		(*13*)permeateVolumeSampleCompatibleList,
		(*14*)permeateVolumesScaleCompatibleList,
		(*15*)volumeOutputsValidList,
		(*16*)diafiltrationBuffersValidList,
		(*17*)crossFlowNonOptimalSizeCutoffList,
		(*18*)crossFlowFilterSterileUnavailableList,
		(*19*)crossFlowDefaultFilterReturnedList,
		(*20*)retentateVolumeAboveMinList,
		(*21*)sampleReservoirSterileMatchList,
		(*22*)sizeCutoffsMatchList,
		(*23*)invalidSampleReservoirList,
		(*24*)invalidFilterTypeList,
		(*25*)invalidDiafiltrationModeList,
		(*26*)invalidDiaFiltrationExchangeCountList,
		(*27*)invalidFiltrationModeList,
		(*28*)invalidDiaFiltrationVolumeList,
		(*29*)invalidDeadVolumeRecoveryModeList
	} = Transpose@MapThread[
		Function[
			{
				(*1*)optionSet,
				(*2*)preResolvedSampleInVolume,
				(*3*)inputSampleReservoirPacket,
				(*4*)sampleWithoutCompositionQ,
				(*5*)samplePacket,
				(*6*)sampleModelPacket,
				(*7*)inputFilterPacket,
				(*8*)inputPermeateContainerPacket,
				(*9*)sampleContainerPacket
			},

			Module[
				{
					resolvedFilter,resolvedSampleInVolume,resolvedPrimaryConcentrationTarget, resolvedSecondaryConcentrationTarget,
					resolvedDiafiltrationTarget, resolvedSizeCutoff, resolvedSampleReservoir, resolvedTransmembranePressureTarget,
					resolvedPermeateContainerOut, resolvedPermeateStorageCondition, resolvedPrimaryPumpFlowRate, resolvedDiafiltrationBuffer,
					resolvedRetentateContainerOut, resolvedRetentateStorageCondition, resolvedRetentateAliquotVolume, resolvedDiafiltrationMode,
					resolvedDiaFiltrationExchangeCount, specifiedTargetOptions, diafiltrationBuffersBooleans,
					minFilterVolume,diafiltrationPermeateVolume, crossFlowNonOptimalSizeCutoffQ,crossFlowFilterSterileUnavailableQ,
					crossFlowDefaultFilterReturnedQ,validSampleInVolumeQ, crossFlowExceedCapacityQ, sizeCutoffsMatchQ,
					instrumentMaxVolume, diafiltrationQ, concentrationQ, invalidSampleReservoirQ, invalidFilterTypeQ,
					invalidDiafiltrationModeQ, invalidDiaFiltrationExchangeCountQ, invalidFiltrationModeQ, invalidDiaFiltrationVolumeQ,
					resolvedDeadVolumeRecoveryMode, invalidDeadVolumeRecoveryModeQ
				},
				
				(* Instrument max volume *)
				instrumentMaxVolume = If[uPulseQ,50 Milliliter, 2 Liter];
				
				(*Init those error checks to be false*)
				crossFlowExceedCapacityQ=False;
				
				(* Resolve the volume within the current bounds of the experiment *)
				resolvedSampleInVolume=Which[
					(* Use the user specified value *)
					MatchQ[Lookup[optionSet,SampleInVolume], Except[Automatic]],Lookup[optionSet,SampleInVolume],

					(* Resolve the sample in volume for KR2i*)
					(preResolvedSampleInVolume <= instrumentMaxVolume) && Not[uPulseQ], Max[UnitConvert[preResolvedSampleInVolume,Milliliter],100 Milliliter],
					
					(* Resolve it for uPulse *)
					(preResolvedSampleInVolume <= instrumentMaxVolume), Min[UnitConvert[preResolvedSampleInVolume,Milliliter],50 Milliliter],
					
					(* Throw a warning saying we are capping the sample volume and return instrumentMaxVolume *)
					uPulseQ, (
						crossFlowExceedCapacityQ=True;
						45 Milliliter
					),
					True, (
						crossFlowExceedCapacityQ=True;
						2 Liter
					)
				];

				(* Determine if our volume is too small *)
				If[uPulseQ&&LessQ[resolvedSampleInVolume,1 Milliliter],
					(* If it is, default our resolved volume to 1 Milliliter so the rest of the resolver is happy *)
					resolvedSampleInVolume = 1 Milliliter;
				];

				(* -- housekeeping - make sure to know filter and reservoir's minimum volume --*)
				(* Find the minimum volume of the filter *)
				minFilterVolume=Which[

					(* If filter is specified, return its min volume *)
					MatchQ[Lookup[optionSet,CrossFlowFilter],ObjectReferenceP[{Model[Item]}]],
					Lookup[inputFilterPacket,MinVolume]/.Null->0Milliliter,
					
					(* If filter is specified, return its min volume *)
					MatchQ[Lookup[optionSet,CrossFlowFilter],ObjectReferenceP[{Object[Item]}]],
					fastAssocLookup[fastCacheBall, Lookup[optionSet, CrossFlowFilter], {Model, MinVolume}]/.Null->0Milliliter,

					(* Otherwise, find the minimum volume amongst filters that can fit our sample volume *)
					True, Min[Lookup[Select[filterModelPackets,And[Lookup[#,MinVolume,0 Milliliter]<=resolvedSampleInVolume<=Lookup[#,MaxVolume,0 Milliliter]]&],MinVolume]]
				];
				

				(* Find the minimum volume of the sample reservoir *)
				minSampleReservoirVolume=Which[

					(* If sample reservoir is specified, return its min volume *)
					MatchQ[Lookup[optionSet,SampleReservoir],Except[Automatic]], Lookup[inputSampleReservoirPacket,MinVolume],

					(* if we're using the micro pulse, then use 1.5mL *)
					(* NOTE: This value was changed after extensive testing with the uPulse determined that 1mL was an absolute lower limit *)
					(* due to physical constraints of the uPulse tube reaching inside the 50mL tube *)
					(* $MinMicropulseRetentateVolume was chosen to provide a slight buffer against pulling air into the system *)
					uPulseQ, $MinMicropulseRetentateVolume,

					(* Otherwise, find the minimum volume amongst containers that can fit our sample volume *)
					True, Min[Lookup[Select[sampleReservoirModelPackets,And[Lookup[#,MinVolume,0 Milliliter]<=resolvedSampleInVolume<=Lookup[#,MaxVolume,0 Milliliter]]&],MinVolume]]
				];

				(*Check if the sample in volume is larger than the remaining sample volume*)
				validSampleInVolumeQ = If[uPulseQ, True, (resolvedSampleInVolume <= Lookup[samplePacket, Volume])];
				
				(* ----- Is SampleInVolume compatible with Targets? ----- *)
				(* Find the solvent *)
				solvent=ToList@Which[

					(* If targets are not specified as weight or there is no composition, skip this step as that is the only use for the solvent density *)
					Or[!MemberQ[MatchQ[#,UnitsP[1 Gram]]&/@Lookup[optionSet,{DiafiltrationTarget,PrimaryConcentrationTarget,SecondaryConcentrationTarget}],True],sampleWithoutCompositionQ],"No weight targets",

					(* If solvent field for sample is informed, use it *)
					!MatchQ[Lookup[samplePacket,Solvent,Null],Null|{}],
						Module[{},

							(* Find the liquid components, which are the solvents -- this is used below for density calculations, so we need to set this variable here *)
							liquidComponents={{100VolumePercent, Download[Lookup[samplePacket,Solvent],Object]}};

							(* Return the molecules as our solvent *)
							Download[ToList[Lookup[samplePacket,Solvent]],Object]
						],

					(* Otherwise, find the solvent *)
					True,
						Module[{componentsAmount,solventPositions},

							(* Get all components and their amounts*)
							componentsAmount={First[#],Download[#[[2]],Object]}&/@Lookup[samplePacket,Composition,{}];

							(* Find the liquid components *)
							liquidComponents=Select[componentsAmount,MatchQ[First[#],Alternatives[UnitsP[IndependentUnit["VolumePercent"]],UnitsP[1 VolumePercent]]]&];

							(* Find the positions of the solvents *)
							solventPositions=If[

								(* If we have liquid components, find their positions *)
								MatchQ[liquidComponents,Except[{}]],
								Flatten[Position[componentsAmount,#]&/@liquidComponents],

								(* Otherwise, we don't have a solvent *)
								Null
							];

							(* If we found a solvent, return it *)
							If[
								MatchQ[solventPositions,Except[Null]],
								Last/@Part[componentsAmount,solventPositions],
								Null
							]
						]
				];

				(* Find the density of the solvent *)
				solventDensity=Which[

					(* If targets are not specified as weight, skip this step as that is the only use for the solvent density *)
					!MemberQ[MatchQ[#,UnitsP[1 Gram]]&/@Lookup[optionSet,{DiafiltrationTarget,PrimaryConcentrationTarget,SecondaryConcentrationTarget}],True],1 Gram/Milliliter,

					(* If there is no composition, skip this step -- we are erroring out so return a reasonable value to prevent a red wall *)
					sampleWithoutCompositionQ,1 Gram/Milliliter,

					(* If sample has density, use it *)
					!NullQ[Lookup[samplePacket,Density]],Lookup[samplePacket,Density],

					(* If sample's model has density, use it *)
					!NullQ[Lookup[sampleModelPacket,Density]],Lookup[sampleModelPacket,Density],

					(* If we found a solvent, use that *)
					!NullQ[solvent],Module[{solventPackets,solventDensities,finalDensity,densityReallyMissing},

						(* Fetch the packets for the solvent molecules *)
						solventPackets=Experiment`Private`fetchPacketFromFastAssoc[#,fastCacheBall]&/@solvent;

						(* Lookup the densities for the solvent molecules *)
						solventDensities=Lookup[solventPackets,Density,Null];

						(* Calculate the density *)
						finalDensity=If[

							(* If we have all the densities, weight it by the volume amount -- This method is not a great way of calculating the density for multiple solvents but unfortunately, without knowing the density of the actual solvent, we don't have a lot of options here *)
							!MemberQ[solventDensities,Null],
							Total[MapThread[
								#1/100*#2&,
								{Unitless[First/@liquidComponents],solventDensities}
							]],
							Module[{redownloadedDensity},

								(* Check if the density is really missing in the database -- we are adding this here because assumed density pops up in ~1% of tests randomly even though the density is in the database. It's too rare and sporadic to figure out what is going on, but as far as I can tell, it has to do with the fact that every once in a while, something goes wrong with grabbing the data. So we are going to double check with the database in cases where we can't find the density to eliminate those sporadic cases *)
								redownloadedDensity=Download[solvent,Density];
								densityReallyMissing=MemberQ[redownloadedDensity,Null];

								(* Return assumed/redownloaded value *)
								If[
									densityReallyMissing,
									1 Gram/Milliliter,
									Total[MapThread[
										#1/100*#2&,
										{Unitless[First/@liquidComponents],redownloadedDensity}
									]]
								]
							]
						];

						(* Display a warning indicating that we are assuming the density -- we not warning if sample composition is invalid since we are already erroring out in that case *)
						Which[

							(* If we have more than one solvent in the calculation, warn the user we did the weighted average *)
							Length[solvent]>1&&messages&&!MatchQ[$ECLApplication,Engine],
							Message[Warning::CrossFlowAssumedDensity," combined","s",finalDensity],

							(* If we only couldn't find the density, warn the user we assumed it was 1 g/mL *)
							densityReallyMissing&&messages&&!MatchQ[$ECLApplication,Engine],
							Message[Warning::CrossFlowAssumedDensity,"","",finalDensity]
						];

						(* Return the density *)
						finalDensity
					],

					(* Otherwise, we couldn't find a solvent so return 1 g/mL with a warning *)
					True,1 Gram/Milliliter
				];
				
				
				(* Find the filtration mode we have to pre-resolve the mode here since just about everything will need this in error checking *)
				{resolvedFiltrationMode, validFiltrationModeQ} =Which[

					(* If specified, use it *)
					MatchQ[Lookup[optionSet, FiltrationMode],Except[Automatic]],
					{Lookup[optionSet, FiltrationMode], MatchQ[Lookup[optionSet, FiltrationMode],Except[Null]]},

					(* if it isnt specified, see if any of the relevant targets are specified *)

					(* If diafiltration, primary concentration and or secondary concentration targets are specified, resolve to ConcentrationDiafiltrationConcentration*)
					MatchQ[Lookup[optionSet, DiafiltrationTarget],Except[Null]]&&MatchQ[Lookup[optionSet, PrimaryConcentrationTarget],Except[Null]]&&MatchQ[Lookup[optionSet, SecondaryConcentrationTarget],Except[Null|Automatic]],
					{ConcentrationDiafiltrationConcentration, And@@(MatchQ[#,Except[Null]]&/@{Lookup[optionSet, DiafiltrationTarget],Lookup[optionSet, PrimaryConcentrationTarget],Lookup[optionSet, SecondaryConcentrationTarget]})},

					(* If diafiltration and primary concentration but not secondary concentration targets are specified, resolve to ConcentrationDiafiltration*)
					MatchQ[Lookup[optionSet, DiafiltrationTarget],Except[Null|Automatic]]&&MatchQ[Lookup[optionSet, PrimaryConcentrationTarget],Except[Null|Automatic]]&&MatchQ[Lookup[optionSet, SecondaryConcentrationTarget],Alternatives[Null,Automatic]],
					{ConcentrationDiafiltration, And@@(MatchQ[#,Except[Null]]&/@{Lookup[optionSet, DiafiltrationTarget],Lookup[optionSet, PrimaryConcentrationTarget]})},

					(* If only diafiltration and not primary or secondary concentration targets are specified, resolve to ConcentrationDiafiltrationConcentration*)
					MatchQ[Lookup[optionSet, DiafiltrationTarget],Except[Null|Automatic]]&&MatchQ[Lookup[optionSet, PrimaryConcentrationTarget],Alternatives[Null,Automatic]]&&MatchQ[Lookup[optionSet, SecondaryConcentrationTarget],Alternatives[Null,Automatic]],
					{ConcentrationDiafiltrationConcentration, And@@(MatchQ[#,Except[Null]]&/@{Lookup[optionSet, DiafiltrationTarget]})},

					(* If only primary concentration and not diafiltration or secondary concentration targets are specified, resolve to ConcentrationDiafiltration*)
					MatchQ[Lookup[optionSet, DiafiltrationBuffer],Except[Null|Automatic]]&&MatchQ[Lookup[optionSet, DiafiltrationTarget],Alternatives[Null,Automatic]]&&MatchQ[Lookup[optionSet, PrimaryConcentrationTarget],Except[Null]]&&MatchQ[Lookup[optionSet, SecondaryConcentrationTarget],Alternatives[Null,Automatic]],
					{ConcentrationDiafiltration, And@@(MatchQ[#,Except[Null]]&/@{Lookup[optionSet, PrimaryConcentrationTarget]})},
					
					(* If only primary concentration and not diafiltration or secondary concentration targets are specified, resolve to Concentration*)
					MatchQ[Lookup[optionSet, DiafiltrationTarget],Alternatives[Null,Automatic]]&&MatchQ[Lookup[optionSet, PrimaryConcentrationTarget],Except[Null]]&&MatchQ[Lookup[optionSet, SecondaryConcentrationTarget],Alternatives[Null,Automatic]],
					{Concentration, And@@(MatchQ[#,Except[Null]]&/@{Lookup[optionSet, PrimaryConcentrationTarget]})},
					
					(* Otherwise, return a single concentration step *)
					True,
					{Concentration, False}
				];
				
				(* Check if the user specified Diafiltration as the filtration mode, uPulse won't support that  *)
				invalidFiltrationModeQ=If[uPulseQ,
					MatchQ[resolvedFiltrationMode,Diafiltration],
					False
				];
				
				
				(* keep tabs on what we're doing here *)
				diafiltrationQ = MatchQ[resolvedFiltrationMode, Alternatives[ConcentrationDiafiltrationConcentration,ConcentrationDiafiltration,Diafiltration]];
				concentrationQ = MatchQ[resolvedFiltrationMode, Alternatives[ConcentrationDiafiltrationConcentration,ConcentrationDiafiltration,Concentration]];

				(* helper function to convert targets to fold *)
				convertToFold[target_, option_]:= If[MatchQ[option, DiafiltrationTarget],
					Which[
						(* If defined as fold sample volume, multiply by sample volume *)
						MatchQ[target,UnitsP[1]],target,

						(* If defined as volume, convert to fold *)
						MatchQ[target,UnitsP[1 Milliliter]],SafeRound[N[target/resolvedSampleInVolume],10^-2],

						(* If defined as weight, divide by density and convert to fold*)
						MatchQ[target,UnitsP[1 Gram]],SafeRound[N[UnitConvert[target/solventDensity,Milliliter]/resolvedSampleInVolume],10^-2],

						(* There are no other conditions but return a logical number as the default anyway *)
						True,1
					],
					Which[
						(* If defined as fold sample volume, multiply by sample volume *)
						MatchQ[target,UnitsP[1]],target,

						(* If defined as volume, convert to fold *)
						MatchQ[target,UnitsP[1 Milliliter]],SafeRound[N[resolvedSampleInVolume/target],10^-2],

						(* If defined as weight, divide by density and convert to fold*)
						MatchQ[target,UnitsP[1 Gram]],SafeRound[N[resolvedSampleInVolume/UnitConvert[target/solventDensity,Milliliter]],10^-2],

						(* There are no other conditions but return a logical number as the default anyway *)
						True,1
					]
				];

				(* check if there's a constraint for maximum concentration due to sample or filter minimum volume. if not set default target to 5 for KR2i and 10 for uPulse *)
				defaultTotalConcentrationFactor = Module[{concentrationFactorByContainerConstraint},
					concentrationFactorByContainerConstraint = Round[resolvedSampleInVolume / Max[minSampleReservoirVolume, minFilterVolume],0.1];

					(* return the smaller of the possible concentration factors, either by container constraint or default *)
					Min[concentrationFactorByContainerConstraint,If[uPulseQ,10,5]]
				];

				(* resolve concentration targets (probably should have nested the which in a switch for filtration mode..)*)
				{resolvedPrimaryConcentrationTarget, resolvedSecondaryConcentrationTarget} = Which[
					(* if specified, just use it *)
					MatchQ[Lookup[optionSet,PrimaryConcentrationTarget], Except[Automatic]]&&MatchQ[Lookup[optionSet,SecondaryConcentrationTarget], Except[Automatic]],
					{Lookup[optionSet,PrimaryConcentrationTarget], Lookup[optionSet,SecondaryConcentrationTarget]},

					(*if the primary concentration was specified, and the secondary is automatic, set the secondary to be Null if the Concentration stage is single stage*)
					MatchQ[Lookup[optionSet,PrimaryConcentrationTarget], Except[Automatic]]&&MatchQ[resolvedFiltrationMode,Alternatives[Concentration,ConcentrationDiafiltration]],
					{Lookup[optionSet,PrimaryConcentrationTarget], Null},

					(* if we have a single concentration, figure it out there *)
					MatchQ[Lookup[optionSet,PrimaryConcentrationTarget], Automatic]&&MatchQ[resolvedFiltrationMode,Alternatives[Concentration,ConcentrationDiafiltration]],
					{defaultTotalConcentrationFactor, Null},

					(* if we have a two concentration steps, figure it out *)
					(* if both Automatic, set by default*)
					MatchQ[Lookup[optionSet,PrimaryConcentrationTarget], Automatic]&&MatchQ[Lookup[optionSet,SecondaryConcentrationTarget], Automatic]&&MatchQ[resolvedFiltrationMode,ConcentrationDiafiltrationConcentration],
					{Divisors[Floor[defaultTotalConcentrationFactor]][[-2]], SafeRound[defaultTotalConcentrationFactor / Divisors[Floor[defaultTotalConcentrationFactor]][[-2]],10^-2]},

					(* if the secondary is set, calculate the primary factor*)
					MatchQ[Lookup[optionSet,PrimaryConcentrationTarget], Automatic]&&MatchQ[Lookup[optionSet,SecondaryConcentrationTarget], Except[Automatic]]&&MatchQ[resolvedFiltrationMode,ConcentrationDiafiltrationConcentration],
					{defaultTotalConcentrationFactor / convertToFold[Lookup[optionSet,SecondaryConcentrationTarget],SecondaryConcentrationTarget], Lookup[optionSet,SecondaryConcentrationTarget]},

					(* if the primary is set, calculate the secondary factor *)
					MatchQ[Lookup[optionSet,PrimaryConcentrationTarget], Except[Automatic]]&&MatchQ[Lookup[optionSet,SecondaryConcentrationTarget], Automatic]&&MatchQ[resolvedFiltrationMode,ConcentrationDiafiltrationConcentration],
					{Lookup[optionSet,PrimaryConcentrationTarget], defaultTotalConcentrationFactor / convertToFold[Lookup[optionSet,PrimaryConcentrationTarget], PrimaryConcentrationTarget]},

					(* otherwise,we're not concentrating so move on with nulls *)
					True,
					{Null, Null}
				];


				(* now figure out the diafiltration target if needed *)
				resolvedDiafiltrationTarget = Which[
					(* they specified it? hurray! *)
					MatchQ[Lookup[optionSet,DiafiltrationTarget], Except[Automatic]],
					Lookup[optionSet,DiafiltrationTarget],
					(* unspecified but we're using Diafiltration alone and don't have permeate volume *)
					MatchQ[Lookup[optionSet,DiafiltrationTarget], Automatic]&&MatchQ[resolvedFiltrationMode, Alternatives[Diafiltration, ConcentrationDiafiltration, ConcentrationDiafiltrationConcentration]]&&MatchQ[Lookup[optionSet, PermeateAliquotVolume],Null|All],
					5,
					(* otherwise,we're not concentrating so move on with nulls *)
					True,
					Null
				];

				(* Calculate the permeate volume from targets *)
				diafiltrationPermeateVolume=If[diafiltrationQ,
					Experiment`Private`calculateDiafiltrationVolume[resolvedSampleInVolume,resolvedPrimaryConcentrationTarget,resolvedDiafiltrationTarget, solventDensity],
					0Milliliter
				];
				
				(* For uPulse when checking  *)
				invalidDiaFiltrationVolumeQ = If[uPulseQ,
					(diafiltrationPermeateVolume > 45 Milliliter),
					False
				];
				
				(* Make a list of all targets for concentration steps -- diafiltration is omitted since it does not change the retentate volume *)
				concentrationTargets={resolvedPrimaryConcentrationTarget,resolvedSecondaryConcentrationTarget};
				
				(* Convert all to volume and add them up to find the total permeate volume for concentration steps (assume water is the diafiltration buffer for the second concentration) *)
				concentrationPermeateVolume=Experiment`Private`calculatePermeateTargetToVolume[concentrationTargets,resolvedSampleInVolume,solventDensity,Quantity[0.997, ("Grams")/("Milliliters")]];

				(* Check if the total permeate volume is less than or equal to the sample volume and disfiltration volumes -- equal is important in cases where only diafiltration steps are specified *)
				validTargetAmountsQ=If[
					MatchQ[concentrationTargets,Except[Null|Automatic|{Null..}]],
					Total[concentrationPermeateVolume]<=(resolvedSampleInVolume+diafiltrationPermeateVolume),
					True
				];
				
				(* ----- Are Targets for Individual Concentration Steps Less Than 100%? ----- *)

				(* Compile a list of whether the concentration steps have a target < 1 *)
				targetValidQList=#<=resolvedSampleInVolume&/@concentrationPermeateVolume;

				(* Check all the targets for target < 1 *)
				validTargetQ=If[
					MatchQ[concentrationTargets,Except[Automatic]],
					And@@targetValidQList,
					True
				];

				(* Find which steps failed *)
				failedTargetSteps=If[
					!validTargetQ,
					StringRiffle[Flatten[Position[targetValidQList,False]],", "]
				];

				(* Find what the failed values are *)
				failedTargetValues=If[
					!validTargetQ,
					StringRiffle[Pick[concentrationTargets,targetValidQList,False],", "]
				];
				
				(* ----- Is SampleReservoir compatible with SampleInVolume? ----- *)

				(* Find the min and max volumes for the reservoir *)
				inputSampleReservoirVolume=If[
					MatchQ[Lookup[optionSet, SampleReservoir],Except[Automatic]],
					Lookup[inputSampleReservoirPacket,{MinVolume,MaxVolume},{}],
					Null
				];

				(* Check if sample volume is compatible with the reservoir *)
				reservoirCompatibleWithVolumeQ=If[

					(* If Lookup[optionSet, SampleReservoir] is specified, check if the sample volume fits in the reservoir *)
					MatchQ[Lookup[optionSet, SampleReservoir],Except[Automatic]],
					First[inputSampleReservoirVolume]<=resolvedSampleInVolume<=Last[inputSampleReservoirVolume],
					True
				];


				(*----- Is CrossFlowFilter compatible with SampleInVolume? ----- *)

				(* Find the min and max volumes for the filter *)
				inputFilterVolume=If[
					MatchQ[Lookup[optionSet, CrossFlowFilter],Except[Automatic]],
					Lookup[inputFilterPacket,{MinVolume,MaxVolume},{}],
					{}
				];

				(* Check if filter is compatible with the reservoir *)
				filterCompatibleWithVolumeQ=If[

					(* If SampleFilterType and SampleInVolume are specified, check that SampleInVolume fits in the filter *)
					MatchQ[Lookup[optionSet, CrossFlowFilter],Except[Automatic]] && Not[uPulseQ],
					
					First[inputFilterVolume]<=resolvedSampleInVolume<=Last[inputFilterVolume],
					True
				];
				
				(* ----- Is RetentateAliquotVolume compatible with RetentateContainerOut? ----- *)

				(* Find the min and max volumes for our container *)
				inputRetentateContainerVolume=If[
					MatchQ[Lookup[optionSet, RetentateContainerOut],Except[Automatic]],
					fastAssocLookup[fastCacheBall, Lookup[optionSet, RetentateContainerOut], MaxVolume],
					Null
				];
				
				(* If RetentateAliquotVolume and RetentateAliquotVolume are specified *)
				retentateVolumeValidQ=If[
					And[
						MatchQ[Lookup[optionSet, RetentateContainerOut],Except[Automatic]],
						MatchQ[Lookup[optionSet, RetentateAliquotVolume],Except[Automatic]]
					],

					(* Check that the retentate fits in the container *)
					Lookup[optionSet, RetentateAliquotVolume]<FirstOrDefault[inputRetentateContainerVolume,inputRetentateContainerVolume],
					True
				];


				(* ----- Is PermeateAliquotVolume compatible with PermeateContainerOut? ----- *)

				(* Find the max volumes for containers *)
				preResolvedPermeateContainerVolume=If[
					MatchQ[Lookup[optionSet, PermeateContainerOut],Except[Automatic]],
					Lookup[inputPermeateContainerPacket,MaxVolume],
					Null
				];

				(* Check if PermeateAliquotVolume and PermeateContainerOut are specified, and that the permeate fits in the container *)
				permeateVolumeValidQ=If[

					(* If both PermeateContainerOut and PermeateAliquotVolume have been specified *)
					MatchQ[Lookup[optionSet, PermeateContainerOut],Except[Automatic]]&&MatchQ[Lookup[optionSet, PermeateAliquotVolume],Except[All]],

					(* Check if the permeate fits into the specified number of containers *)
					Lookup[optionSet, PermeateAliquotVolume]<=preResolvedPermeateContainerVolume,

					(* Otherwise, return true *)
					True
				];

				(* ----- Is RetentateAliquotVolume compatible with SampleInVolume? ----- *)
				
				(* Calculate the permeate volume from concentration targets *)
				concentrationPermeateVolume=If[concentrationQ,
					Total[concentrationPermeateVolume],
					0Liter
				];

				(* figure out total permeate volume *)
				totalPermeateVolume = Total[Flatten[{diafiltrationPermeateVolume,concentrationPermeateVolume}]];
				
				finalRetentateVolume = (resolvedSampleInVolume - Total[ToList[concentrationPermeateVolume]]);
				retentateVolumeAboveMinQ=Or[
					finalRetentateVolume>=Max[minFilterVolume,minSampleReservoirVolume],
					(* this is admittedly weird.  HOWEVER, if finalRetentateVolume is less than zero then we're already throwing other messages and don't want to throw these too *)
					finalRetentateVolume < 0 Milliliter
				];

				(* Check if RetentateAliquotVolume exceeds sample volume *)
				retentateVolumeSampleCompatibleQ=If[
					MatchQ[Lookup[optionSet, RetentateAliquotVolume],Except[Automatic]],
					Lookup[optionSet, RetentateAliquotVolume]<=finalRetentateVolume,
					True
				];

				(* ----- Is PermeateAliquotVolume compatible with SampleInVolume after the whole recipe? ----- *)
				(* Check if PermeateAliquotVolumes exceed calculated permeate Volume *)
				permeateVolumeSampleCompatibleQ=If[
					(* If permeate volumes were specified, *)
					MatchQ[Lookup[optionSet, PermeateAliquotVolume],Except[All]],
					Lookup[optionSet, PermeateAliquotVolume]<=totalPermeateVolume,
					(* Otherwise, return true *)
					True
				];

				(* ----- Is PermeateAliquotVolume compatible with max scale capacity? ----- *)
				(* This check only relevant to diafiltration steps because sample volume cannot exceed 2 liters, whereas the scales go up to 20 kilogram. Since there is a container, we are going to cap the volume at 18 liters. Additionally, there is no default diafiltration step so for this to fail, at least one diafiltration step must be specified by the user. Since we only calculate targets for diafiltration steps either at 3X sample volume as default or by user specification, we need to check if either of those values exceed 18 liters *)

				(* Check if PermeateAliquotVolume will exceed scale capacity *)
				permeateVolumesScaleCompatibleQ = totalPermeateVolume<=18Liter;

				(* ----- RetentateAliquotVolume, PermeateAliquotVolume and Targets Compatible Fest ----- *)
				(* Error checking for each of these three options have been done individually above. However, since RetentateAliquotVolume, PermeateAliquotVolume and Targets are related to one another, you can design a non-physical experiment by defining more than two of them. To ensure that the each of them are compatible with the other two and with other options, we have to go on this massive error hunt below *)

				(* Check which of the relevant options are specified *)
				specifiedVolumeOutput = MapThread[
					If[
						MatchQ[#1, Except[Automatic|All]],
						#2, 
						Nothing
					]&,
					{
						{Lookup[optionSet, RetentateAliquotVolume],Lookup[optionSet, PermeateAliquotVolume],Lookup[optionSet, DiafiltrationTarget],Lookup[optionSet, PrimaryConcentrationTarget],Lookup[optionSet, SecondaryConcentrationTarget]},
						{RetentateAliquotVolume,PermeateAliquotVolume,DiafiltrationTarget,PrimaryConcentrationTarget,SecondaryConcentrationTarget}
					}
				];

				(* Check which of the relevant options are specified *)
				specifiedTargetOptions = MapThread[
					If[
						MatchQ[#1, Except[Automatic]],
						#2,
						Nothing
					]&,
					{
						{Lookup[optionSet, DiafiltrationTarget],Lookup[optionSet, PrimaryConcentrationTarget],Lookup[optionSet, SecondaryConcentrationTarget]},
						{DiafiltrationTarget,PrimaryConcentrationTarget,SecondaryConcentrationTarget}
					}
				];

				(* Check that the specified options are compatible *)
				(* If targets are invalid, skip this check as we are already failing on that *)
				failingVolumeOutput=Which[
					!validTargetAmountsQ,{},

					(* If targets are specified, we are going to assume that it is correct, and check that the rest of the options do not exceed their specified amount *)
					Length[Intersection[specifiedVolumeOutput,{DiafiltrationTarget, PrimaryConcentrationTarget, SecondaryConcentrationTarget}]]>0,Module[{optionsValidList},

						(* Check that the options are compatible *)
						optionsValidList = Which[

							(* If both other options are specified *)
							MemberQ[specifiedVolumeOutput, RetentateAliquotVolume] && MemberQ[specifiedVolumeOutput, PermeateAliquotVolume], {

								(* Retentate volume is less than or equal to calculated *)
								Lookup[optionSet, RetentateAliquotVolume] <= finalRetentateVolume,

								(* Permeate volume is less than or equal to calculated *)
								Lookup[optionSet, PermeateAliquotVolume] <= totalPermeateVolume
							},

							(* If only retentate volume is specified, check that it is less than or equal to calculated *)
							MemberQ[specifiedVolumeOutput, RetentateAliquotVolume], {Lookup[optionSet, RetentateAliquotVolume] <= finalRetentateVolume, True},

							(* If only permeate volumes are specified, check that they are less than or equal to calculated *)
							MemberQ[specifiedVolumeOutput, PermeateAliquotVolume], {True, Lookup[optionSet, PermeateAliquotVolume] <= totalPermeateVolume},

							(* Otherwise, return true for everything *)
							True, {True, True}
						];


						(* If options failed, return which ones failed *)
						If[
							MemberQ[optionsValidList, False],
							Switch[optionsValidList,
								{False, False}, Flatten@{RetentateAliquotVolume, PermeateAliquotVolume, specifiedTargetOptions},
								{False, True}, Flatten@{RetentateAliquotVolume, specifiedTargetOptions},
								{True, False}, Flatten@{PermeateAliquotVolume, specifiedTargetOptions}
							],
							{}
						]
					],
					(* Otherwise, only branch left is the case where only RetentateAliquotVolume and PermeateAliquotVolume are specified, so we are going to assume that the RetentateAliquotVolume is correct and calculate permeate volumes from that *)
					VolumeQ[Lookup[optionSet, RetentateAliquotVolume]] && VolumeQ[Lookup[optionSet, PermeateAliquotVolume]],
						Module[{optionsValid, specifiedRetentateAliquotVolume, specifiedPermeateAliquotVolume},
							{specifiedRetentateAliquotVolume, specifiedPermeateAliquotVolume} = Lookup[optionSet, {RetentateAliquotVolume, PermeateAliquotVolume}];

							(* Check that the options are compatible -- depending on if the aliquot volume is set, each one needs to pass that test *)
							optionsValid=And[

								(* Retentate volume is less than or equal to calculated *)
								specifiedRetentateAliquotVolume <= finalRetentateVolume,

								(* Permeate volume is less than or equal to calculated *)
								specifiedPermeateAliquotVolume <= totalPermeateVolume
							];

							(* If options failed, return the only two that have been specified *)
							If[
								!optionsValid,
								{RetentateAliquotVolume,PermeateAliquotVolume},
								{}
							]
						],
					True, {}
				];

				(* Check if anything failed *)
				volumeOutputsValidQ=Length[failingVolumeOutput]==0;
				
				(* Find out how the retentate volume was specified *)
				failedRetentateAboveMinOption = Which[

					(* If Targets was specified, it was used to calculate the retentate volume so regardless of what else was specified, it was targets that caused the issue *)
					Length[Intersection[specifiedVolumeOutput, specifiedTargetOptions]] > 0, specifiedTargetOptions,

					(* If PermeateAliquotVolumes was specified, that has to be the culprit *)
					MatchQ[specifiedVolumeOutput, {PermeateAliquotVolume}], PermeateAliquotVolume,

					(* If neither of those were specified, sample volume is the only other option that can trigger this error *)
					True, SampleInVolume
				];


				(* ----- Is DiafiltrationBuffer compatible with FiltrationMode? ----- *)

				(* Check if the diafiltration buffers are legit for each step -- Diafiltration buffers are a mix between sample objects and Null. This step checks if any diafiltration steps have Null values. We don't care about concentration steps with sample objects at this stage. Those will turn to Nulls in the resolver and throw a warning *)
				diafiltrationBuffersBooleans=If[

					(* If both diafiltration buffers and filtration modes are specified *)
					MatchQ[Lookup[optionSet, DiafiltrationBuffer],Except[Automatic]]&&MatchQ[Lookup[optionSet, FiltrationMode],Except[Automatic]],
					If[
						diafiltrationQ,
						MatchQ[Lookup[optionSet, DiafiltrationBuffer],ObjectP[{Model[Sample],Object[Sample]}]],
						True
					],
					(* Otherwise, return True *)
					{True}
				];

				(* Check if any diafiltration buffers are not the right kind *)
				diafiltrationBuffersValidQ=And@@diafiltrationBuffersBooleans;
				

				(*------  Resolve FiltrationMode related options  ------*)

				(* ----- Resolve TransmembranePressureTarget ----- *)
				resolvedTransmembranePressureTarget=Which[

					(* If flow rate is specified, use that *)
					MatchQ[Lookup[optionSet, TransmembranePressureTarget],Except[Automatic]],
					Lookup[optionSet, TransmembranePressureTarget],

					(* Otherwise, resolve to 20 PSI if using KR2i for the instrument *)
					Not[uPulseQ],20 PSI,
					
					(* if using uPulse *)
					True, Null
				];


				(* ----- Resolve DiafiltrationBuffer ----- *)
				resolvedDiafiltrationBuffer=Which[

					(* If specified as a buffer for a diafiltration step, use it *)
					MatchQ[Lookup[optionSet, DiafiltrationBuffer],ObjectP[{Model[Sample],Object[Sample]}]]&&diafiltrationQ,Lookup[optionSet, DiafiltrationBuffer],

					(* If specified as a buffer for a concentration step, null it out and display a warning *)
					MatchQ[Lookup[optionSet, DiafiltrationBuffer],ObjectP[{Model[Sample],Object[Sample]}]]&&!diafiltrationQ,Module[{},

						(* Throw a warning *)
						Message[Warning::CrossFlowDiafiltrationBufferIgnored,Lookup[optionSet, DiafiltrationBuffer]];

						(* Return Null *)
						Null
					],

					(* If specified as Null for a concentration step, use it -- we already eliminated any cases where a Null was specified for diafiltration steps in error checking *)
					NullQ[Lookup[optionSet, DiafiltrationBuffer]]&&!diafiltrationQ,Lookup[optionSet, DiafiltrationBuffer],

					(* If automatic and a diafiltration step, return water *)
					MatchQ[Lookup[optionSet, DiafiltrationBuffer],Automatic]&&diafiltrationQ,Model[Sample,"Milli-Q water"],

					(* If not a diafiltration step, skip *)
					True,Null
				];
				
				(* Resolve DiafitrationMode *)
				resolvedDiafiltrationMode=Which[
					
					(* User user specified value *)
					MatchQ[Lookup[optionSet, DiafiltrationMode],Except[Automatic]],Lookup[optionSet, DiafiltrationMode],
					
					(* Resolve to Continues if using uPulse and running diafiltration *)
					uPulseQ&&diafiltrationQ, Continuous,
					
					(* else set to Null *)
					True, Null
					
				];
				
				(* further resolved DiafiltrationExchange count*)
				resolvedDiaFiltrationExchangeCount = Which[
					(* Use user specified value *)
					MatchQ[Lookup[optionSet, DiafiltrationExchangeCount],Except[Automatic]],Lookup[optionSet, DiafiltrationExchangeCount],
					
					(* If DiafiltrationMode is Discrete, default to 3 *)
					uPulseQ && diafiltrationQ && MatchQ[resolvedDiafiltrationMode, Discrete], 3,
					
					(* Otherwise se to null *)
					True, Null
					
				];
				
				(* Check if DiafiltrationMode is conflicting with the instrument *)
				invalidDiafiltrationModeQ = Or[And[uPulseQ, diafiltrationQ, NullQ[resolvedDiafiltrationMode]], And[uPulseQ,Not[diafiltrationQ],Not[NullQ[resolvedDiafiltrationMode]]]];
				
				(* Check if DiafiltrationExchangeCount is conflicting with the instrument *)
				invalidDiaFiltrationExchangeCountQ = If[invalidDiafiltrationModeQ,
					
					(* Ignore this error check if the DiafiltrationMode is incorrect *)
					False,
					
					Or[
						And[uPulseQ,MatchQ[resolvedDiafiltrationMode,Except[Discrete]], Not[NullQ[resolvedDiaFiltrationExchangeCount]]],
						And[uPulseQ,MatchQ[resolvedDiafiltrationMode,Discrete],NullQ[resolvedDiaFiltrationExchangeCount]]
					]
				];
				
				(* Resolved DeadVolumeRecoveryMode *)
				resolvedDeadVolumeRecoveryMode = Which[
					(* Use user specified value *)
					MatchQ[Lookup[optionSet, DeadVolumeRecoveryMode],Except[Automatic]],Lookup[optionSet, DeadVolumeRecoveryMode],
					
					(* If DiafiltrationMode is Discrete, default to 3 *)
					uPulseQ, Air,
					
					(* Otherwise se to null *)
					True, Null
				
				];
				
				(* Invalid DeadVolumeRecoveryMode: this option can only be set when instrument is uPulse, and can only be air is diafiltrationQ is False *)
				invalidDeadVolumeRecoveryModeQ = Which[
					
					(* If using uPulse but not in diafiltration, cannot use buffer as the recovery mode, since there will be no buffer there *)
					uPulseQ && Not[diafiltrationQ], MatchQ[resolvedDeadVolumeRecoveryMode, Buffer],
					
					(* If not uing uPulse, this option can only be Null *)
					Not[uPulseQ], Not[NullQ[resolvedDeadVolumeRecoveryMode]],
					
					True, False
				
				];

				(* ----- Resolve PermeateStorageCondition ----- *)
				resolvedPermeateStorageCondition=Which[

					(* If specified, use it *)
					MatchQ[Lookup[optionSet, PermeateStorageCondition],Except[Automatic]],Lookup[optionSet, PermeateStorageCondition],

					(* If sample has storage information, use that *)
					!NullQ[Lookup[samplePacket,StorageCondition,Null]],sampleStorageConditionExpression,

					(* Any other case, store in the fridge *)
					True, Refrigerator
				];


				(* ----- Resolve PermeateAliquotVolume and PermeateContainerOut ----- *)
				resolvedPermeateContainerOut = Which[

					(* If we error out above, bypass this section *)
					!permeateVolumesScaleCompatibleQ,Model[Container,Vessel,"50mL Tube"],

					(* If both are specified, return as is *)
					MatchQ[Lookup[optionSet, PermeateContainerOut],Except[Automatic]],Lookup[optionSet, PermeateContainerOut],

					(* If only volume is specified, return a container based on PreferredContainer *)
					MatchQ[resolvedPermeateStorageCondition,Except[Disposal]] && MatchQ[Lookup[optionSet, PermeateAliquotVolume],VolumeP], PreferredContainer[Lookup[optionSet, PermeateAliquotVolume], Sterile -> resolvedSterile],

					(* If PermeateAliquotVolume is set to all and PermeateStorageCondition is not disposal, set based on calculated PermeatedVolume *)
					MatchQ[resolvedPermeateStorageCondition,Except[Disposal]], PreferredContainer[totalPermeateVolume*1.1, Sterile -> resolvedSterile],

					(* If the PermeateStorageCondition is resolved to Disposal, then we don't need this container *)
					True, Null
				];


				(* ----- Resolve RetentateAliquotVolume ----- *)
				(* Check if any of the retentate aliquot options is specified *)
				impliedRetentateAliquotQ= If[uPulseQ,
					Or@@Map[
						MatchQ[Lookup[optionSet, #],Except[Automatic|Null]]&,
						{
							RetentateContainerOut,
							RetentateStorageCondition,
							RetentateAliquotVolume
						}
					],
					True
				];
				(* Calculate the theoretical maximum of the volume -- this is the entire amount that gets left behind based on targets *)
				theoreticalRetentateVolume=resolvedSampleInVolume-concentrationPermeateVolume;
				
				(* Resolve the retentate out volume *)
				resolvedRetentateAliquotVolume=Which[

					(* If specified without errors, use it *)
					MatchQ[Lookup[optionSet, RetentateAliquotVolume],Except[Automatic]],Lookup[optionSet, RetentateAliquotVolume],

					(* If only container is specified, calculate from container volume *)
					MatchQ[Lookup[optionSet, RetentateAliquotVolume],Automatic]&&MatchQ[Lookup[optionSet, RetentateContainerOut],Except[Automatic|Null]],Module[{},


						(* If the resolved volume doesn't fit in the specified container, then cap the volume at the container max. Otherwise, return the entire theoretical retentate volume *)
						Which[
							retentateVolumeValidQ && (theoreticalRetentateVolume < $MaxTransferVolume), All,
							retentateVolumeValidQ, theoreticalRetentateVolume,
							True, Lookup[fetchPacketFromCache[Lookup[optionSet, RetentateContainerOut],newCache],MaxVolume,0 Milliliter]
						]
					],
					(* Else if the calculated value is smaller than $MaxTransferVolume, use All *)
					impliedRetentateAliquotQ && (theoreticalRetentateVolume < $MaxTransferVolume), All,
					
					(* Else just use the $MaxTransferVolume *)
					impliedRetentateAliquotQ,$MaxTransferVolume,
					
					(* If RetentateAliquotVolume is set to Automatic, but we are using uPulse as the Instrument set to Null *)
					True, Null
				
				];
				
				(* ----- Resolve RetentateContainerOut ----- *)
				(* Resolve container *)
				resolvedRetentateContainerOut=Which[

					(* If specified, return it *)
					MatchQ[Lookup[optionSet, RetentateContainerOut],Except[Automatic]],
					Lookup[optionSet, RetentateContainerOut],
					
					(* For KR2i instrument, find the first smallest container the volume fits in *)
					impliedRetentateAliquotQ,
					PreferredContainer[theoreticalRetentateVolume*1.1, Sterile -> resolvedSterile],
					
					(* for uPulse, default to not to use a new container *)
					True, Null
				];
				

				(* ----- Resolve SizeCutoff and CrossFlowFilter ----- *)

				(* Fetch the molecular weights of sample components *)
				componentMolecularWeights=Lookup[sampleComponentPackets,{Object,MolecularWeight},Nothing];

				(* Find the molecular weights of components *)
				elementSize=If[
					MatchQ[componentMolecularWeights,Except[{}]],
					Cases[(Last/@componentMolecularWeights),UnitsP[]],
					{}
				];

				(* Find all the kDa size cutoffs in the database *)
				databaseDaltonSizeCutoffs=If[
					uPulseQ,
					Cases[DeleteDuplicates[Lookup[filterChipModelPackets,MolecularWeightCutoff]],UnitsP[Kilodalton]],
					Cases[DeleteDuplicates[Lookup[filterModelPackets,SizeCutoff]],UnitsP[Kilodalton]]
				];

				(* Find all the micron size cutoffs in the database *)
				databaseMicronSizeCutoffs=If[
					uPulseQ,
					Cases[DeleteDuplicates[Lookup[filterChipModelPackets,PoreSize]],UnitsP[Micron]],
					Cases[DeleteDuplicates[Lookup[filterModelPackets,SizeCutoff]],UnitsP[Micron]]
				];
				(* Init an error check boolean *)
				crossFlowNonOptimalSizeCutoffQ=False;
				(* Calculate the max cutoff we can use -- this is basically the number that we can use to make sure the biggest component of the sample will not cross the filter. Any number below the max will also be a reasonable filter, however, smaller the cutoff, slower the experiment will go *)
				maxSizeCutoff=Which[
					
					(* If size cutoff was specified, return that *)
					MatchQ[Lookup[optionSet, SizeCutoff],Except[Automatic]],Lookup[optionSet, SizeCutoff],
					
					(* If we are erroring out, return a number to prevent further errors *)
					Or[sampleWithoutCompositionQ,!volumeInformationValidQ,!retentateVolumeAboveMinQ],50 Kilodalton,

					(* If sample has bacteria or yeast, return 0.1 uM if using KR2i else 30 Kilodalton *)
					MemberQ[Transpose[Lookup[samplePacket,Composition,{}]][[2]],LinkP[{Model[Cell,Bacteria],Model[Cell,Yeast]}]],If[uPulseQ, 30 Kilodalton ,0.1 Micron],
					
					(* If sample has mammalian cells, return 0.2 uM if using KR2i else 10 Kilodalton *)
					MemberQ[Transpose[Lookup[samplePacket,Composition,{}]][[2]],LinkP[Model[Cell,Mammalian]]],If[uPulseQ, 10 Kilodalton,0.2 Micron],
					
					(* If sample has more than 1 component with known molecular weight, return the size of the filter closest to the midpoint the two largest component molecular weights and below the largest molecular weight *)
					Length[elementSize]>1,
					Module[{cutoffsSmallerThanLargestMolecule},
						
						(* Find all cutoffs that are smaller our largest molecule *)
						cutoffsSmallerThanLargestMolecule=Select[databaseDaltonSizeCutoffs,#<Max[elementSize]&];
						
						(* If we have at least one cutoff we can use, find one closest to the midpoint between the two largest components *)
						If[
							Length[cutoffsSmallerThanLargestMolecule]>0,
							First[Nearest[cutoffsSmallerThanLargestMolecule,Mean[{Max[elementSize],RankedMax[elementSize,2]}]]],
							Module[{largestSize},
								
								(* Find the size of the largest filter in the database *)
								largestSize=If[
									MatchQ[databaseMicronSizeCutoffs,{}],
									Max[databaseDaltonSizeCutoffs],
									Max[databaseMicronSizeCutoffs]
								];
								
								(* flip the variables for the warning *)
								crossFlowNonOptimalSizeCutoffQ = True;
								
								(* Return the value *)
								largestSize
							]
						]
					],
					
					(* If there is one component with known molecular weight, but there are more components, resolve to the largest filter but throw a warning *)
					Length[elementSize]==1&&Length[sampleComponentPackets]>1,
					Module[{largestSize},
						
						(* Find the size of the largest filter in the database *)
						largestSize=If[
							MatchQ[databaseMicronSizeCutoffs,{}],
							Max[databaseDaltonSizeCutoffs],
							Max[databaseMicronSizeCutoffs]
						];
						
						(* flip the variables for the warning *)
						crossFlowNonOptimalSizeCutoffQ = True;
						
						
						(* Return the value *)
						largestSize
					],
					
					(* If sample has 1 component, return the size of the largest filter in the database *)
					True,
					If[
						MatchQ[databaseMicronSizeCutoffs,{}],
						Max[databaseDaltonSizeCutoffs],
						Max[databaseMicronSizeCutoffs]
					]
				];
				
				(* Assign variables for errors and warnings *)
				crossFlowFilterSterileUnavailableQ = False;
				crossFlowDefaultFilterReturnedQ = False;
				sizeCutoffsMatchQ = True;
				
				(* Resolve CrossFlowFilter *)
				{resolvedFilter,resolvedSizeCutoff}=If[
					uPulseQ,
					
					(* For uPulse *)
					Which[
						
						(* If both are specified, return the filter and its size cutoff *)
						MatchQ[Lookup[optionSet, SizeCutoff],Except[Automatic]]&&MatchQ[Lookup[optionSet, CrossFlowFilter],Except[Automatic]],
						Module[{crossFlowFilterSizeCutoff},
							
							(* If filter is specified, return its min volume *)
							crossFlowFilterSizeCutoff = Which[
								MatchQ[Lookup[optionSet,CrossFlowFilter],ObjectReferenceP[{Model[Item]}]],
								Lookup[inputFilterPacket,MolecularWeightCutoff],
								
								(* If filter is specified, return its min volume *)
								MatchQ[Lookup[optionSet,CrossFlowFilter],ObjectReferenceP[{Object[Item]}]],
								fastAssocLookup[fastCacheBall, Download[fastAssocLookup[fastCacheBall, Lookup[optionSet,CrossFlowFilter], Model],Object], MolecularWeightCutoff]/.Null->0Kilodalton,
								
								True, 0 Kilodalton
							];
							
							
							(* Check if the size cutoff of the filter matches the specified SizeCutoff *)
							sizeCutoffsMatchQ=EqualQ[Lookup[optionSet, SizeCutoff],crossFlowFilterSizeCutoff];
						
							(* Return the initial filter and its size cutoff *)
							{Lookup[optionSet, CrossFlowFilter],Lookup[inputFilterPacket,SizeCutoff]}
						],
						
						(* If only filter is specified, return the filter and its size cutoff *)
						MatchQ[Lookup[optionSet, SizeCutoff],Automatic]&&MatchQ[Lookup[optionSet, CrossFlowFilter],Except[Automatic]],
						Module[{filterSizeCutoff},
							(* If we were given a filter object, we have to get the cutoff from the model packet *)
							filterSizeCutoff = If[MatchQ[inputFilterPacket,PacketP[Model[Item,Filter,MicrofluidicChip]]],
								Lookup[inputFilterPacket,MolecularWeightCutoff] /. Null -> 0 kilodalton,
								fastAssocLookup[fastCacheBall, Download[Lookup[inputFilterPacket,Model],Object], MolecularWeightCutoff] /. Null -> 0 Kilodalton
							];
							{Lookup[optionSet, CrossFlowFilter],filterSizeCutoff}
						],
						
						(* If only SizeCutoff is specified, find a filter based on the size cutoff *)
						MatchQ[Lookup[optionSet, SizeCutoff],Except[Automatic]]&&MatchQ[Lookup[optionSet, CrossFlowFilter],Automatic],
						Module[{firstQualifiedFilterPacket},
							
							(* Get the first available filter packet that matches the size cutoff and sterility*)
							firstQualifiedFilterPacket = SelectFirst[
								filterChipModelPackets,
								And[MatchQ[Lookup[#, MolecularWeightCutoff], GreaterEqualP[Lookup[optionSet, SizeCutoff]]], MatchQ[TrueQ[Lookup[#, Sterile]],resolvedSterile]]&,
								Null
							];
							
							(* What if we have nothing to return*)
							crossFlowFilterSterileUnavailableQ=And[NullQ[firstQualifiedFilterPacket],resolvedSterile];
							
							(* Check if the size cutoff of the filter matches the specified SizeCutoff *)
							sizeCutoffsMatchQ=If[crossFlowFilterSterileUnavailableQ,True,EqualQ[Lookup[optionSet, SizeCutoff],Lookup[firstQualifiedFilterPacket,MolecularWeightCutoff]]];
							
							(* Return the initial filter and its size cutoff *)
							{
								If[
									NullQ[firstQualifiedFilterPacket],
									Model[Item, Filter, MicrofluidicChip, "Formulatrix MicroPulse Filter Chip 50 kDa"], (* in case we cannot find a proper filter, we return the 50kDa as the default one*)
									Download[firstQualifiedFilterPacket, Object]
								],
								Lookup[optionSet, SizeCutoff]
							}
						],
						
						(* If neither is specified, find a filter based on the max size cutoff we calculated *)
						True,
						Module[{firstQualifiedFilterPacket},
							
							firstQualifiedFilterPacket = SelectFirst[
								filterChipModelPackets,
								And[MatchQ[Lookup[#, MolecularWeightCutoff], GreaterEqualP[maxSizeCutoff]], MatchQ[TrueQ[Lookup[#, Sterile]],resolvedSterile]]&,
								Null
							];
							
							(* What if we have nothing to return*)
							crossFlowFilterSterileUnavailableQ=And[NullQ[firstQualifiedFilterPacket],resolvedSterile];
							
							(* Return the initial filter and its size cutoff *)
							{
								If[
									NullQ[firstQualifiedFilterPacket],
									Model[Item, Filter, MicrofluidicChip, "Formulatrix MicroPulse Filter Chip 50 kDa"], (* in case we cannot find a proper filter, we return the 50kDa as the default one*)
									Download[firstQualifiedFilterPacket, Object]
								],
								If[
									NullQ[firstQualifiedFilterPacket],
									50 Kilodalton, (* in case we cannot find a proper filter, we return the 50kDa as the default one*)
									Lookup[firstQualifiedFilterPacket, MolecularWeightCutoff]
								]
							}
						]
					],
					
					(* KR2i *)
					Module[
						{
							allPossibleFilters,idealFilters,sizeCutoffMatchedFilters,sterilityMatchedFilters,
							orderedSterilityMatchedFilterCutoffs
						},

						(* Find all possible filters without checking sterility -- the smallest feed volumes are equal to the minimum retentate volume so we need to compare the minimum to that volume instead of sample volume *)
						allPossibleFilters=Which[
							
							(* If we are erroring out, skip this step *)
							Or[!volumeInformationValidQ,!validTargetAmountsQ,!retentateVolumeAboveMinQ],{},
							
							(* If both sizes are in kDa, compare as is *)
							MatchQ[Lookup[#,SizeCutoff],UnitsP[1 Kilodalton]]&&MatchQ[maxSizeCutoff,UnitsP[1 Kilodalton]],Module[{possibleFilterCheck},
								(* Check if the volume and the size cutoff would work *)
								possibleFilterCheck=And[
									Lookup[#,MinVolume]<=theoreticalRetentateVolume,
									Lookup[#,MaxVolume]>=resolvedSampleInVolume,
									Lookup[#,SizeCutoff]<=maxSizeCutoff
								];
								
								(* Return if it passes the check *)
								If[
									possibleFilterCheck,
									#,
									Nothing
								]
							],
							
							(* If both sizes are in micron, compare as is *)
							MatchQ[Lookup[#,SizeCutoff],UnitsP[1 Micron]]&&MatchQ[maxSizeCutoff,UnitsP[1 Micron]],Module[{possibleFilterCheck},
								
								(* Check if the volume and the size cutoff would work *)
								possibleFilterCheck=And[
									Lookup[#,MinVolume]<=theoreticalRetentateVolume,
									Lookup[#,MaxVolume]>=resolvedSampleInVolume,
									Lookup[#,SizeCutoff]<=maxSizeCutoff
								];
								
								(* Return if it passes the check *)
								If[
									possibleFilterCheck,
									#,
									Nothing
								]
							],
							
							(* If filter is in kDa, and the sample is in micron, we already know the filter would work so check the volume *)
							MatchQ[Lookup[#,SizeCutoff],UnitsP[1 Kilodalton]]&&MatchQ[maxSizeCutoff,UnitsP[1 Micron]],Module[{possibleFilterCheck},
								
								(* Check if the volume would work *)
								possibleFilterCheck=And[
									Lookup[#,MinVolume]<=theoreticalRetentateVolume,
									Lookup[#,MaxVolume]>=resolvedSampleInVolume
								];
								
								(* Return if it passes the check *)
								If[
									possibleFilterCheck,
									#,
									Nothing
								]
							],
							
							(* If filter is in micron, and the sample is in kDa, it's too big so return nothing *)
							MatchQ[Lookup[#,SizeCutoff],UnitsP[1 Micron]]&&MatchQ[maxSizeCutoff,UnitsP[1 Kilodalton]],Nothing
						]&/@filterModelPackets;
						
						
						(* Find the ideal filters -- these filters will match on sterility and size cutoff *)
						idealFilters=Select[
							allPossibleFilters,
							And[
								MatchQ[Lookup[#,Sterile],resolvedSterile],
								EqualQ[Lookup[#,SizeCutoff],maxSizeCutoff]
							]&
						];
						
						(* Find the filters that only match size cutoff but not sterility *)
						sizeCutoffMatchedFilters=Select[
							allPossibleFilters,
							And[
								!MatchQ[Lookup[#,Sterile],resolvedSterile],
								EqualQ[Lookup[#,SizeCutoff],maxSizeCutoff]
							]&
						];
						
						(* Find the filters that only match size cutoff but not sterility -- since we selected all possible filters to be the ones that are less than the max size cutoff, we don't need to compare sizes here, any in possible filters are already strictly below the size cutoff we need *)
						sterilityMatchedFilters=Select[
							allPossibleFilters,
							And[
								MatchQ[Lookup[#,Sterile],resolvedSterile],
								!EqualQ[Lookup[#,SizeCutoff],maxSizeCutoff]
							]&
						];
						
						(* Make an ordered list of sterilityMatchedFilters, from smallest to largest *)
						orderedSterilityMatchedFilterCutoffs=Join[Sort[Cases[DeleteDuplicates[Lookup[sterilityMatchedFilters,SizeCutoff]],UnitsP[Kilodalton]]],Sort[Cases[DeleteDuplicates[Lookup[sterilityMatchedFilters,SizeCutoff]],UnitsP[Micron]]]];
						
						
						(* Resolve the size cutoff *)
						Which[
							
							(* If targets are invalid, skip this step since we are erroring out *)
							Or[!volumeInformationValidQ,!validTargetAmountsQ,!retentateVolumeAboveMinQ],
							{Model[Item,CrossFlowFilter,"Dry MicroKros mPES 50 kDa"],50 Kilodalton},
							
							(* If both are specified, return the filter and its size cutoff *)
							MatchQ[Lookup[optionSet, SizeCutoff],Except[Automatic]]&&MatchQ[Lookup[optionSet, CrossFlowFilter],Except[Automatic]],
							Module[{},
							
							(* Check if the size cutoff of the filter matches the specified SizeCutoff *)
								sizeCutoffsMatchQ=MatchQ[Lookup[optionSet, SizeCutoff],Lookup[inputFilterPacket,SizeCutoff]];
							
							(* Return the initial filter and its size cutoff *)
								{Lookup[optionSet, CrossFlowFilter],Lookup[inputFilterPacket,SizeCutoff]}
							],
							
							(* If only filter is specified, return the filter and its size cutoff *)
							MatchQ[Lookup[optionSet, SizeCutoff],Automatic]&&MatchQ[Lookup[optionSet, CrossFlowFilter],Except[Automatic]],
							{Lookup[optionSet, CrossFlowFilter],Lookup[inputFilterPacket,SizeCutoff]},
							
							(* If only SizeCutoff is specified, find a filter based on the size cutoff *)
							MatchQ[Lookup[optionSet, SizeCutoff],Except[Automatic]]&&MatchQ[Lookup[optionSet, CrossFlowFilter],Automatic],
							Module[{almostResolvedFilterPacket},
								
								(* Choose a filter *)
								almostResolvedFilterPacket=Which[
								
									(* If we have ideal filters, grab the largest one *)
									Length[idealFilters]>0,SelectFirst[idealFilters,MatchQ[Lookup[#,MinVolume],Max[Lookup[idealFilters,MinVolume]]]&],
									
									(* If we have don't have ideal filters but have size cutoff matched ones, grab the largest one *)
									Length[idealFilters]==0&&Length[sizeCutoffMatchedFilters]>0,Module[{},
										
										crossFlowFilterSterileUnavailableQ= True;
										
										(* Return the largest filter with the matched size cutoff *)
										SelectFirst[sizeCutoffMatchedFilters,MatchQ[Lookup[#,MinVolume],Max[Lookup[sizeCutoffMatchedFilters,MinVolume]]]&]
									],
									
									(* If we have don't have ideal filters but have sterility matched ones, grab the largest size cutoff and physically the largest -- since we have no ideal filters, that means the sterility matched filters are strictly lower size cutoffs than the specified size cutoff *)
									Length[idealFilters]==0&&Length[sterilityMatchedFilters]>0,Module[{sterilityMatchedFilter},
										
										(* Find the largest filter with the matched size cutoff *)
										sterilityMatchedFilter=SelectFirst[
											sterilityMatchedFilters,
											And[
												EqualQ[Lookup[#,SizeCutoff],Last[orderedSterilityMatchedFilterCutoffs]],
												MatchQ[Lookup[#,MinVolume],Max[Lookup[sterilityMatchedFilters,MinVolume]]]
											]&,
											First[sterilityMatchedFilters]
										];

										crossFlowFilterSterileUnavailableQ= True;
										
										(* Return filter *)
										sterilityMatchedFilter
									],
								
									(* Otherwise, we can't find a filter that makes scientific sense, so return defaults *)
									True,Module[{},
										
										(* Throw a warning because we are returning a default filter *)
										crossFlowDefaultFilterReturnedQ= True;
										
										(* Return the filter and its size cutoff *)
										Which[
											(* If sterile is requested, return the default sterile ones based on volume *)
											resolvedSterile&&theoreticalRetentateVolume<25 Milliliter,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Sterile MicroKros mPES 30 kDa"],newCache],
											resolvedSterile,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Sterile MidiKros PS 500 kDa"],newCache],
											
											(* Otherwise, return the defaults based on volume *)
											theoreticalRetentateVolume<25 Milliliter,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Dry MicroKros mPES 50 kDa"],newCache],
											True,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Dry MidiKros mPES 300 kDa"],newCache]
										]
									]
								];

								(* Return the filter and its size cutoff *)
								{Lookup[almostResolvedFilterPacket,Object],Lookup[optionSet, SizeCutoff]}
							],
							
							(* If neither is specified, find a filter based on the max size cutoff we calculated *)
							MatchQ[Lookup[optionSet, SizeCutoff],Automatic]&&MatchQ[Lookup[optionSet, CrossFlowFilter],Automatic],
							Module[{almostResolvedFilterPacket},
							
								(* Choose a filter *)
								almostResolvedFilterPacket=Which[
									
									(* If we have ideal filters, grab the largest one *)
									Length[idealFilters]>0,SelectFirst[idealFilters,MatchQ[Lookup[#,MinVolume],Max[Lookup[idealFilters,MinVolume]]]&],
									
									(* If we have don't have ideal filters but have sterility matched ones, grab the largest size cutoff and physically the largest -- since we have no ideal filters, that means the sterility matched filters are strictly lower size cutoffs than the specified size cutoff *)
									Length[idealFilters]==0&&Length[sterilityMatchedFilters]>0,SelectFirst[
										sterilityMatchedFilters,
										And[
											EqualQ[Lookup[#,SizeCutoff],Last[orderedSterilityMatchedFilterCutoffs]],
											MatchQ[Lookup[#,MinVolume],Max[Lookup[sterilityMatchedFilters,MinVolume]]]
										]&
									],
									
									(* Otherwise, we can't find a filter that makes scientific sense, so return defaults *)
									True,Module[{},
										
										crossFlowDefaultFilterReturnedQ = True;
										
										(* Return the filter and its size cutoff *)
										Which[
											(* If sterile is requested, return the default sterile ones based on volume *)
											resolvedSterile&&theoreticalRetentateVolume<25 Milliliter,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Sterile MicroKros mPES 30 kDa"],newCache],
											resolvedSterile,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Sterile MidiKros PS 500 kDa"],newCache],
											
											(* Otherwise, return the defaults based on volume *)
											theoreticalRetentateVolume<25 Milliliter,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Dry MicroKros mPES 50 kDa"],newCache],
											True,fetchPacketFromCache[Model[Item,CrossFlowFilter,"Dry MidiKros mPES 300 kDa"],newCache]
										]
									]
								];
								
								(* Return the filter and its size cutoff *)
								{Lookup[almostResolvedFilterPacket,Object],Lookup[almostResolvedFilterPacket,SizeCutoff]}
							]
						]
					]
				];
				
				(* Check to make sure the if the instrument is using correct filter types *)
				invalidFilterTypeQ = If[
					uPulseQ,
					Not[MatchQ[resolvedFilter,ObjectP[{Object[Item, Filter, MicrofluidicChip], Model[Item, Filter, MicrofluidicChip]}]]],
					Not[MatchQ[resolvedFilter,ObjectP[{Object[Item,CrossFlowFilter], Model[Item,CrossFlowFilter]}]]]
				];
				
				(* Prepare a filter packet *)
				resolvedFilterPacket=fetchPacketFromCache[resolvedFilter,newCache];

				(* ----- Resolve SampleReservoir ----- *)

				(* Find sample reservoirs that fits our sample volume and retentate volume *)
				fittingSampleReservoirs=Select[sampleReservoirModelPackets,And[
					Lookup[#,MinVolume,0 Milliliter]<=theoreticalRetentateVolume,
					resolvedSampleInVolume<=Lookup[#,MaxVolume,0 Milliliter]
				]&];

				(* Count the number of smallest reservoirs in the fitting sample list -- this is relevant due to sterility; not all reservoirs can be purchased sterile so only some have multiple values in the database*)
				numberOfSmallestReservoirs=Count[Lookup[fittingSampleReservoirs,MaxVolume,{}],Min[Lookup[fittingSampleReservoirs,MaxVolume,{}]]];

				(* Pick the smallest container out of the ones that fit *)
				resolvedSampleReservoir=If[
					
					uPulseQ,
					
					(* For uPulse *)
					Which[
						(* If sample reservoir is specified, use that *)
						MatchQ[Lookup[optionSet, SampleReservoir],Except[Automatic]],Lookup[optionSet, SampleReservoir],
						
						(* If the input container is in the 50 mL tube, just use the sample container *)
						Not[NullQ[sampleContainerPacket]]&&MatchQ[Download[Lookup[sampleContainerPacket,Model],Object],ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]], Download[Lookup[sampleContainerPacket,Model],Object],
						
						(* Else we have to use 50 mL tube for this instrument, we will resolve the aliquot container later. *)
						True, Model[Container, Vessel, "50mL Tube"]
					],
					
					(* For KR2i instrument *)
					Which[
						
						(* If sample reservoir is specified, use that *)
						MatchQ[Lookup[optionSet, SampleReservoir],Except[Automatic]],Lookup[optionSet, SampleReservoir],
						
						(* If targets are invalid, skip this step since we are erroring out *)
						Or[!volumeInformationValidQ,!validTargetAmountsQ,!retentateVolumeAboveMinQ],Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 250mL Tube"],
						
						(* If there is only one smallest reservoir that fits in the database, return it *)
						numberOfSmallestReservoirs==1,
						Lookup[
							SelectFirst[fittingSampleReservoirs,MatchQ[Lookup[#,MaxVolume],Min[Lookup[fittingSampleReservoirs,MaxVolume]]]&],
							Object
						],
						
						(* If there is more than one smallest reservoir that fits in the database *)
						numberOfSmallestReservoirs>1,
						Lookup[
						
							(* Find the one that matches the required sterility *)
							SelectFirst[
								fittingSampleReservoirs,
								And[
									MatchQ[Lookup[#,MaxVolume],Min[Lookup[fittingSampleReservoirs,MaxVolume]]],
									MatchQ[Lookup[#,Sterile],resolvedSterile]
								]&
							],
							Object
						]
					]
				];

				(* Check if sample reservoir is valid for  *)
				invalidSampleReservoirQ= Which[
					MatchQ[resolvedSampleReservoir,ObjectP[Model[Container]]] && uPulseQ, MatchQ[resolvedSampleReservoir,Except[ObjectP[{Model[Container, Vessel, "50mL Tube"]}]]],
					uPulseQ,MatchQ[Download[Lookup[resolvedSampleReservoir,Model],Object],Except[ObjectP[{Model[Container, Vessel, "50mL Tube"]}]]],
					True, False
				];

				(* return the object whose MinVolume is above the volume we're dealing with *)
				(* this could be the filter or the sample reservoir *)
				failedRetentateMinSpecification = Which[
					(* if we are above the min then no problem *)
					retentateVolumeAboveMinQ, Null,
					(* if we're below the minFilterVolume, then we have a problem *)
					finalRetentateVolume < minFilterVolume, resolvedFilter,

					(* if we're below the minSampleReservoirVolume, then we also have a problem *)
					finalRetentateVolume < minSampleReservoirVolume, resolvedSampleReservoir
				];

				(* If anything failed, find out which one failed *)
				failedRetentateAboveMinVolume = Which[

					(* If nothing failed, carry on *)
					retentateVolumeAboveMinQ, Null,

					(* If the retentate volume is below filter MinVolume *)
					finalRetentateVolume < minFilterVolume && MatchQ[resolvedFilter, ObjectP[Model]], fastAssocLookup[fastCacheBall, resolvedFilter, MinVolume],
					finalRetentateVolume < minFilterVolume, fastAssocLookup[fastCacheBall, resolvedFilter, {Model, MinVolume}],

					(* If the retentate volume is below reservoir MinVolume *)
					finalRetentateVolume < minSampleReservoirVolume && uPulseQ, $MinMicropulseRetentateVolume,
					finalRetentateVolume < minSampleReservoirVolume && MatchQ[resolvedSampleReservoir, ObjectP[Model]], fastAssocLookup[fastCacheBall, resolvedSampleReservoir, MinVolume],
					finalRetentateVolume < minSampleReservoirVolume, fastAssocLookup[fastCacheBall, resolvedSampleReservoir, {Model, MinVolume}],

					(* shouldn't get here *)
					True, Null
				];


				(* Prepare a packet of the resolved sample reservoir *)
				resolvedSampleReservoirPacket=fetchPacketFromCache[resolvedSampleReservoir,newCache];

				(* Check if the sterility of the sample reservoir matches the specified sterility -- sometimes the sterility will not match since not all samples reservoirs are available in sterile form. The manufacturer only makes 250 and 500 mL sterile containers, so volumes outside those ranges won't be sterile *)
				sampleReservoirSterileMatchQ=If[
					resolvedSterile,
					MatchQ[Lookup[resolvedSampleReservoirPacket,Sterile],resolvedSterile],
					True
				];

				(* ----- Resolve PrimaryPumpFlowRate ----- *)
				resolvedPrimaryPumpFlowRate=Which[

					(* If flow rate is specified, use that *)
					MatchQ[Lookup[optionSet, PrimaryPumpFlowRate],Except[Automatic]],
					Lookup[optionSet, PrimaryPumpFlowRate],

					(* Otherwise, if using KR2i resolve to the default of the filter ( a bit under, to avoid pressure alarms) or the flow the tubing can handle, whatever is smaller *)
					(* The FilterFeedPrecutTubing was default to ObjectP[Model[Plumbing, Tubing, "PharmaPure #16"]] which has the flow rate limit for 479 Milliliter/Minute*)
					Not[uPulseQ],
					Min[Floor[Lookup[resolvedFilterPacket,DefaultFlowRate]*0.9], 479 Milliliter/Minute],
					
					(* If using uPulse as the instrument, set to Null*)
					True,
					Null
				];
				

				(* ----- Resolve RetentateStorageCondition ----- *)
				resolvedRetentateStorageCondition=Which[

					(* If specified, use it *)
					MatchQ[Lookup[optionSet,RetentateStorageCondition],Except[Automatic]],
					Lookup[optionSet,RetentateStorageCondition],

					(* If sample has storage information, use that *)
					(!NullQ[Lookup[samplePacket,StorageCondition]])&&impliedRetentateAliquotQ,sampleStorageConditionExpression,

					(* Otherwise, store in the fridge *)
					impliedRetentateAliquotQ,Refrigerator,
					
					(* for uPulse, default to Null *)
					True, Null
				];
				
				(* Return all resolved values and error checkers *)
				{
					(*1*)resolvedSampleInVolume,
					(*2*)resolvedFiltrationMode,
					(*3*)resolvedPrimaryConcentrationTarget,
					(*4*)resolvedSecondaryConcentrationTarget,
					(*5*)resolvedDiafiltrationTarget,
					(*6*)resolvedSizeCutoff,
					(*7*)resolvedFilter,
					(*8*)resolvedSampleReservoir,
					(*9*)resolvedTransmembranePressureTarget,
					(*10*)resolvedPermeateContainerOut,
					(*11*)resolvedPermeateStorageCondition,
					(*12*)resolvedPrimaryPumpFlowRate,
					(*13*)resolvedDiafiltrationBuffer,
					(*14*)resolvedRetentateContainerOut,
					(*15*)resolvedRetentateStorageCondition,
					(*16*)resolvedRetentateAliquotVolume,
					(*17*)resolvedDiafiltrationMode,
					(*18*)resolvedDiaFiltrationExchangeCount,
					(*19*)resolvedDeadVolumeRecoveryMode,

					(* misc values*)
					(*1*)minFilterVolume,
					(*2*)specifiedTargetOptions,
					(*3*)failingVolumeOutput,
					(*4*)failedRetentateAboveMinOption,
					(*5*)failedRetentateMinSpecification,
					(*6*)failedRetentateAboveMinVolume,
					(*7*)maxSizeCutoff,
					(*8*)diafiltrationQ,
					(*9*)concentrationQ,
					(*10*)theoreticalRetentateVolume,
					(*11*)diafiltrationPermeateVolume,
					(*12*)finalRetentateVolume,

					(* Valid checks *)
					(*1*)validSampleInVolumeQ,
					(*2*)crossFlowExceedCapacityQ,
					(*3*)validFiltrationModeQ,
					(*4*)validTargetAmountsQ,
					(*5*)validTargetQ,
					(*6*)failedTargetSteps,
					(*7*)failedTargetValues,
					(*8*)reservoirCompatibleWithVolumeQ,
					(*9*)filterCompatibleWithVolumeQ,
					(*10*)retentateVolumeValidQ,
					(*11*)permeateVolumeValidQ,
					(*12*)retentateVolumeSampleCompatibleQ,
					(*13*)permeateVolumeSampleCompatibleQ,
					(*14*)permeateVolumesScaleCompatibleQ,
					(*15*)volumeOutputsValidQ,
					(*16*)diafiltrationBuffersValidQ,
					(*17*)crossFlowNonOptimalSizeCutoffQ,
					(*18*)crossFlowFilterSterileUnavailableQ,
					(*19*)crossFlowDefaultFilterReturnedQ,
					(*20*)retentateVolumeAboveMinQ,
					(*21*)sampleReservoirSterileMatchQ,
					(*22*)sizeCutoffsMatchQ,
					(*23*)invalidSampleReservoirQ,
					(*24*)invalidFilterTypeQ,
					(*25*)invalidDiafiltrationModeQ,
					(*26*)invalidDiaFiltrationExchangeCountQ,
					(*27*)invalidFiltrationModeQ,
					(*28*)invalidDiaFiltrationVolumeQ,
					(*29*)invalidDeadVolumeRecoveryModeQ
				}

			]
		],
		(* All listed values *)
		{
			(*1*)mapThreadSafeOptions,
			(*2*)preResolvedSampleInVolumes,
			(*3*)inputSampleReservoirPackets,
			(*4*)sampleWithoutCompositionList,
			(*5*)simulatedSamplePackets,
			(*6*)sampleModelPackets,
			(*7*)inputFilterPackets,
			(*8*)inputPermeateContainerPackets,
			(*9*)sampleContainerPackets
		}
	];
	
	(* Resolve the filter storage condition at the end, this is because we want the same storage condition for filters with same objects and models *)
	(* First preresolve all filter storage conditions *)
	preResolvedFilterStorageConditions= If[uPulseQ,
		Replace[initialFilterStorageConditions,{Automatic->AmbientStorage},{1}],
		Replace[initialFilterStorageConditions,{Automatic->Disposal},{1}]
	];
	
	filterToStorageConditionRules=Rule@@@Transpose[{resolvedFilters,preResolvedFilterStorageConditions}];
	
	(* build the rule for replacing the unique storage conditions later*)
	uniqueFilterToStorageConditionRules=DeleteDuplicates/@Merge[filterToStorageConditionRules,Identity];
	
	(* check if same column is specified two different storage conditions *)
	conflictingFilterStorageConditionsList=Map[
		(Length[#]>1)&,
		Values[uniqueFilterToStorageConditionRules]
	];
	
	(* Throw an error i *)
	If[Or@@conflictingFilterStorageConditionsList,
		Message[Error::CrossFlowFilteConflictingFilterStorageCondition,Keys[uniqueFilterToStorageConditionRules],Values[uniqueFilterToStorageConditionRules]]
	];
	
	conflictingFilterStorageConditionsTest=If[
		gatherTests,
		Test["If specified, one type of filters will only have one valid storage condition:",!(Or@@conflictingFilterStorageConditionsList),True],
		Nothing
	];
	
	(* replace the existing storage conditions to generate resolved options *)
	resolvedFilterStorageConditions = FirstOrDefault/@ Replace[resolvedFilters,uniqueFilterToStorageConditionRules,{1}];

	(* Resolve FilterPrime and FilterFlush *)
	(* Get the first packet, for KR2i CFF instrument we will only have one filter *)
	firstFilterPacket=fetchPacketFromCache[FirstOrDefault[resolvedFilters],newCache];

	(* ----- Resolve FilterPrimeBuffer ----- *)
	resolvedFilterPrimeBuffer=Which[

		(* If filter buffer is specified, use it *)
		initialFilterPrime&&MatchQ[initialFilterPrimeBuffer,Except[Automatic]],initialFilterPrimeBuffer,
		
		And[uPulseQ, initialFilterPrime], Model[Sample, StockSolution, "0.1 M NaOH"],

		(* If membrane is PS and is made by Repligen, resolve to 20% ethanol -- this is done because the Repligen PS filters are washed with ethanol and Cytiva PS filters are washed with water. Module family is the easiest way of figuring out who made the filter *)
		And[
			initialFilterPrime,
			Not[uPulseQ],
			MatchQ[Lookup[firstFilterPacket,MembraneMaterial],Polysulfone],
			MatchQ[Lookup[firstFilterPacket,ModuleFamily],MicroKros|MidiKros|MidiKrosTC|MiniKrosSampler]
		],Model[Sample,StockSolution,"20% Ethanol"],

		(* If filter prime is true under any other circumstance, resolve to water *)
		And[Not[uPulseQ],initialFilterPrime],Model[Sample,"Milli-Q water"],

		(* Otherwise, return Null *)
		True,Null
	];

	(* ----- Resolve FilterPrimeVolume ----- *)
	resolvedFilterPrimeVolume=Module[{calculatedFilterPrimeVolume,surfaceArea},
		
		(* Find the filter's surface area *)
		surfaceArea=UnitConvert[Lookup[firstFilterPacket,FilterSurfaceArea, 0 Centimeter^2], Centimeter^2];
		
		(* Calculate filter prime volume so we can throw an error if the volume the user specified is too small for the filter, or set it based on the calculation if not specified.
		If filter is PES, wash with 1 mL per cm2, otherwise wash with 2 mL per cm2 *)
		calculatedFilterPrimeVolume=If[
			uPulseQ,
			40 Milliliter,
			Min[
				500Milliliter,
				1.2*If[
					MatchQ[Lookup[firstFilterPacket,MembraneMaterial],Polyethersulfone],
					Unitless[surfaceArea]*1 Milliliter,
					Unitless[surfaceArea]*2 Milliliter
				]
			]
		];
		
		
		Which[
			
			(* If filter volume is specified, use it (but add 15% to make sure nothing dried out), but check if it's at least equal to the calculated minimum filter prime volume *)
			MatchQ[roundedFilterPrimeVolume,Except[Automatic]],
			
			If[UnitConvert[roundedFilterPrimeVolume,Milliliter]>=calculatedFilterPrimeVolume,UnitConvert[roundedFilterPrimeVolume,Milliliter],
				(*If filter prime volume is not at least twice the calculated filter prime volume, throw a warning that we are setting it to the calculated volume and set it*)
				Module[{},Message[Error::CrossFlowFilterPrimeVolumeTooLow,roundedFilterPrimeVolume,calculatedFilterPrimeVolume];calculatedFilterPrimeVolume]],
			
			(* If volume is not specified, calculate from filter's surface area *)
			initialFilterPrime,
			(* Return the calculated volume if it's not greater than 500 mL *)
			calculatedFilterPrimeVolume,
			
			(* Otherwise, return Null *)
			True,Null
		]
	];


	(* ----- Resolve FilterPrimeRinse ----- *)
	(* Get the first diafiltration model if any *)
	firstDiafiltrationBuffer=FirstOrDefault[Cases[resolvedDiafiltrationBuffers,ObjectReferenceP[]]];
	
	(* Find the diafiltration buffer model *)
	firstDiafiltrationBufferModel=Which[
		!(And@@diafiltrationList),Null,
		NullQ[firstDiafiltrationBuffer], Null,
		MatchQ[firstDiafiltrationBuffer,ObjectP[Model[Sample]]],firstDiafiltrationBuffer,
		True,Lookup[fetchPacketFromCache[firstDiafiltrationBuffer,newCache],Model, Null]
	];

	(* Check if the prime buffer is compatible with the diafiltration buffer *)
	primeSameAsDiafiltrationQ=If[
		(And@@diafiltrationList)&&initialFilterPrime,
		Module[{filterPrimeBufferModel},

			(* Find the filter prime buffer model *)
			filterPrimeBufferModel=If[
				MatchQ[resolvedFilterPrimeBuffer,ObjectP[Model[Sample]]],
				resolvedFilterPrimeBuffer,
				Lookup[fetchPacketFromCache[resolvedFilterPrimeBuffer,newCache],Model]
			];

			(* Compare the two buffers *)
			MatchQ[filterPrimeBufferModel,ObjectP[firstDiafiltrationBufferModel]]
		],
		False
	];

	(* Resolve FilterPrimeRinse *)
	resolvedFilterPrimeRinse=If[

		(* If rinse is specified, do it if both Prime and Rinse are on *)
		MatchQ[initialFilterPrimeRinse,Except[Automatic]],
		initialFilterPrimeRinse,

		(* Otherwise, do it if 1) we are doing filter prime, 2) either a rinse buffer is specified, or we resolved to a buffer that isn't water and isn't the same as the diafiltration buffer *)
		And[
			initialFilterPrime,
			Or[
				MatchQ[initialFilterPrimeRinseBuffer,Except[Null|Automatic]],
				MatchQ[resolvedFilterPrimeBuffer,Except[Null|ObjectP[Model[Sample,"Milli-Q water"]]]]&&!primeSameAsDiafiltrationQ
			]
		]
	];

	(* ----- Resolve FilterPrimeRinseBuffer ----- *)

	(* Resolve the buffer *)
	resolvedFilterPrimeRinseBuffer=Which[
		
		(* If rinse buffer is specified, use it *)
		MatchQ[initialFilterPrimeRinseBuffer,Except[Automatic]],initialFilterPrimeRinseBuffer,

		(* If resolvedFilterPrimeRinse is False, this is null *)
		!resolvedFilterPrimeRinse,Null,
		
		(* If it wasn't specified but we resolved any diafiltration buffers, grab the first one *)
		(And@@diafiltrationList),firstDiafiltrationBuffer,

		(* If it wasn't specified and no diafiltration buffers were resolved, just go with water *)
		True,Model[Sample,"Milli-Q water"]
	];

	(* If resolvedFilterPrimeRinseBuffer is not the same model as resolvedDiafiltrationBuffers, raise a warning *)
	compatibleFilterPrimeRinseBufferQ=If[
		(And@@diafiltrationList)&&resolvedFilterPrimeRinse,
		Module[{filterPrimeRinseBufferModel},

			(* Find the filter prime rinse buffer model *)
			filterPrimeRinseBufferModel=If[
				MatchQ[resolvedFilterPrimeRinseBuffer,ObjectP[Model[Sample]]],
				resolvedFilterPrimeRinseBuffer,
				Lookup[fetchPacketFromCache[resolvedFilterPrimeRinseBuffer,newCache],Model]
			];


			(* Compare the two buffers *)
			MatchQ[filterPrimeRinseBufferModel,ObjectP[firstDiafiltrationBufferModel]]
		],
		True
	];

	(* If resolvedFilterPrimeRinseBuffer is not the same model as resolvedDiafiltrationBuffers, raise a warning *)
	If[
		!compatibleFilterPrimeRinseBufferQ&&messages&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::CrossFlowPrimeBuffersIncompatible,resolvedFilterPrimeRinseBuffer,firstDiafiltrationBufferModel]
	];

	(* Build a warning test for compatibleFilterPrimeRinseBufferQ *)
	compatibleFilterPrimeRinseBufferWarning=If[
		gatherTests,
		Warning["FilterPrimeRinseBuffer is recommended to be the same as DiafiltrationBuffers.",compatibleFilterPrimeRinseBufferQ,True],
		Nothing
	];

	(* ----- Resolve FilterPrimeFlowRate ----- *)
	resolvedFilterPrimeFlowRate=Which[

		(* If flow rate is specified, use that *)
		initialFilterPrime&&MatchQ[roundedFilterPrimeFlowRate,Except[Automatic]]&&Not[uPulseQ],UnitConvert[roundedFilterPrimeFlowRate,Milliliter/Minute],

		(* If flow rate is not specified but we are priming, resolve to filter default (a bit under, to avoid pressure alarms) *)
		initialFilterPrime&&Not[uPulseQ],Min[Floor[Lookup[firstFilterPacket,DefaultFlowRate]*0.9],479 Milliliter/Minute], (* The FilterFeedPrecutTubing was default to ObjectP[Model[Plumbing, Tubing, "PharmaPure #16"]] which has the flow rate limit for 479 Milliliter/Minute*)

		(* Otherwise, return Null *)
		True,Null
	];
	
	(* ----- Resolve FilterPrimeTransmembranePressureTarget ----- *)
	resolvedFilterPrimeTransmembranePressureTarget=Which[

		(* If target is specified, use that *)
		initialFilterPrime&&MatchQ[roundedFilterPrimeTransmembranePressureTarget,Except[Automatic]],UnitConvert[roundedFilterPrimeTransmembranePressureTarget,PSI],

		(* If target is not specified, resolve to 10 PSI *)
		initialFilterPrime&&Not[uPulseQ],10 PSI,

		(* Otherwise, return Null *)
		True,Null
	];

	(* ----- Resolve FilterFlush ----- *)
	resolvedFilterFlush=Which[

		(* If specified, use it *)
		MatchQ[initialFilterFlush,Except[Automatic]],initialFilterFlush,

		(* If any filter flush option is specified, return True -- we are making an exception for Rinse. If its specified as false, it is not a problem so we are only checking for True *)
		Or[
			MatchQ[initialFilterFlushRinse,True],
			MatchQ[initialFilterFlushBuffer,Except[Automatic]],
			MatchQ[roundedFilterFlushVolume,Except[Automatic]],
			MatchQ[roundedFilterFlushFlowRate,Except[Automatic]],
			MatchQ[roundedFilterFlushTransmembranePressureTarget,Except[Automatic]]
		],True,

		(* If filter is being discarded, return False *)
		MatchQ[resolvedFilterStorageConditions,{Disposal..}],False,

		(* Otherwise resolve to false *)
		uPulseQ,True,
		
		(* catch all for false *)
		True, False
	];

	(* ----- Resolve FilterFlushBuffer ----- *)
	resolvedFilterFlushBuffer=Which[
		
		(* If filter buffer is specified, use it *)
		MatchQ[initialFilterFlushBuffer,Except[Automatic]],initialFilterFlushBuffer,
		
		(* if using uPulse, we use 0.1 M NaOH to clean the filter *)
		resolvedFilterFlush&&uPulseQ, Model[Sample, StockSolution, "0.1 M NaOH"],
		
		(* If filter flush is false, return Null *)
		resolvedFilterFlush,Model[Sample,"Milli-Q water"],
		
		(* Otherwise resolve to water *)
		True,Null
	];

	(* ----- Resolve FilterFlushRinse ----- *)
	resolvedFilterFlushRinse=If[

		(* If rinse is specified, do it *)
		MatchQ[initialFilterFlushRinse,Except[Automatic]],
		initialFilterFlushRinse,

		(* Otherwise, do it if the buffer isn't water *)
		MatchQ[resolvedFilterFlushBuffer,Except[Null|Model[Sample,"Milli-Q water"]]]
	];

	(* ----- Resolve FilterFlushVolume ----- *)
	resolvedFilterFlushVolume=Which[
		(* If filter volume is specified, use it *)
		MatchQ[roundedFilterFlushVolume,Except[Automatic]],UnitConvert[roundedFilterFlushVolume,Milliliter],
		
		(* If filter flush is false, return Null *)
		resolvedFilterFlush && uPulseQ, 40 Milliliter,

		(* Otherwise, calculate from filter's surface area *)
		resolvedFilterFlush,Module[{surfaceArea,calculatedFilterFlushVolume},

			(* Find the filter's surface area *)
			surfaceArea=UnitConvert[Lookup[firstFilterPacket,FilterSurfaceArea], Centimeter^2];

			(* Wash with 1 mL per cm2 *)
			calculatedFilterFlushVolume=Unitless[surfaceArea]*1 Milliliter;

			(* Return the calculated volume if it's not greater than 500 mL *)
			If[
				2*calculatedFilterFlushVolume<500 Milliliter,
				2*calculatedFilterFlushVolume,
				500 Milliliter
			]
		],
		True, Null
	];

	(* ----- Resolve FilterFlushFlowRate ----- *)
	resolvedFilterFlushFlowRate=Which[
		
		(* If flow rate is specified, use that *)
		MatchQ[roundedFilterFlushFlowRate,Except[Automatic]],UnitConvert[roundedFilterFlushFlowRate,Milliliter/Minute],

		(* Otherwise, resolve to filter default (a little under, to avoid high pressure alarms) *)
		(* The FilterFeedPrecutTubing was default to ObjectP[Model[Plumbing, Tubing, "PharmaPure #16"]] which has the flow rate limit for 479 Milliliter/Minute*)
		resolvedFilterFlush&&Not[uPulseQ],Min[Floor[Lookup[firstFilterPacket,DefaultFlowRate]*0.9],479 Milliliter/Minute],
		
		True, Null
	];

	(* ----- Resolve FilterFlushTransmembranePressureTarget ----- *)
	resolvedFilterFlushTransmembranePressureTarget=Which[

		(* If flow rate is specified, use that *)
		MatchQ[roundedFilterFlushTransmembranePressureTarget,Except[Automatic]],UnitConvert[roundedFilterFlushTransmembranePressureTarget,PSI],

		(* Otherwise, resolve to 10 PSI *)
		resolvedFilterFlush&&Not[uPulseQ],10 PSI,
		
		True, Null
	];
	
	(* ----- Make sure initial or concentrated sample volume isn't smaller than the system's dead volume ----- *)
	(* Calculate the system dead volume and throw the warning*)
	If[
		uPulseQ,
		deadVolumeErrorQ = False;
		uPulseDeadVolume = 0.65 Milliliter, (* Instrument specification *)

		(*KR2i deadvolume calculation and error checks*)
		Module[
			{
				xamplerFilterModels, filterModel, xamplerFilterQ, KR2iDeadVolume, sampleReservoirMinVolume, diafiltrationBufferContainerToFeedContainerTubingPacket, feedContainerToFeedPressureSensorTubingPacket,
				permeatePressureSensorToConductivitySensorTubingPacket, retentateConductivitySensorToFeedContainerTubingPacket, retentatePressureSensorToConductivitySensorTubingPacket,
				retentateConductivitySensorInletTubingPacket, retentateConductivitySensorOutletTubingPacket, permeateConductivitySensorInletTubingPacket,
				permeateConductivitySensorOutletTubingPacket, filterToPermeatePressureSensorTubingPacket, feedPressureSensorToFilterTubingPacket,
				filterToRetentatePressureSensorTubingPacket,diafiltrationTubingObj, permeateTubingObj, retentateTubingObj,conductivitySensorTubingObj,
				filterTubingParentTubingObj, filterAuxiliaryPermeateTubingPacket
			},

			(* NOTE: Depending on the filter we are using, we might have to cut an additional tubing *)
			(* Get a boolean that states whether the filter is an xampler filter or not *)
			(* Generate the coupling ring resources *)
			(* The filters that require TriCloverClamp connections are the following *)
			xamplerFilterModels = {
				Model[Item, CrossFlowFilter, "id:E8zoYvNEGW0X"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 100 kDa"] *)
				Model[Item, CrossFlowFilter, "id:Vrbp1jKWwNAx"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 50 kDa"] *)
				Model[Item, CrossFlowFilter, "id:9RdZXv14EO6l"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 30 kDa"] *)
				Model[Item, CrossFlowFilter, "id:J8AY5jD3LBl7"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 10 kDa"] *)
				Model[Item, CrossFlowFilter, "id:KBL5DvwKEMEa"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 5 kDa"] *)
				Model[Item, CrossFlowFilter, "id:dORYzZJqwNLq"] (* Model[Item, CrossFlowFilter, "Dry Xampler PS 0.2 Micron"] *)
			};

			(* Get the filter model *)
			filterModel = If[MatchQ[First[resolvedFilters], ObjectP[Model[Item,CrossFlowFilter]]],
				First[resolvedFilters],
				Download[fastAssocLookup[fastCacheBall, First[resolvedFilters], Model],Object]
			];

			xamplerFilterQ = MemberQ[xamplerFilterModels,Download[filterModel,Object]];

			(* use the helper function to calculate all tubing *)
			{
				{
					diafiltrationBufferContainerToFeedContainerTubingPacket,
					feedContainerToFeedPressureSensorTubingPacket,
					permeatePressureSensorToConductivitySensorTubingPacket,
					retentateConductivitySensorToFeedContainerTubingPacket,
					retentatePressureSensorToConductivitySensorTubingPacket,
					retentateConductivitySensorInletTubingPacket,
					retentateConductivitySensorOutletTubingPacket,
					permeateConductivitySensorInletTubingPacket,
					permeateConductivitySensorOutletTubingPacket,
					filterToPermeatePressureSensorTubingPacket,
					filterAuxiliaryPermeateTubingPacket,
					feedPressureSensorToFilterTubingPacket,
					filterToRetentatePressureSensorTubingPacket
				},
				{
					diafiltrationTubingObj,
					permeateTubingObj,
					retentateTubingObj,
					conductivitySensorTubingObj,
					filterTubingParentTubingObj
				}
			}=calculateAllTubingPackets[resolvedSampleReservoirPacket,xamplerFilterQ,fastCacheBall];

			KR2iDeadVolume = calculateKR2iDeadVolume[
				Lookup[firstFilterPacket, MinVolume, 0 Milliliter],
				Lookup[feedContainerToFeedPressureSensorTubingPacket, Object],
				Lookup[retentatePressureSensorToConductivitySensorTubingPacket, Object],
				Lookup[retentateConductivitySensorToFeedContainerTubingPacket, Object],
				newCache
			];

			(* Get the minimum volume of the sample reservoir, we have to add this to the dead volume because we can't have the volume in the sample reservoir be less than this value. *)
			sampleReservoirMinVolume = Lookup[resolvedSampleReservoirPacket,MinVolume];

			(* Figure out if we need to raise a dead-volume error *)
			deadVolumeErrorQ=And[
				Or[
					(* Here KR2i only allows one sample, we just use the first one *)
					FirstOrDefault[resolvedSampleInVolumes] < (KR2iDeadVolume + sampleReservoirMinVolume),
					FirstOrDefault[theoreticalRetentateVolumes] < (KR2iDeadVolume + sampleReservoirMinVolume)
				]
			];

			(* Raise warning if needed *)
			If[
				deadVolumeErrorQ&&messages&&Not[MatchQ[$ECLApplication,Engine]],
				Message[Error::CrossFlowSampleDeadVolume,FirstOrDefault[resolvedSampleInVolumes],FirstOrDefault[theoreticalRetentateVolumes],KR2iDeadVolume + sampleReservoirMinVolume]
			];

		]
	];

	(* ---------- COMPATIBILITY CHECKS ----------*)

	(* Check if the sample is compatible with instrument *)
	{compatibleSampleQ,incompatibleSampleTest}=If[
		gatherTests,
		CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Output->{Result,Tests},Cache->newCache],
		{CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Messages->messages,Cache->newCache],{}}
	];

	incompatibleInputs= If[Not[compatibleSampleQ], simulatedSamples, {}];

	(* Check if the diafiltration buffers are compatible with the instrument for each step -- Diafiltration buffers are Null for concentration steps so we need to remove those *)
	{incompatibleDiafiltrationBuffer,incompatibleDiafiltrationBufferTest}=Which[
		NullQ[resolvedDiafiltrationBuffers],{True,{}},
		gatherTests, CompatibleMaterialsQ[resolvedInstrument,ToList[resolvedDiafiltrationBuffers],Output->{Result,Tests},Cache->newCache],
		True,{CompatibleMaterialsQ[resolvedInstrument,ToList[resolvedDiafiltrationBuffers],Messages->messages,Cache->newCache],{}}
	];

	(* Check if the filter prime buffer is compatible with the instrument *)
	{incompatibleFilterPrimeBuffer,incompatibleFilterPrimeBufferTest}=Which[

		(* If the buffer is not a sample, return true *)
		!MatchQ[resolvedFilterPrimeBuffer,ObjectReferenceP[{Object[Sample],Model[Sample]}]],{True,{}},

		(* If we are gathering tests, return with tests *)
		gatherTests,CompatibleMaterialsQ[resolvedInstrument,resolvedFilterPrimeBuffer,Output->{Result,Tests},Cache->newCache],

		(* Otherwise, we have buffer and we are not gathering tests, so only return the result *)
		True,{CompatibleMaterialsQ[resolvedInstrument,resolvedFilterPrimeBuffer,Messages->messages,Cache->newCache],{}}
	];

	(* Check if the filter flush buffer is compatible with the instrument *)
	{incompatibleFilterFlushBuffer,incompatibleFilterFlushBufferTest}=Which[

		(* If the buffer is not a sample, return true *)
		!MatchQ[resolvedFilterFlushBuffer,ObjectP[{Object[Sample],Model[Sample]}]],{True,{}},

		(* If we are gathering tests, return with tests *)
		gatherTests,CompatibleMaterialsQ[resolvedInstrument,resolvedFilterFlushBuffer,Output->{Result,Tests},Cache->newCache],

		(* Otherwise, we have buffer and we are not gathering tests, so only return the result *)
		True,{CompatibleMaterialsQ[resolvedInstrument,resolvedFilterFlushBuffer,Messages->messages,Cache->newCache],{}}
	];

	(* ---------- Error Checks ---------- *)
	(* If sample doesn't have enough volume and messages are on, throw an error *)
	If[
		!(And@@validSampleInVolumeList)&&messages,
		Message[
			Error::CrossFlowInsufficientSampleVolume,
			PickList[resolvedSampleInVolumes,validSampleInVolumeList,False],
			PickList[sampleNames,validSampleInVolumeList,False],
			UnitConvert[
				Lookup[PickList[simulatedSamplePackets,validSampleInVolumeList,False],Volume,Null],
				Units[PickList[resolvedSampleInVolumes,validSampleInVolumeList,False]]
			]
		]
	];

	(* If gathering tests, create a passing or failing test *)
	validSampleInVolumeTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@validSampleInVolumeList),Test["If specified, SampleInVolume is less than the total available sample volume:",True,True],
		gatherTests&&!(And@@validSampleInVolumeList),Test["If specified, SampleInVolume is less than the total available sample volume:",True,False]
	];


	(* Throw a warning if the volume exceed the capacity*)
	If[
		(Or@@crossFlowExceedCapacityList)&&!MatchQ[$ECLApplication,Engine]&&messages,
		Message[Warning::CrossFlowSampleVolumeExceedsCapacity,PickList[sampleNames, crossFlowExceedCapacityList, True],If[uPulseQ,"50 mL","2 liters"]]
	];

	(* Build a warning tests *)
	crossFlowExceedCapacityWarnings=If[
		gatherTests,
		Warning["The SampleVolume has been adjusted since the max volume of the sample exceed the max volume of the instrument: "<>If[uPulseQ,"50 mL","2 liters"],Or@@crossFlowExceedCapacityList,False],
		Nothing
	];

	(* If permeate volume is higher than sample volume and messages are on, throw an error *)
	If[
		!(And@@validTargetAmountList)&&messages,
		Message[Error::CrossFlowConcentrationFactorExceedsUnity,PickList[resolvedSampleInVolumes, validTargetAmountList, False]]
	];

	(* If gathering tests, create a passing or failing test *)
	validTargetAmountsTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@validTargetAmountList),Test["If specified, total concentration factor is less than 1:",True,True],
		gatherTests&&!(And@@validTargetAmountList),Test["If specified, total concentration factor is less than 1:",True,False]
	];

	(* If any targets are above 1 and messages are on, throw an error *)
	If[
		!(And@@validTargetList)&&messages,
		Message[Error::CrossFlowInvalidTarget,failedTargetStepsList,failedTargetValuesList]
	];

	(* If gathering tests, create a passing or failing test *)
	validTargetQTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@validTargetList),Test["If specified, targets for concentration steps do not exceed the sample volume for any step:",True,True],
		gatherTests&&!(And@@validTargetList),Test["If specified, targets for concentration steps do not exceed the sample volume for any step:",True,False]
	];


	(* If the SampleInVolume doesn't fit in reservoir and messages are on, throw an error *)
	If[
		!(And@@reservoirCompatibleWithVolumeList)&&messages,
		Message[
			Error::CrossFlowReservoirIncompatibleWithVolume,
			PickList[resolvedSampleInVolumes, reservoirCompatibleWithVolumeList, False],
			With[
				{filteredPackets= PickList[inputSampleReservoirPackets,reservoirCompatibleWithVolumeList,False]},
				Lookup[filteredPackets,Object]
			]
		]
	];

	(* If gathering tests, create a passing or failing test *)
	reservoirCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@reservoirCompatibleWithVolumeList),Test["If specified, SampleInVolume fits within the specified sample reservoir:",True,True],
		gatherTests&&!(And@@reservoirCompatibleWithVolumeList),Test["If specified, SampleInVolume fits within the specified sample reservoir:",True,False]
	];

	(* If the SampleInVolume doesn't fit in reservoir and messages are on, throw an error *)
	If[
		!(And@@filterCompatibleWithVolumeList)&&messages,
		Message[
			Error::CrossFlowFilterIncompatibleWithVolume,
			PickList[resolvedSampleInVolumes,filterCompatibleWithVolumeList,False],
			With[{filteredPackets= PickList[inputFilterPackets,filterCompatibleWithVolumeList,False]},
				Lookup[filteredPackets,Object]
			]
		]
	];

	(* If gathering tests, create a passing or failing test *)
	filterCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@filterCompatibleWithVolumeList),Test["If specified, SampleInVolume fits within the specified filter:",True,True],
		gatherTests&&!(And@@filterCompatibleWithVolumeList),Test["If specified, SampleInVolume fits within the specified filter:",True,False]
	];

	(* If the roundedRetentateAliquotVolume doesn't fit in container and messages are on, throw an error *)
	If[
		!(And@@retentateVolumeValidList)&&messages,
		Message[
			Error::CrossFlowRetentateVolumeExceedsContainer,
			PickList[resolvedRetentateAliquotVolumes, retentateVolumeValidList, False],
			PickList[resolvedRetentateContainersOut, retentateVolumeValidList, False]
		]
	];

	(* If gathering tests, create a passing or failing test *)
	retentateVolumeValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@retentateVolumeValidList),Test["If specified, RetentateAliquotVolume fits within the specified RetentateContainerOut:",True,True],
		gatherTests&&!(And@@retentateVolumeValidList),Test["If specified, RetentateAliquotVolume fits within the specified RetentateContainerOut:",True,False]
	];

	(* If anything failed, record them for nicer error reporting *)
	failedPermeateAliquotVolumes = PickList[initialPermeateAliquotVolume, permeateVolumeValidList, False];
	failedPermeateContainer = PickList[initialPermeateContainersOut, permeateVolumeValidList, False];
	failedPermeateContainerVolumes = fastAssocLookup[fastCacheBall,#, MaxVolume]&/@failedPermeateContainer;

	(* If the expandedPermeateAliquotVolume doesn't fit in container and messages are on, throw an error *)
	If[
		!(And@@permeateVolumeValidList)&&messages,
		Message[Error::CrossFlowPermeateVolumeExceedsContainer,failedPermeateAliquotVolumes,failedPermeateContainer,failedPermeateContainerVolumes]
	];

	(* If gathering tests, create a passing or failing test *)
	permeateVolumeValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@permeateVolumeValidList),Test["If specified, PermeateAliquotVolume fits within the specified PermeateContainerOut:",True,True],
		gatherTests&&!(And@@permeateVolumeValidList),Test["If specified, PermeateAliquotVolume fits within the specified PermeateContainerOut:",True,False]
	];

	(* If the RetentateAliquotVolume doesn't fit in container and messages are on, throw an error *)
	If[
		!(And@@retentateVolumeSampleCompatibleList)&&messages,
		Message[
			Error::CrossFlowRetentateExceedsSample,
			PickList[resolvedRetentateAliquotVolumes,retentateVolumeSampleCompatibleList,False],
			PickList[theoreticalRetentateVolumes,retentateVolumeSampleCompatibleList,False]
		]
	];

	(* If gathering tests, create a passing or failing test *)
	retentateVolumeSampleCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@retentateVolumeSampleCompatibleList),Test["If specified, RetentateAliquotVolume is less than the SampleInVolume:",True,True],
		gatherTests&&!(And@@retentateVolumeSampleCompatibleList),Test["If specified, RetentateAliquotVolume is less than the SampleInVolume:",True,False]
	];


	(* If the expandedPermeateAliquotVolumes doesn't fit in container and messages are on, throw an error *)
	If[
		!(And@@permeateVolumeSampleCompatibleList)&&messages,
		Message[Error::CrossFlowPermeateExceedsSample,totalPermeateVolume]
	];

	(* If gathering tests, create a passing or failing test *)
	permeateVolumeSampleCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@permeateVolumeSampleCompatibleList),Test["If specified, total PermeateAliquotVolume for concentration steps is less than the SampleInVolume:",True,True],
		gatherTests&&!(And@@permeateVolumeSampleCompatibleList),Test["If specified, total PermeateAliquotVolume for concentration steps is less than the SampleInVolume:",True,False]
	];

	(* If the expandedPermeateAliquotVolumes doesn't fit in container and messages are on, throw an error *)
	If[
		!(And@@permeateVolumesScaleCompatibleList)&&messages,
		Message[Error::CrossFlowPermeateExceedsCapacity]
	];

	(* If gathering tests, create a passing or failing test *)
	permeateVolumesScaleCompatibleTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@permeateVolumesScaleCompatibleList),Test["Generated permeate volume is smaller than the capacity of the instrument:",True,True],
		gatherTests&&!(And@@permeateVolumesScaleCompatibleList),Test["Generated permeate volume is smaller than the capacity of the instrument:",True,False]
	];
	(*

	failingVolumeOutputs,failedRetentateAboveMinOptionList,failedRetentateMinSpecificationList
	*)
	(* Make strings of failed options for the error message *)
	failedVolumeOutputOptionsList= PickList[failingVolumeOutputs,volumeOutputsValidList,False];



	failedVolumeOutputErrorMessages=Switch[#,

		(* If nothing failed, carry on *)
		{},"",

		(* If all three failed *)
		{RetentateAliquotVolume,PermeateAliquotVolume,DiafiltrationTarget,PrimaryConcentrationTarget,SecondaryConcentrationTarget},"the volume specified for PermeateAliquotVolume does not exceed the total volume specified by DiafiltrationTarget, PrimaryConcentrationTarget, and SecondaryConcentrationTarget, and the volume specified for RetentateAliquotVolume does not exceed the difference between PermeateAliquotVolume and SampleInVolume",

		(* If retentate volume and targets failed *)
		{RetentateAliquotVolume,DiafiltrationTarget,PrimaryConcentrationTarget,SecondaryConcentrationTarget},"the volume specified for RetentateAliquotVolume does not exceed the difference between the volume specified by Targets and SampleInVolume",

		(* If permeate volumes and targets failed *)
		{PermeateAliquotVolume,DiafiltrationTarget,PrimaryConcentrationTarget,SecondaryConcentrationTarget},"the volumes specified for PermeateAliquotVolume do not exceed volume specified by Targets",

		(* If retentate and permeate volumes failed *)
		{RetentateAliquotVolume,PermeateAliquotVolume},"the PermeateAliquotVolume specified for concentration steps do not exceed the specified RetentateAliquotVolume divided by the specified number of concentration steps"
	]&/@(PickList[failingVolumeOutputs,volumeOutputsValidList,False]);

	(* If the anything failed and messages are on, throw an error *)
	If[
		!(And@@volumeOutputsValidList)&&messages,
		Message[Error::CrossFlowInvalidOutputVolumes,(failedVolumeOutputOptionsList),(failedVolumeOutputErrorMessages)]
	];

	(* If gathering tests, create a passing or failing test *)
	volumeOutputsValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@volumeOutputsValidList),Test["If two or more options amongst Targets, RetentateAliquotVolume and PermeateAliquotVolume are specified, the volumes specified by these options are consistent:",True,True],
		gatherTests&&!(And@@volumeOutputsValidList),Test["If two or more options amongst Targets, RetentateAliquotVolume and PermeateAliquotVolume are specified, the volumes specified by these options are consistent:",True,False]
	];

	(* ----- Is RetentateVolumeOut,PermeateAliquotVolume or Targets compatible with CrossFlowFilter and SampleReservoir? ----- *)

	(* Check if the calculated or the specified retentate amount was below the minimum container in any scenario above and throw an error -- we only want this going off if we have valid volume information so it's also checked against that *)
	If[
		volumeInformationValidQ&&!(And@@retentateVolumeAboveMinList)&&messages,
		Message[
			(* what we actually want is the final retentate volume and the *)
			Error::CrossFlowRetentateVolumeTooLow,
			ObjectToString[PickList[finalRetentateVolumes,retentateVolumeAboveMinList,False]],
			ObjectToString[PickList[mySamples, retentateVolumeAboveMinList, False], Cache -> newCache],
			ObjectToString[PickList[failedRetentateMinSpecificationList,retentateVolumeAboveMinList,False]],
			ObjectToString[PickList[failedRetentateAboveMinVolumes,retentateVolumeAboveMinList,False]]
		]
	];

	(* If gathering tests, create a passing or failing test *)
	retentateVolumeAboveMinTest=Which[
		!gatherTests,Nothing,
		gatherTests&&volumeInformationValidQ&&(And@@retentateVolumeAboveMinList),Test["If Targets, RetentateAliquotVolume and/or PermeateAliquotVolume are specified, the retentate volume specified by the option(s) is above the minimum volume that can be handled by the sample reservoirs and filters in the system:",True,True],
		gatherTests&&volumeInformationValidQ&&!(And@@retentateVolumeAboveMinList),Test["If Targets, RetentateAliquotVolume and/or PermeateAliquotVolume are specified, the retentate volume specified by the option(s) is above the minimum volume that can be handled by the sample reservoirs and filters in the system:",True,False]
	];

	(* If the anything failed and messages are on, throw an error *)
	If[
		!(And@@diafiltrationBuffersValidList)&&messages,
		Message[Error::CrossFlowInvalidDiafiltrationBuffer,PickList[resolvedDiafiltrationBuffers,diafiltrationBuffersValidList,False]]
	];

	(* If gathering tests, create a passing or failing test *)
	diafiltrationBuffersValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&(And@@diafiltrationBuffersValidList),Test["If specified, DiafiltrationBuffer is not Null:",True,True],
		gatherTests&&!(And@@diafiltrationBuffersValidList),Test["If specified, DiafiltrationBuffer is not Null:",True,False]
	];

	(* If the anything failed and messages are on, throw an error *)
	If[
		(And@@invalidSampleReservoirList)&&messages,
		Message[Error::CrossFlowInvalidSampleReservoir,PickList[simulatedSamples,invalidSampleReservoirList],PickList[resolvedSampleReservoirs,invalidSampleReservoirList],resolvedInstrument]
	];

	(* If gathering tests, create a passing or failing test *)
	invalidSampleReservoirTest=If[
		gatherTests,
		Test["When using uPulse as the Instrument, SampleReservoir can only use Model[Container, Vessel, \"50mL Tube\"] ",And@@invalidSampleReservoirList,False]
	];


	(* If the anything failed and messages are on, throw an error *)
	invalidCrossFlowFilterOptions = If[
		(And@@invalidFilterTypeList)&&messages,
		Message[Error::CrossFlowFilterDoesNotMatchInstrument,PickList[simulatedSamples,invalidFilterTypeList],PickList[resolvedFilters,invalidFilterTypeList],resolvedInstrument];{CrossFlowFilter},
		{}
	];

	(* If gathering tests, create a passing or failing test *)
	invalidCrossFlowFilterTest=Which[
		!gatherTests,Nothing,
		gatherTests&&uPulseQ,Test["When using uPulse as the Instrument, CrossFlowFilter is either an Object[Item, Filter, MicrofluidicChip] or Model[Item, Filter, MicrofluidicChip]:",Not[(And@@invalidFilterTypeList)],True],
		gatherTests,Test["When using KR2i as the Instrument, CrossFlowFilter is either an Object[Item,CrossFlowFilter] or Model[Item,CrossFlowFilter]:",Not[(And@@invalidFilterTypeList)],True]
	];

	(* If the anything failed and messages are on, throw an error *)
	invalidDiafiltrationModeOptions = If[
		(And@@invalidDiafiltrationModeList)&&messages,
		Message[Error::CrossFlowFilterInvalidDiafiltrationMode,PickList[simulatedSamples,invalidDiafiltrationModeList],PickList[resolvedFiltrationModes,invalidDiafiltrationModeList],PickList[resolvedDiafiltrationModes,invalidDiafiltrationModeList]];{DiafiltrationMode},
		{}
	];

	(* If gathering tests, create a passing or failing test *)
	invalidDiafiltrationModeTest=If[
		gatherTests,
		Test["When using uPulse as the Instrument, DiafiltrationMode can only be set if FiltrationMode is ConcentrationDiafiltrationConcentration,ConcentrationDiafiltration or Diafiltration:",Not[(And@@invalidDiafiltrationModeList)],True],
		Nothing
	];

	(* If the anything failed and messages are on, throw an error *)
	invalidDiaFiltrationExchangeCountOptions = If[
		(Or@@invalidDiaFiltrationExchangeCountList)&&messages,
		Message[Error::CrossFlowFilterDiaFiltrationExchangeCount,PickList[simulatedSamples,invalidDiaFiltrationExchangeCountList],PickList[resolvedDiafiltrationModes,invalidDiaFiltrationExchangeCountList],PickList[resolvedDiaFiltrationExchangeCounts,invalidDiaFiltrationExchangeCountList]];{DiafiltrationExchangeCount},
		{}
	];

	(* If gathering tests, create a passing or failing test *)
	invalidDiaFiltrationExchangeCountTest=If[
		gatherTests,
		Test["When using uPulse as the Instrument, DiafiltrationExchangeCount can only be set DiafiltrationMode is discrete:",Not[(And@@invalidDiaFiltrationExchangeCountList)],True],
		Nothing
	];

	(* If the anything failed and messages are on, throw an error *)
	invalidFiltrationModeOptions = If[
		(Or@@invalidFiltrationModeList)&&messages,
		Message[Error::CrossFlowFilterInvalidDiaFiltrationMode,PickList[simulatedSamples,invalidFiltrationModeList],PickList[resolvedFiltrationModes,invalidFiltrationModeList],resolvedInstrument];{FiltrationMode},
		{}
	];

	(* If gathering tests, create a passing or failing test *)
	invalidFiltrationModeTests=If[
		gatherTests,
		Test["When using uPulse as the Instrument, FiltrationMode cannot use Diafiltration:",Not[(And@@invalidDiaFiltrationExchangeCountList)],True],
		Nothing
	];


	(* If the anything failed and messages are on, throw an error *)
	invalidDiafiltrationTargetOptions = If[
		(Or@@invalidDiaFiltrationVolumeList)&&messages,
		Message[
			Error::CrossFlowFilterInvalidDiafiltrationTarget,
			PickList[simulatedSamples,invalidDiaFiltrationVolumeList],
			PickList[resolvedDiafiltrationTargets,invalidDiaFiltrationVolumeList],
			PickList[diafiltrationVolumes,invalidDiaFiltrationVolumeList]
		];{DiafiltrationTarget},
		{}
	];

	(* If gathering tests, create a passing or failing test *)
	invalidDiafiltrationTargetTests=If[
		gatherTests,
		Test["When using uPulse as the Instrument, FiltrationMode cannot use Diafiltration:",Not[(And@@invalidDiaFiltrationVolumeList)],True],
		Nothing
	];

	(* If the anything failed and messages are on, throw an error *)
	invalidDeadVolumeRecoveryModeOptions = If[
		(Or@@invalidDeadVolumeRecoveryModeList)&&messages,
		Message[
			Error::CrossFlowFilterInvalidDeadVolumeRecoveryMode,
			PickList[simulatedSamples,invalidDeadVolumeRecoveryModeList],
			resolvedInstrument,
			PickList[resolvedFiltrationModes,invalidDiaFiltrationVolumeList]
		];{DeadVolumeRecoveryMode},
		{}
	];

	(* If gathering tests, create a passing or failing test *)
	invalidDeadVolumeRecoveryModeTests=If[
		gatherTests,
		Test["When using uPulse as the Instrument, DeadVolumeRecoveryMode is valid:",Not[(And@@invalidDeadVolumeRecoveryModeList)],True],
		Nothing
	];

	(* ----- Is FilterPrime compatible with other filter prime options? ----- *)
	(* Make a list of filter prime options and whether they were specified -- for rinse, we only care about it being specified as True. If it is set to False, no issues *)
	filterPrimeOptionsValidList={
		{
			FilterPrimeRinse,
			FilterPrimeRinseBuffer,
			FilterPrimeBuffer,
			FilterPrimeVolume,
			FilterPrimeFlowRate,
			FilterPrimeTransmembranePressureTarget
		},
		{
			If[
				MatchQ[initialFilterPrimeRinse,Except[Automatic]],
				!initialFilterPrimeRinse,
				True
			],
			MatchQ[initialFilterPrimeRinseBuffer,Automatic],
			MatchQ[initialFilterPrimeBuffer,Automatic],
			MatchQ[roundedFilterPrimeVolume,Automatic],
			MatchQ[roundedFilterPrimeFlowRate,Automatic],
			MatchQ[roundedFilterPrimeTransmembranePressureTarget,Automatic]
		}
	};

	(* Check that the filter is being primed if other options are specified -- FilterPrime is True by default. If it is set to False and another prime option is included, that means two user inputs conflict *)
	filterPrimeOptionsValidQ=If[
		!initialFilterPrime,
		And@@Last[filterPrimeOptionsValidList],
		True
	];

	(* Find out which ones were specified *)
	failedFilterPrimeOptionNames=If[
		!filterPrimeOptionsValidQ,
		Pick[First[filterPrimeOptionsValidList],Last[filterPrimeOptionsValidList],False],
		{}
	];

	(* If filter is not being primed but an option is specified, and messages are on, throw an error *)
	If[
		!filterPrimeOptionsValidQ&&messages,
		Message[Error::CrossFlowPrimeOptionSpecifiedWithoutPrime,failedFilterPrimeOptionNames]
	];

	(* If gathering tests, create a passing or failing test *)
	filterPrimeOptionsValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&filterPrimeOptionsValidQ,Test["If FilterPrime is set to False, no other priming options are specified:",True,True],
		gatherTests&&!filterPrimeOptionsValidQ,Test["If FilterPrime is set to False, no other priming options are specified:",True,False]
	];

	(* ----- Is FilterFlush compatible with other filter flush options? ----- *)

	(* Make a list of filter flush options and whether they were specified -- for rinse, we only care about it being specified as True. If it is set to False, no issues *)
	filterFlushOptionsValidList={
		{
			"\"FilterFlushRinse\"",
			"\"FilterFlushBuffer\"",
			"\"FilterFlushVolume\"",
			"\"FilterFlushFlowRate\"",
			"\"FilterFlushTransmembranePressureTarget\""
		},
		{
			If[
				MatchQ[initialFilterFlushRinse,Except[Automatic]],
				!initialFilterFlushRinse,
				True
			],
			MatchQ[initialFilterFlushBuffer,Automatic],
			MatchQ[roundedFilterFlushVolume,Automatic],
			MatchQ[roundedFilterFlushFlowRate,Automatic],
			MatchQ[roundedFilterFlushTransmembranePressureTarget,Automatic]
		}
	};

	(* Check that the filter is being flushed if other options are specified -- FilterFlush is Automatic by default. If it is set to False and another prime option is included, that means two user inputs conflict *)
	filterFlushOptionsValidQ=If[
		MatchQ[initialFilterFlush,Except[Automatic]]&&!initialFilterFlush,
		And@@Last[filterFlushOptionsValidList],
		True
	];

	(* Find out which ones were specified *)
	failedFilterFlushOptionNames=If[
		!filterFlushOptionsValidQ,
		Pick[First[filterFlushOptionsValidList],Last[filterFlushOptionsValidList],False],
		{}
	];

	(* If filter is not being flushed but an option is specified, and messages are on, throw an error *)
	If[
		!filterFlushOptionsValidQ&&messages,
		Message[Error::CrossFlowFlushOptionSpecifiedWithoutFlush,failedFilterFlushOptionNames]
	];

	(* If gathering tests, create a passing or failing test *)
	filterFlushRinseValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&filterFlushOptionsValidQ,Test["If FilterFlush is set to False, no other flushing options are specified:",True,True],
		gatherTests&&!filterFlushOptionsValidQ,Test["If FilterFlush is set to False, no other flushing options are specified:",True,False]
	];

	(* If sterility doesn't match, display a warning -- we are also checking for error states to ensure that we don't throw an additional error with the fake containers we used to skip the process *)
	crossFlowSterileMisMatchList = MapThread[
		And[
			MatchQ[#1,Automatic],
			!(#2),
			volumeInformationValidQ,
			(#3)
		]&,
		{
			initialSampleReservoirs,
			sampleReservoirSterileMatchList,
			validTargetAmountList
		}
	];

	misMatchedSampleModels=Map[
		If[
			MatchQ[#,ObjectReferenceP[Model[]]],
			#,
			Download[fastAssocLookup[fastCacheBall, #, Model], Object]
		]&,
		PickList[resolvedSampleReservoirs, crossFlowSterileMisMatchList]
	];
	If[
		And[
			And@@crossFlowSterileMisMatchList,
			messages,
			Not[MatchQ[$ECLApplication,Engine]]
		],
		Message[Warning::CrossFlowNonSterileSampleReservoir,misMatchedSampleModels]
	];

	(* Build the warning *)
	crossFlowSterileMisMatchWarnings=If[
		gatherTests,
		Warning["If specified Sterile->True, no reservoir is not available in a sterile form.",And@@crossFlowSterileMisMatchList,False],
		Nothing
	];

	(* If there is a mismatch, display a warning *)
	If[
		(Or@@crossFlowNonOptimalSizeCutoffList)&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[
			Warning::CrossFlowNonOptimalSizeCutoff,
			PickList[sampleNames,crossFlowNonOptimalSizeCutoffList,True],
			PickList[maxSizeCutoffs,crossFlowNonOptimalSizeCutoffList,True]
		]
	];

	(* Build the warning tests *)
	crossFlowNonOptimalSizeCutoffWarnings=If[
		gatherTests,
		Warning["If MolecularWeight of SamplesIn are not specified, an filter with largest possible value for SizeCutoff is selected.",Or@@crossFlowNonOptimalSizeCutoffList,False],
			Nothing
	];

	(* If there is a mismatch, display a warning *)
 	If[
		!(And@@sizeCutoffsMatchList)&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[
			Warning::CrossFlowFilterSpecifiedMismatch,
			PickList[resolvedFilters,sizeCutoffsMatchList,False],
			"\"SizeCutoff\"",
			PickList[resolvedSizeCutoffs,sizeCutoffsMatchList,False]
		]
	];

	(* Build the warning tests *)
	sizeCutoffsMatchWarnings=If[
		gatherTests,
		Warning["If MolecularWeight of SamplesIn are not specified, an filter with largest possible value for SizeCutoff is selected.",Or@@crossFlowNonOptimalSizeCutoffList,False],
		Nothing
	];

	(* If sterility was specified, throw a warning because we are about to choose a filter that doesn't match the resolved sterility -- we are throwing this warning if sterile was specified because if sterile is true, something sterile was specified (either sterile was specified directly or a sterile sample or reservoir was specified). It is not shown in cases where sterile is false and we return a sterile filter *)
	If[
		Or@@crossFlowFilterSterileUnavailableList&&Not[And@@crossFlowSterileMisMatchList]&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::CrossFlowFilterUnavailableFilters,PickList[resolvedSizeCutoffs,crossFlowFilterSterileUnavailableList, True]]
	];

	(* Build the warning tests *)
	crossFlowFilterSterileUnavailableWarnings=If[
		gatherTests,
		Warning["No sterile filter with specified SizeCutoff is found, an default filter is selected.",Or@@crossFlowFilterSterileUnavailableList,False],
		Nothing
	];

	(* Throw a warning because we are returning a default filter *)
	If[
		Or@@crossFlowDefaultFilterReturnedList&&messages&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::CrossFlowDefaultFilterReturned]
	];

	(* Build the warning tests *)
	crossFlowDefaultFilterReturnedWarnings=If[
		gatherTests,
		Warning["Since a filter with required sterility, volume range and size cutoff could not be found, a default filter will be returned",Or@@crossFlowDefaultFilterReturnedList,False],
		Nothing
	];

	(* ---------- OTHER CHECKS ---------- *)

	(* Check if the name is in use *)
	nameNotUniqueQ=TrueQ[DatabaseMemberQ[Append[Object[Protocol,CrossFlowFiltration],initialName]]];

	(* If the name is a duplicate, throw an error *)
	If[
		nameNotUniqueQ,
		Message[Error::DuplicateName,Object[Protocol,CrossFlowFiltration]]
	];

	(* get the resolved Email option; for this experiment, the default is True *)
	email=If[MatchQ[Lookup[crossFlowOptionsAssociation,Email],Automatic],
		True,
		Lookup[crossFlowOptionsAssociation,Email]
	];

	(* If gathering tests, create a passing or failing test *)
	duplicateNameTest=Which[
		!gatherTests,Nothing,
		gatherTests&&nameNotUniqueQ,Test["If name is specified it does not already exist in the database for an Object[Protocol,CrossFlowFiltration]:",True,False],
		gatherTests&&!nameNotUniqueQ,Test["If name is specified it does not already exist in the database for an Object[Protocol,CrossFlowFiltration]:",True,True]
	];

	(* ----- Check for invalid input and option variables ----- *)

	(* Check if any errors have been thrown *)
	invalidInputs=Flatten[{invalidVolumeInputs,discardedInputs,invalidCompositionInputs, incompatibleInputs, invalidVolumeInputs, invalidNumSamplesInputs}];

	(* Make a list of all variables for error tracking *)
	invalidOptionsList={
		(*1*) validInstrumentQ,
		(*2*) And@@validSampleInVolumeList,
		(*3*) And@@validTargetAmountList,
		(*4*) And@@validTargetList,
		(*5*) And@@reservoirCompatibleWithVolumeList,
		(*6*) And@@filterCompatibleWithVolumeList,
		(*7*) And@@retentateVolumeValidList,
		(*8*) And@@permeateVolumeValidList,
		(*9*) And@@retentateVolumeSampleCompatibleList,
		(*10*) And@@permeateVolumeSampleCompatibleList,
		(*11*) And@@permeateVolumesScaleCompatibleList,
		(*12*) And@@retentateVolumeAboveMinList,
		(*13*) And@@volumeOutputsValidList,
		(*14*) And@@diafiltrationBuffersValidList,
		(*15*) filterPrimeOptionsValidQ,
		(*16*) filterFlushOptionsValidQ,
		(*17*) incompatibleDiafiltrationBuffer,
		(*18*) incompatibleFilterPrimeBuffer,
		(*19*) incompatibleFilterFlushBuffer,
		(*20*) !nameNotUniqueQ,
		(*21*) Not[And@@invalidSampleReservoirList],
		(*22*) Not[Or@@conflictingFilterStorageConditionsList],
		(*23*) !deadVolumeErrorQ
	};

	(* Prepare a list of which options are failing for each error *)
	invalidOptionErrors={
		(*1*) Instrument,
		(*2*) SampleInVolume,
		(*3*) Join[specifiedTargetOptionList,{SampleInVolume}],
		(*4*) specifiedTargetOptionList,
		(*5*) {SampleReservoir,SampleInVolume},
		(*6*) {CrossFlowFilter,SampleInVolume},
		(*7*) {RetentateAliquotVolume,RetentateContainerOut},
		(*8*) {RetentateAliquotVolume,PermeateContainerOut},
		(*9*) {RetentateAliquotVolume,SampleInVolume},
		(*10*) {RetentateAliquotVolume,SampleInVolume},
		(*11*) ToList[specifiedTargetOptionList],
		(*12*) ToList[failedRetentateAboveMinOption],
		(*13*) failedVolumeOutputOptionsList,
		(*14*) DiafiltrationBuffer,
		(*15*) Join[failedFilterPrimeOptionNames,{FilterPrime}],
		(*16*) Join[failedFilterFlushOptionNames,{FilterFlush}],
		(*17*) DiafiltrationBuffer,
		(*18*) FilterPrimeBuffer,
		(*19*) FilterFlushBuffer,
		(*20*) Name,
		(*21*) SampleReservoir,
		(*22*) FilterStorageCondition,
		(*23*) {SampleInVolume,PrimaryConcentrationTarget,SecondaryConcentrationTarget}
	};

	(* Prepare a list of which options failed *)
	invalidOptions=DeleteDuplicates[
		Flatten[
			List[
				Pick[invalidOptionErrors,invalidOptionsList,False],
				optionsConflictingWithInstrument,
				instrumentRequiredOptions,
				invalidCrossFlowFilterOptions,
				invalidDiafiltrationModeOptions,
				invalidDiaFiltrationExchangeCountOptions,
				invalidFiltrationModeOptions,
				invalidDiafiltrationTargetOptions,
				invalidDeadVolumeRecoveryModeOptions
			]
		]
	];

	(* If there are invalid inputs, throw error *)
	If[
		Length[invalidInputs]>0,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->newCache]]
	];

	(* If there are invalid options, throw error *)
	If[
		Length[invalidOptions]>0,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* ---------- CONTAINER GROUPING RESOLUTION ---------- *)
	(* Aliquot messages *)
	aliquotWarningMessage=If[
		uPulseQ,"because the given samples are in containers that are not compatible with the uPulse cross flow system. You may set how much volume you wish to be aliquoted using the AliquotAmount or SampleInVolume option.",
		"because the given samples are in containers that are not compatible with the KR2i cross flow system. You may set how much volume you wish to be aliquoted using the AliquotAmount option."
	];

	(* resolved aliquot amounts *)
	requiredAliquotAmounts = If[
		uPulseQ,
		resolvedSampleInVolumes,
		Null
	];

	(* generate required aliquot container *)
	requiredAliquotContainers=If[
		uPulseQ,
		(Model[Container, Vessel, "50mL Tube"])&/@Range[Length[resolvedSampleInVolumes]],
		Null
	];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[
		gatherTests,
		resolveAliquotOptions[
			ExperimentCrossFlowFiltration,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->aliquotWarningMessage,
			Cache->newCache,
			Simulation->updatedSimulation,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentCrossFlowFiltration,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->aliquotWarningMessage,
				Cache->newCache,
				Simulation->updatedSimulation,
				Output->Result
			],
			{}
		}
	];

	(* Resolve post processing options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(*--- Resolve all label options ---*)
	(* --- Resolve SampleLabel --- *)
	resolvedSampleLabels=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["cross-flow filtration samples"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[roundedOptions, SampleLabel]}
		]
	];
	(* --- Resolve SampleContainerLabel --- *)
	resolvedSampleContainerLabels=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[simulatedSamplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["cross-flow filtration container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[roundedOptions, SampleContainerLabel]}
		]
	];
	(* --- Resolve Other Labels --- *)
	{
		resolvedRetentateContainerOutLabels,
		resolvedPermeateContainerOutLabels
	}=MapThread[
		Function[
			{option,values,labelStr},
			MapThread[
				Function[{object, label},
					Which[
						(* Use user specified labels *)
						MatchQ[label, Except[Automatic]],
						label,

						(* Check if this container is previously labeled in the simulation *)
						MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
						LookupObjectLabel[updatedSimulation, Download[object, Object]],

						(* If we resolved to use this container give it a label *)
						MatchQ[object,ObjectP[]],
						CreateUniqueLabel[labelStr],

						(* Otherwise, it means we don't need this container so specify user *)
						True,
						Null
					]
				],
				{values, Lookup[roundedOptions, option]}
			]
		],
		{
			{
				RetentateContainerOutLabel,
				PermeateContainerOutLabel
			},
			{
				resolvedRetentateContainersOut,
				resolvedPermeateContainerOuts
			},
			{
				"cross-flow retentate containerOut label samples",
				"cross-flow permeate containerOut label samples"
			}
		}
	];

	{
		resolvedRetentateSampleOutLabels,
		resolvedPermeateSampleOutLabels
	}=MapThread[
		Function[
			{option,values,labelStr},
			MapThread[
				Function[{object, label},
					Which[
						(* Use user specified label *)
						MatchQ[label, Except[Automatic]],
						label,

						(* Note since we have to use empty container to collect retentae container
						   out or permeate container out we cannot prespecified label of the sample,

						   if specified container we give the sample inside a label
						*)

						MatchQ[object,ObjectP[]],
						CreateUniqueLabel[labelStr],

						(* Otherwise Null *)
						True,
						Null
					]
				],
				{values, Lookup[roundedOptions, option]}
			]
		],
		{
			{
				RetentateSampleOutLabel,
				PermeateSampleOutLabel
			},
			{
				resolvedRetentateContainersOut,
				resolvedPermeateContainerOuts
			},
			{
				"cross-flow retentate samples out label samples",
				"cross-flow permeate samples out label samples"
			}
		}
	];

	(* ----- Output Resolved Options ----- *)

	(* Combine all options *)
	allOptions=Flatten[Join[
		{
			SampleInVolume->UnitConvert[resolvedSampleInVolumes,Milliliter],
			Sterile->resolvedSterile,
			SizeCutoff->resolvedSizeCutoffs,
			CrossFlowFilter->resolvedFilters,
			SampleReservoir->resolvedSampleReservoirs,

			(* Prime options*)
			FilterPrime->initialFilterPrime,
			FilterPrimeBuffer->resolvedFilterPrimeBuffer,
			FilterPrimeVolume->resolvedFilterPrimeVolume,
			FilterPrimeRinse->resolvedFilterPrimeRinse,
			FilterPrimeRinseBuffer->resolvedFilterPrimeRinseBuffer,
			FilterPrimeTransmembranePressureTarget->resolvedFilterPrimeTransmembranePressureTarget,
			FilterPrimeFlowRate->resolvedFilterPrimeFlowRate,

			(* Flush options *)
			FilterFlush->resolvedFilterFlush,
			FilterFlushBuffer->resolvedFilterFlushBuffer,
			FilterFlushVolume->resolvedFilterFlushVolume,
			FilterFlushRinse->resolvedFilterFlushRinse,
			FilterFlushTransmembranePressureTarget->resolvedFilterFlushTransmembranePressureTarget,
			FilterFlushFlowRate->resolvedFilterFlushFlowRate,

			(*other options*)
			FiltrationMode->resolvedFiltrationModes,
			SizeCutoff -> maxSizeCutoffs,
			DiafiltrationTarget->resolvedDiafiltrationTargets,
			PrimaryConcentrationTarget->resolvedPrimaryConcentrationTargets,
			SecondaryConcentrationTarget->resolvedSecondaryConcentrationTargets,
			TransmembranePressureTarget->If[NullQ[resolvedTransmembranePressureTargets],resolvedTransmembranePressureTargets,UnitConvert[resolvedTransmembranePressureTargets,PSI]],
			PermeateContainerOut->resolvedPermeateContainerOuts,
			PermeateAliquotVolume->N[roundedPermeateAliquotVolumes],
			PermeateStorageCondition->resolvedPermeateStorageConditions,
			PrimaryPumpFlowRate->If[NullQ[resolvedPrimaryPumpFlowRates],resolvedPrimaryPumpFlowRates,UnitConvert[resolvedPrimaryPumpFlowRates,Milliliter/Minute]],
			DiafiltrationBuffer->resolvedDiafiltrationBuffers,
			DiafiltrationMode->resolvedDiafiltrationModes,
			DiafiltrationExchangeCount->resolvedDiaFiltrationExchangeCounts,
			DeadVolumeRecoveryMode->resolvedDeadVolumeRecoveryModes,
			RetentateAliquotVolume->N[resolvedRetentateAliquotVolumes],
			RetentateContainerOut->resolvedRetentateContainersOut,
			RetentateStorageCondition->resolvedRetentateStorageConditions,
			Instrument->resolvedInstrument,
			FilterStorageCondition->resolvedFilterStorageConditions,
			TubingType->resolvedTubingType,
			Name->initialName,
			Template->Lookup[myOptions,Template],
			FastTrack->initialFastTrack,
			PreparatoryUnitOperations->Lookup[myOptions,PreparatoryUnitOperations],
			SampleLabel -> resolvedSampleLabels,
			SampleContainerLabel -> resolvedSampleContainerLabels,
			RetentateContainerOutLabel -> resolvedRetentateContainerOutLabels,
			PermeateContainerOutLabel -> resolvedPermeateContainerOutLabels,
			RetentateSampleOutLabel -> resolvedRetentateSampleOutLabels,
			PermeateSampleOutLabel -> resolvedPermeateSampleOutLabels
		},
		resolvedSamplePrepOptions,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions
	]];

	(* get the final resolved options, pre-collapsed (that is only happening outside this function) *)
	resolvedOptions=ReplaceRule[
		(* Recreate full set of options - necessary since we're using Append->False *)
		Join[Normal[roundedOptions],mySamplePrepOptions],
		allOptions,
		(* If one of our replacements isn't in our original set of options, this means it's experiment specific, so just drop it here by using Append->False *)
		Append->False
	];

	allTests=Cases[
		Flatten[
			{
				samplePrepTests,
				discardedTest,
				sampleMissingVolumeTest,
				volumeInformationValidTest,
				preparationTest,
				sampleMissingCompositionTest,
				precisionTests,
				validInstrumentTest,
				validSampleInVolumeTest,
				validTargetQTest,
				reservoirCompatibleTest,
				filterCompatibleTest,
				retentateVolumeValidTest,
				permeateVolumeValidTest,
				retentateVolumeSampleCompatibleTest,
				permeateVolumeSampleCompatibleTest,
				permeateVolumesScaleCompatibleTest,
				volumeOutputsValidTest,
				retentateVolumeAboveMinTest,
				diafiltrationBuffersValidTest,
				invalidSampleReservoirTest,
				invalidCrossFlowFilterTest,
				filterPrimeOptionsValidTest,
				filterFlushRinseValidTest,
				incompatibleSampleTest,
				conflictingFilterStorageConditionsTest,
				incompatibleDiafiltrationBufferTest,
				incompatibleFilterPrimeBufferTest,
				incompatibleFilterFlushBufferTest,
				duplicateNameTest,
				aliquotTests,
				optionsConflictingWithInstrumentTest,
				requiredOptionsWithInstrumentTest,
				invalidDiafiltrationModeTest,
				invalidNumSamplesTest,
				invalidDiaFiltrationExchangeCountTest,
				invalidFiltrationModeTests,
				invalidDiafiltrationTargetTests,
				invalidDeadVolumeRecoveryModeTests,
				compatibleFilterPrimeRinseBufferWarning,
				crossFlowSterileMisMatchWarnings,
				crossFlowNonOptimalSizeCutoffWarnings,
				sizeCutoffsMatchWarnings,
				crossFlowFilterSterileUnavailableWarnings,
				crossFlowDefaultFilterReturnedWarnings,
				crossFlowExceedCapacityWarnings,
				validTargetAmountsTest
			}
		],
		_EmeraldTest
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}

];

(* helper function to calculate permeate volumes *)
(* two targets *)
calculatePermeateTargetToVolume[targets:{_}|{_,_}, startingVolume_ ,sampleDensity_, diafiltrationDensity_]:=Module[{firstConcentration},
	(* calculate the volume after the first concentration *)
	firstConcentration = Experiment`Private`calculatePermeateTargetToVolume[First[targets], startingVolume,sampleDensity];
	(* make sure we're not out of targets *)
	If[Length[Rest[targets]]==0,
		{firstConcentration},
		{firstConcentration,Experiment`Private`calculatePermeateTargetToVolume[Last[targets], startingVolume-firstConcentration,diafiltrationDensity]}
	]
];

(* only one target *)
calculatePermeateTargetToVolume[target_, volume_,density_]:= Which[
	(* If defined as fold sample volume, multiply by sample volume *)
	MatchQ[target,UnitsP[1]],SafeRound[volume * (1 - 1/target),0.1Milliliter],

	(* If defined as volume, return as is *)
	MatchQ[target,UnitsP[1 Milliliter]],target,

	(* If defined as weight, divide by density *)
	MatchQ[target,UnitsP[1 Gram]],SafeRound[UnitConvert[target/density,Milliliter],0.1Milliliter],

	(* There are no other conditions but return a logical number as the default anyway *)
	True,0 Milliliter
];

calculateConcentrationTargets[volumes : {_, _}, startingVolume_] := Module[
	{primaryVolume, secondaryVolume, secondaryTarget, primaryTarget},
	{primaryVolume, secondaryVolume} = volumes;

	secondaryTarget = (startingVolume - primaryVolume)/(startingVolume - primaryVolume - secondaryVolume);
	secondaryTarget = (startingVolume - primaryVolume)/(startingVolume - primaryVolume - secondaryVolume);
	primaryTarget = startingVolume/(startingVolume - primaryVolume);
	{primaryTarget, secondaryTarget}
];

(* diafiltration Target to volume *)
calculateDiafiltrationVolume[sampleInVolume_, primaryConcentrationTarget_, diafiltrationTarget_, solventDensity_] := Which[
	(* If target is specified as fold sample volume, multiply target by sample volume *)
	MatchQ[diafiltrationTarget, UnitsP[1]] && MatchQ[primaryConcentrationTarget, UnitsP[1] | NullP],
		(sampleInVolume / primaryConcentrationTarget /. Null -> 1) * diafiltrationTarget,

	(* If we are doing ConcentrationDiafiltration... mode, we should calculate the exchange volume using the remaining sample volume (after PrimaryConcentrationTarget amount has been removed from sample) times DiafiltrationTarget *)
	MatchQ[diafiltrationTarget, UnitsP[1]] && MatchQ[primaryConcentrationTarget, UnitsP[1 Liter]],
		(sampleInVolume - primaryConcentrationTarget) * diafiltrationTarget,

	(* If target is specified as volume, return volume as is *)
	MatchQ[diafiltrationTarget, UnitsP[1 Liter]],
		diafiltrationTarget,

	(* If target is specified as weight, convert to volume *)
	MatchQ[diafiltrationTarget, UnitsP[1 Gram]],
		Floor[UnitConvert[diafiltrationTarget / solventDensity, Milliliter]],

	(* in case its null *)
	True,
		0Liter
];

calculateDiafiltrationTargetReal[sampleInVolume_, diafiltrationVolume_, primaryConcentrationTarget_]:=(diafiltrationVolume/sampleInVolume)*primaryConcentrationTarget;


(* ::Subsection:: *)
(* Resource Packet Helper *)


DefineOptions[crossFlowResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

(* we need a better way to calculate the max time. until then, we cant checkf for it in a reasonable way..  *)
(*Error::CrossFlowExceedsMaxExperimentTime="The experiment cannot be performed within maximum allowed time for experiments. Please specify a shorter experiment.";*)


crossFlowResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{__Rule},myOptions:OptionsPattern[crossFlowResourcePackets]]:=Module[
	{
		outputSpecification,output,gatherTests,messages,cache,fastCacheBall,diafiltrationList,concentrationList,
		washContainers,wasteContainerModels,fittingModels,tubingModels,cuttingJigModels, resolvedInstrument,
		sampleReservoirRackModels,downloadedPackets,washContainerPackets,wasteContainerPackets,
		fittingPackets,tubingPackets,diafiltrationBufferPackets,sampleReservoirRackPackets,cuttingJigPackets,
		newCache,filterPacket,instrumentModelPacket,simulatedSamplePackets,containerInObject,samplesInResources,
		instrumentResource,protocolPacket, containersInResource, pairedSamplesInAndVolumes,resolvedOptionsNoHidden,
		sampleVolumeRules,sampleResourceReplaceRules, instrumentModel, uPulseQ, sharedFieldPacket, finalizedPacket,
		allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, resultRule, testsRule, expandedInputs,
		expandedResolvedOptions, simulation, checkpoints, sampleInRequestedVolumes
	},


	(* Determine the requested output format *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Get the inherited cache *)
	cache=Lookup[ToList[myOptions],Cache,{}];
	simulation=Lookup[ToList[myOptions],Simulation,Null];
	fastCacheBall = makeFastAssocFromCache[cache];

	(* expand the resolved options if they weren't expanded already *)
	{{expandedInputs}, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentCrossFlowFiltration, {mySamples}, myResolvedOptions];

	(* ----- Search and Download ----- *)

	(* Build two boolean to indicate if we have concentration and/or diafiltration *)
	diafiltrationList = MatchQ[#, Alternatives[ConcentrationDiafiltrationConcentration,ConcentrationDiafiltration,Diafiltration]]&/@Lookup[expandedResolvedOptions,FiltrationMode];
	concentrationList = MatchQ[#, Alternatives[ConcentrationDiafiltrationConcentration,ConcentrationDiafiltration,Concentration]]&/@Lookup[expandedResolvedOptions,FiltrationMode];

	(* Big search *)
	{
		washContainers,
		wasteContainerModels,
		fittingModels,
		tubingModels,
		cuttingJigModels,
		sampleReservoirRackModels
	}= Search[
		{
			Model[Container,Vessel,CrossFlowWashContainer],
			Model[Container,Vessel],
			Model[Plumbing,Fitting],
			Model[Plumbing,PrecutTubing],
			Model[Part,CuttingJig],
			Model[Container,Rack]
		},
		{
			Deprecated!=True,
			Or[(Name==(___~~"L Glass Bottle")&&MaxVolume>50 Milliliter),Name==(___~~"Carboy")&&CleaningMethod===DishwashPlastic&&MaxVolume==10 Liter],
			Name==(___~~"Cross Flow"~~___),
			StringContainsQ[Name,"PharmaPure #"],
			Deprecated!=True,
			StringContainsQ[Name,"CrossFlowContainer"]
		},
		SubTypes->{
			True,
			False,
			True,
			True,
			True,
			True
		}

	];

	(* Find the instrument object so we can pull the conductivity sensors *)
	resolvedInstrument = Lookup[expandedResolvedOptions, Instrument];

	(* Download the packets *)
	downloadedPackets=Quiet[
		Download[
			{
				(*1*)washContainers,
				(*2*)wasteContainerModels,
				(*3*)fittingModels,
				(*4*)tubingModels,
				(*5*)ToList[Lookup[expandedResolvedOptions,DiafiltrationBuffer]],
				(*6*)sampleReservoirRackModels,
				(*7*)cuttingJigModels
			},
			{
				(*1*){Packet[Name,MaxVolume,Connectors,SelfStanding]},
				(*2*){Packet[Name,MaxVolume]},
				(*3*){Packet[Name,Connectors,ImageFile]},
				(*4*){Packet[Name,InnerDiameter,Connectors,ParentTubing,Size]},
				(*5*){Packet[Name,Solvent,Composition,Density,Model]},
				(*6*){Packet[Positions,Dimensions]},
				(*7*){Packet[Name,TubingCutters]}
			},
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Separate the downloaded packets *)
	washContainerPackets=Flatten[First[downloadedPackets]];
	wasteContainerPackets=Flatten[downloadedPackets[[2]]];
	fittingPackets=Flatten[downloadedPackets[[3]]];
	tubingPackets=Flatten[downloadedPackets[[4]]];
	diafiltrationBufferPackets=Flatten[downloadedPackets[[5]]];
	sampleReservoirRackPackets=Flatten[downloadedPackets[[6]]];
	cuttingJigPackets=Flatten[downloadedPackets[[7]]];


	(* Combine caches *)
	newCache=FlattenCachePackets[{cache,downloadedPackets}];

	(* Prepare a filter packet for lookups *)
	filterPacket=fetchPacketFromCache[#,newCache]&/@Lookup[expandedResolvedOptions,CrossFlowFilter];

	(* Get the model of resolved instrument*)
	instrumentModel = If[MatchQ[resolvedInstrument, ObjectP[Model[Instrument]]],
		(* If the resolved option is a Model use that. *)
		resolvedInstrument,
		(* Otherwise its an Object, get its packet and look up the Model from the packet. *)
		Download[fastAssocLookup[fastCacheBall, resolvedInstrument, Model], Object]
	];

	(* Prepare an instrument model packet for lookups*)
	instrumentModelPacket=fetchPacketFromFastAssoc[instrumentModel,fastCacheBall];

	(* build a boolean to indicate which instrument we are using *)
	uPulseQ = MatchQ[instrumentModel, ObjectReferenceP[Model[Instrument, CrossFlowFiltration, "id:vXl9j5lJXvnJ"]]];

	(* ---------- Generate Resources ---------- *)

	(* Prepare a packet for the sample *)
	simulatedSamplePackets=fetchPacketFromCache[#,newCache]&/@expandedInputs;

	(* ----- Make the sample resource ----- *)

	(* Fetch the sample container from the cache *)
	containerInObject=Download[Lookup[simulatedSamplePackets,Container],Object];

	(* Prepare the resource *)

	(* make rules correlating the volumes with each sample in *)
	(* Firstly we need to determine which volume will will use: if specifiec aliquot we should use AliquotAmount, else use SampleInVolume *)
	sampleInRequestedVolumes= MapThread[
		If[MatchQ[#1, VolumeP],#1,#2]&,
		{
			Lookup[expandedResolvedOptions,AliquotAmount],
			Lookup[expandedResolvedOptions,SampleInVolume]
		}
	];

	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {expandedInputs, sampleInRequestedVolumes}];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, If[NullQ[#], Null, Total[DeleteCases[#, Null]]]&];

	(* make replace rules for the samples and its resources *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[NullQ[volume],
				sample -> Resource[Sample -> sample, Name -> CreateUUID[]],
				sample -> Resource[Sample -> sample, Name -> CreateUUID[], Amount -> volume]
			]
		],
		sampleVolumeRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[expandedInputs, sampleResourceReplaceRules, {1}];

	containersInResource = (Resource[Sample->#]&/@DeleteDuplicates[containerInObject]);

	(*
	(* Check if the experimental can be completed within MaxExperimentTime *)

	(* we need a better way to calculate the max time. until then, we cant check for it in a reasonable way..  *)

	(* If gathering tests, create a passing or failing test *)
	experimentTimeValidTest=Which[
		!gatherTests,Nothing,
		gatherTests&&experimentTimeValid,Test["Experiment can be performed within maximum allowed time for experiments:",True,True],
		gatherTests&&!experimentTimeValid,Test["Experiment can be performed within maximum allowed time for experiments:",True,False]
	];
	*)


	protocolPacket= If[
		uPulseQ,
		Module[
			{
				diafiltrationTargets,filtrationModes, primaryConcentrationTargets, secondaryConcentrationTargets,sampleInVolumes, diafiltrationVolumes,
				diafiltrationBufferResources, filterPrimeVolume,filterPrimeBufferResources, filterPrimeRinseResources, filterFlushBufferResources,filterFlushRinseResources,
				filterResources, permeateContainerResources,retentateContainerResources,
				wasteContainerResource, permeateAliquotVolumes, sampleReservoirs, crossFlowFilters, permeateContainersOut, retentateContainersOut,
				diafiltrationBuffers, filterPrimeBuffer, filterPrimeRinse, filterFlushVolume, filterFlushBuffer, filterFlushRinse, filterPrime,
				filterFlush, steriles, filterVolumeAssoc, numUniqueFilters, instrumentSetupTearDownTime, instrumentFilterRate, primeFlushFilterVolume,
				experimentRunTime, filterIndices, filterUniqueID, filterPrimeRinseBuffer,
				sampleReservoirRackResource, temporaryPermeateContainersOutResources, currFilterIndex, diafiltrationContainerRackResource,
				liquidComponentLists, solvents, solventDensities, diafiltrationBufferSolvents, diafiltrationBufferDensities,
				primaryConcentrationVolumes, secondaryConcentrationVolumes, calculatedPrimaryTargets, calculatedSecondaryTargets, sanitizedPrimaryTargets,
				sanitizedSecondaryTargets, sanitizedDiafiltrationTargets,
				tubeBlockResource,
				filterPrimeDiafiltrationBufferResources, filterPrimeRinseDiafiltrationBufferResources, filterFlushDiafiltrationBufferResources,
				filterFlushRinseDiafiltrationBufferResources, sampleRunTimes, filterPrimeTime, filterFlushTime,
				primaryConcentrationWeights, secondaryConcentrationWeights, diafiltrationWeights
			},

			(* ----- Generate the DiafiltrationBuffer resource ----- *)
			(* Fetch the variables we need for diafiltration buffer calculations *)
			{
				(*1*)diafiltrationTargets,
				(*2*)filtrationModes,
				(*3*)primaryConcentrationTargets,
				(*4*)secondaryConcentrationTargets,
				(*5*)sampleInVolumes,
				(*6*)permeateAliquotVolumes,
				(*7*)sampleReservoirs,
				(*8*)crossFlowFilters,
				(*9*)permeateContainersOut,
				(*10*)retentateContainersOut,
				(*11*)diafiltrationBuffers,
				(*12*)steriles,
				(*13*)filterPrime,
				(*14*)filterPrimeVolume,
				(*15*)filterPrimeBuffer,
				(*16*)filterPrimeRinse,
				(*17*)filterFlush,
				(*18*)filterFlushVolume,
				(*19*)filterFlushBuffer,
				(*20*)filterFlushRinse,
				(*21*)filterPrimeRinseBuffer
			}=Lookup[
				expandedResolvedOptions,
				{
					(*1*)DiafiltrationTarget,
					(*2*)FiltrationMode,
					(*3*)PrimaryConcentrationTarget,
					(*4*)SecondaryConcentrationTarget,
					(*5*)SampleInVolume,
					(*6*)PermeateAliquotVolume,
					(*7*)SampleReservoir,
					(*8*)CrossFlowFilter,
					(*9*)PermeateContainerOut,
					(*10*)RetentateContainerOut,
					(*11*)DiafiltrationBuffer,
					(*12*)Sterile,
					(*13*)FilterPrime,
					(*14*)FilterPrimeVolume,
					(*15*)FilterPrimeBuffer,
					(*16*)FilterPrimeRinse,
					(*17*)FilterFlush,
					(*18*)FilterFlushVolume,
					(*19*)FilterFlushBuffer,
					(*20*)FilterFlushRinse,
					(*21*)FilterPrimeRinseBuffer
				}
			];


			(* If Solvent field for sample is informed, use it; otherwise, determine the solvents *)
			{
				solvents,
				liquidComponentLists
			}=Transpose[If[
				!MatchQ[Lookup[#,Solvent,Null],Null|{}],
				Module[{liquidComponents},

					(* Find the liquid components, which are the solvents -- this is used below for density calculations, so we need to set this variable here *)
					liquidComponents={{100VolumePercent, Download[Lookup[#,Solvent],Object]}};

					(* Return the molecules as our solvent *)
					{Download[ToList[Lookup[#, Solvent]], Object],liquidComponents}
				],
				Module[{componentsAmount,solventPositions,liquidComponents},

					(* Get all components and their amounts*)
					componentsAmount={First[#],Download[#[[2]],Object]}&/@Lookup[#,Composition,{}];

					(* Find the liquid components *)
					liquidComponents=Select[componentsAmount,MatchQ[First[#],Alternatives[UnitsP[IndependentUnit["VolumePercent"]],UnitsP[1 VolumePercent]]]&];

					(* Find the positions of the solvents *)
					solventPositions=If[

						(* If we have liquid components, find their positions *)
						MatchQ[liquidComponents,Except[{}]],
						Flatten[Position[componentsAmount,#]&/@liquidComponents],

						(* Otherwise, we don't have a solvent *)
						Null
					];

					(* If we found a solvent, return it *)
					{
						If[
							MatchQ[solventPositions, Except[Null]],
							Last /@ Part[componentsAmount, solventPositions],
							Null
						],
						liquidComponents
					}
				]
			]&/@simulatedSamplePackets];


			(* Find the density of the solvent *)
			solventDensities=MapThread[
				Function[
					{
						solvent,
						samplePacket,
						liquidComponents
					},
					Which[

						(* If sample has density, use it *)
						!NullQ[Lookup[samplePacket,Density]],
						Lookup[samplePacket,Density],

						(* If we found a solvent, use that *)
						!NullQ[solvent],
						Module[{solventPackets,solventDensity},

							(* Fetch the packets for the solvent molecules *)
							solventPackets=fetchPacketFromCache[#,newCache]&/@solvent;

							(* Lookup the densities for the solvent molecules *)
							solventDensity=Lookup[solventPackets,Density,Null];

							(* Calculate the density *)
							If[

								(* If we have all the densities, weigh it by the volume amount -- This method is not a great way of calculating the density for multiple solvents but unfortunately,without knowing the density of the actual solvent,we don't have a lot of options here *)
								!MemberQ[solventDensity,Null],
								Total[MapThread[
									#1/100*#2&,
									{Unitless[First/@liquidComponents],solventDensity}
								]],

								(* Otherwise *)
								Module[{redownloadedDensity},

									(* Check if the density is really missing in the database -- we are adding this here because assumed density pops up in ~1% of tests randomly even though the density is in the database. It's too rare and sporadic to figure out what is going on, but as far as I can tell, it has to do with the fact that every once in a while, something goes wrong with grabbing the data. So we are going to double check with the database in cases where we can't find the density to eliminate those sporadic cases *)
									redownloadedDensity=Download[solvent,Density];

									(* Return assumed/redownloaded value *)
									Total[MapThread[
										#1/100*#2&,
										{Unitless[First/@liquidComponents],redownloadedDensity/.Null->1 Gram/Milliliter}
									]]
								]
							]
						],

						(* Otherwise, we couldn't find a solvent so return 1 g/mL *)
						True,
						1 Gram/Milliliter
					]
				],
				{
					solvents,
					simulatedSamplePackets,
					liquidComponentLists
				}

			];

			(* Find the diafiltration buffer solvent *)
			diafiltrationBufferSolvents=Function[
				bufferPacket,
				If[

					(* If there is no buffer, skip *)
					NullQ[bufferPacket],
					Null,

					(* Otherwise, find the solvent *)
					Module[{componentsAmount,liquidComponents,solventPositions},

						(* Get all components and their amounts*)
						componentsAmount={First[#],Download[#[[2]],Object]}&/@Lookup[bufferPacket,Composition,{}];

						(* Find the liquid components *)
						liquidComponents=Select[componentsAmount,MatchQ[First[#],Alternatives[UnitsP[IndependentUnit["VolumePercent"]],UnitsP[1 VolumePercent]]]&];

						(* Find the positions of the solvents *)
						solventPositions=If[

							(* If we have liquid components, find their positions *)
							MatchQ[liquidComponents,Except[{}]],
							Flatten[Position[componentsAmount,#]&/@liquidComponents],

							(* Otherwise, we don't have a solvent *)
							Null
						];

						(* Return the solvent and the liquid components *)
						Which[

							(* If solvent field for sample is informed, use it *)
							!MatchQ[Lookup[bufferPacket,Solvent,Null],Null|{}],{ToList[Download[Lookup[bufferPacket,Solvent],Object]],liquidComponents},

							(* Otherwise, determine based on manual resolution *)
							MatchQ[solventPositions,Except[Null]],{Last/@Part[liquidComponents,solventPositions],liquidComponents},

							(* Default condition for when we can't find the solvent *)
							True,Null
						]
					]
				]
			]/@diafiltrationBufferPackets;

			(* Find the density of the diafiltration buffer *)
			diafiltrationBufferDensities=MapThread[
				Function[
					{bufferPacket,solventAndLiquidComponents},
					Which[

						(* If no diafiltration buffer, carry on *)
						NullQ[bufferPacket],Null,

						(* If buffer has density, use it *)
						!NullQ[Lookup[bufferPacket,Density]],Lookup[bufferPacket,Density],

						(* If we found a solvent, use that *)
						!NullQ[solventAndLiquidComponents],Module[{solventPackets,solventDensities,densityReallyMissing},

						(* Fetch the packets for the solvent molecules *)
						solventPackets=fetchPacketFromCache[#,newCache]&/@First[solventAndLiquidComponents];

						(* Lookup the densities for the solvent molecules *)
						solventDensities=Lookup[solventPackets,Density,Null];

						(* Calculate the density *)
						If[

							(* If we have all the densities, weight it by the volume amount -- This method is not a great way of calculating the density for multiple solvents but unfortunately,without knowing the density of the actual solvent,we don't have a lot of options here *)
							!MemberQ[solventDensities,Null],
							Total[MapThread[
								#1/100*#2&,
								{Unitless[First/@Last[solventAndLiquidComponents]],solventDensities}
							]],

							(* Otherwise *)
							Module[{redownloadedDensity},

								(* Check if the density is really missing in the database -- we are adding this here because assumed density pops up in ~1% of tests randomly even though the density is in the database. It's too rare and sporadic to figure out what is going on, but as far as I can tell, it has to do with the fact that every once in a while, something goes wrong with grabbing the data. So we are going to double check with the database in cases where we can't find the density to eliminate those sporadic cases *)
								redownloadedDensity=Download[First[solventAndLiquidComponents],Density];
								densityReallyMissing=MemberQ[redownloadedDensity,Null];

								(* Return assumed/redownloaded value *)
								If[
									densityReallyMissing,
									1 Gram/Milliliter,
									Total[MapThread[
										#1/100*#2&,
										{Unitless[First/@Last[solventAndLiquidComponents]],redownloadedDensity}
									]]
								]
							]
						]
					],

						(* Otherwise, we couldn't find a solvent so return 1 g/mL *)
						True,1 Gram/Milliliter
					]
				],
				{diafiltrationBufferPackets,diafiltrationBufferSolvents}
			];

			(* Calculate the permeate volume from targets *)
			diafiltrationVolumes=MapThread[
				Function[
					{
						diafiltrationTarget,
						sampleInVolume,
						primaryConcentrationTarget,
						diafiltrationQ,
						solventDensity
					},
					If[
						diafiltrationQ,
						calculateDiafiltrationVolume[sampleInVolume, primaryConcentrationTarget, diafiltrationTarget, solventDensity],
						0Milliliter
					]
				],
				{
					diafiltrationTargets,
					sampleInVolumes,
					primaryConcentrationTargets,
					diafiltrationList,
					solventDensities
				}
			];

			(* Calculate the permeate volume from concentration targets *)
			{primaryConcentrationVolumes, secondaryConcentrationVolumes}=Transpose[
				MapThread[
					Function[
						{
							sampleInVolume,
							primaryConcentrationTarget,
							secondaryConcentrationTarget,
							concentrationQ,
							solventDensity,
							diafiltrationBufferDensity
						},
						If[
							concentrationQ,
							Experiment`Private`calculatePermeateTargetToVolume[{primaryConcentrationTarget, secondaryConcentrationTarget},sampleInVolume,solventDensity,If[DensityQ[diafiltrationBufferDensity],diafiltrationBufferDensity,1Gram/Milliliter]],
							{0Milliliter, 0Milliliter}
						]
					],
					{
						sampleInVolumes,
						primaryConcentrationTargets,
						secondaryConcentrationTargets,
						concentrationList,
						solventDensities,
						diafiltrationBufferDensities
					}
				]
			];

			(* Since the uPulse use the mass to control the diafiltraiton and concentration process, we need to calculate the mass and store these information in the protocol *)
			{
				primaryConcentrationWeights,
				secondaryConcentrationWeights,
				diafiltrationWeights
			}=Transpose[
				MapThread[
					Function[
						{
							primaryConcentrationVolume,
							secondaryConcentrationVolume,
							diafiltrationVolume,
							solventDensity,
							diafiltrationBufferDensity
						},
						With[{sanitizedDiafiltrationDensity = If[NullQ[diafiltrationBufferDensity], solventDensity, diafiltrationBufferDensity]},
							{
								primaryConcentrationVolume * solventDensity,
								secondaryConcentrationVolume * sanitizedDiafiltrationDensity,
								diafiltrationVolume * sanitizedDiafiltrationDensity
							}

						]
					],
					{
						primaryConcentrationVolumes,
						secondaryConcentrationVolumes,
						diafiltrationVolumes,
						solventDensities,
						diafiltrationBufferDensities
					}
				]
			];

			(* Do some sanitizations for diafiltration targets and volumes *)
			{
				calculatedPrimaryTargets,
				calculatedSecondaryTargets
			}=Transpose[
				MapThread[
					Function[
						{
							primaryConcentrationVolume,
							secondaryConcentrationVolume,
							sampleInVolume
						},
						calculateConcentrationTargets[{primaryConcentrationVolume,secondaryConcentrationVolume}, sampleInVolume]
					],
					{
						primaryConcentrationVolumes,
						secondaryConcentrationVolumes,
						sampleInVolumes
					}
				]
			];

			(* We need to sanitize the target since the protocol objects only takes number of the input *)
			sanitizedPrimaryTargets= MapThread[
				Function[
					{
						primaryConcentrationTarget,
						calculatedPrimaryTarget
					},
					If[
						MatchQ[primaryConcentrationTarget, UnitsP[1]],
						primaryConcentrationTarget,
						Max[calculatedPrimaryTarget,1.01]
					]
				],
				{
					primaryConcentrationTargets,
					calculatedPrimaryTargets
				}
			];

			(* We need to sanitize the target since the protocol objects only takes number of the input *)
			sanitizedSecondaryTargets= MapThread[
				Function[
					{
						secondaryConcentrationTarget,
						calculatedSecondaryTarget
					},
					If[
						MatchQ[secondaryConcentrationTarget, UnitsP[1]],
						secondaryConcentrationTarget,
						Max[calculatedSecondaryTarget,1.01]
					]
				],
				{
					secondaryConcentrationTargets,
					calculatedSecondaryTargets
				}
			];


			(* Sanitized primary target *)
			sanitizedDiafiltrationTargets = MapThread[
				Function[
					{
						sampleInVolume,
						diafiltrationVolume,
						sanitizedPrimaryTarget,
						diafiltrationTarget,
						diafiltrationQ
					},
					Which[
						diafiltrationQ && MatchQ[diafiltrationTarget,UnitsP[1]],diafiltrationTarget,
						diafiltrationQ, calculateDiafiltrationTargetReal[sampleInVolume, diafiltrationVolume, sanitizedPrimaryTarget],
						True, Null
					]
				],
				{
					sampleInVolumes,
					diafiltrationVolumes,
					sanitizedPrimaryTargets,
					diafiltrationTargets,
					diafiltrationList
				}
			];

			(* Make the diafiltration buffer resources *)
			diafiltrationBufferResources =MapThread[
				Function[
					{
						diafiltrationBuffer,
						diafiltrationVolume,
						diafiltrationQ
					},
					If[
						diafiltrationQ,
						Module[
							{
								volumeWithDead, bufferContainer
							},

							(* all diafiltration will need 3 milliliter as the dead volume, requested by uPulse itself *)
							volumeWithDead = diafiltrationVolume + 3 Milliliter;

							(* Preferred container of this buffer *)
							bufferContainer = Model[Container, Vessel, "50mL Tube"];

							Link[
								Resource[
									Sample -> diafiltrationBuffer,
									Amount -> (volumeWithDead),
									Container -> bufferContainer,
									Name -> ToString[CreateUUID[]],
									RentContainer -> True
								]
							]

						],
						Null
					]
				],
				{
					diafiltrationBuffers,
					diafiltrationVolumes,
					diafiltrationList
				}
			];
			(* Now we need to find how many filters we gonna use *)
			(* we will iterate through the filters and the volumes, store current volume that will be filtered by this filter in filterVolumeAssoc *)
			(* filterVolumeAssoc is like <|<filter> -> {volume..}|> , aka we use a list to store all volumes to be filtered by this model *)
			(* init the dict to store the info *)
			filterVolumeAssoc=<||>;
			currFilterIndex = 0;

			(* Iterate through the two values, return a list of index about *)
			filterIndices=MapThread[
				Function[
					{filter, volume},
					If[
						(* If this is an filter we have used *)
						KeyExistsQ[filterVolumeAssoc, filter],
						If[
							(* If user specified an Object, we will use it no matter how many volume we will filter *)
							MatchQ[filter, ObjectReferenceP[Object[Item, Filter, MicrofluidicChip]]],

							(* Update the dict directly *)
							With[{currentVolume = LastOrDefault[filterVolumeAssoc[filter], 0 Milliliter]},

								filterVolumeAssoc[filter] = {currentVolume + volume};
							],

							(* Else if resolved the filter is a model, check if we have specified more than this filter can filter *)
							(* if not, use the same filter, else, assign a new filters *)
							Module[
								{currentVolume, maxVolumeOfUses, currentVolumeList,updatedVolumeList},

								currentVolume = LastOrDefault[filterVolumeAssoc[filter], 0 Milliliter];
								maxVolumeOfUses = fastAssocLookup[fastCacheBall, filter, MaxVolumeOfUses];
								currentVolumeList = filterVolumeAssoc[filter];

								(* If current model can still filter more, use this filter *)
								updatedVolumeList=If[
									((currentVolume + volume) <= maxVolumeOfUses),
									Append[Most[currentVolumeList],(currentVolume + volume)],

									(* Else update the current number of filters and assign a new filters to the assoc, and add this filter to the list *)
									currFilterIndex += 1; Append[currentVolumeList, volume]
								];

								filterVolumeAssoc[filter]= updatedVolumeList;
							]
						],

						(* If this is an filter we have never used, aka not existed in the dict *)
						currFilterIndex = 1;filterVolumeAssoc[filter] = {volume};
					];

					currFilterIndex
				],
				{Download[crossFlowFilters,Object],sampleInVolumes}
			];


			(* Create an unique randoms ID for filter resources *)
			filterUniqueID= ToString[CreateUUID[]];

			(* Generate resources *)
			filterResources = MapThread[
				Function[
					{
						filter,
						index
					},
					With[
						{
							id=Download[filter,ID],
							volumeList= Lookup[filterVolumeAssoc, Download[filter,Object]]
						},
						If[
							MatchQ[filter,ObjectReferenceP[Model[Item]]],
							Resource[Sample->filter,Name->"Filter Resource_"<>filterUniqueID<>"_filter_"<>id<>"_"<>ToString[volumeList[[index]]],VolumeOfUses->volumeList[[index]]],
							Resource[Sample->filter,Name->"Filter Resource_"<>filterUniqueID<>"_filter_"<>id<>"_"<>ToString[volumeList[[index]]]]
						]
					]
				],
				{
					crossFlowFilters,
					filterIndices
				}
			];

			(* Calculate the number of filters *)
			numUniqueFilters = Length[DeleteDuplicates[filterResources]];

			(* Define a time to setup and teardown the instrument *)
			instrumentSetupTearDownTime = 15 Minute;

			(* Define the filter rate of the instrument *)
			instrumentFilterRate = $uPulseFilterRate;

			(* Define the prime/flush filter throughput volume *)
			primeFlushFilterVolume = 20 Milliliter;

			(* Now calculate experiment time, including filter change times and additional prime and flush time *)
			sampleRunTimes = (diafiltrationVolumes + primaryConcentrationVolumes + secondaryConcentrationVolumes )/instrumentFilterRate+(instrumentSetupTearDownTime * Length[primaryConcentrationVolumes]);

			(* Calculate filter prime time *)
			filterPrimeTime = Which[
				filterPrime&&filterPrimeRinse, (primeFlushFilterVolume/instrumentFilterRate)*2 + (instrumentSetupTearDownTime * 2),
				filterPrime,(primeFlushFilterVolume/instrumentFilterRate) + instrumentSetupTearDownTime,
				True, 0 Minute
			] * numUniqueFilters;

			(* Get number of washes *)
			filterFlushTime = Which[
				filterFlush&&filterFlushRinse, (primeFlushFilterVolume/instrumentFilterRate)*2 + (instrumentSetupTearDownTime * 2),
				filterFlush,(primeFlushFilterVolume/instrumentFilterRate) + instrumentSetupTearDownTime,
				True, 0 Minute
			] * numUniqueFilters;

			experimentRunTime = Total[sampleRunTimes + filterPrimeTime + filterFlushTime] ;

			(* ----- Generate the FilterPrimeBuffer resource ----- *)
			(* For each of filter we will prime it once *)

			(* If Operation Filter Prime is a go, make a resource *)
			{filterPrimeBufferResources,filterPrimeDiafiltrationBufferResources}=If[
				filterPrime,
				Transpose[
					Table[
						{
							Resource[
								Sample -> filterPrimeBuffer,
								Amount -> Min[filterPrimeVolume, 40Milliliter],
								Container -> Model[Container, Vessel, "50mL Tube"],
								Name -> ToString[CreateUUID[]],
								RentContainer -> True
							],
							(* NOTE: the FilterPrimeDiafiltrationBufferResource needs to be 5mL greater than the FilterPrimeBuffer resource *)
							(* Otherwise, the instrument will try and have the buffer refilled, which is currently not *)
							(* supported in the procedure *)
							Resource[
								Sample->filterPrimeBuffer,
								Amount->Min[filterPrimeVolume + 5Milliliter, 45 Milliliter],
								Container->Model[Container, Vessel, "50mL Tube"],
								Name->ToString[CreateUUID[]],
								RentContainer->True
							]
						},
						numUniqueFilters
					]
				],
				{Null, Null}
			];

			(* ----- Generate the FilterPrimeRinse resource ----- *)
			{filterPrimeRinseResources, filterPrimeRinseDiafiltrationBufferResources}=If[
				filterPrimeRinse,
				Transpose[
					Table[
						{
							Resource[
								Sample->filterPrimeRinseBuffer,
								Amount->Min[filterPrimeVolume, 40Milliliter],
								Container->Model[Container, Vessel, "50mL Tube"],
								Name->ToString[CreateUUID[]],
								RentContainer->True
							],
							(* NOTE: the FilterPrimeRinseDiafiltrationBuffer resource needs to be 5mL greater than the FilterPrimeRinseBuffer resource *)
							(* Otherwise, the instrument will try and have the buffer refilled, which is currently not *)
							(* supported in the procedure *)
							Resource[
								Sample->filterPrimeRinseBuffer,
								Amount->Min[filterPrimeVolume + 5Milliliter, 45 Milliliter],
								Container->Model[Container, Vessel, "50mL Tube"],
								Name->ToString[CreateUUID[]],
								RentContainer->True
							]
						},
						numUniqueFilters
					]
				],
				{Null, Null}
			];

			(* ----- Generate the FilterFlushBuffer resource ----- *)
			(* Generate the resource *)

			{filterFlushBufferResources, filterFlushDiafiltrationBufferResources}=If[
				filterFlush,
				Transpose[
					Table[
						{
							Resource[
								Sample->filterFlushBuffer,
								Amount->Min[filterFlushVolume, 40 Milliliter],
								Container->Model[Container, Vessel, "50mL Tube"],
								Name->ToString[CreateUUID[]],
								RentContainer->True
							],
							(* NOTE: the FilterFlushDiafiltrationBuffer resource needs to be 5mL greater than the FilterFlushBuffer resource *)
							(* Otherwise, the instrument will try and have the buffer refilled, which is currently not *)
							(* supported in the procedure *)
							Resource[
								Sample->filterFlushBuffer,
								Amount->Min[filterFlushVolume+5Milliliter, 45 Milliliter],
								Container->Model[Container, Vessel, "50mL Tube"],
								Name->ToString[CreateUUID[]],
								RentContainer->True
							]
						},
						numUniqueFilters
					]
				],
				{Null, Null}
			];

			(* ----- Generate the FilterFlushRinse resource ----- *)
			{filterFlushRinseResources, filterFlushRinseDiafiltrationBufferResources}=If[
				filterFlushRinse,
				Transpose[
					Table[
						{
							Resource[
								Sample->Model[Sample,"Milli-Q water"],
								Amount->Min[filterFlushVolume, 40 Milliliter],
								Container->Model[Container, Vessel, "50mL Tube"],
								Name->ToString[CreateUUID[]],
								RentContainer->True
							],
							(* NOTE: the FilterFlushDiafiltrationBuffer resource needs to be 5mL greater than the FilterFlushBuffer resource *)
							(* Otherwise, the instrument will try and have the buffer refilled, which is currently not *)
							(* supported in the procedure *)
							Resource[
								Sample->Model[Sample,"Milli-Q water"],
								Amount->Min[filterFlushVolume+5Milliliter, 45 Milliliter],
								Container->Model[Container, Vessel, "50mL Tube"],
								Name->ToString[CreateUUID[]],
								RentContainer->True
							]
						},
						numUniqueFilters
					]
				],
				{Null, Null}
			];
			(* For racks we need two 50 mL tube racks to hold racks on the balance *)
			(* These will populate two fields SampleReservoirRack and DiafiltrationContainerRack *)
			sampleReservoirRackResource = Resource[Sample->Model[Container, Rack, "Balance Tubing Racks for uPulse TFF instrumnent"],Name->ToString[CreateUUID[]]];
			diafiltrationContainerRackResource = Resource[Sample->Model[Container, Rack, "Balance Tubing Racks for uPulse TFF instrumnent"],Name->ToString[CreateUUID[]]];

			(* ---------- Generate Other Resources ---------- *)
			permeateContainerResources= Map[
					If[
						NullQ[#],
						Null,
						Resource[Sample->#, Name->ToString[Unique[]]]
					]&,
				permeateContainersOut
			];

			retentateContainerResources= Map[
				If[
					NullQ[#],
					Null,
					Resource[Sample->#, Name->ToString[Unique[]]]
				]&,
				retentateContainersOut
			];

			(* Generate TemporaryPermeateContainersOut *)
			temporaryPermeateContainersOutResources=Table[
				Resource[Sample->Model[Container, Vessel, "125mL medium square bottom clear solid plastic nalgene bottle"], Name->ToString[Unique[]], Rent->True],
				Length[permeateContainersOut]
			];
			(* ----- Generate WasteContainer resource ----- *)
			(* Create the resource *)
			wasteContainerResource=If[
				Or[filterPrime,filterPrimeRinse,filterFlush,filterFlushRinse],
				Resource[Sample->Model[Container, Vessel, "125mL medium square bottom clear solid plastic nalgene bottle"], Name->ToString[Unique[]], Rent->True],
				Null
			];

			(* ----- Generate Instrument resource ----- *)
			(* Create the instrument resource -- 150 minutes is the time it takes for all other steps *)
			instrumentResource=Resource[Instrument->Lookup[expandedResolvedOptions,Instrument],Time->experimentRunTime];

			(* Get the tube block resources for the experiment *)
			tubeBlockResource = Resource[Sample -> Model[Part, TubeBlock, "uPulse Tube Block"],Name->ToString[CreateUUID[]]];

			(* ---------- Prepare the Packets ---------- *)

			(* Collapse options and remove hidden ones *)
			resolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentCrossFlowFiltration,expandedResolvedOptions];

			checkpoints= If[uPulseQ,
				{
					{"Preparing Samples",20 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->20 Minute]]},
					{"Filtration",experimentRunTime,"Cleaning filters and filtering samples.",Link[Resource[Operator->$BaselineOperator,Time->experimentRunTime]]},
					{"Storing Samples",20 Minute,"Storing all samples and items",Link[Resource[Operator->$BaselineOperator,Time->20 Minute]]}
				},
				{
					{"Preparing Samples", 10 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]},
					{"Instrument Setup", 2 Day, "Plumbing and sample are connected instrument and software setup is performed.",Link[Resource[Operator->$BaselineOperator,Time->120 Minute]]},
					{"Filtration", experimentRunTime, "Sample is filtered.",Link[Resource[Operator->$BaselineOperator,Time->experimentRunTime]]},
					{"Instrument CleanUp", 5 Hour, "Sample is removed from the instrument and instrument is returned to a ready state for the next user.",Link[Resource[Operator->$BaselineOperator,Time->120 Minute]]}
				}
			];

			(* ----- Make the protocol packet uPulse ----- *)
			<|
				(* Organizational information *)
				Object->CreateID[Object[Protocol,CrossFlowFiltration]],
				Type->Object[Protocol,CrossFlowFiltration],
				Name->Lookup[resolvedOptionsNoHidden,Name],
				Template->Link[Lookup[resolvedOptionsNoHidden,Template],ProtocolsTemplated],

				(* Options handling *)
				UnresolvedOptions->myUnresolvedOptions,
				ResolvedOptions->resolvedOptionsNoHidden,

				(* Checkpoints *)
				Replace[Checkpoints]->checkpoints,

				(* Storage RetentateStorageCondition, PermeateStorageCondition, FilterStorageCondition*)
				Replace[SamplesInStorage]->Lookup[expandedResolvedOptions,SamplesInStorageCondition],
				Replace[RetentateStorageConditions]->Lookup[expandedResolvedOptions,RetentateStorageCondition],
				Replace[PermeateStorageConditions]->Lookup[expandedResolvedOptions,PermeateStorageCondition],
				Replace[FilterStorageConditions]->Lookup[expandedResolvedOptions,FilterStorageCondition],

				(* new multiple fields *)
				Replace[SampleInVolumes]->Lookup[expandedResolvedOptions,SampleInVolume],
				Replace[DiafiltrationTargets]->sanitizedDiafiltrationTargets,
				Replace[PrimaryConcentrationTargets]->sanitizedPrimaryTargets,
				Replace[SecondaryConcentrationTargets]->sanitizedSecondaryTargets,
				Replace[DiafiltrationBufferWeights]->diafiltrationWeights,
				Replace[PrimaryConcentrationWeights]->primaryConcentrationWeights,
				Replace[SecondaryConcentrationWeights]->secondaryConcentrationWeights,
				Replace[RetentateAliquotVolumes]->Lookup[expandedResolvedOptions,RetentateAliquotVolume],
				Replace[PermeateAliquotVolumes]->Lookup[expandedResolvedOptions,PermeateAliquotVolume],
				Replace[FiltrationModes]->Lookup[expandedResolvedOptions,FiltrationMode],
				Replace[TransmembranePressureTargets]->Lookup[expandedResolvedOptions,TransmembranePressureTarget],
				Replace[PrimaryPumpFlowRates]->Lookup[expandedResolvedOptions,PrimaryPumpFlowRate],
				Replace[DiafiltrationModes]->Lookup[expandedResolvedOptions,DiafiltrationMode],
				Replace[DiafiltrationExchangeCounts]->Lookup[expandedResolvedOptions,DiafiltrationExchangeCount],
				Replace[DeadVolumeRecoveryModes]->Lookup[expandedResolvedOptions,DeadVolumeRecoveryMode],
				Replace[SampleReservoirs]->Link[Lookup[expandedResolvedOptions,SampleReservoir]],

				(* Experiment options without resources *)
				Replace[CrossFlowFilters]->Link/@filterResources,
				Replace[SamplesIn]-> (Link[#,Protocols]&/@samplesInResources),
				Replace[ContainersIn]-> (Link[#,Protocols]&/@containersInResource),
				Sterile->Lookup[expandedResolvedOptions,Sterile],
				FilterPrime->Lookup[expandedResolvedOptions,FilterPrime],
				FilterPrimeVolume->Lookup[expandedResolvedOptions,FilterPrimeVolume],
				FilterPrimeRinse->Lookup[expandedResolvedOptions,FilterPrimeRinse],
				FilterFlush->Lookup[expandedResolvedOptions,FilterFlush],
				FilterFlushVolume->Lookup[expandedResolvedOptions,FilterFlushVolume],
				FilterFlushRinse->Lookup[expandedResolvedOptions,FilterFlushRinse],

				(* Experiment options with resources *)
				Replace[FilterPrimeBuffers]->Link/@filterPrimeBufferResources,
				Replace[FilterPrimeDiafiltrationBuffers]->Link/@filterPrimeDiafiltrationBufferResources,
				Replace[FilterPrimeRinseBuffers]->Link/@filterPrimeRinseResources,
				Replace[FilterPrimeRinseDiafiltrationBuffers]->Link/@filterPrimeRinseDiafiltrationBufferResources,
				Replace[FilterFlushBuffers]->Link/@filterFlushBufferResources,
				Replace[FilterFlushDiafiltrationBuffers]->Link/@filterFlushDiafiltrationBufferResources,
				Replace[FilterFlushRinseBuffers]->Link/@filterFlushRinseResources,
				Replace[FilterFlushRinseDiafiltrationBuffers]->Link/@filterFlushRinseDiafiltrationBufferResources,

				WasteContainer->Link[wasteContainerResource],
				Replace[PermeateContainersOut]->Link/@permeateContainerResources,
				Replace[DiafiltrationBuffers]->diafiltrationBufferResources,
				Replace[RetentateContainersOut]->Link/@retentateContainerResources,
				Replace[TemporaryPermeateContainersOut]->Link/@temporaryPermeateContainersOutResources,
				Instrument->Link[instrumentResource],
				SampleReservoirRack->Link[sampleReservoirRackResource],
				DiafiltrationContainerRack->Link[diafiltrationContainerRackResource],
				TubeBlock -> Link[tubeBlockResource]
			|>

		],

		(* KR2i instrument *)
		Module[
			{
				diafiltrationTarget,filtrationMode, primaryConcentrationTarget, secondaryConcentrationTarget,sampleInVolume,
				sampleModelPackets,solvent,solventDensity,diafiltrationBufferSolvents,diafiltrationBufferDensities,
				diafiltrationPermeateVolumes,concentrationPermeateVolumesByStep,totalPermeateVolume,diafiltrationVolume,
				containerModels,bufferContainers,diafiltrationOverheadFactor,diafiltrationBufferTriplet,diafiltrationBufferResources,
				resolvedSampleReservoirPacket,diafiltrationBufferContainerToFeedContainerTubingPacket,feedContainerToFeedPressureSensorTubingPacket,
				permeatePressureSensorToConductivitySensorTubingPacket,retentateConductivitySensorToFeedContainerTubingPacket,
				retentatePressureSensorToConductivitySensorTubingPacket,retentateConductivitySensorInletTubingPacket,
				retentateConductivitySensorOutletTubingPacket,permeateConductivitySensorInletTubingPacket,permeateConductivitySensorOutletTubingPacket,
				filterToPermeatePressureSensorTubingPacket, filterAuxiliaryPermeateTubingPacket,
				filterToRetentatePressureSensorTubingPacket, feedPressureSensorToFilterTubingPacket, diafiltrationTubingObj,
				permeateTubingObj,retentateTubingObj,conductivitySensorTubingObj, filterTubingParentTubingObj,allTubingModelNoDupes,
				parentTubingLookup,diafiltrationTubingResource,permeateTubingResource,retentateTubingResource,
				conductivitySensorTubingResource,filterToPermeatePressureSensorParentTubingResource,KR2iDeadVolume,systemPermeateVolume,resolvedFilterPrimeVolume,
				filterPrimeVolumeToResourcePick,filterPrimeBufferResource,filterPrimeBufferContainerResource,
				filterPrimeRinseResource,filterPrimeRinseContainerResource,resolvedFilterFlushVolume,filterFlushVolumeToResourcePick,
				filterFlushBufferResource,filterFlushBufferContainerResource,filterFlushRinseResource,filterFlushRinseContainerResource,
				sampleReservoirPacket,feedContainerConnections,feedContainerFilterOutletFitting,feedContainerDetectorInletFitting,
				feedContainerDiafiltrationBufferInletFitting,filterConnectors,pressureSensorConnectorsToFilter,feedPressureSensorToFilterInletFitting,
				feedPressureSensorToFilterOutletFitting,filterToRetentatePressureSensorInletFitting,filterToRetentatePressureSensorOutletFitting,filterToPermeatePressureSensorOutletFitting,
				sensorConnectors,tubingsConnectedToPressureSensorsGauges,feedContainerToFeedPressureSensorTubingOutletFitting,
				retentatePressureSensorToConductivitySensorTubingInletFitting,permeatePressureSensorToConductivitySensorTubingInletFitting,
				feedContainerToFeedPressureSensorTubingInletFitting,retentateConductivitySensorToFeedContainerTubingOutletFitting,
				diafiltrationBufferContainerToFeedContainerTubingOutletFitting,retentatePressureSensorToConductivitySensorTubingOutletFitting,
				retentateConductivitySensorToFeedContainerTubingInletFitting,permeatePressureSensorToConductivitySensorTubingOutletFitting,filterPrimeFeedContainerFilterOutletFitting,
				filterPrimeFeedContainerDetectorInletFitting,filterFlushFeedContainerFilterOutletFitting,
				filterFlushFeedContainerDetectorInletFitting,systemFlushConnections,systemFlushFeedContainerFilterOutletFitting,
				systemFlushFeedContainerDetectorInletFitting, systemFlushContainer,systemFlushReservoirPacket,
				feedPressureSensorToFilterInletFittingResource, feedPressureSensorToFilterOutletFittingResource, filterToRetentatePressureSensorInletFittingResource,
				filterToRetentatePressureSensorOutletFittingResource, filterToPermeatePressureSensorOutletFittingResource, feedContainerFilterOutletFittingResource,
				feedContainerDetectorInletFittingResource, feedContainerDiafiltrationBufferInletFittingResource,
				feedContainerToFeedPressureSensorTubingOutletFittingResource, retentatePressureSensorToConductivitySensorTubingInletFittingResource,
				permeatePressureSensorToConductivitySensorTubingInletFittingResource, feedContainerToFeedPressureSensorTubingInletFittingResource,
				retentateConductivitySensorToFeedContainerTubingOutletFittingResource, diafiltrationBufferContainerToFeedContainerTubingOutletFittingResource,
				retentatePressureSensorToConductivitySensorTubingOutletFittingResource, retentateConductivitySensorToFeedContainerTubingInletFittingResource,
				permeatePressureSensorToConductivitySensorTubingOutletFittingResource, filterPrimeFeedContainerFilterOutletFittingResource,
				filterPrimeFeedContainerDetectorInletFittingResource, filterFlushFeedContainerFilterOutletFittingResource,
				filterFlushFeedContainerDetectorInletFittingResource, systemFlushFeedContainerFilterOutletFittingResource,
				systemFlushFeedContainerDetectorInletFittingResource,
				firstSamplePacket, updatedFittingResources,temporaryPermeateContainerOut,temporaryPermeateContainerResources,
				systemFlushFakeColumn,systemFlushFakeColumnFittings,fittingRack,sampleReservoirResource,filterResource,
				permeateContainerResources,retentateContainerResource,systemFlushBufferResource,systemFlushRinseBufferResource,
				systemFlushFakeColumnResource,systemFlushFakeColumnFittingResources,fittingRackResource,filterHolderResource,
				sampleReservoirRackResource,permeateContainerOutObject,permeateContainerOutPacket,permeateContainerOutRack,
				permeateContainerRackResourceLookup,protocolWashReservoirs,protocolWashReservoirPackets,
				nonSelfStandingWashReservoirPackets,uniqueWashReservoirResources,allWashRackResources,wasteContainerVolume,
				wasteFitsInContainer,resolvedWasteContainer,wasteContainerResource,sampleStorageConditionModels,
				sampleStorageConditionExpression,sampleStorageCondition,permeateWeightAlarm,retentateWeightAlarm,
				getFittingImages,allFittingImages,sterile,permeateAliquotVolume,
				sampleReservoir, crossFlowFilter, permeateContainerOut, retentateContainerOut, diafiltrationBuffer,
				firstFilterPacket, filterPrimeBufferContainer, resolvedFilterPrimeBufferContainer,
				liquidComponents, totalFilterPrimeRunTime,numberOfSteps,frequentCheckInTime,experimentRunTime,
				totalFilterFlushRunTime,totalRunTime, experimentTimeValid, resolvedFilterFlushBufferContainer,
				sanitiezedConcentrationTargets,sanitizedPrimaryTarget,sanitizedSecondaryTarget,sanitizedDiafiltrationTarget,
				xamplerFilterModels,xamplerFilterQ,filterConnectionsCouplingRingResources,feedContainerFittingConnectionsCouplingRingResources,
				filterPrimeFittingConnectionsCouplingRingResources, filterFlushFittingConnectionsCouplingRingResources,
				diafiltrationWeight, concentrationPermeateWeightsByStep, outputContainerModels, sterileContainers,
				nonSterileContainers, maxVolumeSterileContainer, maxVolumeNonSterileContainer, filterConnectionTubingClamps,
				tubeClampPliersResource
			},

			(* ----- Generate the instrument resource ----- *)

			(* Calculate filter prime run time *)
			totalFilterPrimeRunTime=Switch[Lookup[expandedResolvedOptions,{FilterPrime,FilterPrimeRinse}],
				{True,True},60 Minute,
				{True,False},30 Minute,
				{False,False},0 Minute
			];

			(* Calculate actual filtration run time -- for the time being, we are going to fix this at 3 hours per step. Once we have data from a few protocols, we will use the prime/flush times to calculate how long it takes to run the stuff through the filter because the theoretical calculations are outrageously inaccurate for this *)
			(* we are splitting the runtime to have an hour with frequent checkins (20min) and the rest with less frequent (60min)  *)
			numberOfSteps = Total@(Switch[#,
				Alternatives[Concentration|Diafiltration], 1,
				ConcentrationDiafiltration, 2,
				ConcentrationDiafiltrationConcentration, 3,
				(* just in case, default at 4 to overestimate *)
				True, 4
			]&/@Lookup[expandedResolvedOptions,FiltrationMode]);

			frequentCheckInTime=0.5 Hour;
			experimentRunTime=frequentCheckInTime + 2 Hour*numberOfSteps;


			(* Calculate filter flush run time *)
			totalFilterFlushRunTime=Switch[Lookup[expandedResolvedOptions,{FilterFlush,FilterFlushRinse}],
				{True,True},60 Minute,
				{True,False},30 Minute,
				{False,False},0 Minute
			];

			(* Calculate the total run time for the experiment *)
			totalRunTime=totalFilterPrimeRunTime+experimentRunTime+totalFilterFlushRunTime;
			experimentTimeValid=totalRunTime<$MaxExperimentTime;

			(* Create the instrument resource -- 150 minutes is the time it takes for all other steps *)
			instrumentResource=If[
				totalRunTime>0 Second,
				Resource[Instrument->Lookup[expandedResolvedOptions,Instrument],Time->totalRunTime+150 Minute]
			];
			(* ----- Generate the DiafiltrationBuffer resource ----- *)
			(* Fetch the variables we need for diafiltration buffer calculations *)
			{
				diafiltrationTarget,
				filtrationMode,
				primaryConcentrationTarget,
				secondaryConcentrationTarget,
				sampleInVolume,
				permeateAliquotVolume,
				sampleReservoir,
				crossFlowFilter,
				permeateContainerOut,
				retentateContainerOut,
				diafiltrationBuffer
			}=FirstOrDefault/@Lookup[
				expandedResolvedOptions,
				{
					DiafiltrationTarget,
					FiltrationMode,
					PrimaryConcentrationTarget,
					SecondaryConcentrationTarget,
					SampleInVolume,
					PermeateAliquotVolume,
					SampleReservoir,
					CrossFlowFilter,
					PermeateContainerOut,
					RetentateContainerOut,
					DiafiltrationBuffer
				}
			];
			{
				sterile
			}=Lookup[
				expandedResolvedOptions,
				{
					Sterile
				}
			];

			(* since the KR2i only use one sample we just collect the first packet of the simulatedSamplePackets *)
			firstSamplePacket= FirstOrDefault[simulatedSamplePackets,{}];

			(* Make a packet for the sample model *)
			sampleModelPackets=fetchPacketFromCache[#,newCache]&/@Download[FirstOrDefault[Lookup[firstSamplePacket,Model]],Object];

			(* If Solvent field for sample is informed, use it; otherwise, determine the solvents *)
			solvent=If[!MatchQ[Lookup[firstSamplePacket,Solvent,Null],Null|{}],
				Module[{},

					(* Find the liquid components, which are the solvents -- this is used below for density calculations, so we need to set this variable here *)
					liquidComponents={{100VolumePercent, Download[Lookup[firstSamplePacket,Solvent],Object]}};

					(* Return the molecules as our solvent *)
					Download[ToList[Lookup[firstSamplePacket,Solvent]],Object]
				],
				Module[{componentsAmount,solventPositions},

					(* Get all components and their amounts*)
					componentsAmount={First[#],Download[#[[2]],Object]}&/@Lookup[firstSamplePacket,Composition,{}];

					(* Find the liquid components *)
					liquidComponents=Select[componentsAmount,MatchQ[First[#],Alternatives[UnitsP[IndependentUnit["VolumePercent"]],UnitsP[1 VolumePercent]]]&];

					(* Find the positions of the solvents *)
					solventPositions=If[

						(* If we have liquid components, find their positions *)
						MatchQ[liquidComponents,Except[{}]],
						Flatten[Position[componentsAmount,#]&/@liquidComponents],

						(* Otherwise, we don't have a solvent *)
						Null
					];

					(* If we found a solvent, return it *)
					If[
						MatchQ[solventPositions,Except[Null]],
						Last/@Part[componentsAmount,solventPositions],
						Null
					]
				]
			];
			(* Find the density of the solvent *)
			solventDensity=Which[

				(* If sample has density, use it *)
				!NullQ[Lookup[firstSamplePacket,Density]],Lookup[firstSamplePacket,Density],

				(* If we found a solvent, use that *)
				!NullQ[solvent],Module[{solventPackets,solventDensities},

					(* Fetch the packets for the solvent molecules *)
					solventPackets=fetchPacketFromCache[#,newCache]&/@solvent;

					(* Lookup the densities for the solvent molecules *)
					solventDensities=Lookup[solventPackets,Density,Null];

					(* Calculate the density *)
					If[

						(* If we have all the densities, weigh it by the volume amount -- This method is not a great way of calculating the density for multiple solvents but unfortunately,without knowing the density of the actual solvent,we don't have a lot of options here *)
						!MemberQ[solventDensities,Null],
						Total[MapThread[
							#1/100*#2&,
							{Unitless[First/@liquidComponents],solventDensities}
						]],

						(* Otherwise *)
						Module[{redownloadedDensity},

							(* Check if the density is really missing in the database -- we are adding this here because assumed density pops up in ~1% of tests randomly even though the density is in the database. It's too rare and sporadic to figure out what is going on, but as far as I can tell, it has to do with the fact that every once in a while, something goes wrong with grabbing the data. So we are going to double check with the database in cases where we can't find the density to eliminate those sporadic cases *)
							redownloadedDensity=Download[solvent,Density];

							(* Return assumed/redownloaded value *)
							Total[MapThread[
								#1/100*#2&,
								{Unitless[First/@liquidComponents],redownloadedDensity/.Null->1 Gram/Milliliter}
							]]
						]
					]
				],

				(* Otherwise, we couldn't find a solvent so return 1 g/mL *)
				True,1 Gram/Milliliter
			];

			(* Find the diafiltration buffer solvent *)
			diafiltrationBufferSolvents=Function[
				bufferPacket,
				If[

					(* If there is no buffer, skip *)
					NullQ[bufferPacket],
					Null,

					(* Otherwise, find the solvent *)
					Module[{componentsAmount,liquidComponents,solventPositions},

						(* Get all components and their amounts*)
						componentsAmount={First[#],Download[#[[2]],Object]}&/@Lookup[bufferPacket,Composition,{}];

						(* Find the liquid components *)
						liquidComponents=Select[componentsAmount,MatchQ[First[#],Alternatives[UnitsP[IndependentUnit["VolumePercent"]],UnitsP[1 VolumePercent]]]&];

						(* Find the positions of the solvents *)
						solventPositions=If[

							(* If we have liquid components, find their positions *)
							MatchQ[liquidComponents,Except[{}]],
							Flatten[Position[componentsAmount,#]&/@liquidComponents],

							(* Otherwise, we don't have a solvent *)
							Null
						];

						(* Return the solvent and the liquid components *)
						Which[

							(* If solvent field for sample is informed, use it *)
							!MatchQ[Lookup[bufferPacket,Solvent,Null],Null|{}],{ToList[Download[Lookup[bufferPacket,Solvent],Object]],liquidComponents},

							(* Otherwise, determine based on manual resolution *)
							MatchQ[solventPositions,Except[Null]],{Last/@Part[liquidComponents,solventPositions],liquidComponents},

							(* Default condition for when we can't find the solvent *)
							True,Null
						]
					]
				]
			]/@diafiltrationBufferPackets;

			(* Find the density of the diafiltration buffer *)
			diafiltrationBufferDensities=MapThread[
				Function[
					{bufferPacket,solventAndLiquidComponents},
					Which[

						(* If no diafiltration buffer, carry on *)
						NullQ[bufferPacket],Null,

						(* If buffer has density, use it *)
						!NullQ[Lookup[bufferPacket,Density]],Lookup[bufferPacket,Density],

						(* If we found a solvent, use that *)
						!NullQ[solventAndLiquidComponents],Module[{solventPackets,solventDensities,densityReallyMissing},

						(* Fetch the packets for the solvent molecules *)
						solventPackets=fetchPacketFromCache[#,newCache]&/@First[solventAndLiquidComponents];

						(* Lookup the densities for the solvent molecules *)
						solventDensities=Lookup[solventPackets,Density,Null];

						(* Calculate the density *)
						If[

							(* If we have all the densities, weight it by the volume amount -- This method is not a great way of calculating the density for multiple solvents but unfortunately,without knowing the density of the actual solvent,we don't have a lot of options here *)
							!MemberQ[solventDensities,Null],
							Total[MapThread[
								#1/100*#2&,
								{Unitless[First/@(solventAndLiquidComponents[[2]])],solventDensities}
							]],

							(* Otherwise *)
							Module[{redownloadedDensity},

								(* Check if the density is really missing in the database -- we are adding this here because assumed density pops up in ~1% of tests randomly even though the density is in the database. It's too rare and sporadic to figure out what is going on, but as far as I can tell, it has to do with the fact that every once in a while, something goes wrong with grabbing the data. So we are going to double check with the database in cases where we can't find the density to eliminate those sporadic cases *)
								redownloadedDensity=Download[First[solventAndLiquidComponents],Density];
								densityReallyMissing=MemberQ[redownloadedDensity,Null];

								(* Return assumed/redownloaded value *)
								If[
									densityReallyMissing,
									1 Gram/Milliliter,
									Total[MapThread[
										#1/100*#2&,
										{Unitless[First/@Last[solventAndLiquidComponents]],redownloadedDensity}
									]]
								]
							]
						]
					],

						(* Otherwise, we couldn't find a solvent so return 1 g/mL *)
						True,1 Gram/Milliliter
					]
				],
				{diafiltrationBufferPackets,diafiltrationBufferSolvents}
			];

			(* Check if PermeateAliquotVolume will exceed scale capacity *)
			(* Calculate the permeate volume from targets *)
			diafiltrationPermeateVolumes=If[(And@@diafiltrationList),
				Experiment`Private`calculateDiafiltrationVolume[sampleInVolume,primaryConcentrationTarget,diafiltrationTarget, solventDensity],
				0Liter
			];

			(* Calculate the permeate volume from concentration targets *)
			concentrationPermeateVolumesByStep=If[And@@concentrationList,
				Experiment`Private`calculatePermeateTargetToVolume[{primaryConcentrationTarget, secondaryConcentrationTarget},sampleInVolume,solventDensity,diafiltrationBufferDensities[[1]]],
				{0Liter,0Liter}
			];

			(* We also need to calculation  *)
			concentrationPermeateWeightsByStep = (concentrationPermeateVolumesByStep * {(solventDensity),(diafiltrationBufferDensities[[1]]/.Null->solventDensity)});
			(* figure out total permeate volume *)
			totalPermeateVolume = Total[Flatten[{diafiltrationPermeateVolumes,concentrationPermeateVolumesByStep}]];

			(* If diafiltration step, return theoretical volume -- since we are collecting everything the output volume is the same as how much buffer we need *)
			{diafiltrationVolume,diafiltrationWeight}=If[
				(And@@diafiltrationList),
				{diafiltrationPermeateVolumes, diafiltrationPermeateVolumes * (diafiltrationBufferDensities[[1]])},
				{Null, Null}
			];

			(* Find all the containers in the cache *)
			containerModels=Select[newCache,MatchQ[Lookup[#,Type],Model[Container,Vessel]]&];

			(* Find the containers we can use based on sterility *)
			bufferContainers=If[
				sterile,
				Pick[KeyTake[containerModels,{Object,MaxVolume}],Lookup[containerModels,Sterile,Null],True],
				Join[

					(* Add tubes since they are always sterile *)
					KeyTake[Select[containerModels,Lookup[#,MaxVolume]<=50 Milliliter&],{Object,MaxVolume}],

					(* Non-sterile bottles and carboys *)
					Pick[KeyTake[containerModels,{Object,MaxVolume}],Lookup[containerModels,Sterile,Null],False]
				]
			];

			(* because the diafiltration volume can be up to 18L, we need to make sure we can handle that case wrt the overhead volume we're getting *)
			diafiltrationOverheadFactor = Which[
				diafiltrationPermeateVolumes<= 0.5Liter, 1.5,
				diafiltrationPermeateVolumes<= 16Liter, 1.25,
				diafiltrationPermeateVolumes<= 18Liter, 1.1
			];

			(* Find and add the container to the {buffer,volume} pairs *)
			diafiltrationBufferTriplet=	If[
				(And@@diafiltrationList),
				{
					diafiltrationBuffer,
					diafiltrationVolume,
					(* Add a container to the list *)
					Module[{allFittingContainers,minVolume},

						(* Find all fitting containers (taking into account that we're taking extra volume later*)
						allFittingContainers=Select[bufferContainers,GreaterEqual[Lookup[#,MaxVolume],diafiltrationPermeateVolumes*diafiltrationOverheadFactor]&];

						(* Find the smallest volume amongst the fitting containers *)
						minVolume=Min[Lookup[allFittingContainers,MaxVolume]];

						(* Find and return the object of the container with the smallest volumes *)
						Lookup[
							SelectFirst[bufferContainers,Lookup[#,MaxVolume]==minVolume&],
							Object
						]
					]
				},
				(* Otherwise *)
				{Null,Null,Null}
			];

			(* Create the resource with 25% extra buffer for dead volume *)
			diafiltrationBufferResources=If[
				(And@@diafiltrationList),
				Link[Resource[Sample->diafiltrationBufferTriplet[[1]],Amount->diafiltrationOverheadFactor*diafiltrationBufferTriplet[[2]],Container->diafiltrationBufferTriplet[[3]],RentContainer->True]],
				Null
			];

			(* ----- Generate parent tubing resources ----- *)
			(* doing this first so we can figure out the dead volume and take it into account in buffer resources *)
			
			(* NOTE: Depending on the filter we are using, we might have to cut an additional tubing *)
			(* Get a boolean that states whether the filter is an xampler filter or not *)
			(* Generate the coupling ring resources *)
			(* The filters that require TriCloverClamp connections are the following *)
			(* These filters also have very un-barbed bar connectors, and require tubing clamps. *)
			xamplerFilterModels = {
				Model[Item, CrossFlowFilter, "id:E8zoYvNEGW0X"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 100 kDa"] *)
				Model[Item, CrossFlowFilter, "id:Vrbp1jKWwNAx"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 50 kDa"] *)
				Model[Item, CrossFlowFilter, "id:9RdZXv14EO6l"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 30 kDa"] *)
				Model[Item, CrossFlowFilter, "id:J8AY5jD3LBl7"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 10 kDa"] *)
				Model[Item, CrossFlowFilter, "id:KBL5DvwKEMEa"], (* Model[Item, CrossFlowFilter, "Dry Xampler PS 5 kDa"] *)
				Model[Item, CrossFlowFilter, "id:dORYzZJqwNLq"] (* Model[Item, CrossFlowFilter, "Dry Xampler PS 0.2 Micron"] *)
			};

			xamplerFilterQ = MatchQ[Lookup[First[filterPacket],Object],ObjectP[xamplerFilterModels]];
			
			(*--- Now get all the tube we want to use in the protocol ---*)

			(* First find the packet *)
			resolvedSampleReservoirPacket=fetchPacketFromFastAssoc[sampleReservoir,fastCacheBall];

			(* Calculate to get all tubing packet *)
			{
				{
					diafiltrationBufferContainerToFeedContainerTubingPacket,
					feedContainerToFeedPressureSensorTubingPacket,
					permeatePressureSensorToConductivitySensorTubingPacket,
					retentateConductivitySensorToFeedContainerTubingPacket,
					retentatePressureSensorToConductivitySensorTubingPacket,
					retentateConductivitySensorInletTubingPacket,
					retentateConductivitySensorOutletTubingPacket,
					permeateConductivitySensorInletTubingPacket,
					permeateConductivitySensorOutletTubingPacket,
					filterToPermeatePressureSensorTubingPacket,
					filterAuxiliaryPermeateTubingPacket,
					feedPressureSensorToFilterTubingPacket,
					filterToRetentatePressureSensorTubingPacket
				},
				{
					diafiltrationTubingObj,
					permeateTubingObj,
					retentateTubingObj,
					conductivitySensorTubingObj,
					filterTubingParentTubingObj
				}
			}=calculateAllTubingPackets[resolvedSampleReservoirPacket,xamplerFilterQ,fastCacheBall];

			(* Now generate resources for the parent tubing that we need to cut them *)
			allTubingModelNoDupes= DeleteCases[DeleteDuplicates[{diafiltrationTubingObj,permeateTubingObj,retentateTubingObj,conductivitySensorTubingObj,filterTubingParentTubingObj}],Null];

			(* make resources replacement rule *)
			parentTubingLookup= Map[
				Function[{obj},
					(
						obj->Resource[
							Sample->obj,
							Name->CreateUUID[]
						]
					)
				],
				allTubingModelNoDupes
			];

			(* Generate the parent tubing resources *)
			{
				diafiltrationTubingResource,
				permeateTubingResource,
				retentateTubingResource,
				conductivitySensorTubingResource,
				filterToPermeatePressureSensorParentTubingResource
			}=Replace[
				{
					diafiltrationTubingObj,
					permeateTubingObj,
					retentateTubingObj,
					conductivitySensorTubingObj,
					filterTubingParentTubingObj
				},
				parentTubingLookup,
				{1}
			];

			(* Since KR2i only use one single sample we fetch the first filterPacket *)
			firstFilterPacket = FirstOrDefault[filterPacket];

			(* Now calculate the volume of the relevant tubings - specifically from the sample to the filter (1), from the filter to the retentate conductivity sensor (and Cary) (3), and from the conductivity sensor/Cary to the sample reservoir (4) *)
			KR2iDeadVolume = calculateKR2iDeadVolume[
				Lookup[firstFilterPacket, MinVolume, 0 Milliliter],
				Lookup[feedContainerToFeedPressureSensorTubingPacket, Object],
				Lookup[retentatePressureSensorToConductivitySensorTubingPacket, Object],
				Lookup[retentateConductivitySensorToFeedContainerTubingPacket, Object],
				newCache
			];

			(* same for permeate side *)
			systemPermeateVolume=Ceiling[
				Total[Flatten[{
					(* Tubing from filter to permeate conductivity sensor *)
					Map[
						Function[{precutTubeObject},
							If[NullQ[precutTubeObject],
								0 Milliliter,
								Module[{precutTubePacket,length,innerDiameter,volume},

									(* Get packet *)
									precutTubePacket=fetchPacketFromCache[precutTubeObject,newCache];

									(* Get inner diameter and length *)
									{length,innerDiameter}=Lookup[precutTubePacket,{Size,InnerDiameter}];

									(* Calculate tubing volume *)
									volume=Convert[Pi*(innerDiameter/2)^2*length, Milliliter]
								]
							]
						],
						{
							If[NullQ[filterToPermeatePressureSensorTubingPacket],Null,Lookup[filterToPermeatePressureSensorTubingPacket,Object]],
							Lookup[permeatePressureSensorToConductivitySensorTubingPacket,Object],
							Lookup[permeateConductivitySensorInletTubingPacket,Object],
							Lookup[permeateConductivitySensorOutletTubingPacket,Object]
						}
					],

					(* system overhead for permeate conductivity and pressure sensors- 2 ml each *)
					2 Milliliter*2
				}]]
			];

			(* ----- Generate the FilterPrimeBuffer resource ----- *)

			(* Find the resolved volume for the filter prime - add buffer for safety*)
			resolvedFilterPrimeVolume=Lookup[expandedResolvedOptions,FilterPrimeVolume];

			(* we resource pick twice the volume, or 500 ml so that we can use concentration recipes to run it automatically. if it requires more than 500ml, we will handle it by updating the concentration factor *)
			filterPrimeVolumeToResourcePick = If[resolvedFilterPrimeVolume > 500Milliliter,
				500Milliliter,
				resolvedFilterPrimeVolume
			];


			(* If Operation Filter Prime is a go, make a resource *)
			{filterPrimeBufferResource, filterPrimeBufferContainerResource}=If[
				Lookup[expandedResolvedOptions,FilterPrime]&&experimentTimeValid,
				Module[{primeBufferFitsInContainer},

					(* Find all containers the buffer would fit into *)
					primeBufferFitsInContainer=PickList[washContainerPackets,GreaterEqual[Lookup[#,MaxVolume],filterPrimeVolumeToResourcePick]&/@washContainerPackets];

					(* Find the first smallest container the volume fits in *)
					filterPrimeBufferContainer=Lookup[
						SelectFirst[primeBufferFitsInContainer,MatchQ[Lookup[#,MaxVolume],Min[Lookup[primeBufferFitsInContainer,MaxVolume]]]&],
						Object
					];
					(* Find the first smallest container the volume fits in *)
					resolvedFilterPrimeBufferContainer=Lookup[
						SelectFirst[primeBufferFitsInContainer,MatchQ[Lookup[#,MaxVolume],Min[Lookup[primeBufferFitsInContainer,MaxVolume]]]&],
						Object
					];

					(* Return resources *)
					{
						Resource[Sample->Lookup[expandedResolvedOptions,FilterPrimeBuffer],Amount->filterPrimeVolumeToResourcePick,Container->PreferredContainer[filterPrimeVolumeToResourcePick],RentContainer->True],
						Resource[Sample->filterPrimeBufferContainer,Name->ToString[Unique[]],Rent->True]
					}
				],
				{Null, Null}
			];

			(* ----- Generate the FilterPrimeRinse resource ----- *)
			{filterPrimeRinseResource, filterPrimeRinseContainerResource}=If[
				Lookup[expandedResolvedOptions,FilterPrimeRinse]&&experimentTimeValid,
				{
					Resource[Sample->Lookup[expandedResolvedOptions,FilterPrimeRinseBuffer],Amount->resolvedFilterPrimeVolume,Container->PreferredContainer[filterPrimeVolumeToResourcePick],RentContainer->True],
					Resource[Sample->resolvedFilterPrimeBufferContainer,Name->ToString[Unique[]],Rent->True]
				},
				{Null,Null}
			];

			(* ----- Generate the FilterFlushBuffer resource ----- *)

			(* Find the resolved volume for the filter prime *)
			resolvedFilterFlushVolume=Lookup[expandedResolvedOptions,FilterFlushVolume];

			(* we resource pick twice the volume, or 500 ml so that we can use concentration recipes to run it automatically. if it requires more than 500ml, we will handle it by updating the concentration factor *)
			filterFlushVolumeToResourcePick = If[resolvedFilterFlushVolume > 500Milliliter,
				500Milliliter,
				resolvedFilterFlushVolume
			];

			(* Pre assign a Null value*)
			resolvedFilterFlushBufferContainer=Null;

			(* Generate the resource *)
			{filterFlushBufferResource, filterFlushBufferContainerResource}=If[
				Lookup[expandedResolvedOptions,FilterFlush]&&experimentTimeValid,
				Module[{flushBufferFitsInContainer},

					(* Find all containers the buffer would fit into *)
					flushBufferFitsInContainer=PickList[washContainerPackets,GreaterEqual[Lookup[#,MaxVolume],filterFlushVolumeToResourcePick]&/@washContainerPackets];

					(* Find the first smallest container the volume fits in *)
					resolvedFilterFlushBufferContainer=Lookup[
						SelectFirst[flushBufferFitsInContainer,MatchQ[Lookup[#,MaxVolume],Min[Lookup[flushBufferFitsInContainer,MaxVolume]]]&],
						Object
					];

					(* Return resources *)
					{
						Resource[Sample->Lookup[expandedResolvedOptions,FilterFlushBuffer],Amount->filterFlushVolumeToResourcePick,Container->PreferredContainer[filterFlushVolumeToResourcePick],RentContainer->True],
						Resource[Sample->resolvedFilterFlushBufferContainer,Name->ToString[Unique[]],Rent->True]
					}
				],
				{Null, Null}
			];

			(* ----- Generate the FilterFlushRinse resource ----- *)
			{filterFlushRinseResource, filterFlushRinseContainerResource}=If[
				Lookup[expandedResolvedOptions,FilterFlushRinse]&&experimentTimeValid,
				{
					Resource[Sample->Model[Sample,"Milli-Q water"],Amount->filterFlushVolumeToResourcePick,Container->PreferredContainer[filterFlushVolumeToResourcePick],RentContainer->True],
					Resource[Sample->resolvedFilterFlushBufferContainer,Name->ToString[Unique[]],Rent->True]
				},
				{Null, Null}
			];


			(* ----- Generate Fittings resources ----- *)
			(* ----- Get all Resources ---- *)


			(* Prepare a sample reservoir packet for lookups *)
			sampleReservoirPacket=fetchPacketFromCache[sampleReservoir,newCache];

			(* Find the connections for the feed container and order them *)
			feedContainerConnections={
				SelectFirst[Lookup[sampleReservoirPacket,Connectors,{}],First[#]=="Filter Outlet"&],
				SelectFirst[Lookup[sampleReservoirPacket,Connectors,{}],First[#]=="Detector Inlet"&],
				SelectFirst[Lookup[sampleReservoirPacket,Connectors,{}],First[#]=="Diafiltration Buffer Inlet"&]
			};


			(* Resolve the fittings that connect the feed container to other tubings *)
			{
				feedContainerFilterOutletFitting,
				feedContainerDetectorInletFitting,
				feedContainerDiafiltrationBufferInletFitting
			}=Map[
				Function[
					connection,
					Which[

						(* If sample reservoir has 1/32" tubing, find a barbed fitting for 1/16" -- the 1/32" tubing requires 1/16" barbs, everything else is the same as the diameter, so we need this exception here *)
						MatchQ[connection[[2]],Tube]&&connection[[4]]==1/32 Inch,
							Lookup[
								SelectFirst[
									fittingPackets,
									And[
										MemberQ[Lookup[#,Connectors],{_,Barbed,None,0.0625 Inch,0.0625 Inch,None}],
										MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
									]&
								],
								Object
							],

						(* If sample reservoir has tubing, find a barbed fitting *)
						MatchQ[connection[[2]],Tube],
							Lookup[
								SelectFirst[
									fittingPackets,
									And[
										MemberQ[Lookup[#,Connectors],{_,Barbed,None,connection[[4]],connection[[5]],None}],
										MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
									]&
								],
								Object
							],

						(* If sample reservoir has female LuerLock, find a male LuerLock fitting *)
						MatchQ[connection[[2]],LuerLock]&&MatchQ[connection[[6]],Female],
							Lookup[
								SelectFirst[
									fittingPackets,
									And[
										MemberQ[Lookup[#,Connectors],{_,LuerLock,None,Null,Null,Male}],
										MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
									]&
								],
								Object
							],

						(* If sample reservoir has male LuerLock, find a female LuerLock fitting *)
						MatchQ[connection[[2]],LuerLock]&&MatchQ[connection[[6]],Male],
							Lookup[
								SelectFirst[
									fittingPackets,
									And[
										MemberQ[Lookup[#,Connectors],{_,LuerLock,None,Null,Null,Female}],
										MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
									]&
								],
								Object
							],

						(* If sample reservoir has TC clamp, find a TC connector *)
						MatchQ[connection[[2]],TriCloverClamp],
							Lookup[
								SelectFirst[
									fittingPackets,
									And[
										MemberQ[Lookup[#,Connectors],{_,TriCloverClamp,None,connection[[4]],connection[[5]],None}],
										MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
									]&
								],
								Object
							]
					]
				],
				feedContainerConnections
			];

			(* Find the connections for the filter *)
			(* NOTE: Depending on the filter, we either connect the filterToPermeatePressureSensorFitting directly to the filter *)
			(* or, for Xampler filters, we connect to a 1/4" tubing *)
			filterConnectors={
				SelectFirst[Lookup[firstFilterPacket,Connectors,{}],First[#]=="Inlet Pressure Sensor Inlet"&],
				SelectFirst[Lookup[firstFilterPacket,Connectors,{}],First[#]=="Retentate Pressure Sensor Outlet"&],
				SelectFirst[Lookup[firstFilterPacket,Connectors,{}],First[#]=="Permeate Pressure Sensor Inlet"&]
			};

			(* Get the pressure sensor connectors that will connect to the filter *)
			pressureSensorConnectorsToFilter = {
				SelectFirst[Lookup[instrumentModelPacket,Connectors,{}],First[#]=="Feed Pressure Sensor Outlet"&],
				SelectFirst[Lookup[instrumentModelPacket,Connectors,{}],First[#]=="Retentate Pressure Sensor Outlet"&],
				SelectFirst[Lookup[instrumentModelPacket,Connectors,{}],First[#]=="Permeate Pressure Sensor Outlet"&]
			};

			(* Resolve the fittings that connect the filter to the pressure sensors *)
			{
				feedPressureSensorToFilterInletFitting,
				feedPressureSensorToFilterOutletFitting,
				filterToRetentatePressureSensorInletFitting,
				filterToRetentatePressureSensorOutletFitting,
				filterToPermeatePressureSensorOutletFitting
			}=Flatten@MapThread[
				Function[
					{
						filterConnector,pressureSensorConnector
					},
					If[xamplerFilterQ,
						(* When we are using an xampler filter, we need some additional fittings because we need to connect the filter's TCC connections *)
						(* to a tube and then the tube to a fitting on the pressure sensor. The tube will always be a 1/4" inner diameter tube so we can directly build *)
						(* the fitting search packets depending on what filter connection we are dealing with *)
						Which[
							MatchQ[First[filterConnector],"Permeate Pressure Sensor Inlet"],
								Module[{filterConnectorFittingConnectorTuple,pressureSensorConnectorFittingConnectorTuple},
									(* For the Permeate pressure sensor inlet, the filter has a 3/8" barb so we need a fitting that connects a 1/4" tube to a male LuerLock fitting *)
									filterConnectorFittingConnectorTuple = {_,Barbed, None, 0.25 Inch, 0.25 Inch, None};
									pressureSensorConnectorFittingConnectorTuple = {_,LuerLock,None,Null,Null,Male};

									(* Find the corresponding fitting packet *)
									SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],filterConnectorFittingConnectorTuple],
											MemberQ[Lookup[#,Connectors],pressureSensorConnectorFittingConnectorTuple]
										]&
									]
								],
							MatchQ[First[filterConnector],"Inlet Pressure Sensor Inlet"],
								Module[
									{
										filterConnectorFittingConnectorTuple,tubeConnectorTuple,pressureSensorConnectorFittingConnectorTuple,
										inletFittingPacket,outletFittingPacket
									},
									(* For the Inlet pressure sensor inlet, the filter has a TCC connection *)
									filterConnectorFittingConnectorTuple = {_,TriCloverClamp, None, 1.0 Inch, 1.0 Inch, None};
									tubeConnectorTuple={_,Barbed, None, 0.25 Inch, 0.25 Inch, None};
									pressureSensorConnectorFittingConnectorTuple = {_,LuerLock,None,Null,Null,Male};

									(* Find the inlet fitting packet *)
									inletFittingPacket = SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],tubeConnectorTuple],
											MemberQ[Lookup[#,Connectors],pressureSensorConnectorFittingConnectorTuple]
										]&
									];

									(* Find the outlet fitting packet *)
									outletFittingPacket = SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],filterConnectorFittingConnectorTuple],
											MemberQ[Lookup[#,Connectors],tubeConnectorTuple]
										]&
									];

									(* Return the fittings *)
									{
										Lookup[inletFittingPacket,Object],
										Lookup[outletFittingPacket,Object]
									}
								],
							True,
								Module[
									{
										filterConnectorFittingConnectorTuple,tubeConnectorTuple,pressureSensorConnectorFittingConnectorTuple,
										inletFittingPacket,outletFittingPacket
									},
									(* For the Inlet pressure sensor inlet, the filter has a TCC connection *)
									filterConnectorFittingConnectorTuple = {_,TriCloverClamp, None, 1.0 Inch, 1.0 Inch, None};
									tubeConnectorTuple={_,Barbed, None, 0.25 Inch, 0.25 Inch, None};
									pressureSensorConnectorFittingConnectorTuple = {_,LuerLock,None,Null,Null,Male};

									(* Find the inlet fitting packet *)
									inletFittingPacket = SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],filterConnectorFittingConnectorTuple],
											MemberQ[Lookup[#,Connectors],tubeConnectorTuple]
										]&
									];

									(* Find the outlet fitting packet *)
									outletFittingPacket = SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],tubeConnectorTuple],
											MemberQ[Lookup[#,Connectors],pressureSensorConnectorFittingConnectorTuple]
										]&
									];

									(* Return the fittings *)
									{
										Lookup[inletFittingPacket,Object],
										Lookup[outletFittingPacket,Object]
									}
								]
						],
						Module[{filterConnectorFittingConnectorTuple,pressureSensorConnectorFittingConnectorTuple,fittingToReturn},
							(* First find the filterConnectorFittingConnector (what is needed from the fitting to connect to the filter) *)
							filterConnectorFittingConnectorTuple = Which[

								(* If filter has 3/8" barb, find a 1/4" tube fitting *)
								MatchQ[filterConnector[[2]],Barbed]&&filterConnector[[4]]==0.375 Inch,
								{_,Tube,None,0.25 Inch,0.25 Inch,None},

								(* If filter has barb, find a tube fitting *)
								MatchQ[filterConnector[[2]],Barbed],
								{_,Tube,None,filterConnector[[4]],filterConnector[[5]],None},

								(* If filter has female LuerLock, find a male LuerLock fitting *)
								MatchQ[filterConnector[[2]],LuerLock]&&MatchQ[filterConnector[[6]],Female],
								{_,LuerLock,None,Null,Null,Male},

								(* If filter has male LuerLock, find a female LuerLock fitting *)
								MatchQ[filterConnector[[2]],LuerLock]&&MatchQ[filterConnector[[6]],Male],
								{_,LuerLock,None,Null,Null,Female},

								(* If filter has TC clamp, find a TC connector *)
								MatchQ[filterConnector[[2]],TriCloverClamp],
								{_,TriCloverClamp,None,filterConnector[[4]],filterConnector[[5]],None}
							];

							(* Next, find the pressureSensorConnectorFittingConnector (what is needed from the fitting to connect to the pressure sensor) *)
							(* NOTE, the pressure sensor can only have a LuerLock connector *)
							pressureSensorConnectorFittingConnectorTuple = If[MatchQ[pressureSensorConnector[[6]],Male],
								{_,LuerLock,None,Null,Null,Female},
								{_,LuerLock,None,Null,Null,Male}
							];

							(* Find the fitting that satisfies these two constraints *)
							(* NOTE: we have to do a different lookup if the constraints are the same on both sides *)
							fittingToReturn = Lookup[
								If[MatchQ[filterConnectorFittingConnectorTuple,pressureSensorConnectorFittingConnectorTuple],
									SelectFirst[
										fittingPackets,
										MatchQ[Lookup[#,Connectors],{filterConnectorFittingConnectorTuple,pressureSensorConnectorFittingConnectorTuple}]&
									],
									SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],filterConnectorFittingConnectorTuple],
											MemberQ[Lookup[#,Connectors],pressureSensorConnectorFittingConnectorTuple]
										]&
									]
								],
								Object
							];

							(* NOTE: We have to return an additional Null for the retentate and feed cases in order to have our listyness match *)
							If[!MatchQ[First[filterConnector],"Permeate Pressure Sensor Inlet"],
								{
									fittingToReturn,
									Null
								},
								fittingToReturn
							]
						]
					]
				],
				{
					filterConnectors,
					pressureSensorConnectorsToFilter
				}
			];

			(* Order the connections for the sensors *)
			sensorConnectors={
				SelectFirst[Lookup[instrumentModelPacket,Connectors,{}],First[#]=="Feed Pressure Sensor Inlet"&],
				SelectFirst[Lookup[instrumentModelPacket,Connectors,{}],First[#]=="Retentate Pressure Sensor Inlet"&],
				SelectFirst[Lookup[instrumentModelPacket,Connectors,{}],First[#]=="Permeate Pressure Sensor Inlet"&]
			};

			(* Order the corresponding tubing connections *)
			tubingsConnectedToPressureSensorsGauges = {
				Lookup[feedContainerToFeedPressureSensorTubingPacket,InnerDiameter,Null],
				Lookup[retentatePressureSensorToConductivitySensorTubingPacket,InnerDiameter,Null],
				Lookup[permeatePressureSensorToConductivitySensorTubingPacket,InnerDiameter,Null]
			};

			(* Resolve the fittings that connect the pressure sensors to other tubings *)
			{
				feedContainerToFeedPressureSensorTubingOutletFitting,
				retentatePressureSensorToConductivitySensorTubingInletFitting,
				permeatePressureSensorToConductivitySensorTubingInletFitting
			}=MapThread[
				Function[
					{pressureSensorConnector,tubingGauge},
					Module[{tubingConnectorFittingConnectorTuple,pressureSensorConnectorFittingConnectorTuple},
						(* First find the tubingConnectorFittingConnector (what is needed from the fitting to connect to the tubing) *)
						(* NOTE: We always connect a barbed -> tube - just choose the correct size barb *)
						tubingConnectorFittingConnectorTuple = {_,Barbed,None,tubingGauge,tubingGauge,None};

						(* Next, find the pressureSensorConnectorFittingConnector (what is needed from the fitting to connect to the pressure sensor) *)
						(* NOTE, the pressure sensor can only have a LuerLock connector *)
						pressureSensorConnectorFittingConnectorTuple = If[MatchQ[pressureSensorConnector[[6]],Male],
							{_,LuerLock,None,Null,Null,Female},
							{_,LuerLock,None,Null,Null,Male}
						];

						(* Find the fitting that satisfies these two constraints *)
						(* NOTE: we have to do a different lookup if the constraints are the same on both sides *)
						Lookup[
							SelectFirst[
								fittingPackets,
								And[
									MemberQ[Lookup[#,Connectors],tubingConnectorFittingConnectorTuple],
									MemberQ[Lookup[#,Connectors],pressureSensorConnectorFittingConnectorTuple]
								]&
							],
							Object
						]
					]
				],
				{
					sensorConnectors,
					tubingsConnectedToPressureSensorsGauges
				}
			];

			(*Resolve the fittings for the tubes to connect to the feed container fittings*)
			{
				feedContainerToFeedPressureSensorTubingInletFitting,
				retentateConductivitySensorToFeedContainerTubingOutletFitting,
				diafiltrationBufferContainerToFeedContainerTubingOutletFitting
			}=Map[
				Function[
					{tubeGauge},
					Lookup[
						SelectFirst[
							fittingPackets,
							And[
								MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Female}],
								MemberQ[Lookup[#,Connectors],{_,Barbed,None,tubeGauge,tubeGauge,None}]
							]&
						],
						Object
					]
				],
				Flatten[{
					Lookup[feedContainerToFeedPressureSensorTubingPacket,InnerDiameter],
					Lookup[retentateConductivitySensorToFeedContainerTubingPacket,InnerDiameter],
					If[MatchQ[diafiltrationBufferContainerToFeedContainerTubingPacket,{Null}],
						_,
						Lookup[diafiltrationBufferContainerToFeedContainerTubingPacket,InnerDiameter]
					]
				}]
			];

			(* Resolve the fittings that connect two tubes together *)
			{
				retentateConductivitySensorToFeedContainerTubingInletFitting,
				retentatePressureSensorToConductivitySensorTubingOutletFitting,
				permeatePressureSensorToConductivitySensorTubingOutletFitting
			}=MapThread[
				Function[
					{inletTubeGauge,outletTubeGauge},

					Lookup[
						SelectFirst[
							fittingPackets,
							MatchQ[Lookup[#,Connectors],
								Alternatives[
									{{_,Barbed,None,inletTubeGauge,inletTubeGauge,None},{_,Barbed,None,outletTubeGauge,outletTubeGauge,None}},
            						{{_,Barbed,None,outletTubeGauge,outletTubeGauge,None},{_,Barbed,None,inletTubeGauge,inletTubeGauge,None}}
								]
							]&
						],
						Object
					]
				],
				{
					Flatten@{
						Lookup[retentateConductivitySensorOutletTubingPacket,InnerDiameter],
						Lookup[retentatePressureSensorToConductivitySensorTubingPacket,InnerDiameter],
						Lookup[permeatePressureSensorToConductivitySensorTubingPacket,InnerDiameter]
					},
					Flatten@{
						Lookup[retentateConductivitySensorToFeedContainerTubingPacket,InnerDiameter],
						Lookup[retentateConductivitySensorInletTubingPacket,InnerDiameter],
						Lookup[permeateConductivitySensorInletTubingPacket,InnerDiameter]
					}
				}
			];

			(* ----- Generate Special Fittings resources ----- *)

			(* If we are priming the filter, find the fittings *)
			{
				filterPrimeFeedContainerFilterOutletFitting,
				filterPrimeFeedContainerDetectorInletFitting
			}=If[
				Lookup[expandedResolvedOptions,FilterPrime]&&experimentTimeValid,
				Module[{filterPrimeReservoirPacket,filterPrimeConnections},

					(* Prepare a packet for lookups *)
					filterPrimeReservoirPacket=fetchPacketFromCache[resolvedFilterPrimeBufferContainer,washContainerPackets];

					(* Find the connections for the reservoir and order them *)
					filterPrimeConnections={
						SelectFirst[Lookup[filterPrimeReservoirPacket,Connectors,{}],First[#]=="Filter Outlet"&],
						SelectFirst[Lookup[filterPrimeReservoirPacket,Connectors,{}],First[#]=="Detector Inlet"&]
					};

					(* Resolve the fittings *)
					(* NOTE: There is one Model[Container,Vessel,CrossFlowContainer] that has a luerlock connection for the DiafiltrationBuffer Inlet *)
					(* However, we never utilize that connection for the FilterPrime step, so we don't consider that case here *)
					Map[
						Function[
							connection,
							Which[

								(* If reservoir has tubing, find a barbed fitting *)
								MatchQ[connection[[2]],Tube],
									Lookup[
										SelectFirst[
											fittingPackets,
											And[
												MemberQ[Lookup[#,Connectors],{_,Barbed,None,connection[[4]],connection[[5]],None}],
												MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
											]&
										],
										Object
									],

								(* If reservoir has TC clamp, find a TC connector *)
								MatchQ[connection[[2]],TriCloverClamp],
									Lookup[
										SelectFirst[
											fittingPackets,
											And[
												MemberQ[Lookup[#,Connectors],{_,TriCloverClamp,None,connection[[4]],connection[[5]],None}],
												MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
											]&
										],
										Object
									]
							]
						],
						filterPrimeConnections
					]
				],
				{Null,Null}
			];

			(* If we are flushing the filter, find the fittings *)
			{
				filterFlushFeedContainerFilterOutletFitting,
				filterFlushFeedContainerDetectorInletFitting
			}=If[
				Lookup[expandedResolvedOptions,FilterFlush]&&experimentTimeValid,
				Module[{filterFlushReservoirPacket,filterFlushConnections},

					(* Prepare a packet for lookups *)
					filterFlushReservoirPacket=fetchPacketFromCache[resolvedFilterFlushBufferContainer,washContainerPackets];

					(* Find the connections for the reservoir and order them *)
					filterFlushConnections={
						SelectFirst[Lookup[filterFlushReservoirPacket,Connectors,{}],First[#]=="Filter Outlet"&],
						SelectFirst[Lookup[filterFlushReservoirPacket,Connectors,{}],First[#]=="Detector Inlet"&]
					};

					(* Resolve the fittings *)
					(* NOTE: There is one Model[Container,Vessel,CrossFlowContainer] that has a luerlock connection for the DiafiltrationBuffer Inlet *)
					(* However, we never utilize that connection for the FilterPrime step, so we don't consider that case here *)
					Map[
						Function[
							connection,
							Which[

								(* If reservoir has tubing, find a barbed fitting *)
								MatchQ[connection[[2]],Tube],
								Lookup[
									SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],{_,Barbed,None,connection[[4]],connection[[5]],None}],
											MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
										]&
									],
									Object
								],

								(* If reservoir has TC clamp, find a TC connector *)
								MatchQ[connection[[2]],TriCloverClamp],
								Lookup[
									SelectFirst[
										fittingPackets,
										And[
											MemberQ[Lookup[#,Connectors],{_,TriCloverClamp,None,connection[[4]],connection[[5]],None}],
											MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
										]&
									],
									Object
								]
							]
						],
						filterFlushConnections
					]
				],
				{Null,Null}
			];

			(* Prepare a system flush packet for lookups *)
			systemFlushContainer=Model[Container,Vessel,CrossFlowWashContainer,"Conical 500mL Tube"];
			systemFlushReservoirPacket=fetchPacketFromCache[systemFlushContainer,washContainerPackets];

			(* Find the connections for the reservoir and order them *)
			systemFlushConnections={
				SelectFirst[Lookup[systemFlushReservoirPacket,Connectors,{}],First[#]=="Filter Outlet"&],
				SelectFirst[Lookup[systemFlushReservoirPacket,Connectors,{}],First[#]=="Detector Inlet"&]
			};

			(* Resolve the fittings for the system flush reservoir *)
			(* NOTE: All of the connections to any Model[Container,Vessel,CrossFlowWashContainer] are all Tube connections - so we always find a barbed fitting *)
			{
				systemFlushFeedContainerFilterOutletFitting,
				systemFlushFeedContainerDetectorInletFitting
			}=Map[
				Function[
					connection,
					SelectFirst[
						fittingPackets,
						And[
							MemberQ[Lookup[#,Connectors],{_,Barbed,None,connection[[4]],connection[[5]],None}],
							MemberQ[Lookup[#,Connectors],{_,QuickDisconnect,None,Null,Null,Male}]
						]&
					]
				],
				systemFlushConnections
			];

			(* Prepare the resources *)
			{
				(*1*) feedPressureSensorToFilterInletFittingResource,
				(*2*) feedPressureSensorToFilterOutletFittingResource,
				(*3*) filterToRetentatePressureSensorInletFittingResource,
				(*4*) filterToRetentatePressureSensorOutletFittingResource,
				(*5*) filterToPermeatePressureSensorOutletFittingResource,
				(*6*) feedContainerFilterOutletFittingResource,
				(*7*) feedContainerDetectorInletFittingResource,
				(*8*) feedContainerDiafiltrationBufferInletFittingResource,
				(*9*) feedContainerToFeedPressureSensorTubingOutletFittingResource,
				(*10*) retentatePressureSensorToConductivitySensorTubingInletFittingResource,
				(*11*) permeatePressureSensorToConductivitySensorTubingInletFittingResource,
				(*12*) feedContainerToFeedPressureSensorTubingInletFittingResource,
				(*13*) retentateConductivitySensorToFeedContainerTubingOutletFittingResource,
				(*14*) diafiltrationBufferContainerToFeedContainerTubingOutletFittingResource,
				(*15*) retentatePressureSensorToConductivitySensorTubingOutletFittingResource,
				(*16*) retentateConductivitySensorToFeedContainerTubingInletFittingResource,
				(*17*) permeatePressureSensorToConductivitySensorTubingOutletFittingResource,
				(*18*) filterPrimeFeedContainerFilterOutletFittingResource,
				(*19*) filterPrimeFeedContainerDetectorInletFittingResource,
				(*20*) filterFlushFeedContainerFilterOutletFittingResource,
				(*21*) filterFlushFeedContainerDetectorInletFittingResource,
				(*22*) systemFlushFeedContainerFilterOutletFittingResource,
				(*23*) systemFlushFeedContainerDetectorInletFittingResource
			}=If[
				NullQ[#],
				Null,
				Resource[
					Sample->#,
					Name->ToString[Unique[]],
					Rent->True
				]
			]&/@{
				(*1*) feedPressureSensorToFilterInletFitting,
				(*2*) feedPressureSensorToFilterOutletFitting,
				(*3*) filterToRetentatePressureSensorInletFitting,
				(*4*) filterToRetentatePressureSensorOutletFitting,
				(*5*) filterToPermeatePressureSensorOutletFitting,
				(*6*) feedContainerFilterOutletFitting,
				(*7*) feedContainerDetectorInletFitting,
				(*8*) feedContainerDiafiltrationBufferInletFitting,
				(*9*) feedContainerToFeedPressureSensorTubingOutletFitting,
				(*10*) retentatePressureSensorToConductivitySensorTubingInletFitting,
				(*11*) permeatePressureSensorToConductivitySensorTubingInletFitting,
				(*12*) feedContainerToFeedPressureSensorTubingInletFitting,
				(*13*) retentateConductivitySensorToFeedContainerTubingOutletFitting,
				(*14*) diafiltrationBufferContainerToFeedContainerTubingOutletFitting,
				(*15*) retentatePressureSensorToConductivitySensorTubingOutletFitting,
				(*16*) retentateConductivitySensorToFeedContainerTubingInletFitting,
				(*17*) permeatePressureSensorToConductivitySensorTubingOutletFitting,
				(*18*) filterPrimeFeedContainerFilterOutletFitting,
				(*19*) filterPrimeFeedContainerDetectorInletFitting,
				(*20*) filterFlushFeedContainerFilterOutletFitting,
				(*21*) filterFlushFeedContainerDetectorInletFitting,
				(*22*) systemFlushFeedContainerFilterOutletFitting,
				(*23*) systemFlushFeedContainerDetectorInletFitting
			};


			(* Collect all fittings, this will help*)
			updatedFittingResources= Flatten[
				{
					(*1*) feedContainerFilterOutletFittingResource,
					(*2*) feedContainerDetectorInletFittingResource,
					(*3*) feedPressureSensorToFilterInletFittingResource,
					(*4*) feedPressureSensorToFilterOutletFittingResource,
					(*5*) filterToRetentatePressureSensorInletFittingResource,
					(*6*) filterToRetentatePressureSensorOutletFittingResource,
					(*7*) filterToPermeatePressureSensorOutletFittingResource,
					(*8*) If[(And@@diafiltrationList),feedContainerDiafiltrationBufferInletFittingResource,Null],
					(*9*) feedContainerToFeedPressureSensorTubingOutletFittingResource,
					(*10*) retentatePressureSensorToConductivitySensorTubingInletFittingResource,
					(*11*) permeatePressureSensorToConductivitySensorTubingInletFittingResource,
					(*12*) feedContainerToFeedPressureSensorTubingInletFittingResource,
					(*13*) retentateConductivitySensorToFeedContainerTubingOutletFittingResource,
					(*14*) If[(And@@diafiltrationList),diafiltrationBufferContainerToFeedContainerTubingOutletFittingResource,Null],
					(*15*) retentatePressureSensorToConductivitySensorTubingOutletFittingResource,
					(*16*) retentateConductivitySensorToFeedContainerTubingInletFittingResource,
					(*17*) permeatePressureSensorToConductivitySensorTubingOutletFittingResource,
					(*18*) filterPrimeFeedContainerFilterOutletFittingResource,
					(*19*) filterPrimeFeedContainerDetectorInletFittingResource,
					(*20*) filterFlushFeedContainerFilterOutletFittingResource,
					(*21*) filterFlushFeedContainerDetectorInletFittingResource,
					(*22*) systemFlushFeedContainerFilterOutletFittingResource,
					(*23*) systemFlushFeedContainerDetectorInletFittingResource
				}
			];

			(* ----- Generate miscellaneous resources ----- *)

			(* Get the output container models *)
			outputContainerModels=Select[newCache,MatchQ[Lookup[#,Type],Model[Container,Vessel]]&];

			(* Separate containers by sterility *)
			sterileContainers=Pick[KeyTake[outputContainerModels,{Object,MaxVolume}],Lookup[outputContainerModels,Sterile,Null],True];
			nonSterileContainers=Join[

				(* Add tubes since they are always sterile *)
				KeyTake[Select[outputContainerModels,Lookup[#,MaxVolume]<=50 Milliliter&],{Object,MaxVolume}],

				(* Non-sterile bottles and carboys *)
				Pick[KeyTake[outputContainerModels,{Object,MaxVolume}],Lookup[outputContainerModels,Sterile,Null],False]
			];

			(* Find the volumes of the largest containers *)
			maxVolumeSterileContainer=Max[Lookup[sterileContainers,MaxVolume]/.Null->Nothing];
			maxVolumeNonSterileContainer=Max[Lookup[nonSterileContainers,MaxVolume]/.Null->Nothing];

			(* Find containers that entire permeate would fit into -- I added 10% slop to the volume to ensure it always fits *)
			temporaryPermeateContainerOut= Which[
				(* If sterile and resolved permeate volume is greater than would fit into one container *)
				sterile&&totalPermeateVolume>=maxVolumeSterileContainer,Module[{numberOfContainersNeeded},

					(* Find how many containers we need *)
					numberOfContainersNeeded=Ceiling[1.1*totalPermeateVolume/maxVolumeSterileContainer];

					(* Find the container with the highest volume and return the required number of it *)
					{Select[sterileContainers,Lookup[#,MaxVolume,0 Milliliter]==maxVolumeSterileContainer&],numberOfContainersNeeded}
				],

				(* If non-sterile and resolved permeate volume is greater than would fit into one container *)
				!sterile&&totalPermeateVolume>=maxVolumeNonSterileContainer,Module[{numberOfContainersNeeded,largestContainer},

					(* Find how many containers we need *)
					numberOfContainersNeeded=Ceiling[1.1*totalPermeateVolume/maxVolumeNonSterileContainer];

					(* Find the container with the highest volume *)
					largestContainer=SelectFirst[nonSterileContainers,Lookup[#,MaxVolume,0 Milliliter]==maxVolumeNonSterileContainer&];

					(* Return the pair *)
					{Lookup[largestContainer,Object,Null],numberOfContainersNeeded}
				],

				(* If sterile, find sterile containers *)
				sterile&&totalPermeateVolume<maxVolumeSterileContainer,PickList[sterileContainers,GreaterEqual[Lookup[#,MaxVolume],totalPermeateVolume*1.1]&/@sterileContainers],

				(* If non-sterile, find non-sterile containers *)
				!sterile&&totalPermeateVolume<maxVolumeNonSterileContainer,PickList[nonSterileContainers,GreaterEqual[Lookup[#,MaxVolume],totalPermeateVolume*1.1]&/@nonSterileContainers]
			];

			(* Generate temporary permeate container resources -- the logic in the procedure is to keep the permeate in the temporary *)
			(* containers if we are transferring the entire volume, so we are also checking if the theoretical and the resolved permeate volumes match. *)
			(* If they do, don't rent the container, as these containers will eventually become the final permeate container. *)
			(* Otherwise, we rent this container, and will transfer the liquid to a different container at the end of the protocol *)
			temporaryPermeateContainerResources=Switch[temporaryPermeateContainerOut,
				(* If our volume fits into multiple containers, return a single one of the first smallest one *)
				{<|__|>..},Module[{smallestContainer},

					smallestContainer=Lookup[
						SelectFirst[temporaryPermeateContainerOut,MatchQ[Lookup[#,MaxVolume],Min[Lookup[temporaryPermeateContainerOut,MaxVolume]]]&],
						Object
					];

					(* Return the resource *)
					If[
						EqualQ[permeateAliquotVolume,totalPermeateVolume],
						Link[Resource[Sample->smallestContainer,Name->ToString[Unique[]]]],
						Link[Resource[Sample->smallestContainer,Name->ToString[Unique[]],Rent->True]]
					]
				],

				(* If our volume is greater than the max of our containers, then we already calculated the right container in temporaryPermeateContainerOut *)
				{ObjectP[Model[Container,Vessel]],_Integer},If[
					EqualQ[permeateAliquotVolume,totalPermeateVolume],
					Link[Resource[Sample->#,Name->ToString[Unique[]]]]&/@ConstantArray[First[temporaryPermeateContainerOut],Last[temporaryPermeateContainerOut]],
					Link[Resource[Sample->#,Name->ToString[Unique[]]],Rent->True]&/@ConstantArray[First[temporaryPermeateContainerOut],Last[temporaryPermeateContainerOut]]
				]
			];

			(* Fake column connector for system flush -- during system flush we remove the column and replace it with this fake column, which is just a T-joint with female LuerLock connectors *)
			systemFlushFakeColumn=Model[Plumbing,Fitting,"3X FLL T Joint"];
			systemFlushFakeColumnFittings={Model[Plumbing,Fitting,"MLL to MLL Fitting for Cross Flow"],Model[Plumbing,Fitting,"MLL to MLL Fitting for Cross Flow"],Model[Plumbing,Fitting,"MLL to MLL Fitting for Cross Flow"]};

			(* Rack for storing fittings during the experiment -- we are using this container so that we don't have a bunch of loose fittings and stickers *)
			fittingRack=Model[Container,Rack,"Tackle Box For Cross Flow Fittings"];

			(* Generate the resources *)
			{
				sampleReservoirResource,
				filterResource,
				permeateContainerResources,
				retentateContainerResource,
				systemFlushBufferResource,
				systemFlushRinseBufferResource,
				systemFlushFakeColumnResource,
				systemFlushFakeColumnFittingResources,
				fittingRackResource
			}={
				Resource[Sample->sampleReservoir,Name->ToString[Unique[]],Rent->True],
				Resource[Sample->crossFlowFilter,Name->ToString[Unique[]]],
				If[NullQ[permeateContainerOut],Null,Resource[Sample->permeateContainerOut,Name->ToString[Unique[]]]],
				If[NullQ[retentateContainerOut],Null,Resource[Sample->retentateContainerOut,Name->ToString[Unique[]]]],
				Resource[Sample->Model[Sample,StockSolution,"0.5M NaOH"],Amount->500 Milliliter,Container->systemFlushContainer,RentContainer->True],
				Resource[Sample->Model[Sample,"Milli-Q water"],Amount->500 Milliliter,Container->Model[Container,Vessel,"1L Glass Bottle"],RentContainer->True],
				Resource[Sample->systemFlushFakeColumn,Name->ToString[Unique[]],Rent->True],
				Resource[Sample->#,Name->ToString[Unique[]],Rent->True]&/@systemFlushFakeColumnFittings,
				Resource[Sample->fittingRack,Name->ToString[Unique[]],Rent->True]
			};


			(* ----- Generate FilterHolder Resource ----- *)

			(* If our filter is a sheet filter, make a resource for the filter holder *)
			filterHolderResource=If[
				MatchQ[Lookup[firstFilterPacket,FilterType],Sheet],
				Resource[
					Sample->Model[Container,Rack,"Sartocon Slice 50 Holder"],
					Name->ToString[Unique[]]
				]
			];

			(* ---------- Generate Rack Resources ---------- *)

			(* Generate the sample reservoir rack resource -- sample reservoir always gets its own rack *)
			sampleReservoirRackResource=If[TrueQ[Lookup[sampleReservoirPacket,SelfStanding]],
				Null,

				Module[{modelOfContainerToUse,crossFlowRackModel},
					(*if sampleReservoirObject is a cross flow container object, get the model*)
					modelOfContainerToUse=If[MatchQ[sampleReservoirPacket,PacketP[Object[Container,Vessel,CrossFlowContainer]]],
						Download[Lookup[sampleReservoirPacket,Model],Object],
						Lookup[sampleReservoirPacket,Object]
					];

					(* choose a rack *)
					crossFlowRackModel=Which[
						(*if modelOfContainerToUse is a 250mL/500mL, give the 250mL/500mL crossflowrack model*)
						Or[
							MatchQ[modelOfContainerToUse,ObjectReferenceP[Model[Container,Vessel,CrossFlowContainer,"id:WNa4ZjKZ07E7"]]],
							MatchQ[modelOfContainerToUse,ObjectReferenceP[Model[Container,Vessel,CrossFlowContainer,"id:n0k9mG8mYZdp"]]]
						],
						Model[Container,Rack,"id:01G6nvwXDYBr"],

						(*if modelOfContainerToUse is a 15/50mL, give the 15/50mL crossflowrack model*)
						True,
						Model[Container,Rack,"id:1ZA60vLqzkBD"]
					];

					(* make resource blob for the rack *)
					Resource[
						Sample->crossFlowRackModel,
						Name->ToString[Unique[]],
						Rent->True]
				]
			];

			(* Prepare a permeate container out packet for lookups *)
			permeateContainerOutObject=Download[temporaryPermeateContainerResources[[1]][[1]][Sample],Object];
			permeateContainerOutPacket=fetchPacketFromCache[permeateContainerOutObject,newCache];

			(* Generate the permeate rack resource -- permeate always gets its own rack if not self-standing *)
			permeateContainerOutRack=If[TrueQ[Lookup[permeateContainerOutPacket,SelfStanding]],
				Null,
				(* check if permeate container out is a crossflow containner *)
				If[MatchQ[permeateContainerOutPacket,PacketP[{Model[Container,Vessel,CrossFlowContainer],Object[Container,Vessel,CrossFlowContainer]}]],
					(* if it is a crossflow container, determine which rack to use based on the model *)
					Module[{permeateContainerOutMaxVolume,model},

						(* get the max volume of the container *)
						permeateContainerOutMaxVolume=If[MatchQ[permeateContainerOutPacket,PacketP[Model[Container,Vessel,CrossFlowContainer]]],
							(* if specified as a model, lookup from packet *)
							Lookup[permeateContainerOutPacket,MaxVolume],

							(* else: lookup MaxVolume from its model packet *)
							(
								model=Lookup[permeateContainerOutPacket,Model];
								Lookup[fetchPacketFromCache[model,newCache],MaxVolume]
							)
						];

						(* return the correct model *)
						Which[
							MatchQ[permeateContainerOutMaxVolume,EqualP[15 Milliliter]|EqualP[50 Milliliter]],
							(* make sure we use the crossflow 15/50mL tube rack *)
							Model[Container,Rack,"id:1ZA60vLqzkBD"],(*15/50 mL CrossFlowContainer Rack*)

							(* if permeateContainerOutPacket[Object] or [Model] is a crossflow container of 250/500mL, give the 250/500mL crossflowrack*)
							MatchQ[permeateContainerOutMaxVolume,EqualP[250 Milliliter]|EqualP[500 Milliliter]],
							Model[Container,Rack,"id:01G6nvwXDYBr"] (*250/500 mL CrossFlowContainer Rack*)
						]
					],

					(* else: call RackFinder to determine the rack *)
					RackFinder[Lookup[permeateContainerOutPacket,Object]]
				]
			];

			(* create unique resource lookup for permeate container racks *)
			permeateContainerRackResourceLookup=If[NullQ[permeateContainerOutRack],
				Lookup[permeateContainerOutPacket,Object]->Null,
				Lookup[permeateContainerOutPacket,Object]->Resource[Sample->permeateContainerOutRack,Name->ToString[Unique[]],Rent->True]
			];

			(* Get the wash reservoirs we will use in the protocol -- the rinse containers are exactly the same as the prime or flush, so we only need each one once for the purposes of finding a rack *)
			protocolWashReservoirs={
				If[
					Lookup[expandedResolvedOptions,FilterPrime],
					resolvedFilterPrimeBufferContainer,
					Null
				],
				If[
					Lookup[expandedResolvedOptions,FilterFlush],
					resolvedFilterFlushBufferContainer,
					Null
				],
				systemFlushContainer
			};

			(* Fetch the packets for the reservoirs we have for washes -- these steps will share racks as much as possible *)
			protocolWashReservoirPackets=fetchPacketFromCache[#,washContainerPackets]&/@protocolWashReservoirs;

			(* Find the unique non self standing reservoirs, for which we need a rack -- this code has some trickery in it. Any Nulls in the packets will get removed because we are converting them to empty associations with True default condition in the lookup. This is necessary because we need to always have three elements in the final rack resources list. The field is an indexed single and the three parts of it are hardcoded into the procedure *)
			nonSelfStandingWashReservoirPackets=PickList[
				DeleteDuplicates[protocolWashReservoirPackets],
				Lookup[DeleteDuplicates[protocolWashReservoirPackets]/.Null-><||>,SelfStanding,True],
				Except[True]
			];

			(* Prepare resources for each of the unique racks we need *)
			(* note: WashReservoir can only be Model[Container,Vessel,CrossFlowContainer] *)
			uniqueWashReservoirResources=Function[modelPacket,
				Module[{rackModel},
					(* get rack model based on max volume of the crossflow container *)
					rackModel=Which[
						MatchQ[Lookup[modelPacket,MaxVolume],EqualP[15 Milliliter]|EqualP[50 Milliliter]],
						(* make sure we use the crossflow 15/50mL tube rack *)
						Model[Container,Rack,"id:1ZA60vLqzkBD"],(*15/50 mL CrossFlowContainer Rack *)

						(* if it is a crossflow container of 250/500mL, give the 250/500mL crossflowrack *)
						MatchQ[Lookup[modelPacket,MaxVolume],EqualP[250 Milliliter]|EqualP[500 Milliliter]],
						Model[Container,Rack,"id:01G6nvwXDYBr"] (*250/500 mL CrossFlowContainer Rack*)
					];

					(* return the resource blob *)
					Resource[
						Sample->rackModel,
						Name->ToString[Unique[]],
						Rent->True
					]
				]
			]/@nonSelfStandingWashReservoirPackets;

			(* Create a list of rack resources for all wash reservoirs *)
			allWashRackResources=protocolWashReservoirPackets/.Thread[nonSelfStandingWashReservoirPackets->uniqueWashReservoirResources];

			(* ----- Generate WasteContainer resource ----- *)

			(* Find the max volume we will need to put into the container *)
			wasteContainerVolume=Max[

				(* If we are doing filter rinse, check filter rinse volume *)
				If[
					Lookup[expandedResolvedOptions,FilterPrime],
					resolvedFilterPrimeVolume,
					0 Milliliter
				],

				(* If we are doing filter flush, check filter flush volume *)
				If[
					Lookup[expandedResolvedOptions,FilterFlush],
					resolvedFilterFlushVolume,
					0 Milliliter
				],

				(* System flush volume is always 500 Milliliter *)
				500 Milliliter
			];

			(* Find all the containers that our waste would fit in -- with 20% slop *)
			wasteFitsInContainer=PickList[wasteContainerPackets,GreaterEqual[Lookup[#,MaxVolume],wasteContainerVolume*1.2]&/@wasteContainerPackets];

			(* Find the first smallest container the volume fits in *)
			resolvedWasteContainer=Lookup[
				SelectFirst[wasteContainerPackets,MatchQ[Lookup[#,MaxVolume],Min[Lookup[wasteFitsInContainer,MaxVolume]]]&],
				Object
			];

			(* Create the resource *)
			wasteContainerResource=Resource[Sample->resolvedWasteContainer,Name->ToString[Unique[]],Rent->True];

			(* ---------- Find Storage Conditions ---------- *)

			(* Find the sample storage condition model *)
			sampleStorageConditionModels=FirstOrDefault[Download[Lookup[firstSamplePacket,StorageCondition,Null],Object]];

			(* Look up the storage condition expression from the storage condition packet *)
			sampleStorageConditionExpression=If[
				MatchQ[sampleStorageConditionModels,ObjectP[Model[StorageCondition]]],
				Download[sampleStorageConditionModels,StorageCondition],
				Refrigerator
			];

			(* Resolve the storage condition for the sample *)
			sampleStorageCondition=If[
				MatchQ[Lookup[firstSamplePacket,StorageCondition,Null],LinkP[Model[StorageCondition]]],
				{sampleStorageConditionExpression},
				{Refrigerator}
			];

			(* ---------- Calculate the permeateWeightAlarm and retentateWeightAlarm ---------- *)
			(* we don't need to worry about the permeateWeightAlarm since the software does that automatically. we will uyse this to set a weight alarm in the permeate to make sure nothing overflows *)
			permeateWeightAlarm=Round[Total[Flatten[{concentrationPermeateWeightsByStep,diafiltrationWeight}/.Null->0Gram]]];

			(* retentate weight alarm should go off if we're losing more weight than expected sample volume*diafiltration density - concentration targets * density. don't forget to take dead volumes into account! *)
			retentateWeightAlarm=Round[sampleInVolume*(diafiltrationBufferDensities[[1]] /. Null->solventDensity) - (Total[concentrationPermeateWeightsByStep]) - KR2iDeadVolume*(diafiltrationBufferDensities[[1]]/. Null->solventDensity),10^-1];

			(* ---------- Helper function for getting fitting image files ---------- *)

			(* TODO: This is a temp fix to display image file of fittings model in engine. There's a download bug that prevents us from traversing indexed single fields like Fittings, so we store index matching image files for the fitting models in a separate field for now *)
			getFittingImages[fittingResourceBlobs:Null|{(_Resource|Null)..},packets:{PacketP[]..}]:=If[
				NullQ[#],
				Null,
				Lookup[fetchPacketFromCache[#[Sample],packets],ImageFile]
			]&/@fittingResourceBlobs;

			allFittingImages=Link/@(getFittingImages[updatedFittingResources,fittingPackets]);

			(* Do some sanitizations for diafiltration targets and volumes *)
			sanitiezedConcentrationTargets=calculateConcentrationTargets[concentrationPermeateVolumesByStep, sampleInVolume];

			sanitizedPrimaryTarget= If[MatchQ[primaryConcentrationTarget, UnitsP[1]],
				primaryConcentrationTarget,
				First[sanitiezedConcentrationTargets]
			];

			sanitizedSecondaryTarget= If[MatchQ[secondaryConcentrationTarget, UnitsP[1]],
				secondaryConcentrationTarget,
				LastOrDefault[sanitiezedConcentrationTargets]
			];
			(* Sanitized primary target *)
			sanitizedDiafiltrationTarget = If[
				And@@diafiltrationList,
				If[MatchQ[diafiltrationTarget, UnitsP[1]], diafiltrationTarget, calculateDiafiltrationTargetReal[sampleInVolume, diafiltrationVolume, sanitizedPrimaryTarget]],
				Null
			];

			(* Generate the coupling ring resources: The object in all the below fields is Model[Part, Clamp, "1 Inch Tri Clover Clamp for Cross Flow"] *)
			(* NOTE: This field is index matching to FilterConnections - so if that changes in the compiler, this needs to change as well *)
			filterConnectionsCouplingRingResources = If[xamplerFilterQ,
				{
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True],
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True],
					Null,
					Null
				},
				{Null,Null,Null}
			];

			(* Generate filter tube clamp resources "Constant-Tension Single Zinc-Plate Steel Spring for 7/16\" OD Tubing" *)
			(* Generate a plier resource to help install the tube clamps. *)
			(* NOTE: This field is index matching to FilterConnections - so if that changes in the compiler, this needs to change as well *)
			{filterConnectionTubingClamps, tubeClampPliersResource} = If[xamplerFilterQ,
				(*For Xampler filters use: *)
				{
					{
						Null,
						Null,
						Resource[Sample -> Model[Item, Clamp, "id:E8zoYvOopMDX"], Amount -> 2, Name -> "Filter Clamps"],
						Resource[Sample -> Model[Item, Clamp, "id:E8zoYvOopMDX"], Amount -> 2, Name -> "Filter Clamps"]
					},
					Resource[Sample -> Model[Item, "id:n0k9mGOoWvn3"], Name -> "Spring Clamp Pliers"]
				},
				(* Otherwise we have TC or luer fittings and do not need clamps. *)
				{
					{Null, Null, Null},
					Null
				}
			];

			(* NOTE: This field is index matching to FeedContainerFittingConnections - so if that changes in the compiler, this needs to change as well *)
			feedContainerFittingConnectionsCouplingRingResources = If[MatchQ[Lookup[sampleReservoirPacket,Object],ObjectP[Model[Container, Vessel, CrossFlowContainer, "id:Z1lqpMzp07PM"]]], (* Model[Container, Vessel, CrossFlowContainer, "Flat Bottom 2L Bottle"] *)
				{
					Null,
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True],
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True]
				},
				{Null,Null,Null}
			];

			(* NOTE: This field is index matching to filterPrimeFittingConnections - so if that changes in the compiler, this needs to change as well *)
			filterPrimeFittingConnectionsCouplingRingResources = If[MatchQ[resolvedFilterPrimeBufferContainer,ObjectP[Model[Container, Vessel, CrossFlowContainer, "id:Z1lqpMzp07PM"]]], (* Model[Container, Vessel, CrossFlowContainer, "Flat Bottom 2L Bottle"] *)
				{
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True],
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True]
				},
				{Null,Null}
			];

			(* NOTE: This field is index matching to filterFlushFittingConnections - so if that changes in the compiler, this needs to change as well *)
			filterFlushFittingConnectionsCouplingRingResources = If[MatchQ[resolvedFilterFlushBufferContainer,ObjectP[Model[Container, Vessel, CrossFlowContainer, "id:Z1lqpMzp07PM"]]], (* Model[Container, Vessel, CrossFlowContainer, "Flat Bottom 2L Bottle"] *)
				{
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True],
					Resource[Sample->Model[Part, Clamp, "id:J8AY5jA8belb"],Name->CreateUUID[],Rent->True]
				},
				{Null,Null}
			];

			(* ---------- Prepare the Packets ---------- *)

			(* Collapse options and remove hidden ones *)
			resolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentCrossFlowFiltration,expandedResolvedOptions];

			(* ----- Make the protocol packet ----- *)
			<|
				(* Organizational information *)
				Object->CreateID[Object[Protocol,CrossFlowFiltration]],
				Type->Object[Protocol,CrossFlowFiltration],
				Name->Lookup[resolvedOptionsNoHidden,Name],
				Template->Link[Lookup[resolvedOptionsNoHidden,Template],ProtocolsTemplated],

				(* Options handling *)
				UnresolvedOptions->myUnresolvedOptions,
				ResolvedOptions->resolvedOptionsNoHidden,

				(* Checkpoints *)
				Replace[Checkpoints]->{
					{"Preparing Samples",10 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]},
					{"Instrument Setup",120 Minute,"Plumbing and sample are connected instrument and software setup is performed.",Link[Resource[Operator->$BaselineOperator,Time->120 Minute]]},
					{"Filtration",experimentRunTime,"Sample is filtered.",Link[Resource[Operator->$BaselineOperator,Time->experimentRunTime]]},
					{"Instrument Teardown",120 Minute,"Sample is removed from the instrument and instrument is returned to a ready state for the next user.",Link[Resource[Operator->$BaselineOperator,Time->120 Minute]]}
				},

				(* Storage *)
				Replace[SamplesInStorage]->sampleStorageCondition,
				Replace[RetentateStorageConditions]->FirstOrDefault[Lookup[expandedResolvedOptions,RetentateStorageCondition]],
				Replace[PermeateStorageConditions]->FirstOrDefault[Lookup[expandedResolvedOptions,PermeateStorageCondition]],
				Replace[FilterStorageConditions]->FirstOrDefault[Lookup[expandedResolvedOptions,FilterStorageCondition]],

				(*CrossFlowFilters,*)
				(* new multiple fields *)
				Replace[SampleInVolumes]->Lookup[resolvedOptionsNoHidden,SampleInVolume],
				Replace[SampleReservoirs]-> ToList[Link[sampleReservoirResource]],
				Replace[CrossFlowFilters]->ToList[Link[filterResource]],
				Replace[DiafiltrationTargets]->ToList[sanitizedDiafiltrationTarget],
				Replace[PrimaryConcentrationTargets]->ToList[sanitizedPrimaryTarget],
				Replace[SecondaryConcentrationTargets]->ToList[sanitizedSecondaryTarget],
				Replace[DiafiltrationBufferWeights]->ToList[diafiltrationWeight],
				Replace[PrimaryConcentrationWeights]->ToList[First[concentrationPermeateWeightsByStep]],
				Replace[SecondaryConcentrationWeights]->ToList[LastOrDefault[concentrationPermeateWeightsByStep]],
				Replace[RetentateAliquotVolumes]->ToList[Lookup[resolvedOptionsNoHidden,RetentateAliquotVolume]],
				Replace[PermeateAliquotVolumes]->ToList[Lookup[resolvedOptionsNoHidden,PermeateAliquotVolume]],
				Replace[FiltrationModes]->Lookup[resolvedOptionsNoHidden,FiltrationMode],
				Replace[TransmembranePressureTargets]->Lookup[resolvedOptionsNoHidden,TransmembranePressureTarget],
				Replace[PrimaryPumpFlowRates]->Lookup[resolvedOptionsNoHidden,PrimaryPumpFlowRate],

				(* Experiment options without resources *)
				Sterile->Lookup[resolvedOptionsNoHidden,Sterile],
				FilterPrime->Lookup[resolvedOptionsNoHidden,FilterPrime],
				FilterPrimeVolume->Lookup[resolvedOptionsNoHidden,FilterPrimeVolume],
				FilterPrimeRinse->Lookup[resolvedOptionsNoHidden,FilterPrimeRinse],
				FilterPrimeTransmembranePressureTarget->Lookup[resolvedOptionsNoHidden,FilterPrimeTransmembranePressureTarget],
				FilterPrimeFlowRate->Lookup[resolvedOptionsNoHidden,FilterPrimeFlowRate],
				FilterFlush->Lookup[resolvedOptionsNoHidden,FilterFlush],
				FilterFlushVolume->Lookup[resolvedOptionsNoHidden,FilterFlushVolume],
				FilterFlushRinse->Lookup[resolvedOptionsNoHidden,FilterFlushRinse],
				FilterFlushTransmembranePressureTarget->Lookup[resolvedOptionsNoHidden,FilterFlushTransmembranePressureTarget],
				FilterFlushFlowRate->Lookup[resolvedOptionsNoHidden,FilterFlushFlowRate],
				(* Experiment options with resources *)
				Replace[SamplesIn]->(Link[#,Protocols]&)/@samplesInResources,
				Replace[ContainersIn]->(Link[#,Protocols]&)/@containersInResource,
				SampleReservoirRack->Link[sampleReservoirRackResource],
				FilterHolder->Link[filterHolderResource],
				Replace[FilterPrimeBuffers]->ToList[Link[filterPrimeBufferResource]],
				Replace[FilterPrimeContainers]->ToList[Link[filterPrimeBufferContainerResource]],
				Replace[FilterPrimeRinseBuffers]->ToList[Link[filterPrimeRinseResource]],
				Replace[FilterPrimeRinseContainers]->ToList[Link[filterPrimeRinseContainerResource]],
				Replace[PermeateContainersOut]->ToList[Link[permeateContainerResources]],
				Replace[DiafiltrationBuffers]->ToList[diafiltrationBufferResources],
				Replace[RetentateContainersOut]-> ToList[Link[retentateContainerResource]],
				Instrument->Link[instrumentResource],
				Replace[FilterFlushBuffers]->ToList[Link[filterFlushBufferResource]],
				Replace[FilterFlushContainers]->ToList[Link[filterFlushBufferContainerResource]],
				Replace[FilterFlushRinseBuffers]->ToList[Link[filterFlushRinseResource]],
				Replace[FilterFlushRinseContainers]->ToList[Link[filterFlushRinseContainerResource]],
				SystemFlushBuffer->Link[systemFlushBufferResource],
				SystemFlushRinseBuffer->Link[systemFlushRinseBufferResource],
				Replace[WashReservoirRacks]->(Link/@allWashRackResources),
				WasteContainer->Link[wasteContainerResource],
				TemporaryPermeateContainerOut->temporaryPermeateContainerResources,
				TemporaryPermeateContainerRack->Link@(permeateContainerOutObject/.permeateContainerRackResourceLookup),
				TheoreticalPermeateVolume->totalPermeateVolume,

				(* Parent Tubing *)

				DiafiltrationParentTubing->Link[diafiltrationTubingResource],
				PermeateParentTubing->Link[permeateTubingResource],
				RetentateParentTubing->Link[retentateTubingResource],
				ConductivitySensorsParentTubing->Link[conductivitySensorTubingResource],
				FilterTubingParentTubing->Link[filterToPermeatePressureSensorParentTubingResource],

				(* all fittings *)
				FeedPressureSensorToFilterInletFitting->Link[feedPressureSensorToFilterInletFittingResource],
				FeedPressureSensorToFilterOutletFitting->Link[feedPressureSensorToFilterOutletFittingResource],
				FilterToRetentatePressureSensorInletFitting->Link[filterToRetentatePressureSensorInletFittingResource],
				FilterToRetentatePressureSensorOutletFitting->Link[filterToRetentatePressureSensorOutletFittingResource],
				FilterToPermeatePressureSensorOutletFitting->Link[filterToPermeatePressureSensorOutletFittingResource],
				FeedContainerFilterOutletFitting->Link[feedContainerFilterOutletFittingResource],
				FeedContainerDetectorInletFitting->Link[feedContainerDetectorInletFittingResource],
				FeedContainerDiafiltrationBufferInletFitting->If[(And@@diafiltrationList),Link[feedContainerDiafiltrationBufferInletFittingResource],Null],
				FeedContainerToFeedPressureSensorTubingOutletFitting->Link[feedContainerToFeedPressureSensorTubingOutletFittingResource],
				RetentatePressureSensorToConductivitySensorTubingInletFitting->Link[retentatePressureSensorToConductivitySensorTubingInletFittingResource],
				PermeatePressureSensorToConductivitySensorTubingInletFitting->Link[permeatePressureSensorToConductivitySensorTubingInletFittingResource],
				FeedContainerToFeedPressureSensorTubingInletFitting->Link[feedContainerToFeedPressureSensorTubingInletFittingResource],
				RetentateConductivitySensorToFeedContainerTubingOutletFitting->Link[retentateConductivitySensorToFeedContainerTubingOutletFittingResource],
				DiafiltrationBufferContainerToFeedContainerTubingOutletFitting->If[(And@@diafiltrationList),Link[diafiltrationBufferContainerToFeedContainerTubingOutletFittingResource],Null],
				RetentatePressureSensorToConductivitySensorTubingOutletFitting->Link[retentatePressureSensorToConductivitySensorTubingOutletFittingResource],
				RetentateConductivitySensorToFeedContainerTubingInletFitting->Link[retentateConductivitySensorToFeedContainerTubingInletFittingResource],
				PermeatePressureSensorToConductivitySensorTubingOutletFitting->Link[permeatePressureSensorToConductivitySensorTubingOutletFittingResource],

				(* FilterPrimeFittings *)
				FilterPrimeFeedContainerFilterOutletFitting->Link[filterPrimeFeedContainerFilterOutletFittingResource],
				FilterPrimeFeedContainerDetectorInletFitting->Link[filterPrimeFeedContainerDetectorInletFittingResource],

				(* Filter Flush *)
				FilterFlushFeedContainerFilterOutletFitting->Link[filterFlushFeedContainerFilterOutletFittingResource],
				FilterFlushFeedContainerDetectorInletFitting->Link[filterFlushFeedContainerDetectorInletFittingResource],

				(* System Flush *)
				SystemFlushFeedContainerFilterOutletFitting->Link[systemFlushFeedContainerFilterOutletFittingResource],
				SystemFlushFeedContainerDetectorInletFitting->Link[systemFlushFeedContainerDetectorInletFittingResource],

				(* Coupling Ring / Tube Clamp Resources *)
				Replace[FilterConnectionsCouplingRings] -> Link/@filterConnectionsCouplingRingResources,
				Replace[FilterConnectionsTubeClamps] -> Link/@filterConnectionTubingClamps,
				TubeClampPliers -> Link[tubeClampPliersResource],
				Replace[FeedContainerFittingConnectionsCouplingRings] -> Link/@feedContainerFittingConnectionsCouplingRingResources,
				Replace[FilterPrimeFittingConnectionsCouplingRings] -> Link/@filterPrimeFittingConnectionsCouplingRingResources,
				Replace[FilterFlushFittingConnectionsCouplingRings]-> Link/@filterFlushFittingConnectionsCouplingRingResources,

				(* All tubings *)
				DiafiltrationBufferContainerToFeedContainerTubing->If[(And@@diafiltrationList), Link[Lookup[diafiltrationBufferContainerToFeedContainerTubingPacket, Object]], Null],
				FeedContainerToFeedPressureSensorTubing->Link[Lookup[feedContainerToFeedPressureSensorTubingPacket, Object]],
				RetentateConductivitySensorToFeedContainerTubing->Link[Lookup[retentateConductivitySensorToFeedContainerTubingPacket, Object]],
				RetentateConductivitySensorInletTubing->Link[Lookup[retentateConductivitySensorInletTubingPacket, Object]],
				RetentateConductivitySensorOutletTubing->Link[Lookup[retentateConductivitySensorOutletTubingPacket, Object]],
				PermeateConductivitySensorInletTubing->Link[Lookup[permeateConductivitySensorInletTubingPacket, Object]],
				PermeateConductivitySensorOutletTubing->Link[Lookup[permeateConductivitySensorOutletTubingPacket, Object]],
				RetentatePressureSensorToConductivitySensorTubing->Link[Lookup[retentatePressureSensorToConductivitySensorTubingPacket, Object]],
				PermeatePressureSensorToConductivitySensorTubing->Link[Lookup[permeatePressureSensorToConductivitySensorTubingPacket, Object]],
				FilterToPermeatePressureSensorTubing->Link[If[NullQ[filterToPermeatePressureSensorTubingPacket],filterToPermeatePressureSensorTubingPacket,Lookup[filterToPermeatePressureSensorTubingPacket, Object]]],
				AuxiliaryPermeateTubing -> Link[If[NullQ[filterAuxiliaryPermeateTubingPacket], filterAuxiliaryPermeateTubingPacket, Lookup[filterAuxiliaryPermeateTubingPacket, Object]]],
				(* If we require AuxiliaryPermeateTubing we will need to clamp it: *)
				AuxiliaryPermeateSiphonClamp -> If[NullQ[filterAuxiliaryPermeateTubingPacket], Null, Link[Resource[Sample -> Model[Item, Clamp, "id:dORYzZdZL1d5"(*"Pinch Clamp, Ratchet-Style, 1.5\" Long"*)], Name -> "Auxiliary Permeate Tubing Clamp"]]],
				FilterToRetentatePressureSensorTubing->Link[If[NullQ[filterToRetentatePressureSensorTubingPacket],filterToRetentatePressureSensorTubingPacket,Lookup[filterToRetentatePressureSensorTubingPacket, Object]]],
				FeedPressureSensorToFilterTubing->Link[If[NullQ[feedPressureSensorToFilterTubingPacket],feedPressureSensorToFilterTubingPacket,Lookup[feedPressureSensorToFilterTubingPacket, Object]]],

				Replace[AllFittings]->(Link[#]&/@updatedFittingResources),
				Replace[FittingImageFiles]->allFittingImages,
				FittingRack->Link[fittingRackResource],

				RetentateHoldupVolume->UnitConvert[KR2iDeadVolume,Milliliter],
				PermeateHoldupVolume->If[Lookup[resolvedOptionsNoHidden,FilterPrime],UnitConvert[systemPermeateVolume,Milliliter],0Milliliter],

				(* Miscellaneous *)
				PrimaryCableLabelSticker->Link[Resource[Sample -> Model[Item, Consumable, "id:Y0lXejMmXOo1"]]], (* Model[Item, Consumable, "Cabel Label Sticker Tag for stickering small objects"] *)
				SecondaryCableLabelSticker->Link[Resource[Sample -> Model[Item, Consumable, "id:Y0lXejMmXOo1"]]], (* Model[Item, Consumable, "Cabel Label Sticker Tag for stickering small objects"] *)
				ExperimentalRunTime->experimentRunTime,
				ExperimentalFirstCheckInTime->frequentCheckInTime,
				FilterPrimeRunTime->(totalFilterPrimeRunTime/.{0 Minute->Null}),
				FilterFlushRunTime->(totalFilterFlushRunTime/.{0 Minute->Null}),
				Replace[ScaleAlarms]->{permeateWeightAlarm, If[retentateWeightAlarm>0Gram, retentateWeightAlarm, 0.1Gram]}, (* its not a great indication if the dead volume is larger than the leftover volume.. but if it is, don't set alarms. if this matters for the filter, we raise a warning *)
				SystemFlushFilterPlaceholder->Link[systemFlushFakeColumnResource],
				SystemFlushFilterPlaceholderFittings->(Link[#]&/@systemFlushFakeColumnFittingResources),
				Replace[SystemFlushFilterPlaceholderFittingImages]->Link[getFittingImages[systemFlushFakeColumnFittingResources,fittingPackets]],
				OtherDataAcquisitionFrequency -> 15 Second
			|>

		]
	];

	(* Make a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[ToList[expandedInputs], expandedResolvedOptions, Cache -> cache, Simulation -> simulation];

	(* Merge the specific fields with the shared fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* ----- Check resources ----- *)

	(* Gather all the resource symbolic representations -- infinite depth is necessary to grab the resources from inside the heads *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* Check if the resources can be fulfilled *)
	{fulfillable,frqTests}=Which[

		(* If on engine, return True *)
		MatchQ[$ECLApplication,Engine],{True,{}},

		(* If gathering tests, return the tests *)
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[expandedResolvedOptions,FastTrack],Site->Lookup[expandedResolvedOptions,Site],Cache->newCache,Simulation->simulation],

		(* Otherwise, return without tests *)
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[expandedResolvedOptions,FastTrack],Site->Lookup[expandedResolvedOptions,Site],Messages->messages,Cache->newCache,Simulation->simulation],{}}
	];

	(* ---------- Return The Packets ---------- *)

	(* Generate the preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[
		MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the result output rule -- if not returning result, or the resources are not fulfillable, return $Failed *)
	resultRule=Result->If[
		MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* Generate the tests output rule *)
	testsRule=Tests->If[
		gatherTests,
		frqTests,
		{}
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* ::Subsection::Closed:: *)
(*ExperimentCrossFlowFiltration Simulation*)

DefineOptions[
	simulateExperimentCrossFlowFiltration,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentCrossFlowFiltration[
	myProtocolPacket:(PacketP[Object[Protocol, CrossFlowFiltration], {Object, ResolvedOptions}]|$Failed),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentCrossFlowFiltration]
]:=Module[
	{
		cache,simulation,samplePackets,protocolObject,currentSimulation,simulationWithLabels,
		simulatedProtocolPackets, simulatedPermeatedContainers, simulatedRetentateContainers,
		simulatedDiafiltrationBuffers, sampleTransferSimulation, filtrationModes,
		primaryConcentrationTargets, secondaryConcentrationTargets, sampleInVolumes,
		diafiltrationTargets, newCache, fastCacheBall, diafiltrationBuffers,
		diafiltrationBufferDensities, currentSampleVolumes, retentateTransferVolumes,
		permeateContainersOutContents, retentateContainersOutContents, permeateSamples,
		retentateSamples
	},
	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[Object[Protocol,CrossFlowFiltration]],
		True,
		Lookup[myProtocolPacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation=If[

		(* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateResources[
			<|
				Object->protocolObject,

				(* Fake resources*)
				Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,

				Instrument->Resource[Sample->Lookup[myResolvedOptions,Instrument],Time->60Minute],
				Replace[CrossFlowFilters] -> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,CrossFlowFilter]),
				Replace[PermeateContainersOut]-> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,PermeateContainerOut]),
				Replace[RetentateContainersOut]-> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,RetentateContainerOut]),
				Replace[DiafiltrationBuffers]-> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,DiafiltrationBuffer]),
				Replace[FilterPrimeBuffers]-> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,FilterPrimeBuffer]),
				Replace[FilterPrimeRinseBuffers]-> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,FilterPrimeRinseBuffer]),
				Replace[FilterFlushBuffers]-> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,FilterFlushBuffer]),
				Replace[FilterFlushRinseBuffers]-> ((Resource[Sample->#])&/@Lookup[myResolvedOptions,FilterFlushRinseBuffer]),

				(* Resource Options *)
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
		],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, CrossFlowFiltration]. *)
		SimulateResources[myProtocolPacket, Null, Cache->cache, Simulation->simulation]
	];

	(* Update simulation *)
	currentSimulation=UpdateSimulation[simulation, currentSimulation];

	(* Download containers from our sample packets. *)
	{
		simulatedProtocolPackets,
		samplePackets
	}=Download[
		{
			ToList[protocolObject],
			mySamples
		},
		{
			{
				Packet[
					PermeateContainersOut,
					RetentateContainersOut,
					FiltrationModes,
					PrimaryConcentrationTargets,
					SecondaryConcentrationTargets,
					DiafiltrationTargets,
					SampleInVolumes,
					DiafiltrationBuffers,
					PermeateAliquotVolumes,
					RetentateAliquotVolumes
				],
				Packet[
					DiafiltrationBuffers[
						{Density}
					]
				]
			},
			{
				Packet[Container]
			}
		},
		Cache->cache,
		Simulation->currentSimulation
	];

	(* Sanitize the packets *)
	samplePackets = Flatten[samplePackets,1];
	(* Download information we need in both the Options and ResourcePackets functions *)
	newCache = FlattenCachePackets[{cache, simulatedProtocolPackets}];

	(* Get the fast cache ball *)
	fastCacheBall = makeFastAssocFromCache[newCache];

	(* More simulations *)
	sampleTransferSimulation= Module[
		{
			sampleDensities, sampleModelDensities, sampleSolvents, solventDensity,
			diaFiltrationToRetentateTransferVolumes, sanitizedDiafiltrationBufferDensities,
			concentrationTargetTuples, retentateToPermeateTransferVolumes,
			diafiltrationTransferSimulation, permeateAliquotVolumes, totalPermeatedVolume,
			calculatedVolume, retentateToPermeateTransferSimulation, retentateAliquotVolumes
		},

		(* Get all information   *)
		{
			simulatedPermeatedContainers,
			simulatedRetentateContainers,
			simulatedDiafiltrationBuffers,
			filtrationModes,
			primaryConcentrationTargets,
			secondaryConcentrationTargets,
			diafiltrationTargets,
			diafiltrationBuffers,
			sampleInVolumes,
			permeateAliquotVolumes,
			retentateAliquotVolumes
		} = ToList/@Lookup[
			FirstOrDefault[Flatten[simulatedProtocolPackets]],
			{
				PermeateContainersOut,
				RetentateContainersOut,
				DiafiltrationBuffers,
				FiltrationModes,
				PrimaryConcentrationTargets,
				SecondaryConcentrationTargets,
				DiafiltrationTargets,
				DiafiltrationBuffers,
				SampleInVolumes,
				PermeateAliquotVolumes,
				RetentateAliquotVolumes
			}
		];

		(* Get samples' information *)
		sampleDensities = fastAssocLookup[fastCacheBall, #, Density]&/@mySamples;
		sampleModelDensities = fastAssocLookup[fastCacheBall, #, Density]&/@mySamples;
		sampleSolvents = Download[(fastAssocLookup[fastCacheBall, #, Solvent]&/@mySamples), Object];
		diafiltrationBufferDensities=fastAssocLookup[fastCacheBall, #, Density]&/@diafiltrationBuffers;
		(* First we get the density of the sample*)
		solventDensity=MapThread[
			Function[
				{
					sampleDensity,
					sampleModelDensity,
					sampleSolvent
				},
				Which[

					(* If sample has density, use it *)
					MatchQ[sampleDensity,UnitsP[Gram/Milliliter]],sampleDensity,

					(* If sample's model has density, use it *)
					MatchQ[sampleModelDensity,UnitsP[Gram/Milliliter]],sampleModelDensity,

					(* If we found a solvent, use that *)
					MatchQ[sampleSolvent, ObjectReferenceP[]],fastAssocLookup[fastCacheBall, sampleSolvent, Solvent],

					(* Otherwise, we couldn't find a solvent so return 1 g/mL with a warning *)
					True,0.997 Gram/Milliliter
				]
			],
			{
				sampleDensities,
				sampleModelDensities,
				sampleSolvents
			}
		];

		(* First let's sanitize the diafiltration buffer densities to remove Nulls*)
		sanitizedDiafiltrationBufferDensities = If[
			MatchQ[#, UnitsP[Gram/Milliliter]],
			#,
			0.997 Gram/Milliliter
		]&/@diafiltrationBufferDensities;

		(* Calculate how much we will need to transfer to the  *)
		retentateToPermeateTransferVolumes=MapThread[
			Function[
				{
					sampleInVolume,
					primaryConcentrationTarget,
					secondaryConcentrationTarget,
					solventDensity,
					diafiltrationBufferDensity,
					permeateAliquotVolume
				},

				(* Make a list of all targets for concentration steps -- diafiltration is omitted since it does not change the retentate volume *)
				concentrationTargetTuples={primaryConcentrationTarget,secondaryConcentrationTarget};

				(* Convert all to volume and add them up to find the total permeate volume for concentration steps (assume water is the diafiltration buffer for the second concentration) *)
				totalPermeatedVolume=Total[Experiment`Private`calculatePermeateTargetToVolume[concentrationTargetTuples,sampleInVolume,solventDensity,diafiltrationBufferDensity]];

				(* Check if total volume is larger than aliquot volume or not *)
				If[
					MatchQ[permeateAliquotVolume,All],
					totalPermeatedVolume,
					Min[totalPermeatedVolume, permeateAliquotVolume]
				]
			],
			{
				sampleInVolumes,
				primaryConcentrationTargets,
				secondaryConcentrationTargets,
				solventDensity,
				sanitizedDiafiltrationBufferDensities,
				permeateAliquotVolumes
			}
		];

		(* Now we calculate how many volume we have to transfer from DiafiltrationBuffer to Container*)
		diaFiltrationToRetentateTransferVolumes=MapThread[
			Function[
				{
					filtrationMode,
					primaryConcentrationTarget,
					diafiltrationTarget,
					sampleInVolume,
					solventDensity,
					permeateAliquotVolume,
					retentateToPermeateTransferVolume
				},
				calculatedVolume=If[
					MatchQ[filtrationMode, Alternatives[ConcentrationDiafiltrationConcentration,ConcentrationDiafiltration,Diafiltration]],
					Which[
						(* If target is specified as fold sample volume, multiply target by sample volume *)
						MatchQ[diafiltrationTarget,UnitsP[1]],(sampleInVolume/primaryConcentrationTarget/. Null->1)*diafiltrationTarget,

						(* If target is specified as volume, return volume as is *)
						MatchQ[diafiltrationTarget,UnitsP[1 Liter]],diafiltrationTarget,

						(* If target is specified as weight, convert to volume *)
						MatchQ[diafiltrationTarget,UnitsP[1 Gram]],Floor[UnitConvert[diafiltrationTarget/solventDensity,Milliliter]],

						(* in case its null *)
						True, 0 Milliliter
					],
					0 Milliliter
				];
				If[
					MatchQ[permeateAliquotVolume,All],
					calculatedVolume,
					Max[Min[permeateAliquotVolume - retentateToPermeateTransferVolume, calculatedVolume],0Milliliter]
				]
			],
			{
				filtrationModes,
				primaryConcentrationTargets,
				diafiltrationTargets,
				sampleInVolumes,
				solventDensity,
				permeateAliquotVolumes,
				retentateToPermeateTransferVolumes
			}
		];

		(*Transfer retentate to permeate *)
		retentateToPermeateTransferSimulation= Quiet[
			ExperimentTransfer[
				PickList[mySamples,retentateToPermeateTransferVolumes,Except[Null]],
				PickList[simulatedPermeatedContainers,retentateToPermeateTransferVolumes,Except[Null]] ,
				PickList[retentateToPermeateTransferVolumes,retentateToPermeateTransferVolumes,Except[Null]],
				Simulation->currentSimulation,
				SourceLabel->PickList[Lookup[myResolvedOptions,SampleLabel],retentateToPermeateTransferVolumes,Except[Null]],
				SourceContainerLabel->PickList[Lookup[myResolvedOptions,SampleContainerLabel],retentateToPermeateTransferVolumes,Except[Null]],
				DestinationLabel->PickList[Lookup[myResolvedOptions,PermeateSampleOutLabel],retentateToPermeateTransferVolumes,Except[Null]],
				DestinationContainerLabel->PickList[Lookup[myResolvedOptions,PermeateContainerOutLabel],retentateToPermeateTransferVolumes,Except[Null]],
				Output->Simulation
			],
			{Warning::RoundedTransferAmount}
		];

		(* Update simulation *)
		currentSimulation=UpdateSimulation[currentSimulation, retentateToPermeateTransferSimulation];

		(*Transfer diafiltration first*)
		diafiltrationTransferSimulation= If[
			NullQ[diafiltrationBuffers],
			Simulation[],
			Quiet[
				ExperimentTransfer[
					PickList[diafiltrationBuffers,diaFiltrationToRetentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					PickList[simulatedPermeatedContainers,diaFiltrationToRetentateTransferVolumes,(All|GreaterP[0 Milliliter])] ,
					PickList[diaFiltrationToRetentateTransferVolumes,diaFiltrationToRetentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					Simulation->currentSimulation,
					DestinationLabel->PickList[Lookup[myResolvedOptions,PermeateSampleOutLabel],diaFiltrationToRetentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					DestinationContainerLabel->PickList[Lookup[myResolvedOptions,PermeateContainerOutLabel],diaFiltrationToRetentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					Output->Simulation
				],
				{Warning::RoundedTransferAmount}
			]
		];
		(* Update simulation *)
		currentSimulation=UpdateSimulation[currentSimulation, diafiltrationTransferSimulation];
		(* Finally Transfer everything to retentate container *)
		currentSampleVolumes=Download[mySamples,Volume,Simulation->currentSimulation];

		(* Calculate retentate transfer volume in the simulation *)
		retentateTransferVolumes = MapThread[
			Function[
				{
					retentateContainer,
					sampleVolume,
					retentateAliquotVolume
				},
				Which[
					NullQ[retentateContainer], 0Milliliter,

					MatchQ[retentateAliquotVolume,All],All,

					True, Min[sampleVolume,retentateAliquotVolume]
				]

			],
			{
				simulatedRetentateContainers,
				currentSampleVolumes,
				retentateAliquotVolumes
			}
		];

		(*Transfer sample to retentate container out first*)
		diafiltrationTransferSimulation= If[
			NullQ[simulatedRetentateContainers],
			Simulation[],
			Quiet[
				ExperimentTransfer[
					PickList[mySamples,retentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					PickList[simulatedRetentateContainers,retentateTransferVolumes,(All|GreaterP[0 Milliliter])] ,
					PickList[retentateTransferVolumes,retentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					Simulation->currentSimulation,
					SourceLabel->PickList[Lookup[myResolvedOptions,SampleLabel],retentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					SourceContainerLabel->PickList[Lookup[myResolvedOptions,SampleContainerLabel],retentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					DestinationLabel->PickList[Lookup[myResolvedOptions,RetentateSampleOutLabel],retentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					DestinationContainerLabel->PickList[Lookup[myResolvedOptions,RetentateContainerOutLabel],retentateTransferVolumes,(All|GreaterP[0 Milliliter])],
					Output->Simulation
				],
				{Warning::RoundedTransferAmount}
			]
		];

		(* Update simulation *)
		currentSimulation=UpdateSimulation[currentSimulation, diafiltrationTransferSimulation]
	];

	(* Now get the simulated samples in retentate and permeate containers *)
	{
		permeateContainersOutContents,
		retentateContainersOutContents
	}=Download[
		protocolObject,
		{
			{
				PermeateContainersOut[{Contents[[All,2]][Object]}]
			},
			{
				RetentateContainersOut[{Contents[[All,2]][Object]}]
			}
		},
		Cache->cache,
		Simulation->currentSimulation
	];

	{
		permeateSamples,
		retentateSamples
	}=Flatten[#,2]&/@{
		permeateContainersOutContents,
		retentateContainersOutContents
	};


	(* Uploaded Labels *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Download[Lookup[samplePackets, Container], Object]}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, RetentateContainerOutLabel]], simulatedRetentateContainers}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, RetentateSampleOutLabel]], retentateSamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PermeateContainerOutLabel]], simulatedPermeatedContainers}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PermeateSampleOutLabel]], permeateSamples}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, RetentateContainerOutLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, RetentateSampleOutLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PermeateContainerOutLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, PermeateSampleOutLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			]
		]
	];
	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentCrossFlowFiltrationOptions*)


DefineOptions[ExperimentCrossFlowFiltrationOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentCrossFlowFiltration}
];


ExperimentCrossFlowFiltrationOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* Get only the options for ExperimentCrossFlowFiltration *)
	options=ExperimentCrossFlowFiltration[myInputs,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[
		MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentCrossFlowFiltration],
		options
	]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentCrossFlowFiltrationQ*)


DefineOptions[ValidExperimentCrossFlowFiltrationQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentCrossFlowFiltration}
];


ValidExperimentCrossFlowFiltrationQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,preparedOptions,experimentCrossFlowFiltrationTests,validObjectBoolean,voqWarning,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the ValidQ specific options and Output before passing to the core function -- we want the output to be Tests in the call below *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentCrossFlowFiltration *)
	experimentCrossFlowFiltrationTests=ExperimentCrossFlowFiltration[myInputs,Append[preparedOptions,Output->Tests]];

	(* Create warnings for invalid objects *)
	validObjectBoolean=ValidObjectQ[ToList[myInputs],OutputFormat->SingleBoolean];

	(* Create a warning for invalid samples *)
	voqWarning=Warning[
		StringJoin[ToString[ToList[myInputs],InputForm]," are valid (run ValidObjectQ for more detailed information):"],
		And@@validObjectBoolean,
		True
	];

	(* Get all the tests/warnings *)
	allTests=Prepend[experimentCrossFlowFiltrationTests,voqWarning];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentCrossFlowFiltrationQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentCrossFlowFiltrationQ"]
];


(* ::Subsubsection::Closed:: *)
(*ExperimentCrossFlowFiltrationPreview*)


DefineOptions[ExperimentCrossFlowFiltrationPreview,
	SharedOptions:>{ExperimentCrossFlowFiltration}
];


ExperimentCrossFlowFiltrationPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Output->_];

	(* Return the preview for ExperimentCrossFlowFiltration *)
	ExperimentCrossFlowFiltration[myInputs,Append[noOutputOptions,Output->Preview]]
];

(* ::Subsubsection::Closed:: *)
(* Helper Functions *)

calculateAllTubingPackets[sampleReservoirPacket_,xamplerFilterQ_,fastCache_]:=Module[
	{
		feedContainerConnections, reorderedSampleReservoirConnections,tubingModelPackets,precutTubingModelPackets,
		permeateTubingPacket,retentateTubingPacket,diafiltrationTubingPacket,permeateTubingObj,retentateTubingObj,
		diafiltrationTubingObj,conductivitySensorTubingObj,filterTubingParentTubingObj,longLengthTubing,midLengthTubing,
		shortLengthTubing,tinyLengthTubing,diafiltrationBufferContainerToFeedContainerTubingPacket,feedContainerToFeedPressureSensorTubingPacket,
		permeatePressureSensorToConductivitySensorTubingPacket,retentateConductivitySensorToFeedContainerTubingPacket,
		retentatePressureSensorToConductivitySensorTubingPacket,retentateConductivitySensorInletTubingPacket,
		retentateConductivitySensorOutletTubingPacket, permeateConductivitySensorInletTubingPacket,permeateConductivitySensorOutletTubingPacket,
		filterToPermeatePressureSensorTubingPacket,feedPressureSensorToFilterTubingPacket,filterToRetentatePressureSensorTubingPacket,
		filterAuxiliaryPermeateTubingPacket
	},

	(* Find the connections for the sample reservoir *)
	feedContainerConnections=Lookup[sampleReservoirPacket,Connectors,{}];

	(* Reorder the connectors -- this is important because the order matters in the resolution, so we need to make sure they were defined in the correct order *)
	reorderedSampleReservoirConnections={
		SelectFirst[feedContainerConnections,First[#]=="Filter Outlet"&],
		SelectFirst[feedContainerConnections,First[#]=="Detector Inlet"&],
		SelectFirst[feedContainerConnections,First[#]=="Diafiltration Buffer Inlet"&]
	};

	(* Get all tube packets *)
	tubingModelPackets = DeleteDuplicates[Cases[fastCache,PacketP[Model[Plumbing,Tubing]]]];
	precutTubingModelPackets = DeleteDuplicates[Cases[fastCache,PacketP[Model[Plumbing,PrecutTubing]]]];

	(* Resolve the tubings for the sample reservoir connections -- we are only resolving for the sample reservoir because the flow rate is dictated by only the first tube. Only the tube associated with "Filter Outlet" connector is running through the filter so we want to ensure that the tube is not getting giant in other places and causing pump issues *)
	{
		permeateTubingPacket,
		retentateTubingPacket,
		diafiltrationTubingPacket
	}=Map[
		Function[
			connection,
			Which[

				(* If sample reservoir has 1/32" tubing, return 1/16" tubing -- the 1/32" tubing requires 1/16" barbs, everything else is the same as the diameter, so we need this exception here *)
				MatchQ[connection[[2]],Tube]&&connection[[4]]==1/32 Inch,SelectFirst[tubingModelPackets,Lookup[#,InnerDiameter]==1/16 Inch&],

				(* If sample reservoir has other tubing, find a tube with the same diameter *)
				MatchQ[connection[[2]],Tube],SelectFirst[tubingModelPackets,Lookup[#,InnerDiameter]==connection[[4]]&],

				(* If sample reservoir has LuerLock or TC clamp, return 1/4" *)
				MatchQ[connection[[2]],Alternatives[LuerLock,TriCloverClamp]],SelectFirst[tubingModelPackets,Lookup[#,InnerDiameter]==1/8 Inch&],

				(* Any other case, return $Failed *)
				True,$Failed
			]
		],
		reorderedSampleReservoirConnections
	];

	(*Get the corresponding objects*)
	{
		permeateTubingObj,
		retentateTubingObj,
		diafiltrationTubingObj
	}=Lookup[
		{
			permeateTubingPacket,
			retentateTubingPacket,
			diafiltrationTubingPacket
		},
		Object
	];

	(* get what you would resolve automatically for each required tube,based on the reservoirs, so we can resolve if needed *)
	conductivitySensorTubingObj = Lookup[
		SelectFirst[
			tubingModelPackets,
			Lookup[#, InnerDiameter] == 1/4 Inch &
		],
		Object
	];

	(* If we are using an xampler filter, we need a parent tubing for the tube between the filter and the pressure sensors *)
	(* NOTE: We use 1/4" tubing because the largest barb to MLL fitting we have is 1/4" barb *)
	filterTubingParentTubingObj = If[xamplerFilterQ,
		Lookup[
			SelectFirst[
				tubingModelPackets,
				Lookup[#, InnerDiameter] == 1/4 Inch &
			],
			Object
		],
		Null
	];


	(*--- new sections for all tubings ---*)
	(* - Helper function to find the correct packet for the tubing - *)
	(* Helper function to find the precut tube *)
	findPrecutTubing[parentTubingModel_, requiredLength_ ] := Module[{resolvedTubingPacket, parentTubingModelObj},
		(* get the parent tubing we want *)

		parentTubingModelObj = Download[parentTubingModel, Object];

		(* figure out what tubing we should use *)
		resolvedTubingPacket=SelectFirst[
			precutTubingModelPackets,
			And[
				MatchQ[Lookup[#,ParentTubing],LinkP[parentTubingModelObj]],
				Lookup[#,Size]==requiredLength,
				MatchQ[Lookup[#,Connectors],{
					{"Inlet", Tube, None, Null, Null, None},
					{"Outlet", Tube, None, Null, Null, None}
				}]
			]&
		];

		(* decide what to return and check if its not a good fit here.. *)
		resolvedTubingPacket
	];
	findPrecutTubing[parentTubingModel:NullP, requiredLength_ ] := Null;

	(* Different tubing length *)
	longLengthTubing = 1.10 Meter;
	midLengthTubing = 0.75 Meter;
	shortLengthTubing = 0.25 Meter;
	tinyLengthTubing = 0.05 Meter;


	(*--- Use the helper function to search all proper precut tubing models ---*)
	(*-- Note since the tube will be freshly made during the experiment here we will only call the resources for the parent tubing --*)
	diafiltrationBufferContainerToFeedContainerTubingPacket=findPrecutTubing[
		diafiltrationTubingObj,
		longLengthTubing
	];

	(*--- Generate the packet for tubing for FeedContainerToFeedPressureSensorTubing ---*)
	feedContainerToFeedPressureSensorTubingPacket=findPrecutTubing[
		permeateTubingObj,
		longLengthTubing
	];

	(*--- Generate the packet for tubing for PermeatePressureSensorToConductivitySensorTubing ---*)
	permeatePressureSensorToConductivitySensorTubingPacket=findPrecutTubing[
		permeateTubingObj,
		midLengthTubing
	];

	(*--- Generate the packet for tubing for RetentateConductivitySensorToFeedContainerTubing ---*)
	retentateConductivitySensorToFeedContainerTubingPacket=findPrecutTubing[
		retentateTubingObj,
		midLengthTubing
	];

	(*--- Generate the packet for tubing for RetentatePressureSensorToConductivitySensorTubing ---*)
	retentatePressureSensorToConductivitySensorTubingPacket=findPrecutTubing[
		retentateTubingObj,
		midLengthTubing
	];

	(*--- Generate the packet for tubing for RetentateConductivitySensorInletTubing ---*)
	retentateConductivitySensorInletTubingPacket=findPrecutTubing[
		conductivitySensorTubingObj,
		tinyLengthTubing
	];

	(*--- Generate the packet for tubing for RetentateConductivitySensorOutletTubing ---*)
	retentateConductivitySensorOutletTubingPacket=findPrecutTubing[
		conductivitySensorTubingObj,
		tinyLengthTubing
	];

	(*--- Generate the packet for tubing for PermeateConductivitySensorInletTubing ---*)
	permeateConductivitySensorInletTubingPacket=findPrecutTubing[
		conductivitySensorTubingObj,
		tinyLengthTubing
	];

	(*--- Generate the packet for tubing for PermeateConductivitySensorOutletTubing ---*)
	permeateConductivitySensorOutletTubingPacket=findPrecutTubing[
		conductivitySensorTubingObj,
		shortLengthTubing
	];

	(*--- Generate the packet for tubing for PermeateConductivitySensorOutletTubing ---*)
	filterToPermeatePressureSensorTubingPacket=findPrecutTubing[
		filterTubingParentTubingObj,
		tinyLengthTubing
	];

	filterAuxiliaryPermeateTubingPacket=findPrecutTubing[
		filterTubingParentTubingObj,
		tinyLengthTubing
	];

	feedPressureSensorToFilterTubingPacket=findPrecutTubing[
		filterTubingParentTubingObj,
		tinyLengthTubing
	];

	filterToRetentatePressureSensorTubingPacket=findPrecutTubing[
		filterTubingParentTubingObj,
		tinyLengthTubing
	];

	(* Return all *)
	{
		{
			diafiltrationBufferContainerToFeedContainerTubingPacket,
			feedContainerToFeedPressureSensorTubingPacket,
			permeatePressureSensorToConductivitySensorTubingPacket,
			retentateConductivitySensorToFeedContainerTubingPacket,
			retentatePressureSensorToConductivitySensorTubingPacket,
			retentateConductivitySensorInletTubingPacket,
			retentateConductivitySensorOutletTubingPacket,
			permeateConductivitySensorInletTubingPacket,
			permeateConductivitySensorOutletTubingPacket,
			filterToPermeatePressureSensorTubingPacket,
			filterAuxiliaryPermeateTubingPacket,
			feedPressureSensorToFilterTubingPacket,
			filterToRetentatePressureSensorTubingPacket
		},
		{
			permeateTubingObj,
			retentateTubingObj,
			diafiltrationTubingObj,
			conductivitySensorTubingObj,
			filterTubingParentTubingObj
		}
	}
];

(* Now calculate the volume of the relevant tubings - specifically from the sample to the filter (1), from the filter to the retentate conductivity sensor (3), and from the conductivity sensor to the sample reservoir (4) *)
calculateKR2iDeadVolume[
	minFilterVolume:VolumeP,
	feedContainerToFeedPressureSensorTubing:ObjectP[Model[Plumbing,PrecutTubing]],
	retentatePressureSensorToConductivitySensorTubing:ObjectP[Model[Plumbing,PrecutTubing]],
	retentateConductivitySensorToFeedContainerTubing:ObjectP[Model[Plumbing,PrecutTubing]],
	cache_
] := Ceiling[
	Total[Flatten[{

		(* Filter volume *)
		minFilterVolume,

		(* First, second, and fourth objects in the resolved precut tubings *)
		Module[{precutTubePacket, length, innerDiameter, volume},

			(* Get packet *)
			precutTubePacket = fetchPacketFromCache[#, cache];

			(* Get inner diameter and length *)
			{length, innerDiameter} = Lookup[precutTubePacket, {Size, InnerDiameter}];

			(* Calculate tubing volume *)
			volume = Convert[Pi * (innerDiameter / 2)^2 * length, Milliliter]
		]& /@ {
			feedContainerToFeedPressureSensorTubing,
			retentatePressureSensorToConductivitySensorTubing,
			retentateConductivitySensorToFeedContainerTubing
		},

		(* system overhead for retentate conductivity and pressure sensors- 2 ml each *)
		2 Milliliter * 2
	}]]
];


(* ::Subsubsection:: *)
(* resolveCrossFlowFiltrationMethod *)

(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveCrossFlowFiltrationMethod,
	SharedOptions:>{
		ExperimentCrossFlowFiltration,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with *)
(* the given options. *)
resolveCrossFlowFiltrationMethod[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}]|Automatic], myOptions : OptionsPattern[]] := Module[
	{outputSpecification,output,safeOps,gatherTests,resolvedPreparation,manualRequirementStrings,roboticRequirementStrings,result,tests},
	
	(* Generate the output specification*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	
	(* Check if we gather test *)
	gatherTests = MemberQ[output,Tests];
	
	(* get the safe options *)
	safeOps = SafeOptions[resolveCrossFlowFiltrationMethod, ToList[myOptions]];
	
	(* Resolve the sample preparation methods *)
	resolvedPreparation=If[
		MatchQ[Lookup[safeOps,Preparation],Except[Automatic]],
		Lookup[safeOps,Preparation],
		{Manual}
	];
	
	
	(* make a boolean for if it is ManualSamplePreparation or not *)
	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		"ExperimentCrossFlowFiltration can only be done manually."
	};
	
	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MemberQ[ToList[Lookup[safeOps, Preparation]], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};
	
	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];
	
	(* Return our result and tests. *)
	result=Which[
		MatchQ[Lookup[safeOps, Preparation], Except[Automatic]], Lookup[safeOps, Preparation],
		Length[manualRequirementStrings]>0,	Manual,
		Length[roboticRequirementStrings]>0, Robotic,
		True,{Manual, Robotic}
	];
	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the CrossFlowFiltration primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];
	
	outputSpecification/.{Result->result, Tests->tests}

];



(* lookup table for flowrate to parent tubing model *)
flowRateToParentTubingModel[model_] := Switch[model,
	ObjectP[Model[Plumbing, Tubing, "PharmaPure #13"]],35 Milliliter/Minute,
	ObjectP[Model[Plumbing, Tubing, "PharmaPure #14"]],131 Milliliter/Minute,
	ObjectP[Model[Plumbing, Tubing, "PharmaPure #16"]],479 Milliliter/Minute,
	ObjectP[Model[Plumbing, Tubing, "PharmaPure #15"]],1019 Milliliter/Minute,
	ObjectP[Model[Plumbing, Tubing, "PharmaPure #17"]],1679 Milliliter/Minute,
	True,1679 Milliliter/Minute
];

