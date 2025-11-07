(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(* Define Global Variables *)
(* $InoculationTransferOptionSymbols is shared by non-SolidMedia Inoculation sources *)
$InoculationTransferOptionSymbols = {
	InoculationTips,
	InoculationTipType,
	InoculationTipMaterial
};

$SolidMediaOptionSymbols = {
	Populations,
	MinRegularityRatio,
	MaxRegularityRatio,
	MinCircularityRatio,
	MaxCircularityRatio,
	MinDiameter,
	MaxDiameter,
	MinColonySeparation,
	ImagingChannels,
	ImagingStrategies,
	ExposureTimes,
	NumberOfHeads,
	ColonyPickingTool,
	ColonyPickingDepth,
	PickCoordinates,
	DestinationFillDirection,
	MaxDestinationNumberOfColumns,
	MaxDestinationNumberOfRows,
	PrimaryWash,
	PrimaryWashSolution,
	NumberOfPrimaryWashes,
	PrimaryDryTime,
	SecondaryWash,
	SecondaryWashSolution,
	NumberOfSecondaryWashes,
	SecondaryDryTime,
	TertiaryWash,
	TertiaryWashSolution,
	NumberOfTertiaryWashes,
	TertiaryDryTime,
	QuaternaryWash,
	QuaternaryWashSolution,
	NumberOfQuaternaryWashes,
	QuaternaryDryTime
};

$LiquidMediaOptionSymbols = Join[
	{
		Volume,
		SourceMix,
		SourceMixType,
		NumberOfSourceMixes,
		SourceMixVolume
	},
	$InoculationTransferOptionSymbols
];

$FreezeDriedOptionSymbols = Join[
	{
		Volume,
		ResuspensionMix,
		ResuspensionMixType,
		NumberOfResuspensionMixes,
		ResuspensionMixVolume,
		ResuspensionMedia,
		ResuspensionMediaVolume
	},
	$InoculationTransferOptionSymbols
];

$FrozenGlycerolOptionSymbols = Join[
	{
		NumberOfSourceScrapes
	},
	$InoculationTransferOptionSymbols
];

$AgarStabOptionSymbols = $InoculationTransferOptionSymbols;


(* ::Subsection::Closed:: *)
(*Define Options*)


(* ::Code::Initialization:: *)
DefineOptions[ExperimentInoculateLiquidMedia,
	Options :> {
		{
			OptionName -> InoculationSource,
			Default -> Automatic,
			Description -> "The type of media in which the source cell samples are stored before the experiment. The possible types accepted by ExperimentInoculateLiquidMedia include LiquidMedia, SolidMedia, AgarStab, FreezeDried, and FrozenGlycerol. For sources of type LiquidMedia, samples are mixed in the source containers, the well-mixed input sample is then transferred to the destination media container with fresh media. For sources of type SolidMedia, microbial colonies are first imaged and categorized, then picked and transferred to the destination media container with fresh media. For sources of type AgarStab, microbial colonies are picked and transferred to destination media container with fresh media. For sources of type FreezeDried, samples are resuspended with media in the source container, the resuspended material is then transferred to the destination media container with fresh media. For sources of type FrozenGlycerol, samples are scraped from the frozen surface using pipette tips while the source container is kept chilled, the scraped material is then deposited into the destination media container with fresh media. If the entire amount of FrozenGlycerol samples are desired or when there is no glycerol in the composition thus scrapping technique does not work, the samples should be thaw first to liquid before calling ExperimentInoculateLiquidMedia. See Figure 1 of ExperimentInoculateLiquidMedia to check inoculation source specific procedures and ExampleResults section in the helpfile for more information.",
			ResolutionDescription -> "If the source samples have liquid state, automatically set to LiquidMedia. If the source container models are hermetic or ampoules and the source samples have solid state, automatically set to FreezeDried. If the source samples contain agarose in the composition and are in solid state, automatically set to SolidMedia if the source containers are plates, or set to AgarStab if the source containers are vials or tubes. If the source containers are stored in cryogenic or deep freezer storage condition, automatically set to FrozenGlycerol if the source samples contain glycerol in the composition.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> InoculationSourceP (* SolidMedia | LiquidMedia | AgarStab | FreezeDried | FrozenGlycerol *)
			],
			Category -> "General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* 1.Options for Manual Transfer *)
			(* 1.1 General Index Matching Options for Manual Transfer *)
			{
				OptionName -> Instrument,
				Default -> Automatic,
				Description -> "The instrument that is used to transfer cells (e.g., cell suspension or inoculum) into fresh liquid media to initiate culture growth. See InstrumentTable section in the helpfile for information about TipConnectionType, CultureHandling and compatible InoculationTips.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to Model[Instrument, ColonyHandler, \"QPix 420 HT\"]. If InoculationSource is LiquidMedia and Preparation is Robotic, automatically set to Model[Instrument, LiquidHandler, \"bioSTAR\"] for mammalian samples or Model[Instrument, LiquidHandler, \"microbioSTAR\"] for microbial samples. If InoculationTips is specified and Preparation is Manual, set to a pipette that is the same TipConnectionType as the InoculationTips and CultureHandling field matching the cell type of the input sample. If InoculationSource is LiquidMedia and Preparation is Manual, set to a pipette that has MaxVolume greater than Volume and CultureHandling field matching the cell type of the input sample. If InoculationSource is AgarStab, set to a pipette with either the P1000 or Serological TipConnectionType and CultureHandling field matching the cell type of the input sample. If InoculationSource is FrozenGlycerol or FreezeDried, set to a pipette that has TipConnectionType P1000 and CultureHandling field matching the cell type of the input sample.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Object[Instrument, Pipette], Model[Instrument, Pipette],
						Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler],
						Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Liquid Handling",
							"Pipettes"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Liquid Handling",
							"Robotic Liquid Handlers"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Colony Handling",
							"Colony Handlers"
						}
					}
				],
				Category -> "General"
			},
			ModifyOptions[ExperimentTransfer,
				TransferEnvironment,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}],
					PreparedContainer -> False,
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Transfer Environments",
							"Biosafety Cabinets"
						}
					}
				],
				Description -> "The environment in which the inoculation is performed for the input sample (e.g., cell suspension or inoculum). Containers involved are first moved into the TransferEnvironment (with covers on), then uncovered inside of the TransferEnvironment for inoculation, and covered before moving back onto the operator cart. This option is only applicable if Preparation is set to Manual.",
				ResolutionDescription -> "If Preparation is Manual, automatically set to Model[Instrument,HandlingStation,BiosafetyCabinet,\"Biosafety Cabinet Handling Station for Tissue Culture\"] for mammalian cell samples, otherwise set to Model[Instrument, HandlingStation, BiosafetyCabinet, \"Biosafety Cabinet Handling Station for Microbiology\"].",
				Category -> "General"
			],
			(* 1.2 Instrument Specifications for Manual Transfer and Hamilton Transfer *)
			ModifyOptions[ExperimentTransfer,
				OptionName -> Tips,
				ModifiedOptionName -> InoculationTips,
				Description -> "The pipette tip used during the inoculation process, either on a manual pipette or a robotic liquid handler, to move cells from the source container to the destination media container(s). This option is only applicable when the InoculationSource is not SolidMedia. For SolidMedia, a ColonyPickingTool is used instead to deposit source cells into the destination media containers.",
				ResolutionDescription -> "If InoculationSource is LiquidMedia, AgarStab, FreezeDried, or FrozenGlycerol, automatically set to a tip that matches the TipConnectionType of the Instrument option and is sterile.",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, Tips], Object[Item, Tips]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Labware",
							"Pipette Tips",
							"Robotic Tips",
							"Sterile"
						},
						{
							Object[Catalog, "Root"],
							"Labware",
							"Pipette Tips",
							"Air-displacement Pipette Tips",
							"Sterile"
						},
						{
							Object[Catalog, "Root"],
							"Labware",
							"Pipette Tips",
							"Serological Pipettes"
						}
					}
				],
				Category -> "Inoculation"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> TipType,
				ModifiedOptionName -> InoculationTipType,
				Description -> "The type of pipette tips used to aspirate and dispense the cells during the inoculation. This option is only applicable if InoculationSource is not SolidMedia.",
				ResolutionDescription -> "Automatically set to Barrier/WideBore/GelLoading/Aspirator if the fields Filtered/WideBore/GelLoading/Aspirator of the calculated Tips are True, otherwise set to Normal.",
				Category -> "Hidden"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> TipMaterial,
				ModifiedOptionName -> InoculationTipMaterial,
				Description -> "The material of pipette tips used to aspirate and dispense the cells during the inoculation. This option is only applicable if InoculationSource is not SolidMedia.",
				ResolutionDescription -> "Automatically set to the TipMaterial of the InoculationTips.",
				Category -> "Hidden"
			],
			(* InoculationSource specific Volume options only for resuspended liquid *)
			{
				OptionName -> Volume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxTransferVolume],
						Units -> {Microliter, {Microliter, Milliliter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description -> "The amount of suspended source cells to transfer to the destination container. Applicable only when the input sample is in liquid form or resuspended from freeze-dried powder.",
				ResolutionDescription -> "If InoculationSource is LiquidMedia, automatically set to either 1/12th of the maximum volume of DestinationMediaContainer or 1/10th of the cell suspension volume, whichever is smaller. If InoculationSource is FreezeDried, automatically set to the total volume of the cell resuspension divided by the total number of DestinationMediaContainer.",
				Category -> "Inoculation"
			},
			(* DestinationMix options for all inoculation sources *)
			ModifyOptions[ExperimentTransfer,
				OptionName -> DispenseMix,
				ModifiedOptionName -> DestinationMix,
				Default -> True,
				Description -> "Indicates if mixing is performed immediately after the input sample (e.g., cell suspension or inoculum) is dispensed into the destination media container.",
				NestedIndexMatching -> True,
				Category -> "Inoculation"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> DispenseMixType,
				ModifiedOptionName -> DestinationMixType,
				Description -> "The style of mixing that is performed immediately after the input sample (e.g., cell suspension or inoculum) is dispensed into the destination media container. Pipette performs DestinationNumberOfMixes aspiration/dispense cycle(s) of DestinationMixVolume using the Instrument with the same InoculationTips. Swirl has the operator place the container on the surface of the TransferEnvironment and perform DestinationNumberOfMixes clockwise rotations of the container. Shake moves the pin on the ColonyHandlerHeadCassette used to pick the colony in a circular motion DestinationNumberOfMixes times in the DestinationWell. If InoculationSource is SolidMedia, Shake is applicable. For other inoculation sources, if Preparation is set to Robotic, Pipette is applicable, otherwise both Pipette and Swirl are applicable. See Figure 3.1 of ExperimentInoculateLiquidMedia for more information.",
				ResolutionDescription -> "If DestinationMix is set to True, automatically set to shake when InoculationSource is SolidMedia, otherwise set to Pipette.",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> InoculationMixTypeP (* Shake |Pipette | Swirl *)
				],
				NestedIndexMatching -> True,
				Category -> "Inoculation"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> NumberOfDispenseMixes,
				ModifiedOptionName -> DestinationNumberOfMixes,
				Description -> "The number of times the cells are mixed in the destination container. Pipette performs DestinationNumberOfMixes aspirate-dispense cycles. Shake performs DestinationNumberOfMixes number of circular motions of the ColonyPickingTool in the destination liquid media during inoculation. Swirl has the operator perform DestinationNumberOfMixes clockwise motions to the destination container on the surface of the TransferEnvironment.",
				ResolutionDescription -> "Automatically set to 5 if DestinationMix is True.",
				NestedIndexMatching -> True,
				Category -> "Inoculation"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> DispenseMixVolume,
				ModifiedOptionName -> DestinationMixVolume,
				Description -> "The amount repeatedly aspirated and dispensed via pipette from the destination sample in order to distribute the input sample (e.g., cell suspension or inoculum) in the destination media uniformly after the inoculation. This option is only applicable if DestinationMixType is set to Pipette.",
				ResolutionDescription -> "If DestinationMixType is set to Pipette, automatically set to the lesser of either half the destination media volume or the pipette's maximum volume.",
				NestedIndexMatching -> True,
				Category -> "Inoculation"
			],
			(* 2.Options for DestinationMedia for all inoculation types *)
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MediaVolume,
				AllowNull -> True,
				Description -> "The amount of fresh media pre-loaded into the DestinationMediaContainer prior to the addition of the input sample (e.g., cell suspension or inoculum). This option is only applicable when DestinationMedia is specified.",
				ResolutionDescription -> "If InoculationSource is LiquidMedia or FreezeDried, automatically set to 5 times of Volume for 1:5 split cell culture or 40% of the MaxVolume of the DestinationMediaContainer, whichever is smaller. For other inoculation sources, automatically set to recommended fill volume or 40% of the MaxVolume of the DestinationMediaContainer.",
				NestedIndexMatching -> True,
				Category -> "Media Preparation"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> DestinationMedia,
				AllowNull -> True,
				Description -> "A liquid, nutrient-rich solution added to the destination container to provide the necessary conditions for cell growth following inoculation.",
				ResolutionDescription -> "If InoculationSource is FreezeDried and ResuspensionMedia is specified, automatically set to match the ResuspensionMedia. In other cases, DestinationMedia is automatically set to the value in the PreferredLiquidMedia field for the cell model for the most abundant cells in the input sample Composition. If there is no PreferredLiquidMedia, automatically set to Model[Sample, Media, \"LB Broth, Miller\"].",
				NestedIndexMatching -> True,
				Category -> "Media Preparation"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> DestinationMediaContainer,
				Description -> "The desired container to have cells transferred to. When InoculationSource is SolidMedia, multiple containers can be specified for each Population. However, container model must be the same within a Population. When InoculationSource is FreezeDried, it can be one or multiple containers. For all other cases, a single container can be used.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]. If InoculationSource is LiquidMedia and Preparation is Robotic, automatically set to Model[Container, Plate, \"24-well Round Bottom Deep Well Plate, Sterile\"] if the total volume of output sample is less than 10 Milliliter or set as a plate calculated with function PreferredContainer given the total volume of the output sample. For all other cases, automatically set to set to Model[Container, Vessel, \"Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap\"] if the total volume of the output sample is less than 14 Milliliter or set as a tube or a flask calculated with function PreferredContainer given the total volume of the output sample.",
				Widget -> Alternatives[
					"A single container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers",
								"Cell Culture Flasks"
							},
							{
								Object[Catalog, "Root"],
								"Containers",
								"Plates",
								"Cell Incubation Plates",
								"Suspension Culture Plates"
							},
							{
								Object[Catalog, "Root"],
								"Containers",
								"Plates",
								"Colony Handling Plates",
								"Multi-Well Suspension Plates"
							}
						}
					],
					"Multiple containers" -> Adder[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Container]]
						]
					]
				],
				NestedIndexMatching -> True,
				Category -> "Media Preparation"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> DestinationWell,
				AllowNull -> True,
				NestedIndexMatching -> True,
				Description -> "The position in the DestinationMediaContainer where the fresh media and source cells (e.g., cell suspension or inoculum) are transferred. Applicable only when the input sample is not on SolidMedia.",
				ResolutionDescription -> "If InoculationSource is LiquidMedia, AgarStab, FreezeDried, or FrozenGlycerol, automatically set to the first empty position of the DestinationMediaContainer. If no empty position is found, set to \"A1\".",
				Category -> "Media Preparation"
			],
			(* 3.Options for specific inoculation types *)
			(* 3.1 Inoculate from freeze dried powder only options i.e. resuspension options *)
			ModifyOptions[ExperimentMix,
				OptionName -> Mix,
				ModifiedOptionName -> ResuspensionMix,
				AllowNull -> True,
				Description -> "Indicates if the cells in resuspension is mixed after adding ResuspensionMedia to the input sample. This option is only applicable if InoculationSource is FreezeDried.",
				ResolutionDescription -> "If InoculationSource is FreezeDried, or if any of the other ResuspensionMix options are set, automatically set to True.",
				Category -> "Inoculation From Freeze Dried"
			],
			ModifyOptions[ExperimentMix,
				OptionName -> MixType,
				ModifiedOptionName -> ResuspensionMixType,
				AllowNull -> True,
				Description -> "The type of mixing of the cells in resuspension after adding ResuspensionMedia to the input sample. Pipette performs NumberOfResuspensionMixes aspiration/dispense cycle(s) of ResuspensionMixVolume using a pipette.",
				ResolutionDescription -> "If ResuspensionMix is True, automatically set to Pipette.",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Pipette]
				],
				Category -> "Hidden"(*Hide it since no option essentially*)
			],
			ModifyOptions[ExperimentMix,
				OptionName -> NumberOfMixes,
				ModifiedOptionName -> NumberOfResuspensionMixes,
				AllowNull -> True,
				Description -> "The number of times the aspiration/dispense cycle(s) is repeated using a pipette after adding ResuspensionMedia to the input sample.",
				ResolutionDescription -> "If ResuspensionMix is True, automatically set to 5.",
				Category -> "Inoculation From Freeze Dried"
			],
			ModifyOptions[ExperimentMix,
				OptionName -> MixVolume,
				ModifiedOptionName -> ResuspensionMixVolume,
				AllowNull -> True,
				Description -> "The amount repeatedly aspirated and dispensed via pipette from the cells in resuspension in order to mix after adding ResuspensionMedia to the source sample in freeze-dried powder. The same pipette and tips used to add the ResuspensionMedia are used to mix the cell resuspension.",
				ResolutionDescription -> "If ResuspensionMix is True, automatically set to the lesser of either half the ResuspensionMediaVolume or the InoculationTips's maximum volume.",
				Category -> "Inoculation From Freeze Dried"
			],
			{
				OptionName -> ResuspensionMedia,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample], Object[Container, Vessel]}],
					Dereference -> {Object[Container, Vessel] -> Field[Contents[[All, 2]]]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Cell Culture",
							"Media"
						}
					}
				],
				Description -> "The liquid, nutrient-rich solution added to the input sample in freeze-dried powder in order to resuspend the cells. This option is only applicable if InoculationSource is FreezeDried.",
				ResolutionDescription -> "If InoculationSource is FreezeDried, automatically set to match DestinationMedia. If DestinationMedia is not specified, ResuspensionMedia is automatically set to the value in the PreferredLiquidMedia field for the cell model of the most abundant cells in the input sample Composition. If there is no PreferredLiquidMedia, automatically set to Model[Sample, Media, \"LB Broth, Miller\"].",
				Category -> "Inoculation From Freeze Dried"
			},
			{
				OptionName -> ResuspensionMediaVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, $MaxTransferVolume],
						Units -> {1, {Microliter, {Microliter, Milliliter}}}
					]
				],
				Description -> "The amount of ResuspensionMedia added to the input sample in order to resuspend the cells. This option is only applicable if InoculationSource is FreezeDried.",
				ResolutionDescription -> "If InoculationSource is FreezeDried, automatically set to 1/4 of the MaxVolume of the source sample container's model.",
				Category -> "Inoculation From Freeze Dried"
			},
			(* 3.2 Inoculate From Frozen Glycerol Only Options *)
			{
				OptionName -> NumberOfSourceScrapes,
				Default -> Automatic,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 20, 1]
				],
				Description -> "The number of times that the input sample is scraped with the pipette tip prior to introducing the tip into the destination media for inoculation. This option is only applicable if InoculationSource is FrozenGlycerol.",
				ResolutionDescription -> "Automatically set to 5 if InoculationSource is FrozenGlycerol.",
				AllowNull -> True,
				Category -> "Inoculation From Frozen Glycerol"
			},
			(* 3.3 Inoculate From Solid Media Only Options *)
			ModifyOptions[ExperimentPickColonies,
				OptionName -> Populations,
				AllowNull -> True,
				Description -> "The criteria used to group colonies together into a population to pick. Criteria are based on the ordering of colonies by the desired feature(s): Diameter, Regularity, Circularity, Isolation, Fluorescence, and BlueWhiteScreen. Additionally, CustomCoordinates can be specified, which work in conjunction with the PickCoordinates option to select colonies based on pre-determined locations. For more information see documentation on colony population Unit Operations: Diameter, Isolation, Regularity, Circularity, Fluorescence, BlueWhiteScreen, MultiFeatured, and AllColonies under Experiment Principles section. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, and if the cell model in the sample object matches one of the fluorescent excitation and emission pairs of the colony picking instrument, Populations will group the fluorescent colonies into a population. Otherwise, Populations will be set to All.",
				NestedIndexMatching -> True,
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MinDiameter,
				Description -> "The smallest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to 0.5 Millimeter.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MaxDiameter,
				Description -> "The largest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to 2 Millimeter.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MinColonySeparation,
				Default -> Automatic,
				Description -> "The closest distance included colonies can be from each other from which colonies will be included. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, set to 0.2 Millimeter.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MinRegularityRatio,
				Description -> "The smallest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to 0.65.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MaxRegularityRatio,
				Description -> "The largest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to 1.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MinCircularityRatio,
				Description -> "The smallest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to 0.65.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MaxCircularityRatio,
				Description -> "The largest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to 1.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> ImagingChannels,
				AllowNull -> True,
				Description -> "Wavelength parameters to indicate how to expose the colonies to light/and measure light from the colonies when capturing images of the colonies. Options include blue-white filter, and wavelength pairs for selecting fluorescence excitation and emission options. Images can be taken even if they are not used during Analysis. This option is only applicable if InoculationSource is SolidMedia."
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> ImagingStrategies,
				AllowNull -> True,
				Description -> "The end goals for capturing images. The options include BrightField imaging, BlueWhite Screening, and Fluorescence imaging. Images can be taken even if they are not used during Analysis. This option is only applicable if InoculationSource is SolidMedia.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> ExposureTimes,
				AllowNull -> True,
				Description -> "For each Sample and for each imaging strategy, the length of time to allow the camera to capture an image. An increased ExposureTime leads to brighter images based on a linear scale. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and ExposureTimes is not specified, optimal exposure time is automatically determined during experiment. This is done by running AnalyzeImageExposure on suggested initial exposure time and calculating pixel gray levels. The process adjusts the exposure time for subsequent image acquisitions until the optimal exposure time is found.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> ColonyPickingTool,
				AllowNull -> True,
				Description -> "The part attached to Instrument to collect the source cells and deposit them into DestinationMediaContainer. See Figure 3.11 of ExperimentInoculateLiquidMedia for more information. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, if the DestinationContainer has 24 wells, set to Model[Part,ColonyHandlerHeadCassette, \"Qpix 24 pin picking head - E. coli\" ]. If the DestinationContainer has 96 or 384 wells, or is an OmniTray, will use the PreferredColonyHandlerHeadCassette of the first model cell in the composition of the input sample. If the Composition field is not filled or there are not Model[Cell]'s in the composition, this option is automatically set to Model[Part, ColonyHandlerHeadCassette, \" Qpix 96 pin picking head, deepwell - E. coli\"] if the destination is a deep well plate and Model[Part, ColonyHandlerHeadCassette, \" Qpix 96 pin picking head, deepwell - E. coli\"] otherwise.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> NumberOfHeads,
				AllowNull -> True,
				Description -> "The number of metal probes on the ColonyHandlerHeadCassette that will pick the colonies. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, resolves from the ColonyPickingTool[NumberOfHeads].",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> ColonyPickingDepth,
				AllowNull -> True,
				Description -> "The deepness to reach into the agar when collecting a colony. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to 2 Millimeter.",
				NestedIndexMatching -> True,
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> PickCoordinates,
				Description -> "The coordinates, in Millimeters, from which colonies are collected from the source plate where {0 Millimeter, 0 Millimeter} is the center of the source well. This option is only applicable if InoculationSource is SolidMedia.",
				Category -> "Inoculation From Solid Media"
			]
		],
		ModifyOptions[ExperimentPickColonies,
			OptionName -> DestinationFillDirection,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> RowColumnP (* Row|Column *)
			],
			Description -> "Indicates if the destination will be filled with picked colonies in row order or column order. This option is only applicable if InoculationSource is SolidMedia.",
			Default -> Automatic,
			ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to Row.",
			Category -> "Inoculation From Solid Media"
		],
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MaxDestinationNumberOfColumns,
				Description -> "The number of columns of colonies to deposit in the destination container. See Figure 3.12 of ExperimentInoculateLiquidMedia for more information. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set based on the table Fig3.12.",
				NestedIndexMatching -> True,
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> MaxDestinationNumberOfRows,
				Description -> "The number of rows of colonies to deposit in the destination container. See Figure 3.13 of ExperimentInoculateLiquidMedia for more information. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set based on the table Fig3.13.",
				NestedIndexMatching -> True,
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> PrimaryWash,
				AllowNull -> True,
				Default -> Automatic,
				Description -> "Whether the PrimaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to True.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> PrimaryWashSolution,
				Description -> "The first wash solution that is used during the sanitization process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and PrimaryWash is True, automatically set to Model[Sample,StockSolution,\"70% Ethanol\"].",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> NumberOfPrimaryWashes,
				Description -> "The number of times the ColonyHandlerHeadCassette moves in a circular motion in the PrimaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and PrimaryWash is True, automatically set to 5.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> PrimaryDryTime,
				Description -> "The length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in PrimaryWashSolution.. This option is only applicable if InoculationSource is SolidMedia.",
				Default -> Automatic,
				ResolutionDescription -> "If InoculationSource is SolidMedia and PrimaryWash is True, automatically set to 10 Second.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> SecondaryWash,
				AllowNull -> True,
				Description -> "Whether the SecondaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to False if PrimaryWash is False.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> SecondaryWashSolution,
				Description -> "The second wash solution that can be used during the sanitization process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and SecondaryWash is True, automatically set to Model[Sample,\"Milli-Q water\"].",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> NumberOfSecondaryWashes,
				Description -> "The number of times the ColonyHandlerHeadCassette moves in a circular motion in the SecondaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and SecondaryWash is True, automatically set to 5.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> SecondaryDryTime,
				Description -> "The length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in SecondaryWashSolution. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and SecondaryWash is True, automatically set to 10 Second.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> TertiaryWash,
				AllowNull -> True,
				Description -> "Whether the TertiaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to False if SecondaryWash is False.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> TertiaryWashSolution,
				Description -> "The third wash solution that can be used during the sanitization process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and TertiaryWash is True, automatically set to Model[Sample, StockSolution, \"10% Bleach\"].",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> NumberOfTertiaryWashes,
				Description -> "The number of times the ColonyHandlerHeadCassette moves in a circular motion in the TertiaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and TertiaryWash is True, automatically set to 5.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> TertiaryDryTime,
				Description -> "The length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in TertiaryWashSolution. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and TertiaryWash is True, automatically set to 10 Second.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> QuaternaryWash,
				AllowNull -> True,
				Description -> "Whether the QuaternaryWash stage should be turned on during the sanitization process. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia, automatically set to False if TertiaryWash is False.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> QuaternaryWashSolution,
				Description -> "The fourth wash solution that can be used during the process prior to each round of picking. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and QuaternaryWash is True, automatically set to Model[Sample, StockSolution, \"70% Ethanol\"].",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> NumberOfQuaternaryWashes,
				Description -> "The number of times the ColonyHandlerHeadCassette moves in a circular motion in the QuaternaryWashSolution to clean any material off the head. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and QuaternaryWash is True, automatically set to 5.",
				Category -> "Inoculation From Solid Media"
			],
			ModifyOptions[ExperimentPickColonies,
				OptionName -> QuaternaryDryTime,
				Description -> "The length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in QuaternaryWashSolution. This option is only applicable if InoculationSource is SolidMedia.",
				ResolutionDescription -> "If InoculationSource is SolidMedia and QuaternaryWash is True, automatically set to 10 seconds.",
				Category -> "Inoculation From Solid Media"
			],
			(* Inoculate From Liquid Media Only Options *)
			ModifyOptions[ExperimentTransfer,
				OptionName -> AspirationMix,
				ModifiedOptionName -> SourceMix,
				AllowNull -> True,
				Description -> "Indicates if mixing is performed during aspiration from the input sample before the inoculation. This option is only applicable if InoculationSource is LiquidMedia.",
				ResolutionDescription -> "If InoculationSource is LiquidMedia, automatically set to True.",
				Category -> "Inoculation From Liquid Media"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> AspirationMixType,
				ModifiedOptionName -> SourceMixType,
				Description -> "The type of mixing that is performed in the container of the input sample before the inoculation. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette. Swirl has the operator place the container on the surface of the TransferEnvironment and perform NumberOfSourceMixes clockwise rotations of the container. This option is only applicable if InoculationSource is LiquidMedia. Swirl is only applicable when Preparation is set to Manual.",
				ResolutionDescription -> "If InoculationSource is LiquidMedia, automatically set to Pipette if SourceMix is set to True.",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Pipette|Swirl
				],
				Category -> "Inoculation From Liquid Media"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> NumberOfAspirationMixes,
				ModifiedOptionName -> NumberOfSourceMixes,
				Description -> "The number of times that the cells are mixed in the input container. When SourceMixType is Pipette, it refers to the number of times of aspirate-dispense cycles. When SourceMixType is Swirl, it refers to the number of clockwise motions applied to the input container.",
				ResolutionDescription -> "If SourceMix is True, automatically set to 5.",
				Category -> "Inoculation From Liquid Media"
			],
			ModifyOptions[ExperimentTransfer,
				OptionName -> AspirationMixVolume,
				ModifiedOptionName -> SourceMixVolume,
				Description -> "The amount repeatedly aspirated and dispensed via pipette from the input sample in order to mix the source cells before the inoculation. The same pipette and tips used in the inoculation are used to mix the source cells. This option is only applicable if SourceMixType is Pipette.",
				ResolutionDescription -> "If InoculationSource is LiquidMedia, and SourceMixType is Pipette, automatically set to the lesser of either half the sample volume or the InoculationTips's maximum volume.",
				Category -> "Inoculation From Liquid Media"
			],
			(* 4 General and Protocol Options for all inoculation sources *)
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "For each sample, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "For each sample, the label of the sample's container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				UnitOperation -> True
			},
			ModifyOptions[
				ExperimentPickColonies,
				SampleOutLabel,
				Widget -> Alternatives[
					"Single Label" -> Widget[Type -> String, Pattern :> _String, Size -> Line],
					"Multiple Labels" -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]]
				]
			],
			ModifyOptions[
				ExperimentPickColonies,
				ContainerOutLabel
			],
			ModifyOptions[
				ExperimentPickColonies,
				SamplesOutStorageCondition
			]
		],
		ModifyOptions[
			WorkCellOption,
			WorkCell,
			Widget -> Widget[Type -> Enumeration, Pattern :> qPix|bioSTAR|microbioSTAR],
			ResolutionDescription -> "If Preparation is Robotic and InoculationSource is LiquidMedia, automatically set to bioSTAR if the cell types of input samples contain Mammalian, otherwise set to microbioSTAR. If InoculationSource is SolidMedia, automatically set to qPix."
		],
		ProtocolOptions,
		SubprotocolDescriptionOption,
		PreparationOption,
		SimulationOption,
		ModifyOptions[
			SamplesInStorageOptions,
			SamplesInStorageCondition,
			Default -> Automatic,
			ResolutionDescription -> "If InoculationSource is FreezeDried, automatically set to Disposal. Otherwise, automatically set to the current StorageCondition of the provided input sample."
		],
		BiologyPostProcessingOptions,
		(* For Model[Sample] input, we can only allow standard commercial forms: FreezeDried, FrozenGlycerol, AgarStab.*)
		(* The amount and container are not technically options for users, but we need them to calculate. *)
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to All."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		(* don't actually want this exposed to the customer, but do need it under the hood for ModelInputOptions to work *)
		ModifyOptions[
			PreparatoryUnitOperationsOption,
			Category -> "Hidden"
		]
	}
];


(* ::Subsection:: *)
(*Warning and Error Messages*)


(* Invalid Inputs *)
Error::MultipleInoculationSourceInInput = "Across the input samples `1`, there are different types of InoculationSources: `2`. Please split up input samples into multiple protocols and have only one type of InoculationSource for each protocol.";
Error::DuplicatedFreezeDriedSamples = "The input samples `1` contain duplicates while the type of InoculationSource is FreezeDried. Starting from the same freeze-dried sample is not supported as it can only be resuspended once. Please check if the InoculationSource is correct or specify multiple DestinationMediaContainer for the sample if multiple inoculations are intended from the sample.";
Error::InvalidModelSampleInoculationSourceType = "The InoculationSource of input samples `1` are classified as `2`. When a model sample is specified as input, the entire amount of the input model sample that comes from a product in the catalog is used as the inoculation source. Only cell sample models in FreezeDried, FrozenGlycerol, or AgarStab form are currently supported as inoculation source for model input.";
Error::UnsupportedInoculationSourceType = "The input samples `1` are classified as FrozenLiquidMedia since no glycerol is found in the composition. FrozenLiquidMedia is not a supported InoculationSource. To start cell culture from cells stored in frozen media without glycerol, please call ExperimentIncubate first to thaw the samples.";
Error::ConflictingInoculationSource = "`4`. Thus the input samples `1` have InoculationSource classified as `2`, not the InoculationSource option value `3`. Please change InoculationSource option to match the classification of the input samples or allow this option to be set automatically.";
Warning::ConflictingInoculationSource = "`3`. Thus the input samples `1` are not classified as `2`. InoculationSource `2` is going to be used despite the mismatch in sample composition.";
(* Invalid Options *)
Error::InvalidInoculationInstrument = "The specified Instrument(s), `1`, cannot be used for InoculationSource `2`. `3`. Please specify a different Instrument, or allow this option to be set automatically.";
Error::IncompatibleInstrumentAndCellType = "The input samples, `1`, have cell types `2` incompatible with Instrument `3`. `4`.";
Error::IncompatibleBiosafetyCabinetAndCellType = "The input samples, `1`, have cell types `2` incompatible with the biosafety cabinet specified in TransferEnvironment `3`. Model[Instrument,HandlingStation,BiosafetyCabinet,\"Biosafety Cabinet Handling Station for Tissue Culture\"](or an object of this model) allows inoculation of mammalian cells. Model[Instrument,HandlingStation,BiosafetyCabinet,\"Biosafety Cabinet Handling Station for Microbiology\"] allows inoculation of microbial cells. Please specify a TransferEnvironment compatible with the cells in the samples or leave it to be set automatically.";
Error::InoculationSourceOptionMismatch = "InoculationSource is set to `1`. `3`. Please look at the ExperimentInoculateLiquidMedia help file to see what options can be specified when InoculationSource is `1`, or allow the options to be set automatically";
Warning::NoPreferredLiquidMedia = "The input samples, `1`, either do not have any model cell in their composition or the model cells in the Composition do not have a PreferredLiquidMedia. DestinationMedia will be set to Model[Sample, Media, \"LB Broth, Miller\"].";
Error::DestinationMediaContainerOverfill = "The input samples, `1` would have total volume(s) `3` in DestinationMediaContainer `2`. This would result in overflowing. Please either decrease the Volume or MediaVolume in order to submit a valid experiment.";
Error::MultipleDestinationMediaContainers = "The input samples, `1`, have InoculationSource as `2` but DestinationMediaContainer as a list of Objects. `3` or allow these options to be set automatically.";
Error::NoTipsFound = "For the input samples, `1`, no pipette tip can touch the top of the sample in the source container and the bottom of the DestinationMediaContainer. Please specify a different DestinationMediaContainer, or allow the option to be set automatically.";
Error::TipConnectionMismatch = "The input samples, `1`, have a specified Instrument and InoculationTips that do not have the same TipConnectionType. Please specify Instruments and InoculationTips with the same TipConnectionType or allow these options to be set automatically.";
Warning::NoPreferredLiquidMediaForResuspension = "The input samples, `1`, either do not have model cell in their composition or the model cells in the Composition do not have a PreferredLiquidMedia. ResuspensionMedia will be resolved to Model[Sample, Media, \"LB Broth, Miller\"]";
Error::InvalidResuspensionMediaState = "For the following samples, `1`, the ResuspensionMedia has a non Liquid State. Please specify a different ResuspensionMedia or allow this option to be set automatically.";
Error::ResuspensionMediaOverfill = "The input samples, `1` would have total volume(s) `3` in the source container `2` upon addition of ResuspensionMedia `4`. This would result in overflowing. Please either decrease the ResuspensionMediaVolume in order to submit a valid experiment.";
Error::FreezeDriedUnusedSample = "The sample(s) `1` are expected to have a total volume of `2` after resuspending. Currently, the Volume is set to `3` and the DestinationMediaContainer option is set to `4`. Under these conditions, `5` of the sample(s) will not be used and will therefore be discarded. Consider adjusting the Volume or specify multiple DestinationMediaContainer for the sample in order to submit a valid experiment.";
Error::InsufficientResuspensionMediaVolume = "The sample(s) `1` are expected to have a total volume of `2` after resuspending. Currently, the Volume is set to `3` and the DestinationMediaContainer option is set to `4`. Under these conditions, a total `5` of the resuspended sample(s) are required. Consider decreasing the Volume or specify less DestinationMediaContainer, or increasing ResuspensionMediaVolume in order to submit a valid experiment.";
Warning::NoResuspensionMix = "The input samples, `1`, are specified not to mix during resuspension. This might lead to transfer of non-homogenous cell resuspension and unsuccessful inoculation.";
Error::ResuspensionMixMismatch = "The input samples, `1`, have ResuspensionMix set to True and one or more of ResuspensionMixType, NumberOfResuspensionMixes, and ResuspensionMixVolume set to Null. Or ResuspensionMix set to False and one or more of ResuspensionMixType, NumberOfResuspensionMixes, and ResuspensionMixVolume not set to Null. Please align these options or allow them to be set automatically.";

(* ::Subsection::Closed:: *)
(*Experiment Function*)
(* CORE Overload *)
(* ::Code::Initialization:: *)

ExperimentInoculateLiquidMedia[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[]] := Module[
	{
		outputSpecification, output, gatherTests, listedSamplesNamed, listedOptionsNamed, samplesWithPreparedSamplesNamed,
		validSamplePreparationResult, optionsWithPreparedSamplesNamed, updatedSimulation, safeOpsNamed, safeOpsTests,
		listedSamples, safeOps, listedOptions, validLengths, validLengthTests, templatedOptions, templateTests,
		inheritedOptions, preExpandedImagingStrategies, preExpandedExposureTimes, manuallyExpandedImagingStrategies,
		manuallyExpandedExposureTimes, expandedSafeOps, cache, preferredMedia, preferredDestinationMediaContainers, possibleDefaultTips,
		defaultObjects, allObjects, sampleObjects, sampleModelObjects, objectContainerObjects, modelContainerObjects,
		objectTipObjects, modelTipObjects, objectPipetteObjects, modelPipetteObjects, biosafetyCabinetObjects, biosafetyCabinetModels,
		roboticInstrumentModels, roboticInstrumentObjects, sampleObjectDownloadFields, modelSampleDownloadFields, containerDownloadFields,
		containerModelDownloadFields, tipObjectDownloadFields, tipModelDownloadFields, pipetteObjectDownloadFields, pipetteModelDownloadFields,
		transferEnvironmentDownloadFields, transferEnvironmentModelDownloadFields, downloadValue, cacheBall, resolvedOptionsResult,
		roboticSimulation, protocolPacket, unitOperationPacket, batchedUnitOperationPackets, resolvedOptions, resolvedOptionsTests,
		preCollapsedResolvedOptions, collapsedResolvedOptions, resolvedPreparation, optionsResolverOnly, returnEarlyBecauseFailuresQ,
		returnEarlyQBecauseOptionsResolverOnly, performSimulationQ, protocolObject, roboticRunTime, resourcePacketTests,
		simulatedProtocol, simulatedProtocolSimulation, uploadQ, allUnitOperationPackets
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links. *)
	{listedSamplesNamed, listedOptionsNamed} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentInoculateLiquidMedia,
			listedSamplesNamed,
			listedOptionsNamed
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentInoculateLiquidMedia, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentInoculateLiquidMedia, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

  (* replace all objects referenced by Name to ID *)
	{listedSamples, safeOps, listedOptions} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOpsNamed, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentInoculateLiquidMedia, {listedSamples}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentInoculateLiquidMedia, {listedSamples}, listedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentInoculateLiquidMedia, {ToList[listedSamples]}, safeOps, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentInoculateLiquidMedia, {ToList[listedSamples]}, safeOps], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* Normally, SingletonClassificationPreferred or ExpandedClassificationPreferred is used to expand multi-select *)
	(* However, imaging options are NestedIndexMatched to each other but that information is not *)
	(* in their OptionDefinition because there can only be one NestedIndexMatching block per IndexMatching block *)
	(* Note: but we can be smart here to check if it is singleton or not *)
	(* Basically, the only value allowed for singleton for ImagingStrategies is BrightField *)
	(* And ImagingChannels and ExposureTimes are index matched to ImagingStrategies *)
	{
		preExpandedImagingStrategies,
		preExpandedExposureTimes
	} = Lookup[inheritedOptions,
		{
			ImagingStrategies,
			ExposureTimes
		}
	];
	manuallyExpandedImagingStrategies = Which[
		(* For Imaging options are not specified, do not expand it yet *)
		MatchQ[preExpandedImagingStrategies, Automatic] && MatchQ[preExpandedExposureTimes, Automatic],
			Automatic,
		MatchQ[preExpandedImagingStrategies, BrightField],
			(* If a singleton value is given and collapsed *)
			ConstantArray[preExpandedImagingStrategies, Length[listedSamples]],
		MatchQ[preExpandedImagingStrategies, BrightField | Automatic],
			(* If a singleton value is given and collapsed *)
			ConstantArray[preExpandedImagingStrategies, Length[listedSamples]],
		MatchQ[preExpandedImagingStrategies, {(BrightField | Automatic)..}] && EqualQ[Length[preExpandedImagingStrategies], Length@listedSamples],
			(* If a singleton value is given and not collapsed *)
			preExpandedImagingStrategies,
		MatchQ[preExpandedImagingStrategies, _List] && !MemberQ[preExpandedImagingStrategies, _List],
			(* If it is a list and collapsed *)
			ConstantArray[preExpandedImagingStrategies, Length[listedSamples]],
		True,
			(* If a list of values or a mix of list and singleton *)
			preExpandedImagingStrategies
	];

	manuallyExpandedExposureTimes = Which[
		(* For Imaging options are not specified, do not expand it yet *)
		MatchQ[manuallyExpandedImagingStrategies, Automatic] && MatchQ[preExpandedExposureTimes, Automatic],
			Automatic,
		MatchQ[preExpandedExposureTimes, Automatic | _Real],
			(* If a singleton value is given and collapsed *)
			Map[If[MatchQ[#, _List], ConstantArray[preExpandedExposureTimes, Length[#]], preExpandedExposureTimes]&, manuallyExpandedImagingStrategies],
		And[
			MatchQ[preExpandedExposureTimes, {(Automatic | _Real)..}],
			MatchQ[manuallyExpandedImagingStrategies, {BrightField..}],
			EqualQ[Length[preExpandedExposureTimes], Length@listedSamples]
		],
			(* If a singleton value is given and not collapsed *)
			preExpandedExposureTimes,
		MatchQ[preExpandedExposureTimes, _List] && !MemberQ[preExpandedExposureTimes, _List],
			(* If it is a list and collapsed *)
			ConstantArray[preExpandedExposureTimes, Length[listedSamples]],
		True,
			(* If a list of values or a mix of list and singleton *)
			preExpandedExposureTimes
	];

	(* Updating imaging options with the manually expanded values *)
	expandedSafeOps = Join[
		Last[
			ExpandIndexMatchedInputs[
				ExperimentInoculateLiquidMedia,
				{ToList[listedSamples]},
				Normal[KeyDrop[inheritedOptions, {ImagingStrategies, ExposureTimes}], Association]
			]
		],
		{
			ImagingStrategies -> manuallyExpandedImagingStrategies,
			ExposureTimes -> manuallyExpandedExposureTimes
		}
	];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that cache is added first to the cache ball, before the main download. *)
	cache = Lookup[expandedSafeOps, Cache, {}];

	(* Possible Media sample used in findPreferredMediaOfCellSample as default value *)
	preferredMedia = {Model[Sample, Media, "id:XnlV5jlXbNx8"]};(* Model[Sample, Media, "LB Broth, Miller"] *)

	(* Possible DestinationMediaContainers from PreferredContainer *)
	preferredDestinationMediaContainers = DeleteDuplicates@Join[
		PreferredContainer[All, Type -> All, CultureAdhesion -> Suspension, CellType -> Bacterial],
		PreferredContainer[All, Type -> All, CultureAdhesion -> SolidMedia, CellType -> Bacterial],
		PreferredContainer[All, Type -> All, LiquidHandlerCompatible -> True, Sterile -> True],
		PreferredContainer[All, Type -> All, LiquidHandlerCompatible -> True, CultureAdhesion -> Suspension, CellType -> Mammalian]
	];

	(* Default Tips to use from TransferDevices *)
	possibleDefaultTips = TransferDevices[Model[Item, Tips], All, PipetteType -> {Micropipette, Serological, Hamilton}, Sterile -> True][[All, 1]];

	(* Default media, container and tip model. *)
	defaultObjects = Join[
		preferredMedia,
		preferredDestinationMediaContainers,
		possibleDefaultTips
	];

	(* All the objects. *)
	(* NOTE: Include the default samples, containers, tips and instruments that we can use since we want their packets as well. *)
	allObjects = DeleteDuplicates@Quiet[
		Download[
			Cases[
				Flatten@Join[
					ToList[listedSamples],
					ToList[Lookup[expandedSafeOps, {Instrument, DestinationMedia, DestinationMediaContainer, ResuspensionMedia, InoculationTips, TransferEnvironment, Instrument}]],
					defaultObjects,
					inoculateInstrumentModelsSearch["Memoization"],(* bsc and pipette models *)
					inoculateInstrumentsSearch["Memoization"](* bsc objects *)
				],
				ObjectP[]
			],
			Object,
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		Download::FieldDoesntExist
	];

	(* Get the objects from options to download from *)
	sampleObjects = Cases[allObjects, ObjectP[Object[Sample]]];
	sampleModelObjects = Cases[allObjects, ObjectP[Model[Sample]]];
	objectContainerObjects = Cases[allObjects, ObjectP[Object[Container]]];
	modelContainerObjects = Cases[allObjects, ObjectP[Model[Container]]];
	objectTipObjects = Cases[allObjects, ObjectP[Object[Item, Tips]]];
	modelTipObjects = Cases[allObjects, ObjectP[Model[Item, Tips]]];
	objectPipetteObjects = Cases[allObjects, ObjectP[Object[Instrument, Pipette]]];
	modelPipetteObjects = Cases[allObjects, ObjectP[Model[Instrument, Pipette]]];
	biosafetyCabinetObjects = Cases[allObjects, ObjectP[Object[Instrument, HandlingStation, BiosafetyCabinet]]];
	biosafetyCabinetModels = Cases[allObjects, ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet]]];
	roboticInstrumentModels = Cases[allObjects, ObjectP[{Model[Instrument, LiquidHandler], Model[Instrument, ColonyHandler]}]];
	roboticInstrumentObjects = Cases[allObjects, ObjectP[{Object[Instrument, LiquidHandler], Object[Instrument, ColonyHandler]}]];

	(* Define the packets we need to extract from the downloaded cache *)
	sampleObjectDownloadFields = SamplePreparationCacheFields[Object[Sample]];
	modelSampleDownloadFields = SamplePreparationCacheFields[Model[Sample]];
	containerDownloadFields = SamplePreparationCacheFields[Object[Container]];
	containerModelDownloadFields = SamplePreparationCacheFields[Model[Container]];
	tipObjectDownloadFields = {Name, Model, PipetteType, Material, WideBore, Aspirator, Filtered, GelLoading, MaxVolume, AspirationDepth, Diameter3D, TipConnectionType};
	tipModelDownloadFields = {Name, NumberOfTips, PipetteType, Material, WideBore, Aspirator, Filtered, GelLoading, MaxVolume, AspirationDepth, Diameter3D, TipConnectionType};
	pipetteObjectDownloadFields = {Name, Site, Model, TipConnectionType, PipetteType};
	pipetteModelDownloadFields = {Name, TipConnectionType, MaxVolume, CultureHandling};
	transferEnvironmentDownloadFields = {Name, Site, Model, Pipettes, BiosafetyWasteBin};
	transferEnvironmentModelDownloadFields = {Name, Pipettes, DefaultBiosafetyWasteBinModel, CultureHandling};

	(* Download from cache and simulation *)
	downloadValue = Quiet[
		Download[
			{
				sampleObjects,
				sampleModelObjects,
				modelContainerObjects,
				objectContainerObjects,
				modelTipObjects,
				objectTipObjects,
				modelPipetteObjects,
				objectPipetteObjects,
				biosafetyCabinetModels,
				biosafetyCabinetObjects,
				roboticInstrumentModels,
				roboticInstrumentObjects
			},
			{
				{
					Evaluate[Packet@@sampleObjectDownloadFields],
					Packet[Model[modelSampleDownloadFields]],
					Packet[Composition[[All, 2]][{CellType, PreferredLiquidMedia}]],
					Packet[Container[containerDownloadFields]],
					Packet[Container[Model][containerModelDownloadFields]],
					Packet[Container[Cover][{Reusable, Model}]],
					Packet[Container[Cover][Model][CoverType]],
					Packet[StorageCondition[StorageCondition]]
				},
				{
					Evaluate[Packet@@modelSampleDownloadFields],
					Packet[Composition[[All, 2]][{CellType, PreferredLiquidMedia}]]
				},
				{
					Evaluate[Packet@@containerModelDownloadFields],
					Packet[VolumeCalibrations[{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]]
				},
				{
					Evaluate[Packet@@containerDownloadFields],
					Packet[Model[containerModelDownloadFields]],
					Packet[Model[VolumeCalibrations][{CalibrationFunction, EmptyDistanceDistribution, WellEmptyDistanceDistributions, TareDistanceDistribution}]],
					Packet[Model, RecommendedFillVolume, Notebook],
					Packet[Cover[{Reusable, Model}]],
					Packet[Cover[Model][CoverType]]
				},
				{
					Evaluate[Packet@@tipModelDownloadFields]
				},
				{
					Evaluate[Packet@@tipObjectDownloadFields]
				},
				{
					Evaluate[Packet@@pipetteModelDownloadFields]
				},
				{
					Evaluate[Packet@@pipetteObjectDownloadFields]
				},
				{
					Evaluate[Packet@@transferEnvironmentModelDownloadFields]
				},
				{
					Evaluate[Packet@@transferEnvironmentDownloadFields]
				},
				{
					Packet[Name, LiquidHandlerType]
				},
				{
					Packet[Name, Model],
					Packet[Model[LiquidHandlerType]]
				}
			},
			Cache -> cache,
			Simulation -> updatedSimulation
		],
		Download::FieldDoesntExist
	];
	cacheBall = FlattenCachePackets[{cache, downloadValue}];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentInoculateLiquidMediaOptions[listedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveExperimentInoculateLiquidMediaOptions[listedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* When InoculationSource is SolidMedia, manually collapse imaging options *)
	(* they are NestedIndexMatched to each other but that information is not *)
	(* in their OptionDefinition because there can only be one NestedIndexMatching block per IndexMatching block *)
	(* NOTE: This collapsing logic is mirrored from CollapseIndexMatchedOptions. We know that both options are IndexMatching *)
	(* are currently in an expanded form and are nested index matching *)
	preCollapsedResolvedOptions = Map[
		Function[{option},
			Module[{inoculationSource, resolvedOptionRule, inheritedOptionRule},
				inoculationSource = Lookup[resolvedOptions, InoculationSource];
				resolvedOptionRule = Lookup[resolvedOptions, option];
				inheritedOptionRule = Lookup[inheritedOptions, option];
				Which[
					(* If it is not solid media, ignore it *)
					!MatchQ[inoculationSource, SolidMedia],
						option -> Null,
					(* If the option was specified by the user, ignore it *)
					MatchQ[resolvedOptionRule, inheritedOptionRule],
						option -> resolvedOptionRule,
					(* If there is the same singleton pattern across all samples, collapse it to a single singleton value *)
					And[
						MatchQ[resolvedOptionRule, _List],
						!MemberQ[resolvedOptionRule, _List],
						SameQ @@ Flatten[ToList[resolvedOptionRule], 1]
					],
						option -> First[ToList[resolvedOptionRule]],
					(* If there is the same list pattern across all nested lists, collapse it to a list value *)
					MatchQ[resolvedOptionRule, {_List..}] && SameQ @@ resolvedOptionRule,
						option -> First[resolvedOptionRule],
					(* Otherwise, this means the option is not the same across all nested lists, so leave it alone *)
					True,
						option -> resolvedOptionRule
				]
			]
		],
		{ImagingStrategies, ImagingChannels, ExposureTimes}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = Join[
		CollapseIndexMatchedOptions[
			ExperimentInoculateLiquidMedia,
			Normal[KeyDrop[resolvedOptions, {ImagingStrategies, ImagingChannels, ExposureTimes}], Association],
			Ignore -> ToList[myOptions],
			Messages -> False
		],
		{
			ImagingStrategies -> Lookup[preCollapsedResolvedOptions, ImagingStrategies],
			ImagingChannels -> Lookup[preCollapsedResolvedOptions, ImagingChannels],
			ExposureTimes -> Lookup[preCollapsedResolvedOptions, ExposureTimes]
		}
	];

	(* Lookup our option values.  This will determine if we skip the resource packets and simulation functions *)
	(* If Output contains Result or Simulation, then we can't do this *)
	{resolvedPreparation, optionsResolverOnly} = Lookup[resolvedOptions, {Preparation, OptionsResolverOnly}];
	returnEarlyQBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. *)
	(* NOTE: We need to perform simulation if Result is asked for in Inoculate since it's part of the CellPreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentRCP (in the case of Preparation -> Robotic). *)
	performSimulationQ = MemberQ[output, Result | Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[(returnEarlyBecauseFailuresQ || returnEarlyQBecauseOptionsResolverOnly) && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{{protocolPacket, unitOperationPacket, batchedUnitOperationPackets, roboticSimulation, roboticRunTime}, resourcePacketTests} = If[returnEarlyBecauseFailuresQ || returnEarlyQBecauseOptionsResolverOnly,
		{{$Failed, $Failed, $Failed, $Failed, $Failed}, {}},
		If[gatherTests,
			inoculateLiquidMediaResourcePackets[listedSamples, listedOptionsNamed, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{inoculateLiquidMediaResourcePackets[listedSamples, listedOptionsNamed, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation], {}}
		]
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulatedProtocolSimulation} = Which[
		returnEarlyBecauseFailuresQ || !performSimulationQ,
			{Null, updatedSimulation},
		(* If Preparation -> Manual, we have to simulate the sample movements *)
		performSimulationQ && MatchQ[resolvedPreparation, Manual],
			simulateInoculateLiquidMedia[
				If[MatchQ[protocolPacket, $Failed],
					$Failed,
					protocolPacket
				],
				listedSamples,
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				ParentProtocol -> Lookup[safeOps, ParentProtocol]
			],
		performSimulationQ && MatchQ[resolvedPreparation, Robotic] && MatchQ[batchedUnitOperationPackets, {PacketP[]..}],
			simulateExperimentPickColonies[
				unitOperationPacket,
				listedSamples,
				resolvedOptions,
				ExperimentInoculateLiquidMedia,
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
		(* If Preparation -> Robotic, we can use the roboticSimulation from the ResourcePackets *)
		performSimulationQ && MatchQ[resolvedPreparation, Robotic] && MatchQ[roboticSimulation, SimulationP],
			{Null, roboticSimulation},
		(* Otherwise, we don't have to return a simulation *)
		True,
			{Null, updatedSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulatedProtocolSimulation,
			RunTime -> If[MatchQ[resolvedPreparation, Robotic],
				roboticRunTime,
				inoculateLiquidMediaRunTime[mySamples]
			]
		}]
	];

	(* Lookup if we are supposed to upload *)
	uploadQ = Lookup[safeOps, Upload];

	(* Gather all the unit operation packets *)
	allUnitOperationPackets = Flatten[{unitOperationPacket, batchedUnitOperationPackets}];

	(* We have to return the result. Call UploadProtocol[..] to prepare our protocol packet (and upload it if asked) *)
	protocolObject = Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[protocolPacket, $Failed] || MatchQ[unitOperationPacket, $Failed] || MatchQ[resolvedOptionsResult, $Failed],
			$Failed,

		(* If Preparation is Robotic, return the unit operation packets back without RequireResources called if *)
		(* Upload -> False *)
		MatchQ[resolvedPreparation, Robotic] && !uploadQ,
			allUnitOperationPackets,

		(* If we're doing Preparation -> Robotic and Upload -> True, call ExperimentRoboticCellPreparation with our primitive *)
		MatchQ[resolvedPreparation, Robotic],
			Module[
				{
					primitive, nonHiddenOptions
				},
				(* Create the InoculateLiquidMedia primitive to feed into RoboticCellPreparation *)
				primitive = InoculateLiquidMedia @@ Join[
					{
						Sample -> Download[ToList[mySamples], Object]
					},
					RemoveHiddenPrimitiveOptions[InoculateLiquidMedia, ToList[myOptions]]
				];

				(* Remove any hidden options before returning *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentInoculateLiquidMedia, collapsedResolvedOptions];

				(* Memoize the value of ExperimentInoculateLiquidMedia so the framework doesn't spend time resolving it again. *)
				Block[{ExperimentInoculateLiquidMedia, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache = <||>;

					ExperimentInoculateLiquidMedia[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> allUnitOperationPackets,
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulatedProtocolSimulation,
							RunTime -> roboticRunTime
						}
					];

					ExperimentRoboticCellPreparation[
						{primitive},
						Name -> Lookup[safeOps, Name],
						Instrument -> Lookup[collapsedResolvedOptions, Instrument],
						Upload -> Lookup[safeOps, Upload],
						Confirm -> Lookup[safeOps, Confirm],
						CanaryBranch -> Lookup[safeOps, CanaryBranch],
						ParentProtocol -> Lookup[safeOps, ParentProtocol],
						Priority -> Lookup[safeOps, Priority],
						StartDate -> Lookup[safeOps, StartDate],
						HoldOrder -> Lookup[safeOps, HoldOrder],
						QueuePosition -> Lookup[safeOps, QueuePosition],
						Cache -> cacheBall
					]
				]
			],

		(* Otherwise, upload an Object[Protocol, InoculateLiquidMedia] *)
		True,
			UploadProtocol[
				protocolPacket, (* Protocol packet *)
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol, InoculateLiquidMedia],
				Cache -> cacheBall,
				Simulation -> simulatedProtocolSimulation
			]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulatedProtocolSimulation,
		RunTime -> If[MatchQ[resolvedPreparation, Robotic],
			roboticRunTime,
			inoculateLiquidMediaRunTime[mySamples]
		]
	}
];

(* Container and Prepared Samples Overload *)
ExperimentInoculateLiquidMedia[myContainers: ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String| {LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions: OptionsPattern[]] := Module[
	{
		outputSpecification, output, gatherTests, listedContainers, listedOptions, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationSimulation, validSamplePreparationResult,  containerToSampleOutput, containerToSampleTests, containerToSampleSimulation,
		containerToSampleResult, samples, sampleOptions
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links. *)
	{listedContainers, listedOptions} = removeLinks[ToList[myContainers], ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentInoculateLiquidMedia,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> All
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentInoculateLiquidMedia,
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
				ExperimentInoculateLiquidMedia,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> samplePreparationSimulation
			],
			$Failed,
			{Download::ObjectDoesNotExist, Error::EmptyContainer}
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
		ExperimentInoculateLiquidMedia[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(* ::Subsection:: *)
(*RunTime Resolver*)
inoculateLiquidMediaRunTime[mySamples_] := 5 Minute * Length[mySamples];


(* ::Subsection::Closed:: *)
(*Helper functions*)
(* NOTE: We also cache our search in case we will do it multiple times. *)
inoculateInstrumentModelsSearch[testString_] := inoculateInstrumentModelsSearch[testString] = Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`inoculateInstrumentModelsSearch],
		AppendTo[$Memoization, Experiment`Private`inoculateInstrumentModelsSearch]
	];
	Search[
		{
			{Model[Instrument, HandlingStation, BiosafetyCabinet], Model[Instrument, Pipette], Model[Instrument, LiquidHandler], Model[Instrument, ColonyHandler]}
		},
		Deprecated != True && DeveloperObject != True
	]
];

inoculateInstrumentsSearch[testString_] := inoculateInstrumentsSearch[testString] = Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`inoculateInstrumentsSearch],
		AppendTo[$Memoization, Experiment`Private`inoculateInstrumentsSearch]
	];
	Search[
		Object[Instrument, HandlingStation, BiosafetyCabinet],
		Notebook == Null && DeveloperObject != True
	]
];

(*-- Helper:classifyInoculationSampleTypes --*)
classifyInoculationSampleTypes[inputSamples: ListableP[ObjectP[Object[Sample]]], inoculationSource: InoculationSourceP|FrozenLiquidMedia|Automatic, combinedAssoc_Association] := classifyInoculationSampleTypes[inputSamples, combinedAssoc] = Module[
	{frozenConditionsP, samplePackets, samplesClassificationInfo, classificationToSampleLookup},
	(* Memoize *)
	If[!MemberQ[$Memoization, classifyInoculationSampleTypes],
		AppendTo[$Memoization, classifyInoculationSampleTypes]
	];

	(* List the storage conditions that we consider as deep frozen for classifying frozen glycerol samples or frozen liquid media samples *)
	frozenConditionsP = ObjectP[{Model[StorageCondition, "id:xRO9n3BVOe3z"](*DeepFreezer*), Model[StorageCondition, "id:6V0npvmE09vG"](*Cryogenic*)}];

	(* Get the sample packets from input association *)
	samplePackets = fetchPacketFromFastAssoc[#, combinedAssoc]& /@ ToList[inputSamples];

	samplesClassificationInfo = MapThread[
		Function[{sample, samplePacket},
			Module[
				{
					sampleContainer, sampleState, sampleStorageCondition, sampleComposition, glycerolQ, agarQ, containerModelPacket,
					sampleContainerModel, hermeticOrAmpoule, classification, errorQ, errorTypes
				},

				{
					sampleContainer,
					sampleState,
					sampleStorageCondition,
					sampleComposition
				} = Lookup[
					samplePacket,
					{
						Container,
						State,
						StorageCondition,
						Composition
					}
				];

				(* Check if sample contains Glycerol *)
				(* Note: if cryoprotectant is not glycerol, say DMSO, scrapes won't work as inoculation procedure *)
				(* Note: if there is no Composition value, defaults to True *)
				glycerolQ = NullQ[sampleComposition] || MemberQ[sampleComposition[[All, 2]], ObjectP[Model[Molecule, "id:WNa4ZjKVdbW7"]]];(*"Glycerol"*)
				agarQ = NullQ[sampleComposition] || MemberQ[sampleComposition[[All, 2]], ObjectP[{Model[Molecule, "id:4pO6dM5l7lMX"], Model[Molecule, "id:zGj91a70m0lv"]}]];(*"Agarose" and "Agar"*)

				(* Lookup sample container model *)
				containerModelPacket = If[MatchQ[sampleContainer, ObjectP[Object[Container]]],
					fastAssocPacketLookup[combinedAssoc, sampleContainer, Model],
					(*Just in case it is already a model*)
					fetchPacketFromFastAssoc[sampleContainer, combinedAssoc]
				];

				(* Get the Hermetic and ampoule bool of the sample container object or model *)
				sampleContainerModel = Lookup[containerModelPacket, Object];
				hermeticOrAmpoule = MemberQ[Lookup[containerModelPacket, {Hermetic, Ampoule}], True];

				(* Classify sample into SolidMedia, LiquidMedia, AgarStab, FreezeDried, FrozenGlycerol, FrozenLiquidMedia *)
				classification = Switch[{sampleContainer, hermeticOrAmpoule, sampleState, sampleStorageCondition, glycerolQ, agarQ},

					(* If the state is solid and the container is ampoule or hermetic, sample is FreezeDried *)
					{_, True, Solid, _, _, _}, FreezeDried,

					(* If the state is solid and contains agar and the container is a plate -> SolidMedia source (can pick off of) *)
					{ObjectP[Object[Container, Plate]], False | Null, Solid, _, _, True}, SolidMedia,

					(* If the storage condition is one of the frozen conditions and contains glycerol -> FrozenGlycerol *)
					{_, False | Null, Solid, frozenConditionsP, True, _}, FrozenGlycerol,

					(* If the storage condition is one of the frozen conditions and does not contains glycerol ->FrozenLiquidMedia *)
					(* Note:FrozenGlycerol and FrozenLiquidMedia are different here since we can only Incubate FrozenLiquidMedia to LiquidMedia to start inoculation *)
					{_, False | Null, Solid, frozenConditionsP, False, _}, FrozenLiquidMedia,

					(* Otherwise if the state is solid and contains agar but the container is not a plate -> AgarStab *)
					{_, False | Null, Solid, _, _, True}, AgarStab,

					(* Else if the state is liquid it is a LiquidMedia source *)
					{_, _, Liquid, _, _, _}, LiquidMedia,

					(* Catchall - put as liquid if State is not populated *)
					_, LiquidMedia
				];
				(* Check if specified InoculationSource matches our classification *)
				errorQ = !MatchQ[inoculationSource, classification|Automatic];

				(* Check why specified InoculationSource does not match our classification *)
				errorTypes = If[TrueQ[errorQ],
					Which[
						MatchQ[inoculationSource, FreezeDried],
							{
								If[MatchQ[sampleState, Except[Solid]], State, Nothing],
								If[MatchQ[hermeticOrAmpoule, Except[True]], Hermetic, Nothing]
							},
						MatchQ[inoculationSource, SolidMedia],
							{
								If[MatchQ[sampleState, Except[Solid]], State, Nothing],
								If[MatchQ[sampleContainer, Except[ObjectP[Object[Container, Plate]]]], Container, Nothing],
								If[MatchQ[agarQ, Except[True]], Agarose, Nothing]
							},
						MatchQ[inoculationSource, FrozenGlycerol],
							{
								If[MatchQ[sampleState, Except[Solid]], State, Nothing],
								If[MatchQ[sampleStorageCondition, Except[frozenConditionsP]], StorageCondition, Nothing],
								If[MatchQ[hermeticOrAmpoule, True], Hermetic, Nothing],
								If[MatchQ[glycerolQ, Except[True]], Glycerol, Nothing]
							},
						MatchQ[inoculationSource, AgarStab],
							{
								If[MatchQ[sampleState, Except[Solid]], State, Nothing],
								If[MatchQ[agarQ, Except[True]], Agarose, Nothing]
							},
						True,
							{
								If[MatchQ[sampleState, Except[Liquid]], State, Nothing]
							}
					],
					{}
				];

				(* Return the information *)
				<|
					Object -> sample,
					Container -> Download[sampleContainer, Object],
					InoculationSource -> classification,
					StorageCondition -> Download[sampleStorageCondition, Object],
					State -> sampleState,
					Hermetic -> hermeticOrAmpoule,
					Glycerol -> glycerolQ,
					Agarose -> agarQ,
					Error -> errorQ,
					ErrorTypes -> errorTypes
				|>
			]
		],
		{ToList[inputSamples], samplePackets}
	];

	(* Return sorted samples in the order of SolidMedia, LiquidMedia, AgarStab, FreezeDried, FrozenGlycerol, FrozenLiquidMedia *)
	classificationToSampleLookup = Map[
		(Keys[#] -> Lookup[Values[#], Object])&,
		Normal[GroupBy[samplesClassificationInfo, #[InoculationSource]&], Association](* sorted samples with SolidMedia, LiquidMedia, AgarStab, FreezeDried, FrozenGlycerol, FrozenLiquidMedia *)
	];

	(* Return both lookup *)
	{
		samplesClassificationInfo,
		classificationToSampleLookup
	}
];


(*-- Helper:checkMismatchedOptionsForInoculationSource --*)
checkMismatchedOptionsForInoculationSource[myOptions: {_Rule...}, optionDefs: {_Association..}, sourceType: InoculationSourceP] := Module[
	{sourceHiddenOptions, badOptions},
	(* Get the symbols specific hidden to the inoculation source type *)
	sourceHiddenOptions = Switch[sourceType,
		SolidMedia, DeleteDuplicates@Join[$InoculationTransferOptionSymbols, $LiquidMediaOptionSymbols, $FreezeDriedOptionSymbols, $FrozenGlycerolOptionSymbols, $AgarStabOptionSymbols, {DestinationMixVolume, DestinationWell}],
		LiquidMedia, Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $FreezeDriedOptionSymbols, $FrozenGlycerolOptionSymbols, $AgarStabOptionSymbols], $LiquidMediaOptionSymbols],
		AgarStab,  Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $FreezeDriedOptionSymbols, $FrozenGlycerolOptionSymbols, $LiquidMediaOptionSymbols], $AgarStabOptionSymbols],
		FreezeDried, Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $AgarStabOptionSymbols, $FrozenGlycerolOptionSymbols, $LiquidMediaOptionSymbols], $FreezeDriedOptionSymbols],
		FrozenGlycerol, Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $AgarStabOptionSymbols, $FreezeDriedOptionSymbols, $LiquidMediaOptionSymbols], $FrozenGlycerolOptionSymbols]
	];
	(* Get the mismatched options *)
	badOptions = Map[
		Function[{symbol},
			Module[{optionValue, optionDefault},

				(* Lookup the option *)
				optionValue = Lookup[myOptions, symbol];

				(* Lookup the options default *)
				optionDefault = First[Lookup[Cases[optionDefs, KeyValuePattern["OptionSymbol" -> symbol]], "Default"]];

				(* See if the option matches ListableP[ListableP[default]] *)
				If[MatchQ[optionValue, ListableP[ListableP[ReleaseHold[optionDefault] | Null]]],
					Nothing,
					symbol
				]
			]
		],
		(* Go through the type-specific symbols that are not in the given type *)
		sourceHiddenOptions
	];

	(* Return mismatched options *)
	badOptions
];

(*-- Helper:findPreferredMediaOfCellSample --*)
(* Output {Warning bool, preferred liquid media}. This helper is used by both InoculateLiquidMedia and SpreadCells *)
findPreferredMediaOfCellSample[
	inputSample: ListableP[ObjectP[Object[Sample]]],
	missingPreferredLiquidMediaWarning: BooleanP,
	combinedAssoc_Association
] := Module[{modelCell, preferredLiquidMedia},
	(* Get the first model cell in the composition *)
	modelCell = Download[FirstCase[fastAssocLookup[combinedAssoc, inputSample, Composition][[All, 2]], ObjectP[Model[Cell]], Null], Object];
	preferredLiquidMedia = Download[fastAssocLookup[combinedAssoc, modelCell, PreferredLiquidMedia], Object];
	(* Get the PreferredLiquidMedia and flip missingPreferredLiquidMediaWarning to True if resolved to default value *)
	Which[
		NullQ[modelCell],
			{True, Model[Sample, Media, "id:XnlV5jlXbNx8"]}, (* Model[Sample, Media, "LB Broth, Miller"] *)
		(* If preferredLiquidMedia is found, keep the original flag missingPreferredLiquidMediaWarning *)
		MatchQ[preferredLiquidMedia, ObjectP[]],
			{missingPreferredLiquidMediaWarning, preferredLiquidMedia},
		True,
			{True, Model[Sample, Media, "id:XnlV5jlXbNx8"]} (* Model[Sample, Media, "LB Broth, Miller"] *)
		]
];

(*-- Helper:resolveInoculationTipWithGivenInstrument --*)
(* Note: this helper cannot resolve tip for robotic instrument *)
(* Output {tips,tipConnectionMismatchError,noTipsFoundError}*)

(* Overload for a list of destMediaContainers *)
resolveInoculationTipWithGivenInstrument[
	sample: ObjectP[Object[Sample]],
	unresolvedTip: Automatic | Null| ObjectP[{Object[Item, Tips], Model[Item, Tips]}],
	resolvedInstrument: ObjectP[{Object[Instrument], Model[Instrument]}] | Null,
	inputTipMaterial: MaterialP | Null | Automatic,
	inputTipType: TipTypeP | Null | Automatic,
	volume: VolumeP | Null,
	destMediaContainers: {ObjectP[{Object[Container], Model[Container]}]..},
	unresolvedDestMixTypes: {(Pipette|Swirl|Shake|Null|Automatic)..},
	sourceType: FreezeDried,
	combinedAssoc_Association
] := Module[{resolvedTips, tipConnectionMismatchErrors, noTipsFoundErrors},
	(* Check for each destMediaContainer, if we can find a tip *)
	{resolvedTips, tipConnectionMismatchErrors, noTipsFoundErrors} = Transpose@MapThread[
		resolveInoculationTipWithGivenInstrument[
			sample,
			unresolvedTip,
			resolvedInstrument,
			Automatic,
			Automatic,
			volume,
			#1,
			#2,
			FreezeDried,
			combinedAssoc
		]&,
		{destMediaContainers, unresolvedDestMixTypes}
	];
	(* Return the merged option and errors *)
	{
		If[TrueQ[Or@@noTipsFoundErrors], Null, First[resolvedTips]],
		Or@@tipConnectionMismatchErrors,
		Or@@noTipsFoundErrors
	}
];
(* Overload for single destMediaContainer *)
resolveInoculationTipWithGivenInstrument[
	sample: ObjectP[Object[Sample]],
	unresolvedTip: Automatic | Null| ObjectP[{Object[Item, Tips], Model[Item, Tips]}],
	resolvedInstrument: ObjectP[{Object[Instrument], Model[Instrument]}] | Null,
	inputTipMaterial: MaterialP | Null | Automatic,
	inputTipType: TipTypeP | Null | Automatic,
	volume: VolumeP | Null,
	destMediaContainer: ObjectP[{Object[Container], Model[Container]}],
	unresolvedDestMixType: Pipette|Swirl|Shake|Null|Automatic,
	sourceType: LiquidMedia| AgarStab | FreezeDried | FrozenGlycerol,
	combinedAssoc_Association
] := Module[{tipConnectionMismatchError, noTipsFoundError},
	
	(* Initiate the error tracking variables of the module*)
	{tipConnectionMismatchError, noTipsFoundError} = {False, False};
	
	(* If Instrument is not Automatic keep it and resolve Tips *)
	Which[
		(* If Tips is specified *)
		MatchQ[unresolvedTip, ObjectP[{Object[Item, Tips], Model[Item, Tips]}]],
				(* See if the connection types match *)
				Module[
					{
						tipConnectionType, pipetteConnectionType
					},
					(* Get the inputTips connection type *)
					tipConnectionType = If[MatchQ[unresolvedTip, ObjectP[Model[Item, Tips]]],
						fastAssocLookup[combinedAssoc, unresolvedTip, TipConnectionType],
						fastAssocLookup[combinedAssoc, unresolvedTip, {Model, TipConnectionType}]
					];

					(* Get the pipette connection type  *)
					pipetteConnectionType = Which[
						MatchQ[resolvedInstrument, ObjectP[Model[Instrument, Pipette]]],
							fastAssocLookup[combinedAssoc, resolvedInstrument, TipConnectionType],
						MatchQ[resolvedInstrument, ObjectP[Object[Instrument, Pipette]]],
							fastAssocLookup[combinedAssoc, resolvedInstrument, {Model, TipConnectionType}],
						True,
							(* For other instrument such as LH or QPix, return Null *)
							Null
					];

					(* Mark an error if the connection types do not match *)
					If[!MatchQ[tipConnectionType, pipetteConnectionType],
						tipConnectionMismatchError = True;
						{unresolvedTip, tipConnectionMismatchError, noTipsFoundError},
						{unresolvedTip, tipConnectionMismatchError, noTipsFoundError}
					]
				],
		NullQ[unresolvedTip],
			(* If InoculationTips is specified as Null, no errors here are thrown. We will throw InoculationSourceOptionMismatch later *)
			{unresolvedTip, tipConnectionMismatchError, noTipsFoundError},
		(* Otherwise, try to find Tips that 1)can reach the source sample 2)can reach the destination container if it is not FreezeDried *)
		True,
			Module[
				{
					pipetteConnectionType, partiallyResolvedTipMaterial, partiallyResolvedTipType, possibleTips,
					sampleContainerModelPacket, destinationMediaContainerPacket, tipPackets,
					inputTipsCanTouchSampleQ, inputTipsCanTouchDestinationBottomQ, validTips
				},

				(* Get the connection type from the pipette *)
				pipetteConnectionType = Which[
					(* If the pipette is a model, directly look up the connection type *)
					MatchQ[resolvedInstrument, ObjectP[Model[Instrument, Pipette]]],
						fastAssocLookup[combinedAssoc, resolvedInstrument, TipConnectionType],
					(* If the pipette is an object, look up the connection type through the model *)
					MatchQ[resolvedInstrument, ObjectP[Object[Instrument, Pipette]]],
						fastAssocLookup[combinedAssoc, resolvedInstrument, {Model, TipConnectionType}],
					(* Otherwise, return Null *)
					True,
						Null
				];

				(* Partially resolve the tip options so we can pass them to TransferDevices *)
				partiallyResolvedTipMaterial = If[MatchQ[inputTipMaterial, Automatic],
					(* If tipMaterial is Automatic, set it to All *)
					All,
					(* otherwise leave it as is *)
					inputTipMaterial
				];

				partiallyResolvedTipType = If[MatchQ[inputTipType, Automatic],
					(* If tipType is Automatic, set it to All *)
					All,
					(* otherwise leave it as is *)
					inputTipType
				];

				(* Get possible inputTips that work with the resolvedInstrument *)
				possibleTips = If[!NullQ[pipetteConnectionType],
					TransferDevices[
						Model[Item, Tips],
						All,
						TipMaterial -> partiallyResolvedTipMaterial,
						TipType -> partiallyResolvedTipType,
						TipConnectionType -> pipetteConnectionType,
						Sterile -> True
					][[All, 1]],
					TransferDevices[
						Model[Item, Tips],
						All,
						TipMaterial -> partiallyResolvedTipMaterial,
						TipType -> partiallyResolvedTipType,
						Sterile -> True
					][[All, 1]]
				];

				(* If there are no possible inputTips, mark an error and return *)
				If[Length[possibleTips] == 0,
					noTipsFoundError = True;
					{Null, tipConnectionMismatchError, noTipsFoundError},

					(* Otherwise, find which inputTips can "aspirate" and "dispense" at the needed locations *)
					(* Get the information we need for inputTipsCanAspirateQ *)
					(* Get the sample container packet *)
					sampleContainerModelPacket = fastAssocPacketLookup[combinedAssoc, sample, {Container, Model}];

					(* Get the destination packet *)
					destinationMediaContainerPacket = If[MatchQ[destMediaContainer, ObjectP[Model[Container]]],
						fetchPacketFromFastAssoc[destMediaContainer, combinedAssoc],
						fastAssocPacketLookup[combinedAssoc, destMediaContainer, Model]
					];

					(* Get all the possible tip packets *)
					tipPackets = fetchPacketFromFastAssoc[#, combinedAssoc]& /@ possibleTips;

					(* See if the inputTips can "aspirate" from the source and "dispense" into the destination *)
					inputTipsCanTouchSampleQ = (Experiment`Private`tipsCanAspirateQ[
						(* Tip Object *)
						Lookup[#, Object],
						(* Container of interest Packet *)
						sampleContainerModelPacket,
						(* We just need to touch the top of the sample *)
						volume,
						(* We are "aspirating" 0 volume - just need to touch the top *)
						0 Milliliter,
						(* Tip Packet *)
						{#},
						(* Volume calibration packet *)
						{}
					])& /@ tipPackets;

					inputTipsCanTouchDestinationBottomQ = (Experiment`Private`tipsCanAspirateQ[
						(* Tip Object *)
						Lookup[#, Object],
						(* Container of interest Packet *)
						destinationMediaContainerPacket,
						(* We always want to be able to touch the bottom of the container *)
						0 Milliliter,
						(* We are "aspirating" 0 volume - just need to touch the top *)
						0 Milliliter,
						(* Tip packet *)
						{#},
						(* Volume calibration packet *)
						{}
					])& /@ tipPackets;

					(* Filter the possibleTips based on source type *)
					validTips = Which[
						MatchQ[sourceType, AgarStab | FrozenGlycerol] || MatchQ[unresolvedDestMixType, Pipette],
						(* If the source is agar stab /frozen glycerol, or DestinationMixType is specified as Pipette, it needs to touch sample and touch destination bottom *)
							PickList[possibleTips, Transpose[{inputTipsCanTouchSampleQ, inputTipsCanTouchDestinationBottomQ}], {True, True}],
						(* If the source is FreezeDried, no need to touch destination bottom but need to touch source bottom to use up all resuspension unless destinationmixtype is Pipette *)
						MatchQ[sourceType, FreezeDried],
							PickList[possibleTips, inputTipsCanTouchSampleQ],
						(* catch all, just out put all possible ones *)
						True,
							possibleTips
					];

					(* If there are valid inputTips, return the first one *)
					If[Length[validTips] > 0,
						{First[validTips], tipConnectionMismatchError, noTipsFoundError},
						(* Otherwise, mark an error and return Null *)
						noTipsFoundError = True;
						{Null, tipConnectionMismatchError, noTipsFoundError}
					]
				]
			]
	]
];


(*-- Helper:resolveInoculateResuspensionMixOptions --*)
(* Note:this helper function is used by both SpreadCells and InoculateLiquidMedia. This helper is used by both InoculateLiquidMedia and SpreadCells*)
resolveInoculateResuspensionMixOptions[
	sample: ObjectP[{Object[Container], Object[Sample]}],
	unresolvedResuspensionOptions: {_Rule..} | (_Association),
	volumeToMix: VolumeP,
	resolvedTip: ObjectP[{Object[Item, Tips], Model[Item, Tips]}] | Null,
	combinedAssoc_Association
] := Module[{resuspensionMix, resuspensionMixType, resuspensionMixVolume, numberOfResuspensionMixes, resolvedResuspensionMix, resolvedResuspensionMixType, resolvedResuspensionMixVolume, resolvedNumberOfResuspensionMixes, noResuspensionMixWarning, resuspensionMixOptionsMismatchError},

	(* Lookup needed options *)
	{resuspensionMix, resuspensionMixType, resuspensionMixVolume, numberOfResuspensionMixes} = Lookup[
		unresolvedResuspensionOptions,
		{ResuspensionMix, ResuspensionMixType, ResuspensionMixVolume, NumberOfResuspensionMixes}
	];

	(* Initiate error tracking variables *)
	{noResuspensionMixWarning, resuspensionMixOptionsMismatchError} = {False, False};

	(* Resolve ResuspensionMix *)
	resolvedResuspensionMix = Which[
		MatchQ[resuspensionMix, Automatic] && MemberQ[{resuspensionMixType, resuspensionMixVolume, numberOfResuspensionMixes}, Null],
			(*If it is automatic and any of the mix options is specified to Null, resolve to False. *)
			False,
		MatchQ[resuspensionMix, Automatic],
			(*If it is automatic and none of the mix options is specified to Null, resolve to True. *)
			True,
		True,
			(*If it is not automatic, keep it*)
			resuspensionMix
	];

	(*Flip the warning switch if resuspension mix switch is resolved to false *)
	If[!MatchQ[resolvedResuspensionMix, True], noResuspensionMixWarning = True;];

	(* Resolve ResuspensionMixType *)
	resolvedResuspensionMixType = Which[
		MatchQ[resuspensionMixType, Automatic] && !MatchQ[resolvedResuspensionMix, True],
			(*If it is automatic, and we are not mixing, set to Null*)
			Null,
		MatchQ[resuspensionMixType, Automatic],
			(*If it is Automatic and we are mixing, set to default *)
			Pipette,
		True,
			(*If it is not automatic, keep it*)
			resuspensionMixType
	];

	(* Resolve ResuspensionMixVolume *)
	resolvedResuspensionMixVolume = Which[
		MatchQ[resuspensionMixVolume, Automatic] && !MatchQ[resolvedResuspensionMix, True],
			(*If it is automatic, and we are not mixing, set to Null*)
			Null,
		(*If it is Automatic and we are mixing and resolvedTip is Null, set to 50% resuspension media volume *)
		MatchQ[resuspensionMixVolume, Automatic] && NullQ[resolvedTip],
			SafeRound[0.5 * volumeToMix, 10^-1 * Microliter],
		(*If it is Automatic and tip is not Null, set to the lesser between 50% resuspension media volume or 50% of tips max volume if tip is not Null *)
		MatchQ[resuspensionMixVolume, Automatic],
			Min[
				SafeRound[0.5 * volumeToMix, 10^-1 * Microliter],
				fastAssocLookup[combinedAssoc, resolvedTip, MaxVolume]
			],
		True,
			(*If it is not automatic, keep it*)
			resuspensionMixVolume
	];

	(* Resolve ResuspensionMixVolume *)
	resolvedNumberOfResuspensionMixes = Which[
		MatchQ[numberOfResuspensionMixes, Automatic] && !MatchQ[resolvedResuspensionMix, True],
			(*If it is automatic, and we are not mixing, set to Null*)
			Null,
		(*If it is Automatic and we are mixing, set to default *)
		MatchQ[numberOfResuspensionMixes, Automatic],
			5,
		(*If it is not automatic, keep it*)
		True,
			numberOfResuspensionMixes
	];

	(* Check the mix options for mismatch *)
	resuspensionMixOptionsMismatchError = If[Or[
		(*Flip the error True if Mix switch is true but there is Null in the mix options, or if mix switch is Null or False but there is non-Null mix options*)
		MatchQ[resolvedResuspensionMix, True] && MemberQ[{resolvedResuspensionMixType, resolvedResuspensionMixVolume, resolvedNumberOfResuspensionMixes}, Null],
		!MatchQ[resolvedResuspensionMix, True] && MemberQ[{resolvedResuspensionMixType, resolvedResuspensionMixVolume, resolvedNumberOfResuspensionMixes}, Except[Null]]
	],
		True,
		(*otherwise it stays false*)
		False
	];

	(* return the resolved resuspension media, volume, container, warning *)
	{
		resolvedResuspensionMix,
		resolvedResuspensionMixType,
		resolvedResuspensionMixVolume,
		resolvedNumberOfResuspensionMixes,
		noResuspensionMixWarning,
		resuspensionMixOptionsMismatchError}
];

(*--Helper:mapThreadFriendlyDestinationOptions--*)
mapThreadFriendlyDestinationOptions[
	inputOptions: (_Association | {_Rule..}),
	resolvedContainers: {ObjectP[{Model[Container], Object[Container]}]..}
] := Module[{expandedInputOptions, containerLength},
	(* Correctly make destination options mapThreadFriendly *)
	containerLength = Length[resolvedContainers];
	(*Expand each destination option to match the length of the resolved containers*)
	expandedInputOptions = Map[
		Function[{destinationOptionSymbol},
			Module[{input, corrected},
				input = Lookup[inputOptions, destinationOptionSymbol];
				corrected = Which[
					(*If it is a singleton, make it a list to match the container length*)
					!MatchQ[input, _List],
					ConstantArray[input, containerLength],
					(*If it is a list of not correct length, take the first and expand*)
					!EqualQ[Length[input], containerLength],
					ConstantArray[First[input], containerLength],
					(*Otherwise it is already a list of correct length, leave it as it is*)
					True,
					input
				];
				(*Return the rules list*)
				(destinationOptionSymbol -> #) & /@ corrected
			]
		],
		{DestinationMedia, MediaVolume, DestinationMix, DestinationMixType, DestinationNumberOfMixes, DestinationMixVolume}
	];
	(*Return the transposed list of rules*)
	Transpose[expandedInputOptions]
];

(*-- Helper:resolveInoculationDestinationOptions--*)

(* Overload for multiple resolved containers (only for FreezeDried InoculationSource) *)
resolveInoculationDestinationOptions[
	sample: ObjectP[Object[Sample]],
	unresolvedDestionationOptions: {_Rule..},
	resolvedContainers: {ObjectP[{Model[Container], Object[Container]}]..},
	resolvedTip: ObjectP[{Object[Item, Tips], Model[Item, Tips]}] | Null,
	sampleVolume: VolumeP|Null,
	specifiedDestinationMedium: {(ObjectP[{Object[Sample], Model[Sample]}]|Null|Automatic)..},
	combinedAssoc_Association
] := Module[{resolvedOptions, preferredMediaWarnings, nonLiquidMediaErrors, overfillErrors, mixMismatchErrors},

	(* Resolve DestinationOptions for each resolvedContainer *)
	{resolvedOptions, preferredMediaWarnings, nonLiquidMediaErrors, overfillErrors, mixMismatchErrors} = Transpose@MapThread[
		resolveInoculationDestinationOptions[sample, #1, #2, resolvedTip, sampleVolume, #3, combinedAssoc]&,
		{mapThreadFriendlyDestinationOptions[unresolvedDestionationOptions, resolvedContainers], resolvedContainers, specifiedDestinationMedium}
	];
	(* Return the merged options and summarized errors *)
	{
		Merge[Flatten[resolvedOptions], Identity],
		MemberQ[preferredMediaWarnings, True],
		MemberQ[nonLiquidMediaErrors, True],
		DeleteCases[overfillErrors, {}],
		If[MatchQ[DeleteCases[mixMismatchErrors, {}], {}], {}, {sample, DeleteDuplicates[Flatten@Join[DeleteCases[mixMismatchErrors, {}][[All, 2]]]]}]
	}
];

(* Main overload that deals with one resolved container *)
resolveInoculationDestinationOptions[
	sample: ObjectP[Object[Sample]],
	unresolvedDestionationOptions: {_Rule..},
	resolvedContainer: ObjectP[{Model[Container], Object[Container]}],
	resolvedTip: ObjectP[{Object[Item, Tips], Model[Item, Tips]}] | Null | Automatic, (* Tips are Automatic only when Preparation is Robotic *)
	sampleVolume: VolumeP|Null,
	specifiedDestinationMedia: ObjectP[{Object[Sample], Model[Sample]}]|Null|Automatic,
	combinedAssoc_Association
] := Module[
	{
		resolvedMedia, resolvedMediaVolume, resolvedMix, resolvedMixType, resolvedNumberOfMixes, resolvedMixVolume,
		noPreferredMediaWarning, nonLiquidMediaError, overfillError, mixMismatchErrorOptions, containerModelPacket,
		tipModelPacket
	},

	(* Initiate the error tracking booleans *)
	noPreferredMediaWarning = False;
	nonLiquidMediaError = False;

	(* Extract DestinationMediaContainer and Tip from cache *)
	containerModelPacket = If[MatchQ[resolvedContainer, ObjectP[Object]],
		fastAssocPacketLookup[combinedAssoc, resolvedContainer, Model],
		fetchPacketFromFastAssoc[resolvedContainer, combinedAssoc]
	];

	tipModelPacket = Which[
		MatchQ[resolvedTip, ObjectP[Object]], fastAssocPacketLookup[combinedAssoc, resolvedTip, Model],
		MatchQ[resolvedTip, ObjectP[Model]], fetchPacketFromFastAssoc[resolvedTip, combinedAssoc],
		True, <||>
	];

	(* Resolve DestinationMedia *)
	{{noPreferredMediaWarning, resolvedMedia}, nonLiquidMediaError} = If[MatchQ[Lookup[unresolvedDestionationOptions, DestinationMedia], Automatic],
		(* If DestinationMedia is Automatic, set to the PreferredLiquidMedia of the first model cell in the input sample if it exists, otherwise default to Model[Sample, Media, "LB Broth, Miller"] *)
		(* Since every media found by PreferredLiquidMedia field of Model[Cell] is liquid media, nonLiquidMediaError is False here*)
		{findPreferredMediaOfCellSample[sample, noPreferredMediaWarning, combinedAssoc], False},
		(* Otherwise leave the media as is and check if the media is liquid media *)
		{
			{False, Lookup[unresolvedDestionationOptions, DestinationMedia]},
			If[MatchQ[specifiedDestinationMedia, ObjectP[]],
				(* If the DestinationMedia is not user-specified, no need to check state again since it must pre-resolved from ResuspensionMedia *)
				(* If the DestinationMedia is Null, no need to check state *)
				MatchQ[fastAssocLookup[combinedAssoc, Lookup[unresolvedDestionationOptions, DestinationMedia], State], Except[Liquid]],
				False
			]
		}
	];

	(* Resolve MediaVolume and check if MediaVolume overfill the destination container *)
	{resolvedMediaVolume, overfillError} = If[MatchQ[Lookup[unresolvedDestionationOptions, MediaVolume], Automatic],
		Which[
			MatchQ[resolvedMedia, Null],
				(*If the destination media is specified as Null, the volume is Null. *)
				(* This is allowed only for freeze dried cell, in case we just want to culture using the resuspension media volume, but want to transfer the resuspended cells out from the hermetic container or ampoule to the destination media container.*)
				{Null, {}},
			NullQ[sampleVolume],
				(* If MediaVolume is Automatic and DestinationMedia is not Null, set based on the type of container *)
				Module[{maxVol},
					maxVol = Lookup[containerModelPacket, MaxVolume];
					(* Take 40% of the MaxVolume of the DestinationMediaContainer, and if that value is null take 4ml *)
					{SafeRound[FirstCase[{0.4*maxVol, 4 Milliliter}, VolumeP], 10^-1 Microliter], {}}
				],
			True,
				(* When sample vol is not Null, we need to consider sample vol. Usually do 5 times of sample vol *)
				Module[{maxVol, mediaVolume, overfillInfo},
					maxVol = Lookup[containerModelPacket, MaxVolume];
					(* Take 5 times sample volume or 40% of the MaxVolume of the DestinationMediaContainer whichever is smaller *)
					mediaVolume = Min[5*sampleVolume, SafeRound[FirstCase[{0.4*maxVol, 4 Milliliter}, VolumeP], 10^-1 Microliter]];
					overfillInfo = If[GreaterQ[(sampleVolume+mediaVolume), maxVol],
						{sample, resolvedContainer, (sampleVolume+mediaVolume)},
						{}
					];
					{mediaVolume, overfillInfo}
				]
		],
		(* Otherwise leave the option as is and just check overfill error *)
		Module[{maxVol, overfillInfo},
			maxVol = Lookup[containerModelPacket, MaxVolume];
			overfillInfo = If[GreaterQ[(sampleVolume+Lookup[unresolvedDestionationOptions, MediaVolume])/.Null->0Microliter, maxVol],
				{sample, resolvedContainer, (sampleVolume+Lookup[unresolvedDestionationOptions, MediaVolume])/.Null->0Microliter},
				{}
			];
			{Lookup[unresolvedDestionationOptions, MediaVolume], overfillInfo}
		]
	];

	(* Resolve DestinationMix *)
	resolvedMix = If[MatchQ[Lookup[unresolvedDestionationOptions, DestinationMix], Automatic],
		(* If DestinationMix is Automatic, resolve it to True if we have destination media*)
		If[NullQ[resolvedMedia], False, True],
		(* Otherwise leave it as is *)
		Lookup[unresolvedDestionationOptions, DestinationMix]
	];

	(* Resolve DestinationMixType *)
	resolvedMixType = If[MatchQ[Lookup[unresolvedDestionationOptions, DestinationMixType], Automatic],
		(* If DestinationMixType is automatic, set to Pipette if DestinationMix is turned on and tipsCanAspirateQ is True *)
		If[MatchQ[resolvedMix, True],
			Which[
				MatchQ[resolvedTip, Automatic],
					Pipette,
				MatchQ[resolvedTip, ObjectP[]],
					Module[{allVolumeCalibrationPackets, resolvedTipCanAspirateQ},
						allVolumeCalibrationPackets = fastAssocPacketLookup[combinedAssoc, Lookup[containerModelPacket, Object], VolumeCalibrations];
						resolvedTipCanAspirateQ = tipsCanAspirateQ[
							Lookup[tipModelPacket, Object],
							containerModelPacket,
							(resolvedMediaVolume + sampleVolume)/.Null->0Microliter,
							0.5*(resolvedMediaVolume + sampleVolume)/.Null->0Microliter,
							{tipModelPacket},
							allVolumeCalibrationPackets
						];
						If[TrueQ[resolvedTipCanAspirateQ],
							Pipette,
							Swirl
						]
					],
				True,
					Pipette
			],
			Null
		],
		(* If it is set, use it*)
		Lookup[unresolvedDestionationOptions, DestinationMixType]
	];

	(* Resolve DestinationNumberOfMixes *)
	resolvedNumberOfMixes = If[MatchQ[Lookup[unresolvedDestionationOptions, DestinationNumberOfMixes], Automatic],
		(* If destinationNumberOfMixes is Automatic, resolve to 5 if resolvedDestinationMix is True, otherwise Null *)
		If[MatchQ[resolvedMix, True],
			5,
			Null
		],
		(* If it is set, use it *)
		Lookup[unresolvedDestionationOptions, DestinationNumberOfMixes]
	];

	(* Resolve DestinationMixVolume *)
	resolvedMixVolume = Which[
		MatchQ[Lookup[unresolvedDestionationOptions, DestinationMixVolume], Except[Automatic]],
		(* If it is set, check for a mismatch with resolvedDestinationMix *)
		Lookup[unresolvedDestionationOptions, DestinationMixVolume],
		(* If destinationMixVolume is Automatic and MixType of Pipette, resolve mix volume *)
		MatchQ[resolvedMix, True] && MatchQ[resolvedMixType, Pipette],
			Module[{maxPipetteVol},
				maxPipetteVol = Which[
					MatchQ[resolvedTip, ObjectP[]],
						Lookup[tipModelPacket, MaxVolume],
					NullQ[resolvedTip],
						(* Check the volume range of sample volume, if nothing default to the largest Pipiette range *)
						SafeRound[FirstCase[ToList@sampleVolume, VolumeP, 50 Milliliter], 10^-1 Microliter],
					True,
						(* Otherwise we are doing robotic transfer, default to 970 microliter or largest sample volume *)
						SafeRound[FirstCase[ToList@sampleVolume, VolumeP, $MaxRoboticSingleTransferVolume], 10^-1 Microliter]
				];
				Min[
					(* In case MediaVolume is specified as Null but Mix and MixType are set to Pipette mix, resolve to samplevol *)
					SafeRound[FirstCase[{resolvedMediaVolume, sampleVolume}, VolumeP, 0 Microliter]/2, 10^-1 Microliter],
					maxPipetteVol
				]
			],
		True,
			Null
	];

	(* Check if any Mix related options are mismatched *)
	mixMismatchErrorOptions = If[MatchQ[resolvedMix, True],
		{
			If[NullQ[resolvedMixType], DestinationMixType, Nothing],
			If[NullQ[resolvedNumberOfMixes], DestinationNumberOfMixes, Nothing],
			If[MatchQ[resolvedMixType, Pipette] && NullQ[resolvedMixVolume], DestinationMixVolume, Nothing]
		},
		{
			If[!NullQ[resolvedMixType], DestinationMixType, Nothing],
			If[!NullQ[resolvedNumberOfMixes], DestinationNumberOfMixes, Nothing],
			If[!NullQ[resolvedMixVolume], DestinationMixVolume, Nothing]
		}
	];

	(* Return the resolved options and error booleans *)
	{
		{
			DestinationMedia -> resolvedMedia,
			MediaVolume -> resolvedMediaVolume,
			DestinationMix -> resolvedMix,
			DestinationMixType -> resolvedMixType,
			DestinationNumberOfMixes -> resolvedNumberOfMixes,
			DestinationMixVolume -> resolvedMixVolume
		},
		noPreferredMediaWarning,
		nonLiquidMediaError,
		overfillError,
		If[MatchQ[mixMismatchErrorOptions, {}], {}, {sample, mixMismatchErrorOptions}]
	}
];

(*-- Helper:resolveInoculationDestinationWell--*)
(* Return the resolved destination wells and the invalidDestinationWellError boolean. This helper is used by both InoculateLiquidMedia and SpreadCells *)
(*Overload for extra nestiness in resolved containers*)
resolveInoculationDestinationWells[
	destinationWellInput: ListableP[Automatic, 2] | {___, {_String..}, ___},
	nestedResolvedContainers: {___, {ObjectP[{Model[Container], Object[Container]}]..}, ___},
	resolvedContainerLabels: {___, {(_String)..}, ___},
	combinedAssoc_Association
] := Module[{resolvedWells, errors},
	{resolvedWells, errors} = Transpose[If[EqualQ[Length[destinationWellInput], Length[nestedResolvedContainers]],
		(* if the wells and the containers have the same length, mapthread it *)
		MapThread[resolveInoculationDestinationWells[#1, #2, #3, combinedAssoc]&,
			{destinationWellInput, nestedResolvedContainers, resolvedContainerLabels}],
		(* Otherwise the well is likely a single that is repeated for every call *)
		MapThread[resolveInoculationDestinationWells[destinationWellInput, #1, #2, combinedAssoc]&,
			{nestedResolvedContainers, resolvedContainerLabels}]
	]];
	(* return the wells and one error bool *)
	{resolvedWells, Map[(Or@@#)&, errors]}
];

(*Main overload*)
resolveInoculationDestinationWells[
	destinationWellInput: ListableP[Automatic | _String],
	resolvedContainers: ListableP[ObjectP[{Model[Container], Object[Container]}]],
	resolvedContainerLabels: ListableP[_String],
	combinedAssoc_Association
] := Module[{expandedWells, resolvedWells, invalidWellErrors, containerLookup},

	(*Initiate the look up*)
	containerLookup = <||>;
	(*Make the well the same length as the resolved container*)
	expandedWells = If[!MatchQ[destinationWellInput, _List],
		(*If the destination well input is a singleton, it should be expanded to the same length as the container*)
		ConstantArray[destinationWellInput, Length[ToList[resolvedContainers]]],
		(*If it is already a list, keep it. *)
		destinationWellInput
	];

	(*resolve the destination well based on input and resolved container*)
	{resolvedWells, invalidWellErrors} = Transpose@MapThread[
		Function[{well, container, containerLabel},
			Module[{availableContainerInfo, invalidWellError},
				availableContainerInfo = Lookup[
					containerLookup,
					Key[{container, containerLabel}],
					Null
				];
				(*Initiation the error tracking bool for this round
        *)
				invalidWellError = False;

				(* Was there an available container? (Matching object/model with available positions and label) *)
				If[!NullQ[availableContainerInfo],
					(* Yes there was an available container *)
					Module[{allowedPositions, availablePositions, newPositionToOccupy},

						(* Get the info about the object *)
						{allowedPositions, availablePositions} = Lookup[availableContainerInfo, {AllowedPositions, AvailablePositions}];

						(* Throw an error if the user specified destination well is not a position of the container *)
						If[MatchQ[well, _String] && !MemberQ[allowedPositions, well],
							invalidWellError = True;
						];

						newPositionToOccupy = If[MatchQ[well, Automatic],
							(* If Automatic, resolve to the first available position, if no availability, default to A1 *)
							FirstCase[availablePositions, _String, "A1"],
							(*otherwise the well is specified, keep it*)
							well
						];

						(* update the lookup with new container information *)
						containerLookup = AssociateTo[
							containerLookup,
							{container, containerLabel} -> {
								AllowedPositions -> allowedPositions,
								AvailablePositions -> DeleteCases[availablePositions, newPositionToOccupy]
							}
						];

						(* return the resolved well *)
						{newPositionToOccupy, invalidWellError}
					],

					(* No this is not in the lookup *)
					Module[{allowedPositions, occupiedPositions, availablePositions, newPositionToOccupy},

						(* Get the allowed, occupied, and open positions in the collection container *)
						{allowedPositions, occupiedPositions} = If[MatchQ[container, ObjectP[Object[Container]]],
							(* If the container is an object. Lookup from the cache *)
							{
								Lookup[fastAssocLookup[combinedAssoc, container, {Model, Positions}], Name],
								fastAssocLookup[combinedAssoc, container, Contents][[All, 1]]
							},
							(* Otherwise if the container is a model start with all the allowed positions *)
							{
								Lookup[fastAssocLookup[combinedAssoc, container, Positions], Name],
								{}
							}
						];
						(* Available positions are those that are allowed but not occupied *)
						availablePositions = UnsortedComplement[allowedPositions, occupiedPositions];

						(* Throw an error if the user specified destination well is not a position of the container *)
						If[MatchQ[well, _String] && !MemberQ[allowedPositions, well],
							invalidWellError = True;
						];

						newPositionToOccupy = If[MatchQ[well, Automatic],
							(* If Automatic, resolve to the first available position, if no availability, default to A1 *)
							FirstCase[availablePositions, _String, "A1"],
							(*otherwise the well is specified, keep it*)
							well
							(*If it is a vessel, i.e. only 1 position is available, use that position. We are pooling samples.*)
						];

						(* update the lookup with new container information *)
						containerLookup = AssociateTo[
							containerLookup,
							{container, containerLabel} -> {
								AllowedPositions -> allowedPositions,
								AvailablePositions -> DeleteCases[availablePositions, newPositionToOccupy]
							}
						];

						(* return the resolved well *)
						{newPositionToOccupy, invalidWellError}
					]
				]
			]
		],
		{ToList[expandedWells], ToList[resolvedContainers], ToList[resolvedContainerLabels]}
	];
	(*Return resolvedWell and error tracking bool*)
	{resolvedWells, invalidWellErrors}
];

(*-- Helper:resolveInoculationLabel. Overload for a list of samples with nested list of specified label options, up to 2-level list --*)
(* This helper is also used by SpreadCells when resolve FreezeDried labels *)
resolveInoculationLabel[
	inputSamples: {ObjectP[Object[Sample]]..},
	labelOptionSymbol: SampleOutLabel|ContainerOutLabel,
	labelOptionInputs: {ListableP[(_String | Null | Automatic)]..},
	nestedContainers: {{ObjectP[{Model[Container], Object[Container]}]..}..},
	specifiedLabels: {_String...},
	currentSimulation: SimulationP|Null,
	combinedAssoc_Association
] := Module[{},
	(* Reduce 2-level list to 1-level list *)
	 MapThread[
		 Function[{inputSample, labelOptionInput, listContainers},
			 resolveInoculationLabel[
				ConstantArray[inputSample, Length[Flatten@labelOptionInput]],
				labelOptionSymbol,
				Flatten@labelOptionInput,
				Flatten@listContainers,
				specifiedLabels,
				currentSimulation,
				combinedAssoc
		]],
		{inputSamples, labelOptionInputs, nestedContainers}
	]
];

(* This helper is used by both InoculateLiquidMedia and SpreadCells *)
resolveInoculationLabel[
	inputSamples: {ObjectP[Object[Sample]]..},
	labelOptionSymbol: SampleOutLabel|ContainerOutLabel,
	labelOptionInputs: {(_String | Null | Automatic)..},
	nestedContainers: {(ObjectP[{Model[Container], Object[Container]}]|Null)..}|Null,
	specifiedLabels: {_String...},
	currentSimulation: SimulationP|Null,
	combinedAssoc_Association
] := MapThread[
	resolveInoculationLabel[#1, labelOptionSymbol, #2, #3, specifiedLabels, currentSimulation, combinedAssoc]&,
	{inputSamples, labelOptionInputs, If[NullQ[nestedContainers], ConstantArray[Null, Length[inputSamples]], nestedContainers]}
];

(*-- Helper:resolveInoculationLabel for SampleLabel--*)
resolveInoculationLabel[
	inputSamples: {ObjectP[Object[Sample]]..},
	labelOptionSymbol: SampleLabel,
	labelOptionInputs: {(_String | Null | Automatic)..},
	nestedContainers: {ListableP[ListableP[(ObjectP[{Model[Container], Object[Container]}]|Null)]]..}|Null,
	specifiedLabels: {_String...},
	currentSimulation: SimulationP|Null,
	combinedAssoc_Association
] := Module[{uniqueSamples, uniqueUserLabels, labelPrefix, sampleLabelLookup},

	(* get the unique samples in *)
	uniqueSamples = DeleteDuplicates[inputSamples];

	(* get the unique strings in user input *)
	uniqueUserLabels = DeleteDuplicates[DeleteCases[labelOptionInputs, Automatic | Null]];

	(*If the specified sample labels is one string, use it as a label prefix, otherwise use "ExperimentInoculateLiquidMedia Sample" as prefix*)
	labelPrefix = If[MatchQ[Length@uniqueUserLabels, 1],
		FirstCase[uniqueUserLabels, _String, "ExperimentInoculateLiquidMedia Sample"],
		"ExperimentInoculateLiquidMedia Sample"
	];

	(* create a lookup of unique sample to label *)
	sampleLabelLookup = (# -> CreateUniqueLabel[labelPrefix, UserSpecifiedLabels -> specifiedLabels])& /@ uniqueSamples;

	(* Expand the sample-specific unique labels *)
	MapThread[
		Function[{object, label},
			Which[
				(* respect user specification *)
				MatchQ[label, Except[Automatic]], label,
				(* respect upstream LabelSample/LabelContainer input *)
				MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, object], _String], LookupObjectLabel[currentSimulation, object],
				(* get a label from the lookup *)
				True, Lookup[sampleLabelLookup, object]
			]
		],
		{inputSamples, labelOptionInputs}
	]
];

(*-- Helper:resolveInoculationLabel for SampleContainerLabel--*)
resolveInoculationLabel[
	inputSamples: {ObjectP[Object[Sample]]..},
	labelOptionSymbol: SampleContainerLabel,
	labelOptionInputs: {(_String | Null | Automatic)..},
	nestedContainers: {ListableP[ListableP[(ObjectP[{Model[Container], Object[Container]}]|Null)]]..}|Null,
	specifiedLabels: {_String...},
	currentSimulation: SimulationP|Null,
	combinedAssoc_Association
] := Module[{uniqueSamples, uniqueUserLabels, sampleContainerLookup, uniqueSampleContainers, labelPrefix, containerLabelLookup},

	(* get the unique samples in containers *)
	uniqueSamples = DeleteDuplicates[inputSamples];
	(* get the unique strings in user input *)
	uniqueUserLabels = DeleteDuplicates[DeleteCases[labelOptionInputs, Automatic | Null]];

	(* create a lookup of sample to container *)
	sampleContainerLookup = (# -> Download[fastAssocLookup[combinedAssoc, #, Container], Object])& /@ uniqueSamples;
	(* get the unique sample containers*)
	uniqueSampleContainers = DeleteDuplicates[Values[sampleContainerLookup]];
	(*If the specified sample labels is one string, use it as a label prefix, otherwise use "ExperimentInoculateLiquidMedia Sample" as prefix*)
	labelPrefix = If[MatchQ[Length@uniqueUserLabels, 1],
		FirstCase[uniqueUserLabels, _String, "ExperimentInoculateLiquidMedia Sample Container"],
		"ExperimentInoculateLiquidMedia Sample Container"];
	(* create a lookup of container to label *)
	containerLabelLookup = (# -> CreateUniqueLabel[labelPrefix, UserSpecifiedLabels -> specifiedLabels])& /@ Values[sampleContainerLookup];

	(* Expand the sample-specific unique labels *)
	MapThread[
		Function[{object, label},
			Which[
				(* respect user specification *)
				MatchQ[label, Except[Automatic]], label,
				(* respect upstream LabelSample/LabelContainer input *)
				MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, object/.sampleContainerLookup], _String], LookupObjectLabel[currentSimulation, object/.sampleContainerLookup],
				(* get a label from the lookup *)
				True, Lookup[containerLabelLookup, Lookup[sampleContainerLookup, object]]
			]
		],
		{inputSamples, labelOptionInputs}
	]
];

(*-- Helper:resolveInoculationLabel for SampleOutLabel--*)
resolveInoculationLabel[
	inputSample: ObjectP[Object[Sample]],
	labelOptionSymbol: SampleOutLabel,
	labelOptionInput: _String | Null | Automatic,
	unnestedContainer: ObjectP[{Model[Container], Object[Container]}]|Null,
	specifiedLabels: {_String...},
	currentSimulation: SimulationP|Null,
	combinedAssoc_Association
] := Module[{},
	Which[
		(* If the given label is not automatic, leave it alone *)
		MatchQ[labelOptionInput, Except[Automatic]],
			labelOptionInput,
		(* respect upstream LabelSample/LabelContainer input *)
		MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, inputSample], _String],
			LookupObjectLabel[currentSimulation, inputSample],
		(* Otherwise create a label *)
		True,
			CreateUniqueLabel["ExperimentInoculateLiquidMedia Sample Out", UserSpecifiedLabels -> specifiedLabels]
	]
];

(*-- Helper:resolveInoculationLabel for ContainerOutLabel--*)
resolveInoculationLabel[
	inputSample: ObjectP[Object[Sample]],
	labelOptionSymbol: ContainerOutLabel,
	labelOptionInput: _String | Null | Automatic,
	unnestedContainer: ObjectP[{Model[Container], Object[Container]}]|Null,
	specifiedLabels: {_String...},
	currentSimulation: SimulationP|Null,
	combinedAssoc_Association
] := Module[{},
	Which[
		(* If the given label is not automatic, leave it alone *)
		MatchQ[labelOptionInput, Except[Automatic]],
			labelOptionInput,
		(* respect upstream LabelSample/LabelContainer input *)
		MatchQ[unnestedContainer, ObjectP[Object[Container]]] && MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, unnestedContainer], _String],
			LookupObjectLabel[currentSimulation, unnestedContainer],
		NullQ[unnestedContainer],
			Null,
		(* Otherwise create a label *)
		True,
			CreateUniqueLabel["ExperimentInoculateLiquidMedia Container Out", UserSpecifiedLabels -> specifiedLabels]
	]
];

(*-- Helper: generateMediaResources --*)
(* This helper is used by both InoculateLiquidMedia and SpreadCells *)
generateMediaResources[
	resolvedOptions: {_Rule..},
	mediaOptionSymbol: DestinationMedia | ResuspensionMedia,
	volumeOptionSymbol: MediaVolume | ResuspensionMediaVolume,
	experimentString_String
] := Module[{mediaVolumeAssociations, mediaToVolumeLookup, mediaResourceLookup},
	mediaVolumeAssociations = MapThread[If[MatchQ[#1, Null], Nothing, <|#1 -> #2|>]&,
		{Flatten[Download[Lookup[resolvedOptions, mediaOptionSymbol], Object]],
			Flatten[Lookup[resolvedOptions, volumeOptionSymbol]]}
	];

	(* Total the media volumes across all input samples *)
	mediaToVolumeLookup = Merge[mediaVolumeAssociations, Total];

	(* Create a resource lookup for each unique media *)
	mediaResourceLookup = KeyValueMap[
		Function[{object, volume},
			object -> If[MatchQ[object, WaterModelP],
				(* need to specify a container if we're doing water prep *)
				Resource[Sample -> object, Container -> First[ToList[PreferredContainer[volume, Sterile -> True]]], Amount -> volume, Name -> experimentString <> " " <> ToString[mediaOptionSymbol] <> CreateUUID[]],
				(* otherwise we want to minimize transfers and thus don't want to specify container; just pick it in whatever it's already in *)
				Resource[Sample -> object, Amount -> volume, Name -> experimentString <> " " <> ToString[mediaOptionSymbol] <> CreateUUID[]]
			]
		],
		mediaToVolumeLookup
	];

	(* Return the ordered list of resources using the media lookup *)
	(* Note:we should expand ResuspensionMedia to the length of DestinationMediaContainer for ExperimentInoculateLiquidMedia *)
	If[MatchQ[mediaOptionSymbol, DestinationMedia] || StringMatchQ[experimentString, "ExperimentSpreadCells"|"ExperimentStreakCells"],
		Lookup[resolvedOptions, mediaOptionSymbol] /. mediaResourceLookup,
		Flatten@MapThread[
			Function[{optionValue, destinationMediaContainerList},
				If[Length[destinationMediaContainerList] == 1,
					(* If only 1 destinationMediaContainer exists, no need to expand *)
					optionValue/. mediaResourceLookup,
					(* Otherwise, we need to expand ResuspensionMedia if multiple destinationMediaContainer exist *)
					ConstantArray[optionValue, Length[destinationMediaContainerList]]/. mediaResourceLookup
				]
			],
			{Lookup[resolvedOptions, mediaOptionSymbol], Lookup[resolvedOptions, DestinationMediaContainer]}
		]
	]
];

(* -- Helper: generateBSCWasteResources -- *)
generateBSCWasteResources[
	resolvedOptions: {_Rule..},
	inoculationSource: Alternatives[LiquidMedia, FreezeDried, SolidMedia],
	fastAssoc_Association
] := ConstantArray[Null, Length[Lookup[resolvedOptions], TransferEnvironment]];

generateBSCWasteResources[
	resolvedOptions: {_Rule..},
	inoculationSource: Alternatives[AgarStab, FrozenGlycerol],
	fastAssoc_Association
] := Module[{finalTuples},

	(* We need to generate a new waste bin/bag resource each time we enter a new bsc *)
	finalTuples = FoldList[
		Function[{stateTuple, nextTransferEnvironment},
			Module[{currentTransferEnvironment, currentWasteBinResource, currentWasteBagResource,
				candidateWasteBinOfNextBSC, wasteBinOfNextBSC},
				(* Split the tuple *)
				{
					currentTransferEnvironment,
					currentWasteBinResource,
					currentWasteBagResource
				} = stateTuple;

				(* Based on the model/Object of the next TransferEnvironment BSC, determine the model/object of the waste bin to generate resource for. Now we have either object or model BSC, otherwise we would have returned due to the code right above. *)
				candidateWasteBinOfNextBSC = Switch[nextTransferEnvironment,
					ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet]],
					(* Look up the default waste bin model of the BSC model *)
					fastAssocLookup[fastAssoc, nextTransferEnvironment, DefaultBiosafetyWasteBinModel],
					ObjectP[Object[Instrument, HandlingStation, BiosafetyCabinet]],
					(*Look up the associated waste bin object of the BSC object*)
					fastAssocLookup[fastAssoc, nextTransferEnvironment, BiosafetyWasteBin],
					_,
					(*Otherwise, no bsc is used*)
					Null
				];
				(* In case we have a BSC next but we don't have a waste bin model/object pulled. Do not throw any error to the user, feed a general waste bin model instead, and it will throw error in procedure *)
				wasteBinOfNextBSC = If[And[
					MatchQ[nextTransferEnvironment,ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet],Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
					!MatchQ[candidateWasteBinOfNextBSC,ObjectP[{Model[Container,WasteBin],Object[Container,WasteBin]}]]
				],
					Model[Container, WasteBin, "id:7X104v1DJmX6"], (*"Biohazard Waste Container, BSC"*)
					(*Otherwise either we got a wastebin from BSC, or we don't have a BSC next, just use what we got for candidateWasteBinOfNextBSC*)
					candidateWasteBinOfNextBSC
				];

				If[MatchQ[nextTransferEnvironment, ObjectP[currentTransferEnvironment]],
					{
						nextTransferEnvironment,
						currentWasteBinResource,
						currentWasteBagResource
					},
					{
						nextTransferEnvironment,
						Resource[
							Sample -> wasteBinOfNextBSC,
							Name -> CreateUUID[]
						],
						Resource[
							Sample -> Model[Item, Consumable, "id:7X104v6oeYNJ"], (* Model[Item, Consumable, "Biohazard Waste Bags, 8x12"] *)
							Name -> CreateUUID[]
						]
					}
				]
			]
		],
		{
			Null,
			Null,
			Null
		},
		Lookup[resolvedOptions, TransferEnvironment]
	];

	(* Return our wastebins and waste bags (stripping off initial nulls) *)
	{
		Rest@finalTuples[[All, 2]],
		Rest@finalTuples[[All, 3]]
	}
];

(*-- Helper: generateTransferEnvironmentDeveloperInfo --*)
generateTransferEnvironmentDeveloperInfo[
	resolvedOptions: {_Rule..},
	environmentResources: {(_Resource | Link[_Resource, ___])..},
	instResources: {(_Resource | Link[_Resource, ___])..},
	tipResources: {(_Resource | Link[_Resource, ___])..},
	samplesInResources: {(_Resource | Link[_Resource, ___])..},
	destContainerResources: {(_Resource | Link[_Resource, ___])..},
	wasteBinResources: {(_Resource | Link[_Resource, ___] | Null)..},
	wasteBagResources: {(_Resource | Link[_Resource, ___] | Null)..},
	combinedAssoc_Association
] := Module[
	{
		resourcesNotToPickUpFront, setUpTransferEnvironmentBools, tearDownTransferEnvironmentBools,
		pipetteReleaseBools, tipReleaseBools, coverSamplesInBools, coverDestinationContainerBools, wasteBinPlacements, wasteBagPlacements,
		wasteBinTeardowns, wasteBagTeardowns
	},

	(* These are the resources that should not be put into RequiredInstruments/Objects to be picked up front. *)
	resourcesNotToPickUpFront = DeleteDuplicates@Flatten@Join[
		(* Never pick our transfer environments up front. *)
		Cases[environmentResources, _Resource, All],

		(* Never pick our waste bins up front. *)
		Cases[wasteBinResources, _Resource, All],
		(* Never pick our waste bags up front. *)
		Cases[wasteBagResources, _Resource, All]
	];

	(* Determine when we need to set up transfer environments *)
	setUpTransferEnvironmentBools = MapIndexed[
		Function[{transferEnvironmentResource, index},
			Which[
				(* If this is the first sample, we have to set up *)
				MatchQ[index, {1}], True,

				(* If the transfer environment is not the same as the previous transfer environment, we have to set up *)
				!MatchQ[transferEnvironmentResource, environmentResources[[index[[1]] - 1]]], True,

				(* Otherwise, we will use the already set up transfer environment *)
				True, False
			]
		],
		environmentResources
	];

	(* Determine when we need to tear down transfer environments  *)
	tearDownTransferEnvironmentBools = MapIndexed[
		Function[{transferEnvironmentResource, index},
			Which[
				(* If this is the last sample, we have to tear down *)
				MatchQ[index[[1]], Length[environmentResources]], True,

				(* If the transfer environment is not the same as the next transfer environment, we have to tear down *)
				!MatchQ[transferEnvironmentResource, environmentResources[[index[[1]] + 1]]], True,

				(* Otherwise, we will keep this transfer environment set up *)
				True, False
			]
		],
		environmentResources
	];

	(* Determine when we need to release the pipettes *)
	pipetteReleaseBools = MapIndexed[
		Function[{pipetteResource, index},
			Which[
				(* If this is the last sample, we have to release *)
				MatchQ[index[[1]], Length[instResources]], True,

				(* If this is the last time we use this pipette, we have to release *)
				!MemberQ[instResources[[(index[[1]] + 1) ;;]], pipetteResource], True,

				(* Otherwise, we will keep this pipette *)
				True, False
			]
		],
		instResources
	];

	(* Determine when we need to release the tips *)
	tipReleaseBools = MapIndexed[
		Function[{tipResource, index},
			Which[
				(* If this is the last sample, we have to release *)
				MatchQ[index[[1]], Length[tipResource]], True,

				(* If this is the last time we use this pipette, we have to release *)
				!MemberQ[tipResources[[(index[[1]] + 1) ;;]], tipResource], True,

				(* Otherwise, we will keep this pipette *)
				True, False
			]
		],
		tipResources
	];

	coverSamplesInBools = MapIndexed[
		Function[{sample, index},
			Which[
				(* If this is the last sample, we have to cover *)
				MatchQ[index[[1]], Length[samplesInResources]], True,

				(* If the sample is never used as an input sample again, cover *)
				!MemberQ[samplesInResources[[(index[[1]] + 1) ;;]], sample], True,

				(* Otherwise, we will keep this transfer environment set up *)
				True, False
			]
		],
		samplesInResources
	];

	coverDestinationContainerBools = MapIndexed[
		Function[{destinationContainer, index},
			Which[
				(* If this is the last sample, we have to cover *)
				MatchQ[index[[1]], Length[destContainerResources]], True,

				(* If the container is never used as a destination container again, cover *)
				!MemberQ[destContainerResources[[(index[[1]] + 1) ;;]], destinationContainer], True,

				(* Otherwise, we will keep this transfer environment set up *)
				True, False
			]
		],
		destContainerResources
	];

	wasteBinPlacements = MapThread[
		Function[{wasteBinResource, environmentResource, setUpTransferEnvironmentBool},
			If[setUpTransferEnvironmentBool,
				{Link[wasteBinResource], Link[environmentResource], "Waste Bin Slot"},
				{Null, Null, Null}
			]
		],
		{
			wasteBinResources,
			environmentResources,
			setUpTransferEnvironmentBools
		}
	];

	wasteBagPlacements = MapThread[
		Function[{wasteBagResource, wasteBinResource, setUpTransferEnvironmentBool},
			If[setUpTransferEnvironmentBool,
				{Link[wasteBagResource], Link[wasteBinResource], "A1"},
				{Null, Null, Null}
			]
		],
		{
			wasteBagResources,
			wasteBinResources,
			setUpTransferEnvironmentBools
		}
	];
	wasteBinTeardowns = MapThread[
		Function[{wasteBinResource, tearDownTransferEnvironmentBool},
			If[tearDownTransferEnvironmentBool,
				Link[wasteBinResource],
				Null
			]
		],
		{
			wasteBinResources,
			tearDownTransferEnvironmentBools
		}
	];

	wasteBagTeardowns = MapThread[
		Function[{wasteBagResource, tearDownTransferEnvironmentBool},
			If[tearDownTransferEnvironmentBool,
				Link[wasteBagResource],
				Null
			]
		],
		{
			wasteBagResources,
			tearDownTransferEnvironmentBools
		}
	];


	(*Return the developer info to populate protocol fields*)
	{
		setUpTransferEnvironmentBools,
		tearDownTransferEnvironmentBools,
		pipetteReleaseBools,
		tipReleaseBools,
		coverSamplesInBools,
		coverDestinationContainerBools,
		resourcesNotToPickUpFront,
		wasteBinPlacements,
		wasteBagPlacements,
		wasteBinTeardowns,
		wasteBagTeardowns
	}
];

(*-- Helper: addRequiredInoculateObjectsInstruments*)
addRequiredInoculateObjectInstruments[
	initialPacket_Association,
	ignoreResources: {(_Resource | Link[_Resource, ___])..}
] := Merge[{
	initialPacket,
	<|
		(* NOTE: These are all resource picked at once so that we can minimize trips to the VLM -- EXCEPT for resources that live in other transfer environments *)
		(* like the BSC. *)
		Replace[RequiredObjects] -> DeleteDuplicates[
			Cases[
				Cases[
					DeleteDuplicates[Cases[Normal[initialPacket, Association], _Resource, Infinity]],
					Resource[KeyValuePattern[Type -> Object[Resource, Sample]]]
				],
				Except[Alternatives @@ ignoreResources]
			]
		],
		(* NOTE: We pick all of our instruments at once -- make sure to not include transfer environment instruments like *)
		(* the glove box or BSC. *)
		Replace[RequiredInstruments] -> DeleteDuplicates[
			Cases[
				Cases[
					DeleteDuplicates[Cases[Normal[initialPacket, Association], _Resource, Infinity]],
					Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]]
				],
				Except[Alternatives @@ ignoreResources]
			]
		]
	|>
}, First];


(* ::Subsection:: *)
(*Method Resolver*)

DefineOptions[resolveInoculateLiquidMediaMethod,
	SharedOptions :> {
		ExperimentInoculateLiquidMedia,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveInoculateLiquidMediaMethod[
	mySamples: ListableP[Automatic | ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String| {LocationPositionP, _String|ObjectP[Object[Container]]}],
	myOptions: OptionsPattern[]
] := Module[
	{
		safeOptions, cache, simulation, outputSpecification, output, gatherTests, inputContainers, inputSamples,
		allDestinationContainers, allDestinationModelContainers, allInoculationModelTips, allInoculationTips, downloadedStuff,
		flattenedCachePackets, combinedFastAssoc, inputSamplesFromContainers, inputSampleContainers, allModelTipPackets,
		containerModelPackets, liquidHandlerIncompatibleContainers, samplesClassificationInfo, classificationToSampleLookup,
		solidMediaSamples, liquidMediaSamples, agarStabSamples, freezeDriedSamples, frozenGlycerolSamples,
		manualRequirementStrings, roboticRequirementStrings, result, tests
	},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveInoculateLiquidMediaMethod, ToList[myOptions]];

	(* Specifically lookup the cache and simulation *)
	cache = Lookup[ToList[myOptions], Cache, {}];
	simulation = Lookup[ToList[myOptions], Simulation, Simulation[]];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Extract Containers and Tips from InputSamples and Options *)
	inputContainers = Cases[ToList@mySamples, {LocationPositionP, ObjectP[Object[Container]]}|ObjectP[Object[Container]]];
	inputSamples = Cases[ToList@mySamples, ObjectP[Object[Sample]]];
	allDestinationContainers = DeleteDuplicates@Cases[Flatten@ToList[Lookup[safeOptions, DestinationMediaContainer, {}]], ObjectP[Object[Container]]];
	allDestinationModelContainers = DeleteDuplicates@Cases[Flatten@ToList[Lookup[safeOptions, DestinationMediaContainer, {}]], ObjectP[Model[Container]]];
	allInoculationModelTips = DeleteDuplicates@Cases[ToList[Lookup[safeOptions, InoculationTips, {}]], ObjectReferenceP[Model[Item, Tips]]];
	allInoculationTips = DeleteDuplicates@Cases[ToList[Lookup[safeOptions, InoculationTips, {}]], ObjectReferenceP[Object[Item, Tips]]];

	(* Download information that we need from our inputs and/or options. *)
	downloadedStuff = Flatten/@Quiet[
		Download[
			{
				allInoculationModelTips,
				allInoculationTips,
				inputSamples,
				Cases[Flatten@Join[inputContainers, allDestinationContainers], ObjectP[]],
				allDestinationModelContainers,
				Cases[Flatten[ToList@mySamples], ObjectP[Object[Sample]]]
			},
			{
				{Packet[Name, PipetteType]},
				{Packet[Name, Object, Model], Packet[Model[{Name, PipetteType}]]},
				{Packet[Name, Container, State, StorageCondition, Composition], Packet[Container[{Contents, Model}]], Packet[Container[Model][{Footprint, LiquidHandlerPrefix}]]},
				{Packet[Contents, Model], Packet[Model[{Footprint, LiquidHandlerPrefix}]], Packet[Contents[[All, 2]][{Container, State, StorageCondition, Composition}]]},
				{Packet[Footprint, LiquidHandlerPrefix]},
				{Packet[Container, State, StorageCondition, Composition], Packet[Container[Model]], Packet[Container[Model][{Footprint, LiquidHandlerPrefix}]]}
			},
			Cache -> cache,
			Simulation -> simulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist, Download::MissingCacheField}
	];

	(* Flatten cache packets and make fast lookup association *)
	flattenedCachePackets = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];
	combinedFastAssoc = Experiment`Private`makeFastAssocFromCache[flattenedCachePackets];

	(* Make sure the helper classifyInoculationSampleTypes has Object[Sample] to work with *)
	inputSamplesFromContainers = If[Length[inputContainers] > 0,
		Map[
			Module[{containerObject, wellPosition},
				containerObject = FirstCase[ToList[#], ObjectP[Object[Container]]];
				(* If there is no well position, default to A1 *)
				wellPosition = FirstCase[ToList[#], LocationPositionP, "A1"];
				Download[FirstCase[fastAssocLookup[combinedFastAssoc, containerObject, Contents], {wellPosition, sample_}:>sample], Object]
			]&,
			inputContainers
		],
		{}
	];

	inputSampleContainers = If[Length[inputSamples] > 0,
		fastAssocLookup[combinedFastAssoc, #, Container]& /@ inputSamples,
		{}
	];

	(* Get all of the container objects that we were given. *)
	containerModelPackets = Map[
		If[MatchQ[#, ObjectP[Model[Container]]],
			(* for model, just get the packet directly *)
			fetchPacketFromFastAssoc[#, combinedFastAssoc],
			fastAssocPacketLookup[combinedFastAssoc, #, Model]
		]&,
		Cases[Flatten@Join[inputContainers, inputSampleContainers, allDestinationContainers, allDestinationModelContainers], ObjectP[]]
	];

	allModelTipPackets =Join[
		fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ allInoculationModelTips,
		fastAssocPacketLookup[combinedFastAssoc, #, Model]& /@ allInoculationTips
	];

	(* Get the containers that are liquid handler/colony handler incompatible *)
	(* Note: OmniTray is LiquidHandler compatible as well. *)
	liquidHandlerIncompatibleContainers = DeleteDuplicates[Flatten[{
		PickList[Lookup[containerModelPackets, Object, {}], Lookup[containerModelPackets, Footprint, {}], Except[LiquidHandlerCompatibleFootprintP]],
		PickList[Lookup[containerModelPackets, Object, {}], Lookup[containerModelPackets, LiquidHandlerPrefix, {}], Null]
	}]];

	{
		samplesClassificationInfo,
		classificationToSampleLookup
	} = If[!MatchQ[Flatten[{inputSamplesFromContainers, inputSamples}], {}],
		classifyInoculationSampleTypes[Flatten[{inputSamplesFromContainers, inputSamples}], Lookup[safeOptions, InoculationSource], combinedFastAssoc],
		{{}, {}}
	];

	{
		solidMediaSamples,
		liquidMediaSamples,
		agarStabSamples,
		freezeDriedSamples,
		frozenGlycerolSamples
	} = Lookup[classificationToSampleLookup, {SolidMedia, LiquidMedia, AgarStab, FreezeDried, FrozenGlycerol}, {}];

	(* Create a list of reasons why we need Preparation -> Manual *)
	manualRequirementStrings = {
		If[MatchQ[Lookup[safeOptions, InoculationSource], AgarStab | FreezeDried | FrozenGlycerol],
			"the following manual-only InoculationSource was specified " <> ToString@Lookup[safeOptions, InoculationSource],
			Nothing
		],
		(* For Model[Sample] input, we can only allow standard commercial forms: FreezeDried, FrozenGlycerol, AgarStab *)
		If[MatchQ[Lookup[safeOptions, InoculationSource], Automatic] && MemberQ[Cases[ToList@mySamples, ObjectP[Model[Sample]]], ObjectP[]],
			"the following manual-only model input samples " <>  ObjectToString[Cases[ToList@mySamples, ObjectP[Model[Sample]]], Cache -> cache, Simulation -> simulation] <> " were specified",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, InoculationSource], Automatic] && Length[agarStabSamples] > 0,
			"the samples, " <> ObjectToString[agarStabSamples, Cache -> cache, Simulation -> simulation] <> " are considered agar stabs and inoculating an agar stab source can only occur manually",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, InoculationSource], Automatic] && Length[freezeDriedSamples] > 0,
			"the samples, " <> ObjectToString[freezeDriedSamples, Cache -> cache, Simulation -> simulation] <> " are considered freeze-dried powder and inoculating a freeze-dried sample source can only occur manually",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, InoculationSource], Automatic] && Length[frozenGlycerolSamples] > 0,
			"the samples, " <> ObjectToString[frozenGlycerolSamples, Cache -> cache, Simulation -> simulation] <> " are considered frozen glycerol and inoculating a frozen glycerol source can only occur manually",
			Nothing
		],
		Module[{manualOnlyOptions},
			(* Mark any that do not match their default or Null *)
			manualOnlyOptions = Select[
				{Instrument, TransferEnvironment},
				(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler], Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}]|Null|Automatic]]&)
			];

			If[Length[manualOnlyOptions] > 0,
				"the following Manual-only options were specified " <> ToString[manualOnlyOptions] <> ". Inoculation with Pipette as Instrument inside of a biosafety cabinet is only supported for manual preparation",
				Nothing
			]
		],
		Module[{manualOnlyValues},
			(* Mark any that do not match nested indexed Automatic *)
			manualOnlyValues = Select[
				{SourceMixType, DestinationMixType},
				(!MatchQ[Flatten@ToList[Lookup[safeOptions, #, {}]], ListableP[Null|Automatic|Pipette|Shake]]&)
			];

			If[Length[manualOnlyValues] > 0,
				"the value Swirl was specified for option " <> ToString[manualOnlyValues] <> ". Swirl can only be set for manual preparation",
				Nothing
			]
		],
		If[And[
			!MatchQ[liquidHandlerIncompatibleContainers, {}],
			MatchQ[Lookup[safeOptions, InoculationSource], LiquidMedia] || (MatchQ[Lookup[safeOptions, InoculationSource], Automatic] && Length[liquidMediaSamples] > 0)
		],
			"the Input container or DestinationMediaContainer models" <> ObjectToString[liquidHandlerIncompatibleContainers, Cache -> cache, Simulation -> simulation] <> " are not liquid handler compatible",
			Nothing
		],
		(* Serological and Micropipette pipettes tips can only be used manually. *)
		Module[{manualOnlyTips},
			manualOnlyTips = Cases[
				allModelTipPackets,
				KeyValuePattern[{PipetteType -> Except[Hamilton|QPix]}]
			];

			If[Length[manualOnlyTips] > 0,
				"the following Manual-only Tips were specified " <> ObjectToString[Lookup[manualOnlyTips, Object], Cache -> cache, Simulation -> simulation],
				Nothing
			]
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation -> Robotic *)
	roboticRequirementStrings = {
		If[MatchQ[Lookup[safeOptions, InoculationSource], SolidMedia],
			"the robotic-only InoculationSource SolidMedia was specified",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, InoculationSource], Automatic] && Length[solidMediaSamples] > 0,
			"the samples, " <> ObjectToString[solidMediaSamples, Cache -> cache, Simulation -> simulation] <> " are considered in SolidMedia and colonies can only be picked off of them robotically",
			Nothing
		],
		Module[{optionsToCheck, optionDefinition, solidMediaOnlyOptions},
			(* Get the options that only pertain to SolidMedia InoculationSource *)
			optionsToCheck = KeyTake[Association@safeOptions, $SolidMediaOptionSymbols];

			(* Get the option definition of the function *)
			optionDefinition = OptionDefinition[ExperimentInoculateLiquidMedia];

			(* Mark any that do not match their default or Null *)
			solidMediaOnlyOptions = KeyValueMap[
				Function[{symbol, value},

					(* If the option matches its Default or Null, do Nothing *)
					If[MatchQ[value, ListableP[ListableP[ReleaseHold[Lookup[First[Cases[optionDefinition, KeyValuePattern["OptionSymbol" -> symbol]]], "Default"]] | Null]]],
						Nothing,
						symbol
					]
				],
				optionsToCheck
			];

			If[Length[solidMediaOnlyOptions] > 0,
				"the following options only apply when InoculationSource is SolidMedia, " <> ToString[solidMediaOnlyOptions] <> ". Colony picking is only supported on ColonyHandlers",
				Nothing
			]
		],
		Module[{roboticOnlyInstruments},
			(* Pull LH or Qpix *)
			roboticOnlyInstruments = Cases[
				ToList[Lookup[safeOptions, Instrument, Automatic]],
				ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler], Model[Instrument, ColonyHandler], Model[Instrument, ColonyHandler]}]
			];

			If[Length[roboticOnlyInstruments] > 0,
				"the following robotic instruments " <> ObjectToString[roboticOnlyInstruments, Cache -> cache, Simulation -> simulation] <> " were specified. LiquidHandler or ColonyHandler can only be used for robotic preparation",
				Nothing
			]
		],
		Module[{roboticOnlyValues},
			(* Mark any that do not match nested indexed Automatic *)
			roboticOnlyValues = Select[
				{DestinationMixType},
				(!MatchQ[Flatten@ToList[Lookup[safeOptions, #, {}]], ListableP[Null|Automatic|Pipette|Swirl]]&)
			];

			If[Length[roboticOnlyValues] > 0,
				"the value Shake was specified for option " <> ToString[roboticOnlyValues] <> ". Shake can only be set for robotic preparation using colony handler",
				Nothing
			]
		],
		(* Hamilton and QPix pipettes tips can only be used robotic. *)
		Module[{roboticOnlyTips},
			roboticOnlyTips = Cases[
				allModelTipPackets,
				KeyValuePattern[{PipetteType -> Hamilton|QPix}]
			];

			If[Length[roboticOnlyTips] > 0,
				"the following Robotic-only Tips were specified " <> ObjectToString[Lookup[roboticOnlyTips, Object], Cache -> cache, Simulation -> simulation],
				Nothing
			]
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0 && !gatherTests,
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
	result = Which[
		!MatchQ[Lookup[safeOptions, Preparation], Automatic],
			ToList@Lookup[safeOptions, Preparation],
		Length[manualRequirementStrings] > 0,
			{Manual},
		Length[roboticRequirementStrings] > 0,
			{Robotic},
		True,
			{Manual, Robotic}
	];

	(* Gather tests if needed *)
	tests = If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the InoculateLiquidMedia primitive", False, Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0]
		}
	];

	(* Return as necessary *)
	outputSpecification /. {Result -> result, Tests -> tests}

];


(* ::Subsection::Closed:: *)
(*Option Resolver*)
(*resolveExperimentInoculateLiquidMediaOptions*)


(* ::Code::Initialization:: *)
DefineOptions[
	resolveExperimentInoculateLiquidMediaOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentInoculateLiquidMediaOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentInoculateLiquidMediaOptions]] := Module[
	{
		(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
		outputSpecification, output, gatherTests, messages, combinedCache, currentSimulation, optionDefinition, inoculateLiquidMediaOptionsAssociation,
		combinedFastAssoc, samplePackets, sampleModelPackets, containerPackets, containerModelPackets, specifiedInoculationSource,
		specifiedPreparedModelAmount, specifiedPreparedModelContainer, specifiedPreparatoryUnitOperations, specifiedInstruments,
		specifiedTransferEnvironments, specifiedInoculationTips, specifiedVolumes, specifiedDestinationMediaContainers,
		specifiedMediaVolumes, upload, specifiedEmail, specifiedName, specifiedSamplesInStorageCondition, specifiedSamplesOutStorageCondition,
		samplesClassificationInfo, inoculationSourceToSampleLookup, solidMediaSamples, liquidMediaSamples, agarStabSamples,
		freezeDriedSamples, frozenGlycerolSamples, frozenLiquidMediaSamples,
		(*-- INPUT VALIDATION CHECKS --*)
		discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSampleModelPackets, deprecatedSampleModelInputs,
		deprecatedSampleInputs, deprecatedTest, conflictingInoculationSourceErrorInputs, conflictingInoculationSourceWarningInputs,
		conflictingInoculationSourceErrorCases, conflictingInoculationSourceWarningCases, conflictingInoculationSourceErrorTest,
		conflictingInoculationSourceWarningTest, invalidModelSampleSourceTypes, invalidModelSampleSourceInputs, invalidModelSampleSourceInputTests,
		invalidFrozenLiquidMediaInputs, invalidFrozenLiquidMediaInputTests, multipleSourceSampleTypes, multipleInoculationSourceInputs,
		multipleInoculationSourceInInputTests, duplicatedFreezeDriedSamples, duplicatedFreezeDriedSamplesTests, mainCellIdentityModels,
		sampleCellTypes, modifiedSampleCellTypes, validCellTypeQs, invalidCellTypeSamples, invalidCellTypeCellTypes, invalidCellTypeTest,
		(*-- OPTION PRECISION CHECKS --*)
		optionPrecisions, roundedInoculateLiquidMediaOptions, optionPrecisionTests,
		(*-- RESOLVE GENERAL OPTIONS --*)
		protocolOptions, nestedIndexMatchingOptions, nonInoculationSpecificOptions, resolvedInoculationSource, preparationResult, 
		allowedPreparation, preparationTest, resolvedPreparation, resolvedWorkCell, tipConnectionTypeLookup, resolvedInstruments, 
		resolvedInstrumentModelPackets, resolvedTransferEnvironments, resolvedTransferEnvironmentModelPackets, resolvedSamplesInStorageCondition, 
		resolvedEmail, userSpecifiedLabels, resolvedSampleLabels, resolvedSampleContainerLabels, resolvedGeneralOptions,
		(* -- CONFLICTING OPTIONS CHECKS I-- *)
		nameInvalidBool, nameInvalidOption, nameInvalidTest, conflictingWorkCellAndPreparationQ, conflictingWorkCellAndPreparationOptions,
		conflictingWorkCellAndPreparationTest, invalidInstrumentErrors, invalidInstrumentOptions, invalidInstrumentTests,
		instrumentCellTypeIncompatibleErrors, instrumentCellTypeIncompatibleOptions, instrumentCellTypeIncompatibleTests,
		bscCellTypeIncompatibleErrors, bscCellTypeIncompatibleOptions, bscCellTypeIncompatibleTests,
		(* -- Big Switch For Individual Inoculation Source Options and Error Trackings-- *)
		inoculationSourceError, inoculationSourceDensity, resolvedTotalOptions, nullMismatchOptions, switchInvalidOptions,
		switchInvalidInputs, noPreferredLiquidMediaWarnings, nonLiquidDestinationMediaErrors, overfillDestinationMediaContainerErrors,
		invalidDestinationWellErrors, multipleDestinationMediaContainersErrors, destinationMixMismatchErrors,
		noTipsFoundErrors, tipConnectionMismatchErrors, invalidResuspensionMediaStateErrors, resuspensionMediaOverfillErrors,
		noPreferredResuspensionLiquidMediaWarnings, unusedFreezeDriedSampleErrors, insufficientResuspensionMediaErrors,
		resuspensionMixFalseWarnings, resuspensionMixOptionsMismatchErrors,
		(* -- CONFLICTING OPTIONS CHECKS II-- *)
		specifiedNullOptions, specificMixValueOptions, nonDisposalFreezeDriedOptions, inoculationSourceOptionMismatchOptions,
		inoculationSourceOptionMismatchTests, destinationMediaStateOptions, destinationMediaStateTests, invalidDestinationWellInfo,
		invalidDestinationWellOptions, invalidDestinationWellTests, destinationMediaContainersOverfillOptions,
		destinationMediaContainersOverfillTests, multipleDestinationMediaContainersOptions, multipleDestinationMediaContainersTests,
		mixMismatchOptions, mixMismatchTests, noTipsFoundOptions, noTipsFoundTests, tipConnectionMismatchOptions, tipConnectionMismatchTests,
		resuspensionMediaStateOptions, resuspensionMediaStateTests, resuspensionMediaOverfillOptions, resuspensionMediaOverfillTests,
		freezeDriedMismatchedVolumeOptions, freezeDriedMismatchedVolumeTests, resuspensionMixMismatchOptions, resuspensionMixMismatchTests,
		mapThreadFriendlyResolvedOptions, inputBlendedMapThreadFriendlyOptions, volatileHazardousSamplesInBSCError,
		volatileHazardousSamplesInBSCMessage, volatileHazardousSamplesInBSCTest,
		(* -- RETURN -- *)
		invalidInputs, invalidOptions, allTests, resolvedPostProcessingOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	combinedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Initialize the simulation if it is not initialized *)
	currentSimulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Get the option definition of the function *)
	optionDefinition = OptionDefinition[ExperimentInoculateLiquidMedia];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	inoculateLiquidMediaOptionsAssociation = Association[myOptions];

	(* Create combined fast assoc *)
	combinedFastAssoc = Experiment`Private`makeFastAssocFromCache[combinedCache];
	samplePackets = fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ mySamples;
	sampleModelPackets = fastAssocPacketLookup[combinedFastAssoc, #, Model]& /@ mySamples;
	containerPackets = fastAssocPacketLookup[combinedFastAssoc, #, Container]& /@ mySamples;
	containerModelPackets = fastAssocPacketLookup[combinedFastAssoc, #, {Container, Model}]& /@ mySamples;

	(* Lookup the supplied options:InoculationSource, model input options, general option etc *)
	{
		specifiedInoculationSource,
		specifiedPreparedModelAmount,
		specifiedPreparedModelContainer,
		specifiedPreparatoryUnitOperations,
		specifiedInstruments,
		specifiedTransferEnvironments,
		specifiedInoculationTips,
		specifiedVolumes,
		specifiedDestinationMediaContainers,
		specifiedMediaVolumes,
		upload,
		specifiedEmail,
		specifiedName,
		specifiedSamplesInStorageCondition,
		specifiedSamplesOutStorageCondition
	} = Lookup[
		inoculateLiquidMediaOptionsAssociation,
		{
			InoculationSource,
			PreparedModelAmount,
			PreparedModelContainer,
			PreparatoryUnitOperations,
			Instrument,
			TransferEnvironment,
			InoculationTips,
			Volume,
			DestinationMediaContainer,
			MediaVolume,
			Upload,
			Email,
			Name,
			SamplesInStorageCondition,
			SamplesOutStorageCondition
		}
	];

	(* Classify each sample to different InoculationSources *)
	{
		samplesClassificationInfo,
		inoculationSourceToSampleLookup
	} = classifyInoculationSampleTypes[mySamples, specifiedInoculationSource, combinedFastAssoc];

	{
		solidMediaSamples,
		liquidMediaSamples,
		agarStabSamples,
		freezeDriedSamples,
		frozenGlycerolSamples,
		frozenLiquidMediaSamples
	} = Lookup[inoculationSourceToSampleLookup, {SolidMedia, LiquidMedia, AgarStab, FreezeDried, FrozenGlycerol, FrozenLiquidMedia}, {}];

	(*-- INPUT VALIDATION CHECKS --*)

	(* 1.) Discarded Sample Checks *)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && !gatherTests,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> combinedCache, Simulation -> currentSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> combinedCache, Simulation -> currentSimulation] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 2.) Get whether the samples have deprecated models. *)
	deprecatedSampleModelPackets = Cases[sampleModelPackets, KeyValuePattern[Deprecated -> True]];
	deprecatedSampleModelInputs = Lookup[deprecatedSampleModelPackets, Object, {}];
	deprecatedSampleInputs = Lookup[
		PickList[samplePackets, sampleModelPackets, KeyValuePattern[Deprecated -> True]],
		Object,
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedSampleModelInputs] > 0 && messages,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedSampleModelInputs, Cache -> combinedCache, Simulation -> currentSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedSampleInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[deprecatedSampleInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have models that are not Deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedSampleInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, deprecatedSampleInputs], Cache -> combinedCache, Simulation -> currentSimulation] <> " have models that are not Deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 3.)InoculationSource Input sample mismatch checks *)
	(* Hard error and soft error: For ErrorTypes {State,Hermetic,Container,StorageCondition}, throw hard error *)
	(*For ErrorTypes {Agarose, Glycerol}, throw soft warning *)
	{conflictingInoculationSourceErrorInputs, conflictingInoculationSourceWarningInputs} = If[MatchQ[specifiedInoculationSource, Automatic],
		(* If InoculationSource is Automatic, no samples can be mismatched with it *)
		{{}, {}},
		(* Otherwise if InoculationSource is set, check against the other types *)
		Transpose@Map[
			If[TrueQ[Lookup[#, Error]],
				{
					If[MemberQ[Lookup[#, ErrorTypes], Alternatives[State, Hermetic, Container, StorageCondition]],
						Lookup[#, Object],
						Null
					],
					If[MemberQ[Lookup[#, ErrorTypes], Alternatives[Agarose, Glycerol]],
						Lookup[#, Object],
						Null
					]
				},
				{Null, Null}
			]&,
			samplesClassificationInfo
		]
	];

	(* Note: the same logic is used in classifyInoculationSampleTypes *)
	(* For ErrorTypes {State,Hermetic,Container,StorageCondition}, throw hard error *)
	conflictingInoculationSourceErrorCases = If[MatchQ[conflictingInoculationSourceErrorInputs, {Null...}],
		{},
		Map[
			Function[{sample},
				Module[{sampleEntry, errorTypes, joinedCasesPerSample},
					sampleEntry = FirstCase[samplesClassificationInfo, KeyValuePattern[{Object -> ObjectP[sample]}]];
					errorTypes = Lookup[sampleEntry, ErrorTypes];
					joinedCasesPerSample = {
						If[MemberQ[errorTypes, State],
							If[MatchQ[specifiedInoculationSource, LiquidMedia], " has non-Liquid State:", " has non-Solid State:"],
							Nothing
						],
						If[MemberQ[errorTypes, Hermetic],
							StringJoin@{
								If[MatchQ[specifiedInoculationSource, FreezeDried], " is in non-hermetic or non-ampoule model container ", " is in model hermetic or ampoule model container "],
								ObjectToString[Lookup[sampleEntry, Container], Cache -> combinedCache, Simulation -> currentSimulation]
							},
							Nothing
						],
						If[MemberQ[errorTypes, Container],
							StringJoin@{
								" is in non-plate model container ",
								ObjectToString[Lookup[sampleEntry, Container], Cache -> combinedCache, Simulation -> currentSimulation]
							},
							Nothing
						],
						If[MemberQ[errorTypes, StorageCondition],
							StringJoin@{
								" is in a non-freezing StorageCondition:",
								ObjectToString[Lookup[sampleEntry, StorageCondition], Cache -> combinedCache, Simulation -> currentSimulation]
							},
							Nothing
						]
					};
					{
						Lookup[sampleEntry, InoculationSource],
						joinClauses[
							Join[
								{StringJoin[ObjectToString[sample, Cache -> combinedCache, Simulation -> currentSimulation], First[joinedCasesPerSample]]},
								Rest[joinedCasesPerSample]
							]
						]
					}
				]
			],
			conflictingInoculationSourceErrorInputs
		]
	];

	If[!MatchQ[conflictingInoculationSourceErrorCases, {}] && messages,
		Message[
			Error::ConflictingInoculationSource,
			ObjectToString[DeleteCases[conflictingInoculationSourceErrorInputs, Null], Cache -> combinedCache, Simulation -> currentSimulation],
			conflictingInoculationSourceErrorCases[[All, 1]],
			specifiedInoculationSource,
			StringJoin@conflictingInoculationSourceErrorCases[[All, 2]]
		]
	];

	(* Note: the same logic is used in classifyInoculationSampleTypes *)
	(* For ErrorTypes {Agarose, Glycerol}, throw soft warning *)
	conflictingInoculationSourceWarningCases = If[MatchQ[conflictingInoculationSourceWarningInputs, {Null...}],
		{},
		Map[
			Function[{sample},
				Module[{sampleEntry, errorTypes, joinedCasesPerSample},
					sampleEntry = FirstCase[samplesClassificationInfo, KeyValuePattern[{Object -> ObjectP[sample]}]];
					errorTypes = Lookup[sampleEntry, ErrorTypes];
					(* Note:currently there is no case where Agarose and Glycerol are failing at the same time, but we keep them separate for the future *)
					joinedCasesPerSample = {
						If[MemberQ[errorTypes, Agarose],
							" has no agarose in composition",
							Nothing
						],
						If[MemberQ[errorTypes, Glycerol],
							" has no glycerol in composition",
							Nothing
						]
					};
					{
						joinClauses[
							Join[
								{StringJoin[ObjectToString[sample, Cache -> combinedCache, Simulation -> currentSimulation], First[joinedCasesPerSample]]},
								Rest[joinedCasesPerSample]
							]
						]
					}
				]
			],
			conflictingInoculationSourceWarningInputs
		]
	];

	If[!MatchQ[conflictingInoculationSourceWarningCases, {}] && messages,
		Message[
			Warning::ConflictingInoculationSource,
			ObjectToString[DeleteCases[conflictingInoculationSourceWarningInputs, Null], Cache -> combinedCache, Simulation -> currentSimulation],
			specifiedInoculationSource,
			StringJoin@conflictingInoculationSourceWarningCases
		]
	];

	conflictingInoculationSourceErrorTest = If[!MatchQ[conflictingInoculationSourceErrorCases, {}] && gatherTests,
		Module[{passingInputs, passingTest, failingTest},

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, conflictingInoculationSourceErrorInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have classification corresponds with specified InoculationSource:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[DeleteCases[conflictingInoculationSourceErrorInputs, Null], Cache -> combinedCache, Simulation -> currentSimulation] <> " have classification corresponds with specified InoculationSource:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	conflictingInoculationSourceWarningTest = If[!MatchQ[conflictingInoculationSourceWarningCases, {}] && gatherTests,
		Module[{passingInputs, passingTest, failingTest},

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, conflictingInoculationSourceWarningInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have classification corresponds with specified InoculationSource:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[DeleteCases[conflictingInoculationSourceWarningInputs, Null], Cache -> combinedCache, Simulation -> currentSimulation] <> " have classification corresponds with specified InoculationSource:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 4.)Model input InoculationSource Type check. *)

	(* For Model[Sample] input, we can only allow standard commercial forms: FreezeDried, FrozenGlycerol, AgarStab. *)
	(* Extract the InoculationSource where model input not supported, Note for FrozenLiquidMedia, we will thrown Error::UnsupportedInoculationSourceType later *)
	invalidModelSampleSourceTypes = If[!NullQ[specifiedPreparedModelContainer],
		Module[{simulatedSamplesWithModelInput},
			(* Extract all Model[Sample] input and convert simulatedSamples back to Model[Sample] for error message *)
			simulatedSamplesWithModelInput = PickList[mySamples, specifiedPreparedModelContainer, Except[Null]];
			Which[
				MatchQ[specifiedInoculationSource, SolidMedia|LiquidMedia],
					{{specifiedInoculationSource, Download[fastAssocPacketLookup[combinedFastAssoc, #, Model]& /@ simulatedSamplesWithModelInput, Object]}},
				MatchQ[specifiedInoculationSource, Automatic] && MemberQ[Flatten@Lookup[inoculationSourceToSampleLookup, {SolidMedia, LiquidMedia}, {}], ObjectP[simulatedSamplesWithModelInput]],
						{
							If[MemberQ[Lookup[inoculationSourceToSampleLookup, SolidMedia, {}], ObjectP[simulatedSamplesWithModelInput]],
								{SolidMedia, Download[fastAssocPacketLookup[combinedFastAssoc, #, Model]& /@ Cases[Lookup[inoculationSourceToSampleLookup, SolidMedia], ObjectP[simulatedSamplesWithModelInput]], Object]},
								Nothing
							],
							If[MemberQ[Lookup[inoculationSourceToSampleLookup, LiquidMedia, {}], ObjectP[simulatedSamplesWithModelInput]],
								{LiquidMedia, Download[fastAssocPacketLookup[combinedFastAssoc, #, Model]& /@ Cases[Lookup[inoculationSourceToSampleLookup, LiquidMedia], ObjectP[simulatedSamplesWithModelInput]], Object]},
								Nothing
							]
						},
				True,
					{}
			]
		],
		{}
	];

	(* Throw an error if there are multiple source sample types *)
	invalidModelSampleSourceInputs = If[!MatchQ[invalidModelSampleSourceTypes, {}] && messages,
		invalidModelSampleSourceTypes[[All, 2]],
		{}
	];

	(* Throw an error *)
	If[!MatchQ[invalidModelSampleSourceInputs , {}] && messages,
		Message[
			Error::InvalidModelSampleInoculationSourceType,
			ObjectToString[Flatten@invalidModelSampleSourceTypes[[All, 2]], Cache -> combinedCache, Simulation -> currentSimulation],
			If[Length[invalidModelSampleSourceTypes] == 1, ToString[invalidModelSampleSourceTypes[[All, 1]][[1]]], "LiquidMedia or SolidMedia"]
		]
	];

	(* Create a test if we are gathering tests *)
	invalidModelSampleSourceInputTests = If[!MatchQ[invalidModelSampleSourceTypes, {}] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = mySamples;

			(* Get the passing inputs *)
			passingInputs = {};

			(* Create the passing test *)
			passingTest = Test["When the input sample is Model[Sample], it is not the unsupported InoculationSource type of SolidMedia or LiquidMedia:", True, True];

			(* Create the failing test *)
			failingTest = Test["The the input sample is Model[Sample], it is not the unsupported InoculationSource type of SolidMedia or LiquidMedia:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 5.)Unsupported input InoculationSource Type check. *)

	(* For FrozenLiquidMedia, currently we can only thaw it first with ExperimentIncubate then inoculate it as LiquidMedia *)
	(* If user has specified InoculationSource to bypass the Glycerol composition check, don't throw it *)
	invalidFrozenLiquidMediaInputs = If[MatchQ[specifiedInoculationSource, Automatic] && MemberQ[Lookup[inoculationSourceToSampleLookup, FrozenLiquidMedia, {}], ObjectP[]],
		Lookup[inoculationSourceToSampleLookup, FrozenLiquidMedia],
		{}
	];
	
	(* Throw an error if there are FrozenLiquidMedia samples *)
	If[!MatchQ[invalidFrozenLiquidMediaInputs, {}] && messages,
		(* Throw an error and mark the bad inputs *)
		Message[
			Error::UnsupportedInoculationSourceType,
			ObjectToString[invalidFrozenLiquidMediaInputs, Cache -> combinedCache, Simulation -> currentSimulation]
		]
	];

	(* Create a test if we are gathering tests *)
	invalidFrozenLiquidMediaInputTests = If[!MatchQ[invalidFrozenLiquidMediaInputs, {}] && gatherTests,
		Module[{passingTest, failingTest},

			(* Create the passing test *)
			passingTest = If[Length[invalidFrozenLiquidMediaInputs] == Length[mySamples],
				Nothing,
				Test["The input sample does not contain any unsupported sample of InoculationSource type of FrozenLiquidMedia:", True, True]
			];

			(* Create the failing test *)
			failingTest = If[Length[invalidFrozenLiquidMediaInputs] == 0,
				Nothing,
				Test["The input sample does not contain any unsupported sample of InoculationSource type of FrozenLiquidMedia:", True, False]
			];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 6.) Multiple Input Sample State checks *)

	(* Mark if we have multiple source sample types - This is an important flag/major error *)
	multipleSourceSampleTypes = If[MatchQ[specifiedInoculationSource, Automatic] && GreaterQ[Length@Keys[inoculationSourceToSampleLookup], 1],
		Keys[inoculationSourceToSampleLookup],
		{}
	];

	(* Throw an error if there are multiple source sample types *)
	multipleInoculationSourceInputs = If[Length[multipleSourceSampleTypes] > 0 && messages,
		{mySamples},
		{}
	];

	(* Throw an error *)
	If[!MatchQ[multipleInoculationSourceInputs, {}] && messages,
		Message[
			Error::MultipleInoculationSourceInInput,
			ObjectToString[mySamples, Cache -> combinedCache, Simulation -> currentSimulation],
			ToString[multipleSourceSampleTypes]
		]
	];

	(* Create a test if we are gathering tests *)
	multipleInoculationSourceInInputTests = If[!MatchQ[multipleInoculationSourceInputs, {}] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = mySamples;

			(* Get the passing inputs *)
			passingInputs = {};

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have only a single source type among them:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have only a single source type among them:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 7.) Duplicated freeze-dried samples check *)
	duplicatedFreezeDriedSamples = If[DuplicateFreeQ[freezeDriedSamples],
		{},
		(* Find which samples are duplicated *)
		First /@ DeleteCases[Tally[freezeDriedSamples], {_, 1}]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[duplicatedFreezeDriedSamples] > 0 && !gatherTests,
		Message[Error::DuplicatedFreezeDriedSamples, ObjectToString[duplicatedFreezeDriedSamples, Cache -> combinedCache, Simulation -> currentSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	duplicatedFreezeDriedSamplesTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[duplicatedFreezeDriedSamples] > 0,
				Test["The input samples " <> ObjectToString[mySamples, Cache -> combinedCache, Simulation -> currentSimulation] <> " do not contain duplicates if inoculation source is FreezeDried:", True, False],
				Nothing
			];

			passingTest = If[Length[duplicatedFreezeDriedSamples] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[mySamples, Cache -> combinedCache, Simulation -> currentSimulation] <> " do not contain duplicates if inoculation source is FreezeDried:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 8.)Get whether the input cell types are supported *)

	(* first get the main cell object in the composition; if this is a mixture it will pick the one with the highest concentration *)
	mainCellIdentityModels = selectMainCellFromSample[mySamples, Cache -> combinedCache];

	(* Determine what kind of cells the input samples are *)
	sampleCellTypes = lookUpCellTypes[samplePackets, sampleModelPackets, mainCellIdentityModels, Cache -> combinedCache];

	(* If there are samples without cell in composition as control, we should use the same WorkCell/TransferEnvironment/Instrument as the experimental group but there can be grouped together *)
	(* For example, sample 1 is water, sample 2 is HEK293 cells, we should inoculate both together using mammalian WorkCell/TransferEnvironment/Instrument *)
	(* Note: if cell is Insect/Plant/Fungus, we treat them the same as Null *)
	modifiedSampleCellTypes = If[MemberQ[sampleCellTypes, Except[Mammalian|Yeast|Bacterial]] && MemberQ[sampleCellTypes, Mammalian|Yeast|Bacterial] && EqualQ[DeleteDuplicates@Cases[sampleCellTypes, Mammalian|Yeast|Bacterial], 1],
		sampleCellTypes/.(Except[Mammalian|Yeast|Bacterial] -> FirstCase[sampleCellTypes, Mammalian|Yeast|Bacterial]),
		(* Otherwise, the no cell sample will go with microbial samples *)
		sampleCellTypes
	];

	(* Note here that Null is acceptable (in case negative control is performed )*)
	validCellTypeQs = MatchQ[#, Mammalian|Yeast|Bacterial|Null]& /@ sampleCellTypes;
	invalidCellTypeSamples = Lookup[PickList[samplePackets, validCellTypeQs, False], Object, {}];
	invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

	If[Length[invalidCellTypeSamples] > 0 && messages,
		Message[
			Error::UnsupportedCellTypes,
			(*1*)"ExperimentInoculateLiquidMedia only supports mammalian, bacterial and yeast cell cultures",
			(*2*)StringJoin[
			Capitalize@samplesForMessages[invalidCellTypeSamples, mySamples, Cache -> combinedCache, Simulation -> currentSimulation],(* Potentially collapse to the sample or all samples instead of ID here *)
			If[Length[invalidCellTypeSamples] == 1,
				" has",
				" have"
			],
			" CellType detected as ",
			joinClauses@invalidCellTypeCellTypes,
			" from the CellType field of the object(s)"
		]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidCellTypeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidCellTypeSamples] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> combinedCache, Simulation -> currentSimulation] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> combinedCache, Simulation -> currentSimulation] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* First, define the option precisions that need to be checked for InoculateLiquidMedia *)
	optionPrecisions = {
		{Volume, 10^-1*Microliter},
		{MediaVolume, 10^0*Microliter},
		{DestinationMixVolume, 10^0*Microliter},
		{ResuspensionMediaVolume, 10^0*Microliter},
		{ResuspensionMixVolume, 10^0*Microliter},
		{SourceMixVolume, 10^0*Microliter},
		{MinDiameter, 10^-2*Millimeter},
		{MaxDiameter, 10^-2*Millimeter},
		{MinColonySeparation, 10^-2*Millimeter},
		{ExposureTimes, 10^0*Millisecond},
		{ColonyPickingDepth, 10^-2*Millimeter},
		{PickCoordinates, 10^-1*Millimeter},
		{PrimaryDryTime, 10^0*Second},
		{SecondaryDryTime, 10^0*Second},
		{TertiaryDryTime, 10^0*Second},
		{QuaternaryDryTime, 10^0*Second}
	};

	(* Check the precisions of these options. *)
	{roundedInoculateLiquidMediaOptions, optionPrecisionTests} = If[gatherTests,
		(*If we are gathering tests *)
		RoundOptionPrecision[inoculateLiquidMediaOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
		(* Otherwise *)
		{RoundOptionPrecision[inoculateLiquidMediaOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
	];

	(*-- RESOLVE GENERAL OPTIONS --*)

	(* Experiments options are shared by all experiments *)
	protocolOptions = {
		Cache, Simulation, FastTrack, Template, ParentProtocol, Operator, Interruptible, OptionsResolverOnly,
		Confirm, Name, Upload, Output, Email, HoldOrder, Priority, StartDate, QueuePosition, Site, CanaryBranch, SubprotocolDescription,
		MeasureWeight, MeasureVolume, ImageSample,
		PreparedModelAmount, PreparedModelContainer, PreparatoryUnitOperations
	};
	(* Only for SolidMedia, we have below options nested indexmatching to Populations. *)
	nestedIndexMatchingOptions = {
		SamplesOutStorageCondition, SampleOutLabel, ContainerOutLabel,
		(* Media Preparation options *)
		DestinationMix, DestinationMixType, DestinationNumberOfMixes,
		DestinationMixVolume, MediaVolume, DestinationMedia, DestinationMediaContainer, DestinationWell
	};
	(* Experiments options are shared by all type of inoculation source in this experiment *)
	nonInoculationSpecificOptions = Join[
		{
			InoculationSource, Instrument, TransferEnvironment, WorkCell, Preparation,
			SampleLabel, SampleContainerLabel, SamplesInStorageCondition
		},
		nestedIndexMatchingOptions
	];

	(* Resolve MaterSwitch InoculationSource *)
	resolvedInoculationSource = If[MatchQ[specifiedInoculationSource, Except[Automatic]],
		specifiedInoculationSource,
		(* If the option is Automatic, resolve it based on the type of input samples *)
		If[MatchQ[Cases[Keys@inoculationSourceToSampleLookup, InoculationSourceP], {}],
			(* If there is only FrozenLiquidMedia samples, resolve to LiquidMedia *)
			LiquidMedia,
			(* Otherwise, set based off classification *)
			FirstCase[Keys@inoculationSourceToSampleLookup, InoculationSourceP]
		]
	];

	(* Resolve Preparation and WorkCell *)
	preparationResult = Check[
		{allowedPreparation, preparationTest} = If[MatchQ[gatherTests, False],
			{
				resolveInoculateLiquidMediaMethod[mySamples, ReplaceRule[Normal[roundedInoculateLiquidMediaOptions, Association], {InoculationSource -> resolvedInoculationSource, Cache -> combinedCache, Simulation -> currentSimulation, Output -> Result}]],
				{}
			},
			resolveInoculateLiquidMediaMethod[mySamples, ReplaceRule[Normal[roundedInoculateLiquidMediaOptions, Association], {InoculationSource -> resolvedInoculationSource, Cache -> combinedCache, Simulation -> currentSimulation, Output -> {Result, Tests}}]]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation = FirstOrDefault[allowedPreparation];

	(* Resolve the work cell that we're going to operator on. *)
	resolvedWorkCell = FirstOrDefault[resolveInoculateLiquidMediaWorkCell[mySamples, ReplaceRule[Normal[roundedInoculateLiquidMediaOptions, Association], {Cache -> combinedCache, Simulation -> currentSimulation, Preparation -> resolvedPreparation, Output -> Result}]]];

	(* Resolve the instrument option *)

	(* Define connectionType Lookup table for manual pipette and tip based on TipConnectionType and *)
	tipConnectionTypeLookup = <|
		P10 -> {
			NonMicrobial -> Model[Instrument, Pipette, "id:Z1lqpMznLWVM"], (* "Eppendorf Research Plus P2.5, Tissue Culture" *)
			Microbial -> Model[Instrument, Pipette, "id:BYDOjvGzwBZD"] (* "Eppendorf Research Plus P2.5, Microbial" *)
		},
		P20 -> {
			NonMicrobial -> Model[Instrument, Pipette, "id:8qZ1VW0p9neD"], (* "Eppendorf Research Plus P20, Tissue Culture" *)
			Microbial -> Model[Instrument, Pipette, "id:kEJ9mqRlbZxV"] (* "Eppendorf Research Plus P20, Microbial" *)
		},
		P200 -> {
			NonMicrobial -> Model[Instrument, Pipette, "id:xRO9n3BqKznz"], (* "Eppendorf Research Plus P200, Tissue Culture" *)
			Microbial -> Model[Instrument, Pipette, "id:vXl9j57VBAjN"] (* "Eppendorf Research Plus P200, Microbial" *)
		},
		P1000 -> {
			NonMicrobial -> Model[Instrument, Pipette, "id:AEqRl9Ko8XWR"], (*"Eppendorf Research Plus P1000, Tissue Culture"*)
			Microbial -> Model[Instrument, Pipette, "id:GmzlKjP3boWe"] (* "Eppendorf Research Plus P1000, Microbial" *)
		},
		P5000 -> {
			NonMicrobial -> Model[Instrument, Pipette, "id:rea9jlReMVDb"], (* "Eppendorf Research Plus P5000, Tissue Culture" *)
			Microbial -> Model[Instrument, Pipette, "id:qdkmxzqdM4xm"] (* "Eppendorf Research Plus P5000, Microbial" *)
		},
		Serological -> {
			NonMicrobial -> Model[Instrument, Pipette, "id:KBL5DvwK6REk"], (* "pipetus, Tissue Culture" *)
			Microbial -> Model[Instrument, Pipette, "id:4pO6dM51ljY5"] (* "pipetus, Microbial" *)
		}
	|>;

	resolvedInstruments = MapThread[
		Function[
			{
				sample,
				instrument,
				cellType,
				samplePacket,
				containerModelPacket,
				inoculationTip,
				volume,
				destinationMediaContainer,
				mediaVolume
			},
			(* Resolve Instrument for each sample *)
			Which[
				MatchQ[instrument, Except[Automatic]],
					(* If instrument is specified, use it *)
					instrument,
				MatchQ[resolvedInoculationSource, SolidMedia],
					If[MemberQ[specifiedInstruments, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}]],
						(* If a colony handler has been specified for other samples, pick the same colony handler *)
						FirstCase[specifiedInstruments, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}]],
						(* If InoculationSource is SolidMedia, resolve to Model[Instrument, ColonyHandler, "QPix 420 HT"] *)
						Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]
					],
				MatchQ[resolvedInoculationSource, LiquidMedia] && MatchQ[resolvedPreparation, Robotic],
					Which[
						(* If a LH has been specified for other samples, pick the same LH since only LH should be selected per protocol *)
						MemberQ[specifiedInstruments, ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
							FirstCase[specifiedInstruments, ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
						(* If InoculationSource is LiquidMedia and Preparation is Robotic, resolve to a LH based on cell type *)
						MatchQ[resolvedWorkCell, bioSTAR] || MatchQ[cellType, NonMicrobialCellTypeP|Null],
							Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],(* bioSTAR *)
						True,
							Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"] (* microbioSTAR *)
					],
				MatchQ[inoculationTip, ObjectP[]],
					(* If InoculationSource is LiquidMedia|AgarStab|FreezeDried|FrozenGlycerol, and tip is specified - Find a pipette instrument that fits the tips *)
					Module[{tipConnectionType},
						(* Get the connection type of the specified tips *)
						tipConnectionType = fastAssocLookup[combinedFastAssoc, inoculationTip, TipConnectionType];
						(* Use the lookup to find the instrument if the TipConnectionType is one of the keys in lookup *)
						If[MemberQ[Keys@tipConnectionTypeLookup, tipConnectionType],
							Lookup[Lookup[tipConnectionTypeLookup, tipConnectionType], If[MatchQ[cellType, MicrobialCellTypeP], Microbial, NonMicrobial]],
							(* Otherwise, resolve to P1000 and throw a tip mismatch error later *)
							If[MatchQ[cellType, MicrobialCellTypeP],
								Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* "Eppendorf Research Plus P1000, Microbial" *)
								Model[Instrument, Pipette, "id:AEqRl9Ko8XWR"] (*"Eppendorf Research Plus P1000, Tissue Culture"*)
							]
						]
					],
				MatchQ[resolvedInoculationSource, LiquidMedia],
					(* If InoculationSource is LiquidMedia, Preparation is Manual and no specified InoculationTips, resolve to a pipette based on the volume being transferred *)
					Module[
						{
							sampleVolume, preResolvedVolume, possibleMicropipetteTypes, possibleMicropipetteTips, possibleMicropipetteTipPackets,
							micropipetteTipCanTouchSampleQ, possibleMicropipetteTip
						},
						(* Pre-resolve Volume *)
						sampleVolume = Lookup[samplePacket, Volume]/.Null -> 0 Microliter;
						preResolvedVolume = Which[
							MatchQ[volume, Except[Automatic]],
								volume/.{Null -> 0 Microliter, All -> sampleVolume},
							LessQ[sampleVolume, 10 Microliter],
								sampleVolume,
							MemberQ[ToList@destinationMediaContainer, ObjectP[]],
								Module[{maxVolume},
									maxVolume = If[MatchQ[FirstCase[ToList@destinationMediaContainer, ObjectP[]], ObjectP[Object]],
										fastAssocLookup[combinedFastAssoc, FirstCase[ToList@destinationMediaContainer, ObjectP[]], {Model, MaxVolume}],
										fastAssocLookup[combinedFastAssoc, FirstCase[ToList@destinationMediaContainer, ObjectP[]], MaxVolume]
									];
									(* If the option is automatic, resolve it to 1/10th of the volume of the input sample or 1/12th of the destination container max vol *)
									Min[
										SafeRound[maxVolume/12, 10^-1*Microliter],
										SafeRound[sampleVolume/10, 10^-1*Microliter]
									]
								],
							True,
								(* If the option is automatic, resolve it to 1/10th of the volume of the input sample or 1 ml whichever is smaller *)
								Min[
									1 Milliliter,
									SafeRound[sampleVolume/10, 10^-1*Microliter]
								]
						];
						possibleMicropipetteTypes = Which[
							LessEqualQ[preResolvedVolume, 10 Microliter], {P10, P20},
							LessEqualQ[preResolvedVolume, 20 Microliter], {P20},
							LessEqualQ[preResolvedVolume, 200 Microliter], {P200},
							LessEqualQ[preResolvedVolume, 1000 Microliter], {P1000},
							True, P5000
						];
						possibleMicropipetteTips = TransferDevices[
							Model[Item, Tips],
							All,
							TipConnectionType -> possibleMicropipetteTypes,
							Sterile -> True
						][[All, 1]];
						(* Get all the possible tip packets *)
						possibleMicropipetteTipPackets = fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ possibleMicropipetteTips;
						micropipetteTipCanTouchSampleQ = MapThread[
							Experiment`Private`tipsCanAspirateQ[
								(* Tip Object *)
								#1,
								(* Container of interest Packet *)
								containerModelPacket,
								(* We just need to touch the top of the sample *)
								preResolvedVolume,
								(* We are "aspirating" 0 volume - just need to touch the top *)
								0 Milliliter,
								(* Tip Packet *)
								{#2},
								(* Volume calibration packet *)
								{}
							]&,
							{possibleMicropipetteTips, possibleMicropipetteTipPackets}
						];
						possibleMicropipetteTip = PickList[possibleMicropipetteTips, micropipetteTipCanTouchSampleQ];
						If[!MatchQ[possibleMicropipetteTip, {}],
							Lookup[Lookup[tipConnectionTypeLookup, fastAssocLookup[combinedFastAssoc, First[possibleMicropipetteTip], TipConnectionType]], If[MatchQ[cellType, MicrobialCellTypeP], Microbial, NonMicrobial]],
							Lookup[Lookup[tipConnectionTypeLookup, Serological], If[MatchQ[cellType, MicrobialCellTypeP], Microbial, NonMicrobial]]
						]
					],
				MatchQ[resolvedInoculationSource, AgarStab],
					(* If InoculationSource is AgarStab and no InoculationTips is specified, try first with P1000 pipette. Need to make sure the pipette is able to reach both source and destination containers *)
					(* This reaching requirement is only critical for AgarStab since InoculationTips will be stuck with solid chuck of cells and the tip has to be mixed with destination media to release the inoculum. *)
					Module[
						{
							sampleVolume, preResolvedDestinationMediaContainer, destinationMediaContainerPacket, p1000Packet, p1000CanTouchSampleQ,
							p1000CanTouchDestinationBottomQ
						},
						(* Get the source Volume *)
						sampleVolume = If[MatchQ[Lookup[samplePacket, Volume], VolumeP],
							Lookup[samplePacket, Volume],
							(* Otherwise look up the mass and use the density of Agar to calculate volume *)
							Lookup[samplePacket, Mass] / (1.03 Gram / Milliliter)
						];
						(* Preresolve DestinationMediaContainer *)
						preResolvedDestinationMediaContainer = If[MatchQ[destinationMediaContainer, Except[ListableP[Automatic]]],
							FirstCase[ToList@destinationMediaContainer, ObjectP[]],
							(* If the option is automatic, resolve a container based on MediaVolume *)
							If[MatchQ[mediaVolume, ListableP[Automatic]],
								(* If mediaVolume is also Automatic, default to "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap" *)
								Model[Container, Vessel, "id:AEqRl9KXBDoW"],
								(* Otherwise use PreferredContainer[mediaVolume] to get a container that fits *)
								FirstCase[ToList[PreferredContainer[mediaVolume, (CellType -> cellType/.Null->Automatic), Sterile -> True]], ObjectP[Model[Container]], Model[Container, Vessel, "id:AEqRl9KXBDoW"]]
							]
						];
						(* Get the destination packet *)
						destinationMediaContainerPacket = If[MatchQ[preResolvedDestinationMediaContainer, ObjectP[Model[Container]]],
							fetchPacketFromFastAssoc[preResolvedDestinationMediaContainer, combinedFastAssoc],
							fastAssocPacketLookup[combinedFastAssoc, preResolvedDestinationMediaContainer, Model]
						];

						(* Get all the possible tip packets *)
						p1000Packet = fetchPacketFromFastAssoc[Model[Item, Tips, "id:n0k9mGzRaaN3"], combinedFastAssoc]; (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
						(* See if the tips can "aspirate" from the source and "dispense" into the destination *)
						(* Note: tipsCanAspirateQ is defined in ExperimentTransfer *)
						p1000CanTouchSampleQ = Experiment`Private`tipsCanAspirateQ[
							(* Tip Object *)
							Model[Item, Tips, "id:n0k9mGzRaaN3"], (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
							(* Container of interest Packet *)
							containerModelPacket,
							(* We just need to touch the top of the sample *)
							sampleVolume,
							(* We are "aspirating" 0 volume - just need to touch the top *)
							0 Milliliter,
							(* Tip Packet *)
							{p1000Packet},
							(* Volume calibration packet *)
							{}
						];
						p1000CanTouchDestinationBottomQ = Experiment`Private`tipsCanAspirateQ[
							(* Tip Object *)
							Model[Item, Tips, "id:n0k9mGzRaaN3"], (* Model[Item, Tips, "1000 uL reach tips, sterile"] *)
							(* Container of interest Packet *)
							destinationMediaContainerPacket,
							(* We always want to be able to touch the bottom of the container *)
							0 Milliliter,
							(* We are "aspirating" 0 volume - just need to touch the top *)
							0 Milliliter,
							(* Tip packet *)
							{p1000Packet},
							(* Volume calibration packet *)
							{}
						];

						(* If the P1000 works, use it! *)
						If[p1000CanTouchSampleQ && p1000CanTouchDestinationBottomQ,
							Lookup[Lookup[tipConnectionTypeLookup, P1000], If[MatchQ[cellType, MicrobialCellTypeP], Microbial, NonMicrobial]],
							(* Otherwise, resolve to serological pipette *)
							Lookup[Lookup[tipConnectionTypeLookup, Serological], If[MatchQ[cellType, MicrobialCellTypeP], Microbial, NonMicrobial]]
						]
					],
				True,
					(* If InoculationSource is FreezeDried or FrozenGlycerol and no specified InoculationTips, resolve to a P1000 pipette *)
					(* Note: we decide to use P1000 pipette since 1) the same pipette will be used to resuspend/mix so too low vol is not good for mixing *)
					(*2) serological pipette can not enter ampoule/hermetic container, or hard to scrape frozen glycerol *)
					If[MatchQ[cellType, MicrobialCellTypeP],
						Model[Instrument, Pipette, "id:GmzlKjP3boWe"], (* "Eppendorf Research Plus P1000, Microbial" *)
						Model[Instrument, Pipette, "id:AEqRl9Ko8XWR"] (*"Eppendorf Research Plus P1000, Tissue Culture"*)
					]
			]
		],
		{
			mySamples,
			specifiedInstruments,
			modifiedSampleCellTypes,
			samplePackets,
			containerModelPackets,
			specifiedInoculationTips,
			specifiedVolumes,
			specifiedDestinationMediaContainers,
			specifiedMediaVolumes
		}
	];

	(* Extract the model packet for resolvedInstruments *)
	resolvedInstrumentModelPackets = Map[
		If[MatchQ[#, ObjectP[Object[Instrument]]],
			fastAssocPacketLookup[combinedFastAssoc, #, Model],
			fetchPacketFromFastAssoc[#, combinedFastAssoc]
		]&,
		resolvedInstruments
	];

	(* Resolve TransferEnvironment *)
	resolvedTransferEnvironments = MapThread[
		Which[
			(* If TransferEnvironment has been specified, use it *)
			MatchQ[#1, Except[Automatic]],
				#1,
			(* If Preparation->Robotic (or InoculationSource is SolidMedia which also should have robotic preparation), no TransferEnvironment *)
			MatchQ[resolvedPreparation, Robotic] || MatchQ[resolvedInoculationSource, SolidMedia],
				Null,
			(* Otherwise, select BSC based on cell type *)
			True,
				If[MatchQ[#2, MicrobialCellTypeP],
					Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"],(* Biosafety Cabinet Handling Station for Microbiology *)
					Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"] (* Biosafety Cabinet Handling Station for Tissue Culture *)
				]
		]&,
		{specifiedTransferEnvironments, modifiedSampleCellTypes}
	];

	(* Extract the model packet for resolvedInstruments *)
	resolvedTransferEnvironmentModelPackets = Map[
		If[MatchQ[#, ObjectP[Object[Instrument]]],
			fastAssocPacketLookup[combinedFastAssoc, #, Model],
			fetchPacketFromFastAssoc[#, combinedFastAssoc]
		]&,
		resolvedTransferEnvironments
	];

	(* Resolve SamplesInStorageCondition *)
	resolvedSamplesInStorageCondition = MapThread[
		Which[
			MatchQ[#, Except[Automatic]],
				#,
			MatchQ[resolvedInoculationSource, FreezeDried],
			(* For FreezeDried, sample comes in ampoule container, we are unable to recrimp the bottle so have to discard everything left *)
				Disposal,
			MatchQ[Lookup[#2, StorageCondition], ObjectP[]],
				(* Otherwise, grab the StorageCondition symbol from StorageCondition model *)
				fastAssocLookup[combinedFastAssoc, Lookup[#2, StorageCondition], StorageCondition],
			MatchQ[resolvedInoculationSource, FreezeDried],
			(* For SolidMedia, if no StorageCondition is found for the samples, resolve to Refrigerator which is the default in ExperimentPickColonies *)
				Refrigerator,
			True,
				Null
		]&,
		{specifiedSamplesInStorageCondition, samplePackets}
	];

	(* Adjust the email option based on the upload option *)
	resolvedEmail = If[!MatchQ[specifiedEmail, Automatic],
		specifiedEmail,
		upload && MemberQ[output, Result]
	];

	(* Get all of the user specified labels. *)
	userSpecifiedLabels = DeleteDuplicates@Cases[
		Flatten@Lookup[
			roundedInoculateLiquidMediaOptions,
			{SampleLabel, SampleContainerLabel, SampleOutLabel, ContainerOutLabel}
		],
		_String
	];

	(* Resolve SampleLabel *)
	(* The expected SampleLabel is a flat list index matching to mySamples *)
	resolvedSampleLabels = resolveInoculationLabel[
		mySamples,
		SampleLabel,
		Lookup[roundedInoculateLiquidMediaOptions, SampleLabel],
		Null,
		userSpecifiedLabels,
		currentSimulation,
		combinedFastAssoc
	];

	(* Resolve SampleContainerLabel *)
	(* The expected SampleContainerLabel is a flat list index matching to mySamples *)
	resolvedSampleContainerLabels = resolveInoculationLabel[
		mySamples,
		SampleContainerLabel,
		Lookup[roundedInoculateLiquidMediaOptions, SampleContainerLabel],
		Null,
		userSpecifiedLabels,
		currentSimulation,
		combinedFastAssoc
	];

	resolvedPostProcessingOptions = resolvePostProcessingOptions[Normal[roundedInoculateLiquidMediaOptions, Association], Living -> True];

	(* Get the resolved and semi-resolved options  *)
	resolvedGeneralOptions = ReplaceRule[
		Normal[roundedInoculateLiquidMediaOptions, Association],
		Join[
			resolvedPostProcessingOptions,
			{
				InoculationSource -> resolvedInoculationSource,
				PreparedModelAmount -> specifiedPreparedModelAmount,
				PreparedModelContainer -> specifiedPreparedModelContainer,
				PreparatoryUnitOperations -> specifiedPreparatoryUnitOperations,
				Preparation -> resolvedPreparation,
				WorkCell -> resolvedWorkCell,
				Instrument -> resolvedInstruments,
				TransferEnvironment -> resolvedTransferEnvironments,
				SamplesInStorageCondition -> resolvedSamplesInStorageCondition,
				SampleLabel -> resolvedSampleLabels,
				SampleContainerLabel -> resolvedSampleContainerLabels,
				Name -> specifiedName,
				Upload -> upload,
				Email -> resolvedEmail,
				Cache -> combinedCache,
				Simulation -> currentSimulation
			}
		]
	];

	(* -- CONFLICTING OPTIONS CHECKS I-- *)

	(* 1.) Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameInvalidBool = And[
		StringQ[specifiedName], Or[
			MatchQ[resolvedPreparation, Robotic] && TrueQ[DatabaseMemberQ[Append[Object[Protocol, RoboticCellPreparation], specifiedName]]],
			TrueQ[DatabaseMemberQ[Append[Object[Protocol, InoculateLiquidMedia], specifiedName]]]
		]
	];

	(* If the name is invalid, will add it to the list if invalid options later. *)
	nameInvalidOption = If[nameInvalidBool && messages,
		(
			Message[Error::DuplicateName, "InoculateLiquidMedia protocol"];
			{Name}
		),
		{}
	];
	nameInvalidTest = If[gatherTests,
		Test["The specified Name is unique:", False, nameInvalidBool],
		Nothing
	];

	(* 2.) If Preparation -> Robotic, WorkCell can't be Null. If Preparation -> Manual, WorkCell can't be specified *)
	conflictingWorkCellAndPreparationQ = Or[
		MatchQ[resolvedPreparation, Robotic] && NullQ[resolvedWorkCell],
		MatchQ[resolvedPreparation, Manual] && Not[NullQ[resolvedWorkCell]]
	];

	(* NOT throwing this message if we already thew Error::ConflictingIncubationWorkCells because if that message got thrown than our work cell is always Null and so this will always get thrown too *)
	conflictingWorkCellAndPreparationOptions = If[conflictingWorkCellAndPreparationQ && messages,
		Message[Error::ConflictingWorkCellWithPreparation, resolvedWorkCell, resolvedPreparation];
		{WorkCell, Preparation},
		{}
	];

	conflictingWorkCellAndPreparationTest = If[gatherTests,
		Test["If Preparation -> Robotic, WorkCell must not be Null. If Preparation -> Manual, WorkCell must not be specified:",
			conflictingWorkCellAndPreparationQ,
			False
		]
	];

	(* 3.) InvalidInstrument:multipleLH, non Liquid LH, pipette tipconnectiontype, *)
	invalidInstrumentErrors = {
		(* Check if we have a single robotic instrument across different samples *)
		If[And[
				MemberQ[resolvedInstruments, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler], Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
				Not[SameQ @@ resolvedInstruments]
			],
			{
				DeleteDuplicates@Cases[resolvedInstruments, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler], Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
				"different robotic instruments and only one robotic instrument is allowed per protocol"
			},
			Nothing
		],
		(* Check if we have non-liquid handling robotic instrument (such as pipette, or solid handling LH) *)
		If[MatchQ[resolvedInoculationSource, LiquidMedia] && MatchQ[resolvedPreparation, Robotic],
			Module[{invalidLHInstrumentModels},
				invalidLHInstrumentModels = MapThread[
					Which[
						MatchQ[#1, Except[ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]]],
							#1,
						And[
							MatchQ[#1, ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
							!MatchQ[Lookup[#2, LiquidHandlerType], LiquidHandling]
						],
							#1,
						True,
							Nothing
					]&,
					{resolvedInstruments, resolvedInstrumentModelPackets}
				];
				If[!MatchQ[invalidLHInstrumentModels, {}],
					{
						DeleteDuplicates@Download[invalidLHInstrumentModels, Object],
						"non liquid-handling robotic instruments"
					},
					Nothing
				]
			],
			Nothing
		],
		(* Check if we have pipette instrument setup with LiquidMedia for volume out of range *)
		If[MatchQ[resolvedInoculationSource, LiquidMedia] && MatchQ[resolvedPreparation, Manual],
			Module[{invalidInstruments},
				invalidInstruments = MapThread[
					If[And[
						MatchQ[#1, ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]],
						MatchQ[#3, VolumeP],
						LessQ[Lookup[#2, MaxVolume], #3]
					],
						#1,
						Nothing
					]&,
					{resolvedInstruments, resolvedInstrumentModelPackets, specifiedVolumes}
				];
				If[!MatchQ[invalidInstruments, {}],
					{
						DeleteDuplicates@invalidInstruments,
						"not suitable to aspirate the amount of LiquidMedia required with option Volume"
					},
					Nothing
				]
			],
			Nothing
		],
		(* Check if we have non-pipette instrument setup with AgarStab|FrozenGlycerol|FreezeDried or Manual LiquidMedia*)
		If[Or[
			MatchQ[resolvedInoculationSource, AgarStab|FrozenGlycerol|FreezeDried],
			MatchQ[resolvedInoculationSource, LiquidMedia] && MatchQ[resolvedPreparation, Manual]
			],
			Module[{invalidInstruments},
				invalidInstruments = MapThread[
					Which[
						(* Exclude ColonyHandler and LiquidHandler *)
						MatchQ[#1, Except[ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]]],
							#1,
						(* Exclude pipette with TipConnectionType other than the 6 types we allow *)
						!MatchQ[Lookup[#2, TipConnectionType], P10|P20|P200|P1000|P5000|Serological],
							#1,
						True,
							Nothing
					]&,
					{resolvedInstruments, resolvedInstrumentModelPackets}
				];
				If[!MatchQ[Cases[resolvedInstruments, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler], Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]], {}],
					{
						DeleteDuplicates@Cases[resolvedInstruments, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler], Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
						"not hand-held pipettes with TipConnectionType P10/P20/P200/P1000/P5000/Serological"
					},
					Nothing
				]
			],
			Nothing
		],
		(* Check if we have serological pipette instrument setup with FreezeDried *)
		If[MatchQ[resolvedInoculationSource, FreezeDried],
			Module[{uniquePipettes},
				uniquePipettes = DeleteDuplicates@PickList[resolvedInstruments, Lookup[resolvedInstrumentModelPackets, TipConnectionType], Serological];
				If[!MatchQ[uniquePipettes, {}],
					{
						uniquePipettes,
						"serological pipettes which are incompatible with ampoule container for freeze-dried samples"
					},
					Nothing
				]
			],
			Nothing
		],
		(* Check if instrument conflict with InoculationSource *)
		If[And[
			MatchQ[resolvedInoculationSource, SolidMedia],
			!MatchQ[Cases[resolvedInstruments, Except[ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}]]], {}]
		],
			{
				DeleteDuplicates@Cases[resolvedInstruments, Except[ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}]]],
				"not colony-handling instruments"
			},
			Nothing
		]
	};

	If[!MatchQ[invalidInstrumentErrors, {}] && messages,
		Module[{allInvalidInstruments},
			allInvalidInstruments = DeleteDuplicates@Flatten[invalidInstrumentErrors[[All, 1]]];
			Message[
				Error::InvalidInoculationInstrument,
				ObjectToString[allInvalidInstruments, Cache -> combinedCache, Simulation -> currentSimulation],
				resolvedInoculationSource,
				joinClauses@Map[
					StringJoin[
						ObjectToString[#[[1]], Cache -> combinedCache, Simulation -> currentSimulation],
						" are ",
						#[[2]]
					]&,
					invalidInstrumentErrors
				]
			]
		]
	];

	invalidInstrumentOptions = If[!MatchQ[invalidInstrumentErrors, {}] && messages,
		{InoculationSource, Instrument},
		{}
	];

	invalidInstrumentTests = If[gatherTests,
		Test["The input samples have a specified instrument that corresponds to InoculationSource:",
			MatchQ[invalidInstrumentErrors, {}],
			True
		],
		Nothing
	];

	(* 4.) Instrument-CellTypeIncompatibleErrors *)
	instrumentCellTypeIncompatibleErrors = MapThread[
		Function[{sample, instrument, instrumentModelPacket, cellType},
			Which[
				MatchQ[resolvedInoculationSource, LiquidMedia] && MatchQ[resolvedPreparation, Robotic],
					If[MatchQ[instrument, ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
						(* If instrument is LH, check if it is microbioSTAR for microbioSTAR or bioSTAR for mammalian *)
							Which[
								MatchQ[cellType, NonMicrobialCellTypeP] && !MatchQ[instrumentModelPacket, ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]]],(* bioSTAR *)
									{sample, cellType, instrument, {Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]}},
								MatchQ[cellType, MicrobialCellTypeP] && !MatchQ[instrumentModelPacket, ObjectP[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]], (* microbioSTAR *)
									{sample, cellType, instrument, {Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]}},
								(* For sample with Null CellType, can use either bioSTAR or microbioSTAR but not others LH *)
								NullQ[cellType] && !MatchQ[instrumentModelPacket, ObjectP[{Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]}]],
									{sample, cellType, instrument, {Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]}},
								True,
									Nothing
							],
							(* We do not check if the instrument is LH or not in this check, that was the last check for Error::InvalidInoculationInstrument *)
						Nothing
					],
			MatchQ[resolvedInoculationSource, SolidMedia],
				If[MatchQ[instrument, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}]],
					(* If instrument is QPIX, check if cell is Mammalian. It is okay if cell type is Null *)
					If[MatchQ[cellType, NonMicrobialCellTypeP],
						{sample, cellType, instrument, ""},
						Nothing
					],
					(* We do not check if the instrument is QPIX or not in this check, that was the last check for Error::InvalidInoculationInstrument *)
					Nothing
				],
			MatchQ[resolvedPreparation, Manual],
				Module[{cellTypeCompatiblePipettes},
					cellTypeCompatiblePipettes = Which[
						MatchQ[cellType, NonMicrobialCellTypeP], Lookup[Values@tipConnectionTypeLookup, NonMicrobial],
						MatchQ[cellType, MicrobialCellTypeP], Lookup[Values@tipConnectionTypeLookup, Microbial],
						(* For negative control without cell type, can use either TissueCulture Pipette or Microbial Pipette *)
						True, Flatten@Lookup[Values@tipConnectionTypeLookup, {Microbial, NonMicrobial}]
					];
					Which[
						(* We do not check if the instrument is Pipette or not in this check, that was the last check for Error::InvalidInoculationInstrument *)
						MatchQ[instrument, Except[ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]]],
							Nothing,
						MatchQ[cellType, NonMicrobialCellTypeP] && !MatchQ[Lookup[instrumentModelPacket, CultureHandling], NonMicrobial],
							{sample, cellType, instrument, cellTypeCompatiblePipettes},
						MatchQ[cellType, MicrobialCellTypeP] && !MatchQ[Lookup[instrumentModelPacket, CultureHandling], Microbial],
							{sample, cellType, instrument, cellTypeCompatiblePipettes},
						(* If the user specified aseptic transfer pipette, regardless of cell type, throw an error. *)
						NullQ[Lookup[instrumentModelPacket, CultureHandling]],
							{sample, cellType, instrument, cellTypeCompatiblePipettes},
						True,
							Nothing
					]
				],
				True,
					Nothing
			]
		],
		{mySamples, resolvedInstruments, resolvedInstrumentModelPackets, sampleCellTypes}
	];

	instrumentCellTypeIncompatibleOptions = If[!MatchQ[instrumentCellTypeIncompatibleErrors, {}] && messages,
		{Instrument},
		{}
	];

	If[!MatchQ[instrumentCellTypeIncompatibleErrors, {}] && messages,
		Module[{lastMessage},
			(* The guidance for user is different for SolidMedia case where simply updating Instrument option won't work as PickColonies is only applicable for microbial cells *)
			lastMessage = If[MatchQ[resolvedInoculationSource, SolidMedia],
				"Please verify and correct the cell type of " <> ObjectToString[instrumentCellTypeIncompatibleErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation] <> " to start a valid inoculation experiment from microbial colonies",
				(* Note:The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
				StringJoin[
					joinClauses[
						Map[
							("Please specify one of the compatible instruments " <> ObjectToString[#[[4]], Cache -> combinedCache, Simulation -> currentSimulation] <> " for CellType " <> ToString[#[[2]]])&,
							instrumentCellTypeIncompatibleErrors
						]
					],
					" or leave the Instrument option to be set automatically."
				]
			];
			Message[
				Error::IncompatibleInstrumentAndCellType,
				ObjectToString[instrumentCellTypeIncompatibleErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
				instrumentCellTypeIncompatibleErrors[[All, 2]],
				ObjectToString[instrumentCellTypeIncompatibleErrors[[All, 3]], Cache -> combinedCache, Simulation -> currentSimulation],
				lastMessage
			]
		]
	];

	instrumentCellTypeIncompatibleTests = If[gatherTests,
		Test["The input samples have a specified instrument that is compatible with the CellType:",
			MatchQ[instrumentCellTypeIncompatibleErrors, {}],
			True
		],
		Nothing
	];

	(* 5.) TransferEnvironment-CellTypeIncompatibleErrors *)
	bscCellTypeIncompatibleErrors = MapThread[
		Which[
			(*If user specified microbial culture BSC, but the cell type is mammalian, throw error *)
			MatchQ[#2, ObjectP[]] && MatchQ[Lookup[#3, CultureHandling], Microbial] && MatchQ[#4, NonMicrobialCellTypeP],
				{#1, #4, #2},
			(* If the user specified tissue culture BSC, and cell type is microbial, throw error *)
			MatchQ[#2, ObjectP[]] && MatchQ[Lookup[#3, CultureHandling], NonMicrobial] && MatchQ[#4, MicrobialCellTypeP],
				{#1, #4, #2},
			(* If the user specified aseptic transfer BSC, regardless of cell type, throw an error. *)
			MatchQ[#2, ObjectP[]] && NullQ[Lookup[#3, CultureHandling]],
				{#1, #4, #2},
			True,
				Nothing
		]&,
		{mySamples, resolvedTransferEnvironments, resolvedTransferEnvironmentModelPackets, sampleCellTypes}
	];

	bscCellTypeIncompatibleOptions = If[!MatchQ[bscCellTypeIncompatibleErrors, {}] && messages,
		{TransferEnvironment},
		{}
	];

	If[!MatchQ[bscCellTypeIncompatibleErrors, {}] && messages,
		Message[
			Error::IncompatibleBiosafetyCabinetAndCellType,
			ObjectToString[bscCellTypeIncompatibleErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
			bscCellTypeIncompatibleErrors[[All, 2]],
			ObjectToString[bscCellTypeIncompatibleErrors[[All, 3]], Cache -> combinedCache, Simulation -> currentSimulation]
		]
	];

	bscCellTypeIncompatibleTests = If[!MatchQ[bscCellTypeIncompatibleErrors, {}] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, bscCellTypeIncompatibleErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have cell type compatible with TransferEnvironment:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have cell type compatible with TransferEnvironment:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* -- Big Switch For Individual Inoculation Source Options-- *)

	(* Detect if there is any sort of error with InoculationSource - we cannot continue if there is  *)
	inoculationSourceError = Or[
		Length[multipleInoculationSourceInputs] > 0,
		Length[conflictingInoculationSourceErrorCases] > 0,
		Length[inoculationSourceOptionMismatchOptions] > 1,
		Length[invalidFrozenLiquidMediaInputs] > 0,
		Length[invalidModelSampleSourceInputs] > 0
	];

	(* Define our density to convert Mass to volume if necessary *)
	inoculationSourceDensity = Switch[resolvedInoculationSource,
		LiquidMedia, 0.997 Gram / Milliliter,
		AgarStab|SolidMedia, 1.03 Gram / Milliliter,
		FrozenGlycerol, 1.13 Gram / Milliliter,(*50% glycerol in water*)
		_, 1 Gram / Milliliter
	];

	(* Big main switch off of InoculationSource where we will call other option resolvers as necessary *)
	(* InvalidOptions calculated by InoculationSource specific functions (such as ExperimentPickColonies, ExperimentTransfer) is recorded in swithcInvalidOptions *)
	(* InvalidInputs calculated by InoculationSource specific functions (such as ExperimentPickColonies, ExperimentTransfer) is recorded in swithcInvalidInputs *)
	{
		(*1*)resolvedTotalOptions,
		(*2*)nullMismatchOptions,
		(*3*)switchInvalidOptions,
		(*4*)switchInvalidInputs,
		(* DestinationMedia related errors *)
		(*5*)noPreferredLiquidMediaWarnings,
		(*6*)nonLiquidDestinationMediaErrors,
		(*7*)overfillDestinationMediaContainerErrors,
		(*8*)invalidDestinationWellErrors,
		(*9*)multipleDestinationMediaContainersErrors,
		(*10*)destinationMixMismatchErrors,
		(* InoculationTips related errors *)
		(*11*)noTipsFoundErrors,
		(*12*)tipConnectionMismatchErrors,
		(* FreezeDried only errors *)
		(*13*)noPreferredResuspensionLiquidMediaWarnings,
		(*14*)invalidResuspensionMediaStateErrors,
		(*15*)resuspensionMediaOverfillErrors,
		(*16*)unusedFreezeDriedSampleErrors,
		(*17*)insufficientResuspensionMediaErrors,
		(*18*)resuspensionMixFalseWarnings,
		(*19*)resuspensionMixOptionsMismatchErrors
	} = Which[
		(* Call PickColonies resolver for SolidMedia branch *)
		MatchQ[resolvedInoculationSource, SolidMedia] && !inoculationSourceError,
			Module[
				{
					pickOptions, suppliedPickOptions, hiddenOptions, nonPickOptions,  defaultPickColoniesValues, nonNullValueRequiredOptions,
					pickColoniesOptionsToPass, invalidPickOptions, invalidPickInputs, presolvedPickColoniesOptions, presolvedPickColoniesTest,
					expandedPickColoniesOptions, postsolvedPickColoniesOptions, resolvedDestinationMixType, resolvedDestinationMixVolume,
					resolvedDestinationWell, solidMediaMixMismatchErrors, solidMediaNonLiquidMediaErrors, solidMediaAllResolvedOptions,
					solidMediaOverfillDestinationMediaContainerErrors, solidMediaNullMismatchOptions
				},

				(* Section: Pre-Process options (any specific defaults that Pick would not normally do or protocol options which we are specifying directly) *)
				(* Note:ExperimentPickColonies currently do have DestinationMixType|DestinationMixVolume|DestinationWell|SampleContainerLabel|SampleLabel which we will resolve them separately *)
				pickOptions = Cases[
					Join[$SolidMediaOptionSymbols, nonInoculationSpecificOptions],
					Except[InoculationSource|DestinationMixType|DestinationMixVolume|DestinationWell|SampleContainerLabel|SampleLabel|TransferEnvironment]
				];
				suppliedPickOptions = Select[
					resolvedGeneralOptions,
					MemberQ[
						pickOptions,
						First[#]
					]&
				];

				(* Gather the nonPick options and replace Automatic to Null *)
				(* Note: for DestinationMixVolume|DestinationWell they are technically not applicable to SolidMedia and should Nulls, *)
				(* but we still need to resolve them to expand as nested indexmatching options based on the values of Populations later *)
				hiddenOptions = DeleteDuplicates@Join[$InoculationTransferOptionSymbols, $LiquidMediaOptionSymbols, $FreezeDriedOptionSymbols, $FrozenGlycerolOptionSymbols, $AgarStabOptionSymbols];
				nonPickOptions = Select[
					resolvedGeneralOptions,
					MemberQ[
						hiddenOptions,
						First[#]
					]&
				]/.Automatic -> Null;

				(* The default values for AnalyzeColonies related options in ExperimentInoculateLiquidMedia *)
				defaultPickColoniesValues = <|
					MinDiameter -> 0.5 Millimeter,
					MaxDiameter -> 2 Millimeter,
					MinColonySeparation -> 0.2 Millimeter,
					MinRegularityRatio -> 0.65,
					MaxRegularityRatio -> 1.0,
					MinCircularityRatio -> 0.65,
					MaxCircularityRatio -> 1.0,
					ColonyPickingDepth -> 2 Millimeter,
					DestinationFillDirection -> Row
				|>;

				(* list of options have to be non-Null value for SolidMedia *)
				nonNullValueRequiredOptions = {
					PrimaryWash, SecondaryWash, TertiaryWash, QuaternaryWash,
					Populations, ColonyPickingTool, NumberOfHeads, ColonyPickingDepth, DestinationFillDirection,
					ImagingStrategies, ImagingChannels, ExposureTimes,
					DestinationMedia, MediaVolume, SamplesInStorageCondition
				};

				(* Update options to work with ExperimentPickColonies *)
				pickColoniesOptionsToPass = Map[
					Which[
						(* For options:MinRegularityRatio|MaxRegularityRatio|MinCircularityRatio|MaxCircularityRatio|MinDiameter|MaxDiameter|MinColonySeparation|ColonyPickingDepth|DestinationFillDirection *)
						(* they are not allowed to be Automatic by ExperimentPicColonies but allowed here *)
						(* We replace Automatic to default value before passing them on and use PickColonies *)
						MemberQ[Keys@defaultPickColoniesValues, Keys[#]],
							Keys[#] -> (Values[#]/.Automatic -> Lookup[defaultPickColoniesValues, Keys[#]]),
						(* Check if PrimaryWash value is valid since Null is not allowed in PickColonies and we default to True *)
						(* We change the value to valid value before passing it on and will change back to user specified value *)
						MatchQ[Keys[#], PrimaryWash],
							Keys[#] -> (Values[#]/.{Null -> False, Automatic -> True}),
						(* Check if Populations value is valid since Null is not allowed in PickColonies and it is index matching to other options *)
						(* We change the value to valid value and keeping the same length before passing it on and will change back to user specified value *)
						MatchQ[Keys[#], Populations],
							Keys[#] -> (Values[#]/.{Null -> All}),
						(* Check if SamplesInStorageCondition value is valid since Null is not allowed in PickColonies and we default to Refrigerator *)
						(* We change the value to valid value before passing it on and will change back to user specified value *)
						MatchQ[Keys[#], SamplesInStorageCondition],
							Keys[#] -> (Values[#]/.{Null -> Refrigerator}),
						(* For options:SecondaryWash|TertiaryWash|QuaternaryWash|ColonyPickingTool|NumberOfHeads|ColonyPickingDepth|ImagingStrategies|ExposureTimes|DestinationMedia *)
						(* they are not allowed to be Null by ExperimentPickColonies but allowed here *)
						(* We change the value to Automatic before passing them on and will change back to user specified value *)
						MemberQ[Cases[nonNullValueRequiredOptions, Except[PrimaryWash|Populations|SamplesInStorageCondition]], Keys[#]],
							Keys[#] -> (Values[#]/.Null -> Automatic),
						(* Instrument is not index-matching for PickColonies *)
						(* We change the value to a single value and will change back to user specified value *)
						MatchQ[#, Instrument -> _],
							Instrument -> Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"],
						(* Check if WorkCell, Preparation options are valid for PickColonies which only allows Robotic and qPix *)
						(* We change the value to valid values before passing them on and will change back to user specified value *)
						MatchQ[#, WorkCell -> Except[qPix]],
							WorkCell -> qPix,
						MatchQ[#, Preparation -> Except[Robotic]],
							Preparation -> Robotic,
						True,
							(* Keep other options as they are*)
							#
					]&,
					suppliedPickOptions
				];

				(* Pass options to PickColonies to resolve and check *)
				(* Call ModifyFunctionMessages to resolve the options and modify any messages. *)
				invalidPickOptions = {};
				invalidPickInputs = {};
				{presolvedPickColoniesOptions, presolvedPickColoniesTest} = If[gatherTests,
					ExperimentPickColonies[
						mySamples,
						Sequence @@ pickColoniesOptionsToPass,
						DestinationMediaType -> LiquidMedia,
						ColonyHandlerHeadCassetteApplication -> Pick,
						NumberOfReplicates -> Null,
						Cache -> combinedCache,
						Simulation -> currentSimulation,
						Output -> {Options, Tests}
					],
					{
						Module[{resolvedOptions, invalidOptionsBool},
							{resolvedOptions, invalidOptionsBool, invalidPickOptions, invalidPickInputs} = Quiet[
								ModifyFunctionMessages[
									ExperimentPickColonies,
									{mySamples},
									"The following message was thrown when calculating the pick colonies options for the following samples:" <> ObjectToString[mySamples, Cache -> combinedCache, Simulation -> currentSimulation] <> ". ",
									{},(* We do not need to replace option names since pickColoniesOptionsToPass has swapped names already *)
									Join[pickColoniesOptionsToPass, {DestinationMediaType -> LiquidMedia, ColonyHandlerHeadCassetteApplication -> Pick, NumberOfReplicates -> Null, Upload -> False, Output -> Options}],
									Cache -> combinedCache,
									Simulation -> currentSimulation,
									Output -> {Result, Boolean, InvalidOptions, InvalidInputs}
								],
								(* Quiet the error since we either have thrown them when resolve general options or will throw soon *)
								{Download::MissingCacheField, Error::DiscardedSamples, Error::DeprecatedModels, Error::DestinationMixMismatch, Error::DestinationMediaTypeMismatch}
							];

							(* Only pick invalid options from our lists of options *)
							invalidPickOptions = Cases[invalidPickOptions, Alternatives@@pickOptions];
							(* Return the options *)
							resolvedOptions
						],
						{}
					}
				];

				(* Expand presolvedPickColoniesOptions since options might have collapsed *)
				(* Note:SampleOutLabel, ContainerOutLabel should not be expanded again *)
				(* And be smart of expanding ImageStrategies and ExposureTimes *)
				expandedPickColoniesOptions = Module[
					{
						pickResolvedImagingStrategies, pickResolvedExposureTimes, reExpandedImagingStrategies, reExpandedExposureTimes,
						strategiesMappingToChannels, pickResolvedSampleOutLabel, pickResolvedContainerOutLabel
					},

					(* Note: the pick options resolved from ExperimentPickColonies might have collapsed already, expand it again here *)
					pickResolvedImagingStrategies = Lookup[presolvedPickColoniesOptions, ImagingStrategies];
					pickResolvedExposureTimes = Lookup[presolvedPickColoniesOptions, ExposureTimes];

					reExpandedImagingStrategies = Which[
						MatchQ[pickResolvedImagingStrategies, BrightField],
							(* If a singleton value is given and collapsed *)
							ConstantArray[pickResolvedImagingStrategies, Length[mySamples]],
						MatchQ[pickResolvedImagingStrategies, {BrightField..}] && EqualQ[Length[pickResolvedImagingStrategies], Length@mySamples],
							(* If a singleton value is given and not collapsed *)
							pickResolvedImagingStrategies,
						MatchQ[pickResolvedImagingStrategies, _List] && !MemberQ[pickResolvedImagingStrategies, _List],
							(* If it is a list and collapsed *)
							ConstantArray[pickResolvedImagingStrategies, Length[mySamples]],
						True,
							(* If a list of values or a mix of list and singleton *)
							pickResolvedImagingStrategies
					];

					reExpandedExposureTimes = Which[
						MatchQ[pickResolvedExposureTimes, Automatic | _Real],
						(* If a singleton value is given and collapsed *)
							Map[If[MatchQ[#, _List], ConstantArray[pickResolvedExposureTimes, Length[#]], pickResolvedExposureTimes]&, reExpandedImagingStrategies],
						And[
							MatchQ[pickResolvedExposureTimes, {(Automatic | _Real)..}],
							MatchQ[reExpandedImagingStrategies, {BrightField..}],
							EqualQ[Length[pickResolvedExposureTimes], Length@mySamples]
						],
							(* If a singleton value is given and not collapsed *)
							pickResolvedExposureTimes,
						MatchQ[pickResolvedExposureTimes, _List] && !MemberQ[pickResolvedExposureTimes, _List],
							(* If it is a list and collapsed *)
							ConstantArray[pickResolvedExposureTimes, Length[mySamples]],
						True,
							(* If a list of values or a mix of list and singleton *)
							pickResolvedExposureTimes
					];
					(* Lookup table for each imaging strategy what imaging channel it is corresponding to *)
					(* We need this since ImagingChannels is hidden option of PickColonies and does not get returned *)
					strategiesMappingToChannels = {
						BlueWhiteScreen -> 400 Nanometer,
						VioletFluorescence -> {377 Nanometer, 447 Nanometer},
						GreenFluorescence -> {457 Nanometer, 536 Nanometer},
						OrangeFluorescence -> {531 Nanometer, 593 Nanometer},
						RedFluorescence -> {531 Nanometer, 624 Nanometer},
						DarkRedFluorescence -> {628 Nanometer, 692 Nanometer}
					};

					(* Currently when there is a Population error, ExperimentPickColonies skip resolving SampleOutLabel/ContainerOutLabel and return {{{}}}. *)
					(* Since ExpandIndexMatchedInputs check the option pattern, expansion will fail with Error::ValueDoesNotMatchPattern. *)
					(* To be more robust about population failure, we drop them before expansion and add them back *)
					{pickResolvedSampleOutLabel, pickResolvedContainerOutLabel} = Lookup[presolvedPickColoniesOptions, {SampleOutLabel, ContainerOutLabel}];

					(* Return the expanded options *)
					Join[
						Last@ExpandIndexMatchedInputs[
							ExperimentPickColonies,
							{mySamples},
							Normal[KeyDrop[presolvedPickColoniesOptions, {ImagingStrategies, ImagingChannels, ExposureTimes, SampleOutLabel, ContainerOutLabel}], Association]
						],
						{
							ImagingStrategies -> reExpandedImagingStrategies,
							ImagingChannels -> reExpandedImagingStrategies/.strategiesMappingToChannels,
							ExposureTimes -> reExpandedExposureTimes,
							SampleOutLabel -> pickResolvedSampleOutLabel,
							ContainerOutLabel -> pickResolvedContainerOutLabel
						}
					]
				];

				(* Extract relevant options back to original name and value if necessary *)
				postsolvedPickColoniesOptions = Map[
					Which[
						(* For option DestinationMedia and MediaVolume, they are both nestedIndexmatching options and nonNullValueRequiredOptions *)
						(* If specified value contains Null, we still need to expand them as nested indexed Null instead of using them directly *)
						MatchQ[Keys[#], DestinationMedia|MediaVolume] && MemberQ[Flatten@Values[#], Null],
							Module[{updatedValues},
								(* ResolvedValues should be 3-level list *)
								updatedValues = MapThread[
									Function[{specifiedUnexpandedValue, expandedResolvedValue},
										If[EqualQ[Length[specifiedUnexpandedValue], Length[expandedResolvedValue]],
											(* No need to expand if resolved values are the same length as input values. Just swap Null position back *)
											MapThread[If[NullQ[#1], #1, #2]&, {specifiedUnexpandedValue, expandedResolvedValue}],
											(* Replace non-Null value to Null but keep the expanded format *)
											expandedResolvedValue/.{ObjectP[] -> Null, VolumeP -> Null}
										]
									],
									{Values[#], Lookup[expandedPickColoniesOptions, Keys[#]]}
								];
								Keys[#] -> updatedValues
							],
						(* For other options which were specified as Null and we replaced to non-Null value, replace back to Null if they were specified *)
						MemberQ[nonNullValueRequiredOptions, Keys[#]] && NullQ[Values[#]],
							Keys[#] -> Values[#],
						(* For options:Instrument|WorkCell|Preparation|SamplesInStorageCondition, replace back to previous values *)
						MatchQ[Keys[#], Instrument|WorkCell|Preparation|SamplesInStorageCondition],
							Keys[#] -> Values[#],
						True,
							Keys[#] -> Lookup[expandedPickColoniesOptions, Keys[#]]
					]&,
					suppliedPickOptions
				];

				(* Note: since DestinationMixType/DestinationMixVolume/DestinationWell are also nested indexmaching to populations, we need to make sure the value gets expanded the same way as DestinationMix *)
				{resolvedDestinationMixType, resolvedDestinationMixVolume, resolvedDestinationWell, solidMediaMixMismatchErrors} = Transpose@MapThread[
					Function[{resoledDestinationMix, specifiedMixType, specifiedMixVolume, specifiedWell, resolvedDestinationNumberOfMixes, sample},
						Module[{expandedMixType, expandedMixVolume, expandedWell, errorOptions},
							(* Resolve DestinationMixType on our own based on resolved pick options which is an option for ExperimentInoculateLiquidMedia but not ExperimentPickColonies *)
							expandedMixType = Which[
								ListQ[specifiedMixType] && !MemberQ[specifiedMixType, Automatic] && Length[resoledDestinationMix] == Length[specifiedMixType],
									specifiedMixType,
								ListQ[specifiedMixType] && Length[resoledDestinationMix] == Length[specifiedMixType],
									MapThread[
										Which[
											MatchQ[#1, Except[Automatic]], #1,
											MatchQ[#2, True], Shake,
											True, Null
										]&,
										{specifiedMixType, resoledDestinationMix}
									],
								True,
									resoledDestinationMix/.{True->Shake, False->Null}
							];
							(* Resolve DestinationMixVolume on our own and null it if it is automatic *)
							expandedMixVolume = Which[
								ListQ[specifiedMixVolume] && !MemberQ[specifiedMixVolume, Automatic] && Length[resoledDestinationMix] == Length[specifiedMixVolume],
									specifiedMixVolume,
								ListQ[specifiedMixVolume] && Length[resoledDestinationMix] == Length[specifiedMixVolume],
									Map[
										If[MatchQ[#, Except[Automatic]],
											#,
											Null
										]&,
										specifiedMixVolume
									],
								True,
									resoledDestinationMix/. Automatic -> Null
							];
							(* Resolve DestinationWell on our own since ExperimentPickColonies does not support DestinationWell currently *)
							(* If ExperimentPickColonies includes DestinationWell in the future, we should remove this block and use postsolvedPickColoniesOptions *)
							expandedWell = Which[
								ListQ[specifiedWell] && !MemberQ[specifiedWell, Automatic] && Length[resoledDestinationMix] == Length[specifiedWell],
									specifiedWell,
								ListQ[specifiedWell] && Length[resoledDestinationMix] == Length[specifiedWell],
									Map[
										If[MatchQ[#, Except[Automatic]],
											#,
											Null
										]&,
										specifiedWell
									],
								True,
									resoledDestinationMix/. Automatic -> Null
							];

							(* Check if any specified DestinationMix options are mixmatched *)
							errorOptions = Flatten@Join[MapThread[
								{
									If[MatchQ[#1, True] && NullQ[#2], DestinationMixType, Nothing],
									If[MatchQ[#1, True] && NullQ[#5], DestinationNumberOfMixes, Nothing],
									If[MatchQ[#1, False] && !NullQ[#2], DestinationMixType, Nothing],
									If[MatchQ[#1, False] && MatchQ[#5, _Integer], DestinationNumberOfMixes, Nothing]
								}&,
								{resoledDestinationMix, expandedMixType, expandedMixVolume, expandedWell, resolvedDestinationNumberOfMixes}
							]];

							{expandedMixType, expandedMixVolume, expandedWell, If[MatchQ[errorOptions, {}], {}, {sample, DeleteDuplicates[errorOptions]}]}
						]
					],
					{
						Lookup[postsolvedPickColoniesOptions, DestinationMix],
						Lookup[resolvedGeneralOptions, DestinationMixType],
						Lookup[resolvedGeneralOptions, DestinationMixVolume],
						Lookup[resolvedGeneralOptions, DestinationWell],
						Lookup[postsolvedPickColoniesOptions, DestinationNumberOfMixes],
						mySamples
					}
				];

				(* Check if any specified DestinationMedia is not liquid *)
				(* Note: if DestinationMedia is Automatic, we resolve with PreferredLiquidMedia field which guarantee the media is liquid *)
				solidMediaNonLiquidMediaErrors = MapThread[
					Function[{specifiedMedia, resolvedDestinationMedia},
						Module[{mediaPackets, nonLiquidMedia},
							mediaPackets = fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ Cases[Flatten[resolvedDestinationMedia], ObjectP[]];
							nonLiquidMedia = Lookup[Cases[mediaPackets, KeyValuePattern[{State -> Except[Liquid]}]], Object];
							!MatchQ[nonLiquidMedia, {}] && MemberQ[Flatten@specifiedMedia, ObjectP[nonLiquidMedia]]
						]
					],
					{Lookup[suppliedPickOptions, DestinationMedia], Lookup[postsolvedPickColoniesOptions, DestinationMedia]}
				];

				(* Check if any specified DestinationMedia is overfilled *)
				(* Note:ExperimentPickColonies should check this but it is not currently. *)
				(* If in the future we add it in PickColonies, need to silence the error in ModifyFunctionMessages above *)
				solidMediaOverfillDestinationMediaContainerErrors = Flatten[MapThread[
					Function[{sample, resolvedDestinationMediaContainers, resolvedMediaVolumes},
						(* DestinationMediaContainer and MediaVolume can either be 2-level list or 3-level list *)
						MapThread[
							Function[{innerDestinationMediaContainers, innerMediaVolumes},
								If[!ListQ[innerDestinationMediaContainers] && !ListQ[innerMediaVolumes],
									(* Both DestinationMediaContainer and MediaVolume are 2-level list *)
									Module[{destinationContainerModelPacket, containerMaxVol},
										destinationContainerModelPacket = If[MatchQ[innerDestinationMediaContainers, ObjectP[Object]],
											fastAssocPacketLookup[combinedFastAssoc, innerDestinationMediaContainers, Model],
											fetchPacketFromFastAssoc[innerDestinationMediaContainers, combinedFastAssoc]
										];
										containerMaxVol = Lookup[destinationContainerModelPacket, MaxVolume, 0 Microliter];
										If[GreaterQ[innerMediaVolumes/.Null -> 0 Microliter, containerMaxVol],
											{sample, innerDestinationMediaContainers, innerMediaVolumes},
											Nothing
										]
									],
									(* Either DestinationMediaContainer and MediaVolume is 3-level list *)
									MapThread[
										Module[{destinationContainerModelPacket, containerMaxVol},
											destinationContainerModelPacket = If[MatchQ[#1, ObjectP[Object]],
												fastAssocPacketLookup[combinedFastAssoc, #1, Model],
												fetchPacketFromFastAssoc[#1, combinedFastAssoc]
											];
											containerMaxVol = Lookup[destinationContainerModelPacket, MaxVolume, 0 Microliter];
											If[GreaterQ[#2/.Null -> 0 Microliter, containerMaxVol],
												{sample, #1, #2},
												Nothing
											]
										]&,
										{
											If[!ListQ[innerDestinationMediaContainers],  ConstantArray[innerDestinationMediaContainers, Length[innerMediaVolumes]], innerDestinationMediaContainers],
											If[!ListQ[innerMediaVolumes], ConstantArray[innerMediaVolumes, Length[innerDestinationMediaContainers]], innerMediaVolumes]
										}
									]
								]
							],
							{resolvedDestinationMediaContainers, resolvedMediaVolumes}
						]
					],
					{mySamples, Lookup[postsolvedPickColoniesOptions, DestinationMediaContainer], Lookup[postsolvedPickColoniesOptions, MediaVolume]}
				], 1];

				(* Combine all resolved options. At this point, all options are correctly nested indexmatching *)
				solidMediaAllResolvedOptions = ReplaceRule[
					resolvedGeneralOptions,
					Join[
						postsolvedPickColoniesOptions,
						nonPickOptions,
						{
							DestinationMixType -> resolvedDestinationMixType,
							DestinationMixVolume -> resolvedDestinationMixVolume,
							DestinationWell -> resolvedDestinationWell
						}
					]
				];

				(* Check if any position in nonNullValueRequiredOptions value is Null *)
				solidMediaNullMismatchOptions = PickList[
					nonNullValueRequiredOptions,
					MemberQ[Flatten@ToList[Lookup[solidMediaAllResolvedOptions, #]], Null]& /@ nonNullValueRequiredOptions,
					True
				];

				(* Section: Post-Process options (combine newly resolved and those set to Null) and return *)
				{
					(*1*)solidMediaAllResolvedOptions,
					(*2*)solidMediaNullMismatchOptions,
					(*3*)invalidPickOptions,
					(*4*)invalidPickInputs,
					(* DestinationMedia related errors, mostly already thrown by ExperimentPickColonies *)
					(*5*)ConstantArray[False, Length[mySamples]],
					(*6*)solidMediaNonLiquidMediaErrors,
					(*7*)DeleteCases[solidMediaOverfillDestinationMediaContainerErrors, {}],
					(*8*)ConstantArray[False, Length[mySamples]],
					(*9*)ConstantArray[False, Length[mySamples]],
					(*10*)DeleteCases[solidMediaMixMismatchErrors, {}],
					(* InoculationTips related errors *)
					(*11*)ConstantArray[False, Length[mySamples]],
					(*12*)ConstantArray[False, Length[mySamples]],
					(* FreezeDried only errors *)
					(*13*)ConstantArray[False, Length[mySamples]],
					(*14*)ConstantArray[False, Length[mySamples]],
					(*15*){},
					(*16*){},
					(*17*){},
					(*18*)ConstantArray[False, Length[mySamples]],
					(*19*)ConstantArray[False, Length[mySamples]]
				}
			],
		(* Call Transfer resolver for LiquidMedia branch and Correct Nesting options *)
		MatchQ[resolvedInoculationSource, LiquidMedia] && !inoculationSourceError,
			Module[
				{
					liquidMediaMultipleDestinationErrors, flattenedDestinationOptions, liquidMediaMapThreadFriendlyOptions,
					flattenedGeneralOptions, transferOptions, suppliedFlattenedTransferOptions, hiddenOptions, nonTransferOptions,
					optionRenamingRules, nonNullValueRequiredOptions, sampleVolumes, resolvedVolumes, resolvedAmountsForExperimentTransfer,
					liquidMediaNoPreferredLiquidMediaWarnings, liquidMediaNonLiquidMediaErrors, liquidMediaOverfillMediaErrors,
					liquidMediaMixMismatchErrors, preResolvedDestinationMediaContainers, resolvedSourceMixes, resolvedSourceMixTypes,
					preResolvedDestinationOptions, preResolvedDestinationMedium, preResolvedMediaVolumes, preResolvedTips, updatedTransferOptions,
					transferOptionsToPass, invalidTransferOptions, invalidTransferInputs, transferOutput, transferTests,
					expandedTransferOptions, postsolvedTransferOptions, liquidMediaNullMismatchOptions, liquidMediaFullyNestedOptions,
					liquidMediaResolvedOptions
				},

				(* Section: Unnest and flatten DestinationMedia related options and check error *)
				(* Note:we define destination related options as nested indexmatching for SolidMedia with potential multiple populations. *)
				(* For LiquidMedia, all those options should be a list of 1 value otherwise we throw error *)
				(* Example conversion:{s1,s2} has fully-nested options{{{1 Milliliter}},{{2 Milliliter}}} to {1 Milliliter, 2 Milliliter}, *)
				(* or not-fullynested options {{Automatic},{Automatic}} to {Automatic,Automatic} *)
				(* We will re-nest options and swap back to user-specified wrongly multiple destination option values after resolving all transfer options *)
				flattenedDestinationOptions = Map[
					Function[{option},
						Module[{unnestedValue},
							unnestedValue = Map[
								Which[
									!ListQ[#], #,
									!MemberQ[#, _List], #[[1]],
									True, First[#[[1]]]
								]&,
								Lookup[resolvedGeneralOptions, option]
							];
							(* Combine the value and error *)
							option -> unnestedValue
						]
					],
					nestedIndexMatchingOptions
				];

				flattenedGeneralOptions = ReplaceRule[resolvedGeneralOptions, flattenedDestinationOptions];

				liquidMediaMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
					ExperimentInoculateLiquidMedia,
					flattenedGeneralOptions,
					AmbiguousNestedResolution -> IndexMatchingOptionPreferred
				];

				(* Section: Pre-Process options (any specific defaults that Transfer uses as Input instead of Options or protocol options which we are specifying directly) *)
				transferOptions = Cases[
					Join[$LiquidMediaOptionSymbols, nonInoculationSpecificOptions],
					Except[InoculationSource|Volume|DestinationMediaContainer|DestinationMedia|MediaVolume]
				];
				suppliedFlattenedTransferOptions = Select[
					flattenedGeneralOptions,
					MemberQ[
						transferOptions,
						First[#]
					]&
				];

				(* Gather the non transfer options and replace Automatic to Null *)
				(* Note:whether the hidden options are nested or not do not matter since NullQ works on list of list of Null *)
				hiddenOptions = Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $FreezeDriedOptionSymbols, $FrozenGlycerolOptionSymbols, $AgarStabOptionSymbols], $LiquidMediaOptionSymbols];
				nonTransferOptions = Select[
					resolvedGeneralOptions,
					MemberQ[
						hiddenOptions,
						First[#]
					]&
				]/.Automatic -> Null;

				(* Create a list of rules to map from the namespace of InoculateLiquidMedia to the namespace of Transfer *)
				optionRenamingRules = {
					InoculationTips -> Tips,
					InoculationTipType -> TipType,
					InoculationTipMaterial -> TipMaterial,
					DestinationMix -> DispenseMix,
					DestinationMixType -> DispenseMixType,
					DestinationNumberOfMixes -> NumberOfDispenseMixes,
					DestinationMixVolume -> DispenseMixVolume,
					SourceMix -> AspirationMix,
					SourceMixType -> AspirationMixType,
					NumberOfSourceMixes -> NumberOfAspirationMixes,
					SourceMixVolume -> AspirationMixVolume,
					SampleLabel -> SourceLabel,
					SampleContainerLabel -> SourceContainerLabel,
					SampleOutLabel -> DestinationLabel,
					ContainerOutLabel -> DestinationContainerLabel
				};

				(* list of options have to be non-Null value for LiquidMedia *)
				nonNullValueRequiredOptions = {
					Volume, MediaVolume, DestinationMedia, DestinationWell, SourceMix
				};

				(* Get the source Volume *)
				sampleVolumes = Map[
					If[MatchQ[Lookup[#, Volume], VolumeP],
						Lookup[#, Volume],
						(* Otherwise look up the mass and convert *)
						Lookup[#, Mass] / inoculationSourceDensity
					]&,
					samplePackets
				];

				(* Resolve Volume option *)
				resolvedVolumes = MapThread[
					Function[{volume, destinationMediaContainer, sampleVolume},
						(* If the option is specified, keep it *)
						Which[
							MatchQ[volume, Except[Automatic]],
								volume,
							NullQ[sampleVolume],
								Null,
							LessQ[sampleVolume, 10 Microliter],
								All,
							MatchQ[destinationMediaContainer, ObjectP[]],
								Module[{maxVolume},
									maxVolume = If[MatchQ[destinationMediaContainer, ObjectP[Object]],
										fastAssocLookup[combinedFastAssoc, destinationMediaContainer, {Model, MaxVolume}],
										fastAssocLookup[combinedFastAssoc, destinationMediaContainer, MaxVolume]
									];
									(* If the option is automatic, resolve it to 1/10th of the volume of the input sample or 1/12th of the destination container max vol *)
									Min[
										SafeRound[maxVolume/12, 10^-1*Microliter],
										SafeRound[sampleVolume/10, 10^-1*Microliter]
									]
								],
							True,
								(* If the option is automatic, resolve it to 1/10th of the volume of the input sample or 1 ml whichever is smaller *)
								Min[
									1 Milliliter,
									SafeRound[sampleVolume/10, 10^-1*Microliter]
								]
						]
					],
					{Lookup[liquidMediaMapThreadFriendlyOptions, Volume], Lookup[liquidMediaMapThreadFriendlyOptions, DestinationMediaContainer], sampleVolumes}
				];

				(* Resolve Amount input for ExperimentTransfer *)
				(* Remove all Null in volumes since ExperimentTransfer does not allow Null as Amounts pattern *)
				resolvedAmountsForExperimentTransfer = Map[
					Function[{volume},
						If[NullQ[volume],
							(* If the option is Null, convert to 1 Microliter *)
							1 Microliter,
							(* If the option is already VolumeP or All, keep it *)
							volume
						]
					],
					resolvedVolumes
				];

				(* Resolve Media Preparation, SourceMix and Label options *)
				{
					(* Error tracking *)
					(*1*)liquidMediaNoPreferredLiquidMediaWarnings,
					(*2*)liquidMediaNonLiquidMediaErrors,
					(*3*)liquidMediaOverfillMediaErrors,
					(*4*)liquidMediaMixMismatchErrors,
					(* Options *)
					(*5*)preResolvedDestinationMediaContainers,
					(*6*)resolvedSourceMixes,
					(*7*)resolvedSourceMixTypes,
					(*8*)preResolvedDestinationOptions,
					(*9*)preResolvedDestinationMedium,
					(*10*)preResolvedMediaVolumes,
					(*11*)preResolvedTips
				} = Transpose@MapThread[
					Function[{sample, mapThreadOptions, cellType, volume, sampleVolume},
						Module[
							{
								destinationMediaContainer, destinationMix, destinationMixType, destinationNumberOfMixes, destinationMixVolume,
								sourceMix, sourceMixType, destinationMedia, mediaVolume, convertedVolume, resolvedUnnestedDestinationMediaContainer,
								resolvedSourceMix, resolvedSourceMixType, preResolvedTip, resolvedUnnestedDestinationOptions,
								noPreferredLiquidMediaWarning, nonLiquidMediaError, overfillMediaError, mixMismatchOption,
								resolvedUnnestedDestinationMedia, resolvedUnnestedMediaVolume
							},

							(* Extract the necessary options *)
							(* Note:all those values should be a singleton since we have stripped nested list from them *)
							{
								destinationMediaContainer,
								destinationMix,
								destinationMixType,
								destinationNumberOfMixes,
								destinationMixVolume,
								sourceMix,
								sourceMixType,
								destinationMedia,
								mediaVolume
							} = Lookup[mapThreadOptions,
								{
									DestinationMediaContainer,
									DestinationMix,
									DestinationMixType,
									DestinationNumberOfMixes,
									DestinationMixVolume,
									SourceMix,
									SourceMixType,
									DestinationMedia,
									MediaVolume
								}
							];

							(* Convert Volume to VolumeP *)
							convertedVolume = If[MatchQ[volume, All],
								(* Replace expression in volume to quantity *)
								sampleVolume/.Null -> 1 Microliter,
								volume
							];

							(* Pre-resolve DestinationMediaContainer *)
							resolvedUnnestedDestinationMediaContainer = Which[
								MatchQ[destinationMediaContainer, Automatic] && MatchQ[resolvedPreparation, Manual],
								(* If DestinationMediaContainer is Automatic, resolve based on the PreferredContainer of the MediaVolume being transferred.*)
								(* For manual preparation, use the first model given by PreferredContainer, or default to "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap" *)
									Which[
										MatchQ[mediaVolume, Automatic] && LessQ[convertedVolume, 1.2 Milliliter],
											(* If mediaVolume is also Automatic, default to "Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap" if volume is less than 1.2ml *)
											(* 1.2ml is calculated as 0.5*14ml/6. We aim to fill 50% of the vessel, sample and fresh media vol is 1vs5 *)
											Model[Container, Vessel, "id:AEqRl9KXBDoW"],
										MatchQ[mediaVolume, Automatic],
											(* Usually we mix cell with media with ratio 1:5 *)
											FirstOrDefault[ToList[Quiet[
												PreferredContainer[6*convertedVolume, (CellType -> cellType/.Null->Automatic), Sterile -> True],
												PreferredContainer::ContainerNotFound
											]]]/. {$Failed -> Model[Container, Vessel, "id:AEqRl9KXBDoW"]},
										(* Otherwise use PreferredContainer[mediaVolume] to get a container that fits. Make sure the container is Sterile *)
										True,
											FirstOrDefault[ToList[Quiet[
												PreferredContainer[(mediaVolume/.Null->0 Microliter) + convertedVolume, (CellType -> cellType/.Null->Automatic), Sterile -> True],
												PreferredContainer::ContainerNotFound
											]]]/. {$Failed -> Model[Container, Vessel, "id:AEqRl9KXBDoW"]}
									],
								MatchQ[destinationMediaContainer, Automatic],
									(* DestinationMediaContainer is Automatic, for robotic preparation, use the first model given by PreferredContainer or default to "24-well Round Bottom Deep Well Plate, Sterile" *)
									(* Since only SBS plate or 14ml tube and cell culture flasks are allowed for IncubateCells, limit to only plate for destination container here as  14ml tube and cell culture flasks are not liquidhandler compatible *)
									Which[
										MatchQ[mediaVolume, Automatic] && LessQ[convertedVolume, 1 Milliliter],
											(* If mediaVolume is also Automatic and less than 1ml, default to 10ml 24-well plate *)
											Model[Container, Plate, "id:jLq9jXY4kkMq"],(* "24-well Round Bottom Deep Well Plate, Sterile" *)
										MatchQ[mediaVolume, Automatic],
											(* Usually we mix cell with media with ratio 1:5 *)
											FirstOrDefault[ToList[Quiet[
												PreferredContainer[6*convertedVolume, Type -> Plate, LiquidHandlerCompatible -> True, Sterile -> True],
												PreferredContainer::ContainerNotFound
											]]]/. {$Failed -> Model[Container, Plate, "id:jLq9jXY4kkMq"]},
									(* Otherwise use PreferredContainer[mediaVolume] to get a container that fits *)
										True,
											FirstOrDefault[ToList[Quiet[
												PreferredContainer[(mediaVolume/.Null->0 Microliter) + convertedVolume, Type -> Plate, (CellType -> cellType/.Null->Automatic), Sterile -> True],
												PreferredContainer::ContainerNotFound
											]]]/. {$Failed -> Model[Container, Plate, "id:jLq9jXY4kkMq"]}
										],
								True,
									(* Otherwise leave it as is *)
									destinationMediaContainer
							];

							(* Pre-resolve SourceMix *)
							resolvedSourceMix = If[MatchQ[sourceMix, Automatic],
								(* If SourceMix is Automatic, pre resolve it to True *)
								True,
								(* Otherwise leave it as is *)
								sourceMix
							];

							resolvedSourceMixType = Which[
								MatchQ[sourceMixType, Except[Automatic]],
									sourceMixType,
								TrueQ[resolvedSourceMix],
									Pipette,
								True,
									Null
							];

							(* If the instrument is specified as a pipette, resolve the tips by calling the helper function *)
							(* If preparation is robotic, keep Automatic if not specified and let ExperimentTransfer resolve for us *)
							preResolvedTip = If[MatchQ[resolvedPreparation, Manual],
								First@resolveInoculationTipWithGivenInstrument[
									sample,
									Lookup[mapThreadOptions, InoculationTips],
									Lookup[mapThreadOptions, Instrument],
									Automatic,
									Automatic,
									sampleVolume,
									resolvedUnnestedDestinationMediaContainer,
									Lookup[mapThreadOptions, DestinationMixType],
									LiquidMedia,
									combinedFastAssoc
								],
								Lookup[mapThreadOptions, InoculationTips]
							];

							(* Resolve nested version of DestinationMedia and MediaVolume options by calling the helper. the helper returns many other options and *)
							(* error checking variables, but we only care about these 2 options. Error checking will be conducted by ExperimentTransfer*)
							{
								resolvedUnnestedDestinationOptions,
								noPreferredLiquidMediaWarning,
								nonLiquidMediaError,
								overfillMediaError,
								mixMismatchOption
							} = resolveInoculationDestinationOptions[
								sample,
								{
									DestinationMedia -> destinationMedia,
									MediaVolume -> mediaVolume,
									DestinationMix -> destinationMix,
									DestinationMixType -> destinationMixType,
									DestinationNumberOfMixes -> destinationNumberOfMixes,
									DestinationMixVolume -> destinationMixVolume
								},
								resolvedUnnestedDestinationMediaContainer,
								preResolvedTip,
								convertedVolume,
								destinationMedia,
								combinedFastAssoc
							];

							(* Option DestinationMedia and MediaVolume are not options for ExperimentTransfer, return them separately *)
							resolvedUnnestedDestinationMedia = Lookup[resolvedUnnestedDestinationOptions, DestinationMedia];
							resolvedUnnestedMediaVolume = Lookup[resolvedUnnestedDestinationOptions, MediaVolume];

							(* Return resolved options *)
							{
								(*1*)noPreferredLiquidMediaWarning,
								(*2*)nonLiquidMediaError,
								(*3*)overfillMediaError,
								(*4*)mixMismatchOption,
								(* Options *)
								(*5*)resolvedUnnestedDestinationMediaContainer,
								(*6*)resolvedSourceMix,
								(*7*)resolvedSourceMixType,
								(*8*)resolvedUnnestedDestinationOptions,
								(*9*)resolvedUnnestedDestinationMedia,
								(*10*)resolvedUnnestedMediaVolume,
								(*11*)preResolvedTip
							}
						]
					],
					{mySamples, liquidMediaMapThreadFriendlyOptions, modifiedSampleCellTypes, resolvedAmountsForExperimentTransfer, sampleVolumes}
				];

				(* Create a list of options to send to Transfer with preresolved source and destination media options *)
				(* Note:do not use preResolvedDestinationOptions since we are using ExperimentTransfer to error check those *)
				updatedTransferOptions = ReplaceRule[
					suppliedFlattenedTransferOptions,
					{
						InoculationTips -> (preResolvedTips/.Null -> Automatic),
						DestinationMix -> Lookup[preResolvedDestinationOptions, DestinationMix],
						DestinationMixType -> Lookup[preResolvedDestinationOptions, DestinationMixType],
						DestinationNumberOfMixes -> Lookup[preResolvedDestinationOptions, DestinationNumberOfMixes],
						DestinationMixVolume -> Lookup[preResolvedDestinationOptions, DestinationMixVolume],
						SourceMix -> resolvedSourceMixes,
						SourceMixType -> resolvedSourceMixTypes
					}
				];

				(* Update options to work with ExperimentTransfer with the option names swapped to their version in Transfer *)
				transferOptionsToPass = Map[
					Which[
						(* For option DestinationMixType, InoculateLM has special Shake mix type which is only applicable for SolidMedia *)
						(* We change the value to valid value and will change back to user specified value *)
						MatchQ[Keys[#], DestinationMixType] && MemberQ[Values[#], Shake],
							DispenseMixType -> (Values[#]/.Shake -> Automatic),
						(* For option DestinationWell, Transfer does not accept Null *)
						(* We change the value to valid value and will change back to user specified value *)
						MatchQ[Keys[#], DestinationWell] && NullQ[Values[#]],
							DestinationWell -> Automatic,
						(* For options with different name in ExperimentTransfer, swap the option name *)
						MemberQ[Keys@optionRenamingRules, Keys[#]],
							(Keys[#]/.optionRenamingRules) -> Values[#],
						MatchQ[#, Instrument -> {ObjectP[]..}],
							Which[
								(* Instrument is Null for ExperimentTransfer when doing robotic transfer *)
								(* We change the value to a single value and will change back to user specified value *)
								MatchQ[resolvedPreparation, Robotic],
									Instrument -> Null,
								(* If Instrument is not valid, set it to Automatic for invalid position so Transfer does not crash *)
								MemberQ[resolvedInstruments, ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler], Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}]],
									Instrument -> (Values[#]/.ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler], Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}] -> Automatic),
								True,
									#
							],
						(* Check if WorkCell, Preparation options are valid for Transfer which does not allow qPix *)
						(* We change the value to valid values before passing them on and will change back to user specified value *)
						MatchQ[#, WorkCell -> qPix],
							WorkCell -> Automatic,
						True,
							(* Keep other options as they are*)
							#
					]&,
					updatedTransferOptions
				];

				(* Section: Call ExperimentTransfer muted *)
				(* Call ModifyFunctionMessages to resolve the options and modify any messages. *)
				invalidTransferOptions = {};
				invalidTransferInputs = {};
				{transferOutput, transferTests} = If[gatherTests,
					ExperimentTransfer[
						mySamples,
						preResolvedDestinationMediaContainers,
						resolvedAmountsForExperimentTransfer,
						Sequence @@ transferOptionsToPass,
						SterileTechnique -> True,
						Cache -> combinedCache,
						Simulation -> currentSimulation,
						Output -> {Options, Tests}
					],
					{
						Module[{invalidOptionsBool, resolvedOptions},
							{resolvedOptions, invalidOptionsBool, invalidTransferOptions, invalidTransferInputs} = Quiet[
								ModifyFunctionMessages[
									ExperimentTransfer,
									{mySamples, preResolvedDestinationMediaContainers, resolvedAmountsForExperimentTransfer},
									"The following message was thrown when calculating the transfer options for the following samples:" <> ObjectToString[mySamples, Cache -> combinedCache, Simulation -> currentSimulation],
									{},(* We do not need to replace option names since transferOptionsToPass has swapped names already *)
									Join[transferOptionsToPass, {SterileTechnique -> True, Upload -> False, Output -> Options}],
									Simulation -> currentSimulation,
									Cache -> combinedCache,
									Output -> {Result, Boolean, InvalidOptions, InvalidInputs}
								],
								(* Quiet the error since we either have thrown them when resolve general options or will throw soon *)
								{Download::MissingCacheField, Error::ConflictingUnitOperationMethodRequirements, Warning::RoundedTransferAmount, Error::DiscardedSamples, Error::DeprecatedModels, Error::DispenseMixOptions}
							];

							invalidTransferOptions = Join[
								(* Only pick invalid options from our lists of options and convert the name back to the option name in our function *)
								Cases[invalidTransferOptions, Alternatives@@(transferOptions/.optionRenamingRules)]/.(Reverse /@ optionRenamingRules),
								(* Handle a special case in calling ExperimentTransfer, that the specified destinations or amounts are invalid, *)
								(* which is technically invalid input for Transfer but invalid options for InoculateLiquidMedia. *)
								If[MatchQ[invalidOptionsBool, True] && MatchQ[invalidTransferOptions, {}],
									{DestinationWell},
									{}
								],
								If[MemberQ[Flatten@invalidTransferInputs, VolumeP],
									{Volume},
									{}
								],
								If[MemberQ[Flatten@invalidTransferInputs, ObjectP[{Object[Container], Model[Container]}]],
									{DestinationMediaContainer},
									{}
								]
							];

							(* Only pick invalid inputs from our transfer if they are mySamples *)
							invalidTransferInputs = If[MemberQ[Flatten@invalidTransferInputs, ObjectP[mySamples]],
								PickList[mySamples, MemberQ[Flatten@invalidTransferInputs, ObjectP[#]]&],
								{}
							];

							(* Return the options *)
							resolvedOptions
						],
						{}
					}
				];

				(* Expand Transfer options since options might have collapsed *)
				(* Note:here we just indexmaching options, later we will nest indexmatching some options *)
				expandedTransferOptions = Last@ExpandIndexMatchedInputs[
					ExperimentTransfer,
					{mySamples, preResolvedDestinationMediaContainers, resolvedAmountsForExperimentTransfer},
					transferOutput,
					SingletonClassificationPreferred -> {SampleOutLabel, ContainerOutLabel}
				];

				(* Extract relevant options back to original name and value if necessary *)
				postsolvedTransferOptions = Map[
					Which[
						(* Option DestinationMixType might have modified by removing Shake. We need to swap the value back if user specified Shake *)
						MatchQ[Keys[#], DestinationMixType],
							DestinationMixType -> Values[#],
						(* For options which were specified as Null and we replaced to non-Null value, replace back to Null if they were specified *)
						(* Note:SourceMix option is renamed to AspirationMix in ExperimentTransfer *)
						MemberQ[nonNullValueRequiredOptions, Keys[#]] && MemberQ[Values[#], Null],
							Module[{updatedValues},
								updatedValues = MapThread[
									Function[{specifiedValue, resolvedValue},
										If[NullQ[specifiedValue],
											specifiedValue,
											resolvedValue
										]
									],
									{Values[#], Lookup[expandedTransferOptions, Keys[#]/.{SourceMix -> AspirationMix}]}
								];
								Keys[#] -> updatedValues
							],
						(* For other options with different name in ExperimentTransfer, take the value from expandedTransferOptions and swap the option name *)
						MemberQ[Keys@optionRenamingRules, Keys[#]],
							Keys[#] -> Lookup[expandedTransferOptions, Keys[#]/.optionRenamingRules],
						(* For options:Instrument, replace back to previous values *)
						MatchQ[Keys[#], Instrument],
							Keys[#] -> Values[#],
						(* Check if WorkCell was specified as qPix and We need to swap the value back if user specified Null *)
						MatchQ[Keys[#], WorkCell],
							Keys[#] -> Values[#],
						True,
							Keys[#] -> Lookup[expandedTransferOptions, Keys[#]]
					]&,
					updatedTransferOptions
				];

				(* Check if any of the nonNull options contains Null *)
				liquidMediaNullMismatchOptions = MapThread[
					If[MemberQ[Flatten@#2, Null],
						#1,
						Nothing
					]&,
					{
						nonNullValueRequiredOptions,
						{
							resolvedVolumes,
							preResolvedMediaVolumes,
							preResolvedDestinationMedium,
							Lookup[postsolvedTransferOptions, DestinationWell],
							Lookup[postsolvedTransferOptions, SourceMix]
						}
					}
				];

				(* We Re-nest options and swap back to user-specified wrongly multiple destination option values after resolving all transfer options *)
				liquidMediaFullyNestedOptions = Transpose@Map[
					Function[{option},
						Module[{updatedValue},
							updatedValue = MapThread[
								Which[
									MatchQ[option, DestinationMediaContainer], (#1/.Automatic -> #3),
									MatchQ[option, DestinationMedia], (#1/.Automatic -> #4),
									MatchQ[option, MediaVolume], (#1/.Automatic -> #5),
									True, (#1/.Automatic -> #2)
								]&,
								{
									Lookup[resolvedGeneralOptions, option],
									Lookup[postsolvedTransferOptions, option, ConstantArray[Null, Length[mySamples]]],
									preResolvedDestinationMediaContainers,
									preResolvedDestinationMedium,
									preResolvedMediaVolumes
								}
							];
							option -> updatedValue
						]
					],
					nestedIndexMatchingOptions
				];
				liquidMediaMultipleDestinationErrors = Map[
					!EqualQ[Length[Flatten[#]], 1]&,
					Lookup[liquidMediaFullyNestedOptions, DestinationMediaContainer]
				];

				liquidMediaResolvedOptions = ReplaceRule[
					resolvedGeneralOptions,
					Join[
						Normal[KeyDrop[postsolvedTransferOptions, nestedIndexMatchingOptions], Association],
						nonTransferOptions,
						liquidMediaFullyNestedOptions,
						{
							Volume -> resolvedVolumes
						}
					]
				];

				(* Return *)
				{
					(*1*)liquidMediaResolvedOptions,
					(*2*)liquidMediaNullMismatchOptions,
					(*3*)invalidTransferOptions,
					(*4*)invalidTransferInputs,
					(* DestinationMedia related errors. Note DestinationWell error is thrown by ExperimentTransfer already *)
					(*5*)liquidMediaNoPreferredLiquidMediaWarnings,
					(*6*)liquidMediaNonLiquidMediaErrors,
					(*7*)DeleteCases[liquidMediaOverfillMediaErrors, {}],
					(*8*)ConstantArray[False, Length[mySamples]],(* InvalidWell error is thrown by ExperimentTransfer *)
					(*9*)liquidMediaMultipleDestinationErrors,
					(*10*)DeleteCases[liquidMediaMixMismatchErrors, {}],
					(* InoculationTips related errors. We are using IncompatibleTips and NoCompatibleTips error checking in ExperimentTransfer instead here *)
					(*11*)ConstantArray[False, Length[mySamples]],
					(*12*)ConstantArray[False, Length[mySamples]],
					(* FreezeDried only errors *)
					(*13*)ConstantArray[False, Length[mySamples]],
					(*14*)ConstantArray[False, Length[mySamples]],
					(*15*){},
					(*16*){},
					(*17*){},
					(*18*)ConstantArray[False, Length[mySamples]],
					(*19*)ConstantArray[False, Length[mySamples]]
				}
			],
		(* Do own resolution *)
		MatchQ[resolvedInoculationSource, AgarStab] && !inoculationSourceError,
			Module[
				{
					flattenedDestinationOptions, flattenedGeneralOptions, agarStabMapThreadFriendlyOptions, agarStabOptions,
					suppliedFlattenedAgarStabOptions, hiddenOptions, nonAgarStabOptions, nonNullValueRequiredOptions, sampleVolumes,
					preResolvedDestinationMediaContainers, resolvedTips, agarStabTipConnectionMismatchErrors, agarStabNoTipsFoundErrors,
					resolvedTipTypes, resolvedTipMaterials, agarStabNoPreferredLiquidMediaWarnings, agarStabNonLiquidMediaErrors,
					agarStabOverfillMediaErrors, agarStabMixMismatchErrors, preResolvedDestinationOptions, preResolvedSampleOutLabels,
					preResolvedContainerOutLabels, preResolvedDestinationWells, agarStabInvalidDestinationWellErrors,
					updatedAgarStabOptions, agarStabNullMismatchOptions, agarStabFullyNestedOptions, agarStabMultipleDestinationErrors,
					agarStabResolvedOptions
				},

				(* Section: Unnest and flatten DestinationMedia related options and check error *)
				(* Note:we define destination related options as nested indexmatching for SolidMedia with potential multiple populations. *)
				(* For AgarStab, all those options should be a list of 1 value otherwise we throw error *)
				(* Example conversion:{s1,s2} has fully-nested options{{{1 Milliliter}},{{2 Milliliter}}} to {1 Milliliter, 2 Milliliter}, *)
				(* or not-fullynested options {{Automatic},{Automatic}} to {Automatic,Automatic} *)
				(* We will re-nest options and swap back to user-specified wrongly multiple destination option values after resolving all transfer options *)
				flattenedDestinationOptions = Map[
					Function[{option},
						Module[{unnestedValue},
							unnestedValue = Map[
								Which[
									!ListQ[#], #,
									!MemberQ[#, _List], #[[1]],
									True, First[#[[1]]]
								]&,
								Lookup[resolvedGeneralOptions, option]
							];
							(* Combine the value and error *)
							option -> unnestedValue
						]
					],
					nestedIndexMatchingOptions
				];

				flattenedGeneralOptions = ReplaceRule[resolvedGeneralOptions, flattenedDestinationOptions];

				(* Get mapThreadFriendlyOptions of agar stab options *)
				agarStabMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
					ExperimentInoculateLiquidMedia,
					flattenedGeneralOptions,
					AmbiguousNestedResolution -> IndexMatchingOptionPreferred
				];
				
				(* Section: Pre-Process options *)
				agarStabOptions = Join[$AgarStabOptionSymbols, nonInoculationSpecificOptions];
				suppliedFlattenedAgarStabOptions = Select[
					flattenedGeneralOptions,
					MemberQ[
						agarStabOptions,
						First[#]
					]&
				];

				(* Gather the non AgarStab options and replace Automatic to Null *)
				(* Note:whether the hidden options are nested or not do not matter since NullQ works on list of list of Null *)
				hiddenOptions = Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $FreezeDriedOptionSymbols, $FrozenGlycerolOptionSymbols, $LiquidMediaOptionSymbols], $AgarStabOptionSymbols];
				nonAgarStabOptions = Select[
					resolvedGeneralOptions,
					MemberQ[
						hiddenOptions,
						First[#]
					]&
				]/.Automatic -> Null;

				(* list of options have to be non-Null value for AgarStab *)
				nonNullValueRequiredOptions = {
					MediaVolume, DestinationMedia, DestinationWell
				};

				(* Get the source Volume which will be used to calculate whether InoculationTips can reach the sample *)
				sampleVolumes = Map[
					If[MatchQ[Lookup[#, Volume], VolumeP],
						Lookup[#, Volume],
						(* Otherwise look up the mass and convert *)
						Lookup[#, Mass] / inoculationSourceDensity
					]&,
					samplePackets
				];

				(* Resolve DestinationMediaContainer *)
				preResolvedDestinationMediaContainers = MapThread[
					Function[{destinationMediaContainer, mediaVolume, cellType},
						Which[
							MatchQ[destinationMediaContainer, Except[Automatic]],
								(* If DestinationMediaContainer is not Automatic, use it.*)
								destinationMediaContainer,
							MatchQ[mediaVolume, Automatic] || LessQ[(mediaVolume/.Null->0Microliter), 7 Milliliter],
								(* If mediaVolume is also Automatic, default to "Falcon Round-Bottom Polypropylene 14mL Test Tube *)
							(* 7ml is calculated as 0.5*14ml. We aim to fill 50% of the vessel *)
								Model[Container, Vessel, "id:AEqRl9KXBDoW"],
							(* Otherwise use PreferredContainer[mediaVolume] to get a container that fits. Make sure the container is Sterile *)
							True,
								FirstOrDefault[ToList[Quiet[
									PreferredContainer[FirstCase[{mediaVolume}, VolumeP, 0 Microliter], (CellType -> cellType/.Null->Automatic), Sterile -> True],
									PreferredContainer::ContainerNotFound
								]]]/. {$Failed -> Model[Container, Vessel, "id:AEqRl9KXBDoW"]}
						]
					],
					{Lookup[suppliedFlattenedAgarStabOptions, DestinationMediaContainer], Lookup[suppliedFlattenedAgarStabOptions, MediaVolume], modifiedSampleCellTypes}
				];

				(* Resolve InoculationTips and tip related options *)
				{resolvedTips, agarStabTipConnectionMismatchErrors, agarStabNoTipsFoundErrors} = Transpose@MapThread[
					Function[{sample, instrument, sampleVolume, destinationMediaContainer, options},
						(* If the instrument is specified, resolve the tips by calling the helper function *)
						resolveInoculationTipWithGivenInstrument[
							sample,
							Lookup[options, InoculationTips],
							instrument,
							Automatic,
							Automatic,
							sampleVolume,
							destinationMediaContainer,
							Lookup[options, DestinationMixType],
							AgarStab,
							combinedFastAssoc
						]
					],
					{mySamples, resolvedInstruments, sampleVolumes, preResolvedDestinationMediaContainers, agarStabMapThreadFriendlyOptions}
				];

				(* Resolve TipType and TipMaterial *)
				(* TipType and TipMaterial are hidden options and basically all sterile tip types are Barrier *)
				{resolvedTipTypes, resolvedTipMaterials} = Transpose@Map[
					Function[{tip},
						If[NullQ[tip],
							{Null, Null},
							Module[{tipPacket, tipType},
								tipPacket = If[MatchQ[tip, ObjectP[Model[Item]]],
									fetchPacketFromFastAssoc[tip, combinedFastAssoc],
									fastAssocPacketLookup[combinedFastAssoc, tip, Model]
								];
								tipType = Which[
									(* All sterile tips are barrier *)
									TrueQ[Lookup[tipPacket, Filtered]], Barrier,
									TrueQ[Lookup[tipPacket, WideBore]], WideBore,
									TrueQ[Lookup[tipPacket, GelLoading]], GelLoading,
									TrueQ[Lookup[tipPacket, Aspirator]], Aspirator,
									True, Normal
								];
								{tipType, Lookup[tipPacket, Material]}
							]
						]
					],
					resolvedTips
				];

				{
					(*1*)agarStabNoPreferredLiquidMediaWarnings,
					(*2*)agarStabNonLiquidMediaErrors,
					(*3*)agarStabOverfillMediaErrors,
					(*4*)agarStabMixMismatchErrors,
					(*5*)preResolvedDestinationOptions
				} = Transpose@MapThread[
					Function[{mySample, mapThreadOptions, destinationMediaContainer, tip},
						Module[
							{
								destinationMix, destinationMixType, destinationNumberOfMixes, destinationMixVolume,
								destinationMedia, mediaVolume, resolvedUnnestedDestinationOptions, agarStabNoPreferredLiquidMediaWarning,
								nonLiquidMediaError, overfillMediaError, mixMismatchOption
							},

							(* Lookup needed options *)
							(* Note:all those values should be a singleton since we have stripped nested list from them *)
							{
								destinationMix,
								destinationMixType,
								destinationNumberOfMixes,
								destinationMixVolume,
								destinationMedia,
								mediaVolume
							} = Lookup[
								mapThreadOptions,
								{
									DestinationMix,
									DestinationMixType,
									DestinationNumberOfMixes,
									DestinationMixVolume,
									DestinationMedia,
									MediaVolume
								}
							];

							(* Resolve destination options *)
							{
								resolvedUnnestedDestinationOptions,
								agarStabNoPreferredLiquidMediaWarning,
								nonLiquidMediaError,
								overfillMediaError,
								mixMismatchOption
							} = resolveInoculationDestinationOptions[
								mySample,
								{
									DestinationMedia -> destinationMedia,
									MediaVolume -> mediaVolume,
									DestinationMix -> destinationMix,
									DestinationMixType -> destinationMixType,
									DestinationNumberOfMixes -> destinationNumberOfMixes,
									DestinationMixVolume -> destinationMixVolume
								},
								destinationMediaContainer,
								tip,
								Null,(* AgarStab is solid so SampleVolume is negligible when considering OverFill error *)
								destinationMedia,
								combinedFastAssoc
							];
							
							(* Return resolved values *)
							{
								(*1*)agarStabNoPreferredLiquidMediaWarning,
								(*2*)nonLiquidMediaError,
								(*3*)overfillMediaError,
								(*4*)mixMismatchOption,
								(*5*)resolvedUnnestedDestinationOptions
							}
						]
					],
					{mySamples, agarStabMapThreadFriendlyOptions, preResolvedDestinationMediaContainers, resolvedTips}
				];

				(* Resolve SampleOutLabel and ContainerOutLabel *)
				(* The expected output is a flat list index matching to mySamples. We will re-nest them later *)
				preResolvedSampleOutLabels = resolveInoculationLabel[
					mySamples,
					SampleOutLabel,
					Lookup[suppliedFlattenedAgarStabOptions, SampleOutLabel],
					preResolvedDestinationMediaContainers,
					userSpecifiedLabels,
					currentSimulation,
					combinedFastAssoc
				];

				preResolvedContainerOutLabels = resolveInoculationLabel[
					mySamples,
					ContainerOutLabel,
					Lookup[suppliedFlattenedAgarStabOptions, ContainerOutLabel],
					preResolvedDestinationMediaContainers,
					userSpecifiedLabels,
					currentSimulation,
					combinedFastAssoc
				];

				(* Resolve destination wells using the helper function. Only flattened list is allowed, just call the helper *)
				{
					preResolvedDestinationWells,
					agarStabInvalidDestinationWellErrors
				} = resolveInoculationDestinationWells[
					Lookup[suppliedFlattenedAgarStabOptions, DestinationWell],
					preResolvedDestinationMediaContainers,
					preResolvedContainerOutLabels,
					combinedFastAssoc
				];

				updatedAgarStabOptions = ReplaceRule[
					suppliedFlattenedAgarStabOptions,
					{
						DestinationMediaContainer -> preResolvedDestinationMediaContainers,
						DestinationWell -> preResolvedDestinationWells,
						DestinationMix -> Lookup[preResolvedDestinationOptions, DestinationMix],
						DestinationMixType -> Lookup[preResolvedDestinationOptions, DestinationMixType],
						DestinationNumberOfMixes -> Lookup[preResolvedDestinationOptions, DestinationNumberOfMixes],
						DestinationMixVolume -> Lookup[preResolvedDestinationOptions, DestinationMixVolume],
						DestinationMedia -> Lookup[preResolvedDestinationOptions, DestinationMedia],
						MediaVolume -> Lookup[preResolvedDestinationOptions, MediaVolume],
						InoculationTips -> resolvedTips,
						InoculationTipType -> resolvedTipTypes,
						InoculationTipMaterial -> resolvedTipMaterials,
						SampleOutLabel -> preResolvedSampleOutLabels,
						ContainerOutLabel -> preResolvedContainerOutLabels
				}];
				agarStabNullMismatchOptions = MapThread[
					If[MemberQ[Flatten@#2, Null],
						#1,
						Nothing
					]&,
					{
						nonNullValueRequiredOptions,
						{
							Lookup[preResolvedDestinationOptions, MediaVolume],
							Lookup[preResolvedDestinationOptions, DestinationMedia],
							Lookup[preResolvedDestinationOptions, DestinationWell]
						}
					}
				];

				agarStabFullyNestedOptions = Transpose@Map[
					Function[{option},
						Module[{updatedValue},
							updatedValue = MapThread[
								(#1/.Automatic -> #2)&,
								{
									Lookup[resolvedGeneralOptions, option],
									Lookup[updatedAgarStabOptions, option]
								}
							];
							option -> updatedValue
						]
					],
					nestedIndexMatchingOptions
				];
				agarStabMultipleDestinationErrors = Map[
					!EqualQ[Length[Flatten[#]], 1]&,
					Lookup[agarStabFullyNestedOptions, DestinationMediaContainer]
				];

				agarStabResolvedOptions = ReplaceRule[
					resolvedGeneralOptions,
					Join[
						Normal[KeyDrop[updatedAgarStabOptions, nestedIndexMatchingOptions], Association],
						nonAgarStabOptions,
						agarStabFullyNestedOptions
					]
				];

				{
					(*1*)agarStabResolvedOptions,
					(*2*)agarStabNullMismatchOptions,
					(*3*){},
					(*4*){},
					(* DestinationMedia related errors *)
					(*5*)agarStabNoPreferredLiquidMediaWarnings,
					(*6*)agarStabNonLiquidMediaErrors,
					(*7*)DeleteCases[agarStabOverfillMediaErrors, {}],
					(*8*)agarStabInvalidDestinationWellErrors,
					(*9*)agarStabMultipleDestinationErrors,
					(*10*)DeleteCases[agarStabMixMismatchErrors, {}],
					(* InoculationTips related errors *)
					(*11*)agarStabNoTipsFoundErrors,
					(*12*)agarStabTipConnectionMismatchErrors,
					(* FreezeDried only errors *)
					(*13*)ConstantArray[False, Length[mySamples]],
					(*14*)ConstantArray[False, Length[mySamples]],
					(*15*){},
					(*16*){},
					(*17*){},
					(*18*)ConstantArray[False, Length[mySamples]],
					(*19*)ConstantArray[False, Length[mySamples]]
				}
			],
		(* Do own resolution *)
		MatchQ[resolvedInoculationSource, FreezeDried] && !inoculationSourceError,
			Module[
				{
					freezeDriedOptions, suppliedFreezeDriedOptions, freezeDriedMapThreadFriendlyOptions, hiddenOptions,
					nonFreezeDriedOptions, nonNullValueRequiredOptions,
					(* Error tracking variables *)
					freezeDriedResuspensionNoPreferredLiquidMediaWarnings, resolvedResuspensionMedium, freezeDriedResuspensionNonLiquidErrors,
					resolvedResuspensionMediaVolumes, sourceContainerOverfillErrors, resolvedVolumes, resolvedVolumesNoAll,
					resolvedDestinationMediaContainers, resuspensionMediaOverdrawnErrors, resuspensionMediaUnusedErrors,
					resolvedTips, freezeDriedTipConnectionMismatchErrors, freezeDriedNoTipsFoundErrors, resolvedTipTypes, resolvedTipMaterials,
					resolvedResuspensionMixes, resolvedResuspensionMixTypes, resolvedNumberOfResuspensionMixess, resolvedResuspensionMixVolumes,
					freezeDriedNoResuspensionMixForFreezeDriedSampleWarnings, freezeDriedResuspensionMixOptionsMismatchErrors,
					freezeDriedDestinationNoPreferredLiquidMediaWarnings, freezeDriedDestinationNonLiquidErrors, destinationOverfillMediaErrors,
					freezeDriedDestinationMixMismatchErrors, resolvedDestinationMixes, resolvedDestinationMixTypes,
					resolvedDestinationNumberOfMixes, resolvedDestinationMixVolumes, resolvedDestinationMedium, resolvedMediaVolumes,
					resolvedSampleOutLabels, resolvedContainerOutLabels,
					freezeDriedInvalidDestinationWellErrors,
					resolvedDestinationWells,
					resolvedFreezeDriedOptions, freezeDriedNullMismatchOptions
				},

				(* Section: Pre-Process options *)
				freezeDriedOptions = Join[$FreezeDriedOptionSymbols, nonInoculationSpecificOptions];
				suppliedFreezeDriedOptions = Select[
					resolvedGeneralOptions,
					MemberQ[
						freezeDriedOptions,
						First[#]
					]&
				];

				(* Get mapThreadFriendlyOptions of freeze dried options *)
				(* Note:we keep the Nested indexmatching form of all the option values *)
				freezeDriedMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
					ExperimentInoculateLiquidMedia,
					suppliedFreezeDriedOptions,
					SingletonOptionPreferred -> {ContainerOutLabel, SampleOutLabel}
				];

				(* Gather the non FreezeDried options and replace Automatic to Null *)
				hiddenOptions = Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $AgarStabOptionSymbols, $FrozenGlycerolOptionSymbols, $LiquidMediaOptionSymbols], $FreezeDriedOptionSymbols];
				nonFreezeDriedOptions = Select[
					resolvedGeneralOptions,
					MemberQ[
						hiddenOptions,
						First[#]
					]&
				]/.Automatic -> Null;

				(* list of options have to be non-Null value for FreezeDried *)
				(* Note:DestinationMedia and MediaVolume can be Null in case user only wants to use the resuspended cells by resuspension media *)
				nonNullValueRequiredOptions = {
					Volume, ResuspensionMix, ResuspensionMedia, ResuspensionMediaVolume, DestinationWell
				};

				(* Resolve ResuspensionMedia *)
				{freezeDriedResuspensionNoPreferredLiquidMediaWarnings, resolvedResuspensionMedium} = Transpose@MapThread[
					Function[{sample, resuspensionMedia, destinationMedia},
						If[MatchQ[resuspensionMedia, Automatic],
							(* If it is automatic, resolve to the first object in destination media, otherwise check the preferred *)
							If[MemberQ[destinationMedia, ObjectP[]],
								{False, FirstCase[destinationMedia, ObjectP[]]},
								findPreferredMediaOfCellSample[sample, False, combinedFastAssoc]
							],
							(* If it is not automatic, keep it *)
							{False, resuspensionMedia}
						]
					],
					{mySamples, Lookup[freezeDriedMapThreadFriendlyOptions, ResuspensionMedia], Lookup[freezeDriedMapThreadFriendlyOptions, DestinationMedia]}
				];

				(* Check if ResuspesionMedia is not liquid. Note if we resolve ResuspensionMedia from DestinationMedia, we do not throw non liquid error here *)
				freezeDriedResuspensionNonLiquidErrors = MapThread[
					Function[{resuspensionMedia, specifiedMedia},
						If[NullQ[resuspensionMedia] || MatchQ[specifiedMedia, Automatic],
							False,
							Module[{mediaPacket},
								mediaPacket = fetchPacketFromFastAssoc[resuspensionMedia, combinedFastAssoc];
								MatchQ[Lookup[mediaPacket, State], Except[Liquid]]
							]
						]
					],
					{resolvedResuspensionMedium, Lookup[freezeDriedMapThreadFriendlyOptions, ResuspensionMedia]}
				];

				(* Resolve ResuspensionMediaVolume *)
				resolvedResuspensionMediaVolumes = MapThread[
					Function[{sample, resuspensionMediaVolume},
						If[MatchQ[resuspensionMediaVolume, Except[Automatic]],
							(* If it is not automatic, keep it *)
							resuspensionMediaVolume,
							(* If it is automatic, resolve to to 25% of the container's max volume *)
							Module[{sampleContainerModelPacket, maxVolume},
								sampleContainerModelPacket = fastAssocPacketLookup[combinedFastAssoc, sample, {Container, Model}];
								maxVolume = FirstCase[{Lookup[sampleContainerModelPacket, MaxVolume], 1 * Milliliter}, VolumeP];
								SafeRound[0.25 * maxVolume, 10^-1 * Microliter]
							]
						]
					],
					{mySamples, Lookup[freezeDriedMapThreadFriendlyOptions, ResuspensionMediaVolume]}
				];

				(* Check if resuspension medium is too much for the source container *)
				sourceContainerOverfillErrors = MapThread[
					Function[{sample, containerPacket, containerModelPacket, mediaVolume, resuspensionMedia},
						If[GreaterQ[mediaVolume/.Null->0Microliter, Lookup[containerModelPacket, MaxVolume]/.Null->0Microliter],
							{sample, Lookup[containerPacket, Object], mediaVolume, resuspensionMedia},
							{}
						]
					],
					{mySamples, containerPackets, containerModelPackets, resolvedResuspensionMediaVolumes, resolvedResuspensionMedium}
				];

				(* Resolve Volume *)
				resolvedVolumes =  MapThread[
					Function[{resuspensionMediaVolume, options},
						Module[{destinationMediaContainer, volume},
							destinationMediaContainer = Lookup[options, DestinationMediaContainer];
							volume = Lookup[options, Volume];
							Which[
								MatchQ[volume, ListableP[VolumeP|All|Null]],
									(* If the option is set, keep it *)
									volume,
								EqualQ[Length[destinationMediaContainer], 1],
									(* If there is only 1 destination container, set volume to All *)
									volume/. Automatic -> All,
								True,
									(* If the option is automatic, resolve it to the volume of the resuspension media sample divided by the length of the destination containers (but no less than 1 Microliter)*)
									volume/. Automatic -> SafeRound[(resuspensionMediaVolume/.Null -> 1 Microliter) / Length[destinationMediaContainer], 10^-1 * Microliter]
							]
						]
					],
					{resolvedResuspensionMediaVolumes, freezeDriedMapThreadFriendlyOptions}
				];

				(* If All is specified as Volume, convert it to ResuspensionMediaVolume *)
				resolvedVolumesNoAll = MapThread[
					If[MatchQ[#1, All],
						#2,
						#1
					]&,
					{resolvedVolumes, resolvedResuspensionMediaVolumes}
				];

				(* Resolve DestinationMediaContainer *)
				resolvedDestinationMediaContainers = MapThread[
					Function[{options, volume, cellType},
						Module[{destinationMediaContainer, mediaVolume},
							destinationMediaContainer = Lookup[options, DestinationMediaContainer];
							mediaVolume = Lookup[options, MediaVolume];
							If[!MatchQ[destinationMediaContainer, ListableP[Automatic]],
								(* We allow multiple destinations for one freeze-dried sample *)
								destinationMediaContainer,
								MapThread[
									Which[
										(* If the option is already an object - keep it *)
										MatchQ[#1, ObjectP[]],
											#1,
										MatchQ[#2, Automatic],
											Which[
												MatchQ[#3, VolumeP] && LessQ[#3, 1.2 Milliliter],
													(* 1.2ml is calculated as 0.5*14ml/6. We aim to fill 50% of the vessel, sample and fresh media vol is 1vs5 *)
													Model[Container, Vessel, "id:AEqRl9KXBDoW"],
												MatchQ[#3, VolumeP],
													FirstOrDefault[ToList[Quiet[
														PreferredContainer[6*#3, (CellType -> cellType/.Null->Automatic), Sterile -> True],
														PreferredContainer::ContainerNotFound
													]]]/. {$Failed -> Model[Container, Vessel, "id:AEqRl9KXBDoW"]},
												(* If mediaVolume is Automatic and Volume is Null, default to "Falcon Round-Bottom Polypropylene 14mL Test Tube *)
												True,
													Model[Container, Vessel, "id:AEqRl9KXBDoW"]
											],
										True,
											(* Find a container which can fit both media volume and volume. Make sure the container is Sterile *)
											FirstOrDefault[ToList[Quiet[
												PreferredContainer[Total[{#2, #3/.Null->1 Microliter}], (CellType -> cellType/.Null->Automatic), Sterile -> True],
												PreferredContainer::ContainerNotFound
											]]]/. {$Failed -> Model[Container, Vessel, "id:AEqRl9KXBDoW"]}
										]&,
									{destinationMediaContainer, mediaVolume, ConstantArray[volume, Length[destinationMediaContainer]]}
								]
							]
						]
					],
					{freezeDriedMapThreadFriendlyOptions, resolvedVolumesNoAll, modifiedSampleCellTypes}
				];

				(* Check if we are overaspirating resuspension medium and have some unused *)
				(* Note: we allow multiple DestinationMediaContainers. Allow for up to 50 Microliter unused sample to be discarded without error *)
				{resuspensionMediaOverdrawnErrors, resuspensionMediaUnusedErrors} = Transpose@MapThread[
					{
						If[LessQ[(#2/.Null->0Microliter), (Length[#4]*#3/.Null->0Microliter)],
							{#1, #2, #3, #4, Length[#4]*#3/.Null->0Microliter},
							{}
						],
						If[GreaterQ[(#2/.Null->0Microliter), (50 Microliter+Length[#4]*#3/.Null->0Microliter)],
							{#1, #2, #3, #4, Length[#4]*#3/.Null->0Microliter},
							{}
						]
					}&,
					{mySamples, resolvedResuspensionMediaVolumes, resolvedVolumesNoAll, resolvedDestinationMediaContainers}
				];

				(* Resolve InoculationTips and tip related options *)
				{resolvedTips, freezeDriedTipConnectionMismatchErrors, freezeDriedNoTipsFoundErrors} = Transpose@MapThread[
					Function[{sample, instrument, sampleVolume, destinationMediaContainer, options},
						resolveInoculationTipWithGivenInstrument[
							sample,
							Lookup[options, InoculationTips],
							instrument,
							Automatic,
							Automatic,
							sampleVolume,(* Use the reuspended sample volume divided by total number of destinations since we might transfer from source container multiple times and need to make sure the tip is able to reach the source container at the end *)
							destinationMediaContainer,
							Lookup[options, DestinationMixType],
							FreezeDried,
							combinedFastAssoc
						]
					],
					{mySamples, resolvedInstruments, resolvedVolumesNoAll, resolvedDestinationMediaContainers, freezeDriedMapThreadFriendlyOptions}
				];

				(* Resolve TipType and TipMaterial *)
				(* TipType and TipMaterial are hidden options and basically all sterile tip types are Barrier *)
				{resolvedTipTypes, resolvedTipMaterials} = Transpose@Map[
					Function[{tip},
						If[NullQ[tip],
							{Null, Null},
							Module[{tipPacket, tipType},
								tipPacket = If[MatchQ[tip, ObjectP[Model[Item]]],
									fetchPacketFromFastAssoc[tip, combinedFastAssoc],
									fastAssocPacketLookup[combinedFastAssoc, tip, Model]
								];
								tipType = Which[
									(* All sterile tips are barrier *)
									TrueQ[Lookup[tipPacket, Filtered]], Barrier,
									TrueQ[Lookup[tipPacket, WideBore]], WideBore,
									TrueQ[Lookup[tipPacket, GelLoading]], GelLoading,
									TrueQ[Lookup[tipPacket, Aspirator]], Aspirator,
									True, Normal
								];
								{tipType, Lookup[tipPacket, Material]}
							]
						]
					],
					resolvedTips
				];

				(* Resolve ResuspensionMix options*)
				{
					resolvedResuspensionMixes,
					resolvedResuspensionMixTypes,
					resolvedResuspensionMixVolumes,
					resolvedNumberOfResuspensionMixess,
					freezeDriedNoResuspensionMixForFreezeDriedSampleWarnings,
					freezeDriedResuspensionMixOptionsMismatchErrors
				} = Transpose@MapThread[
					Function[{sample, tip, resuspensionMediaVolume, options},
						resolveInoculateResuspensionMixOptions[
							sample,
							{
								ResuspensionMix -> Lookup[options, ResuspensionMix],
								ResuspensionMixType -> Lookup[options, ResuspensionMixType],
								ResuspensionMixVolume -> Lookup[options, ResuspensionMixVolume],
								NumberOfResuspensionMixes -> Lookup[options, NumberOfResuspensionMixes]
							},
							resuspensionMediaVolume,
							tip,
							combinedFastAssoc
						]
					],
					{mySamples, resolvedTips, resolvedResuspensionMediaVolumes, freezeDriedMapThreadFriendlyOptions}
				];

				{
					(* Error tracking variables *)
					freezeDriedDestinationNoPreferredLiquidMediaWarnings,
					freezeDriedDestinationNonLiquidErrors,
					destinationOverfillMediaErrors,
					freezeDriedDestinationMixMismatchErrors,
					(* Resolved options *)
					resolvedDestinationMixes,
					resolvedDestinationMixTypes,
					resolvedDestinationNumberOfMixes,
					resolvedDestinationMixVolumes,
					resolvedDestinationMedium,
					resolvedMediaVolumes
				} = Transpose@MapThread[
					Function[{mySample, mapThreadOptions, destinationMediaContainer, tip, volume, resuspensionMedia},
						Module[
							{
								(* Unresolved options *)
								destinationMix, destinationMixType, destinationNumberOfMixes, destinationMixVolume, destinationMedia,
								preResolvedDestinationMedia, mediaVolume, resolvedDestinationOptions, freezeDriedNoPreferredLiquidMediaWarning,
								nonLiquidMediaError, overfillMediaError, mixMismatchOption
							},

							(* Lookup needed options. Note those options are all nested indexmatching options *)
							{
								destinationMix,
								destinationMixType,
								destinationNumberOfMixes,
								destinationMixVolume,
								destinationMedia,
								mediaVolume
							} = Lookup[
								mapThreadOptions,
								{
									DestinationMix,
									DestinationMixType,
									DestinationNumberOfMixes,
									DestinationMixVolume,
									DestinationMedia,
									MediaVolume
								}
							];

							(* Pre-resolve destination media based on 1)user input to this option, and 2) user input to ResuspensionMedia *)
							preResolvedDestinationMedia = Map[
								Which[
									MatchQ[#, ListableP[ObjectP[]]],
										#,
									MatchQ[#, Automatic] && MatchQ[resuspensionMedia, ObjectP[]],
										(* If the user input is automatic,check if there user input to ResuspensionMedia, use the specified resuspension media *)
										#/.Automatic -> resuspensionMedia,
									True,
										(* Otherwise keep the Automatic and resolve in  resolveInoculationDestinationOptions *)
										#
								]&,
								destinationMedia
							];

							(* Call the helper function to resolve the destination options *)
							{
								resolvedDestinationOptions,
								freezeDriedNoPreferredLiquidMediaWarning,
								nonLiquidMediaError,
								overfillMediaError,
								mixMismatchOption
							} = resolveInoculationDestinationOptions[
								mySample,
								{
									DestinationMedia -> preResolvedDestinationMedia,
									MediaVolume -> mediaVolume,
									DestinationMix -> destinationMix,
									DestinationMixType -> destinationMixType,
									DestinationNumberOfMixes -> destinationNumberOfMixes,
									DestinationMixVolume -> destinationMixVolume
								},
								destinationMediaContainer,
								tip,
								volume, (* FreezeDried is resuspended to liquid so Volume should be considered here when considering OverFill error *)
								destinationMedia,(* we need to distinguish preResolvedDestinationMedia and destinationMedia so we do not throw duplicated Media non liquid error *)
								combinedFastAssoc
							];

							(* Return necessary values *)
							{
								(* Error tracking variables *)
								freezeDriedNoPreferredLiquidMediaWarning,
								nonLiquidMediaError,
								overfillMediaError,
								mixMismatchOption,
								(* Resolved options *)
								Lookup[resolvedDestinationOptions, DestinationMix],
								Lookup[resolvedDestinationOptions, DestinationMixType],
								Lookup[resolvedDestinationOptions, DestinationNumberOfMixes],
								Lookup[resolvedDestinationOptions, DestinationMixVolume],
								Lookup[resolvedDestinationOptions, DestinationMedia],
								Lookup[resolvedDestinationOptions, MediaVolume]
							}
						]
					],
					{mySamples, freezeDriedMapThreadFriendlyOptions, resolvedDestinationMediaContainers, resolvedTips, resolvedVolumesNoAll, resolvedResuspensionMedium}
				];

				(* Resolve SampleOutLabel and ContainerOutLabel *)
				(* The expected output is a list of list index matching to mySamples, unflattened the same manner as resolvedDestinationMediaContainers *)
				resolvedSampleOutLabels = resolveInoculationLabel[
					mySamples,
					SampleOutLabel,
					Lookup[resolvedGeneralOptions, SampleOutLabel],
					resolvedDestinationMediaContainers,
					userSpecifiedLabels,
					currentSimulation,
					combinedFastAssoc
				];

				resolvedContainerOutLabels = resolveInoculationLabel[
					mySamples,
					ContainerOutLabel,
					Lookup[resolvedGeneralOptions, ContainerOutLabel],
					resolvedDestinationMediaContainers,
					userSpecifiedLabels,
					currentSimulation,
					combinedFastAssoc
				];

				(* Resolve destination wells using the helper function *)
				{resolvedDestinationWells, freezeDriedInvalidDestinationWellErrors} = resolveInoculationDestinationWells[
					Lookup[resolvedGeneralOptions, DestinationWell],
					resolvedDestinationMediaContainers,
					resolvedContainerOutLabels,
					combinedFastAssoc
				];

				(* Gather all FreezeDried options *)
				resolvedFreezeDriedOptions = {
					DestinationMediaContainer -> resolvedDestinationMediaContainers,
					DestinationWell -> resolvedDestinationWells,
					DestinationMix -> resolvedDestinationMixes,
					DestinationMixType -> resolvedDestinationMixTypes,
					DestinationNumberOfMixes -> resolvedDestinationNumberOfMixes,
					DestinationMixVolume -> resolvedDestinationMixVolumes,
					InoculationTips -> resolvedTips,
					InoculationTipType -> resolvedTipTypes,
					InoculationTipMaterial -> resolvedTipMaterials,
					DestinationMedia -> resolvedDestinationMedium,
					MediaVolume -> resolvedMediaVolumes,
					Volume -> resolvedVolumes,
					ResuspensionMix -> resolvedResuspensionMixes,
					ResuspensionMixType -> resolvedResuspensionMixTypes,
					NumberOfResuspensionMixes -> resolvedNumberOfResuspensionMixess,
					ResuspensionMixVolume -> resolvedResuspensionMixVolumes,
					ResuspensionMedia -> resolvedResuspensionMedium,
					ResuspensionMediaVolume -> resolvedResuspensionMediaVolumes,
					SampleOutLabel -> resolvedSampleOutLabels,
					ContainerOutLabel -> resolvedContainerOutLabels
				};

				freezeDriedNullMismatchOptions = PickList[nonNullValueRequiredOptions, NullQ[Lookup[resolvedFreezeDriedOptions, #]] &/@nonNullValueRequiredOptions, True];

				{
					(*1*)ReplaceRule[
						resolvedGeneralOptions,
						Join[
							nonFreezeDriedOptions,
							resolvedFreezeDriedOptions
						]
					],
					(*2*)freezeDriedNullMismatchOptions,
					(*3*){},
					(*4*){},
					(* DestinationMedia related errors *)
					(*5*)freezeDriedDestinationNoPreferredLiquidMediaWarnings,
					(*6*)freezeDriedDestinationNonLiquidErrors,
					(*7*)DeleteCases[Flatten[destinationOverfillMediaErrors, 1], {}],
					(*8*)freezeDriedInvalidDestinationWellErrors,
					(*9*)ConstantArray[False, Length[mySamples]],
					(*10*)DeleteCases[freezeDriedDestinationMixMismatchErrors, {}],
					(* InoculationTips related errors *)
					(*11*)freezeDriedNoTipsFoundErrors,
					(*12*)freezeDriedTipConnectionMismatchErrors,
					(* FreezeDried only errors *)
					(*13*)freezeDriedResuspensionNoPreferredLiquidMediaWarnings,
					(*14*)freezeDriedResuspensionNonLiquidErrors,
					(*15*)DeleteCases[sourceContainerOverfillErrors, {}],
					(*16*)DeleteCases[resuspensionMediaUnusedErrors, {}],
					(*17*)DeleteCases[resuspensionMediaOverdrawnErrors, {}],
					(*18*)freezeDriedNoResuspensionMixForFreezeDriedSampleWarnings,
					(*19*)freezeDriedResuspensionMixOptionsMismatchErrors
				}
			],
		(* Do own resolution *)
		MatchQ[resolvedInoculationSource, FrozenGlycerol] && !inoculationSourceError,
			Module[
				{
					flattenedDestinationOptions, flattenedGeneralOptions, frozenGlycerolMapThreadFriendlyOptions, frozenGlycerolOptions,
					suppliedFlattenedFrozenGlycerolOptions, hiddenOptions, nonFrozenGlycerolOptions, nonNullValueRequiredOptions,
					sampleVolumes, preResolvedDestinationMediaContainers, resolvedNumberOfSourceScrapes, resolvedTips, resolvedTipTypes,
					resolvedTipMaterials, frozenGlycerolTipConnectionMismatchErrors, frozenGlycerolNoTipsFoundErrors,
					frozenGlycerolNoPreferredLiquidMediaWarnings, frozenGlycerolNonLiquidMediaErrors, frozenGlycerolOverfillMediaErrors,
					frozenGlycerolMixMismatchErrors, preResolvedDestinationOptions, preResolvedSampleOutLabels, preResolvedContainerOutLabels,
					preResolvedDestinationWells, frozenGlycerolInvalidDestinationWellErrors, updatedFrozenGlycerolOptions,
					frozenGlycerolNullMismatchOptions, frozenGlycerolFullyNestedOptions, frozenGlycerolMultipleDestinationErrors,
					frozenGlycerolResolvedOptions
				},

				(* Section: Unnest and flatten DestinationMedia related options and check error *)
				(* Note:we define destination related options as nested indexmatching for SolidMedia with potential multiple populations. *)
				(* For FrozenGlycerol, all those options should be a list of 1 value otherwise we throw error *)
				(* Example conversion:{s1,s2} has fully-nested options{{{1 Milliliter}},{{2 Milliliter}}} to {1 Milliliter, 2 Milliliter}, *)
				(* or not-fullynested options {{Automatic},{Automatic}} to {Automatic,Automatic} *)
				(* We will re-nest options and swap back to user-specified wrongly multiple destination option values after resolving all transfer options *)
				flattenedDestinationOptions = Map[
					Function[{option},
						Module[{unnestedValue},
							unnestedValue = Map[
								Which[
									!ListQ[#], #,
									!MemberQ[#, _List], #[[1]],
									True, First[#[[1]]]
								]&,
								Lookup[resolvedGeneralOptions, option]
							];
							(* Combine the value and error *)
							option -> unnestedValue
						]
					],
					nestedIndexMatchingOptions
				];

				flattenedGeneralOptions = ReplaceRule[resolvedGeneralOptions, flattenedDestinationOptions];

				frozenGlycerolMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
					ExperimentInoculateLiquidMedia,
					flattenedGeneralOptions,
					AmbiguousNestedResolution -> IndexMatchingOptionPreferred
				];
				
				(* Section: Pre-Process options *)
				frozenGlycerolOptions = Join[$FrozenGlycerolOptionSymbols, nonInoculationSpecificOptions];
				suppliedFlattenedFrozenGlycerolOptions = Select[
					flattenedGeneralOptions,
					MemberQ[
						frozenGlycerolOptions,
						First[#]
					]&
				];

				(* Gather the non FrozenGlycerol options and replace Automatic to Null *)
				hiddenOptions = Complement[DeleteDuplicates@Join[$SolidMediaOptionSymbols, $AgarStabOptionSymbols, $FreezeDriedOptionSymbols, $LiquidMediaOptionSymbols], $FrozenGlycerolOptionSymbols];
				nonFrozenGlycerolOptions = Select[
					resolvedGeneralOptions,
					MemberQ[
						hiddenOptions,
						First[#]
					]&
				]/.Automatic -> Null;

				(* list of options have to be non-Null value for FrozenGlycerol *)
				nonNullValueRequiredOptions = {
					DestinationWell, DestinationMedia, MediaVolume, NumberOfSourceScrapes
				};

				(* Get the source Volume which will be used to calculate whether InoculationTips can reach the sample *)
				sampleVolumes = Map[
					If[MatchQ[Lookup[#, Volume], VolumeP],
						Lookup[#, Volume],
						(* Otherwise look up the mass and convert *)
						Lookup[#, Mass] / inoculationSourceDensity
					]&,
					samplePackets
				];

				(* Resolve DestinationMediaContainer *)
				preResolvedDestinationMediaContainers = MapThread[
					Function[{destinationMediaContainer, mediaVolume, cellType},
						Which[
							!MatchQ[destinationMediaContainer, Automatic],
								destinationMediaContainer,
							MatchQ[mediaVolume, Automatic],
								(* If mediaVolume is also Automatic, default to "Falcon Round-Bottom Polypropylene 14mL Test Tube *)
								Model[Container, Vessel, "id:AEqRl9KXBDoW"],
							(* Otherwise use PreferredContainer[mediaVolume] to get a container that fits. Make sure the container is Sterile *)
							True,
							FirstOrDefault[ToList[Quiet[
								PreferredContainer[FirstCase[{mediaVolume}, VolumeP, 0 Microliter], (CellType -> cellType/.Null->Automatic), Sterile -> True],
								PreferredContainer::ContainerNotFound
							]]]/. {$Failed -> Model[Container, Vessel, "id:AEqRl9KXBDoW"]}
						]
					],
					{Lookup[suppliedFlattenedFrozenGlycerolOptions, DestinationMediaContainer], Lookup[suppliedFlattenedFrozenGlycerolOptions, MediaVolume], modifiedSampleCellTypes}
				];

				(* Resolve NumberOfSourceScrapes *)
				resolvedNumberOfSourceScrapes = Map[
					If[MatchQ[#, Automatic],
						(* If it is automatic, set to 5 *)
						5,
						(* If it is not automatic, keep it *)
						#
					]&,
					Lookup[suppliedFlattenedFrozenGlycerolOptions, NumberOfSourceScrapes]
				];

				(* Resolve InoculationTips and tip related options *)
				{resolvedTips, frozenGlycerolTipConnectionMismatchErrors, frozenGlycerolNoTipsFoundErrors} = Transpose@MapThread[
					Function[{sample, instrument, sampleVolume, destinationMediaContainer, options},
						(* If the instrument is specified, resolve the tips by calling the helper function *)
						resolveInoculationTipWithGivenInstrument[
							sample,
							Lookup[options, InoculationTips],
							instrument,
							Automatic,
							Automatic,
							sampleVolume,
							destinationMediaContainer,
							Lookup[options, DestinationMixType],
							FrozenGlycerol,
							combinedFastAssoc
						]
					],
					{mySamples, resolvedInstruments, sampleVolumes, preResolvedDestinationMediaContainers, frozenGlycerolMapThreadFriendlyOptions}
				];

				(* Resolve TipType and TipMaterial *)
				(* TipType and TipMaterial are hidden options and basically all sterile tip types are Barrier *)
				{resolvedTipTypes, resolvedTipMaterials} = Transpose@Map[
					Function[{tip},
						If[NullQ[tip],
							{Null, Null},
							Module[{tipPacket, tipType},
								tipPacket = If[MatchQ[tip, ObjectP[Model[Item]]],
									fetchPacketFromFastAssoc[tip, combinedFastAssoc],
									fastAssocPacketLookup[combinedFastAssoc, tip, Model]
								];
								tipType = Which[
									(* All sterile tips are barrier *)
									TrueQ[Lookup[tipPacket, Filtered]], Barrier,
									TrueQ[Lookup[tipPacket, WideBore]], WideBore,
									TrueQ[Lookup[tipPacket, GelLoading]], GelLoading,
									TrueQ[Lookup[tipPacket, Aspirator]], Aspirator,
									True, Normal
								];
								{tipType, Lookup[tipPacket, Material]}
							]
						]
					],
					resolvedTips
				];

				{
					(* Error tracking variables *)
					frozenGlycerolNoPreferredLiquidMediaWarnings,
					frozenGlycerolNonLiquidMediaErrors,
					frozenGlycerolOverfillMediaErrors,
					frozenGlycerolMixMismatchErrors,
					(* Resolved options *)
					preResolvedDestinationOptions
				} = Transpose@MapThread[
					Function[{mySample, mapThreadOptions, destinationMediaContainer, tip},
						Module[
							{
								destinationMix, destinationMixType, destinationNumberOfMixes, destinationMixVolume, destinationMedia,
								mediaVolume, resolvedUnnestedDestinationOptions, frozenGlycerolNoPreferredLiquidMediaWarning, nonLiquidMediaError,
								overfillMediaError, mixMismatchOption
							},

							(* Lookup needed options *)
							(* Note:all those values should be a singleton since we have stripped nested list from them *)
							{
								destinationMix,
								destinationMixType,
								destinationNumberOfMixes,
								destinationMixVolume,
								destinationMedia,
								mediaVolume
							} = Lookup[
								mapThreadOptions,
								{
									DestinationMix,
									DestinationMixType,
									DestinationNumberOfMixes,
									DestinationMixVolume,
									DestinationMedia,
									MediaVolume
								}
							];

							(* Resolve destination options *)
							{
								resolvedUnnestedDestinationOptions,
								frozenGlycerolNoPreferredLiquidMediaWarning,
								nonLiquidMediaError,
								overfillMediaError,
								mixMismatchOption
							} = resolveInoculationDestinationOptions[
								mySample,
								{
									DestinationMedia -> destinationMedia,
									MediaVolume -> mediaVolume,
									DestinationMix -> destinationMix,
									DestinationMixType -> destinationMixType,
									DestinationNumberOfMixes -> destinationNumberOfMixes,
									DestinationMixVolume -> destinationMixVolume
								},
								destinationMediaContainer,
								tip,
								Null, (* FrozenGlycerol is solid so SampleVolume is negligible when considering OverFill error *)
								destinationMedia,
								combinedFastAssoc
							];

							(* Return necessary values *)
							{
								frozenGlycerolNoPreferredLiquidMediaWarning,
								nonLiquidMediaError,
								overfillMediaError,
								mixMismatchOption,
								resolvedUnnestedDestinationOptions
							}
						]
					],
					{mySamples, frozenGlycerolMapThreadFriendlyOptions, preResolvedDestinationMediaContainers, resolvedTips}
				];

				(* Resolve ContainerOutLabel *)
				(* The expected output is a flat list index matching to mySamples. We will re-nest them later *)
				preResolvedSampleOutLabels = resolveInoculationLabel[
					mySamples,
					SampleOutLabel,
					Lookup[suppliedFlattenedFrozenGlycerolOptions, SampleOutLabel],
					preResolvedDestinationMediaContainers,
					userSpecifiedLabels,
					currentSimulation,
					combinedFastAssoc
				];

				preResolvedContainerOutLabels = resolveInoculationLabel[
					mySamples,
					ContainerOutLabel,
					Lookup[suppliedFlattenedFrozenGlycerolOptions, ContainerOutLabel],
					preResolvedDestinationMediaContainers,
					userSpecifiedLabels,
					currentSimulation,
					combinedFastAssoc
				];

				(* Resolve destination wells using the helper function. Only one level nestiness is allowed, just call the helper *)
				{
					preResolvedDestinationWells,
					frozenGlycerolInvalidDestinationWellErrors
				} = resolveInoculationDestinationWells[
					Lookup[suppliedFlattenedFrozenGlycerolOptions, DestinationWell],
					preResolvedDestinationMediaContainers,
					preResolvedContainerOutLabels,
					combinedFastAssoc
				];

				(* Gather all FrozenGlycerol options *)
				updatedFrozenGlycerolOptions = ReplaceRule[
					suppliedFlattenedFrozenGlycerolOptions,
					{
						NumberOfSourceScrapes -> resolvedNumberOfSourceScrapes,
						DestinationMediaContainer -> preResolvedDestinationMediaContainers,
						DestinationWell -> preResolvedDestinationWells,
						DestinationMix -> Lookup[preResolvedDestinationOptions, DestinationMix],
						DestinationMixType -> Lookup[preResolvedDestinationOptions, DestinationMixType],
						DestinationNumberOfMixes -> Lookup[preResolvedDestinationOptions, DestinationNumberOfMixes],
						DestinationMixVolume -> Lookup[preResolvedDestinationOptions, DestinationMixVolume],
						DestinationMedia -> Lookup[preResolvedDestinationOptions, DestinationMedia],
						MediaVolume -> Lookup[preResolvedDestinationOptions, MediaVolume],
						InoculationTips -> resolvedTips,
						InoculationTipType -> resolvedTipTypes,
						InoculationTipMaterial -> resolvedTipMaterials,
						SampleOutLabel -> preResolvedSampleOutLabels,
						ContainerOutLabel -> preResolvedContainerOutLabels
					}
				];

				frozenGlycerolNullMismatchOptions = MapThread[
					If[MemberQ[Flatten@#2, Null],
						#1,
						Nothing
					]&,
					{
						nonNullValueRequiredOptions,
						{
							Lookup[preResolvedDestinationOptions, DestinationWell],
							Lookup[preResolvedDestinationOptions, DestinationMedia],
							Lookup[preResolvedDestinationOptions, MediaVolume],
							resolvedNumberOfSourceScrapes
						}
					}
				];

				frozenGlycerolFullyNestedOptions = Transpose@Map[
					Function[{option},
						Module[{updatedValue},
							updatedValue = MapThread[
								(#1/.Automatic -> #2)&,
								{
									Lookup[resolvedGeneralOptions, option],
									Lookup[updatedFrozenGlycerolOptions, option]
								}
							];
							option -> updatedValue
						]
					],
					nestedIndexMatchingOptions
				];
				frozenGlycerolMultipleDestinationErrors = Map[
					!EqualQ[Length[Flatten[#]], 1]&,
					Lookup[frozenGlycerolFullyNestedOptions, DestinationMediaContainer]
				];
				frozenGlycerolResolvedOptions = ReplaceRule[
					resolvedGeneralOptions,
					Join[
						Normal[KeyDrop[updatedFrozenGlycerolOptions, nestedIndexMatchingOptions], Association],
						nonFrozenGlycerolOptions,
						frozenGlycerolFullyNestedOptions
					]
				];

				{
					(*1*)frozenGlycerolResolvedOptions,
					(*2*)frozenGlycerolNullMismatchOptions,
					(*3*){},
					(*4*){},
					(* DestinationMedia related errors*)
					(*5*)frozenGlycerolNoPreferredLiquidMediaWarnings,
					(*6*)frozenGlycerolNonLiquidMediaErrors,
					(*7*)DeleteCases[frozenGlycerolOverfillMediaErrors, {}],
					(*8*)frozenGlycerolInvalidDestinationWellErrors,
					(*9*)frozenGlycerolMultipleDestinationErrors,
					(*10*)DeleteCases[frozenGlycerolMixMismatchErrors, {}],
					(* InoculationTips related errors *)
					(*11*)frozenGlycerolNoTipsFoundErrors,
					(*12*)frozenGlycerolTipConnectionMismatchErrors,
					(* FreezeDried only errors *)
					(*13*)ConstantArray[False, Length[mySamples]],
					(*14*)ConstantArray[False, Length[mySamples]],
					(*15*){},
					(*16*){},
					(*17*){},
					(*18*)ConstantArray[False, Length[mySamples]],
					(*19*)ConstantArray[False, Length[mySamples]]
				}
			],
		(* We are not resolving any more options at this point - Return Automatic as Null *)
		True,
			{
				(*1*)resolvedGeneralOptions/.Automatic->Null,
				(*2*){},
				(*3*){},
				(*4*){},
				(* DestinationMedia related errors *)
				(*5*)ConstantArray[False, Length[mySamples]],
				(*6*)ConstantArray[False, Length[mySamples]],
				(*7*){},
				(*8*)ConstantArray[False, Length[mySamples]],
				(*9*)ConstantArray[False, Length[mySamples]],
				(*10*){},
				(* InoculationTips related errors *)
				(*11*)ConstantArray[False, Length[mySamples]],
				(*12*)ConstantArray[False, Length[mySamples]],
				(* FreezeDried only errors *)
				(*13*)ConstantArray[False, Length[mySamples]],
				(*14*)ConstantArray[False, Length[mySamples]],
				(*15*){},
				(*16*){},
				(*17*){},
				(*18*)ConstantArray[False, Length[mySamples]],
				(*19*)ConstantArray[False, Length[mySamples]]
			}
	];

	(* -- CONFLICTING OPTIONS CHECKS II-- *)

	(* 6.) Check for specified options that do not correspond to the resolvedInoculationSource *)
	specifiedNullOptions = If[MatchQ[multipleSourceSampleTypes, {}],
		checkMismatchedOptionsForInoculationSource[resolvedGeneralOptions, optionDefinition, resolvedInoculationSource],
		{}
	];
	specificMixValueOptions = Which[
		MatchQ[resolvedInoculationSource, SolidMedia] && MemberQ[Flatten@Lookup[resolvedGeneralOptions, DestinationMixType], Swirl|Pipette],
			{DestinationMixType},
		MatchQ[resolvedInoculationSource, Except[SolidMedia, InoculationSourceP]] && MemberQ[Flatten@Lookup[resolvedGeneralOptions, DestinationMixType], Shake],
			{DestinationMixType},
		True,
			{}
	];
	nonDisposalFreezeDriedOptions = If[MatchQ[resolvedInoculationSource, FreezeDried] && MemberQ[resolvedSamplesInStorageCondition, Except[Disposal]],
		{SamplesInStorageCondition},
		{}
	];
	inoculationSourceOptionMismatchOptions = If[!MatchQ[multipleSourceSampleTypes, {}],
		(* If there are multipleSourceSampleTypes no need to check for this error *)
		{},
		(* Otherwise call the helper function to check the type-specific options, if any of the options not for the resolved type is specified to non-default *)
		(* Also pull out options where we should have a non-Null value but user has specified Null *)
		Join[specifiedNullOptions, nullMismatchOptions, specificMixValueOptions, nonDisposalFreezeDriedOptions]
	];

	If[Length[inoculationSourceOptionMismatchOptions] > 0 && messages,
		Module[{lastMessage},
			(* The guidance for user is different for SolidMedia case where simply updating Instrument option won't work as PickColonies is only applicable for microbial cells *)
			lastMessage = joinClauses[{
				If[!MatchQ[nullMismatchOptions, {}],
					"The following options " <> ToString[nullMismatchOptions] <> " must be set to a non-Null value when InoculationSource is " <> ToString[resolvedInoculationSource],
					Nothing
				],
				If[!MatchQ[specifiedNullOptions, {}],
					"The following options " <> ToString[specifiedNullOptions] <> " cannot be set when InoculationSource is " <> ToString[resolvedInoculationSource],
					Nothing
				],
				Which[
					!MatchQ[specificMixValueOptions, {}] && MatchQ[resolvedInoculationSource, SolidMedia],
						"The following DestinationMixType value Swirl or Pipette cannot be set when InoculationSource is SolidMedia",
					!MatchQ[specificMixValueOptions, {}],
						"The following DestinationMixType value Shake cannot be set when InoculationSource is " <> ToString[resolvedInoculationSource],
					True,
						Nothing
				],
				If[!MatchQ[nonDisposalFreezeDriedOptions, {}],
					"The following SamplesInStorageCondition value " <> ToString[DeleteDuplicates@Cases[resolvedSamplesInStorageCondition, Except[Disposal]]] <> "cannot be set when InoculationSource is FreezeDried",
					Nothing
				]
			}];
			Message[
				Error::InoculationSourceOptionMismatch,
				resolvedInoculationSource,
				inoculationSourceOptionMismatchOptions,
				lastMessage
			]
		]
	];

	(* Create a test if we are gathering tests *)
	inoculationSourceOptionMismatchTests = If[gatherTests,
		If[Length[inoculationSourceOptionMismatchOptions] > 0,
			(* If there are failing options *)
			Test["The specified options, " <> ToString[inoculationSourceOptionMismatchOptions] <> " are valid options for the specified InoculationSource:", True, False],

			(* If there are not failing options *)
			Test["The specified options are valid options for the specified InoculationSource:", True, True]
		],
		Nothing
	];

	(* DestinationMedia related errors *)
	(* 7.)NoPreferredLiquidMedia *)
	If[MemberQ[noPreferredLiquidMediaWarnings, True] && messages,
		Message[
			Warning::NoPreferredLiquidMedia,
			ObjectToString[PickList[mySamples, noPreferredLiquidMediaWarnings], Cache -> combinedCache, Simulation -> currentSimulation]
		]
	];


	(* 8.)Invalid DestinationMedia State *)
	destinationMediaStateOptions = If[MemberQ[nonLiquidDestinationMediaErrors, True] && messages,
		{DestinationMedia},
		{}
	];

	If[MemberQ[nonLiquidDestinationMediaErrors, True] && messages,
		Message[
			Error::InvalidDestinationMediaState,
			ObjectToString[PickList[mySamples, nonLiquidDestinationMediaErrors], Cache -> combinedCache, Simulation -> currentSimulation],
			"Liquid"
		]
	];

	destinationMediaStateTests = If[MemberQ[nonLiquidDestinationMediaErrors, True] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, nonLiquidDestinationMediaErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a specified DestinationMedia that has a state of nonLiquid:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a specified DestinationMedia that has a state of nonLiquid:", True, False];

			(* Return the tests *)
			{passingTest,failingTest}
		],
		Nothing
	];

	(* 9.)InvalidDestinationWell *)
	invalidDestinationWellInfo = MapThread[
		If[TrueQ[#2],
			{#1, First[Flatten@#3], First[Flatten@#4], #5},
			Nothing
		]&,
		{mySamples, invalidDestinationWellErrors, Lookup[resolvedTotalOptions, DestinationWell], Lookup[resolvedTotalOptions, DestinationMediaContainer], Range[Length[mySamples]]}
	];
	invalidDestinationWellOptions = If[MemberQ[invalidDestinationWellErrors, True] && messages,
		Message[
			Error::InvalidDestinationWell,
			ObjectToString[invalidDestinationWellInfo[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString[invalidDestinationWellInfo[[All, 2]]],
			ObjectToString[invalidDestinationWellInfo[[All, 3]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString[invalidDestinationWellInfo[[All, 4]]]
		];
		{DestinationWell},
		{}
	];

	invalidDestinationWellTests = If[MemberQ[invalidDestinationWellErrors, True] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, invalidDestinationWellErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a Destination well that is a valid Position in DestinationMediaContainer:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a Destination well that is a valid Position in DestinationMediaContainer:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 10.) DestinationMediaContainerOverfill *)
	destinationMediaContainersOverfillOptions = If[!MatchQ[overfillDestinationMediaContainerErrors, {}] && messages,
		Message[
			Error::DestinationMediaContainerOverfill,
			ObjectToString[DeleteDuplicates@overfillDestinationMediaContainerErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
			ObjectToString[overfillDestinationMediaContainerErrors[[All, 2]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString@overfillDestinationMediaContainerErrors[[All, 3]]
		];
		If[MatchQ[resolvedInoculationSource, FreezeDried|LiquidMedia],
			{DestinationMediaContainer, MediaVolume, Volume},
			{DestinationMediaContainer, MediaVolume}
		],
		{}
	];

	destinationMediaContainersOverfillTests = If[!MatchQ[overfillDestinationMediaContainerErrors, {}] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = DeleteDuplicates@overfillDestinationMediaContainerErrors[[All, 1]];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a total volume below the max vol of DestinationMediaContainer:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a total volume below the max vol of DestinationMediaContainer:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 11.) MultipleDestinationMediaContainersErrors *)
	multipleDestinationMediaContainersOptions = If[MemberQ[multipleDestinationMediaContainersErrors, True] && messages,
		Message[
			Error::MultipleDestinationMediaContainers,
			ObjectToString[PickList[mySamples, multipleDestinationMediaContainersErrors], Cache -> combinedCache, Simulation -> currentSimulation],
			resolvedInoculationSource,
			"Please specify a single value for options:DestinationWell, DestinationMedia, DestinationMediaContainer, MediaVolume, DestinationMix, DestinationMixType, DestinationNumberOfMixes or DestinationMixVolume"
		];
		{DestinationMediaContainer},
		{}
	];

	multipleDestinationMediaContainersTests = If[MemberQ[multipleDestinationMediaContainersErrors, True] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, multipleDestinationMediaContainersErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have InoculationSource->LiquidMedia/AgarStab/FrozenGlycerol and have only a single Object or single Model DestinationMediaContainer:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have InoculationSource->LiquidMedia/AgarStab/FrozenGlycerol and have only a single Object or single Model DestinationMediaContainer:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 12.)DestinationMixMismatch *)
	mixMismatchOptions = If[!MatchQ[destinationMixMismatchErrors, {}] && messages,
		Message[
			Error::DestinationMixMismatch,
			ObjectToString[destinationMixMismatchErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString@DeleteDuplicates[Flatten[destinationMixMismatchErrors[[All, 2]]]]
		];
		Join[{DestinationMix}, DeleteDuplicates[Flatten[destinationMixMismatchErrors[[All, 2]]]]],
		{}
	];

	mixMismatchTests = If[!MatchQ[destinationMixMismatchErrors, {}] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, destinationMixMismatchErrors[[All, 1]]];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have DestinationMix -> True and all DestinationMix related options properly set or DestinationMix -> False and DestinationMix related options are also set to Null:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have DestinationMix -> True and all DestinationMix related options properly set or DestinationMix -> False and DestinationMix related options are also set to Null:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 13.)noTipsFoundErrors *)
	noTipsFoundOptions = If[MemberQ[noTipsFoundErrors, True] && messages,
		Message[Error::NoTipsFound, ObjectToString[PickList[mySamples, noTipsFoundErrors], Cache -> combinedCache, Simulation -> currentSimulation]];
		{DestinationMediaContainer, InoculationTips},
		{}
	];

	noTipsFoundTests = If[MemberQ[noTipsFoundErrors, True] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, noTipsFoundErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have Tips that match TipMaterial and TipType, can reach the sample in the source container and can touch the bottom of the DestinationMediaContainer:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have Tips that match TipMaterial and TipType, can reach the sample in the source container and can touch the bottom of the DestinationMediaContainer:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 14.)tipConnectionMismatchErrors *)
	tipConnectionMismatchOptions = If[MemberQ[tipConnectionMismatchErrors, True] && messages,
		Message[Error::TipConnectionMismatch, ObjectToString[PickList[mySamples, tipConnectionMismatchErrors], Cache -> combinedCache, Simulation -> currentSimulation]];
		{Instrument, InoculationTips},
		{}
	];

	tipConnectionMismatchTests = If[MemberQ[tipConnectionMismatchErrors, True] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, tipConnectionMismatchErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " specified Instrument and InoculationTips have a compatible TipConnectionType:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " specified Instrument and InoculationTips have a compatible TipConnectionType:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(*== FreezeDried specific Errors ==*)
	(* 15.)NoPreferredLiquidMedia *)
	If[MemberQ[noPreferredResuspensionLiquidMediaWarnings, True] && messages,
		Message[
			Warning::NoPreferredLiquidMediaForResuspension,
			ObjectToString[PickList[mySamples, noPreferredResuspensionLiquidMediaWarnings], Cache -> combinedCache, Simulation -> currentSimulation]
		]
	];

	(* 16.) Invalid ResuspensionMedia State *)
	resuspensionMediaStateOptions = If[MemberQ[invalidResuspensionMediaStateErrors, True] && messages,
		Message[
			Error::InvalidResuspensionMediaState,
			ObjectToString[PickList[mySamples, invalidResuspensionMediaStateErrors], Cache -> combinedCache, Simulation -> currentSimulation]
		];
		{ResuspensionMedia},
		{}
	];

	resuspensionMediaStateTests = If[MemberQ[invalidResuspensionMediaStateErrors, True] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, invalidResuspensionMediaStateErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples,failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a specified ResuspensionMedia that has a state of Liquid:",True,True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a specified ResuspensionMedia that has a state of Liquid:",True, False];

			(* Return the tests *)
			{passingTest,failingTest}
		],
		Nothing
	];

	(* 17.) DestinationMediaContainerOverfill *)
	resuspensionMediaOverfillOptions = If[!MatchQ[resuspensionMediaOverfillErrors, {}] && messages,
		Message[
			Error::ResuspensionMediaOverfill,
			ObjectToString[DeleteDuplicates@resuspensionMediaOverfillErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
			ObjectToString[resuspensionMediaOverfillErrors[[All, 2]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString@resuspensionMediaOverfillErrors[[All, 3]],
			ObjectToString[resuspensionMediaOverfillErrors[[All, 4]], Cache -> combinedCache, Simulation -> currentSimulation]
		];
		{ResuspensionMediaVolume},
		{}
	];

	resuspensionMediaOverfillTests = If[!MatchQ[resuspensionMediaOverfillErrors, {}] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = DeleteDuplicates@resuspensionMediaOverfillErrors[[All, 1]];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a total volume below the max vol of source container after adding resuspension media:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a total volume below the max vol of source container after adding resuspension media:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 18.) FreezeDriedUnusedSample and 19.) InsufficientResuspensionMediaVolume*)
	If[!MatchQ[unusedFreezeDriedSampleErrors, {}] && messages,
		Message[
			Error::FreezeDriedUnusedSample,
			ObjectToString[DeleteDuplicates@unusedFreezeDriedSampleErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString@unusedFreezeDriedSampleErrors[[All, 2]],
			ToString@unusedFreezeDriedSampleErrors[[All, 3]],
			ObjectToString[unusedFreezeDriedSampleErrors[[All, 4]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString@unusedFreezeDriedSampleErrors[[All, 5]]
		]
	];

	If[!MatchQ[insufficientResuspensionMediaErrors, {}] && messages,
		Message[
			Error::InsufficientResuspensionMediaVolume,
			ObjectToString[DeleteDuplicates@insufficientResuspensionMediaErrors[[All, 1]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString@insufficientResuspensionMediaErrors[[All, 2]],
			ToString@insufficientResuspensionMediaErrors[[All, 3]],
			ObjectToString[insufficientResuspensionMediaErrors[[All, 4]], Cache -> combinedCache, Simulation -> currentSimulation],
			ToString@insufficientResuspensionMediaErrors[[All, 5]]
		]
	];

	freezeDriedMismatchedVolumeOptions = If[!MatchQ[unusedFreezeDriedSampleErrors, {}] || !MatchQ[insufficientResuspensionMediaErrors, {}],
		{ResuspensionMediaVolume, Volume, DestinationMediaContainer},
		{}
	];

	freezeDriedMismatchedVolumeTests = If[(!MatchQ[unusedFreezeDriedSampleErrors, {}] || !MatchQ[insufficientResuspensionMediaErrors, {}] )&& gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = Which[
				MatchQ[unusedFreezeDriedSampleErrors, {}], DeleteDuplicates[insufficientResuspensionMediaErrors[[All, 1]]],
				MatchQ[insufficientResuspensionMediaErrors, {}], DeleteDuplicates[unusedFreezeDriedSampleErrors[[All, 1]]],
				True, DeleteDuplicates[Join[unusedFreezeDriedSampleErrors[[All, 1]], insufficientResuspensionMediaErrors[[All, 1]]]]
			];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a total volume of resuspension media fully aliquot to destionation media containers:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have a total volume of resuspension media fully aliquot to destionation media containers:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];

	(* 20.) NoResuspensionMix *)
	If[MemberQ[resuspensionMixFalseWarnings, True] && messages,
		Message[Warning::NoResuspensionMix, ObjectToString[PickList[mySamples, resuspensionMixFalseWarnings], Cache -> combinedCache, Simulation -> currentSimulation]]
	];

	(* 21.)ResuspensionMixMismatch *)
	resuspensionMixMismatchOptions = If[MemberQ[resuspensionMixOptionsMismatchErrors, True] && messages,
		Message[Error::ResuspensionMixMismatch, ObjectToString[PickList[mySamples, resuspensionMixOptionsMismatchErrors], Cache -> combinedCache, Simulation -> currentSimulation]];
		{ResuspensionMix, ResuspensionMixType, NumberOfResuspensionMixes, ResuspensionMixVolume},
		{}
	];

	resuspensionMixMismatchTests = If[MemberQ[resuspensionMixOptionsMismatchErrors, True] && gatherTests,
		Module[{passingInputs, failingInputs, passingTest, failingTest},

			(* Get the failing inputs *)
			failingInputs = PickList[mySamples, resuspensionMixOptionsMismatchErrors];

			(* Get the passing inputs *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create the passing test *)
			passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have ResuspensionMix->True, or ResuspensionMix ->False while other resuspension mix options set to Null:", True, True];

			(* Create the failing test *)
			failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache, Simulation -> currentSimulation] <> " have ResuspensionMix->True, or ResuspensionMix ->False while other resuspension mix options set to Null:", True, False];

			(* Return the tests *)
			{passingTest, failingTest}
		],
		Nothing
	];
	(* 22.) VolatileHazardousSamplesInBSC *)
	mapThreadFriendlyResolvedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentInoculateLiquidMedia,resolvedTotalOptions];
	(* Blend in source and destination to mapthread friendly option list of associations *)
	inputBlendedMapThreadFriendlyOptions = MapThread[
		Function[{mySample, options},
			Append[options, Input -> mySample]
		],
		{mySamples, mapThreadFriendlyResolvedOptions}
	];

	(* Error checking for if any flammable and ventilated sample is asked to be used inside a biosafety cabinet.  This cannot be done due to the concentrated hazard. *)
	{volatileHazardousSamplesInBSCError, volatileHazardousSamplesInBSCMessage} = If[MemberQ[
		Lookup[mapThreadFriendlyResolvedOptions, TransferEnvironment],
		ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]
	],
		(* call the helper to return a list of boolean and a string of error message *)
		checkVolatileHazardousSamplesInBSCs[
			inputBlendedMapThreadFriendlyOptions,
			(* These wash solution options are for qpix, if they are specified, the transfer environment should be Null. So we are guaranteed to have triggered tons of other errors. This one is pretty downstream so don't bother.*)
			{Cache, WashSolution, SecondaryWashSolution, TertiaryWashSolution, QuaternaryWashSolution},
			TransferEnvironment,
			combinedCache
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

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[
		{
			discardedInvalidInputs,
			deprecatedSampleModelInputs,
			DeleteCases[conflictingInoculationSourceErrorInputs, Null],
			invalidModelSampleSourceInputs,
			invalidFrozenLiquidMediaInputs,
			multipleInoculationSourceInputs,
			duplicatedFreezeDriedSamples,
			invalidCellTypeSamples,
			switchInvalidInputs
		}
	]];

	invalidOptions = DeleteDuplicates[Flatten[
		{
			If[MatchQ[preparationResult, $Failed], {Preparation}, {}],
			nameInvalidOption,
			conflictingWorkCellAndPreparationOptions,
			invalidInstrumentOptions,
			instrumentCellTypeIncompatibleOptions,
			bscCellTypeIncompatibleOptions,
			inoculationSourceOptionMismatchOptions,
			switchInvalidOptions,
			destinationMediaStateOptions,
			destinationMediaContainersOverfillOptions,
			invalidDestinationWellOptions,
			multipleDestinationMediaContainersOptions,
			mixMismatchOptions,
			noTipsFoundOptions,
			tipConnectionMismatchOptions,
			resuspensionMediaStateOptions,
			resuspensionMediaOverfillOptions,
			freezeDriedMismatchedVolumeOptions,
			resuspensionMixMismatchOptions,
			(* For experiments that teh developer marks the post processing samples as Living -> True, we need to add potential failing options to invalidOptions list in order to properly fail the resolver *)
			If[MemberQ[Values[resolvedPostProcessingOptions], $Failed],
				PickList[Keys[resolvedPostProcessingOptions], Values[resolvedPostProcessingOptions], $Failed],
				Nothing],
			If[TrueQ[volatileHazardousSamplesInBSCError],
				{TransferEnvironment},
				{}
			]
		}
	]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	(* NOTE: Quiet General::stop when throwing InvalidInput/InvalidOptions because they do not get quieted in ModifyFunctionMessages *)
	Quiet[
		If[Length[invalidInputs] > 0 && !gatherTests,
			Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> combinedCache]]
		],
		General::stop
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	(* NOTE: Quiet General::stop when throwing InvalidInput/InvalidOptions because they do not get quieted in ModifyFunctionMessages *)
	Quiet[
		If[Length[invalidOptions] > 0 && !gatherTests,
			Message[Error::InvalidOption, invalidOptions]
		],
		General::stop
	];

	(* Get all the tests together. *)
	allTests = Cases[Flatten[{
		preparationTest,
		discardedTest,
		deprecatedTest,
		conflictingInoculationSourceErrorTest,
		conflictingInoculationSourceWarningTest,
		multipleInoculationSourceInInputTests,
		duplicatedFreezeDriedSamplesTests,
		invalidModelSampleSourceInputTests,
		invalidFrozenLiquidMediaInputTests,
		invalidCellTypeTest,
		optionPrecisionTests,
		nameInvalidTest,
		conflictingWorkCellAndPreparationTest,
		invalidInstrumentTests,
		instrumentCellTypeIncompatibleTests,
		bscCellTypeIncompatibleTests,
		inoculationSourceOptionMismatchTests,
		destinationMediaStateTests,
		destinationMediaContainersOverfillTests,
		multipleDestinationMediaContainersTests,
		invalidDestinationWellTests,
		mixMismatchTests,
		noTipsFoundTests,
		tipConnectionMismatchTests,
		resuspensionMediaStateTests,
		resuspensionMediaOverfillTests,
		freezeDriedMismatchedVolumeTests,
		resuspensionMixMismatchTests,
		volatileHazardousSamplesInBSCTest,
		If[gatherTests,
			postProcessingTests[resolvedPostProcessingOptions],
			Nothing
		]
	}], TestP];

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> resolvedTotalOptions,
		Tests -> allTests
	}
];


(* ::Subsection:: *)
(*Resource Packets*)
DefineOptions[inoculateLiquidMediaResourcePackets,
	Options :> {
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

inoculateLiquidMediaResourcePackets[
	mySamples: {ObjectP[Object[Sample]]..},
	myUnresolvedOptions: {_Rule...},
	myResolvedOptions: {_Rule...},
	ops: OptionsPattern[inoculateLiquidMediaResourcePackets]
] := Module[
	{
		unresolvedOptionsNoHidden, resolvedOptionsNoHidden, safeOps, outputSpecification, output, gatherTests, messages,
		inheritedCache, inheritedFastAssoc, simulation, currentSimulation, resolvedPreparation, resolvedInoculationSource,
		parentProtocol, protocolPacket, unitOperationPackets, batchedUnitOperationPackets, roboticRunTime,
		(* FRQ and Return *)
		rawResourceBlobs, resourcesWithoutName, resourceToNameReplaceRules, allResourceBlobs, fulfillable, frqTests,
		previewRule, optionsRule, resultRule, testsRule
	},

	(* Get the collapsed unresolved index-matching options that don't include hidden options *)
	unresolvedOptionsNoHidden = RemoveHiddenOptions[ExperimentInoculateLiquidMedia, myUnresolvedOptions];

	(* Get the collapsed resolved index-matching options that don't include hidden options *)
	(* Ignore to collapse those options that are set in expandedsafeoptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentInoculateLiquidMedia,
		RemoveHiddenOptions[ExperimentInoculateLiquidMedia, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Get the safe options for this function *)
	safeOps = SafeOptions[inoculateLiquidMediaResourcePackets, ToList[ops]];

	(* Determine the requested output format of this function *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Get the inherited cache *)
	{inheritedCache, simulation} = Lookup[safeOps, {Cache, Simulation}, {}];

	(* Make the fast association *)
	inheritedFastAssoc = makeFastAssocFromCache[inheritedCache];

	(* Initialize the simulation if it does not exist *)
	currentSimulation = If[MatchQ[simulation, SimulationP],
		simulation,
		Simulation[]
	];

	(* Get the resolved preparation options *)
	{
		resolvedPreparation,
		resolvedInoculationSource,
		parentProtocol
	} = Lookup[
		myResolvedOptions,
		{
			Preparation,
			InoculationSource,
			ParentProtocol
		}
	];

	(* Case on resolvedPreparation and InoculationSource *)
	{protocolPacket, unitOperationPackets, batchedUnitOperationPackets, currentSimulation, roboticRunTime} = Which[
		(* If we are Manual and LiquidMedia/AgarStab/FreezeDried/FrozenGlycerol *)
		MatchQ[resolvedPreparation, Manual],
			Module[
				{
					nestedDestinationMediaContainers, expandedInstruments, expandedTransferEnvironments, expandedVolumes,
					flattenedDestinationWells, expandedTips, expandedTipTypes, expandedTipMaterials, expandedSourceMixes,
					expandedSourceMixTypes, expandedNumberOfSourceMixes, expandedSourceMixVolumes, flattenedDestinationMediaContainers,
					flattenedDestinationMixes, flattenedDestinationMixTypes, flattenedDestinationNumberOfMixes, flattenedDestinationMixVolumes,
					flattenedMediaVolumes, flattenedDestinationMedium, expandedResuspensionMixes, expandedResuspensionMixTypes,
					expandedNumberOfResuspensionMixes, expandedResuspensionMixVolumes, expandedResuspensionMedium,
					expandedResuspensionMediaVolumes, expandedNumberOfSourceScrapes, flattenedSampleOutLabels, flattenedContainerOutLabels, 
					expandedSampleLabels, expandedSampleContainerLabels, flattenedSamplesOutStorageConditions, expandedSamplesInStorageConditions, 
					expandedSamplesIn, sampleContainerObjects, tipPackets, flattenedTipPackets, combinedFastAssoc, samplesInResources, 
					containersIn, uniqueContainersIn, containersInResources, transferEnvironmentResources, allSharedInstruments,
					sharedInstrumentResources, instrumentResources, allTips, talliedTips, tipToResourceListLookup, popTipResource,
					tipResources, uniqueDestinationContainerObjects, destinationContainerObjectResourceLookup,
					destinationContainerResources, destMediaContainerFootprints, destMediaContainerPackets, combinedCache,
					plateSealToUse, containersToBeUsedInBSC, capRackResourcesForBSC, prepPacket
				},

				(* --- Expansion and Flatten for Multiple DestinationMediaContainer  --- *)
				(* Note that the Multiple DestinationMediaContainer in this experiment do not result in a greater number of SamplesIn, but we still *)
				(* expand the samples initially to preserve index-matching. We need to then expand a particular subset (non-nested indexmatching) of options. *)
				(* We need to expand certain options according to the number of DestinationMediaContainer; use the following helper function to do this. *)
				(* For example, we have {s1,s2} and DestinationMediaContainer {{container1,container2},{container3}} and SourceMix {True,False}. *)
				(* After the helper, non-nested option value SourceMix should be {True,True,False} and DestinationMediaContainer should be {container1,container2,container3} *)
				expandAndFlattenOptions[
					myOptions:{__Rule},
					myOptionNames:{__Symbol},
					myDestinationMediaContainers: {ListableP[ObjectP[{Model[Container], Object[Container]}]]..}
				] := Module[
					{nestedIndexMatchingOptions},
					(* We have below options nested indexmatching. *)
					nestedIndexMatchingOptions = {
						SamplesOutStorageCondition, SampleOutLabel, ContainerOutLabel,
						(* Media Preparation options *)
						DestinationMix, DestinationMixType, DestinationNumberOfMixes,
						DestinationMixVolume, MediaVolume, DestinationMedia, DestinationMediaContainer, DestinationWell
					};
					Map[
						Function[{optionName},
							Flatten@MapThread[
								Function[{optionValue, destinationMediaContainerList},
									If[MemberQ[nestedIndexMatchingOptions, optionName] || Length[destinationMediaContainerList] == 1,
										(* For options that are nestedIndexMatchingOptions, simply flatten the value *)
										(* If only 1 destinationMediaContainer exists, no need to expand *)
										optionValue,
										(* For options that are not nestedIndexMatchingOptions, we need to expand it if multiple destinationMediaContainer exist *)
										ConstantArray[optionValue, Length[destinationMediaContainerList]]
									]
								],
								{Lookup[myOptions, optionName], myDestinationMediaContainers}
							]
						],
						myOptionNames
					]
				];

				nestedDestinationMediaContainers = Lookup[myResolvedOptions, DestinationMediaContainer];

				(* Flatten nested-indexmatching options and Expand the index-matched options using helper *)
				{
					(*1*)expandedInstruments,
					(*2*)expandedTransferEnvironments,
					(*3*)expandedVolumes,
					(*4*)flattenedDestinationWells,
					(*5*)expandedTips,
					(*6*)expandedTipTypes,
					(*7*)expandedTipMaterials,
					(*8*)expandedSourceMixes,
					(*9*)expandedSourceMixTypes,
					(*10*)expandedNumberOfSourceMixes,
					(*11*)expandedSourceMixVolumes,
					(*12*)flattenedDestinationMediaContainers,
					(*13*)flattenedDestinationMixes,
					(*14*)flattenedDestinationMixTypes,
					(*15*)flattenedDestinationNumberOfMixes,
					(*16*)flattenedDestinationMixVolumes,
					(*17*)flattenedMediaVolumes,
					(*18*)flattenedDestinationMedium,
					(*19*)expandedResuspensionMixes,
					(*20*)expandedResuspensionMixTypes,
					(*21*)expandedNumberOfResuspensionMixes,
					(*22*)expandedResuspensionMixVolumes,
					(*23*)expandedResuspensionMedium,
					(*24*)expandedResuspensionMediaVolumes,
					(*25*)expandedNumberOfSourceScrapes,
					(*26*)flattenedSampleOutLabels,
					(*27*)flattenedContainerOutLabels,
					(*28*)expandedSampleLabels,
					(*29*)expandedSampleContainerLabels,
					(*30*)flattenedSamplesOutStorageConditions,
					(*31*)expandedSamplesInStorageConditions
				} = expandAndFlattenOptions[
					myResolvedOptions,
					{
						(*1*)Instrument,
						(*2*)TransferEnvironment,
						(*3*)Volume,
						(*4*)DestinationWell,
						(*5*)InoculationTips,
						(*6*)InoculationTipType,
						(*7*)InoculationTipMaterial,
						(*8*)SourceMix,
						(*9*)SourceMixType,
						(*10*)NumberOfSourceMixes,
						(*11*)SourceMixVolume,
						(*12*)DestinationMediaContainer,
						(*13*)DestinationMix,
						(*14*)DestinationMixType,
						(*15*)DestinationNumberOfMixes,
						(*16*)DestinationMixVolume,
						(*17*)MediaVolume,
						(*18*)DestinationMedia,
						(*19*)ResuspensionMix,
						(*20*)ResuspensionMixType,
						(*21*)NumberOfResuspensionMixes,
						(*22*)ResuspensionMixVolume,
						(*23*)ResuspensionMedia,
						(*24*)ResuspensionMediaVolume,
						(*25*)NumberOfSourceScrapes,
						(*26*)SampleOutLabel,
						(*27*)ContainerOutLabel,
						(*28*)SampleLabel,
						(*29*)SampleContainerLabel,
						(*30*)SamplesOutStorageCondition,
						(*31*)SamplesInStorageCondition
					},
					nestedDestinationMediaContainers
				];

				(* Expand the samples according to nestedDestinationMediaContainers *)
				expandedSamplesIn = Flatten[MapThread[
					ConstantArray[#1, Length[#2]]&,
					{Download[ToList[mySamples], Object], nestedDestinationMediaContainers}
				]];

				(* If we are doing manual we can either have a Liquid-Liquid transfer (LiquidMedia, FreezeDried) or an Solid-Liquid transfer (AgarStab, FrozenGlycerol) *)
				(* Either way we will make an Object[Protocol,InoculateLiquidMedia] *)

				(* Download information *)
				(* Split the destination containers into models and objects *)
				{
					sampleContainerObjects,
					tipPackets,
					destMediaContainerPackets
				} = Quiet[
					Download[
						{
							expandedSamplesIn,
							expandedTips,
							flattenedDestinationMediaContainers
						},
						{
							{
								Packet[Container[Object]]
							},
							{
								Packet[NumberOfTips]
							},
							{
								Packet[Model[Footprint]],
								Packet[Footprint, Model]
							}
						},
						Cache -> inheritedCache,
						Simulation -> currentSimulation
					],
					{Download::FieldDoesntExist}
				];

				(* Flatten the tip packets *)
				flattenedTipPackets = FlattenCachePackets[tipPackets];

				(* Create a fast assoc *)
				combinedCache = FlattenCachePackets[{tipPackets, destMediaContainerPackets, inheritedCache}];
				combinedFastAssoc = makeFastAssocFromCache[combinedCache];

				(* Create the resources *)

				(* 1. Make resources for our SamplesIn *)
				samplesInResources = If[MatchQ[resolvedInoculationSource, LiquidMedia],
					(* For Liquid media, only require the amount specified in Volume *)
					Module[
						{
							samplesInVolumesRequired, samplesInAndVolumes, samplesInResourceReplaceRules
						},
						(* Calculate the total volume we need of each sample in. It is just the volume we are transferring  *)
						samplesInVolumesRequired = expandedVolumes;

						(* Pair up each sample with its volume *)
						samplesInAndVolumes = Merge[MapThread[Association[#1 -> #2]&, {expandedSamplesIn, samplesInVolumesRequired}], Total];

						(* Create a resource rule for each unique sample *)
						samplesInResourceReplaceRules = KeyValueMap[Function[{sample, volume},
							If[MatchQ[volume, All],
								sample -> Resource[Sample -> sample, Name -> CreateUUID[]],
								sample -> Resource[Sample -> sample, Amount -> volume, Name -> CreateUUID[]]
							]
						],
							samplesInAndVolumes
						];

						(* Use the replace rules *)
						expandedSamplesIn/.samplesInResourceReplaceRules
					],
					(* For AgarStab, FreezeDried and FrozenGlycerol, no amount is specified. Whole tubes are needed. *)
					Module[
						{
							samplesInResourceReplaceRules
						},
						(* Create a resource rule for each unique sampleIn *)
						samplesInResourceReplaceRules = (# -> Resource[Sample -> #, Name -> CreateUUID[]])& /@ DeleteDuplicates[expandedSamplesIn];

						(* Use the replace rules *)
						expandedSamplesIn/.samplesInResourceReplaceRules
					]
				];

				(* 2. Make Resources for our ContainersIn *)
				(* Note:we could have duplicated container packet inside of sampleContainerObjects, do not call FlattenCachePackets which remove duplicated packets *)
				containersIn = Lookup[Flatten[sampleContainerObjects], Object];

				(* get the unique container in *)
				uniqueContainersIn = DeleteDuplicates[containersIn];

				containersInResources = Module[
					{containersInResourceReplaceRules},
					(* Create a resource rule for each unique containerIn *)
					containersInResourceReplaceRules = (# -> Resource[Sample -> #, Name -> CreateUUID[]])& /@ uniqueContainersIn;

					(* Use the replace rules *)
					containersIn /. containersInResourceReplaceRules
				];

				(* 3. Create TransferEnvironment Resources *)
				(* If multiple transfer environment resources are the same back to back, they should be the same resource object for BSCs. *)
				(* This is because only 1 operator can use a BSC at the same time. *)
				transferEnvironmentResources = Module[{splitTransferEnvironments},

					(* Get runs of the same BSC's *)
					splitTransferEnvironments = Split[Download[expandedTransferEnvironments, Object]];

					(* Map over the runs of BSC's *)
					Flatten@Map[
						Function[{transferEnvironmentList},
							ConstantArray[
								Resource[
									Instrument -> First[transferEnvironmentList],
									Time -> 10 * Minute * Length[transferEnvironmentList],
									Name -> CreateUUID[]
								],
								Length[transferEnvironmentList]
							]
						],
						splitTransferEnvironments
					]
				];

				(* 4. Create Instrument Resources *)
				allSharedInstruments = Download[Cases[
					expandedInstruments,
					ObjectP[{Model[Instrument, Pipette], Object[Instrument, Pipette]}]
				], Object];

				sharedInstrumentResources = (
					Download[#, Object] -> Resource[Instrument -> #, Name -> CreateUUID[], Time -> (5 Minute + (5 Minute * Count[allSharedInstruments, ObjectP[#]]))]&
				) /@ DeleteDuplicates[allSharedInstruments];

				instrumentResources = expandedInstruments /. sharedInstrumentResources;

				(* 5. Create tip resources  *)
				(* Create resources for all of the tips. *)
				(* NOTE: We only take into account tip box partitioning in the Manual case because in the Robotic case, the framework handles it *)
				(* for us by replacing our tip resources in-situ. *)
				(* Note:though SamplesIn is expanded when multiple DestinationMediaContainers exist, resuspension still only happen once *)
				allTips = If[MatchQ[resolvedInoculationSource, FreezeDried],
					(* ExperimentTransfer requires each transfer manipulation uses a fresh tip *)
					(* If we are working with freeze-dried cells, for each unique sample, each resolved tip model is used 1 time resuspension and number of DestinationMediaContainers for each final placement *)
					Flatten@MapThread[
						ConstantArray[#2, 1+Length[#3]]&,
						{mySamples, Lookup[myResolvedOptions, InoculationTips], Lookup[myResolvedOptions, DestinationMediaContainer]}
					],
					Download[Cases[expandedTips, ObjectP[{Model[Item, Tips], Object[Item, Tips]}]], Object]
				];
				talliedTips = Tally[allTips];

				tipToResourceListLookup = Association@Map[
					Function[{tipInformation},
						Module[{tipObject, numberOfTipsNeeded, numberOfTipsPerBox},
							(* Pull out from our tip information. *)
							tipObject = tipInformation[[1]];
							numberOfTipsNeeded = tipInformation[[2]];

							(* Lookup the number of tips per box. *)
							(* NOTE: This can be one if they're individually wrapped. *)
							numberOfTipsPerBox = (Lookup[fetchPacketFromCache[tipObject, flattenedTipPackets], NumberOfTips] /. {Null | $Failed -> 1});

							(* Return a list that we will pop off of everytime we take a tip. *)
							(* NOTE: If NumberOfTips->1, that means that this tip model is individually wrapped and we shouldn't include *)
							(* the Amount key in the resource. *)
							Download[tipObject, Object] -> If[MatchQ[numberOfTipsPerBox, 1],
								Table[
									Resource[
										Sample -> tipObject,
										Name -> CreateUUID[]
									],
									{x, 1, numberOfTipsNeeded}
								],
								Flatten@{
									Table[ (* Resources for full boxes of tips. *)
										ConstantArray[
											Resource[
												Sample -> tipObject,
												Amount -> numberOfTipsPerBox,
												Name -> CreateUUID[]
											],
											numberOfTipsPerBox
										],
										{x, 1, IntegerPart[numberOfTipsNeeded / numberOfTipsPerBox]}
									],
									ConstantArray[ (* Resources for the tips in the non-full box. *)
										Resource[
											Sample -> tipObject,
											Amount -> Mod[numberOfTipsNeeded, numberOfTipsPerBox],
											Name -> CreateUUID[]
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
				popTipResource[tipObject_] := Module[{oldResourceList},
					If[MatchQ[tipObject, Null],
						Null,
						oldResourceList = Lookup[tipToResourceListLookup, Download[tipObject, Object]];

						tipToResourceListLookup[Download[tipObject, Object]] = Rest[oldResourceList];

						First[oldResourceList]
					]
				];

				(* Use the helper and resource list to get the resources *)
				tipResources = popTipResource /@ expandedTips;

				(* 6. Create DestinationContainer Resources *)
				uniqueDestinationContainerObjects = DeleteDuplicates[Cases[flattenedDestinationMediaContainers, ObjectP[Object[Container]]]];

				destinationContainerObjectResourceLookup = # -> Resource[Sample -> #, Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]]& /@ uniqueDestinationContainerObjects;

				destinationContainerResources = Map[
					Function[{container},
						If[MatchQ[container, ObjectP[Object[Container]]],
							container /. destinationContainerObjectResourceLookup,
							Resource[Sample -> container, Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]]
						]
					],
					flattenedDestinationMediaContainers
				];

				(* decide if we want to use a special plate seal or not *)
				destMediaContainerFootprints = Map[
					Switch[#,
						ObjectP[Object[Container]], fastAssocLookup[combinedFastAssoc, #, {Model, Footprint}],
						ObjectP[Model[Container]], fastAssocLookup[combinedFastAssoc, #, Footprint],
						_, Null
					]&,
					flattenedDestinationMediaContainers
				];
				plateSealToUse = If[MemberQ[destMediaContainerFootprints, Plate],
					Model[Item, PlateSeal, "id:BYDOjvG74Abm"], (* Model[Item, PlateSeal, "AeraSeal Plate Seal, Breathable Sterile"] *)
					Null
				];

				(* Create a resources for cap racks if we are working in a BSC *)
				(* Generate a list of containers (in the format of object or model) to be used to estimate cap rack resources. *)
				containersToBeUsedInBSC = If[MatchQ[resolvedInoculationSource, FreezeDried],
					(*If we are working with freeze-dried samples, we also need to include one for resuspension media. *)
					(* But as we do not have ResuspensionMediaContainer options, and more likely than not it will be using a cap, a place holder container is put here for every unique Model[Sample] or Object[Sample]*)
					Cases[Flatten[
						{
							fastAssocLookup[combinedFastAssoc, mySamples, Container],
							ConstantArray[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Length[DeleteDuplicates[expandedResuspensionMedium]]], (*"50mL Tube"*)
							flattenedDestinationMediaContainers
						}
					], ObjectP[]],
					(* For other source types, we just have source and destination containers *)
					Cases[Flatten[{fastAssocLookup[combinedFastAssoc, mySamples, Container], flattenedDestinationMediaContainers}], ObjectP[]]
				];

				(* Call the helper function to generate the caprack resources if containersToBeUsedInBSC is not empty *)
				capRackResourcesForBSC = If[!MatchQ[containersToBeUsedInBSC, {}],
					estimateCapRackResources[containersToBeUsedInBSC, combinedFastAssoc],
					(* Otherwise we are not working in BSC as the containersToBeUsedInBSC is empty *)
					{}
				];

				(* Get our sample prep fields. *)
				prepPacket = KeyDrop[
					populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> inheritedCache, Simulation -> currentSimulation],
					{Replace[SamplesInStorage], Replace[SamplesOutStorage]}
				];

				(* Switch on InoculationSource and create the protocol packet *)
				Switch[resolvedInoculationSource,
					LiquidMedia,
					Module[{inoculateProtocolPacket, mediaResources, sanitizedResolvedVolumes},

						(* Create DestinationMedia Resources *)
						(* call the helper function to generate media resource for destination media*)
						mediaResources = generateMediaResources[myResolvedOptions, DestinationMedia, MediaVolume, "ExperimentInoculateLiquidMedia"];

						(* Translate All in resolvedVolume to sample volume, so that the field TransferVolumes have a VolumeP to work with *)
						sanitizedResolvedVolumes = MapThread[
							Function[{sample, volume},
								(*If resolved volume is All and sample has a volume in combined fast assoc, use the sample volume*)
								If[MatchQ[volume, All] && MatchQ[fastAssocLookup[combinedFastAssoc, sample, Volume], VolumeP],
									fastAssocLookup[combinedFastAssoc, sample, Volume],
									(*Otherwise use as is*)
									volume
								]
							],
							{expandedSamplesIn, expandedVolumes}
						];

						(* Create the protocol packet *)
						inoculateProtocolPacket = <|

							(* General *)
							Object -> CreateID[Object[Protocol, InoculateLiquidMedia]],
							Type -> Object[Protocol, InoculateLiquidMedia],
							Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
							Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
							ParentProtocol -> If[MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]],
								Link[parentProtocol, Subprotocols]
							],
							Name -> Lookup[myResolvedOptions, Name],

							(* Organizational Information *)
							Author -> If[MatchQ[parentProtocol, Null],
								Link[$PersonID, ProtocolsAuthored]
							],

							(* Options Handling *)
							UnresolvedOptions -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia, myUnresolvedOptions],
							ResolvedOptions -> myResolvedOptions,

							(* Resources *)
							Replace[Checkpoints] -> {
								{"Picking Resources", 15 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 45 Minute]]},
								{"Performing Transfers", inoculateLiquidMediaRunTime[mySamples], "Cells are transferred.", Link[Resource[Operator -> $BaselineOperator, Time -> 3 Hour]]},
								{"Sample Post-Processing", 30 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
								{"Returning Materials", 15 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]}
							},

							(* Sample Storage *)
							Replace[SamplesInStorageCondition] -> expandedSamplesInStorageConditions,
							Replace[SamplesOutStorageCondition] -> flattenedSamplesOutStorageConditions,

							(* General *)
							InoculationSource -> resolvedInoculationSource,
							Replace[TransferEnvironments] -> Link /@ transferEnvironmentResources,
							Replace[Instruments] -> Link /@ instrumentResources,

							(* Cell Inoculation Transfer *)
							Replace[InoculationTips] -> Link /@ tipResources,
							Replace[InoculationTipTypes] -> expandedTipTypes,
							Replace[InoculationTipMaterials] -> expandedTipMaterials,
							Replace[TransferVolumes] -> sanitizedResolvedVolumes,
							Replace[SourceMixTypes] -> expandedSourceMixTypes,
							Replace[NumberOfSourceMixes] -> expandedNumberOfSourceMixes,
							Replace[SourceMixVolumes] -> expandedSourceMixVolumes,

							(* Unused fields specific to other InoculationSourceTypes *)
							Replace[NumberOfSourceScrapes] -> Null,
							Replace[ResuspensionMedia] -> Null,
							Replace[ResuspensionMediaVolumes] -> Null,
							Replace[ResuspensionMixTypes] -> Null,
							Replace[NumberOfResuspensionMixes] -> Null,
							Replace[ResuspensionMixVolumes] -> Null,

							(* Deposit *)
							Replace[DestinationMedia] -> Link /@ Flatten[mediaResources],
							Replace[MediaVolumes] -> flattenedMediaVolumes,
							Replace[DestinationMediaContainers] -> Link /@ destinationContainerResources,
							Replace[DestinationWells] -> flattenedDestinationWells,
							Replace[DestinationMixTypes] -> flattenedDestinationMixTypes,
							Replace[DestinationNumberOfMixes] -> flattenedDestinationNumberOfMixes,
							Replace[DestinationMixVolumes] -> flattenedDestinationMixVolumes,

							(* Additional Resources *)
							Replace[CapRacks] -> Link /@ capRackResourcesForBSC,
							PlateSeal -> Link[plateSealToUse],

							(* PostProcessing *)
							MeasureVolume -> False,
							ImageSample -> False,
							MeasureWeight -> False
						|>;

						(* Return the protocol packet *)
						{
							inoculateProtocolPacket,
							Null,
							Null,
							currentSimulation,
							Null
						}
					],
					AgarStab,
					Module[
						{
							mediaResources, wasteBinResources, wasteBagResources,
							setUpTransferEnvironmentBoolsAgarStab, tearDownTransferEnvironmentBoolsAgarStab, pipetteReleaseBoolsAgarStab,
							tipReleaseBoolsAgarStab, coverSamplesInBoolsAgarStab, coverDestinationContainerBoolsAgarStab, resourcesNotToPickUpFrontAgarStab,
							wasteBinPlacementsAgarStab, wasteBagPlacementsAgarStab, wasteBinTeardownsAgarStab, wasteBagTeardownsAgarStab,
							inoculateProtocolPacket, fullInoculateProtocolPacket
						},

						(* Create DestinationMedia Resources *)
						(* call the helper function to generate media resource for destination media and resuspension media *)
						mediaResources = generateMediaResources[myResolvedOptions, DestinationMedia, MediaVolume, "ExperimentInoculateLiquidMedia"];

						(* Create waste bin and waste bag resources *)
						{
							wasteBinResources,
							wasteBagResources
						} = generateBSCWasteResources[myResolvedOptions, AgarStab, inheritedFastAssoc];

						(* Determine the RequiredObjects and RequiredResources - we do not want to pick all of the resources up front because some will already be inside the BSCs *)
						(* Right now, these only include pipettes and pipette tips *)
						(* if we're in the BSC/glove box since we stash pipettes in these transfer environments. *)
						(* NOTE: We do this at experiment time to try to avoid any un-linking of resources at experiment time. *)
						(* This can be a little inaccurate since things can change between experiment and procedure time but generally, *)
						(* we don't expect the types of pipettes to change. Additionally, the operator is still given free-reign to *)
						(* pick whatever they want so they can still pick something from the VLM if there aren't enough stashed in the box. *)

						{
							setUpTransferEnvironmentBoolsAgarStab,
							tearDownTransferEnvironmentBoolsAgarStab,
							pipetteReleaseBoolsAgarStab,
							tipReleaseBoolsAgarStab,
							coverSamplesInBoolsAgarStab,
							coverDestinationContainerBoolsAgarStab,
							resourcesNotToPickUpFrontAgarStab,
							wasteBinPlacementsAgarStab,
							wasteBagPlacementsAgarStab,
							wasteBinTeardownsAgarStab,
							wasteBagTeardownsAgarStab
						} = generateTransferEnvironmentDeveloperInfo[
							myResolvedOptions,
							transferEnvironmentResources,
							instrumentResources,
							tipResources,
							samplesInResources,
							destinationContainerResources,
							wasteBinResources,
							wasteBagResources,
							combinedFastAssoc
						];

						(* Create the protocol packet *)
						inoculateProtocolPacket = <|

							(* General *)
							Object -> CreateID[Object[Protocol, InoculateLiquidMedia]],
							Type -> Object[Protocol, InoculateLiquidMedia],
							Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
							Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
							ParentProtocol -> If[MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]],
								Link[parentProtocol, Subprotocols]
							],
							Name -> Lookup[myResolvedOptions, Name],

							(* Organizational Information *)
							Author -> If[MatchQ[parentProtocol, Null],
								Link[$PersonID, ProtocolsAuthored]
							],

							(* Options Handling *)
							UnresolvedOptions -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia, myUnresolvedOptions],
							ResolvedOptions -> myResolvedOptions,

							(* Resources *)
							Replace[Checkpoints] -> {
								{"Picking Resources", 15 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 45 Minute]]},
								{"Performing Inoculations", 5 Minute * Length[mySamples], "The Inoculations are performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 3 Hour]]},
								{"Returning Materials", 15 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]}
							},

							(* Sample Storage *)
							Replace[SamplesInStorageCondition] -> expandedSamplesInStorageConditions,
							Replace[SamplesOutStorageCondition] -> flattenedSamplesOutStorageConditions,

							(* General *)
							InoculationSource -> resolvedInoculationSource,
							Replace[TransferEnvironments] -> Link /@ transferEnvironmentResources,
							Replace[Instruments] -> Link /@ instrumentResources,

							(* Inoculation Transfer *)
							Replace[InoculationTips] -> Link /@ tipResources,
							Replace[InoculationTipTypes] -> expandedTipTypes,
							Replace[InoculationTipMaterials] -> expandedTipMaterials,

							(* Unused fields specific to other InoculationSourceTypes *)
							Replace[NumberOfSourceScrapes] -> Null,
							Replace[ResuspensionMedia] -> Null,
							Replace[ResuspensionMediaVolumes] -> Null,
							Replace[ResuspensionMixTypes] -> Null,
							Replace[NumberOfResuspensionMixes] -> Null,
							Replace[ResuspensionMixVolumes] -> Null,
							Replace[TransferVolumes] -> Null,
							Replace[SourceMixTypes] -> Null,
							Replace[NumberOfSourceMixes] -> Null,
							Replace[SourceMixVolumes] -> Null,

							(* Deposit *)
							Replace[DestinationMedia] -> Link /@ Flatten[mediaResources],
							Replace[MediaVolumes] -> flattenedMediaVolumes,
							Replace[DestinationMediaContainers] -> Link /@ destinationContainerResources,
							Replace[DestinationWells] -> flattenedDestinationWells,
							Replace[DestinationMixTypes] -> flattenedDestinationMixTypes,
							Replace[DestinationNumberOfMixes] -> flattenedDestinationNumberOfMixes,
							Replace[DestinationMixVolumes] -> flattenedDestinationMixVolumes,

							(* Developer *)
							Replace[SetUpTransferEnvironments] -> setUpTransferEnvironmentBoolsAgarStab,
							Replace[TearDownTransferEnvironments] -> tearDownTransferEnvironmentBoolsAgarStab,
							Replace[ReleaseInstruments] -> pipetteReleaseBoolsAgarStab,
							Replace[ReleaseTips] -> tipReleaseBoolsAgarStab,
							Replace[CoverSamplesIns] -> coverSamplesInBoolsAgarStab,
							Replace[CoverDestinationContainers] -> coverDestinationContainerBoolsAgarStab,
							Replace[WasteBins] -> Link /@ wasteBinResources,
							Replace[WasteBags] -> Link /@ wasteBagResources,
							Replace[BiosafetyWasteBinPlacements] -> wasteBinPlacementsAgarStab,
							Replace[BiosafetyWasteBagPlacements] -> wasteBagPlacementsAgarStab,
							Replace[BiosafetyWasteBinTeardowns] -> wasteBinTeardownsAgarStab,
							Replace[BiosafetyWasteBagTeardowns] -> wasteBagTeardownsAgarStab,
							Replace[CapRacks] -> Link /@ capRackResourcesForBSC,
							PlateSeal -> Link[plateSealToUse],

							(* PostProcessing *)
							MeasureVolume -> False,
							ImageSample -> False,
							MeasureWeight -> False
						|>;

						(* Add the RequiredObjects and RequiredInstruments Keys *)
						fullInoculateProtocolPacket = addRequiredInoculateObjectInstruments[inoculateProtocolPacket, resourcesNotToPickUpFrontAgarStab];

						(* Return the protocol packet *)
						{
							Join[fullInoculateProtocolPacket, prepPacket],
							Null,
							Null,
							currentSimulation,
							Null
						}
					],
					FreezeDried,
					Module[
						{
							mediaResources, resuspensionMediaResources, sanitizedResolvedVolumes, setUpTransferEnvironmentBoolsFreezeDried, tearDownTransferEnvironmentBoolsFreezeDried,
							pipetteReleaseBoolsFreezeDried, tipReleaseBoolsFreezeDried, coverSamplesInBoolsFreezeDried, coverDestinationContainerBoolsFreezeDried,
							wasteBinPlacementsFreezeDried, wasteBagPlacementsFreezeDried, wasteBinTeardownsFreezeDried, wasteBagTeardownsFreezeDried,
							resourcesNotToPickUpFrontFreezeDried, inoculateProtocolPacket, fullInoculateProtocolPacket
						},

						(* Create DestinationMedia Resources *)
						(* call the helper function to generate media resource for destination media and resuspension media *)
						mediaResources = generateMediaResources[myResolvedOptions, DestinationMedia, MediaVolume, "ExperimentInoculateLiquidMedia"];
						resuspensionMediaResources = generateMediaResources[myResolvedOptions, ResuspensionMedia, ResuspensionMediaVolume, "ExperimentInoculateLiquidMedia"];

						(*Translate All in resolvedVolume to sample volume, so that the field TransferVolumes have a VolumeP to work with*)
						sanitizedResolvedVolumes = MapThread[
							Function[{sample, volume, resuspensionVolume},
								(*If resolved volume is All and resuspensionMediaVolume is a volume (which should always be true for freeze-dried sample)*)
								If[MatchQ[volume, All] && MatchQ[resuspensionVolume, VolumeP],
									resuspensionVolume,
									(*Otherwise use as is*)
									volume
								]
							],
							{expandedSamplesIn, expandedVolumes, expandedResuspensionMediaVolumes}
						];

						(* Determine the RequiredObjects and RequiredResources - we do not want to pick all of the resources up front because some will already be inside the BSCs *)
						(* Right now, these only include pipettes and pipette tips *)
						(* if we're in the BSC/glove box since we stash pipettes in these transfer environments. *)
						(* NOTE: We do this at experiment time to try to avoid any un-linking of resources at experiment time. *)
						(* This can be a little inaccurate since things can change between experiment and procedure time but generally, *)
						(* we don't expect the types of pipettes to change. Additionally, the operator is still given free-reign to *)
						(* pick whatever they want so they can still pick something from the VLM if there aren't enough stashed in the box. *)

						{
							setUpTransferEnvironmentBoolsFreezeDried,
							tearDownTransferEnvironmentBoolsFreezeDried,
							pipetteReleaseBoolsFreezeDried,
							tipReleaseBoolsFreezeDried,
							coverSamplesInBoolsFreezeDried,
							coverDestinationContainerBoolsFreezeDried,
							resourcesNotToPickUpFrontFreezeDried,
							wasteBinPlacementsFreezeDried,
							wasteBagPlacementsFreezeDried,
							wasteBinTeardownsFreezeDried,
							wasteBagTeardownsFreezeDried
						} = generateTransferEnvironmentDeveloperInfo[
							myResolvedOptions,
							transferEnvironmentResources,
							instrumentResources,
							tipResources,
							samplesInResources,
							destinationContainerResources,
							ConstantArray[Null, Length[transferEnvironmentResources]],
							ConstantArray[Null, Length[transferEnvironmentResources]],
							combinedFastAssoc
						];


						(* Create the protocol packet *)
						inoculateProtocolPacket = <|

							(* General *)
							Object -> CreateID[Object[Protocol, InoculateLiquidMedia]],
							Type -> Object[Protocol, InoculateLiquidMedia],
							Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
							Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
							ParentProtocol -> If[MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]],
								Link[parentProtocol, Subprotocols]
							],
							Name -> Lookup[myResolvedOptions, Name],

							(* Organizational Information *)
							Author -> If[MatchQ[parentProtocol, Null],
								Link[$PersonID, ProtocolsAuthored]
							],

							(* Options Handling *)
							UnresolvedOptions -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia, myUnresolvedOptions],
							ResolvedOptions -> myResolvedOptions,

							(* Resources *)
							Replace[Checkpoints] -> {
								{"Picking Resources", 15 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 45 Minute]]},
								{"Performing Inoculations", 5 Minute * Length[mySamples], "The Inoculations are performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 3 Hour]]},
								{"Returning Materials", 15 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]}
							},

							(* Sample Storage *)
							Replace[SamplesInStorageCondition] -> expandedSamplesInStorageConditions,
							Replace[SamplesOutStorageCondition] -> flattenedSamplesOutStorageConditions,

							(* General *)
							InoculationSource -> resolvedInoculationSource,
							Replace[TransferEnvironments] -> Link /@ transferEnvironmentResources,
							Replace[Instruments] -> Link /@ instrumentResources,

							(* Stab *)
							Replace[InoculationTips] -> Link /@ tipResources,
							Replace[InoculationTipTypes] -> expandedTipTypes,
							Replace[InoculationTipMaterials] -> expandedTipMaterials,
							Replace[TransferVolumes] -> sanitizedResolvedVolumes,

							(* Resuspend *)
							Replace[ResuspensionMedia] -> Link /@ resuspensionMediaResources,
							Replace[ResuspensionMediaVolumes] -> expandedResuspensionMediaVolumes,
							Replace[ResuspensionMixTypes] -> expandedResuspensionMixTypes,
							Replace[NumberOfResuspensionMixes] -> expandedNumberOfResuspensionMixes,
							Replace[ResuspensionMixVolumes] -> expandedResuspensionMixVolumes,

							(* Unused fields specific to other InoculationSourceTypes *)
							Replace[NumberOfSourceScrapes] -> Null,
							Replace[SourceMixTypes] -> Null,
							Replace[NumberOfSourceMixes] -> Null,
							Replace[SourceMixVolumes] -> Null,

							(* Deposit *)
							Replace[DestinationMedia] -> Link /@ Flatten[mediaResources],
							Replace[MediaVolumes] -> flattenedMediaVolumes,
							Replace[DestinationMediaContainers] -> Link /@ destinationContainerResources,
							Replace[DestinationWells] -> flattenedDestinationWells,
							Replace[DestinationMixTypes] -> flattenedDestinationMixTypes,
							Replace[DestinationNumberOfMixes] -> flattenedDestinationNumberOfMixes,
							Replace[DestinationMixVolumes] -> flattenedDestinationMixVolumes,

							(* Developer *)
							Replace[SetUpTransferEnvironments] -> setUpTransferEnvironmentBoolsFreezeDried,
							Replace[TearDownTransferEnvironments] -> tearDownTransferEnvironmentBoolsFreezeDried,
							Replace[ReleaseInstruments] -> pipetteReleaseBoolsFreezeDried,
							Replace[ReleaseTips] -> tipReleaseBoolsFreezeDried,
							Replace[CoverSamplesIns] -> coverSamplesInBoolsFreezeDried,
							Replace[CoverDestinationContainers] -> coverDestinationContainerBoolsFreezeDried,
							Replace[CapRacks] -> Link /@ capRackResourcesForBSC,
							PlateSeal -> Link[plateSealToUse],

							(* PostProcessing *)
							MeasureVolume -> False,
							ImageSample -> False,
							MeasureWeight -> False
						|>;

						(* Add the RequiredObjects and RequiredInstruments Keys *)
						fullInoculateProtocolPacket = addRequiredInoculateObjectInstruments[inoculateProtocolPacket, resourcesNotToPickUpFrontFreezeDried];

						(* Return the protocol packet *)
						{
							Join[fullInoculateProtocolPacket, prepPacket],
							Null,
							Null,
							currentSimulation,
							Null
						}
					],
					FrozenGlycerol,
					Module[
						{
							mediaResources, wasteBinResources, wasteBagResources,
							setUpTransferEnvironmentBoolsFrozenGlycerol, tearDownTransferEnvironmentBoolsFrozenGlycerol,
							pipetteReleaseBoolsFrozenGlycerol, tipReleaseBoolsFrozenGlycerol, coverSamplesInBoolsFrozenGlycerol, coverDestinationContainerBoolsFrozenGlycerol,
							resourcesNotToPickUpFrontFrozenGlycerol, wasteBinPlacementsFrozenGlycerol, wasteBagPlacementsFrozenGlycerol,
							wasteBinTeardownsFrozenGlycerol, wasteBagTeardownsFrozenGlycerol, inoculateProtocolPacket, fullInoculateProtocolPacket,
							cryogenicGlovesResource, samplesInStorageConditions, cryogenicSamples, nonCryogenicSamples
						},

						(* Create DestinationMedia Resources *)
						(* call the helper function to generate media resource for destination media and resuspension media *)
						mediaResources = generateMediaResources[myResolvedOptions, DestinationMedia, MediaVolume, "ExperimentInoculateLiquidMedia"];

						(* Create waste bin and waste bag resources *)
						{
							wasteBinResources,
							wasteBagResources
						} = generateBSCWasteResources[myResolvedOptions, FrozenGlycerol, inheritedFastAssoc];

						(* Determine the RequriedObjects and RequiredResources - we do not want to pick all of the resources up front because some will already be inside the BSCs *)
						(* Right now, these only include pipettes *)
						(* if we're in the BSC/glove box since we stash pipettes in these transfer environments. *)
						(* NOTE: We do this at experiment time to try to avoid any un-linking of resources at experiment time. *)
						(* This can be a little inaccurate since things can change between experiment and procedure time but generally, *)
						(* we don't expect the types of pipettes to change. Additionally, the operator is still given free-reign to *)
						(* pick whatever they want so they can still pick something from the VLM if there aren't enough stashed in the box. *)

						{
							setUpTransferEnvironmentBoolsFrozenGlycerol,
							tearDownTransferEnvironmentBoolsFrozenGlycerol,
							pipetteReleaseBoolsFrozenGlycerol,
							tipReleaseBoolsFrozenGlycerol,
							coverSamplesInBoolsFrozenGlycerol,
							coverDestinationContainerBoolsFrozenGlycerol,
							resourcesNotToPickUpFrontFrozenGlycerol,
							wasteBinPlacementsFrozenGlycerol,
							wasteBagPlacementsFrozenGlycerol,
							wasteBinTeardownsFrozenGlycerol,
							wasteBagTeardownsFrozenGlycerol
						} = generateTransferEnvironmentDeveloperInfo[
							myResolvedOptions,
							transferEnvironmentResources,
							instrumentResources,
							tipResources,
							samplesInResources,
							destinationContainerResources,
							wasteBinResources,
							wasteBagResources,
							combinedFastAssoc
						];

						(* Make a resource for Model[Item, Glove, "Cryo Glove, Medium"] to pick before retrieving the samples from cryogenic storage. *)
						cryogenicGlovesResource = Link[Resource[Sample -> Model[Item, Glove, "id:4pO6dM5EWNaw"], Rent -> True, Name -> ToString[Model[Item, Glove, "id:4pO6dM5EWNaw"]]]];

						(* Get the current storage condition for each of the SamplesIn *)
						samplesInStorageConditions = fastAssocLookup[combinedFastAssoc, #, StorageCondition] & /@ mySamples;

						(* Classify the inoculation sources as either CryogenicSamples or NonCryogenicSamples *)
						cryogenicSamples = PickList[samplesInResources, samplesInStorageConditions, Alternatives[CryogenicStorage, ObjectP[Model[StorageCondition, "id:6V0npvmE09vG"](*Cryogenic*)]]];
						nonCryogenicSamples = UnsortedComplement[samplesInResources, cryogenicSamples];

						(* Create the protocol packet *)
						inoculateProtocolPacket = <|

							(* General *)
							Object -> CreateID[Object[Protocol, InoculateLiquidMedia]],
							Type -> Object[Protocol, InoculateLiquidMedia],
							Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
							Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
							ParentProtocol -> If[MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]],
								Link[parentProtocol, Subprotocols]
							],
							Name -> Lookup[myResolvedOptions, Name],

							(* Organizational Information *)
							Author -> If[MatchQ[parentProtocol, Null],
								Link[$PersonID, ProtocolsAuthored]
							],

							(* Options Handling *)
							UnresolvedOptions -> RemoveHiddenOptions[ExperimentInoculateLiquidMedia, myUnresolvedOptions],
							ResolvedOptions -> myResolvedOptions,

							(* Resources *)
							Replace[Checkpoints] -> {
								{"Picking Resources", 15 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 45 Minute]]},
								{"Performing Inoculations", 5 Minute * Length[mySamples], "The Inoculations are performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 3 Hour]]},
								{"Returning Materials", 15 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]}
							},

							(* Sample Storage *)
							Replace[SamplesInStorageCondition] -> expandedSamplesInStorageConditions,
							Replace[SamplesOutStorageCondition] -> flattenedSamplesOutStorageConditions,

							(* General *)
							InoculationSource -> resolvedInoculationSource,
							Replace[TransferEnvironments] -> Link /@ transferEnvironmentResources,
							Replace[Instruments] -> Link /@ instrumentResources,
							Replace[CapRacks] -> Link /@ capRackResourcesForBSC,

							(* Inoculation Transfer *)
							Replace[InoculationTips] -> Link /@ tipResources,
							Replace[InoculationTipTypes] -> expandedTipTypes,
							Replace[InoculationTipMaterials] -> expandedTipMaterials,
							Replace[NumberOfSourceScrapes] -> expandedNumberOfSourceScrapes,

							(* Unused fields specific to other InoculationSourceTypes *)
							Replace[ResuspensionMedia] -> Null,
							Replace[ResuspensionMediaVolumes] -> Null,
							Replace[ResuspensionMixTypes] -> Null,
							Replace[NumberOfResuspensionMixes] -> Null,
							Replace[ResuspensionMixVolumes] -> Null,
							Replace[TransferVolumes] -> Null,
							Replace[SourceMixTypes] -> Null,
							Replace[NumberOfSourceMixes] -> Null,
							Replace[SourceMixVolumes] -> Null,

							(* Deposit *)
							Replace[DestinationMedia] -> Link /@ Flatten[mediaResources],
							Replace[MediaVolumes] -> flattenedMediaVolumes,
							Replace[DestinationMediaContainers] -> Link /@ destinationContainerResources,
							Replace[DestinationWells] -> flattenedDestinationWells,
							Replace[DestinationMixTypes] -> flattenedDestinationMixTypes,
							Replace[DestinationNumberOfMixes] -> flattenedDestinationNumberOfMixes,
							Replace[DestinationMixVolumes] -> flattenedDestinationMixVolumes,

							(* Developer *)
							Replace[SetUpTransferEnvironments] -> setUpTransferEnvironmentBoolsFrozenGlycerol,
							Replace[TearDownTransferEnvironments] -> tearDownTransferEnvironmentBoolsFrozenGlycerol,
							Replace[ReleaseInstruments] -> pipetteReleaseBoolsFrozenGlycerol,
							Replace[ReleaseTips] -> tipReleaseBoolsFrozenGlycerol,
							Replace[CoverSamplesIns] -> coverSamplesInBoolsFrozenGlycerol,
							Replace[CoverDestinationContainers] -> coverDestinationContainerBoolsFrozenGlycerol,
							Replace[WasteBins] -> Link /@ wasteBinResources,
							Replace[WasteBags] -> Link /@ wasteBagResources,
							Replace[BiosafetyWasteBinPlacements] -> wasteBinPlacementsFrozenGlycerol,
							Replace[BiosafetyWasteBagPlacements] -> wasteBagPlacementsFrozenGlycerol,
							Replace[BiosafetyWasteBinTeardowns] -> wasteBinTeardownsFrozenGlycerol,
							Replace[BiosafetyWasteBagTeardowns] -> wasteBagTeardownsFrozenGlycerol,
							CryogenicGloves -> cryogenicGlovesResource,
							Replace[CryogenicSamples] -> Link /@ cryogenicSamples,
							Replace[NonCryogenicSamples] -> Link /@ nonCryogenicSamples,
							PlateSeal -> Link[plateSealToUse],

							(* PostProcessing *)
							MeasureVolume -> False,
							ImageSample -> False,
							MeasureWeight -> False
						|>;

						(* Add the RequiredObjects and RequiredInstruments Keys *)
						fullInoculateProtocolPacket = addRequiredInoculateObjectInstruments[inoculateProtocolPacket, resourcesNotToPickUpFrontFrozenGlycerol];

						(* Return the protocol packet *)
						{
							Join[fullInoculateProtocolPacket, prepPacket],
							Null,
							Null,
							currentSimulation,
							Null
						}
					]
				]
			],
		(* If we are robotic and SolidMedia *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedInoculationSource, SolidMedia],
			(* Call the pick resource packets to get the batched unit operation packets *)
			pickColoniesResourcePackets[
				mySamples,
				myUnresolvedOptions,
				myResolvedOptions,
				ExperimentInoculateLiquidMedia,
				Output -> outputSpecification,
				Cache -> inheritedCache,
				Simulation -> currentSimulation
			],
		(* If we are robotic and LiquidMedia *)
		True,
			Module[
				{
					resolvedInstruments, resolvedDestinationMediaContainers, resolvedDestinationMixes, resolvedDestinationMixTypes,
					resolvedDestinationNumberOfMixes, resolvedDestinationMixVolumes, resolvedMediaVolumes, resolvedDestinationMedium,
					resolvedVolumes, resolvedDestinationWells, resolvedTips, resolvedSourceMixes, resolvedSourceMixTypes,
					resolvedNumberOfSourceMixes, resolvedSourceMixVolumes, resolvedSampleOutLabels, resolvedContainerOutLabels,
					resolvedSampleLabels, resolvedSampleContainerLabels, transferKeys, mediaTransferInputsAndOptions,
					sourceTransferInputsAndOptions, transferInputsAndOptions, roboticUnitOperationPackets, roboticSimulation,
					runTime, outputUnitOperationPacket
				},

				(* Extract options for Transfer *)
				{
					(*1*)resolvedInstruments,
					(*2*)resolvedDestinationMediaContainers,
					(*3*)resolvedDestinationMixes,
					(*4*)resolvedDestinationMixTypes,
					(*5*)resolvedDestinationNumberOfMixes,
					(*6*)resolvedDestinationMixVolumes,
					(*7*)resolvedMediaVolumes,
					(*8*)resolvedDestinationMedium,
					(*9*)resolvedVolumes,
					(*10*)resolvedDestinationWells,
					(*11*)resolvedTips,
					(*12*)resolvedSourceMixes,
					(*13*)resolvedSourceMixTypes,
					(*14*)resolvedNumberOfSourceMixes,
					(*15*)resolvedSourceMixVolumes,
					(*16*)resolvedSampleOutLabels,
					(*17*)resolvedContainerOutLabels,
					(*18*)resolvedSampleLabels,
					(*19*)resolvedSampleContainerLabels
				} = Lookup[
					myResolvedOptions,
					{
						(*1*)Instrument,
						(*2*)DestinationMediaContainer,
						(*3*)DestinationMix,
						(*4*)DestinationMixType,
						(*5*)DestinationNumberOfMixes,
						(*6*)DestinationMixVolume,
						(*7*)MediaVolume,
						(*8*)DestinationMedia,
						(*9*)Volume,
						(*10*)DestinationWell,
						(*11*)InoculationTips,
						(*12*)SourceMix,
						(*13*)SourceMixType,
						(*14*)NumberOfSourceMixes,
						(*15*)SourceMixVolume,
						(*16*)SampleOutLabel,
						(*17*)ContainerOutLabel,
						(*18*)SampleLabel,
						(*19*)SampleContainerLabel
					}
				];

				transferKeys = {Source, Destination, Amount, DispenseMix, DispenseMixType, DispenseMixVolume, NumberOfDispenseMixes, DestinationWell, Tips, AspirationMix, AspirationMixType, AspirationMixVolume, NumberOfAspirationMixes, SourceLabel, SourceContainerLabel, DestinationLabel, DestinationContainerLabel};

				(* Make the transfer input and option list for media into destination container *)
				(* Note: we need to flatten nested indexmatching option values here *)
				mediaTransferInputsAndOptions = {
					Source -> Flatten[resolvedDestinationMedium],
					Destination -> Flatten[resolvedDestinationMediaContainers],
					Amount -> Flatten[resolvedMediaVolumes],
					(* Mix options all goes to Null for destination media prep, since this is just moving the liquid media to the destination container*)
					DispenseMix -> ConstantArray[False, Length[mySamples]],
					DispenseMixType -> ConstantArray[Null, Length[mySamples]],
					DispenseMixVolume -> ConstantArray[Null, Length[mySamples]],
					NumberOfDispenseMixes -> ConstantArray[Null, Length[mySamples]],
					DestinationWell -> Flatten[resolvedDestinationWells],
					Tips -> ConstantArray[Automatic, Length[mySamples]],
					AspirationMix -> ConstantArray[Automatic, Length[mySamples]],
					AspirationMixType -> ConstantArray[Automatic, Length[mySamples]],
					AspirationMixVolume -> ConstantArray[Automatic, Length[mySamples]],
					NumberOfAspirationMixes -> ConstantArray[Automatic, Length[mySamples]],
					SourceLabel -> ConstantArray[Automatic, Length[mySamples]],
					SourceContainerLabel -> ConstantArray[Automatic, Length[mySamples]],
					DestinationLabel -> Flatten[resolvedSampleOutLabels],
					DestinationContainerLabel -> Flatten[resolvedContainerOutLabels]
				};

				(* Make the transfer input and option list from source cell sample to destination container *)
				sourceTransferInputsAndOptions = {
					Source -> mySamples,
					Destination -> Flatten[resolvedDestinationMediaContainers],
					Amount -> resolvedVolumes,
					DispenseMix -> Flatten[resolvedDestinationMixes],
					DispenseMixType -> Flatten[resolvedDestinationMixTypes],
					DispenseMixVolume -> Flatten[resolvedDestinationMixVolumes],
					NumberOfDispenseMixes -> Flatten[resolvedDestinationNumberOfMixes],
					DestinationWell -> Flatten[resolvedDestinationWells],
					Tips -> resolvedTips,
					AspirationMix -> resolvedSourceMixes,
					AspirationMixType -> resolvedSourceMixTypes,
					AspirationMixVolume -> resolvedSourceMixVolumes,
					NumberOfAspirationMixes -> resolvedNumberOfSourceMixes,
					SourceLabel -> resolvedSampleLabels,
					SourceContainerLabel -> resolvedSampleContainerLabels,
					DestinationLabel -> Flatten[resolvedSampleOutLabels],
					DestinationContainerLabel -> Flatten[resolvedContainerOutLabels]
				};

				(* Create the transfer primitive combining the media to destination and source cells to destination transfers *)
				transferInputsAndOptions = (# -> Join[
					ToList@Lookup[mediaTransferInputsAndOptions, #],
					ToList@Lookup[sourceTransferInputsAndOptions, #]
				])& /@ transferKeys;

				(* Get our robotic unit operation packets. *)
				{{roboticUnitOperationPackets, runTime}, roboticSimulation} = ExperimentRoboticCellPreparation[
					Transfer[Sequence @@ transferInputsAndOptions, SterileTechnique -> True],
					Instrument -> FirstCase[resolvedInstruments, ObjectP[]],
					UnitOperationPackets -> True,
					Output -> {Result, Simulation},
					FastTrack -> Lookup[myResolvedOptions, FastTrack],
					ParentProtocol -> parentProtocol,
					Name -> Lookup[myResolvedOptions, Name],
					Simulation -> currentSimulation,
					Upload -> False,
					ImageSample -> Lookup[myResolvedOptions, ImageSample],
					MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
					MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
					Priority -> Lookup[myResolvedOptions, Priority],
					StartDate -> Lookup[myResolvedOptions, StartDate],
					HoldOrder -> Lookup[myResolvedOptions, HoldOrder],
					QueuePosition -> Lookup[myResolvedOptions, QueuePosition]
				];

				(* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
				outputUnitOperationPacket = UploadUnitOperation[
					Module[{nonHiddenOptions},
						nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, InoculateLiquidMedia]];
						(* Override any options with resource. *)
						InoculateLiquidMedia@Join[
							Cases[Normal[myResolvedOptions, Association], Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
							{
								Sample -> mySamples,
								RoboticUnitOperations -> (Link /@ Lookup[roboticUnitOperationPackets, Object])
							}
						]
					],
					UnitOperationType -> Output,
					Upload -> False
				];

				(* Get the final updated simulation *)
				roboticSimulation = UpdateSimulation[
					roboticSimulation,
					Module[{protocolPacket},
						protocolPacket = <|
							Object -> SimulateCreateID[Object[Protocol, RoboticCellPreparation]],
							Replace[OutputUnitOperations] -> (Link[Lookup[outputUnitOperationPacket, Object], Protocol]),
							ResolvedOptions -> {}
						|>;

						SimulateResources[protocolPacket, {outputUnitOperationPacket}, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> currentSimulation]
					]
				];

				(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
				roboticSimulation = If[Length[roboticUnitOperationPackets] == 0,
					roboticSimulation,
					updateLabelFieldReferences[roboticSimulation, RoboticUnitOperations]
				];

				(* Return the packets and simulation *)
				{
					Null,
					Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
					{},
					roboticSimulation,
					(* Add 10 mins to the robotic run time *)
					(runTime + 10 Minute)
				}
			]
	];

	(*--Gather all the resource symbolic representations--*)

	(* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	rawResourceBlobs = Which[
		MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedInoculationSource, SolidMedia],
			DeleteDuplicates[Cases[{unitOperationPackets, batchedUnitOperationPackets}, _Resource, Infinity]],
		MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedInoculationSource, LiquidMedia],
			{},
		True,
			DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]]
	];

	(* Get all resources without a name *)
	resourcesWithoutName = DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False]&)]]];
	resourceToNameReplaceRules = MapThread[#1 -> #2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name -> CreateUUID[]]]&) /@ resourcesWithoutName}];
	allResourceBlobs = rawResourceBlobs /. resourceToNameReplaceRules;


	(*---Call fulfillableResourceQ on all the resources we created---*)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine],
			{True, {}},
		(* When Preparation->Robotic, the framework will call FRQ for us *)
		MatchQ[resolvedPreparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[
				allResourceBlobs,
				Output -> {Result, Tests},
				FastTrack -> Lookup[myResolvedOptions, FastTrack],
				Cache -> inheritedCache,
				Simulation -> simulation
			],
		True,
			{
				Resources`Private`fulfillableResourceQ[
					allResourceBlobs,
					FastTrack -> Lookup[myResolvedOptions, FastTrack],
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
		{protocolPacket, unitOperationPackets, batchedUnitOperationPackets, currentSimulation, roboticRunTime} /. resourceToNameReplaceRules,
		$Failed
	];

	(* Generate the tests output rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection:: *)
(*Simulation Function*)
DefineOptions[simulateInoculateLiquidMedia,
	Options :> {
		CacheOption, SimulationOption, ParentProtocolOption
	}
];
(* Note:this simulation is only for Manual Preparation *)
simulateInoculateLiquidMedia[
	myProtocolPacket: PacketP[Object[Protocol, InoculateLiquidMedia]] | $Failed,
	mySamples: {ObjectP[Object[Sample]]..},
	myResolvedOptions: {_Rule..},
	myResolutionOptions: OptionsPattern[simulateInoculateLiquidMedia]
] := Module[
	{
		inheritedCache, currentSimulation, inheritedFastAssoc, protocolObject, resolvedPreparation, inoculationSource, fulfillmentSimulation,
		simulatedSamplesIn, destinationMediaContainers, destinationMedia, resuspensionMedia, containerContentsPackets,
		sampleContainerPackets, sanitizedSamplesIn, sanitizedResuspensionMedia, sanitizedDestinationMediaContainers,
		sanitizedDestinationMedia, containerFastAssoc, resolvedDestinationWell, resolvedResuspensionMediaVolume, resolvedMediaVolume,
		resolvedVolumes, resolvedNumberOfSourceScrapes, destsNoSample, uploadSamplePackets, containerPackets, destinationSamples,
		mediaTransferTuples, resuspensionMediaTransferTuples, sampleTransferTuples, allTuples, uploadSampleTransferPackets,
		simulatedSamplesOut, simulatedLabels, destinationMediaContainerFootprints, plateSeal, destContainerToPlateSealRules,
		coverSimulation, cultureAdhesionPackets
	},

	(* Get simulation and cache *)
	{inheritedCache, currentSimulation} = Lookup[ToList[myResolutionOptions], {Cache, Simulation}, {}];

	(* Create a faster version of the cache to improve speed *)
	inheritedFastAssoc = makeFastAssocFromCache[inheritedCache];

	(* Get our protocol ID. This should already be in the protocol packet, unless option resolver or  *)
	(* resource packets failed, then we have to simulate a new id *)
	protocolObject = If[MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[Object[Protocol, InoculateLiquidMedia]],
		Lookup[myProtocolPacket, Object]
	];

	(* Lookup the resolved preparation (it should always be Manual) *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Lookup the InoculationSource *)
	inoculationSource = Lookup[myResolvedOptions, InoculationSource];

	(* Simulate the fulfillment of all resources by the procedure *)
	fulfillmentSimulation = If[MatchQ[myProtocolPacket, $Failed],
		(* If we have a $Failed for the protocol packet, that means we had a problem in option resolver *)
		(* and skipped resource packet generation. *)
		Module[
			{
				samplesInResources, containersIn, uniqueContainersIn, containersInResources, mediaResources, resuspensionMediaResources,
				uniqueDestinationContainerObjects, destinationContainerObjectResourceLookup, destinationContainerResources,
				protocolPacket
			},
			(* Just create a shell of a protocol object so we can return something back *)
			(* We do this by creating (and then simulating) the resources we need to simulate the movement *)
			(* Of samples by the end of the experiment *)

			(* 0. Download any information needed to create the resources *)
			{
				containersIn
			} = Quiet[
				Download[
					{
						mySamples
					},
					{
						Container[Object]
					},
					Cache -> inheritedCache,
					Simulation -> currentSimulation
				],
				{Download::FieldDoesntExist}
			];

			(* 1. Make resources for our SamplesIn *)
			(* NOTE: This step is copied from the resource packets *)
			samplesInResources = If[MatchQ[Lookup[myResolvedOptions, InoculationSource], LiquidMedia],
				Module[
					{
						samplesInVolumesRequired, samplesInAndVolumes, samplesInResourceReplaceRules
					},
					(* Calculate the total volume we need of each sample in. It is just the volume we are transferring  *)
					samplesInVolumesRequired = Lookup[myResolvedOptions, Volume];

					(* Pair up each sample with its volume *)
					samplesInAndVolumes = Merge[MapThread[Association[#1 -> #2]&, {mySamples, samplesInVolumesRequired}], Total];

					(* Create a resource rule for each unique sample *)
					samplesInResourceReplaceRules = KeyValueMap[Function[{sample, volume},
						sample -> Resource[Sample -> sample, Amount -> volume, Name -> CreateUUID[]]
					],
						samplesInAndVolumes
					];

					(* Use the replace rules *)
					mySamples /. samplesInResourceReplaceRules;
				],
				(* For AgarStab, FreezeDried and FrozenGlycerol, no amount is specified. Whole tubes are needed. *)
				Module[
					{
						samplesInResourceReplaceRules
					},
					(* Create a resource rule for each unique sampleIn *)
					samplesInResourceReplaceRules = (# -> Resource[Sample -> #, Name -> CreateUUID[]])& /@ DeleteDuplicates[mySamples];

					(* Use the replace rules *)
					mySamples /. samplesInResourceReplaceRules;
				]
			];

			(* 2. Make Resources for our ContainersIn *)
			(* NOTE: This step is copied from the resource packets *)
			(* Get the unique container in *)
			uniqueContainersIn = DeleteDuplicates[Flatten[containersIn]];

			(* Create container in resources *)
			containersInResources = Map[Function[{container}, Link[container, Protocols]], uniqueContainersIn];

			(* 3. Create Media Resources *)
			(* call the helper function to generate media resource for destination media and resuspension media *)
			mediaResources = generateMediaResources[myResolvedOptions, DestinationMedia, MediaVolume, "ExperimentInoculateLiquidMedia"];

			resuspensionMediaResources = If[MatchQ[Lookup[myResolvedOptions, InoculationSource], FreezeDried],
				(*For freeze-dried we also need to simulate resuspension media resource*)
				generateMediaResources[myResolvedOptions, ResuspensionMedia, ResuspensionMediaVolume, "ExperimentInoculateLiquidMedia"],
				{}
			];

			(* 4. Create DestinationContainer Resources *)
			(* Get the Unique DestinationContainer Objects *)
			(* NOTE: Have the extra replace rule to handle the case of a list of objects. *)
			uniqueDestinationContainerObjects = DeleteDuplicates[Cases[Flatten[Lookup[myResolvedOptions, DestinationMediaContainer]], ObjectP[Object]]];

			(* Create a resource lookup for the unique containers *)
			destinationContainerObjectResourceLookup = # -> Resource[
				Sample -> #,
				Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]
			]& /@ uniqueDestinationContainerObjects;

			(* Get a list of destination container resources - Each Model[Container] gets its own resource *)
			(* Note:DestinationMediaContainer can be 3-level list. To avoid crash, reduce for each sample, there is only 1 DestinationMediaContainer *)
			destinationContainerResources = Map[
				Function[{container},
					If[MatchQ[First[ToList[container]], ObjectP[Object[Container]]],
						First[ToList[container]] /. destinationContainerObjectResourceLookup,
						Resource[
							Sample -> First[ToList[container]],
							Name -> "ExperimentInoculateLiquidMedia DestinationContainer " <> CreateUUID[]
						]
					]
				],
				Lookup[myResolvedOptions, DestinationMediaContainer]
			];

			(* Put together a shell of a protocol *)
			protocolPacket = <|
				(* Organizational Information *)
				Object -> protocolObject,
				Type -> Object[Protocol, InoculateLiquidMedia],
				ResolvedOptions -> myResolvedOptions,
				Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
				Replace[ContainersIn] -> containersInResources,

				(* Destination Information *)
				Replace[DestinationMedia] -> Flatten[Link[First[#]]& /@ mediaResources],
				Replace[ResuspensionMedia] -> (Link /@ resuspensionMediaResources /. {} -> Null),
				Replace[DestinationMediaContainers] -> Flatten[Link /@ destinationContainerResources]
			|>;

			(* Simulate the Resources and return *)
			SimulateResources[
				protocolPacket,
				Simulation -> currentSimulation
			]

		],
		(* Otherwise, resource packets went fine. Just Simulate the resource picking *)
		SimulateResources[
			myProtocolPacket,
			ParentProtocol -> Lookup[ToList[myResolutionOptions], ParentProtocol, Null],
			Simulation -> currentSimulation
		]
	];

	(* Update the simulation with the simulated resources. *)
	currentSimulation = UpdateSimulation[currentSimulation, fulfillmentSimulation];

	(* We need to create a series of upload sample transfer tuples *)
	(* First, we need to transfer the destination media into the destination well of the destination media container *)
	(* Then we need to either transfer a small (5 Microliter) amount, or volume of sample into the destination well of the destination media container *)

	(* 1. First, extract our simulated resources from the protocol object *)
	{
		{{
			simulatedSamplesIn,
			destinationMediaContainers,
			destinationMediaContainerFootprints,
			destinationMedia,
			resuspensionMedia,
			containerContentsPackets,
			plateSeal,
			resolvedDestinationWell,
			resolvedMediaVolume,
			resolvedResuspensionMediaVolume,
			resolvedVolumes,
			resolvedNumberOfSourceScrapes
		}},
		sampleContainerPackets
	} = Quiet[
		Download[
			{
				{protocolObject},
				mySamples
			},
			{
				{
					SamplesIn,
					DestinationMediaContainers,
					DestinationMediaContainers[Model][Footprint],
					DestinationMedia,
					ResuspensionMedia,
					Packet[DestinationMediaContainers[Contents]],
					PlateSeal,
					DestinationWells,
					MediaVolumes,
					ResuspensionMediaVolumes,
					TransferVolumes,
					NumberOfSourceScrapes
				},
				{Packet[Container]}
			},
			Cache -> inheritedCache,
			Simulation -> currentSimulation
		],
		{Download::FieldDoesntExist}
	];

	(* 2. Sanitize the download output  *)
	sanitizedSamplesIn = Download[simulatedSamplesIn, Object];
	sanitizedDestinationMediaContainers = Download[destinationMediaContainers, Object];
	sanitizedDestinationMedia = Download[destinationMedia, Object];
	sanitizedResuspensionMedia = Download[resuspensionMedia, Object];

	(* Create a fast lookup of the container contents *)
	containerFastAssoc = makeFastAssocFromCache[FlattenCachePackets[{containerContentsPackets, sampleContainerPackets}]];

	(* 3. Make sure all destinations have an Object[Sample]  *)
	(* First, pick out any destinations that do not have an object sample *)
	destsNoSample = MapThread[
		Function[{container, well},
			Module[{containerContents},
				(* Lookup the contents of the container *)
				containerContents = fastAssocLookup[containerFastAssoc, container, Contents];

				(* If there is an object sample at the well in question, skip, otherwise *)
				(* record the well, container pairing *)
				If[!NullQ[FirstCase[containerContents, {well, ObjectP[Object[Sample]]}, Null]],
					Nothing,
					{well, container}
				]
			]
		],
		{
			sanitizedDestinationMediaContainers,
			resolvedDestinationWell
		}
	];

	(* Upload an empty sample to all of those locations *)
	uploadSamplePackets = UploadSample[
		ConstantArray[{}, Length[destsNoSample]],
		destsNoSample,
		State -> Liquid,
		InitialAmount -> ConstantArray[Null, Length[destsNoSample]],
		UpdatedBy -> protocolObject,
		Simulation -> currentSimulation,
		SimulationMode -> True,
		FastTrack -> True,
		Upload -> False
	];

	(* Update the simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSamplePackets]];

	(* Retrieve samples inside all containers of interest *)
	containerPackets = Download[
		sanitizedDestinationMediaContainers,
		Packet[Contents],
		Cache -> inheritedCache,
		Simulation -> currentSimulation
	];

	(* Convert, {well, container} pairs to the corresponding sample *)
	destinationSamples = MapThread[
		Function[{containerPacket, well},
			Download[Last[FirstCase[Lookup[containerPacket, Contents], {well, _}]], Object]
		],
		{
			containerPackets,
			Flatten[resolvedDestinationWell]
		}
	];

	(* 4. Create the first set of transfer tuples (Media into destination container for liquid media, agar stab and frozen glycerol,
	media to sample container for freeze dried) if - Necessary *)
	mediaTransferTuples = If[MatchQ[inoculationSource, LiquidMedia | AgarStab | FreezeDried | FrozenGlycerol],
		MapThread[
			Function[{mediaObject, destinationSample, mediaVolume},
				If[NullQ[mediaObject], Nothing, {mediaObject, destinationSample, mediaVolume}]
			],
			{
				sanitizedDestinationMedia,
				destinationSamples,
				Flatten[resolvedMediaVolume]
			}
		],
		{}
	];

	(* 4.5 Create optional resuspension media transfer for FreezeDried samples (resuspension media to sample container) *)
	(* If we have expanded SamplesIn and Resuspension in the protocol packet, remove the duplicates by DeleteDuplicates *)
	(* since Resuspension should only happen once per sample *)
	resuspensionMediaTransferTuples = If[MatchQ[inoculationSource, FreezeDried],
		DeleteDuplicates@MapThread[
			Function[{mediaObject, destinationSample, mediaVolume},
				{mediaObject, destinationSample, mediaVolume}
			],
			{
				sanitizedResuspensionMedia,
				sanitizedSamplesIn,
				resolvedResuspensionMediaVolume
			}
		],
		{}
	];

	(* 5. Create the second set of transfer tuples (Sample into destination container) *)
	(* If InoculationSource is LiquidMedia or FreezeDried, transfer the given volume *)
	(* If InoculationSource is FrozenGlycerol, use numberOfSourceScrapes * 5 Microliter as a rough estimate *)
	(* If Otherwise, use 5 Microliter in the case of errors *)
	(* could be SolidMedia or Null, transfer 5 Microliter *)
	sampleTransferTuples = Module[{volumesToTransfer},

		(* Determine the volume to use (described above) *)
		volumesToTransfer = Which[
			MatchQ[inoculationSource, LiquidMedia | FreezeDried],
				resolvedVolumes,
			MatchQ[inoculationSource, FrozenGlycerol],
				resolvedNumberOfSourceScrapes * 5 Microliter,
			True,
				ConstantArray[5 Microliter, Length[sanitizedSamplesIn]]
		];

		(* Create the tuples *)
		MapThread[{#1, #2, #3}&, {sanitizedSamplesIn, destinationSamples, volumesToTransfer}]
	];

	(* 6. Combine the tuples and call UploadSampleTransfer *)
	allTuples = Join[mediaTransferTuples, sampleTransferTuples];

	uploadSampleTransferPackets = UploadSampleTransfer[
		allTuples[[All, 1]],
		allTuples[[All, 2]],
		allTuples[[All, 3]],
		CountAsPassage -> True,
		Upload -> False,
		FastTrack -> True,
		Simulation -> currentSimulation
	];

	(* Update the simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

	(* 7. make sure the destination containers are covered.  If it's a plate, then use PlateSeal; otherwise stick with Automatic *)
	destContainerToPlateSealRules = DeleteDuplicates[MapThread[
		If[MatchQ[#2, Plate],
			#1 -> plateSeal,
			#1 -> Automatic
		]&,
		{destinationMediaContainers, destinationMediaContainerFootprints}
	]];
	coverSimulation = ExperimentCover[
		destinationMediaContainers,
		Cover -> destinationMediaContainers /. destContainerToPlateSealRules,
		Simulation -> currentSimulation,
		Output -> Simulation,
		FastTrack -> True
	];

	(* Update the simulation, but ONLY the simulation packets.  Basically, I want to make sure the containers have covers on them,
	but I don't want to complicate things with the labels ExperimentCover comes up with *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[Lookup[coverSimulation[[1]], Packets]]];

	(* 8. All destinationSamples need CultureAdhesion of Suspension *)
	cultureAdhesionPackets = Map[
		Function[{destinationSample},
			<|
				Object -> destinationSample,
				CultureAdhesion -> Suspension
			|>
		],
		destinationSamples
	];

	(* Add these packets into the simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[cultureAdhesionPackets]];

	(* 9. Update Labels *)
	(* The simulatedSamplesOut are the destination samples *)
	simulatedSamplesOut = destinationSamples;

	(* Label options *)
	simulatedLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{
					(*In case the samples are in the same container, aka plate. We need to expand it to make it Transpose happy*)
					If[MatchQ[Length[ToList[Lookup[myResolvedOptions, SampleContainerLabel]]], Length[mySamples]],
						ToList[Lookup[myResolvedOptions, SampleContainerLabel]],
						ConstantArray[FirstCase[ToList[Lookup[myResolvedOptions, SampleContainerLabel]], _String, Null], Length[mySamples]]
					], fastAssocLookup[containerFastAssoc, #, Container]& /@ mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Flatten@ToList[Lookup[myResolvedOptions, SampleOutLabel]], Flatten@simulatedSamplesOut}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Flatten@ToList[Lookup[myResolvedOptions, ContainerOutLabel]], sanitizedDestinationMediaContainers}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> If[MatchQ[resolvedPreparation, Manual],
			Join[
				Rule @@@ Cases[
					Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[Subprotocol[SamplesIn][[#]]]&) /@ Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule @@@ Cases[
					Transpose[{
						(*In case the samples are in the same container, aka plate. We need to expand it to make it Transpose happy*)
						If[MatchQ[Length[ToList[Lookup[myResolvedOptions, SampleContainerLabel]]], Length[mySamples]],
							ToList[Lookup[myResolvedOptions, SampleContainerLabel]],
							ConstantArray[FirstCase[ToList[Lookup[myResolvedOptions, SampleContainerLabel]], _String, Null], Length[mySamples]]
						],
						(Field[Subprotocol[SamplesIn][[#]][Container]]&) /@ Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule @@@ Cases[
					Transpose[{Flatten@ToList[Lookup[myResolvedOptions, SampleOutLabel]], (Field[Subprotocol[SamplesOut[[#]]]]&) /@ Range[Length[simulatedSamplesOut]]}],
					{_String, _}
				],
				Rule @@@ Cases[
					Transpose[{Flatten@ToList[Lookup[myResolvedOptions, ContainerOutLabel]], (Field[Subprotocol[ContainersOut][[#]]]&) /@ Range[Length[simulatedSamplesOut]]}],
					{_String, _}
				]
			],
			{}
		]
	];

	(* Final update simulation and return *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulatedLabels]
	}

];


(* ::Subsection:: *)
(*workCellResolver Function*)
resolveInoculateLiquidMediaWorkCell[
	myInputs: ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{LocationPositionP, _String|ObjectP[Object[Container]]}],
	myOptions: OptionsPattern[]
] := Module[
	{workCell, preparation, cache, simulation, cacheLookup, inputSampleInfo},

	(* Pull out WorkCell and Preparation options *)
	workCell = Lookup[myOptions, WorkCell, Automatic];
	preparation = Lookup[myOptions, Preparation];

	(* Lookup the cache and simulation *)
	cache = Lookup[myOptions, Cache, {}];
	simulation = Lookup[myOptions, Simulation, Null];

	(* Make fast assoc lookup from the cache *)
	cacheLookup = Experiment`Private`makeFastAssocFromCache[cache];

	(* Get the states of the input samples *)
	inputSampleInfo = If[MatchQ[cache, {}],
		(* If the cache is empty, default to Null (LiquidHandler) *)
		{},

		(* Otherwise, Lookup the state of the input samples *)
		Module[{containerInputs, allSamples, sampleStates, sampleContainers, mammalianQs},

			containerInputs = Cases[ToList[myInputs], ObjectP[Object[Container]]];

			(* Get all the samples (even those specified as containers) *)
			allSamples = Join[
				Cases[ToList[myInputs], ObjectP[Object[Sample]]],
				Quiet[Download[Cases[Flatten[fastAssocLookup[cacheLookup, containerInputs, Contents][[All, All, 2]]], ObjectP[Object[Sample]]], Object]]
			];

			(* Get the state from all of the input samples *)
			sampleStates = fastAssocLookup[cacheLookup, allSamples, State];
			sampleContainers = fastAssocLookup[cacheLookup, allSamples, Container];
			mammalianQs = MatchQ[fastAssocLookup[cacheLookup, #, CellType], NonMicrobialCellTypeP]& /@ allSamples;

			(* Filter out the bad states - an error for this will be thrown later *)
			MapThread[
				Function[{state, container, mammalianQ},
					{state, Download[container, Object], mammalianQ}
				],
				{sampleStates, sampleContainers, mammalianQs}
			]
		]
	];

	(* Determine the WorkCell that can be used *)
	Which[
		(* If WorkCell is specified, use that *)
		MatchQ[workCell, Except[Automatic]],
			{workCell},
		(* For Manual preparation, no work cell *)
		MatchQ[preparation, Manual],
			{},
		(* If the InoculationSource is SolidMedia or only solid state and plates in the input - use the qPix *)
		Or[
			MatchQ[inputSampleInfo, ListableP[{Solid, ObjectP[Object[Container, Plate]], _}]],
			MatchQ[Lookup[myOptions, InoculationSource], SolidMedia]
		],
			{qPix},
		(* If the InoculationSource is LiquidMedia or only liquid in the input - use the hamilton *)
		Or[
			MatchQ[Lookup[myOptions, InoculationSource], LiquidMedia],
			MatchQ[inputSampleInfo, ListableP[{Liquid, _, _}]]
		],
			If[!MatchQ[Cases[inputSampleInfo, {_, _, True}], {}],
				{bioSTAR},
				{microbioSTAR}
			],
		(* Anything else is an error *)
		True,
			{}
	]
];

(* ::Subsection:: *)
(* Sister Functions *)

(* ::Subsubsection:: *)
(* ExperimentInoculateLiquidMediaOptions *)
DefineOptions[ExperimentInoculateLiquidMediaOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentInoculateLiquidMedia}
];


ExperimentInoculateLiquidMediaOptions[
	myInputs: ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String],
	myOptions: OptionsPattern[ExperimentInoculateLiquidMediaOptions]
] := Module[
	{listedOptions, preparedOptions, resolvedOptions},

	(*Get the options as a list*)
	listedOptions = ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions = Normal[KeyDrop[Append[listedOptions, Output -> Options], {OutputFormat}], Association];

	resolvedOptions = ExperimentInoculateLiquidMedia[myInputs, preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]], Table] && MatchQ[resolvedOptions, {(_Rule | _RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions, ExperimentInoculateLiquidMedia],
		resolvedOptions
	]
];

(* ::Subsubsection:: *)
(* ValidExperimentInoculateLiquidMediaQ *)
DefineOptions[ValidExperimentInoculateLiquidMediaQ,
	Options :> {VerboseOption, OutputFormatOption},
	SharedOptions :> {ExperimentInoculateLiquidMedia}
];


ValidExperimentInoculateLiquidMediaQ[
	myInputs: ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String],
	myOptions: OptionsPattern[ValidExperimentInoculateLiquidMediaQ]
] := Module[
	{listedOptions, preparedOptions, experimentInoculateLiquidMediaTests, initialTestDescription, allTests, verbose, outputFormat},

	(*Get the options as a list*)
	listedOptions = ToList[myOptions];

	(*Remove the output option before passing to the core function because it doesn't make sense here*)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(*Call the ExperimentInoculateLiquidMedia function to get a list of tests*)
	experimentInoculateLiquidMediaTests = Quiet[
		ExperimentInoculateLiquidMedia[myInputs, Append[preparedOptions, Output -> Tests]],
		{LinkObject::linkd, LinkObject::linkn}
	];

	(*Define the general test description*)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test*)
	allTests = If[MatchQ[experimentInoculateLiquidMediaTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[{initialTest, validObjectBooleans, voqWarnings},

			(*Generate the initial test, which should pass if we got this far*)
			initialTest = Test[initialTestDescription, True, True];

			(*Create warnings for invalid objects*)
			validObjectBooleans = ValidObjectQ[Cases[Flatten[myInputs], ObjectP[]], OutputFormat -> Boolean];

			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[myInputs], ObjectP[]], validObjectBooleans}
			];

			(*Get all the tests/warnings*)
			Cases[Flatten[{initialTest, experimentInoculateLiquidMediaTests, voqWarnings}], _EmeraldTest]
		]
	];

	(*Look up the test-running options*)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(*Run the tests as requested*)
	Lookup[RunUnitTest[<|"ValidExperimentInoculateLiquidMediaQ" -> allTests|>, Verbose -> verbose,
		OutputFormat -> outputFormat], "ValidExperimentInoculateLiquidMediaQ"]
];

(* ::Subsubsection:: *)
(* ExperimentInoculateLiquidMediaPreview *)

DefineOptions[ExperimentInoculateLiquidMediaPreview,
	SharedOptions :> {ExperimentInoculateLiquidMedia}
];

ExperimentInoculateLiquidMediaPreview[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions: OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for ExperimentInoculateLiquidMedia *)
	ExperimentInoculateLiquidMedia[myInputs, Append[noOutputOptions, Output -> Preview]]];
