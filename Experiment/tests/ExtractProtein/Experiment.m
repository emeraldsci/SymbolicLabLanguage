(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*ExperimentExtractProtein Tests*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentExtractProtein*)

DefineTests[ExperimentExtractProtein,
  {
    (* Basic examples *)
    Example[{Basic,"Living cells are lysed to isolate total protein from the cell without purification:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification->None,
        Output->{Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,
            TargetProtein->All
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    Example[{Basic,"Multiple cell samples and types can undergo protein extraction in one experiment call:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample "<>$SessionUUID]
        },
        Purification->None,
        Output->{Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,
            RoboticInstrument->ObjectP[Model[Instrument, LiquidHandler, "microbioSTAR"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Basic,"Lysate samples can be further purified using the rudimentary purification steps from protein extraction:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Lysate Sample "<>$SessionUUID]
        },
        Purification -> {SolidPhaseExtraction},
        Output->{Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> False,
            Purification ->{SolidPhaseExtraction},
            SolidPhaseExtractionStrategy -> Positive
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Basic,"Crude protein samples can be further purified using the rudimentary purification steps from protein extraction:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        Purification -> {MagneticBeadSeparation},
        Output->{Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> False,
            Purification ->{MagneticBeadSeparation},
            MagneticBeadSeparationMode -> IonExchange
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* Options *)

    (* - General Options - *)
    Example[{Options,{RoboticInstrument,WorkCell}, "If input cells are only Mammalian, then the bioSTAR liquid handler is used as the robotic instrument and work cell for the extraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample "<>$SessionUUID],
        Purification->None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "bioSTAR"]],
            WorkCell -> bioSTAR
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,{RoboticInstrument,WorkCell}, "If input cells have anything other than just Mammalian cells (Microbial or Yeast), then the microbioSTAR liquid handler is used as the robotic instrument and work cell for the extraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification->None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "microbioSTAR"]],
            WorkCell -> microbioSTAR
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    Example[{Options, {ContainerOut,ExtractedProteinLabel,ExtractedProteinContainerLabel}, "ContainerOut, ExtractedProteinLabel, and ExtractedProteinContainerLabel can be specified to collect the sample and label the sample and container of the last step of the extraction unless otherwise specified:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        ContainerOut -> Object[Container,Plate,"ExperimentExtractProtein test 96-well plate 12"<>$SessionUUID],
        ExtractedProteinLabel -> "My Favorite Protein Soup",
        ExtractedProteinContainerLabel -> "My Favorite Protein Soup Bowl",
        ClarifyLysate->True,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ContainerOut -> ObjectP[Object[Container, Plate, "ExperimentExtractProtein test 96-well plate 12" <> $SessionUUID]],
          ClarifiedLysateContainer -> ObjectP[Object[Container, Plate, "ExperimentExtractProtein test 96-well plate 12" <> $SessionUUID]],
          ExtractedProteinLabel -> "My Favorite Protein Soup",
          ExtractedProteinContainerLabel -> "My Favorite Protein Soup Bowl"
        }]
      },
      TimeConstraint -> 1800
    ],

    Example[{Options,TargetProtein, "If TargetProtein is All and no options related to purification steps are specified,  Purification is set to {Precipitation}:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->All,
        LysisSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            TargetProtein -> All,
            Purification -> {Precipitation}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    Example[{Options,TargetProtein, "If TargetProtein is a Model[Molecule] and no options related to purification steps are specified by user or the method, Purification is set to {SolidPhaseExtraction}:"},
      (*Need to quiet this function call as there are a lot of volume related messages, but we want to make sure the purification is resolved to SPE without specifying any SPE options*)
      Quiet[ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->Model[Molecule,Protein,"ExperimentExtractProtein test protein "<> $SessionUUID],
        Method->Custom,
        Output -> Options
      ]],
      KeyValuePattern[
        {
          TargetProtein -> {ObjectP[Model[Molecule, Protein]]},
          Purification -> {{SolidPhaseExtraction}}
        }
      ],
      TimeConstraint -> 1800
    ],
    (*Method*)
    Example[{Options, Method, "A Method can be specified, which contains a pre-set protocol for protein extraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Object[Method, Extraction, Protein, "ExperimentExtractProtein Test Method for Microbial Cells "<>$SessionUUID],
        LysisSolutionVolume -> 300 Microliter,
        MagneticBeadSeparationSampleVolume -> 20 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          Method -> ObjectP[Object[Method, Extraction, Protein, "ExperimentExtractProtein Test Method for Microbial Cells " <> $SessionUUID]],
          TargetProtein -> ObjectP[Model[Molecule, Protein, "ExperimentExtractProtein test protein " <> $SessionUUID]],
          CellType -> Bacterial
        }]
      },
      TimeConstraint -> 1200
    ],

    Example[{Options, Method, "If Method is not specified by the user, a default Method for the TargetProtein is set:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->Model[Molecule,Protein,"ExperimentExtractProtein test protein "<> $SessionUUID],
        LysisSolutionVolume -> 300 Microliter,
        MagneticBeadSeparationSampleVolume -> 20 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          Method -> ObjectP[Object[Method, Extraction, Protein]]
        }]
      },
      Stubs :> {
        Search[Object[Method,Extraction,Protein]] = {
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Test Method for Microbial Cells " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Test Method for Microbial Cells All Proteins " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 1 " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 2 " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 3 " <> $SessionUUID]
        }
      },
      TimeConstraint -> 1200
    ],
    Example[{Options, Method, "If Method is not specified by the user, a default Method for the TargetProtein is set:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        TargetProtein-> All,
        SolidPhaseExtractionLoadingSampleVolume -> 50 Microliter,
        SolidPhaseExtractionElutionSolutionVolume -> 20 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          Method -> ObjectP[Object[Method, Extraction, Protein]]
        }]
      },
      Stubs :> {
        Search[Object[Method,Extraction,Protein]] = {
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Test Method for Microbial Cells " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Test Method for Microbial Cells All Proteins " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 1 " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 2 " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 3 " <> $SessionUUID]
        }
      },
      TimeConstraint -> 1200
    ],
    (* - Purification Option - *)

    Example[{Options,Purification, "If any liquid-liquid extraction options are set, then a liquid-liquid extraction will be added to the list of purification steps:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Method->Custom,
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
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If any precipitation options are set, then precipitation will be added to the list of purification steps:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        PrecipitationSeparationTechnique -> Filter,
        Method->Custom,
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
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If any solid phase extraction options are set, then a solid phase extraction will be added to the list of purification steps:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        SolidPhaseExtractionTechnique -> Pressure,
        Method->Custom,
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
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If any magnetic bead separation options are set, then a magnetic bead separation will be added to the list of purification steps:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MagneticBeadSeparationElutionMixTime -> 5*Minute,
        Method->Custom,
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
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If options from multiple purification steps are specified, then they will be added to the purification step list in the order liquid-liquid extraction, precipitation, solid phase extraction, then magnetic bead separation:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MagneticBeadSeparationElutionMixTime -> 5*Minute,
        SolidPhaseExtractionTechnique -> Pressure,
        PrecipitationSeparationTechnique -> Filter,
        LiquidLiquidExtractionTechnique -> Pipette,
        Method->Custom,
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
      TimeConstraint -> 1200
    ],

    (* Messages tests *)

    (* - General Errors and Warnings - *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentExtractProtein[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentExtractProtein[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentExtractProtein[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentExtractProtein[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Plate,"96-well 2mL Deep Well Plate"],
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
          Simulation -> simulationToPassIn,
          InitialAmount -> 0.2 Milliliter,
          CellType -> Bacterial,
          CultureAdhesion -> Suspension,Living -> True,
          State -> Liquid,
          StorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"] (*Model[StorageCondition, "Refrigerator"]*)
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentExtractProtein[sampleID, Purification->None, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule},
      TimeConstraint -> 1800
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Plate,"96-well 2mL Deep Well Plate"],
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
          Simulation -> simulationToPassIn,
          InitialAmount -> 0.2 Milliliter,
          CellType -> Bacterial,
          CultureAdhesion -> Suspension,Living -> True,
          State -> Liquid,
          StorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"] (*Model[StorageCondition, "Refrigerator"]*)
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentExtractProtein[containerID, Purification->None, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule},
      TimeConstraint -> 1800
    ],
    Example[{Messages,"MethodTargetProteinMismatch","Return a warning if the specified method conflicts with the specified target protein:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein -> All,
        LysisSolutionVolume -> 200 Microliter,
        MagneticBeadSeparationSampleVolume -> 20 Microliter,
        Method -> Object[Method, Extraction, Protein, "ExperimentExtractProtein Test Method for Microbial Cells " <> $SessionUUID],
        Output -> Options
      ],
      KeyValuePattern[
        {
          TargetProtein -> All,
          Method -> ObjectP[Object[Method]],
          SecondaryLysisSolution -> ObjectP[Model[Sample, "Milli-Q water"]]
        }
      ],
      Messages:>{
        Warning::MethodTargetProteinMismatch,
        Warning::TargetPurificationMismatch(*It is anticipitated to be thrown together because if the method is not for the protein it is highly likely that the Purification is not for the target protein*)
      },
      TimeConstraint -> 1200
    ],
    Example[{Messages,"NullTargetProtein","A warning is returned if the target protein is set to Null while Purification is set to be resolved automatically:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->Null,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages:>{
        Warning::NullTargetProtein
      },
      TimeConstraint -> 1800
    ],

    (* - Input Errors - *)

    Example[{Messages,"InvalidSolidMediaSample","An error is returned if the input cell samples are in solid media since only suspended or adherent cells are supported for protein extraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Solid Media Cell Sample "<>$SessionUUID],
        Purification->None,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::InvalidSolidMediaSample,
        Error::InvalidInput
      },
      TimeConstraint -> 1800
    ],

    (* - Lysis Errors - *)

    Example[{Messages,"ConflictingLysisOutputOptions","An error is returned if the last step of the extraction is lysis, but the ouput options do not match their counterparts in the lysis options:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Lyse -> True,
        ClarifyLysate -> True,
        ClarifiedLysateContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        Purification -> None,
        ContainerOut -> Model[Container, Vessel, "50mL Tube"],
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::ConflictingLysisOutputOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"ConflictingLysisStepSolutionEquilibration","An error is returned if the lysis solution equilibration time or temperature options is in conflict with lysis procedure indicated by Lyse or NumberOfLysisSteps, e.g. LysisSolutionTemperature is set but Lyse is set to False:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Method -> Custom,
        Lyse -> False,
        LysisSolutionTemperature -> 4 Celsius,
        Purification -> {MagneticBeadSeparation},
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::ConflictingLysisStepSolutionEquilibration,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"ConflictingLysisStepSolutionEquilibration","An error is returned if the lysis solution equilibration time or temperature options is in conflict with lysis procedure indicated by Lyse or NumberOfLysisSteps, e.g. TertiaryLysisSolutionEquilibrationTime is set but NumberOfLysisSteps is set to 2:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        NumberOfLysisSteps -> 2,
        TertiaryLysisSolutionEquilibrationTime -> 5 Minute,
        TertiaryLysisSolutionTemperature -> 4 Celsius,
        Purification -> None,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::ConflictingLysisStepSolutionEquilibration,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"LysisSolutionEquilibrationTimeTemperatureMismatch","An error is returned if the lysis solution equilibration time and temperature options are mismatched, e.g. temperature is Null but equilibration time is a valid duration of time:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        LysisSolutionEquilibrationTime -> 5 Minute,
        LysisSolutionTemperature -> Null,
        Purification -> None,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::LysisSolutionEquilibrationTimeTemperatureMismatch,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"LysisSolutionEquilibrationTimeTemperatureMismatch","An error is returned if the lysis solution equilibration time and temperature options are mismatched, e.g. equilibration time is Null but temperature is a non-ambient temperature:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        SecondaryLysisSolutionEquilibrationTime -> Null,
        SecondaryLysisSolutionTemperature -> 4 Celsius,
        Purification -> None,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::LysisSolutionEquilibrationTimeTemperatureMismatch,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],

    (* - Purification Errors - *)

    Example[{Messages,"NoProteinExtractionStepsSet","An error is returned if no steps are selected for an extraction (neither lysis nor any purification techniques):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Method -> Custom,
        Lyse -> False,
        Purification -> None,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::NoExtractProteinStepsSet,Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"TargetPurificationMismatch","A warning is returned if the isolation of specified  target protein cannot be achieved by the specified Purification options, e.g. target protein is All, but purification using solid phase extraction or magnetic bead separation with separation mode of affinity is called:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        TargetProtein->All,
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionSeparationMode -> Affinity,
        Method -> Custom,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages:>{
        Warning::TargetPurificationMismatch
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"TargetPurificationMismatch","A warning is returned if the isolation of specified  target protein cannot be achieved by the specified Purification options, e.g. target protein is a Model[Molecule], but purification using solid phase extraction or magnetic bead separation with separation mode of affinity is not called:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        TargetProtein->Model[Molecule,Protein,"ExperimentExtractProtein test protein "<> $SessionUUID],
        Purification -> {LiquidLiquidExtraction,MagneticBeadSeparation},
        MagneticBeadSeparationMode -> IonExchange,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages:>{
        Warning::TargetPurificationMismatch
      },
      TimeConstraint -> 1800
    ],

    (* - Lyse Options - *)

    (* -- General Lysis options -- *)

    (*Test case: Lyse is off because input is lysed*)
    Example[{Options,{Lyse,LysisSolutionTemperature,LysisSolutionEquilibrationTime,SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime,TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime}, "If the input is lysate or crude protein solution, it will not be lysed (since it is already lysed or does not require lysing). LysisAliquot,PreLysisPellet,PreLysisDilute,NumberOfLysisSteps,ClarifyLysate are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Method -> Custom,
        Purification ->{SolidPhaseExtraction},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> False,
            LysisAliquot -> Null,
            PreLysisPellet -> Null,
            PreLysisDilute -> Null,
            NumberOfLysisSteps -> Null,
            ClarifyLysate -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (*Test case: Lyse is on, high level switches are resolved based on options specified*)
    Example[{Options,{Lyse,LysisAliquot,PreLysisPellet,PreLysisDilute,NumberOfLysisSteps,ClarifyLysate}, "If the input is living cells, they will be lysed before purification. 1) If no aliquotting options are set (LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration), LysisAliquot is set to False. 2) If no pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to False. 3) If no neither PreLysisDiluent nor PreLysisDilutionVolume is set, PreLysisDilute is set to False. 4) Up to 3 steps of lysis steps can be performed. If no secondary or tertiary lysis options are set, NumberOfLysisSteps is set to 1. 5) If no clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to False:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        Purification->None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,
            LysisAliquot -> False,
            PreLysisPellet -> False,
            PreLysisDilute -> False,
            NumberOfLysisSteps -> 1,
            ClarifyLysate -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,{Lyse,LysisAliquot,PreLysisPellet,PreLysisDilute,NumberOfLysisSteps,ClarifyLysate}, "If the input is living cells, they will be lysed before purification. 1) If any aliquotting options are set (LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration), LysisAliquot is set to True. 2) If any pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to True. 3) If any of the PreLysisDiluent or PreLysisDilutionVolume is set, PreLysisDilute is set To True. 4) Up to 3 steps of lysis steps can be performed. If any secondary or tertiary lysis options are set, NumberOfLysisSteps is set to the highest number of steps for which an option is specified. 5) If any clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to True:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        LysisAliquotAmount -> 0.1 Milliliter,
        PreLysisPelletingTime -> 1 Minute,
        PreLysisDilutionVolume -> 0.2 Milliliter,
        TertiaryLysisTemperature -> Ambient,
        ClarifyLysateTime -> 1 Minute,
        Purification->None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,
            LysisAliquot -> True,
            PreLysisPellet -> True,
            PreLysisDilute -> True,
            NumberOfLysisSteps -> 3,
            ClarifyLysate -> True
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case:CellType and CultureAdhesion populated by the sample fields. Dissociate switch is resolved based on Culture Adhesion and LysisAliquot *)
    Example[{Options, {CellType,CultureAdhesion,Dissociate}, "CellType and CultureAdhesion are set based on the corresponding fields of the sample if they are specified. If CultureAdhesion is Adherent and LysisAliquot is True, then Dissociate is set to True:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        Method -> Custom,
        Lyse -> True,
        LysisAliquot -> True,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> Mammalian,
          CultureAdhesion -> Adherent,
          Dissociate -> True
        }]
      }
    ],
    Example[{Options, {CellType,CultureAdhesion,Dissociate}, "CellType and CultureAdhesion are set based on the corresponding fields of the sample if they are specified. If CultureAdhesion is Adherent and LysisAliquot is False, then Dissociate is set to False:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        Method -> Custom,
        Lyse -> True,
        LysisAliquot -> False,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> Mammalian,
          CultureAdhesion -> Adherent,
          Dissociate -> False
        }]
      }
    ],
    Example[{Options, {CellType,CultureAdhesion,Dissociate}, "CellType and CultureAdhesion are set based on the corresponding fields of the sample if they are specified. If CultureAdhesion is Suspension, then Dissociate is set to True:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
        },
        Method -> Custom,
        Lyse -> True,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> Mammalian,
          CultureAdhesion -> Suspension,
          Dissociate -> False
        }]
      }
    ],

    (* -- Lysis Aliquot Options -- *)

    (*Test Case: Lysis Aliquot is off. All of its options are resolved to Null*)
    Example[{Options, {LysisAliquotAmount, LysisAliquotContainer, LysisAliquotContainerLabel, TargetCellCount, TargetCellConcentration}, "If LysisAliquot is set to False. All LysisAliquot options are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        Method -> Custom,
        LysisAliquot -> False,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> Null,
          LysisAliquotContainer -> Null,
          LysisAliquotContainerLabel -> Null
        }]
      }
    ],
    (*Test Case: Lysis Aliquot is on. Its options are automatically resolved. *)
    Example[{Options, {LysisAliquotAmount, LysisAliquotContainer, LysisAliquotContainerLabel}, "If LysisAliquot is set to True and TargetCellCount or TargetCellConcentration is specified while LysisAliquotAmount is not, LysisAliquotAmount is automatically set to attain the target cell count. Unless otherwise specified, LysisAliquotContainer will be assigned by PackContainers, and LysisAliquotContainerLabel will be automatically generated:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        Method -> Custom,
        TargetCellCount -> 10^9 EmeraldCell,
        LysisAliquot -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.1 Milliliter],
          LysisAliquotContainer -> {(_Integer),ObjectP[Model[Container]]},
          LysisAliquotContainerLabel -> (_String)
        }]
      }
    ],
    Example[{Options, LysisAliquotAmount, "If LysisAliquot is set to True and none of the LysisAliquotAmount, TargetCellCount, TargetCellConcentration, or LysisAliquotContainer is specified, LysisAliquotAmount is automatically set to 25% of the input sample volume:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        Method -> Custom,
        LysisAliquot -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.05 Milliliter]
        }]
      }
    ],
    Example[{Options,LysisAliquotAmount, "If LysisAliquot is set to True and LysisAliquotContainer is specified while TargetCellCount is not specified, LysisAliquotAmount is automatically set to half of the LysisAliquotContiner's max volume if the input sample volume is greater than that value:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        Method -> Custom,
        LysisAliquot -> True,
        LysisAliquotContainer -> Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
        (* NOTE:Solution volume required to avoid low volume warning *)
        LysisSolutionVolume -> 150 Microliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[150 Microliter]
        }]
      }
    ],
    Example[{Options, LysisAliquotAmount, "If LysisAliquot is set to True and LysisAliquotContainer is specified while TargetCellCount is not specified, LysisAliquotAmount is automatically set to All if the input sample is less than half of the LysisAliquotContiner's max volume:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        Method -> Custom,
        LysisAliquot -> True,
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisAliquotAmount -> EqualP[0.2 Milliliter]
        }]
      }
    ],

    (* -- PreLysisPellet Options -- *)

    (*Test Case: PreLysisPellet is off. All of its options are resolved to Null*)
    Example[{Options, {PreLysisPellet,PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, PreLysisSupernatantContainer,PreLysisSupernatantLabel,PreLysisSupernatantContainerLabel}, "If PreLysisPellet is set to False, all PreLysisPellet options are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        Method -> Custom,
        PreLysisPellet -> False,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingCentrifuge -> Null,
          PreLysisPelletingIntensity -> Null,
          PreLysisPelletingTime -> Null,
          PreLysisSupernatantVolume -> Null,
          PreLysisSupernatantStorageCondition -> Null,
          PreLysisSupernatantContainer -> Null,
          PreLysisSupernatantLabel ->Null,
          PreLysisSupernatantContainerLabel -> Null
        }]
      }
    ],

    (*Test Case: PreLysisPellet is on. All of its options are resolved*)
    Example[{Options, {PreLysisPellet,PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, PreLysisSupernatantContainer}, "If PreLysisPellet is set to True, the PreLysisPellet options are resolved automatically. Unless otherwise specified, PreLysisPelletCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"], PreLysisPelletCentrifugeTime is automatically set to 10 minutes, PreLysisSupernatantVolume is automatically set to 80% of the of total volume, PreLysisSupernatantStorageCondition is automatically set to Disposal, PreLysisSupernatantContainer is automatically set by PackContainers, PreLysisSupernatantLabel and PreLysisSupernatantContainerLabel are automatically generated, and PreLysisPelletCentrifugeIntensity is automatically set to 1560 RPM for mamallian cells:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        Method -> Custom,
        PreLysisPellet -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
          PreLysisPelletingIntensity -> EqualP[1560 RPM],
          PreLysisPelletingTime -> EqualP[10 Minute],
          PreLysisSupernatantVolume -> EqualP[0.16 Milliliter],
          PreLysisSupernatantStorageCondition -> Disposal,
          PreLysisSupernatantContainer -> {(_Integer), ObjectP[Model[Container]]},
          PreLysisSupernatantLabel ->  (_String),
          PreLysisSupernatantContainerLabel -> (_String)
        }]
      }
    ],
    Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True, the PreLysisPellet options are resolved automatically. Unless otherwise specified, PreLysisPelletCentrifugeIntensity is automatically set to 4030 RPM for bacterial cells:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample " <>$SessionUUID]
        },
        Method -> Custom,
        PreLysisPellet -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> EqualP[4030 RPM]
        }]
      }
    ],

    (* -- PreLysisDilute Options -- *)
    (*Test Case: PreLysisDilute is off. All of its options are resolved to Null*)
    Example[{Options, {PreLysisDilute,PreLysisDiluent,PreLysisDilutionVolume}, "If PreLysisDilute is False, PreLysisDiluent and PreLysisDilutionVolume are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        Method -> Custom,
        PreLysisDilute -> False,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDiluent -> Null,
          PreLysisDilutionVolume -> Null
        }]
      }
    ],
    (*Test Case: PreLysisDilute is on. All of its options are resolved automatically*)
    Example[{Options, PreLysisDiluent, "If PreLysisDilute is set to True, PreLysisDiluent is automatically set to Model[Sample, StockSolution, \"1x PBS from 10X stock\"], PreLysisDilutionVolume is set to the volume required to attain the specified TargetCellConcentration:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        Method -> Custom,
        PreLysisDilute -> True,
        (* TargetCellConcentration added to avoid error for not having enough into to make PreLysisDilutionVolume *)
        TargetCellConcentration -> 5 * 10^9 EmeraldCell/Milliliter,
        LysisAliquot -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDiluent -> ObjectP[Model[Sample, StockSolution, "id:9RdZXv1KejGK"]], (* Model[Sample, StockSolution, "1x PBS from 10X stock, Alternative Preparation 1"] *)
          PreLysisDilutionVolume -> EqualP[0.05 Milliliter]
        }]
      }
    ],

    (* -- Lysis Steps Options -- *)
    (* --- Primary Lysis General Options ---*)
    (*Test case: NumberOfLysisSteps=1, secondary and tertiary lysis options are set to Null. primary lysis options are resolved Automatically in most default cases. *)
    Example[{Options,{LysisSolution,LysisSolutionVolume,LysisSolutionTemperature,LysisSolutionEquilibrationTime,LysisTime,LysisTemperature,LysisIncubationInstrument, SecondaryLysisSolution,SecondaryLysisSolutionVolume,
      SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime,SecondaryLysisTime,SecondaryLysisSolutionTemperature,SecondaryLysisIncubationInstrument,TertiaryLysisSolution,TertiaryLysisSolutionVolume,TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime,TertiaryLysisTemperature,TertiaryLysisTime,TertiaryLysisIncubationInstrument}, "If NumberOfLysisSteps is 1, secondary and tertiary lysis options are set to Null. Unless otherwise specified, 1)LysisSolution is automatically set to Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"] for mammalian cells; 2) if LysisAliquot is False, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps; 3) LysisSolutionEquilibrationTime is automatically set to 10 Minute if LysisSolutionTemperature is not Null; 4) LysisSolutionTemperature is automatically set to 4 Celsius; 5) LysisTime is automatically set to 15 minutes; 6) LysisTemperature is automatically set to Ambient; 7) LysisIncubationInstrument is automatically set to an integrated instrument compatible with the LysisTemperature:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID],
        Method -> Custom,
        LysisAliquot -> False,
        NumberOfLysisSteps -> 1,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            LysisSolution -> ObjectP[Model[Sample,StockSolution,"id:kEJ9mqJxqNLV"]], (*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
            LysisSolutionVolume -> EqualP[0.9 Milliliter],
            LysisSolutionTemperature -> EqualP[4 Celsius],
            LysisSolutionEquilibrationTime -> EqualP[10 Minute],
            LysisTime -> EqualP[15 Minute],
            LysisTemperature -> Ambient,
            LysisIncubationInstrument -> ObjectP[Model[Instrument]],

            SecondaryLysisSolution -> Null,
            SecondaryLysisSolutionVolume -> Null,
            SecondaryLysisSolutionTemperature -> Null,
            SecondaryLysisSolutionEquilibrationTime -> Null,
            SecondaryLysisTime -> Null,
            SecondaryLysisTemperature -> Null,
            SecondaryLysisIncubationInstrument -> Null,
            TertiaryLysisSolution -> Null,
            TertiaryLysisSolutionVolume -> Null,
            TertiaryLysisSolutionTemperature -> Null,
            TertiaryLysisSolutionEquilibrationTime -> Null,
            TertiaryLysisTemperature -> Null,
            TertiaryLysisTime -> Null,
            TertiaryLysisIncubationInstrument -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test case: NumberOfLysisSteps=1, more resolution cases.*)
    Example[{Options,{LysisSolution,LysisSolutionVolume,LysisSolutionTemperature,LysisSolutionEquilibrationTime}, "If NumberOfLysisSteps is 1, unless otherwise specified, 1)LysisSolution is automatically set to Model[Sample, \"B-PER Bacterial Protein Extraction Reagent\"] for bacterial cells; 2) If LysisAliquot is True and LysisAliquotContainer is not set, LysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps; 3) LysisSolutionEquilibrationTime is automatically set to Null if LysisSolutionTemperature is Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        CellType -> Bacterial,
        NumberOfLysisSteps -> 1,
        LysisAliquot -> True,
        LysisAliquotAmount -> 0.1 Milliliter,
        LysisSolutionTemperature -> Null,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            LysisSolution -> ObjectP[Model[Sample,"id:R8e1PjeVjwlK"]], (*"B-PER Bacterial Protein Extraction Reagent"*)
            LysisSolutionVolume -> EqualP[0.9 Milliliter],
            LysisSolutionTemperature -> Null,
            LysisSolutionEquilibrationTime -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test case: NumberOfLysisSteps=1, more resolution cases.*)
    Example[{Options,{LysisSolutionVolume,LysisSolutionTemperature,LysisSolutionEquilibrationTime}, "If NumberOfLysisSteps is 1, unless otherwise specified, 1) If LysisAliquotContainer is set, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps; 2) LysisSolutionTemperature is automatically set to Null if LysisSolutionEquilibrationTime is Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID],
        Method -> Custom,
        NumberOfLysisSteps -> 1,
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        LysisSolutionEquilibrationTime -> Null,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            LysisSolutionVolume -> EqualP[0.9 Milliliter],
            LysisSolutionTemperature -> Null,
            LysisSolutionEquilibrationTime -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- Primary Lysis Mix Options ---*)

    (*Test Case: LysisMixType is None to turn it off. *)
    Example[{Options, {LysisMixType,LysisMixRate,LysisMixTime, LysisMixTemperature, LysisMixInstrument, LysisMixVolume, NumberOfLysisMixes}, "If NumberOfLysisSteps is 1 and LysisMixType is set to None, all lysis mix options are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        NumberOfLysisSteps -> 1,
        LysisMixType -> None,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixRate -> Null,
          LysisMixTime -> Null,
          LysisMixTemperature -> Null,
          LysisMixInstrument -> Null,
          LysisMixVolume -> Null,
          NumberOfLysisMixes -> Null
        }]
      }
    ],

    (*Test case: NumberOfLysisSteps = 1, secondary and tertiary mix options are Null. mix type resovled to shake due to samples in plate, mix options are resolved to default. *)

    Example[{Options, {LysisMixType,LysisMixRate,LysisMixTime, LysisMixTemperature, LysisMixInstrument, LysisMixVolume, NumberOfLysisMixes, SecondaryLysisMixType, TertiaryLysisMixType}, "If NumberOfLysisSteps is 1, SecondaryLysisMixType and TertiaryLysisMixType are set to Null. Unless otherwise specified. LysisMixType is set to Shake if the sample is mixed in a plate. If LysisMixType is Shake, unless otherwise specified, 1) LysisMixRate is set to 200 RPM, 2) LysisMixTime is set to 1 Minute, 3) LysisMixTemperature is set to Ambient, 4) LysisMixInstrument is automatically set to an available shaking device compatible with the specified LysisMixRate and LysisMixTemperature, 5) LysisMixVolume and NumberOfLysisMixes are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        NumberOfLysisSteps -> 1,
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Shake,
          LysisMixRate -> EqualP[200 RPM],
          LysisMixTime -> EqualP[1 Minute],
          LysisMixTemperature -> Ambient,
          LysisMixInstrument -> ObjectP[Model[Instrument]],
          LysisMixVolume -> Null,
          NumberOfLysisMixes -> Null,
          SecondaryLysisMixType -> Null,
          TertiaryLysisMixType -> Null
        }]
      }
    ],
    (*Test Case: resolving to MixType of shake by specifying a shake-only option*)
    Example[{Options, LysisMixType, "If LysisMixRate, LysisMixTime, or LysisMixInstrument are specified, LysisMixType is automatically set to Shake:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        LysisMixTime -> 1 Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Shake
        }]
      }
    ],
    (*Test case: NumberOfLysisSteps = 1, secondary and tertiary mix options are Null. Primary mix options are resolved. *)
    Example[{Options, {LysisMixType,LysisMixRate,LysisMixTime, LysisMixTemperature, LysisMixInstrument, LysisMixVolume, NumberOfLysisMixes, SecondaryLysisMixType, TertiaryLysisMixType}, "If NumberOfLysisSteps is 1, SecondaryLysisMixType and TertiaryLysisMixType are set to Null. Unless otherwise specified, LysisMixType is set to Pipette if the sample is mixed in a tube. If LysisMixType is Pipette, unless otherwise specified, 1) NumberOfLysisMixes is set to 10, 2) LysisMixVolume is automatically set to 50% of the total solution volume, if 50% of the total solution volume is less than 970 microliters, 3) LysisMixRate, LysisMixTime, LysisMixTemperature, and LysisMixInstrument are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
        },
        NumberOfLysisSteps -> 1,
        LysisSolutionVolume -> 0.2 Milliliter,
        LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Pipette,
          LysisMixRate -> Null,
          LysisMixTime -> Null,
          LysisMixTemperature -> Null,
          LysisMixInstrument -> Null,
          LysisMixVolume -> EqualP[0.2 Milliliter],
          NumberOfLysisMixes -> 10,
          SecondaryLysisMixType -> Null,
          TertiaryLysisMixType -> Null
        }]
      }
    ],
    (*Test Case: resolving to MixType of Pipette by specifying a pipette-only option. Another case of LysisMixVolume resolution when LysisSolutionVolume is large. *)
    Example[{Options, {LysisMixType,LysisMixVolume}, "If LysisMixVolume or NumberOfLysisMixes are specified, LysisMixType is automatically set to Pipette. If LysisMixType -> Pipette and 50% of the total solution volume is greater than 970 microliters, LysisMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        NumberOfLysisMixes -> 5,
        LysisSolutionVolume -> 1.8 Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisMixType -> Pipette,
          LysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      }
    ],
    

    (* --- Secondary Lysis General Options ---*)

    (*Test case: NumberOfLysisSteps=2, tertiary lysis options are set to Null. Secondary lysis options are resolved Automatically in most default case.*)
    Example[{Options,{LysisSolution,LysisSolutionVolume,LysisSolutionTemperature,LysisSolutionEquilibrationTime,LysisTime,LysisTemperature,LysisIncubationInstrument, SecondaryLysisSolution,SecondaryLysisSolutionVolume,
      SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime,SecondaryLysisTime,SecondaryLysisSolutionTemperature,SecondaryLysisIncubationInstrument,TertiaryLysisSolution,TertiaryLysisSolutionVolume,TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime,TertiaryLysisTemperature,TertiaryLysisTime,TertiaryLysisIncubationInstrument}, "If NumberOfLysisSteps is 2, tertiary lysis options are set to Null. Primary lysis options are resolved similarly as when NumberOfLysisSteps is 1. Unless otherwise specified, 1) SecondaryLysisSolution is automatically set to the LysisSolution employed in the first lysis step; 2) if LysisAliquot is False, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps; 3) SecondaryLysisSolutionEquilibrationTime is automatically set to 10 Minute if SecondaryLysisSolutionTemperature is not Null; 4) SecondaryLysisSolutionTemperature is automatically set to 4 Celsius; 5) SecondaryLysisTime is automatically set to 15 minutes; 6) SecondaryLysisTemperature is automatically set to Ambient; 7) SecondaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the SecondaryLysisTemperature:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID],
        Method -> Custom,
        LysisAliquot -> False,
        NumberOfLysisSteps -> 2,
        LysisSolutionVolume -> 0.2 Milliliter,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            LysisSolution -> ObjectP[Model[Sample,StockSolution,"id:kEJ9mqJxqNLV"]], (*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
            LysisSolutionVolume -> EqualP[0.2 Milliliter],
            LysisSolutionTemperature -> EqualP[4 Celsius],
            LysisSolutionEquilibrationTime -> EqualP[10 Minute],
            LysisTime -> EqualP[15 Minute],
            LysisTemperature -> Ambient,
            LysisIncubationInstrument -> ObjectP[Model[Instrument]],

            SecondaryLysisSolution -> ObjectP[Model[Sample,StockSolution,"id:kEJ9mqJxqNLV"]], (*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
            SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter],
            SecondaryLysisSolutionTemperature -> EqualP[4 Celsius],
            SecondaryLysisSolutionEquilibrationTime -> EqualP[10 Minute],
            SecondaryLysisTime -> EqualP[15 Minute],
            SecondaryLysisTemperature -> Ambient,
            SecondaryLysisIncubationInstrument -> ObjectP[Model[Instrument]],

            TertiaryLysisSolution -> Null,
            TertiaryLysisSolutionVolume -> Null,
            TertiaryLysisSolutionTemperature -> Null,
            TertiaryLysisSolutionEquilibrationTime -> Null,
            TertiaryLysisTemperature -> Null,
            TertiaryLysisTime -> Null,
            TertiaryLysisIncubationInstrument -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test case: NumberOfLysisSteps=2, more resolution cases.*)
    Example[{Options,{SecondaryLysisSolution,SecondaryLysisSolutionVolume,SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime}, "If NumberOfLysisSteps is 2, unless otherwise specified, 1) If LysisAliquot is True and LysisAliquotContainer is not set, SecondaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps; 3) SecondaryLysisSolutionEquilibrationTime is automatically set to Null if SecondaryLysisSolutionTemperature is Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        NumberOfLysisSteps -> 2,
        LysisAliquot -> True,
        LysisAliquotAmount -> 0.1 Milliliter,
        SecondaryLysisSolutionTemperature -> Null,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            SecondaryLysisSolutionVolume -> EqualP[0.45 Milliliter],
            SecondaryLysisSolutionTemperature -> Null,
            SecondaryLysisSolutionEquilibrationTime -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test case: NumberOfLysisSteps=2, more resolution cases.*)
    Example[{Options,{SecondaryLysisSolutionVolume,SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime}, "If NumberOfLysisSteps is 2, unless otherwise specified, 1) If LysisAliquotContainer is set, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps; 2) SecondaryLysisSolutionTemperature is automatically set to Null if SecondaryLysisSolutionEquilibrationTime is Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID],
        Method -> Custom,
        NumberOfLysisSteps -> 2,
        LysisSolutionVolume -> 0.2 Milliliter,
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        SecondaryLysisSolutionEquilibrationTime -> Null,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter],
            SecondaryLysisSolutionTemperature -> Null,
            SecondaryLysisSolutionEquilibrationTime -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- Secondary Lysis Mix Options --- *)

    (*Test Case:  SecondaryLysisMixType is None to turn it off. *)
    Example[{Options, {SecondaryLysisMixType,SecondaryLysisMixRate,SecondaryLysisMixTime, SecondaryLysisMixTemperature, SecondaryLysisMixInstrument, SecondaryLysisMixVolume, SecondaryNumberOfLysisMixes}, "If SecondaryLysisMixType is set to None, all secondary lysis mix options are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        SecondaryLysisMixType -> None,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixRate -> Null,
          SecondaryLysisMixTime -> Null,
          SecondaryLysisMixTemperature -> Null,
          SecondaryLysisMixInstrument -> Null,
          SecondaryLysisMixVolume -> Null,
          SecondaryNumberOfLysisMixes -> Null
        }]
      }
    ],

    (*Test case: NumberOfLysisSteps = 2, tertiary mix options are Null. secondary mix type resovled to shake due to samples in plate, mix options are resolved to default. *)

    Example[{Options, {SecondaryLysisMixType,SecondaryLysisMixRate,SecondaryLysisMixTime, SecondaryLysisMixTemperature, SecondaryLysisMixInstrument, SecondaryLysisMixVolume, SecondaryNumberOfLysisMixes, TertiaryLysisMixType}, "If NumberOfLysisSteps is 2, TertiaryLysisMixType is set to Null. Unless otherwise specified. SecondaryLysisMixType is set to Shake if the sample is mixed in a plate. If SecondaryLysisMixType is Shake, unless otherwise specified, 1) SecondaryLysisMixRate is set to 200 RPM, 2) SecondaryLysisMixTime is set to 1 Minute, 3) SecondaryLysisMixTemperature is set to Ambient, 4) SecondaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified SecondaryLysisMixRate and SecondaryLysisMixTemperature, 5) SecondaryLysisMixVolume and SecondaryNumberOfLysisMixes are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Shake,
          SecondaryLysisMixRate -> EqualP[200 RPM],
          SecondaryLysisMixTime -> EqualP[1 Minute],
          SecondaryLysisMixTemperature -> Ambient,
          SecondaryLysisMixInstrument -> ObjectP[Model[Instrument]],
          SecondaryLysisMixVolume -> Null,
          SecondaryNumberOfLysisMixes -> Null,
          TertiaryLysisMixType -> Null
        }]
      }
    ],
    (*Test Case: resolving to MixType of shake by specifying a shake-only option*)
    Example[{Options, SecondaryLysisMixType, "If SecondaryLysisMixRate, SecondaryLysisMixTime, or SecondaryLysisMixInstrument are specified, SecondaryLysisMixType is automatically set to Shake:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        SecondaryLysisMixTime -> 1 Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Shake
        }]
      }
    ],
    (*Test case: NumberOfLysisSteps = 2, secondary and tertiary mix options are Null. Primary mix options are resolved. *)
    Example[{Options, {SecondaryLysisMixType,SecondaryLysisMixRate,SecondaryLysisMixTime, SecondaryLysisMixTemperature, SecondaryLysisMixInstrument, SecondaryLysisMixVolume,SecondaryNumberOfLysisMixes, TertiaryLysisMixType}, "If NumberOfLysisSteps is 2, TertiaryLysisMixType is set to Null. Unless otherwise specified, SecondaryLysisMixType is set to Pipette if the sample is mixed in a tube. If SecondaryLysisMixType is Pipette, unless otherwise specified, 1) SecondaryNumberOfLysisMixes is set to 10, 2) SecondaryLysisMixVolume is automatically set to 50% of the total solution volume, if 50% of the total solution volume is less than 970 microliters, 3) SecondaryLysisMixRate, SecondaryLysisMixTime, SecondaryLysisMixTemperature, and SecondaryLysisMixInstrument are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        LysisSolutionVolume -> 0.2 Milliliter,
        SecondaryLysisSolutionVolume -> 0.2 Milliliter,
        LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Pipette,
          SecondaryLysisMixRate -> Null,
          SecondaryLysisMixTime -> Null,
          SecondaryLysisMixTemperature -> Null,
          SecondaryLysisMixInstrument -> Null,
          SecondaryLysisMixVolume -> EqualP[0.3 Milliliter],
          SecondaryNumberOfLysisMixes -> 10,
          TertiaryLysisMixType -> Null
        }]
      }
    ],
    (*Test Case: resolving to MixType of Pipette by specifying a pipette-only option. Another case of SecondaryLysisMixVolume resolution when SecondaryLysisSolutionVolume is large. *)
    Example[{Options, {SecondaryLysisMixType,SecondaryLysisMixVolume}, "If SecondaryLysisMixVolume or SecondaryNumberOfLysisMixes are specified, SecondaryLysisMixType is automatically set to Pipette. If SecondaryLysisMixType -> Pipette and 50% of the total solution volume is greater than 970 microliters, SecondaryLysisMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        SecondaryNumberOfLysisMixes -> 5,
        LysisSolutionVolume -> 0.9 Milliliter,
        SecondaryLysisSolutionVolume -> 0.9 Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisMixType -> Pipette,
          SecondaryLysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      }
    ],

    (* --- Tertiary Lysis General Options ---*)
    (*Test case: NumberOfLysisSteps=3, tertiary lysis options are resolved Automatically in most default case.*)
    Example[{Options,{LysisSolution,LysisSolutionVolume,LysisSolutionTemperature,LysisSolutionEquilibrationTime,LysisTime,LysisTemperature,LysisIncubationInstrument, SecondaryLysisSolution,SecondaryLysisSolutionVolume,
      SecondaryLysisSolutionTemperature,SecondaryLysisSolutionEquilibrationTime,SecondaryLysisTime,SecondaryLysisSolutionTemperature,SecondaryLysisIncubationInstrument,TertiaryLysisSolution,TertiaryLysisSolutionVolume,TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime,TertiaryLysisTemperature,TertiaryLysisTime,TertiaryLysisIncubationInstrument}, "If NumberOfLysisSteps is 3, primary and secondary lysis options are resolved similarly as when NumberOfLysisSteps is 2. Unless otherwise specified, 1) TertiaryLysisSolution is automatically set to be the same as the SecondaryLysisSolution; 2) if LysisAliquot is False, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps; 3) TertiaryLysisSolutionEquilibrationTime is automatically set to 10 Minute if TertiaryLysisSolutionTemperature is not Null; 4) TertiaryLysisSolutionTemperature is automatically set to 4 Celsius; 5) TertiaryLysisTime is automatically set to 15 minutes; 6) TertiaryLysisTemperature is automatically set to Ambient; 7) TertiaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the TertiaryLysisTemperature:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID],
        Method -> Custom,
        LysisAliquot -> False,
        NumberOfLysisSteps -> 3,
        LysisSolutionVolume -> 0.3 Milliliter,
        SecondaryLysisSolutionVolume -> 0.3 Milliliter,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            LysisSolution -> ObjectP[Model[Sample,StockSolution,"id:kEJ9mqJxqNLV"]], (*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
            LysisSolutionVolume -> EqualP[0.3 Milliliter],
            LysisSolutionTemperature -> EqualP[4 Celsius],
            LysisSolutionEquilibrationTime -> EqualP[10 Minute],
            LysisTime -> EqualP[15 Minute],
            LysisTemperature -> Ambient,
            LysisIncubationInstrument -> ObjectP[Model[Instrument]],

            SecondaryLysisSolution -> ObjectP[Model[Sample,StockSolution,"id:kEJ9mqJxqNLV"]], (*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
            SecondaryLysisSolutionVolume -> EqualP[0.3 Milliliter],
            SecondaryLysisSolutionTemperature -> EqualP[4 Celsius],
            SecondaryLysisSolutionEquilibrationTime -> EqualP[10 Minute],
            SecondaryLysisTime -> EqualP[15 Minute],
            SecondaryLysisTemperature -> Ambient,
            SecondaryLysisIncubationInstrument -> ObjectP[Model[Instrument]],

            TertiaryLysisSolution -> ObjectP[Model[Sample,StockSolution,"id:kEJ9mqJxqNLV"]], (*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
            TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter],
            TertiaryLysisSolutionTemperature -> EqualP[4 Celsius],
            TertiaryLysisSolutionEquilibrationTime -> EqualP[10 Minute],
            TertiaryLysisTemperature -> Ambient,
            TertiaryLysisTime -> EqualP[15 Minute],
            TertiaryLysisIncubationInstrument -> ObjectP[Model[Instrument]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test case: NumberOfLysisSteps=3, more resolution cases.*)
    Example[{Options,{TertiaryLysisSolution,TertiaryLysisSolutionVolume,TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime}, "If NumberOfLysisSteps is 3, unless otherwise specified, 1) If LysisAliquot is True and LysisAliquotContainer is not set, TertiaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps; 3) TertiaryLysisSolutionEquilibrationTime is automatically set to Null if TertiaryLysisSolutionTemperature is Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Custom,
        NumberOfLysisSteps -> 3,
        LysisAliquot -> True,
        LysisAliquotAmount -> 0.1 Milliliter,
        TertiaryLysisSolutionTemperature -> Null,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            TertiaryLysisSolutionVolume -> EqualP[0.3 Milliliter],
            TertiaryLysisSolutionTemperature -> Null,
            TertiaryLysisSolutionEquilibrationTime -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test case: NumberOfLysisSteps=3, more resolution cases.*)
    Example[{Options,{TertiaryLysisSolutionVolume,TertiaryLysisSolutionTemperature,TertiaryLysisSolutionEquilibrationTime}, "If NumberOfLysisSteps is 3, unless otherwise specified, 1) If LysisAliquotContainer is set, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps; 2) TertiaryLysisSolutionTemperature is automatically set to Null if TertiaryLysisSolutionEquilibrationTime is Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID],
        Method -> Custom,
        NumberOfLysisSteps -> 3,
        LysisSolutionVolume -> 0.3 Milliliter,
        SecondaryLysisSolutionVolume -> 0.3 Milliliter,
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        TertiaryLysisSolutionEquilibrationTime -> Null,
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Lyse -> True,

            TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter],
            TertiaryLysisSolutionTemperature -> Null,
            TertiaryLysisSolutionEquilibrationTime -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- Tertiary Lysis Mix Options --- *)

    (*Test Case:  TertiaryLysisMixType is None to turn it off. *)
    Example[{Options, {TertiaryLysisMixType,TertiaryLysisMixRate,TertiaryLysisMixTime, TertiaryLysisMixTemperature, TertiaryLysisMixInstrument, TertiaryLysisMixVolume, TertiaryNumberOfLysisMixes}, "If TertiaryLysisMixType is set to None, all tertiary lysis mix options are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        TertiaryLysisMixType -> None,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixRate -> Null,
          TertiaryLysisMixTime -> Null,
          TertiaryLysisMixTemperature -> Null,
          TertiaryLysisMixInstrument -> Null,
          TertiaryLysisMixVolume -> Null,
          TertiaryNumberOfLysisMixes -> Null
        }]
      }
    ],

    (*Test case: NumberOfLysisSteps = 3, tertiary mix type resovled to shake due to samples in plate, tertiary mix options are resolved to default. *)

    Example[{Options, {TertiaryLysisMixType,TertiaryLysisMixRate,TertiaryLysisMixTime, TertiaryLysisMixTemperature, TertiaryLysisMixInstrument, TertiaryLysisMixVolume, TertiaryNumberOfLysisMixes}, "If NumberOfLysisSteps is 3, TertiaryLysisMixType is set to Shake if the sample is mixed in a plate. If TertiaryLysisMixType is Shake, unless otherwise specified, 1) TertiaryLysisMixRate is set to 200 RPM, 2) TertiaryLysisMixTime is set to 1 Minute, 3) TertiaryLysisMixTemperature is set to Ambient, 4) TertiaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified TertiaryLysisMixRate and TertiaryLysisMixTemperature, 5) TertiaryLysisMixVolume and TertiaryNumberOfLysisMixes are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Shake,
          TertiaryLysisMixRate -> EqualP[200 RPM],
          TertiaryLysisMixTime -> EqualP[1 Minute],
          TertiaryLysisMixTemperature -> Ambient,
          TertiaryLysisMixInstrument -> ObjectP[Model[Instrument]],
          TertiaryLysisMixVolume -> Null,
          TertiaryNumberOfLysisMixes -> Null
        }]
      }
    ],
    (*Test Case: resolving to MixType of shake by specifying a shake-only option*)
    Example[{Options, TertiaryLysisMixType, "If TertiaryLysisMixRate, TertiaryLysisMixTime, or TertiaryLysisMixInstrument are specified, TertiaryLysisMixType is automatically set to Shake:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        TertiaryLysisMixTime -> 1 Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Shake
        }]
      }
    ],
    (*Test case: NumberOfLysisSteps = 3, tertiary and tertiary mix options are Null. Primary mix options are resolved. *)
    Example[{Options, {TertiaryLysisMixType,TertiaryLysisMixRate,TertiaryLysisMixTime, TertiaryLysisMixTemperature, TertiaryLysisMixInstrument, TertiaryLysisMixVolume,TertiaryNumberOfLysisMixes}, "If NumberOfLysisSteps is 3, TertiaryLysisMixType is set to Pipette if the sample is mixed in a tube. If TertiaryLysisMixType is Pipette, unless otherwise specified, 1) TertiaryNumberOfLysisMixes is set to 10, 2) TertiaryLysisMixVolume is automatically set to 50% of the total solution volume, if 50% of the total solution volume is less than 970 microliters, 3) TertiaryLysisMixRate, TertiaryLysisMixTime, TertiaryLysisMixTemperature, and TertiaryLysisMixInstrument are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        LysisSolutionVolume -> 0.2 Milliliter,
        SecondaryLysisSolutionVolume -> 0.2 Milliliter,
        TertiaryLysisSolutionVolume -> 0.2 Milliliter,
        LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Pipette,
          TertiaryLysisMixRate -> Null,
          TertiaryLysisMixTime -> Null,
          TertiaryLysisMixTemperature -> Null,
          TertiaryLysisMixInstrument -> Null,
          TertiaryLysisMixVolume -> EqualP[0.4 Milliliter],
          TertiaryNumberOfLysisMixes -> 10
        }]
      }
    ],
    (*Test Case: resolving to MixType of Pipette by specifying a pipette-only option. Another case of TertiaryLysisMixVolume resolution when TertiaryLysisSolutionVolume is large. *)
    Example[{Options, {TertiaryLysisMixType,TertiaryLysisMixVolume}, "If TertiaryLysisMixVolume or TertiaryNumberOfLysisMixes are specified, TertiaryLysisMixType is automatically set to Pipette. If TertiaryLysisMixType -> Pipette and 50% of the total solution volume is greater than 970 microliters, TertiaryLysisMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        TertiaryNumberOfLysisMixes -> 5,
        LysisSolutionVolume -> 0.6 Milliliter,
        SecondaryLysisSolutionVolume -> 0.6 Milliliter,
        TertiaryLysisSolutionVolume -> 0.6 Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisMixType -> Pipette,
          TertiaryLysisMixVolume -> EqualP[0.970 Milliliter]
        }]
      }
    ],

    (* -- ClarifyLysate Options -- *)
    (*Test Case: If ClarifyLysate is turned Off. All its options are set to Null*)
    Example[{Options, {ClarifyLysateCentrifuge,ClarifyLysateIntensity,ClarifyLysateTime,ClarifiedLysateVolume,PostClarificationPelletLabel,PostClarificationPelletStorageCondition,ClarifiedLysateContainer,ClarifiedLysateContainerLabel}, "If ClarifyLysate is set to False, all ClarifyLysate options are set to Null:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        ClarifyLysate -> False,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysateCentrifuge -> Null,
          ClarifyLysateIntensity-> Null,
          ClarifyLysateTime-> Null,
          ClarifiedLysateVolume-> Null,
          PostClarificationPelletLabel-> Null,
          PostClarificationPelletStorageCondition-> Null,
          ClarifiedLysateContainer -> Null,
          ClarifiedLysateContainerLabel-> Null
        }]
      }
    ],
    (*Test Case: If ClarifyLysate is on. All its options are resolved to the most default. *)
    Example[{Options, {ClarifyLysateCentrifuge,ClarifyLysateIntensity,ClarifyLysateTime,ClarifiedLysateVolume,PostClarificationPelletLabel,PostClarificationPelletStorageCondition,ClarifiedLysateContainer,ClarifiedLysateContainerLabel}, "If ClarifyLysate is set to True, unless otherwise specified, 1) ClarifyLysateCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"], 2) ClarifyLysateIntensity is set to 5700 RPM, 3) ClarifyLysateTime is set to 10 minutes, 4) ClarifiedLysateVolume is set automatically set to 90% of the volume of the lysate, 5) PostClarificationPelletLabel is automatically generated, 6) PostClarificationPelletStorageCondition is automatically set to Disposal, 7) ClarifiedLysateContainer is automatically selected to accomadate the volume of the clarified lysate, 8) ClarifiedLysateContainerLabel is automatically generated:"},
      ExperimentExtractProtein[
        {
          Object[Sample, "ExperimentExtractProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        ClarifyLysate -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysateCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "HiG4"]],
          ClarifyLysateIntensity-> EqualP[5700 RPM],
          ClarifyLysateTime-> EqualP[10 Minute],
          ClarifiedLysateVolume -> EqualP[0.99 Milliliter],
          PostClarificationPelletLabel -> (_String),
          PostClarificationPelletStorageCondition -> Disposal,
          ClarifiedLysateContainer -> ObjectP[Model[Container]],
          ClarifiedLysateContainerLabel -> (_String)
        }]
      }
    ],

    (*Shared Unit Tests*)

    (* - Purification Errors - *)

    Example[{Messages, "LiquidLiquidExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 liquid-liquid extractions called for in the purification step list:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction},
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::LiquidLiquidExtractionStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages, "PurificationStepCountLimitExceeded", "An error is returned if there are more than 3 precipitations called for in the purification step list:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation, Precipitation, Precipitation, Precipitation},
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::PrecipitationStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 1200
    ],
    Example[{Messages, "SolidPhaseExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 solid phase extractions called for in the purification step list:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction},
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::SolidPhaseExtractionStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 1200
    ],
    Example[{Messages, "MagneticBeadSeparationStepCountLimitExceeded", "An error is returned if there are more than 3 magnetic bead separations called for in the purification step list:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation},
        (*Need to specify these volumes otherwise will be automatically resolve to 0uL in the 3rd round*)
        MagneticBeadVolume -> 20 Microliter,
        MagneticBeadSeparationElutionSolutionVolume -> 20 Microliter,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::MagneticBeadSeparationStepCountLimitExceeded,
        Error::InvalidOption
      },
      TimeConstraint -> 1200
    ],
    Example[{Messages, "ConflictingMagneticBeadSeparationMethods", "An error is returned if there are different values specified by methods for MagneticBeadSeparationSelectionStrategy:"},
      ExperimentExtractProtein[
        {Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
          Object[Sample,"ExperimentExtractProtein Lysate Sample " <> $SessionUUID]},
        Method->{
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 1 " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 3 " <> $SessionUUID]
        },
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::ConflictingMagneticBeadSeparationMethods,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages, "ConflictingMagneticBeadSeparationMethods", "An error is returned if there are different values specified by methods for MagneticBeadSeparationMode:"},
      ExperimentExtractProtein[
        {Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
          Object[Sample,"ExperimentExtractProtein Lysate Sample " <> $SessionUUID]},
        Method->{
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 1 " <> $SessionUUID],
          Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 2 " <> $SessionUUID]
        },
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::ConflictingMagneticBeadSeparationMethods,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages, "ConflictingMagneticBeadSeparationMethods", "An error is returned if there are different values specified by user and methods for MagneticBeadSeparationMode or MagneticBeadSeparationSelectionStrategy:"},
      ExperimentExtractProtein[
        {Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
          Object[Sample,"ExperimentExtractProtein Lysate Sample " <> $SessionUUID]},
        Method->Object[Method, Extraction, Protein, "ExperimentExtractProtein Conflicting MBS Test Method 1 " <> $SessionUUID],
        MagneticBeadSeparationSelectionStrategy -> Negative,
        MagneticBeadSeparationMode -> ReversePhase,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::ConflictingMagneticBeadSeparationMethods,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],


    (* - Shared MBS Tests - *)

    (* -- MBS General Options -- *)

    (*Test Case: Purification->MBS.*)
    Example[{Basic, "Crude samples can be purified with magnetic bead separation. :"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Method -> Custom,
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],

    (*Test Case: Default resolutions when nothing is set *)
    Example[{Options, {MagneticBeadSeparationSelectionStrategy,MagneticBeadSeparationMode,MagneticBeadSeparationSampleVolume,MagneticBeads,MagneticBeadVolume,MagneticBeadCollectionStorageCondition,MagnetizationRack}, "If Purification contains MagneticBeadSeparation, unless otherwise specified, 1) MagneticBeadSeparationSelectionStrategy is set to Positive, 2) MagneticBeadSeparationMode is set based on TargetProtein: if TargetProtein is not a Model[Molecule], MagneticBeadSeparationMode is set to IonExchange, 3) If the volume of the sample is less than 50% of the max volume of the container, then all of the sample will be used as the MagneticBeadSeparationSampleVolume, 4) if MagneticBeadSeparationMode is not set to Affinity, MagneticBeads is set to the first one found with the same MagneticBeadSeparationMode, 5) MagneticBeadVolume is set to 1/10 of the MagneticBeadSeparationSampleVolume, 6)MagneticBeadCollectionStorageCondition is set to Disposal, 7) MagnetizationRack is set to Model[Item, MagnetizationRack, \"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"]:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSelectionStrategy -> Positive,
            MagneticBeadSeparationMode -> IonExchange,
            MagneticBeadSeparationSampleVolume -> EqualP[0.2 Milliliter],
            MagneticBeads -> ObjectP[Model[Sample]],
            MagneticBeadVolume -> EqualP[0.02 Milliliter],
            MagneticBeadCollectionStorageCondition -> Disposal,
            MagnetizationRack -> ObjectP[Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"]](*Model[Item,MagnetizationRack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"]*)
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Alternative scenario for general options when TargetProtein is Model[Molecule]*)
    Example[{Options, {MagneticBeadSeparationMode,MagneticBeadSeparationAnalyteAffinityLabel,MagneticBeadAffinityLabel,MagneticBeads}, "If Purification contains MagneticBeadSeparation, unless otherwise specified, MagneticBeadSeparationMode is set based on TargetProtein: if TargetProtein is a Model[Molecule], MagneticBeadSeparationMode is set to Affinity. When MagneticBeadSeparationMode is Affinity, unless otherwise specified, 1) MagneticBeadSeparationAnalyteAffinityLabel is set to the first item in Analytes of the sample, 2) MagneticBeadAffinityLabel is set to the first item in the Targets field of the target molecule object, 3) MagneticBeads is set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel. If bead is not found, it is resolved to a general bead and a warning is thrown:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        TargetProtein -> Model[Molecule,Protein,"ExperimentExtractProtein test protein "<> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationMode -> Affinity,
            MagneticBeadSeparationAnalyteAffinityLabel -> ObjectP[Model[Molecule]],
            MagneticBeadAffinityLabel -> Null,
            MagneticBeads -> ObjectP[Model[Sample]]
          }
        ]
      },
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      },
      TimeConstraint -> 1800
    ],

    (*Test Case: Stage switches all off*)
    Example[{Options, {MagneticBeadSeparationPreWash,MagneticBeadSeparationEquilibration,MagneticBeadSeparationWash,MagneticBeadSeparationSecondaryWash,MagneticBeadSeparationTertiaryWash,MagneticBeadSeparationQuaternaryWash,MagneticBeadSeparationQuinaryWash,MagneticBeadSeparationSenaryWash,MagneticBeadSeparationSeptenaryWash,MagneticBeadSeparationElution}, "If Purification contains MagneticBeadSeparation, MagneticBeadSeparation is performed. 1) For each optional MagneticBeadSeparation stage other than Elution, if none of the stage-specific options is specified, unless otherwise specified, the optional stage is automatically turned off. 2) For MagneticBeadSeparationElution, if MagneticBeadSeparationSelectionStrategy is Negative and none of the stage-specific options is specified, MagneticBeadSeparationElution is set to False:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationSelectionStrategy -> Negative,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWash -> False,
            MagneticBeadSeparationEquilibration -> False,
            MagneticBeadSeparationWash -> False,
            MagneticBeadSeparationSecondaryWash -> False,
            MagneticBeadSeparationTertiaryWash -> False,
            MagneticBeadSeparationQuaternaryWash -> False,
            MagneticBeadSeparationQuinaryWash -> False,
            MagneticBeadSeparationSenaryWash -> False,
            MagneticBeadSeparationSeptenaryWash -> False,
            MagneticBeadSeparationElution -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Stage switches all on*)
    Example[{Options, {MagneticBeadSeparationPreWash,MagneticBeadSeparationEquilibration,MagneticBeadSeparationWash,MagneticBeadSeparationSecondaryWash,MagneticBeadSeparationTertiaryWash,MagneticBeadSeparationQuaternaryWash,MagneticBeadSeparationQuinaryWash,MagneticBeadSeparationSenaryWash,MagneticBeadSeparationSeptenaryWash,MagneticBeadSeparationElution}, "If Purification contains MagneticBeadSeparation, MagneticBeadSeparation is performed. 1) For each optional MagneticBeadSeparation stage other than Elution, if any of the stage-specific options is specified, unless otherwise specified, the optional stage is automatically turned on. 2) For MagneticBeadSeparationElution, if MagneticBeadSeparationSelectionStrategy is Positive (which is default) or any of the stage-specific options is specified, MagneticBeadSeparationElution is set to True:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationPreWashMix -> True,
        MagneticBeadSeparationEquilibrationAirDry->True,
        MagneticBeadSeparationWashSolutionVolume -> 100 Microliter,
        SecondaryWashMagnetizationTime -> 2 Minute,
        MagneticBeadSeparationTertiaryWashMixTemperature -> 4 Celsius,
        MagneticBeadSeparationQuaternaryWashSolution -> Model[Sample,"Milli-Q water"],
        MagneticBeadSeparationQuinaryWashMixTime -> 30 Second,
        MagneticBeadSeparationSenaryWashMixRate -> 300 RPM,
        NumberOfMagneticBeadSeparationSeptenaryWashes -> 1,
        MagneticBeadSeparationSelectionStrategy -> Positive,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWash -> True,
            MagneticBeadSeparationEquilibration -> True,
            MagneticBeadSeparationWash -> True,
            MagneticBeadSeparationSecondaryWash -> True,
            MagneticBeadSeparationTertiaryWash -> True,
            MagneticBeadSeparationQuaternaryWash -> True,
            MagneticBeadSeparationQuinaryWash -> True,
            MagneticBeadSeparationSenaryWash -> True,
            MagneticBeadSeparationSeptenaryWash -> True,
            MagneticBeadSeparationElution -> True
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- MBS PreWash Options -- *)
    (* --- MBS PreWash General Options --- *)
    (*Test Case: If PreWash is False, stage options are set to Null*)
    Example[{Options, {MagneticBeadSeparationPreWashSolution,MagneticBeadSeparationPreWashSolutionVolume,MagneticBeadSeparationPreWashMix,PreWashMagnetizationTime,MagneticBeadSeparationPreWashAspirationVolume,MagneticBeadSeparationPreWashCollectionContainer,MagneticBeadSeparationPreWashCollectionStorageCondition,NumberOfMagneticBeadSeparationPreWashes,MagneticBeadSeparationPreWashAirDry}, "If Purification contains MagneticBeadSeparation and MagneticBeadSeparationPreWash is set to False, unless otherwise specified, all PreWash options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationPreWash -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashSolution->Null,
            MagneticBeadSeparationPreWashSolutionVolume->Null,
            MagneticBeadSeparationPreWashMix->Null,
            PreWashMagnetizationTime->Null,
            MagneticBeadSeparationPreWashAspirationVolume->Null,
            MagneticBeadSeparationPreWashCollectionContainer-> {Null},
            MagneticBeadSeparationPreWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationPreWashes->Null,
            MagneticBeadSeparationPreWashAirDry->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: If PreWash is True, stage options are resolved to default*)
    Example[{Options, {MagneticBeadSeparationPreWashSolution,MagneticBeadSeparationPreWashSolutionVolume,MagneticBeadSeparationPreWashMix,PreWashMagnetizationTime,MagneticBeadSeparationPreWashAspirationVolume,MagneticBeadSeparationPreWashCollectionContainer,
      MagneticBeadSeparationPreWashCollectionContainerLabel,MagneticBeadSeparationPreWashCollectionStorageCondition,NumberOfMagneticBeadSeparationPreWashes,MagneticBeadSeparationPreWashAirDry}, "If MagneticBeadSeparationPreWash is set to True, unless otherwise specified, 1) MagneticBeadSeparationPreWashSolution is set to match the MagneticBeadSeparationElutionSolution if it is not Null, 2) MagneticBeadSeparationPreWashSolutionVolume is set to the sample volume, 3) MagneticBeadSeparationPreWashMix is set to True, 4) PreWashMagnetizationTime is automatically set to 5 minutes, 5) MagneticBeadSeparationPreWashAspirationVolume is set to the MagneticBeadSeparationPreWashSolutionVolume , 6) MagneticBeadSeparationPreWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], 7) MagneticBeadSeparationPreWashCollectionContainer is automatically generated, 8) MagneticBeadSeparationPreWashCollectionStorageCondition is set to Refrigerator, 9) NumberOfMagneticBeadSeparationPreWashes is set to 1, 10) MagneticBeadSeparationPreWashAirDry is automatically set to False:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashSolution -> ObjectP[Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"]],(*"id:eGakldadjlEe"50 mM Glycine pH 2.8, sterile filtered*)
            MagneticBeadSeparationPreWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationPreWashMix -> True,
            PreWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationPreWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationPreWashCollectionContainer -> {{"A1",ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationPreWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationPreWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationPreWashes -> 1,
            MagneticBeadSeparationPreWashAirDry -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: If PreWash is True, another possible resolution for solution when elution solution is null and for Mix when MixType is Null*)
    Example[{Options, {MagneticBeadSeparationPreWashSolution,MagneticBeadSeparationPreWashMix}, "If MagneticBeadSeparationPreWash is set to True, unless otherwise specified, 1) MagneticBeadSeparatioPreWashSolutionVolume is set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationElutionSolution is Null, 2) MagneticBeadSeparationPreWashMix is set to False if MagneticBeadSeparationPreWashMixType is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashMixType -> Null,
        MagneticBeadSeparationElutionSolution -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]],
            MagneticBeadSeparationPreWashMix -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- MBS PreWash Mix Options --- *)
    (*Test Case: PreWashMix is False. All prewash mix options are set to Null. *)
    Example[{Options, {MagneticBeadSeparationPreWashMixType,MagneticBeadSeparationPreWashMixTime,MagneticBeadSeparationPreWashMixRate,NumberOfMagneticBeadSeparationPreWashMixes,MagneticBeadSeparationPreWashMixVolume,MagneticBeadSeparationPreWashMixTemperature,MagneticBeadSeparationPreWashMixTipType,MagneticBeadSeparationPreWashMixTipMaterial}, "If MagneticBeadSeparationPreWashMix is set to False, other magnetic bead separation prewash mix options are automatically set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationPreWashMix -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixType->Null,
            MagneticBeadSeparationPreWashMixTime->Null,
            MagneticBeadSeparationPreWashMixRate -> Null,
            MagneticBeadSeparationPreWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationPreWashMixes->Null,
            MagneticBeadSeparationPreWashMixVolume->Null,
            MagneticBeadSeparationPreWashMixTipType->Null,
            MagneticBeadSeparationPreWashMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: PreWashMix is True and No other options are set. Mix type is set to Pipette, and other options are resolved. *)
    Example[{Options, {MagneticBeadSeparationPreWashMixType,MagneticBeadSeparationPreWashMixTime,MagneticBeadSeparationPreWashMixRate,NumberOfMagneticBeadSeparationPreWashMixes,MagneticBeadSeparationPreWashMixVolume,MagneticBeadSeparationPreWashMixTemperature,MagneticBeadSeparationPreWashMixTipType,MagneticBeadSeparationPreWashMixTipMaterial}, "If MagneticBeadSeparationPreWashMix is set to True, other magnetic bead separation prewash mix options are automatically set. If nothing is specified, MagneticBeadSeparationPreWashMixType is set to set to Pipette. When MagneticBeadSeparationPreWashMixType is Pipette, unless otherwise specified, 1) MagneticBeadSeparationPreWashMixTime and MagneticBeadSeparationPreWashMixRateare set to Null, 2) NumberOfMagneticBeadSeparationPreWashMixes is set to 20, 3) MagneticBeadSeparationPreWashMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume, 4) MagneticBeadSeparationPreWashMixTipType is set to WideBore, 5) MagneticBeadSeparationPreWashMixTipMaterial is set to Polypropylene, 6) MagneticBeadSeparationPreWashMixTemperature is set to Ambient:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWashMix -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixType -> Pipette,
            MagneticBeadSeparationPreWashMixTime->Null,
            MagneticBeadSeparationPreWashMixRate -> Null,
            MagneticBeadSeparationPreWashMixTemperature-> Ambient,
            MagneticBeadSeparationPreWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationPreWashMixes -> 20,
            MagneticBeadSeparationPreWashMixTipType -> WideBore,
            MagneticBeadSeparationPreWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: PreWashMix is True and some pipetting options are set: MagneticBeadSeparationPreWashMixType->Pipette, another resolution scenario for mix volume when current volume is larger*)
    Example[{Options, {MagneticBeadSeparationPreWashMixType,MagneticBeadSeparationPreWashMixVolume}, "If MagneticBeadSeparationPreWashMix is set to True, other magnetic bead separation prewash mix options are automatically set. 1) Unless otherwise specified, MagneticBeadSeparationPreWashMixType is set to Pipette if any of the pipetting options are set. 2) When MagneticBeadSeparationPreWashMixType is Pipette, unless otherwise specified, MagneticBeadSeparationPreWashMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL):"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixTipType -> WideBore,
        MagneticBeadVolume -> 1.0 Milliliter,
        MagneticBeadSeparationPreWashSolutionVolume -> 1.0 Milliliter,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixType -> Pipette,
            MagneticBeadSeparationPreWashMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: PreWashMix is True and some shaking options are set: MagneticBeadSeparationPreWashMixType->Shake*)
    Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and shaking options are set, MagneticBeadSeparationPreWashMixType is automatically set to Shake:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixRate -> 200 RPM,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],
    (*Test Case: MagneticBeadSeparationPreWashMixType->Shake and nothing is specified *)
    Example[{Options, {MagneticBeadSeparationPreWashMixType,MagneticBeadSeparationPreWashMixTime,MagneticBeadSeparationPreWashMixRate,NumberOfMagneticBeadSeparationPreWashMixes,MagneticBeadSeparationPreWashMixVolume,MagneticBeadSeparationPreWashMixTemperature,MagneticBeadSeparationPreWashMixTipType,MagneticBeadSeparationPreWashMixTipMaterial}, "If MagneticBeadSeparationPreWashMixType is Shake, unless otherwise specified,1) pipetting options are set to Null, 2) MagneticBeadSeparationPreWashMixTime set to 5 Minute, 3) MagneticBeadSeparationPreWashMixTemperature is set to 5 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Shake,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationPreWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationPreWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationPreWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationPreWashMixes->Null,
            MagneticBeadSeparationPreWashMixVolume->Null,
            MagneticBeadSeparationPreWashMixTipType->Null,
            MagneticBeadSeparationPreWashMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (* --- MBS PreWash AirDryOptions --- *)
    (*Test Case: PreWashAirDry is On, MagneticBeadSeparationPreWashAirDryTime is set to default*)
    Example[{Options, MagneticBeadSeparationPreWashAirDryTime, "If MagneticBeadSeparationPreWashAirDry is True, MagneticBeadSeparationPreWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashAirDry -> True,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],

    (* -- MBS Equilibration Options -- *)
    (* --- MBS Equilibration General Options --- *)
    (*Test Case: If Equilibration is False, stage options are set to Null*)
    Example[{Options, {MagneticBeadSeparationEquilibrationSolution,MagneticBeadSeparationEquilibrationSolutionVolume,MagneticBeadSeparationEquilibrationMix,EquilibrationMagnetizationTime,MagneticBeadSeparationEquilibrationAspirationVolume,MagneticBeadSeparationEquilibrationCollectionContainer,MagneticBeadSeparationEquilibrationCollectionStorageCondition,MagneticBeadSeparationEquilibrationAirDry}, "If Purification contains MagneticBeadSeparation and MagneticBeadSeparationEquilibration is set to False, unless otherwise specified, all Equilibration options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationEquilibration -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationSolution->Null,
            MagneticBeadSeparationEquilibrationSolutionVolume->Null,
            MagneticBeadSeparationEquilibrationMix->Null,
            EquilibrationMagnetizationTime->Null,
            MagneticBeadSeparationEquilibrationAspirationVolume->Null,
            MagneticBeadSeparationEquilibrationCollectionContainer-> Null,
            MagneticBeadSeparationEquilibrationCollectionStorageCondition->Null,
            MagneticBeadSeparationEquilibrationAirDry->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: If Equilibration is True, stage options are resolved to default*)
    Example[{Options, {MagneticBeadSeparationEquilibrationSolution,MagneticBeadSeparationEquilibrationSolutionVolume,MagneticBeadSeparationEquilibrationMix,EquilibrationMagnetizationTime,MagneticBeadSeparationEquilibrationAspirationVolume,MagneticBeadSeparationEquilibrationCollectionContainer,
      MagneticBeadSeparationEquilibrationCollectionContainerLabel,MagneticBeadSeparationEquilibrationCollectionStorageCondition,MagneticBeadSeparationEquilibrationAirDry}, "If MagneticBeadSeparationEquilibration is set to True, unless otherwise specified, 1) MagneticBeadSeparationEquilibrationSolution is set to Model[Sample,\"Milli-Q water\"], 2) MagneticBeadSeparationEquilibrationSolutionVolume is set to the sample volume if Prewash is False, 3) MagneticBeadSeparationEquilibrationMix is set to True if MagneticBeadSeparationEquilibrationMixType is not set to Null, 4) EquilibrationMagnetizationTime is automatically set to 5 minutes, 5) MagneticBeadSeparationEquilibrationAspirationVolume is set to the MagneticBeadSeparationEquilibrationSolutionVolume , 6) MagneticBeadSeparationEquilibrationCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], 7) MagneticBeadSeparationEquilibrationCollectionContainer is automatically generated, 8) MagneticBeadSeparationEquilibrationCollectionStorageCondition is set to Refrigerator, 9) MagneticBeadSeparationEquilibrationAirDry is automatically set to False:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationSolution -> ObjectP[Model[Sample,"Milli-Q water"]],
            MagneticBeadSeparationEquilibrationSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationEquilibrationMix -> True,
            EquilibrationMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationEquilibrationAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationEquilibrationCollectionContainer -> {"A1",ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
            MagneticBeadSeparationEquilibrationCollectionContainerLabel -> {_String},
            MagneticBeadSeparationEquilibrationCollectionStorageCondition -> Refrigerator,
            MagneticBeadSeparationEquilibrationAirDry -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (*Test Case: If Equilibration is True, another possible resolution for solution volume when the previous stage is on*)
    Example[{Options, {MagneticBeadSeparationEquilibrationSolutionVolume,MagneticBeadSeparationEquilibrationMix}, "If MagneticBeadSeparationEquilibration is set to True, unless otherwise specified, 1) MagneticBeadSeparationEquilibrationSolutionVolume is set to MagneticBeadSeparationPreWashSolutionVolume if Prewash is True, 2) MagneticBeadSeparationEquilibrationMix is set to False if MagneticBeadSeparationEquilibrationMixType is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashSolutionVolume -> 100 Microliter,
        MagneticBeadSeparationEquilibration -> True,
        MagneticBeadSeparationEquilibrationMixType -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationSolutionVolume -> EqualP[0.1 Milliliter],
            MagneticBeadSeparationEquilibrationMix -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- MBS Equilibration Mix Options --- *)
    (*Test Case: EquilibrationMix is False. All equilibration mix options are set to Null. *)
    Example[{Options, {MagneticBeadSeparationEquilibrationMixType,MagneticBeadSeparationEquilibrationMixTime,MagneticBeadSeparationEquilibrationMixRate,NumberOfMagneticBeadSeparationEquilibrationMixes,MagneticBeadSeparationEquilibrationMixVolume,MagneticBeadSeparationEquilibrationMixTemperature,MagneticBeadSeparationEquilibrationMixTipType,MagneticBeadSeparationEquilibrationMixTipMaterial}, "If MagneticBeadSeparationEquilibrationMix is set to False, other magnetic bead separation equilibration mix options are automatically set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationEquilibrationMix -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixType->Null,
            MagneticBeadSeparationEquilibrationMixTime->Null,
            MagneticBeadSeparationEquilibrationMixRate -> Null,
            MagneticBeadSeparationEquilibrationMixTemperature->Null,
            NumberOfMagneticBeadSeparationEquilibrationMixes->Null,
            MagneticBeadSeparationEquilibrationMixVolume->Null,
            MagneticBeadSeparationEquilibrationMixTipType->Null,
            MagneticBeadSeparationEquilibrationMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: EquilibrationMix is True and No other options are set. Mix type is set to Pipette, and other options are resolved. *)
    Example[{Options, {MagneticBeadSeparationEquilibrationMixType,MagneticBeadSeparationEquilibrationMixTime,MagneticBeadSeparationEquilibrationMixRate,NumberOfMagneticBeadSeparationEquilibrationMixes,MagneticBeadSeparationEquilibrationMixVolume,MagneticBeadSeparationEquilibrationMixTemperature,MagneticBeadSeparationEquilibrationMixTipType,MagneticBeadSeparationEquilibrationMixTipMaterial}, "If MagneticBeadSeparationEquilibrationMix is set to True, other magnetic bead separation equilibration mix options are automatically set. If nothing is specified, MagneticBeadSeparationEquilibrationMixType is set to set to Pipette. When MagneticBeadSeparationEquilibrationMixType is Pipette, unless otherwise specified, 1) MagneticBeadSeparationEquilibrationMixTime and MagneticBeadSeparationEquilibrationMixRateare set to Null, 2) NumberOfMagneticBeadSeparationEquilibrationMixes is set to 20, 3) MagneticBeadSeparationEquilibrationMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationEquilibrationSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationEquilibrationMixVolume is automatically set to 80% of the combined MagneticBeadSeparationEquilibrationSolutionVolume and magnetic beads volume, 4) MagneticBeadSeparationEquilibrationMixTipType is set to WideBore, 5) MagneticBeadSeparationEquilibrationMixTipMaterial is set to Polypropylene, 6) MagneticBeadSeparationEquilibrationMixTemperature is set to Ambient:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationEquilibrationMix -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixType -> Pipette,
            MagneticBeadSeparationEquilibrationMixTime->Null,
            MagneticBeadSeparationEquilibrationMixRate -> Null,
            MagneticBeadSeparationEquilibrationMixTemperature-> Ambient,
            MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationEquilibrationMixes -> 20,
            MagneticBeadSeparationEquilibrationMixTipType -> WideBore,
            MagneticBeadSeparationEquilibrationMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: EquilibrationMix is True and some pipetting options are set: MagneticBeadSeparationEquilibrationMixType->Pipette, another resolution scenario for mix volume when current volume is larger*)
    Example[{Options, {MagneticBeadSeparationEquilibrationMixType,MagneticBeadSeparationEquilibrationMixVolume}, "If MagneticBeadSeparationEquilibrationMix is set to True, other magnetic bead separation equilibration mix options are automatically set. 1) Unless otherwise specified, MagneticBeadSeparationEquilibrationMixType is set to Pipette if any of the pipetting options are set. 2) When MagneticBeadSeparationEquilibrationMixType is Pipette, unless otherwise specified, MagneticBeadSeparationEquilibrationMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationEquilibrationSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationEquilibrationMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL):"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixTipType -> WideBore,
        MagneticBeadVolume -> 1.0 Milliliter,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 1.0 Milliliter,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixType -> Pipette,
            MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: EquilibrationMix is True and some shaking options are set: MagneticBeadSeparationEquilibrationMixType->Shake*)
    Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If MagneticBeadSeparationEquilibrationMix is set to True and shaking options are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Shake:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixRate -> 200 RPM,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],
    (*Test Case: MagneticBeadSeparationEquilibrationMixType->Shake and nothing is specified *)
    Example[{Options, {MagneticBeadSeparationEquilibrationMixType,MagneticBeadSeparationEquilibrationMixTime,MagneticBeadSeparationEquilibrationMixRate,NumberOfMagneticBeadSeparationEquilibrationMixes,MagneticBeadSeparationEquilibrationMixVolume,MagneticBeadSeparationEquilibrationMixTemperature,MagneticBeadSeparationEquilibrationMixTipType,MagneticBeadSeparationEquilibrationMixTipMaterial}, "If MagneticBeadSeparationEquilibrationMixType is Shake, unless otherwise specified,1) pipetting options are set to Null, 2) MagneticBeadSeparationEquilibrationMixTime set to 5 Minute, 3) MagneticBeadSeparationEquilibrationMixTemperature is set to 5 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Shake,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationEquilibrationMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationEquilibrationMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationEquilibrationMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationEquilibrationMixes->Null,
            MagneticBeadSeparationEquilibrationMixVolume->Null,
            MagneticBeadSeparationEquilibrationMixTipType->Null,
            MagneticBeadSeparationEquilibrationMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (* --- MBS Equilibration AirDryOptions --- *)
    (*Test Case: EquilibrationAirDry is On, MagneticBeadSeparationEquilibrationAirDryTime is set to default*)
    Example[{Options, MagneticBeadSeparationEquilibrationAirDryTime, "If MagneticBeadSeparationEquilibrationAirDry is set to True, MagneticBeadSeparationEquilibrationAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationAirDry -> True,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],
    (* -- MBS Loading Options -- *)
    (* --- MBS Loading General Options --- *)
    (*Test Case: Loading is always true, stage options are resolved to default if nothing is specified*)
    Example[{Options, {MagneticBeadSeparationSampleVolume,MagneticBeadSeparationLoadingMix,LoadingMagnetizationTime,MagneticBeadSeparationLoadingAspirationVolume,MagneticBeadSeparationLoadingCollectionContainer, MagneticBeadSeparationLoadingCollectionContainerLabel,MagneticBeadSeparationLoadingCollectionStorageCondition,MagneticBeadSeparationLoadingAirDry}, "If Purification contains MagneticBeadSeparation, Loading is always performed. Unless otherwise specified, 1) MagneticBeadSeparationSampleVolume is set to the lesser of the input sample volume or 1 Milliliter, 2) MagneticBeadSeparationLoadingMix is set to True, 3) LoadingMagnetizationTime is automatically set to 5 minutes, 4) MagneticBeadSeparationLoadingAspirationVolume is set to the MagneticBeadSeparationSampleVolume , 5) MagneticBeadSeparationLoadingCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], 6) MagneticBeadSeparationLoadingCollectionContainer is automatically generated, 7) MagneticBeadSeparationLoadingCollectionStorageCondition is set to Refrigerator, 8) MagneticBeadSeparationLoadingAirDry is automatically set to False:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {MagneticBeadSeparation},
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationSampleVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationLoadingMix -> True,
            LoadingMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationLoadingAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationLoadingCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
            MagneticBeadSeparationLoadingCollectionContainerLabel -> {_String},
            MagneticBeadSeparationLoadingCollectionStorageCondition -> Refrigerator,
            MagneticBeadSeparationLoadingAirDry -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (*Test Case: If Loading is True, another possible resolution for LoadingMix if MixType is Null*)
    Example[{Options, {MagneticBeadSeparationLoadingMix}, "If Purification contains MagneticBeadSeparation, Loading is always performed. Unless otherwise specified, MagneticBeadSeparationLoadingMix is set to False if MagneticBeadSeparationLoadingMixType is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {MagneticBeadSeparation},
        MagneticBeadSeparationLoadingMixType -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMix -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- MBS Loading Mix Options --- *)
    (*Test Case: LoadingMix is False. All loading mix options are set to Null. *)
    Example[{Options, {MagneticBeadSeparationLoadingMixType,MagneticBeadSeparationLoadingMixTime,MagneticBeadSeparationLoadingMixRate,NumberOfMagneticBeadSeparationLoadingMixes,MagneticBeadSeparationLoadingMixVolume,MagneticBeadSeparationLoadingMixTemperature,MagneticBeadSeparationLoadingMixTipType,MagneticBeadSeparationLoadingMixTipMaterial}, "If MagneticBeadSeparationLoadingMix is set to False, other magnetic bead separation loading mix options are automatically set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationLoadingMix -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixType->Null,
            MagneticBeadSeparationLoadingMixTime->Null,
            MagneticBeadSeparationLoadingMixRate -> Null,
            MagneticBeadSeparationLoadingMixTemperature->Null,
            NumberOfMagneticBeadSeparationLoadingMixes->Null,
            MagneticBeadSeparationLoadingMixVolume->Null,
            MagneticBeadSeparationLoadingMixTipType->Null,
            MagneticBeadSeparationLoadingMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: LoadingMix is True and No other options are set. Mix type is set to Pipette, and other options are resolved. *)
    Example[{Options, {MagneticBeadSeparationLoadingMixType,MagneticBeadSeparationLoadingMixTime,MagneticBeadSeparationLoadingMixRate,NumberOfMagneticBeadSeparationLoadingMixes,MagneticBeadSeparationLoadingMixVolume,MagneticBeadSeparationLoadingMixTemperature,MagneticBeadSeparationLoadingMixTipType,MagneticBeadSeparationLoadingMixTipMaterial}, "If MagneticBeadSeparationLoadingMix is set to True, other magnetic bead separation loading mix options are automatically set. If nothing is specified, MagneticBeadSeparationLoadingMixType is set to set to Pipette. When MagneticBeadSeparationLoadingMixType is Pipette, unless otherwise specified, 1) MagneticBeadSeparationLoadingMixTime and MagneticBeadSeparationLoadingMixRateare set to Null, 2) NumberOfMagneticBeadSeparationLoadingMixes is set to 20, 3) MagneticBeadSeparationLoadingMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationSampleVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationLoadingMixVolume is automatically set to 80% of the combined MagneticBeadSeparationLoadingSolutionVolume and magnetic beads volume, 4) MagneticBeadSeparationLoadingMixTipType is set to WideBore, 5) MagneticBeadSeparationLoadingMixTipMaterial is set to Polypropylene, 6) MagneticBeadSeparationLoadingMixTemperature is set to Ambient:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationLoadingMix -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixType -> Pipette,
            MagneticBeadSeparationLoadingMixTime->Null,
            MagneticBeadSeparationLoadingMixRate -> Null,
            MagneticBeadSeparationLoadingMixTemperature-> Ambient,
            MagneticBeadSeparationLoadingMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationLoadingMixes -> 20,
            MagneticBeadSeparationLoadingMixTipType -> WideBore,
            MagneticBeadSeparationLoadingMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: LoadingMix is True and some pipetting options are set: MagneticBeadSeparationLoadingMixType->Pipette, another resolution scenario for mix volume when current volume is larger*)
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If MagneticBeadSeparationLoadingMix is set to True, other magnetic bead separation loading mix options are automatically set. 1) Unless otherwise specified, MagneticBeadSeparationLoadingMixType is set to Pipette if any of the pipetting options are set. 2) When MagneticBeadSeparationLoadingMixType is Pipette:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixTipType -> WideBore,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],
    (*Test Case: LoadingMix is True and some shaking options are set: MagneticBeadSeparationLoadingMixType->Shake*)
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If MagneticBeadSeparationLoadingMix is set to True and shaking options are set, MagneticBeadSeparationLoadingMixType is automatically set to Shake:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixRate -> 200 RPM,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],
    (*Test Case: MagneticBeadSeparationLoadingMixType->Shake and nothing is specified *)
    Example[{Options, {MagneticBeadSeparationLoadingMixType,MagneticBeadSeparationLoadingMixTime,MagneticBeadSeparationLoadingMixRate,NumberOfMagneticBeadSeparationLoadingMixes,MagneticBeadSeparationLoadingMixVolume,MagneticBeadSeparationLoadingMixTemperature,MagneticBeadSeparationLoadingMixTipType,MagneticBeadSeparationLoadingMixTipMaterial}, "If MagneticBeadSeparationLoadingMixType is Shake, unless otherwise specified,1) pipetting options are set to Null, 2) MagneticBeadSeparationLoadingMixTime set to 5 Minute, 3) MagneticBeadSeparationLoadingMixTemperature is set to 5 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Shake,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationLoadingMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationLoadingMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationLoadingMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationLoadingMixes->Null,
            MagneticBeadSeparationLoadingMixVolume->Null,
            MagneticBeadSeparationLoadingMixTipType->Null,
            MagneticBeadSeparationLoadingMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (* --- MBS Loading AirDryOptions --- *)
    (*Test Case: LoadingAirDry is On, MagneticBeadSeparationLoadingAirDryTime is set to default*)
    Example[{Options, MagneticBeadSeparationLoadingAirDryTime, "If MagneticBeadSeparationLoadingAirDry is set to True, MagneticBeadSeparationLoadingAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingAirDry -> True,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],
    
    (* -- MBS Wash Options: compiled all 7 stages -- *)
    (* --- MBS Wash General Options --- *)
    (*Test Case: If Wash is False, stage options are set to Null*)
    Example[{Options, {MagneticBeadSeparationWashSolution,MagneticBeadSeparationWashSolutionVolume,MagneticBeadSeparationWashMix,WashMagnetizationTime,MagneticBeadSeparationWashAspirationVolume,MagneticBeadSeparationWashCollectionContainer,MagneticBeadSeparationWashCollectionStorageCondition,NumberOfMagneticBeadSeparationWashes,MagneticBeadSeparationWashAirDry,MagneticBeadSeparationSecondaryWashSolution,MagneticBeadSeparationSecondaryWashSolutionVolume,MagneticBeadSeparationSecondaryWashMix,SecondaryWashMagnetizationTime,MagneticBeadSeparationSecondaryWashAspirationVolume,MagneticBeadSeparationSecondaryWashCollectionContainer,MagneticBeadSeparationSecondaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationSecondaryWashes,MagneticBeadSeparationSecondaryWashAirDry,MagneticBeadSeparationTertiaryWashSolution,MagneticBeadSeparationTertiaryWashSolutionVolume,MagneticBeadSeparationTertiaryWashMix,TertiaryWashMagnetizationTime,MagneticBeadSeparationTertiaryWashAspirationVolume,MagneticBeadSeparationTertiaryWashCollectionContainer,MagneticBeadSeparationTertiaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationTertiaryWashes,MagneticBeadSeparationTertiaryWashAirDry,MagneticBeadSeparationQuaternaryWashSolution,MagneticBeadSeparationQuaternaryWashSolutionVolume,MagneticBeadSeparationQuaternaryWashMix,QuaternaryWashMagnetizationTime,MagneticBeadSeparationQuaternaryWashAspirationVolume,MagneticBeadSeparationQuaternaryWashCollectionContainer,MagneticBeadSeparationQuaternaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationQuaternaryWashes,MagneticBeadSeparationQuaternaryWashAirDry,MagneticBeadSeparationQuinaryWashSolution,MagneticBeadSeparationQuinaryWashSolutionVolume,MagneticBeadSeparationQuinaryWashMix,QuinaryWashMagnetizationTime,MagneticBeadSeparationQuinaryWashAspirationVolume,MagneticBeadSeparationQuinaryWashCollectionContainer,MagneticBeadSeparationQuinaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationQuinaryWashes,MagneticBeadSeparationQuinaryWashAirDry,MagneticBeadSeparationSenaryWashSolution,MagneticBeadSeparationSenaryWashSolutionVolume,MagneticBeadSeparationSenaryWashMix,SenaryWashMagnetizationTime,MagneticBeadSeparationSenaryWashAspirationVolume,MagneticBeadSeparationSenaryWashCollectionContainer,MagneticBeadSeparationSenaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationSenaryWashes,MagneticBeadSeparationSenaryWashAirDry,MagneticBeadSeparationSeptenaryWashSolution,MagneticBeadSeparationSeptenaryWashSolutionVolume,MagneticBeadSeparationSeptenaryWashMix,SeptenaryWashMagnetizationTime,MagneticBeadSeparationSeptenaryWashAspirationVolume,MagneticBeadSeparationSeptenaryWashCollectionContainer,MagneticBeadSeparationSeptenaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationSeptenaryWashes,MagneticBeadSeparationSeptenaryWashAirDry}, "If Purification contains MagneticBeadSeparation and a stage masterswitch (e.g. MagneticBeadSeparationWash, MagneticBeadSeparationSecondaryWash...} is set to False, unless otherwise specified, all options of that wash stage are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationWash -> False,
        MagneticBeadSeparationSecondaryWash -> False,
        MagneticBeadSeparationTertiaryWash -> False,
        MagneticBeadSeparationQuaternaryWash -> False,
        MagneticBeadSeparationQuinaryWash -> False,
        MagneticBeadSeparationSenaryWash -> False,
        MagneticBeadSeparationSeptenaryWash -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashSolution->Null,
            MagneticBeadSeparationWashSolutionVolume->Null,
            MagneticBeadSeparationWashMix->Null,
            WashMagnetizationTime->Null,
            MagneticBeadSeparationWashAspirationVolume->Null,
            MagneticBeadSeparationWashCollectionContainer-> {Null},
            MagneticBeadSeparationWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationWashes->Null,
            MagneticBeadSeparationWashAirDry->Null,
            MagneticBeadSeparationSecondaryWashSolution->Null,
            MagneticBeadSeparationSecondaryWashSolutionVolume->Null,
            MagneticBeadSeparationSecondaryWashMix->Null,
            SecondaryWashMagnetizationTime->Null,
            MagneticBeadSeparationSecondaryWashAspirationVolume->Null,
            MagneticBeadSeparationSecondaryWashCollectionContainer-> {Null},
            MagneticBeadSeparationSecondaryWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationSecondaryWashes->Null,
            MagneticBeadSeparationSecondaryWashAirDry->Null,
            MagneticBeadSeparationTertiaryWashSolution->Null,
            MagneticBeadSeparationTertiaryWashSolutionVolume->Null,
            MagneticBeadSeparationTertiaryWashMix->Null,
            TertiaryWashMagnetizationTime->Null,
            MagneticBeadSeparationTertiaryWashAspirationVolume->Null,
            MagneticBeadSeparationTertiaryWashCollectionContainer-> {Null},
            MagneticBeadSeparationTertiaryWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationTertiaryWashes->Null,
            MagneticBeadSeparationTertiaryWashAirDry->Null,
            MagneticBeadSeparationQuaternaryWashSolution->Null,
            MagneticBeadSeparationQuaternaryWashSolutionVolume->Null,
            MagneticBeadSeparationQuaternaryWashMix->Null,
            QuaternaryWashMagnetizationTime->Null,
            MagneticBeadSeparationQuaternaryWashAspirationVolume->Null,
            MagneticBeadSeparationQuaternaryWashCollectionContainer-> {Null},
            MagneticBeadSeparationQuaternaryWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationQuaternaryWashes->Null,
            MagneticBeadSeparationQuaternaryWashAirDry->Null,
            MagneticBeadSeparationQuinaryWashSolution->Null,
            MagneticBeadSeparationQuinaryWashSolutionVolume->Null,
            MagneticBeadSeparationQuinaryWashMix->Null,
            QuinaryWashMagnetizationTime->Null,
            MagneticBeadSeparationQuinaryWashAspirationVolume->Null,
            MagneticBeadSeparationQuinaryWashCollectionContainer-> {Null},
            MagneticBeadSeparationQuinaryWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationQuinaryWashes->Null,
            MagneticBeadSeparationQuinaryWashAirDry->Null,
            MagneticBeadSeparationSenaryWashSolution->Null,
            MagneticBeadSeparationSenaryWashSolutionVolume->Null,
            MagneticBeadSeparationSenaryWashMix->Null,
            SenaryWashMagnetizationTime->Null,
            MagneticBeadSeparationSenaryWashAspirationVolume->Null,
            MagneticBeadSeparationSenaryWashCollectionContainer-> {Null},
            MagneticBeadSeparationSenaryWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationSenaryWashes->Null,
            MagneticBeadSeparationSenaryWashAirDry->Null,
            MagneticBeadSeparationSeptenaryWashSolution->Null,
            MagneticBeadSeparationSeptenaryWashSolutionVolume->Null,
            MagneticBeadSeparationSeptenaryWashMix->Null,
            SeptenaryWashMagnetizationTime->Null,
            MagneticBeadSeparationSeptenaryWashAspirationVolume->Null,
            MagneticBeadSeparationSeptenaryWashCollectionContainer-> {Null},
            MagneticBeadSeparationSeptenaryWashCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationSeptenaryWashes->Null,
            MagneticBeadSeparationSeptenaryWashAirDry->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: If Wash is True, stage options are resolved to default*)
    Example[{Options, {MagneticBeadSeparationWashSolution,MagneticBeadSeparationWashSolutionVolume,MagneticBeadSeparationWashMix,WashMagnetizationTime,MagneticBeadSeparationWashAspirationVolume,MagneticBeadSeparationWashCollectionContainer,
      MagneticBeadSeparationWashCollectionContainerLabel,MagneticBeadSeparationWashCollectionStorageCondition,NumberOfMagneticBeadSeparationWashes,MagneticBeadSeparationWashAirDry,MagneticBeadSeparationSecondaryWashSolution,MagneticBeadSeparationSecondaryWashSolutionVolume,MagneticBeadSeparationSecondaryWashMix,SecondaryWashMagnetizationTime,MagneticBeadSeparationSecondaryWashAspirationVolume,MagneticBeadSeparationSecondaryWashCollectionContainer,
      MagneticBeadSeparationSecondaryWashCollectionContainerLabel,MagneticBeadSeparationSecondaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationSecondaryWashes,MagneticBeadSeparationSecondaryWashAirDry,MagneticBeadSeparationTertiaryWashSolution,MagneticBeadSeparationTertiaryWashSolutionVolume,MagneticBeadSeparationTertiaryWashMix,TertiaryWashMagnetizationTime,MagneticBeadSeparationTertiaryWashAspirationVolume,MagneticBeadSeparationTertiaryWashCollectionContainer,
      MagneticBeadSeparationTertiaryWashCollectionContainerLabel,MagneticBeadSeparationTertiaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationTertiaryWashes,MagneticBeadSeparationTertiaryWashAirDry,MagneticBeadSeparationQuaternaryWashSolution,MagneticBeadSeparationQuaternaryWashSolutionVolume,MagneticBeadSeparationQuaternaryWashMix,QuaternaryWashMagnetizationTime,MagneticBeadSeparationQuaternaryWashAspirationVolume,MagneticBeadSeparationQuaternaryWashCollectionContainer,
      MagneticBeadSeparationQuaternaryWashCollectionContainerLabel,MagneticBeadSeparationQuaternaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationQuaternaryWashes,MagneticBeadSeparationQuaternaryWashAirDry,MagneticBeadSeparationQuinaryWashSolution,MagneticBeadSeparationQuinaryWashSolutionVolume,MagneticBeadSeparationQuinaryWashMix,QuinaryWashMagnetizationTime,MagneticBeadSeparationQuinaryWashAspirationVolume,MagneticBeadSeparationQuinaryWashCollectionContainer,
      MagneticBeadSeparationQuinaryWashCollectionContainerLabel,MagneticBeadSeparationQuinaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationQuinaryWashes,MagneticBeadSeparationQuinaryWashAirDry,MagneticBeadSeparationSenaryWashSolution,MagneticBeadSeparationSenaryWashSolutionVolume,MagneticBeadSeparationSenaryWashMix,SenaryWashMagnetizationTime,MagneticBeadSeparationSenaryWashAspirationVolume,MagneticBeadSeparationSenaryWashCollectionContainer,
      MagneticBeadSeparationSenaryWashCollectionContainerLabel,MagneticBeadSeparationSenaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationSenaryWashes,MagneticBeadSeparationSenaryWashAirDry,MagneticBeadSeparationSeptenaryWashSolution,MagneticBeadSeparationSeptenaryWashSolutionVolume,MagneticBeadSeparationSeptenaryWashMix,SeptenaryWashMagnetizationTime,MagneticBeadSeparationSeptenaryWashAspirationVolume,MagneticBeadSeparationSeptenaryWashCollectionContainer,
      MagneticBeadSeparationSeptenaryWashCollectionContainerLabel,MagneticBeadSeparationSeptenaryWashCollectionStorageCondition,NumberOfMagneticBeadSeparationSeptenaryWashes,MagneticBeadSeparationSeptenaryWashAirDry}, "If MagneticBeadSeparationWash is set to True, unless otherwise specified, 1) MagneticBeadSeparationWashSolution is set to Model[Sample,\"Filtered PBS, Sterile\"], 2) MagneticBeadSeparationWashSolutionVolume is set to MagneticBeadSeparationSampleVolume when PreWash is False, 3) MagneticBeadSeparationWashMix is set to True if MagneticBeadSeparationWashMixType is not set to Null, 4) WashMagnetizationTime is automatically set to 5 minutes, 5) MagneticBeadSeparationWashAspirationVolume is set to the MagneticBeadSeparationWashSolutionVolume , 6) MagneticBeadSeparationWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], 7) MagneticBeadSeparationWashCollectionContainer is automatically generated, 8) MagneticBeadSeparationWashCollectionStorageCondition is set to Refrigerator, 9) NumberOfMagneticBeadSeparationWashes is set to 1, 10) MagneticBeadSeparationWashAirDry is automatically set to False. Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 200 Microliter,
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        MagneticBeadSeparationSeptenaryWash -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            MagneticBeadSeparationWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationWashMix -> True,
            WashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationWashes -> 1,
            MagneticBeadSeparationWashAirDry -> False,
            MagneticBeadSeparationSecondaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationSecondaryWashMix -> True,
            SecondaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationSecondaryWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationSecondaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationSecondaryWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationSecondaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationSecondaryWashes -> 1,
            MagneticBeadSeparationSecondaryWashAirDry -> False,
            MagneticBeadSeparationTertiaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationTertiaryWashMix -> True,
            TertiaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationTertiaryWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationTertiaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationTertiaryWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationTertiaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationTertiaryWashes -> 1,
            MagneticBeadSeparationTertiaryWashAirDry -> False,
            MagneticBeadSeparationQuaternaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationQuaternaryWashMix -> True,
            QuaternaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationQuaternaryWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationQuaternaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationQuaternaryWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationQuaternaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationQuaternaryWashes -> 1,
            MagneticBeadSeparationQuaternaryWashAirDry -> False,
            MagneticBeadSeparationQuinaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationQuinaryWashMix -> True,
            QuinaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationQuinaryWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationQuinaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationQuinaryWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationQuinaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationQuinaryWashes -> 1,
            MagneticBeadSeparationQuinaryWashAirDry -> False,
            MagneticBeadSeparationSenaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationSenaryWashMix -> True,
            SenaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationSenaryWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationSenaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationSenaryWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationSenaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationSenaryWashes -> 1,
            MagneticBeadSeparationSenaryWashAirDry -> False,
            MagneticBeadSeparationSeptenaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationSeptenaryWashMix -> True,
            SeptenaryWashMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationSeptenaryWashAspirationVolume -> EqualP[0.2 Milliliter],
            MagneticBeadSeparationSeptenaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
            MagneticBeadSeparationSeptenaryWashCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationSeptenaryWashCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationSeptenaryWashes -> 1,
            MagneticBeadSeparationSeptenaryWashAirDry -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: If Wash is True, another possible resolution for solution volume when PreWash is True and for Mix when MixType is Null*)
    Example[{Options, {MagneticBeadSeparationWashSolutionVolume,MagneticBeadSeparationWashMix,MagneticBeadSeparationSecondaryWashSolutionVolume,MagneticBeadSeparationSecondaryWashMix,MagneticBeadSeparationTertiaryWashSolutionVolume,MagneticBeadSeparationTertiaryWashMix,MagneticBeadSeparationQuaternaryWashSolutionVolume,MagneticBeadSeparationQuaternaryWashMix,MagneticBeadSeparationQuinaryWashSolutionVolume,MagneticBeadSeparationQuinaryWashMix,MagneticBeadSeparationSenaryWashSolutionVolume,MagneticBeadSeparationSenaryWashMix,MagneticBeadSeparationSeptenaryWashSolutionVolume,MagneticBeadSeparationSeptenaryWashMix}, "If MagneticBeadSeparationWash is set to True, unless otherwise specified, 1) MagneticBeadSeparatioWashSolutionVolume is set to MagneticBeadSeparationPreWashSolutionVolume if MagneticBeadSeparatioPreWash is True, 2) MagneticBeadSeparationWashMix is set to False if MagneticBeadSeparationWashMixType is set to Null. Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashSolutionVolume->100 Microliter,
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationWashMixType -> Null,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationSecondaryWashMixType -> Null,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationTertiaryWashMixType -> Null,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuaternaryWashMixType -> Null,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationQuinaryWashMixType -> Null,
        MagneticBeadSeparationSenaryWash -> True,
        MagneticBeadSeparationSenaryWashMixType -> Null,
        MagneticBeadSeparationSeptenaryWash -> True,
        MagneticBeadSeparationSeptenaryWashMixType -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashSolutionVolume -> EqualP[100 Microliter],
            MagneticBeadSeparationWashMix -> False,
            MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[100 Microliter],
            MagneticBeadSeparationSecondaryWashMix -> False,
            MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[100 Microliter],
            MagneticBeadSeparationTertiaryWashMix -> False,
            MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[100 Microliter],
            MagneticBeadSeparationQuaternaryWashMix -> False,
            MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[100 Microliter],
            MagneticBeadSeparationQuinaryWashMix -> False,
            MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[100 Microliter],
            MagneticBeadSeparationSenaryWashMix -> False,
            MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[100 Microliter],
            MagneticBeadSeparationSeptenaryWashMix -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- MBS Wash Mix Options --- *)
    (*Test Case: WashMix is False. All wash mix options are set to Null. *)
    Example[{Options, {MagneticBeadSeparationWashMixType,MagneticBeadSeparationWashMixTime,MagneticBeadSeparationWashMixRate,NumberOfMagneticBeadSeparationWashMixes,MagneticBeadSeparationWashMixVolume,MagneticBeadSeparationWashMixTemperature,MagneticBeadSeparationWashMixTipType,MagneticBeadSeparationWashMixTipMaterial,
      MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationSecondaryWashMixTime,MagneticBeadSeparationSecondaryWashMixRate,NumberOfMagneticBeadSeparationSecondaryWashMixes,MagneticBeadSeparationSecondaryWashMixVolume,MagneticBeadSeparationSecondaryWashMixTemperature,MagneticBeadSeparationSecondaryWashMixTipType,MagneticBeadSeparationSecondaryWashMixTipMaterial,
      MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationTertiaryWashMixTime,MagneticBeadSeparationTertiaryWashMixRate,NumberOfMagneticBeadSeparationTertiaryWashMixes,MagneticBeadSeparationTertiaryWashMixVolume,MagneticBeadSeparationTertiaryWashMixTemperature,MagneticBeadSeparationTertiaryWashMixTipType,MagneticBeadSeparationTertiaryWashMixTipMaterial,
      MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuaternaryWashMixTime,MagneticBeadSeparationQuaternaryWashMixRate,NumberOfMagneticBeadSeparationQuaternaryWashMixes,MagneticBeadSeparationQuaternaryWashMixVolume,MagneticBeadSeparationQuaternaryWashMixTemperature,MagneticBeadSeparationQuaternaryWashMixTipType,MagneticBeadSeparationQuaternaryWashMixTipMaterial,
      MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationQuinaryWashMixTime,MagneticBeadSeparationQuinaryWashMixRate,NumberOfMagneticBeadSeparationQuinaryWashMixes,MagneticBeadSeparationQuinaryWashMixVolume,MagneticBeadSeparationQuinaryWashMixTemperature,MagneticBeadSeparationQuinaryWashMixTipType,MagneticBeadSeparationQuinaryWashMixTipMaterial,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSenaryWashMixTime,MagneticBeadSeparationSenaryWashMixRate,NumberOfMagneticBeadSeparationSenaryWashMixes,MagneticBeadSeparationSenaryWashMixVolume,MagneticBeadSeparationSenaryWashMixTemperature,MagneticBeadSeparationSenaryWashMixTipType,MagneticBeadSeparationSenaryWashMixTipMaterial,MagneticBeadSeparationSeptenaryWashMixType,MagneticBeadSeparationSeptenaryWashMixTime,MagneticBeadSeparationSeptenaryWashMixRate,NumberOfMagneticBeadSeparationSeptenaryWashMixes,MagneticBeadSeparationSeptenaryWashMixVolume,MagneticBeadSeparationSeptenaryWashMixTemperature,MagneticBeadSeparationSeptenaryWashMixTipType,MagneticBeadSeparationSeptenaryWashMixTipMaterial}, "If MagneticBeadSeparationWashMix is set to False, other magnetic bead separation wash mix options are automatically set to Null. Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationWashMix -> False,
        MagneticBeadSeparationSecondaryWashMix -> False,
        MagneticBeadSeparationTertiaryWashMix -> False,
        MagneticBeadSeparationQuaternaryWashMix -> False,
        MagneticBeadSeparationQuinaryWashMix -> False,
        MagneticBeadSeparationSenaryWashMix -> False,
        MagneticBeadSeparationSeptenaryWashMix -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixType->Null,
            MagneticBeadSeparationWashMixTime->Null,
            MagneticBeadSeparationWashMixRate -> Null,
            MagneticBeadSeparationWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationWashMixes->Null,
            MagneticBeadSeparationWashMixVolume->Null,
            MagneticBeadSeparationWashMixTipType->Null,
            MagneticBeadSeparationWashMixTipMaterial->Null,
            MagneticBeadSeparationSecondaryWashMixType->Null,
            MagneticBeadSeparationSecondaryWashMixTime->Null,
            MagneticBeadSeparationSecondaryWashMixRate -> Null,
            MagneticBeadSeparationSecondaryWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationSecondaryWashMixes->Null,
            MagneticBeadSeparationSecondaryWashMixVolume->Null,
            MagneticBeadSeparationSecondaryWashMixTipType->Null,
            MagneticBeadSeparationSecondaryWashMixTipMaterial->Null,
            MagneticBeadSeparationTertiaryWashMixType->Null,
            MagneticBeadSeparationTertiaryWashMixTime->Null,
            MagneticBeadSeparationTertiaryWashMixRate -> Null,
            MagneticBeadSeparationTertiaryWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationTertiaryWashMixes->Null,
            MagneticBeadSeparationTertiaryWashMixVolume->Null,
            MagneticBeadSeparationTertiaryWashMixTipType->Null,
            MagneticBeadSeparationTertiaryWashMixTipMaterial->Null,
            MagneticBeadSeparationQuaternaryWashMixType->Null,
            MagneticBeadSeparationQuaternaryWashMixTime->Null,
            MagneticBeadSeparationQuaternaryWashMixRate -> Null,
            MagneticBeadSeparationQuaternaryWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationQuaternaryWashMixes->Null,
            MagneticBeadSeparationQuaternaryWashMixVolume->Null,
            MagneticBeadSeparationQuaternaryWashMixTipType->Null,
            MagneticBeadSeparationQuaternaryWashMixTipMaterial->Null,
            MagneticBeadSeparationQuinaryWashMixType->Null,
            MagneticBeadSeparationQuinaryWashMixTime->Null,
            MagneticBeadSeparationQuinaryWashMixRate -> Null,
            MagneticBeadSeparationQuinaryWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationQuinaryWashMixes->Null,
            MagneticBeadSeparationQuinaryWashMixVolume->Null,
            MagneticBeadSeparationQuinaryWashMixTipType->Null,
            MagneticBeadSeparationQuinaryWashMixTipMaterial->Null,
            MagneticBeadSeparationSenaryWashMixType->Null,
            MagneticBeadSeparationSenaryWashMixTime->Null,
            MagneticBeadSeparationSenaryWashMixRate -> Null,
            MagneticBeadSeparationSenaryWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationSenaryWashMixes->Null,
            MagneticBeadSeparationSenaryWashMixVolume->Null,
            MagneticBeadSeparationSenaryWashMixTipType->Null,
            MagneticBeadSeparationSenaryWashMixTipMaterial->Null,
            MagneticBeadSeparationSeptenaryWashMixType->Null,
            MagneticBeadSeparationSeptenaryWashMixTime->Null,
            MagneticBeadSeparationSeptenaryWashMixRate -> Null,
            MagneticBeadSeparationSeptenaryWashMixTemperature->Null,
            NumberOfMagneticBeadSeparationSeptenaryWashMixes->Null,
            MagneticBeadSeparationSeptenaryWashMixVolume->Null,
            MagneticBeadSeparationSeptenaryWashMixTipType->Null,
            MagneticBeadSeparationSeptenaryWashMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: WashMix is True and No other options are set. Mix type is set to Pipette, and other options are resolved. *)
    Example[{Options, {MagneticBeadSeparationWashMixType,MagneticBeadSeparationWashMixTime,MagneticBeadSeparationWashMixRate,NumberOfMagneticBeadSeparationWashMixes,MagneticBeadSeparationWashMixVolume,MagneticBeadSeparationWashMixTemperature,MagneticBeadSeparationWashMixTipType,MagneticBeadSeparationWashMixTipMaterial,
      MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationSecondaryWashMixTime,MagneticBeadSeparationSecondaryWashMixRate,NumberOfMagneticBeadSeparationSecondaryWashMixes,MagneticBeadSeparationSecondaryWashMixVolume,MagneticBeadSeparationSecondaryWashMixTemperature,MagneticBeadSeparationSecondaryWashMixTipType,MagneticBeadSeparationSecondaryWashMixTipMaterial,
      MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationTertiaryWashMixTime,MagneticBeadSeparationTertiaryWashMixRate,NumberOfMagneticBeadSeparationTertiaryWashMixes,MagneticBeadSeparationTertiaryWashMixVolume,MagneticBeadSeparationTertiaryWashMixTemperature,MagneticBeadSeparationTertiaryWashMixTipType,MagneticBeadSeparationTertiaryWashMixTipMaterial,
      MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuaternaryWashMixTime,MagneticBeadSeparationQuaternaryWashMixRate,NumberOfMagneticBeadSeparationQuaternaryWashMixes,MagneticBeadSeparationQuaternaryWashMixVolume,MagneticBeadSeparationQuaternaryWashMixTemperature,MagneticBeadSeparationQuaternaryWashMixTipType,MagneticBeadSeparationQuaternaryWashMixTipMaterial,
      MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationQuinaryWashMixTime,MagneticBeadSeparationQuinaryWashMixRate,NumberOfMagneticBeadSeparationQuinaryWashMixes,MagneticBeadSeparationQuinaryWashMixVolume,MagneticBeadSeparationQuinaryWashMixTemperature,MagneticBeadSeparationQuinaryWashMixTipType,MagneticBeadSeparationQuinaryWashMixTipMaterial,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSenaryWashMixTime,MagneticBeadSeparationSenaryWashMixRate,NumberOfMagneticBeadSeparationSenaryWashMixes,MagneticBeadSeparationSenaryWashMixVolume,MagneticBeadSeparationSenaryWashMixTemperature,MagneticBeadSeparationSenaryWashMixTipType,MagneticBeadSeparationSenaryWashMixTipMaterial,MagneticBeadSeparationSeptenaryWashMixType,MagneticBeadSeparationSeptenaryWashMixTime,MagneticBeadSeparationSeptenaryWashMixRate,NumberOfMagneticBeadSeparationSeptenaryWashMixes,MagneticBeadSeparationSeptenaryWashMixVolume,MagneticBeadSeparationSeptenaryWashMixTemperature,MagneticBeadSeparationSeptenaryWashMixTipType,MagneticBeadSeparationSeptenaryWashMixTipMaterial}, "If MagneticBeadSeparationWashMix is set to True, other magnetic bead separation wash mix options are automatically set. If nothing is specified, MagneticBeadSeparationWashMixType is set to set to Pipette. When MagneticBeadSeparationWashMixType is Pipette, unless otherwise specified, 1) MagneticBeadSeparationWashMixTime and MagneticBeadSeparationWashMixRateare set to Null, 2) NumberOfMagneticBeadSeparationWashMixes is set to 20, 3) MagneticBeadSeparationWashMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationWashSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationWashSolutionVolume and magnetic beads volume, 4) MagneticBeadSeparationWashMixTipType is set to WideBore, 5) MagneticBeadSeparationWashMixTipMaterial is set to Polypropylene, 6) MagneticBeadSeparationWashMixTemperature is set to Ambient. Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationWashMix -> True,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSecondaryWashMix -> True,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationTertiaryWashMix -> True,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuaternaryWashMix -> True,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuinaryWashMix -> True,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSenaryWashMix -> True,
        MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSeptenaryWashMix -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixType -> Pipette,
            MagneticBeadSeparationWashMixTime->Null,
            MagneticBeadSeparationWashMixRate -> Null,
            MagneticBeadSeparationWashMixTemperature-> Ambient,
            MagneticBeadSeparationWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationWashMixes -> 20,
            MagneticBeadSeparationWashMixTipType -> WideBore,
            MagneticBeadSeparationWashMixTipMaterial -> Polypropylene,
            MagneticBeadSeparationSecondaryWashMixType -> Pipette,
            MagneticBeadSeparationSecondaryWashMixTime->Null,
            MagneticBeadSeparationSecondaryWashMixRate -> Null,
            MagneticBeadSeparationSecondaryWashMixTemperature-> Ambient,
            MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationSecondaryWashMixes -> 20,
            MagneticBeadSeparationSecondaryWashMixTipType -> WideBore,
            MagneticBeadSeparationSecondaryWashMixTipMaterial -> Polypropylene,
            MagneticBeadSeparationTertiaryWashMixType -> Pipette,
            MagneticBeadSeparationTertiaryWashMixTime->Null,
            MagneticBeadSeparationTertiaryWashMixRate -> Null,
            MagneticBeadSeparationTertiaryWashMixTemperature-> Ambient,
            MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationTertiaryWashMixes -> 20,
            MagneticBeadSeparationTertiaryWashMixTipType -> WideBore,
            MagneticBeadSeparationTertiaryWashMixTipMaterial -> Polypropylene,
            MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
            MagneticBeadSeparationQuaternaryWashMixTime->Null,
            MagneticBeadSeparationQuaternaryWashMixRate -> Null,
            MagneticBeadSeparationQuaternaryWashMixTemperature-> Ambient,
            MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 20,
            MagneticBeadSeparationQuaternaryWashMixTipType -> WideBore,
            MagneticBeadSeparationQuaternaryWashMixTipMaterial -> Polypropylene,
            MagneticBeadSeparationQuinaryWashMixType -> Pipette,
            MagneticBeadSeparationQuinaryWashMixTime->Null,
            MagneticBeadSeparationQuinaryWashMixRate -> Null,
            MagneticBeadSeparationQuinaryWashMixTemperature-> Ambient,
            MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationQuinaryWashMixes -> 20,
            MagneticBeadSeparationQuinaryWashMixTipType -> WideBore,
            MagneticBeadSeparationQuinaryWashMixTipMaterial -> Polypropylene,
            MagneticBeadSeparationSenaryWashMixType -> Pipette,
            MagneticBeadSeparationSenaryWashMixTime->Null,
            MagneticBeadSeparationSenaryWashMixRate -> Null,
            MagneticBeadSeparationSenaryWashMixTemperature-> Ambient,
            MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationSenaryWashMixes -> 20,
            MagneticBeadSeparationSenaryWashMixTipType -> WideBore,
            MagneticBeadSeparationSenaryWashMixTipMaterial -> Polypropylene,
            MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
            MagneticBeadSeparationSeptenaryWashMixTime->Null,
            MagneticBeadSeparationSeptenaryWashMixRate -> Null,
            MagneticBeadSeparationSeptenaryWashMixTemperature-> Ambient,
            MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 20,
            MagneticBeadSeparationSeptenaryWashMixTipType -> WideBore,
            MagneticBeadSeparationSeptenaryWashMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: WashMix is True and some pipetting options are set: MagneticBeadSeparationWashMixType->Pipette, another resolution scenario for mix volume when current volume is larger*)
    Example[{Options, {MagneticBeadSeparationWashMixType,MagneticBeadSeparationWashMixVolume,MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationSecondaryWashMixVolume,MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationTertiaryWashMixVolume,MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuaternaryWashMixVolume,MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationQuinaryWashMixVolume,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSenaryWashMixVolume,MagneticBeadSeparationSeptenaryWashMixType,MagneticBeadSeparationSeptenaryWashMixVolume}, "If MagneticBeadSeparationWashMix is set to True, other magnetic bead separation wash mix options are automatically set. 1) Unless otherwise specified, MagneticBeadSeparationWashMixType is set to Pipette if any of the pipetting options are set. 2) When MagneticBeadSeparationWashMixType is Pipette, unless otherwise specified, MagneticBeadSeparationWashMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationWashSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationWashMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL). Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadVolume -> 1.0 Milliliter,
        MagneticBeadSeparationWashMixTipType -> WideBore,
        MagneticBeadSeparationWashSolutionVolume -> 1.0 Milliliter,
        MagneticBeadSeparationSecondaryWashMixTipType -> WideBore,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 1.0 Milliliter,
        MagneticBeadSeparationTertiaryWashMixTipType -> WideBore,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 1.0 Milliliter,
        MagneticBeadSeparationQuaternaryWashMixTipType -> WideBore,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 1.0 Milliliter,
        MagneticBeadSeparationQuinaryWashMixTipType -> WideBore,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 1.0 Milliliter,
        MagneticBeadSeparationSenaryWashMixTipType -> WideBore,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 1.0 Milliliter,
        MagneticBeadSeparationSeptenaryWashMixTipType -> WideBore,
        MagneticBeadSeparationSeptenaryWashSolutionVolume -> 1.0 Milliliter,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixType -> Pipette,
            MagneticBeadSeparationWashMixVolume -> EqualP[0.970 Milliliter], 
            MagneticBeadSeparationSecondaryWashMixType -> Pipette,
            MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.970 Milliliter],
            MagneticBeadSeparationTertiaryWashMixType -> Pipette,
            MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.970 Milliliter],
            MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
            MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.970 Milliliter],
            MagneticBeadSeparationQuinaryWashMixType -> Pipette,
            MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.970 Milliliter],
            MagneticBeadSeparationSenaryWashMixType -> Pipette,
            MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.970 Milliliter],
            MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
            MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.970 Milliliter]
            
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: WashMix is True and some shaking options are set: MagneticBeadSeparationWashMixType->Shake*)
    Example[{Options, {MagneticBeadSeparationWashMixType,MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSeptenaryWashMixType}, "If MagneticBeadSeparationWashMix is set to True and shaking options are set, MagneticBeadSeparationWashMixType is automatically set to Shake. Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixRate -> 200 RPM,
        MagneticBeadSeparationSecondaryWashMixTime -> 5 Minute,
        MagneticBeadSeparationTertiaryWashMixTemperature -> 20 Celsius,
        MagneticBeadSeparationQuaternaryWashMixRate -> 200 RPM,
        MagneticBeadSeparationQuinaryWashMixTime -> 5 Minute,
        MagneticBeadSeparationSenaryWashMixTemperature -> 20 Celsius,
        MagneticBeadSeparationSeptenaryWashMixRate -> 200 RPM,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixType -> Shake,
            MagneticBeadSeparationSecondaryWashMixType -> Shake,
            MagneticBeadSeparationTertiaryWashMixType -> Shake,
            MagneticBeadSeparationQuaternaryWashMixType -> Shake,
            MagneticBeadSeparationQuinaryWashMixType -> Shake,
            MagneticBeadSeparationSenaryWashMixType -> Shake,
            MagneticBeadSeparationSeptenaryWashMixType -> Shake
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: MagneticBeadSeparationWashMixType->Shake and nothing is specified *)
    Example[{Options, {MagneticBeadSeparationWashMixType,MagneticBeadSeparationWashMixTime,MagneticBeadSeparationWashMixRate,NumberOfMagneticBeadSeparationWashMixes,MagneticBeadSeparationWashMixVolume,MagneticBeadSeparationWashMixTemperature,MagneticBeadSeparationWashMixTipType,MagneticBeadSeparationWashMixTipMaterial,
      MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationSecondaryWashMixTime,MagneticBeadSeparationSecondaryWashMixRate,NumberOfMagneticBeadSeparationSecondaryWashMixes,MagneticBeadSeparationSecondaryWashMixVolume,MagneticBeadSeparationSecondaryWashMixTemperature,MagneticBeadSeparationSecondaryWashMixTipType,MagneticBeadSeparationSecondaryWashMixTipMaterial,
      MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationTertiaryWashMixTime,MagneticBeadSeparationTertiaryWashMixRate,NumberOfMagneticBeadSeparationTertiaryWashMixes,MagneticBeadSeparationTertiaryWashMixVolume,MagneticBeadSeparationTertiaryWashMixTemperature,MagneticBeadSeparationTertiaryWashMixTipType,MagneticBeadSeparationTertiaryWashMixTipMaterial,
      MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuaternaryWashMixTime,MagneticBeadSeparationQuaternaryWashMixRate,NumberOfMagneticBeadSeparationQuaternaryWashMixes,MagneticBeadSeparationQuaternaryWashMixVolume,MagneticBeadSeparationQuaternaryWashMixTemperature,MagneticBeadSeparationQuaternaryWashMixTipType,MagneticBeadSeparationQuaternaryWashMixTipMaterial,
      MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationQuinaryWashMixTime,MagneticBeadSeparationQuinaryWashMixRate,NumberOfMagneticBeadSeparationQuinaryWashMixes,MagneticBeadSeparationQuinaryWashMixVolume,MagneticBeadSeparationQuinaryWashMixTemperature,MagneticBeadSeparationQuinaryWashMixTipType,MagneticBeadSeparationQuinaryWashMixTipMaterial,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSenaryWashMixTime,MagneticBeadSeparationSenaryWashMixRate,NumberOfMagneticBeadSeparationSenaryWashMixes,MagneticBeadSeparationSenaryWashMixVolume,MagneticBeadSeparationSenaryWashMixTemperature,MagneticBeadSeparationSenaryWashMixTipType,MagneticBeadSeparationSenaryWashMixTipMaterial,MagneticBeadSeparationSeptenaryWashMixType,MagneticBeadSeparationSeptenaryWashMixTime,MagneticBeadSeparationSeptenaryWashMixRate,NumberOfMagneticBeadSeparationSeptenaryWashMixes,MagneticBeadSeparationSeptenaryWashMixVolume,MagneticBeadSeparationSeptenaryWashMixTemperature,MagneticBeadSeparationSeptenaryWashMixTipType,MagneticBeadSeparationSeptenaryWashMixTipMaterial}, "If MagneticBeadSeparationWashMixType is Shake, unless otherwise specified,1) pipetting options are set to Null, 2) MagneticBeadSeparationWashMixTime set to 5 Minute, 3) MagneticBeadSeparationWashMixTemperature is set to 5 Minute. Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Shake,
        MagneticBeadSeparationSecondaryWashMixType -> Shake,
        MagneticBeadSeparationTertiaryWashMixType -> Shake,
        MagneticBeadSeparationQuaternaryWashMixType -> Shake,
        MagneticBeadSeparationQuinaryWashMixType -> Shake,
        MagneticBeadSeparationSenaryWashMixType -> Shake,
        MagneticBeadSeparationSeptenaryWashMixType -> Shake,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationWashMixes->Null,
            MagneticBeadSeparationWashMixVolume->Null,
            MagneticBeadSeparationWashMixTipType->Null,
            MagneticBeadSeparationWashMixTipMaterial->Null,
            MagneticBeadSeparationSecondaryWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationSecondaryWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationSecondaryWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationSecondaryWashMixes->Null,
            MagneticBeadSeparationSecondaryWashMixVolume->Null,
            MagneticBeadSeparationSecondaryWashMixTipType->Null,
            MagneticBeadSeparationSecondaryWashMixTipMaterial->Null,
            MagneticBeadSeparationTertiaryWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationTertiaryWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationTertiaryWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationTertiaryWashMixes->Null,
            MagneticBeadSeparationTertiaryWashMixVolume->Null,
            MagneticBeadSeparationTertiaryWashMixTipType->Null,
            MagneticBeadSeparationTertiaryWashMixTipMaterial->Null,
            MagneticBeadSeparationQuaternaryWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationQuaternaryWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationQuaternaryWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationQuaternaryWashMixes->Null,
            MagneticBeadSeparationQuaternaryWashMixVolume->Null,
            MagneticBeadSeparationQuaternaryWashMixTipType->Null,
            MagneticBeadSeparationQuaternaryWashMixTipMaterial->Null,
            MagneticBeadSeparationQuinaryWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationQuinaryWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationQuinaryWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationQuinaryWashMixes->Null,
            MagneticBeadSeparationQuinaryWashMixVolume->Null,
            MagneticBeadSeparationQuinaryWashMixTipType->Null,
            MagneticBeadSeparationQuinaryWashMixTipMaterial->Null,
            MagneticBeadSeparationSenaryWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationSenaryWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationSenaryWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationSenaryWashMixes->Null,
            MagneticBeadSeparationSenaryWashMixVolume->Null,
            MagneticBeadSeparationSenaryWashMixTipType->Null,
            MagneticBeadSeparationSenaryWashMixTipMaterial->Null,
            MagneticBeadSeparationSeptenaryWashMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationSeptenaryWashMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationSeptenaryWashMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationSeptenaryWashMixes->Null,
            MagneticBeadSeparationSeptenaryWashMixVolume->Null,
            MagneticBeadSeparationSeptenaryWashMixTipType->Null,
            MagneticBeadSeparationSeptenaryWashMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options, {MagneticBeadSeparationWashAirDry, MagneticBeadSeparationSecondaryWashAirDry, MagneticBeadSeparationTertiaryWashAirDry, MagneticBeadSeparationQuaternaryWashAirDry, MagneticBeadSeparationQuinaryWashAirDry, MagneticBeadSeparationSenaryWashAirDry, MagneticBeadSeparationSeptenaryWashAirDryTime}, "If MagneticBeadSeparationWashAirDry is set to True, MagneticBeadSeparationWashAirDryTime is automatically set to 1 Minute. Options of the 7 different wash stages are resolved similarly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashAirDry -> True,
        MagneticBeadSeparationSecondaryWashAirDry -> True,
        MagneticBeadSeparationTertiaryWashAirDry -> True,
        MagneticBeadSeparationQuaternaryWashAirDry -> True,
        MagneticBeadSeparationQuinaryWashAirDry -> True,
        MagneticBeadSeparationSenaryWashAirDry -> True,
        MagneticBeadSeparationSeptenaryWashAirDry -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationWashAirDryTime -> EqualP[1 Minute],
            MagneticBeadSeparationSecondaryWashAirDryTime -> EqualP[1 Minute],
            MagneticBeadSeparationTertiaryWashAirDryTime -> EqualP[1 Minute],
            MagneticBeadSeparationQuaternaryWashAirDryTime -> EqualP[1 Minute],
            MagneticBeadSeparationQuinaryWashAirDryTime -> EqualP[1 Minute],
            MagneticBeadSeparationSenaryWashAirDryTime -> EqualP[1 Minute],
            MagneticBeadSeparationSeptenaryWashAirDryTime -> EqualP[1 Minute]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- MBS Elution Options -- *)
    (* --- MBS Elution General Options --- *)
    (*Test Case: If Elution is False, stage options are set to Null*)
    Example[{Options, {MagneticBeadSeparationElutionSolution,MagneticBeadSeparationElutionSolutionVolume,MagneticBeadSeparationElutionMix,ElutionMagnetizationTime,MagneticBeadSeparationElutionAspirationVolume,MagneticBeadSeparationElutionCollectionContainer,MagneticBeadSeparationElutionCollectionStorageCondition,NumberOfMagneticBeadSeparationElutions}, "If Purification contains MagneticBeadSeparation and MagneticBeadSeparationElution is set to False, unless otherwise specified, all Elution options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationElution -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionSolution->Null,
            MagneticBeadSeparationElutionSolutionVolume->Null,
            MagneticBeadSeparationElutionMix->Null,
            ElutionMagnetizationTime->Null,
            MagneticBeadSeparationElutionAspirationVolume->Null,
            MagneticBeadSeparationElutionCollectionContainer-> Null,
            MagneticBeadSeparationElutionCollectionStorageCondition->Null,
            NumberOfMagneticBeadSeparationElutions->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: If Elution is True, stage options are resolved to default*)
    Example[{Options, {MagneticBeadSeparationElutionSolution,MagneticBeadSeparationElutionSolutionVolume,MagneticBeadSeparationElutionMix,ElutionMagnetizationTime,MagneticBeadSeparationElutionAspirationVolume,MagneticBeadSeparationElutionCollectionContainer,
      MagneticBeadSeparationElutionCollectionContainerLabel,MagneticBeadSeparationElutionCollectionStorageCondition,NumberOfMagneticBeadSeparationElutions}, "If MagneticBeadSeparationElution is set to True, unless otherwise specified, 1) MagneticBeadSeparationElutionSolution is set to Model[Sample,\"50 mM Glycine pH 2.8, sterile filtered\"], 2) MagneticBeadSeparationElutionSolutionVolume is set to 1/10 of the MagneticBeadSeparationSampleVolume, 3) MagneticBeadSeparationElutionMix is set to True if MagneticBeadSeparationElutionMixType is not set to Null, 4) ElutionMagnetizationTime is automatically set to 5 minutes, 5) MagneticBeadSeparationElutionAspirationVolume is set to the MagneticBeadSeparationElutionSolutionVolume , 6) MagneticBeadSeparationElutionCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"], 7) MagneticBeadSeparationElutionCollectionContainer is automatically generated, 8) MagneticBeadSeparationElutionCollectionStorageCondition is set to Refrigerator, 9) NumberOfMagneticBeadSeparationElutions is set to 1, 10) MagneticBeadSeparationElutionAirDry is automatically set to False:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionSolution -> ObjectP[Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"]],(*"id:eGakldadjlEe"50 mM Glycine pH 2.8, sterile filtered*)
            MagneticBeadSeparationElutionSolutionVolume -> EqualP[0.02 Milliliter],
            MagneticBeadSeparationElutionMix -> True,
            ElutionMagnetizationTime -> EqualP[5 Minute],
            MagneticBeadSeparationElutionAspirationVolume -> EqualP[0.02 Milliliter],
            MagneticBeadSeparationElutionCollectionContainer ->{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]},
            MagneticBeadSeparationElutionCollectionContainerLabel -> {(_String)},
            MagneticBeadSeparationElutionCollectionStorageCondition -> Refrigerator,
            NumberOfMagneticBeadSeparationElutions -> 1
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: If Elution is True, another possible resolution for Mix when MixType is Null*)
    Example[{Options, {MagneticBeadSeparationElutionSolution,MagneticBeadSeparationElutionMix}, "If MagneticBeadSeparationElution is set to True, unless otherwise specified, MagneticBeadSeparationElutionMix is set to False if MagneticBeadSeparationElutionMixType is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        MagneticBeadSeparationElutionMixType -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMix -> False
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* --- MBS Elution Mix Options --- *)
    (*Test Case: ElutionMix is False. All elution mix options are set to Null. *)
    Example[{Options, {MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionMixTime,MagneticBeadSeparationElutionMixRate,NumberOfMagneticBeadSeparationElutionMixes,MagneticBeadSeparationElutionMixVolume,MagneticBeadSeparationElutionMixTemperature,MagneticBeadSeparationElutionMixTipType,MagneticBeadSeparationElutionMixTipMaterial}, "If MagneticBeadSeparationElutionMix is set to False, other magnetic bead separation elution mix options are automatically set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationElutionMix -> False,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixType->Null,
            MagneticBeadSeparationElutionMixTime->Null,
            MagneticBeadSeparationElutionMixRate -> Null,
            MagneticBeadSeparationElutionMixTemperature->Null,
            NumberOfMagneticBeadSeparationElutionMixes->Null,
            MagneticBeadSeparationElutionMixVolume->Null,
            MagneticBeadSeparationElutionMixTipType->Null,
            MagneticBeadSeparationElutionMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: ElutionMix is True and No other options are set. Mix type is set to Pipette, and other options are resolved. *)
    Example[{Options, {MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionMixTime,MagneticBeadSeparationElutionMixRate,NumberOfMagneticBeadSeparationElutionMixes,MagneticBeadSeparationElutionMixVolume,MagneticBeadSeparationElutionMixTemperature,MagneticBeadSeparationElutionMixTipType,MagneticBeadSeparationElutionMixTipMaterial}, "If MagneticBeadSeparationElutionMix is set to True, other magnetic bead separation elution mix options are automatically set. If nothing is specified, MagneticBeadSeparationElutionMixType is set to set to Pipette. When MagneticBeadSeparationElutionMixType is Pipette, unless otherwise specified, 1) MagneticBeadSeparationElutionMixTime and MagneticBeadSeparationElutionMixRateare set to Null, 2) NumberOfMagneticBeadSeparationElutionMixes is set to 20, 3) MagneticBeadSeparationElutionMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationElutionSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationElutionMixVolume is automatically set to 80% of the combined MagneticBeadSeparationElutionSolutionVolume and magnetic beads volume, 4) MagneticBeadSeparationElutionMixTipType is set to WideBore, 5) MagneticBeadSeparationElutionMixTipMaterial is set to Polypropylene, 6) MagneticBeadSeparationElutionMixTemperature is set to Ambient:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationElutionMix -> True,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixType -> Pipette,
            MagneticBeadSeparationElutionMixTime->Null,
            MagneticBeadSeparationElutionMixRate -> Null,
            MagneticBeadSeparationElutionMixTemperature-> Ambient,
            MagneticBeadSeparationElutionMixVolume -> EqualP[0.32 Milliliter],
            NumberOfMagneticBeadSeparationElutionMixes -> 20,
            MagneticBeadSeparationElutionMixTipType -> WideBore,
            MagneticBeadSeparationElutionMixTipMaterial -> Polypropylene
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: ElutionMix is True and some pipetting options are set: MagneticBeadSeparationElutionMixType->Pipette, another resolution scenario for mix volume when current volume is larger*)
    Example[{Options, {MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionMixVolume}, "If MagneticBeadSeparationElutionMix is set to True, other magnetic bead separation elution mix options are automatically set. 1) Unless otherwise specified, MagneticBeadSeparationElutionMixType is set to Pipette if any of the pipetting options are set. 2) When MagneticBeadSeparationElutionMixType is Pipette, unless otherwise specified, MagneticBeadSeparationElutionMixVolume is set based on current volume: if 80% of the combined MagneticBeadSeparationElutionSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationElutionMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL):"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixTipType -> WideBore,
        MagneticBeadVolume -> 1.0 Milliliter,
        MagneticBeadSeparationElutionSolutionVolume -> 1.0 Milliliter,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixType -> Pipette,
            MagneticBeadSeparationElutionMixVolume -> EqualP[0.970 Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: ElutionMix is True and some shaking options are set: MagneticBeadSeparationElutionMixType->Shake*)
    Example[{Options, MagneticBeadSeparationElutionMixType, "If MagneticBeadSeparationElutionMix is set to True and shaking options are set, MagneticBeadSeparationElutionMixType is automatically set to Shake:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixRate -> 200 RPM,
        Method -> Custom,
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
      TimeConstraint -> 1800
    ],
    (*Test Case: MagneticBeadSeparationElutionMixType->Shake and nothing is specified *)
    Example[{Options, {MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionMixTime,MagneticBeadSeparationElutionMixRate,NumberOfMagneticBeadSeparationElutionMixes,MagneticBeadSeparationElutionMixVolume,MagneticBeadSeparationElutionMixTemperature,MagneticBeadSeparationElutionMixTipType,MagneticBeadSeparationElutionMixTipMaterial}, "If MagneticBeadSeparationElutionMixType is Shake, unless otherwise specified,1) pipetting options are set to Null, 2) MagneticBeadSeparationElutionMixTime set to 5 Minute, 3) MagneticBeadSeparationElutionMixTemperature is set to 5 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Shake,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            MagneticBeadSeparationElutionMixTime-> EqualP[5 Minute],
            MagneticBeadSeparationElutionMixRate -> EqualP[300 RPM],
            MagneticBeadSeparationElutionMixTemperature-> Ambient,
            NumberOfMagneticBeadSeparationElutionMixes->Null,
            MagneticBeadSeparationElutionMixVolume->Null,
            MagneticBeadSeparationElutionMixTipType->Null,
            MagneticBeadSeparationElutionMixTipMaterial->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- Other MBS tests for nested-index matching complex options to make sure they comply with our Bio experiments -- *)

    (* -- NumberOfMagneticBeadSeparationElutions Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationElutions, "If NumberOfMagneticBeadSeparationElutions is set to larger than 1, samples collected from multiple rounds are pooled to one container (and to one well if applicable):"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Method -> Custom,
        NumberOfMagneticBeadSeparationElutions -> 3,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationElutions -> 3,
            MagneticBeadSeparationElutionCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationElutions for multiple samples Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationElutions, "If NumberOfMagneticBeadSeparationElutions is set to larger than 1 for multiple samples, samples collected from multiple rounds are pooled to one container (and to one well if applicable):"},
      ExperimentExtractProtein[
        {Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
          Object[Sample,"ExperimentExtractProtein Lysate Sample " <> $SessionUUID]},
        Method -> Custom,
        NumberOfMagneticBeadSeparationElutions -> 3,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfMagneticBeadSeparationElutions -> 3,
            MagneticBeadSeparationElutionCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}..}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (* -- MagneticBeadSeparation collection container formats -- *)
    Example[{Options, {MagneticBeadSeparationPreWashCollectionContainer,MagneticBeadSeparationEquilibrationCollectionContainer,MagneticBeadSeparationLoadingCollectionContainer,MagneticBeadSeparationWashCollectionContainer,MagneticBeadSeparationSecondaryWashCollectionContainer,MagneticBeadSeparationElutionCollectionContainer}, "The collection containers can be specied in a variety of formats for all stages of magnetic bead separation:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationPreWashCollectionContainer -> {"A1", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
        NumberOfMagneticBeadSeparationPreWashes -> 2,
        MagneticBeadSeparationEquilibrationCollectionContainer -> {"A2", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
        MagneticBeadSeparationLoadingCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        MagneticBeadSeparationWashCollectionContainer -> {"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
        NumberOfMagneticBeadSeparationWashes -> 1,
        MagneticBeadSeparationSecondaryWashCollectionContainer -> {"A1", {2, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
        NumberOfMagneticBeadSeparationSecondaryWashes -> 3,
        NumberOfMagneticBeadSeparationElutions -> 2,
        MagneticBeadSeparationElutionCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        Output -> Result],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],
    (* -- MagneticBeadSeparation collection container formats -- *)
    Example[{Options, {MagneticBeadSeparationPreWashCollectionContainer,MagneticBeadSeparationEquilibrationCollectionContainer,MagneticBeadSeparationLoadingCollectionContainer,MagneticBeadSeparationWashCollectionContainer,MagneticBeadSeparationSecondaryWashCollectionContainer,MagneticBeadSeparationElutionCollectionContainer}, "For multiple input samples, the collection containers can be specied in a variety of formats for all stages of magnetic bead separation:"},
      ExperimentExtractProtein[{
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Object[Sample, "ExperimentExtractProtein Lysate Sample " <> $SessionUUID]
      },
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationPreWashCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        NumberOfMagneticBeadSeparationPreWashes -> 2,
        MagneticBeadSeparationEquilibrationCollectionContainer -> {{"A2", Model[Container, Plate,
          "96-well 2mL Deep Well Plate, Sterile"]}, {"A1",Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
        MagneticBeadSeparationLoadingCollectionContainer -> {"A1", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
        MagneticBeadSeparationWashCollectionContainer -> {"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
        NumberOfMagneticBeadSeparationWashes -> 1,
        MagneticBeadSeparationSecondaryWashCollectionContainer -> {{"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}}, {"A2", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}}},
        NumberOfMagneticBeadSeparationSecondaryWashes -> 3,
        NumberOfMagneticBeadSeparationElutions -> 2,
        MagneticBeadSeparationElutionCollectionContainer -> {Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],

    (* - Shared Precipitation Tests - *)
    Example[{Basic, "Crude samples can be purified with precipitation:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> Precipitation,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],

    (* Testing Stages: General, Mix, Filter, Pellet, Wash, Resuspension, SamplePostprocessing. *)

    (* -- Precipitation General Options -- *)

    (*Test Case: Overall strategy and solutions. Default resolutions when nothing is set. *)
    Example[{Options, {PrecipitationTargetPhase,PrecipitationReagent, PrecipitationReagentVolume, PrecipitationReagentTemperature, PrecipitationReagentEquilibrationTime,PrecipitationTime, PrecipitationInstrument, PrecipitationTemperature}, "If Purification contains Precipitation, if no precipitation option is specified, 1) PrecipitationTargetPhase is set to Solid, 2) when PrecipitationTargetPhase is Solid, PrecipitationReagent is set to Model[Sample,\"Isopropanol\"], 3) PrecipitationReagentVolume is set to the lesser of 50% of the sample volume and the MaxVolume of the sample container, 4) PrecipitationReagentTemperature is set to Ambient, 5) PrecipitationReagentEquilibrationTime is set to 5 Minutes, 6) PrecipitationTime is set to 15 Minutes, 7) PrecipitationInstrument is set to Model[Instrument, HeatBlock, \"Inheco ThermoshakeAC\"] when PrecipitationTemperature is not greater than 70 Celsius, 8) PrecipitationTemperature is set to Ambient when Precipitation Time is set to greater than 0 Minutes:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationTargetPhase -> Solid,
            PrecipitationReagent -> ObjectP[Model[Sample, StockSolution, "id:zGj91a7v1Lob"]],(*"TCA (10%, w/v) in acetone with 2-mercaptoethanol (0.07%)"*)
            PrecipitationReagentVolume -> EqualP[0.1 Milliliter],
            PrecipitationReagentTemperature -> Ambient,
            PrecipitationReagentEquilibrationTime -> EqualP[5 Minute],
            PrecipitationTime -> EqualP[15 Minute],
            PrecipitationInstrument -> ObjectP[Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]],(*Model[Instrument, HeatBlock, "Inheco ThermoshakeAC"]*)
            PrecipitationTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Overall strategy and solutions. Alternative Resolution when targeting liquid phase and Precipitation time is 0. *)
    Example[{Options, {PrecipitationReagent, PrecipitationInstrument, PrecipitationTemperature}, "If Purification contains Precipitation, unless otherwise specified, 1) PrecipitationReagent is set to Model[Sample, StockSolution, \"5M Sodium Chloride\"] if PrecipitationTargetPhase is set to Liquid, 2) PrecipitationInstrument is set to Null if PrecipitationTime is set to 0 Minutes, 3) PrecipitationTemperature is set to Null if PrecipitationTime is set to 0 Minutes:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Liquid,
        PrecipitationTime -> 0 Minute,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationReagent -> ObjectP[Model[Sample,StockSolution,"id:AEqRl954GJb6"]],(*Model[Sample, StockSolution, "5M Sodium Chloride"]*)
            PrecipitationInstrument -> Null,
            PrecipitationTemperature -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Overall strategy and solutions. Alternative Resolution when Precipitation temperature is high. *)
    Example[{Options, PrecipitationInstrument, "PrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationTemperature is set to greater than 70 Celsius:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTemperature -> 80 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationInstrument -> ObjectP[Model[Instrument,Shaker,"id:eGakldJkWVnz"]]}]
      },(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],

    (*Test Case: Stage Masterswitches. Default resolutions when nothing is set, i.e. TargetPhase is Solid *)
    Example[{Options, {PrecipitationSeparationTechnique,PrecipitationMixType,PrecipitationNumberOfWashes,PrecipitationDryingTemperature,PrecipitationDryingTime,PrecipitationResuspensionBuffer}, "If Purification contains Precipitation and PrecipitationTargetPhase is set to Solid by default, if no other precipitation option is specified, 1) PrecipitationSeparationTechnique is set to Pellet, 2) PrecipitationMixType is set to Shake when neither PrecipitationMixVolume or NumberOfPrecipitationMixes are set, 3) PrecipitationNumberOfWashes is set to 3, 4) PrecipitationDryingTemperature is set to Ambient, 5) PrecipitationDryingTime is set to 20 Minutes, 6) PrecipitationResuspensionBuffer is set to Model[Sample, StockSolution, \"1x TE Buffer\"]:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationTargetPhase -> Solid,
            PrecipitationSeparationTechnique -> Pellet,
            PrecipitationMixType -> Shake,
            PrecipitationNumberOfWashes -> 3,
            PrecipitationDryingTemperature -> Ambient,
            PrecipitationDryingTime -> EqualP[20 Minute],
            PrecipitationResuspensionBuffer -> ObjectP[Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"]](*"RIPA Lysis Buffer with protease inhibitor cocktail"*)
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Stage Masterswitches. Alternative resolutions when TargetPhase is Liquid *)
    Example[{Options, {PrecipitationSeparationTechnique,PrecipitationMixType,PrecipitationNumberOfWashes,PrecipitationDryingTemperature,PrecipitationDryingTime,PrecipitationResuspensionBuffer}, "If Purification contains Precipitation and PrecipitationTargetPhase is set to Liquid, if no other precipitation option is specified, 1) PrecipitationSeparationTechnique is set to Pellet, 2) PrecipitationMixType is set to Shake when neither PrecipitationMixVolume or NumberOfPrecipitationMixes are set, 3) PrecipitationNumberOfWashes is set to 0, 4) PrecipitationDryingTemperature and PrecipitationDryingTime are set to Null, 5) PrecipitationResuspensionBuffer is set to None:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Liquid,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationSeparationTechnique -> Pellet,
            PrecipitationMixType -> Shake,
            PrecipitationNumberOfWashes -> 0,
            PrecipitationDryingTemperature -> Null,
            PrecipitationDryingTime -> Null,
            PrecipitationResuspensionBuffer -> None
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- Precipitation Mix Options -- *)
    (*Test Case: MixType is set to pipette if pipette-only options are set *)
    Example[{Options, {PrecipitationMixType,PrecipitationMixInstrument,PrecipitationMixRate,PrecipitationMixTemperature,PrecipitationMixTime,NumberOfPrecipitationMixes}, "If Purification contains Precipitation and any pipette mixing option is set (PrecipitationMixVolume or NumberOfPrecipitationMixes), unless otherwise specified, PrecipitationMixType is set to Pipette and other shake options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixVolume -> 100 Microliter,
        PrecipitationMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationMixInstrument -> Null,
          PrecipitationMixRate -> Null,
          PrecipitationMixTemperature -> Null,
          PrecipitationMixTime -> Null
        }]
      },
      TimeConstraint -> 1200
    ],

    (*Test Case: MixType is None. all other options are Null. *)
    Example[{Options, {PrecipitationMixType,PrecipitationMixInstrument,PrecipitationMixRate,PrecipitationMixTemperature,PrecipitationMixTime,NumberOfPrecipitationMixes}, "If Purification contains Precipitation and PrecipitationMixType is set to None, unless otherwise specified, all other precipitation mix options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationMixInstrument -> Null,
          PrecipitationMixRate -> Null,
          PrecipitationMixTemperature -> Null,
          PrecipitationMixTime -> Null,
          NumberOfPrecipitationMixes -> Null
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: MixType is Pipette. Pipette options are set to default. Shake options are Null. *)
    Example[{Options, {PrecipitationMixInstrument,PrecipitationMixRate,PrecipitationMixTemperature,PrecipitationMixTime,NumberOfPrecipitationMixes}, "If Purification contains Precipitation and PrecipitationMixType is set to Pipette, unless otherwise specified, 1) PrecipitationMixVolume is set to 50% of the sample volume if $MaxRoboticSingleTransferVolume is more than 50% of the sample volume, 2) NumberOfPrecipitationMixes is set to 10, 3) all other shake options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Pipette,
        PrecipitationReagentVolume -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationMixVolume -> EqualP[150 Microliter],
          PrecipitationMixInstrument -> Null,
          PrecipitationMixRate -> Null,
          PrecipitationMixTemperature -> Null,
          PrecipitationMixTime -> Null,
          NumberOfPrecipitationMixes -> 10
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: MixType is Shake. Pipette options are set to Null. Shake options are set to default. *)
    Example[{Options, {PrecipitationMixInstrument,PrecipitationMixRate,PrecipitationMixTemperature,PrecipitationMixTime,NumberOfPrecipitationMixes}, "If Purification contains Precipitation and PrecipitationMixType is set to Shake, unless otherwise specified, 1) PrecipitationMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"], 2) PrecipitationMixRate is set to 300 RPM, 3) PrecipitationMixTemperature is set to Ambient, 4) PrecipitationMixTime is set to 15 Minutes, 5) all other pipette options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationMixVolume -> Null,
         PrecipitationMixInstrument -> ObjectP[Model[Instrument,Shaker,"id:pZx9jox97qNp"]],(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
          PrecipitationMixRate -> EqualP[300 RPM],
          PrecipitationMixTemperature -> Ambient,
          PrecipitationMixTime -> EqualP[15 Minute],
          NumberOfPrecipitationMixes -> Null
        }]
      },
      TimeConstraint -> 1200
    ],

    (* -- Precipitation Filter Options -- *)
    (*Test Case:PrecipitationSeparationTechnique is Pellet. No filter options are set*)
    Example[{Options, {PrecipitationFiltrationInstrument,PrecipitationFiltrationTechnique,PrecipitationFilter,PrecipitationPrefilterPoreSize,PrecipitationPrefilterMembraneMaterial,PrecipitationPoreSize,PrecipitationMembraneMaterial,PrecipitationFilterPosition,PrecipitationFiltrationTime,PrecipitationFiltrateVolume,PrecipitationFilterStorageCondition}, "If PrecipitationSeparationTechnique is set to Pellet, unless otherwise specified, all purification filter options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationFiltrationInstrument -> Null,
          PrecipitationFiltrationTechnique -> Null,
          PrecipitationFilter -> Null,
          PrecipitationPrefilterPoreSize -> Null,
          PrecipitationPrefilterMembraneMaterial -> Null,
          PrecipitationPoreSize -> Null,
          PrecipitationMembraneMaterial -> Null,
          PrecipitationFilterPosition -> Null,
          PrecipitationFiltrationTime -> Null,
          PrecipitationFiltrateVolume -> Null,
          PrecipitationFilterStorageCondition -> Null
        }]
      },
      TimeConstraint -> 1200
    ],

    (*Test Case:PrecipitationSeparationTechnique is Filter. Most default resolution when no other options are set*)
    Example[{Options, {PrecipitationFiltrationTechnique,PrecipitationFilter,PrecipitationPrefilterPoreSize,PrecipitationPrefilterMembraneMaterial,PrecipitationPoreSize,PrecipitationMembraneMaterial,PrecipitationFilterPosition,PrecipitationFiltrationTime,PrecipitationFiltrateVolume,PrecipitationFilterStorageCondition}, "If PrecipitationSeparationTechnique is set to Filter, unless otherwise specified, 1) PrecipitationFiltrationTechnique is set to AirPressure, 2) PrecipitationFilter is set to Model[Container, Plate, Filter, \"Pierce Protein Precipitation Plate\"], 3) PrecipitationPrefilterPoreSize, PrecipitationPrefilterMembraneMaterial, PrecipitationPoreSize, PrecipitationMembraneMaterial, PrecipitationFilterPosition are set by ExperimentFilter, 4) PrecipitationFiltrationTime is set to 10 Minutes, 5) PrecipitationFiltrateVolume is set to the sample volume plus PrecipitationReagentVolume, 6) PrecipitationFilterStorageCondition is set to the StorageCondition of the Sample if PrecipitationTargetPhase is to Solid (set or by default):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationReagentVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationFiltrationTechnique -> AirPressure,
          PrecipitationFilter -> ObjectP[Model[Container, Plate, Filter, "Pierce Protein Precipitation Plate"]],(*id:Z1lqpMlMrPw9*)
          PrecipitationPrefilterPoreSize -> Null,
          PrecipitationPrefilterMembraneMaterial -> Null,
          PrecipitationPoreSize -> EqualP[0.2*Micron],
          PrecipitationMembraneMaterial -> PTFE,(*Changes if the filter is changed*)
          PrecipitationFilterPosition -> "A1",
          PrecipitationFiltrationTime -> EqualP[10 Minute],
          PrecipitationFiltrateVolume -> EqualP[0.4 Milliliter],
          PrecipitationFilterStorageCondition -> ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]](*Model[StorageCondition, "Refrigerator"]*)
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test case: additional resolution scenarios*)
    Example[{Options, PrecipitationFilterStorageCondition, "PrecipitationFilterStorageCondition is set to Disposal if PrecipitationTargetPhase is set to Liquid and PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationFilterStorageCondition -> Disposal}]
      },
      TimeConstraint -> 1200
    ],
    (* --- Precipitation Filter Centrifuge Options --- *)
    (*Test case: PrecipitationFiltrationTechnique is set to Centrifuge, all AirPressure options are set to Null*)
    Example[{Options, {PrecipitationFiltrationInstrument,PrecipitationFiltrationPressure, PrecipitationFilterCentrifugeIntensity}, "If PrecipitationFiltrationTechnique is set to Centrifuge, unless otherwise specified, 1) PrecipitationFiltrationPressure is set to Null, 2) PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"], 3) PrecipitationFilterCentrifugeIntensity is set to 3600 g. 4) :"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationFiltrationTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationFiltrationInstrument -> ObjectP[Model[Instrument,Centrifuge,"id:kEJ9mqaVPAXe"]],(*Model[Instrument, Centrifuge, "HiG4"]*)
          PrecipitationFiltrationPressure -> Null,
          PrecipitationFilterCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]
        }]
      },
      TimeConstraint -> 1200
    ],
    (* --- Precipitation Filter AirPressure Options --- *)
    (*Test case: PrecipitationFiltrationTechnique is set to AirPressure, all Centrifuge options are set to Null*)
    Example[{Options, {PrecipitationFiltrationInstrument,PrecipitationFiltrationPressure, PrecipitationFilterCentrifugeIntensity}, "If PrecipitationFiltrationTechnique is set to AirPressure, unless otherwise specified, 1) PrecipitationFiltrationPressure is set to 40 PSI, 2) PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"MPE2 Sterile\"] , 3) PrecipitationFilterCentrifugeIntensity is set to 3600 g. 4) :"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationFiltrationTechnique -> AirPressure,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationFiltrationInstrument -> ObjectP[Model[Instrument,PressureManifold,"id:4pO6dMOqXNpX"]],(*Model[Instrument, PressureManifold, "MPE2"*)
          PrecipitationFiltrationPressure -> EqualP[40 PSI],
          PrecipitationFilterCentrifugeIntensity -> Null
        }]
      },
      TimeConstraint -> 1200
    ],

    (* -- Precipitation Pellet Options -- *)
    (*Test Case:PrecipitationSeparationTechnique is Filter. No pellet options are set*)
    Example[{Options, {PrecipitationPelletVolume,PrecipitationPelletCentrifuge,PrecipitationPelletCentrifugeIntensity,PrecipitationPelletCentrifugeTime,PrecipitationSupernatantVolume}, "If PrecipitationSeparationTechnique is set to Filter, unless otherwise specified, all purification pellet options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationPelletVolume -> Null,
          PrecipitationPelletCentrifuge -> Null,
          PrecipitationPelletCentrifugeIntensity -> Null,
          PrecipitationPelletCentrifugeTime -> Null,
          PrecipitationSupernatantVolume -> Null
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case:PrecipitationSeparationTechnique is Pellet. Most default resolution when no other options are set*)
    Example[{Options, {PrecipitationPelletVolume,PrecipitationPelletCentrifuge,PrecipitationPelletCentrifugeIntensity,PrecipitationPelletCentrifugeTime,PrecipitationSupernatantVolume}, "If PrecipitationSeparationTechnique is set to Pellet, unless otherwise specified, 1) PrecipitationPelletVolume is set to 1 MicroLiter, 2) PrecipitationPelletCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"], 3) PrecipitationPelletCentrifugeIntensity is set to 3600 Gravitational Acceleration, 4) PrecipitationPelletCentrifugeTime is set to 10 Minutes, 5) PrecipitationSupernatantVolume is set to 90% of the sample volume plus PrecipitationReagentVolume:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        PrecipitationReagentVolume -> 0.1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationPelletVolume -> EqualP[1 Microliter],
          PrecipitationPelletCentrifuge -> ObjectP[Model[Instrument,Centrifuge,"id:kEJ9mqaVPAXe"]],(*Model[Instrument, Centrifuge, "HiG4"]*)
          PrecipitationPelletCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration],
          PrecipitationPelletCentrifugeTime -> EqualP[10 Minute],
          PrecipitationSupernatantVolume -> EqualP[0.27 Milliliter]
        }]
      },
      TimeConstraint -> 1200
    ],

    (* -- Precipitation Wash options -- *)
    (*Test Case: PrecipitationNumberOfWashes is set 0, all wash options are set to Null*)
    Example[{Options, {PrecipitationWashSolution,PrecipitationWashSolutionTemperature,PrecipitationWashSolutionEquilibrationTime,PrecipitationWashMixType,PrecipitationWashPrecipitationTime,PrecipitationWashPrecipitationInstrument,PrecipitationWashPrecipitationTemperature,PrecipitationWashSeparationTime}, "If PrecipitationNumberOfWashes is set to 0, unless otherwise specified, all purification wash options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 0,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationWashSolution -> Null,
          PrecipitationWashSolutionTemperature -> Null,
          PrecipitationWashSolutionEquilibrationTime -> Null,
          PrecipitationWashMixType -> None,
          PrecipitationWashPrecipitationTime -> Null,
          PrecipitationWashPrecipitationInstrument -> Null,
          PrecipitationWashPrecipitationTemperature -> Null,
          PrecipitationWashSeparationTime -> Null
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: PrecipitationNumberOfWashes>0, all wash options are set to most default*)
    Example[{Options, {PrecipitationWashSolution, PrecipitationWashSolutionVolume, PrecipitationWashSolutionTemperature, PrecipitationWashSolutionEquilibrationTime, PrecipitationWashMixType}, "If PrecipitationSeparationTechnique is set to Pellet, nothing else is specified, 1) PrecipitationWashSolution is set to Model[Sample, StockSolution, \"Acetone, Reagent Grade\"], 2) PrecipitationWashSolutionVolume is set to the volume of the sample, 3) PrecipitationWashSolutionTemperature is set to Ambient, 4) PrecipitationWashSolutionEquilibrationTime is set to 10 Minutes, 5) PrecipitationWashMixType is set to Shake :"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationWashSolution -> ObjectP[Model[Sample, "id:Vrbp1jG80zno"]],(*Model[Sample, "Acetone, Reagent Grade"]*)
          PrecipitationWashSolutionVolume -> EqualP[0.2 Milliliter],
          PrecipitationWashSolutionTemperature -> Ambient,
          PrecipitationWashSolutionEquilibrationTime -> EqualP[10 Minute],
          PrecipitationWashMixType -> Shake
        }]
      },
      TimeConstraint -> 1200
    ],

    (*Test Case: Alternative resolution of MixType*)
    Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationWashMixVolume is set:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 3,
        PrecipitationWashMixVolume -> 100 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixType -> Pipette}]
      },
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationNumberOfWashMixes is set:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 1,
        PrecipitationNumberOfWashMixes -> 10,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixType -> Pipette}]
      },
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 3,
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixType -> Pipette}]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: other resolution scenarios. PrecipitationSeparationTechnique*)
    Example[{Options, {PrecipitationWashCentrifugeIntensity, PrecipitationWashSeparationTime}, "If PrecipitationFiltrationTechnique is set to Centrifuge and PrecipitationNumberOfWashes is greater than 0 PrecipitationWashCentrifugeIntensity is set to 3600 GravitationalAcceleration and PrecipitationWashSeparationTime is set to 20 Minutes if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 1,
        PrecipitationFiltrationTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationWashCentrifugeIntensity ->EqualP[3600 GravitationalAcceleration],
          PrecipitationWashSeparationTime -> EqualP[20 Minute]}]
      },
      TimeConstraint -> 1200
    ],
    Example[{Options, {PrecipitationWashPressure,PrecipitationWashSeparationTime}, "If PrecipitationFiltrationTechnique is set to AirPressure and PrecipitationNumberOfWashes is greater than 0, 1) PrecipitationWashPressure is set to 40 PSI and 2) PrecipitationWashSeparationTime is set to 3 Minutes:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> AirPressure,
        PrecipitationNumberOfWashes -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationWashPressure -> EqualP[40 PSI],
          PrecipitationWashSeparationTime -> EqualP[3 Minute]}]
      },
      TimeConstraint -> 1200
    ],
    
    (* --- Precipitation Wash Mix options --- *)

    (*Test Case: MixType is None. all other options are Null. *)
    Example[{Options, {PrecipitationWashMixType,PrecipitationWashMixInstrument,PrecipitationWashMixRate,PrecipitationWashMixTemperature,PrecipitationWashMixTime,PrecipitationNumberOfWashMixes}, "If Purification contains Precipitation and PrecipitationWashMixType is set to None, unless otherwise specified, all other precipitation wash mix options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationWashMixInstrument -> Null,
          PrecipitationWashMixRate -> Null,
          PrecipitationWashMixTemperature -> Null,
          PrecipitationWashMixTime -> Null,
          PrecipitationNumberOfWashMixes -> Null
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: MixType is Pipette. Pipette options are set to default. Shake options are Null. *)
    Example[{Options, {PrecipitationWashMixInstrument,PrecipitationWashMixRate,PrecipitationWashMixTemperature,PrecipitationWashMixTime,PrecipitationNumberOfWashMixes}, "If Purification contains Precipitation and PrecipitationWashMixType is set to Pipette, unless otherwise specified, 1) PrecipitationWashMixVolume is set to the lesser of 50% of the sample volume and $MaxRoboticSingleTransferVolume, 2) NumberOfPrecipitationWashMixes is set to 10, 3) all other shake options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationWashMixVolume -> EqualP[0.1 Milliliter],
          PrecipitationWashMixInstrument -> Null,
          PrecipitationWashMixRate -> Null,
          PrecipitationWashMixTemperature -> Null,
          PrecipitationWashMixTime -> Null,
          PrecipitationNumberOfWashMixes -> 10
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: MixType is Shake. Pipette options are set to Null. Shake options are set to default. *)
    Example[{Options, {PrecipitationWashMixInstrument,PrecipitationWashMixRate,PrecipitationWashMixTemperature,PrecipitationWashMixTime,PrecipitationNumberOfWashMixes}, "If Purification contains Precipitation and PrecipitationWashMixType is set to Shake, unless otherwise specified, 1) PrecipitationWashMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] when PrecipitationWashMixTemperature is below 70 Celsius, 2) PrecipitationWashMixRate is set to 300 RPM, 3) PrecipitationWashMixTemperature is set to Ambient, 4) PrecipitationWashMixTime is set to 15 Minutes, 5) all other pipette options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationWashMixVolume -> Null,
          PrecipitationWashMixInstrument -> ObjectP[Model[Instrument,Shaker,"id:pZx9jox97qNp"]],(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
          PrecipitationWashMixRate -> EqualP[300 RPM],
          PrecipitationWashMixTemperature -> Ambient,
          PrecipitationWashMixTime -> EqualP[15 Minute],
          PrecipitationNumberOfWashMixes -> Null
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: Another scenario for mix instrument resolution*)
    Example[{Options, PrecipitationWashMixInstrument, "PrecipitationWashMixInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is above 70 Celsius:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        PrecipitationWashMixTemperature -> 72 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]}]
      },(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],
    (* --- Precipitation Wash Precipitation options --- *)
    (*Test Case: No wash precipitation options set.*)
    Example[{Options, {PrecipitationWashPrecipitationTime, PrecipitationWashPrecipitationInstrument, PrecipitationWashPrecipitationTemperature}, "If Purification contains Precipitation and PrecipitationWashPrecipitationTime is not specified to be greater than 0 minute: 1) PrecipitationWashPrecipitationTemperature is set to Null, 2) PrecipitationWashPrecipitationInstrument is set to Null, 3) PrecipitationWashPrecipitationTime is set to Null if PrecipitationWashSolutionTemperature is not greater than PrecipitationReagentTemperature:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashSolutionTemperature -> Ambient,
        PrecipitationReagentTemperature -> Ambient,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationWashPrecipitationTime ->Null,
            PrecipitationWashPrecipitationInstrument -> Null,
            PrecipitationWashPrecipitationTemperature -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: PrecipitationTime is set to above 0.*)
    Example[{Options, {PrecipitationWashPrecipitationTime, PrecipitationWashPrecipitationInstrument, PrecipitationWashPrecipitationTemperature}, "If Purification contains Precipitation and PrecipitationWashSolutionTemperature is greater than the PrecipitationReagentTemperature, PrecipitationWashPrecipitationTime is set to 1 Minute. If PrecipitationWashPrecipitationTime is greater than 0 minute: 1) PrecipitationWashPrecipitationTemperature is set to Ambient, 2) PrecipitationWashPrecipitationInstrument is set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"] if PrecipitationWashPrecipitationTemperature is less than 70 Celsius:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationWashSolutionTemperature -> 40 Celsius,
        PrecipitationReagentTemperature -> Ambient,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitationWashPrecipitationTime -> 1 Minute,
            PrecipitationWashPrecipitationInstrument -> ObjectP[Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]],(*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
            PrecipitationWashPrecipitationTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Additional resolution scenario for wash precipitation instrument*)
    Example[{Options, PrecipitationWashPrecipitationInstrument, "PrecipitationWashPrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashPrecipitationTemperature is set to greater than 70 Celsius and PrecipitationWashPrecipitationTime is greater than 0 Minute:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashPrecipitationTemperature -> 80 Celsius,
        PrecipitationWashPrecipitationTime -> 15 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> ObjectP[Model[Instrument,Shaker,"id:eGakldJkWVnz"]]}]
      },(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],

    (* -- Precipitation Resuspension options -- *)
    (*Test Case: PrecipitationResuspensionBuffer resolves to none, all other resuspension options are set to Null*)
    Example[{Options, {PrecipitationResuspensionBuffer, PrecipitationResuspensionBufferVolume,PrecipitationResuspensionBufferTemperature, PrecipitationResuspensionBufferEquilibrationTime, PrecipitationResuspensionMixType}, "If PrecipitationTargetPhase is set to Liquid, PrecipitationResuspensionBuffer is set to None. If PrecipitationResuspensionBuffer is None, all precipitation resuspension options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationResuspensionBuffer -> None,
          PrecipitationResuspensionBufferVolume -> Null,
          PrecipitationResuspensionBufferTemperature -> Null,
          PrecipitationResuspensionBufferEquilibrationTime -> Null,
          PrecipitationResuspensionMixType -> None
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: PrecipitationResuspensionBuffer is a buffer, all resuspension options are set to most default*)
    Example[{Options,{PrecipitationResuspensionBuffer, PrecipitationResuspensionBufferVolume,PrecipitationResuspensionBufferTemperature, PrecipitationResuspensionBufferEquilibrationTime, PrecipitationResuspensionMixType}, "If PrecipitationTargetPhase is set to Solid, PrecipitationResuspensionBuffer is set to Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"]. If PrecipitationResuspensionBuffer is not None, unless otherwise specified, 1) PrecipitationResuspensionBufferVolume is set to the greater of 10 MicroLiter or 1/4th SampleVolume, 2) PrecipitationResuspensionBufferTemperature is set to Ambient, 3) PrecipitationResuspensionBufferEquilibrationTime is set to 10 Minutes, 4) PrecipitationResuspensionMixType is set to Shake if no specific mix option is set and and PrecipitationSeparationTechnique is not set to Filter:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationResuspensionBuffer -> ObjectP[Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"]],(*Model[Sample, StockSolution, "RIPA Lysis Buffer with protease inhibitor cocktail"]*)
          PrecipitationResuspensionBufferVolume -> EqualP[0.05 Milliliter],
          PrecipitationResuspensionBufferTemperature -> Ambient,
          PrecipitationResuspensionBufferEquilibrationTime -> EqualP[10 Minute],
          PrecipitationResuspensionMixType -> Shake
        }]
      },
      TimeConstraint -> 1200
    ],

    (*Test Case: Alternative resolution of MixType*)
    Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationResuspensionMixVolume is set:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixVolume -> 10 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]
      },
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationNumberOfResuspensionMixes is set:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfResuspensionMixes -> 10,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]
      },
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]
      },
      TimeConstraint -> 1200
    ],

    (* --- Precipitation Resuspension Mix options --- *)

    (*Test Case: MixType is None. all other options are Null. *)
    Example[{Options, {PrecipitationResuspensionMixType,PrecipitationResuspensionMixInstrument,PrecipitationResuspensionMixRate,PrecipitationResuspensionMixTemperature,PrecipitationResuspensionMixTime,PrecipitationNumberOfResuspensionMixes}, "If PrecipitationResuspensionMixType is set to None, unless otherwise specified, all other precipitation wash mix options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationResuspensionMixInstrument -> Null,
          PrecipitationResuspensionMixRate -> Null,
          PrecipitationResuspensionMixTemperature -> Null,
          PrecipitationResuspensionMixTime -> Null,
          PrecipitationNumberOfResuspensionMixes -> Null
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: MixType is Pipette. Pipette options are set to default. Shake options are Null. *)
    Example[{Options, {PrecipitationResuspensionMixInstrument,PrecipitationResuspensionMixRate,PrecipitationResuspensionMixTemperature,PrecipitationResuspensionMixTime,PrecipitationNumberOfResuspensionMixes}, "If Purification contains Precipitation and PrecipitationResuspensionMixType is set to Pipette, unless otherwise specified, 1) PrecipitationResuspensionMixVolume is set to the lesser of 50% of the sample volume and $MaxRoboticSingleTransferVolume, 2) NumberOfPrecipitationResuspensionMixes is set to 10, 3) all other shake options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Pipette,
        PrecipitationResuspensionBufferVolume -> 0.05 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationResuspensionMixVolume -> EqualP[0.025 Milliliter],
          PrecipitationResuspensionMixInstrument -> Null,
          PrecipitationResuspensionMixRate -> Null,
          PrecipitationResuspensionMixTemperature -> Null,
          PrecipitationResuspensionMixTime -> Null,
          PrecipitationNumberOfResuspensionMixes -> 10
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: MixType is Shake. Pipette options are set to Null. Shake options are set to default. *)
    Example[{Options, {PrecipitationResuspensionMixInstrument,PrecipitationResuspensionMixRate,PrecipitationResuspensionMixTemperature,PrecipitationResuspensionMixTime,PrecipitationNumberOfResuspensionMixes}, "If Purification contains Precipitation and PrecipitationResuspensionMixType is set to Shake, unless otherwise specified, 1) PrecipitationResuspensionMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] when PrecipitationResuspensionMixTemperature is below 70 Celsius, 2) PrecipitationResuspensionMixRate is set to 300 RPM, 3) PrecipitationResuspensionMixTemperature is set to Ambient, 4) PrecipitationResuspensionMixTime is set to 15 Minutes, 5) all other pipette options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PrecipitationResuspensionMixVolume -> Null,
          PrecipitationResuspensionMixInstrument -> ObjectP[Model[Instrument,Shaker,"id:pZx9jox97qNp"]],(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
          PrecipitationResuspensionMixRate -> EqualP[300 RPM],
          PrecipitationResuspensionMixTemperature -> Ambient,
          PrecipitationResuspensionMixTime -> EqualP[15 Minute],
          PrecipitationNumberOfResuspensionMixes -> Null
        }]
      },
      TimeConstraint -> 1200
    ],
    (*Test Case: Another scenario for mix instrument resolution*)
    Example[{Options, PrecipitationResuspensionMixInstrument, "PrecipitationResuspensionMixInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is above 70 Celsius:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        PrecipitationResuspensionMixTemperature -> 72 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{PrecipitationResuspensionMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]}]
      },(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],

    (* -- Precipitation Sample Positprocessing options -- *)

    (*Test Case: Default resolutions when nothing is set. TargetPhase is Solid. *)
    Example[{Options, {PrecipitatedSampleStorageCondition,PrecipitatedSampleLabel,PrecipitatedSampleContainerLabel,UnprecipitatedSampleStorageCondition,UnprecipitatedSampleLabel,UnprecipitatedSampleContainerLabel,PrecipitatedSampleContainerOut,UnprecipitatedSampleContainerOut}, "If Purification contains Precipitation and PrecipitationTargetPhase is set to Solid: 1) PrecipitatedSampleStorageCondition is set to the StorageCondition of the Sample, 2) PrecipitatedSampleLabel and PrecipitatedSampleContainerLabel are automatically generated, 3) UnprecipitatedSampleStorageCondition is set to Null, 4) UnprecipitatedSampleLabel and UnprecipitatedSampleContainerLabel are set to Null, 5) PrecipitatedSampleContainerOut and UnprecipitatedSampleContainerOut are automatically assigned:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Solid,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitatedSampleStorageCondition -> ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]],(*Model[StorageCondition, "Refrigerator"]*)
            PrecipitatedSampleLabel -> _String,
            PrecipitatedSampleContainerLabel -> _String,
            UnprecipitatedSampleStorageCondition -> Null,
            UnprecipitatedSampleLabel -> Null,
            UnprecipitatedSampleContainerLabel -> Null,
            PrecipitatedSampleContainerOut -> {_String,{_Integer, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}},
            UnprecipitatedSampleContainerOut -> {_String,{_Integer, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Alternatively labels can be specified by user. TargetPhase is Solid. *)
    Example[{Options, {PrecipitatedSampleLabel,PrecipitatedSampleContainerLabel}, "If Purification contains Precipitation and PrecipitationTargetPhase is set to Solid, PrecipitatedSampleLabel and PrecipitatedSampleContainerLabel can be specified by the user. PrecipitatedSampleContainerOut and UnprecipitatedSampleContainerOut can be specified by user and set properly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Solid,
        PrecipitatedSampleLabel -> "Test Label for Precipitated Sample",
        PrecipitatedSampleContainerLabel -> "Test Label for Precipitated Sample Container",
        PrecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        UnprecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitatedSampleLabel -> "Test Label for Precipitated Sample",
            PrecipitatedSampleContainerLabel -> "Test Label for Precipitated Sample Container",
            PrecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
            UnprecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Default resolutions when nothing is set. TargetPhase is Liquid. *)
    Example[{Options, {PrecipitatedSampleStorageCondition,PrecipitatedSampleLabel,PrecipitatedSampleContainerLabel,UnprecipitatedSampleStorageCondition,UnprecipitatedSampleLabel,UnprecipitatedSampleContainerLabel}, "If Purification contains Precipitation and PrecipitationTargetPhase is set to Liquid: 1) PrecipitatedSampleStorageCondition is set to Null, 2) PrecipitatedSampleLabel and PrecipitatedSampleContainerLabel are set to Null, 3) UnprecipitatedSampleStorageCondition is set to the StorageCondition of the Sample, 4) UnprecipitatedSampleLabel and UnprecipitatedSampleContainerLabel are automatically generated, 5) PrecipitatedSampleContainerOut and UnprecipitatedSampleContainerOut are automatically assigned:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Liquid,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitatedSampleStorageCondition -> Null,
            PrecipitatedSampleLabel -> Null,
            PrecipitatedSampleContainerLabel -> Null,
            UnprecipitatedSampleStorageCondition -> ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]],(*Model[StorageCondition, "Refrigerator"]*)
            UnprecipitatedSampleLabel -> _String,
            UnprecipitatedSampleContainerLabel -> _String,
            PrecipitatedSampleContainerOut -> {_String,{_Integer, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}},
            UnprecipitatedSampleContainerOut -> {_String,{_Integer, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Alternatively labels can be specified by user. TargetPhase is Liquid *)
    Example[{Options, {UnprecipitatedSampleLabel,UnprecipitatedSampleContainerLabel}, "If Purification contains Precipitation and PrecipitationTargetPhase is set to Liquid, UnprecipitatedSampleLabel and UnprecipitatedSampleContainerLabel can be specified by the user. PrecipitatedSampleContainerOut and UnprecipitatedSampleContainerOut can be specified by user and set properly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> Precipitation,
        PrecipitationTargetPhase -> Liquid,
        PrecipitatedSampleLabel -> "Test Label for Unprecipitated Sample",
        PrecipitatedSampleContainerLabel -> "Test Label for Unprecipitated Sample Container",
        PrecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        UnprecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            PrecipitatedSampleLabel -> "Test Label for Unprecipitated Sample",
            PrecipitatedSampleContainerLabel -> "Test Label for Unprecipitated Sample Container",
            PrecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
            UnprecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* - Shared SPE Tests - *)
    Example[{Basic, "Crude samples can be purified with solid phase extraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],
    Example[{Basic, "All solid phase extraction options are set to Null if they are not specified by the user or method and SolidPhaseExtraction is not specified as a Purification step:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SolidPhaseExtractionStrategy -> Null,
          SolidPhaseExtractionSeparationMode -> Null,
          SolidPhaseExtractionSorbent -> Null,
          SolidPhaseExtractionCartridge -> Null,
          SolidPhaseExtractionTechnique -> Null,
          SolidPhaseExtractionInstrument -> Null,
          SolidPhaseExtractionCartridgeStorageCondition -> Null,
          SolidPhaseExtractionLoadingSampleVolume -> Null,
          (*SolidPhaseExtractionLoadingTemperature -> Null,
          SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> Null,*)
          SolidPhaseExtractionLoadingCentrifugeIntensity -> Null,
          SolidPhaseExtractionLoadingPressure -> Null,
          SolidPhaseExtractionLoadingTime -> Null,
          CollectSolidPhaseExtractionLoadingFlowthrough -> Null,
          SolidPhaseExtractionLoadingFlowthroughContainerOut -> Null,
          SolidPhaseExtractionWashSolution -> Null,
          SolidPhaseExtractionWashSolutionVolume -> Null,
          (*)SolidPhaseExtractionWashTemperature -> Null,
          SolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
          SolidPhaseExtractionWashCentrifugeIntensity -> Null,
          SolidPhaseExtractionWashPressure -> Null,
          SolidPhaseExtractionWashTime -> Null,
          CollectSolidPhaseExtractionWashFlowthrough -> Null,
          SolidPhaseExtractionWashFlowthroughContainerOut -> Null,
          SecondarySolidPhaseExtractionWashSolution -> Null,
          SecondarySolidPhaseExtractionWashSolutionVolume -> Null,
          (*)SecondarySolidPhaseExtractionWashTemperature -> Null,
          SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
          SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
          SecondarySolidPhaseExtractionWashPressure -> Null,
          SecondarySolidPhaseExtractionWashTime -> Null,
          CollectSecondarySolidPhaseExtractionWashFlowthrough -> Null,
          SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> Null,
          TertiarySolidPhaseExtractionWashSolution -> Null,
          TertiarySolidPhaseExtractionWashSolutionVolume -> Null,
          (*)TertiarySolidPhaseExtractionWashTemperature -> Null,
          TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
          TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
          TertiarySolidPhaseExtractionWashPressure -> Null,
          TertiarySolidPhaseExtractionWashTime -> Null,
          CollectTertiarySolidPhaseExtractionWashFlowthrough -> Null,
          TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> Null,
          SolidPhaseExtractionElutionSolution -> Null,
          SolidPhaseExtractionElutionSolutionVolume -> Null,
          (*)SolidPhaseExtractionElutionSolutionTemperature -> Null,
          SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> Null,*)
          SolidPhaseExtractionElutionCentrifugeIntensity -> Null,
          SolidPhaseExtractionElutionPressure -> Null,
          SolidPhaseExtractionElutionTime -> Null}]
      },
      TimeConstraint -> 1200
    ],

    (* Testing Stages: General, Loading, Wash, SecondaryWash, TertiaryWash, Elution. *)

    (* -- SPE General Options -- *)
    (*Test Case: Overall strategy and solutions. Default resolutions when nothing is set. *)
    (*------These general options are mainly resolved by pre-pre-resolved SPE options. The behabior is for ExtractProtein only------*)
    Example[{Options, {SolidPhaseExtractionStrategy,SolidPhaseExtractionSeparationMode,SolidPhaseExtractionSorbent,SolidPhaseExtractionCartridge,SolidPhaseExtractionTechnique,SolidPhaseExtractionInstrument, SolidPhaseExtractionCartridgeStorageCondition}, "If Purification contains SolidPhaseExtraction and TargetProtein is All (specified or by default), if no solid phase extraction option is specified, 1) SolidPhaseExtractionStrategy is set to Positive, 2) SolidPhaseExtractionSorbent is set to Null, 3) SolidPhaseExtractionSeparationMode is set to SizeExclusion, 4) SolidPhaseExtractionCartridge is set to the default cartridge for extraction of all proteins, 5) SolidPhaseExtractionTechnique is set to Pressure, 6) SolidPhaseExtractionInstrument is set to Model[Instrument, PressureManifold, \"MPE2\"] if SolidPhaseExtractionTechnique is Pressure, 7) SolidPhaseExtractionCartridgeStorageCondition is set to Disposal:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionStrategy -> Positive,
            SolidPhaseExtractionSorbent -> Null,
            SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"]], (*"Zeba 7K 96-well Desalt Spin Plate"*)
            SolidPhaseExtractionSeparationMode -> SizeExclusion,
            SolidPhaseExtractionTechnique -> Pressure,
            SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
            SolidPhaseExtractionCartridgeStorageCondition -> Disposal
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: Alternative resolutions*)
    Example[{Options, {SolidPhaseExtractionSorbent,SolidPhaseExtractionSeparationMode}, "If SolidPhaseExtractionCartridge is specified, unless otherwise specified, SolidPhaseExtractionSorbent and SolidPhaseExtractionSeparationMode are set to match the sorbent and separation mode of the SolidPhaseExtractionCartridge :"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Method->Custom,
        SolidPhaseExtractionCartridge->Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"],(*Model[Container, Plate, Filter, "Zeba 7K 96-well Desalt Spin Plate"]*)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SolidPhaseExtractionSorbent -> Null,
          SolidPhaseExtractionSeparationMode -> SizeExclusion
        }]
      },
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionSorbent, "If Purification contains SolidPhaseExtraction, TargetProtein is a Model[Molecule], and the resolved cell type is Bacterial, unless otherwise specified, 1) SolidPhaseExtractionSorbent is set to Affinity, and 2) SolidPhaseExtractionSeparationMode and SolidPhaseExtractionCartridge are set correspondingly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        CellType -> Bacterial,
        TargetProtein -> Model[Molecule, Protein,"ExperimentExtractProtein test protein " <> $SessionUUID],
        Method -> Custom,(*To avoid resolving to the test method*)
        Purification->{SolidPhaseExtraction},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SolidPhaseExtractionSorbent -> Affinity,
          SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"]], (*Model[Container, Plate, Filter, "HisPur Ni-NTA Spin Plates"]*)
          SolidPhaseExtractionSeparationMode -> Affinity
        }]
      },
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionSorbent, "If Purification contains SolidPhaseExtraction, TargetProtein is a Model[Molecule], and the resolved cell type is Mammalian, unless otherwise specified, 1) SolidPhaseExtractionSorbent is set to ProteinG, and 2) SolidPhaseExtractionSeparationMode and SolidPhaseExtractionCartridge are set correspondingly:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        CellType -> Mammalian,
        TargetProtein -> Model[Molecule, Protein,"ExperimentExtractProtein test protein " <> $SessionUUID],
        Method -> Custom,(*To avoid resolving to the test method*)
        Purification->{SolidPhaseExtraction},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SolidPhaseExtractionSorbent -> ProteinG,
          SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:eGakldaE6bY1"]], (*Model[Container, Plate, Filter, "Pierce ProteinG Spin Plate for IgG Screening"]*)
          SolidPhaseExtractionSeparationMode -> Affinity
        }]
      },
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionSeparationMode, "SolidPhaseExtractionSeparationMode is set to IonExchange if SolidPhaseExtractionSorbent is specified and SolidPhaseExtractionSeparationMode is not specified:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionSorbent->Silica,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionSeparationMode -> SizeExclusion}]
      },
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionInstrument, "SolidPhaseExtractionInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if SolidPhaseExtractionTechnique is set to Centrifuge and SolidPhaseExtractionInstrument is not specified:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"],
        SolidPhaseExtractionTechnique->Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}]}]
      },
      TimeConstraint -> 3600
    ],
    (* -- SPE Loading Options -- *)
    (*Test Case: most default, nothing specified*)
    Example[{Options, {SolidPhaseExtractionLoadingSampleVolume,SolidPhaseExtractionLoadingTemperature,SolidPhaseExtractionLoadingTemperatureEquilibrationTime,SolidPhaseExtractionLoadingCentrifugeIntensity,SolidPhaseExtractionLoadingPressure,SolidPhaseExtractionLoadingTime,CollectSolidPhaseExtractionLoadingFlowthrough,SolidPhaseExtractionLoadingFlowthroughContainerOut}, "If Purification contains SolidPhaseExtraction and no solid phase extraction option is specified, 1) SolidPhaseExtractionLoadingSampleVolume is resolved by ExperimentSolidPhaseExtraction, 2) SolidPhaseExtractionLoadingTemperature is set to Ambient, 3) SolidPhaseExtractionLoadingTemperatureEquilibrationTime is set to Null if SolidPhaseExtractionLoadingTemperature is Ambient or Null, 4) SolidPhaseExtractionLoadingCentrifugeIntensity is set to Null if SolidPhaseExtractionTechnique is Pressure (specified or by default), 5) SolidPhaseExtractionLoadingPressure is set to the MaxRoboticAirPressure if SolidPhaseExtractionTechnique is Pressure (specified or by default), 6) SolidPhaseExtractionLoadingTime is automatically set to 1 Minute, 7) CollectSolidPhaseExtractionLoadingFlowthrough and SolidPhaseExtractionLoadingFlowthroughContainerOut are resolved by ExperimentSolidPhaseExtraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Method->Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SolidPhaseExtractionLoadingSampleVolume -> RangeP[Quantity[199., Microliter], Quantity[201., Microliter]],
          (*)SolidPhaseExtractionLoadingTemperature -> Ambient,
          SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> Null,*)
          SolidPhaseExtractionLoadingCentrifugeIntensity -> Null,
          SolidPhaseExtractionLoadingPressure -> $MaxRoboticAirPressure,
          SolidPhaseExtractionLoadingTime -> EqualP[1 Minute],
          CollectSolidPhaseExtractionLoadingFlowthrough -> False,
          SolidPhaseExtractionLoadingFlowthroughContainerOut -> Null
        }]
      }(*in SPE Automatic resolves to use All of the sample. make sure this number matches the volume of the test sample plus any volume added/subtracted prior to SPE purification*),
      TimeConstraint -> 3600
    ],
    (*Not supported for now
    (*Test Case: Alternative resolution*)
    Example[{Options, SolidPhaseExtractionLoadingTemperatureEquilibrationTime, "SolidPhaseExtractionLoadingTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SolidPhaseExtractionLoadingTemperature is set to something other than Ambient or Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionLoadingTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> 3 Minute}]
      },
      TimeConstraint -> 3600
    ],*)
    Example[{Options, {SolidPhaseExtractionLoadingCentrifugeIntensity,SolidPhaseExtractionLoadingPressure}, "If SolidPhaseExtractionTechnique is set to Centrifuge, unless otherwise specified, 1) SolidPhaseExtractionLoadingCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed, 2) SolidPhaseExtractionLoadingPressure is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"],
        SolidPhaseExtractionTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionLoadingCentrifugeIntensity -> 5000 RPM,
          SolidPhaseExtractionLoadingPressure -> Null}]
      },
      TimeConstraint -> 3600
    ],
    (* -- SPE Wash Options -- *)
    (*Test Case: Wash is turned off*)
    Example[{Options, {SolidPhaseExtractionWashSolution, SolidPhaseExtractionWashSolutionVolume, SolidPhaseExtractionWashTemperature, SolidPhaseExtractionWashTemperatureEquilibrationTime, SolidPhaseExtractionWashCentrifugeIntensity, SolidPhaseExtractionWashPressure, SolidPhaseExtractionWashTime, CollectSolidPhaseExtractionWashFlowthrough, SolidPhaseExtractionWashFlowthroughContainerOut}, "If Purification contains SolidPhaseExtraction and SolidPhaseExtractionWashSolution is set to Null, other solid phase extraction wash options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionWashSolution -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionWashSolutionVolume -> Null,
            (*)SolidPhaseExtractionWashTemperature -> Ambient,
            SolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
            SolidPhaseExtractionWashCentrifugeIntensity -> Null,
            SolidPhaseExtractionWashPressure -> Null,
            SolidPhaseExtractionWashTime -> Null,
            CollectSolidPhaseExtractionWashFlowthrough -> False,
            SolidPhaseExtractionWashFlowthroughContainerOut ->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: most default, nothing specified*)
    Example[{Options, {SolidPhaseExtractionWashSolution, SolidPhaseExtractionWashSolutionVolume, SolidPhaseExtractionWashTemperature, SolidPhaseExtractionWashTemperatureEquilibrationTime, SolidPhaseExtractionWashCentrifugeIntensity, SolidPhaseExtractionWashPressure, SolidPhaseExtractionWashTime, CollectSolidPhaseExtractionWashFlowthrough, SolidPhaseExtractionWashFlowthroughContainerOut}, "If Purification contains SolidPhaseExtraction SolidPhaseExtractionWashSolution is set to Model[Sample,StockSolution,\"Filtered PBS, Sterile\"] by ExperimentSolidPhaseExtraction. If SolidPhaseExtractionWashSolution is set, unless otherwise specified, 1) SolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction, 2) SolidPhaseExtractionWashTemperature is set to Ambient, 3) SolidPhaseExtractionWashTemperatureEquilibrationTime is set to Null if SolidPhaseExtractionWashTemperature is Ambient or Null, 4) SolidPhaseExtractionWashCentrifugeIntensity is set to Null if SolidPhaseExtractionTechnique is Pressure (specified or by default), 5) SolidPhaseExtractionWashPressure is set to the MaxRoboticAirPressure if SolidPhaseExtractionTechnique is Pressure (specified or by default), 6) SolidPhaseExtractionWashTime is automatically set to 1 Minute, 7) CollectSolidPhaseExtractionWashFlowthrough and SolidPhaseExtractionWashFlowthroughContainerOut are resolved by ExperimentSolidPhaseExtraction:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],(*Filtered PBS, Sterile*)
            SolidPhaseExtractionWashSolutionVolume -> EqualP[0.4 Milliliter],
            (*)SolidPhaseExtractionWashTemperature -> Ambient,
            SolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
            SolidPhaseExtractionWashCentrifugeIntensity -> Null,
            SolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure,
            SolidPhaseExtractionWashTime -> 1 Minute,
            CollectSolidPhaseExtractionWashFlowthrough -> False,
            SolidPhaseExtractionWashFlowthroughContainerOut -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Not supported for now
    (*Test case: Alternative resolution*)
    Example[{Options, SolidPhaseExtractionWashTemperatureEquilibrationTime, "SolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SolidPhaseExtractionWashTemperature is not Ambient or Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionWashTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionWashTemperatureEquilibrationTime -> 3 Minute}]
      },
      TimeConstraint -> 3600
    ],*)
    Example[{Options, {SolidPhaseExtractionWashCentrifugeIntensity,SolidPhaseExtractionWashPressure}, "If SolidPhaseExtractionTechnique is set to Centrifuge, unless otherwise specified, 1) SolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed, 2) SolidPhaseExtractionWashPressure is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"],
        SolidPhaseExtractionTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM,
          SolidPhaseExtractionWashPressure -> Null}]
      },
      TimeConstraint -> 3600
    ],

    (* -- Secondary SPE Wash Options -- *)
    (*Test Case: Secondary Wash is turned off*)
    Example[{Options, {SecondarySolidPhaseExtractionWashSolution, SecondarySolidPhaseExtractionWashSolutionVolume, SecondarySolidPhaseExtractionWashTemperature, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, SecondarySolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashTime, CollectSecondarySolidPhaseExtractionWashFlowthrough, SecondarySolidPhaseExtractionWashFlowthroughContainerOut}, "If Purification contains SolidPhaseExtraction and SecondarySolidPhaseExtractionWashSolution is set to Null, other secondary solid phase extraction wash options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SecondarySolidPhaseExtractionWashSolution -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SecondarySolidPhaseExtractionWashSolutionVolume -> Null,
            (*)SecondarySolidPhaseExtractionWashTemperature -> Ambient,
            SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
            SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
            SecondarySolidPhaseExtractionWashPressure -> Null,
            SecondarySolidPhaseExtractionWashTime -> Null,
            CollectSecondarySolidPhaseExtractionWashFlowthrough -> False,
            SecondarySolidPhaseExtractionWashFlowthroughContainerOut ->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: most default, nothing specified*)
    Example[{Options, {SecondarySolidPhaseExtractionWashSolution, SecondarySolidPhaseExtractionWashSolutionVolume, SecondarySolidPhaseExtractionWashTemperature, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, SecondarySolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashTime, CollectSecondarySolidPhaseExtractionWashFlowthrough, SecondarySolidPhaseExtractionWashFlowthroughContainerOut}, "If Purification contains SolidPhaseExtraction and SolidPhaseExtractionWashSolution is specified, unless otherwise specified, 0) SecondarySolidPhaseExtractionWashSolution is set to SolidPhaseExtractionWashSolution, 1) SecondarySolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction, 2) SecondarySolidPhaseExtractionWashTemperature is set to Ambient, 3) SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to Null if SecondarySolidPhaseExtractionWashTemperature is Ambient or Null, 4) SecondarySolidPhaseExtractionWashCentrifugeIntensity is set to Null if SolidPhaseExtractionTechnique is Pressure (specified or by default), 5) SecondarySolidPhaseExtractionWashPressure is set to the MaxRoboticAirPressure if SolidPhaseExtractionTechnique is Pressure (specified or by default), 6) SecondarySolidPhaseExtractionWashTime is automatically set to 1 Minute, 7) CollectSecondarySolidPhaseExtractionWashFlowthrough and SecondarySolidPhaseExtractionWashFlowthroughContainerOut are resolved by ExperimentSolidPhaseExtraction:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"],
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SecondarySolidPhaseExtractionWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]],
            SecondarySolidPhaseExtractionWashSolutionVolume -> EqualP[0.4 Milliliter],
            (*)SecondarySolidPhaseExtractionWashTemperature -> Ambient,
            SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
            SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
            SecondarySolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure,
            SecondarySolidPhaseExtractionWashTime -> 1 Minute,
            CollectSecondarySolidPhaseExtractionWashFlowthrough -> False,
            SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Not supported for now
    (*Test case: Alternative resolution*)
    Example[{Options, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, "SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SecondarySolidPhaseExtractionWashTemperature is not Ambient or Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SecondarySolidPhaseExtractionWashTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> 3 Minute}]
      },
      TimeConstraint -> 3600
    ],*)
    Example[{Options, {SecondarySolidPhaseExtractionWashCentrifugeIntensity,SecondarySolidPhaseExtractionWashPressure}, "If SolidPhaseExtractionTechnique is set to Centrifuge, unless otherwise specified, 1) SecondarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed, 2) SecondarySolidPhaseExtractionWashPressure is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"],
        SolidPhaseExtractionTechnique -> Centrifuge,
        SecondarySolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SecondarySolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM,
          SecondarySolidPhaseExtractionWashPressure -> Null}]
      },
      TimeConstraint -> 3600
    ],

    (* -- Tertiary SPE Wash Options -- *)
    (*Test Case: Tertiary Wash is turned off*)
    Example[{Options, {TertiarySolidPhaseExtractionWashSolution, TertiarySolidPhaseExtractionWashSolutionVolume, TertiarySolidPhaseExtractionWashTemperature, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, TertiarySolidPhaseExtractionWashCentrifugeIntensity, TertiarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashTime, CollectTertiarySolidPhaseExtractionWashFlowthrough, TertiarySolidPhaseExtractionWashFlowthroughContainerOut}, "If Purification contains SolidPhaseExtraction and TertiarySolidPhaseExtractionWashSolution is set to Null, other tertiary solid phase extraction wash options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        TertiarySolidPhaseExtractionWashSolution -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            TertiarySolidPhaseExtractionWashSolutionVolume -> Null,
            (*)TertiarySolidPhaseExtractionWashTemperature -> Ambient,
            TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null, *)
            TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
            TertiarySolidPhaseExtractionWashPressure -> Null,
            TertiarySolidPhaseExtractionWashTime -> Null,
            CollectTertiarySolidPhaseExtractionWashFlowthrough -> False,
            TertiarySolidPhaseExtractionWashFlowthroughContainerOut ->Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: most default, nothing specified*)
    Example[{Options, {TertiarySolidPhaseExtractionWashSolution, TertiarySolidPhaseExtractionWashSolutionVolume, TertiarySolidPhaseExtractionWashTemperature, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, TertiarySolidPhaseExtractionWashCentrifugeIntensity, TertiarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashTime, CollectTertiarySolidPhaseExtractionWashFlowthrough, TertiarySolidPhaseExtractionWashFlowthroughContainerOut}, "If Purification contains SolidPhaseExtraction and SecondarySolidPhaseExtractionWashSolution is specified, unless otherwise specified, 0) TertiarySolidPhaseExtractionWashSolution is set to SecondarySolidPhaseExtractionWashSolution, 1) TertiarySolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction, 2) TertiarySolidPhaseExtractionWashTemperature is set to Ambient, 3) TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to Null if TertiarySolidPhaseExtractionWashTemperature is Ambient or Null, 4) TertiarySolidPhaseExtractionWashCentrifugeIntensity is set to Null if SolidPhaseExtractionTechnique is Pressure (specified or by default), 5) TertiarySolidPhaseExtractionWashPressure is set to the MaxRoboticAirPressure if SolidPhaseExtractionTechnique is Pressure (specified or by default), 6) TertiarySolidPhaseExtractionWashTime is automatically set to 1 Minute, 7) CollectTertiarySolidPhaseExtractionWashFlowthrough and TertiarySolidPhaseExtractionWashFlowthroughContainerOut are resolved by ExperimentSolidPhaseExtraction:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"],
        SecondarySolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"],
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            TertiarySolidPhaseExtractionWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]],
            TertiarySolidPhaseExtractionWashSolutionVolume -> EqualP[0.4 Milliliter],
            (*)TertiarySolidPhaseExtractionWashTemperature -> Ambient,
            TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null,*)
            TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
            TertiarySolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure,
            TertiarySolidPhaseExtractionWashTime -> 1 Minute,
            CollectTertiarySolidPhaseExtractionWashFlowthrough -> False,
            TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Not supported for now
    (*Test case: Alternative resolution*)
    Example[{Options, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, "TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and TertiarySolidPhaseExtractionWashTemperature is not Ambient or Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        TertiarySolidPhaseExtractionWashTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> 3 Minute}]
      },
      TimeConstraint -> 3600
    ],*)
    Example[{Options, {TertiarySolidPhaseExtractionWashCentrifugeIntensity,TertiarySolidPhaseExtractionWashPressure}, "If SolidPhaseExtractionTechnique is set to Centrifuge, unless otherwise specified, 1) TertiarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed, 2) TertiarySolidPhaseExtractionWashPressure is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"],
        SolidPhaseExtractionTechnique -> Centrifuge,
        TertiarySolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{TertiarySolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM,
          TertiarySolidPhaseExtractionWashPressure -> Null}]
      },
      TimeConstraint -> 3600
    ],
    (* -- SPE Elution Options -- *)
    (*Test Case: Elution is turned off*)
    Example[{Options, {SolidPhaseExtractionElutionSolution, SolidPhaseExtractionElutionSolutionVolume, SolidPhaseExtractionElutionSolutionTemperature, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, SolidPhaseExtractionElutionCentrifugeIntensity, SolidPhaseExtractionElutionPressure, SolidPhaseExtractionElutionTime}, "If Purification contains SolidPhaseExtraction and SolidPhaseExtractionElutionSolution is Null (specified or resolved when SolidPhaseExtractionStrategy -> Negative), other solid phase extraction elution options are set to Null:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        SolidPhaseExtractionElutionSolution -> Null,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionElutionSolutionVolume -> Null,
            (*)SolidPhaseExtractionElutionSolutionTemperature -> Ambient,
            SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> Null,*)
            SolidPhaseExtractionElutionCentrifugeIntensity -> Null,
            SolidPhaseExtractionElutionPressure -> Null,
            SolidPhaseExtractionElutionTime -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Test Case: most default, nothing specified*)
    Example[{Options, {SolidPhaseExtractionElutionSolution, SolidPhaseExtractionElutionSolutionVolume, SolidPhaseExtractionElutionSolutionTemperature, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, SolidPhaseExtractionElutionCentrifugeIntensity, SolidPhaseExtractionElutionPressure, SolidPhaseExtractionElutionTime}, "If Purification contains SolidPhaseExtraction, SolidPhaseExtractionElutionSolution is set to Model[Sample,StockSolution,\"50 mM Glycine pH 2.8, sterile filtered\"], unless otherwise specified, 1) SolidPhaseExtractionElutionSolutionVolume is resolved by ExperimentSolidPhaseExtraction, 2) SolidPhaseExtractionElutionSolutionTemperature is set to Ambient, 3) SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime is set to Null if SolidPhaseExtractionElutionSolutionTemperature is Ambient or Null, 4) SolidPhaseExtractionElutionCentrifugeIntensity is set to Null if SolidPhaseExtractionTechnique is Pressure (specified or by default), 5) SolidPhaseExtractionElutionPressure is set to the MaxRoboticAirPressure if SolidPhaseExtractionTechnique is Pressure (specified or by default), 6) SolidPhaseExtractionElutionTime is automatically set to 1 Minute:"},
      ExperimentExtractProtein[
        Object[Sample,"ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Method -> Custom,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            SolidPhaseExtractionElutionSolution -> ObjectP[Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"]],(*"id:eGakldadjlEe" 50 mM Glycine pH 2.8, sterile filtered*)
            SolidPhaseExtractionElutionSolutionVolume -> EqualP[0.4 Milliliter],
            (*)SolidPhaseExtractionElutionSolutionTemperature -> Ambient,
            SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> Null,*)
            SolidPhaseExtractionElutionCentrifugeIntensity -> Null,
            SolidPhaseExtractionElutionPressure -> $MaxRoboticAirPressure,
            SolidPhaseExtractionElutionTime -> 1 Minute
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*Not supported for now
    (*Test case: Alternative resolution*)
    Example[{Options, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, "SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SolidPhaseExtractionElutionSolutionTemperature is not Ambient or Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionElutionSolutionTemperature -> 37 Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> 3 Minute}]
      },
      TimeConstraint -> 3600
    ],*)
    Example[{Options, {SolidPhaseExtractionElutionCentrifugeIntensity,SolidPhaseExtractionElutionPressure}, "If SolidPhaseExtractionTechnique is set to Centrifuge, unless otherwise specified, 1) SolidPhaseExtractionElutionCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed, 2) SolidPhaseExtractionElutionPressure is set to Null:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"],
        SolidPhaseExtractionTechnique -> Centrifuge,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{SolidPhaseExtractionElutionCentrifugeIntensity -> 5000 RPM,
          SolidPhaseExtractionElutionPressure -> Null}]
      },
      TimeConstraint -> 3600
    ],

    (*Shared LLE tests*)

    (* Basic Example *)
    Example[{Basic, "Crude samples can be purified with liquid-liquid extraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],

    (* - Liquid-liquid Extraction Options - *)

    (* -- LiquidLiquidExtractionTechnique Tests -- *)
    Example[{Options,LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are set for removing one layer from another, then pipetting is used for the liquid-liquid extraction technique:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        (*If all specified options are False, it is not considered specified when resolving Purification steps, and will resolved to {LLE,Precipitation} which will unnecessarily slow down the tests*)
        Purification->LiquidLiquidExtraction,
        IncludeLiquidBoundary -> {False,False,False},
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are not set for removing one layer from another, then a phase separator is used for the liquid-liquid extraction technique:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionDevice Tests --*)
    Example[{Options,LiquidLiquidExtractionDevice, "If pipetting is used as the technique for physically separating the different phases during the liquid-liquid extraction, then a phase separator is not specified (since a phase separator is not being used):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionDevice -> Null
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionDevice, "If a phase separator is used as the technique for physically separating the different phases during the liquid-liquid extraction, then a standard phase separator (Model[Container,Plate,PhaseSeparator,\"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits\"]) is selected for use:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionDevice -> ObjectP[Model[Container,Plate,PhaseSeparator,"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionSelectionStrategy -- *)
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If there is only one round of liquid-liquid extraction, then a selection strategy is not specified (since a selection strategy is only required for multiple extraction rounds):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round matches the target phase, then the selection strategy is positive:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round does not match the target phase, then the selection strategy is negative:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If nothing else is specified, then the selection strategy is set to positive:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
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
      TimeConstraint -> 1800
    ],

    (* -- IncludeLiquidBoundary -- *)
    Example[{Options,IncludeLiquidBoundary, "If pipetting is used for physical separating the two phases after extraction, then the liquid boundary between the phases is not removed during each liquid-liquid extraction round:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            IncludeLiquidBoundary -> {False, False, False}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTargetPhase -- *)
    Example[{Options,LiquidLiquidExtractionTargetPhase, "The target phase is selected based on the phase that the protein is more likely to be found in based on the PredictDestinationPhase[...] function:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
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
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTargetLayer -- *)
    Example[{Options,LiquidLiquidExtractionTargetLayer, "The target layer for each extraction round is calculated from the density of the sample's aqueous and organic layers (if present in the sample), the density of the AqueousSolvent and OrganicSolvent options (if specified), and the target phase:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is less dense than the organic phase, then the target layer will be the top layer:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
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
      TimeConstraint -> 1800
    ],

    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is denser than the organic phase, then the target layer will be the bottom layer:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is less dense than the organic phase, then the target layer will be the bottom layer:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Organic,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
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
      TimeConstraint -> 1800
    ],

    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is denser than the organic phase, then the target layer will be the top layer:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        LiquidLiquidExtractionTargetPhase -> Organic,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
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
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionContainer -- *)
    Example[{Options,LiquidLiquidExtractionContainer, "If the sample is in a non-centrifuge-compatible container and centrifuging is specified, then the extraction container will be set to a centrifuge-compatible, 96-well 2mL deep well plate:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
        LiquidLiquidExtractionCentrifuge -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> {1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    Example[{Options,LiquidLiquidExtractionContainer, "If heating or cooling is specified, then the extraction container will be set to a 96-well 2mL deep well plate (since the robotic heater/cooler units are only compatible with Plate format containers):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
        LiquidLiquidExtractionTemperature -> 90.0*Celsius,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> {1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionContainer, "If the sample will not be centrifuged and the extraction will take place at ambient temperature, then the extraction container will be selected using the PreferredContainer function (to find a robotic-compatible container that will hold the sample):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
        LiquidLiquidExtractionCentrifuge -> False,
        LiquidLiquidExtractionTemperature -> Ambient,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionContainer -> ObjectP[Model[Container]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionContainerWell -- *)
    Example[{Options,LiquidLiquidExtractionContainerWell, "If a liquid-liquid extraction container is specified, then the first available well in the container will be used by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
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
      TimeConstraint -> 1800
    ],

    (* -- AqueousSolvent -- *)
    Example[{Options,AqueousSolvent, "If aqueous solvent is required for a separation, then water (Milli-Q water) will be used as the aqueous solvent:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolvent -> ObjectP[Model[Sample, "Milli-Q water"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- AqueousSolventVolume -- *)
    Example[{Options,AqueousSolventVolume, "If an aqueous solvent ratio is set, then the aqueous solvent volume is calculated from the ratio and the sample volume (SampleVolume/AqueousSolventRatio):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolventRatio -> 5,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolventVolume -> EqualP[0.04*Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,AqueousSolventVolume, "If an aqueous solvent is set, then the aqueous solvent volume will be 20% of the sample volume:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            AqueousSolventVolume -> EqualP[0.04*Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- AqueousSolventRatio -- *)
    Example[{Options,AqueousSolventRatio, "If an aqueous solvent volume is set, then the aqueous solvent ratio is calculated from the set aqueous solvent volume and the sample volume (SampleVolume/AqueousSolventVolume):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolventVolume -> 0.04*Milliliter,
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
      TimeConstraint -> 1800
    ],
    Example[{Options,AqueousSolventRatio, "If an aqueous solvent is set, then the aqueous solvent ratio is set to 5:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
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
      TimeConstraint -> 1800
    ],

    (* -- OrganicSolvent -- *)
    Example[{Options,OrganicSolvent, "If an organic solvent volume or organic solvent ratio are specified, then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventRatio -> 5,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent,"If an organic solvent volume or organic solvent ratio are specified, then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventVolume -> 0.2*Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent, "If the target phase is set to Organic and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent, "If the target phase is set to Aqueous and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a pipette will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> Pipette), then ethyl acetate (Model[Sample, \"Ethyl acetate, HPLC Grade\"]) will be used as the organic solvent:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Ethyl acetate, HPLC Grade"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a phase separator will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> PhaseSeparator), Model[Sample, \"Chloroform\"] will be used if Model[Sample, \"Ethyl acetate, HPLC Grade\"] is not dense enough to be denser than the aqueous layer, since the organic layer needs to be below the aqueous layer to pass through the hydrophobic frit:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolvent -> ObjectP[Model[Sample, "Chloroform"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- OrganicSolventVolume -- *)
    Example[{Options,OrganicSolventVolume, "If an organic solvent ratio is set, then the organic solvent volume is calculated from the ratio and the sample volume (SampleVolume/OrganicSolventRatio):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventRatio -> 5,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolventVolume -> EqualP[0.04*Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolventVolume, "If an organic solvent is set, then the organic solvent volume will be 20% of the sample volume:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            OrganicSolventVolume -> EqualP[0.04*Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- OrganicSolventRatio -- *)
    Example[{Options,OrganicSolventRatio, "If an organic solvent volume is set, then the organic solvent ratio is calculated from the set organic solvent volume and the sample volume (SampleVolume/OrganicSolventVolume):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventVolume -> 0.04*Milliliter,
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
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolventRatio, "If an organic solvent is set, then the organic solvent ratio is set to 5:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
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
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionSolventAdditions -- *)
    Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an organic or unknown phase, then an aqueous solvent is added to that sample:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {{ObjectP[], ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an aqueous phase, then organic solvent is added to that sample:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {{ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]..}}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of an extraction is biphasic, then no solvent is added for the first extraction:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Biphasic Previously Extracted Protein Sample "<>$SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSolventAdditions -> {None, ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- Demulsifier -- *)
    Example[{Options,Demulsifier, "If the demulsifier additions are specified, then the specified demulsifier will be used:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        DemulsifierAdditions -> {Model[Sample, StockSolution, "5M Sodium Chloride"], None, None},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Demulsifier -> ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,Demulsifier, "If a demulsifier amount is specified, then a 5M sodium chloride solution will be used as the demulsifier:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        DemulsifierAmount -> 0.1*Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            Demulsifier -> ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,Demulsifier, "If no demulsifier options are specified, then a demulsifier is not used:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
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
      TimeConstraint -> 1800
    ],

    (* -- DemulsifierAmount -- *)
    Example[{Options,DemulsifierAmount, "If demulsifier and/or demulsifier additions are specified, then the demulsifier amount is set to 10% of the sample volume:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAmount -> EqualP[0.02*Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- DemulsifierAdditions -- *)
    Example[{Options,DemulsifierAdditions, "If a demulsifier is not specified, then the demulsifier additions are set to None for each round:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],
    Example[{Options,DemulsifierAdditions, "If there will only be one round of liquid-liquid extraction and a demulsifier is specified, then the demulsifier will be added for that one extraction round:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 1,
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the organic phase will be used in subsequent extraction rounds, then the demulsifier will be added for each extraction round (since the demulsifier will likely be removed with the aqueous phase each round):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]..}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the aqueous phase will be used in subsequent extraction rounds, then the demulsifier will only be added for the first extraction round (since the demulsifier is usually a salt solution which stays in the aqueous phase):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]], None, None}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTemperature -- *)
    Example[{Options,LiquidLiquidExtractionTemperature, "If not specified by the user nor the method, the liquid-liquid extraction is carried out at ambient temperature by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTemperature -> Ambient
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- NumberOfLiquidLiquidExtractions -- *)
    Example[{Options,NumberOfLiquidLiquidExtractions, "If not specified by the user nor the method, the number of liquid-liquid extraction is 3 by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            NumberOfLiquidLiquidExtractions -> 3
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixType -- *)
    Example[{Options,LiquidLiquidExtractionMixType, "If a mixing time or mixing rate for the liquid-liquid extraction is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixTime -> 1*Minute,
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionMixType, "If mixing options are not specified, then the sample will be mixed via pipetting:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixTime -- *)
    Example[{Options,LiquidLiquidExtractionMixTime, "If the liquid-liquid extraction mixture will be mixed by shaking, then the mixing time is set to 30 seconds by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixTime -> EqualP[30*Second]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixRate -- *)
    Example[{Options,LiquidLiquidExtractionMixRate, "If the liquid-liquid extraction mixture will be mixed by shaking, then the mixing rate is set to 300 RPM (revolutions per minute) by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixRate -> EqualP[300 Revolution/Minute]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- NumberOfLiquidLiquidExtractionMixes -- *)
    Example[{Options,NumberOfLiquidLiquidExtractionMixes, "If the liquid-liquid extraction mixture will be mixed by pipette, then the number of mixes (number of times the liquid-liquid extraction mixture is pipetted up and down) is set to 10 by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixVolume -- *)
    Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        OrganicSolventVolume -> 0.2*Milliliter,
        NumberOfLiquidLiquidExtractions -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixVolume -> EqualP[0.2*Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        OrganicSolventVolume -> 1.75*Milliliter,
        NumberOfLiquidLiquidExtractions -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionMixVolume -> EqualP[0.970*Milliliter]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionSettlingTime -- *)
    Example[{Options,LiquidLiquidExtractionSettlingTime, "If not specified by the user nor the method, the liquid-liquid extraction solution is allowed to settle for 1 minute by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionSettlingTime -> EqualP[1 * Minute]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionCentrifuge -- *)
    Example[{Options,LiquidLiquidExtractionCentrifuge, "If any other centrifuging options are specified, then the liquid-liquid extraction solution will be centrifuged in order to separate the solvent phases:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionCentrifugeTime -> 1*Minute,
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionCentrifuge, "If the separated solvent phases will be pysically separated with a pipette and the sample is in a centrifuge-compatible container, then the liquid-liquid extraction solution will be centrifuged in order to separate the solvent phases:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionCentrifuge, "If not specified by the user nor the method, the liquid-liquid extraction solution will not be centrifuged:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionCentrifugeInstrument -- *)
    Example[{Options,LiquidLiquidExtractionCentrifugeInstrument, "If the liquid-liquid extraction solution will be centrifuged, then the integrated centrifuge model on the chosen robotic instrument will be automatically used:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        RoboticInstrument -> Object[Instrument, LiquidHandler, "id:WNa4ZjRr56bE"],
        LiquidLiquidExtractionCentrifuge -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeInstrument -> ObjectP[Model[Instrument,Centrifuge,"HiG4"]]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionCentrifugeIntensity -- *)
    Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "The liquid-liquid extraction solution will be centrifuged at the lesser intensity between MaxIntensity of the centrifuge model and MaxCentrifugationForce of the plate model:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument,Centrifuge,"HiG4"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeIntensity -> EqualP[2000 GravitationalAcceleration]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionCentrifugeTime -- *)
    Example[{Options,LiquidLiquidExtractionCentrifugeTime, "If the liquid-liquid extraction solution will be centrifuged, the liquid-liquid extraction solution will be centrifuged for 2 minutes by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionCentrifuge -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionCentrifugeTime -> EqualP[2*Minute]
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidBoundaryVolume -- *)
    Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the top layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the sample container at the location of the layer boundary for each extraction round:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        NumberOfLiquidLiquidExtractions -> 1,
        LiquidLiquidExtractionTransferLayer -> {Top},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidBoundaryVolume -> {EqualP[0.02*Milliliter]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    (*TODO::Error::NoSampleExistsInWell*)
    Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the bottom layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the bottom of the sample container for each extraction round:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        NumberOfLiquidLiquidExtractions -> 1,
        LiquidLiquidExtractionTransferLayer -> {Bottom},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidBoundaryVolume -> {EqualP[0.02*Milliliter]}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTransferLayer -- *)
    Example[{Options,LiquidLiquidExtractionTransferLayer, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette, the top layer will be removed from the bottom layer during each extraction round by default:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            LiquidLiquidExtractionTransferLayer -> {Top, Top, Top}
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerStorageCondition -- *)
    Example[{Options,ImpurityLayerStorageCondition, "ImpurityLayerStorageCondition is set to Disposal for each extraction round if not otherwise specified:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ImpurityLayerStorageCondition -> Disposal
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerContainerOut -- *)

    Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is set to Aqueous and LiquidLiquidExtractionTechnique is set to PhaseSeparator, ImpurityLayerContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
	  ExperimentExtractProtein[
		Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
		LiquidLiquidExtractionTargetPhase -> Aqueous,
		LiquidLiquidExtractionTechnique -> PhaseSeparator,
		Output -> {Result, Options}
	  ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ImpurityLayerContainerOut -> ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]
          }
        ]
      },
	  TimeConstraint -> 1800
	],
    Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is not set to Aqueous or LiquidLiquidExtractionTechnique is not set to PhaseSeparator, ImpurityLayerContainerOut is automatically determined by the PreferredContainer function:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerContainerOutWell -- *)
    Example[{Options,ImpurityLayerContainerOutWell, "ImpurityLayerContainerOutWell is automatically set to the first empty well of the ImpurityLayerContainerOut:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        ImpurityLayerContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ImpurityLayerContainerOutWell -> "A1"
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerLabel -- *)
    Example[{Options,ImpurityLayerLabel, "ImpurityLayerLabel is automatically generated for the impurity layer sample:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ImpurityLayerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerContainerLabel -- *)
    Example[{Options,ImpurityLayerContainerLabel, "ImpurityLayerContainerLabel is automatically generated for the impurity layer sample:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[
          {
            ImpurityLayerContainerLabel -> (_String)
          }
        ]
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages, "LiquidLiquidExtractionOptionMismatch", "An error is returned if any liquid-liquid extraction options are set, but LiquidLiquidExtraction is not specified in Purification:"},
      ExperimentExtractProtein[
        Object[Sample, "ExperimentExtractProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {Precipitation},
        LiquidLiquidExtractionSettlingTime -> 1*Minute,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::LiquidLiquidExtractionConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ]
  },
  Stubs :> {
    $AllowPublicObjects=True
  },
  Parallel -> True,
  HardwareConfiguration -> HighRAM,
  TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct, Upload::Warning, Warning::ConflictingSourceAndDestinationAsepticHandling},
  SymbolSetUp :> Module[{allObjects,functionName,existingObjects,allSampleObjects},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    functionName="ExperimentExtractProtein";
    (*Gather all the objects created in SymbolSetUp*)
    allObjects=Cases[Flatten[{
      (*containers*)
      Table[Object[Container, Plate, functionName <> " test 96-well plate " <>ToString[x]<> $SessionUUID],{x,12}],
      Object[Container, Vessel, functionName <> " test 50mL tube " <> $SessionUUID],
      Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test ethanol 50mL tube " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test NaCl 50mL tube " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test 50mM glycine 50mL tube " <> $SessionUUID],
      Object[Container, Vessel, functionName <> " test filtered PBS tube " <> $SessionUUID],
      (*Object[Sample]*)
      Object[Sample, functionName <> " Suspended Microbial Cell Sample " <> $SessionUUID],
      Object[Sample, functionName <> " Suspended Microbial Cell Sample with Unspecified CellType Field " <> $SessionUUID],
      Object[Sample, functionName <>  " Solid Media Cell Sample "<>$SessionUUID],
      Object[Sample, functionName <> " Adherent Mammalian Cell Sample "<>$SessionUUID],
      Object[Sample, functionName <>" Suspended Mammalian Cell Sample "<>$SessionUUID],
      Object[Sample, functionName <>" Suspended Mammalian Cell Sample with Cell Concentration Info "<>$SessionUUID],
      Object[Sample, functionName <> " Lysate Sample " <> $SessionUUID],
      Object[Sample, functionName <>  " Lysate Sample in Filter "<>$SessionUUID],
      Object[Sample,functionName <> " Previously Extracted Protein Sample "<>$SessionUUID],
      Object[Sample, functionName <> " Biphasic Previously Extracted Protein Sample "<>$SessionUUID],
      Object[Sample, functionName <> " Previously Extracted Protein Sample in Ethanol "<>$SessionUUID],
      Object[Sample, functionName <> " Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
      Object[Sample, functionName <> " test ethanol "<>$SessionUUID],
      Object[Sample, functionName <> " test NaCl "<>$SessionUUID],
      Object[Sample, functionName <> " test 50mM glycine "<>$SessionUUID],
      Object[Sample, functionName <> " test filtered PBS "<>$SessionUUID],
      (*Method*)
      Object[Method, Extraction, Protein, functionName <> " Test Method for Microbial Cells " <> $SessionUUID],
      Object[Method, Extraction, Protein, functionName <> " Test Method for Microbial Cells All Proteins " <> $SessionUUID],
      Object[Method, Extraction, Protein, functionName <> " Conflicting MBS Test Method 1 " <> $SessionUUID],
      Object[Method, Extraction, Protein, functionName <> " Conflicting MBS Test Method 2 " <> $SessionUUID],
      Object[Method, Extraction, Protein, functionName <> " Conflicting MBS Test Method 3 " <> $SessionUUID]
    }],ObjectP[]];
    (*Check whether the names we want to give below already exist in the database*)
    existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
    (*Erase any test objects that we failed to erase in the last unit test*)
    Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

    allSampleObjects={
      Object[Sample, functionName <> " Suspended Microbial Cell Sample " <> $SessionUUID],
      Object[Sample, functionName <> " Suspended Microbial Cell Sample with Unspecified CellType Field " <> $SessionUUID],
      Object[Sample, functionName <>  " Solid Media Cell Sample "<>$SessionUUID],
      Object[Sample, functionName <> " Adherent Mammalian Cell Sample "<>$SessionUUID],
      Object[Sample, functionName <>" Suspended Mammalian Cell Sample "<>$SessionUUID],
      Object[Sample, functionName <>" Suspended Mammalian Cell Sample with Cell Concentration Info "<>$SessionUUID],
      Object[Sample, functionName <> " Lysate Sample " <> $SessionUUID],
      Object[Sample, functionName <>  " Lysate Sample in Filter "<>$SessionUUID],
      Object[Sample,functionName <> " Previously Extracted Protein Sample "<>$SessionUUID],
      Object[Sample, functionName <> " Biphasic Previously Extracted Protein Sample "<>$SessionUUID],
      Object[Sample, functionName <> " Previously Extracted Protein Sample in Ethanol "<>$SessionUUID],
      Object[Sample, functionName <> " Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID]
    };

    Block[{$AllowSystemsProtocols=True},
      (*Make test containers*)
      Upload[
        Join[
          Flatten[{Table[
            <|
              Type->Object[Container,Plate],
              Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],
                Objects],
              Name->functionName<>" test 96-well plate " <>ToString[x]<> $SessionUUID,
              Site->Link[$Site],
              DeveloperObject->True
            |>,
            {x,12}]}],
          (*Upload developer object test ethanol container and sample*)
          {
            <|
              Type -> Object[Container, Vessel],
              Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
              Name -> functionName<>" test 50mL tube "<>$SessionUUID,
              Site -> Link[$Site],
              DeveloperObject -> True
            |>,
            <|
              Type -> Object[Container, Vessel],
              Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
              Name -> functionName<>" test ethanol 50mL tube "<>$SessionUUID,
              Site -> Link[$Site],
              DeveloperObject -> True
            |>,
            <|
              Type -> Object[Container, Vessel],
              Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
              Name -> functionName<>" test NaCl 50mL tube "<>$SessionUUID,
              Site -> Link[$Site],
              DeveloperObject -> True
            |>,
            <|
              Type -> Object[Container, Vessel],
              Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
              Name -> functionName<>" test 50mM glycine 50mL tube "<>$SessionUUID,
              Site -> Link[$Site],
              DeveloperObject -> True
            |>,
            <|
              Type -> Object[Container, Vessel],
              Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
              Name -> functionName<>" test filtered PBS tube "<>$SessionUUID,
              Site -> Link[$Site],
              DeveloperObject -> True
            |>
          }
        ]
      ];

      UploadSample[
        Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
        {"A1",Object[Container, Vessel, functionName <> " test ethanol 50mL tube " <> $SessionUUID]},
        Name -> functionName <> " test ethanol "<>$SessionUUID,
        InitialAmount ->45 Milliliter,
        State -> Liquid,
        FastTrack -> True
      ];
      UploadSample[
        Model[Sample, StockSolution, "id:AEqRl954GJb6"],(*Model[Sample, StockSolution, "5M Sodium Chloride"]*)
        {"A1",Object[Container, Vessel, functionName <> " test NaCl 50mL tube " <> $SessionUUID]},
        Name -> functionName <> " test NaCl "<>$SessionUUID,
        InitialAmount ->45 Milliliter,
        State -> Liquid,
        FastTrack -> True
      ];
      UploadSample[
        Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"],(*"id:eGakldadjlEe"*)
        {"A1",Object[Container, Vessel, functionName <> " test 50mM glycine 50mL tube " <> $SessionUUID]},
        Name -> functionName <> " test 50mM glycine "<>$SessionUUID,
        InitialAmount ->45 Milliliter,
        State -> Liquid,
        FastTrack -> True
      ];
      UploadSample[
        Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],(*"Filtered PBS, Sterile"*)
        {"A1",Object[Container, Vessel, functionName <> " test filtered PBS tube " <> $SessionUUID]},
        Name -> functionName <> " test filtered PBS "<>$SessionUUID,
        InitialAmount ->45 Milliliter,
        State -> Liquid,
        FastTrack -> True
      ];
      Upload[{
        <|Object -> Object[Sample, functionName <> " test ethanol " <> $SessionUUID], Status -> Available, DeveloperObject -> True|>,
        <|Object -> Object[Sample, functionName <> " test NaCl " <> $SessionUUID], Status -> Available, DeveloperObject -> True|>,
        <|Object -> Object[Sample, functionName <> " test 50mM glycine " <> $SessionUUID], Status -> Available, DeveloperObject -> True|>,
        <|Object -> Object[Sample, functionName <> " test filtered PBS " <> $SessionUUID], Status -> Available, DeveloperObject -> True|>
      }
      ];

      (*Make test molecules*)
      UploadProtein[
       functionName <> " test protein "<> $SessionUUID,
        State->Solid,
        MSDSFile -> NotApplicable,
        BiosafetyLevel->"BSL-1",
        IncompatibleMaterials->{None}
      ];
      (* Create some samples for testing purposes *)
      UploadSample[
        (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
        {
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
          {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
          {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
          {{10^10 EmeraldCell/Milliliter, Model[Cell, Mammalian, "HEK293"]}},
          {{100 VolumePercent, Model[Lysate, "Simple Western Control HeLa Lysate"]}},
          {{100 VolumePercent, Model[Lysate, "Simple Western Control HeLa Lysate"]}},
          {{95 VolumePercent, Model[Molecule, "Water"]},{5 VolumePercent, Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID]}},
          {{45 VolumePercent, Model[Molecule, "Ethyl acetate"]},{50 VolumePercent, Model[Molecule, "Water"]},{5 VolumePercent,Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID]}},
          {{95 VolumePercent, Model[Molecule, "Ethanol"]},{5 VolumePercent, Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID]}},
          {{95 VolumePercent, Model[Molecule, "Water"]},{5 VolumePercent, Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID]}}
        },
        {
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 1" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 2" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 3" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 4" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 5" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 6" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 7" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 8" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 9" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 10" <> $SessionUUID]},
          {"A1",Object[Container, Plate, functionName <> " test 96-well plate 11" <> $SessionUUID]},
          {"A1",Object[Container, Vessel, functionName <> " test 50mL tube " <> $SessionUUID]}
        },
        Name -> {
          functionName <> " Suspended Microbial Cell Sample " <> $SessionUUID,
          functionName <> " Suspended Microbial Cell Sample with Unspecified CellType Field " <> $SessionUUID,
          functionName <>  " Solid Media Cell Sample "<>$SessionUUID,
          functionName <> " Adherent Mammalian Cell Sample "<>$SessionUUID,
          functionName <> " Suspended Mammalian Cell Sample "<>$SessionUUID,
          functionName <>" Suspended Mammalian Cell Sample with Cell Concentration Info "<>$SessionUUID,
          functionName <> " Lysate Sample " <> $SessionUUID,
          functionName <>  " Lysate Sample in Filter "<>$SessionUUID,
          functionName <> " Previously Extracted Protein Sample "<>$SessionUUID,
          functionName <> " Biphasic Previously Extracted Protein Sample "<>$SessionUUID,
          functionName <> " Previously Extracted Protein Sample in Ethanol "<>$SessionUUID,
          functionName <> " Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID
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
          0.2 Milliliter
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
          False
        },
        State -> Liquid,
        FastTrack -> True,
        StorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"] (*Model[StorageCondition, "Refrigerator"]*)
      ];

      (* Make some changes to our samples for testing purposes *)
      Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>]& /@ allSampleObjects;
      (*Upload additional fields to the set up objects.*)
      Map[
        Upload[{
          <|
            Object -> #,
            Append[Analytes] -> Link[Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID]]
          |>
        }]&,
        allSampleObjects
      ];
      (*Create test Method Object*)
      Upload[
        {
          <|
            Type -> Object[Method, Extraction, Protein],
            Name -> functionName <> " Test Method for Microbial Cells " <> $SessionUUID,
            DeveloperObject -> True,
            Lyse -> True,
            Append[CellType] -> Bacterial,
            TargetProtein -> Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID],
            NumberOfLysisSteps -> 3,
            PreLysisPellet -> True,
            PreLysisPelletingIntensity -> 3500 GravitationalAcceleration,
            PreLysisPelletingTime -> 12 Minute,
            LysisSolution -> Link[Model[Sample, "B-PER Bacterial Protein Extraction Reagent"]],
            (*Lysis buffer protocol reference: https://www.thermofisher.com/order/catalog/product/78248*)
            LysisMixType -> Pipette,
            NumberOfLysisMixes -> 10,
            LysisTime -> 30 Minute,
            LysisTemperature -> 37 Celsius,
            (*Let's try out the secondary lysis options although not needed with B-PER protocol`*)
            SecondaryLysisSolution -> Link[Model[Sample, "Milli-Q water"]],
            SecondaryLysisMixType -> Shake,
            SecondaryLysisMixRate -> 200 RPM,
            SecondaryLysisMixTime -> 1 Minute,
            SecondaryLysisMixTemperature -> 4 Celsius,
            SecondaryLysisTime -> 45 Second,
            SecondaryLysisTemperature -> 4 Celsius,
            ClarifyLysate -> True,
            ClarifyLysateIntensity -> 3500 GravitationalAcceleration,
            ClarifyLysateTime -> 18 Minute,
            (*TCA/Acetone protein precipitation protocol reference: https://www.sigmaaldrich.com/US/en/technical-documents/technical-article/protein-biology/protein-lysis-and-extraction/precipitation-procedures;
            https://rtsf.natsci.msu.edu/sites/_rtsf/assets/File/2016_Acetone_Precipitation_of_Proteins.pdf*)
            Purification -> {LiquidLiquidExtraction,MagneticBeadSeparation},
            LiquidLiquidExtractionSelectionStrategy -> Positive,
            LiquidLiquidExtractionTechnique -> Pipette,
            LiquidLiquidExtractionTargetPhase -> Aqueous,
            AqueousSolvent -> Model[Sample,"Milli-Q water"],
            OrganicSolvent -> Model[Sample, "Chloroform"],
            Demulsifier->None,
            LiquidLiquidExtractionTemperature -> 4 Celsius,
            NumberOfLiquidLiquidExtractions -> 1,
            LiquidLiquidExtractionCentrifuge -> False,
            MagneticBeadSeparationMode -> Affinity,
            MagneticBeadSeparationSelectionStrategy -> Positive,
            MagneticBeads -> Link[Model[Sample, "Pierce Ni-NTA Magnetic Agarose Beads"]],
            MagneticBeadSeparationEquilibration -> True,
            MagneticBeadSeparationEquilibrationSolution -> Link[Model[Sample, StockSolution, "Pierce Ni-NTA Agarose Magnetic Bead Equilibration Buffer"]],
            MagneticBeadSeparationEquilibrationMix->True,
            MagneticBeadSeparationEquilibrationMixType -> Shake,
            MagneticBeadSeparationEquilibrationMixRate -> 300 RPM,
            MagneticBeadSeparationEquilibrationMixTime -> 1 Minute,
            EquilibrationMagnetizationTime -> 1 Minute,
            MagneticBeadSeparationLoadingMixType -> Shake,
            MagneticBeadSeparationLoadingMixRate -> 300 RPM,
            MagneticBeadSeparationLoadingMixTime -> 1 Minute,
            LoadingMagnetizationTime -> 1 Minute,
            MagneticBeadSeparationElution->True,
            NumberOfMagneticBeadSeparationElutions ->1,
            MagneticBeadSeparationElutionMixType -> Shake,
            MagneticBeadSeparationElutionMixRate -> 300 RPM,
            MagneticBeadSeparationElutionMixTime -> 10 Minute
          |>,
          <|
            Type -> Object[Method, Extraction, Protein],
            Name -> functionName <> " Test Method for Microbial Cells All Proteins " <> $SessionUUID,
            DeveloperObject -> True,
            Lyse -> False,
            TargetProtein -> All,
            Purification -> {Precipitation,SolidPhaseExtraction},
            PrecipitationTargetPhase -> Solid,
            PrecipitationSeparationTechnique -> Pellet,
            PrecipitationReagent -> Link[Model[Sample, StockSolution, "TCA (10%, w/v) in acetone with 2-mercaptoethanol (0.07%)"]],
            PrecipitationReagentTemperature -> 4 Celsius,
            PrecipitationReagentEquilibrationTime -> 5 Minute,
            PrecipitationMixType -> Shake,
            PrecipitationMixRate -> 300 RPM,
            PrecipitationMixTemperature -> 4 Celsius,
            PrecipitationMixTime -> 1 Minute,
            PrecipitationTime -> 1 Hour,
            PrecipitationTemperature -> 0 Celsius,
            PrecipitationPelletCentrifugeIntensity -> 3500 GravitationalAcceleration,
            PrecipitationPelletCentrifugeTime -> 30 Minute,
            PrecipitationDryingTime -> 30 Minute,
            PrecipitationDryingTemperature -> 0 Celsius,
            PrecipitationNumberOfWashes -> 2,
            PrecipitationWashSolution -> Link[Model[Sample, "Acetone, Reagent Grade"]],
            PrecipitationResuspensionBuffer -> Link[Model[Sample, StockSolution, "0.5% SDS, 50mM Tris-HCl 6.8pH, with 20mM DTT"]],
            PrecipitationResuspensionBufferTemperature -> 4 Celsius,
            PrecipitationResuspensionBufferEquilibrationTime -> 1 Minute,
            PrecipitationResuspensionMixType -> Pipette,
            PrecipitationNumberOfResuspensionMixes -> 20,
            SolidPhaseExtractionCartridge ->Link[Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 1000uL"]],
            SolidPhaseExtractionStrategy ->Positive,
            SolidPhaseExtractionTechnique -> Centrifuge,
            SolidPhaseExtractionLoadingTime -> 1 Minute,
            SolidPhaseExtractionElutionSolution -> Link[Model[Sample, "Milli-Q water"]],
            SolidPhaseExtractionElutionTime -> 1 Minute
          |>,
          <|
            Type -> Object[Method, Extraction, Protein],
            Name -> functionName <> " Conflicting MBS Test Method 1 " <> $SessionUUID,
            DeveloperObject -> True,
            Lyse -> False,
            TargetProtein -> All,
            Purification -> {MagneticBeadSeparation},
            MagneticBeadSeparationSelectionStrategy -> Positive,
            MagneticBeadSeparationMode -> IonExchange,
            MagneticBeads -> Link[Model[Sample, "Pierce Ni-NTA Magnetic Agarose Beads"]]
          |>,
          <|
            Type -> Object[Method, Extraction, Protein],
            Name -> functionName <> " Conflicting MBS Test Method 2 " <> $SessionUUID,
            DeveloperObject -> True,
            Lyse -> False,
            TargetProtein -> All,
            Purification -> {MagneticBeadSeparation},
            MagneticBeadSeparationSelectionStrategy -> Positive,
            MagneticBeadSeparationMode -> ReversePhase,(*Differs with 1*)
            MagneticBeads -> Link[Model[Sample, "Pierce Ni-NTA Magnetic Agarose Beads"]]
          |>,
          <|
            Type -> Object[Method, Extraction, Protein],
            Name -> functionName <> " Conflicting MBS Test Method 3 " <> $SessionUUID,
            DeveloperObject -> True,
            Lyse -> False,
            TargetProtein -> All,
            Purification -> {MagneticBeadSeparation},
            MagneticBeadSeparationSelectionStrategy -> Negative,(*Differs with 1*)
            MagneticBeadSeparationMode -> IonExchange,
            MagneticBeads -> Link[Model[Sample, "Pierce Ni-NTA Magnetic Agarose Beads"]]
          |>
        }
      ];
    ]
  ],
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects,functionName, existsFilter},
      functionName = "ExperimentExtractProtein";
      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects= Cases[Flatten[{
        (*containers*)
        Table[Object[Container, Plate, functionName <> " test 96-well plate " <>ToString[x]<> $SessionUUID],{x,12}],
        Object[Container, Vessel, functionName <> " test 50mL tube " <> $SessionUUID],
        Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID],
        Object[Container, Vessel, functionName <> " test ethanol 50mL tube " <> $SessionUUID],
        Object[Container, Vessel, functionName <> " test NaCl 50mL tube " <> $SessionUUID],
        Object[Container, Vessel, functionName <> " test 50mM glycine 50mL tube " <> $SessionUUID],
        Object[Container, Vessel, functionName <> " test filtered PBS tube " <> $SessionUUID],
        (*Object[Sample]*)
        Object[Sample, functionName <> " Suspended Microbial Cell Sample " <> $SessionUUID],
        Object[Sample, functionName <> " Suspended Microbial Cell Sample with Unspecified CellType Field " <> $SessionUUID],
        Object[Sample, functionName <>  " Solid Media Cell Sample "<>$SessionUUID],
        Object[Sample, functionName <> " Adherent Mammalian Cell Sample "<>$SessionUUID],
        Object[Sample, functionName <>" Suspended Mammalian Cell Sample "<>$SessionUUID],
        Object[Sample, functionName <>" Suspended Mammalian Cell Sample with Cell Concentration Info "<>$SessionUUID],
        Object[Sample, functionName <> " Lysate Sample " <> $SessionUUID],
        Object[Sample, functionName <>  " Lysate Sample in Filter "<>$SessionUUID],
        Object[Sample,functionName <> " Previously Extracted Protein Sample "<>$SessionUUID],
        Object[Sample, functionName <> " Biphasic Previously Extracted Protein Sample "<>$SessionUUID],
        Object[Sample, functionName <> " Previously Extracted Protein Sample in Ethanol "<>$SessionUUID],
        Object[Sample, functionName <> " Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
        Object[Sample, functionName <> " test ethanol "<>$SessionUUID],
        Object[Sample, functionName <> " test NaCl "<>$SessionUUID],
        Object[Sample, functionName <> " test 50mM glycine "<>$SessionUUID],
        Object[Sample, functionName <> " test filtered PBS "<>$SessionUUID],
        (*Method*)
        Object[Method, Extraction, Protein, functionName <> " Test Method for Microbial Cells " <> $SessionUUID],
        Object[Method, Extraction, Protein, functionName <> " Test Method for Microbial Cells All Proteins " <> $SessionUUID],
        Object[Method, Extraction, Protein, functionName <> " Conflicting MBS Test Method 1 " <> $SessionUUID],
        Object[Method, Extraction, Protein, functionName <> " Conflicting MBS Test Method 2 " <> $SessionUUID],
        Object[Method, Extraction, Protein, functionName <> " Conflicting MBS Test Method 3 " <> $SessionUUID]
      }],
        ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];
    ]
  )
];


(* ::Subsubsection::Closed:: *)
(*ExtractProtein*)

DefineTests[ExtractProtein,
  {

    Example[{Basic, "Form an ExtractProtein unit operation:"},
      ExtractProtein[
        Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID]
      ],
      _ExtractProtein
    ],

    Example[{Basic, "A RoboticCellPreparation protocol is generated when calling ExtractProtein:"},
      ExperimentRoboticCellPreparation[
        {
          ExtractProtein[
            Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID],
            Purification->None
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 3200
    ](*,

    (* TODO::Determine why labeling is not working for ExtractProtein when trying to pass on labeled samples. *)
    Example[{Basic, "A RoboticCellPreparation protocol is generated when calling ExtractProtein preceded and followed by other unit operations:"},
      ExperimentRoboticCellPreparation[
        {
          Mix[
            Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID]
          ],
          ExtractProtein[
            Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID],
            ExtractedProteinLabel -> "Extracted RNA Sample (Test for ExtractProtein) " <> $SessionUUID
          ],
          Transfer[
            Source -> "Extracted RNA Sample (Test for ExtractProtein) " <> $SessionUUID,
            Amount -> All,
            Destination -> Model[Container, Vessel, "50mL Tube"]
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
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
      Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID],
      Object[Container, Plate, "Test Plate 1 for ExtractProtein " <> $SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID],
          Object[Container, Plate, "Test Plate 1 for ExtractProtein " <> $SessionUUID]
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
        Name -> "Test Plate 1 for ExtractProtein " <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject -> True
      |>
    ];

    (* Create some samples for testing purposes *)
    sample1 = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
      {"A1", plate1},
      Name -> "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID,
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
        Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractProtein) " <> $SessionUUID],
        Object[Container, Plate, "Test Plate 1 for ExtractProtein " <> $SessionUUID]
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
  )
];
