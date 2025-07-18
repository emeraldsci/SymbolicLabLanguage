(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Options and Messages*)



(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[ExperimentLyseCells,
	Options:> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",

			ModifyOptions[CellExtractionSharedOptions,
				Method,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Custom]],
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Method, LyseCells], Object[Method, Extraction], Object[Method, Harvest]}]
					]
				]
			],

			CellTypeOption,
			CultureAdhesionOption,
			TargetCellularComponentOption,

			(* --- DISSOCIATION --- *)

			{
				OptionName -> Dissociate,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if adherent cells in the input cell sample are dissociated from their container prior to cell lysis.",
				ResolutionDescription -> "Automatically set to True if CultureAdhesion is Adherent and Aliquot is True. If CultureAdhesion is set to Suspension, automatically set to False. If neither of these conditions are met, Dissociate is automatically set to False.",
				Category -> "Dissociation"
			},

			(* --- NUMBER OF LYSIS STEPS AND ALIQUOTING --- *)

			{
				OptionName -> NumberOfLysisSteps,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[1, 2, 3]],
				Description -> "The number of times that the cell sample is subjected to a unique set of conditions for disruption of the cell membranes. These conditions include the LysisSolution, LysisSolutionVolume, MixType, MixRate, NumberOfMixes, MixVolume, MixTemperature, MixInstrument, LysisTime, LysisTemperature, and IncubationInstrument.",
				ResolutionDescription -> "Automatically set to the number of lysis steps specified by the selected Method. If Method is set to Custom, automatically set to 2 if any options for a second lysis step are specified, or 3 if any options for a third lysis step are specified. Otherwise, automatically set to 1.",
				Category -> "General"
			},
			{
				OptionName -> TargetCellCount,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[Quantity[0, IndependentUnit["Cells"]]],
					Units -> Quantity[1, IndependentUnit["Cells"]]
				],
				Description -> "The number of cells in the experiment prior to the addition of LysisSolution. Note that the TargetCellCount, if specified, is obtained by aliquoting rather than by cell culture.",
				ResolutionDescription -> "Automatically calculated from the composition of the cell sample and AliquotAmount if sufficient cell count or concentration data is available. If the cell count cannot be calculated from the available sample information, TargetCellCount is automatically set to Null.",
				Category -> "Aliquoting"
			},
			{
				OptionName -> TargetCellConcentration,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[Quantity[0, IndependentUnit["Cells"]]/Milliliter],
					Units -> Quantity[1, IndependentUnit["Cells"]] / Milliliter
				],
				Description -> "The concentration of cells in the experiment prior to the addition of LysisSolution. Note that the TargetCellConcentration, if specified, is obtained by aliquoting and optional dilution rather than by cell culture.",
				ResolutionDescription -> "Automatically calculated from the composition of the cell sample, AliquotAmount, and any additional solution volumes added to the experiment if sufficient cell count or concentration data is available. If the cell concentration cannot be calculated from the available sample information, TargetCellConcentration is automatically set to Null.",
				Category -> "Aliquoting"
			},
			{
				OptionName -> Aliquot,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if a portion of the input cell sample is transferred to a new container prior to lysis.",
				ResolutionDescription -> "Automatically set to True if any of AliquotAmount, AliquotContainer, TargetCellCount, TargetCellConcentration, or NumberOfReplicates are specified, or if the sample's current container is not suitable for the specified mixing, incubation, or centrifugation conditions. Otherwise, Aliquot is automatically set to False.",
				Category -> "Aliquoting"
			},
			{
				OptionName -> AliquotAmount,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
						Units -> {Microliter,{Microliter,Milliliter}}
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description -> "The amount that is transferred from the input cell sample to a new container in order to lyse a portion of the cell sample.",
				ResolutionDescription -> "Automatically set to Null if Aliquot is False. If Aliquot is True, AliquotAmount is automatically set to the amount required to attain the specified TargetCellCount. If TargetCellCount is not specified and AliquotContainer is specified, AliquotAmount is automatically set to the lesser of All of the input sample or enough sample to occupy half the volume of the specified AliquotContainer. If AliquotContainer is not specified, AliquotAmount is automatically set to 25% of the amount of input cell sample available.",
				Category -> "Aliquoting"
			},
			{
				OptionName -> AliquotContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}]
					],
					"Container with Index" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well and Index" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Index and Container"->{
							"Index" -> Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							"Container" -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container]}],
								PreparedSample -> False,
								PreparedContainer -> False
							]
						}
					}
				],
				Description -> "The container into which a portion of the cell sample is transferred prior to cell lysis.",
				ResolutionDescription -> "Automatically set to Null if Aliquot is False. If Aliquot is True, AliquotContainer is automatically set to a Model[Container] with sufficient capacity for the total volume of the experiment which is compatible with all of the mixing, incubation, and centrifugation conditions for the experiment.",
				Category -> "Aliquoting"
			},
			{
				OptionName -> AliquotContainerWell,
				Default->Automatic,
				AllowNull -> True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
					PatternTooltip -> "Enumeration must be any well from A1 to P24."
				],
				Description->"The well of the container into which the AliquotAmount is transferred prior to cell lysis.",
				ResolutionDescription->"Automatically set to the first empty well in AliquotContainer.",
				Category -> "Hidden"
			},
			{
				OptionName -> AliquotContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "A user defined word or phrase used to identify the container into which the cell sample is aliquoted prior to cell lysis.",
				Category -> "Aliquoting",
				UnitOperation -> True
			},

			(* --- OPTIONS FOR PELLETING PRIOR TO LYSIS --- *)

			{
				OptionName -> PreLysisPellet,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the cell sample is centrifuged to remove unwanted media prior to addition of LysisSolution.",
				ResolutionDescription -> "Automatically set to True if any of PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer are set. Otherwise, automatically set to True if and only if pelleting is necessary to obtain the specified TargetCellConcentration.",
				Category -> "Pelleting"
			},
			{
				OptionName -> PreLysisPelletingCentrifuge,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
					}
				],
				Description -> "The centrifuge used to apply centrifugal force to the cell samples at PreLysisPelletingIntensity for PreLysisPelletingTime in order to remove unwanted media prior to addition of LysisSolution.",
				ResolutionDescription -> "Automatically set to Model[Instrument, Centrifuge, \"HiG4\"] if PreLysisPellet is True. Otherwise, automatically set to Null.",
				Category -> "Pelleting"
			},
			{
				OptionName -> PreLysisPelletingIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Revolutions per Minute" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
						Units -> Alternatives[RPM]
					],
					"Relative Centrifugal Force" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
						Units -> Alternatives[GravitationalAcceleration]
					]
				],
				Description -> "The rotational speed or force applied to the cell sample to facilitate separation of the cells from the media.",
				ResolutionDescription -> "Automatically set to the PreLysisPelletingIntensity specified by the selected Method. If Method is set to Custom and PreLysisPellet is True, automatically set to 2850 RPM for Yeast cells, 4030 RPM for Bacterial cells, and 1560 RPM for Mammalian Cells. If PreLysisPellet is False, PreLysisPelletingIntensity is automatically set to Null.",
				Category -> "Pelleting"
			},
			{
				OptionName -> PreLysisPelletingTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The duration for which the cell sample is centrifuged at PreLysisPelletingIntensity to facilitate separation of the cells from the media.",
				ResolutionDescription -> "Automatically set to the PreLysisPelletingTime specified by the selected Method. If Method is set to Custom and PreLysisPellet is True, automatically set to 10 minutes.",
				Category -> "Pelleting"
			},
			{
				OptionName -> PreLysisSupernatantVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
						Units -> {Microliter,{Microliter,Milliliter}}
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description -> "The volume of the supernatant that is transferred to a new container after the cell sample is pelleted prior to optional dilution and addition of LysisSolution.",
				ResolutionDescription -> "Automatically set to 80% of the occupied volume of the container if PreLysisPellet is True. Otherwise, automatically set to Null.",
				Category -> "Pelleting"
			},
			{
				OptionName -> PreLysisSupernatantStorageCondition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Storage Type" -> Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP | Disposal
					],
					"Storage Object" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]]
					]
				],
				Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant isolated from the cell sample is stored upon completion of this protocol.",
				ResolutionDescription -> "Automatically set to Disposal if PreLysisPellet is True. Otherwise, automatically set to Null.",
				Category -> "Pelleting"
			},
			{
				OptionName -> PreLysisSupernatantContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}]
					],
					"Container with Index" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well and Index" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Index and Container"->{
							"Index" -> Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							"Container" -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container]}],
								PreparedSample -> False,
								PreparedContainer -> False
							]
						}
					}
				],
				Description -> "The container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
				ResolutionDescription -> "Automatically set to a Model[Container] with sufficient capacity for the volume of the supernatant using the PreferredContainer function if PreLysisPellet is True. If PreLysisSupernatantStorageCondition is set to Disposal for multiple samples, the supernatants corresponding to these samples are automatically combined into a common container for efficient disposal. If PreLysisPellet is False, automatically set to Null.",
				Category -> "Pelleting"
			},
			{
				OptionName -> PreLysisSupernatantContainerWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
					PatternTooltip -> "Enumeration must be any well from A1 to P24."
				],
				Description-> "The well of the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
				ResolutionDescription -> "Automatically set to the first empty well in PreLysisSupernatantContainer.",
				Category -> "Hidden"
			},
			{
				OptionName -> PreLysisSupernatantLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "A user defined word or phrase used to identify the supernatant which is transferred to a new container following pelleting of the cell sample by centrifugation, for use in downstream unit operations.",
				Category -> "Pelleting",
				UnitOperation -> True
			},
			{
				OptionName -> PreLysisSupernatantContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "A user defined word or phrase used to identify the new container into which the supernatant is transferred following pelleting of the cell sample by centrifugation, for use in downstream unit operations.",
				Category -> "Pelleting",
				UnitOperation -> True
			},

			(* --- OPTIONS FOR DILUTION PRIOR TO LYSIS --- *)

			{
				OptionName -> PreLysisDilute,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the cell sample is diluted prior to cell lysis.",
				ResolutionDescription -> "Automatically set to True if one or both of PreLysisDiluent and PreLysisDilutionVolume is specified, or if dilution is required to obtain the specified TargetCellConcentration. Otherwise, automatically set to False.",
				Category -> "Dilution"
			},
			{
				OptionName -> PreLysisDiluent,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Materials", "Reagents", "Buffers"}
					}
				],
				Description -> "The solution with which the cell sample is diluted prior to cell lysis.",
				ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"1x PBS from 10X stock\"] if PreLysisDilute is set to True. Otherwise, automatically set to Null.",
				Category -> "Dilution"
			},
			{
				OptionName -> PreLysisDilutionVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
					Units -> {Microliter,{Microliter,Milliliter}}
				],
				Description -> "The volume of PreLysisDiluent added to the cell sample (or AliqoutAmount, if a portion of the cell sample has been aliquoted to an AliquotContainer) prior to addition of LysisSolution.",
				ResolutionDescription -> "Automatically set to the volume necessary to obtain the TargetCellConcentration if PreLysisDilute is True and TargetCellConcentration is specified. If PreLysisDilute is True, TargetCellConcentration is unspecified, and AliquotContainer is specified, automatically set to 25% of the volume of AliquotContainer. If PreLysisDilute is True but neither of TargetCellConcentration or AliquotContainer are specified, PreLysisDilutionVolume is automatically set to 0 Microliter due to insufficient information to determine a reasonable dilution volume.",
				Category -> "Dilution"
			},

			(* --- CONDITIONS FOR PRIMARY LYSIS STEP --- *)

			{
				OptionName -> LysisSolution,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Materials", "Reagents"}
					}
				],
				Description -> "The solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics.",
				ResolutionDescription -> "Automatically set to the LysisSolution specified by the selected Method. If Method is set to Custom, automatically set according to the combination of CellType and TargetCellularComponents. LysisSolution is set to Model[Sample, \"TRIzol\"], Model[Sample, \"DNAzol\"], and Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"] when the TargetCellularComponent is RNA, GenomicDNA, and PlasmidDNA, respectively. If the TargetCellularComponent is CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, or Unspecified, the LysisSolution is automatically set to Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"] for Mammalian cells, Model[Sample, \"B-PER Bacterial Protein Extraction Reagent\"] for Bacterial cells, and Model[Sample, \"Y-PER Yeast Protein Extraction Reagent\"] for Yeast cells.",
				Category -> "Lysis Solution Addition"
			},
			{
				OptionName -> LysisSolutionVolume,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
						Units -> {Microliter,{Microliter,Milliliter}}
					],
					Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				],
				Description -> "The volume of LysisSolution to be added to the cell sample. If Aliquot is True, the LysisSolution is added to the AliquotContainer. Otherwise, the LysisSolution is added to the container of the input cell sample.",
				ResolutionDescription -> "LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps if Aliquot is False. If AliquotContainer is specified, automatically set to 50% of the unoccupied volume of AliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps. If Aliquot is True but AliquotContainer is unspecified, LysisSolutionVolume is automatically set to nine times the AliquotAmount divided by the NumberOfLysisSteps.",
				Category -> "Lysis Solution Addition"
			},
			{
				OptionName -> MixType,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
				Description -> "The manner in which the sample is mixed following combination of cell sample and LysisSolution.",
				ResolutionDescription -> "Automatically set to the MixType specified by the selected Method. If Method is set to Custom and either of MixVolume and NumberOfMixes are specified, automatically set to Pipette. If Method is set to Custom and any of MixRate, MixTime, and MixInstrument are specified, automatically set to Shake. Otherwise, MixType is automatically set to Shake if mixing is to occur in a plate or Pipette if it is to occur in a tube.",
				Category -> "Mixing"
			},
			{
				OptionName -> MixRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, $MaxMixRate], Units -> RPM],
				Description -> "The rate at which the sample is mixed by the selected MixType during the MixTime.",
				ResolutionDescription -> "Automatically set to the MixRate specified by the selected Method. If Method is set to Custom and MixType is set to Shake, automatically set to 200 RPM.",
				Category -> "Mixing"
			},
			{
				OptionName -> MixTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The duration for which the sample is mixed by the selected MixType following combination of the cell sample and the LysisSolution.",
				ResolutionDescription -> "If MixType is set to Shake, automatically set to the MixTime specified by the selected Method. If Method is set to Custom and MixType is set to Shake, automatically set to 1 minute.",
				Category -> "Mixing"
			},
			{
				OptionName -> NumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
				Description -> "The number of times that the sample is mixed by pipetting the MixVolume up and down following combination of the cell sample and the LysisSolution.",
				ResolutionDescription -> "If MixType is set to Pipette, automatically set to the NumberOfMixes specified by the selected Method. If Method is set to Custom and MixType is set to Pipette, automatically set to 10.",
				Category -> "Mixing"
			},
			{
				OptionName -> MixVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
					Units -> {Microliter,{Microliter,Milliliter}}
				],
				Description -> "The volume of the cell sample and LysisSolution displaced during each mix-by-pipette mix cycle.",
				ResolutionDescription -> "If MixType is set to Pipette, automatically set to the lesser of "<>ToString[$MaxRoboticSingleTransferVolume]<>" or 50% of the total solution volume within the container.",
				Category -> "Mixing"
			},
			{
				OptionName -> MixTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
						Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
					],
					"Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
				Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the MixTime, which occurs immediately before the LysisTime.",
				ResolutionDescription -> "Automatically set to the MixTemperature specified by the selected Method. If Method is set to Custom, automatically set to Ambient.",
				Category -> "Mixing"
			},
			{
				OptionName -> MixInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Mixing Devices"}
					}
				],
				Description -> "The device used to mix the cell sample by shaking.",
				ResolutionDescription -> "Automatically set to an available shaking device compatible with the specified MixRate and MixTemperature if MixType is set to Shake. Otherwise, automatically set to Null.",
				Category -> "Mixing"
			},
			{
				OptionName -> LysisTime,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The minimum duration for which the IncubationInstrument is maintained at the LysisTemperature to facilitate the disruption of cell membranes and release of cellular contents. The LysisTime occurs immediately after addition of LysisSolution and optional mixing.",
				ResolutionDescription -> "Automatically set to the LysisTime specified by the selected Method. If Method is set to Custon, automatically set to 15 Minute.",
				Category -> "Cell Lysis"
			},
			{
				OptionName -> LysisTemperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
						Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
					],
					"Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
				Description -> "The temperature at which the IncubationInstrument is maintained during the LysisTime, following the mixing of the cell sample and LysisSolution.",
				ResolutionDescription -> "Automatically set to the LysisTemperature specified by the selected Method. If Method is set to Custom, automatically set to Ambient.",
				Category -> "Cell Lysis"
			},
			{
				OptionName -> IncubationInstrument,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Heating", "Heat Blocks"}
					}
				],
				Description -> "The device used to cool or heat the cell sample to the LysisTemperature for the duration of the LysisTime.",
				ResolutionDescription -> "Automatically set to an integrated instrument compatible with the specified LysisTemperature.",
				Category -> "Cell Lysis"
			},

			(* --- CONDITIONS FOR SECONDARY LYSIS STEP --- *)

			{
				OptionName -> SecondaryLysisSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Materials", "Reagents"}
					}
				],
				Description -> "The solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional second lysis step.",
				ResolutionDescription -> "Automatically set to the SecondaryLysisSolution specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is greater than 1, automatically set to the LysisSolution employed in the first lysis step.",
				Category -> "Lysis Solution Addition"
			},
			{
				OptionName -> SecondaryLysisSolutionVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
						Units -> {Microliter,{Microliter,Milliliter}}
					],
					Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				],
				Description -> "The volume of SecondaryLysisSolution to be added to the cell sample in an optional second lysis step. If Aliquot is True, the SecondaryLysisSolution is added to the AliquotContainer. Otherwise, the SecondaryLysisSolution is added to the container of the input cell sample.",
				ResolutionDescription -> "Automatically set to Null if NumberOfLysisSteps is 1. If NumberOfLysisSteps is greater than 1, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps if Aliquot is False. If AliquotContainer is specified, automatically set to 50% of the unoccupied volume of AliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps. If Aliquot is True but AliquotContainer is unspecified, SecondaryLysisSolutionVolume is automatically set to nine times the AliquotAmount divided by the NumberOfLysisSteps.",
				Category -> "Lysis Solution Addition"
			},
			{
				OptionName -> SecondaryMixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
				Description -> "The manner in which the sample is mixed following combination of cell sample and SecondaryLysisSolution in an optional second lysis step.",
				ResolutionDescription -> "Automatically set to the SecondaryMixType specified by the selected Method. If Method is set to Custom and either of SecondaryMixVolume and SecondaryNumberOfMixes are specified, automatically set to Pipette. If Method is set to Custom and any of SecondaryMixRate, SecondaryMixTime, and SecondaryMixInstrument are specified, automatically set to Shake. Otherwise, SecondaryMixType is automatically set to Shake if mixing is to occur in a plate or Pipette if it is to occur in a tube.",
				Category -> "Mixing"
			},
			{
				OptionName -> SecondaryMixRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 RPM, $MaxMixRate],
					Units -> RPM
				],
				Description -> "The rate at which the sample is mixed by the selected SecondaryMixType during the SecondaryMixTime in an optional second lysis step.",
				ResolutionDescription -> "Automatically set to the SecondaryMixRate specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is greater than 1, and SecondaryMixType is set to Shake, automatically set to 200 RPM.",
				Category -> "Mixing"
			},
			{
				OptionName -> SecondaryMixTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The duration for which the sample is mixed by the selected SecondaryMixType following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
				ResolutionDescription -> "If SecondaryMixType is set to Shake, automatically set to the SecondaryMixTime specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is greater than 1, and SecondaryMixType is set to Shake, automatically set to 1 minute.",
				Category -> "Mixing"
			},
			{
				OptionName -> SecondaryNumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
				Description -> "The number of times that the sample is mixed by pipetting the SecondaryMixVolume up and down following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
				ResolutionDescription -> "If SecondaryMixType is set to Pipette and NumberOfLysisSteps is greater than 1, automatically set to the SecondaryNumberOfMixes specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is greater than 1, and SecondaryMixType is set to Pipette, automatically set to 10.",
				Category -> "Mixing"
			},
			{
				OptionName -> SecondaryMixVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
					Units -> {Microliter,{Microliter,Milliliter}}
				],
				Description -> "The volume of the cell sample and SecondaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional second lysis step.",
				ResolutionDescription -> "If SecondaryMixType is set to Pipette and NumberOfLysisSteps is greater than 1, automatically set to the lesser of "<>ToString[$MaxRoboticSingleTransferVolume]<>" or 50% of the total solution volume within the container.",
				Category -> "Mixing"
			},
			{
				OptionName -> SecondaryMixTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
						Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
					],
					"Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
				Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the SecondaryMixTime, which occurs immediately before the SecondaryLysisTime in an optional second lysis step.",
				ResolutionDescription -> "Automatically set to the SecondaryMixTemperature specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is greater than 1, automatically set to Ambient.",
				Category -> "Mixing"
			},
			{
				OptionName -> SecondaryMixInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Mixing Devices"}
					}
				],
				Description -> "The device used to mix the cell sample by shaking in an optional second lysis step.",
				ResolutionDescription -> "Automatically set to an available shaking device compatible with the specified SecondaryMixRate and SecondaryMixTemperature if SecondaryMixType is set to Shake and NumberOfLysisSteps is greater than 1. Otherwise, automatically set to Null.",
				Category -> "Mixing"
			},
			{
				OptionName -> SecondaryLysisTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The minimum duration for which the SecondaryIncubationInstrument is maintained at the SecondaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional second lysis step. The SecondaryLysisTime occurs immediately after addition of SecondaryLysisSolution and optional mixing.",
				ResolutionDescription -> "Automatically set to the SecondaryLysisTime specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is greater than 1, automatically set to 15 minutes.",
				Category -> "Cell Lysis"
			},
			{
				OptionName -> SecondaryLysisTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
						Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
					],
					"Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
				Description -> "The temperature at which the SecondaryIncubationInstrument is maintained during the SecondaryLysisTime, following the mixing of the cell sample and SecondaryLysisSolution in an optional second lysis step.",
				ResolutionDescription -> "Automatically set to the SecondaryLysisTemperature specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is greater than 1, automatically set to Ambient.",
				Category -> "Cell Lysis"
			},
			{
				OptionName -> SecondaryIncubationInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Heating", "Heat Blocks"}
					}
				],
				Description -> "The device used to cool or heat the cell sample to the SecondaryLysisTemperature for the duration of the SecondaryLysisTime in an optional second lysis step.",
				ResolutionDescription -> "If NumberOfLysisSteps is greater than 1, automatically set to an integrated instrument compatible with the specified SecondaryLysisTemperature.",
				Category -> "Cell Lysis"
			},

			(* --- CONDITIONS FOR TERTIARY LYSIS STEP --- *)

			{
				OptionName -> TertiaryLysisSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Materials", "Reagents"}
					}
				],
				Description -> "The solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional third lysis step.",
				ResolutionDescription -> "Automatically set to the TertiaryLysisSolution specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is 3, automatically set to the SecondaryLysisSolution employed in the second lysis step.",
				Category -> "Lysis Solution Addition"
			},
			{
				OptionName -> TertiaryLysisSolutionVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
						Units -> {Microliter,{Microliter,Milliliter}}
					],
					Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				],
				Description -> "The volume of TertiaryLysisSolution to be added to the cell sample in an optional third lysis step. If Aliquot is True, the TertiaryLysisSolution is added to the AliquotContainer. Otherwise, the TertiaryLysisSolution is added to the container of the input cell sample.",
				ResolutionDescription -> "Automatically set to Null if NumberOfLysisSteps is less than 3. If NumberOfLysisSteps is 3, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps if Aliquot is False. If AliquotContainer is specified, automatically set to 50% of the unoccupied volume of AliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps. If Aliquot is True but AliquotContainer is unspecified, TertiaryLysisSolutionVolume is automatically set to nine times the AliquotAmount divided by the NumberOfLysisSteps.",
				Category -> "Lysis Solution Addition"
			},
			{
				OptionName -> TertiaryMixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
				Description -> "The manner in which the sample is mixed following combination of cell sample and TertiaryLysisSolution in an optional third lysis step.",
				ResolutionDescription -> "Automatically set to the TertiaryMixType specified by the selected Method. If Method is set to Custom and either of TertiaryMixVolume and TertiaryNumberOfMixes are specified, automatically set to Pipette. If Method is set to Custom and any of TertiaryMixRate, TertiaryMixTime, and TertiaryMixInstrument are specified, automatically set to Shake. Otherwise, TertiaryMixType is automatically set to Shake if mixing is to occur in a plate or Pipette if it is to occur in a tube.",
				Category -> "Mixing"
			},
			{
				OptionName -> TertiaryMixRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, $MaxMixRate], Units -> RPM],
				Description -> "The rate at which the sample is mixed by the selected TertiaryMixType during the TertiaryMixTime in an optional third lysis step.",
				ResolutionDescription -> "Automatically set to the TertiaryMixRate specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is 3, and TertiaryMixType is set to Shake, automatically set to 200 RPM.",
				Category -> "Mixing"
			},
			{
				OptionName -> TertiaryMixTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The duration for which the sample is mixed by the selected TertiaryMixType following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
				ResolutionDescription -> "If TertiaryMixType is set to Shake, automatically set to the TertiaryMixTime specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is 3, and TertiaryMixType is set to Shake, automatically set to 1 minute.",
				Category -> "Mixing"
			},
			{
				OptionName -> TertiaryNumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
				Description -> "The number of times that the sample is mixed by pipetting the TertiaryMixVolume up and down following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
				ResolutionDescription -> "If TertiaryMixType is set to Pipette and NumberOfLysisSteps is 3, automatically set to the TertiaryNumberOfMixes specified by the selected Method. If Method is set to Custom and TertiaryMixType is set to Pipette, automatically set to 10.",
				Category -> "Mixing"
			},
			{
				OptionName -> TertiaryMixVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
					Units -> {Microliter,{Microliter,Milliliter}}
				],
				Description -> "The volume of the cell sample and TertiaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional third lysis step.",
				ResolutionDescription -> "If TertiaryMixType is set to Pipette and NumberOfLysisSteps is 3, automatically set to the TertiaryMixVolume specified by the selected Method. If Method is set to Custom and TertiaryMixType is set to Pipette, automatically set to the lesser of "<>ToString[$MaxRoboticSingleTransferVolume]<>" or 50% of the total solution volume within the container.",
				Category -> "Mixing"
			},
			{
				OptionName -> TertiaryMixTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
						Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
					],
					"Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
				Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the TertiaryMixTime, which occurs immediately before the TertiaryLysisTime in an optional third lysis step.",
				ResolutionDescription -> "Automatically set to the TertiaryMixTemperature specified by the selected Method. If Method is set to Custom, automatically set to Ambient.",
				Category -> "Mixing"
			},
			{
				OptionName -> TertiaryMixInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Mixing Devices"}
					}
				],
				Description -> "The device used to mix the cell sample by shaking in an optional third lysis step.",
				ResolutionDescription -> "If NumberOfLysisSteps is 3 and TertiaryMixType is set to Shake, automatically set to an available shaking device compatible with the specified TertiaryMixRate and TertiaryMixTemperature.",
				Category -> "Mixing"
			},
			{
				OptionName -> TertiaryLysisTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The minimum duration for which the TertiaryIncubationInstrument is maintained at the TertiaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional third lysis step. The TertiaryLysisTime occurs immediately after addition of TertiaryLysisSolution and optional mixing.",
				ResolutionDescription -> "Automatically set to the TertiaryLysisTime specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is 3, automatically set to 15 minutes.",
				Category -> "Cell Lysis"
			},
			{
				OptionName -> TertiaryLysisTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
						Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
					],
					"Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
				Description -> "The temperature at which the TertiaryIncubationInstrument is maintained during the TertiaryLysisTime, following the mixing of the cell sample and TertiaryLysisSolution in an optional third lysis step.",
				ResolutionDescription -> "Automatically set to the TertiaryLysisTemperature specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is 3, automatically set to Ambient.",
				Category -> "Cell Lysis"
			},
			{
				OptionName -> TertiaryIncubationInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Heating", "Heat Blocks"}
					}
				],
				Description -> "The device used to cool or heat the cell sample to the TertiaryLysisTemperature for the duration of the TertiaryLysisTime in an optional third lysis step.",
				ResolutionDescription -> "If NumberOfLysisSteps is 3, automatically set to an integrated instrument compatible with the specified TertiaryLysisTemperature.",
				Category -> "Cell Lysis"
			},

			(* --- LYSATE CLARIFICATION --- *)

			{
				OptionName -> ClarifyLysate,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the lysate is centrifuged to remove cellular debris following incubation in the presence of LysisSolution.",
				ResolutionDescription -> "Automatically set to match the ClarifyLysate field of the selected Method, or set to True if any of ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, or PostClarificationPelletStorageCondition are specified. Otherwise, automatically set to False.",
				Category -> "Lysate Clarification"
			},
			{
				OptionName -> ClarifyLysateCentrifuge,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
					}
				],
				Description -> "The centrifuge used to apply centrifugal force to the cell samples at ClarifyLysateIntensity for ClarifyLysateTime in order to facilitate separation of suspended, insoluble cellular debris into a solid phase at the bottom of the container.",
				ResolutionDescription -> "Automatically set to Model[Instrument, Centrifuge, \"HiG4\"] if ClarifyLysate is True. Otherwise, automatically set to Null.",
				Category -> "Lysate Clarification"
			},
			{
				OptionName -> ClarifyLysateIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Revolutions per Minute" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
						Units -> Alternatives[RPM]
					],
					"Relative Centrifugal Force" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
						Units -> Alternatives[GravitationalAcceleration]
					]
				],
				Description -> "The rotational speed or force applied to the lysate to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
				ResolutionDescription -> "Automatically set to the ClarifyLysateIntensity specified by the selected Method. If Method is set to Custom and ClarifyLysate is True, automatically set to the maximum rotational speed possible with the workcell-integrated centrifuge (5700 RPM).",
				Category -> "Lysate Clarification"
			},
			{
				OptionName -> ClarifyLysateTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Description -> "The duration for which the lysate is centrifuged at ClarifyLysateIntensity to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
				ResolutionDescription -> "Automatically set to the ClarifyLysateTime specified by the selected Method. If Method is set to Custom and ClarifyLysate is True, automatically set to 10 minutes.",
				Category -> "Lysate Clarification"
			},
			{
				OptionName -> ClarifiedLysateVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
						Units -> {Microliter,{Microliter,Milliliter}}
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description -> "The volume of lysate transferred to a new container following clarification by centrifugation.",
				ResolutionDescription -> "Automatically set to 90% of the volume of the lysate if ClarifyLysate is True.",
				Category -> "Lysate Clarification"
			},
			{
				OptionName -> PostClarificationPelletLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "A user defined word or phrase used to identify the pelleted sample resulting from the centrifugation of lysate to remove cellular debris, for use in downstream unit operations.",
				Category -> "Lysate Clarification",
				UnitOperation -> True
			},
			{
				OptionName -> PostClarificationPelletContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}]
					],
					"Container with Index" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well and Index" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Index and Container"->{
							"Index" -> Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							"Container" -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container]}],
								PreparedSample -> False,
								PreparedContainer -> False
							]
						}
					}
				],
				Description -> "The container in which the pellet resulting from lysate clarification remains following the lysis experiment.",
				ResolutionDescription -> "If ClarifyLysate is True, automatically set to the AliquotContainer if Aliquot is True and the input container if Aliquot is False. If ClarifyLysate is False, the PostClarificationPelletContainer is set to Null.",
				Category -> "Hidden"
			},
			{
				OptionName -> PostClarificationPelletContainerWell,
				Default->Automatic,
				AllowNull -> True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
					PatternTooltip -> "Enumeration must be any well from A1 to P24."
				],
				Description->"The well of the container in which the pellet resulting from lysate clarification remains following the lysis experiment.",
				ResolutionDescription->"Automatically set to the first empty well in PostClarificationPelletContainer.",
				Category -> "Hidden"
			},
			{
				OptionName -> PostClarificationPelletContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "A user defined word or phrase used to identify the container in which the pelleted sample resulting from the centrifugation of lysate to remove cellular debris is located, for use in downstream unit operations.",
				Category -> "Lysate Clarification",
				UnitOperation -> True
			},
			{
				OptionName -> PostClarificationPelletStorageCondition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Storage Type" -> Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP | Disposal
					],
					"Storage Object" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]]
					]
				],
				Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the pelleted sample resulting from the centrifugation of lysate to remove cellular debris is stored upon completion of this protocol.",
				ResolutionDescription -> "Automatically set to Disposal if ClarifyLysate is True.",
				Category -> "Lysate Clarification"
			},
			{
				OptionName -> ClarifiedLysateContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}]
					],
					"Container with Index" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well and Index" -> {
						"Well" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						"Index and Container"->{
							"Index" -> Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							"Container" -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container]}],
								PreparedSample -> False,
								PreparedContainer -> False
							]
						}
					}
				],
				Description -> "The container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
				ResolutionDescription -> "Automatically set to a Model[Container] with sufficient capacity for the volume of the clarified lysate using the PreferredContainer function if ClarifyLysate is True. If ClarifyLysate is False, automatically set to Null.",
				Category -> "Lysate Clarification"
			},
			{
				OptionName -> ClarifiedLysateContainerWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
					PatternTooltip -> "Enumeration must be any well from A1 to P24."
				],
				Description->"The well of the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
				Category -> "Hidden"
			},
			{
				OptionName -> ClarifiedLysateContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "A user defined word or phrase used to identify the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
				Category -> "Lysate Clarification",
				UnitOperation -> True
			},

			(* --- LYSATE STORAGE AND HANDLING --- *)

			{
				OptionName -> SamplesOutStorageCondition,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Storage Type" -> Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP | Disposal
					],
					"Storage Object" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]]
					]
				],
				Description -> "The set of parameters that define the temperature, safety, and other environmental conditions under which the lysate generated from the cell lysis experiment is stored upon completion of this protocol.",
				ResolutionDescription -> "Automatically set to Freezer.",
				Category -> "Storage"
			},
			{
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				],
				Description -> "A user defined word or phrase used to identify the lysate resulting from the disruption of cell membranes, for use in downstream unit operations.",
				Category -> "Storage",
				UnitOperation -> True
			}
		],

		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Number, Pattern :> RangeP[2, 200, 1]],
			Description -> "The number of wells into which the cell sample is aliquoted prior to the lysis experiment and subsequent unit operations, including extraction of cellular components such as nucleic acids, proteins, or organelles.",
			Category -> "General"
		},

		(* --- Shared Options --- *)
		RoboticPreparationOption,
		RoboticInstrumentOption,
		ProtocolOptions,
		SimulationOption,
		BiologyPostProcessingOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		WorkCellOption
	}
];



(* ::Subsubsection::Closed:: *)
(*Messages*)

(* Useful lists of options *)

$PreLysisPelletingOptions =
		{
			PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime,
			PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, PreLysisSupernatantContainer
		};

$LysateClarificationOptions =
		{
			ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, PostClarificationPelletStorageCondition, ClarifiedLysateContainer
		};

$SecondaryLysisOptions =
		{
			SecondaryLysisSolution, SecondaryLysisSolutionVolume, SecondaryMixType, SecondaryMixRate, SecondaryMixTime,
			SecondaryMixVolume, SecondaryNumberOfMixes, SecondaryMixTemperature, SecondaryLysisTemperature, SecondaryLysisTime,
			SecondaryMixInstrument, SecondaryIncubationInstrument
		};

$SecondaryLysisOptionsWithLysisPrefix =
		{
			SecondaryLysisSolution, SecondaryLysisSolutionVolume, SecondaryLysisMixType, SecondaryLysisMixRate, SecondaryLysisMixTime,
			SecondaryLysisMixVolume, SecondaryNumberOfLysisMixes, SecondaryLysisMixTemperature, SecondaryLysisTemperature, SecondaryLysisTime,
			SecondaryLysisMixInstrument, SecondaryLysisIncubationInstrument
		};

$TertiaryLysisOptions =
		{
			TertiaryLysisSolution, TertiaryLysisSolutionVolume, TertiaryMixType, TertiaryMixRate, TertiaryMixTime,
			TertiaryMixVolume, TertiaryNumberOfMixes, TertiaryMixTemperature, TertiaryLysisTemperature, TertiaryLysisTime,
			TertiaryMixInstrument, TertiaryIncubationInstrument
		};

$TertiaryLysisOptionsWithLysisPrefix =
		{
			TertiaryLysisSolution, TertiaryLysisSolutionVolume, TertiaryLysisMixType, TertiaryLysisMixRate, TertiaryLysisMixTime,
			TertiaryLysisMixVolume, TertiaryNumberOfLysisMixes, TertiaryLysisMixTemperature, TertiaryLysisTemperature, TertiaryLysisTime,
			TertiaryLysisMixInstrument, TertiaryLysisIncubationInstrument
		};

$TemperatureControlOptions =
		{
			MixTemperature, SecondaryMixTemperature, TertiaryMixTemperature, LysisTemperature, SecondaryLysisTemperature, TertiaryLysisTemperature
		};

$TemperatureControlOptionsWithLysisPrefix =
		{
			LysisMixTemperature, SecondaryLysisMixTemperature, TertiaryLysisMixTemperature, LysisTemperature, SecondaryLysisTemperature, TertiaryLysisTemperature
		};

$InstrumentOptions =
		{
			RoboticInstrument, PreLysisPelletingCentrifuge, ClarifyLysateCentrifuge,
			MixInstrument, SecondaryMixInstrument,  TertiaryMixInstrument,
			IncubationInstrument, SecondaryIncubationInstrument, TertiaryIncubationInstrument
		};

(* CONFLICTING OR UNRESOLVABLE OPTIONS *)
Error::UnsupportedCellType = "The samples `1` at indices `3` have a CellType of `2`. These CellType(s) were either input by the user, informed by the chosen Method, or automatically set to match the CellType Field in the sample object(s). ExperimentLyseCells is currently only available for Mammalian, Bacterial, and Yeast cells.";
Error::InsufficientSecondaryLysisOptions = "The sample(s) `1` at indices `5` have option(s) `2` set to Null. This conflicts with the NumberOfLysisSteps option, which is set to `4`. Please adjust these options to make them consistent with the NumberOfLysisSteps option in order to submit a valid experiment.";
Error::InsufficientTertiaryLysisOptions = "The sample(s) `1` at indices `5` have option(s) `2` set to Null. This conflicts with the NumberOfLysisSteps option, which is set to `4`. Please adjust these options to make them consistent with the NumberOfLysisSteps option in order to submit a valid experiment.";
Error::ExtraneousSecondaryLysisOptions = "The sample(s) `1` at indices `5` have option(s) `2` set to `3`. This conflicts with the NumberOfLysisSteps option, which is set to `4`. Please adjust these options to make them consistent with the NumberOfLysisSteps option in order to submit a valid experiment.";
Error::ExtraneousTertiaryLysisOptions = "The sample(s) `1` at indices `5` have option(s) `2` set to `3`. This conflicts with the NumberOfLysisSteps option, which is set to `4`. Please adjust these options to make them consistent with the NumberOfLysisSteps option in order to submit a valid experiment.";
Error::AliquotOptionsMismatch = "The sample(s) `1` at indices `5` have the Aliquot option set to `4` with option(s) `2` set to `3`. Please adjust these options such that all aliquoting options for a given sample are consistent with one another in order to submit a valid experiment.";
Error::PreLysisPelletOptionsMismatch = "The sample(s) `1` at indices `5` have the PreLysisPellet option set to `4` with option(s) `2` set to `3`. Please adjust these options such that all pre-lysis pelleting options for a given sample are consistent with one another in order to submit a valid experiment.";
Error::PreLysisDiluteOptionsMismatch = "The sample(s) `1` at indices `5` have the PreLysisDilute option set to `4` with option(s) `2` set to `3`. Please adjust these options such that all pre-lysis dilution options for a given sample are consistent with one another in order to submit a valid experiment.";
Error::ClarifyLysateOptionsMismatch = "The sample(s) `1` at indices `5` have the ClarifyLysate option set to `4` with option(s) `2` set to `3`. Please adjust these options such that all lysate clarification options for a given sample are consistent with one another in order to submit a valid experiment.";
Error::AliquotAdherentCells = "The Aliquot option is set to True for the sample(s) `1` at indices `2`, whose CultureAdhesion is Adherent. However, the Dissociate option is set to False. Please set Dissociate to True for all samples to be aliquoted containing adherent cells in order to submit a valid experiment.";
Error::NoCellCountOrConcentrationData = "The option(s) `2` are specified as `3` for the sample(s) `1` at indices `4`, but the sample(s) do not have the necessary cell count or cell concentration data in their Composition field to calculate the `2`. Please use samples with sufficient Composition data (or set `2` to Automatic or Null) in order to submit a valid experiment:";
Error::InsufficientCellCount = "A TargetCellCount of `2` cells is specified for the sample(s) `1` at indices `5`, with the NumberOfReplicates option set to `3`. As such, the number of cells, `4`, present in the sample is insufficient to carry out this experiment. Please adjust these options accordingly in order to submit a valid experiment:";
Error::ReplicateAliquotsRequiredForLysis = "The sample(s) `1` at indices `3` have the Aliquot option set to False while the NumberOfReplicates option is set to `2`. Please set Aliquot to True for all samples whenever NumberOfReplicates is set to 2 or more in order to submit a valid experiment.";
Error::MixByShakingOptionsMismatch = "The sample(s) `1` at indices `4` have the MixType option set to Shake with the options `2` set to `3`. When MixType is set to Shake, the options MixRate, MixTime, MixTemperature, and MixInstrument must not be Null, while the options NumberOfMixes and MixVolume must be Null. Please adjust these conflicting options in order to submit a valid experiment.";
Error::SecondaryMixByShakingOptionsMismatch = "The sample(s) `1` at indices `4` have the SecondaryMixType option set to Shake with the options `2` set to `3`. When SecondaryMixType is set to Shake, the options SecondaryMixRate, SecondaryMixTime, SecondaryMixTemperature, and SecondaryMixInstrument must not be Null, while the options SecondaryNumberOfMixes and SecondaryMixVolume must be Null. Please adjust these conflicting options in order to submit a valid experiment.";
Error::TertiaryMixByShakingOptionsMismatch = "The sample(s) `1` at indices `4` have the TertiaryMixType option set to Shake with the options `2` set to `3`. When TertiaryMixType is set to Shake, the options TertiaryMixRate, TertiaryMixTime, TertiaryMixTemperature, and TertiaryMixInstrument must not be Null, while the options TertiaryNumberOfMixes and TertiaryMixVolume must be Null. Please adjust these conflicting options in order to submit a valid experiment.";
Error::MixByPipettingOptionsMismatch = "The sample(s) `1` at indices `4` have the MixType option set to Pipette with the options `2` set to `3`. When MixType is set to Pipette, the options NumberOfMixes and MixVolume must not be Null, while the options MixRate, MixTime, and MixInstrument must be Null and the option MixTemperature must be Null, Ambient, or "<>ToString[$AmbientTemperature]<>". Please adjust these conflicting options in order to submit a valid experiment.";
Error::SecondaryMixByPipettingOptionsMismatch = "The sample(s) `1` at indices `4` have the SecondaryMixType option set to Pipette with the options `2` set to `3`. When SecondaryMixType is set to Pipette, the options SecondaryNumberOfMixes and SecondaryMixVolume must not be Null, while the options SecondaryMixRate, SecondaryMixTime, and SecondaryMixInstrument must be Null and the option SecondaryMixTemperature must be Null, Ambient, or "<>ToString[$AmbientTemperature]<>". Please adjust these conflicting options in order to submit a valid experiment.";
Error::TertiaryMixByPipettingOptionsMismatch = "The sample(s) `1` at indices `4` have the TertiaryMixType option set to Pipette with the options `2` set to `3`. When TertiaryMixType is set to Pipette, the options TertiaryNumberOfMixes and TertiaryMixVolume must not be Null, while the options TertiaryMixRate, TertiaryMixTime, and TertiaryMixInstrument must be Null and the option TertiaryMixTemperature must be Null, Ambient, or "<>ToString[$AmbientTemperature]<>". Please adjust these conflicting options in order to submit a valid experiment.";
Error::MixTypeNoneMismatch = "The sample(s) `1` at indices `4` have MixType set to None, but the option(s) `2` are set to `3`. When MixType is set to None, the options MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, and MixInstrument must be Null. Please adjust these conflicting options in order to submit a valid experiment.";
Error::SecondaryMixTypeNoneMismatch = "The sample(s) `1` at indices `4` have SecondaryMixType set to None, but the option(s) `2` are set to `3`. When SecondaryMixType is set to None, the options SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixVolume, SecondaryMixTemperature, and SecondaryMixInstrument must be Null. Please adjust these conflicting options in order to submit a valid experiment.";
Error::TertiaryMixTypeNoneMismatch = "The sample(s) `1` at indices `4` have TertiaryMixType set to None, but the option(s) `2` are set to `3`. When TertiaryMixType is set to None, the options TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixVolume, TertiaryMixTemperature, and TertiaryMixInstrument must be Null. Please adjust these conflicting options in order to submit a valid experiment.";
Error::ConflictingMixOptionsInSameContainerForLysis = "The container(s) `2` at indices `3` contain sample(s) `1` with conflicting conditions for one or more of the following options: MixType, MixRate, MixTime, MixInstrument, MixTemperature, SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryMixInstrument, SecondaryMixTemperature, TertiaryMixType, TertiaryMixRate, TertiaryMixTime, and TertiaryMixInstrument, TertiaryMixTemperature. Please adjust these options such that experiments with conflicting conditions occur in different containers in order to submit a valid experiment.";
Error::ConflictingIncubationOptionsInSameContainerForLysis = "The container(s) `2` at indices `3` contain sample(s) `1` with conflicting conditions for one or more of the following options: LysisTime, LysisTemperature, IncubationInstrument, SecondaryLysisTime, SecondaryLysisTemperature, SecondaryIncubationInstrument, TertiaryLysisTime, TertiaryLysisTemperature, TertiaryIncubationInstrument. Please adjust these options such that experiments with conflicting conditions occur in different containers in order to submit a valid experiment.";
Error::ConflictingCentrifugationConditionsInSameContainerForLysis = "The container(s) `2` at indices `3` contain sample(s) `1` with conflicting conditions for one or more of the following options: PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime. Please adjust these options such that experiments with conflicting conditions occur in different containers in order to submit a valid experiment.";
Error::DissociateSuspendedCells = "The CultureAdhesion for the sample(s) `1` at indices `2` is Suspension, but the Dissociate option is set to True for these sample(s). Please set Dissociate to False for all samples containing suspended cells in order to submit a valid experiment.";
Error::UnresolvablePreLysisDilutionVolume = "There is not sufficient information available to determine a reasonable PreLysisDilutionVolume for the sample(s) `1` at indices `2`. Please specify PreLysisDilutionVolume or TargetCellConcentration for all samples for which PreLysisDilute is set to True in order to submit a valid experiment.";
Error::UnknownCultureAdhesion = "The CultureAdhesion option is not specified for the sample(s) `1` at indices `2`, and the sample object(s) indicate that the sample(s) are Living but contain no CultureAdhesion information. The value for the CultureAdhesion option is automatically set to Adherent for the sample(s). Please specify the CultureAdhesion option or update the CultureAdhesion field in the sample object(s) in order to submit a valid experiment.";
Error::ConflictingSamplesOutStorageConditionInSameContainer = "The samples `1` at indices `4` will be in container(s) `2` following the cell lysis experiment under the currently specified conditions, and the SamplesOutStorageCondition option for these samples are currently set to `3`. Please adjust the SamplesOutStorageCondition option or adjust container specifications such that no two (or more) samples in the same final container have different storage conditions in order to submit a valid experiment.";
Error::ConflictingPreLysisSupernatantStorageConditionInSameContainer = "The supernatants resulting from pre-lysis pelleting of samples(s) `1` at indices `4` will be transferred into PreLysisSupernatantContainer(s) `2`, and the PreLysisSupernatantStorageCondition option for these samples are currently set to `3`. Please adjust the PreLysisSupernatantStorageCondition or PreLysisSupernatantContainer options such that no two (or more) samples in the same PreLysisSupernatantContainer have different storage conditions in order to submit a valid experiment.";
Error::ConflictingPostClarificationPelletStorageConditionInSameContainer = "The pellets resulting from lysate clarification of samples `1` at indices `4` will be in container(s) `2` following the lysate clarification step of the cell lysis experiment, and the PostClarificationPelletStorageCondition option for these samples are currently set to `3`. Please adjust the PostClarificationPelletStorageCondition option or adjust container specifications such that no two (or more) samples with different PostClarificationPelletStorageConditions are clarified in the same container in order to submit a valid experiment. This can easily be achieved by setting Aliquot to True and AliquotContainer to Automatic at these indices.";
Warning::PelletingRequiredToObtainTargetCellConcentration = "The sample(s), `1` at indices `3` require pelleting and removal of the supernatant prior to lysis in order to obtain the specified TargetCellConcentration, `2` cells per milliliter. PreLysisPellet will be automatically set to True for these samples.";
Warning::UnknownCellType = "The CellType option is not specified for the sample(s) `1` at indices `2`, and the sample object(s) contain no CellType information. The value for the CellType option is automatically set to Bacterial for these sample(s).";
Warning::LowRelativeLysisSolutionVolume = "The sample(s) `1` at indices `4` will have a volume of `3` (including volume adjustments from optional dilution and pelleting steps) prior to the addition of lysis solution(s), whose total volume `2` is less than that of the sample volume. The low relative volume of lysis solution(s) in the experiment may negatively impact the efficiency of cell lysis. Please consider adjusting the options such that the volume of lysis solutions is a larger proportion of the total experiment volume.";
Warning::AliquotingRequiredForCellLysis = "The sample(s) `1` at indices `2` will be aliquoted into a new container prior to the cell lysis experiment because one or more of the following is true: the sample container is not compatible with a necessary centrifugation step; the sample container is not compatible with a necessary mixing or temperature control setting; the sample container would be more than 75% full before addition of LysisSolution under the current conditions; one or more of the options NumberOfReplicates, TargetCellCount, or TargetCellConcentration are specified by the user.";

(* ::Subsection::Closed:: *)
(* ExperimentLyseCells*)


(* - Container to Sample Overload - *)

ExperimentLyseCells[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{cache, listedOptions,listedContainers,outputSpecification,output,gatherTests,containerToSampleResult,
		containerToSampleOutput,samples,sampleOptions,containerToSampleTests,simulation,
		containerToSampleSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* Fetch the cache from listedOptions. *)
	cache=ToList[Lookup[listedOptions, Cache, {}]];
	simulation=Lookup[listedOptions, Simulation, Null];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentLyseCells,
			listedContainers,
			listedOptions,
			Output->{Result,Tests,Simulation},
			Simulation->simulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentLyseCells,
				listedContainers,
				listedOptions,
				Output-> {Result,Simulation},
				Simulation->simulation
			],
			$Failed,
			{Download::ObjectDoesNotExist, Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
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
		ExperimentLyseCells[samples,ReplaceRule[sampleOptions,Simulation->simulation]]
	]
];

(* -- Main Overload --*)
ExperimentLyseCells[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		cache, cacheBall, collapsedResolvedOptions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
		listedSamples, messages, output, outputSpecification, lyseCellsCache, performSimulationQ, resultQ,
		protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, numberOfReplicatesNoNull,
		expandedSamplesWithNumReplicates, resourceResult, resourcePacketTests,
		returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation,
		runTime, inheritedSimulation, validLengths, validLengthTests, simulation, listedSanitizedSamples,
		listedSanitizedOptions, userSpecifiedObjects, objectsExistQs, objectsExistTests,
		sampleDownloadFields, methodObjects, lyseCellsMethodFields, extractAndHarvestMethodFields,
		instrumentOptions, userSpecifiedInstruments, defaultInstruments, instrumentFields, modelInstrumentFields
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Remove temporal links *)
	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[ExperimentLyseCells,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentLyseCells,listedOptions,AutoCorrect->False],{}}
	];
	inheritedSimulation = Lookup[safeOptions, Simulation, Null];

	(* Get the number of replicates, replacing Null with 1 *)
	numberOfReplicatesNoNull = Lookup[safeOptions, NumberOfReplicates] /. Null -> 1;

	(* Call sanitize-inputs to clean any objects referenced by Name; i.e., reference them by ID instead *)
	{listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions, Simulation -> inheritedSimulation];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentLyseCells,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentLyseCells,{listedSanitizedSamples},listedSanitizedOptions],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentLyseCells,{listedSanitizedSamples},listedSanitizedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentLyseCells,{listedSanitizedSamples},listedSanitizedOptions],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentLyseCells,{listedSanitizedSamples},inheritedOptions]];

	(* Fetch the Cache option *)
	cache=Lookup[expandedSafeOps, Cache, {}];

	(* Disallow Upload->False and Confirm->True. *)
	(* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
	If[MatchQ[Lookup[safeOps,Upload],False]&&TrueQ[Lookup[safeOps,Confirm]],
		Message[Error::ConfirmUploadConflict];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Make sure that all of our objects exist. *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten[{ToList[mySamples],ToList[myOptions]}],
		ObjectReferenceP[]
	];

	objectsExistQs = DatabaseMemberQ[userSpecifiedObjects, Simulation->inheritedSimulation];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{userSpecifiedObjects,objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects,objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[userSpecifiedObjects,objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,templateTests,objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Fields to download from samples *)
	sampleDownloadFields={
		SamplePreparationCacheFields[Object[Sample], Format->Packet],
		Packet[Model[SamplePreparationCacheFields[Model[Sample]]]],
		Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
		Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]],
		Packet[Living]
	};

	(* Fields to download from extraction Method objects *)
	methodObjects = Lookup[expandedSafeOps, Method];
	lyseCellsMethodFields = Packet[{
		CellType,
		TargetCellularComponent,
		NumberOfLysisSteps,
		PreLysisPellet,
		PreLysisPelletingIntensity,
		PreLysisPelletingTime,
		LysisSolution,
		MixType,
		MixRate,
		MixTime,
		NumberOfMixes,
		MixTemperature,
		LysisTime,
		LysisTemperature,
		SecondaryLysisSolution,
		SecondaryMixType,
		SecondaryMixRate,
		SecondaryMixTime,
		SecondaryNumberOfMixes,
		SecondaryMixTemperature,
		SecondaryLysisTime,
		SecondaryLysisTemperature,
		TertiaryLysisSolution,
		TertiaryMixType,
		TertiaryMixRate,
		TertiaryMixTime,
		TertiaryNumberOfMixes,
		TertiaryMixTemperature,
		TertiaryLysisTime,
		TertiaryLysisTemperature,
		ClarifyLysate,
		ClarifyLysateIntensity,
		ClarifyLysateTime
	}];
	extractAndHarvestMethodFields = Packet[{
		CellType,
		TargetCellularComponent,
		NumberOfLysisSteps,
		PreLysisPellet,
		PreLysisPelletingIntensity,
		PreLysisPelletingTime,
		LysisSolution,
		LysisMixType,
		LysisMixRate,
		LysisMixTime,
		NumberOfLysisMixes,
		LysisMixTemperature,
		LysisTime,
		LysisTemperature,
		SecondaryLysisSolution,
		SecondaryLysisMixType,
		SecondaryLysisMixRate,
		SecondaryLysisMixTime,
		SecondaryNumberOfLysisMixes,
		SecondaryLysisMixTemperature,
		SecondaryLysisTime,
		SecondaryLysisTemperature,
		TertiaryLysisSolution,
		TertiaryLysisMixType,
		TertiaryLysisMixRate,
		TertiaryLysisMixTime,
		TertiaryNumberOfLysisMixes,
		TertiaryLysisMixTemperature,
		TertiaryLysisTime,
		TertiaryLysisTemperature,
		ClarifyLysate,
		ClarifyLysateIntensity,
		ClarifyLysateTime
	}];

	(* Options whose inputs could be an instrument object or model *)
	instrumentOptions = {
		RoboticInstrument,
		PreLysisPelletingCentrifuge,
		MixInstrument,
		IncubationInstrument,
		SecondaryMixInstrument,
		SecondaryIncubationInstrument,
		TertiaryMixInstrument,
		TertiaryIncubationInstrument,
		ClarifyLysateCentrifuge
	};

	(* Extract any instrument objects that the user has explicitly specified *)
	userSpecifiedInstruments = DeleteDuplicates @ Cases[
		Flatten @ Lookup[ToList[myOptions], instrumentOptions, Null],
		ObjectP[]
	];

	defaultInstruments = {
		Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
		Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
		Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
		Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
		Model[Instrument, Shaker, "id:eGakldJkWVnz"], (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
		Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
	};

	instrumentFields = {
		Packet[Model, Status, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature],
		Packet[Model[{ModelName, Deprecated, Positions}]]
	};

	modelInstrumentFields = Packet[{Name, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature, Positions}];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	lyseCellsCache = Quiet[
		Download[
			{
				listedSanitizedSamples,
				methodObjects,
				methodObjects,
				Join[{userSpecifiedInstruments, defaultInstruments}],
				Join[{userSpecifiedInstruments, defaultInstruments}]
			},
			Evaluate[{
				sampleDownloadFields,
				lyseCellsMethodFields,
				extractAndHarvestMethodFields,
				instrumentFields,
				modelInstrumentFields
			}],
			Cache->cache,
			Simulation ->inheritedSimulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[{cache,lyseCellsCache}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentLyseCellsOptions[
			ToList[Download[mySamples,Object]],
			expandedSafeOps,
			Cache->cacheBall,
			Simulation->inheritedSimulation,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests} = {
				resolveExperimentLyseCellsOptions[
					ToList[Download[mySamples,Object]],
					expandedSafeOps,
					Cache->cacheBall,
					Simulation->inheritedSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentLyseCells,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			True,
		gatherTests,
			Not[RunUnitTest[<|"Tests"->resolvedOptionsTests|>, Verbose->False, OutputFormat->SingleBoolean]],
		True,
			False
	];

	performSimulationQ = MemberQ[output, Result|Simulation];
	resultQ = MemberQ[output, Result];

	(* If option resolution failed, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentLyseCells,collapsedResolvedOptions],
			Preview->Null,
			Simulation -> Simulation[]
		}]
	];

	(* Expand the samples and sample packets according to the number of replicates *)
	expandedSamplesWithNumReplicates = Flatten[Map[
		ConstantArray[#, numberOfReplicatesNoNull]&,
		Download[ToList[mySamples], Object]
	]];

	(* Build packets with resources *)
	{{resourceResult, roboticSimulation, runTime}, resourcePacketTests} = Which[
		MatchQ[resolvedOptionsResult, $Failed],
		{{$Failed, $Failed, $Failed}, {}},
		gatherTests,
		lyseCellsResourcePackets[
			ToList[Download[mySamples,Object]],
			templatedOptions,
			resolvedOptions,
			Cache->cacheBall,
			Simulation -> inheritedSimulation,
			Output->{Result,Tests}
		],
		True,
		{
			lyseCellsResourcePackets[
				ToList[Download[mySamples,Object]],
				templatedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation -> inheritedSimulation
			],
			{}
		}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	simulation = Which[
		!performSimulationQ,
			Null,
		MatchQ[resolvedPreparation, Robotic] && MatchQ[roboticSimulation, SimulationP],
			roboticSimulation,
		True,
			Null
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentLyseCells,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation,
			RunTime -> runTime
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourceResult,$Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
			Rest[resourceResult], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
		True,
			Module[{primitive, nonHiddenOptions},
				(* Create our primitive to feed into RoboticSamplePreparation. *)
				primitive = LyseCells @@ Join[
					{
						Sample -> Download[ToList[expandedSamplesWithNumReplicates], Object]
					},
					RemoveHiddenPrimitiveOptions[LyseCells, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentLyseCells, $ExpandedOptionsForNumReplicates];

				(* Memoize the value of ExperimentLyseCells so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentLyseCells, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentLyseCells]={};

					ExperimentLyseCells[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Result -> Rest[resourceResult],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> runTime
						}
					];

					(* Biology experiments can only run via RCP and not RSP. *)
					ExperimentRoboticCellPreparation[
						{primitive},
						Name->Lookup[safeOps,Name],
						Upload->Lookup[safeOps,Upload],
						Confirm->Lookup[safeOps,Confirm],
						CanaryBranch->Lookup[safeOps,CanaryBranch],
						ParentProtocol->Lookup[safeOps,ParentProtocol],
						Priority->Lookup[safeOps,Priority],
						StartDate->Lookup[safeOps,StartDate],
						HoldOrder->Lookup[safeOps,HoldOrder],
						QueuePosition->Lookup[safeOps,QueuePosition],
						Cache->cacheBall
					]
				]
			]
		];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentLyseCells,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> runTime
	}
];

(* ::Subsection::Closed:: *)
(* resolveLyseCellsWorkCell *)

DefineOptions[resolveLyseCellsWorkCell,
	SharedOptions:>{
		ExperimentLyseCells,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveLyseCellsWorkCell[
	myContainersAndSamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions:OptionsPattern[]
]:=Module[{cache,simulation,mySamples, myContainers, samplePackets},

	cache=Lookup[ToList[myOptions],Cache,{}];
	simulation=Lookup[ToList[myOptions],Simulation,Null];

	mySamples = Cases[myContainersAndSamples, ObjectP[Object[Sample]], Infinity];
	myContainers = Cases[myContainersAndSamples, ObjectP[Object[Container]], Infinity];
	simulation = Lookup[ToList[myOptions], Simulation, Null];

	samplePackets = Download[mySamples, Packet[CellType], Cache->cache, Simulation->simulation];

	(* NOTE: due to the mechanism by which the primitive framework resolves WorkCell, we can't just resolve it on our own and then tell *)
	(* the framework what to use. So, we resolve using the CellType option if specified, or the CellType field in the input sample(s). *)

	Which[
		(* If the user specifies the microbioSTAR for RoboticInstrument, resolve the WorkCell to match *)
		KeyExistsQ[myOptions, RoboticInstrument] && MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]],
			{microbioSTAR},
		(* If the user specifies the microbioSTAR for RoboticInstrument, resolve the WorkCell to match *)
		KeyExistsQ[myOptions, RoboticInstrument] && MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]],
			{bioSTAR},
		(* If the user specifies any microbial (Bacterial, Yeast) cell types using the CellType option, resolve to microbioSTAR *)
		KeyExistsQ[myOptions, CellType] && MemberQ[Lookup[myOptions, CellType], MicrobialCellTypeP],
			{microbioSTAR},
		(* If the user specifies only nonmicrobial (Mammalian, Insect, or Plant) cell types using the CellType option, resolve to bioSTAR *)
		KeyExistsQ[myOptions, CellType] && MatchQ[Lookup[myOptions, CellType], {NonMicrobialCellTypeP..}],
			{bioSTAR},
		(*If CellType field for any input Sample objects is microbial (Bacterial, Yeast), then the microbioSTAR is used. *)
		MemberQ[Lookup[samplePackets, CellType], MicrobialCellTypeP],
			{microbioSTAR},
		(*If CellType field for all input Sample objects is not microbial (Mammalian, Plant, or Insect), then the bioSTAR is used. *)
		MatchQ[Lookup[samplePackets, CellType], {NonMicrobialCellTypeP..}],
			{bioSTAR},
		(*Otherwise, use the microbioSTAR.*)
		True,
			{microbioSTAR}
	]
];

(* ::Subsection::Closed:: *)
(* resolveExperimentLyseCellsOptions *)

DefineOptions[
	resolveExperimentLyseCellsOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentLyseCellsOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentLyseCellsOptions]]:=Module[
	{outputSpecification, output, gatherTests, messages, cache, cacheBall, fastAssoc, listedOptions, currentSimulation,

		optionPrecisions, roundedExperimentOptions, optionPrecisionTests, invalidInputs, invalidOptions, mapThreadFriendlyOptions, mapThreadFriendlyOptionsMinusAliquotContainer,
		sampleFields, samplePacketFields, samplePackets, sampleModelFields, sampleModelPackets, sampleModelPacketFields,
		lyseCellsMethodFields, lyseCellsMethodPacketFields, lyseCellsMethodPackets, extractAndHarvestMethodFields, extractAndHarvestMethodPacketFields,
		extractAndHarvestMethodPackets, instrumentFields, instrumentPacketFields, modelInstrumentFields, modelInstrumentPacketFields, instrumentPackets, modelInstrumentPackets,

		containerModelPackets, containerModelFromObjectPackets, containerObjectFields, containerObjectPacketFields, containerModelFields, containerModelPacketFields,
		sampleContainerPackets, sampleContainerModelPackets, discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSamplePackets, deprecatedInvalidInputs, deprecatedTest,
		solidMediaInvalidInputs, solidMediaTest,

		userSpecifiedLabels, resolvedPreLysisSupernatantContainerLabels, resolvedPreLysisSupernatantLabels, preResolvedPreLysisSupernatantLabels,
		preResolvedPostClarificationPelletLabels, resolvedPostClarificationPelletLabels, resolvedPostClarificationPelletContainerLabels, preResolvedSampleOutLabels,
		resolvedSampleOutLabels,

		resolvedPostProcessingOptions, email,

		allowedWorkCells, resolvedWorkCell,
		resolvedRoboticInstrument,
		resolvedCellTypes, resolvedUnknownCellTypeQs,
		resolvedTargetCellularComponents,
		resolvedMethods,
		resolvedCultureAdhesions, resolvedUnknownCultureAdhesionQs,
		resolvedCellCountAccessibleCompositions, (* internal variable for resolving *)
		resolvedCellConcentrationAccessibleCompositions, (* internal variable for resolving *)
		resolvedCellCountAvailableQs, (* internal variable for resolving *)
		resolvedCellConcentrationAvailableQs,
		resolvedNumbersOfLysisSteps,
		resolvedNumberOfReplicates,
		resolvedAliquotBools,
		resolvedAliquotAmounts,
		resolvedDissociateBools,
		resolvedPreLysisPelletBools, pelletingRequiredToAttainTargetCellConcentrationQ,
		resolvedPreLysisPelletingCentrifuges,
		resolvedPreLysisPelletingIntensities,
		resolvedPreLysisPelletingTimes,
		resolvedPreLysisSupernatantVolumes,
		resolvedPreLysisSupernatantStorageConditions,
		resolvedPreLysisDiluteBools,
		resolvedPreLysisDiluents,
		resolvedPreLysisDilutionVolumes,
		resolvedTargetCellCounts,
		resolvedTargetCellConcentrations,
		resolvedLysisSolutions,
		resolvedLysisSolutionVolumes,
		resolvedMixTypes,
		resolvedMixRates,
		resolvedMixTimes,
		resolvedMixVolumes,
		resolvedNumbersOfMixes,
		resolvedMixTemperatures,
		resolvedLysisTemperatures,
		resolvedLysisTimes,
		resolvedMixInstruments,
		resolvedIncubationInstruments,
		resolvedSecondaryLysisSolutions,
		resolvedSecondaryLysisSolutionVolumes,
		resolvedSecondaryMixTypes,
		resolvedSecondaryMixRates,
		resolvedSecondaryMixTimes,
		resolvedSecondaryMixVolumes,
		resolvedSecondaryNumbersOfMixes,
		resolvedSecondaryMixTemperatures,
		resolvedSecondaryLysisTemperatures,
		resolvedSecondaryLysisTimes,
		resolvedSecondaryMixInstruments,
		resolvedSecondaryIncubationInstruments,
		resolvedTertiaryLysisSolutions,
		resolvedTertiaryLysisSolutionVolumes,
		resolvedTertiaryMixTypes,
		resolvedTertiaryMixRates,
		resolvedTertiaryMixTimes,
		resolvedTertiaryMixVolumes,
		resolvedTertiaryNumbersOfMixes,
		resolvedTertiaryMixTemperatures,
		resolvedTertiaryLysisTemperatures,
		resolvedTertiaryLysisTimes,
		resolvedTertiaryMixInstruments,
		resolvedTertiaryIncubationInstruments,
		resolvedMaxAliquotContainerVolumes,
		resolvedClarifyLysateBools,
		resolvedClarifyLysateCentrifuges,
		resolvedClarifyLysateIntensities,
		resolvedClarifyLysateTimes,
		resolvedClarifiedLysateVolumes,
		resolvedPostClarificationPelletStorageConditions,
		resolvedSamplesOutStorageConditions,

		numberOfReplicatesNoNull,

		aliquotContainerPlateRequiredQ,

		(*-- CONTAINER RESOLUTIONS --*)
		aliquotContainersWithWellsRemoved, wellsFromAliquotContainers, resolvedAliquotContainers, resolvedAliquotContainerWells, resolvedAliquotContainerLabels,
		preLysisSupernatantContainersWithWellsRemoved, wellsFromPreLysisSupernatantContainers, resolvedPreLysisSupernatantContainers, resolvedPreLysisSupernatantContainerWells,
		clarifiedLysateContainersWithWellsRemoved, wellsFromClarifiedLysateContainers, resolvedClarifiedLysateContainers, resolvedClarifiedLysateContainerWells,
		resolvedClarifiedLysateContainerLabels, resolvedPostClarificationPelletContainers, resolvedPostClarificationPelletContainerWells, clarifiedLysateContainerPackPlateQ,

		(*-- CONTRACTED OPTIONS FOR TESTS --*)
		contractedResolvedAliquotContainers, contractedResolvedAliquotContainerWells, contractedResolvedPostClarificationPelletContainers,
		contractedResolvedPostClarificationPelletContainerWells, contractedResolvedPreLysisSupernatantContainers, contractedResolvedPreLysisSupernatantContainerWells,
		contractedResolvedClarifiedLysateContainers, contractedResolvedClarifiedLysateContainerWells,

		resolvedOptions,

		(*-- TESTS --*)
		unsupportedCellTypeCases, unsupportedCellTypeTest,
		extraneousSecondaryLysisOptionsCases, extraneousSecondaryLysisOptionsTest, extraneousTertiaryLysisOptionsCases, extraneousTertiaryLysisOptionsTest,
		insufficientSecondaryLysisOptionsCases, insufficientSecondaryLysisOptionsTest, insufficientTertiaryLysisOptionsCases, insufficientTertiaryLysisOptionsTest,
		aliquotOptionsMismatches, aliquotOptionsMismatchesTest, mixTypeNoneMismatches, mixTypeNoneMismatchTest, secondaryMixTypeNoneMismatches, secondaryMixTypeNoneMismatchTest,
		tertiaryMixTypeNoneMismatches, tertiaryMixTypeNoneMismatchTest, mixByShakingOptionsMismatches, mixByShakingOptionsMismatchTest, secondaryMixByShakingOptionsMismatches,
		secondaryMixByShakingOptionsMismatchTest, tertiaryMixByShakingOptionsMismatches, tertiaryMixByShakingOptionsMismatchTest, mixByPipettingOptionsMismatches,
		mixByPipettingOptionsMismatchTest, secondaryMixByPipettingOptionsMismatches, secondaryMixByPipettingOptionsMismatchTest, tertiaryMixByPipettingOptionsMismatches,
		tertiaryMixByPipettingOptionsMismatchTest, preLysisPelletOptionsMismatches, preLysisPelletOptionsMismatchesTest, preLysisDiluteOptionsMismatches, preLysisDiluteOptionsMismatchesTest,
		clarifyLysateOptionsMismatches, clarifyLysateOptionsMismatchesTest, aliquotAdherentCellsCases, aliquotAdherentCellsTest,
		noCellCountOrConcentrationDataCases, noCellCountOrConcentrationDataTest, dissociateSuspendedCellsCases, dissociateSuspendedCellsTest,
		insufficientCellCountCases, insufficientCellCountTest, replicatesWithoutAliquotCases, replicatesWithoutAliquotTest,
		conflictingMixParametersInSameContainersCases, conflictingMixParametersInSameContainersTest, conflictingIncubationParametersInSameContainersCases,
		conflictingIncubationParametersInSameContainersTest, conflictingCentrifugationParametersInSameContainersCases, conflictingCentrifugationParametersInSameContainersTest,
		unresolvablePreLysisDilutionVolumeCases, unresolvablePreLysisDilutionVolumeTest, pelletingRequiredToObtainTargetCellConcentrationCases,
		unknownCultureAdhesionCases, unknownCultureAdhesionTest, unknownCellTypeCases, lowRelativeLysisSolutionVolumeCases, aliquotingRequiredForCellLysisCases,
		conflictingSamplesOutStorageConditionInSameContainerCases, conflictingSamplesOutStorageConditionInSameContainerTest,
		conflictingPreLysisSupernatantStorageConditionInSameContainerCases, conflictingPreLysisSupernatantStorageConditionInSameContainerTest,
		conflictingPostClarificationPelletStorageConditionInSameContainerCases, conflictingPostClarificationPelletStorageConditionInSameContainerTest
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages=!gatherTests;

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* ToList our options. *)
	listedOptions = ToList[myOptions];

	(* Lookup our simulation. *)
	currentSimulation = Lookup[ToList[myResolutionOptions],Simulation];

	(*-- RESOLVE PREPARATION OPTION --*)
	(* Usually, we resolve our Preparation option here, but since we can only do Preparation -> Robotic, there is no need to. *)

	(* - DOWNLOAD - *)

	(* Download fields from samples that are required.*)
	(* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
	sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Container, Position}]];
	samplePacketFields = Packet@@sampleFields;
	sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition}]];
	sampleModelPacketFields = Packet@@sampleModelFields;
	containerObjectFields = {Contents, Model, Name, MaxVolume, Type};
	containerObjectPacketFields = Packet@@containerObjectFields;
	containerModelFields = {Footprint, MaxVolume, Positions, Name, NumberOfWells};
	containerModelPacketFields = Packet@@containerModelFields;
	lyseCellsMethodFields = DeleteDuplicates[{
		CellType,
		TargetCellularComponent,
		NumberOfLysisSteps,
		PreLysisPellet,
		PreLysisPelletingIntensity,
		PreLysisPelletingTime,
		LysisSolution,
		MixType,
		MixRate,
		MixTime,
		NumberOfMixes,
		MixTemperature,
		LysisTime,
		LysisTemperature,
		SecondaryLysisSolution,
		SecondaryMixType,
		SecondaryMixRate,
		SecondaryMixTime,
		SecondaryNumberOfMixes,
		SecondaryMixTemperature,
		SecondaryLysisTime,
		SecondaryLysisTemperature,
		TertiaryLysisSolution,
		TertiaryMixType,
		TertiaryMixRate,
		TertiaryMixTime,
		TertiaryNumberOfMixes,
		TertiaryMixTemperature,
		TertiaryLysisTime,
		TertiaryLysisTemperature,
		ClarifyLysate,
		ClarifyLysateIntensity,
		ClarifyLysateTime
	}];
	lyseCellsMethodPacketFields = Packet@@lyseCellsMethodFields;
	extractAndHarvestMethodFields = DeleteDuplicates[{
		CellType,
		TargetCellularComponent,
		NumberOfLysisSteps,
		PreLysisPellet,
		PreLysisPelletingIntensity,
		PreLysisPelletingTime,
		LysisSolution,
		LysisMixType,
		LysisMixRate,
		LysisMixTime,
		NumberOfLysisMixes,
		LysisMixTemperature,
		LysisTime,
		LysisTemperature,
		SecondaryLysisSolution,
		SecondaryLysisMixType,
		SecondaryLysisMixRate,
		SecondaryLysisMixTime,
		SecondaryNumberOfLysisMixes,
		SecondaryLysisMixTemperature,
		SecondaryLysisTime,
		SecondaryLysisTemperature,
		TertiaryLysisSolution,
		TertiaryLysisMixType,
		TertiaryLysisMixRate,
		TertiaryLysisMixTime,
		TertiaryNumberOfLysisMixes,
		TertiaryLysisMixTemperature,
		TertiaryLysisTime,
		TertiaryLysisTemperature,
		ClarifyLysate,
		ClarifyLysateIntensity,
		ClarifyLysateTime
	}];
	extractAndHarvestMethodPacketFields = Packet@@extractAndHarvestMethodFields;
	instrumentFields = DeleteDuplicates[{Model, Status, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature}];
	instrumentPacketFields = Packet@@instrumentFields;
	modelInstrumentFields = DeleteDuplicates[{Name, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature, Positions}];
	modelInstrumentPacketFields = Packet@@modelInstrumentFields;

	{
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		containerModelPackets,
		containerModelFromObjectPackets,
		lyseCellsMethodPackets,
		extractAndHarvestMethodPackets,
		instrumentPackets,
		modelInstrumentPackets
	} = Quiet[
		Download[
			{
				mySamples,
				mySamples,
				mySamples,
				mySamples,
				DeleteDuplicates@Flatten[{
					Cases[
						Flatten[Lookup[myOptions, {AliquotContainer, PreLysisSupernatantContainer, ClarifiedLysateContainer}]],
						ObjectP[Model[Container]]
					],
					PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All]
				}],
				DeleteDuplicates@Cases[
					Flatten[Lookup[myOptions, {AliquotContainer, PreLysisSupernatantContainer, ClarifiedLysateContainer}]],
					ObjectP[Object[Container]]
				],
				DeleteDuplicates@Flatten[{
					Cases[
						Flatten[Lookup[myOptions, Method]], ObjectP[Object[Method, LyseCells]]]}
				],
				DeleteDuplicates@Flatten[{
					Cases[
						Flatten[Lookup[myOptions, Method]], ObjectP[Object[Method]]]}
				],
				DeleteDuplicates@Flatten[{
					Cases[
						Flatten[Lookup[myOptions, $InstrumentOptions]], ObjectP[Object[Instrument]]]}
				],
				DeleteDuplicates@Flatten[{
					Cases[{
						Flatten[Lookup[myOptions, $InstrumentOptions]],
						Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],
						Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"],
						Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"],
						Model[Instrument, Shaker, "id:eGakldJkWVnz"],
						Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"]}, ObjectP[Model[Instrument]]]}
				]
			},
			{
				{samplePacketFields},
				{Packet[Model[sampleModelFields]]},
				{Packet[Container[containerObjectFields]]},
				{Packet[Container[Model][containerModelFields]]},
				{containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction}]]},
				{containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction}]]},
				{lyseCellsMethodPacketFields},
				{extractAndHarvestMethodPacketFields},
				{instrumentPacketFields},
				{modelInstrumentPacketFields}
			},
			Cache -> cache,
			Simulation -> currentSimulation
		],
		{Download::ObjectDoesNotExist, Download::FieldDoesntExist,Download::NotLinkField}
	];

	{
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		containerModelPackets,
		containerModelFromObjectPackets,
		lyseCellsMethodPackets,
		extractAndHarvestMethodPackets,
		instrumentPackets,
		modelInstrumentPackets
	}=Flatten/@{
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		containerModelPackets,
		containerModelFromObjectPackets,
		lyseCellsMethodPackets,
		extractAndHarvestMethodPackets,
		instrumentPackets,
		modelInstrumentPackets
	};

	(* make a new cache with what we just Downloaded *)
	cacheBall = FlattenCachePackets[{
		cache,
		samplePackets,
		sampleModelPackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		containerModelPackets,
		containerModelFromObjectPackets,
		lyseCellsMethodPackets,
		extractAndHarvestMethodPackets,
		instrumentPackets,
		modelInstrumentPackets
	}];

	(* Make fast association to look up things from cache quickly.*)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(*-- INPUT VALIDATION CHECKS --*)

	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["The input samples "<>ObjectToString[discardedInvalidInputs,Cache->cache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->cacheBall]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- DEPRECATED MODEL CHECK -- *)

	(* Get the samples from samplePackets that are deprecated. *)
	deprecatedSamplePackets = Select[Flatten[sampleModelPackets], If[MatchQ[#,Except[Null]],MatchQ[Lookup[#, Deprecated], True]]&];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	deprecatedInvalidInputs = Lookup[deprecatedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedInvalidInputs] > 0 && messages,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cache]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[deprecatedInvalidInputs, Cache -> cache] <> " do not have deprecated models:", True, False]
			];
			passingTest = If[Length[deprecatedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, deprecatedInvalidInputs], Cache -> cache] <> " do not have deprecated models:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* -- SOLID MEDIA CHECK -- *)

	{solidMediaInvalidInputs,solidMediaTest} = checkSolidMedia[samplePackets,messages,Cache -> cache];

	(* -- INVALID INPUT CHECK -- *)

	(*Gather a list of all invalid inputs from all invalid input tests.*)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs,deprecatedInvalidInputs,solidMediaInvalidInputs}]];

	(*Throw Error::InvalidInput if there are any invalid inputs.*)
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cache]]
	];

	(*-- OPTION PRECISION CHECKS --*)

	(* Define the option precisions that need to be checked. *)
	optionPrecisions = {
		{AliquotAmount, 10^(-1) Microliter},
		{PreLysisPelletingTime, 1 Second},
		{PreLysisPelletingIntensity, 1 GravitationalAcceleration},
		{PreLysisSupernatantVolume, 10^(-1) Microliter},
		{PreLysisDilutionVolume, 10^(-1) Microliter},
		{TargetCellCount, 1 EmeraldCell},
		{TargetCellConcentration, 1 (EmeraldCell/Milliliter)},

		{LysisSolutionVolume, 10^(-1) Microliter},
		{MixRate, 1 RPM},
		{MixTime, 1 Second},
		{MixVolume, 10^(-1) Microliter},
		{MixTemperature, 10^(-1) Celsius},
		{LysisTemperature, 10^(-1) Celsius},
		{LysisTime, 1 Second},

		{SecondaryLysisSolutionVolume, 10^(-1) Microliter},
		{SecondaryMixRate, 1 RPM},
		{SecondaryMixTime, 1 Second},
		{SecondaryMixVolume, 10^(-1) Microliter},
		{SecondaryMixTemperature, 10^(-1) Celsius},
		{SecondaryLysisTemperature, 10^(-1) Celsius},
		{SecondaryLysisTime, 1 Second},

		{TertiaryLysisSolutionVolume, 10^(-1) Microliter},
		{TertiaryMixRate, 1 RPM},
		{TertiaryMixTime, 1 Second},
		{TertiaryMixVolume, 10^(-1) Microliter},
		{TertiaryMixTemperature, 10^(-1) Celsius},
		{TertiaryLysisTemperature, 10^(-1) Celsius},
		{TertiaryLysisTime, 1 Second},

		{ClarifyLysateTime, 1 Second},
		{ClarifyLysateIntensity, 1 GravitationalAcceleration},
		{ClarifiedLysateVolume, 10^(-1) Microliter}
	};

	(* There are still a few options that we need to check the precisions of though. *)
	{roundedExperimentOptions,optionPrecisionTests} = If[gatherTests,
		(*If we are gathering tests *)
		RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],
		(* Otherwise *)
		{RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
	];

	(* Convert our options into a MapThread friendly version. *)
	(* AliquotContainer is also a shared option for many experiments and is handled by mapThreadOptions in a manner that conflicts with the usage of *)
	(* the AliquotContainer used in ExperimentLyseCells. Thus we add the AliquotContainer option manually in the next few lines to prevent mapThreadOptions errors. *)
	mapThreadFriendlyOptionsMinusAliquotContainer = OptionsHandling`Private`mapThreadOptions[ExperimentLyseCells,KeyDrop[roundedExperimentOptions, AliquotContainer]];
	mapThreadFriendlyOptions = MapThread[
		Append[#1, AliquotContainer -> #2]&,
		{mapThreadFriendlyOptionsMinusAliquotContainer, Lookup[roundedExperimentOptions, AliquotContainer]}
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Resolve WorkCell. *)
	allowedWorkCells = resolveLyseCellsWorkCell[mySamples, listedOptions];

	resolvedWorkCell = Which[
		MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]],
			Lookup[myOptions, WorkCell],
		Length[allowedWorkCells] > 0,
			First[allowedWorkCells],
		True,
			microbioSTAR
	];

	resolvedRoboticInstrument = Which[
		(* If user-set, then use set value. *)
		MatchQ[Lookup[myOptions,RoboticInstrument], Except[Automatic]],
			Lookup[myOptions, RoboticInstrument],
		(* If there is no user-set value, resolve to match the resolved WorkCell - see directly above *)
		MatchQ[resolvedWorkCell, bioSTAR],
			Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
		True,
			Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"] (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
	];

	(* Resolve NumberOfReplicates *)
	resolvedNumberOfReplicates = Which[
		(* Use the user-specified values, if any *)
		MatchQ[Lookup[myOptions, NumberOfReplicates], Except[Automatic]],
			Lookup[myOptions, NumberOfReplicates],
		(* Replicates are set to Null if unspecified *)
		True,
			Null
	];

	(* Get all of the user specified labels. *)
	userSpecifiedLabels = DeleteDuplicates@Cases[
		Flatten@Lookup[
			listedOptions,
			{PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel, PostClarificationPelletLabel, PostClarificationPelletContainerLabel, ClarifiedLysateContainerLabel, SampleOutLabel}
		],
		_String
	];

	{
		resolvedMethods,
		resolvedCellCountAccessibleCompositions, (* internal variable for resolving *)
		resolvedCellConcentrationAccessibleCompositions, (* internal variable for resolving *)
		resolvedCellCountAvailableQs, (* internal variable for resolving *)
		resolvedCellConcentrationAvailableQs, (* internal variable for resolving *)
		resolvedCellTypes, resolvedUnknownCellTypeQs,
		resolvedTargetCellularComponents,
		resolvedCultureAdhesions, resolvedUnknownCultureAdhesionQs,
		resolvedNumbersOfLysisSteps,
		resolvedAliquotBools,
		resolvedAliquotAmounts,
		resolvedDissociateBools,
		resolvedPreLysisPelletBools, pelletingRequiredToAttainTargetCellConcentrationQ,
		resolvedPreLysisPelletingCentrifuges,
		resolvedPreLysisPelletingIntensities,
		resolvedPreLysisPelletingTimes,
		resolvedPreLysisSupernatantVolumes,
		resolvedPreLysisSupernatantStorageConditions,
		resolvedPreLysisDiluteBools,
		resolvedPreLysisDiluents,
		resolvedPreLysisDilutionVolumes,
		resolvedTargetCellCounts,
		resolvedTargetCellConcentrations,
		resolvedLysisSolutions,
		resolvedLysisSolutionVolumes,
		resolvedMixTypes,
		resolvedMixRates,
		resolvedMixTimes,
		resolvedMixVolumes,
		resolvedNumbersOfMixes,
		resolvedMixTemperatures,
		resolvedMixInstruments,
		resolvedLysisTemperatures,
		resolvedLysisTimes,
		resolvedIncubationInstruments,
		resolvedSecondaryLysisSolutions,
		resolvedSecondaryLysisSolutionVolumes,
		resolvedSecondaryMixTypes,
		resolvedSecondaryMixRates,
		resolvedSecondaryMixTimes,
		resolvedSecondaryMixVolumes,
		resolvedSecondaryNumbersOfMixes,
		resolvedSecondaryMixTemperatures,
		resolvedSecondaryMixInstruments,
		resolvedSecondaryLysisTemperatures,
		resolvedSecondaryLysisTimes,
		resolvedSecondaryIncubationInstruments,
		resolvedTertiaryLysisSolutions,
		resolvedTertiaryLysisSolutionVolumes,
		resolvedTertiaryMixTypes,
		resolvedTertiaryMixRates,
		resolvedTertiaryMixTimes,
		resolvedTertiaryMixVolumes,
		resolvedTertiaryNumbersOfMixes,
		resolvedTertiaryMixTemperatures,
		resolvedTertiaryMixInstruments,
		resolvedTertiaryLysisTemperatures,
		resolvedTertiaryLysisTimes,
		resolvedTertiaryIncubationInstruments,
		resolvedMaxAliquotContainerVolumes,
		resolvedClarifyLysateBools,
		resolvedClarifyLysateCentrifuges,
		resolvedClarifyLysateIntensities,
		resolvedClarifyLysateTimes,
		resolvedClarifiedLysateVolumes,
		resolvedPostClarificationPelletStorageConditions,
		resolvedSamplesOutStorageConditions,
		preResolvedSampleOutLabels,
		preResolvedPreLysisSupernatantLabels,
		preResolvedPostClarificationPelletLabels

	}=Transpose@MapThread[
		Function[{samplePacket, sampleContainerModelPacket, options},
			Module[{
				method,
				methodSpecifiedQ, (* internal variable for resolving *)
				methodPacket,
				cellCountAccessibleComposition, (* internal variable for resolving *)
				cellConcentrationAccessibleComposition, (* internal variable for resolving *)
				cellCountAvailableQ, (* internal variable for resolving *)
				cellConcentrationAvailableQ, (* internal variable for resolving *)
				cellType, unknownCellTypeQ,
				targetCellularComponent, unknownCultureAdhesionQ,
				cultureAdhesion,
				numberOfLysisSteps,
				aliquotBool,
				aliquotAmount,
				dissociateBool,
				volumeFromDissociateCells, (* placeholder before DissociateCells is ready *)
				preLysisPelletBool, pelletingForcedQ,
				preLysisPelletingCentrifuge,
				preLysisPelletingIntensity,
				preLysisPelletingTime,
				preLysisSupernatantVolume,
				preLysisSupernatantStorageCondition,
				preLysisDiluteBool,
				preLysisDiluent,
				preLysisDilutionVolume,
				targetCellCount,
				targetCellConcentration,
				lysisSolution,
				lysisSolutionVolume,
				mixType,
				mixRate,
				mixTime,
				mixVolume,
				numberOfMixes,
				mixTemperature,
				mixInstrument,
				lysisTemperature,
				lysisTime,
				incubationInstrument,
				secondaryLysisSolution,
				secondaryLysisSolutionVolume,
				secondaryMixType,
				secondaryMixRate,
				secondaryMixTime,
				secondaryMixVolume,
				secondaryNumberOfMixes,
				secondaryMixTemperature,
				secondaryMixInstrument,
				secondaryLysisTemperature,
				secondaryLysisTime,
				secondaryIncubationInstrument,
				tertiaryLysisSolution,
				tertiaryLysisSolutionVolume,
				tertiaryMixType,
				tertiaryMixRate,
				tertiaryMixTime,
				tertiaryMixVolume,
				tertiaryNumberOfMixes,
				tertiaryMixTemperature,
				tertiaryMixInstrument,
				tertiaryLysisTemperature,
				tertiaryLysisTime,
				tertiaryIncubationInstrument,
				maxAliquotContainerVolume, (* internal variable for resolving *)
				clarifyLysateBool,
				clarifyLysateCentrifuge,
				clarifyLysateIntensity,
				clarifyLysateTime,
				clarifiedLysateVolume,
				postClarificationPelletStorageCondition,
				samplesOutStorageCondition,
				sampleOutLabel,
				preLysisSupernatantLabel,
				postClarificationPelletLabel
			},

				(* --- GENERAL --- *)

				(* Resolve Method *)
				method = If[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,Method], ObjectP[Object[Method]]],
					Lookup[options,Method],
					(* Otherwise, default to Custom *)
					Custom
				];

				(* Write a method Boolean internal variable to switch on/off Method-specified options *)
				methodSpecifiedQ = MatchQ[method,Except[Custom]];

				(* Get the method packet that will be used for this sample if there is one. *)
				methodPacket = If[
					MatchQ[method,Except[Custom]],
					fetchPacketFromFastAssoc[method,fastAssoc],
					<||>
				];

				(* resolve an internal variable which returns the items in the sample's Composition fields for which TargetCellCount can be calculated *)
				cellCountAccessibleComposition = Cases[Lookup[samplePacket,Composition],{GreaterEqualP[0 EmeraldCell],ObjectP[Model[Cell]]}|{GreaterEqualP[0 EmeraldCell],ObjectP[Model[Cell]],_}];

				(* resolve an internal variable which returns the items in the sample's Composition fields for which TargetCellCount can be calculated *)
				cellConcentrationAccessibleComposition = Cases[Lookup[samplePacket,Composition],{GreaterEqualP[(0 EmeraldCell/Milliliter)],ObjectP[Model[Cell]]}|{GreaterEqualP[(0 EmeraldCell/Milliliter)],ObjectP[Model[Cell]],_}];

				(* resolve an internal boolean which tells us whether there is sufficient information to do any Cell Count calculations *)
				cellCountAvailableQ = MatchQ[Length[cellCountAccessibleComposition], GreaterP[0]];

				(* resolve an internal boolean which tells us whether there is sufficient information to do any Cell concentration calculations *)
				cellConcentrationAvailableQ = MatchQ[Length[cellConcentrationAccessibleComposition], GreaterP[0]];

				(* Resolve CellType *)
				{cellType, unknownCellTypeQ} = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options, CellType], Except[Automatic]],
						{Lookup[options, CellType], False},
					(* Use the Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, CellType],
						MatchQ[Lookup[methodPacket, CellType], Except[Null]]
					],
						{Lookup[methodPacket, CellType], False},
					(* Use the value of the CellType field in Object[Sample], if any *)
					MatchQ[Lookup[samplePacket, CellType], CellTypeP],
						{Lookup[samplePacket, CellType], False},
					(* If neither of the above apply, default to Bacterial and throw a warning *)
					True,
						{Bacterial, True}
				];

				(* Resolve TargetCellularComponent *)
				targetCellularComponent = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TargetCellularComponent], Except[Automatic]],
						Lookup[options,TargetCellularComponent],
					(* Use the Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, TargetCellularComponent],
						MatchQ[Lookup[methodPacket, TargetCellularComponent], Except[Null]]
					],
						Lookup[methodPacket, TargetCellularComponent],
					(* Otherwise, default to Unspecified *)
					True,
						Unspecified
				];

				(* Resolve CultureAdhesion. Assume that a sample without the Living field informed is not Living. *)
				{cultureAdhesion, unknownCultureAdhesionQ} = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,CultureAdhesion], Except[Automatic]],
						{Lookup[options, CultureAdhesion], False},
					(* Use the value of the CultureAdhesion field in Object[Sample], if any *)
					MatchQ[Lookup[samplePacket,CultureAdhesion], Except[Null]],
						{Lookup[samplePacket, CultureAdhesion], False},
					(* If there's no CultureAdhesion info but the Sample is not Living, set this to suspension. *)
					MatchQ[Lookup[samplePacket, CultureAdhesion], Except[CultureAdhesionP]] && MatchQ[Lookup[samplePacket, Living], Except[True]],
						{Suspension, False},
					(* If none of the above apply, default to Adherent and throw an error *)
					True,
						{Adherent, True}
				];

				(* --- NUMBERS OF LYSIS STEPS --- *)

				(* Resolve NumberOfLysisSteps *)
				numberOfLysisSteps = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,NumberOfLysisSteps], Except[Automatic]],
						Lookup[options,NumberOfLysisSteps],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, NumberOfLysisSteps] && MatchQ[Lookup[methodPacket, NumberOfLysisSteps], Except[Null]],
						Lookup[methodPacket,NumberOfLysisSteps],
					(* If any Tertiary lysis conditions are specified by the user, NumberOfLysisSteps resolves to 3 *)
					MemberQ[Lookup[options, $TertiaryLysisOptions], Except[Null|Automatic]],
						3,
					(* If any Tertiary lysis conditions are specified by a LyseCells method, NumberOfLysisSteps resolves to 3 *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $TertiaryLysisOptions, True],
						MemberQ[Cases[Lookup[methodPacket, $TertiaryLysisOptions], Except[Missing[_,_]]], Except[Null]]
					],
						3,
					(* If any Tertiary lysis conditions are specified by an Extraction method, NumberOfLysisSteps resolves to 3 *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $TertiaryLysisOptionsWithLysisPrefix, True],
						MemberQ[Cases[Lookup[methodPacket, $TertiaryLysisOptionsWithLysisPrefix], Except[Missing[_,_]]], Except[Null]]
					],
						3,
					(* If any Secondary lysis conditions are specified by the user, NumberOfLysisSteps resolves to 2 *)
					MemberQ[Lookup[options, $SecondaryLysisOptions], Except[Null|Automatic]],
						2,
					(* If any Secondary lysis conditions are specified by a LyseCells method, NumberOfLysisSteps resolves to 2 *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $SecondaryLysisOptions, True],
						MemberQ[Cases[Lookup[methodPacket, $SecondaryLysisOptions], Except[Missing[_,_]]], Except[Null]]
					],
						3,
					(* If any Secondary lysis conditions are specified by an Extraction method, NumberOfLysisSteps resolves to 2 *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $SecondaryLysisOptionsWithLysisPrefix, True],
						MemberQ[Cases[Lookup[methodPacket, $SecondaryLysisOptionsWithLysisPrefix], Except[Missing[_,_]]], Except[Null]]
					],
						3,
					(* Otherwise, NumberOfLysisSteps resolves to 1 *)
					True,
						1
				];

				(* --- ALIQUOT MASTER SWITCH --- *)

				(* Resolve Aliquot switch *)
				aliquotBool = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,Aliquot], BooleanP],
						Lookup[options,Aliquot],
					(* Set Aliquot to True if any of AliquotAmount, AliquotContainer, NumberOfReplicates, TargetCellCount or TargetCellConcentration are specified *)
					MemberQ[Lookup[options,{AliquotAmount, AliquotContainer, NumberOfReplicates, TargetCellCount, TargetCellConcentration}], Except[Null|Automatic]],
						True,
					(* Set Aliquot to True if the sample isn't in a plate but the user sets either of PreLysisPellet and ClarifyLysate to True *)
					And[
						MatchQ[Lookup[sampleContainerModelPacket, Footprint], Except[Plate]],
						MemberQ[Lookup[options, {PreLysisPellet, ClarifyLysate}], True]
					],
						True,
					(* Set Aliquot to True if sample isn't in a plate but the Method sets either of PreLysisPellet and ClarifyLysate to True *)
					And[
						MatchQ[Lookup[sampleContainerModelPacket, Footprint], Except[Plate]],
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {PreLysisPellet, ClarifyLysate}, True],
						MemberQ[Cases[Lookup[methodPacket, {PreLysisPellet, ClarifyLysate}], Except[Missing[_,_]]], True]
					],
						True,
					(* Set Aliquot to True if sample isn't in a plate but the User specifies any centrifugation-related options *)
					And[
						MatchQ[Lookup[sampleContainerModelPacket, Footprint], Except[Plate]],
						MemberQ[Lookup[options, Join[$PreLysisPelletingOptions, $LysateClarificationOptions]], Except[Null|Automatic]]
					],
						True,
					(* Set Aliquot to True if sample isn't in a plate but the Method sets any centrifugation-related options to True *)
					And[
						MatchQ[Lookup[sampleContainerModelPacket, Footprint], Except[Plate]],
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ Join[$PreLysisPelletingOptions, $LysateClarificationOptions], True],
						MemberQ[Cases[Lookup[methodPacket, Join[$PreLysisPelletingOptions, $LysateClarificationOptions]], Except[Missing[_,_]]], Except[Null]]
					],
						True,
					(* Set Aliquot to True if the container is at least 75% full by volume and PreLysisPellet is NOT set to True by the user, because we still need to add lysis solutions *)
					And[
						MatchQ[Lookup[samplePacket, Volume], GreaterEqualP[0.75 * Lookup[sampleContainerModelPacket, MaxVolume]]],
						MatchQ[Lookup[options, PreLysisPellet], Except[True]] (* if True, volume will be reduced before adding lysis solutions *)
					],
						True,
					(* Set Aliquot to True if the container is at least 75% full by volume and PreLysisPellet is NOT set to True by the Method, because we still need to add lysis solutions *)
					And[
						MatchQ[Lookup[samplePacket, Volume], GreaterEqualP[0.75 * Lookup[sampleContainerModelPacket, MaxVolume]]],
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, PreLysisPellet],
						MatchQ[Lookup[methodPacket, PreLysisPellet], (False|Null)] (* if True, volume will be reduced before adding lysis solutions *)
					],
						True,
					(* Set Aliquot to False if the sample is in some kind of plate, since all of the below conditions don't require aliquoting if we're in a plate. *)
					MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate],
						False,
					(* Set Aliquot to True if any of the MixType options are set to Shake by the user *)
					MemberQ[Lookup[options, {MixType, SecondaryMixType, TertiaryMixType}], Shake],
						True,
					(* Set Aliquot to True if any of the MixType options are set to Shake by a LyseCells Method *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {MixType, SecondaryMixType, TertiaryMixType}, True],
						MemberQ[Cases[Lookup[methodPacket, {MixType, SecondaryMixType, TertiaryMixType}], Except[Missing[_,_]]], Shake]
					],
						True,
					(* Set Aliquot to True if any of the MixType options are set to Shake by an Extraction Method *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {LysisMixType, SecondaryLysisMixType, TertiaryLysisMixType}, True],
						MemberQ[Cases[Lookup[methodPacket, {LysisMixType, SecondaryLysisMixType, TertiaryLysisMixType}], Except[Missing[_,_]]], Shake]
					],
						True,
					(* Set Aliquot to True if any of the Temperature options are set to something other than Ambient by the user *)
					MemberQ[Lookup[options, $TemperatureControlOptions], Except[Automatic|Null|AmbientTemperatureP]],
						True,
					(* Set Aliquot to True if any of the Temperature options are set to something other than Ambient by a LyseCells Method *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $TemperatureControlOptions, True],
						MemberQ[Cases[Lookup[methodPacket, $TemperatureControlOptions], Except[Missing[_,_]]], Except[Automatic|Null|AmbientTemperatureP]]
					],
						True,
					(* Set Aliquot to True if any of the Temperature options are set to something other than Ambient by an Extraction Method *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $TemperatureControlOptionsWithLysisPrefix, True],
						MemberQ[Cases[Lookup[methodPacket, $TemperatureControlOptionsWithLysisPrefix], Except[Missing[_,_]]], Except[Automatic|Null|AmbientTemperatureP]]
					],
						True,
					(* Otherwise, set to False *)
					True,
						False
				];

				(* --- DISSOCIATE CELLS --- *)

				(* Resolve Dissociate switch *)
				dissociateBool = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,Dissociate], BooleanP],
						Lookup[options,Dissociate],
					(* Dissociate is set to False if CultureAdhesion is Suspension *)
					MatchQ[cultureAdhesion, Suspension],
						False,
					(* Dissociate is set to True if CultureAdhesion is not Suspension and Aliquot is True *)
					MatchQ[cultureAdhesion, Except[Suspension]] && aliquotBool,
						True,
					(* Else, Dissociate is False *)
					True,
						False
				];

				(* TODO placeholder variable for volumes left over from DissociateCells, if it was called *)
				volumeFromDissociateCells = If[
					dissociateBool,
					5 Microliter,
					Null
				];

				(* --- ALIQUOT AMOUNT --- *)

				(* Resolve AliquotAmount *)
				aliquotAmount = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,AliquotAmount], Except[Automatic]],
						Lookup[options,AliquotAmount],
					(* If Aliquot is False, AliquotAmount is Null *)
					MatchQ[aliquotBool, False],
						Null,
					(* If TargetCellCount is specified by the user, resolve to the amount needed to obtain the TargetCellCount based on sample composition *)
					MatchQ[Lookup[options,TargetCellCount], Except[Null|Automatic]] && MemberQ[{cellCountAvailableQ,cellConcentrationAvailableQ}, True],
						Which[
							cellCountAvailableQ,
								(* TargetCellCount divided by number of cells in the sample, times the sample volume *)
								N @ Lookup[options,TargetCellCount] / (Total[cellCountAccessibleComposition[[All,1]]]) * Lookup[samplePacket, Volume],
							cellConcentrationAvailableQ,
								(* TargetCellCount divided by the sample's cell concentration in cells per mL *)
								N @ Lookup[options,TargetCellCount] / (Total[cellConcentrationAccessibleComposition[[All,1]]])
						],
					(* If TargetCellConcentration and AliquotContainer are both specified by the user, resolve to the amount needed to obtain TargetCellConcentration once *)
					(* diluted to fill 50% of the capacity of the container - as long as we have sufficient composition info *)
					And[
						MatchQ[Lookup[options,TargetCellConcentration], Except[Null|Automatic]],
						MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						MemberQ[{cellCountAvailableQ,cellConcentrationAvailableQ}, True]
					],
						Which[
							cellCountAvailableQ,
								Module[{halfAliquotContainerMaxVolume, sampleVolumePerCell},
									(* Get half the capacity of the aliquotContainer *)
									halfAliquotContainerMaxVolume = 0.50 * Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], MaxVolume];
									(* Get the volume per number of cells of all cell models present in the sample *)
									sampleVolumePerCell = Lookup[samplePacket, Volume] / Total[cellCountAccessibleComposition[[All,1]]];
									(* Multiply the specified TargetCellConcentration by halfAliquotContainerMaxVolume times sampleVolumePerCell *)
									Lookup[options, TargetCellConcentration] * halfAliquotContainerMaxVolume * sampleVolumePerCell
								],
							cellConcentrationAvailableQ,
								Module[{halfAliquotContainerMaxVolume, totalCellConcentration},
									(* Get half the capacity of the aliquotContainer *)
									halfAliquotContainerMaxVolume = 0.50 * Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], MaxVolume];
									(* Get the total cell concentration from the sample, regardless of the cell models *)
									totalCellConcentration = Total[cellConcentrationAccessibleComposition[[All,1]]];
									(* Multiply the specified TargetCellConcentration by halfAliquotContainerMaxVolume over the totalCellConcentration *)
									Lookup[options, TargetCellConcentration] * halfAliquotContainerMaxVolume / totalCellConcentration
								]
						],
					(* If the user specifies AliquotContainer and the volume of the input cell sample is less than 50% of the capacity of this container, resolves to All of the input sample *)
					And[
						MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						MatchQ[Lookup[samplePacket, Volume], LessP[0.50 * Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], MaxVolume]]]
					],
						Lookup[samplePacket, Volume],
					(* Else, default to 50% of the capacity of AliquotContainer if it is user-specified *)
					MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						0.50 * Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], MaxVolume],
					(* Otherwise, AliquotContainer is not specified. Resolve to 25% of the volume of the input sample *)
					True,
						0.25 * Lookup[samplePacket, Volume]
				];

				(* --- CENTRIFUGATION SWITCHES --- *)

				(* Resolve PreLysisPellet switch and PelletingForcedQ; we need the latter to warn the user that their sample is going to be *)
				(* Pelleted in order to obtain the specified TargetCellConcentration *)
				{preLysisPelletBool, pelletingForcedQ} = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisPellet], BooleanP],
						{Lookup[options, PreLysisPellet], False},
					(* If any of the conditions for PreLysisPellet are specified by the user, PreLysisPellet resolves to True *)
					MemberQ[Lookup[options, $PreLysisPelletingOptions], Except[Null|Automatic]],
						{True, False},
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, PreLysisPellet] && MatchQ[Lookup[methodPacket, PreLysisPellet], Except[Null]],
						{Lookup[methodPacket, PreLysisPellet], False},
					(* If any of the conditions for PreLysisPellet are specified by the Method, PreLysisPellet resolves to True *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $PreLysisPelletingOptions, True],
						MemberQ[Cases[Lookup[methodPacket, $PreLysisPelletingOptions], Except[Missing[_,_]]], Except[Automatic|Null]]
					],
						{True, False},
					(* If no TargetCellConcentration is specified, PreLysisPellet resolves to False since everything below handles the case where we *)
					(* need to pellet to obtain to the target concentration *)
					MatchQ[Lookup[options,TargetCellConcentration], Alternatives[Automatic,Null]],
						{False, False},
					(* Resolve to False if there is not sufficient Composition info in Object[Sample] to calculate TargetCellConcentration; see previous comment *)
					MatchQ[{cellCountAvailableQ,cellConcentrationAvailableQ}, {False,False}],
						{False, False},
					(* If the user-specified TargetCellConcentration is greater than the current cell concentration within the container, preLysisPellet is True *)
					MatchQ[Lookup[options, TargetCellConcentration],
						GreaterP[
							Which[
								cellCountAvailableQ,
									Module[{aliquotRatio, totalCellCount, currentVolume},
										(* Get the ratio of the aliquotAmount to the total amount of input sample *)
										aliquotRatio = aliquotAmount / Lookup[samplePacket,Volume];
										(* Get the total cell count from the sample, regardless of the cell models *)
										totalCellCount = Total[cellCountAccessibleComposition[[All,1]]];
										(* Get the total solution volume at this point *)
										currentVolume = Total@Cases[{volumeFromDissociateCells,aliquotAmount}, VolumeP];
										(* Multiply the aliquotRatio by the totalCellCount and divide by the currentVolume *)
										aliquotRatio * totalCellCount / currentVolume
									],
								cellConcentrationAvailableQ,
									Module[{totalCellConcentration, currentVolume},
										(* Get the total cell concentration from the sample, regardless of the cell models *)
										totalCellConcentration = Total[cellConcentrationAccessibleComposition[[All,1]]];
										(* Get the total solution volume at this point *)
										currentVolume = Total@Cases[{volumeFromDissociateCells,aliquotAmount}, VolumeP];
										(* Multiply the sample's cell concentration by the aliquotAmount and divide by the total volume *)
										totalCellConcentration * aliquotAmount / currentVolume
									]
							]
						]
					],
						{True, True},
					(* Otherwise, PreLysisPellet resolves to False *)
					True,
						{False, False}
				];

				(* Resolve ClarifyLysate switch *)
				clarifyLysateBool = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,ClarifyLysate], BooleanP],
						Lookup[options,ClarifyLysate],
					(* Set to True if any of the dependent options are set *)
					MemberQ[Lookup[options, $LysateClarificationOptions], Except[Null|Automatic]],
						True,
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, ClarifyLysate] && MatchQ[Lookup[methodPacket, ClarifyLysate], Except[Null]],
						Lookup[methodPacket,ClarifyLysate],
					(* If any of the conditions for ClarifyLysate are specified by the Method, ClarifyLysate resolves to True *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ $LysateClarificationOptions, True],
						MemberQ[Cases[Lookup[methodPacket, $LysateClarificationOptions], Except[Missing[_,_]]], Except[Automatic|Null]]
					],
						True,
					(* Otherwise, this is False *)
					True,
						False
				];

				(* --- PRE LYSIS PELLETING OPTIONS, except for the boolean switch --- *)

				(* Resolve PreLysisPelletingCentrifuge *)
				preLysisPelletingCentrifuge = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisPelletingCentrifuge], Except[Automatic]],
						Lookup[options,PreLysisPelletingCentrifuge],
					(* The integrated HiG4 centrifuge is selected if PreLysisPellet is True *)
					MatchQ[preLysisPelletBool,True],
						Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
					(* Otherwise, there is no PreLysisPelleting and we don't need a centrifuge for it *)
					True,
						Null
				];

				(* Resolve PreLysisPelletingIntensity *)
				preLysisPelletingIntensity = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisPelletingIntensity], Except[Automatic]],
						Lookup[options,PreLysisPelletingIntensity],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, PreLysisPelletingIntensity] && MatchQ[Lookup[methodPacket, PreLysisPelletingIntensity], Except[Null]],
						Lookup[methodPacket,PreLysisPelletingIntensity],
					(* If the PreLysisPellet boolean is switched off, resolve to Null *)
					MatchQ[preLysisPelletBool,False],
						Null,
					(* Otherwise, resolve to match the default $Constant for the resolved cellType *)
					MatchQ[cellType, Yeast],
						2850 RPM, (* $LivingYeastCentrifugeIntensity *)
					MatchQ[cellType, Bacterial],
						4030 RPM, (* $LivingBacterialCentrifugeIntensity *)
					True,
						1560 RPM (* $LivingMammalianCentrifugeIntensity *)
				];

				(* Resolve PreLysisPelletingTime *)
				preLysisPelletingTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisPelletingTime], Except[Automatic]],
						Lookup[options,PreLysisPelletingTime],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, PreLysisPelletingTime] && MatchQ[Lookup[methodPacket, PreLysisPelletingTime], Except[Null]],
						Lookup[methodPacket,PreLysisPelletingTime],
					(* Default to 10 Minutes if PreLysisPellet is True *)
					MatchQ[preLysisPelletBool,True],
						10 Minute,
					(* Otherwise, there is no PreLysisPelleting; set time to Null *)
					True,
						Null
				];

				(* Resolve PreLysisSupernatantVolume *)
				preLysisSupernatantVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisSupernatantVolume], Except[Automatic]],
						Lookup[options,PreLysisSupernatantVolume],
					(* Default to 80% of the total solution volume if PreLysisPellet is True *)
					MatchQ[preLysisPelletBool,True],
						0.80 * Total @ Cases[
							{
								volumeFromDissociateCells,
								If[MatchQ[aliquotAmount, GreaterP[0 Microliter]], aliquotAmount, Lookup[samplePacket, Volume]]
							},
							VolumeP
						],
					(* Otherwise, there is no PreLysisPelleting; set the supernatant volume to Null *)
					True,
						Null
				];

				(* Resolve PreLysisSupernatantStorageCondition *)
				preLysisSupernatantStorageCondition = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisSupernatantStorageCondition], Except[Automatic]],
						Lookup[options,PreLysisSupernatantStorageCondition],
					(* Default to Disposal if PreLysisPellet is True *)
					MatchQ[preLysisPelletBool,True],
						Disposal,
					(* Otherwise, there is no PreLysisPelleting; set the supernatant storage condition to Null *)
					True,
						Null
				];

				(* --- DILUTION --- *)

				(* Resolve PreLysisDilute switch *)
				preLysisDiluteBool = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisDilute], BooleanP],
						Lookup[options,PreLysisDilute],
					(* Set to True if either of the dependent options are specified *)
					MemberQ[Lookup[options,{PreLysisDiluent, PreLysisDilutionVolume}], Except[Automatic|Null]],
						True,
					(* Resolve to False if there is no user-specified TargetCellConcentration *)
					MatchQ[Lookup[options, TargetCellConcentration], Null|Automatic],
						False,
					(* Resolve to False if there is not sufficient Composition info in Object[Sample] to calculate TargetCellConcentration *)
					MatchQ[{cellCountAvailableQ,cellConcentrationAvailableQ}, {False,False}],
						False,
					(* If the User-specified TargetCellConcentration is less than the current cell concentration within the container, dilute is True *)
					MatchQ[Lookup[options, TargetCellConcentration],
						LessP[
							Which[
								cellCountAvailableQ,
									Module[{aliquotRatio, totalCellCount, currentVolume},
										(* Get the ratio of the aliquotAmount to the total amount of input sample *)
										aliquotRatio = aliquotAmount / Lookup[samplePacket,Volume];
										(* Get the total cell count from the sample, regardless of the cell models *)
										totalCellCount = Total[cellCountAccessibleComposition[[All,1]]];
										(* Get the total solution volume at this point *)
										currentVolume = Total @ Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume}, VolumeP];
										(* Multiply the aliquotRatio by the totalCellCount and divide by the current volume *)
										aliquotRatio * totalCellCount / currentVolume
									],
								cellConcentrationAvailableQ,
									Module[{totalCellConcentration, currentVolume},
										(* Get the total cell concentration from the sample, regardless of the cell models *)
										totalCellConcentration = Total[cellConcentrationAccessibleComposition[[All,1]]];
										(* Get the total solution volume at this point *)
										currentVolume = Total @ Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume}, VolumeP];
										(* Multiply the sample's cell concentration by the aliquotAmount and divide by the current volume *)
										totalCellConcentration * aliquotAmount / currentVolume
									]
							]
						]
					],
						True,
					(* Otherwise, dilute is False *)
					True,
						False
				];

				(* Resolve PreLysisDiluent *)
				preLysisDiluent = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisDiluent], Except[Automatic]],
						Lookup[options,PreLysisDiluent],
					(* If PreLysisDilute is True, default to 1x PBS buffer as the diluent *)
					MatchQ[preLysisDiluteBool, True],
						Model[Sample, StockSolution, "id:9RdZXv1KejGK"], (* Model[Sample, StockSolution, "1x PBS from 10X stock"] *)
					(* Otherwise, there is no dilution and the diluent resolves to Null *)
					True,
						Null
				];

				(* Resolve PreLysisDilutionVolume *)
				(* In some cases we resolve to 0 uL instead of Null to avoid throwing errors/warnings unnecessarily. *)
				preLysisDilutionVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PreLysisDilutionVolume], Except[Automatic]],
						Lookup[options,PreLysisDilutionVolume],
					(* If PreLysisDilute is False, the dilution volume resolves to Null *)
					MatchQ[preLysisDiluteBool, False],
						Null,
					(* Resolve to 0 Microliter if there is not sufficient Composition info in Object[Sample] to calculate TargetCellConcentration *)
					MatchQ[{cellCountAvailableQ,cellConcentrationAvailableQ}, {False,False}],
						0 Microliter,
					(* If TargetCellConcentration is set by the user, dilute enough to obtain this concentration *)
					MatchQ[Lookup[options, TargetCellConcentration], Except[Null|Automatic]],
						Which[
							cellCountAvailableQ,
								Module[{aliquotRatio, totalCellCount, currentVolume, targetVolume},
									(* Get the ratio of the aliquotAmount to the total amount of input sample *)
									aliquotRatio = aliquotAmount / Lookup[samplePacket,Volume];
									(* Get the total cell count from the sample, regardless of the cell models *)
									totalCellCount = Total[cellCountAccessibleComposition[[All,1]]];
									(* Get the total solution volume at this point *)
									currentVolume = Total@Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume}, VolumeP];
									(* Aliquot ratio times the total cell count divided by the target cell concentration gives the target volume *)
									targetVolume = aliquotRatio * totalCellCount / Lookup[options,TargetCellConcentration];
									(* The dilution volume is the difference between the target volume and the curent volume *)
									SafeRound[targetVolume - currentVolume, $LiquidHandlerVolumeTransferPrecision]
								],
							cellConcentrationAvailableQ,
								Module[{totalCellConcentration, currentVolume, targetVolume},
									(* Get the total cell concentration from the sample, regardless of the cell models *)
									totalCellConcentration = Total[cellConcentrationAccessibleComposition[[All,1]]];
									(* Get the total solution volume at this point *)
									currentVolume = Total@Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume}, VolumeP];
									(* Get the target volume from the total cell concentration times the aliquot amount over the TargetCellConcentration *)
									targetVolume = totalCellConcentration * aliquotAmount / Lookup[options,TargetCellConcentration];
									(* The dilution volume is the difference between the target volume and the curent volume *)
									SafeRound[targetVolume - currentVolume, $LiquidHandlerVolumeTransferPrecision]
								],
							True,
								0 Microliter
						],
					(* If not resolved yet, default to 0 Microliter and throw a warning because there is no reasonable guess to make *)
					True,
						0 Microliter
				];

				(* --- TARGET CELL COUNT AND CONCENTRATION --- *)

				(* Resolve TargetCellCount *)
				targetCellCount = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TargetCellCount], Except[Automatic]],
						Lookup[options,TargetCellCount],
					(* If it is impossible to calculate TargetCellCount with the information given in Object[Sample], resolve to Null *)
					MatchQ[{cellCountAvailableQ,cellConcentrationAvailableQ}, {False,False}],
						Null,
					(* If we are aliquoting, set to the total number of cells in AliquotAmount *)
					MatchQ[aliquotBool, True],
						Which[
							cellCountAvailableQ,
								(* The sample's total cell count times the ratio of the aliquot amount to the total sample amount gives the number of cells in the aliquot amount *)
								Total[cellCountAccessibleComposition[[All,1]]] * aliquotAmount/Lookup[samplePacket,Volume],
							cellConcentrationAvailableQ,
								(* The sample's cell concentration times the aliquot amount gives the number of cells in the aliquot amount *)
								Total[cellConcentrationAccessibleComposition[[All,1]]] * aliquotAmount
						],
					(* If Aliquot is False, set to the total number of cells in Object[Sample] *)
					MatchQ[aliquotBool, False],
					Which[
						cellCountAvailableQ,
							Total[cellCountAccessibleComposition[[All,1]]],
						cellConcentrationAvailableQ,
							(* The sample's cell concentration times the sample's volume gives the number of cells in the aliquot amount *)
							Total[cellConcentrationAccessibleComposition[[All,1]]] * Lookup[samplePacket,Volume]
					],
					(* This should cover all cases, but if somehow it hasn't resolved yet, resolve to Null to be safe *)
					True,
						Null
				];

				(* Resolve TargetCellConcentration *)
				targetCellConcentration = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TargetCellConcentration], Except[Automatic]],
						Lookup[options,TargetCellConcentration],
					(* If Object[Sample] does not contain some amount of a Model[Cell] with Cell or Cell concentration units in the composition field, resolve to Null *)
					MatchQ[{cellCountAvailableQ,cellConcentrationAvailableQ}, {False,False}],
						Null,
					(* If Aliquot is True, set to the total number of cells in AliquotAmount divided by the sum of all solutions added to this point *)
					MatchQ[aliquotBool, True],
						Which[
							cellCountAvailableQ,
								Module[{aliquotRatio, totalCellCount, currentVolume},
									(* Get the ratio of the aliquotAmount to the total amount of input sample *)
									aliquotRatio = aliquotAmount / Lookup[samplePacket,Volume];
									(* Get the total cell count from the sample, regardless of the cell models *)
									totalCellCount = Total[cellCountAccessibleComposition[[All,1]]];
									(* Get the total solution volume at this point *)
									currentVolume = Total@Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume, preLysisDilutionVolume}, VolumeP];
									(* Multiply the aliquotRatio by the totalCellCount and divide by the current volume *)
									aliquotRatio * totalCellCount / currentVolume
								],
								cellConcentrationAvailableQ,
								Module[{totalCellConcentration, currentVolume},
									(* Get the total cell concentration from the sample, regardless of the cell models *)
									totalCellConcentration = Total[cellConcentrationAccessibleComposition[[All,1]]];
									(* Get the total solution volume at this point *)
									currentVolume = Total@Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume, preLysisDilutionVolume}, VolumeP];
									(* Multiply the sample's cell concentration by the aliquotAmount and divide by the total volume *)
									totalCellConcentration * aliquotAmount / currentVolume
								]
						],
					(* If Aliquot is False, set to the total number of cells in Object[Sample] divided by the sum of all solutions added to this point *)
					MatchQ[aliquotBool, False],
						Which[
							cellCountAvailableQ,
								Module[{totalCellCount, currentVolume},
									(* Get the total cell count from the sample, regardless of the cell models *)
									totalCellCount = Total[cellCountAccessibleComposition[[All,1]]];
									(* Get the total solution volume at this point *)
									currentVolume = Total@Cases[{volumeFromDissociateCells,Lookup[samplePacket,Volume],-preLysisSupernatantVolume, preLysisDilutionVolume}, VolumeP];
									(* The total cell count divided by the current volume gives the cell concentration *)
									totalCellCount / currentVolume
								],
							cellConcentrationAvailableQ,
								Module[{totalCellConcentration, currentVolume},
									(* Get the total cell concentration from the sample, regardless of the cell models *)
									totalCellConcentration = Total[cellConcentrationAccessibleComposition[[All,1]]];
									(* Get the total solution volume at this point *)
									currentVolume = Total@Cases[{volumeFromDissociateCells,Lookup[samplePacket,Volume],-preLysisSupernatantVolume, preLysisDilutionVolume}, VolumeP];
									(* The sample's cell concentration times its volume, divided by the current volume gives the cell concentration *)
									totalCellConcentration * Lookup[samplePacket,Volume] / currentVolume
								]
						],
					(* This should cover all cases, but if somehow it hasn't resolved yet, resolve to Null to be safe *)
					True,
						Null
				];

				(* --- PRIMARY LYSIS STEP --- *)

				(* Resolve LysisSolution *)
				lysisSolution = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,LysisSolution], Except[Automatic]],
						Lookup[options,LysisSolution],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, LysisSolution] && MatchQ[Lookup[methodPacket, LysisSolution], Except[Null]],
						LinkedObject[Lookup[methodPacket,LysisSolution]],
					(* If we are extracting RNA, default to TRIzol *)
					MatchQ[targetCellularComponent, RNA],
						Model[Sample, "id:mnk9jOkYjA4K"], (* Model[Sample, "TRIzol"] *)
					(* If we are extracting PlasmidDNA, default to alkaline SDS lysis buffer with RNAse *)
					MatchQ[targetCellularComponent, PlasmidDNA],
						Model[Sample, StockSolution, "id:eGaklda6dGvE"], (* Model[Sample, StockSolution, "Alkaline lysis buffer for Plasmid DNA extraction"] *)
					(* If we are extracting GenomicDNA, default to DNAzol *)
					MatchQ[targetCellularComponent, GenomicDNA],
						Model[Sample, "id:o1k9jAkvAdz8"], (* Model[Sample, "DNAzol"] *)
					(* If we are extracting Protein or Unspecified targets from Mammalian cells, default to RIPA with protease inhibitor cocktail *)
					And[
						MatchQ[targetCellularComponent, Alternatives[CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, Unspecified]],
						MatchQ[cellType, Mammalian]
					],
						Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"], (* Model[Sample, StockSolution, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
					(* If we are extracting Protein  or Unspecified targets from Bacterial cells, default to ThermoFisher B-PER lysis reagent *)
					And[
						MatchQ[targetCellularComponent, Alternatives[CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, Unspecified]],
						MatchQ[cellType, Bacterial]
					],
						Model[Sample, "id:R8e1PjeVjwlK"], (* Model[Sample, "B-PER Bacterial Protein Extraction Reagent"] *)
					(* If we are extracting Protein or Unspecified targets from Yeast cells, default to ThermoFisher Y-PER lysis reagent *)
					And[
						MatchQ[targetCellularComponent, Alternatives[CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, Unspecified]],
						MatchQ[cellType, Yeast]
					],
						Model[Sample, "id:AEqRl9qm9Xnl"], (* Model[Sample, "Y-PER Yeast Protein Extraction Reagent"] *)
					(* Just to be safe, resolve to RIPA with protease inhibitor cocktail if all else fails. *)
					True,
						Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"] (* Model[Sample, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
				];

				(* Resolve LysisSolutionVolume *)
				lysisSolutionVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,LysisSolutionVolume], Except[Automatic]],
						Lookup[options,LysisSolutionVolume],
					(* If AliquotContainer is user-specified, use 50% of the container's unoccupied volume divided by numberOfLysisSteps *)
					MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						RoundOptionPrecision[Module[{containerMaxVolume, currentVolume, availableVolume},
							(* Get the max volume of the specified container *)
							containerMaxVolume = Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], MaxVolume];
							(* Get the current solution volume within the container *)
							currentVolume = Total @ Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume,preLysisDilutionVolume}, VolumeP];
							(* Subtract the current volume from the max volume to get the available volume *)
							availableVolume = containerMaxVolume - currentVolume;
							(* Divide the available volume by the number of lysis steps and multiply it all by 50% *)
							0.50 * availableVolume / numberOfLysisSteps
						], 10^(-1) Microliter],
					(* If Aliquot is True but the user hasn't specified a container, use nine times the AliquotAmount divided by the NumberOfLysisSteps *)
					MatchQ[aliquotBool, True],
						RoundOptionPrecision[((aliquotAmount * 9) / numberOfLysisSteps), 10^(-1) Microliter],
					(* Otherwise we're not aliquoting, so use 50% of the unoccupied input container volume divided by numberOfLysisSteps *)
					True,
						RoundOptionPrecision[Module[{currentVolume, availableVolume},
							(* Get the current solution volume *)
							currentVolume = Total @ Cases[{volumeFromDissociateCells, Lookup[samplePacket, Volume], -preLysisSupernatantVolume, preLysisDilutionVolume}, VolumeP];
							(* Subtract this from the max volume of the sample container to get the available volume *)
							availableVolume = Lookup[sampleContainerModelPacket, MaxVolume] - currentVolume;
							(* Take 50% of the available volume divided by the number of lysis steps *)
							0.50 * availableVolume / numberOfLysisSteps
						], 10^(-1) Microliter]
				];

				(* Resolve MixType *)
				mixType = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,MixType], Except[Automatic]],
						Lookup[options,MixType],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, MixType] && MatchQ[Lookup[methodPacket, MixType], Except[Null]],
						Lookup[methodPacket,MixType],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, LysisMixType],
						!KeyExistsQ[methodPacket, MixType],
						MatchQ[Lookup[methodPacket, LysisMixType], Except[Null]]
					],
						Lookup[methodPacket, LysisMixType],
					(* If any options relevant to Pipette are specified by the user, default to Pipette *)
					MemberQ[Lookup[options,{MixVolume,NumberOfMixes}], Except[Null|Automatic]],
						Pipette,
					(* If any options relevant to Shake are specified by the user, default to Shake *)
					MemberQ[Lookup[options,{MixRate,MixTime,MixInstrument}], Except[Null|Automatic]],
						Shake,
					(* If any options relevant to Pipette are specified by a LyseCells method, default to Pipette *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {MixVolume,NumberOfMixes}, True],
						MemberQ[Cases[Lookup[methodPacket, {MixVolume,NumberOfMixes}], Except[Missing[_,_]]], Except[Null]]
					],
						Pipette,
					(* If any options relevant to Pipette are specified by an Extraction method, default to Pipette *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {LysisMixVolume,NumberOfLysisMixes}, True],
						MemberQ[Cases[Lookup[methodPacket, {LysisMixVolume,NumberOfLysisMixes}], Except[Missing[_,_]]], Except[Null]]
					],
						Pipette,
					(* If any options relevant to Shake are specified by a LyseCells method, default to Shake *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {MixRate,MixTime,MixInstrument}, True],
						MemberQ[Cases[Lookup[methodPacket, {MixRate,MixTime,MixInstrument}], Except[Missing[_,_]]], Except[Null]]
					],
						Shake,
					(* If any options relevant to Shake are specified by an Extraction method, default to Shake *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {LysisMixRate,LysisMixTime,LysisMixInstrument}, True],
						MemberQ[Cases[Lookup[methodPacket, {LysisMixRate,LysisMixTime,LysisMixInstrument}], Except[Missing[_,_]]], Except[Null]]
					],
						Shake,
					(* If any temperature option is set to any temperature other than Ambient, resolve to Shake *)
					MemberQ[Lookup[options, $TemperatureControlOptions], Except[Null|Automatic|AmbientTemperatureP]],
						Shake,
					(* If Aliquot is False, use the model of the input sample container - i.e., plate vs. tube - to determine MixType *)
					MatchQ[aliquotBool,False],
						If[MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate],
							Shake,
							Pipette
						],
					(* If AliquotContainer is user-specified, resolve to Shake for plates and Pipette for non-plates *)
					MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						If[MatchQ[Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], Footprint], Plate],
							Shake,
							Pipette
						],
					(* If the sample will be centrifuged, resolve to Shake since we must use a plate *)
					MemberQ[{preLysisPelletBool, clarifyLysateBool}, True],
						Shake,
					(* If we're not done yet, resolve to Shake if solution volume is less than 70% of a theoretical suitable container and resolve to Pipette otherwise *)
					True,
						Module[{currentVolume, estimatedFinalVolume, suitableContainer, suitableContainerMaxVolume},
							(* Get the total volume at this point *)
							currentVolume = Total @ Cases[
								{volumeFromDissociateCells, aliquotAmount, -preLysisSupernatantVolume, preLysisDilutionVolume, lysisSolutionVolume}, VolumeP];
							(* Estimate the final volume by multiplying the lysisSolutionVolume by the number of lysis steps *)
							estimatedFinalVolume = Total @ Cases[
								{volumeFromDissociateCells, aliquotAmount, -preLysisSupernatantVolume, preLysisDilutionVolume, numberOfLysisSteps * lysisSolutionVolume}, VolumeP];
							(* Use PreferredContainer to find a suitable container for the estimated final volume *)
							suitableContainer = PreferredContainer[estimatedFinalVolume, LiquidHandlerCompatible -> True];
							(* Get the maximum volume of the suitable container we found *)
							suitableContainerMaxVolume = Lookup[fetchModelPacketFromFastAssoc[suitableContainer, fastAssoc], MaxVolume];
							(* If the current volume is less than 70% of the volume of the possible suitable container we found, resolve to Shake Otherwise, Pipette *)
							If[
								MatchQ[currentVolume, LessP[0.70 * suitableContainerMaxVolume]],
								Shake,
								Pipette
							]
						]
				];

				(* Resolve MixRate *)
				mixRate = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,MixRate], Except[Automatic]],
						Lookup[options,MixRate],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, MixRate] && MatchQ[Lookup[methodPacket, MixRate], Except[Null]],
						Lookup[methodPacket,MixRate],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, LysisMixRate],
						!KeyExistsQ[methodPacket, MixRate],
						MatchQ[Lookup[methodPacket, LysisMixRate], Except[Null]]
					],
						Lookup[methodPacket,LysisMixRate],
					(* If mixType is Shake, MixRate resolves to 200 RPM *)
					MatchQ[mixType, Shake],
						200 RPM,
					(* Else, MixRate is Null *)
					True,
						Null
				];

				(* Resolve MixTime *)
				mixTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,MixTime], Except[Automatic]],
						Lookup[options,MixTime],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, MixTime] && MatchQ[Lookup[methodPacket, MixTime], Except[Null]],
						Lookup[methodPacket,MixTime],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, LysisMixTime],
						!KeyExistsQ[methodPacket, MixTime],
						MatchQ[Lookup[methodPacket, LysisMixTime], Except[Null]]
					],
						Lookup[methodPacket,LysisMixTime],
					(* If mixType is Shake, MixTime resolves to 1 Minute *)
					MatchQ[mixType, Shake],
						1 Minute,
					(* Else, MixTime is Null *)
					True,
						Null
				];

				(* Resolve MixVolume *)
				mixVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,MixVolume], Except[Automatic]],
						Lookup[options,MixVolume],
					(* If mixType is not Pipette, MixVolume resolves to Null *)
					MatchQ[mixType, Except[Pipette]],
						Null,
					(* Else, MixVolume is the lesser of: $MaxRoboticSingleTransferVolume or 50% of the total solution volume *)
					True,
						RoundOptionPrecision[Min[
							$MaxRoboticSingleTransferVolume,
							0.50 * Total @ Cases[
								{
									volumeFromDissociateCells,
									If[MatchQ[aliquotAmount, GreaterP[0 Microliter]], aliquotAmount, Lookup[samplePacket, Volume]],
									-preLysisSupernatantVolume,
									preLysisDilutionVolume,
									lysisSolutionVolume
								}, VolumeP
							]
						], 10^(-1) Microliter]
				];

				(* Resolve NumberOfMixes *)
				numberOfMixes = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,NumberOfMixes], Except[Automatic]],
						Lookup[options,NumberOfMixes],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, NumberOfMixes] && MatchQ[Lookup[methodPacket, NumberOfMixes], Except[Null]],
						Lookup[methodPacket,NumberOfMixes],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, LysisNumberOfMixes],
						!KeyExistsQ[methodPacket, NumberOfMixes],
						MatchQ[Lookup[methodPacket, LysisNumberOfMixes], Except[Null]]
					],
						Lookup[methodPacket,NumberOfLysisMixes],
					(* If the MixType is Pipette, default to 10 mixes *)
					MatchQ[mixType,Pipette],
						10,
					(* Else, number of mixes is Null *)
					True,
						Null
				];

				(* Resolve MixTemperature *)
				mixTemperature = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,MixTemperature], Except[Automatic]],
						Lookup[options,MixTemperature],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, MixTemperature] && MatchQ[Lookup[methodPacket, MixTemperature], Except[Null]],
						Lookup[methodPacket,MixTemperature],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, LysisMixTemperature],
						!KeyExistsQ[methodPacket, MixTemperature],
						MatchQ[Lookup[methodPacket, LysisMixTemperature], Except[Null]]
					],
						Lookup[methodPacket,LysisMixTemperature],
					(* If the mix type is not Shake, resolve to Null *)
					MatchQ[mixType, Except[Shake]],
						Null,
					(* Otherwise, resolve to Ambient *)
					True,
						Ambient
				];

				(* Resolve MixInstrument *)
				mixInstrument = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,MixInstrument], Except[Automatic]],
						Lookup[options,MixInstrument],
					(* Set to Null if MixType is anything but Shake *)
					MatchQ[mixType, Except[Shake]],
						Null,
					(* Set to the Inheco ThermoshakeAC if the MixRate falls outside the other shaker's RPM range *)
					!MatchQ[mixRate, RangeP[
						Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MinRotationRate],
						Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxRotationRate]]
					],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Set to the Inheco ThermoshakeAC if the MixTemperature is less than or equal to this shaker's max temperature *)
					MatchQ[mixTemperature /. Ambient -> $AmbientTemperature, LessEqualP[Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxTemperature]]],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Set to the Inheco Incubator Shaker if the MixTemperature is greater than the on-deck shaker's max temperature *)
					True,
						Model[Instrument, Shaker, "id:eGakldJkWVnz"] (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
				];

				(* Resolve LysisTemperature *)
				lysisTemperature = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,LysisTemperature], Except[Automatic]],
						Lookup[options,LysisTemperature],
					(* Use the Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, LysisTemperature],
						MatchQ[Lookup[methodPacket, LysisTemperature], (Ambient|TemperatureP)]
					],
						Lookup[methodPacket, LysisTemperature],
					(* Otherwise, resolve to Ambient *)
					True,
						Ambient
				];

				(* Resolve LysisTime *)
				lysisTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,LysisTime], Except[Automatic]],
						Lookup[options,LysisTime],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, LysisTime] && MatchQ[Lookup[methodPacket, LysisTime], Except[Null]],
						Lookup[methodPacket,LysisTime],
					(* Otherwise, resolve to 15 Minutes *)
					True,
						15 Minute
				];

				(* Resolve IncubationInstrument *)
				incubationInstrument = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,IncubationInstrument], Except[Automatic]],
						Lookup[options,IncubationInstrument],
					(* Resolve to the integrated heat block if there is no shaking *)
					MatchQ[mixType, Except[Shake]],
						Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
					(* If the lysis temperature is within the temp range of the integrated shaker and it is the resolved mix instrument, use it for incubation as well *)
					And[
						MatchQ[mixInstrument, ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]]], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
						MatchQ[lysisTemperature /. Ambient -> $AmbientTemperature, RangeP[
							Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MinTemperature],
							Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxTemperature]]]
					],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Otherwise, just use the heat block *)
					True,
						Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
				];

				(* --- SECONDARY LYSIS STEP --- *)

				(* Resolve SecondaryLysisSolution *)
				secondaryLysisSolution = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryLysisSolution], Except[Automatic]],
						Lookup[options,SecondaryLysisSolution],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket,SecondaryLysisSolution] && MatchQ[Lookup[methodPacket, SecondaryLysisSolution], Except[Null]],
						Lookup[methodPacket,SecondaryLysisSolution],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* Use the LysisSolution that we used in the previous lysis step *)
					True,
						lysisSolution
				];

				(* Resolve SecondaryLysisSolutionVolume *)
				secondaryLysisSolutionVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryLysisSolutionVolume], Except[Automatic]],
						Lookup[options,SecondaryLysisSolutionVolume],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* If AliquotContainer is user-specified, use 50% of the container's unoccupied volume divided by the numberOfLysisSteps *)
					MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						RoundOptionPrecision[Module[{containerMaxVolume, currentVolume,availableVolume},
							(* Get the max volume of the specified container *)
							containerMaxVolume = Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], MaxVolume];
							(* Get the current solution volume within the container *)
							currentVolume = Total @ Cases[{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume,preLysisDilutionVolume,lysisSolutionVolume}, VolumeP];
							(* Subtract the current volume from the max volume to get the available volume *)
							availableVolume = containerMaxVolume - currentVolume;
							(* Divide the available volume by one less than the number of lysis steps and multiply it all by 50% *)
							(0.50 * availableVolume) / (numberOfLysisSteps)
						], 10^(-1) Microliter],
					(* If Aliquot is True but we have no specified AliquotContainer, use nine times the AliquotAmount divided by the NumberOfLysisSteps *)
					MatchQ[aliquotBool, True],
						RoundOptionPrecision[((9 * aliquotAmount) / numberOfLysisSteps), 10^(-1) Microliter],
					(* Otherwise we're not aliquoting, so use 50% of the unoccupied input container volume divided by one less than the numberOfLysisSteps *)
					True,
						RoundOptionPrecision[Module[{currentVolume, availableVolume},
							(* Get the current solution volume *)
							currentVolume = Total @ Cases[
								{volumeFromDissociateCells, Lookup[samplePacket, Volume], -preLysisSupernatantVolume, preLysisDilutionVolume, lysisSolutionVolume}, VolumeP];
							(* Subtract this from the max volume of the sample container to get the available volume *)
							availableVolume = Lookup[sampleContainerModelPacket, MaxVolume] - currentVolume;
							(* Take 50% of the available volume divided by one less than the number of lysis steps *)
							(0.50 * availableVolume) / numberOfLysisSteps
						], 10^(-1) Microliter]
				];

				(* Resolve SecondaryMixType *)
				secondaryMixType = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryMixType], Except[Automatic]],
						Lookup[options,SecondaryMixType],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, SecondaryMixType] && MatchQ[Lookup[methodPacket, SecondaryMixType], Except[Null]],
						Lookup[methodPacket,SecondaryMixType],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, SecondaryLysisMixType],
						!KeyExistsQ[methodPacket, SecondaryMixType],
						MatchQ[Lookup[methodPacket, SecondaryLysisMixType], Except[Null]]
					],
						Lookup[methodPacket,SecondaryLysisMixType],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* If any secondary mix options relevant to Pipette are specified, default to Pipette *)
					MemberQ[Lookup[options,{SecondaryMixVolume,SecondaryNumberOfMixes}], Except[Null|Automatic]],
						Pipette,
					(* If any secondary mix options relevant to Shake are specified, default to Shake *)
					MemberQ[Lookup[options,{SecondaryMixRate,SecondaryMixTime,SecondaryMixInstrument}], Except[Null|Automatic]],
						Shake,
					(* If any options relevant to Pipette are specified by a LyseCells method, default to Pipette *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {SecondaryMixVolume,SecondaryNumberOfMixes}, True],
						MemberQ[Cases[Lookup[methodPacket, {SecondaryMixVolume,SecondaryNumberOfMixes}], Except[Missing[_,_]]], Except[Null]]
					],
						Pipette,
					(* If any options relevant to Pipette are specified by an Extraction method, default to Pipette *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {SecondaryLysisMixVolume,SecondaryNumberOfLysisMixes}, True],
						MemberQ[Cases[Lookup[methodPacket, {SecondaryLysisMixVolume,SecondaryNumberOfLysisMixes}], Except[Missing[_,_]]], Except[Null]]
					],
						Pipette,
					(* If any options relevant to Shake are specified by a LyseCells method, default to Shake *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {SecondaryMixRate,SecondaryMixTime,SecondaryMixInstrument}, True],
						MemberQ[Cases[Lookup[methodPacket, {SecondaryMixRate,SecondaryMixTime,SecondaryMixInstrument}], Except[Missing[_,_]]], Except[Null]]
					],
						Shake,
					(* If any options relevant to Shake are specified by an Extraction method, default to Shake *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {SecondaryLysisMixRate,SecondaryLysisMixTime,SecondaryLysisMixInstrument}, True],
						MemberQ[Cases[Lookup[methodPacket, {SecondaryLysisMixRate,SecondaryLysisMixTime,SecondaryLysisMixInstrument}], Except[Missing[_,_]]], Except[Null]]
					],
						Shake,
					(* If any temperature option is set to any temperature other than Ambient, resolve to Shake *)
					MemberQ[Lookup[options, $TemperatureControlOptions], Except[Null|Automatic|AmbientTemperatureP]],
					Shake,
					(* If Aliquot is False, use the model of the input sample container - i.e., plate vs. tube - to determine MixType *)
					MatchQ[aliquotBool,False],
						If[MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate],
							Shake,
							Pipette
						],
					(* If AliquotContainer is user-specified, resolve to Shake for plates and Pipette for non-plates *)
					MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						If[MatchQ[Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], Footprint], Plate],
							Shake,
							Pipette
						],
					(* If the sample will be centrifuged, resolve to Shake since we must be in a plate *)
					MatchQ[aliquotBool, True] && MemberQ[{preLysisPelletBool, clarifyLysateBool}, True],
						Shake,
					(* If we're not done yet, resolve to Shake if solution volume is less than 70% of a theoretical suitable container and resolve to Pipette otherwise *)
					True,
						Module[{currentVolume, estimatedFinalVolume, suitableContainer, suitableContainerMaxVolume},
							(* Get the total volume at this point *)
							currentVolume = Total @ Cases[
								{volumeFromDissociateCells, aliquotAmount, -preLysisSupernatantVolume, preLysisDilutionVolume, lysisSolutionVolume, secondaryLysisSolutionVolume}, VolumeP];
							(* Estimate the final volume by multiplying the secondaryLysisSolutionVolume by one less than the number of lysis steps *)
							estimatedFinalVolume = Total @ Cases[
								{
									volumeFromDissociateCells, aliquotAmount, -preLysisSupernatantVolume, preLysisDilutionVolume,
									lysisSolutionVolume, secondaryLysisSolutionVolume * (numberOfLysisSteps - 1)
								},
								VolumeP
							];
							(* Use PreferredContainer to find a suitable container for the estimated final volume *)
							suitableContainer = PreferredContainer[estimatedFinalVolume, LiquidHandlerCompatible -> True];
							(* Get the maximum volume of the suitable container we found *)
							suitableContainerMaxVolume = Lookup[fetchModelPacketFromFastAssoc[suitableContainer, fastAssoc], MaxVolume];
							(* If the current volume is less than 70% of the volume of the possible suitable container we found, resolve to Shake Otherwise, Pipette *)
							If[
								MatchQ[currentVolume, LessP[0.70 * suitableContainerMaxVolume]],
								Shake,
								Pipette
							]
						]
				];

				(* Resolve SecondaryMixRate *)
				secondaryMixRate = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryMixRate], Except[Automatic]],
						Lookup[options,SecondaryMixRate],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, SecondaryMixRate] && MatchQ[Lookup[methodPacket, SecondaryMixRate], Except[Null]],
						Lookup[methodPacket,SecondaryMixRate],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, SecondaryLysisMixRate],
						!KeyExistsQ[methodPacket, SecondaryMixRate],
						MatchQ[Lookup[methodPacket, SecondaryLysisMixRate], Except[Null]]
					],
						Lookup[methodPacket,SecondaryLysisMixRate],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* If secondaryMixType is Shake, SecondaryMixRate resolves to 200 RPM *)
					MatchQ[secondaryMixType, Shake],
						200 RPM,
					(* Else, SecondaryMixRate is Null *)
					True,
						Null
				];

				(* Resolve SecondaryMixTime *)
				secondaryMixTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryMixTime], Except[Automatic]],
						Lookup[options,SecondaryMixTime],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, SecondaryMixTime] && MatchQ[Lookup[methodPacket, SecondaryMixTime], Except[Null]],
						Lookup[methodPacket,SecondaryMixTime],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, SecondaryLysisMixTime],
						!KeyExistsQ[methodPacket, SecondaryMixTime],
						MatchQ[Lookup[methodPacket, SecondaryLysisMixTime], Except[Null]]
					],
						Lookup[methodPacket,SecondaryLysisMixTime],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* If secondaryMixType is Shake, MixTime resolves to 1 Minute *)
					MatchQ[secondaryMixType, Shake],
						1 Minute,
					(* Else, SecondaryMixTime is Null *)
					True,
						Null
				];

				(* Resolve SecondaryMixVolume *)
				secondaryMixVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryMixVolume], Except[Automatic]],
						Lookup[options,SecondaryMixVolume],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* If secondaryMixType is not Pipette, SecondaryMixVolume resolves to Null *)
					MatchQ[secondaryMixType, Except[Pipette]],
						Null,
					(* Else, SecondaryMixVolume is the lesser of: $MaxRoboticSingleTransferVolume or 50% of the total solution volume *)
					True,
						RoundOptionPrecision[Min[
							$MaxRoboticSingleTransferVolume,
							0.50 * Total @ Cases[
								{
									volumeFromDissociateCells,
									If[MatchQ[aliquotAmount, GreaterP[0 Microliter]], aliquotAmount, Lookup[samplePacket, Volume]],
									-preLysisSupernatantVolume,
									preLysisDilutionVolume,
									lysisSolutionVolume,
									secondaryLysisSolutionVolume
								}, VolumeP
							]
						], 10^(-1) Microliter]
				];

				(* Resolve SecondaryNumberOfMixes *)
				secondaryNumberOfMixes = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryNumberOfMixes], Except[Automatic]],
						Lookup[options,SecondaryNumberOfMixes],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, SecondaryNumberOfMixes] && MatchQ[Lookup[methodPacket, SecondaryNumberOfMixes], Except[Null]],
						Lookup[methodPacket,SecondaryNumberOfMixes],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, SecondaryNumberOfLysisMixes],
						!KeyExistsQ[methodPacket, SecondaryNumberOfMixes],
						MatchQ[Lookup[methodPacket, SecondaryNumberOfLysisMixes], Except[Null]]
					],
						Lookup[methodPacket,SecondaryNumberOfLysisMixes],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* If the SecondaryMixType is Pipette, default to 10 mixes *)
					MatchQ[secondaryMixType,Pipette],
						10,
					(* Else, Secondary number of mixes is Null *)
					True,
						Null
				];

				(* Resolve SecondaryMixTemperature *)
				secondaryMixTemperature = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryMixTemperature], Except[Automatic]],
						Lookup[options,SecondaryMixTemperature],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, SecondaryMixTemperature] && MatchQ[Lookup[methodPacket, SecondaryMixTemperature], Except[Null]],
						Lookup[methodPacket,SecondaryMixTemperature],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, SecondaryLysisMixTemperature],
						!KeyExistsQ[methodPacket, SecondaryMixTemperature],
						MatchQ[Lookup[methodPacket, SecondaryLysisMixTemperature], Except[Null]]
					],
						Lookup[methodPacket,SecondaryLysisMixTemperature],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* If the mix type is not Shake, resolve to Null *)
					MatchQ[secondaryMixType, Except[Shake]],
						Null,
					(* Otherwise, resolve to Ambient *)
					True,
						Ambient
				];

				(* Resolve SecondaryMixInstrument *)
				secondaryMixInstrument = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryMixInstrument], Except[Automatic]],
						Lookup[options,SecondaryMixInstrument],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* Set to Null if the secondary MixType is anything but Shake *)
					MatchQ[secondaryMixType, Except[Shake]],
						Null,
					(* Set to the Inheco ThermoshakeAC if the secondary MixRate falls outside the other shaker's RPM range *)
					!MatchQ[secondaryMixRate, RangeP[
						Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MinRotationRate],
						Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxRotationRate]]
					],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Set to the Inheco ThermoshakeAC if the secondary MixTemperature is less than or equal to this shaker's max temperature *)
					MatchQ[secondaryMixTemperature /. Ambient -> $AmbientTemperature, LessEqualP[Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxTemperature]]],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Set to the Inheco Incubator Shaker if the secondary MixTemperature is greater than the on-deck shaker's max temperature *)
					True,
						Model[Instrument, Shaker, "id:eGakldJkWVnz"] (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
				];

				(* Resolve SecondaryLysisTemperature *)
				secondaryLysisTemperature = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryLysisTemperature], Except[Automatic]],
						Lookup[options,SecondaryLysisTemperature],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, SecondaryLysisTemperature] && MatchQ[Lookup[methodPacket, SecondaryLysisTemperature], Except[Null]],
						Lookup[methodPacket,SecondaryLysisTemperature],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* Otherwise, resolve to Ambient *)
					True,
						Ambient
				];

				(* Resolve SecondaryLysisTime *)
				secondaryLysisTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryLysisTime], Except[Automatic]],
						Lookup[options,SecondaryLysisTime],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, SecondaryLysisTime] && MatchQ[Lookup[methodPacket, SecondaryLysisTime], Except[Null]],
						Lookup[methodPacket,SecondaryLysisTime],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* Otherwise, resolve to 15 Minutes *)
					True,
						15 Minute
				];

				(* Resolve SecondaryIncubationInstrument *)
				secondaryIncubationInstrument = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SecondaryIncubationInstrument], Except[Automatic]],
						Lookup[options,SecondaryIncubationInstrument],
					(* Resolve to Null if the number of lysis steps is less than 2 *)
					MatchQ[numberOfLysisSteps, 1],
						Null,
					(* Resolve to the integrated heat block if there is no shaking *)
					MatchQ[secondaryMixType, Except[Shake]],
						Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
					(* If the secondary lysis temperature is within the temp range of the integrated shaker and it is the resolved secondary mix instrument, use it for incubation as well *)
					And[
						MatchQ[secondaryMixInstrument, ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]]], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
						MatchQ[secondaryLysisTemperature /. Ambient -> $AmbientTemperature, RangeP[
							Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MinTemperature],
							Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxTemperature]]]
					],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Otherwise, just use the heat block *)
					True,
						Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
				];

				(* --- TERTIARY LYSIS STEP --- *)

				(* Resolve TertiaryLysisSolution *)
				tertiaryLysisSolution = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryLysisSolution], Except[Automatic]],
						Lookup[options,TertiaryLysisSolution],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryLysisSolution] && MatchQ[Lookup[methodPacket, TertiaryLysisSolution], Except[Null]],
						Lookup[methodPacket,TertiaryLysisSolution],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* Use the LysisSolution that we used in the previous lysis step *)
					True,
						secondaryLysisSolution
				];

				(* Resolve TertiaryLysisSolutionVolume *)
				tertiaryLysisSolutionVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryLysisSolutionVolume], Except[Automatic]],
						Lookup[options,TertiaryLysisSolutionVolume],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* If AliquotContainer is user-specified, use 50% of the container's unoccupied volume *)
					MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						RoundOptionPrecision[Module[{containerMaxVolume, currentVolume,availableVolume},
							(* Get the max volume of the specified container *)
							containerMaxVolume = Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], MaxVolume];
							(* Get the current solution volume within the container *)
							currentVolume = Total @ Cases[
								{volumeFromDissociateCells,aliquotAmount,-preLysisSupernatantVolume,preLysisDilutionVolume,lysisSolutionVolume,secondaryLysisSolutionVolume}, VolumeP];
							(* Subtract the current volume from the max volume to get the available volume *)
							availableVolume = containerMaxVolume - currentVolume;
							(* Take 50% of the available volume *)
							(0.50 * availableVolume) / numberOfLysisSteps
						], 10^(-1) Microliter],
					(* If Aliquot is True but we have no specified AliquotContainer, use nine times the AliquotAmount divided by the NumberOfLysisSteps *)
					MatchQ[aliquotBool, True],
						RoundOptionPrecision[((aliquotAmount * 9) / numberOfLysisSteps), 10^(-1) Microliter],
					(* Otherwise we're not aliquoting, so use 50% of the unoccupied input container volume divided by numberOfLysisSteps *)
					True,
						RoundOptionPrecision[Module[{currentVolume, availableVolume},
							(* Get the current solution volume *)
							currentVolume = Total @ Cases[
								{volumeFromDissociateCells, Lookup[samplePacket, Volume], -preLysisSupernatantVolume, preLysisDilutionVolume, lysisSolutionVolume, secondaryLysisSolutionVolume}, VolumeP];
							(* Subtract this from the max volume of the sample container to get the available volume *)
							availableVolume = Lookup[sampleContainerModelPacket, MaxVolume] - currentVolume;
							(* Take 50% of the available volume divided by numberOfLysisSteps *)
							(0.50 * availableVolume) / numberOfLysisSteps
						], 10^(-1) Microliter]
				];

				(* Resolve TertiaryMixType *)
				tertiaryMixType = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryMixType], Except[Automatic]],
						Lookup[options,TertiaryMixType],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryMixType] && MatchQ[Lookup[methodPacket, TertiaryMixType], Except[Null]],
						Lookup[methodPacket,TertiaryMixType],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, TertiaryLysisMixType],
						!KeyExistsQ[methodPacket, TertiaryMixType],
						MatchQ[Lookup[methodPacket, TertiaryLysisMixType], Except[Null]]
					],
						Lookup[methodPacket,TertiaryLysisMixType],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* If any tertiary mix options relevant to Pipette are specified, default to Pipette *)
					MemberQ[Lookup[options,{TertiaryMixVolume,TertiaryNumberOfMixes}], Except[Null|Automatic]],
						Pipette,
					(* If any tertiary mix options relevant to Shake are specified, default to Shake *)
					MemberQ[Lookup[options,{TertiaryMixRate,TertiaryMixTime,TertiaryMixInstrument}], Except[Null|Automatic]],
						Shake,
					(* If any options relevant to Pipette are specified by a LyseCells method, default to Pipette *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {TertiaryMixVolume,TertiaryNumberOfMixes}, True],
						MemberQ[Cases[Lookup[methodPacket, {TertiaryMixVolume,TertiaryNumberOfMixes}], Except[Missing[_,_]]], Except[Null]]
					],
						Pipette,
					(* If any options relevant to Pipette are specified by an Extraction method, default to Pipette *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {TertiaryLysisMixVolume,TertiaryNumberOfLysisMixes}, True],
						MemberQ[Cases[Lookup[methodPacket, {TertiaryLysisMixVolume,TertiaryNumberOfLysisMixes}], Except[Missing[_,_]]], Except[Null]]
					],
						Pipette,
					(* If any options relevant to Shake are specified by a LyseCells method, default to Shake *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {TertiaryMixRate,TertiaryMixTime,TertiaryMixInstrument}, True],
						MemberQ[Cases[Lookup[methodPacket, {TertiaryMixRate,TertiaryMixTime,TertiaryMixInstrument}], Except[Missing[_,_]]], Except[Null]]
					],
						Shake,
					(* If any options relevant to Shake are specified by an Extraction method, default to Shake *)
					And[
						methodSpecifiedQ,
						MemberQ[KeyExistsQ[methodPacket, #] & /@ {TertiaryLysisMixRate,TertiaryLysisMixTime,TertiaryLysisMixInstrument}, True],
						MemberQ[Cases[Lookup[methodPacket, {TertiaryLysisMixRate,TertiaryLysisMixTime,TertiaryLysisMixInstrument}], Except[Missing[_,_]]], Except[Null]]
					],
						Shake,
					(* If any temperature option is set to any temperature other than Ambient, resolve to Shake *)
					MemberQ[Lookup[options, $TemperatureControlOptions], Except[Null|Automatic|AmbientTemperatureP]],
						Shake,
					(* If Aliquot is False, use the model of the input sample container - i.e., plate vs. tube - to determine MixType *)
					MatchQ[aliquotBool,False],
						If[MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate],
							Shake,
							Pipette
						],
					(* If AliquotContainer is user-specified, resolve to Shake for plates and Pipette for non-plates *)
					MatchQ[Lookup[options,AliquotContainer], Except[Null|Automatic]],
						If[MatchQ[Lookup[fetchModelPacketFromFastAssoc[FirstCase[Flatten@ToList[Lookup[options, AliquotContainer]], ObjectP[]], fastAssoc], Footprint], Plate],
							Shake,
							Pipette
						],
					(* If the sample will be centrifuged, resolve to Shake since we must be in a plate *)
					MatchQ[aliquotBool, True] && MemberQ[{preLysisPelletBool, clarifyLysateBool}, True],
						Shake,
					(* If we're not done yet, resolve to Shake if solution volume is less than 70% of a theoretical suitable container and resolve to Pipette otherwise *)
					True,
						Module[{currentVolume, suitableContainer, suitableContainerMaxVolume},
							(* Get the total volume at this point, which in this case is the same as the "finalVolume" we estimated for MixType and SecondaryMixType resolutions *)
							currentVolume = Total @ Cases[
								{
									volumeFromDissociateCells, aliquotAmount, -preLysisSupernatantVolume, preLysisDilutionVolume,
									lysisSolutionVolume, secondaryLysisSolutionVolume, tertiaryLysisSolutionVolume
								}, VolumeP
							];
							(* Use PreferredContainer to find a suitable container for this volume *)
							suitableContainer = PreferredContainer[currentVolume, LiquidHandlerCompatible -> True];
							(* Get the maximum volume of the suitable container we found *)
							suitableContainerMaxVolume = Lookup[fetchModelPacketFromFastAssoc[suitableContainer, fastAssoc], MaxVolume];
							(* If the current volume is less than 70% of the volume of the possible suitable container we found, resolve to Shake. Otherwise, Pipette *)
							If[
								MatchQ[currentVolume, LessP[0.70 * suitableContainerMaxVolume]],
								Shake,
								Pipette
							]
						]
				];

				(* Resolve TertiaryMixRate *)
				tertiaryMixRate = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryMixRate], Except[Automatic]],
						Lookup[options,TertiaryMixRate],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryMixRate] && MatchQ[Lookup[methodPacket, TertiaryMixRate], Except[Null]],
						Lookup[methodPacket,TertiaryMixRate],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, TertiaryLysisMixRate],
						!KeyExistsQ[methodPacket, TertiaryMixRate],
						MatchQ[Lookup[methodPacket, TertiaryLysisMixRate], Except[Null]]
					],
						Lookup[methodPacket,TertiaryLysisMixRate],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* If tertiaryMixType is Shake, TertiaryMixRate resolves to 200 RPM *)
					MatchQ[tertiaryMixType, Shake],
						200 RPM,
					(* Else, TertiaryMixRate is Null *)
					True,
						Null
				];

				(* Resolve TertiaryMixTime *)
				tertiaryMixTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryMixTime], Except[Automatic]],
						Lookup[options,TertiaryMixTime],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryMixTime] && MatchQ[Lookup[methodPacket, TertiaryMixTime], Except[Null]],
						Lookup[methodPacket,TertiaryMixTime],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, TertiaryLysisMixTime],
						!KeyExistsQ[methodPacket, TertiaryMixTime],
						MatchQ[Lookup[methodPacket, TertiaryLysisMixTime], Except[Null]]
					],
						Lookup[methodPacket,TertiaryLysisMixTime],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* If tertiaryMixType is Shake, TertiaryMixTime resolves to 1 Minute *)
					MatchQ[tertiaryMixType, Shake],
						1 Minute,
					(* Else, TertiaryMixTime is Null *)
					True,
						Null
				];

				(* Resolve TertiaryMixVolume *)
				tertiaryMixVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryMixVolume], Except[Automatic]],
						Lookup[options,TertiaryMixVolume],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* If tertiaryMixType is not Pipette, TertiaryMixVolume resolves to Null *)
					MatchQ[tertiaryMixType, Except[Pipette]],
						Null,
					(* Else, TertiaryMixVolume is the lesser of: $MaxRoboticSingleTransferVolume or 50% of the total solution volume *)
					True,
						RoundOptionPrecision[Min[
							$MaxRoboticSingleTransferVolume,
							0.50 * Total @ Cases[
								{
									volumeFromDissociateCells,
									If[MatchQ[aliquotAmount, GreaterP[0 Microliter]], aliquotAmount, Lookup[samplePacket, Volume]],
									-preLysisSupernatantVolume,
									preLysisDilutionVolume,
									lysisSolutionVolume,
									secondaryLysisSolutionVolume,
									tertiaryLysisSolutionVolume
								}, VolumeP
							]
						], 10^(-1) Microliter]
				];

				(* Resolve TertiaryNumberOfMixes *)
				tertiaryNumberOfMixes = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryNumberOfMixes], Except[Automatic]],
						Lookup[options,TertiaryNumberOfMixes],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryNumberOfMixes] && MatchQ[Lookup[methodPacket, TertiaryNumberOfMixes], Except[Null]],
						Lookup[methodPacket,TertiaryNumberOfMixes],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, TertiaryNumberOfLysisMixes],
						!KeyExistsQ[methodPacket, TertiaryNumberOfMixes],
						MatchQ[Lookup[methodPacket, TertiaryNumberOfLysisMixes], Except[Null]]
					],
						Lookup[methodPacket,TertiaryNumberOfLysisMixes],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* If the tertiaryMixType is Pipette, default to 10 mixes *)
					MatchQ[tertiaryMixType,Pipette],
						10,
					(* Else, Tertiary number of mixes is Null *)
					True,
						Null
				];

				(* Resolve TertiaryMixTemperature *)
				tertiaryMixTemperature = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryMixTemperature], Except[Automatic]],
						Lookup[options,TertiaryMixTemperature],
					(* Use the LyseCells-Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryMixTemperature] && MatchQ[Lookup[methodPacket, TertiaryMixTemperature], Except[Null]],
						Lookup[methodPacket,TertiaryMixTemperature],
					(* Use the Extraction-Method-specified values, if any *)
					And[
						methodSpecifiedQ,
						KeyExistsQ[methodPacket, TertiaryLysisMixTemperature],
						!KeyExistsQ[methodPacket, TertiaryMixTemperature],
						MatchQ[Lookup[methodPacket, TertiaryLysisMixTemperature], Except[Null]]
					],
						Lookup[methodPacket,TertiaryLysisMixTemperature],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* If the mix type is not Shake, resolve to Null *)
					MatchQ[tertiaryMixType, Except[Shake]],
						Null,
					(* Otherwise, resolve to Ambient *)
					True,
						Ambient
				];

				(* Resolve TertiaryMixInstrument *)
				tertiaryMixInstrument = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryMixInstrument], Except[Automatic]],
						Lookup[options,TertiaryMixInstrument],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* Set to Null if Tertiary MixType is anything but Shake *)
					MatchQ[tertiaryMixType, Except[Shake]],
						Null,
					(* Set to the Inheco ThermoshakeAC if the Tertiary MixRate falls outside the other shaker's RPM range *)
					!MatchQ[tertiaryMixRate, RangeP[
						Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MinRotationRate],
						Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxRotationRate]]
					],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Set to the Inheco ThermoshakeAC if the Tertiary MixTemperature is less than or equal to this shaker's max temperature *)
					MatchQ[tertiaryMixTemperature /. Ambient -> $AmbientTemperature, LessEqualP[Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxTemperature]]],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Set to the Inheco Incubator Shaker if the Tertiary MixTemperature is greater than the on-deck shaker's max temperature *)
					True,
						Model[Instrument, Shaker, "id:eGakldJkWVnz"] (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
				];

				(* Resolve TertiaryLysisTemperature *)
				tertiaryLysisTemperature = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryLysisTemperature], Except[Automatic]],
						Lookup[options,TertiaryLysisTemperature],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryLysisTemperature] && MatchQ[Lookup[methodPacket, TertiaryLysisTemperature], Except[Null]],
						Lookup[methodPacket,TertiaryLysisTemperature],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* Otherwise, resolve to Ambient *)
					True,
						Ambient
				];

				(* Resolve TertiaryLysisTime *)
				tertiaryLysisTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryLysisTime], Except[Automatic]],
						Lookup[options,TertiaryLysisTime],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, TertiaryLysisTime] && MatchQ[Lookup[methodPacket, TertiaryLysisTime], Except[Null]],
						Lookup[methodPacket,TertiaryLysisTime],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* Otherwise, resolve to 15 Minutes *)
					True,
						15 Minute
				];

				(* Resolve TertiaryIncubationInstrument *)
				tertiaryIncubationInstrument = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,TertiaryIncubationInstrument], Except[Automatic]],
						Lookup[options,TertiaryIncubationInstrument],
					(* Resolve to Null if the number of lysis steps is less than 3 *)
					MatchQ[numberOfLysisSteps, (1|2)],
						Null,
					(* Resolve to the integrated heat block if there is no shaking *)
					MatchQ[tertiaryMixType, Except[Shake]],
						Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
					(* If the tertiary lysis temperature is within the temp range of the integrated shaker and it is the resolved tertiary mix instrument, use it for incubation as well *)
					And[
						MatchQ[tertiaryMixInstrument, ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]]], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
						MatchQ[tertiaryLysisTemperature /. Ambient -> $AmbientTemperature, RangeP[
							Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MinTemperature],
							Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Shaker, "id:pZx9jox97qNp"], fastAssoc], MaxTemperature]]]
					],
						Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
					(* Otherwise, just use the heat block *)
					True,
						Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
				];

				(* Resolve maxAliquotContainerVolume to help resolve AliquotContainer after the MapThread *)
				maxAliquotContainerVolume = If[
					MatchQ[aliquotAmount, GreaterP[0 Microliter]],
					Total @ Cases[
						{
							volumeFromDissociateCells, (* TODO update as needed once we can call/simulate DissociateCells *)
							aliquotAmount,
							-preLysisSupernatantVolume,
							preLysisDilutionVolume,
							lysisSolutionVolume,
							secondaryLysisSolutionVolume,
							tertiaryLysisSolutionVolume
						}, VolumeP],
					Null
				];

				(* --- LYSATE CLARIFICATION, except the boolean switch, which comes earlier --- *)

				(* Resolve ClarifyLysateCentrifuge *)
				clarifyLysateCentrifuge = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,ClarifyLysateCentrifuge], Except[Automatic]],
						Lookup[options,ClarifyLysateCentrifuge],
					(* The default HiG4 centrifuge is selected if ClarifyLysate is True *)
					MatchQ[clarifyLysateBool,True],
						Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
					(* Otherwise, there is no clarification and we don't need a centrifuge for it *)
					True,
						Null
				];

				(* Resolve ClarifyLysateIntensity *)
				clarifyLysateIntensity = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,ClarifyLysateIntensity], Except[Automatic]],
						Lookup[options,ClarifyLysateIntensity],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, ClarifyLysateIntensity] && MatchQ[Lookup[methodPacket, ClarifyLysateIntensity], Except[Null]],
						Lookup[methodPacket,ClarifyLysateIntensity],
					(* Default to the max force of the default HiG4 centrifuge if PreLysisPellet is True *)
					MatchQ[clarifyLysateBool,True],
						5700 RPM,
					(* Otherwise, there is no lysate clarification; set intensity to Null *)
					True,
						Null
				];

				(* Resolve ClarifyLysateTime *)
				clarifyLysateTime = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,ClarifyLysateTime], Except[Automatic]],
						Lookup[options,ClarifyLysateTime],
					(* Use the Method-specified values, if any *)
					methodSpecifiedQ && KeyExistsQ[methodPacket, ClarifyLysateTime] && MatchQ[Lookup[methodPacket, ClarifyLysateTime], Except[Null]],
						Lookup[methodPacket,ClarifyLysateTime],
					(* Default to 10 Minutes if ClarifyLysate is True *)
					MatchQ[clarifyLysateBool,True],
						10 Minute,
					(* Otherwise, there is no lysate clarification; set time to Null *)
					True,
						Null
				];

				(* Resolve ClarifiedLysateVolume *)
				clarifiedLysateVolume = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,ClarifiedLysateVolume], Except[Automatic]],
						Lookup[options,ClarifiedLysateVolume],
					(* Default to 90% of the occupied container volume if ClarifyLysate is True *)
					MatchQ[clarifyLysateBool,True],
						0.90 * Total @ Cases[
							{
								volumeFromDissociateCells,
								If[MatchQ[aliquotAmount, GreaterP[0 Microliter]], aliquotAmount, Lookup[samplePacket, Volume]],
								-preLysisSupernatantVolume,
								preLysisDilutionVolume,
								lysisSolutionVolume,
								secondaryLysisSolutionVolume,
								tertiaryLysisSolutionVolume
							}, VolumeP
						],
					(* Otherwise, there is no PreLysisPelleting; set the supernatant volume to Null *)
					True,
						Null
				];

				(* Resolve PostClarificationPelletStorageCondition *)
				postClarificationPelletStorageCondition = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,PostClarificationPelletStorageCondition], Except[Automatic]],
						Lookup[options,PostClarificationPelletStorageCondition],
					(* Default to Disposal if ClarifyLysate is True *)
					MatchQ[clarifyLysateBool,True],
						Disposal,
					(* Otherwise, there is no lysate clarification; set the pellet storage condition to Null *)
					True,
						Null
				];

				(* Resolve SamplesOutStorageCondition *)
				samplesOutStorageCondition = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options,SamplesOutStorageCondition], Except[Automatic]],
						Lookup[options,SamplesOutStorageCondition],
					(* Otherwise, set the sample storage condition to Freezer *)
					True,
						Freezer
				];

				(* Pre-resolve SampleOutLabel; we expand this for NumberOfReplicates after the MapThread *)
				sampleOutLabel = Which[
					(* Use the user-specified label, if any *)
					MatchQ[Lookup[options, SampleOutLabel], Except[Null|Automatic]],
						Lookup[options, SampleOutLabel],
					(* Otherwise, make a new label for this sample *)
					True,
						CreateUniqueLabel["lyse cells sample out", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
				];

				(* Pre-resolve preLysisSupernatantLabel; we expand this for NumberOfReplicates after the MapThread *)
				preLysisSupernatantLabel = Which[
					(* Use the user-specified label, if any *)
					MatchQ[Lookup[options, PreLysisSupernatantLabel], Except[Null|Automatic]],
						Lookup[options, PreLysisSupernatantLabel],
					(* If the label is not user-specified but PreLysisPellet is True, make a new label for this sample *)
					MatchQ[preLysisPelletBool, True],
						CreateUniqueLabel["lyse cells pre lysis supernatant", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
					(* Otherwise, set this to Null *)
					True,
						Null
				];

				(* Pre-resolve postClarificationPelletLabel; we expand this for NumberOfReplicates after the MapThread *)
				postClarificationPelletLabel = Which[
					(* Use the user-specified label, if any *)
					MatchQ[Lookup[options, PostClarificationPelletLabel], Except[Null|Automatic]],
						Lookup[options, PostClarificationPelletLabel],
					(* If the label is not user-specified but ClarifyLysate is True, make a new label for this sample *)
					MatchQ[clarifyLysateBool, True],
						CreateUniqueLabel["lyse cells post clarification pellet", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
					(* Otherwise, set this to Null *)
					True,
						Null
				];

				{
					method,
					cellCountAccessibleComposition, (* internal variable for resolving *)
					cellConcentrationAccessibleComposition, (* internal variable for resolving *)
					cellCountAvailableQ, (* internal variable for resolving *)
					cellConcentrationAvailableQ, (* internal variable for resolving *)
					cellType, unknownCellTypeQ,
					targetCellularComponent,
					cultureAdhesion, unknownCultureAdhesionQ,
					numberOfLysisSteps,
					aliquotBool,
					aliquotAmount,
					dissociateBool,
					preLysisPelletBool, pelletingForcedQ,
					preLysisPelletingCentrifuge,
					preLysisPelletingIntensity,
					preLysisPelletingTime,
					preLysisSupernatantVolume,
					preLysisSupernatantStorageCondition,
					preLysisDiluteBool,
					preLysisDiluent,
					preLysisDilutionVolume,
					targetCellCount,
					targetCellConcentration,
					lysisSolution,
					lysisSolutionVolume,
					mixType,
					mixRate,
					mixTime,
					mixVolume,
					numberOfMixes,
					mixTemperature,
					mixInstrument,
					lysisTemperature,
					lysisTime,
					incubationInstrument,
					secondaryLysisSolution,
					secondaryLysisSolutionVolume,
					secondaryMixType,
					secondaryMixRate,
					secondaryMixTime,
					secondaryMixVolume,
					secondaryNumberOfMixes,
					secondaryMixTemperature,
					secondaryMixInstrument,
					secondaryLysisTemperature,
					secondaryLysisTime,
					secondaryIncubationInstrument,
					tertiaryLysisSolution,
					tertiaryLysisSolutionVolume,
					tertiaryMixType,
					tertiaryMixRate,
					tertiaryMixTime,
					tertiaryMixVolume,
					tertiaryNumberOfMixes,
					tertiaryMixTemperature,
					tertiaryMixInstrument,
					tertiaryLysisTemperature,
					tertiaryLysisTime,
					tertiaryIncubationInstrument,
					maxAliquotContainerVolume,
					clarifyLysateBool,
					clarifyLysateCentrifuge,
					clarifyLysateIntensity,
					clarifyLysateTime,
					clarifiedLysateVolume,
					postClarificationPelletStorageCondition,
					samplesOutStorageCondition,
					sampleOutLabel,
					preLysisSupernatantLabel,
					postClarificationPelletLabel
				}
			]
		],
		{samplePackets, sampleContainerModelPackets, mapThreadFriendlyOptions}
	];

	(* Take the container inputs and separate the wells from the indices and containers *)
  {aliquotContainersWithWellsRemoved, preLysisSupernatantContainersWithWellsRemoved, clarifiedLysateContainersWithWellsRemoved} = Map[
    Function[{index},
      Which[
        (* If the user specified AliquotContainer using the "Container with Well" widget format, remove the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Model[Container]}]}],
          Last[index],
        (* If the user specified AliquotContainer using the "Container with Well and Index" widget format, remove the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Model[Container]}]}}],
          Last[index],
        (* If the user specified AliquotContainer any other way, we don't have to mess with it here. *)
        True,
          index
      ]
    ], #
  ]& /@ Lookup[listedOptions, {AliquotContainer, PreLysisSupernatantContainer, ClarifiedLysateContainer}];

  {wellsFromAliquotContainers, wellsFromPreLysisSupernatantContainers, wellsFromClarifiedLysateContainers} = Map[
    Function[{index},
      Which[
        (* If the user specified AliquotContainer using the "Container with Well" widget format, extract the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Model[Container]}]}],
          First[index],
        (* If the user specified AliquotContainer using the "Container with Well and Index" widget format, extract the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Model[Container]}]}}],
          First[index],
        (* Otherwise, there isn't a well specified and we set this to automatic. *)
        True,
          Automatic
      ]
    ], #
  ]& /@ Lookup[listedOptions, {AliquotContainer, PreLysisSupernatantContainer, ClarifiedLysateContainer}];

	(* Replace all Nulls in the NumberOfReplicates option with 1 *)
	numberOfReplicatesNoNull = resolvedNumberOfReplicates /. Null -> 1;

	(* Determine whether aliquoting into a plate is necessary at each index *)
	aliquotContainerPlateRequiredQ = AliquotIntoPlateQ[
		Lookup[listedOptions, AliquotContainer],
		resolvedAliquotBools,
		{resolvedPreLysisPelletBools, resolvedClarifyLysateBools},
		{resolvedMixTypes, resolvedSecondaryMixTypes, resolvedTertiaryMixTypes},
		{
			resolvedMixTemperatures, resolvedSecondaryMixTemperatures, resolvedTertiaryMixTemperatures,
			resolvedLysisTemperatures, resolvedSecondaryLysisTemperatures, resolvedTertiaryLysisTemperatures
		}
	];

	(* Resolve AliquotContainer and AliquotContainerWell. *)
	{resolvedAliquotContainers, resolvedAliquotContainerWells} = PackContainers[
		Lookup[listedOptions, AliquotContainer],
		aliquotContainerPlateRequiredQ,
		resolvedMaxAliquotContainerVolumes,
		{
			resolvedPreLysisPelletBools,
			resolvedPreLysisPelletingCentrifuges,
			resolvedPreLysisPelletingIntensities,
			resolvedPreLysisPelletingTimes,
			resolvedMixTypes,
			resolvedSecondaryMixTypes,
			resolvedTertiaryMixTypes,
			resolvedMixRates,
			resolvedSecondaryMixRates,
			resolvedTertiaryMixRates,
			resolvedMixTimes,
			resolvedSecondaryMixTimes,
			resolvedTertiaryMixTimes,
			resolvedMixTemperatures,
			resolvedSecondaryMixTemperatures,
			resolvedTertiaryMixTemperatures,
			resolvedMixInstruments,
			resolvedSecondaryMixInstruments,
			resolvedTertiaryMixInstruments,
			resolvedLysisTimes,
			resolvedSecondaryLysisTimes,
			resolvedTertiaryLysisTimes,
			resolvedLysisTemperatures,
			resolvedSecondaryLysisTemperatures,
			resolvedTertiaryLysisTemperatures,
			resolvedIncubationInstruments,
			resolvedSecondaryIncubationInstruments,
			resolvedTertiaryIncubationInstruments,
			resolvedClarifyLysateBools,
			resolvedClarifyLysateCentrifuges,
			resolvedClarifyLysateIntensities,
			resolvedClarifyLysateTimes,
			resolvedPostClarificationPelletStorageConditions (* since the AliquotContainer becomes the PostClarificationPelletContainer *)
		},
		NumberOfReplicates -> numberOfReplicatesNoNull,
		FirstNewContainerIndex -> (Max[{
			0,
			Cases[Flatten[Lookup[listedOptions, {AliquotContainer, PreLysisSupernatantContainer, ClarifiedLysateContainer}]], _Integer]
		}] + 1),
		Sterile -> True,
		LiquidHandlerCompatible -> True
	];

	(* Resolve the hidden options postClarificationPelletContainer and postClarificationPelletContainerWell *)
	{resolvedPostClarificationPelletContainers, resolvedPostClarificationPelletContainerWells} = Module[
		{expandedSamplePackets, expandedClarifyLysateBools, expandedAliquotBools},

		(* Expand the resolved options and sample packets that we need the group the samples according to the number of replicates *)
		{
			expandedSamplePackets,
			expandedClarifyLysateBools,
			expandedAliquotBools
		} = Map[
			Flatten[
				Map[
					Function[{indexMatchedItem},
						ConstantArray[indexMatchedItem, numberOfReplicatesNoNull]
					],
					#
				], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
			]&,
			{
				samplePackets,
				resolvedClarifyLysateBools,
				resolvedAliquotBools
			}
		];

		Transpose @ MapThread[
			Function[{clarifyLysateBool, aliquotBool, aliquotContainer, aliquotContainerWell, samplePacket},
				Which[
					(* If ClarifyLysate is False, set both the container and the well to Null *)
					MatchQ[clarifyLysateBool, False],
						{Null, Null},
					(* If ClarifyLysate is True and Aliquot is True, set the container and well to match *)
					MatchQ[clarifyLysateBool, True] && MatchQ[aliquotBool, True],
						{aliquotContainer, aliquotContainerWell},
					(* If ClarifyLysate is True and Aliquot is False, set the container and well to match that of the input sample *)
					MatchQ[clarifyLysateBool, True] && MatchQ[aliquotBool, False],
						{LinkedObject @ Lookup[samplePacket, Container], Lookup[samplePacket, Position]}
				]
			],
			{expandedClarifyLysateBools, expandedAliquotBools, resolvedAliquotContainers, resolvedAliquotContainerWells, expandedSamplePackets}
		]
	];

	(* Resolve PreLysisSupernatantContainers. Note that the solution is transferred into these containers following *)
	(* centrifugation, so it is invariably coming out of some kind of plate. *)
	{resolvedPreLysisSupernatantContainers, resolvedPreLysisSupernatantContainerWells} = Module[
		{
			expandedPreLysisSupernatantContainersWithWellsRemoved, expandedWellsFromPreLysisSupernatantContainers, expandedPreLysisSupernatantVolumes,
			expandedPreLysisPelletBools, expandedPreLysisSupernatantStorageConditions, highestUserSpecifiedContainerIndexPlusResolvedAliquotContainerIndices, supernatantDisposalSampleIndices,
			preLysisSupernatantVolumesForDisposal, preLysisSupernatantContainersForDisposal,
			semiResolvedPreLysisSupernatantContainers, semiResolvedPreLysisSupernatantContainerWells,
			preLysisSupernatantContainerToAvailableWellsLookup
		},

		(* Expand the resolved options that we need the group the samples according to the number of replicates *)
		{
			expandedPreLysisSupernatantContainersWithWellsRemoved,
			expandedPreLysisSupernatantVolumes,
			expandedPreLysisPelletBools,
			expandedPreLysisSupernatantStorageConditions
		} = Map[
			Flatten[
				Map[
					Function[{indexMatchedItem},
						ConstantArray[indexMatchedItem, numberOfReplicatesNoNull]
					],
					#
				], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
			]&,
			{
				preLysisSupernatantContainersWithWellsRemoved,
				resolvedPreLysisSupernatantVolumes,
				resolvedPreLysisPelletBools,
				resolvedPreLysisSupernatantStorageConditions
			}
		];

		(* Expand wells to make the replicated wells Automatic *)
		expandedWellsFromPreLysisSupernatantContainers = Flatten[PadRight[{#}, numberOfReplicatesNoNull, Automatic] & /@ wellsFromPreLysisSupernatantContainers];

		(* Get the highest integer either specified by the user or resolved for AliquotContainer. *)
		highestUserSpecifiedContainerIndexPlusResolvedAliquotContainerIndices = Max[{
			0,
			Cases[Flatten[Join[{0},{resolvedAliquotContainers}, Lookup[listedOptions, {PreLysisSupernatantContainer, ClarifiedLysateContainer}]]], _Integer]
		}];

		(* Get all the samples for which the supernatant's storage condition is set to Disposal *)
		supernatantDisposalSampleIndices = Flatten @ Position[
			Transpose[
				{
					expandedPreLysisSupernatantContainersWithWellsRemoved,
					expandedPreLysisSupernatantVolumes,
					expandedPreLysisPelletBools,
					expandedPreLysisSupernatantStorageConditions
				}
			],
			{
				Automatic,
				VolumeP,
				True,
				Disposal
			}
		];

		(* For each sample index that we're going to pre-resolve PreLysisSupernatantContainer, get the volumes. *)
		preLysisSupernatantVolumesForDisposal = Map[
			Function[{sampleIndex},
				Extract[expandedPreLysisSupernatantVolumes, sampleIndex]
			],
			supernatantDisposalSampleIndices
		] /. {} -> 0 Microliter;

		(* Resolve the containers into which the supernatant will be transferred *)
		preLysisSupernatantContainersForDisposal = Which[
			(* If there are no supernatants which will be disposed of, just return an empty list. *)
			MatchQ[supernatantDisposalSampleIndices, {}],
				{},
			(* If the total volume of these supernatants is less than 50 mL, combine them into the smallest Hamilton compatible tube that can fit the volume. *)
			MatchQ[Total@preLysisSupernatantVolumesForDisposal, LessP[50 Milliliter]],
				ConstantArray[
					{(highestUserSpecifiedContainerIndexPlusResolvedAliquotContainerIndices + 1), PreferredContainer[Total@preLysisSupernatantVolumesForDisposal, LiquidHandlerCompatible -> True]},
					Length[supernatantDisposalSampleIndices]
				],
			(* Otherwise, run PreferredContainer with type -> Plate since this gives us access to much larger containers *)
			True,
				ConstantArray[
					{(highestUserSpecifiedContainerIndexPlusResolvedAliquotContainerIndices + 1), PreferredContainer[Total@preLysisSupernatantVolumesForDisposal, LiquidHandlerCompatible -> True, Type -> Plate]},
					Length[supernatantDisposalSampleIndices]
				]
		];

		semiResolvedPreLysisSupernatantContainers = ReplacePart[
			expandedPreLysisSupernatantContainersWithWellsRemoved,
			Rule@@@Transpose[{
				supernatantDisposalSampleIndices,
				preLysisSupernatantContainersForDisposal
			}]
		];

		(* Set the well to A1 for all supernatants which are designated for disposal, since these go into tubes or large plates *)
		semiResolvedPreLysisSupernatantContainerWells = ReplacePart[
			expandedWellsFromPreLysisSupernatantContainers,
			Rule@@@Transpose[{
				supernatantDisposalSampleIndices,
				ConstantArray["A1", Length[supernatantDisposalSampleIndices]]
			}]
		];

		(* Keep track of any wells that we use when packing the container in case the user gave us the container option *)
		(* but no wells. *)
		preLysisSupernatantContainerToAvailableWellsLookup = Module[
			{groupedPreLysisSupernatantContainersToWells},
			(* Find the wells of each container we are given *)
			groupedPreLysisSupernatantContainersToWells = GroupBy[Transpose[{semiResolvedPreLysisSupernatantContainers, semiResolvedPreLysisSupernatantContainerWells}], First -> Last];

			Association @ KeyValueMap[
				Function[{preLysisSupernatantContainer, specifiedWells},
					Which[
						MatchQ[preLysisSupernatantContainer, ObjectP[Object[Container]]],
							Module[{allWells, transposedWells, occupiedWells, specifiedWellsNoAutomatic},
								(* Remove all of the Automatics *)
								specifiedWellsNoAutomatic = Cases[specifiedWells, WellPositionP];
								(* Get all the wells of the container *)
								allWells = Lookup[Lookup[fetchModelPacketFromFastAssoc[preLysisSupernatantContainer, fastAssoc], Positions], Name];
								(* Transpose the wells so that we occupy them column-wise *)
								transposedWells = If[
									MatchQ[allWells, Flatten[AllWells[]]],
									Flatten[Transpose[AllWells[]]],
									allWells
								];

								occupiedWells = Lookup[fetchPacketFromFastAssoc[preLysisSupernatantContainer, fastAssoc], Contents][[All,1]];

								preLysisSupernatantContainer -> UnsortedComplement[transposedWells, Join[occupiedWells, specifiedWellsNoAutomatic]]
							],
						MatchQ[preLysisSupernatantContainer, {_Integer, ObjectP[Model[Container]]}],
							Module[{allWells, transposedWells, specifiedWellsNoAutomatic},
								(* Remove all of the Automatics *)
								specifiedWellsNoAutomatic = Cases[specifiedWells, WellPositionP];
								(* Get all the wells of the container *)
								allWells = Lookup[Lookup[fetchPacketFromFastAssoc[preLysisSupernatantContainer[[2]], fastAssoc], Positions], Name];
								(* Transpose the wells so that we occupy them column-wise *)
								transposedWells = If[
									MatchQ[allWells, Flatten[AllWells[]]],
									Flatten[Transpose[AllWells[]]],
									allWells
								];

								preLysisSupernatantContainer -> UnsortedComplement[transposedWells, specifiedWellsNoAutomatic]
							],
						True,
							Nothing
					]
				],
				groupedPreLysisSupernatantContainersToWells
			]
		];

		(* Resolve the container and well options for all other cases. *)
		Transpose@MapThread[
			Function[{preLysisSupernatantContainer, preLysisSupernatantContainerWell, preLysisPelletBool, preLysisSupernatantVolume},
				Which[
					(* If the user specifies both the container and the well, use the specified Container and Well *)
					MatchQ[preLysisSupernatantContainer, Except[Automatic]] && MatchQ[preLysisSupernatantContainerWell, Except[Automatic]],
						{preLysisSupernatantContainer, preLysisSupernatantContainerWell},
					(* If the user sets the container to Null, set both container and well to Null *)
					MatchQ[preLysisSupernatantContainer, Null],
						{Null, Null},
					(* If the sample is not being pelleted, set both preLysisSupernatantContainer and preLysisSupernatantContainerWell to Null *)
					MatchQ[preLysisPelletBool, False],
						{Null, Null},
					(* If the user specifies a new container, default to well "A1". *)
					MatchQ[preLysisSupernatantContainer, ObjectP[Model[Container]]],
						{preLysisSupernatantContainer, "A1"},
					(* If the user specifies a tube with Well set to Automatic, use the specified Container and default to A1 *)
					MatchQ[preLysisSupernatantContainer, {_Integer, ObjectP[Model[Container, Vessel]]}] && MatchQ[preLysisSupernatantContainerWell, Automatic],
						{preLysisSupernatantContainer, "A1"},
					(* If the user specifies a container but not a well, find the next available well as follows *)
					MatchQ[preLysisSupernatantContainer, Except[Automatic]] && MatchQ[preLysisSupernatantContainerWell, Automatic],
						Module[{availableWells},
							(* Get the available wells. *)
							availableWells = Lookup[preLysisSupernatantContainerToAvailableWellsLookup, Key[preLysisSupernatantContainer]];

							(* Update the lookup, if there are no longer any wells left, use the standard well list. *)
							preLysisSupernatantContainerToAvailableWellsLookup[preLysisSupernatantContainer] = RestOrDefault[availableWells, Flatten[Transpose[AllWells[]]]];

							{preLysisSupernatantContainer, FirstOrDefault[availableWells, "A1"]}
						],
					(* Just use a liquid handler compatible vessel. *)
					True,
						{
							PreferredContainer[preLysisSupernatantVolume, LiquidHandlerCompatible -> True],
							"A1"
						}
					]
			],
			{
				semiResolvedPreLysisSupernatantContainers,
				semiResolvedPreLysisSupernatantContainerWells,
				expandedPreLysisPelletBools,
				expandedPreLysisSupernatantVolumes
			}
		]
	];

	(* Find all indices at which a plate is specified for ClarifiedLysateContainer. *)
	(* The ClarifiedLysateContainer will just resolve to a tube if the user doesn't specify a plate object or model. *)
	clarifiedLysateContainerPackPlateQ = If[
		MemberQ[Flatten@ToList[#], ObjectP[{Model[Container, Plate], Object[Container, Plate]}]],
		True,
		False
	] & /@ Lookup[listedOptions, ClarifiedLysateContainer];

	(* Resolve ClarifiedLysateContainer and ClarifiedLysateContainerWell for all samples. *)
	{resolvedClarifiedLysateContainers, resolvedClarifiedLysateContainerWells} = PackContainers[
		Lookup[listedOptions, ClarifiedLysateContainer],
		clarifiedLysateContainerPackPlateQ,
		resolvedClarifiedLysateVolumes,
		resolvedSamplesOutStorageConditions,
		NumberOfReplicates -> numberOfReplicatesNoNull,
		FirstNewContainerIndex -> (Max[{
			0,
			Cases[Flatten[Join[{0},{resolvedAliquotContainers, resolvedPreLysisSupernatantContainers}, Lookup[listedOptions, ClarifiedLysateContainer]]], _Integer]
		}] + 1),
		LiquidHandlerCompatible -> True,
		Sterile -> True
	];

	(* RESOLVE LABELS *)

	(* Resolve our SampleOut labels. *)
	resolvedSampleOutLabels = Module[
		{expandedSampleOutLabels},

		(* Expand the sample out labels according to the number of replicates *)
		expandedSampleOutLabels = Flatten[Map[
			ConstantArray[#, numberOfReplicatesNoNull]&,
			preResolvedSampleOutLabels
		]];

		(* If number of replicates is not Null, update the labels to reflect "replicate" status *)
		If[
			MatchQ[numberOfReplicatesNoNull, 1],
			preResolvedSampleOutLabels,
			(* The following converts "this sample label" to "this sample label replicate 1", "this sample label replicate 2", "this sample label replicate 3"... *)
			MapThread[
				Function[{sampleLabel, replicateNumber},
					(sampleLabel <> " replicate " <> ToString[replicateNumber])
				],
				{expandedSampleOutLabels, Flatten[ConstantArray[Range[numberOfReplicatesNoNull], Length[preResolvedSampleOutLabels]]]}
			]
		]
	];

	(* Resolve our PostClarificationPellet labels. *)
	resolvedPostClarificationPelletLabels = Module[
		{expandedPostClarificationPelletLabels},

		(* Expand the sample out labels according to the number of replicates *)
		expandedPostClarificationPelletLabels = Flatten[Map[
			ConstantArray[#, numberOfReplicatesNoNull]&,
			preResolvedPostClarificationPelletLabels
		]];

		(* If number of replicates is not Null, update the labels to reflect "replicate" status *)
		If[
			MatchQ[numberOfReplicatesNoNull, 1],
			preResolvedPostClarificationPelletLabels,
			(* The following converts "this sample label" to "this sample label replicate 1", "this sample label replicate 2", "this sample label replicate 3"... *)
			MapThread[
				Function[{sampleLabel, replicateNumber},
					Which[
						(* If the label is Null, just keep it *)
						MatchQ[sampleLabel, Null],
							sampleLabel,
						(* Otherwise, designate it as a replicate *)
						True,
							(sampleLabel <> " replicate " <> ToString[replicateNumber])
						]
				],
				{expandedPostClarificationPelletLabels, Flatten[ConstantArray[Range[numberOfReplicatesNoNull], Length[preResolvedPostClarificationPelletLabels]]]}
			]
		]
	];

	(* Resolve PostClarificationPelletContainer Labels *)
	resolvedPostClarificationPelletContainerLabels = Module[
		{expandedPostClarificationPelletContainerLabels, expandedClarifyLysateBools, containersToGroupedLabels, containersToUserSpecifiedLabels, preResolvedPostClarificationPelletContainerLabels},

		(* Expand the resolved options that we need to group the samples according to the number of replicates *)
		{expandedPostClarificationPelletContainerLabels, expandedClarifyLysateBools} = Map[
			Flatten[
				Map[
					Function[{indexMatchedItem},
						ConstantArray[indexMatchedItem, numberOfReplicatesNoNull]
					],
					#
				], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
			]&,
			{Lookup[listedOptions, PostClarificationPelletContainerLabel], resolvedClarifyLysateBools}
		];

		(* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
		containersToGroupedLabels = GroupBy[
			Rule@@@Transpose[{resolvedPostClarificationPelletContainers, expandedPostClarificationPelletContainerLabels}],
			First -> Last
		];

		(* Model[Container]s are unique containers and therefore don't need shared labels. *)
		containersToUserSpecifiedLabels = (#[[1]] -> FirstCase[#[[2]], _String, Null]&) /@ Normal[containersToGroupedLabels];

		preResolvedPostClarificationPelletContainerLabels = MapThread[
			Function[{postClarificationPelletContainer, userSpecifiedLabel, clarifyLysateBool},
				Which[
					(* If we're not clarifying the lysate, we don't produce a pellet and we don't need a container label *)
					MatchQ[clarifyLysateBool, False],
						Null,
					(* User specified the option. *)
					MatchQ[userSpecifiedLabel, _String],
						userSpecifiedLabel,
					(* All Model[Container]s are unique. *)
					MatchQ[postClarificationPelletContainer, ObjectP[Model[Container]]],
						CreateUniqueLabel["lyse cells post clarification pellet container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
					(* User specified the option for another index and ClarifyLysate is True. *)
					MatchQ[Lookup[containersToUserSpecifiedLabels, Key[postClarificationPelletContainer]], _String],
						Lookup[containersToUserSpecifiedLabels, Key[postClarificationPelletContainer]],
					(* We need to make a new label for this object. *)
					True,
						Module[{},
							containersToUserSpecifiedLabels = ReplaceRule[
								containersToUserSpecifiedLabels,
								postClarificationPelletContainer -> CreateUniqueLabel["lyse cells post clarification pellet container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
							];

							Lookup[containersToUserSpecifiedLabels, Key[postClarificationPelletContainer]]
						]
				]
			],
			{resolvedPostClarificationPelletContainers, expandedPostClarificationPelletContainerLabels, expandedClarifyLysateBools}
		]
	];

	(* Resolve ClarifiedLysateContainer Labels *)
	resolvedAliquotContainerLabels = Module[
		{expandedAliquotContainerLabels, expandedAliquotBools, aliquotContainersToGroupedLabels, aliquotContainersToUserSpecifiedLabels, preResolvedAliquotContainerLabels},

		(* Expand the resolved options that we need to group the samples according to the number of replicates *)
		{expandedAliquotContainerLabels, expandedAliquotBools} = Map[
			Flatten[
				Map[
					Function[{indexMatchedItem},
						ConstantArray[indexMatchedItem, numberOfReplicatesNoNull]
					],
					#
				], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
			]&,
			{Lookup[listedOptions, AliquotContainerLabel], resolvedAliquotBools}
		];

		(* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
		aliquotContainersToGroupedLabels = GroupBy[
			Rule@@@Transpose[{resolvedAliquotContainers, expandedAliquotContainerLabels}],
			First -> Last
		];

		(* Model[Container]s are unique containers and therefore don't need shared labels. *)
		aliquotContainersToUserSpecifiedLabels = (#[[1]] -> FirstCase[#[[2]], _String, Null]&) /@ Normal[aliquotContainersToGroupedLabels];

		preResolvedAliquotContainerLabels = MapThread[
			Function[{aliquotContainer, userSpecifiedLabel, aliquotBool},
				Which[
					(* If we're not aliquoting, we don't need to label the aliquot container. *)
					MatchQ[aliquotBool, False],
						Null,
					(* User specified the option. *)
					MatchQ[userSpecifiedLabel, _String],
						userSpecifiedLabel,
					(* All Model[Container]s are unique. *)
					MatchQ[aliquotContainer, ObjectP[Model[Container]]],
						CreateUniqueLabel["lyse cells aliquot container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
					(* User specified the option for another index. *)
					MatchQ[Lookup[aliquotContainersToUserSpecifiedLabels, Key[aliquotContainer]], _String],
						Lookup[aliquotContainersToUserSpecifiedLabels, Key[aliquotContainer]],
					(* We need to make a new label for this object. *)
					True,
						Module[{},
							aliquotContainersToUserSpecifiedLabels = ReplaceRule[
								aliquotContainersToUserSpecifiedLabels,
								aliquotContainer -> CreateUniqueLabel["lyse cells aliquot container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
							];

							Lookup[aliquotContainersToUserSpecifiedLabels, Key[aliquotContainer]]
						]
				]
			],
			{resolvedAliquotContainers, expandedAliquotContainerLabels, expandedAliquotBools}
		]
	];

	(* Resolve ClarifiedLysateContainer Labels *)
	resolvedClarifiedLysateContainerLabels = Module[
		{expandedClarifiedLysateContainerLabels, expandedClarifyLysateBools, clarifiedLysateContainersToGroupedLabels, clarifiedLysateContainersToUserSpecifiedLabels, preResolvedClarifiedLysateContainerLabels},

		(* Expand the resolved options that we need to group the samples according to the number of replicates *)
		{expandedClarifiedLysateContainerLabels, expandedClarifyLysateBools} = Map[
			Flatten[
				Map[
					Function[{indexMatchedItem},
						ConstantArray[indexMatchedItem, numberOfReplicatesNoNull]
					],
					#
				], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
			]&,
			{Lookup[listedOptions, ClarifiedLysateContainerLabel], resolvedClarifyLysateBools}
		];

		(* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
		clarifiedLysateContainersToGroupedLabels = GroupBy[
			Rule@@@Transpose[{resolvedClarifiedLysateContainers, expandedClarifiedLysateContainerLabels}],
			First -> Last
		];

		(* Model[Container]s are unique containers and therefore don't need shared labels. *)
		clarifiedLysateContainersToUserSpecifiedLabels = (#[[1]] -> FirstCase[#[[2]], _String, Null]&) /@ Normal[clarifiedLysateContainersToGroupedLabels];

		preResolvedClarifiedLysateContainerLabels = MapThread[
			Function[{clarifiedLysateContainer, userSpecifiedLabel, clarifyLysateBool},
				Which[
					(* If we're not clarifying the lysate, we don't need to label its destination container. *)
					MatchQ[clarifyLysateBool, False],
						Null,
					(* User specified the option. *)
					MatchQ[userSpecifiedLabel, _String],
						userSpecifiedLabel,
					(* All Model[Container]s are unique. *)
					MatchQ[clarifiedLysateContainer, ObjectP[Model[Container]]],
						CreateUniqueLabel["lyse cells clarified lysate container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
					(* User specified the option for another index. *)
					MatchQ[Lookup[clarifiedLysateContainersToUserSpecifiedLabels, Key[clarifiedLysateContainer]], _String],
						Lookup[clarifiedLysateContainersToUserSpecifiedLabels, Key[clarifiedLysateContainer]],
					(* If the lysate is to be clarified at this index, we need to make a new label for this object. *)
					True,
						Module[{},
							clarifiedLysateContainersToUserSpecifiedLabels = ReplaceRule[
								clarifiedLysateContainersToUserSpecifiedLabels,
								clarifiedLysateContainer -> CreateUniqueLabel["lyse cells clarified lysate container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
							];

							Lookup[clarifiedLysateContainersToUserSpecifiedLabels, Key[clarifiedLysateContainer]]
						]
				]
			],
			{resolvedClarifiedLysateContainers, expandedClarifiedLysateContainerLabels, expandedClarifyLysateBools}
		]
	];

	(* Resolve our PreLysisSupernatant labels. *)
	resolvedPreLysisSupernatantLabels = Module[
		{expandedPreLysisSupernatantLabels},

		(* Expand the sample out labels according to the number of replicates *)
		expandedPreLysisSupernatantLabels = Flatten[Map[
			ConstantArray[#, numberOfReplicatesNoNull]&,
			preResolvedPreLysisSupernatantLabels
		]];

		(* If number of replicates is not Null, update the labels to reflect "replicate" status *)
		If[
			MatchQ[numberOfReplicatesNoNull, 1],
			preResolvedPreLysisSupernatantLabels,
			(* The following converts "this sample label" to "this sample label replicate 1", "this sample label replicate 2", "this sample label replicate 3"... *)
			MapThread[
				Function[{sampleLabel, replicateNumber},
					Which[
						(* If the label is Null, just keep it *)
						MatchQ[sampleLabel, Null],
							sampleLabel,
						(* Otherwise, designate it as a replicate *)
						True,
							(sampleLabel <> " replicate " <> ToString[replicateNumber])
					]
				],
				{expandedPreLysisSupernatantLabels, Flatten[ConstantArray[Range[numberOfReplicatesNoNull], Length[preResolvedPreLysisSupernatantLabels]]]}
			]
		]
	];

	(* Resolve PreLysisSupernatantContainer Labels *)
	resolvedPreLysisSupernatantContainerLabels = Module[
		{expandedPreLysisSupernatantContainerLabels, expandedPreLysisPelletBools, containersToGroupedLabels, containersToUserSpecifiedLabels, preResolvedPreLysisSupernatantContainerLabels},

		(* Expand the resolved options that we need to group the samples according to the number of replicates *)
		{expandedPreLysisSupernatantContainerLabels, expandedPreLysisPelletBools} = Map[
			Flatten[
				Map[
					Function[{indexMatchedItem},
						ConstantArray[indexMatchedItem, numberOfReplicatesNoNull]
					],
					#
				], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
			]&,
			{Lookup[listedOptions, PreLysisSupernatantContainerLabel], resolvedPreLysisPelletBools}
		];

		(* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
		containersToGroupedLabels = GroupBy[
			Rule@@@Transpose[{resolvedPreLysisSupernatantContainers, expandedPreLysisSupernatantContainerLabels}],
			First -> Last
		];

		(* Model[Container]s are unique containers and therefore don't need shared labels. *)
		containersToUserSpecifiedLabels = (#[[1]] -> FirstCase[#[[2]], _String, Null]&) /@ Normal[containersToGroupedLabels];

		preResolvedPreLysisSupernatantContainerLabels = MapThread[
			Function[{preLysisSupernatantContainer, userSpecifiedLabel, preLysisPelletBool},
				Which[
					(* If we're not pelleting prior to lysis, we don't produce a pellet and we don't need a container label *)
					MatchQ[expandedPreLysisPelletBools, False],
						Null,
					(* User specified the option. *)
					MatchQ[userSpecifiedLabel, _String],
						userSpecifiedLabel,
					(* All Model[Container]s are unique. *)
					MatchQ[preLysisSupernatantContainer, ObjectP[Model[Container]]],
						CreateUniqueLabel["lyse cells pre lysis supernatant container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
					(* User specified the option for another index and PreLysisPellet is True. *)
					MatchQ[Lookup[containersToUserSpecifiedLabels, Key[preLysisSupernatantContainer]], _String] && preLysisPelletBool,
						Lookup[containersToUserSpecifiedLabels, Key[preLysisSupernatantContainer]],
					(* We need to make a new label for this object. *)
					preLysisPelletBool,
						Module[{},
							containersToUserSpecifiedLabels = ReplaceRule[
								containersToUserSpecifiedLabels,
								preLysisSupernatantContainer -> CreateUniqueLabel["lyse cells pre lysis supernatant container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
							];

							Lookup[containersToUserSpecifiedLabels, Key[preLysisSupernatantContainer]]
						]
				]
			],
			{resolvedPreLysisSupernatantContainers, expandedPreLysisSupernatantContainerLabels, expandedPreLysisPelletBools}
		]
	];

	(* Define contracted variants of the options that we expanded for number of replicates; we need these for tests and messages *)
	contractedResolvedAliquotContainers = resolvedAliquotContainers[[1 ;; -1 ;; numberOfReplicatesNoNull]];
	contractedResolvedAliquotContainerWells = resolvedAliquotContainerWells[[1 ;; -1 ;; numberOfReplicatesNoNull]];
	contractedResolvedPostClarificationPelletContainers = resolvedPostClarificationPelletContainers[[1 ;; -1 ;; numberOfReplicatesNoNull]];
	contractedResolvedPostClarificationPelletContainerWells = resolvedPostClarificationPelletContainerWells[[1 ;; -1 ;; numberOfReplicatesNoNull]];
	contractedResolvedPreLysisSupernatantContainers = resolvedPreLysisSupernatantContainers[[1 ;; -1 ;; numberOfReplicatesNoNull]];
	contractedResolvedPreLysisSupernatantContainerWells = resolvedPreLysisSupernatantContainerWells[[1 ;; -1 ;; numberOfReplicatesNoNull]];
	contractedResolvedClarifiedLysateContainers = resolvedClarifiedLysateContainers[[1 ;; -1 ;; numberOfReplicatesNoNull]];
	contractedResolvedClarifiedLysateContainerWells = resolvedClarifiedLysateContainerWells[[1 ;; -1 ;; numberOfReplicatesNoNull]];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions,Sterile->True];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[Lookup[myOptions,ParentProtocol]],
			True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[Lookup[myOptions,ParentProtocol], ObjectP[ProtocolTypes[]]],
			False,
		True,
			Lookup[myOptions, Email]
	];

	(* Overwrite our rounded options with our resolved options. Everything else has a default. *)
	resolvedOptions=Normal@Join[
		Association@roundedExperimentOptions,
		Association@{
			WorkCell -> resolvedWorkCell,
			RoboticInstrument -> resolvedRoboticInstrument,
			CellType -> resolvedCellTypes,
			TargetCellularComponent -> resolvedTargetCellularComponents,
			Method -> resolvedMethods,
			CultureAdhesion -> resolvedCultureAdhesions,
			NumberOfLysisSteps -> resolvedNumbersOfLysisSteps,
			NumberOfReplicates -> resolvedNumberOfReplicates,
			Aliquot -> resolvedAliquotBools,
			AliquotAmount -> resolvedAliquotAmounts,
			AliquotContainer -> resolvedAliquotContainers,
			AliquotContainerWell -> resolvedAliquotContainerWells,
			AliquotContainerLabel -> resolvedAliquotContainerLabels,
			ClarifiedLysateContainer -> resolvedClarifiedLysateContainers,
			ClarifiedLysateContainerWell -> resolvedClarifiedLysateContainerWells,
			Dissociate -> resolvedDissociateBools,
			PreLysisPellet -> resolvedPreLysisPelletBools,
			PreLysisPelletingCentrifuge -> resolvedPreLysisPelletingCentrifuges,
			PreLysisPelletingIntensity -> resolvedPreLysisPelletingIntensities,
			PreLysisPelletingTime -> resolvedPreLysisPelletingTimes,
			PreLysisSupernatantVolume -> resolvedPreLysisSupernatantVolumes,
			PreLysisSupernatantStorageCondition -> resolvedPreLysisSupernatantStorageConditions,
			PreLysisSupernatantContainer -> resolvedPreLysisSupernatantContainers,
			PreLysisSupernatantContainerWell -> resolvedPreLysisSupernatantContainerWells,
			PreLysisDilute -> resolvedPreLysisDiluteBools,
			PreLysisDiluent -> resolvedPreLysisDiluents,
			PreLysisDilutionVolume -> resolvedPreLysisDilutionVolumes,
			TargetCellCount -> resolvedTargetCellCounts,
			TargetCellConcentration -> resolvedTargetCellConcentrations,
			LysisSolution -> resolvedLysisSolutions,
			LysisSolutionVolume -> resolvedLysisSolutionVolumes,
			MixType -> resolvedMixTypes,
			MixRate -> resolvedMixRates,
			MixTime -> resolvedMixTimes,
			MixVolume -> resolvedMixVolumes,
			NumberOfMixes -> resolvedNumbersOfMixes,
			MixTemperature -> resolvedMixTemperatures,
			LysisTemperature -> resolvedLysisTemperatures,
			LysisTime -> resolvedLysisTimes,
			MixInstrument -> resolvedMixInstruments,
			IncubationInstrument -> resolvedIncubationInstruments,
			SecondaryLysisSolution -> resolvedSecondaryLysisSolutions,
			SecondaryLysisSolutionVolume -> resolvedSecondaryLysisSolutionVolumes,
			SecondaryMixType -> resolvedSecondaryMixTypes,
			SecondaryMixRate -> resolvedSecondaryMixRates,
			SecondaryMixTime -> resolvedSecondaryMixTimes,
			SecondaryMixVolume -> resolvedSecondaryMixVolumes,
			SecondaryNumberOfMixes -> resolvedSecondaryNumbersOfMixes,
			SecondaryMixTemperature -> resolvedSecondaryMixTemperatures,
			SecondaryLysisTemperature -> resolvedSecondaryLysisTemperatures,
			SecondaryLysisTime -> resolvedSecondaryLysisTimes,
			SecondaryMixInstrument -> resolvedSecondaryMixInstruments,
			SecondaryIncubationInstrument -> resolvedSecondaryIncubationInstruments,
			TertiaryLysisSolution -> resolvedTertiaryLysisSolutions,
			TertiaryLysisSolutionVolume -> resolvedTertiaryLysisSolutionVolumes,
			TertiaryMixType -> resolvedTertiaryMixTypes,
			TertiaryMixRate -> resolvedTertiaryMixRates,
			TertiaryMixTime -> resolvedTertiaryMixTimes,
			TertiaryMixVolume -> resolvedTertiaryMixVolumes,
			TertiaryNumberOfMixes -> resolvedTertiaryNumbersOfMixes,
			TertiaryMixTemperature -> resolvedTertiaryMixTemperatures,
			TertiaryLysisTemperature -> resolvedTertiaryLysisTemperatures,
			TertiaryLysisTime -> resolvedTertiaryLysisTimes,
			TertiaryMixInstrument -> resolvedTertiaryMixInstruments,
			TertiaryIncubationInstrument -> resolvedTertiaryIncubationInstruments,
			ClarifyLysate -> resolvedClarifyLysateBools,
			ClarifyLysateCentrifuge -> resolvedClarifyLysateCentrifuges,
			ClarifyLysateIntensity -> resolvedClarifyLysateIntensities,
			ClarifyLysateTime -> resolvedClarifyLysateTimes,
			ClarifiedLysateVolume -> resolvedClarifiedLysateVolumes,
			PostClarificationPelletStorageCondition -> resolvedPostClarificationPelletStorageConditions,
			SamplesOutStorageCondition -> resolvedSamplesOutStorageConditions,

			SampleOutLabel -> resolvedSampleOutLabels,
			ClarifiedLysateContainerLabel -> resolvedClarifiedLysateContainerLabels,
			PreLysisSupernatantLabel -> resolvedPreLysisSupernatantLabels,
			PreLysisSupernatantContainerLabel -> resolvedPreLysisSupernatantContainerLabels,
			PostClarificationPelletLabel -> resolvedPostClarificationPelletLabels,
			PostClarificationPelletContainerLabel -> resolvedPostClarificationPelletContainerLabels,

			(* HIDDEN OPTIONS *)
			PostClarificationPelletContainer -> resolvedPostClarificationPelletContainers,
			PostClarificationPelletContainerWell -> resolvedPostClarificationPelletContainerWells,

			resolvedPostProcessingOptions,
			Email -> email
		}
	];

	(* UNSUPPORTED CELLTYPE ERROR - For *)
	unsupportedCellTypeCases = MapThread[
		Function[{sample, cellType, index},
			(* Null is here to avoid clash w/ UnknownCellType warning or lysis-free extractions, where CellType might be correctly set to Null. *)
			If[MatchQ[cellType, Except[Alternatives[Mammalian, Bacterial, Yeast, Null]]],
				{sample, cellType, index},
				Nothing
			]
		],
		{mySamples, resolvedCellTypes, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[unsupportedCellTypeCases], GreaterP[0]] && messages,
		Message[
			Error::UnsupportedCellType,
			ObjectToString[unsupportedCellTypeCases[[All,1]], Cache -> cacheBall],
			ObjectToString[unsupportedCellTypeCases[[All,2]], Cache -> cacheBall],
			unsupportedCellTypeCases[[All,3]]
		];
	];

	unsupportedCellTypeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unsupportedCellTypeCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The CellType of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " must be Mammalian, Bacterial, or Yeast:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The CellType of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " must be Mammalian, Bacterial, or Yeast:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* THROW CONFLICTING OPTION ERRORS *)

	(* There should only be secondary lysis options if number of lysis steps is 2 or 3. *)
	extraneousSecondaryLysisOptionsCases = MapThread[
		Function[
			{
				sample,
				numberOfLysisSteps,
				secondaryLysisSolution,
				secondaryLysisSolutionVolume,
				secondaryMixType,
				secondaryMixRate,
				secondaryMixTime,
				secondaryMixVolume,
				secondaryNumberOfMixes,
				secondaryMixInstrument,
				secondaryMixTemperature,
				secondaryLysisTemperature,
				secondaryLysisTime,
				secondaryIncubationInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[secondaryLysisSolution, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryLysisSolution, secondaryLysisSolution, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryLysisSolutionVolume, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryLysisSolutionVolume, secondaryLysisSolutionVolume, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryMixType, secondaryMixType, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryMixRate, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryMixRate, secondaryMixRate, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryMixTime, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryMixTime, secondaryMixTime, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryMixVolume, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryMixVolume, secondaryMixVolume, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryNumberOfMixes, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryNumberOfMixes, secondaryNumberOfMixes, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryMixInstrument, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryMixInstrument, secondaryMixInstrument, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryMixTemperature, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryMixTemperature, secondaryMixTemperature, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryLysisTemperature, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryLysisTemperature, secondaryLysisTemperature, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryLysisTime, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryLysisTime, secondaryLysisTime, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryIncubationInstrument, Except[Null]] && MatchQ[numberOfLysisSteps, 1],
					{sample, SecondaryIncubationInstrument, secondaryIncubationInstrument, numberOfLysisSteps, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedNumbersOfLysisSteps,
			resolvedSecondaryLysisSolutions,
			resolvedSecondaryLysisSolutionVolumes,
			resolvedSecondaryMixTypes,
			resolvedSecondaryMixRates,
			resolvedSecondaryMixTimes,
			resolvedSecondaryMixVolumes,
			resolvedSecondaryNumbersOfMixes,
			resolvedSecondaryMixInstruments,
			resolvedSecondaryMixTemperatures,
			resolvedSecondaryLysisTemperatures,
			resolvedSecondaryLysisTimes,
			resolvedSecondaryIncubationInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[extraneousSecondaryLysisOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::ExtraneousSecondaryLysisOptions,
			ObjectToString[extraneousSecondaryLysisOptionsCases[[All,1]], Cache -> cacheBall],
			ObjectToString[extraneousSecondaryLysisOptionsCases[[All,2]], Cache -> cacheBall],
			ObjectToString[extraneousSecondaryLysisOptionsCases[[All,3]], Cache -> cacheBall],
			ObjectToString[extraneousSecondaryLysisOptionsCases[[All,4]], Cache -> cacheBall],
			extraneousSecondaryLysisOptionsCases[[All,5]]
		];
	];

	extraneousSecondaryLysisOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = extraneousSecondaryLysisOptionsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["No secondary lysis options are specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if NumberOfLysisSteps is equal to 1:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["No secondary lysis options are specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if NumberOfLysisSteps is equal to 1:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* There should only be tertiary lysis options if number of lysis steps is 3. *)
	extraneousTertiaryLysisOptionsCases = MapThread[
		Function[
			{
				sample,
				numberOfLysisSteps,
				tertiaryLysisSolution,
				tertiaryLysisSolutionVolume,
				tertiaryMixType,
				tertiaryMixRate,
				tertiaryMixTime,
				tertiaryMixVolume,
				tertiaryNumberOfMixes,
				tertiaryMixInstrument,
				tertiaryMixTemperature,
				tertiaryLysisTemperature,
				tertiaryLysisTime,
				tertiaryIncubationInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[tertiaryLysisSolution, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, SecondaryLysisSolution, tertiaryLysisSolution, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryLysisSolutionVolume, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, SecondaryLysisSolutionVolume, tertiaryLysisSolutionVolume, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryMixType, tertiaryMixType, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryMixRate, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryMixRate, tertiaryMixRate, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryMixTime, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryMixTime, tertiaryMixTime, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryMixVolume, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryMixVolume, tertiaryMixVolume, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryNumberOfMixes, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryNumberOfMixes, tertiaryNumberOfMixes, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryMixInstrument, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryMixInstrument, tertiaryMixInstrument, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryMixTemperature, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryMixTemperature, tertiaryMixTemperature, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryLysisTemperature, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryLysisTemperature, tertiaryLysisTemperature, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryLysisTime, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryLysisTime, tertiaryLysisTime, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryIncubationInstrument, Except[Null]] && MatchQ[numberOfLysisSteps, (1|2)],
					{sample, TertiaryIncubationInstrument, tertiaryIncubationInstrument, numberOfLysisSteps, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedNumbersOfLysisSteps,
			resolvedTertiaryLysisSolutions,
			resolvedTertiaryLysisSolutionVolumes,
			resolvedTertiaryMixTypes,
			resolvedTertiaryMixRates,
			resolvedTertiaryMixTimes,
			resolvedTertiaryMixVolumes,
			resolvedTertiaryNumbersOfMixes,
			resolvedTertiaryMixInstruments,
			resolvedTertiaryMixTemperatures,
			resolvedTertiaryLysisTemperatures,
			resolvedTertiaryLysisTimes,
			resolvedTertiaryIncubationInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[extraneousTertiaryLysisOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::ExtraneousTertiaryLysisOptions,
			ObjectToString[extraneousTertiaryLysisOptionsCases[[All,1]], Cache -> cacheBall],
			ObjectToString[extraneousTertiaryLysisOptionsCases[[All,2]], Cache -> cacheBall],
			ObjectToString[extraneousTertiaryLysisOptionsCases[[All,3]], Cache -> cacheBall],
			ObjectToString[extraneousTertiaryLysisOptionsCases[[All,4]], Cache -> cacheBall],
			extraneousTertiaryLysisOptionsCases[[All,5]]
		];
	];

	extraneousTertiaryLysisOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = extraneousTertiaryLysisOptionsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["No tertiary lysis options are specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if NumberOfLysisSteps is less than 3:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["No tertiary lysis options are specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if NumberOfLysisSteps is less than 3:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that none of the required secondary lysis options are Null if number of lysis steps is 2 or 3. *)
	insufficientSecondaryLysisOptionsCases = MapThread[
		Function[
			{
				sample,
				numberOfLysisSteps,
				secondaryLysisSolution,
				secondaryLysisSolutionVolume,
				secondaryMixType,
				secondaryLysisTemperature,
				secondaryLysisTime,
				secondaryIncubationInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[secondaryLysisSolution, Null] && MatchQ[numberOfLysisSteps, (2|3)],
					{sample, SecondaryLysisSolution, secondaryLysisSolution, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryLysisSolutionVolume, Null] && MatchQ[numberOfLysisSteps, (2|3)],
					{sample, SecondaryLysisSolutionVolume, secondaryLysisSolutionVolume, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Null] && MatchQ[numberOfLysisSteps, (2|3)],
					{sample, SecondaryMixType, secondaryMixType, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryLysisTemperature, Null] && MatchQ[numberOfLysisSteps, (2|3)],
					{sample, SecondaryLysisTemperature, secondaryLysisTemperature, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryLysisTime, Null] && MatchQ[numberOfLysisSteps, (2|3)],
					{sample, SecondaryLysisTime, secondaryLysisTime, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[secondaryIncubationInstrument, Null] && MatchQ[numberOfLysisSteps, (2|3)],
					{sample, SecondaryIncubationInstrument, secondaryIncubationInstrument, numberOfLysisSteps, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedNumbersOfLysisSteps,
			resolvedSecondaryLysisSolutions,
			resolvedSecondaryLysisSolutionVolumes,
			resolvedSecondaryMixTypes,
			resolvedSecondaryLysisTemperatures,
			resolvedSecondaryLysisTimes,
			resolvedSecondaryIncubationInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[insufficientSecondaryLysisOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::InsufficientSecondaryLysisOptions,
			ObjectToString[insufficientSecondaryLysisOptionsCases[[All,1]], Cache -> cacheBall],
			ObjectToString[insufficientSecondaryLysisOptionsCases[[All,2]], Cache -> cacheBall],
			ObjectToString[insufficientSecondaryLysisOptionsCases[[All,3]], Cache -> cacheBall],
			ObjectToString[insufficientSecondaryLysisOptionsCases[[All,4]], Cache -> cacheBall],
			insufficientSecondaryLysisOptionsCases[[All,5]]
		];
	];

	insufficientSecondaryLysisOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = insufficientSecondaryLysisOptionsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of SecondaryLysisSolution, SecondaryLysisSolutionVolume, SecondaryMixType, SecondaryLysisTemperature, SecondaryLysisTime, or SecondaryIncubationInstrument are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if NumberOfLysisSteps is greater than 1:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of SecondaryLysisSolution, SecondaryLysisSolutionVolume, SecondaryMixType, SecondaryLysisTemperature, SecondaryLysisTime, or SecondaryIncubationInstrument are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if NumberOfLysisSteps is greater than 1:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that none of the required tertiary lysis options are Null if number of lysis steps is 3. *)
	insufficientTertiaryLysisOptionsCases = MapThread[
		Function[
			{
				sample,
				numberOfLysisSteps,
				tertiaryLysisSolution,
				tertiaryLysisSolutionVolume,
				tertiaryMixType,
				tertiaryLysisTemperature,
				tertiaryLysisTime,
				tertiaryIncubationInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[tertiaryLysisSolution, Null] && MatchQ[numberOfLysisSteps, 3],
					{sample, TertiaryLysisSolution, tertiaryLysisSolution, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryLysisSolutionVolume, Null] && MatchQ[numberOfLysisSteps, 3],
					{sample, TertiaryLysisSolutionVolume, tertiaryLysisSolutionVolume, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Null] && MatchQ[numberOfLysisSteps, 3],
					{sample, TertiaryMixType, tertiaryMixType, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryLysisTemperature, Null] && MatchQ[numberOfLysisSteps, 3],
					{sample, TertiaryLysisTemperature, tertiaryLysisTemperature, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryLysisTime, Null] && MatchQ[numberOfLysisSteps, 3],
					{sample, TertiaryLysisTime, tertiaryLysisTime, numberOfLysisSteps, index},
					Nothing
				],
				If[MatchQ[tertiaryIncubationInstrument, Null] && MatchQ[numberOfLysisSteps, 3],
					{sample, TertiaryIncubationInstrument, tertiaryIncubationInstrument, numberOfLysisSteps, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedNumbersOfLysisSteps,
			resolvedTertiaryLysisSolutions,
			resolvedTertiaryLysisSolutionVolumes,
			resolvedTertiaryMixTypes,
			resolvedTertiaryLysisTemperatures,
			resolvedTertiaryLysisTimes,
			resolvedTertiaryIncubationInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[insufficientTertiaryLysisOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::InsufficientTertiaryLysisOptions,
			ObjectToString[insufficientTertiaryLysisOptionsCases[[All,1]], Cache -> cacheBall],
			ObjectToString[insufficientTertiaryLysisOptionsCases[[All,2]], Cache -> cacheBall],
			ObjectToString[insufficientTertiaryLysisOptionsCases[[All,3]], Cache -> cacheBall],
			ObjectToString[insufficientTertiaryLysisOptionsCases[[All,4]], Cache -> cacheBall],
			insufficientTertiaryLysisOptionsCases[[All,5]]
		];
	];

	insufficientTertiaryLysisOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = insufficientTertiaryLysisOptionsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of TertiaryLysisSolution, TertiaryLysisSolutionVolume, TertiaryMixType, TertiaryLysisTemperature, TertiaryLysisTime, or TertiaryIncubationInstrument are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if NumberOfLysisSteps is 3:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of TertiaryLysisSolution, TertiaryLysisSolutionVolume, TertiaryMixType, TertiaryLysisTemperature, TertiaryLysisTime, or TertiaryIncubationInstrument are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if NumberOfLysisSteps is 3:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* AliquotAmount and AliquotContainer must be set if and only if Aliquot is True. *)
	aliquotOptionsMismatches = MapThread[
		Function[{sample, aliquotBool, aliquotAmount, aliquotContainer, index},
			Sequence @@ {
				If[MatchQ[aliquotBool, False] && MatchQ[aliquotAmount, Except[Null]],
					{sample, AliquotAmount, aliquotAmount, aliquotBool, index},
					Nothing
				],
				If[MatchQ[aliquotBool, False] && MatchQ[aliquotContainer, Except[Null]],
					{sample, AliquotContainer, aliquotContainer, aliquotBool, index},
					Nothing
				],
				If[MatchQ[aliquotBool, True] && MatchQ[aliquotAmount, Null],
					{sample, AliquotAmount, aliquotAmount, aliquotBool, index},
					Nothing
				],
				If[MatchQ[aliquotBool, True] && MatchQ[aliquotContainer, Null],
					{sample, AliquotContainer, aliquotContainer, aliquotBool, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedAliquotBools, resolvedAliquotAmounts, contractedResolvedAliquotContainers, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[aliquotOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::AliquotOptionsMismatch,
			ObjectToString[aliquotOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[aliquotOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[aliquotOptionsMismatches[[All,3]], Cache -> cacheBall],
			ObjectToString[aliquotOptionsMismatches[[All,4]], Cache -> cacheBall],
			aliquotOptionsMismatches[[All,5]]
		];
	];

	aliquotOptionsMismatchesTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = aliquotOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if and only if AliquotAmount and AliquotContainer are not Null:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if and only if AliquotAmount and AliquotContainer are not Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* PreLysis Pelleting options must be set if and only if PreLysisPellet is True. *)
	preLysisPelletOptionsMismatches = MapThread[
		Function[
			{
				sample,
				preLysisPelletBool,
				preLysisPelletingCentrifuge,
				preLysisPelletingIntensity,
				preLysisPelletingTime,
				preLysisSupernatantVolume,
				preLysisSupernatantStorageCondition,
				preLysisSupernatantContainer,
				index
			},
			Sequence @@ {
				If[MatchQ[preLysisPelletBool, True] && MatchQ[preLysisPelletingCentrifuge, Null],
					{sample, PreLysisPelletingCentrifuge, preLysisPelletingCentrifuge, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, True] && MatchQ[preLysisPelletingIntensity, Null],
					{sample, PreLysisPelletingIntensity, preLysisPelletingIntensity, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, True] && MatchQ[preLysisPelletingTime, Null],
					{sample, PreLysisPelletingTime, preLysisPelletingTime, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, True] && MatchQ[preLysisSupernatantVolume, Null],
					{sample, PreLysisSupernatantVolume, preLysisSupernatantVolume, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, True] && MatchQ[preLysisSupernatantStorageCondition, Null],
					{sample, PreLysisSupernatantStorageCondition, preLysisSupernatantStorageCondition, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, True] && MatchQ[preLysisSupernatantContainer, Null],
					{sample, PreLysisSupernatantContainer, preLysisSupernatantContainer, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, False] && MatchQ[preLysisPelletingCentrifuge, Except[Null]],
					{sample, PreLysisPelletingCentrifuge, preLysisPelletingCentrifuge, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, False] && MatchQ[preLysisPelletingIntensity, Except[Null]],
					{sample, PreLysisPelletingIntensity, preLysisPelletingIntensity, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, False] && MatchQ[preLysisPelletingTime, Except[Null]],
					{sample, PreLysisPelletingTime, preLysisPelletingTime, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, False] && MatchQ[preLysisSupernatantVolume, Except[Null]],
					{sample, PreLysisSupernatantVolume, preLysisSupernatantVolume, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, False] && MatchQ[preLysisSupernatantStorageCondition, Except[Null]],
					{sample, PreLysisSupernatantStorageCondition, preLysisSupernatantStorageCondition, preLysisPelletBool, index},
					Nothing
				],
				If[MatchQ[preLysisPelletBool, False] && MatchQ[preLysisSupernatantContainer, Except[Null]],
					{sample, PreLysisSupernatantContainer, preLysisSupernatantContainer, preLysisPelletBool, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedPreLysisPelletBools,
			resolvedPreLysisPelletingCentrifuges,
			resolvedPreLysisPelletingIntensities,
			resolvedPreLysisPelletingTimes,
			resolvedPreLysisSupernatantVolumes,
			resolvedPreLysisSupernatantStorageConditions,
			contractedResolvedPreLysisSupernatantContainers,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[preLysisPelletOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::PreLysisPelletOptionsMismatch,
			ObjectToString[preLysisPelletOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[preLysisPelletOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[preLysisPelletOptionsMismatches[[All,3]], Cache -> cacheBall],
			ObjectToString[preLysisPelletOptionsMismatches[[All,4]], Cache -> cacheBall],
			preLysisPelletOptionsMismatches[[All,5]]
		];
	];

	preLysisPelletOptionsMismatchesTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = preLysisPelletOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["PreLysisPellet is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if and only if all options required for pre-lysis pelleting are not Null:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["PreLysisPellet is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if and only if all options required for pre-lysis pelleting are not Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Pre-lysis dilution options must be set if and only if PreLysisDilute is True *)
	preLysisDiluteOptionsMismatches = MapThread[
		Function[{sample, preLysisDiluteBool, preLysisDiluent, preLysisDilutionVolume, index},
			Sequence @@ {
				If[MatchQ[preLysisDiluteBool, True] && MatchQ[preLysisDiluent, Null],
					{sample, PreLysisDiluent, preLysisDiluent, preLysisDiluteBool, index},
					Nothing
				],
				If[MatchQ[preLysisDiluteBool, True] && MatchQ[preLysisDilutionVolume, Null],
					{sample, PreLysisDilutionVolume, preLysisDilutionVolume, preLysisDiluteBool, index},
					Nothing
				],
				If[MatchQ[preLysisDiluteBool, False] && MatchQ[preLysisDiluent, Except[Null]],
					{sample, PreLysisDiluent, preLysisDiluent, preLysisDiluteBool, index},
					Nothing
				],
				If[MatchQ[preLysisDiluteBool, False] && MatchQ[preLysisDilutionVolume, Except[Null]],
					{sample, PreLysisDilutionVolume, preLysisDilutionVolume, preLysisDiluteBool, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedPreLysisDiluteBools, resolvedPreLysisDiluents, resolvedPreLysisDilutionVolumes, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[preLysisDiluteOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::PreLysisDiluteOptionsMismatch,
			ObjectToString[preLysisDiluteOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[preLysisDiluteOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[preLysisDiluteOptionsMismatches[[All,3]], Cache -> cacheBall],
			ObjectToString[preLysisDiluteOptionsMismatches[[All,4]], Cache -> cacheBall],
			preLysisDiluteOptionsMismatches[[All,5]]
		];
	];

	preLysisDiluteOptionsMismatchesTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = preLysisDiluteOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["PreLysisDilute is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if and only if PreLysisDiluent is Null and PreLysisDilutionVolume is Null or 0 Microliter:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["PreLysisDilute is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if and only if PreLysisDiluent is Null and PreLysisDilutionVolume is Null or 0 Microliter:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* PreLysis Pelleting options must be set if and only if PreLysisPellet is True. *)
	clarifyLysateOptionsMismatches = MapThread[
		Function[
			{
				sample,
				clarifyLysateBool,
				clarifyLysateCentrifuge,
				clarifyLysateIntensity,
				clarifyLysateTime,
				clarifiedLysateVolume,
				clarifiedLysateContainer,
				postClarificationPelletStorageCondition,
				index
			},
			Sequence @@ {
				If[MatchQ[clarifyLysateBool, True] && MatchQ[clarifyLysateCentrifuge, Null],
					{sample, ClarifyLysateCentrifuge, clarifyLysateCentrifuge, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, True] && MatchQ[clarifyLysateIntensity, Null],
					{sample, ClarifyLysateIntensity, clarifyLysateIntensity, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, True] && MatchQ[clarifyLysateTime, Null],
					{sample, ClarifyLysateTime, clarifyLysateTime, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, True] && MatchQ[clarifiedLysateVolume, Null],
					{sample, ClarifiedLysateVolume, clarifiedLysateVolume, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, True] && MatchQ[clarifiedLysateContainer, Null],
					{sample, ClarifiedLysateContainer, clarifiedLysateContainer, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, True] && MatchQ[postClarificationPelletStorageCondition, Null],
					{sample, PostClarificationPelletStorageCondition, postClarificationPelletStorageCondition, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, False] && MatchQ[clarifyLysateCentrifuge, Except[Null]],
					{sample, ClarifyLysateCentrifuge, clarifyLysateCentrifuge, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, False] && MatchQ[clarifyLysateIntensity, Except[Null]],
					{sample, ClarifyLysateIntensity, clarifyLysateIntensity, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, False] && MatchQ[clarifyLysateTime, Except[Null]],
					{sample, ClarifyLysateTime, clarifyLysateTime, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, False] && MatchQ[clarifiedLysateVolume, Except[Null]],
					{sample, ClarifiedLysateVolume, clarifiedLysateVolume, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, False] && MatchQ[clarifiedLysateContainer, Except[Null]],
					{sample, ClarifiedLysateContainer, clarifiedLysateContainer, clarifyLysateBool, index},
					Nothing
				],
				If[MatchQ[clarifyLysateBool, False] && MatchQ[postClarificationPelletStorageCondition, Except[Null]],
					{sample, PostClarificationPelletStorageCondition, postClarificationPelletStorageCondition, clarifyLysateBool, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedClarifyLysateBools,
			resolvedClarifyLysateCentrifuges,
			resolvedClarifyLysateIntensities,
			resolvedClarifyLysateTimes,
			resolvedClarifiedLysateVolumes,
			contractedResolvedClarifiedLysateContainers,
			resolvedPostClarificationPelletStorageConditions,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[clarifyLysateOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::ClarifyLysateOptionsMismatch,
			ObjectToString[clarifyLysateOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[clarifyLysateOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[clarifyLysateOptionsMismatches[[All,3]], Cache -> cacheBall],
			ObjectToString[clarifyLysateOptionsMismatches[[All,4]], Cache -> cacheBall],
			clarifyLysateOptionsMismatches[[All,5]]
		];
	];

	clarifyLysateOptionsMismatchesTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = clarifyLysateOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["ClarifyLysate is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if and only if all options required for lysate clarification are not Null:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["ClarifyLysate is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if and only if all options required for lysate clarification are not Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that all shaking options are set and all pipette mixing options are Null if MixType is Shake *)
	mixByShakingOptionsMismatches = MapThread[
		Function[
			{
				sample,
				mixType,
				mixRate,
				mixTime,
				numberOfMixes,
				mixVolume,
				mixTemperature,
				mixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[mixType, Shake] && MatchQ[mixRate, (Null|EqualP[0 RPM])],
					{sample, MixRate, mixRate, index},
					Nothing
				],
				If[MatchQ[mixType, Shake] && MatchQ[mixTime, (Null|EqualP[0 Second])],
					{sample, MixTime, mixTime, index},
					Nothing
				],
				If[MatchQ[mixType, Shake] && MatchQ[numberOfMixes, Except[Null]],
					{sample, NumberOfMixes, numberOfMixes, index},
					Nothing
				],
				If[MatchQ[mixType, Shake] && MatchQ[mixVolume, Except[Null]],
					{sample, MixVolume, mixVolume, index},
					Nothing
				],
				If[MatchQ[mixType, Shake] && MatchQ[mixTemperature, Null],
					{sample, MixTemperature, mixTemperature, index},
					Nothing
				],
				If[MatchQ[mixType, Shake] && MatchQ[mixInstrument, Null],
					{sample, MixInstrument, mixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedMixTypes,
			resolvedMixRates,
			resolvedMixTimes,
			resolvedNumbersOfMixes,
			resolvedMixVolumes,
			resolvedMixTemperatures,
			resolvedMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[mixByShakingOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::MixByShakingOptionsMismatch,
			ObjectToString[mixByShakingOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[mixByShakingOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[mixByShakingOptionsMismatches[[All,3]], Cache -> cacheBall],
			mixByShakingOptionsMismatches[[All,4]]
		];
	];

	mixByShakingOptionsMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = mixByShakingOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["MixRate, MixTime, MixInstrument, and MixTemperature are not Null while NumberOfMixes and MixVolume are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if MixType is set to Shake:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["MixRate, MixTime, MixInstrument, and MixTemperature are not Null while NumberOfMixes and MixVolume are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if MixType is set to Shake:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that all secondary shaking options are set and all secondary pipette mixing options are Null if SecondaryMixType is Shake *)
	secondaryMixByShakingOptionsMismatches = MapThread[
		Function[
			{
				sample,
				secondaryMixType,
				secondaryMixRate,
				secondaryMixTime,
				secondaryNumberOfMixes,
				secondaryMixVolume,
				secondaryMixTemperature,
				secondaryMixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[secondaryMixType, Shake] && MatchQ[secondaryMixRate, (Null|EqualP[0 RPM])],
					{sample, SecondaryMixRate, secondaryMixRate, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Shake] && MatchQ[secondaryMixTime, (Null|EqualP[0 Second])],
					{sample, SecondaryMixTime, secondaryMixTime, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Shake] && MatchQ[secondaryNumberOfMixes, Except[Null]],
					{sample, SecondaryNumberOfMixes, secondaryNumberOfMixes, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Shake] && MatchQ[secondaryMixVolume, Except[Null]],
					{sample, SecondaryMixVolume, secondaryMixVolume, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Shake] && MatchQ[secondaryMixTemperature, Null],
					{sample, SecondaryMixTemperature, secondaryMixTemperature, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Shake] && MatchQ[secondaryMixInstrument, Null],
					{sample, SecondaryMixInstrument, secondaryMixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedSecondaryMixTypes,
			resolvedSecondaryMixRates,
			resolvedSecondaryMixTimes,
			resolvedSecondaryNumbersOfMixes,
			resolvedSecondaryMixVolumes,
			resolvedSecondaryMixTemperatures,
			resolvedSecondaryMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[secondaryMixByShakingOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::SecondaryMixByShakingOptionsMismatch,
			ObjectToString[secondaryMixByShakingOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[secondaryMixByShakingOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[secondaryMixByShakingOptionsMismatches[[All,3]], Cache -> cacheBall],
			secondaryMixByShakingOptionsMismatches[[All,4]]
		];
	];

	secondaryMixByShakingOptionsMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = secondaryMixByShakingOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["SecondaryMixRate, SecondaryMixTime, SecondaryMixInstrument, and SecondaryMixTemperature are not Null while SecondaryNumberOfMixes and SecondaryMixVolume are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if SecondaryMixType is set to Shake:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["SecondaryMixRate, SecondaryMixTime, SecondaryMixInstrument, and SecondaryMixTemperature are not Null while SecondaryNumberOfMixes and SecondaryMixVolume are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if SecondaryMixType is set to Shake:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that all tertiary shaking options are set and all tertiary pipette mixing options are Null if TertiaryMixType is Shake *)
	tertiaryMixByShakingOptionsMismatches = MapThread[
		Function[
			{
				sample,
				tertiaryMixType,
				tertiaryMixRate,
				tertiaryMixTime,
				tertiaryNumberOfMixes,
				tertiaryMixVolume,
				tertiaryMixTemperature,
				tertiaryMixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[tertiaryMixType, Shake] && MatchQ[tertiaryMixRate, (Null|EqualP[0 RPM])],
					{sample, TertiaryMixRate, tertiaryMixRate, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Shake] && MatchQ[tertiaryMixTime, (Null|EqualP[0 Second])],
					{sample, TertiaryMixTime, tertiaryMixTime, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Shake] && MatchQ[tertiaryNumberOfMixes, Except[Null]],
					{sample, TertiaryNumberOfMixes, tertiaryNumberOfMixes, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Shake] && MatchQ[tertiaryMixVolume, Except[Null]],
					{sample, TertiaryMixVolume, tertiaryMixVolume, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Shake] && MatchQ[tertiaryMixTemperature, Null],
					{sample, TertiaryMixTemperature, tertiaryMixTemperature, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Shake] && MatchQ[tertiaryMixInstrument, Null],
					{sample, TertiaryMixInstrument, tertiaryMixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedTertiaryMixTypes,
			resolvedTertiaryMixRates,
			resolvedTertiaryMixTimes,
			resolvedTertiaryNumbersOfMixes,
			resolvedTertiaryMixVolumes,
			resolvedTertiaryMixTemperatures,
			resolvedTertiaryMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[tertiaryMixByShakingOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::TertiaryMixByShakingOptionsMismatch,
			ObjectToString[tertiaryMixByShakingOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[tertiaryMixByShakingOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[tertiaryMixByShakingOptionsMismatches[[All,3]], Cache -> cacheBall],
			tertiaryMixByShakingOptionsMismatches[[All,4]]
		];
	];

	tertiaryMixByShakingOptionsMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = tertiaryMixByShakingOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["TertiaryMixRate, TertiaryMixTime, TertiaryMixInstrument, and TertiaryMixTemperature are not Null while TertiaryNumberOfMixes and TertiaryMixVolume are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if TertiaryMixType is set to Shake:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["TertiaryMixRate, TertiaryMixTime, TertiaryMixInstrument, and TertiaryMixTemperature are not Null while TertiaryNumberOfMixes and TertiaryMixVolume are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if TertiaryMixType is set to Shake:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that all pipette mix options are set and all shake mix options are Null if MixType is Pipette *)
	mixByPipettingOptionsMismatches = MapThread[
		Function[
			{
				sample,
				mixType,
				mixRate,
				mixTime,
				numberOfMixes,
				mixVolume,
				mixTemperature,
				mixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[mixType, Pipette] && MatchQ[mixRate, Except[Null]],
					{sample, MixRate, mixRate, index},
					Nothing
				],
				If[MatchQ[mixType, Pipette] && MatchQ[mixTime, Except[Null]],
					{sample, MixTime, mixTime, index},
					Nothing
				],
				If[MatchQ[mixType, Pipette] && MatchQ[numberOfMixes, Except[_Integer]],
					{sample, NumberOfMixes, numberOfMixes, index},
					Nothing
				],
				If[MatchQ[mixType, Pipette] && MatchQ[mixVolume, Except[GreaterP[0 Microliter]]],
					{sample, MixVolume, mixVolume, index},
					Nothing
				],
				If[MatchQ[mixType, Pipette] && MatchQ[mixTemperature, Except[Null|AmbientTemperatureP]],
					{sample, MixTemperature, mixTemperature, index},
					Nothing
				],
				If[MatchQ[mixType, Pipette] && MatchQ[mixInstrument, Except[Null]],
					{sample, MixInstrument, mixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedMixTypes,
			resolvedMixRates,
			resolvedMixTimes,
			resolvedNumbersOfMixes,
			resolvedMixVolumes,
			resolvedMixTemperatures,
			resolvedMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[mixByPipettingOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::MixByPipettingOptionsMismatch,
			ObjectToString[mixByPipettingOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[mixByPipettingOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[mixByPipettingOptionsMismatches[[All,3]], Cache -> cacheBall],
			mixByPipettingOptionsMismatches[[All,4]]
		];
	];

	mixByPipettingOptionsMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = mixByPipettingOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["NumberOfMixes and MixVolume are not Null while MixRate, MixTime, MixInstrument, are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if MixType is set to Pipette:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["NumberOfMixes and MixVolume are not Null while MixRate, MixTime, MixInstrument, are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if MixType is set to Pipette:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that all secondary pipette mix options are set and all secondary shake mix options are Null if SecondaryMixType is Pipette *)
	secondaryMixByPipettingOptionsMismatches = MapThread[
		Function[
			{
				sample,
				secondaryMixType,
				secondaryMixRate,
				secondaryMixTime,
				secondaryNumberOfMixes,
				secondaryMixVolume,
				secondaryMixTemperature,
				secondaryMixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[secondaryMixType, Pipette] && MatchQ[secondaryMixRate, Except[Null]],
					{sample, SecondaryMixRate, secondaryMixRate, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Pipette] && MatchQ[secondaryMixTime, Except[Null]],
					{sample, SecondaryMixTime, secondaryMixTime, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Pipette] && MatchQ[secondaryNumberOfMixes, Except[_Integer]],
					{sample, SecondaryNumberOfMixes, secondaryNumberOfMixes, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Pipette] && MatchQ[secondaryMixVolume, Except[GreaterP[0 Microliter]]],
					{sample, SecondaryMixVolume, secondaryMixVolume, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Pipette] && MatchQ[secondaryMixTemperature, Except[Null|AmbientTemperatureP]],
					{sample, SecondaryMixTemperature, secondaryMixTemperature, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, Pipette] && MatchQ[secondaryMixInstrument, Except[Null]],
					{sample, SecondaryMixInstrument, secondaryMixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedSecondaryMixTypes,
			resolvedSecondaryMixRates,
			resolvedSecondaryMixTimes,
			resolvedSecondaryNumbersOfMixes,
			resolvedSecondaryMixVolumes,
			resolvedSecondaryMixTemperatures,
			resolvedSecondaryMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[secondaryMixByPipettingOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::SecondaryMixByPipettingOptionsMismatch,
			ObjectToString[secondaryMixByPipettingOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[secondaryMixByPipettingOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[secondaryMixByPipettingOptionsMismatches[[All,3]], Cache -> cacheBall],
			secondaryMixByPipettingOptionsMismatches[[All,4]]
		];
	];

	secondaryMixByPipettingOptionsMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = secondaryMixByPipettingOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["SecondaryNumberOfMixes and SecondaryMixVolume are not Null while SecondaryMixRate, SecondaryMixTime, SecondaryMixInstrument are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if SecondaryMixType is set to Pipette:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["SecondaryNumberOfMixes and SecondaryMixVolume are not Null while SecondaryMixRate, SecondaryMixTime, SecondaryMixInstrument are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if SecondaryMixType is set to Pipette:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that all tertiary pipette mix options are set and all tertiary shake mix options are Null if TertiaryMixType is Pipette *)
	tertiaryMixByPipettingOptionsMismatches = MapThread[
		Function[
			{
				sample,
				tertiaryMixType,
				tertiaryMixRate,
				tertiaryMixTime,
				tertiaryNumberOfMixes,
				tertiaryMixVolume,
				tertiaryMixTemperature,
				tertiaryMixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[tertiaryMixType, Pipette] && MatchQ[tertiaryMixRate, Except[Null]],
					{sample, TertiaryMixRate, tertiaryMixRate, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Pipette] && MatchQ[tertiaryMixTime, Except[Null]],
					{sample, TertiaryMixTime, tertiaryMixTime, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Pipette] && MatchQ[tertiaryNumberOfMixes, Except[_Integer]],
					{sample, TertiaryNumberOfMixes, tertiaryNumberOfMixes, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Pipette] && MatchQ[tertiaryMixVolume, Except[GreaterP[0 Microliter]]],
					{sample, TertiaryMixVolume, tertiaryMixVolume, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Pipette] && MatchQ[tertiaryMixTemperature, Except[Null|AmbientTemperatureP]],
					{sample, TertiaryMixTemperature, tertiaryMixTemperature, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, Pipette] && MatchQ[tertiaryMixInstrument, Except[Null]],
					{sample, TertiaryMixInstrument, tertiaryMixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedTertiaryMixTypes,
			resolvedTertiaryMixRates,
			resolvedTertiaryMixTimes,
			resolvedTertiaryNumbersOfMixes,
			resolvedTertiaryMixVolumes,
			resolvedTertiaryMixTemperatures,
			resolvedTertiaryMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[tertiaryMixByPipettingOptionsMismatches], GreaterP[0]] && messages,
		Message[
			Error::TertiaryMixByPipettingOptionsMismatch,
			ObjectToString[tertiaryMixByPipettingOptionsMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[tertiaryMixByPipettingOptionsMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[tertiaryMixByPipettingOptionsMismatches[[All,3]], Cache -> cacheBall],
			tertiaryMixByPipettingOptionsMismatches[[All,4]]
		];
	];

	tertiaryMixByPipettingOptionsMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = tertiaryMixByPipettingOptionsMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["TertiaryNumberOfMixes and TertiaryMixVolume are not Null while TertiaryMixRate, TertiaryMixTime, TertiaryMixInstrument, and TertiaryMixTemperature are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if TertiaryMixType is set to Pipette:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["TertiaryNumberOfMixes and TertiaryMixVolume are not Null while TertiaryMixRate, TertiaryMixTime, TertiaryMixInstrument, and TertiaryMixTemperature are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if TertiaryMixType is set to Pipette:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that no primary mixing options are set if MixType is set to None *)
	mixTypeNoneMismatches = MapThread[
		Function[
			{
				sample,
				mixType,
				mixRate,
				mixTime,
				numberOfMixes,
				mixVolume,
				mixTemperature,
				mixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[mixType, None] && MatchQ[mixRate, Except[Null]],
					{sample, MixRate, mixRate, index},
					Nothing
				],
				If[MatchQ[mixType, None] && MatchQ[mixTime, Except[Null]],
					{sample, MixTime, mixTime, index},
					Nothing
				],
				If[MatchQ[mixType, None] && MatchQ[numberOfMixes, Except[Null]],
					{sample, NumberOfMixes, numberOfMixes, index},
					Nothing
				],
				If[MatchQ[mixType, None] && MatchQ[mixVolume, Except[Null]],
					{sample, MixVolume, mixVolume, index},
					Nothing
				],
				If[MatchQ[mixType, None] && MatchQ[mixTemperature, Except[Null]],
					{sample, MixTemperature, mixTemperature, index},
					Nothing
				],
				If[MatchQ[mixType, None] && MatchQ[mixInstrument, Except[Null]],
					{sample, MixInstrument, mixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedMixTypes,
			resolvedMixRates,
			resolvedMixTimes,
			resolvedNumbersOfMixes,
			resolvedMixVolumes,
			resolvedMixTemperatures,
			resolvedMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[mixTypeNoneMismatches], GreaterP[0]] && messages,
		Message[
			Error::MixTypeNoneMismatch,
			ObjectToString[mixTypeNoneMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[mixTypeNoneMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[mixTypeNoneMismatches[[All,3]], Cache -> cacheBall],
			mixTypeNoneMismatches[[All,4]]
		];
	];

	mixTypeNoneMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = mixTypeNoneMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, and MixInstrument are set to Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if MixType is set to None:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, and MixInstrument are set to Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if MixType is set to None:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that no secondary mixing options are set if SecondaryMixType is set to None *)
	secondaryMixTypeNoneMismatches = MapThread[
		Function[
			{
				sample,
				secondaryMixType,
				secondaryMixRate,
				secondaryMixTime,
				secondaryNumberOfMixes,
				secondaryMixVolume,
				secondaryMixTemperature,
				secondaryMixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[secondaryMixType, None] && MatchQ[secondaryMixRate, Except[Null]],
					{sample, SecondaryMixRate, secondaryMixRate, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, None] && MatchQ[secondaryMixTime, Except[Null]],
					{sample, SecondaryMixTime, secondaryMixTime, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, None] && MatchQ[secondaryNumberOfMixes, Except[Null]],
					{sample, SecondaryNumberOfMixes, secondaryNumberOfMixes, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, None] && MatchQ[secondaryMixVolume, Except[Null]],
					{sample, SecondaryMixVolume, secondaryMixVolume, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, None] && MatchQ[secondaryMixTemperature, Except[Null]],
					{sample, SecondaryMixTemperature, secondaryMixTemperature, index},
					Nothing
				],
				If[MatchQ[secondaryMixType, None] && MatchQ[secondaryMixInstrument, Except[Null]],
					{sample, SecondaryMixInstrument, secondaryMixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedSecondaryMixTypes,
			resolvedSecondaryMixRates,
			resolvedSecondaryMixTimes,
			resolvedSecondaryNumbersOfMixes,
			resolvedSecondaryMixVolumes,
			resolvedSecondaryMixTemperatures,
			resolvedSecondaryMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[secondaryMixTypeNoneMismatches], GreaterP[0]] && messages,
		Message[
			Error::SecondaryMixTypeNoneMismatch,
			ObjectToString[secondaryMixTypeNoneMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[secondaryMixTypeNoneMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[secondaryMixTypeNoneMismatches[[All,3]], Cache -> cacheBall],
			secondaryMixTypeNoneMismatches[[All,4]]
		];
	];

	secondaryMixTypeNoneMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = secondaryMixTypeNoneMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixVolume, SecondaryMixTemperature, and SecondaryMixInstrument are set to Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if SecondaryMixType is set to None:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixVolume, SecondaryMixTemperature, and SecondaryMixInstrument are set to Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if SecondaryMixType is set to None:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that no tertiary mixing options are set if MixType is set to None *)
	tertiaryMixTypeNoneMismatches = MapThread[
		Function[
			{
				sample,
				tertiaryMixType,
				tertiaryMixRate,
				tertiaryMixTime,
				tertiaryNumberOfMixes,
				tertiaryMixVolume,
				tertiaryMixTemperature,
				tertiaryMixInstrument,
				index
			},
			Sequence @@ {
				If[MatchQ[tertiaryMixType, None] && MatchQ[tertiaryMixRate, Except[Null]],
					{sample, TertiaryMixRate, tertiaryMixRate, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, None] && MatchQ[tertiaryMixTime, Except[Null]],
					{sample, TertiaryMixTime, tertiaryMixTime, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, None] && MatchQ[tertiaryNumberOfMixes, Except[Null]],
					{sample, TertiaryNumberOfMixes, tertiaryNumberOfMixes, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, None] && MatchQ[tertiaryMixVolume, Except[Null]],
					{sample, TertiaryMixVolume, tertiaryMixVolume, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, None] && MatchQ[tertiaryMixTemperature, Except[Null]],
					{sample, TertiaryMixTemperature, tertiaryMixTemperature, index},
					Nothing
				],
				If[MatchQ[tertiaryMixType, None] && MatchQ[tertiaryMixInstrument, Except[Null]],
					{sample, TertiaryMixInstrument, tertiaryMixInstrument, index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedTertiaryMixTypes,
			resolvedTertiaryMixRates,
			resolvedTertiaryMixTimes,
			resolvedTertiaryNumbersOfMixes,
			resolvedTertiaryMixVolumes,
			resolvedTertiaryMixTemperatures,
			resolvedTertiaryMixInstruments,
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[tertiaryMixTypeNoneMismatches], GreaterP[0]] && messages,
		Message[
			Error::TertiaryMixTypeNoneMismatch,
			ObjectToString[tertiaryMixTypeNoneMismatches[[All,1]], Cache -> cacheBall],
			ObjectToString[tertiaryMixTypeNoneMismatches[[All,2]], Cache -> cacheBall],
			ObjectToString[tertiaryMixTypeNoneMismatches[[All,3]], Cache -> cacheBall],
			tertiaryMixTypeNoneMismatches[[All,4]]
		];
	];

	tertiaryMixTypeNoneMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = tertiaryMixTypeNoneMismatches[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixVolume, TertiaryMixTemperature, and TertiaryMixInstrument are set to Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if TertiaryMixType is set to None:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixVolume, TertiaryMixTemperature, and TertiaryMixInstrument are set to Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if TertiaryMixType is set to None:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that no samples grouped into the same container have different mixing conditions *)
	conflictingMixParametersInSameContainersCases = Module[
		{
			workingContainers, exclusiveContainerIndices, shareableContainers, containerWithMixParameterSets, containersWithUniqueMixParameters,
			conflictingMixOptionsContainers, conflictingMixOptionsContainerIndices
		},

		(* Get the working containers in which mixing steps will occur *)
		workingContainers = MapThread[
			Function[{samplePacket, aliquotContainer},
				Which[
					(* If we're not aliquoting, this is the sample's input container *)
					MatchQ[aliquotContainer, Null],
						LinkedObject[Lookup[samplePacket, Container]],
					(* If we are aliquoting, this is the aliquot container *)
					True,
						aliquotContainer
				]
			],
			{samplePackets, contractedResolvedAliquotContainers}
		];

		(* Find the indices at which the container is neither a specific object or an indexed container model *)
		(* The containers at these indices can each have one sample in them, so there will be no parameter conflicts *)
		exclusiveContainerIndices = Rest @ Flatten[Position[workingContainers, Except[Alternatives[ObjectP[Object[Container]], {_Integer, ObjectP[Model[Container]]}]], 1]];

		(* Get all the containers but Null out the ones which won't ever have multiple experiments. The Nulls are here to preserve index matching. *)
		shareableContainers = ReplacePart[workingContainers, # -> Null & /@ exclusiveContainerIndices];

		(* Get all of the mixing parameters for each individual experiment *)
		containerWithMixParameterSets = Transpose[{
			shareableContainers,
			resolvedMixTypes,
			resolvedMixRates,
			resolvedMixTimes,
			resolvedMixTemperatures,
			resolvedMixInstruments,
			resolvedSecondaryMixTypes,
			resolvedSecondaryMixRates,
			resolvedSecondaryMixTimes,
			resolvedSecondaryMixTemperatures,
			resolvedSecondaryMixInstruments,
			resolvedTertiaryMixTypes,
			resolvedTertiaryMixRates,
			resolvedTertiaryMixTimes,
			resolvedTertiaryMixTemperatures,
			resolvedTertiaryMixInstruments
		}];

		(* Delete duplicates and take the first of the transpose to find all containers with unique sets of parameters *)
		containersWithUniqueMixParameters = First @ Transpose[DeleteDuplicates[containerWithMixParameterSets]];

		(* Get the containers which are associated with conflicting parameter sets *)
		conflictingMixOptionsContainers = PickList[
			containersWithUniqueMixParameters,
			Count[containersWithUniqueMixParameters, #] & /@ containersWithUniqueMixParameters,
			GreaterP[1]
		];

		(* Get the indices of containers with conflicting mix parameters *)
		conflictingMixOptionsContainerIndices = Flatten @ Position[workingContainers, Alternatives @@ conflictingMixOptionsContainers];

		Transpose @ {mySamples[[conflictingMixOptionsContainerIndices]], conflictingMixOptionsContainers, conflictingMixOptionsContainerIndices}

	];

	If[MatchQ[Length[conflictingMixParametersInSameContainersCases], GreaterP[0]] && messages,
		Message[
			Error::ConflictingMixOptionsInSameContainerForLysis,
			ObjectToString[conflictingMixParametersInSameContainersCases[[All,1]], Cache -> cacheBall],
			ObjectToString[conflictingMixParametersInSameContainersCases[[All,2]], Cache -> cacheBall],
			conflictingMixParametersInSameContainersCases[[All,3]]
		];
	];

	conflictingMixParametersInSameContainersTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingMixParametersInSameContainersCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " which are grouped into the same containers have different experimental conditions specified for the options MixType, MixRate, MixTime, MixInstrument, SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryMixInstrument, TertiaryMixType, TertiaryMixRate, TertiaryMixTime, or TertiaryMixInstrument:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " which are grouped into the same containers have different experimental conditions specified for the options MixType, MixRate, MixTime, MixInstrument, SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryMixInstrument, TertiaryMixType, TertiaryMixRate, TertiaryMixTime, or TertiaryMixInstrument:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that no samples grouped into the same container have different incubation conditions *)
	conflictingIncubationParametersInSameContainersCases = Module[
		{
			workingContainers, exclusiveContainerIndices, shareableContainers, containerWithIncubationParameterSets, containersWithUniqueIncubationParameters,
			conflictingIncubationOptionsContainers, conflictingIncubationOptionsContainerIndices
		},

		(* Get the working containers in which incubation steps will occur *)
		workingContainers = MapThread[
			Function[{samplePacket, aliquotContainer},
				Which[
					(* If we're not aliquoting, this is the sample's input container *)
					MatchQ[aliquotContainer, Null],
						LinkedObject[Lookup[samplePacket, Container]],
					(* If we are aliquoting, this is the aliquot container *)
					True,
						aliquotContainer
				]
			],
			{samplePackets, contractedResolvedAliquotContainers}
		];

		(* Find the indices at which the container is neither a specific object or an indexed container model *)
		(* The containers at these indices can each have one sample in them, so there will be no parameter conflicts *)
		exclusiveContainerIndices = Rest @ Flatten[Position[workingContainers, Except[Alternatives[ObjectP[Object[Container]], {_Integer, ObjectP[Model[Container]]}]], 1]];

		(* Get all the containers but Null out the ones which won't ever have multiple experiments. The Nulls are here to preserve index matching. *)
		shareableContainers = ReplacePart[workingContainers, # -> Null & /@ exclusiveContainerIndices];

		(* Get all of the incubation related parameters for each individual experiment *)
		containerWithIncubationParameterSets = Transpose[{
			shareableContainers,
			resolvedLysisTimes,
			resolvedLysisTemperatures,
			resolvedIncubationInstruments,
			resolvedSecondaryLysisTimes,
			resolvedSecondaryLysisTemperatures,
			resolvedSecondaryIncubationInstruments,
			resolvedTertiaryLysisTimes,
			resolvedTertiaryLysisTemperatures,
			resolvedTertiaryIncubationInstruments
		}];

		(* Delete duplicates and take the first of the transpose to find all containers with unique sets of parameters *)
		containersWithUniqueIncubationParameters = First @ Transpose[DeleteDuplicates[containerWithIncubationParameterSets]];

		(* Get the containers which are associated with conflicting parameter sets *)
		conflictingIncubationOptionsContainers = PickList[
			containersWithUniqueIncubationParameters,
			Count[containersWithUniqueIncubationParameters, #] & /@ containersWithUniqueIncubationParameters,
			GreaterP[1]
		];

		(* Get the indices of containers with conflicting incubation parameters *)
		conflictingIncubationOptionsContainerIndices = Flatten @ Position[workingContainers, Alternatives @@ conflictingIncubationOptionsContainers];

		Transpose @ {mySamples[[conflictingIncubationOptionsContainerIndices]], conflictingIncubationOptionsContainers, conflictingIncubationOptionsContainerIndices}

	];

	If[MatchQ[Length[conflictingIncubationParametersInSameContainersCases], GreaterP[0]] && messages,
		Message[
			Error::ConflictingIncubationOptionsInSameContainerForLysis,
			ObjectToString[conflictingIncubationParametersInSameContainersCases[[All,1]], Cache -> cacheBall],
			ObjectToString[conflictingIncubationParametersInSameContainersCases[[All,2]], Cache -> cacheBall],
			conflictingIncubationParametersInSameContainersCases[[All,3]]
		];
	];

	conflictingIncubationParametersInSameContainersTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingIncubationParametersInSameContainersCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " which are grouped into the same containers have different experimental conditions specified for the options LysisTime, LysisTemperature, IncubationInstrument, SecondaryLysisTime, SecondaryLysisTemperature, SecondaryIncubationInstrument, TertiaryLysisTime, TertiaryLysisTemperature, TertiaryIncubationInstrument:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " which are grouped into the same containers have different experimental conditions specified for the options LysisTime, LysisTemperature, IncubationInstrument, SecondaryLysisTime, SecondaryLysisTemperature, SecondaryIncubationInstrument, TertiaryLysisTime, TertiaryLysisTemperature, TertiaryIncubationInstrument:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that no samples grouped into the same container have different pre lysis pelleting conditions *)
	conflictingCentrifugationParametersInSameContainersCases = Module[
		{
			workingContainers, exclusiveContainerIndices, shareableContainers, containerWithPelletParameterSets, containersWithUniquePelletParameters,
			conflictingPelletOptionsContainers, conflictingPelletOptionsContainerIndices
		},

		(* Get the working containers in which pelleting steps will occur *)
		workingContainers = MapThread[
			Function[{samplePacket, aliquotContainer},
				Which[
					(* If we're not aliquoting, this is the sample's input container *)
					MatchQ[aliquotContainer, Null],
						LinkedObject[Lookup[samplePacket, Container]],
					(* If we are aliquoting, this is the aliquot container *)
					True,
						aliquotContainer
				]
			],
			{samplePackets, contractedResolvedAliquotContainers}
		];

		(* Find the indices at which the container is neither a specific object or an indexed container model *)
		(* The containers at these indices can each have one sample in them, so there will be no parameter conflicts *)
		exclusiveContainerIndices = Rest @ Flatten[Position[workingContainers, Except[Alternatives[ObjectP[Object[Container]], {_Integer, ObjectP[Model[Container]]}]], 1]];

		(* Get all the containers but Null out the ones which won't ever have multiple experiments. The Nulls are here to preserve index matching. *)
		shareableContainers = ReplacePart[workingContainers, # -> Null & /@ exclusiveContainerIndices];

		(* Get all of the pelleting related parameters for each individual experiment *)
		containerWithPelletParameterSets = Transpose[{
			shareableContainers,
			resolvedPreLysisPelletingCentrifuges,
			resolvedPreLysisPelletingIntensities,
			resolvedPreLysisPelletingTimes,
			resolvedClarifyLysateCentrifuges,
			resolvedClarifyLysateIntensities,
			resolvedClarifyLysateTimes
		}];

		(* Delete duplicates and take the first of the transpose to find all containers with unique sets of parameters *)
		containersWithUniquePelletParameters = First @ Transpose[DeleteDuplicates[containerWithPelletParameterSets]];

		(* Get the containers which are associated with conflicting parameter sets *)
		conflictingPelletOptionsContainers = PickList[
			containersWithUniquePelletParameters,
			Count[containersWithUniquePelletParameters, #] & /@ containersWithUniquePelletParameters,
			GreaterP[1]
		];

		(* Get the indices of containers with conflicting pelleting parameters *)
		conflictingPelletOptionsContainerIndices = Flatten @ Position[workingContainers, Alternatives @@ conflictingPelletOptionsContainers];

		Transpose @ {mySamples[[conflictingPelletOptionsContainerIndices]], conflictingPelletOptionsContainers, conflictingPelletOptionsContainerIndices}

	];

	If[MatchQ[Length[conflictingCentrifugationParametersInSameContainersCases], GreaterP[0]] && messages,
		Message[
			Error::ConflictingCentrifugationConditionsInSameContainerForLysis,
			ObjectToString[conflictingCentrifugationParametersInSameContainersCases[[All,1]], Cache -> cacheBall],
			ObjectToString[conflictingCentrifugationParametersInSameContainersCases[[All,2]], Cache -> cacheBall],
			conflictingCentrifugationParametersInSameContainersCases[[All,3]]
		];
	];

	conflictingCentrifugationParametersInSameContainersTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingCentrifugationParametersInSameContainersCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " which are grouped into the same containers have different experimental conditions specified for the options PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, ClarifyLysateCentrifuge, ClarifyLysateIntensity, or ClarifyLysateTime:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " which are grouped into the same containers have different experimental conditions specified for the options PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, ClarifyLysateCentrifuge, ClarifyLysateIntensity, or ClarifyLysateTime:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* We cannot aliquot adherent cells without calling Dissociate *)
	aliquotAdherentCellsCases = MapThread[
		Function[{sample, aliquotBool, dissociateBool, cultureAdhesion, index},
			If[MatchQ[aliquotBool, True] && MatchQ[cultureAdhesion, Adherent] && MatchQ[dissociateBool, False],
				{sample, index},
				Nothing
			]
		],
		{mySamples, resolvedAliquotBools, resolvedDissociateBools, resolvedCultureAdhesions, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[aliquotAdherentCellsCases], GreaterP[0]] && messages,
		Message[
			Error::AliquotAdherentCells,
			ObjectToString[aliquotAdherentCellsCases[[All,1]], Cache -> cacheBall],
			aliquotAdherentCellsCases[[All,2]]
		];
	];

	aliquotAdherentCellsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = aliquotAdherentCellsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " containing adherent cells if and only if Dissociate is True:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " containing adherent cells if and only if Dissociate is True:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* We need to Aliquot all samples if NumberOfReplicates is greater than 1 *)
	replicatesWithoutAliquotCases = MapThread[
		Function[{sample, aliquotBool, index},
			If[MatchQ[aliquotBool, False] && MatchQ[numberOfReplicatesNoNull, GreaterP[1]],
				{sample, numberOfReplicatesNoNull, index},
				Nothing
			]
		],
		{mySamples, resolvedAliquotBools, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[replicatesWithoutAliquotCases], GreaterP[0]] && messages,
		Message[
			Error::ReplicateAliquotsRequiredForLysis,
			ObjectToString[replicatesWithoutAliquotCases[[All,1]], Cache -> cacheBall],
			replicatesWithoutAliquotCases[[All,2]],
			replicatesWithoutAliquotCases[[All,3]]
		];
	];

	replicatesWithoutAliquotTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = replicatesWithoutAliquotCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if NumberOfReplicates is 2 or greater:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if NumberOfReplicates is 2 or greater:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that there is cell count/concentration data in the sample if the user sets TargetCellCount and/or TargetCellConcentration *)
	noCellCountOrConcentrationDataCases = MapThread[
		Function[{sample, targetCellCount, targetCellConcentration, cellCountAvailableQ, cellConcentrationAvailableQ, index},
			Sequence @@ {
				If[MatchQ[targetCellCount, Except[Null|Automatic]] && MatchQ[{cellCountAvailableQ, cellConcentrationAvailableQ}, {False, False}],
					{sample, TargetCellCount, targetCellCount, index},
					Nothing
				],
				If[MatchQ[targetCellConcentration, Except[Null|Automatic]] && MatchQ[{cellCountAvailableQ, cellConcentrationAvailableQ}, {False, False}],
					{sample, TargetCellConcentration, targetCellConcentration, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedTargetCellCounts, resolvedTargetCellConcentrations, resolvedCellCountAvailableQs, resolvedCellConcentrationAvailableQs, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[noCellCountOrConcentrationDataCases], GreaterP[0]] && messages,
		Message[
			Error::NoCellCountOrConcentrationData,
			ObjectToString[noCellCountOrConcentrationDataCases[[All,1]], Cache -> cacheBall],
			ObjectToString[noCellCountOrConcentrationDataCases[[All,2]], Cache -> cacheBall],
			ObjectToString[noCellCountOrConcentrationDataCases[[All,3]], Cache -> cacheBall],
			noCellCountOrConcentrationDataCases[[All,4]]
		];
	];

	noCellCountOrConcentrationDataTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = noCellCountOrConcentrationDataCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["There is cell count or cell concentration data in the composition field of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if TargetCellCount and/or TargetCellConcentration is specified:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["There is cell count or cell concentration data in the composition field of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if TargetCellCount and/or TargetCellConcentration is specified:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check that there are enough cells in the source sample for the experiment if TargetCellCount and/or TargetCellConcentration is specified *)
	insufficientCellCountCases = MapThread[
		Function[
			{
				sample,
				targetCellCount,
				cellCountAvailableQ,
				cellCountAccessibleComposition,
				cellConcentrationAvailableQ,
				cellConcentrationAccessibleComposition,
				sampleVolume,
				index
			},
			Sequence @@ {
				If[
					And[
						MatchQ[targetCellCount, Except[Null]],
						MatchQ[cellCountAvailableQ, True],
						(* Next, check whether the experiment needs more than the available cell count; 1.02 gives us a 2% margin of error *)
						MatchQ[targetCellCount * numberOfReplicatesNoNull, GreaterP[1.02 * Total[cellCountAccessibleComposition[[All,1]]]]]
					],
					{
						sample,
						Unitless[targetCellCount],
						resolvedNumberOfReplicates,
						Unitless[Total[cellCountAccessibleComposition[[All,1]]]], (* the total number of cells in the source sample *)
						index
					},
					Nothing
				],
				If[
					And[
						MatchQ[targetCellCount, Except[Null]],
						MatchQ[cellConcentrationAvailableQ, True],
						(* Next, check whether the experiment needs more than the available cell count; 1.02 gives us a 2% margin of error *)
						MatchQ[targetCellCount * numberOfReplicatesNoNull, GreaterP[1.02 * sampleVolume * Total[cellConcentrationAccessibleComposition[[All,1]]]]]
					],
					{
						sample,
						Unitless[targetCellCount],
						resolvedNumberOfReplicates,
						Unitless[Total[cellConcentrationAccessibleComposition[[All,1]]] * sampleVolume], (* the total number of cells in the source sample *)
						index
					},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedTargetCellCounts,
			resolvedCellCountAvailableQs,
			resolvedCellCountAccessibleCompositions,
			resolvedCellConcentrationAvailableQs,
			resolvedCellConcentrationAccessibleCompositions,
			Lookup[samplePackets, Volume],
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[insufficientCellCountCases], GreaterP[0]] && messages,
		Message[
			Error::InsufficientCellCount,
			ObjectToString[insufficientCellCountCases[[All,1]], Cache -> cacheBall],
			insufficientCellCountCases[[All,2]],
			ObjectToString[insufficientCellCountCases[[All,3]], Cache -> cacheBall],
			insufficientCellCountCases[[All,4]],
			insufficientCellCountCases[[All,5]]
		];
	];

	insufficientCellCountTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = insufficientCellCountCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The specified TargetCellCount is less than 1.02 times the number of cells present in the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " times the NumberOfReplicates (if specified):", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The specified TargetCellCount is less than 1.02 times the number of cells present in the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " times the NumberOfReplicates (if specified):", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check to ensure that Dissociate is False if CultureAdhesion is Suspension *)
	dissociateSuspendedCellsCases = MapThread[
		Function[{sample, cultureAdhesion, dissociateBool, index},
			If[MatchQ[cultureAdhesion, Suspension] && MatchQ[dissociateBool, True],
				{sample, index},
				Nothing
			]
		],
		{mySamples, resolvedCultureAdhesions, resolvedDissociateBools, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[dissociateSuspendedCellsCases], GreaterP[0]] && messages,
		Message[
			Error::DissociateSuspendedCells,
			ObjectToString[dissociateSuspendedCellsCases[[All,1]], Cache -> cacheBall],
			dissociateSuspendedCellsCases[[All,2]]
		];
	];

	dissociateSuspendedCellsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = dissociateSuspendedCellsCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["CultureAdhesion is not Suspension for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if Dissociate is True:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["CultureAdhesion is not Suspension for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if Dissociate is True:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Throw an error if the user sets PreLysisDilute to True but doesn't give us enough info to resolve PreLysisDilutionVolume *)
	unresolvablePreLysisDilutionVolumeCases = MapThread[
		Function[{sample, preLysisDiluteBool, preLysisDilutionVolume, unresolvedTargetCellConcentration, index},
			If[
				And[
					MatchQ[preLysisDiluteBool, True],
					EqualQ[preLysisDilutionVolume, 0 Microliter],
					MatchQ[unresolvedTargetCellConcentration, (Null|Automatic)]
				],
				{sample, index},
				Nothing
			]
		],
		{mySamples, resolvedPreLysisDiluteBools, resolvedPreLysisDilutionVolumes, Lookup[listedOptions, TargetCellConcentration], Range[Length[mySamples]]}
	];

	If[MatchQ[Length[unresolvablePreLysisDilutionVolumeCases], GreaterP[0]] && messages,
		Message[
			Error::UnresolvablePreLysisDilutionVolume,
			ObjectToString[unresolvablePreLysisDilutionVolumeCases[[All,1]], Cache -> cacheBall],
			unresolvablePreLysisDilutionVolumeCases[[All,2]]
		];
	];

	unresolvablePreLysisDilutionVolumeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unresolvablePreLysisDilutionVolumeCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The user must specify one of PreLysisDilutionVolume or TargetCellConcentration to determine an appropriate dilution volume for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if PreLysisDilute is True:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The user must specify one of PreLysisDilutionVolume or TargetCellConcentration to determine an appropriate dilution volume for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if PreLysisDilute is True:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Throw an error if the CultureAdhesion is not specified by the user or known from the sample object *)
	unknownCultureAdhesionCases = MapThread[
		Function[{sample, unknownCultureAdhesionQ, index},
			If[
				MatchQ[unknownCultureAdhesionQ, True],
				{sample, index},
				Nothing
			]
		],
		{mySamples, resolvedUnknownCultureAdhesionQs, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[unknownCultureAdhesionCases], GreaterP[0]] && messages,
		Message[
			Error::UnknownCultureAdhesion,
			ObjectToString[unknownCultureAdhesionCases[[All,1]], Cache -> cacheBall],
			unknownCultureAdhesionCases[[All,2]]
		];
	];

	unknownCultureAdhesionTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unknownCultureAdhesionCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The CultureAdhesion is either specified by the user or obtained from the CellType field in the sample object for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> ":", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The CultureAdhesion is either specified by the user or obtained from the CellType field in the sample object for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Throw an error if multiple samples in the same plate have a different SamplesOutStorageCondition *)
	conflictingSamplesOutStorageConditionInSameContainerCases = Module[
		{
			containersOut, exclusiveContainerIndices, shareableContainers, containersWithStorageConditions, containersWithUniqueStorageConditions,
			conflictingStorageConditionContainers, conflictingStorageConditionContainerIndices
		},

		(* Get the final container at each index *)
		containersOut = MapThread[
			Function[{clarifiedLysateContainer, aliquotContainer, sampleInContainer},
				Which[
					(* If there is a ClarifiedLysateContainer, this is ContainerOut *)
					MatchQ[clarifiedLysateContainer, Except[Null]],
						clarifiedLysateContainer,
					(* If there is an AliquotContainer, this is ContainerOut *)
					MatchQ[aliquotContainer, Except[Null]],
						aliquotContainer,
					(* Otherwise, the sample in container is ContainerOut *)
					True,
						LinkedObject[sampleInContainer]
				]
			],
			{contractedResolvedClarifiedLysateContainers, contractedResolvedAliquotContainers, Lookup[samplePackets, Container]}
		];

		(* Find the indices at which the container is neither a specific object or an indexed container model *)
		(* The containers at these indices can each have one sample in them, so there will be no parameter conflicts *)
		exclusiveContainerIndices = Rest @ Flatten[Position[containersOut, Except[Alternatives[ObjectP[Object[Container]], {_Integer, ObjectP[Model[Container]]}]], 1]];

		(* Get all the containers but Null out the ones which won't ever have multiple experiments. The Nulls are here to preserve index matching. *)
		shareableContainers = ReplacePart[containersOut, # -> Null & /@ exclusiveContainerIndices];

		(* Get all of the storage conditions for each individual experiment *)
		containersWithStorageConditions = Transpose[{shareableContainers, resolvedSamplesOutStorageConditions}];

		(* Delete duplicates and take the first of the transpose to find all containers with unique storage conditions *)
		containersWithUniqueStorageConditions = First @ Transpose[DeleteDuplicates[containersWithStorageConditions]];

		(* Get the containers which are associated with conflicting parameter sets *)
		conflictingStorageConditionContainers = Cases[
			PickList[
				containersWithUniqueStorageConditions,
				Count[containersWithUniqueStorageConditions, #] & /@ containersWithUniqueStorageConditions,
				GreaterP[1]
			],
			Except[Null]
		];

		(* Get the indices of containers with conflicting storage conditions *)
		conflictingStorageConditionContainerIndices = Flatten @ Position[containersOut, Alternatives @@ conflictingStorageConditionContainers];

		Transpose @ {
			mySamples[[conflictingStorageConditionContainerIndices]],
			conflictingStorageConditionContainers,
			resolvedSamplesOutStorageConditions[[conflictingStorageConditionContainerIndices]],
			conflictingStorageConditionContainerIndices
		}

	];

	If[MatchQ[Length[conflictingSamplesOutStorageConditionInSameContainerCases], GreaterP[0]],
		Message[
			Error::ConflictingSamplesOutStorageConditionInSameContainer,
			ObjectToString[conflictingSamplesOutStorageConditionInSameContainerCases[[All,1]], Cache -> cacheBall],
			ObjectToString[conflictingSamplesOutStorageConditionInSameContainerCases[[All,2]], Cache -> cacheBall],
			ObjectToString[conflictingSamplesOutStorageConditionInSameContainerCases[[All,3]], Cache -> cacheBall],
			conflictingSamplesOutStorageConditionInSameContainerCases[[All,4]]
		];
	];

	conflictingSamplesOutStorageConditionInSameContainerTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingSamplesOutStorageConditionInSameContainerCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " which are grouped in the same container(s) have a different SamplesOutStorageCondition:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " which are grouped in the same container(s) have a different SamplesOutStorageCondition:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Throw an error if multiple samples in the same container have a different PreLysisSupernatantStorageCondition *)
	conflictingPreLysisSupernatantStorageConditionInSameContainerCases = Module[
		{
			exclusiveContainerIndices, shareableContainers, containersWithStorageConditions, containersWithUniqueStorageConditions,
			conflictingStorageConditionContainers, conflictingStorageConditionContainerIndices
		},

		(* Find the indices at which the container is neither a specific object or an indexed container model *)
		(* The containers at these indices can each have one sample in them, so there will be no storage conflicts *)
		exclusiveContainerIndices = Rest @ Flatten[Position[contractedResolvedPreLysisSupernatantContainers, Except[Alternatives[ObjectP[Object[Container]], {_Integer, ObjectP[Model[Container]]}]], 1]];

		(* Get all the containers but Null out the ones which won't ever have multiple experiments. The Nulls are here to preserve index matching. *)
		shareableContainers = ReplacePart[contractedResolvedPreLysisSupernatantContainers, # -> Null & /@ exclusiveContainerIndices];

		(* Get all the container and storage condition pairs *)
		containersWithStorageConditions = Transpose[{shareableContainers, resolvedPreLysisSupernatantStorageConditions}];

		(* Delete duplicates and take the first of the transpose to find all containers with unique sets of parameters *)
		containersWithUniqueStorageConditions = First @ Transpose[DeleteDuplicates[containersWithStorageConditions]];

		(* Get the containers which are associated with conflicting parameter sets *)
		conflictingStorageConditionContainers = Cases[
			PickList[
				containersWithUniqueStorageConditions,
				Count[containersWithUniqueStorageConditions, #] & /@ containersWithUniqueStorageConditions,
				GreaterP[1]
			],
			Except[Null]
		];

		(* Get the indices of containers with conflicting incubation parameters *)
		conflictingStorageConditionContainerIndices = Flatten @ Position[contractedResolvedPreLysisSupernatantContainers, Alternatives @@ conflictingStorageConditionContainers];

		Transpose @ {
			mySamples[[conflictingStorageConditionContainerIndices]],
			conflictingStorageConditionContainers,
			resolvedPreLysisSupernatantStorageConditions[[conflictingStorageConditionContainerIndices]],
			conflictingStorageConditionContainerIndices
		}

	];

	If[MatchQ[Length[conflictingPreLysisSupernatantStorageConditionInSameContainerCases], GreaterP[0]],
		Message[
			Error::ConflictingPreLysisSupernatantStorageConditionInSameContainer,
			ObjectToString[conflictingPreLysisSupernatantStorageConditionInSameContainerCases[[All,1]], Cache -> cacheBall],
			ObjectToString[conflictingPreLysisSupernatantStorageConditionInSameContainerCases[[All,2]], Cache -> cacheBall],
			ObjectToString[conflictingPreLysisSupernatantStorageConditionInSameContainerCases[[All,3]], Cache -> cacheBall],
			conflictingPreLysisSupernatantStorageConditionInSameContainerCases[[All,4]]
		];
	];

	conflictingPreLysisSupernatantStorageConditionInSameContainerTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingPreLysisSupernatantStorageConditionInSameContainerCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the supernatants resulting from pre lysis pelleting of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " which are transferred to the same container(s) have a different PreLysisSupernatantStorageCondition:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the supernatants resulting from pre lysis pelleting of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " which are transferred to the same container(s) have a different PreLysisSupernatantStorageCondition:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Throw an error if multiple samples in the same container have a different PostClarificationPelletStorageCondition *)
	conflictingPostClarificationPelletStorageConditionInSameContainerCases = Module[
		{
			workingContainers, containersWithStorageConditions, containersWithUniqueStorageConditions,
			conflictingStorageConditionContainers, conflictingStorageConditionContainerIndices
		},

		(* Get the final container at each index *)
		workingContainers = MapThread[
			Function[{aliquotContainer, sampleInContainer},
				Which[
					(* If there is an AliquotContainer, this is the working Container *)
					MatchQ[aliquotContainer, Except[Null]],
						aliquotContainer,
					(* Otherwise, the sample in container is the working Container *)
					True,
						LinkedObject[sampleInContainer]
				]
			],
			{contractedResolvedAliquotContainers, Lookup[samplePackets, Container]}
		];

		(* Get all the container and storage condition pairs *)
		containersWithStorageConditions = Transpose[{workingContainers, resolvedPostClarificationPelletStorageConditions}];

		(* Delete duplicates and take the first of the transpose to find all containers with unique sets of parameters *)
		containersWithUniqueStorageConditions = First @ Transpose[DeleteDuplicates[containersWithStorageConditions]];

		(* Get the containers which are associated with conflicting parameter sets *)
		conflictingStorageConditionContainers = Cases[
			PickList[
				containersWithUniqueStorageConditions,
				Count[containersWithUniqueStorageConditions, #] & /@ containersWithUniqueStorageConditions,
				GreaterP[1]
			],
			Except[Null]
		];

		(* Get the indices of containers with conflicting incubation parameters *)
		conflictingStorageConditionContainerIndices = Flatten @ Position[workingContainers, Alternatives @@ conflictingStorageConditionContainers];

		Transpose @ {
			mySamples[[conflictingStorageConditionContainerIndices]],
			conflictingStorageConditionContainers,
			resolvedPostClarificationPelletStorageConditions[[conflictingStorageConditionContainerIndices]],
			conflictingStorageConditionContainerIndices
		}

	];

	If[MatchQ[Length[conflictingPostClarificationPelletStorageConditionInSameContainerCases], GreaterP[0]],
		Message[
			Error::ConflictingPostClarificationPelletStorageConditionInSameContainer,
			ObjectToString[conflictingPostClarificationPelletStorageConditionInSameContainerCases[[All,1]], Cache -> cacheBall],
			ObjectToString[conflictingPostClarificationPelletStorageConditionInSameContainerCases[[All,2]], Cache -> cacheBall],
			ObjectToString[conflictingPostClarificationPelletStorageConditionInSameContainerCases[[All,3]], Cache -> cacheBall],
			conflictingPostClarificationPelletStorageConditionInSameContainerCases[[All,4]]
		];
	];

	conflictingPostClarificationPelletStorageConditionInSameContainerTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingPostClarificationPelletStorageConditionInSameContainerCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " which are pelleted in the same container(s) have a different PostClarificationPelletStorageCondition:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["None of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " which are pelleted in the same container(s) have a different PostClarificationPelletStorageCondition:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* WARNINGS *)

	(* Throw a warning if the CellType is not specified by the user or known from the sample object *)
	unknownCellTypeCases = MapThread[
		Function[{sample, unknownCellTypeQ, index},
			If[
				unknownCellTypeQ,
				{sample, index},
				Nothing
			]
		],
		{mySamples, resolvedUnknownCellTypeQs, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[unknownCellTypeCases], GreaterP[0]] && messages,
		Message[
			Warning::UnknownCellType,
			ObjectToString[unknownCellTypeCases[[All,1]], Cache -> cacheBall],
			unknownCellTypeCases[[All,2]]
		];
	];

	(* Throw a warning if the user specifies a TargetCellConcentration but we need to Pellet to reduce the volume to obtain it. *)
	pelletingRequiredToObtainTargetCellConcentrationCases = MapThread[
		Function[{sample, pelletingRequiredToAttainTargetCellConcentration, targetCellConcentration, index},
			If[pelletingRequiredToAttainTargetCellConcentration,
				{sample, targetCellConcentration, index},
				Nothing
			]
		],
		{mySamples, pelletingRequiredToAttainTargetCellConcentrationQ, resolvedTargetCellConcentrations, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[pelletingRequiredToObtainTargetCellConcentrationCases], GreaterP[0]] && messages,
		Message[
			Warning::PelletingRequiredToObtainTargetCellConcentration,
			ObjectToString[pelletingRequiredToObtainTargetCellConcentrationCases[[All,1]], Cache -> cacheBall],
			ObjectToString[(pelletingRequiredToObtainTargetCellConcentrationCases[[All,2]])/(EmeraldCell/Milliliter), Cache -> cacheBall],
			pelletingRequiredToObtainTargetCellConcentrationCases[[All,3]]
		];
	];

	(* Throw a warning if the total volume of the lysis solutions is less than that of solutions present prior to addition of lysis solution. *)
	lowRelativeLysisSolutionVolumeCases = MapThread[
		Function[
			{
				sample,
				aliquotBool,
				aliquotAmount,
				sampleAmount,
				dilutionVolume,
				preLysisSupernatantVolume,
				lysisSolutionVolume,
				secondaryLysisSolutionVolume,
				tertiaryLysisSolutionVolume,
				index
			},
			Sequence @@ {
				If[
					And[
						MatchQ[aliquotBool, True],
						MatchQ[
							Total[{lysisSolutionVolume, secondaryLysisSolutionVolume, tertiaryLysisSolutionVolume}],
							LessP[Total[{aliquotAmount, dilutionVolume, -preLysisSupernatantVolume}]]
						]
					],
					{sample, Total[{lysisSolutionVolume, secondaryLysisSolutionVolume, tertiaryLysisSolutionVolume}], Total[{aliquotAmount, dilutionVolume, -preLysisSupernatantVolume}], index},
					Nothing
				],
				If[
					And[
						MatchQ[aliquotBool, False],
						MatchQ[
							Total[{lysisSolutionVolume, secondaryLysisSolutionVolume, tertiaryLysisSolutionVolume}],
							LessP[Total[{sampleAmount, dilutionVolume, -preLysisSupernatantVolume}]]
						]
					],
					{sample, Total[{lysisSolutionVolume, secondaryLysisSolutionVolume, tertiaryLysisSolutionVolume}], Total[{sampleAmount, dilutionVolume, -preLysisSupernatantVolume}], index},
					Nothing
				]
			}
		],
		{
			mySamples,
			resolvedAliquotBools,
			resolvedAliquotAmounts,
			Lookup[samplePackets, Volume]/.{(Null|{}) -> 0 Microliter},
			resolvedPreLysisDilutionVolumes/.{Null -> 0 Microliter},
			resolvedPreLysisSupernatantVolumes/.{Null -> 0 Microliter},
			resolvedLysisSolutionVolumes/.{Null -> 0 Microliter},
			resolvedSecondaryLysisSolutionVolumes/.{Null -> 0 Microliter},
			resolvedTertiaryLysisSolutionVolumes/.{Null -> 0 Microliter},
			Range[Length[mySamples]]
		}
	];

	If[MatchQ[Length[lowRelativeLysisSolutionVolumeCases], GreaterP[0]] && messages,
		Message[
			Warning::LowRelativeLysisSolutionVolume,
			ObjectToString[lowRelativeLysisSolutionVolumeCases[[All,1]], Cache -> cacheBall],
			ObjectToString[lowRelativeLysisSolutionVolumeCases[[All,2]], Cache -> cacheBall],
			ObjectToString[lowRelativeLysisSolutionVolumeCases[[All,3]], Cache -> cacheBall],
			lowRelativeLysisSolutionVolumeCases[[All,4]]
		];
	];

	(* Throw a warning if the user leaves Aliquot, AliquotContainer, and AliquotAmount as Automatic but we resolve Aliquot to True for any other reason. *)
	aliquotingRequiredForCellLysisCases = MapThread[
		Function[{sample, unresolvedAliquotBool, unresolvedAliquotContainer, unresolvedAliquotAmount, resolvedAliquotBool, index},
			If[
				MatchQ[{unresolvedAliquotBool, unresolvedAliquotContainer, unresolvedAliquotAmount}, {Automatic, Automatic, Automatic}] && MatchQ[resolvedAliquotBool, True],
				{sample, index},
				Nothing
			]
		],
		{mySamples, Lookup[listedOptions, Aliquot], Lookup[listedOptions, AliquotContainer], Lookup[listedOptions, AliquotAmount], resolvedAliquotBools, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[aliquotingRequiredForCellLysisCases], GreaterP[0]] && messages,
		Message[
			Warning::AliquotingRequiredForCellLysis,
			ObjectToString[aliquotingRequiredForCellLysisCases[[All,1]], Cache -> cacheBall],
			aliquotingRequiredForCellLysisCases[[All,2]]
		];
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, deprecatedInvalidInputs, solidMediaInvalidInputs}]];

	invalidOptions = DeleteDuplicates[Flatten[{
		If[MatchQ[Length[unsupportedCellTypeCases], GreaterP[0]],
			{CellType},
			{}
		],
		If[MatchQ[Length[extraneousSecondaryLysisOptionsCases], GreaterP[0]],
			Join[{NumberOfLysisSteps}, $SecondaryLysisOptions],
			{}
		],
		If[MatchQ[Length[extraneousTertiaryLysisOptionsCases], GreaterP[0]],
			Join[{NumberOfLysisSteps}, $TertiaryLysisOptions],
			{}
		],
		If[MatchQ[Length[insufficientSecondaryLysisOptionsCases], GreaterP[0]],
			Join[{NumberOfLysisSteps}, $SecondaryLysisOptions],
			{}
		],
		If[MatchQ[Length[insufficientTertiaryLysisOptionsCases], GreaterP[0]],
			Join[{NumberOfLysisSteps}, $TertiaryLysisOptions],
			{}
		],
		If[MatchQ[Length[aliquotOptionsMismatches], GreaterP[0]],
			{Aliquot, AliquotAmount, AliquotContainer},
			{}
		],
		If[MatchQ[Length[preLysisPelletOptionsMismatches], GreaterP[0]],
			Join[{PreLysisPellet}, $PreLysisPelletingOptions],
			{}
		],
		If[MatchQ[Length[preLysisDiluteOptionsMismatches], GreaterP[0]],
			{PreLysisDilute, PreLysisDiluent, PreLysisDilutionVolume},
			{}
		],
		If[MatchQ[Length[clarifyLysateOptionsMismatches], GreaterP[0]],
			Join[{ClarifyLysate}, $LysateClarificationOptions],
			{}
		],
		If[MatchQ[Length[aliquotAdherentCellsCases], GreaterP[0]],
			{Aliquot, Dissociate, CultureAdhesion},
			{}
		],
		If[MatchQ[Length[noCellCountOrConcentrationDataCases], GreaterP[0]],
			{TargetCellCount, TargetCellConcentration},
			{}
		],
		If[MatchQ[Length[insufficientCellCountCases], GreaterP[0]],
			{TargetCellCount, NumberOfReplicates},
			{}
		],
		If[MatchQ[Length[replicatesWithoutAliquotCases], GreaterP[0]],
			{Aliquot, NumberOfReplicates},
			{}
		],
		If[MatchQ[Length[mixByShakingOptionsMismatches], GreaterP[0]],
			{MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, MixInstrument},
			{}
		],
		If[MatchQ[Length[secondaryMixByShakingOptionsMismatches], GreaterP[0]],
			{SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixVolume, SecondaryMixTemperature, SecondaryMixInstrument},
			{}
		],
		If[MatchQ[Length[tertiaryMixByShakingOptionsMismatches], GreaterP[0]],
			{TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixVolume, TertiaryMixTemperature, TertiaryMixInstrument},
			{}
		],
		If[MatchQ[Length[mixByPipettingOptionsMismatches], GreaterP[0]],
			{MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, MixInstrument},
			{}
		],
		If[MatchQ[Length[secondaryMixByPipettingOptionsMismatches], GreaterP[0]],
			{SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixVolume, SecondaryMixTemperature, SecondaryMixInstrument},
			{}
		],
		If[MatchQ[Length[tertiaryMixByPipettingOptionsMismatches], GreaterP[0]],
			{TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixVolume, TertiaryMixTemperature, TertiaryMixInstrument},
			{}
		],
		If[MatchQ[Length[mixTypeNoneMismatches], GreaterP[0]],
			{MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, MixInstrument},
			{}
		],
		If[MatchQ[Length[secondaryMixTypeNoneMismatches], GreaterP[0]],
			{SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixVolume, SecondaryMixTemperature, SecondaryMixInstrument},
			{}
		],
		If[MatchQ[Length[tertiaryMixTypeNoneMismatches], GreaterP[0]],
			{TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixVolume, TertiaryMixTemperature, TertiaryMixInstrument},
			{}
		],
		If[MatchQ[Length[conflictingMixParametersInSameContainersCases], GreaterP[0]],
			{
				MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, MixInstrument,
				SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixVolume, SecondaryMixTemperature, SecondaryMixInstrument,
				TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixVolume, TertiaryMixTemperature, TertiaryMixInstrument
			},
			{}
		],
		If[MatchQ[Length[conflictingIncubationParametersInSameContainersCases], GreaterP[0]],
			{
				LysisTime, LysisTemperature, IncubationInstrument,
				SecondaryLysisTime, SecondaryLysisTemperature, SecondaryIncubationInstrument,
				TertiaryLysisTime, TertiaryLysisTemperature, TertiaryIncubationInstrument
			},
			{}
		],
		If[MatchQ[Length[conflictingCentrifugationParametersInSameContainersCases], GreaterP[0]],
			{PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime},
			{}
		],
		If[MatchQ[Length[dissociateSuspendedCellsCases], GreaterP[0]],
			{CultureAdhesion,Dissociate},
			{}
		],
		If[MatchQ[Length[unresolvablePreLysisDilutionVolumeCases], GreaterP[0]],
			{PreLysisDilute, PreLysisDilutionVolume, TargetCellConcentration},
			{}
		],
		If[MatchQ[Length[unknownCultureAdhesionCases], GreaterP[0]],
			{CultureAdhesion},
			{}
		],
		If[MatchQ[Length[conflictingSamplesOutStorageConditionInSameContainerCases], GreaterP[0]],
			{SamplesOutStorageCondition},
			{}
		],
		If[MatchQ[Length[conflictingPreLysisSupernatantStorageConditionInSameContainerCases], GreaterP[0]],
			{PreLysisSupernatantStorageCondition, PreLysisSupernatantContainer},
			{}
		],
		If[MatchQ[Length[conflictingPostClarificationPelletStorageConditionInSameContainerCases], GreaterP[0]],
			{PostClarificationPelletStorageCondition},
			{}
		]
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[MatchQ[Length[invalidInputs], GreaterP[0]] && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache->cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[MatchQ[Length[invalidOptions], GreaterP[0]] && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Flatten[{
			optionPrecisionTests,
			extraneousSecondaryLysisOptionsTest,
			extraneousTertiaryLysisOptionsTest,
			insufficientSecondaryLysisOptionsTest,
			insufficientTertiaryLysisOptionsTest,
			aliquotOptionsMismatchesTest,
			preLysisPelletOptionsMismatchesTest,
			preLysisDiluteOptionsMismatchesTest,
			clarifyLysateOptionsMismatchesTest,
			mixByShakingOptionsMismatchTest,
			secondaryMixByShakingOptionsMismatchTest,
			tertiaryMixByShakingOptionsMismatchTest,
			mixByPipettingOptionsMismatchTest,
			secondaryMixByPipettingOptionsMismatchTest,
			tertiaryMixByPipettingOptionsMismatchTest,
			mixTypeNoneMismatchTest,
			secondaryMixTypeNoneMismatchTest,
			tertiaryMixTypeNoneMismatchTest,
			conflictingMixParametersInSameContainersTest,
			conflictingIncubationParametersInSameContainersTest,
			conflictingIncubationParametersInSameContainersTest,
			aliquotAdherentCellsTest,
			replicatesWithoutAliquotTest,
			noCellCountOrConcentrationDataTest,
			insufficientCellCountTest,
			dissociateSuspendedCellsTest,
			unresolvablePreLysisDilutionVolumeTest,
			unknownCultureAdhesionTest,
			conflictingSamplesOutStorageConditionInSameContainerTest,
			conflictingPreLysisSupernatantStorageConditionInSameContainerTest,
			conflictingPostClarificationPelletStorageConditionInSameContainerTest
		}]
	}
];

(* ::Subsection::Closed:: *)
(* lyseCellsResourcePackets *)


(* --- lyseCellsResourcePackets --- *)

DefineOptions[
	lyseCellsResourcePackets,
	Options :> {HelperOutputOption,CacheOption,SimulationOption}
];

lyseCellsResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		resolvedOptionsNoHidden, outputSpecification, output, gatherTests,
		messages, inheritedCache, samplePackets, numberOfReplicatesNoNull, expandedSamplesWithNumReplicates, expandedSamplePacketsWithNumReplicates,
		expandForNumReplicates,

		expandedMethods,
		expandedCellTypes,
		expandedTargetCellularComponents,
		expandedCultureAdhesions,
		expandedDissociateBools,
		expandedNumbersOfLysisSteps,
		expandedTargetCellCounts,
		expandedTargetCellConcentrations,
		expandedAliquotBools,
		expandedAliquotAmounts,
		expandedPreLysisPelletBools,
		expandedPreLysisPelletingCentrifuges,
		expandedPreLysisPelletingIntensities,
		expandedPreLysisPelletingTimes,
		expandedPreLysisSupernatantVolumes,
		expandedPreLysisSupernatantStorageConditions,
		expandedPreLysisDiluteBools,
		expandedPreLysisDiluents,
		expandedPreLysisDilutionVolumes,
		expandedLysisSolutions,
		expandedLysisSolutionVolumes,
		expandedMixTypes,
		expandedMixRates,
		expandedMixTimes,
		expandedNumbersOfMixes,
		expandedMixVolumes,
		expandedMixTemperatures,
		expandedMixInstruments,
		expandedLysisTimes,
		expandedLysisTemperatures,
		expandedIncubationInstruments,
		expandedSecondaryLysisSolutions,
		expandedSecondaryLysisSolutionVolumes,
		expandedSecondaryMixTypes,
		expandedSecondaryMixRates,
		expandedSecondaryMixTimes,
		expandedSecondaryNumbersOfMixes,
		expandedSecondaryMixVolumes,
		expandedSecondaryMixTemperatures,
		expandedSecondaryMixInstruments,
		expandedSecondaryLysisTimes,
		expandedSecondaryLysisTemperatures,
		expandedSecondaryIncubationInstruments,
		expandedTertiaryLysisSolutions,
		expandedTertiaryLysisSolutionVolumes,
		expandedTertiaryMixTypes,
		expandedTertiaryMixRates,
		expandedTertiaryMixTimes,
		expandedTertiaryNumbersOfMixes,
		expandedTertiaryMixVolumes,
		expandedTertiaryMixTemperatures,
		expandedTertiaryMixInstruments,
		expandedTertiaryLysisTimes,
		expandedTertiaryLysisTemperatures,
		expandedTertiaryIncubationInstruments,
		expandedClarifyLysateBools,
		expandedClarifyLysateCentrifuges,
		expandedClarifyLysateIntensities,
		expandedClarifyLysateTimes,
		expandedClarifiedLysateVolumes,
		expandedPostClarificationPelletStorageConditions,
		expandedSamplesOutStorageConditions,

		userSpecifiedLabels, uniqueSamplesInResources, resolvedPreparation, samplesInResources, sampleContainersIn, uniqueSampleContainersInResources, containersInResources,
		protocolPacket, primitives, roboticUnitOperationPackets, roboticRunTime, roboticSimulation, outputUnitOperationPacket, allResourceBlobs, resourcesOk, resourceTests, previewRule,
		optionsRule, testsRule, resultRule, allUnitOperationPackets, currentSimulation, runTime, simulatedObjectsToLabel, expandedResolvedOptionsWithLabels
	},

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[ops], Cache, {}];

	(* Get the simulation *)
	currentSimulation = Lookup[ToList[ops], Simulation, {}];

	(* Lookup the resolved Preparation option. *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentLyseCells,
		RemoveHiddenOptions[ExperimentLyseCells, myResolvedOptions],
		Ignore -> myTemplatedOptions,
		Messages -> False
	];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Download *)
	samplePackets = Download[
		mySamples,
		Packet[Container, Position],
		Cache->inheritedCache,
		Simulation->currentSimulation
	];

	(* Get the number of replicates, replacing Null with 1 *)
	numberOfReplicatesNoNull = Lookup[myResolvedOptions, NumberOfReplicates] /. Null -> 1;

	(* Expand the samples and sample packets according to the number of replicates *)
	expandedSamplesWithNumReplicates = Flatten[Map[
		ConstantArray[#, numberOfReplicatesNoNull]&,
		Download[ToList[mySamples], Object]
	]];
	expandedSamplePacketsWithNumReplicates = Flatten[Map[
		ConstantArray[#, numberOfReplicatesNoNull]&,
		samplePackets
	]];

	(* We need to expand certain options according to the number of replicates; use the following helper function to do this. *)
	expandForNumReplicates[myOptions:{__Rule}, myOptionNames:{__Symbol}, myNumberOfReplicates_Integer]:=Module[
		{},
		Map[
			Function[{optionName},
				Flatten[Map[
					ConstantArray[#, myNumberOfReplicates]&,
					Lookup[myOptions, optionName]
				], 1] (* Flatten at level 1 to preserve lists in inputs, e.g, containers with indices *)
			],
			myOptionNames
		]
	];

	(* Expand options for no. of replicates except containers/labels/wells (which are already expanded) and non-indexed-matched options. *)
	{
		expandedMethods,
		expandedCellTypes,
		expandedTargetCellularComponents,
		expandedCultureAdhesions,
		expandedDissociateBools,
		expandedNumbersOfLysisSteps,
		expandedTargetCellCounts,
		expandedTargetCellConcentrations,
		expandedAliquotBools,
		expandedAliquotAmounts,
		expandedPreLysisPelletBools,
		expandedPreLysisPelletingCentrifuges,
		expandedPreLysisPelletingIntensities,
		expandedPreLysisPelletingTimes,
		expandedPreLysisSupernatantVolumes,
		expandedPreLysisSupernatantStorageConditions,
		expandedPreLysisDiluteBools,
		expandedPreLysisDiluents,
		expandedPreLysisDilutionVolumes,
		expandedLysisSolutions,
		expandedLysisSolutionVolumes,
		expandedMixTypes,
		expandedMixRates,
		expandedMixTimes,
		expandedNumbersOfMixes,
		expandedMixVolumes,
		expandedMixTemperatures,
		expandedMixInstruments,
		expandedLysisTimes,
		expandedLysisTemperatures,
		expandedIncubationInstruments,
		expandedSecondaryLysisSolutions,
		expandedSecondaryLysisSolutionVolumes,
		expandedSecondaryMixTypes,
		expandedSecondaryMixRates,
		expandedSecondaryMixTimes,
		expandedSecondaryNumbersOfMixes,
		expandedSecondaryMixVolumes,
		expandedSecondaryMixTemperatures,
		expandedSecondaryMixInstruments,
		expandedSecondaryLysisTimes,
		expandedSecondaryLysisTemperatures,
		expandedSecondaryIncubationInstruments,
		expandedTertiaryLysisSolutions,
		expandedTertiaryLysisSolutionVolumes,
		expandedTertiaryMixTypes,
		expandedTertiaryMixRates,
		expandedTertiaryMixTimes,
		expandedTertiaryNumbersOfMixes,
		expandedTertiaryMixVolumes,
		expandedTertiaryMixTemperatures,
		expandedTertiaryMixInstruments,
		expandedTertiaryLysisTimes,
		expandedTertiaryLysisTemperatures,
		expandedTertiaryIncubationInstruments,
		expandedClarifyLysateBools,
		expandedClarifyLysateCentrifuges,
		expandedClarifyLysateIntensities,
		expandedClarifyLysateTimes,
		expandedClarifiedLysateVolumes,
		expandedPostClarificationPelletStorageConditions,
		expandedSamplesOutStorageConditions
	} = expandForNumReplicates[
		myResolvedOptions,
		{
			Method,
			CellType,
			TargetCellularComponent,
			CultureAdhesion,
			Dissociate,
			NumberOfLysisSteps,
			TargetCellCount,
			TargetCellConcentration,
			Aliquot,
			AliquotAmount,
			PreLysisPellet,
			PreLysisPelletingCentrifuge,
			PreLysisPelletingIntensity,
			PreLysisPelletingTime,
			PreLysisSupernatantVolume,
			PreLysisSupernatantStorageCondition,
			PreLysisDilute,
			PreLysisDiluent,
			PreLysisDilutionVolume,
			LysisSolution,
			LysisSolutionVolume,
			MixType,
			MixRate,
			MixTime,
			NumberOfMixes,
			MixVolume,
			MixTemperature,
			MixInstrument,
			LysisTime,
			LysisTemperature,
			IncubationInstrument,
			SecondaryLysisSolution,
			SecondaryLysisSolutionVolume,
			SecondaryMixType,
			SecondaryMixRate,
			SecondaryMixTime,
			SecondaryNumberOfMixes,
			SecondaryMixVolume,
			SecondaryMixTemperature,
			SecondaryMixInstrument,
			SecondaryLysisTime,
			SecondaryLysisTemperature,
			SecondaryIncubationInstrument,
			TertiaryLysisSolution,
			TertiaryLysisSolutionVolume,
			TertiaryMixType,
			TertiaryMixRate,
			TertiaryMixTime,
			TertiaryNumberOfMixes,
			TertiaryMixVolume,
			TertiaryMixTemperature,
			TertiaryMixInstrument,
			TertiaryLysisTime,
			TertiaryLysisTemperature,
			TertiaryIncubationInstrument,
			ClarifyLysate,
			ClarifyLysateCentrifuge,
			ClarifyLysateIntensity,
			ClarifyLysateTime,
			ClarifiedLysateVolume,
			PostClarificationPelletStorageCondition,
			SamplesOutStorageCondition
		},
		numberOfReplicatesNoNull
	];

	(* Expand options for number of replicates. *)
	$ExpandedOptionsForNumReplicates = Normal @ Join[
		(* Containers, Wells, and Label options were expanded for number of replicates during resolving, so we don't do anything special with them here. *)
		Association@{
			AliquotContainer -> Lookup[myResolvedOptions, AliquotContainer],
			AliquotContainerWell -> Lookup[myResolvedOptions, AliquotContainerWell],
			ClarifiedLysateContainer -> Lookup[myResolvedOptions, ClarifiedLysateContainer],
			ClarifiedLysateContainerWell -> Lookup[myResolvedOptions, ClarifiedLysateContainerWell],
			PreLysisSupernatantContainer -> Lookup[myResolvedOptions, PreLysisSupernatantContainer],
			PreLysisSupernatantContainerWell -> Lookup[myResolvedOptions, PreLysisSupernatantContainerWell],
			PostClarificationPelletContainer -> Lookup[myResolvedOptions, PostClarificationPelletContainer],
			PostClarificationPelletContainerWell -> Lookup[myResolvedOptions, PostClarificationPelletContainerWell],
			SampleOutLabel -> Lookup[myResolvedOptions, SampleOutLabel],
			AliquotContainerLabel -> Lookup[myResolvedOptions, AliquotContainerLabel],
			ClarifiedLysateContainerLabel -> Lookup[myResolvedOptions, ClarifiedLysateContainerLabel],
			PreLysisSupernatantLabel -> Lookup[myResolvedOptions, PreLysisSupernatantLabel],
			PreLysisSupernatantContainerLabel -> Lookup[myResolvedOptions, PreLysisSupernatantContainerLabel],
			PostClarificationPelletLabel -> Lookup[myResolvedOptions, PostClarificationPelletLabel],
			PostClarificationPelletContainerLabel -> Lookup[myResolvedOptions, PostClarificationPelletContainerLabel]
		},
		(* Options without index-matching do not need to be expanded for number of replicates. *)
		Association@{
			WorkCell -> Lookup[myResolvedOptions, WorkCell],
			RoboticInstrument -> Lookup[myResolvedOptions, RoboticInstrument],
			NumberOfReplicates -> Lookup[myResolvedOptions, NumberOfReplicates],
			ImageSample -> Lookup[myResolvedOptions, ImageSample],
			MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
			MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
			Email -> Lookup[myResolvedOptions, Email]
		},
		(* Remaining options were expanded for number of replicates earlier in the resource packets function *)
		Association@{
			CellType -> expandedCellTypes,
			TargetCellularComponent -> expandedTargetCellularComponents,
			Method -> expandedMethods,
			CultureAdhesion -> expandedCultureAdhesions,
			NumberOfLysisSteps -> expandedNumbersOfLysisSteps,
			Aliquot -> expandedAliquotBools,
			AliquotAmount -> expandedAliquotAmounts,
			Dissociate -> expandedDissociateBools,
			PreLysisPellet -> expandedPreLysisPelletBools,
			PreLysisPelletingCentrifuge -> expandedPreLysisPelletingCentrifuges,
			PreLysisPelletingIntensity -> expandedPreLysisPelletingIntensities,
			PreLysisPelletingTime -> expandedPreLysisPelletingTimes,
			PreLysisSupernatantVolume -> expandedPreLysisSupernatantVolumes,
			PreLysisSupernatantStorageCondition -> expandedPreLysisSupernatantStorageConditions,
			PreLysisDilute -> expandedPreLysisDiluteBools,
			PreLysisDiluent -> expandedPreLysisDiluents,
			PreLysisDilutionVolume -> expandedPreLysisDilutionVolumes,
			TargetCellCount -> expandedTargetCellCounts,
			TargetCellConcentration -> expandedTargetCellConcentrations,
			LysisSolution -> expandedLysisSolutions,
			LysisSolutionVolume -> expandedLysisSolutionVolumes,
			MixType -> expandedMixTypes,
			MixRate -> expandedMixRates,
			MixTime -> expandedMixTimes,
			MixVolume -> expandedMixVolumes,
			NumberOfMixes -> expandedNumbersOfMixes,
			MixTemperature -> expandedMixTemperatures,
			LysisTemperature -> expandedLysisTemperatures,
			LysisTime -> expandedLysisTimes,
			MixInstrument -> expandedMixInstruments,
			IncubationInstrument -> expandedIncubationInstruments,
			SecondaryLysisSolution -> expandedSecondaryLysisSolutions,
			SecondaryLysisSolutionVolume -> expandedSecondaryLysisSolutionVolumes,
			SecondaryMixType -> expandedSecondaryMixTypes,
			SecondaryMixRate -> expandedSecondaryMixRates,
			SecondaryMixTime -> expandedSecondaryMixTimes,
			SecondaryMixVolume -> expandedSecondaryMixVolumes,
			SecondaryNumberOfMixes -> expandedSecondaryNumbersOfMixes,
			SecondaryMixTemperature -> expandedSecondaryMixTemperatures,
			SecondaryLysisTemperature -> expandedSecondaryLysisTemperatures,
			SecondaryLysisTime -> expandedSecondaryLysisTimes,
			SecondaryMixInstrument -> expandedSecondaryMixInstruments,
			SecondaryIncubationInstrument -> expandedSecondaryIncubationInstruments,
			TertiaryLysisSolution -> expandedTertiaryLysisSolutions,
			TertiaryLysisSolutionVolume -> expandedTertiaryLysisSolutionVolumes,
			TertiaryMixType -> expandedTertiaryMixTypes,
			TertiaryMixRate -> expandedTertiaryMixRates,
			TertiaryMixTime -> expandedTertiaryMixTimes,
			TertiaryMixVolume -> expandedTertiaryMixVolumes,
			TertiaryNumberOfMixes -> expandedTertiaryNumbersOfMixes,
			TertiaryMixTemperature -> expandedTertiaryMixTemperatures,
			TertiaryLysisTemperature -> expandedTertiaryLysisTemperatures,
			TertiaryLysisTime -> expandedTertiaryLysisTimes,
			TertiaryMixInstrument -> expandedTertiaryMixInstruments,
			TertiaryIncubationInstrument -> expandedTertiaryIncubationInstruments,
			ClarifyLysate -> expandedClarifyLysateBools,
			ClarifyLysateCentrifuge -> expandedClarifyLysateCentrifuges,
			ClarifyLysateIntensity -> expandedClarifyLysateIntensities,
			ClarifyLysateTime -> expandedClarifyLysateTimes,
			ClarifiedLysateVolume -> expandedClarifiedLysateVolumes,
			PostClarificationPelletStorageCondition -> expandedPostClarificationPelletStorageConditions,
			SamplesOutStorageCondition -> expandedSamplesOutStorageConditions
		}
	];

	(* Create resources for our samples in. *)
	uniqueSamplesInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&)/@DeleteDuplicates[Download[mySamples, Object]];
	samplesInResources = (Download[expandedSamplesWithNumReplicates, Object])/.uniqueSamplesInResources;

	(* Create resources for our containers in. *)
	sampleContainersIn = Lookup[expandedSamplePacketsWithNumReplicates, Container];
	uniqueSampleContainersInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&)/@DeleteDuplicates[sampleContainersIn];
	containersInResources = (Download[sampleContainersIn, Object]) /. uniqueSampleContainersInResources;

	(* Get our user specified labels. *)
	userSpecifiedLabels = DeleteDuplicates@Cases[
		Flatten@Lookup[
			myResolvedOptions,
			{PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel, PostClarificationPelletLabel, PostClarificationPelletContainerLabel, ClarifiedLysateContainerLabel, SampleOutLabel}
		],
		_String
	];

	(* --- Create the protocol packet --- *)
	(* Make unit operation packets for the UOs we just made here *)
	{protocolPacket, allUnitOperationPackets, currentSimulation, runTime} = Module[
		{
			sampleLabels, aliquotContainers, aliquotContainerLabels, sampleContainers, sampleContainerLabels, preLysisSupernatantContainerLabels,
			postClarificationPelletContainerLabels, clarifiedLysateContainers, clarifiedLysateContainerLabels, workingContainerLabels, workingContainerWells,
			lysateOutContainerWells, lysateOutContainerLabels, labelSampleAndContainerUnitOperations,
			aliquotUnitOperations, preLysisPelletUnitOperations, diluteUnitOperations, lysisUnitOperations, clarifyLysateUnitOperations, labelSampleUnitOperation,
			preLysisSupernatantContainers, postClarificationPelletContainers
		},

		(* Create a list of sample in labels to be used internally *)
		sampleLabels = Table[
			CreateUniqueLabel["lyse cells sample in", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
			{x, 1, Length[expandedSamplesWithNumReplicates]}
		];

		(* Create an index matched (to samples) list of aliquot container labels. *)
		(* We don't want to assign multiple labels to the same container. To prevent this, we give certain aliquot containers a *)
		(* PostClarificationPelletContainer label if they will end up being the same physical container.  *)
		{aliquotContainers, aliquotContainerLabels} = Transpose @ MapThread[
				Function[{aliquotContainer, aliquotContainerLabel, clarifiedLysateVolume, postClarificationPelletContainerLabel},
					Which[
						(* If there's no AliquotContainer, both the container and label are Null *)
						MatchQ[aliquotContainer, Null],
							{Null, Null},
						(* If the lysate will be clarified and transferred off, set to null and use the PostClarificationPelletContainerLabel *)
						MatchQ[clarifiedLysateVolume, GreaterP[0 Microliter]],
							{aliquotContainer, postClarificationPelletContainerLabel},
						(* For the remaining cases, use the AliquotContainer and AliquotContainerLabel *)
						True,
							{aliquotContainer, aliquotContainerLabel}
					]
				],
				{
					Lookup[myResolvedOptions, AliquotContainer],
					Lookup[myResolvedOptions, AliquotContainerLabel],
					expandedClarifiedLysateVolumes,
					Lookup[myResolvedOptions, PostClarificationPelletContainerLabel]
				}
		];

		(* Create an index matched (to samples) list of sample container labels. *)
		(* We don't have a SampleContainerLabel option, so we just make labels ourselves. *)
		{sampleContainers, sampleContainerLabels} = Module[
			{allSampleContainers, uniqueSampleContainers, uniqueSampleContainerLabels, uniqueSampleContainersToLabelsLookup},

			(* Get all unique sample containers and label each of them. *)
			allSampleContainers = Cases[
				LinkedObject /@ Lookup[expandedSamplePacketsWithNumReplicates, Container],
				ObjectP[Object[Container]]
			];
			uniqueSampleContainers = DeleteDuplicates @ allSampleContainers;
			uniqueSampleContainerLabels = Table[
				CreateUniqueLabel["lyse cells sample in container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
				{x, 1, Length[uniqueSampleContainers]}
			];

			uniqueSampleContainersToLabelsLookup = Association[Rule@@@Transpose[{uniqueSampleContainers, uniqueSampleContainerLabels}]];

			Transpose @ Map[
				Function[{sampleContainer},
					{sampleContainer, Lookup[uniqueSampleContainersToLabelsLookup, Key[sampleContainer]]}
				],
				allSampleContainers
			]
		];

		(* Get the containers and container labels from the resolved options *)
		preLysisSupernatantContainers = Lookup[myResolvedOptions, PreLysisSupernatantContainer];
		preLysisSupernatantContainerLabels = Lookup[myResolvedOptions, PreLysisSupernatantContainerLabel];
		postClarificationPelletContainers = Lookup[myResolvedOptions, PostClarificationPelletContainer];
		postClarificationPelletContainerLabels = Lookup[myResolvedOptions, PostClarificationPelletContainerLabel];
		clarifiedLysateContainers = Lookup[myResolvedOptions, ClarifiedLysateContainer];
		clarifiedLysateContainerLabels = Lookup[myResolvedOptions, ClarifiedLysateContainerLabel];

		(* Define working container wells and labels, which depend on the aliquot bool *)
		workingContainerWells = MapThread[
			Function[{aliquotContainerWell, sampleWell},
				If[MatchQ[aliquotContainerWell, Null],
					sampleWell,
					aliquotContainerWell
				]
			],
			{Lookup[myResolvedOptions, AliquotContainerWell], Lookup[expandedSamplePacketsWithNumReplicates, Position]}
		];
		workingContainerLabels = MapThread[
			Function[{aliquotContainerLabel, sampleContainerLabel},
				If[MatchQ[aliquotContainerLabel, Null],
					sampleContainerLabel,
					aliquotContainerLabel
				]
			],
			{aliquotContainerLabels, sampleContainerLabels}
		];

		(* Define lysate out container wells and labels, which depend on the clarify lysate bool *)
		lysateOutContainerWells = MapThread[
			Function[{clarifiedLysateContainerWell, workingContainerWell},
				If[MatchQ[clarifiedLysateContainerWell, Null],
					workingContainerWell,
					clarifiedLysateContainerWell
				]
			],
			{Lookup[myResolvedOptions, ClarifiedLysateContainerWell], workingContainerWells}
		];
		lysateOutContainerLabels = MapThread[
			Function[{clarifiedLysateContainerLabel, workingContainerLabel},
				If[MatchQ[clarifiedLysateContainerLabel, Null],
					workingContainerLabel,
					clarifiedLysateContainerLabel
				]
			],
			{Lookup[myResolvedOptions, ClarifiedLysateContainerLabel], workingContainerLabels}
		];

		(* LabelContainer and LabelSample *)
		labelSampleAndContainerUnitOperations = Flatten @ {

			(* Sample in Labels *)
			LabelSample[
				Label -> sampleLabels,
				Sample -> expandedSamplesWithNumReplicates
			],

			(* Sample Container Labels *)
			LabelContainer[
				Label -> DeleteDuplicates[sampleContainerLabels],
				Container -> DeleteDuplicates[LinkedObject /@ Lookup[expandedSamplePacketsWithNumReplicates, Container]]
			],

			(* Aliquot Container Labels. *)
			Module[{uniqueAliquotContainersAndLabels},
				uniqueAliquotContainersAndLabels = Cases[
					DeleteDuplicates[Transpose[{aliquotContainers, aliquotContainerLabels}]],
					Except[{Null, Null}]
				];

				If[Length[uniqueAliquotContainersAndLabels] > 0,
					LabelContainer[
						Label -> uniqueAliquotContainersAndLabels[[All, 2]],
						Container->(If[MatchQ[#, {_Integer, ObjectP[]}], #[[2]], #]&)/@uniqueAliquotContainersAndLabels[[All,1]]
					],
					Nothing
				]
			],

			(* PreLysisSupernatantContainer Labels. *)
			Module[{uniquePreLysisSupernatantContainersAndLabels},
				uniquePreLysisSupernatantContainersAndLabels = Cases[
					DeleteDuplicates[Transpose[{preLysisSupernatantContainers, preLysisSupernatantContainerLabels}]],
					Except[{Null, Null}]
				];

				If[Length[uniquePreLysisSupernatantContainersAndLabels] > 0,
					LabelContainer[
						Label -> uniquePreLysisSupernatantContainersAndLabels[[All, 2]],
						Container->(If[MatchQ[#, {_Integer, ObjectP[]}], #[[2]], #]&)/@uniquePreLysisSupernatantContainersAndLabels[[All,1]]
					],
					Nothing
				]
			],

			(* PostClarificationPelletContainer Labels. *)
			Module[{uniquePostClarificationPelletContainersAndLabels},
				uniquePostClarificationPelletContainersAndLabels = Cases[
					DeleteDuplicates[Transpose[{postClarificationPelletContainers, postClarificationPelletContainerLabels}]],
					Except[{Null, Null}]
				];

				If[Length[uniquePostClarificationPelletContainersAndLabels] > 0,
					LabelContainer[
						Label -> uniquePostClarificationPelletContainersAndLabels[[All,2]],
						Container->(If[MatchQ[#, {_Integer, ObjectP[]}], #[[2]], #]&)/@uniquePostClarificationPelletContainersAndLabels[[All,1]]
					],
					Nothing
				]
			],

			(* ClarifiedLysateContainer Labels. *)
			Module[{uniqueClarifiedLysateContainersAndLabels},
				uniqueClarifiedLysateContainersAndLabels = Cases[
					DeleteDuplicates[Transpose[{clarifiedLysateContainers, clarifiedLysateContainerLabels}]],
					Except[{Null, Null}]
				];

				If[Length[uniqueClarifiedLysateContainersAndLabels] > 0,
					LabelContainer[
						Label -> uniqueClarifiedLysateContainersAndLabels[[All,2]],
						Container->(If[MatchQ[#, {_Integer, ObjectP[]}], #[[2]], #]&)/@uniqueClarifiedLysateContainersAndLabels[[All,1]]
					],
					Nothing
				]
			]
		};

		(* Aliquot unit ops aliquot the AliquotAmount of sample into AliquotContainer, if specified *)
		aliquotUnitOperations = MapThread[
			Function[{aliquotContainerLabel, aliquotContainerWell, aliquotAmount, sample},
				If[MatchQ[aliquotAmount, GreaterP[0 Microliter]],
					Transfer[
						Source -> sample,
						Destination -> aliquotContainerLabel,
						DestinationWell -> aliquotContainerWell,
						Amount -> aliquotAmount
					],
					Nothing
				]
			],
			{
				aliquotContainerLabels,
				Lookup[myResolvedOptions, AliquotContainerWell],
				expandedAliquotAmounts,
				sampleLabels
			}
		];

		(* If PreLysisPellet is True, PreLysisPellet UOs centrifuge the sample and then remove the supernatant *)
		preLysisPelletUnitOperations = Module[{centrifuge, supernatantTransfer},

			centrifuge = If[
				MemberQ[expandedPreLysisPelletBools, True],
				Centrifuge[
					Sample -> PickList[workingContainerLabels, expandedPreLysisPelletBools],
					Instrument -> PickList[expandedPreLysisPelletingCentrifuges, expandedPreLysisPelletBools],
					Intensity -> PickList[expandedPreLysisPelletingIntensities, expandedPreLysisPelletBools],
					Time -> PickList[expandedPreLysisPelletingTimes, expandedPreLysisPelletBools]
				],
				Nothing
			];

			supernatantTransfer = MapThread[
				Function[
					{
						workingSampleContainerLabel,
						workingSampleContainerWell,
						preLysisPelletBool,
						preLysisSupernatantContainerLabel,
						preLysisSupernatantContainerWell,
						preLysisSupernatantLabel,
						preLysisSupernatantVolume,
						supernatantStorageCondition
					},
					If[MatchQ[preLysisPelletBool, True],
						Transfer[
							Source -> {workingSampleContainerWell, workingSampleContainerLabel},
							Destination -> preLysisSupernatantContainerLabel,
							DestinationWell -> preLysisSupernatantContainerWell,
							DestinationLabel -> preLysisSupernatantLabel,
							Amount -> preLysisSupernatantVolume,
							SamplesOutStorageCondition -> supernatantStorageCondition
						],
						Nothing
					]
				],
				{
					workingContainerLabels,
					workingContainerWells,
					expandedPreLysisPelletBools,
					Lookup[myResolvedOptions, PreLysisSupernatantContainerLabel],
					Lookup[myResolvedOptions, PreLysisSupernatantContainerWell],
					Lookup[myResolvedOptions, PreLysisSupernatantLabel],
					expandedPreLysisSupernatantVolumes,
					expandedPreLysisSupernatantStorageConditions
				}
			];

			Flatten[{centrifuge, supernatantTransfer}]

		];

		(* Dilute unit ops, if specified, dilute the sample or AliquotAmount to a specified total volume using the specified diluent *)
		diluteUnitOperations = MapThread[
			Function[{workingSampleContainerLabel, workingSampleContainerWell, diluteBool, diluent, dilutionVolume},
				If[MatchQ[diluteBool, True],
					(* Use a Transfer primitive instead of a Dilute primitive so we don't have to calculate the working volume for this *)
					Transfer[
						Source -> diluent,
						Destination -> workingSampleContainerLabel,
						DestinationWell -> workingSampleContainerWell,
						Amount -> dilutionVolume
					],
					Nothing
				]
			],
			{
				workingContainerLabels,
				workingContainerWells,
				expandedPreLysisDiluteBools,
				expandedPreLysisDiluents,
				expandedPreLysisDilutionVolumes
			}
		];

		(* Lysis unit operations must accomplish the following: *)
		(* Add lysis solution to the sample or aliquoted amount of the sample. *)
		(* Mix the sample + lysis solution using the resolved mix conditions. *)
		(* Incubate the above under the resolved incubation conditions. *)
		(* If NumberOfLysisSteps is two or three, repeat the above accordingly. *)
		lysisUnitOperations = Module[
			{
				addLysisSolution, mix, incubate, wait, addSecondaryLysisSolution, secondaryMix, secondaryIncubate,
				secondaryWait, addTertiaryLysisSolution, tertiaryMix, tertiaryIncubate, tertiaryWait
			},

			(* Add lysis solution in the first lysis step *)
			addLysisSolution = MapThread[
				Function[{lysisSolution, workingSampleContainerLabel, workingSampleContainerWell, lysisSolutionVolume},
					Transfer[
						Source -> lysisSolution,
						Destination -> workingSampleContainerLabel,
						DestinationWell -> workingSampleContainerWell,
						Amount -> lysisSolutionVolume,
						LivingDestination -> False (* The sample is considered to be not living upon addition of lysis solutions *)
					]
				],
				{
					expandedLysisSolutions,
					workingContainerLabels,
					workingContainerWells,
					expandedLysisSolutionVolumes
				}
			];

			(* Mix in the first lysis step *)
			mix = If[
				MemberQ[expandedMixTypes, Except[Null|None]],
				Mix[
					Sample -> Transpose[{
						PickList[workingContainerWells, expandedMixTypes, Except[Null|None]],
						PickList[workingContainerLabels, expandedMixTypes, Except[Null|None]]
					}],
					MixType -> PickList[expandedMixTypes, expandedMixTypes, Except[Null|None]],
					Time -> PickList[expandedMixTimes, expandedMixTypes, Except[Null|None]],
					MixRate -> PickList[expandedMixRates, expandedMixTypes, Except[Null|None]],
					NumberOfMixes -> PickList[expandedNumbersOfMixes, expandedMixTypes, Except[Null|None]],
					MixVolume -> PickList[expandedMixVolumes, expandedMixTypes, Except[Null|None]],
					Temperature -> (PickList[expandedMixTemperatures, expandedMixTypes, Except[Null|None]]/.Ambient -> $AmbientTemperature)
				],
				Nothing
			];

			(* Incubate the samples that have non Ambient temperatures *)
			incubate = If[
				MemberQ[expandedLysisTemperatures,NonAmbientTemperatureP],
				Incubate[
					Sample -> Transpose[{
						PickList[workingContainerWells, expandedLysisTemperatures, NonAmbientTemperatureP],
						PickList[workingContainerLabels, expandedLysisTemperatures, NonAmbientTemperatureP]
					}],
					Temperature -> (PickList[expandedLysisTemperatures, expandedLysisTemperatures, NonAmbientTemperatureP]),
					Time -> PickList[expandedLysisTimes, expandedLysisTemperatures, NonAmbientTemperatureP]
				],
				Nothing
			];

			(* Wait for the samples that have ambient temperatures *)
			wait = If[
				MemberQ[expandedLysisTemperatures, AmbientTemperatureP],
				Wait[
					Duration -> Max[PickList[expandedLysisTimes, expandedLysisTemperatures, AmbientTemperatureP]]
				],
				Nothing
			];

			(* Add lysis solution in the optional second lysis step *)
			addSecondaryLysisSolution = MapThread[
				Function[{lysisSolution, workingSampleContainerLabel, workingSampleContainerWell, lysisSolutionVolume},
					If[MatchQ[lysisSolutionVolume, VolumeP],
						Transfer[
							Source -> lysisSolution,
							Destination -> workingSampleContainerLabel,
							DestinationWell -> workingSampleContainerWell,
							Amount -> lysisSolutionVolume,
							LivingDestination -> False (* The sample is considered to be not living upon addition of lysis solutions *)
						],
						Nothing
					]
				],
				{
					expandedSecondaryLysisSolutions,
					workingContainerLabels,
					workingContainerWells,
					expandedSecondaryLysisSolutionVolumes
				}
			];

			(* Mix in the optional second lysis step *)
			secondaryMix = If[
				MemberQ[expandedSecondaryMixTypes, Except[Null|None]],
				Mix[
					Sample -> Transpose[{
						PickList[workingContainerWells, expandedSecondaryMixTypes, Except[Null|None]],
						PickList[workingContainerLabels, expandedSecondaryMixTypes, Except[Null|None]]
					}],
					MixType -> PickList[expandedSecondaryMixTypes, expandedSecondaryMixTypes, Except[Null|None]],
					Time -> PickList[expandedSecondaryMixTimes, expandedSecondaryMixTypes, Except[Null|None]],
					MixRate -> PickList[expandedSecondaryMixRates, expandedSecondaryMixTypes, Except[Null|None]],
					NumberOfMixes -> PickList[expandedSecondaryNumbersOfMixes, expandedSecondaryMixTypes, Except[Null|None]],
					MixVolume -> PickList[expandedSecondaryMixVolumes, expandedSecondaryMixTypes, Except[Null|None]],
					Temperature -> (PickList[expandedSecondaryMixTemperatures, expandedSecondaryMixTypes, Except[Null|None]]/.Ambient -> $AmbientTemperature)
				],
				Nothing
			];

			(* Incubate in the optional second lysis step the samples that have non Ambient temperatures *)
			secondaryIncubate = If[
				MemberQ[expandedSecondaryLysisTemperatures, NonAmbientTemperatureP],
				Incubate[
					Sample -> Transpose[{
						PickList[workingContainerWells, expandedSecondaryLysisTemperatures, NonAmbientTemperatureP],
						PickList[workingContainerLabels, expandedSecondaryLysisTemperatures, NonAmbientTemperatureP]
					}],
					Temperature -> (PickList[expandedSecondaryLysisTemperatures, expandedSecondaryLysisTemperatures, NonAmbientTemperatureP]),
					Time -> PickList[expandedSecondaryLysisTimes, expandedSecondaryLysisTemperatures, NonAmbientTemperatureP]
				],
				Nothing
			];

			(* Wait for the samples that have ambient temperatures *)
			secondaryWait = If[
				MemberQ[expandedSecondaryLysisTemperatures, AmbientTemperatureP],
				Wait[
					Duration -> Max[PickList[expandedSecondaryLysisTimes, expandedSecondaryLysisTemperatures, AmbientTemperatureP]]
				],
				Nothing
			];

			(* Add lysis solution in the optional third lysis step *)
			addTertiaryLysisSolution = MapThread[
				Function[{lysisSolution, workingSampleContainerLabel, workingSampleContainerWell, lysisSolutionVolume},
					If[MatchQ[lysisSolutionVolume, VolumeP],
						Transfer[
							Source -> lysisSolution,
							Destination -> workingSampleContainerLabel,
							DestinationWell -> workingSampleContainerWell,
							Amount -> lysisSolutionVolume,
							LivingDestination -> False (* The sample is considered to be not living upon addition of lysis solutions *)
						],
						Nothing
					]
				],
				{
					expandedTertiaryLysisSolutions,
					workingContainerLabels,
					workingContainerWells,
					expandedTertiaryLysisSolutionVolumes
				}
			];

			(* Mix in the optional third lysis step *)
			tertiaryMix = If[
				MemberQ[expandedTertiaryMixTypes, Except[Null|None]],
				Mix[
					Sample -> Transpose[{
						PickList[workingContainerWells, expandedTertiaryMixTypes, Except[Null|None]],
						PickList[workingContainerLabels, expandedTertiaryMixTypes, Except[Null|None]]
					}],
					MixType -> PickList[expandedTertiaryMixTypes, expandedTertiaryMixTypes, Except[Null|None]],
					Time -> PickList[expandedTertiaryMixTimes, expandedTertiaryMixTypes, Except[Null|None]],
					MixRate -> PickList[expandedTertiaryMixRates, expandedTertiaryMixTypes, Except[Null|None]],
					NumberOfMixes -> PickList[expandedTertiaryNumbersOfMixes, expandedTertiaryMixTypes, Except[Null|None]],
					MixVolume -> PickList[expandedTertiaryMixVolumes, expandedTertiaryMixTypes, Except[Null|None]],
					Temperature -> (PickList[expandedTertiaryMixTemperatures, expandedTertiaryMixTypes, Except[Null|None]]/.Ambient -> $AmbientTemperature)
				],
				Nothing
			];

			(* Incubate in the optional third lysis step the samples that have non Ambient temperatures *)
			tertiaryIncubate = If[
				MemberQ[expandedTertiaryLysisTemperatures, NonAmbientTemperatureP],
				Incubate[
					Sample -> Transpose[{
						PickList[workingContainerWells, expandedTertiaryLysisTemperatures, NonAmbientTemperatureP],
						PickList[workingContainerLabels, expandedTertiaryLysisTemperatures, NonAmbientTemperatureP]
					}],
					Temperature -> (PickList[expandedTertiaryLysisTemperatures, expandedTertiaryLysisTemperatures, NonAmbientTemperatureP]),
					Time -> PickList[expandedTertiaryLysisTimes, expandedTertiaryLysisTemperatures, NonAmbientTemperatureP]
				],
				Nothing
			];

			(* Wait for the samples in the optional third lysis that have ambient temperatures *)
			tertiaryWait = If[
				MemberQ[expandedTertiaryLysisTemperatures, AmbientTemperatureP],
				Wait[
					Duration -> Max[PickList[expandedTertiaryLysisTimes, expandedTertiaryLysisTemperatures, AmbientTemperatureP]]
				],
				Nothing
			];

			Flatten[{
				addLysisSolution,
				mix,
				incubate,
				wait,
				addSecondaryLysisSolution,
				secondaryMix,
				secondaryIncubate,
				secondaryWait,
				addTertiaryLysisSolution,
				tertiaryMix,
				tertiaryIncubate,
				tertiaryWait
			}]

		];

		(* If ClarifyLysate is True, ClarifyLysate UOs centrifuge the sample and then transfer off the (lysate) supernatant *)
		clarifyLysateUnitOperations = Module[{centrifuge, supernatantTransfer},

			centrifuge = If[
				MemberQ[expandedClarifyLysateBools, True],
				Centrifuge[
					Sample -> PickList[workingContainerLabels, expandedClarifyLysateBools],
					Instrument -> PickList[expandedClarifyLysateCentrifuges, expandedClarifyLysateBools],
					Intensity -> PickList[expandedClarifyLysateIntensities, expandedClarifyLysateBools],
					Time -> PickList[expandedClarifyLysateTimes, expandedClarifyLysateBools]
				],
				Nothing
			];

			supernatantTransfer = MapThread[
				Function[
					{
						workingSampleContainerLabel,
						workingSampleContainerWell,
						clarifyLysateBool,
						clarifiedLysateContainerLabel,
						clarifiedLysateContainerWell,
						sampleOutLabel,
						clarifiedLysateVolume,
						pelletStorageCondition
					},
					If[MatchQ[clarifyLysateBool, True],
						Transfer[
							Source -> {workingSampleContainerWell, workingSampleContainerLabel},
							Destination -> clarifiedLysateContainerLabel,
							DestinationWell -> clarifiedLysateContainerWell,
							DestinationLabel -> sampleOutLabel,
							Amount -> clarifiedLysateVolume,
							SamplesInStorageCondition -> pelletStorageCondition
						],
						Nothing
					]
				],
				{
					workingContainerLabels,
					workingContainerWells,
					expandedClarifyLysateBools,
					Lookup[myResolvedOptions, ClarifiedLysateContainerLabel],
					Lookup[myResolvedOptions, ClarifiedLysateContainerWell],
					Lookup[myResolvedOptions, SampleOutLabel],
					expandedClarifiedLysateVolumes,
					expandedPostClarificationPelletStorageConditions
				}
			];

			Flatten[{centrifuge, supernatantTransfer}]

		];

		labelSampleUnitOperation = Module[{sampleOut, postClarificationPellet, preLysisSupernatant},

			sampleOut = MapThread[
				Function[{sampleLabel, well, containerLabel, storageCondition},
					LabelSample[
						Sample -> {well, containerLabel},
						Label -> sampleLabel,
						StorageCondition -> storageCondition
					]
				],
				{
					Lookup[myResolvedOptions, SampleOutLabel],
					lysateOutContainerWells,
					lysateOutContainerLabels,
					expandedSamplesOutStorageConditions
				}
			];

			postClarificationPellet = MapThread[
				Function[{clarifyLysateBool, pelletLabel, well, containerLabel, storageCondition},
					If[MatchQ[clarifyLysateBool, True],
						LabelSample[
							Sample -> {well, containerLabel},
							Label -> pelletLabel,
							StorageCondition -> storageCondition
						],
						Nothing
					]
				],
				{
					expandedClarifyLysateBools,
					Lookup[myResolvedOptions, PostClarificationPelletLabel],
					Lookup[myResolvedOptions, PostClarificationPelletContainerWell],
					postClarificationPelletContainerLabels,
					expandedPostClarificationPelletStorageConditions
				}
			];

			preLysisSupernatant = MapThread[
				Function[{preLysisPelletBool, supernatantLabel, well, containerLabel, storageCondition},
					If[MatchQ[preLysisPelletBool, True],
						LabelSample[
							Sample -> {well, containerLabel},
							Label -> supernatantLabel,
							StorageCondition -> storageCondition
						],
						Nothing
					]
				],
				{
					expandedPreLysisPelletBools,
					Lookup[myResolvedOptions, PreLysisSupernatantLabel],
					Lookup[myResolvedOptions, PreLysisSupernatantContainerWell],
					preLysisSupernatantContainerLabels,
					expandedPreLysisSupernatantStorageConditions
				}
			];

			Flatten[{sampleOut, postClarificationPellet, preLysisSupernatant}]

		];

		(* Combine all the unit operations *)
		primitives = Flatten[{
			labelSampleAndContainerUnitOperations,
			aliquotUnitOperations,
			preLysisPelletUnitOperations,
			diluteUnitOperations,
			lysisUnitOperations,
			clarifyLysateUnitOperations,
			labelSampleUnitOperation
		}];

		(* Set this internal variable to unit test the unit operations that are created by this function. *)
		$LyseCellsUnitOperations = primitives;

		(* Determine which objects in the simulation are simulated and make replace rules for those *)
		simulatedObjectsToLabel = If[NullQ[currentSimulation],
			{},
			Module[{allObjectsInSimulation, simulatedQ},
				(* Get all objects out of our simulation. *)
				allObjectsInSimulation = Download[Lookup[currentSimulation[[1]], Labels][[All, 2]], Object];

				(* Figure out which objects are simulated. *)
				simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, currentSimulation];

				(Reverse /@ PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
			]
		];

		(* Get the resolved options with simulated objects replaced with labels *)
		expandedResolvedOptionsWithLabels = $ExpandedOptionsForNumReplicates /. simulatedObjectsToLabel;

		(* Get our robotic unit operation packets. *)
		{{roboticUnitOperationPackets, roboticRunTime}, roboticSimulation} =
			ExperimentRoboticCellPreparation[
				primitives,
				UnitOperationPackets -> True,
				Output -> {Result, Simulation},
				FastTrack -> Lookup[myResolvedOptions, FastTrack],
				ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol],
				Name -> Lookup[myResolvedOptions, Name],
				Simulation -> currentSimulation,
				Upload -> False,
				ImageSample -> Lookup[myResolvedOptions, ImageSample],
				MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
				MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
				Priority -> Lookup[myResolvedOptions, Priority],
				StartDate -> Lookup[myResolvedOptions, StartDate],
				HoldOrder -> Lookup[myResolvedOptions, HoldOrder],
				QueuePosition -> Lookup[myResolvedOptions, QueuePosition],
				CoverAtEnd -> False
			];

		(* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
		outputUnitOperationPacket = UploadUnitOperation[
			Module[{nonHiddenOptions},
				(* Only include non-hidden options from ExperimentLyseCells. *)
				nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, LyseCells]];

				(* Override any options with resource. *)
				LyseCells@Join[
					Cases[Normal[expandedResolvedOptionsWithLabels], Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
					{
						Sample -> samplesInResources,
						RoboticUnitOperations -> If[Length[roboticUnitOperationPackets] == 0,
							{},
							(Link /@ Lookup[roboticUnitOperationPackets, Object])
						]
					}
				]
			],
			UnitOperationType -> Output,
			Upload -> False
		];

		(* Simulate the resources for our main UO since it's now the only thing that doesn't have resources. *)
		roboticSimulation = UpdateSimulation[
			roboticSimulation,
			Simulation[<|Object -> Lookup[outputUnitOperationPacket, Object], Sample -> (Link /@ expandedSamplesWithNumReplicates)|>]
		];

		(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
		roboticSimulation=If[Length[roboticUnitOperationPackets]==0,
			roboticSimulation,
			updateLabelFieldReferences[roboticSimulation,RoboticUnitOperations]
		];

		(* Return back our packets and simulation. *)
		{
			Null,
			Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
			roboticSimulation,
			(roboticRunTime + (10 Minute))
		}
	];

	(* Make list of all the resources we need to check in FRQ *)
	allResourceBlobs = If[MatchQ[resolvedPreparation, Manual],
		DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]],
		{}
	];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests} = Which[
		(* NOTE: If we're robotic, the framework will call FRQ for us. *)
		MatchQ[$ECLApplication,Engine] || MatchQ[resolvedPreparation, Robotic],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Cache->inheritedCache,Simulation->currentSimulation],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Messages->messages,Cache->inheritedCache,Simulation->currentSimulation],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[
		gatherTests,
		resourceTests,
		{}
	];

	(* Generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output,Result] && TrueQ[resourcesOk],
		{Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation, runTime},
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule,optionsRule,resultRule,testsRule}

];