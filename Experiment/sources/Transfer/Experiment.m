(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Transfer*)


(* ::Subsubsection:: *)
(*ExperimentTransfer patterns and hardcoded values*)
(* Transfer Bench with PA124/PA224/EX225AD MinWeight = 20 mg Analytical Balance *)
(* We disallow EX124 on transfer benches *)
$TransferBalanceBenchModel = Model[Container, Bench, "id:J8AY5jwRw5o9"];

(* $HighTechSchlenkLineTransferEnvironments is currently not used in Transfer since there is no room in that hood and also the instructions need to be updated *)
(* Keeping this hard-coded value for future reference *)
(* Note that the SchlenkLine field of this fume hood is NOT populated *)
$HighTechSchlenkLineTransferEnvironments={Object[Instrument, FumeHood, "id:mnk9jOkaVWbm"](*"E6 Hood 1"*)};

(* NOTE: These are the single probes ONLY. *)
$WorkCellProbes={SingleProbe1, SingleProbe2, SingleProbe3, SingleProbe4, SingleProbe5, SingleProbe6, SingleProbe7, SingleProbe8};
$NumberOfWorkCellProbes=Length[$WorkCellProbes];

(* this variable sets the lower limit on how many transfers we need to qualify for automatic usage of MultiProbeHead *)
$MultiProbeLowerLimit = 48;

(* this variable sets the upper limit for auto-resolving to multichannel transfer when Aspiration/Dispense Pipette Mix options are set *)
$MaxNumberOfMultichannelPipetteMixes = 5;

(* this is a list of all Hamilton tip P/N supported by our "cutness" library with what is equivalent to be used *)
$HamiltonPartNumbersEquivalence=<|
	(* natively supported types *)
	"57549-02 US" -> "57549-02 US", (* standard with filter, non-sterile, 51.6mm with orifice 1.55mm *)
	"235449" -> "235449", (* standard w/ filter, non-sterile, 51.6mm with orifice 1.55mm *)
	"235451" -> "235451", (* standard w/o filter, non-sterile, 51.6mm orifice 1.55mm *)
	"235452" -> "235452", (* standard w/ filter, non-sterile, 57.23mm orifice 0.71mm *)
	"235541" -> "235541", (* 1mL w/filter, non-sterile, 80.14mm orifice 3.2mm *)
	"235444" -> "235444", (* 1mL w/o filter, non-sterile, 80.13mm orifice 3.2mm *)
	(* equivalence list *)
	"235842" -> "235541" (* 1mL w/filter, sterile -> non-sterile version *)
|>;

(* This is equivalence of the CORE2->CORE1 tip models *)
$HamiltonCORETipsEquivalence=<|
	(* Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"] -> Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile CO-RE 1"] *)
	Model[Item, Tips, "id:54n6evKx0oB9"] -> Model[Item, Tips, "id:4pO6dMOzE9eo"],
	(*Model[Item, Tips, "300 uL Hamilton barrier tips, sterile"] -> Model[Item, Tips, "300 uL Hamilton barrier tips, sterile CO-RE 1"]*)
	Model[Item, Tips, "id:Z1lqpMGjeYXz"] -> Model[Item, Tips, "id:Vrbp1jbRoqmx"],
	(* Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"] -> Model[Item, Tips, "50 uL Hamilton barrier tips, sterile CO-RE 1"]*)
	Model[Item, Tips, "id:rea9jl1orrY3"] -> Model[Item, Tips, "id:XnlV5jlGRD08"],
	(*Model[Item, Tips, "10 uL Hamilton barrier tips, sterile"] -> Model[Item, Tips, "10 uL Hamilton barrier tips, sterile CO-RE 1"]*)
	Model[Item, Tips, "id:P5ZnEj4P884r"] -> Model[Item, Tips, "id:qdkmxzk9elwa"],
	(*Model[Item, Tips, "300 uL Hamilton tips, non-sterile"] -> Model[Item, Tips, "300 uL Hamilton tips, non-sterile CO-RE 1"]*)
	Model[Item, Tips, "id:o1k9jAKOwwEA"] -> Model[Item, Tips, "id:R8e1Pje4r65K"],
	(*Model[Item, Tips, "50 uL Hamilton tips, non-sterile"] -> Model[Item, Tips, "50 uL Hamilton tips, non-sterile CO-RE 1"]*)
	Model[Item, Tips, "id:D8KAEvdqzzmm"] -> Model[Item, Tips, "id:O81aEB1dpxje"],
	(*Model[Item, Tips, "10 uL Hamilton tips, non-sterile"] -> Model[Item, Tips, "10 uL Hamilton tips, non-sterile CO-RE 1"]*)
	Model[Item, Tips, "id:vXl9j5qEnnV7"] -> Model[Item, Tips, "id:GmzlKjzvxAD9"],
	(*Model[Item, Tips, "300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"] -> Model[Item, Tips, "300 uL Hamilton barrier tips, wide bore, 1.55mm orifice CO-RE 1"]*)
	Model[Item, Tips, "id:D8KAEvGD8RMR"] -> Model[Item, Tips, "id:AEqRl9qrNOLl"],
	(*Model[Item, Tips, "1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"] -> Model[Item, Tips, "1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice CO-RE 1"]*)
	Model[Item, Tips, "id:J8AY5jDG8NXD"] -> Model[Item, Tips, "id:o1k9jAkxZlDr"],
	(*Model[Item, Tips, "1000 uL Hamilton tips, non-sterile"] -> Model[Item, Tips, "1000 uL Hamilton tips, non-sterile CO-RE 1"]*)
	Model[Item, Tips, "id:J8AY5jDvl5lE"] -> Model[Item, Tips, "id:zGj91ajVEbvO"],
	(*Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile, wide bore, 3.2mm orifice"] -> Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile, wide bore, 3.2mm orifice CO-RE 1"]*)
	Model[Item, Tips, "id:WNa4ZjaePv7L"] -> Model[Item, Tips, "id:lYq9jRq7nKkY"]
|>;

(* Model[Sample, "Milli-Q water"] *)
$DefaultQuantitativeTransferWashSolution = Model[Sample, "id:8qZ1VWNmdLBD"];

(* we can only use Micro balance if we are using Model[Item, WeighBoat, WeighingFunnel, "Polypropylene Weighing Funnel (0.5 mL capacity, 0.2 Inch Stem Diameter) with Lip"], Model[Item, WeighBoat, "Aluminum Round Micro Weigh Dish, Individual"], or Model[Item, WeighBoat, "Aluminum Round Micro Weigh Dish"] *)
$MicroBalanceCompatibleWeighingContainerModels = {Model[Item, WeighBoat, WeighingFunnel, "id:1ZA60vzGv6l0"], Model[Item, WeighBoat, "id:4pO6dMj9wqM7"], Model[Item, WeighBoat, "id:7X104vn4qJkw"]};

(* this is a list of handling station models that we should only try to use when specified, but not via auto-resolution since they contain specialized instruments inside and we do not want to just direct normal transfers inside *)
(* definitely add more to this list as we discover more, i.e. fumehood containing pH meter and schlenk lines *)
$SpecializedHandlingStationModels = {
	Model[Instrument, HandlingStation, FumeHood, "id:aXRlGn0rDJGB"], (* Model[Instrument, HandlingStation, FumeHood, "Fume Hood Handling Station with Schlenk Line"] *)
	Model[Instrument, HandlingStation, FumeHood, "id:1ZA60vzObqa0"] (* Model[Instrument, HandlingStation, FumeHood, "Fumehood with pHMeter"] *)
};


(* ::Subsubsection:: *)
(*ExperimentTransfer Options*)


DefineOptions[ExperimentTransfer,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SourceLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the source sample from which the transfer occurs, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SourceContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the container of the source sample from which the transfer occurs, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> DestinationLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the destination sample from which the source sample is transferred into, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> DestinationContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the container of the destination sample from which the source sample is transferred into, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName -> SourceWell,
				Default -> Automatic,
				ResolutionDescription -> "Automatically set to the first non-empty well if an Object[Container] or {_Integer, Model[Container]} is given. Otherwise, is set to the position of the given Object[Sample].",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> String,
						Pattern :> WellPositionP,
						Size->Line,
						PatternTooltip -> "Enumeration must be any well from A1 to H12."
					],
					Widget[
						Type -> String,
						Pattern :> LocationPositionP,
						PatternTooltip -> "Any valid container position.",
						Size->Line
					]
				],
				Description -> "The position in the source container to aspirate from.",
				Category->"General"
			},
			(* NOTE: The following two options related to source container and grouping are just for passing information from the resolver to the resource packets function and should NOT be specified by the user. *)
			{
				OptionName -> SourceContainer,
				Default -> Automatic,
				ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in. If Preparation->Robotic, all compatible containers will be automatically listed for the SourceContainer, so that any requests for the same Model[Sample] can automatically be combined into the same container on the robot between unit operations, to optimize for space on the liquid handler deck.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Existing Container"->Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Container]]
					],
					"New Container"->Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Container]]
					],
					"New Possible Containers"->Adder[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Model[Container]]
						]
					]
				],
				Description -> "The container that the source sample will be located in during the transfer.",
				Category->"Hidden"
			},
			{
				OptionName -> SourceSampleGrouping,
				Default -> Null,
				Description -> "The grouping information of Model[Sample] fulfillment for different transfers. The Model[Sample] requests with the same Index are fulfilled with one single resource of the specified Total Amount. For requests totalling larger than the maximum volume of available containers in the lab, multiple resources are picked for the same Model[Sample].",
				AllowNull -> True,
				Widget -> List[
					"Index" -> Widget[
						Type -> String,
						Pattern:>_String,
						Size->Line
					],
					"Total Amount"->Alternatives[
						"Volume" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Microliter, 20 Liter],
							Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
						],
						"Mass" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Milligram, 20 Kilogram],
							Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
						],
						"Count" -> Widget[
							Type -> Number,
							Pattern :> GreaterP[0., 1.]
						]
					]
				],
				Category->"Hidden"
			},
			(* NOTE: This option is a developer only option. This option should be set to False if the Destination should be marked as Living->False, instead of following the normal living sample combining rules as found in MoreInformation of UploadSampleTransfer *)
			{
				OptionName -> LivingDestination,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the typical rules for setting the Living field of the Destination will be followed, or if the Living field of the Destination will be set to False regardless of the state of the Living field of the source and destination initially. See the UploadSampleTransfer helpfile for more information on the 'typical rules' for setting the Living field.",
				Category->"Hidden"
			},

			(* NOTE: This option is only used to pass the rounded amount that we're going to transfer back up to the resource *)
			(* packets function. It should NEVER be passed in by the user/developer. *)
			{
				OptionName->Amount,
				Default->Automatic,
				ResolutionDescription -> "Automatically rounded based on the resolution of the transfer instrument.",
				AllowNull->True,
				Widget->Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count" -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description->"The amount of the source sample that should be transferred to the destination sample.",
				Category->"Hidden"
			},
			{
				OptionName -> DestinationRack,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}],
					PreparedContainer->False
				],
				Description -> "Specifies the rack that is used to hold the DestinationContainer upright.",
				Category->"Hidden"
			},
			{
				OptionName -> AllowSourceContainerReCover,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates whether the source container is allowed to be re-covered once uncovered. If set to false, the source container is discarded after transfer and all contents in it need to be transferred out.",
				Category->"Hidden"
			},
			{
				OptionName -> RestrictSource,
				Default -> Automatic,
				Description -> "Indicates whether the source should be restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member.)",
				ResolutionDescription -> "If this sample is being reused as a source/destination elsewhere in your Transfer and the RestrictSource/RestrictDestination option are specified for that sample, the same value will be used.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> RestrictDestination,
				Default -> Automatic,
				Description -> "Indicates whether the destination should be restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member.)",
				ResolutionDescription -> "If this sample is being reused as a source/destination elsewhere in your Transfer and the RestrictSource/RestrictDestination option are specified for that sample, the same value will be used.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> CoolingTime,
				Default -> Automatic,
				Description -> "Specifies the length of time that should elapse after the transfer before the sample is removed from the TransferEnvironment. This is a lower bound, which will govern the final transfer, and so any given sample in a batch may cool for longer than the CoolingTime.",
				ResolutionDescription -> "Resolves to 10 minutes when the SourceTemperature is not Ambient.",
				AllowNull -> True,
				Category -> "TemperatureConditions",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute,$MaxExperimentTime],
					Units->{1,{Minute,{Second,Minute,Hour}}}
				]
			},
			{
				OptionName->SolidificationTime,
				Default->Null,
				Description->"In a media transfer, the duration of time after transferring the liquid media into incubation plates that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments.",
				AllowNull->True,
				Category->"TemperatureConditions",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,1*Day],
						Units->{1,{Hour,{Hour,Day}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None]
					]
				]
			},
			{
				OptionName -> FlameDestination,
				Default -> Automatic,
				Description -> "In a media transfer, indicates whether the destination should be briefly heated with a flame to remove any bubbles after transfer before it solidifies.",
				ResolutionDescription -> "Automatically set to True if the destination is a plate and the source is a media sample.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> ParafilmDestination,
				Default -> Automatic,
				Description -> "In a media transfer, indicates whether Parafilm should be applied to the Destination after Transfer (and any applicable CoolingTime).",
				ResolutionDescription -> "Automatically set to True if the destination is a plate and the source is a media sample.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> IntermediateDecantRecoup,
				Default -> False,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if any residual sample transferred into the intermediate container should be transferred back to the source sample. This option can only be set to True for Object[Sample] source.",
				Category -> "General"
			},
			{
				OptionName -> BalanceCleaningMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Wet,Dry]],
				Description -> "Indicates the type of cleaning performed on the balance right before a weighing instance if the operator indicates presence of stray material. Dry indicates the balance pan surface and the balance floor outside of the balance pan are cleared of any stray material using soft and lint-free non-woven wipes. Wet indicates the balance pan surface and the balance floor outside of the balance pan is first cleaned with Dry method, followed by wiping with DI-water moistened wipes, IPA-moistened wipes, and a final dry wipe. None indicates no cleaning is performed prior to initial setup.",
				ResolutionDescription -> "Automatically set to the same value as BalancePreCleaningMethod if BalancePreCleaningMethod is either Wet or Dry. If BalancePreCleaningMethod is None, set to Wet.",
				Category -> "General"
			},
			{
				OptionName -> OverdrawVolume,
				Default -> Automatic,
				Description -> "When performing a syringe transfer, the amount with which to fill the syringe with to allow for the removal of air from the syringe body, determined by adding the specified Amount and a calculated extra volume based on the needle and syringe used.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Microliter, 20 Liter],
					Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
				],
				Category -> "Hidden"
			}
		],
		{
			OptionName -> WasteContainer,
			Default->Automatic,
			Description->"The container used to temporarily hold any leftover samples removed from the intermediate containers and graduated cylinders. The sample in this container will be discarded at the end of the protocol.",
			ResolutionDescription -> "Automatically set to Model[Container, Vessel, \"250mL Glass Bottle\"] if intermediate container is used and IntermediateDecantRecoup is False.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Container],
					Object[Container]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers"
					}
				}
			],
			Category -> "Hidden"
		},
		ModifyOptions[
			SourceTemperatureOptions,
			{
				{
					OptionName -> SourceTemperature,
					Widget->Alternatives[
						Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, 90 Celsius],Units :> Celsius],
						Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Cold]]
					],
					Description->"Indicates the temperature at which the source sample will be at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample. Samples transferred in a biosafety cabinet can have SourceTemperature specified as Cold (approximately 4 Celsius), Ambient, or a specific temperature above 25 Celsius."
				},
				{OptionName -> SourceEquilibrationTime},
				{OptionName -> MaxSourceEquilibrationTime},
				{OptionName -> SourceEquilibrationCheck}
			}
		],
		ModifyOptions[
			DestinationTemperatureOptions,
			{
				{
					OptionName -> DestinationTemperature,
					Widget->Alternatives[
						Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, 90 Celsius],Units :> Celsius],
						Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Cold]]
					],
					Description->"Indicates the temperature at which the destination will be at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample. Samples transferred in a biosafety cabinet can have DestinationTemperature specified as Cold (approximately 4 Celsius), Ambient, or a specific temperature above 25 Celsius."
				},
				{OptionName -> DestinationEquilibrationTime},
				{OptionName -> MaxDestinationEquilibrationTime},
				{OptionName -> DestinationEquilibrationCheck}
			}
		],
		TransferDestinationWellOption,
		MultichannelTransferOptions,
		TransferInstrumentOption,
		HandlingConditionOption,
		TransferEnvironmentOption,
		EquivalentTransferEnvironmentsOption,
		TransferBalanceOption,
		TabletCrusherOption,
		SachetOptions,
		TransferTipOptions,
		TransferRoboticTipOptions,
		TransferNeedleOption,
		TransferFunnelOption,
		WeighingContainerOption,
		TransferToleranceOption,
		HandPumpOption,
		QuantitativeTransferOptions,
		TransferHermeticSourceOptions,
		TransferHermeticDestinationOptions,
		TipRinseOptions,
		AspirationMixOptions,
		DispenseMixOptions,
		IntermediateDecantOptions,
		TransferLayerOptions,
		MagnetizationOptions,
		CollectionContainerOptions,
		SterileTechniqueOption,
		RNaseFreeTechniqueOption,
		CountAsPassageOptions,
		TransferCoverOptions,

		{
			OptionName -> FillToVolume,
			Default -> False,
			Description -> "Indicates that ExperimentTransfer is being called from ExperimentFillToVolume so that it returns options that Output -> Options wouldn't normally do.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},
		{
			OptionName -> FillToVolumeOverfillingRepreparation,
			Default -> False,
			Description -> "Indicates that ExperimentTransfer is being called from FillToVolume as part of its OverfillingRepreparations. In this case, the Transfer is not doing FillToVolume and should be performed in the normal way, even if the destination is a volumetric flask.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},
		{
			OptionName -> InSitu,
			Default -> False,
			Description -> "Indicates if the operator should not resource pick the source or destination containers and that they should remain where they already are.  Note that this will only work if the source and destination containers are already in the TransferEnvironment (or inside a container inside the TransferEnvironment, etc.).",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> UploadResources,
			Default -> True,
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the resource blobs from the resource packets function should actually be uploaded.",
			Category->"Hidden"
		},
		{
			OptionName -> BalancePreCleaningMethod,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Wet,Dry,None]],
			Description -> "Indicates the type of cleaning performed on the balance prior to its initial setup for use. Dry indicates the balance pan surface and the balance floor outside of the balance pan is cleared of any stray material using a cleaning brush and lint-free non-woven wipes. Wet indicates the balance pan surface and the balance floor outside of the balance pan is first cleaned with Dry method, followed by wiping with DI-water moistened wipes, IPA-moistened wipes, and a final dry wipe. None indicates no cleaning is performed prior to initial setup.",
			ResolutionDescription -> "Automatically set to None.",
			Category -> "General"
		},
		{
			OptionName -> OverdrawVolumeWasteContainer,
			Default -> Automatic,
			Description -> "The vessel to hold any extraneous discarded sample when expelling air or bringing the sample volume to the target amount after overdrawing.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Model[Container, Vessel],
					Object[Container, Vessel]}]
			],
			Category -> "Hidden"
		},
		(*===Shared Options===*)
		PreparationOption,
		ProtocolOptions,
		SimulationOption,
		NonBiologyPostProcessingOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		WorkCellOption,

		(* option used to pass any advanced certificate back to top level framework primitive functions *)
		SupplementalCertificationOption,

		(* NOTE: These are weird Transfer specific options. Do NOT copy them. *)
		KeepInstrumentOption,

		(* this option is used in order fulfillment system, it does not need to be index matched since each transfer protocol is trying to fulfill one order when it gets called *)
		OrderFulfilledOption,

		(* These three options are only used by Resource fulfillment system. They are guaranteed to be index matching to each tuple of source,destination,amount *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* these two options need to be index matched to samples, so we can tune them individually for each batched UO, depending on the transfer amount, sample state etc *)
			WeightStabilityDurationOption,
			MaxWeightVariationOption,
			TareWeightStabilityDurationOption,
			MaxTareWeightVariationOption,
			{
				OptionName->PreparedResources,
				Default->Null,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Resource,Sample]],ObjectTypes->{Object[Resource,Sample]}],
				Description->"Model resources in the ParentProtocol that are being transferred into an appropriate container model by this experiment call.",
				Category->"Hidden"
			},
			{
				OptionName->RentDestinationContainer,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates if the container model resource requested for this sample should be rented when this experiment is performed.",
				Category->"Hidden"
			},
			{
				OptionName->Fresh,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates if a fresh sample should be used when fulfilling the model resource of the transfer source.",
				Category->"Hidden"
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(* ExperimentTransfer Source Code *)
Warning::OveraspiratedTransfer="The source(s), `1`, have the following amounts specified to be transferred, `2`, at manipulation indices `4`. However, these source(s) will only have `3` in their containers at the time that the transfer is to be performed. Please specify a lower mass/volume/count or specify All to transfer all of the contents of the sample.";
Error::OverfilledTransfer="The destination(s), `1`, have the following amounts transferred into them, `2`, at manipulation indices, `4`. However, there will already be, `3` in these destination(s) at the time that the transfer is to be performed. This will overfill the MaxVolume of the container. Please transfer a lower mass/volume/count into the destination container or transfer the source into a different destination container. For solid sample without density information, its volume is estimated with 80% of the water density (0.997 g/mL) for safe transfers. If you know the sample density, please populate the information to avoid this error.";
Error::InvalidDestinationHermetic="The destination container(s), `1`, have UnsealHermeticDestination or VentingNeedle set for them at manipulation indices, `2`. However, that the time of the transfer, the destination container will not be hermetic. Please do not specify these options at this manipulation index.";
Error::InvalidSourceHermetic="The source container(s), `1`, have UnsealHermeticSource, BackfillNeedle, or BackfillGas set for them at manipulation indices, `2`. However, that the time of the transfer, the source container will not be hermetic. Please do not specify these options at this manipulation index.";
Error::DispenseMixOptions="The dispense mix options, `1`, are currently set to `2`, but the options `3`, are currently set to `4`. The dispense mix options must all be specified to be used. Please let the options `3` automatically resolve instead of setting them to Null.";
Error::AspirationMixOptions="The aspiration mix options, `1`, are currently set to `2`, but the options `3`, are currently set to `4`. The aspiration mix options must all be specified to be used. Please let the options `3` automatically resolve instead of setting them to Null.";
Error::InvalidTiltMixVolumeOptions="The mix volume options, `1`, are currently set to `2` while the corresponding mix type(s) are set to Tilt. The mix volume options cannot be specified for Tilt mixing. Please set the options to Null or select Pipette mixing type.";
Error::TipRinseOptions="The tip rinse options, `1`, are currently set to `2`, but the options `3`, are currently set to `4`. The tip rinse options must all be specified to be used. Please let the options `3` automatically resolve instead of setting them to Null.";
Error::ConflictingQuantitativeTransferOptions="The quantitative transfer options, `1`, are currently set to `2`, but the options `3`, are currently set to `4`. The quantitative transfer options must all be specified to be used. And QuantitativeTransfer cannot be performed if Preparation method is Robotic. Please check the options `1` and `3` or let these options resolve automatically.";
Error::IncompatibleSpatulaWidth="The spatula instrument specified (`1`), at manipulation indices, `2`, have an end width greater than the destination aperture of the destination container (`3`). Please specify a different Instrument or allow to resolve automatically.";
Warning::QuantitativeTransferRecommended="The following solid samples, `1`, at manipulation indices, `2`, are weighed in the WeighingContainer `3` at amounts of `4`. When the amount is less than " <> ToString[$WeighBoatSmallQuantityThreshold] <> ", residual solids left behind in the WeighingContainer can represent a significant portion of the total sample. If full recovery is needed, consider setting QuantitativeTransfer to True to rinse the WeighingContainer with QuantitativeTransferWashSolution.";
Error::InvalidQuantitativeTransferWashVolume="The following amounts of QuantitativeTransferWashSolution, `1`, at manipulation indices, `2` for QuantitativeTransfer is greater than 5 Milliliter. Please set QuantitativeTransferWashVolume to a lower value and increase NumberOfQuantitativeTransferWashes if more washes are desired.";
Error::IncompatibleQuantitativeTransferWashTips="The following QuantitativeTransferWashTips, `1`, at manipulation indices, `2` is not valid. Only tips with PipetteType Micropipette are used for QuantitativeTransfer and must be able to hold `3`. Please specify a different value for QuantitativeTransferWashTips or allow to resolve automatically.";
Error::IncompatibleQuantitativeTransferWashInstrument="The following QuantitativeTransferWashInstrument, `1`, at manipulation indices, `2` are not valid. Only pipettes with PipetteType Micropipette are used for QuantitativeTransfer and must be compatible with tips `3`. Please specify a different value for QuantitativeTransferWashInstrument or allow to resolve automatically.";
Error::RequiredWeighingContainerNonEmptyDestination="The destination container(s), `1`, will not be empty at the requested DestinationWell to be transferred into at the time of the transfer at manipulation indices, `2`. Therefore, a WeighingContainer is necessary to first weigh out the requested sample amount. Please do not set the WeighingContainer options to Null or transfer All of the sample into the destination container.";
Error::TipsOrNeedleLiquidLevel="The following options, `1`, that are currently set to, `2`, will not be able to reach the bottom of the source's container or intermediate decant container at manipulation indices, `3`. Please let these options resolve automatically or specify a different set of needles/pipettes to perform the transfer.";
Warning::TabletCrusherRequired="The manipulation(s) at indices `2` specify that a mass of the source sample, `1`, should be transferred to the destination. However, the source sample has the SampleHandling category of Itemized and Tablet -> True. A pill crusher may be used in order to achieve the requested mass. If this is not intended, please specify an integer number of pills instead of a mass to be transferred.";
Warning::SachetMassSpecified="The manipulation(s) at indices `2` specify that a mass of the source sample, `1`, should be transferred to the destination. However, the source sample has the SampleHandling category of Itemized and Sachet -> True. Whole sachets will be measured to get as close as possible to the specified mass. The sachets will be cut open and the their whole portioned filler (may or may not include the pouch itself, as indicated by IncludeSachetPouch) is transferred to the destination. If this is not intended, please specify an integer number of sachets instead of a mass to be transferred.";
Warning::SpatulaCapacityWarning = "The spatula Instrument (`1`) at manipulation indice(s) `2` has a capacity that is not ideal for the mass to be transferred (`3`). If this is not intended, please specify a different spatula instrument or allow to resolve automatically.";
Error::BalanceCleaningMethodRequired = "The BalanceCleaningMethod (`1`) for (`2`) at manipulation indices (`3`) are not valid. BalanceCleaningMethod cannot be Null if a balance is required. Please modify the option or allow to resolve automatically.";
Error::InvalidInstrumentCapacity="The following combination of options, `1`, that are currently set to, `2`, are not able to transfer the amount/state of the sample requested `3` at manipulation indices `4`. Please check the range of volume/mass that the specified instruments can transfer or let these options resolve automatically.";
Error::ToleranceSpecifiedForAllTransfer="At manipulation indices, `2`, the Tolerance option, `1`, was specified. However, the Amount transferred at these indices is specified to be All. The tolerance of a transfer cannot be specified if the Amount to be transferred is All. Please set the Tolerance option to Null or let it automatically resolve.";
Error::IncorrectlySpecifiedTransferOptions="The following pairs of instruments and amounts, `1` and `2` at manipulation indices, `7`, require the following options to be set, `3` (they are currently set to `4`). Additionally, the following options cannot be set `5`, but are currently set to `6`. Please let these options automatically resolve. If these options are automatically resolving to Null, that means that there are no compatible values for these options based on the Instruments/containers given.";
Error::IncompatibleTipItemConsumable="The following value (`1`) for the option `2` is not allowed. Please specify value of types Model[Item, Tips] or Object[Item,Tips] for Tips or allow options to automatically resolve.";
Error::InvalidTransferWellSpecification="The following well(s), `2`, were given for the destination container(s), `1`. However, these destination containers do not have these wells. Please check the AllowedPositions of the Model[Container] that you are transferring into and specify a valid well position for the transfer.";
Error::SterileTransfersAreInBSC="All SterileTechnique manual transfers must occur in a biosafety cabinet. Non-SterileTechnique transfers cannot be performed in a biosafety cabinet. The manipulations at indices, `2`, have a TransferEnvironment of `1`. Please change the SterileTechnique or TransferEnvironment options to specify a valid transfer.";
Error::ConflictingSterileTransferWithWorkCell="All SterileTechnique robotic transfers must occur in a bioSTAR or microbioSTAR WorkCell. Non-SterileTechnique robotic transfers are performed in a STAR WorkCell. The manipulations at indices, `2`, have SterileTechnique of `1`. Please change the SterileTechnique or WorkCell options to specify a valid transfer.";
Warning::ConflictingSourceAndDestinationAsepticHandling="The following source sample(s) `1` require aseptic techniques, as either AsepticHandling or Sterile field is set to True, but the corresponding destination(s) `2` do not have AsepticHandling or Sterile set to True. This mismatch will result in a non-sterile sample by the end of the protocol. If sterility is desired, consider changing the destination container to a sterile container model or using destination sample that also requires aseptic techniques.";
Error::AspiratorRequiresSterileTransfer="Transfers using an aspirator, including all transfers to Waste, must occur in a BSC which requires SterileTechnique to be set to True. The manipulations at indices, `1`, have Destination set to Waste or have Instrument set to an aspirator but have SterileTechnique set to False. Please change SterileTechnique to True in order to use an aspirator or transfer to Waste.";
Error::InvalidBackfillGas="All transfers that specify the need for BackfillGas must either occur in a Instrument that is equipped with the correct gas pipe. The manipulations at indices, `3`, have a TransferEnvironment of `1` (check the ArgonHermeticTransfer/NitrogenHermeticTransfer field of the ProvidedHandlingConditions) that is not capable of fulfilling BackfillGas of `2`. If you want this transfer to occur with no BackFill needed, please specify UnsealHermeticSource->True, or reset BackfillGas TransferEnvironment options to Automatic to continue.";
Error::TransferEnvironmentBalanceCombination="The balance(s) requested, `1`, at manipulation indices, `4`, are not located in the given transfer environment(s), `2`. The available balance models in these transfer environment(s) are, `3`. Please specify another transfer environment for the transfer to occur in or specify a different balance.";
Error::TransferEnvironmentInstrumentCombination="The instrument(s) requested, `1`, at manipulation indices, `3`, do not have the same CultureHandling or AsepticHandling value as the given transfer environment(s), `2`. Please specify another transfer environment for the transfer to occur in or specify a different instrument.";
Error::AspiratableOrDispensableFalse="The source containers at indices, `1`, have Aspiratable->False specified in their container models. The destination containers at indices, `2`, have Dispensable->False in their container models. Due to these invalid containers, the transfer cannot be performed. Please choose alternative sources/destinations to transfer to/from.";
Error::InvalidTransferTemperatureGloveBox="All transfers that occur in the glove box cannot have a non-Ambient/25 Celsius SourceTemperature or DestinationTemperature specified since hot/cold transfers cannot be performed in the glove box. The manipulations at indices, `2`, that are specified to occur in the TransferEnvironment(s), `1`, have a non-Ambient SourceTemperature/DestinationTemperature. Please do not specify a SourceTemperature/DestinationTemperature if the transfer is to occur in the glove box.";
Error::IncompatibleTransferDestinationContainer="The following source sample(s) `1` at manipulation indices, `2` are incompatible to the corresponding destination(s) `3` containing material(s) `4`. Please select destination(s) that do(es) not have ContainerMaterials which are members of the IncompatibleMaterials of the source sample(s).";
Error::IncompatibleTransferIntermediateContainer="The following source sample(s) `1` at manipulation indices, `2` are incompatible to the corresponding intermediate container(s) `3` containing material(s) `4`. Please specify IntermediateContainer that do(es) not have ContainerMaterials which are members of the IncompatibleMaterials of the source sample(s).";
Error::RecoupContamination="The following source sample(s) `1` at manipulation indices, `2` are not private samples while IntermediateDecantRecoup option is set to True, which can potentially result in cross-contamination of a public sample while fulfilling the source model sample (if any). Please replace the problematic source sample with an explicit object sample that can be used by your financing team, or set IntermediateDecantRecoup option to False.";
Error::IncompatibleQuantitativeTransferWeighingContainer="The following container(s) `2` at manipulation indices `3` are incompatible with QuantitativeTransfer `1`. Please set WeighingContainer to a Model[Item,WeighBoat] or Model[Item,WeighBoat,WeighingFunnel] when QuantitativeTransfer is True or allow to resolve automatically.";
Error::NoCompatibleWeighingContainer="The transfers at  manipulation indices `1` require WeighingContainer (`2`) but no compatible ones were found. Please check the transfer amount, destination Aperture, and IncompatibleMaterials of the sample and QuantitativeTransferWashSolution (if applicable).  If Mode is Micro, only "<>ToString[$MicroBalanceCompatibleWeighingContainerModels, InputForm]<>" can be used. Please modify either amount to trasfer, destination container or quantitative transfer parameters or allow to resolve automatically.";
Error::IncompatibleWeighingContainer="The following specified WeighingContainer (`1`) at manipulation indices (`2`) are not compatible with the transfer parameters specified. Weighing container must be compatible with the specified transfer amount, destination container Aperture, and should not include any specified IncompatibleMaterials for the sample or QuantitativeTransferWashSolution (if applicable). If Mode is Micro, only "<>ToString[$MicroBalanceCompatibleWeighingContainerModels, InputForm]<>" can be used. Please modify the specified WeighingContainer or allow to resolve automatically.";
Error::NoCompatibleFunnel="No Funnel was found compatible with WeighingContainer `1` for QuantitativeTransfer True at manipulation indices `2`. A funnel is required when WeighingContainer is not a Model[Item,WeighBoat,WeighingContainer] and QuantitativeTransfer is True. Please modify options or allow to resolve automatically.";
Error::GaseousSample="The source samples, `1`, at manipulation indices, `2`, have State->Gas. Currently, the transfer of gaseous samples is not supported by ExperimentTransfer. Please specify alternative samples to be transferred.";
Error::IncompatibleFTVTransferIntermediateContainer="The following source intermediate container(s) `1` at manipulation indices, `2` are not allowed for a transfer involving FillToVolume to the following model destination container (`3`). Please specify IntermediateContainer as `4` for FillToVolume to volumetric flasks or allow the option to automatically resolve.";
Error::IncompatibleFTVTransferIntermediateDecant="The following option values for IntermediateDecant `1` at manipulation indices, `2` are not allowed for a transfer involving FillToVolume to the following model destination container (`3`). Please specify IntermediateDecant to False if doing a FillToVolume to a volumetric flask or allow the option to automatically resolve.";
Error::IncompatibleFTVTransferInstrument="The following option values for Instrument `1` at manipulation indices, `2` are not allowed for a transfer involving FillToVolume to the following model destination container (`3`). Please specify Instrument to either Null or a graduated cylinder if doing a FillToVolume to a volumetric flask or allow the option to automatically resolve.";
Error::InvalidNumberOfQuantitativeTransferWashes="The following option values for NumberOfQuantitativeTransferWashes `1` at manipulation indices, `2` are not allowed. If the WeighingContainer is not of Model[Item,WeighBoat, WeighingFunnel] and Funnel is not Null, the NumberOfQuantitativeTransferWashes must be equal or greater than 3. Otherwise, NumberOfQuantitativeTransferWashes must be equal or greater than 2. Please modify the option or allow the option to automatically resolve.";
Error::IncompatibleFTVTransferFunnel="The following option values for Funnel `1` at manipulation indices, `2` are not allowed for a transfer involving FillToVolume to the following model destination container `3`. Please specify Funnel if doing a FillToVolume to a volumetric flask, or allow the option to automatically resolve.";
Error::TransferSolidSampleByVolume="The source sample(s), `1`, will be State->Solid at manipulation indices, `2`. However, these samples have been requested to be transferred by volume. Solid samples must be transferred by mass and cannot be transferred by volume. Please specify the amount to be transferred as a mass in order to transfer this solid sample.";
Warning::RoundedTransferAmount="The give amounts to be transferred, `1`, at manipulation indices, `3`, are going to be rounded to, `2`, due to the Resolution of the transfer Instrument/Balance that are going to be used. If the given precision is still desired, please transfer a smaller amount or use a different Instrument/Balance to perform the transfer.";
Error::TransferInstrumentRequired="The manipulations at indices, `2`, have Instrument->Null but have the transfer amount specified as, `1`. The Instrument option can only be set to Null (the transfer is to be performed by pouring from the source to destination) if All of the source is being transferred to the destination. Please either specify an instrument or set the amount to be transferred to All.";
Error::PlateTransferInstrumentRequired="The source samples at manipulation indices, `2`, are located in, `1`. However, these transfers are specified to occur via pouring (Instrument->Null). Transfers via pouring cannot occur if the source sample is in a plate (a container with more than one position). Please specify a different source sample or let the Instrument option automatically resolve.";
Error::ToleranceLessThanBalanceResolution="The tolerances, `1`, given at manipulation indices, `3`, are less than the achievable Resolution of the Balances given, `2`. Please specify a tolerance that is greater than the Resolution of the balance or specify a different balance to perform the transfer";
Error::InvalidIntermediateFunnel="The intermediate funnel(s), `1`, at manipulation indices, `4`, must have a StemDiameter less than or equal to, `2`, (to fit into the intermediate container) and must not be made up of any of the source sample's IncompatibleMaterials, `3`. Please choose a different Funnel or let the option resolve automatically.";
Error::InvalidDestinationFunnel="The funnel(s), `1`, at manipulation indices, `5`, must have a StemDiameter less than or equal to, `2`, (to fit into the destination container), must not be made up of any of the source sample's IncompatibleMaterials, `3`, and must be of FunnelType, `4`. Please choose a different Funnel or let the option resolve automatically.";
Error::AqueousGloveBoxSamples="The following samples, `1`, at manipulation indices, `2`, either have Model[Molecule, \"Water\"] in their Composition or are marked Aqueous->True. Aqueous samples cannot be manipulated in the glove box. Please choose different samples or a different transfer environment.";
Warning::NonAnhydrousSample="The following liquid samples, `1`, at manipulation indices, `2`, are not marked as Anhydrous->True. Please verify that these samples will not invalidate the atmosphere of the glove box. Any damage that is done to the glove box will be billed to the user and could result in the loss of ECL privileges.";
Error::MultichannelPipetteRequired="The manipulations at indices, `2`, have MultichannelTransfer->True but do not have a Multichannel Pipette/Aspirator set for their Instrument option (`1`). If MultichannelTransfer->True, a multichannel pipette/aspirator must be used to perform the transfer. Please let the Instrument option resolve automatically.";
Error::MultiProbeHeadDimension="The manipulation(s) at manipulation indices `1` have DeviceChannel->{MultiProbeHead..} but the dimensions of the transfer do not fit the limitations of the MultiProbeHead. MultiProbeHead can only perform MxN transfer blocks of more than 12 samples without outliers and the same transfer amount and pipetting parameters must be used for all the channels. Please take this limitation into account when requesting MultiProbeHead manipulations.";
Error::MultiProbeHeadDispenseLLD="The manipulation(s) at manipulation indices `1` were designated as MxN transfers using MultiProbeHead and have DispensePosition set (or inherited from PipettingMethod) as LiquidLevel which is currently not supported due to the instrument limitations. Please revise your dispense options in order for your experiment call to work.";
Error::InvalidWasteAspiration="The destination can only be set as Waste if a Model[Instrument, Aspirator] is used as the transfer Instrument. At manipulation indices, `3`, the instrument is set as, `1`, but the destination is set as, `2`. Please change the Instrument option or destination to specify a valid transfer.";
Error::InvalidLayerLiquid="The samples, `1`, have the following options set for them, `2`, at manipulation indices, `3`. These options can only be set if these samples are Liquids at this time. Please do not specify these options for these samples until they are liquids (since non-liquids cannot have layers).";
Error::SupernatantAspirationLayerMismatch="The transfers at indices, `3`, have Supernatant set to, `1`, but have their AspirationLayer specified as, `2`. The aspiration layer is counted from the top, so Supernatant must be set to True if the AspirationLayer is set to 1. Please change these options or let them automatically resolve.";
Error::LayerInstrumentMismatch="The manipulations at indices, `2`, have the AspirationLayer/DestinationLayer option set but have their instruments set to, `1`. In order for the AspirationLayer/DestinationLayer option to be specified, the transfer must occur using a pipette, syringe, or aspirator. Please change these options to specify a valid transfer.";
Error::MagnetizationOptionsMismatch="The magnetization options (Magnetization/MagnetizationTime/MaxMagnetizationTime/MagnetizationRack) must either all be set or not set at all. At manipulation indices, `5`, the following options are set -- Magnetization->`1`, MagnetizationTime->`2`, MaxMagnetizationTime->`3`, MagnetizationRack->`4`. Please resolve these conflicting options.";
Error::CollectionContainerOptionsMismatch="The CollectionContainer options (CollectionContainer/CollectionTime) must either all be set or not set at all. At manipulation indices, `3`, the following options are set -- CollectionContainer->`1` and CollectionTime->`2`. Please resolve these conflicting options.";
Error::CollectionContainerFootprintMismatch="The CollectionContainer(s), `1`, at index, `4`, have the Footprint(s), `2`. However, the destination container(s) at these indices have Footprint(s), `3`. Since the CollectionContainer will be stacked underneath the destination container, they must have the same Footprint. Please specify a compatible CollectionContainer to proceeed.";
Error::MagneticRackMismatch="The given samples, `1`, at manipulation indices, `3`, will be in containers with footprint, `2`, but the given MagnetizationRack options are either not magnetic or cannot fit the given containers. If the source container cannot fit in a magnetic rack, the IntermediateContainer option will automatically resolve to a compatible container (as long as the volume is under 50mL, which is the largest magnetic rack at the ECL). Please let the MagnetizationRack/IntermediateContainer option automatically resolve.";
Error::InvalidAspirationAmount="The manipulations at indices, `3`, are specified to use an aspirator instrument, `1`, but have their amounts set to, `2`. The amount transferred must be All if an aspirator is specified since aspirators cannot transfer specific amounts. Please change the amount to be transferred in order to use an aspirator.";
Error::NoCompatibleTips="The source sample(s), `1`, at indices, `4`, have no compatible tips that can transfer the requested volume(s), `2`, that also satisfy the following requirements, `3`. When Preparation->Robotic, the tips must hold a volume that consists of (1) OverDispenseVolume, (2) Amount (taking into account the CorrectionCurve, if specified), and (3) OverAspirationVolume. Please change the tip requirements or manually specify the model of tips to use if you want to use a non-default tip model.";
Error::NoCompatibleSyringe="The source sample(s), `1`, at indices, `4`, do not have any compatible syringes that can hold a MaxVolume of at least `2` and also satisfy the requirements of `3`. Please manually specify a syringe model if there is a non-default model that you want to use. Otherwise, please choose a different transfer method.";
Error::IncompatibleRestrictOptions="The samples `1` are being both restricted and unrestricted. Please specify consistent options for the given samples using the options RestrictSource and RestrictDestination.";
Error::InvalidTransferPrecision = "Transfer requested of the Amount `1` is lower precision than the Precision option `2` at manipulation index `3`.";
Error::InvalidTransferSource = "The requested transfers cannot be completed because the sample position(s) does not contain a sample at manipulation index `1`. Please specify a source that has a sample object in it.";
Error::PositionOffsetOutOfBounds = "The following aspiration/dispense position offset(s), `1`, from wells `3` of the container models, `2`, at indices, `4`, are not within the horizontal (X) and vertical (Y) boundaries of the well. When specifying pipetting position offsets, an X and Y offset of {0 Millimeter, 0 Millimeter} indicates that the pipetting should occur from the center of the well. Please specify position offsets that are within the boundaries of the well.";
Error::CannotTiltNonPlate = "The following container(s), `1`, at positions, `2`, are specified to be tilted during the transfer via the AspirationMixType/DispenseMixType or AspirationAngle/DispenseAngle options. Only containers with Footprint->Plate can be tilted during a transfer. Please choose a different container for your transfer or do not set these options for non-plate containers.";
Error::IncompatibleTips="The specified tip(s), `1`, are indices, `3`, are not compatible for the specified transfer. Specified tips must (1) be able to hold the volume required for the transfer (plus OverAspirationVolume/OverDispenseVolume and accounting for CorrectionCurve if Preparation->Robotic), `2`, (2) be compatible with the TipType option, (3) be compatible with the TipMaterial option, (4) be compatible with the SterileTechnique option. Please let the Tips option resolve automatically or specify Tips that are compatible with the other Transfer options.";
Error::InvalidTransferSourceStorageCondition="The source model samples, `1`, will be fulfilled by ECL's resource system and cannot have their storage conditions set to `2`. Please remove SamplesInStorageCondition options for these samples.";
Warning::ReversePipettingSampleVolume = "The manipulations at indices, `2`, with the source sample(s), `1`, have ReversePipetting set to True. When reverse pipetting, 20% of the MaxVolume of the pipette is aspirated from the source sample (in addition to the requested transfer volume) and is discarded with the tip after the requested volume is dispensed into the destination sample. If the excess volume in the source sample is less than 20% of the MaxVolume of the pipette, the entirety of the sample will be consumed by this transfer. If you do not wish to transfer any excess volume out of the source sample, please set ReversePipetting to False.";
Error::AspirationMixVolumeOutOfTipRange = "The manipulations at indices, `1`, with the source sample(s), `2`, have requested AspirationMixVolume of `3`, which is not in the allowed volume range of tips `4`. Please correct the input by changing either the Tips or AspirationMixVolume options, or split the unit operation into a mix unit operation followed by a transfer unit operation.";
Error::DispenseMixVolumeOutOfTipRange = "The manipulations at indices, `1`, with the source sample(s), `2`, and destination sample(s), `3`, have requested DispenseMixVolume of `4`, which is not in the allowed volume range of tips `5`. Please correct the input by changing either the Tips or DispenseMixVolume options, or split the unit operation into a mix unit operation followed by a transfer unit operation.";
Warning::TooManyMixesWithMultichannelPipette="The manipulations at indices, `1`, are requesting using a multichannel pipette for `2` for `3` times (MultichannelTransfer set to True), which can lead to inadequate mixing given the difficulty of multichannel pipette mixing operations in lab. Please consider setting Preparation to Robotic, decreasing `4` to be less equal than `5`, and/or setting MultichannelTransfer to False/Automatic to allow each well to be mixed individually.";
Error::InvalidTransferNonDisposalSourceStorageCondition = "The source samples, `1`, are in containers that cannot be re-covered, therefore cannot have their storage conditions set to `2`. Please set SamplesInStorageCondition to Disposal for these samples.";
Error::NoTransferEnvironmentAvailable = " The manipulation(s) at indices, `1`, cannot find an available TransferEnvironment to transfer from source(s), `2`, to destination(s), `3`, for the following reasons: `4`. Please correct the input accordingly and try again.";
Error::InvalidTransferEnvironment = "The manipulation(s) at indices, `1` have TransferEnvironment, `2`, that is not suitable for the transfer due to the following reasons: `3`. Please correct the relevant options accordingly and try again.";
Error::VolatileHazardousSamplesInBSC = "Recirculating biosafety cabinets cannot safely handle volatile hazardous materials. `1` Please use alternative chemicals or use a chemical fume hood as the TransferEnvironment.";

(*ExperimentTransfer*)

(* -- Secret Overloads --*)
singletonSourceP = ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | {_Integer, ObjectP[Model[Container]]} | {_String, ObjectP[Object[Container]]};
singletonDestinationP = ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}] | {_Integer, ObjectP[Model[Container]]} | {_String, ObjectP[Object[Container]]} | Waste;
singletonAmountP = VolumeP | MassP | CountP | All;

(* ExperimentTransfer[{a, a, a}, b, c] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentTransfer[
	mySources:{singletonSourceP..},
	myDestination:singletonDestinationP,
	myAmount:singletonAmountP,
	myOptions:OptionsPattern[]
] := ExperimentTransfer[mySources, ConstantArray[myDestination, Length[mySources]], ConstantArray[myAmount, Length[mySources]], myOptions];


(* ExperimentTransfer[a, b, {c, c, c}] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentTransfer[
	mySource:singletonSourceP,
	myDestination:singletonDestinationP,
	myAmounts:{singletonAmountP..},
	myOptions:OptionsPattern[]
] := ExperimentTransfer[ConstantArray[mySource, Length[myAmounts]], ConstantArray[myDestination, Length[myAmounts]], myAmounts, myOptions];


(* ExperimentTransfer[a, {b, b, b}, c] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentTransfer[
	mySource:singletonSourceP,
	myDestinations:{singletonDestinationP..},
	myAmount:singletonAmountP,
	myOptions:OptionsPattern[]
] := ExperimentTransfer[ConstantArray[mySource, Length[myDestinations]], myDestinations, ConstantArray[myAmount, Length[myDestinations]], myOptions];


(* ExperimentTransfer[{a, a, a}, {b, b, b}, c] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentTransfer[
	mySources:{singletonSourceP..},
	myDestinations:{singletonDestinationP..},
	myAmount:singletonAmountP,
	myOptions:OptionsPattern[]
] := ExperimentTransfer[mySources, myDestinations, ConstantArray[myAmount, Length[myDestinations]], myOptions];


(* ExperimentTransfer[{a, a, a}, b, {c, c, c}] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentTransfer[
	mySources:{singletonSourceP..},
	myDestination:singletonDestinationP,
	myAmounts:{singletonAmountP..},
	myOptions:OptionsPattern[]
] := ExperimentTransfer[mySources, ConstantArray[myDestination, Length[mySources]], myAmounts, myOptions];


(* ExperimentTransfer[a, {b, b, b}, {c, c, c}] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentTransfer[
	mySource:singletonSourceP,
	myDestinations:{singletonDestinationP..},
	myAmounts:{singletonAmountP
		..},
	myOptions:OptionsPattern[]
] := ExperimentTransfer[ConstantArray[mySource, Length[myDestinations]], myDestinations, myAmounts, myOptions];


(* -- Main Overload --*)
(* NOTE: No container to sample overload because we handle it specially inside of the function. *)
(* NOTE: If you're looking for a function to copy for your primitive, do NOT pick this one. It is not standard. *)
ExperimentTransfer[
	{
		mySources:ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}],
		myDestinations:ListableP[ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}|Waste],
		myAmounts:ListableP[VolumeP|MassP|CountP|All]
	},
	myOptions:OptionsPattern[]
]:=ExperimentTransfer[
	mySources, myDestinations, myAmounts, myOptions
];

ExperimentTransfer[
	mySources:ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}],
	myDestinations:ListableP[ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}|Waste],
	myAmounts:ListableP[VolumeP|MassP|CountP|All],
	myOptions:OptionsPattern[]
]:=Module[
	{
		listedOptions,cache,outputSpecification,output,gatherTests,messages,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,transferOptionsAssociation,listedAmounts,listedDestinations,
		listedSources,initialSimulation,

		objectsExistTests,objectsExistQs,simulatedSampleQ,userSpecifiedObjects,

		cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePacketTests,
		result,resourceResult,performSimulationQ,returnEarlyBecauseFailuresQ,simulatedProtocol,simulation,resolvedPreparation,
		resolvedWorkCell,
		sourcesWithoutTemporalLinks, destinationsWithoutTemporalLinks, listedSourcesNamed, listedDestinationsNamed,
		safeOpsNamed, listedOptionsNamed, returnEarlyBecauseOptionsResolverOnly, optionsResolverOnly, initialFastAssoc,
		suppliedInstrument,suppliedBalance,suppliedTips,suppliedNeedles,suppliedWeighingContainers,suppliedHandPumps,suppliedQuantitativeTransferWashSolution,
		suppliedQuantitativeTransferWashInstrument,suppliedQuantitativeTransferWashTips,suppliedBackfillNeedle,suppliedVentingNeedle,suppliedTipRinseSolution,
		suppliedIntermediateContainer,suppliedDestinationWells,suppliedTransferEnvironments,suppliedFunnels,suppliedIntermediateFunnel,
		suppliedSourceWells,suppliedMagnetizationRacks,suppliedKeepInstruments,suppliedDestinationRack, suppliedPipettingMethod, parentProtocol, preparedResources, suppliedCollectionContainers,

		objectSampleFields, objectSamplePacketFields, modelSamplePacketFields, objectContainerFields, objectContainerPacketFields,
		modelContainerFields, modelContainerPacketFields, productFields, pipettingMethodFields, pipettingMethodPacketFields,
		simulatedSampleObjects, simulatedContainerObjects, simulatedSampleModels, simulatedDestinationSamples,
		simulatedDestinationContainerObjects, simulatedCollectionContainerObjects, allTransferModelPackets,

		downloadObjects, downloadFields, simulatedSources, simulatedDestinations, listedSourcesAndDests,
		allDownloadedStuff, userSpecifiedObjectsStatus, notDiscardedSampleQs, samplesNotDiscardedTests
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* remove all temporal links *)
	(* quieting because we could throw an ObjectDoesNotExist error here, but if we do we will already do that in a more robust way later so silence it for now *)
	{{sourcesWithoutTemporalLinks, destinationsWithoutTemporalLinks}, listedOptionsNamed} = removeLinks[{mySources, myDestinations}, ToList[myOptions]];

	cache = Lookup[listedOptionsNamed, Cache, {}];
	initialFastAssoc = makeFastAssocFromCache[cache];
	initialSimulation = Lookup[listedOptionsNamed, Simulation, Null];

	(* ToList doesn't work on sources/destinations because we can have {_Integer, Model[Container]} and that's already in a list. *)
	listedSourcesNamed=If[MatchQ[sourcesWithoutTemporalLinks, {_Integer|_String, _}],
		{sourcesWithoutTemporalLinks},
		ToList[sourcesWithoutTemporalLinks]
	];
	listedDestinationsNamed=If[MatchQ[destinationsWithoutTemporalLinks, {_Integer|_String, _}],
		{destinationsWithoutTemporalLinks},
		ToList[destinationsWithoutTemporalLinks]
	];
	listedAmounts=ToList[myAmounts];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentTransfer,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentTransfer,listedOptionsNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	(* important for the first variable here to be a signle one because it could return $Failed and we don't want a set error *)
	{listedSourcesAndDests, safeOps, listedOptions} = sanitizeInputs[{listedSourcesNamed, listedDestinationsNamed}, safeOpsNamed, listedOptionsNamed, Simulation -> initialSimulation];
	{listedSources, listedDestinations} = If[MatchQ[listedSourcesAndDests, $Failed],
		{$Failed, $Failed},
		listedSourcesAndDests
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentTransfer,{listedSources,listedDestinations,listedAmounts},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentTransfer,{listedSources,listedDestinations,listedAmounts},listedOptions],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentTransfer,{listedSources,listedDestinations,listedAmounts},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentTransfer,{listedSources,listedDestinations,listedAmounts},listedOptions],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentTransfer,{listedSources,listedDestinations,listedAmounts},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* - Throw an error if any of the specified input objects or objects in Options are not members of the database - *)
	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten[{listedSources,listedDestinations,myOptions}],
		ObjectReferenceP[]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ = TrueQ[fastAssocLookup[initialFastAssoc, #, Simulated]]&/@userSpecifiedObjects;
	objectsExistQs = DatabaseMemberQ[PickList[userSpecifiedObjects,simulatedSampleQ,False], Simulation->initialSimulation];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests,objectsExistTests],
			Options -> $Failed,
			Preview -> Null,
			RunTime -> 0 Minute
		}]
	];

	userSpecifiedObjectsStatus = Quiet[
		Download[userSpecifiedObjects, Status, Cache -> cache, Simulation -> initialSimulation],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::ObjectDoesNotExist}
	];

	notDiscardedSampleQs = MatchQ[#, Except[Discarded]]& /@ userSpecifiedObjectsStatus;

	(* Build tests for discarded samples *)
	samplesNotDiscardedTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` has not been discarded:"][#1], #2, True]&,
			{userSpecifiedObjects, notDiscardedSampleQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@notDiscardedSampleQs),
		If[!gatherTests,
			Message[Error::DiscardedSamples, PickList[userSpecifiedObjects, notDiscardedSampleQs, False]];
			Message[Error::InvalidInput, PickList[userSpecifiedObjects, notDiscardedSampleQs, False]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, objectsExistTests, samplesNotDiscardedTests],
			Options -> safeOps,
			Preview -> Null,
			RunTime -> 0 Minute
		}]
	];


	(* Turn the expanded safe ops into an association so we can lookup information from it*)
	transferOptionsAssociation=Association[expandedSafeOps];

	(* --- make our big Download here so we can pass our cache to the resolver and to the resource packets function --- *)

	(* Resolve our sample prep options *)
	simulatedSources = ToList[mySources]/.{obj:ObjectP[]:>Download[obj, Object]};

	(* Our destinations will not be simulated since sample prep only applies to the sources. *)
	simulatedDestinations = myDestinations /. {obj : ObjectP[] :> Download[obj, Object]};

	(* Pull the info out of the options that we need to download from *)
	{
		suppliedInstrument, suppliedBalance, suppliedTips, suppliedNeedles, suppliedWeighingContainers, suppliedHandPumps, suppliedQuantitativeTransferWashSolution,
		suppliedQuantitativeTransferWashInstrument, suppliedQuantitativeTransferWashTips, suppliedBackfillNeedle, suppliedVentingNeedle, suppliedTipRinseSolution,
		suppliedIntermediateContainer, suppliedDestinationWells, suppliedTransferEnvironments, suppliedFunnels, suppliedIntermediateFunnel,
		suppliedSourceWells, suppliedMagnetizationRacks, suppliedKeepInstruments, suppliedDestinationRack, suppliedPipettingMethod, parentProtocol, preparedResources, suppliedCollectionContainers
	} = Lookup[transferOptionsAssociation,
		{
			Instrument, Balance, Tips, Needle, WeighingContainer, HandPump, QuantitativeTransferWashSolution, QuantitativeTransferWashInstrument,
			QuantitativeTransferWashTips, BackfillNeedle, VentingNeedle, TipRinseSolution,
			IntermediateContainer, DestinationWell, TransferEnvironment, Funnel, IntermediateFunnel,
			SourceWell, MagnetizationRack, KeepInstruments, DestinationRack, PipettingMethod, ParentProtocol, PreparedResources, CollectionContainer
		}
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSampleFields = DeleteDuplicates[Flatten[{Composition, Solvent, Parafilm, AluminumFoil, PipettingMethod, TransferTemperature, TransportCondition,
		KeepCovered, Position, Well, Density, ReversePipetting, ParticleWeight, Volume, Mass, SampleHandling, Fuming, Ventilated, Anhydrous,
		Living, CellType, InertHandling, AsepticHandling, Pyrophoric, State, Container, IncompatibleMaterials, Notebook, SamplePreparationCacheFields[Object[Sample]]}]];
	objectSamplePacketFields = Packet @@ objectSampleFields;
	modelSamplePacketFields = Packet @@ Flatten[{Parafilm, AluminumFoil, PipettingMethod, TransferTemperature, TransportCondition, Living, Anhydrous,
		Density, Products, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}];
	objectContainerFields = DeleteDuplicates[Flatten[{Hermetic, PreviousCover, Cover, Septum, Parafilm, AluminumFoil, KeepCovered, Notebook,
		Name, Status, Sterile, Counted, TareWeight, Weight, SolutionVolume, Dimensions,Footprint,InternalDepth,StorageCondition,ContainerMaterials, RequestedResources, KitComponents, Site, SamplePreparationCacheFields[Object[Container]]}]];
	objectContainerPacketFields = Packet @@ objectContainerFields;
	modelContainerFields = DeleteDuplicates[Flatten[{MultiProbeHeadIncompatible, BuiltInCover, CoverTypes,
		CoverFootprints, Dimensions,Footprint,InternalDepth,Parafilm, AluminumFoil, CoverType, CoverFootprint, CrimpType, SeptumRequired, Opaque,
		Reusable, EngineDefault, NotchPositions, SealType, HorizontalPitch, VerticalPitch, VolumeCalibrations, Columns,
		Aperture, WellDepth, Sterile, RNaseFree, Squeezable, Material, Counted, TareWeight, Weight, SolutionVolume, Object, Positions, Hermetic, Ampoule, MaxVolume,
		IncompatibleMaterials,ContainerMaterials, StorageBuffer, StorageBufferVolume, Products,FunnelStemDiameter,FunnelStemLength,Graduations, GraduationType, GraduationLabels, CrossSectionalShape, SamplePreparationCacheFields[Model[Container]]}]];
	modelContainerPacketFields = Packet @@ modelContainerFields;
	productFields = {Name, ProductModel, KitComponents, DefaultContainerModel, Deprecated};
	pipettingMethodFields = {Name, AspirationEquilibrationTime, AspirationMixRate, AspirationPosition, AspirationPositionOffset,
		AspirationRate, AspirationWithdrawalRate, CorrectionCurve, DispenseEquilibrationTime, DispenseMixRate, DispensePosition,
		DispensePositionOffset, DispenseRate, DispenseWithdrawalRate, DynamicAspiration, OverAspirationVolume, OverDispenseVolume};
	pipettingMethodPacketFields = Packet @@ pipettingMethodFields;

	simulatedSampleObjects = DeleteDuplicates@Cases[simulatedSources, ObjectP[Object[Sample]]];
	simulatedContainerObjects = DeleteDuplicates@Cases[Flatten[simulatedSources], ObjectP[Object[Container]]];
	simulatedSampleModels = DeleteDuplicates@Cases[simulatedSources, ObjectP[Model[Sample]]];
	simulatedDestinationSamples = DeleteDuplicates@Cases[Flatten[{simulatedDestinations}], ObjectP[Object[Sample]]];
	simulatedDestinationContainerObjects = DeleteDuplicates@Cases[Flatten[{simulatedDestinations}], ObjectP[{Object[Container], Object[Item]}]];
	simulatedCollectionContainerObjects = DeleteDuplicates@Cases[Flatten[Lookup[transferOptionsAssociation, CollectionContainer]], ObjectP[{Object[Container]}]];

	(* gather together everything we're Downloading from *)
	downloadObjects = {
		(* NOTE: If we were given a container with samples in it, we would have been converted to a sample by now. *)
		(* If we have a container as a source or destination, that means that it is empty when we start. *)
		(*1*)simulatedSampleObjects,
		(*2*)simulatedSampleObjects,
		(*3*)simulatedSampleObjects,
		(*4*)simulatedSampleObjects,
		(*5*)simulatedSampleObjects,

		(*6*)DeleteDuplicates@Download[Cases[simulatedSources, ObjectP[], Infinity], Object],
		(*7*)DeleteDuplicates@Download[Cases[simulatedSources, ObjectP[], Infinity], Object],

		(*8*)simulatedContainerObjects,
		(*8b*)simulatedContainerObjects,
		(*9*)simulatedContainerObjects,
		(*10*)simulatedContainerObjects,
		(*11*)simulatedContainerObjects,
		(*12*)simulatedContainerObjects,

		(*13*)simulatedSampleModels,
		(*14*)simulatedSampleModels,
		(*15*)simulatedSampleModels,

		(*16*)simulatedDestinationSamples,
		(*17*)simulatedDestinationSamples,
		(*18*)simulatedDestinationSamples,
		(*19*)simulatedDestinationSamples,
		(*20*)simulatedDestinationSamples,

		(*21*)simulatedDestinationContainerObjects,
		(*22*)simulatedDestinationContainerObjects,
		(*23*)simulatedDestinationContainerObjects,
		(*24*)simulatedDestinationContainerObjects,
		(*25*)simulatedDestinationContainerObjects,

		(* Note that {_Integer, Model[Container]} syntax is allowed in our source list. *)
		(* Always download Model[Container, Vessel, "id:aXRlGnZmOOB9"] since we use a 10L Carboy to simulate waste destinations. *)
		(*26*)DeleteDuplicates[
			Download[
				Flatten[{
					Model[Container, Vessel, "id:aXRlGnZmOOB9"],
					Cases[Flatten[{simulatedSources, simulatedDestinations}], ObjectP[Model[Container]]],
					Cases[Flatten[{simulatedSources, simulatedDestinations}], {_Integer, ObjectP[Model[Container]]}][[All, 2]]
				}],
				Object
			]
		],

		(*27*)DeleteDuplicates@Cases[suppliedInstrument, ObjectP[Object[]]],

		(*28*)DeleteDuplicates@Cases[suppliedBalance, ObjectP[Object[]]],

		(*29*)DeleteDuplicates@Cases[Flatten[{suppliedTips, suppliedQuantitativeTransferWashTips}], ObjectP[Object[Item, Tips]]],

		(*30*)DeleteDuplicates@Cases[Flatten[{suppliedNeedles, suppliedBackfillNeedle, suppliedVentingNeedle}], ObjectP[Object[Item, Needle]]],

		(*31*)DeleteDuplicates@Cases[suppliedInstrument, ObjectP[Object[Item, Spatula]]],

		(*32*)DeleteDuplicates@Cases[suppliedInstrument, ObjectP[Object[Container, GraduatedCylinder]]],

		(*33*)DeleteDuplicates@Cases[Flatten[{suppliedWeighingContainers, suppliedCollectionContainers}], ObjectP[Object[]]],

		(*34*)DeleteDuplicates@Cases[suppliedHandPumps, ObjectP[Object[Part, HandPump]]],

		(* want to Download from the models and objects for the quantitative transfer wash solution and tip rinse solution *)
		(*35*)DeleteDuplicates@Cases[suppliedQuantitativeTransferWashSolution, ObjectP[{Model[Sample], Object[Sample]}]],
		(*36*)DeleteDuplicates@Cases[suppliedTipRinseSolution, ObjectP[{Model[Sample], Object[Sample]}]],
		(*37*)DeleteDuplicates@Cases[suppliedIntermediateContainer, ObjectP[Object[Container]]],
		(*38*)DeleteDuplicates@Cases[suppliedIntermediateContainer, ObjectP[Model[Container]]],

		(*39*)DeleteDuplicates@Cases[suppliedTransferEnvironments, ObjectP[Object[]]],

		(*40*)DeleteDuplicates@Cases[Flatten[{suppliedFunnels, suppliedIntermediateFunnel}], ObjectP[Object[]]],

		(*41*)DeleteDuplicates@Cases[suppliedMagnetizationRacks, ObjectP[Object[Container, Rack]]],

		(*42*)DeleteDuplicates@Download[Cases[Flatten[{suppliedPipettingMethod, Model[Method, Pipetting, "id:qdkmxzqkJlw1"]}], ObjectP[Model[Method, Pipetting]], Infinity], Object],

		(*43*){$PersonID},

		(*44*){parentProtocol},

		(*45*)ToList[preparedResources],

		(*46*)simulatedCollectionContainerObjects,
		(*47*)simulatedCollectionContainerObjects,
		(*48*)Flatten[{simulatedCollectionContainerObjects,simulatedContainerObjects}],
		(*49*)simulatedSampleObjects,
		(*50*){$DefaultQuantitativeTransferWashSolution}
	};
	downloadFields = {
		(*1*)List@objectSamplePacketFields,
		(*2*)List@Packet[Container[objectContainerFields]],
		(*3*)List@Packet[Container[Model][modelContainerFields]],
		(*4*)List@Packet[Container[Model][VolumeCalibrations][{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]],
		(*5*){Packet[PipettingMethod[pipettingMethodFields]], Packet[Solvent[PipettingMethod][pipettingMethodFields]], Packet[Field[Composition[[All, 2]]][PipettingMethod][pipettingMethodFields]]},

		(*6*)List@Packet[Field[Composition[[All, 2]][{PipettingMethod}]]],
		(*7*)List@Packet[Solvent[{PipettingMethod}]],

		(*8*)List@Packet[Field[Contents[[All, 2]]][objectSampleFields]],
		(*8b*)List@Packet[Field[Contents[[All, 2]][Composition][[All, 2]][{PipettingMethod}]]],
		(*9*)List@objectContainerPacketFields,
		(*10*)List@Packet[Model[modelContainerFields]],
		(*11*)List@Packet[Model[VolumeCalibrations][{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]],
		(*12*)List@Packet[Field[Contents[[All, 2]]][PipettingMethod][pipettingMethodFields]],

		(*13*)List@modelSamplePacketFields,
		(*14*){
			Packet[Products[productFields]],
			Packet[Products[DefaultContainerModel][modelContainerFields]],
			Packet[KitProducts[productFields]],
			Packet[KitProducts[DefaultContainerModel][modelContainerFields]]
		},
		(*15*){Packet[PipettingMethod[pipettingMethodFields]], Packet[Solvent[PipettingMethod][pipettingMethodFields]], Packet[Field[Composition[[All, 2]]][PipettingMethod][pipettingMethodFields]]},

		(*16*)List@objectSamplePacketFields,
		(*17*)List@Packet[Container[objectContainerFields]],
		(*18*)List@Packet[Container[Model][modelContainerFields]],
		(*19*)List@Packet[Container[Model][VolumeCalibrations][{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]],
		(*20*)List@Packet[PipettingMethod[pipettingMethodFields]],

		(*21*)List@Packet[Field[Contents[[All, 2]]][objectSampleFields]],
		(*22*)List@objectContainerPacketFields,
		(*23*)List@Packet[Model[modelContainerFields]],
		(*24*)List@Packet[Container[Model][VolumeCalibrations][{CalibrationFunction}]],
		(*25*)List@Packet[Field[Contents[[All, 2]]][PipettingMethod][pipettingMethodFields]],

		(*26*){modelContainerPacketFields, Packet[VolumeCalibrations[{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]]},

		(*27*)List@Packet[Object, Model], (* suppliedInstrumentObjectPackets *)

		(*28*){Packet[Object, Container, Model],Packet[Container[Container]]}, (* suppliedBalanceObjectPackets *)

		(*29*){Packet[Model, Status], Packet[Model[{Object, Name, Sterile, PipetteType, RNaseFree, WideBore, Filtered, Aspirator, GelLoading, Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips}]]}, (* suppliedTipObjectPackets *)

		(*30*){Packet[Model, Status], Packet[Model[{Name, Sterile, ConnectionType, Gauge, InnerDiameter, NeedleLength}]]}, (* suppliedNeedles *)

		(*31*){Packet[Model, Status], Packet[Model[{Name, Material, TransferVolume, Reusable,NarrowEndWidth, WideEndWidth, Counted, CleaningMethod, EngineDefault}]]}, (* suppliedSpatulaPackets *)

		(*32*){Packet[Model, Status], Packet[Model[{Name, Sterile, RNaseFree, MaxVolume, Resolution, Material}]]}, (* suppliedGraduatedCylinderPackets. *)

		(*33*){Packet[Model, Status], Packet[Model[modelContainerFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]]}, (* suppliedWeighingContainerPackets *)

		(*34*)List@Packet[Object,Model], (* suppliedHandPumps *)

		(*35*){Packet[Object, Volume, Container, IncompatibleMaterials, Density, Fuming, Ventilated], Packet[Container[objectContainerFields]], Packet[Container[Model][modelContainerFields]]}, (* suppliedQuantitativeTransferWashSolution *)

		(*36*)List@Packet[Object, Volume, Container, IncompatibleMaterials, Fuming, Ventilated], (* suppliedTipRinseSolutionPackets *)

		(*37*){Packet[Model[modelContainerFields]], objectContainerPacketFields, Packet[Model[VolumeCalibrations][{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]]}, (* suppliedIntermediateContainerObjectPackets *)
		(*38*){modelContainerPacketFields, Packet[VolumeCalibrations[{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]]}, (* suppliedIntermediateContainerModelPackets *)

		(* NOTE: Kind of weird, but we have the balances of each transfer environment also included in these packet lists. *)
		(* This is to make sure that we can fulfill the requested balance after given a transfer environment. *)

		(* NOTE: We also download the contents of these transfer environment objects to see what pipettes are stored in them. *)
		(*39*){Packet[Model, Contents, Pipettes, Balances, IRProbe, SchlenkLine, BiosafetyWasteBin, Status, DeveloperObject, Site], Packet[Pipettes[{Model}]], Packet[Balances[{Model}]], Packet[Balances[Model][{Mode, MinWeight, AllowedMaxVariation}]], Packet[Model[{Positions, AsepticHandling, DefaultBiosafetyWasteBinModel, CultureHandling, BalanceType, Objects, DeveloperObject, ProvidedHandlingConditions, LocalCacheContents}]]}, (* suppliedTransferEnvironmentPackets *)

		(*40*){Packet[Model[{Name, StemDiameter, FunnelType}]], Packet[Model]}, (* suppliedFunnelPackets *)

		(*41*){Packet[Model[{Name, Magnetized, Positions}]], Packet[Model]}, (* suppliedRackPackets *)

		(*42*){pipettingMethodPacketFields}, (*suppliedPipettingMethod*)

		(*43*){
			Packet[FinancingTeams[{Notebooks, NotebooksFinanced}]],
			Packet[SharingTeams[{Notebooks, NotebooksFinanced, ViewOnly}]]
		},

		(*44*){
			Packet[ParentProtocol, PreparedResources, OutputUnitOperations, Site, Author],
			Packet[Repeated[ParentProtocol][{ParentProtocol, Author, Site}]],
			Packet[Repeated[ParentProtocol][Author][{FinancingTeams, SharingTeams}]],
			Packet[Repeated[ParentProtocol][Author][FinancingTeams][{Notebooks, NotebooksFinanced}]],
			Packet[Repeated[ParentProtocol][Author][SharingTeams][{Notebooks, NotebooksFinanced, ViewOnly}]],
			Packet[Author[FinancingTeams][{Notebooks, NotebooksFinanced}]],
			Packet[Author[SharingTeams][{Notebooks, NotebooksFinanced, ViewOnly}]],
			Packet[PreparedResources[{RentContainer, Fresh}]]
		},

		(*45*){Packet[RentContainer, Fresh]},

		(*46*)List@objectContainerPacketFields,
		(*47*)List@Packet[Model[modelContainerFields]],
		(*48*){
			Packet[Cover[{Reusable, Model, Name}]],
			Packet[Cover[Model][{CoverType, CoverFootprint, CrimpType, SeptumRequired, TaperGroundJointSize, Opaque, Reusable, EngineDefault, Barcode, CrimpingPressure, Name}]]
		},
		(*49*){
			Packet[Container[Cover][{Reusable, Model, Name}]],
			Packet[Container[Cover][Model][{CoverType, CoverFootprint, CrimpType, SeptumRequired, TaperGroundJointSize, Opaque, Reusable, EngineDefault, Barcode, CrimpingPressure, Name}]]
		},
		(*50*){Packet[Object, Volume, Container, IncompatibleMaterials,Density], Packet[Container[objectContainerFields]], Packet[Container[Model][modelContainerFields]]} (* $DefaultQuantitativeTransferWashSolution *)
	};

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	allDownloadedStuff = Quiet[
		Download[
			downloadObjects,
			Evaluate[downloadFields],
			Cache -> Flatten[{cache}],
			Simulation -> initialSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::ObjectDoesNotExist}
	];

	(* pull out the transfer model packets right now up front *)
	allTransferModelPackets = transferModelPackets[expandedSafeOps];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[{cache, allDownloadedStuff, allTransferModelPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentTransferOptions[
			listedSources,
			listedDestinations,
			listedAmounts,
			expandedSafeOps,
			Simulation->initialSimulation,
			Cache->cacheBall,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentTransferOptions[
				listedSources,
				listedDestinations,
				listedAmounts,
				expandedSafeOps,
				Simulation->initialSimulation,
				Cache->cacheBall
			],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentTransfer,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];
	resolvedWorkCell = Lookup[resolvedOptions, WorkCell];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* NOTE: We need to perform simulation if Result is asked for in Transfer since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	performSimulationQ = MemberQ[output, Result | Simulation];

	(* If option resolution failed (or we're asked to return early) and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->If[MatchQ[Lookup[listedOptions, FillToVolume], True] || MatchQ[Lookup[listedOptions, InSitu], True],
				collapsedResolvedOptions,
				RemoveHiddenOptions[ExperimentTransfer,collapsedResolvedOptions]
			],
			Preview->Null,
			Simulation->Simulation[],
			RunTime -> 0 Minute
		}]
	];

	(* Build packets with resources *)
	(* resourceResult is in the form {protocolPacket, unitOperationPackets} or $Failed. *)
	{resourceResult, resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
			{$Failed, {}},
		MatchQ[gatherTests, True],
			transferResourcePackets[
				listedSources,
				listedDestinations,
				Lookup[resolvedOptions, Amount],
				templatedOptions,
				resolvedOptions,
				Simulation -> initialSimulation,
				Cache -> cacheBall,
				Output -> {Result, Tests}
			],
		True,
			{
				transferResourcePackets[
					listedSources,
					listedDestinations,
					Lookup[resolvedOptions, Amount],
					templatedOptions,
					resolvedOptions,
					Simulation -> initialSimulation,
					Cache -> cacheBall
				],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentTransfer[
			If[MatchQ[resourceResult, $Failed],
				$Failed,
				resourceResult[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourceResult, $Failed],
				$Failed,
				ToList[resourceResult[[2]]] (* unitOperationPackets *)
			],
			listedSources,
			listedDestinations,
			Lookup[resolvedOptions, Amount],
			resolvedOptions,
			Cache->cacheBall,
			(* if upload false, we may have some cloud file packets in the transferResourcePackets return *)
			Simulation->initialSimulation,
			ParentProtocol->Lookup[safeOps,ParentProtocol]
		],
		{Null, initialSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			(* We will have to pass this hidden option into the unit operation since we need this to decide the resource renting and preparation (fresh) later.
			Only do that if we need to rent a container or prepare fresh resource, which means we are in a sub anyway *)
			(* Also, we need to pass the resolved supplementalCertification options to top level SP primitive functions so top-level protocol get the correct certificates populated *)
			Options -> Which[
				MatchQ[Lookup[listedOptions, FillToVolume], True] || MatchQ[Lookup[listedOptions, InSitu], True],
					collapsedResolvedOptions,
				Or[
					MemberQ[ToList@Lookup[collapsedResolvedOptions,RentDestinationContainer,False],True],
					MemberQ[ToList@Lookup[collapsedResolvedOptions,Fresh,False],True]
				],
					RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {RentDestinationContainer, Fresh, SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition,WasteContainer}],
				True,
					RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition,WasteContainer}]
			],
			Preview -> Null,
			Simulation->simulation,
			(* The time to process a multichannel group is the max of the magnetization times in that group plus 15 seconds per transfer. *)
			(* So compute this value for each group then sum *)
			RunTime -> transferRunTime[resolvedOptions]
		}]
	];

	(* If told to return the raw resource packets, do that. *)
	If[MatchQ[Lookup[safeOps, UploadResources], False],
		Return[outputSpecification /. {
			Result -> resourceResult,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			(* We will have to pass this hidden option into the unit operation since we need this to decide the resource renting and preparation (fresh) later.
			Only do that if we need to rent a container or prepare fresh resource, which means we are in a sub anyway *)
			(* Also, we need to pass the resolved supplementalCertification options to top level SP primitive functions so top-level protocol get the correct certificates populated *)
			Options -> Which[
				MatchQ[Lookup[listedOptions, FillToVolume], True] || MatchQ[Lookup[listedOptions, InSitu], True],
					collapsedResolvedOptions,
				Or[
					MemberQ[ToList@Lookup[collapsedResolvedOptions,RentDestinationContainer,False],True],
					MemberQ[ToList@Lookup[collapsedResolvedOptions,Fresh,False],True]
				],
					RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {RentDestinationContainer, Fresh, SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition,WasteContainer}],
				True,
					RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition, WasteContainer}]
			],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourceResult,$Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
			resourceResult[[2]], (* unitOperationPackets only, we do not create cloud file for pipette dial images in robotic case *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation or ExperimentRoboticCellPreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive, nonHiddenOptions},
				(* Create our transfer primitive to feed into RoboticSamplePreparation or RoboticCellPreparation. *)
				primitive=Transfer@@Join[
					{
						Source->mySources,
						Destination->myDestinations,
						Amount->myAmounts
					},
					RemoveHiddenPrimitiveOptions[Transfer,ToList[myOptions]],
					(* We will have to pass this hidden option into the unit operation since we need this to decide the resource renting later. Only do that if we need to rent a container, which means we are in a sub anyway *)
					{
						RentDestinationContainer->Lookup[collapsedResolvedOptions,RentDestinationContainer,False],
						Fresh->Lookup[collapsedResolvedOptions,Fresh,False]
					}
				];

				(* Remove any hidden options before returning. *)
				(* We will have to pass this hidden option into the unit operation since we need this to decide the resource renting and preparation (fresh) later.
				Only do that if we need to rent a container or prepare fresh resource, which means we are in a sub anyway *)
				(* Also, we need to pass the resolved supplementalCertification options to top level SP primitive functions so top-level protocol get the correct certificates populated *)
				nonHiddenOptions = If[
					Or[
						MemberQ[ToList@Lookup[collapsedResolvedOptions, RentDestinationContainer, False], True],
						MemberQ[ToList@Lookup[collapsedResolvedOptions, Fresh, False], True]
					],
					RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {RentDestinationContainer, Fresh, SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition, WasteContainer}],
					RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition, WasteContainer}]
				];

				(* Memoize the value of ExperimentTransfer so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentTransfer, $PrimitiveFrameworkResolverOutputCache, experimentFunction},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentTransfer]={};

					ExperimentTransfer[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Result -> resourceResult[[2]],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> transferRunTime[resolvedOptions]
						}
					];

					(* pick the corresponding function from the association above *)
					experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];

					experimentFunction[
						{primitive},
						Name -> Lookup[safeOps, Name],
						Upload -> Lookup[safeOps, Upload],
						Confirm -> Lookup[safeOps, Confirm],
						CanaryBranch -> Lookup[safeOps, CanaryBranch],
						ParentProtocol -> Lookup[safeOps, ParentProtocol],
						Priority -> Lookup[safeOps, Priority],
						StartDate -> Lookup[safeOps, StartDate],
						HoldOrder -> Lookup[safeOps, HoldOrder],
						QueuePosition -> Lookup[safeOps, QueuePosition],
						Cache -> cacheBall,
						Simulation -> simulation,

						(* NOTE: This is a Transfer specific option. Do NOT copy it. *)
						OrderFulfilled -> Lookup[safeOps, OrderFulfilled],
						PreparedResources -> Lookup[safeOps, PreparedResources]
					]
				]
			],

		(* If we're doing Preparation->Manual AND our ParentProtocol isn't ManualSamplePreparation or ManualCellPreparation, generate one *)
		(* NOTE: Transfer doesn't have sample prep options so don't copy this one. *)
		!MatchQ[Lookup[safeOps,ParentProtocol], ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]}]],
			Module[{primitive, nonHiddenOptions, experimentFunction},
				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				primitive=Transfer@@Join[
					{
						Source->mySources,
						Destination->myDestinations,
						Amount->myAmounts
					},
					RemoveHiddenPrimitiveOptions[Transfer,ToList[myOptions]],
					(* We will have to pass this hidden option into the unit operation since we need this to decide the resource renting and preparation (fresh) later. Only do that if we need to rent a container or prepare fresh resource, which means we are in a sub anyway *)
					{
						RentDestinationContainer->Lookup[collapsedResolvedOptions,RentDestinationContainer,False],
						Fresh->Lookup[collapsedResolvedOptions,Fresh,False]
					}
				];

				(* Remove any hidden options before returning (with some exceptions). *)
				(* We will have to pass this hidden option into the unit operation since we need this to decide the resource renting and preparation (fresh) later.
				Only do that if we need to rent a container or prepare fresh resource, which means we are in a sub anyway *)
				(* Also, we need to pass the resolved supplementalCertification options to top level SP primitive functions so top-level protocol get the correct certificates populated *)
				nonHiddenOptions=Which[
					MatchQ[Lookup[listedOptions, FillToVolume], True] || MatchQ[Lookup[listedOptions, InSitu], True],
						collapsedResolvedOptions,
					Or[
						MemberQ[ToList@Lookup[collapsedResolvedOptions,RentDestinationContainer,False],True],
						MemberQ[ToList@Lookup[collapsedResolvedOptions,Fresh,False],True]
					],
						RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {RentDestinationContainer, Fresh, SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition, WasteContainer}],
					True,
						RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition, WasteContainer}]
				];

				(* Memoize the value of ExperimentTransfer so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentTransfer, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentTransfer]={};

					ExperimentTransfer[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation
						}
					];

					(* Resolve the experiment function (MSP/MCP) to call using the shared helper function *)
					experimentFunction = resolveManualFrameworkFunction[{simulatedSources, simulatedDestinations}, nonHiddenOptions, Cache -> cacheBall, Simulation -> simulation, Output -> Function];

					experimentFunction[
						{primitive},
						Name -> Lookup[safeOps, Name],
						Upload -> Lookup[safeOps, Upload],
						Confirm -> Lookup[safeOps, Confirm],
						CanaryBranch -> Lookup[safeOps, CanaryBranch],
						ParentProtocol -> Lookup[safeOps, ParentProtocol],
						Priority -> Lookup[safeOps, Priority],
						StartDate -> Lookup[safeOps, StartDate],
						HoldOrder -> Lookup[safeOps, HoldOrder],
						QueuePosition -> Lookup[safeOps, QueuePosition],
						Cache -> cacheBall,
						Simulation -> simulation,

						(* NOTE: This is a Transfer specific option. Do NOT copy it. *)
						OrderFulfilled -> Lookup[safeOps, OrderFulfilled],
						PreparedResources -> Lookup[safeOps, PreparedResources]
					]
				]
			],

		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation. *)
		True,
			UploadProtocol[
				resourceResult[[1]], (* protocolPacket *)
				Flatten[resourceResult[[2;;]]], (* unitOperationPackets plus cloud file upload packets *)
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol, Transfer],
				SupplementalCertification -> Lookup[resolvedOptions, SupplementalCertification, {}],
				Cache -> cacheBall,
				Simulation -> simulation
			]
	];

	(* Return requested output *)
	(* We will have to pass this hidden option into the unit operation since we need this to decide the resource renting and preparation (fresh) later.
	Only do that if we need to rent a container or prepare fresh resource, which means we are in a sub anyway *)
	(* Also, we need to pass the resolved supplementalCertification options to top level SP primitive functions so top-level protocol get the correct certificates populated *)
	outputSpecification/.{
		Result -> result,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> Which[
			MatchQ[Lookup[listedOptions, FillToVolume], True] || MatchQ[Lookup[listedOptions, InSitu], True],
				collapsedResolvedOptions,
			Or[
				MemberQ[ToList@Lookup[collapsedResolvedOptions,RentDestinationContainer,False],True],
				MemberQ[ToList@Lookup[collapsedResolvedOptions,Fresh,False],True]
			],
				RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {RentDestinationContainer, Fresh, SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition, WasteContainer}],
			True,
				RemoveHiddenOptions[ExperimentTransfer, collapsedResolvedOptions, Exclude -> {SupplementalCertification, EquivalentTransferEnvironments, HandlingCondition, WasteContainer}]
		],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> transferRunTime[resolvedOptions]
	}
];

(* ::Subsection::Closed *)
(* transferRunTime *)

(* this is a tiny helper that we use in order to keep the time estimation formula in one place *)
(* multiprobe head takes longer than single channel transfers due to the possible adapter shenanigans, probably can improve logic here with time *)
transferRunTime[transferOptions_List]:=Plus@@Map[
	(Max[#] + (If[Length[#]<=8,50 Second,80 Second]))&,
	Unflatten[
		Lookup[transferOptions,MagnetizationTime]/.{Null->0 Second},
		Gather[Lookup[transferOptions,MultichannelTransferName]]
	]
];


(* ::Subsection:: *)
(*Helpers*)



(* ::Subsubsection:: *)
(* transferModelPackets *)

(* NOTE: This function will try to find deprecated or developer object models in our option list and explicitly call download to get them. *)
(* Then, it combines it with the non-deprecated model packets that we always download and have previously cached, for speed. *)
transferModelPackets[myOptions_List]:=transferModelPackets[myOptions]=Module[
	{searchResult, allModelsFromOptions, modelsNotInSearch, modelContainerFields, modelContainerPacketFields, supppliedDownloadResult,
		flattenedDownloadResult, mergedPackets, allHandlingConditionModelPackets, allHandlingStationPackets, allHandlingStationModelPackets,
		handlingConditionPositionLookup, allHandlingStationModelPacketsSorted, allHandlingStationPacketsWithSortedHSModels},

	If[!MemberQ[$Memoization, Experiment`Private`transferModelPackets],
		AppendTo[$Memoization, Experiment`Private`transferModelPackets]
	];

	(* Search for all transfer models in the lab to download from. *)
	(* currently these weigh boats are hard coded; probably worth not doing this in the future *)
	searchResult=Flatten[{
		transferModelsSearch["Memoization"],
		$MicroBalanceCompatibleWeighingContainerModels
	}];

	(* Get all the object models of interest from our options. *)
	allModelsFromOptions=Download[
		DeleteDuplicates@Cases[
			KeyDrop[myOptions, {Cache, Simulation}],
			ObjectP[{Model[Container, Syringe], Model[Instrument, Pipette], Model[Instrument, Balance], Model[Container], Model[Item, Spatula], Model[Item, Needle], Model[Item, Tips], Model[Item, WeighBoat], Model[Item, Consumable],Model[Part,HandPump],Model[Part,HandPumpAdapter]}],
			Infinity
		],
		Object
	];

	(* Find the objects for which we do not have packets for. *)
	modelsNotInSearch=Complement[allModelsFromOptions, Flatten[searchResult]];

	modelContainerFields=DeleteDuplicates[Flatten[{DeveloperObject, BuiltInCover, CoverTypes, CoverFootprints, Parafilm, AluminumFoil, CoverType, CoverFootprint, CrimpType, SeptumRequired, Opaque, Reusable, EngineDefault, NotchPositions, SealType,HorizontalPitch,VerticalPitch,VolumeCalibrations,Columns,Aperture,WellDepth,Sterile,RNaseFree,Squeezable,Material,Counted, TareWeight,Weight,SolutionVolume,Object,Positions,Hermetic,Ampoule,MaxVolume,ContainerMaterials, IncompatibleMaterials,Dimensions,FunnelStemDiameter,FunnelStemLength,Graduations,GraduationTypes,GraduationLabels,CrossSectionalShape,SamplePreparationCacheFields[Model[Container]]}]];
	modelContainerPacketFields=Packet@@modelContainerFields;

	(* Download packets for these models. *)
	(* NOTE: Keep this in the same order of packets from nonDeprecatedTransferModelPackets. *)
	supppliedDownloadResult=Quiet[
		Download[
			{
				(*1*)DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Container, Syringe]]]]
				],
				(*2*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Instrument, Pipette]]]
				],
				(*3*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Instrument, Aspirator]]]
				],

				(*4*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Instrument, Balance]]]
				],
				(*5*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[]]]
				],
				(*6*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Container, GraduatedCylinder]]]
				],
				(*7*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Item, Spatula]]]
				],
				(*8*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Item, Needle]]]
				],
				(*9*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Item, Tips]]]
				],
				(*10*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[TransportCondition]]]
				],
				(*11*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Instrument, FumeHood]]]
				],
				(*12*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Instrument, GloveBox]]]
				],
				(*13*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Instrument, BiosafetyCabinet]]]
				],
				(*14*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Container, Enclosure]]]
				],
				(*15*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Container, Bench]]]
				],
				(*16*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Part, Funnel]]]
				],
				(*17*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Container, Rack]]]
				],
				(*18*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Item, Consumable]]]
				],
				(*19*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Part, HandPump]]]
				],
				(*20*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Part, HandPumpAdapter]]]
				],
				(*21*)DeleteDuplicates[
					Cases[modelsNotInSearch, ObjectP[Model[Instrument, HandlingStation]]]
				]
			},
			{
				(*1*)List@Packet[Name, Sterile, ConnectionType, MinVolume, MaxVolume, Resolution, ContainerMaterials, Reusable, DeadVolume, Graduations, GraduationTypes, GraduationLabels, DeveloperObject], (* allSyringeModelPackets *)
				(*2*)List@Packet[Name, Resolution, Sterile, CultureHandling, TipConnectionType, MinVolume, MaxVolume, Channels, PipetteType, ChannelOffset, CultureHandling, GloveBoxStorage, EngineDefault, DeveloperObject, AsepticHandling], (* allPipetteModelPackets *)
				(*3*)List@Packet[Object, Name, Channels, TipConnectionType, MultichannelTipConnectionType, ChannelOffset, DeveloperObject], (* allAspiratorModelPackets *)
				(*4*)List@Packet[Name, MinWeight, MaxWeight, Resolution, Mode, AllowedMaxVariation], (* allBalanceModelPackets *)
				(*5*){modelContainerPacketFields, Packet[VolumeCalibrations[{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution, DeveloperObject}]]}, (* allWeighingContainerModelPackets *)
				(*6*)List@Packet[Name, Sterile, RNaseFree, MaxVolume, Resolution, Material, Graduations, GraduationTypes, GraduationLabels, DeveloperObject], (* allGraduatedCylinderModelPackets *)
				(*7*)List@Packet[Name, Material, TransferVolume, Reusable, DeveloperObject, NarrowEndWidth, WideEndWidth, Counted, CleaningMethod, EngineDefault], (* allSpatulaModelPackets *)
				(*8*)List@Packet[Name, Sterile, ConnectionType, Gauge, NeedleLength, InnerDiameter, Bevel, DeveloperObject], (* allNeedleModelPackets *)
				(*9*)List@Packet[Object, Name, Sterile, RNaseFree, WideBore, Filtered, Aspirator, GelLoading, Material, PipetteType, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, Footprint, MaxStackSize, AscendingGraduations, AscendingGraduationTypes, AscendingGraduationLabels, DescendingGraduations, DescendingGraduationTypes, DescendingGraduationLabels, DeveloperObject], (* allTipModelPackets *)
				(* NOTE: Kind of weird, but we have the balances of each transfer environment also included in these packet lists. *)
				(* This is to make sure that we can fulfill the requested balance after given a transfer environment. *)

				(* NOTE: We also download the contents of these transfer environment objects to see what pipettes are stored in them. *)
				(*10*){Packet[Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site], Packet[Pipettes[{Model, DeveloperObject}]], Packet[Balances[{Model, DeveloperObject}]], Packet[Balances[Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]], Packet[Model[{Name, CultureHandling, DeveloperObject}]]}, (* suppliedTransferEnvironmentPackets *)
				(*11*){Packet[CultureHandling, Objects], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allFumeHoodPackets *)
				(*12*){Packet[CultureHandling, Objects], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allGloveBoxPackets *)
				(*13*){Packet[CultureHandling, Objects, DefaultBiosafetyWasteBinModel], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, BiosafetyWasteBin, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allBiosafetyCabinetPackets *)
				(*14*){Packet[CultureHandling, Objects, DeveloperObject], Packet[Objects[{Contents, Balances, Status, DeveloperObject, Site}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allEnclosuresPackets *)
				(*15*){Packet[CultureHandling, Objects], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allBenchPackets *)
				(*16*)List@Packet[Name, StemDiameter, ContainerMaterials, FunnelType, FunnelMaterial, DeveloperObject], (* allFunnelPackets *)
				(*17*)List@Packet[Name, Magnetized, Positions, DeveloperObject], (* allRackModelPackets *)
				(*18*)List@Packet[Name, MaxVolume, DeveloperObject],
				(*19*)List@Packet[DispenseHeight, IntakeTubeLength],
				(*20*)List@Packet[Dimensions],
				(*21*){Packet[Positions, AsepticHandling, DefaultBiosafetyWasteBinModel, CultureHandling, BalanceType, Objects, DeveloperObject, ProvidedHandlingConditions, LocalCacheContents], Packet[Objects[{Model, PipetteCamera, BiosafetyWasteBin, Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}
			}
		],
		{Download::NotLinkField, Download::FieldDoesntExist, Download::ObjectDoesNotExist}
	];
	flattenedDownloadResult=Map[
		Function[{packets},
			(* need to remove the DeveloperObject objects here because otherwise we're *)
			Select[Flatten[{packets}], MatchQ[#, ObjectP[]] && Not[TrueQ[Lookup[#, DeveloperObject]]]&]
		],
		supppliedDownloadResult
	];

	(* we did not download anything extra for the packets at -5 and -2 positions, specifically allGraduatedContainerModelPackets and allHandlingConditionModelPackets, so inserting back an empty list *)
	mergedPackets = MapThread[
		Flatten[{#1, #2}]&,
		{Insert[flattenedDownloadResult, {}, {{-5}, {-2}}], nonDeprecatedTransferModelPackets["Memoization"]}
	];

	(* assign variables *)
	{allHandlingConditionModelPackets, allHandlingStationPackets} = mergedPackets[[{22, 23}]];

	(* get all handling station models and their packets *)
	allHandlingStationModelPackets = Cases[allHandlingStationPackets, PacketP[Model[Instrument, HandlingStation]]];

	(* handling condition is already sorted in nonDeprecatedTransferModelPackets  based on the accessibility of its provided handling condition, latter the position, most complicated the handling condition is *)
	handlingConditionPositionLookup = MapIndexed[
		(Lookup[#1, Object] -> First[#2])&,
		allHandlingConditionModelPackets
	];
	allHandlingStationModelPacketsSorted = SortBy[
		allHandlingStationModelPackets,
		{
			(* get the most "complicated" handling condition it can provide, smaller the index, the more "common/easily accessible" it is *)
			Max[Lookup[handlingConditionPositionLookup, Download[Lookup[#, ProvidedHandlingConditions], Object], Infinity]]&,
			(* non-ventilated over ventilated *)
			(Lookup[#, Ventilated] /. {Except[True] -> 1, True -> 2})&,
			(* non-hermetic over hermetic *)
			(Lookup[#, HermeticTransferCompatible] /. {Except[True] -> 1, True -> 2})&,
			(* less balance is better *)
			(Length[Lookup[#, BalanceType, {}]]&)
		}
	];

	(* merge the sorted handling station packets back into the big cache *)
	allHandlingStationPacketsWithSortedHSModels = Join[
		allHandlingStationModelPacketsSorted,
		DeleteCases[allHandlingStationPackets, PacketP[Model[Instrument, HandlingStation]]]
	];

	ReplacePart[mergedPackets, {23 -> allHandlingStationPacketsWithSortedHSModels}]
];


(* ::Subsubsection:: *)
(*transferModelsSearch*)


(* NOTE: We also cache our search because we will do it multiple times. *)
transferModelsSearch[fakeString_]:=transferModelsSearch[fakeString]=Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`transferModelsSearch],
		AppendTo[$Memoization, Experiment`Private`transferModelsSearch]
	];
Search[
		{
			(*1*){Model[Item, Tips]},
			(*2*){Model[Instrument,Balance]},
			(*3*){Model[Container,Syringe]},
			(*4*){Model[Container,GraduatedCylinder]},
			(*5*){Model[Item, Needle]},
			(*6*){Model[Instrument, Pipette]},
			(*7*){Model[Instrument, Aspirator]},
			(*8*){Model[Item, Spatula]},
			(*9*){Model[Item, WeighBoat]},
			(*10*){Model[TransportCondition]},
			(*11*){Model[Instrument, FumeHood]},
			(*12*){Model[Instrument, GloveBox]},
			(*13*){Model[Instrument, BiosafetyCabinet]},
			(*14*){Model[Part, Funnel]},
			(*15*){Model[Container, Enclosure]},
			(*16*){Model[Container, Bench]},
			(*17*){Model[Container, Rack]},
			(*18*){Model[Item, Consumable]},
			(*19*){Model[Container, Vessel]},
			(*20*){Model[Part,HandPump]},
			(*21*){Model[Part,HandPumpAdapter]},
			(*22*){Model[HandlingCondition]},
			(*23*){Model[Instrument, HandlingStation]}
		},
		{
			(*1*)Deprecated != True && DeveloperObject != True,
			(*2*)Deprecated != True && DeveloperObject != True,
			(*3*)Deprecated != True && DeveloperObject != True,
			(*4*)Deprecated != True && DeveloperObject != True,
			(*5*)Deprecated != True && DeveloperObject != True,
			(*6*)Deprecated != True && DeveloperObject != True,
			(*7*)Deprecated != True && DeveloperObject != True,
			(*8*)Deprecated != True && DeveloperObject != True,
			(*9*)Deprecated != True && DeveloperObject != True,
			(*10*)Deprecated != True && DeveloperObject != True,
			(*11*)Deprecated != True && DeveloperObject != True,
			(*12*)Deprecated != True && DeveloperObject != True,
			(*13*)Deprecated != True && DeveloperObject != True,
			(*14*)Deprecated != True && DeveloperObject != True,
			(*15*)Deprecated != True && DeveloperObject != True,
			(*16*)Deprecated != True && DeveloperObject != True,
			(*17*)Deprecated != True && DeveloperObject != True,
			(*18*)Deprecated != True && DeveloperObject != True,
			(*19*)Deprecated != True && DeveloperObject != True && Graduations != Null,
			(*20*)Deprecated != True && DeveloperObject != True,
			(*21*)Deprecated != True && DeveloperObject != True,
			(*22*)Deprecated != True && DeveloperObject != True,
			(*23*)Deprecated != True && DeveloperObject != True
		},
		SubTypes -> {
			(*1*)True,
			(*2*)True,
			(*3*)True,
			(*4*)True,
			(*5*)True,
			(*6*)True,
			(*7*)True,
			(*8*)True,
			(*9*)True,
			(*10*)True,
			(*11*)True,
			(*12*)True,
			(*13*)True,
			(*14*)True,
			(*15*)True,
			(*16*)True,
			(*17*)True,
			(*18*)True,
			(* get all graduated containers, we do not want volumetric flasks for sure so excluding the VolumetricFlask subtype here *)
			(*19*)False,
			(*20*)True,
			(*21*)True,
			(*22*)True,
			(*23*)True
		}
	]
];


(* ::Subsubsection:: *)
(*nonDeprecatedTransferModelPackets*)


(* NOTE: These are the non-deprecated model packets that we ALWAYS download so we memoize it. *)
nonDeprecatedTransferModelPackets[fakeString_]:=nonDeprecatedTransferModelPackets[fakeString]=Module[
	{allTipModels, allBalanceModels, allSyringeModels, allGraduatedCylinderModels, allNeedleModels, allPipetteModels,
	allAspiratorModels, allSpatulaModels, allWeighBoatModels, allTransportConditions, allFumeHoods, allGloveBoxes,
	allBiosafetyCabinets, allFunnels, allEnclosures, allBenches, allRackModels, allSyringeModelPackets, allPipetteModelPackets,
	allAspiratorModelPackets, allBalanceModelPackets, allWeighingContainerModelPackets, allGraduatedCylinderModelPackets,
	allSpatulaModelPackets, allNeedleModelPackets, allTipModelPackets, allTransportConditionPackets, allFumeHoodPackets,
	allGloveBoxPackets, allBiosafetyCabinetPackets, allEnclosurePackets, allBenchPackets, allFunnelPackets,allHandPumpModelPackets,allHandPumpAdapterModelPackets, allRackModelPackets,
		modelContainerFields, modelContainerPacketFields,allConsumableModels,allConsumableModelPackets,allGraduatedContainers,allGraduatedContainerModelPackets,allHandPumpModels,
		allHandPumpAdapterModels, allHandlingConditions, allHandlingStations, allHandlingConditionModelPackets, allHandlingStationPackets, allHandlingConditionModelPacketsSorted},

	(*Add nonDeprecatedTransferModelPackets to list of Memoized functions*)
	If[!MemberQ[$Memoization, Experiment`Private`nonDeprecatedTransferModelPackets],
		AppendTo[$Memoization, Experiment`Private`nonDeprecatedTransferModelPackets]
	];

	(* Search for all transfer models in the lab to download from. *)
	{
		allTipModels,
		allBalanceModels,
		allSyringeModels,
		allGraduatedCylinderModels,
		allNeedleModels,
		allPipetteModels,
		allAspiratorModels,
		allSpatulaModels,
		allWeighBoatModels,
		allTransportConditions,
		allFumeHoods,
		allGloveBoxes,
		allBiosafetyCabinets,
		allFunnels,
		allEnclosures,
		allBenches,
		allRackModels,
		allConsumableModels,
		allGraduatedContainers,
		allHandPumpModels,
		allHandPumpAdapterModels,
		allHandlingConditions,
		allHandlingStations
	}=transferModelsSearch["Memoization"];

	(* Fields to download. Keep this in sync with the experiment function. *)
	modelContainerFields=DeleteDuplicates[Flatten[{
		DeveloperObject, MultiProbeHeadIncompatible, BuiltInCover, CoverTypes, CoverFootprints, Parafilm, AluminumFoil,
		CoverType, CoverFootprint, CrimpType, SeptumRequired, Opaque, Reusable, EngineDefault, NotchPositions, SealType,
		HorizontalPitch,VerticalPitch,VolumeCalibrations,Columns,Aperture,WellDepth,Sterile,RNaseFree,Squeezable,Material,Counted,
		TareWeight,Weight,SolutionVolume,Object,Positions,Hermetic,Ampoule,MaxVolume,IncompatibleMaterials, Products, Dimensions, FunnelStemDiameter,FunnelStemLength,Graduations, GraduationTypes, GraduationLabels, CrossSectionalShape,SamplePreparationCacheFields[Model[Container]]}]];
	modelContainerPacketFields=Packet@@modelContainerFields;

	(* Download the fields that we need. *)
	{
		(*1*)allSyringeModelPackets,
		(*2*)allPipetteModelPackets,
		(*3*)allAspiratorModelPackets,
		(*4*)allBalanceModelPackets,
		(*5*)allWeighingContainerModelPackets,
		(*6*)allGraduatedCylinderModelPackets,
		(*7*)allSpatulaModelPackets,
		(*8*)allNeedleModelPackets,
		(*9*)allTipModelPackets,
		(*10*)allTransportConditionPackets,
		(*11*)allFumeHoodPackets,
		(*12*)allGloveBoxPackets,
		(*13*)allBiosafetyCabinetPackets,
		(*14*)allEnclosurePackets,
		(*15*)allBenchPackets,
		(*16*)allFunnelPackets,
		(*17*)allRackModelPackets,
		(*18*)allConsumableModelPackets,
		(*19*)allGraduatedContainerModelPackets,
		(*20*)allHandPumpModelPackets,
		(*21*)allHandPumpAdapterModelPackets,
		(*22*)allHandlingConditionModelPackets,
		(*23*)allHandlingStationPackets
	} = Quiet[
		Download[
			{
				(*1*)DeleteDuplicates[
					Flatten[{allSyringeModels}]
				],
				(*2*)DeleteDuplicates[
					Flatten[{allPipetteModels}]
				],
				(*3*)DeleteDuplicates[
					Flatten[{allAspiratorModels}]
				],
				(*4*)DeleteDuplicates[
					Flatten[{allBalanceModels}]
				],
				(*5*)DeleteDuplicates[
					Flatten[{
						allWeighBoatModels,
						PreferredContainer[All, Type -> All, LiquidHandlerCompatible -> True],
						PreferredContainer[All, Type -> All, LiquidHandlerCompatible -> False],
						{
							Model[Container, Vessel, "id:jLq9jXvoR87z"],
							Model[Container, Vessel, "id:n0k9mG8EojZ6"],
							Model[Container, Vessel, "id:XnlV5jKPkq7b"],
							Model[Container, Vessel, "id:XnlV5jKPkqJN"],
							Model[Container, Vessel, "id:qdkmxzqPLnN1"],
							Model[Container, GraduatedCylinder, "id:L8kPEjNLDDXV"]
						}
					}]
				],
				(*6*)DeleteDuplicates[
					Flatten[{allGraduatedCylinderModels}]
				],
				(*7*)DeleteDuplicates[
					Flatten[{allSpatulaModels}]
				],
				(*8*)DeleteDuplicates[
					Flatten[{allNeedleModels}]
				],
				(*9*)DeleteDuplicates[
					Flatten[{allTipModels}]
				],
				(*10*)allTransportConditions,
				(*11*)allFumeHoods,
				(*12*)allGloveBoxes,
				(*13*)allBiosafetyCabinets,
				(*14*)allEnclosures,
				(*15*)allBenches,
				(*16*)allFunnels,
				(*17*)allRackModels,
				(*18*)allConsumableModels,
				(*19*)allGraduatedContainers,
				(*20*)allHandPumpModels,
				(*21*)allHandPumpAdapterModels,
				(*22*)allHandlingConditions,
				(*23*)allHandlingStations
			},
			{
				(*1*)List@Packet[Name, Sterile, ConnectionType, MinVolume, MaxVolume, Resolution, ContainerMaterials, Reusable, Graduations, GraduationTypes, GraduationLabels, DeadVolume, DeveloperObject], (* allSyringeModelPackets *)
				(*2*)List@Packet[Name, Resolution, Sterile, CultureHandling, TipConnectionType, MinVolume, MaxVolume, Channels, PipetteType, ChannelOffset, CultureHandling, GloveBoxStorage, EngineDefault, DeveloperObject, AsepticHandling], (* allPipetteModelPackets *)
				(*3*)List@Packet[Object, Name, Channels, TipConnectionType, MultichannelTipConnectionType, ChannelOffset, AsepticHandling, CultureHandling, DeveloperObject], (* allAspiratorModelPackets *)
				(*4*)List@Packet[Name, MinWeight, MaxWeight, Resolution, Mode, AllowedMaxVariation, DeveloperObject], (* allBalanceModelPackets *)
				(*5*){modelContainerPacketFields, Packet[VolumeCalibrations[{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution, DeveloperObject}]]}, (* allWeighingContainerModelPackets *)
				(*6*)List@Packet[Name, Sterile, RNaseFree, MaxVolume, Resolution, Material, Graduations, GraduationTypes, GraduationLabels, DeveloperObject], (* allGraduatedCylinderModelPackets *)
				(*7*)List@Packet[Name, Material, TransferVolume, Reusable, EngineDefault, DeveloperObject,NarrowEndWidth,WideEndWidth, Counted, CleaningMethod, EngineDefault], (* allSpatulaModelPackets *)
				(*8*)List@Packet[Name, Sterile, ConnectionType, Gauge, NeedleLength, InnerDiameter, Bevel, DeveloperObject], (* allNeedleModelPackets *)
				(*9*)List@Packet[Object, Name, Sterile, PipetteType, RNaseFree, WideBore, Filtered, Aspirator, GelLoading, Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, AscendingGraduations, AscendingGraduationTypes, AscendingGraduationLabels, DescendingGraduations, DescendingGraduationTypes, DescendingGraduationLabels, DeveloperObject], (* allTipModelPackets *)
				(* NOTE: Kind of weird, but we have the balances of each transfer environment also included in these packet lists. *)
				(* This is to make sure that we can fulfill the requested balance after given a transfer environment. *)
				(* NOTE: We also download the contents of these transfer environment objects to see what pipettes are stored in them. *)
				(*10*){Packet[Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject], Packet[Pipettes[{Model, DeveloperObject, Site}]], Packet[Balances[{Model, DeveloperObject}]], Packet[Balances[Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]], Packet[Model[{Name, CultureHandling, DeveloperObject}]]}, (* suppliedTransferEnvironmentPackets *)
				(*11*){Packet[CultureHandling, AsepticHandling, Objects, DeveloperObject], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allFumeHoodPackets *)
				(*12*){Packet[CultureHandling, AsepticHandling, Objects, DeveloperObject], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allGloveBoxPackets *)
				(*13*){Packet[CultureHandling, AsepticHandling, Objects, DeveloperObject, DefaultBiosafetyWasteBinModel], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, BiosafetyWasteBin, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allBiosafetyCabinetPackets *)
				(*14*){Packet[CultureHandling, Objects, DeveloperObject], Packet[Objects[{Contents, Balances, Status, DeveloperObject, Site}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allEnclosuresPackets *)
				(*15*){Packet[CultureHandling, Objects, DeveloperObject], Packet[Objects[{Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}, (* allBenchPackets *)
				(*16*)List@Packet[Name, StemDiameter, ContainerMaterials, FunnelType, FunnelMaterial, DeveloperObject], (* allFunnelPackets *)
				(*17*)List@Packet[Name, Magnetized, Positions, DeveloperObject], (* allRackModelPackets *)
				(*18*)List@Packet[Name, MaxVolume, DeveloperObject], (* allRackModelPackets *)
				(*19*)List@Packet[Name, Graduations, GraduationTypes, GraduationLabels, CrossSectionalShape, DeveloperObject], (*allGraduatedContainers*)
				(*20*)List@Packet[DispenseHeight, IntakeTubeLength],
				(*21*)List@Packet[Dimensions],
				(*22*)List@Packet[HandlingAtmosphere, FumeExtraction, MinVolumetricFlowRate, AsepticTechniqueEnvironment, UVSterilization, NitrogenHermeticTransfer, ArgonHermeticTransfer, SchlenkLineTransfer, IRProbe, BalanceType, Pipette],
				(*23*){Packet[Positions, AsepticHandling, DefaultBiosafetyWasteBinModel, CultureHandling, BalanceType, Objects, DeveloperObject, ProvidedHandlingConditions, LocalCacheContents], Packet[Objects[{Model, PipetteCamera, BiosafetyWasteBin, Contents, Pipettes, Balances, IRProbe, SchlenkLine, Status, DeveloperObject, Site}]], Packet[Objects[Pipettes][{Model, DeveloperObject}]], Packet[Objects[Balances][{Model, DeveloperObject}]], Packet[Objects[Balances][Model][{Mode, MinWeight, AllowedMaxVariation, DeveloperObject}]]}
			}
		],
		{Download::NotLinkField, Download::FieldDoesntExist, Download::ObjectDoesNotExist}
	];

	(* Flatten our packets. *)
	(* also delete everything that is a developer object *)
	{
		allSyringeModelPackets,allPipetteModelPackets,allAspiratorModelPackets,

		allBalanceModelPackets,
		allWeighingContainerModelPackets,
		allGraduatedCylinderModelPackets,
		allSpatulaModelPackets,
		allNeedleModelPackets,
		allTipModelPackets,

		allTransportConditionPackets,

		allFumeHoodPackets,
		allGloveBoxPackets,
		allBiosafetyCabinetPackets,
		allEnclosurePackets,
		allBenchPackets,

		allFunnelPackets,

		allRackModelPackets,
		allConsumableModelPackets,
		allGraduatedContainerModelPackets,
		allHandPumpModelPackets,
		allHandPumpAdapterModelPackets,
		allHandlingConditionModelPackets,
		allHandlingStationPackets
	}=Map[
		Function[{packets},
			(* need to remove the DeveloperObject objects here because otherwise we're *)
			Select[Flatten[{packets}], MatchQ[#, ObjectP[]] && Not[TrueQ[Lookup[#, DeveloperObject]]]&]
		],
		{
			allSyringeModelPackets,allPipetteModelPackets,allAspiratorModelPackets,

			allBalanceModelPackets,
			allWeighingContainerModelPackets,
			allGraduatedCylinderModelPackets,
			allSpatulaModelPackets,
			allNeedleModelPackets,
			allTipModelPackets,

			allTransportConditionPackets,

			allFumeHoodPackets,
			allGloveBoxPackets,
			allBiosafetyCabinetPackets,
			allEnclosurePackets,
			allBenchPackets,

			allFunnelPackets,

			allRackModelPackets,
			allConsumableModelPackets,
			allGraduatedContainerModelPackets,
			allHandPumpModelPackets,
			allHandPumpAdapterModelPackets,
			allHandlingConditionModelPackets,
			allHandlingStationPackets
		}
	];

	(* we sort the handling conditions b/c we want to prefer the most "common/easily accessible" conditions first *)
	allHandlingConditionModelPacketsSorted = SortBy[
		allHandlingConditionModelPackets,
		{
			(* definitely prefer ambient, nitrogen, then argon, then low/high vacuum *)
			(Lookup[#, HandlingAtmosphere] /. {Ambient -> 1, Nitrogen -> 2, Argon -> 3, _Symbol -> 4})&,
			(* non-sterile over sterile *)
			(Lookup[#, AsepticTechniqueEnvironment] /. {Except[True] -> 1, True -> 2})&,
			(* non-hermetic over hermetic *)
			(Lookup[#, NitrogenHermeticTransfer] /. {Except[True] -> 1, True -> 2})&,
			(* non-hermetic over hermetic *)
			(Lookup[#, ArgonHermeticTransfer] /. {Except[True] -> 1, True -> 2})&,
			(* non-schlenk line over schlenk line *)
			(Lookup[#, SchlenkLineTransfer] /. {Except[True] -> 1, True -> 2})&,
			(* non-fumehood over fumehood *)
			(Lookup[#, MinVolumetricFlowRate, 0 Liter / Second])&,
			(* less balance is better *)
			(Length[Lookup[#, BalanceType, {}]]&)
		}
	];

	(* Return our packets. *)
	{
		allSyringeModelPackets,allPipetteModelPackets,allAspiratorModelPackets,

		allBalanceModelPackets,
		(* NOTE: Some containers (weigh boats) don't have volume calibrations, so we have to filter out the $Failed. *)
		Cases[allWeighingContainerModelPackets, PacketP[]],
		allGraduatedCylinderModelPackets,
		allSpatulaModelPackets,
		allNeedleModelPackets,
		allTipModelPackets,

		allTransportConditionPackets,

		allFumeHoodPackets,
		allGloveBoxPackets,
		allBiosafetyCabinetPackets,
		allEnclosurePackets,
		allBenchPackets,

		allFunnelPackets,

		allRackModelPackets,
		allConsumableModelPackets,
		allGraduatedContainerModelPackets,
		allHandPumpModelPackets,
		allHandPumpAdapterModelPackets,
		allHandlingConditionModelPacketsSorted,
		allHandlingStationPackets
	}
];


(* ::Subsubsection:: *)
(*reusableNeedleModelSearch*)


reusableNeedleModelSearch[fakeString_]:=reusableNeedleModelSearch[fakeString]=Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`reusableNeedleModelSearch],
		AppendTo[$Memoization, Experiment`Private`reusableNeedleModelSearch]
	];
	Search[Model[Item, Needle], Reusable == True]
];

(* ::Subsubsection:: *)
(*handlingConditionInstrumentLookup*)


(* cache the handling condition -> handling station lookup *)
handlingConditionInstrumentLookup[fakeString_] := handlingConditionInstrumentLookup[fakeString] = Module[{allHandlingConditionModelPackets, allHandlingStationPackets, allHandlingStationModelPackets, handlingConditionStationRules},
	If[!MemberQ[$Memoization, Experiment`Private`handlingConditionInstrumentLookup],
		AppendTo[$Memoization, Experiment`Private`handlingConditionInstrumentLookup]
	];
	(* get the condition and station download packets *)
	{allHandlingConditionModelPackets, allHandlingStationPackets} = transferModelPackets[{}][[{22, 23}]];

	(* get all handling station models and their packets, this comes sorted too *)
	allHandlingStationModelPackets = Cases[allHandlingStationPackets, PacketP[Model[Instrument, HandlingStation]]];

	(* go over all handling station packets and generate the condition -> station lookup *)
	handlingConditionStationRules = Flatten[Map[
		Function[{packet},
			Module[{station, conditions},
				station = Lookup[packet, Object];
				conditions = Download[Lookup[packet, ProvidedHandlingConditions, {}], Object];

				(* Thread[{a, b, c} -> {1, 2, 3}] makes {a -> 1, b -> 2, c -> 3} *)
				Thread[conditions -> ConstantArray[station, Length[conditions]]]
			]
		],
		allHandlingStationModelPackets
	]];

	(* make sure we delete duplicates and merge *)
	(* b/c the handling station that is Mapped over was sorted, the keys in the lookup is also sorted to our preference *)
	Merge[DeleteDuplicates[handlingConditionStationRules], Identity]
];


(* ::Subsubsection:: *)
(*balanceHandlingStationLookup*)



(* cache the balance -> handling station lookup *)
balanceHandlingStationLookup[fakeString_] := balanceHandlingStationLookup[fakeString] = (
	(* this needs to stay outside the Module if you have the same variable name as the function name *)
	If[!MemberQ[$Memoization, Experiment`Private`balanceHandlingStationLookup],
		AppendTo[$Memoization, Experiment`Private`balanceHandlingStationLookup]
	];
	Module[{allHandlingStationPackets, allHandlingStationObjectPackets, allHandlingStationModelPackets, fastAssoc, balanceHandlingStationRules, balanceHandlingStationLookup},

		(* get the condition and station download packets *)
		allHandlingStationPackets = transferModelPackets[{}][[23]];

		(* get all handling station objet packets, make sure we filter the Retired objects out *)
		allHandlingStationObjectPackets = DeleteCases[Cases[allHandlingStationPackets, PacketP[Object[Instrument, HandlingStation]]], KeyValuePattern[{Status -> Retired}]];

		(* get all handling station model packets, this comes sorted *)
		allHandlingStationModelPackets = Cases[allHandlingStationPackets, PacketP[Model[Instrument, HandlingStation]]];

		(* make a fast assoc cache *)
		fastAssoc = makeFastAssocFromCache[FlattenCachePackets[allHandlingStationPackets]];

		(* create balance -> handling station rules *)
		balanceHandlingStationRules = Flatten[Map[
			Function[{packet},
				Module[{handlingStationModel, balances, balanceModels},
					(* get the handling station model *)
					handlingStationModel = Download[Lookup[packet, Model], Object];

					(* get all the balances *)
					balances = Cases[Download[Lookup[packet, Balances], Object], ObjectP[]];

					(* get all balance models *)
					(* take the equivalent balance models into the lookup when we make the lookup, b/c our resource system treats them the same anyways *)
					balanceModels = Flatten[Cases[Download[fastAssocLookup[fastAssoc, #, Model], Object]& /@ balances, ObjectP[]] /. Resources`Private`$EquivalentInstrumentModelLookup];

					(* point balance object to this handling station object and model, but separate with different keys *)
					{
						Thread[balances -> "Object" -> ConstantArray[Lookup[packet, Object], Length[balances]]],
						Thread[balances -> "Model" -> ConstantArray[handlingStationModel, Length[balances]]],
						Thread[balanceModels -> "Object" -> ConstantArray[Lookup[packet, Object], Length[balances]]],
						Thread[balanceModels -> "Model" -> ConstantArray[handlingStationModel, Length[balances]]]
					}
				]
			],
			allHandlingStationObjectPackets
		]];

		(* merge and make it a lookup *)
		balanceHandlingStationLookup = Module[{balanceMerged},
			(* merge by balance key first, so we have a lookup like:
				<|balanceObject1 -> {"Object"->hs1, "Model"->hs1Model, "Object"->hs2, "Model"-> hs2Model}|>
			*)
			balanceMerged = Merge[balanceHandlingStationRules, Flatten];

			(* now merge again by "Object"/"Model" keys, so we know for each balance object, model, what handling station object/models are associated with them *)
			(* Map[f, <|key1 -> val1, key2 -> val2, ...|>] returns an association <|key -> f[val1], key2 -> f[val2], ...|> *)
			Map[
				Function[{rules},
					Merge[rules, DeleteDuplicates[Flatten[#]]&]
				],
				balanceMerged
			]
		];

		(* finally, we sort the handling station models in the lookup to our preference *)
		Map[
			Function[{assoc},
				(* we only sort the handling station model, not the handling station object *)
				Association @ KeyValueMap[
					Function[{key, value},
						key -> If[MatchQ[key, "Model"],
							UnsortedIntersection[Lookup[allHandlingStationModelPackets, Object], value],
							value
						]
					],
					assoc
				]
			],
			balanceHandlingStationLookup
		]
	]
);



(* ::Subsubsection:: *)
(*handlingStationBalanceLookup*)



(* cache the handling station -> balance lookup *)
(* this is basically just reversing balanceHandlingStationLookup so no download is required *)
handlingStationBalanceLookup[fakeString_] := handlingStationBalanceLookup[fakeString] = (
	(* this needs to stay outside the Module if you have the same variable name as the function name *)
	If[!MemberQ[$Memoization, Experiment`Private`handlingStationBalanceLookup],
		AppendTo[$Memoization, Experiment`Private`handlingStationBalanceLookup]
	];
	Module[{downloads, fastAssoc, sortedBalances, handlingStationBalanceRules, handlingStationBalanceLookup},

		(* download *)
		downloads = Quiet[
			Download[
				Keys[balanceHandlingStationLookup["Memoization"]],
				{
					Packet[MinWeight, Model], Packet[Model[MinWeight]]
				}
			],
			{Download::FieldDoesntExist, Download::NotLinkField, Download::ObjectDoesNotExist}
		];

		(* make a fast assoc cache *)
		fastAssoc = makeFastAssocFromCache[FlattenCachePackets[downloads]];

		(* sort the balance according to model's MinWeight *)
		sortedBalances = SortBy[
			Keys[balanceHandlingStationLookup["Memoization"]],
			If[MatchQ[#, ObjectP[Object[Instrument]]],
				fastAssocLookup[fastAssoc, #, {Model, MinWeight}],
				fastAssocLookup[fastAssoc, #, MinWeight]
			]&
		];

		handlingStationBalanceRules = KeyValueMap[
			Function[{balance, assoc},
				If[MatchQ[balance, ObjectP[Model[Instrument, Balance]]],
					{
						(* point all handling station to balance model with a model key *)
						Thread[Lookup[assoc, "Object"] -> "Model" -> ConstantArray[balance, Length[Lookup[assoc, "Object"]]]],
						Thread[Lookup[assoc, "Model"] -> "Model" -> ConstantArray[balance, Length[Lookup[assoc, "Model"]]]]
					},
					{
						(* point all handling station to balance object with a object key *)
						Thread[Lookup[assoc, "Object"] -> "Object" -> ConstantArray[balance, Length[Lookup[assoc, "Object"]]]],
						Thread[Lookup[assoc, "Model"] -> "Object" -> ConstantArray[balance, Length[Lookup[assoc, "Model"]]]]
					}
				]
			],
			balanceHandlingStationLookup["Memoization"]
		];

		(* merge and make it a lookup *)
		handlingStationBalanceLookup = Module[{handlingStationMerged},
			(* merge by balance key first, so we have a lookup like:
				<|balanceObject1 -> {"Object"->hs1, "Model"->hs1Model, "Object"->hs2, "Model"-> hs2Model}|>
			*)
			handlingStationMerged = Merge[handlingStationBalanceRules, Flatten];

			(* now merge again by "Object"/"Model" keys, so we know for each balance object, model, what handling station object/models are associated with them *)
			(* Map[f, <|key1 -> val1, key2 -> val2, ...|>] returns an association <|key -> f[val1], key2 -> f[val2], ...|> *)
			Map[
				Function[{rules},
					Merge[rules, DeleteDuplicates[Flatten[#]]&]
				],
				handlingStationMerged
			]
		];

		(* finally, we sort the handling station models in the lookup to our preference *)
		Map[
			Function[{assoc},
				(* we only sort the handling station model, not the handling station object *)
				Association @ KeyValueMap[
					Function[{key, value},
						key -> UnsortedIntersection[sortedBalances, value]
					],
					assoc
				]
			],
			handlingStationBalanceLookup
		]
	]
);



(* ::Subsubsection:: *)
(*splitByCommonElements*)

(* this helper will group adjacent lists together and extract the intersection, as long as adjacent lists have shared elements in common.
 input: list = {{a, b, c}, {a, b}, {a, c}, {d}, {a, d}}
 output: {{{a}, {a}, {a}}, {{d}, {d}}}
 This is useful to determine the real usable transfer environments given each transfer has a specific list of "real" equivalent environments that we can do transfers on no problem
*)

splitByCommonElements[listyList:{___List}] := Fold[
	Function[{grouped, current},
		Module[{lastGroup, intersection},
			(* get the previous group *)
			lastGroup = Last[grouped, {}];

			(* see if we have a transfer environment that can be shared with the current ongoing grouping *)
			intersection = UnsortedIntersection[Last[lastGroup, {}], current];

			(* if we have a transfer environment that can be shared with the last transfer environment, mark them together as the same grouping *)
			If[Length[intersection] > 0,
				Append[
					Most[grouped],
					ConstantArray[intersection, Length[lastGroup] + 1]
				],
				(* otherwise, start a new group *)
				Append[grouped, {current}]
			]
		]
	],
	{},
	listyList
];



(* ::Subsection:: *)
(* resolveTransferMethod *)

DefineOptions[resolveTransferMethod,
	SharedOptions:>{
		ExperimentTransfer,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: mySources can be Automatic when the user has not yet specified a value for autofill. *)
resolveTransferMethod[
	mySources:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{_Integer,ObjectP[Model[Container]]|Automatic}|{_String,ObjectP[Object[Container]]|Automatic}],
	myDestinations:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container], Model[Container], Object[Item], Model[Item]}]|{_Integer,ObjectP[Model[Container]]|Automatic}|{_String,ObjectP[Object[Container]]|Automatic}|Waste],
	myAmounts:ListableP[VolumeP|MassP|CountP|All],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, outputSpecification, output, gatherTests, allTipModelPackets,
		allModelContainerPackets, allModelContainerPlatePackets,
		samplePackets, liquidHandlerIncompatibleContainers, allPackets,
		manualRequirementStrings, roboticRequirementStrings, result, tests, cache, simulation, initialFastAssoc,
		fastAssoc, allSpecifiedContainerObjs, allSpecifiedSampleObjs,
		allSpecifiedContainerModelObjs, allSpecifiedSampleModelObjs, initialFastAssocKeys, samplePacketsExistQs,
		containerPacketsExistQs, containerModelPacketExistQs, sampleModelPacketExistQs, remainingSampleObjs,
		remainingContainerObjs, remainingSampleModelObjs, remainingContainerModelObjs, allDownloadedStuff,
		allSpecifiedTipModelObjs, allSpecifiedTipObjs, tipPacketExistQs, tipModelPacketExistQs, remainingTipObjs,
		remainingTipModelObjs},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveTransferMethod, ToList[myOptions]];
	{cache, simulation} = Lookup[safeOptions, {Cache, Simulation}];
	initialFastAssoc = makeFastAssocFromCache[cache];
	initialFastAssocKeys = Keys[initialFastAssoc];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* get all the relevant sample/container objects/models from the sources and destinations*)
	allSpecifiedContainerObjs = Download[DeleteDuplicates[Cases[Flatten[{mySources, myDestinations}], ObjectP[Object[Container]]]], Object];
	allSpecifiedSampleObjs = Download[DeleteDuplicates[Cases[Flatten[{mySources, myDestinations}], ObjectP[Object[Sample]]]], Object];
	allSpecifiedContainerModelObjs = Download[DeleteDuplicates[Cases[Flatten[{mySources, myDestinations}], ObjectP[Model[Container]]]], Object];
	allSpecifiedSampleModelObjs = Download[DeleteDuplicates[Cases[Flatten[{mySources, myDestinations}], ObjectP[Model[Sample]]]], Object];

	(* get all the specified tip models and objects from the option s*)
	(* remove the Cache and Simulation here because that is sometimes enormous and not something we need to track *)
	{allSpecifiedTipModelObjs, allSpecifiedTipObjs} = With[{culledOptions = ReplaceRule[ToList[myOptions], {Cache -> {}, Simulation -> Null}]},
		{
			DeleteDuplicates[Cases[culledOptions, ObjectReferenceP[Model[Item, Tips]], Infinity]],
			DeleteDuplicates[Cases[culledOptions, ObjectReferenceP[Object[Item, Tips]], Infinity]]
		}
	];

	(* figure out if we have all the information about input samples, containers, and models *)
	(* for input models this is easy: just do we have the packet at all? *)
	(* for samples, this means do we have packets for the container models, the containers, and the samples? *)
	samplePacketsExistQs = Map[
		Function[specifiedSampleObj,
			And[
				MemberQ[initialFastAssocKeys, specifiedSampleObj],
				MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedSampleObj, {Container, Object}]],
				MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedSampleObj, {Container, Model, Object}]]
			]
		],
		allSpecifiedSampleObjs
	];
	containerPacketsExistQs = Map[
		Function[specifiedContainerObj,
			And[
				MemberQ[initialFastAssocKeys, specifiedContainerObj],
				MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedContainerObj, {Model, Object}]],
				And @@ (MemberQ[initialFastAssocKeys, #]& /@ Download[fastAssocLookup[initialFastAssoc, specifiedContainerObj, Contents][[All, 2]], Object])
			]
		],
		allSpecifiedContainerObjs
	];
	sampleModelPacketExistQs = Map[
		Function[specifiedSampleModel,
			MemberQ[initialFastAssocKeys, specifiedSampleModel]
		],
		allSpecifiedSampleModelObjs
	];
	containerModelPacketExistQs = Map[
		Function[specifiedContainerModel,
			MemberQ[initialFastAssocKeys, specifiedContainerModel]
		],
		allSpecifiedContainerModelObjs
	];
	tipPacketExistQs = Map[
		Function[specifiedTipObj,
			MemberQ[initialFastAssocKeys, specifiedTipObj]
		],
		allSpecifiedTipObjs
	];
	tipModelPacketExistQs = Map[
		Function[specifiedTipModel,
			MemberQ[initialFastAssocKeys, specifiedTipModel]
		],
		allSpecifiedTipModelObjs
	];

	(* get the remaining objects that we don't have any information about *)
	remainingSampleObjs = PickList[allSpecifiedSampleObjs, samplePacketsExistQs, False];
	remainingContainerObjs = PickList[allSpecifiedContainerObjs, containerPacketsExistQs, False];
	remainingSampleModelObjs = PickList[allSpecifiedSampleModelObjs, sampleModelPacketExistQs, False];
	remainingContainerModelObjs = PickList[allSpecifiedContainerModelObjs, containerModelPacketExistQs, False];
	remainingTipObjs = PickList[allSpecifiedTipObjs, tipPacketExistQs, False];
	remainingTipModelObjs = PickList[allSpecifiedTipModelObjs, tipModelPacketExistQs, False];

	allDownloadedStuff = Quiet[
		Download[
			{
				remainingSampleObjs,
				remainingContainerObjs,
				remainingSampleModelObjs,
				remainingContainerModelObjs,
				remainingTipObjs,
				remainingTipModelObjs
			},
			{
				{
					Packet[Contents[[All,2]][{Name, LiquidHandlerIncompatible, Container, Position}]],
					Packet[Name, Model, Contents],
					Packet[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]
				},
				{
					Packet[Name, LiquidHandlerIncompatible, Container, Position],
					Packet[Container[{Model}]],
					Packet[Container[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]]
				},
				{Packet[Name, LiquidHandlerIncompatible]},
				{Packet[Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix]},
				{Packet[Model[PipetteType]]},
				{Packet[PipetteType]}
			},
			Cache -> cache,
			Simulation -> simulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Join all packets. *)
	allPackets = FlattenCachePackets[{cache, allDownloadedStuff}];
	fastAssoc = makeFastAssocFromCache[allPackets];

	(* Get all of our Model[Container]s. *)
	allModelContainerPackets = Cases[
		Flatten[{
			fastAssocPacketLookup[fastAssoc, #, Model]& /@ allSpecifiedContainerObjs,
			fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ allSpecifiedSampleObjs,
			fetchPacketFromFastAssoc[#, fastAssoc]& /@ allSpecifiedContainerModelObjs
		}],
		PacketP[Model[Container]]
	];

	(* Get all of our Model[Container,Plate]s and look at their LiquidHandlerPrefix. *)
	allModelContainerPlatePackets=Cases[
		allModelContainerPackets,
		PacketP[Model[Container,Plate]]
	];

	(* Get all of the sample objects that we were given. *)
	samplePackets = Map[
		Function[sourceOrDestinationValue,
			Switch[sourceOrDestinationValue,
				(* for model or object samples, just get the packet directly *)
				ObjectP[{Object[Sample], Model[Sample]}], fetchPacketFromFastAssoc[sourceOrDestinationValue, fastAssoc],
				(* for pairs with a position in a container, first get the packet of the container, and then get the packet of the sample at that positino *)
				{_String, ObjectP[Object[Container]]},
					Module[{containerPacket, contentsEntry},
						containerPacket = fetchPacketFromFastAssoc[sourceOrDestinationValue[[2]], fastAssoc];
						contentsEntry = SelectFirst[Lookup[containerPacket, Contents], MatchQ[#[[1]], sourceOrDestinationValue[[1]]]&];
						If[MatchQ[contentsEntry, {_String, ObjectP[Object[Sample]]}],
							fetchPacketFromFastAssoc[contentsEntry[[2]], fastAssoc],
							Nothing
						]
					],
				(* everything else, Nothing*)
				_, Nothing
			]
		],
		Join[ToList[mySources], ToList[myDestinations]]
	];

	(* get all the tip model packets *)
	allTipModelPackets = DeleteDuplicates[Flatten[{
		fetchPacketFromFastAssoc[#, fastAssoc]& /@ allSpecifiedTipModelObjs,
		fastAssocPacketLookup[fastAssoc, #, Model]& /@ allSpecifiedTipObjs
	}]];

	(* Get the containers that are liquid handler incompatible *)
	liquidHandlerIncompatibleContainers=DeleteDuplicates[Flatten[{
		PickList[Lookup[allModelContainerPackets, Object, {}], Lookup[allModelContainerPackets, Footprint, {}], Except[LiquidHandlerCompatibleFootprintP]],
		PickList[Lookup[allModelContainerPlatePackets, Object, {}], Lookup[allModelContainerPlatePackets, LiquidHandlerPrefix, {}], Null]
	}]];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
			"the source/destination containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not liquid handler compatible",
			Nothing
		],
		If[MemberQ[ToList[myDestinations], Waste],
			"the destination Waste is specified (aspirators that transfer into Waste can only be used manually)",
			Nothing
		],
		If[MemberQ[ToList[myAmounts], MassP|CountP],
			"masses and tablet/sachet counts cannot be transferred robotically",
			Nothing
		],
		If[Length[Cases[ToList[myAmounts], GreaterP[970 Microliter]]]>0,
			"a maximum of 970 Microliter can be transferred in one step using a robotic liquid handler",
			Nothing
		],
		If[MatchQ[Total[Cases[ToList[myAmounts], VolumeP]], GreaterP[450 Milliliter]],
			"if transferring more than 450mL in total, we must perform the transfer manually (it exceeds the tip capacity we have on our liquid handler decks)",
			Nothing
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[{MaxMagnetizationTime, ImageSample, MeasureVolume, MeasureWeight, TransferEnvironment, Balance, TabletCrusher, IncludeSachetPouch, ReversePipetting, Needle, Funnel, WeighingContainer, Tolerance, HandPump, QuantitativeTransfer, QuantitativeTransferWashSolution, QuantitativeTransferWashVolume, QuantitativeTransferWashInstrument, QuantitativeTransferWashTips, NumberOfQuantitativeTransferWashes, UnsealHermeticSource, BackfillNeedle, BackfillGas, UnsealHermeticDestination, VentingNeedle, TipRinse, TipRinseSolution, TipRinseVolume, NumberOfTipRinses, IntermediateDecant, IntermediateContainer, IntermediateFunnel, Supernatant, AspirationLayer, DestinationLayer},(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|False|Automatic]]&)];

			If[Length[manualOnlyOptions]>0,
				"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
				Nothing
			]
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[{AspirationMixType, DispenseMixType},(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Pipette|Tilt|Automatic]]&)];

			If[Length[manualOnlyOptions]>0,
				ToString[manualOnlyOptions]<>" can only be set to Swirl when Preparation->Manual",
				Nothing
			]
		],
		If[MemberQ[Lookup[samplePackets, LiquidHandlerIncompatible], True],
			"the following samples are liquid handler incompatible "<>ObjectToString[Lookup[Cases[samplePackets, KeyValuePattern[LiquidHandlerIncompatible->True]], Object], Cache->allPackets],
			Nothing
		],
		Module[{magnetizationOptionSetQ,magnetizedSources,magnetizedSourceContainerModels,nonRoboticMagnetizationSamples},

			(* Get the options with a user-specified magnetization option. Only check if Magnetization -> True, no need to check for False or Null *)
			magnetizationOptionSetQ=MapThread[(TrueQ[#1]||MatchQ[#2,TimeP])&,{ToList[Lookup[safeOptions,Magnetization,Null]],ToList[Lookup[safeOptions,MagnetizationTime,Null]]}];

			(* Get only the sources with a magnetization option set *)
			magnetizedSources=PickList[ToList[mySources],If[Length[magnetizationOptionSetQ]==1,ConstantArray[magnetizationOptionSetQ[[1]],Length[ToList[mySources]]],magnetizationOptionSetQ]];

			(* Get the container the sources are in if it exists *)
			magnetizedSourceContainerModels=Map[
				Switch[#,
					ObjectP[Object[Sample]],
						fastAssocPacketLookup[fastAssoc, #, {Container, Model}],
					{_String,ObjectP[Object[Container]]},
						fastAssocPacketLookup[fastAssoc, #[[2]], Model],
					ObjectP[Model[Sample]], Null,
					_, Null
				]&,
				magnetizedSources
			];

			(* If the Footprint is not Plate or the LiquidHandlerAdapter is not Null, than the container can only be magnetized manually *)
			nonRoboticMagnetizationSamples = MapThread[
				If[!NullQ[#2] && !(MatchQ[fastAssocLookup[fastAssoc, #2, Footprint], Plate] || MatchQ[fastAssocLookup[fastAssoc, #2, LiquidHandlerAdapter], Except[Null]]),
					#1,
					Nothing
				]&,
				{
					magnetizedSources,
					magnetizedSourceContainerModels
				}
			];

			If[Length[nonRoboticMagnetizationSamples] > 0,
				"the following samples are in containers that cannot be magnetized on a liquid handler" <> ObjectToString[nonRoboticMagnetizationSamples],
				Nothing
			]
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		Module[{roboticOnlyOptions},
			roboticOnlyOptions=Select[{AspirationRate, DispenseRate, OverAspirationVolume, AspirationRate, DispenseRate, OverAspirationVolume, OverDispenseVolume, AspirationWithdrawalRate, DispenseWithdrawalRate, AspirationEquilibrationTime, DispenseEquilibrationTime, AspirationMixRate, DispenseMixRate, AspirationPosition, DispensePosition, AspirationPositionOffset, DispensePositionOffset, CorrectionCurve, PipettingMethod, DynamicAspiration, DeviceChannel, CollectionContainer, CollectionTime},(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|False|Automatic]]&)];

			If[Length[roboticOnlyOptions]>0,
				"the following Robotic-only options were specified "<>ToString[roboticOnlyOptions],
				Nothing
			]
		],
		Module[{roboticOnlyOptions},
			roboticOnlyOptions=Select[{AspirationMixType, DispenseMixType},(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Pipette|Swirl|Automatic]]&)];

			If[Length[roboticOnlyOptions]>0,
				ToString[roboticOnlyOptions]<>" can only be set to Tilt when Preparation->Robotic",
				Nothing
			]
		],
		Module[{hamiltonTips},
			(* TODO figure out how to extract these from the fastAssoc*)
			hamiltonTips=PickList[allTipModelPackets, Lookup[allTipModelPackets, PipetteType, {}], Hamilton];

			If[Length[hamiltonTips]>0,
				"the following tips models were specified that are only compatible with a Hamilton liquid handler "<>ObjectToString[hamiltonTips, Cache->allPackets],
				Nothing
			]
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
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
		!MatchQ[Lookup[safeOptions, Preparation], Automatic],
			Lookup[safeOptions, Preparation],
		Length[manualRequirementStrings]>0,
			Manual,
		Length[roboticRequirementStrings]>0,
			Robotic,
		True,
			{Manual, Robotic}
	];

	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Transfer primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];






(* ::Subsection:: *)
(* generateTransferEnvironmentErrorTemplate *)
(* convert list of short reasons in string to a complete sentence stating why cannot we find a transfer environment and such *)

generateTransferEnvironmentErrorTemplate[myList:{__String}] := Module[{handlingConditionResolutionString, balanceString},

	handlingConditionResolutionString = Module[{connectedWords},
		connectedWords = StringRiffle[Cases[myList, "sterile environment (such as a BiosafetyCabinet)" | "inert Handling Atmosphere" | "backfilling gas (for sealing hermetic containers)" | "ventilation (FumeHood)" | "IRProbe temperature monitoring" | (ToString /@ BalanceModeP)] /. {balanceModeString : (ToString /@ BalanceModeP) :> balanceModeString <> " balance"}, ", "];
		If[MatchQ[connectedWords, ""], Nothing, connectedWords <> " integration(s) are required. "]
	];
	balanceString = If[MemberQ[myList, "Balance"], "cannot find a balance located in the requested transfer environment.", Nothing];

	(* add a index to each of the reason strings *)
	MapIndexed[
		(ToString[#2[[1]]] <> ". " <> #1)&,
		{handlingConditionResolutionString, balanceString}
	]

];




(* ::Subsection:: *)
(* resolveExperimentTransferOptions *)

DefineOptions[
	resolveExperimentTransferOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentTransferOptions[
	mySources:{(ObjectP[{Object[Sample], Model[Sample], Object[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]})..},
	myDestinations:{(ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}|Waste)..},
	myAmounts:{(VolumeP|MassP|CountP|All)..},
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[resolveExperimentTransferOptions]
]:=Module[
	{
		outputSpecification, output, gatherTests, messages, warnings, cache, fastAssoc, simulation, fastAssocKeysIDOnly,
		transferOptions,  allSyringeModelPackets, allPipetteModelPackets, allAspiratorModelPackets, allBalanceModelPackets,
		allWeighingContainerModelPackets, allGraduatedCylinderModelPackets, allSpatulaModelPackets, allNeedleModelPackets,
		allTipModelPackets, allTransportConditionPackets, allFumeHoodPackets, allGloveBoxPackets, allBiosafetyCabinetPackets,
		allEnclosurePackets, allBenchPackets, allFunnelPackets, allHandPumpPackets,
		allHandPumpAdapterPackets,allRackModelPackets, allModelConsumablePackets,allHandlingConditionModelPackets,allHandlingStationPackets,handlingConditionSort,
		simulatedSources, simulatedCache, samplePrepTests, simulatedDestinations,
		transferOptionsAssociation,
		(* Download *)
		suppliedInstrument, suppliedBalance, suppliedTips, suppliedNeedles, suppliedWeighingContainers, suppliedHandPumps,
		suppliedQuantitativeTransferWashSolution, suppliedQuantitativeTransferWashInstrument, suppliedQuantitativeTransferWashTips,
		suppliedBackfillNeedle, suppliedVentingNeedle, suppliedTipRinseSolution, suppliedIntermediateContainer,
		suppliedDestinationWells, suppliedTransferEnvironments, suppliedFunnels, suppliedIntermediateFunnel, suppliedSourceWells,
		suppliedMagnetizationRacks, suppliedKeepInstruments, suppliedDestinationRack, suppliedPipettingMethod, parentProtocol,
		preparedResources, suppliedCollectionContainers, suppliedTipType, simulatedSampleObjects, simulatedContainerObjects,
		simulatedSampleModels, simulatedDestinationSamples, simulatedDestinationContainerObjects,
		sourcePackets, sourceContainerPackets, sourceContainerModelPackets, parentProtocolPreparedResources,
		allVolumeCalibrationPackets, sourceSuppliedContainerSamplePackets, sourceSuppliedContainerPackets, sourceSuppliedContainerModelPackets,
		sourceModelPackets, sourceModelProductPackets, destinationPackets, destinationContainerPackets, destinationContainerModelPackets,
		destinationSuppliedContainerPackets, destinationSuppliedContainerModelPackets, suppliedWeighingContainerPackets,
		correctedPreparedResources, transferPreparingResourcesQ, parentProtocolTree, preparedResourcesPackets,
		simulatedCollectionContainerObjects, collectionContainerSuppliedPackets, collectionContainerSuppliedModelPackets,
		allMultichannelPipetteModelPackets, analyticalBalanceMinWeight, analyticalBalanceCutOffWeight, magneticRackCompatibleFootprints, allGraduatedContainerModelPackets,
		(* Resolve Preparation and Workcell *)
		preparationResult, resolvedPreparation, allowedPreparation, preparationTest, allowedWorkCells, resolvedWorkCell,
		(* Resolve SimulatedSources/Destinations *)
		uniqueSampleModelWithSourceIncubations, sampleModelsAmountsWithSourceIncubations, totaledSampleModelAmounts,
		indexedSampleModelGroupings, availableSampleContainerModelPackets, preparedResourcesRule, sterileQ,
		sampleModelWithContainerAndAmount, modelContainerFields, modelContainerPacketFields, simulatedSampleModelPackets,
		simulatedSampleModelContainerPackets, indexMatchedSimulatedSampleModelPackets, indexMatchedSimulatedSampleModelContainerPackets,
		indexMatchedAllSampleModelContainers, resolvedCollectionContainers, resolvedCollectionTimes, allUniqueContainerPackets, emptySampleForContainerPacket,
		containerPacketsWithSimulatedContents, allContainerSimulatedSamples, uniqueDestinationLabelsForContainerSimulation,
		containerAndSamplePacketForContainersWithIndices, workingSourceSamplePackets, workingSourceContainerPackets,
		workingSourceContainerModelPackets, simulatedWorkingSourceQ, resolvedSourceWells, simulatedSourceObjects,
		workingDestinationSamplePackets, simulatedDestinationObjects, workingCollectionContainerSamplePackets, resolvedDestinationWells,
		workingCollectionContainerPackets, destinationSuppliedContainerSamplePackets, workingDestinationContainerPackets,
		workingDestinationContainerModelPackets, wasteContainerID,
		(* Track errors *)
		missingSampleErrors, missingSampleErrorsTest, overaspirationWarnings, overaspirationTests, overfilledErrors, overfilledTests,
		hermeticSourceErrors, sourceHermeticTests, hermeticDestinationErrors, destinationHermeticTests, weighingContainerErrors,balanceCleaningMethodRequiredErrors,
		instrumentCapacityErrors, liquidLevelErrors, liquidLevelTest, dispenseMixTest, invalidDispenseMixOptions, aspirationMixTest,
		invalidAspirationMixOptions, invalidTiltMixOptions ,invalidTiltMixTest, tipRinseTest, invalidTipRinseOptions,
		quantitativeTransferTest, invalidQuantitativeTransferOptions,
		weighingContainerTest, balanceCleaningMethodRequiredTest, instrumentCapacityTest, invalidToleranceTest, invalidTolerancesResult, incorrectlySpecifiedTransferOptionsTest,
		requiredOrCantBeSpecifiedResult, invalidWellTest, invalidWellResult, pillCrusherWarnings,
		sachetMassWarnings, spatulaCapacityWarnings, sachetMassTest,spatulaCapacityTest, gaseousSampleErrors,incompatibleTipItemConsumableResult,incompatibleTipItemConsumableTest,
		gaseousSampleTest, incompatibleQuantitativeTransferWeighingContainerErrors,incompatibleQuantitativeTransferWashTipsErrors,incompatibleQuantitativeTransferWashInstrumentErrors,noCompatibleWeighingContainerErrors,incompatibleWeighingContainerErrors, noCompatibleFunnelErrors,incompatibleDestinationContainerErrors, incompatibleIntermediateContainerErrors,recoupContaminationErrors,recoupContaminationTest,incompatibleSpatulaWidthErrors,
		incompatibleFTVIntermediateContainerErrors,incompatibleFTVIntermediateDecantErrors,incompatibleQuantitativeTransferWeighingContainerTest,noCompatibleWeighingContainerTest,incompatibleWeighingContainerTest,noCompatibleFunnelTest,incompatibleQuantitativeTransferWashTipsTest,incompatibleQuantitativeTransferWashInstrumentTest,incompatibleFTVInstrumentErrors,incompatibleFTVFunnelErrors,invalidNumberOfQuantitativeTransferWashesError,
		incompatibleDestinationContainerTest,incompatibleFTVIntermediateContainerTest,incompatibleFTVIntermediateDecantTest,incompatibleIntermediateContainerTest, solidSampleVolumeErrors,
		solidSampleVolumeTest, invalidPrecisionResult, invalidPrecisionTest, instrumentRequiredResult, instrumentRequiredTest,
		plateInstrumentRequiredResult, plateInstrumentRequiredTest, balanceToleranceResult, balanceToleranceTest,
		funnelDestinationResult, funnelDestinationTest, funnelIntermediateResult, funnelIntermediateTest, aqueousGloveBoxErrors,
		anhydrousGloveBoxWarnings, aqueousGloveBoxTest, invalidMultichannelTransferTest, invalidMultichannelTransferInstrumentResult,
		invalidCellAspiratorTest, invalidCellAspiratorResult, layerSupernatantLiquidErrors, layerSupernatantTest,
		aspirationLayerSupernatantMismatchTest, aspirationLayerSupernatantMismatchResult, layerInstrumentMismatchTest,
		layerInstrumentMismatchResult, magnetizationSpecifiedTest, magnetizationSpecifiedResult, magneticRackErrors,
		magneticRackTest, invalidAspiratorAmountResult, invalidAspiratorAmountTest, noCompatibleTipsErrors, noCompatibleTipsTest,
		noCompatibleSyringesErrors, noCompatibleSyringesTest, restrictTest, outOfBoundsTest, outOfBoundsResult, tiltNonPlateResult,
		monotonicCorrectionCurveWarnings, monotonicCorrectionCurveTest, incompleteCorrectionCurveWarnings, incompleteCorrectionCurveTest,
		invalidZeroCorrectionErrors, invalidZeroCorrectionTest, tiltNonPlateTest, incompatibleTipsTest, incompatibleTipsResult,
		collectionContainerSpecifiedResult, collectionContainerSpecifiedTest,
		collectionContainerFootprintResult, collectionContainerFootprintTest, invalidAspirationMixVolumeOptions,
		invalidDispenseMixVolumeOptions, invalidAspirationMixVolumeTests, invalidDispenseMixVolumeTests,
		multichannelAspirationMixTest, multichannelDispenseMixTest ,roundedTransferAmountTest, roundedTransferAmountResult,
		volumePrecisionRoundQs, sterileSourceDestinationWarningSources, sterileSourceDestinationWarningDests, sterileSourceDestinationWarningTests,
		sterileTransfersAreInBSCResult, sterileTransfersAreInBSCTest, compatibleTransfersEnvWithInstrumentResult,
		compatibleTransfersEnvWithInstrumentTest, aspiratorsRequireSterileTransferResult, aspiratorsRequireSterileTransferTest,
		backfillGasResult, backfillGasTest, invalidQuantitativeTransferVolumes, quantitativeTransferVolumeTest,
		invalidTransferEnvironmentBalanceResult, invalidTransferEnvironmentBalanceTest, aspiratableOrDispensableFalseResult,
		aspiratableOrDispensableFalseTest, invalidTransferTemperatureResult, transferTemperatureTest, sterileTransfersAreInSTAR,
		sterileTransfersAreInSTARTest, conflictingRestrictSourceAndDestinationResult, asepticHandlingSourceDestinationWarnings,
		aspirationMixVolumeErrors, dispenseMixVolumeErrors, multichannelAspirationMixWarnings, multichannelDispenseMixWarnings,
		smallQuantityQuantitativeTransfers, smallQuantityQuantitativeTransferTest, noTransferEnvironmentAvailableErrors, noTransferEnvironmentAvailableOptions,
		noTransferEnvironmentAvailableTest, invalidTransferEnvironmentErrors, invalidTransferEnvironmentOptions, invalidTransferEnvironmentTest,
		volatileHazardousSamplesInBSCError, volatileHazardousSamplesInBSCMessage, volatileHazardousSamplesInBSCTest, inputBlendedMapThreadFriendlyOptions,
		(* *)
		optionsAndPrecisions, roundedOptions, roundedOptionTests,
		mapThreadFriendlyOptions, resolvedInstrument, resolvedTransferEnvironment, resolvedBalance,resolvedBalancePreCleaningMethod,
		resolvedBalanceCleaningMethods, resolvedTips, resolvedTipType, resolvedTipMaterial,
		resolvedReversePipetting, resolvedNeedle, resolvedFunnel, resolvedWeighingContainer, resolvedTolerance,
		resolvedHandPump, resolvedQuantitativeTransfer, resolvedQuantitativeTransferWashSolution, resolvedQuantitativeTransferWashVolume,
		resolvedQuantitativeTransferWashInstrument, resolvedQuantitativeTransferWashTips, resolvedNumberOfQuantitativeTransferWashes,
		resolvedUnsealHermeticSource, resolvedUnsealHermeticDestination, resolvedBackfillNeedle, resolvedBackfillGas,
		resolvedVentingNeedle, resolvedTipRinse, resolvedTipRinseSolution, resolvedTipRinseVolume, resolvedNumberOfTipRinses,
		resolvedAspirationMix, resolvedAspirationMixType, resolvedNumberOfAspirationMixes, resolvedDispenseMix,
		resolvedDispenseMixType, resolvedNumberOfDispenseMixes, resolvedIntermediateDecant, resolvedIntermediateContainer, resolvedIntermediateFunnel,
		resolvedSourceTemperature, resolvedSourceEquilibrationTime, resolvedMaxSourceEquilibrationTime,
		resolvedSourceEquilibrationCheck, resolvedDestinationTemperature, resolvedDestinationEquilibrationTime,
		resolvedMaxDestinationEquilibrationTime, resolvedCoolingTime, resolvedSolidificationTime, resolvedFlameDestination, resolvedDestinationEquilibrationCheck,
		resolvedParafilmDestination, resolvedAmount, allResolvedCoverTests,
		resolvedTabletCrusher, resolvedIncludeSachetPouch, resolvedSachetIntermediateContainers,
		resolvedSterileTechnique, resolvedRNaseFreeTechnique, preresolvedInstruments, resolvedMultichannelTransfers,
		resolvedMultichannelTransferNames, resolvedSupernatant, resolvedAspirationLayer, resolvedMagnetization,
		resolvedMagnetizationTime, resolvedMaxMagnetizationTime, resolvedMagnetizationRack, resolvedSourceContainers, resolvedSourceSampleGroupings,
		resolvedSourceLabels, resolvedSourceContainerLabels, resolvedDestinationLabels, resolvedDestinationContainerLabels,
		objectToNewResolvedLabelLookup, resolvedPipettingMethod, resolvedAspirationRate, resolvedDispenseRate,
		resolvedOverAspirationVolume, resolvedOverDispenseVolume, resolvedAspirationWithdrawalRate, resolvedDispenseWithdrawalRate,
		resolvedAspirationEquilibrationTime, resolvedDispenseEquilibrationTime, resolvedAspirationMixVolume,
		resolvedDispenseMixVolume, resolvedAspirationMixRate, resolvedDispenseMixRate, resolvedAspirationPosition,
		resolvedDispensePosition, resolvedAspirationPositionOffset, resolvedDispensePositionOffset, resolvedCorrectionCurve,
		resolvedDynamicAspiration, resolvedDeviceChannels, volumetricFlaskFTVQ, mapThreadFriendlyOptionsWithPreResolvedOptions, parentProtocolSite,
		specifiedSite, resolvedReplaceSourceCovers, resolvedSourceCovers, resolvedSourceSeptums, resolvedSourceStoppers,
		resolvedReplaceDestinationCovers, resolvedDestinationCovers, resolvedDestinationSeptums, resolvedDestinationStoppers,
		resolvedLivingDestinations, invalidCoverOptions, resolvedMaxNumberOfAspirationMixes,
		resolvedSlurryTransfer, resolvedKeepSourceCovered, resolvedKeepDestinationCovered, resolvedAspirationAngles,
		resolvedDispenseAngles, resolvedAllowSourceContainerReCovers, resolvedMultiProbeHeadRows, resolvedMultiProbeColumns,
		resolvedMultiProbeAspirationOffsetRows, resolvedMultiProbeAspirationOffsetColumns, resolvedMultiProbeDispenseOffsetRows,
		resolvedMultiProbeDispenseOffsetColumns, incorrectMultiProbeHeadTransfer, tupleToWell, wellToTuple, rectangleQ,
		invalidMultiProbeHeadDimensionsTest, map96Integers, invalidMNDispenseErrors, invalidMNDispenseOptionsTest,
		invalidSamplesInStorageConditionBools,invalidSamplesInStorageConditionOptions,invalidSamplesInStorageConditionTests,
		invalidNonDisposalSamplesInStorageConditionBools, invalidNonDisposalSamplesInStorageConditionOptions,
		invalidNonDisposalSamplesInStorageConditionTests, resolvedSupplementalCertificates, restrictSourceOptions, restrictDestinationOptions,
		resolvedRestrictSource, resolvedRestrictDestination, reversePipettingSamples,
		resolvedOptions, mapThreadFriendlyResolvedOptions,resolvedHandlingCondition,resolvedEquivalentTransferEnvironments, resolvedOverdrawVolume, resolvedOverdrawVolumeWasteContainer, resolvedWasteContainer,
		resolvedWeightStabilityDurations, resolvedMaxWeightVariations, resolvedTareWeightStabilityDurations, resolvedMaxTareWeightVariations, getHandlingStations,
		(* Resources *)
		resourceRentContainerBools, resourceFreshBools,
		(* Final *)
		invalidInputs, invalidOptions, resolvedPostProcessingOptions,
		resolvedModelSampleContainers
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	(* warnings assume we're not in engine; if we are they are not surfaced *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;
	warnings = !gatherTests && !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	fastAssoc = makeFastAssocFromCache[cache];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* get the fastAssoc Keys, but only the ones in the ID form (not the name form) *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];

	(* Separate out our Transfer options from our Sample Prep options. *)
	transferOptions=myOptions;

	(* Get our constant packets that we cache up front. We already did this in the main experiment function so this is fully memoized.  Just need this for some variable names below *)
	{
		allSyringeModelPackets,
		allPipetteModelPackets,
		allAspiratorModelPackets,
		allBalanceModelPackets,
		allWeighingContainerModelPackets,
		allGraduatedCylinderModelPackets,
		allSpatulaModelPackets,
		allNeedleModelPackets,
		allTipModelPackets,
		allTransportConditionPackets,
		allFumeHoodPackets,
		allGloveBoxPackets,
		allBiosafetyCabinetPackets,
		allEnclosurePackets,
		allBenchPackets,
		allFunnelPackets,
		allRackModelPackets,
		allModelConsumablePackets,
		allGraduatedContainerModelPackets,
		allHandPumpPackets,
		allHandPumpAdapterPackets,
		allHandlingConditionModelPackets,
		allHandlingStationPackets
	} = transferModelPackets[ToList[myOptions]];

	(* helper function to sort any list of handling conditions based on "accessibility" *)
	(* the actual sorting is already done in nonDeprecatedTransferModelPackets so allHandlingStationPackets comes out sorted *)
	handlingConditionSort[in_List] := Module[{flattenedIn, objectPacketLookup},
		(* flatten input to remove empty lists, i.e., any ProvidedHandlingConditions that are deprecated or developer object *)
		flattenedIn = Flatten[in];
		(* make a object -> packet lookup similar as fast cache *)
		objectPacketLookup = AssociationThread[Lookup[flattenedIn, Object] -> flattenedIn];
		(* use UnsortedIntersection so order remains *)
		Lookup[objectPacketLookup, UnsortedIntersection[Lookup[allHandlingConditionModelPackets, Object], Download[flattenedIn, Object]]]
	];
	
	(* quick helper to get handling station from handling conditions, and do additional stuffs *)
	(* input can be a single condition, or a list of condition objects *)
	(* remember to exclude the specialized handling station models that we should not auto-resolve! *)
	getHandlingStations[myHandlingConditions_] := UnsortedComplement[DeleteDuplicates[Flatten[Lookup[handlingConditionInstrumentLookup["Memoization"], myHandlingConditions, {}]]], $SpecializedHandlingStationModels];

	(* Resolve our sample prep options *)
	{simulatedSources, simulatedCache, samplePrepTests} = {
		ToList[mySources]/.{obj:ObjectP[]:>Download[obj, Object]}, cache, {}
	};

	(* Our destinations will not be simulated since sample prep only applies to the sources. *)
	simulatedDestinations=myDestinations/.{obj:ObjectP[]:>Download[obj, Object]};

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	transferOptionsAssociation = Association[transferOptions];

	(* Pull the info out of the options that we need to download from *)
	{
		suppliedInstrument,suppliedBalance,suppliedTips,suppliedNeedles,suppliedWeighingContainers,suppliedHandPumps,suppliedQuantitativeTransferWashSolution,
		suppliedQuantitativeTransferWashInstrument,suppliedQuantitativeTransferWashTips,suppliedBackfillNeedle,suppliedVentingNeedle,suppliedTipRinseSolution,
		suppliedIntermediateContainer,suppliedDestinationWells,suppliedTransferEnvironments,suppliedFunnels,suppliedIntermediateFunnel,
		suppliedSourceWells,suppliedMagnetizationRacks,suppliedKeepInstruments,suppliedDestinationRack, suppliedPipettingMethod, parentProtocol, preparedResources, suppliedCollectionContainers
	}=Lookup[transferOptionsAssociation,
		{
			Instrument,Balance,Tips,Needle,WeighingContainer,HandPump,QuantitativeTransferWashSolution,QuantitativeTransferWashInstrument,
			QuantitativeTransferWashTips,BackfillNeedle,VentingNeedle,TipRinseSolution,
			IntermediateContainer,DestinationWell,TransferEnvironment,Funnel,IntermediateFunnel,
			SourceWell,MagnetizationRack,KeepInstruments,DestinationRack,PipettingMethod, ParentProtocol, PreparedResources, CollectionContainer
		}
	];

	(* get the supplied tip type if we have it; this will be important for resolving multichannel pipettes later on *)
	suppliedTipType = Map[
		Switch[#,
			ObjectP[Model[Item, Tips]], fastAssocLookup[fastAssoc, #, TipConnectionType],
			ObjectP[Object[Item, Tips]], fastAssocLookup[fastAssoc, #, {Model, TipConnectionType}],
			_, Null
		]&,
		suppliedTips
	];

	simulatedSampleObjects=DeleteDuplicates@Cases[simulatedSources, ObjectP[Object[Sample]]];
	simulatedContainerObjects=DeleteDuplicates@Cases[Flatten[simulatedSources], ObjectP[Object[Container]]];
	simulatedSampleModels=DeleteDuplicates@Cases[simulatedSources, ObjectP[Model[Sample]]];
	simulatedDestinationSamples=DeleteDuplicates@Cases[Flatten[{simulatedDestinations}], ObjectP[Object[Sample]]];
	simulatedDestinationContainerObjects=DeleteDuplicates@Cases[Flatten[{simulatedDestinations}], ObjectP[{Object[Container], Object[Item]}]];

	(* pull everything out of our huge fastAssoc *)
	sourcePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedSampleObjects;
	sourceContainerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ simulatedSampleObjects;
	sourceContainerModelPackets = fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ simulatedSampleObjects;
	parentProtocolPreparedResources = If[NullQ[parentProtocol],
		ConstantArray[Null, Length[simulatedSampleObjects]],
		Lookup[fetchPacketFromFastAssoc[parentProtocol, fastAssoc], PreparedResources]
	];

	(* pull out all the calibration packets *)
	allVolumeCalibrationPackets = With[{volumeCalibrations = Cases[fastAssocKeysIDOnly, ObjectP[Object[Calibration, Volume]]]},
		fetchPacketFromFastAssoc[#, fastAssoc]& /@ volumeCalibrations
	];

	sourceSuppliedContainerSamplePackets = With[{contents = fastAssocLookup[fastAssoc, #, Contents][[All, 2]]& /@ simulatedContainerObjects},
		fetchPacketFromFastAssoc[#, fastAssoc]& /@ Flatten[contents]
	];

	sourceSuppliedContainerPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedContainerObjects;
	sourceSuppliedContainerModelPackets = fastAssocPacketLookup[fastAssoc, #, Model]& /@ simulatedContainerObjects;

	sourceModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedSampleModels;
	sourceModelProductPackets = Flatten[Map[
		Function[{sourceModel},
			Module[{sourceModelPacket, allProductPackets, allDefaultContainerModelPackets},
				sourceModelPacket = fetchPacketFromFastAssoc[sourceModel, fastAssoc];
				allProductPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[sourceModelPacket, ObjectReferenceP[Object[Product]], Infinity];
				allDefaultContainerModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Lookup[allProductPackets, DefaultContainerModel];

				{
					allProductPackets,
					allDefaultContainerModelPackets
				}
			]
		],
		simulatedSampleModels
	]];

	destinationPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedDestinationSamples;
	destinationContainerPackets = fastAssocPacketLookup[fastAssoc, #, {Container}]& /@ simulatedDestinationSamples;
	destinationContainerModelPackets = fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ simulatedDestinationSamples;

	destinationSuppliedContainerSamplePackets = With[{
		contents = Map[
			If[MatchQ[fastAssocLookup[fastAssoc, #, Contents], $Failed],
				{},
				fastAssocLookup[fastAssoc, #, Contents][[All, 2]]
			]&,
			simulatedDestinationContainerObjects
		]
	},
		fetchPacketFromFastAssoc[#, fastAssoc]& /@ Flatten[contents]
	];
	destinationSuppliedContainerPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedDestinationContainerObjects;
	destinationSuppliedContainerModelPackets = fastAssocPacketLookup[fastAssoc, #, Model]& /@ simulatedDestinationContainerObjects;

	suppliedWeighingContainerPackets = With[{weighingContainerObjs = DeleteDuplicates@Cases[Flatten[{suppliedWeighingContainers, suppliedCollectionContainers}], ObjectP[Object[]]]},
		fetchPacketFromFastAssoc[#, fastAssoc]& /@ weighingContainerObjs
	];

	(* Find the 'True' PreparedResources *)
	(* If this is a subprotocol call of a MSP protocol, we should try to look at the parent MSP protocol's PreparedResources field instead of the PreparedResources option for this function call*)
	(* If the parent protocol's PreparedResources index-match with input sample, and there's only one transfer UO in OutputUnitOperations field of the parent protocol, we assume this transfer call is trying to prepare the same resource *)
	(* We cannot directly pass the PreparedResources option though, because Preparation field of Object[Resource, Sample] is single *)
	correctedPreparedResources = If[MatchQ[parentProtocol, ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]}]]&&SameLengthQ[simulatedSources, parentProtocolPreparedResources]&&MatchQ[Lookup[fetchPacketFromFastAssoc[parentProtocol, fastAssoc], OutputUnitOperations], {ObjectP[Object[UnitOperation, Transfer]]}],
		parentProtocolPreparedResources,
		preparedResources
	];

	(* We need to pass the information on whether we are preparing resources to resource packet, so defining a global variable to carry this info *)
	transferPreparingResourcesQ = If[MatchQ[correctedPreparedResources, {ObjectP[]..}],
		True,
		False
	];

	(* recursively go up the ParentProtocol chain *)
	parentProtocolTree = If[NullQ[parentProtocol],
		{},
		Prepend[repeatedFastAssocLookup[fastAssoc, parentProtocol, ParentProtocol],parentProtocol]
	];

	preparedResourcesPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ ToList[correctedPreparedResources];

	simulatedCollectionContainerObjects = DeleteDuplicates@Cases[Flatten[Lookup[transferOptions, CollectionContainer]], ObjectP[{Object[Container]}]];
	collectionContainerSuppliedPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedCollectionContainerObjects;
	collectionContainerSuppliedModelPackets = fastAssocPacketLookup[fastAssoc, #, Model]& /@ simulatedCollectionContainerObjects;

	(* Add any model packets to our model packet lists. This is because we could have the user passing us an object *)
	(* whose model is deprecated and we don't download deprecated models by default. *)
	allTipModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectReferenceP[Model[Item, Tips]]];
	allNeedleModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectReferenceP[Model[Item, Needle]]];
	allSpatulaModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectReferenceP[Model[Item, Spatula]]];
	allBalanceModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectReferenceP[Model[Instrument, Balance]]];
	allWeighingContainerModelPackets=Flatten[{allWeighingContainerModelPackets, Cases[Flatten@suppliedWeighingContainerPackets, PacketP[Model[]]]}];

	allMultichannelPipetteModelPackets=Cases[allPipetteModelPackets, KeyValuePattern[Channels -> GreaterP[1]]];

	(* Get a cutoff MinWeight of our Analytical balance, which is the weight that we need to resolve to Micro balance in the enclosure *)
	(* TODO We actually need a correct way to determine this, or decide a reasonable arbitrary number. This MinWeight number is 20 mg from database. However, with even the smallest weigh boat, we have a tare weight of 214 mg, which is higher than the limit. The MinWeight of the balance should not be affected by taring action. *)
	analyticalBalanceMinWeight=Min[Lookup[Cases[allBalanceModelPackets,KeyValuePattern[Mode->Analytical]],MinWeight]];
	(* Currently set a value to 10 mg to avoid too much traffic to micro balance. This is also the value suggested by our customer. *)
	analyticalBalanceCutOffWeight=10Milligram;

	(* Figure out what kinds of containers are compatible with our magnetic racks. *)
	magneticRackCompatibleFootprints=DeleteDuplicates[
		Lookup[
			Flatten[Lookup[Cases[allRackModelPackets, KeyValuePattern[Magnetized->True]], Positions, {}]],
			Footprint,
			{}
		]
	];

	(* Resolve our preparation option. *)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveTransferMethod[mySources, myDestinations, myAmounts, ReplaceRule[transferOptions, {Cache->cache, Output->Result}]],
				{}
			},
			resolveTransferMethod[mySources, myDestinations, myAmounts, ReplaceRule[transferOptions, {Cache->cache, Output->{Result, Tests}}]]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Resolve the work cell that we're going to operator on. *)
	allowedWorkCells = resolveExperimentTransferWorkCell[mySources, myDestinations, myAmounts, ReplaceRule[transferOptions, {Preparation -> resolvedPreparation, Cache -> cache, Output -> Result}]];

	resolvedWorkCell = FirstOrDefault[allowedWorkCells];

	(* We have to thread together our source and destination packets in order since we split up the samples from the *)
	(* containers and sample models that we got as input. This is also where we will have to simulate any *)
	(* Model[Sample]s that we were given. *)

	(* Get the total amount of any Model[Sample]s that we were given in our source list. *)
	(* First, get the unique sample models we have with the consideration of their incubation parameters *)
	uniqueSampleModelWithSourceIncubations=Cases[
		DeleteDuplicates[
			Transpose[{
				simulatedSources/.{link_Link:>Download[link,Object]},
				(* Get all the source incubation option values *)
				(* Note that these options are now possible Automatic. For the same Model[Sample], Automatic(s) will resolve to the same values later so this does not affect our grouping *)
				Lookup[myOptions, SourceTemperature]/.{Ambient->$AmbientTemperature, Cold->4 Celsius},
				Lookup[myOptions, SourceEquilibrationTime],
				Lookup[myOptions, MaxSourceEquilibrationTime]
			}]
		],
		{ObjectP[Model[Sample]],___}
	];

	(* Put the sample models and amounts and the source container incubation parameters together *)
	sampleModelsAmountsWithSourceIncubations=Cases[
		Transpose[{
			simulatedSources/.{link_Link:>Download[link, Object]},
			(* Get all the source incubation option values *)
			Lookup[myOptions, SourceTemperature]/.{Ambient->$AmbientTemperature, Cold->4 Celsius},
			Lookup[myOptions, SourceEquilibrationTime],
			Lookup[myOptions, MaxSourceEquilibrationTime],
			myAmounts,
			(* Append an index for resource grouping (If a certain model goes beyond 200 mL for robotic (reservoir) or 20 L for manual (carboy), we will need to request multiple resources for handling). A single transfer in Robotic handling will never go beyond 200 mL due to the limit of the destination size so we won't worry about splitting a single transfer source. *)
			Range[Length[simulatedSources]]
		}],
		{ObjectP[Model[Sample]], ___}
	];

	(* For each sample model, tally up the amount requested. If we were asked for All, assume that means 1 Milliliter for *)
	(* simulation purposes. We will yell about this later in our error checking. *)

	(* NOTE: This is the same amount logic as in the resource packets. It should be identical. *)
	totaledSampleModelAmounts=Flatten@Map[
		Function[
			{sampleModelTuple},
			Module[{tuples, amounts, indices, modelPacket, state, amountsWithoutAll, amountsWithoutGravimetricLiquid,maxTransferAmountSolid, roboticReservoirMaxVolume,splitAmounts},
				(* Get all tuples for this Model[Sample]. *)
				tuples=Cases[sampleModelsAmountsWithSourceIncubations, {Sequence@@sampleModelTuple, _, _}];

				(* Get the amounts of the sources requesting this model *)
				amounts=tuples[[All,-2]];

				(* Get the indices of the sources requesting this model *)
				indices=tuples[[All,-1]];

				(* Get the state of our Model[Sample] at room temperature. *)
				modelPacket=fetchPacketFromFastAssoc[sampleModelTuple[[1]], fastAssoc];
				state=Lookup[modelPacket, State];

				(* If we see an All, covert it to 1 mL or 1 gram, depending on the state of the model. *)
				amountsWithoutAll=If[MemberQ[amounts, All],
					If[MatchQ[state, Liquid],
						amounts/.{All->1 Milliliter},
						amounts/.{All->1 Gram}
					],
					amounts
				];

				(* If we were given a mass, but the state of our Model[Sample] at RT is a liquid, convert the mass to a volume *)
				(* using density information. If there is no density information, use the density of water times a buffer amount. *)
				amountsWithoutGravimetricLiquid=If[MemberQ[amountsWithoutAll, MassP] && MatchQ[state,Liquid],
					If[MatchQ[Lookup[modelPacket, Density], DensityP],
						amountsWithoutAll/.{mass:MassP:>mass/Lookup[modelPacket, Density]},
						amountsWithoutAll/.{mass:MassP:>(mass/Quantity[0.997`, ("Grams")/("Milliliters")] * 1.25)}
					],
					amountsWithoutAll
				];

				(* For solid sample, use its density to figure out the max amount we cant put in a reservoir so we can split if necessary *)
				maxTransferAmountSolid=If[MatchQ[Lookup[modelPacket, Density], DensityP],
					($MaxTransferVolume/1.1)/.{mass:MassP:>mass/Lookup[modelPacket, Density]},
					($MaxTransferVolume/1.1)/.{mass:MassP:>(mass/Quantity[0.997`, ("Grams")/("Milliliters")] * 1.25)}
				];

				(* when we have amountsWithoutGravimetricLiquid being larger than 155 mL for robotic (the maximum robotic amount we can put into one container is 200 mL and MinVolume of the container is 30 mL. with 10% resource extra, the container can hold up to 155 mL resource.) we must split the resource request when it is above this amount *)
				(* Define this number so we can easily use it later *)
				roboticReservoirMaxVolume=($MaxRoboticTransferVolume-$RoboticReservoirDeadVolume)/1.1;
				(* we don't need to worry about solid here since that is not supported in Robotic transfer *)
				(* same thing for manual transfer over 20 Liter/1.1 or 20 Kilogram/1.1, we have to split since our largest container is the reservoir *)
				splitAmounts=Which[
					(* Robotic splitting case *)
					MatchQ[state,Liquid]&&MatchQ[Total[amountsWithoutGravimetricLiquid],GreaterP[roboticReservoirMaxVolume]]&&MatchQ[resolvedPreparation,Robotic],
					(* Split the resource amounts (with indices trying to make each group as large as possible) *)
					(* Sort the amounts and try to group from the largest request. Fill in small amounts into the first possible group *)
					Fold[
						If[MemberQ[(Total/@(#1[[All,All,1]]))/.{0->0Microliter},LessEqualP[(roboticReservoirMaxVolume-#2[[1]])]],
							(* If a group can accept this new value, we will put it in there *)
							Module[
								{firstSmallGroupPosition},
								firstSmallGroupPosition=First@FirstPosition[(Total/@(#1[[All,All,1]]))/.{0->0Microliter},LessEqualP[(roboticReservoirMaxVolume-#2[[1]])]];
								ReplacePart[#1,firstSmallGroupPosition->Append[#1[[firstSmallGroupPosition]],#2]]
							],
							(* Start a new group *)
							Append[#1, {#2}]
						]&,
						(* Start with empty list *)
						{},
						(* Sort *)
						ReverseSortBy[
							Transpose[{
								amountsWithoutGravimetricLiquid,
								indices
							}],
							First
						]
					],
					(* Manual splitting case - Liquid *)
					MatchQ[Total[amountsWithoutGravimetricLiquid],GreaterEqualP[$MaxTransferVolume/1.1]]&&MatchQ[resolvedPreparation,Manual],
					(* Split the resource amounts (with indices trying to group all requests in order *)
					(* If the last group can take this new request, combine them. If not, start a new group *)
					Fold[
						If[MatchQ[(Total[(#[[-1,All,1]])])/.{0->0Microliter},LessEqualP[($MaxTransferVolume/1.1-#2[[1]])]],
							ReplacePart[#1,(-1)->Append[#1[[-1]],#2]],
							(* Start a new group *)
							Append[#1, {#2}]
						]&,
						(* Start with the first transfer request as a list *)
						{{First@Transpose[{
							amountsWithoutGravimetricLiquid,
							indices
						}]}},
						(* Process the transfer requests in order so we can save operator time grabbing different bottles of resources *)
						Rest@Transpose[{
							amountsWithoutGravimetricLiquid,
							indices
						}]
					],
					(* Manual splitting case - Solid *)
					MatchQ[Total[amountsWithoutGravimetricLiquid],GreaterEqualP[maxTransferAmountSolid/1.1]]&&MatchQ[resolvedPreparation,Manual],
					(* Split the resource amounts (with indices trying to group all requests in order *)
					(* If the last group can take this new request, combine them. If not, start a new group *)
					Fold[
						If[MatchQ[(Total[(#[[-1,All,1]])])/.{0->0Microliter},LessEqualP[(maxTransferAmountSolid-#2[[1]])]],
							ReplacePart[#1,(-1)->Append[#1[[-1]],#2]],
							(* Start a new group *)
							Append[#1, {#2}]
						]&,
						(* Start with the first transfer request as a list *)
						{{First@Transpose[{
							amountsWithoutGravimetricLiquid,
							indices
						}]}},
						(* Process the transfer requests in order so we can save operator time grabbing different bottles of resources *)
						Rest@Transpose[{
							amountsWithoutGravimetricLiquid,
							indices
						}]
					],
					(* If we don't have too large volume, we only have one group *)
					True,
					{Transpose[{
						amountsWithoutGravimetricLiquid,
						indices
					}]}
				];

				(* Total it up. Each sample model may now have more than one instance required *)
				(sampleModelTuple->{Total[#[[All,1]]],#[[All,2]]})&/@splitAmounts
			]
		],
		uniqueSampleModelWithSourceIncubations
	];

	indexedSampleModelGroupings=Flatten@Map[
		Function[
			{resourceGroup},
			Module[
				{index},
				(* Use a unique string to indicate that these resources are the same group *)
				index=CreateUUID[];
				(* Record this index and the total amount *)
				(#->{index,resourceGroup[[1]]})&/@(resourceGroup[[2]])
			]
		],
		Values[totaledSampleModelAmounts]
	];


	(* PreparedResources should be index-matched to our samples, make sure we are  *)
	preparedResourcesRule=AssociationThread[simulatedSources,correctedPreparedResources];

	(* Decide if we want our samples to be in sterile containers for robotic handling. This is True for bioSTAR/microbioSTAR and False for STAR *)
	sterileQ=MatchQ[resolvedWorkCell,(bioSTAR | microbioSTAR)];

	(* call helper to resolve a container for any Model[Sample] in the source *)
	resolvedModelSampleContainers = If[Length[totaledSampleModelAmounts] == 0,
		{},
		resolveModelSampleContainer[
			(* list of Model[Sample]s *)
			totaledSampleModelAmounts[[All, 1, 1]],
			(* the amount in volume for each Model[Sample] *)
			totaledSampleModelAmounts[[All, 2, 1]],
			(* parent protocol *)
			parentProtocol,
			(* root protocol *)
			Last[Flatten[{parentProtocolTree}], parentProtocol],
			(* sterile booleans *)
			ConstantArray[sterileQ, Length[totaledSampleModelAmounts]],
			(* resolved method *)
			resolvedPreparation,

			(* PreparedResource of each Model[Sample] *)
			PreparedResources -> Lookup[preparedResourcesRule, totaledSampleModelAmounts[[All, 1, 1]]],
			(* see if incubation is needed for each sample model *)
			Incubate -> (MemberQ[#, Except[(Null | Automatic)]]& /@ totaledSampleModelAmounts[[All, 1, 2;;]]),

			Cache -> cache,
			Simulation -> simulation
		]
	];

	(* create the information tuple for each sample model in the form of:
	 {{< sample model with incubation infos >, < resolved container model >, < required total amount >, < group index >}..}
	*)
	sampleModelWithContainerAndAmount = Transpose[{
		(* sample model with incubation infos *)
		totaledSampleModelAmounts[[All, 1]],
		(* resolved container model *)
		resolvedModelSampleContainers,
		(* required total amount *)
		totaledSampleModelAmounts[[All, 2, 1]],
		(* group indices *)
		totaledSampleModelAmounts[[All, 2, 2]]
	}];

	(* Fields to download. Keep this in sync with the experiment function. *)
	modelContainerFields=DeleteDuplicates[Flatten[{
		DeveloperObject, MultiProbeHeadIncompatible, BuiltInCover, CoverTypes, CoverFootprints, Parafilm, AluminumFoil,
		CoverType, CoverFootprint, CrimpType, SeptumRequired, Opaque, Reusable, EngineDefault, NotchPositions, SealType,
		HorizontalPitch,VerticalPitch,VolumeCalibrations,Columns,Aperture,WellDepth,Sterile,RNaseFree,Squeezable,Material,Counted,
		TareWeight,Weight,SolutionVolume,Object,Positions,Hermetic,Ampoule,MaxVolume,IncompatibleMaterials, Products, Dimensions,FunnelStemDiameter,FunnelStemLength,Graduations, GraduationType, GraduationLabels, CrossSectionalShape,SamplePreparationCacheFields[Model[Container]]}]];
	modelContainerPacketFields=Packet@@modelContainerFields;

	availableSampleContainerModelPackets=Quiet[
		If[Length[sampleModelWithContainerAndAmount] == 0,
			{},
			Download[Flatten[sampleModelWithContainerAndAmount[[All,2]]], modelContainerPacketFields]
		],
		{Download::FieldDoesntExist}
	];

	(* Append these container model packets to our global list of container model packets. *)
	allWeighingContainerModelPackets=Cases[
		Join[allWeighingContainerModelPackets, Flatten[availableSampleContainerModelPackets], Flatten[sourceModelProductPackets]],
		ObjectP[]
	];

	(* Simulate each Model[Sample] as being in a consolidated single vessel/plate based on the incubation parameters. *)
	{simulatedSampleModelPackets, simulatedSampleModelContainerPackets}=If[Length[sampleModelWithContainerAndAmount]==0,
		{{},{}},
		Transpose[
			Map[
				Module[{modelPacket, amountOptions, containerModel},
					modelPacket=fetchPacketFromFastAssoc[#[[1,1]], fastAssoc];

					amountOptions = Switch[#[[3]],
						MassP,
						{
							Mass->#[[3]],
							State->Lookup[modelPacket, State],
							Density->Lookup[modelPacket, Density]
						},
						VolumeP,
						{
							Volume->#[[3]],
							State->Lookup[modelPacket, State],
							Density->Lookup[modelPacket, Density]
						},
						CountP,
						{
							Count->#[[3]],
							With[{solidUnitWeight=Lookup[modelPacket, SolidUnitWeight]},
								If[MatchQ[solidUnitWeight, MassP],
									Mass->#[[3]] * solidUnitWeight,
									Nothing
								]
							],
							State->Lookup[modelPacket, State]
						}
					];

					(* In the rare case where we don't enforce container assume it will be preferred container *)
					(* This could cause our simulation to be inaccurate but it will avoid endless loops where we can't get the desired container *)
					containerModel = If[MatchQ[#[[2]],Null|{}],
						fetchPacketFromFastAssoc[PreferredContainer[#[[3]], IncompatibleMaterials -> Lookup[modelPacket, IncompatibleMaterials]],fastAssoc],
						(* Use the first container model for simulation *)
						FirstOrDefault[ToList[#[[2]]]]
					];

					SimulateSample[
						{#[[1,1]]},
						"Simulated Source Sample of "<>ToString[#[[1,1]], InputForm]<>CreateUUID[],
						{"A1"},
						containerModel,
						Join[
							amountOptions,
							{
								TransportCondition->Lookup[modelPacket, TransportCondition],
								TransportTemperature->Lookup[modelPacket, TransportTemperature],
								TransferTemperature->Lookup[modelPacket, TransferTemperature],
								PipettingMethod->Lookup[modelPacket, PipettingMethod]
							}
						],
						Cache->FlattenCachePackets[{modelPacket, allWeighingContainerModelPackets}]
					]
				]&,
				sampleModelWithContainerAndAmount
			]
		]
	];

	simulatedSampleModelPackets=Flatten[simulatedSampleModelPackets];
	simulatedSampleModelContainerPackets=Flatten[simulatedSampleModelContainerPackets];

	(* Get the index-matching relationship between source sample and simulatedSampleModelPackets/simulatedSampleModelContainerPackets *)
	indexMatchedSimulatedSampleModelPackets=Flatten[
		MapThread[
			Function[{modelPacket,indices},
				(#->modelPacket)&/@indices
			],
			{simulatedSampleModelPackets,sampleModelWithContainerAndAmount[[All,-1]]}
		]
	];

	indexMatchedSimulatedSampleModelContainerPackets=Flatten[
		MapThread[
			Function[{containerPacket,indices},
				(#->containerPacket)&/@indices
			],
			{simulatedSampleModelContainerPackets,sampleModelWithContainerAndAmount[[All,-1]]}
		]
	];

	indexMatchedAllSampleModelContainers=Flatten[
		MapThread[
			Function[{containerModels,indices},
				(#->containerModels)&/@indices
			],
			{sampleModelWithContainerAndAmount[[All,2]],sampleModelWithContainerAndAmount[[All,-1]]}
		]
	];

	(* Resolve CollectionContainer and CollectionTimes. We do this before the MapThread since we need these options *)
	(* to resolve the pipetting groupings. *)
	{resolvedCollectionContainers, resolvedCollectionTimes}=Transpose@MapThread[
		Function[{collectionContainer, collectionTime},
			If[MatchQ[collectionContainer, Except[Null|Automatic]] || MatchQ[collectionTime, Except[Null|Automatic]],
				{
					collectionContainer /. {Automatic -> If[sterileQ, Model[Container, Plate, "id:n0k9mGkwbvG4"], Model[Container, Plate, "id:L8kPEjkmLbvW"]]},(*96-well 2mL Deep Well Plate*)
					collectionTime /. {Automatic -> 1 Minute}
				},
				{Null, Null}
			]
		],
		{
			Lookup[myOptions, CollectionContainer],
			Lookup[myOptions, CollectionTime]
		}
	];

	(* Thread together our Object[Sample]s, Model[Sample]s, and Object[Container]s. *)

	(* First, we need to make sure that all wells of the containers we have are full with samples (we will simulate them). *)
	(* This is so that we can easily update the volume/mass etc. of the samples as we do each step of the transfer. *)
	allUniqueContainerPackets=DeleteDuplicates[Flatten[{destinationSuppliedContainerPackets, collectionContainerSuppliedPackets}]];

	(* For each container packet, create an empty sample. *)
	(* NOTE: We call SimulateSample here so that if any new important fields get added to SimulateSample, we also get them here. *)
	emptySampleForContainerPacket=First@First@SimulateSample[
		{Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)},
		"Random Name", (* We will overwrite this later. *)
		{"A1"}, (* We will overwrite this later. *)
		Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* Model[Container, Vessel, "50mL Tube"] *), (* We will overwrite this later. *)
		{
			Volume -> 0 Liter,
			Mass -> 0 Gram,
			Model -> Null,
			Composition -> {},
			Container -> Null (* We will link up the container later. *)
		}
	];

	(* Function that, given a container packet, will return a {fullContainerPacket, samplePackets}. *)
	(* We use this down below as well to make containers for our destination models *)
	createContainerAndSamplePackets[containerPacket_]:=Module[
		{modelPacket, allPositions, emptyPositions, newSamplesInEmptyPositions, newContainerPacket, existingSamplePackets},
		(* Put a fake empty sample in all of the positions that are empty in the container. *)
		modelPacket=fetchPacketFromFastAssoc[Lookup[containerPacket, Model], fastAssoc];
		allPositions=Lookup[Lookup[modelPacket, Positions,Null]/.{$Failed|{}|Null->{<|Name->"A1"|>}}, Name];
		emptyPositions=DeleteCases[allPositions, Alternatives @@ (Lookup[containerPacket, Contents,{}]/.{$Failed->{}})[[All,1]]];

		(* Create simulated samples in each of these positions. *)
		newSamplesInEmptyPositions=(
			Append[
				emptySampleForContainerPacket,
				<|
					With[{newObject=SimulateCreateID[Object[Sample]]},
						Sequence@@{
							Object->newObject,
							ID->newObject[ID]
						}
					],
					Name -> If[MatchQ[Lookup[containerPacket, Name], _String],
						"Sample in Position "<>#<>" of "<>ToString[(Lookup[containerPacket, Object]/.{Lookup[containerPacket, ID]->Lookup[containerPacket, Name]}), InputForm],
						"Sample in Position "<>#<>" of "<>ToString[Lookup[containerPacket, Object], InputForm]
					],
					Container -> Link[Lookup[containerPacket, Object], Contents, 2],
					Position -> #,
					Well -> #,
					(*Add the volume of the storagebuffer to the empty sample to avoid overflow*)
					Volume-> If[
						MatchQ[Lookup[containerPacket, StorageBuffer],True]&&MatchQ[Lookup[containerPacket, StorageBufferVolume],VolumeP],
						Lookup[containerPacket, StorageBufferVolume],
						0 Liter
					],
					Sterile -> If[MatchQ[Lookup[containerPacket, Sterile], BooleanP], Lookup[containerPacket, Sterile], Null],
					AsepticHandling -> If[MatchQ[Lookup[containerPacket, AsepticHandling], BooleanP], Lookup[containerPacket, AsepticHandling], Null],
					ContainerMaterials -> Lookup[containerPacket, ContainerMaterials]
				|>
			]
		&)/@emptyPositions;

		(* Link up these samples in the contents. *)
		newContainerPacket=Join[
			<|
				Contents->Join[
					Lookup[containerPacket, Contents],
					If[Length[emptyPositions]>0,
						Transpose[{emptyPositions, Link[Lookup[newSamplesInEmptyPositions, Object], Container]}],
						{}
					]
				],
				(* NOTE: We add these fields so cache balling works into ExperimentCover. *)
				(#->Null&)/@Cases[SamplePreparationCacheFields[Object[Container]], Except[Object|Type]],
				Simulated->True
			|>,
			containerPacket
		];

		(* Also return any sample packets that weren't simulated. *)
		existingSamplePackets=Cases[
			Flatten[{sourceSuppliedContainerSamplePackets, destinationSuppliedContainerSamplePackets}],
			KeyValuePattern[{
				Container -> ObjectP[Lookup[containerPacket, Object]],
				Position -> Alternatives @@ ((Lookup[containerPacket, Contents]/.{$Failed->{}})[[All, 1]])
			}]
		];

		(* Return our packets. *)
		{
			newContainerPacket,
			Flatten[{newSamplesInEmptyPositions,existingSamplePackets}]
		}
	];

	(* Link up the empty sample in the correct position in the container packet. *)
	{containerPacketsWithSimulatedContents, allContainerSimulatedSamples}=If[Length[allUniqueContainerPackets]==0,
		{{sourceSuppliedContainerPackets}, {sourceSuppliedContainerSamplePackets}},
		Module[{containers,samples},
			{containers,samples}=Transpose@Map[
				createContainerAndSamplePackets,
				allUniqueContainerPackets
			];
			{Join[containers,sourceSuppliedContainerPackets], Join[samples, sourceSuppliedContainerPackets]}
		]
	];

	allContainerSimulatedSamples = Flatten[allContainerSimulatedSamples];

	(* Semi-resolve our destination labels. *)
	(* NOTE: We need to resolve this before the MapThread because if the user uses the same label for a naked *)
	(* Model[Container], we need to make the same Model[Container] resource -- like with integer syntax. We'll do the *)
	(* actual resolving later in the MapThread. *)
	uniqueDestinationLabelsForContainerSimulation=Module[{pairedDestinationAndContainerLabels},
		(* First, thread together our existing DestinationLabels and DestinationContainerLabels. *)
		(* This is so that if a user paired together {"A", B"}, we reuse that pairing, even if it was left automatic. *)
		pairedDestinationAndContainerLabels=Transpose[{
			Lookup[transferOptionsAssociation, DestinationLabel],
			Lookup[transferOptionsAssociation, DestinationContainerLabel]
		}];

		MapThread[
			Function[{destination, destinationLabel, destinationContainerLabel},
				Which[
					MatchQ[destination, {_Integer, ObjectP[Model[Container]]}],
						Null,
					!MatchQ[destination, ObjectP[Model[Container]]],
						Null,
					MatchQ[destinationLabel, Except[Automatic]],
						destinationLabel,
					MatchQ[destinationContainerLabel, _String],
						FirstCase[pairedDestinationAndContainerLabels, {currentDestinationLabel:Except[Automatic], destinationContainerLabel}:>currentDestinationLabel, CreateUUID[]],
					True,
						CreateUUID[]
				]
			],
			{simulatedDestinations, Lookup[transferOptionsAssociation, DestinationLabel], Lookup[transferOptionsAssociation, DestinationContainerLabel]}
		]
	];

	(* For each of these index lists, make {fullContainerPacket, samplePackets}. *)
	containerAndSamplePacketForContainersWithIndices=MapThread[
		Function[{destination, destinationLabel, source},
			Which[
				MatchQ[destination, {_Integer, ObjectP[Model[Container]]}],
					destination->createContainerAndSamplePackets[<|
						Object->SimulateCreateID[Object@@(destination[[2]][Type])],
						Model->Link[Download[destination[[2]], Object], Objects],
						Hermetic->Lookup[
							fetchPacketFromFastAssoc[destination[[2]], fastAssoc],
							Hermetic
						],
						Ampoule->Lookup[
							fetchPacketFromFastAssoc[destination[[2]], fastAssoc],
							Ampoule
						],
						Contents->{},
						StorageBuffer->Lookup[fetchPacketFromFastAssoc[destination[[2]], fastAssoc], StorageBuffer],
						StorageBufferVolume->Lookup[fetchPacketFromFastAssoc[destination[[2]], fastAssoc], StorageBufferVolume],
						ContainerMaterials->Lookup[fetchPacketFromFastAssoc[destination[[2]], fastAssoc], ContainerMaterials],
						Notebook -> Null,
						If[TrueQ[fastAssocLookup[fastAssoc, source, Sterile]] && TrueQ[fastAssocLookup[fastAssoc, destination[[2]], Sterile]],
							Sterile -> True,
							Nothing
						],
						(* Note:AsepticHandling is not a field in Model[Container] *)
						If[TrueQ[fastAssocLookup[fastAssoc, source, AsepticHandling]] && TrueQ[fastAssocLookup[fastAssoc, destination[[2]], Sterile]],
							AsepticHandling -> True,
							Nothing
						]
					|>],
				MatchQ[destination, ObjectP[Model[Container]]] && MatchQ[destinationLabel, _String],
					destinationLabel->createContainerAndSamplePackets[<|
						Object->SimulateCreateID[Object@@(destination[Type])],
						Model->Link[Download[destination, Object], Objects],
						Hermetic->Lookup[
							fetchPacketFromFastAssoc[destination, fastAssoc],
							Hermetic
						],
						Ampoule->Lookup[
							fetchPacketFromFastAssoc[destination, fastAssoc],
							Ampoule
						],
						Contents->{},
						StorageBuffer->Lookup[fetchPacketFromFastAssoc[destination, fastAssoc], StorageBuffer],
						StorageBufferVolume->Lookup[fetchPacketFromFastAssoc[destination, fastAssoc], StorageBufferVolume],
						ContainerMaterials->Lookup[fetchPacketFromFastAssoc[destination, fastAssoc], ContainerMaterials],
						Notebook -> Null,
						If[TrueQ[fastAssocLookup[fastAssoc, source, Sterile]] && TrueQ[fastAssocLookup[fastAssoc, destination, Sterile]],
							Sterile -> True,
							Nothing
						],
						(* Note:AsepticHandling is not a field in Model[Container] *)
						If[TrueQ[fastAssocLookup[fastAssoc, source, AsepticHandling]] && TrueQ[fastAssocLookup[fastAssoc, destination, Sterile]],
							AsepticHandling -> True,
							Nothing
						]
					|>],
				True,
					Nothing
			]
		],
		{
			Join[simulatedDestinations, resolvedCollectionContainers],
			Join[uniqueDestinationLabelsForContainerSimulation, ConstantArray[Null, Length[resolvedCollectionContainers]]],
			Join[simulatedSources, ConstantArray[Null, Length[resolvedCollectionContainers]]]
		}
	];

	(* Add these new packets to our simulated cache so ObjectToString works correctly. *)
	simulatedCache=FlattenCachePackets[{cache, simulatedCache, simulatedSampleModelPackets, simulatedSampleModelContainerPackets, containerPacketsWithSimulatedContents, allContainerSimulatedSamples, containerAndSamplePacketForContainersWithIndices[[All,2]], allWeighingContainerModelPackets}];
	fastAssoc=makeFastAssocFromCache[simulatedCache];

	(* NOTE: By simulatedWorkingSourceQ, we mean that it stars off simulated from a Model[Sample]. *)
	{workingSourceSamplePackets, workingSourceContainerPackets, workingSourceContainerModelPackets, simulatedWorkingSourceQ, resolvedSourceWells}=Transpose@MapThread[
		Function[{simulatedSource, sourceWell, index},
			Switch[simulatedSource,
				(* If we were given a sample, then we can just take from the download list. *)
				ObjectP[Object[Sample]],
					Module[{samplePosition,samplePacket},

						(* Get the position of the sample in the download list. *)
						samplePosition=FirstPosition[sourcePackets, PacketP[simulatedSource]];
						samplePacket=First@Take[sourcePackets, samplePosition];

						(* Take this position from the rest of the index-matched lists since we downloaded through the sample. *)
						{
							samplePacket,
							(* Try to take from the container simulation cache if it's in there since the simulation cache will *)
							(* have the positions of extra samples that we made. *)
							If[MemberQ[containerPacketsWithSimulatedContents, PacketP[Lookup[samplePacket, Container]]],
								FirstCase[containerPacketsWithSimulatedContents, PacketP[Lookup[samplePacket, Container]]],
								(* NOTE: Make sure that we get a container packet back. Some samples may be discarded. *)
								If[MatchQ[First@Take[sourceContainerPackets, samplePosition], PacketP[]],
									First@Take[sourceContainerPackets, samplePosition],
									<|Object->SimulateCreateID[Object[Container]]|>
								]
							],
							(* NOTE: Make sure that we get a container packet back. Some samples may be discarded. *)
							If[MatchQ[First@Take[sourceContainerModelPackets, samplePosition], PacketP[]],
								First@Take[sourceContainerModelPackets, samplePosition],
								<|Object->SimulateCreateID[Model[Container]]|>
							],
							False,
							Lookup[samplePacket, Position]
						}
					],
				(* If we were given a container, then we can just take from the download list. *)
				(* As stated above, if we have a container at this point, that means that it's empty. *)
				ObjectP[Object[Container]]|{_String, ObjectP[Object[Container]]},
					Module[{containerObject, containerPosition,resolvedSourceWell},

						(* Get the container object. *)
						containerObject=If[MatchQ[simulatedSource, {_String, ObjectP[Object[Container]]}],
							simulatedSource[[2]],
							simulatedSource
						];

						(* Get the position of the container in the download list. *)
						containerPosition=FirstPosition[sourceSuppliedContainerPackets, PacketP[containerObject]];

						(* Resolve the source well option. *)
						(* NOTE: If you want to change this, please also change Primitive Framework function, after also checking the branch for {_Integer, ObjectP[Model[Container]]} below. The resolution logic is used to pre-resolve robotic transfer splitting in primitive framework function. *)
						resolvedSourceWell=Which[
							(* Did the user give us an option? *)
							MatchQ[sourceWell, Except[Automatic]],
								sourceWell,
							(* Were we given {_String, ObjectP[Object[Container]]} as input? *)
							MatchQ[simulatedSource, {_String, ObjectP[Object[Container]]}],
								simulatedSource[[1]],
							(* Do we have a sample in this container that is non-empty? *)
							MatchQ[FirstCase[allContainerSimulatedSamples, KeyValuePattern[{Container->ObjectP[containerObject], Volume -> Except[0 Liter], Mass -> Except[0 Gram]}], Null], PacketP[]],
								Lookup[FirstCase[allContainerSimulatedSamples, KeyValuePattern[{Container->ObjectP[containerObject], Volume -> Except[0 Liter], Mass -> Except[0 Gram]}], Null], Position],
							(* Do we have a destination transfer into this container later? If so, take the destination well of that. *)
							MatchQ[FirstCase[Transpose[{simulatedDestinations, suppliedDestinationWells}], {ObjectP[containerObject], position_String}:>position], _String],
								FirstCase[Transpose[{simulatedDestinations, suppliedDestinationWells}], {ObjectP[containerObject], position_String}:>position],
							(* Give up and use "A1". *)
							True,
								"A1"
						];

						(* Take this position from the rest of the index-matched lists since we downloaded through the sample. *)
						{
							(* NOTE: Have to do this because they could have given us a bogus well. *)
							If[MatchQ[FirstCase[simulatedCache, KeyValuePattern[{Container->ObjectP[containerObject], Position->resolvedSourceWell}]], PacketP[]],
								FirstCase[simulatedCache, KeyValuePattern[{Container->ObjectP[containerObject], Position->resolvedSourceWell}]],
								<||>
							],
							FirstCase[containerPacketsWithSimulatedContents, PacketP[containerObject],<||>],
							First@Take[sourceSuppliedContainerModelPackets, containerPosition],
							False,
							resolvedSourceWell
						}
					],
				(* If we have a Model[Sample], we had to simulate up above. *)
				ObjectP[Model[Sample]],
					Module[{},

						(* Get the sample model and container packet using the index of the simulatedSamples list. *)
						{
							Lookup[indexMatchedSimulatedSampleModelPackets,index],
							Lookup[indexMatchedSimulatedSampleModelContainerPackets,index],
							fetchPacketFromFastAssoc[
								(* Lookup the model of our container that we simulated in. *)
								Lookup[Lookup[indexMatchedSimulatedSampleModelContainerPackets,index], Model],
								(* We downloaded PreferredContainer[All] in these packets. *)
								fastAssoc
							],
							True,
							(* Model[Sample]s are always placed in "A1" of their container. *)
							"A1"
						}
					],
				(* If we were given a Model[Container] with an index. *)
				{_Integer, ObjectP[Model[Container]]},
					Module[{containerModel, containerPacket, samplePackets, resolvedSourceWell, simulatedSourceNoLinks},
						(* Get rid of the index if we have it. *)
						containerModel=simulatedSource[[2]];
						simulatedSourceNoLinks=simulatedSource/.{link_Link:>Download[link, Object]};

						(* Lookup our samples and container from the pre-made list. *)
						{containerPacket, samplePackets}=Lookup[containerAndSamplePacketForContainersWithIndices, Key[simulatedSource/.{link_Link:>Download[link, Object]}]];

						(* Resolve the source well option. *)
						(* NOTE: If you want to change this, please also change Primitive Framework function, after also checking the branch for ObjectP[Object[Container]]|{_String, ObjectP[Object[Container]]} above. The resolution logic is used to pre-resolve robotic transfer splitting in primitive framework function. *)
						resolvedSourceWell=Which[
							(* Did the user give us an option? *)
							MatchQ[sourceWell, Except[Automatic]],
								sourceWell,
							(* Do we have a destination transfer into this container later? If so, take the destination well of that. *)
							MatchQ[FirstCase[Transpose[{simulatedDestinations/.{link_Link:>Download[link, Object]}, suppliedDestinationWells}], {simulatedSourceNoLinks, position_String}:>position], _String],
								FirstCase[Transpose[{simulatedDestinations/.{link_Link:>Download[link, Object]}, suppliedDestinationWells}], {simulatedSourceNoLinks, position_String}:>position],
							(* Give up and use "A1". *)
							True,
								"A1"
						];

						{
							FirstCase[samplePackets, KeyValuePattern[{Position->resolvedSourceWell}], Null],
							containerPacket,
							fetchPacketFromFastAssoc[Lookup[containerPacket, Model], fastAssoc],
							True,
							resolvedSourceWell
						}
					]
			]
		],
		{simulatedSources, suppliedSourceWells, Range[Length[simulatedSources]]}
	];


	(* Get all of our destinations. *)

	(* Create a waste container ID for us to use that is the same. *)
	(* This is so that our multichannel logic down below isn't confused if it sees the destination as a separate container. *)
	(* In reality, waste will always go to the same container when it is aspirated by the same aspirator. *)
	wasteContainerID=SimulateCreateID[Object[Container,Vessel]];

	(* Do the same thing for the destinations, except that we can't have Model[Sample]s here. *)
	{workingDestinationSamplePackets, workingDestinationContainerPackets, workingDestinationContainerModelPackets, resolvedDestinationWells}=Transpose@Module[
		{containerObjectToUsedPositions,destinationWellLabels},
		(* Create a temporary map of simulated container ID to used positions. This is to help us resolve DestinationWell. *)
		(* We have to do this here because we don't actually know what wells are going to be used until time of transfer in *)
		(* the MapThread so this is cheating a bit. *)
		containerObjectToUsedPositions=Association[Map[
			If[MatchQ[Lookup[#, Contents],$Failed],
				Lookup[#, Object] -> {},
				Lookup[#, Object] -> Lookup[#, Contents][[All,1]]
			]&,
			Flatten[destinationSuppliedContainerPackets]
		]];
		(* Track the label and assigned destination well as we go through the samples *)
		destinationWellLabels=Association[];

		MapThread[
			Function[{simulatedDestination, destinationWell, uniqueNewDestinationLabel, suppliedDestinationLabel},
				Switch[simulatedDestination,
					(* If we were given a sample, then we can just take from the download list. *)
					ObjectP[{Object[Sample]}],
						Module[{samplePosition,samplePacket,resolvedDestinationWell},
							(* Get the position of the sample in the download list. *)
							samplePosition=FirstPosition[destinationPackets, PacketP[simulatedDestination]];
							samplePacket=First@Take[destinationPackets, samplePosition];

							(* Resolve the destination well. *)
							(* NOTE: If you want to change this, please also change Primitive Framework function, after also checking the other branch for resolvedDestinationWell below. The resolution logic is used to pre-resolve robotic transfer splitting in primitive framework function. *)
							resolvedDestinationWell=Which[
								MatchQ[destinationWell, Except[Automatic]],
									destinationWell,
								True,
									Lookup[samplePacket, Position]
							];

							(* Take this position from the rest of the index-matched lists since we downloaded through the sample. *)
							{
								samplePacket,
								(* Try to take from the container simulation cache if it's in there since the simulation cache will *)
								(* have the positions of extra samples that we made. *)
								If[MemberQ[containerPacketsWithSimulatedContents, PacketP[Lookup[samplePacket, Container]]],
									FirstCase[containerPacketsWithSimulatedContents, PacketP[Lookup[samplePacket, Container]]],
									First@Take[destinationContainerPackets, samplePosition]
								],
								First@Take[destinationContainerModelPackets, samplePosition],
								resolvedDestinationWell
							}
						],
					(* If we were given a container, then we can just take from the download list. *)
					(* As stated above, if we have a container at this point, that means that it's empty. *)
					ObjectP[{Object[Container],Object[Item]}]|{Alternatives@@Flatten[{AllWells[],LocationPositionP}], ObjectP[Object[Container]]},
						Module[{containerObject,containerPosition,containerModelPacket,containerPacket,resolvedDestinationWell,containerVolume},
							(* Get the container object. *)
							containerObject=If[MatchQ[simulatedDestination, {_String, ObjectP[Object[Container]]}],
								Download[simulatedDestination[[2]], Object],
								Download[simulatedDestination, Object]
							];

							(* Get the position of the container in the download list. *)
							containerPosition=FirstPosition[destinationSuppliedContainerPackets, PacketP[containerObject]];

							(* Get the container and container model packet. *)
							containerModelPacket=First@Take[destinationSuppliedContainerModelPackets, containerPosition];
							containerPacket=FirstCase[containerPacketsWithSimulatedContents, PacketP[containerObject]];

							(* Resolve the destination well. *)
							(* NOTE: If you want to change this, please also change Primitive Framework function, after also checking the other branch for resolvedDestinationWell above and below. The resolution logic is used to pre-resolve robotic transfer splitting in primitive framework function. *)
							resolvedDestinationWell=Which[
								MatchQ[destinationWell, Except[Automatic]],
									destinationWell,
								(* Were we given {_String, ObjectP[Object[Container]]} as input? *)
								MatchQ[simulatedDestination, {_String, ObjectP[Object[Container]]}],
									simulatedDestination[[1]],
								MatchQ[simulatedDestination,ObjectP[Object[Item]]],
									"A1",
								KeyExistsQ[destinationWellLabels, {suppliedDestinationLabel,containerObject}],
									Lookup[destinationWellLabels,Key[{suppliedDestinationLabel,containerObject}]],
								True,
									Module[{emptyPositions},
										(* Try to get the empty positions of this container. *)
										emptyPositions=UnsortedComplement[
											Lookup[Lookup[containerModelPacket, Positions], Name],
											Lookup[containerObjectToUsedPositions, containerObject, {}]
										];

										FirstOrDefault[emptyPositions, "A1"]
									]
							];

							(* note that if we have a StorageBufferVolume, note that we are NOT adding that because it would already be the volume at that position *)
							containerVolume=Lookup[
								FirstCase[allContainerSimulatedSamples, KeyValuePattern[{Container->LinkP[containerObject], Position->resolvedDestinationWell}], emptySampleForContainerPacket],
								Volume
							];

							(* Keep track of this used position. *)
							AppendTo[
								containerObjectToUsedPositions,
								Rule[
									Lookup[containerPacket, Object],
									Append[
										Lookup[containerObjectToUsedPositions,Lookup[containerPacket, Object],{}],
										resolvedDestinationWell
									]
								]
							];
							If[MatchQ[suppliedDestinationLabel,_String],
								AppendTo[
									destinationWellLabels,
									Rule[
										{suppliedDestinationLabel,containerObject},
										resolvedDestinationWell
									]
								]
							];

							(* Take this position from the rest of the index-matched lists since we downloaded through the sample. *)
							{
								(* NOTE: We will throw an error later if we can't find the well. *)
								(* NOTE2: We need to add the storage buffer volume to the simulated container to avoid overfilling*)
								Append[
									FirstCase[allContainerSimulatedSamples, KeyValuePattern[{Container->LinkP[containerObject], Position->resolvedDestinationWell}], emptySampleForContainerPacket],
									<|Volume->containerVolume|>
								],
								containerPacket,
								containerModelPacket,
								resolvedDestinationWell
							}
						],
					(* If we were given a Model[Container] or a Model[Container] with an index. *)
					ObjectP[Model[Container]]|{_Integer, ObjectP[Model[Container]]},
						Module[{containerModel, resolvedDestinationWell, containerPacket, containerModelPacket, samplePackets, containerObject},
							(* Get rid of the index if we have it. *)
							containerModel=If[MatchQ[simulatedDestination,{_Integer,_}],
								simulatedDestination[[2]],
								simulatedDestination
							];

							(* If we have a specific index, lookup our samples and container from the pre-made list. *)
							{containerPacket, samplePackets}=Which[
								MatchQ[simulatedDestination,{_Integer,_}],
									Lookup[containerAndSamplePacketForContainersWithIndices, Key[simulatedDestination/.{link_Link:>Download[link, Object]}]],
								MatchQ[uniqueNewDestinationLabel, _String],
									Lookup[containerAndSamplePacketForContainersWithIndices, Key[uniqueNewDestinationLabel]],
								True,
									createContainerAndSamplePackets[<|
										Object->SimulateCreateID[Object@@(containerModel[Type])],
										Model->Link[Download[containerModel, Object], Objects],
										Hermetic->Lookup[
											fetchPacketFromFastAssoc[containerModel, fastAssoc],
											Hermetic
										],
										Ampoule->Lookup[
											fetchPacketFromFastAssoc[containerModel, fastAssoc],
											Ampoule
										],
										Contents->{},
										StorageBuffer->Lookup[fetchPacketFromFastAssoc[containerModel, fastAssoc], StorageBuffer],
										StorageBufferVolume->Lookup[fetchPacketFromFastAssoc[containerModel, fastAssoc], StorageBufferVolume],
										ContainerMaterials->Lookup[fetchPacketFromFastAssoc[containerModel, fastAssoc], ContainerMaterials]
									|>]
							];
							containerObject=Lookup[containerPacket,Object];

							(* Get the container model packet. *)
							containerModelPacket=fetchPacketFromFastAssoc[Lookup[containerPacket, Model], fastAssoc];

							(* Resolve the destination well. *)
							(* NOTE: If you want to change this, please also change Primitive Framework function, after also checking the other branch for resolvedDestinationWell above and below. The resolution logic is used to pre-resolve robotic transfer splitting in primitive framework function. *)
							resolvedDestinationWell=Which[
								MatchQ[destinationWell, Except[Automatic]],
									destinationWell,
								KeyExistsQ[destinationWellLabels, {suppliedDestinationLabel,containerObject}],
									Lookup[destinationWellLabels,Key[{suppliedDestinationLabel,containerObject}]],
								(* Try to find the first position in the container that is empty. Otherwise, fall back on "A1". *)
								True,
									Module[{emptyPositions},
										(* Try to get the empty positions of this container. *)
										emptyPositions=UnsortedComplement[
											Lookup[Lookup[containerModelPacket, Positions], Name],
											Lookup[containerObjectToUsedPositions, Lookup[containerPacket, Object], {}]
										];

										FirstOrDefault[emptyPositions, "A1"]
									]
							];

							(* Keep track of this used position. *)
							AppendTo[
								containerObjectToUsedPositions,
								Rule[
									Lookup[containerPacket, Object],
									Append[
										Lookup[containerObjectToUsedPositions,containerObject,{}],
										resolvedDestinationWell
									]
								]
							];

							If[MatchQ[suppliedDestinationLabel,_String],
								AppendTo[
									destinationWellLabels,
									Rule[
										{suppliedDestinationLabel,containerObject},
										resolvedDestinationWell
									]
								]
							];

							{
								FirstCase[samplePackets, KeyValuePattern[{Position->resolvedDestinationWell}], Null],
								containerPacket,
								containerModelPacket,
								resolvedDestinationWell
							}
						],
					(* If we were given Waste, simulate a 10L carboy. *)
					Waste,
						Module[{containerModel, containerPacket, samplePackets, resolvedDestinationWell},
							(* Get rid of the index if we have it. *)
							(* "10L Polypropylene Carboy" *)
							containerModel=Model[Container, Vessel, "id:aXRlGnZmOOB9"];

							(* If we have a specific index, lookup our samples and container from the pre-made list. *)
							{containerPacket, samplePackets}=createContainerAndSamplePackets[<|
								Object->wasteContainerID,
								Model->Link[Download[containerModel, Object], Objects],
								Hermetic->Lookup[
									fetchPacketFromFastAssoc[containerModel, fastAssoc],
									Hermetic
								],
								Ampoule->Lookup[
									fetchPacketFromFastAssoc[containerModel, fastAssoc],
									Ampoule
								],
								Contents->{}
							|>];

							(* Resolve the destination well. *)
							(* NOTE: If you want to change this, please also change Primitive Framework function, after also checking the other branch for resolvedDestinationWell above. The resolution logic is used to pre-resolve robotic transfer splitting in primitive framework function. *)
							resolvedDestinationWell=Which[
								MatchQ[destinationWell, Except[Automatic]],
								destinationWell,
								True,
								"A1"
							];

							{
								FirstCase[samplePackets, KeyValuePattern[{Position->resolvedDestinationWell}], Null],
								containerPacket,
								fetchPacketFromFastAssoc[Lookup[containerPacket, Model], fastAssoc],
								resolvedDestinationWell
							}
						]
				]
			],
			{simulatedDestinations, suppliedDestinationWells, uniqueDestinationLabelsForContainerSimulation, Lookup[transferOptionsAssociation, DestinationLabel]}
		]
	];

	(* Do the same thing for any collection containers that we have. *)
	{workingCollectionContainerSamplePackets, workingCollectionContainerPackets}=Transpose@MapThread[
		Function[{simulatedCollectionContainer, destinationWell},
			Switch[simulatedCollectionContainer,
				(* If we were given a container, then we can just take from the download list. *)
				(* As stated above, if we have a container at this point, that means that it's empty. *)
				ObjectP[{Object[Container]}],
					Module[{containerObject},
						(* Get the container object. *)
						containerObject=Download[simulatedCollectionContainer, Object];

						(* Take this position from the rest of the index-matched lists since we downloaded through the sample. *)
						{
							FirstCase[allContainerSimulatedSamples, KeyValuePattern[{Container->LinkP[containerObject], Position->destinationWell}], emptySampleForContainerPacket],
							fetchPacketFromFastAssoc[simulatedCollectionContainer, fastAssoc]
						}
					],
				(* If we were given a Model[Container] or a Model[Container] with an index. *)
				ObjectP[Model[Container]]|{_Integer, ObjectP[Model[Container]]},
					Module[{containerModel, containerPacket, containerModelPacket, samplePackets},
						(* Get rid of the index if we have it. *)
						containerModel=If[MatchQ[simulatedCollectionContainer,{_Integer,_}],
							simulatedCollectionContainer[[2]],
							simulatedCollectionContainer
						];

						(* If we have a specific index, lookup our samples and container from the pre-made list. *)
						{containerPacket, samplePackets}=Which[
							MatchQ[simulatedCollectionContainer,{_Integer,_}],
								Lookup[containerAndSamplePacketForContainersWithIndices, Key[simulatedCollectionContainer/.{link_Link:>Download[link, Object]}]],
							True,
								createContainerAndSamplePackets[<|
									Object->SimulateCreateID[Object@@(containerModel[Type])],
									Model->Link[Download[containerModel, Object], Objects],
									Hermetic->Lookup[
										fetchPacketFromFastAssoc[containerModel, fastAssoc],
										Hermetic
									],
									Ampoule->Lookup[
										fetchPacketFromFastAssoc[containerModel, fastAssoc],
										Ampoule
									],
									Contents->{},
									StorageBuffer->Lookup[fetchPacketFromFastAssoc[containerModel, fastAssoc], StorageBuffer],
									StorageBufferVolume->Lookup[fetchPacketFromFastAssoc[containerModel, fastAssoc], StorageBufferVolume]
								|>]
						];

						(* Get the container model packet. *)
						containerModelPacket=fetchPacketFromFastAssoc[Lookup[containerPacket, Model], fastAssoc];

						{
							FirstCase[samplePackets, KeyValuePattern[{Position->destinationWell}], Null],
							containerPacket
						}
					],
				_,
					{Null, Null}
			]
		],
		{resolvedCollectionContainers, resolvedDestinationWells}
	];


	(* Get the fully resolved sources and destinations as simulated objects. *)
	simulatedSourceObjects = Lookup[workingSourceSamplePackets, Object, <||>];
	simulatedDestinationObjects = Lookup[workingDestinationSamplePackets, Object];

	(* -- SETUP ERROR CHECKING -- *)
	missingSampleErrors={};
	overaspirationWarnings={};
	overfilledErrors={};
	hermeticSourceErrors={};
	hermeticDestinationErrors={};
	weighingContainerErrors={};
	balanceCleaningMethodRequiredErrors={};
	instrumentCapacityErrors={};
	liquidLevelErrors={};
	incompatibleSpatulaWidthErrors={};
	pillCrusherWarnings={};
	sachetMassWarnings = {};
	spatulaCapacityWarnings = {};
	gaseousSampleErrors={};
	incompatibleQuantitativeTransferWeighingContainerErrors={};
	incompatibleQuantitativeTransferWashTipsErrors={};
	incompatibleQuantitativeTransferWashInstrumentErrors={};
	noCompatibleWeighingContainerErrors = {};
	incompatibleWeighingContainerErrors = {};
	noCompatibleFunnelErrors = {};
	incompatibleDestinationContainerErrors={};
	incompatibleIntermediateContainerErrors={};
	recoupContaminationErrors={};
	incompatibleFTVIntermediateContainerErrors={};
	incompatibleFTVIntermediateDecantErrors={};
	incompatibleFTVInstrumentErrors={};
	incompatibleFTVFunnelErrors={};
	invalidNumberOfQuantitativeTransferWashesError={};
	solidSampleVolumeErrors={};
	funnelDestinationResult={};
	funnelIntermediateResult={};
	aqueousGloveBoxErrors={};
	anhydrousGloveBoxWarnings={};
	layerSupernatantLiquidErrors={};
	magneticRackErrors={};
	noCompatibleTipsErrors={};
	noCompatibleSyringesErrors={};
	incorrectMultiProbeHeadTransfer={};
	invalidMNDispenseErrors = {};
	monotonicCorrectionCurveWarnings={};
	incompleteCorrectionCurveWarnings={};
	invalidZeroCorrectionErrors={};
	reversePipettingSamples = {};
	aspirationMixVolumeErrors = {};
	dispenseMixVolumeErrors = {};
	multichannelAspirationMixWarnings = {};
	multichannelDispenseMixWarnings = {};
	noTransferEnvironmentAvailableErrors = {};
	invalidTransferEnvironmentErrors = {};

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* -- Check for missing samples -- *)


	(* -- ROUND OUR OPTIONS -- *)

	(* NOTE: We need to do further precision checks after we've done our resolving to make sure that our instruments can *)
	(* actually achieve the precisions that were asked for. *)
	optionsAndPrecisions={
		{Tolerance, Quantity[1.*10^-7, "Grams"]}, (* NOTE: Our micro scale can go down to this precision. *)
		{QuantitativeTransferWashVolume, 1 Microliter},
		{TipRinseVolume, 1 Microliter},
		{SourceTemperature, 1 Celsius},
		{SourceEquilibrationTime, 1 Second},
		{MaxSourceEquilibrationTime, 1 Second},
		{DestinationTemperature, 1 Celsius},
		{DestinationEquilibrationTime, 1 Second},
		{MaxDestinationEquilibrationTime, 1 Second},
		{CoolingTime, 1 Second}
	};

	{roundedOptions,roundedOptionTests} = If[!messages,
		RoundOptionPrecision[Association@transferOptions,optionsAndPrecisions[[All,1]],optionsAndPrecisions[[All,2]],Output->{Result,Tests}],
		{RoundOptionPrecision[Association@transferOptions,optionsAndPrecisions[[All,1]],optionsAndPrecisions[[All,2]]],{}}
	];

	(* Resolve the AspirationAngle and DispenseAngle options. We do this before the MapThread since we need these options *)
	(* to resolve the pipetting groupings. *)
	{resolvedAspirationAngles, resolvedDispenseAngles}=Transpose@MapThread[
		Function[{aspirationAngle, dispenseAngle, sourceContainerPacket, destinationContainerPacket},
			(* If we're transferring from->to the same container and an angle is set for aspiration/dispense, make sure any Automatics *)
			(* are resolved to that same angle. *)
			Which[
				And[
					MatchQ[Lookup[sourceContainerPacket, Object], Lookup[destinationContainerPacket, Object]],
					MatchQ[aspirationAngle, GreaterP[0 AngularDegree]]
				],
					{aspirationAngle, dispenseAngle/.{Automatic->aspirationAngle}},
				And[
					MatchQ[Lookup[sourceContainerPacket, Object], Lookup[destinationContainerPacket, Object]],
					MatchQ[dispenseAngle, GreaterP[0 AngularDegree]]
				],
					{aspirationAngle/.{Automatic->dispenseAngle}, dispenseAngle},
				True,
					{aspirationAngle, dispenseAngle}/.{Automatic->Null}
			]
		],
		{
			Lookup[myOptions, AspirationAngle],
			Lookup[myOptions, DispenseAngle],
			workingSourceContainerPackets,
			workingDestinationContainerPackets
		}
	];

	(* Convert our options into a MapThread friendly version. *)
	(* Also replace with our pre-resolved multichannel options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentTransfer,
		Append[
			roundedOptions,
			<|
				AspirationAngle->resolvedAspirationAngles,
				DispenseAngle->resolvedDispenseAngles,
				CollectionContainer->resolvedCollectionContainers,
				CollectionTime->resolvedCollectionTimes
			|>
		]
	];

	(* Helper function to resolve culture handling since we resolve it in multiple branches. *)
	resolveCultureHandling[sourcePacket_Association, destinationPacket_Association, options:(_List|_Association)]:=Which[
		(* Has the user told us explicitly that we should go to the TC or Microbial hood? *)

		(* Biosafety Cabinet Handling Station for Tissue Culture *)
		Or[
			MatchQ[Lookup[options, TransferEnvironment], ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"]]],
			And[
				MatchQ[Lookup[options, TransferEnvironment], ObjectP[Object[Instrument, HandlingStation, BiosafetyCabinet]]],
				MatchQ[
					fastAssocLookup[fastAssoc, Lookup[options, TransferEnvironment], Model],
					ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"]]
				]
			]
		],
			NonMicrobial,

		(* Biosafety Cabinet Handling Station for Microbiology *)
		Or[
			MatchQ[Lookup[options, TransferEnvironment], ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"]]],
			And[
				MatchQ[Lookup[options, TransferEnvironment], ObjectP[Object[Instrument, HandlingStation, BiosafetyCabinet]]],
				MatchQ[
					fastAssocLookup[fastAssoc, Lookup[options, TransferEnvironment], Model],
					ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"]]
				]
			]
		],
			Microbial,

		(* Biosafety Cabinet Handling Station with Analytical Balance *)
		Or[
			MatchQ[Lookup[options, TransferEnvironment], ObjectP[Model[Instrument,HandlingStation,BiosafetyCabinet,"id:XnlV5jNYpXYP"]]],
			And[
				MatchQ[Lookup[options, TransferEnvironment], ObjectP[Object[Instrument, HandlingStation, BiosafetyCabinet]]],
				MatchQ[
					fastAssocLookup[fastAssoc, Lookup[options, TransferEnvironment], Model],
					ObjectP[Model[Instrument,HandlingStation,BiosafetyCabinet,"id:XnlV5jNYpXYP"]]
				]
			]
		],
			(* CultureHandling can be Null in this case because while we are using a BSC, we are not necessarily using cells *)
			Null,

		(* are we dealing with any samples that have cells?  If we don't then it is fine to say Null here and just use the normal Transfer BSCs (which require Null CultureHandling) *)
		MemberQ[Flatten[{Lookup[sourcePacket, CellType], Lookup[destinationPacket, CellType]}], Except[Null]],
			(* Only use the tissue culture hood if the samples are labeled as CellType->NonMicrobialCellTypeP or if given a TC instrument. *)
			If[Or[
				MatchQ[Lookup[options, Instrument], ObjectP[Model[]]] && MatchQ[fastAssocLookup[fastAssoc, Lookup[options, Instrument], CultureHandling], NonMicrobial],
				MatchQ[Lookup[options, Instrument], ObjectP[Object[]]] && MatchQ[fastAssocLookup[fastAssoc, Lookup[options, Instrument], {Model, CultureHandling}], NonMicrobial],
				MemberQ[Flatten[{Lookup[sourcePacket, CellType], Lookup[destinationPacket, CellType]}], NonMicrobialCellTypeP]
			],
				NonMicrobial,
				Microbial
			],

		True,
			Null
	];

	wellToTuple[well_String]:={First@ToCharacterCode[StringTake[well, 1]], ToExpression[StringTake[well, 2 ;;]]};
	tupleToWell[tuple : {_Integer, _Integer}] := FromCharacterCode[tuple[[1]]] <> ToString[tuple[[2]]];
	(* we stash this since we anticipate this calculation to be done multiple times *)
	map96Integers = Map[wellToTuple,AllWells[],{2}];

	(* a helper function to determine is the list of wells we gave a rectangle -> we can use do it to determine is we can *)
	rectangleQ[wells:{{_Integer, _Integer}..}, map:{{{_Integer,_Integer}..}..}]:=Module[{sortedWells, rows, columnLengths, firstWellPosition, lastWellPosition, theoreticalPositions},
		sortedWells = Sort@wells;
		rows = SplitBy[sortedWells, First];
		If[!Equal@@Length/@rows, Return[False]];
		If[Mod[Length@wells, rows[[1]]]!=0, Return[False]];
		columnLengths = Length/@SplitBy[SortBy[wells,Last], Last];
		If[!Equal@@columnLengths, Return[False]];
		(*check that the transfers are consecutive - we have to do A1, A2.. and can't do A1, A3..*)
		firstWellPosition = Position[map, sortedWells[[1]]];
		lastWellPosition = Position[map, sortedWells[[-1]]];
		theoreticalPositions = (lastWellPosition[[1,2]]-firstWellPosition[[1,2]]+1)*(lastWellPosition[[1,1]]-firstWellPosition[[1,1]]+1);
		Length[wells]==theoreticalPositions
	];

	(* Right before we go into our MapThread, figure out if it's feasible for our samples to be transferred *)
	(* via MultichannelTransfer. This is allowed if: *)
	(* (1) the source sample and destination samples/locations are in a plate and the spacing of the wells in the plate *)
	(* are compatible with the spacing between the channels in the pipette (HorizontalPitch/VerticalPitch/ChannelOffset). *)
	(* (2) the source sample and destination sample to be transferred before/after this sample are in the same row or *)
	(* well of the plate. *)
	(* (3) the amount of the samples to be transferred is the same. *)

	(* To do this, we basically map over our transfers one by one and if they're compatible with the last transfer, *)
	(* we add them to a "run" of consecutive transfers that we can do at the same time. Otherwise, we break off *)
	(* and form another run. *)

	(* NOTE: MultiChannelTransfers and MultichannelTransferNames are now resolved after this point. We continue resolving *)
	(* the Instrument option in the big MapThread. *)
	{
		preresolvedInstruments,
		resolvedMultichannelTransfers,
		resolvedMultichannelTransferNames,
		resolvedDeviceChannels
	}=If[MatchQ[resolvedPreparation, Robotic],
		(* We ALWAYS set MultichannelTransfer->True if
			1) we have more than one transfer that we're performing
			2) the source of our transfer isn't a destination in our multichannel group.
			3) the specified tips are compatible with the pipette
		*)
		Module[
			{
				transferInformation, initialResolvedMultichannelTransfers, initialResolvedMultichannelTransferNames, initialResolvedDeviceChannels,
				preResolvedMultichannelTransfers, preResolvedMultichannelTransferNames, preResolvedDeviceChannels, pipettingParameters
			},

			(* First detect any 96 runs of transfers that are being done from source to destination with the same volume. *)
			transferInformation=Transpose[{
				(*1*)Lookup[workingSourceContainerModelPackets, Object],
				(*2*)Lookup[workingDestinationContainerModelPackets, Object],
				(*3*)Lookup[workingSourceContainerModelPackets, MultiProbeHeadIncompatible],
				(*4*)Lookup[workingDestinationContainerModelPackets, MultiProbeHeadIncompatible],
				(*5*)Lookup[workingSourceContainerPackets, Object],
				(*6*)Lookup[workingDestinationContainerPackets, Object],
				(*7*)Lookup[workingSourceSamplePackets, Position],
				(*8*)Lookup[workingDestinationSamplePackets, Position],
				(*9*)myAmounts,
				(*10*)Lookup[myOptions, MultichannelTransfer],
				(*11*)Lookup[myOptions, MultichannelTransferName],
				(*12*)Lookup[myOptions, DeviceChannel],

				(* NOTE: We cannot use the 96 head if we have an aspiration/dispense angle and if we have a position offset, they all have to be the same. *)
				(*13*)resolvedAspirationAngles,
				(*14*)Lookup[myOptions, AspirationPositionOffset],
				(*15*)resolvedDispenseAngles,
				(*16*)Lookup[myOptions, DispensePositionOffset]
			}];

			{initialResolvedMultichannelTransfers, initialResolvedMultichannelTransferNames, initialResolvedDeviceChannels}=Module[
				(* these are not real variables, but rather a way for us to protect these from being assigned outside this Module *)
				{sourceContainerModel, destinationContainerModel, sourceContainerMultiProbeHeadIncompatibleQ, destinationContainerMultiProbeHeadIncompatibleQ,
					sourceContainer, destinationContainer, amount, aspirationPositionOffset, dispensePositionOffset},

				(* NOTE: The following are all patterns in which we can use the 96 MultiProbeHead. We use SequenceReplace to detect these *)
				(* patterns and automatically preresolve the DeviceChannel option to MultiProbeHead. The advantage to using SequenceReplace *)
				(* over something like Fold/Map is that MM's pattern matcher is much faster at finding sequences that we could manually and is *)
				(* much less complex in terms of writing new code. *)
				Transpose@With[{
					(* Detect transfers of all 96 wells from plate 1 to plate 2 of the same volume. *)
					pattern96=(
						{
							sourceContainerModel_, destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #, #, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}
					&)/@Flatten[AllWells[]],

					patternTransposed96=(
						{
							sourceContainerModel_, destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #, #, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}
					&)/@Flatten[Transpose[AllWells[]]],

					(* The 300mL Reservoir is special in that it has 1 physical location but 96 virtual positions in its Hamilton labware. *)
					(* We make sure in the robotic exporter to set the correct positions for the Transfer JSON. *)
					patternSourceReservoir96=(
						{
							Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"], destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, "A1", #, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}
					&)/@Flatten[AllWells[]],
					patternSourceReservoirTransposed96=(
						{
							Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"], destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, "A1", #, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}
					&)/@Flatten[Transpose[AllWells[]]],

					patternDestinationReservoir96=(
						{
							sourceContainerModel_, Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"], sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #, "A1", amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}
					&)/@Flatten[AllWells[]],
					patternDestinationReservoirTransposed96=(
						{
							sourceContainerModel_, Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"], sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #, "A1", amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}
					&)/@Flatten[Transpose[AllWells[]]],

					(* We can also use the 96 head if we're transferring on a 384 plate in a spaced out way. *)
					patternTransposed96To384=MapThread[
						{
							sourceContainerModel_, destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #1, #2, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}&,
						{
							Flatten[Transpose[AllWells[]]],
							Flatten[AllWells[NumberOfWells -> 384][[;; ;; 2]]][[;; ;; 2]]
						}
					],
					pattern96To384=MapThread[
						{
							sourceContainerModel_, destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #1, #2, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}&,
						{
							Flatten[AllWells[]],
							Flatten[AllWells[NumberOfWells -> 384][[;; ;; 2]]][[;; ;; 2]]
						}
					],
					pattern384To96=MapThread[
						{
							sourceContainerModel_, destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #1, #2, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}&,
						{
							Flatten[AllWells[NumberOfWells -> 384][[;; ;; 2]]][[;; ;; 2]],
							Flatten[Transpose[AllWells[]]]
						}
					],
					pattern384ToTransposed96=MapThread[
						{
							sourceContainerModel_, destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #1, #2, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}&,
						{
							Flatten[AllWells[NumberOfWells -> 384][[;; ;; 2]]][[;; ;; 2]],
							Flatten[AllWells[]]
						}
					],
					pattern384To384=MapThread[
						{
							sourceContainerModel_, destinationContainerModel_, sourceContainerMultiProbeHeadIncompatibleQ:(False|Null), destinationContainerMultiProbeHeadIncompatibleQ:(False|Null),
							sourceContainer_, destinationContainer_, #1, #2, amount_, (True|Automatic), Automatic, (MultiProbeHead|Automatic),
							Automatic|Null|0 AngularDegree|0. AngularDegree, aspirationPositionOffset_, Automatic|Null|0 AngularDegree|0. AngularDegree, dispensePositionOffset_
						}&,
						{
							Flatten[AllWells[NumberOfWells -> 384][[;; ;; 2]]][[;; ;; 2]],
							Flatten[AllWells[NumberOfWells -> 384][[;; ;; 2]]][[;; ;; 2]]
						}
					]
				},
					SequenceReplace[
						transferInformation,
						{
							pattern96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							patternTransposed96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							patternSourceReservoir96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							patternSourceReservoirTransposed96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							patternDestinationReservoir96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							patternDestinationReservoirTransposed96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							patternTransposed96To384:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							pattern96To384:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							pattern384To96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							pattern384ToTransposed96:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							pattern384To384:>Sequence@@ConstantArray[{True, CreateUUID[], MultiProbeHead}, 96],
							{list_List}:>{list[[-7]], list[[-6]], list[[-5]]}
						}
					]
				]
			];

			(* list of the parameters that dictate how we pipette on deck excluding PipettingMethod *)
			pipettingParameters = {
				TipType,
				TipMaterial,
				AspirationRate,
				DispenseRate,
				OverAspirationVolume,
				OverDispenseVolume,
				AspirationWithdrawalRate,
				DispenseWithdrawalRate,
				AspirationEquilibrationTime,
				DispenseEquilibrationTime,
				AspirationPosition,
				DispensePosition,
				AspirationPositionOffset,
				DispensePositionOffset,
				CorrectionCurve,
				DynamicAspiration,
				AspirationMix,
				AspirationMixRate,
				AspirationMixVolume,
				DispenseMix,
				DispenseMixRate,
				DispenseMixVolume,
				AspirationAngle,
				DispenseAngle
			};

			{preResolvedMultichannelTransfers,preResolvedMultichannelTransferNames,preResolvedDeviceChannels} = Module[
				{
					joinedData, initialSplitData, multiProbeHeadTransferLimit, overLimitTransfers, splitByRecurringElement, overLimitTransfersWithOffsets,
					preVerifiedMultiProbeGroup, initialFilteredTransfers, qualifiedTransferGroups, overLimitTransfersWith384Split,
					qualifiedLongTransferGroups
				},

				(* we attach options so we can extract pipetting parameters since they have to be identical and UUID so we can later on place new resolved MultiProbeHead results back *)
				joinedData = MapThread[Join[#1, #2,{#3, #4, #5, #6, #7, #8}]&,{
					transferInformation,
					Transpose@{
						(*17*)initialResolvedMultichannelTransfers,
						(*18*)initialResolvedMultichannelTransferNames,
						(*19*)initialResolvedDeviceChannels},
					(*20*)mapThreadFriendlyOptions,
					(*21*)Lookup[workingSourceContainerModelPackets, NumberOfWells],
					(*22*)Lookup[workingDestinationContainerModelPackets, NumberOfWells],
					(*23*)Lookup[workingSourceContainerModelPackets, Footprint],
					(*24*)Lookup[workingDestinationContainerModelPackets, Footprint],
					(*25*)Table[CreateUUID[],Length[mapThreadFriendlyOptions]]
				}];
				(* split by source container, destination container, amount and all pipetting parameters *)
				initialSplitData = SplitBy[joinedData, {
					#[[{5,6,9}]],
					Lookup[#[[20]], pipettingParameters, Null],
					Download[Lookup[#[[20]], PipettingMethod, Null]/.Automatic->Null, Object],
					Lookup[#[[20]], DeviceChannel, Null]
				}&];

				(* If the user specified that we should use MultiProbeHead for transfer, we allow a smaller length of transfers to be processed with MPH *)
				(* We cannot assume that the Transfer UO with MPH option is one group. It is possible that user has specified the MPH transfers in good shapes and we did UO optimization to combine multiple MPH into one UO before we call Transfer resolver *)
				multiProbeHeadTransferLimit=If[MemberQ[initialResolvedDeviceChannels, MultiProbeHead],
					Floor[$MultiProbeLowerLimit/4],
					$MultiProbeLowerLimit
				];

				(* do initial filtration - we want to throw away everything that is less than multiProbeHeadTransferLimit transfers in length, not a plate or is incompatible*)
				initialFilteredTransfers = Select[initialSplitData, And[
					Length[#]>=multiProbeHeadTransferLimit,
					(* source/Destination are not MultiProbeHeadIncompatible *)
					!TrueQ[#[[1,3]]],
					!TrueQ[#[[1,4]]],
					(* source/destination have Footprint of a Plate - can't do MultiProbeHead transfers from/to tubes *)
					MatchQ[#[[1,{23,24}]],{Plate, Plate}],
					(*We need to do resolution only for the cases of DeviceChannel not resolved yet and skip anything that we already have resolved *)
					MatchQ[#[[All, 19]], {(Automatic|MultiProbeHead)..}]
				]&];

				(* helpers to split an list into a sub-lists if they have an element that is identical to an already existing element in the list *)
				(* a new group is also started if a new source has been "detected" as a destination in the previous group, since we are doing serial transfers and cannot do the later transfer before/together with the previous transfer *)
				splitByRecurringElement[myList_List]:=Fold[
					Function[{runningValues, newValue},
						If[
							Which[
								(* if both source and destination are reservoirs we don't care about wells *)
								MatchQ[newValue[[{1,2}]],
									{
										Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],
										Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"]
									}],
								False,

								(* if we are transferring from a reservoir, we pay attention only to the well of the destination *)
								MatchQ[newValue[[1]],Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"]],
								MemberQ[Last[runningValues][[;;,8]],newValue[[8]]],

								(* if we are transferring to a reservoir, we pay attention only to the well of the source *)
								MatchQ[newValue[[2]],Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"]],
								MemberQ[Last[runningValues][[;;,7]],newValue[[7]]],

								True,
								Or[
									(* regular case 1 - either source or destination well were used before *)
									MemberQ[Last[runningValues][[;;,7]], newValue[[7]]],
									MemberQ[Last[runningValues][[;;,8]], newValue[[8]]],
									(* regular case 2 - the new source has been used as destination before *)
									MemberQ[Last[runningValues][[;;,{6,8}]], newValue[[{5,7}]]]
								]
							],
							Append[runningValues, {newValue}],

							Append[Most[runningValues], Append[Last[runningValues], newValue]]
						]
					],
					{{}},
					myList
				];

				(* grab only runs over multiProbeHeadTransferLimit in length that do not contain repetitive elements *)
				overLimitTransfers = Select[Flatten[splitByRecurringElement/@initialFilteredTransfers,1], Length[#]>=multiProbeHeadTransferLimit&];

				(* if we are using 384-well plates we can be in different "sub-plates" that are accessible for MultiProbeHead *)
				overLimitTransfersWith384Split =Flatten[Function[{transferGroup},
					Switch[transferGroup[[1,{21,22}]],
						{384,384},SplitBy[transferGroup,Function[{transferInfo},{map384[transferInfo[[7]]],map384[transferInfo[[8]]]}]],
						{384,_},SplitBy[transferGroup,Function[{transferInfo},map384[transferInfo[[7]]]]],
						{_,384},SplitBy[transferGroup,Function[{transferInfo},map384[transferInfo[[8]]]]],
						Except[{384,384}],{transferGroup}
					]]/@overLimitTransfers,1];

				(* split even further - we have to make sure that we either are working with the same offsets between
				source/destination or we are working with the robotic container on either end where offsets don't matter
				since we will have "A1" everywhere
				We also have to be mapping this over each group separately because for 96->384 transfer we can get
				the same offset but we will be on a different "sub plate" out of 4 96-well sub-plates for 384 plate*)
				overLimitTransfersWithOffsets = Map[Function[{transferGroup},
					Module[{
						sourceContainerModel, destinationContainerModel, sourceFistPosition, destinationFistPosition,
						sourceNoWell, destinationNoWells, sourceWellMap, destinationWellMap
					},
						sourceContainerModel = transferGroup[[1,1]];
						destinationContainerModel = transferGroup[[1,2]];
						sourceNoWell = transferGroup[[1,21]];
						destinationNoWells = transferGroup[[1,22]];
						sourceFistPosition = transferGroup[[1,7]];
						destinationFistPosition = transferGroup[[1,8]];
						sourceWellMap = Switch[{sourceContainerModel, sourceNoWell},
							{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"], _}, {{"A1"}},
							{_, 96}, AllWells[],
							{_, 384}, map384[sourceFistPosition]
						];
						destinationWellMap = Switch[{destinationNoWells, destinationNoWells},
							{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"], _}, {{"A1"}},
							{_, 96}, AllWells[],
							{_, 384}, map384[destinationFistPosition]
						];

						(* now that we established our group-specific parameters we can go through each transfer inside the group to add an offset *)
						Map[
							Append[#,
								If[
									(* source/destination is a reservoir -> don't care about offsets as everything is allowed *)
									MatchQ[
										{sourceContainerModel, destinationContainerModel},
										Alternatives[
											{Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"],Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"]},
											{_ ,Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"]},
											{Model[Container,Plate,"id:Vrbp1jG800Vb"]|Model[Container, Plate, "id:54n6evLWKqbG"],_}
										]
									],
									{0,0},
									(* in all other cases we have out well maps already established for the group so we can just use them for the offset calculation *)
									Position[destinationWellMap, #[[8]]]-Position[sourceWellMap, #[[7]]]
								]
							]&,
							transferGroup]
					]],
					overLimitTransfersWith384Split];

				(* another round of splitting - based on the offset and remove offset since we will not need it in the future *)
				preVerifiedMultiProbeGroup = Flatten[SplitBy[#, Last]&/@overLimitTransfersWithOffsets,1][[All,All,;;-2]];

				(* at this point we know that we have groups of transfers with the same pipetting parameters, volumes,
				sources, destinations and offsets with no repeated positions. The only thing we have to check is that
				we don't have any empty positions inside our transfer groups so we arrive to clean MxN compatible groups *)

				(* find the longest square run and extract it out from the group and put into a separate transfer group *)
				qualifiedTransferGroups =Flatten[Map[Function[{transferGroup},Module[
					{
						sourceContainerModel,destinationContainerModel,sourceNoWell,destinationNoWells,sourceWells,
						destinationWells,plateMap,transferWells,partitionedRuns,longestRun,
						startTransferPosition
					},
					sourceContainerModel=transferGroup[[1,1]];
					destinationContainerModel=transferGroup[[1,2]];
					sourceNoWell=transferGroup[[1,21]];
					destinationNoWells=transferGroup[[1,22]];
					(* we convert wells to {CharacterCode, Index} pairs because it is faster to work with integers than strings and it's better for sorting *)
					sourceWells=wellToTuple/@transferGroup[[;;,7]];
					destinationWells=wellToTuple/@transferGroup[[;;,8]];

					{plateMap,transferWells}=Switch[{sourceContainerModel,sourceNoWell,destinationContainerModel,destinationNoWells},
						{_,96,_,_},{map96Integers,sourceWells},
						{_,_,_,96},{map96Integers,destinationWells},
						{_,384,_,_},{Map[wellToTuple,map384[tupleToWell[sourceWells[[1]]]],{2}],sourceWells},
						{_,_,_,384},{Map[wellToTuple,map384[tupleToWell[destinationWells[[1]]]],{2}],destinationWells},
						(*
							for the weird case of transfers from a reservoir into a reservoir we only need to check
							that the # of transfers that we can split into a rectangle to allow it to exist, otherwise
							we need to split it into the smallest number of transfers
						*)
						{
							Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],
							_,
							Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],
							_
						},
						With[{
							(* Can we put this number of transfers into a NxM rectangle (doesn't matter the dimensions since we're going *)
							(* from reservoir to reservoir)? Make sure that we're not going beyond 8 rows since the reservoir is 8x12 virtual *)
							(* wells. *)
							initialColumns=SelectFirst[
								Reverse@Cases[Divisors[Length[transferGroup]],LessEqualP[12]],
								Mod[Length[transferGroup],#]==0 && Length[transferGroup]/# <= 8&,
								0
							]
						},
							Which[
								(* we can form a rectangle for this transfer *)
								initialColumns!=0,Return[{transferGroup}, Module],
								(* we have less than 12 transfers - return as is since this is fine *)
								Length[transferGroup]<=12,Return[{transferGroup}, Module],
								(* if we have more than 96 transfers, then do them in groups of 96 -- leave the last one to be done by itself *)
								Length[transferGroup]>96,Return[Partition[transferGroup,UpTo[96]], Module],
								(* we have >12 transfers but not quite 96 transfers, split into the subgroups *)
								Length[transferGroup]>12,
									With[
										(* This gives us all of the ways we can NxM up to 8 rows and 12 columns. *)
										{possibleAreas=Table[row * column,{row,1,8},{column,1,12}]},

										(* Get the largest NxM rectangle that's possible, then drop the rest -- we'll do those as 8 channel spans. *)
										Return[
											TakeDrop[
												transferGroup,
												Max[Cases[possibleAreas,LessEqualP[Length[transferGroup]],2]]
											],
											Module
										]
									]
							]
						]
					];

					(* split into all possible runs of >2 elements and reverse so the long runs will go first *)
					partitionedRuns=Reverse@Flatten[Table[Partition[transferWells,length,1],{length,2,Length[transferWells]}],1];
					(* When length of transferWells is only 1, we will not be able to find any rectangle. Give a default here and Length[longestRun]<multiProbeHeadTransferLimit will be True below to reject multichannel transfer *)
					longestRun = SelectFirst[partitionedRuns, rectangleQ[#,plateMap]&, {transferWells[[1]]}];

					startTransferPosition=Position[transferWells,First@longestRun][[1,1]];
					(* split the transfer group into sub-groups to extract the longest run into it's own subgroup *)
					If[
						Length[longestRun]<multiProbeHeadTransferLimit,
						Nothing,
						DeleteCases[Unflatten[transferGroup,
							{
								ConstantArray[0,startTransferPosition - 1],
								ConstantArray[1,Length[longestRun]],
								ConstantArray[0,Length[transferWells] - Length[longestRun] - startTransferPosition + 1]
							}],{}]
					]
				]],
					preVerifiedMultiProbeGroup],1];

				qualifiedLongTransferGroups = Select[
					qualifiedTransferGroups,
					(And[
						Length[#]>=multiProbeHeadTransferLimit,
						(* NOTE: We need to double check that the number of transfers can be performed by NxM since in the case of *)
						(* the reservoir sometimes we TakeDrop/Partition and thus we can't do the last group as a clean NxM. *)
						MemberQ[Flatten[Table[row * column,{row,1,8},{column,1,12}]], Length[#]]
					]&)
				];

				(* make the item in the groups that survived to have new UUID for Transfer name and update their DeviceChannel (if it is not already MultiProbeHead *)
				If[MatchQ[qualifiedLongTransferGroups,{}],
					{initialResolvedMultichannelTransfers, initialResolvedMultichannelTransferNames, initialResolvedDeviceChannels},

					Module[{transferChannelInfoTuples, uuidToPositionMap, uuidToParametersTuples, positionToParameters},
						transferChannelInfoTuples = Transpose@{initialResolvedMultichannelTransfers, initialResolvedMultichannelTransferNames, initialResolvedDeviceChannels};
						(* uuid -> position -> new parameters *)
						uuidToPositionMap = Rule@@@Transpose@{
							Flatten@qualifiedLongTransferGroups[[All,All,-1]],
							Flatten[
								Position[joinedData[[;;,-1]], #]&/@ Flatten@qualifiedLongTransferGroups[[All,All,-1]]
							]};
						uuidToParametersTuples = Flatten[Transpose[{#,ConstantArray[{True,CreateUUID[],MultiProbeHead},Length[#]]}]&/@qualifiedLongTransferGroups[[All,All,-1]],1];
						positionToParameters = uuidToParametersTuples/.uuidToPositionMap;
						Transpose@ReplacePart[transferChannelInfoTuples,Rule@@@positionToParameters]
					]
				]
			];

			Which[
				(* User is telling us to use the 96 head. *)
				MatchQ[preResolvedDeviceChannels, {MultiProbeHead..}],
					(* We have already handled the grouping earlier to resolve proper MultichannelTransferName. If they were not resolved earlier, that means the groups are too small (or not in the correct mxn shape) *)
					{
						ConstantArray[Null, Length[myAmounts]],
						preResolvedMultichannelTransfers/.{Automatic->True},
						preResolvedMultichannelTransferNames/.{Automatic->CreateUUID[]},
						preResolvedDeviceChannels
					},

				(* If we only have one source/destination, we can't do this multi-channel. *)
				Length[myAmounts]==1,
					{{Null}, {False}, {Null}, {SingleProbe1}},

				(* The user has set some of these options (or we're using the tilt angle or Magnetization or CollectionContainer options) *)
				(* so we have to do a fold. *)
				Or[
					MemberQ[preResolvedMultichannelTransfers, Except[ListableP[Automatic]]],
					MemberQ[preResolvedMultichannelTransferNames, Except[ListableP[Automatic]]],
					MemberQ[preResolvedDeviceChannels, Except[ListableP[Automatic]]],
					MemberQ[resolvedAspirationAngles, Except[ListableP[Automatic|Null]]],
					MemberQ[resolvedDispenseAngles, Except[ListableP[Automatic|Null]]],
					MemberQ[resolvedCollectionContainers,ObjectP[]|{_Integer, ObjectP[]}],
					MemberQ[Lookup[myOptions,Magnetization], True]
				],

				(* NOTE: Do Most to get rid of the index at the last index of each tuple. *)
				Prepend[
					Most@Transpose@Fold[
						(* NOTE: Our tuples are in the format {MultichannelTransfer, MultichannelTransferName, DeviceChannel, TransferIndex}. *)
						Function[{tupleList, newTuple},
							Module[{lastTuple,lastTupleGroup,resolvedNewTuple},
								(* Pull out the last tuple of information. *)
								lastTuple=Last[tupleList];

								(* Get the information about the last MultichannelTransferName group. *)
								lastTupleGroup=Cases[tupleList, {_, lastTuple[[2]], _, _}];

								(* Resolve our current tuple that we're on. *)
								resolvedNewTuple=Which[
									(* The user specifically said to turn off multi-transfer. *)
									MatchQ[newTuple[[1]], False],
										{newTuple[[1]], newTuple[[2]]/.{Automatic->Null}, newTuple[[3]]/.{Automatic->Null}, newTuple[[4]]},

									(* User has already specified all of the multichannel options. *)
									!MemberQ[newTuple, Automatic],
										newTuple,

									(* If the user has specified a non-zero AspirationAngle/DispenseAngle for a container and that container *)
									(* has previously showed up in our multi channel transfer group with a different angle or with a magnetization. *)
									(* We also cannot have more than 4 unique containers to tilt within a multichannel transfer group since *)
									(* there are only 4 tilting positions on the robot deck. *)
									And[
										Or[
											MatchQ[resolvedAspirationAngles[[newTuple[[4]]]],Except[Null|Automatic|0 AngularDegree|0. AngularDegree]],
											MatchQ[resolvedDispenseAngles[[newTuple[[4]]]],Except[Null|Automatic|0 AngularDegree|0. AngularDegree]]
										],
										Module[{tiltedContainersToConsider, magnetizationPositions, collectionContainerPositions, containersWithCollectionContainersInGroup, magnetizedContainersInGroup},

											(* Find out if our source container has shown up in this multichannel transfer group before *)
											(* with a different angle or with a magnetization. *)
											tiltedContainersToConsider={
												If[MatchQ[resolvedAspirationAngles[[newTuple[[4]]]],Except[Null|Automatic|0 AngularDegree|0. AngularDegree]],
													Download[Lookup[workingSourceSamplePackets[[newTuple[[4]]]], Container], Object],
													Nothing
												],
												If[MatchQ[resolvedDispenseAngles[[newTuple[[4]]]],Except[Null|Automatic|0 AngularDegree|0. AngularDegree]],
													Download[Lookup[workingDestinationSamplePackets[[newTuple[[4]]]], Container], Object],
													Nothing
												]
											};

											collectionContainerPositions=Position[
												Lookup[myOptions,CollectionContainer][[lastTupleGroup[[All,4]]]],
												ObjectP[]|{_Integer, ObjectP[]}
											];

											containersWithCollectionContainersInGroup=If[Length[magnetizationPositions]>0,
												Download[
													Lookup[
														Extract[
															workingSourceSamplePackets,
															collectionContainerPositions
														],
														Container
													],
													Object
												],
												{}
											];

											magnetizationPositions=Position[
												Lookup[myOptions,Magnetization][[lastTupleGroup[[All,4]]]],
												True
											];

											magnetizedContainersInGroup=If[Length[magnetizationPositions]>0,
												Download[
													Lookup[
														Extract[
															workingSourceSamplePackets,
															magnetizationPositions
														],
														Container
													],
													Object
												],
												{}
											];

											If[Or[
														(* Containers cannot be both tilted, magnetized, and/or stacked on a collection container *)
														(* at the same time. *)
														Length[Intersection[tiltedContainersToConsider, magnetizedContainersInGroup]]>0,
														Length[Intersection[tiltedContainersToConsider, containersWithCollectionContainersInGroup]]>0,
														Length[Intersection[magnetizedContainersInGroup, containersWithCollectionContainersInGroup]]>0
												],
												True,
												Module[{tiltedContainersInGroupToAngles},
													tiltedContainersInGroupToAngles=DeleteDuplicates@Join[
														Rule@@@Transpose[{
															(* Source containers with a tilt. *)
															Lookup[workingSourceContainerPackets, Object],
															(* Source container tilt angles. *)
															resolvedAspirationAngles /. {Automatic|Null -> 0 AngularDegree}
														}][[Append[lastTupleGroup[[All,4]], newTuple[[4]]]]],
														Rule@@@Transpose[{
															(* Destination containers with a tilt. *)
															Lookup[workingDestinationContainerPackets, Object],
															(* Destination container tilt angles. *)
															resolvedDispenseAngles /. {Automatic|Null -> 0 AngularDegree}
														}][[Append[lastTupleGroup[[All,4]], newTuple[[4]]]]]
													];

													(* Do we have more than 4 containers to tilt in our group? If so, initialize a new multichannel *)
													(* transfer group since we only have 4 tilting positions on the deck. *)
													(* Does any container have more than 1 unique tilt angle across the aspiration/dispense cycles *)
													(* for this multichannel transfer group? *)
													If[Length[tiltedContainersInGroupToAngles] > 4 || Or@@(Length[DeleteDuplicates[#]]>1&)/@Values[GroupBy[tiltedContainersInGroupToAngles, First->Last, Join]],
														True,
														False
													]
												]
											]
										]
									],
										{True, newTuple[[2]]/.{Automatic->CreateUUID[]}, newTuple[[3]]/.{Automatic->SingleProbe1}, newTuple[[4]]},

									(* If the user has specified Magnetization and there is already a source in our group that has Magnetization->True *)
									(* and the source of the two transfers is not the same, start a new group *)
									And[
										MatchQ[Lookup[myOptions,Magnetization][[newTuple[[4]]]],True],
										MemberQ[Lookup[myOptions,Magnetization][[lastTupleGroup[[All,4]]]],True],
										Length[DeleteDuplicates[
											Download[
												Lookup[
													Cases[
														Transpose[{workingSourceSamplePackets, Lookup[myOptions,Magnetization]}][[Append[lastTupleGroup[[All,4]],newTuple[[4]]]]],
														{cont_, True}:>cont
													],
													Container
												],
												Object
											]
										]]!=1
									],
										{True, newTuple[[2]]/.{Automatic->CreateUUID[]}, newTuple[[3]]/.{Automatic->SingleProbe1}, newTuple[[4]]},

									(* If the user has specified CollectionContainer and there is already a source in our group that has *)
									(* CollectionContainer specified and the source of the two transfers is not the same or the collection *)
									(* containers are not the same, start a new group. *)
									And[
										(* CollectionContainer is turned on for this new tuple or for this current tuple group. *)
										Or[
											MatchQ[Lookup[myOptions,CollectionContainer][[newTuple[[4]]]],ObjectP[]|{_Integer, ObjectP[]}],
											MemberQ[Lookup[myOptions,CollectionContainer][[lastTupleGroup[[All,4]]]],ObjectP[]|{_Integer, ObjectP[]}]
										],
										(* The CollectionContainer option is incompatible with the current tuple group. *)
										Or[
											(* The collection container of this transfer must match the previous collection container. *)
											!MatchQ[
												Lookup[myOptions,CollectionContainer][[lastTupleGroup[[All,4]]]],
												{ObjectP[Lookup[myOptions,CollectionContainer][[newTuple[[4]]]]]...}
											],
											(* The source containers of this transfer group must match. *)
											Length[DeleteDuplicates[
												Download[
													Lookup[
														workingDestinationSamplePackets[[Append[lastTupleGroup[[All,4]],newTuple[[4]]]]],
														Container
													],
													Object
												]
											]]!=1
										]
									],
										{True, newTuple[[2]]/.{Automatic->CreateUUID[]}, newTuple[[3]]/.{Automatic->SingleProbe1}, newTuple[[4]]},

									(* If our previous tuple was a MultiProbeHead transfer, start a new group. *)
									MatchQ[lastTuple[[3]],MultiProbeHead],
										{True, newTuple[[2]]/.{Automatic->CreateUUID[]}, newTuple[[3]]/.{Automatic->SingleProbe1}, newTuple[[4]]},

									(* If our previous tuple chose to turn off MultiChannel transfers and we're at the end of the list, don't turn it on. *)
									MatchQ[lastTuple[[1]], False] && MatchQ[newTuple[[4]], Length[mySources]],
										{False, newTuple[[2]]/.{Automatic->Null}, newTuple[[3]]/.{Automatic->Null}, newTuple[[4]]},

									(* Previous one was on and we haven't used up all of our channels yet (or the user specifically asked for group inclusion). *)
									(* Also make sure that the source sample of our current transfer wasn't a destination for a transfer in our current group. *)
									(* Append to the previous tuple's run. *)
									And[
										MatchQ[lastTuple[[1]], True],
										Or[
											MatchQ[newTuple[[2]], lastTuple[[2]]],
											And[
												(* Make sure that our group is less than 8 long since we only have 8 channels. *)
												Length[lastTupleGroup] < 8,
												(* HSL requires the DeviceChannel to be in ascending order within one group. That means Channel8 cannot be used already in this group and our new DeviceChannel (if specified) must be larger than existing DeviceChannel *)
												!MemberQ[lastTupleGroup[[All,3]], Last[$WorkCellProbes]],
												Or[
													MatchQ[newTuple[[3]],Automatic],
													MatchQ[
														Max[Flatten[{Position[$WorkCellProbes,Alternatives@@(lastTupleGroup[[All,3]])],0}]],
														LessP[FirstOrDefault[FirstPosition[$WorkCellProbes,newTuple[[3]]],Length[$WorkCellProbes]]]
													]
												],
												(* Make sure that the source sample of our current transfer wasn't a destination for a transfer in our current group *)
												!MemberQ[
													Lookup[
														workingDestinationSamplePackets[[lastTupleGroup[[All,4]]]],
														{Container, Position}
													]/.{link:LinkP[]:>Download[link, Object]},
													Lookup[workingSourceSamplePackets[[newTuple[[4]]]], {Container, Position}]/.{link:LinkP[]:>Download[link, Object]}
												]
											]
										]
									],
									(* Use the first unused Probe *)
										{True, lastTuple[[2]], newTuple[[3]]/.{Automatic->FirstOrDefault[Part[$WorkCellProbes, FirstPosition[$WorkCellProbes, lastTuple[[3]], 0]+1], SingleProbe1]}, newTuple[[4]]},

									(* Start a new run. *)
									True,
										{True, newTuple[[2]]/.{Automatic->CreateUUID[]}, newTuple[[3]]/.{Automatic->SingleProbe1}, newTuple[[4]]}
								];

								(* Append our new tuple at the end of our list. *)
								Append[tupleList, resolvedNewTuple]
							]
						],
						(* Initialize our first transfer before our fold. *)
						List@Switch[{preResolvedMultichannelTransfers[[1]], preResolvedMultichannelTransferNames[[1]], preResolvedDeviceChannels[[1]]},
							{Except[Automatic], Except[Automatic], Except[Automatic]},
								{preResolvedMultichannelTransfers[[1]], preResolvedMultichannelTransferNames[[1]], preResolvedDeviceChannels[[1]], 1},
							{False, _, _}|{Automatic, _, Null}|{Automatic, Null, _},
								{
									False,
									Lookup[myOptions, MultichannelTransferName][[1]],
									Lookup[myOptions, DeviceChannel][[1]],
									1
								}/.{Automatic->Null},
							{Automatic, _, _},
								{
									True,
									Lookup[myOptions, MultichannelTransferName][[1]]/.{Automatic->CreateUUID[]},
									Lookup[myOptions, DeviceChannel][[1]]/.{Automatic->SingleProbe1},
									1
								},
							_,
								{
									True,
									Lookup[myOptions, MultichannelTransferName][[1]]/.{Automatic->CreateUUID[]},
									Lookup[myOptions, DeviceChannel][[1]]/.{Automatic->SingleProbe1},
									1
								}
						],
						Rest[Transpose[
							{
								preResolvedMultichannelTransfers,
								preResolvedMultichannelTransferNames,
								preResolvedDeviceChannels,
								Range[Length[mySources]]
							}
						]]
					],
					(* preResolvedInstruments *)
					ConstantArray[Null, Length[myAmounts]]
				],

				(* Otherwise, just use the 8 channels like normal. *)
				True,
					Module[{allMultichannelShells, currentMultichannelShell, currentDestinationContainersAndWells,currentMagnetizationSourceContainer},
						(* Create a shell that when flattened equals our length of sources/destinations. This shell will represent the number *)
						(* of transfers that we should do at the same time. *)
						allMultichannelShells={};
						currentMultichannelShell={};
						currentDestinationContainersAndWells={};
						currentMagnetizationSourceContainer=Null;

						(* Make sure that the source sample of our transfer wasn't a destination for a transfer in our current group. *)
						MapThread[
							Function[{sourceContainerAndWell, destinationContainerAndWell, magnetization},
								If[
									And[
										!MemberQ[currentDestinationContainersAndWells, sourceContainerAndWell],
										Length[currentMultichannelShell]<$NumberOfWorkCellProbes,
										Or[MatchQ[magnetization,Except[True]],MatchQ[currentMagnetizationSourceContainer,Null],MatchQ[sourceContainerAndWell[[1]],currentMagnetizationSourceContainer]]
									],
										Module[{},
											AppendTo[currentMultichannelShell, Null];
											AppendTo[currentDestinationContainersAndWells, destinationContainerAndWell];
											If[MatchQ[magnetization,True],
												currentMagnetizationSourceContainer=sourceContainerAndWell[[1]];
											]
										],
										Module[{},
											AppendTo[allMultichannelShells, currentMultichannelShell];
											currentMultichannelShell={};
											currentDestinationContainersAndWells={};
											currentMagnetizationSourceContainer=Null;

											AppendTo[currentMultichannelShell, Null];
											AppendTo[currentDestinationContainersAndWells, destinationContainerAndWell];
											If[MatchQ[magnetization,True],
												currentMagnetizationSourceContainer=sourceContainerAndWell[[1]];
											]
										]
								]
							],
							{
								Transpose[{Download[Lookup[workingSourceSamplePackets, Container,Null], Object], Lookup[workingSourceSamplePackets, Position,Null]}],
								Transpose[{Download[Lookup[workingDestinationSamplePackets, Container], Object], Lookup[workingDestinationSamplePackets, Position]}],
								Lookup[myOptions,Magnetization]
							}
						];

						If[Length[currentMultichannelShell]>0,
							AppendTo[allMultichannelShells, currentMultichannelShell];
							currentMultichannelShell={};
							currentDestinationContainersAndWells={};
						];

						{
							ConstantArray[Null, Length[myAmounts]],
							Flatten[(If[Length[#]>1, ConstantArray[True, Length[#]], False]&)/@allMultichannelShells],
							Flatten[(If[Length[#]>1, ConstantArray[CreateUUID[], Length[#]], Null]&)/@allMultichannelShells],
							Flatten[(If[Length[#]>1, Take[{SingleProbe1, SingleProbe2, SingleProbe3, SingleProbe4, SingleProbe5, SingleProbe6, SingleProbe7, SingleProbe8}, Length[#]], SingleProbe1]&)/@allMultichannelShells]
						}
					]
			]
		],

		(* Manual transfers *)
		Module[
			{containerModelToMultichannelPipetteModelPackets, containerModelToPlateMap, currentDestinationWell, currentSourceWell,
				currentDestinationContainer, currentSourceContainer, currentSourceRunDirection, currentDestinationRunDirection,
				currentRun, allRuns, allRunPotentialInstruments, rawInstruments, rawMultichannelTransfers, rawMultichannelUUIDs,
				currentAmount, containerModelToMultichannelAspiratorModelPackets, currentRunPotentialInstruments, currentAmountAsVolume,
				currentCompatibleTipConnectionTypes, currentCultureHandling, uniquePlateContainerModelPackets},

			(* Get all of our unique plate model packets. *)
			uniquePlateContainerModelPackets=DeleteDuplicatesBy[
				Cases[Flatten[{workingDestinationContainerModelPackets, workingSourceContainerModelPackets}], PacketP[Model[Container, Plate]]],
				(Lookup[#, Object]&)
			];

			(* Figure out which of our source/destination container models are compatible with our multichannel pipettes. *)
			(* A container is considered compatible if the pitch is within 0.1 mm of the ChannelOffset of a pipette. *)
			containerModelToMultichannelPipetteModelPackets=(
				Download[#, Object]->Cases[
					allMultichannelPipetteModelPackets,
					KeyValuePattern[
						ChannelOffset->PatternUnion[
							(* NOTE: Some plates don't have a horizontal pitch if there's only one row of wells. *)
							If[MatchQ[Lookup[#, HorizontalPitch], Null],
								_,
								RangeP[Lookup[#, HorizontalPitch]-0.1 Millimeter, Lookup[#, HorizontalPitch]+0.1 Millimeter]
							],
							RangeP[Lookup[#, VerticalPitch]-0.1 Millimeter, Lookup[#, VerticalPitch]+0.1 Millimeter]
						]
					]
				]
			&)/@uniquePlateContainerModelPackets;

			(* NOTE: All aspirators can be used as single or multichannel aspirators by toggling the adapter. *)
			containerModelToMultichannelAspiratorModelPackets=(
				Download[#, Object]->Cases[
					allAspiratorModelPackets,
					KeyValuePattern[
						ChannelOffset->PatternUnion[
							(* NOTE: Some plates don't have a horizontal pitch if there's only one row of wells. *)
							If[MatchQ[Lookup[#, HorizontalPitch], Null],
								_,
								RangeP[Lookup[#, HorizontalPitch]-0.1 Millimeter, Lookup[#, HorizontalPitch]+0.1 Millimeter]
							],
							RangeP[Lookup[#, VerticalPitch]-0.1 Millimeter, Lookup[#, VerticalPitch]+0.1 Millimeter]
						]
					]
				]
			&)/@uniquePlateContainerModelPackets;

			(* Make all of the plate maps for our container models. *)
			(* This is basically the same thing as AllWells[] but is much faster since we don't have to make separate calls. *)
			containerModelToPlateMap=(
				Lookup[#, Object]->Partition[
					Lookup[Lookup[#, Positions], Name],
					Lookup[#, Columns]
				]
			&)/@uniquePlateContainerModelPackets;

			(* Variables to track our runs. *)
			allRuns={}; (* This is a list of indices like {{1,2,3},{5,6,7}}. *)
			allRunPotentialInstruments={}; (* Index matched to allRuns, a list of the pipette models that we can use to perform the transfer. *)

			(* Variables that get over-written so we know when to stop a run. *)
			currentRun={};
			currentRunPotentialInstruments={};
			currentSourceRunDirection=Null;
			currentDestinationRunDirection=Null;
			currentSourceContainer=Null;
			currentDestinationContainer=Null;
			currentSourceWell=Null;
			currentDestinationWell=Null;
			currentAmount=Null;
			currentAmountAsVolume=Null;
			currentCompatibleTipConnectionTypes={};
			currentCultureHandling=Null;

			(* Compute all of our runs. *)
			MapThread[
				Function[{workingSourceSamplePacket, workingSourceContainerPacket, workingDestinationSamplePacket, workingDestinationContainerPacket, workingSourceContainerModelPacket, workingDestinationContainerModelPacket, destinationIsWasteQ, sourceWell, destinationWell, amount, tipType, options, manipulationIndex},
					Which[
						(* Some basic checks to see if it's even valid to continue the run. *)
						Or[
							(* If currentSourceContainer/currentDestinationContainer are set and we're dealing with a new container, end the run and move on. *)
							And[
								MatchQ[currentSourceContainer, ObjectP[]],
								MatchQ[currentDestinationContainer, ObjectP[]],
								Or[
									!MatchQ[currentSourceContainer[Object], ObjectReferenceP[Lookup[workingSourceContainerPacket, Object]]],
									!MatchQ[currentDestinationContainer[Object], ObjectReferenceP[Lookup[workingDestinationContainerPacket, Object]]]
								]
							],

							(* If currentAmount is set and we're dealing with a different amount, end the run and move on. *)
							And[
								MatchQ[currentAmount, Except[Null]],
								!MatchQ[currentAmount, amount]
							],

							(* If the source and destination containers aren't plates, we can't do this. *)
							(* Unless the destination container is waste. *)
							Or[
								!MatchQ[Lookup[workingSourceContainerModelPacket, Object], ObjectReferenceP[Model[Container, Plate]]],
								And[
									!MatchQ[Lookup[workingDestinationContainerModelPacket, Object], ObjectReferenceP[Model[Container, Plate]]],
									!MatchQ[destinationIsWasteQ, True]
								]
							],

							(* If the source and destination containers aren't in one of our pre-cached compatible lists, we can't do this. *)
							And[
								!MatchQ[destinationIsWasteQ, True],
								MatchQ[
									Length[
										Cases[
											Lookup[
												containerModelToMultichannelPipetteModelPackets,
												Lookup[workingSourceContainerModelPacket, Object],
												{}
											],
											KeyValuePattern[{
												MaxVolume->GreaterEqualP[currentAmountAsVolume],
												TipConnectionType->Alternatives@@currentCompatibleTipConnectionTypes,
												CultureHandling->currentCultureHandling
											}]
										]
									],
									LessP[1]
								]
							],
							And[
								!MatchQ[destinationIsWasteQ, True],
								MatchQ[
									Length[
										Cases[
											Lookup[
												containerModelToMultichannelPipetteModelPackets,
												Lookup[workingDestinationContainerModelPacket, Object],
												{}
											],
											KeyValuePattern[{
												MaxVolume->GreaterEqualP[currentAmountAsVolume],
												TipConnectionType->Alternatives@@currentCompatibleTipConnectionTypes,
												CultureHandling->currentCultureHandling
											}]
										]
									],
									LessP[1]
								]
							],

							And[
								MatchQ[destinationIsWasteQ, True],
								MatchQ[
									Length[
										Cases[
											Lookup[
												containerModelToMultichannelAspiratorModelPackets,
												Lookup[workingSourceContainerModelPacket, Object],
												{}
											],
											KeyValuePattern[{
												CultureHandling->currentCultureHandling
											}]
										]
									],
									LessP[1]
								]
							],

							Module[{previousPosDestinations},
								(* get a list of tuples of all previous {pos, container} in the latest run *)
								previousPosDestinations = Transpose[{
									Append[Part[resolvedDestinationWells, Last[allRuns, {}]], currentDestinationWell],
									Append[Part[Lookup[workingDestinationContainerPackets, Object], Last[allRuns, {}]], currentDestinationContainer]
								}];
								(* if the current source has been "detected" as a destination in the previous group, end the run and move on, since we are doing serial transfers and cannot do the later transfer before/together with the previous transfer *)
								MemberQ[previousPosDestinations, {sourceWell, Lookup[workingSourceContainerPacket, Object]}]
							]
						],
						Module[{},
							(* Append if there's something worthwhile to keep. *)
							If[MatchQ[Length[currentRun], GreaterP[1]],
								allRuns=Append[allRuns, currentRun];
								allRunPotentialInstruments=Append[allRunPotentialInstruments, currentRunPotentialInstruments];
							];

							(* Reset variables. *)
							currentRun={};
							currentRunPotentialInstruments={};
							currentSourceRunDirection=Null;
							currentDestinationRunDirection=Null;
							currentSourceContainer=Null;
							currentDestinationContainer=Null;
							currentSourceWell=Null;
							currentDestinationWell=Null;
							currentAmount=Null;
							currentAmountAsVolume=Null;
							currentCompatibleTipConnectionTypes={};
							currentCultureHandling=Null;

							(* Add to our run. *)
							currentRun=Append[currentRun, manipulationIndex];
							currentSourceContainer=Lookup[workingSourceContainerPacket, Object];
							currentDestinationContainer=Lookup[workingDestinationContainerPacket, Object];
							currentSourceWell=sourceWell;
							currentDestinationWell=destinationWell;
							currentAmount=amount;
							currentAmountAsVolume=Which[
								(* Specifically don't try to convert for solids because we can't aspirate/pipette transfer solids. *)
								MatchQ[Lookup[workingSourceSamplePacket, State], Solid],
									Null,
								(* Convert All for liquids to be Volume of the sample. *)
								MatchQ[amount, All] && MatchQ[Lookup[workingSourceSamplePacket, Volume], VolumeP],
									Lookup[workingSourceSamplePacket, Volume],
								(* Otherwise, just use the amount given. *)
								True,
									amount
							];
							(* if we already specified tips, we need to make sure the compatible tips we're including here work properly match the tips that were specified *)
							currentCompatibleTipConnectionTypes=If[MatchQ[currentAmountAsVolume, VolumeP],
								With[
									{potentialTipTypes = Map[
										fastAssocLookup[fastAssoc, #, TipConnectionType]&,
										TransferDevices[Model[Item, Tips], currentAmountAsVolume][[All, 1]]
									]},
									If[MatchQ[tipType, TipConnectionTypeP],
										Cases[potentialTipTypes, tipType],
										potentialTipTypes
									]
								],
								{}
							];
							currentCultureHandling=resolveCultureHandling[workingSourceSamplePacket, workingDestinationSamplePacket, options];
						],

						(* If we're just starting a new run, initialize our variables. *)
						MatchQ[Length[currentRun], 0],
						Module[{},
							(* Add to our run. *)
							currentRun=Append[currentRun, manipulationIndex];
							currentSourceContainer=Lookup[workingSourceContainerPacket, Object];
							currentDestinationContainer=Lookup[workingDestinationContainerPacket, Object];
							currentSourceWell=sourceWell;
							currentDestinationWell=destinationWell;
							currentAmount=amount;
						],

						(* We already have an ongoing run and are dispensing to waste. *)
						(* NOTE: This is basically the same as the next Switch branch, but without the destination checks. *)
						MatchQ[destinationIsWasteQ, True],
						Module[{sourceContainerMap, sourceWellPosition, sourceWellOffset},
							(* Get the plate map of our source and destination containers. *)
							sourceContainerMap=Lookup[containerModelToPlateMap, Lookup[workingSourceContainerModelPacket, Object]];

							(* Get the location of our source and destination wells in our map. *)
							sourceWellPosition=FirstPosition[sourceContainerMap, sourceWell, Null];
							sourceWellOffset=sourceWellPosition-FirstPosition[sourceContainerMap, currentSourceWell, Null];

							(* Define the direction of the run (this will happen on our second element of the run). *)
							If[MatchQ[currentSourceRunDirection, Null],
								currentSourceRunDirection=sourceWellOffset;

								currentRunPotentialInstruments=If[MatchQ[destinationIsWasteQ, True],
									Cases[
										Lookup[
											containerModelToMultichannelAspiratorModelPackets,
											Lookup[workingSourceContainerModelPacket, Object],
											{}
										],
										KeyValuePattern[{
											CultureHandling->currentCultureHandling
										}]
									],
									Cases[
										Lookup[
											containerModelToMultichannelPipetteModelPackets,
											Lookup[workingSourceContainerModelPacket, Object],
											{}
										],
										KeyValuePattern[{
											MaxVolume->GreaterEqualP[currentAmountAsVolume],
											TipConnectionType->Alternatives@@currentCompatibleTipConnectionTypes,
											CultureHandling->currentCultureHandling
										}]
									]
								];
							];

							If[Or[
								(* If we weren't able to find either the source well, end the run. *)
								MatchQ[sourceWellPosition, Null],

								(* Or the offsets don't match {1,0} (Vertical) or {0,1} (Horizontal). *)
								!MatchQ[sourceWellOffset, {1,0}|{0,1}|{-1,0}|{0,-1}],

								(* Make sure the offsets match the run direction. *)
								!MatchQ[sourceWellOffset, currentSourceRunDirection]
							],
								(* Append if there's something worthwhile to keep. *)
								If[MatchQ[Length[currentRun], GreaterP[1]],
									allRuns=Append[allRuns, currentRun];
									allRunPotentialInstruments=Append[allRunPotentialInstruments, currentRunPotentialInstruments];
								];

								(* Reset variables. *)
								currentRun={};
								currentRunPotentialInstruments={};
								currentSourceRunDirection=Null;
								currentDestinationRunDirection=Null;
								currentSourceContainer=Null;
								currentDestinationContainer=Null;
								currentSourceWell=Null;
								currentDestinationWell=Null;
								currentAmount=Null;
								currentAmountAsVolume=Null;
								currentCompatibleTipConnectionTypes={};
								currentCultureHandling=Null;

								(* Add to our run. *)
								currentRun=Append[currentRun, manipulationIndex];
								currentSourceContainer=Lookup[workingSourceContainerPacket, Object];
								currentDestinationContainer=Lookup[workingDestinationContainerPacket, Object];
								currentSourceWell=sourceWell;
								currentDestinationWell=destinationWell;
								currentAmount=amount;
								currentAmountAsVolume=Which[
									(* Specifically don't try to convert for solids because we can't aspirate/pipette transfer solids. *)
									MatchQ[Lookup[workingSourceSamplePacket, State], Solid],
									Null,
									(* Convert All for liquids to be Volume of the sample. *)
									MatchQ[amount, All] && MatchQ[Lookup[workingSourceSamplePacket, Volume], VolumeP],
									Lookup[workingSourceSamplePacket, Volume],
									(* Otherwise, just use the amount given. *)
									True,
									amount
								];
								currentCompatibleTipConnectionTypes=If[MatchQ[currentAmountAsVolume, VolumeP],
									((fastAssocLookup[fastAssoc, #, TipConnectionType]&)/@TransferDevices[Model[Item, Tips], currentAmountAsVolume][[All, 1]]),
									{}
								];
								currentCultureHandling=resolveCultureHandling[workingSourceSamplePacket, workingDestinationSamplePacket, options];

								Null,

								(* ELSE: Append to our current run. *)
								currentRun=Append[currentRun, manipulationIndex];
								currentSourceWell=sourceWell;
								currentDestinationWell=destinationWell;
							]
						],
						(* We already have an ongoing run and are not using an aspirator to waste. Check the validity of the directionality. *)
						True,
						Module[{sourceContainerMap, destinationContainerMap, sourceWellPosition, destinationWellPosition, sourceWellOffset, destinationWellOffset},
							(* Get the plate map of our source and destination containers. *)
							sourceContainerMap=Lookup[containerModelToPlateMap, Lookup[workingSourceContainerModelPacket, Object]];
							destinationContainerMap=Lookup[containerModelToPlateMap, Lookup[workingDestinationContainerModelPacket, Object]];

							(* Get the location of our source and destination wells in our map. *)
							sourceWellPosition=FirstPosition[sourceContainerMap, sourceWell, Null];
							destinationWellPosition=FirstPosition[destinationContainerMap, destinationWell, Null];
							sourceWellOffset=sourceWellPosition-FirstPosition[sourceContainerMap, currentSourceWell, Null];
							destinationWellOffset=destinationWellPosition-FirstPosition[destinationContainerMap, currentDestinationWell, Null];

							(* Define the direction of the run (this will happen on our second element of the run). *)
							If[MatchQ[currentSourceRunDirection, Null],
								currentSourceRunDirection=sourceWellOffset;
								currentDestinationRunDirection=destinationWellOffset;

								currentRunPotentialInstruments=If[MatchQ[destinationIsWasteQ, True],
									Cases[
										Lookup[
											containerModelToMultichannelAspiratorModelPackets,
											Lookup[workingSourceContainerModelPacket, Object],
											{}
										],
										KeyValuePattern[{
											CultureHandling->currentCultureHandling
										}]
									],
									Cases[
										Lookup[
											containerModelToMultichannelPipetteModelPackets,
											Lookup[workingSourceContainerModelPacket, Object],
											{}
										],
										KeyValuePattern[{
											MaxVolume->GreaterEqualP[currentAmountAsVolume],
											TipConnectionType->Alternatives@@currentCompatibleTipConnectionTypes,
											CultureHandling->currentCultureHandling
										}]
									]
								];
							];

							If[Or[
								(* If we weren't able to find either the source or destination well, end the run. *)
								MatchQ[sourceWellPosition, Null] || MatchQ[destinationWellPosition, Null],

								(* Or the offsets don't match {1,0} (Vertical) or {0,1} (Horizontal). *)
								!MatchQ[sourceWellOffset, {1,0}|{0,1}|{-1,0}|{0,-1}],
								!MatchQ[destinationWellOffset, {1,0}|{0,1}|{-1,0}|{0,-1}],

								(* Make sure the offsets match the run direction. *)
								!MatchQ[sourceWellOffset, currentSourceRunDirection],
								!MatchQ[destinationWellOffset, currentDestinationRunDirection]
							],
								(* Append if there's something worthwhile to keep. *)
								If[MatchQ[Length[currentRun], GreaterP[1]],
									allRuns=Append[allRuns, currentRun];
									allRunPotentialInstruments=Append[allRunPotentialInstruments, currentRunPotentialInstruments];
								];

								(* Reset variables. *)
								currentRun={};
								currentRunPotentialInstruments={};
								currentSourceRunDirection=Null;
								currentDestinationRunDirection=Null;
								currentSourceContainer=Null;
								currentDestinationContainer=Null;
								currentSourceWell=Null;
								currentDestinationWell=Null;
								currentAmount=Null;
								currentCompatibleTipConnectionTypes={};
								currentCultureHandling=Null;

								(* Add to our run. *)
								currentRun=Append[currentRun, manipulationIndex];
								currentSourceContainer=Lookup[workingSourceContainerPacket, Object];
								currentDestinationContainer=Lookup[workingDestinationContainerPacket, Object];
								currentSourceWell=sourceWell;
								currentDestinationWell=destinationWell;
								currentAmount=amount;
								currentAmountAsVolume=Which[
									(* Specifically don't try to convert for solids because we can't aspirate/pipette transfer solids. *)
									MatchQ[Lookup[workingSourceSamplePacket, State], Solid],
									Null,
									(* Convert All for liquids to be Volume of the sample. *)
									MatchQ[amount, All] && MatchQ[Lookup[workingSourceSamplePacket, Volume], VolumeP],
									Lookup[workingSourceSamplePacket, Volume],
									(* Otherwise, just use the amount given. *)
									True,
									amount
								];
								currentCompatibleTipConnectionTypes=If[MatchQ[currentAmountAsVolume, VolumeP],
									((fastAssocLookup[fastAssoc, #, TipConnectionType]&)/@TransferDevices[Model[Item, Tips], currentAmountAsVolume][[All, 1]]),
									{}
								];
								currentCultureHandling=resolveCultureHandling[workingSourceSamplePacket, workingDestinationSamplePacket, options];

								Null,

								(* ELSE: Append to our current run. *)
								currentRun=Append[currentRun, manipulationIndex];
								currentSourceWell=sourceWell;
								currentDestinationWell=destinationWell;
							]
						]
					]
				],
				{
					workingSourceSamplePackets, workingSourceContainerPackets, workingDestinationSamplePackets, workingDestinationContainerPackets,
					workingSourceContainerModelPackets, workingDestinationContainerModelPackets, (MatchQ[#, Waste]&)/@myDestinations,
					resolvedSourceWells, resolvedDestinationWells, myAmounts, suppliedTipType, mapThreadFriendlyOptions,
					Range[Length[myAmounts]]
				}
			];

			(* Append our last run if we have one. *)
			If[MatchQ[Length[currentRun], GreaterP[1]],
				allRuns=Append[allRuns, currentRun];
				allRunPotentialInstruments=Append[allRunPotentialInstruments, currentRunPotentialInstruments];
			];

			(* For each of our runs, pre-resolve our options. *)
			rawInstruments=Lookup[myOptions, Instrument];
			rawMultichannelTransfers=ConstantArray[False, Length[myAmounts]];
			rawMultichannelUUIDs=ConstantArray[Null, Length[myAmounts]];

			(* Over-write our options at the indices of our runs. *)
			MapThread[
				Function[{run, runInstruments},
					(* Do we have an indication that we're not supposed to use a multichannel pipette? *)
					If[Or[
						(* They gave us a non-pipette. *)
						MemberQ[Lookup[myOptions, Instrument][[run]], Except[ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]|Automatic]],

						(* They told us to not do a multi-channel transfer. *)
						MemberQ[Lookup[myOptions, MultichannelTransfer][[run]], False],

						(* There are no compatible pipettes for the given direction. *)
						Length[runInstruments]==0,

						(* Manual transfer, AspirationMix/DispenseMixType set to Pipette, NumberOfMixes larger than $MaxNumberOfMultichannelPipetteMixes *)
						And[
							MatchQ[resolvedPreparation, Manual],
							!MatchQ[Lookup[myOptions, MultichannelTransfer][[run]], {True..}],
							Or[
								MemberQ[Transpose[{Lookup[myOptions, AspirationMixType][[run]], Lookup[myOptions, NumberOfAspirationMixes][[run]]}], {Pipette, GreaterP[$MaxNumberOfMultichannelPipetteMixes]}],
								MemberQ[Transpose[{Lookup[myOptions, DispenseMixType][[run]], Lookup[myOptions, NumberOfDispenseMixes][[run]]}], {Pipette, GreaterP[$MaxNumberOfMultichannelPipetteMixes]}]
							]
						]
					],
						(* Then, resolve MultichannelTransfer->False. *)
						rawMultichannelTransfers[[run]] = ConstantArray[False, Length[run]],

						(* ELSE: We should use a multi-channel pipette. Figure out which one we should use. *)
						Module[{maxNumberOfChannels},
							(* What is the most number of channels that we have? *)
							maxNumberOfChannels=Max[Cases[Lookup[runInstruments, Channels], _Integer]];

							If[Length[run] <= maxNumberOfChannels,
								(* We can do this in one shot. Pick the pipette with the closest number of channels that we need. *)
								Module[{specifiedInstruments,potentialInstrumentPackets,instrumentToUse},
									(* get the raw Instrument option values *)
									specifiedInstruments=Lookup[myOptions,Instrument][[run]];

									(* get the instrument packets with channels >= number of transfers in each run *)
									potentialInstrumentPackets=Cases[runInstruments,KeyValuePattern[Channels->GreaterEqualP[Length[run]]]];

									(* pre-resolve instrument to replace Automatic *)
									(* did the user specify an Instrument at any index? *)
									instrumentToUse=If[MemberQ[specifiedInstruments,Except[Automatic]],
										(* return the first member that is an object *)
										FirstCase[specifiedInstruments,ObjectP[]],
										(* pick the pipette with the closest number of channels that we need *)
										First@Lookup[SortBy[potentialInstrumentPackets,(Length[run]-Lookup[#,Channels])&],Object]
									];

									(* replace Automatic with the instrument we pre-resolved *)
									rawInstruments[[run]] = specifiedInstruments/.Automatic->instrumentToUse;

									(* at this point MultichannelTransfer option should resolve to true for all indices *)
									rawMultichannelTransfers[[run]] = ConstantArray[True, Length[run]];

									(* all indices get the same UUID since we can pipette all samples in one go *)
									rawMultichannelUUIDs[[run]] = ConstantArray[CreateUUID[], Length[run]];
								],
								(* ELSE: We can't do this in one shot. Use the instrument with the maximum number of channels and then split up the runs. *)
								Module[{specifiedInstruments,instrumentToUse},
									(* get the raw Instrument option values *)
									specifiedInstruments=Lookup[myOptions,Instrument][[run]];

									(* pre-resolve instrument to replace Automatic *)
									(* did the user specify an Instrument at any index? *)
									instrumentToUse=If[MemberQ[specifiedInstruments,Except[Automatic]],
										(* return the first member that is an object *)
										FirstCase[specifiedInstruments,ObjectP[]],
										(* else: pick the pipette with the maximum number of channels *)
										Lookup[FirstCase[runInstruments,KeyValuePattern[Channels->maxNumberOfChannels]],Object]
									];

									(* replace Automatic with the instrument we pre-resolved *)
									rawInstruments[[run]] = specifiedInstruments/.Automatic->instrumentToUse;

									(* at this point MultichannelTransfer option should resolve to true for all indices *)
									rawMultichannelTransfers[[run]] = ConstantArray[True, Length[run]];

									(* Split up into IntegerPart[Length[run]/maxNumberOfChannels] full channel transfers and *)
									(* 1 partial transfer using Mod[Length[run], maxNumberOfChannels] channels. *)
									rawMultichannelUUIDs[[run]] = Flatten[{
										Table[
											ConstantArray[CreateUUID[], maxNumberOfChannels],
											{x, 1, IntegerPart[Length[run]/maxNumberOfChannels]}
										],
										ConstantArray[CreateUUID[], Mod[Length[run], maxNumberOfChannels]]
									}];
								]
							]
						]
					]
				],
				{allRuns, allRunPotentialInstruments}
			];

			(* Return the options that we overwrote. *)
			{rawInstruments, rawMultichannelTransfers, rawMultichannelUUIDs, ConstantArray[Null, Length[myAmounts]]}
		]
	];

	(*
		In this section we are calculating offsets for the MultiProbeHead - the number of wells/columns by which
		we will have to shift virtual labware on deck to make multi probe head aspirate/dispense into the correct position.
		NOTE: we have to keep in mind that we are not always picking up the full rack of tips which means we have to account
		for the actual top-left tip on the multiprobe head and match it with the top-left corner of the aspiration/dispense square
	*)
	{
		resolvedMultiProbeHeadRows,
		resolvedMultiProbeColumns,
		resolvedMultiProbeAspirationOffsetRows,
		resolvedMultiProbeAspirationOffsetColumns,
		resolvedMultiProbeDispenseOffsetRows,
		resolvedMultiProbeDispenseOffsetColumns
	} = If[MatchQ[resolvedPreparation, Manual],
		(* for Manual all 6 are Nulls, expanded to the # of transfers *)
		ConstantArray[ConstantArray[Null,Length[myAmounts]], 6],

		(* for Robotic, we need to grab only MultiProbeHead and do math only on them and then just back-populate those positions *)
		Module[
			{transferInformation, splitTransfers, resolvedParametersMultiProbeHead, reservoirsAlternative},
			transferInformation = Transpose[{
				(*1*)Lookup[workingSourceContainerModelPackets, Object],
				(*2*)Lookup[workingDestinationContainerModelPackets, Object],
				(*3*)Lookup[workingSourceSamplePackets, Position],
				(*4*)Lookup[workingDestinationSamplePackets, Position],
				(*5*)resolvedMultichannelTransferNames,
				(*6*)resolvedDeviceChannels,
				(*7*)Lookup[workingSourceContainerModelPackets, NumberOfWells],
				(*8*)Lookup[workingDestinationContainerModelPackets, NumberOfWells],
				(*9*)Range[Length[resolvedDeviceChannels]] (* this is the index of out transfer *)
			}];
			reservoirsAlternative = Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"];

			splitTransfers = SplitBy[transferInformation, #[[5]]&];

			(* going over every group split by the multichannel transfer name *)
			resolvedParametersMultiProbeHead = Transpose@Flatten[Map[Function[{transferGroup},
				If[!MatchQ[transferGroup[[1,6]],MultiProbeHead],
					(* this group is not MultiProbeHead - no offsets, expanded by the number of transfers in the group *)
					ConstantArray[ConstantArray[Null,6],Length[transferGroup]],

					(* case with 96 transfers is easier since we are using full MultiProbeHead always *)
					If[Length[transferGroup]==96,
						Transpose@{
							ConstantArray[8,96],
							ConstantArray[12,96],
							Sequence@@Switch[transferGroup[[1,{1,2,7,8}]],
								(* for the case of two plates, we don't have any offsets to deal with *)
								{_, _, 96|384, 96|384},
								ConstantArray[ConstantArray[0,96],4],

								(* we are transferring from a reservoir into a reservoir - no offsets *)
								{reservoirsAlternative, reservoirsAlternative, _, _},
								ConstantArray[ConstantArray[0,96],4],

								(* source is the reservoir but destination is not *)
								{reservoirsAlternative, _, _, 96},
								{
									ConstantArray[0,96],
									ConstantArray[0,96],
									Sequence@@Module[{firstWell,offsetPair},
										firstWell=Sort[wellToTuple/@transferGroup[[;;,4]]][[1]];
										offsetPair=Position[map96Integers,firstWell][[1]]-{1,1};
										{ConstantArray[offsetPair[[1]],96],ConstantArray[offsetPair[[2]],96]}
									]
								},

								(* 384-well case *)
								{reservoirsAlternative, _, _, 384},
								{
									ConstantArray[0,96],
									ConstantArray[0,96],
									Sequence@@Module[{firstWell,offsetPair},
										firstWell=Sort[wellToTuple/@transferGroup[[;;,4]]][[1]];
										offsetPair=Position[Map[wellToTuple,map384[transferGroup[[1,4]]],{2}],firstWell][[1]]-{1,1};
										{ConstantArray[offsetPair[[1]],96],ConstantArray[offsetPair[[2]],96]}
									]
								},

								(* destination is the reservoir but source is not *)
								{_, reservoirsAlternative, 96, _},
								{
									Sequence@@Module[{firstWell,offsetPair},
										firstWell=Sort[wellToTuple/@transferGroup[[;;,3]]][[1]];
										offsetPair=Position[map96Integers,firstWell][[1]]-{1,1};
										{ConstantArray[offsetPair[[1]],96],ConstantArray[offsetPair[[2]],96]}
									],
									ConstantArray[0,96],
									ConstantArray[0,96]
								},

								(* 384-well case *)
								{_, reservoirsAlternative, 384, _},
								{
									Sequence@@Module[{firstWell,offsetPair},
										firstWell=Sort[wellToTuple/@transferGroup[[;;,3]]][[1]];
										offsetPair=Position[Map[wellToTuple,map384[transferGroup[[1,3]]],{2}],firstWell][[1]]-{1,1};
										{ConstantArray[offsetPair[[1]],96],ConstantArray[offsetPair[[2]],96]}
									],
									ConstantArray[0,96],
									ConstantArray[0,96]
								}
							]
						},

						(* we have less than 96 transfers - we have to calculate the size of the transfer and take into account that we will be using not A1 on the MultiProbeHead *)
						Module[{
							sourceWells,destinationWells,sourceContainerModel,destinationContainerModel,numberOfRows,numberOfColumns,numberOfTransfers,
							multiProbeHeadTopLeftTipPosition,sourceNumberOfWells,destinationNumberOfWells,aspirationPositionTopLeft,
							aspirationOffsetRow,aspirationOffsetColumn,dispensePositionTopLeft,dispenseOffsetRow,dispenseOffsetColumn,
							checkMultiProbeError
						},

							sourceWells=wellToTuple/@transferGroup[[;;,3]];
							destinationWells=wellToTuple/@transferGroup[[;;,4]];
							sourceContainerModel=transferGroup[[1,1]];
							destinationContainerModel=transferGroup[[1,2]];
							sourceNumberOfWells=transferGroup[[1,7]];
							destinationNumberOfWells=transferGroup[[1,8]];
							numberOfTransfers=Length[transferGroup];

							numberOfRows=Switch[{sourceContainerModel,destinationContainerModel},
								(* for reservoir->reservoir - just calculate how many we have *)
								{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"]},
								With[{columns=SelectFirst[Reverse@Cases[Divisors[numberOfTransfers],LessEqualP[12]],Mod[numberOfTransfers,#]==0 &]},
									numberOfTransfers / columns
								],
								(* for reservoir->plate use Destination *)
								{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],_},
								Length[GatherBy[destinationWells,First]],
								(* in all other cases, use source *)
								_,
								Length[GatherBy[sourceWells,First]]
							];
							numberOfColumns=Switch[{sourceContainerModel,destinationContainerModel},
								(* for reservoir->reservoir - just calculate how many we have *)
								{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"]},
								With[{columns=SelectFirst[Reverse@Cases[Divisors[numberOfTransfers],LessEqualP[12]],Mod[numberOfTransfers,#]==0 &]},
									columns
								],
								(* for reservoir->plate use Destination *)
								{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],_},
								Length[GatherBy[destinationWells,Last]],
								(* in all other cases, use source *)
								_,
								Length[GatherBy[sourceWells,Last]]
							];

							(* small helper to make code look nicer *)
							checkMultiProbeError[wells:{{_Integer,_Integer}..},map:{{{_Integer,_Integer}..}..}]:=If[!rectangleQ[wells,map],AppendTo[incorrectMultiProbeHeadTransfer,transferGroup[[;;,9]]]];

							(* at this point we can check if the transfers we are working with are rectangular and add an error if they are not *)
							Switch[{sourceContainerModel,sourceNumberOfWells,destinationContainerModel,destinationNumberOfWells},
								{_,96,_,_},checkMultiProbeError[sourceWells,Map[wellToTuple,AllWells[],{2}]],
								{_,_,_,96},checkMultiProbeError[destinationWells,Map[wellToTuple,AllWells[],{2}]],
								{_,384,_,_},checkMultiProbeError[sourceWells,Map[wellToTuple,map384[sourceWells[[1]]],{2}]],
								{_,_,_,384},checkMultiProbeError[destinationWells,Map[wellToTuple,map384[destinationWells[[1]]],{2}]],
								(*
									for the weird case of transfers from a reservoir into a reservoir we just need to check that the # of transfers can fit into a rectangle
									the transfer exporter will force these transfers to use square virtual wells
								*)
								{
									Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],
									_,
									Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],
									_
								},
									With[{possibleAreas=Flatten@Table[row * column,{row,1,8},{column,1,12}]},
										If[!MemberQ[possibleAreas,Length[transferGroup]],AppendTo[incorrectMultiProbeHeadTransfer,transferGroup[[;;,9]]]]
									]
							];

							(* MultiProbeHead will always pick up from the H12 corner, so we have to count from it to find our first picked tip position *)
							multiProbeHeadTopLeftTipPosition=wellToTuple@(Reverse@(Reverse/@AllWells[]))[[numberOfRows,numberOfColumns]];

							(* calculate the offset that we have to use for the MultiProbeHead in order to aspirate with our tips from the source wells *)
							aspirationPositionTopLeft=SortBy[SortBy[sourceWells,First],Last][[1]];
							{aspirationOffsetRow,aspirationOffsetColumn}=Switch[{sourceContainerModel,sourceNumberOfWells},
								(* no offset for the reservoirs *)
								{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],_},
								{0,0},
								{_,96},
								Position[map96Integers,aspirationPositionTopLeft][[1]] - Position[map96Integers,multiProbeHeadTopLeftTipPosition][[1]],
								{_,384},
								(* we are using "sub plates" here because we want to preserve the wells that we are actually transferring into in the manipulations file *)
								Position[Map[wellToTuple,map384[tupleToWell[aspirationPositionTopLeft]],{2}],aspirationPositionTopLeft][[1]] - Position[map96Integers,multiProbeHeadTopLeftTipPosition][[1]]
							];

							(* calculate the offset that we have to use for the MultiProbeHead in order to dispense with our tips into destination wells *)
							dispensePositionTopLeft=SortBy[SortBy[destinationWells,First],Last][[1]];
							{dispenseOffsetRow,dispenseOffsetColumn}=Switch[{destinationContainerModel,destinationNumberOfWells},
								(* no offset for reservoir *)
								{Model[Container,Plate,"id:Vrbp1jG800Vb"] | Model[Container,Plate,"id:54n6evLWKqbG"],_},
								{0,0},
								{_,96},
								Position[map96Integers,dispensePositionTopLeft][[1]] - Position[map96Integers,multiProbeHeadTopLeftTipPosition][[1]],
								{_,384},
								(* we are using "sub plates" here because we want to preserve the wells that we are actually transferring into in the manipulations file *)
								Position[Map[wellToTuple,map384[tupleToWell[dispensePositionTopLeft]],{2}],dispensePositionTopLeft][[1]] - Position[map96Integers,multiProbeHeadTopLeftTipPosition][[1]]
							];

							(* output the result *)
							ConstantArray[{
								numberOfRows,
								numberOfColumns,
								aspirationOffsetRow,
								aspirationOffsetColumn,
								dispenseOffsetRow,
								dispenseOffsetColumn
							}, numberOfTransfers]
						]
					]
				]],splitTransfers],1];

			resolvedParametersMultiProbeHead
		]
	];

	(* make a lookup of any new labels that we create for samples/containers since we may re-use them *)
	objectToNewResolvedLabelLookup = {};

	(* Convert our options into a MapThread friendly version. *)
	(* Also replace with our pre-resolved multichannel options. *)
	mapThreadFriendlyOptionsWithPreResolvedOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentTransfer,
		Append[
			roundedOptions,
			<|
				Instrument->preresolvedInstruments,
				MultichannelTransfer->resolvedMultichannelTransfers,
				MultichannelTransferName->resolvedMultichannelTransferNames,
				SourceWell->resolvedSourceWells,
				DestinationWell->resolvedDestinationWells,
				DeviceChannel->resolvedDeviceChannels,
				MultiProbeHeadNumberOfRows->resolvedMultiProbeHeadRows,
				MultiProbeHeadNumberOfColumns->resolvedMultiProbeColumns,
				MultiProbeAspirationOffsetRows->resolvedMultiProbeAspirationOffsetRows,
				MultiProbeAspirationOffsetColumns->resolvedMultiProbeAspirationOffsetColumns,
				MultiProbeDispenseOffsetRows->resolvedMultiProbeDispenseOffsetRows,
				MultiProbeDispenseOffsetColumns->resolvedMultiProbeDispenseOffsetColumns,
				AspirationAngle->resolvedAspirationAngles,
				DispenseAngle->resolvedDispenseAngles
			|>
		]
	];

	(* Define specified Site for instrument resolution below *)
	(* If we are in a subprotocol, we must have the same site as the parent/root protocol *)
	parentProtocolSite = If[!MatchQ[parentProtocolTree,{}],
		Lookup[fetchPacketFromFastAssoc[Last[parentProtocolTree],fastAssoc],Site,Automatic]/.{Null->Automatic},
		Automatic
	];
	(* Determine the site using the option, or the parent protocol *)
	specifiedSite = If[MatchQ[Lookup[roundedOptions,Site,Automatic],Automatic],
		parentProtocolSite,
		Lookup[roundedOptions,Site]
	];

	(* Keep track of any invalid cover options when calling ExperimentCover. *)
	invalidCoverOptions={};

	{
		(*1*)resolvedSourceLabels,
		(*2*)resolvedSourceContainerLabels,
		(*3*)resolvedSourceContainers,
		(*4*)resolvedSourceSampleGroupings,
		(*5*)resolvedDestinationLabels,
		(*6*)resolvedDestinationContainerLabels,
		(*7*)resolvedInstrument,
		(*8*)resolvedTransferEnvironment,
		(*9*)resolvedBalance,
		(*10*)resolvedTabletCrusher,
		(*11*)resolvedTips,
		(*12*)resolvedTipType,
		(*13*)resolvedTipMaterial,
		(*14*)resolvedReversePipetting,
		(*15*)resolvedSupernatant,
		(*16*)resolvedMagnetization,
		(*17*)resolvedMagnetizationTime,
		(*18*)resolvedMaxMagnetizationTime,
		(*19*)resolvedMagnetizationRack,
		(*20*)resolvedAspirationLayer,
		(*21*)resolvedNeedle,
		(*22*)resolvedFunnel,
		(*23*)resolvedWeighingContainer,
		(*24*)resolvedTolerance,
		(*25*)resolvedHandPump,
		(*26*)resolvedQuantitativeTransfer,
		(*27*)resolvedQuantitativeTransferWashSolution,
		(*28*)resolvedQuantitativeTransferWashVolume,
		(*29*)resolvedQuantitativeTransferWashInstrument,
		(*30*)resolvedQuantitativeTransferWashTips,
		(*31*)resolvedNumberOfQuantitativeTransferWashes,
		(*32*)resolvedUnsealHermeticSource,
		(*33*)resolvedUnsealHermeticDestination,
		(*34*)resolvedBackfillNeedle,
		(*35*)resolvedBackfillGas,
		(*36*)resolvedVentingNeedle,
		(*37*)resolvedTipRinse,
		(*38*)resolvedTipRinseSolution,
		(*39*)resolvedTipRinseVolume,
		(*40*)resolvedNumberOfTipRinses,
		(*41*)resolvedAspirationMix,
		(*42*)resolvedSlurryTransfer,
		(*43*)resolvedAspirationMixType,
		(*44*)resolvedNumberOfAspirationMixes,
		(*45*)resolvedMaxNumberOfAspirationMixes,
		(*46*)resolvedDispenseMix,
		(*47*)resolvedDispenseMixType,
		(*48*)resolvedNumberOfDispenseMixes,
		(*49*)resolvedPipettingMethod,
		(*50*)resolvedAspirationRate,
		(*51*)resolvedDispenseRate,
		(*52*)resolvedOverAspirationVolume,
		(*53*)resolvedOverDispenseVolume,
		(*54*)resolvedAspirationWithdrawalRate,
		(*55*)resolvedDispenseWithdrawalRate,
		(*56*)resolvedAspirationEquilibrationTime,
		(*57*)resolvedDispenseEquilibrationTime,
		(*58*)resolvedAspirationMixVolume,
		(*59*)resolvedDispenseMixVolume,
		(*60*)resolvedAspirationMixRate,
		(*61*)resolvedDispenseMixRate,
		(*62*)resolvedAspirationPosition,
		(*63*)resolvedDispensePosition,
		(*64*)resolvedAspirationPositionOffset,
		(*65*)resolvedDispensePositionOffset,
		(*66*)resolvedCorrectionCurve,
		(*67*)resolvedDynamicAspiration,
		(*68*)resolvedIntermediateDecant,
		(*69*)resolvedIntermediateContainer,
		(*70*)resolvedIntermediateFunnel,
		(*71*)resolvedSourceTemperature,
		(*72*)resolvedSourceEquilibrationTime,
		(*73*)resolvedMaxSourceEquilibrationTime,
		(*74*)resolvedSourceEquilibrationCheck,
		(*75*)resolvedDestinationTemperature,
		(*76*)resolvedDestinationEquilibrationTime,
		(*77*)resolvedMaxDestinationEquilibrationTime,
		(*78*)resolvedDestinationEquilibrationCheck,
		(*79*)resolvedCoolingTime,
		(*80*)resolvedSolidificationTime,
		(*81*)resolvedFlameDestination,
		(*82*)resolvedParafilmDestination,
		(*83*)resolvedSterileTechnique,
		(*84*)resolvedRNaseFreeTechnique,
		(*85*)resolvedKeepSourceCovered,
		(*86*)resolvedReplaceSourceCovers,
		(*87*)resolvedSourceCovers,
		(*88*)resolvedSourceSeptums,
		(*89*)resolvedSourceStoppers,
		(*90*)resolvedKeepDestinationCovered,
		(*91*)resolvedReplaceDestinationCovers,
		(*92*)resolvedDestinationCovers,
		(*93*)resolvedDestinationSeptums,
		(*94*)resolvedDestinationStoppers,
		(*95*)resolvedLivingDestinations,
		(* NOTE: For this option, we leave All alone. We only have this for rounding according to instrument precision. *)
		(*96*)resolvedAmount,
		(* this is a weird case where we're getting tests out of the MapThread*)
		(*97*)allResolvedCoverTests,
		(*98*)asepticHandlingSourceDestinationWarnings,
		(*99*)resolvedAllowSourceContainerReCovers,
		(*100*)volumePrecisionRoundQs,
		(* Sachet related option and error checkings*)
		(*101*)resolvedIncludeSachetPouch,
		(*102*)resolvedSachetIntermediateContainers,
		(*103*)resolvedHandlingCondition,
		(*104*)resolvedBalanceCleaningMethods,
		(*105*)resolvedEquivalentTransferEnvironments,
		(*106*)resolvedOverdrawVolume,
		(*107*)resolvedWeightStabilityDurations,
		(*108*)resolvedMaxWeightVariations,
		(*109*)resolvedTareWeightStabilityDurations,
		(*110*)resolvedMaxTareWeightVariations
	}=Transpose@MapThread[
		Function[{sourceObject, sourceContainerObject, sourceContainerModelObject, destinationObject, destinationContainerObject, destinationContainerModelObject, collectionContainerSample, sourceIsModelQ, amount, destinationIsWasteQ, options, manipulationIndex, sourceInput, destinationInput},
			Module[
				{
					sourcePacket, sourceContainerPacket, sourceContainerModelPacket, destinationPacket, destinationContainerPacket,incompatibleMaterialsDestinationContainer,
					destinationContainerModelPacket, workingSourceContainerModelPacket, collectionContainerSamplePacket, convertedAmount,tips,tipType,tipModelPacket,tipMaterial,needle,
					unsealHermeticSource, unsealHermeticDestination, backfillNeedle, backfillGas, ventingNeedle, tipRinse, tipRinseSolution,
					tipRinseVolume, numberOfTipRinses,aspirationMix,slurryTransfer, aspirationMixType, numberOfAspirationMixes, maxNumberOfAspirationMixes, dispenseMix,
					dispenseMixType, numberOfDispenseMixes, intermediateContainer,incompatibleMaterialsIntermediateContainer, intermediateDecant, convertedAmountAsVolume,destinationAperture, convertedAmountAsMass,allCompatibleSpatulas,idealSpatulasByCapacity,weighingContainerRequired, instrument, instrumentModel,weighingContainer, weighingContainerModel,semiResolvedQuantitativeTransferQ,semiResolvedQuantitativeTransferWashSolution, preresolvedBalanceModel, preresolvedBalanceModelMode,destinationContainerAperture,preresolvedWeighingContainersAndErrors,weighingFunnelError,weighBoatError,washSolutionIncompatibleMaterials,balance,balanceCleaningMethod, tolerance, handPump,
					reversePipetting, quantitativeTransfer, quantitativeTransferWashSolution, quantitativeTransferWashVolume,
					numberOfQuantitativeTransferWashes, validQuantitativeTransferWashTips,quantitativeTransferWashTips,quantitativeTransferWashTipsModel,validQuantitativeTransferWashInstrument, quantitativeTransferWashInstrument,quantitativeTransferWashInstrumentModel,
					destinationAmountAsVolume, sourceAmountAsVolume, workingDestinationContainerModelPacket, asepticHandlingSourceDestinationWarning,
					rnaseFreeTechnique,sterileTechnique,transferEnvironment,
					preResolvedSourceTemperature,sourceTemperature, sourceEquilibrationTime, maxSourceEquilibrationTime, sourceEquilibrationCheck,
					preResolvedDestinationTemperature, destinationTemperature, destinationEquilibrationTime, maxDestinationEquilibrationTime, coolingTime, solidificationTime, flameDestination, parafilmDestination, mnTransferQ,
					destinationEquilibrationCheck, sourceRoundedAmount, roundedAmount, volumePrecisionRoundQ, funnel, intermediateFunnel, pillCrusher, includeSachetPouch, sachetIntermediateContainer,
					cultureHandling, supernatant, aspirationLayer, maxMagnetizationTime, magnetizationTime, semiResolvedSterileTechnique,
					magnetization, magnetizationRack, sourceContainer, sourceSampleGrouping, sourceLabel, sourceContainerLabel, destinationLabel,
					destinationContainerLabel, compatibleBalanceModels, pipettingMethod, pipettingMethodObject, pipettingMethodPacket,
					aspirationRate, dispenseRate, overAspirationVolume, overDispenseVolume, aspirationWithdrawalRate, dispenseWithdrawalRate,
					aspirationEquilibrationTime, dispenseEquilibrationTime, aspirationMixVolume, dispenseMixVolume, aspirationMixRate, dispenseMixRate,
					aspirationPosition, dispensePosition, aspirationPositionOffset, dispensePositionOffset, correctionCurve, sortedCorrectionCurve, sortedActualValues,
					dynamicAspiration, keepSourceCovered, replaceSourceCover, sourceCover, sourceSeptum, sourceStopper, keepDestinationCovered,
					replaceDestinationCover, destinationCover, destinationSeptum, destinationStopper, livingDestination, allCoverTests, allCoverTests2, tipsSemiResolved,
					sourceContainerCover,allowSourceContainerReCover,intermediateContainerSemiResolved,workingSourceContainerModelPacketSemiResolved,
					resolveIntermediateContainer, semiResolvedHandlingConditions, semiResolvedTransferEnvironment, handlingConditions, transferEnvironmentResolutionStrings,
					equivalentTransferEnvironments, overdrawVolume, fumeHoodRequested, weightStabilityDuration, maxWeightVariation, modelDefaultMaxVariation, tareWeightStabilityDuration, maxTareWeightVariation,
					needBalanceQ, smallVolumeTransferQ
				},


				(* -- General Computations -- *)

				(* Lookup our most recent packet for the following input objects: *)
				(* NOTE: These change after every iteration. See the bottom of the MapThread. *)
				{sourcePacket, sourceContainerPacket, sourceContainerModelPacket, destinationPacket, destinationContainerPacket, destinationContainerModelPacket, collectionContainerSamplePacket} = MapThread[
					If[
						NullQ[#1],
						<||>,
						fetchPacketFromCache[#1,#2]
					]&,
					{
						{sourceObject, sourceContainerObject, sourceContainerModelObject, destinationObject, destinationContainerObject, destinationContainerModelObject, collectionContainerSample},
						{workingSourceSamplePackets, workingSourceContainerPackets, workingSourceContainerModelPackets, workingDestinationSamplePackets, workingDestinationContainerPackets, workingDestinationContainerModelPackets, workingCollectionContainerSamplePackets}
					}
				];

				(* figure out if we are doing MxN MultiProbeHead transfer *)
				mnTransferQ = And[
					MatchQ[resolvedPreparation, Robotic],
					MatchQ[Lookup[options, DeviceChannel], MultiProbeHead],
					Or[
						MatchQ[Lookup[options, MultiProbeHeadNumberOfRows], Except[8]],
						MatchQ[Lookup[options, MultiProbeHeadNumberOfColumns], Except[12]]
					]
				];

				(* Figure out our pipetting method packet. *)
				(* Use our option, if provided, or default from our source *)
				pipettingMethod=Which[
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[Lookup[options,PipettingMethod,Null],ObjectP[Model[Method, Pipetting]]],
						Lookup[options,PipettingMethod,Null],
					MatchQ[Lookup[sourcePacket, PipettingMethod], ObjectP[]],
						Lookup[sourcePacket, PipettingMethod],
					(* If we have a PipettingMethod in our Solvent field, use that. *)
					MatchQ[Lookup[sourcePacket, Solvent], ObjectP[]]&&MatchQ[Lookup[fetchPacketFromFastAssoc[Lookup[sourcePacket, Solvent], fastAssoc], PipettingMethod], ObjectP[Model[Method,Pipetting]]],
						Lookup[fetchPacketFromFastAssoc[Lookup[sourcePacket, Solvent], fastAssoc], PipettingMethod],
					(* If we have a PipettingMethod field in our Composition field, use that. *)
					KeyExistsQ[sourcePacket, Composition] && MemberQ[(Lookup[fetchPacketFromFastAssoc[#, fastAssoc]/.{Null->(<||>)}, PipettingMethod, Null]&)/@Cases[Lookup[sourcePacket, Composition][[All,2]], ObjectP[]], ObjectP[]],
						Module[{compositionAsObjects, compositionToAmountLookup, compositionToPipettingMethodLookup, filteredCompositionToPipettingMethodLookup},
							(* Get our composition molecules as objects. *)
							compositionAsObjects=Map[
								{First[#], Download[#[[2]], Object]}&,
								Lookup[sourcePacket, Composition]
							];

							(* Create a lookup between composition and amount. *)
							compositionToAmountLookup=Rule@@@(Reverse/@compositionAsObjects);

							(* Create a composition to PipettingMethod lookup. *)
							compositionToPipettingMethodLookup=(#->Lookup[fetchPacketFromFastAssoc[#, fastAssoc]/.{Null->(<||>)}, PipettingMethod]&)/@Cases[compositionAsObjects[[All,2]], ObjectP[]];

							(* Filter out composition with no pipetting method. *)
							filteredCompositionToPipettingMethodLookup=Cases[compositionToPipettingMethodLookup, Verbatim[Rule][_, ObjectP[]]];

							Which[
								(* If there is only one pipetting method, use that. *)
								Length[filteredCompositionToPipettingMethodLookup]==1,
									filteredCompositionToPipettingMethodLookup[[1]][[2]],
								(* If we have amounts, then use that to break ties. *)
								MemberQ[(Lookup[compositionToAmountLookup, #[[1]]]&)/@filteredCompositionToPipettingMethodLookup, UnitsP[]],
									SortBy[
										filteredCompositionToPipettingMethodLookup,
										(-1*(Lookup[compositionToAmountLookup, #[[1]]]/.{Null->0 VolumePercent})&)
									][[1]][[2]],
								(* Otherwise, take the first pipetting method that isn't just aqueous. *)
								MemberQ[Values[filteredCompositionToPipettingMethodLookup], Except[ObjectP[Model[Method, Pipetting, "id:qdkmxzqkJlw1"]]]],
									FirstCase[Values[filteredCompositionToPipettingMethodLookup], Except[ObjectP[Model[Method, Pipetting, "id:qdkmxzqkJlw1"]]]],
								(* Default to aqueous. *)
								True,
									Model[Method, Pipetting, "Aqueous"]
							]
						],
					True,
						Model[Method, Pipetting, "Aqueous"]
				];

				pipettingMethodObject=Download[pipettingMethod,Object];

				pipettingMethodPacket=fetchPacketFromFastAssoc[pipettingMethodObject, fastAssoc];

				(* Convert Amount to a Volume or Mass to work with internally. *)
				convertedAmount=Which[
					MatchQ[amount, All] && MatchQ[Lookup[sourcePacket, State], Liquid],
						(* Assume that the whole container is full, if the volume is Null. *)
						If[MatchQ[Lookup[sourcePacket, Volume], VolumeP],
							Lookup[sourcePacket, Volume],
							Lookup[sourceContainerModelPacket, MaxVolume]
						],
					(* Assume that the whole container is full, if the volume is Null. *)
					MatchQ[amount, All] && MatchQ[Lookup[sourcePacket, State], Solid],
						If[MatchQ[Lookup[sourcePacket, Mass], MassP],
							Lookup[sourcePacket, Mass],
							Lookup[sourceContainerModelPacket, MaxVolume] * Quantity[0.997`, ("Grams")/("Milliliters")] * 1.25
						],
					MatchQ[amount, All],
						If[MatchQ[Lookup[sourcePacket, Volume], VolumeP],
							Lookup[sourcePacket, Volume],
							Lookup[sourceContainerModelPacket, MaxVolume]
						],
					True,
						amount
				];

				(* If our amount is a mass, convert the mass to a volume. If we don't have a density, assume the density of water with a little buffer amount. *)
				convertedAmountAsVolume=If[MatchQ[convertedAmount, VolumeP],
					convertedAmount,
					Which[
						(* If sample is a tablet, and both SolidUnitWeight and Density are populated, use them to calculate expected volume *)
						MatchQ[convertedAmount, CountP] && MatchQ[Lookup[sourcePacket, SolidUnitWeight], MassP] && MatchQ[Lookup[sourcePacket, Density], DensityP],
							convertedAmount*Lookup[sourcePacket, SolidUnitWeight]/Lookup[sourcePacket, Density],
						(* If sample is a tablet, but Mass instead of SolidUnitWeight is populated, use mass instead *)
						MatchQ[convertedAmount, CountP] && MatchQ[Lookup[sourcePacket, Mass], MassP] && MatchQ[Lookup[sourcePacket, Density], DensityP],
							convertedAmount*Lookup[sourcePacket, Mass]/Lookup[sourcePacket, Density],
						(* If sample is a tablet, and either SolidUnitWeight or mass is populated but density is not, use a default density of 0.7976 g/ml (75% of water) *)
						MatchQ[convertedAmount, CountP] && MatchQ[Lookup[sourcePacket, SolidUnitWeight], MassP],
							(convertedAmount*Lookup[sourcePacket, SolidUnitWeight]/Quantity[0.997`, ("Grams")/("Milliliters")])*1.25,
						MatchQ[convertedAmount, CountP] && MatchQ[Lookup[sourcePacket, Mass], MassP],
							(convertedAmount*Lookup[sourcePacket, Mass]/Quantity[0.997`, ("Grams")/("Milliliters")])*1.25,
						(* If sample is a tablet but mass and SolidUnitWeight are both missing, then use default mass of 1g and default density of 0.7976 g/ml (75% of water) *)
						MatchQ[convertedAmount, CountP],
							(convertedAmount*1 Gram/Quantity[0.997`, ("Grams")/("Milliliters")])*1.25,
						(* Otherwise, amount is represented by mass and we need to look up sample density to calculate volume *)
						MatchQ[Lookup[sourcePacket, Density], DensityP],
							convertedAmount/Lookup[sourcePacket, Density],
						(* Finally, if density is not available, use default value 0.7976 g/ml (75% of water) *)
						True,
							(convertedAmount/Quantity[0.997`, ("Grams")/("Milliliters")]) * 1.25
					]
				];

				(* If our amount is a volume, convert the volume to mass. If we don't have a density, assume the density of water with a little buffer amount. *)
				convertedAmountAsMass=If[MatchQ[convertedAmount, MassP],
					convertedAmount,
					Which[
						MatchQ[convertedAmount, CountP] && MatchQ[Lookup[sourcePacket, SolidUnitWeight], MassP],
							convertedAmount*Lookup[sourcePacket, SolidUnitWeight],
						MatchQ[convertedAmount, CountP],
							convertedAmount*1 Gram,
						MatchQ[Lookup[sourcePacket, Density], DensityP],
							convertedAmount*Lookup[sourcePacket, Density],
						True,
							(convertedAmount*Quantity[0.997`, ("Grams")/("Milliliters")]) * 1.25
					]
				];

				(* Convert the current mass of the source into a volume. *)
				sourceAmountAsVolume=Which[
					MatchQ[Lookup[sourcePacket, Volume], VolumeP],
						Lookup[sourcePacket, Volume],
					MatchQ[Lookup[sourcePacket, Mass], MassP],
						If[MatchQ[Lookup[sourcePacket, Density], DensityP],
							Lookup[sourcePacket, Mass]/Lookup[sourcePacket, Density],
							(Lookup[sourcePacket, Mass]/Quantity[0.997`, ("Grams")/("Milliliters")]) * 1.25
						],
					(* Assume that the whole container is full, if the volume is Null. *)
					True,
						Lookup[sourceContainerModelPacket, MaxVolume]
				];

				(* Convert the current mass of the destination into a volume. *)
				destinationAmountAsVolume=Which[
					MatchQ[Lookup[destinationPacket, Volume], VolumeP],
						Lookup[destinationPacket, Volume],
					MatchQ[Lookup[destinationPacket, Mass], MassP],
						If[MatchQ[Lookup[destinationPacket, Density], DensityP],
							Lookup[destinationPacket, Mass]/Lookup[destinationPacket, Density],
							(Lookup[destinationPacket, Mass]/Quantity[0.997`, ("Grams")/("Milliliters")]) * 1.25
						],
					(* If the volume is Null, assume the sample has negligible volume *)
					True,
						0 Liter
				];

				(* semi-resolve the sterile technique option *)
				(* culture handling will get resolved based partially on the SterileTechnique option *)
				(* some stuff we use to resolve sterile technique doesn't relate to any other options so we should get those out of the way early *)
				semiResolvedSterileTechnique = Which[
					MatchQ[Lookup[options, SterileTechnique], Except[Automatic]],
						Lookup[options, SterileTechnique],

					(* If we're dealing with cells (of any type) in our source or destination samples, use sterile technique. *)
					MemberQ[Flatten[{Lookup[sourcePacket, Composition], Lookup[destinationPacket, Composition]}], ObjectP[Model[Cell]]],
						True,

					(* If the user has told us to use a BSC, use sterile technique. *)
					MatchQ[Lookup[options, TransferEnvironment], ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
						True,

					(* If we're on the bioSTAR/microbioSTAR, we should use sterile technique. *)
					MatchQ[resolvedWorkCell, bioSTAR|microbioSTAR],
						True,

					(* If we're on the STARlet or SuperSTAR, we should not use sterile technique. *)
					MatchQ[resolvedWorkCell, STAR],
						False,


					(* if either the source or destination(preexisting) is sterile, then use sterile technique *)
					(* Note:if we have a simulated sample in destination container, we do not have Composition. We do not care in this case if the simulated sample is sterile or not *)
					TrueQ[Lookup[sourcePacket, Sterile]] || (TrueQ[Lookup[destinationPacket, Sterile]] && MemberQ[Flatten@Lookup[destinationPacket, Composition], ObjectP[]]),
						True,

					(* if either the source or destination(preexisting) is AsepticHandling, then use sterile technique *)
					(* Note:if we have a simulated sample in destination container, we do not have Composition. We do not care in this case if the simulated sample is aseptic handling or not *)
					TrueQ[Lookup[sourcePacket, AsepticHandling]] || (TrueQ[Lookup[destinationPacket, AsepticHandling]] && MemberQ[Flatten@Lookup[destinationPacket, Composition], ObjectP[]]),
						True,

					(* Otherwise, leave it at Automatic. *)
					True,
						Automatic
				];

				(* Figure out what kind of CultureHandling we should be using. *)
				cultureHandling = resolveCultureHandling[sourcePacket, destinationPacket, ReplaceRule[Normal[options, Association], SterileTechnique -> semiResolvedSterileTechnique]];

				(* -- Resolve Label Related Options -- *)

				(* We don't need to give these options labels automatically, unless we're in the work cell resolver. *)
				(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
				(* labels if we have duplicates. *)
				sourceLabel=Which[
					MatchQ[Lookup[options, SourceLabel], Except[Automatic]],
						Lookup[options, SourceLabel],
					MatchQ[simulation, SimulationP] && MatchQ[sourceObject, ObjectP[]] && MatchQ[LookupObjectLabel[simulation, Download[sourceObject, Object]], _String],
						LookupObjectLabel[simulation, Download[sourceObject, Object]],
					KeyExistsQ[objectToNewResolvedLabelLookup, sourceObject],
						Lookup[objectToNewResolvedLabelLookup, sourceObject],
					True,
						Module[{newLabel},
							newLabel=CreateUniqueLabel["transfer source sample"];

							AppendTo[objectToNewResolvedLabelLookup, sourceObject->newLabel];

							newLabel
						]
				];
				sourceContainerLabel=Which[
					MatchQ[Lookup[options, SourceContainerLabel], Except[Automatic]],
						Lookup[options, SourceContainerLabel],
					MatchQ[simulation, SimulationP] && MatchQ[sourceContainerObject, ObjectP[]] && MatchQ[LookupObjectLabel[simulation, Download[sourceContainerObject, Object]], _String],
						LookupObjectLabel[simulation, Download[sourceContainerObject, Object]],
					KeyExistsQ[objectToNewResolvedLabelLookup, sourceContainerObject],
						Lookup[objectToNewResolvedLabelLookup, sourceContainerObject],
					True,
						Module[{newLabel},
							newLabel=CreateUniqueLabel["transfer source container"];

							AppendTo[objectToNewResolvedLabelLookup, sourceContainerObject->newLabel];

							newLabel
						]
				];
				destinationContainerLabel=Which[
					MatchQ[Lookup[options, DestinationContainerLabel], Except[Automatic]],
						Lookup[options, DestinationContainerLabel],
					MatchQ[simulation, SimulationP] && MatchQ[destinationContainerObject, ObjectP[]] && MatchQ[LookupObjectLabel[simulation, Download[destinationContainerObject, Object]], _String],
						LookupObjectLabel[simulation, Download[destinationContainerObject, Object]],
					KeyExistsQ[objectToNewResolvedLabelLookup, destinationContainerObject],
						Lookup[objectToNewResolvedLabelLookup, destinationContainerObject],
					True,
						Module[{newLabel},
							newLabel=CreateUniqueLabel["transfer destination container"];

							AppendTo[objectToNewResolvedLabelLookup, destinationContainerObject->newLabel];

							newLabel
						]
				];

				(* We need to give our destination a label automatically since it will be used to autofill the input *)
				(* for the next primitive, whether we're in Manual or Robotic. *)
				destinationLabel=Which[
					MatchQ[Lookup[options, DestinationLabel], Except[Automatic]],
						Lookup[options, DestinationLabel],
					MatchQ[simulation, SimulationP] && MatchQ[destinationObject, ObjectP[]] && MatchQ[LookupObjectLabel[simulation, Download[destinationObject, Object]], _String],
						LookupObjectLabel[simulation, Download[destinationObject, Object]],
					KeyExistsQ[objectToNewResolvedLabelLookup, destinationObject],
						Lookup[objectToNewResolvedLabelLookup, destinationObject],
					True,
						Module[{newLabel},
							newLabel=CreateUniqueLabel["transfer destination sample"];

							AppendTo[objectToNewResolvedLabelLookup, destinationObject->newLabel];

							newLabel
						]
				];

				(* -- Resolve Transfer Environment -- *)
				(* Final SourceTemperature/DestinationTemperature need to consider resolved TransferEnvironment *)
				(* This part uses partial logic from later resolution *)
				preResolvedSourceTemperature=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, SourceTemperature], Except[Automatic]],
					Lookup[options, SourceTemperature],
					(* Is the TransferTemperature field set in the sample? *)
					MatchQ[Lookup[sourcePacket, TransferTemperature], TemperatureP],
					Lookup[sourcePacket, TransferTemperature],
					(* Otherwise, set to Ambient. *)
					True,
					Ambient
				];
				preResolvedDestinationTemperature=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, DestinationTemperature], Except[Automatic]],
					Lookup[options, DestinationTemperature],
					(* Is the TransferTemperature field set in the sample? *)
					MatchQ[Lookup[destinationPacket, TransferTemperature], TemperatureP],
					Lookup[destinationPacket, TransferTemperature],
					(* Otherwise, set to Ambient. *)
					True,
					Ambient
				];

				(* a variable to store a list of strings that states how the HandlingStation/TransferEnvironment is resolved *)
				transferEnvironmentResolutionStrings = {};

				(* --- Resolve handling condition --- *)
				semiResolvedHandlingConditions = Module[{potentialHandlingConditionModelPackets, sterileKey, bscRequested, gloveBoxKey, gloveBoxRequested, hermeticTransferKey, fumeHoodKey, backfillRequested, irProbeKey, balanceKey},

					(* if we are doing robotic, early return empty list *)
					If[MatchQ[resolvedPreparation, Robotic], Return[{}, Module]];

					(* if we have a list of HandlingCondition being passed down, that means we are being called inside MSP, just use that value directly without doing any additional check, we've done it already *)
					(* this is a hidden option so in theory there is no way user would have provided this value *)
					If[MatchQ[Lookup[options, HandlingCondition], Except[Automatic]], ToList[Lookup[options, HandlingCondition]]];

					(* we already sort these so the first is supposedly the most "common/easily accessible" handling condition *)
					potentialHandlingConditionModelPackets = Which[
						(* if user gives us a handling station already, limit the potential handling conditions to its Model's ProvidedHandlingConditions *)
						MatchQ[Lookup[options, TransferEnvironment], ObjectP[Object[Instrument, HandlingStation]]],
							handlingConditionSort[fastAssocPacketLookup[fastAssoc, Lookup[options, TransferEnvironment], {Model, ProvidedHandlingConditions}]],
						(* if user gives us a handling station Model already, limit the potential handling conditions to its ProvidedHandlingConditions *)
						MatchQ[Lookup[options, TransferEnvironment], ObjectP[Model[Instrument, HandlingStation]]],
							handlingConditionSort[fastAssocPacketLookup[fastAssoc, Lookup[options, TransferEnvironment], ProvidedHandlingConditions]],
						(* if we are doing TC culture, we hard code to use a BSC handling station model 1 *)
						MatchQ[cultureHandling, NonMicrobial],
							(* Model[Instrument, HandlingStation, "Biosafety Cabinet Handling Station for Tissue Culture"] *)
							handlingConditionSort[fastAssocPacketLookup[fastAssoc, Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"], ProvidedHandlingConditions]],
						(* if we are doing microbial culture handling, we hard code to use a BSC handling station model 2 *)
						MatchQ[cultureHandling, Microbial] || MatchQ[destinationIsWasteQ, True],
							(* Model[Instrument, HandlingStation, "Biosafety Cabinet Handling Station for Microbiology"] *)
							handlingConditionSort[fastAssocPacketLookup[fastAssoc, Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"], ProvidedHandlingConditions]],
						(* if we are not specifying CultureHandling but doing generial sterile technique, we hard code to use a BSC handling station model 3 *)
						NullQ[cultureHandling] && TrueQ[semiResolvedSterileTechnique],
							(* Model[Instrument, HandlingStation, "Biosafety Cabinet Handling Station with Analytical Balance"] *)
							handlingConditionSort[fastAssocPacketLookup[fastAssoc, Model[Instrument, HandlingStation, BiosafetyCabinet, "id:XnlV5jNYpXYP"], ProvidedHandlingConditions]],
						True,
							allHandlingConditionModelPackets
					];

					(* DO NOT use sterile environment unless we really need one *)
					{sterileKey, bscRequested} = If[
						And[
							!MatchQ[cultureHandling, NonMicrobial],
							!(MatchQ[cultureHandling, Microbial] || MatchQ[destinationIsWasteQ, True]),
							!(NullQ[cultureHandling] && TrueQ[semiResolvedSterileTechnique])
						],
						{{AsepticTechniqueEnvironment -> False}, False},
						(
							AppendTo[transferEnvironmentResolutionStrings, "sterile environment (such as a BiosafetyCabinet)"];
							{{AsepticTechniqueEnvironment -> True}, True}
						)
					];

					(* need glovebox if we are dealing a solid Pyrophoric sample or a source/destination that is marked InertHandling->True *)
					{gloveBoxKey, gloveBoxRequested} = If[
						(* Are we dealing a solid Pyrophoric sample or a source/destination that is marked InertHandling->True? *)
						Or[
							And[
								MatchQ[Lookup[sourcePacket, Pyrophoric], True],
								MatchQ[Lookup[sourcePacket, State], Solid]
							],
							MatchQ[Lookup[sourcePacket, InertHandling], True],
							(* need glovebox environment if transfer environment is specified to be a glovebox! *)
							MatchQ[Lookup[options, TransferEnvironment], ObjectP[{Object[Instrument, HandlingStation, GloveBox], Model[Instrument, HandlingStation, GloveBox]}]]
						],
						(
							AppendTo[transferEnvironmentResolutionStrings, "inert Handling Atmosphere"];
							{{HandlingAtmosphere -> Nitrogen | Argon}, True}
						),
						{{HandlingAtmosphere -> Ambient}, False}
					];

					(* need backfilling/venting if we are dealing with hermetic containers and we are not unsealing them *)
					{hermeticTransferKey, backfillRequested} = Which[
						(* if back fill gas is specified, look for the environment that can do backfilling with that gas  *)
						MatchQ[Lookup[options, BackfillGas], Except[Automatic | NullP]],
							(
								AppendTo[transferEnvironmentResolutionStrings, "backfilling gas (for sealing hermetic containers)"];
								{{(Lookup[options, BackfillGas] /. {Argon -> ArgonHermeticTransfer, Nitrogen -> NitrogenHermeticTransfer}) -> True}, True}
							),
						(* otherwise either nitrogen or argon backfilling is okay *)
						(* we NEED a hermetic container if we are explictly specifying to NOT UnsealHermeticSource/UnsealHermeticDestination *)
						Or[
							And[
								MatchQ[Lookup[sourceContainerPacket, Hermetic], True],
								MatchQ[Lookup[options, UnsealHermeticSource], False]
							],
							And[
								MatchQ[Lookup[destinationContainerPacket, Hermetic], True],
								MatchQ[Lookup[options, UnsealHermeticDestination], False]
							]
						],
							(
								AppendTo[transferEnvironmentResolutionStrings, "backfilling gas (for sealing hermetic containers)"];
								{{(NitrogenHermeticTransfer | ArgonHermeticTransfer) -> True}, True}
							),
						True,
							{{}, False}
					];

					(* need ventilation if any sample requires fuming/ventilated explicitly *)
					{fumeHoodKey, fumeHoodRequested} = If[
						And[
							Or[
								(* NOTE: Fuming is the safety field. Ventilated is the field that lets the user tell us they want it handled in a FumeHood. *)
								MatchQ[Lookup[sourcePacket, Fuming], True],
								MatchQ[Lookup[destinationPacket, Fuming], True],

								(* TODO: Migrate the Ventilated field to be called VentilatedHandling. *)
								MatchQ[Lookup[sourcePacket, Ventilated], True],
								MatchQ[Lookup[destinationPacket, Ventilated], True],
								
								(* if user provides a ventilated/fuming quantitative wash solution, we need to use a fumehood too *)
								(* our default solution is water for now so need to check that along with the quantitative resolution *)
								TrueQ[fastAssocLookup[fastAssoc, Lookup[options, QuantitativeTransferWashSolution], Fuming]],
								TrueQ[fastAssocLookup[fastAssoc, Lookup[options, QuantitativeTransferWashSolution], Ventilated]],

								(* if user provides a ventilated/fuming tip rinse solution, we need to use a fumehood too *)
								(* our default solution is water for now so need to check that along with the tip rinse resolution *)
								TrueQ[fastAssocLookup[fastAssoc, Lookup[options, TipRinseSolution], Fuming]],
								TrueQ[fastAssocLookup[fastAssoc, Lookup[options, TipRinseSolution], Ventilated]],

								(* currently, we only have backfill gas lines in fumehood, so have to request fumehood if we are requesting Hermetic transfer *)
								TrueQ[backfillRequested]
							],
							(* if we already requested a glovebox, then no need to try to search for a fumehood, since we should be good to handle fuming and ventilated sample inside a glovebox right? or can we? *)
							!TrueQ[gloveBoxRequested],
							(* if we already request a TC hood, no need to try to search for a fumehood *)
							!TrueQ[bscRequested]
						],
						(
							AppendTo[transferEnvironmentResolutionStrings, "ventilation (FumeHood)"];
							{{MinVolumetricFlowRate -> FumeHoodVolumetricFlowRateP}, True}
						),
						(* we cannot exclude fumehood just yet since we are not sure if we need backfill gas lines or not *)
						{{}, False}
					];

					(* need IR probe if we are doing FTV into a Volumetric flask *)
					irProbeKey = If[
						Or[
							MatchQ[preResolvedSourceTemperature, TemperatureP],
							MatchQ[preResolvedDestinationTemperature, TemperatureP],
							(* Are we doing FTV into a VolumetricFlask? If so, set IRProbe to True so we can use it to ensure we are 18-28C during transfer to VolFlask *)
							And[
								(MatchQ[Lookup[options, FillToVolume], True] || MatchQ[Lookup[options, ParentProtocol], ObjectP[Object[Protocol, FillToVolume]]]),
								MatchQ[destinationContainerModelPacket, ObjectP[{Model[Container, Vessel, VolumetricFlask], Object[Container, Vessel, VolumetricFlask]}]]
							]
						],
						(
							AppendTo[transferEnvironmentResolutionStrings, "IRProbe temperature monitoring"];
							{IRProbe -> True}
						),
						{}
					];

					(* balance requirement, we cannot really resolve balance up front since they are convoluted with the transfer environments, so we will semiresolve and return a list for now *)
					balanceKey = If[MatchQ[Lookup[options, Balance], ObjectP[{Object[Instrument, Balance], Model[Instrument, Balance]}]],
						Module[{balanceType},
							(* get the balance type for sure from its model *)
							balanceType = If[MatchQ[Lookup[options, Balance], ObjectP[Object[Instrument, Balance]]],
								fastAssocLookup[fastAssoc, Lookup[options, Balance], {Model, Mode}],
								fastAssocLookup[fastAssoc, Lookup[options, Balance], Mode]
							];
							AppendTo[transferEnvironmentResolutionStrings, ToString[balanceType]];
							{BalanceType -> _?(MemberQ[#, balanceType]&)}
						],
						{}
					];

					(* now try to find all handling conditions that meet all the requirements we have resolved, we return this list as the semi-resolved handling condition, until balance is resolved we can fully resolve this *)
					Lookup[
						Cases[
							potentialHandlingConditionModelPackets,
							KeyValuePattern[Flatten[{sterileKey, gloveBoxKey, hermeticTransferKey, fumeHoodKey, irProbeKey, balanceKey}]]
						],
						Object,
						{}
					]
				];

				(* -- Resolve Transfer Environment -- *)
				semiResolvedTransferEnvironment = Which[
					(* if we are provided with a list of EquivalentTransferEnvironments, this means we are being called inside MSP, just fast track taking these values *)
					MatchQ[Lookup[options, EquivalentTransferEnvironments], Except[Automatic]],
						ToList[Lookup[options, EquivalentTransferEnvironments]],

					(* Did the user give us a transfer environment object? *)
					MatchQ[Lookup[options, TransferEnvironment], ObjectP[{Object[Instrument, HandlingStation], Model[Instrument, HandlingStation]}]],
						Lookup[options, TransferEnvironment],

					(* No TransferEnvironment when Robotic. *)
					MatchQ[resolvedPreparation, Robotic],
						Null,

					(* Is Balance specified as an object? we should just resolve to the handling station that has that balance on it directly *)
					(* NOTE: if balance is already specified as a model, we will do the filtering later after we resolve the balance *)
					MatchQ[Lookup[options, Balance], ObjectP[Object[Instrument, Balance]]],
						(* If we have balance specified as object, then resolve to the HandlingStation with the balance in it. The lookup is memoized so it should not be too bad *)
						Lookup[Lookup[balanceHandlingStationLookup["Memoization"], Download[Lookup[options, Balance], Object], <||>], "Object", {}],

					(* from the semi resolved handling conditions, get the potential transfer environments temporarily *)
					True,
						getHandlingStations[semiResolvedHandlingConditions]
				];

				(* -- Resolve Technique Options -- *)
				(* for SterileTechnique, we will have done most of the checks already above; all we need to do extra here is to incorporate new information based on the resolved transfer environment *)
				sterileTechnique = Which[
					MatchQ[semiResolvedSterileTechnique, Except[Automatic]],
						semiResolvedSterileTechnique,

					(* If the user or previous resolution has told us to choose a sterile environment, do so *)
					MatchQ[fastAssocLookup[fastAssoc, #, AsepticTechniqueEnvironment]& /@ semiResolvedHandlingConditions, {True..}],
						True,

					(* Otherwise, no sterile technique. *)
					True,
						False
				];

				(* If Source is sterile or AsepticHandling->True, but destination is not *)
				(* Note: it is okay if source is sterile, but destination is not sterile but AsepticHandling->True *)
				(* This is the case where destination contains microbial cell samples (sterile is not True) but still handled with aseptic handling *)
				asepticHandlingSourceDestinationWarning = And[
					TrueQ[Lookup[sourcePacket, AsepticHandling]] || TrueQ[Lookup[sourcePacket, Sterile]],
					(* If destination has preexisting sample with Sterile and AsepticHandling field, check values. *)
					Or[
						And[
							MemberQ[Flatten@Lookup[destinationPacket, Composition], ObjectP[]],
							Not[TrueQ[Lookup[destinationPacket, AsepticHandling]]],
							Not[TrueQ[Lookup[destinationPacket, Sterile]]]
						],
						(* If destination is a container with a simulated sample, we check the fields from the container packet *)
						(* Note:historically, we do not track AsepticHandling field of container, Null indicates the container does not require AsepticHandling. *)
						And[
							!MemberQ[Lookup[Flatten[containerAndSamplePacketForContainersWithIndices[[All, 2]]], Object], ObjectP[Lookup[destinationPacket, Object]]],
							!MemberQ[Flatten@Lookup[destinationPacket, Composition], ObjectP[]],
							Not[TrueQ[Lookup[destinationContainerPacket, Sterile]]] && Not[TrueQ[Lookup[destinationContainerPacket, AsepticHandling]]]
						],
						(* If destination is a simulated container with a simulated sample, we check the field Sterile from the container model packet *)
						(* AsepticHandling does not exist in Model[Container]. *)
						And[
							TrueQ[Lookup[destinationContainerPacket, Simulated]],
							!MemberQ[Flatten@Lookup[destinationPacket, Composition], ObjectP[]],
							Not[TrueQ[Lookup[destinationContainerModelPacket, Sterile]]]
						]
					]
				];

				rnaseFreeTechnique=Which[
					MatchQ[Lookup[options, RNaseFreeTechnique], Except[Automatic]],
						Lookup[options, RNaseFreeTechnique],

					(* If our samples are RNaseFree, we probably want to use RNaseFreeTechnique. *)
					MatchQ[Lookup[sourcePacket, RNaseFree], True] || MatchQ[Lookup[destinationPacket, RNaseFree], True],
						True,

					(* Otherwise no. *)
					True,
						False
				];

				If[MatchQ[ECL`$UnitTestObject, _ECL`Object],
					Echo[convertedAmountAsVolume,"convertedAmountAsVolume"];
					Echo[TransferDevices[Model[Item, Tips], All],"TransferDevices[Model[Item, Tips], All]"];
				];

				(* Resolve OverAspirationVolume. *)
				overAspirationVolume=Which[
					MatchQ[Lookup[options, OverAspirationVolume], Except[Automatic]],
						Lookup[options, OverAspirationVolume],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, OverAspirationVolume], Except[Null]],
						Lookup[pipettingMethodPacket, OverAspirationVolume],
					(* "10 uL Hamilton tips, non-sterile", "10 uL Hamilton barrier tips, sterile" *)
					MatchQ[tips, ObjectP[{Model[Item, Tips, "id:vXl9j5qEnnV7"], Model[Item, Tips, "id:P5ZnEj4P884r"]}]],
						0 Microliter,
					True,
						5 Microliter
				];

				(* Resolve OverDispenseVolume. *)
				overDispenseVolume=Which[
					MatchQ[Lookup[options, OverDispenseVolume], Except[Automatic]],
						Lookup[options, OverDispenseVolume],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, OverDispenseVolume], Except[Null]],
						Lookup[pipettingMethodPacket, OverDispenseVolume],
					MatchQ[Lookup[options, OverAspirationVolume], Except[Automatic]],
						Lookup[options, OverAspirationVolume],
					(* "10 uL Hamilton tips, non-sterile", "10 uL Hamilton barrier tips, sterile" *)
					MatchQ[tips, ObjectP[{Model[Item, Tips, "id:vXl9j5qEnnV7"], Model[Item, Tips, "id:P5ZnEj4P884r"]}]],
						0 Microliter,
					True,
						5 Microliter
				];

				(* Resolve CorrectionCurve. *)
				correctionCurve=Which[
					MatchQ[Lookup[options, CorrectionCurve], Except[Automatic]],
						Lookup[options, CorrectionCurve],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, CorrectionCurve], Except[Null]],
						Round[Lookup[pipettingMethodPacket, CorrectionCurve],0.01 Microliter],
					True,
						Null
				];

				(* Sort curve by target volume values *)
				sortedCorrectionCurve=SortBy[correctionCurve/.{Null->{}}, First];

				(* Sort only actual values *)
				sortedActualValues=Sort[(correctionCurve/.{Null->{}})[[All, 2]]];

				(* Check for problems with correction curve *)
				If[!NullQ[correctionCurve]&&!MatchQ[sortedActualValues, sortedCorrectionCurve[[All, 2]]],
					AppendTo[monotonicCorrectionCurveWarnings,{correctionCurve,manipulationIndex}]
				];

				If[!NullQ[correctionCurve]&&(!MatchQ[LastOrDefault[sortedCorrectionCurve], {GreaterEqualP[1000Microliter],_}]||!MatchQ[FirstOrDefault[sortedCorrectionCurve], {EqualP[0Microliter],_}]),
					AppendTo[incompleteCorrectionCurveWarnings,{correctionCurve,manipulationIndex}]
				];

				If[!NullQ[correctionCurve]&&(MatchQ[FirstOrDefault[sortedCorrectionCurve], {EqualP[0Microliter],Except[EqualP[0Microliter]]}]),
					AppendTo[invalidZeroCorrectionErrors,{sortedActualValues[[1,2]],manipulationIndex}]
				];

				(* abstract a shared helper to resolve a intermediate container if we are decanting since we may need to call it twice, also memoize it so it only evaluates once tho *)
				(* All of our preferred containers can support pipette access. *)
				(* NOTE: A 2mL Tube is the smallest tube that we allow for an intermediate container because pouring into a *)
				(* smaller container than this is unwieldy. Ideally, we would like to allow pouring into a 50mL tube but some *)
				(* of the more precise tips like Model[Item, Tips, "0.1 - 10 uL Tips, Low Retention, Non-Sterile"] cannot reach *)
				(* the bottom of a 50mL tube. *)
				resolveIntermediateContainer[myVolume_] := Set[
					resolveIntermediateContainer[myVolume],
					Module[{recommendedTransferOutVolume, preferredContainers, potentialGraduatedContainerModelPackets, sortedGraduatedContainers},
						(* we are adding a 10% buffer again for the volume to be transferred out from source *)
						recommendedTransferOutVolume = myVolume * 1.1;

						(* get the preferred containers with All->True so it returns a list of recommended container models *)
						(*check the source container in case we are trying to pour into a very small container from a very large bottle*)
						(*we will check tipsCanAspirateQ later on, so we will want to put anything where the source volume < 10 mL into a smaller tube*)
						(*this should be ok since with a smaller volume it will be possible to pour with control. The minimum amount can be enforced in the procedure for decants into 50 mL tubes*)
						(* this will keep the result of tipsCanAspirateQ in line with reality *)
						(* we also always want to pick up a container that has graduation lines so operator can know the level roughly when they pour *)
						preferredContainers = If[MatchQ[recommendedTransferOutVolume, LessEqualP[1.9 Milliliter]],

							If[MatchQ[Lookup[sourceContainerModelPacket, MaxVolume], GreaterEqualP[1 Liter]],
								PreferredContainer[50 Milliliter, IncompatibleMaterials -> Lookup[sourcePacket, IncompatibleMaterials], Sterile -> sterileTechnique, All -> True],
								PreferredContainer[1.9 Milliliter, IncompatibleMaterials -> Lookup[sourcePacket, IncompatibleMaterials], Sterile -> sterileTechnique, All -> True]
							],
							PreferredContainer[recommendedTransferOutVolume, IncompatibleMaterials -> Lookup[sourcePacket, IncompatibleMaterials], Sterile -> sterileTechnique, All -> True]
						];

						(* find all graduated containers that: *)
						potentialGraduatedContainerModelPackets = Select[
							allGraduatedContainerModelPackets,
							(* the largest graduation is greater or equal to the transfer volume *)
							GreaterEqualQ[
								Max[Lookup[#, Graduations]],
								recommendedTransferOutVolume
							]&
						];

						(* then we sort the filtered graduated container from small to large size orders *)
						sortedGraduatedContainers = If[MatchQ[potentialGraduatedContainerModelPackets, {}],
							{},
							Lookup[SortBy[
								potentialGraduatedContainerModelPackets,
								{
									(* the container size as small as possible *)
									(Lookup[#, MaxVolume]&),
									(* then resolution as precise as possible *)
									(Lookup[#, Resolution] /. {Null -> Infinity Microliter}&)
								}
							], Object]
						];

						(* if we can find a container that is both graduated and also preferred container, just use that *)
						If[Length[UnsortedIntersection[preferredContainers, sortedGraduatedContainers]] > 0,
							First[UnsortedIntersection[preferredContainers, sortedGraduatedContainers]],
							(* otherwise, default to the first preferred container in which case is likely, not having a graduation line *)
							(* this branch can happen if we unfortunately have some incompatible material/sterile requirements that just rule out some graduated container models out *)
							First[preferredContainers]
						]
					]
				];

				(* semi resolve the intermediate container *)
				intermediateContainerSemiResolved = Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, IntermediateContainer], Except[Automatic]],
						Lookup[options, IntermediateContainer],
					(* If we are decanting, pick a container that can support the volume of our sample. *)
					MatchQ[Lookup[options, IntermediateDecant], True],
						resolveIntermediateContainer[convertedAmountAsVolume],
					(* We are not decanting or we do not know yet, leave it Automatic *)
					True,
						Automatic
				];

				(* update the working source container based on the semi resolved intermediate container *)
				workingSourceContainerModelPacketSemiResolved = Which[
					MatchQ[intermediateContainerSemiResolved, ObjectP[Object[Container]]],
						fastAssocPacketLookup[fastAssoc, intermediateContainerSemiResolved, Model],
					MatchQ[intermediateContainerSemiResolved, ObjectP[Model[Container]]],
						fetchPacketFromFastAssoc[intermediateContainerSemiResolved, fastAssoc],
					True,
						sourceContainerModelPacket
				];

				(* -- Resolve Instrument Auxillary Options -- *)
				tipsSemiResolved = Which[
					(* User has already specified the tips. *)
					!MatchQ[Lookup[options, Tips], Automatic],
						Lookup[options, Tips],

					(* we are doing FTV into a VolumetricFlask - no tips required unless specified from ExperimentFTV*)
					(MatchQ[Lookup[options, FillToVolume], True] || MatchQ[Lookup[options, ParentProtocol], ObjectP[Object[Protocol, FillToVolume]]]) && !MatchQ[Lookup[options,FillToVolumeOverfillingRepreparation, False],True] && MatchQ[destinationContainerModelPacket, ObjectP[{Model[Container, Vessel, VolumetricFlask], Object[Container, Vessel, VolumetricFlask]}]],
						Null,

					(* User has specified (1) a needle, (2) a water purifier, (3) has set the instrument to something other than a pipette *)
					(* or (4) we are transferring All, are in a vessel, are not doing sterile technique, and not transfering supernatant (we should pour), AND the user hasn't *)
					(* specified that we use tips *)
					And[
						Or[
							MatchQ[Lookup[options, Needle], Except[Automatic | Null]],
							And[
								(* If we should use a water purifier, we must use a graduated cylinder. *)
								(* NOTE: We will only use a graduated cylinder if we are collecting water once. *)
								MatchQ[Length[Cases[simulatedSources, ObjectReferenceP[Model[Sample, "id:8qZ1VWNmdLBD"]]]], 1],
								MatchQ[sourceIsModelQ, True],
								MatchQ[Lookup[sourcePacket, Model][Object], ObjectReferenceP[Model[Sample, "id:8qZ1VWNmdLBD"]]],
								MatchQ[Lookup[options, {ReversePipetting, Needle, WeighingContainer, BackfillNeedle, BackfillGas, VentingNeedle, TipRinse, TipRinseSolution, TipRinseVolume, NumberOfTipRinses}], {(Automatic | Null)..}],
								(* NOTE: The smallest graduated cylinder has a min of 3mL but we want to default to using serological pipettes when possible *)
								(* and the max volume of a serological pipette is 50mL. *)
								MatchQ[convertedAmountAsVolume, GreaterP[50 Milliliter]]
							],
							MatchQ[Lookup[options, Instrument], Except[Automatic | ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette], Model[Instrument, Aspirator], Object[Instrument, Aspirator]}]]],
							And[
								MatchQ[amount, All],
								MatchQ[workingSourceContainerModelPacketSemiResolved, PacketP[Model[Container, Vessel]]],
								(* NOTE: We NEED tips if we're using an aspirator to transfer into waste. *)
								!MatchQ[destinationIsWasteQ, True],
								(* NOTE: We should not be pouring if we're trying to transfer the supernatant. *)
								!MatchQ[Lookup[options, Supernatant], True],
								(* NOTE: We should not be pouring if we are trying to do stuff sterile-ly *)
								!TrueQ[sterileTechnique]
							]
						],
						!MatchQ[Lookup[options, TipMaterial], Except[Automatic | Null]],
						!MatchQ[Lookup[options, TipType], Except[Automatic | Null]],
						!MatchQ[resolvedPreparation, Robotic]
					],
						Null,

					(* Are we trying to transfer more volume than the tips can hold? *)
					(* For manual sterile transfer, even if the volume is more than max volume of serological pipette, we will use pipette by doing multiple times *)
					MatchQ[convertedAmountAsVolume, GreaterP[Max[TransferDevices[Model[Item, Tips], All][[All, 3]]]]] && (!TrueQ[sterileTechnique] && !MatchQ[resolvedPreparation, Robotic]),
						Null,

					(* Is the source or destination container hermetic (taking into account of if we're going to unseal it)? *)
					(* This means that we have to use a needle. UNLESS the user told us to explicitly use a pipette. *)
					(* NOTE: we wont really be using a IntermediateContainer in this case anyway, so be sure to refer to sourceContainerPacket! *)
					And[
						Or[
							(* Is the source container going to stay hermetic? *)
							And[
								MatchQ[Lookup[sourceContainerPacket, Hermetic], True],
								!MatchQ[Lookup[options, UnsealHermeticSource], True],
								!MatchQ[Lookup[options, ReplaceSourceCover], True],
								!MemberQ[Lookup[options, {SourceCover, SourceSeptum, SourceStopper}], Except[Automatic | Null]]
							],
							(* Is the destination container going to stay hermetic? *)
							And[
								MatchQ[Lookup[destinationContainerPacket, Hermetic], True],
								!MatchQ[Lookup[options, UnsealHermeticDestination], True],
								!MatchQ[Lookup[options, ReplaceDestinationCover], True],
								!MemberQ[Lookup[options, {DestinationCover, DestinationSeptum, DestinationStopper}], Except[Automatic | Null]]
							]
						],
						!MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]]
					],
						Null,

					(* At this point, the user hasn't told us anything that indicates that we shouldn't use a tip/pipette combo. *)
					(* If the source sample is compatible via SampleHandling or the user told us about TipMaterial/TipType, use tips. *)
					(* NOTE: Even though we can't transfer from a fixed sample, still resolve to tips for resolving purposes. We error check this later. *)
					Or[
						MatchQ[Lookup[sourcePacket, SampleHandling], Liquid | Slurry | Fixed | Viscous],
						And[
							Or[
								MatchQ[Lookup[sourcePacket, State], Liquid],
								MatchQ[Lookup[sourcePacket, Volume], VolumeP] && MatchQ[Lookup[sourcePacket, State], Null]
							],
							MatchQ[Lookup[sourcePacket, SampleHandling], Null]
						],
						MatchQ[Lookup[options, TipMaterial], Except[Automatic | Null]],
						MatchQ[Lookup[options, TipType], Except[Automatic | Null]]
					],
						Module[{tipConnectionType, specifiedTipType, specifiedTipMaterial, sterile, potentialTips, containerCompatibleTips, pipetteType, volumeWithRoboticTransportVolumes,
							specifiedInstrument},
							(* Lookup our pipette type if we were given a pipette. *)
							specifiedInstrument = Download[Lookup[options, Instrument], Object];
							tipConnectionType = Which[
								MatchQ[specifiedInstrument, ObjectReferenceP[{Model[Instrument, Aspirator], Model[Instrument, Pipette]}]],
									fastAssocLookup[fastAssoc, specifiedInstrument, TipConnectionType],
								MatchQ[specifiedInstrument, ObjectReferenceP[{Object[Instrument, Aspirator], Object[Instrument, Pipette]}]],
									fastAssocLookup[fastAssoc, specifiedInstrument, {Model, TipConnectionType}],
								MatchQ[specifiedInstrument, ObjectReferenceP[Model[Instrument, Aspirator]]] && MatchQ[Lookup[options, MultichannelTransfer], True],
									fastAssocLookup[fastAssoc, specifiedInstrument, MultichannelTipConnectionType],
								True,
									All
							];

							(* Lookup our TipType. *)
							specifiedTipType = Which[
								MatchQ[Lookup[options, TipType], Except[Automatic]],
									Lookup[options, TipType],

								(* Use a barrier (filter) tip if we want to do things RNaseFree. *)
								MatchQ[Lookup[options, TipType], Automatic] && MatchQ[rnaseFreeTechnique, True],
									Barrier,

								(* Otherwise, all types. *)
								True,
									All
							];

							(* Lookup our TipMaterial. *)
							specifiedTipMaterial = (Lookup[options, TipMaterial] /. {Automatic -> All});

							(* If we have to use SterileTechnique or RNaseFreeTechnique, use a sterile tip. *)
							sterile = If[MatchQ[sterileTechnique, True] || MatchQ[rnaseFreeTechnique, True],
								True,
								All
							];

							(* We should use a positive displacement pipette if we have a viscous or paste-like sample unless we are requesting to work on Hamilton. *)
							pipetteType = Which[
								MatchQ[resolvedPreparation, Robotic],
									Hamilton,
								MatchQ[Lookup[sourcePacket, SampleHandling], Viscous | Paste] && !MatchQ[destinationIsWasteQ, True],
									PositiveDisplacement,
								(* if we have VolumetricFlask as the source, do not use serological pipette, we either use a Micropipette, or if we cannot find any, use a intermediate container *)
								MatchQ[Lookup[workingSourceContainerModelPacketSemiResolved, Type], Model[Container, Vessel, VolumetricFlask]],
									Micropipette,
								True,
									{Micropipette, Serological}
							];

							(* The full volume that the tip needs to aspirate consists of: *)
							(* 1) OverDispenseVolume (blow out air that is first aspirated) *)
							(* 2) Amount (taking into account the correction curve) *)
							(* 3) OverAspirationVolume (air transport volume) *)
							volumeWithRoboticTransportVolumes = If[MatchQ[resolvedPreparation, Robotic],
								Total[{
									If[MatchQ[overDispenseVolume, VolumeP],
										overDispenseVolume,
										0 Microliter
									],
									If[MatchQ[correctionCurve, {{VolumeP, VolumeP}..}],
										(* NOTE: LinearModelFit only works with floats, not quantities. *)
										LinearModelFit[
											correctionCurve /. {vol:VolumeP :> QuantityMagnitude[UnitConvert[vol, Microliter]]},
											x,
											x
										][QuantityMagnitude[UnitConvert[convertedAmountAsVolume, Microliter]]] * Microliter,
										convertedAmountAsVolume
									],
									If[MatchQ[overAspirationVolume, VolumeP],
										overAspirationVolume,
										0 Microliter
									]
								}],
								convertedAmountAsVolume
							];

							(* Get the tips that we should use. *)
							(* TransferDevices gives us results in a preferential order. *)
							potentialTips = Module[{potentialTipsOneTransfer, potentialTipsOneTransferCanAspirate, defaultPotentialTips},
								(* Get the list with the correct options passed down to it. *)
								(* since volumeWithRoboticTransportVolumes can be relatively high compared to convertedAmountAsVolume, the resolver may ultimately select tips that are not very rational. For example, transfer amount is 5 uL DispenseMixVolume is 2 uL. volumeWithRoboticTransportVolumes might end up to be ~15 uL. depending on the well height, the resolver might choose a 300 uL tip, which then an error is thrown because it cannot do the 2 uL mix. So, limit the potential tip options to the ones that can handle both convertedAmountAsVolume and volumeWithRoboticTransportVolumes *)
								potentialTipsOneTransfer = Which[

									(* If we're aspirating, we don't actually have to be able to hold the volume in our tips. *)
									TrueQ[destinationIsWasteQ],
										TransferDevices[
											Model[Item, Tips],
											All,
											TipConnectionType -> tipConnectionType,
											TipType -> specifiedTipType,
											TipMaterial -> specifiedTipMaterial,
											Sterile -> sterile,
											PipetteType -> pipetteType
										][[All, 1]],

									(* if volumeWithRoboticTransportVolumes and convertedAmountAsVolume are equal, does not matter which one is used to find suitable tips *)
									EqualQ[volumeWithRoboticTransportVolumes, convertedAmountAsVolume],
										TransferDevices[
											Model[Item, Tips],
											convertedAmountAsVolume,
											TipConnectionType -> tipConnectionType,
											TipType -> specifiedTipType,
											TipMaterial -> specifiedTipMaterial,
											Sterile -> sterile,
											PipetteType -> pipetteType
										][[All, 1]],

									(* Since volumeWithRoboticTransportVolumes can be relatively high compared to convertedAmountAsVolume, the resolver may select suboptimal tips, which ultimately might throw errors. For example, if the transfer amount is 5 µL and DispenseMixVolume is 2 µL, volumeWithRoboticTransportVolumes might reach ~15 µL. Depending on well height, the resolver could pick a 300 µL tip, which would then fail to perform the 2 µL mix. To prevent this, restrict tip selection to those that support both convertedAmountAsVolume and volumeWithRoboticTransportVolumes. *)
									True,
										Module[{tipsForAmount, tipsForCorrectedAmount},

											(* tips that are suitable for transferring the specified amount *)
											tipsForAmount = TransferDevices[
												Model[Item, Tips],
												convertedAmountAsVolume,
												TipConnectionType -> tipConnectionType,
												TipType -> specifiedTipType,
												TipMaterial -> specifiedTipMaterial,
												Sterile -> sterile,
												PipetteType -> pipetteType
											][[All, 1]];

											(* tips that are suitable for transferring the corrected amount for robotic transfer *)
											tipsForCorrectedAmount = TransferDevices[
												Model[Item, Tips],
												volumeWithRoboticTransportVolumes,
												TipConnectionType -> tipConnectionType,
												TipType -> specifiedTipType,
												TipMaterial -> specifiedTipMaterial,
												Sterile -> sterile,
												PipetteType -> pipetteType
											][[All, 1]];

											(* tips that are suitable for specified and corrected amounts, with preserving the order *)
											(* using Intersection changes the initial order *)
											If[Length[tipsForAmount] > 0,
												Select[tipsForAmount, MemberQ[tipsForCorrectedAmount, #]&],
												tipsForCorrectedAmount
											]
										]
								];

								(* These tips can hold the volume and meet the required TipType/TipMaterial -- but make sure that they can reach the bottom of the container. *)
								potentialTipsOneTransferCanAspirate = AnyTrue[
									potentialTipsOneTransfer,
									(tipsCanAspirateQ[
										#,
										workingSourceContainerModelPacketSemiResolved,
										sourceAmountAsVolume,
										convertedAmountAsVolume,
										allTipModelPackets,
										allVolumeCalibrationPackets
									]&)
								];

								(* If we do not have any tips possible, allow multiple transfers only for manual case! *)
								defaultPotentialTips = If[(Length[potentialTipsOneTransfer] == 0 || !potentialTipsOneTransferCanAspirate) && MatchQ[resolvedPreparation, Manual],
									Module[{allCompatibleTipTuples, minTipVolume, minMaxCheck},
										(* Get all compatible tips, regardless of volume. *)
										allCompatibleTipTuples = TransferDevices[
											Model[Item, Tips],

											All,

											TipConnectionType -> tipConnectionType,
											TipType -> specifiedTipType,
											TipMaterial -> specifiedTipMaterial,
											Sterile -> sterile,
											PipetteType -> pipetteType
										];

										(* Check for the lowest possible transfer volume *)
										minTipVolume = If[MatchQ[allCompatibleTipTuples, {}],
											Null,
											Min[allCompatibleTipTuples[[All, 2]]]
										];

										minMaxCheck = Which[
											(* There were no compatible tips *)
											NullQ[minTipVolume],
											{},
											(* If the transfer volume is lower than the lowest possible transfer volume then return an empty list *)
											LessEqualQ[volumeWithRoboticTransportVolumes, minTipVolume],
											{},
											(* TransferDevices will sort the tips from small to large, so we reverse and select the tips that have the minimum precision to do the set transfer, i.e. you cannot do a transfer of 10uL with a 25mL serological pipette b/c of its MinVolume *)
											GreaterEqualQ[Length[allCompatibleTipTuples], 1],
											Select[Reverse[allCompatibleTipTuples], LessEqualQ[#[[2]], volumeWithRoboticTransportVolumes]&][[All, 1]],
											True,
											{}
										]
									],
									potentialTipsOneTransfer
								];

								(* If there are no tips available that suit our needs, then take off our limitations *)
								(*  and record an error to throw later. *)
								If[Length[defaultPotentialTips] == 0,
									(* Record the lack of compatible tips. *)
									AppendTo[
										noCompatibleTipsErrors,
										{
											Lookup[sourcePacket, Object],
											If[MatchQ[destinationIsWasteQ, True],
												All,
												volumeWithRoboticTransportVolumes
											],
											{
												TipConnectionType -> tipConnectionType,
												TipType -> specifiedTipType,
												TipMaterial -> specifiedTipMaterial,
												Sterile -> sterile,
												PipetteType -> pipetteType
											},
											manipulationIndex
										}
									];

									TransferDevices[
										Model[Item, Tips],

										(* If we're aspirating, we don't actually have to be able to hold the volume in our tips. *)
										If[MatchQ[destinationIsWasteQ, True] || MatchQ[volumeWithRoboticTransportVolumes, GreaterP[50 Milliliter]],
											All,
											volumeWithRoboticTransportVolumes
										]
									][[All, 1]],
									defaultPotentialTips
								]
							];

							If[MatchQ[ECL`$UnitTestObject, _ECL`Object],
								Echo[potentialTips, "potentialTips"];
							];

							(* Check again to make sure that we pick a tip that can reach the bottom of the container. *)
							containerCompatibleTips = Select[
								potentialTips,
								(tipsCanAspirateQ[
									#,
									workingSourceContainerModelPacketSemiResolved,
									sourceAmountAsVolume,
									convertedAmountAsVolume,
									allTipModelPackets,
									allVolumeCalibrationPackets
								]&)
							];

							(* If there are no tips that can reach the bottom of the container, then just pick the most preferential given back by TransferDevices *)
							(* and we'll do an IntermediateTransfer. UNLESS they told us to transfer Amount->All and we're not doing sterile technique. Then we'll just pour. *)
							Which[
								Length[containerCompatibleTips] == 0 && !MatchQ[amount, All],
									(* Will need to do an intermediate transfer. *)
									(* we return a list here b/c we want to do a little bit of "smart" resolution with intermediate containers *)
									(* NOTE: the list is already sorted from the largest tips to smallest *)
									(* NOTE 2: b/c we are using workingSourceContainerModelPacketSemiResolved, we might have already been in an intermediate container at this point, so this be in an error state anyway, the only not so good thing is that we are calling tipsCanAspirateQ again when resolving IntermediateContainer *)
									potentialTips,
								Length[containerCompatibleTips] == 0 && MatchQ[amount, All] && !TrueQ[sterileTechnique],
									(* Just pour *)
									Null,
								True,
									(* We have tips that can reach the bottom of the container. *)
									FirstOrDefault[containerCompatibleTips]
							]
						],

					(* At this point, give up on using tips. *)
					True,
						Null
				];
				
				(* Define if we are doing an FTV to a volumetric flask - volumetricFlaskFTVQ *)
				volumetricFlaskFTVQ = (MatchQ[Lookup[options,FillToVolume],True] || MatchQ[Lookup[options,ParentProtocol],ObjectP[Object[Protocol,FillToVolume]]]) && !MatchQ[Lookup[options,FillToVolumeOverfillingRepreparation, False],True] && MatchQ[destinationContainerModelPacket,ObjectP[{Model[Container,Vessel,VolumetricFlask],Object[Container,Vessel,VolumetricFlask]}]];
				
				(* Resolve Intermediate Decant *)
				intermediateDecant=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, IntermediateDecant], Except[Automatic]],
					Lookup[options, IntermediateDecant],

					MatchQ[resolvedPreparation, Robotic],
					Null,

					(* Did the user give us an intermediate container AND we are NOT in FTV? *)
					MatchQ[Lookup[options, IntermediateContainer], Except[Automatic]]&&Not[volumetricFlaskFTVQ],
					True,

					(* Do we have a squeezable container and is our amount a volume? *)
					(* If we had a mass, we will use an intermediate container anyways so we don't have to do an extra decant. *)
					MatchQ[Lookup[sourceContainerModelPacket, Squeezable], True] && MatchQ[amount, VolumeP],
					True,

					(* Do we have tips and can our chosen tips NOT reach the bottom of the working source container? *)
					And[
						MatchQ[tipsSemiResolved, Except[Null]],
						If[MatchQ[tipsSemiResolved, ObjectP[Object[Item, Tips]]],
							!tipsCanAspirateQ[
								fastAssocLookup[fastAssoc, tipsSemiResolved, {Model, Object}],
								workingSourceContainerModelPacketSemiResolved,
								sourceAmountAsVolume,
								convertedAmountAsVolume,
								allTipModelPackets,
								allVolumeCalibrationPackets
							],
							AllTrue[
								ToList[tipsSemiResolved],
								(!tipsCanAspirateQ[
									#,
									workingSourceContainerModelPacketSemiResolved,
									sourceAmountAsVolume,
									convertedAmountAsVolume,
									allTipModelPackets,
									allVolumeCalibrationPackets
								]&)
							]
						]
					],
					(* Then we need to decant. *)
					True,

					(* Are we supposed to magnetize the sample before transferring, is the transfer amount under 50mL *)
					(* (the largest rack that we have), and is the format not in a magnetic rack compatible footprint? *)

					(* NOTE: All of our PreferredContainers (how intermediate container is resolved) are compatible with *)
					(* our magnetic racks in house. *)
					And[
						Or[
							MatchQ[Lookup[options, Magnetization], True],
							MatchQ[Lookup[options, MagnetizationTime], TimeP],
							MatchQ[Lookup[options, MaxMagnetizationTime], TimeP]
						],
						MatchQ[convertedAmountAsVolume, LessEqualP[50 Milliliter]],
						!MatchQ[Lookup[sourceContainerModelPacket, Footprint], Alternatives@@magneticRackCompatibleFootprints]
					],
					True,

					(* Otherwise, we do not need to do an intermediate decant. *)
					True,
					False
				];

				(* resolve the intermediate container based on the transfer volume, practicality of pouring from a giant container to a tiny one, and graduation lines (we will always try to use a graduated container if possible) *)
				intermediateContainer=Which[
					(* Did the user give us a value? *)
					MatchQ[intermediateContainerSemiResolved, Except[Automatic]],
						intermediateContainerSemiResolved,
					(* If we are decanting, pick a container that can support the volume of our sample. *)
					MatchQ[intermediateDecant, True],
						resolveIntermediateContainer[convertedAmountAsVolume],
					(* We are not decanting. *)
					True,
						Null
				];

				(* If IntermediateContainer is specified by user, and the source sample is not compatible with the intermediate container, record the error *)
				(* Get a list of materials, if any, that is common between the IncompatibleMaterials of the source and the ContainerMaterials of the specified container *)
				incompatibleMaterialsIntermediateContainer=If[MatchQ[Lookup[options, IntermediateContainer], Except[Automatic]],
					Intersection[
						Cases[ToList[Lookup[sourcePacket,IncompatibleMaterials]],Except[Null]],
						Cases[ToList[fastAssocLookup[fastAssoc,intermediateContainer,ContainerMaterials]],Except[Null]]
					],
					{}
				];

				If[MatchQ[Length[incompatibleMaterialsIntermediateContainer],GreaterP[0]],
					AppendTo[incompatibleIntermediateContainerErrors, {sourceInput,manipulationIndex,intermediateContainer,incompatibleMaterialsIntermediateContainer}]
				];

				(* we cannot set recoup intermediate container option to True if our source sample is simulated (simulate means the sample comes from a Model and we might still fulfill it with a public sample later in RP) or public, this is so we can minimize cross contamination for sample *)
				If[
					And[
						(* if we are decanting *)
						TrueQ[intermediateDecant],
						(* AND user set IntermediateDecantRecoup to True while *)
						TrueQ[Lookup[options, IntermediateDecantRecoup]],
						With[{simulatedQ = TrueQ[Quiet[Experiment`Private`simulatedObjectQs[{Lookup[sourcePacket, Object]}, simulation][[1]]]]},
							Or[
								(* either source is a public sample *)
								!simulatedQ && NullQ[Lookup[sourcePacket, Notebook]],
								(* or a simulated object *)
								simulatedQ
							]
						]
					],
					(* we do not allow recoup *)
					AppendTo[recoupContaminationErrors, {sourceInput,manipulationIndex}]
				];

				(* If we have an intermediate transfer container, we care about fitting into that container, not the source's container. *)
				workingSourceContainerModelPacket = Which[
					MatchQ[intermediateContainer, ObjectP[Object[Container]]],
						fastAssocPacketLookup[fastAssoc, intermediateContainer, Model],
					MatchQ[intermediateContainer, ObjectP[Model[Container]]],
						fetchPacketFromFastAssoc[intermediateContainer, fastAssoc],
					True,
						sourceContainerModelPacket
				];

				(* with the intermediate container resolved, we can now fully resolve tips that can aspirate with this proper source container model *)
				tips = If[Length[ToList[tipsSemiResolved]] > 1,
					SelectFirst[
						ToList[tipsSemiResolved],
						(tipsCanAspirateQ[
							#,
							workingSourceContainerModelPacket,
							sourceAmountAsVolume,
							convertedAmountAsVolume,
							allTipModelPackets,
							allVolumeCalibrationPackets
						]&),
						(* default to use the largest tips *)
						First[ToList[tipsSemiResolved], Null]
					],
					(* default to use the largest tips *)
					First[ToList[tipsSemiResolved], Null]
				];

				If[MatchQ[ECL`$UnitTestObject, _ECL`Object],
					Echo[sourcePacket,"sourcePacket"];
					Echo[tips,"tips"];
				];

				(* Get the model packet for these tips. *)
				tipModelPacket=Which[
					MatchQ[tips, ObjectP[Object[Item, Tips]]],
						fastAssocPacketLookup[fastAssoc, tips, Model],
					MatchQ[tips, ObjectP[Model[Item, Tips]]],
						fetchPacketFromFastAssoc[tips, fastAssoc],
					True,
						Null
				];

				If[MatchQ[ECL`$UnitTestObject, _ECL`Object],
					Echo[tipModelPacket,"tipModelPacket"];
				];

				(* Resolve TipType based on the resolved Tips. *)
				tipType=If[MatchQ[Lookup[options, TipType],Automatic],
					Which[
						MatchQ[tips, ObjectP[Object[Item, Tips]]],
						(*Look up each value of the {WideBore, Filtered, Aspirator, GelLoading} in the selected myTips object packet*)
						(*If there are more than one True, (i.e. {WideBore,Filtered} or {Aspirator, Filtered}), display the first as the resolved type*)
						First@(
							(If[MatchQ[Lookup[tipModelPacket, #], True],
								(*If the looked up value is True, append the TipTypeP to the resolved myTipType*)
								#,
								Nothing
								(*Map over the following field names in Model[Item,Tips], Replace Filtered(field name) with Barrier(TipTypeP), strip the list of single item, and return Normal for empty list *)
							]&/@ {WideBore, Aspirator, Filtered, GelLoading}
							) /. {Filtered->Barrier, {} -> {Normal}}
						),
						MatchQ[tips, ObjectP[Model[Item, Tips]]],
						(*Look up each value of the {WideBore, Filtered, Aspirator, GelLoading} in the selected myTips object packet*)
						(*If there are more than one True, (i.e. {WideBore,Filtered} or {Aspirator,Filtered}), display the first as the resolved type*)
						First@(
							(If[MatchQ[Lookup[tipModelPacket, #], True],
								(*If the looked up value is True, append the TipTypeP to the resolved myTipType*)
								#,
								Nothing
								(*Map over the following field names in Model[Item,Tips], Replace Filtered(field name) with Barrier(TipTypeP), strip the list of single item, and return Normal for empty list *)
							]&/@ {WideBore, Aspirator, Filtered, GelLoading}
							) /. {Filtered->Barrier, {} -> {Normal}}
						),
						True,
							Null
					],
					Lookup[options, TipType]
				];

				(* Resolve TipMaterial based on the resolved Tips. *)
				tipMaterial=If[MatchQ[Lookup[options, TipMaterial],Automatic],
					Which[
						MatchQ[tips, ObjectP[Object[Item, Tips]]],
							Lookup[tipModelPacket, Material],
						MatchQ[tips, ObjectP[Model[Item, Tips]]],
							Lookup[tipModelPacket, Material],
						True,
							Null
					],
					Lookup[options, TipMaterial]
				];

				(* Resolve AspirationRate. *)
				aspirationRate=Which[
					MatchQ[Lookup[options, AspirationRate], Except[Automatic]],
						Lookup[options, AspirationRate],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, AspirationRate], Except[Null]],
						Lookup[pipettingMethodPacket, AspirationRate],
					True,
						100 Microliter/Second
				];

				(* Resolve DispenseRate. *)
				dispenseRate=Which[
					MatchQ[Lookup[options, DispenseRate], Except[Automatic]],
						Lookup[options, DispenseRate],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, DispenseRate], Except[Null]],
						Lookup[pipettingMethodPacket, DispenseRate],
					MatchQ[Lookup[options, AspirationRate], Except[Automatic]],
						Lookup[options, AspirationRate],
					True,
						100 Microliter/Second
				];

				(* Resolve AspirationWithdrawalRate. *)
				aspirationWithdrawalRate=Which[
					MatchQ[Lookup[options, AspirationWithdrawalRate], Except[Automatic]],
						Lookup[options, AspirationWithdrawalRate],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, AspirationWithdrawalRate], Except[Null]],
						Lookup[pipettingMethodPacket, AspirationWithdrawalRate],
					MatchQ[Lookup[options, DispenseWithdrawalRate], Except[Automatic]],
						Lookup[options, DispenseWithdrawalRate],
					True,
						2 Millimeter/Second
				];

				(* Resolve DispenseWithdrawalRate. *)
				dispenseWithdrawalRate=Which[
					MatchQ[Lookup[options, DispenseWithdrawalRate], Except[Automatic]],
						Lookup[options, DispenseWithdrawalRate],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, DispenseWithdrawalRate], Except[Null]],
						Lookup[pipettingMethodPacket, DispenseWithdrawalRate],
					MatchQ[Lookup[options, AspirationWithdrawalRate], Except[Automatic]],
						Lookup[options, AspirationWithdrawalRate],
					True,
						2 Millimeter/Second
				];

				(* Resolve AspirationEquilibrationTime. *)
				aspirationEquilibrationTime=Which[
					MatchQ[Lookup[options, AspirationEquilibrationTime], Except[Automatic]],
						Lookup[options, AspirationEquilibrationTime],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, AspirationEquilibrationTime], Except[Null]],
						Lookup[pipettingMethodPacket, AspirationEquilibrationTime],
					True,
						1 Second
				];

				(* Resolve DispenseEquilibrationTime. *)
				dispenseEquilibrationTime=Which[
					MatchQ[Lookup[options, DispenseEquilibrationTime], Except[Automatic]],
						Lookup[options, DispenseEquilibrationTime],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, DispenseEquilibrationTime], Except[Null]],
						Lookup[pipettingMethodPacket, DispenseEquilibrationTime],
					True,
						1 Second
				];

				(* Resolve AspirationPosition. *)
				aspirationPosition=Which[
					MatchQ[Lookup[options, AspirationPosition], Except[Automatic]],
						Lookup[options, AspirationPosition],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, AspirationPosition], Except[Null]],
						Lookup[pipettingMethodPacket, AspirationPosition],
					True,
						LiquidLevel
				];

				(* Resolve DispensePosition. *)
				dispensePosition=Which[
					mnTransferQ&&MatchQ[Lookup[options, DispensePosition], LiquidLevel],
						AppendTo[invalidMNDispenseErrors, manipulationIndex]; Lookup[options, DispensePosition],
					MatchQ[Lookup[options, DispensePosition], Except[Automatic]],
						Lookup[options, DispensePosition],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					(* for MxN transfer, default to Bottom *)
					mnTransferQ,
						Bottom,
					(* Don't try to do LLD if we're dispensing into a tilted plate since the liquid will all pool to one side. *)
					(* We also don't do TouchOff here because DispenseAngle is often used for aspirating/dispensing with adherent cells. *)
					MatchQ[Lookup[options, DispenseAngle], Except[Null|0 AngularDegree|0. AngularDegree]],
						Bottom,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, DispensePosition], Except[Null]],
						Lookup[pipettingMethodPacket, DispensePosition],
					True,
						TouchOff
				];

				(* Resolve AspirationPositionOffset. *)
				aspirationPositionOffset=Which[
					MatchQ[Lookup[options, AspirationPositionOffset], Except[Automatic]],
						Lookup[options, AspirationPositionOffset],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[Lookup[options, AspirationAngle], GreaterP[0 AngularDegree]],
						Coordinate[{
							If[MatchQ[Lookup[sourceContainerModelPacket, WellDimensions], {DistanceP, DistanceP}],
								N@Round[-.98 * Lookup[sourceContainerModelPacket, WellDimensions][[1]] / 2, 10^-1 Millimeter],
								N@Round[-.98 * Lookup[sourceContainerModelPacket, WellDiameter] / 2, 10^-1 Millimeter]
							],
							0 Millimeter,
							If[MatchQ[aspirationPosition, TouchOff],
								1 Millimeter,
								2 Millimeter
							]
						}],
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, AspirationPositionOffset], Except[Null]],
						Lookup[pipettingMethodPacket, AspirationPositionOffset],
					MatchQ[aspirationPosition, TouchOff],
						1 Millimeter,
					True,
						2 Millimeter
				];

				(* Resolve DispensePositionOffset. *)
				dispensePositionOffset=Which[
					MatchQ[Lookup[options, DispensePositionOffset], Except[Automatic]],
						Lookup[options, DispensePositionOffset],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[Lookup[options, DispenseAngle], GreaterP[0 AngularDegree]],
						Coordinate[{
							If[MatchQ[Lookup[destinationContainerModelPacket, WellDimensions], {DistanceP, DistanceP}],
								N@Round[-.98 * Lookup[destinationContainerModelPacket, WellDimensions][[1]] / 2, 10^-1 Millimeter],
								N@Round[-.98 * Lookup[destinationContainerModelPacket, WellDiameter] / 2, 10^-1 Millimeter]
							],
							0 Millimeter,
							If[MatchQ[dispensePosition, TouchOff],
								1 Millimeter,
								2 Millimeter
							]
						}],
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, DispensePositionOffset], Except[Null]],
						Lookup[pipettingMethodPacket, DispensePositionOffset],
					MatchQ[dispensePosition, TouchOff],
						1 Millimeter,
					True,
						2 Millimeter
				];

				(* Resolve DynamicAspiration. *)
				dynamicAspiration=Which[
					MatchQ[Lookup[options, DynamicAspiration], Except[Automatic]],
						Lookup[options, DynamicAspiration],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, DynamicAspiration], Except[Null]],
						Lookup[pipettingMethodPacket, DynamicAspiration],
					True,
						False
				];

				(* Resolve Needle Option. *)
				needle=Which[
					(* If the user has specified the option, use that. *)
					MatchQ[Lookup[options, Needle], Except[Automatic]],
						Lookup[options, Needle],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					And[
						(* If Instrument is a syringe OR either the source/destination is hermetic, resolve to using a needle. *)
						Or[
							MatchQ[Lookup[options, Instrument], ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]],
							MatchQ[Lookup[sourceContainerPacket, Hermetic], True],
							MatchQ[Lookup[destinationContainerPacket, Hermetic], True]
						],
						(* AND Do not resolve to using a needle if we've been given the idea to use a pipette instead. *)
						And[
							MatchQ[tips, Null],
							MatchQ[tipType, Null],
							MatchQ[tipMaterial, Null],
							MatchQ[Lookup[options, Instrument], Automatic|ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]]
						],
						(* AND do not use a needle if our source isn't a liquid. *)
						MatchQ[Lookup[sourcePacket, State], Liquid]
					],
						Module[{specifiedInstrument, syringeConnectionType, maximumContainerDepth, bluntTipQ, potentialNeedles},
							specifiedInstrument = Lookup[options, Instrument];
							(* Is the syringe set? If so, we need to pick a needle that is compatible with the syringe. *)
							syringeConnectionType=Which[
								MatchQ[specifiedInstrument, ObjectP[Object[Container, Syringe]]],
									fastAssocLookup[fastAssoc, specifiedInstrument, {Model, ConnectionType}],
								MatchQ[specifiedInstrument, ObjectP[Model[Container, Syringe]]],
									fastAssocLookup[fastAssoc, specifiedInstrument, ConnectionType],
								True,
									All
							];

							(* What is the maximum container depth between the source and destination containers? *)
							maximumContainerDepth=Max[
								Lookup[sourceContainerModelPacket, Dimensions][[3]],
								Lookup[destinationContainerModelPacket, Dimensions][[3]]
							];

							(* Determine if we want to look for sharp needles to work with hermetic containers, or otherwise use blunt-tip ones *)
							bluntTipQ = And[
								!MatchQ[Lookup[sourceContainerPacket, Hermetic], True],
								!MatchQ[Lookup[destinationContainerPacket, Hermetic], True]
							];

							(* Get all of our compatible syringes. *)
							potentialNeedles = compatibleNeedles[
								allNeedleModelPackets,
								ConnectionType -> syringeConnectionType,
								MinimumLength -> maximumContainerDepth,
								Viscous -> MatchQ[Lookup[sourcePacket, SampleHandling], Viscous],
								Blunt -> bluntTipQ
							];

							(* We're returned needles in preferential order, take the first one given. *)
							FirstOrDefault[potentialNeedles]
						],
					(* Otherwise, don't use a Needle. *)
					True,
						Null
				];

				(* Resolve Hermetic related options. *)
				unsealHermeticSource=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, UnsealHermeticSource], Except[Automatic]],
						Lookup[options, UnsealHermeticSource],
					(* Set to True if we have an Ampoule. *)
					MatchQ[Lookup[sourceContainerPacket, Ampoule], True],
						True,
					(* If we're using anything but a needle, we have to unseal our source/destination if they're hermetic, respectively. *)
					MatchQ[Lookup[sourceContainerPacket, Hermetic], True] && MatchQ[needle, Null],
						True,
					(* Set to True if we're replacing the source cover and have a hermetic source. *)
					MatchQ[Lookup[sourceContainerPacket, Hermetic], True] && (MatchQ[Lookup[options, ReplaceSourceCover], True] || MemberQ[Lookup[options, {SourceCover, SourceSeptum, SourceStopper}], Except[Automatic|Null]]),
						True,
					(* Set to false if we have a hermetic container. *)
					MatchQ[Lookup[sourceContainerPacket, Hermetic], True],
						False,
					(* There are no other situations where we should unseal our container. *)
					True,
						Null
				];

				unsealHermeticDestination=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, UnsealHermeticDestination], Except[Automatic]],
						Lookup[options, UnsealHermeticDestination],
					(* Set to True if we have an Ampoule. *)
					MatchQ[Lookup[destinationContainerPacket, Ampoule], True],
						True,
					(* If we're using anything but a needle, we have to unseal our source/destination if they're hermetic, respectively. *)
					MatchQ[Lookup[destinationContainerPacket, Hermetic], True] && MatchQ[needle, Null],
						True,
					(* Set to True if we're replacing the destination cover and have a hermetic container. *)
					MatchQ[Lookup[destinationContainerPacket, Hermetic], True] && (MatchQ[Lookup[options, ReplaceDestinationCover], True] || MemberQ[Lookup[options, {DestinationCover, DestinationSeptum, DestinationStopper}], Except[Automatic|Null]]),
						True,
					(* Set to false if we have a hermetic container. *)
					MatchQ[Lookup[destinationContainerPacket, Hermetic], True],
						False,
					(* There are no other situations where we should unseal our container. *)
					True,
						Null
				];

				(* once we resolve the UnsealHermeticSource/UnsealHermeticDestination, we can further update the handling condition/transfer environment *)
				(* we really only need backfilling if we use a hermtic container and we are not unsealing *)
				semiResolvedHandlingConditions = If[
					Or[
						And[
							MatchQ[Lookup[sourceContainerPacket, Hermetic], True],
							MatchQ[unsealHermeticSource, Except[True]]
						],
						And[
							MatchQ[Lookup[destinationContainerPacket, Hermetic], True],
							MatchQ[unsealHermeticDestination, Except[True]]
						]
					],
					(
						AppendTo[transferEnvironmentResolutionStrings, "backfilling gas (for sealing hermetic containers)"];
						(* filter to find the handling condition that can do backfillings *)
						Lookup[
							Cases[
								fetchPacketFromFastAssoc[#, fastAssoc]& /@ semiResolvedHandlingConditions,
								KeyValuePattern[{(NitrogenHermeticTransfer | ArgonHermeticTransfer) -> True}]
							],
							Object,
							{}
						]
					),
					(* if we have already requested fumehood, we do not need to do anything *)
					If[MemberQ[transferEnvironmentResolutionStrings, "ventilation (FumeHood)"],
						semiResolvedHandlingConditions,
						(* otherwise, we need to exclude fumehood since we do not need to use fumehood unless absolute necessary *)
						Lookup[
							Cases[
								fetchPacketFromFastAssoc[#, fastAssoc]& /@ semiResolvedHandlingConditions,
								KeyValuePattern[{MinVolumetricFlowRate -> Except[FumeHoodVolumetricFlowRateP]}]
							],
							Object,
							{}
						]
					]
				];

				(* update the transfer environment based on the updated handling condition *)
				semiResolvedTransferEnvironment = UnsortedIntersection[ToList[semiResolvedTransferEnvironment], getHandlingStations[semiResolvedHandlingConditions]];

				backfillNeedle=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, BackfillNeedle], Except[Automatic]],
						Lookup[options, BackfillNeedle],
					(* If the source container is hermetic and we're not unsealing it, we must perform a backfill. *)
					(* Use a disposable 1" needle - no specific reason - but nice that it doesn't have to be handwashed *)
					MatchQ[Lookup[sourceContainerPacket, Hermetic], True] && MatchQ[unsealHermeticSource, False],
						Model[Item, Needle, "id:P5ZnEj4P88YE"],
					(* Do not backfill. *)
					True,
						Null
				];

				ventingNeedle=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, VentingNeedle], Except[Automatic]],
						Lookup[options, VentingNeedle],
					(* If the destination container is hermetic and we're not unsealing it, we must perform a vent. *)
					MatchQ[Lookup[destinationContainerPacket, Hermetic], True] && MatchQ[unsealHermeticDestination, False],
					(* Default to 1inx21G needle *)
					Model[Item, Needle, "id:P5ZnEj4P88YE"], (* "21g x 1 Inch Single-Use Needle" *)
					(* Do not vent. *)
					True,
						Null
				];

				(* Resolve Tip Rinse Options *)
				tipRinse=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, TipRinse], Except[Automatic]],
						Lookup[options, TipRinse],
					(* If any of the tip rinse options are indicated, turn on tip rinsing. *)
					Or[
						MatchQ[Lookup[options, TipRinseSolution], Except[Automatic|Null]],
						MatchQ[Lookup[options, TipRinseVolume], Except[Automatic|Null]],
						MatchQ[Lookup[options, NumberOfTipRinses], Except[Automatic|Null]]
					],
						True,
					(* Do we have tips? *)
					MatchQ[tips, Except[Null]],
						False,
					(* Otherwise, no tip rinsing. *)
					True,
						Null
				];

				tipRinseSolution=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, TipRinseSolution], Except[Automatic]],
						Lookup[options, TipRinseSolution],
					(* Are we tip rinsing? *)
					MatchQ[tipRinse, True],
					Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *),
					(* Otherwise, no tip rinsing. *)
					True,
						Null
				];

				tipRinseVolume=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, TipRinseVolume], Except[Automatic]],
						Lookup[options, TipRinseVolume],
					(* Are we tip rinsing? *)
					MatchQ[tipRinse, True],
						Module[{tipMaxVolume},
							(* Get the volume of the tip that we're using. *)
							(* If we were unable to find the tips, just default to 500 Microliter. We will yell about the lack of tips later. *)
							tipMaxVolume=Which[
								MatchQ[tips, ObjectP[Object[Item, Tips]]],
									fastAssocLookup[fastAssoc, tips, {Model, MaxVolume}],
								MatchQ[tips, ObjectP[Model[Item, Tips]]],
									fastAssocLookup[fastAssoc, tips, MaxVolume],
								True,
									500 Microliter
							];

							(* Use 125% of the Volume or the MaxVolume of the tip when doing a tip rinse. *)
							Min[{UnitScale[SafeRound[(1.25) * convertedAmountAsVolume, 1 Microliter]], tipMaxVolume}]
						],
					(* Otherwise, no tip rinsing. *)
					True,
						Null
				];

				numberOfTipRinses=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, NumberOfTipRinses], Except[Automatic]],
						Lookup[options, NumberOfTipRinses],
					(* Are we tip rinsing? *)
					MatchQ[tipRinse, True],
						(* Default to 5. *)
						5,
					(* Otherwise, no tip rinsing. *)
					True,
						Null
				];

				(* Adding some debugging echos for SM Pelleting test. *)
				If[MatchQ[ECL`$UnitTestObject, _ECL`Object],
					Echo[resolvedPreparation, "resolvedPreparation"];
					Echo[Lookup[options, Instrument], "Lookup[options, Instrument]"];
					Echo[tips, "tips"];
					Echo[amount, "amount"];
				];

				(* Check if user has specified any QuantitativeTransferOptions or if Preparation is Manual - this information is required for subsequent resolutions *)
				semiResolvedQuantitativeTransferQ = And[
					!MatchQ[resolvedPreparation, Robotic],
					(* If any of the other quantitative transfer options are set, resolve to True. *)
					MemberQ[
						Lookup[
							options,
							{
								QuantitativeTransfer,
								QuantitativeTransferWashSolution,
								QuantitativeTransferWashVolume,
								QuantitativeTransferWashInstrument,
								QuantitativeTransferWashTips,
								NumberOfQuantitativeTransferWashes
							}
						],
						Except[Automatic|Null|False]
					]
				];

				(* check if we need a weighing container - this is needed to determine appropriate spatula based on destination aperture *)
				(* SetDelayed b/c compatibleBalanceModels[...] can change depending if we have resolved a weighing container or not *)
				weighingContainerRequired := And[
					MatchQ[convertedAmount, MassP|CountP],
					Or[
						(* We need a weighing container if we're transferring a mass AND the destination container is not empty. *)
						!MatchQ[destinationAmountAsVolume, 0 Liter],

						(* We need a weighing container if we're quantitative transfer. *)
						(* Check if user has specified any QuantitativeTransferOptions or if Preparation is Manual. *)
						TrueQ[semiResolvedQuantitativeTransferQ],

						(* If the destination container is empty, but is a volumetric flask, get a weigh boat anyway because super long containers with narrow necks make awkward weighing containers  *)
						And[
							MatchQ[destinationAmountAsVolume,0 Liter],
							MatchQ[Lookup[destinationContainerModelPacket,Object],ObjectP[Model[Container,Vessel,VolumetricFlask]]]
						],

						(* We also should use a weighing container if there is not a compatible balance in our transfer environment *)
						(* due to the destination container being too heavy and maxing out the MaxWeight of the balance. *)
						Length[compatibleBalanceModels[IgnoreTransferEnvironmentAvailability->False]]==0,

						(* If our destination container is not self-standing and we don't have a rack for it, let's use a weighing container *)
						And[
							MatchQ[Lookup[destinationContainerModelPacket,SelfStanding],False],
							MatchQ[RackFinder[Lookup[destinationContainerModelPacket,Object]],Null]
						],

						(* if our destination container is Immobile, we definitely should use a weighing container *)
						TrueQ[Lookup[destinationContainerModelPacket, Immobile]]
					]
				];

				(* get the destinationAperture to be able to compare with spatula width *)
				destinationAperture = Which[
					weighingContainerRequired,
					Null,
					MatchQ[Lookup[destinationContainerModelPacket,Aperture],DistanceP],
					Lookup[destinationContainerModelPacket,Aperture],
					MatchQ[Lookup[destinationContainerModelPacket,WellDiameter],DistanceP],
					Lookup[destinationContainerModelPacket,WellDiameter],
					True,
					Null
				];

				(* Resolve Instrument *)
				instrument=Which[
					(* Did the user give us a spatula value? *)
					MatchQ[Lookup[options, Instrument], ObjectP[{Object[Item,Spatula],Model[Item,Spatula]}]],
						(* get a list of all compatible spatulas to check if the user input is valid *)
						{allCompatibleSpatulas,idealSpatulasByCapacity} = compatibleSpatulas[
							convertedAmountAsMass,
							Lookup[sourcePacket, Density],
							allSpatulaModelPackets,
							destinationAperture,
							IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials]
						];
						Lookup[options, Instrument],
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, Instrument], Except[Automatic]],
						Lookup[options, Instrument],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					(* Is our destination waste and we're dealing with TC samples? *)
					MatchQ[destinationIsWasteQ, True] && MatchQ[cultureHandling, NonMicrobial],
						Model[Instrument, Aspirator, "id:zGj91a7O17kE"], (* "HandEvac Handheld Aspirator, Tissue Culture" *)
					(* Is our destination waste and we're dealing with Microbial samples? *)
					MatchQ[destinationIsWasteQ, True] && MatchQ[cultureHandling, Microbial],
						Model[Instrument, Aspirator, "id:J8AY5jD35DDx"], (* "HandEvac Handheld Aspirator, Microbial" *)
					(* Is our destination waste and we're dealing with non-cell samples? *)
					MatchQ[destinationIsWasteQ, True] && MatchQ[cultureHandling, Null],
						Model[Instrument, Aspirator, "id:J8AY5jD35DDx"], (* "HandEvac Handheld Aspirator, Microbial" *)
					(* Do we have tips? If so, then we have to go from the tips to a pipette. *)
					(* This should cover - liquid, slurry, viscous. *)
					MatchQ[tips, Except[Null|ObjectP[{Model[Item,Consumable],Object[Item,Consumable]}]]],
						Module[{tipsModel, potentialPipettes},
							(* Convert our tips to a model. *)
							tipsModel=If[MatchQ[tips, ObjectP[Object[Item, Tips]]],
								fastAssocLookup[fastAssoc, tips, Model],
								tips
							];

							(* Get all pipettes that can perform our transfer. *)
							potentialPipettes=compatiblePipettes[
								tipsModel,
								allTipModelPackets,
								allPipetteModelPackets,
								convertedAmountAsVolume,
								SterileTechnique -> sterileTechnique,
								CultureHandling->cultureHandling,
								GloveBoxStorage->MatchQ[semiResolvedTransferEnvironment, ListableP[ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]]]
							];

							(* Pick the first one or the largest one if there is not pipette that can hold all of the volume. *)
							If[Length[potentialPipettes]==0,
								FirstOrDefault@compatiblePipettes[
									tipsModel,
									allTipModelPackets,
									allPipetteModelPackets,
									All,
									SterileTechnique -> sterileTechnique,
									CultureHandling->cultureHandling,
									GloveBoxStorage->MatchQ[semiResolvedTransferEnvironment, ListableP[ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]]]
								],
								FirstOrDefault[potentialPipettes]
							]
						],
					(* Do we have a needle? If so, get a syringe. *)
					MatchQ[needle, Except[Null]],
						Module[{needleModel, potentialSyringes},
							(* Convert our needles to a model. *)
							needleModel=If[MatchQ[needle, ObjectP[Object[Item, Needle]]],
								fastAssocLookup[fastAssoc, needle, Model],
								needle
							];

							(* Get all syringes that can perform our transfer. *)
							potentialSyringes=Module[{rawPotentialSyringes,anyCompatibleSyringe},
								rawPotentialSyringes=compatibleSyringes[
									needleModel,
									allNeedleModelPackets,
									allSyringeModelPackets,
									convertedAmountAsVolume,
									IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials]
								];

								(* If we didn't find a syringe of the right volume, try to see if there are syringes that would otherwise work *)
								(* If we can find a syringe of a smaller volume that is compatible, the operator will be asked to do multiple transfers *)
								anyCompatibleSyringe = If[Length[rawPotentialSyringes]==0,
									compatibleSyringes[
										needleModel,
										allNeedleModelPackets,
										allSyringeModelPackets,
										All,
										IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials]
									],
									rawPotentialSyringes
								];

								(* If our initial search found no compatible syringes *)
								If[Length[rawPotentialSyringes]==0,

									(* And our second search that didn't consider volume found now compatible syringes *)
									If[Length[anyCompatibleSyringe] == 0,

										(* Record the lack of compatible syringes. *)
										AppendTo[
											noCompatibleSyringesErrors,
											{
												Lookup[sourcePacket, Object],
												convertedAmountAsVolume,
												{
													IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials]
												},
												manipulationIndex
											}
										];

										Module[{maximumSyringeVolume},
											maximumSyringeVolume=Max[Cases[Lookup[allSyringeModelPackets, MaxVolume], VolumeP]];

											compatibleSyringes[
												needleModel,
												allNeedleModelPackets,
												allSyringeModelPackets,
												If[!MatchQ[convertedAmountAsVolume, LessEqualP[maximumSyringeVolume]],
													maximumSyringeVolume,
													convertedAmountAsVolume
												],
												IncompatibleMaterials-> {}
											]
										],

										(* If we did find a syringe that wasn't volume compliant but otherwise compatible, return the largest *)
										{Last[anyCompatibleSyringe]}
									],

									(* If we found a syringe that is compatible and has appropriate volume, then happy days*)
									rawPotentialSyringes
								]
							];

							(* Pick the first one. *)
							FirstOrDefault[potentialSyringes]
						],
					(* If we have an item and our transfer amount is All|_Integer (not using a pill crusher), get tweezers. *)
					MatchQ[Lookup[sourcePacket, {SampleHandling, Sachet}], {Itemized, Except[True]}] && MatchQ[amount, All|_Integer],
						(* "Straight flat tip tweezer" *)
						Model[Item, Tweezer, "id:8qZ1VWNwNDVZ"],
					(* If we have a paste, get a transfer tube. *)
					MatchQ[Lookup[sourcePacket, SampleHandling], Paste],
						Model[Item, TransferTube, "Spectrum Disposable Transfer Tubes"],
					(* If we have a brittle solid, get a chipping hammer. *)
					MatchQ[Lookup[sourcePacket, SampleHandling], Brittle],
						Model[Item, ChippingHammer, "Estwing Big Blue Chipping Hammer"],
					(* If we have a fabric, get scissors. *)
					Or[
						MatchQ[Lookup[sourcePacket, SampleHandling], Fabric],
						(* If we have a sachet,  use scissors to cut open the pouch, the rest of the process does not require tools *)
						MatchQ[Lookup[sourcePacket, {SampleHandling, Sachet}], {Itemized, True}]
					],
						Model[Item, Scissors, "Lab Scissors"],
					(* Are we transferring All from a vessel and not doing stuff sterile-ly? If so, then pour. *)
					And[
						MatchQ[amount, All],
						MatchQ[sourceContainerModelPacket, PacketP[Model[Container, Vessel]]],
						!TrueQ[sterileTechnique]
					],
						Null,

					(* -- Spatula transfer of solids -- *)
					(* If we have a powder (or if SampleHandling->Null and State->Solid), get an appropriately sized spatula. *)
					(* Also just make sure that we have a Mass given as our transfer amount. *)
					Or[
						MatchQ[Lookup[sourcePacket, SampleHandling], Powder],
						(* NOTE: We've already checked for the weird solid sample handling categories above so this is a fail safe. *)
						MatchQ[Lookup[sourcePacket, State], Solid]
					],

						(* get a list of all compatible spatulas *)
						{allCompatibleSpatulas,idealSpatulasByCapacity} = compatibleSpatulas[
							convertedAmountAsMass,
							Lookup[sourcePacket, Density],
							allSpatulaModelPackets,
							destinationAperture,
							IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials]
						];

						If[MatchQ[FirstOrDefault[idealSpatulasByCapacity,Null], ObjectP[]],
							FirstOrDefault[idealSpatulasByCapacity,Null],
							FirstOrDefault[allCompatibleSpatulas,Null]
						],

					(* -- Graduated Cylinder -- *)
					(* If we have a liquid (or if SampleHandling->Null and State->Liquid), get a graduated cylinder. *)
					(* NOTE: In the tips/needle branch we tried to resolve to using a pipette/syringe, unless there *)
					(* were conflicting options. So, if we get here, we couldn't use a pipette or a syringe. *)
					And[
						(*If we are transferring liquid by mass, don't use a graduated cylinder. This will cause confusion in the procedures as it will request a liquid mass transfer into the gc*)
						Or[
							And[
								(* Note if this number is changed here, please also update QualificationTrainingVolumetricFlask *)
								MatchQ[amount, GreaterP[10 Milliliter]],
								MatchQ[destinationContainerModelPacket,ObjectP[{Model[Container,Vessel,VolumetricFlask],Object[Container,Vessel,VolumetricFlask]}]]
							],
							And[
								MatchQ[amount, VolumeP],
								MatchQ[destinationContainerModelPacket,Except[ObjectP[{Model[Container,Vessel,VolumetricFlask],Object[Container,Vessel,VolumetricFlask]}]]]
							]
						],
						Or[
							MatchQ[Lookup[sourcePacket, SampleHandling], Liquid],
							(* NOTE: We've already checked for the viscous liquid sample handling categories above so this is a fail safe. *)
							MatchQ[Lookup[sourcePacket, State], Liquid]
						]
					],
					(* if we cant find a grad cylinder on the first pass, need to loop back and try to loosen the restrictions a bit *)
					FirstOrDefault[
						Flatten[
							{TransferDevices[
								Model[Container, GraduatedCylinder],
								convertedAmountAsVolume,
								{
									If[Length[Lookup[sourcePacket, IncompatibleMaterials]] > 0,
										IncompatibleMaterials -> Lookup[sourcePacket, IncompatibleMaterials],
										Nothing
									]
								}
							][[All, 1]],
								(* ignore the volume requirement and just find the largest compatible gc *)
								LastOrDefault[TransferDevices[
									Model[Container, GraduatedCylinder],
									All,
									{
										If[Length[Lookup[sourcePacket, IncompatibleMaterials]] > 0,
											IncompatibleMaterials -> Lookup[sourcePacket, IncompatibleMaterials],
											Nothing
										]
									}
								][[All, 1]],
									{}
								]
							}
						],
							(* Fall back on the largest graduated cylinder that we have and ignore the compatibility *)
							Last[TransferDevices[Model[Container, GraduatedCylinder], All][[All, 1]]]
						],
					(* Attempt to pour the sample. If this isn't possible, we will throw an error about this later. *)
					True,
						Null
				];

				instrumentModel = If[MatchQ[instrument,ObjectP[Object[]]],
					fastAssocLookup[fastAssoc,instrument,Model],
					instrument
				];

				(* NOTE: This function is abstracted because it is also used below in error checking. *)
				(* NOTE: Send IgnoreTransferEnvironmentAvailability->True if you want to skip the transfer environment check. *)
				(* NOTE: Send IncludeWeighingContainerWeight->True if you want to always include weighing container weight for resolution *)
				(* NOTE: Send IgnoreMassResolutionCompatibility->True if you want to ignore the check of whether a transfer amount is "close" to balance resolution *)
				compatibleBalanceModels[balanceModelOptions:OptionsPattern[]]:=Module[{weighingContainerToUse, weighingContainerPacket, containerWeight, totalMassCompatibleBalanceModels, totalMassWithBufferCompatibleBalanceModels, transferMassCompatibleBalanceModels, massCompatibleBalanceModels, filteredMassCompatibleBalanceModels,availableBalanceModels,finalBalanceModelPackets,filteredBalanceModels,filteredBalanceModelPackets},

					(* get the weighing container, or any user-specified weighing container, since we might call this helper before WeighingContainer is resolved *)
					weighingContainerToUse = If[MatchQ[weighingContainer, ObjectP[]],
						weighingContainer,
						Lookup[options, WeighingContainer]
					];

					(* Get the packet of the weighing container. *)
					weighingContainerPacket = If[MatchQ[weighingContainerToUse, ObjectP[Object[]]],
						fastAssocPacketLookup[fastAssoc, weighingContainerToUse, Model],
						fetchPacketFromFastAssoc[weighingContainerToUse, fastAssoc]
					];

					(* Account for the weight of the weighing container or of the destination container. *)
					containerWeight=If[
						!MatchQ[weighingContainerToUse, ObjectP[]],
						(* Destination Container. *)
						Which[
							MatchQ[Lookup[destinationContainerModelPacket, TareWeight], MassP],
								Lookup[destinationContainerModelPacket, TareWeight],
							(* Item's weight *)
							MatchQ[Lookup[destinationContainerModelPacket, Weight], MassP],
								Lookup[destinationContainerModelPacket, Weight],
							(* Electrode *)
							MatchQ[Lookup[destinationContainerModelPacket, SolutionVolume], VolumeP],
								Lookup[destinationContainerModelPacket, SolutionVolume] * (500 Gram/Liter),
							(* If we don't have the TareWeight of the container, assume that the container weights 500 Grams *)
							(* for every Liter of volume it can hold. This is a rough estimate from some common containers we *)
							(* have in the lab. *)
							True,
								Lookup[destinationContainerModelPacket, MaxVolume] * (500 Gram/Liter)
						],

						(* Weighing Container *)
						Which[

							(* If we know the weight, use it *)
							MatchQ[Lookup[weighingContainerPacket, TareWeight], MassP], Lookup[weighingContainerPacket, TareWeight],
								(* Item *)
								MatchQ[Lookup[weighingContainerPacket, Weight], MassP],Lookup[weighingContainerPacket, Weight],

							(* If we are using a consumable weigh paper, assume 200 mg (measured in lab) *)
							(* Smallest non aluminum weigh boat is about 2.6 grams. aluminum weigh boat is 214 mg *)
							MatchQ[Lookup[weighingContainerPacket, Object],ObjectP[Model[Item, Consumable]]],
								200 Milligram,

							(* Electrode *)
							MatchQ[Lookup[weighingContainerPacket, SolutionVolume], VolumeP],
								Lookup[weighingContainerPacket, SolutionVolume] * (500 Gram/Liter),

								(* If we don't have the TareWeight of the container, assume that the container weights 500 Grams *)
							(* for every Liter of volume it can hold. This is a rough estimate from some common containers we *)
							(* have in the lab. *)
							True,
								Lookup[weighingContainerPacket, MaxVolume] * (500 Gram / Liter)
						]
					];

					(* Return all balances that can weight the amount requested + the empty container + a 5% buffer. To ensure the accurate measurement on the low side, we call TransferDevices twice to get the correct balance for both with and without buffer. TransferDevices is memoized so this is fast. *)
					totalMassCompatibleBalanceModels=TransferDevices[
						Model[Instrument, Balance],
						(convertedAmountAsMass + containerWeight)
					][[All,1]];
					totalMassWithBufferCompatibleBalanceModels=TransferDevices[
						Model[Instrument, Balance],
						(convertedAmountAsMass + containerWeight)*1.05
					][[All,1]];
					(* Also consider the possible balances that can directly do the convertedAmountAsMass without considering containerWeight (which will turn 0 with taring). This is for the best precision of measurement and to make sure our final data looks rasonable *)
					(* Note taring is not affecting the true MinWeight, meaning that the containerWeight can count towards the minimum *)
					(* The only exception is when transfer weight is between analyticalBalanceCutOffWeight and analyticalBalanceMinWeight, where we resolve to Analytical balance, but Micro balance would be returned if we run TransferDevices on only the transfer mass *)
					transferMassCompatibleBalanceModels= Which[
						(* If we are in error checking and told to include weighing container weight when resolving balance, then we skip this transfer mass compatible check *)
						MatchQ[Lookup[ToList[balanceModelOptions], IncludeWeighingContainerWeight, False], True],
							totalMassCompatibleBalanceModels,
						MatchQ[convertedAmountAsMass,RangeP[analyticalBalanceCutOffWeight,analyticalBalanceMinWeight,Inclusive->Left]],
							(* Force it to return the better Analytical balance *)
							TransferDevices[
								Model[Instrument, Balance],
								analyticalBalanceMinWeight
							][[All,1]],
						True,
							TransferDevices[
								Model[Instrument, Balance],
								convertedAmountAsMass
							][[All,1]]
					];

					(* If it is possible to find a more precise balance, let's use it *)
					massCompatibleBalanceModels=If[!MatchQ[UnsortedIntersection[totalMassCompatibleBalanceModels,totalMassWithBufferCompatibleBalanceModels,transferMassCompatibleBalanceModels],{}],
						UnsortedIntersection[totalMassCompatibleBalanceModels,totalMassWithBufferCompatibleBalanceModels,transferMassCompatibleBalanceModels],
						totalMassWithBufferCompatibleBalanceModels
					];

					filteredMassCompatibleBalanceModels = If[TrueQ[Lookup[ToList[balanceModelOptions], IgnoreMassResolutionCompatibility, False]],
						(* ignore this check if we are told to skip *)
						massCompatibleBalanceModels,

						(* Otherwise, do additional check to filter out balances of which the resolution is too close to the desired transfer amount. We may have found a Macro/Bulk balance for a very small transfer because our destination container is heavy. *)
						(* If we find Analytical balance or Micro balance, accept it since we cannot go lower. (Micro balance has very limited weighing container choice that may not work for a lot of transfer requests so we cannot just reject Analytical to go down to Micro) *)
						Map[
							(* Default tolerance is 2 * Resolution so we want to make sure it is smaller than 0.1% of the weight so that we don't lose information by selecting a large balance *)
							(* This is guaranteed to work since Macro's resolution is 0.01 Grams, and the MaxWeight of Analytical is 120 Grams *)
							If[
								And[
									TrueQ[convertedAmountAsMass < (2000 * Lookup[fetchPacketFromCache[#, allBalanceModelPackets], Resolution])],
									MatchQ[Lookup[fetchPacketFromCache[#, allBalanceModelPackets], Mode], (Bulk | Macro)]
								],
								Nothing,
								#
							]&,
							massCompatibleBalanceModels
						]
					];

					(* Get the balance models that are available in our resolved transfer environment. *)
					availableBalanceModels=Which[
						(* If we were told to ignore transfer environment availability, then just return all balances. *)
						MatchQ[Lookup[ToList[balanceModelOptions], IgnoreTransferEnvironmentAvailability, False], True],
							filteredMassCompatibleBalanceModels,

						(* if we are given a environment object already *)
						MatchQ[ToList[semiResolvedTransferEnvironment], {ObjectP[]..}],
							Flatten[Lookup[Lookup[handlingStationBalanceLookup["Memoization"], ToList[semiResolvedTransferEnvironment], <||>], "Model", {}]],

						(* catch all *)
						True,
							{}
					];

					(* Take the intersection between the models that are available for picking in our transfer environments and the *)
					(* balances that are compatible with the mass needed. *)
					filteredBalanceModels=UnsortedIntersection[filteredMassCompatibleBalanceModels, availableBalanceModels];

					(* Get the packet for the balance models *)
					filteredBalanceModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ filteredBalanceModels;

					(* take weighing container into consideration, we can only use Micro balance if we are using $MicroBalanceCompatibleWeighingContainerModels, this limit is only for solids btw *)
					finalBalanceModelPackets = If[MatchQ[weighingContainerToUse, ObjectP[]] && Not[MatchQ[Lookup[weighingContainerPacket, Object], ObjectP[$MicroBalanceCompatibleWeighingContainerModels]]] && MatchQ[Lookup[sourcePacket, State], Solid],
						DeleteCases[filteredBalanceModelPackets, KeyValuePattern[{Mode -> Micro}]],
						filteredBalanceModelPackets
					];

					Lookup[
						SortBy[
							finalBalanceModelPackets,
							{
								(* although we generally want higher precision for our measurements, we do not want to create resource constraints in lab either, we only have 1 Micro in lab but many Analytical balances around, so prefer Analytical over Micro if we can *)
								Lookup[#, Mode, Null]& /. {Analytical -> 1, Macro -> 2, Bulk -> 3, Micro -> 4, Null -> 5},
								(* then sort to prefer the balance with better/smaller MinWeight *)
								Lookup[#, MinWeight, Null]&
							}
						],
						Object,
						{}
					]
				];

				semiResolvedQuantitativeTransferWashSolution=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, QuantitativeTransferWashSolution], Except[Automatic]],
					Lookup[options, QuantitativeTransferWashSolution],
					(* Default to water if we're quant transferring. *)
					MatchQ[semiResolvedQuantitativeTransferQ, True],
					$DefaultQuantitativeTransferWashSolution, (* Model[Sample, "Milli-Q water"] *)
					(* Otherwise, Null. *)
					True,
					Null
				];

				(* Resolve Weighing Container *)

				(* Get the aperture of our destination container. *)
				(* NOTE: Vessels have this number under Aperture, Plates have it under WellDiameter. *)
				destinationContainerAperture=If[MatchQ[Lookup[destinationContainerModelPacket, Aperture], DistanceP],
					Lookup[destinationContainerModelPacket, Aperture],
					Lookup[destinationContainerModelPacket, WellDiameter]
				];

				(* Preresolve the balance option *)
				(* Note:Analytical and Micro mode balances have overlaps. If we do not check whether balance is specified, we might end up using different balance-weighingcontainer pair. *)
				preresolvedBalanceModel = Which[
					MatchQ[Lookup[options, Balance], ObjectP[Object]],
					Download[fastAssocLookup[fastAssoc, Lookup[options, Balance], Model], Object],
					MatchQ[Lookup[options, Balance], ObjectP[Model]],
					Lookup[options, Balance],
					(* Otherwise, use compatibleBalanceModels to resolve balances. This is the same logic we use to resolve balance later *)
					True,
					FirstOrDefault[compatibleBalanceModels[IgnoreTransferEnvironmentAvailability->False]]
				];
				preresolvedBalanceModelMode = If[MatchQ[preresolvedBalanceModel, ObjectP[]],
					fastAssocLookup[fastAssoc, preresolvedBalanceModel, Mode],
					Null
				];

				(* we need to check compatibility with QuantitativeTransferWashSolution *)
				washSolutionIncompatibleMaterials = If[
					MatchQ[semiResolvedQuantitativeTransferWashSolution,ObjectP[]],
					fastAssocLookup[fastAssoc,semiResolvedQuantitativeTransferWashSolution,IncompatibleMaterials],
					{}
				];

				weighingContainer=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, WeighingContainer], Except[Automatic]],
						(* Preresolve compatible weighing container based on QuantitativeTransfer, destination Aperture and IncompatibleMaterials so we can check if the specified option is compatible *)
						preresolvedWeighingContainersAndErrors = compatibleWeighingContainer[
							convertedAmountAsMass,
							convertedAmountAsVolume,
							allWeighingContainerModelPackets,
							allFunnelPackets,
							Mode->preresolvedBalanceModelMode,
							QuantitativeTransfer->semiResolvedQuantitativeTransferQ,
							IncompatibleMaterials->Join[Lookup[sourcePacket, IncompatibleMaterials],washSolutionIncompatibleMaterials],
							Aperture->destinationContainerAperture
						];
						Lookup[options, WeighingContainer],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					weighingContainerRequired,
						(* Are we transferring a solid or liquid? *)
						If[MatchQ[Lookup[sourcePacket, State], Solid],
							(* Solid. *)

							(* Preresolve compatible weighing container based on QuantitativeTransfer, destination Aperture and IncompatibleMaterials *)
							(* QuantitativeTransfer True will resolve to a Model[Item,WeighBoat,WeighingFunnel] with compatible FunnelStemDiameter and Dimensions *)
							(* QuantitativeTransfer False will resolve to a Model[Item,WeighBoat]  *)
							preresolvedWeighingContainersAndErrors = compatibleWeighingContainer[
								convertedAmountAsMass,
								convertedAmountAsVolume,
								allWeighingContainerModelPackets,
								allFunnelPackets,
								Mode->preresolvedBalanceModelMode,
								QuantitativeTransfer->semiResolvedQuantitativeTransferQ,
								IncompatibleMaterials->Join[Lookup[sourcePacket, IncompatibleMaterials],washSolutionIncompatibleMaterials],
								Aperture->destinationContainerAperture
							];

							(* add error check here *)
							(* If WeighingContainer resolved to Null (eg no compatible WeighingContainer was found due to IncompatibleMaterials), throw an error *)
							If[MatchQ[FirstOrDefault[preresolvedWeighingContainersAndErrors[[1]]],Null],
								AppendTo[noCompatibleWeighingContainerErrors,{manipulationIndex,preresolvedWeighingContainersAndErrors[[2]]}],
								Nothing
							];

							(* If preresolvedWeighingContainersAndErrors returns an empty list and a weighing container is required, an error is thrown later *)
							FirstOrDefault[preresolvedWeighingContainersAndErrors[[1]]],

							(* Liquid. Use a vessel from our preferred container list. *)
							(* NOTE: We do not use PreferredContainer here because some of our larger preferred containers are glass and *)
							(* are pretty heavy -- they will max out the MaxWeight of the analytical balances. *)
							Switch[convertedAmountAsVolume,
								LessP[0.5Milliliter],
									Model[Container, Vessel,"id:o1k9jAG00e3N"],
								LessP[1.5Milliliter],
									Model[Container,Vessel,"id:eGakld01zzpq"],
								LessP[1.9 Milliliter],
									Model[Container,Vessel,"id:3em6Zv9NjjN8"],
								LessP[50 Milliliter],
									Model[Container,Vessel,"id:bq9LA0dBGGR6"],
								LessP[125 Milliliter],
									Model[Container, Vessel, "id:jLq9jXvoR87z"],
								LessP[250 Milliliter],
									Model[Container, Vessel, "id:n0k9mG8EojZ6"],
								LessP[500 Milliliter],
									Model[Container, Vessel, "id:XnlV5jKPkq7b"],
								LessP[1 Liter],
									Model[Container, Vessel, "id:XnlV5jKPkqJN"],
								LessP[2 Liter],
									Model[Container, Vessel, "id:qdkmxzqPLnN1"],
								_,
									Model[Container, GraduatedCylinder, "id:L8kPEjNLDDXV"]
							]
						],
					True,
						Null
				];

				weighingContainerModel = Which[
					MatchQ[weighingContainer, ObjectP[Object[]]],
					fastAssocLookup[fastAssoc, weighingContainer, Model],

					MatchQ[weighingContainer, ObjectP[Model[]]],
					weighingContainer
				];

				(* If we have a sachet and no weighing container, i.e. transferring by count using scissors, we will still need a weigh boat as our intermediate container *)
				sachetIntermediateContainer = Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, SachetIntermediateContainer], Except[Automatic]],
					Lookup[options, SachetIntermediateContainer],
					MatchQ[Lookup[sourcePacket, {SampleHandling, Sachet}], {Itemized, True}] && MatchQ[instrument, ObjectP[{Model[Item, Scissors], Object[Item, Scissors]}]] && NullQ[weighingContainer],
					Model[Item, WeighBoat, "id:Vrbp1jaq5Ojz"],(*Weigh boats, medium, Individual*)
					True,
					Null
				];

				(* If we have an weighing container, we care about fitting into that container, not the destination's container. *)
				workingDestinationContainerModelPacket=Which[
					MatchQ[weighingContainer, ObjectP[Object[Container]]],
						fastAssocPacketLookup[fastAssoc, weighingContainer, Model],
					MatchQ[weighingContainer, ObjectP[Model[Container]]],
						fetchPacketFromFastAssoc[weighingContainer, fastAssoc],
					True,
						destinationContainerModelPacket
				];

				(* Resolve Aspiration/DispenseMix options. *)
				aspirationMix=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, AspirationMix], Except[Automatic]],
						Lookup[options, AspirationMix],
					(* If any of the mix options are indicated, turn on mixing. *)
					Or[
						MatchQ[Lookup[options, AspirationMixType], Except[Automatic|Null]],
						MatchQ[Lookup[options, NumberOfAspirationMixes], Except[Automatic|Null]]
					],
						True,
					(* Was the SlurryTransfer option set? *)
					MatchQ[Lookup[options, SlurryTransfer], True],
						True,
					(* Is our source sample a slurry? *)
					MatchQ[Lookup[sourcePacket, SampleHandling], Slurry],
						True,
					(* Otherwise, no mixing. *)
					True,
						False
				];

				slurryTransfer=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, SlurryTransfer], Except[Automatic]],
						Lookup[options, SlurryTransfer],
					(* Are we turning AspirationMix off? *)
					MatchQ[aspirationMix, False],
						False,
					(* Is our source sample a slurry? *)
					MatchQ[Lookup[sourcePacket, SampleHandling], Slurry],
						True,
					(* Otherwise, no slurry transfer. *)
					True,
						False
				];

				aspirationMixType=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, AspirationMixType], Except[Automatic]],
						Lookup[options, AspirationMixType],
					(* Are we mixing? *)
					MatchQ[aspirationMix, True],
					(* If the amount we are transferring is under 1mL and we're using tips, use pipette mixing. Otherwise, use swirling. *)
						If[MatchQ[convertedAmountAsVolume, LessP[1 Milliliter]] && MatchQ[tips, Except[Null]],
							Pipette,
							Swirl
						],
					(* Otherwise, no mixing. *)
					True,
						Null
				];

				numberOfAspirationMixes=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, NumberOfAspirationMixes], Except[Automatic]],
						Lookup[options, NumberOfAspirationMixes],
					(* If we are mixing with multichannel pipette, set to $MaxNumberOfMultichannelPipetteMixes *)
					MatchQ[aspirationMixType, Pipette] && MatchQ[Lookup[options, MultichannelTransfer], True] && MatchQ[resolvedPreparation, Manual],
						$MaxNumberOfMultichannelPipetteMixes,
					(* Otherwise if we are mixing, set to 10 *)
					MatchQ[aspirationMix, True],
						10,
					(* Otherwise, no mixing. *)
					True,
						Null
				];

				(* check warning, if Aspiration/Dispense mixing with multichannel pipette, and NumberOfAspiration/DispenseMixes is set to larger than $MaxNumberOfMultichannelPipetteMixes, throw a warning *)
				If[
					And[
						MatchQ[resolvedPreparation, Manual],
						MatchQ[Lookup[options, MultichannelTransfer], True],
						MatchQ[aspirationMixType, Pipette],
						MatchQ[numberOfAspirationMixes, GreaterP[$MaxNumberOfMultichannelPipetteMixes]]
					],
					AppendTo[multichannelAspirationMixWarnings, {manipulationIndex, numberOfAspirationMixes}]
				];

				maxNumberOfAspirationMixes=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, MaxNumberOfAspirationMixes], Except[Automatic]],
						Lookup[options, MaxNumberOfAspirationMixes],
					(* Are we doing a slurry transfer? *)
					MatchQ[slurryTransfer, True] && MatchQ[numberOfAspirationMixes, LessP[50]],
						50,
					(* Set it to 100 (the max) if the user has set NumberOfAspirationMixes to a high number. *)
					MatchQ[slurryTransfer, True],
						100,
					(* Otherwise, no mixing. *)
					True,
						Null
				];

				(* Resolve AspirationMixVolume. *)
				aspirationMixVolume=Which[
					MatchQ[Lookup[options, AspirationMixVolume], Except[Automatic]],
						Lookup[options, AspirationMixVolume],
					MatchQ[aspirationMixType, Except[Pipette]],
						Null,
					MatchQ[aspirationMix, True] && MatchQ[Lookup[sourcePacket, Volume], VolumeP],
						(* NOTE: Don't use the volume to be transferred as the mix volume if it's less than 1/4 of the total sample volume. *)
						(* Ideally we want 1/2 of the sample volume as the mix volume to get better mixing, but if the transfer volume is over *)
						(* 1/4 of the sample volume, just use that because it's easier to mix with the same volume as is being transferred. *)
						(* Also make sure we do not mixing with a volume that is over 80 Percent of the source total volume to avoid bubbles *)
						If[MatchQ[convertedAmountAsVolume, LessP[Lookup[sourcePacket, Volume] / 4]],
							SafeRound[Min[Max[Lookup[sourcePacket, Volume] / 2, Lookup[tipModelPacket, MinVolume]], Lookup[tipModelPacket, MaxVolume]], 1 Microliter],
							SafeRound[Min[convertedAmountAsVolume, Lookup[tipModelPacket, MaxVolume], Lookup[sourcePacket, Volume] * 0.8], 1 Microliter]
						],
					(* we really should at least have some liquid in the source sample otherwise this transfer just does not make sense *)
					(* so this branch should never be hit *)
					MatchQ[aspirationMix, True],
						convertedAmountAsVolume,
					True,
						Null
				];

				(* Check error. MixVolume must be lower than the capacity of tips, and larger than the MinVolume *)
				If[
					!TrueQ[Or[
						NullQ[aspirationMixVolume],
						TrueQ[(aspirationMixVolume <= Lookup[tipModelPacket, MaxVolume]) && (aspirationMixVolume >= Lookup[tipModelPacket, MinVolume])]
					]],
					AppendTo[aspirationMixVolumeErrors, {manipulationIndex, Lookup[sourcePacket, Object], aspirationMixVolume, Lookup[tipModelPacket, {MinVolume, MaxVolume}]}]
				];

				(* Resolve AspirationMixRate. *)
				aspirationMixRate=Which[
					MatchQ[Lookup[options, AspirationMixRate], Except[Automatic]],
						Lookup[options, AspirationMixRate],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[aspirationMix, False],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, AspirationMixRate], Except[Null]],
						Lookup[pipettingMethodPacket, AspirationMixRate],
					MatchQ[Lookup[options, DispenseMixRate], Except[Automatic]],
						Lookup[options, DispenseMixRate],
					MatchQ[Lookup[options, AspirationRate], Except[Automatic]],
						Lookup[options, AspirationRate],
					True,
						100 Microliter/Second
				];

				(* Resolve Dispense Mix Options. *)
				(* NOTE: We put this here because we want to know first if we have a weighing container. *)
				dispenseMix=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, DispenseMix], Except[Automatic]],
						Lookup[options, DispenseMix],
					(* If any of the mix options are indicated, turn on mixing. *)
					Or[
						MatchQ[Lookup[options, DispenseMixType], Except[Automatic|Null]],
						MatchQ[Lookup[options, NumberOfDispenseMixes], Except[Automatic|Null]]
					],
						True,
					(* Mix after dispensing is generally a good idea. *)
					And[
						MatchQ[Lookup[sourcePacket, SampleHandling], Liquid|Slurry|Powder|Viscous|Paste|Brittle],
						MatchQ[Lookup[destinationPacket, SampleHandling], Liquid|Slurry|Viscous|Paste]
					],
						True,
					(* Otherwise, no mixing. *)
					True,
						False
				];

				dispenseMixType=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, DispenseMixType], Except[Automatic]],
						Lookup[options, DispenseMixType],
					(* Are we mixing? *)
					MatchQ[dispenseMix, True],
						(* If we have a weighing container, mix via swirl once we dump the stuff from the weighing container into the *)
						(* final destination container. Otherwise, use pipette mixing if we have tips and can reach the bottom of *)
						(* the destination's container. *)
						Which[
							MatchQ[weighingContainer, ObjectP[]],
								Swirl,
							And[
								MatchQ[tips, Except[Null]],
								If[MatchQ[tips, ObjectP[Object[Item, Tips]]],
									tipsCanAspirateQ[
										fastAssocLookup[fastAssoc, tips, {Model, Object}],
										workingDestinationContainerModelPacket,
										sourceAmountAsVolume,
										convertedAmountAsVolume,
										allTipModelPackets,
										allVolumeCalibrationPackets
									],
									tipsCanAspirateQ[
										tips,
										workingDestinationContainerModelPacket,
										sourceAmountAsVolume,
										convertedAmountAsVolume,
										allTipModelPackets,
										allVolumeCalibrationPackets
									]
								]
							],
								Pipette,
							True,
								Swirl
						],
					(* Otherwise, no mixing. *)
					True,
						Null
				];

				numberOfDispenseMixes=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, NumberOfDispenseMixes], Except[Automatic]],
						Lookup[options, NumberOfDispenseMixes],
					(* If we are mixing with multichannel pipette, set to $MaxNumberOfMultichannelPipetteMixes *)
					MatchQ[dispenseMixType, Pipette] && MatchQ[Lookup[options, MultichannelTransfer], True] && MatchQ[resolvedPreparation, Manual],
						$MaxNumberOfMultichannelPipetteMixes,
					(* Are we mixing? *)
					MatchQ[dispenseMix, True],
						10,
					(* Otherwise, no mixing. *)
					True,
						Null
				];

				(* check warning, if Aspiration/Dispense mixing with multichannel pipette, and NumberOfAspiration/DispenseMixes is set to larger than $MaxNumberOfMultichannelPipetteMixes, throw a warning *)
				If[
					And[
						MatchQ[resolvedPreparation, Manual],
						MatchQ[Lookup[options, MultichannelTransfer], True],
						MatchQ[dispenseMixType, Pipette],
						MatchQ[numberOfDispenseMixes, GreaterP[$MaxNumberOfMultichannelPipetteMixes]]
					],
					AppendTo[multichannelDispenseMixWarnings, {manipulationIndex, numberOfDispenseMixes}]
				];

				(* Resolve DispenseMixVolume. *)
				dispenseMixVolume = Which[
					MatchQ[Lookup[options, DispenseMixVolume], Except[Automatic]],
						Lookup[options, DispenseMixVolume],
					MatchQ[dispenseMixType, Except[Pipette]],
						Null,
					(* destinationPacket has the volume before this current transfer so we may not have anything in there yet. *)
					MatchQ[dispenseMix, True] && MatchQ[Lookup[destinationPacket, Volume], VolumeP],
						(* recommended DispenseMixVolume is half of the total volume in destination after transfer *)
						(* Make sure we get at least MinVolume of the tip as the dispense mix volume so we can do a mix properly. *)
						(* also Make sure we do not max out over tips' MaxVolume *)
						SafeRound[Min[Max[(Lookup[destinationPacket, Volume] + convertedAmountAsVolume) / 2, Lookup[tipModelPacket, MinVolume]], Lookup[tipModelPacket, MaxVolume]], 1 Microliter],
					(* destination is empty before transfer *)
					MatchQ[dispenseMix, True],
						(* set to half of the transferred volume to avoid bubbles *)
						(* NOTE: we do not want to aspirate all liquid in a container during dispense mixing to avoid bubbles *)
						SafeRound[Max[convertedAmountAsVolume / 2, Lookup[tipModelPacket, MinVolume]], 1 Microliter],
					True,
						Null
				];

				(* Check error. MixVolume must be lower than the capacity of tips *)
				If[
					!TrueQ[Or[
						NullQ[dispenseMixVolume],
						TrueQ[(dispenseMixVolume <= Lookup[tipModelPacket, MaxVolume]) && (dispenseMixVolume >= Lookup[tipModelPacket, MinVolume])]
					]],
					AppendTo[dispenseMixVolumeErrors, {manipulationIndex, Lookup[sourcePacket, Object], Lookup[destinationPacket, Object], dispenseMixVolume, Lookup[tipModelPacket, {MinVolume, MaxVolume}]}]
				];

				(* Resolve DispenseMixRate. *)
				dispenseMixRate=Which[
					MatchQ[Lookup[options, DispenseMixRate], Except[Automatic]],
						Lookup[options, DispenseMixRate],
					MatchQ[resolvedPreparation, Except[Robotic]],
						Null,
					MatchQ[dispenseMix, False],
						Null,
					MatchQ[pipettingMethodPacket, Except[Null]] && MatchQ[Lookup[pipettingMethodPacket, DispenseMixRate], Except[Null]],
						Lookup[pipettingMethodPacket, DispenseMixRate],
					MatchQ[Lookup[options, AspirationMixRate], Except[Automatic]],
						Lookup[options, AspirationMixRate],
					MatchQ[Lookup[options, DispenseRate], Except[Automatic]],
						Lookup[options, DispenseRate],
					True,
						100 Microliter/Second
				];

				(* Resolve Funnel*)
				(* We need to use a funnel if: *)
				(* 1) The Transfer instrument is Null or a Graduated Cylinder. *)
				(* 2) We are doing a liquid transfer and are using a weighing container -- this means we will need to pour from the *)
				(* weighing container to the destination. *)
				funnel=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, Funnel], Except[Automatic]],
						Lookup[options, Funnel],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					(* The Transfer instrument is Null or a Graduated Cylinder. *)
					(* OR we are doing a liquid transfer and are using a weighing container *)
					(* OR we are using a weighing container and the destination is a volumetric flask *)
					Or[
						MatchQ[instrument, Null|ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}]],
						MatchQ[Lookup[sourcePacket, State], Liquid] && MatchQ[weighingContainer, ObjectP[]],
						MatchQ[weighingContainer, Except[ObjectP[{Model[Item,WeighBoat,WeighingFunnel],Object[Item,WeighBoat,WeighingFunnel]}]]] && MatchQ[Lookup[destinationContainerModelPacket,Object],ObjectP[Model[Container,Vessel,VolumetricFlask]]],
						MatchQ[weighingContainer, ObjectP[{Model[Item,WeighBoat],Object[Item,WeighBoat]}]] && MatchQ[weighingContainer, Except[ObjectP[{Model[Item,WeighBoat,WeighingFunnel],Object[Item,WeighBoat,WeighingFunnel]}]]] && MatchQ[semiResolvedQuantitativeTransferQ, True]
					],
						Module[{destinationContainerAperture,funnelType,preresolvedFunnels},
							(* Get the aperture of our destination container. *)
							(* NOTE: Vessels have this number under Aperture, Plates have it under WellDiameter. *)
							destinationContainerAperture=If[MatchQ[Lookup[destinationContainerModelPacket, Aperture], DistanceP],
								Lookup[destinationContainerModelPacket, Aperture],
								Lookup[destinationContainerModelPacket, WellDiameter]
							];

							(* resolve FunnelType based on State of Sample *)
							(* if instrument is GraduatedCylinder, also resolve to Wet *)
							funnelType=Which[
								MatchQ[Lookup[sourcePacket, State], Solid],
								Dry,

								MatchQ[Lookup[sourcePacket, State], Liquid]||MatchQ[instrument, ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}]],
								Wet,

								True,
								{Wet,Dry}
							];

							(* Get an initial list of compatible funnels *)
							preresolvedFunnels=compatibleFunnels[
								allFunnelPackets,
								IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials],
								Aperture->destinationContainerAperture,
								FunnelType->funnelType
							];

							FirstOrDefault[preresolvedFunnels]
							(*
							(* If no compatible funnel comes up for solid transfer due to lack of available models, expand search to Wet funnels *)
							If[MatchQ[funnelType,Dry]&&MatchQ[preresolvedFunnels,{}],
								FirstOrDefault[
									compatibleFunnels[
										allFunnelPackets,
										IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials],
										Aperture->destinationContainerAperture,
										FunnelType->Wet
									]
								],
								FirstOrDefault[preresolvedFunnels]
							]
							*)
						],
					(* Otherwise, we don't need a funnel. *)
					True,
						Null
				];

				(* Resolve IntermediateFunnel *)
				(* We need a funnel if we're doing an intermediate decant. *)
				intermediateFunnel=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, IntermediateFunnel], Except[Automatic]],
						Lookup[options, IntermediateFunnel],

					(* Are we doing an intermediate decant? *)
					MatchQ[intermediateContainer, ObjectP[]],
						Module[{intermediateContainerPacket, intermediateContainerAperture,funnelType},
							(* Get the model packet of the intermediate container. *)
							intermediateContainerPacket=If[MatchQ[intermediateContainer, ObjectP[Model[Container]]],
								fetchPacketFromFastAssoc[intermediateContainer, fastAssoc],
								fastAssocPacketLookup[fastAssoc, intermediateContainer, Model]
							];

							(* Get the aperture of our intermediate container. *)
							(* NOTE: Vessels have this number under Aperture, Plates have it under WellDiameter. *)
							intermediateContainerAperture=If[MatchQ[Lookup[intermediateContainerPacket, Aperture], DistanceP],
								Lookup[intermediateContainerPacket, Aperture],
								Lookup[intermediateContainerPacket, WellDiameter]
							];

							(* resolve FunnelType based on State of Sample *)
							(* if instrument is GraduatedCylinder, also resolve to Wet *)
							funnelType=Which[
								MatchQ[Lookup[sourcePacket, State], Solid],
								Dry,

								MatchQ[Lookup[sourcePacket, State], Liquid]||MatchQ[instrument, ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}]],
								Wet,

								True,
								{Wet,Dry}
							];

							(* Get the first funnel that can fit into our intermediate container. *)
							FirstOrDefault[
								compatibleFunnels[
									allFunnelPackets,
									IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials],
									Aperture->intermediateContainerAperture,
									FunnelType->funnelType
								]
							]
						],
					(* Otherwise, we don't need a funnel. *)
					True,
						Null
				];

				(* Resolve Balance *)
				(* If we're doing this transfer gravimetrically (Amount->MassP) we NEED a balance. *)
				(* Otherwise, we should not be using a balance. *)
				balance=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, Balance], Except[Automatic]],
						Lookup[options, Balance],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					MatchQ[convertedAmount, MassP|CountP],
						Module[{potentialBalances},
							(* NOTE: This takes into account both container weight and availability in the resolved transfer environment. *)
							potentialBalances=compatibleBalanceModels[IgnoreTransferEnvironmentAvailability->False];

							(* If we have compatible balances, use those. However, if we don't just resolve to some reasonable balance *)
							(* and we'll yell about the fact that we can't pick it in the specified transfer environment later. *)
							If[Length[potentialBalances]>0,
								FirstOrDefault[potentialBalances],
								FirstOrDefault[compatibleBalanceModels[IgnoreTransferEnvironmentAvailability->True]]
							]
						],
					(* Otherwise, we don't need a balance. *)
					True,
						Null
				];

				(* once we resolve the Balance option, filter out the Microbalance handling stations, if we do not need to use Microbalance *)
				semiResolvedHandlingConditions = If[
					(* if we need to use a Microbalance, do nothing *)
					MatchQ[
						If[MatchQ[balance, ObjectP[Model[Instrument, Balance]]],
							fastAssocLookup[fastAssoc, balance, Mode],
							fastAssocLookup[fastAssoc, balance, {Model, Mode}]
						],
						Micro
					],
					semiResolvedHandlingConditions,
					(* otherwise filter out the micro balance handling stations *)
					Lookup[
						DeleteCases[
							fetchPacketFromFastAssoc[#, fastAssoc]& /@ semiResolvedHandlingConditions,
							KeyValuePattern[{BalanceType -> _?(MemberQ[#, Micro]&)}]
						],
						Object,
						{}
					]
				];

				(* update the transfer environment based on the updated handling condition *)
				semiResolvedTransferEnvironment = UnsortedIntersection[ToList[semiResolvedTransferEnvironment], getHandlingStations[semiResolvedHandlingConditions]];

				balanceCleaningMethod = Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, BalanceCleaningMethod], Except[Automatic]],
					Lookup[options, BalanceCleaningMethod],

					(* is a BalancePreCleaningMethod specified as either Wet or Dry?*)
					MatchQ[Lookup[options, BalancePreCleaningMethod], Wet|Dry],
					Lookup[options, BalancePreCleaningMethod],

					(* is a BalancePreCleaningMethod specified as None or not specified, but a balance is required?*)
					MatchQ[balance,ObjectP[]],
					Wet,

					(* no balance *)
					True,
					Null
				];

				(* Resolve Tolerance *)
				(* Default to 5*ParticleWeight, 2X the balance resolution, or suppliedAmount/100. Whichever is largest. *)
				tolerance=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, Tolerance], Except[Automatic]],
						Lookup[options, Tolerance],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					MatchQ[balance, Except[Null]] && !MatchQ[amount, All], (* Tolerance should not be specified for All. *)
						Max[{
							If[MatchQ[Lookup[sourcePacket, ParticleWeight], MassP],
								5 * Lookup[sourcePacket, ParticleWeight],
								Nothing
							],
							If[MatchQ[balance, ObjectP[Model[Instrument, Balance]]],
								2 * fastAssocLookup[fastAssoc, balance, Resolution],
								2 * fastAssocLookup[fastAssoc, balance, {Model, Resolution}]
							],
							N[convertedAmountAsMass/100]
						}],
					True,
						Null
				];

				(* Resolve Hand Pump *)
				handPump=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, HandPump], Except[Automatic]],
						Lookup[options, HandPump],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					(* Otherwise: *)
					And[
						(* can the source container fit the pump? *)
						Lookup[sourceContainerModelPacket, Aperture]>Quantity[50.`, "Millimeters"],
						(* Is the source in a container with a MaxVolume over 5L AND *)
						MatchQ[Lookup[sourceContainerModelPacket, MaxVolume], GreaterEqualP[5 Liter]],
						Or[
							(* The transfer instrument is a graduated cylinder OR *)
							MatchQ[instrument, ObjectP[{Object[Container, GraduatedCylinder], Model[Container, GraduatedCylinder]}]],
							(* An intermediate decant was specified *)
							MatchQ[intermediateDecant, True]
						]
					],
						Model[Part, HandPump, "id:L8kPEjNLDld6"],
					True,
						Null
				];

				(* with the balance fully resolved, we can resolve the transfer environment now! Note that we do not try to resolve to the same transfer environment as the previous one in the options resolver just yet, we do it in resource packet so we can get the longest list of grouping *)
				{transferEnvironment, equivalentTransferEnvironments} = Which[
					(* if we are provided with a TransferEnvironment and EquivalentTransferEnvironments, this means we are being called inside MSP, just fast track taking these values *)
					MatchQ[Lookup[options, TransferEnvironment], Except[Automatic]] && MatchQ[Lookup[options, EquivalentTransferEnvironments], Except[Automatic]],
						{Lookup[options, TransferEnvironment], ToList[Lookup[options, EquivalentTransferEnvironments]]},
					(* if we are given a TransferEnvironment, respect the input *)
					NullQ[Lookup[options, TransferEnvironment]],
						{Lookup[options, TransferEnvironment], {}},
					MatchQ[Lookup[options, TransferEnvironment], Except[Automatic]],
						{Lookup[options, TransferEnvironment], {Lookup[options, TransferEnvironment]}},
					(* No TransferEnvironment when Robotic. *)
					MatchQ[resolvedPreparation, Robotic],
						{Null, {}},
					(* do extra filtering only for automatic resolution *)
					True,
						Module[{balanceFiltered, pipetteFiltered, handPumpFiltered},

							(* if we cannot semi-resolve a transfer environment, log an error, return early *)
							If[MatchQ[semiResolvedTransferEnvironment, {}],
								(
									AppendTo[noTransferEnvironmentAvailableErrors, {manipulationIndex, Lookup[sourcePacket, Object], Lookup[destinationPacket, Object], DeleteDuplicates[transferEnvironmentResolutionStrings]}];
									Return[{Null, {}}, Module]
								);
							];

							(* if we do not need a balance, then no need to do the filtering *)
							balanceFiltered = If[NullQ[balance],
								ToList[semiResolvedTransferEnvironment],
								(* call the helper to get the transfer environment that has the resolved balance on it *)
								(* use UnsortedIntersection so our preference for the handling condition remains *)
								UnsortedIntersection[
									ToList[semiResolvedTransferEnvironment],
									Flatten[Values[Lookup[balanceHandlingStationLookup["Memoization"], Download[balance, Object], <||>]]]
								]
							];

							(* if we cannot semi-resolve a transfer environment b/c of balance, add to the string, log an error, return early *)
							If[MatchQ[balanceFiltered, {}],
								(
									AppendTo[transferEnvironmentResolutionStrings, "Balance"];
									AppendTo[noTransferEnvironmentAvailableErrors, {manipulationIndex, Lookup[sourcePacket, Object], Lookup[destinationPacket, Object], DeleteDuplicates[transferEnvironmentResolutionStrings]}];
									Return[{Null, {}}, Module]
								)
							];

							(* if we need a pipette, then make sure we also ask for a handling station with pipette camera on it *)
							pipetteFiltered = If[
								Or[
									MatchQ[instrument, ObjectP[Object[Instrument, Pipette]]] && MatchQ[fastAssocLookup[fastAssoc, instrument, {Model, PipetteType}], Micropipette | PositiveDisplacement],
									MatchQ[instrument, ObjectP[Model[Instrument, Pipette]]] && MatchQ[fastAssocLookup[fastAssoc, instrument, PipetteType], Micropipette | PositiveDisplacement]
								],
								Select[
									balanceFiltered,
									(
										Or[
											(* object - check if the object has pipette camera field populated *)
											MatchQ[#, ObjectP[Object[Instrument, HandlingStation]]] && MatchQ[fastAssocLookup[fastAssoc, #, PipetteCamera], ObjectP[]],
											(* model - check if the first non-developer object of this model has pipette camera field populated *)
											MatchQ[#, ObjectP[Model[Instrument, HandlingStation]]] && MemberQ[fastAssocPacketLookup[fastAssoc, #, Objects], KeyValuePattern[{Status -> Except[Retired], DeveloperObject -> Except[True], PipetteCamera -> ObjectP[]}]]
										]
									)&
								],
								balanceFiltered
							];

							(* if we cannot find a handling station with pipette camera but we are doing transfer inside, do not filter, it is still okay to do transfer, just that we do not have the pipette dial recordings and that's it *)
							If[MatchQ[pipetteFiltered, {}],
								pipetteFiltered = balanceFiltered
							];

							handPumpFiltered = Module[{carboyHandlingStations},
								(* the list is hardcoded unfortunately *)
								carboyHandlingStations = If[fumeHoodRequested,
									(* Model[Instrument, HandlingStation, FumeHood, "Fume Hood Handling Station with Carboy Pumping Integrations"] *)
									{Model[Instrument, HandlingStation, FumeHood, "id:vXl9j5WkxMXB"]},
									(* Model[Instrument, HandlingStation, Ambient, "Benchtop Handling Station with Carboy Pumping Integrations"] *)
									{Model[Instrument, HandlingStation, Ambient, "id:mnk9jOJqoOaK"]}
								];

								(* if we are using hand pump, make sure we redirect to use carboy handling stations *)
								If[MatchQ[handPump, ObjectP[]],
									UnsortedIntersection[
										pipetteFiltered,
										carboyHandlingStations
									],
									(* otherwise, make sure we do not request it *)
									UnsortedComplement[
										pipetteFiltered,
										carboyHandlingStations
									]
								]
							];

							(* if we need a carboy handling station, but we cannot use it, log an error *)
							If[MatchQ[handPumpFiltered, {}],
								(
									AppendTo[transferEnvironmentResolutionStrings, "Carboy"];
									AppendTo[noTransferEnvironmentAvailableErrors, {manipulationIndex, Lookup[sourcePacket, Object], Lookup[destinationPacket, Object], transferEnvironmentResolutionStrings}];
									Return[{Null, {}}, Module]
								)
							];


							(* return *)
							{First[handPumpFiltered], handPumpFiltered}
						]
				];

				(* fully resolve the handling condition too *)
				(* if we have a list of HandlingCondition being passed down, that means we are being called inside MSP, just use that value directly without doing any additional check, we've done it already *)
				(* this is a hidden option so in theory there is no way user would have provided this value *)
				handlingConditions = If[MatchQ[Lookup[options, HandlingCondition], Except[Automatic]],
					ToList[Lookup[options, HandlingCondition]],
					Module[{providedHandlingConditions},
						providedHandlingConditions = Flatten[Map[
							Switch[# ,
								ObjectP[Object[Instrument, HandlingStation]],
									fastAssocLookup[fastAssoc, #, {Model, ProvidedHandlingConditions}],
								ObjectP[Model[Instrument, HandlingStation]],
									fastAssocLookup[fastAssoc, #, ProvidedHandlingConditions],
								_,
									{}
							]&,
							equivalentTransferEnvironments
						]];
						(* use UnsortedIntersection so our preference for the handling condition remains *)
						UnsortedIntersection[semiResolvedHandlingConditions, DeleteDuplicates[Download[providedHandlingConditions, Object]]]
					]];

				(* log some error states *)
				(* if we have resolved transfer environment to be an object, but handling condtion to be Null, we are in an error state!
				 this is usually caused by user specifies a transfer environment that do not provide a suitable handling condition for our transfer *)
				If[MatchQ[transferEnvironment, ObjectP[]] && MatchQ[resolvedPreparation, Manual] && Length[handlingConditions] == 0 && Length[transferEnvironmentResolutionStrings] > 0,
					AppendTo[invalidTransferEnvironmentErrors, {manipulationIndex, transferEnvironment, transferEnvironmentResolutionStrings}]
				];

				(* resolve backfill gas after we resolve the handling condition *)
				backfillGas = Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, BackfillGas], Except[Automatic]],
						Lookup[options, BackfillGas],
					(* If the source container is hermetic and we're not unsealing it, we must perform a backfill. *)
					(* set to Nitrogen if transfer environment supports Nitrogen backfilling *)
					MatchQ[Lookup[sourceContainerPacket, Hermetic], True] && MatchQ[unsealHermeticSource, False] && MemberQ[fastAssocLookup[fastAssoc, #, NitrogenHermeticTransfer]& /@ handlingConditions, True],
						Nitrogen,
					(* set to Argon if transfer environment supports Argon backfilling *)
					MatchQ[Lookup[sourceContainerPacket, Hermetic], True] && MatchQ[unsealHermeticSource, False] && MemberQ[fastAssocLookup[fastAssoc, #, ArgonHermeticTransfer]& /@ handlingConditions, True],
						Argon,
					(* Do not backfill. *)
					True,
						Null
				];

				(* Resolve Reverse Pipetting *)
				reversePipetting=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, ReversePipetting], Except[Automatic]],
						Lookup[options, ReversePipetting],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					(* If we're pipetting, set it to True if the ReversePipetting field is set to True. *)
					MatchQ[instrument, ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]],
						If[MatchQ[Lookup[sourcePacket, ReversePipetting], True] || MatchQ[Lookup[destinationPacket, ReversePipetting], True],
							True,
							False
						],
					(* Otherwise, set it to Null. *)
					True,
						Null
				];

				(* Resolve Magnetization *)
				magnetization=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, Magnetization], Except[Automatic]],
						Lookup[options, Magnetization],
					(* If MagnetizationTime or MaxMagnetizationTime are set, use a magnet. *)
					MatchQ[Lookup[options, MagnetizationTime], TimeP] || MatchQ[Lookup[options, MaxMagnetizationTime], TimeP],
						True,
					(* Otherwise, set it to Null. *)
					True,
						False
				];

				(* Resolve MagnetizationTime *)
				magnetizationTime=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, MagnetizationTime], Except[Automatic]],
						Lookup[options, MagnetizationTime],
					(* If Magnetization->True, default to 15 Second. *)
					MatchQ[magnetization, True],
						15 Second,
					(* Otherwise, set it to Null. *)
					True,
						Null
				];

				(* Resolve MaxMagnetizationTime *)
				maxMagnetizationTime=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, MaxMagnetizationTime], Except[Automatic]],
						Lookup[options, MaxMagnetizationTime],
					(* If Preparation->Robotic, default to Null *)
					MatchQ[resolvedPreparation,Robotic],
						Null,
					(* If Magnetization->True, default to 1 Minute. *)
					MatchQ[magnetization, True],
						1 Minute,
					(* Otherwise, set it to Null. *)
					True,
						Null
				];

				(* Resolve MagnetizationRack *)
				magnetizationRack=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, MagnetizationRack], Except[Automatic]],
						Lookup[options, MagnetizationRack],
					(* If Magnetization->True, use a compatible rack. *)
					MatchQ[magnetization, True]&&MatchQ[resolvedPreparation,Manual],
						FirstOrDefault[
							compatibleMagneticRacks[workingSourceContainerModelPacket, allRackModelPackets]
						],
					(* If Magnetization->True, and Preparation -> Robotic *)
					MatchQ[magnetization,True]&&MatchQ[resolvedPreparation,Robotic],
					Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"],(*Model[Item,MagnetizationRack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"*)
					(* Otherwise, set it to Null. *)
					True,
						Null
				];

				(* Resolve Supernatant *)
				supernatant=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, Supernatant], Except[Automatic]],
						Lookup[options, Supernatant],
					(* Is AspirationLayer set to 1 (the top)? *)
					MatchQ[Lookup[options, AspirationLayer], 1],
						True,
					(* Is Magnetization->True and are we dealing with a liquid? *)
					MatchQ[magnetization, True] && MatchQ[Lookup[sourcePacket, State], Liquid],
						True,
					(* Are we dealing with a liquid? *)
					MatchQ[Lookup[sourcePacket, State], Liquid],
						False,
					(* Should hide itself for non-liquids. *)
					True,
						Null
				];

				(* Resolve AspirationLayer *)
				aspirationLayer=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, AspirationLayer], Except[Automatic]],
						Lookup[options, AspirationLayer],
					(* Is supernatant set to True when Preparation is Manual? *)
					MatchQ[supernatant, True]&&MatchQ[resolvedPreparation, Manual],
						1,
					(* Otherwise, Null. *)
					True,
						Null
				];

				(* Resolve Quantitative Transfer *)
				quantitativeTransfer=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, QuantitativeTransfer], Except[Automatic]],
						Lookup[options, QuantitativeTransfer],
					MatchQ[resolvedPreparation, Robotic],
						Null,
					(* If any of the other quantitative transfer options are set, resolve to True. *)
					MemberQ[
						Lookup[
							options,
							{
								QuantitativeTransferWashSolution,
								QuantitativeTransferWashVolume,
								QuantitativeTransferWashInstrument,
								QuantitativeTransferWashTips,
								NumberOfQuantitativeTransferWashes
							}
						],
						Except[Automatic|Null]
					],
						True,
					(* If we're NOT using a weighingContainer OR if the weighingContainer is a weigh paper, set to False. *)
					(* Weighing Paper are Item,Consumable while Weigh Boats are Item,WeighBoat *)
					MatchQ[weighingContainer, ObjectP[Model[Item, Consumable],Model[Item, Consumable]]|Null],
						False,
					(* Otherwise, does not apply. *)
					True,
						Null
				];

				quantitativeTransferWashSolution=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, QuantitativeTransferWashSolution], Except[Automatic]],
						Lookup[options, QuantitativeTransferWashSolution],
					(* Default to water if we're quant transferring. *)
					MatchQ[quantitativeTransfer, True],
						$DefaultQuantitativeTransferWashSolution, (* Model[Sample, "Milli-Q water"] *)
					(* Otherwise, Null. *)
					True,
						Null
				];

				quantitativeTransferWashVolume=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, QuantitativeTransferWashVolume], Except[Automatic]],
						Lookup[options, QuantitativeTransferWashVolume],
					(* If we're quant transferring, default to lesser of volume of the weighing container or 5 mL *)
					(* Limit to max of 5 mL so we only use Micropipette for wash. Serological pipette is not easy to use for quantitative transfer wash *)
					MatchQ[quantitativeTransfer, True],
						Module[{weighingContainerModelPacket},
							(* Get the model of the weighing container. *)
							weighingContainerModelPacket=Which[
								MatchQ[weighingContainer, ObjectP[Object[]]],
								fastAssocPacketLookup[fastAssoc, weighingContainer, Model],

								MatchQ[weighingContainer, ObjectP[Model[]]],
								fetchPacketFromFastAssoc[weighingContainer, fastAssoc],

								True,
								Null
							];

							Which[
								(* if a Model[Item,Consumable], set to 5 mL to allow resolution. An error is thrown later for IncompatibleQuantitativeTransferWeighingContainer *)
								MatchQ[weighingContainerModelPacket,ObjectP[Model[Item,Consumable]]],
								5 Milliliter,

								(* Resolve to max volume of weighing container or 5 mL, whichever is smallest *)
								MatchQ[weighingContainerModelPacket,ObjectP[]],
								Min[Lookup[weighingContainerModelPacket, MaxVolume], 5 Milliliter],

								(* default to 5mL if no weighingContainerModelPacket is found, error due to lack of weighing container is thrown later *)
								True,
								5 Milliliter
							]
						],
					(* Otherwise, Null. *)
					True,
						Null
				];

				numberOfQuantitativeTransferWashes=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, NumberOfQuantitativeTransferWashes], Except[Automatic]],
						Lookup[options, NumberOfQuantitativeTransferWashes],
					(* Default to 3 if we're doing this. *)
					MatchQ[quantitativeTransfer, True],
						3,
					(* Otherwise, Null. *)
					True,
						Null
				];

				quantitativeTransferWashTips=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, QuantitativeTransferWashTips], Except[Automatic]],
						Lookup[options, QuantitativeTransferWashTips],
					(* pick Tips if we are doing quantitative transfer *)
					MatchQ[quantitativeTransfer, True] && MatchQ[quantitativeTransferWashVolume, VolumeP],
						Module[{potentialTips,washSolutionContainerModelPacket,containerCompatibleTips},
							(* Get the tips that we should use. *)
							(* TransferDevices gives us results in a preferential order. SortBy uses evaluated PipetteType and returns Micropipette ahead of Serological *)
							potentialTips=TransferDevices[Model[Item, Tips], quantitativeTransferWashVolume,PipetteType->Micropipette][[All,1]];

							(* Importantly, we assume that the tips can reach the bottom of the container is we're the one picking the container. *)
							(* This is because the wash solution will always be in a preferred container if we're picking (via the resource system). *)
							(* And unless there are hella number of washes and we're consolidating, the size of the container should be around the *)
							(* amount that we're washing with. *)

							(* This may not be true if the user gave us the wash solution in another container. *)
							washSolutionContainerModelPacket=Switch[quantitativeTransferWashSolution,
								ObjectP[Model[Sample]],
									Null,
								ObjectP[Object[Sample]],
									fastAssocPacketLookup[fastAssoc, quantitativeTransferWashSolution, {Container, Model}]
							];

							(* These tips can hold the volume and meet the required TipType/TipMaterial -- but make sure that they can reach the bottom of the container. *)
							containerCompatibleTips=If[MatchQ[washSolutionContainerModelPacket, Except[Null]],
								Select[
									potentialTips,
									(tipsCanAspirateQ[
										#,
										washSolutionContainerModelPacket,
										sourceAmountAsVolume,
										convertedAmountAsVolume,
										allTipModelPackets,
										allVolumeCalibrationPackets
									]&)
								],
								potentialTips
							];

							(* If there are no tips that can reach the bottom of the container, then just pick the most preferential given back by TransferDevices *)
							(* and we'll tell the operator to tilt the container a bit in the instructions. *)
							If[Length[containerCompatibleTips]==0,
								FirstOrDefault[potentialTips],
								FirstOrDefault[containerCompatibleTips]
							]
						],
					(* Otherwise, Null. *)
					True,
						Null
				];

				quantitativeTransferWashTipsModel = If[MatchQ[quantitativeTransferWashTips,ObjectP[Object[Item]]],
					fastAssocLookup[fastAssoc,quantitativeTransferWashTips,Model],
					quantitativeTransferWashTips
				];

				quantitativeTransferWashInstrument=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, QuantitativeTransferWashInstrument], Except[Automatic]],
						Lookup[options, QuantitativeTransferWashInstrument],
					(* Pick a pipette from our tips *)
					MatchQ[quantitativeTransfer, True] && MatchQ[quantitativeTransferWashTips, Except[Null]],
						Module[{tipsModel, potentialPipettes},
							(* Convert our tips to a model. *)
							tipsModel=If[MatchQ[quantitativeTransferWashTips, ObjectP[Object[Item, Tips]]],
								fastAssocLookup[fastAssoc, quantitativeTransferWashTips, Model],
								quantitativeTransferWashTips
							];

							(* Get all pipettes that can perform our transfer. *)
							potentialPipettes=compatiblePipettes[
								tipsModel,
								allTipModelPackets,
								allPipetteModelPackets,
								quantitativeTransferWashVolume,
								SterileTechnique -> sterileTechnique,
								CultureHandling->cultureHandling,
								GloveBoxStorage->MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]]
							];

							(* Pick the first one. *)
							FirstOrDefault[potentialPipettes]
						],
					(* Otherwise, Null. *)
					True,
						Null
				];

				quantitativeTransferWashInstrumentModel = If[MatchQ[quantitativeTransferWashInstrument,ObjectP[Object[Instrument]]],
					fastAssocLookup[fastAssoc,quantitativeTransferWashInstrument,Model],
					quantitativeTransferWashInstrument
				];

				(* -- Resolve Transfer Temperature Options -- *)
				(* NOTE: Importantly we do NOT want to set the TransferTemperature to non-Ambient if the TransportTemperature *)
				(* is non-Ambient. TransferTemperature should ONLY be set if given by the user or set in the TransferTemperature field. *)
				sourceTemperature=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, SourceTemperature], Except[Automatic]],
						Lookup[options, SourceTemperature],
					(* Is the transfer occurring in the glove box? If so, then we can't have a hot/cold transfer. *)
					MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]],
						Ambient,
					(* Is the TransferTemperature field set in the sample? *)
					MatchQ[Lookup[sourcePacket, TransferTemperature], TemperatureP],
						Lookup[sourcePacket, TransferTemperature],
					(* Otherwise, set to Ambient. *)
					True,
						Ambient
				];

				sourceEquilibrationTime=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, SourceEquilibrationTime], Except[Automatic]],
						Lookup[options, SourceEquilibrationTime],
					(* Is SourceTemperature set? *)
					MatchQ[sourceTemperature, Except[Ambient]],
						5 Minute,
					(* Don't set it. *)
					True,
						Null
				];

				maxSourceEquilibrationTime=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, MaxSourceEquilibrationTime], Except[Automatic]],
						Lookup[options, MaxSourceEquilibrationTime],
					(* Is SourceTemperature set? *)
					MatchQ[sourceTemperature, Except[Ambient]],
						30 Minute,
					(* Don't set it. *)
					True,
						Null
				];

				sourceEquilibrationCheck=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, SourceEquilibrationCheck], Except[Automatic]],
						Lookup[options, SourceEquilibrationCheck],
					(* Is SourceTemperature set? *)
					MatchQ[sourceTemperature, Except[Ambient]],
					IRThermometer,
					(* Don't set it. *)
					True,
					Null
				];

				(* NOTE: Importantly we do NOT want to set the TransferTemperature to non-Ambient if the TransportTemperature *)
				(* is non-Ambient. TransferTemperature should ONLY be set if given by the user or set in the TransferTemperature field. *)
				destinationTemperature=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, DestinationTemperature], Except[Automatic]],
						Lookup[options, DestinationTemperature],
					(* Is the transfer occurring in the glove box? If so, then we can't have a hot/cold transfer. *)
					MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]],
						Ambient,
					(* Is the TransferTemperature field set in the sample? *)
					MatchQ[Lookup[destinationPacket, TransferTemperature], TemperatureP],
						Lookup[destinationPacket, TransferTemperature],
					(* Otherwise, set to Ambient. *)
					True,
						Ambient
				];

				destinationEquilibrationTime=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, DestinationEquilibrationTime], Except[Automatic]],
						Lookup[options, DestinationEquilibrationTime],
					(* Is SourceTemperature set? *)
					MatchQ[destinationTemperature, Except[Ambient]],
						5 Minute,
					(* Don't set it. *)
					True,
						Null
				];

				maxDestinationEquilibrationTime=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, MaxDestinationEquilibrationTime], Except[Automatic]],
						Lookup[options, MaxDestinationEquilibrationTime],
					(* Is SourceTemperature set? *)
					MatchQ[destinationTemperature, Except[Ambient]],
						30 Minute,
					(* Don't set it. *)
					True,
						Null
				];

				destinationEquilibrationCheck=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, DestinationEquilibrationCheck], Except[Automatic]],
						Lookup[options, DestinationEquilibrationCheck],
					(* Is SourceTemperature set? *)
					MatchQ[destinationTemperature, Except[Ambient]],
					IRThermometer,
					(* Don't set it. *)
					True,
					Null
				];

				coolingTime=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, CoolingTime], Except[Automatic]],
					Lookup[options, CoolingTime],
					(* Is SourceTemperature set, and are we transferring media? *)
					MatchQ[sourceTemperature, Except[Ambient]]&&MatchQ[Lookup[sourcePacket, Model],ObjectP[Model[Sample,Media]]],
					10*Minute,
					(* Don't set it. *)
					True,
					Null
				];

				solidificationTime=If[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, SolidificationTime], Except[Automatic]],
						Lookup[options, SolidificationTime],

						(* otherwise, just Null *)
						Null
				];

				flameDestination=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, FlameDestination], Except[Automatic]],
						Lookup[options, FlameDestination],

					(* Is SourceTemperature set, and are we transferring media? *)
					MatchQ[sourceTemperature, Except[Ambient]]&&MatchQ[Lookup[sourcePacket, Model],ObjectP[Model[Sample,Media]]],
						True,

					(* False otherwise *)
					True,
						False
				];

				parafilmDestination=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, ParafilmDestination], Except[Automatic]],
						Lookup[options, ParafilmDestination],

					(* Is SourceTemperature set, and are we transferring media? *)
					MatchQ[sourceTemperature, Except[Ambient]]&&MatchQ[Lookup[sourcePacket, Model],ObjectP[Model[Sample,Media]]],
						True,

					(* False otherwise *)
					True,
						False
				];

				sourceContainerCover = Lookup[sourceContainerPacket, Cover, Null];

				(* -- Resolve the hidden AllowSourceContainerReCover option -- *)
				allowSourceContainerReCover = Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, AllowSourceContainerReCover], Except[Automatic]],
						Lookup[options, AllowSourceContainerReCover],
					(* Set to False if we have an Ampoule. *)
					MatchQ[Lookup[sourceContainerPacket, Ampoule], True],
						False,
					(* Set to False if we have the cover type of crimped, and we are unsealing it instead of using syringe to extract, and we are inside a BSC. *)
					And[
						MatchQ[sourceContainerCover, ObjectP[Object]],
						MatchQ[fastAssocLookup[fastAssoc, Download[sourceContainerCover,Object], {Model, CoverType}], Crimp],
						unsealHermeticSource,
						MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]]
					],
						False,
					(* Otherwise allow it to be recovered *)
					True,
						True
				];

				(* Resolve Overdraw Volume for syringe transfers *)
				overdrawVolume = Which[
					(* if we aren't doing a syringe transfer, we don't need an overdraw volume *)
					MatchQ[needle, Null] && !MatchQ[fastAssocLookup[fastAssoc, suppliedInstrument[[manipulationIndex]], ConnectionType], Alternatives[Fused, {Fused}, {Fused..}]],
					Null,
					(* if there is a separate needle, need to caculate overdraw amount based on needle volume *)
					MatchQ[needle, ObjectP[{Object[Item, Needle], Model[Item, Needle]}]],
						Module[{needleModel, suppliedInstrumentModel, instrumentModel, needleInnerDiameter, needleHeight, syringeResolution},
							needleModel = If[MatchQ[needle, ObjectP[Model[Item, Needle]]],
								needle,
								fastAssocLookup[fastAssoc, needle, Model]
							];
							suppliedInstrumentModel = If[MatchQ[suppliedInstrument[[manipulationIndex]], ObjectP[Model[Container]]],
								suppliedInstrument[[manipulationIndex]],
								fastAssocLookup[fastAssoc, suppliedInstrument[[manipulationIndex]], Model]
							];
							instrumentModel = If[MatchQ[instrument, ObjectP[Model[Container]]],
								instrument,
								fastAssocLookup[fastAssoc, instrument, Model]
							];
							(* pull out values needed to calculate needle internal volume *)
							needleInnerDiameter = fastAssocLookup[fastAssoc, needleModel, InnerDiameter];
							needleHeight = fastAssocLookup[fastAssoc, needleModel, NeedleLength];
							(* pull out the syringe resolution to round to a reasonable value *)
							syringeResolution = Which[
								MatchQ[suppliedInstrument[[manipulationIndex]], ObjectP[{Object[Container, Syringe], Model[Container, Syringe]}]],
								fastAssocLookup[fastAssoc, suppliedInstrumentModel, Resolution],
								MatchQ[instrument, ObjectP[{Object[Container, Syringe], Model[Container, Syringe]}]],
								fastAssocLookup[fastAssoc, instrumentModel, Resolution]
							];
							(* calculate the overdraw volume for the transfer *)
							(* added syringe resolution in final overdraw amount because if the needle volume is below that of syringe resolution, it will round to zero and not give any additional volume to overdraw by *)
							SafeRound[Convert[Pi * (needleInnerDiameter / 2)^2 * needleHeight, Milliliter] + convertedAmountAsVolume + syringeResolution, syringeResolution]
						],
					(* if the needle is fused to the syringe, use the syringe's dead volume as the overdraw amount *)
					(* this is assuming that the choice to use a fused syringe will always be specified - otherwise we default to transfer via micropipette *)
					MatchQ[fastAssocLookup[fastAssoc, suppliedInstrument[[manipulationIndex]], ConnectionType], Alternatives[Fused, {Fused}, {Fused..}]],
						Module[{syringeModel, syringeResolution, deadVolume},
							syringeModel = If[MatchQ[suppliedInstrument[[manipulationIndex]], ObjectP[Model[Container, Syringe]]],
								suppliedInstrument[[manipulationIndex]],
								fastAssocLookup[fastAssoc, suppliedInstrument[[manipulationIndex]], Model]
							];
							syringeResolution = fastAssocLookup[fastAssoc, syringeModel, Resolution];
							deadVolume = fastAssocLookup[fastAssoc, syringeModel, DeadVolume];
							SafeRound[deadVolume + convertedAmountAsVolume + syringeResolution, syringeResolution]
						],
					True,
					Null
				];

				(* -- Resolve the Cover Options -- *)
				keepSourceCovered = Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, KeepSourceCovered], Except[Automatic]],
						Lookup[options, KeepSourceCovered],
					(* Are we doing this manually and if so, is UnsealHermeticSource not set to True? *)
					MatchQ[resolvedPreparation, Manual] && MatchQ[unsealHermeticSource, Except[True]],
						True,
					(* Are we doing this robotically and is KeepCovered set in the source sample or container, or is SterileTechnique already True? *)
					And[
						MatchQ[resolvedPreparation, Robotic],
						Or[
							MatchQ[Lookup[sourcePacket, KeepCovered], True],
							MatchQ[Lookup[sourceContainerPacket, KeepCovered], True],
							sterileTechnique
						]
					],
						True,
					(* Don't set it. *)
					True,
						False
				];

				replaceSourceCover=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, ReplaceSourceCover], Except[Automatic]],
						Lookup[options, ReplaceSourceCover],
					(* Are any other source cover options set? *)
					MemberQ[Lookup[options, {SourceCover, SourceSeptum, SourceStopper}], Except[Automatic|Null]],
						True,
					(* Are we allowing the container to be re-covered? *)
					MatchQ[allowSourceContainerReCover, False],
						False,
					(* Are we hermetically unsealing the source? *)
					MatchQ[unsealHermeticSource, True],
						True,
					(* Don't set it. *)
					True,
						False
				];

				{sourceCover, sourceSeptum, sourceStopper, allCoverTests}=Which[
					(* If there is a mismatch in options, record it and resolve any Automatics to Null. *)
					Or[
						MatchQ[replaceSourceCover, True] && MemberQ[Lookup[options, {SourceCover, SourceSeptum, SourceStopper}], Null],
						MatchQ[replaceSourceCover, False] && MemberQ[Lookup[options, {SourceCover, SourceSeptum, SourceStopper}], ObjectP[]],
						!allowSourceContainerReCover
					],
						Append[Lookup[options, {SourceCover, SourceSeptum, SourceStopper}], {}]/.{Automatic->Null},
					MatchQ[replaceSourceCover, True],
						Module[{resolvedCoverOptions, coverTests, coverCache, coverSimulation},
							coverCache = FlattenCachePackets[{workingSourceSamplePackets, workingSourceContainerPackets, workingSourceContainerModelPackets, workingDestinationSamplePackets, workingDestinationContainerPackets, workingDestinationContainerModelPackets, simulatedCache}];
							coverSimulation = UpdateSimulation[If[NullQ[simulation], Simulation[], simulation], Simulation[coverCache]];
							(* Call ExperimentCover, passing down the options that the user gave us. *)
							(* NOTE: If there are issues, ExperimentCover will throw Error::InvalidInput/InvalidOption for us. *)
							Quiet[
								Check[
									{resolvedCoverOptions, coverTests} = If[gatherTests,
										ExperimentCover[
											sourceContainerObject,
											Cover->Lookup[options, SourceCover],
											Septum->Lookup[options, SourceSeptum],
											Stopper->(Lookup[options, SourceStopper]/.{Automatic->Null}),
											Output-> {Options, Tests},
											(* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
											FastTrack->True,
											Cache->coverCache,
											Simulation -> coverSimulation,
											OptionsResolverOnly -> True
										],
										{
											ExperimentCover[
												sourceContainerObject,
												Cover->Lookup[options, SourceCover],
												Septum->Lookup[options, SourceSeptum],
												Stopper->(Lookup[options, SourceStopper]/.{Automatic->Null}),
												Output-> Options,
												(* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
												FastTrack->True,
												Cache->coverCache,
												Simulation -> coverSimulation,
												OptionsResolverOnly -> True
											],
											{}
										}
									],
									invalidCoverOptions=Append[invalidCoverOptions, {ReplaceSourceCover}],
									{Error::InvalidOption, Error::InvalidInput}
								],
								{Error::InvalidOption, Error::InvalidInput}
							];

							Append[Lookup[resolvedCoverOptions, {Cover, Septum, Stopper}], coverTests]
						],
					True,
						Append[Lookup[options, {SourceCover, SourceSeptum, SourceStopper}], {}]/.{Automatic->Null}
				];

				keepDestinationCovered = Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, KeepDestinationCovered], Except[Automatic]],
						Lookup[options, KeepDestinationCovered],
					(* Are we doing this manually and if so, is UnsealHermeticDestination not set to True? *)
					(* NOTE: We can't keep the destination covered if we're using a balance. *)
					MatchQ[resolvedPreparation, Manual] && MatchQ[unsealHermeticDestination, Except[True]] && !MatchQ[instrument, ObjectP[{Model[Instrument, Balance], Object[Instrument, Balance]}]],
						True,
					(* Are we doing this robotically and is KeepCovered set in the destination sample or container, or is SterileTechnique already True? *)
					And[
						MatchQ[resolvedPreparation, Robotic],
						Or[
							MatchQ[Lookup[destinationPacket, KeepCovered], True],
							MatchQ[Lookup[destinationContainerPacket, KeepCovered], True],
							sterileTechnique
						]
					],
						True,
					(* Don't set it. *)
					True,
						False
				];

				replaceDestinationCover=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, ReplaceDestinationCover], Except[Automatic]],
						Lookup[options, ReplaceDestinationCover],
					(* Are any other destination cover options set? *)
					MemberQ[Lookup[options, {DestinationCover, DestinationSeptum, DestinationStopper}], Except[Automatic|Null]],
						True,
					(* Are we hermetically unsealing the destination? *)
					MatchQ[unsealHermeticDestination, True],
						True,
					(* Don't set it. *)
					True,
						False
				];

				{destinationCover, destinationSeptum, destinationStopper, allCoverTests2}=Which[
					(* If there is a mismatch in options, record it and resolve any Automatics to Null. *)
					Or[
						MatchQ[replaceDestinationCover, True] && MemberQ[Lookup[options, {DestinationCover, DestinationSeptum, DestinationStopper}], Null],
						MatchQ[replaceDestinationCover, False] && MemberQ[Lookup[options, {DestinationCover, DestinationSeptum, DestinationStopper}], ObjectP[]]
					],
						Append[Lookup[options, {DestinationCover, DestinationSeptum, DestinationStopper}], {}]/.{Automatic->Null},
					MatchQ[replaceDestinationCover, True],
						Module[{resolvedCoverOptions, coverTests, coverCache, coverSimulation},

							coverCache = FlattenCachePackets[{workingSourceSamplePackets, workingSourceContainerPackets, workingSourceContainerModelPackets, workingDestinationSamplePackets, workingDestinationContainerPackets, workingDestinationContainerModelPackets, simulatedCache}];
							coverSimulation = UpdateSimulation[If[NullQ[simulation], Simulation[], simulation], Simulation[coverCache]];

							(* Call ExperimentCover, passing down the options that the user gave us. *)
							(* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
							Quiet[
								Check[
									{resolvedCoverOptions, coverTests} = If[gatherTests,
										ExperimentCover[
											destinationContainerObject,
											Cover->Lookup[options, DestinationCover],
											Septum->Lookup[options, DestinationSeptum],
											Stopper->(Lookup[options, DestinationStopper]/.{Automatic->Null}),
											Output-> {Options, Tests},
											(* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered since we don't simulate cover state. *)
											FastTrack->True,
											Cache->coverCache,
											Simulation -> coverSimulation,
											OptionsResolverOnly -> True
										],
										{
											ExperimentCover[
												destinationContainerObject,
												Cover->Lookup[options, DestinationCover],
												Septum->Lookup[options, DestinationSeptum],
												Stopper->(Lookup[options, DestinationStopper]/.{Automatic->Null}),
												Output->Options,
												(* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered since we don't simulate cover state. *)
												FastTrack->True,
												Cache->coverCache,
												Simulation -> coverSimulation,
												OptionsResolverOnly -> True
											],
											{}
										}
									],
									invalidCoverOptions=Append[invalidCoverOptions, {ReplaceDestinationCover}],
									{Error::InvalidOption, Error::InvalidInput}
								],
								{Error::InvalidOption, Error::InvalidInput}
							];

							Append[Lookup[resolvedCoverOptions, {Cover, Septum, Stopper}], coverTests]
						],
					True,
						Append[Lookup[options, {DestinationCover, DestinationSeptum, DestinationStopper}], {}]/.{Automatic->Null}
				];

				(* If we have a mass or volume, make sure that we round the amount according to the precision of the instrument. *)
				{sourceRoundedAmount, roundedAmount, volumePrecisionRoundQ}=If[MatchQ[amount, CountP],
					{Null, amount, False},
					Module[{instrumentPrecision, instrumentType, actualPrecision},
						(* Check that the main transfer instrument and transfer amount. Make sure that the transfer instrument can achieve the resolution that we were given. *)
						instrumentPrecision=Which[
							(* We have a balance and a specific transfer mass. *)
							MatchQ[balance, ObjectP[{Model[Instrument, Balance], Object[Instrument, Balance]}]] && MatchQ[amount, MassP],
								If[MatchQ[balance, ObjectP[{Model[Instrument, Balance]}]],
									fastAssocLookup[fastAssoc, balance, Resolution],
									fastAssocLookup[fastAssoc, balance, {Model, Resolution}]
								],
							(* We have a graduated cylinder and a volume. *)
							MatchQ[instrument, ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}]] && MatchQ[amount, VolumeP] && MatchQ[Lookup[destinationContainerModelPacket,Object],Except[ObjectP[{Object[Container,Vessel,VolumetricFlask],Model[Container,Vessel,VolumetricFlask]}]]],
								If[MatchQ[instrument, ObjectP[{Model[Container,GraduatedCylinder]}]],
									fastAssocLookup[fastAssoc, instrument, Resolution],
									fastAssocLookup[fastAssoc, instrument, {Model, Resolution}]
								],
							(* We have a pipette and a volume. *)
							MatchQ[instrument, ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]] && MatchQ[amount, VolumeP],
								If[MatchQ[instrument, ObjectP[{Model[Instrument, Pipette]}]],
									fastAssocLookup[fastAssoc, instrument, Resolution],
									fastAssocLookup[fastAssoc, instrument, {Model, Resolution}]
								],
							(* Are we using the Hamiltons? *)
							(* https://www.hamiltoncompany.com/automation/case-studies/1000-%CE%BCl-channels-pipetting-specifications *)
							MatchQ[resolvedPreparation, Robotic],
								10^-2 Microliter,
							(* Otherwise, we don't have to care about transfer amount precision. *)
							True,
								Null
						];

						instrumentType=Which[
							(* We have a balance and a specific transfer mass. *)
							MatchQ[balance, ObjectP[{Model[Instrument, Balance], Object[Instrument, Balance]}]] && MatchQ[amount, MassP],
								Model[Instrument, Balance],
							(* We have a graduated cylinder and a volume. *)
							MatchQ[instrument, ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}]] && MatchQ[amount, VolumeP] && MatchQ[Lookup[destinationContainerModelPacket,Object],Except[ObjectP[{Object[Container,Vessel,VolumetricFlask],Model[Container,Vessel,VolumetricFlask]}]]],
								Model[Container, GraduatedCylinder],
							(* We have a pipette and a volume. *)
							MatchQ[instrument, ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]] && MatchQ[amount, VolumeP],
								Model[Item, Tips],
							(* Otherwise, we don't have to care about transfer amount precision. *)
							True,
								Null
						];

						(* tolerance really doesn't have much to do with precision of the target value, it only gives what we should accept as being equal to that value *)
						(* so unless its absolutely necessary, we can just use instrument precision *)
						actualPrecision=Which[
							(* If we have instrument precision, we should round up mass/vol based on it. *)
							(* This is also used to avoid computer roundoff error, such as amount 192.99999ul should be rounded up to 193.00ul(0.01ul instrument precision) if on Hamilton *)
							MatchQ[instrumentPrecision, MassP] || (MatchQ[instrumentPrecision, VolumeP] && MatchQ[amount, VolumeP]),
								instrumentPrecision,
							(* If we are using balance and have tolerance specified, accept the value within tolerance range. *)
							MatchQ[tolerance, MassP],
								tolerance,
							True,
								Null
						];

						{
							(* Round the source Mass/Volume to instrumentPrecision the same way as Amount. *)
							(* This is used to avoid computer roundoff error when doing overaspirationWarnings which checks if source Mass/Volume is less than the required mount. *)
							(* tolerance really doesn't have much to do with source amount, so leave it out. *)
							Which[
								MatchQ[instrumentPrecision, Except[Null]] && MatchQ[amount, VolumeP],
									N[UnitScale[SafeRound[Lookup[sourcePacket, Volume], Rationalize[instrumentPrecision], AvoidZero -> True]]],
								MatchQ[instrumentPrecision, Except[Null]] && MatchQ[amount, MassP],
									N[UnitScale[SafeRound[Lookup[sourcePacket, Mass], Rationalize[instrumentPrecision], AvoidZero -> True]]],
								MatchQ[amount, VolumeP],
									Lookup[sourcePacket, Volume],
								MatchQ[amount, MassP],
									Lookup[sourcePacket, Mass],
								True,
									Null
							],
							(* Round the required Amount to actualPrecision. *)
							If[MatchQ[actualPrecision, Except[Null]],
								(* NOTE: This number comes out of the database so we need to rationalize it for Round to really work. *)
								(* Ironically, it seems like Round is doing a better job than SafeRound. *)
								If[!MatchQ[amount, N@SafeRound[amount, Rationalize[actualPrecision], AvoidZero -> True]],
									(* If it is being changed, also unit scale it so it reads better. *)
									N[UnitScale[SafeRound[amount, Rationalize[actualPrecision], AvoidZero -> True]]],
									If[MatchQ[instrumentType,ObjectP[]],
										Quiet[AchievableResolution[amount,instrumentType],Warning::AmountRounded],
										amount
									]
								],
								If[MatchQ[instrumentType,Except[Null]],
									Quiet[AchievableResolution[amount,instrumentType],Warning::AmountRounded],
									amount
								]
							],
							(* Here we categorize if the volume rounding is from InstrumentPrecision not from instrumentType (such as Hamilton)*)
							MatchQ[instrumentPrecision, VolumeP] && NullQ[instrumentType]
						}
					]
				];

				(* We will use a pill crusher if we have an itemized tablet sample but are transferring it by mass. *)
				pillCrusher=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, TabletCrusher], Except[Automatic]],
					Lookup[options, TabletCrusher],
					MatchQ[amount, MassP] && MatchQ[Lookup[sourcePacket, SampleHandling], Itemized] && TrueQ[Lookup[sourcePacket, Tablet]] && !MatchQ[resolvedPreparation, Robotic],
					Model[Item, TabletCrusher, "id:Y0lXejM894kv"], (*Silent Knight tablet crusher*)
					True,
					Null
				];

				(* We will resolve to not include the pouch for sachet, if we are working with a sachet using scissors and the option is not specified *)
				includeSachetPouch=Which[
					(* Did the user give us a value? *)
					MatchQ[Lookup[options, IncludeSachetPouch], Except[Automatic]],
						Lookup[options, IncludeSachetPouch],
					MatchQ[Lookup[sourcePacket, SampleHandling], Itemized] && TrueQ[Lookup[sourcePacket, Sachet]] && MatchQ[instrument, ObjectP[{Model[Item, Scissors], Object[Item, Scissors]}]],
						False,
					True,
						Null
				];

				(* Resolve the SourceContainer option since we've already done the hard work of resolving the Model[Container] *)
				(* in the case that we were given a Model[Sample] for a source, so just detect that. *)
				sourceContainer=Which[
					(* If the user gave us an option, use that. *)
					MatchQ[Lookup[options, SourceContainer], Except[Automatic]],
						Lookup[options, SourceContainer],
					(* Otherwise, we will need a source container - determined above based on containers sample instances are current in  *)
					(* This can be a list of models *)
					MatchQ[sourceIsModelQ, True] && KeyExistsQ[indexMatchedAllSampleModelContainers,manipulationIndex],
						Lookup[indexMatchedAllSampleModelContainers,manipulationIndex],
					MatchQ[sourceIsModelQ, True],
						sourceContainerModelObject,
					(* Otherwise, Object[Container] since this is a real sample. *)
					True,
						Download[Lookup[sourcePacket, Container], Object]
				];

				sourceSampleGrouping=Lookup[
					indexedSampleModelGroupings,
					manipulationIndex,
					Null
				];

				(* Resolve the LivingDestination option - because this option has a Default, there isn't much resolution to do here	*)
				livingDestination = Lookup[options, LivingDestination];

				(* -- Error check for missing samples, overaspiration and overfilled samples -- *)
				(* Lists to append to: missingSampleErrors, overaspirationWarnings, overfilledErrors *)

				(* Check for non-existent samples. Note that we are not tracking the position here as sourcePackets is <||> and we don't have a sample here to report *)
				If[
					MatchQ[sourcePacket,<||>],
					AppendTo[missingSampleErrors,manipulationIndex]
				];

				(* Check for overaspiration. *)
				Which[
					(* NOTE: If our source is a model, we are the ones that initialized the volume during simulation. *)
					MatchQ[sourceIsModelQ, True],
						Nothing,
					(* For source amount from source packet, we round it up with the same instrument precision as for roundedAmount so we should be fine. *)
					MatchQ[roundedAmount, MassP] && MatchQ[sourceRoundedAmount, LessP[roundedAmount]],
						AppendTo[overaspirationWarnings, {Lookup[sourcePacket, Object], roundedAmount, sourceRoundedAmount, manipulationIndex}],
					MatchQ[roundedAmount, VolumeP] && MatchQ[sourceRoundedAmount, LessP[roundedAmount]],
						AppendTo[overaspirationWarnings, {Lookup[sourcePacket, Object], roundedAmount, sourceRoundedAmount, manipulationIndex}],
					True,
						Null
				];

				(* Check for overfilling. *)
				Which[
					(* don't worry about overfilling in stock solution protocols.  This is because we already will have done checks here *)
					(* in special cases like mixing ethanol and water, we know there is going to be a density change ahead of time such that mixing 50 mL of ethanol and 50 mL of water will give 97 mL of mixture *)
					(* thus, if StockSolution asks for 100 mL, the sum of the components will add up to be greater than 100 mL, and if the MaxVolume of the destination container is 100 mL, it will throw this error even though we are going to be fine *)
					(* StockSolution calls ManualSamplePreparation on its Primitives and then ManualSamplePreparation calls Transfer to do the real liquid handling. There are two cases involved here:
					(1) StockSolution is trying to generate a ManualSamplePreparation subprotocol. During ManualSamplePreparation resolver, we call Transfer to help resolve options. In this case, we pass in ParentProtocol option and use our StockSolution as the option value. We should not give warnings in this case;
					(2) ManualSamplePreparation is successfully generated and then try to call Transfer to generate its own sub. Now the ParentProtocol is from Engine and it is the ManualSamplePreparation. StockSolution is 2 levels up but it is indeed the same case as (1). In this case, our parentProtocolTree actually starts with StockSolution.
					Both should be quieted.
					 *)
					(* so for StockSolution, don't check this *)
					(* NOTE: Use roundedAmount when possible here because if roundedAmount is less than the original convertedAmountAsVolume *)
					(* there are cases where the warning doesn't get thrown (correctly) since it'll really be rounded down. *)
					MatchQ[parentProtocol, ObjectP[Object[Protocol, StockSolution]]],
						Null,
					MatchQ[Flatten[parentProtocolTree], {ObjectP[Object[Protocol, StockSolution]],___}],
						Null,
					(* don't worry about overfilling if we are called from ExperimentFillToVolume *)
					(* This is because in ExperimentFillToVolume, we call ExperimentTransfer with the max possible volumes that we would transfer to FTV. This is important because we want to resolve a good source container that is big enough to hold the full possible amount so that we don't run out of resource during FTV *)
					(* It may be expected that we are going beyond the max volume of the container at this moment, but we will either use volumetric flask or ultrasonic measurement in the protocol to make sure we don't transfer this large amount *)
					TrueQ[Lookup[myOptions, FillToVolume]],
						Null,
					(* NOTE: If the source is the same as the destination, we're not actually adding any volume to the sample. This happens when *)
					(* we want to mix via pipette -- we can just transfer from the sample back into the same sample with AspirationMix also set. *)
					MatchQ[Lookup[sourcePacket, Object], Lookup[destinationPacket, Object]],
						Null,
					MatchQ[roundedAmount, MassP] && MatchQ[convertedAmountAsVolume+destinationAmountAsVolume, GreaterP[1.03 * Lookup[destinationContainerModelPacket, MaxVolume]]],
						AppendTo[overfilledErrors, {Lookup[destinationPacket, Object], roundedAmount, Lookup[destinationPacket, Mass], manipulationIndex}],
					MatchQ[roundedAmount, VolumeP] && MatchQ[roundedAmount+destinationAmountAsVolume, GreaterP[1.03 * Lookup[destinationContainerModelPacket, MaxVolume]]],
						AppendTo[overfilledErrors, {Lookup[destinationPacket, Object], roundedAmount, destinationAmountAsVolume, manipulationIndex}],
					True,
						Null
				];

				(* -- Error check for incorrect hermetic usage -- *)
				(* Lists to append to: hermeticSourceErrors, hermeticDestinationErrors. *)
				If[And[
						Or[
							MatchQ[unsealHermeticSource, True],
							MatchQ[backfillNeedle, Except[Null]],
							MatchQ[backfillGas, Except[Null]]
						],
						And[
							MatchQ[Lookup[sourceContainerPacket, Hermetic], Except[True]],
							MatchQ[Lookup[sourceContainerPacket, Ampoule], Except[True]]
						]
					],
					AppendTo[hermeticSourceErrors, {Lookup[sourceContainerPacket, Object], manipulationIndex}];
				];

				If[And[
						Or[
							MatchQ[unsealHermeticDestination, True],
							MatchQ[ventingNeedle, Except[Null]]
						],
						And[
							MatchQ[Lookup[destinationContainerPacket, Hermetic], Except[True]],
							MatchQ[Lookup[destinationContainerPacket, Ampoule], Except[True]]
						]
					],
					AppendTo[hermeticDestinationErrors, {Lookup[destinationContainerPacket, Object], manipulationIndex}];
				];

				(* -- Error check for weighing container -- *)
				(* Make sure that we have a weighing container if we're using a spatula if our destination container is not empty or a plate at the time of transfer AND we are not transferring all. *)
				If[MatchQ[instrument, ObjectP[Model[Item, Spatula]]] && MatchQ[weighingContainer, Null] && !MatchQ[destinationAmountAsVolume, 0 Liter] && !MatchQ[amount, All],
					AppendTo[weighingContainerErrors, {Lookup[destinationContainerPacket, Object], manipulationIndex}]
				];

				(* -- Error check for instrument/balance -- *)
				(* Check that any given instruments/tips can hold the amount needed to be transferred -- this includes problems of a mismatched state. *)
				Which[
					(* First, check for problems of mismatched state. *)
					And[
						MatchQ[
							instrument,
							ObjectP[{
								Model[Container, Syringe],
								Object[Container, Syringe],
								Model[Container, GraduatedCylinder],
								Object[Container, GraduatedCylinder],
								Model[Instrument, Pipette],
								Object[Instrument, Pipette]
							}]
						],
						MatchQ[Lookup[sourcePacket, State], Except[Liquid|Null]]
					],
						AppendTo[instrumentCapacityErrors, {Instrument, instrument, convertedAmount, manipulationIndex}],

					And[
						MatchQ[
							instrument,
							ObjectP[{
								Model[Item, Spatula],
								Object[Item, Spatula]
							}]
						],
						MatchQ[Lookup[sourcePacket, State], Except[Solid]]
					],
						AppendTo[instrumentCapacityErrors, {Instrument, instrument, convertedAmount, manipulationIndex}],

					(* User specified balance. When checking on this, we allow a balance that can fulfill the MinWeight requirement when WeighingContainer is considered. In other words, we won't reject a balance because of MinWeight as long as the WeighingContainer weight + transfer mass is over MinWeight. *)
					(* This is different from when we resolve a balance, where we prefer a balance with a smaller MinWeight, ideally smaller than transfer mass *)
					(* We also want to loosen some criteria like we do not need to check transfer environment compatibility here (it will be checked elsewhere) *)
					(* We also want to skip the check of whether we think a transfer amount is "too close" to the balance resolution, in resolution, transfer amount has to be greater than 2000 times of the balance resolution, while here, we do not care *)
					MatchQ[Lookup[options, Balance], Except[Automatic]] && MatchQ[balance, ObjectP[{Model[Instrument, Balance], Object[Instrument, Balance]}]],
					Module[{potentialBalances,balanceModel},
						potentialBalances=compatibleBalanceModels[IgnoreTransferEnvironmentAvailability->True,IncludeWeighingContainerWeight->True,IgnoreMassResolutionCompatibility->True];

						balanceModel=If[MatchQ[balance, ObjectP[Object[Instrument, Balance]]],
							fastAssocLookup[fastAssoc, balance, Model],
							balance
						];

						If[!MemberQ[potentialBalances, ObjectP[balanceModel]],
							AppendTo[instrumentCapacityErrors, {Balance, balance, convertedAmountAsMass, manipulationIndex}]
						];
					],

					MatchQ[balance, ObjectP[{Model[Instrument, Balance], Object[Instrument, Balance]}]],
						Module[{potentialBalances,balanceModel},
							potentialBalances=compatibleBalanceModels[IgnoreTransferEnvironmentAvailability->True];

							balanceModel=If[MatchQ[balance, ObjectP[Object[Instrument, Balance]]],
								fastAssocLookup[fastAssoc, balance, Model],
								balance
							];

							If[!MemberQ[potentialBalances, ObjectP[balanceModel]],
								AppendTo[instrumentCapacityErrors, {Balance, balance, convertedAmountAsMass, manipulationIndex}]
							];
						],
					True,
						Null
				];

				(* -- Error check for BalanceCleaningMethod -- *)
				If[MatchQ[balance,ObjectP[]]&&MatchQ[Lookup[options,BalanceCleaningMethod],Except[Automatic]]&&!MatchQ[balanceCleaningMethod,(Wet|Dry)],
					AppendTo[balanceCleaningMethodRequiredErrors, {balanceCleaningMethod, balance, manipulationIndex}]
				];

				(* -- Error check for tips/needles -- *)

				(* Make sure that the tip/needles can hit the bottom of the container. *)
				(* NOTE: We're putting this insider of the MapThread so that later, when we update the code to know about liquid level, *)
				(* it is easier to update. *)
				Which[
					MatchQ[needle, ObjectP[{Model[Item, Needle], Object[Item, Needle]}]],
						Module[{needleModel,maximumContainerDepth, sharpNeedleRequiredQ, potentialNeedles},
							needleModel=If[MatchQ[needle, ObjectP[Model[Item, Needle]]],
								needle,
								fastAssocLookup[fastAssoc, needle, Model]
							];

							(* What is the maximum container depth between the source and destination containers? *)
							maximumContainerDepth=Max[
								Lookup[workingSourceContainerModelPacket, Dimensions][[3]],
								Lookup[workingDestinationContainerModelPacket, Dimensions][[3]]
							];

							(* Determine if we have to use a sharp needle due to either source or container being hermetic yet are set to NOT unseal. *)
							sharpNeedleRequiredQ = Or[
								MatchQ[Lookup[workingSourceContainerModelPacket, Hermetic], True] && MatchQ[unsealHermeticSource, False],
								MatchQ[Lookup[workingDestinationContainerModelPacket, Hermetic], True] &&MatchQ[unsealHermeticDestination, False]
							];

							(* Get all of our compatible needles. *)
							potentialNeedles = compatibleNeedles[
								allNeedleModelPackets,
								MinimumLength -> maximumContainerDepth,
								(* For error checking, we do not error out for bevel-overkill, i.e. using a sharp needle where blunt is okay, but we do need to consider blunt ones incompatible when we need a sharp one *)
								Blunt -> If[TrueQ[sharpNeedleRequiredQ],
									False,
									Null
								]
							];

							If[!MemberQ[potentialNeedles, ObjectP[needleModel]],
								AppendTo[liquidLevelErrors, {Needle, needle, manipulationIndex}]
							];
						],
					MatchQ[tips, ObjectP[{Model[Item, Tips], Object[Item, Tips]}]],
						Module[{tipsModel},
							tipsModel=If[MatchQ[tips, ObjectP[Model[Item, Tips]]],
								tips,
								fastAssocLookup[fastAssoc, tips, Model]
							];
							(*TODO: this is a little suspect, as the working container will not have the sourceAmountAsVolume because it has been decanted into. It has less, so this test is *)
							(* goign to pass when it maybe should fail. On the other hand, I'm not mad at it since it will allow for the use of 50 mL intermediate tubes with 10 uL transfers *)
							If[!MatchQ[tipsCanAspirateQ[tipsModel, workingSourceContainerModelPacket, sourceAmountAsVolume, convertedAmountAsVolume, allTipModelPackets, allVolumeCalibrationPackets], True],
								AppendTo[liquidLevelErrors, {Tips, tips, manipulationIndex}]
							];
						],
					True,
						Null
				];

				(* -- Error check for weighingContainer/quantitativeTransfer -- *)

				(* Make sure weigh paper (Item,Consumable) is NOT used as weighing container when QuantitativeTransfer is True *)
				If[MatchQ[quantitativeTransfer,True]&&MatchQ[weighingContainer,ObjectP[{Model[Item,Consumable],Object[Item,Consumable]}]],
					AppendTo[incompatibleQuantitativeTransferWeighingContainerErrors,{quantitativeTransfer, weighingContainer, manipulationIndex}],
					Nothing
				];

				(* Check if specified WeighingContainer is a member of preresolvedWeighingContainersAndErrors - compatible with QuantitativeTransfer options and destination *)
				If[
					And[
						MatchQ[Lookup[sourcePacket, State], Solid],
						MatchQ[Lookup[options,WeighingContainer],Except[Automatic | ObjectP[{Model[Item, Consumable], Object[Item, Consumable]}]]],
						MatchQ[weighingContainer,Except[Null]],
						!MemberQ[preresolvedWeighingContainersAndErrors[[1]],weighingContainerModel],
						!(MatchQ[Lookup[options,WeighingContainer],ObjectP[{Model[Item, Consumable], Object[Item, Consumable]}]]&&MatchQ[quantitativeTransfer,True]) (* this is thrown on a different error message *)
					],
					AppendTo[incompatibleWeighingContainerErrors,Join[{weighingContainer},{manipulationIndex},{convertedAmountAsVolume},{destinationContainerAperture},Join[Lookup[sourcePacket, IncompatibleMaterials],washSolutionIncompatibleMaterials]]],
					Nothing
				];

				(* -- Error check for funnel/quantitativeTransfer -- *)
				(* If QuantitativeTransfer is True and WeighingContainer is not a weighing funnel, throw an error if Funnel resolves to Null (eg no compatible Funnel was found due to IncompatibleMaterials,StemDiameter etc)*)
				If[MatchQ[quantitativeTransfer,True]&&MatchQ[weighingContainer,Except[ObjectP[{Model[Item,WeighBoat,WeighingFunnel],Object[Item,WeighBoat,WeighingFunnel]}]]]&&MatchQ[funnel,Null]&&MatchQ[Lookup[options,Funnel],Except[Null]]&&!MatchQ[Lookup[options,Preparation],Robotic],
					AppendTo[noCompatibleFunnelErrors,{weighingContainer,manipulationIndex}],
					Nothing
				];

				(* -- Error check for quantitativeTransferWashTips/quantitativeTransfer -- *)
				(* If quantitativeTransferWashTips is specified, make sure it is a member of validQuantitativeTransferWashTips (which is limited by a wash volume of 5mL) *)
				validQuantitativeTransferWashTips = If[MatchQ[quantitativeTransferWashVolume,LessEqualP[5 Milliliter]],
					TransferDevices[Model[Item, Tips], quantitativeTransferWashVolume,PipetteType->Micropipette][[All,1]],
					{}
				];

				(* Do not throw error if quantitativeTransferWashVolume is already above limit *)
				If[
					MatchQ[quantitativeTransfer,True]&&MatchQ[Lookup[options, QuantitativeTransferWashTips], Except[Automatic]]&&!MemberQ[validQuantitativeTransferWashTips,quantitativeTransferWashTipsModel]&&MatchQ[quantitativeTransferWashVolume,LessEqualP[5 Milliliter]],
					AppendTo[incompatibleQuantitativeTransferWashTipsErrors,{quantitativeTransferWashTips, manipulationIndex, quantitativeTransferWashVolume}],

					Nothing
				];

				(* -- Error check for quantitativeTransferWashInstrument/quantitativeTransfer -- *)
				(* If QuantitativeTransferWashInstrument is specified, make sure it is a member of validQuantitativeTransferWashInstrument (which is limited to a Micropipette PipetteType) *)
				validQuantitativeTransferWashInstrument=compatiblePipettes[
					quantitativeTransferWashTips,
					Cases[allTipModelPackets,KeyValuePattern[{PipetteType->Micropipette}]],
					Cases[allPipetteModelPackets,KeyValuePattern[{PipetteType->Micropipette}]],
					quantitativeTransferWashVolume,
					SterileTechnique -> sterileTechnique,
					CultureHandling->cultureHandling,
					GloveBoxStorage->MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]]
				];

				(* Do not throw error if quantitativeTransferWashVolume is already above limit OR quantitativeTransferWashTips is invalid (not Micropipette)*)
				If[MatchQ[quantitativeTransfer,True]&&MatchQ[Lookup[options, QuantitativeTransferWashInstrument], Except[Automatic]]&&!MemberQ[validQuantitativeTransferWashInstrument,quantitativeTransferWashInstrumentModel]&&MatchQ[fastAssocLookup[fastAssoc,quantitativeTransferWashTips,PipetteType],Micropipette]&&MatchQ[quantitativeTransferWashVolume,LessEqualP[5 Milliliter]],
					AppendTo[incompatibleQuantitativeTransferWashInstrumentErrors,{ quantitativeTransferWashInstrument, manipulationIndex,quantitativeTransferWashTips}],
					Nothing
				];

				(* -- Error for spatula that does not fit the destinationAperture *)
				If[MatchQ[instrument,ObjectP[{Object[Item,Spatula],Model[Item,Spatula]}]]&&MatchQ[fastAssocLookup[fastAssoc,instrumentModel,NarrowEndWidth],GreaterP[destinationAperture-1 Millimeter]],
					AppendTo[incompatibleSpatulaWidthErrors,{instrument, manipulationIndex,destinationAperture}];
				];

				(* -- Warning for items that are transferred by mass -- *)
				(* Warning that we will crush up itemized samples (separate field for hammer since we can't use instrument) if we're given a mass amount that's totally off OR a tolerance *)
				If[MatchQ[amount, MassP] && MatchQ[Lookup[sourcePacket, SampleHandling], Itemized] && MatchQ[Lookup[sourcePacket, Tablet], True],
					AppendTo[pillCrusherWarnings, {amount, manipulationIndex}];
				];

				If[MatchQ[amount, MassP] && MatchQ[Lookup[sourcePacket, SampleHandling], Itemized] && MatchQ[Lookup[sourcePacket, Sachet], True],
					AppendTo[sachetMassWarnings, {amount, manipulationIndex}];
				];

				(* Warning if spatula selected is compatible with destination aperture but too small or too big for the mass transfer *)
				If[
					And[
						MatchQ[Lookup[options,Instrument],Except[Automatic]],
						MatchQ[
							instrument,
							ObjectP[{
								Model[Item, Spatula],
								Object[Item, Spatula]
							}]
						],
						!MemberQ[idealSpatulasByCapacity,Download[instrumentModel,Object]]&&MemberQ[allCompatibleSpatulas,Download[instrumentModel,Object]]
					],
					AppendTo[spatulaCapacityWarnings, {Instrument, instrument, convertedAmount, manipulationIndex}]
				];

				(* -- Error for samples that are gaseous -- *)
				If[MatchQ[Lookup[sourcePacket, State], Gas],
					AppendTo[gaseousSampleErrors, {sourcePacket, manipulationIndex}];
				];

				(* -- Error for if source IncompatibleMaterials is a member destinationContainer ContainerMaterials  -- *)
				(* Get a list of materials, if any, that is common between the IncompatibleMaterials of the source and the ContainerMaterials of the specified container *)
				incompatibleMaterialsDestinationContainer = Module[
					{
						sourceIncompatibleMaterials, destinationContainerIncompatibleMaterials, destinationContainerModelIncompatibleMaterials,
						transferredSampleVolumeRatio, incompatibleMaterialsThreshold
					},

					sourceIncompatibleMaterials = ToList[Lookup[sourcePacket,IncompatibleMaterials]];
					destinationContainerIncompatibleMaterials = ToList[Lookup[destinationContainerPacket,ContainerMaterials]];
					destinationContainerModelIncompatibleMaterials = ToList[Lookup[destinationContainerModelPacket,ContainerMaterials]];

					(* Allow transfer of incompatible materials if the destination sample's composition will contain less than a given threshold of the incompatible *)
					(* transferred sample by volume. Get the ratio of the transferred volume to the theoretical destination volume and check for this. *)
					transferredSampleVolumeRatio = If[GreaterQ[(convertedAmountAsVolume + destinationAmountAsVolume), 0 Liter],
						convertedAmountAsVolume/(convertedAmountAsVolume + destinationAmountAsVolume),
						1
					];

					(* Set the threshold for incompatible materials. We keep this at 0 because we don't want any ill-advised transfers to go through *)
					(* unnoticed, but if Error::IncompatibleTransferDestinationContainer is thrown, sci-ops can plug a number in here and run the experiment call *)
					(* locally after determining that the transfer is acceptable. e.g., if this threshold is set to 0.02, we will allow the transfer if *)
					(* it results in a destination sample which contains no more than 2% of the incompatible source sample by volume. *)
					incompatibleMaterialsThreshold = 0;

					Which[
						And[
							IntersectingQ[sourceIncompatibleMaterials,destinationContainerIncompatibleMaterials],
							GreaterQ[transferredSampleVolumeRatio, incompatibleMaterialsThreshold]
						],
							Intersection[
								Cases[sourceIncompatibleMaterials,Except[Null]],
								Cases[destinationContainerIncompatibleMaterials,Except[Null]]
							],

						And[
							IntersectingQ[sourceIncompatibleMaterials,destinationContainerModelIncompatibleMaterials],
							GreaterQ[transferredSampleVolumeRatio, incompatibleMaterialsThreshold]
						],
							Intersection[
								Cases[sourceIncompatibleMaterials,Except[Null]],
								Cases[destinationContainerModelIncompatibleMaterials,Except[Null]]
							],

						True,
							{}
					]
				];

				If[MatchQ[Length[incompatibleMaterialsDestinationContainer],GreaterP[0]],
					AppendTo[incompatibleDestinationContainerErrors, {sourceInput, manipulationIndex, destinationInput,incompatibleMaterialsDestinationContainer}]
				];


				(* -- Error for samples that are solids but are asked to be transferred by volume -- *)
				If[MatchQ[Lookup[sourcePacket, State], Solid] && MatchQ[amount, VolumeP],
					AppendTo[solidSampleVolumeErrors, {Download[sourcePacket,Object], manipulationIndex}];
				];

				(* Make sure that our funnel option can fit into our destination container. *)
				If[MatchQ[funnel, ObjectP[{Model[Part, Funnel], Object[Part, Funnel]}]],
					Module[{destinationContainerAperture,funnelModel,potentialFunnels,funnelType},
						(* Get the aperture of our destination container. *)
						(* NOTE: Vessels have this number under Aperture, Plates have it under WellDiameter. *)
						destinationContainerAperture=If[MatchQ[Lookup[destinationContainerModelPacket, Aperture], DistanceP],
							Lookup[destinationContainerModelPacket, Aperture],
							Lookup[destinationContainerModelPacket, WellDiameter]
						];

						(* Get the model of the funnel if we have an object. *)
						funnelModel=If[MatchQ[funnel, ObjectP[{Object[Part, Funnel]}]],
							fastAssocLookup[fastAssoc, funnel, Model],
							funnel
						];

						(* resolve FunnelType based on State of Sample *)
						(* if instrument is GraduatedCylinder, also resolve to Wet *)
						funnelType=Which[
							MatchQ[Lookup[sourcePacket, State], Solid],
							Dry,

							MatchQ[Lookup[sourcePacket, State], Liquid]||MatchQ[instrument, ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}]],
							Wet,

							True,
							{Wet,Dry}
						];

						(* Get the first funnel that can fit into our destination container. *)
						potentialFunnels=compatibleFunnels[
							allFunnelPackets,
							IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials],
							Aperture->destinationContainerAperture,
							FunnelType->funnelType
						];

						(* We have a problem if this model isn't in our potential funnels. *)
						If[!MemberQ[potentialFunnels, ObjectP[funnelModel]],
							AppendTo[
								funnelDestinationResult,
								{
									funnel,
									destinationContainerAperture,
									Lookup[sourcePacket, IncompatibleMaterials],
									funnelType,
									manipulationIndex
								}
							]
						]
					]
				];

				(* Make sure that our intermediate funnel option can fit into our intermediate container. *)
				If[MatchQ[intermediateFunnel, ObjectP[{Model[Part, Funnel], Object[Part, Funnel]}]] && MatchQ[intermediateContainer, ObjectP[{Model[Container], Object[Container]}]],
					Module[{intermediateContainerPacket,intermediateContainerAperture,funnelModel,potentialFunnels,funnelType},
						(* Get the model packet of the intermediate container. *)
						intermediateContainerPacket=If[MatchQ[intermediateContainer, ObjectP[Model[Container]]],
							fetchPacketFromFastAssoc[intermediateContainer, fastAssoc],
							fastAssocPacketLookup[fastAssoc, intermediateContainer, Model]
						];

						(* Get the aperture of our intermediate container. *)
						(* NOTE: Vessels have this number under Aperture, Plates have it under WellDiameter. *)
						intermediateContainerAperture=If[MatchQ[Lookup[intermediateContainerPacket, Aperture], DistanceP],
							Lookup[intermediateContainerPacket, Aperture],
							Lookup[intermediateContainerPacket, WellDiameter]
						];

						(* resolve FunnelType based on State of Sample *)
						(* if instrument is GraduatedCylinder, also resolve to Wet *)
						funnelType=Which[
							MatchQ[Lookup[sourcePacket, State], Solid],
							Dry,

							MatchQ[Lookup[sourcePacket, State], Liquid]||MatchQ[instrument, ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}]],
							Wet,

							True,
							{Wet,Dry}
						];

						(* Get the first funnel that can fit into our destination container. *)
						potentialFunnels=compatibleFunnels[
							allFunnelPackets,
							IncompatibleMaterials->Lookup[sourcePacket, IncompatibleMaterials],
							Aperture->intermediateContainerAperture,
							FunnelType->funnelType
						];

						(* Get the model of the funnel if we have an object. *)
						funnelModel=If[MatchQ[intermediateFunnel, ObjectP[{Object[Part, Funnel]}]],
							fastAssocLookup[fastAssoc, intermediateFunnel, Model],
							intermediateFunnel
						];

						(* We have a problem if this model isn't in our potential funnels. *)
						If[!MemberQ[potentialFunnels, ObjectP[funnelModel]],
							AppendTo[
								funnelIntermediateResult,
								{
									intermediateFunnel,
									intermediateContainerAperture,
									Lookup[sourcePacket, IncompatibleMaterials],
									manipulationIndex
								}
							]
						]
					]
				];

				(* -- Error check for IntermediateContainer and IntermediateDecant when in FTV -- *)
				(* FTV to VolumetricFlask only allows Model[Container, Vessel, "id:kEJ9mqaVPPD8"] as IntermediateContainer *)
				Which[
					(*If specified option is a Model*)
					MatchQ[Lookup[options, IntermediateContainer],ObjectP[Model[Container]]],
						If[MatchQ[Lookup[options, IntermediateContainer], Except[ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]]]
							&&(volumetricFlaskFTVQ),
							AppendTo[incompatibleFTVIntermediateContainerErrors,{Lookup[options, IntermediateContainer],manipulationIndex,Lookup[destinationContainerModelPacket,Object],Model[Container, Vessel, "id:kEJ9mqaVPPD8"]}];
						],
					(*If specified option is an Object*)
					MatchQ[Lookup[options, IntermediateContainer],ObjectP[Object[Container]]],
						If[MatchQ[fastAssocLookup[fastAssoc,Lookup[options, IntermediateContainer],Model], Except[ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]]]
							&&(volumetricFlaskFTVQ),
							AppendTo[incompatibleFTVIntermediateContainerErrors,{Lookup[options, IntermediateContainer],manipulationIndex,Lookup[destinationContainerModelPacket,Object],Model[Container, Vessel, "id:kEJ9mqaVPPD8"]}];
						],
					True,
					Nothing
				];

				(* FTV to VolumetricFlask only allows IntermediateDecant False *)
				If[MatchQ[intermediateDecant,True]
					&&(volumetricFlaskFTVQ),
					AppendTo[incompatibleFTVIntermediateDecantErrors,{Lookup[options, IntermediateDecant],manipulationIndex,Lookup[destinationContainerModelPacket,Object]}];
				];

				(* FTV to VolumetricFlask only allows GraduatedCylinder or Null as instrument *)
				If[MatchQ[Lookup[options, Instrument],Except[Automatic | Null | ObjectP[{Object[Container, GraduatedCylinder], Model[Container, GraduatedCylinder]}]]]
					&&(volumetricFlaskFTVQ),
					AppendTo[incompatibleFTVInstrumentErrors,{Lookup[options, Instrument],manipulationIndex,Lookup[destinationContainerModelPacket,Object]}];
				];
				
				(* FTV to VolumetricFlask with GraduatedCylinder requires a Funnel *)
				If[MatchQ[instrument,ObjectP[{Object[Container, GraduatedCylinder], Model[Container, GraduatedCylinder]}]]
					&&(volumetricFlaskFTVQ)&&MatchQ[funnel,Except[ObjectP[]]],
					AppendTo[incompatibleFTVFunnelErrors,{funnel, manipulationIndex,Lookup[destinationContainerModelPacket,Object]}];
				];

				(* NumberOfQuantitativeTransferWashes should always be greater than or equal to 2 *)
				Which[
					MatchQ[numberOfQuantitativeTransferWashes,LessP[3]]&&!MatchQ[weighingContainer,ObjectP[{Object[Item,Weighboat,WeighingFunnel],Model[Item,Weighboat,WeighingFunnel]}]]&&MatchQ[funnel,ObjectP[]],
					AppendTo[invalidNumberOfQuantitativeTransferWashesError,{numberOfQuantitativeTransferWashes,manipulationIndex}];,
					MatchQ[numberOfQuantitativeTransferWashes,LessP[2]],
					AppendTo[invalidNumberOfQuantitativeTransferWashesError,{numberOfQuantitativeTransferWashes,manipulationIndex}];
				];

				(* -- Error if we have a magnetization rack but the source/working container won't fit into the rack or -- *)
				(* -- the rack isn't magnetic -- *)
				Module[{magnetizationRackModelPacket},
					magnetizationRackModelPacket=Which[
						MatchQ[magnetizationRack, ObjectP[Model[Container, Rack]]],
							fetchPacketFromFastAssoc[magnetizationRack, fastAssoc],
						MatchQ[magnetizationRack, ObjectP[Object[Container, Rack]]],
							fastAssocPacketLookup[fastAssoc, magnetizationRack, Model],
						True,
							Null
					];

					If[And[
							MatchQ[magnetizationRackModelPacket, PacketP[]],
							Or[
								!MemberQ[
									Lookup[Lookup[magnetizationRackModelPacket, Positions, {}], Footprint],
									Lookup[workingSourceContainerModelPacket, Footprint]
								],
								!MatchQ[Lookup[magnetizationRackModelPacket, Magnetized, {}], True]
							]
						],
						AppendTo[magneticRackErrors, {sourcePacket, Lookup[workingSourceContainerModelPacket, Footprint], manipulationIndex}]
					];
				];

				(* -- Error for samples that have layer/supernatant set but are not liquids  -- *)
				If[MatchQ[aspirationLayer, Except[Null]] && MatchQ[Lookup[sourcePacket, State], Except[Liquid]],
					AppendTo[layerSupernatantLiquidErrors, {sourcePacket, AspirationLayer, manipulationIndex}];
				];

				If[MatchQ[supernatant, True] && MatchQ[Lookup[sourcePacket, State], Except[Liquid]],
					AppendTo[layerSupernatantLiquidErrors, {sourcePacket, AspirationLayer, manipulationIndex}];
				];

				If[MatchQ[Lookup[options, DestinationLayer], Except[Null]] && MatchQ[Lookup[destinationPacket, State], Except[Liquid]],
					AppendTo[layerSupernatantLiquidErrors, {destinationPacket, DestinationLayer, manipulationIndex}];
				];

				(* -- Warning for non-anhydrous liquid samples that are going into the glove box *)
				If[MatchQ[Lookup[sourcePacket, State], Liquid] && MatchQ[Lookup[sourcePacket, Anhydrous], Except[True]] && MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]],
					AppendTo[anhydrousGloveBoxWarnings, {sourcePacket, manipulationIndex}];
				];

				If[MatchQ[Lookup[destinationPacket, State], Liquid] && MatchQ[Lookup[destinationPacket, Anhydrous], Except[True]] && MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]],
					AppendTo[anhydrousGloveBoxWarnings, {destinationPacket, manipulationIndex}];
				];

				(* -- Error for samples that have water in the composition or are Aqueous->True -- *)
				If[MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]] && (MemberQ[Lookup[sourcePacket, Composition][[All,2]], ObjectP[Model[Molecule, "id:vXl9j57PmP5D"]]] || MatchQ[Lookup[sourcePacket, Aqueous], True]),
					AppendTo[aqueousGloveBoxErrors, {sourcePacket, manipulationIndex}];
				];

				If[MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]] && (MemberQ[Lookup[destinationPacket, Composition][[All,2]], ObjectP[Model[Molecule, "id:vXl9j57PmP5D"]]] || MatchQ[Lookup[destinationPacket, Aqueous], True]),
					AppendTo[aqueousGloveBoxErrors, {destinationPacket, manipulationIndex}];
				];

				(* Warning for ReversePipetting using extra volume from the source sample *)
				If[MatchQ[reversePipetting, True],
					AppendTo[reversePipettingSamples, {Lookup[sourcePacket, Object], manipulationIndex}];
				];

				(* -- Simulate any changes in our working cache packets. -- *)

				(* Sample Fields to simulate: State, Volume, Mass *)
				(* Container Fields to simulate: Hermetic, Contents *)
				If[
					!MatchQ[sourcePacket,<||>],
					Module[{safetyEHSCache, ehsFields, ehsValuesRules, newDensity, newSourceSamplePacket, newDestinationSamplePacket, newCollectionContainerSamplePacket},
						(* Simulate changes to our source sample. *)
						newSourceSamplePacket=If[MatchQ[Lookup[sourcePacket,Object],Lookup[destinationPacket,Object]],
							sourcePacket,
							Append[
								sourcePacket,
								<|
									Volume->If[MatchQ[Lookup[sourcePacket, Volume], VolumeP],
										Max[{
											Lookup[sourcePacket, Volume] - convertedAmountAsVolume,
											0 Liter
										}],
										Null
									],
									Mass->If[MatchQ[Lookup[sourcePacket, Mass], MassP],
										Max[{
											Lookup[sourcePacket, Mass] - convertedAmountAsMass,
											0 Gram
										}],
										Null
									]
								|>
							]
						];

						(* Drop the old packet from our cache, add the new packet. *)
						workingSourceSamplePackets=Append[
							DeleteCases[workingSourceSamplePackets, PacketP[Lookup[sourcePacket, Object]]],
							newSourceSamplePacket
						];

						(* Also drop it from the destination cache if it exists (since sources can also be destinations). *)
						If[MemberQ[workingDestinationSamplePackets, PacketP[Lookup[sourcePacket, Object]]],
							workingDestinationSamplePackets=Append[
								DeleteCases[workingDestinationSamplePackets, PacketP[Lookup[sourcePacket, Object]]],
								newSourceSamplePacket
							];
						];

						(* Also drop it from the collection container cache if it exists (since sources can also be destinations). *)
						If[MemberQ[workingCollectionContainerSamplePackets, PacketP[Lookup[sourcePacket, Object]]],
							workingCollectionContainerSamplePackets=Append[
								DeleteCases[workingCollectionContainerSamplePackets, PacketP[Lookup[sourcePacket, Object]]],
								newSourceSamplePacket
							];
						];

						(* Simulate changes to our source container. *)
						If[MatchQ[unsealHermeticSource, True],
							Append[
								DeleteCases[workingDestinationContainerPackets, sourceContainerPacket],
								Append[
									sourceContainerPacket,
									<|
										Hermetic->False,
										Ampoule->False
									|>
								]
							]
						];

						(* Setup safety simulation changes to our destination sample. *)
						safetyEHSCache={sourcePacket, destinationPacket, collectionContainerSamplePacket};
						ehsFields={SampleHandling, Fuming, Ventilated, CellType, InertHandling, AsepticHandling, Pyrophoric, State, Sterile};

						(* Map over the safety fields that we need to simulate and update them. *)
						(* NOTE: Do NOT update EHS fields if we have an item. *)
						ehsValuesRules=If[MatchQ[destinationObject, ObjectP[Object[Item]]],
							{},
							ExternalUpload`Private`combineEHSFields[
								ehsFields,
								Lookup[sourcePacket, Object],
								If[MatchQ[collectionContainerSample, ObjectP[Object[Sample]]],
									Lookup[collectionContainerSamplePacket, Object],
									Lookup[destinationPacket, Object]
								],
								convertedAmountAsVolume,
								destinationAmountAsVolume,
								safetyEHSCache
							][[1]]
						];

						(* approximate new Density of the destination if we can *)
						newDensity = ExternalUpload`Private`approximateDensity[{
							{convertedAmountAsVolume, sourcePacket},
							{destinationAmountAsVolume,destinationPacket}
						}];

						(* Simulate changes to our destination. *)
						(* NOTE: Do NOT update the destination packet if we have a collection container, we will update the collection container packet instead. *)
						newDestinationSamplePacket=If[Or[
								MatchQ[collectionContainerSample, ObjectP[Object[Sample]]],
								MatchQ[destinationObject, ObjectP[Object[Item]]],
								MatchQ[Lookup[sourcePacket,Object],Lookup[destinationPacket,Object]]
							],
							destinationPacket,
							Append[
								destinationPacket,
								<|
									Volume->If[MatchQ[Lookup[destinationPacket, Volume], VolumeP],
										Lookup[destinationPacket, Volume] + convertedAmountAsVolume,
										Null
									],
									Mass->If[MatchQ[Lookup[destinationPacket, Mass], MassP],
										Lookup[destinationPacket, Mass] + convertedAmountAsMass,
										Null
									],
									(* Only have to change the state of the destination if it was a solid and we're adding a liquid. *)
									If[MatchQ[Lookup[destinationPacket, State], Solid] && MatchQ[convertedAmount, VolumeP],
										State->Liquid,
										Nothing
									],

									(* update Density if we end up with liquid *)
									If[
										Or[
											MatchQ[Lookup[destinationPacket, State], Liquid],
											(* we now have liquid *)
											MatchQ[Lookup[destinationPacket, State], Solid] && MatchQ[convertedAmount, VolumeP]
										],
										Density->newDensity,
										Nothing
									],

									(* Include our EHS updates. *)
									Sequence@@ehsValuesRules
								|>
							]
						];

						(* Drop the old packet from our cache, add the new packet. *)
						workingDestinationSamplePackets=Append[
							DeleteCases[workingDestinationSamplePackets, PacketP[Lookup[destinationPacket, Object]]],
							newDestinationSamplePacket
						];

						(* Also drop it from the source cache if it exists (since destinations can also be sources). *)
						If[MemberQ[workingSourceSamplePackets, PacketP[Lookup[destinationPacket, Object]]],
							workingSourceSamplePackets=Append[
								DeleteCases[workingSourceSamplePackets, PacketP[Lookup[destinationPacket, Object]]],
								newDestinationSamplePacket
							];
						];

						(* Also drop it from the collection container cache if it exists (since sources can also be destinations). *)
						If[MemberQ[workingCollectionContainerSamplePackets, PacketP[Lookup[destinationPacket, Object]]],
							workingCollectionContainerSamplePackets=Append[
								DeleteCases[workingCollectionContainerSamplePackets, PacketP[Lookup[destinationPacket, Object]]],
								newDestinationSamplePacket
							];
						];

						(* Simulate changes to our destination container. *)
						If[MatchQ[unsealHermeticDestination, True],
							Append[
								DeleteCases[workingDestinationContainerPackets, destinationContainerPacket],
								Append[
									destinationContainerPacket,
									<|
										Hermetic->False,
										Ampoule->False
									|>
								]
							]
						];

						(* Simulate changes to our collection container sample. *)
						(* NOTE: Do NOT update the destination packet if we have a collection container, we will update the collection container packet instead. *)
						newCollectionContainerSamplePacket=If[!MatchQ[collectionContainerSample, ObjectP[Object[Sample]]],
							collectionContainerSamplePacket,
							Append[
								collectionContainerSamplePacket,
								<|
									Volume->If[MatchQ[Lookup[collectionContainerSamplePacket, Volume], VolumeP],
										Lookup[collectionContainerSamplePacket, Volume] + convertedAmountAsVolume,
										Null
									],
									Mass->If[MatchQ[Lookup[collectionContainerSamplePacket, Mass], MassP],
										Lookup[collectionContainerSamplePacket, Mass] + convertedAmountAsMass,
										Null
									],
									(* Only have to change the state of the destination if it was a solid and we're adding a liquid. *)
									If[MatchQ[Lookup[collectionContainerSamplePacket, State], Solid] && MatchQ[convertedAmount, VolumeP],
										State->Liquid,
										Nothing
									],

									(* update Density if we end up with liquid *)
									If[
										Or[
											MatchQ[Lookup[collectionContainerSamplePacket, State], Liquid],
											(* we now have liquid *)
											MatchQ[Lookup[collectionContainerSamplePacket, State], Solid] && MatchQ[convertedAmount, VolumeP]
										],
										Density->newDensity,
										Nothing
									],

									(* Include our EHS updates. *)
									Sequence@@ehsValuesRules
								|>
							]
						];

						(* Drop the old packet from our cache, add the new packet. *)
						workingDestinationSamplePackets=Append[
							DeleteCases[workingDestinationSamplePackets, PacketP[Lookup[collectionContainerSamplePacket, Object]]],
							newCollectionContainerSamplePacket
						];

						(* Also drop it from the source cache if it exists (since destinations can also be sources). *)
						If[MemberQ[workingSourceSamplePackets, PacketP[Lookup[collectionContainerSamplePacket, Object]]],
							workingSourceSamplePackets=Append[
								DeleteCases[workingSourceSamplePackets, PacketP[Lookup[collectionContainerSamplePacket, Object]]],
								newCollectionContainerSamplePacket
							];
						];

						(* Also drop it from the collection container cache if it exists (since sources can also be destinations). *)
						If[MemberQ[workingCollectionContainerSamplePackets, PacketP[Lookup[collectionContainerSamplePacket, Object]]],
							workingCollectionContainerSamplePackets=Append[
								DeleteCases[workingCollectionContainerSamplePackets, PacketP[Lookup[collectionContainerSamplePacket, Object]]],
								newCollectionContainerSamplePacket
							];
						];
					]
				];

				(* get the balance model's allowed max variation default *)
				modelDefaultMaxVariation = If[MatchQ[balance, ObjectP[Object[Instrument, Balance]]], fastAssocLookup[fastAssoc, balance, {Model, AllowedMaxVariation}], fastAssocLookup[fastAssoc, balance, AllowedMaxVariation]];
				(* do we need a balance for the current transfer *)
				needBalanceQ = NullQ[balance] || MatchQ[resolvedPreparation, Robotic];
				(* are we transferring small amount of liquid? *)
				smallVolumeTransferQ = And[
					MatchQ[Lookup[sourcePacket, State], Liquid],
					LessEqualQ[convertedAmountAsVolume, 5 Milliliter]
				];

				(* resolve weight stability and max variation option for measuring samples of interest *)
				weightStabilityDuration = Which[
					(* respect user input *)
					MatchQ[Lookup[options, WeightStabilityDuration], Except[Automatic]],
						Lookup[options, WeightStabilityDuration],
					(* if we are not using balance or we are doing robotic, no need for this at all *)
					needBalanceQ,
						Null,
					(* if we are transferring small amount of liquid, and using balance, set to 10 Second, allow a larger variation due to possible evaporation (5x of balance's model's allowed max variation), otherwise, set to 60 Second and balance default *)
					smallVolumeTransferQ,
						10 Second,
					True,
						60 Second
				];

				maxWeightVariation = Which[
					(* respect user input *)
					MatchQ[Lookup[options, MaxWeightVariation], Except[Automatic]],
						Lookup[options, MaxWeightVariation],
					(* if we are not using balance or we are doing robotic, no need for this at all *)
					needBalanceQ,
						Null,
					(* if we are transferring small amount of liquid, and using balance, set to 10 Second, allow a larger variation due to possible evaporation (5x of balance's model's allowed max variation), otherwise, set to 60 Second and balance default *)
					smallVolumeTransferQ,
						5 * modelDefaultMaxVariation,
					True,
						modelDefaultMaxVariation
				];

				tareWeightStabilityDuration = Which[
					(* respect user input *)
					MatchQ[Lookup[options, TareWeightStabilityDuration], Except[Automatic]],
						Lookup[options, TareWeightStabilityDuration],
					(* if we are not using balance or we are doing robotic, no need for this at all *)
					needBalanceQ,
						Null,
					(* otherwise always default to 60s *)
					True,
						60 Second
				];

				maxTareWeightVariation = Which[
					(* respect user input *)
					MatchQ[Lookup[options, MaxTareWeightVariation], Except[Automatic]],
						Lookup[options, MaxTareWeightVariation],
					(* if we are not using balance or we are doing robotic, no need for this at all *)
					needBalanceQ,
						Null,
					(* otherwise always default to 60s *)
					True,
						modelDefaultMaxVariation
				];

				(* Return our options in the order that we will transpose them. *)
				{
					(*1*)sourceLabel,
					(*2*)sourceContainerLabel,
					(*3*)sourceContainer,
					(*4*)sourceSampleGrouping,
					(*5*)destinationLabel,
					(*6*)destinationContainerLabel,
					(*7*)instrument,
					(*8*)transferEnvironment,
					(*9*)balance,
					(*10*)pillCrusher,
					(*11*)tips,
					(*12*)tipType,
					(*13*)tipMaterial,
					(*14*)reversePipetting,
					(*15*)supernatant,
					(*16*)magnetization,
					(*17*)magnetizationTime,
					(*18*)maxMagnetizationTime,
					(*19*)magnetizationRack,
					(*20*)aspirationLayer,
					(*21*)needle,
					(*22*)funnel,
					(*23*)weighingContainer,
					(*24*)tolerance,
					(*25*)handPump,
					(*26*)quantitativeTransfer,
					(*27*)quantitativeTransferWashSolution,
					(*28*)quantitativeTransferWashVolume,
					(*29*)quantitativeTransferWashInstrument,
					(*30*)quantitativeTransferWashTips,
					(*31*)numberOfQuantitativeTransferWashes,
					(*32*)unsealHermeticSource,
					(*33*)unsealHermeticDestination,
					(*34*)backfillNeedle,
					(*35*)backfillGas,
					(*36*)ventingNeedle,
					(*37*)tipRinse,
					(*38*)tipRinseSolution,
					(*39*)tipRinseVolume,
					(*40*)numberOfTipRinses,
					(*41*)aspirationMix,
					(*42*)slurryTransfer,
					(*43*)aspirationMixType,
					(*44*)numberOfAspirationMixes,
					(*45*)maxNumberOfAspirationMixes,
					(*46*)dispenseMix,
					(*47*)dispenseMixType,
					(*48*)numberOfDispenseMixes,
					(*49*)pipettingMethodObject,
					(*50*)aspirationRate,
					(*51*)dispenseRate,
					(*52*)overAspirationVolume,
					(*53*)overDispenseVolume,
					(*54*)aspirationWithdrawalRate,
					(*55*)dispenseWithdrawalRate,
					(*56*)aspirationEquilibrationTime,
					(*57*)dispenseEquilibrationTime,
					(*58*)aspirationMixVolume,
					(*59*)dispenseMixVolume,
					(*60*)aspirationMixRate,
					(*61*)dispenseMixRate,
					(*62*)aspirationPosition,
					(*63*)dispensePosition,
					(*64*)aspirationPositionOffset,
					(*65*)dispensePositionOffset,
					(*66*)correctionCurve,
					(*67*)dynamicAspiration,
					(*68*)intermediateDecant,
					(*69*)intermediateContainer,
					(*70*)intermediateFunnel,
					(*71*)sourceTemperature,
					(*72*)sourceEquilibrationTime,
					(*73*)maxSourceEquilibrationTime,
					(*74*)sourceEquilibrationCheck,
					(*75*)destinationTemperature,
					(*76*)destinationEquilibrationTime,
					(*77*)maxDestinationEquilibrationTime,
					(*78*)destinationEquilibrationCheck,
					(*79*)coolingTime,
					(*80*)solidificationTime,
					(*81*)flameDestination,
					(*82*)parafilmDestination,
					(*83*)sterileTechnique,
					(*84*)rnaseFreeTechnique,
					(*85*)keepSourceCovered,
					(*86*)replaceSourceCover,
					(*87*)sourceCover,
					(*88*)sourceSeptum,
					(*89*)sourceStopper,
					(*90*)keepDestinationCovered,
					(*91*)replaceDestinationCover,
					(*92*)destinationCover,
					(*93*)destinationSeptum,
					(*94*)destinationStopper,
					(*95*)livingDestination,
					(*96*)roundedAmount,
					(*97*)Join[allCoverTests, allCoverTests2],
					(*98*)asepticHandlingSourceDestinationWarning,
					(*99*)allowSourceContainerReCover,
					(*100*)volumePrecisionRoundQ,
					(*101*)includeSachetPouch,
					(*102*)sachetIntermediateContainer,
					(*103*)handlingConditions,
					(*104*)balanceCleaningMethod,
					(*105*)equivalentTransferEnvironments,
					(*106*)overdrawVolume,
					(*107*)weightStabilityDuration,
					(*108*)maxWeightVariation,
					(*109*)tareWeightStabilityDuration,
					(*110*)maxTareWeightVariation
				}
			]
		],
		{
			(* Make all of the following objects so that we can change them in a central cache. *)
			Sequence@@Map[
				(# /. {packet:PacketP[]:>Lookup[packet, Object, Null]}&),
				{
					workingSourceSamplePackets, workingSourceContainerPackets, workingSourceContainerModelPackets,
					workingDestinationSamplePackets, workingDestinationContainerPackets, workingDestinationContainerModelPackets,
					workingCollectionContainerSamplePackets
				}
			],
			simulatedWorkingSourceQ, myAmounts, (MatchQ[#, Waste]&)/@myDestinations, mapThreadFriendlyOptionsWithPreResolvedOptions, Range[Length[myAmounts]], mySources, myDestinations
		}
	];

	(* Resolve BalancePreCleaningMethod *)
	resolvedBalancePreCleaningMethod = Which[
		(* Did user give us a value? *)
		MatchQ[Lookup[transferOptions,BalancePreCleaningMethod],Except[Automatic]],
		Lookup[transferOptions,BalancePreCleaningMethod],

		(* do we need a balance? *)
		MatchQ[Length[Cases[resolvedBalance,ObjectP[]]],GreaterP[0]],
		None,

		(* no balance *)
		True,
		Null
	];

	(* Resolve OverdrawVolumeWasteContainer *)
	(* needle volume and syringe dead volume are both generally under 1 mL, so a blanket use of a 20 mL beaker as a waste container is sufficient *)
	resolvedOverdrawVolumeWasteContainer = Which[
		MatchQ[resolvedOverdrawVolume, Alternatives[Null, {Null}, {Null..}]],
		Null,
		MatchQ[resolvedOverdrawVolume, {Quantity[_, _] ..}] && Total[resolvedOverdrawVolume] < 20 Milliliter,
		Model[Container, Vessel, "id:kEJ9mqaVPPD8"] (* Model[Container, Vessel, "20mL Pyrex Beaker *),
		MatchQ[resolvedOverdrawVolume, {Quantity[_, _] ..}] && Total[resolvedOverdrawVolume] < 100 Milliliter,
		Model[Container, Vessel, "id:aXRlGnZmOOJk"] (* Model[Container, Vessel, "100mL Pyrex Beaker"] *),
		MatchQ[resolvedOverdrawVolume, {Quantity[_, _] ..}] && Total[resolvedOverdrawVolume] < 250 Milliliter,
		Model[Container, Vessel, "id:BYDOjv1VAA8m"] (* Model[Container, Vessel, "250mL Kimax Beaker"] *),
		MatchQ[resolvedOverdrawVolume, {Quantity[_, _] ..}] && Total[resolvedOverdrawVolume] < 600 Milliliter,
		Model[Container, Vessel, "id:R8e1PjRDbbOv"] (* Model[Container, Vessel, "600mL Pyrex Beaker"] *),
		MatchQ[resolvedOverdrawVolume, {Quantity[_, _] ..}] && Total[resolvedOverdrawVolume] < 1000 Milliliter,
		Model[Container, Vessel, "id:O81aEB4kJJJo"] (* Model[Container, Vessel, "1000mL Glass Beaker"] *)
	];

	(* Resolve WasteContainer which is used to hold extra volume from intermediate container when IntermediateDecantRecoup is False OR waste from handpump/handpump adapter *)
	resolvedWasteContainer = Which[
		(* If we already have an object, use it! This happens if we are generating Transfer with the resolved options stored in MSP *)
		!MatchQ[Lookup[myOptions,WasteContainer],Automatic],
		Lookup[myOptions,WasteContainer],
		Or[
			(* FillToVolume with VolumetricFlask where we always need an intermediate container with transfer pipet and do not want to pour back *)
			And[
				Or[
					MatchQ[Lookup[myOptions,FillToVolume,False],True],
					MatchQ[Lookup[myOptions,ParentProtocol,Null],ObjectP[Object[Protocol,FillToVolume]]]
				],
				!MatchQ[Lookup[myOptions,FillToVolumeOverfillingRepreparation, False],True],
				MemberQ[workingDestinationContainerModelPackets,ObjectP[{Model[Container,Vessel,VolumetricFlask],Object[Container,Vessel,VolumetricFlask]}]]
			],
			(* We need to do IntermediateDecant, but we are not doing recoup *)
			MemberQ[
				Transpose[{resolvedIntermediateDecant,Lookup[myOptions, IntermediateDecantRecoup]}],
				{True,False}
			],
			(* We are using a handpump *)
			MemberQ[resolvedHandPump, ObjectP[]]
		],
		Model[Container, Vessel, "250mL Glass Bottle"],
		True,
		(* Otherwise no waste container needed *)
		Null
	];


	(* Resolve restricted options (RestrictSource and RestrictDestination). *)
	(* NOTE: We have to do this outside of the MapThread because if the user sets RestrictSource/Destination for one sample, *)
	(* we want that option to propagate everytime the sample shows up as a Source/Destination. *)
	restrictSourceOptions = Lookup[mapThreadFriendlyOptions,RestrictSource];
	restrictDestinationOptions = Lookup[mapThreadFriendlyOptions,RestrictDestination];

	{resolvedRestrictSource,resolvedRestrictDestination,conflictingRestrictSourceAndDestinationResult} = Module[
		{listedPairs,groupedByObject,groupedAndResolved,equalCheckAssoc,resolvedForEachObject,equalCheck},

		(* Pair each object with its restricted option *)
		listedPairs = Join[
			Transpose[{simulatedSourceObjects,restrictSourceOptions}],
			Transpose[{simulatedDestinationObjects,restrictDestinationOptions}]
		];

		(* Group by objects and extract the restricted options *)
		groupedByObject = (#[[All,2]]&)/@GroupBy[listedPairs, First];

		(* Resolve any automatics by setting them to True if another True is present otherwise False *)
		groupedAndResolved=(If[MemberQ[#, True],
			# /. (Automatic -> True),
			# /. (Automatic -> False)]) & /@ groupedByObject;

		(* Check if an object is to be both restricted and unrestricted *)
		equalCheckAssoc = Equal@@#&/@groupedAndResolved;

		(* Resolve the options *)
		resolvedForEachObject = First/@groupedAndResolved;

		(* Obtain any objects which are both restricted and unrestricted *)
		equalCheck = Cases[Normal[equalCheckAssoc], Verbatim[Rule][x_, False] :> x];

		{Lookup[resolvedForEachObject,simulatedSourceObjects],Lookup[resolvedForEachObject, simulatedDestinationObjects],equalCheck}
	];

	(* Resolve RentDestinationContainer hidden option. This is used when procedure resource picking prepares the resources by ExperimentTransfer *)
	(* This option comes from EITHER the PreparedResources packets or the RentDestinationContainer option;
    ASSUME that we will have XOR of these options (PreparedResources is passed by Engine, and RentDestinationContainer may be specified by the experiment itself);
    ASSUME we have index-matching with the manipulations in either case (Hidden option, don't enforce, please upstream don't screw up)
    the meaning here is the same though, so we can combine; set to False if we don't have either of these *)
	(* We are overwriting the option here since this is hidden *)
	resourceRentContainerBools = Which[
		MatchQ[Flatten[preparedResourcesPackets],{PacketP[]..}],
		TrueQ/@Lookup[Flatten[preparedResourcesPackets],RentContainer],
		MatchQ[Lookup[transferOptionsAssociation,RentDestinationContainer],{BooleanP..}],
		Lookup[transferOptionsAssociation,RentDestinationContainer],
		True,
		ConstantArray[False,Length[mySources]]
	];

	(* Check on valid SamplesInStorageCondition option - ExperimentTransfer allows sources to be Model[Sample], which will be fulfilled through the resource system. This means, we should not allow setting SamplesInStorageCondition for Model[Sample] inputs *)
	invalidSamplesInStorageConditionBools = MapThread[
		And[
			MatchQ[#1,ObjectP[Model[Sample]]],
			MatchQ[#2,Except[Null|Disposal]]
		]&,
		{mySources,Lookup[mapThreadFriendlyOptions,SamplesInStorageCondition]}
	];

	(* If any sample has invalid storage condition, return an error *)
	invalidSamplesInStorageConditionOptions=If[MemberQ[invalidSamplesInStorageConditionBools,True] && messages,
		Message[
			Error::InvalidTransferSourceStorageCondition,
			ObjectToString[PickList[mySources,invalidSamplesInStorageConditionBools,True], Cache->simulatedCache],
			PickList[Lookup[mapThreadFriendlyOptions,SamplesInStorageCondition],invalidSamplesInStorageConditionBools,True]
		];
		{SamplesInStorageCondition},
		{}
	];

	invalidSamplesInStorageConditionTests=If[gatherTests,
		If[MemberQ[invalidSamplesInStorageConditionBools,True],
			Test["SamplesInStorageCondition must be Null or Disposal for Model[Sample] sources:",True,False],
			Test["SamplesInStorageCondition must be Null or Disposal for Model[Sample] sources:",True,True]
		]
	];

	(* Check on valid SamplesInStorageCondition option *)
	(* 2) If the source is not allowed to be re-covered, we do not allow setting SamplesInStorageCondition to anything other than Disposal*)
	invalidNonDisposalSamplesInStorageConditionBools = MapThread[
		And[
			MatchQ[#1,False],
			MatchQ[#2,Except[Disposal]]
		]&,
		{resolvedAllowSourceContainerReCovers,Lookup[mapThreadFriendlyOptions,SamplesInStorageCondition]}
	];

	(* If any sample has invalid storage condition, return an error *)
	invalidNonDisposalSamplesInStorageConditionOptions=If[MemberQ[invalidNonDisposalSamplesInStorageConditionBools,True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Error::InvalidTransferNonDisposalSourceStorageCondition,
			ObjectToString[PickList[mySources,invalidNonDisposalSamplesInStorageConditionBools,True], Cache->simulatedCache],
			PickList[Lookup[mapThreadFriendlyOptions,SamplesInStorageCondition],invalidNonDisposalSamplesInStorageConditionBools,True]
		];
		{SamplesInStorageCondition},
		{}
	];

	invalidNonDisposalSamplesInStorageConditionTests=If[gatherTests,
		If[MemberQ[invalidNonDisposalSamplesInStorageConditionBools,True],
			Test["SamplesInStorageCondition must be Disposal for source samples in non-recoverable containers:",True,False],
			Test["SamplesInStorageCondition must be Disposal for source samples in non-recoverable containers:",True,True]
		]
	];

	(* Resolve Fresh hidden option. This is used when procedure resource picking prepares the resources by ExperimentTransfer. If the prepared resources should be Fresh, the sources here must be prepared Fresh and then transferred into the destination *)
	(* This option comes from EITHER the PreparedResources packets or the Fresh option;
    ASSUME that we will have XOR of these options (PreparedResources is passed by Engine, and Fresh may be specified by the experiment itself);
    ASSUME we have index-matching with the manipulations in either case (Hidden option, don't enforce, please upstream don't screw up)
    the meaning here is the same though, so we can combine; set to False if we don't have either of these *)
	(* We are overwriting the option here since this is hidden *)
	resourceFreshBools = Which[
		MatchQ[Flatten[preparedResourcesPackets],{PacketP[]..}],
		TrueQ/@Lookup[Flatten[preparedResourcesPackets],Fresh],
		MatchQ[Lookup[transferOptionsAssociation,Fresh],{BooleanP..}],
		Lookup[transferOptionsAssociation,Fresh],
		True,
		ConstantArray[False,Length[mySources]]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[
		ReplaceRule[myOptions, Preparation->resolvedPreparation],
		Living -> MemberQ[Lookup[workingSourceSamplePackets,Living],True],
		Sterile -> MemberQ[resolvedSterileTechnique,True]
	];

	(* Importantly, we have to make sure protocol requires advanced certificates if we end up using one (or more) of the following techniques in manual transfers *)
	resolvedSupplementalCertificates = If[
		And[
			MatchQ[resolvedPreparation, Manual],
			Or[
				(* any Multichannel Transfer? *)
				MemberQ[resolvedMultichannelTransfers, True],
				(* any Slurry Transfer using micropipette? *)
				MemberQ[resolvedSlurryTransfer, True] && MemberQ[resolvedInstrument, ObjectP[{Object[Instrument, Pipette], Model[Instrument, Pipette]}]],
				(* any Reverse Pipetting? *)
				MemberQ[resolvedReversePipetting, True],
				(* using any pipette of positive displacement kind? *)
				(* doing replace all to avoid downloading computible fields like PipetteType for object *)
				MemberQ[
					resolvedInstrument /. {obj:ObjectP[Object[Instrument]] :> fastAssocLookup[fastAssoc, obj, {Model, PipetteType}], model:ObjectP[Model[Instrument]] :> fastAssocLookup[fastAssoc, model, PipetteType]},
					PositiveDisplacement
				]
			]
		],
		(* Model[Certification, "Advanced Pipetting"] *)
		Model[Certification, "id:jLq9jXqPmvxE"],
		{}
	];


	(* Gather these options together in a list. *)
	resolvedOptions=ReplaceRule[
		myOptions,
		{
			Preparation->resolvedPreparation,
			WorkCell->resolvedWorkCell,
			SourceLabel->resolvedSourceLabels,
			SourceContainerLabel->resolvedSourceContainerLabels,
			SourceContainer->resolvedSourceContainers,
			SourceSampleGrouping->resolvedSourceSampleGroupings,
			DestinationLabel->resolvedDestinationLabels,
			DestinationContainerLabel->resolvedDestinationContainerLabels,
			Instrument->resolvedInstrument,
			TransferEnvironment->resolvedTransferEnvironment,
			EquivalentTransferEnvironments->resolvedEquivalentTransferEnvironments,
			HandlingCondition->resolvedHandlingCondition,
			SourceWell->resolvedSourceWells,
			DestinationWell->resolvedDestinationWells,
			MultichannelTransfer->resolvedMultichannelTransfers,
			MultichannelTransferName->resolvedMultichannelTransferNames,
			Balance->resolvedBalance,
			BalancePreCleaningMethod->resolvedBalancePreCleaningMethod,
			BalanceCleaningMethod->resolvedBalanceCleaningMethods,
			TabletCrusher->resolvedTabletCrusher,
			IncludeSachetPouch -> resolvedIncludeSachetPouch,
			SachetIntermediateContainer -> resolvedSachetIntermediateContainers,
			Tips->resolvedTips,
			TipType->resolvedTipType,
			TipMaterial->resolvedTipMaterial,
			ReversePipetting->resolvedReversePipetting,
			Supernatant->resolvedSupernatant,
			Magnetization->resolvedMagnetization,
			MagnetizationTime->resolvedMagnetizationTime,
			MaxMagnetizationTime->resolvedMaxMagnetizationTime,
			MagnetizationRack->resolvedMagnetizationRack,
			CollectionContainer->resolvedCollectionContainers,
			CollectionTime->resolvedCollectionTimes,
			AspirationLayer->resolvedAspirationLayer,
			DestinationLayer->Lookup[myOptions, DestinationLayer],
			Needle->resolvedNeedle,
			WeighingContainer->resolvedWeighingContainer,
			Funnel->resolvedFunnel,
			Tolerance->resolvedTolerance,
			HandPump->resolvedHandPump,
			QuantitativeTransfer->resolvedQuantitativeTransfer,
			QuantitativeTransferWashSolution->resolvedQuantitativeTransferWashSolution,
			QuantitativeTransferWashVolume->resolvedQuantitativeTransferWashVolume,
			QuantitativeTransferWashInstrument->resolvedQuantitativeTransferWashInstrument,
			QuantitativeTransferWashTips->resolvedQuantitativeTransferWashTips,
			NumberOfQuantitativeTransferWashes->resolvedNumberOfQuantitativeTransferWashes,
			UnsealHermeticSource->resolvedUnsealHermeticSource,
			UnsealHermeticDestination->resolvedUnsealHermeticDestination,
			BackfillNeedle->resolvedBackfillNeedle,
			BackfillGas->resolvedBackfillGas,
			VentingNeedle->resolvedVentingNeedle,
			TipRinse->resolvedTipRinse,
			TipRinseSolution->resolvedTipRinseSolution,
			TipRinseVolume->resolvedTipRinseVolume,
			NumberOfTipRinses->resolvedNumberOfTipRinses,
			AspirationMix->resolvedAspirationMix,
			SlurryTransfer->resolvedSlurryTransfer,
			AspirationMixType->resolvedAspirationMixType,
			NumberOfAspirationMixes->resolvedNumberOfAspirationMixes,
			MaxNumberOfAspirationMixes->resolvedMaxNumberOfAspirationMixes,
			DispenseMix->resolvedDispenseMix,
			DispenseMixType->resolvedDispenseMixType,
			NumberOfDispenseMixes->resolvedNumberOfDispenseMixes,
			PipettingMethod-> resolvedPipettingMethod,
			AspirationRate->resolvedAspirationRate,
			DispenseRate->resolvedDispenseRate,
			OverAspirationVolume->resolvedOverAspirationVolume,
			OverDispenseVolume->resolvedOverDispenseVolume,
			AspirationWithdrawalRate->resolvedAspirationWithdrawalRate,
			DispenseWithdrawalRate->resolvedDispenseWithdrawalRate,
			AspirationEquilibrationTime->resolvedAspirationEquilibrationTime,
			DispenseEquilibrationTime->resolvedDispenseEquilibrationTime,
			AspirationMixVolume->resolvedAspirationMixVolume,
			DispenseMixVolume->resolvedDispenseMixVolume,
			AspirationMixRate->resolvedAspirationMixRate,
			DispenseMixRate->resolvedDispenseMixRate,
			AspirationPosition->resolvedAspirationPosition,
			DispensePosition->resolvedDispensePosition,
			AspirationPositionOffset->resolvedAspirationPositionOffset,
			DispensePositionOffset->resolvedDispensePositionOffset,
			AspirationAngle->resolvedAspirationAngles,
			DispenseAngle->resolvedDispenseAngles,
			CorrectionCurve->resolvedCorrectionCurve,
			DynamicAspiration->resolvedDynamicAspiration,
			IntermediateDecant->resolvedIntermediateDecant,
			IntermediateContainer->resolvedIntermediateContainer,
			IntermediateFunnel->resolvedIntermediateFunnel,
			SourceTemperature->resolvedSourceTemperature,
			SourceEquilibrationTime->resolvedSourceEquilibrationTime,
			MaxSourceEquilibrationTime->resolvedMaxSourceEquilibrationTime,
			SourceEquilibrationCheck->resolvedSourceEquilibrationCheck,
			DestinationTemperature->resolvedDestinationTemperature,
			DestinationEquilibrationTime->resolvedDestinationEquilibrationTime,
			MaxDestinationEquilibrationTime->resolvedMaxDestinationEquilibrationTime,
			DestinationEquilibrationCheck->resolvedDestinationEquilibrationCheck,
			CoolingTime->resolvedCoolingTime,
			SolidificationTime->resolvedSolidificationTime,
			FlameDestination->resolvedFlameDestination,
			ParafilmDestination->resolvedParafilmDestination,
			SterileTechnique->resolvedSterileTechnique,
			RNaseFreeTechnique->resolvedRNaseFreeTechnique,
			KeepSourceCovered->resolvedKeepSourceCovered,
			ReplaceSourceCover->resolvedReplaceSourceCovers,
			SourceCover->resolvedSourceCovers,
			SourceSeptum->resolvedSourceSeptums,
			SourceStopper->resolvedSourceStoppers,
			AllowSourceContainerReCover -> resolvedAllowSourceContainerReCovers,
			KeepDestinationCovered->resolvedKeepDestinationCovered,
			ReplaceDestinationCover->resolvedReplaceDestinationCovers,
			DestinationCover->resolvedDestinationCovers,
			DestinationSeptum->resolvedDestinationSeptums,
			DestinationStopper->resolvedDestinationStoppers,

			Amount->resolvedAmount,
			KeepInstruments->suppliedKeepInstruments,
			DestinationRack->suppliedDestinationRack,
			RestrictSource->resolvedRestrictSource,
			RestrictDestination->resolvedRestrictDestination,
			DeviceChannel->resolvedDeviceChannels,

			(* MultiProbeHead-specific keys *)
			MultiProbeHeadNumberOfRows->resolvedMultiProbeHeadRows,
			MultiProbeHeadNumberOfColumns->resolvedMultiProbeColumns,
			MultiProbeAspirationOffsetRows->resolvedMultiProbeAspirationOffsetRows,
			MultiProbeAspirationOffsetColumns->resolvedMultiProbeAspirationOffsetColumns,
			MultiProbeDispenseOffsetRows->resolvedMultiProbeDispenseOffsetRows,
			MultiProbeDispenseOffsetColumns->resolvedMultiProbeDispenseOffsetColumns,

			Name->Lookup[myOptions, Name],
			ImageSample -> Lookup[resolvedPostProcessingOptions, ImageSample],
			MeasureVolume -> Lookup[resolvedPostProcessingOptions, MeasureVolume],
			MeasureWeight -> Lookup[resolvedPostProcessingOptions, MeasureWeight],
			(* If called from Engine we will generate a protocol regardless of whether the specified SamplesInStorageCondition option should have been disposal or not. *)
			(* Automatically mark these samples for disposal. *)
			SamplesInStorageCondition -> If[MatchQ[$ECLApplication, Engine],
				ReplacePart[Lookup[myOptions, SamplesInStorageCondition], Position[invalidNonDisposalSamplesInStorageConditionBools, True] -> Disposal],
				Lookup[myOptions, SamplesInStorageCondition]
			],
			SamplesOutStorageCondition -> Lookup[myOptions, SamplesOutStorageCondition],
			FillToVolume -> Lookup[myOptions, FillToVolume],
			InSitu -> Lookup[myOptions, InSitu],
			OrderFulfilled -> Lookup[myOptions, OrderFulfilled],
			PreparedResources -> Lookup[myOptions, PreparedResources],
			RentDestinationContainer -> resourceRentContainerBools,
			Fresh -> resourceFreshBools,
			SupplementalCertification -> resolvedSupplementalCertificates,
			LivingDestination -> resolvedLivingDestinations,
			OverdrawVolume -> resolvedOverdrawVolume,
			OverdrawVolumeWasteContainer -> resolvedOverdrawVolumeWasteContainer,
			WasteContainer -> resolvedWasteContainer,
			WeightStabilityDuration -> resolvedWeightStabilityDurations,
			MaxWeightVariation -> resolvedMaxWeightVariations,
			TareWeightStabilityDuration -> resolvedTareWeightStabilityDurations,
			MaxTareWeightVariation -> resolvedMaxTareWeightVariations
		}
	];

	mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentTransfer,resolvedOptions];

	(*-- AMOUNT PRECISION CHECKS --*)
	(* Above we rounded the Amount option if the instrument precision couldn't achieve the Amount input. *)
	(* See if these two numbers are different and if they are, tell the user about it. *)
	(* Note: when amount is Volume, historically we do not check rounded Transfer error if the rounding is from InstrumentPrecision when InstrumentType is Null (Hamilton for example). *)
	roundedTransferAmountResult=MapThread[
		Function[{options, amount, manipulationIndex, skipCheckQ},
			If[
				Or[
					And[
						MatchQ[Lookup[options, Amount], VolumeP],
						!TrueQ[skipCheckQ],
						!MatchQ[UnitConvert[Rationalize[Lookup[options, Amount]], Milliliter], UnitConvert[Rationalize[amount], Milliliter]]
					],
					And[
						MatchQ[Lookup[options, Amount], MassP],
						!MatchQ[UnitConvert[Rationalize[Lookup[options, Amount]], Gram], UnitConvert[Rationalize[amount], Gram]]
					]
				],
				{
					amount,
					Lookup[options, Amount],
					manipulationIndex
				},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, myAmounts, Range[Length[myAmounts]], volumePrecisionRoundQs}
	];

	roundedTransferAmountTest=If[Length[roundedTransferAmountResult]==0,
		Warning["All transfer amounts are within the resolution limits of the transfer instruments that are to be used to perform the transfer:",True,True],
		Warning["All transfer amounts are within the resolution limits of the transfer instruments that are to be used to perform the transfer:",False,True]
	];

	If[Length[roundedTransferAmountResult] > 0 && warnings,
		Message[
			Warning::RoundedTransferAmount,
			ObjectToString[roundedTransferAmountResult[[All,1]]],
			ObjectToString[roundedTransferAmountResult[[All,2]]],
			roundedTransferAmountResult[[All,3]]
		]
	];

	(* Make sure that the Precision option isn't more precise than the amount given to be transferred. *)
	invalidPrecisionResult=MapThread[
		Function[{options, manipulationIndex},
			If[MatchQ[Lookup[options, Precision], MassP] && !MatchQ[SafeRound[Lookup[options, Amount], Lookup[options, Precision]], Lookup[options, Amount]],
				{
					Lookup[options, Amount],
					Lookup[options, Precision],
					manipulationIndex
				},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	invalidPrecisionTest=If[Length[invalidPrecisionResult]==0,
		Test["The amount to be transferred is not more precise than the Precision option (if given):",True,True],
		Test["The amount to be transferred is not more precise than the Precision option (if given):",False,True]
	];

	If[Length[invalidPrecisionResult] > 0 && messages,
		Message[
			Error::InvalidTransferPrecision,
			ObjectToString[invalidPrecisionResult[[All,1]]],
			ObjectToString[invalidPrecisionResult[[All,2]]],
			invalidPrecisionResult[[All,3]]
		]
	];

	(* Make sure that our PositionOffsets don't put us out of bounds for our source/destination containers. *)
	outOfBoundsResult=Module[{outOfBoundsHelperFunction},
		(* Define a helper function for us to map over. *)
		outOfBoundsHelperFunction[wellInformation_, positionOffset_, containerModelPacket_, manipulationIndex_]:=Which[
			(* If the user gave an invalid well, don't consider it. *)
			(* If the user hasn't specified the position offset, or specifies the position offset as a single number (Z offset), then it can't be out of bounds. *)
			!MatchQ[wellInformation, _Association] || !MatchQ[positionOffset, _Coordinate],
				Nothing,
			Or[
				(* Check for an out of bounds error in the X dimension. *)
				And[
					!MatchQ[Lookup[wellInformation, MaxWidth], Null],
					MatchQ[Lookup[wellInformation, MaxWidth]/2, LessP[Abs[positionOffset[[1]][[1]]]]]
				],
				(* Check for an out of bounds error in the Y dimension. *)
				And[
					!MatchQ[Lookup[wellInformation, MaxDepth], Null],
					MatchQ[Lookup[wellInformation, MaxDepth]/2, LessP[Abs[positionOffset[[1]][[2]]]]]
				]
			],
				{positionOffset, Lookup[containerModelPacket, Object], Lookup[wellInformation, Name], manipulationIndex},
			True,
				Nothing
		];

		MapThread[
			Function[{options, sourceWell, sourceContainerModelPacket, destinationWell, destinationContainerModelPacket, manipulationIndex},
				Sequence@@{
					Module[{sourceWellInformation, aspirationPositionOffset},
						sourceWellInformation=FirstCase[Lookup[sourceContainerModelPacket, Positions], KeyValuePattern[Name->sourceWell], Null];
						aspirationPositionOffset=Lookup[options, AspirationPositionOffset];

						outOfBoundsHelperFunction[sourceWellInformation, aspirationPositionOffset, sourceContainerModelPacket, manipulationIndex]
					],
					Module[{destinationWellInformation, dispensePositionOffset},
						destinationWellInformation=FirstCase[Lookup[destinationContainerModelPacket, Positions], KeyValuePattern[Name->destinationWell], Null];
						dispensePositionOffset=Lookup[options, DispensePositionOffset];

						outOfBoundsHelperFunction[destinationWellInformation, dispensePositionOffset, sourceContainerModelPacket, manipulationIndex]
					]
				}
			],
			{mapThreadFriendlyResolvedOptions, resolvedSourceWells, workingSourceContainerModelPackets, resolvedDestinationWells, workingDestinationContainerModelPackets, Range[Length[myAmounts]]}
		]
	];

	outOfBoundsTest=If[Length[outOfBoundsResult]==0,
		Test["The specified AspirationPositionOffset/DispensePositionOffset options do not extend beyond the bounds of the wells that are being aspirated/dispense from:",True,True],
		Test["The specified AspirationPositionOffset/DispensePositionOffset options do not extend beyond the bounds of the wells that are being aspirated/dispense from:",False,True]
	];

	If[Length[outOfBoundsResult] > 0 && messages,
		Message[
			Error::PositionOffsetOutOfBounds,
			ObjectToString[outOfBoundsResult[[All,1]]],
			ObjectToString[outOfBoundsResult[[All,2]], Cache->cache],
			outOfBoundsResult[[All,3]],
			outOfBoundsResult[[All,4]]
		];
	];

	(* Make sure that we're not trying to tilt a non-plate. *)
	tiltNonPlateResult=MapThread[
		Function[{options, sourceContainerModelPacket, destinationContainerModelPacket, manipulationIndex},
			Sequence@@{
				If[And[
						!MatchQ[Lookup[sourceContainerModelPacket, Footprint], Plate],
						MatchQ[Lookup[options, AspirationMixType], Tilt] || MatchQ[Lookup[options, AspirationAngle], Except[Null|0 AngularDegree|0. AngularDegree]]
					],
					{Lookup[sourceContainerModelPacket, Object], manipulationIndex},
					Nothing
				],
				If[And[
						!MatchQ[Lookup[destinationContainerModelPacket, Footprint], Plate],
						MatchQ[Lookup[options, DispenseMixType], Tilt] || MatchQ[Lookup[options, DispenseAngle], Except[Null|0 AngularDegree|0. AngularDegree]]
					],
					{Lookup[destinationContainerModelPacket, Object], manipulationIndex},
					Nothing
				]
			}
		],
		{mapThreadFriendlyResolvedOptions, workingSourceContainerModelPackets, workingDestinationContainerModelPackets, Range[Length[myAmounts]]}
	];

	tiltNonPlateTest=If[Length[tiltNonPlateResult]==0,
		Test["Non-plate containers cannot be tilted during the course of a transfer (the integrated Hamilton plate tilter module only works with plates):",True,True],
		Test["Non-plate containers cannot be tilted during the course of a transfer (the integrated Hamilton plate tilter module only works with plates):",False,True]
	];

	If[Length[tiltNonPlateResult] > 0 && messages,
		Message[
			Error::CannotTiltNonPlate,
			ObjectToString[tiltNonPlateResult[[All,1]], Cache->cache],
			ObjectToString[tiltNonPlateResult[[All,2]]]
		];
	];

	(* TODO: Cannot specify AspirationAngle and Magnetization. *)

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check that we were not given empty wells *)
	missingSampleErrorsTest=If[Length[missingSampleErrors]==0,
		Test["No transfers were specified from wells that do not contain samples:",True,True],
		Test["No transfers were specified from wells that do not contain samples:",False,True]
	];

	If[Length[missingSampleErrors]>0&&messages,
		Message[
			Error::InvalidTransferSource,
			missingSampleErrors
		]
	];

	(* Check that we were able to find a syringe that is compatible with our transfers. *)
	noCompatibleSyringesTest=If[Length[noCompatibleSyringesErrors]==0,
		Test["If a syringe is required for the transfers, there is a compatible syringe that satisfy the transfer requirements:",True,True],
		Test["If a syringe is required for the transfers, there is a compatible syringe that satisfy the transfer requirements:",False,True]
	];

	If[Length[noCompatibleSyringesErrors] > 0 && messages,
		Message[
			Error::NoCompatibleSyringe,
			ObjectToString[noCompatibleSyringesErrors[[All,1]], Cache->simulatedCache],
			ObjectToString[noCompatibleSyringesErrors[[All,2]], Cache->simulatedCache],
			noCompatibleSyringesErrors[[All,3]],
			noCompatibleSyringesErrors[[All,4]]
		]
	];

	(* Check that we were able to find compatible tips for our transfers. *)
	noCompatibleTipsTest=If[Length[noCompatibleTipsErrors]==0,
		Test["If tip related options are given (TipMaterial, TipType, Instrument is a Pipette), there are compatible tips that satisfy these requirements:",True,True],
		Test["If tip related options are given (TipMaterial, TipType, Instrument is a Pipette), there are compatible tips that satisfy these requirements:",False,True]
	];

	If[Length[noCompatibleTipsErrors] > 0 && messages,
		Message[
			Error::NoCompatibleTips,
			ObjectToString[noCompatibleTipsErrors[[All,1]], Cache->simulatedCache],
			ObjectToString[noCompatibleTipsErrors[[All,2]], Cache->simulatedCache],
			noCompatibleTipsErrors[[All,3]],
			noCompatibleTipsErrors[[All,4]]
		]
	];

	(* Check that the chosen magnetization rack has an open position for the working source container's footprint. *)
	magneticRackTest=If[Length[magneticRackErrors]==0,
		Test["All given MagneticRacks are magnetic and can hold the source/intermediate container:",True,True],
		Test["All given MagneticRacks are magnetic and can hold the source/intermediate container:",False,True]
	];

	If[Length[magneticRackErrors] > 0 && messages,
		Message[
			Error::MagneticRackMismatch,
			ObjectToString[magneticRackErrors[[All,1]], Cache->simulatedCache],
			magneticRackErrors[[All,2]],
			magneticRackErrors[[All,3]]
		]
	];

	(* Make sure that the supernatant/layer option isn't set for a non-liquid sample. *)
	layerSupernatantTest=If[Length[layerSupernatantLiquidErrors]==0,
		Test["The corresponding samples that have AspirationLayer/DestinationLayer/Supernatant set must be liquids:",True,True],
		Test["The corresponding samples that have AspirationLayer/DestinationLayer/Supernatant set must be liquids:",False,True]
	];

	If[Length[layerSupernatantLiquidErrors] > 0 && messages,
		Message[
			Error::InvalidLayerLiquid,
			ObjectToString[layerSupernatantLiquidErrors[[All,1]], Cache->simulatedCache],
			layerSupernatantLiquidErrors[[All,2]],
			layerSupernatantLiquidErrors[[All,3]]
		]
	];

	(* Make sure that our funnel option can fit into our destination container. *)
	funnelDestinationTest=If[Length[funnelDestinationResult]==0,
		Test["All Funnels must be able to fit in the destination container and must contain any incompatible materials with the source sample:",True,True],
		Test["All Funnels must be able to fit in the destination container and must contain any incompatible materials with the source sample:",False,True]
	];

	If[Length[funnelDestinationResult] > 0 && messages,
		Message[
			Error::InvalidDestinationFunnel,
			ObjectToString[funnelDestinationResult[[All,1]], Cache->simulatedCache],
			ObjectToString[funnelDestinationResult[[All,2]]],
			funnelDestinationResult[[All,3]],
			funnelDestinationResult[[All,4]],
			funnelDestinationResult[[All,5]]
		]
	];

	(* Make sure that our funnel option can fit into our intermediate container. *)
	funnelIntermediateTest=If[Length[funnelIntermediateResult]==0,
		Test["All Intermediate Funnels must be able to fit in the intermediate container and must contain any incompatible materials with the source sample:",True,True],
		Test["All Intermediate Funnels must be able to fit in the intermediate container and must contain any incompatible materials with the source sample:",False,True]
	];

	If[Length[funnelIntermediateResult] > 0 && messages,
		Message[
			Error::InvalidIntermediateFunnel,
			ObjectToString[funnelIntermediateResult[[All,1]], Cache->simulatedCache],
			ObjectToString[funnelIntermediateResult[[All,2]]],
			funnelIntermediateResult[[All,3]],
			funnelIntermediateResult[[All,4]]
		]
	];

	(* If the tips are specified by the user, make sure that the tips can hold the full amount of volume requested. Exception is made for Model[Item,Consumable] since this is only called inside FillToVolume cases with VolumetricFlask transfers *)
	incompatibleTipsResult=MapThread[
		Function[{options, resolvedOptions, amount, manipulationIndex},
			If[MatchQ[Lookup[options, Tips], ObjectP[]] && MatchQ[amount, VolumeP] && MatchQ[Lookup[options, Tips],Except[ObjectP[{Model[Item, Consumable],Object[Item,Consumable]}]]],
				Module[{tipModel,volumeWithRoboticTransportVolumes, compatibleTips},
					(* Get the model packet for these tips. *)
					tipModel=Which[
						MatchQ[Lookup[options, Tips], ObjectP[Object[Item, Tips]]],
							fastAssocLookup[fastAssoc, Lookup[options, Tips], {Model, Object}],
						MatchQ[Lookup[options, Tips], ObjectP[Model[Item, Tips]]],
							Download[Lookup[options, Tips], Object],
						True,
							Null
					];

					(* This is the full amount of volume that the tip needs to be able to hold. *)
					volumeWithRoboticTransportVolumes=If[MatchQ[resolvedPreparation, Robotic],
						Total[{
							If[MatchQ[Lookup[resolvedOptions, OverDispenseVolume], VolumeP],
								Lookup[resolvedOptions, OverDispenseVolume],
								0 Microliter
							],
							If[MatchQ[Lookup[resolvedOptions, CorrectionCurve], {{VolumeP, VolumeP}..}],
								(* NOTE: LinearModelFit only works with floats, not quantities. *)
								LinearModelFit[
									Lookup[resolvedOptions, CorrectionCurve] /. {vol : VolumeP :> QuantityMagnitude[UnitConvert[vol, Microliter]]},
									x,
									x
								][QuantityMagnitude[UnitConvert[amount, Microliter]]] * Microliter,
								amount
							],
							If[MatchQ[Lookup[resolvedOptions, OverAspirationVolume], VolumeP],
								Lookup[resolvedOptions, OverAspirationVolume],
								0 Microliter
							]
						}],
						amount
					];

					(* Get the tips that would be compatible with this transfer. *)
					compatibleTips=TransferDevices[
						Model[Item, Tips],
						volumeWithRoboticTransportVolumes,
						TipType->Lookup[resolvedOptions, TipType],
						TipMaterial->Lookup[resolvedOptions, TipMaterial],
						PipetteType->If[MatchQ[resolvedPreparation, Robotic],
							Hamilton,
							{Micropipette, Serological, PositiveDisplacement}
						],
						(* We need to check all possible tips instead of only EngineDefault because we may have been given a tip option from the user and it may not be EngineDefault *)
						EngineDefault->All,
						(* Since now we officially allow multipule transfers on pipette tips when doing MSP, include this option in TransferDevices *)
						AllowMultipleTransfers -> If[MatchQ[resolvedPreparation, Manual],
							True,
							False
						]
					][[All,1]];

					(* If our tip isn't compatible, log it so that we can throw an error. *)
					If[!MemberQ[compatibleTips, tipModel],
						{tipModel, volumeWithRoboticTransportVolumes, manipulationIndex},
						Nothing
					]
				],
				Nothing
			]
		],
		{mapThreadFriendlyOptions, mapThreadFriendlyResolvedOptions, myAmounts, Range[Length[myAmounts]]}
	];

	incompatibleTipsTest=If[Length[incompatibleTipsResult]==0,
		Test["Any tips that are specified can (1) hold the volume required for the transfer, (2) compatible with the TipType option, (3) compatible with the TipMaterial option, (4) compatible with the SterileTechnique option:",True,True],
		Test["Any tips that are specified can (1) hold the volume required for the transfer, (2) compatible with the TipType option, (3) compatible with the TipMaterial option, (4) compatible with the SterileTechnique option:",False,True]
	];

	If[Length[incompatibleTipsResult] > 0 && messages,
		Message[
			Error::IncompatibleTips,
			ObjectToString[incompatibleTipsResult[[All,1]]],
			ObjectToString[incompatibleTipsResult[[All,2]]],
			incompatibleTipsResult[[All,3]]
		]
	];

	(* We must be given an instrument if we are not transferring All. *)
	(* Exceptions: 1) liquid transfers by mass, where you can transfer by pouring into a container on a balance, 2) when using Model[Item,Consumable]/Object[Item,Consumable] as Tips during FTV *)
	(* NOTE: Do not throw this error if we're being called from the hamilton code. *)
	instrumentRequiredResult=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{options, manipulationIndex, sourceObject,destinationContainerModelPacket},
				If[

					And[
						MatchQ[Lookup[options, Instrument], Null],
						!MatchQ[Lookup[options, Amount], All],
						!(Or[
							(* We can allow Null instrument if we're pouring a liquid to measure by weight *)
							And[
								MatchQ[Lookup[options, Amount],MassP],
								MatchQ[Lookup[FirstCase[workingSourceSamplePackets,AssociationMatchP[<|Object->Download[sourceObject,Object]|>,AllowForeignKeys->True]|AssociationMatchP[<|Model->LinkP[sourceObject]|>,AllowForeignKeys->True]],State],Liquid],
								MatchQ[Lookup[options,Balance],ObjectP[Model[Instrument,Balance]]]
							],
							(* we are doing FTV into a VolumetricFlask - this is used during the first initial resolution of Transfer options inside FTV protocol *)
							And[
								MatchQ[Lookup[options,FillToVolume],True],
								MatchQ[destinationContainerModelPacket,ObjectP[{Model[Container,Vessel,VolumetricFlask],Object[Container,Vessel,VolumetricFlask]}]]
							],
							(* we are doing FTV into a VolumetricFlask - this is used during MSP call on Transfer UO or ExperimentTransfer call on MSP ResolvedUOs during FTV protocol *)
							And[
								MatchQ[Lookup[options,Tips],ObjectP[{Model[Item,Consumable],Object[Item,Consumable]}]],
								MatchQ[destinationContainerModelPacket,ObjectP[{Model[Container,Vessel,VolumetricFlask],Object[Container,Vessel,VolumetricFlask]}]]
							]
						])
					],
					{Lookup[options, Amount], manipulationIndex},
					Nothing
				]
			],
			{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]], simulatedSources,workingDestinationContainerModelPackets}
		]
	];

	instrumentRequiredTest=If[Length[instrumentRequiredResult]==0,
		Test["Any transfers that are not Amount->All must have an Instrument used to perform the transfer:",True,True],
		Test["Any transfers that are not Amount->All must have an Instrument used to perform the transfer:",False,True]
	];

	If[Length[instrumentRequiredResult] > 0 && messages,
		Message[
			Error::TransferInstrumentRequired,
			ObjectToString[instrumentRequiredResult[[All,1]]],
			instrumentRequiredResult[[All,2]]
		]
	];

	(* Make sure that all transfers with Supernatant->True must have AspirationLayer->1. *)
	(* note: we allow AspirationLayer to be Null when Preparation is Robotic *)
	aspirationLayerSupernatantMismatchResult=MapThread[
		Function[{options, manipulationIndex},
			If[Or[
					MatchQ[Lookup[options, Supernatant], True] && !MatchQ[Lookup[options, AspirationLayer], 1] && MatchQ[resolvedPreparation, Manual],
					!MatchQ[Lookup[options, Supernatant], True] && MatchQ[Lookup[options, AspirationLayer], 1]
				],
				{Lookup[options, Supernatant], Lookup[options, AspirationLayer], manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	aspirationLayerSupernatantMismatchTest=If[Length[aspirationLayerSupernatantMismatchResult]==0,
		Test["All transfers that have Supernatant->True must have the AspirationLayer specified as 1 (the top most layer):",True,True],
		Test["All transfers that have Supernatant->True must have the AspirationLayer specified as 1 (the top most layer):",False,True]
	];

	If[Length[aspirationLayerSupernatantMismatchResult] > 0 && messages,
		Message[
			Error::SupernatantAspirationLayerMismatch,
			aspirationLayerSupernatantMismatchResult[[All,1]],
			aspirationLayerSupernatantMismatchResult[[All,2]],
			aspirationLayerSupernatantMismatchResult[[All,3]]
		]
	];

	(* The AspirationLayer and DestinationLayer options can only be specified if the instrument is a syringe, pipette, or aspiratior. *)
	layerInstrumentMismatchResult=MapThread[
		Function[{options, manipulationIndex},
			If[And[
					Or[
						MatchQ[Lookup[options, AspirationLayer], Except[Null]],
						MatchQ[Lookup[options, DestinationLayer], Except[Null]]
					],
					!MatchQ[Lookup[options, Instrument], ObjectP[{Model[Container,Syringe], Object[Container,Syringe], Model[Instrument,Pipette], Object[Instrument,Pipette], Model[Instrument, Aspirator], Object[Instrument, Aspirator]}]]
				],
				{Lookup[options, Instrument], manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	layerInstrumentMismatchTest=If[Length[layerInstrumentMismatchResult]==0,
		Test["All transfers with AspirationLayer/DestinationLayer specified must occur with a syringe, pipette, or aspirator:",True,True],
		Test["All transfers with AspirationLayer/DestinationLayer specified must occur with a syringe, pipette, or aspirator:",False,True]
	];

	If[Length[layerInstrumentMismatchResult] > 0 && messages,
		Message[
			Error::LayerInstrumentMismatch,
			ObjectToString[layerInstrumentMismatchResult[[All,1]], Cache->simulatedCache],
			layerInstrumentMismatchResult[[All,2]]
		]
	];

	(* We must be given a multi-channel pipette if MultichannelTransfer->True. *)
	invalidMultichannelTransferInstrumentResult=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{options, manipulationIndex},
				If[Or[
					(* MultichannelTransfer->True but a pipette/aspirator isn't given. *)
					And[
						MatchQ[Lookup[options, MultichannelTransfer], True],
						!MatchQ[Lookup[options, Instrument], ObjectP[{Object[Instrument, Pipette], Model[Instrument, Pipette], Object[Instrument, Aspirator], Model[Instrument, Aspirator]}]]
					],

					(* MultichannelTransfer->True but the Model[Instrument, Pipette/Aspirator] doesn't have more than 1 channel. *)
					And[
						MatchQ[Lookup[options, MultichannelTransfer], True],
						MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Pipette], Model[Instrument, Aspirator]}]],
						!MatchQ[Lookup[fetchPacketFromCache[Lookup[options, Instrument], Flatten[{allMultichannelPipetteModelPackets, allAspiratorModelPackets}]], Channels], GreaterP[1]]
					],

					(* MultichannelTransfer->True but the Object[Instrument, Pipette] doesn't have more than 1 channel. *)
					And[
						MatchQ[Lookup[options, MultichannelTransfer], True],
						MatchQ[Lookup[options, Instrument], ObjectP[{Object[Instrument, Pipette], Object[Instrument, Aspirator]}]],
						!MatchQ[
							fastAssocLookup[fastAssoc, Lookup[options, Instrument], Channels],
							GreaterP[1]
						]
					]
				],
					{Lookup[options, Instrument], manipulationIndex},
					Nothing
				]
			],
			{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
		]
	];

	invalidMultichannelTransferTest=If[Length[invalidMultichannelTransferInstrumentResult]==0,
		Test["Any transfers that are specified as MultichannelTransfer->True must use a multi-channel pipette or aspirator:",True,True],
		Test["Any transfers that are specified as MultichannelTransfer->True must use a multi-channel pipette or aspirator:",False,True]
	];

	If[Length[invalidMultichannelTransferInstrumentResult] > 0 && messages,
		Message[
			Error::MultichannelPipetteRequired,
			ObjectToString[invalidMultichannelTransferInstrumentResult[[All,1]], Cache->simulatedCache],
			invalidMultichannelTransferInstrumentResult[[All,2]]
		]
	];

	(* Check MultiProbeHead transfers for being rectangular. *)
	invalidMultiProbeHeadDimensionsTest=If[Length[incorrectMultiProbeHeadTransfer]==0,
		Test["Any transfers that use MultiProbeHead much have source/destination rectangular:",True,True],
		Test["Any transfers that use MultiProbeHead much have source/destination rectangular:",False,True]
	];

	If[Length[incorrectMultiProbeHeadTransfer]>0 && messages,
		Message[
			Error::MultiProbeHeadDimension,
			Flatten[incorrectMultiProbeHeadTransfer]
		]
	];

	(* Check if any LLD options were specified for dispense in MxN transfer *)
	invalidMNDispenseOptionsTest=If[Length[invalidMNDispenseErrors]==0,
		Test["When performing MxN MultiProbeHead transfer, DispensePosition is not LiquidLevel:",True,True],
		Test["When performing MxN MultiProbeHead transfer, DispensePosition is not LiquidLevel:",False,True]
	];

	If[Length[invalidMNDispenseErrors]>0 && messages,
		Message[
			Error::MultiProbeHeadDispenseLLD,
			Flatten[invalidMNDispenseErrors]
		]
	];

	(* Correction Curve Error Checking *)
	monotonicCorrectionCurveTest=If[Length[monotonicCorrectionCurveWarnings]==0,
		Warning["The specified CorrectionCurve has actual values that are not monotonically increasing:",True,True],
		Warning["The specified CorrectionCurve has actual values that are not monotonically increasing:",False,True]
	];

	If[Length[monotonicCorrectionCurveWarnings]>0 && messages,
		Message[
			Warning::CorrectionCurveNotMonotonic,
			Sequence@@Transpose[monotonicCorrectionCurveWarnings]
		]
	];

	incompleteCorrectionCurveTest=If[Length[incompleteCorrectionCurveWarnings]==0,
		Warning["The specified CorrectionCurve covers the full transfer volume range of 0 uL - 1000 uL:",True,True],
		Warning["The specified CorrectionCurve covers the full transfer volume range of 0 uL - 1000 uL:",False,True]
	];

	If[Length[incompleteCorrectionCurveWarnings]>0 && messages,
		Message[
			Warning::CorrectionCurveIncomplete,
			Sequence@@Transpose[incompleteCorrectionCurveWarnings]
		]
	];

	invalidZeroCorrectionTest=If[Length[invalidZeroCorrectionErrors]==0,
		Test["The specified CorrectionCurve's actual volume corresponding to a target volume of 0 Microliter must be 0 Microliter:",True,True],
		Test["The specified CorrectionCurve's actual volume corresponding to a target volume of 0 Microliter must be 0 Microliter:",False,True]
	];

	If[Length[invalidZeroCorrectionErrors]>0 && messages,
		Message[
			Error::InvalidCorrectionCurveZeroValue,
			Sequence@@Transpose[invalidZeroCorrectionErrors]
		]
	];

	(* Amount must be All if an aspirator is specified. *)
	invalidAspiratorAmountResult=MapThread[
		Function[{options, amount, manipulationIndex},
			If[MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Aspirator], Object[Instrument, Aspirator]}]] && !MatchQ[amount, All],
				{Lookup[options, Instrument], amount, manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, myAmounts, Range[Length[myAmounts]]}
	];

	invalidAspiratorAmountTest=If[Length[invalidAspiratorAmountResult]==0,
		Test["Any transfers that use a Model[Instrument, Aspirator] must have the amount transferred set to All:",True,True],
		Test["Any transfers that use a Model[Instrument, Aspirator] must have the amount transferred set to All:",False,True]
	];

	If[Length[invalidAspiratorAmountResult] > 0 && messages,
		Message[
			Error::InvalidAspirationAmount,
			ObjectToString[invalidAspiratorAmountResult[[All,1]], Cache->simulatedCache],
			invalidAspiratorAmountResult[[All,2]],
			invalidAspiratorAmountResult[[All,3]]
		]
	];

	(* Instrument must be a cell aspirator if the destination is waste. *)
	invalidCellAspiratorResult=MapThread[
		Function[{options, destination, manipulationIndex},
			If[Or[
					And[
						MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Aspirator], Object[Instrument, Aspirator]}]],
						!MatchQ[destination, Waste]
					],
					And[
						!MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Aspirator], Object[Instrument, Aspirator]}]],
						MatchQ[destination, Waste]
					]
				],
				{Lookup[options, Instrument], destination, manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, myDestinations, Range[Length[myAmounts]]}
	];

	invalidCellAspiratorTest=If[Length[invalidCellAspiratorResult]==0,
		Test["Any transfers that use a Model[Instrument, Aspirator] must have the destination set as Waste:",True,True],
		Test["Any transfers that use a Model[Instrument, Aspirator] must have the destination set as Waste:",False,True]
	];

	If[Length[invalidCellAspiratorResult] > 0 && messages,
		Message[
			Error::InvalidWasteAspiration,
			ObjectToString[invalidCellAspiratorResult[[All,1]], Cache->simulatedCache],
			invalidCellAspiratorResult[[All,2]],
			invalidCellAspiratorResult[[All,3]]
		]
	];

	(* Magnetization options must be all specified or not specified at all. *)
	magnetizationSpecifiedResult=MapThread[
		Function[{options, manipulationIndex},
			If[MatchQ[resolvedPreparation,Manual],
				If[!Or[
					And[
						MatchQ[Lookup[options, Magnetization], True],
						MatchQ[Lookup[options, MagnetizationTime], TimeP],
						MatchQ[Lookup[options, MaxMagnetizationTime], TimeP],
						MatchQ[Lookup[options, MagnetizationRack], ObjectP[{Model[Container, Rack], Object[Container,Rack], Model[Item, MagnetizationRack], Object[Item, MagnetizationRack]}]]
					],
					And[
						MatchQ[Lookup[options, Magnetization], False|Null],
						MatchQ[Lookup[options, MagnetizationTime], Null],
						MatchQ[Lookup[options, MaxMagnetizationTime], Null],
						MatchQ[Lookup[options, MagnetizationRack], Null]
					]
				],
					{Lookup[options, Magnetization], Lookup[options, MagnetizationTime], Lookup[options, MaxMagnetizationTime], Lookup[options, MagnetizationRack], manipulationIndex},
					Nothing
				],
				If[!Or[
					And[
						MatchQ[Lookup[options, Magnetization], True],
						MatchQ[Lookup[options, MagnetizationTime], TimeP],
						MatchQ[Lookup[options, MagnetizationRack], ObjectP[{Model[Container, Rack], Object[Container,Rack], Model[Item, MagnetizationRack], Object[Item, MagnetizationRack]}]]
					],
					And[
						MatchQ[Lookup[options, Magnetization], False|Null],
						MatchQ[Lookup[options, MagnetizationTime], Null],
						MatchQ[Lookup[options, MagnetizationRack], Null]
					]
				],
					{Lookup[options, Magnetization], Lookup[options, MagnetizationTime], Lookup[options, MaxMagnetizationTime], Lookup[options, MagnetizationRack], manipulationIndex},
					Nothing
				]
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	magnetizationSpecifiedTest=If[Length[magnetizationSpecifiedResult]==0,
		Test["The Magnetization related options (Magnetization/MagnetizationTime/MaxMagnetizationTime/MagnetizationRack) must be all set or not set at all:",True,True],
		Test["The Magnetization related options (Magnetization/MagnetizationTime/MaxMagnetizationTime/MagnetizationRack) must be all set or not set at all:",False,True]
	];

	If[Length[magnetizationSpecifiedResult] > 0 && messages,
		Message[
			Error::MagnetizationOptionsMismatch,
			magnetizationSpecifiedResult[[All,1]],
			magnetizationSpecifiedResult[[All,2]],
			magnetizationSpecifiedResult[[All,3]],
			magnetizationSpecifiedResult[[All,4]],
			magnetizationSpecifiedResult[[All,5]]
		]
	];

	(* CollectionContainer options must be all specified or not specified at all. *)
	collectionContainerSpecifiedResult=MapThread[
		Function[{options, manipulationIndex},
			If[Or[
					And[
						MatchQ[Lookup[options, CollectionContainer], ObjectP[]],
						!MatchQ[Lookup[options, CollectionTime], TimeP]
					],
					And[
						!MatchQ[Lookup[options, CollectionContainer], ObjectP[]],
						MatchQ[Lookup[options, CollectionTime], TimeP]
					]
				],
				{Lookup[options, CollectionContainer], Lookup[options, CollectionTime], manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	collectionContainerSpecifiedTest=If[Length[collectionContainerSpecifiedResult]==0,
		Test["The CollectionContainer related options (CollectionContainer/CollectionTime) must be all set or not set at all:",True,True],
		Test["The CollectionContainer related options (CollectionContainer/CollectionTime) must be all set or not set at all:",False,True]
	];

	If[Length[collectionContainerSpecifiedResult] > 0 && messages,
		Message[
			Error::CollectionContainerOptionsMismatch,
			collectionContainerSpecifiedResult[[All,1]],
			collectionContainerSpecifiedResult[[All,2]],
			collectionContainerSpecifiedResult[[All,3]]
		]
	];

	(* CollectionContainer's Footprint must match the destination container's Footprint. *)
	collectionContainerFootprintResult = MapThread[
		Function[{options, destinationContainerModelPacket, manipulationIndex},
			If[MatchQ[Lookup[options, CollectionContainer], ObjectP[]],
				Module[{collectionContainerFootprint, destinationContainerFootprint},
					collectionContainerFootprint = If[MatchQ[Lookup[options, CollectionContainer], ObjectP[Model[Container]]],
						fastAssocLookup[fastAssoc, Lookup[options, CollectionContainer], Footprint],
						fastAssocLookup[fastAssoc, Lookup[options, CollectionContainer], {Model, Footprint}]
					];
					destinationContainerFootprint = Lookup[destinationContainerModelPacket, Footprint];

					If[!MatchQ[collectionContainerFootprint, destinationContainerFootprint],
						{Lookup[options, CollectionContainer], collectionContainerFootprint, destinationContainerFootprint, manipulationIndex},
						Nothing
					]
				],
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, workingDestinationContainerModelPackets, Range[Length[myAmounts]]}
	];

	collectionContainerFootprintTest=If[Length[collectionContainerSpecifiedResult]==0,
		Test["If CollectionContainer is specified, it has the same Footprint as the destination sample's container (since the CollectionContainer will be stacked underneath the destination sample's container):",True,True],
		Test["If CollectionContainer is specified, it has the same Footprint as the destination sample's container (since the CollectionContainer will be stacked underneath the destination sample's container):",False,True]
	];

	If[Length[collectionContainerFootprintResult] > 0 && messages,
		Message[
			Error::CollectionContainerFootprintMismatch,
			ObjectToString[collectionContainerFootprintResult[[All,1]], Cache->cache],
			collectionContainerFootprintResult[[All,2]],
			collectionContainerFootprintResult[[All,3]],
			collectionContainerFootprintResult[[All,4]]
		]
	];

	(* We must be given an instrument if the source is in a plate. *)
	(* For future proofing, we will define a plate as any container model that has more than one position. *)
	plateInstrumentRequiredResult=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{sourceContainerModelPacket, options, manipulationIndex},
				If[MatchQ[Lookup[options, Instrument], Null] && MatchQ[Length[Lookup[sourceContainerModelPacket, Positions]], GreaterP[1]],
					{Lookup[workingSourceContainerModelPackets, Object], manipulationIndex},
					Nothing
				]
			],
			{workingSourceContainerModelPackets, mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
		]
	];

	plateInstrumentRequiredTest=If[Length[plateInstrumentRequiredResult]==0,
		Test["Any transfers that specify pouring (Instrument->Null) cannot have the source sample be in a plate:",True,True],
		Test["Any transfers that specify pouring (Instrument->Null) cannot have the source sample be in a plate:",False,True]
	];

	If[Length[plateInstrumentRequiredResult] > 0 && messages,
		Message[
			Error::PlateTransferInstrumentRequired,
			ObjectToString[plateInstrumentRequiredResult[[All,1]], Cache->simulatedCache],
			plateInstrumentRequiredResult[[All,2]]
		]
	];

	(* Check that if we're given the Tolerance option and a Balance, that the Balance can actually achieve the Tolerance. *)
	balanceToleranceResult=MapThread[
		Function[{options, manipulationIndex},
			If[MatchQ[Lookup[options, Balance], ObjectP[{Model[Instrument,Balance], Object[Instrument,Balance]}]] && MatchQ[Lookup[options, Tolerance], MassP],
				Module[{balanceModelPacket},
					(* Get the packet for the balance model. *)
					balanceModelPacket=If[MatchQ[Lookup[options, Balance], ObjectP[{Model[Instrument,Balance]}]],
						fetchPacketFromFastAssoc[Lookup[options, Balance], fastAssoc],
						fastAssocPacketLookup[fastAssoc, Lookup[options, Balance], Model]
					];

					(* There is a problem if the tolerance is not greater than the resolution of the balance. *)
					If[!MatchQ[Lookup[options, Tolerance], GreaterEqualP[Lookup[balanceModelPacket, Resolution]]],
						{
							Lookup[options, Tolerance],
							Lookup[balanceModelPacket, Resolution],
							manipulationIndex
						},
						Nothing
					]
				],
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	balanceToleranceTest=If[Length[balanceToleranceResult]==0,
		Test["Any given Tolerances (for transfer by mass) must be greater than the Resolution of the accompanying Balance:",True,True],
		Test["Any given Tolerances (for transfer by mass) must be greater than the Resolution of the accompanying Balance:",False,True]
	];

	If[Length[balanceToleranceResult] > 0 && messages,
		Message[
			Error::ToleranceLessThanBalanceResolution,
			balanceToleranceResult[[All,1]],
			balanceToleranceResult[[All,2]],
			balanceToleranceResult[[All,3]]
		]
	];

	(* Check that if SterileTechnique->True, the TransferEnvironment is a BSC. *)
	sterileTransfersAreInBSCResult=MapThread[
		Function[{options, manipulationIndex},
			If[And[
					!MatchQ[resolvedPreparation, Robotic],
					Or[
						MatchQ[Lookup[options, SterileTechnique], True] && MatchQ[Lookup[options, TransferEnvironment], Except[ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]]],
						MatchQ[Lookup[options, SterileTechnique], False] && MatchQ[Lookup[options, TransferEnvironment], ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]]
					]
				],
				{Download[Lookup[options, TransferEnvironment], Object], manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	sterileTransfersAreInBSCTest=If[Length[sterileTransfersAreInBSCResult]==0,
		Test["All manual transfers that have SterileTechnique->True must occur in a Biosafety Cabinet:",True,True],
		Test["All manual transfers that have SterileTechnique->True must occur in a Biosafety Cabinet:",False,True]
	];

	If[Length[sterileTransfersAreInBSCResult] > 0 && messages,
		Message[
			Error::SterileTransfersAreInBSC,
			ObjectToString[sterileTransfersAreInBSCResult[[All,1]], Cache->simulatedCache],
			sterileTransfersAreInBSCResult[[All,2]]
		]
	];
	(* Blend in source and destination to mapthread friendly option list of associations *)
	inputBlendedMapThreadFriendlyOptions = MapThread[
		Function[{source, dest, options},
			Append[options, {Source -> source, Destination -> dest}]
		],
		{mySources, myDestinations,mapThreadFriendlyResolvedOptions}
	];
	(* Error checking for if any flammable and ventilated sample is asked to be used inside a biosafety cabinet.  This cannot be done due to the concentrated hazard. *)
	{volatileHazardousSamplesInBSCError, volatileHazardousSamplesInBSCMessage} = If[MemberQ[
		Lookup[mapThreadFriendlyResolvedOptions, TransferEnvironment],
		ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]
	],
		(* call the helper to return a list of boolean and a string of error message *)
		checkVolatileHazardousSamplesInBSCs[
			inputBlendedMapThreadFriendlyOptions,
			{Cache},
			TransferEnvironment,
			simulatedCache
		],
		(* Otherwise, no BSC is involved, no error *)
		{False, Null}
	];
	volatileHazardousSamplesInBSCTest = If[TrueQ[volatileHazardousSamplesInBSCError],
		Test["All samples to use in a Biosafety Cabinet can be safely handled:", True, False],
		Test["All samples to use in a Biosafety Cabinet can be safely handled:", True, True]
	];

	If[TrueQ[volatileHazardousSamplesInBSCError] && messages,
		Message[
			Error::VolatileHazardousSamplesInBSC,
			volatileHazardousSamplesInBSCMessage
		]
	];

	(* Check that if SterileTechnique->True, the WorkCell is STAR. *)
	sterileTransfersAreInSTAR=MapThread[
		Function[{options, manipulationIndex},
			If[And[
				MatchQ[resolvedPreparation, Robotic],
				MemberQ[ToList@Lookup[options, SterileTechnique], True],
				MatchQ[resolvedWorkCell, STAR]
			],
				{Lookup[options, SterileTechnique], manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	sterileTransfersAreInSTARTest=If[Length[sterileTransfersAreInSTAR]==0,
		Test["All robotic transfers that have SterileTechnique->True must occur in a bioSTAR or microbioSTAR work cell:",True,True],
		Test["All robotic transfers that have SterileTechnique->True must occur in a bioSTAR or microbioSTAR work cell:",False,True]
	];

	If[Length[sterileTransfersAreInSTAR] > 0 && messages,
		Message[
			Error::ConflictingSterileTransferWithWorkCell,
			ObjectToString[sterileTransfersAreInSTAR[[All,1]], Cache->simulatedCache],
			sterileTransfersAreInSTAR[[All,2]]
		]
	];

	(* throw a message if the source is Sterile/AsepticHandling but the destination is not sterile/asepticHandling *)
	sterileSourceDestinationWarningSources = PickList[simulatedSources, asepticHandlingSourceDestinationWarnings];
	sterileSourceDestinationWarningDests = PickList[simulatedDestinations, asepticHandlingSourceDestinationWarnings];
	If[Not[MatchQ[$ECLApplication, Engine]] && MemberQ[asepticHandlingSourceDestinationWarnings, True] && messages,
		Message[
			Warning::ConflictingSourceAndDestinationAsepticHandling,
			ObjectToString[sterileSourceDestinationWarningSources, Cache -> simulatedCache],
			ObjectToString[sterileSourceDestinationWarningDests, Cache -> simulatedCache]
		]
	];
	sterileSourceDestinationWarningTests = If[MemberQ[asepticHandlingSourceDestinationWarnings, True],
		Warning["Sterile -> True or AsepticHandling -> True for the source sample(s) " <> ObjectToString[sterileSourceDestinationWarningSources, Cache -> simulatedCache] <> " but not for destination sample(s) " <> ObjectToString[sterileSourceDestinationWarningDests, Cache -> simulatedCache] <> ":", False, True],
		Warning["If Sterile -> True or AsepticHandling -> True for the source sample(s), either Sterile or AsepticHandling must be True for the destination sample(s):", True, True]
	];

	(* Check that if TransferEnvironment(BSC, GloveBox, Fumehood) has the same AsepticHandling and CultureHandling as Instrument(Pipette,Aspirator). *)
	compatibleTransfersEnvWithInstrumentResult = MapThread[
		Function[{options, manipulationIndex},
			If[
				(* no need to check if: *)
				Or[
					(* robotic, no TransferEnvironment needed *)
					MatchQ[resolvedPreparation, Robotic],
					(* no TransferEnvironment resolved *)
					MatchQ[Lookup[options, TransferEnvironment], Except[ObjectP[{Object[Instrument], Model[Instrument]}]]],
					(* no Instrument resolved *)
					MatchQ[Lookup[options, Instrument], Null | ObjectP[{Object[Container], Model[Container]}]]
				],
				Nothing,
				Module[{equivalentTransferEnvironments, transferEnvironmentModelPackets, instrument, instrumentModelPacket},
					{equivalentTransferEnvironments, instrument} = Lookup[options, {EquivalentTransferEnvironments, Instrument}];

					transferEnvironmentModelPackets = Map[
						If[MatchQ[#, ObjectP[Object]],
							fastAssocPacketLookup[fastAssoc, #, Model],
							fetchPacketFromFastAssoc[#, fastAssoc]
						]&,
						equivalentTransferEnvironments
					];
					instrumentModelPacket = If[MatchQ[instrument, ObjectP[Object]],
						fastAssocPacketLookup[fastAssoc, instrument, Model],
						fetchPacketFromFastAssoc[instrument, fastAssoc]
					];
					If[
						And[
							MatchQ[Lookup[transferEnvironmentModelPackets, AsepticHandling, Null] /. False -> Null, {(Lookup[instrumentModelPacket, AsepticHandling, Null] /. False -> Null)..}],
							MatchQ[Lookup[transferEnvironmentModelPackets, CultureHandling, Null], {Lookup[instrumentModelPacket, CultureHandling, Null]..}]
						],
						Nothing,
						{instrument, Lookup[options, TransferEnvironment], manipulationIndex}
					]
				]
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	compatibleTransfersEnvWithInstrumentTest = If[Length[compatibleTransfersEnvWithInstrumentResult] == 0,
		Test["All manual transfers that have compatible TransferEnvironment and Instrument:", True, True],
		Test["All manual transfers that have compatible TransferEnvironment and Instrument:", False, True]
	];

	If[Length[compatibleTransfersEnvWithInstrumentResult] > 0 && messages,
		Message[
			Error::TransferEnvironmentInstrumentCombination,
			ObjectToString[compatibleTransfersEnvWithInstrumentResult[[All, 1]], Cache -> simulatedCache],
			ObjectToString[compatibleTransfersEnvWithInstrumentResult[[All, 2]], Cache -> simulatedCache],
			compatibleTransfersEnvWithInstrumentResult[[All, 3]]
		]
	];

	(* Check that if Destination->Waste or Instrument->Aspirator, then SterileTechnique->True *)
	aspiratorsRequireSterileTransferResult=MapThread[
		Function[{options, destination, manipulationIndex},
			If[And[
				!MatchQ[resolvedPreparation, Robotic],
				Or[
					MatchQ[destination, Waste] && MatchQ[Lookup[options, SterileTechnique], False],
					MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Aspirator], Object[Instrument, Aspirator]}]] && MatchQ[Lookup[options, SterileTechnique], False]
				]
			],
				manipulationIndex,
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions,  myDestinations, Range[Length[myAmounts]]}
	];

	aspiratorsRequireSterileTransferTest=If[Length[aspiratorsRequireSterileTransferResult]==0,
		Test["All transfers using an aspirator must have SterileTechnique->True:",True,True],
		Test["All transfers using an aspirator must have SterileTechnique->True:",False,True]
	];

	If[Length[aspiratorsRequireSterileTransferResult] > 0 && messages,
		Message[
			Error::AspiratorRequiresSterileTransfer,
			aspiratorsRequireSterileTransferResult
		]
	];

	(* make sure the backfill gas is consistent with what can be achieved by the transfer environment *)
	backfillGasResult = MapThread[
		Function[{options, manipulationIndex},
			If[
				Or[
					!MatchQ[fastAssocLookup[fastAssoc, #, ArgonHermeticTransfer]& /@ Lookup[options, HandlingCondition], {True..}] && MatchQ[Lookup[options, BackfillGas], Argon],
					!MatchQ[fastAssocLookup[fastAssoc, #, NitrogenHermeticTransfer]& /@ Lookup[options, HandlingCondition], {True..}] && MatchQ[Lookup[options, BackfillGas], Nitrogen]
				],
				{Download[Lookup[options, TransferEnvironment], Object], Lookup[options, BackfillGas], manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	backfillGasTest=If[Length[backfillGasResult]==0,
		Test["All transfers that specify the need for BackfillGas either occur in a Biosafety Cabinet (for non-Argon transfers) or in a FumeHood:",True,True],
		Test["All transfers that specify the need for BackfillGas either occur in a Biosafety Cabinet (for non-Argon transfers) or in a FumeHood:",False,True]
	];

	If[Length[backfillGasResult] > 0 && messages,
		Message[
			Error::InvalidBackfillGas,
			ObjectToString[backfillGasResult[[All,1]], Cache->simulatedCache],
			backfillGasResult[[All,2]],
			backfillGasResult[[All,3]]
		]
	];

	(* Check TransferEnvironment and Balance availability. *)
	(* NOTE: Any additional resources that are expected to already be in the transfer environment must be added to this *)
	(* check as we add more features to ExperimentTransfer. *)
	(* NOTE: This should be done by the resource system with the installed resources subsystem in the future. *)

	invalidTransferEnvironmentBalanceResult=MapThread[
		Function[{options, manipulationIndex},
			(* If we don't have a balance, then we don't have to worry at all. *)
			If[MatchQ[Lookup[options, Balance], Null],
				Nothing,
				Module[{equivalentTransferEnvironments, handlingStationsWithResolvedBalance},
					(* this is all the handling station that we might use *)
					equivalentTransferEnvironments = Lookup[options, EquivalentTransferEnvironments];

					(* if we are manual and transfer environment is null, okay to not throw this message, we will throw Error::NoTransferEnvironmentAvailable later *)
					If[MatchQ[equivalentTransferEnvironments, {}] && MatchQ[Lookup[options, Preparation], Manual], Return[Nothing, Module]];

					(* this includes both handling station objects and models associated with the resovled balance *)
					handlingStationsWithResolvedBalance = Flatten[Values[Lookup[balanceHandlingStationLookup["Memoization"], Download[Lookup[options, Balance], Object], <||>]]];

					(* If we can't fulfill the request based on the balances that we have in our transfer environments, let the user know. *)
					If[
						!SubsetQ[handlingStationsWithResolvedBalance, equivalentTransferEnvironments],
						{
							Lookup[options, Balance],
							Lookup[options, TransferEnvironment],
							handlingStationsWithResolvedBalance,
							manipulationIndex
						},
						Nothing
					]
				]
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	invalidTransferEnvironmentBalanceTest=If[Length[invalidTransferEnvironmentBalanceResult]==0,
		Test["The requested balances exist in the requested TransferEnvironments (ex. there is an Analytical Balance in the Biosafety Cabinet):",True,True],
		Test["The requested balances exist in the requested TransferEnvironments (ex. there is an Analytical Balance in the Biosafety Cabinet):",False,True]
	];

	If[Length[invalidTransferEnvironmentBalanceResult] > 0 && messages,
		Message[
			Error::TransferEnvironmentBalanceCombination,
			ObjectToString[invalidTransferEnvironmentBalanceResult[[All,1]], Cache->simulatedCache],
			ObjectToString[invalidTransferEnvironmentBalanceResult[[All,2]], Cache->simulatedCache],
			ObjectToString[invalidTransferEnvironmentBalanceResult[[All,3]], Cache->simulatedCache],
			invalidTransferEnvironmentBalanceResult[[All,4]]
		]
	];

	(* Check for Aspiratable->False or Dispensable->False containers. *)
	(* NOTE: We don't change these fields in the working container model packets, so it's fine to check these fields outside of the big MapThread. *)
	aspiratableOrDispensableFalseResult=MapThread[
		Function[{sourceContainerPacket, sourceContainerModelPacket, destinationContainerPacket, destinationContainerModelPacket, manipulationIndex},
			Sequence@@{
				If[MatchQ[Lookup[sourceContainerModelPacket, Aspiratable], False],
					{Source, sourceContainerPacket, manipulationIndex},
					Nothing
				],
				If[MatchQ[Lookup[sourceContainerModelPacket, Dispensable], False],
					{Destination, destinationContainerPacket, manipulationIndex},
					Nothing
				]
			}
		],
		{workingSourceContainerPackets, workingSourceContainerModelPackets, workingDestinationContainerPackets, workingDestinationContainerModelPackets, Range[Length[myAmounts]]}
	];

	aspiratableOrDispensableFalseTest=If[Length[aspiratableOrDispensableFalseResult]==0,
		Test["All source container models are not Aspiratable->False and all destination container models are not Dispensable->False:",True,True],
		Test["All source container models are not Aspiratable->False and all destination container models are not Dispensable->False:",False,True]
	];

	If[Length[aspiratableOrDispensableFalseResult] > 0 && messages,
		Message[
			Error::AspiratableOrDispensableFalse,
			Cases[aspiratableOrDispensableFalseResult, {Source, _, _}][[All,3]],
			Cases[aspiratableOrDispensableFalseResult, {Destination, _, _}][[All,3]]
		]
	];

	(* We cannot do hot/cold transfers in the glove box. Check for this. *)
	invalidTransferTemperatureResult=MapThread[
		Function[{options, manipulationIndex},
			If[MatchQ[Lookup[options, TransferEnvironment], ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]] && (MatchQ[Lookup[options, SourceTemperature], Except[AmbientTemperatureP]] || MatchQ[Lookup[options, DestinationTemperature], Except[AmbientTemperatureP]]),
				{Download[Lookup[options, TransferEnvironment], Object], manipulationIndex},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[myAmounts]]}
	];

	transferTemperatureTest=If[Length[invalidTransferTemperatureResult]==0,
		Test["All transfers that occur in the glove box do not have a non-Ambient/25 Celsius SourceTemperature or DestinationTemperature specified since hot/cold transfers cannot be performed in the glove box:",True,True],
		Test["All transfers that occur in the glove box do not have a non-Ambient/25 Celsius SourceTemperature or DestinationTemperature specified since hot/cold transfers cannot be performed in the glove box:",False,True]
	];

	If[Length[invalidTransferTemperatureResult] > 0 && messages,
		Message[
			Error::InvalidTransferTemperatureGloveBox,
			ObjectToString[invalidTransferTemperatureResult[[All,1]], Cache->simulatedCache],
			invalidTransferTemperatureResult[[All,2]]
		]
	];

	(* Check that the user didn't give us a bogus DestinationWell option value. *)
	invalidWellResult=MapThread[
		Function[{destinationContainerPacket, suppliedDestinationWells},
			Module[{allPositions},
				allPositions=Lookup[
					fastAssocLookup[fastAssoc, Lookup[destinationContainerPacket, Model], Positions]/.{$Failed|{}->{<|Name->"A1"|>}},
					Name
				];

				If[!MatchQ[allPositions, Null] && !MemberQ[allPositions, suppliedDestinationWells],
					{Lookup[destinationContainerPacket, Object], suppliedDestinationWells},
					Nothing
				]
			]
		],
		{workingDestinationContainerPackets, Lookup[resolvedOptions, DestinationWell]}
	];

	invalidWellTest=If[Length[invalidWellResult]==0,
		Test["All Wells that are specified exist in the destination container given:",True,True],
		Test["All Wells that are specified exist in the destination container given:",False,True]
	];

	If[Length[invalidWellResult] > 0 && messages,
		Message[
			Error::InvalidTransferWellSpecification,
			ObjectToString[invalidWellResult[[All,1]], Cache->simulatedCache],
			ObjectToString[invalidWellResult[[All,2]], Cache->simulatedCache]
		]
	];

	(* Check that if an instrument was specified, any required accessories are also specified. *)
	requiredOrCantBeSpecifiedResult=MapThread[
		Function[{options, amount, manipulationIndex,destinationContainerModelPacket},
			Module[{requiredOptions,quantitativeTransferOptions,hermeticOptions,tipOptions,cantBeSpecifiedOptions,
				requiredErrors,cantBeSpecifiedErrors},

				(* Get any missing options. *)
				requiredOptions=Flatten@{
					(* FTV to VolumetricFlask does not require any option based on instrument *)
					If[(volumetricFlaskFTVQ),
						{},
						(* required options based on instrument *)
						Switch[Lookup[options, Instrument],
							ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
							{Needle},
							ObjectP[{Model[Container,GraduatedCylinder], Object[Container,GraduatedCylinder]}],
							{},
							ObjectP[{Model[Instrument,Pipette], Object[Instrument,Pipette]}],
							{Tips},
							ObjectP[{Model[Item, Spatula], Object[Item, Spatula]}],
							{Balance},
							ObjectP[{Model[Instrument,Aspirator], Object[Instrument,Aspirator]}],
							{Tips},
							_,
							Nothing
						]
					],
					Switch[amount,
						MassP,
							{Balance},
						_,
							{}
					],
					If[MatchQ[Lookup[options, Tips], ObjectP[{Object[Item,Tips],Model[Item,Tips]}]],
						(* NOTE: Do not need an instrument if called from the work cell function bc our instrument is the hamilton. *)
						If[MatchQ[resolvedPreparation, Robotic],
							{TipType, TipMaterial},
							{TipType, TipMaterial, Instrument}
						],
						{}
					],
					If[MatchQ[Lookup[options, Needle], ObjectP[]],
						{Instrument},
						{}
					]
				};

				(* Define common option sets. *)
				quantitativeTransferOptions={QuantitativeTransfer, QuantitativeTransferWashSolution, QuantitativeTransferWashInstrument, QuantitativeTransferWashVolume, NumberOfQuantitativeTransferWashes};
				hermeticOptions={BackfillNeedle, BackfillGas, VentingNeedle}; (* Leave out the unseal options since that can make something non-hermetic. *)
				tipOptions={Tips, TipType, TipMaterial, ReversePipetting, TipRinse, TipRinseSolution, TipRinseVolume, NumberOfTipRinses};

				(* Get any options that shouldn't have been specified. *)
				cantBeSpecifiedOptions=Flatten@Switch[{Lookup[options, Instrument],Lookup[destinationContainerModelPacket, Object],Lookup[options, Tips]},
					{ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],_,_},
						{tipOptions},
					(* Allow Tips, TipMaterial and TipType specified when Instrument is a graduated cylinder and we are pouring into a VolumetricFlask so we can use a consumable pipette dropper *)
					{ObjectP[{Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}]|Null,ObjectP[Model[Container,Vessel,VolumetricFlask]],ObjectP[{Model[Item, Consumable],Object[Item,Consumable]}]},
						{hermeticOptions, DeleteCases[tipOptions,Tips|TipMaterial|TipType|TipRinse]},
					{ObjectP[{Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}],_,_},
						{hermeticOptions, tipOptions},
					{ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}],_,_},
						{hermeticOptions},
					{ObjectP[{Model[Item, Spatula], Object[Item, Spatula]}],_,_},
						{tipOptions},
					{_,_,_},
						{}
				];

				(* If there are any options set incorrectly, return them. *)
				requiredErrors=Cases[Transpose[{requiredOptions, Lookup[options, #]&/@requiredOptions}], {_, Null}];
				cantBeSpecifiedErrors=Cases[Transpose[{cantBeSpecifiedOptions, Lookup[options, #]&/@cantBeSpecifiedOptions}], {_, Except[Null]}];

				If[Length[requiredErrors] > 0 || Length[cantBeSpecifiedErrors] > 0,
					{
						Lookup[options, Instrument],
						amount,
						requiredErrors[[All,1]],
						requiredErrors[[All,2]],
						cantBeSpecifiedErrors[[All,1]],
						cantBeSpecifiedErrors[[All,2]],
						manipulationIndex
					},
					Nothing
				]
			]
		],
		{mapThreadFriendlyResolvedOptions, myAmounts, Range[Length[simulatedSources]],workingDestinationContainerModelPackets}
	];

	incorrectlySpecifiedTransferOptionsTest=If[Length[requiredOrCantBeSpecifiedResult]==0,
		Test["Based on the instruments that have been resolved to perform the transfers and amounts being transferred, all required accessories (needles, tips, balances, etc.) are given:", True, True],
		Test["Based on the instruments that have been resolved to perform the transfers and amounts being transferred, all required accessories (needles, tips, balances, etc.) are given:", False, True]
	];

	If[Length[requiredOrCantBeSpecifiedResult]>0 && messages,
		Message[
			Error::IncorrectlySpecifiedTransferOptions,
			ObjectToString[requiredOrCantBeSpecifiedResult[[All,1]], Cache->simulatedCache],
			requiredOrCantBeSpecifiedResult[[All,2]],
			requiredOrCantBeSpecifiedResult[[All,3]],
			requiredOrCantBeSpecifiedResult[[All,4]],
			requiredOrCantBeSpecifiedResult[[All,5]],
			requiredOrCantBeSpecifiedResult[[All,6]],
			requiredOrCantBeSpecifiedResult[[All,7]]
		]
	];

	(* If the Tips specified is Model[Item,Consumable], make sure they are only for FTV transfers using VolumetricFlask destination container. *)
	incompatibleTipItemConsumableResult=DeleteCases[MapThread[
		Function[{options,tips,instrument, destinationContainerModelPacket},
			Which[
				MatchQ[tips,ObjectP[{Model[Item,Consumable],Object[Item,Consumable]}]]&&MatchQ[Lookup[options,FillToVolume],True]&&MatchQ[destinationContainerModelPacket,ObjectP[Model[Container,Vessel,Volumetric,Flask]]],
				{},

				MatchQ[tips,ObjectP[{Model[Item,Consumable],Object[Item,Consumable]}]]&&MatchQ[instrument,ObjectP[{Model[Container,GraduatedCylinder],Object[Container,GraduatedCylinder]}]|Null]&&MatchQ[destinationContainerModelPacket,ObjectP[Model[Container,Vessel,VolumetricFlask]]],
				{},

				MatchQ[tips,ObjectP[{Model[Item,Consumable],Object[Item,Consumable]}]],
				{
					Lookup[options,Tips],
					Tips
				},

				True,
				{}
			]
		],
		{mapThreadFriendlyOptions,resolvedTips, resolvedInstrument,workingDestinationContainerModelPackets}
	],{}];

	incompatibleTipItemConsumableTest=If[Length[incompatibleTipItemConsumableResult]==0,
		Test["Based on the instruments that have been resolved to perform the transfers and destination container, resolved Tips are compatible:", True, True],
		Test["Based on the instruments that have been resolved to perform the transfers and destination container, resolved Tips are compatible:", False, True]
	];

	If[Length[incompatibleTipItemConsumableResult]>0 && messages,
		Message[
			Error::IncompatibleTipItemConsumable,
			ObjectToString[incompatibleTipItemConsumableResult[[All,1]], Cache->simulatedCache],
			incompatibleTipItemConsumableResult[[All,2]]
		]
	];

	(* Check that Tolerance cannot be specified if Amount->All. *)
	invalidTolerancesResult=MapThread[
		Function[{options, amount, manipulationIndex},
			If[MatchQ[Lookup[options, Tolerance], Except[Null]] && MatchQ[amount, All],
				{
					Lookup[options, Tolerance],
					manipulationIndex
				},
				Nothing
			]
		],
		{mapThreadFriendlyResolvedOptions, myAmounts, Range[Length[simulatedSources]]}
	];

	invalidToleranceTest=If[Length[invalidTolerancesResult]==0,
		Test["If the amount to be transferred is All, the Tolerance option is not specified:", True, True],
		Test["If the amount to be transferred is All, the Tolerance option is not specified:", False, True]
	];

	If[Length[invalidTolerancesResult]>0 && messages,
		Message[
			Error::ToleranceSpecifiedForAllTransfer,
			invalidTolerancesResult[[All,1]],
			invalidTolerancesResult[[All,2]]
		]
	];

	(* Check that the user didn't give us a bad instrument that can't hold the volume required of the transfer. *)
	If[Length[instrumentCapacityErrors]>0 && messages,
		Message[
			Error::InvalidInstrumentCapacity,
			instrumentCapacityErrors[[All,1]],
			ObjectToString[instrumentCapacityErrors[[All,2]], Cache->simulatedCache],
			instrumentCapacityErrors[[All,3]],
			instrumentCapacityErrors[[All,4]]
		]
	];

	instrumentCapacityTest=If[Length[instrumentCapacityErrors] == 0,
		Test["All specified instruments/balances/tips can hold the amount that is being requested to be transferred:", True, True],
		Test["All specified instruments/balances/tips can hold the amount that is being requested to be transferred:", False, True]
	];

	(* Check that the user didn't give us tips/needles that can't reach the bottom of the container. *)
	If[Length[liquidLevelErrors] > 0 && !MatchQ[resolvedPreparation, Robotic] && messages,
		Message[
			Error::TipsOrNeedleLiquidLevel,
			liquidLevelErrors[[All,1]],
			ObjectToString[liquidLevelErrors[[All,2]], Cache->simulatedCache],
			liquidLevelErrors[[All,3]]
		]
	];

	liquidLevelTest=If[(Length[liquidLevelErrors] == 0)||MatchQ[resolvedPreparation, Robotic],
		Test["All of the specified tips/needles can reach the bottom of the source's container:", True, True],
		Test["All of the specified tips/needles can reach the bottom of the source's container:", False, True]
	];

	(* Check that the user didn't give us any gaseous samples. *)
	If[Length[gaseousSampleErrors] > 0 && messages,
		Message[
			Error::GaseousSample,
			ObjectToString[gaseousSampleErrors[[All,1]], Cache->simulatedCache],
			gaseousSampleErrors[[All,2]]
		]
	];

	gaseousSampleTest=If[Length[gaseousSampleErrors] == 0,
		Test["None of the source samples that are specified to be transferred have State->Gas:", True, True],
		Test["None of the source samples that are specified to be transferred have State->Gas:", False, True]
	];

	(* Check that the user didn't give an incompatible WeighingContainer for QuantitativeTransfer. *)
	If[Length[incompatibleQuantitativeTransferWeighingContainerErrors] > 0 && messages,
		Message[
			Error::IncompatibleQuantitativeTransferWeighingContainer,
			incompatibleQuantitativeTransferWeighingContainerErrors[[All,1]],
			ObjectToString[incompatibleQuantitativeTransferWeighingContainerErrors[[All,2]], Cache->simulatedCache],
			incompatibleQuantitativeTransferWeighingContainerErrors[[All,3]]
		]
	];

	incompatibleQuantitativeTransferWeighingContainerTest=If[Length[incompatibleQuantitativeTransferWeighingContainerErrors] == 0,
		Test["The weighing containers specified for transfers with QuantitativeTransfer True is valid", True, True],
		Test["The weighing containers specified for transfers with QuantitativeTransfer True is valid", False, True]
	];

	(* Check that a compatible WeighingContainer was found. *)
	If[Length[noCompatibleWeighingContainerErrors] > 0 && messages,
		Message[
			Error::NoCompatibleWeighingContainer,
			noCompatibleWeighingContainerErrors[[All,1]], (* manipulation index *)
			noCompatibleWeighingContainerErrors[[All,2]] (* weighboat and/or weighing funnel *)
		]
	];

	noCompatibleWeighingContainerTest=If[Length[noCompatibleWeighingContainerErrors] == 0,
		Test["If required, WeighingContainer is properly populated.", True, True],
		Test["If required, WeighingContainer is properly populated.", False, True]
	];

	(* Check that the specified WeighingContainer is compatible with Destination and QuantitativeTransfer options. *)
	If[Length[incompatibleWeighingContainerErrors] > 0 && messages,
		Message[
			Error::IncompatibleWeighingContainer,
			ObjectToString[incompatibleWeighingContainerErrors[[All,1]], Cache->simulatedCache],
			incompatibleWeighingContainerErrors[[All,2]]
		]
	];

	incompatibleWeighingContainerTest=If[Length[incompatibleWeighingContainerErrors] == 0,
		Test["The WeighingContainer for transfers with QuantitativeTransfer options and Destination is valid", True, True],
		Test["The WeighingContainer for transfers with QuantitativeTransfer options and Destination is valid", False, True]
	];

	(* Check that a compatible Funnel was found for QuantitativeTransfer that does not use a weighing funnel. *)
	If[Length[noCompatibleFunnelErrors] > 0 && messages,
		Message[
			Error::NoCompatibleFunnel,
			ObjectToString[noCompatibleFunnelErrors[[All,1]], Cache->simulatedCache],
			noCompatibleFunnelErrors[[All,2]]
		]
	];

	noCompatibleFunnelTest=If[Length[noCompatibleFunnelErrors] == 0,
		Test["The Funnel for transfers with QuantitativeTransfer True is valid", True, True],
		Test["The Funnel for transfers with QuantitativeTransfer True is valid", False, True]
	];

	(* Check that the user didn't give an incompatible QuantitativeTransferWashTips for QuantitativeTransfer. *)
	If[Length[incompatibleQuantitativeTransferWashTipsErrors] > 0 && messages,
		Message[
			Error::IncompatibleQuantitativeTransferWashTips,
			ObjectToString[incompatibleQuantitativeTransferWashTipsErrors[[All,1]], Cache->simulatedCache],
			incompatibleQuantitativeTransferWashTipsErrors[[All,2]],
			incompatibleQuantitativeTransferWashTipsErrors[[All,3]]
		]
	];

	incompatibleQuantitativeTransferWashTipsTest=If[Length[incompatibleQuantitativeTransferWashTipsErrors] == 0,
		Test["The wash tips specified for transfers with QuantitativeTransfer True is valid", True, True],
		Test["The wash tips specified for transfers with QuantitativeTransfer True is valid", False, True]
	];

	(* Check that the user didn't give an incompatible QuantitativeTransferWashInstrument for QuantitativeTransfer. *)
	If[Length[incompatibleQuantitativeTransferWashInstrumentErrors] > 0 && messages,
		Message[
			Error::IncompatibleQuantitativeTransferWashInstrument,
			ObjectToString[incompatibleQuantitativeTransferWashInstrumentErrors[[All,1]], Cache->simulatedCache],
			incompatibleQuantitativeTransferWashInstrumentErrors[[All,2]],
			ObjectToString[incompatibleQuantitativeTransferWashInstrumentErrors[[All,3]], Cache->simulatedCache]
		]
	];

	incompatibleQuantitativeTransferWashInstrumentTest=If[Length[incompatibleQuantitativeTransferWashInstrumentErrors] == 0,
		Test["The wash instrument specified for transfers with QuantitativeTransfer True is valid", True, True],
		Test["The wash instrument specified for transfers with QuantitativeTransfer True is valid", False, True]
	];

	(* Check that the user didn't destination container(s) that are incompatible with source. *)
	If[Length[incompatibleDestinationContainerErrors] > 0 && messages,
		Message[
			Error::IncompatibleTransferDestinationContainer,
			ObjectToString[incompatibleDestinationContainerErrors[[All,1]], Cache->simulatedCache],
			incompatibleDestinationContainerErrors[[All,2]],
			ObjectToString[incompatibleDestinationContainerErrors[[All,3]], Cache->simulatedCache],
			incompatibleDestinationContainerErrors[[All,4]]
		]
	];

	incompatibleDestinationContainerTest=If[Length[incompatibleDestinationContainerErrors] == 0,
		Test["None of the destination containers are incompatible with the source samples that are specified to be transferred", True, True],
		Test["None of the destination containers are incompatible with the source samples that are specified to be transferred", False, True]
	];

	(* Check that the user didn't give an incompatible IntermediateContainer when in FTV of a Volumetric Flask. *)
	If[Length[incompatibleFTVIntermediateContainerErrors] > 0 && messages,
		Message[
			Error::IncompatibleFTVTransferIntermediateContainer,
			ObjectToString[incompatibleFTVIntermediateContainerErrors[[All,1]], Cache->simulatedCache],
			incompatibleFTVIntermediateContainerErrors[[All,2]],
			ObjectToString[incompatibleFTVIntermediateContainerErrors[[All,3]], Cache->simulatedCache],
			ObjectToString[incompatibleFTVIntermediateContainerErrors[[All,4]], Cache->simulatedCache]
		]
	];

	incompatibleFTVIntermediateContainerTest=If[Length[incompatibleFTVIntermediateContainerErrors] == 0,
		Test["The intermediate containers specified for transfers involving FillToVolume of a VolumetricFlask are valid", True, True],
		Test["The intermediate containers specified for transfers involving FillToVolume of a VolumetricFlask are valid", False, True]
	];

	(* Check that the user didn't give an incompatible IntermediateDecant when in FTV of a Volumetric Flask. *)
	If[Length[incompatibleFTVIntermediateDecantErrors] > 0 && messages,
		Message[
			Error::IncompatibleFTVTransferIntermediateDecant,
			incompatibleFTVIntermediateDecantErrors[[All,1]],
			incompatibleFTVIntermediateDecantErrors[[All,2]],
			ObjectToString[incompatibleFTVIntermediateDecantErrors[[All,3]], Cache->simulatedCache]
		]
	];

	(* Check that the user didn't give an incompatible Instrument when in FTV of a Volumetric Flask. *)
	If[Length[incompatibleFTVInstrumentErrors] > 0 && messages,
		Message[
			Error::IncompatibleFTVTransferInstrument,
			incompatibleFTVInstrumentErrors[[All,1]],
			incompatibleFTVInstrumentErrors[[All,2]],
			ObjectToString[incompatibleFTVInstrumentErrors[[All,3]], Cache->simulatedCache]
		]
	];
	
	(* Check that the user didn't give an incompatible Funnel when in FTV of a Volumetric Flask. *)
	If[Length[incompatibleFTVFunnelErrors] > 0 && messages,
		Message[
			Error::IncompatibleFTVTransferFunnel,
			incompatibleFTVFunnelErrors[[All,1]],
			incompatibleFTVFunnelErrors[[All,2]],
			ObjectToString[incompatibleFTVFunnelErrors[[All,3]], Cache->simulatedCache]
			
		]
	];
	
	(* Check that the user didn't give an incompatible NumberOfQuantitativeTransferWashes, this should be equal or greater than 2. *)
	If[Length[invalidNumberOfQuantitativeTransferWashesError] > 0 && messages,
		Message[
			Error::InvalidNumberOfQuantitativeTransferWashes,
			invalidNumberOfQuantitativeTransferWashesError[[All,1]],
			invalidNumberOfQuantitativeTransferWashesError[[All,2]]
		]
	];

	incompatibleFTVIntermediateDecantTest=If[Length[incompatibleFTVIntermediateContainerErrors] == 0,
		Test["The IntermediateDecant option specified for transfers involving FillToVolume of a VolumetricFlask are valid", True, True],
		Test["The IntermediateDecant option specified for transfers involving FillToVolume of a VolumetricFlask are valid", False, True]
	];

	(* Check that the user didn't destination container(s) that are incompatible with source. *)
	If[Length[incompatibleIntermediateContainerErrors] > 0 && messages,
		Message[
			Error::IncompatibleTransferIntermediateContainer,
			ObjectToString[incompatibleIntermediateContainerErrors[[All,1]], Cache->simulatedCache],
			incompatibleIntermediateContainerErrors[[All,2]],
			ObjectToString[incompatibleIntermediateContainerErrors[[All,3]], Cache->simulatedCache],
			incompatibleIntermediateContainerErrors[[All,4]]
		]
	];

	incompatibleIntermediateContainerTest=If[Length[incompatibleIntermediateContainerErrors] == 0,
		Test["None of the intermediate containers are incompatible with the source samples that are specified to be transferred", True, True],
		Test["None of the intermediate containers are incompatible with the source samples that are specified to be transferred", False, True]
	];

	(* check if we are trying to recoup intermediate container liquid back to a public sample or model sample, which is not allowed *)
	If[Length[recoupContaminationErrors] > 0 && messages,
		Message[
			Error::RecoupContamination,
			ObjectToString[recoupContaminationErrors[[All, 1]], Cache -> simulatedCache],
			recoupContaminationErrors[[All, 2]]
		]
	];

	recoupContaminationTest = If[Length[recoupContaminationErrors] == 0,
		Test["We are not recouping residual sample in IntermediateContainer back to a public or model sample:", True, True],
		Test["We are not recouping residual sample in IntermediateContainer back to a public or model sample:", False, True]
	];

	(* Check that the user did not give us a spatula that cannot fit inside the destination aperture *)
	If[Length[incompatibleSpatulaWidthErrors] > 0 && messages,
		Message[
			Error::IncompatibleSpatulaWidth,
			ObjectToString[incompatibleSpatulaWidthErrors[[All,1]], Cache -> simulatedCache],
			incompatibleSpatulaWidthErrors[[All, 2]],
			incompatibleSpatulaWidthErrors[[All, 3]]
		]
	];

	(* Check that the user didn't give us a mass for an itemized sample. *)
	If[Length[pillCrusherWarnings] > 0 && warnings,
		Message[
			Warning::TabletCrusherRequired,
			pillCrusherWarnings[[All,1]],
			pillCrusherWarnings[[All,2]]
		]
	];

	(* sachet mass specified checks. *)
	sachetMassTest=If[Length[sachetMassWarnings]==0,
		Warning["There are no amount specified as mass for transferring from sachet samples:", True, True],
		Warning["There are no amount specified as mass for transferring from sachet samples:", False, True]
	];

	If[Length[sachetMassWarnings]>0 && warnings,
		Message[
			Warning::SachetMassSpecified,
			ObjectToString[sachetMassWarnings[[All,1]], Cache->simulatedCache],
			sachetMassWarnings[[All,2]]
		]
	];

	(* sachet mass specified checks. *)
	spatulaCapacityTest=If[Length[spatulaCapacityWarnings]==0,
		Warning["The capacity of the spatula selected is either too big or too small for the mass desired to be transferred:", True, True],
		Warning["The capacity of the spatula selected is either too big or too small for the mass desired to be transferred:", False, True]
	];

	If[Length[spatulaCapacityWarnings]>0 && warnings,
		Message[
			Warning::SpatulaCapacityWarning,
			ObjectToString[spatulaCapacityWarnings[[All,1]], Cache->simulatedCache],
			spatulaCapacityWarnings[[All,2]],
			spatulaCapacityWarnings[[All,3]]
		]
	];

	(* Check that the user didn't tell us to transfer a solid sample by volume. *)
	If[Length[solidSampleVolumeErrors] > 0 && messages,
		Message[
			Error::TransferSolidSampleByVolume,
			ObjectToString[solidSampleVolumeErrors[[All,1]], Cache->simulatedCache],
			solidSampleVolumeErrors[[All,2]]
		]
	];

	solidSampleVolumeTest=If[Length[solidSampleVolumeErrors] == 0,
		Test["All solid samples are specified to be transferred by mass:", True, True],
		Test["All solid samples are specified to be transferred by mass:", False, True]
	];

	(* Warn the user if they're transferring non-anhydrous samples in the glove box. *)
	If[Length[anhydrousGloveBoxWarnings] > 0 && warnings,
		Message[
			Warning::NonAnhydrousSample,
			ObjectToString[anhydrousGloveBoxWarnings[[All,1]], Cache->simulatedCache],
			anhydrousGloveBoxWarnings[[All,2]]
		]
	];

	(* Warn the user if they're transferring non-anhydrous samples in the glove box. *)
	If[Length[aqueousGloveBoxErrors] > 0 && messages,
		Message[
			Error::AqueousGloveBoxSamples,
			ObjectToString[aqueousGloveBoxErrors[[All,1]], Cache->simulatedCache],
			aqueousGloveBoxErrors[[All,2]]
		]
	];

	aqueousGloveBoxTest=If[Length[aqueousGloveBoxErrors] == 0,
		Test["Aqueous samples are not manipulated in the glove box:", True, True],
		Test["Aqueous samples are not manipulated in the glove box:", False, True]
	];

	(* Check that the user didn't give us WeighingContainer->Null with a non-empty destination container. *)
	If[Length[weighingContainerErrors] > 0 && messages,
		Message[
			Error::RequiredWeighingContainerNonEmptyDestination,
			ObjectToString[weighingContainerErrors[[All,1]], Cache->simulatedCache],
			weighingContainerErrors[[All,2]]
		]
	];

	weighingContainerTest=If[Length[weighingContainerErrors] == 0,
		Test["A weighing container is given to first weigh out the requested sample amount if the destination container is not going to be empty at the time of the transfer and the transfered amount requested is not All:", True, True],
		Test["A weighing container is given to first weigh out the requested sample amount if the destination container is not going to be empty at the time of the transfer and the transfered amount requested is not All:", False, True]
	];

	(* Check that the user didn't give us BalanceCleaningMethod->Null with a Balance. *)
	If[Length[balanceCleaningMethodRequiredErrors] > 0 && messages,
		Message[
			Error::BalanceCleaningMethodRequired,
			ObjectToString[balanceCleaningMethodRequiredErrors[[All,1]], Cache->simulatedCache],
			ObjectToString[balanceCleaningMethodRequiredErrors[[All,2]], Cache->simulatedCache],
			balanceCleaningMethodRequiredErrors[[All,3]]
		]
	];

	balanceCleaningMethodRequiredTest=If[Length[balanceCleaningMethodRequiredErrors] == 0,
		Test["A BalanceCleaningMethod is given if Balance is needed:", True, True],
		Test["A BalanceCleaningMethod is given if Balance is needed:", False, True]
	];

	(* Check that the QuantitativeTransfer options are compatible. *)
	invalidQuantitativeTransferOptions=Map[
		Function[{options},
			Module[{quantitativeTransferOptions,specifiedOptions,notSpecifiedOptions,notSpecifiedOptionsWithWeighingContainer},
				quantitativeTransferOptions={
					QuantitativeTransfer,
					QuantitativeTransferWashSolution,
					QuantitativeTransferWashVolume,
					QuantitativeTransferWashInstrument,
					QuantitativeTransferWashTips,
					NumberOfQuantitativeTransferWashes
				};

				specifiedOptions=(
					If[MatchQ[Lookup[options, #], Except[Null|False]],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@quantitativeTransferOptions;

				notSpecifiedOptions=(
					If[MatchQ[Lookup[options, #], Null|False],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@quantitativeTransferOptions;
				(*
				(* WeighingContainer only can cause an error if it is NOT specified AND there are other specified options. *)
				notSpecifiedOptionsWithWeighingContainer=If[
					And[
						MatchQ[Lookup[options, WeighingContainer], Null],
						Length[specifiedOptions]>0
					],
					Append[notSpecifiedOptions, {WeighingContainer, Null}],
					notSpecifiedOptions
				];
				*)

				Which[
					MatchQ[resolvedPreparation, Manual] && Length[specifiedOptions] > 0 && Length[notSpecifiedOptions] > 0,
						{specifiedOptions[[All,1]], specifiedOptions[[All,2]], notSpecifiedOptions[[All,1]], notSpecifiedOptions[[All,2]]},
					MatchQ[resolvedPreparation, Robotic] && Length[specifiedOptions] > 0,
						{specifiedOptions[[All,1]], specifiedOptions[[All,2]], Preparation, Robotic},
					True,
						Nothing
				]
			]
		],
		mapThreadFriendlyResolvedOptions
	];

	If[Length[invalidQuantitativeTransferOptions]>0 && messages,
		Message[
			Error::ConflictingQuantitativeTransferOptions,
			invalidQuantitativeTransferOptions[[All,1]],
			ObjectToString[invalidQuantitativeTransferOptions[[All,2]], Cache->simulatedCache],
			invalidQuantitativeTransferOptions[[All,3]],
			ObjectToString[invalidQuantitativeTransferOptions[[All,4]], Cache->simulatedCache]
		]
	];

	quantitativeTransferTest=If[Length[invalidQuantitativeTransferOptions]==0,
		Test["The Quantitative Transfer options must either all be specified or none of them can be specified:", True, True],
		Test["The Quantitative Transfer options must either all be specified or none of them can be specified:", False, True]
	];

	(* Check that the QuantitativeTransfer volume is not exceeding 5 mL. We can only use Micropipette for QuantitativeTransfer wash (5mL limit) since Serological pipettes are difficult to use for this purpose *)
	invalidQuantitativeTransferVolumes = MapThread[
		Function[{options, index},
			Module[{quantitativeTransfer, quantitativeTransferVolume},
				{
					quantitativeTransfer,
					quantitativeTransferVolume
				} = Lookup[
					options,
					{
						QuantitativeTransfer,
						QuantitativeTransferWashVolume
					}
				];


				(* If maxVol or quantitativeTransferVolume is not VolumeP, the previous ConflictingQuantitativeTransferOptions will catch it *)
				If[MatchQ[quantitativeTransfer,True]&&MatchQ[quantitativeTransferVolume,GreaterP[5 Milliliter]],
					{quantitativeTransferVolume, index},
					Nothing
				]
			]
		],
		{mapThreadFriendlyResolvedOptions, Range[Length[simulatedSources]]}
	];

	If[Length[invalidQuantitativeTransferVolumes] > 0 && messages,
		Message[
			Error::InvalidQuantitativeTransferWashVolume,
			invalidQuantitativeTransferVolumes[[All,1]],
			invalidQuantitativeTransferVolumes[[All,2]]
		]
	];

	quantitativeTransferVolumeTest = If[Length[invalidQuantitativeTransferVolumes] == 0,
		Test["The QuantitativeTransferVolume is below 5 Milliliter:", True, True],
		Test["The QuantitativeTransferVolume is below 5 Milliliter:", False, True]
	];

	(* Check if small amount of mass is transferred but QuantitativeTransfer is False. *)
	smallQuantityQuantitativeTransfers = MapThread[
		Function[{options, sample, amount, manipulationIndex},
			Module[{quantitativeTransferQ, weighingContainer},
				{quantitativeTransferQ, weighingContainer} = Lookup[options, {QuantitativeTransfer, WeighingContainer}];

				If[And[
					MatchQ[resolvedPreparation, Manual],
					!TrueQ[quantitativeTransferQ],
					MatchQ[weighingContainer, ObjectP[]],
					MatchQ[amount, MassP] && LessQ[amount, $WeighBoatSmallQuantityThreshold]
				],
					{sample, manipulationIndex, weighingContainer, amount},
					Nothing
				]
			]
		],
		{mapThreadFriendlyResolvedOptions, mySources, myAmounts, Range[Length[simulatedSources]]}
	];

	smallQuantityQuantitativeTransferTest = If[Length[smallQuantityQuantitativeTransfers]==0,
		Warning["All solid transfer amounts beyond the threshold to perform the quantitative transfer to avoid significant loss of sample:",True,True],
		Warning["All solid transfer amounts beyond the threshold to perform the quantitative transfer to avoid significant loss of sample:",False,True]
	];

	If[Length[smallQuantityQuantitativeTransfers]>0 && warnings,
		Message[
			Warning::QuantitativeTransferRecommended,
			ObjectToString[smallQuantityQuantitativeTransfers[[All,1]], Cache->simulatedCache],
			smallQuantityQuantitativeTransfers[[All,2]],
			ObjectToString[smallQuantityQuantitativeTransfers[[All,3]], Cache->simulatedCache],
			smallQuantityQuantitativeTransfers[[All,4]]
		]
	];

	(* Check that the TipRinse options are compatible. *)
	invalidTipRinseOptions=Map[
		Function[{options},
			Module[{tipRinseOptions,specifiedOptions,notSpecifiedOptions},
				tipRinseOptions={
					TipRinse,
					TipRinseSolution,
					TipRinseVolume,
					NumberOfTipRinses
				};

				specifiedOptions=(
					If[MatchQ[Lookup[options, #], Except[Null|False]],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@tipRinseOptions;

				notSpecifiedOptions=(
					If[MatchQ[Lookup[options, #], Null|False],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@tipRinseOptions;

				If[Length[specifiedOptions] > 0 && Length[notSpecifiedOptions] > 0,
					{specifiedOptions[[All,1]], specifiedOptions[[All,2]], notSpecifiedOptions[[All,1]], notSpecifiedOptions[[All,2]]},
					Nothing
				]
			]
		],
		mapThreadFriendlyResolvedOptions
	];

	If[Length[invalidTipRinseOptions]>0 && messages,
		Message[
			Error::TipRinseOptions,
			invalidTipRinseOptions[[All,1]],
			ObjectToString[invalidTipRinseOptions[[All,2]], Cache->simulatedCache],
			invalidTipRinseOptions[[All,3]],
			ObjectToString[invalidTipRinseOptions[[All,4]], Cache->simulatedCache]
		]
	];

	tipRinseTest=If[Length[invalidTipRinseOptions]==0,
		Test["The Tip Rinse options must either all be specified or none of them can be specified:", True, True],
		Test["The Tip Rinse options must either all be specified or none of them can be specified:", False, True]
	];

	(* Check that the AspirationMix options are compatible. *)
	invalidAspirationMixOptions=Map[
		Function[{options},
			Module[{aspirationMixOptions,specifiedOptions,notSpecifiedOptions},
				aspirationMixOptions=Which[
					MatchQ[resolvedPreparation, Robotic]&&MatchQ[Lookup[options,AspirationMixType],Tilt],
					{
						AspirationMix,
						AspirationMixType,
						NumberOfAspirationMixes,
						AspirationMixRate
					},
					MatchQ[resolvedPreparation, Robotic],
					{
						AspirationMix,
						AspirationMixType,
						NumberOfAspirationMixes,
						AspirationMixVolume,
						AspirationMixRate
					},
					True,
					{
						AspirationMix,
						AspirationMixType,
						NumberOfAspirationMixes
					}
				];

				specifiedOptions=(
					If[MatchQ[Lookup[options, #], Except[Null|False]],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@aspirationMixOptions;

				notSpecifiedOptions=(
					If[MatchQ[Lookup[options, #], Null|False],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@aspirationMixOptions;

				If[Length[specifiedOptions] > 0 && Length[notSpecifiedOptions] > 0,
					{specifiedOptions[[All,1]], specifiedOptions[[All,2]], notSpecifiedOptions[[All,1]], notSpecifiedOptions[[All,2]]},
					Nothing
				]
			]
		],
		mapThreadFriendlyResolvedOptions
	];

	If[Length[invalidAspirationMixOptions]>0 && messages,
		Message[
			Error::AspirationMixOptions,
			invalidAspirationMixOptions[[All,1]],
			ObjectToString[invalidAspirationMixOptions[[All,2]], Cache->simulatedCache],
			invalidAspirationMixOptions[[All,3]],
			ObjectToString[invalidAspirationMixOptions[[All,4]], Cache->simulatedCache]
		]
	];

	aspirationMixTest=If[Length[invalidAspirationMixOptions]==0,
		Test["The Aspiration Mix options must either all be specified or none of them can be specified:", True, True],
		Test["The Aspiration Mix options must either all be specified or none of them can be specified:", False, True]
	];

	(* Check that the DestinationMix options are compatible. *)
	invalidDispenseMixOptions=Map[
		Function[{options},
			Module[{dispenseMixOptions,specifiedOptions,notSpecifiedOptions},
				dispenseMixOptions=Which[
					MatchQ[resolvedPreparation, Robotic]&&MatchQ[Lookup[options,DispenseMixType],Tilt],
					{
						DispenseMix,
						DispenseMixType,
						NumberOfDispenseMixes,
						DispenseMixRate
					},
					MatchQ[resolvedPreparation, Robotic],
					{
						DispenseMix,
						DispenseMixType,
						NumberOfDispenseMixes,
						DispenseMixVolume,
						DispenseMixRate
					},
					True,
					{
						DispenseMix,
						DispenseMixType,
						NumberOfDispenseMixes
					}
				];

				specifiedOptions=(
					If[MatchQ[Lookup[options, #], Except[Null|False]],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@dispenseMixOptions;

				notSpecifiedOptions=(
					If[MatchQ[Lookup[options, #], Null|False],
						{#, Lookup[options, #]},
						Nothing
					]
				&)/@dispenseMixOptions;

				If[Length[specifiedOptions] > 0 && Length[notSpecifiedOptions] > 0,
					{specifiedOptions[[All,1]], specifiedOptions[[All,2]], notSpecifiedOptions[[All,1]], notSpecifiedOptions[[All,2]]},
					Nothing
				]
			]
		],
		mapThreadFriendlyResolvedOptions
	];

	If[Length[invalidDispenseMixOptions]>0 && messages,
		Message[
			Error::DispenseMixOptions,
			invalidDispenseMixOptions[[All,1]],
			ObjectToString[invalidDispenseMixOptions[[All,2]], Cache->simulatedCache],
			invalidDispenseMixOptions[[All,3]],
			ObjectToString[invalidDispenseMixOptions[[All,4]], Cache->simulatedCache]
		]
	];

	dispenseMixTest=If[Length[invalidDispenseMixOptions]==0,
		Test["The Dispense Mix options must either all be specified or none of them can be specified:", True, True],
		Test["The Dispense Mix options must either all be specified or none of them can be specified:", False, True]
	];

	(* Check that AspirationMixVolume is not set when AspirationMixType->Tilt. If we tilt the plate to mix, we do not need a volume *)
	invalidTiltMixOptions=Map[
		Function[{options},
			Sequence@@{
				If[
					And[
						MatchQ[resolvedPreparation, Robotic],
						MatchQ[Lookup[options, AspirationMixType], Tilt],
						!NullQ[Lookup[options, AspirationMixVolume]]
					],
					{AspirationMixVolume, Lookup[options, AspirationMixVolume]},
					Nothing
				],
				If[
					And[
						MatchQ[resolvedPreparation, Robotic],
						MatchQ[Lookup[options, DispenseMixType], Tilt],
						!NullQ[Lookup[options, DispenseMixVolume]]
					],
					{DispenseMixVolume, Lookup[options, DispenseMixVolume]},
					Nothing
				]
			}
		],
		mapThreadFriendlyResolvedOptions
	];

	If[Length[invalidTiltMixOptions]>0 && messages,
		Message[
			Error::InvalidTiltMixVolumeOptions,
			invalidTiltMixOptions[[All,1]],
			ObjectToString[invalidTiltMixOptions[[All,2]], Cache->simulatedCache]
		]
	];

	invalidTiltMixTest=If[Length[invalidTiltMixOptions]==0,
		Test["The AspirationMixVolume and DispenseMixVolume options must be Null for Tilt mixing:", True, True],
		Test["The AspirationMixVolume and DispenseMixVolume options must be Null for Tilt mixing:", False, True]
	];

	(* Source hermetic checks. *)
	sourceHermeticTests=If[Length[hermeticSourceErrors]==0,
		Test["The source containers are not attempted to be hermetically unsealed or backfilled if they are not hermetic:", True, True],
		Test["The source containers are not attempted to be hermetically unsealed or backfilled if they are not hermetic:", False, True]
	];

	If[Length[hermeticSourceErrors]>0 && messages,
		Message[
			Error::InvalidSourceHermetic,
			ObjectToString[hermeticSourceErrors[[All,1]], Cache->simulatedCache],
			hermeticSourceErrors[[All,2]]
		]
	];

	(* Destination hermetic checks. *)
	destinationHermeticTests=If[Length[hermeticDestinationErrors]==0,
		Test["The destination containers are not attempted to be hermetically unsealed or vented if they are not hermetic:", True, True],
		Test["The destination containers are not attempted to be hermetically unsealed or vented if they are not hermetic:", False, True]
	];

	If[Length[hermeticDestinationErrors]>0 && messages,
		Message[
			Error::InvalidDestinationHermetic,
			ObjectToString[hermeticDestinationErrors[[All,1]], Cache->simulatedCache],
			hermeticDestinationErrors[[All,2]]
		]
	];

	(* Overaspiration checks. *)
	overaspirationTests=If[Length[overaspirationWarnings]==0,
		Warning["There are no overaspirations from the source samples:", True, True],
		Warning["There are no overaspirations from the source samples:", False, True]
	];

	If[Length[overaspirationWarnings]>0 && warnings,
		Message[
			Warning::OveraspiratedTransfer,
			ObjectToString[overaspirationWarnings[[All,1]], Cache->simulatedCache],
			overaspirationWarnings[[All,2]],
			overaspirationWarnings[[All,3]],
			overaspirationWarnings[[All,4]]
		]
	];

	(* Overfilling checks. *)
	overfilledTests=If[Length[overfilledErrors]==0,
		Test["There are all transfers can be held within the MaxVolume of their destination's containers:", True, True],
		Test["There are all transfers can be held within the MaxVolume of their destination's containers:", False, True]
	];

	If[Length[overfilledErrors]>0 && messages,
		Message[
			Error::OverfilledTransfer,
			ObjectToString[overfilledErrors[[All,1]], Cache->simulatedCache],
			overfilledErrors[[All,2]],
			overfilledErrors[[All,3]],
			overfilledErrors[[All,4]]
		]
	];

	(* Restrict Options checks *)
	restrictTest=If[Length[conflictingRestrictSourceAndDestinationResult]==0,
		Test["There are no samples which are being both restricted and unrestricted:",True, True],
		Test["There are no samples which are being both restricted and unrestricted:",False, True]
	];

	(* Throw an error if trying to restrict and unrestrict a sample *)
	If[Length[conflictingRestrictSourceAndDestinationResult]!=0 && messages,
		Message[
			Error::IncompatibleRestrictOptions,
			conflictingRestrictSourceAndDestinationResult
		]
	];

	(* Check if ReversePipetting is set to True for any samples, and throw a warning that ReversePipetting consumes more than the requested volume of the source sample. *)
	If[Length[reversePipettingSamples] > 0 && warnings,
		Message[
			Warning::ReversePipettingSampleVolume,
			reversePipettingSamples[[All,1]],
			reversePipettingSamples[[All,2]]
		]
	];


	(* Check error for Aspiration/Dispense MixVolume, specifically do not allow it to exceed MaxVolume of tips *)
	invalidAspirationMixVolumeOptions = If[Length[aspirationMixVolumeErrors] > 0 && messages,
		Message[
			Error::AspirationMixVolumeOutOfTipRange,
			aspirationMixVolumeErrors[[All,1]],
			aspirationMixVolumeErrors[[All,2]],
			aspirationMixVolumeErrors[[All,3]],
			aspirationMixVolumeErrors[[All,4]]
		];
		{AspirationMixVolume, Tips},
		{}
	];

	invalidDispenseMixVolumeOptions = If[Length[dispenseMixVolumeErrors] > 0 && messages,
		Message[
			Error::DispenseMixVolumeOutOfTipRange,
			dispenseMixVolumeErrors[[All,1]],
			dispenseMixVolumeErrors[[All,2]],
			dispenseMixVolumeErrors[[All,3]],
			dispenseMixVolumeErrors[[All,4]],
			dispenseMixVolumeErrors[[All,5]]
		];
		{AspirationMixVolume, Tips},
		{}
	];

	invalidAspirationMixVolumeTests = If[Length[aspirationMixVolumeErrors] > 0,
		Test["If AspirationMix is requested, then AspirationMixVolume is within the limit of the MaxVolume of the tips", True, False],
		Test["If AspirationMix is requested, then AspirationMixVolume is within the limit of the MaxVolume of the tips", True, True]
	];

	invalidDispenseMixVolumeTests = If[Length[aspirationMixVolumeErrors] > 0,
		Test["If DispenseMix is requested, then DispenseMixVolume is within the limit of the MaxVolume of the tips", True, False],
		Test["If DispenseMix is requested, then DispenseMixVolume is within the limit of the MaxVolume of the tips", True, True]
	];

	(* Warn user if they are aspiration/dispense mixing with a multichannel pipette for more than $MaxNumberOfMultichannelPipetteMixes times *)
	If[Length[multichannelAspirationMixWarnings] > 0 && warnings,
		Message[
			Warning::TooManyMixesWithMultichannelPipette,
			multichannelAspirationMixWarnings[[All, 1]],
			"AspirationMix",
			multichannelAspirationMixWarnings[[All, 2]],
			"NumberOfAspirationMixes",
			$MaxNumberOfMultichannelPipetteMixes
		]
	];

	If[Length[multichannelDispenseMixWarnings] > 0 && warnings,
		Message[
			Warning::TooManyMixesWithMultichannelPipette,
			multichannelDispenseMixWarnings[[All, 1]],
			"DispenseMix",
			multichannelDispenseMixWarnings[[All, 2]],
			"NumberOfDispenseMixes",
			$MaxNumberOfMultichannelPipetteMixes
		]
	];

	multichannelAspirationMixTest = If[Length[multichannelAspirationMixWarnings] == 0,
		Warning["Samples are not mixed with multichannel pipette for more than "<>ToString[$MaxNumberOfMultichannelPipetteMixes]<>" times during aspiration:", True, True],
		Warning["Samples are not mixed with multichannel pipette for more than "<>ToString[$MaxNumberOfMultichannelPipetteMixes]<>" times during aspiration:", False, True]
	];

	multichannelDispenseMixTest = If[Length[multichannelDispenseMixWarnings] == 0,
		Warning["Samples are not mixed with multichannel pipette for more than "<>ToString[$MaxNumberOfMultichannelPipetteMixes]<>" times during dispense:", True, True],
		Warning["Samples are not mixed with multichannel pipette for more than "<>ToString[$MaxNumberOfMultichannelPipetteMixes]<>" times during dispense:", False, True]
	];

	(* If we cannot find a transfer environment/handling condition combination, throw an error to let user know *)
	noTransferEnvironmentAvailableOptions = If[Length[noTransferEnvironmentAvailableErrors] > 0 && messages,
		(
			(* throw message *)
			Message[
				Error::NoTransferEnvironmentAvailable,
				noTransferEnvironmentAvailableErrors[[All, 1]],
				ObjectToString[noTransferEnvironmentAvailableErrors[[All, 2]], Cache -> simulatedCache],
				ObjectToString[noTransferEnvironmentAvailableErrors[[All, 3]], Cache -> simulatedCache],
				(* manipulate the list of error strings into a sentence *)
				generateTransferEnvironmentErrorTemplate /@ noTransferEnvironmentAvailableErrors[[All, 4]]
			];

			(* add bad options *)
			Flatten[
				{
					TransferEnvironment,
					Lookup[
						(* error type to option lookup *)
						{
							"sterile environment (such as a BiosafetyCabinet)" -> SterileTechnique,
							"IRProbe temperature monitoring" -> {SourceTemperature, DestinationTemperature},
							"Balance" -> Balance,
							"backfilling gas (for sealing hermetic containers)" -> {BackfillGas, UnsealHermeticSource, UnsealHermeticDestination}
						},
						noTransferEnvironmentAvailableErrors[[All, 4]],
						Nothing
					]
				}
			]
		),
		{}
	];

	noTransferEnvironmentAvailableTest = If[Length[noTransferEnvironmentAvailableErrors] == 0,
		Test["A suitable TransferEnvironment can be found to fulfill the user-specified transfers:", True, True],
		Test["A suitable TransferEnvironment can be found to fulfill the user-specified transfers:", False, True]
	];


	(* If we cannot find a transfer environment/handling condition combination, throw an error to let user know *)
	invalidTransferEnvironmentOptions = If[Length[invalidTransferEnvironmentErrors] > 0 && messages,
		(
			(* throw message *)
			Message[
				Error::InvalidTransferEnvironment,
				invalidTransferEnvironmentErrors[[All, 1]],
				ObjectToString[invalidTransferEnvironmentErrors[[All, 2]], Cache -> simulatedCache],
				(* manipulate the list of error strings into a sentence *)
				generateTransferEnvironmentErrorTemplate /@ invalidTransferEnvironmentErrors[[All, 3]]
			];

			(* add bad options *)
			Flatten[
				{
					TransferEnvironment,
					Lookup[
						(* error type to option lookup *)
						{
							"sterile environment (such as a BiosafetyCabinet)" -> SterileTechnique,
							"IRProbe temperature monitoring" -> {SourceTemperature, DestinationTemperature},
							"Balance" -> Balance,
							"backfilling gas (for sealing hermetic containers)" -> {BackfillGas, UnsealHermeticSource, UnsealHermeticDestination}
						},
						invalidTransferEnvironmentErrors[[All, 3]],
						Nothing
					]
				}
			]
		),
		{}
	];

	invalidTransferEnvironmentTest = If[Length[invalidTransferEnvironmentErrors] == 0,
		Test["The specified TransferEnvironment is suitable to fulfill the user-specified transfers:", True, True],
		Test["The specified TransferEnvironment is suitable to fulfill the user-specified transfers:", False, True]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		invalidWellResult[[All,1]],
		overfilledErrors[[All,1]],
		hermeticSourceErrors[[All,1]],
		hermeticDestinationErrors[[All,1]],
		requiredOrCantBeSpecifiedResult[[All,1]],
		weighingContainerErrors[[All,1]],
		aspiratableOrDispensableFalseResult[[All,2]],
		gaseousSampleErrors[[All,1]],
		incompatibleDestinationContainerErrors[[All,1]],
		incompatibleDestinationContainerErrors[[All,3]],
		solidSampleVolumeErrors[[All,1]],
		(* this is different from the rest because missingSampleErrors is only a flat list of integers *)
		mySources[[missingSampleErrors]]
	}]];


	invalidOptions=DeleteDuplicates[Flatten[{
		requiredOrCantBeSpecifiedResult[[All,3]],
		requiredOrCantBeSpecifiedResult[[All,5]],
		incompatibleTipItemConsumableResult[[All,2]],
		instrumentCapacityErrors[[All,1]],
		If[MatchQ[resolvedPreparation, Robotic],{},liquidLevelErrors[[All,1]]],
		invalidDispenseMixOptions[[All,1]],
		invalidDispenseMixOptions[[All,3]],
		invalidAspirationMixOptions[[All,1]],
		invalidAspirationMixOptions[[All,3]],
		invalidTiltMixOptions[[All,1]],
		invalidTipRinseOptions[[All,1]],
		invalidTipRinseOptions[[All,3]],
		invalidQuantitativeTransferOptions[[All,1]],
		invalidQuantitativeTransferOptions[[All,3]],
		If[Length[incompatibleQuantitativeTransferWeighingContainerErrors]>0,
			{WeighingContainer,QuantitativeTransfer},
			{}
		],
		If[Length[noCompatibleWeighingContainerErrors]>0,
			{WeighingContainer},
			{}
		],
		If[Length[incompatibleWeighingContainerErrors]>0,
			{WeighingContainer},
			{}
		],
		If[Length[noCompatibleFunnelErrors]>0,
			{Funnel,WeighingContainer,QuantitativeTransfer},
			{}
		],
		If[Length[incompatibleQuantitativeTransferWashTipsErrors]>0,
			{QuantitativeTransferWashTips,QuantitativeTransfer},
			{}
		],
		If[Length[incompatibleQuantitativeTransferWashInstrumentErrors]>0,
			{QuantitativeTransferWashInstrument,QuantitativeTransfer},
			{}
		],
		If[Length[invalidQuantitativeTransferVolumes] > 0,
			{QuantitativeTransferWashVolume},
			{}
		],
		layerSupernatantLiquidErrors[[All,2]],
		invalidCoverOptions,
		invalidAspirationMixVolumeOptions,
		invalidDispenseMixVolumeOptions,
		If[Length[invalidTolerancesResult]>0,
			{Tolerance},
			{}
		],
		If[Length[weighingContainerErrors]>0,
			{WeighingContainer},
			{}
		],
		If[Length[balanceCleaningMethodRequiredErrors]>0,
			{BalanceCleaningMethod},
			{}
		],
		If[Length[incompatibleSpatulaWidthErrors]>0,
			{Instrument},
			{}
		],
		If[Length[incompatibleIntermediateContainerErrors]>0,
			{IntermediateContainer},
			{}
		],
		If[Length[recoupContaminationErrors]>0,
			{IntermediateDecantRecoup},
			{}
		],
		If[Length[incompatibleFTVIntermediateContainerErrors]>0,
			{IntermediateContainer},
			{}
		],
		If[Length[incompatibleFTVIntermediateDecantErrors]>0,
			{IntermediateDecant},
			{}
		],
		If[Length[incompatibleFTVInstrumentErrors]>0,
			{Instrument},
			{}
		],
		If[Length[incompatibleFTVFunnelErrors]>0,
			{Funnel},
			{}
		],
		If[Length[invalidNumberOfQuantitativeTransferWashesError]>0,
			{NumberOfQuantitativeTransferWashes},
			{}
		],
		If[Length[sterileTransfersAreInBSCResult]>0,
			{SterileTechnique, TransferEnvironment},
			{}
		],
		If[Length[sterileTransfersAreInSTAR]>0,
			{SterileTechnique, WorkCell},
			{}
		],
		If[Length[compatibleTransfersEnvWithInstrumentResult]>0,
			{TransferEnvironment, Instrument},
			{}
		],
		If[Length[aspiratorsRequireSterileTransferResult]>0,
			{SterileTechnique},
			{}
		],
		If[Length[backfillGasResult]>0,
			{BackfillGas, TransferEnvironment},
			{}
		],
		If[Length[invalidTransferEnvironmentBalanceResult]>0,
			{Balance, TransferEnvironment},
			{}
		],
		If[Length[invalidTransferTemperatureResult]>0,
			{SourceTemperature, DestinationTemperature, TransferEnvironment},
			{}
		],
		If[Length[outOfBoundsResult]>0,
			{AspirationPositionOffset, DispensePositionOffset},
			{}
		],
		If[Length[tiltNonPlateResult]>0,
			{AspirationMixType, DispenseMixType, AspirationAngle, DispenseAngle},
			{}
		],
		If[Length[invalidPrecisionResult]>0,
			{Precision},
			{}
		],
		If[Length[instrumentRequiredResult]>0,
			{Instrument},
			{}
		],
		If[Length[plateInstrumentRequiredResult]>0,
			{Instrument},
			{}
		],
		If[Length[collectionContainerSpecifiedResult]>0,
			{CollectionContainer, CollectionTime},
			{}
		],
		If[Length[collectionContainerFootprintResult]>0,
			{CollectionContainer},
			{}
		],
		If[Length[balanceToleranceResult]>0,
			{Balance, Tolerance},
			{}
		],
		If[Length[funnelDestinationResult]>0,
			{Funnel},
			{}
		],
		If[Length[funnelIntermediateResult]>0,
			{IntermediateFunnel},
			{}
		],
		If[Length[aqueousGloveBoxErrors]>0,
			{TransferEnvironment},
			{}
		],
		If[TrueQ[volatileHazardousSamplesInBSCError],
			{TransferEnvironment},
			{}
		],
		If[Length[invalidMultichannelTransferInstrumentResult]>0,
			{MultichannelTransfer},
			{}
		],
		If[Length[invalidCellAspiratorResult]>0,
			{Instrument},
			{}
		],
		If[Length[aspirationLayerSupernatantMismatchResult]>0,
			{Supernatant, AspirationLayer},
			{}
		],
		If[Length[layerInstrumentMismatchResult]>0,
			{Instrument, AspirationLayer, DestinationLayer},
			{}
		],
		If[Length[magnetizationSpecifiedResult]>0,
			{Magnetization, MagnetizationTime, MaxMagnetizationTime},
			{}
		],
		If[Length[invalidAspiratorAmountResult]>0,
			{Instrument},
			{}
		],
		If[Length[noCompatibleTipsErrors]>0,
			{Tips},
			{}
		],
		If[Length[noCompatibleSyringesErrors]>0,
			{Instrument},
			{}
		],
		If[MatchQ[preparationResult, $Failed],
			{Preparation},
			{}
		],
		If[Length[incorrectMultiProbeHeadTransfer]>0,
			{DeviceChannel},
			{}],
		If[Length[invalidMNDispenseErrors]>0,
			{DeviceChannel, DispensePosition},
			{}
		],
		If[Length[incompatibleTipsResult]>0,
			{Tips},
			{}
		],
		If[Length[invalidZeroCorrectionErrors]>0,
			{CorrectionCurve},
			{}
		],
		If[Length[conflictingRestrictSourceAndDestinationResult]>0,
			{RestrictSource, RestrictDestination},
			{}
		],
		(* For experiments that teh developer marks the post processing samples as Living -> True, we need to add potential failing options to invalidOptions list in order to properly fail the resolver *)
		If[MemberQ[Values[resolvedPostProcessingOptions],$Failed],
			PickList[Keys[resolvedPostProcessingOptions],Values[resolvedPostProcessingOptions],$Failed],
			Nothing],
		invalidSamplesInStorageConditionOptions,
		invalidNonDisposalSamplesInStorageConditionOptions,
		noTransferEnvironmentAvailableOptions,
		invalidTransferEnvironmentOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> Flatten[{
			resolvedOptions,
			resolvedPostProcessingOptions
		}],
		Tests -> Flatten[{
			invalidWellTest,
			incorrectlySpecifiedTransferOptionsTest,
			incompatibleTipItemConsumableTest,
			invalidToleranceTest,
			overaspirationTests,
			overfilledTests,
			sourceHermeticTests,
			destinationHermeticTests,
			weighingContainerTest,
			instrumentCapacityTest,
			liquidLevelTest,
			quantitativeTransferTest,
			quantitativeTransferVolumeTest,
			tipRinseTest,
			aspirationMixTest,
			dispenseMixTest,
			invalidTiltMixTest,
			sterileTransfersAreInBSCTest,
			sterileTransfersAreInSTARTest,
			sterileSourceDestinationWarningTests,
			compatibleTransfersEnvWithInstrumentTest,
			backfillGasTest,
			invalidTransferEnvironmentBalanceTest,
			aspiratableOrDispensableFalseTest,
			transferTemperatureTest,
			gaseousSampleTest,
			incompatibleDestinationContainerTest,
			incompatibleFTVIntermediateContainerTest,
			incompatibleFTVIntermediateDecantTest,
			incompatibleIntermediateContainerTest,
			recoupContaminationTest,
			solidSampleVolumeTest,
			roundedOptionTests,
			roundedTransferAmountTest,
			invalidPrecisionTest,
			outOfBoundsTest,
			tiltNonPlateTest,
			instrumentRequiredTest,
			plateInstrumentRequiredTest,
			balanceToleranceTest,
			funnelDestinationTest,
			funnelIntermediateTest,
			incompatibleTipsTest,
			collectionContainerSpecifiedTest,
			collectionContainerFootprintTest,
			aqueousGloveBoxTest,
			layerSupernatantTest,
			invalidMultichannelTransferTest,
			invalidMultiProbeHeadDimensionsTest,
			invalidMNDispenseOptionsTest,
			monotonicCorrectionCurveTest,
			incompleteCorrectionCurveTest,
			invalidZeroCorrectionTest,
			invalidCellAspiratorTest,
			aspirationLayerSupernatantMismatchTest,
			layerInstrumentMismatchTest,
			magnetizationSpecifiedTest,
			magneticRackTest,
			invalidAspiratorAmountTest,
			noCompatibleTipsTest,
			noCompatibleSyringesTest,
			restrictTest,
			preparationTest,
			allResolvedCoverTests,
			missingSampleErrorsTest,
			invalidSamplesInStorageConditionTests,
			invalidAspirationMixVolumeTests,
			invalidDispenseMixVolumeTests,
			multichannelAspirationMixTest,
			multichannelDispenseMixTest,
			invalidNonDisposalSamplesInStorageConditionTests,
			sachetMassTest,
			smallQuantityQuantitativeTransferTest,
			noTransferEnvironmentAvailableTest,
			invalidTransferEnvironmentTest,
			volatileHazardousSamplesInBSCTest
		}]
	}
];

(* ::Subsection:: *)
(* transferResourcePackets *)

DefineOptions[
	transferResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption, OutputOption}
];

transferResourcePackets[
	mySources:{(ObjectP[{Object[Sample], Model[Sample], Object[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]})..},
	myDestinations:{(ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}|Waste)..},
	myAmounts:{(VolumeP|MassP|CountP|All)..},
	myTemplatedOptions:{(_Rule|_RuleDelayed)...},
	myResolvedOptions:{(_Rule|_RuleDelayed)..},
	ops:OptionsPattern[]
]:=Module[
	{expandedInputs, expandedResolvedOptions, outputSpecification, output, gatherTests, messages,
		inheritedCache, simulation, specifiedSite, resolvedPreparation, preparedResources, reusableNeedleModels,
		resourceRentContainerBools, resourceFreshBools, freshSourceModels, combinedResourceRentContainerBool,
		uniqueSampleModelWithSourceIncubations,
		sampleModelsAmountsWithSourceIncubations, totaledSampleModelAmounts, sampleModelContainers, sampleModelContainerRules,
		sourceSampleModelResources, myUniqueDestinationsWithRentQ, specifiedIntegerContainerModelResources,
		protocolPacket, unitOperationPackets, allResourceBlobs, resourcesOk,resourceTests, testsRule, resultRule,
		magnetizationRackResourceLookup, uniqueMagnetizationRacks, fastAssoc, fastAssocKeysIDOnly,
		parentProtocol, parentProtocolTree, parentProtocolSite, upload, peripheralPackets
	},


	(* check if we are uploading or not *)
	upload = Lookup[myResolvedOptions, Upload];

	(* -- SHARED LOGIC BETWEEN ROBOTIC AND MANUAL -- *)

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentTransfer, {mySources, myDestinations, myAmounts}, myResolvedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache];
	simulation = Lookup[ToList[ops],Simulation];
	fastAssoc = makeFastAssocFromCache[inheritedCache];
	(* get the fastAssoc Keys, but only the ones in the ID form (not the name form) *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];

	(* Figure out the parent protocol information *)
	parentProtocol=Lookup[myResolvedOptions,ParentProtocol,Null];
	(* recursively go up the ParentProtocol chain *)
	parentProtocolTree = If[NullQ[parentProtocol],
		{},
		Prepend[repeatedFastAssocLookup[fastAssoc, parentProtocol, ParentProtocol],parentProtocol]
	];
	(* If we are in a subprotocol, we must have the same site as the parent/root protocol *)
	parentProtocolSite = If[!MatchQ[parentProtocolTree,{}],
		Lookup[fetchPacketFromFastAssoc[Last[parentProtocolTree],fastAssoc],Site,Automatic]/.{Null->Automatic},
		Automatic
	];

	(* Define specified Site for instrument resolution below *)
	(* Note that in a lot of cases, our Site is only decided when ConfirmProtocol and UploadResourceStatus are run so our resolved Site can still Automatic. Since Site can decide some instrument models in Transfer, we pre-assign here based on $Site or the specified value *)
	specifiedSite = If[MatchQ[Lookup[myResolvedOptions,Site,Automatic],Automatic],
		parentProtocolSite,
		Download[Lookup[myResolvedOptions,Site],Object]
	];

	(* Lookup the Preparation option. *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Lookup the PreparedResources *)
	preparedResources = Lookup[myResolvedOptions, PreparedResources];

	(* get a list of all reusable needles *)
	reusableNeedleModels = reusableNeedleModelSearch["Memoization"];

	(* Get RentDestinationContainer hidden option from the resolved options *)
	resourceRentContainerBools = Lookup[expandedResolvedOptions,RentDestinationContainer]/.{Null->False};


	(* Get Fresh hidden option from the resolved options *)
	(* We are overwriting the option here since this is hidden *)
	resourceFreshBools = Lookup[expandedResolvedOptions,Fresh]/.{Null->False};

	(* Get the models that are required to be prepared Fresh *)
	freshSourceModels = DeleteDuplicates[
		Download[
			PickList[
				mySources,
				resourceFreshBools,
				True
			],
			Object
		]
	];

	(* Get the total amount of any Model[Sample]s that we were given in our source list. *)
	(* First, get the unique sample models we have with the consideration of their incubation parameters *)
	uniqueSampleModelWithSourceIncubations=Cases[
		DeleteDuplicates[
			Transpose[{
				mySources/.{link_Link:>Download[link,Object]},
				(* Get all the source incubation option values *)
				(* Note that these options are now possible Automatic. For the same Model[Sample], Automatic(s) will resolve to the same values later so this does not affect our grouping *)
				Lookup[expandedResolvedOptions, SourceTemperature]/.{Ambient->$AmbientTemperature, Cold->4 Celsius},
				Lookup[expandedResolvedOptions, SourceEquilibrationTime],
				Lookup[expandedResolvedOptions, MaxSourceEquilibrationTime]
			}]
		],
		{ObjectP[Model[Sample]],___}
	];

	(* Put the sample models and amounts and the source container incubation parameters together *)
	sampleModelsAmountsWithSourceIncubations=Transpose[{
		mySources/.{link_Link:>Download[link, Object]},
		(* Get all the source incubation option values *)
		Lookup[expandedResolvedOptions, SourceTemperature]/.{Ambient->$AmbientTemperature, Cold->4 Celsius},
		Lookup[expandedResolvedOptions, SourceEquilibrationTime],
		Lookup[expandedResolvedOptions, MaxSourceEquilibrationTime],
		myAmounts,
		(* Append an index for resource grouping (If a certain model goes beyond 200 mL for robotic (reservoir) or 20 L for manual (carboy), we will need to request multiple resources for handling). A single transfer in Robotic handling will never go beyond 200 mL due to the limit of the destination size so we won't worry about splitting a single transfer source. *)
		Range[Length[mySources]]
	}];

	(* For each sample model, tally up the amount requested based on the results we got in resolver (passed down with SourceSampleGrouping option. *)
	totaledSampleModelAmounts=Module[
		{sourceSampleGroupings,indexedSourceSampleGroupings,indexedSourceSampleGroups},
		sourceSampleGroupings=Lookup[expandedResolvedOptions,SourceSampleGrouping];
		(* Transpose the sample grouping info with other model handling incubation parameters. Delete any cases that we don't have SourceSampleGrouping for, which means it is not a Model[Sample] resource *)
		indexedSourceSampleGroupings=DeleteCases[Transpose[{sourceSampleGroupings,sampleModelsAmountsWithSourceIncubations}],{Null,_}];
		(* Group by same resource index (and guaranteed to be same Amount) *)
		indexedSourceSampleGroups=GatherBy[indexedSourceSampleGroupings,First];
		Map[
			(* We have already done grouping in resolver so we can safely use the information from the first of the group *)
			(
				(* {model,temp,equilTime,maxEquilTime} -> {totalAmount,all indices} *)
				#[[1,2,;;-3]]->{#[[1,1,2]],#[[All,2,-1]]}
			)&,
			indexedSourceSampleGroups
		]
	];

	(* Lookup the Model[Container]s of these Model[Sample]s, from the SourceContainer option in the resolver *)
	(* Since we may have regrouped one model request (with same incubation parameters) into multiple resources due to the large volume, we have to look up from the index, not only model *)
	sampleModelContainerRules=Map[
		Rule[#[[3]],#[[2]]]&,
		Cases[
			Transpose[{
				mySources/.{obj:ObjectP[]:>Download[obj,Object]},
				Download[#,Object]&/@Lookup[myResolvedOptions, SourceContainer],
				Range[Length[mySources]]
			}],
			{ObjectP[Model[Sample]], ListableP[ObjectP[Model[Container]]], _}
		]
	];

	sampleModelContainers=Map[
		(* Use the first indice to decide the container model. We have resolved to the same container model earlier based on the same grouping rule *)
		If[KeyExistsQ[sampleModelContainerRules,First[#]],
			(First[#]/.sampleModelContainerRules),
			Null
		]&,
		(* Get the indices out of the model amount tuple *)
		totaledSampleModelAmounts[[All,2,2]]
	];

	(* Create resources for any Model[Sample]s we have for our sources. *)
	(* NOTE: We do NOT make a resource if the SourceContainer got resolved to Null. This is set to Null if we're *)
	sourceSampleModelResources=Flatten@MapThread[
		Function[{totaledSampleModelAmount,sourceContainer},
			Module[
				{sourceContainerModel, modelPacket, state, density, sourceContainerMaxVolume, amount, deadVolume, resource},

				(* if we have Object[Container], convert it to Model[Container] (must be single) *)
				(* sourceContainer is a list of Model[Container] for Model[Sample] *)
				sourceContainerModel = If[MatchQ[sourceContainer, ObjectP[Object[Container]]],
					fastAssocLookup[fastAssoc, sourceContainer, {Model, Object}],
					sourceContainer
				];

				(* Get the state of our Model[Sample] at room temperature. *)
				modelPacket=fetchPacketFromFastAssoc[totaledSampleModelAmount[[1,1]], fastAssoc];
				state=Lookup[modelPacket, State];
				(* For solid sample, use its density to figure out the max amount we cant put in a reservoir so we can split if necessary *)
				density=If[MatchQ[Lookup[modelPacket, Density], DensityP],
					Lookup[modelPacket, Density],
					Quantity[0.997`, ("Grams")/("Milliliters")] * 1.25
				];

				(* The following considerations are performed on the smallest possible container, if there is a list. We will add additional dead volume in primitive framework if we have to consolidate more and select a larger container *)
				(* get the MaxVolume of the smallest sourceContainer *)
				sourceContainerMaxVolume = If[MatchQ[state,Solid]&&!NullQ[sourceContainerModel],
					(* Convert to mass max if we are transferring a solid. Use 1 Gram/Milliliter density as in how we deal with PreferredContainer resolution *)
					Min[fastAssocLookup[fastAssoc,#,MaxVolume]&/@ToList[sourceContainerModel]]*density,
					Min[fastAssocLookup[fastAssoc,#,MaxVolume]&/@ToList[sourceContainerModel]]
				];

				(* We are supposed to use the MinVolume of the container as the required container dead volume. However, we do that on the framework level since we may consolidate resources *)

				(* Calculate the dead volume for each transfer *)
				deadVolume=Which[
					MatchQ[totaledSampleModelAmount[[2,1]],VolumeP],
					5Microliter*Count[sampleModelsAmountsWithSourceIncubations, {ObjectP[totaledSampleModelAmount[[1]]], ___}],
					MatchQ[totaledSampleModelAmount[[2,1]],MassP],
					0Gram,
					True,
					Null
				];

				(* When requesting water, we always want to get an amount large enough that we get it from the purifier *)
				(* Engine calls ExperimentTransfer to make amounts less than $MicroWaterMaximum so if we request less than that we'll get stuck in a requesting loop *)
				(* Note this same logic is used in calculating sampleModelWithContainerAndAmount in the resolver *)
				amount=If[MatchQ[totaledSampleModelAmount[[1,1]],WaterModelP],
					Max[$MicroWaterMaximum,Min[{totaledSampleModelAmount[[2,1]]*1.1+deadVolume,If[CompatibleUnitQ[sourceContainerMaxVolume,totaledSampleModelAmount[[2,1]]], sourceContainerMaxVolume, $MaxTransferVolume]}]],
					(* use the smallest of 110% of what we need and the max volume of the source container in case we are working with liquid *)
					If[MatchQ[resolvedPreparation, Manual],
						Which[
							NumericQ[totaledSampleModelAmount[[2,1]]],
							(* If we are dealing with a count item, just go with the amount. No need for 110%. Add Unit for the resource *)
								SafeRound[totaledSampleModelAmount[[2,1]],1]*Unit,
							(* If we are dealing with sachet but we are not given a count, convert it to count and round up a unit *)
							TrueQ[Lookup[modelPacket,Sachet]] && MatchQ[totaledSampleModelAmount[[2,1]], MassP],
								Unit * SafeRound[totaledSampleModelAmount[[2,1]]/Lookup[modelPacket,SolidUnitWeight], 1],
							True,
								Min[{totaledSampleModelAmount[[2,1]]*1.1+deadVolume, If[CompatibleUnitQ[sourceContainerMaxVolume,totaledSampleModelAmount[[2,1]]], sourceContainerMaxVolume, Nothing]}]
						],
						Min[{(totaledSampleModelAmount[[2,1]])*1.1+deadVolume, If[CompatibleUnitQ[sourceContainerMaxVolume,totaledSampleModelAmount[[2,1]]], sourceContainerMaxVolume, Nothing]}]
					]
				];

				resource=If[MatchQ[sourceContainer, ListableP[ObjectP[Model[Container]]]],
					Resource@@{
						Sample->totaledSampleModelAmount[[1,1]],
						Amount->amount,
						(* Provide the name since we need to track this resource in multiple fields *)
						Name->CreateUUID[],
						(* for the container field we should add a failsafe resource, in case the sample resource is not requested in a stocked container and we need to perform consolidation *)
						(* Also, if we are manually preparing non-water resources do not request any containers. Overwrite whatever we requested as SourceContainer *)
						(* This is because water resource must always have ContainerModel specified, and RSP will always need source containers to be specified as well to check compatibility on instruments *)
						(* Otherwise, if we are preparing resources we should try to not specify ContainerModels for source, allowing us to choose any source and avoid entering infinite loop *)
						If[
							(!QuantityQ[amount])||(MatchQ[amount,UnitsP[Unit]])||(!MatchQ[Download[totaledSampleModelAmount[[1]], Object], WaterModelP]&&TrueQ[transferPreparingResourcesQ]&&MatchQ[resolvedPreparation, Manual]),
							Nothing,
							Container->sourceContainer
						],
						(* Populate the source incubation keys (temporary keys) in resource so we can group them on the framework level *)
						If[MemberQ[totaledSampleModelAmount[[1,2;;4]],Except[Null]],
							Sequence@@{
								SourceTemperature ->totaledSampleModelAmount[[1,2]],
								SourceEquilibrationTime -> totaledSampleModelAmount[[1,3]],
								MaxSourceEquilibrationTime -> totaledSampleModelAmount[[1,4]]
							},
							Nothing
						],
						If[MemberQ[freshSourceModels,Download[totaledSampleModelAmount[[1,1]],Object]],
							Fresh->True,
							Nothing
						],
						(* Tell the framework that this Model[Sample] resource can be consolidated with other resources *)
						ConsolidateTransferResources->If[MatchQ[resolvedPreparation,Robotic],
							True,
							False
						]
					},
					Resource@@{
						Sample->totaledSampleModelAmount[[1,1]],
						Amount->amount,
						(* Provide the name since we need to track this resource in multiple fields *)
						Name->CreateUUID[],
						(* Container is not specified, but should add a Fail-safe for water *)
						If[
							MatchQ[Download[totaledSampleModelAmount[[1,1]], Object], WaterModelP],
							Container -> PreferredContainer[amount],
							Nothing
						],
						(* Populate the source incubation keys (temporary keys) in resource so we can group them on the framework level *)
						If[MemberQ[totaledSampleModelAmount[[1,2;;4]],Except[Null]],
							Sequence@@{
								SourceTemperature ->totaledSampleModelAmount[[1,2]],
								SourceEquilibrationTime -> totaledSampleModelAmount[[1,3]],
								MaxSourceEquilibrationTime -> totaledSampleModelAmount[[1,4]]
							},
							Nothing
						],
						If[MemberQ[freshSourceModels,Download[totaledSampleModelAmount[[1,1]],Object]],
							Fresh->True,
							Nothing
						],
						(* Tell the framework that this Model[Sample] resource can be consolidated with other resources *)
						ConsolidateTransferResources->If[MatchQ[resolvedPreparation,Robotic],
							True,
							False
						]
					}
				];

				(* Get the rule from each index to the resource *)
				(#->resource)&/@(totaledSampleModelAmount[[2,2]])
			]
		],
		{totaledSampleModelAmounts,sampleModelContainers}
	];

	(* Create resources for any Model[Container]s we have for our destinations. *)
	myUniqueDestinationsWithRentQ = DeleteDuplicatesBy[
		Cases[
			Transpose[
				{myDestinations,resourceRentContainerBools}
			],
			{{_Integer, ObjectP[Model[Container]]},BooleanP}
		]/.{link_Link:>Download[link, Object]},
		First
	];

	specifiedIntegerContainerModelResources=(
		#[[1]]->Resource[
			Sample->#[[1,2]],
			Name->CreateUUID[],
			Rent->TrueQ[#[[2]]]
		]
	&)/@myUniqueDestinationsWithRentQ;

	(*---Create and combine all of the magnetization rack resources---*)

	(* Get all unique magnetization racks *)
	uniqueMagnetizationRacks=DeleteDuplicates@Cases[Download[Lookup[myResolvedOptions,MagnetizationRack],Object],ObjectReferenceP[]];

	(* create a lookup for magnetization rack resources *)
	magnetizationRackResourceLookup=(
		#->Resource[
			Sample->#,
			Name->CreateUUID[],
			Rent->True
		]&
	)/@uniqueMagnetizationRacks;

	(* Are we making resources for Manual or Robotic? *)
	{protocolPacket, unitOperationPackets, peripheralPackets}=If[MatchQ[resolvedPreparation, Manual],
		Module[
			{
				sharedInstrumentTypes, allSharedInstruments, transferManualUnitOperationPackets, weighingContainerResources, destinationLabelToUUID,
				sourceIncubators, destinationIncubators, resourceIDRules, groupedHeaterCoolerTimeTuplesNoNulls,
				heaterCoolerTimeTuples, sourceTempEquilibrationTimes, destinationTempEquilibrationTimes, sourceIncubatorIDs, destinationIncubatorIDs,
				heaterModelResourceID, coolerModelResourceID, secondaryHeaterModelResourceID, secondaryCoolerModelResourceID,
				heaterModels,coolerModels, heaterTempLimit,coolerTempLimit, heaterDimensionLimits,coolerDimensionLimits,
				heatedContainerDimensions, cooledContainerDimensions, bscTransferQ, cooledContainers, heatedContainers, sourceContainers,destinationContainers,
				sourceTemperatures,destinationTemperatures,containersToBeUsedInBSC,capRackResourcesForBSC, indexMatchedMagnetizationSampleResources,
				groupedMagnetizationWorkingSourceResources, groupedMagnetizationRacks, workingSourceResources, sourceResources, intermediateContainerResources, sachetIntermediateContainerResources,
				transferEnvironmentResources, balanceResources, multichannelNameToTips, multichannelNameToDestinationWells,
				multichannelNameToSourceWells, gatheredMultichannelInformation, ventingNeedleResources, backfillNeedleResources,
				instrumentAndSourceToResource, transposedSourcesAndInstruments, combinedSources, combinedDestinations, combinedAmounts, combinedIndices,
				combinedMapThreadFriendlyOptions, pillCrusherResource, nonEmptyDestinations,funnelAssoc,mappedDestinationContents,funnelResources, intermediateFunnelResources,
				handPumpWasteContainerResource, tipRinseSolutionResources, tipRinseSolutionAndVolume, quantitativeTransferWashSolutionResources,
				quantitativeTransferWashSolutionAndVolume, sharedHandPumpAndAdapterResources, allHandPumps,allHandPumpAdapterPackets, sharedInstrumentResources, reusableSpatulas,reusableSpatulaResources,countedSpatulas, countedSpatulaResources, availablePipetteObjectsAndModels,
				resourcesNotToPickUpFront, manualProtocolPacket,
				expandedQuantitativeTransferWashTips, allTips, talliedTips, tipToResourceListLookup, popTipResource,
				destinationContainerResources, expandedShell, combinedShell, expandCombinedList, flameDestinations, flameSourceResources, roundToInstrumentResolution,
				combinedAmountsRounded, combinedAmountsAsVolume, pipetteDialImages, aspirationMixPipetteDialImages, dispenseMixPipetteDialImages, transferInstMaxVolumes, transferInstResolutions,
				transferInstChannels, transferInstPipetteTypes, discardSources, graduatedCylinderImages, serologicalPipetteImages, intermediateContainerImages, splitTransferEnvironments, overdrawVolumeContainerResource, wasteContainerResource, syringeImages,
				transferManualUnitOperationPacketsWithRequiredObjects, transferManualUnitOperationRequiredResourceTuples
			},

			(* Expand the QuantitativeTransferWashTips options by NumberOfQuantitativeTransferWashes since we want to use a new tip for each wash *)
			expandedQuantitativeTransferWashTips = MapThread[
				If[NullQ[#2],
					Null,
					ConstantArray[#1,#2]
				]&,
				{
					Lookup[myResolvedOptions, QuantitativeTransferWashTips],
					Lookup[myResolvedOptions, NumberOfQuantitativeTransferWashes]
				}
			];
			(* Create resources for all of the tips (both the regular Tips and the QuantitativeTransferWashTips). *)
			(* NOTE: We only take into account tip box partitioning in the Manual case because in the Robotic case, the framework handles it *)
			(* for us by replacing our tip resources in-situ. *)
			allTips=Cases[Flatten@{Lookup[myResolvedOptions, Tips], expandedQuantitativeTransferWashTips}, ObjectP[{Model[Item, Tips], Object[Item, Tips]}]]/.{link_Link:>Download[link, Object]};
			talliedTips=Tally[allTips];

			(* We abstract this tip resource generation function because we use it for the quantitative transfer wash tips as well. *)
			tipToResourceListLookup=Association@Map[
				Function[{tipInformation},
					Module[{tipObject, numberOfTipsNeeded, tipModelPacket, numberOfTipsPerBox},
						(* Pull out from our tip information. *)
						tipObject=tipInformation[[1]];
						numberOfTipsNeeded=tipInformation[[2]];

						(* Get the tip model packet. *)
						tipModelPacket=If[MatchQ[tipObject, ObjectP[Model[Item, Tips]]],
							fetchPacketFromFastAssoc[tipObject, fastAssoc],
							fastAssocPacketLookup[fastAssoc, tipObject, Model]
						];

						(* Lookup the number of tips per box. *)
						(* NOTE: This can be one if they're individually wrapped or if the Tips are Model[Item,Consumable] used for FTV *)
						numberOfTipsPerBox=If[MatchQ[tipObject,ObjectP[Model[Item,Consumable]]],
							1,
							(Lookup[tipModelPacket, NumberOfTips]/.{Null->1})
						];

						(* Return a list that we will pop off of everytime we take a tip. *)
						(* NOTE: If NumberOfTips->1, that means that this tip model is individually wrapped and we shouldn't include *)
						(* the Amount key in the resource. *)
						Download[tipObject, Object]->If[MatchQ[numberOfTipsPerBox, 1],
							Table[
								Resource[
									Sample->tipObject,
									Name->CreateUUID[]
								],
								{x, 1, numberOfTipsNeeded}
							],
							Flatten@{
								Table[ (* Resources for full boxes of tips. *)
									ConstantArray[
										Resource[
											Sample->tipObject,
											Amount->numberOfTipsPerBox,
											Name->CreateUUID[]
										],
										numberOfTipsPerBox
									],
									{x, 1, IntegerPart[numberOfTipsNeeded/numberOfTipsPerBox]}
								],
								ConstantArray[ (* Resources for the tips in the non-full box. *)
									Resource[
										Sample->tipObject,
										Amount->Mod[numberOfTipsNeeded, numberOfTipsPerBox],
										Name->CreateUUID[]
									],
									Mod[numberOfTipsNeeded, numberOfTipsPerBox]
								]
							}
						]
					]
				],
				talliedTips
			];

			(* Helper function to pop a tip resource off of a given stack. *)
			popTipResource[tipObject_]:=Module[{oldResourceList},
				If[MatchQ[tipObject, Null],
					Null,
					oldResourceList=Lookup[tipToResourceListLookup, Download[tipObject, Object]];

					tipToResourceListLookup[Download[tipObject, Object]]=Rest[oldResourceList];

					First[oldResourceList]
				]
			];

			(* Create resources for all of the Model[Instrument, Pipette]s and Model[Item, Spatula]s to be the same. *)
			sharedInstrumentTypes={
				Model[Instrument, Pipette],
				Object[Instrument, Pipette],
				Model[Item, Tweezer],
				Object[Item, Tweezer],
				Model[Item, ChippingHammer],
				Object[Item, ChippingHammer],
				Model[Item, Scissors],
				Object[Item, Scissors],
				Model[Instrument, Aspirator],
				Object[Instrument, Aspirator]
			};
			allSharedInstruments=Cases[
				Flatten[{Lookup[myResolvedOptions, Instrument], Lookup[myResolvedOptions, QuantitativeTransferWashInstrument]}],
				ObjectP[sharedInstrumentTypes]
			]/.{link_Link:>Download[link, Object]};

			sharedInstrumentResources=(
				Which[
					MatchQ[#, ObjectP[{Model[Instrument], Object[Instrument]}]],
					Download[#, Object]->Resource[Instrument->#, Name->CreateUUID[], Time->(5 Minute + (5 Minute * Count[allSharedInstruments, ObjectP[#]]))],
					True,
					Download[#, Object]->Resource[Sample->#, Name->CreateUUID[], Rent->True]
				]
			&)/@DeleteDuplicates[allSharedInstruments];
			
			(* Create resources for spatula *)
			reusableSpatulas=Download[DeleteDuplicatesBy[
				Select[Cases[Lookup[myResolvedOptions, Instrument],ObjectP[{Object[Item,Spatula],Model[Item,Spatula]}]],
                    If[MatchQ[#,ObjectP[Model[Item]]],
                        MatchQ[fastAssocLookup[fastAssoc, #, Reusable],True]&&MatchQ[fastAssocLookup[fastAssoc, #, CleaningMethod],Null],
                        MatchQ[Lookup[fastAssocPacketLookup[fastAssoc,#,Model],Reusable,Null],True]&&MatchQ[Lookup[fastAssocPacketLookup[fastAssoc,#,Model], CleaningMethod,Null],Null]
                    ]&
				],
				ObjectP[#]&
			],Object];
			
			reusableSpatulaResources = # -> Resource[
				Sample->Download[#, Object],
				Name->CreateUUID[],
				Rent->True
			]&/@reusableSpatulas;
			
			countedSpatulas = Download[
				Select[Cases[Lookup[myResolvedOptions, Instrument],ObjectP[{Object[Item,Spatula],Model[Item,Spatula]}]],
					If[MatchQ[#,ObjectP[Model[Item]]],
						MatchQ[fastAssocLookup[fastAssoc, #, Counted],True],
						MatchQ[Lookup[fastAssocPacketLookup[fastAssoc,#,Model],Counted,Null],True]
					]&
				],
			Object];
			
			countedSpatulaResources = Map[
				#[[1]] -> Resource[
					Sample->Download[#[[1]], Object],
					Name->CreateUUID[],
					Amount->#[[2]]
				]&,
				Tally[countedSpatulas,#1===#2&]
			];

			(* Create resources for all of the hand pumps. *)
			allHandPumps=Cases[Lookup[myResolvedOptions, HandPump], ObjectP[{Model[Part, HandPump], Object[Part, HandPump]}]]/.{link_Link:>Download[link, Object]};
			sharedHandPumpResources=(
				Download[#, Object]->Resource[
					Sample->#,
					Name->CreateUUID[],
					Rent->True
				]
			&)/@DeleteDuplicates[allHandPumps];

			(* Create resources for the quantitative transfer wash solution. *)
			quantitativeTransferWashSolutionAndVolume = MapThread[
				If[MatchQ[#1, ObjectP[]],
					({#1, #2*#3}/.{link_Link:>Download[link, Object]}),
					Nothing
				]&,
				{Lookup[myResolvedOptions, QuantitativeTransferWashSolution], Lookup[myResolvedOptions, QuantitativeTransferWashVolume], Lookup[myResolvedOptions, NumberOfQuantitativeTransferWashes]}
			];

			quantitativeTransferWashSolutionResources=(
				Download[#, Object]->If[MatchQ[#, ObjectP[Model[Sample]]],
					Resource[
						Sample->#,
						Name->CreateUUID[],
						Amount->Total[Cases[quantitativeTransferWashSolutionAndVolume, {#, _}][[All,2]]] * 1.1,
						Container->PreferredContainer[Total[Cases[quantitativeTransferWashSolutionAndVolume, {#, _}][[All,2]]] * 1.1, IncompatibleMaterials -> fastAssocLookup[fastAssoc, #, IncompatibleMaterials]]
					],
					Resource[
						Sample->#,
						Name->CreateUUID[],
						Amount->Total[Cases[quantitativeTransferWashSolutionAndVolume, {#, _}][[All,2]]] * 1.1
					]
				]
					&)/@DeleteDuplicates[Cases[Lookup[myResolvedOptions, QuantitativeTransferWashSolution], ObjectP[]]/.{link_Link:>Download[link, Object]}];

			(* Create resources for the tip rinse solution. *)
			tipRinseSolutionAndVolume=Transpose[{Lookup[myResolvedOptions, TipRinseSolution], Lookup[myResolvedOptions, TipRinseVolume]}]/.{link_Link:>Download[link, Object]};
			tipRinseSolutionResources=(
				Download[#, Object]->If[MatchQ[#, ObjectP[Model[Sample]]],
					Resource[
						Sample->#,
						Name->CreateUUID[],
						Amount->Total[Cases[tipRinseSolutionAndVolume, {#, _}][[All,2]]] * 1.1,
						Container->PreferredContainer[Total[Cases[tipRinseSolutionAndVolume, {#, _}][[All,2]]] * 1.1, IncompatibleMaterials -> fastAssocLookup[fastAssoc, #, IncompatibleMaterials]]
					],
					Resource[
						Sample->#,
						Name->CreateUUID[],
						Amount->Total[Cases[tipRinseSolutionAndVolume, {#, _}][[All,2]]] * 1.1
					]
				]
					&)/@DeleteDuplicates[Cases[Lookup[myResolvedOptions, TipRinseSolution], ObjectP[]]/.{link_Link:>Download[link, Object]}];

			(* Create a single resource for HandPumpWasteContainer *)
			handPumpWasteContainerResource=Resource[
				Sample->Model[Container,Vessel,"id:O81aEB4kJJJo"],
				Name->CreateUUID[],
				Rent->True
			];

			(* Single pill crusher resource. *)
			pillCrusherResource=Resource[
				Sample->Model[Item, TabletCrusher, "id:Y0lXejM894kv"],
				Name->CreateUUID[],
				Rent->True
			];

			(* Single OverdrawVolumeWasteContainer resource. *)
			overdrawVolumeContainerResource = If[MatchQ[Lookup[myResolvedOptions, OverdrawVolumeWasteContainer], ObjectP[]],
				Resource[
				Sample -> Lookup[myResolvedOptions, OverdrawVolumeWasteContainer],
				Name -> CreateUUID[],
				Rent -> True],
				Null
			];

			(* Single WasteContainer resource *)
			wasteContainerResource = If[MatchQ[Lookup[myResolvedOptions, WasteContainer], ObjectP[]],
				Resource[
					Sample -> Lookup[myResolvedOptions, WasteContainer],
					Name -> CreateUUID[],
					Rent -> True
				],
				Null
			];


			(* Combine information for any multichannel transfers that are occurring together. *)
			(* NOTE: We error checked in our resolver that multichannel transfers must have the same source, destination, *)
			(* and amount (as a volume) -- so we aren't losing any information here. We also cannot do a multichannel *)
			(* transfer if we have an intermediate decant specified etc. *)
			(* NOTE: We don't collapse the sources/destinations/amounts together if we're doing Preparation->Robotic. *)
			(* In manual transfer, we haven't and will not prepare Model[Sample] resources in multi-well plates *)
			{combinedSources, combinedDestinations, combinedAmounts, combinedIndices, combinedMapThreadFriendlyOptions, combinedResourceRentContainerBool}=Transpose@(
				Most/@DeleteDuplicatesBy[
					Transpose[{mySources, myDestinations, myAmounts, Range[Length[mySources]], OptionsHandling`Private`mapThreadOptions[ExperimentTransfer,myResolvedOptions], resourceRentContainerBools, (If[MatchQ[#, Null], CreateUUID[], #]&)/@Lookup[myResolvedOptions, MultichannelTransferName]}],
					Last
				]
			);

			(* Create helper function that takes in a list that is combined and expands it out to be index matching again. *)
			(* We need this to populate fields in the protocol object. *)
			expandedShell=(If[MatchQ[#, Null], CreateUUID[], #]&)/@Lookup[myResolvedOptions, MultichannelTransferName];
			combinedShell=DeleteDuplicates[expandedShell];
			expandCombinedList[combinedList_]:=expandedShell/.(Rule@@@Transpose[{combinedShell, combinedList}]);
			destinationContainerResources=MapThread[Function[{destination,rentQ},
					Switch[destination,
						ObjectP[Object[Sample]],
						Resource[
							Sample -> fastAssocLookup[fastAssoc, destination, {Container, Object}],
							Name -> fastAssocLookup[fastAssoc, destination, {Container, ID}]
						],
						ObjectP[Object[Item]],
						Resource[
							Sample -> Download[destination, Object],
							Name -> CreateUUID[]
						],
						ObjectP[Object[Container]],
						Resource[
							Sample -> Download[destination, Object],
							Name -> Download[destination, ID]
						],
						ObjectP[Model[Container]],
						Resource[
							Sample -> Download[destination, Object],
							Name -> CreateUUID[],
							Rent -> rentQ
						],
						{_Integer, ObjectP[Model[Container]]},
						Lookup[specifiedIntegerContainerModelResources, Key[destination /. {link_Link :> Download[link, Object]}]],
						{_Integer, ObjectP[Object[Container]]} | {_String, ObjectP[Object[Container]]},
						Resource[
							Sample -> Download[destination[[2]], Object],
							Name -> Download[destination[[2]], ID]
						],
						(* NOTE: We will switch off of the aspirator instrument and the sample will automatically go to waste. *)
						Waste,
						Null
					]],
					{combinedDestinations,combinedResourceRentContainerBool}];

				(* We share graduated cylinders and syringes if the source is the same. *)
				transposedSourcesAndInstruments=Cases[
					Transpose[{combinedSources, Lookup[combinedMapThreadFriendlyOptions, Instrument]}/.{link_Link:>Download[link, Object]}],
					{_, ObjectP[{Model[Container, Syringe], Object[Container, Syringe], Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}]}
				];
				instrumentAndSourceToResource=(
					If[MatchQ[#[[2]], ObjectP[{Model[Instrument], Object[Instrument]}]],
						#->Resource[Instrument->#[[2]], Name->CreateUUID[], Time->(5 Minute + (5 Minute * Count[transposedSourcesAndInstruments, #]))],
						#->Resource[Sample->#[[2]], Name->CreateUUID[], Rent->True]
					]
				&)/@DeleteDuplicates[transposedSourcesAndInstruments];

				(* Make shared resources for the backfill and venting needles. These are shared amongst similar sources and destinations. *)
				(* That is, we will NOT cross contaminate using needles with different ssamples. *)
				backfillNeedleResources=Module[{uniqueBackfillNeedleResourceRules},
					uniqueBackfillNeedleResourceRules=Map[
						#->Resource[
							Sequence@@{Sample -> #[[1]],
								(* if we are using reusable needles, Rent them *)
								If[MatchQ[#[[1]], Alternatives @@ reusableNeedleModels], Rent -> True, Nothing],
								Name -> CreateUUID[]}
						]&,
						DeleteDuplicates[
							MapThread[
								Function[{source, options},
									Which[
										!MatchQ[Lookup[options, BackfillNeedle], ObjectP[]],
											Nothing,
										MatchQ[FirstOrDefault[ToList[Lookup[options, SourceContainer]]], ObjectP[Model[Container]]],
											{Lookup[options, BackfillNeedle], source, Lookup[options, SourceWell]},
										True,
											{Lookup[options, BackfillNeedle], Lookup[options, SourceContainer], Lookup[options, SourceWell]}
									]
								],
								{combinedSources, combinedMapThreadFriendlyOptions}
							]/.{obj:ObjectP[]:>Download[obj, Object]}
						]
					];

					MapThread[
						Function[{source, options},
							Which[
								!MatchQ[Lookup[options, BackfillNeedle], ObjectP[]],
									Null,
								MatchQ[FirstOrDefault[ToList[Lookup[options, SourceContainer]]], ObjectP[Model[Container]]],
									Lookup[
										uniqueBackfillNeedleResourceRules,
										Key[{Lookup[options, BackfillNeedle], source, Lookup[options, SourceWell]}/.{obj:ObjectP[]:>Download[obj, Object]}]
									],
								True,
									Lookup[
										uniqueBackfillNeedleResourceRules,
										Key[{Lookup[options, BackfillNeedle], FirstOrDefault[ToList[Lookup[options, SourceContainer]]], Lookup[options, SourceWell]}/.{obj:ObjectP[]:>Download[obj, Object]}]
									]
							]
						],
						{combinedSources, combinedMapThreadFriendlyOptions}
					]
				];
				ventingNeedleResources=Module[{uniqueVentingNeedleResourceRules},
					uniqueVentingNeedleResourceRules=Map[
						#->Resource[
							Sequence@@{Sample -> #[[1]],
								(* if we are using reusable needles, Rent them *)
								If[MatchQ[#[[1]], Alternatives @@ reusableNeedleModels], Rent -> True, Nothing],
								Name -> CreateUUID[]}
						]&,
						DeleteDuplicates[
							MapThread[
								Function[{destination, destinationResource, options},
									Which[
										!MatchQ[Lookup[options, VentingNeedle], ObjectP[]],
											Nothing,
										MatchQ[Lookup[destinationResource[[1]], Sample], ObjectP[Model[Container]]],
											{Lookup[options, VentingNeedle], destination, Lookup[options, DestinationWell]},
										True,
											{Lookup[options, VentingNeedle], Lookup[destinationResource[[1]], Sample], Lookup[options, DestinationWell]}
									]
								],
								{combinedDestinations, destinationContainerResources, combinedMapThreadFriendlyOptions}
							]/.{obj:ObjectP[]:>Download[obj, Object]}
						]
					];

					MapThread[
						Function[{destination, destinationResource, options},
							Which[
								!MatchQ[Lookup[options, VentingNeedle], ObjectP[]],
									Null,
								MatchQ[Lookup[destinationResource[[1]], Sample], ObjectP[Model[Container]]],
									Lookup[
										uniqueVentingNeedleResourceRules,
										Key[{Lookup[options, VentingNeedle], destination, Lookup[options, DestinationWell]}/.{obj:ObjectP[]:>Download[obj, Object]}]
									],
								True,
									Lookup[
										uniqueVentingNeedleResourceRules,
										Key[{Lookup[options, VentingNeedle], Lookup[destinationResource[[1]], Sample], Lookup[options, DestinationWell]}/.{obj:ObjectP[]:>Download[obj, Object]}]
									]
							]
						],
						{combinedDestinations, destinationContainerResources, combinedMapThreadFriendlyOptions}
					]
				];

			(* Create a map of our multichannel transfer names to the tip resources, source wells, and destination wells. *)
			gatheredMultichannelInformation=GroupBy[
				Cases[
					Transpose[{
						Lookup[myResolvedOptions, SourceWell],
						Lookup[myResolvedOptions, DestinationWell],
						Lookup[myResolvedOptions, Tips],
						Lookup[myResolvedOptions, MultichannelTransferName]
					}],
					{_, _, _, Except[Null]}
				],
				Last
			];

			multichannelNameToSourceWells=KeyValueMap[
				Function[{multichannelTransferName, gatheredInformation},
					multichannelTransferName->gatheredInformation[[All,1]]
				],
				gatheredMultichannelInformation
			];

			multichannelNameToDestinationWells=KeyValueMap[
				Function[{multichannelTransferName, gatheredInformation},
					multichannelTransferName->gatheredInformation[[All,2]]
				],
				gatheredMultichannelInformation
			];

			multichannelNameToTips=KeyValueMap[
				Function[{multichannelTransferName, gatheredInformation},
					multichannelTransferName->gatheredInformation[[All,3]]
				],
				gatheredMultichannelInformation
			];

			(* If multiple transfer environment resources are the same back to back, they should be the same resource object for BSCs and Glove Boxes. *)
			(* This is because only 1 operator can use a BSC or glove box at the same time. We don't have the same restriction for fume hoods and *)
			(* benches so these will be globally assigned to the same resource. *)

			(* NOTE: Benches and fume hoods will be immediately released after they're instrument selected so multiple people can use *)
			(* them at the same time. *)

			(* try to group adjacent transfers as much as possible now that we know each transfer has a specific list of "real" equivalent environments that we can do transfers on no problem
			 given a list: list = {{a, b, c}, {a, b}, {a, c}, {d}, {a, d}}
			 the goal is get this output: {{{a}, {a}, {a}}, {{d}, {d}}} (the first set will use TransferEnvironment a, the next one uses TransferEnvironment d)
			 such that we have the longest group that shares the same TransferEnvironment resource *)
			splitTransferEnvironments = splitByCommonElements[Lookup[combinedMapThreadFriendlyOptions, EquivalentTransferEnvironments]];

			(* Create our index matched transfer environment resources. *)
			{
				transferEnvironmentResources,
				balanceResources
			} = Flatten /@ Transpose[MapThread[
				(* NOTE: Since splitTransferEnvironments is legit grouped, we will for sure find at least one shared transfer environment models within the same group. *)
				Function[{groupedTransferEnvironments, groupedBalances},
					(* we have really considered balance, IR probe compatibility in resolver, so just make the resource here *)
					{
						(* Transfer Environment Resources *)
						(* ConstantArray will only evaluate CreateUUID[] once, so they are pointed to the same environment group *)
						ConstantArray[
							Link[
								Resource[
									(* InstrumentResourceP only accepts a single instrument OBJECT/MODEL, or a list of instrument MODELs, but not a list of OBJECTs, so we have to branch here *)
									Instrument -> If[MatchQ[First[groupedTransferEnvironments], {ObjectP[Model[Instrument]]..}],
										First[groupedTransferEnvironments],
										First[First[groupedTransferEnvironments]]
									],
									Time -> 30 * Minute * Length[groupedTransferEnvironments],
									Name -> CreateUUID[]
								]
							],
							Length[groupedTransferEnvironments]
						],
						(* Balance Resources (if needed) -- for each unique balance type, make a single resource since we're in the same *)
						(* transfer environment here. *)
						groupedBalances /. (
							Map[
								(
									ObjectP[#] -> Resource[
										Instrument -> #,
										Name -> CreateUUID[],
										Time -> (5 Minute * Length[Cases[groupedBalances, ObjectP[#]]])
									]&
								),
								DeleteDuplicates[Download[Cases[groupedBalances, ObjectP[]], Object]]
							]
						)
					}
				],
				{
					splitTransferEnvironments,
					TakeList[
						Download[Lookup[combinedMapThreadFriendlyOptions, Balance], Object],
						Length /@ splitTransferEnvironments
					]
				}
			]];
			
			(* Create resources for all of the hand pumps and adapters. *)
			
			allHandPumpAdapterPackets=Cases[fastAssoc, ObjectP[Model[Part,HandPumpAdapter]],{}];
			
			sharedHandPumpAndAdapterResources = {};
			
			MapIndexed[
				Module[{source, amount, options, position, transferEnvironmentResource, sourceObject, handPumpObject, handPumpModel, handPumpIntakeTubeLength, handPumpDispenseHeight, sourcePacket, sourceContainerModelPackets, sourceContainers, sourceInternalDepth, adapterHeightRange, compatibleHandPumpAdapterPackets, handPumpAdapter},
					
					source = #1[[1]];
					amount = #1[[2]];
					options = #1[[3]];
					transferEnvironmentResource = #1[[4]];
					position = #2[[1]];
					
					sourceObject = Download[source,Object];
					
					handPumpObject = Download[Lookup[options,HandPump],Object];
					
					handPumpModel = If[MatchQ[handPumpObject,ObjectP[Object[Part,HandPump]]],
						fastAssocLookup[fastAssoc,Download[handPumpObject, Object],Model],
						handPumpObject
					];
					
					(* determine if we need a handpump adapter *)
					handPumpIntakeTubeLength = fastAssocLookup[fastAssoc,Download[handPumpModel, Object],IntakeTubeLength]; (* measured from the liquid intake opening to the point where it rests at the container's opening *)
					handPumpDispenseHeight = fastAssocLookup[fastAssoc,Download[handPumpModel, Object],DispenseHeight]; (* maximum distance between liquid intake opening to bottom of container *)
					
					(* it is possible to have a list of of Models for SourceContainer so we will need to Map and select the lowest internal depth as reference *)
					(* if we allow any model as SourceContainer (when we are preparing resource), find preferred container. we did the same thing in resolver for simulation when resolving relevant options *)
					sourcePacket = fetchPacketFromFastAssoc[Download[source,Object], fastAssoc];
					
					sourceContainers = ToList[Lookup[options,SourceContainer]];
					
					sourceContainerModelPackets=Flatten[Map[
						Which[
							NullQ[#],
							fetchPacketFromFastAssoc[PreferredContainer[amount, IncompatibleMaterials -> Lookup[sourcePacket, IncompatibleMaterials]], fastAssoc],
							MatchQ[#,ObjectP[Object[Container]]],
							fastAssocPacketLookup[fastAssoc, Download[#,Object], Model],
							True,
							fetchPacketFromFastAssoc[Download[#,Object], fastAssoc]
						]&,
						sourceContainers
					],1];
					
					sourceInternalDepth=Min[Append[Cases[Lookup[DeleteCases[sourceContainerModelPackets,Null],InternalDepth,{}],_Quantity],Infinity*Meter]];
					
					(* if handPumpIntakeLength is greater than sourceInternalDepth*0.95, if the bottom of the handpump is too close to the bottom of the container, this requires an adapter - this indicates the minimum height required for the adapter *)
					(* handPumpIntakeLength + handPumpDispenseHeight = sourceInternalDepth + adapterHeight : the bottom of the handPump must not be above the handPumpDispenseHeight in order to be able to pull liquid properly - this indicates the maximum height of the adapter *)
					adapterHeightRange = If[MatchQ[handPumpIntakeTubeLength,GreaterEqualP[sourceInternalDepth*0.95]],
						RangeP[handPumpIntakeTubeLength-(sourceInternalDepth*0.95),handPumpIntakeTubeLength+handPumpDispenseHeight-sourceInternalDepth],
						Null
					];
					
					compatibleHandPumpAdapterPackets = Select[allHandPumpAdapterPackets,MatchQ[Lookup[#,Dimensions][[3]],adapterHeightRange]&];
					
					handPumpAdapter = If[MatchQ[Length[compatibleHandPumpAdapterPackets],GreaterEqualP[1]],
						Lookup[FirstOrDefault[compatibleHandPumpAdapterPackets],Object],
						Null
					];
					
					Which[
						(* create new handpump and adapter resources if it's the first UO *)
						MatchQ[position, 1]&&MatchQ[handPumpObject,ObjectP[]],
						AppendTo[
							sharedHandPumpAndAdapterResources,
							{
								Resource[
									Sample->handPumpObject,
									Name->CreateUUID[],
									Rent->True
								],
								If[MatchQ[handPumpAdapter,ObjectP[]],
									Resource[
										Sample->handPumpAdapter,
										Name->CreateUUID[],
										Rent->True
									],
									Null
								]
							}
						],
						
						(* don't create resource if the previous UO is the same source, hand pump and transfer environment - we will not be removing the handpump/adapter from source if next UO is using the same set *)
						And[
							MatchQ[Lookup[options,HandPump],ObjectP[]],
							MatchQ[Lookup[combinedMapThreadFriendlyOptions[[position-1]],HandPump],ObjectP[handPumpObject]],
							MatchQ[sourceObject,ObjectP[combinedSources[[position-1]]]],
							MatchQ[transferEnvironmentResource,transferEnvironmentResources[[position-1]]]
						],
						AppendTo[
							sharedHandPumpAndAdapterResources,
							sharedHandPumpAndAdapterResources[[-1]]
						],
						
						(* otherwise, create a new resource *)
						MatchQ[Lookup[options,HandPump],ObjectP[]],
						AppendTo[
							sharedHandPumpAndAdapterResources,
							{
								Resource[
									Sample->handPumpObject,
									Name->CreateUUID[],
									Rent->True
								],
								If[MatchQ[handPumpAdapter,ObjectP[]],
									Resource[
										Sample->handPumpAdapter,
										Name->CreateUUID[],
										Rent->True
									],
									Null
								]
							}
						],
						
						True,
						AppendTo[
							sharedHandPumpAndAdapterResources,
							{Null,Null}
						]
					]
				
				]&,
				Transpose[{combinedSources, combinedAmounts, combinedMapThreadFriendlyOptions, transferEnvironmentResources}]
			];

			(* Get all of the funnels that we're using. *)
			(* setup tracker for destinations that become filled after a Transfer *)
			nonEmptyDestinations={};

			(* tracks Source, Destination, resolvedFunnel, funnelResource and empty state of destination before transfer UO *)
			funnelAssoc = {};

			mappedDestinationContents = Map[
				Which[
					MatchQ[#,ObjectP[]],
					fastAssocLookup[fastAssoc,#,Contents],

					MatchQ[#,{_Integer, ObjectP[]}|{_String, ObjectP[]}],
					Cases[fastAssocLookup[fastAssoc,#[[2]],Contents],{#[[1]],_}],

					MatchQ[#,Waste],
					Null (* assign Null contents so it'll be considered a non-empty destination *)
				]&,
				combinedDestinations
			];

			MapThread[
				Function[
					{source,destination,destContentsBeforeTransfer,resolvedFunnel},
					Module[
						{
							finalSource,
							finalDestination,
							emptyBeforeTransfer,
							funnelResource,
							sameDestinationFunnelCases,
							nonEmptySourceFunnelCases
						},

						(* *)
						finalSource = source/.y:ObjectP[]->Download[y,Object];
						finalDestination = destination/.y:ObjectP[]->Download[y,Object];

						(* check if the destination is empty before the transfer *)
						emptyBeforeTransfer= If[
							!MatchQ[destContentsBeforeTransfer,{}]||MemberQ[nonEmptyDestinations,finalDestination],
							False,
							True
						];

						(* update a tracker for nonEmptyDestinations to include current destination *)
						nonEmptyDestinations = Append[nonEmptyDestinations,finalDestination];

						(* look for previous transfer UO that has the same destination and same resolvedFunnel *)
						sameDestinationFunnelCases = Cases[
							funnelAssoc,
							KeyValuePattern[{Destination->finalDestination,Funnel->resolvedFunnel}]
						];

						(* look for previous assoc with the same source and resolvedFunnel, and which the previous transfer involved an empty destination *)
						nonEmptySourceFunnelCases=Cases[
							(* Gather assoc by same destination, then get the most recent assoc to see if it was empty prior to transfer *)
							Map[
								LastOrDefault[#,Null]&,
								GatherBy[funnelAssoc,Lookup[#,Destination]&]
							],
							KeyValuePattern[{Source->finalSource,Funnel->resolvedFunnel,Empty->True}]
						];

						funnelResource = Which[
							(* no funnel required, no Resource *)
							MatchQ[resolvedFunnel,Except[ObjectP[]]],
							Null,

							(* if assoc already exists with same destination and same resolvedFunnel, use the resource associated with that assoc *)
							MatchQ[sameDestinationFunnelCases,Except[{}]],
							Flatten[Lookup[sameDestinationFunnelCases,Resource]][[1]],

							(* if assoc already exists with same source and resolvedFunnel, and destination was previously empty, use resource associated with that assoc *)
							MatchQ[nonEmptySourceFunnelCases,Except[{}]],
							Lookup[nonEmptySourceFunnelCases,Resource][[1]],

							(* all else fails, create new resource *)
							True,

							Resource[
								Sample->resolvedFunnel,
								Name->"funnel"<>CreateUUID[]
							]
						];

						funnelAssoc = Append[funnelAssoc,{
							Source->finalSource,
							Destination->finalDestination,
							Funnel->resolvedFunnel,
							Resource->funnelResource,
							Empty->emptyBeforeTransfer
						}]

					]
				],

				{
					combinedSources,
					combinedDestinations,
					mappedDestinationContents,
					Lookup[combinedMapThreadFriendlyOptions,Funnel]
				}
			];

			funnelResources = Lookup[funnelAssoc,Resource];

			intermediateFunnelResources=Map[
				If[NullQ[#],
					Null,
					Resource[
						Sample->#,
						Name->CreateUUID[],
						Rent->True
					]
				]&,
				Lookup[combinedMapThreadFriendlyOptions,IntermediateFunnel]
			];

			(* Create intermediate container resources. *)
			intermediateContainerResources=MapThread[
				Function[{intermediateContainer, sterileTechniqueQ},
					Switch[{intermediateContainer, sterileTechniqueQ},
						{ObjectP[Model], True},
							Resource[
								Sample->Download[intermediateContainer, Object],
								Name->CreateUUID[],
								Rent->True,
								Sterile -> True
							],
						{ObjectP[Model], _},
							Resource[
								Sample->Download[intermediateContainer, Object],
								Name->CreateUUID[],
								Rent->True
							],
						{ObjectP[], True},
							Resource[
								Sample->Download[intermediateContainer, Object],
								Name->CreateUUID[],
								Sterile -> True
							],
						{ObjectP[], _},
							Resource[
								Sample->Download[intermediateContainer, Object],
								Name->CreateUUID[]
							],
						{_, _}, Null
					]
				],
				{
					Lookup[combinedMapThreadFriendlyOptions, IntermediateContainer],
					Lookup[combinedMapThreadFriendlyOptions, SterileTechnique]
				}
			];

			(* Create resources for our sources. *)
			sourceResources=MapThread[
				Function[{source,index},
					Switch[source,
						ObjectP[Model[Sample]],
						Lookup[sourceSampleModelResources,index],
						ObjectP[Object[Sample]],
						Resource[
							Sample->fastAssocLookup[fastAssoc, source, {Container, Object}],
							Name->fastAssocLookup[fastAssoc, source, {Container, ID}]
						],
						ObjectP[Object[Container]],
						Resource[
							Sample->Download[source, Object],
							Name->Download[source, ID]
						],
						(* We should never enter this branch here since the source sample should not be a pure empty container. It may be a Model[Sample] or a simulated Object[Sample]. We still allow the {index, container model} pattern in Transfer for serial transfers but the container must have been filled by a sample earlier. *)
						{_Integer, ObjectP[Model[Container]]},
						Lookup[specifiedIntegerContainerModelResources, Key[source/.{link_Link:>Download[link, Object]}]],
						{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
						Resource[
							Sample->Download[source[[2]], Object],
							Name->Download[source[[2]], ID]
						]
					]
				],
				{combinedSources,combinedIndices}
			];

			(* Figure out our working source resources. *)
			(* NOTE: We actually populate the working source field via execute in the procedure. This is just for magnetization logic. *)
			workingSourceResources=MapThread[
				Function[{sourceResource, intermediateContainerResource},
					If[MatchQ[intermediateContainerResource, _Resource],
						intermediateContainerResource,
						sourceResource
					]
				],
				{sourceResources, intermediateContainerResources}
			];

			(* Link up our resources for the WorkingMagnetizationSource. *)
			(* We place samples into a magnetization rack together if they have (1) the same rack, (2) the same Max/MagnetizationTime, *)
			(* 3) and there are enough positions in the magnetic rack to hold all of the samples. *)
			{groupedMagnetizationWorkingSourceResources, groupedMagnetizationRacks}=Transpose[
				Transpose/@Part[
					GatherBy[
						Transpose[{
							workingSourceResources,
							Lookup[combinedMapThreadFriendlyOptions, MagnetizationRack],
							Lookup[combinedMapThreadFriendlyOptions, MaxMagnetizationTime],
							Lookup[combinedMapThreadFriendlyOptions, MagnetizationTime]
						}],
						({Download[#[[2]], Object], #[[3]], #[[4]]}&)
					],
					All,
					All,
					{1,2}
				]
			];

			indexMatchedMagnetizationSampleResources=MapThread[
				Function[{workingSourceResourceGroup, magnetizationRackGroup},
					(* Do we have a magnetization rack at all? *)
					If[!MatchQ[magnetizationRackGroup, {ObjectP[]..}],
						Sequence@@ConstantArray[{}, Length[magnetizationRackGroup]],
						(* We have a magnetization rack. Figure out what samples to put into the rack and when. *)
						Module[{magnetizationRackPacket, numberOfPositions},
							(* How many spots do we have in our rack? *)
							magnetizationRackPacket=If[MatchQ[magnetizationRackGroup[[1]], ObjectP[Model[]]],
								fetchPacketFromFastAssoc[magnetizationRackGroup[[1]], fastAssoc],
								fastAssocPacketLookup[fastAssoc, magnetizationRackGroup[[1]], Model]
							];
							numberOfPositions=Length[Lookup[magnetizationRackPacket, Positions]];

							(* Put as many containers into the rack as possible, then for the subsequent transfers we no longer need *)
							(* to place the container into the rack because it's already in there. Do this multiple times if we don't *)
							(* have enough positions. *)
							Sequence@@(
								(
									Sequence@@{
										DeleteDuplicates[#],
										Sequence@@ConstantArray[{}, Length[#]-1]
									}
								&)/@Partition[workingSourceResourceGroup, UpTo[numberOfPositions]]
							)
						]
					]
				],
				{groupedMagnetizationWorkingSourceResources, groupedMagnetizationRacks}
			];

			(* Create resources for any required portable heaters/coolers *)

			(* determine which sources and destinations will need to be temperature controlled *)
			{sourceTemperatures,destinationTemperatures}=Transpose@Lookup[combinedMapThreadFriendlyOptions, {SourceTemperature,DestinationTemperature}]/.{Ambient->$AmbientTemperature, Cold->4 Celsius};

			{sourceContainers,destinationContainers}=Map[
				Function[locations,
					Map[
						Function[location,
							Switch[location,
								ObjectP[Object[Sample]],
									fastAssocLookup[fastAssoc, location, {Container, Object}],
								ObjectP[{Object[Item],Object[Container],Model[Container]}],
									Download[location, Object],
								{_Integer, ObjectP[Model[Container]]}|{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
									Download[location[[2]], Object],
								Waste|ObjectP[Model[Sample]],
									Null
							]
						],
						locations
					]
				],
				{combinedSources,combinedDestinations}
			];

			heatedContainers=Cases[
				Flatten[
					PickList[
						(* sometimes there are source containers hiding in the source resource. we definitely need to know these containers to be informed about the heater/cooler selection *)
						Flatten[{Transpose@{sourceContainers, sourceResources}, destinationContainers}, 1],
						Flatten[{sourceTemperatures, destinationTemperatures}],
						TemperatureP?(Function[temp, GreaterQ[temp, $AmbientTemperature]])
					]
				],
				ObjectP[{Object[Container],Model[Container]}],
				All
			];

			cooledContainers=Cases[
				Flatten[
					PickList[
						(* sometimes there are source containers hiding in the source resource. we definitely need to know these containers to be informed about the heater/cooler selection *)
						Flatten[{Transpose@{sourceContainers, sourceResources}, destinationContainers}, 1],
						Flatten[{sourceTemperatures, destinationTemperatures}],
						TemperatureP?(Function[temp, LessQ[temp, $AmbientTemperature]])
					]
				],
				ObjectP[{Object[Container],Model[Container]}],
				All
			];

			(* get all the dimensions of containers that need to be temperature controlled *)
			{heatedContainerDimensions, cooledContainerDimensions} = Map[
				Function[containerList,
					Module[{containerModelPackets},
						containerModelPackets = Map[
							If[MatchQ[#, ObjectP[Object[Container]]],
								fastAssocPacketLookup[fastAssoc, #, Model],
								fetchPacketFromFastAssoc[#, fastAssoc]
							]&,
							containerList
						];

						Lookup[containerModelPackets, Dimensions, {}]
					]
				],
				{heatedContainers, cooledContainers}
			];

			(* collapse the dimensions to determine what we need to fit in the heater/cooler *)
			{heaterDimensionLimits,coolerDimensionLimits}=Function[dimsList,If[Length[dimsList]>0,Max/@Transpose[dimsList],{Infinity,Infinity,Infinity}*Meter]]/@{heatedContainerDimensions,cooledContainerDimensions};

			(* also consider temperature while making the heater/cooler selection *)
			{heaterTempLimit,coolerTempLimit}=With[
				{
					minTemp=Min[Flatten[{sourceTemperatures,destinationTemperatures}/.{Null|Ambient->Nothing, Cold->4 Celsius}]],
					maxTemp=Max[Flatten[{sourceTemperatures,destinationTemperatures}/.{Null|Ambient->Nothing, Cold->4 Celsius}]]
				},
				{
					If[MatchQ[maxTemp,_Quantity],maxTemp,-Infinity*Celsius],
					If[MatchQ[minTemp,_Quantity],minTemp,Infinity*Celsius]
				}
			];

			(*Consider whether we're in a BSC for making the heater/cooler selection*)
			bscTransferQ=MatchQ[Lookup[myResolvedOptions,TransferEnvironment],ListableP[ObjectP[{Object[Instrument, HandlingStation, BiosafetyCabinet],Model[Instrument,HandlingStation,BiosafetyCabinet]}]]];

			(* get the appropriate heater or cooler model(s) we need for the experiment *)
			{heaterModels,coolerModels}=MapThread[portableHeaterCoolerForContainer,{{heaterDimensionLimits,coolerDimensionLimits},{Heat,Cool},{heaterTempLimit,coolerTempLimit}, {bscTransferQ,bscTransferQ}}];

			(* prepare to generate resource by creating UUIDs *)
			{heaterModelResourceID, coolerModelResourceID, secondaryHeaterModelResourceID, secondaryCoolerModelResourceID} = Table[CreateUUID[],4];

			(* we want to share the resource between all the coolers and heaters so that we're not constantly re-picking and storing *)
			{sourceIncubatorIDs,destinationIncubatorIDs}=Transpose@MapThread[
				Function[{sourceTemp,destinationTemp},
					Which[
						(* when source and destination are the same *)
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(GreaterQ[#, 25 Celsius]&),TemperatureP?(GreaterQ[#, 25 Celsius]&)}] && EqualQ[sourceTemp,destinationTemp],
						{heaterModelResourceID,heaterModelResourceID},
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(LessQ[#, 25 Celsius]&),TemperatureP?(LessQ[#, 25 Celsius]&)}] && EqualQ[sourceTemp,destinationTemp],
						{coolerModelResourceID,coolerModelResourceID},
						(* when source and destination are both heated or cooled but mismatched *)
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(GreaterQ[#, 25 Celsius]&),TemperatureP?(GreaterQ[#, 25 Celsius]&)}] && !EqualQ[sourceTemp,destinationTemp],
						{heaterModelResourceID,secondaryHeaterModelResourceID},
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(LessQ[#, 25 Celsius]&),TemperatureP?(LessQ[#, 25 Celsius]&)}] && !EqualQ[sourceTemp,destinationTemp],
						{coolerModelResourceID,secondaryCoolerModelResourceID},
						(* when one is cooled and the other is heated *)
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(GreaterQ[#, 25 Celsius]&),TemperatureP?(LessQ[#, 25 Celsius]&)}],
						{heaterModelResourceID,coolerModelResourceID},
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(LessQ[#, 25 Celsius]&),TemperatureP?(GreaterQ[#, 25 Celsius]&)}],
						{coolerModelResourceID,heaterModelResourceID},
						(* singleton cases *)
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(GreaterQ[#, 25 Celsius]&),_}],
						{heaterModelResourceID,Null},
						MatchQ[{sourceTemp,destinationTemp},{TemperatureP?(LessQ[#, 25 Celsius]&),_}],
						{coolerModelResourceID,Null},
						MatchQ[{sourceTemp,destinationTemp},{_,TemperatureP?(LessQ[#, 25 Celsius]&)}],
						{Null,coolerModelResourceID},
						MatchQ[{sourceTemp,destinationTemp},{_,TemperatureP?(GreaterQ[#, 25 Celsius]&)}],
						{Null,heaterModelResourceID},
						(* no case *)
						True,
						{Null,Null}
					]
				],
				{sourceTemperatures,destinationTemperatures}
			];

			(* determine how long we need to use each heater/cooler *)
			{sourceTempEquilibrationTimes,destinationTempEquilibrationTimes}=Transpose@Lookup[combinedMapThreadFriendlyOptions, {SourceEquilibrationTime,DestinationEquilibrationTime}];

			(* create associated lists of ids and corresponding equlibration times *)
			heaterCoolerTimeTuples=Transpose/@{{sourceIncubatorIDs,sourceTempEquilibrationTimes},{destinationIncubatorIDs,destinationTempEquilibrationTimes}};

			(* remove and combine any Nulls or cases where we'll be heating or cooling simultaneously. This creates an association of the form <|ID1->{{ID1,time1},{ID1,time2}},...|> *)
			groupedHeaterCoolerTimeTuplesNoNulls=GroupBy[
				Flatten[
					MapThread[
						Function[
							{sourceTuple,destinationTuple},
							If[
								(* if we're using the same heater or cooler to adjust the source and the destination, we'll be doing that simultaneously so use the longer equilibration time. always add 5 minutes for each transfer *)
								MatchQ[sourceTuple[[1]],destinationTuple[[1]]] && !MemberQ[{sourceTuple[[1]],destinationTuple[[1]]},Null],
								{{sourceTuple[[1]],Max[sourceTuple[[2]],destinationTuple[[2]]] + 5 Minute}},
								(* otherwise, remove any cases where no incubator is used and add 5 minutes for transferring once the target temp is reached *)
								{sourceTuple,destinationTuple}/.{{Null,_}->Nothing,x:{_String,TimeP}:>{x[[1]], x[[2]] + 5 Minute}}
							]
						],
						heaterCoolerTimeTuples
					],
					1
				],
				First
			];

			(* create resources for these heaters/coolers *)
			resourceIDRules=MapThread[
				Function[
					{models,id},
					id->If[Length[models]>0 && MatchQ[groupedHeaterCoolerTimeTuplesNoNulls,KeyValuePattern[id->_]],
						Resource[
							Instrument->models,
							Name->id,
							(* add all the instrument time together *)
							Time->Total[Lookup[groupedHeaterCoolerTimeTuplesNoNulls,id,{{Null,1 Minute}}][[All,2]]]
						],
						Null
					]
				],
				{
					{heaterModels,coolerModels,heaterModels,coolerModels},
					{heaterModelResourceID, coolerModelResourceID, secondaryHeaterModelResourceID, secondaryCoolerModelResourceID}
				}
			];

			{sourceIncubators,destinationIncubators} = {sourceIncubatorIDs,destinationIncubatorIDs}/.resourceIDRules;
			(* Create a resources for cap racks if we are working in a BSC *)
			(* Generate a list of containers (in the fortmat of object or model) to be used to estimate cap rack resources. *)
			containersToBeUsedInBSC = If[bscTransferQ,
				Flatten@MapThread[
					Cases[{#1,#2,#3},ObjectP[]]&,
					{
						sourceContainers,
						destinationContainers,
						Lookup[combinedMapThreadFriendlyOptions, IntermediateContainer]
					}
				],
				(*Otherwise we are not in a BSC, we don't need to pick cap racks beforehand*)
				{}
			];
			(* Call the helper function to generate the caprack resources if containersToBeUsedInBSC is not empty *)
			capRackResourcesForBSC = If[!MatchQ[containersToBeUsedInBSC,{}|Null],
				estimateCapRackResources[containersToBeUsedInBSC,fastAssoc],
				(* Otherwise we are not working in BSC as the containersToBeUsedInBSC is empty *)
				{}
			];

			(* Create a resource for a lighter to flame destination *)
			(* First, is FlameDestination true for any transfers? *)
			flameDestinations=Lookup[combinedMapThreadFriendlyOptions,FlameDestination];

			(* If there are any samples that need to be flamed, make the resource *)
			flameSourceResources=If[
				MemberQ[flameDestinations,True],
					Resource[
						Sample->Model[Part,Lighter,"id:M8n3rx07ZGa9"](*"BIC Grill Lighter"*)
					],
					Null
			];


			(* Create a lookup from destination labels to UUIDs. This is because we can ask for a transfer into a 50mL tube and *)
			(* label them all the same. *)
			destinationLabelToUUID=(#->CreateUUID[]&)/@DeleteDuplicates[Cases[Lookup[myResolvedOptions, DestinationLabel], _String]];

			(* create resources for the weigh containers *)
			weighingContainerResources=Module[
				{fullList, gathered, merged, mergedResources, mergedSamples, replacementRules, onlyResources},

				(* make naive resources for the WeighingContainer *)
				fullList = Map[Function[{options},
					Which[
						MatchQ[Lookup[options, WeighingContainer], ObjectP[{Model[Item]}]],
							If[
								MatchQ[fastAssocLookup[fastAssoc,Lookup[options, WeighingContainer],Counted],True],
								Resource[
									Sample -> Lookup[options, WeighingContainer],
									Amount -> 1
								],
								Resource[
									Sample -> Lookup[options, WeighingContainer],
									Name->CreateUUID[]
								]
							],
						MatchQ[Lookup[options, WeighingContainer], ObjectP[{Object[Item]}]],
							If[
								MatchQ[fastAssocLookup[fastAssoc, fastAssocPacketLookup[fastAssoc,Lookup[options, SachetIntermediateContainer],Model], Counted],True],
								Resource[
									Sample -> Lookup[options, WeighingContainer],
									Amount -> 1
								],
								Resource[
									Sample -> Lookup[options, WeighingContainer],
									Name->CreateUUID[]
								]
							],
						MatchQ[Lookup[options, WeighingContainer], ObjectP[]],
							Resource[
								Sample -> Lookup[options, WeighingContainer],
								Name->CreateUUID[]
							],
						True,
							Null
					]
				], combinedMapThreadFriendlyOptions];

				(* grab only resources without Null *)
				onlyResources = Cases[fullList, _Resource];

				(* return early if there are no resources or no resources with Amount *)
				If[Or[
					MatchQ[onlyResources, ListableP[Null]],
					!MemberQ[
						KeyExistsQ[#, Amount]& /@ onlyResources[[All, 1]],
						True
					]],
					Return[fullList, Module]
				];

				(* gather those resources based on the Sample type *)
				gathered=GatherBy[onlyResources, (Lookup[#[[1]], Sample]&)];

				merged = Flatten@Map[
					If[KeyExistsQ[#[[1,1]], Amount],
					(* merge resources for counted resources *)
					Resource[
						Sample->Lookup[#[[1,1]], Sample],
						Amount-> Total[Lookup[#[[All,1]], Amount]],
						UpdateCount->True,
						Name->CreateUUID[]
					],
					(* in other cases, leave these as they are *)
					#
				]&, gathered];

				(* make a list of the resources that were merged *)
				mergedResources = Cases[merged, _?(KeyExistsQ[#[[1]], Amount]&)];

				(* extract Sample form those Resources *)
				mergedSamples = Lookup[mergedResources[[All,1]], Sample];

				(* make replacement rules original Resource->new Resource *)
				replacementRules = MapThread[(Resource[Sample -> #1, Amount -> 1]->#2)&,{mergedSamples, mergedResources}];

				(* return the list of Resources replaced with merged resources *)
				fullList/.replacementRules
			];

			sachetIntermediateContainerResources = Module[
				{fullList, gathered, merged, mergedResources, mergedSamples, replacementRules, onlyResources},
				
				(* make naive resources for the WeighingContainer *)
				fullList = Map[Function[{options},
					Which[
						MatchQ[Lookup[options, SachetIntermediateContainer], ObjectP[{Model[Item]}]],
						If[
							MatchQ[fastAssocLookup[fastAssoc,Lookup[options, SachetIntermediateContainer],Counted],True],
							Resource[
								Sample -> Lookup[options, SachetIntermediateContainer],
								Amount -> 1
							],
							Resource[
								Sample -> Lookup[options, SachetIntermediateContainer],
								Name->CreateUUID[]
							]
						],
						MatchQ[Lookup[options, SachetIntermediateContainer], ObjectP[{Object[Item]}]],
						If[
							MatchQ[fastAssocLookup[fastAssoc, fastAssocPacketLookup[fastAssoc,Lookup[options, SachetIntermediateContainer],Model], Counted],True],
							Resource[
								Sample -> Lookup[options, SachetIntermediateContainer],
								Amount -> 1
							],
							Resource[
								Sample -> Lookup[options, SachetIntermediateContainer],
								Name->CreateUUID[]
							]
						],
						MatchQ[Lookup[options, SachetIntermediateContainer], ObjectP[]],
						Resource[
							Sample -> Lookup[options, SachetIntermediateContainer],
							Name->CreateUUID[]
						],
						True,
						Null
					]
				], combinedMapThreadFriendlyOptions];
				
				(* grab only resources without Null *)
				onlyResources = Cases[fullList, _Resource];
				
				(* return early if there are no resources or no resources with Amount *)
				If[Or[
					MatchQ[onlyResources, ListableP[Null]],
					!MemberQ[
						KeyExistsQ[#, Amount]& /@ onlyResources[[All, 1]],
						True
					]],
					Return[fullList, Module]
				];
				
				(* gather those resources based on the Sample type *)
				gathered=GatherBy[onlyResources, (Lookup[#[[1]], Sample]&)];
				
				merged = Flatten@Map[
					If[KeyExistsQ[#[[1,1]], Amount],
						(* merge resources for counted resources *)
						Resource[
							Sample->Lookup[#[[1,1]], Sample],
							Amount-> Total[Lookup[#[[All,1]], Amount]],
							UpdateCount->True,
							Name->CreateUUID[]
						],
						(* in other cases, leave these as they are *)
						#
					]&, gathered];
				
				(* make a list of the resources that were merged *)
				mergedResources = Cases[merged, _?(KeyExistsQ[#[[1]], Amount]&)];
				
				(* extract Sample form those Resources *)
				mergedSamples = Lookup[mergedResources[[All,1]], Sample];
				
				(* make replacement rules original Resource->new Resource *)
				replacementRules = MapThread[(Resource[Sample -> #1, Amount -> 1]->#2)&,{mergedSamples, mergedResources}];
				
				(* return the list of Resources replaced with merged resources *)
				fullList/.replacementRules
			];

			(* helper: round amount to a given resolution dictated by the instrument option *)
			roundToInstrumentResolution[myAmount_, myOptions_] := Module[{instrumentType},
				(* get the instrument type *)
				instrumentType = Which[
					(* We have a graduated cylinder and a volume. *)
					MatchQ[Lookup[myOptions, Instrument], ObjectP[{Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}]],
						Model[Container, GraduatedCylinder],
					(* We have a pipette and a volume. *)
					MatchQ[Lookup[myOptions, Instrument], ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]],
						Model[Item, Tips],
					(* We have a syringe and a volume. *)
					MatchQ[Lookup[myOptions, Instrument], ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]],
						Model[Container, Syringe],
					(* Otherwise, we don't have to care about transfer amount precision. *)
					True,
						Null
				];
				(* do the rounding *)
				If[MatchQ[instrumentType, Except[Null]],
					Quiet[AchievableResolution[myAmount, instrumentType], Warning::AmountRounded],
					myAmount
				]
			];

			{combinedAmountsRounded, combinedAmountsAsVolume} = Transpose[MapThread[
				Function[{amount, source, options},
					Module[{roundedAmountWithMass},
						(* round the amount to instrument precision if we can *)
						roundedAmountWithMass = If[MatchQ[amount, VolumeP],
							roundToInstrumentResolution[amount, options],
							amount
						];

						{
							(* return amounts with only volumes rounded to known instrument precision, mass untouched *)
							roundedAmountWithMass,
							(* return amounts with masses converted to volume *)
							If[MatchQ[roundedAmountWithMass, MassP],
								Module[{density},
									(* we will try to lookup density from the source, and its model *)
									density = Which[
										(* the sample has density populated, great, just use that *)
										MatchQ[fastAssocLookup[fastAssoc, source, Density], DensityP],
											fastAssocLookup[fastAssoc, source, Density],
										(* otherwise look to see if we have density populated in its model *)
										MatchQ[fastAssocLookup[fastAssoc, source, {Model, Density}], DensityP],
											fastAssocLookup[fastAssoc, source, {Model, Density}],
										(* If we don't have a density, assume that it's a less dense than water to be safe. *)
										True,
											Quantity[0.5`, ("Grams") / ("Milliliters")]
									];
									roundToInstrumentResolution[roundedAmountWithMass / density, options]
								],
								roundedAmountWithMass
							]
						}
					]
				],
				{combinedAmounts, combinedSources, combinedMapThreadFriendlyOptions}
			]];

			(* get a few parameters off transfer instrument *)
			{
				transferInstMaxVolumes,
				transferInstResolutions,
				transferInstChannels,
				transferInstPipetteTypes
			} = Module[{transferInsts},
				transferInsts = Lookup[combinedMapThreadFriendlyOptions, Instrument];
				(* fetch info from cache, we always fetch these info from the model to avoid downloading computable fields *)
				{
					fastAssocLookup[fastAssoc, Sequence @@ If[MatchQ[#, ObjectP[Object[Instrument]]], {#, {Model, MaxVolume}}, {#, MaxVolume}]]& /@ transferInsts,
					fastAssocLookup[fastAssoc, Sequence @@ If[MatchQ[#, ObjectP[Object[Instrument]]], {#, {Model, Resolution}}, {#, Resolution}]]& /@ transferInsts,
					fastAssocLookup[fastAssoc, Sequence @@ If[MatchQ[#, ObjectP[Object[Instrument]]], {#, {Model, Channels}}, {#, Channels}]]& /@ transferInsts,
					fastAssocLookup[fastAssoc, Sequence @@ If[MatchQ[#, ObjectP[Object[Instrument]]], {#, {Model, PipetteType}}, {#, PipetteType}]]& /@ transferInsts
				}
			];

			(*Determine if source sample along with its container and covered should be discarded at the end of each batched unit operation in biosafety cabinet.*)
			(*NOTE: we might have a Model[Sample] at this point, so we can not rely on any Container information here*)
			discardSources = Module[{uniqueSources, uniqueSourceLastPositions, sourcesToDiscard},
				(*Get a non-repeating list of sources*)
				uniqueSources = DeleteDuplicates[combinedSources];
				(*Find the positions of the source's last used (reversed as first position here*)
				uniqueSourceLastPositions = (# -> FirstPosition[Reverse[combinedSources],#])&/@uniqueSources;
				sourcesToDiscard = DeleteDuplicates@PickList[combinedSources,Lookup[combinedMapThreadFriendlyOptions, SamplesInStorageCondition], Disposal];
				(*Construct the list of whether to discard the source*)
				Reverse@MapIndexed[
					Function[{source,index},
						(*If this source is to be discarded, and this is the last time it is used, set to True, otherwise set to False*)
						If[And[
							MemberQ[sourcesToDiscard, source],
							MatchQ[Lookup[uniqueSourceLastPositions,source],index]
						],
							True,
							False
						]
					],
					Reverse[combinedSources]
				]
			];

				(* generate the pipette dial images to tell operator how to set pipette *)
			pipetteDialImages = generatePipetteDialImage[
				combinedAmountsAsVolume,
				transferInstMaxVolumes,
				transferInstResolutions,
				transferInstChannels,
				transferInstPipetteTypes,
				Upload -> upload
			];
			aspirationMixPipetteDialImages = generatePipetteDialImage[
				Lookup[combinedMapThreadFriendlyOptions, AspirationMixVolume],
				transferInstMaxVolumes,
				transferInstResolutions,
				transferInstChannels,
				transferInstPipetteTypes,
				Upload -> upload
			];
			dispenseMixPipetteDialImages = generatePipetteDialImage[
				Lookup[combinedMapThreadFriendlyOptions, DispenseMixVolume],
				transferInstMaxVolumes,
				transferInstResolutions,
				transferInstChannels,
				transferInstPipetteTypes,
				Upload -> upload
			];

			(* Create screenshots for graduated cylinder tasks. *)
			graduatedCylinderImages = MapThread[Function[{transferInstrument, amount},
				Module[{graphic, packet},
					If[MatchQ[transferInstrument, ObjectP[{Object[Container, GraduatedCylinder], Model[Container, GraduatedCylinder]}]] && MatchQ[amount, VolumeP],
						packet = If[MatchQ[transferInstrument, ObjectP[Object[Container]]],
							fastAssocPacketLookup[fastAssoc, transferInstrument, Model],
							fetchPacketFromFastAssoc[transferInstrument, fastAssoc]
						];
						(* Generate MM graphics for the graduated cylinder *)
						graphic = Quiet[
							PlotGraduatedCylinder[packet, amount, FieldOfView -> MeniscusPoint, Cache -> {packet}],
							{Error::VolumeOutsidePlottableRange, Error::UnableToPlotGraduatedCylinderModel, Warning::VolumeOutsideOfGraduations}
						];
						(* If we were able to generate the graphic.. *)
						If[MatchQ[graphic, _Graphics],
							(*.. upload the MM graphics convert to image Image and call UploadCloudFile with the upload option.*)
							Block[{$DisableVerbosePrinting = True}, UploadCloudFile[Image[graphic], Upload -> upload]],
							Null
						],
						Null
					]
				]],
				{Lookup[combinedMapThreadFriendlyOptions, Instrument], combinedAmountsAsVolume}
			];

			(* Create screenshots for graduated cylinder tasks. *)
			serologicalPipetteImages = MapThread[Function[{tip, amount},
				Module[{graphic, packet},
					If[MatchQ[tip, ObjectP[{Object[Item, Tips], Model[Item, Tips]}]] && MatchQ[amount, VolumeP],
						packet = If[MatchQ[tip, ObjectP[Object[Item]]],
							fastAssocPacketLookup[fastAssoc, tip, Model],
							fetchPacketFromFastAssoc[tip, fastAssoc]
						];
						(* Generate MM graphics for the graduated cylinder *)
						graphic = Quiet[
							PlotSerologicalPipette[packet, amount, FieldOfView -> MeniscusPoint, Cache -> {packet}],
							{Error::VolumeOutsidePlottableRange, Error::UnableToPlotTipModel, Error::InvalidPipetteType, Warning::VolumeOutsideOfGraduations}
						];
						(* If we were able to generate the graphic.. *)
						If[MatchQ[graphic, _Graphics],
							(*.. upload the MM graphics convert to image Image and call UploadCloudFile with the upload option.*)
							Block[{$DisableVerbosePrinting = True}, UploadCloudFile[Image[graphic], Upload -> upload]],
							Null
						],
						Null
					]
				]],
				{Lookup[combinedMapThreadFriendlyOptions, Tips], combinedAmountsAsVolume}
			];

			(* Create screenshots for intermediate container pouring tasks *)
			intermediateContainerImages = MapThread[
				Function[{intermediateContainer, amount},
					If[MatchQ[intermediateContainer, ObjectP[{Object[Container, Vessel], Model[Container, Vessel]}]] && MatchQ[amount, VolumeP],
						Module[{graphic, packet},
							(* fetch the model packet for sure *)
							packet = If[MatchQ[intermediateContainer, ObjectP[Object[Container]]],
								fastAssocPacketLookup[fastAssoc, intermediateContainer, Model],
								fetchPacketFromFastAssoc[intermediateContainer, fastAssoc]
							];
							(* Generate MM graphics for the intermediate container, we always ask operator to pour ~1.1x *)
							graphic = Quiet[
								PlotContainer[packet, amount * 1.1, FieldOfView -> All, Cache -> {packet}],
								{Error::VolumeOutsidePlottableRange, Error::UnableToPlotContainerModel, Warning::VolumeOutsideOfGraduations}
							];
							(* If we were able to generate the graphic.. *)
							If[MatchQ[graphic, _Graphics],
								(*.. upload the MM graphics convert to image Image and call UploadCloudFile with the upload option.*)
								Block[{$DisableVerbosePrinting = True}, UploadCloudFile[Image[graphic], Upload -> upload]],
								Null
							]
						],
						Null
					]
				],
				{Lookup[combinedMapThreadFriendlyOptions, IntermediateContainer], combinedAmountsAsVolume}
			];

			(* Create screenshots for syringe tasks. *)
			syringeImages = MapThread[Function[{transferInstrument, amount},
				Module[{graphic, packet},
					If[MatchQ[transferInstrument, ObjectP[{Object[Container, Syringe], Model[Container, Syringe]}]] && MatchQ[amount, VolumeP],
						packet = If[MatchQ[transferInstrument, ObjectP[Object[Container, Syringe]]],
							fastAssocPacketLookup[fastAssoc, transferInstrument, Model],
							fetchPacketFromFastAssoc[transferInstrument, fastAssoc]
						];
						(* Generate MM graphics for the syringe *)
						graphic = Quiet[
							PlotSyringe[packet, amount, FieldOfView -> MeniscusPoint, Cache -> {packet}],
							{Error::VolumeOutsidePlottableRange, Error::UnableToPlotSyringeModelTypesFilled, Error::UnableToPlotSyringeModelMismatchedLengths, Warning::VolumeOutsideOfGraduations}
						];
						(* If we were able to generate the graphic.. *)
						If[MatchQ[graphic, _Graphics],
							(*.. upload the MM graphics convert to image Image and call UploadCloudFile with the upload option.*)
							Block[{$DisableVerbosePrinting = True}, UploadCloudFile[Image[graphic], Upload -> upload]],
							Null
						],
						Null
					]
				]],
				{Lookup[combinedMapThreadFriendlyOptions, Instrument], combinedAmountsAsVolume}
			];

			(* Map over each of our resolve transfers and make a Object[UnitOperation, Transfer] for it. *)
			transferManualUnitOperationPackets=UploadUnitOperation[
				MapThread[
					Function[{source, destination, amount, roundedAmount, roundedAmountAsVolume, sourceResource, transferEnvironmentResource, balanceResource, backfillNeedleResource, ventingNeedleResource, intermediateContainerResource, indexMatchedMagnetizationSampleResource, options, sourceIncubator, destinationIncubator, weighingContainerResource, destinationResource, pipetteDialImage, aspirationMixPipetteDialImage, dispenseMixPipetteDialImage, graduatedCylinderImage, serologicalPipetteImage, intermediateContainerImage, discardSource, sachetIntermediateContainerResource,funnelResource,intermediateFunnelResource, syringeImage,handPumpAndAdapter},
						Module[{nonHiddenTransferOptions, weighingContainer, sachetIntermediateContainer},
							(* Only include non-hidden options from Transfer. *)
							nonHiddenTransferOptions=Lookup[
								Cases[OptionDefinition[ExperimentTransfer], KeyValuePattern["Category"->Except["Hidden"]]],
								"OptionSymbol"
							];

							(* pull stuff out of the options here so we don't have to do it again and again below *)
							{weighingContainer,sachetIntermediateContainer} = Download[Lookup[options, {WeighingContainer,SachetIntermediateContainer}], Object];

							(* Override any options with resource. *)
							Transfer@Join[
								Cases[Normal[options], Verbatim[Rule][Alternatives@@nonHiddenTransferOptions|MultichannelTransferName|RentDestinationContainer|LivingDestination, _]],
								{
									(* NOTE: We always make resources for the containers, not the samples. This is because we want the container *)
									(* objects, not the sample objects to show up in the engine instructions. *)
									Source-> If[MatchQ[Lookup[options, MultichannelTransferName], Null],
										sourceResource,
										ConstantArray[
											sourceResource,
											Length[Lookup[multichannelNameToSourceWells, Lookup[options, MultichannelTransferName]]]
										]
									],

									Destination->Module[{destination},
										destination=If[MatchQ[destination, Waste],
											Waste,
											destinationResource
										];

										(* NOTE: Make sure to expand the destination if we're doing MultichannelTransfer because we're passing *)
										(* FastTrack->True to UploadUnitOperation which means that everything has to be pre-expanded. *)
										If[MatchQ[Lookup[options, MultichannelTransferName], Null],
											destination,
											ConstantArray[
												destination,
												Length[Lookup[multichannelNameToSourceWells, Lookup[options, MultichannelTransferName]]]
											]
										]
									],

									Amount->amount,

									DisplayedAmount -> If[MatchQ[roundedAmount, All],
										"All (the entire amount of the sample)",
										ToString[roundedAmount]
									],
									DisplayedAmountAsVolume -> If[MatchQ[roundedAmountAsVolume, All],
										"All (the entire amount of the sample)",
										ToString[roundedAmountAsVolume]
									],

									DisplayedAspirationMixVolume->If[MatchQ[Lookup[options, AspirationMixVolume], VolumeP],
										"set the pipette to "<>ToString[Lookup[options, AspirationMixVolume]],
										""
									],

									DisplayedDispenseMixVolume->If[MatchQ[Lookup[options, DispenseMixVolume], VolumeP],
										"set the pipette to "<>ToString[Lookup[options, DispenseMixVolume]],
										""
									],

									DestinationRack->Which[
										(* It was resolved to an object *)
										MatchQ[Lookup[options, DestinationRack], ObjectP[Object[Container]]],
										Resource[
											Sample->Lookup[options, DestinationRack],
											Rent->True,
											Name->(ToString[Lookup[options, DestinationRack]]<>" destination rack")
										],
										(* If using weighing container or sachet weigh boat, non-selfstanding destination container will not need to be on balance. *)
										MemberQ[{weighingContainer,sachetIntermediateContainer},ObjectP[]],
										Null,
										(* Otherwise will need to look at the destination container to find a suitable rack *)
										True,
										Switch[destination,
											ObjectP[Object[Sample]],
											Module[{destinationContainerModelPacket,destinationContainerModel,rack},
												destinationContainerModelPacket=fastAssocPacketLookup[fastAssoc, Download[destination, Object], {Container, Model}];

												destinationContainerModel=Lookup[destinationContainerModelPacket,Object];

												rack=If[MatchQ[Lookup[destinationContainerModelPacket,SelfStanding,Null],True],
													Null,
													RackFinder[destinationContainerModel]
												];

												If[MatchQ[rack,ObjectP[]]&&MatchQ[amount,MassP],
													Resource[
														Sample->rack,
														Rent->True,
														Name->(ToString[rack]<>" destination rack")
													],
													Null
												]
											],
											ObjectP[Object[Container]],
											Module[{destinationContainerModelPacket,destinationContainerModel,rack},
												destinationContainerModelPacket=fastAssocPacketLookup[fastAssoc, Download[destination, Object], Model];

												destinationContainerModel=Lookup[destinationContainerModelPacket,Object];

												rack=If[MatchQ[Lookup[destinationContainerModelPacket,SelfStanding,Null],True],
													Null,
													RackFinder[destinationContainerModel]
												];

												If[MatchQ[rack,ObjectP[]]&&MatchQ[amount,MassP],
													Resource[
														Sample->rack,
														Rent->True,
														Name->(ToString[rack]<>" destination rack")
													],
													Null
												]
											],
											{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
											Module[{destinationContainerModelPacket,destinationContainerModel,rack},
												destinationContainerModelPacket=fastAssocPacketLookup[fastAssoc, Download[destination[[2]], Object], Model];

												destinationContainerModel=Lookup[destinationContainerModelPacket,Object];

												rack=If[MatchQ[Lookup[destinationContainerModelPacket,SelfStanding,Null],True],
													Null,
													RackFinder[destinationContainerModel]
												];

												If[MatchQ[rack,ObjectP[]]&&MatchQ[amount,MassP],
													Resource[
														Sample->rack,
														Rent->True,
														Name->(ToString[rack]<>" destination rack")
													],
													Null
												]
											],
											ObjectP[Model[Container]]|{_Integer, ObjectP[Model[Container]]},
											Module[{destinationContainerModelPacket,destinationContainerModel,rack},
												destinationContainerModelPacket=If[MatchQ[destination, ObjectP[Model[Container]]],
													fetchPacketFromFastAssoc[Download[destination, Object], fastAssoc],
													fetchPacketFromFastAssoc[Download[destination[[2]], Object], fastAssoc]
												];

												destinationContainerModel=Lookup[destinationContainerModelPacket,Object];

												rack=If[MatchQ[Lookup[destinationContainerModelPacket,SelfStanding,Null],True],
													Null,
													RackFinder[destinationContainerModel]
												];

												If[MatchQ[rack,ObjectP[]]&&MatchQ[amount,MassP],
													Resource[
														Sample->rack,
														Rent->True,
														Name->(ToString[rack]<>" destination rack")
													],
													Null
												]
											],
											_,
											Null
										]
									],

									(* Are we doing a multichannel transfer? If so, we will have multiple wells and multiple tips. *)
									If[MatchQ[Lookup[options, MultichannelTransferName], Null],
										Sequence@@{
											MultichannelTransfer-> {False},
											SourceWell-> {Lookup[options, SourceWell]},
											DestinationWell->{Lookup[options, DestinationWell]},
											(* add in special case of when we need a Model[Item,Consumable] tip with a GraduatedCylinder to Volumetric Flask transfer in FillToVolume *)
											Tips-> {If[MatchQ[Lookup[options, Tips],ObjectP[Model[Item,Consumable]]|ObjectP[Object[Item,Consumable]]],
												Resource[
													Sample->Lookup[options, Tips],
													Name->CreateUUID[]
												],
												popTipResource[Lookup[options, Tips]]
											]},
											TipType-> {Lookup[options, TipType]},
											TipMaterial-> {Lookup[options, TipMaterial]}
										},
										Sequence@@{
											MultichannelTransfer-> True,
											SourceWell-> Lookup[multichannelNameToSourceWells, Lookup[options, MultichannelTransferName]],
											DestinationWell-> Lookup[multichannelNameToDestinationWells, Lookup[options, MultichannelTransferName]],
											Tips-> popTipResource /@ Lookup[multichannelNameToTips, Lookup[options, MultichannelTransferName]],
											TipType-> Lookup[options, TipType],
											TipMaterial-> Lookup[options, TipMaterial],
											NumberOfMultichannelTips-> Length[Lookup[multichannelNameToSourceWells, Lookup[options, MultichannelTransferName]]]
										}
									],

									HandlingCondition->Link[Lookup[options, HandlingCondition]],
									TransferEnvironment-> transferEnvironmentResource,
									CapRacks -> capRackResourcesForBSC,
									Instrument->Switch[Lookup[options, Instrument],
										(* These can be shared between transfers -- we'll tell operators to wipe down the spatulas. *)
										ObjectP[sharedInstrumentTypes],
										Lookup[sharedInstrumentResources, Download[Lookup[options, Instrument], Object]],
										ObjectP[{Model[Container, Syringe], Object[Container, Syringe], Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}],
										Lookup[instrumentAndSourceToResource, Key[{source /. {x:LinkP[]|PacketP[] :> Download[x, Object]}, Download[Lookup[options, Instrument], Object]}]],
										(* Otherwise, make a unique resource -- we will not share in between transfers. *)
										ObjectP[{Model[Instrument], Object[Instrument]}],
										Resource[
											Instrument->Lookup[options, Instrument],
											Name->CreateUUID[]
										],
										ObjectP[{Model[Item,Spatula], Object[Item,Spatula]}],
										Which[
											MemberQ[reusableSpatulas,Download[Lookup[options,Instrument],Object]],
												Lookup[reusableSpatulaResources, Download[Lookup[options,Instrument],Object]],
											MemberQ[countedSpatulas,Download[Lookup[options,Instrument],Object]],
												Lookup[countedSpatulaResources, Download[Lookup[options,Instrument],Object]],
											(* For non-counted OR reusable spatula with cleaning method, create individual resource *)
											True,
												Resource[
													Sample -> Download[Lookup[options,Instrument],Object],
													Name->CreateUUID[],
													Rent->If[MatchQ[Lookup[options, Instrument],ObjectP[Model[Item]]],
														MatchQ[fastAssocLookup[fastAssoc, Lookup[options, Instrument], Reusable],True],
														MatchQ[Lookup[fastAssocPacketLookup[fastAssoc,Lookup[options, Instrument],Model],Reusable,Null],True]
													]
												]
										],
										ObjectP[],
										Resource[
											Sample->Lookup[options, Instrument],
											Name->CreateUUID[]
										],
										_,
										Null
									],
									Balance-> balanceResource,
									BalancePreCleaningMethod->Lookup[options,BalancePreCleaningMethod],
									BalanceCleaningMethod->Lookup[options,BalanceCleaningMethod],
									TabletCrusher->If[MatchQ[Lookup[options, TabletCrusher], ObjectP[]],
										pillCrusherResource,
										Null
									],
									TabletCrusherBag->If[MatchQ[Lookup[options, TabletCrusher], ObjectP[]],
										Resource[
											Sample -> Model[Item, TabletCrusherBag, "id:WNa4ZjK6menE"],
											Name -> CreateUUID[],
											Amount -> 1 Unit
										],
										Null
									],
									IncludeSachetPouch -> Lookup[options, IncludeSachetPouch],
									SachetIntermediateContainer -> sachetIntermediateContainerResource,
									ReversePipetting-> Lookup[options, ReversePipetting],
									AspirationLayer-> Lookup[options, AspirationLayer],
									DisplayedAspirationLayer->If[MatchQ[Lookup[options, AspirationLayer], Null],
										"",
										"Place the needle/pipette into layer "<>ToString[Lookup[options, AspirationLayer]]<>" (counting from the top of the source container before any aspiration). If the layers in this sample are not clearly defined, aspirate from the top of the sample if the intended layer is the first layer, otherwise, aspirate from the closest layer possible."
									],
									DestinationLayer-> Lookup[options, DestinationLayer],
									DisplayedDestinationLayer->If[MatchQ[Lookup[options, DestinationLayer], Null],
										"",
										"Place the needle/pipette into layer "<>ToString[Lookup[options, DestinationLayer]]<>" (counting from the top of the destination container before any dispensing). If the layers in this sample are not clearly defined, dispense into the top of the sample if the intended layer is the first layer, otherwise, dispense into the closest layer possible."
									],
									Needle->If[MatchQ[Lookup[options, Needle], ObjectP[]],
										Resource[
											Sequence @@ {Sample -> Lookup[options, Needle],
												(* if the needle is reusable, Rent it *)
												If[MatchQ[Lookup[options, Needle], Alternatives @@ reusableNeedleModels], Rent -> True, Nothing],
												Name -> CreateUUID[]}
										],
										Null
									],
									Funnel->funnelResource,

									Magnetization-> Lookup[options, Magnetization],
									MagnetizationSamples-> Flatten[{indexMatchedMagnetizationSampleResource}],
									MagnetizationRack->If[MatchQ[Lookup[options,MagnetizationRack],ObjectP[]],
										Lookup[magnetizationRackResourceLookup,Download[Lookup[options,MagnetizationRack],Object]]],
									MagnetizationTime-> Lookup[options, MagnetizationTime],
									MaxMagnetizationTime-> Lookup[options, MaxMagnetizationTime],

									WeighingContainer->weighingContainerResource,

									WeighingContainerRack->Switch[weighingContainer,
										ObjectP[Object[Container]],
										Module[{weighingContainerModelPacket,weighingContainerModel,rack},
											weighingContainerModelPacket=fastAssocPacketLookup[fastAssoc, weighingContainer, Model];

											weighingContainerModel=Lookup[weighingContainerModelPacket, Object];

											rack=If[MatchQ[Lookup[weighingContainerModelPacket,SelfStanding,Null],True],
												Null,
												RackFinder[weighingContainerModel]
											];

											If[MatchQ[rack,ObjectP[]],
												Resource[
													Sample->rack,
													Name->CreateUUID[],
													Rent->True
												],
												Null
											]
										],
										ObjectP[Model[Container]],
										Module[{weighingContainerModelPacket,weighingContainerModel,rack},
											weighingContainerModelPacket=fetchPacketFromFastAssoc[weighingContainer, fastAssoc];

											weighingContainerModel=Lookup[weighingContainerModelPacket, Object];

											rack=If[MatchQ[Lookup[weighingContainerModelPacket,SelfStanding,Null],True],
												Null,
												RackFinder[weighingContainerModel]
											];

											If[MatchQ[rack,ObjectP[]],
												Resource[
													Sample->rack,
													Name->CreateUUID[],
													Rent->True
												],
												Null
											]
										],
										_,
										Null
									],
									Tolerance->If[MatchQ[Lookup[options, Tolerance], MassP],
										Lookup[options, Tolerance],
										Null
									],
									
									HandPump->FirstOrDefault[handPumpAndAdapter, Null],
									HandPumpAdapter->LastOrDefault[handPumpAndAdapter, Null],

									HandPumpWasteContainer->If[MatchQ[Lookup[options, HandPump], ObjectP[]],
										(* NOTE: We use a single 1L beaker to collect anything left in our hand pump when we disconnect it. *)
										handPumpWasteContainerResource,
										Null
									],
									QuantitativeTransfer-> Lookup[options, QuantitativeTransfer],
									QuantitativeTransferWashSolution->If[MatchQ[Lookup[options, QuantitativeTransferWashSolution], ObjectP[]],
										Lookup[quantitativeTransferWashSolutionResources, Download[Lookup[options, QuantitativeTransferWashSolution], Object]],
										Null
									],
									QuantitativeTransferWashVolume-> Lookup[options, QuantitativeTransferWashVolume],
									QuantitativeTransferWashInstrument->If[MatchQ[Lookup[options, QuantitativeTransferWashInstrument], ObjectP[]],
										Lookup[sharedInstrumentResources, Download[Lookup[options, QuantitativeTransferWashInstrument], Object]],
										Null
									],
									QuantitativeTransferWashTips-> popTipResource[Lookup[options, QuantitativeTransferWashTips]],
									NumberOfQuantitativeTransferWashes-> Lookup[options, NumberOfQuantitativeTransferWashes],
									UnsealHermeticSource-> Lookup[options, UnsealHermeticSource],
									UnsealHermeticDestination-> Lookup[options, UnsealHermeticDestination],
									BackfillNeedle-> backfillNeedleResource,
									BackfillGas-> Lookup[options, BackfillGas],
									VentingNeedle-> ventingNeedleResource,
									TipRinse-> Lookup[options, TipRinse],
									TipRinseSolution->If[MatchQ[Lookup[options, TipRinseSolution], ObjectP[]],
										Lookup[tipRinseSolutionResources, Download[Lookup[options, TipRinseSolution], Object]],
										Null
									],
									TipRinseVolume-> Lookup[options, TipRinseVolume],
									NumberOfTipRinses-> Lookup[options, NumberOfTipRinses],
									AspirationMix-> Lookup[options, AspirationMix],
									AspirationMixType-> Lookup[options, AspirationMixType],
									NumberOfAspirationMixes-> Lookup[options, NumberOfAspirationMixes],
									DispenseMix-> Lookup[options, DispenseMix],
									DispenseMixType-> Lookup[options, DispenseMixType],
									NumberOfDispenseMixes-> Lookup[options, NumberOfDispenseMixes],
									IntermediateDecant-> Lookup[options, IntermediateDecant],
									IntermediateContainer->intermediateContainerResource,
									IntermediateFunnel-> intermediateFunnelResource,
									IntermediateDecantRecoup->Lookup[options, IntermediateDecantRecoup],
									DisplayedDecantAmountAsVolume -> If[MatchQ[roundedAmountAsVolume, All],
										"All (the entire amount of the sample)",
										(* 10% more liquid at most to be transferred into intermediate container *)
										ToString[roundedAmountAsVolume * 1.1]
									],
									SourceTemperature-> Lookup[options, SourceTemperature]/.{Cold->4 Celsius},
									SourceEquilibrationTime-> Lookup[options, SourceEquilibrationTime],
									MaxSourceEquilibrationTime-> Lookup[options, MaxSourceEquilibrationTime],
									SourceEquilibrationCheck-> Lookup[options, SourceEquilibrationCheck],
									DestinationTemperature-> Lookup[options, DestinationTemperature]/.{Cold->4 Celsius},
									DestinationEquilibrationTime-> Lookup[options, DestinationEquilibrationTime],
									MaxDestinationEquilibrationTime-> Lookup[options, MaxDestinationEquilibrationTime],
									DestinationEquilibrationCheck-> Lookup[options, DestinationEquilibrationCheck],
									CoolingTime -> Lookup[options, CoolingTime],
									SolidificationTime -> Lookup[options, SolidificationTime],
									FlameDestination -> Lookup[options, FlameDestination],
									FlameSource -> flameSourceResources,
									SourceIncubationDevice->sourceIncubator,
									DestinationIncubationDevice->destinationIncubator,
									RentDestinationContainer->Lookup[options, RentDestinationContainer],
									PipetteDialImage -> Download[pipetteDialImage, Object],
									AspirationMixPipetteDialImage -> Download[aspirationMixPipetteDialImage, Object],
									DispenseMixPipetteDialImage -> Download[dispenseMixPipetteDialImage, Object],
									GraduatedCylinderImage -> Download[graduatedCylinderImage, Object],
									SerologicalPipetteImage -> Download[serologicalPipetteImage, Object],
									IntermediateContainerImage -> Download[intermediateContainerImage, Object],
									DiscardSourceContainerAndCover -> discardSource,
									AllowSourceContainerReCover -> Lookup[options, AllowSourceContainerReCover],
									OverdrawVolume -> Lookup[myResolvedOptions, OverdrawVolume],
									OverdrawVolumeWasteContainer -> overdrawVolumeContainerResource,
									WasteContainer -> wasteContainerResource,
									SyringeImage -> Download[syringeImage, Object],
									CountAsPassage -> Lookup[options, CountAsPassage],
									WeightStabilityDuration -> Lookup[options, WeightStabilityDuration],
									MaxWeightVariation -> Lookup[options, MaxWeightVariation],
									TareWeightStabilityDuration -> Lookup[options, TareWeightStabilityDuration],
									MaxTareWeightVariation -> Lookup[options, MaxTareWeightVariation]
								}
							]
						]
					],
					{
						combinedSources,
						combinedDestinations,
						combinedAmounts,
						combinedAmountsRounded,
						combinedAmountsAsVolume,
						sourceResources,
						transferEnvironmentResources,
						balanceResources,
						backfillNeedleResources,
						ventingNeedleResources,
						intermediateContainerResources,
						indexMatchedMagnetizationSampleResources,
						combinedMapThreadFriendlyOptions,
						sourceIncubators,
						destinationIncubators,
						weighingContainerResources,
						destinationContainerResources,
						pipetteDialImages,
						aspirationMixPipetteDialImages,
						dispenseMixPipetteDialImages,
						graduatedCylinderImages,
						serologicalPipetteImages,
						intermediateContainerImages,
						discardSources,
						sachetIntermediateContainerResources,
						funnelResources,
						intermediateFunnelResources,
						syringeImages,
						sharedHandPumpAndAdapterResources
					}
				],
				UnitOperationType->Batched,
				Preparation->Manual,
				FastTrack->True,
				Upload->False
			];


			(* Figure out which resources we shouldn't pick up front. Right now, these only include pipettes and pipette tips *)
			(* if we're in the BSC/glove box since we stash pipettes in these transfer environments. *)
			(* NOTE: We do this at experiment time to try to avoid any un-linking of resources at experiment time. *)
			(* This can be a little inaccurate since things can change between experiment and procedure time but generally, *)
			(* we don't expect the types of pipettes to change. Additionally, the operator is still given free-reign to *)
			(* pick whatever they want so they can still pick something from the VLM if there aren't enough stashed in the box. *)

			(* Figure out what pipette objects and models are available in each of the transfer environments that we have. *)
			availablePipetteObjectsAndModels=Map[
				Function[{transferEnvironment},
					(* Figure out what pipette objects/models are available in our transfer environment. *)
					Download[transferEnvironment, Object]->Switch[Download[transferEnvironment, Object],
						ObjectP[{Object[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, BiosafetyCabinet]}],
							Module[{transferEnvironmentObjectPacket, allPipetteObjects},
								(* Get the packet for the transfer environment. *)
								transferEnvironmentObjectPacket=fetchPacketFromFastAssoc[transferEnvironment, fastAssoc];

								(* Get all pipette objects. *)
								allPipetteObjects=Cases[
									Lookup[transferEnvironmentObjectPacket, Pipettes],
									ObjectP[Object[Instrument, Pipette]]
								];

								(* Include all objects and models. *)
								Download[
									Flatten[{
										allPipetteObjects,
										(Lookup[fetchPacketFromFastAssoc[#, fastAssoc], Model]&)/@allPipetteObjects
									}],
									Object
								]
							],
						ObjectP[{Model[Instrument, HandlingStation, GloveBox], Model[Instrument, HandlingStation, BiosafetyCabinet]}],
							Module[{transferEnvironmentModelPacket, transferEnvironmentObjectsPacket,allPipetteObjects},
								(* Get the packet for the transfer environment. *)
								transferEnvironmentModelPacket=fetchPacketFromFastAssoc[transferEnvironment, fastAssoc];
								transferEnvironmentObjectsPacket=(fetchPacketFromFastAssoc[#, fastAssoc]&)/@Lookup[transferEnvironmentModelPacket,Objects];

								(* Get all pipette objects. *)
								allPipetteObjects=Cases[
									Flatten[(Lookup[#, Pipettes]&)/@transferEnvironmentObjectsPacket],
									ObjectP[Object[Instrument, Pipette]]
								];

								(* Include all objects and models. *)
								Download[
									Flatten[{
										allPipetteObjects,
										(Lookup[fetchPacketFromFastAssoc[#, fastAssoc], Model]&)/@allPipetteObjects
									}],
									Object
								]
							],
						_,
							{}
					]
				],
				DeleteDuplicates[Flatten[Download[Lookup[myResolvedOptions, EquivalentTransferEnvironments], Object]]]
			];

			(* These are the resources that should not be put into RequiredInstruments/Objects to be picked up front. *)
			resourcesNotToPickUpFront=Flatten@Join[
				(* Never pick our transfer environments up front. *)
				Cases[transferEnvironmentResources,_Resource,All],
				(* Never pick our balances up front. *)
				Cases[balanceResources,_Resource,All],
				(* If we have a BSC or glove box transfer environment, do not pick the pipette (and corresponding pipette tips) up front *)
				(* if we think that we can fulfill it from the stash inside of the box. *)
				MapThread[
					Function[{transferPacket, transferEnvironments},
						If[MemberQ[transferEnvironments, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox], Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
							Module[{availablePipettes},
								availablePipettes=Flatten[Lookup[availablePipetteObjectsAndModels, Download[transferEnvironments, Object]]];
								{
									(* Aspirators permanently live in the BSCs. *)
									If[MatchQ[Lookup[transferPacket, Replace[InstrumentLink]][[1]], Resource[KeyValuePattern[Instrument->ObjectP[{Object[Instrument, Aspirator], Model[Instrument, Aspirator]}]]]],
										Lookup[transferPacket, Replace[InstrumentLink]][[1]],
										Nothing
									],

									(* If the pipette objects/models live in the BSC, we SHOULD have corresponding tips in there as well -- *)
									(* they're refilled via a maintenance. If not, we just ask operators to grab stuff on the fly out of the VLM. *)
									If[
										And[
											MatchQ[Lookup[transferPacket, Replace[InstrumentLink]][[1]], Resource[KeyValuePattern[Instrument->ObjectP[{Object[Instrument, Pipette], Model[Instrument, Pipette]}]]]],
											MemberQ[availablePipettes, ObjectP[Lookup[Lookup[transferPacket, Replace[InstrumentLink]][[1]][[1]], Instrument]]]
										],
										{
											Lookup[transferPacket, Replace[InstrumentLink]],
											Lookup[transferPacket, Replace[Tips]]
										},
										Nothing
									],

									(* Same logic here for the quantitative transfer pipette/tip. *)
									If[
										And[
											MatchQ[Lookup[transferPacket, Replace[QuantitativeTransferWashInstrument]][[1]], Resource[KeyValuePattern[Instrument->ObjectP[{Object[Instrument, Pipette], Model[Instrument, Pipette]}]]]],
											MemberQ[availablePipettes, ObjectP[Lookup[Lookup[transferPacket, Replace[QuantitativeTransferWashInstrument]][[1]][[1]], Instrument]]]
										],
										{
											Lookup[transferPacket, Replace[QuantitativeTransferWashInstrument]],
											Lookup[transferPacket, Replace[QuantitativeTransferWashTips]]
										},
										Nothing
									]
								}
							],
							Nothing
						]
					],
					{transferManualUnitOperationPackets, Flatten[splitTransferEnvironments, 1]}
				],
				(* don't pick the portable heaters or coolers up front *)
				Cases[Flatten[{sourceIncubators,destinationIncubators}],_Resource],
				(* if InSitu -> True, don't pick up the source or destination containers *)
				If[TrueQ[Lookup[myResolvedOptions, InSitu]],
					Cases[Flatten[{sourceResources, destinationContainerResources}], _Resource],
					{}
				]
			];

			(* get all the resources requested by the batchd UO, this is index matched to transferManualUnitOperationPackets *)
			(* return a list of tuples structured as { 1. ones we can potentially find in the local cache, 2. ones that we cannot, so need to be picked upfront, 3. all resources used by this unit operation} *)
			transferManualUnitOperationRequiredResourceTuples = MapThread[
				Function[{unitOperationPacket, transferEnvironments},
					Module[{allResourceSamples, allResourceSamplesToPick, localCacheContents, localCacheModelTypes, grouped},
						(* get all resources *)
						allResourceSamples = Cases[
							DeleteDuplicates[Cases[Normal[{unitOperationPacket}], _Resource, Infinity]],
							Resource[KeyValuePattern[Type -> Object[Resource, Sample]]]
						];

						(* excluding the resources that we should not pick upfront *)
						allResourceSamplesToPick = DeleteCases[allResourceSamples, Alternatives @@ resourcesNotToPickUpFront];

						(* get local cache, if multiple instrument models can be selected, do a union of all local cache contents *)
						localCacheContents = Flatten[
							Map[
								If[MatchQ[#, ObjectP[Model[Instrument]]], fastAssocLookup[fastAssoc, #, LocalCacheContents], fastAssocLookup[fastAssoc, #, {Model, LocalCacheContents}]]&,
								transferEnvironments
							],
							1
						];
						localCacheModelTypes = DeleteDuplicates[Download[localCacheContents[[All, 1]], Object]];

						grouped = GroupBy[allResourceSamplesToPick, MatchQ[#, Resource[KeyValuePattern[Sample -> ObjectP[localCacheModelTypes]]]]&];

						(* return the resources that can be found in local cache (True), the ones that cannot (False), and all resources requested by the current unit operation *)
						{Lookup[grouped, True, {}], Lookup[grouped, False, {}], allResourceSamples}
					]
				],
				{transferManualUnitOperationPackets, Flatten[splitTransferEnvironments, 1]}
			];

			(* Return our final protocol packet. *)
			manualProtocolPacket=<|
				Object->CreateID[Object[Protocol, Transfer]],

				Replace[Destinations]->expandCombinedList[destinationContainerResources],
				Replace[Amounts]->(myAmounts/.{All->Null}),
				Replace[SourceWells]->Lookup[myResolvedOptions, SourceWell],
				Replace[TransferEnvironments]->expandCombinedList[transferEnvironmentResources],
				Replace[Instruments]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[InstrumentLink], Null])],
				Replace[SterileTechnique]->Lookup[myResolvedOptions, SterileTechnique],
				Replace[RNaseFreeTechnique]->Lookup[myResolvedOptions, RNaseFreeTechnique],
				Replace[CountAsPassages] -> Lookup[myResolvedOptions, CountAsPassage],
				Replace[Balances]->expandCombinedList[balanceResources],
				Replace[BalancePreCleaningMethod]->Lookup[myResolvedOptions,BalancePreCleaningMethod],
				Replace[BalanceCleaningMethods]->Lookup[myResolvedOptions,BalanceCleaningMethod],
				Replace[TabletCrushers]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[TabletCrusher], Null])],
				Replace[TabletCrusherBags]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[TabletCrusherBag], Null])],
				Replace[IncludeSachetPouches] -> expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[IncludeSachetPouch], Null])],
				Replace[SachetIntermediateContainers]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[SachetIntermediateContainer], Null])],
				Replace[Tips]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[Tips], Null])],
				Replace[MultichannelTransfer]->Lookup[myResolvedOptions, MultichannelTransfer],
				Replace[TipTypes]->Lookup[myResolvedOptions, TipType],
				Replace[TipMaterials]->Lookup[myResolvedOptions, TipMaterial],
				Replace[ReversePipetting]->Lookup[myResolvedOptions, ReversePipetting],
				Replace[Supernatant]->Lookup[myResolvedOptions, Supernatant],
				Replace[AspirationLayers]->Lookup[myResolvedOptions, AspirationLayer],
				Replace[DestinationLayers]->Lookup[myResolvedOptions, DestinationLayer],
				Replace[Needles]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[Needle], Null])],
				Replace[Funnels]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[Funnel], Null])],
				Replace[WeighingContainers]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[WeighingContainerLink], Null])],
				Replace[Magnetization]->Lookup[myResolvedOptions, Magnetization],
				Replace[MagnetizationRack]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[MagnetizationRack], Null])],
				Replace[MagnetizationTimes]->Lookup[myResolvedOptions, MagnetizationTime],
				Replace[MaxMagnetizationTimes]->Lookup[myResolvedOptions, MaxMagnetizationTime],
				Replace[Tolerances]->Lookup[myResolvedOptions, Tolerance],
				Replace[HandPumps]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[HandPump], Null])],
				Replace[HandPumpAdapters]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[HandPumpAdapters], Null])],
				Replace[QuantitativeTransfer]->Lookup[myResolvedOptions, QuantitativeTransfer],
				Replace[QuantitativeTransferWashSolutions]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[QuantitativeTransferWashSolution], Null])],
				Replace[QuantitativeTransferWashVolumes]->Lookup[myResolvedOptions, QuantitativeTransferWashVolume],
				Replace[QuantitativeTransferWashInstruments]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[QuantitativeTransferWashInstrument], Null])],
				Replace[QuantitativeTransferWashTips]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[QuantitativeTransferWashTips], Null])],
				Replace[NumberOfQuantitativeTransferWashes]->Lookup[myResolvedOptions, NumberOfQuantitativeTransferWashes],
				Replace[UnsealHermeticSources]->Lookup[myResolvedOptions, UnsealHermeticSource],
				Replace[UnsealHermeticDestinations]->Lookup[myResolvedOptions, UnsealHermeticDestination],
				Replace[BackfillNeedles]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[BackfillNeedle], Null])],
				Replace[BackfillGas]->Lookup[myResolvedOptions, BackfillGas],
				Replace[VentingNeedles]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[VentingNeedle], Null])],
				Replace[TipRinse]->Lookup[myResolvedOptions, TipRinse],
				Replace[TipRinseSolutions]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[TipRinseSolution], Null])],
				Replace[TipRinseVolumes]->Lookup[myResolvedOptions, TipRinseVolume],
				Replace[NumberOfTipRinses]->Lookup[myResolvedOptions, NumberOfTipRinses],
				Replace[AspirationMix]->Lookup[myResolvedOptions, AspirationMix],
				Replace[AspirationMixTypes]->Lookup[myResolvedOptions, AspirationMixType],
				Replace[NumberOfAspirationMixes]->Lookup[myResolvedOptions, NumberOfAspirationMixes],
				Replace[MaxNumberOfAspirationMixes]->Lookup[myResolvedOptions, MaxNumberOfAspirationMixes],
				Replace[AspirationMixVolumes]->Lookup[myResolvedOptions, AspirationMixVolume],
				Replace[DispenseMix]->Lookup[myResolvedOptions, DispenseMix],
				Replace[DispenseMixTypes]->Lookup[myResolvedOptions, DispenseMixType],
				Replace[NumberOfDispenseMixes]->Lookup[myResolvedOptions, NumberOfDispenseMixes],
				Replace[DispenseMixVolumes]->Lookup[myResolvedOptions, DispenseMixVolume],
				Replace[IntermediateDecant]->Lookup[myResolvedOptions, IntermediateDecant],
				Replace[IntermediateContainers]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[IntermediateContainerLink], Null])],
				Replace[IntermediateFunnels]->expandCombinedList[Flatten@(FirstOrDefault/@Lookup[transferManualUnitOperationPackets, Replace[IntermediateFunnel], Null])],
				WasteContainer->wasteContainerResource,
				Replace[SourceTemperatures]->(Lookup[myResolvedOptions, SourceTemperature]/.{Ambient->25 Celsius, Cold->4 Celsius}),
				Replace[SourceEquilibrationTimes]->Lookup[myResolvedOptions, SourceEquilibrationTime],
				Replace[MaxSourceEquilibrationTimes]->Lookup[myResolvedOptions, MaxSourceEquilibrationTime],
				Replace[SourceEquilibrationCheck]->Lookup[myResolvedOptions, SourceEquilibrationCheck],
				Replace[DestinationTemperatures]->(Lookup[myResolvedOptions, DestinationTemperature]/.{Ambient->25 Celsius, Cold->4 Celsius}),
				Replace[DestinationEquilibrationTimes]->Lookup[myResolvedOptions, DestinationEquilibrationTime],
				Replace[MaxDestinationEquilibrationTimes]->Lookup[myResolvedOptions, MaxDestinationEquilibrationTime],
				Replace[DestinationEquilibrationCheck]->Lookup[myResolvedOptions, DestinationEquilibrationCheck],
				Replace[SolidificationTime]->Lookup[myResolvedOptions,SolidificationTime],
				Replace[FlameDestination]->Lookup[myResolvedOptions,FlameDestination],
				Replace[FlameSource]->FirstCase[Lookup[transferManualUnitOperationPackets, FlameSource], Except[Null], Null],
				Replace[LivingDestinations]->Lookup[myResolvedOptions, LivingDestination],
				Replace[KeepSourceCovered] -> Lookup[myResolvedOptions, KeepSourceCovered],
				Replace[ReplaceSourceCovers] -> Lookup[myResolvedOptions, ReplaceSourceCover],
				Replace[SourceCovers] -> Lookup[myResolvedOptions, SourceCover],
				Replace[SourceSeptums] -> Lookup[myResolvedOptions, SourceSeptum],
				Replace[SourceStoppers] -> Lookup[myResolvedOptions, SourceStopper],
				Replace[KeepDestinationCovered] -> Lookup[myResolvedOptions, KeepDestinationCovered],
				Replace[ReplaceDestinationCovers] -> Lookup[myResolvedOptions, ReplaceDestinationCover],
				Replace[DestinationCovers] -> Link[Lookup[myResolvedOptions, DestinationCover]],
				Replace[DestinationSeptums] -> Link[Lookup[myResolvedOptions, DestinationSeptum]],
				Replace[DestinationStoppers] -> Link[Lookup[myResolvedOptions, DestinationStopper]],

				Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@Lookup[transferManualUnitOperationPackets, Object],
				Replace[Checkpoints]->{
					{"Picking Resources",15*Minute,"Samples and plates required to execute this protocol are gathered from storage and stock solutions are freshly prepared.",Link[Resource[Operator -> $BaselineOperator, Time -> 15*Minute]]},
					{"Performing Transfers",5*Minute*Length[transferManualUnitOperationPackets],"The transfers are performed.",Link[Resource[Operator -> $BaselineOperator, Time -> (5*Minute*Length[transferManualUnitOperationPackets])]]},
					{"Returning Materials",15*Minute,"Samples are returned to storage.",Link[Resource[Operator -> $BaselineOperator, Time -> 15*Minute]]}
				},

				Author->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],Null],
					Link[$PersonID,ProtocolsAuthored]
				],
				ParentProtocol->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],ObjectP[ProtocolTypes[]]],
					Link[Lookup[myResolvedOptions, ParentProtocol],Subprotocols]
				],

				UnresolvedOptions->RemoveHiddenOptions[ExperimentTransfer,myTemplatedOptions],
				ResolvedOptions->myResolvedOptions,

				Name->Lookup[myResolvedOptions, Name],

				Replace[Amounts]->(myAmounts/.{All->Null, count:CountP:>(count*Unit)}),

				(* NOTE: These are all resource picked at once so that we can minimize trips to the VLM -- EXCEPT for resources that live in other transfer environments *)
				(* like the BSC or glove box. *)
				Replace[RequiredObjects] -> DeleteDuplicates[Flatten[transferManualUnitOperationRequiredResourceTuples[[All, 2]]]],
				(* NOTE: We pick all of our instruments at once -- make sure to not include transfer environment instruments like *)
				(* the glove box or BSC. *)
				Replace[RequiredInstruments] -> DeleteCases[
					DeleteDuplicates[
						Cases[
							Cases[Normal[transferManualUnitOperationPackets], _Resource, Infinity],
							Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]]
						]
					],
					(* also do not pick these types as we should have some stock in the handling station local cache, so operator can find them easily after selecting a handling station *)
					Alternatives @@ resourcesNotToPickUpFront
				],

				Replace[OrdersFulfilled] -> Link[Cases[ToList[Lookup[myResolvedOptions, OrderFulfilled]], ObjectP[Object[Transaction, Order]]], Fulfillment],
				Replace[PreparedResources] -> Link[Lookup[myResolvedOptions, PreparedResources], Preparation],

				KeepInstruments->Lookup[myResolvedOptions, KeepInstruments],
				(* NOTE: These are usually uploaded by populateSamplePrepFields. *)
				ImageSample -> Lookup[myResolvedOptions, ImageSample],
				MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
				Replace[SamplesInStorage] -> Lookup[myResolvedOptions, SamplesInStorageCondition],
				Replace[SamplesOutStorage] -> Lookup[myResolvedOptions, SamplesOutStorageCondition]
			|>;

			(* for each batched UO, update the RequiredObjects *)
			transferManualUnitOperationPacketsWithRequiredObjects = Module[{packetsWithRequiredObjects},
				(* populate RequiredObjects for each unit operations, only excluding the resources that have been previously picked *)
				packetsWithRequiredObjects = MapThread[
					Function[{packet, currentResourceSamples, previousResourceSamples},
						Append[
							packet,
							<|
								Replace[RequiredObjects] -> DeleteDuplicates[Complement[currentResourceSamples, previousResourceSamples]]
							|>
						]
					],
					{
						transferManualUnitOperationPackets,
						(* this is the resource that we should be able to find in the local cache *)
						transferManualUnitOperationRequiredResourceTuples[[All, 1]],
						(* use FoldList to get all requested resources before current UO *)
						Most[FoldList[Append, {}, transferManualUnitOperationRequiredResourceTuples[[All, 3]]]]
					}
				];
				
				(* do a second round now for BSC/GloveBox, we populate the RequiredObjects for the first UO with all objects that are to be used by the following UOs that shared the same transfer environment, to minimize number of times op need to setup the instrument *)
				Flatten[MapThread[
					Function[{groupedPackets, groupedTransferEnvironments},
						(* for BSC/GloveBox, lets we populate the RequiredObjects for the first UO with all objects that are to be used by the following UOs that shared the same transfer environment *)
						If[MatchQ[First[groupedTransferEnvironments], {ObjectP[{Object[Instrument, HandlingStation, BiosafetyCabinet], Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, GloveBox], Model[Instrument, HandlingStation, GloveBox]}]..}],
							Module[{allRequiredObjects},
								allRequiredObjects = Flatten[Lookup[groupedPackets, Replace[RequiredObjects]]];
								{
									Append[First[groupedPackets], <|Replace[RequiredObjects] -> allRequiredObjects|>],
									Sequence @@ (Append[#, <|Replace[RequiredObjects] -> {}|>]& /@ Rest[groupedPackets])
								}
							],
							(* we still pick the required objects needed for the current UO for fumehood or ambient handling stations, no need to group here *)
							groupedPackets
						]
					],
					{
						TakeList[packetsWithRequiredObjects, Length /@ splitTransferEnvironments],
						splitTransferEnvironments
					}

				]]
			];

			(* Return our protocol packet and unit operation packets. *)
			{manualProtocolPacket, transferManualUnitOperationPacketsWithRequiredObjects, Cases[Flatten[{pipetteDialImages, aspirationMixPipetteDialImages, dispenseMixPipetteDialImages, graduatedCylinderImages, syringeImages}], PacketP[]]}
		],
		Module[
			{sourceResources, sourceSampleResources, destinationResources, destinationSampleResources, uniqueCollectionContainersToResourcesLookup,
				collectionContainerResources, tipResources, transferUnitOperationPacket, transferUnitOperationPacketWithLabeledObjects,
				tipAdapterResource},

			(* Create resources for our sources. *)
			sourceResources=MapThread[
				Function[{source,index},
					Switch[source,
						ObjectP[Model[Sample]],
							Lookup[sourceSampleModelResources,index],
						ObjectP[Object[Sample]],
							Module[{container},
								container=fastAssocLookup[fastAssoc, source, {Container, Object}];

								(* If we don't have a container (sample is discarded), make a resource for the sample and VRQ will throw an error. *)
								If[!MatchQ[container, ObjectP[]],
									Resource[
										Sample->Download[source, Object],
										Name->Download[source, ID]
									],
									Resource[
										Sample->container,
										Name->fastAssocLookup[fastAssoc, container, ID]
									]
								]
							]
							,
						ObjectP[Object[Container]],
							Resource[
								Sample->Download[source, Object],
								Name->Download[source, ID]
							],
						{_Integer, ObjectP[Model[Container]]},
							Lookup[specifiedIntegerContainerModelResources, Key[source/.{link_Link:>Download[link, Object]}]],
						{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
							Resource[
								Sample->Download[source[[2]], Object],
								Name->Download[source[[2]], ID]
							]
					]
				],
				{mySources,Range[Length[mySources]]}
			];

			(* NOTE: We only use this for LabeledObjects. *)
			sourceSampleResources=MapThread[
				Function[{source, position, index},
					Switch[source,
						ObjectP[Model[Sample]],
							Lookup[sourceSampleModelResources, index],
						ObjectP[Object[Sample]],
							Resource[
								Sample->Download[source, Object],
								Name->Download[source, ID]
							],
						ObjectP[Object[Container]],
							Module[{contents, sourceSample, sourceSamplePacket},
								contents = fastAssocLookup[fastAssoc, source, Contents];
								(* {Null, Null} so that we end up with Null when we do [[2]] *)
								sourceSample = SelectFirst[contents, MatchQ[#[[1]], position]&, {Null, Null}][[2]];
								sourceSamplePacket = fetchPacketFromFastAssoc[sourceSample, fastAssoc];

								If[MatchQ[sourceSamplePacket, ObjectP[Object[Sample]]],
									Resource[
										Sample->Lookup[sourceSamplePacket, Object],
										Name->Lookup[sourceSamplePacket, ID]
									],
									Resource[
										Sample->Download[source, Object],
										Name->Download[source, ID]
									]
								]
							],
						{_Integer, ObjectP[Model[Container]]},
							Lookup[specifiedIntegerContainerModelResources, Key[source/.{link_Link:>Download[link, Object]}]],
						{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
							Module[{contents, sourceSample, sourceSamplePacket},
								contents = fastAssocLookup[fastAssoc, source[[2]], Contents];
								(* {Null, Null} so that we end up with Null when we do [[2]] *)
								sourceSample = SelectFirst[contents, MatchQ[#[[1]], position]&, {Null, Null}][[2]];
								sourceSamplePacket = fetchPacketFromFastAssoc[sourceSample, fastAssoc];

								If[MatchQ[sourceSamplePacket, ObjectP[Object[Sample]]],
									Resource[
										Sample->Lookup[sourceSamplePacket, Object]
									],
									Resource[
										Sample->Download[source[[2]], Object],
										Name->Download[source[[2]], ID]
									]
								]
							]
					]
				],
				{mySources, Lookup[myResolvedOptions, SourceWell], Range[Length[mySources]]}
			];


			(* Make resources for our destination samples. *)
			destinationResources=MapThread[
				Function[{destination,rentQ},
					Switch[destination,
						ObjectP[Object[Sample]],
							Resource[
								Sample -> fastAssocLookup[fastAssoc, destination, {Container, Object}],
								Name -> fastAssocLookup[fastAssoc, destination, {Container, ID}]
							],
						ObjectP[Object[Item]],
							Resource[
								Sample->Download[destination, Object],
								Name->Download[destination, Object]
							],
						ObjectP[Object[Container]],
							Resource[
								Sample->Download[destination, Object],
								Name->Download[destination, ID]
							],
						ObjectP[Model[Container]],
							Resource[
								Sample->Download[destination, Object],
								Name->CreateUUID[],
								Rent->TrueQ[rentQ]
							],
						{_Integer, ObjectP[Model[Container]]},
							Lookup[specifiedIntegerContainerModelResources, Key[destination/.{link_Link:>Download[link, Object]}]],
						{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
							Resource[
								Sample->Download[destination[[2]], Object],
								Name->Download[destination[[2]], ID]
							],
						(* NOTE: This shouldn't be possible in Preparation->Robotic but just include it. *)
						Waste,
							Waste
					]
				],
				{myDestinations,resourceRentContainerBools}
			];

			(* NOTE: We only use this for LabeledObjects. *)
			destinationSampleResources=MapThread[
				Function[{destination, position,rentQ},
					Switch[destination,
						ObjectP[Object[Sample]],
							Resource[
								Sample -> Download[destination, Object],
								Name -> Download[destination, ID]
							],
						ObjectP[Object[Item]],
							Resource[
								Sample->Download[destination, Object],
								Name->Download[destination, Object]
							],
						ObjectP[Object[Container]],
							Module[{destinationSamplePacket, contents, destinationSample},
								contents = fastAssocLookup[fastAssoc, destination, Contents];
								(* {Null, Null} so that we end up with Null when we do [[2]] *)
								destinationSample = SelectFirst[contents, MatchQ[#[[1]], position]&, {Null, Null}][[2]];
								destinationSamplePacket = fetchPacketFromFastAssoc[destinationSample, fastAssoc];

								If[MatchQ[destinationSamplePacket, ObjectP[Object[Sample]]],
									Resource[
										Sample->Lookup[destinationSamplePacket, Object],
										Name->Lookup[destinationSamplePacket, ID]
									],
									Resource[
										Sample->Download[destination, Object],
										Name->Download[destination, ID]
									]
								]
							],
						ObjectP[Model[Container]],
							Resource[
								Sample->Download[destination, Object],
								Name->CreateUUID[],
								Rent->TrueQ[rentQ]
							],
						{_Integer, ObjectP[Model[Container]]},
							Lookup[specifiedIntegerContainerModelResources, Key[destination/.{link_Link:>Download[link, Object]}]],
						{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
							Module[{destinationSamplePacket, contents, destinationSample},
								contents = fastAssocLookup[fastAssoc, destination[[2]], Contents];
								(* {Null, Null} so that we end up with Null when we do [[2]] *)
								destinationSample = SelectFirst[contents, MatchQ[#[[1]], position]&, {Null, Null}][[2]];
								destinationSamplePacket = fetchPacketFromFastAssoc[destinationSample, fastAssoc];

								If[MatchQ[destinationSamplePacket, ObjectP[Object[Sample]]],
									Resource[
										Sample->Lookup[destinationSamplePacket, Object],
										Name->Lookup[destinationSamplePacket, ID]
									],
									Resource[
										Sample->Download[destination[[2]], Object],
										Name->Download[destination[[2]], ID]
									]
								]
							],
						(* NOTE: This shouldn't be possible in Preparation->Robotic but just include it. *)
						Waste,
							Waste
					]
				],
				{myDestinations, Lookup[myResolvedOptions, DestinationWell],resourceRentContainerBools}
			];

			(* Make resources for our collection containers. *)
			uniqueCollectionContainersToResourcesLookup = Map[
				Function[{collectionContainer},
					collectionContainer->Switch[collectionContainer,
						ObjectP[Object[Container]],
							Resource[Sample->collectionContainer, Name->Download[collectionContainer, ID]],
						ObjectP[Model[Container]],
							Resource[Sample->collectionContainer, Name->CreateUUID[]],
						{_Integer, ObjectP[Model[Container]]},
							Resource[Sample->collectionContainer[[2]], Name->CreateUUID[]],
						_,
							Null
					]
				],
				Lookup[myResolvedOptions, CollectionContainer]
			];
			collectionContainerResources=Lookup[myResolvedOptions, CollectionContainer]/.uniqueCollectionContainersToResourcesLookup;

			(* Make tip resources for our Tips option. *)
			(* NOTE: We don't have to care about the NumberOfTips in each tip box because the framework will deal with this for us. *)
			(* Create resources for all of the tips (both the regular Tips and the QuantitativeTransferWashTips). *)
			(* for the MultiProbeHead we want to guarantee that the transfer will request 96 tips, so for transfers with
			 less than 96 channels used we will have the 1st resource taking up the rest of the 96-tip-stack in Amount*)
			tipResources=Flatten@Module[{transferInfoTips,gatheredTipInfo,labeledDataTuples},
				transferInfoTips=Transpose@Lookup[myResolvedOptions,{Tips,MultichannelTransferName,DeviceChannel}];
				labeledDataTuples=MapThread[Append[#1,#2]&,{transferInfoTips,Range[Length[transferInfoTips]]}];
				gatheredTipInfo=SplitBy[labeledDataTuples,#[[2]]&];
				Function[transferGroup,
					If[
						MatchQ[transferGroup[[1,3]],MultiProbeHead],
						Prepend[
							Resource[
								Sample->#,
								Amount->1,
								Name->CreateUUID[]
							]&/@transferGroup[[2;;,1]],
							Resource[
								Sample->transferGroup[[1,1]],
								Amount->96 - Length[transferGroup] + 1,
								Name->CreateUUID[]
							]],

						Resource[
							Sample->#,
							Amount->1,
							Name->CreateUUID[]
						]&/@transferGroup[[;;,1]]
					]
				]/@gatheredTipInfo
			];

			(* ,make a resource for the TipAdapter if we need it *)
			tipAdapterResource = With[{transferInfo = GatherBy[Transpose@Lookup[myResolvedOptions,{MultichannelTransferName,DeviceChannel}], First]},
				If[
					And[
						MemberQ[transferInfo, {{_,MultiProbeHead}..}],
						Min[Length/@Cases[transferInfo, {{_,MultiProbeHead}..}]]<96
					],
					Resource[
						Sample->Model[Item, "id:Y0lXejMp6aRV"], (*"Hamilton MultipProbeHead tip rack"*)
						Rent->True,
						Name->CreateUUID[]
					]
				]];

			(* Upload our UnitOperation with the Source/Destination/Tips options replaced with resources. *)
			transferUnitOperationPacket=Module[{nonHiddenTransferOptions},
				(* Only include non-hidden options from Transfer. *)
				nonHiddenTransferOptions=Lookup[
					Cases[OptionDefinition[ExperimentTransfer], KeyValuePattern["Category"->Except["Hidden"]]],
					"OptionSymbol"
				];

				UploadUnitOperation[
					Transfer@@Join[
						{
							Source->sourceResources,
							Destination->destinationResources,
							Amount->myAmounts
						},
						(* NOTE: We also allow Magnetization for robotic so we need MagnetizationRack resources here *)
						(* NOTE: We allow for MultichannelTransferName and RentDestinationContainer (developer field) since it's used in the exporter and for resource preparation *)
						ReplaceRule[
							Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenTransferOptions|MultichannelTransferName|RentDestinationContainer|LivingDestination, _]],
							{
								Tips->tipResources,
								MagnetizationRack->If[MemberQ[ToList@Lookup[myResolvedOptions,MagnetizationRack],ObjectP[]],
									Lookup[magnetizationRackResourceLookup,Download[Lookup[myResolvedOptions,MagnetizationRack],Object],Null],
									Null
								],
								PlateTilter->If[MemberQ[Lookup[myResolvedOptions, {AspirationMixType, DispenseMixType, AspirationAngle, DispenseAngle}], Tilt|GreaterP[0 AngularDegree], Infinity],
									Resource[
										Instrument->Model[Instrument, PlateTilter, "id:eGakldJkWVk4"] (* "Hamilton Plate Tilter" *),
										Name->CreateUUID[]
									],
									Null
								],
								CollectionContainer->collectionContainerResources,
								(* NOTE: Don't pass Name down. *)
								Name->Null,
								TipAdapter->tipAdapterResource,
								(* Make sure we have a temperature to work with for SourceTemperature and DestinationTemperature, if not Ambient *)
								SourceTemperature -> Lookup[myResolvedOptions, SourceTemperature]/.{Cold->4 Celsius},
								DestinationTemperature -> Lookup[myResolvedOptions, DestinationTemperature]/.{Cold->4 Celsius}
							}
						],

						(* these are the keys for the MultiProbeHead items *)
						Cases[myResolvedOptions,
							Alternatives @@(Rule[#,_]&/@{
								MultiProbeHeadNumberOfRows,
								MultiProbeHeadNumberOfColumns,
								MultiProbeAspirationOffsetRows,
								MultiProbeAspirationOffsetColumns,
								MultiProbeDispenseOffsetRows,
								MultiProbeDispenseOffsetColumns
							})]
					],
					Preparation->Robotic,
					UnitOperationType->Output,
					FastTrack->True,
					Upload->False
				]
			];

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			transferUnitOperationPacketWithLabeledObjects=Append[
				transferUnitOperationPacket,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{Lookup[myResolvedOptions, SourceLabel], sourceSampleResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{Lookup[myResolvedOptions, SourceContainerLabel], sourceResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					],

					Cases[
						Transpose[{Lookup[myResolvedOptions, DestinationLabel], destinationSampleResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{Lookup[myResolvedOptions, DestinationContainerLabel], destinationResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					]
				]
			];

			(* Return our protocol packet (we don't have one) and our unit operation packet. *)
			{Null, transferUnitOperationPacketWithLabeledObjects, {}}
		]
	];

	(* make list of all the resources we need to check in FRQ *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket], Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		MatchQ[resolvedPreparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->simulation,Cache->inheritedCache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation,Cache->inheritedCache],Null}
	];

	(* --- Output --- *)

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		{protocolPacket, unitOperationPackets, peripheralPackets},
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];

(*portableHeaterCoolerForContainer*)
portableHeaterCoolerForContainer[dimensions:{DistanceP,DistanceP,DistanceP},tempChange:(Heat|Cool),requestedTemp:TemperatureP,bscTransferQ:BooleanP]:=Module[
	{heaterPackets,coolerPackets,usableObs,bscFriendly},

	(* try to sort these by size as more appear. these are offline for speed but this should be replaced with a Search when it's necessary *)
	heaterPackets={
		<|Object -> Model[Instrument, PortableHeater,"id:3em6ZvLv7bZv"],(* "Main Lab Portable Heater"*) InternalDimensions -> {0.098425 Meter, 0.155575 Meter,0.1016 Meter}, MinTemperature -> 37 Celsius, MaxTemperature -> 105 Celsius, bscFriendly -> True|>
	};

	coolerPackets={
		(* dison coolers currently don't work *)
		(*<|Object->Model[Instrument, PortableCooler, "Main Lab Portable Cooler"], InternalDimensions -> {0.18 Meter, 0.1 Meter, 0.08 Meter}, MinTemperature -> 4 Celsius, MaxTemperature -> 25 Celsius|>,*)
		<|Object->Model[Instrument, PortableCooler,"id:R8e1PjpjnEPX"], (*"ICECO GO20 Portable Refrigerator"*) InternalDimensions -> {0.3 Meter, 0.221 Meter, 0.221 Meter}, MinTemperature -> 4 Celsius, MaxTemperature -> 25 Celsius, bscFriendly->False|>,
		<|Object->Model[Instrument, PortableCooler,"id:eGakldJdO9le"],(*"ICECO GO12"*)  InternalDimensions -> {0.3 Meter, 0.221 Meter, 0.221 Meter}, MinTemperature -> 4 Celsius, MaxTemperature -> 25 Celsius, bscFriendly->False|>,
		<|Object->Model[Instrument, PortableCooler,"id:4pO6dM5MoKdo"],(* "XtremepowerUS Portable Cooler Freezer"*) InternalDimensions -> {0.3 Meter, 0.221 Meter, 0.221 Meter}, MinTemperature -> -20 Celsius, MaxTemperature -> 25 Celsius, bscFriendly->False|>,
		<|Object->Model[Instrument, PortableCooler,"id:R8e1PjpjnEPK"],(* "LAB RepCo -40c Portable Freezer"*) InternalDimensions -> {0.332 Meter, 0.221 Meter, 0.34 Meter} MinTemperature -> -40 Celsius, MaxTemperature -> 25 Celsius, bscFriendly->False|>,
		<|Object->Model[Instrument, PortableCooler,"id:o1k9jAGAEpjr"],(* "Stirling Ultracold"*) InternalDimensions -> {0.332 Meter, 0.221 Meter, 0.34 Meter} MinTemperature -> -86 Celsius, MaxTemperature -> 25 Celsius, bscFriendly->False|>(*Todo: add portable cooling tub with bscFriendly -> True*)
	};

	(* return a list of the heaters or coolers that meet the specs *)
	usableObs=Lookup[
		Cases[
			Switch[tempChange, Heat, heaterPackets, Cool, coolerPackets],
			KeyValuePattern[{
				(* allow a tilt angle of up to 30 degrees, but don't allow laying containers sideways. this is really rough and assumes containers will typically be limited in the z dimension only *)
				InternalDimensions->_?(And[LessQ[dimensions[[1]],#[[1]]],LessQ[dimensions[[2]],#[[2]]],LessQ[Sin[Pi/3]*dimensions[[3]],#[[3]]]]&),
				Sequence@@Switch[tempChange, Heat, {MaxTemperature ->GreaterP[requestedTemp], MinTemperature ->LessP[requestedTemp]}, Cool, {MaxTemperature ->GreaterP[requestedTemp], MinTemperature ->LessP[requestedTemp]}],
				(*Force it to select a sterile heater/cooler*)
				If[bscTransferQ,bscFriendly->True,Nothing]
			}]
		],
		Object,
		{}
	];

	(* for use in this experiment we should always return a container unless we feed the function infinity.
	this just means that we don't have a portable instrument of the correct size. *)
	If[
		MatchQ[usableObs,{}] && MemberQ[dimensions, LessP[Infinity*Meter]],
		Lookup[Last[Switch[tempChange, Heat, heaterPackets, Cool, coolerPackets]],{Object}],
		usableObs
	]
];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentTransfer,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentTransfer[
	myProtocolPacket:(PacketP[Object[Protocol, Transfer], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:({PacketP[]..}|$Failed),
	mySources:{(ObjectP[{Object[Sample], Model[Sample], Object[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]})..},
	myDestinations:{(ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}|Waste)..},
	myAmounts:{(VolumeP|MassP|CountP|All)..},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentTransfer]
]:=Module[
	{
		resolvedPreparation, resolvedWorkCell, protocolObject, mapThreadFriendlyOptions, currentSimulation, simulatedUnitOperationPackets,
		simulatedSourceSamplePackets, simulation, cache, protocolType, simulatedSourceContainerPackets, simulatedDestinationSamplePackets,
		simulatedCollectionContainerPackets, simulatedDestinationContainerPackets, simulatedQuantitativeTransferWashSolutionPackets,
		fakeWaterSampleContainerObject, fakeWasteSampleContainerObject, fakeWaterAndWastePackets, fakeWaterSample, fakeWasteSample,
		existingSourceSamples, existingSourceContainers, sourceSamples, sourceContainers, destinationSamples, destinationSamplesToCreate,
		collectionContainerSamples, collectionContainerSamplesToCreate, destinationContainers, updatedPackets, simulatedSourceAndDestinationCacheWithUpdatedDestinations,
		samplesToCreatePackets, newDestinationSampleObjects, newCollectionContainerSampleObjects, uploadSampleTransferPackets,
		simulationWithLabels, simulatedSourceAndDestinationCache, combinedSources, memoizedWaterAndWasteSimulation,
		combinedDestinations, combinedAmounts, combinedMapThreadFriendlyOptions, unitOperationField, resourceFreshBools, freshSourceModels,
		combinedSourceWells, combinedDestinationWells, resolvedLivingDestination, resolvedSterileTechnique, resolvedQuantitativeTransfer,
		resolvedQuantitativeTransferWashVolumes, resolvedNumberOfQuantitativeTransferWashes, destinationSamplesAsepticUpdatePackets,
		collectionSamplesAsepticUpdatePackets
	},

	(* Lookup our resolved preparation option. *)
	{resolvedPreparation, resolvedWorkCell} = Lookup[myResolvedOptions, {Preparation, WorkCell}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* If preparation is Robotic, determine the protocol type (RCP vs. RSP) that we want to create an ID for. *)
	protocolType = If[MatchQ[resolvedPreparation, Robotic],
		Module[{experimentFunction},
			experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];
			Object[Protocol, ToExpression@StringDelete[ToString[experimentFunction], "Experiment"]]
		],
		Object[Protocol, Transfer]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = If[MatchQ[myProtocolPacket, $Failed|Null],
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		SimulateCreateID[protocolType],
		Lookup[myProtocolPacket, Object]
	];


	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentTransfer,
		myResolvedOptions
	];

	(* Lookup our Fresh option to prepare the resources. *)
	resourceFreshBools = Lookup[mapThreadFriendlyOptions, Fresh, ConstantArray[False, Length[mySources]]];

	(* Get the models that are required to be prepared Fresh *)
	freshSourceModels = DeleteDuplicates[
		Download[
			PickList[
				mySources,
				resourceFreshBools,
				True
			],
			Object
		]
	];

	(* Lookup the resolved LivingDestination, SterileTechnique as well as QuantitativeTransfer options (Will be passed to UploadSampleTransfer) *)
	{
		resolvedLivingDestination,
		resolvedSterileTechnique,
		resolvedQuantitativeTransfer,
		resolvedQuantitativeTransferWashVolumes,
		resolvedNumberOfQuantitativeTransferWashes
	} = Lookup[
		myResolvedOptions,
		{
			LivingDestination,
			SterileTechnique,
			QuantitativeTransfer,
			QuantitativeTransferWashVolume,
			NumberOfQuantitativeTransferWashes
		}
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	(* Note: In SimulateResources (in the call of UploadSample), if we are simulating a container from model for manual preparation, the cover of the container will be simulated as well *)
	currentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
			Module[{protocolPacket},
				protocolPacket=<|
					Object->protocolObject,
					Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[myUnitOperationPackets, Object],
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions->{}
				|>;

				SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> simulation]
			],

		(* Otherwise, if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
			(* NOTE: Even if our resource packets simulation failed, we're going to have to generate some shell primitive *)
			(* objects so that we can simulate the transfer samples and return them. This is NOT REQUIRED for most experiment *)
			(* functions where a shell protocol object is just fine. *)
			Module[{sourceSamplePackets, sourceModelPackets, destinationSamplePackets, sourceContainerPackets, preferredContainerPackets, simulatedCache, fastAssoc, uniqueSampleModelWithSourceIncubations, sampleModelsAmountsWithSourceIncubations, totaledSampleModelAmounts, sampleModelContainerRules, sampleModelContainers, sourceSampleModelResources, specifiedIntegerContainerModelResources, protocolPacket, simulatedPrimitiveIDs, transferUnitOperationPackets, destinationLabelToUUID},
				(* NOTE: The following is code from the resource packets function. It should be kept in sync. *)
				(* We basically just run the part of the resource packets function here that we can be sure is error-proof. *)

				(* Download containers from our sample packets. *)
				{
					sourceSamplePackets,
					sourceModelPackets,
					destinationSamplePackets,
					sourceContainerPackets,
					preferredContainerPackets
				}=Quiet[Download[
					{
						Cases[mySources, ObjectP[Object[Sample]]],
						Cases[mySources, ObjectP[Model[Sample]]],
						Cases[myDestinations, ObjectP[Object[Sample]]],
						Cases[Flatten[Lookup[myResolvedOptions, SourceContainer]], ObjectP[{Object[Container], Model[Container]}]],
						PreferredContainer[All]
					},
					{
						{Packet[Model, Container, Name, Sachet, SolidUnitWeight]},
						{Packet[State, Name, Sachet, SolidUnitWeight]},
						{Packet[Container, Name]},
						{Packet[MaxVolume,Dimensions,Aperture]},
						{Packet[MaxVolume]}
					},
					Cache -> cache,
					Simulation-> simulation
				],{Download::FieldDoesntExist}];

				(* make a cache for container information *)
				(* Add these new packets to our simulated cache so ObjectToString works correctly. *)
				simulatedCache=Flatten[{cache, sourceSamplePackets, sourceModelPackets, destinationSamplePackets, sourceContainerPackets, preferredContainerPackets}];
				fastAssoc=makeFastAssocFromCache[simulatedCache];

				(* Get the total amount of any Model[Sample]s that we were given in our source list. *)
				(* First, get the unique sample models we have. *)
				uniqueSampleModelWithSourceIncubations=Cases[
					DeleteDuplicates[
						Transpose[{
							mySources/.{link_Link:>Download[link,Object]},
							(* Get all the source incubation option values *)
							(* Note that these options are now possible Automatic. For the same Model[Sample], Automatic(s) will resolve to the same values later so this does not affect our grouping *)
							Lookup[myResolvedOptions, SourceTemperature]/.{Ambient->$AmbientTemperature, Cold->4 Celsius},
							Lookup[myResolvedOptions, SourceEquilibrationTime],
							Lookup[myResolvedOptions, MaxSourceEquilibrationTime]
						}]
					],
					{ObjectP[Model[Sample]],___}
				];

				(* Put the sample models and amounts and the source container incubation parameters together *)
				sampleModelsAmountsWithSourceIncubations=Transpose[{
					mySources/.{link_Link:>Download[link, Object]},
					(* Get all the source incubation option values *)
					Lookup[myResolvedOptions, SourceTemperature]/.{Ambient->$AmbientTemperature, Cold->4 Celsius},
					Lookup[myResolvedOptions, SourceEquilibrationTime],
					Lookup[myResolvedOptions, MaxSourceEquilibrationTime],
					myAmounts,
					(* Append an index for resource grouping (If a certain model goes beyond 200 mL for robotic (reservoir) or 20 L for manual (carboy), we will need to request multiple resources for handling). A single transfer in Robotic handling will never go beyond 200 mL due to the limit of the destination size so we won't worry about splitting a single transfer source. *)
					Range[Length[mySources]]
				}];

				(* For each sample model, tally up the amount requested based on the results we got in resolver (passed down with SourceSampleGrouping option. *)
				totaledSampleModelAmounts=Module[
					{sourceSampleGroupings,indexedSourceSampleGroupings,indexedSourceSampleGroups},
					sourceSampleGroupings=Lookup[myResolvedOptions,SourceSampleGrouping];
					(* Transpose the sample grouping info with other model handling incubation parameters. Delete any cases that we don't have SourceSampleGrouping for, which means it is not a Model[Sample] resource *)
					indexedSourceSampleGroupings=DeleteCases[Transpose[{sourceSampleGroupings,sampleModelsAmountsWithSourceIncubations}],{Null,_}];
					(* Group by same resource index (and guaranteed to be same Amount) *)
					indexedSourceSampleGroups=GatherBy[indexedSourceSampleGroupings,First];
					Map[
						(* We have already done grouping in resolver so we can safely use the information from the first of the group *)
						(
							(* {model,temp,equilTime,maxEquilTime} -> {totalAmount,all indices} *)
							#[[1,2,;;-3]]->{#[[1,1,2]],#[[All,2,-1]]}
						)&,
						indexedSourceSampleGroups
					]
				];

				(* Lookup the Model[Container]s of these Model[Sample]s, from the SourceContainer option in the resolver *)
				(* Since we may have regrouped one model request (with same incubation parameters) into multiple resources due to the large volume, we have to look up from the index, not only model *)
				sampleModelContainerRules=Map[
					Rule[#[[3]],#[[2]]]&,
					Cases[
						Transpose[{
							mySources/.{obj:ObjectP[]:>Download[obj,Object]},
							Download[#,Object]&/@Lookup[myResolvedOptions, SourceContainer],
							Range[Length[mySources]]
						}],
						{ObjectP[Model[Sample]], ListableP[ObjectP[Model[Container]]], _}
					]
				];

				sampleModelContainers=Map[
					(* Use the first indice to decide the container model. We have resolved to the same container model earlier based on the same grouping rule *)
					(First[#]/.sampleModelContainerRules)&,
					(* Get the indices out of the model amount tuple *)
					totaledSampleModelAmounts[[All,2,2]]
				];

				(* Create resources for any Model[Sample]s we have for our sources. *)
				(* straight from the water purifier. *)
				sourceSampleModelResources=Flatten@MapThread[
					Function[{totaledSampleModelAmount,sourceContainer},
						Module[
							{sourceContainerModel,modelPacket,state,density,sourceContainerMaxVolume,amount,deadVolume,resource},

							(* if we have Object[Container], convert it to Model[Container] (must be single) *)
							(* sourceContainer is a list of Model[Container] for Model[Sample] *)
							sourceContainerModel = If[MatchQ[sourceContainer, ObjectP[Object[Container]]],
								fastAssocLookup[fastAssoc, sourceContainer, {Model, Object}],
								sourceContainer
							];

							(* Get the state of our Model[Sample] at room temperature. *)
							modelPacket=fetchPacketFromFastAssoc[totaledSampleModelAmount[[1,1]], fastAssoc];
							state=Lookup[modelPacket, State];
							(* For solid sample, use its density to figure out the max amount we cant put in a reservoir so we can split if necessary *)
							density=If[MatchQ[Lookup[modelPacket, Density], DensityP],
								Lookup[modelPacket, Density],
								Quantity[0.997`, ("Grams")/("Milliliters")] * 1.25
							];

							(* sourceContainer is a Model[Container] for Model[Sample] *)
							(* The following considerations are performed on the smallest possible container, if there is a list. We will add additional dead volume in primitive framework if we have to consolidate more and select a larger container *)
							(* get the MaxVolume of the smallest sourceContainer *)
							sourceContainerMaxVolume = If[MatchQ[state,Solid]&&!NullQ[sourceContainerModel],
								(* Convert to mass max if we are transferring a solid. Use 1 Gram/Milliliter density as in how we deal with PreferredContainer resolution *)
								Min[fastAssocLookup[fastAssoc,#,MaxVolume]&/@ToList[sourceContainerModel]]*density,
								Min[fastAssocLookup[fastAssoc,#,MaxVolume]&/@ToList[sourceContainerModel]]
							];

							(* We are supposed to use the MinVolume of the container as the required container dead volume. However, we do that on the framework level since we may consolidate resources *)

							(* Calculate the dead volume for each transfer *)
							deadVolume=Which[
								MatchQ[totaledSampleModelAmount[[2,1]],VolumeP],
								5Microliter*Count[sampleModelsAmountsWithSourceIncubations, {ObjectP[totaledSampleModelAmount[[1]]], ___}],
								MatchQ[totaledSampleModelAmount[[2,1]],MassP],
								0Gram,
								True,
								Null
							];

							(* When requesting water, we always want to get an amount large enough that we get it from the purifier *)
							(* Engine calls ExperimentTransfer to make amounts less than $MicroWaterMaximum so if we request less than that we'll get stuck in a requesting loop *)
							(* Note this same logic is used in calculating sampleModelWithContainerAndAmount in the resolver *)
							amount=If[MatchQ[totaledSampleModelAmount[[1,1]],WaterModelP],
								Max[$MicroWaterMaximum,Min[{totaledSampleModelAmount[[2,1]]*1.1+deadVolume,If[CompatibleUnitQ[sourceContainerMaxVolume,totaledSampleModelAmount[[2,1]]], sourceContainerMaxVolume, Nothing]}]],
								(* use the smallest of 110% of what we need and the max volume of the source container in case we are working with liquid *)
								If[MatchQ[resolvedPreparation, Manual],
									Which[
										NumericQ[totaledSampleModelAmount[[2,1]]],
										(* If we are dealing with a count item, just go with the amount. No need for 110%. Add Unit for the resource *)
											SafeRound[totaledSampleModelAmount[[2,1]],1]*Unit,
										(* If we are dealing with sachet but we are not given a count, convert it to count and round up a unit *)
										TrueQ[Lookup[modelPacket,Sachet]] && MatchQ[totaledSampleModelAmount[[2,1]], MassP],
											Unit * SafeRound[totaledSampleModelAmount[[2,1]]/Lookup[modelPacket,SolidUnitWeight], 1],
										True,
											Min[{totaledSampleModelAmount[[2,1]]*1.1, If[CompatibleUnitQ[sourceContainerMaxVolume,totaledSampleModelAmount[[2,1]]], sourceContainerMaxVolume, Nothing]}]
									],
									Min[{totaledSampleModelAmount[[2,1]]*1.1+deadVolume, If[CompatibleUnitQ[sourceContainerMaxVolume,totaledSampleModelAmount[[2,1]]], sourceContainerMaxVolume, Nothing]}]
								]
							];

							resource=If[MatchQ[sourceContainer, ListableP[ObjectP[Model[Container]]]],
								If[MemberQ[freshSourceModels,Download[totaledSampleModelAmount[[1,1]],Object]],
									Resource@@{
										Sample->totaledSampleModelAmount[[1,1]],
										Amount->amount,
										(* Provide the name since we need to track this resource in multiple fields *)
										Name->CreateUUID[],
										(* for the container field we should add a failsafe resource, in case the sample resource is not requested in a stocked container and we need to perform consolidation *)
										If[
											(!QuantityQ[amount])||(MatchQ[amount,UnitsP[Unit]]),
											Nothing,
											Container->sourceContainer
										],
										(* Populate the source incubation keys (temporary keys) in resource so we can group them on the framework level *)
										If[MemberQ[totaledSampleModelAmount[[1,2;;4]],Except[Null]],
											Sequence@@{
												SourceTemperature ->totaledSampleModelAmount[[1,2]],
												SourceEquilibrationTime -> totaledSampleModelAmount[[1,3]],
												MaxSourceEquilibrationTime -> totaledSampleModelAmount[[1,4]]
											},
											Nothing
										],
										Fresh->True,
										(* Tell the framework that this Model[Sample] resource can be consolidated with other resources *)
										ConsolidateTransferResources->If[MatchQ[resolvedPreparation,Robotic],
											True,
											False
										]
									},
									Resource@@{
										Sample->totaledSampleModelAmount[[1,1]],
										Amount->amount,
										(* Provide the name since we need to track this resource in multiple fields *)
										Name->CreateUUID[],
										(* for the container field we should add a failsafe resource, in case the sample resource is not requested in a stocked container and we need to perform consolidation *)
										If[
											(!QuantityQ[amount])||(MatchQ[amount,UnitsP[Unit]]),
											Nothing,
											Container->sourceContainer
										],
										(* Populate the source incubation keys (temporary keys) in resource so we can group them on the framework level *)
										If[MemberQ[totaledSampleModelAmount[[1,2;;4]],Except[Null]],
											Sequence@@{
												SourceTemperature ->totaledSampleModelAmount[[1,2]],
												SourceEquilibrationTime -> totaledSampleModelAmount[[1,3]],
												MaxSourceEquilibrationTime -> totaledSampleModelAmount[[1,4]]
											},
											Nothing
										],
										(* Tell the framework that this Model[Sample] resource can be consolidated with other resources *)
										ConsolidateTransferResources->If[MatchQ[resolvedPreparation,Robotic],
											True,
											False
										]
									}
								],
								Link[Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)]
							];

							(* Get the rule from each index to the resource *)
							(#->resource)&/@(totaledSampleModelAmount[[2,2]])
						]
					],
					{totaledSampleModelAmounts,sampleModelContainers}
				];

				(* Create resources for any Model[Container]s we have for our destinations. *)
				specifiedIntegerContainerModelResources=(
					#->Resource[
						Sample->#[[2]],
						Name->CreateUUID[]
					]
				&)/@DeleteDuplicates[
					Cases[myDestinations, {_Integer, ObjectP[Model[Container]]}]/.{link_Link:>Download[link, Object]}
				];

				(* Simulate the creation of transfer primitive IDs. *)
				simulatedPrimitiveIDs=SimulateCreateID[ConstantArray[Object[UnitOperation, Transfer], Length[mySources]]];

				(* Create a lookup from destination labels to UUIDs. This is because we can ask for a transfer into a 50mL tube and *)
				(* label them all the same. *)
				destinationLabelToUUID=(#->CreateUUID[]&)/@DeleteDuplicates[Cases[Lookup[myResolvedOptions, DestinationLabel], _String]];

				(* Make packets for the transfer primitives. *)
				(* NOTE: Once again this is an excerpt from the resource packets function, just for the important fields that *)
				(* are error proof. *)
				transferUnitOperationPackets=MapThread[
					Function[{source, destination, sourceWell, destWell, destinationLabel, amount, primitiveID, index},
						<|
							Object->primitiveID,

							Protocol->Link[protocolObject, BatchedUnitOperations],

							(* NOTE: We always make resources for the containers, not the samples. This is because we want the container *)
							(* objects, not the sample objects to show up in the engine instructions. *)
							Replace[SourceLink]->List@Switch[source,
								ObjectP[Model[Sample]],
									Lookup[sourceSampleModelResources, index],
								ObjectP[Object[Sample]],
									Resource[
										Sample->Download[Lookup[fetchPacketFromFastAssoc[source, fastAssoc], Container], Object],
										Name->Download[Lookup[fetchPacketFromFastAssoc[source, fastAssoc], Container], ID]
									],
								ObjectP[Object[Container]],
									Resource[
										Sample->source,
										Name->Download[source, ID]
									],
								{_String, ObjectP[Object[Container]]},
									Resource[
										Sample->source[[2]],
										Name->Download[source[[2]], ID]
									],
								{_Integer, ObjectP[Model[Container]]},
									Lookup[specifiedIntegerContainerModelResources, Key[destination/.{link_Link:>Download[link, Object]}]]
							],
							Replace[SourceExpression]->{Null},
							Replace[SourceString]->{Null},

							Replace[DestinationLink]->List@Switch[destination,
								ObjectP[Object[Sample]],
									Resource[
										Sample->Download[Lookup[fetchPacketFromFastAssoc[destination, fastAssoc], Container], Object],
										Name->Download[Lookup[fetchPacketFromFastAssoc[destination, fastAssoc], Container], ID]
									],
								ObjectP[Object[Container]],
									Resource[
										Sample->Download[destination, Object],
										Name->Download[destination, ID]
									],
								ObjectP[Model[Container]],
									Resource[
										Sample->destination,
										Name->If[MatchQ[Lookup[destinationLabelToUUID, destinationLabel], _String],
											Lookup[destinationLabelToUUID, destinationLabel],
											CreateUUID[]
										]
									],
								{_Integer, ObjectP[Model[Container]]},
									Lookup[specifiedIntegerContainerModelResources, Key[destination/.{link_Link:>Download[link, Object]}]],
								{_Integer, ObjectP[Object[Container]]}|{_String, ObjectP[Object[Container]]},
									Resource[
										Sample->Download[destination[[2]], Object],
										Name->Download[destination[[2]], ID]
									],
								(* NOTE: We will switch off of the aspirator instrument and the sample will automatically go to waste. *)
								Waste,
									Null
							],
							Replace[DestinationString]->{Null},
							Replace[DestinationExpression]->List@If[MatchQ[destination, Waste],
								Waste,
								Null
							],
							Replace[SourceWell] -> {sourceWell},
							Replace[DestinationWell] -> {destWell},
							Which[
								MatchQ[amount, All],
									Sequence@@{
										Replace[AmountVariableUnit]->{Null},
										Replace[AmountInteger]->{Null},
										Replace[AmountExpression]->{All}
									},
								MatchQ[amount, CountP],
									Sequence@@{
										Replace[AmountVariableUnit]->{Null},
										Replace[AmountInteger]->{amount},
										Replace[AmountExpression]->{All}
									},
								True,
									Sequence@@{
										Replace[AmountVariableUnit]->{amount},
										Replace[AmountInteger]->{amount},
										Replace[AmountExpression]->{All}
									}
							]
						|>
					],
					{
						mySources,
						myDestinations,
						Lookup[myResolvedOptions, SourceWell],
						Lookup[myResolvedOptions, DestinationWell],
						Lookup[myResolvedOptions, DestinationLabel],
						myAmounts,
						simulatedPrimitiveIDs,
						Range[Length[mySources]]
					}
				];

				(* Make the transfer primitives. *)
				protocolPacket=<|
					Object->protocolObject,
					If[MatchQ[protocolObject, ObjectP[Object[Protocol, Transfer]]],
						Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@simulatedPrimitiveIDs,
						Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@simulatedPrimitiveIDs
					],
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[transferUnitOperationPackets, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[transferUnitOperationPackets, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions->myResolvedOptions
				|>;

				SimulateResources[protocolPacket, transferUnitOperationPackets, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> simulation]
			],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Transfer]. *)
		True,
			SimulateResources[myProtocolPacket, myUnitOperationPackets, Simulation -> simulation]
	];

	(* Figure out what field to download from. *)
	unitOperationField=If[MatchQ[protocolObject, ObjectP[Object[Protocol, Transfer]]],
		BatchedUnitOperations,
		OutputUnitOperations
	];

	(* Download information from our simulated resources. *)
	{
		simulatedUnitOperationPackets,
		simulatedSourceContainerPackets,
		simulatedSourceSamplePackets,
		simulatedDestinationContainerPackets,
		simulatedDestinationSamplePackets,
		simulatedCollectionContainerPackets,
		simulatedQuantitativeTransferWashSolutionPackets
	}=Quiet[
		With[{insertMe=unitOperationField},
			Download[
				protocolObject,
				{
					Packet[insertMe[{SourceLink, DestinationLink, CollectionContainerLink, SourceWell, DestinationWell}]],
					Packet[insertMe[SourceLink][{Model, State, Sachet, SolidUnitWeight, Container, Name, Contents, Sterile, AsepticHandling}]],
					Packet[insertMe[SourceLink][Contents][[All,2]][{Model, State, Name, Sachet, SolidUnitWeight, Sterile, AsepticHandling}]],
					Packet[insertMe[DestinationLink][{Model, State, Container, Name, Contents, Sterile, AsepticHandling}]],
					Packet[insertMe[DestinationLink][Contents][[All,2]][{Model, State, Name, Sterile, AsepticHandling}]],
					Packet[insertMe[CollectionContainerLink][{Model, State, Container, Name, Contents, Sterile, AsepticHandling}]],
					Packet[insertMe[QuantitativeTransferWashSolutionLink][{Model, State, Container, Name, Contents, Sterile, AsepticHandling}]]
				},
				Simulation->currentSimulation
			]
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Like in the resource packets function, we have to combine our source/destinations in order to take the multichannel *)
	(* transfers into account. *)
	{combinedSources, combinedDestinations, combinedAmounts, combinedMapThreadFriendlyOptions}=If[MatchQ[resolvedPreparation, Robotic],
		{
			Flatten[Lookup[simulatedUnitOperationPackets, SourceLink]],
			Flatten[Lookup[simulatedUnitOperationPackets, DestinationLink]],
			myAmounts,
			mapThreadFriendlyOptions
		},
		Transpose@(
			Most/@DeleteDuplicatesBy[
				Transpose[{
					Flatten[Lookup[simulatedUnitOperationPackets, SourceLink]],
					Flatten[Lookup[simulatedUnitOperationPackets, DestinationLink]],
					myAmounts,
					mapThreadFriendlyOptions,
					(If[MatchQ[#, Null], CreateUUID[], #]&)/@Lookup[myResolvedOptions, MultichannelTransferName]
				}],
				Last
			]
		)
	];

	combinedSourceWells=If[MatchQ[resolvedPreparation, Robotic],
		ToList/@Flatten[Lookup[simulatedUnitOperationPackets, SourceWell]],
		Lookup[simulatedUnitOperationPackets, SourceWell]
	];

	combinedDestinationWells=If[MatchQ[resolvedPreparation, Robotic],
		ToList/@Flatten[Lookup[simulatedUnitOperationPackets, DestinationWell]],
		Lookup[simulatedUnitOperationPackets, DestinationWell]
	];

	(* memoized helper function to make the fake water and waste samples we can use whenever we're asked to transfer in *)
	(* admittedly this is a goofy thing to return but the point is we're memoizing two UploadSample calls so this makes a substantial difference performance-wise *)
	{
		{fakeWaterSample, fakeWasteSample},
		{fakeWaterSampleContainerObject, fakeWasteSampleContainerObject},
		fakeWaterAndWastePackets,
		memoizedWaterAndWasteSimulation
	} = simulateWaterAndWasteSamples["Memoization"];
	currentSimulation = UpdateSimulation[currentSimulation, memoizedWaterAndWasteSimulation];

	(* Get our cache with water sample *)
	simulatedSourceAndDestinationCache = FlattenCachePackets[{
		simulatedSourceSamplePackets,
		simulatedSourceContainerPackets,
		simulatedDestinationSamplePackets,
		simulatedDestinationContainerPackets,
		simulatedCollectionContainerPackets,
		simulatedQuantitativeTransferWashSolutionPackets,
		fakeWaterAndWastePackets
	}];

	(* We SHOULD be guaranteed to always have samples in our source containers. If this is not the case, we will have *)
	(* thrown an error about it in our resolver function and we just need to do something in our simulation function *)
	(* to not crash. If we don't find a sample, mark with Null. *)
	{existingSourceSamples, existingSourceContainers}=Transpose@MapThread[
		Function[{sourceWells, simulatedSource, options},
			Sequence@@Switch[simulatedSource,
				ObjectP[Object[Sample]],
				Module[{container},
					container=Lookup[fetchPacketFromCache[simulatedSource, simulatedSourceAndDestinationCache], Container];

					(
						{
							simulatedSource,
							Download[container, Object]
						}
								&)/@sourceWells
				],
				ObjectP[Object[Container]],
				(
					{
						(* Get the sample that's in the well of this container. If we can't find it, mark with Null so destination doesn't transfer from it. *)
						FirstCase[
							Lookup[fetchPacketFromCache[simulatedSource, simulatedSourceAndDestinationCache], Contents],
							{#, obj_}:>Download[obj, Object],
							Null
						],
						Download[simulatedSource, Object]
					}
							&)/@sourceWells,
				(* If we don't have a sample or a container (should be Null), it signifies that we're going to use the water purifier. *)
				_,
				ConstantArray[
					{Null, Null},
					Length[sourceWells]
				]
			]
		],
		{combinedSourceWells, combinedSources, combinedMapThreadFriendlyOptions}
	];

	(* We are NOT guaranteed to have a sample already in our destination container. Find the first transfer into this *)
	(* destination and initialize the model to that if we don't have a sample already in the container. *)
	destinationContainers=MapThread[
		Function[{destinationWells, simulatedDestination},
			Module[{destinationContainer},
				destinationContainer=Which[
					(* Otherwise, do we have a simulated container? *)
					MatchQ[simulatedDestination, ObjectP[Object[Container]]],
						Download[simulatedDestination, Object],
					(* Otherwise, do we have a simulated object? *)
					MatchQ[simulatedDestination, ObjectP[Object[Sample]]],
						Download[Lookup[fetchPacketFromCache[simulatedDestination, simulatedSourceAndDestinationCache], Container], Object],
					(* Are we supposed to transfer into waste? *)
					True,
						fakeWasteSampleContainerObject
				];

				(* NOTE: If we have a Multichannel transfer, we actually have multiple source samples, but just combined the primitive *)
				(* objects together. *)
				If[Length[destinationWells]>0,
					Sequence@@ConstantArray[destinationContainer, Length[destinationWells]],
					destinationContainer
				]
			]
		],
		{combinedDestinationWells, combinedDestinations}
	];

	(* This will either be an Object[Sample] or a {Model[Sample], StateP, Object[Container], WellPositionP} if the sample doesn't *)
	(* yet exist. *)
	destinationSamples=MapThread[
		Function[{destinationWells, groupedSimulatedSourceSamples, rawDestination, groupedSimulatedDestinationContainers, options},
			(* Are we dealing with our waste container? *)
			Sequence@@If[MatchQ[groupedSimulatedDestinationContainers, {ObjectP[fakeWasteSampleContainerObject]..}],
				ConstantArray[fakeWasteSample, Length[destinationWells]],
				(* Otherwise, we have a sample inside of our container? *)
				Module[{destinationSamples},
					(* Try to find the sample at our destination well. *)
					destinationSamples=MapThread[
						Function[{well, container},
							FirstCase[
								Lookup[fetchPacketFromCache[container, simulatedSourceAndDestinationCache], Contents],
								{well, obj_}:>Download[obj, Object],
								Null
							]
						],
						{destinationWells, groupedSimulatedDestinationContainers}
					];

					(* Were we able to find our destination sample? *)
					(* NOTE: This is kind of an approximation because if we have sample A transfer into sample B for the first *)
					(* transfer into B, sample C could transfer into A before, thus messing up A's model and state. UST should correct *)
					(* this if we safely default state to Automatic and even if we get the model wrong for B to start off with. *)
					MapThread[
						Function[{destinationSample, destinationWell, simulatedSourceSample, simulatedDestinationContainer},
							If[MatchQ[destinationSample, ObjectP[Object[Sample]]],
								destinationSample,
								(* No. Find the first transfer into this container and initialize a new sample of that model. *)
								Which[
									(* If we have a Model[Container], we are a unique container that cannot be reused. The first model transferred *)
									(* in is the model of our index-matched source sample. *)
									MatchQ[rawDestination, ObjectP[Model[Container]]],
										{
											Lookup[fetchPacketFromCache[simulatedSourceSample, simulatedSourceAndDestinationCache], Model, Null],
											Automatic,
											simulatedDestinationContainer,
											destinationWell
										},
									(* If we have an {_Integer, Model[Container]}, get the first instance it shows up. *)
									MatchQ[rawDestination, {_Integer, ObjectP[Model[Container]]}],
										Module[{correspondingSourceSample},
											correspondingSourceSample=FirstCase[
												Transpose[{existingSourceSamples, myDestinations, Lookup[mapThreadFriendlyOptions, DestinationWell]}],
												{obj_, {rawDestination[[1]], ObjectP[rawDestination[[2]]]}, destinationWell}:>obj
											];

											{
												If[!MatchQ[correspondingSourceSample,ObjectP[Object[Sample]]],Null,Lookup[fetchPacketFromCache[correspondingSourceSample, simulatedSourceAndDestinationCache], Model, Null]],
												Automatic,
												simulatedDestinationContainer,
												destinationWell
											}
										],
									(* If we have an Object[Container], look for that. We are guaranteed they didn't use Object[Sample] *)
									(* syntax earlier because we just said that there's no sample at this well. *)
									MatchQ[rawDestination, ObjectP[Object[Container]]],
										Module[{correspondingSourceSample},
											correspondingSourceSample=FirstCase[
												Transpose[{existingSourceSamples, myDestinations, Lookup[mapThreadFriendlyOptions, DestinationWell]}],
												{obj_, (ObjectP[rawDestination]|{Lookup[options, DestinationWell], ObjectP[rawDestination]}), destinationWell}:>obj
											];

											{
												If[!MatchQ[correspondingSourceSample,ObjectP[Object[Sample]]],Null,Lookup[fetchPacketFromCache[correspondingSourceSample, simulatedSourceAndDestinationCache], Model, Null]],
												Automatic,
												simulatedDestinationContainer,
												destinationWell
											}
										],
									(* If we have a {WellPositionP, Object[Container]}, look for that. We are guaranteed they didn't use Object[Sample] *)
									(* syntax earlier because we just said that there's no sample at this well. *)
									MatchQ[rawDestination, {_String, ObjectP[Object[Container]]}],
										Module[{correspondingSourceSample},
											correspondingSourceSample=FirstCase[
												Transpose[{existingSourceSamples, myDestinations, Lookup[mapThreadFriendlyOptions, DestinationWell]}],
												{obj_, (ObjectP[rawDestination[[2]]]|{destinationWell, ObjectP[rawDestination[[2]]]}), destinationWell}:>obj
											];

											{
												If[!MatchQ[correspondingSourceSample,ObjectP[Object[Sample]]],Null,Lookup[fetchPacketFromCache[correspondingSourceSample, simulatedSourceAndDestinationCache], Model, Null]],
												Automatic,
												simulatedDestinationContainer,
												destinationWell
											}
										],
									(* If there is no source sample. *)
									MatchQ[simulatedSourceSample, Null],
										{
											Null,
											Automatic,
											simulatedDestinationContainer,
											destinationWell
										},
									(* We messed up bad. *)
									True,
										fakeWasteSample
								]
							]
						],
						{destinationSamples, destinationWells, groupedSimulatedSourceSamples, groupedSimulatedDestinationContainers}
					]
				]
			]
		],
		(* NOTE: We need to unflatten here in the case where we're doing multichannel transfers so that things still index match. *)
		{
			combinedDestinationWells,
			Unflatten[existingSourceSamples, (If[MatchQ[#, {}], {Null}, #]&)/@combinedSourceWells],
			combinedDestinations,
			Unflatten[destinationContainers, (If[MatchQ[#, {}], {Null}, #]&)/@combinedDestinationWells],
			combinedMapThreadFriendlyOptions
		}
	];

	(* Get any samples that we have to initialize in our destinations. *)
	destinationSamplesToCreate=DeleteDuplicates[Cases[destinationSamples, {ObjectP[Model[Sample]]|Null, _, _, _}]/.{obj:ObjectP[]:>Download[obj, Object]}];

	(* Create samples in our collection containers if they do not yet exist. *)
	collectionContainerSamples=If[Length[Flatten[simulatedCollectionContainerPackets]]>0,
		MapThread[
			Function[{destinationWell, collectionContainerPacket},
				Which[
					MatchQ[resolvedPreparation, Manual],
						Null,
					(* Not using a collection container. *)
					!MatchQ[collectionContainerPacket, PacketP[Object[Container]]],
						Null,
					(* Collection container already has a sample in it. *)
					And[
						MatchQ[collectionContainerPacket, PacketP[Object[Container]]],
						MatchQ[FirstCase[Lookup[collectionContainerPacket, Contents], {destinationWell, obj_}:>obj], ObjectP[Object[Sample]]]
					],
						FirstCase[Lookup[collectionContainerPacket, Contents], {destinationWell, obj_}:>obj],
					(* Using a collection container that needs a sample in it. *)
					True,
						{
							Null,
							Automatic,
							Lookup[collectionContainerPacket, Object],
							destinationWell
						}
				]
			],
			(* Sometimes we can have unit operations with multiple destination wells so we need to expand our collection containers to match. *)
			{
				Flatten[Lookup[simulatedUnitOperationPackets, DestinationWell]],
 				If[MatchQ[Length[Flatten[Lookup[simulatedUnitOperationPackets, DestinationWell]]], Length[Flatten[simulatedCollectionContainerPackets]]],
					Flatten[simulatedCollectionContainerPackets],
					Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {simulatedCollectionContainerPackets, ToList[Lookup[simulatedUnitOperationPackets, DestinationWell]]}]]
				]
			}
		],
		ConstantArray[Null, Length[myAmounts]]
	];

	collectionContainerSamplesToCreate=DeleteDuplicates[Cases[collectionContainerSamples, {ObjectP[Model[Sample]]|Null, _, _, _}]/.{obj:ObjectP[]:>Download[obj, Object]}];

	(* Make them. *)
	samplesToCreatePackets=UploadSample[
		(* NOTE: UploadSample takes in {} instead of Null if there is no model. *)
		(* NOTE: Temporary work around because the way that we're currently calculating the model to simulate is incorrect. *)
		Join[
			destinationSamplesToCreate[[All,1]]/.Null->{},
			collectionContainerSamplesToCreate[[All,1]]/.Null->{}
		],(* temp fix but we still need to handle model-less case *)
		Join[
			Transpose[{destinationSamplesToCreate[[All,4]], destinationSamplesToCreate[[All,3]]}],
			Transpose[{collectionContainerSamplesToCreate[[All,4]], collectionContainerSamplesToCreate[[All,3]]}]
		],
		State->Join[
			destinationSamplesToCreate[[All,2]],
			collectionContainerSamplesToCreate[[All,2]]
		],
		InitialAmount->ConstantArray[Null, Length[Join[destinationSamplesToCreate, collectionContainerSamplesToCreate]]],
		UpdatedBy->protocolObject,
		Simulation->currentSimulation,
		SimulationMode -> True,
		FastTrack->True,
		Upload->False
	];

	newDestinationSampleObjects=(Lookup[#, Object]&)/@Take[samplesToCreatePackets, Length[destinationSamplesToCreate]];
	newCollectionContainerSampleObjects=(Lookup[#, Object]&)/@Take[Drop[samplesToCreatePackets, Length[destinationSamplesToCreate]], Length[collectionContainerSamplesToCreate]];

	(* Update our simulation. *)
	currentSimulation=UpdateSimulation[currentSimulation, Simulation[samplesToCreatePackets]];

	(* Finalize our destination samples and collection container samples. *)
	(* We need to update AsepticHandling/Sterile field according to index-matching option SterileTechnique. Since the number of newSamples vary for each uo, we need to do a map here *)
	(* The reason why the Sterile/AsepticHandling is not handled by UST later is because we use Milli-Q water as the Model for the simulated new destination samples, which is not Sterile *)
	{destinationSamples, destinationSamplesAsepticUpdatePackets} = Module[{destinationSampleToNewObjectRules},
		destinationSampleToNewObjectRules = MapThread[#1 -> #2&, {destinationSamplesToCreate/.{obj:ObjectP[]:>ObjectP[obj]}, newDestinationSampleObjects}];
		Transpose@MapThread[
			If[MemberQ[destinationSamplesToCreate, #1/.{obj:ObjectP[]:>ObjectP[obj]}],
				Module[{containerSterile},
					containerSterile = TrueQ[Lookup[fetchPacketFromCache[#1[[3]], simulatedSourceAndDestinationCache], Sterile]];
					{
						#1/.destinationSampleToNewObjectRules,
						<|
							Object -> #1/.destinationSampleToNewObjectRules,
							Sterile -> containerSterile,
							AsepticHandling -> (containerSterile && #2)
						|>
					}
				],
				{
					#1,
					<||>
				}
			]&,
			{destinationSamples, resolvedSterileTechnique}
		]
	];
	{collectionContainerSamples, collectionSamplesAsepticUpdatePackets} = Module[{collectionSampleToNewObjectRules},
		collectionSampleToNewObjectRules = MapThread[#1 -> #2&, {collectionContainerSamplesToCreate/.{obj:ObjectP[]:>ObjectP[obj]}, newCollectionContainerSampleObjects}];
		Transpose@MapThread[
			If[MemberQ[collectionContainerSamplesToCreate, #1/.{obj:ObjectP[]:>ObjectP[obj]}],
				Module[{containerSterile},
					containerSterile = TrueQ[Lookup[fetchPacketFromCache[#1[[3]], simulatedSourceAndDestinationCache], Sterile]];
					{
						#1/.collectionSampleToNewObjectRules,
						<|
							Object -> #1/.collectionSampleToNewObjectRules,
							Sterile -> containerSterile,
							AsepticHandling -> (containerSterile && #2)
						|>
					}
				],
				{
					#1,
					<||>
				}
			]&,
		{collectionContainerSamples, resolvedSterileTechnique}
	]];
	currentSimulation=UpdateSimulation[currentSimulation, Simulation[Cases[Join[destinationSamplesAsepticUpdatePackets, collectionSamplesAsepticUpdatePackets], PacketP[]]]];

	(* Re-Download so source samples will exist if they are also a destination *)
	updatedPackets=Quiet[
		Download[
			destinationContainers,
			{
				Packet[Contents],
				Packet[Contents[[All,2]][{Model, State, Name}]]
			},
			Simulation->currentSimulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Create new updated cache. NOTE: updatedPackets must be before simulatedSourceAndDestinationCache to make sure the updated packets are merged in. *)
	simulatedSourceAndDestinationCacheWithUpdatedDestinations=FlattenCachePackets[{updatedPackets,simulatedSourceAndDestinationCache}];

	(* We SHOULD be guaranteed to always have samples in our source containers. If this is not the case, we will have *)
	(* thrown an error about it in our resolver function and we just need to do something in our simulation function *)
	(* to not crash. If we don't find a sample, just transfer from our giant water sample. *)
	{sourceSamples, sourceContainers}=Transpose@MapThread[
		Function[{sourceWells, simulatedSource, options},
			Sequence@@Switch[simulatedSource,
				ObjectP[Object[Sample]],
				Module[{container},
					container=Lookup[fetchPacketFromCache[simulatedSource, simulatedSourceAndDestinationCacheWithUpdatedDestinations], Container];

					(
						{
							simulatedSource,
							Download[container, Object]
						}
								&)/@sourceWells
				],
				ObjectP[Object[Container]],
				(
					{
						(* Get the sample that's in the well of this container. If we can't find it, fall back on our giant water sample. *)
						FirstCase[
							Lookup[fetchPacketFromCache[simulatedSource, simulatedSourceAndDestinationCacheWithUpdatedDestinations], Contents],
							{#, obj_}:>Download[obj, Object],
							fakeWaterSample
						],
						Download[simulatedSource, Object]
					}
							&)/@sourceWells,
				(* If we don't have a sample or a container (should be Null), it signifies that we're going to use the water purifier. *)
				_,
				ConstantArray[
					{fakeWaterSample, fakeWaterSampleContainerObject},
					Length[sourceWells]
				]
			]
		],
		{combinedSourceWells, combinedSources, combinedMapThreadFriendlyOptions}
	];

	(* Call UploadSampleTransfer on our source and destination samples. *)
	uploadSampleTransferPackets=If[MatchQ[sourceSamples, destinationSamples],
		{},
		Module[
			{
				sourceTransferSamples, destinationTransferSamples, transferAmounts, livingDestinations, sachetSourceQs,
				includeSachetPouches, sourcePackets, destinationSampleQuantitativeTransferTuples, ustPackets,
				destinationSampleSachetUpdates, ustCountAsPassages, countAsPassages
			},
			(* Determine if we are transferring from a sachet source *)
			sourcePackets = fetchPacketFromCache[#, simulatedSourceAndDestinationCacheWithUpdatedDestinations]& /@ sourceSamples;
			sachetSourceQs = Lookup[sourcePackets, Sachet, Null];
			countAsPassages = Lookup[mapThreadFriendlyOptions, CountAsPassage];
			(* The 6th item of the list is the CountAsPassage tuple. It is only countAsPassageQ for the original source transfer. The rest will the inhereit the log with the correct parent sample if there's any cell model in the composition *)
			(* When we have collection containers, we need to transfer from the source -> destination -> collection container sample. *)
			{sourceTransferSamples, destinationTransferSamples, transferAmounts, livingDestinations, includeSachetPouches, ustCountAsPassages}=Transpose@MapThread[
				Function[{source, destination, collectionContainerSample, amount, livingDestination, sachetSourceQ, sourcePacket, countAsPassageQ, options},
					Which[
						MatchQ[collectionContainerSample, ObjectP[Object[Sample]]],
							Sequence@@{
								{source, destination, amount, livingDestination, True, countAsPassageQ},
								{destination, collectionContainerSample, amount, livingDestination, True, False}
							},
						(* If we are transferring from sachet, we need to do a little conversion here to make sure we always feed a count or all, and look up the option for whether to include the pouch *)
						TrueQ[sachetSourceQ] && !MatchQ[source, destination],
							Module[{sanitizedAmount},
								sanitizedAmount = Which[MatchQ[amount, MassP],
									(* If specified a mass, we find the integer of count estimated to fulfill the mass *)
									SafeRound[amount/Lookup[sourcePacket,SolidUnitWeight, 1 Gram], 1],
									(* If somehow we got here with a volume, it already errored out in the resolver. We roughly convert it to count so that we could smoothly return a simulation *)
									MatchQ[amount, VolumeP],
										1,
									True,
									(* Otherwise we should only be getting CountP|All, use directly*)
										amount
								];
								{source, destination, sanitizedAmount, livingDestination,
									(* In case we have a sachet source, but not cutting it open, IncludeSachetPouch can be Null, we need to interpret it as to include sachet pouch in the UploadSampleTransfer composition update *)
									(Lookup[options, IncludeSachetPouch] /. Null -> True),
									countAsPassageQ
								}
							],
						!MatchQ[source, destination],
							{source, destination, amount, livingDestination, True, countAsPassageQ},
						True,
							Nothing
					]
				],
				{sourceSamples, destinationSamples, collectionContainerSamples, myAmounts, resolvedLivingDestination, sachetSourceQs, sourcePackets, countAsPassages, mapThreadFriendlyOptions}
			];

			(* We need to simulate quantitative transfer washes *)
			(* Note: QuantitativeTransfer, we are adding buffer to destination sample. So the state and amount should be updated accordingly *)
			destinationSampleQuantitativeTransferTuples = If[MemberQ[resolvedQuantitativeTransfer, True],
				DeleteCases[Flatten[
					MapThread[
						Function[{destSamples, quantitativeTransfers, washVolumes, numberOfWashes, simulatedWashSolution},
							MapThread[
								If[MatchQ[#2, True],
									{
										(* simulatedWashSolution may be Null if we already errored out earlier in resolver, for unfulfillable resource. Set to Null to not break again here *)
										Download[FirstOrDefault[simulatedWashSolution], Object],
										#1,
										#3*#4,
										False,
										False,
										False
									},
									Nothing
								]&,
								{destSamples, quantitativeTransfers, washVolumes, numberOfWashes}
							]
						],
						(* NOTE: We need to unflatten destinationSamples here in the case where we're doing multichannel transfers so that things still index match. *)
						(* resolvedQuantitativeTransfer,resolvedQuantitativeTransferWashVolumes,resolvedNumberOfQuantitativeTransferWashes are indexmatching to the flattened destinationSamples *)
						(* simulatedQuantitativeTransferWashSolutionPackets is already indexmatching to the unflatten destinationSamples *)
						{
							Unflatten[destinationSamples, (If[MatchQ[#, {}], {Null}, #]&)/@combinedDestinationWells],
							Unflatten[resolvedQuantitativeTransfer, (If[MatchQ[#, {}], {Null}, #]&)/@combinedDestinationWells],
							Unflatten[resolvedQuantitativeTransferWashVolumes, (If[MatchQ[#, {}], {Null}, #]&)/@combinedDestinationWells],
							Unflatten[resolvedNumberOfQuantitativeTransferWashes, (If[MatchQ[#, {}], {Null}, #]&)/@combinedDestinationWells],
							simulatedQuantitativeTransferWashSolutionPackets
						}
					],
					1
				], {}],(* Remove empty list from the tuples *)
				(* If quantitative transfer is not True, directly return {} for the tuples *)
				{}
			];

			ustPackets = UploadSampleTransfer[
				Join[sourceTransferSamples, destinationSampleQuantitativeTransferTuples[[All, 1]]],
				Join[destinationTransferSamples, destinationSampleQuantitativeTransferTuples[[All, 2]]],
				Join[transferAmounts, destinationSampleQuantitativeTransferTuples[[All, 3]]],
				LivingDestination -> Join[livingDestinations, destinationSampleQuantitativeTransferTuples[[All, 4]]],
				IncludeSachetPouch -> Join[includeSachetPouches, destinationSampleQuantitativeTransferTuples[[All, 5]]],
				CountAsPassage -> Join[ustCountAsPassages, destinationSampleQuantitativeTransferTuples[[All, 6]]],
				Upload->False,
				FastTrack->True,
				Simulation->currentSimulation
			];

			(* Update sachet-related fields. This needs to be done outside UST since it does not have info of what instrument we used. *)
			destinationSampleSachetUpdates = MapThread[
				Function[{destination, sachetSourceQ, amount, options},
					Which[
						(* If Sachets are transferred using scissors, we turn off the Sachet field, update sample handling *)
						And[
							TrueQ[sachetSourceQ],
							MatchQ[Lookup[options, Instrument], ObjectP[{Model[Item, Scissors], Object[Item, Scissors]}]]
						],
							<|
								Object -> destination,
								Sachet -> False,
								SampleHandling -> Powder
							|>,
						(* If sachets are transferred by tweezers/Null, they stay itemized sachet, but count will needs to be updated.*)
						And[
							TrueQ[sachetSourceQ],
							MatchQ[amount, CountP]
						],
							<|
								Object -> destination,
								Sachet -> True,
								Count ->  (Lookup[fetchPacketFromCache[destination, ustPackets],Count,0]/.{Null->0}) + (amount)
							|>,
						True,
							Nothing
					]
				],
				{destinationSamples, sachetSourceQs, myAmounts, mapThreadFriendlyOptions}
			];

			(* Return joined packets*)
			Cases[Flatten[{ustPackets, destinationSampleSachetUpdates}],PacketP[]]
		]
	];

	(* Update our simulation. *)
	currentSimulation=UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SourceLabel], sourceSamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SourceContainerLabel], sourceContainers}],
				{_String, ObjectP[]}
			],

			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, DestinationLabel], destinationSamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, DestinationContainerLabel], destinationContainers}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SourceLabel], (Field[SourceSample[[#]]]&)/@Range[Length[sourceSamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SourceContainerLabel], (Field[SourceContainer[[#]]]&)/@Range[Length[sourceContainers]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, DestinationLabel], (Field[DestinationSample[[#]]]&)/@Range[Length[destinationSamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, DestinationContainerLabel], (Field[DestinationContainer[[#]]]&)/@Range[Length[destinationContainers]]}],
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

DefineOptions[compatibleFunnels,
	Options:>{
		{IncompatibleMaterials->Null,Null|{(None|MaterialP|Null)...},"Indicates any incompatible materials of the sample that the funnel shouldn't be made of."},
		{Aperture->Null,Null|DistanceP,"The diameter that the funnel must fit into."},
		{FunnelType-> {Wet,Dry},Null|FunnelTypeP|{FunnelTypeP...},"The kind of funnel (Wet, Dry) that is used depending on the state of material to be transferred"}
	}
];

compatibleFunnels[funnelModelPackets_List, ops:OptionsPattern[]]:=Module[
	{safeOptions,filteredFunnels},

	(* Get our safe options. *)
	safeOptions=SafeOptions[compatibleFunnels,ToList[ops]];

	(* Filter our funnels. *)
	filteredFunnels=Cases[
		Cases[funnelModelPackets,Except[PacketP[Model[Part, Funnel, "id:P5ZnEjdwlzxr"]]]], (* do not include Model[Part, Funnel, "CryoPod Funnel"] *)
		KeyValuePattern[{
			(* Include a 1.5 mm tolerance. *)
			StemDiameter->LessEqualP[Lookup[safeOptions, Aperture] - 1.5 Millimeter],
			FunnelType->Alternatives@@Lookup[safeOptions,FunnelType],

			If[MatchQ[Lookup[safeOptions, IncompatibleMaterials], Null|{}|{None}],
				Nothing,
				FunnelMaterial->Except[Alternatives@@Lookup[safeOptions, IncompatibleMaterials]]
			]
		}]
	];

	(* Sort from larger to smaller stem diameters. *)
	Download[
		SortBy[
			filteredFunnels,
			{
				(* todo: this is a temp restriction to avoid auto resolution of glass funnels, will be removed after glass funnel set up ready in lab *)
				Position[{Polypropylene, Glass}, Lookup[#, FunnelMaterial]] &,
				(-Lookup[#, StemDiameter]&)
			}
		],
		Object
	]
];

(* -- HELPER FUNCTIONS -- *)
DefineOptions[compatibleWeighingContainer,
	Options:>{
		{IncompatibleMaterials->Null,Null|{(None|MaterialP)...},"Indicates any incompatible materials of the sample that the weighing container shouldn't be made of."},
		{QuantitativeTransfer->Null,Null|BooleanP,"Indicates if additional QuantitativeTransferWashSolution is used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination."},
		{QuantitativeTransferWashVolume->Null,Null|VolumeP,"The volume of the solution that will be used to wash the weighing container, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weighing container (after measurement) to the destination."},
		{Aperture->Null,Null|DistanceP,"The diameter that the stem component of the weigh boat must fit into. This is only applicable if for Model[Item,WieghBoat,WeighingFunnel]."},
		{Mode->Null,Null|BalanceModeP,"The type of measurement the specified balance to be used with the weighing container is capable of performing."}
	}
	];
	compatibleWeighingContainer[massToTransfer:MassP,volumeToTransfer:VolumeP, allWeighBoatModelPackets_List, allFunnelPackets_List, ops:OptionsPattern[]]:=Module[
	{safeOps, incompatibleMaterials, quantitativeTransfer, quantitativeTransferWashVolume, destinationAperture, mode,minFunnelStemDiameter,compatibleWeighingFunnelPackets,compatibleWeighingFunnels,compatibleWeighBoatPackets,compatibleWeighBoats,filteredWeighingContainers,errorSources},
	
	(* Get our safe options. *)
	safeOps=SafeOptions[compatibleWeighingContainer,ToList[ops]];
	
	{
		incompatibleMaterials,
		quantitativeTransfer,
		quantitativeTransferWashVolume,
		destinationAperture,
		mode
	}=Lookup[
		safeOps,
		{
			IncompatibleMaterials,
			QuantitativeTransfer,
			QuantitativeTransferWashVolume,
			Aperture,
			Mode
		}
	];
	
	minFunnelStemDiameter = Min[Cases[Lookup[Cases[allFunnelPackets,KeyValuePattern[{FunnelType->Dry}]],StemDiameter],_Quantity]];
	
	compatibleWeighingFunnelPackets = Cases[
		allWeighBoatModelPackets,
		KeyValuePattern[{
			MaxVolume->GreaterEqualP[volumeToTransfer] (* based on convertedAmountAsVolume *),
			Type->Model[Item,WeighBoat,WeighingFunnel],
			FunnelStemDiameter->LessEqualP[destinationAperture - 1.5 Millimeter],
			Dimensions -> {GreaterEqualP[destinationAperture + 1.5 Millimeter], _, _} | {_, GreaterEqualP[destinationAperture + 1.5 Millimeter], _},(*Include a 1.5 mm tolerance on x,y dimensions so weighing funnel does not fall through the container opening.*)
			Material->Except[Alternatives@@incompatibleMaterials],
			(* TODO update this to not be hardcoded once we get the correct dimensions of the weighing slot of the micro balance and use that as criteria *)
			If[MatchQ[mode,Micro],
				Object->ObjectP[$MicroBalanceCompatibleWeighingContainerModels[[1]]],
				Nothing
			]
		}]
	];
	
	compatibleWeighingFunnels = Download[
		SortBy[
			compatibleWeighingFunnelPackets,
			(Lookup[#, MaxVolume]&)
		],
		Object
	];
	
	compatibleWeighBoatPackets = Cases[
		allWeighBoatModelPackets,
		KeyValuePattern[{
			MaxVolume->GreaterEqualP[volumeToTransfer] (* based on convertedAmountAsVolume *),
			Type->Model[Item,WeighBoat],
			Material->Except[Alternatives@@incompatibleMaterials],
			If[MatchQ[mode,Micro],
				Object->ObjectP[$MicroBalanceCompatibleWeighingContainerModels[[2]]],
				Nothing
			]
		}]
	];
	
	compatibleWeighBoats = Download[
		SortBy[
			compatibleWeighBoatPackets,
			{
				(* Put individually stickered weighboats first. *)
				MatchQ[Lookup[#, Counted], True]&,
				(* Sub-sort uncounted and counted groupings, putting smallest weighboats first. *)
				Lookup[#, MaxVolume]&
			}
		],
		Object
	];
	
	{filteredWeighingContainers, errorSources} = Module[{weighingContainers,errors},
		Which[
			(* QuantitativeTransfer False, and a big enough aperture so we are sure to have compatible funnel, allow both weigh boat and weigh funnels but prioritize weigh boat *)
			MatchQ[quantitativeTransfer,Except[True]]&&MatchQ[destinationAperture,GreaterEqualP[minFunnelStemDiameter+1.5 Millimeter]],
			weighingContainers = Join[
				compatibleWeighBoats,
				compatibleWeighingFunnels
			];
			
			errors=If[MatchQ[weighingContainers,{}],
				{Model[Item,WeighBoat,WeighingFunnel],Model[Item,WeighBoat]},
				{}
			];
			
			{weighingContainers,errors},
			
			(* If QuantitativeTransfer is True and Aperture is less than the smallest StemDiameter of available funnels+tolerance (we can't use weighboat/weigh funnel combo), we require weighing funnels. If no compatibleWeighingFunnels are found, this returns {} and will error out later *)
			MatchQ[quantitativeTransfer,True]&&MatchQ[Lookup[safeOps, Aperture],LessP[minFunnelStemDiameter+1.5 Millimeter]],
			
			weighingContainers=compatibleWeighingFunnels;
			
			errors = If[MatchQ[weighingContainers,{}],
				{Model[Item,WeighBoat,WeighingFunnel]},
				{}
			];
			{weighingContainers,errors},
			
			(* If QuantitativeTransfer is True and we have compatibleWeighingFunnels, prioritize weighing funnel *)
			MatchQ[quantitativeTransfer,True]&&MatchQ[compatibleWeighingFunnels,Except[{}]],
			weighingContainers=Join[
				compatibleWeighingFunnels,
				compatibleWeighBoats
			];
			
			errors=If[MatchQ[weighingContainers,{}],
				{Model[Item,WeighBoat,WeighingFunnel],Model[Item,WeighBoat]},
				{}
			];
			{weighingContainers,errors},
			
			(* Otherwise, prioritize weigh boats *)
			(* If no compatibleWeighBoats are found, this returns {} and will error out later*)
			True,
			weighingContainers=compatibleWeighBoats;
			errors = If[MatchQ[weighingContainers,{}],
				{Model[Item,WeighBoat]},
				{}
			];
			{weighingContainers,errors}
		]
	]
	
	
];

(* Global variable to use as density if sample density is not available *)
$DefaultSampleDensity = 1.23 Gram/Milliliter; (* density of caffeine *)

DefineOptions[compatibleSpatulas,
	Options:>{
		{IncompatibleMaterials->Null,Null|{(None|MaterialP)...},"Indicates any incompatible materials of the sample that the spatula shouldn't be made of."}
	}
];
compatibleSpatulas[massToTransfer:MassP, sampleDensity:DensityP|Null, allSpatulaModelPackets_List, destinationAperture:DistanceP|Null, ops:OptionsPattern[]]:=Module[
	{safeOps, filteredSpatulaPacketsByCapacity,allowedSpatulaPacketsByWidth,singleTransferVolume,sortedAllowedSpatulaPacketsByWidth,filteredNarrowEndSpatulas, filteredWideEndSpatulas, minTransferMass},

	(* Get our safe options. *)
	safeOps=SafeOptions[compatibleSpatulas,ToList[ops]];

	(* get spatulas that can use narrow end *)
	filteredNarrowEndSpatulas=If[MatchQ[destinationAperture,DistanceP],
		Cases[
			allSpatulaModelPackets,
			KeyValuePattern[{
				Material -> Except[Alternatives @@ Lookup[safeOps, IncompatibleMaterials]],
				NarrowEndWidth -> LessEqualP[(destinationAperture - 1 Millimeter)]
			}]
		],
		allSpatulaModelPackets
	];

	(* get spatulas that can use wide end *)
	filteredWideEndSpatulas=If[MatchQ[destinationAperture,DistanceP],
		Cases[
			allSpatulaModelPackets,
			KeyValuePattern[{
				Material -> Except[Alternatives @@ Lookup[safeOps, IncompatibleMaterials]],
				WideEndWidth -> LessEqualP[(destinationAperture - 1 Millimeter)]
			}]
		],
		allSpatulaModelPackets
	];

	(* sort spatula by prioritizing filteredWideEndSpatulas over filteredNarrowEndSpatulas *)
	allowedSpatulaPacketsByWidth = DeleteDuplicates[Join[filteredWideEndSpatulas,filteredNarrowEndSpatulas]];

	singleTransferVolume = If[MatchQ[sampleDensity,_Quantity],
		massToTransfer/sampleDensity,
		massToTransfer/$DefaultSampleDensity
	];
	
	(* We ideally want max 5 transfers to do our scoops. *)
	minTransferMass=massToTransfer/5;

	sortedAllowedSpatulaPacketsByWidth = SortBy[
		allowedSpatulaPacketsByWidth,
		{
			(* consider EngineDefault non-False first *)
			Position[{True, Null, False},Lookup[#,EngineDefault]] &,
			
			(* prioritize Polypropylene (non-reusable spatula/spoon and reusable scoops) over StainlessSteel spatula, we only want to use the StainlessSteel ones if Polypropylene is encountered as an IncompatibleMaterial *)
			Position[{Polypropylene, StainlessSteel, Null}, Lookup[#, Material]] &,

			(* ideal spatula capacity is greater than 1/5th of mass to transfer and less than 5x mass to transfer *)
			Position[{True,False,Null},If[MatchQ[sampleDensity, _Quantity],
				MatchQ[Lookup[#,TransferVolume],RangeP[minTransferMass / sampleDensity,(massToTransfer*5)/sampleDensity]],
				MatchQ[Lookup[#,TransferVolume],RangeP[minTransferMass / $DefaultSampleDensity,(massToTransfer*5)/$DefaultSampleDensity]] (* use $DefaultSampleDensity if density is not available *)
			]]&,

			(* if no spatula is of ideal capacity, prefer ones closer to single transfer volume *)
			Abs[Lookup[#,TransferVolume]-singleTransferVolume]&,

			(* non-reusable ones first *)
			Position[{False, Null, True}, Lookup[#, Reusable]]&,
			
			(* individual ones first *)
			Position[{False, Null, True}, Lookup[#, Counted]]&
		}
	];

	(* select spatula with capacity that's not too small (can hold at least 1/5th of amount) and not too big (TransferVolume not more than 5 times the intended mass to be transferred) *)
	filteredSpatulaPacketsByCapacity = Cases[
		sortedAllowedSpatulaPacketsByWidth,
		KeyValuePattern[{
			Material -> Except[Alternatives @@ Lookup[safeOps, IncompatibleMaterials]],
			TransferVolume -> If[MatchQ[sampleDensity, _Quantity],
				RangeP[minTransferMass / sampleDensity,(massToTransfer*5)/sampleDensity],
				RangeP[minTransferMass / $DefaultSampleDensity,(massToTransfer*5)/$DefaultSampleDensity] (* use $DefaultSampleDensity if density is not available *)
			],
			EngineDefault->Except[False]
		}]
	];

	{Download[sortedAllowedSpatulaPacketsByWidth,Object],Download[filteredSpatulaPacketsByCapacity,Object]}

];

DefineOptions[compatiblePipettes,
	Options :> {
		{CultureHandling -> Null, Null | CultureHandlingP, "Indicates the type of culture handling pipette that should be selected for the sample."},
		{GloveBoxStorage -> Null, Null | BooleanP, "Indicates that the type of pipette chosen should be one that permanently resides in the glvoe box, if possible."},
		{SterileTechnique -> Null, Null | BooleanP, "Indicates if the type of pipette chosen should be one that is designated for aseptic transfers."}
	}
];

compatiblePipettes[tipModel : ObjectP[Model[Item, Tips]], allTipModelPackets_List, allPipetteModelPackets_List, volumeToTransfer : (VolumeP | All), myOptions : OptionsPattern[]] := Module[
	{safeOptions, tipModelPacket, tipConnectionType, filteredPipettes, cultureHandlingCompatiblePipettes,
		gloveBoxCompatiblePipettes, finalPipettes, sterileTechnique, sterileCompatiblePipettes},

	(* Get safe options. *)
	safeOptions = SafeOptions[compatiblePipettes, ToList[myOptions]];
	sterileTechnique = Lookup[safeOptions, SterileTechnique];

	(* Lookup our tip model packet. *)
	tipModelPacket = fetchPacketFromCache[tipModel, allTipModelPackets];

	(* Lookup the pipette type of our tips. *)
	tipConnectionType = Lookup[tipModelPacket, TipConnectionType];

	(* Only pick pipettes that are compatible with our tips and can also hold the requested volume. *)
	filteredPipettes = If[MatchQ[volumeToTransfer, All],
		Cases[
			allPipetteModelPackets,
			KeyValuePattern[{
				TipConnectionType -> tipConnectionType
			}]
		],
		Cases[
			allPipetteModelPackets,
			KeyValuePattern[{
				TipConnectionType -> tipConnectionType,
				MaxVolume -> GreaterEqualP[volumeToTransfer],
				MinVolume -> LessEqualP[volumeToTransfer]
			}]
		]
	];

	(* Select a pipette according to the culture handling, if possible. *)
	(* importantly, if this is Null, it excludes things that have CultureHandling set. This is intentional *)
	cultureHandlingCompatiblePipettes = Cases[
		filteredPipettes,
		KeyValuePattern[{
			CultureHandling -> Lookup[safeOptions, CultureHandling]
		}]
	];

	(* Select a pipette according to the glove box usage, if possible. *)
	gloveBoxCompatiblePipettes = If[MatchQ[Lookup[safeOptions, GloveBoxStorage], Null | False],
		cultureHandlingCompatiblePipettes,
		Cases[
			cultureHandlingCompatiblePipettes,
			KeyValuePattern[{
				GloveBoxStorage -> Lookup[safeOptions, GloveBoxStorage]
			}]
		]
	];

	(* Select a pipette according to sterile handling if applicable *)
	(* This is the only way we can end up picking a sterile pipette but we don't have CultureHandling (for aseptic transferring in the Transfer BSCs) *)
	(* importantly this _excludes_ sterile pipettes if SterileTechnique is False.  That is intentional. *)
	sterileCompatiblePipettes = If[TrueQ[sterileTechnique],
		DeleteDuplicates@Join[
			Cases[
				gloveBoxCompatiblePipettes,
				KeyValuePattern[{AsepticHandling -> True}]
			],
			Cases[
				gloveBoxCompatiblePipettes,
				KeyValuePattern[{Sterile -> True}]
			]
		],
		Cases[
			gloveBoxCompatiblePipettes,
			KeyValuePattern[{AsepticHandling -> Except[True], Sterile -> Except[True]}]
		]
	];

	(* Use any pipette if the one with our culture handling/glove boxing/sterility isn't available. *)
	finalPipettes = If[Length[sterileCompatiblePipettes] == 0,
		filteredPipettes,
		sterileCompatiblePipettes
	];

	(* Favor single channel pipettes over multi-channel pipettes, then prefer engine defaults, then sort by volume and resolution leaving filtered tips for last*)
	Download[
		SortBy[
			finalPipettes,
			{
				(Lookup[#, Channels] /. {Null -> 1}&),
				Position[{True, Null, False}, Lookup[#, EngineDefault]]&,
				(Lookup[#, Filtered]&),
				(Lookup[#, MaxVolume]&),
				(Lookup[#, Resolution] /. {Null -> Infinity Microliter}&)
			}
		],
		Object
	]
];

DefineOptions[compatibleSyringes,
	Options:>{
		{IncompatibleMaterials->Null,Null|{(None|MaterialP)...},"Indicates any incompatible materials of the sample that the syringe shouldn't be made of."}
	}
];

compatibleSyringes[needleModel:ObjectP[Model[Item, Needle]], needleModelPackets_List, syringeModelPackets_List, volumeToTransfer:(VolumeP|All), ops:OptionsPattern[]]:=Module[
	{safeOptions,needleModelPacket,connectionType,filteredSyringes,groupedAndSortedSyringes},

	(* Get our safe options. *)
	safeOptions=SafeOptions[compatibleSyringes,ToList[ops]];

	(* Get our needle model packet. *)
	needleModelPacket=fetchPacketFromCache[needleModel, needleModelPackets];

	(* Get the connection type of our needle. *)
	(* if the needle is SlipLuer or LuerLock, that can go on either the SlipLuer or LuerLock syringes *)
	connectionType=Lookup[needleModelPacket, ConnectionType] /. {SlipLuer | LuerLock :> SlipLuer | LuerLock};

	(* Filter the syringes that support this connection type and can also transfer our volume. *)
	filteredSyringes=Cases[
		syringeModelPackets,
		KeyValuePattern[{
			ConnectionType->connectionType,
			If[MatchQ[volumeToTransfer, All],
				Nothing,
				MaxVolume->GreaterEqualP[volumeToTransfer]
			],
			If[MatchQ[Lookup[safeOptions, IncompatibleMaterials], Null|{}|{None}],
				Nothing,
				ContainerMaterials->Except[Alternatives@@Lookup[safeOptions, IncompatibleMaterials]]
			]
		}]
	];

	(* Group the syringes into reusable and disposal and sort each group from smaller to larger in terms of MaxVolume *)
	groupedAndSortedSyringes=GroupBy[filteredSyringes,Lookup[#,Reusable]&,SortBy[#,Function[reusabilityGroup,Lookup[reusabilityGroup,MaxVolume]]]&];

	(* Return a list of flat models *)
	Download[Flatten[Lookup[groupedAndSortedSyringes,{False,Null,True},{}]],Object]
];

DefineOptions[compatibleNeedles,
	Options:>{
		{ConnectionType->All,All|ConnectorP,"Indicates the connection type that the syringe must support.  Note that specifying one of SlipLuer or LuerLock will automatically include the other."},
		{MinimumLength->Null,Null|DistanceP,"The minimum length of the syringes that will be returned."},
		{Blunt -> Null, Null|BooleanP, "Indicates if the tip of the needle is requested to be 90 Degree. If set to True, only blunt-tip needles (Bevel -> 90 Degree) are returned; if set to False, only non-blunt-tip needles are returned. If set to Null, Bevel is not used to screen the needles to return."},
		{Viscous->False, BooleanP,"Indicates if a viscous sample will be transferred using this needle, meaning that we should order the needles returned by larger to smaller gauge."}
	}
];

compatibleNeedles[needleModelPackets_List, ops:OptionsPattern[]]:=Module[
	{safeOps,bevelFilterPattern,connectionType,connectionFilteredNeedlePackets,lengthFilteredNeedlePackets, bevelFilteredNeedlePackets},

	(* Get our safe options. *)
	safeOps=SafeOptions[compatibleNeedles,ToList[ops]];

	(* pull out the connection type here; note that since SlipLuer/LuerLock needles are interchangeable, allow either here  *)
	connectionType = Lookup[safeOps, ConnectionType] /. {SlipLuer | LuerLock :> SlipLuer | LuerLock};

	(* Filter by connection type. *)
	connectionFilteredNeedlePackets=If[MatchQ[connectionType, Except[All]],
		Cases[needleModelPackets, KeyValuePattern[ConnectionType -> connectionType]],
		needleModelPackets
	];

	(* Filter by minimum length. *)
	lengthFilteredNeedlePackets=If[MatchQ[Lookup[safeOps, MinimumLength], Except[Null]],
		Cases[connectionFilteredNeedlePackets, KeyValuePattern[NeedleLength->GreaterEqualP[Lookup[safeOps, MinimumLength]]]],
		connectionFilteredNeedlePackets
	];

	(* filter by Bevel - we can't use needles with Bevel of 90 since they are blunt *)
	bevelFilterPattern = Switch[Lookup[safeOps, Blunt],
		(* Considers only blunt tip needles *)
		True, Bevel -> EqualP[Quantity[90., "AngularDegrees"]],
		(* Considers only sharp needles *)
		False, Bevel -> LessP[Quantity[90., "AngularDegrees"]],
		(* No screening based on Bevel *)
		_, Null
	];
	bevelFilteredNeedlePackets = If[NullQ[bevelFilterPattern],
		(* No screening based on Bevel *)
		lengthFilteredNeedlePackets,
		Cases[lengthFilteredNeedlePackets, KeyValuePattern[bevelFilterPattern]]
	];

	(* If we have a viscous sample, sort by larger to smaller gauge -> then break ties by favoring disposable ones, then sorting by the closest length. *)
	(* If we have a MinimumLength, try to return a needle that's closest to the minimum length. *)
	(* NOTE: A lower gauge number is actually larger. *)
	(* NOTE: Prefer LuerLock and SlipLuer needles over more rare needle ConnectionTypes. This is because we have a wider *)
	(* variety of syringes compatible with these two ConnetionTypes. *)
	Which[
		MatchQ[Lookup[safeOps, Viscous], True] && MatchQ[Lookup[safeOps, MinimumLength], Except[Null]],
			Download[
				SortBy[
					bevelFilteredNeedlePackets,
					{
						(First@FirstPosition[{LuerLock, SlipLuer}, Lookup[#, ConnectionType], {Infinity}] &),
						(* favor disposable needles even more in Viscous fluid case. Note that given our current available needle models, disposable ones do not fail the Gauge competition at any length. *)
						(First@FirstPosition[{False, True}, Lookup[#, Reusable], {Infinity}] &),
						(Lookup[#, Gauge]&),
						(Lookup[#, NeedleLength] - Lookup[safeOps, MinimumLength]&)
					}
				],
				Object
			],
		MatchQ[Lookup[safeOps, Viscous], True],
			Download[
				SortBy[
					bevelFilteredNeedlePackets,
					{
						(First@FirstPosition[{LuerLock, SlipLuer}, Lookup[#, ConnectionType], {Infinity}]&),
						(* favor disposable needles even more in Viscous fluid case. Note that given our current available needle models, disposable ones do not fail the Gauge competition at any length. *)
						(First@FirstPosition[{False, True}, Lookup[#, Reusable], {Infinity}] &),
						(Lookup[#, Gauge]&)
					}
				],
				Object
			],
		MatchQ[Lookup[safeOps, MinimumLength], Except[Null]],
			Download[
				SortBy[
					bevelFilteredNeedlePackets,
					{
						(First@FirstPosition[{LuerLock, SlipLuer}, Lookup[#, ConnectionType], {Infinity}]&),
						(First@FirstPosition[{False, True}, Lookup[#, Reusable], {Infinity}] &),
						(Lookup[#, NeedleLength] - Lookup[safeOps, MinimumLength]&)
					}
				],
				Object
			],
		True,
			Download[
				SortBy[
					bevelFilteredNeedlePackets,
					{
						First@FirstPosition[{LuerLock, SlipLuer}, Lookup[#, ConnectionType], {Infinity}]&,
						(First@FirstPosition[{False, True}, Lookup[#, Reusable], {Infinity}] &)
					}
				],
				Object
			]
	]
];

DefineOptions[compatibleMagneticRacks,
	Options:>{}
];

compatibleMagneticRacks[workingSourceContainerModelPacket:PacketP[], allRackModelPackets_List, ops:OptionsPattern[]]:=Module[
	{safeOps,magneticRacks,workingFootprint},

	(* Get our safe options. *)
	safeOps=SafeOptions[compatibleNeedles,ToList[ops]];

	(* Only use racks that are magnetized. *)
	magneticRacks=Cases[allRackModelPackets, KeyValuePattern[Magnetized->True]];

	(* Only use racks that have a spot open for our working container's footprint. *)
	workingFootprint=Lookup[workingSourceContainerModelPacket, Footprint];

	Lookup[
		Cases[
			magneticRacks,
			KeyValuePattern[Positions->_?(MemberQ[Lookup[#, Footprint], workingFootprint]&)]
		],
		Object
	]
];


(* creating a bulk source water and waste sample/container doesn't need to happen every single time we call simulateExperimentTransfer; it's independent of state and thus we can just memoize it *)
simulateWaterAndWasteSamples[stringInput_]:=simulateWaterAndWasteSamples[stringInput]=Module[
	{fakeContainerPackets, fakeWaterSampleContainerObject, fakeWasteSampleContainerObject, currentSimulation,
		fakeWaterAndWastePackets, fakeWaterSample, fakeWasteSample},

	If[!MemberQ[$Memoization, Experiment`Private`simulateWaterAndWasteSamples],
		AppendTo[$Memoization, Experiment`Private`simulateWaterAndWasteSamples]
	];

	(* Make a fake water sample with 20L of volume so that we can use it whenever we are asked to transfer in *)
	(* Model[Sample, "Milli-Q water"] since we don't actually make a resource for our water sample if we're going to *)
	(* get it straight from the water purifier. Also make a fake waste sample. *)
	fakeContainerPackets = UploadSample[
		{Model[Container, Vessel, "id:3em6Zv9NjjkY"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]},
		{
			{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]}, (* Object[Container, Room, "Empty Room for Simulated Objects"] *)
			{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]} (* Object[Container, Room, "Empty Room for Simulated Objects"] *)
		},
		FastTrack -> True,
		SimulationMode -> True,
		Upload -> False
	];
	{fakeWaterSampleContainerObject, fakeWasteSampleContainerObject} = Lookup[fakeContainerPackets[[1;;2]], Object];

	(* Update it with the container packets. *)
	currentSimulation = Simulation[fakeContainerPackets];

	(* Put some water in our container. *)
	fakeWaterAndWastePackets = UploadSample[
		{
			Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *),
			Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
		},
		{
			{"A1", fakeWaterSampleContainerObject},
			{"A1", fakeWasteSampleContainerObject}
		},
		State->Liquid,
		InitialAmount->{$MaxTransferVolume, Null},
		Simulation -> currentSimulation,
		SimulationMode -> True,
		FastTrack -> True,
		Upload -> False
	];

	{fakeWaterSample, fakeWasteSample} = Lookup[fakeWaterAndWastePackets[[1;;2]], Object];

	(* Update it with the sample packets. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[fakeWaterAndWastePackets]];

	(* return four things, all of which simulateExperimentTransfer wants *)
	(* this is admittedly a very goofy thing to return; the point of it is that we're memoizing two UploadSample calls so this makes a substantial difference performance-wise *)
	(* 1.) the {fakeWaterSample, fakeWasteSample} pair *)
	(* 2.) the {fakeWaterSampleContainerObject, fakeWasteSampleContainerObject} pair *)
	(* 3.) the fakeWaterAndWastePackets cache we'll use later *)
	(* 4.) the simulation that we'll use to update whatever simulation we already had in our simulateExperimentTransfer call *)
	{
		{fakeWaterSample, fakeWasteSample},
		{fakeWaterSampleContainerObject, fakeWasteSampleContainerObject},
		fakeWaterAndWastePackets,
		currentSimulation
	}
];

(* NOTE: Excess pattern checking here makes calling the helper function slow so the real patterns *)
(* are commented out. *)
(* NOTE: This function can be slow (~10ms) because of InverseFunction. If there is a better way to invert the function *)
(* and cache it, we can make this function faster. Right now, for about 50 samples, it takes about 5 seconds just in the *)
(* option resolver map thread because of this function being called a lot. *)

(* due to all the reasons above, the function is split between Hamilton case and non-Hamilton case + Hamilton case is memoized now *)
tipsCanAspirateQ[
	myTips:ObjectP[Model[Item,Tips]],
	myContainerModelPacket:PacketP[Model[Container]],
	myVolume:VolumeP,
	myVolumeToAspirate:VolumeP,
	myTipPackets_List, (* {(PacketP[Model[Item,Tips]]|Null)..} *)
	myVolumeCalibrationPackets_List (* {(PacketP[{Object[Calibration, Volume]}]|Null)...} *)
]:=Module[{tipPacket, hamiltonQ, latestVolumeCalibrationPacket},

	tipPacket=fetchPacketFromCache[myTips, myTipPackets];
	hamiltonQ=MatchQ[Lookup[tipPacket, PipetteType], Hamilton];
	latestVolumeCalibrationPacket = fetchPacketFromCache[
		LastOrDefault[Lookup[myContainerModelPacket, VolumeCalibrations]],
		myVolumeCalibrationPackets
	];

	If[hamiltonQ,
		tipsCanAspirateQCoreHamilton[myTips, myContainerModelPacket, tipPacket, latestVolumeCalibrationPacket],
		tipsCanAspirateQCore[myTips, myContainerModelPacket, myVolume, myVolumeToAspirate, tipPacket, latestVolumeCalibrationPacket]
	]
];
(* Hamilton case *)
tipsCanAspirateQCoreHamilton[
	myTips:ObjectP[Model[Item,Tips]],
	myContainerModelPacket:PacketP[Model[Container]],
	tipPacket_Association, (* (PacketP[Model[Item,Tips]]) *)
	latestVolumeCalibrationPacket:(_Association|Null) (* PacketP[{Object[Calibration, Volume]}] *)
]:=tipsCanAspirateQCoreHamilton[myTips, myContainerModelPacket, tipPacket, latestVolumeCalibrationPacket]=Module[
	{aspirationDepthsAtApertures,maxDepthTipsCanReach,liquidHeightAfterAspiration,containerHeight,maximumTipWidth,minimumContainerWidth},

	If[!MemberQ[$Memoization, Experiment`Private`tipsCanAspirateQCoreHamilton],
		AppendTo[$Memoization, Experiment`Private`tipsCanAspirateQCoreHamilton]
	];

	(* pull AspirationDepth out of the tip packet *)
	aspirationDepthsAtApertures=Lookup[tipPacket,AspirationDepth];

	(* Figure out the maximum depth that the tips can reach into our container, based on the aperture. *)
	(* NOTE: We can't just do a straight geometry calculation here because we have to factor in the geometry of the *)
	(* pipette as well when sticking into the aperture. That's why we still have this AspirationDepth field. *)
	maxDepthTipsCanReach=Module[{sourceAperture, sortedAspirationDepthsAtApertures, aspirationDepthAtClosestAperture},
		(* Figure out what the aperture of our container is. *)
		sourceAperture=Switch[myContainerModelPacket,
			PacketP[Model[Container,Plate]],
			Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellDimensions,WellDiameter}],Null]],
			PacketP[{Model[Container]}],
			Lookup[myContainerModelPacket,Aperture],
			_,
			Null
		];

		(* If any information is missing, assume the tips can't reach the bottom. *)
		If[
			Or[
				MatchQ[aspirationDepthsAtApertures,{}],
				MatchQ[sourceAperture,NullP]
			],
			Return[False, Module]
		];

		(* Sort the {{aperture,aspiration depth}..} list by aperture*)
		sortedAspirationDepthsAtApertures=Prepend[SortBy[aspirationDepthsAtApertures,First],{0 Meter,0 Meter}];

		(* Get the last entry with an aperture larger than that of the source aperture *)
		aspirationDepthAtClosestAperture=Last[DeleteCases[
			sortedAspirationDepthsAtApertures,
			_?(First[#]>sourceAperture &)
		]];

		Last[aspirationDepthAtClosestAperture]
	];

	(* What is the maximum height of the container? Look for InternalDepth first; if not available, use Z-dimension which is external height as estimate. *)
	containerHeight=Which[
		MatchQ[Lookup[myContainerModelPacket, InternalDepth], DistanceP], Lookup[myContainerModelPacket, InternalDepth],
		MatchQ[Lookup[myContainerModelPacket, Dimensions], _List], Lookup[myContainerModelPacket, Dimensions][[3]],
		True, 0 Meter
	];

	(* For robotic tips we only care about tips reaching the bottom of the container *)
	liquidHeightAfterAspiration=0 Millimeter;

	(* Can the tips perform the aspiration? *)
	(* NOTE: We already included a small extra buffer in our liquidHeightAfterAspiration calculation above. *)
	If[!MatchQ[maxDepthTipsCanReach, GreaterEqualP[containerHeight-liquidHeightAfterAspiration]],
		Return[False];
	];

	(* Get the maximum width of the tips based on how much we're sticking into the container. *)
	maximumTipWidth=Max@@Append[
		Cases[Lookup[tipPacket, Diameter3D], {LessEqualP[containerHeight-liquidHeightAfterAspiration], _}][[All,2]],
		0 Millimeter
	];

	(* Get the minimum width of the container in the portion that we'll be sticking the tip into. *)
	minimumContainerWidth=Min@@Append[
		Cases[Lookup[myContainerModelPacket, InternalDiameter3D], {GreaterEqualP[liquidHeightAfterAspiration], _}][[All,2]],
		0 Millimeter
	];

	(* Will there be any physical obstructions between the tips and the container? *)
	If[!MatchQ[maximumTipWidth, GreaterEqualP[minimumContainerWidth]],
		Return[False];
	];

	(* All checks passed. *)
	True
];

(* general case *)
tipsCanAspirateQCore[
	myTips:ObjectP[Model[Item,Tips]],
	myContainerModelPacket:PacketP[Model[Container]],
	myVolume:VolumeP,
	myVolumeToAspirate:VolumeP,
	tipPacket_Association, (* (PacketP[Model[Item,Tips]]) *)
	latestVolumeCalibrationPacket:(_Association|Null) (* PacketP[{Object[Calibration, Volume]}] *)
]:=Module[
	{aspirationDepthsAtApertures,maxDepthTipsCanReach,liquidHeightAfterAspiration,containerHeight,maximumTipWidth,minimumContainerWidth},

	(* pull AspirationDepth out of the tip packet *)
	aspirationDepthsAtApertures=Lookup[tipPacket,AspirationDepth];

	(* Figure out the maximum depth that the tips can reach into our container, based on the aperture. *)
	(* NOTE: We can't just do a straight geometry calculation here because we have to factor in the geometry of the *)
	(* pipette as well when sticking into the aperture. That's why we still have this AspirationDepth field. *)
	maxDepthTipsCanReach=Module[{sourceAperture, sortedAspirationDepthsAtApertures, aspirationDepthAtClosestAperture},
		(* Figure out what the aperture of our container is. *)
		sourceAperture=Switch[myContainerModelPacket,
			PacketP[Model[Container,Plate]],
				Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellDimensions,WellDiameter}],Null]],
			PacketP[{Model[Container]}],
				Lookup[myContainerModelPacket,Aperture],
			_,
				Null
		];

		(* If any information is missing, assume the tips can't reach the bottom. *)
		If[
			Or[
				MatchQ[aspirationDepthsAtApertures,{}],
				MatchQ[sourceAperture,NullP]
			],
			Return[False, Module]
		];

		(* Sort the {{aperture,aspiration depth}..} list by aperture*)
		sortedAspirationDepthsAtApertures=Prepend[SortBy[aspirationDepthsAtApertures,First],{0 Meter,0 Meter}];

		(* Get the last entry with an aperture larger than that of the source aperture *)
		aspirationDepthAtClosestAperture=Last[DeleteCases[
			sortedAspirationDepthsAtApertures,
			_?(First[#]>sourceAperture &)
		]];

		Last[aspirationDepthAtClosestAperture]
	];

	(* What is the maximum height of the container? Look for InternalDepth first; if not available, use Z-dimension which is external height as estimate. *)
	containerHeight=Which[
		MatchQ[Lookup[myContainerModelPacket, InternalDepth], DistanceP], Lookup[myContainerModelPacket, InternalDepth],
		MatchQ[Lookup[myContainerModelPacket, Dimensions], _List], Lookup[myContainerModelPacket, Dimensions][[3]],
		True, 0 Meter
	];

	(* Now figure out the height of the liquid will be in the container and make sure liquid surface is still reachable after aspiration. *)
	liquidHeightAfterAspiration=Module[
		{calibrationQuantityFunction,rawCalibrationFunction,inverseFunction,
			inputUnit,outputUnit,distanceDerivedFromCalibration,heightFromContainerBottom},

		(* If we didn't get a volume calibration, assume the worst case. *)
		If[!MatchQ[latestVolumeCalibrationPacket, PacketP[Object[Calibration, Volume]]],
			Return[0 Millimeter, Module];
		];

		(* Get the volume calibration function. *)
		calibrationQuantityFunction=Lookup[latestVolumeCalibrationPacket, CalibrationFunction];

		(* Our calibration function is a QuantityFunction[rawFunction, ListableP[inputUnits], outputUnit]. *)
		(* Pull out the raw function and invert it since we want to go from volume to distance. *)
		rawCalibrationFunction=calibrationQuantityFunction[[1]];

		(* Now get the input units. It's listable so pull out the first distance. *)
		(* NOTE: The input and output unit will get swapped since we're inverting the function. *)
		inputUnit=FirstCase[calibrationQuantityFunction[[2]], DistanceP];
		outputUnit=calibrationQuantityFunction[[3]];

		(* Attempt to invert the function. If we didn't get another function out, then InverseFunction didn't work. *)
		inverseFunction=Quiet[InverseFunction[rawCalibrationFunction]];

		(* Convert to the input unit, strip off the unit, then tack on the output unit. *)
		(* NOTE: Include a little buffer in the amount that we're aspirating to be safe. *)
		(* NOTE: The calibration function used to give us the distance from the volume sensor, which is at the top of the container. *)
		(* However, this is no longer true. Calibrations now return the height from the inside of the container bottom so the below has been updated. *)
		(* NOTE: InverseFunction does not work on piecewise functions so we need to solve analytically if we have a piecewise. *)
		distanceDerivedFromCalibration=If[MatchQ[inverseFunction, Verbatim[InverseFunction][___]],
			(* Solve analytically. *)
			Module[{uniqueVariable},
				uniqueVariable=Unique[t];

				Lookup[
					FirstCase[
						Quiet@Solve[
							(* volume = calibrationFunction (with #1 subbed with t so we can solve for t). *)
							Unitless[UnitConvert[Max[{1 Microliter, myVolume - (myVolumeToAspirate*1.05)}], outputUnit]]==(rawCalibrationFunction[[1]]/.{#->uniqueVariable}),
							uniqueVariable,
							Reals
						],
						(* get the first solution that returns a non-negative value *)
						{uniqueVariable->GreaterEqualP[0]},
						(* If there is no analytical solution, assume the bottle is empty (so it's all the way at the bottom). Set the uniqueVariable as either containerHeight or 0 depending on the characteristic of volume calibration function. *)
						{uniqueVariable->If[rawCalibrationFunction[2]<rawCalibrationFunction[1],Unitless[containerHeight],0]},
						(* don't remove the levelspec or this function will error out *)
						{1}
					],
					uniqueVariable
				] * inputUnit
			],
			(* Use our symbolic function. *)
			inverseFunction[
				Unitless[UnitConvert[Max[{1 Microliter, myVolume - (myVolumeToAspirate*1.05)}], outputUnit]]
			] * inputUnit
		];

		(* NOTE: Calibration Function of containers might reports distance of either DepthFromTop or HeightFromBottom. *)
		(* Check whether Calibration Function is monotone decreasing, which means reporting distance as DepthFromTop; if true, convert distanceDerivedFromCalibration to the distance relative to container bottom. *)
		heightFromContainerBottom = Max[
			If[rawCalibrationFunction[2]<rawCalibrationFunction[1],
				containerHeight-distanceDerivedFromCalibration,
				distanceDerivedFromCalibration
			],
			0 Millimeter
		]
	];

	(* Can the tips perform the aspiration? *)
	(* NOTE: We already included a small extra buffer in our liquidHeightAfterAspiration calculation above. *)
	If[!MatchQ[maxDepthTipsCanReach, GreaterEqualP[containerHeight-liquidHeightAfterAspiration]],
		Return[False];
	];

	(* Get the maximum width of the tips based on how much we're sticking into the container. *)
	maximumTipWidth=Max@@Append[
		Cases[Lookup[tipPacket, Diameter3D], {LessEqualP[containerHeight-liquidHeightAfterAspiration], _}][[All,2]],
		0 Millimeter
	];

	(* Get the minimum width of the container in the portion that we'll be sticking the tip into. *)
	minimumContainerWidth=Min@@Append[
		Cases[Lookup[myContainerModelPacket, InternalDiameter3D], {GreaterEqualP[liquidHeightAfterAspiration], _}][[All,2]],
		0 Millimeter
	];

	(* Will there be any physical obstructions between the tips and the container? *)
	If[!MatchQ[maximumTipWidth, GreaterEqualP[minimumContainerWidth]],
		Return[False];
	];

	(* If the container is a Cuvette, are we using a serological pipette? *)
	If[MatchQ[myContainerModelPacket,PacketP[Model[Container,Cuvette]]] && MatchQ[Lookup[tipPacket,TipConnectionType], Serological],
		Return[False];
     ];

	(* All checks passed. *)
	True
];

(* ::Subsection:: *)
(* resolveTransferWorkCell *)

DefineOptions[resolveExperimentTransferWorkCell,
	SharedOptions :> {
		ExperimentTransfer,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveExperimentTransferWorkCell[
	mySources:ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}],
	myDestinations:ListableP[ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}]|{_Integer,ObjectP[Model[Container]]}|{_String,ObjectP[Object[Container]]}|Waste],
	myAmounts:ListableP[VolumeP|MassP|CountP|All],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, cache, simulation, workCell, preparation, sterileTechnique},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveExperimentTransferWorkCell, ToList[myOptions]];
	{cache, simulation} = Lookup[safeOptions, {Cache, Simulation}];

	{workCell, preparation, sterileTechnique} = Lookup[myOptions, {WorkCell, Preparation, SterileTechnique}, Automatic];

	(* Determine the WorkCell that can be used *)
	If[MatchQ[workCell, WorkCellP|Null],
		(* If WorkCell is specified, use that *)
		{workCell}/.{Null} -> {},
		(* Otherwise, use helper function to resolve potential work cells based on experiment options and sample properties *)
		resolvePotentialWorkCells[Cases[Flatten[{mySources, myDestinations}], ObjectP[{Object[Sample], Object[Container], Model[Sample], Model[Container]}]], {Preparation -> preparation, SterileTechnique -> sterileTechnique}, Cache -> cache, Simulation -> simulation]
	]
];

(* Authors definition for Experiment`Private`tipsCanAspirateQ *)
Authors[Experiment`Private`tipsCanAspirateQ]:={"malav.desai", "waseem.vali", "thomas"};

(* helper to give a part of the 384-well plate that is being used for 96-head transfer *)
map384[well_String]:=With[{
	option1=#[[;;;;2]] &/@AllWells[NumberOfWells->384][[;;;;2]],
	option2=#[[;;;;2]] &/@AllWells[NumberOfWells->384][[2;;;;2]],
	option3=#[[2;;;;2]] &/@AllWells[NumberOfWells->384][[;;;;2]],
	option4=#[[2;;;;2]] &/@AllWells[NumberOfWells->384][[2;;;;2]]
},
	Which[
		MemberQ[Flatten@option1,well],option1,
		MemberQ[Flatten@option2,well],option2,
		MemberQ[Flatten@option3,well],option3,
		MemberQ[Flatten@option4,well],option4
	]
];


(* This function generates a mimic of the pipette dial at the correct volume setting for the batched transfers. *)
DefineOptions[
	generatePipetteDialImage,
	Options :> {
		UploadOption
	}
];

(* a home-drawn pipette base image resource *)
pipetteDialBackgroundImage[in_String] := Set[
	pipetteDialBackgroundImage[in],
	(
		If[!MemberQ[$Memoization, Experiment`Private`pipetteDialBackgroundImage],
			AppendTo[$Memoization, Experiment`Private`pipetteDialBackgroundImage]
		];
		ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard12/8dbc3ac9f1d6b88ef210e28f66f20d96.jpg", ""]]
	)
];

generatePipetteDialImage[
	amountsAsVolume:_List,
	instrumentMaxVolumes_List,
	instrumentResolutions_List,
	instrumentChannels_List,
	instrumentPipetteTypes_List,
	myOptions:OptionsPattern[]
] := Module[{safeOps, upload, pipetteBackground},

	(* get safe options *)
	safeOps = SafeOptions[generatePipetteDialImage, ToList[myOptions]];

	(* see if we are uploading or not *)
	upload = Lookup[safeOps, Upload];

	(* get the pipette base image resource, this is hard coded and memoized *)
	pipetteBackground = pipetteDialBackgroundImage["Memoization"];

	MapThread[
		Function[{transferAmount, maxPipetVolume, pipetteModelResolution, pipetteModelChannel, pipetteModelType},
			Module[{ p2Point5Bool, p10MultichannelBool, p20Bool, p100MultichannelBool, unitlessTransferAmount, unitlessTransferAmountStringList,
				p200Bool, p200MultichannelBool, p1000Bool, p5000Bool, unitlessTransferAmountStringListWithDash, pipetteDialMimicString},

				(* if we are not dealing with a volume amount, return early *)
				If[!MatchQ[transferAmount, VolumeP], Return[Null, Module]];

				(* Sort the pipette used into model groups based on properties like resolution and max volume, we are doing this instead of matching to Model to prevent hardcoding model IDs *)
				p2Point5Bool = And[
					EqualQ[maxPipetVolume, Quantity[0.0025, "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[0.002, "Microliters"]],
					pipetteModelChannel === 1,
					pipetteModelType === Micropipette
				];
				p10MultichannelBool = And[
					EqualQ[maxPipetVolume, Quantity[0.01, "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[0.01, "Microliters"]],
					pipetteModelChannel === 1,
					pipetteModelType === Micropipette
				];

				(* Includes p20 Multichannel pipettes only present at ECL-CMU *)
				p20Bool = And[
					EqualQ[maxPipetVolume, Quantity[0.02, "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[0.02, "Microliters"]],
					pipetteModelType === Micropipette
				];
				p100MultichannelBool = And[
					EqualQ[maxPipetVolume, Quantity[0.1, "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[0.1, "Microliters"]],
					pipetteModelChannel === 1,
					pipetteModelType === Micropipette
				];
				p200Bool = And[
					EqualQ[maxPipetVolume, Quantity[0.2, "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[0.2, "Microliters"]],
					pipetteModelChannel === 1,
					pipetteModelType === Micropipette
				];

				(* Includes p300 multichannel pipettes with max volume set at 200uL *)
				p200MultichannelBool = And[
					EqualQ[maxPipetVolume, Quantity[0.2, "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[0.1, "Microliters"]],
					pipetteModelChannel === 1,
					pipetteModelType === Micropipette
				];

				(* Includes p1200 multichannel pipettes with max volume set at 1mL *)
				p1000Bool = And[
					EqualQ[maxPipetVolume, Quantity[1., "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[1., "Microliters"]],
					pipetteModelType === Micropipette
				];
				p5000Bool = And[
					EqualQ[maxPipetVolume, Quantity[5., "Milliliters"]],
					EqualQ[pipetteModelResolution, Quantity[5., "Microliters"]],
					pipetteModelChannel === 1,
					pipetteModelType === Micropipette
				];

				(* Remove units from transfer amount and separate them into a list of individual strings. *)
				(* Then replace decimals with dashes for air pipettes and remove decimals for positive displacement pipettes *)

				(* for most pipettes that would not go > 1mL, it is fine to round them to Microliter *)
				(* for P1000 and P5000 pipettes, round amount to Milliliter to make sure we display "1|250" for 1250uL instead of "1250|" *)
				unitlessTransferAmount = N[QuantityMagnitude[transferAmount, If[p5000Bool, Milliliter, Microliter]]];

				unitlessTransferAmountStringList = Characters[ToString[unitlessTransferAmount]];

				unitlessTransferAmountStringListWithDash = unitlessTransferAmountStringList /. "." :> "\[LongDash]";

				(* Based on the grouping of the pipette, mimic what the pipette dial setting should look like *)
				(* In some scenarios, we need to add zeros at the front or back *)

				pipetteDialMimicString = Which[

					(* For p2.5, and p5000 models, we will not have insignificant zeros in front, since the largest decimal place on the dial is 1.Microliter/Milliliter *)
					(* In cases where volume transferred is < 1uL, the 0 will be present in volume fields and will always show up *)
					(* Therefore, only pad zeros to the mimic string until a total length of 5, 4 for digits, 1 for the dash *)
					(* For example, 2uL needs to be {2,—,0,0,0} *)

					Or[p2Point5Bool, p5000Bool],
					PadRight[unitlessTransferAmountStringListWithDash, 5, "0"],

					(* For p10, p100, and p1000 air pipettes, we will have one insignificant zero in front *)
					(* Therefore, prepend 1 zero if volume transferred is less than max volume of the pipette, then pad zeros until final length of 5 *)
					(* For example, 1uL needs to be {0,1,—,0,0} *)

					Or[p10MultichannelBool, p100MultichannelBool, p1000Bool],
					PadRight[
						If[!EqualQ[transferAmount, maxPipetVolume],
							Prepend[unitlessTransferAmountStringListWithDash, "0"],
							unitlessTransferAmountStringListWithDash
						],
						5, "0"
					],

					(* For all other pipette groups, we need to write out padding logic individually, as we might have transfer volumes that do not have significant zeros *)
					(* in front, but the transferred amount is still less than the max volume of the pipette model *)
					(* For example, 10uL in p20 will need to be {1,0,—,0,0}, so we will need to account for cases where transfer volume >10uL and do not prepend 0 *)
					(* As well as cases where transfer volume <10uL and need to prepend 0 *)
					p20Bool,
					If[(transferAmount >= QuantityArray[10, "Microliters"]),
						PadRight[unitlessTransferAmountStringListWithDash, 5, "0"],
						PadRight[(Prepend[unitlessTransferAmountStringListWithDash, "0"]), 5, "0"]
					],

					Or[p200Bool, p200MultichannelBool],
					If[(transferAmount >= QuantityArray[100, "Microliters"]),
						PadRight[unitlessTransferAmountStringListWithDash, 5, "0"],
						PadRight[(Prepend[unitlessTransferAmountStringListWithDash, "0"]), 5, "0"]
					],

					True, Nothing
				];

				(* If we matched to a mimicable pipette, take the mimic string and add another layer of list structure so it can be transposed into individual elements, then into a vertical fprm through Grid[] *)
				If[!MatchQ[pipetteDialMimicString, Nothing],
					Module[{verticalMimicString, finalDialImage},
						verticalMimicString = Grid[Transpose[{pipetteDialMimicString}], Frame -> True, Alignment -> Center];

						(* compose the pipette image *)
						finalDialImage = ImageCompose[pipetteBackground, Magnify[Rasterize[verticalMimicString], 2], Scaled[{0.365, 0.34}]];

						(* Rasterize the mimic string to obtain an output image, block $DisableVerbosePrinting True to not show constellation message of cloud file upload *)
						Block[{$DisableVerbosePrinting = True}, UploadCloudFile[finalDialImage, Upload -> upload]]
					],

					(* If we did not match to a mimicable pipette, do nothing which will leave the Field as Null. Instructions are to use the image if generated so no image should not cause alarm. *)
					Null
				]
			]
		],
		{amountsAsVolume, instrumentMaxVolumes, instrumentResolutions, instrumentChannels, instrumentPipetteTypes}
	]
];



(*helper to estimate the caprack resources needed for manual batched unit operation. Mainly for putting stuffs inside BSC when setting up to avoid repetitively exit HandsFreeOperation, grab cap rack, decontaminate, and reenter HandsFreeOperation.*)
(* Although it is used to populate batched unit operations, it is estimated for the whole expeirment call, so that we bring in enough cap racks in the initial Setup Transfer Environment. This will tend to overestimate the number of cap racks needed, but will be capped at 6. If the number of cap racks needed is estimated to be larger than that, we don't want to overcrowd the surface since the experiment is already large. *)
estimateCapRackResources[
	myContainers:{ObjectP[{Object[Container],Model[Container]}]..},
	myFastAssoc_Association
]:=Module[
	{duplicateFreeContainerObjects,containerModels,capRackCompatibleCoverTypeP,maxNumCapRacks,numCapRacks,containerObjectCovers,coveredContainerObjects,uncoveredContainerObjectModels,capRackNeededQForCoveredContainerObjects,capRackNeededQBaseOnContainerModels},


	(*Start with getting a number of containers that potentially need cap racks. This include duplicate-free objects (as the cap rack can be reused), and keep-duplicate models*)
	duplicateFreeContainerObjects = DeleteDuplicates[Cases[myContainers,ObjectP[Object[Container,Vessel]]]];
	containerModels = Cases[myContainers,ObjectP[Model[Container,Vessel]]];

	(*Define cover types that might use cap racks. Need to be revisited in case there will be more types added to CoverTypeP for biology experiments.*)
	capRackCompatibleCoverTypeP = Screw|Snap|Place;
	(*Define a max number to bring in BSC in case we have other ideas in future*)
	maxNumCapRacks = 6;

	(*Get a list of container object covers. If a container is covered, we use the cover information, otherwise we treat it the same as a container model*)
	containerObjectCovers = fastAssocLookup[myFastAssoc,duplicateFreeContainerObjects, Cover];

	(*Get a list of covered container objects*)
	coveredContainerObjects = PickList[duplicateFreeContainerObjects,containerObjectCovers,ObjectP[]];

	(*Look up the models for the uncovered container objects*)
	uncoveredContainerObjectModels = fastAssocLookup[myFastAssoc,Complement[duplicateFreeContainerObjects,coveredContainerObjects],Model];

	(*For Object[Container], if the cover type is Object[Item,Cap] and the cover is reusable, a caprack is reserved*)
	(*Note that even if the container object does not have a cover populated. It should before entering BSC, and will be caught by other errors. If it is really not covered at the time of running into this helper, we guestimate it using the container's model similarly as below*)
	capRackNeededQForCoveredContainerObjects = Map[
		Function[{containerCover},
			Module[{coverReusable,coverType},
				(*Look up cover type and if it is reusable*)
				coverReusable = fastAssocLookup[myFastAssoc, containerCover, Reusable];
				coverType = fastAssocLookup[myFastAssoc, containerCover, {Model, CoverType}];

				(*Return boolean indicating if cap rack is needed for this cover. True if the cover type is cap-rack-compatible and it is reusable*)
				And[
					MatchQ[coverType,capRackCompatibleCoverTypeP],
					TrueQ[coverReusable]
				]
			]
		],
		Cases[containerObjectCovers,ObjectP[]]
	];
	(*For Model[Container] and uncovered Object[Container]'s model, it is not covered yet, we guestimate based on the CoverType. If the CoverTypes is contain any cap-rack-compatible one, a cap rack is reserved*)
	capRackNeededQBaseOnContainerModels = Map[
			MemberQ[
				fastAssocLookup[myFastAssoc,#,CoverTypes],
				capRackCompatibleCoverTypeP
			]&,
		Join[containerModels,uncoveredContainerObjectModels]
	];
	(*Calculate number of cap racks to generate resources for. If estimation is larger than the max defined above use max to save space.*)
	numCapRacks = Min[
		Count[Join[capRackNeededQForCoveredContainerObjects,capRackNeededQBaseOnContainerModels],True],
		maxNumCapRacks
	];

	(*Final resources*)
	Table[
		Resource[Sample -> Model[Container, Rack, "id:1ZA60vLllqk8"], Name -> CreateUUID[](* Universal Cap Rack *)],
		numCapRacks
	]
];


(* ::Subsubsection:: *)
(*resolveModelSampleContainer*)
(* this helper tries to resolve a container given a model sample, as Transfer really needs the container information of a source to decide options like Tips, Instrument, Needle etc *)
DefineOptions[
	resolveModelSampleContainer,
	Options :> {
		CacheOption,
		SimulationOption,
		(* allow listable Object or Null pattern, if given a list, make sure the list is index matched to mySampleModels, or a single Null so we can expand *)
		{PreparedResources -> Null, (ObjectP[Object[Resource, Sample]] | Null) | {(ObjectP[Object[Resource, Sample]] | Null)..}, "For each sample model, resources in the ParentProtocol that will be satisfied by preparation of the requested reference electrode models. If given a list, this option must be index matched to the input model list."},
		(* borrow these options from ModelInstances so they remain up to date with what the real default is there *)
		{ExactAmount -> False, BooleanP | {BooleanP..}, "For each sample model, indicates if the exact amount (taking into account Tolerance, if specified) if required to fulfill a sample. If given a list, this option must be index matched to the input model list."},
		{Tolerance -> Null, (singletonAmountP | Null) | {(singletonAmountP | Null)..}, "For each sample model, the amount of Volume/Mass/Count that can deviate from the requested Amount if ExactAmount->True and still have the Object[Sample] count as fulfillable. If given a list, this option must be index matched to the input model list."},
		(* default incubate to false, if given a list, make sure the list is index matched to mySampleModels, or a single boolean so we can expand *)
		{Incubate -> False, BooleanP | {BooleanP..}, "For each sample model, indicates if incubation/mix is needed. If given a list, this option must be index matched to the input model list."},
		{Density -> Null, (GreaterP[(0 Gram)/Milliliter] | Null) | {(GreaterP[(0 Gram)/Milliliter] | Null)..}, "For each sample model, indicates the density to use. If given a list, this option must be index matched to the input model list."}
	}
];


resolveModelSampleContainer[
	(* list of Model[Sample]s *)
	mySampleModels:{ObjectP[Model[Sample]]..},
	(* the amount in volume for each Model[Sample], index matched to mySampleModels *)
	myAmounts:{singletonAmountP..},
	(* parent protocol *)
	myParentProtocol:(ObjectP[] | Null),
	(* root protocol *)
	myRootProtocol:(ObjectP[] | Null),
	(* sterile booleans, index matched to mySampleModels *)
	mySterileBooleans:{(BooleanP | Null)..},
	(* resolved method *)
	myPreparation:PreparationMethodP,
	myOptions:OptionsPattern[]
] := Module[
	{
		safeOps, cache, simulation, suppliedExactAmountQs, suppliedTolerance, fastCache, waterPositions, modelAmountTuplesNoWater, allowedNotebooks, availableSamples, availableSampleDownloadResult, availableSampleContainerModelList, availableSampleContainerModelListWithWater,
		sampleModelPackets, allIncompatibleMaterials, suppliedNeedIncubateQs, expandedNeedIncubateQs, suppliedPreparedResourcesOption, expandedPreparedResources, suppliedDensities, expandedDensities, canConsolidateQs, modelToCanConsolidateQLookup
	},

	(* get safe options *)
	safeOps = SafeOptions[resolveModelSampleContainer, ToList[myOptions]];
	{cache, simulation, suppliedExactAmountQs, suppliedTolerance, suppliedNeedIncubateQs, suppliedPreparedResourcesOption, suppliedDensities} = Lookup[safeOps, {Cache, Simulation, ExactAmount, Tolerance, Incubate, PreparedResources, Density}];
	fastCache = Experiment`Private`makeFastAssocFromCache[cache];

	(* expand the options properly, we trust that ExperimentTransfer/resolveLabelSamplePrimitive will always pass the correct pattern in so we dont do a lot of pattern check *)
	{
		expandedPreparedResources,
		expandedNeedIncubateQs,
		expandedDensities
	} = Map[
		If[ListQ[#] && Length[#] === Length[mySampleModels],
			# ,
			ConstantArray[#, Length[mySampleModels]]
		]&,
		{
			suppliedPreparedResourcesOption,
			suppliedNeedIncubateQs,
			suppliedDensities
		}
	];

	(* This is the model for Milli-Q water. Save the positions so we can reinsert empty lists later  *)
	waterPositions = Position[mySampleModels, ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]];

	(* filter the water temporarily as we definitely do not want to search water models since there are so many of them *)
	modelAmountTuplesNoWater = Delete[
		Transpose[{mySampleModels, myAmounts, mySterileBooleans}],
		waterPositions
	];

	(* Calculate allowed notebooks based on sharing settings *)
	allowedNotebooks = AllowedResourcePickingNotebooks[Protocol -> myParentProtocol, Cache -> cache];

	(* For each of these sample models that we have, search to see what the available samples are that we can pick from. *)
	availableSamples = Module[{sampleInstancesLists, searchResults, indexedSearchResults, gatheredSearchResults, reformattedSearchResults},

		(* return early if we will not be searching for samples *)
		If[Length[modelAmountTuplesNoWater] == 0, Return[{}, Module]];

		(* Call the same function ResourcePicking uses to determine what we can pick *)
		sampleInstancesLists = ModelInstances[
			(* Requested model. This list can have replicates since we may need different resources if (1) total amount is too large to fit in one container; (2)  *)
			modelAmountTuplesNoWater[[All, 1]],
			(* Requested amount *)
			modelAmountTuplesNoWater[[All, 2]],
			(* Container models - we will allow anything *)
			ConstantArray[{}, Length[modelAmountTuplesNoWater]],
			(* All notebooks available to the customer *)
			allowedNotebooks,
			(* Get the root protocol if we have one - parentProtocolTree has extra levels of lists from download to remove *)
			(* parentProtocol will be Null if not set *)
			myRootProtocol,
			(* 'Current protocol' - we don't have one since we are the current protocol *)
			Null,
			(* pass the ExactAmount boolean here so we can properly determine the container model *)
			ExactAmount -> suppliedExactAmountQs,
			Tolerance -> suppliedTolerance
		];

		searchResults = Map[
			Function[sampleInstances,
				Module[{ownedInstances},
					(* Get all the samples owned by the user *)
					ownedInstances = Select[sampleInstances, Lookup[#, "UserOwned"]&];

					(* If user owns no samples everything is fair game, otherwise look only at their samples *)
					If[MatchQ[ownedInstances, {}],
						Lookup[sampleInstances, "Value", {}],
						Lookup[ownedInstances, "Value"]
					]
				]
			],
			sampleInstancesLists
		];

		(* Gather the search results together so they group with the correct input sample *)
		indexedSearchResults = MapIndexed[{#1, #2} &, searchResults];
		gatheredSearchResults = GatherBy[indexedSearchResults, Mod[Last[#], Length[modelAmountTuplesNoWater]] &];
		reformattedSearchResults = Map[DeleteDuplicates@DeleteCases[Flatten[#], _Integer, {1}] &, gatheredSearchResults]
	];

	(* Download information about these samples. *)
	availableSampleDownloadResult = Quiet[
		Download[availableSamples, {Container[Model]}],
		{Download::FieldDoesntExist}
	];
	availableSampleContainerModelList = availableSampleDownloadResult[[All, All, 1]];

	(* Insert empty lists for where the water samples originally were so all of the lists in the ensuing MapThread have the same dimensions *)
	availableSampleContainerModelListWithWater = Fold[Insert[#1, {}, #2[[1]]] &, availableSampleContainerModelList, waterPositions];

	(* for any sample model (that is not water) and does not have any available instances, check if we might consolidate existing samples for them *)
	modelToCanConsolidateQLookup = Module[{modelAmountTuplesNoWaterNoAvailableInstances, consolidationInstancesLists},

		(* get the sample model that does not have any available instances *)
		modelAmountTuplesNoWaterNoAvailableInstances = PickList[modelAmountTuplesNoWater, availableSampleContainerModelList, {}];

		(* return early if we do not need to do any search *)
		If[Length[modelAmountTuplesNoWaterNoAvailableInstances] == 0, Return[{}, Module]];

		(* call helper to find possible consolidation instances *)
		consolidationInstancesLists = ConsolidationInstances[
			modelAmountTuplesNoWaterNoAvailableInstances[[All, 1]],
			modelAmountTuplesNoWaterNoAvailableInstances[[All, 2]],
			(* All notebooks available to the customer *)
			allowedNotebooks,
			(* Get the root protocol if we have one - parentProtocolTree has extra levels of lists from download to remove *)
			(* parentProtocol will be Null if not set *)
			myRootProtocol,
			(* 'Current protocol' - we don't have one since we are the current protocol *)
			Null,
			Sterile -> modelAmountTuplesNoWaterNoAvailableInstances[[All, 3]]
		];

		(* return the lookup *)
		(* Thread[{a, b, c} -> {True, False, True}] returns {a -> True, b -> False, c -> True}*)
		Thread[modelAmountTuplesNoWaterNoAvailableInstances[[All, 1]] -> (AssociationQ /@ consolidationInstancesLists)]
	];

	(* we will just say that water is not consolidatable in lab always since we _always_ prefer to use fresh water and go through a different RP task "WaterPrep" anyway *)
	(* also any sample that already has a list of available instances, we will just exclude them from needing consolidation *)
	canConsolidateQs = Replace[mySampleModels /. modelToCanConsolidateQLookup, Except[BooleanP] -> False, {1}];

	(* get the model packets and their incompatible materials *)
	sampleModelPackets = Experiment`Private`fetchPacketFromFastAssoc[#, fastCache]& /@ mySampleModels;
	allIncompatibleMaterials = Lookup[sampleModelPackets, IncompatibleMaterials, {}];

	(* mapthread to resolve a container for each model sample source and return *)
	MapThread[
		Function[{sampleModel, sampleModelPacket, amount, availableSampleContainerModels, preparedResource, incompatibleMaterials, needIncubateQ, sterileInput, suppliedDensity, canConsolidateQ},
			Module[
				{sterileQ, amountAsVolume, bufferedAmountAsVolume, state, density, maxTransferAmountSolid, allProductObjects, allProductPackets, nonDeprecatedProductPackets},

				(* make sure sterile is always boolean *)
				sterileQ = Which[
					(* Check if the Sterile is set as True as specified option *)
					BooleanQ[sterileInput],
						sterileInput,
					(* If we're dealing with cells (of any type) in our sample model, use sterile container. *)
					MemberQ[Lookup[sampleModelPacket, Composition], ObjectP[Model[Cell]]],
						True,
					(* if Model is living, then use sterile container *)
					TrueQ[Lookup[sampleModelPacket, Living]],
						True,
					(* if Model is sterile, then use sterile container *)
					TrueQ[Lookup[sampleModelPacket, Sterile]],
						True,
					(* if model requires AsepticHandling, then use sterile container *)
					TrueQ[Lookup[sampleModelPacket, AsepticHandling]],
						True,
					True,
						Automatic
				];

				(* Get all potential products in case we need them to resolve source container *)
				allProductObjects = Cases[Flatten[Lookup[sampleModelPacket, {Products, KitProducts}]][Object], ObjectReferenceP[Object[Product]]];
				allProductPackets = (Experiment`Private`fetchPacketFromFastAssoc[#, fastCache]&) /@ allProductObjects;

				(* Get the first product that is not deprecated. Favor Products > KitProducts. *)
				nonDeprecatedProductPackets = Cases[
					allProductPackets,
					KeyValuePattern[Deprecated -> (False | Null)]
				];

				(* Get the state of our Model[Sample] at room temperature. *)
				state = Lookup[sampleModelPacket, State];
				(* For solid sample, use its density to figure out the max amount we cant put in a reservoir so we can split if necessary *)
				density = Which[
					DensityQ[suppliedDensity],
					suppliedDensity,
					DensityQ[Lookup[sampleModelPacket, Density]],
					Lookup[sampleModelPacket, Density],
					True,
					Quantity[0.997`, ("Grams") / ("Milliliters")] * 1.25
				];
				maxTransferAmountSolid = ($MaxTransferVolume / 1.1) /. {mass:MassP :> mass / density};

				(* convert amount to volume if we have not done so *)
				amountAsVolume = Which[
					MatchQ[amount, VolumeP],
						amount,
					MatchQ[amount, MassP],
						amount / density,
					MatchQ[amount, _Integer] && MatchQ[Lookup[sampleModelPacket, SolidUnitWeight], MassP],
						(amount * Lookup[sampleModelPacket, SolidUnitWeight]) / density,
					(* if we got here we're in an error state anyway so just having a volume ensures we don't trainwreck *)
					True,
						1 Milliliter
				];

				(* always add a 10% for the requested amount *)
				bufferedAmountAsVolume = amountAsVolume * 1.1;

				(* Resolve the container for this Model[Sample], with the Sterile requirement considered. *)
				(* We are going to use this resolved container as SourceContainer downstream and in resource packets so it is important to know if the container should be sterile or not *)
				Which[
					(* Robotic, large amount of any sample. No need to check on incubation parameters as the reservoir is a plate that can be incubated for robotic handling *)
					And[
						MatchQ[bufferedAmountAsVolume, GreaterP[50 Milliliter]],
						MatchQ[myPreparation, Robotic]
					],
						If[sterileQ,
							Model[Container, Plate, "id:AEqRl9qm8rwv"],(*"200mL Polypropylene Robotic Reservoir, sterile"*)
							Model[Container, Plate, "id:54n6evLWKqbG"](*"200mL Polypropylene Robotic Reservoir, non-sterile"*)
						],
					(* Robotic, less water *)
					And[
						MatchQ[Download[sampleModel, Object], WaterModelP],
						(* Require a plate if we need to incubate water *)
						needIncubateQ,
						MatchQ[myPreparation, Robotic]
					],
						(* Return all possible robotic plates *)
						(* Exclude robotic reservoir since that (1) requires a large dead volume and (2) will affect the resolution of MPH transfer, making it different for the container models *)
						DeleteCases[
							PreferredContainer[Max[{bufferedAmountAsVolume, $MicroWaterMaximum}], Sterile -> sterileQ, Type -> Plate, LiquidHandlerCompatible -> True, All -> True],
							ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}]
						],
					(* Robotic, water, but no incubation required doesn't have to be in a plate *)
					And[
						MatchQ[Download[sampleModel, Object], WaterModelP],
						MatchQ[myPreparation, Robotic]
					],
						(* This should resolve to a tube since volume < 50 mL. Allow one type of tube for future option resolution *)
						PreferredContainer[Max[{bufferedAmountAsVolume, $MicroWaterMaximum}], Sterile -> sterileQ, LiquidHandlerCompatible -> True],

					(* When requesting water (non robotic case, no need to consider the requirement of on-deck incubation), we always want to get an amount large enough that we get it from the purifier *)
					(*Engine calls ExperimentTransfer to make amounts less than $MicroWaterMaximum so if we request less than that we'll get stuck in a requesting loop *)
					(* Note this amount calculation is duplicated in resource creation in the resource packets function *)
					(* If the total volume is above 20 Liter, which is larger than the largest container we have in the lab, split it and request the 20 Liter carboy *)
					MatchQ[Download[sampleModel, Object], WaterModelP] && MatchQ[bufferedAmountAsVolume, GreaterEqualP[$MaxTransferVolume]],
						PreferredContainer[$MaxTransferVolume],
					MatchQ[Download[sampleModel, Object], WaterModelP],
						PreferredContainer[Max[bufferedAmountAsVolume, $MicroWaterMaximum]],

					(* If the user has samples in their inventory that fulfill this model with the requested amount, then pick the most common one. *)
					(* NOTE: If we're in the liquid handler resolver, we have to pick a container that is okay on the liquid handler. *)
					Length[availableSampleContainerModels] > 0 && !MatchQ[myPreparation, Robotic],
						FirstOrDefault[Commonest[Download[availableSampleContainerModels, Object], 1]],
					(* Robotic case with incubation required. The volume is guaranteed to be smaller than 50 mL as that would have required a reservoir *)
					And[
						Length[availableSampleContainerModels] > 0,
						MatchQ[myPreparation, Robotic],
						(* Require a plate if we need to incubate water *)
						needIncubateQ
					],
						Module[
							{plateContainerModels},
							(* Get all of our container models that have a compatible footprint with the liquid handler *)
							plateContainerModels = DeleteDuplicates[
								(Lookup[#, Object]&) /@ Cases[
									(fetchPacketFromFastAssoc[#, fastCache]&) /@ availableSampleContainerModels,
									KeyValuePattern[{Footprint -> Plate}]
								]
							];
							If[Length[plateContainerModels] > 0,
								(* Go with available models if there are any available, exclude reservoir if it is in the list *)
								If[MatchQ[plateContainerModels, {ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}]}],
									plateContainerModels,
									DeleteCases[
										plateContainerModels,
										ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}](*"200mL Polypropylene Robotic Reservoir"*)
									]
								],
								(* Otherwise go with preferred plates, excluding the reservoir *)
								(* Exclude robotic reservoir since that (1) requires a large dead volume and (2) will affect the resolution of MPH transfer, making it different for the container models *)
								DeleteCases[
									PreferredContainer[bufferedAmountAsVolume,Sterile->sterileQ,Type->Plate,LiquidHandlerCompatible->True,All->True],
									ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}](*"200mL Polypropylene Robotic Reservoir"*)
								]
							]
						],
					(* Other robotic case*)
					MatchQ[myPreparation, Robotic],
						Module[
							{roboticContainerModels},
							(* Get all of our container models that have a compatible footprint with the liquid handler *)
							roboticContainerModels = DeleteDuplicates[
								(Lookup[#, Object]&) /@ Cases[
									(fetchPacketFromFastAssoc[#, fastCache]&) /@ availableSampleContainerModels,
									KeyValuePattern[{Footprint -> LiquidHandlerCompatibleFootprintP}]
								]
							];
							Which[
								(* A list of plates  *)
								MatchQ[roboticContainerModels, ListableP[ObjectP[Model[Container, Plate]]]],
									(* Go with available models if there are any available, exclude reservoir if it is in the list *)
									If[MatchQ[roboticContainerModels,{ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}]}],
										roboticContainerModels,
										DeleteCases[
											roboticContainerModels,
											ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}](*"200mL Polypropylene Robotic Reservoir"*)
										]
									],
								(* A list of containers with possible vessels *)
								Length[roboticContainerModels] > 0,
									(* Go with the first vessel so we can resolve the best pipetting options *)
									FirstOrDefault[Cases[roboticContainerModels, ObjectP[Model[Container, Vessel]]]],
								True,
									(* Otherwise go with preferred vessel *)
									PreferredContainer[bufferedAmountAsVolume, Sterile -> sterileQ, LiquidHandlerCompatible -> True, IncompatibleMaterials -> incompatibleMaterials]
							]
						],
					(* We have no available samples and we're prepping a resource - allow any container *)
					(* If we're prepping a resource i.e. this transfer will move sample into desired container we don't want to be specific about source container *)
					(* This will help us to avoid loops where we have to prepare a resource, but then we make another resource for our source that we then need to prepare in another sub and on and on *)
					MatchQ[preparedResource, ObjectP[]],
						Null,

					(* we do not have a single available sample to fulfill the model, but if we can consolidate samples from lab, it is still okay to just always use PreferredContainer right? *)
					TrueQ[canConsolidateQ],
						PreferredContainer[bufferedAmountAsVolume, Sterile -> sterileQ, IncompatibleMaterials -> incompatibleMaterials],

					(* Otherwise, we'll probably have to buy some. Pull out the DefaultContainerModel from the product. *)
					(* If we're Robotic, make sure it's in a robotic compatible container. *)
					MatchQ[nonDeprecatedProductPackets, {PacketP[]..}] && MatchQ[myPreparation, Robotic],
						Module[{potentialProductContainerModels},
							(* Get the default container model from the product. *)
							potentialProductContainerModels = Map[
								Function[{productPacket},
									Which[
										MatchQ[Lookup[productPacket, DefaultContainerModel][Object], ObjectReferenceP[Model[Container]]],
										Lookup[productPacket, DefaultContainerModel],
										MatchQ[
											Lookup[
												FirstCase[
													Lookup[productPacket, KitComponents],
													KeyValuePattern[{ProductModel -> ObjectP[sampleModel], DefaultContainerModel -> ObjectP[Model[Container]]}],
													<||>
												],
												DefaultContainerModel
											],
											ObjectP[Model[Container]]
										],
										Lookup[
											FirstCase[
												Lookup[productPacket, KitComponents],
												KeyValuePattern[{ProductModel -> ObjectP[sampleModel], DefaultContainerModel -> ObjectP[Model[Container]]}]
											],
											DefaultContainerModel
										],
										True,
										PreferredContainer[bufferedAmountAsVolume, Sterile -> sterileQ, LiquidHandlerCompatible -> True, IncompatibleMaterials -> incompatibleMaterials]
									]
								],
								nonDeprecatedProductPackets
							];

							If[needIncubateQ,
								(* Require a plate if we need to incubate sample *)
								Module[
									{plateProductContainerModels},
									plateProductContainerModels = DeleteDuplicates@Lookup[
										Cases[
											(Experiment`Private`fetchPacketFromFastAssoc[#, fastCache]&) /@ potentialProductContainerModels,
											KeyValuePattern[{Footprint -> Plate}]
										],
										Object,
										{}
									];
									If[Length[plateProductContainerModels] > 0,
										(* Go with available models if there are any available, exclude reservoir if it is in the list *)
										If[MatchQ[plateProductContainerModels,{ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}]}],
											plateProductContainerModels,
											DeleteCases[
												plateProductContainerModels,
												ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}](*"200mL Polypropylene Robotic Reservoir"*)
											]
										],
										(* Otherwise go with preferred plates, excluding the reservoir *)
										(* Exclude robotic reservoir since that (1) requires a large dead volume and (2) will affect the resolution of MPH transfer, making it different for the container models *)
										DeleteCases[
											PreferredContainer[bufferedAmountAsVolume,Sterile->sterileQ,Type->Plate,LiquidHandlerCompatible->True,All->True],
											ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}](*"200mL Polypropylene Robotic Reservoir"*)
										]
									]
								],
								(* Other robotic case *)
								Module[
									{roboticProductContainerModels},
									roboticProductContainerModels = DeleteDuplicates@Lookup[
										Cases[
											(fetchPacketFromFastAssoc[#, fastCache]&) /@ potentialProductContainerModels,
											KeyValuePattern[{Footprint -> LiquidHandlerCompatibleFootprintP}]
										],
										Object,
										{}
									];
									Which[
										(* A list of plates  *)
										MatchQ[roboticProductContainerModels, ListableP[ObjectP[Model[Container, Plate]]]],
										(* Go with available models if there are any available, exclude reservoir if it is in the list *)
										If[MatchQ[roboticProductContainerModels, {ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}]}],
											roboticProductContainerModels,
											DeleteCases[
												roboticProductContainerModels,
												ObjectP[{Model[Container,Plate,"id:54n6evLWKqbG"], Model[Container, Plate, "id:AEqRl9qm8rwv"]}](*"200mL Polypropylene Robotic Reservoir"*)
											]
										],
										(* A list of containers with possible vessels *)
										Length[roboticProductContainerModels] > 0,
										(* Go with the first vessel so we can resolve the best pipetting options *)
										FirstOrDefault[Cases[roboticProductContainerModels, ObjectP[Model[Container, Vessel]]]],
										True,
										(* Otherwise go with preferred vessel *)
										PreferredContainer[bufferedAmountAsVolume, Sterile -> sterileQ, LiquidHandlerCompatible -> True, IncompatibleMaterials -> incompatibleMaterials]
									]
								]
							]
						],
					(* Otherwise, non robotic. any container is fine. The only exception is when the amount is larger than 20 Liter/20 Kilogram, then we have to split *)
					MatchQ[nonDeprecatedProductPackets, {PacketP[]..}],
						Module[{productPacket, potentialProductContainerModel, potentialProductContainerModelMaxVolume},
							(* Get the default container model from the product. *)
							productPacket = First[nonDeprecatedProductPackets];

							potentialProductContainerModel = Which[
								(* product has a default container model populated, just use that *)
								MatchQ[Lookup[productPacket, DefaultContainerModel][Object], ObjectReferenceP[Model[Container]]],
									Lookup[productPacket, DefaultContainerModel],
								(* otherwise, look at the kit components to see if sample model is there and has a default container model specified *)
								MatchQ[
									Lookup[
										FirstCase[
											Lookup[productPacket, KitComponents],
											KeyValuePattern[{ProductModel -> ObjectP[sampleModel], DefaultContainerModel -> ObjectP[Model[Container]]}],
											<||>
										],
										DefaultContainerModel
									],
									ObjectP[Model[Container]]
								],
									Lookup[
										FirstCase[
											Lookup[productPacket, KitComponents],
											KeyValuePattern[{ProductModel -> ObjectP[sampleModel], DefaultContainerModel -> ObjectP[Model[Container]]}]
										],
										DefaultContainerModel
									],
								(* otherwise, there is no default container model information in the product, use the PreferredContainer of max transfer volume to avoid overflow *)
								MatchQ[bufferedAmountAsVolume, GreaterEqualP[$MaxTransferVolume]],
									PreferredContainer[$MaxTransferVolume, Sterile -> sterileQ, IncompatibleMaterials -> incompatibleMaterials],
								(* use the PreferredContainer of max solid transfer volume to avoid overflow if we are dealing with solids *)
								MatchQ[bufferedAmountAsVolume, GreaterEqualP[maxTransferAmountSolid]],
									PreferredContainer[maxTransferAmountSolid, Sterile -> sterileQ, Density -> density, IncompatibleMaterials -> incompatibleMaterials],
								(* Otherwise, we are not overflowing, so it is safe to use the PreferredContainer of amount to be transferred *)
								True,
									PreferredContainer[bufferedAmountAsVolume,Sterile -> sterileQ, Density -> density, IncompatibleMaterials -> incompatibleMaterials]
							];

							potentialProductContainerModelMaxVolume = fastAssocLookup[fastCache, potentialProductContainerModel, MaxVolume];

							(* if we don't have MaxVolume, assume it is fine since we either used PreferredContainer or Container somehow does not have MaxVolume (unlikely) *)
							(* or if we don't have compatible units - weight or count would not work well for our next test *)
							Which[
								Or[
									NullQ[potentialProductContainerModelMaxVolume],
									!CompatibleUnitQ[potentialProductContainerModelMaxVolume, amount]
								],
									potentialProductContainerModel,

								(* we need more than what single container can hold -> we will have to consolidate for Resource, but we need a different container here *)
								MatchQ[bufferedAmountAsVolume, GreaterEqualP[$MaxTransferVolume]],
									PreferredContainer[$MaxTransferVolume, Sterile -> sterileQ, IncompatibleMaterials -> incompatibleMaterials],
								MatchQ[bufferedAmountAsVolume, GreaterEqualP[maxTransferAmountSolid]],
									PreferredContainer[maxTransferAmountSolid,Sterile -> sterileQ, Density -> density, IncompatibleMaterials -> incompatibleMaterials],
								potentialProductContainerModelMaxVolume < amount,
									PreferredContainer[bufferedAmountAsVolume, Sterile -> sterileQ, Density -> density, IncompatibleMaterials -> incompatibleMaterials],

								(* other cases should take what we have resolved *)
								True,
									potentialProductContainerModel
							]
						],
					(* if out source is Model of StockSolution with PrepareInResuspensionContainer, grab the appropriate container *)
					MatchQ[sampleModel, ObjectP[Model[Sample, StockSolution]]] && MatchQ[Lookup[sampleModelPacket, PrepareInResuspensionContainer, Null], True],
						Download[First@Lookup[sampleModelPacket, PreferredContainers, {}], Object],

					(* Otherwise, just fall back on the preferred container. *)
					And[
						MatchQ[bufferedAmountAsVolume, GreaterP[50 Milliliter]],
						MatchQ[myPreparation, Robotic]
					],
						If[sterileQ,
							Model[Container, Plate, "id:AEqRl9qm8rwv"],(*"200mL Polypropylene Robotic Reservoir, sterile"*)
							Model[Container, Plate, "id:54n6evLWKqbG"](*"200mL Polypropylene Robotic Reservoir, non-sterile"*)
						],
					MatchQ[myPreparation, Robotic],
						PreferredContainer[bufferedAmountAsVolume, Sterile -> sterileQ, LiquidHandlerCompatible -> True, IncompatibleMaterials -> incompatibleMaterials],
					MatchQ[bufferedAmountAsVolume, GreaterEqualP[$MaxTransferVolume]],
						PreferredContainer[$MaxTransferVolume, Sterile -> sterileQ, IncompatibleMaterials -> incompatibleMaterials],
					MatchQ[bufferedAmountAsVolume, GreaterEqualP[maxTransferAmountSolid]],
						PreferredContainer[maxTransferAmountSolid,Sterile -> sterileQ, Density -> density, IncompatibleMaterials -> incompatibleMaterials],
					True,
						PreferredContainer[bufferedAmountAsVolume, Sterile -> sterileQ, Density -> density, IncompatibleMaterials -> incompatibleMaterials]
				]
			]
		],
		{
			mySampleModels,
			sampleModelPackets,
			myAmounts,
			availableSampleContainerModelListWithWater,
			expandedPreparedResources,
			allIncompatibleMaterials,
			expandedNeedIncubateQs,
			mySterileBooleans,
			expandedDensities,
			canConsolidateQs
		}
	]
];


(* Helper function that checks if samples in input and options can be safely handled by BSC if one is specified to be the transfer environment. The recirculating mechanis of our A2 type BSCs are not built to handle and could concentrate volatile chemical that are explosive, flammable, toxicm radioactive, or corrosive. *)
checkVolatileHazardousSamplesInBSCs[
	mapThreadFriendlyInputAndOptions : {(_Association)..}, (* Input samples are merged into the associations *)
	keysToExclude : {(_Symbol)...}, (* option keys that we neglect because the samples there are not used inside the handling station*)
	handlingStationOptionKey_Symbol,
	cache_List
] := Module[{hazardClassNotAllowedInBSCsP, handlingStations, mapThreadFriendlyOptionsUsingBSCs, sampleToKeyLookup, allSampleBooleans,
	allOptionSamplesToUseInBSCs, samplesNotAllowedTuples, groupedSamples, clauses},
	(* These DOT hazard classes, in combination with Ventilated->True, are not allowed in the BSCs *)
	hazardClassNotAllowedInBSCsP = Alternatives[
		"Class 1 Division 1.1 Mass Explosion Hazard",
		"Class 2 Division 2.1 Flammable Gas Hazard",
		"Class 2 Division 2.3 Toxic Gas Hazard",
		"Class 3 Flammable Liquids Hazard",
		"Class 6 Division 6.1 Toxic Substances Hazard",
		"Class 7 Division 7 Radioactive Material Hazard",
		"Class 8 Division 8 Corrosives Hazard"
	];
	(* Pull the list of resolved handling stations *)
	handlingStations = Lookup[mapThreadFriendlyInputAndOptions, handlingStationOptionKey];
	(* Filter out associations of options for those not using BSCs, and drop the keys specified to exclude *)
	mapThreadFriendlyOptionsUsingBSCs = PickList[mapThreadFriendlyInputAndOptions, handlingStations, ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]];
	(* Make a lookup to log sample -> option/input key relationships *)
	sampleToKeyLookup = Merge[
		Flatten@Map[
			Function[options,
				KeyValueMap[
					Function[{optionKey, optionValue},
						If[MemberQ[optionKey, keysToExclude],
							Nothing,
							(* generate rules of e.g. Model[Sample, "chloroform"] -> PreWashBuffer *)
							(# -> optionKey) & /@ Cases[ToList[optionValue], ObjectP[{Object[Sample], Model[Sample]}]]
						]
					],
					options
				]
			],
			mapThreadFriendlyOptionsUsingBSCs
		],
		Identity
	];

	(* Pull the keys from the lookup to get a duplicate-free sample list *)
	allOptionSamplesToUseInBSCs = Keys[sampleToKeyLookup];
	(* Download sample packets with Flammable/Ventilated info *)
	allSampleBooleans = Quiet[Download[allOptionSamplesToUseInBSCs, {Object, Ventilated, DOTHazardClass}, Cache -> cache], Download::MissingCacheField];
	(* Disallow sample objects/models that are both flammable and requiring ventilation. *)
	samplesNotAllowedTuples = Cases[allSampleBooleans, {_, True, hazardClassNotAllowedInBSCsP}];
	(* Group by hazard class *)
	groupedSamples = GroupBy[samplesNotAllowedTuples, Last];
	If[Length[samplesNotAllowedTuples] > 0,
		(* There are had samples, return True and clauses *)
		{
			True,
			(* Construct the message *)
			If[Length[Keys[groupedSamples]] > $MaxNumberOfErrorDetails,
				"There are samples that have Ventilated -> True and an incompatible DOTHazardClass specified to be used in a biosafety cabinet.",
				 StringJoin[
					StringJoin @@ KeyValueMap[
						Function[{hazardClass, sampleTuples},
							StringJoin[
								"The ",
								joinClauses[Flatten@Lookup[sampleToKeyLookup, sampleTuples[[All, 1]]]],
								" ",
								samplesForMessages[sampleTuples[[All, 1]], Cache -> cache],
								" ",
								hasOrHave[sampleTuples[[All, 1]]],
								" a DOTHazardClass of ",
								hazardClass,
								". "
							]
						],
						groupedSamples
					],
					pluralize[samplesNotAllowedTuples[[All, 1]], "This sample ", "These samples "],
					isOrAre[samplesNotAllowedTuples[[All, 1]]],
					" also marked with Ventilated -> True."
				]
			]
		},
		(* There's no bad sample, return False and Null *)
		{False, Null}
	]
];
