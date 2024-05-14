(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentLyseCells: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentLyseCells*)

DefineTests[ExperimentLyseCells,
  {

    (* - Basic Examples - *)
    Example[{Basic, "Lyse living cells within a sample:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        CellType -> Mammalian,
        LysisTime -> 10 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> Mammalian,
          LysisTime -> 10 Minute
        }]
      }
    ],

    Example[{Basic, "Lyse living cells within multiple samples:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        CellType -> Mammalian,
        LysisTime -> 10 Minute,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> Mammalian,
          LysisTime -> 10 Minute
        }]
      },
      TimeConstraint -> 800
    ],

    Example[{Additional, "Experiments with different temperature conditions are grouped into different plates when aliquoted into plates:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        LysisTemperature -> {57 Celsius, 37 Celsius},
        LysisSolutionVolume -> {0.5 Milliliter, 0.5 Milliliter},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotContainer -> {{1, PreferredContainer[1.0 Milliliter, LiquidHandlerCompatible->True, Type -> Plate]}, {2, PreferredContainer[1.0 Milliliter, LiquidHandlerCompatible->True, Type -> Plate]}}
        }]
      }
    ],

    Example[{Additional, "Experiments with different centrifugation conditions are grouped into different plates when aliquoted into plates:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        PreLysisPelletingTime -> {5 Minute, 15 Minute},
        LysisSolutionVolume -> {0.5 Milliliter, 0.5 Milliliter},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotContainer -> {{1, PreferredContainer[1.0 Milliliter, LiquidHandlerCompatible->True, Type -> Plate]}, {2, PreferredContainer[1.0 Milliliter, LiquidHandlerCompatible->True, Type -> Plate]}}
        }]
      }
    ],

    Example[{Additional, "Experiments with different mix-by-shaking conditions are grouped into different plates when aliquoted into plates:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        MixRate -> {200 RPM, 500 RPM},
        LysisSolutionVolume -> {0.5 Milliliter, 0.5 Milliliter},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotContainer -> {{1, PreferredContainer[1.0 Milliliter, LiquidHandlerCompatible->True, Type -> Plate]}, {2, PreferredContainer[1.0 Milliliter, LiquidHandlerCompatible->True, Type -> Plate]}}
        }]
      }
    ],

    Example[{Options, NumberOfReplicates, "Use the NumberOfReplicates option to submit multiple experiments with identical option settings:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        LysisSolution -> Model[Sample, StockSolution, "id:7X104vK9ZlWZ"],
        MixType -> Shake,
        LysisTemperature -> 37 Celsius,
        NumberOfReplicates -> 4,
        Aliquot -> True,
        Output -> {Result, Options}
        ],
        {
          ObjectP[Object[Protocol, RoboticCellPreparation]],
          KeyValuePattern[{
            LysisSolution -> Model[Sample, StockSolution, "id:7X104vK9ZlWZ"],
            MixType -> Shake,
            LysisTemperature -> 37 Celsius,
            NumberOfReplicates -> 4
          }]
        }
      ],

    Example[{Options, RoboticInstrument, "Specify the robotic liquid handler on which the experiment is to be performed using the RoboticInstrument option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        RoboticInstrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          RoboticInstrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"] (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
        }]
      }
    ],

    Example[{Options, RoboticInstrument, "If the input sample contains only nonmicrobial (i.e., Mammalian, Insect, or Plant) cells, then the bioSTAR liquid handler is used for the cell lysis experiment:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          RoboticInstrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"] (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
        }]
      }
    ],

    Example[{Options, RoboticInstrument, "If the input sample contains any microbial (i.e., Bacterial, Yeast, or Fungal) cells, then the microbioSTAR liquid handler is used for the cell lysis experiment:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          RoboticInstrument -> Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"] (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
        }]
      }
    ],

    Example[{Options, WorkCell, "If the input sample contains only nonmicrobial (i.e., Mammalian, Insect, or Plant) cells, then the bioSTAR work cell is used for the cell lysis experiment:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WorkCell -> bioSTAR
        }]
      }
    ],

    Example[{Options, WorkCell, "If the input sample contains any microbial (i.e., Bacterial, Yeast, or Fungal) cells, then the microbioSTAR work cell is used for the cell lysis experiment:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WorkCell -> microbioSTAR
        }]
      }
    ],

    Example[{Options, Method, "A Method containing a pre-set procedure for cell lysis can be specified:"},
      ExperimentLyseCells[
        Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Method -> Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ExperimentLyseCells) "<>$SessionUUID],
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          Method -> ObjectP[Object[Method, LyseCells]],
          CellType -> Mammalian,
          LysisSolution -> ObjectP[Model[Sample, StockSolution, "id:7X104vK9ZlWZ"]],
          TargetCellularComponent -> CytosolicProtein,
          MixType -> Shake
        }]
      }
    ],

    Example[{Options, Method, "With the Method option set to Custom, any experimental parameter can be specified by the user:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Method -> Custom,
        NumberOfLysisSteps -> 1,
        PreLysisPellet -> False,
        MixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          Method -> Custom,
          NumberOfLysisSteps -> 1,
          PreLysisPellet -> False,
          MixType -> None
        }]
      }
    ],

    Example[{Options, CellType, "Specify the CellType option to reflect the type of cells contained in the input sample:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        CellType -> Mammalian,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> Mammalian
        }]
      }
    ],

    Example[{Options, CellType, "Specify the CellType option to reflect the type of cells contained in the input sample:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        CellType -> Mammalian,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> Mammalian
        }]
      }
    ],

    Example[{Options, CultureAdhesion, "Specify the CultureAdhesion option to indicate whether the cells contained in the input sample are adhered to their container or suspended in solution:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        CultureAdhesion -> Adherent,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CultureAdhesion -> Adherent
        }]
      }
    ],

    Example[{Options, TargetCellularComponent, "Specify the TargetCellularComponent option to indicate which cellular component is to be isolated following lysis and subsequent operations:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        TargetCellularComponent -> RNA,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TargetCellularComponent -> RNA
        }]
      }
    ],

    Example[{Options, LysisSolution, "Specify the LysisSolution option to select a desired solution containing buffers, enzymes, chaotropics and other components with which to lyse the cells contained within the sample:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        LysisSolution -> Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"], (* Model[Sample, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisSolution -> Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"] (* Model[Sample, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
        }]
      }
    ],

    Example[{Options, SecondaryLysisSolution, "Specify the SecondaryLysisSolution option to select a desired solution containing buffers, enzymes, chaotropics and other components with which to lyse the cells contained within the sample during an optional second lysis step:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        SecondaryLysisSolution -> Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"], (* Model[Sample, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolution -> Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"] (* Model[Sample, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
        }]
      }
    ],

    Example[{Options, TertiaryLysisSolution, "Specify the TertiaryLysisSolution option to select a desired solution containing buffers, enzymes, chaotropics and other components with which to lyse the cells contained within the sample during an optional third lysis step:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        TertiaryLysisSolution -> Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"], (* Model[Sample, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisSolution -> Model[Sample, StockSolution, "id:kEJ9mqJxqNLV"] (* Model[Sample, "RIPA Lysis Buffer with protease inhibitor cocktail"] *)
        }]
      }
    ],

    Example[{Options, LysisSolutionVolume, "Specify the LysisSolutionVolume option:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        LysisSolutionVolume -> 1 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisSolutionVolume -> 1 Milliliter
        }]
      }
    ],

    Example[{Options, SecondaryLysisSolutionVolume, "Specify the SecondaryLysisSolutionVolume option:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        SecondaryLysisSolutionVolume -> 0.3 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolutionVolume -> 0.3 Milliliter
        }]
      }
    ],

    Example[{Options, TertiaryLysisSolutionVolume, "Specify the TertiaryLysisSolutionVolume option:"},
      ExperimentLyseCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        TertiaryLysisSolutionVolume -> 0.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisSolutionVolume -> 0.2 Milliliter
        }]
      }
    ],

    Example[{Additional, "Cells which are suspended in solution can be aliquoted without prior dissociation:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          Dissociate -> False
        }]
      }
    ],

    Example[{Options, Dissociate, "Set the Dissociate option to True to dissociate adherent cells from their current container in order to be aliquoted into a different container:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        CultureAdhesion -> Adherent,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          Dissociate -> True
        }]
      }
    ],

    Example[{Options, NumberOfLysisSteps, "If NumberOfLysisSteps is 1, the protocol will contain a single lysis step:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 1,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolution -> Null,
          SecondaryLysisSolutionVolume -> Null,
          SecondaryMixType -> Null,
          SecondaryMixRate -> Null,
          SecondaryMixTime -> Null,
          SecondaryMixVolume -> Null,
          SecondaryNumberOfMixes -> Null,
          SecondaryMixTemperature -> Null,
          SecondaryLysisTemperature -> Null,
          SecondaryLysisTime -> Null,
          SecondaryMixInstrument -> Null,
          SecondaryIncubationInstrument -> Null,
          TertiaryLysisSolution -> Null,
          TertiaryLysisSolutionVolume -> Null,
          TertiaryMixType -> Null,
          TertiaryMixRate -> Null,
          TertiaryMixTime -> Null,
          TertiaryMixVolume -> Null,
          TertiaryNumberOfMixes -> Null,
          TertiaryMixTemperature -> Null,
          TertiaryLysisTemperature -> Null,
          TertiaryLysisTime -> Null,
          TertiaryMixInstrument -> Null,
          TertiaryIncubationInstrument -> Null
        }]
      }
    ],

    Example[{Options, NumberOfLysisSteps, "Set the NumberOfLysisSteps option to 2 to add a second lysis step with unique conditions, including SecondaryLysisSolution, SecondaryLysisSolutionVolume, SecondaryMixType, SecondaryLysisTemperature, SecondaryLysisTime, and SecondaryIncubationInstrument:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolution -> ObjectP[Model[Sample]],
          SecondaryLysisSolutionVolume -> GreaterP[0 Microliter],
          SecondaryMixType -> (MixTypeP|None),
          SecondaryLysisTemperature -> (GreaterP[0 Celsius]|Ambient),
          SecondaryLysisTime -> GreaterP[0 Second],
          SecondaryIncubationInstrument -> ObjectP[Model[Instrument]],
          TertiaryLysisSolution -> Null,
          TertiaryLysisSolutionVolume -> Null,
          TertiaryMixType -> Null,
          TertiaryMixRate -> Null,
          TertiaryMixTime -> Null,
          TertiaryMixVolume -> Null,
          TertiaryNumberOfMixes -> Null,
          TertiaryMixTemperature -> Null,
          TertiaryLysisTemperature -> Null,
          TertiaryLysisTime -> Null,
          TertiaryMixInstrument -> Null,
          TertiaryIncubationInstrument -> Null
        }]
      }
    ],

    Example[{Options, NumberOfLysisSteps, "Set the NumberOfLysisSteps option to 3 to add second and third lysis steps with unique conditions:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisSolution -> ObjectP[Model[Sample]],
          SecondaryLysisSolutionVolume -> GreaterP[0 Microliter],
          SecondaryMixType -> (MixTypeP|None),
          SecondaryLysisTemperature -> (GreaterP[0 Celsius]|Ambient),
          SecondaryLysisTime -> GreaterP[0 Second],
          SecondaryIncubationInstrument -> ObjectP[Model[Instrument]],
          TertiaryLysisSolution -> ObjectP[Model[Sample]],
          TertiaryLysisSolutionVolume -> GreaterP[0 Microliter],
          TertiaryMixType -> (MixTypeP|None),
          TertiaryLysisTemperature -> (GreaterP[0 Celsius]|Ambient),
          TertiaryLysisTime -> GreaterP[0 Second],
          TertiaryIncubationInstrument -> ObjectP[Model[Instrument]]
        }]
      }
    ],

    Example[{Options, TargetCellCount, "For samples with cell count or concentration information in their composition field, specify the TargetCellCount option to aliquot a desired number of cells instead of a specified volume of solution:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TargetCellCount -> Quantity[2. * 10^9,IndependentUnit["Cells"]],
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotAmount -> 0.20 Milliliter
        }]
      }
    ],

    Example[{Options, TargetCellCount, "If there is no cell count or cell concentration information in the sample's composition field and TargetCellCount and TargetCellConcentration are both Automatic, TargetCellCount and TargetCellConcentration both resolve to Null:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TargetCellCount -> Automatic,
        TargetCellConcentration -> Automatic,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TargetCellCount -> Null,
          TargetCellConcentration -> Null
        }]
      }
    ],

    Example[{Options, TargetCellCount, "If TargetCellCount is Automatic and there is cell count or cell concentration information in the sample's composition field, TargetCellCount resolves to the number of cells present in the experiment, calculated from the sample's composition information:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TargetCellCount -> Automatic,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TargetCellCount -> Quantity[5. * 10^9,IndependentUnit["Cells"]]
        }]
      }
    ],

    Example[{Options, TargetCellConcentration, "If TargetCellConcentration is Automatic and there is cell count or cell concentration information in the sample's composition field, TargetCellConcentration resolves to the concentration of cells present in the experiment, calculated from the sample's composition information and the total volume:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TargetCellConcentration -> Automatic,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TargetCellConcentration -> 1. * 10^10 Quantity[1,Times[Power["Milliliters",-1],IndependentUnit["Cells"]]]
        }]
      }
    ],

    Example[{Options, TargetCellConcentration, "If dilution is required to obtain the specified TargetCellConcentration, PreLysisDilute is automatically set to True and PreLysisDilutionVolume resolves to the volume needed to obtain the TargetCellConcentration:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TargetCellConcentration -> 9.0 * 10^9 Quantity[1,Times[Power["Milliliters",-1],IndependentUnit["Cells"]]],
        AliquotAmount -> 200 Microliter,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDilute -> True,
          PreLysisDilutionVolume -> RangeP[22 Microliter, 23 Microliter]
        }]
      }
    ],

    Example[{Options, PreLysisPellet, "Specify the PreLysisPellet option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPellet -> True
        }]
      }
    ],

    Example[{Options, PreLysisPellet, "PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, and PreLysisSupernatantContainer must not be Null if PreLysisPellet is True:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingCentrifuge -> ObjectP[{Object[Instrument], Model[Instrument]}],
          PreLysisPelletingIntensity -> GreaterP[0 RPM],
          PreLysisPelletingTime -> GreaterP[0 Second],
          PreLysisSupernatantVolume -> GreaterP[0 Microliter],
          PreLysisSupernatantStorageCondition -> (SampleStorageTypeP|Disposal),
          PreLysisSupernatantContainer -> {_Integer, ObjectP[Model[Container]]}
        }]
      }
    ],

    Example[{Options, PreLysisPellet, "PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, and PreLysisSupernatantContainer must be Null if PreLysisPellet is False:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> False,
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
          PreLysisSupernatantContainer -> Null
        }]
      }
    ],

    Example[{Options, PreLysisPellet, "If PreLysisSupernatantContainer is set to Automatic, the total PreLysisSupernatantVolume of all samples is less than 50 mL, and PreLysisSupernatantStorageCondition is set to Disposal, the supernatants are grouped into a single tube:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        Aliquot -> True,
        PreLysisSupernatantStorageCondition -> Disposal,
        PreLysisSupernatantVolume -> 100 Microliter,
        NumberOfReplicates -> 2,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisSupernatantContainer -> {_Integer, PreferredContainer[200 Microliter, LiquidHandlerCompatible -> True]}
        }]
      }
    ],

    Example[{Options, PreLysisPelletingCentrifuge, "Specify a particular centrifuge or centrifuge model for pre-lysis pelleting using the PreLysisPelletingCentrifuge option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPelletingCentrifuge -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
          PreLysisPellet -> True
        }]
      }
    ],

    Example[{Options, PreLysisPelletingIntensity, "Specify the PreLysisPelletingIntensity option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPelletingIntensity -> 4000 RPM,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingIntensity -> 4000 RPM,
          PreLysisPellet -> True
        }]
      }
    ],

    Example[{Options, PreLysisPelletingTime, "Specify the PreLysisPelletingTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPelletingTime -> 15 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisPelletingTime -> 15 Minute,
          PreLysisPellet -> True
        }]
      }
    ],

    Example[{Options, PreLysisSupernatantVolume, "Specify the amount of supernatant to remove from the cell sample following pre-lysis pelleting using the PreLysisSupernatantVolume option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisSupernatantVolume -> 100 Microliter,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisSupernatantVolume -> 100 Microliter,
          PreLysisPellet -> True
        }]
      }
    ],

    Example[{Options, PreLysisSupernatantStorageCondition, "Specify the conditions under which the supernatant removed from the cell sample following pre-lysis pelleting is to be stored (or set to Disposal if storage of the supernatant is not desired) using the PreLysisSupernatantStorageCondition option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisSupernatantStorageCondition -> Disposal,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisSupernatantStorageCondition -> Disposal,
          PreLysisPellet -> True
        }]
      }
    ],

    Example[{Options, PreLysisSupernatantContainer, "Specify a particular container or container model into which the supernatant resulting from pre lysis pelleting is to be transferred using the PreLysisSupernatantContainer option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisSupernatantContainer -> Model[Container, Vessel, "50mL Tube"],
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisSupernatantContainer -> ObjectP[Model[Container, Vessel, "50mL Tube"]],
          PreLysisPellet -> True
        }]
      }
    ],

    Example[{Options, PreLysisSupernatantLabel, "Specify the PreLysisSupernatantLabel option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisSupernatantLabel -> "supernatant from sample A",
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisSupernatantLabel -> "supernatant from sample A"
        }]
      }
    ],

    Example[{Options, PreLysisSupernatantContainerLabel, "Specify the PreLysisSupernatantContainerLabel option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisSupernatantContainerLabel -> "supernatant container 1",
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisSupernatantContainerLabel -> "supernatant container 1"
        }]
      }
    ],

    Example[{Options, PreLysisDilute, "Set the PreLysisDilute option to True to adjust the concentration of the cell sample prior to addition of LysisSolution:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> True,
        PreLysisDilutionVolume -> 100 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDiluent -> Model[Sample, StockSolution, "id:9RdZXv1KejGK"], (* Model[Sample, StockSolution, "1x PBS from 10X stock"] *)
          PreLysisDilutionVolume -> 100 Microliter
        }]
      }
    ],

    Example[{Options, PreLysisDiluent, "Specify a desired PreLysisDiluent:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDiluent -> Model[Sample, StockSolution, "id:9RdZXv1KejGK"], (* Model[Sample, StockSolution, "1x PBS from 10X stock"] *)
        PreLysisDilutionVolume -> 100 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDiluent -> Model[Sample, StockSolution, "id:9RdZXv1KejGK"] (* Model[Sample, StockSolution, "1x PBS from 10X stock"] *)
        }]
      }
    ],

    Example[{Options, PreLysisDiluent, "PreLysisDiluent must be Null if PreLysisDilute is False:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> False,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDiluent -> Null
        }]
      }
    ],

    Example[{Options, PreLysisDiluent, "PreLysisDiluent must not be Null if PreLysisDilute is True:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> True,
        PreLysisDilutionVolume -> 100 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDiluent -> Except[Null]
        }]
      }
    ],

    Example[{Options, PreLysisDilutionVolume, "Use the PreLysisDilutionVolume option to specify a desired volume of PreLysisDiluent to be added to the sample prior to lysis:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilutionVolume -> 100 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PreLysisDilute -> True,
          PreLysisDiluent -> Except[Null],
          PreLysisDilutionVolume -> 100 Microliter
        }]
      }
    ],

    Example[{Options, ClarifyLysate, "Specify the ClarifyLysate option to remove unwanted, insoluble cellular debris from the lysate following lysis:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> True,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysateCentrifuge -> ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}],
          ClarifyLysateIntensity -> GreaterP[0 RPM],
          ClarifyLysateTime -> GreaterP[0 Second],
          ClarifiedLysateVolume -> GreaterP[0 Microliter],
          ClarifiedLysateContainer -> Alternatives[ObjectP[{Object[Container], Model[Container]}], {_Integer, ObjectP[Model[Container]]}],
          PostClarificationPelletStorageCondition -> (SampleStorageTypeP|Disposal)
        }]
      }
    ],

    Example[{Options, ClarifyLysate, "ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition must be Null if ClarifyLysate is False:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> False,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysateCentrifuge -> Null,
          ClarifyLysateIntensity -> Null,
          ClarifyLysateTime -> Null,
          ClarifiedLysateVolume -> Null,
          ClarifiedLysateContainer -> Null,
          PostClarificationPelletStorageCondition -> Null
        }]
      }
    ],

    Example[{Options, ClarifyLysateCentrifuge, "Specify a particular centrifuge or centrifuge model for lysate clarification using the ClarifyLysateCentrifuge option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysateCentrifuge -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysateCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (* Model[Instrument, Centrifuge, "HiG4"] *)
          ClarifyLysate -> True
        }]
      }
    ],

    Example[{Options, ClarifyLysateIntensity, "Specify the ClarifyLysateIntensity option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysateIntensity -> 2500 RPM,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysateIntensity -> 2500 RPM,
          ClarifyLysate -> True
        }]
      }
    ],

    Example[{Options, ClarifyLysateTime, "Specify the ClarifyLysateTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysateTime -> 15 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifyLysateTime -> 15 Minute,
          ClarifyLysate -> True
        }]
      }
    ],

    Example[{Options, ClarifiedLysateVolume, "Specify the amount of clarified lysate to remove from the lysate sample following clarification using the ClarifiedLysateVolume option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifiedLysateVolume -> 400 Microliter,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifiedLysateVolume -> 400 Microliter,
          ClarifyLysate -> True
        }]
      }
    ],

    Example[{Options, ClarifiedLysateContainer, "Specify a particular container or container model into which the clarified lysate is to be transferred using the ClarifiedLysateContainer option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifiedLysateContainer -> Model[Container, Vessel, "50mL Tube"],
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifiedLysateContainer -> ObjectP[Model[Container, Vessel, "50mL Tube"]],
          ClarifyLysate -> True
        }]
      }
    ],

    Example[{Options, ClarifiedLysateContainerLabel, "Specify the ClarifiedLysateContainerLabel option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifiedLysateContainerLabel -> "purified lysate container 8",
        ClarifyLysate -> True,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ClarifiedLysateContainerLabel -> "purified lysate container 8",
          ClarifyLysate -> True
        }]
      }
    ],

    Example[{Options, PostClarificationPelletLabel, "Specify the PostClarificationPelletLabel option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PostClarificationPelletLabel -> "pellet from clarification of sample 2B",
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PostClarificationPelletLabel -> "pellet from clarification of sample 2B"
        }]
      }
    ],

    Example[{Options, PostClarificationPelletContainerLabel, "Specify the PostClarificationPelletContainerLabel option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PostClarificationPelletContainerLabel -> "clarification pellet container 1",
        ClarifyLysate -> True,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PostClarificationPelletContainerLabel -> "clarification pellet container 1"
        }]
      }
    ],

    Example[{Options, PostClarificationPelletStorageCondition, "Specify the conditions under which the pellet obtained from lysate clarification is to be stored (or set to Disposal if storage of the supernatant is not desired) using the PostClarificationPelletStorageCondition option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PostClarificationPelletStorageCondition -> Disposal,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          PostClarificationPelletStorageCondition -> Disposal,
          ClarifyLysate -> True
        }]
      }
    ],

    Example[{Options, Aliquot, "Set the Aliquot option to True to transfer some or all of the sample out of its current container into a new container:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotAmount -> GreaterP[0 Microliter],
          AliquotContainer -> (ObjectP[Model[Container]] | {_Integer, ObjectP[Model[Container]]})
        }]
      }
    ],

    Example[{Options, Aliquot, "AliquotAmount and AliquotContainer must not be Null if Aliquot is True:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotAmount -> GreaterP[0 Microliter],
          AliquotContainer -> (ObjectP[Model[Container]] | {_Integer, ObjectP[Model[Container]]})
        }]
      }
    ],

    Example[{Options, AliquotAmount, "Specify the AliquotAmount option to transfer a desired volume of the input sample into a new container:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        AliquotAmount -> 200 Microliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotAmount -> 200 Microliter
        }]
      }
    ],

    Example[{Options, AliquotAmount, "AliquotAmount automatically resolves to Null if Aliquot is False:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> False,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotAmount -> Null
        }]
      }
    ],

    Example[{Options, AliquotContainer, "Specify the AliquotContainer option to aliquot the sample into a specific container or container model:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        AliquotContainer -> Model[Container, Vessel, "2mL Tube"],
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotContainer -> ObjectP[Model[Container, Vessel, "2mL Tube"]]
        }]
      }
    ],

    Example[{Options, AliquotContainer, "AliquotContainer automatically resolves to Null if Aliquot is False:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> False,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotContainer -> Null
        }]
      }
    ],

    Example[{Options, AliquotContainerLabel, "Specify the AliquotContainerLabel option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        AliquotContainerLabel -> "very important cell sample",
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotContainerLabel -> "very important cell sample",
          Aliquot -> True
        }]
      }
    ],

    Example[{Options, MixType, "Specify the MixType option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixRate -> GreaterP[0 RPM],
          MixTime -> GreaterP[0 Second],
          MixVolume -> Null,
          NumberOfMixes -> Null,
          MixTemperature -> (TemperatureP|Ambient),
          MixInstrument -> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}]
        }]
      }
    ],

    Example[{Options, MixType, "MixRate, MixTime, MixVolume, NumberOfMixes, MixTemperature, and MixInstrument are set to Null if MixType is None:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixRate -> Null,
          MixTime -> Null,
          MixVolume -> Null,
          NumberOfMixes -> Null,
          MixTemperature -> Null,
          MixInstrument -> Null
        }]
      }
    ],

    Example[{Options, MixType, "If MixType is Shake, the options MixRate, MixTime, MixTemperature, and MixInstrument must not be Null while MixVolume and NumberOfMixes must be Null:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixRate -> GreaterP[0 RPM],
          MixTime -> GreaterP[0 Second],
          MixVolume -> Null,
          NumberOfMixes -> Null,
          MixTemperature -> (TemperatureP|Ambient),
          MixInstrument -> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}]
        }]
      }
    ],

    Example[{Options, MixType, "If MixType is Pipette, the options MixVolume, and NumberOfMixes must not be Null while MixRate, MixTime, and MixInstrument must be Null:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixRate -> Null,
          MixTime -> Null,
          MixVolume -> GreaterP[0 Microliter],
          NumberOfMixes -> _Integer,
          MixInstrument -> Null
        }]
      }
    ],

    Example[{Options, SecondaryMixType, "Specify the SecondaryMixType option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixRate -> GreaterP[0 RPM],
          SecondaryMixTime -> GreaterP[0 Second],
          SecondaryMixVolume -> Null,
          SecondaryNumberOfMixes -> Null,
          SecondaryMixTemperature -> (TemperatureP|Ambient),
          SecondaryMixInstrument -> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}]
        }]
      }
    ],

    Example[{Options, SecondaryMixType, "SecondaryMixRate, SecondaryMixTime, SecondaryMixVolume, SecondaryNumberOfMixes, SecondaryMixTemperature, and SecondaryMixInstrument must all be Null if SecondaryMixType is None:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixRate -> Null,
          SecondaryMixTime -> Null,
          SecondaryMixVolume -> Null,
          SecondaryNumberOfMixes -> Null,
          SecondaryMixTemperature -> Null,
          SecondaryMixInstrument -> Null
        }]
      }
    ],

    Example[{Options, SecondaryMixType, "If SecondaryMixType is Shake, the options SecondaryMixRate, SecondaryMixTime, SecondaryMixTemperature, and SecondaryMixInstrument must not be Null while SecondaryMixVolume and SecondaryNumberOfMixes must be Null:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixRate -> GreaterP[0 RPM],
          SecondaryMixTime -> GreaterP[0 Second],
          SecondaryMixVolume -> Null,
          SecondaryNumberOfMixes -> Null,
          SecondaryMixTemperature -> (Ambient|TemperatureP),
          SecondaryMixInstrument -> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}]
        }]
      }
    ],

    Example[{Options, SecondaryMixType, "If SecondaryMixType is Pipette, the options SecondaryMixVolume, and SecondaryNumberOfMixes must not be Null while SecondaryMixRate, SecondaryMixTime, and SecondaryMixInstrument must be Null:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixRate -> Null,
          SecondaryMixTime -> Null,
          SecondaryMixVolume -> GreaterP[0 Microliter],
          SecondaryNumberOfMixes -> _Integer
        }]
      }
    ],

    Example[{Options, TertiaryMixType, "Specify the TertiaryMixType option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Shake,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixRate -> GreaterP[0 RPM],
          TertiaryMixTime -> GreaterP[0 Second],
          TertiaryMixVolume -> Null,
          TertiaryNumberOfMixes -> Null,
          TertiaryMixTemperature -> (TemperatureP|Ambient),
          TertiaryMixInstrument -> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}]
        }]
      }
    ],

    Example[{Options, TertiaryMixType, "TertiaryMixRate, TertiaryMixTime, TertiaryMixVolume, TertiaryNumberOfMixes, TertiaryMixTemperature, and TertiaryMixInstrument must all be Null if TertiaryMixType is None:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixRate -> Null,
          TertiaryMixTime -> Null,
          TertiaryMixVolume -> Null,
          TertiaryNumberOfMixes -> Null,
          TertiaryMixTemperature -> Null,
          TertiaryMixInstrument -> Null
        }]
      }
    ],

    Example[{Options, TertiaryMixType, "If TertiaryMixType is Shake, the options TertiaryMixRate, TertiaryMixTime, TertiaryMixTemperature, and TertiaryMixInstrument must not be Null while TertiaryMixVolume and TertiaryNumberOfMixes must be Null:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        Aliquot -> True,
        SecondaryMixType -> None,
        TertiaryMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixRate -> GreaterP[0 RPM],
          TertiaryMixTime -> GreaterP[0 Second],
          TertiaryMixVolume -> Null,
          TertiaryNumberOfMixes -> Null,
          TertiaryMixTemperature -> (TemperatureP|Ambient),
          TertiaryMixInstrument -> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}]
        }]
      }
    ],

    Example[{Options, TertiaryMixType, "If TertiaryMixType is Pipette, the options TertiaryMixVolume, and TertiaryNumberOfMixes must not be Null while TertiaryMixRate, TertiaryMixTime, and TertiaryMixInstrument must be Null:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        SecondaryMixType -> None,
        TertiaryMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixRate -> Null,
          TertiaryMixTime -> Null,
          TertiaryMixVolume -> GreaterP[0 Microliter],
          TertiaryNumberOfMixes -> _Integer,
          TertiaryMixInstrument -> Null
        }]
      }
    ],

    Example[{Options, MixRate, "Specify the MixRate option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixRate -> 300 RPM,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixRate -> 300 RPM
        }]
      }
    ],

    Example[{Options, SecondaryMixRate, "Specify the SecondaryMixRate option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixRate -> 300 RPM,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixRate -> 300 RPM
        }]
      }
    ],

    Example[{Options, TertiaryMixRate, "Specify the TertiaryMixRate option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixRate -> 300 RPM,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixRate -> 300 RPM
        }]
      }
    ],

    Example[{Options, MixTime, "Specify the MixTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixTime -> 2 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixTime -> 2 Minute
        }]
      }
    ],

    Example[{Options, SecondaryMixTime, "Specify the SecondaryMixTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixTime -> 2 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixTime -> 2 Minute
        }]
      }
    ],

    Example[{Options, TertiaryMixTime, "Specify the TertiaryMixTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixTime -> 2 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixTime -> 2 Minute
        }]
      }
    ],

    Example[{Options, NumberOfMixes, "Specify the NumberOfMixes option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfMixes -> 15,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfMixes -> 15
        }]
      }
    ],

    Example[{Options, SecondaryNumberOfMixes, "Specify the SecondaryNumberOfMixes option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryNumberOfMixes -> 15,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryNumberOfMixes -> 15
        }]
      }
    ],

    Example[{Options, TertiaryNumberOfMixes, "Specify the TertiaryNumberOfMixes option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryNumberOfMixes -> 15,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryNumberOfMixes -> 15
        }]
      }
    ],

    Example[{Options, MixVolume, "Specify the MixVolume option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixVolume -> 250 Microliter,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixVolume -> 250 Microliter
        }]
      }
    ],

    Example[{Options, SecondaryMixVolume, "Specify the SecondaryMixVolume option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixVolume -> 250 Microliter,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixVolume -> 250 Microliter
        }]
      }
    ],

    Example[{Options, TertiaryMixVolume, "Specify the TertiaryMixVolume option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixVolume -> 250 Microliter,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixVolume -> 250 Microliter
        }]
      }
    ],

    Example[{Options, MixTemperature, "Specify the MixTemperature option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixTemperature -> Ambient,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixTemperature -> Ambient
        }]
      }
    ],

    Example[{Options, SecondaryMixTemperature, "Specify the SecondaryMixTemperature option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixTemperature -> 38 Celsius,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixTemperature -> 38 Celsius
        }]
      }
    ],

    Example[{Options, TertiaryMixTemperature, "Specify the TertiaryMixTemperature option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixTemperature -> Ambient,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixTemperature -> Ambient
        }]
      }
    ],

    Example[{Options, MixInstrument, "Specify the MixInstrument option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          MixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
        }]
      }
    ],

    Example[{Options, SecondaryMixInstrument, "Specify the SecondaryMixInstrument option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
        }]
      }
    ],

    Example[{Options, TertiaryMixInstrument, "Specify the TertiaryMixInstrument option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
        }]
      }
    ],

    Example[{Options, LysisTime, "Specify the LysisTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        LysisTime -> 10 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisTime -> 10 Minute
        }]
      }
    ],

    Example[{Options, SecondaryLysisTime, "Specify the SecondaryLysisTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryLysisTime -> 10 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisTime -> 10 Minute
        }]
      }
    ],

    Example[{Options, TertiaryLysisTime, "Specify the TertiaryLysisTime option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryLysisTime -> 10 Minute,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisTime -> 10 Minute
        }]
      }
    ],

    Example[{Options, LysisTemperature, "Specify the LysisTemperature option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        LysisTemperature -> 40 Celsius,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          LysisTemperature -> 40 Celsius
        }]
      }
    ],

    Example[{Options, SecondaryLysisTemperature, "Specify the SecondaryLysisTemperature option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryLysisTemperature -> 40 Celsius,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryLysisTemperature -> 40 Celsius
        }]
      }
    ],

    Example[{Options, TertiaryLysisTemperature, "Specify the TertiaryLysisTemperature option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryLysisTemperature -> 40 Celsius,
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryLysisTemperature -> 40 Celsius
        }]
      }
    ],

    Example[{Options, IncubationInstrument, "Specify the IncubationInstrument option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        IncubationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          IncubationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
        }]
      }
    ],

    Example[{Options, SecondaryIncubationInstrument, "Specify the SecondaryIncubationInstrument option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryIncubationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          SecondaryIncubationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
        }]
      }
    ],

    Example[{Options, TertiaryIncubationInstrument, "Specify the TertiaryIncubationInstrument option:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryIncubationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
        Aliquot -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          TertiaryIncubationInstrument -> Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
        }]
      }
    ],

    Example[{Messages, "UnsupportedCellType", "If any input sample has a CellType other than those currently supported (Mammalian, Bacterial, and Yeast), an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension insect cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        }
      ],
      $Failed,
      Messages :> {
        Error::UnsupportedCellType,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ExtraneousSecondaryLysisOptions", "If any secondary lysis options are specified while NumberOfLysisSteps is 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 1,
        SecondaryLysisTime -> 5 Minute
      ],
      $Failed,
      Messages :> {
        Error::ExtraneousSecondaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ExtraneousTertiaryLysisOptions", "If any tertiary lysis options are specified while NumberOfLysisSteps is less than 3, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        TertiaryLysisTime -> 5 Minute
      ],
      $Failed,
      Messages :> {
        Error::ExtraneousTertiaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientSecondaryLysisOptions", "If SecondaryLysisSolution is Null while NumberOfLysisSteps is greater than 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        LysisSolutionVolume -> 500 Microliter, (* specifying this to avoid an additional message about the volume of lysis solution being too low *)
        SecondaryLysisSolution -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientSecondaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientSecondaryLysisOptions", "If SecondaryLysisSolutionVolume is Null while NumberOfLysisSteps is greater than 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        LysisSolutionVolume -> 500 Microliter, (* specifying this to avoid an additional message about the volume of lysis solution being too low *)
        SecondaryLysisSolutionVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientSecondaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientSecondaryLysisOptions", "If SecondaryMixType is Null while NumberOfLysisSteps is greater than 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        SecondaryMixType -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientSecondaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientSecondaryLysisOptions", "If SecondaryLysisTemperature is Null while NumberOfLysisSteps is greater than 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        SecondaryLysisTemperature -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientSecondaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientSecondaryLysisOptions", "If SecondaryLysisTime is Null while NumberOfLysisSteps is greater than 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        SecondaryLysisTime -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientSecondaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientSecondaryLysisOptions", "If SecondaryIncubationInstrument is Null while NumberOfLysisSteps is greater than 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 2,
        SecondaryIncubationInstrument -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientSecondaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientTertiaryLysisOptions", "If TertiaryLysisSolution is Null while NumberOfLysisSteps is 3, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        LysisSolutionVolume -> 500 Microliter, (* specifying this to avoid an additional message about the volume of lysis solution being too low *)
        TertiaryLysisSolution -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientTertiaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientTertiaryLysisOptions", "If TertiaryLysisSolutionVolume is Null while NumberOfLysisSteps is 3, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        LysisSolutionVolume -> 500 Microliter, (* specifying this to avoid an additional message about the volume of lysis solution being too low *)
        TertiaryLysisSolutionVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientTertiaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientTertiaryLysisOptions", "If TertiaryMixType is Null while NumberOfLysisSteps is 3, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        TertiaryMixType -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientTertiaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientTertiaryLysisOptions", "If TertiaryLysisTemperature is Null while NumberOfLysisSteps is 3, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        TertiaryLysisTemperature -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientTertiaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientTertiaryLysisOptions", "If TertiaryLysisTime is Null while NumberOfLysisSteps is 3, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        TertiaryLysisTime -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientTertiaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientTertiaryLysisOptions", "If TertiaryIncubationInstrument is Null while NumberOfLysisSteps is 3, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        NumberOfLysisSteps -> 3,
        TertiaryIncubationInstrument -> Null
      ],
      $Failed,
      Messages :> {
        Error::InsufficientTertiaryLysisOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "AliquotOptionsMismatch", "If AliquotAmount is Null while Aliquot is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        AliquotAmount -> Null
      ],
      $Failed,
      Messages :> {
        Error::AliquotOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "AliquotOptionsMismatch", "If AliquotContainer is Null while Aliquot is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        AliquotContainer -> Null
      ],
      $Failed,
      Messages :> {
        Error::AliquotOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "AliquotOptionsMismatch", "If AliquotAmount is not Null while Aliquot is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> False,
        AliquotAmount -> 300 Microliter
      ],
      $Failed,
      Messages :> {
        Error::AliquotOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "AliquotOptionsMismatch", "If AliquotContainer is not Null while Aliquot is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> False,
        AliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"]
      ],
      $Failed,
      Messages :> {
        Error::AliquotOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisPelletOptionsMismatch", "If any pre lysis pelleting options are not Null while PreLysisPellet is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> False,
        PreLysisPelletingTime -> 15 Minute,
        PreLysisPelletingIntensity -> 1500 RPM,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::PreLysisPelletOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisPelletOptionsMismatch", "If PreLysisPelletingCentrifuge is Null while PreLysisPellet is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        PreLysisPelletingCentrifuge -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::PreLysisPelletOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisPelletOptionsMismatch", "If PreLysisPelletingIntensity is Null while PreLysisPellet is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        PreLysisPelletingIntensity -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::PreLysisPelletOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisPelletOptionsMismatch", "If PreLysisPelletingTime is Null while PreLysisPellet is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        PreLysisPelletingTime -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::PreLysisPelletOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisPelletOptionsMismatch", "If PreLysisSupernatantVolume is Null while PreLysisPellet is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        PreLysisSupernatantVolume -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::PreLysisPelletOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisPelletOptionsMismatch", "If PreLysisSupernatantStorageCondition is Null while PreLysisPellet is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        PreLysisSupernatantStorageCondition -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::PreLysisPelletOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisPelletOptionsMismatch", "If PreLysisSupernatantContainer is Null while PreLysisPellet is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> True,
        PreLysisSupernatantContainer -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::PreLysisPelletOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisDiluteOptionsMismatch", "If PreLysisDilutionVolume is not Null while PreLysisDilute is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> False,
        PreLysisDilutionVolume -> 50 Microliter
      ],
      $Failed,
      Messages :> {
        Error::PreLysisDiluteOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisDiluteOptionsMismatch", "If PreLysisDiluent is not Null while PreLysisDilute is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> False,
        PreLysisDiluent -> Model[Sample, StockSolution, "id:9RdZXv1KejGK"] (* Model[Sample, StockSolution, "1x PBS from 10X stock"] *)
      ],
      $Failed,
      Messages :> {
        Error::PreLysisDiluteOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisDiluteOptionsMismatch", "If PreLysisDiluent is Null while PreLysisDilute is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> True,
        PreLysisDilutionVolume -> 50 Microliter,
        PreLysisDiluent -> Null
      ],
      $Failed,
      Messages :> {
        Error::PreLysisDiluteOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisDiluteOptionsMismatch", "If PreLysisDilutionVolume is Null while PreLysisDilute is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> True,
        PreLysisDiluent -> Model[Sample, StockSolution, "id:9RdZXv1KejGK"], (* Model[Sample, StockSolution, "1x PBS from 10X stock"] *)
        PreLysisDilutionVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::PreLysisDiluteOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PreLysisDiluteOptionsMismatch", "If PreLysisDiluent is Null while PreLysisDilute is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> True,
        PreLysisDilutionVolume -> 50 Microliter,
        PreLysisDiluent -> Null
      ],
      $Failed,
      Messages :> {
        Error::PreLysisDiluteOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifyLysateIntensity is not Null while ClarifyLysate is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> False,
        ClarifyLysateIntensity -> 600 RPM,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifyLysateTime is not Null while ClarifyLysate is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> False,
        ClarifyLysateTime -> 15 Minute,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifyLysateCentrifuge is not Null while ClarifyLysate is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> False,
        ClarifyLysateCentrifuge -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifiedLysateContainer is not Null while ClarifyLysate is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> False,
        ClarifiedLysateContainer -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifyLysateIntensity is Null while ClarifyLysate is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> True,
        ClarifyLysateIntensity -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifyLysateTime is Null while ClarifyLysate is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> True,
        ClarifyLysateTime -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifyLysateCentrifuge is Null while ClarifyLysate is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> True,
        ClarifyLysateCentrifuge -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ClarifyLysateOptionsMismatch", "If ClarifiedLysateContainer is Null while ClarifyLysate is True, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        ClarifyLysate -> True,
        ClarifiedLysateContainer -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::ClarifyLysateOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByShakingOptionsMismatch", "If MixRate is Null while MixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        MixRate -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::MixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByShakingOptionsMismatch", "If MixTime is Null while MixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        MixTime -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::MixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByShakingOptionsMismatch", "If MixInstrument is Null while MixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        MixInstrument -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::MixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByShakingOptionsMismatch", "If MixTemperature is Null while MixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        MixTemperature -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::MixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByShakingOptionsMismatch", "If MixVolume is not Null while MixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        MixVolume -> 0.2 Milliliter,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::MixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByShakingOptionsMismatch", "If NumberOfMixes is not Null while MixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Shake,
        NumberOfMixes -> 15,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::MixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByShakingOptionsMismatch", "If SecondaryMixRate is Null while SecondaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        SecondaryMixRate -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByShakingOptionsMismatch", "If SecondaryMixTime is Null while SecondaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        SecondaryMixTime -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByShakingOptionsMismatch", "If SecondaryMixInstrument is Null while SecondaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        SecondaryMixInstrument -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByShakingOptionsMismatch", "If SecondaryMixTemperature is Null while SecondaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        SecondaryMixTemperature -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByShakingOptionsMismatch", "If SecondaryMixVolume is not Null while SecondaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        SecondaryMixVolume -> 0.2 Milliliter,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByShakingOptionsMismatch", "If SecondaryNumberOfMixes is not Null while SecondaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Shake,
        SecondaryNumberOfMixes -> 15,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByShakingOptionsMismatch", "If TertiaryMixRate is Null while TertiaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Shake,
        TertiaryMixRate -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByShakingOptionsMismatch", "If TertiaryMixTime is Null while TertiaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Shake,
        TertiaryMixTime -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByShakingOptionsMismatch", "If TertiaryMixInstrument is Null while TertiaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Shake,
        TertiaryMixInstrument -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByShakingOptionsMismatch", "If TertiaryMixTemperature is Null while TertiaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Shake,
        TertiaryMixTemperature -> Null,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByShakingOptionsMismatch", "If TertiaryMixVolume is not Null while TertiaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Shake,
        TertiaryMixVolume -> 0.2 Milliliter,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByShakingOptionsMismatch", "If TertiaryNumberOfMixes is not Null while TertiaryMixType is Shake, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Shake,
        TertiaryNumberOfMixes -> 15,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByShakingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByPipettingOptionsMismatch", "If NumberOfMixes is Null while MixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Pipette,
        NumberOfMixes -> Null
      ],
      $Failed,
      Messages :> {
        Error::MixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByPipettingOptionsMismatch", "If MixVolume is Null while MixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Pipette,
        MixVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::MixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByPipettingOptionsMismatch", "If MixRate is not Null while MixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Pipette,
        MixRate -> 300 RPM
      ],
      $Failed,
      Messages :> {
        Error::MixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByPipettingOptionsMismatch", "If MixTime is not Null while MixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Pipette,
        MixTime -> 30 Second
      ],
      $Failed,
      Messages :> {
        Error::MixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixByPipettingOptionsMismatch", "If MixInstrument is not Null while MixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> Pipette,
        MixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
      ],
      $Failed,
      Messages :> {
        Error::MixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByPipettingOptionsMismatch", "If SecondaryNumberOfMixes is Null while SecondaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Pipette,
        SecondaryNumberOfMixes -> Null
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByPipettingOptionsMismatch", "If SecondaryMixVolume is Null while SecondaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Pipette,
        SecondaryMixVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByPipettingOptionsMismatch", "If SecondaryMixRate is not Null while SecondaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Pipette,
        SecondaryMixRate -> 300 RPM
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByPipettingOptionsMismatch", "If SecondaryMixTime is not Null while SecondaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Pipette,
        SecondaryMixTime -> 30 Second
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixByPipettingOptionsMismatch", "If SecondaryMixInstrument is not Null while SecondaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> Pipette,
        SecondaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByPipettingOptionsMismatch", "If TertiaryNumberOfMixes is Null while TertiaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Pipette,
        TertiaryNumberOfMixes -> Null
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByPipettingOptionsMismatch", "If TertiaryMixVolume is Null while TertiaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Pipette,
        TertiaryMixVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByPipettingOptionsMismatch", "If TertiaryMixRate is not Null while TertiaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Pipette,
        TertiaryMixRate -> 300 RPM
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByPipettingOptionsMismatch", "If TertiaryMixTime is not Null while TertiaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Pipette,
        TertiaryMixTime -> 30 Second
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixByPipettingOptionsMismatch", "If TertiaryMixInstrument is not Null while TertiaryMixType is Pipette, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> Pipette,
        TertiaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixByPipettingOptionsMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixTypeNoneMismatch", "If MixRate is not Null while MixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        MixRate -> 200 RPM
      ],
      $Failed,
      Messages :> {
        Error::MixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixTypeNoneMismatch", "If MixTime is not Null while MixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        MixTime -> 10 Minute
      ],
      $Failed,
      Messages :> {
        Error::MixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixTypeNoneMismatch", "If NumberOfMixes is not Null while MixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        NumberOfMixes -> 6
      ],
      $Failed,
      Messages :> {
        Error::MixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixTypeNoneMismatch", "If MixVolume is not Null while MixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        MixVolume -> 100 Microliter
      ],
      $Failed,
      Messages :> {
        Error::MixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixTypeNoneMismatch", "If MixTemperature is not Null while MixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        MixTemperature -> 40 Celsius,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::MixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "MixTypeNoneMismatch", "If MixInstrument is not Null while MixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        MixType -> None,
        MixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
      ],
      $Failed,
      Messages :> {
        Error::MixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixTypeNoneMismatch", "If SecondaryMixRate is not Null while SecondaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> None,
        SecondaryMixRate -> 200 RPM
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixTypeNoneMismatch", "If SecondaryMixTime is not Null while SecondaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> None,
        SecondaryMixTime -> 10 Minute
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixTypeNoneMismatch", "If SecondaryNumberOfMixes is not Null while SecondaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> None,
        SecondaryNumberOfMixes -> 6
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixTypeNoneMismatch", "If SecondaryMixVolume is not Null while SecondaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> None,
        SecondaryMixVolume -> 100 Microliter
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixTypeNoneMismatch", "If SecondaryMixTemperature is not Null while SecondaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> None,
        SecondaryMixTemperature -> 40 Celsius,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "SecondaryMixTypeNoneMismatch", "If SecondaryMixInstrument is not Null while SecondaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        SecondaryMixType -> None,
        SecondaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
      ],
      $Failed,
      Messages :> {
        Error::SecondaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixTypeNoneMismatch", "If TertiaryMixRate is not Null while TertiaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> None,
        TertiaryMixRate -> 200 RPM
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixTypeNoneMismatch", "If TertiaryMixTime is not Null while TertiaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> None,
        TertiaryMixTime -> 10 Minute
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixTypeNoneMismatch", "If TertiaryNumberOfMixes is not Null while TertiaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> None,
        TertiaryNumberOfMixes -> 6
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixTypeNoneMismatch", "If TertiaryMixVolume is not Null while TertiaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> None,
        TertiaryMixVolume -> 100 Microliter
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixTypeNoneMismatch", "If TertiaryMixTemperature is not Null while TertiaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> None,
        TertiaryMixTemperature -> 40 Celsius,
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TertiaryMixTypeNoneMismatch", "If TertiaryMixInstrument is not Null while TertiaryMixType is None, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TertiaryMixType -> None,
        TertiaryMixInstrument -> Model[Instrument, Shaker, "id:pZx9jox97qNp"] (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
      ],
      $Failed,
      Messages :> {
        Error::TertiaryMixTypeNoneMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ConflictingMixOptionsInSameContainerForLysis", "If multiple samples within the same plate have different parameters set for any mixing options, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        AliquotContainer -> {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
        MixRate -> {200 RPM, 300 RPM}
      ],
      $Failed,
      Messages :> {
        Error::ConflictingMixOptionsInSameContainerForLysis,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ConflictingIncubationOptionsInSameContainerForLysis", "If multiple samples within the same plate have different parameters set for any incubation options, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        AliquotContainer -> {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
        LysisTemperature -> {25 Celsius, 37 Celsius}
      ],
      $Failed,
      Messages :> {
        Error::ConflictingIncubationOptionsInSameContainerForLysis,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ConflictingCentrifugationConditionsInSameContainerForLysis", "If multiple samples within the same plate have different parameters set for any centrifugation options, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        AliquotContainer -> {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
        PreLysisPelletingIntensity -> {1500 RPM, 2000 RPM}
      ],
      $Failed,
      Messages :> {
        Error::ConflictingCentrifugationConditionsInSameContainerForLysis,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "AliquotAdherentCells", "If Aliquot is True for an Adherent cell sample but Dissociate is False, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        Dissociate -> False
      ],
      $Failed,
      Messages :> {
        Error::AliquotAdherentCells,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ReplicateAliquotsRequiredForLysis", "If Aliquot is False while NumberOfReplicates is greater than 1, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> False,
        NumberOfReplicates -> 4
      ],
      $Failed,
      Messages :> {
        Error::ReplicateAliquotsRequiredForLysis,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "NoCellCountOrConcentrationData", "If TargetCellCount is specified but there is no cell count or cell concentration information in the sample's composition field, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TargetCellCount -> 7.3 * 10^6 Quantity[1, IndependentUnit["Cells"]],
        Aliquot -> True
      ],
      $Failed,
      Messages :> {
        Error::NoCellCountOrConcentrationData,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "NoCellCountOrConcentrationData", "If TargetCellConcentration is specified but there is no cell count or cell concentration information in the sample's composition field, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot->True,
        PreLysisPellet->True,
        TargetCellConcentration -> 2.3 * 10^5 Quantity[1,Times[Power["Milliliters",-1],IndependentUnit["Cells"]]]
      ],
      $Failed,
      Messages :> {
        Error::NoCellCountOrConcentrationData,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DissociateSuspendedCells", "If Dissociate is set to True but CultureAdhesion is Suspension, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Dissociate -> True
      ],
      $Failed,
      Messages :> {
        Error::DissociateSuspendedCells,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "UnresolvablePreLysisDilutionVolume", "If PreLysisDilute is True but PreLysisDilutionVolume and TargetCellConcentration are both Automatic or Null, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisDilute -> True,
        PreLysisDilutionVolume -> Automatic,
        TargetCellConcentration -> Automatic
      ],
      $Failed,
      Messages :> {
        Error::UnresolvablePreLysisDilutionVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InsufficientCellCount", "If TargetCellCount is specified and the number of cells required for the experiment is greater than the number of cells in the source sample, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        TargetCellCount -> 1*10^10 Quantity[1,IndependentUnit["Cells"]],
        Aliquot -> True,
        AliquotContainer -> Model[Container, Vessel, "50mL Tube"]
      ],
      $Failed,
      Messages :> {
        Error::InsufficientCellCount,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "UnknownCultureAdhesion", "If CultureAdhesion is not specified by the user nor known from the CultureAdhesion field of the sample object, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCells) "<>$SessionUUID]
        }
      ],
      $Failed,
      Messages :> {
        Error::UnknownCultureAdhesion,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ConflictingSamplesOutStorageConditionInSameContainer", "If any two or more samples with different SamplesOutStorageConditions will be in the same container at the completion of the cell lysis experiment, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        AliquotContainer -> {{1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}, {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}},
        SamplesOutStorageCondition -> {Refrigerator, Freezer}
      ],
      $Failed,
      Messages :> {
        Error::ConflictingSamplesOutStorageConditionInSameContainer,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ConflictingPreLysisSupernatantStorageConditionInSameContainer", "If any two or more supernatant samples resulting from pre-lysis pelleting with different PreLysisSupernatantStorageCondition will be transferred to the same container, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        PreLysisSupernatantContainer -> {{1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}, {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}},
        PreLysisSupernatantStorageCondition -> {Disposal, Freezer}
      ],
      $Failed,
      Messages :> {
        Error::ConflictingPreLysisSupernatantStorageConditionInSameContainer,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ConflictingPostClarificationPelletStorageConditionInSameContainer", "If any two or more pellet samples (resulting from lysate clarification) with different PostClarificationPelletStorageConditions will be in the same container at the completion of the cell lysis experiment, an error is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> True,
        AliquotContainer -> {{1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}, {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}},
        PostClarificationPelletStorageCondition -> {Disposal, Freezer}
      ],
      $Failed,
      Messages :> {
        Error::ConflictingPostClarificationPelletStorageConditionInSameContainer,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PelletingRequiredToObtainTargetCellConcentration", "If PreLysisPellet is left Automatic but pelleting is required to obtain the specified TargetCellConcentration, PreLysisPellet is set to True and a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        PreLysisPellet -> Automatic,
        Aliquot -> True,
        TargetCellConcentration -> 2*10^10 Quantity[1,Times[Power["Milliliters",-1],IndependentUnit["Cells"]]]
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::PelletingRequiredToObtainTargetCellConcentration
      }
    ],

    Example[{Messages, "UnknownCellType", "If CellType is not specified by the user nor known from the CellType field of the sample object, CellType defaults to Bacterial and a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCells) "<>$SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::UnknownCellType
      }
    ],

    Example[{Messages, "LowRelativeLysisSolutionVolume", "If the sum of the LysisSolutionVolume, LysisSolutionVolume, and LysisSolutionVolume are less than the volume of combined sample and media to which the lysis solutions are added, a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        LysisSolutionVolume -> 200 Microliter
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::LowRelativeLysisSolutionVolume
      }
    ],

    Example[{Messages, "AliquotingRequiredForCellLysis", "If Aliquot is set to Automatic but NumberOfReplicates is specified, Aliquot is set to True and a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> Automatic,
        NumberOfReplicates -> 2
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::AliquotingRequiredForCellLysis
      }
    ],

    Example[{Messages, "AliquotingRequiredForCellLysis", "If Aliquot is set to Automatic but TargetCellCount is specified, Aliquot is set to True and a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> Automatic,
        TargetCellCount -> 7.3 * 10^6 Quantity[1, IndependentUnit["Cells"]]
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::AliquotingRequiredForCellLysis
      }
    ],

    Example[{Messages, "AliquotingRequiredForCellLysis", "If Aliquot is set to Automatic but TargetCellConcentration is specified, Aliquot is set to True and a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> Automatic,
        TargetCellConcentration -> 5 * 10^9 Quantity[1,Times[Power["Milliliters",-1],IndependentUnit["Cells"]]]
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::AliquotingRequiredForCellLysis
      }
    ],

    Example[{Messages, "AliquotingRequiredForCellLysis", "If Aliquot is set to Automatic but the sample must be aliquoted into a centrifuge compatible container, Aliquot is set to True and a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> Automatic,
        PreLysisPellet -> True
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::AliquotingRequiredForCellLysis
      }
    ],

    Example[{Messages, "AliquotingRequiredForCellLysis", "If Aliquot is set to Automatic but the sample must be aliquoted into a mix-by-shaking compatible container, Aliquot is set to True and a warning is thrown:"},
      ExperimentLyseCells[
        {
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        },
        Aliquot -> Automatic,
        MixType -> Shake
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      Messages :> {
        Warning::AliquotingRequiredForCellLysis
      }
    ],

    Test["Test the LyseCells unit operation:",
      ExperimentRoboticCellPreparation[
        LyseCells[
          Sample -> Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID]
        ],
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],

    Test["Test the LyseCells unit operation with other unit operations immediately before and after:",
      ExperimentRoboticCellPreparation[
        {
          Mix[
            Sample -> Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) " <> $SessionUUID],
            MixType -> Pipette,
            NumberOfMixes -> 5
          ],
          LyseCells[
            Sample -> Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) " <> $SessionUUID],
            Aliquot -> False
          ],
          Transfer[
            Source -> Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) " <> $SessionUUID],
            Destination -> Model[Container, Vessel, "2mL Tube"],
            Amount -> 0.5 Milliliter
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ]

  },
  TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),

  SymbolSetUp :> Block[{$DeveloperUpload = True},
    Module[{objects, existsFilter, tube0, tube1, tube2, tube3, tube4, tube5, tube6, plate0, sample0, sample1, sample2, sample3, sample4, sample5, sample6, method0, testBench},
      $CreatedObjects={};

      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      objects={
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample in sterile DWP (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension insect cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],

        Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ExperimentLyseCells) "<>$SessionUUID],

        Object[Container, Vessel, "Test 2mL Tube 0 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 3 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 4 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 5 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Plate, "Test DWP plate 0 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 6 for ExperimentLyseCells "<>$SessionUUID],

        Object[Container, Bench, "Test bench for ExperimentLyseCells tests" <> $SessionUUID]

      };
      existsFilter = DatabaseMemberQ[objects];

      EraseObject[
        PickList[
          objects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ];

      testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentLyseCells tests" <> $SessionUUID, Site -> Link[$Site]|>];

      {tube0, tube1, tube2, tube3, tube4, tube5, plate0, tube6} = UploadSample[
        {
          Model[Container, Vessel, "2mL Tube"],
          Model[Container, Vessel, "2mL Tube"],
          Model[Container, Vessel, "2mL Tube"],
          Model[Container, Vessel, "2mL Tube"],
          Model[Container, Vessel, "2mL Tube"],
          Model[Container, Vessel, "2mL Tube"],
          Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
          Model[Container, Vessel, "2mL Tube"]
        },
        {
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench}
        },
        Name -> {
          "Test 2mL Tube 0 for ExperimentLyseCells "<>$SessionUUID,
          "Test 2mL Tube 1 for ExperimentLyseCells "<>$SessionUUID,
          "Test 2mL Tube 2 for ExperimentLyseCells "<>$SessionUUID,
          "Test 2mL Tube 3 for ExperimentLyseCells "<>$SessionUUID,
          "Test 2mL Tube 4 for ExperimentLyseCells "<>$SessionUUID,
          "Test 2mL Tube 5 for ExperimentLyseCells "<>$SessionUUID,
          "Test DWP plate 0 for ExperimentLyseCells "<>$SessionUUID,
          "Test 2mL Tube 6 for ExperimentLyseCells "<>$SessionUUID
        },
        FastTrack -> True
      ];

      (* Create some samples for testing purposes *)
      {sample0, sample1, sample2, sample3, sample4, sample5, plate0, sample6} = UploadSample[
        (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
        {
          {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
          {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
          {{100 MassPercent, Model[Cell, Yeast, "Pichia Pastoris"]}},
          {{10^10 EmeraldCell/Milliliter, Model[Cell, Mammalian, "HEK293"]}},
          {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
          {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
          {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
          {{100 MassPercent, Model[Cell, Mammalian, "Insect Cell Sf9"]}}
        },
        {
          {"A1", tube0},
          {"A1", tube1},
          {"A1", tube2},
          {"A1", tube3},
          {"A1", tube4},
          {"A1", tube5},
          {"A1", plate0},
          {"A1", tube6}
        },
        Name -> {
          "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID,
          "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID,
          "Adherent yeast cell sample (Test for ExperimentLyseCells) "<>$SessionUUID,
          "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID,
          "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCells) "<>$SessionUUID,
          "Adherent cell sample without information in CellType field (Test for ExperimentLyseCells) "<>$SessionUUID,
          "Suspension mammalian cell sample in sterile DWP (Test for ExperimentLyseCells) "<>$SessionUUID,
          "Suspension insect cell sample (Test for ExperimentLyseCells) "<>$SessionUUID
        },
        InitialAmount -> {
          0.5 Milliliter,
          0.5 Milliliter,
          0.5 Milliliter,
          0.5 Milliliter,
          0.5 Milliliter,
          0.5 Milliliter,
          0.5 Milliliter,
          0.5 Milliliter
        },
        CellType -> {
          Mammalian,
          Mammalian,
          Yeast,
          Mammalian,
          Mammalian,
          Null,
          Mammalian,
          Insect
        },
        CultureAdhesion -> {
          Adherent,
          Suspension,
          Adherent,
          Suspension,
          Null,
          Adherent,
          Suspension,
          Suspension
        },
        Living -> {
          True,
          True,
          True,
          True,
          True,
          True,
          True,
          True
        },
        State -> Liquid,
        FastTrack -> True
      ];

      method0 = Upload[
        <|
          Type -> Object[Method, LyseCells],
          Name -> "Mammalian protein Lysis Method (Test for ExperimentLyseCells) "<>$SessionUUID,
          CellType -> Mammalian,
          TargetCellularComponent -> CytosolicProtein,
          LysisSolution -> Link[Model[Sample, StockSolution, "id:7X104vK9ZlWZ"]],
          MixType -> Shake
        |>
      ]

    ]
  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample in sterile DWP (Test for ExperimentLyseCells) "<>$SessionUUID],
        Object[Sample, "Suspension insect cell sample (Test for ExperimentLyseCells) "<>$SessionUUID],

        Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ExperimentLyseCells) "<>$SessionUUID],

        Object[Container, Vessel, "Test 2mL Tube 0 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 3 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 4 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 5 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Plate, "Test DWP plate 0 for ExperimentLyseCells "<>$SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 6 for ExperimentLyseCells "<>$SessionUUID],

        Object[Container, Bench, "Test bench for ExperimentLyseCells tests" <> $SessionUUID]

      }], ObjectP[]];

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
  ),
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  },
  Parallel -> True
];

DefineTests[LyseCells,
  {
    Example[{Basic,"Generate a LyseCells unit operation:"},
      LyseCells[
        Sample -> Object[Sample, "Suspension mammalian cell sample (Test for LyseCells unit operation) " <> $SessionUUID]
      ],
      _LyseCells
    ]
  },
  TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
  SymbolSetUp :> Module[{existsFilter, sample0, tube0},
    $CreatedObjects = {};

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter = DatabaseMemberQ[{
      Object[Sample, "Suspension mammalian cell sample (Test for LyseCells unit operation) "<> $SessionUUID],
      Object[Container, Vessel, "Test 2mL Tube 0 for LyseCells unit operation "<> $SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for LyseCells unit operation) "<> $SessionUUID],
          Object[Container, Vessel, "Test 2mL Tube 0 for LyseCells unit operation "<> $SessionUUID]
        },
        existsFilter
      ],
      Force -> True,
      Verbose -> False
    ];

    tube0 = Upload[
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
        Name -> "Test 2mL Tube 0 for LyseCells unit operation "<> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    ];

    (* Create a sample for testing purposes *)
    sample0 = UploadSample[
      {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
      {"A1", tube0},
      Name -> "Suspension mammalian cell sample (Test for LyseCells unit operation) " <> $SessionUUID,
      InitialAmount -> 0.5 Milliliter,
      Living -> True,
      State -> Liquid,
      FastTrack -> True,
      StorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"]
    ];

    (* Make some changes to our sample for testing purposes *)
    Upload[
      <|
        Object -> sample0,
        Status -> Available,
        DeveloperObject -> True
      |>
    ]
  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects,existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample, "Suspension mammalian cell sample (Test for LyseCells unit operation) " <> $SessionUUID],
        Object[Container, Vessel, "Test 2mL Tube 0 for LyseCells unit operation "<> $SessionUUID]
      }],
        ObjectP[]
      ];

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