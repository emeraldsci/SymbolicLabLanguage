(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*ExperimentExtractPlasmidDNA Tests*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentExtractPlasmidDNA*)

DefineTests[ExperimentExtractPlasmidDNA,
  {

    (* Basic examples *)
    Example[{Basic, "Living cells are lysed and neutralized to isolate plasmid DNA from the cell and then extracted plasmid DNA is purified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,
            Neutralize -> True,
            Purification -> {LiquidLiquidExtraction, Precipitation}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Basic, "Multiple cell samples and types can undergo plasmid DNA extraction in one experiment call:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,
            Neutralize -> True,
            Purification -> {LiquidLiquidExtraction, Precipitation}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Basic, "Lysate samples can be neutralized and/or further purified using the rudimentary purification steps from plasmid DNA extraction:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> False,
            Neutralize -> True,
            Purification -> {LiquidLiquidExtraction, Precipitation}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Basic, "Crude plasmid DNA samples can be further purified using the rudimentary purification steps from plasmid DNA extraction:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> False,
            Neutralize -> False,
            Purification -> {LiquidLiquidExtraction, Precipitation}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* Options *)

    (* - General Options - *)

    (* -- RoboticInstrument Tests -- *)
    Example[{Options, RoboticInstrument, "If input cells are only Mammalian, then the bioSTAR liquid handler is used for the extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "bioSTAR"]]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, RoboticInstrument, "If input cells have anything other than just Mammalian cells (Bacterial or Yeast), then the microbioSTAR liquid handler is used for the extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "microbioSTAR"]]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- WorkCell Tests -- *)
    Example[{Options, WorkCell, "If input cells are only Mammalian, then the bioSTAR WorkCell is used for the extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            WorkCell -> bioSTAR
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, WorkCell, "If input cells have anything other than just Mammalian cells (Bacterial or Yeast), then the microbioSTAR WorkCell is used for the extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            WorkCell -> microbioSTAR
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- Method Tests -- *)
    Example[{Options, Method, "If a plasmid DNA extraction method is specified, then the options from the method object will be used to determine other options:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Low Volume Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Method -> Object[Method, Extraction, PlasmidDNA, "PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Method -> ObjectP[Object[Method, Extraction, PlasmidDNA, "PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]],
            NumberOfLysisSteps -> 1,
            NeutralizationSettlingTime -> EqualP[10 Minute],
            NumberOfLiquidLiquidExtractions -> 1,
            PrecipitationNumberOfWashes -> 1,
            NumberOfMagneticBeadSeparationWashes -> 1,
            SolidPhaseExtractionElutionTime -> EqualP[2 Minute],
            Lyse -> True,
            Neutralize -> True,
            Purification -> {LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, MagneticBeadSeparation}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- ContainerOut Tests -- *)
    Example[{Options, ContainerOut, "ContainerOut is automatically set to the container that the sample was in for the last step of the extraction unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ContainerOut -> {(_String), {(_Integer), ObjectP[{Model[Container], Object[Container]}]}}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- ExtractedPlasmidDNALabel and ExtractedPlasmidDNAContainerLabel Tests -- *)
    Example[{Options, {ExtractedPlasmidDNALabel, ExtractedPlasmidDNAContainerLabel}, "ExtractedPlasmidDNALabel and ExtractedPlasmidDNAContainerLabel are automatically generated if they are not otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ExtractedPlasmidDNALabel -> (_String),
            ExtractedPlasmidDNAContainerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* - Lyse Options - *)

    (* -- Lyse Tests -- *)
    Example[{Options, Lyse, "If the input is living cells, they will be lysed before neutralization and purification:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True
          }
        ]
      },
      TimeConstraint -> 3600
    ],
    Example[{Options, Lyse, "If the input is lysate or crude plasmid solution, it will not be lysed (since it is already lysed or does not require lysing):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* One purification step to speed up testing. Can't use no purification because then nothing done to it and error thrown. *)
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> False
          }
        ]
      },
      TimeConstraint -> 3600
    ],


    (* - Neutralization Options - *)

    (* -- Neutralize Tests -- *)
    Example[{Options, Neutralize, "If a sample is being lysed, it will also be neutralized (since lysate often needs to be neutralized soon after lysis for plasmid DNA extraction):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Neutralize -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Neutralize, "If any neutralization options are set, then the sample will be neutralized:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Neutralize -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Neutralize, "If the sample is a lysate, then the sample will be neutralized:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Neutralize -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Neutralize, "If the sample is not a lysate, not being lysed, nor has any neutralization options specified, then the sample will not be neutralized:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* One purification step to speed up testing. *)
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Neutralize -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],


    (* -- NeutralizationSeparation Tests -- *)
    Example[{Options, NeutralizationSeparationTechnique, "If any neutralization filtration options are specified, then the sample will be filtered to separate the neutralized supernatant from the cell debris:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationFiltrationTime -> 2 * Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationSeparationTechnique -> Filter
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NeutralizationSeparationTechnique, "If no neutralization filtration options are specified, then the sample will be pelleted to separate the neutralized supernatant from the cell debris by default:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationSeparationTechnique -> Pellet
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationReagent, NeutralizationReagentTemperature, NeutralizationReagentEquilibrationTime, and NeutralizationSettlingTime Tests -- *)
    Example[{Options, {NeutralizationReagent, NeutralizationReagentTemperature, NeutralizationReagentEquilibrationTime, NeutralizationSettlingTime}, "By default, if a sample will be neutralized, then NeutralizationReagent will automatically be set to Model[Sample, StockSolution, \"3M Sodium Acetate\"]], NeutralizationReagentTemperature will be automatically set to Ambient, NeutralizationReagentEquilibrationTime will automatically be set to 5 minutes, and NeutralizationSettlingTime will be set to 15 minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationReagent -> ObjectP[Model[Sample, StockSolution, "id:Vrbp1jKWrmjW"]], (* Model[Sample, StockSolution, "3M Sodium Acetate"] *)
            NeutralizationReagentTemperature -> Ambient,
            NeutralizationReagentEquilibrationTime -> EqualP[5 Minute],
            NeutralizationSettlingTime -> EqualP[15 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationReagentVolume Tests -- *)
    Example[{Options, NeutralizationReagentVolume, "If half of the lysate volume is less than 80% of the maximum volume of the container minus the volume of the lysate, then half of the lysate volume is used as the volume of the neutralization reagent added to the lysate:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationReagentVolume -> EqualP[0.1 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NeutralizationReagentVolume, "If half of the lysate volume is greater than 80% of the maximum volume of the container minus the volume of the lysate, then 80% of the maximum volume of the container minus the volume of the lysate is used as the volume of the neutralization reagent added to the lysate:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisSolutionVolume -> 1.35 Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationReagentVolume -> EqualP[0.05 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationMixType Tests -- *)
    Example[{Options, NeutralizationMixType, "If a mixing time or mixing rate for the neutralization is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        NeutralizationMixTime -> 1 * Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NeutralizationMixType, "If a mixing volume or number of mixes for the neutralization is specified, then the sample will be mixed with a pipette (since a mixing volume and number of mixes do not pertain to shaking):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfNeutralizationMixes -> 6,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NeutralizationMixType, "If mixing options are not specified for neutralization, then the sample will not be mixed by default:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixType -> None
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationMixTemperature Tests -- *)
    Example[{Options, NeutralizationMixTemperature, "If the neutralization mixture will be mixed, then the mixing temperature is set to ambient temperature by default:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationMixInstrument Tests-- *)
    Example[{Options, NeutralizationMixInstrument, "If the neutralization mixture will be mixed by shaking, the mixing temperature is less than or equal to 70 degrees Celsius, and the mixing rate is outside the range of 400-1800 RPM, then the mixing instrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NeutralizationMixInstrument, "If the neutralization mixture will be mixed by shaking and the mixing temperature is greater than 70 degrees Celsius and the mixing rate is within 400-1800 RPM, then the mixing instrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Shake,
        NeutralizationMixTemperature -> 75 Celsius,
        NeutralizationMixRate -> 500 RPM,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]] (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationMixRate and NeutralizationMixTime Tests -- *)
    Example[{Options, {NeutralizationMixRate, NeutralizationMixTime}, "If NeutralizationMixType is set to Shake, then the NeutralizationMixRate is automatically set to 300 RPM (revolutions per minute) and NeutralizationMixTime is automatically set to 15 minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixRate -> EqualP[300 RPM],
            NeutralizationMixTime -> EqualP[15 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfNeutralizationMixes Tests -- *)
    Example[{Options, NumberOfNeutralizationMixes, "If the neutralization mixture will be mixed by pipette, then the number of mixes (number of times the neutralization mixture is pipetted up and down) is set to 10 by default:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Pipette,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfNeutralizationMixes -> 10
          }
        ]
      },
      TimeConstraint -> 600
    ],


    (* -- NeutralizationMixVolume Tests -- *)
    Example[{Options, NeutralizationMixVolume, "If half of the neutralization mixture (the sample volume plus the added neutralization reagent volume) is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Pipette,
        NeutralizationReagentVolume -> 0.2 Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NeutralizationMixVolume, "If half of the neutralization mixture (the sample volume plus the added neutralization reagent volume) is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationMixType -> Pipette,
        NeutralizationReagentVolume -> 1.8 Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationSettlingInstrument and NeutralizationSettlingTemperature Tests -- *)
    Example[{Options, {NeutralizationSettlingInstrument, NeutralizationSettlingTemperature}, "If the neutralization settling time is greater than 0 minutes, then NeutralizationSettlingInstrument is automatically set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"] and NeutralizationSettlingTemperature is automatically set to Ambient unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationSettlingTime -> 10 * Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationSettlingInstrument -> ObjectP[Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"]], (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
            NeutralizationSettlingTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationFiltrationTechnique, NeutralizationFiltrationTime, and NeutralizationFilterStorageCondition Tests -- *)
    Example[{Options, {NeutralizationFiltrationTechnique, NeutralizationFiltrationTime, NeutralizationFilterStorageCondition}, "If NeutralizationSeparationTechnique is set to Filter, then NeutralizationFiltrationTechnique is automatically set to AirPressure, NeutralizationFiltrationTime is automatically set to 10 minutes, and NeutralizationFilterStorageCondition is set to Disposal unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationSeparationTechnique -> Filter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationFiltrationTechnique -> AirPressure,
            NeutralizationFiltrationTime -> EqualP[10 Minute],
            NeutralizationFilterStorageCondition -> Disposal
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationFiltrationInstrument and NeutralizationFilterCentrifugeIntensity Tests -- *)
    Example[{Options, {NeutralizationFiltrationInstrument, NeutralizationFilterCentrifugeIntensity}, "If NeutralizationFiltrationTechnique is set to centrifuge, then NeutralizationFiltrationInstrument is automatically set to Model[Instrument,Centrifuge,\"HiG4\"] and NeutralizationFilterCentrifugeIntensity is automatically set to 3600 G unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationFiltrationTechnique -> Centrifuge,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationFiltrationInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
            NeutralizationFilterCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationFiltrationInstrument and NeutralizationFiltrationPressure Tests -- *)
    Example[{Options, {NeutralizationFiltrationInstrument, NeutralizationFiltrationPressure}, "If NeutralizationFiltrationTechnique is set to AirPressure, then NeutralizationFiltrationInstrument is automatically set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"] and NeutralizationFiltrationPressure is automatically set to 40 PSI unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationFiltrationTechnique -> AirPressure,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationFiltrationInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]], (* Model[Instrument, PressureManifold, "MPE2 Sterile"] *)
            NeutralizationFiltrationPressure -> EqualP[40 PSI]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationFilter and NeutralizationFilterPosition Tests -- *)
    Example[{Options, {NeutralizationFilter, NeutralizationFilterPosition}, "If NeutralizationSeparationTechnique is set to Filter and the sample is already in a filter, then NeutralizationFilter is set to the filter that the sample is already in and NeutralizationFilterPosition is set to the position that the sample is in the filter unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample in Filter (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationSeparationTechnique -> Filter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationFilter -> ObjectP[Object[Container, Plate, Filter, "Test Plate 7 for ExperimentExtractPlasmidDNA " <> $SessionUUID]],
            NeutralizationFilterPosition -> "B3"
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, {NeutralizationFilter, NeutralizationFilterPosition}, "If NeutralizationSeparationTechnique is set to Filter and the sample is not already in a filter, NeutralizationFilter is automatically set to a filter that fits on the filtration instrument, either the centrifuge or pressure manifold and matches MembraneMaterial and PoreSize if they are set and NeutralizationFilterPosition is set to the first available position in the NeutralizationFilter unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationSeparationTechnique -> Filter,
        NeutralizationMembraneMaterial -> Silica,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationFilter -> ObjectP[Model[Container, Plate, Filter]],
            NeutralizationFilterPosition -> "A1"
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationPoreSize and NeutralizationMembraneMaterial Tests -- *)
    Example[{Options, {NeutralizationPoreSize, NeutralizationMembraneMaterial}, "If a neutralization filter is specified, then NeutralizationPoreSize is set to the pore size of the specified filter and NeutralizationMembraneMaterial is set to the membrane material of the specified filter:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationFilter -> Model[Container, Plate, Filter, "Oasis PRiME HLB 96-well Filter Plate"],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationPoreSize -> EqualP[0.008 Micrometer],
            NeutralizationMembraneMaterial -> HLB
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationMembraneMaterial -- *)
    Example[{Options,NeutralizationMembraneMaterial, "If the neutralization separation technique is set to filter and a filter is not specified, then the neutralization membrane material will be set to the material of the resolved filter:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) "<>$SessionUUID],
        NeutralizationSeparationTechnique -> Filter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationMembraneMaterial -> (FilterMembraneMaterialP)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizationPelletVolume, NeutralizationPelletInstrument, NeutralizationPelletCentrifugeIntensity, and NeutralizationPelletCentrifugeTime Tests -- *)
    Example[{Options, {NeutralizationPelletVolume, NeutralizationPelletInstrument, NeutralizationPelletCentrifugeIntensity, NeutralizationPelletCentrifugeTime, NeutralizedPelletStorageCondition}, "If NeutralizationSeparationTechnique is set to Pellet, NeutralizationPelletVolume is automatically set to 1 microliter, NeutralizationPelletInstrument is automatically set to Model[Instrument, Centrifuge, \"HiG4\"], NeutralizationPelletCentrifugeIntensity is automatically set to 3600 G, NeutralizationPelletCentrifugeTime is automatically set to 10 minutes, and NeutralizedPelletStorageCondition is set to Disposal unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationSeparationTechnique -> Pellet,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizationPelletVolume -> EqualP[1 Microliter],
            NeutralizationPelletInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
            NeutralizationPelletCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration],
            NeutralizationPelletCentrifugeTime -> EqualP[10 Minute],
            NeutralizedPelletStorageCondition -> Disposal
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizedSupernatantTransferVolume -- *)
    Example[{Options, NeutralizedSupernatantTransferVolume, "If the separation technique for the sample will be pelleting, then the amount of supernatant transferred from the centrifuged neutralization solution will be 90% of the neutralization reagent plus the sample volume by default:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationSeparationTechnique -> Pellet,
        NeutralizationReagentVolume -> 0.2 * Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizedSupernatantTransferVolume -> EqualP[0.36 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NeutralizedPelletLabel and NeutralizedPelletContainerLabel Tests -- *)
    Example[{Options, {NeutralizedPelletLabel, NeutralizedPelletContainerLabel}, "If NeutralizedPelletStorageCondition is not set to Disposal, NeutralizedPelletLabel and NeutralizedPelletContainerLabel are automatically generated for the neutralized pellet sample unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizedPelletStorageCondition -> Refrigerator,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NeutralizedPelletLabel -> (_String),
            NeutralizedPelletContainerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 600
    ],


    (* Messages tests *)

    (* - Input Errors - *)

    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentExtractPlasmidDNA[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentExtractPlasmidDNA[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentExtractPlasmidDNA[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentExtractPlasmidDNA[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"2mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
          {"A1", containerID},
          Upload -> False,
          Living->True,
          CultureAdhesion->Suspension,
          CellType->Bacterial,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 0.1 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentExtractPlasmidDNA[sampleID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule},
      TimeConstraint -> 600
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"2mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Living->True,
          CultureAdhesion->Suspension,
          CellType->Bacterial,
          Simulation -> simulationToPassIn,
          InitialAmount -> 0.1 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentExtractPlasmidDNA[containerID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule},
      TimeConstraint -> 600
    ],

    Example[{Messages, "InvalidSolidMediaSample", "An error is returned if the input cell samples are in solid media since only suspended or adherent cells are supported for plasmid DNA extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Solid Media Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::InvalidSolidMediaSample,
        Error::InvalidInput
      },
      TimeConstraint -> 600
    ],

    (* Method Validity Error *)

    Example[{Messages, "Error::InvalidExtractionMethod", "An error is returned if a plasmid DNA extraction method is specified and it does not pass ValidObjectQ:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Method -> Object[Method, Extraction, PlasmidDNA, "Invalid PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::InvalidExtractionMethod,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],

    (* Method Conflicting Error *)

    Example[{Messages, "Error::MethodOptionConflict", "An error is returned if a plasmid DNA extraction method is specified but an option is set differently from the method-specified value:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Method -> Object[Method, Extraction, PlasmidDNA, "PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        (* NOTE: NeutralizationSettlingTime is 10 Minute in method and Purification is {LLE, Precipitation, SPE, MBS} in method. *)
        NeutralizationSettlingTime -> 2 Minute,
        Purification -> None,
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::MethodOptionConflict,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],

    (* - Lysis Errors - *)

    Example[{Messages, "Error::ConflictingLysisOutputOptions", "An error is returned if the last step of the extraction is lysis, but the ouput options do not match their counterparts in the lysis options:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        ClarifyLysate -> True,
        ClarifiedLysateContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        Neutralize -> False,
        Purification -> None,
        ContainerOut -> Model[Container, Vessel, "50mL Tube"],
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::ConflictingLysisOutputOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],

    (* - Neutralization Errors - *)

    Example[{Messages, "NeutralizeOptionMismatch", "An error is returned if neutralization options are set if Neutralize is False or vice versa:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Neutralize -> False,
        NeutralizationSettlingTime -> 10 Minute,
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::NeutralizeOptionMismatch,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],

    (* - Purification Errors - *)

    Example[{Messages, "NoPlasmidDNAExtractionStepsSet", "An error is returned if no steps are selected for an extraction (neither lysis, neutralization, nor any purification techniques):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> False,
        Neutralize -> False,
        Purification -> None,
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::NoPlasmidDNAExtractionStepsSet,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],


    (*Shared Unit Tests*)

    (* - SHARED LYSIS TESTS - *)

    (* -- CellType and CultureAdhesion Tests -- *)
    Example[{Options, {CellType, CultureAdhesion}, "CellType is set to the value of the CellType field in the sample object (if specified in the object) and CultrueAdhesion is set to the value of the CultureAdhesion field of the sample object unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            CellType -> Mammalian,
            CultureAdhesion -> Adherent
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- CellType Tests -- *)
    Example[{Options, CellType, "If the CellType field of the input sample is Unspecified, CellType automatically set to the majority cell type of the input sample based on its composition:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Bacterial Cell Sample with Unspecified CellType Field (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        Lyse -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            CellType -> Bacterial
          }
        ]
      },
      Messages :> {Warning::UnknownCellType},
      TimeConstraint -> 600
    ],

    (* -- Dissociate Tests -- *)
    Example[{Options, Dissociate, "If CultureAdhesion is Adherent and LysisAliquot is True, then Dissociate is set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        CultureAdhesion -> Adherent,
        LysisAliquot -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Dissociate -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Dissociate, "If CultureAdhesion is Suspension, then Dissociate is set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        CultureAdhesion -> Suspension,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Dissociate -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Dissociate, "If CultureAdhesion is Adherent but LysisAliquot is False, then Dissociate is set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        CultureAdhesion -> Adherent,
        LysisAliquot -> False,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Dissociate -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],


    (* -- NumberOfLysisSteps Tests -- *)
    Example[{Options, NumberOfLysisSteps, "If any tertiary lysis steps are set, then NumberOfLysisSteps will be set to 3:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryLysisTemperature -> Ambient,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfLysisSteps -> 3
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NumberOfLysisSteps, "If any secondary lysis steps are specified but no tertiary lysis steps are set, then NumberOfLysisSteps will be set to 2:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryLysisTemperature -> Ambient,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfLysisSteps -> 2
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, NumberOfLysisSteps, "If no secondary nor tertiary lysis steps are set, then NumberOfLysisSteps will be set to 1:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfLysisSteps -> 1
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisAliquot Tests -- *)
    Example[{Options, LysisAliquot, "If LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration are specified, LysisAliquot is set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotAmount -> 0.1 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquot -> True
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisAliquot, "If no aliquotting options are set (LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration), LysisAliquot is set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquot -> False
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisAliquotAmount Tests -- *)
    Example[{Options, LysisAliquotAmount, "If LysisAliquot is set to True and TargetCellCount is set, LysisAliquotAmount will be set to attain the target cell count:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        TargetCellCount -> 10^9 EmeraldCell,
        LysisAliquot -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.1 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer is specified but TargetCellCount is not specified, LysisAliquotAmount will be set to All if the input sample is less than half of the LysisAliquotContiner's max volume:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        LysisAliquotContainer -> Model[Container, Plate, "id:n0k9mGkwbvG4"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.2 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer is specified but TargetCellCount is not specified, LysisAliquotAmount will be set to half of the LysisAliquotContiner's max volume if the input sample volume is greater than that value:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        LysisAliquotContainer -> Model[Container, Plate, "id:4pO6dMOqKBaX"], (* Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"] *)
        (* NOTE:Solution volume required to avoid low volume warning *)
        LysisSolutionVolume -> 150 Microliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[150 Microliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer and TargetCellCount are not specified, LysisAliquotAmount will be set to 25% of the input sample volume:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        LysisAliquot -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.05 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisAliquotContainer and LysisAliquotContainerLabel Tests -- *)
    Example[{Options, {LysisAliquotContainer, LysisAliquotContainerLabel}, "If LysisAliquot is True, LysisAliquotContainer will be assigned by PackContainers and LysisAliquotContainerLabel will be automatically generated, :"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        LysisAliquot -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LysisAliquotContainer -> ({(_Integer), ObjectP[Model[Container]]}|ObjectP[Model[Container]]),
            LysisAliquotContainerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PreLysisPellet Tests -- *)
    Example[{Options, PreLysisPellet, "If any pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        PreLysisPelletingTime -> 1 Minute,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPellet -> True
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PreLysisPellet, "If no pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPellet -> False
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- PreLysisPelletingCentrifuge, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, PreLysisSupernatantContainer, PreLysisSupernatantLabel, and PreLysisSupernatantContainerLabel Tests -- *)
    Example[{Options, {PreLysisPelletingCentrifuge, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, PreLysisSupernatantContainer, PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel}, "If PreLysisPellet is set to True, PreLysisPelletCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"], PreLysisPelletingTime is automatically set to 10 minutes, PreLysisSupernatantVolume is automatically set to 80% of the of total sample volume, PreLysisSupernatantStorageCondition is automatically set to Disposal, PreLysisSupernatantContainer is automatically set by PackContainers, PreLysisSupernatantLabel will be automatically generated, and PreLysisSupernatantContainerLabel will be automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        PreLysisPellet -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PreLysisPelletingCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
            PreLysisPelletingTime -> 10 Minute,
            PreLysisSupernatantVolume -> EqualP[0.16 Milliliter],
            PreLysisSupernatantStorageCondition -> Disposal,
            PreLysisSupernatantContainer -> {(_Integer), ObjectP[Model[Container]]},
            PreLysisSupernatantLabel -> (_String),
            PreLysisSupernatantContainerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PreLysisPelletingIntensity Tests -- *)
    Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Mammalian, PreLysisPelletCentrifugeIntensity is automatically set to 1560 RPM:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        PreLysisPellet -> True,
        CellType -> Mammalian,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> EqualP[1560 RPM]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Bacterial, PreLysisPelletCentrifugeIntensity is automatically set to 4030 RPM:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        PreLysisPellet -> True,
        CellType -> Bacterial,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> EqualP[4030 RPM]
        }]
      },
      TimeConstraint -> 600
    ],
    (* NOTE:Yeast cells currently not supported, but test will be needed when it is supported. *)
    Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Yeast, PreLysisPelletCentrifugeIntensity is automatically set to 2850 RPM:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        PreLysisPellet -> True,
        CellType -> Yeast,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> EqualP[2850 RPM]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- PreLysisDilute Tests -- *)
    Example[{Options, PreLysisDilute, "If either PreLysisDiluent or PreLysisDilutionVolume are set, then PreLysisDilute is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        PreLysisDilutionVolume -> 0.2 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDilute -> True
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- PreLysisDiluent Tests -- *)
    Example[{Options, PreLysisDiluent, "If PreLysisDilute is set to True, PreLysisDiluent is automatically set to Model[Sample, StockSolution, \"1x PBS from 10X stock\"]:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        PreLysisDilute -> True,
        (* TargetCellConcentration added to avoid error for not having enough into to make PreLysisDilutionVolume *)
        TargetCellConcentration -> 5 * 10^9 EmeraldCell / Milliliter,
        LysisAliquot -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDiluent -> ObjectP[Model[Sample, StockSolution, "id:9RdZXv1KejGK"]] (* Model[Sample, StockSolution, "1x PBS from 10X stock, Alternative Preparation 1"] *)
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- PreLysisDilutionVolume Tests -- *)
    Example[{Options, PreLysisDilutionVolume, "If PreLysisDilute is True and a TargetCellConcentration is specified, then PreLysisDilutionVolume is set to the volume required to attain the TargetCellConcentration:"},
      ExperimentExtractPlasmidDNA[
        {
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        PreLysisDilute -> True,
        TargetCellConcentration -> 5 * 10^9 EmeraldCell / Milliliter,
        LysisAliquot -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDilutionVolume -> EqualP[0.05 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisSolution, LysisTime, LysisTemperature, and LysisIncubationInstrument Tests -- *)
    Example[{Options, {LysisSolution, LysisTime, LysisTemperature, LysisIncubationInstrument}, "If Lyse is set to True, LysisSolution is automatically set to Model[Sample, StockSolution, \"Alkaline lysis buffer for Plasmid DNA extraction\"], LysisTime is automatically set to 15 minutes, LysisTemperature is automatically set to Ambient, and LysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified LysisTemperature,  unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LysisSolution -> Model[Sample, StockSolution, "id:eGaklda6dGvE"], (* Model[Sample, StockSolution, "Alkaline lysis buffer for Plasmid DNA extraction"] *)
            LysisTime -> EqualP[15 Minute],
            LysisTemperature -> Ambient,
            LysisIncubationInstrument -> ObjectP[Model[Instrument]]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisSolutionVolume Tests -- *)
    Example[{Options, LysisSolutionVolume, "If LysisAliquot is False, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquot -> False,
        NumberOfLysisSteps -> 1,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisSolutionVolume -> EqualP[0.9 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisSolutionVolume, "If LysisAliquotContainer is set, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        NumberOfLysisSteps -> 1,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisSolutionVolume -> EqualP[0.9 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisSolutionVolume, "If LysisAliquot is True and LysisAliquotContainer is not set, LysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquot -> True,
        LysisAliquotAmount -> 0.1 Milliliter,
        NumberOfLysisSteps -> 1,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisSolutionVolume -> EqualP[0.9 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],


    (* -- LysisMixType Tests -- *)
    Example[{Options, LysisMixType, "If LysisMixVolume or NumberOfLysisMixes are specified, LysisMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLysisMixes -> 3,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Pipette
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisMixType, "If LysisMixRate, LysisMixTime, or LysisMixInstrument are specified, LysisMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisMixTime -> 1 Minute,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Shake
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisMixType, "If no mixing options are set and the sample will be mixed in a plate, LysisMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Shake
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisMixType, "If no mixing options are set and the sample will be mixed in a tube, LysisMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"], (*Model[Container, Vessel, "2mL Tube"]*)
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Pipette
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisMixRate Tests -- *)
    Example[{Options, {LysisMixRate, LysisMixTime, LysisMixInstrument}, "If LysisMixType is set to Shake, LysisMixRate is automatically set to 200 RPM, LysisMixTime is automatically set to 1 minute, and LysisMixInstrument is automatically set to an available shaking device compatible with the specified LysisMixRate and LysisMixTemperature unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisMixType -> Shake,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LysisMixRate -> EqualP[200 RPM],
            LysisMixTime -> EqualP[1 Minute],
            LysisMixInstrument -> ObjectP[Model[Instrument]]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfLysisMixes Tests -- *)
    Example[{Options, NumberOfLysisMixes, "If LysisMixType is set to Pipette, NumberOfLysisMixes is automatically set to 10:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisMixType -> Pipette,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfLysisMixes -> 10
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisMixVolume Tests -- *)
    Example[{Options, LysisMixVolume, "If LysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, LysisMixVolume is automatically set to 50% of the total solution volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisMixType -> Pipette,
        LysisSolutionVolume -> 0.2 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixVolume -> EqualP[0.2 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LysisMixVolume, "If LysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, LysisMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisMixType -> Pipette,
        LysisSolutionVolume -> 1.8 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- LysisMixTemperature Tests -- *)
    Example[{Options, LysisMixTemperature, "If LysisMixType is set to either Pipette or Shake, LysisMixTemperature is automatically set to Ambient unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisMixType -> Shake,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixTemperature -> Ambient
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryLysisSolution Tests -- *)
    Example[{Options, SecondaryLysisSolution, "Unless otherwise specified, SecondaryLysisSolution is set to the the same solution as LysisSolution:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLysisSteps -> 2,
        LysisSolution -> Model[Sample, StockSolution, "id:eGaklda6dGvE"], (* Model[Sample, StockSolution, "Alkaline lysis buffer for Plasmid DNA extraction"] *)
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolution -> ObjectP[Model[Sample, StockSolution, "id:eGaklda6dGvE"]] (* Model[Sample, StockSolution, "Alkaline lysis buffer for Plasmid DNA extraction"] *)
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryLysisSolutionVolume Tests -- *)
    Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1 and LysisAliquot is False, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLysisSteps -> 2,
        LysisAliquot -> False,
        LysisSolutionVolume -> 0.2 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1 and LysisAliquotContainer is set, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        NumberOfLysisSteps -> 2,
        LysisSolutionVolume -> 0.2 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1, LysisAliquot is True, and LysisAliquotContainer is not set, SecondaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquot -> True,
        NumberOfLysisSteps -> 2,
        LysisAliquotAmount -> 0.1 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolutionVolume -> EqualP[0.45 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryLysisMixType Tests -- *)
    Example[{Options, SecondaryLysisMixType, "If SecondaryLysisMixVolume or SecondaryNumberOfLysisMixes are specified, SecondaryLysisMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryNumberOfLysisMixes -> 3,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Pipette
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SecondaryLysisMixType, "If SecondaryLysisMixRate, SecondaryLysisMixTime, or SecondaryLysisMixInstrument are specified, SecondaryLysisMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryLysisMixTime -> 1 Minute,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Shake
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SecondaryLysisMixType, "If NumberOfLysisSteps is greater than 1, no mixing options are set, and the sample will be mixed in a plate, SecondaryLysisMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        NumberOfLysisSteps -> 2,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Shake
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SecondaryLysisMixType, "If NumberOfLysisSteps is greater than 1, no mixing options are set, and the sample will be mixed in a tube, SecondaryLysisMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"], (*Model[Container, Vessel, "2mL Tube"]*)
        NumberOfLysisSteps -> 2,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Pipette
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryLysisMixRate, SecondaryLysisMixTime, and SecondaryLysisMixInstrument Tests -- *)
    Example[{Options, {SecondaryLysisMixRate, SecondaryLysisMixTime, SecondaryLysisMixInstrument}, "If SecondaryLysisMixType is set to Shake, SecondaryLysisMixRate is automatically set to 200 RPM, SecondaryLysisMixTime is automatically set to 1 minute, and SecondaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified SecondaryLysisMixRate and SecondaryLysisMixTemperature unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryLysisMixType -> Shake,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SecondaryLysisMixRate -> EqualP[200 RPM],
            SecondaryLysisMixTime -> EqualP[1 Minute],
            SecondaryLysisMixInstrument -> ObjectP[Model[Instrument]]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryNumberOfLysisMixes Tests -- *)
    Example[{Options, SecondaryNumberOfLysisMixes, "If SecondaryLysisMixType is set to Pipette, SecondaryNumberOfLysisMixes is automatically set to 10:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryLysisMixType -> Pipette,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryNumberOfLysisMixes -> 10
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryLysisMixVolume Tests -- *)
    Example[{Options, SecondaryLysisMixVolume, "If SecondaryLysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, SecondaryLysisMixVolume is automatically set to 50% of the total solution volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryLysisMixType -> Pipette,
        LysisSolutionVolume -> 0.2 Milliliter,
        SecondaryLysisSolutionVolume -> 0.2 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixVolume -> EqualP[0.3 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SecondaryLysisMixVolume, "If SecondaryLysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, SecondaryLysisMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryLysisMixType -> Pipette,
        LysisSolutionVolume -> 0.9 Milliliter,
        SecondaryLysisSolutionVolume -> 0.9 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryLysisMixTemperature Tests -- *)
    Example[{Options, SecondaryLysisMixTemperature, "If SecondaryLysisMixType is set to either Pipette or Shake, SecondaryLysisMixTemperature is automatically set to Ambient unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SecondaryLysisMixType -> Shake,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixTemperature -> Ambient
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondaryLysisTime Tests -- *)
    Example[{Options, {SecondaryLysisTime, SecondaryLysisTemperature, SecondaryLysisIncubationInstrument}, "If NumberOfLysisSteps is greater than 1, SecondaryLysisTime is automatically set to 15 minutes, SecondaryLysisTemperature is automatically set to Ambient, and SecondaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified SecondaryLysisTemperature unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLysisSteps -> 2,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisTime -> EqualP[15 Minute]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryLysisSolution Tests -- *)
    Example[{Options, TertiaryLysisSolution, "If NumberOfLysisSteps is greater than 2, TertiaryLysisSolution is the same as LysisSolution unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLysisSteps -> 3,
        LysisSolution -> Model[Sample, StockSolution, "id:eGaklda6dGvE"], (* Model[Sample, StockSolution, "Alkaline lysis buffer for Plasmid DNA extraction"] *)
        TertiaryLysisSolutionVolume -> 0.2 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisSolution -> ObjectP[Model[Sample, StockSolution, "id:eGaklda6dGvE"]] (* Model[Sample, StockSolution, "Alkaline lysis buffer for Plasmid DNA extraction"] *)
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryLysisSolutionVolume Tests -- *)
    Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2 and LysisAliquot is False, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLysisSteps -> 3,
        LysisAliquot -> False,
        LysisSolutionVolume -> 0.3 Milliliter,
        SecondaryLysisSolutionVolume -> 0.3 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2 and LysisAliquotContainer is set, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of the TertiaryLysisSolutionVolume) divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        NumberOfLysisSteps -> 3,
        LysisSolutionVolume -> 0.3 Milliliter,
        SecondaryLysisSolutionVolume -> 0.3 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2, LysisAliquot is True, and LysisAliquotContainer is not set, TertiaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquot -> True,
        NumberOfLysisSteps -> 3,
        LysisAliquotAmount -> 0.1 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisSolutionVolume -> EqualP[0.3 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryLysisMixType Tests -- *)
    Example[{Options, TertiaryLysisMixType, "If TertiaryLysisMixVolume or TertiaryNumberOfLysisMixes are specified, TertiaryLysisMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryNumberOfLysisMixes -> 3,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Pipette
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, TertiaryLysisMixType, "If TertiaryLysisMixRate, TertiaryLysisMixTime, or TertiaryLysisMixInstrument are specified, TertiaryLysisMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryLysisMixTime -> 1 Minute,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Shake
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, TertiaryLysisMixType, "If NumberOfLysisSteps is greater than 2, no mixing options are set, and the sample will be mixed in a plate, TertiaryLysisMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        NumberOfLysisSteps -> 3,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Shake
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, TertiaryLysisMixType, "If NumberOfLysisSteps is greater than 2, no mixing options are set, and the sample will be mixed in a tube, TertiaryLysisMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"], (*Model[Container, Vessel, "2mL Tube"]*)
        NumberOfLysisSteps -> 3,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Pipette
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryLysisMixRate, TertiaryLysisMixTime, and TertiaryLysisMixInstrument Tests -- *)
    Example[{Options, {TertiaryLysisMixRate, TertiaryLysisMixTime, TertiaryLysisMixInstrument}, "If TertiaryLysisMixType is set to Shake, TertiaryLysisMixRate is automatically set to 200 RPM, TertiaryLysisMixTime is automatically set to 1 minute, and TertiaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified TertiaryLysisMixRate and TertiaryLysisMixTemperature unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryLysisMixType -> Shake,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixRate -> EqualP[200 RPM],
          TertiaryLysisMixTime -> EqualP[1 Minute],
          TertiaryLysisMixInstrument -> ObjectP[Model[Instrument]]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryNumberOfLysisMixes Tests -- *)
    Example[{Options, TertiaryNumberOfLysisMixes, "If TertiaryLysisMixType is set to Pipette, TertiaryNumberOfLysisMixes is automatically set to 10:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryLysisMixType -> Pipette,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryNumberOfLysisMixes -> 10
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryLysisMixVolume Tests -- *)
    Example[{Options, TertiaryLysisMixVolume, "If TertiaryLysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, TertiaryLysisMixVolume is automatically set to 50% of the total solution volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryLysisMixType -> Pipette,
        LysisSolutionVolume -> 0.2 Milliliter,
        SecondaryLysisSolutionVolume -> 0.2 Milliliter,
        TertiaryLysisSolutionVolume -> 0.2 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixVolume -> EqualP[0.4 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, TertiaryLysisMixVolume, "If TertiaryLysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, TertiaryLysisMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryLysisMixType -> Pipette,
        LysisSolutionVolume -> 0.6 Milliliter,
        SecondaryLysisSolutionVolume -> 0.6 Milliliter,
        TertiaryLysisSolutionVolume -> 0.6 Milliliter,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryLysisMixTemperature Tests -- *)
    Example[{Options, TertiaryLysisMixTemperature, "If TertiaryLysisMixType is set to either Pipette or Shake, TertiaryLysisMixTemperature is automatically set to Ambient unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        TertiaryLysisMixType -> Shake,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixTemperature -> Ambient
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- TertiaryLysisTime, TertiaryLysisTemperature, and TertiaryLysisIncubationInstrument Tests -- *)
    Example[{Options, {TertiaryLysisTime, TertiaryLysisTemperature, TertiaryLysisIncubationInstrument}, "If NumberOfLysisSteps is greater than 2, TertiaryLysisTime is automatically set to 15 minutes, TertiaryLysisTemperature is automatically set to Ambient, and TertiaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified TertiaryLysisTemperature unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        NumberOfLysisSteps -> 3,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            TertiaryLysisTime -> EqualP[15 Minute],
            TertiaryLysisTemperature -> Ambient,
            TertiaryLysisIncubationInstrument -> ObjectP[Model[Instrument]]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- ClarifyLysate Tests -- *)
    Example[{Options, ClarifyLysate, "If any clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        ClarifyLysateTime -> 1 Minute,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysate -> True
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, ClarifyLysate, "If no clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Lyse -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysate -> False
        }]
      },
      TimeConstraint -> 600
    ],

    (* -- ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, PostClarificationPelletLabel, PostClarificationPelletStorageCondition, ClarifiedLysateContainer, and ClarifiedLysateContainerLabel Tests -- *)
    Example[{Options, {ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, PostClarificationPelletLabel, PostClarificationPelletStorageCondition, ClarifiedLysateContainer, ClarifiedLysateContainerLabel}, "If ClarifyLysate is set to True, ClarifyLysateCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"], ClarifyLysateIntensity is automatically set to 5700 RPM, ClarifyLysateTime is automatically set to 10 minutes, ClarifiedLysateVolume is set automatically set to 90% of the volume of the lysate, PostClarificationPelletLabel will be automatically generated, PostClarificationPelletStorageCondition will be automatically set to Disposal, ClarifiedLysateContainer will be automatically selected to accommodate the volume of the clarified lysate, and ClarifiedLysateContainerLabel will be automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        ClarifyLysate -> True,
        (* No neutralization nor purification to speed up testing. *)
        Neutralize -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ClarifyLysateCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
            ClarifyLysateIntensity -> EqualP[5700 RPM],
            ClarifyLysateTime -> EqualP[10 Minute],
            ClarifiedLysateVolume -> EqualP[0.99 Milliliter],
            PostClarificationPelletLabel -> (_String),
            PostClarificationPelletStorageCondition -> Disposal,
            ClarifiedLysateContainer -> ObjectP[Model[Container]],
            ClarifiedLysateContainerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 600
    ],


    (* - SHARED PURIFICATION TESTS - *)

    Example[{Options, Purification, "If any liquid-liquid extraction options are set, then a liquid-liquid extraction will be added to the list of purification steps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Purification -> {LiquidLiquidExtraction}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Purification, "If any precipitation options are set, then precipitation will be added to the list of purification steps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Purification -> {Precipitation}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Purification, "If any solid phase extraction options are set, then a solid phase extraction will be added to the list of purification steps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SolidPhaseExtractionTechnique -> Pressure,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Purification -> {SolidPhaseExtraction}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Purification, "If any magnetic bead separation options are set, then a magnetic bead separation will be added to the list of purification steps:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMixTime -> 5 * Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Purification -> {MagneticBeadSeparation}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Purification, "If options from multiple purification steps are specified, then they will be added to the purification step list in the order liquid-liquid extraction, precipitation, solid phase extraction, then magnetic bead separation:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Low Volume Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 1,
        PrecipitationNumberOfWashes -> 1,
        NumberOfMagneticBeadSeparationWashes -> 1,
        SolidPhaseExtractionElutionTime -> 2 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Purification -> {LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, MagneticBeadSeparation}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Purification, "If no options relating to purification steps are specified, then a liquid-liquid extraction followed by a precipitation will be used by default:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Purification -> {LiquidLiquidExtraction, Precipitation}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* - Purification Errors - *)

    Example[{Messages, "LiquidLiquidExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 liquid-liquid extractions called for in the purification step list:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> {LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction},
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::LiquidLiquidExtractionStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],
    Example[{Messages, "PurificationStepCountLimitExceeded", "An error is returned if there are more than 3 precipitations called for in the purification step list:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> {Precipitation, Precipitation, Precipitation, Precipitation},
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::PrecipitationStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],
    Example[{Messages, "SolidPhaseExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 solid phase extractions called for in the purification step list:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction},
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::SolidPhaseExtractionStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],
    Example[{Messages, "MagneticBeadSeparationStepCountLimitExceeded", "An error is returned if there are more than 3 magnetic bead separations called for in the purification step list:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> {MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation},
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::MagneticBeadSeparationStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],


    (* - SHARED LLE TESTS - *)

    (* Basic Example *)
    Example[{Basic, "Crude samples can be purified with liquid-liquid extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],

    (* - Liquid-liquid Extraction Options - *)

    (* -- LiquidLiquidExtractionTechnique Tests -- *)
    Example[{Options, LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are set, then LiquidLiquidExtractionTechnique is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidBoundaryVolume -> {5 Microliter, 5 Microliter, 5 Microliter},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTechnique -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are not set, then LiquidLiquidExtractionTechnique is automatically set to PhaseSeparator:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTechnique -> PhaseSeparator
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionDevice Tests --*)
    Example[{Options, LiquidLiquidExtractionDevice, "If LiquidLiquidExtractionTechnique is set to PhaseSeparator, then LiquidLiquidExtractionDevice is automatically set to Model[Container,Plate,PhaseSeparator,\"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionDevice -> ObjectP[Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"]] (* Model[Container, Plate, PhaseSeparator, "Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionSelectionStrategy Tests -- *)
    Example[{Options, LiquidLiquidExtractionSelectionStrategy, "If NumberOfLiquidLiquidExtractions is set to one, then LiquidLiquidExtractionSelectionStrategy is not specified (since a selection strategy is only required for multiple extraction rounds):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Null
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round matches the target phase, then LiquidLiquidExtractionSelectionStrategy is automatically set to Positive:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Positive
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round does not match the target phase, then LiquidLiquidExtractionSelectionStrategy is automatically set to Negative:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        AqueousSolvent -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Negative
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionSelectionStrategy, "If LiquidLiquidExtractionTargetPhase and AqueousSolvent/OrganicSovlent are not set, then LiquidLiquidExtractionSelectionStrategy is automatically set to Positive:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSelectionStrategy -> Positive
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- IncludeLiquidBoundary Tests -- *)
    Example[{Options, {IncludeLiquidBoundary, LiquidLiquidExtractionTransferLayer}, "If LiquidLiquidExtractionTechnique is set to Pipette, then IncludeLiquidBoundary is automatically set to False for each extraction round and LiquidLiquidExtractionTransferLayer will be set to Top for each extraction round unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            IncludeLiquidBoundary -> {False, False, False},
            LiquidLiquidExtractionTransferLayer -> {Top, Top, Top}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionTargetPhase Tests -- *)
    Example[{Options, LiquidLiquidExtractionTargetPhase, "The target phase is selected based on the phase that the plasmid DNA is more likely to be found in based on the PredictDestinationPhase[...] function:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetPhase -> Aqueous
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionTargetLayer Tests -- *)
    Example[{Options, LiquidLiquidExtractionTargetLayer, "The target layer for each extraction round is calculated from the density of the sample's aqueous and organic layers (if present in the sample), the density of the AqueousSolvent and OrganicSolvent options (if specified), and the target phase:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Top, Top, Top}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is less dense than the organic phase, then the target layer will be the top layer:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        OrganicSolvent -> Model[Sample, "Dichloromethane, Reagent Grade"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Top}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is denser than the organic phase, then the target layer will be the bottom layer:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        OrganicSolvent -> Model[Sample, "Ethyl acetate, HPLC Grade"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Bottom}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is less dense than the organic phase, then the target layer will be the bottom layer:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Organic,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        OrganicSolvent -> Model[Sample, "Dichloromethane, Reagent Grade"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Bottom}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is denser than the organic phase, then the target layer will be the top layer:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        LiquidLiquidExtractionTargetPhase -> Organic,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        OrganicSolvent -> Model[Sample, "Ethyl acetate, HPLC Grade"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTargetLayer -> {Top}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionContainer Tests -- *)
    Example[{Options, LiquidLiquidExtractionContainer, "If the sample is in a non-centrifuge-compatible container and LiquidLiquidExtractionCentrifuge is set to True, then LiquidLiquidExtractionContainer will be automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionCentrifuge -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> {1, ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]} (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionContainer, "If heating or cooling is specified, then LiquidLiquidExtractionContainer will be automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] (since the robotic heater/cooler units are only compatible with Plate format containers):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTemperature -> 90.0 * Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> {1, ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]} (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionContainer, "If LiquidLiquidExtractionCentrifuge is set to True and the extraction will take place at ambient temperature, then the extraction container will be selected using the PreferredContainer function (to find a robotic-compatible container that will hold the sample):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionCentrifuge -> True,
        LiquidLiquidExtractionTemperature -> Ambient,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> ({(_Integer), ObjectP[Model[Container]]}|ObjectP[Model[Container]])
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionContainerWell Tests -- *)
    Example[{Options, LiquidLiquidExtractionContainerWell, "If a LiquidLiquidExtractionContainer is specified, then LiquidLiquidExtractionContainerWell will automatically be set to the first available well in the container:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainerWell -> "A1"
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- AqueousSolvent Tests-- *)
    Example[{Options, AqueousSolvent, "If aqueous solvent is required for a separation, then AqueousSolvent will automatically be set to Model[Sample, \"Milli-Q water\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolvent -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]] (* Model[Sample, "Milli-Q water"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- AqueousSolventVolume Tests -- *)
    Example[{Options, AqueousSolventVolume, "If an AqueousSolventRatio is set, then the AqueousSolventVolume is calculated from the ratio and the sample volume (SampleVolume/AqueousSolventRatio):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        AqueousSolventRatio -> 5,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolventVolume -> EqualP[0.04 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, AqueousSolventVolume, "If an AqueousSolvent is set and an AqueousSolventRatio is not set, then the AqueousSolventVolume will be 20% of the sample volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolventVolume -> EqualP[0.04 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- AqueousSolventRatio Tests -- *)
    Example[{Options, AqueousSolventRatio, "If an AqueousSolventVolume is set, then the AqueousSolventRatio is calculated from the set AqueousSolventVolume and the sample volume (SampleVolume/AqueousSolventVolume):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        AqueousSolventVolume -> 0.04 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolventRatio -> EqualP[5.0]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, AqueousSolventRatio, "If an AqueousSolvent is set and an AqueousSolventVolume is not set, then the AqueousSolventRatio is set to 5:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolventRatio -> EqualP[5.0]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- OrganicSolvent Tests -- *)
    Test[{"If an OrganicSolventVolume or OrganicSolventRatio are specified, then OrganicSolvent will be set to Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"] (a phenol:chloroform:iso-amyl alcohol mixture often used in phenol-chloroform extractions):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        OrganicSolventVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "id:vXl9j5lWlb7e"]] (* Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, OrganicSolvent, "If LiquidLiquidExtractionTargetPhase is set to Organic and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then OrganicSolvent will be set to Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"] (a phenol:chloroform:iso-amyl alcohol mixture often used in phenol-chloroform extractions):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "id:vXl9j5lWlb7e"]] (* Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, OrganicSolvent, "If the target phase is set to Aqueous and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then OrganicSolvent will be set to Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"] (a phenol:chloroform:iso-amyl alcohol mixture often used in phenol-chloroform extractions):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "id:vXl9j5lWlb7e"]] (* Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, OrganicSolvent, "If organic solvent is otherwise required for an extraction and LiquidLiquidExtractionTechnique is set to Pipette, then ethyl acetate (Model[Sample, \"Ethyl acetate, HPLC Grade\"]) will be used as the organic solvent:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]] (* Model[Sample, "Ethyl acetate, HPLC Grade"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    (*FIXME::Refuses to use ethyl acetate as organic solvent for some reason even though absolute ethanol is less dense. Tracked it down to possible issue with PredictSolventPhase because it's saying sample in Ethanol is Unknown phase with no solvent nor density. Add back in when fix is determined.*)
    (*Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a phase separator will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> PhaseSeparator), then ethyl acetate (Model[Sample, \"Ethyl acetate, HPLC Grade\"]) will be used as the organic solvent if it is denser than the aqueous phase, since the organic layer needs to be below the aqueous layer to pass through the hydrophobic frit:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in Ethanol (Test for ExperimentExtractPlasmidDNA) "<>$SessionUUID],
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
        {
          OrganicSolvent -> ObjectP[Model[Sample, "id:9RdZXvKBeeGK"]] (* Model[Sample, "Ethyl acetate, HPLC Grade"] *)
        }
      ],
      TimeConstraint -> 600
    ],}*)
    Example[{Options, OrganicSolvent, "If organic solvent is otherwise required for an extraction and LiquidLiquidExtractionTechnique is set to PhaseSeparator, Model[Sample, \"Chloroform\"] will be used if Model[Sample, \"Ethyl acetate, HPLC Grade\"] is not dense enough to be denser than the aqueous layer, since the organic layer needs to be below the aqueous layer to pass through the hydrophobic frit:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "id:eGakld01zzXo"]] (* Model[Sample, "Chloroform"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- OrganicSolventVolume Tests -- *)
    Example[{Options, OrganicSolventVolume, "If an OrganicSolventRatio is set, then the OrganicSolventRatio is calculated from the ratio of the sample volume (SampleVolume/OrganicSolventRatio):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        OrganicSolventRatio -> 5,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolventVolume -> EqualP[0.04 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, OrganicSolventVolume, "If an OrganicSolvent is set and an OrganicSolventVolume is not set, then the OrganicSolventVolume will be automatically set to 20% of the sample volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolventVolume -> EqualP[0.04 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- OrganicSolventRatio Tests -- *)
    Example[{Options, OrganicSolventRatio, "If an OrganicSolventVolume is set, then the OrganicSolventRatio is calculated from the set OrganicSolventVolume and the sample volume (SampleVolume/OrganicSolventVolume):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        OrganicSolventVolume -> 0.04 * Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolventRatio -> EqualP[5.0]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, OrganicSolventRatio, "If an organic solvent is set, then the organic solvent ratio is set to 5:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        OrganicSolvent -> Model[Sample, "id:vXl9j5lWlb7e"], (* Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolventRatio -> EqualP[5.0]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionSolventAdditions Tests -- *)
    Example[{Options, LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an organic or unknown phase, then an aqueous solvent is added to that sample:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {{ObjectP[], ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]], ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]}} (* Model[Sample, "Milli-Q water"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an aqueous phase, then organic solvent is added to that sample:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {{ObjectP[Model[Sample, "id:vXl9j5lWlb7e"]]..}} (* Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionSolventAdditions, "If the starting sample of an extraction is biphasic, then no solvent is added for the first extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Biphasic Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {None, ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]], ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]} (* Model[Sample, "Milli-Q water"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- Demulsifier Tests -- *)
    Example[{Options, Demulsifier, "If DemulsifierAdditions are specified, then Demulsifier will automatically be set to the specified demulsifier in DemulsifierAdditions:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        DemulsifierAdditions -> {Model[Sample, StockSolution, "id:AEqRl954GJb6"], None, None}, (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Demulsifier -> ObjectP[Model[Sample, StockSolution, "id:AEqRl954GJb6"]] (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Demulsifier, "If a DemulsifierAmount is specified, then Demulsifier will automatically be set to Model[Sample, StockSolution, \"5M Sodium Chloride\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        DemulsifierAmount -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Demulsifier -> ObjectP[Model[Sample, StockSolution, "id:AEqRl954GJb6"]] (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, Demulsifier, "If neither DemulsifierAdditions nor DemulsifierAmount are set, then a Demulsifier is automatically set to None:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Demulsifier -> None
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- DemulsifierAmount Tests-- *)
    Example[{Options, DemulsifierAmount, "If Demulsifier and/or DemulsifierAdditions are specified, then the DemulsifierAmount is set to 10% of the sample volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Demulsifier -> Model[Sample, StockSolution, "id:AEqRl954GJb6"], (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAmount -> EqualP[0.02 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- DemulsifierAdditions Tests -- *)
    Example[{Options, DemulsifierAdditions, "If a Demulsifier is not specified, then the DemulsifierAdditions are set to None for each round:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {None, None, None}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, DemulsifierAdditions, "If there will only be one round of liquid-liquid extraction and a Demulsifier is specified, then the Demulsifier will be added for that one extraction round in DemulsifierAdditions:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 1,
        Demulsifier -> Model[Sample, StockSolution, "id:AEqRl954GJb6"], (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "id:AEqRl954GJb6"]]} (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a Demulsifier is specified, and the organic phase will be used in subsequent extraction rounds, then the Demulsifier will be added for each extraction round in DemulsifierAdditions (since the demulsifier will likely be removed with the aqueous phase each round):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        Demulsifier -> Model[Sample, StockSolution, "id:AEqRl954GJb6"], (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "id:AEqRl954GJb6"]]..} (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a Demulsifier is specified, and the aqueous phase will be used in subsequent extraction rounds, then the Demulsifier will only be added for the first extraction round in DemulsifierAdditions (since the demulsifier is usually a salt solution which stays in the aqueous phase):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        Demulsifier -> Model[Sample, StockSolution, "id:AEqRl954GJb6"], (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "id:AEqRl954GJb6"]], None, None} (* Model[Sample, StockSolution, "5M Sodium Chloride"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionTemperature, NumberOfLiquidLiquidExtractions, LiquidLiquidExtractionSettlingTime, ImpurityLayerStorageCondition, ImpurityLayerContainerOutWell, ImpurityLayerLabel, and ImpurityLayerContainerLabel Tests -- *)
    Example[{Options, {LiquidLiquidExtractionTemperature, NumberOfLiquidLiquidExtractions, LiquidLiquidExtractionSettlingTime, ImpurityLayerStorageCondition, ImpurityLayerContainerOutWell, ImpurityLayerLabel, ImpurityLayerContainerLabel}, "If LiquidLiquidExtraction is included in Purification, LiquidLiquidExtractionTemperature is automatically set to Ambient, NumberOfLiquidLiquidExtractions is automatically set to 3, LiquidLiquidExtractionSettlingTime is set to 1 minute, ImpurityLayerStorageCondition is set to Disposal for each extraction round, ImpurityLayerContainerOutWell is automatically set to the first empty well of the ImpurityLayerContainerOut, ImpurityLayerLabel is automatically generated, and ImpurityLayerContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTemperature -> Ambient,
            NumberOfLiquidLiquidExtractions -> 3,
            LiquidLiquidExtractionSettlingTime -> EqualP[1 Minute],
            ImpurityLayerStorageCondition -> Disposal,
            ImpurityLayerContainerOutWell -> "A1",
            ImpurityLayerLabel -> (_String),
            ImpurityLayerContainerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionMixType Tests -- *)
    Example[{Options, LiquidLiquidExtractionMixType, "If LiquidLiquidExtractionMixTime or LiquidLiquidExtractionMixRate is specified, then LiquidLiquidExtractionMixType will automatically be set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionMixTime -> 1 * Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionMixType, "If mixing options (LiquidLiquidExtractionMixTime and LiquidLiquidExtractionMixRate) are not specified, then LiquidLiquidExtractionMixType will automatically be set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionMixTime and LiquidLiquidExtractionMixRate Tests -- *)
    Example[{Options, {LiquidLiquidExtractionMixTime, LiquidLiquidExtractionMixRate}, "If LiquidLiquidExtractionMixType is set to Shake, then LiquidLiquidExtractionMixTime is automatically set to 30 seconds and LiquidLiquidExtractionMixRate is set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixTime -> EqualP[30 Second],
            LiquidLiquidExtractionMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfLiquidLiquidExtractionMixes Tests -- *)
    Example[{Options, NumberOfLiquidLiquidExtractionMixes, "If tLiquidLiquidExtractionMixType is set to Pipette, then NumberOfLiquidLiquidExtractionMixes is automatically set to 10:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfLiquidLiquidExtractionMixes -> 10
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionMixVolume Tests -- *)
    Example[{Options, LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is less than 970 microliters, then LiquidLiquidExtractionMixVolume will be automatically set to half of the liquid-liquid extraction mixture:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        OrganicSolventVolume -> 0.2 * Milliliter,
        NumberOfLiquidLiquidExtractions -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is greater than 970 microliters, then LiquidLiquidExtractionMixVolume will automatically be set to 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        OrganicSolventVolume -> 1.75 * Milliliter,
        NumberOfLiquidLiquidExtractions -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionCentrifuge Tests -- *)
    Example[{Options, LiquidLiquidExtractionCentrifuge, "If any centrifuging options (LiquidLiquidExtractionCentrifugeInstrument, LiquidLiquidExtractionCentrifugeTime, and LiquidLiquidExtractionCentrifugeIntensity) are specified, then LiquidLiquidExtractionCentrifuge will automatically be set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionCentrifugeTime -> 1 * Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifuge -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionCentrifuge, "If LiquidLiquidExtractionTechnique is set to Pipette and the sample is in a centrifuge-compatible container, then LiquidLiquidExtractionCentrifuge will automatically be set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifuge -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidLiquidExtractionCentrifuge, "If no centrifuging options (LiquidLiquidExtractionCentrifugeInstrument, LiquidLiquidExtractionCentrifugeTime, and LiquidLiquidExtractionCentrifugeIntensity) are set, LiquidLiquidExtractionTechnique is set to PhaseSeparator, or the sample is not in a centrifuge-compatible container, then LiquidLiquidExtractionCentrifuge will automatically be set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifuge -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionCentrifugeInstrument Tests -- *)
    Example[{Options, {LiquidLiquidExtractionCentrifugeInstrument, LiquidLiquidExtractionCentrifugeTime}, "If LiquidLiquidExtractionCentrifuge is set to True, then LiquidLiquidExtractionCentrifugeInstrument will be set to the integrated centrifuge model on the chosen robotic instrument and LiquidLiquidExtractionCentrifugeTime is automatically set to 2 minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        RoboticInstrument -> Object[Instrument, LiquidHandler, "id:WNa4ZjRr56bE"],
        LiquidLiquidExtractionCentrifuge -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
            LiquidLiquidExtractionCentrifugeTime -> EqualP[2 * Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- LiquidLiquidExtractionCentrifugeIntensity Tests -- *)
    Example[{Options, LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is less than the MaxCentrifugationForce of the plate model (or the MaxCentrifugationForce of the plate model does not exist), the liquid-liquid extraction solution will be centrifuged at the MaxIntensity of the centrifuge model:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    (* NOTE: Only 4 containers currently have a MaxCentrifugationForce and are not compatible with the HiG4, so the below is not currently a realistic case currently. Also, LLE resolves this based on the container it enters LLE and not the LLE container which needs to be fixed. *)
    (*Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is greater than the MaxCentrifugationForce of the plate model, the liquid-liquid extraction solution will be centrifuged at the MaxCentrifugationForce of the plate model:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) "<>$SessionUUID],
        LiquidLiquidExtractionContainer -> Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"],
        LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument,Centrifuge,"HiG4"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
        {
          LiquidLiquidExtractionCentrifugeIntensity -> EqualP[2851.5 RPM]
        }
      ],
      TimeConstraint -> 600
    ],}*)

    (* -- LiquidBoundaryVolume Tests -- *)
    Example[{Options, LiquidBoundaryVolume, "If LiquidLiquidExtractionTechnique is set to Pipette and LiquidLiquidExtractionTransferLayer is set to Top for the first extraction round, then LiquidBoundaryVolume will be set to a 5 millimeter tall cross-section of the sample container at the location of the layer boundary for each extraction round:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        NumberOfLiquidLiquidExtractions -> 1,
        LiquidLiquidExtractionTransferLayer -> {Top},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidBoundaryVolume -> {EqualP[0.02 Milliliter]}
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, LiquidBoundaryVolume, "If LiquidLiquidExtractionTechnique is set to Pipette and LiquidLiquidExtractionTransferLayer is set to Bottom for the first extraction round, then LiquidBoundaryVolume will be set to a 5 millimeter tall cross-section of the bottom of the sample container for each extraction round:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        NumberOfLiquidLiquidExtractions -> 1,
        LiquidLiquidExtractionTransferLayer -> {Bottom},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidBoundaryVolume -> {EqualP[0.02 Milliliter]}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- ImpurityLayerContainerOut Tests -- *)
    Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is set to Aqueous and LiquidLiquidExtractionTechnique is set to PhaseSeparator, ImpurityLayerContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) "<>$SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ImpurityLayerContainerOut -> ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]] (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is not set to Aqueous or LiquidLiquidExtractionTechnique is not set to PhaseSeparator, ImpurityLayerContainerOut is automatically determined by the PreferredContainer function:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ImpurityLayerContainerOut -> ObjectP[Model[Container]]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* - Liquid-Liquid Extraction Errors - *)

    Example[{Messages, "LiquidLiquidExtractionOptionMismatch", "An error is returned if any liquid-liquid extraction options are set, but LiquidLiquidExtraction is not specified in Purification:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        LiquidLiquidExtractionSettlingTime -> 1 * Minute,
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::LiquidLiquidExtractionConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],
    Example[{Messages, "LiquidLiquidExtractionSelectionStrategyOptionsMismatched", "A warning is returned if a selection strategy (LiquidLiquidExtractionSelectionStrategy) is specified, but there is only one liquid-liquid extraction round specified (NumberOfLiquidLiquidExtractions) since a selection strategy is only required for multiple rounds of liquid-liquid extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        NumberOfLiquidLiquidExtractions -> 1,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::LiquidLiquidExtractionSelectionStrategyNotNeeded
      },
      TimeConstraint -> 600
    ],
    Example[{Messages, "AqueousSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified aqueous solvent options (AqueousSolvent, AqueousSolventVolume, AqueousSolventRatio) for a sample:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        AqueousSolventVolume -> 0.2 * Milliliter,
        AqueousSolventRatio -> Null,
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::AqueousSolventOptionsMismatched,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],
    Example[{Messages, "OrganicSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified organic solvent options (OrganicSolvent, OrganicSolventVolume, OrganicSolventRatio) for a sample:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        OrganicSolventVolume -> 0.2 * Milliliter,
        OrganicSolventRatio -> Null,
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::OrganicSolventOptionsMismatched,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],
    Example[{Messages, "DemulsifierOptionsMismatched", "An error is returned if there is a mix of specified and unspecified demulsifier options (Demulsifier, DemulsifierAmount, DemulsifierAdditions):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Demulsifier -> None,
        DemulsifierAmount -> 0.1 * Milliliter,
        Output -> Result
      ],
      $Failed,
      Messages :> {
        Error::DemulsifierOptionsMismatched,
        Error::InvalidOption
      },
      TimeConstraint -> 600
    ],


    (* - SHARED PRECIPITATION TESTS - *)

    (* -- Basic Tests -- *)
    Example[{Basic, "Crude samples can be purified with precipitation:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],

    (* -- PrecipitationTargetPhase Tests -- *)
    Example[{Options, {PrecipitationTargetPhase, PrecipitationSeparationTechnique, PrecipitationReagentTemperature, PrecipitationReagentEquilibrationTime}, "If Precipitation is included in Purification, PrecipitationTargetPhase is automatically set to Solid, PrecipitationSeparationTechnique is set to Pellet, PrecipitationReagentTemperature is automatically set to Ambient, PrecipitationReagentEquilibrationTime is automatically set to 5 minutes, and PrecipitationTime is set to 15 Minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationTargetPhase -> Solid,
            PrecipitationSeparationTechnique -> Pellet,
            PrecipitationReagentTemperature -> Ambient,
            PrecipitationReagentEquilibrationTime -> EqualP[5 Minute],
            PrecipitationTime -> EqualP[15 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationReagent, PrecipitationNumberOfWashes, UnprecipitatedSampleStorageCondition, UnprecipitatedSampleLabel, and UnprecipitatedSampleContainerLabel Tests -- *)
    Example[{Options, {PrecipitationReagent, PrecipitationNumberOfWashes, UnprecipitatedSampleStorageCondition, UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel}, "If PrecipitationTargetPhase is set to Liquid, PrecipitationReagent is automatically set to Model[Sample, StockSolution, \"5M Sodium Chloride\"], PrecipitationNumberOfWashes is automatically set to 0, UnprecipitatedSampleStorageCondition is set to the StorageCondition of the Sample, UnprecipitatedSampleLabel is automatically generated, and UnprecipitatedSampleContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Liquid,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationReagent -> Model[Sample, StockSolution, "id:AEqRl954GJb6"], (*Model[Sample, StockSolution, "5M Sodium Chloride"]*)
            PrecipitationNumberOfWashes -> 0,
            UnprecipitatedSampleStorageCondition -> ObjectP[Model[StorageCondition, "id:N80DNj1r04jW"]], (*Model[StorageCondition, "Refrigerator"]*)
            UnprecipitatedSampleLabel -> _String,
            UnprecipitatedSampleContainerLabel -> _String
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationReagent, PrecipitationNumberOfWashes, PrecipitationDryingTemperature, PrecipitationDryingTime, PrecipitationResuspensionBuffer, PrecipitatedSampleStorageCondition, PrecipitatedSampleLabel, and PrecipitatedSampleContainerLabel Tests -- *)
    Example[{Options, {PrecipitationReagent, PrecipitationNumberOfWashes, PrecipitationDryingTemperature, PrecipitationDryingTime, PrecipitationResuspensionBuffer, PrecipitatedSampleStorageCondition, PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel}, "If PrecipitationTargetPhase is set to Solid, PrecipitationReagent is automatically set to Model[Sample,\"Isopropanol\"], PrecipitationNumberOfWashes is automatically set to 3, PrecipitationDryingTemperature is automatically set to Ambient, PrecipitationDryingTime is automatically set to 20 Minutes, PrecipitationResuspensionBuffer is automatically set to Model[Sample, StockSolution, \"1x TE Buffer\"], PrecipitatedSampleStorageCondition is set to the StorageCondition of the Sample, PrecipitatedSampleLabel is automatically generated, and PrecipitatedSampleContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Solid,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationReagent -> Model[Sample, "id:jLq9jXY4k6da"], (*Model[Sample, "Isopropanol"]*)
            PrecipitationNumberOfWashes -> 3,
            PrecipitationDryingTemperature -> Ambient,
            PrecipitationDryingTime -> 20 Minute,
            PrecipitationResuspensionBuffer -> Model[Sample, StockSolution, "id:n0k9mGzRaJe6"], (*Model[Sample, StockSolution, "1x TE Buffer"]*)
            PrecipitatedSampleStorageCondition -> ObjectP[Model[StorageCondition, "id:N80DNj1r04jW"]], (*Model[StorageCondition, "Refrigerator"]*)
            PrecipitatedSampleLabel -> _String,
            PrecipitatedSampleContainerLabel -> _String
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationReagentVolume Tests -- *)
    Example[{Options, PrecipitationReagentVolume, "If 50% of the sample volume is less than 80% of the sample container MaxVolume, then PrecipitationReagentVolume is set 50% of the sample volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationReagentVolume -> EqualP[0.1 Milliliter]}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationReagentVolume, "If 50% of the sample volume is greater than 80% of the sample container MaxVolume minus the sample volume, then PrecipitationReagentVolume is set 80% of the sample container MaxVolume minus the sample volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "High Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationReagentVolume -> EqualP[0.4 Milliliter]}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationMixType Tests -- *)
    Example[{Options, PrecipitationMixType, "If PrecipitationMixVolume or NumberOfPrecipitationMixes are specified, then PrecipitationMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationMixVolume -> 100 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationMixType -> Pipette}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationMixType, "If neither PrecipitationMixVolume nor NumberOfPrecipitationMixes are specified, then PrecipitationMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationMixType -> Shake}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationMixType Tests -- *)
    Example[{Options, {PrecipitationMixInstrument, PrecipitationMixRate, PrecipitationMixTemperature, PrecipitationMixTime}, "If PrecipitationMixType is set to Shake, PrecipitationMixInstrument is automatically set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"], PrecipitationMixRate is automatically set to 300 RPM, PrecipitationMixTemperature is automatically set to Ambient, and PrecipitationMixTime is automatically set to 15 minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
            PrecipitationMixRate -> 300 RPM,
            PrecipitationMixTemperature -> Ambient,
            PrecipitationMixTime -> 15 Minute
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfPrecipitationMixes Tests -- *)
    Example[{Options, NumberOfPrecipitationMixes, "If PrecipitationMixType is set to Pipette, then NumberOfPrecipitationMixes is automatically set to 10 :"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{NumberOfPrecipitationMixes -> 10}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationMixVolume Tests -- *)
    Example[{Options, PrecipitationMixVolume, "If PrecipitationMixType is set to Pipette and 50% of the total volume (sample volume plus the PrecipitationReagentVolume) is less than the maximum robotic transfer volume, then PrecipitationMixVolume is set to 50% of the total volume (sample volume plus the PrecipitationReagentVolume):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationMixType -> Pipette,
        PrecipitationReagentVolume -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationMixVolume -> EqualP[150 Microliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationMixVolume, "If PrecipitationMixType is set to Pipette and 50% of the total volume (sample volume plus the PrecipitationReagentVolume) is greater than the maximum robotic transfer volume, then PrecipitationMixVolume is set to the maximum robotic transfer volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 10mL Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationMixType -> Pipette,
        PrecipitationReagentVolume -> 1.8 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationMixVolume -> EqualP[970 Microliter]}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationInstrument Tests -- *)
    Example[{Options, PrecipitationInstrument, "If PrecipitationTemperature is set to greater than 70 Celsius, PrecipitationInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTemperature -> 80 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationInstrument -> Model[Instrument, Shaker, "id:eGakldJkWVnz"]}] (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationInstrument, "If PrecipitationTemperature is less than 70 Celsius, PrecipitationInstrument is automatically set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTemperature -> 50 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"]}] (*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationTemperature Tests -- *)
    Example[{Options, PrecipitationTemperature, "If PrecipitationTime is set to greater than 0 Minutes, then PrecipitationTemperature automatically is set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTime -> 1 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationTemperature -> Ambient}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationFiltrationInstrument Tests -- *)
    Example[{Options, PrecipitationFiltrationInstrument, "If PrecipitationSeparationTechnique is set to Filter and PrecipitationFiltrationTechnique is set to Centrifuge, PrecipitationFiltrationInstrument is automatically set to Model[Instrument, Centrifuge, \"HiG4\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationFiltrationTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationFiltrationInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}] (*Model[Instrument, Centrifuge, "HiG4"]*)
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationFiltrationInstrument, "If PrecipitationSeparationTechnique is set to Filter and PrecipitationFiltrationTechnique is set to AirPressure, PrecipitationFiltrationInstrument is automatically set to Model[Instrument, Centrifuge, \"MPE2 Sterile\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationFiltrationTechnique -> AirPressure,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationFiltrationInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]]}] (*Model[Instrument, PressureManifold, "MPE2"*)
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationFiltrationTechnique Tests -- *)
    Example[{Options, {PrecipitationFiltrationTechnique, PrecipitationFiltrationTime}, "If PrecipitationSeparationTechnique is set to Filter, then PrecipitationFiltrationTechnique is automatically set to AirPressure and PrecipitationFiltrationTime is set to 10 Minutes:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationFiltrationTechnique -> AirPressure,
            PrecipitationFiltrationTime -> EqualP[10 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationFilter Tests -- *)
    Example[{Options, {PrecipitationFilter, PrecipitationFilterPosition}, "If SeparationTechnique is set to Filter and the sample is already in a filter, PrecipitationFilter will automatically be set to the filter that the sample is in and PrecipitationFilterPosition is set to the current position of the sample in the filter unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in Filter Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationFilter -> ObjectP[Object[Container, Plate, Filter, "Test Plate 14 for ExperimentExtractPlasmidDNA " <> $SessionUUID]],
            PrecipitationFilterPosition -> "B3"
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, {PrecipitationFilter, PrecipitationFilterPosition}, "If SeparationTechnique is set to Filter and the sample is not already in a filter, PrecipitationFilter will automatically be determined based on the SeparationTechnique and PrecipitationFiltrationInstrument and PrecipitationFilterPosition will be set to the first empty position in the PrecipitationFilter unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationFilter -> ObjectP[Model[Container, Plate, Filter]],
            PrecipitationFilterPosition -> "A1"
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationPoreSize and PrecipitationMembraneMaterial Tests -- *)
    Example[{Options, {PrecipitationPoreSize, PrecipitationMembraneMaterial}, "If PrecipitationSeparationTechnique is set to Filter and a PrecipitationFilter is specified,PrecipitationPoreSize is automatically set to the pore size of the specified filter and PrecipitationMembraneMaterial is automatically set to the membrane material of the specified filter:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationFilter -> Model[Container, Plate, Filter, "id:kEJ9mqRPx6M3"], (* Model[Container, Plate, Filter, "Oasis PRiME HLB 96-well Filter Plate"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationPoreSize -> EqualP[0.008 Micrometer],
            PrecipitationMembraneMaterial -> HLB
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationPoreSize Tests -- *)
    Example[{Options, PrecipitationPoreSize, "If PrecipitationSeparationTechnique is set to Filter, a PrecipitationFilter is not specified and a PrecipitationMembraneMaterial is specified, then PrecipitationPoreSize is automatically set 0.22 micron:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationMembraneMaterial -> PES,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationPoreSize -> 0.22 Micrometer
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationMembraneMaterial Tests -- *)
    Example[{Options, PrecipitationMembraneMaterial, "If PrecipitationSeparationTechnique is set to Filter, a PrecipitationFilter is not specified, and a PrecipitationPoreSize is set, then PrecipitationMembraneMaterial is automatically set to PES:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationPoreSize -> 0.22 Micrometer,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationMembraneMaterial -> PES
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationFilterCentrifugeIntensity Tests -- *)
    Example[{Options, PrecipitationFilterCentrifugeIntensity, "If PrecipitationFiltrationTechnique is set to Centrifuge, PrecipitationFilterCentrifugeIntensity is automatically set to 3600 G:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationFiltrationTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationFilterCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationFiltrationPressure Tests -- *)
    Example[{Options, PrecipitationFiltrationPressure, "If PrecipitationFiltrationTechnique is set to AirPressure, PrecipitationFiltrationPressure is automatically set to 40 PSI:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationFiltrationTechnique -> AirPressure,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationFiltrationPressure -> EqualP[40 PSI]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationFiltrateVolume Tests -- *)
    Example[{Options, PrecipitationFiltrateVolume, "If PrecipitationSeparationTechnique is set to Filter, PrecipitationFiltrateVolume is set to the sample volume plus PrecipitationReagentVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationReagentVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationFiltrateVolume -> EqualP[0.4 Milliliter]}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationFilterStorageCondition Tests -- *)
    Example[{Options, PrecipitationFilterStorageCondition, "If PrecipitationTargetPhase is set to Solid, PrecipitationSeparationTechnique is set to Filter, and ResuspensionBuffer is not set to None, then PrecipitationFilterStorageCondition is automatically set to the StorageCondition of the sample:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Solid,
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationResuspensionBuffer -> Model[Sample, StockSolution, "id:n0k9mGzRaJe6"], (* Model[Sample, StockSolution, "1x TE Buffer"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationFilterStorageCondition -> ObjectP[Model[StorageCondition, "id:N80DNj1r04jW"]]}] (*Model[StorageCondition, "Refrigerator"]*)
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationFilterStorageCondition, "If PrecipitationSeparationTechnique is set to Filter and PrecipitationTargetPhase is set to Liquid, then FilterStorageCondition is automatically set to Disposal:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Liquid,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationFilterStorageCondition -> Disposal}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationPelletVolume, PrecipitationPelletCentrifuge, PrecipitationPelletCentrifugeIntensity, and PrecipitationPelletCentrifugeTime Tests -- *)
    Example[{Options, {PrecipitationPelletVolume, PrecipitationPelletCentrifuge, PrecipitationPelletCentrifugeIntensity, PrecipitationPelletCentrifugeTime}, "If PrecipitationSeparationTechnique is set to Pellet, PrecipitationPelletVolume is automatically set to 1 MicroLiter, PrecipitationPelletCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"], PrecipitationPelletCentrifugeIntensity is automatically set to 3600 Gravitational Acceleration, and PrecipitationPelletCentrifugeTime is automatically set to 10 minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Pellet,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationPelletVolume -> EqualP[1 Microliter],
            PrecipitationPelletCentrifuge -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
            PrecipitationPelletCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration],
            PrecipitationPelletCentrifugeTime -> 10 Minute
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationSupernatantVolume Tests -- *)
    Example[{Options, PrecipitationSupernatantVolume, "If PrecipitationSeparationTechnique is set to Pellet, PrecipitationSupernatantVolume is automatically set to 90% of the sample volume plus PrecipitationReagentVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Pellet,
        PrecipitationReagentVolume -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationSupernatantVolume -> 0.27 Milliliter}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashSolution, PrecipitationWashSolutionVolume, PrecipitationWashSolutionTemperature, and PrecipitationWashSolutionEquilibrationTime Tests -- *)
    Example[{Options, {PrecipitationWashSolution, PrecipitationWashSolutionVolume, PrecipitationWashSolutionTemperature, PrecipitationWashSolutionEquilibrationTime}, "If PrecipitationNumberOfWashes is greater than 0, PrecipitationWashSolution is set to Model[Sample, StockSolution, \"70% Ethanol\"], PrecipitationWashSolutionVolume is set to the volume of the sample, PrecipitationWashSolutionTemperature is set to Ambient, and PrecipitationWashSolutionEquilibrationTime is set to 10 minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationNumberOfWashes -> 3,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationWashSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"], (* Model[Sample, StockSolution, "70% Ethanol"] *)
            PrecipitationWashSolutionVolume -> EqualP[0.2 Milliliter],
            PrecipitationWashSolutionTemperature -> Ambient,
            PrecipitationWashSolutionEquilibrationTime -> 10 Minute
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashMixType Tests -- *)
    Example[{Options, PrecipitationWashMixType, "If PrecipitationTargetPhase is set to Solid and PrecipitationSeparationTechnique is set to Filter or any pipetting options are set (PrecipitationWashMixVolume and PrecipitationNumberOfWashMixes), then PrecipitationWashMixType is automatically set to Pipette if PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Solid,
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationNumberOfWashes -> 3,
        PrecipitationWashMixVolume -> 100 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixType -> Pipette}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationWashMixType, "If PrecipitationTargetPhase is set to Solid and pipetting options are not set (PrecipitationWashMixVolume and PrecipitationNumberOfWashMixes), then PrecipitationWashMixType is automatically set to Shake if PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 3,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixType -> Shake}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashMixInstrument Tests -- *)
    Example[{Options, PrecipitationWashMixInstrument, "If PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is below 70 Celsius, PrecipitationWashMixInstrument is automatically set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashMixType -> Shake,
        PrecipitationWashMixTemperature -> 65 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]]}] (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationWashMixInstrument, "If PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is above 70 Celsius, PrecipitationWashMixInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashMixType -> Shake,
        PrecipitationWashMixTemperature -> 72 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]}] (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashMixRate, PrecipitationWashMixTemperature, and PrecipitationWashMixTime Tests -- *)
    Example[{Options, {PrecipitationWashMixRate, PrecipitationWashMixTemperature, PrecipitationWashMixTime}, "If PrecipitationWashMixType is set to Shake, PrecipitationWashMixRate is set to 300 RPM, PrecipitationWashMixTemperature is set to Ambient, and PrecipitationWashMixTime is set to 15 Minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationWashMixRate -> 300 RPM,
            PrecipitationWashMixTemperature -> Ambient,
            PrecipitationWashMixTime -> 15 Minute
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationNumberOfWashMixes Tests -- *)
    Example[{Options, PrecipitationNumberOfWashMixes, "If PrecipitationWashMixType is set to Pipette, PrecipitationNumberOfWashMixes is set to 10:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationNumberOfWashMixes -> 10}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashMixVolume Tests -- *)
    Example[{Options, PrecipitationWashMixVolume, "If PrecipitationWashMixType is set to Pipette and 50% of PrecipitationWashSolutionVolume is less than the maximum robotic transfer volume, then PrecipitationWashMixVolume is set to 50% of PrecipitationWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashMixType -> Pipette,
        PrecipitationWashSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixVolume -> EqualP[100 Microliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationWashMixVolume, "If PrecipitationWashMixType is set to Pipette and 50% of PrecipitationWashSolutionVolume is greater than the maximum robotic transfer volume, then PrecipitationWashMixVolume is set to the maximum robotic transfer volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 10mL Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashMixType -> Pipette,
        PrecipitationWashSolutionVolume -> 2.0 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixVolume -> EqualP[970 Microliter]}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashMixVolume Tests -- *)
    Example[{Options, PrecipitationWashPrecipitationTime, "If the PrecipitationWashSolutionTemperature is greater than the PrecipitationReagentTemperature, PrecipitationWashPrecipitationTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashSolutionTemperature -> 40 Celsius,
        PrecipitationReagentTemperature -> Ambient,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashPrecipitationTime -> 1 Minute}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashPrecipitationInstrument Tests -- *)
    Example[{Options, PrecipitationWashPrecipitationInstrument, "If PrecipitationWashPrecipitationTemperature is set to greater than 70 Celsius and PrecipitationWashPrecipitationTime is greater than 0 Minute, PrecipitationWashPrecipitationInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashPrecipitationTemperature -> 80 Celsius,
        PrecipitationWashPrecipitationTime -> 15 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Model[Instrument, Shaker, "id:eGakldJkWVnz"]}] (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationWashPrecipitationInstrument, "If PrecipitationWashPrecipitationTemperature is less than 70 Celsius and PrecipitationWashPrecipitationTime is greater than 0 Minute, PrecipitationWashPrecipitationInstrument is automatically set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashPrecipitationTemperature -> 50 Celsius,
        PrecipitationWashPrecipitationTime -> 15 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"]}] (*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashPrecipitationTemperature Tests -- *)
    Example[{Options, PrecipitationWashPrecipitationTemperature, "If PrecipitationWashPrecipitationTime is greater than 0, PrecipitationWashPrecipitationTemperature is set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashPrecipitationTime -> 10 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashPrecipitationTemperature -> Ambient}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashCentrifugeIntensity Tests -- *)
    Example[{Options, PrecipitationWashCentrifugeIntensity, "If PrecipitationSeparationTechnique is set to Pellet, PrecipitationWashCentrifugeIntensity is set to 3600 GravitationalAcceleration:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Pellet,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashPressure Tests -- *)
    Example[{Options, {PrecipitationWashPressure, PrecipitationWashSeparationTime}, "If PrecipitationFiltrationTechnique is set to AirPressure and PrecipitationNumberOfWashes is greater than 0, PrecipitationWashPressure is automatically set to 40 PSI and PrecipitationWashSeparationTime is set to 3 Minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationFiltrationTechnique -> AirPressure,
        PrecipitationNumberOfWashes -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationWashPressure -> 40 PSI,
            PrecipitationWashSeparationTime -> 3 Minute
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationWashSeparationTime Tests -- *)
    Example[{Options, PrecipitationWashSeparationTime, "If PrecipitationFiltrationTechnique is set to Centrifuge and PrecipitationNumberOfWashes is greater than 0, PrecipitationWashSeparationTime is automatically set to 20 Minutes:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationFiltrationTechnique -> Centrifuge,
        PrecipitationNumberOfWashes -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashSeparationTime -> 20 Minute}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationResuspensionBufferVolume Tests -- *)
    Example[{Options, PrecipitationResuspensionBufferVolume, "If the 25% of the initial sample volume is greater than 10 microliters, then  then PrecipitationResuspensionBufferVolume will be set to 25% of the initial sample volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionBuffer -> Model[Sample, StockSolution, "id:n0k9mGzRaJe6"], (* Model[Sample, StockSolution, "1x TE Buffer"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionBufferVolume -> EqualP[0.05 Milliliter]}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationResuspensionBufferVolume, "If the 25% of the initial sample volume is less than 10 microliters, then PrecipitationResuspensionBufferVolume will be set to 10 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Low Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionBuffer -> Model[Sample, StockSolution, "id:n0k9mGzRaJe6"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionBufferVolume -> EqualP[10 Microliter]}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationResuspensionBufferTemperature and PrecipitationResuspensionBufferEquilibrationTime Tests -- *)
    Example[{Options, {PrecipitationResuspensionBufferTemperature, PrecipitationResuspensionBufferEquilibrationTime}, "If a PrecipitationResuspensionBuffer is specified, PrecipitationResuspensionBufferTemperature is automatically set to Ambient and PrecipitationResuspensionBufferEquilibrationTime is automatically set to 10 minutes:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionBuffer -> Model[Sample, StockSolution, "id:n0k9mGzRaJe6"], (*Model[Sample, StockSolution, "1x TE Buffer"]*)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationResuspensionBufferTemperature -> Ambient,
            PrecipitationResuspensionBufferEquilibrationTime -> 10 Minute
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationResuspensionMixType Tests -- *)
    Example[{Options, PrecipitationResuspensionMixType, "If any resuspension pipetting options are set (PrecipitationResuspensionMixVolume and PrecipitationNumberOfResuspensionMixes), then PrecipitationResuspensionMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionMixVolume -> 10 Microliter,
        PrecipitationNumberOfResuspensionMixes -> 10,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationResuspensionMixType, "If a PrecipitationResuspensionBuffer is set and PrecipitationSeparationTechnique is set to Filter, PrecipitationResuspensionMixType is set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationResuspensionMixType, "If a PrecipitationResuspensionBuffer is specified, neither PrecipitationResuspensionMixVolume or PrecipitationNumberOfResuspensionMixes are set, and PrecipitationSeparationTechnique is not set to Filter, PrecipitationResuspensionMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionBuffer -> Model[Sample, StockSolution, "id:n0k9mGzRaJe6"], (*Model[Sample, StockSolution, "1x TE Buffer"]*)
        PrecipitationSeparationTechnique -> Pellet,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixType -> Shake}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationResuspensionMixInstrument Tests -- *)
    Example[{Options, PrecipitationResuspensionMixInstrument, "If PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is below 70 Celsius, PrecipitationResuspensionMixInstrument is automatically set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionMixType -> Shake,
        PrecipitationResuspensionMixTemperature -> 65 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]]}] (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationResuspensionMixInstrument, "If PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is above 70 Celsius, PrecipitationResuspensionMixInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionMixType -> Shake,
        PrecipitationResuspensionMixTemperature -> 72 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]}] (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationResuspensionMixRate, PrecipitationResuspensionMixTemperature, and PrecipitationResuspensionMixTime Tests -- *)
    Example[{Options, {PrecipitationResuspensionMixRate, PrecipitationResuspensionMixTemperature, PrecipitationResuspensionMixTime}, "If PrecipitationResuspensionMixType is set to Shake, PrecipitationResuspensionMixRate is automatically set to 300 RPM, PrecipitationResuspensionMixTemperature is automatically set to Ambient, and PrecipitationResuspensionMixTime is automatically set to 15 minutes unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationResuspensionMixRate -> 300 RPM,
            PrecipitationResuspensionMixTemperature -> Ambient,
            PrecipitationResuspensionMixTime -> 15 Minute
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationNumberOfResuspensionMixes Tests -- *)
    Example[{Options, PrecipitationNumberOfResuspensionMixes, "If PrecipitationResuspensionMixType is set to Pipette, PrecipitationNumberOfResuspensionMixes is automatically set to 10:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationNumberOfResuspensionMixes -> 10}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitationResuspensionMixVolume Tests -- *)
    Example[{Options, PrecipitationResuspensionMixVolume, "If 50% of the PrecipitationResuspensionBufferVolume is less than the maximum robotic transfer volume, then PrecipitationResuspensionMixVolume is set to 50% of the PrecipitationResuspensionBufferVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionMixType -> Pipette,
        PrecipitationResuspensionBufferVolume -> 0.05 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixVolume -> EqualP[0.025 Milliliter]
        }]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, PrecipitationResuspensionMixVolume, "If 50% of the PrecipitationResuspensionBufferVolume is greater than the maximum robotic transfer volume, then PrecipitationResuspensionMixVolume is set to the maximum robotic transfer volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 10mL Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationResuspensionMixType -> Pipette,
        PrecipitationResuspensionBufferVolume -> 2.0 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixVolume -> EqualP[0.970 Milliliter]}]
      },
      TimeConstraint -> 600
    ],

    (* -- PrecipitatedSampleContainerOut Tests -- *)
    Example[{Options, PrecipitatedSampleContainerOut, "If a PrecipitationResuspensionBuffer is specified, PrecipitationTargetPhase is set to Solid, and PrecipitationSeparationTechnique is set to Filter, then PrecipitatedSampleContainerOut is automatically set by the PreferredContainer function based on the sample volume and the PrecipitationResuspensionBufferVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        PrecipitationResuspensionBuffer -> Model[Sample, StockSolution, "id:n0k9mGzRaJe6"], (*Model[Sample, StockSolution, "1x TE Buffer"]*)
        PrecipitationTargetPhase -> Solid,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitatedSampleContainerOut -> {_String, {_Integer, ObjectP[Model[Container]]}}}]
      },
      TimeConstraint -> 600
    ],

    (* -- UnprecipitatedSampleContainerOut Tests -- *)
    Example[{Options, UnprecipitatedSampleContainerOut, "If PrecipitationTargetPhase is set to Liquid, then UnprecipitatedSampleContainerOut is automatically set to a container selected by PreferredContainer[...] based on having sufficient capacity to not overflow when the separated liquid phase is added."},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Liquid,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{UnprecipitatedSampleContainerOut -> {_String, {_Integer, ObjectP[Model[Container]]}}}]
      },
      TimeConstraint -> 600
    ],


    (* - SHARED SPE TESTS - *)

    (* -- Basic Tests -- *)

    Example[{Basic, "Crude samples can be purified with solid phase extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionStrategy, SolidPhaseExtractionTechnique, SolidPhaseExtractionCartridgeStorageCondition, SolidPhaseExtractionLoadingTemperature, SolidPhaseExtractionLoadingTime, SolidPhaseExtractionWashSolution, SolidPhaseExtractionWashTemperature, SolidPhaseExtractionWashTime, CollectSolidPhaseExtractionWashFlowthrough, SecondarySolidPhaseExtractionWashSolution, SecondarySolidPhaseExtractionWashTemperature, SecondarySolidPhaseExtractionWashTime, CollectSecondarySolidPhaseExtractionWashFlowthrough, TertiarySolidPhaseExtractionWashSolution, TertiarySolidPhaseExtractionWashTemperature, TertiarySolidPhaseExtractionWashTime, CollectTertiarySolidPhaseExtractionWashFlowthrough, and SolidPhaseExtractionElutionSolution Tests -- *)
    (* NOTE: Non-ambient temperatures not currently supported for SPE, so removed for now. *)
    (* TODO::Finalize wash and elution solution default names to NucleoSpin defaults once they are ordered. *)
    Example[{Options, {SolidPhaseExtractionStrategy, SolidPhaseExtractionTechnique, SolidPhaseExtractionCartridgeStorageCondition, SolidPhaseExtractionLoadingTime, SolidPhaseExtractionWashSolution, SolidPhaseExtractionWashTime, CollectSolidPhaseExtractionWashFlowthrough, SecondarySolidPhaseExtractionWashSolution, SecondarySolidPhaseExtractionWashTime, CollectSecondarySolidPhaseExtractionWashFlowthrough, TertiarySolidPhaseExtractionWashSolution, TertiarySolidPhaseExtractionWashTime, CollectTertiarySolidPhaseExtractionWashFlowthrough, SolidPhaseExtractionElutionSolution, SolidPhaseExtractionElutionTime}, "If SolidPhaseExtraction is included in Purification, then SolidPhaseExtractionStrategy is automatically set to Positive, SolidPhaseExtractionTechnique is set to Pressure, SolidPhaseExtractionCartridgeStorageCondition is automatically set to Disposal, SolidPhaseExtractionLoadingTime is set to 1 Minute, SolidPhaseExtractionCartridge is automatically set to Model[Container, Plate, Filter, \"NucleoSpin Plasmid Binding Plate\"], SolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"], SolidPhaseExtractionWashTime is automatically set to 1 Minute, CollectSolidPhaseExtractionWashFlowthrough is automatically set to False,  SecondarySolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"], SecondarySolidPhaseExtractionWashTime is automatically set to 1 Minute, CollectSecondarySolidPhaseExtractionWashFlowthrough is automatically set to False,  TertiarySolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"],  TertiarySolidPhaseExtractionWashTime is automatically set to 1 Minute, CollectTertiarySolidPhaseExtractionWashFlowthrough is automatically set to False, SolidPhaseExtractionElutionSolution is automatically set to Model[Sample, \"Macherey-Nagel Elution Buffer AE\"], SolidPhaseExtractionElutionTime is automatically set to 1 Minute unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionStrategy -> Positive,
            SolidPhaseExtractionTechnique -> Pressure,
            SolidPhaseExtractionCartridgeStorageCondition -> Disposal,
            SolidPhaseExtractionLoadingTime -> EqualP[1 Minute],
            SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:9RdZXvdnd0bX"]], (* Model[Container, Plate, Filter, "NucleoSpin Plasmid Binding Plate"] *)
            (* TODO::Put in defaults for wash solutions and elution solution once objects are finalized when ordered. For now, just water is used. *)
            SolidPhaseExtractionWashSolution -> ObjectP[Model[Sample]],
            SolidPhaseExtractionWashTime -> EqualP[1 Minute],
            CollectSolidPhaseExtractionWashFlowthrough -> False,
            SecondarySolidPhaseExtractionWashTime -> EqualP[1 Minute],
            CollectSecondarySolidPhaseExtractionWashFlowthrough -> False,
            TertiarySolidPhaseExtractionWashTime -> EqualP[1 Minute],
            CollectTertiarySolidPhaseExtractionWashFlowthrough -> False,
            SolidPhaseExtractionElutionSolution -> ObjectP[Model[Sample]],
            SolidPhaseExtractionElutionTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    (*Example[{Options, {SolidPhaseExtractionStrategy, SolidPhaseExtractionTechnique, SolidPhaseExtractionCartridgeStorageCondition, SolidPhaseExtractionLoadingTemperature, SolidPhaseExtractionLoadingTime, SolidPhaseExtractionWashSolution, SolidPhaseExtractionWashTemperature, SolidPhaseExtractionWashTime, CollectSolidPhaseExtractionWashFlowthrough, SecondarySolidPhaseExtractionWashSolution, SecondarySolidPhaseExtractionWashTemperature, SecondarySolidPhaseExtractionWashTime, CollectSecondarySolidPhaseExtractionWashFlowthrough, TertiarySolidPhaseExtractionWashSolution, TertiarySolidPhaseExtractionWashTemperature, TertiarySolidPhaseExtractionWashTime, CollectTertiarySolidPhaseExtractionWashFlowthrough, SolidPhaseExtractionElutionSolution}, "If SolidPhaseExtraction is included in Purification, then SolidPhaseExtractionStrategy is automatically set to Positive, SolidPhaseExtractionTechnique is set to Pressure, SolidPhaseExtractionCartridgeStorageCondition is automatically set to Disposal, SolidPhaseExtractionLoadingTemperature is set to Ambient, SolidPhaseExtractionLoadingTime is set to 1 Minute, SolidPhaseExtractionCartridge is automatically set to Model[Container, Plate, Filter, \"NucleoSpin Plasmid Binding Plate\"], SolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"], SolidPhaseExtractionWashTemperature is automatically set to Ambient, SolidPhaseExtractionWashTime is automatically set to 1 Minute, CollectSolidPhaseExtractionWashFlowthrough is automatically set to False,  SecondarySolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"],  SecondarySolidPhaseExtractionWashTemperature is automatically set to Ambient, SecondarySolidPhaseExtractionWashTime is automatically set to 1 Minute, CollectSecondarySolidPhaseExtractionWashFlowthrough is automatically set to False,  TertiarySolidPhaseExtractionWashSolution is automatically set to Model[Sample, \"Macherey-Nagel Wash Buffer A4\"],  TertiarySolidPhaseExtractionWashTemperature is automatically set to Ambient, TertiarySolidPhaseExtractionWashTime is automatically set to 1 Minute, CollectTertiarySolidPhaseExtractionWashFlowthrough is automatically set to False, SolidPhaseExtractionElutionSolution is automatically set to Model[Sample, \"Macherey-Nagel Elution Buffer AE\"], SolidPhaseExtractionElutionSolutionTemperature is automatically set to Ambient, SolidPhaseExtractionElutionTime is automatically set to 1 Minute unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionStrategy -> Positive,
            SolidPhaseExtractionTechnique -> Pressure,
            SolidPhaseExtractionCartridgeStorageCondition -> Disposal,
            SolidPhaseExtractionLoadingTemperature -> Ambient,
            SolidPhaseExtractionLoadingTime -> EqualP[1 Minute],
            SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:9RdZXvdnd0bX"]], (* Model[Container, Plate, Filter, "NucleoSpin Plasmid Binding Plate"] *)
            (* TODO::Put in defaults for wash solutions and elution solution once objects are finalized when ordered. For now, just water is used. *)
            SolidPhaseExtractionWashSolution -> ObjectP[Model[Sample]],
            SolidPhaseExtractionWashTemperature -> Ambient,
            SolidPhaseExtractionWashTime -> EqualP[1 Minute],
            CollectSolidPhaseExtractionWashFlowthrough -> False,
            SecondarySolidPhaseExtractionWashTemperature -> Ambient,
            SecondarySolidPhaseExtractionWashTime -> EqualP[1 Minute],
            CollectSecondarySolidPhaseExtractionWashFlowthrough -> False,
            TertiarySolidPhaseExtractionWashTemperature -> Ambient,
            TertiarySolidPhaseExtractionWashTime -> EqualP[1 Minute],
            CollectTertiarySolidPhaseExtractionWashFlowthrough -> False,
            SolidPhaseExtractionElutionSolution -> ObjectP[Model[Sample]],
            SolidPhaseExtractionElutionSolutionTemperature -> Ambient,
            SolidPhaseExtractionElutionTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],*)

    (* -- SolidPhaseExtractionSeparationMode Tests -- *)
    Example[{Options, SolidPhaseExtractionSeparationMode, "If a SolidPhaseExtractionSorbent or a SolidPhaseExtractionCartridge are specified, then SolidPhaseExtractionSeparationMode is resolved based on the SolidPhaseExtractionSorbent and the sample contents:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionSorbent -> Silica,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionSeparationMode -> (IonExchange | SizeExclusion | Affinity)}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SolidPhaseExtractionSeparationMode, "If neither a SolidPhaseExtractionSorbent nor a SolidPhaseExtractionCartridge are specified, then SolidPhaseExtractionSeparationMode is automatically set to IonExchange:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionSeparationMode -> IonExchange}]
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionSorbent Tests -- *)
    Example[{Options, SolidPhaseExtractionSorbent, "If a SolidPhaseExtractionCartridge is specified, SolidPhaseExtractionSorbent is automatically set to the sorbent of the specified cartridge:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"], (*Model[Container, Plate, Filter, QiaQuick 96well]*)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionSorbent -> Silica}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, SolidPhaseExtractionSorbent, "If a SolidPhaseExtractionCartridge is not specified, SolidPhaseExtractionSorbent is automatically set to Silica:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionSorbent -> Silica}]
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionInstrument and SolidPhaseExtractionLoadingCentrifugeIntensity Tests -- *)
    Example[{Options, {SolidPhaseExtractionInstrument, SolidPhaseExtractionLoadingCentrifugeIntensity}, "If SolidPhaseExtractionTechnique is set to Centrifuge, SolidPhaseExtractionInstrument is automatically set to Model[Instrument, Centrifuge, \"HiG4\"] and SolidPhaseExtractionLoadingCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}], (* Model[Instrument, Centrifuge, "HiG4"] *)
            SolidPhaseExtractionLoadingCentrifugeIntensity -> EqualP[5000 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionInstrument Tests -- *)
    Example[{Options, SolidPhaseExtractionInstrument, "If SolidPhaseExtractionTechnique is not set to Centrifuge, then SolidPhaseExtractionInstrument is set to Model[Instrument, PressureManifold, \"MPE2\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]}]}] (*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionLoadingSampleVolume Tests -- *)
    Example[{Options, SolidPhaseExtractionLoadingSampleVolume, "If SolidPhaseExtraction is included in Purification and the total volume of the sample is less than the MaxVolume of the SolidPhaseExtractionCartridge, then SolidPhaseExtractionLoadingSampleVolume is automatically set to the total volume of the sample:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionLoadingSampleVolume -> RangeP[Quantity[199., Microliter], Quantity[201., Microliter]]}]
      },
      TimeConstraint -> 600
    ],
    (* TODO::Doesn't actually resolve correctly in SPE (uses max robotic transfer volume for unknown reason), so needs to be fixed there or resolution description updated. *)
    (*Example[{Options, SolidPhaseExtractionLoadingSampleVolume, "If SolidPhaseExtraction is included in Purification and the total volume of the sample is greater than the MaxVolume of the SolidPhaseExtractionCartridge, then SolidPhaseExtractionLoadingSampleVolume is automatically set to the MaxVolume of the SolidPhaseExtractionCartridge:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NeutralizationReagentVolume -> 1.5 Milliliter,
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "id:9RdZXvdnd0bX"], (* Model[Container, Plate, Filter, \"NucleoSpin Plasmid Binding Plate\"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionLoadingSampleVolume -> EqualP[1.5 Milliliter]}]
      },
      TimeConstraint -> 600
    ],*)

    (* NOTE: Non-ambient temperatures not currently supported for SPE, so removed for now. *)
    (* -- SolidPhaseExtractionLoadingTemperatureEquilibrationTime Tests -- *)
    (*Example[{Options, SolidPhaseExtractionLoadingTemperatureEquilibrationTime, "If SolidPhaseExtractionLoadingTemperature is set to a temperature besides Ambient, SolidPhaseExtractionLoadingTemperatureEquilibrationTime is automatically set to 3 Minutes:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionLoadingTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> EqualP[3 Minute]}]
      },
      TimeConstraint -> 600
    ],*)

    (* -- SolidPhaseExtractionLoadingPressure Tests -- *)
    Example[{Options, SolidPhaseExtractionLoadingPressure, "If SolidPhaseExtractionTechnique is set to Pressure, then SolidPhaseExtractionLoadingPressure is automatically set to the MaxRoboticAirPressure:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionTechnique -> Pressure,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionLoadingPressure -> EqualP[$MaxRoboticAirPressure]}]
      },
      TimeConstraint -> 600
    ],

    (* -- CollectSolidPhaseExtractionLoadingFlowthrough Tests -- *)
    Example[{Options, CollectSolidPhaseExtractionLoadingFlowthrough, "If SolidPhaseExtractionStrategy is set to Negative, then CollectSolidPhaseExtractionLoadingFlowthrough is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SolidPhaseExtractionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{CollectSolidPhaseExtractionLoadingFlowthrough -> True}]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, CollectSolidPhaseExtractionLoadingFlowthrough, "If SolidPhaseExtractionStrategy is set to Positive, then CollectSolidPhaseExtractionLoadingFlowthrough is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SolidPhaseExtractionStrategy -> Positive,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{CollectSolidPhaseExtractionLoadingFlowthrough -> False}]
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionLoadingFlowthroughContainerOut Tests -- *)
    Example[{Options, SolidPhaseExtractionLoadingFlowthroughContainerOut, "If SolidPhaseExtractionLoadingFlowthrough is set to True, then SolidPhaseExtractionLoadingFlowthroughContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        CollectSolidPhaseExtractionLoadingFlowthrough -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionLoadingFlowthroughContainerOut -> ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]]}] (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionWashSolutionVolume Tests -- *)
    Example[{Options, SolidPhaseExtractionWashSolutionVolume, "If SolidPhaseExtraction is included in Purification and a SolidPhaseExtractionWashSolution is specified, then the SolidPhaseExtractionWashSolutionVolume is automatically set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"], (* Model[Container, Plate, Filter, "QiaQuick 96well"] *)
        SolidPhaseExtractionWashSolution -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionWashSolutionVolume -> EqualP[1 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* NOTE: Non-ambient temperatures not currently supported for SPE, so removed for now. *)
    (* -- SolidPhaseExtractionWashTemperatureEquilibrationTime Tests -- *)
    (*Example[{Options, SolidPhaseExtractionWashTemperatureEquilibrationTime, "If a SolidPhaseExtractionWashTemperature is set to a temperature besides Ambient, SolidPhaseExtractionWashTemperatureEquilibrationTime is automatically set to 3 Minutes:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionWashTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionWashTemperatureEquilibrationTime -> EqualP[3 Minute]}]
      },
      TimeConstraint -> 600
    ],*)

    (* -- SolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashCentrifugeIntensity, and TertiarySolidPhaseExtractionWashCentrifugeIntensity Tests -- *)
    Example[{Options, {SolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashCentrifugeIntensity, TertiarySolidPhaseExtractionWashCentrifugeIntensity}, "If SolidPhaseExtractionInstrument is set to a centrifuge, then SolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashCentrifugeIntensity, and TertiarySolidPhaseExtractionWashCentrifugeIntensity are automatically set to the MaxIntensity of the Centrifuge model:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionWashCentrifugeIntensity -> EqualP[5000 RPM],
            SecondarySolidPhaseExtractionWashCentrifugeIntensity -> EqualP[5000 RPM],
            TertiarySolidPhaseExtractionWashCentrifugeIntensity -> EqualP[5000 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashPressure, and TertiarySolidPhaseExtractionWashPressure Tests -- *)
    Example[{Options, {SolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashPressure}, "If SolidPhaseExtractionInstrument is set to a pressure manifold, then SolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashPressure, and TertiarySolidPhaseExtractionWashPressure are automatically set to the MaxRoboticAirPressure:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"], (*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionWashPressure -> EqualP[$MaxRoboticAirPressure],
            SecondarySolidPhaseExtractionWashPressure -> EqualP[$MaxRoboticAirPressure],
            TertiarySolidPhaseExtractionWashPressure -> EqualP[$MaxRoboticAirPressure]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionWashFlowthroughContainerOut Tests -- *)
    Example[{Options, SolidPhaseExtractionWashFlowthroughContainerOut, "If CollectSolidPhaseExtractionWashFlowthrough is set to True, then SolidPhaseExtractionWashFlowthroughContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        CollectSolidPhaseExtractionWashFlowthrough -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionWashFlowthroughContainerOut -> ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]]}] (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
        },
      TimeConstraint -> 600
    ],

    (* -- SecondarySolidPhaseExtractionWashSolution and TertiarySolidPhaseExtractionWashSolution Tests -- *)
    Example[{Options, {SecondarySolidPhaseExtractionWashSolution, TertiarySolidPhaseExtractionWashSolution}, "If a SolidPhaseExtractionWashSolution is specified, then SecondarySolidPhaseExtractionWashSolution and TertiarySolidPhaseExtractionWashSolution are set to the same solution as SolidPhaseExtractionWashSolution:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionWashSolution -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SecondarySolidPhaseExtractionWashSolution -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]], (* Model[Sample, "Milli-Q water"] *)
            TertiarySolidPhaseExtractionWashSolution -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]] (* Model[Sample, "Milli-Q water"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- SecondarySolidPhaseExtractionWashSolutionVolume Tests -- *)
    Example[{Options, SecondarySolidPhaseExtractionWashSolutionVolume, "If SolidPhaseExtraction is included in Purification and a SecondarySolidPhaseExtractionWashSolution is specified, then the SecondarySolidPhaseExtractionWashSolutionVolume is automatically set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"], (* Model[Container, Plate, Filter, "QiaQuick 96well"] *)
        SecondarySolidPhaseExtractionWashSolution -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SecondarySolidPhaseExtractionWashSolutionVolume -> EqualP[1 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* NOTE: Non-ambient temperatures not currently supported for SPE, so removed for now. *)
    (* -- SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime Tests -- *)
    (*Example[{Options, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, "If SecondarySolidPhaseExtractionWashTemperature is set to temperature besides Ambient, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SecondarySolidPhaseExtractionWashTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> EqualP[3 Minute]}]
      },
      TimeConstraint -> 600
    ],*)

    (* -- SecondarySolidPhaseExtractionWashFlowthroughContainerOut Tests -- *)
    Example[{Options, SecondarySolidPhaseExtractionWashFlowthroughContainerOut, "If CollectSecondarySolidPhaseExtractionWashFlowthrough is set to True, then SecondarySolidPhaseExtractionWashFlowthroughContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        CollectSecondarySolidPhaseExtractionWashFlowthrough -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]]}] (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
      },
      TimeConstraint -> 600
    ],

    (* -- TertiarySolidPhaseExtractionWashSolutionVolume Tests -- *)
    Example[{Options, TertiarySolidPhaseExtractionWashSolutionVolume, "If SolidPhaseExtraction is included in Purification and a TertiarySolidPhaseExtractionWashSolution is specified, then the TertiarySolidPhaseExtractionWashSolutionVolume is automatically set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"], (* Model[Container, Plate, Filter, "QiaQuick 96well"] *)
        TertiarySolidPhaseExtractionWashSolution -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            TertiarySolidPhaseExtractionWashSolutionVolume -> EqualP[1 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* NOTE: Non-ambient temperatures not currently supported for SPE, so removed for now. *)
    (* -- SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime Tests -- *)
    (*Example[{Options, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, "TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and TertiarySolidPhaseExtractionWashTemperature is not Ambient or Null:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        TertiarySolidPhaseExtractionWashTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> EqualP[3 Minute]}]
      },
      TimeConstraint -> 600
    ],*)

    (* -- TertiarySolidPhaseExtractionWashFlowthroughContainerOut Tests -- *)
    Example[{Options, TertiarySolidPhaseExtractionWashFlowthroughContainerOut, "If CollectTertiarySolidPhaseExtractionWashFlowthrough is set to True, then TertiarySolidPhaseExtractionWashFlowthroughContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        CollectTertiarySolidPhaseExtractionWashFlowthrough -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> ObjectP[Model[Container, Plate, "id:n0k9mGkwbvG4"]]}] (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionElutionSolutionVolume Tests -- *)
    Example[{Options, SolidPhaseExtractionElutionSolutionVolume, "If a SolidPhaseExtractionElutionSolution is specified, then SolidPhaseExtractionElutionSolutionVolume is set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"], (* Model[Container, Plate, Filter, "QiaQuick 96well"] *)
        SolidPhaseExtractionElutionSolution -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionElutionSolutionVolume -> EqualP[1 Milliliter]}]
      },
      TimeConstraint -> 600
    ],

    (* NOTE: Non-ambient temperatures not currently supported for SPE, so removed for now. *)
    (* -- SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime Tests -- *)
    (*Example[{Options, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, "If SolidPhaseExtractionSolutionTemperature is set to a temperature that is not Ambient temperature, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime is set to 3 Minutes:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionElutionSolutionTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> EqualP[3 Minute]}]
      },
      TimeConstraint -> 600
    ],*)

    (* -- SolidPhaseExtractionElutionCentrifugeIntensity Tests -- *)
    Example[{Options, SolidPhaseExtractionElutionCentrifugeIntensity, "If SolidPhaseExtractionInstrument is set to a centrifuge, then SolidPhaseExtractionElutionCentrifugeIntensity is automatically set to the MaxIntensity of the Centrifuge model:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionElutionCentrifugeIntensity -> EqualP[5000 RPM]}]
      },
      TimeConstraint -> 600
    ],

    (* -- SolidPhaseExtractionElutionPressure Tests -- *)
    Example[{Options, SolidPhaseExtractionElutionPressure, "If SolidPhaseExtractionInstrument is set to a pressure manifold, then SolidPhaseExtractionElutionPressure is automatically set to the MaxRoboticAirPressure:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"], (*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionElutionPressure -> EqualP[$MaxRoboticAirPressure]}]
      },
      TimeConstraint -> 600
    ],

    (* SPE Message Tests *)

    Example[{Messages, "SolidPhaseExtractionTechniqueInstrumentMismatch", "Return an error if the specified SolidPhaseExtractionInstrument cannot perform the specified SolidPhaseExtractionTechnique (If MPE2 is selected, the Technique must be Pressure. If HiG4 is selected, the Technique must be Centrifuge):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        SolidPhaseExtractionTechnique -> Centrifuge,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::SolidPhaseExtractionTechniqueInstrumentMismatch,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],


    (* - SHARED MBS TESTS - *)

    (* Basic Example *)
    Example[{Basic, "Crude samples can be purified with magnetic bead separation:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSelectionStrategy, MagneticBeadSeparationMode, MagneticBeadCollectionStorageCondition, MagnetizationRack, LoadingMagnetizationTime, MagneticBeadSeparationLoadingCollectionContainer, MagneticBeadSeparationLoadingCollectionStorageCondition, and MagneticBeadSeparationLoadingAirDry Tests -- *)
    Example[{Options, {MagneticBeadSeparationSelectionStrategy, MagneticBeadSeparationMode, MagneticBeadCollectionStorageCondition, MagnetizationRack, LoadingMagnetizationTime, MagneticBeadSeparationLoadingCollectionContainer, MagneticBeadSeparationLoadingCollectionStorageCondition, MagneticBeadSeparationLoadingAirDry}, "By default, MagneticBeadSeparationSelectionStrategy is set to Positive, MagneticBeadSeparationMode is set to NormalPhase, MagneticBeadCollectionStorageCondition is automatically set to Disposal, MagnetizationRack is automatically set to Model[Item,MagnetizationRack,\"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"], MagneticBeadSeparationLoadingMix is automatically set to True, LoadingMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationLoadingCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationLoadingCollectionStorageCondition is automatically set to Refrigerator, and MagneticBeadSeparationLoadingAirDry is automatically set to False unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSelectionStrategy -> Positive,
            MagneticBeadSeparationMode -> NormalPhase,
            MagneticBeadCollectionStorageCondition -> Disposal,
            MagnetizationRack -> ObjectP[Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"]],(*Model[Item,MagnetizationRack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"]*)
            MagneticBeadSeparationLoadingMix -> True,
            LoadingMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationLoadingCollectionContainer -> {(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
            MagneticBeadSeparationLoadingCollectionStorageCondition -> Refrigerator,
            MagneticBeadSeparationLoadingAirDry -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSampleVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSampleVolume, "If the volume of the sample is less than 1 Millilter, then all of the sample will be used as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSampleVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSampleVolume, "If the volume of the sample is greater than 1 Milliliter, 1 Milliliter will be used as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "High Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSampleVolume -> EqualP[1 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationAnalyteAffinityLabel, MagneticBeadAffinityLabel, and MagneticBeads Tests -- *)
    Example[{Options, {MagneticBeadSeparationAnalyteAffinityLabel, MagneticBeadAffinityLabel, MagneticBeads}, "If MagneticBeadSeparationMode is set to Affinity,MagneticBeadSeparationAnalyteAffinityLabel is automatically set to the first item in Analytes of the sample, MagneticBeadAffinityLabel is automatically set to the first item in the Targets field of the target molecule object, and MagneticBeads is automatically set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel (or Model[Sample, \"Mag-Bind Particles CNR (Mag-Bind Viral DNA/RNA Kit)\" if there are no beads with the affinity label of MagneticBeadAffinityLabel)]:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationMode -> Affinity,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationAnalyteAffinityLabel -> ObjectP[Model[Molecule, Oligomer]],
            MagneticBeadAffinityLabel -> Null,
            MagneticBeads -> ObjectP[Model[Sample, "id:lYq9jRxLBKjp"]] (* Model[Sample, "Mag-Bind Particles CNR (Mag-Bind Viral DNA/RNA Kit)"] *)
          }
        ]
      },
      Messages :> {Warning::GeneralResolvedMagneticBeads},
      TimeConstraint -> 600
    ],

    (* -- MagneticBeads Tests -- *)
    Example[{Options, MagneticBeads, "If MagneticBeadSeparationMode is not set to Affinity, MagneticBeads is automatically set based on the MagneticBeadSeparationMode and the target of the extraction:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationMode -> NormalPhase,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeads -> Except[Null]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadVolume Tests -- *)
    Example[{Options, MagneticBeadVolume, "MagneticBeadVolume is automatically set to 1/10 of the MagneticBeadSeparationSampleVolume if not otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadVolume -> EqualP[0.02 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationLoadingCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingCollectionContainerLabel, "MagneticBeadSeparationLoadingCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWash Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWash, "If other magnetic bead separation prewash options are set, then MagneticBeadSeparationPreWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationPreWash, "If no magnetic bead separation prewash options are set, then MagneticBeadSeparationPreWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashSolution, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashSolution is automatically set to match the MagneticBeadSeparationElutionSolution:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationElutionSolution -> Model[Sample,"id:9RdZXvKBeeGK"], (* Model[Sample, "Ethyl acetate, HPLC Grade"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashSolution -> ObjectP[Model[Sample,"id:9RdZXvKBeeGK"]] (* Model[Sample, "Ethyl acetate, HPLC Grade"] *)
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashSolutionVolume, MagneticBeadSeparationPreWashMix, PreWashMagnetizationTime, MagneticBeadSeparationPreWashCollectionContainer, MagneticBeadSeparationPreWashCollectionStorageCondition, NumberOfMagneticBeadSeparationPreWashes, MagneticBeadSeparationPreWashAirDry, and MagneticBeadSeparationPreWashCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationPreWashSolutionVolume, MagneticBeadSeparationPreWashMix, PreWashMagnetizationTime, MagneticBeadSeparationPreWashCollectionContainer, MagneticBeadSeparationPreWashCollectionStorageCondition, NumberOfMagneticBeadSeparationPreWashes, MagneticBeadSeparationPreWashAirDry, MagneticBeadSeparationPreWashCollectionContainerLabel}, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashSolutionVolume is automatically set to the sample volume, MagneticBeadSeparationPreWashMix is automatically set to True, PreWashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationPreWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationPreWashCollectionStorageCondition is automatically set to Refrigerator, NumberOfMagneticBeadSeparationPreWashes is automatically set to 1, MagneticBeadSeparationPreWashAirDry is automatically set to False, and MagneticBeadSeparationPreWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationPreWashMix -> True,
            PreWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationPreWashCollectionContainer -> {{"A1", ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationPreWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationPreWashes -> 1,
            MagneticBeadSeparationPreWashAirDry -> False,
            MagneticBeadSeparationPreWashCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and shaking options are set, MagneticBeadSeparationPreWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixRate -> 200 RPM,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and pipetting options are set, MagneticBeadSeparationPreWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixVolume -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and no other mix options are set, MagneticBeadSeparationPreWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashMixTime and MagneticBeadSeparationPreWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationPreWashMixTime, MagneticBeadSeparationPreWashMixRate}, "If MagneticBeadSeparationPreWashMixType is set to Shake, MagneticBeadSeparationPreWashMixTime is automatically set to 5 Minute and MagneticBeadSeparationPreWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationPreWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationPreWashMixes, MagneticBeadSeparationPreWashMixTipType, and MagneticBeadSeparationPreWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationPreWashMixes, MagneticBeadSeparationPreWashMixTipType, MagneticBeadSeparationPreWashMixTipMaterial}, "If MagneticBeadSeparationPreWashMixType is set to Pipette, NumberOfMagneticBeadSeparationPreWashMixes is automatically set to 20, MagneticBeadSeparationPreWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationPreWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationPreWashMixes -> 20,
            MagneticBeadSeparationPreWashMixTipType -> WideBore,
            MagneticBeadSeparationPreWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL):"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        MagneticBeadVolume -> 1.0 Milliliter,
        MagneticBeadSeparationPreWashSolutionVolume -> 1.0 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixTemperature, "If MagneticBeadSeparationPreWashMix is True, MagneticBeadSeparationPreWashMixTemperature is automatically set to Ambient unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashAspirationVolume, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashAspirationVolume is automatically set to the MagneticBeadSeparationPreWashSolutionVolume unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationPreWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashAirDryTime, "If MagneticBeadSeparationPreWashAirDry is True, MagneticBeadSeparationPreWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWashAirDry -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibration Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibration, "If any magnetic bead separation equilibration options are set (MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationSolutionVolume, MagneticBeadSeparationEquilibrationMix, etc.), MagneticBeadSeparationEquilibration is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibration -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationEquilibration, "If no magnetic bead separation equilibration options are set (MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationSolutionVolume, MagneticBeadSeparationEquilibrationMix, etc.), MagneticBeadSeparationEquilibration is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibration -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationMix, EquilibrationMagnetizationTime, MagneticBeadSeparationEquilibrationCollectionContainer, MagneticBeadSeparationEquilibrationCollectionStorageCondition, MagneticBeadSeparationEquilibrationAirDry, and MagneticBeadSeparationEquilibrationCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationMix, EquilibrationMagnetizationTime, MagneticBeadSeparationEquilibrationCollectionContainer, MagneticBeadSeparationEquilibrationCollectionStorageCondition, MagneticBeadSeparationEquilibrationAirDry, MagneticBeadSeparationEquilibrationCollectionContainerLabel}, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolution is automatically set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationEquilibrationMix is automatically set to True, EquilibrationMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationEquilibrationCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationEquilibrationCollectionStorageCondition is automatically set to Refrigerator, MagneticBeadSeparationEquilibrationAirDry is automatically set to False, and MagneticBeadSeparationEquilibrationCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationSolution -> ObjectP[Model[Sample, "Milli-Q water"]],
            MagneticBeadSeparationEquilibrationMix -> True,
            EquilibrationMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationEquilibrationCollectionContainer -> {(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
            MagneticBeadSeparationEquilibrationCollectionStorageCondition -> Refrigerator,
            MagneticBeadSeparationEquilibrationAirDry -> False,
            MagneticBeadSeparationEquilibrationCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationSolutionVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolution is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationSolutionVolume -> EqualP[0.1 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If MagneticBeadSeparationEquilibrationMixRate or MagneticBeadSeparationEquilibrationMixTime are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixTime -> 1 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If NumberOfMagneticBeadSeparationEquilibrationMixes or MagneticBeadSeparationEquilibrationMixVolume are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationEquilibrationMixes -> 10,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationMixTime and MagneticBeadSeparationEquilibrationMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationEquilibrationMixTime, MagneticBeadSeparationEquilibrationMixRate}, "If MagneticBeadSeparationEquilibrationMixType is set to Shake, MagneticBeadSeparationEquilibrationMixTime is automatically set to 5 minutes and MagneticBeadSeparationEquilibrationMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationEquilibrationMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationEquilibrationMixes, MagneticBeadSeparationEquilibrationMixTipType, and MagneticBeadSeparationEquilibrationMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationEquilibrationMixes, MagneticBeadSeparationEquilibrationMixTipType, MagneticBeadSeparationEquilibrationMixTipMaterial}, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, NumberOfMagneticBeadSeparationEquilibrationMixes is automatically set to 20, MagneticBeadSeparationEquilibrationMixTipType is automatically set to WideBore, and MagneticBeadSeparationEquilibrationMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationEquilibrationMixes -> 20,
            MagneticBeadSeparationEquilibrationMixTipType -> WideBore,
            MagneticBeadSeparationEquilibrationMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 80% of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 80% of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 80% of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixTemperature, "If MagneticBeadSeparationEquilibrationMix is set to True, MagneticBeadSeparationEquilibrationMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationAspirationVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationAspirationVolume is automatically set the same as the MagneticBeadSeparationEquilibrationSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationEquilibrationAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationAirDryTime, "If MagneticBeadSeparationEquilibrationAirDry is set to True, MagneticBeadSeparationEquilibrationAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationAirDry -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationLoadingMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If MagneticBeadSeparationLoadingMixRate or MagneticBeadSeparationLoadingMixTime are set, MagneticBeadSeparationLoadingMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixTime -> 1 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If NumberOfMagneticBeadSeparationLoadingMixes or MagneticBeadSeparationLoadingMixVolume are set, MagneticBeadSeparationLoadingMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationLoadingMixes -> 10,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationLoadingMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationLoadingMixTime Tests -- *)
    Example[{Options, {MagneticBeadSeparationLoadingMixTime, MagneticBeadSeparationLoadingMixRate}, "If MagneticBeadSeparationLoadingMixType is set to Shake, MagneticBeadSeparationLoadingMixTime is automatically set to 5 minutes and MagneticBeadSeparationLoadingMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationLoadingMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationLoadingMixes Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationLoadingMixes, MagneticBeadSeparationLoadingMixTipType, MagneticBeadSeparationLoadingMixTipMaterial}, "If MagneticBeadSeparationLoadingMixType is set to Pipette, NumberOfMagneticBeadSeparationLoadingMixes is automatically set to 20, MagneticBeadSeparationLoadingMixTipType is automatically set to WideBore, and MagneticBeadSeparationLoadingMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationLoadingMixes -> 20,
            MagneticBeadSeparationLoadingMixTipType -> WideBore,
            MagneticBeadSeparationLoadingMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationLoadingMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and 80% of the MagneticBeadSeparationSampleVolume is less than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 80% of the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadVolume -> 0.02 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixVolume -> EqualP[0.176 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and set to 80% of the MagneticBeadSeparationSampleVolume is greater than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadVolume -> 1.8 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationLoadingMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixTemperature, "If MagneticBeadSeparationLoadingMix is set to True, MagneticBeadSeparationLoadingMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationLoadingAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingAspirationVolume, "MagneticBeadSeparationLoadingAspirationVolume is automatically set the same as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationLoadingAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingAirDryTime, "If MagneticBeadSeparationLoadingAirDry is set to True, MagneticBeadSeparationLoadingAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationLoadingAirDry -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWash Tests -- *)
    Example[{Options, MagneticBeadSeparationWash, "If any magnetic bead separation wash options are set (MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashSolutionVolume, MagneticBeadSeparationWashMix, etc.), MagneticBeadSeparationWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationWash, "If no magnetic bead separation wash options are set (MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashSolutionVolume, MagneticBeadSeparationWashMix, etc.), MagneticBeadSeparationWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashMix, WashMagnetizationTime, MagneticBeadSeparationWashCollectionContainer, MagneticBeadSeparationWashCollectionStorageCondition, NumberOfMagneticBeadSeparationWashes, MagneticBeadSeparationWashAirDry, and MagneticBeadSeparationWashCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashMix, WashMagnetizationTime, MagneticBeadSeparationWashCollectionContainer, MagneticBeadSeparationWashCollectionStorageCondition, NumberOfMagneticBeadSeparationWashes, MagneticBeadSeparationWashAirDry, MagneticBeadSeparationWashCollectionContainerLabel}, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"], MagneticBeadSeparationWashMix is automatically set to True, WashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationWashCollectionStorageCondition is automatically set to Refrigerator, NumberOfMagneticBeadSeparationWashes is automatically set to 1, MagneticBeadSeparationWashAirDry is automatically set to False, and MagneticBeadSeparationWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashSolution -> ObjectP[Model[Sample,"id:KBL5DvLdq1Zd"]], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
            MagneticBeadSeparationWashMix -> True,
            WashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationWashCollectionContainer -> {{(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationWashes -> 1,
            MagneticBeadSeparationWashAirDry -> False,
            MagneticBeadSeparationWashCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationWashSolutionVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolution is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashSolutionVolume -> EqualP[0.1 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixType, "If MagneticBeadSeparationWashMixRate or MagneticBeadSeparationWashMixTime are set, MagneticBeadSeparationWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMixTime -> 1 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationWashMixType, "If NumberOfMagneticBeadSeparationWashMixes or MagneticBeadSeparationWashMixVolume are set, MagneticBeadSeparationWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationWashMixes -> 10,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationWashMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashMixTime and MagneticBeadSeparationWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationWashMixTime, MagneticBeadSeparationWashMixRate}, "If MagneticBeadSeparationWashMixType is set to Shake, MagneticBeadSeparationWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationWashSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        MagneticBeadSeparationWashSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixTemperature, "If MagneticBeadSeparationWashMix is set to True, MagneticBeadSeparationWashMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationWashMixes, MagneticBeadSeparationWashMixTipType, MagneticBeadSeparationWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationWashMixes, MagneticBeadSeparationWashMixTipType, MagneticBeadSeparationWashMixTipMaterial}, "If MagneticBeadSeparationWashMixType is set to Pipette, NumberOfMagneticBeadSeparationWashMixes is automatically set to 20, MagneticBeadSeparationWashMixTipType is automatically set to WideBore and MagneticBeadSeparationWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationWashMixes -> 20,
            MagneticBeadSeparationWashMixTipType -> WideBore,
            MagneticBeadSeparationWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationWashAspirationVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashAspirationVolume is automatically set the same as the MagneticBeadSeparationWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationWashAirDryTime, "If MagneticBeadSeparationWashAirDry is set to True, MagneticBeadSeparationWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationWashAirDry -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWash, "If any magnetic bead separation secondary wash options are set (MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashSolutionVolume, MagneticBeadSeparationSecondaryWashMix, etc.), MagneticBeadSeparationSecondaryWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Shake,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWash, "If no magnetic bead separation secondary wash options are set (MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashSolutionVolume, MagneticBeadSeparationSecondaryWashMix, etc.), MagneticBeadSeparationSecondaryWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashMix, SecondaryWashMagnetizationTime, MagneticBeadSeparationSecondaryWashCollectionContainer, MagneticBeadSeparationSecondaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSecondaryWashes, MagneticBeadSeparationSecondaryWashAirDry, and MagneticBeadSeparationSecondaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashMix, SecondaryWashMagnetizationTime, MagneticBeadSeparationSecondaryWashCollectionContainer, MagneticBeadSeparationSecondaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSecondaryWashes, MagneticBeadSeparationSecondaryWashAirDry, MagneticBeadSeparationSecondaryWashCollectionContainerLabel}, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"], MagneticBeadSeparationSecondaryWashMix is automatically set to True, SecondaryWashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationSecondaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationSecondaryWashCollectionStorageCondition is automatically set to Refrigerator, NumberOfMagneticBeadSeparationSecondaryWashes is automatically set to 1, MagneticBeadSeparationSecondaryWashAirDry is automatically set to False, and MagneticBeadSeparationSecondaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashSolution -> ObjectP[Model[Sample,"id:KBL5DvLdq1Zd"]], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
            MagneticBeadSeparationSecondaryWashMix -> True,
            SecondaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationSecondaryWashCollectionContainer -> {{(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationSecondaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationSecondaryWashes -> 1,
            MagneticBeadSeparationSecondaryWashAirDry -> False,
            MagneticBeadSeparationSecondaryWashCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If MagneticBeadSeparationSecondaryWashMixRate or MagneticBeadSeparationSecondaryWashMixTime are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixTime -> 1 Minute,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If NumberOfMagneticBeadSeparationSecondaryWashMixes or MagneticBeadSeparationSecondaryWashMixVolume are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationSecondaryWashMixes -> 10,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If no magnetic bead separation secondary wash mix options are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMix -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixTime and MagneticBeadSeparationSecondaryWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationSecondaryWashMixTime, MagneticBeadSeparationSecondaryWashMixRate}, "If MagneticBeadSeparationSecondaryWashMixType is set to Shake, MagneticBeadSeparationSecondaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationSecondaryWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Shake,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationSecondaryWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationSecondaryWashMixes, MagneticBeadSeparationSecondaryWashMixTipType, and MagneticBeadSeparationSecondaryWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationSecondaryWashMixes, MagneticBeadSeparationSecondaryWashMixTipType, MagneticBeadSeparationSecondaryWashMixTipMaterial}, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSecondaryWashMixes is automatically set to 20, MagneticBeadSeparationSecondaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationSecondaryWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationSecondaryWashMixes -> 20,
            MagneticBeadSeparationSecondaryWashMixTipType -> WideBore,
            MagneticBeadSeparationSecondaryWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixTemperature, "If MagneticBeadSeparationSecondaryWashMix is set to True, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMix -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashAspirationVolume, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSecondaryWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSecondaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashAirDryTime, "If MagneticBeadSeparationSecondaryWashAirDry is set to True, MagneticBeadSeparationSecondaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashAirDry -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSecondaryWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWash, "If any magnetic bead separation tertiary wash options are set (MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashSolutionVolume, MagneticBeadSeparationTertiaryWashMix, etc.), MagneticBeadSeparationTertiaryWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWash, "If no magnetic bead separation tertiary wash options are set (MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashSolutionVolume, MagneticBeadSeparationTertiaryWashMix, etc.), MagneticBeadSeparationTertiaryWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashMix, TertiaryWashMagnetizationTime, MagneticBeadSeparationTertiaryWashCollectionContainer, MagneticBeadSeparationTertiaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationTertiaryWashes, MagneticBeadSeparationTertiaryWashAirDry, and MagneticBeadSeparationTertiaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashMix, TertiaryWashMagnetizationTime, MagneticBeadSeparationTertiaryWashCollectionContainer, MagneticBeadSeparationTertiaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationTertiaryWashes, MagneticBeadSeparationTertiaryWashAirDry, MagneticBeadSeparationTertiaryWashCollectionContainerLabel}, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"], MagneticBeadSeparationTertiaryWashMix is automatically set to True, TertiaryWashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationTertiaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationTertiaryWashCollectionStorageCondition is automatically set to Refrigerator, NumberOfMagneticBeadSeparationTertiaryWashes is automatically set to 1, MagneticBeadSeparationTertiaryWashAirDry is automatically set to False, and MagneticBeadSeparationTertiaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashSolution -> ObjectP[Model[Sample,"id:KBL5DvLdq1Zd"]], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
            MagneticBeadSeparationTertiaryWashMix -> True,
            TertiaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationTertiaryWashCollectionContainer -> {{(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationTertiaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationTertiaryWashes -> 1,
            MagneticBeadSeparationTertiaryWashAirDry -> False,
            MagneticBeadSeparationTertiaryWashCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationTertiaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationTertiaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If MagneticBeadSeparationTertiaryWashMixRate or MagneticBeadSeparationTertiaryWashMixTime are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If NumberOfMagneticBeadSeparationTertiaryWashMixes or MagneticBeadSeparationTertiaryWashMixVolume are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationTertiaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If no magnetic bead separation tertiary wash mix options are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixTime and MagneticBeadSeparationTertiaryWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationTertiaryWashMixTime, MagneticBeadSeparationTertiaryWashMixRate}, "If MagneticBeadSeparationTertiaryWashMixType is set to Shake, MagneticBeadSeparationTertiaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationTertiaryWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationTertiaryWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationTertiaryWashMixes, MagneticBeadSeparationTertiaryWashMixTipType, and MagneticBeadSeparationTertiaryWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationTertiaryWashMixes, MagneticBeadSeparationTertiaryWashMixTipType, MagneticBeadSeparationTertiaryWashMixTipMaterial}, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationTertiaryWashMixes is automatically set to 20, MagneticBeadSeparationTertiaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationTertiaryWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationTertiaryWashMixes -> 20,
            MagneticBeadSeparationTertiaryWashMixTipType -> WideBore,
            MagneticBeadSeparationTertiaryWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixTemperature, "If MagneticBeadSeparationTertiaryWashMix is set to True, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashAspirationVolume, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationTertiaryWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationTertiaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashAirDryTime, "If MagneticBeadSeparationTertiaryWashAirDry is set to True, MagneticBeadSeparationTertiaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationTertiaryWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWash, "If any magnetic bead separation quaternary wash options are set (MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashSolutionVolume, MagneticBeadSeparationQuaternaryWashMix, etc.), MagneticBeadSeparationQuaternaryWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWash, "If no magnetic bead separation quaternary wash options are set (MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashSolutionVolume, MagneticBeadSeparationQuaternaryWashMix, etc.), MagneticBeadSeparationQuaternaryWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashMix, QuaternaryWashMagnetizationTime, MagneticBeadSeparationQuaternaryWashCollectionContainer, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuaternaryWashes, MagneticBeadSeparationQuaternaryWashAirDry, and MagneticBeadSeparationQuaternaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashMix, QuaternaryWashMagnetizationTime, MagneticBeadSeparationQuaternaryWashCollectionContainer, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuaternaryWashes, MagneticBeadSeparationQuaternaryWashAirDry, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel}, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"], MagneticBeadSeparationQuaternaryWashMix is automatically set to True, QuaternaryWashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationQuaternaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationQuaternaryWashCollectionStorageCondition is automatically set to Refrigerator, NumberOfMagneticBeadSeparationQuaternaryWashes is automatically set to 1, MagneticBeadSeparationQuaternaryWashAirDry is automatically set to False, and MagneticBeadSeparationQuaternaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashSolution -> ObjectP[Model[Sample,"id:KBL5DvLdq1Zd"]], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
            MagneticBeadSeparationQuaternaryWashMix -> True,
            QuaternaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationQuaternaryWashCollectionContainer -> {{(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationQuaternaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationQuaternaryWashes -> 1,
            MagneticBeadSeparationQuaternaryWashAirDry -> False,
            MagneticBeadSeparationQuaternaryWashCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuaternaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationQuaternaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If MagneticBeadSeparationQuaternaryWashMixRate or MagneticBeadSeparationQuaternaryWashMixTime are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If NumberOfMagneticBeadSeparationQuaternaryWashMixes or MagneticBeadSeparationQuaternaryWashMixVolume are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If no magnetic bead separation quaternary wash mix options are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixTime and MagneticBeadSeparationQuaternaryWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationQuaternaryWashMixTime, MagneticBeadSeparationQuaternaryWashMixRate}, "If MagneticBeadSeparationQuaternaryWashMixType is set to Shake, MagneticBeadSeparationQuaternaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationQuaternaryWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationQuaternaryWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationQuaternaryWashMixes, MagneticBeadSeparationQuaternaryWashMixTipType, and MagneticBeadSeparationQuaternaryWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationQuaternaryWashMixes, MagneticBeadSeparationQuaternaryWashMixTipType, MagneticBeadSeparationQuaternaryWashMixTipMaterial}, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuaternaryWashMixes is automatically set to 20, MagneticBeadSeparationQuaternaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationQuaternaryWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 20,
            MagneticBeadSeparationQuaternaryWashMixTipType -> WideBore,
            MagneticBeadSeparationQuaternaryWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixTemperature, "If MagneticBeadSeparationQuaternaryWashMix is set to True, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashAspirationVolume, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuaternaryWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuaternaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashAirDryTime, "If MagneticBeadSeparationQuaternaryWashAirDry is set to True, MagneticBeadSeparationQuaternaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuaternaryWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWash, "If any magnetic bead separation quinary wash options are set (MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashSolutionVolume, MagneticBeadSeparationQuinaryWashMix, etc.), MagneticBeadSeparationQuinaryWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWash, "If no magnetic bead separation quinary wash options are set (MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashSolutionVolume, MagneticBeadSeparationQuinaryWashMix, etc.), MagneticBeadSeparationQuinaryWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashMix, QuinaryWashMagnetizationTime, MagneticBeadSeparationQuinaryWashCollectionContainer, MagneticBeadSeparationQuinaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuinaryWashes, MagneticBeadSeparationQuinaryWashAirDry, and MagneticBeadSeparationQuinaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashMix, QuinaryWashMagnetizationTime, MagneticBeadSeparationQuinaryWashCollectionContainer, MagneticBeadSeparationQuinaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuinaryWashes, MagneticBeadSeparationQuinaryWashAirDry, MagneticBeadSeparationQuinaryWashCollectionContainerLabel}, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"], MagneticBeadSeparationQuinaryWashMix is automatically set to True, QuinaryWashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationQuinaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationQuinaryWashCollectionStorageCondition is automatically set to Refrigerator, NumberOfMagneticBeadSeparationQuinaryWashes is automatically set to 1, MagneticBeadSeparationQuinaryWashAirDry is automatically set to False, and MagneticBeadSeparationQuinaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashSolution -> ObjectP[Model[Sample,"id:KBL5DvLdq1Zd"]], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
            MagneticBeadSeparationQuinaryWashMix -> True,
            QuinaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationQuinaryWashCollectionContainer -> {{(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationQuinaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationQuinaryWashes -> 1,
            MagneticBeadSeparationQuinaryWashAirDry -> False,
            MagneticBeadSeparationQuinaryWashCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuinaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationQuinaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If MagneticBeadSeparationQuinaryWashMixRate or MagneticBeadSeparationQuinaryWashMixTime are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If NumberOfMagneticBeadSeparationQuinaryWashMixes or MagneticBeadSeparationQuinaryWashMixVolume are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationQuinaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If no magnetic bead separation quinary wash mix options are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixTime and MagneticBeadSeparationQuinaryWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationQuinaryWashMixTime, MagneticBeadSeparationQuinaryWashMixRate}, "If MagneticBeadSeparationQuinaryWashMixType is set to Shake, MagneticBeadSeparationQuinaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationQuinaryWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationQuinaryWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationQuinaryWashMixes, MagneticBeadSeparationQuinaryWashMixTipType, and MagneticBeadSeparationQuinaryWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationQuinaryWashMixes, MagneticBeadSeparationQuinaryWashMixTipType, MagneticBeadSeparationQuinaryWashMixTipMaterial}, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuinaryWashMixes is automatically set to 20, MagneticBeadSeparationQuinaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationQuinaryWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationQuinaryWashMixes -> 20,
            MagneticBeadSeparationQuinaryWashMixTipType -> WideBore,
            MagneticBeadSeparationQuinaryWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixTemperature, "If MagneticBeadSeparationQuinaryWashMix is set to True, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashAspirationVolume, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuinaryWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationQuinaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashAirDryTime, "If MagneticBeadSeparationQuinaryWashAirDry is set to True, MagneticBeadSeparationQuinaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationQuinaryWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWash, "If any magnetic bead separation senary wash options are set (MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashSolutionVolume, MagneticBeadSeparationSenaryWashMix, etc.), MagneticBeadSeparationSenaryWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSenaryWash, "If no magnetic bead separation senary wash options are set (MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashSolutionVolume, MagneticBeadSeparationSenaryWashMix, etc.), MagneticBeadSeparationSenaryWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashMix, SenaryWashMagnetizationTime, MagneticBeadSeparationSenaryWashCollectionContainer, MagneticBeadSeparationSenaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSenaryWashes, MagneticBeadSeparationSenaryWashAirDry, and MagneticBeadSeparationSenaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, {MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashMix, SenaryWashMagnetizationTime, MagneticBeadSeparationSenaryWashCollectionContainer, MagneticBeadSeparationSenaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSenaryWashes, MagneticBeadSeparationSenaryWashAirDry, MagneticBeadSeparationSenaryWashCollectionContainerLabel}, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"], MagneticBeadSeparationSenaryWashMix is automatically set to True, SenaryWashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationSenaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationSenaryWashCollectionStorageCondition is automatically set to Refrigerator, NumberOfMagneticBeadSeparationSenaryWashes is automatically set to 1, MagneticBeadSeparationSenaryWashAirDry is automatically set to False, and MagneticBeadSeparationSenaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashSolution -> ObjectP[Model[Sample,"id:KBL5DvLdq1Zd"]], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
            MagneticBeadSeparationSenaryWashMix -> True,
            SenaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationSenaryWashCollectionContainer -> {{(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationSenaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationSenaryWashes -> 1,
            MagneticBeadSeparationSenaryWashAirDry -> False,
            MagneticBeadSeparationSenaryWashCollectionContainerLabel -> {(_String)}
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSenaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationSenaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If MagneticBeadSeparationSenaryWashMixRate or MagneticBeadSeparationSenaryWashMixTime are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If NumberOfMagneticBeadSeparationSenaryWashMixes or MagneticBeadSeparationSenaryWashMixVolume are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationSenaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If no magnetic bead separation senary wash mix options are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashMixTime and MagneticBeadSeparationSenaryWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationSenaryWashMixTime, MagneticBeadSeparationSenaryWashMixRate}, "If MagneticBeadSeparationSenaryWashMixType is set to Shake, MagneticBeadSeparationSenaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationSenaryWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationSenaryWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationSenaryWashMixes, MagneticBeadSeparationSenaryWashMixTipType, and MagneticBeadSeparationSenaryWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationSenaryWashMixes, MagneticBeadSeparationSenaryWashMixTipType, MagneticBeadSeparationSenaryWashMixTipMaterial}, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSenaryWashMixes is automatically set to 20, MagneticBeadSeparationSenaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationSenaryWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationSenaryWashMixes -> 20,
            MagneticBeadSeparationSenaryWashMixTipType -> WideBore,
            MagneticBeadSeparationSenaryWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixTemperature, "If MagneticBeadSeparationSenaryWashMix is set to True, MagneticBeadSeparationSenaryWashMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashAspirationVolume, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSenaryWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSenaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashAirDryTime, "If MagneticBeadSeparationSenaryWashAirDry is set to True, MagneticBeadSeparationSenaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSenaryWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWash, "If any magnetic bead separation septenary wash options are set (MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashSolutionVolume, MagneticBeadSeparationSeptenaryWashMix, etc.), MagneticBeadSeparationSeptenaryWash is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWash -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWash, "If no magnetic bead separation septenary wash options are set (MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashSolutionVolume, MagneticBeadSeparationSeptenaryWashMix, etc.), MagneticBeadSeparationSeptenaryWash is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWash -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashMix, SeptenaryWashMagnetizationTime, MagneticBeadSeparationSeptenaryWashCollectionContainer, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition, MagneticBeadSeparationSeptenaryWashAirDry, and NumberOfMagneticBeadSeparationSeptenaryWashes Tests -- *)
    Example[{Options, {MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashMix, SeptenaryWashMagnetizationTime, MagneticBeadSeparationSeptenaryWashCollectionContainer, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition, MagneticBeadSeparationSeptenaryWashAirDry, NumberOfMagneticBeadSeparationSeptenaryWashes}, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashSolution is automatically set to Model[Sample,\"Zyppy Wash Buffer\"], MagneticBeadSeparationSeptenaryWashCollectionContainerLabel is automatically generated, MagneticBeadSeparationSeptenaryWashMix is automatically set to True, SeptenaryWashMagnetizationTime is automatically set to 5 minutes, MagneticBeadSeparationSeptenaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationSeptenaryWashCollectionStorageCondition is automatically set to Refrigerator,MagneticBeadSeparationSeptenaryWashAirDry is automatically set to False, and NumberOfMagneticBeadSeparationSeptenaryWashes is automatically set to 1 unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashSolution -> ObjectP[Model[Sample,"id:KBL5DvLdq1Zd"]], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
            MagneticBeadSeparationSeptenaryWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationSeptenaryWashMix -> True,
            SeptenaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationSeptenaryWashCollectionContainer -> {{(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationSeptenaryWashCollectionStorageCondition -> Refrigerator,
            MagneticBeadSeparationSeptenaryWashAirDry -> False,
            NumberOfMagneticBeadSeparationSeptenaryWashes -> 1
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSeptenaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationSeptenaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If MagneticBeadSeparationSeptenaryWashMixRate or MagneticBeadSeparationSeptenaryWashMixTime are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If NumberOfMagneticBeadSeparationSeptenaryWashMixes or MagneticBeadSeparationSeptenaryWashMixVolume are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If no magnetic bead separation septenary wash mix options are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixTime and MagneticBeadSeparationSeptenaryWashMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationSeptenaryWashMixTime, MagneticBeadSeparationSeptenaryWashMixRate}, "If MagneticBeadSeparationSeptenaryWashMixType is set to Shake, MagneticBeadSeparationSeptenaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationSeptenaryWashMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationSeptenaryWashMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationSeptenaryWashMixes, MagneticBeadSeparationSeptenaryWashMixTipType, and MagneticBeadSeparationSeptenaryWashMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationSeptenaryWashMixes, MagneticBeadSeparationSeptenaryWashMixTipType, MagneticBeadSeparationSeptenaryWashMixTipMaterial}, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSeptenaryWashMixes is automatically set to 20, MagneticBeadSeparationSeptenaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationSeptenaryWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 20,
            MagneticBeadSeparationSeptenaryWashMixTipType -> WideBore,
            MagneticBeadSeparationSeptenaryWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
        MagneticBeadSeparationSeptenaryWashSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixTemperature, "If MagneticBeadSeparationSeptenaryWashMix is set to True, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashAspirationVolume, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSeptenaryWashSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashAspirationVolume -> EqualP[0.2 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationSeptenaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashAirDryTime, "If MagneticBeadSeparationSeptenaryWashAirDry is set to True, MagneticBeadSeparationSeptenaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSeptenaryWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationElution Tests -- *)
    Example[{Options, MagneticBeadSeparationElution, "If any magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.) or MagneticBeadSeparationSelectionStrategy is set to Positive, MagneticBeadSeparationElution is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationSelectionStrategy -> Positive,
        MagneticBeadSeparationElutionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElution -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationElution, "If MagneticBeadSeparationSelectionStrategy is Positive, MagneticBeadSeparationElution is automatically set to True:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationSelectionStrategy -> Positive,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElution -> True
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationElution, "If no magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.) and MagneticBeadSeparationSelectionStrategy is Negative, MagneticBeadSeparationElution is automatically set to False:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElution -> False
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationElutionCollectionContainerLabel, MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionMix, ElutionMagnetizationTime, MagneticBeadSeparationElutionCollectionContainer, MagneticBeadSeparationElutionCollectionStorageCondition, and NumberOfMagneticBeadSeparationElutions Options Tests -- *)
    Example[{Options, {MagneticBeadSeparationElutionCollectionContainerLabel, MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionMix, ElutionMagnetizationTime, MagneticBeadSeparationElutionCollectionContainer, MagneticBeadSeparationElutionCollectionStorageCondition, NumberOfMagneticBeadSeparationElutions}, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionContainerLabel is generated, MagneticBeadSeparationElutionSolution is set to Model[Sample, \"Zyppy Elution Buffer\"], MagneticBeadSeparationElutionMix is set to True, ElutionMagnetizationTime is set to 5 minutes, MagneticBeadSeparationElutionCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationElutionCollectionStorageCondition is set to Refrigerator, and NumberOfMagneticBeadSeparationElutions is set to 1 unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationElutionSolution -> ObjectP[Model[Sample, "id:aXRlGnRDj930"]], (* Model[Sample, "Zyppy Elution Buffer"] *)
            MagneticBeadSeparationElutionMix -> True,
            ElutionMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationElutionCollectionContainer -> {(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]},
            MagneticBeadSeparationElutionCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationElutions -> 1
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionSolutionVolume and MagneticBeadSeparationElutionAspirationVolume Options Tests -- *)
    Example[{Options, {MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionAspirationVolume}, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionSolutionVolume is automatically set 1/10 of the MagneticBeadSeparationSampleVolume and MagneticBeadSeparationElutionAspirationVolume is automatically set the same as the MagneticBeadSeparationElutionSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionSolutionVolume -> EqualP[0.02 Milliliter],
            MagneticBeadSeparationElutionAspirationVolume -> EqualP[0.02 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationElutionMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixType, "If MagneticBeadSeparationElutionMixRate or MagneticBeadSeparationElutionMixTime are set, MagneticBeadSeparationElutionMixType is automatically set to Shake:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMixTime -> 1 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationElutionMixType, "If NumberOfMagneticBeadSeparationElutionMixes or MagneticBeadSeparationElutionMixVolume are set, MagneticBeadSeparationElutionMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        NumberOfMagneticBeadSeparationElutionMixes -> 10,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationElutionMixType, "If no magnetic bead separation elution mix options are set, MagneticBeadSeparationElutionMixType is automatically set to Pipette:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixType -> Pipette
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationElutionMixTime and MagneticBeadSeparationElutionMixRate Tests -- *)
    Example[{Options, {MagneticBeadSeparationElutionMixTime, MagneticBeadSeparationElutionMixRate}, "If MagneticBeadSeparationElutionMixType is set to Shake, MagneticBeadSeparationElutionMixTime is automatically set to 5 minutes and MagneticBeadSeparationElutionMixRate is automatically set to 300 RPM unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixTime -> EqualP[5 Minute],
            MagneticBeadSeparationElutionMixRate -> EqualP[300 RPM]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- NumberOfMagneticBeadSeparationElutionMixes, MagneticBeadSeparationElutionMixTipType, and MagneticBeadSeparationElutionMixTipMaterial Tests -- *)
    Example[{Options, {NumberOfMagneticBeadSeparationElutionMixes, MagneticBeadSeparationElutionMixTipType, MagneticBeadSeparationElutionMixTipMaterial}, "If MagneticBeadSeparationElutionMixType is set to Pipette, NumberOfMagneticBeadSeparationElutionMixes is automatically set to 20, MagneticBeadSeparationElutionMixTipType is automatically set to WideBore, and MagneticBeadSeparationElutionMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationElutionMixes -> 20,
            MagneticBeadSeparationElutionMixTipType -> WideBore,
            MagneticBeadSeparationElutionMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationElutionMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 80% of the combined MagneticBeadSeparationElutionSolutionVolume and MagneticBeadVolume is less than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 80% of theMagneticBeadSeparationElutionSolutionVolume:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixVolume -> EqualP[0.32 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],
    Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 80% of the combined MagneticBeadSeparationElutionSolutionVolume and MagneticBeadVolume is greater than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        MagneticBeadSeparationElutionSolutionVolume -> 1.8 Milliliter,
        MagneticBeadVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 600
    ],

    (* -- MagneticBeadSeparationElutionMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixTemperature, "If MagneticBeadSeparationElutionMix is set to True, MagneticBeadSeparationElutionMixVolume is automatically set to Ambient:"},
      ExperimentExtractPlasmidDNA[
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        MagneticBeadSeparationElutionMix -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 600
    ]

  },
  Parallel -> True,
  TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct, Warning::ConflictingSourceAndDestinationAsepticHandling},
  SymbolSetUp :> Module[{existsFilter, oligomer0, plate0, plate1, plate2, plate3, plate4, plate5, plate6, plate7, plate8, plate9, plate10, plate11, plate12, plate13, plate14, plate15, tube0, sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, method0, method1},
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter = DatabaseMemberQ[{
      Model[Molecule, Oligomer, "Test Plasmid DNA 0 (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Suspended Bacterial Cell Sample with Unspecified CellType Field (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Solid Media Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Lysate Sample in Filter (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Biphasic Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Previously Extracted Plasmid DNA Sample in Ethanol (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Low Volume Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "High Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Previously Extracted Plasmid DNA Sample in 10mL Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Previously Extracted Plasmid DNA Sample in Filter Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Sample, "Low Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 1 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 2 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 3 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 4 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 5 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 6 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, Filter, "Test Plate 7 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 8 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 9 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 10 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 11 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 12 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 13 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, Filter, "Test Plate 14 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 15 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
      Object[Method, Extraction, PlasmidDNA, "PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
      Object[Method, Extraction, PlasmidDNA, "Invalid PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Model[Molecule, Oligomer, "Test Plasmid DNA 0 (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Suspended Bacterial Cell Sample with Unspecified CellType Field (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Solid Media Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Lysate Sample in Filter (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Biphasic Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Previously Extracted Plasmid DNA Sample in Ethanol (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Low Volume Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "High Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Previously Extracted Plasmid DNA Sample in 10mL Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Previously Extracted Plasmid DNA Sample in Filter Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Sample, "Low Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 1 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 2 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 3 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 4 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 5 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 6 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, Filter, "Test Plate 7 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 8 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 9 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 10 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 11 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 12 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 13 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, Filter, "Test Plate 14 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 15 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
          Object[Method, Extraction, PlasmidDNA, "PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
          Object[Method, Extraction, PlasmidDNA, "Invalid PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
        },
        existsFilter
      ],
      Force -> True,
      Verbose -> False
    ];

    {oligomer0} = {UploadOligomer[
      ToStrand["ATATTATTCTAAGGCGTTACCCCAATGGATTTCCGTCGGAATTGCTATAGCCCTTGAACGCTACATGCACGATACCAAGTTATGTATGGACCGGGTCATCAATAGGTTATAGCCTTGTAGTTAACATGTAGCCCGGCCCTATTAGTACAGTAGTGCCTTCATCGGCATTCTGTTTATTAAGTTTTTTCTACAGCAAAACGATCAAGTGCACTTCCACAGAGCGCGGTAGAGACTCATCCACCCGGCAGCTCTGTAATAGGGACTAAAAAAGTGATGATAATCATGAGTGCCGCGTTATGGTGGTGTCGGATCAGAGCGGTCTTACGACCAGTCGTATGCCTTCTCGAGTTCCGTCCGGTTAAGCGTGACAGTCCCAGTGAACCCACAAACCGTGATGGCTGTCCTTGGAGTCATACGCAAGAAGGATGGTCTCCAGACACCGGCGCACCAGTTTTCACGCCGAAAGCATAAACGACGAGCACATATGAGAGTGTTAGAACTGGACGTGCGGTTTCTCTGCGAAGAACACCTCGAGCTGTTGCGTTGTTGCGCTGCCTAGATGCAGTGTCGCACATATCACTTTTGCTTCAACGACTGCCGCTTTCGCTGTATCCCTAGACAGTCAACAGTAAGCGCTTTTTGTAGGCAGGGGCTCCCCCTGTGACTAACTGCGCCAAAACATCTTCGGATCCCCTTGTCCAATCTAACTCACCGAATTCTTACATTTTAGACCCTAATATCACATCATTAGAGATTAATTGCCACTGCCAAAATTCTGTCCACAAGCGTTTTAGTTCGCCCCAGTAAAGTTGTCTATAACGACTACCAAATCCGCATGTTACGGGACTTCTTATTAATTCTTTTTTCGTGAGGAGCAGCGGATCTTAATGGATGGCCGCAGGTGGTATGGAAGCTAATAGCGCGGGTGAGAGGGTAATCAGCCGTGTCCACCAACACAACGCTATCGGGCGATTCTATAAGATTCCGCATTGCGTCTACT"],
      DNA,
      "Test Plasmid DNA 0 (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
      PolymerType -> DNA
    ]
    };

    {plate0, plate1, plate2, plate3, plate4, plate5, plate6, plate7, plate8, plate9, plate10, plate11, plate12, plate13, plate14, plate15} = Upload[{
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 1 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 2 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 3 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 4 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 5 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 6 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate, Filter],
        Model -> Link[Model[Container, Plate, Filter, "Oasis PRiME HLB 96-well Filter Plate"], Objects],
        Name -> "Test Plate 7 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 8 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 9 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 10 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"], Objects],
        Name -> "Test Plate 11 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 12 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"], Objects],
        Name -> "Test Plate 13 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate, Filter],
        Model -> Link[Model[Container, Plate, Filter, "Oasis PRiME HLB 96-well Filter Plate"], Objects],
        Name -> "Test Plate 14 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 15 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>
    }];

    {tube0} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
        {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
        {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
        {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
        {{10^10 EmeraldCell / Milliliter, Model[Cell, Mammalian, "HEK293"]}},
        {{100 VolumePercent, Model[Lysate, "Simple Western Control HeLa Lysate"]}},
        {{100 VolumePercent, Model[Lysate, "Simple Western Control HeLa Lysate"]}},
        {{95 VolumePercent, Model[Molecule, "Water"]
        }, {5 VolumePercent, oligomer0}},
        {{45 VolumePercent, Model[Molecule, "Ethyl acetate"]
        }, {50 VolumePercent, Model[Molecule, "Water"]
        }, {5 VolumePercent, oligomer0}},
        {{95 VolumePercent, Model[Molecule, "Ethanol"]
        }, {5 VolumePercent, oligomer0}},
        {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
        {{95 VolumePercent, Model[Molecule, "Water"]
        }, {5 VolumePercent, oligomer0}},
        {{95 VolumePercent, Model[Molecule, "Water"]
        }, {5 VolumePercent, oligomer0}},
        {{95 VolumePercent, Model[Molecule, "Water"]
        }, {5 VolumePercent, oligomer0}},
        {{95 VolumePercent, Model[Molecule, "Water"]
        }, {5 VolumePercent, oligomer0}},
        {{95 VolumePercent, Model[Molecule, "Water"]
        }, {5 VolumePercent, oligomer0}}
      },
      {
        {"A1", plate0},
        {"A1", plate1},
        {"A1", plate2},
        {"A1", plate3},
        {"A1", plate4},
        {"A1", plate5},
        {"A1", plate6},
        {"B3", plate7},
        {"A1", plate8},
        {"A1", plate9},
        {"A1", plate10},
        {"A1", plate11},
        {"A1", plate12},
        {"A1", tube0},
        {"A1", plate13},
        {"B3", plate14},
        {"A1", plate15}
      },
      Name -> {
        "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Suspended Bacterial Cell Sample with Unspecified CellType Field (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Solid Media Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Lysate Sample in Filter (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Biphasic Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Previously Extracted Plasmid DNA Sample in Ethanol (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Low Volume Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "High Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Previously Extracted Plasmid DNA Sample in 10mL Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Previously Extracted Plasmid DNA Sample in Filter Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
        "Low Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID
      },
      InitialAmount -> {
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        10.0 Microliter,
        1.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        0.2 Milliliter,
        20.0 Microliter
      },
      CellType -> {
        Bacterial,
        Null,
        Bacterial,
        Mammalian,
        Mammalian,
        Mammalian,
        Null,
        Null,
        Null,
        Null,
        Null,
        Bacterial,
        Null,
        Null,
        Null,
        Null,
        Null
      },
      CultureAdhesion -> {
        Suspension,
        Suspension,
        SolidMedia,
        Adherent,
        Suspension,
        Suspension,
        Null,
        Null,
        Null,
        Null,
        Null,
        Suspension,
        Null,
        Null,
        Null,
        Null,
        Null
      },
      Living -> {
        True,
        True,
        True,
        True,
        True,
        True,
        False,
        False,
        False,
        False,
        False,
        True,
        False,
        False,
        False,
        False,
        False
      },
      State -> Liquid,
      StorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
      FastTrack -> True
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16}];

    {method0, method1} = Upload[
      {
        <|
          Type -> Object[Method, Extraction, PlasmidDNA],
          Name -> "PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
          NumberOfLysisSteps -> 1,
          NeutralizationSettlingTime -> 10 Minute,
          NumberOfLiquidLiquidExtractions -> 1,
          PrecipitationNumberOfWashes -> 1,
          NumberOfMagneticBeadSeparationWashes -> 1,
          SolidPhaseExtractionElutionTime -> 2 Minute,
          Lyse -> True,
          Neutralize -> True,
          Purification -> {LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, MagneticBeadSeparation},
          DeveloperObject -> True
        |>,
        <|
          Type -> Object[Method, Extraction, PlasmidDNA],
          Name -> "Invalid PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID,
          Lyse -> True,
          Purification -> None,
          DeveloperObject -> True
        |>
      }
    ];

    (*Upload additional fields to the set up objects.*)
    Map[
      Upload[{
        <|
          Object -> #,
          Append[Analytes] -> Link[oligomer0]
        |>
      }]&,
      {sample6, sample7, sample8, sample9, sample10, sample12, sample13, sample14, sample15, sample16}
    ];

  ],
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Model[Molecule, Oligomer, "Test Plasmid DNA 0 (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Suspended Bacterial Cell Sample with Unspecified CellType Field (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Solid Media Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Adherent Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Suspended Mammalian Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Suspended Mammalian Cell Sample with Cell Concentration Info (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Lysate Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Lysate Sample in Filter (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Biphasic Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Previously Extracted Plasmid DNA Sample in Ethanol (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Low Volume Suspended Bacterial Cell Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "High Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 50mL Tube (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Previously Extracted Plasmid DNA Sample in 10mL Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Previously Extracted Plasmid DNA Sample in Filter Plate (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Sample, "Low Volume Previously Extracted Plasmid DNA Sample (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 1 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 2 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 3 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 4 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 5 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 6 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, Filter, "Test Plate 7 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 8 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 9 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 10 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 11 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 12 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 13 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, Filter, "Test Plate 14 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 15 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentExtractPlasmidDNA " <> $SessionUUID],
        Object[Method, Extraction, PlasmidDNA, "PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID],
        Object[Method, Extraction, PlasmidDNA, "Invalid PlasmidDNA Method (Test for ExperimentExtractPlasmidDNA) " <> $SessionUUID]
      }], ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter = DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ]];
    ]
  ),
  Skip -> "Skipping temporarily until implemented in lab due to high resource requirement for testing."
];


(* ::Subsubsection::Closed:: *)
(*ExtractPlasmidDNA*)

DefineTests[ExtractPlasmidDNA,
  {

    Example[{Basic, "Form an ExtractPlasmidDNA unit operation:"},
      ExtractPlasmidDNA[
        Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID]
      ],
      _ExtractPlasmidDNA
    ],

    Example[{Basic, "A RoboticCellPreparation protocol is generated when calling ExtractPlasmidDNA:"},
      ExperimentRoboticCellPreparation[
        {
          ExtractPlasmidDNA[
            Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 3200
    ](*,

    (* TODO::Determine why labeling not working for extracted plasmid DNA sample. *)
    Example[{Basic,"A RoboticCellPreparation protocol is generated when calling ExtractPlasmidDNA preceded and followed by other unit operations:"},
      ExperimentRoboticCellPreparation[
        {
          Mix[
            Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID]
          ],
          ExtractPlasmidDNA[
            Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID],
            ExtractedPlasmidDNALabel -> "Extracted Plasmid DNA Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID
          ],
          Transfer[
            Source -> "Extracted Plasmid DNA Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID,
            Amount -> All,
            Destination -> Model[Container, Vessel, "50mL Tube"]
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],
      TimeConstraint -> 3200
    ]*)

  },
  SymbolSetUp :> Module[{existsFilter, plate1, sample1},
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter = DatabaseMemberQ[{
      Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 1 for ExtractPlasmidDNA " <> $SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 1 for ExtractPlasmidDNA " <> $SessionUUID]
        },
        existsFilter
      ],
      Force -> True,
      Verbose -> False
    ];

    plate1 = Upload[
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test Plate 1 for ExtractPlasmidDNA " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>
    ];

    (* Create some samples for testing purposes *)
    sample1 = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
      {"A1", plate1},
      Name -> "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID,
      InitialAmount -> 0.2 Milliliter,
      CellType -> Bacterial,
      CultureAdhesion -> Suspension,
      Living -> True,
      State -> Liquid,
      StorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
      FastTrack -> True
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample1}];

  ],
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractPlasmidDNA) " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 1 for ExtractPlasmidDNA " <> $SessionUUID]
      }], ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter = DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ]];
    ]
  ),
  Skip -> "Skipping temporarily until implemented in lab due to high resource requirement for testing."
];

