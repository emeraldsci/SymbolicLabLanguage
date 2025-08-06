(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: User *)
(* :Date: 2023-05-15 *)


DefineTests[convertCellCompositions,
  {

    (* - Basic Examples - *)
    Example[{Basic, "convertCellCompositions from OD600 to Cell/mL:"},
      Experiment`Private`convertCellCompositions[{
        Download[Object[Sample,
          "Test Sample 0 with Cell 0 in OD600 and Cell 1 in CFU/mL for convertCellCompositions" <> $SessionUUID]]}],
      {KeyValuePattern[
        Composition -> {{RangeP[4.4 Gram / Liter, 4.6 Gram / Liter], ObjectP[], _},
          {RangeP[Quantity[59.9, IndependentUnit["Cfus"] / ("Milliliters")], Quantity[60.1, IndependentUnit["Cfus"] / ("Milliliters")]], ObjectP[], _},
          {RangeP[Quantity[49.9`, IndependentUnit["Cells"] / ("Milliliters")], Quantity[50.1`, IndependentUnit["Cells"] / ("Milliliters")]], ObjectP[], _}}
      ]}
    ],

    Example[{Basic, "convertCellCompositions does not change the initial unit if no corresponding standard curve found:"},
      Experiment`Private`convertCellCompositions[{
        Download[
          Object[Sample,
            "Test Sample 0 with Cell 0 in OD600 and Cell 1 in CFU/mL for convertCellCompositions" <> $SessionUUID]],
        Download[
          Object[Sample,
            "Test Sample 1 with Cell 0 in OD600 and Cell 2 in Cell/mL for convertCellCompositions" <> $SessionUUID]]
      }],
      {
        KeyValuePattern[
          Composition -> {{RangeP[4.4 Gram / Liter, 4.6 Gram / Liter], ObjectP[], _},
            {RangeP[Quantity[59.9, IndependentUnit["Cfus"] / ("Milliliters")], Quantity[60.1, IndependentUnit["Cfus"] / ("Milliliters")]], ObjectP[], _},
            {RangeP[Quantity[49.9`, IndependentUnit["Cells"] / ("Milliliters")], Quantity[50.1`, IndependentUnit["Cells"] / ("Milliliters")]], ObjectP[], _}}],
        KeyValuePattern[
          Composition -> {{RangeP[4.4 Gram / Liter, 4.6 Gram / Liter], ObjectP[], _},
            {RangeP[Quantity[29.9, IndependentUnit["Cells"] / ("Milliliters")], Quantity[30.1, IndependentUnit["Cells"] / ("Milliliters")]], ObjectP[], _},
            {RangeP[Quantity[49.9`, IndependentUnit["Cells"] / ("Milliliters")], Quantity[50.1`, IndependentUnit["Cells"] / ("Milliliters")]], ObjectP[], _}}]}
    ]


    (* - Messages  - *)

  },

  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),

  SymbolSetUp :> Module[{existsFilter, standardCurve0, standardCurve1, cell0, cell1, cell2, sample0, sample1, tube0, tube1},
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter = DatabaseMemberQ[{
      Object[Analysis, Fit, "Test Fit 0 for convertCellCompositions" <> $SessionUUID],
      Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID],
      Object[Analysis, StandardCurve, "Test StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID],
      Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID],
      Model[Cell, Bacteria, "Test Cell 1 with StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID],
      Model[Cell, Bacteria, "Test Cell 2 with no StandardCurve for convertCellCompositions" <> $SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 0 for convertCellCompositions " <> $SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for convertCellCompositions " <> $SessionUUID],
      Object[Sample, "Test Sample 0 with Cell 0 in OD600 and Cell 1 in CFU/mL for convertCellCompositions" <> $SessionUUID],
      Object[Sample, "Test Sample 1 with Cell 0 in OD600 and Cell 2 in Cell/mL for convertCellCompositions" <> $SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Analysis, Fit, "Test Fit 0 for convertCellCompositions" <> $SessionUUID],
          Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID],
          Object[Analysis, StandardCurve, "Test StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID],
          Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID],
          Model[Cell, Bacteria, "Test Cell 1 with StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID],
          Model[Cell, Bacteria, "Test Cell 2 with no StandardCurve for convertCellCompositions" <> $SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 0 for convertCellCompositions " <> $SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for convertCellCompositions " <> $SessionUUID],
          Object[Sample, "Test Sample 0 with Cell 0 in OD600 and Cell 1 in CFU/mL for convertCellCompositions" <> $SessionUUID],
          Object[Sample, "Test Sample 1 with Cell 0 in OD600 and Cell 2 in Cell/mL for convertCellCompositions" <> $SessionUUID]
        },
        existsFilter
      ],
      Force -> True,
      Verbose -> False
    ];

    (* Create a test Object[Analysis,Fit] for inverse prediction *)
    AnalyzeFit[
      {{1 EmeraldCell / Milliliter, 1 OD600}, {10 EmeraldCell / Milliliter, 10 OD600}, {100 EmeraldCell / Milliliter, 100 OD600}},
      Linear,
      Name -> "Test Fit 0 for convertCellCompositions" <> $SessionUUID
    ];

    (* Make sure the fit object is a developer object *)
    Upload[<|
      Object -> Object[Analysis, Fit, "Test Fit 0 for convertCellCompositions" <> $SessionUUID],
      DeveloperObject -> True
    |>];

    {standardCurve0, standardCurve1} = Upload[{
      <|
        Type -> Object[Analysis, StandardCurve],
        Name -> "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID,
        Replace[StandardDataUnits] -> {Cell / Milliliter, OD600},
        BestFitFunction -> QuantityFunction[#1 &, Cell / Milliliter, OD600],
        StandardCurveFit -> Link[Object[Analysis, Fit, "Test Fit 0 for convertCellCompositions" <> $SessionUUID]],
        InversePrediction -> True,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Analysis, StandardCurve],
        Name -> "Test StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID,
        Replace[StandardDataUnits] -> {Cell / Milliliter, CFU / Milliliter},
        BestFitFunction -> QuantityFunction[#1^2 &, Cell / Milliliter, CFU / Milliliter],
        DateCreated -> Now - 1 Day,
        DeveloperObject -> True
      |>
    }];

    {cell0, cell1, cell2} = Upload[{
      <|
        Type -> Model[Cell, Bacteria],
        Name -> "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID,
        CellType -> Bacterial,
        CultureAdhesion -> Suspension,
        Replace[StandardCurves] -> {Link[Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID]]}
      |>,
      <|
        Type -> Model[Cell, Bacteria],
        Name -> "Test Cell 1 with StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID,
        CellType -> Bacterial,
        CultureAdhesion -> Suspension,
        Replace[StandardCurves] -> {Link[Object[Analysis, StandardCurve, "Test StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID]]}
      |>,
      <|
        Type -> Model[Cell, Bacteria],
        Name -> "Test Cell 2 with no StandardCurve for convertCellCompositions" <> $SessionUUID,
        CellType -> Bacterial,
        CultureAdhesion -> Suspension
      |>
    }];

    {tube0, tube1} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects], (* "50 mL Tube" *)
        Name -> "Test 50mL Tube 0 for convertCellCompositions " <> $SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects], (* "50 mL Tube" *)
        Name -> "Test 50mL Tube 1 for convertCellCompositions " <> $SessionUUID,
        DeveloperObject -> True
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0, sample1} = UploadSample[
      {
        {
          {4.5 Gram / Liter, Link[Model[Molecule, "id:dORYzZJ3l38e"]]},
          {60 CFU / Milliliter, Link[Model[Cell, Bacteria, "Test Cell 1 with StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID]]},
          {50 OD600, Link[Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID]]}
        },
        {
          {4.5 Gram / Liter, Link[Model[Molecule, "id:dORYzZJ3l38e"]]},
          {30 Cell / Milliliter, Link[Model[Cell, Bacteria, "Test Cell 2 with no StandardCurve for convertCellCompositions" <> $SessionUUID]]},
          {50 OD600, Link[Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID]]}
        }
      },
      {
        {"A1", tube0},
        {"A1", tube1}
      },
      Name -> {
        "Test Sample 0 with Cell 0 in OD600 and Cell 1 in CFU/mL for convertCellCompositions" <> $SessionUUID,
        "Test Sample 1 with Cell 0 in OD600 and Cell 2 in Cell/mL for convertCellCompositions" <> $SessionUUID
      },
      InitialAmount -> {
        10 Milliliter,
        5 Milliliter
      },
      CellType -> {
        Bacterial,
        Bacterial
      },
      CultureAdhesion -> {
        Suspension,
        Suspension
      },
      Living -> {
        True,
        True
      },
      State -> {Liquid, Liquid}
    ];

  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Analysis, Fit, "Test Fit 0 for convertCellCompositions" <> $SessionUUID],
        Object[Analysis, StandardCurve, "Test StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID],
        Object[Analysis, StandardCurve, "Test StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID],
        Model[Cell, Bacteria, "Test Cell 0 with StandardCurve 0 (Cell/mL to OD600 & inv predict) for convertCellCompositions" <> $SessionUUID],
        Model[Cell, Bacteria, "Test Cell 1 with StandardCurve 1 (Cell/mL to CFU/mL) for convertCellCompositions" <> $SessionUUID],
        Model[Cell, Bacteria, "Test Cell 2 with no StandardCurve for convertCellCompositions" <> $SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 0 for convertCellCompositions " <> $SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for convertCellCompositions " <> $SessionUUID],
        Object[Sample, "Test Sample 0 with Cell 0 in OD600 and Cell 1 in CFU/mL for convertCellCompositions" <> $SessionUUID],
        Object[Sample, "Test Sample 1 with Cell 0 in OD600 and Cell 2 in Cell/mL for convertCellCompositions" <> $SessionUUID]

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
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];