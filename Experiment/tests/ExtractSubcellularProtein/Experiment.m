(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*ExperimentExtractSubcellularProtein Tests*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentExtractSubcellularProtein*)

DefineTests[ExperimentExtractSubcellularProtein,
  {
    (* Basic examples *)
    Example[{Basic,"Living cells are lysed and subcellular fractionated to isolate all cytosolic proteins from the cell without purification:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetSubcellularFraction -> Cytosolic,
        Purification->None
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],
    Example[{Basic,"Living cells are lysed and subcellular fractionated to isolate proteins from multiple subcellular fractions from the cell without purification:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetSubcellularFraction -> {Membrane,Cytosolic},
        Purification->None
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],
    Example[{Basic,"Multiple cell samples and types can undergo subcellular protein extraction in one experiment call:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample "<>$SessionUUID]
        },
        Purification->None
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],
    Example[{Basic,"Lysate samples can be subcellular fractionated and purified using the rudimentary purification steps from subcellular protein extraction:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Lysate Sample "<>$SessionUUID]
        },
        TargetSubcellularFraction -> {Nuclear, Membrane,Cytosolic},
        Purification -> {SolidPhaseExtraction}
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],

    (* Options *)

    (* - General Options - *)
    Example[{Options,RoboticInstrument, "If input cells are only Mammalian, then the bioSTAR liquid handler is used for the extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample "<>$SessionUUID],
        Purification->None,
        Output->Options
      ],
      KeyValuePattern[
        {
          RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "bioSTAR"]]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,RoboticInstrument, "If input cells have anything other than just Mammalian cells (Microbial or Yeast), then the microbioSTAR liquid handler is used for the extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification->None,
        Output->Options
      ],
      KeyValuePattern[
        {
          RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "microbioSTAR"]]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,RoboticInstrument, "If input cells have anything other than just Mammalian cells (Microbial or Yeast), then the microbioSTAR liquid handler is used for the extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification->None,
        Output->Options
      ],
      KeyValuePattern[
        {
          RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "microbioSTAR"]]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, WorkCell, "WorkCell is set to bioSTAR if the input sample contains only Mammalian cells:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample "<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{
        WorkCell -> bioSTAR
      }],
      TimeConstraint -> 1800
    ],

    Example[{Options, WorkCell, "WorkCell is set to microbioSTAR if the input sample contains anything other than Mammalian cells:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{
        WorkCell -> microbioSTAR
      }],
      TimeConstraint -> 1800
    ],

    Example[{Options, ExtractedCytosolicProteinContainer, "ExtractedCytosolicProteinContainer can be specified to collect the sample of the last step of the extraction for the cytosolic fraction unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        ExtractedCytosolicProteinContainer -> Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractedCytosolicProteinContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]],
        CytosolicFractionationSupernatantContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedMembraneProteinContainer, "ExtractedMembraneProteinContainer can be specified to collect the sample of the last step of the extraction for the membrane fraction unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        ExtractedMembraneProteinContainer -> {"A1",Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractedMembraneProteinContainer -> {"A1",ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]},
        MembraneFractionationSupernatantContainer -> {"A1",ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]}
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedNuclearProteinContainer, "ExtractedNuclearProteinContainer can be specified to collect the sample of the last step of the extraction for the nuclear fraction unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        ExtractedNuclearProteinContainer -> {"A1",{1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]}},
        NuclearFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractedNuclearProteinContainer -> {"A1",{1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
        NuclearFractionationFiltrateContainer -> {"A1",{1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedCytosolicProteinLabel, "ExtractedCytosolicProteinLabel can be specified for the collected nuclear protein sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification -> None,
        ExtractedCytosolicProteinLabel -> "My Favorite Protein Soup",
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractedCytosolicProteinLabel -> "My Favorite Protein Soup"
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedCytosolicProteinContainerLabel, "ExtractedCytosolicProteinContainerLabel can be specified for the container of the collected cytosolic protein sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification -> None,
        ExtractedCytosolicProteinContainerLabel -> "My Favorite Cytosolic Protein Soup Bowl",
        Output->Options
      ],
      KeyValuePattern[{
        ExtractedCytosolicProteinContainerLabel -> "My Favorite Cytosolic Protein Soup Bowl"
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedMembraneProteinLabel, "ExtractedMembraneProteinLabel can be specified for the collected membrane protein sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification -> None,
        ExtractedMembraneProteinLabel -> "My Favorite Membrane Protein Soup",
        Output -> Options
      ],
      KeyValuePattern[{
        ExtractedMembraneProteinLabel -> "My Favorite Membrane Protein Soup"
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedMembraneProteinContainerLabel, "ExtractedMembraneProteinContainerLabel can be specified for the container of the collected membrane protein sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification -> None,
        ExtractedMembraneProteinContainerLabel -> "My Favorite Membrane Protein Soup Bowl",
        Output->Options
      ],
      KeyValuePattern[{
        ExtractedMembraneProteinContainerLabel -> "My Favorite Membrane Protein Soup Bowl"
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedNuclearProteinLabel, "ExtractedNuclearProteinLabel can be specified for the collected cytsolic protein sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID],
        Purification -> None,
        ExtractedNuclearProteinLabel -> "My Favorite Nuclear Protein Soup",
        Output -> Options
      ],
      KeyValuePattern[{
        TargetSubcellularFraction -> {Cytosolic,Membrane,Nuclear},
        ExtractedNuclearProteinLabel -> "My Favorite Nuclear Protein Soup"
      }],
      TimeConstraint -> 1800
    ],
    Example[{Options, ExtractedNuclearProteinContainerLabel, "ExtractedNuclearProteinContainerLabel can be specified for the container of the collected nuclear protein sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID],
        Purification -> None,
        ExtractedNuclearProteinContainerLabel -> "My Favorite Nuclear Protein Soup Bowl",
        Output->Options
      ],
      KeyValuePattern[{
        TargetSubcellularFraction -> {Cytosolic,Membrane,Nuclear},
        ExtractedNuclearProteinContainerLabel -> "My Favorite Nuclear Protein Soup Bowl"
      }],
      TimeConstraint -> 1800
    ],
    (*TargetProtein*)
    Example[{Options,TargetProtein, "If TargetProtein is All and no options related to purification steps are specified,  Purification is set to {Precipitation}:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->All,
        LysisSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          TargetProtein->All,
          Purification->{Precipitation}
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,TargetProtein, "If TargetProtein is a Model[Molecule] and no options related to purification steps are specified by user or the method, Purification is set to {SolidPhaseExtraction}:"},
      (*Need to quiet this function call as there are a lot of volume related messages, but we want to make sure the purification is resolved to SPE without specifying any SPE options*)
      Quiet[ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->Model[Molecule,Protein,"ExperimentExtractSubcellularProtein test protein "<> $SessionUUID],
        Method->Custom,
        Output->Options
      ]],
      KeyValuePattern[
        {
          TargetProtein->ObjectP[Model[Molecule,Protein]],
          Purification->{SolidPhaseExtraction}
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,TargetProtein, "If TargetProtein is not specified by the user or method, it is set to All:"},
      (*Need to quiet this function call as there are a lot of volume related messages, but we want to make sure the purification is resolved to SPE without specifying any SPE options*)
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method->Custom,
        Output->Options
      ],
      KeyValuePattern[
        {
          TargetProtein->All,
          Purification->{Precipitation}
        }
      ],
      TimeConstraint -> 1800
    ],
    (*TargetSubcellularFraction*)
    Example[{Options,TargetSubcellularFraction, "If TargetSubcellularFraction is not specified by the user or method, and FractionationOrder is also left Automatic, TargetSubcellularFraction is set based on cell type informed by CellType option or the CellType field of the input sample. If the cell type is found to be Bacterial, TargetSubcellularFraction is set to {Cytosolic,Membrane}:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method->Custom,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          TargetSubcellularFraction->{Cytosolic,Membrane}
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,TargetSubcellularFraction, "If TargetSubcellularFraction is not specified by the user or method, and FractionationOrder is also left Automatic, TargetSubcellularFraction is set based on cell type informed by CellType option or the CellType field of the input sample. If the cell type is found to be eukaryotic (i.e. Mammalian, Yeast, Plant, Insect, or Fungal), TargetSubcellularFraction is set to {Cytosolic,Membrane,Nuclear}:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID],
        Method->Custom,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          TargetSubcellularFraction->{Cytosolic,Membrane,Nuclear}
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,TargetSubcellularFraction, "If TargetSubcellularFraction is not specified by the user or method, FractionationOrder is also left Automatic, and cell type is not informed, TargetSubcellularFraction is set to {Cytosolic} appended with Membrane and/or Nuclear if any of the fraction-specific option is set:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Lysate Sample " <>$SessionUUID],
        Method->Custom,
        CellType->Null,
        Lyse->False,
        NuclearFractionationTechnique -> Pellet,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          TargetSubcellularFraction->{Cytosolic,Nuclear}
        }
      ],
      TimeConstraint -> 1800
    ],

    (*Method*)
    Example[{Options, Method, "A Method can be specified, which contains a pre-set protocol for subcellular protein extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method -> Object[Method, Extraction, SubcellularProtein, "ExperimentExtractSubcellularProtein Test Method for Microbial Cells "<>$SessionUUID],
        LysisSolutionVolume -> 300 Microliter,
        Output -> Options
      ],
      KeyValuePattern[{
        Method -> ObjectP[Object[Method, Extraction, SubcellularProtein, "ExperimentExtractSubcellularProtein Test Method for Microbial Cells "<>$SessionUUID]],
        TargetProtein->ObjectP[Model[Molecule,Protein,"ExperimentExtractSubcellularProtein test protein "<> $SessionUUID]],
        TargetSubcellularFraction -> {Membrane,Cytosolic},
        CellType->Bacterial
        }],
      TimeConstraint -> 1200
    ],

    Example[{Options, Method, "If Method is not specified by the user, a default Method for the TargetProtein is set based on informed TargetProtein, TargetSubcellularFraction (regardless of order), CellType, Lyse:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->Model[Molecule,Protein,"ExperimentExtractSubcellularProtein test protein "<> $SessionUUID],
        TargetSubcellularFraction -> {Cytosolic,Membrane},
        LysisSolutionVolume -> 300 Microliter,
        Output -> Options
      ],
      KeyValuePattern[{
          Method -> ObjectP[Object[Method, Extraction, SubcellularProtein]]
        }],
      TimeConstraint -> 1200
    ],

    (* - Lyse Options - *)

    Example[{Options,Lyse, "If the input is living cells, they will be lysed before purification:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Purification->None,
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> True
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,Lyse, "If the input is lysate or crude protein solution, it will not be lysed (since it is already lysed or does not require lysing):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification ->{SolidPhaseExtraction},
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> False
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LysisSolutionTemperature, "LysisSolutionTemperature at which the lysis solution is equilibrated at can be specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        LysisSolutionTemperature -> 4 Celsius,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> True,
          NumberOfLysisSteps -> 1,
          LysisSolutionTemperature -> 4 Celsius,
          LysisSolutionEquilibrationTime -> GreaterP[0 Second]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LysisSolutionEquilibrationTime, "LysisSolutionEquilibrationTime during which the lysis solution is equilibrated at the LysisSolutionTemperature can be specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        LysisSolutionEquilibrationTime -> 10 Minute,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> True,
          NumberOfLysisSteps -> 1,
          LysisSolutionTemperature -> TemperatureP,
          LysisSolutionEquilibrationTime -> GreaterP[0 Second]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,SecondaryLysisSolutionTemperature, "SecondaryLysisSolutionTemperature at which the secondary lysis solution is equilibrated at can be specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        SecondaryLysisSolutionTemperature -> 4 Celsius,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> True,
          NumberOfLysisSteps -> 2,
          SecondaryLysisSolutionTemperature -> 4 Celsius,
          SecondaryLysisSolutionEquilibrationTime -> GreaterP[0 Second]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,SecondaryLysisSolutionEquilibrationTime, "SecondaryLysisSolutionEquilibrationTime during which the secondary lysis solution is equilibrated at the SecondaryLysisSolutionTemperature can be specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        SecondaryLysisSolutionEquilibrationTime -> 5 Minute,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> True,
          NumberOfLysisSteps -> 2,
          SecondaryLysisSolutionTemperature -> TemperatureP,
          SecondaryLysisSolutionEquilibrationTime -> GreaterP[0 Second]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,TertiaryLysisSolutionTemperature, "TertiaryLysisSolutionTemperature at which the tertiary lysis solution is equilibrated at can be specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TertiaryLysisSolutionTemperature -> Ambient,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> True,
          NumberOfLysisSteps -> 3,
          TertiaryLysisSolutionTemperature -> Ambient,
          TertiaryLysisSolutionEquilibrationTime -> GreaterP[0 Second]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,TertiaryLysisSolutionEquilibrationTime, "TertiaryLysisSolutionEquilibrationTime during which the tertiary lysis solution is equilibrated at the TertiaryLysisSolutionTemperature can be specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TertiaryLysisSolutionEquilibrationTime -> 5 Minute,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          Lyse -> True,
          NumberOfLysisSteps -> 3,
          TertiaryLysisSolutionTemperature -> TemperatureP,
          TertiaryLysisSolutionEquilibrationTime -> GreaterP[0 Second]
        }
      ],
      TimeConstraint -> 1800
    ],

    (* Messages tests *)

    (* - General Errors and Warnings - *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentExtractSubcellularProtein[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentExtractSubcellularProtein[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentExtractSubcellularProtein[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentExtractSubcellularProtein[Object[Container, Vessel, "id:12345678"]],
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

        ExperimentExtractSubcellularProtein[sampleID, Purification->None, Simulation -> simulationToPassIn, Output -> Options]
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

        ExperimentExtractSubcellularProtein[containerID, Purification->None, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule},
      TimeConstraint -> 1800
    ],
    Example[{Messages,"MethodTargetFractionMismatch","Return a warning if the specified method conflicts with the specified target protein:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein -> All,
        LysisSolutionVolume -> 200 Microliter,
        Method -> Object[Method, Extraction, SubcellularProtein, "ExperimentExtractSubcellularProtein Test Method for Microbial Cells " <> $SessionUUID],
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
        Warning::MethodTargetFractionMismatch
      },
      TimeConstraint -> 1200
    ],
    Example[{Messages,"NullTargetProtein","A warning is returned if the target protein is set to Null while Purification is set to be resolved automatically:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetProtein->Null,
        Output->Options
      ],
      {_Rule ..},
      Messages:>{
        Warning::NullTargetProtein
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"InvalidTargetSubcellularFraction","A  warning is thrown if TargetSubcellularFraction is specified to container Nuclear (by method or by user) and when the CellType is Bacterial:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetSubcellularFraction -> {Nuclear},
        CellType -> Bacterial,
        Purification->None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Warning::InvalidTargetSubcellularFraction
      },
      TimeConstraint -> 1800
    ],

    (* - Fractionation - *)
    Example[{Messages,"IncompleteFractionationOrder","An error is returned if specified FractionationOrder is incomplete, i.e. either does not contain all members of TargetSubcellularFraction or does not start with Cytosolic:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        TargetSubcellularFraction -> {Cytosolic,Membrane},
        FractionationOrder ->{Membrane},
        Purification->None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::IncompleteFractionationOrder
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"InvalidFractionationationTechnique","An error is returned if the order of techniques used in fractionation and wash separation is invalid. Once Filter is used, future fractions will remain on the filter, so subsequent Pellet would be invalid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        FractionationOrder ->{Cytosolic,Membrane},
        CytosolicFractionationTechnique -> Filter,
        MembraneFractionationTechnique -> Pellet,
        Purification->None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::InvalidFractionationationTechnique
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"InvalidFractionationationTechnique","An error is returned if the order of techniques used in fractionation and wash separation is invalid. The wash separation technique should be the same as the previous fractionation technique:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        FractionationOrder ->{Cytosolic,Membrane},
        CytosolicFractionationTechnique -> Pellet,
        MembraneWashSeparationTechnique -> Filter,
        Purification->None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::InvalidFractionationationTechnique
      },
      TimeConstraint -> 1800
    ],

    (* - Input Errors - *)

    Example[{Messages,"InvalidSolidMediaSample","An error is returned if the input cell samples are in solid media since only suspended or adherent cells are supported for subcellular protein extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Solid Media Cell Sample "<>$SessionUUID],
        Purification->None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::InvalidSolidMediaSample
        (*Error::InvalidInput*)
      },
      TimeConstraint -> 1800
    ],

    (* - Lysis Errors - *)
    (*Uncomment when resource packet is ready to throw error messages
    Example[{Messages,"ConflictingLysisOutputOptions","An error is returned if the last step of the extraction is lysis, but the ouput options do not match their counterparts in the lysis options:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
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
    *)
    Example[{Messages,"ConflictingLysisStepSolutionEquilibration","An error is returned if the lysis solution equilibration time or temperature options is in conflict with lysis procedure indicated by Lyse or NumberOfLysisSteps, e.g. LysisSolutionTemperature is set but Lyse is set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Lyse -> False,
        LysisSolutionTemperature -> 4 Celsius,
        Purification -> {MagneticBeadSeparation},
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::ConflictingLysisStepSolutionEquilibration
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"ConflictingLysisStepSolutionEquilibration","An error is returned if the lysis solution equilibration time or temperature options is in conflict with lysis procedure indicated by Lyse or NumberOfLysisSteps, e.g. TertiaryLysisSolutionEquilibrationTime is set but NumberOfLysisSteps is set to 2:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        NumberOfLysisSteps -> 2,
        TertiaryLysisSolutionEquilibrationTime -> 5 Minute,
        TertiaryLysisSolutionTemperature -> 4 Celsius,
        Purification -> None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::ConflictingLysisStepSolutionEquilibration
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"LysisSolutionEquilibrationTimeTemperatureMismatch","An error is returned if the lysis solution equilibration time and temperature options are mismatched, e.g. temperature is Null but equilibration time is a valid duration of time:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        LysisSolutionEquilibrationTime -> 5 Minute,
        LysisSolutionTemperature -> Null,
        Purification -> None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::LysisSolutionEquilibrationTimeTemperatureMismatch
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"LysisSolutionEquilibrationTimeTemperatureMismatch","An error is returned if the lysis solution equilibration time and temperature options are mismatched, e.g. equilibration time is Null but temperature is a non-ambient temperature:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        SecondaryLysisSolutionEquilibrationTime -> Null,
        SecondaryLysisSolutionTemperature -> 4 Celsius,
        Purification -> None,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],(*$Failed,*)
      Messages:>{
        Error::LysisSolutionEquilibrationTimeTemperatureMismatch
      },
      TimeConstraint -> 1800
    ],

    (* - Purification Errors - *)

    (*Uncomment when resource packet is ready to throw error messages
    Example[{Messages,"TargetPurificationMismatch","A warning is returned if the isolation of specified  target protein cannot be achieved by the specified Purification options, e.g. target protein is All, but purification using solid phase extraction or magnetic bead separation with separation mode of affinity is called:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        TargetProtein->All,
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionSeparationMode -> Affinity,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages:>{
        Warning::TargetPurificationMismatch
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages,"TargetPurificationMismatch","A warning is returned if the isolation of specified  target protein cannot be achieved by the specified Purification options, e.g. target protein is a Model[Molecule], but purification using solid phase extraction or magnetic bead separation with separation mode of affinity is not called:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        TargetProtein->Model[Molecule,Protein,"ExperimentExtractSubcellularProtein test protein "<> $SessionUUID],
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
    *)


    (*Shared Unit Tests*)

    (* - SHARED LYSIS TESTS - *)

    (* -- CellType Tests -- *)
    Example[{Options, CellType, "If the CellType field of the sample is specified, CellType is set to that value:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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

    (* -- CultureAdhesion Tests -- *)
    Example[{Options, CultureAdhesion, "CultureAdhesion is automatically set to the value in the CultureAdhesion field of the sample:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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

    (* -- Dissociate Tests -- *)
    Example[{Options, Dissociate, "If CultureAdhesion is Adherent and LysisAliquot is True, then Dissociate is set to True:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        LysisAliquot -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        LysisAliquotAmount -> GreaterP[0 Microliter],
        LysisAliquotContainer ->  (ObjectP[Model[Container]] | {_Integer, ObjectP[Model[Container]]}) 
      }]
    ],
    Example[{Options, LysisAliquot, "LysisAliquotAmount and LysisAliquotContainer must be Null if LysisAliquot is False:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        LysisAliquot -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        LysisAliquotContainer -> ObjectP[Model[Container]]
      }]
    ],

    (* -- LysisAliquotContainerLabel Tests -- *)
    Example[{Options, LysisAliquotContainerLabel, "If LysisAliquot is True, LysisAliquotContainerLabel will be automatically generated:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
        PreLysisSupernatantStorageCondition ->  (SampleStorageTypeP|Disposal) ,
        PreLysisSupernatantContainer -> {_Integer, ObjectP[Model[Container]]}
      }]
    ],
    Example[{Options, PreLysisPellet, "PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, and PreLysisSupernatantContainer must be Null if PreLysisPellet is False:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        PreLysisPellet -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        PreLysisPelletingCentrifuge ->  ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]] (* Model[Instrument, Centrifuge, "HiG4"] *) 
      }]
    ],

    (* -- PreLysisPelletingIntensity Tests -- *)
    Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Mammalian, PreLysisPelletCentrifugeIntensity is automatically set to 1560 RPM:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        PreLysisPellet -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        PreLysisPelletingIntensity ->  EqualP[1560 RPM] 
      }]
    ],
    (* -- PreLysisPelletingIntensity Tests -- *)
    Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Bacterial, PreLysisPelletCentrifugeIntensity is automatically set to 4030 RPM:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample " <> $SessionUUID]
        },
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
    (*Example[{Options, PreLysisPelletingIntensity, "If PreLysisPellet is set to True and CellType is Yeast, PreLysisPelletCentrifugeIntensity is automatically set to 2850 RPM:"},
	  ExperimentExtractSubcellularProtein[
		{
		  Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
		},
		PreLysisPellet -> True,
		(* No purification steps to speed up testing. *)
		Purification -> None,
		Output->Options
	  ],
	  KeyValuePattern[{
		PreLysisPelletingIntensity -> EqualP[2850 RPM]
	  }]
	],*)

    (* -- PreLysisPelletingTime Tests -- *)
    Example[{Options, PreLysisPelletingTime, "If PreLysisPellet is set to True, PreLysisPelletCentrifugeTime is automatically set to 10 minutes:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
        },
        PreLysisPellet -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        PreLysisSupernatantContainer ->  {(_Integer), ObjectP[Model[Container]]} 
      }]
    ],

    (* -- PreLysisSupernatantLabel Tests -- *)
    Example[{Options, PreLysisSupernatantLabel, "If PreLysisPellet is set to True, PreLysisSupernatantLabel will be automatically generated:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
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
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Suspended Mammalian Cell Sample with Cell Concentration Info " <> $SessionUUID]
        },
        ClarifyLysate -> True,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        ClarifiedLysateContainerLabel -> (_String)
      }]
    ],

    (* - FRACTIONATION TESTS - *)

    (* - General Fractionation Options - *)
    Example[{Options,FractionationOrder, "If FractionationOrder is not specified by the user or method, and TargetSubcellularFraction does not contain Cytosolic, FractionationOrder is set to start with Cytosolic following by TargetSubcellularFraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID],
        Method->Custom,
        TargetSubcellularFraction -> {Nuclear,Membrane},
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          FractionationOrder->{Cytosolic,Nuclear,Membrane}
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,FractionationOrder, "If FractionationOrder is not specified by the user or method, and TargetSubcellularFraction contains Cytosolic, FractionationOrder is set to contain exactly members of TargetSubcellularFraction following the order of {Cytosolic,Membrane,Nuclear}:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Adherent Mammalian Cell Sample " <>$SessionUUID],
        Method->Custom,
        TargetSubcellularFraction -> {Nuclear,Cytosolic},
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          FractionationOrder->{Cytosolic,Nuclear}
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,FractionationFilter, "If any of the fractionation technique is set to Filter by the user or method, the FractionationFilter is set to the default filter plate:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method->Custom,
        MembraneFractionationTechnique -> Filter,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          FractionationFilter -> ObjectP[Model[Container, Plate, Filter, "id:xRO9n3O0B9E5"]]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,FractionationFilter, "If any of the filter-specified options is specified by the user or method, the FractionationFilter is set to the default filter plate:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method->Custom,
        MembraneFractionationFilterTime -> 1 Minute,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          FractionationFilter -> ObjectP[Model[Container, Plate, Filter, "id:xRO9n3O0B9E5"]]
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,FractionationFilter, "If none of the fractionation technique is set to Filter and none of the filter-specified options is specified by the user or method, the FractionationFilter is set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Suspended Microbial Cell Sample "<>$SessionUUID],
        Method->Custom,
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          FractionationFilter -> Null
        }
      ],
      TimeConstraint -> 1800
    ],

    (* - Cytosolic Fractionation - *)
    Example[{Options, CytosolicFractionationTechnique, "CytosolicFractionationTechnique is set to Pellet if it is not specified by the user or method and Cytosolic is a member in FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationTechnique -> Pellet}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationTechnique, "CytosolicFractionationTechnique is set to Filter if it is not specified by the user or method, Cytosolic is a member in FractionationOrder, and there is filter-specific option set for cytosolic fractionation:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationFilterCentrifugeIntensity -> 1000 GravitationalAcceleration,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationTechnique -> Filter}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationPelletInstrument, "CytosolicFractionationPelletInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if CytosolicFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationPelletInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationPelletIntensity, "CytosolicFractionationPelletIntensity is set to 3600 GravitationalAcceleration if CytosolicFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationPelletIntensity -> 3600 GravitationalAcceleration}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationPelletTime, "CytosolicFractionationPelletTime is set based on CellType if CytosolicFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CellType -> Yeast,
        CytosolicFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationPelletTime -> 30 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationSupernatantVolume, "CytosolicFractionationSupernatantVolume is set to 90% of the starting volume of cytosolic fractionation if CytosolicFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationSupernatantVolume -> EqualP[180*Microliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationSupernatantStorageCondition, "CytosolicFractionationSupernatantStorageCondition is set to Freezer if CytosolicFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationSupernatantStorageCondition -> Freezer}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationSupernatantContainer, "CytosolicFractionationSupernatantContainer is set to ExtractedCytosolicProteinContainer if CytosolicFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Pellet,
        ExtractedCytosolicProteinContainer -> Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationSupernatantContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationSupernatantContainerLabel, "CytosolicFractionationSupernatantContainerLabel is set to ExtractedCytosolicProteinContainerLabel if CytosolicFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Pellet,
        ExtractedCytosolicProteinContainerLabel ->"my cytosolic supernatant container",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationSupernatantContainerLabel -> "my cytosolic supernatant container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationSupernatantLabel, "CytosolicFractionationSupernatantLabel is set to ExtractedCytosolicProteinLabel if CytosolicFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Pellet,
        ExtractedCytosolicProteinLabel -> "my cytosolic supernatant",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationSupernatantLabel -> "my cytosolic supernatant"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFilterTechnique, "CytosolicFractionationFilterTechnique is set to AirPressure if it is not specified by the user or method, CytosolicFractionationTechnique is set to Filter, and there is no centrifugation-specific option set for CytosolicFractionationFilter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFilterTechnique -> AirPressure}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFilterInstrument, "CytosolicFractionationFilterInstrument is set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"] if CytosolicFractionationFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFilterInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFilterInstrument, "CytosolicFractionationFilterInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if CytosolicFractionationFilterTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFilterInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFilterCentrifugeIntensity, "CytosolicFractionationFilterCentrifugeIntensity is set to 3600 GravitationalAcceleration if CytosolicFractionationTechnique is set to FilterCentrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFilterCentrifugeIntensity -> Automatic(*EqualP[3600 GravitationalAcceleration]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFilterPressure, "CytosolicFractionationFilterPressure is set to 40 PSI if CytosolicFractionationFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFilterPressure -> Automatic(*40 PSI*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFilterTime, "CytosolicFractionationFilterTime is set to 1 Minute if CytosolicFractionationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFilterTime -> 1 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFiltrateStorageCondition, "CytosolicFractionationFiltrateStorageCondition is set to Freezer if CytosolicFractionationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFiltrateStorageCondition -> Freezer}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFiltrateContainer, "CytosolicFractionationFiltrateContainer is set to ExtractedCytosolicProteinContainer if CytosolicFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        ExtractedCytosolicProteinContainer -> Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFiltrateContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFiltrateContainerLabel, "CytosolicFractionationFiltrateContainerLabel is set to ExtractedCytosolicProteinContainerLabel if CytosolicFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        ExtractedCytosolicProteinContainerLabel ->"my cytosolic filtrate container",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFiltrateContainerLabel -> "my cytosolic filtrate container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationFiltrateLabel, "CytosolicFractionationFiltrateLabel is set to ExtractedCytosolicProteinLabel if CytosolicFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        ExtractedCytosolicProteinLabel -> "my cytosolic filtrate",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationFiltrateLabel -> "my cytosolic filtrate"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationCollectionContainerTemperature, "CytosolicFractionationCollectionContainerTemperature is set to 4 Celsius if Cytosolic is a member of FractionationOrder and CytosolicFractionationCollectionContainerEquilibrationTime is not set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationCollectionContainerTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, CytosolicFractionationCollectionContainerEquilibrationTime, "CytosolicFractionationCollectionContainerEquilibrationTime is set to 10 Minutes if CytosolicFractionationCollectionContainerTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationCollectionContainerTemperature -> 10 Celsius,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{CytosolicFractionationCollectionContainerEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],
    
    (* - Membrane Wash and Solubilization - *)
    Example[{Options, NumberOfMembraneWashes, "NumberOfMembraneWashes is set to 1 if Membrane is a member in FractionationOrder and none of the essential membrane wash options (MembraneWashSolution, MembraneWashSolutionVolume, MembraneWashSeparationTechnique) is set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Membrane},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfMembraneWashes -> 1}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NumberOfMembraneWashes, "NumberOfMembraneWashes is set to Null if Membrane is not a member in FractionationOrder or any of the essential membrane wash options (MembraneWashSolution, MembraneWashSolutionVolume, MembraneWashSeparationTechnique) is set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Membrane},
        MembraneWashSolutionVolume -> Null,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfMembraneWashes -> Null}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSolution, "MembraneWashSolution is set to Model[Sample, StockSolution, \"1x PBS (Phosphate Buffer Saline), Autoclaved\"] if MembraneNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfMembraneWashes -> 2,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSolution -> ObjectP[Model[Sample, StockSolution,"id:P5ZnEjdwzZXE"]]}],(*Model[Sample, StockSolution, "1x PBS (Phosphate Buffer Saline), Autoclaved"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSolutionVolume, "MembraneWashSolutionVolume is set to lesser of experiment initial sample volume or 50% or max allowable volume in current filter or container if MembraneNumberOfWashes is set to a number greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfMembraneWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSolutionVolume -> EqualP[0.2 Milliliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSolutionTemperature, "MembraneWashSolutionTemperature is set to 4 Celsius if MembraneNumberOfWashes is greater than 0 and MembraneWashSolutionEquilibrationTime is not set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfMembraneWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSolutionTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSolutionEquilibrationTime, "MembraneWashSolutionEquilibrationTime is set to 10 Minutes if MembraneNumberOfWashes is greater than 0 and MembraneWashSolutionTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfMembraneWashes -> 3,
        MembraneWashSolutionTemperature -> 4 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSolutionEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options,MembraneWashMixType, "If a mixing time or mixing rate for the membrane wash is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        MembraneWashMixTime -> 1*Minute,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixType -> Shake}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneWashMixType, "If a mixing volume or number of mixes for the membrane wash is specified, then the sample will be mixed with a pipette (since a mixing volume and number of mixes do not pertain to shaking):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfMembraneWashMixes -> 6,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixType -> Pipette}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneWashMixType, "If mixing options are not specified for membrane wash, then the sample will not be mixed by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixType -> Null}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneWashMixTemperature, "If the membrane wash mixture will be mixed, then the mixing temperature is set to ambient temperature by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixTemperature -> Ambient}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneWashMixRate, "If the membrane wash mixture will be mixed by shaking, then the mixing rate is set to 1000 RPM (revolutions per minute) by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixRate -> EqualP[1000 RPM]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneWashMixTime, "If the membrane wash mixture will be mixed by shaking, then the mixing time is set to 1 minutes by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixTime -> EqualP[1 Minute]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NumberOfMembraneWashMixes, "If the membrane wash mixture will be mixed by pipette, then the number of mixes (number of times the membraneWash mixture is pipetted up and down) is set to 10 by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashMixType -> Pipette,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfMembraneWashMixes -> EqualP[10]}],
      TimeConstraint -> 3600
    ],

    Example[{Options,MembraneWashMixVolume, "If half of the membrane wash solution volume is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashMixType -> Pipette,
        MembraneWashSolutionVolume -> 0.2*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixVolume -> EqualP[0.1 Milliliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneWashMixVolume, "If half of the membrane wash solution volume is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashMixType -> Pipette,
        MembraneWashSolutionVolume -> 2.0*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashMixVolume -> EqualP[970 Microliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options, MembraneWashIncubationTime, "MembraneWashIncubationTime is set to Null if not specified by the user or method:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        NumberOfMembraneWashes -> 1,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        MembraneWashIncubationTime -> Null
      }]
    ],
    Example[{Options, MembraneWashIncubationTime, "MembraneWashIncubationTime is automatically set to 1 minute if MembraneWashIncubationTemperature is specified:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        NumberOfMembraneWashes -> 1,
        MembraneWashIncubationTemperature -> 4 Celsius,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        MembraneWashIncubationTime -> EqualP[1 Minute]
      }]
    ],
    Example[{Options, MembraneWashIncubationTemperature, "MembraneWashIncubationTemperature is automatically set to 4 Celsius if MembraneWashIncubationTime is a duration greater than 0 Second:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        MembraneWashIncubationTime -> 5 Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        MembraneWashIncubationTemperature -> 4 Celsius
      }]
    ],
    Example[{Options, MembraneWashSeparationTechnique, "MembraneWashSeparationTechnique is set to Pellet if it is not specified by the user or method, while NumberOfMembraneWashes is greater than 0 and the working sample is not already in a filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfMembraneWashes -> 1,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSeparationTechnique -> Pellet}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSeparationTechnique, "MembraneWashSeparationTechnique is set to Filter if it is not specified by the user or method, while NumberOfMembraneWashes is greater than 0 and the working sample is already in a filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfMembraneWashes -> 1,
        CytosolicFractionationTechnique ->Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSeparationTechnique -> Filter}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashPelletInstrument, "MembraneWashPelletInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashPelletInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashPelletIntensity, "MembraneWashPelletIntensity is set to 3600 GravitationalAcceleration if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashPelletIntensity -> 3600 GravitationalAcceleration}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashPelletTime, "MembraneWashPelletTime is set based on CellType if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CellType -> Yeast,
        MembraneWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashPelletTime -> 45 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSupernatantVolume, "MembraneWashSupernatantVolume is set to MembraneWashSolutionVolume if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSeparationTechnique -> Pellet,
        MembraneWashSolutionVolume -> 500 Microliter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSupernatantVolume -> EqualP[500*Microliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSupernatantStorageCondition, "MembraneWashSupernatantStorageCondition is set to Disposal if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSupernatantStorageCondition -> Disposal}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSupernatantContainer, "MembraneWashSupernatantContainer is set to a container selected by PreferredContainer based on the volume to be collected if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSupernatantContainer -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSupernatantContainerLabel, "MembraneWashSupernatantContainerLabel is set to \"membrane wash supernatant container #\" if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSupernatantContainerLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashSupernatantLabel, "MembraneWashSupernatantLabel is set to \"membrane wash supernatant #\" if MembraneWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashSupernatantLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFilterTechnique, "MembraneWashFilterTechnique is set to AirPressure if it is not specified by the user or method, MembraneWashSeparationTechnique is set to Filter, and there is no centrifugation-specific option set for MembraneWashFilter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFilterTechnique -> AirPressure}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFilterInstrument, "MembraneWashFilterInstrument is set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"] if MembraneWashFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFilterInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFilterInstrument, "MembraneWashFilterInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if MembraneWashFilterTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFilterInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFilterCentrifugeIntensity, "MembraneWashFilterCentrifugeIntensity is set to 3600 GravitationalAcceleration if MembraneWashSeparationTechnique is set to FilterCentrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFilterCentrifugeIntensity -> Automatic(*EqualP[3600 GravitationalAcceleration]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFilterPressure, "MembraneWashFilterPressure is set to 40 PSI if MembraneWashFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFilterPressure -> Automatic(*40 PSI*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFilterTime, "MembraneWashFilterTime is set to 1 Minute if MembraneWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFilterTime -> 1 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFiltrateStorageCondition, "MembraneWashFiltrateStorageCondition is set to Disposal if MembraneWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFiltrateStorageCondition -> Disposal}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFiltrateContainer, "MembraneWashFiltrateContainer is set by PreferredContainer based on the volume of sample to be collected as filtrate if MembraneWashSeparationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFiltrateContainer -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFiltrateContainerLabel, "MembraneWashFiltrateContainerLabel is set to \"membrane wash filtrate container #\" if MembraneWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFiltrateContainerLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashFiltrateLabel, "MembraneWashFiltrateLabel is set to \"membrane wash filtrate #\" if MembraneWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        MembraneWashSeparationTechnique -> Filter,
        ExtractedMembraneProteinLabel -> "my membrane filtrate",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashFiltrateLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashCollectionContainerTemperature, "MembraneWashCollectionContainerTemperature is set to 4 Celsius if either of MembraneWashFiltrateStorageCondition and MembraneWashSupernatantStorageCondition is not set to Null or Disposal, or if MembraneWashCollectionContainerEquilibrationTime is specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashSupernatantStorageCondition -> Freezer,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashCollectionContainerTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneWashCollectionContainerEquilibrationTime, "MembraneWashCollectionContainerEquilibrationTime is set to 10 Minutes if MembraneWashCollectionContainerTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneWashCollectionContainerTemperature -> 10 Celsius,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneWashCollectionContainerEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],

    Example[{Options, MembraneSolubilizationSolution, "MembraneSolubilizationSolution is set to Model[Sample, \"RIPA Lysis and Extraction Buffer\"] if Membrane is a member of FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Membrane},
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationSolution -> ObjectP[Model[Sample,"id:P5ZnEjdm8DYn"]]}],(*Model[Sample, "RIPA Lysis and Extraction Buffer"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneSolubilizationSolutionVolume, "MembraneSolubilizationSolutionVolume is set to lesser of 25% experiment initial sample volume or max allowable volume in current filter or container if Membrane is a member of FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Membrane},
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationSolutionVolume -> EqualP[0.05 Milliliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneSolubilizationSolutionTemperature, "MembraneSolubilizationSolutionTemperature is set to 4 Celsius if Membrane is a member of FractionationOrder and MembraneSolubilizationSolutionEquilibrationTime is not set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Membrane},
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationSolutionTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneSolubilizationSolutionEquilibrationTime, "MembraneSolubilizationSolutionEquilibrationTime is set to 10 Minutes if Membrane is a member of FractionationOrder and MembraneSolubilizationSolutionTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Membrane},
        MembraneSolubilizationSolutionTemperature -> 4 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationSolutionEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options,MembraneSolubilizationMixType, "If a mixing time or mixing rate for the membrane solubilization is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        MembraneSolubilizationMixTime -> 1*Minute,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixType -> Shake}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneSolubilizationMixType, "If a mixing volume or number of mixes for the membrane solubilization is specified, then the sample will be mixed with a pipette (since a mixing volume and number of mixes do not pertain to shaking):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfMembraneSolubilizationMixes -> 6,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixType -> Pipette}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneSolubilizationMixType, "If mixing options are not specified for membrane solubilization, then the sample will be shaken to mix by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        FractionationOrder -> {Cytosolic,Membrane},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixType -> Shake}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneSolubilizationMixTemperature, "If the membrane solubilization mixture will be mixed, then the mixing temperature is set to ambient temperature by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneSolubilizationMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixTemperature -> Ambient}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneSolubilizationMixRate, "If the membrane solubilization mixture will be mixed by shaking, then the mixing rate is set to 1000 RPM (revolutions per minute) by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneSolubilizationMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixRate -> EqualP[1000 RPM]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneSolubilizationMixTime, "If the membrane solubilization mixture will be mixed by shaking, then the mixing time is set to 1 minutes by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneSolubilizationMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixTime -> EqualP[1 Minute]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NumberOfMembraneSolubilizationMixes, "If the membrane solubilization mixture will be mixed by pipette, then the number of mixes (number of times the membraneSolubilization mixture is pipetted up and down) is set to 10 by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneSolubilizationMixType -> Pipette,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfMembraneSolubilizationMixes -> EqualP[10]}],
      TimeConstraint -> 3600
    ],

    Example[{Options,MembraneSolubilizationMixVolume, "If half of the membrane solubilization solution volume is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneSolubilizationMixType -> Pipette,
        MembraneSolubilizationSolutionVolume -> 0.2*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixVolume -> EqualP[0.1 Milliliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,MembraneSolubilizationMixVolume, "If half of the membrane solubilization solution volume is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneSolubilizationMixType -> Pipette,
        MembraneSolubilizationSolutionVolume -> 2.0*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneSolubilizationMixVolume -> EqualP[970 Microliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options, MembraneSolubilizationTime, "MembraneSolubilizationTime is set to 10 Minute if not specified by the user or method and if Membrane is a member of FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        FractionationOrder -> {Cytosolic,Membrane},
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        MembraneSolubilizationTime -> EqualP[10 Minute]
      }]
    ],
    Example[{Options, MembraneSolubilizationTemperature, "MembraneSolubilizationTemperature is automatically set to 4 Celsius if MembraneSolubilizationTime is a duration greater than 0 Second:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        MembraneSolubilizationTime -> 5 Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        MembraneSolubilizationTemperature -> 4 Celsius
      }]
    ],

    (* - Membrane Fractionation - *)
    Example[{Options, MembraneFractionationTechnique, "MembraneFractionationTechnique is set to Pellet if it is not specified by the user or method and Membrane is a member in FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Membrane},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationTechnique -> Pellet}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationTechnique, "MembraneFractionationTechnique is set to Filter if it is not specified by the user or method, Membrane is a member in FractionationOrder, and there is filter-specific option set for membrane fractionation:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationFilterCentrifugeIntensity -> 1000 GravitationalAcceleration,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationTechnique -> Filter}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationPelletInstrument, "MembraneFractionationPelletInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if MembraneFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationPelletInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationPelletIntensity, "MembraneFractionationPelletIntensity is set to 3600 GravitationalAcceleration if MembraneFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationPelletIntensity -> 3600 GravitationalAcceleration}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationPelletTime, "MembraneFractionationPelletTime is set based on CellType if MembraneFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CellType -> Mammalian,
        MembraneFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationPelletTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationSupernatantVolume, "MembraneFractionationSupernatantVolume is set to 90% of the starting volume of membrane fractionation if MembraneFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationSupernatantVolume -> EqualP[63*Microliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationSupernatantStorageCondition, "MembraneFractionationSupernatantStorageCondition is set to Freezer if MembraneFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationSupernatantStorageCondition -> Freezer}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationSupernatantContainer, "MembraneFractionationSupernatantContainer is set to ExtractedMembraneProteinContainer if MembraneFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Pellet,
        ExtractedMembraneProteinContainer -> Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationSupernatantContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationSupernatantContainerLabel, "MembraneFractionationSupernatantContainerLabel is set to ExtractedMembraneProteinContainerLabel if MembraneFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Pellet,
        ExtractedMembraneProteinContainerLabel ->"my membrane supernatant container",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationSupernatantContainerLabel -> "my membrane supernatant container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationSupernatantLabel, "MembraneFractionationSupernatantLabel is set to ExtractedMembraneProteinLabel if MembraneFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Pellet,
        ExtractedMembraneProteinLabel -> "my membrane supernatant",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationSupernatantLabel -> "my membrane supernatant"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFilterTechnique, "MembraneFractionationFilterTechnique is set to AirPressure if it is not specified by the user or method, MembraneFractionationTechnique is set to Filter, and there is no centrifugation-specific option set for MembraneFractionationFilter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFilterTechnique -> AirPressure}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFilterInstrument, "MembraneFractionationFilterInstrument is set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"] if MembraneFractionationFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFilterInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFilterInstrument, "MembraneFractionationFilterInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if MembraneFractionationFilterTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFilterInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFilterCentrifugeIntensity, "MembraneFractionationFilterCentrifugeIntensity is set to 3600 GravitationalAcceleration if MembraneFractionationTechnique is set to FilterCentrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFilterCentrifugeIntensity -> Automatic(*EqualP[3600 GravitationalAcceleration]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFilterPressure, "MembraneFractionationFilterPressure is set to 40 PSI if MembraneFractionationFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFilterPressure -> Automatic(*40 PSI*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFilterTime, "MembraneFractionationFilterTime is set to 1 Minute if MembraneFractionationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFilterTime -> 1 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFiltrateStorageCondition, "MembraneFractionationFiltrateStorageCondition is set to Freezer if MembraneFractionationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFiltrateStorageCondition -> Freezer}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFiltrateContainer, "MembraneFractionationFiltrateContainer is set to ExtractedMembraneProteinContainer if MembraneFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Filter,
        ExtractedMembraneProteinContainer -> Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFiltrateContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFiltrateContainerLabel, "MembraneFractionationFiltrateContainerLabel is set to ExtractedMembraneProteinContainerLabel if MembraneFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Filter,
        ExtractedMembraneProteinContainerLabel ->"my membrane filtrate container",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFiltrateContainerLabel -> "my membrane filtrate container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationFiltrateLabel, "MembraneFractionationFiltrateLabel is set to ExtractedMembraneProteinLabel if MembraneFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationTechnique -> Filter,
        ExtractedMembraneProteinLabel -> "my membrane filtrate",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationFiltrateLabel -> "my membrane filtrate"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationCollectionContainerTemperature, "MembraneFractionationCollectionContainerTemperature is set to 4 Celsius if Membrane is a member of FractionationOrder and MembraneFractionationCollectionContainerEquilibrationTime is not set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Membrane},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationCollectionContainerTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, MembraneFractionationCollectionContainerEquilibrationTime, "MembraneFractionationCollectionContainerEquilibrationTime is set to 10 Minutes if MembraneFractionationCollectionContainerTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MembraneFractionationCollectionContainerTemperature -> 10 Celsius,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{MembraneFractionationCollectionContainerEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],

    (* - Nuclear wash and Solubilization - *)
    Example[{Options, NumberOfNuclearWashes, "NumberOfNuclearWashes is set to 1 if Nuclear is a member in FractionationOrder and none of the essential nuclear wash options (NuclearWashSolution, NuclearWashSolutionVolume, NuclearWashSeparationTechnique) is set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Nuclear},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfNuclearWashes -> 1}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NumberOfNuclearWashes, "NumberOfNuclearWashes is set to Null if Nuclear is not a member in FractionationOrder or any of the essential nuclear wash options (NuclearWashSolution, NuclearWashSolutionVolume, NuclearWashSeparationTechnique) is set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Nuclear},
        NuclearWashSolutionVolume -> Null,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfNuclearWashes -> Null}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSolution, "NuclearWashSolution is set to Model[Sample, StockSolution, \"1x PBS (Phosphate Buffer Saline), Autoclaved\"] if NumberOfNuclearWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfNuclearWashes -> 2,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSolution -> ObjectP[Model[Sample, StockSolution,"id:P5ZnEjdwzZXE"]]}],(*Model[Sample, StockSolution, "1x PBS (Phosphate Buffer Saline), Autoclaved"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSolutionVolume, "NuclearWashSolutionVolume is set to lesser of experiment initial sample volume or 50% or max allowable volume in current filter or container if NumberOfNuclearWashes is set to a number greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfNuclearWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSolutionVolume -> EqualP[0.2 Milliliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSolutionTemperature, "NuclearWashSolutionTemperature is set to 4 Celsius if NumberOfNuclearWashes is greater than 0 and NuclearWashSolutionEquilibrationTime is not set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfNuclearWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSolutionTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSolutionEquilibrationTime, "NuclearWashSolutionEquilibrationTime is set to 10 Minutes if NumberOfNuclearWashes is greater than 0 and NuclearWashSolutionTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        NumberOfNuclearWashes -> 3,
        NuclearWashSolutionTemperature -> 4 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSolutionEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options,NuclearWashMixType, "If a mixing time or mixing rate for the nuclear wash is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        NuclearWashMixTime -> 1*Minute,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixType -> Shake}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearWashMixType, "If a mixing volume or number of mixes for the nuclear wash is specified, then the sample will be mixed with a pipette (since a mixing volume and number of mixes do not pertain to shaking):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfNuclearWashMixes -> 6,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixType -> Pipette}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearWashMixType, "If mixing options are not specified for nuclear wash, then the sample will not be mixed by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixType -> Null}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearWashMixTemperature, "If the nuclear wash mixture will be mixed, then the mixing temperature is set to ambient temperature by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixTemperature -> Ambient}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearWashMixRate, "If the nuclear wash mixture will be mixed by shaking, then the mixing rate is set to 1000 RPM (revolutions per minute) by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixRate -> EqualP[1000 RPM]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearWashMixTime, "If the nuclear wash mixture will be mixed by shaking, then the mixing time is set to 1 minutes by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixTime -> EqualP[1 Minute]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NumberOfNuclearWashMixes, "If the nuclear wash mixture will be mixed by pipette, then the number of mixes (number of times the nuclearWash mixture is pipetted up and down) is set to 10 by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashMixType -> Pipette,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfNuclearWashMixes -> EqualP[10]}],
      TimeConstraint -> 3600
    ],

    Example[{Options,NuclearWashMixVolume, "If half of the nuclear wash solution volume is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashMixType -> Pipette,
        NuclearWashSolutionVolume -> 0.2*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixVolume -> EqualP[0.1 Milliliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearWashMixVolume, "If half of the nuclear wash solution volume is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashMixType -> Pipette,
        NuclearWashSolutionVolume -> 2.0*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashMixVolume -> EqualP[970 Microliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options, NuclearWashIncubationTime, "NuclearWashIncubationTime is set to Null if not specified by the user or method:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        NumberOfNuclearWashes -> 1,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        NuclearWashIncubationTime -> Null
      }]
    ],
    Example[{Options, NuclearWashIncubationTime, "NuclearWashIncubationTime is automatically set to 1 minute if NuclearWashIncubationTemperature is specified:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        NumberOfNuclearWashes -> 1,
        NuclearWashIncubationTemperature -> 4 Celsius,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        NuclearWashIncubationTime -> EqualP[1 Minute]
      }]
    ],
    Example[{Options, NuclearWashIncubationTemperature, "NuclearWashIncubationTemperature is automatically set to 4 Celsius if NuclearWashIncubationTime is a duration greater than 0 Second:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        NuclearWashIncubationTime -> 5 Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        NuclearWashIncubationTemperature -> 4 Celsius
      }]
    ],
    Example[{Options, NuclearWashSeparationTechnique, "NuclearWashSeparationTechnique is set to Pellet if it is not specified by the user or method, while NumberOfNuclearWashes is greater than 0 and the working sample is not already in a filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfNuclearWashes -> 1,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSeparationTechnique -> Pellet}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSeparationTechnique, "NuclearWashSeparationTechnique is set to Filter if it is not specified by the user or method, while NumberOfNuclearWashes is greater than 0 and the working sample is already in a filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfNuclearWashes -> 1,
        CytosolicFractionationTechnique ->Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSeparationTechnique -> Filter}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashPelletInstrument, "NuclearWashPelletInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashPelletInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashPelletIntensity, "NuclearWashPelletIntensity is set to 3600 GravitationalAcceleration if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashPelletIntensity -> 3600 GravitationalAcceleration}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashPelletTime, "NuclearWashPelletTime is set based on CellType if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CellType -> Yeast,
        NuclearWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashPelletTime -> 45 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSupernatantVolume, "NuclearWashSupernatantVolume is set to NuclearWashSolutionVolume if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSeparationTechnique -> Pellet,
        NuclearWashSolutionVolume -> 500 Microliter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSupernatantVolume -> EqualP[500*Microliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSupernatantStorageCondition, "NuclearWashSupernatantStorageCondition is set to Disposal if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSupernatantStorageCondition -> Disposal}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSupernatantContainer, "NuclearWashSupernatantContainer is set to a container selected by PreferredContainer based on the volume to be collected if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSupernatantContainer -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSupernatantContainerLabel, "NuclearWashSupernatantContainerLabel is set to \"nuclear wash supernatant container #\" if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSupernatantContainerLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashSupernatantLabel, "NuclearWashSupernatantLabel is set to \"nuclear wash supernatant #\" if NuclearWashSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSeparationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashSupernatantLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFilterTechnique, "NuclearWashFilterTechnique is set to AirPressure if it is not specified by the user or method, NuclearWashSeparationTechnique is set to Filter, and there is no centrifugation-specific option set for NuclearWashFilter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFilterTechnique -> AirPressure}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFilterInstrument, "NuclearWashFilterInstrument is set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"] if NuclearWashFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFilterInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFilterInstrument, "NuclearWashFilterInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if NuclearWashFilterTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFilterInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFilterCentrifugeIntensity, "NuclearWashFilterCentrifugeIntensity is set to 3600 GravitationalAcceleration if NuclearWashSeparationTechnique is set to FilterCentrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFilterCentrifugeIntensity -> Automatic(*EqualP[3600 GravitationalAcceleration]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFilterPressure, "NuclearWashFilterPressure is set to 40 PSI if NuclearWashFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFilterPressure -> Automatic(*40 PSI*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFilterTime, "NuclearWashFilterTime is set to 1 Minute if NuclearWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFilterTime -> 1 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFiltrateStorageCondition, "NuclearWashFiltrateStorageCondition is set to Disposal if NuclearWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFiltrateStorageCondition -> Disposal}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFiltrateContainer, "NuclearWashFiltrateContainer is set by PreferredContainer based on the volume of sample to be collected as filtrate if NuclearWashSeparationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFiltrateContainer -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFiltrateContainerLabel, "NuclearWashFiltrateContainerLabel is set to \"nuclear wash filtrate container #\" if NuclearWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashSeparationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFiltrateContainerLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashFiltrateLabel, "NuclearWashFiltrateLabel is set to \"nuclear wash filtrate #\" if NuclearWashSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CytosolicFractionationTechnique -> Filter,
        NuclearWashSeparationTechnique -> Filter,
        ExtractedNuclearProteinLabel -> "my nuclear filtrate",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashFiltrateLabel -> Automatic}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashCollectionContainerTemperature, "NuclearWashCollectionContainerTemperature is set to 4 Celsius if either of NuclearWashFiltrateStorageCondition and NuclearWashSupernatantStorageCondition is not set to Null or Disposal, or if NuclearWashCollectionContainerEquilibrationTime is specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashSupernatantStorageCondition -> Freezer,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashCollectionContainerTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearWashCollectionContainerEquilibrationTime, "NuclearWashCollectionContainerEquilibrationTime is set to 10 Minutes if NuclearWashCollectionContainerTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearWashCollectionContainerTemperature -> 10 Celsius,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearWashCollectionContainerEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],

    Example[{Options, NuclearLysisSolution, "NuclearLysisSolution is set to Model[Sample, \"RIPA Lysis and Extraction Buffer\"] if Nuclear is a member of FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Nuclear},
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisSolution -> ObjectP[Model[Sample,"id:P5ZnEjdm8DYn"]]}],(*Model[Sample, "RIPA Lysis and Extraction Buffer"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearLysisSolutionVolume, "NuclearLysisSolutionVolume is set to lesser of 25% experiment initial sample volume or max allowable volume in current filter or container if Nuclear is a member of FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Nuclear},
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisSolutionVolume -> EqualP[0.05 Milliliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearLysisSolutionTemperature, "NuclearLysisSolutionTemperature is set to 4 Celsius if Nuclear is a member of FractionationOrder and NuclearLysisSolutionEquilibrationTime is not set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Nuclear},
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisSolutionTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearLysisSolutionEquilibrationTime, "NuclearLysisSolutionEquilibrationTime is set to 10 Minutes if Nuclear is a member of FractionationOrder and NuclearLysisSolutionTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> None,
        FractionationOrder -> {Cytosolic,Nuclear},
        NuclearLysisSolutionTemperature -> 4 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisSolutionEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options,NuclearLysisMixType, "If a mixing time or mixing rate for the nuclear lysis is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        Purification -> None,
        NuclearLysisMixTime -> 1*Minute,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixType -> Shake}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearLysisMixType, "If a mixing volume or number of mixes for the nuclear lysis is specified, then the sample will be mixed with a pipette (since a mixing volume and number of mixes do not pertain to shaking):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NumberOfNuclearLysisMixes -> 6,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixType -> Pipette}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearLysisMixType, "If mixing options are not specified for nuclear lysis, then the sample will be shaken to mix by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        (* No purification steps to speed up testing. *)
        FractionationOrder -> {Cytosolic,Nuclear},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixType -> Shake}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearLysisMixTemperature, "If the nuclear lysis mixture will be mixed, then the mixing temperature is set to ambient temperature by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearLysisMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixTemperature -> Ambient}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearLysisMixRate, "If the nuclear lysis mixture will be mixed by shaking, then the mixing rate is set to 1000 RPM (revolutions per minute) by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearLysisMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixRate -> EqualP[1000 RPM]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearLysisMixTime, "If the nuclear lysis mixture will be mixed by shaking, then the mixing time is set to 1 minutes by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearLysisMixType -> Shake,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixTime -> EqualP[1 Minute]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NumberOfNuclearLysisMixes, "If the nuclear lysis mixture will be mixed by pipette, then the number of mixes (number of times the nuclearLysis mixture is pipetted up and down) is set to 10 by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearLysisMixType -> Pipette,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfNuclearLysisMixes -> EqualP[10]}],
      TimeConstraint -> 3600
    ],

    Example[{Options,NuclearLysisMixVolume, "If half of the nuclear lysis solution volume is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearLysisMixType -> Pipette,
        NuclearLysisSolutionVolume -> 0.2*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixVolume -> EqualP[0.1 Milliliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options,NuclearLysisMixVolume, "If half of the nuclear lysis solution volume is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearLysisMixType -> Pipette,
        NuclearLysisSolutionVolume -> 2.0*Milliliter,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearLysisMixVolume -> EqualP[970 Microliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options, NuclearLysisTime, "NuclearLysisTime is set to 10 Minute if not specified by the user or method and if Nuclear is a member of FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        FractionationOrder -> {Cytosolic,Nuclear},
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        NuclearLysisTime -> EqualP[10 Minute]
      }]
    ],
    Example[{Options, NuclearLysisTemperature, "NuclearLysisTemperature is automatically set to 4 Celsius if NuclearLysisTime is a duration greater than 0 Second:"},
      ExperimentExtractSubcellularProtein[
        {
          Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID]
        },
        NuclearLysisTime -> 5 Minute,
        (* No purification steps to speed up testing. *)
        Purification -> None,
        Output->Options
      ],
      KeyValuePattern[{
        NuclearLysisTemperature -> 4 Celsius
      }]
    ],

    (* - Nuclear Fractionation - *)
    Example[{Options, NuclearFractionationTechnique, "NuclearFractionationTechnique is set to Pellet if it is not specified by the user or method and Nuclear is a member in FractionationOrder:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Nuclear},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationTechnique -> Pellet}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationTechnique, "NuclearFractionationTechnique is set to Filter if it is not specified by the user or method, Nuclear is a member in FractionationOrder, and there is filter-specific option set for nuclear fractionation:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationFilterCentrifugeIntensity -> 1000 GravitationalAcceleration,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationTechnique -> Filter}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationPelletInstrument, "NuclearFractionationPelletInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if NuclearFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationPelletInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationPelletIntensity, "NuclearFractionationPelletIntensity is set to 3600 GravitationalAcceleration if NuclearFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationPelletIntensity -> 3600 GravitationalAcceleration}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationPelletTime, "NuclearFractionationPelletTime is set based on CellType if NuclearFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        CellType -> Mammalian,
        NuclearFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationPelletTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationSupernatantVolume, "NuclearFractionationSupernatantVolume is set to 90% of the starting volume of nuclear fractionation if NuclearFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationSupernatantVolume -> EqualP[63*Microliter]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationSupernatantStorageCondition, "NuclearFractionationSupernatantStorageCondition is set to Freezer if NuclearFractionationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationSupernatantStorageCondition -> Freezer}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationSupernatantContainer, "NuclearFractionationSupernatantContainer is set to ExtractedNuclearProteinContainer if NuclearFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Pellet,
        ExtractedNuclearProteinContainer -> Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationSupernatantContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationSupernatantContainerLabel, "NuclearFractionationSupernatantContainerLabel is set to ExtractedNuclearProteinContainerLabel if NuclearFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Pellet,
        ExtractedNuclearProteinContainerLabel ->"my nuclear supernatant container",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationSupernatantContainerLabel -> "my nuclear supernatant container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationSupernatantLabel, "NuclearFractionationSupernatantLabel is set to ExtractedNuclearProteinLabel if NuclearFractionationTechnique is set to Pellet and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Pellet,
        ExtractedNuclearProteinLabel -> "my nuclear supernatant",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationSupernatantLabel -> "my nuclear supernatant"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFilterTechnique, "NuclearFractionationFilterTechnique is set to AirPressure if it is not specified by the user or method, NuclearFractionationTechnique is set to Filter, and there is no centrifugation-specific option set for NuclearFractionationFilter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFilterTechnique -> AirPressure}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFilterInstrument, "NuclearFractionationFilterInstrument is set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"] if NuclearFractionationFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFilterInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFilterInstrument, "NuclearFractionationFilterInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if NuclearFractionationFilterTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFilterInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFilterCentrifugeIntensity, "NuclearFractionationFilterCentrifugeIntensity is set to 3600 GravitationalAcceleration if NuclearFractionationTechnique is set to FilterCentrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationFilterTechnique -> Centrifuge,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFilterCentrifugeIntensity -> Automatic(*EqualP[3600 GravitationalAcceleration]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFilterPressure, "NuclearFractionationFilterPressure is set to 40 PSI if NuclearFractionationFilterTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationFilterTechnique -> AirPressure,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFilterPressure -> Automatic(*40 PSI*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFilterTime, "NuclearFractionationFilterTime is set to 1 Minute if NuclearFractionationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFilterTime -> 1 Minute}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFiltrateStorageCondition, "NuclearFractionationFiltrateStorageCondition is set to Freezer if NuclearFractionationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFiltrateStorageCondition -> Freezer}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFiltrateContainer, "NuclearFractionationFiltrateContainer is set to ExtractedNuclearProteinContainer if NuclearFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Filter,
        ExtractedNuclearProteinContainer -> Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID],
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFiltrateContainer -> ObjectP[Object[Container,Plate,"ExperimentExtractSubcellularProtein test 96-well plate 12"<>$SessionUUID]]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFiltrateContainerLabel, "NuclearFractionationFiltrateContainerLabel is set to ExtractedNuclearProteinContainerLabel if NuclearFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Filter,
        ExtractedNuclearProteinContainerLabel ->"my nuclear filtrate container",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFiltrateContainerLabel -> "my nuclear filtrate container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationFiltrateLabel, "NuclearFractionationFiltrateLabel is set to ExtractedNuclearProteinLabel if NuclearFractionationTechnique is set to Filter and Purification is None:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationTechnique -> Filter,
        ExtractedNuclearProteinLabel -> "my nuclear filtrate",
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationFiltrateLabel -> "my nuclear filtrate"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationCollectionContainerTemperature, "NuclearFractionationCollectionContainerTemperature is set to 4 Celsius if Nuclear is a member of FractionationOrder and NuclearFractionationCollectionContainerEquilibrationTime is not set to Null:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Nuclear},
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationCollectionContainerTemperature -> 4 Celsius}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NuclearFractionationCollectionContainerEquilibrationTime, "NuclearFractionationCollectionContainerEquilibrationTime is set to 10 Minutes if NuclearFractionationCollectionContainerTemperature is not set to Null or Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        NuclearFractionationCollectionContainerTemperature -> 10 Celsius,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{NuclearFractionationCollectionContainerEquilibrationTime -> 10 Minute}],
      TimeConstraint -> 1200
    ],

    (*Final pellet or filter storage condition*)
    Example[{Options, FractionationFinalPelletStorageCondition, "FractionationFinalPelletStorageCondition is set to Disposal and FractionationFinalFilterStorageCondition is set to Null if the separation technique for the last fractionation step is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Nuclear},
        NuclearFractionationTechnique -> Pellet,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{
        FractionationFinalPelletStorageCondition -> Disposal,
        FractionationFinalFilterStorageCondition -> Null}],
      TimeConstraint -> 1200
    ],
    Example[{Options, FractionationFinalPelletStorageCondition, "FractionationFinalPelletStorageCondition is set to Null and FractionationFinalFilterStorageCondition is set to Disposal if the separation technique for the last fractionation step is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        FractionationOrder -> {Cytosolic,Nuclear},
        NuclearFractionationTechnique -> Filter,
        Purification -> None,
        Output -> Options
      ],
      KeyValuePattern[{
        FractionationFinalPelletStorageCondition -> Null,
        FractionationFinalFilterStorageCondition -> Disposal}],
      TimeConstraint -> 1200
    ],
    


    (* - SHARED PURIFICATION TESTS - *)

    (* - Purification Option - *)

    Example[{Options,Purification, "If any liquid-liquid extraction options are set, then a liquid-liquid extraction will be added to the list of purification steps:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          Purification -> {LiquidLiquidExtraction}
        }
      ],
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If any precipitation options are set, then precipitation will be added to the list of purification steps:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        PrecipitationSeparationTechnique -> Filter,
        Output->Options
      ],
      KeyValuePattern[
        {
          Purification -> {Precipitation}
        }
      ],
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If any solid phase extraction options are set, then a solid phase extraction will be added to the list of purification steps:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        SolidPhaseExtractionTechnique -> Pressure,
        Output->Options
      ],
      KeyValuePattern[
        {
          Purification -> {SolidPhaseExtraction}
        }
      ],
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If any magnetic bead separation options are set, then a magnetic bead separation will be added to the list of purification steps:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MagneticBeadSeparationElutionMixTime -> 5*Minute,
        Output->Options
      ],
      KeyValuePattern[
        {
          Purification -> {MagneticBeadSeparation}
        }
      ],
      TimeConstraint -> 1200
    ],
    Example[{Options,Purification, "If options from multiple purification steps are specified, then they will be added to the purification step list in the order liquid-liquid extraction, precipitation, solid phase extraction, then magnetic bead separation:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        MagneticBeadSeparationElutionMixTime -> 5*Minute,
        SolidPhaseExtractionTechnique -> Pressure,
        PrecipitationSeparationTechnique -> Filter,
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          Purification -> {LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, MagneticBeadSeparation}
        }
      ],
      TimeConstraint -> 1200
    ],
    (*
    (* - Purification Errors - *)

    Example[{Messages, "LiquidLiquidExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 liquid-liquid extractions called for in the purification step list:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
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
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
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
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
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
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
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
    *)

    (* - SHARED PRECIPITATION TESTS - *)

    Example[{Basic, "Crude samples can be purified with precipitation:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> Precipitation,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],
    Example[{Options, PrecipitationTargetPhase, "PrecipitationTargetPhase is set to Solid if it is not specified by the user or method and Precipitation is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationTargetPhase -> Solid}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationSeparationTechnique, "PrecipitationSeparationTechnique is set to Pellet if it is not specified by the user or method and Precipitation is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationSeparationTechnique -> Pellet}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationReagent, "PrecipitationReagent is set to Model[Sample, StockSolution, \"5M Sodium Chloride\"] if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationReagent -> Automatic(*Model[Sample,StockSolution,"id:AEqRl954GJb6"]*)}],(*Model[Sample, StockSolution, "5M Sodium Chloride"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationReagent, "PrecipitationReagent is set to Model[Sample,\"TCA (10%, w/v) in acetone with 2-mercaptoethanol (0.07%)\"] if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationReagent -> ObjectP[Model[Sample, StockSolution, "id:zGj91a7v1Lob"]](*"TCA (10%, w/v) in acetone with 2-mercaptoethanol (0.07%)"*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationReagentVolume, "PrecipitationReagentVolume is set to the lesser of 50% of the sample volume and the MaxVolume of the sample container:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationReagentVolume -> Automatic(*EqualP[0.1 Milliliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationReagentTemperature, "PrecipitationReagentTemperature is set to Ambient if it is not specified by the user or method and Precipitation is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationReagentTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationReagentEquilibrationTime, "PrecipitationReagentEquilibrationTime is set to 5 Minutes if it is not specified by the user or method and Precipitation is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationReagentEquilibrationTime -> Automatic(*5 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixType, "PrecipitationMixType is set to Pipette if PrecipitationMixVolume is set by the user:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixVolume -> 100 Microliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixType, "PrecipitationMixType is set to Pipette if NumberOfPrecipitationMixes is set by the user:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        NumberOfPrecipitationMixes -> 10,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixType, "PrecipitationMixType is set to Shake if it is not set by the user and neither PrecipitationMixVolume or NumberOfPrecipitationMixes are set by the user:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixType -> Automatic(*Shake*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixInstrument, "PrecipitationMixInstrument is set to Null if PrecipitationMixType is not set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixInstrument -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixInstrument, "PrecipitationMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixInstrument -> Automatic(*Model[Instrument,Shaker,"id:pZx9jox97qNp"]*)(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixRate, "PrecipitationMixRate is set to 300 RPM if PrecipitationMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixRate -> Automatic(*300 RPM*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixRate, "PrecipitationMixRate is set to Null if PrecipitationMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixRate -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixTemperature, "PrecipitationMixTemperature is set to Ambient if PrecipitationMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixTemperature, "PrecipitationMixTemperature is set to Null if PrecipitationMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixTemperature -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixTime, "PrecipitationMixTime is set to 15 Minutes if PrecipitationMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixTime -> Automatic(*15 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixTime, "PrecipitationMixTime is set to Null if PrecipitationMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixTime -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NumberOfPrecipitationMixes, "NumberOfPrecipitationMixes is set to 10 if PrecipitationMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfPrecipitationMixes -> Automatic(*10*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, NumberOfPrecipitationMixes, "NumberOfPrecipitationMixes is set to Null if PrecipitationMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{NumberOfPrecipitationMixes ->Automatic(* Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMixVolume, "PrecipitationMixVolume is set to 50% of the sample volume if PrecipitationMixType is set to Pipette and $MaxRoboticSingleTransferVolume is more than 50% of the sample volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationMixType -> Pipette,
        PrecipitationReagentVolume -> 0.1 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMixVolume -> Automatic(*EqualP[150 Microliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationTime, "PrecipitationTime is set to 15 Minutes if it is not specified by the user or method and Precipitation is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationTime -> Automatic(*15 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationInstrument, "PrecipitationInstrument is set to Null if PrecipitationTime is set to 0 Minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTime -> 0 Minute,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationInstrument -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationInstrument, "PrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationTemperature is set to greater than 70 Celsius:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTemperature -> 80 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationInstrument -> Automatic(*Model[Instrument,Shaker,"id:eGakldJkWVnz"]*)}],(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationInstrument, "PrecipitationInstrument is set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"] if PrecipitationTemperature is less than 70 Celsius:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTemperature -> 50 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationInstrument -> Automatic(*Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]*)}],(*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationTemperature, "PrecipitationTemperature is set to Ambient if PrecipitationTime is set to greater than 0 Minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTime -> 1 Minute,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationTemperature, "PrecipitationTemperature is set to Null if PrecipitationTime is set to 0 Minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTime -> 0 Minute,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationTemperature -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationInstrument, "PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if PrecipitationSeparationTechnique is set to Filter and PrecipitationFiltrationTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationFiltrationTechnique -> Centrifuge,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationInstrument -> Automatic(*ObjectP[Model[Instrument,Centrifuge,"id:kEJ9mqaVPAXe"]]*)}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationInstrument, "PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"MPE2 Sterile\"] if PrecipitationSeparationTechnique is set to Filter and PrecipitationFiltrationTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationFiltrationTechnique -> AirPressure,
        Output -> Options
      ],
      KeyValuePattern[{
        PrecipitationFiltrationInstrument -> Automatic
      (*ObjectP[Model[Instrument,PressureManifold,"id:4pO6dMOqXNpX"]]*)
      }],(*Model[Instrument, PressureManifold, "MPE2"*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationInstrument, "PrecipitationFiltrationInstrument is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationInstrument -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationTechnique, "PrecipitationFiltrationTechnique is set to AirPressure if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationTechnique -> Automatic(*AirPressure*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationTechnique, "PrecipitationFiltrationTechnique is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationTechnique -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilter, "PrecipitationFilter is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilter -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilter, "PrecipitationFilter is set by ExperimentFilter resolver if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilter -> ObjectP[Model[Container, Plate, Filter, "Pierce Protein Precipitation Plate"]](*id:Z1lqpMlMrPw9*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPrefilterPoreSize, "PrecipitationPrefilterPoreSize is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPrefilterPoreSize -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPrefilterMembraneMaterial, "PrecipitationPrefilterMembraneMaterial is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPrefilterMembraneMaterial -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPoreSize, "PrecipitationPoreSize is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPoreSize -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPoreSize, "PrecipitationPoreSize is set by ExperimentFilter if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPoreSize -> EqualP[0.2*Micron]}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMembraneMaterial, "PrecipitationMembraneMaterial is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMembraneMaterial -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationMembraneMaterial, "PrecipitationMembraneMaterial is set by ExperimentFilter if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationMembraneMaterial -> PTFE}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilterPosition, "PrecipitationFilterPosition is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilterPosition -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilterPosition, "PrecipitationFilterPosition is set by ExperimentFilter if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilterPosition -> Automatic(*"A1"*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilterCentrifugeIntensity, "PrecipitationFilterCentrifugeIntensity is set to 3600 g if PrecipitationFiltrationTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> Centrifuge,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilterCentrifugeIntensity -> Automatic(*EqualP[3600 GravitationalAcceleration]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilterCentrifugeIntensity, "PrecipitationFilterCentrifugeIntensity is set to Null if PrecipitationFiltrationTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> AirPressure,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilterCentrifugeIntensity -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationPressure, "PrecipitationFiltrationPressure is set to 40 PSI if PrecipitationFiltrationTechnique is set to AirPressure:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> AirPressure,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationPressure -> Automatic(*40 PSI*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationPressure, "PrecipitationFiltrationPressure is set to Null if PrecipitationFiltrationTechnique is set to Centrifuge:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> Centrifuge,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationPressure -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationTime, "PrecipitationFiltrationTime is set to 10 Minutes if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationTime -> Automatic(*10 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrationTime, "PrecipitationFiltrationTime is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrationTime -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrateVolume, "PrecipitationFiltrateVolume is set to the sample volume plus PrecipitationReagentVolume if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationReagentVolume -> 0.2 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrateVolume -> Automatic(*EqualP[0.4 Milliliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFiltrateVolume, "PrecipitationFiltrateVolume is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        PrecipitationReagentVolume -> 0.1 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFiltrateVolume -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilterStorageCondition, "PrecipitationFilterStorageCondition is set to the StorageCondition of the Sample if PrecipitationTargetPhase is set to Solid and PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilterStorageCondition ->Automatic(*ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]]*)}],(*Model[StorageCondition, "Refrigerator"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationFilterStorageCondition, "PrecipitationFilterStorageCondition is set to Null if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationFilterStorageCondition -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPelletVolume, "PrecipitationPelletVolume is set to 1 MicroLiter if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPelletVolume -> Automatic(*EqualP[1 Microliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPelletVolume, "PrecipitationPelletVolume is set to Null if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPelletVolume -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPelletCentrifuge, "PrecipitationPelletCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"] if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPelletCentrifuge -> Automatic(*Model[Instrument,Centrifuge,"id:kEJ9mqaVPAXe"]*)}],(*Model[Instrument, Centrifuge, "HiG4"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPelletCentrifugeIntensity, "PrecipitationPelletCentrifugeIntensity is set to 3600 Gravitational Acceleration if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPelletCentrifugeIntensity -> Automatic(*3600 GravitationalAcceleration*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationPelletCentrifugeTime, "PrecipitationPelletCentrifugeTime is set to 10 Minutesif PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationPelletCentrifugeTime -> Automatic(*10 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationSupernatantVolume, "PrecipitationSupernatantVolume is set to 90% of the sample volume plus PrecipitationReagentVolume if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        PrecipitationReagentVolume -> 0.1 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationSupernatantVolume -> Automatic(*0.27 Milliliter*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationSupernatantVolume, "PrecipitationSupernatantVolume is set to Null if PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        PrecipitationReagentVolume -> 0.2 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationSupernatantVolume -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationNumberOfWashes, "PrecipitationNumberOfWashes is set to 0 if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationNumberOfWashes -> 0}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationNumberOfWashes, "PrecipitationNumberOfWashes is set to 3 if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationNumberOfWashes -> 3}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashSolution, "PrecipitationWashSolution is set to Model[Sample, \"id:Vrbp1jG80zno\"] if PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 3,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashSolution -> ObjectP[Model[Sample, "id:Vrbp1jG80zno"]]}],(*"Acetone, Reagent Grade"*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashSolutionVolume, "PrecipitationWashSolutionVolume is set to the volume of the sample if PrecipitationNumberOfWashes is set to a number greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashSolutionVolume, "PrecipitationWashSolutionVolume is set to Null if PrecipitationNumberOfWashes is set to 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 0,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashSolutionVolume -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashSolutionTemperature, "PrecipitationWashSolutionTemperature is set to Ambient if PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 3,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashSolutionTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashSolutionEquilibrationTime, "PrecipitationWashSolutionEquilibrationTime is set to 10 Minutes if PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfWashes -> 3,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashSolutionEquilibrationTime -> Automatic(*10 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationWashMixVolume is set:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 3,
        PrecipitationWashMixVolume -> 100 Microliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationNumberOfWashMixes is set:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 1,
        PrecipitationNumberOfWashMixes -> 10,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 3,
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Shake if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitationNumberOfWashes -> 3,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixType -> Automatic(*Shake*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixInstrument, "PrecipitationWashMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is below 70 Celsius:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        PrecipitationWashMixTemperature -> 65 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixInstrument -> Automatic(*ObjectP[Model[Instrument,Shaker,"id:pZx9jox97qNp"]]*)}],(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixInstrument, "PrecipitationWashMixInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is above 70 Celsius:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        PrecipitationWashMixTemperature -> 72 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixInstrument -> Automatic(*ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]*)}],(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixInstrument, "PrecipitationWashMixInstrument is set to Null if PrecipitationWashMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixInstrument -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixRate, "PrecipitationWashMixRate is set to 300 RPM if PrecipitationWashMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixRate -> Automatic(*300 RPM*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixTemperature, "PrecipitationWashMixTemperature is set to Ambient if PrecipitationWashMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixTime, "PrecipitationWashMixTime is set to 15 Minutes if PrecipitationWashMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixTime -> Automatic(*15 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationNumberOfWashMixes, "PrecipitationNumberOfWashMixes is set to 10 if PrecipitationWashMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationNumberOfWashMixes -> Automatic(*10*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixVolume, "PrecipitationWashMixVolume is set to the lesser of 50% of the sample volume and $MaxRoboticSingleTransferVolume if PrecipitationWashMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixVolume -> Automatic(*EqualP[0.1 Milliliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashMixVolume, "PrecipitationWashMixVolume is set to Null if PrecipitationWashMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashMixVolume -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashPrecipitationTime, "PrecipitationWashPrecipitationTime is set to 1 Minute if the PrecipitationWashSolutionTemperature is greater than the PrecipitationReagentTemperature:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashSolutionTemperature -> 40 Celsius,
        PrecipitationReagentTemperature -> Ambient,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashPrecipitationTime -> Automatic(*1 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashPrecipitationInstrument, "PrecipitationWashPrecipitationInstrument is set to Null if PrecipitationWashPrecipitationTime is set to 0 Minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashPrecipitationTime -> 0 Minute,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashPrecipitationInstrument, "PrecipitationWashPrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashPrecipitationTemperature is set to greater than 70 Celsius and PrecipitationWashPrecipitationTime is greater than 0 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashPrecipitationTemperature -> 80 Celsius,
        PrecipitationWashPrecipitationTime -> 15 Minute,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Automatic(*Model[Instrument,Shaker,"id:eGakldJkWVnz"]*)}],(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashPrecipitationInstrument, "PrecipitationWashPrecipitationInstrument is set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"] if PrecipitationWashPrecipitationTemperature is less than 70 Celsius and PrecipitationWashPrecipitationTime is greater than 0 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashPrecipitationTemperature -> 50 Celsius,
        PrecipitationWashPrecipitationTime -> 15 Minute,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Automatic(*Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]*)}],(*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashPrecipitationTemperature, "PrecipitationWashPrecipitationTemperature is set to Ambient if PrecipitationWashPrecipitationTime is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationWashPrecipitationTime -> 10 Minute,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashPrecipitationTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashCentrifugeIntensity, "PrecipitationWashCentrifugeIntensity is set to 3600 GravitationalAcceleration if PrecipitationSeparationTechnique is set to Pellet:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashCentrifugeIntensity -> Automatic(*3600 GravitationalAcceleration*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashPressure, "PrecipitationWashPressure is set to 40 PSI if PrecipitationFiltrationTechnique is set to AirPressure and PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> AirPressure,
        PrecipitationNumberOfWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashPressure -> Automatic(*40 PSI*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashSeparationTime, "PrecipitationWashSeparationTime is set to 3 Minutes if PrecipitationFiltrationTechnique is set to AirPressure and PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> AirPressure,
        PrecipitationNumberOfWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashSeparationTime -> Automatic(*3 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationWashSeparationTime, "PrecipitationWashSeparationTime is set to 20 Minutes if PrecipitationFiltrationTechnique is set to Centrifuge and PrecipitationNumberOfWashes is greater than 0:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationFiltrationTechnique -> Centrifuge,
        PrecipitationNumberOfWashes -> 1,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationWashSeparationTime -> Automatic(*20 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationDryingTemperature, "PrecipitationDryingTemperature is set to Ambient if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationDryingTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationDryingTime, "PrecipitationDryingTime is set to 20 Minutes if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationDryingTime -> Automatic(*20 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionBuffer, "PrecipitationResuspensionBuffer is set to Model[Sample, StockSolution, \"RIPA Lysis Buffer with protease inhibitor cocktail\"] if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionBuffer -> ObjectP[Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"]](*"RIPA Lysis Buffer with protease inhibitor cocktail"*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionBufferVolume, "PrecipitationResuspensionBufferVolume is set to the greater of 10 MicroLiter or 1/4th SampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionBufferVolume -> Automatic(*EqualP[0.05 Milliliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionBufferTemperature, "PrecipitationResuspensionBufferTemperature is set to Ambient if a PrecipitationResuspensionBuffer is set:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],(*Model[Sample, StockSolution, "1x TE Buffer"]*)
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionBufferTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionBufferEquilibrationTime, "PrecipitationResuspensionBufferEquilibrationTime is set to 10 Minutes if a PrecipitationResuspensionBuffer is set:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],(*Model[Sample, StockSolution, "1x TE Buffer"]*)
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionBufferEquilibrationTime -> Automatic(*10 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationResuspensionMixVolume is set:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixVolume -> 10 Microliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationNumberOfResuspensionMixes is set:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationNumberOfResuspensionMixes -> 10,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationSeparationTechnique is set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique -> Filter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixType -> Automatic(*Pipette*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Shake if a PrecipitationResuspensionBuffer is set and neither PrecipitationResuspensionMixVolume or PrecipitationNumberOfResuspensionMixes are set and PrecipitationSeparationTechnique is not set to Filter:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],(*Model[Sample, StockSolution, "1x TE Buffer"]*)
        PrecipitationSeparationTechnique -> Pellet,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixType -> Automatic(*Shake*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixInstrument, "PrecipitationResuspensionMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is below 70 Celsius:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        PrecipitationResuspensionMixTemperature -> 65 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixInstrument -> Automatic(*ObjectP[Model[Instrument,Shaker,"id:pZx9jox97qNp"]]*)}],(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixInstrument, "PrecipitationResuspensionMixInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is above 70 Celsius:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        PrecipitationResuspensionMixTemperature -> 72 Celsius,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixInstrument -> Automatic(*ObjectP[Model[Instrument,Shaker,"id:eGakldJkWVnz"]]*)}],(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixInstrument, "PrecipitationResuspensionMixInstrument is set to Null if PrecipitationResuspensionMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixInstrument -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixRate, "PrecipitationResuspensionMixRate is set to 300 RPM if PrecipitationResuspensionMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixRate -> Automatic(*300 RPM*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixTemperature, "PrecipitationResuspensionMixTemperature is set to Ambient if PrecipitationResuspensionMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixTemperature -> Automatic(*Ambient*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixTime, "PrecipitationResuspensionMixTime is set to 15 Minutes if PrecipitationResuspensionMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixTime -> Automatic(*15 Minute*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationNumberOfResuspensionMixes, "PrecipitationNumberOfResuspensionMixes is set to 10 if PrecipitationResuspensionMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Pipette,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationNumberOfResuspensionMixes -> Automatic(*10*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixVolume, "PrecipitationResuspensionMixVolume is set to the lesser of 50% of the sample volume and $MaxRoboticSingleTransferVolume if PrecipitationResuspensionMixType is set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Pipette,
        PrecipitationResuspensionBufferVolume -> 0.05 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixVolume -> Automatic(*EqualP[0.025 Milliliter]*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitationResuspensionMixVolume, "PrecipitationResuspensionMixVolume is set to Null if PrecipitationResuspensionMixType is set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationResuspensionMixType -> Shake,
        PrecipitationResuspensionBufferVolume -> 0.05 Milliliter,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitationResuspensionMixVolume -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleContainerOut, "PrecipitatedSampleContainerOut is set properly based on input:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleStorageCondition, "PrecipitatedSampleStorageCondition is set to the StorageCondition of the Sample if TargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleStorageCondition -> Automatic(*ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]]*)}],(*Model[StorageCondition, "Refrigerator"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleStorageCondition, "PrecipitatedSampleStorageCondition is set to Null if TargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleStorageCondition -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleLabel, "PrecipitatedSampleLabel is set automatically if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleLabel -> Automatic(*_String*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleLabel, "PrecipitatedSampleLabel is set to user-specified label if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitatedSampleLabel -> "Test Label for Precipitated Sample",
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleLabel -> "Test Label for Precipitated Sample"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleLabel, "PrecipitatedSampleLabel is Null if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleLabel -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleContainerLabel, "PrecipitatedSampleContainerLabel is set automatically if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleContainerLabel -> Automatic(*_String*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleContainerLabel, "PrecipitatedSampleContainerLabel is set to the user-specified label if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        PrecipitatedSampleContainerLabel -> "Test Label for Precipitated Sample Container",
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleContainerLabel -> "Test Label for Precipitated Sample Container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, PrecipitatedSampleContainerLabel, "PrecipitatedSampleContainerLabel is Null if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{PrecipitatedSampleContainerLabel -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleContainerOut, "UnprecipitatedSampleContainerOut is set properly based on input:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        UnprecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleStorageCondition, "UnprecipitatedSampleStorageCondition is set to the StorageCondition of the Sample if TargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleStorageCondition -> Automatic(*ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]]*)}],(*Model[StorageCondition, "Refrigerator"]*)
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleStorageCondition, "UnprecipitatedSampleStorageCondition is set to Null if TargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleStorageCondition -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleLabel, "UnprecipitatedSampleLabel is set automatically if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleLabel -> Automatic(*_String*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleLabel, "UnprecipitatedSampleLabel is set to user-specified label if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        UnprecipitatedSampleLabel -> "Test Label for Unprecipitated Sample",
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleLabel -> "Test Label for Unprecipitated Sample"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleLabel, "UnprecipitatedSampleLabel is Null if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleLabel -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleContainerLabel, "UnprecipitatedSampleContainerLabel is set automatically if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleContainerLabel -> Automatic(*_String*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleContainerLabel, "UnprecipitatedSampleContainerLabel is set to the user-specified label if PrecipitationTargetPhase is set to Liquid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Liquid,
        UnprecipitatedSampleContainerLabel -> "Test Label for Unprecipitated Sample Container",
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleContainerLabel -> "Test Label for Unprecipitated Sample Container"}],
      TimeConstraint -> 1200
    ],
    Example[{Options, UnprecipitatedSampleContainerLabel, "UnprecipitatedSampleContainerLabel is Null if PrecipitationTargetPhase is set to Solid:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample "<>$SessionUUID],
        Purification -> {Precipitation},
        PrecipitationTargetPhase -> Solid,
        Output -> Options
      ],
      KeyValuePattern[{UnprecipitatedSampleContainerLabel -> Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],

    (* - SHARED MBS TESTS - *)
    (* Basic Example *)
    Example[{Basic, "Crude samples can be purified with magnetic bead separation:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSelectionStrategy Tests -- *)
    Example[{Options,MagneticBeadSeparationSelectionStrategy, "MagneticBeadSeparationSelectionStrategy is set to Positive by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSelectionStrategy -> Automatic(*Positive*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationMode Tests -- *)
    Example[{Options,MagneticBeadSeparationMode, "MagneticBeadSeparationMode is set based on the target of the purification (non-protein cellular component is NormalPhase, protein is IonExchange, otherwise set to Affinity):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationMode -> Automatic(*IonExchange*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSampleVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSampleVolume, "If MagneticBeadSeparationSampleVolume is not specified and MagneticBeadSeparation is the first step of Purification, then the minimum collected sample volumes across the target fractions will be used as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        TargetSubcellularFraction -> {Cytosolic,Membrane},
        CytosolicFractionationSupernatantVolume -> 150 Microliter,
        MembraneFractionationSupernatantVolume -> 200 Microliter,
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSampleVolume -> EqualP[150 Microliter]
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationAnalyteAffinityLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationAnalyteAffinityLabel, "MagneticBeadSeparationAnalyteAffinityLabel is automatically set to the first item in Analytes of the sample if SeparationMode is set to Affinity:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        TargetProtein -> Model[Molecule,Protein,"ExperimentExtractSubcellularProtein test protein "<> $SessionUUID],
        MagneticBeadSeparationMode -> Affinity,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationAnalyteAffinityLabel -> Automatic(*ObjectP[Model[Molecule]]*)
        }
      ],
      (*
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      },
      *)
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadAffinityLabel Tests -- *)
    Example[{Options, MagneticBeadAffinityLabel, "If MagneticBeadSeparationMode is set to Affinity, MagneticBeadAffinityLabel is automatically set to the first item in the Targets field of the target molecule object:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        TargetProtein -> Model[Molecule,Protein,"ExperimentExtractSubcellularProtein test protein "<> $SessionUUID],
        MagneticBeadSeparationMode -> Affinity,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadAffinityLabel -> Automatic(*Null*)
        }
      ],
      (*
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      },
      *)
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeads Tests -- *)
    (* NOTE:This test should be customized to your specific experiment if copied in. *)
    Example[{Options, MagneticBeads, "If MagneticBeadSeparationMode is set to Affinity, MagneticBeads is automatically set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel. If bead is found, it is resolved to a general bead and a warning is thrown:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        TargetProtein -> Model[Molecule,Protein,"ExperimentExtractSubcellularProtein test protein "<> $SessionUUID],
        MagneticBeadSeparationMode -> Affinity,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeads -> Automatic(*ObjectP[Model[Sample]]*)
        }
      ],
      (*
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      },
      *)
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeads, "If MagneticBeadSeparationMode is not set to Affinity, MagneticBeads is automatically set based on the MagneticBeadSeparationMode and TargetProtein:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        TargetProtein->All,
        MagneticBeadSeparationMode -> IonExchange,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeads -> Automatic(*ObjectP[Model[Sample]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadVolume Tests -- *)
    Example[{Options, MagneticBeadVolume, "MagneticBeadVolume is automatically set to 1/10 of the MagneticBeadSeparationSampleVolume if not otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadVolume -> Automatic(*EqualP[0.02 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadCollectionStorageCondition, "MagneticBeadCollectionStorageCondition is automatically set to Disposal if not otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadCollectionStorageCondition -> Automatic(*Disposal*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagnetizationRack Tests -- *)
    Example[{Options, MagnetizationRack, "MagnetizationRack is automatically set to Model[Item, MagnetizationRack, \"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"] if not otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagnetizationRack -> Automatic(*ObjectP[Model[Item, MagnetizationRack, "Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashCollectionContainerLabel, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationCollectionContainerLabel, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingCollectionContainerLabel, "MagneticBeadSeparationLoadingCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationWashCollectionContainerLabel, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashCollectionContainerLabel, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* Prior washes need to be True to avoid error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashCollectionContainerLabel, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be True to avoid error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be True to avoid error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashCollectionContainerLabel, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be True to avoid error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashCollectionContainerLabel, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be True to avoid error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be True to avoid error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionCollectionContainerLabel Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionCollectionContainerLabel, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionContainerLabel is automatically generated unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionCollectionContainerLabel -> {Automatic}(*{(_String)}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWash Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWash, "If other magnetic bead separation prewash options are set, then MagneticBeadSeparationPreWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationPreWash, "If no magnetic bead separation prewash options are set, then MagneticBeadSeparationPreWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashSolution, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashSolution is automatically set to match the MagneticBeadSeparationElutionSolution:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashSolution -> Automatic(*ObjectP[]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashSolutionVolume, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashSolutionVolume is automatically set to the sample volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMix, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and shaking options are set, MagneticBeadSeparationPreWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixRate -> 200 RPM,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and pipetting options are set, MagneticBeadSeparationPreWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixVolume -> 0.1 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and no other mix options are set, MagneticBeadSeparationPreWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixTime, "If MagneticBeadSeparationPreWashMixType is set to Shake, MagneticBeadSeparationPreWashMixTime is automatically set to 5 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationPreWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationPreWashMixes, "If MagneticBeadSeparationPreWashMixType is set to Pipette, NumberOfMagneticBeadSeparationPreWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationPreWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 50% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to 50% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 50% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        MagneticBeadVolume -> 1.0 Milliliter,
        MagneticBeadSeparationPreWashSolutionVolume -> 1.0 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixTemperature, "If MagneticBeadSeparationPreWashMix is True, MagneticBeadSeparationPreWashMixTemperature is automatically set to Ambient unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixTipType, "If MagneticBeadSeparationPreWashMixType is set to Pipette, MagneticBeadSeparationPreWashMixTipType is automatically set to WideBore unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashMixTipMaterial, "If MagneticBeadSeparationPreWashMixType is set to Pipette, MagneticBeadSeparationPreWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- PreWashMagnetizationTime Tests -- *)
    Example[{Options, PreWashMagnetizationTime, "If MagneticBeadSeparationPreWash is True, PreWashMagnetizationTime is automatically set to 5 minutes unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          PreWashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashAspirationVolume, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashAspirationVolume is automatically set to the MagneticBeadSeparationPreWashSolutionVolume unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashCollectionContainer, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashCollectionContainer -> {Automatic}(*{{"A1",ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashCollectionStorageCondition, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationPreWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationPreWashes, "If MagneticBeadSeparationPreWash is True, NumberOfMagneticBeadSeparationPreWashes is automatically set to 1 unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationPreWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashAirDry, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashAirDry is automatically set to False unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationPreWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationPreWashAirDryTime, "If MagneticBeadSeparationPreWashAirDry is True, MagneticBeadSeparationPreWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWashAirDry -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationPreWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibration Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibration, "If any magnetic bead separation equilibration options are set (MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationSolutionVolume, MagneticBeadSeparationEquilibrationMix, etc.), MagneticBeadSeparationEquilibration is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibration -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationEquilibration, "If no magnetic bead separation equilibration options are set (MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationSolutionVolume, MagneticBeadSeparationEquilibrationMix, etc.), MagneticBeadSeparationEquilibration is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification ->{MagneticBeadSeparation},
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibration -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationSolution, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationSolutionVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationSolutionVolume -> Automatic(*EqualP[0.1 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMix Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMix, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If MagneticBeadSeparationEquilibrationMixRate or MagneticBeadSeparationEquilibrationMixTime are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixTime -> 1 Minute,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If NumberOfMagneticBeadSeparationEquilibrationMixes or MagneticBeadSeparationEquilibrationMixVolume are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationEquilibrationMixes -> 10,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixTime, "If MagneticBeadSeparationEquilibrationMixType is set to Shake, MagneticBeadSeparationEquilibrationMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixRate, "If MagneticBeadSeparationEquilibrationMixType is set to Shake, MagneticBeadSeparationEquilibrationMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationEquilibrationMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationEquilibrationMixes, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, NumberOfMagneticBeadSeparationEquilibrationMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationEquilibrationMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 2.0 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixTemperature, "If MagneticBeadSeparationEquilibrationMix is set to True, MagneticBeadSeparationEquilibrationMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixTipType, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, MagneticBeadSeparationEquilibrationMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationMixTipMaterial, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, MagneticBeadSeparationEquilibrationMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- EquilibrationMagnetizationTime Tests -- *)
    Example[{Options, EquilibrationMagnetizationTime, "If MagneticBeadSeparationEquilibration is set to True, EquilibrationMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          EquilibrationMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationAspirationVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationAspirationVolume is automatically set the same as the MagneticBeadSeparationEquilibrationSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationCollectionContainer, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationCollectionContainer -> Automatic(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationCollectionStorageCondition, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationAirDry, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibration -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationEquilibrationAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationEquilibrationAirDryTime, "If MagneticBeadSeparationEquilibrationAirDry is set to True, MagneticBeadSeparationEquilibrationAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationEquilibrationAirDry -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationEquilibrationAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMix Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMix, "MagneticBeadSeparationLoadingMix is automatically set to True unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If MagneticBeadSeparationLoadingMixRate or MagneticBeadSeparationLoadingMixTime are set, MagneticBeadSeparationLoadingMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixTime -> 1 Minute,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If NumberOfMagneticBeadSeparationLoadingMixes or MagneticBeadSeparationLoadingMixVolume are set, MagneticBeadSeparationLoadingMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationLoadingMixes -> 10,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationLoadingMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationLoadingMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixTime, "If MagneticBeadSeparationLoadingMixType is set to Shake, MagneticBeadSeparationLoadingMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixRate, "If MagneticBeadSeparationLoadingMixType is set to Shake, MagneticBeadSeparationLoadingMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationLoadingMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationLoadingMixes, "If MagneticBeadSeparationLoadingMixType is set to Pipette, NumberOfMagneticBeadSeparationLoadingMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationLoadingMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and 50% of the MagneticBeadSeparationSampleVolume is less than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 50% of the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadVolume -> 0.02 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixVolume -> Automatic(*EqualP[0.11 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and set to 50% of the MagneticBeadSeparationSampleVolume is greater than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadVolume -> 1.8 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixTemperature, "If MagneticBeadSeparationLoadingMix is set to True, MagneticBeadSeparationLoadingMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixTipType, "If MagneticBeadSeparationLoadingMixType is set to Pipette, MagneticBeadSeparationLoadingMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingMixTipMaterial, "If MagneticBeadSeparationLoadingMixType is set to Pipette, MagneticBeadSeparationLoadingMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LoadingMagnetizationTime Tests -- *)
    Example[{Options, LoadingMagnetizationTime, "LoadingMagnetizationTime is automatically set to 5 minutes unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          LoadingMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingAspirationVolume, "MagneticBeadSeparationLoadingAspirationVolume is automatically set the same as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingCollectionContainer, "MagneticBeadSeparationLoadingCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingCollectionContainer -> Automatic(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingCollectionStorageCondition, "MagneticBeadSeparationLoadingCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingAirDry, "MagneticBeadSeparationLoadingAirDry is automatically set to False unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationLoadingAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationLoadingAirDryTime, "If MagneticBeadSeparationLoadingAirDry is set to True, MagneticBeadSeparationLoadingAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationLoadingAirDry -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationLoadingAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWash Tests -- *)
    Example[{Options, MagneticBeadSeparationWash, "If any magnetic bead separation wash options are set (MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashSolutionVolume, MagneticBeadSeparationWashMix, etc.), MagneticBeadSeparationWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationWash, "If no magnetic bead separation wash options are set (MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashSolutionVolume, MagneticBeadSeparationWashMix, etc.), MagneticBeadSeparationWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationWashSolution, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationWashSolutionVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolution is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashSolutionVolume -> Automatic(*EqualP[0.1 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMix, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixType, "If MagneticBeadSeparationWashMixRate or MagneticBeadSeparationWashMixTime are set, MagneticBeadSeparationWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixTime -> 1 Minute,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationWashMixType, "If NumberOfMagneticBeadSeparationWashMixes or MagneticBeadSeparationWashMixVolume are set, MagneticBeadSeparationWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationWashMixes -> 10,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationWashMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixTime, "If MagneticBeadSeparationWashMixType is set to Shake, MagneticBeadSeparationWashMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixRate, "If MagneticBeadSeparationWashMixType is set to Shake, MagneticBeadSeparationWashMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationWashMixes, "If MagneticBeadSeparationWashMixType is set to Pipette, NumberOfMagneticBeadSeparationWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationWashSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        MagneticBeadSeparationWashSolutionVolume -> 2.0 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixTemperature, "If MagneticBeadSeparationWashMix is set to True, MagneticBeadSeparationWashMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixTipType, "If MagneticBeadSeparationWashMixType is set to Pipette, MagneticBeadSeparationWashMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationWashMixTipMaterial, "If MagneticBeadSeparationWashMixType is set to Pipette, MagneticBeadSeparationWashMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- WashMagnetizationTime Tests -- *)
    Example[{Options, WashMagnetizationTime, "If MagneticBeadSeparationWash is set to True, WashMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          WashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationWashAspirationVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashAspirationVolume is automatically set the same as the MagneticBeadSeparationWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationWashCollectionContainer, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashCollectionContainer -> {Automatic}(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationWashCollectionStorageCondition, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationWashes, "If MagneticBeadSeparationWash is True, NumberOfMagneticBeadSeparationWashes is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationWashAirDry, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationWashAirDryTime, "If MagneticBeadSeparationWashAirDry is set to True, MagneticBeadSeparationWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationWashAirDry -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWash, "If any magnetic bead separation secondary wash options are set (MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashSolutionVolume, MagneticBeadSeparationSecondaryWashMix, etc.), MagneticBeadSeparationSecondaryWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Shake,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWash, "If no magnetic bead separation secondary wash options are set (MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashSolutionVolume, MagneticBeadSeparationSecondaryWashMix, etc.), MagneticBeadSeparationSecondaryWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashSolution, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMix, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If MagneticBeadSeparationSecondaryWashMixRate or MagneticBeadSeparationSecondaryWashMixTime are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixTime -> 1 Minute,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If NumberOfMagneticBeadSeparationSecondaryWashMixes or MagneticBeadSeparationSecondaryWashMixVolume are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationSecondaryWashMixes -> 10,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If no magnetic bead separation secondary wash mix options are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMix -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixTime, "If MagneticBeadSeparationSecondaryWashMixType is set to Shake, MagneticBeadSeparationSecondaryWashMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Shake,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixRate, "If MagneticBeadSeparationSecondaryWashMixType is set to Shake, MagneticBeadSeparationSecondaryWashMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Shake,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationSecondaryWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationSecondaryWashMixes, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSecondaryWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationSecondaryWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 2.0 Milliliter,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixTemperature, "If MagneticBeadSeparationSecondaryWashMix is set to True, MagneticBeadSeparationSecondaryWashMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMix -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixTipType, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, MagneticBeadSeparationSecondaryWashMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashMixTipMaterial, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, MagneticBeadSeparationSecondaryWashMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashMixType -> Pipette,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- SecondaryWashMagnetizationTime Tests -- *)
    Example[{Options, SecondaryWashMagnetizationTime, "If MagneticBeadSeparationSecondaryWash is set to True, SecondaryWashMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          SecondaryWashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashAspirationVolume, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSecondaryWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashCollectionContainer, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashCollectionContainer -> {Automatic}(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashCollectionStorageCondition, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationSecondaryWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationSecondaryWashes, "If MagneticBeadSeparationSecondaryWash is True, NumberOfMagneticBeadSeparationSecondaryWashes is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationSecondaryWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashAirDry, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSecondaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSecondaryWashAirDryTime, "If MagneticBeadSeparationSecondaryWashAirDry is set to True, MagneticBeadSeparationSecondaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSecondaryWashAirDry -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSecondaryWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWash, "If any magnetic bead separation tertiary wash options are set (MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashSolutionVolume, MagneticBeadSeparationTertiaryWashMix, etc.), MagneticBeadSeparationTertiaryWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWash, "If no magnetic bead separation tertiary wash options are set (MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashSolutionVolume, MagneticBeadSeparationTertiaryWashMix, etc.), MagneticBeadSeparationTertiaryWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashSolution, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationTertiaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationTertiaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMix, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If MagneticBeadSeparationTertiaryWashMixRate or MagneticBeadSeparationTertiaryWashMixTime are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If NumberOfMagneticBeadSeparationTertiaryWashMixes or MagneticBeadSeparationTertiaryWashMixVolume are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationTertiaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If no magnetic bead separation tertiary wash mix options are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixTime, "If MagneticBeadSeparationTertiaryWashMixType is set to Shake, MagneticBeadSeparationTertiaryWashMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixRate, "If MagneticBeadSeparationTertiaryWashMixType is set to Shake, MagneticBeadSeparationTertiaryWashMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationTertiaryWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationTertiaryWashMixes, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationTertiaryWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationTertiaryWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 2.0 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixTemperature, "If MagneticBeadSeparationTertiaryWashMix is set to True, MagneticBeadSeparationTertiaryWashMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixTipType, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, MagneticBeadSeparationTertiaryWashMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashMixTipMaterial, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, MagneticBeadSeparationTertiaryWashMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- TertiaryWashMagnetizationTime Tests -- *)
    Example[{Options, TertiaryWashMagnetizationTime, "If MagneticBeadSeparationTertiaryWash is set to True, TertiaryWashMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          TertiaryWashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashAspirationVolume, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationTertiaryWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashCollectionContainer, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashCollectionContainer -> {Automatic}(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashCollectionStorageCondition, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationTertiaryWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationTertiaryWashes, "If MagneticBeadSeparationTertiaryWash is True, NumberOfMagneticBeadSeparationTertiaryWashes is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationTertiaryWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashAirDry, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationTertiaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationTertiaryWashAirDryTime, "If MagneticBeadSeparationTertiaryWashAirDry is set to True, MagneticBeadSeparationTertiaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationTertiaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationTertiaryWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWash, "If any magnetic bead separation quaternary wash options are set (MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashSolutionVolume, MagneticBeadSeparationQuaternaryWashMix, etc.), MagneticBeadSeparationQuaternaryWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWash, "If no magnetic bead separation quaternary wash options are set (MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashSolutionVolume, MagneticBeadSeparationQuaternaryWashMix, etc.), MagneticBeadSeparationQuaternaryWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashSolution, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuaternaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationQuaternaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMix, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If MagneticBeadSeparationQuaternaryWashMixRate or MagneticBeadSeparationQuaternaryWashMixTime are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If NumberOfMagneticBeadSeparationQuaternaryWashMixes or MagneticBeadSeparationQuaternaryWashMixVolume are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If no magnetic bead separation quaternary wash mix options are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixTime, "If MagneticBeadSeparationQuaternaryWashMixType is set to Shake, MagneticBeadSeparationQuaternaryWashMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixRate, "If MagneticBeadSeparationQuaternaryWashMixType is set to Shake, MagneticBeadSeparationQuaternaryWashMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationQuaternaryWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationQuaternaryWashMixes, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuaternaryWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationQuaternaryWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 2.0 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixTemperature, "If MagneticBeadSeparationQuaternaryWashMix is set to True, MagneticBeadSeparationQuaternaryWashMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixTipType, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, MagneticBeadSeparationQuaternaryWashMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashMixTipMaterial, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, MagneticBeadSeparationQuaternaryWashMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- QuaternaryWashMagnetizationTime Tests -- *)
    Example[{Options, QuaternaryWashMagnetizationTime, "If MagneticBeadSeparationQuaternaryWash is set to True, QuaternaryWashMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          QuaternaryWashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashAspirationVolume, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuaternaryWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashCollectionContainer, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashCollectionContainer -> {Automatic}(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationQuaternaryWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationQuaternaryWashes, "If MagneticBeadSeparationQuaternaryWash is True, NumberOfMagneticBeadSeparationQuaternaryWashes is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationQuaternaryWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashAirDry, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuaternaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationQuaternaryWashAirDryTime, "If MagneticBeadSeparationQuaternaryWashAirDry is set to True, MagneticBeadSeparationQuaternaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuaternaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuaternaryWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWash, "If any magnetic bead separation quinary wash options are set (MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashSolutionVolume, MagneticBeadSeparationQuinaryWashMix, etc.), MagneticBeadSeparationQuinaryWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWash, "If no magnetic bead separation quinary wash options are set (MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashSolutionVolume, MagneticBeadSeparationQuinaryWashMix, etc.), MagneticBeadSeparationQuinaryWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashSolution, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuinaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationQuinaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMix, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If MagneticBeadSeparationQuinaryWashMixRate or MagneticBeadSeparationQuinaryWashMixTime are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If NumberOfMagneticBeadSeparationQuinaryWashMixes or MagneticBeadSeparationQuinaryWashMixVolume are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationQuinaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If no magnetic bead separation quinary wash mix options are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixTime, "If MagneticBeadSeparationQuinaryWashMixType is set to Shake, MagneticBeadSeparationQuinaryWashMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixRate, "If MagneticBeadSeparationQuinaryWashMixType is set to Shake, MagneticBeadSeparationQuinaryWashMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationQuinaryWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationQuinaryWashMixes, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuinaryWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationQuinaryWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 2.0 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixTemperature, "If MagneticBeadSeparationQuinaryWashMix is set to True, MagneticBeadSeparationQuinaryWashMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixTipType, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, MagneticBeadSeparationQuinaryWashMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashMixTipMaterial, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, MagneticBeadSeparationQuinaryWashMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- QuinaryWashMagnetizationTime Tests -- *)
    Example[{Options, QuinaryWashMagnetizationTime, "If MagneticBeadSeparationQuinaryWash is set to True, QuinaryWashMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          QuinaryWashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashAspirationVolume, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuinaryWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashCollectionContainer, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashCollectionContainer -> {Automatic}(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashCollectionStorageCondition, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationQuinaryWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationQuinaryWashes, "If MagneticBeadSeparationQuinaryWash is True, NumberOfMagneticBeadSeparationQuinaryWashes is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationQuinaryWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashAirDry, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationQuinaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationQuinaryWashAirDryTime, "If MagneticBeadSeparationQuinaryWashAirDry is set to True, MagneticBeadSeparationQuinaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationQuinaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationQuinaryWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWash, "If any magnetic bead separation senary wash options are set (MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashSolutionVolume, MagneticBeadSeparationSenaryWashMix, etc.), MagneticBeadSeparationSenaryWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSenaryWash, "If no magnetic bead separation senary wash options are set (MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashSolutionVolume, MagneticBeadSeparationSenaryWashMix, etc.), MagneticBeadSeparationSenaryWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashSolution, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationPreWash -> True,
        MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSenaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        MagneticBeadSeparationPreWash -> False,
        MagneticBeadSeparationSenaryWash -> True,
        (* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMix, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If MagneticBeadSeparationSenaryWashMixRate or MagneticBeadSeparationSenaryWashMixTime are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If NumberOfMagneticBeadSeparationSenaryWashMixes or MagneticBeadSeparationSenaryWashMixVolume are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationSenaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If no magnetic bead separation senary wash mix options are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixTime, "If MagneticBeadSeparationSenaryWashMixType is set to Shake, MagneticBeadSeparationSenaryWashMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixRate, "If MagneticBeadSeparationSenaryWashMixType is set to Shake, MagneticBeadSeparationSenaryWashMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationSenaryWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationSenaryWashMixes, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSenaryWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationSenaryWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 2.0 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixTemperature, "If MagneticBeadSeparationSenaryWashMix is set to True, MagneticBeadSeparationSenaryWashMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixTipType, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, MagneticBeadSeparationSenaryWashMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashMixTipMaterial, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, MagneticBeadSeparationSenaryWashMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- SenaryWashMagnetizationTime Tests -- *)
    Example[{Options, SenaryWashMagnetizationTime, "If MagneticBeadSeparationSenaryWash is set to True, SenaryWashMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          SenaryWashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashAspirationVolume, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSenaryWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashCollectionContainer, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashCollectionContainer -> {Automatic}(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashCollectionStorageCondition, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationSenaryWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationSenaryWashes, "If MagneticBeadSeparationSenaryWash is True, NumberOfMagneticBeadSeparationSenaryWashes is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationSenaryWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashAirDry, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSenaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSenaryWashAirDryTime, "If MagneticBeadSeparationSenaryWashAirDry is set to True, MagneticBeadSeparationSenaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSenaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSenaryWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWash Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWash, "If any magnetic bead separation septenary wash options are set (MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashSolutionVolume, MagneticBeadSeparationSeptenaryWashMix, etc.), MagneticBeadSeparationSeptenaryWash is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWash -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWash, "If no magnetic bead separation septenary wash options are set (MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashSolutionVolume, MagneticBeadSeparationSeptenaryWashMix, etc.), MagneticBeadSeparationSeptenaryWash is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWash -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashSolution, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashSolutionVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMix Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMix, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If MagneticBeadSeparationSeptenaryWashMixRate or MagneticBeadSeparationSeptenaryWashMixTime are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixTime -> 1 Minute,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If NumberOfMagneticBeadSeparationSeptenaryWashMixes or MagneticBeadSeparationSeptenaryWashMixVolume are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 10,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If no magnetic bead separation septenary wash mix options are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixTime, "If MagneticBeadSeparationSeptenaryWashMixType is set to Shake, MagneticBeadSeparationSeptenaryWashMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixRate, "If MagneticBeadSeparationSeptenaryWashMixType is set to Shake, MagneticBeadSeparationSeptenaryWashMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Shake,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationSeptenaryWashMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationSeptenaryWashMixes, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSeptenaryWashMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationSeptenaryWashMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
        MagneticBeadSeparationSeptenaryWashSolutionVolume -> 2.0 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixTemperature, "If MagneticBeadSeparationSeptenaryWashMix is set to True, MagneticBeadSeparationSeptenaryWashMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMix -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixTipType, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, MagneticBeadSeparationSeptenaryWashMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashMixTipMaterial, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, MagneticBeadSeparationSeptenaryWashMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- SeptenaryWashMagnetizationTime Tests -- *)
    Example[{Options, SeptenaryWashMagnetizationTime, "If MagneticBeadSeparationSeptenaryWash is set to True, SeptenaryWashMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          SeptenaryWashMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashAspirationVolume, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSeptenaryWashSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashCollectionContainer, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashCollectionContainer -> {Automatic}(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationSeptenaryWashes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationSeptenaryWashes, "If MagneticBeadSeparationSeptenaryWash is True, NumberOfMagneticBeadSeparationSeptenaryWashes is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationSeptenaryWashes -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashAirDry Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashAirDry, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashAirDry is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWash -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashAirDry -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationSeptenaryWashAirDryTime Tests -- *)
    Example[{Options, MagneticBeadSeparationSeptenaryWashAirDryTime, "If MagneticBeadSeparationSeptenaryWashAirDry is set to True, MagneticBeadSeparationSeptenaryWashAirDryTime is automatically set to 1 Minute:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationSeptenaryWashAirDry -> True,
        (* Prior washes need to be set to True to avoid an error. *)
        MagneticBeadSeparationWash -> True,
        MagneticBeadSeparationSecondaryWash -> True,
        MagneticBeadSeparationTertiaryWash -> True,
        MagneticBeadSeparationQuaternaryWash -> True,
        MagneticBeadSeparationQuinaryWash -> True,
        MagneticBeadSeparationSenaryWash -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationSeptenaryWashAirDryTime -> Automatic(*EqualP[1 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElution Tests -- *)
    Example[{Options, MagneticBeadSeparationElution, "If any magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.), MagneticBeadSeparationElution is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElution -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationElution, "If MagneticBeadSeparationSelectionStrategy is Positive, MagneticBeadSeparationElution is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationSelectionStrategy -> Positive,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElution -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationElution, "If no magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.) and MagneticBeadSeparationSelectionStrategy is Negative, MagneticBeadSeparationElution is automatically set to False:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> MagneticBeadSeparation,
        MagneticBeadSeparationSelectionStrategy -> Negative,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElution -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionSolution Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionSolution, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionSolution -> Automatic(*ObjectP[Model[Sample,"Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionSolutionVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionSolutionVolume, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionSolutionVolume is automatically set 1/10 of the MagneticBeadSeparationSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionSolutionVolume -> Automatic(*EqualP[0.02 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMix Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMix, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionMix is automatically set to True:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMix -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMixType Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixType, "If MagneticBeadSeparationElutionMixRate or MagneticBeadSeparationElutionMixTime are set, MagneticBeadSeparationElutionMixType is automatically set to Shake:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixTime -> 1 Minute,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationElutionMixType, "If NumberOfMagneticBeadSeparationElutionMixes or MagneticBeadSeparationElutionMixVolume are set, MagneticBeadSeparationElutionMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationElutionMixes -> 10,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationElutionMixType, "If no magnetic bead separation elution mix options are set, MagneticBeadSeparationElutionMixType is automatically set to Pipette:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMixTime Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixTime, "If MagneticBeadSeparationElutionMixType is set to Shake, MagneticBeadSeparationElutionMixTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMixRate Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixRate, "If MagneticBeadSeparationElutionMixType is set to Shake, MagneticBeadSeparationElutionMixRate is automatically set to 300 RPM:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixRate -> Automatic(*EqualP[300 RPM]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationElutionMixes Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationElutionMixes, "If MagneticBeadSeparationElutionMixType is set to Pipette, NumberOfMagneticBeadSeparationElutionMixes is automatically set to 10:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationElutionMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMixVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationElutionSolutionVolume and MagneticBeadVolume is less than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 1/2 of theMagneticBeadSeparationElutionSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        MagneticBeadVolume -> 0.2 Milliliter,
        MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 1/2 of the MagneticBeadSeparationElutionSolutionVolume is greater than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 970 microliters:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        MagneticBeadSeparationElutionSolutionVolume -> 2.0 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixVolume -> Automatic(*EqualP[0.970 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMixTemperature Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixTemperature, "If MagneticBeadSeparationElutionMix is set to True, MagneticBeadSeparationElutionMixTemperature is automatically set to Ambient:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMix -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMixTipType Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixTipType, "If MagneticBeadSeparationElutionMixType is set to Pipette, MagneticBeadSeparationElutionMixTipType is automatically set to WideBore:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixTipType -> Automatic(*WideBore*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionMixTipMaterial Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionMixTipMaterial, "If MagneticBeadSeparationElutionMixType is set to Pipette, MagneticBeadSeparationElutionMixTipMaterial is automatically set to Polypropylene:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElutionMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionMixTipMaterial -> Automatic(*Polypropylene*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- ElutionMagnetizationTime Tests -- *)
    Example[{Options, ElutionMagnetizationTime, "If MagneticBeadSeparationElution is set to True, ElutionMagnetizationTime is automatically set to 5 minutes:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          ElutionMagnetizationTime -> Automatic(*EqualP[5 Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionAspirationVolume Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionAspirationVolume, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionAspirationVolume is automatically set the same as the MagneticBeadSeparationElutionSolutionVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionAspirationVolume -> Automatic(*EqualP[0.2 Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionCollectionContainer Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionCollectionContainer, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionCollectionContainer -> Automatic(*{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- MagneticBeadSeparationElutionCollectionStorageCondition Tests -- *)
    Example[{Options, MagneticBeadSeparationElutionCollectionStorageCondition, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          MagneticBeadSeparationElutionCollectionStorageCondition -> Automatic(*Refrigerator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationElutions Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationElutions, "If MagneticBeadSeparationElution is True, NumberOfMagneticBeadSeparationElutions is automatically set to 1:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        MagneticBeadSeparationElution -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationElutions -> Automatic(*1*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationElutions Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationElutions, "If NumberOfMagneticBeadSeparationElutions is set to larger than 1, samples collected from multiple rounds are pooled to one container (and to one well if applicable):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfMagneticBeadSeparationElutions -> 3,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationElutions -> 3,
          MagneticBeadSeparationElutionCollectionContainer -> Automatic(*{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfMagneticBeadSeparationElutions for multiple samples Tests -- *)
    Example[{Options, NumberOfMagneticBeadSeparationElutions, "If NumberOfMagneticBeadSeparationElutions is set to larger than 1 for multiple samples, samples collected from multiple rounds are pooled to one container (and to one well if applicable):"},
      ExperimentExtractSubcellularProtein[
        {Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
          Object[Sample,"ExperimentExtractSubcellularProtein Lysate Sample " <> $SessionUUID]},
        NumberOfMagneticBeadSeparationElutions -> 3,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfMagneticBeadSeparationElutions -> 3,
          MagneticBeadSeparationElutionCollectionContainer -> Automatic(*{{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}..}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (*Shared SPE tests *)
    Example[{Basic, "Crude samples can be purified with solid phase extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> SolidPhaseExtraction,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],
    Example[{Basic, "All solid phase extraction options are set to Null if they are not specified by the user or method and SolidPhaseExtraction is not specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output -> Options
      ],
      KeyValuePattern[{
        SolidPhaseExtractionStrategy->Automatic(*Null*),
        SolidPhaseExtractionSeparationMode->Automatic(*Null*),
        SolidPhaseExtractionSorbent->Automatic(*Null*),
        SolidPhaseExtractionCartridge->Automatic(*Null*),
        SolidPhaseExtractionTechnique->Automatic(*Null*),
        SolidPhaseExtractionInstrument->Automatic(*Null*),
        SolidPhaseExtractionCartridgeStorageCondition->Automatic(*Null*),
        SolidPhaseExtractionLoadingSampleVolume->Automatic(*Null*),
        (*)SolidPhaseExtractionLoadingTemperature->Automatic(*Null*),
        SolidPhaseExtractionLoadingTemperatureEquilibrationTime->Automatic(*Null*),*)
        SolidPhaseExtractionLoadingCentrifugeIntensity->Automatic(*Null*),
        SolidPhaseExtractionLoadingPressure->Automatic(*Null*),
        SolidPhaseExtractionLoadingTime->Automatic(*Null*),
        CollectSolidPhaseExtractionLoadingFlowthrough->Automatic(*Null*),
        SolidPhaseExtractionLoadingFlowthroughContainerOut->Automatic(*Null*),
        SolidPhaseExtractionWashSolution->Null,
        SolidPhaseExtractionWashSolutionVolume->Automatic(*Null*),
        (*)SolidPhaseExtractionWashTemperature->Automatic(*Null*),
        SolidPhaseExtractionWashTemperatureEquilibrationTime->Automatic(*Null*),*)
        SolidPhaseExtractionWashCentrifugeIntensity->Automatic(*Null*),
        SolidPhaseExtractionWashPressure->Automatic(*Null*),
        SolidPhaseExtractionWashTime->Automatic(*Null*),
        CollectSolidPhaseExtractionWashFlowthrough->Automatic(*Null*),
        SolidPhaseExtractionWashFlowthroughContainerOut->Automatic(*Null*),
        SecondarySolidPhaseExtractionWashSolution->Null,
        SecondarySolidPhaseExtractionWashSolutionVolume->Automatic(*Null*),
        (*)SecondarySolidPhaseExtractionWashTemperature->Automatic(*Null*),
        SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime->Automatic(*Null*),*)
        SecondarySolidPhaseExtractionWashCentrifugeIntensity->Automatic(*Null*),
        SecondarySolidPhaseExtractionWashPressure->Automatic(*Null*),
        SecondarySolidPhaseExtractionWashTime->Automatic(*Null*),
        CollectSecondarySolidPhaseExtractionWashFlowthrough->Automatic(*Null*),
        SecondarySolidPhaseExtractionWashFlowthroughContainerOut->Automatic(*Null*),
        TertiarySolidPhaseExtractionWashSolution->Null,
        TertiarySolidPhaseExtractionWashSolutionVolume->Automatic(*Null*),
        (*)TertiarySolidPhaseExtractionWashTemperature->Automatic(*Null*),
        TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime->Automatic(*Null*),*)
        TertiarySolidPhaseExtractionWashCentrifugeIntensity->Automatic(*Null*),
        TertiarySolidPhaseExtractionWashPressure->Automatic(*Null*),
        TertiarySolidPhaseExtractionWashTime->Automatic(*Null*),
        CollectTertiarySolidPhaseExtractionWashFlowthrough->Automatic(*Null*),
        TertiarySolidPhaseExtractionWashFlowthroughContainerOut->Automatic(*Null*),
        SolidPhaseExtractionElutionSolution->Null,
        SolidPhaseExtractionElutionSolutionVolume->Automatic(*Null*),
        (*)SolidPhaseExtractionElutionSolutionTemperature->Automatic(*Null*),
        SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime->Automatic(*Null*),*)
        SolidPhaseExtractionElutionCentrifugeIntensity->Automatic(*Null*),
        SolidPhaseExtractionElutionPressure->Automatic(*Null*),
        SolidPhaseExtractionElutionTime->Automatic(*Null*)}],
      TimeConstraint -> 1200
    ],
    Example[{Options, SolidPhaseExtractionStrategy, "SolidPhaseExtractionStrategy is set to Positive if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionStrategy -> Positive}],
      TimeConstraint -> 1200
    ],

    (*------The tests below are for pre-pre-resolved SPE options. The behabior is for ExtractSubcellularProtein only------*)
    Example[{Options, SolidPhaseExtractionSorbent, "SolidPhaseExtractionSorbent is set to match the sorbent in the SolidPhaseExtractionCartridge if SolidPhaseExtractionCartridge is specified and SolidPhaseExtractionSorbent is not specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionCartridge->Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"],(*Model[Container, Plate, Filter, "Zeba 7K 96-well Desalt Spin Plate"]*)
        Output -> Options
      ],
      KeyValuePattern[{
        SolidPhaseExtractionSorbent -> Null,
        SolidPhaseExtractionSeparationMode-> Automatic(*SizeExclusion*)
      }],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionSorbent, "SolidPhaseExtractionSorbent is set to Affinity, and SolidPhaseExtractionSeparationMode and SolidPhaseExtractionCartridge are set correspondingly, if it is not specified by the user, method, or SolidPhaseExtractionCartridge, the TargetProtein is an identity model, the resolved cell type matches MicrobialCellTypeP, and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        CellType -> Bacterial,
        TargetProtein -> Model[Molecule, Protein,"ExperimentExtractSubcellularProtein test protein " <> $SessionUUID],
        Method -> Custom,(*To avoid resolving to the test method*)
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{
        SolidPhaseExtractionSorbent -> Affinity,
        SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"]],(*Model[Container, Plate, Filter, "HisPur Ni-NTA Spin Plates"]*)
        SolidPhaseExtractionSeparationMode -> Affinity
      }],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionSorbent, "SolidPhaseExtractionSorbent is set to Affinity, and SolidPhaseExtractionSeparationMode and SolidPhaseExtractionCartridge are set correspondingly, if it is not specified by the user, method, or SolidPhaseExtractionCartridge, the TargetProtein is an identity model, the resolved cell type matches MicrobialCellTypeP, and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        CellType -> Mammalian,
        TargetProtein -> Model[Molecule, Protein,"ExperimentExtractSubcellularProtein test protein " <> $SessionUUID],
        Method -> Custom,(*To avoid resolving to the test method*)
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{
        SolidPhaseExtractionSorbent -> ProteinG,
        SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:eGakldaE6bY1"]],(*Model[Container, Plate, Filter, "Pierce ProteinG Spin Plate for IgG Screening"]*)
        SolidPhaseExtractionSeparationMode -> Affinity
      }],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionSorbent, "SolidPhaseExtractionSorbent is set to Null,SolidPhaseExtractionSeparationMode is set to SizeExclusion, and SolidPhaseExtractionCartridge is set to the default cartridge for extraction of protein, if they are not specified by the user, method, or SolidPhaseExtractionCartridge, the TargetProtein is All, and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample,"ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{
        SolidPhaseExtractionSorbent -> Automatic(*Null*),
        SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"]],(*"Zeba 7K 96-well Desalt Spin Plate"*)
        SolidPhaseExtractionSeparationMode -> SizeExclusion
      }],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionSeparationMode, "SolidPhaseExtractionSeparationMode is set to Automatic if SolidPhaseExtractionSorbent is specified to a FunctionalGroupP that we do not have reccomended filter and SolidPhaseExtractionSeparationMode is not specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionSorbent->Silica,
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionSeparationMode -> Automatic}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionCartridge, "SolidPhaseExtractionCartridge is set to match the mode of the SolidPhaseExtractionSeparationMode if SolidPhaseExtractionSeparationMode is specified and SolidPhaseExtractionCartridge is not specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        TargetProtein->Model[Molecule, Protein,"ExperimentExtractSubcellularProtein test protein " <> $SessionUUID],
        Method->Custom,
        SolidPhaseExtractionCartridge->Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"],(*Model[Container, Plate, Filter, "HisPur Ni-NTA Spin Plates"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionSeparationMode->Automatic(*Affinity*),SolidPhaseExtractionSorbent->Affinity}],
      TimeConstraint -> 3600
    ],

    (*------END OF The tests for pre-pre-resolved SPE options.------*)


    Example[{Options, SolidPhaseExtractionTechnique, "SolidPhaseExtractionTechnique is set to Pressure if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionTechnique -> Automatic(*Pressure*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionInstrument, "SolidPhaseExtractionInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if SolidPhaseExtractionTechnique is set to Centrifuge and SolidPhaseExtractionInstrument is not specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionTechnique->Centrifuge,
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionInstrument -> Automatic(*ObjectP[{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}]*)
      }],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionInstrument, "SolidPhaseExtractionInstrument is set to Model[Instrument, PressureManifold, \"MPE2\"] if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionInstrument -> Automatic(*ObjectP[{Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]}]*)
      }],(*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionCartridgeStorageCondition, "SolidPhaseExtractionCartridgeStorageCondition is set to Disposal if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionCartridgeStorageCondition -> Automatic(*Disposal*)}](*in SPE the default for ExtractionCartridgeStorageCondition is Disposal, then disposal (or any input that is not in SampleStorageTypeP) resolves to Null*),
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionLoadingSampleVolume, "SolidPhaseExtractionLoadingSampleVolume is not specified and SolidPhaseExtraction is the first step of Purification, then the minimum collected sample volumes across the target fractions is used as SolidPhaseExtractionLoadingSampleVolume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        TargetSubcellularFraction -> {Membrane,Nuclear},
        CytosolicFractionationTechnique -> Filter, (*so that all the following steps occur on filter*)
        MembraneSolubilizationSolutionVolume -> 180 Microliter,
        NuclearLysisSolutionVolume -> 175 Microliter,
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionLoadingSampleVolume -> EqualP[175 Microliter]}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionLoadingCentrifugeIntensity, "SolidPhaseExtractionLoadingCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not set to a Model[Instrument, Centrfuge]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionLoadingCentrifugeIntensity -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionLoadingCentrifugeIntensity, "SolidPhaseExtractionLoadingCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionTechnique -> Centrifuge,
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionLoadingCentrifugeIntensity -> Automatic(*5000 RPM*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionLoadingPressure, "SolidPhaseExtractionLoadingPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not set to a Model[Instrument, PressureManifold]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionLoadingPressure -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionLoadingPressure, "SolidPhaseExtractionLoadingPressure is set to the MaxRoboticAirPressure if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        SolidPhaseExtractionTechnique -> Pressure,
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionLoadingPressure -> Automatic(*$MaxRoboticAirPressure*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionLoadingTime, "SolidPhaseExtractionLoadingTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionLoadingTime -> Automatic(*1 Minute*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, CollectSolidPhaseExtractionLoadingFlowthrough, "CollectSolidPhaseExtractionLoadingFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{CollectSolidPhaseExtractionLoadingFlowthrough -> Automatic(*False*)}](*if the option is not set by the user, SPE sets it to False unless there is a collection container specified*),
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionLoadingFlowthroughContainerOut, "SolidPhaseExtractionLoadingFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionLoadingFlowthroughContainerOut -> Automatic(*Null*)}](*default in SPE is to not collect the flowthrough, so don't need a container*),
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashSolution, "SolidPhaseExtractionWashSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashSolution -> ObjectP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]](*Filtered PBS, Sterile*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashSolutionVolume, "SolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashSolutionVolume -> Automatic(*1. Milliliter*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashCentrifugeIntensity, "SolidPhaseExtractionWashCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashCentrifugeIntensity -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashCentrifugeIntensity, "SolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashCentrifugeIntensity -> Automatic(*5000 RPM*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashPressure, "SolidPhaseExtractionWashPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashPressure -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashPressure, "SolidPhaseExtractionWashPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashPressure -> Automatic(*$MaxRoboticAirPressure*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashTime, "SolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashTime -> Automatic(*1 Minute*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, CollectSolidPhaseExtractionWashFlowthrough, "CollectSolidPhaseExtractionWashFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{CollectSolidPhaseExtractionWashFlowthrough -> Automatic(*False*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionWashFlowthroughContainerOut, "SolidPhaseExtractionWashFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionWashFlowthroughContainerOut -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashSolution, "SecondarySolidPhaseExtractionWashSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:4pO6dMWvnA0X"](*Filtered PBS, Sterile*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashSolutionVolume, "SecondarySolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashSolutionVolume -> Automatic(*1. Milliliter*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashCentrifugeIntensity, "SecondarySolidPhaseExtractionWashCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashCentrifugeIntensity, "SecondarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Automatic(*5000 RPM*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashPressure, "SecondarySolidPhaseExtractionWashPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashPressure -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashPressure, "SecondarySolidPhaseExtractionWashPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashPressure -> Automatic(*$MaxRoboticAirPressure*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashTime, "SecondarySolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashTime -> Automatic(*1 Minute*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, CollectSecondarySolidPhaseExtractionWashFlowthrough, "CollectSecondarySolidPhaseExtractionWashFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{CollectSecondarySolidPhaseExtractionWashFlowthrough -> Automatic(*False*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SecondarySolidPhaseExtractionWashFlowthroughContainerOut, "SecondarySolidPhaseExtractionWashFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashSolution, "TertiarySolidPhaseExtractionWashSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:4pO6dMWvnA0X"](*Filtered PBS, Sterile*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashSolutionVolume, "TertiarySolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashSolutionVolume -> Automatic(*1. Milliliter*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashCentrifugeIntensity, "TertiarySolidPhaseExtractionWashCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashCentrifugeIntensity, "TertiarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Automatic(*5000 RPM*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashPressure, "TertiarySolidPhaseExtractionWashPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Automatic(*Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]*),(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashPressure -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashPressure, "TertiarySolidPhaseExtractionWashPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashPressure -> Automatic(*$MaxRoboticAirPressure*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashTime, "TertiarySolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashTime -> Automatic(*1 Minute*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, CollectTertiarySolidPhaseExtractionWashFlowthrough, "CollectTertiarySolidPhaseExtractionWashFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{CollectTertiarySolidPhaseExtractionWashFlowthrough -> Automatic(*False*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, TertiarySolidPhaseExtractionWashFlowthroughContainerOut, "TertiarySolidPhaseExtractionWashFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionElutionSolution, "SolidPhaseExtractionElutionSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionElutionSolution -> ObjectP[Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"]](*"id:eGakldadjlEe" 50 mM Glycine pH 2.8, sterile filtered*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionElutionSolutionVolume, "SolidPhaseExtractionElutionSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionElutionSolutionVolume -> Automatic(*1. Milliliter*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionElutionCentrifugeIntensity, "SolidPhaseExtractionElutionCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionElutionCentrifugeIntensity -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionElutionCentrifugeIntensity, "SolidPhaseExtractionElutionCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
      Lookup[ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ], SolidPhaseExtractionElutionCentrifugeIntensity],
      Automatic(*5000 RPM*),
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionElutionPressure, "SolidPhaseExtractionElutionPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionElutionPressure -> Automatic(*Null*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionElutionPressure, "SolidPhaseExtractionElutionPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionElutionPressure -> Automatic(*$MaxRoboticAirPressure*)}],
      TimeConstraint -> 3600
    ],
    Example[{Options, SolidPhaseExtractionElutionTime, "SolidPhaseExtractionElutionTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> {SolidPhaseExtraction},
        Output -> Options
      ],
      KeyValuePattern[{SolidPhaseExtractionElutionTime -> Automatic(*1 Minute*)}],
      TimeConstraint -> 3600
    ],

    (*Shared LLE tests*)

    (* Basic Example *)
    Example[{Basic, "Crude samples can be purified with liquid-liquid extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 1800
    ],

    (* - Liquid-liquid Extraction Options - *)

    (* -- LiquidLiquidExtractionTechnique Tests -- *)
    Example[{Options,LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are set for removing one layer from another, then pipetting is used for the liquid-liquid extraction technique:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        (*If all specified options are False, it is not considered specified when resolving Purification steps, and will resolved to {LLE,Precipitation} which will unnecessarily slow down the tests*)
        Purification->LiquidLiquidExtraction,
        IncludeLiquidBoundary -> {False,False,False},
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTechnique -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are not set for removing one layer from another, then a phase separator is used for the liquid-liquid extraction technique:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTechnique -> Automatic(*PhaseSeparator*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionDevice Tests --*)
    Example[{Options,LiquidLiquidExtractionDevice, "If pipetting is used as the technique for physically separating the different phases during the liquid-liquid extraction, then a phase separator is not specified (since a phase separator is not being used):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionDevice -> Automatic(*Null*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionDevice, "If a phase separator is used as the technique for physically separating the different phases during the liquid-liquid extraction, then a standard phase separator (Model[Container,Plate,PhaseSeparator,\"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits\"]) is selected for use:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionDevice -> Automatic(*ObjectP[Model[Container,Plate,PhaseSeparator,"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionSelectionStrategy -- *)
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If there is only one round of liquid-liquid extraction, then a selection strategy is not specified (since a selection strategy is only required for multiple extraction rounds):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 1,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSelectionStrategy -> Automatic(*Null*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round matches the target phase, then the selection strategy is positive:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSelectionStrategy -> Automatic(*Positive*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round does not match the target phase, then the selection strategy is negative:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        AqueousSolvent -> None,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSelectionStrategy -> Automatic(*Negative*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If nothing else is specified, then the selection strategy is set to positive:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSelectionStrategy -> Automatic(*Positive*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- IncludeLiquidBoundary -- *)
    Example[{Options,IncludeLiquidBoundary, "If pipetting is used for physical separating the two phases after extraction, then the liquid boundary between the phases is not removed during each liquid-liquid extraction round:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          IncludeLiquidBoundary ->Automatic(* {False, False, False}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTargetPhase -- *)
    Example[{Options,LiquidLiquidExtractionTargetPhase, "The target phase is selected based on the phase that the protein is more likely to be found in based on the PredictDestinationPhase[...] function:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTargetPhase -> Automatic(*Aqueous*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTargetLayer -- *)
    Example[{Options,LiquidLiquidExtractionTargetLayer, "The target layer for each extraction round is calculated from the density of the sample's aqueous and organic layers (if present in the sample), the density of the AqueousSolvent and OrganicSolvent options (if specified), and the target phase:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTargetLayer -> Automatic(*{Top, Top, Top}*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is less dense than the organic phase, then the target layer will be the top layer:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTargetLayer -> Automatic(*{Top}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is denser than the organic phase, then the target layer will be the bottom layer:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTargetLayer -> Automatic(*{Bottom}*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is less dense than the organic phase, then the target layer will be the bottom layer:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Organic,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTargetLayer -> Automatic(*{Bottom}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is denser than the organic phase, then the target layer will be the top layer:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        LiquidLiquidExtractionTargetPhase -> Organic,
        NumberOfLiquidLiquidExtractions -> 1,
        AqueousSolvent -> Model[Sample,"Milli-Q water"],
        OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTargetLayer -> Automatic(*{Top}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionContainer -- *)
    Example[{Options,LiquidLiquidExtractionContainer, "If the sample is in a non-centrifuge-compatible container and centrifuging is specified, then the extraction container will be set to a centrifuge-compatible, 96-well 2mL deep well plate:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
        LiquidLiquidExtractionCentrifuge -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionContainer -> Automatic(*{1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (*Example[{Options,LiquidLiquidExtractionContainer, "If heating or cooling is specified, then the extraction container will be set to a 96-well 2mL deep well plate (since the robotic heater/cooler units are only compatible with Plate format containers):"},
	  ExperimentExtractSubcellularProtein[
		Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
		LiquidLiquidExtractionTemperature -> 90.0*Celsius,
		Output->Options
	  ],
	  KeyValuePattern[
		{
		  LiquidLiquidExtractionContainer -> {1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
		}
	  ],
	  TimeConstraint -> 1800
	],
	Example[{Options,LiquidLiquidExtractionContainer, "If the sample will not be centrifuged and the extraction will take place at ambient temperature, then the extraction container will be selected using the PreferredContainer function (to find a robotic-compatible container that will hold the sample):"},
	  ExperimentExtractSubcellularProtein[
		Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
		LiquidLiquidExtractionCentrifuge -> False,
		LiquidLiquidExtractionTemperature -> Ambient,
		Output->Options
	  ],
	  KeyValuePattern[
		{
		  LiquidLiquidExtractionContainer -> ObjectP[Model[Container]]
		}
	  ],
	  TimeConstraint -> 1800
	],*)

    (* -- LiquidLiquidExtractionContainerWell -- *)
    Example[{Options,LiquidLiquidExtractionContainerWell, "If a liquid-liquid extraction container is specified, then the first available well in the container will be used by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample in 50mL Tube "<>$SessionUUID],
        LiquidLiquidExtractionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionContainerWell -> Automatic(*"A1"*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- AqueousSolvent -- *)
    Example[{Options,AqueousSolvent, "If aqueous solvent is required for a separation, then water (Milli-Q water) will be used as the aqueous solvent:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        Output->Options
      ],
      KeyValuePattern[
        {
          AqueousSolvent -> Automatic(*ObjectP[Model[Sample, "Milli-Q water"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- AqueousSolventVolume -- *)
    Example[{Options,AqueousSolventVolume, "If an aqueous solvent ratio is set, then the aqueous solvent volume is calculated from the ratio and the sample volume (SampleVolume/AqueousSolventRatio):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolventRatio -> 5,
        Output->Options
      ],
      KeyValuePattern[
        {
          AqueousSolventVolume -> Automatic(*EqualP[0.04*Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,AqueousSolventVolume, "If an aqueous solvent is set, then the aqueous solvent volume will be 20% of the sample volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        Output->Options
      ],
      KeyValuePattern[
        {
          AqueousSolventVolume -> Automatic(*EqualP[0.04*Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- AqueousSolventRatio -- *)
    Example[{Options,AqueousSolventRatio, "If an aqueous solvent volume is set, then the aqueous solvent ratio is calculated from the set aqueous solvent volume and the sample volume (SampleVolume/AqueousSolventVolume):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolventVolume -> 0.04*Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          AqueousSolventRatio -> Automatic(*EqualP[5.0]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,AqueousSolventRatio, "If an aqueous solvent is set, then the aqueous solvent ratio is set to 5:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolvent -> Model[Sample, "Milli-Q water"],
        Output->Options
      ],
      KeyValuePattern[
        {
          AqueousSolventRatio -> Automatic(*EqualP[5.0]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- OrganicSolvent -- *)
    Example[{Options,OrganicSolvent, "If an organic solvent volume or organic solvent ratio are specified, then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventRatio -> 5,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolvent -> Automatic(*ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent,"If an organic solvent volume or organic solvent ratio are specified, then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventVolume -> 0.2*Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolvent -> Automatic(*ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent, "If the target phase is set to Organic and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolvent -> Automatic(*ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent, "If the target phase is set to Aqueous and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolvent -> Automatic(*ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a pipette will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> Pipette), then ethyl acetate (Model[Sample, \"Ethyl acetate, HPLC Grade\"]) will be used as the organic solvent:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolvent -> Automatic(*ObjectP[Model[Sample, "Ethyl acetate, HPLC Grade"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a phase separator will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> PhaseSeparator), Model[Sample, \"Chloroform\"] will be used if Model[Sample, \"Ethyl acetate, HPLC Grade\"] is not dense enough to be denser than the aqueous layer, since the organic layer needs to be below the aqueous layer to pass through the hydrophobic frit:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> PhaseSeparator,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolvent -> Automatic(*ObjectP[Model[Sample, "Chloroform"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- OrganicSolventVolume -- *)
    Example[{Options,OrganicSolventVolume, "If an organic solvent ratio is set, then the organic solvent volume is calculated from the ratio and the sample volume (SampleVolume/OrganicSolventRatio):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventRatio -> 5,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolventVolume -> Automatic(*EqualP[0.04*Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolventVolume, "If an organic solvent is set, then the organic solvent volume will be 20% of the sample volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolventVolume -> Automatic(*EqualP[0.04*Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- OrganicSolventRatio -- *)
    Example[{Options,OrganicSolventRatio, "If an organic solvent volume is set, then the organic solvent ratio is calculated from the set organic solvent volume and the sample volume (SampleVolume/OrganicSolventVolume):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventVolume -> 0.04*Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolventRatio -> Automatic(*EqualP[5.0]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,OrganicSolventRatio, "If an organic solvent is set, then the organic solvent ratio is set to 5:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
        Output->Options
      ],
      KeyValuePattern[
        {
          OrganicSolventRatio -> Automatic(*EqualP[5.0]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionSolventAdditions -- *)
    Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an organic or unknown phase, then an aqueous solvent is added to that sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSolventAdditions -> Automatic(*{{ObjectP[], ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}}*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an aqueous phase, then organic solvent is added to that sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSolventAdditions -> Automatic(*{{ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]..}}*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of an extraction is biphasic, then no solvent is added for the first extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Biphasic Previously Extracted Protein Sample "<>$SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSolventAdditions -> Automatic(*{None, ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- Demulsifier -- *)
    Example[{Options,Demulsifier, "If the demulsifier additions are specified, then the specified demulsifier will be used:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        DemulsifierAdditions -> {Model[Sample, StockSolution, "5M Sodium Chloride"], None, None},
        Output->Options
      ],
      KeyValuePattern[
        {
          Demulsifier -> Automatic(*ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,Demulsifier, "If a demulsifier amount is specified, then a 5M sodium chloride solution will be used as the demulsifier:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        DemulsifierAmount -> 0.1*Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          Demulsifier -> Automatic(*ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,Demulsifier, "If no demulsifier options are specified, then a demulsifier is not used:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification->{LiquidLiquidExtraction},
        Output->Options
      ],
      KeyValuePattern[
        {
          Demulsifier -> Automatic(*None*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- DemulsifierAmount -- *)
    Example[{Options,DemulsifierAmount, "If demulsifier and/or demulsifier additions are specified, then the demulsifier amount is set to 10% of the sample volume:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        Output->Options
      ],
      KeyValuePattern[
        {
          DemulsifierAmount -> Automatic(*EqualP[0.02*Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- DemulsifierAdditions -- *)
    Example[{Options,DemulsifierAdditions, "If a demulsifier is not specified, then the demulsifier additions are set to None for each round:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          DemulsifierAdditions -> Automatic(*{None, None, None}*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,DemulsifierAdditions, "If there will only be one round of liquid-liquid extraction and a demulsifier is specified, then the demulsifier will be added for that one extraction round:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 1,
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        Output->Options
      ],
      KeyValuePattern[
        {
          DemulsifierAdditions -> Automatic(*{ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]}*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the organic phase will be used in subsequent extraction rounds, then the demulsifier will be added for each extraction round (since the demulsifier will likely be removed with the aqueous phase each round):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        LiquidLiquidExtractionTargetPhase -> Organic,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output->Options
      ],
      KeyValuePattern[
        {
          DemulsifierAdditions -> Automatic(*{ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]..}*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the aqueous phase will be used in subsequent extraction rounds, then the demulsifier will only be added for the first extraction round (since the demulsifier is usually a salt solution which stays in the aqueous phase):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        NumberOfLiquidLiquidExtractions -> 3,
        Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
        LiquidLiquidExtractionTargetPhase -> Aqueous,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        Output->Options
      ],
      KeyValuePattern[
        {
          DemulsifierAdditions -> Automatic(*{ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]], None, None}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTemperature -- *)
    Example[{Options,LiquidLiquidExtractionTemperature, "If not specified by the user nor the method, the liquid-liquid extraction is carried out at ambient temperature by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTemperature -> Automatic(*Ambient*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfLiquidLiquidExtractions -- *)
    Example[{Options,NumberOfLiquidLiquidExtractions, "If not specified by the user nor the method, the number of liquid-liquid extraction is 3 by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfLiquidLiquidExtractions -> Automatic(*3*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixType -- *)
    Example[{Options,LiquidLiquidExtractionMixType, "If a mixing time or mixing rate for the liquid-liquid extraction is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixTime -> 1*Minute,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionMixType -> Automatic(*Shake*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionMixType, "If mixing options are not specified, then the sample will be mixed via pipetting:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionMixType -> Automatic(*Pipette*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixTime -- *)
    Example[{Options,LiquidLiquidExtractionMixTime, "If the liquid-liquid extraction mixture will be mixed by shaking, then the mixing time is set to 30 seconds by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionMixTime -> Automatic(*EqualP[30*Second]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixRate -- *)
    Example[{Options,LiquidLiquidExtractionMixRate, "If the liquid-liquid extraction mixture will be mixed by shaking, then the mixing rate is set to 300 RPM (revolutions per minute) by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Shake,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionMixRate -> Automatic(*EqualP[300 Revolution/Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- NumberOfLiquidLiquidExtractionMixes -- *)
    Example[{Options,NumberOfLiquidLiquidExtractionMixes, "If the liquid-liquid extraction mixture will be mixed by pipette, then the number of mixes (number of times the liquid-liquid extraction mixture is pipetted up and down) is set to 10 by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          NumberOfLiquidLiquidExtractionMixes -> Automatic(*10*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionMixVolume -- *)
    Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        OrganicSolventVolume -> 0.2*Milliliter,
        NumberOfLiquidLiquidExtractions -> 1,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionMixVolume -> Automatic(*EqualP[0.1*Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],
  
    Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionMixType -> Pipette,
        LiquidLiquidExtractionSelectionStrategy -> Negative,
        OrganicSolventVolume -> 0.5*Milliliter,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionMixVolume -> Automatic(*EqualP[0.970*Milliliter]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionSettlingTime -- *)
    Example[{Options,LiquidLiquidExtractionSettlingTime, "If not specified by the user nor the method, the liquid-liquid extraction solution is allowed to settle for 1 minute by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionSettlingTime -> Automatic(*EqualP[1*Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionCentrifuge -- *)
    Example[{Options,LiquidLiquidExtractionCentrifuge, "If any other centrifuging options are specified, then the liquid-liquid extraction solution will be centrifuged in order to separate the solvent phases:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionCentrifugeTime -> 1*Minute,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionCentrifuge -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionCentrifuge, "If the separated solvent phases will be pysically separated with a pipette and the sample is in a centrifuge-compatible container, then the liquid-liquid extraction solution will be centrifuged in order to separate the solvent phases:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionCentrifuge -> Automatic(*True*)
        }
      ],
      TimeConstraint -> 1800
    ],
    Example[{Options,LiquidLiquidExtractionCentrifuge, "If not specified by the user nor the method, the liquid-liquid extraction solution will not be centrifuged:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionCentrifuge -> Automatic(*False*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionCentrifugeInstrument -- *)
    Example[{Options,LiquidLiquidExtractionCentrifugeInstrument, "If the liquid-liquid extraction solution will be centrifuged, then the integrated centrifuge model on the chosen robotic instrument will be automatically used:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        RoboticInstrument -> Object[Instrument, LiquidHandler, "id:WNa4ZjRr56bE"],
        LiquidLiquidExtractionCentrifuge -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionCentrifugeInstrument -> Automatic(*ObjectP[Model[Instrument,Centrifuge,"HiG4"]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionCentrifugeIntensity -- *)
    Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is less than the MaxCentrifugationForce of the plate model (or the MaxCentrifugationForce of the plate model does not exist), the liquid-liquid extraction solution will be centrifuged at the MaxIntensity of the centrifuge model:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument,Centrifuge,"HiG4"],
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionCentrifugeIntensity -> Automatic(*EqualP[3600 GravitationalAcceleration]*)
        }
      ],
      TimeConstraint -> 1800
    ],
 
    (*Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is greater than the MaxCentrifugationForce of the plate model, the liquid-liquid extraction solution will be centrifuged at the MaxCentrifugationForce of the plate model:"},
	  ExperimentExtractSubcellularProtein[
		Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
		LiquidLiquidExtractionContainer -> Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"],
		LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument,Centrifuge,"HiG4"],
		Output->Options
	  ],
	  KeyValuePattern[
		{
		  LiquidLiquidExtractionCentrifugeIntensity -> EqualP[2851.5 RPM]
		}
	  ],
	  TimeConstraint -> 1800
	],*)

    (* -- LiquidLiquidExtractionCentrifugeTime -- *)
    Example[{Options,LiquidLiquidExtractionCentrifugeTime, "If the liquid-liquid extraction solution will be centrifuged, the liquid-liquid extraction solution will be centrifuged for 2 minutes by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionCentrifuge -> True,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionCentrifugeTime -> Automatic(*EqualP[2*Minute]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidBoundaryVolume -- *)
 
    Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the top layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the sample container at the location of the layer boundary for each extraction round:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        NumberOfLiquidLiquidExtractions -> 1,
        LiquidLiquidExtractionTransferLayer -> {Top},
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidBoundaryVolume -> Automatic(*{EqualP[0.02*Milliliter]}*)
        }
      ],
      TimeConstraint -> 1800
    ],
  
    Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the bottom layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the bottom of the sample container for each extraction round:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        NumberOfLiquidLiquidExtractions -> 1,
        LiquidLiquidExtractionTransferLayer -> {Bottom},
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidBoundaryVolume -> Automatic(*{EqualP[0.02*Milliliter]}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- LiquidLiquidExtractionTransferLayer -- *)
    Example[{Options,LiquidLiquidExtractionTransferLayer, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette, the top layer will be removed from the bottom layer during each extraction round by default:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionTechnique -> Pipette,
        Output->Options
      ],
      KeyValuePattern[
        {
          LiquidLiquidExtractionTransferLayer -> Automatic(*{Top, Top, Top}*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerStorageCondition -- *)
    Example[{Options,ImpurityLayerStorageCondition, "ImpurityLayerStorageCondition is set to Disposal for each extraction round if not otherwise specified:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          ImpurityLayerStorageCondition -> Automatic(*Disposal*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerContainerOut -- *)
    
    (*Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is set to Aqueous and LiquidLiquidExtractionTechnique is set to PhaseSeparator, ImpurityLayerContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
	  ExperimentExtractSubcellularProtein[
		Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
		LiquidLiquidExtractionTargetPhase -> Aqueous,
		LiquidLiquidExtractionTechnique -> PhaseSeparator,
		Output->Options
	  ],
	  KeyValuePattern[
		{
		  ImpurityLayerContainerOut -> ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]
		}
	  ],
	  TimeConstraint -> 1800
	],*)
    Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is not set to Aqueous or LiquidLiquidExtractionTechnique is not set to PhaseSeparator, ImpurityLayerContainerOut is automatically determined by the PreferredContainer function:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          ImpurityLayerContainerOut -> Automatic(*ObjectP[Model[Container]]*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerContainerOutWell -- *)
    Example[{Options,ImpurityLayerContainerOutWell, "ImpurityLayerContainerOutWell is automatically set to the first empty well of the ImpurityLayerContainerOut:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        ImpurityLayerContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        Output->Options
      ],
      KeyValuePattern[
        {
          ImpurityLayerContainerOutWell -> Automatic(*"A1"*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerLabel -- *)
    Example[{Options,ImpurityLayerLabel, "ImpurityLayerLabel is automatically generated for the impurity layer sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          ImpurityLayerLabel -> Automatic(*(_String)*)
        }
      ],
      TimeConstraint -> 1800
    ],

    (* -- ImpurityLayerContainerLabel -- *)
    Example[{Options,ImpurityLayerContainerLabel, "ImpurityLayerContainerLabel is automatically generated for the impurity layer sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Purification -> LiquidLiquidExtraction,
        Output->Options
      ],
      KeyValuePattern[
        {
          ImpurityLayerContainerLabel -> Automatic(*(_String)*)
        }
      ],
      TimeConstraint -> 1800
    ]

    (* - Liquid-Liquid Extraction Errors - *)
    (*Uncomment when resource packet is ready to throw messages
    Example[{Messages, "LiquidLiquidExtractionOptionMismatch", "An error is returned if any liquid-liquid extraction options are set, but LiquidLiquidExtraction is not specified in Purification:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
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
    ],
    Example[{Messages, "LiquidLiquidExtractionSelectionStrategyOptionsMismatched", "A warning is returned if a selection strategy (LiquidLiquidExtractionSelectionStrategy) is specified, but there is only one liquid-liquid extraction round specified (NumberOfLiquidLiquidExtractions) since a selection strategy is only required for multiple rounds of liquid-liquid extraction:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        LiquidLiquidExtractionSelectionStrategy -> Positive,
        NumberOfLiquidLiquidExtractions -> 1,
        Output->Result
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],
      Messages:>{
        Warning::LiquidLiquidExtractionSelectionStrategyNotNeeded
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages, "AqueousSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified aqueous solvent options (AqueousSolvent, AqueousSolventVolume, AqueousSolventRatio) for a sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        AqueousSolventVolume -> 0.2*Milliliter,
        AqueousSolventRatio -> Null,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::AqueousSolventOptionsMismatched,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ],
    Example[{Messages, "OrganicSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified organic solvent options (OrganicSolvent, OrganicSolventVolume, OrganicSolventRatio) for a sample:"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        OrganicSolventVolume -> 0.2*Milliliter,
        OrganicSolventRatio -> Null,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::OrganicSolventOptionsMismatched,
        Error::InvalidOption
      },
      TimeConstraint -> 3600
    ],
    Example[{Messages, "DemulsifierOptionsMismatched", "An error is returned if there is a mix of specified and unspecified demulsifier options (Demulsifier, DemulsifierAmount, DemulsifierAdditions):"},
      ExperimentExtractSubcellularProtein[
        Object[Sample, "ExperimentExtractSubcellularProtein Previously Extracted Protein Sample " <> $SessionUUID],
        Demulsifier -> None,
        DemulsifierAmount -> 0.1*Milliliter,
        Output->Result
      ],
      $Failed,
      Messages:>{
        Error::DemulsifierOptionsMismatched,
        Error::InvalidOption
      },
      TimeConstraint -> 1800
    ]
    *)

  },
  Stubs :> {
    $AllowPublicObjects=True,
    $DeveloperSearch=True
  },
  Parallel -> True,
  TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct,Upload::Warning,Warning::ConflictingSourceAndDestinationAsepticHandling},
  SymbolSetUp :> Module[{allObjects,functionName,existingObjects,allSampleObjects},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    functionName="ExperimentExtractSubcellularProtein";
    (*Gather all the objects created in SymbolSetUp*)
    allObjects=Cases[Flatten[{
      (*containers*)
      Table[Object[Container, Plate, functionName <> " test 96-well plate " <>ToString[x]<> $SessionUUID],{x,12}],
      Object[Container, Vessel, functionName <> " test 50mL tube " <> $SessionUUID],
      Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID],
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
      (*Method*)
      Object[Method, Extraction, SubcellularProtein, functionName <> " Test Method for Microbial Cells " <> $SessionUUID]
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
        Flatten[{Table[
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],
              Objects],
            Name->functionName<>" test 96-well plate " <>ToString[x]<> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          {x,12}]}]
      ];
      Upload[{
        <|
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
          Name -> functionName<>" test 50mL tube "<>$SessionUUID,
          Site -> Link[$Site],
          DeveloperObject -> True
        |>
      }];

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
        FastTrack -> True
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
            Type -> Object[Method, Extraction, SubcellularProtein],
            Name -> functionName <> " Test Method for Microbial Cells " <> $SessionUUID,
            DeveloperObject -> True,
            Lyse -> True,
            Append[CellType] -> Bacterial,
            Replace[TargetSubcellularFraction] -> {Membrane,Cytosolic},
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
            Replace[FractionationOrder] -> {Cytosolic,Membrane},
            CytosolicFractionationTechnique -> Pellet,
            MembraneFractionationTechnique -> Pellet,
            CytosolicFractionationPelletIntensity -> 3500 GravitationalAcceleration,
            CytosolicFractionationPelletTime -> 30 Minute,
            MembraneFractionationPelletIntensity -> 3500 GravitationalAcceleration,
            MembraneFractionationPelletTime -> 30 Minute,
            Purification -> {MagneticBeadSeparation,LiquidLiquidExtraction},
            (*TCA/Acetone protein precipitation protocol reference: https://www.sigmaaldrich.com/US/en/technical-documents/technical-article/protein-biology/protein-lysis-and-extraction/precipitation-procedures;
            https://rtsf.natsci.msu.edu/sites/_rtsf/assets/File/2016_Acetone_Precipitation_of_Proteins.pdf*)
            (* Purification -> {Precipitation,SolidPhaseExtraction,LiquidLiquidExtraction,MagneticBeadSeparation},*)
            (* take out SPE and Precipitation for now
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
            SolidPhaseExtractionCartridge ->Link[Model[Container, Plate, Filter, "Zeba 40K 96-well Desalt Spin Plate"]],
            SolidPhaseExtractionStrategy ->Positive,
            SolidPhaseExtractionSeparationMode -> SizeExclusion,
            SolidPhaseExtractionSorbent -> SizeExclusion,
            SolidPhaseExtractionTechnique -> AirPressure,
            SolidPhaseExtractionLoadingTime -> 1 Minute,
            SolidPhaseExtractionElutionSolution -> Link[Model[Sample, "Milli-Q water"]],
            SolidPhaseExtractionElutionTime -> 1 Minute,
            *)
            LiquidLiquidExtractionSelectionStrategy -> Positive,
            LiquidLiquidExtractionTechnique -> Pipette,
            LiquidLiquidExtractionTargetPhase -> Aqueous,
            LiquidLiquidExtractionTargetLayer -> {Top,Top,Top},
            AqueousSolvent -> Model[Sample,"Milli-Q water"],
            OrganicSolvent -> Model[Sample, "Chloroform"],
            Replace[LiquidLiquidExtractionSolventAdditions]-> {{Model[Sample, "Chloroform"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]}},
            Demulsifier->None,
            Replace[DemulsifierAdditions]->{None,None,None},
            LiquidLiquidExtractionTemperature -> 4 Celsius,
            NumberOfLiquidLiquidExtractions -> 3,
            LiquidLiquidExtractionCentrifuge -> False,
            MagneticBeadSeparationMode -> Affinity,
            MagneticBeadSeparationSelectionStrategy -> Positive,
            MagneticBeads -> Link[Model[Sample, "Pierce Ni-NTA Magnetic Agarose Beads"]],
            MagneticBeadSeparationEquilibration -> True,
            MagneticBeadSeparationEquilibrationSolution -> Link[Model[Sample, StockSolution, "Pierce Ni-NTA Agarose Magnetic Bead Equilibration Buffer"]];
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
      functionName = "ExperimentExtractSubcellularProtein";
      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects= Cases[Flatten[{
        (*containers*)
        Table[Object[Container, Plate, functionName <> " test 96-well plate " <>ToString[x]<> $SessionUUID],{x,12}],
        Object[Container, Vessel, functionName <> " test 50mL tube " <> $SessionUUID],
        Model[Molecule, Protein, functionName <> " test protein " <> $SessionUUID],
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
        (*Method*)
        Object[Method, Extraction, SubcellularProtein, functionName <> " Test Method for Microbial Cells " <> $SessionUUID]
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