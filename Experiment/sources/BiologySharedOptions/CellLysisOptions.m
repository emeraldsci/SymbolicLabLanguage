(* ::Package:: *)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Subsection:: *)
(* CellLysisOptions *)

DefineOptionSet[
  CellLysisOptions:> {

    CellTypeOption,
    CultureAdhesionOption,
    TargetCellularComponentOption,

    (* --- DISSOCIATION --- *)

    {
      OptionName -> Dissociate,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if adherent cells in the input cell sample are dissociated from their container prior to cell lysis.",
      ResolutionDescription -> "Automatically set to True if CultureAdhesion is Adherent and LysisAliquot is True. If CultureAdhesion is set to Suspension, automatically set to False. If neither of these conditions are met, Dissociate is automatically set to False.",
      Category -> "Lysis"
    },

    (* --- NUMBER OF LYSIS STEPS, REPLICATES, AND ALIQUOTING --- *)

    {
      OptionName -> NumberOfLysisSteps,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[1, 2, 3]],
      Description -> "The number of times that the cell sample is subjected to a unique set of conditions for disruption of the cell membranes. These conditions include the LysisSolution, LysisSolutionVolume, LysisMixType, LysisMixRate, LysisNumberOfMixes, LysisMixVolume, LysisMixTemperature, LysisMixInstrument, LysisTime, LysisTemperature, and LysisIncubationInstrument.",
      ResolutionDescription -> "Automatically set to the number of lysis steps specified by the selected Method. If Method is set to Custom, automatically set to 2 if any options for a second lysis step are specified, or 3 if any options for a third lysis step are specified. Otherwise, automatically set to 1.",
      Category -> "Lysis"
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
      ResolutionDescription -> "Automatically calculated from the composition of the cell sample and LysisAliquotAmount if sufficient cell count or concentration data is available. If the cell count cannot be calculated from the available sample information, TargetCellCount is automatically set to Null.",
      Category -> "Lysis"
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
      ResolutionDescription -> "Automatically calculated from the composition of the cell sample, LysisAliquotAmount, and any additional solution volumes added to the experiment if sufficient cell count or concentration data is available. If the cell concentration cannot be calculated from the available sample information, TargetCellConcentration is automatically set to Null.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisAliquot,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if a portion of the input cell sample is transferred to a new container prior to lysis.",
      ResolutionDescription -> "Automatically set to True if any of LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration are specified. Otherwise, LysisAliquot is automatically set to False.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisAliquotAmount,
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
      ResolutionDescription -> "Automatically set to Null if LysisAliquot is False. If LysisAliquot is True, LysisAliquotAmount is automatically set to the amount required to attain the specified TargetCellCount. If TargetCellCount is not specified and LysisAliquotContainer is specified, LysisAliquotAmount is automatically set to the lesser of All of the input sample or enough sample to occupy half the volume of the specified LysisAliquotContainer. If LysisAliquotContainer is not specified, LysisAliquotAmount is automatically set to 25% of the amount of input cell sample available.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisAliquotContainer,
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
      ResolutionDescription -> "Automatically set to Null if LysisAliquot is False. If LysisAliquot is True, LysisAliquotContainer is automatically set to a Model[Container] with sufficient capacity for the total volume of the experiment which is compatible with all of the mixing, incubation, and centrifugation conditions for the experiment.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisAliquotContainerLabel,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> String,
        Pattern :> _String,
        Size -> Word
      ],
      Description -> "A user defined word or phrase used to identify the container into which the cell sample is aliquoted prior to cell lysis.",
      Category -> "Lysis",
      UnitOperation -> True
    },

    (* --- OPTIONS FOR PELLETING PRIOR TO LYSIS --- *)


    {
      OptionName -> PreLysisPellet,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if the cell sample is centrifuged to remove unwanted media prior to addition of LysisSolution.",
      ResolutionDescription -> "Automatically set to True if any of PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer are set. Otherwise, automatically set to True if and only if pelleting is necessary to obtain the specified TargetCellConcentration.",
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis",
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
      Category -> "Lysis",
      UnitOperation -> True
    },

    (* --- OPTIONS FOR DILUTION PRIOR TO LYSIS --- *)

    {
      OptionName -> PreLysisDilute,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if the cell sample is diluted prior to cell lysis.",
      ResolutionDescription -> "Automatically set to True if one or both of PreLysisDiluent and PreLysisDilutionVolume is specified, or if dilution is required to obtain the specified TargetCellConcentration. Otherwise, automatically set to False.",
      Category -> "Lysis"
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
      ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"1x PBS from 10X stock, Alternative Preparation 1\"] if PreLysisDilute is set to True. Otherwise, automatically set to Null.",
      Category -> "Lysis"
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
      Description -> "The volume of PreLysisDiluent added to the cell sample (or LysisAliqoutAmount, if a portion of the cell sample has been aliquoted to an LysisAliquotContainer) prior to addition of LysisSolution.",
      ResolutionDescription -> "Automatically set to the volume necessary to obtain the TargetCellConcentration if PreLysisDilute is True and TargetCellConcentration is specified. If PreLysisDilute is True, TargetCellConcentration is unspecified, and LysisAliquotContainer is specified, automatically set to 25% of the volume of LysisAliquotContainer. If PreLysisDilute is True but neither of TargetCellConcentration or LysisAliquotContainer are specified, PreLysisDilutionVolume is automatically set to 0 Microliter due to insufficient information to determine a reasonable dilution volume.",
      Category -> "Lysis"
    },

    (* --- CONDITIONS FOR PRIMARY LYSIS STEP --- *)

    {
      OptionName -> LysisSolution,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        OpenPaths -> {
          {Object[Catalog, "Root"], "Materials", "Reagents"}
        }
      ],
      Description -> "The solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics.",
      ResolutionDescription -> "Automatically set to the LysisSolution specified by the selected Method. If Method is set to Custom, automatically set to the LysisSolution specified by the selected Method. If Method is set to Custom, automatically set according to the combination of CellType and TargetCellularComponents. LysisSolution is set to Model[Sample, \"TRIzol\"], Model[Sample, \"DNAzol\"], and Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"] when the TargetCellularComponent is RNA, GenomicDNA, and PlasmidDNA, respectively. If the TargetCellularComponent is CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, or Unspecified, the LysisSolution is automatically set to Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"] for Mammalian cells, Model[Sample, \"B-PER Bacterial Protein Extraction Reagent\"] for Bacterial cells, and Model[Sample, \"Y-PER Yeast Protein Extraction Reagent\"] for Yeast or Fungal cells.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisSolutionVolume,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter,{Microliter,Milliliter}}
        ],
        Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
      ],
      Description -> "The volume of LysisSolution to be added to the cell sample. If LysisAliquot is True, the LysisSolution is added to the LysisAliquotContainer. Otherwise, the LysisSolution is added to the container of the input cell sample.",
      ResolutionDescription -> "LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps if LysisAliquot is False. If LysisAliquotContainer is specified, automatically set to 50% of the unoccupied volume of LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps. If LysisAliquot is True but LysisAliquotContainer is unspecified, LysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisMixType,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
      Description -> "The manner in which the sample is mixed following combination of cell sample and LysisSolution.",
      ResolutionDescription -> "Automatically set to the LysisMixType specified by the selected Method. If Method is set to Custom and either of LysisMixVolume and NumberOfLysisMixes are specified, automatically set to Pipette. If Method is set to Custom and any of LysisMixRate, LysisMixTime, and LysisMixInstrument are specified, automatically set to Shake. Otherwise, LysisMixType is automatically set to Shake if mixing is to occur in a plate or Pipette if it is to occur in a tube.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisMixRate,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, $MaxMixRate], Units -> RPM],
      Description -> "The rate at which the sample is mixed by the selected LysisMixType during the LysisMixTime.",
      ResolutionDescription -> "Automatically set to the LysisMixRate specified by the selected Method. If Method is set to Custom and LysisMixType is set to Shake, automatically set to 200 RPM.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisMixTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Minute, $MaxExperimentTime],
        Units -> {Minute, {Second, Minute, Hour}}
      ],
      Description -> "The duration for which the sample is mixed by the selected LysisMixType following combination of the cell sample and the LysisSolution.",
      ResolutionDescription -> "If LysisMixType is set to Shake, automatically set to the LysisMixTime specified by the selected Method. If Method is set to Custom and LysisMixType is set to Shake, automatically set to 1 minute.",
      Category -> "Lysis"
    },
    {
      OptionName -> NumberOfLysisMixes,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
      Description -> "The number of times that the sample is mixed by pipetting the LysisMixVolume up and down following combination of the cell sample and the LysisSolution.",
      ResolutionDescription -> "If LysisMixType is set to Pipette, automatically set to the NumberOfLysisMixes specified by the selected Method. If Method is set to Custom and LysisMixType is set to Pipette, automatically set to 10.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisMixVolume,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
        Units -> {Microliter,{Microliter,Milliliter}}
      ],
      Description -> "The volume of the cell sample and LysisSolution displaced during each mix-by-pipette mix cycle.",
      ResolutionDescription -> "If LysisMixType is set to Pipette, automatically set to the lesser of "<>ToString[$MaxRoboticSingleTransferVolume]<>" or 50% of the total solution volume within the container.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisMixTemperature,
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
      Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the LysisMixTime, which occurs immediately before the LysisTime.",
      ResolutionDescription -> "Automatically set to the LysisMixTemperature specified by the selected Method. If Method is set to Custom, automatically set to Ambient.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisMixInstrument,
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
      ResolutionDescription -> "Automatically set to an available shaking device compatible with the specified LysisMixRate and LysisMixTemperature if LysisMixType is set to Shake. Otherwise, automatically set to Null.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Minute, $MaxExperimentTime],
        Units -> {Minute, {Second, Minute, Hour}}
      ],
      Description -> "The minimum duration for which the LysisIncubationInstrument is maintained at the LysisTemperature to facilitate the disruption of cell membranes and release of cellular contents. The LysisTime occurs immediately after addition of LysisSolution and optional mixing.",
      ResolutionDescription -> "Automatically set to the LysisTime specified by the selected Method. If Method is set to Custom, automatically set to 15 Minute.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisTemperature,
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
      Description -> "The temperature at which the LysisIncubationInstrument is maintained during the LysisTime, following the mixing of the cell sample and LysisSolution.",
      ResolutionDescription -> "Automatically set to the LysisTemperature specified by the selected Method. If Method is set to Custom, automatically set to Ambient.",
      Category -> "Lysis"
    },
    {
      OptionName -> LysisIncubationInstrument,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Instrument], Model[Instrument]}],
        OpenPaths -> {
          {Object[Catalog, "Root"], "Instruments", "Heating", "Heat Blocks"}
        }
      ],
      Description -> "The device used to cool or heat the cell sample to the LysisTemperature for the duration of the LysisTime.",
      ResolutionDescription -> "Automatically set to an integrated instrument compatible with the specified LysisTemperature.",
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Description -> "The volume of SecondaryLysisSolution to be added to the cell sample in an optional second lysis step. If LysisAliquot is True, the SecondaryLysisSolution is added to the LysisAliquotContainer. Otherwise, the SecondaryLysisSolution is added to the container of the input cell sample.",
      ResolutionDescription -> "Automatically set to Null if NumberOfLysisSteps is 1. If NumberOfLysisSteps is greater than 1, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps if LysisAliquot is False. If LysisAliquotContainer is specified, automatically set to 50% of the unoccupied volume of LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps. If LysisAliquot is True but AliquotContainer is unspecified, SecondaryLysisSolutionVolume is automatically set to nine times the AliquotAmount divided by the NumberOfLysisSteps.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryLysisMixType,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
      Description -> "The manner in which the sample is mixed following combination of cell sample and SecondaryLysisSolution in an optional second lysis step.",
      ResolutionDescription -> "Automatically set to the SecondaryLysisMixType specified by the selected Method. If Method is set to Custom and either of SecondaryLysisMixVolume and SecondaryNumberOfLysisMixes are specified, automatically set to Pipette. If Method is set to Custom and any of SecondaryLysisMixRate, SecondaryLysisMixTime, and SecondaryLysisMixInstrument are specified, automatically set to Shake. Otherwise, SecondaryLysisMixType is automatically set to Shake if mixing is to occur in a plate or Pipette if it is to occur in a tube.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryLysisMixRate,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 RPM, $MaxMixRate],
        Units -> RPM
      ],
      Description -> "The rate at which the sample is mixed by the selected SecondaryLysisMixType during the SecondaryLysisMixTime in an optional second lysis step.",
      ResolutionDescription -> "Automatically set to the SecondaryLysisMixRate specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is greater than 1, and SecondaryLysisMixType is set to Shake, automatically set to 200 RPM.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryLysisMixTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Minute, $MaxExperimentTime],
        Units -> {Minute, {Second, Minute, Hour}}
      ],
      Description -> "The duration for which the sample is mixed by the selected SecondaryLysisMixType following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
      ResolutionDescription -> "If SecondaryLysisMixType is set to Shake, automatically set to the SecondaryLysisMixTime specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is greater than 1, and SecondaryLysisMixType is set to Shake, automatically set to 1 minute.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryNumberOfLysisMixes,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
      Description -> "The number of times that the sample is mixed by pipetting the SecondaryLysisMixVolume up and down following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
      ResolutionDescription -> "If SecondaryLysisMixType is set to Pipette and NumberOfLysisSteps is greater than 1, automatically set to the SecondaryNumberOfLysisMixes specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is greater than 1, and SecondaryLysisMixType is set to Pipette, automatically set to 10.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryLysisMixVolume,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
        Units -> {Microliter,{Microliter,Milliliter}}
      ],
      Description -> "The volume of the cell sample and SecondaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional second lysis step.",
      ResolutionDescription -> "If SecondaryLysisMixType is set to Pipette and NumberOfLysisSteps is greater than 1, automatically set to the lesser of "<>ToString[$MaxRoboticSingleTransferVolume]<>" or 50% of the total solution volume within the container.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryLysisMixTemperature,
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
      Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the SecondaryLysisMixTime, which occurs immediately before the SecondaryLysisTime in an optional second lysis step.",
      ResolutionDescription -> "Automatically set to the SecondaryLysisMixTemperature specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is greater than 1, automatically set to Ambient.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryLysisMixInstrument,
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
      ResolutionDescription -> "Automatically set to an available shaking device compatible with the specified SecondaryLysisMixRate and SecondaryLysisMixTemperature if SecondaryLysisMixType is set to Shake and NumberOfLysisSteps is greater than 1. Otherwise, automatically set to Null.",
      Category -> "Lysis"
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
      Description -> "The minimum duration for which the SecondaryLysisIncubationInstrument is maintained at the SecondaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional second lysis step. The SecondaryLysisTime occurs immediately after addition of SecondaryLysisSolution and optional mixing.",
      ResolutionDescription -> "Automatically set to the SecondaryLysisTime specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is greater than 1, automatically set to 15 minutes.",
      Category -> "Lysis"
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
      Description -> "The temperature at which the SecondaryLysisIncubationInstrument is maintained during the SecondaryLysisTime, following the mixing of the cell sample and SecondaryLysisSolution in an optional second lysis step.",
      ResolutionDescription -> "Automatically set to the SecondaryLysisTemperature specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is greater than 1, automatically set to Ambient.",
      Category -> "Lysis"
    },
    {
      OptionName -> SecondaryLysisIncubationInstrument,
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
      Category -> "Lysis"
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
      ResolutionDescription -> "Automatically set to the TertiaryLysisSolution specified by the selected Method. If Method is set to Custom, automatically set to [...].", (* TODO: update with the appropriate solutions and make a table and direct the user to it *)
      Category -> "Lysis"
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
      Description -> "The volume of TertiaryLysisSolution to be added to the cell sample in an optional third lysis step. If LysisAliquot is True, the TertiaryLysisSolution is added to the AliquotContainer. Otherwise, the TertiaryLysisSolution is added to the container of the input cell sample.",
      ResolutionDescription -> "Automatically set to Null if NumberOfLysisSteps is less than 3. If NumberOfLysisSteps is 3, TertiaryLysisSolutionVolume is automatically set to 80% of the unoccupied volume of the sample's container (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps if LysisAliquot is False. If LysisAliquotContainer is specified, automatically set to 80% of the unoccupied volume of LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps. If LysisAliquot is True but LysisAliquotContainer is unspecified, TertiaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryLysisMixType,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
      Description -> "The manner in which the sample is mixed following combination of cell sample and TertiaryLysisSolution in an optional third lysis step.",
      ResolutionDescription -> "Automatically set to the TertiaryLysisMixType specified by the selected Method. If Method is set to Custom and either of TertiaryMixVolume and TertiaryNumberOfLysisMixes are specified, automatically set to Pipette. If Method is set to Custom and any of TertiaryLysisMixRate, TertiaryLysisMixTime, and TertiaryLysisMixInstrument are specified, automatically set to Shake. Otherwise, TertiaryLysisMixType is automatically set to Shake if mixing is to occur in a plate or Pipette if it is to occur in a tube.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryLysisMixRate,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, $MaxMixRate], Units -> RPM],
      Description -> "The rate at which the sample is mixed by the selected TertiaryLysisMixType during the TertiaryLysisMixTime in an optional third lysis step.",
      ResolutionDescription -> "Automatically set to the TertiaryLysisMixRate specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is 3, and TertiaryLysisMixType is set to Shake, automatically set to 200 RPM.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryLysisMixTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Minute, $MaxExperimentTime],
        Units -> {Minute, {Second, Minute, Hour}}
      ],
      Description -> "The duration for which the sample is mixed by the selected TertiaryLysisMixType following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
      ResolutionDescription -> "If TertiaryLysisMixType is set to Shake, automatically set to the TertiaryLysisMixTime specified by the selected Method. If Method is set to Custom, NumberOfLysisSteps is 3, and TertiaryLysisMixType is set to Shake, automatically set to 1 minute.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryNumberOfLysisMixes,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
      Description -> "The number of times that the sample is mixed by pipetting the TertiaryLysisMixVolume up and down following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
      ResolutionDescription -> "If TertiaryLysisMixType is set to Pipette and NumberOfLysisSteps is 3, automatically set to the TertiaryNumberOfLysisMixes specified by the selected Method. If Method is set to Custom and TertiaryLysisMixType is set to Pipette, automatically set to 10.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryLysisMixVolume,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
        Units -> {Microliter,{Microliter,Milliliter}}
      ],
      Description -> "The volume of the cell sample and TertiaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional third lysis step.",
      ResolutionDescription -> "If TertiaryLysisMixType is set to Pipette and NumberOfLysisSteps is 3, automatically set to the TertiaryLysisMixVolume specified by the selected Method. If Method is set to Custom and TertiaryLysisMixType is set to Pipette, automatically set to the lesser of "<>ToString[$MaxRoboticSingleTransferVolume]<>" or 50% of the total solution volume within the container.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryLysisMixTemperature,
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
      Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the TertiaryLysisMixTime, which occurs immediately before the TertiaryLysisTime in an optional third lysis step.",
      ResolutionDescription -> "Automatically set to the TertiaryLysisMixTemperature specified by the selected Method. If Method is set to Custom, automatically set to Ambient.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryLysisMixInstrument,
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
      ResolutionDescription -> "If NumberOfLysisSteps is 3 and TertiaryLysisMixType is set to Shake, automatically set to an available shaking device compatible with the specified TertiaryLysisMixRate and TertiaryLysisMixTemperature.",
      Category -> "Lysis"
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
      Description -> "The minimum duration for which the TertiaryLysisIncubationInstrument is maintained at the TertiaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional third lysis step. The TertiaryLysisTime occurs immediately after addition of TertiaryLysisSolution and optional mixing.",
      ResolutionDescription -> "Automatically set to the TertiaryLysisTime specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is 3, automatically set to 15 minutes.",
      Category -> "Lysis"
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
      Description -> "The temperature at which the TertiaryLysisIncubationInstrument is maintained during the TertiaryLysisTime, following the mixing of the cell sample and TertiaryLysisSolution in an optional third lysis step.",
      ResolutionDescription -> "Automatically set to the TertiaryLysisTemperature specified by the selected Method. If Method is set to Custom and NumberOfLysisSteps is 3, automatically set to Ambient.",
      Category -> "Lysis"
    },
    {
      OptionName -> TertiaryLysisIncubationInstrument,
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
      Category -> "Lysis"
    },

    (* --- LYSATE CLARIFICATION --- *)

    {
      OptionName -> ClarifyLysate,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if the lysate is centrifuged to remove cellular debris following incubation in the presence of LysisSolution.",
      ResolutionDescription -> "Automatically set to match the ClarifyLysate field of the selected Method, or set to True if any of ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, or PostClarificationPelletStorageCondition are specified. Otherwise, automatically set to False.",
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis",
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
      Category -> "Lysis"
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
      Category -> "Lysis"
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
      Category -> "Lysis",
      UnitOperation -> True
    }
  }
];

$LyseCellsSharedOptionsMap = {
  Method -> Method,
  RoboticInstrument -> RoboticInstrument,
  CellType -> CellType,
  CultureAdhesion -> CultureAdhesion,
  Dissociate -> Dissociate,
  NumberOfLysisSteps -> NumberOfLysisSteps,

  TargetCellCount -> TargetCellCount,
  TargetCellConcentration -> TargetCellConcentration,

  LysisAliquot -> Aliquot,
  LysisAliquotAmount -> AliquotAmount,
  LysisAliquotContainer -> AliquotContainer,
  LysisAliquotContainerLabel -> AliquotContainerLabel,

  PreLysisPellet -> PreLysisPellet,
  PreLysisPelletingCentrifuge -> PreLysisPelletingCentrifuge,
  PreLysisPelletingIntensity -> PreLysisPelletingIntensity,
  PreLysisPelletingTime -> PreLysisPelletingTime,
  PreLysisSupernatantVolume -> PreLysisSupernatantVolume,
  PreLysisSupernatantStorageCondition -> PreLysisSupernatantStorageCondition,
  PreLysisSupernatantContainer -> PreLysisSupernatantContainer,
  PreLysisSupernatantLabel -> PreLysisSupernatantLabel,
  PreLysisSupernatantContainerLabel -> PreLysisSupernatantContainerLabel,

  PreLysisDilute -> PreLysisDilute,
  PreLysisDiluent -> PreLysisDiluent,
  PreLysisDilutionVolume -> PreLysisDilutionVolume, 
  
  LysisSolution -> LysisSolution,
  LysisSolutionVolume -> LysisSolutionVolume,
  LysisMixType -> MixType,
  LysisMixRate -> MixRate,
  LysisMixTime -> MixTime,
  NumberOfLysisMixes -> NumberOfMixes,
  LysisMixVolume -> MixVolume,
  LysisMixTemperature -> MixTemperature,
  LysisMixInstrument -> MixInstrument,
  LysisTime -> LysisTime,
  LysisTemperature -> LysisTemperature,
  LysisIncubationInstrument -> IncubationInstrument,

  SecondaryLysisSolution -> SecondaryLysisSolution,
  SecondaryLysisSolutionVolume -> SecondaryLysisSolutionVolume,
  SecondaryLysisMixType -> SecondaryMixType,
  SecondaryLysisMixRate -> SecondaryMixRate,
  SecondaryLysisMixTime -> SecondaryMixTime,
  SecondaryNumberOfLysisMixes -> SecondaryNumberOfMixes,
  SecondaryLysisMixVolume -> SecondaryMixVolume,
  SecondaryLysisMixTemperature -> SecondaryMixTemperature,
  SecondaryLysisMixInstrument -> SecondaryMixInstrument,
  SecondaryLysisTime -> SecondaryLysisTime,
  SecondaryLysisTemperature -> SecondaryLysisTemperature,
  SecondaryLysisIncubationInstrument -> SecondaryIncubationInstrument,

  TertiaryLysisSolution -> TertiaryLysisSolution,
  TertiaryLysisSolutionVolume -> TertiaryLysisSolutionVolume,
  TertiaryLysisMixType -> TertiaryMixType,
  TertiaryLysisMixRate -> TertiaryMixRate,
  TertiaryLysisMixTime -> TertiaryMixTime,
  TertiaryNumberOfLysisMixes -> TertiaryNumberOfMixes,
  TertiaryLysisMixVolume -> TertiaryMixVolume,
  TertiaryLysisMixTemperature -> TertiaryMixTemperature,
  TertiaryLysisMixInstrument -> TertiaryMixInstrument,
  TertiaryLysisTime -> TertiaryLysisTime,
  TertiaryLysisTemperature -> TertiaryLysisTemperature,
  TertiaryLysisIncubationInstrument -> TertiaryIncubationInstrument,

  ClarifyLysate -> ClarifyLysate,
  ClarifyLysateCentrifuge -> ClarifyLysateCentrifuge,
  ClarifyLysateIntensity -> ClarifyLysateIntensity,
  ClarifyLysateTime -> ClarifyLysateTime,
  ClarifiedLysateVolume -> ClarifiedLysateVolume,
  ClarifiedLysateContainer -> ClarifiedLysateContainer,
  ClarifiedLysateContainerLabel -> ClarifiedLysateContainerLabel,
  PostClarificationPelletLabel -> PostClarificationPelletLabel,
  PostClarificationPelletStorageCondition -> PostClarificationPelletStorageCondition,

  SampleOutLabel -> SampleOutLabel
};

(* constant list of shared options *)
$LysisSharedOptions = ToExpression[Keys[Options[CellLysisOptions]]];


(* ::Subsection::Closed:: *)
(*checkLysisConflictingOptions*)

(* Conflicting lysis options check helper function *)
DefineOptions[
  checkLysisConflictingOptions,
  Options :> {CacheOption}
];
checkLysisConflictingOptions[
  mySamples:{ObjectP[Object[Sample]]..},
  myMapThreadFriendlyOptions:{_Association..},
  messagesQ:BooleanP,
  myOptions:OptionsPattern[checkLysisConflictingOptions]
]:=Module[{safeOptions, cache, editedLysisOptions, lysisConflictingOptionsResult, affectedSamples, affectedIndices, affectedOptions, lysisConflictingOptionsTest},

  safeOptions = SafeOptions[checkLysisConflictingOptions,ToList[myOptions]];
  cache = Lookup[safeOptions,Cache];

  (* - lysisConflictingOptionsTest - *)

  (* have to remove the shared "lysis options" that are actually used more broadly and therefore might be resolved before *)
  editedLysisOptions = Cases[$LysisSharedOptions, Except[TargetCellularComponent | CellType | CultureAdhesion | NumberOfLysisReplicates]];

  (* Find any samples for which Lyse is False but lysis options are set *)
  lysisConflictingOptionsResult = MapThread[
    Function[{sample, options, index},
      If[
        MatchQ[Lookup[options, Lyse], False] && MemberQ[Lookup[options, editedLysisOptions], Except[Null]],
        {
          sample,
          index,
          PickList[editedLysisOptions,Lookup[options,editedLysisOptions],Except[Null]]
        },
        Nothing
      ]
    ],
    {mySamples, myMapThreadFriendlyOptions, Range[Length[mySamples]]}
  ];
  affectedSamples=lysisConflictingOptionsResult[[All,1]];
  affectedIndices=lysisConflictingOptionsResult[[All,2]];
  affectedOptions=lysisConflictingOptionsResult[[All,3]];

  (* If there are samples with conflicting lysis options and we are throwing messages, throw an error message *)
  If[Length[affectedSamples] > 0 && messagesQ,
    Message[Error::LysisConflictingOptions,
      ObjectToString[affectedSamples, Cache -> cache],
      ToString[affectedIndices],
      ToString[affectedOptions]
    ]
  ];

  lysisConflictingOptionsTest = If[!messagesQ,
    Module[{failingTest, passingTest},
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have all lysis options set to Null if Lyse is False:", True, False]
      ];
      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have all lysis options set to Null if Lyse is False:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Null
  ];

  {Flatten[DeleteDuplicates[affectedOptions]], lysisConflictingOptionsTest}

];


(* ::Subsection::Closed:: *)
(*lyseCellsSharedOptionsUnitTests*)

(* NOTE: Tests written with the assumption of 0.2 mL samples and 10^10 EmeraldCell/Milliliter. *)
lyseCellsSharedOptionsUnitTests[myFunction_Symbol, adherentMammalianCellSampleInPlate: ObjectP[Object[Sample]], suspendedMammalianCellSampleInPlate: ObjectP[Object[Sample]], suspendedMammalianCellSampleInPlateWithCellConcentration: ObjectP[Object[Sample]], suspendedBacterialCellSampleInPlate: ObjectP[Object[Sample]], suspendedBacterialCellSampleUnspecifiedField: ObjectP[Object[Sample]]] :=
    {

      (* -- CellType Tests -- *)
      Example[{Options, CellType, "If the CellType field of the sample is specified, CellType is set to that value:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          CellType -> Mammalian
        }]
      ],
      Example[{Options, CellType, "If the CellType field of the input sample is Unspecified, automatically set to the majority cell type of the input sample based on its composition:"},
        myFunction[
          {
            suspendedBacterialCellSampleUnspecifiedField
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          CellType -> Bacterial
        }],
        Messages :> {Warning::UnknownCellType}
      ],

      (* -- CultureAdhesion Tests -- *)
      Example[{Options, CultureAdhesion, "CultureAdhesion is automatically set to the value in the CultureAdhesion field of the sample:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          CultureAdhesion -> Adherent
        }]
      ],

      (* -- TargetCellularComponent Tests -- *)
      (* NOTE::Not found in ExperimentExtractPlasmidDNA. *)
      Example[{Options, TargetCellularComponent, "TargetCellularComponent is the class of biomolecule whose purification is desired following lysis of the cell sample and any subsequent extraction operations. Options include CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, RNA, GenomicDNA, PlasmidDNA, Organelle, Virus and Unspecified.:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TargetCellularComponent -> Unspecified
        }]
      ],

      (* -- Dissociate Tests -- *)
      Example[{Options, Dissociate, "If CultureAdhesion is Adherent and LysisAliquot is True, then Dissociate is set to True:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          CultureAdhesion -> Adherent,
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          Dissociate -> True
        }]
      ],
      Example[{Options, Dissociate, "If CultureAdhesion is Suspension, then Dissociate is set to False:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          CultureAdhesion -> Suspension,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          Dissociate -> False
        }]
      ],
      Example[{Options, Dissociate, "If CultureAdhesion is Adherent but LysisAliquot is False, then Dissociate is set to False:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          CultureAdhesion -> Adherent,
          LysisAliquot -> False,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          Dissociate -> False
        }]
      ],


      (* -- NumberOfLysisSteps Tests -- *)
      Example[{Options, NumberOfLysisSteps, "If any tertiary lysis steps are set, then NumberOfLysisSteps will be set to 3:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisTemperature -> Ambient,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          NumberOfLysisSteps -> 3
        }]
      ],
      Example[{Options, NumberOfLysisSteps, "If any secondary lysis steps are specified but no tertiary lysis steps are set, then NumberOfLysisSteps will be set to 2:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisTemperature -> Ambient,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          NumberOfLysisSteps -> 2
        }]
      ],
      Example[{Options, NumberOfLysisSteps, "If no secondary nor tertiary lysis steps are set, then NumberOfLysisSteps will be set to 1:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          NumberOfLysisSteps -> 1
        }]
      ],

      (* -- LysisAliquot Tests -- *)
      Example[{Options, LysisAliquot, "If LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration are specified, LysisAliquot is set to True:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquotAmount -> 0.1 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquot -> True
        }]
      ],
      Example[{Options, LysisAliquot, "If no aliquotting options are set (LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration), LysisAliquot is set to False:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquot -> False
        }]
      ],
      Example[{Options, LysisAliquot, "LysisAliquotAmount and LysisAliquotContainer must not be Null if LysisAliquot is True:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotAmount -> GreaterP[0 Microliter],
          LysisAliquotContainer -> (ObjectP[Model[Container]] | {_Integer, ObjectP[Model[Container]]})
        }]
      ],
      Example[{Options, LysisAliquot, "LysisAliquotAmount and LysisAliquotContainer must be Null if LysisAliquot is False:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquot -> False,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotAmount -> Null,
          LysisAliquotContainer -> Null
        }]
      ],

      (* -- LysisAliquotAmount Tests -- *)
      Example[{Options, LysisAliquotAmount, "If LysisAliquot is set to True and TargetCellCount is set, LysisAliquotAmount will be set to attain the target cell count:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          TargetCellCount -> 10^9 EmeraldCell,
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.1 Milliliter]
        }]
      ],
      Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer is specified but TargetCellCount is not specified, LysisAliquotAmount will be set to All if the input sample is less than half of the LysisAliquotContiner's max volume:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.2 Milliliter]
        }]
      ],
      Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer is specified but TargetCellCount is not specified, LysisAliquotAmount will be set to half of the LysisAliquotContiner's max volume if the input sample volume is greater than that value:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
          (* NOTE:Solution volume required to avoid low volume warning *)
          LysisSolutionVolume -> 150 Microliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[150 Microliter]
        }]
      ],
      Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer and TargetCellCount are not specified, LysisAliquotAmount will be set to 25% of the input sample volume:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.05 Milliliter]
        }]
      ],

      (* -- LysisAliquotContainer Tests -- *)
      Example[{Options, LysisAliquotContainer, "If LysisAliquot is True, LysisAliquotContainer will be assigned by PackContainers:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotContainer -> {(_Integer),ObjectP[Model[Container]]}
        }]
      ],

      (* -- LysisAliquotContainerLabel Tests -- *)
      Example[{Options, LysisAliquotContainerLabel, "If LysisAliquot is True, LysisAliquotContainerLabel will be automatically generated:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisAliquotContainerLabel -> (_String)
        }]
      ],

      (* -- PreLysisPellet Tests -- *)
      Example[{Options, PreLysisPellet, "If any pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to True:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPelletingTime -> 1 Minute,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPellet -> True
        }]
      ],
      Example[{Options, PreLysisPellet, "If no pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to False:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPellet -> False
        }]
      ],
      Example[{Options, PreLysisPellet, "PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, and PreLysisSupernatantContainer must not be Null if PreLysisPellet is True:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPellet -> True,
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPelletingCentrifuge -> ObjectP[{Object[Instrument], Model[Instrument]}],
          PreLysisPelletingIntensity -> GreaterP[0 RPM],
          PreLysisPelletingTime -> GreaterP[0 Second],
          PreLysisSupernatantVolume -> GreaterP[0 Microliter],
          PreLysisSupernatantStorageCondition -> (SampleStorageTypeP|Disposal),
          PreLysisSupernatantContainer -> {_Integer, ObjectP[Model[Container]]}
        }]
      ],
      Example[{Options, PreLysisPellet, "PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, and PreLysisSupernatantContainer must be Null if PreLysisPellet is False:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPellet -> False,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPelletingCentrifuge -> Null,
          PreLysisPelletingIntensity -> Null,
          PreLysisPelletingTime -> Null,
          PreLysisSupernatantVolume -> Null,
          PreLysisSupernatantStorageCondition -> Null,
          PreLysisSupernatantContainer -> Null
        }]
      ],

      (* -- PreLysisPelletingCentrifuge Tests -- *)
      Example[{Options, PreLysisPelletingCentrifuge, "If PreLysisPellet is set to True, PreLysisPelletCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"]:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPelletingCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]] (* Model[Instrument, Centrifuge, "HiG4"] *)
        }]
      ],

      (* -- PreLysisPelletingIntensity Tests -- *)
      Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Mammalian, PreLysisPelletCentrifugeIntensity is automatically set to 1560 RPM:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          CellType -> Mammalian,
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> EqualP[1560 RPM]
        }]
      ],
      (* -- PreLysisPelletingIntensity Tests -- *)
      Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Bacterial, PreLysisPelletCentrifugeIntensity is automatically set to 4030 RPM:"},
        myFunction[
          {
            suspendedBacterialCellSampleInPlate
          },
          CellType -> Bacterial,
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> EqualP[4030 RPM]
        }]
      ],
      (* NOTE:Yeast cells currently not supported, but test will be needed when it is supported. *)
      (* -- PreLysisPelletingIntensity Tests -- *)
      Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Yeast, PreLysisPelletCentrifugeIntensity is automatically set to 2850 RPM:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          CellType -> Yeast,
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> EqualP[2850 RPM]
        }]
      ],

      (* -- PreLysisPelletingTime Tests -- *)
      Example[{Options, PreLysisPelletingTime, "If PreLysisPellet is set to True, PreLysisPelletCentrifugeTime is automatically set to 10 minutes:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisPelletingTime -> 10 Minute
        }]
      ],

      (* -- PreLysisSupernatantVolume Tests -- *)
      Example[{Options, PreLysisSupernatantVolume, "If PreLysisPellet is set to True, PreLysisSupernatantVolume is automatically set to 80% of the of total volume:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisSupernatantVolume -> EqualP[0.16 Milliliter]
        }]
      ],

      (* -- PreLysisSupernatantStorageCondition Tests -- *)
      Example[{Options, PreLysisSupernatantStorageCondition, "If PreLysisPellet is set to True, PreLysisSupernatantStorageCondition is automatically set to Disposal unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisSupernatantStorageCondition -> Disposal
        }]
      ],

      (* -- PreLysisSupernatantContainer Tests -- *)
      Example[{Options, PreLysisSupernatantContainer, "If PreLysisPellet is set to True, PreLysisSupernatantContainer is automatically set by PackContainers:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisSupernatantContainer -> {(_Integer), ObjectP[Model[Container]]}
        }]
      ],

      (* -- PreLysisSupernatantLabel Tests -- *)
      Example[{Options, PreLysisSupernatantLabel, "If PreLysisPellet is set to True, PreLysisSupernatantLabel will be automatically generated:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisSupernatantLabel -> (_String)
        }]
      ],

      (* -- PreLysisSupernatantContainerLabel Tests -- *)
      Example[{Options, PreLysisSupernatantContainerLabel, "If PreLysisPellet is set to True, PreLysisSupernatantContainerLabel will be automatically generated:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          PreLysisPellet -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisSupernatantContainerLabel -> (_String)
        }]
      ],

      (* -- PreLysisDilute Tests -- *)
      Example[{Options, PreLysisDilute, "If either PreLysisDiluent or PreLysisDilutionVolume are set, then PreLysisDilute is automatically set to True:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisDilutionVolume -> 0.2 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisDilute -> True
        }]
      ],
      Example[{Options, PreLysisDilute, "PreLysisDiluent and PreLysisDilutionVolume must be Null if PreLysisDilute is False:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          PreLysisDilute -> False,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisDiluent -> Null,
          PreLysisDilutionVolume -> Null
        }]
      ],

      (* -- PreLysisDiluent Tests -- *)
      Example[{Options, PreLysisDiluent, "If PreLysisDilute is set to True, PreLysisDiluent is automatically set to Model[Sample, StockSolution, \"1x PBS from 10X stock\"]:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          PreLysisDilute -> True,
          (* TargetCellConcentration added to avoid error for not having enough into to make PreLysisDilutionVolume *)
          TargetCellConcentration -> 5 * 10^9 EmeraldCell/Milliliter,
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisDiluent -> ObjectP[Model[Sample, StockSolution, "id:9RdZXv1KejGK"]] (* Model[Sample, StockSolution, "1x PBS from 10X stock, Alternative Preparation 1"] *)
        }]
      ],

      (* -- PreLysisDilutionVolume Tests -- *)
      Example[{Options, PreLysisDilutionVolume, "If PreLysisDilute is True and a TargetCellConcentration is specified, then PreLysisDilutionVolume is set to the volume required to attain the TargetCellConcentration:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          PreLysisDilute -> True,
          TargetCellConcentration -> 5 * 10^9 EmeraldCell/Milliliter,
          LysisAliquot -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PreLysisDilutionVolume -> EqualP[0.05 Milliliter]
        }]
      ],

      (* -- LysisSolution Tests -- *)
      (* NOTE:Should be customized for the experiment this is used for. *)
      Example[{Options, LysisSolution, "Unless otherwise specified, LysisSolution is automatically set according to the combination of CellType and TargetCellularComponents:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisSolution -> ObjectP[Model[Sample]]
        }]
      ],

      (* -- LysisSolutionVolume Tests -- *)
      Example[{Options, LysisSolutionVolume, "If LysisAliquot is False, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          LysisAliquot -> False,
          NumberOfLysisSteps -> 1,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisSolutionVolume -> EqualP[0.9 Milliliter]
        }]
      ],
      Example[{Options, LysisSolutionVolume, "If LysisAliquotContainer is set, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          NumberOfLysisSteps -> 1,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisSolutionVolume -> EqualP[0.9 Milliliter]
        }]
      ],
      Example[{Options, LysisSolutionVolume, "If LysisAliquot is True and LysisAliquotContainer is not set, LysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          LysisAliquot -> True,
          LysisAliquotAmount -> 0.1 Milliliter,
          NumberOfLysisSteps -> 1,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisSolutionVolume -> EqualP[0.9 Milliliter]
        }]
      ],


      (* -- LysisMixType Tests -- *)
      Example[{Options, LysisMixType, "If LysisMixVolume or NumberOfLysisMixes are specified, LysisMixType is automatically set to Pipette:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          NumberOfLysisMixes -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixType -> Pipette
        }]
      ],
      Example[{Options, LysisMixType, "If LysisMixRate, LysisMixTime, or LysisMixInstrument are specified, LysisMixType is automatically set to Shake:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixTime -> 1 Minute,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixType -> Shake
        }]
      ],
      Example[{Options, LysisMixType, "If no mixing options are set and the sample will be mixed in a plate, LysisMixType is automatically set to Shake:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixType -> Shake
        }]
      ],
      Example[{Options, LysisMixType, "If no mixing options are set and the sample will be mixed in a tube, LysisMixType is automatically set to Pipette:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixType -> Pipette
        }]
      ],

      (* -- LysisMixRate Tests -- *)
      Example[{Options, LysisMixRate, "If LysisMixType is set to Shake, LysisMixRate is automatically set to 200 RPM:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixRate -> EqualP[200 RPM]
        }]
      ],

      (* -- LysisMixTime Tests -- *)
      Example[{Options, LysisMixTime, "If LysisMixType is set to Shake, LysisMixTime is automatically set to 1 minute:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixTime -> EqualP[1 Minute]
        }]
      ],

      (* -- NumberOfLysisMixes Tests -- *)
      Example[{Options, NumberOfLysisMixes, "If LysisMixType is set to Pipette, NumberOfLysisMixes is automatically set to 10:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixType -> Pipette,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          NumberOfLysisMixes -> 10
        }]
      ],

      (* -- LysisMixVolume Tests -- *)
      Example[{Options, LysisMixVolume, "If LysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, LysisMixVolume is automatically set to 50% of the total solution volume:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixType -> Pipette,
          LysisSolutionVolume -> 0.2 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixVolume -> EqualP[0.2 Milliliter]
        }]
      ],
      Example[{Options, LysisMixVolume, "If LysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, LysisMixVolume is automatically set to 970 microliters:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixType -> Pipette,
          LysisSolutionVolume -> 1.8 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      ],

      (* -- LysisMixTemperature Tests -- *)
      Example[{Options, LysisMixTemperature, "If LysisMixType is set to either Pipette or Shake, LysisMixTemperature is automatically set to Ambient unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixTemperature -> Ambient
        }]
      ],

      (* -- LysisMixInstrument Tests -- *)
      Example[{Options, LysisMixInstrument, "If LysisMixType is set to Shake, LysisMixInstrument is automatically set to an available shaking device compatible with the specified LysisMixRate and LysisMixTemperature:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisMixInstrument -> ObjectP[Model[Instrument]]
        }]
      ],

      (* -- LysisTime Tests -- *)
      Example[{Options, LysisTime, "LysisTime is automatically set to 15 minutes unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisTime -> EqualP[15 Minute]
        }]
      ],

      (* -- LysisTemperature Tests -- *)
      Example[{Options, LysisTemperature, "LysisTemperature is automatically set to Ambient unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisTemperature -> Ambient
        }]
      ],

      (* -- LysisIncubationInstrument Tests -- *)
      Example[{Options, LysisIncubationInstrument, "LysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified LysisTemperature:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          LysisIncubationInstrument -> ObjectP[Model[Instrument]]
        }]
      ],

      (* -- SecondaryLysisSolution Tests -- *)
      (* NOTE:Should be customized for the experiment this is used for. *)
      Example[{Options, SecondaryLysisSolution, "Unless otherwise specified, SecondaryLysisSolution is the same as LysisSolution:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          NumberOfLysisSteps -> 2,
          LysisSolution -> Model[Sample, StockSolution, "Protein Lysis Buffer"],
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisSolution -> ObjectP[Model[Sample, StockSolution, "Protein Lysis Buffer"]]
        }]
      ],

      (* -- SecondaryLysisSolutionVolume Tests -- *)
      Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1 and LysisAliquot is False, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          NumberOfLysisSteps -> 2,
          LysisAliquot -> False,
          LysisSolutionVolume -> 0.2 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter]
        }]
      ],
      Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1 and LysisAliquotContainer is set, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          NumberOfLysisSteps -> 2,
          LysisSolutionVolume -> 0.2 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter]
        }]
      ],
      Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1, LysisAliquot is True, and LysisAliquotContainer is not set, SecondaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquot -> True,
          NumberOfLysisSteps -> 2,
          LysisAliquotAmount -> 0.1 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisSolutionVolume -> EqualP[0.45 Milliliter]
        }]
      ],

      (* -- SecondaryLysisMixType Tests -- *)
      Example[{Options, SecondaryLysisMixType, "If SecondaryLysisMixVolume or SecondaryNumberOfLysisMixes are specified, SecondaryLysisMixType is automatically set to Pipette:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryNumberOfLysisMixes -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixType -> Pipette
        }]
      ],
      Example[{Options, SecondaryLysisMixType, "If SecondaryLysisMixRate, SecondaryLysisMixTime, or SecondaryLysisMixInstrument are specified, SecondaryLysisMixType is automatically set to Shake:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixTime -> 1 Minute,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixType -> Shake
        }]
      ],
      Example[{Options, SecondaryLysisMixType, "If NumberOfLysisSteps is greater than 1, no mixing options are set, and the sample will be mixed in a plate, SecondaryLysisMixType is automatically set to Shake:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          NumberOfLysisSteps -> 2,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixType -> Shake
        }]
      ],
      Example[{Options, SecondaryLysisMixType, "If NumberOfLysisSteps is greater than 1, no mixing options are set, and the sample will be mixed in a tube, SecondaryLysisMixType is automatically set to Pipette:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
          NumberOfLysisSteps -> 2,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixType -> Pipette
        }]
      ],

      (* -- SecondaryLysisMixRate Tests -- *)
      Example[{Options, SecondaryLysisMixRate, "If SecondaryLysisMixType is set to Shake, SecondaryLysisMixRate is automatically set to 200 RPM:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixRate -> EqualP[200 RPM]
        }]
      ],

      (* -- SecondaryLysisMixTime Tests -- *)
      Example[{Options, SecondaryLysisMixTime, "If SecondaryLysisMixType is set to Shake, SecondaryLysisMixTime is automatically set to 1 minute:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixTime -> EqualP[1 Minute]
        }]
      ],

      (* -- SecondaryNumberOfLysisMixes Tests -- *)
      Example[{Options, SecondaryNumberOfLysisMixes, "If SecondaryLysisMixType is set to Pipette, SecondaryNumberOfLysisMixes is automatically set to 10:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixType -> Pipette,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryNumberOfLysisMixes -> 10
        }]
      ],

      (* -- SecondaryLysisMixVolume Tests -- *)
      Example[{Options, SecondaryLysisMixVolume, "If SecondaryLysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, SecondaryLysisMixVolume is automatically set to 50% of the total solution volume:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixType -> Pipette,
          LysisSolutionVolume -> 0.2 Milliliter,
          SecondaryLysisSolutionVolume -> 0.2 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixVolume -> EqualP[0.3 Milliliter]
        }]
      ],
      Example[{Options, SecondaryLysisMixVolume, "If SecondaryLysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, SecondaryLysisMixVolume is automatically set to 970 microliters:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixType -> Pipette,
          LysisSolutionVolume -> 0.9 Milliliter,
          SecondaryLysisSolutionVolume -> 0.9 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      ],

      (* -- SecondaryLysisMixTemperature Tests -- *)
      Example[{Options, SecondaryLysisMixTemperature, "If SecondaryLysisMixType is set to either Pipette or Shake, SecondaryLysisMixTemperature is automatically set to Ambient unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixTemperature -> Ambient
        }]
      ],

      (* -- SecondaryLysisMixInstrument Tests -- *)
      Example[{Options, SecondaryLysisMixInstrument, "If SecondaryLysisMixType is set to Shake, SecondaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified SecondaryLysisMixRate and SecondaryLysisMixTemperature:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          SecondaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisMixInstrument -> ObjectP[Model[Instrument]]
        }]
      ],

      (* -- SecondaryLysisTime Tests -- *)
      Example[{Options, SecondaryLysisTime, "If NumberOfLysisSteps is greater than 1, SecondaryLysisTime is automatically set to 15 minutes unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          NumberOfLysisSteps -> 2,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisTime -> EqualP[15 Minute]
        }]
      ],

      (* -- SecondaryLysisTemperature Tests -- *)
      Example[{Options, SecondaryLysisTemperature, "If NumberOfLysisSteps is greater than 1,SecondaryLysisTemperature is automatically set to Ambient unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          NumberOfLysisSteps -> 2,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisTemperature -> Ambient
        }]
      ],

      (* -- SecondaryLysisIncubationInstrument Tests -- *)
      Example[{Options, SecondaryLysisIncubationInstrument, "If NumberOfLysisSteps is greater than 1, SecondaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified SecondaryLysisTemperature:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          NumberOfLysisSteps -> 2,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          SecondaryLysisIncubationInstrument -> ObjectP[Model[Instrument]]
        }]
      ],

      (* -- TertiaryLysisSolution Tests -- *)
      (* NOTE:Should be customized for the experiment this is used for. *)
      Example[{Options, TertiaryLysisSolution, "If NumberOfLysisSteps is greater than 2, TertiaryLysisSolution is the same as LysisSolution unless otherwise specified:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          NumberOfLysisSteps -> 3,
          LysisSolution -> Model[Sample, StockSolution, "Protein Lysis Buffer"],
          TertiaryLysisSolutionVolume -> 0.2 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisSolution -> ObjectP[Model[Sample, StockSolution, "Protein Lysis Buffer"]]
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisSolutionVolume Tests -- *)
      Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2 and LysisAliquot is False, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          NumberOfLysisSteps -> 3,
          LysisAliquot -> False,
          LysisSolutionVolume -> 0.3 Milliliter,
          SecondaryLysisSolutionVolume -> 0.3 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter]
        }],
        TimeConstraint -> 1600
      ],
      Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2 and LysisAliquotContainer is set, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of the TertiaryLysisSolutionVolume) divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          NumberOfLysisSteps -> 3,
          LysisSolutionVolume -> 0.3 Milliliter,
          SecondaryLysisSolutionVolume -> 0.3 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter]
        }],
        TimeConstraint -> 1600
      ],
      Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2, LysisAliquot is True, and LysisAliquotContainer is not set, TertiaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlate
          },
          LysisAliquot -> True,
          NumberOfLysisSteps -> 3,
          LysisAliquotAmount -> 0.1 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisSolutionVolume -> EqualP[0.3 Milliliter]
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisMixType Tests -- *)
      Example[{Options, TertiaryLysisMixType, "If TertiaryLysisMixVolume or TertiaryNumberOfLysisMixes are specified, TertiaryLysisMixType is automatically set to Pipette:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryNumberOfLysisMixes -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixType -> Pipette
        }],
        TimeConstraint -> 1600
      ],
      Example[{Options, TertiaryLysisMixType, "If TertiaryLysisMixRate, TertiaryLysisMixTime, or TertiaryLysisMixInstrument are specified, TertiaryLysisMixType is automatically set to Shake:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixTime -> 1 Minute,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixType -> Shake
        }],
        TimeConstraint -> 1600
      ],
      Example[{Options, TertiaryLysisMixType, "If NumberOfLysisSteps is greater than 2, no mixing options are set, and the sample will be mixed in a plate, TertiaryLysisMixType is automatically set to Shake:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          NumberOfLysisSteps -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixType -> Shake
        }],
        TimeConstraint -> 1600
      ],
      Example[{Options, TertiaryLysisMixType, "If NumberOfLysisSteps is greater than 2, no mixing options are set, and the sample will be mixed in a tube, TertiaryLysisMixType is automatically set to Pipette:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
          NumberOfLysisSteps -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixType -> Pipette
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisMixRate Tests -- *)
      Example[{Options, TertiaryLysisMixRate, "If TertiaryLysisMixType is set to Shake, TertiaryLysisMixRate is automatically set to 200 RPM:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixRate -> EqualP[200 RPM]
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisMixTime Tests -- *)
      Example[{Options, TertiaryLysisMixTime, "If TertiaryLysisMixType is set to Shake, TertiaryLysisMixTime is automatically set to 1 minute:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixTime -> EqualP[1 Minute]
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryNumberOfLysisMixes Tests -- *)
      Example[{Options, TertiaryNumberOfLysisMixes, "If TertiaryLysisMixType is set to Pipette, TertiaryNumberOfLysisMixes is automatically set to 10:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixType -> Pipette,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryNumberOfLysisMixes -> 10
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisMixVolume Tests -- *)
      Example[{Options, TertiaryLysisMixVolume, "If TertiaryLysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, TertiaryLysisMixVolume is automatically set to 50% of the total solution volume:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixType -> Pipette,
          LysisSolutionVolume -> 0.2 Milliliter,
          SecondaryLysisSolutionVolume -> 0.2 Milliliter,
          TertiaryLysisSolutionVolume -> 0.2 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixVolume -> EqualP[0.4 Milliliter]
        }],
        TimeConstraint -> 1600
      ],
      Example[{Options, TertiaryLysisMixVolume, "If TertiaryLysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, TertiaryLysisMixVolume is automatically set to 970 microliters:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixType -> Pipette,
          LysisSolutionVolume -> 0.6 Milliliter,
          SecondaryLysisSolutionVolume -> 0.6 Milliliter,
          TertiaryLysisSolutionVolume -> 0.6 Milliliter,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixVolume -> EqualP[0.970 Milliliter]
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisMixTemperature Tests -- *)
      Example[{Options, TertiaryLysisMixTemperature, "If TertiaryLysisMixType is set to either Pipette or Shake, TertiaryLysisMixTemperature is automatically set to Ambient unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixTemperature -> Ambient
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisMixInstrument Tests -- *)
      Example[{Options, TertiaryLysisMixInstrument, "If TertiaryLysisMixType is set to Shake, TertiaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified TertiaryLysisMixRate and TertiaryLysisMixTemperature:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          TertiaryLysisMixType -> Shake,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisMixInstrument -> ObjectP[Model[Instrument]]
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisTime Tests -- *)
      Example[{Options, TertiaryLysisTime, "If NumberOfLysisSteps is greater than 2, TertiaryLysisTime is automatically set to 15 minutes unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          NumberOfLysisSteps -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisTime -> EqualP[15 Minute]
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisTemperature Tests -- *)
      Example[{Options, TertiaryLysisTemperature, "If NumberOfLysisSteps is greater than 2,TertiaryLysisTemperature is automatically set to Ambient unless otherwise specified:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          NumberOfLysisSteps -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisTemperature -> Ambient
        }],
        TimeConstraint -> 1600
      ],

      (* -- TertiaryLysisIncubationInstrument Tests -- *)
      Example[{Options, TertiaryLysisIncubationInstrument, "If NumberOfLysisSteps is greater than 2, TertiaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified TertiaryLysisTemperature:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          NumberOfLysisSteps -> 3,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          TertiaryLysisIncubationInstrument -> ObjectP[Model[Instrument]]
        }],
        TimeConstraint -> 1600
      ],

      (* -- ClarifyLysate Tests -- *)
      Example[{Options, ClarifyLysate, "If any clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to True:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          ClarifyLysateTime -> 1 Minute,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifyLysate -> True
        }]
      ],
      Example[{Options, ClarifyLysate, "If no clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to False:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          Lyse -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifyLysate -> False
        }]
      ],

      (* -- ClarifyLysateCentrifuge Tests -- *)
      Example[{Options, ClarifyLysateCentrifuge, "If ClarifyLysate is set to True, ClarifyLysateCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"]:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifyLysateCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "HiG4"]]
        }]
      ],

      (* -- ClarifyLysateIntensity Tests -- *)
      Example[{Options, ClarifyLysateIntensity, "If ClarifyLysate is set to True, ClarifyLysateIntensity is set to 5700 RPM:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifyLysateIntensity -> EqualP[5700 RPM]
        }]
      ],

      (* -- ClarifyLysateTime Tests -- *)
      Example[{Options, ClarifyLysateTime, "If ClarifyLysate is set to True, ClarifyLysateTime is set to 10 minutes:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifyLysateTime -> EqualP[10 Minute]
        }]
      ],

      (* -- ClarifiedLysateVolume Tests -- *)
      Example[{Options, ClarifiedLysateVolume, "If ClarifyLysate is set to True, ClarifiedLysateVolume is set automatically set to 90% of the volume of the lysate:"},
        myFunction[
          {
            adherentMammalianCellSampleInPlate
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifiedLysateVolume -> EqualP[0.99 Milliliter]
        }]
      ],

      (* -- PostClarificationPelletLabel Tests -- *)
      Example[{Options, PostClarificationPelletLabel, "If ClarifyLysate is True, PostClarificationPelletLabel will be automatically generated:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PostClarificationPelletLabel -> (_String)
        }]
      ],

      (* -- PostClarificationPelletStorageCondition Tests -- *)
      Example[{Options, PostClarificationPelletStorageCondition, "If ClarifyLysate is True, PostClarificationPelletStorageCondition will be automatically set to Disposal unless otherwise specified:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          PostClarificationPelletStorageCondition -> Disposal
        }]
      ],

      (* -- ClarifiedLysateContainer Tests -- *)
      Example[{Options, ClarifiedLysateContainer, "If ClarifyLysate is True, ClarifiedLysateContainer will be automatically selected to accomadate the volume of the clarified lysate:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifiedLysateContainer -> ObjectP[Model[Container]]
        }]
      ],

      (* -- ClarifiedLysateContainerLabel Tests -- *)
      Example[{Options, ClarifiedLysateContainerLabel, "If ClarifyLysate is True, ClarifiedLysateContainerLabel will be automatically generated:"},
        myFunction[
          {
            suspendedMammalianCellSampleInPlateWithCellConcentration
          },
          ClarifyLysate -> True,
          (* No purification steps to speed up testing. *)
          Purification -> None,
          Output->Options
        ],
        KeyValuePattern[{
          ClarifiedLysateContainerLabel -> (_String)
        }]
      ]

    };
