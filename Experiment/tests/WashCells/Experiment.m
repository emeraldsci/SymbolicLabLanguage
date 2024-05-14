(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(* Helper Functions *)

SetUpWashCellsChangeMediaTest[myFunction : ExperimentWashCells | ExperimentChangeMedia | WashCells | ChangeMedia] := Module[{existsFilter, plate0, tube0, plate1, plate2, standardCurve0, cell0, cell1, sample0, sample1, sample2, sample3, method0},
  $CreatedObjects = {};

  Off[Warning::SamplesOutOfStock];
  Off[Warning::InstrumentUndergoingMaintenance];
  Off[Warning::DeprecatedProduct];

  (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
  (* Erase any objects that we failed to erase in the last unit test. *)
  existsFilter = DatabaseMemberQ[{
    Object[Sample, "Adherent mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
    Object[Sample, "Suspension mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
    Object[Sample, "Adherent yeast cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
    Object[Sample, "Suspension Bacterial cell sample in plate (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

    Object[Analysis, Fit, "Test Fit 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Model[Cell, Bacteria, "Test Cell 1 with no StandardCurve (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

    Object[Container, Plate, "Test mammalian plate 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Object[Container, Vessel, "Test mammalian 50mL Tube 0 for " <> ToString[myFunction] <> " " <> $SessionUUID],
    Object[Container, Plate, "Test yeast plate 1 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Object[Container, Plate, "Test bacterial plate 2 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

    Object[Method, WashCells, "Mammalian cell washing Method (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID]

  }];

  EraseObject[
    PickList[
      {
        Object[Sample, "Adherent mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
        Object[Sample, "Suspension mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
        Object[Sample, "Adherent yeast cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
        Object[Sample, "Suspension Bacterial cell sample in plate (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

        Object[Analysis, Fit, "Test Fit 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
        Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
        Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
        Model[Cell, Bacteria, "Test Cell 1 with no StandardCurve (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

        Object[Container, Plate, "Test mammalian plate 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
        Object[Container, Vessel, "Test mammalian 50mL Tube 0 for " <> ToString[myFunction] <> " " <> $SessionUUID],
        Object[Container, Plate, "Test yeast plate 1 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
        Object[Container, Plate, "Test bacterial plate 2 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

        Object[Method, WashCells, "Mammalian cell washing Method (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID]

      },
      existsFilter
    ],
    Force -> True,
    Verbose -> False
  ];

  {plate0, tube0, plate1, plate2} = Upload[{

    <|
      Type -> Object[Container, Plate],
      Model -> Link[Model[Container, Plate, "id:L8kPEjkmLbvW"], Objects], (* "96-well 2mL Deep Well Plate" *)
      Name -> "Test mammalian plate 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID,
      Site -> Link[$Site],
      DeveloperObject -> True
    |>,
    <|
      Type -> Object[Container, Vessel],
      Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects], (* "50 mL Tube" *)
      Name -> "Test mammalian 50mL Tube 0 for " <> ToString[myFunction] <> " " <> $SessionUUID,
      Site -> Link[$Site],
      DeveloperObject -> True
    |>,
    <|
      Type -> Object[Container, Plate],
      Model -> Link[Model[Container, Plate, "id:L8kPEjkmLbvW"], Objects], (* "96-well 2mL Deep Well Plate" *)
      (* Model -> Link[Model[Container, Plate, "id:qdkmxzkKwn11"], Objects], 24-well V-bottom 10 mL Deep Well Plate Sterile *)
      Name -> "Test yeast plate 1 (for " <> ToString[myFunction] <> ")" <> $SessionUUID,
      Site -> Link[$Site],
      DeveloperObject -> True
    |>,
    <|
      Type -> Object[Container, Plate],
      Model -> Link[Model[Container, Plate, "id:L8kPEjkmLbvW"], Objects], (* "96-well 2mL Deep Well Plate" *)
      (* Model -> Link[Model[Container, Plate, "id:qdkmxzkKwn11"], Objects], 24-well V-bottom 10 mL Deep Well Plate Sterile *)
      Name -> "Test bacterial plate 2 (for " <> ToString[myFunction] <> ")" <> $SessionUUID,
      Site -> Link[$Site],
      DeveloperObject -> True
    |>
  }];

  (* Create a test Object[Analysis,Fit] for inverse prediction *)
  AnalyzeFit[
    {{1 EmeraldCell / Milliliter, 1 OD600}, {10 EmeraldCell / Milliliter, 10 OD600}, {100 EmeraldCell / Milliliter, 100 OD600}},
    Linear,
    Name -> "Test Fit 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID];

  (* Make sure the fit object is a developer object *)
  Upload[<|
      Object -> Object[Analysis, Fit, "Test Fit 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
      DeveloperObject -> True
    |>];

  {standardCurve0} = Upload[{
    <|
      Type -> Object[Analysis, StandardCurve],
      Name -> "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID,
      Replace[StandardDataUnits] -> {Cell / Milliliter, OD600},
      BestFitFunction -> QuantityFunction[#1 &, Cell / Milliliter, OD600],
      StandardCurveFit -> Link[Object[Analysis, Fit, "Test Fit 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID]],
      InversePrediction -> True,
      DeveloperObject -> True
    |>
  }];

  {cell0, cell1} = Upload[{
    <|
      Type -> Model[Cell, Bacteria],
      Name -> "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID,
      CellType -> Bacterial,
      CultureAdhesion -> Suspension,
      PreferredLiquidMedia -> Link[Model[Sample, Media, "id:jLq9jXqbAn9E"], CellTypes], (* Model[Sample, Media, "LB (Liquid)"] *)
      Replace[StandardCurves] -> {Link[Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID]]}
    |>,
    <|
      Type -> Model[Cell, Bacteria],
      Name -> "Test Cell 1 with no StandardCurve (for " <> ToString[myFunction] <> ")" <> $SessionUUID,
      CellType -> Bacterial,
      CultureAdhesion -> Suspension
    |>
  }];

  (* Create some samples for testing purposes *)
  {sample0, sample1, sample2, sample3} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{50 OD600, Model[Cell, Mammalian, "HEK293"]}},
        {{10^10 EmeraldCell / Milliliter, Model[Cell, Mammalian, "HEK293"]}},
        {{30 EmeraldCell / Milliliter, Model[Cell, Yeast, "Pichia Pastoris"]}},
        {
          {4.5 Gram / Liter, Link[Model[Molecule, "id:dORYzZJ3l38e"]]},
          {30 Cell / Milliliter, Link[Model[Cell, Bacteria, "Test Cell 1 with no StandardCurve (for " <> ToString[myFunction] <> ")" <> $SessionUUID]]},
          {50 OD600, Link[Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID]]}
        }
      },
      {
        {"A1", plate0},
        {"A1", tube0},
        {"A1", plate1},
        {"A1", plate2}
      },
      Name -> {
        "Adherent mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID,
        "Suspension mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID,
        "Adherent yeast cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID,
        "Suspension Bacterial cell sample in plate (for " <> ToString[myFunction] <> ")" <> $SessionUUID
      },
      InitialAmount -> {
        1.5 Milliliter,
        1 Milliliter,
        2 Milliliter,
        2 Milliliter
      },
      CellType -> {
        Mammalian,
        Mammalian,
        Yeast,
        Bacterial
      },
      CultureAdhesion -> {
        Adherent,
        Suspension,
        Adherent,
        Suspension
      },
      Living -> {
        True,
        True,
        True,
        True
      },
      State -> Liquid,
      FastTrack -> True
    ];

  {method0} = Upload[
    {
      <|
        Type -> Object[Method, WashCells],
        Name -> "Mammalian cell washing Method (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID,
        CultureAdhesion -> Suspension,
        NumberOfWashes -> 1,
        CellIsolationTechnique -> Pellet,
        CellIsolationInstrument -> Link[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]],
        CellIsolationTime -> 5 Minute,
        CellPelletIntensity -> 2000 RPM,
        WashMixType -> Shake,
        WashMixRate -> 200 RPM,
        WashMixTime -> 1 Minute,
        WashMixInstrument -> Link[Model[Instrument, Shaker, "Inheco ThermoshakeAC"]],
        WashTemperature -> 20 Celsius,
        WashIsolationTime -> 5 Minute,
        WashPelletIntensity -> 2000 RPM,
        AliquotSourceMedia -> False,
        ResuspensionMedia -> None,
        ResuspensionMedia -> Link[Model[Sample, Media, "id:jLq9jXqbAn9E"]],
        ResuspensionMixType -> None,
        ReplateCells -> False
      |>
    }
  ]

];
TearDownWashCellsChangeMediaTest[myFunction : ExperimentWashCells | ExperimentChangeMedia | WashCells | ChangeMedia] := Module[{allObjects, existsFilter},

  (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
  allObjects = Cases[Flatten[{
    Object[Sample, "Adherent mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
    Object[Sample, "Suspension mammalian cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
    Object[Sample, "Adherent yeast cell sample (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID],
    Object[Sample, "Suspension Bacterial cell sample in plate (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

    Object[Analysis, Fit, "Test Fit 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Model[Cell, Bacteria, "Test Cell 1 with no StandardCurve (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

    Object[Container, Plate, "Test mammalian plate 0 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Object[Container, Vessel, "Test mammalian 50mL Tube 0 for " <> ToString[myFunction] <> " " <> $SessionUUID],
    Object[Container, Plate, "Test yeast plate 1 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],
    Object[Container, Plate, "Test bacterial plate 2 (for " <> ToString[myFunction] <> ")" <> $SessionUUID],

    Object[Method, WashCells, "Mammalian cell washing Method (Test for " <> ToString[myFunction] <> ") " <> $SessionUUID]


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
];

(* ::Title:: *)
(*ExperimentWashCells: Tests*)
DefineTests[ExperimentWashCells,
  {
    (* - Basic Examples - *)
    Example[{Basic, "Wash cells within a sample:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]]
      },
      TimeConstraint -> 6000
    ],
    Example[{Basic, "Wash cells within several samples:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]]
      },
      TimeConstraint -> 6000
    ],

    (* - Options  - *)
    Example[{Options, WorkCell, "If the input sample contains cells only Mammalian cells, then the bioSTAR is the WorkCell of cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WorkCell -> bioSTAR
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WorkCell, "If the input sample contains cells other than Mammalian cells, then the microbioSTAR is the WorkCell of cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WorkCell -> microbioSTAR
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, RoboticInstrument, "If the input sample contains only Mammalian cells, then the bioSTAR liquid handler is used for the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          RoboticInstrument -> Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"] (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, RoboticInstrument, "If the input sample contains cells other than Mammalian cells, then the microbioSTAR liquid handler is used for the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          RoboticInstrument -> Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"] (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, Method, "A Method containing a pre-set procedure for washing cells can be specified:"},
      ExperimentWashCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        Method -> Object[Method, WashCells, "Mammalian cell washing Method (Test for ExperimentWashCells) " <> $SessionUUID],
        CellAspirationVolume -> {0.9 Milliliter},
        WashAspirationVolume -> {0.9 Milliliter},
        Output -> {Result, Options}
      ],
      {ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CultureAdhesion -> Suspension,
          NumberOfWashes -> 1,
          CellIsolationTechnique -> Pellet,
          WashMixType -> Shake,
          WashTemperature -> EqualP[20 Celsius],
          CellIsolationTime -> EqualP[5 Minute],
          CellPelletIntensity -> EqualP[2000 RPM],
          WashMixTime -> EqualP[1 Minute],
          WashMixRate -> EqualP[200 RPM],
          CellIsolationInstrument -> ObjectP[],
          WashMixInstrument -> ObjectP[],
          ResuspensionMedia -> ObjectP[],
          ResuspensionMixType -> None,
          ReplateCells -> False
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, CellType, "If CellType is not specified for the wash cell experiment, it will be set as the CellType of sample object:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellType -> {
          Bacterial,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellType -> {
            Bacterial,
            Yeast
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    (* We expect adherent cells come in plates. *)
    Example[{Options, CultureAdhesion, "If CultureAdhesion is not specified for the wash cell experiment, it will be set as the CultureAdhesion of sample object:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationVolume -> {0.9 Milliliter, Automatic},
        WashAspirationVolume -> {0.9 Milliliter, Automatic},
        CultureAdhesion -> {
          Adherent,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CultureAdhesion -> {
            Adherent,
            Adherent
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, CellIsolationTechnique, "If CellIsolationTechnique is not specified for the wash cell experiment, Adherent cells will have CellIsolationTechnique set as Aspirate, other cells will have CellIsolationTechnique set as Pellet:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter},
        CellIsolationTechnique -> {
          Automatic,
          Automatic,
          Pellet
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellIsolationTechnique -> {
            Aspirate,
            Pellet,
            Pellet
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, CellIsolationInstrument, "If CellIsolationTechnique is Pellet, CellIsolationInstrument will be automatically set to Model[Instrument, Centrifuge, \"HiG4\]; If CellIsolationTechnique is Aspirate, no CellIsolationInstrument is needed:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter},
        CellIsolationTechnique -> {
          Aspirate,
          Automatic,
          Pellet
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellIsolationInstrument -> {
            Null,
            ObjectP[],
            ObjectP[]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, NumberOfWashes, "If NumberOfWashes is not specified, adherent cells will be washed for 3 times and suspension cells will be washed for 2 times:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        NumberOfWashes -> {
          Automatic,
          Automatic,
          4
        },

        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfWashes -> {
            3,
            2,
            4
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, NumberOfWashes, "If NumberOfWashes is 0, all the Washing Options are Null:"},
      ExperimentWashCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        NumberOfWashes -> 0,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashSolution -> Null,
          WashSolutionTemperature -> Null,
          WashSolutionEquilibrationTime -> Null,
          WashVolume -> Null,
          WashMixType -> Null,
          WashMixInstrument -> Null,
          WashMixTime -> Null,
          WashMixRate -> Null,
          NumberOfWashMixes -> Null,
          WashMixVolume -> Null,
          WashTemperature -> Null,
          WashAspirationVolume -> Null,
          WashIsolationTime -> Null,
          WashPelletIntensity -> Null,
          WashAspirationAngle -> Null}]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, CellAspirationVolume, "If CellAspirationVolume is not specified, it will be set to be all the liquid for adherent cells and 85% of the sample volume for suspension cells:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationVolume -> {
          Automatic,
          Automatic,
          1.6 Milliliter
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellAspirationVolume -> {
            All,
            EqualP[0.85 Milliliter],
            EqualP[1.6 Milliliter]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, CellIsolationTime, "If CellIsolationTime is not specified, it will be set to be 10 Minute when CellIsolationTechnique is Pellet:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellIsolationTime -> {
          Automatic,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellIsolationTime -> {
            Null,
            EqualP[10 Minute]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, CellPelletIntensity, "If CellIsolationTechnique is Pellet and CellPelletIntensity is not specified, CellPelletIntensity will be set based on the CellType, which is 300 g for Mammalian, 1000 g for Yeast, 2000 g for Bacterial:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID]
        },
        CellAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter, 0.9 Milliliter},
        WashAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter, 0.9 Milliliter},
        CellIsolationTechnique -> {
          Automatic,
          Automatic,
          Pellet,
          Automatic
        },
        CellPelletIntensity -> {
          Automatic,
          3000 RPM,
          Automatic,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellPelletIntensity -> {
            Null,
            EqualP[3000 RPM],
            EqualP[1560 RPM],
            EqualP[4030 RPM]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, CellAspirationAngle, "If CellIsolationTechnique is Aspirate and CellAspirationAngle is not specified, it will be set to be the max aspirate angle for the robotic instrument:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationAngle -> {
          Automatic,
          Automatic,
          6 AngularDegree
        },

        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          CellAspirationAngle -> {
            EqualP[$MaxRoboticAspirationAngle], (* 10 AngularDegree *)
            Null,
            EqualP[6 AngularDegree]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, AliquotSourceMedia, "If any of aliquot source media options (AliquotMediaLabel, AliquotMediaContainer, AliquotMediaContainerLabel, AliquotMediaVolume, AliquotMediaStorageCondition) is specified, AliquotSourceMedia will be set to be True:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID]
        },
        AliquotMediaVolume -> {
          Automatic,
          0.5 Milliliter,
          Automatic
        },
        AliquotMediaLabel -> {
          "my sample",
          Automatic,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotSourceMedia -> {
            True,
            True,
            False
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, AliquotSourceMedia, "If AliquotSourceMedia is False, all the AliquotSourceMediaOptions are Null for the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotMediaVolume -> Null,
          AliquotMediaContainer -> Null,
          AliquotMediaContainerLabel -> Null,
          AliquotMediaStorageCondition -> Null,
          AliquotMediaLabel -> Null
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, AliquotMediaLabel, "If AliquotSourceMedia is True, will automatically create an AliquotMediaLabel if it is not sepcified:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID]
        },
        CellAspirationVolume -> {Automatic, 0.9 Milliliter},
        WashAspirationVolume -> {Automatic, 0.9 Milliliter},
        AliquotSourceMedia -> True,
        AliquotMediaLabel -> {
          "my media label",
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotMediaLabel -> {
            "my media label",
            _String
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, AliquotMediaVolume, "If AliquotSourceMedia is True, will automatically set AliquotMediaVolume to be the same as CellAspirationVolume"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        AliquotSourceMedia -> True,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotMediaVolume -> {
            EqualP[1.5 Milliliter],
            EqualP[0.85 Milliliter]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, AliquotMediaStorageCondition, "If AliquotSourceMedia is True, will automatically set AliquotMediaStorageCondition to be Freezer"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        AliquotSourceMedia -> True,
        AliquotMediaStorageCondition -> {
          Disposal,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          AliquotMediaStorageCondition -> {
            Disposal,
            Freezer
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashSolution, "If NumberOfWashes is not 0 and WashSolution is not specified in wash cells experiment, it will be set to PBS buffer:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashSolution -> Model[Sample, StockSolution, "id:9RdZXv1KejGK"]
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashSolutionTemperature, "If not specified, use Ambient as WashSolutionTemperature for the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID]
        },
        CellAspirationVolume -> {0.9 Milliliter},
        WashAspirationVolume -> {0.9 Milliliter},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashSolutionTemperature -> AmbientTemperatureP
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashSolutionEquilibrationTime, "WashSolutionEquilibrationTime will be set to be 10 Minute if not specified:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashSolutionEquilibrationTime -> EqualP[10 Minute]
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashVolume, "WashVolume is set to be the same as CellAspirationVolume if not specified in the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationVolume -> 1.2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashVolume -> EqualP[1.2 Milliliter]
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashMixType, "If WashMixType is None, all the Washing Mixing Options are Null:"},
      ExperimentWashCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        WashMixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashMixInstrument -> Null,
          WashMixTime -> Null,
          WashMixRate -> Null,
          NumberOfWashMixes -> Null,
          WashMixVolume -> Null,
          WashTemperature -> Null}]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashMixType, "If WashMixType is Pipette, all the WashShakeOptions are Null:"},
      ExperimentWashCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        WashMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashMixInstrument -> Null,
          WashMixTime -> Null,
          WashMixRate -> Null,
          WashTemperature -> Null}]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashMixType, "If WashMixType is Shake, all the WashPipetteOptions are Null:"},
      ExperimentWashCells[
        Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID],
        CellAspirationVolume -> {0.9 Milliliter},
        WashAspirationVolume -> {0.9 Milliliter},
        WashMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfWashMixes -> Null,
          WashMixVolume -> Null}]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashMixType, "If any of the Shake options are specified, WashMixType will be set Shake; if any of the Pipette options are specified, WashMixType will be set Pipette:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        NumberOfWashMixes -> {
          Automatic,
          4
        },
        WashMixTime -> {
          4 Minute,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashMixType -> {
            Shake,
            Pipette
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashMixInstrument, "If WashMixType is Shake, WashMixInstrument will be automatically set to be Inheco ThermoshakeAC:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashMixInstrument -> {
            Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
            Null
          }
        }]
      },
      TimeConstraint -> 6000
    ],
    (*Friday*)
    Example[{Options, WashMixRate, "If WashMixType is Shake, WashMixRate will be automatically set to be 200 RPM:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashMixRate -> {
            200 RPM,
            Null
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashMixTime, "If WashMixType is Shake, WashMixTime will be automatically set to be 1 Minute:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashMixTime -> {
            1 Minute,
            Null
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashMixVolume, "If WashMixType is Pipette, WashMixVolume will be automatically set to be the lesser of the max single transfer volume (970 Microliter) or 50% of the WashVolume:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        WashMixType -> {
          Automatic,
          Automatic,
          Pipette
        },
        WashVolume -> {
          Automatic,
          0.8 Milliliter,
          2 Milliliter
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashMixVolume -> {
            Null,
            0.4 Milliliter,
            $MaxRoboticSingleTransferVolume
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, NumberOfWashMixes, "If WashMixType is Pipette, NumberOfWashMixes will be automatically set to be the lesser of 50 or 5 * WashVolume/WashMixVolume:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        WashMixType -> {
          Automatic,
          Automatic,
          Pipette
        },
        WashVolume -> {
          Automatic,
          0.8 Milliliter,
          2 Milliliter
        },
        WashMixVolume -> {
          Automatic,
          Automatic,
          0.01 Milliliter
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfWashMixes -> {
            Null,
            10,
            50
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashTemperature, "If WashMixType is Shake, WashTemperature will be automatically set to be the same as WashSolutionTemperature:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        WashTemperature -> {
          5 Celsius,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashTemperature -> {
            EqualP[5 Celsius],
            AmbientTemperatureP
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashAspirationVolume, "WashAspirationVolume is set to be the same as WashVolume if not specified in the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        WashVolume -> 2 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashAspirationVolume -> EqualP[2 Milliliter]
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashIsolationTime, "If WashIsolationTime is not specified, it will be set to be the same as CellIsolationTime when CellIsolationTechnique is Pellet and NumberOfWashes is not 0:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        WashIsolationTime -> {
          Automatic,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashIsolationTime -> {
            Null,
            EqualP[10 Minute]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashPelletIntensity, "If CellIsolationTechnique is Pellet and WashPelletIntensity is not specified,  it will be set to be the same as CellPelletIntensity if NumberOfWashes is not 0:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID]
        },
        CellAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter, 0.9 Milliliter},
        WashAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter, 0.9 Milliliter},
        CellIsolationTechnique -> {
          Automatic,
          Automatic,
          Pellet,
          Automatic
        },
        CellPelletIntensity -> {
          Automatic,
          3000 RPM,
          Automatic,
          Automatic
        },
        WashPelletIntensity -> {
          Automatic,
          2000 RPM,
          Automatic,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashPelletIntensity -> {
            Null,
            EqualP[2000 RPM],
            EqualP[1560 RPM],
            EqualP[4030 RPM]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, WashAspirationAngle, "If CellIsolationTechnique is Aspirate and WashAspirationAngle is not specified, it will be set to be the same as CellAspirationAngle:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationAngle -> {
          Automatic,
          Automatic,
          6 AngularDegree
        },

        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          WashAspirationAngle -> {
            EqualP[$MaxRoboticAspirationAngle], (* 10 AngularDegree *)
            Null,
            EqualP[6 AngularDegree]
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMedia, "If ResuspensionMedia is None, all the Media Replenishment Options are Null in the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID]
        },
        CellAspirationVolume -> {0.9 Milliliter},
        WashAspirationVolume -> {0.9 Milliliter},
        ResuspensionMedia -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMediaTemperature -> Null,
          ResuspensionMediaEquilibrationTime -> Null,
          ResuspensionMediaVolume -> Null,
          ResuspensionMixType -> Null,
          ResuspensionTemperature -> Null,
          ResuspensionMixInstrument -> Null,
          ResuspensionMixTime -> Null,
          ResuspensionMixRate -> Null,
          NumberOfResuspensionMixes -> Null,
          ResuspensionMixVolume -> Null,
          ReplateCells -> Null
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMediaTemperature, "If not specified, use Ambient as ResuspensionMediaTemperature for the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMediaTemperature -> AmbientTemperatureP
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMediaEquilibrationTime, "ResuspensionMediaEquilibrationTime will be set to be 10 Minute if not specified:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMediaEquilibrationTime -> EqualP[10 Minute]
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMediaVolume, "ResuspensionMediaVolume is calculated based on the sample volume, container max volume and WashAspirationVolume in the cell washing experiment:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationVolume -> 0.7 Milliliter,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMediaVolume -> EqualP[1.3 Milliliter]
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMixType, "If ResuspensionMixType is None, all the Resuspension Mixing Options are Null:"},
      ExperimentWashCells[
        Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        ResuspensionMixType -> None,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMixInstrument -> Null,
          ResuspensionMixTime -> Null,
          ResuspensionMixRate -> Null,
          NumberOfResuspensionMixes -> Null,
          ResuspensionMixVolume -> Null,
          ResuspensionTemperature -> Null}]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMixType, "If ResuspensionMixType is Pipette, all the ResuspensionShakeOptions are Null:"},
      ExperimentWashCells[
        Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        ResuspensionMixType -> Pipette,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMixInstrument -> Null,
          ResuspensionMixTime -> Null,
          ResuspensionMixRate -> Null,
          ResuspensionTemperature -> Null}]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMixType, "If ResuspensionMixType is Shake, all the ResuspensionPipetteOptions are Null:"},
      ExperimentWashCells[
        Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        ResuspensionMixType -> Shake,
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfResuspensionMixes -> Null,
          ResuspensionMixVolume -> Null}]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMixInstrument, "If ResuspensionMixType is Shake, ResuspensionMixInstrument will be automatically set to be Inheco ThermoshakeAC:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMixInstrument -> {
            Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
            Null
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMixRate, "If ResuspensionMixType is Shake, ResuspensionMixRate will be automatically set to be 200 RPM:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMixRate -> {
            200 RPM,
            Null
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMixTime, "If ResuspensionMixType is Shake, ResuspensionMixTime will be automatically set to be 1 Minute:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMixTime -> {
            1 Minute,
            Null
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionMixVolume, "If ResuspensionMixType is Pipette, ResuspensionMixVolume will be automatically set to be the lesser of the max single transfer volume (970 Microliter) or 50% of the ResuspensionMediaVolume:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        ResuspensionMixType -> {
          Automatic,
          Automatic,
          Pipette
        },
        ResuspensionMediaVolume -> {
          Automatic,
          1 Milliliter,
          2 Milliliter
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionMixVolume -> {
            Null,
            0.5 Milliliter,
            $MaxRoboticSingleTransferVolume
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, NumberOfResuspensionMixes, "If ResuspensionMixType is Pipette, NumberOfResuspensionMixes will be automatically set to be the lesser of 50 or 5 * ResuspensionMediaVolume/ResuspensionMixVolume:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        ResuspensionMixType -> {
          Automatic,
          Automatic,
          Pipette
        },
        ResuspensionMediaVolume -> {
          Automatic,
          1 Milliliter,
          2 Milliliter
        },
        ResuspensionMixVolume -> {
          Automatic,
          Automatic,
          0.01 Milliliter
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          NumberOfResuspensionMixes -> {
            Null,
            10,
            50
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ResuspensionTemperature, "If ResuspensionMixType is Shake, ResuspensionTemperature will be automatically set to be the same as ResuspensionMediaTemperature:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        ResuspensionTemperature -> {
          5 Celsius,
          Automatic
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ResuspensionTemperature -> {
            EqualP[5 Celsius],
            AmbientTemperatureP
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    Example[{Options, ReplateCells, "ReplateCells will be automatically set True if ResuspensionMedia is no None and CultureAdhesion is Suspension:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Suspension Bacterial cell sample in plate (for ExperimentWashCells)" <> $SessionUUID]
        },
        CellAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter},
        WashAspirationVolume -> {Automatic, Automatic, 0.9 Milliliter},
        ResuspensionMedia -> {
          Automatic,
          Automatic,
          None
        },
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
        KeyValuePattern[{
          ReplateCells -> {
            True,
            False,
            Null
          }
        }]
      },
      TimeConstraint -> 6000
    ],

    (* Shared Options *)
    Example[{Options, Output, "If Output is Tests, all the EmeraldTest will be returned in a list:"},
      {result, options, tests} = ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Output -> {Result, Options, Tests}
      ];
      MatchQ[
        {result, options, tests},
        {
          ObjectP[Object[Protocol, RoboticCellPreparation]],
          {_Rule..},
          {_EmeraldTest..}
        }
      ],
      True,
      Variables :> {result, options, tests},
      TimeConstraint -> 6000
    ],

    Example[{Options, Output, "Create a simulation protocol for the given samples when Output->Simulation:"},
      ExperimentWashCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        Output -> Simulation
      ],
      SimulationP,
      TimeConstraint -> 6000
    ],

    Example[{Options, Upload, "Specify indicates if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
      packets = ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Upload -> False
      ];
      MatchQ[
        packets,
        ListableP[PacketP[]]
      ],
      True,
      Variables :> {packets},
      TimeConstraint -> 6000
    ],

    Example[{Options, Name, "Name of the output protocol object can be specified:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        Name -> "ExperimentWashCells name test protocol" <> $SessionUUID
      ],
      Object[Protocol, RoboticCellPreparation, "ExperimentWashCells name test protocol" <> $SessionUUID],
      TimeConstraint -> 6000
    ],

    Example[{Options, Priority, "Specify indicates if (for an additional cost) this protocol will have first rights to shared lab resources before any standard protocols:"},
      Download[
        ExperimentWashCells[
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Priority -> False
        ],
        Priority
      ],
      False,
      TimeConstraint -> 6000
    ],

    Example[{Options, ParentProtocol, "Specify the protocol which is directly generating this experiment during execution:"},
      Download[
        ExperimentWashCells[
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          ParentProtocol -> Object[Protocol, SampleManipulation, "Example Transfer Protocol"]
        ],
        ParentProtocol
      ],
      ObjectP[Object[Protocol]],
      TimeConstraint -> 6000
    ],

    Example[{Options, FastTrack, "Specify indicates if validity checks on the provided input and options should be skipped for faster performance:"},
      ExperimentWashCells[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        FastTrack -> True
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 6000
    ],

    Example[{Options, Cache, "Specify list of pre-downloaded packets to be used before checking for session cached object or downloading any object information from the server:"},
      ExperimentWashCells[{
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
        Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
      },
        Cache -> {}
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 6000
    ],

    Example[{Options, Confirm, "Directly confirms a protocol into the operations queue:"},
      Download[
        ExperimentWashCells[
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
          Confirm -> True
        ],
        Status
      ],
      Processing | ShippingMaterials | Backlogged,
      TimeConstraint -> 6000
    ],

    (* - Messages  - *)

    Example[{Messages, "ExtraneousWashingOptions", "If NumberOfWashes is 0 and any of the wash options are specified, an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        NumberOfWashes -> 0,
        WashAspirationVolume -> 0.05 Milliliter
      ],
      $Failed,
      Messages :> {
        Error::ExtraneousWashingOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ExtraneousMediaReplenishmentOptions", "If ResuspensionMedia is None and any of the resuspension options are specified, an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        ResuspensionMedia -> None,
        ResuspensionMediaTemperature -> 20 Celsius
      ],
      $Failed,
      Messages :> {
        Error::ExtraneousMediaReplenishmentOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "CellIsolationTechniqueConflictingOptions", "If CellIsolationTechnique and the given cell isolation options do not match, an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellIsolationTechnique -> Pellet,
        CellAspirationAngle -> 10 AngularDegree
      ],
      $Failed,
      Messages :> {
        Error::CellIsolationTechniqueConflictingOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "WashIsolationTechniqueConflictingOptions", "If CellIsolationTechnique and the given wash isolation options do not match, an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellIsolationTechnique -> Aspirate,
        WashIsolationTime -> 5 Minute
      ],
      $Failed,
      Messages :> {
        Error::WashIsolationTechniqueConflictingOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "WashMixTypeConflictingOptions", "If WashMixType and the given wash mix options do not match, an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        WashMixType -> Shake,
        NumberOfWashMixes -> 5
      ],
      $Failed,
      Messages :> {
        Error::WashMixTypeConflictingOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ResuspensionMixTypeConflictingOptions", "If ResuspensionMixType and the given resuspension mix options do not match, an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        ResuspensionMixType -> Pipette,
        ResuspensionTemperature -> 20 Celsius
      ],
      $Failed,
      Messages :> {
        Error::ResuspensionMixTypeConflictingOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ReplateCellsConflictingOption", "If ReplateCells set True for adherent cells, an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        ReplateCells -> True
      ],
      $Failed,
      Messages :> {
        Error::ReplateCellsConflictingOption,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "AspirationVolumeConflictingOption", "If aspiration volume exceeds the amount of current volume , an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        CellAspirationVolume -> 1.8 Milliliter
      ],
      $Failed,
      Messages :> {
        Error::AspirationVolumeConflictingOption,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TotalVolumeConflictingOption", "If addition of volume causes the total volume exceeds the container max volume , an error is thrown:"},
      ExperimentWashCells[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
        },
        WashVolume -> 20 Milliliter
      ],
      $Failed,
      Messages :> {
        Error::TotalVolumeConflictingOption,
        Error::InvalidOption
      }
    ],

    Test["Test CellIsolationTechnique is automatically set as Aspirate for adherent cells, as Pellet for other cells in WashCellsUnitOperation if not specified:",
      Module[{protocol},
        protocol=ExperimentWashCells[
          {
            Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
            Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
            Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
          },
          CellIsolationTechnique -> {
            Automatic,
            Automatic,
            Pellet
          },
          Output -> Result
        ];
        Download[protocol, OutputUnitOperations[[1]][CellIsolationTechnique]]
      ],
      {
        Aspirate,
        Pellet,
        Pellet
      },
      TimeConstraint -> 6000
    ],

    Test["Test WashIsolationTime will be automatically set to be the same as CellIsolationTime when CellIsolationTechnique is Pellet and NumberOfWashes is not 0 in WashCellsUnitOperation:",
      Module[{protocol},
        protocol=ExperimentWashCells[
          {
            Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
            Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
          },
          Output -> Result
        ];
        Download[protocol, OutputUnitOperations[[1]][WashIsolationTime]]
      ],
      {
        Null,
        EqualP[10 Minute]
      },
      TimeConstraint -> 6000
    ],

    Test["Test NumberOfWashes will be washed for 3 times for adherent cells and 2 times for suspension cells in WashCellsUnitOperation:",
      Module[{protocol},
        protocol=ExperimentWashCells[
          {
            Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
            Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCells) " <> $SessionUUID],
            Object[Sample, "Adherent yeast cell sample (Test for ExperimentWashCells) " <> $SessionUUID]
          },
          NumberOfWashes -> {
            Automatic,
            Automatic,
            4
          },
          Output -> Result
        ];
        Download[protocol, OutputUnitOperations[[1]][NumberOfWashes]]
      ],
      {
        3,
        2,
        4
      },
      TimeConstraint -> 6000
    ]

  },
  Parallel -> True,
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> SetUpWashCellsChangeMediaTest[ExperimentWashCells],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    TearDownWashCellsChangeMediaTest[ExperimentWashCells]
  ),

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];


(* ::Title:: *)
(*ExperimentChangeMedia: Tests*)

DefineTests[ExperimentChangeMedia,
  {
    Example[{Options, NumberOfWashes, "If NumberOfWashes is not specified, it will be automatically set to 0 in ExperimentChangeMedia:"},
      ExperimentChangeMedia[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentChangeMedia) " <> $SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentChangeMedia) " <> $SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentChangeMedia) " <> $SessionUUID]
        },
        NumberOfWashes -> {
          Automatic,
          Automatic,
          10
        },

        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol]],
        KeyValuePattern[{
          NumberOfWashes -> {
            0,
            0,
            10
          }
        }]
      },
      TimeConstraint -> 6000
    ]
  },
  Parallel -> True,
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> SetUpWashCellsChangeMediaTest[ExperimentChangeMedia],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    TearDownWashCellsChangeMediaTest[ExperimentChangeMedia]
  ),

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];

(* ::Title:: *)
(*WashCells UnitOperation: Tests*)

DefineTests[WashCells,
  {
    Test["Test the WashCells unit operation:",
      ExperimentRoboticCellPreparation[
        WashCells[
          Sample -> Object[Sample, "Adherent mammalian cell sample (Test for WashCells) " <> $SessionUUID]
        ],
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 6000
    ],

    Test["Test the WashCells unit operation with other unit operations immediately before and after:",
      ExperimentRoboticCellPreparation[
        {
          Mix[
            Sample ->  Object[Sample, "Adherent mammalian cell sample (Test for WashCells) " <> $SessionUUID],
            MixType -> Pipette,
            NumberOfMixes -> 5
          ],
          WashCells[
            Sample ->  Object[Sample, "Adherent mammalian cell sample (Test for WashCells) " <> $SessionUUID]
          ],
          Transfer[
            Source -> Object[Sample, "Adherent mammalian cell sample (Test for WashCells) " <> $SessionUUID],
            Destination -> Model[Container, Vessel, "2mL Tube"],
            Amount -> 0.5 Milliliter
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 6000
    ],

    Test["Test the WashCells unit operation automatically sets CellAspirationAngle to $MaxRoboticAspirationAngle when input sample is adherent cells:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[
          WashCells[
            Sample -> Object[Sample, "Adherent mammalian cell sample (Test for WashCells) " <> $SessionUUID]
          ],
          Output -> Result
        ];
        Download[protocol, OutputUnitOperations[[1]][CellAspirationAngle]]
      ],
      {
        EqualP[$MaxRoboticAspirationAngle]
      },
      TimeConstraint -> 6000
    ]
  },
  Parallel -> True,
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> SetUpWashCellsChangeMediaTest[WashCells],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    TearDownWashCellsChangeMediaTest[WashCells]
  ),

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];

(* ::Title:: *)
(*ChangeMedia UnitOperation: Tests*)

DefineTests[ChangeMedia,
  {
    Test["Test the ChangeMedia unit operation:",
      ExperimentRoboticCellPreparation[
        ChangeMedia[
          Sample -> Object[Sample, "Adherent mammalian cell sample (Test for ChangeMedia) " <> $SessionUUID]
        ],
        Output -> Result
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 6000
    ],

    Test["Test the ChangeMedia unit operation with other unit operations immediately before and after:",
      ExperimentRoboticCellPreparation[
        {
          Mix[
            Sample ->  Object[Sample, "Adherent mammalian cell sample (Test for ChangeMedia) " <> $SessionUUID],
            MixType -> Pipette,
            NumberOfMixes -> 5
          ],
          ChangeMedia[
            Sample ->  Object[Sample, "Adherent mammalian cell sample (Test for ChangeMedia) " <> $SessionUUID]
          ],
          Transfer[
            Source -> Object[Sample, "Adherent mammalian cell sample (Test for ChangeMedia) " <> $SessionUUID],
            Destination -> Model[Container, Vessel, "2mL Tube"],
            Amount -> 0.5 Milliliter
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 6000
    ]
  },
  Parallel -> True,
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> SetUpWashCellsChangeMediaTest[ChangeMedia],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    TearDownWashCellsChangeMediaTest[ChangeMedia]
  ),

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];