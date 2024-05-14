(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ConvertCellConcentration*)


DefineTests[
  ConvertCellConcentration,
  {
    Example[{Basic,"Convert from Cell/Milliliter to CFU/Milliliter using the provided standard curve:"},
      ConvertCellConcentration[10 Cell/Milliliter, CFU/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID]],
      100 CFU/Milliliter
    ],
    Example[{Basic,"Convert multiple values using the same standard curve:"},
      ConvertCellConcentration[
        {
          10 Cell/Milliliter,
          5 Cell/Milliliter,
          80 Cell/Milliliter
        },
        CFU/Milliliter,
        Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID]
      ],
      {100 CFU/Milliliter, 25 CFU/Milliliter, 6400 CFU/Milliliter}
    ],
    Example[{Basic,"Convert different units in the same function call:"},
      ConvertCellConcentration[
        {
          10 Cell/Milliliter,
          5 RelativeNephelometricUnit,
          80 Cell/Milliliter
        },
        CFU/Milliliter,
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (RelativeNephelometricUnit to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID]
        }
      ],
      {100 CFU/Milliliter, 10 CFU/Milliliter, 6400 CFU/Milliliter}
    ],
    Example[{Basic,"Convert units using the standard curves found in a Model[Cell]:"},
      ConvertCellConcentration[
        10 Cell/Milliliter,
        CFU/Milliliter,
        Model[Cell, Bacteria, "Test cell model 1 for ConvertCellConcentration" <> $SessionUUID]
      ],
      100 CFU/Milliliter
    ],

    Example[{Additional,"Converting to units that are already compatible, does not use the standard curve:"},
      ConvertCellConcentration[10 Cell/Milliliter, Cell/Liter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID]],
      10000 Cell/Liter
    ],

    Example[{Additional,"Convert to different target units using different standard curves:"},
      ConvertCellConcentration[
        {
          10 Cell/Milliliter,
          5 Cell/Milliliter,
          80 Cell/Milliliter
        },
        {
          CFU/Milliliter,
          CFU/Milliliter,
          OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID]
        }
      ],
      {100 CFU/Milliliter, 25 CFU/Milliliter, 800 OD600}
    ],
    Example[{Additional,"Any units compatible with those in CellConcentrationUnitsP are valid units for the value input:"},
      ConvertCellConcentration[
        {
          10 Cell/Liter,
          5 Cell/Microliter,
          80 Cell/Milliliter
        },
        {
          CFU/Milliliter,
          CFU/Milliliter,
          OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID]
        }
      ],
      {1/10000 * CFU/Milliliter, 25000000 CFU/Milliliter, 800 OD600}
    ],
    Example[{Additional,"Any units compatible with those in CellConcentrationUnitsP are valid target units:"},
      ConvertCellConcentration[
        {
          10 Cell/Milliliter,
          5 Cell/Milliliter,
          80 Cell/Milliliter
        },
        {
          CFU/Microliter,
          CFU/Liter,
          OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID]
        }
      ],
      {1/10 * CFU/Microliter, 25000 CFU/Liter, 800 OD600}
    ],
    Example[{Additional,"Convert units even if the Model[Cell] contains multiple standard curves:"},
      ConvertCellConcentration[
        10 Cell/Milliliter,
        OD600,
        Model[Cell, Bacteria, "Test cell model 2 for ConvertCellConcentration" <> $SessionUUID]
      ],
      100 OD600
    ],
    Example[{Additional,"If a StandardCurve has InversePrediction->True, InversePrediction of a StandardFitFunction can be used to do the conversion:"},
      ConvertCellConcentration[
        0.7 OD600,
        Cell/Milliliter,
        Object[Analysis,StandardCurve,"Test StandardCurve 6 (Cell/mL to OD600 & inv predict) for ConvertCellConcentration" <> $SessionUUID]
      ],
      Quantity[0.7, IndependentUnit["Cells"]/("Milliliters")],
      EquivalenceFunction -> RoundMatchQ[8]
    ],
    Example[{Additional,"If a Model[Cell] contains multiple standard curves that can convert the same units, the most recently created object will be used and a warning will be thrown:"},
      ConvertCellConcentration[
        5 Cell/Milliliter,
        CFU/Milliliter,
        Model[Cell, Bacteria, "Test cell model 4 for ConvertCellConcentration" <> $SessionUUID]
      ],
      125 CFU/Milliliter,
      Messages :> {Warning::MultipleCompatibleStandardCurves}
    ],

    Example[{Messages,"IndexMatchingLengthMismatch","If lists of inputs are provided and they are not all the same length, an error is thrown:"},
      ConvertCellConcentration[
        {
          10 Cell/Milliliter,
          5 Cell/Milliliter
        },
        {
          CFU/Milliliter,
          CFU/Milliliter,
          OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::IndexMatchingLengthMismatch}
    ],
    Example[{Messages,"StandardCurveFitFunctionNotFound","If a BestFitFunction is not found, an error is thrown:"},
      ConvertCellConcentration[
        10 Cell/Milliliter,
        OD600,
        Object[Analysis,StandardCurve,"Test StandardCurve 4 (Cell/mL to OD600 & missing BestFitFunction) for ConvertCellConcentration" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::StandardCurveFitFunctionNotFound}
    ],
    Example[{Messages,"IncompatibleStandardCurve","If the StandardDataUnits of the provided standard curve are not compatible with the value units, an error is thrown:"},
      ConvertCellConcentration[
        10 OD600,
        CFU/Milliliter,
        Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::IncompatibleStandardCurve}
    ],
    Example[{Messages,"IncompatibleStandardCurve","If the StandardDataUnits of the provided standard curve are Length > 2, an error is thrown:"},
      ConvertCellConcentration[
        10 Cell/Milliliter,
        OD600,
        Object[Analysis,StandardCurve,"Test StandardCurve 5 (Cell/mL to OD600 & 3 StandardDataUnits) for ConvertCellConcentration" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::IncompatibleStandardCurve}
    ],
    Example[{Messages,"NoCompatibleStandardCurveInCellModel","If a Model[Cell] is provided and no standard curve from it is compatible, an error is thrown:"},
      ConvertCellConcentration[
        1.2 OD600,
        RelativeNephelometricUnit,
        Model[Cell, Bacteria, "Test cell model 2 for ConvertCellConcentration" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::NoCompatibleStandardCurveInCellModel}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            (* Fits *)
            Object[Analysis,Fit,"Test Fit 1 for ConvertCellConcentration" <> $SessionUUID],

            (* Standard Curves *)
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (RelativeNephelometricUnit to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 4 (Cell/mL to OD600 & missing BestFitFunction) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 5 (Cell/mL to OD600 & 3 StandardDataUnits) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 6 (Cell/mL to OD600 & inv predict) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 7 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],

            (* Neph objs *)
            Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ConvertCellConcentration" <> $SessionUUID],
            Model[Instrument,Nephelometer,"Test Nephelometer model 1 for ConvertCellConcentration" <> $SessionUUID],

            (* Model[Cell]'s *)
            Model[Cell, Bacteria, "Test cell model 1 for ConvertCellConcentration" <> $SessionUUID],
            Model[Cell, Bacteria, "Test cell model 2 for ConvertCellConcentration" <> $SessionUUID],
            Model[Cell, Bacteria, "Test cell model 3 for ConvertCellConcentration" <> $SessionUUID],
            Model[Cell, Bacteria, "Test cell model 4 for ConvertCellConcentration" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create a test Object[Analysis,Fit] for inverse prediction *)
      AnalyzeFit[
        {{1 EmeraldCell/Milliliter, 1 OD600},{10 EmeraldCell/Milliliter, 10 OD600},{100 EmeraldCell/Milliliter, 100 OD600}},
        Linear,
        Name -> "Test Fit 1 for ConvertCellConcentration" <> $SessionUUID
      ];

      (* Make sure the fit object is a developer object *)
      Upload[<|
        Object -> Object[Analysis,Fit,"Test Fit 1 for ConvertCellConcentration" <> $SessionUUID],
        DeveloperObject -> True
      |>];

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1^2 &, Cell/Milliliter, CFU/Milliliter],
            DateCreated -> Now - 1 Day,
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (RelativeNephelometricUnit to cfu/mL) for ConvertCellConcentration" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, RelativeNephelometricUnit, CFU/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,OD600},
            BestFitFunction -> QuantityFunction[#1 * 10 &, Cell/Milliliter, OD600],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 4 (Cell/mL to OD600 & missing BestFitFunction) for ConvertCellConcentration" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,OD600},
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 5 (Cell/mL to OD600 & 3 StandardDataUnits) for ConvertCellConcentration" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,OD600,Meter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, Cell/Milliliter, OD600],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 6 (Cell/mL to OD600 & inv predict) for ConvertCellConcentration" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,OD600},
            BestFitFunction -> QuantityFunction[#1 &, Cell/Milliliter, OD600],
            StandardCurveFit -> Link[Object[Analysis,Fit,"Test Fit 1 for ConvertCellConcentration" <> $SessionUUID]],
            InversePrediction->True,
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 7 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1^3 &, Cell/Milliliter, CFU/Milliliter],
            DeveloperObject -> True
          |>
        }
      ];

      (* Create a shell Object[Protocol,Nephelometry] and Model[Instrument,Nephelometer] so the Model[Cell] can be populated properly *)
      Upload[
        {
          <|
            Type->Object[Protocol,Nephelometry],
            Name->"Test Nephelometry protocol 1 for ConvertCellConcentration" <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type->Model[Instrument,Nephelometer],
            Name->"Test Nephelometer model 1 for ConvertCellConcentration" <> $SessionUUID,
            DeveloperObject -> True
          |>
        }
      ];

      (* Create model cell objects with some standard curves populated *)
      UploadBacterialCell[
        {
          "Test cell model 1 for ConvertCellConcentration" <> $SessionUUID,
          "Test cell model 2 for ConvertCellConcentration" <> $SessionUUID,
          "Test cell model 3 for ConvertCellConcentration" <> $SessionUUID,
          "Test cell model 4 for ConvertCellConcentration" <> $SessionUUID
        },
        Morphology -> Cocci,
        BiosafetyLevel -> "BSL-1",
        Flammable -> False,
        MSDSRequired -> False,
        IncompatibleMaterials -> {None},
        CellType -> Bacterial,
        CultureAdhesion -> Suspension,
        StandardCurves->{
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID]
          },
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (RelativeNephelometricUnit to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID]
          },
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 4 (Cell/mL to OD600 & missing BestFitFunction) for ConvertCellConcentration" <> $SessionUUID]
          },
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 7 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID]
          }
        },
        StandardCurveProtocols->{
          {Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ConvertCellConcentration" <> $SessionUUID]},
          {Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ConvertCellConcentration" <> $SessionUUID], Null},
          {Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ConvertCellConcentration" <> $SessionUUID]},
          {Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ConvertCellConcentration" <> $SessionUUID], Null}
        }
      ];
      
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            (* Fits *)
            Object[Analysis,Fit,"Test Fit 1 for ConvertCellConcentration" <> $SessionUUID],

            (* Standard Curves *)
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (RelativeNephelometricUnit to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 3 (Cell/mL to OD600) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 4 (Cell/mL to OD600 & missing BestFitFunction) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 5 (Cell/mL to OD600 & 3 StandardDataUnits) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 6 (Cell/mL to OD600 & inv predict) for ConvertCellConcentration" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 7 (cell/mL to cfu/mL) for ConvertCellConcentration" <> $SessionUUID],

            (* Neph objs *)
            Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ConvertCellConcentration" <> $SessionUUID],
            Model[Instrument,Nephelometer,"Test Nephelometer model 1 for ConvertCellConcentration" <> $SessionUUID],

            (* Model[Cell]'s *)
            Model[Cell, Bacteria, "Test cell model 1 for ConvertCellConcentration" <> $SessionUUID],
            Model[Cell, Bacteria, "Test cell model 2 for ConvertCellConcentration" <> $SessionUUID],
            Model[Cell, Bacteria, "Test cell model 3 for ConvertCellConcentration" <> $SessionUUID],
            Model[Cell, Bacteria, "Test cell model 4 for ConvertCellConcentration" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];

(* ::Subsection::Closed:: *)
(*Child Functions*)

(* ::Subsubsection::Closed:: *)
(*OD600ToCellPermL*)
DefineTests[
  OD600ToCellPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from OD600 to Cell/Milliliter:"},
      OD600ToCellPermL[10 OD600, Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID]],
      20 Cell/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from OD600 to Cell/Milliliter:"},
      OD600ToCellPermL[
        {
          10 OD600,
          10 OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID]
        }
      ],
      {20 Cell/Milliliter, 100 Cell/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, OD600, Cell/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, OD600, Cell/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to cell/mL) for OD600ToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];


(* ::Subsubsection::Closed:: *)
(*OD600ToCFUPermL*)
DefineTests[
  OD600ToCFUPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from OD600 to CFU/Milliliter:"},
      OD600ToCFUPermL[10 OD600, Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID]],
      20 CFU/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from OD600 to CFU/Milliliter:"},
      OD600ToCFUPermL[
        {
          10 OD600,
          10 OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID]
        }
      ],
      {20 CFU/Milliliter, 100 CFU/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, OD600, CFU/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, OD600, CFU/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to cfu/mL) for OD600ToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*OD600ToRelativeNephelometricUnit*)
DefineTests[
  OD600ToRelativeNephelometricUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from OD600 to RelativeNephelometricUnit:"},
      OD600ToRelativeNephelometricUnit[10 OD600, Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID]],
      20 RelativeNephelometricUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from OD600 to RelativeNephelometricUnit:"},
      OD600ToRelativeNephelometricUnit[
        {
          10 OD600,
          10 OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID]
        }
      ],
      {20 RelativeNephelometricUnit, 100 RelativeNephelometricUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, OD600, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, OD600, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to rnu) for OD600ToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*OD600ToNephelometricTurbidityUnit*)
DefineTests[
  OD600ToNephelometricTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from OD600 to NephelometricTurbidityUnit:"},
      OD600ToNephelometricTurbidityUnit[10 OD600, Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID]],
      20 NephelometricTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from OD600 to NephelometricTurbidityUnit:"},
      OD600ToNephelometricTurbidityUnit[
        {
          10 OD600,
          10 OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 NephelometricTurbidityUnit, 100 NephelometricTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, OD600, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, OD600, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to ntu) for OD600ToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*OD600ToFormazinTurbidityUnit*)
DefineTests[
  OD600ToFormazinTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from OD600 to FormazinTurbidityUnit:"},
      OD600ToFormazinTurbidityUnit[10 OD600, Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID]],
      20 FormazinTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from OD600 to FormazinTurbidityUnit:"},
      OD600ToFormazinTurbidityUnit[
        {
          10 OD600,
          10 OD600
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 FormazinTurbidityUnit, 100 FormazinTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, OD600, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {OD600,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, OD600, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (arb to ftu) for OD600ToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CellPermLToOD600*)
DefineTests[
  CellPermLToOD600,
  {
    Example[{Basic,"Use a Standard curve to convert from Cell/Milliliter to OD600:"},
      CellPermLToOD600[10 Cell/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID]],
      20 OD600
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from Cell/Milliliter to OD600:"},
      CellPermLToOD600[
        {
          10 Cell/Milliliter,
          10 Cell/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID]
        }
      ],
      {20 OD600, 100 OD600}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,OD600},
            BestFitFunction -> QuantityFunction[#1 * 2 &, Cell/Milliliter, OD600],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,OD600},
            BestFitFunction -> QuantityFunction[#1 * 10 &, Cell/Milliliter, OD600],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to arb) for CellPermLToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CellPermLToCFUPermL*)
DefineTests[
  CellPermLToCFUPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from Cell/Milliliter to CFU/Milliliter:"},
      CellPermLToCFUPermL[10 Cell/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID]],
      20 CFU/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from Cell/Milliliter to CFU/Milliliter:"},
      CellPermLToCFUPermL[
        {
          10 Cell/Milliliter,
          10 Cell/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID]
        }
      ],
      {20 CFU/Milliliter, 100 CFU/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, Cell/Milliliter, CFU/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, Cell/Milliliter, CFU/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to cfu/ml) for CellPermLToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CellPermLToRelativeNephelometricUnit*)
DefineTests[
  CellPermLToRelativeNephelometricUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from Cell/Milliliter to RelativeNephelometricUnit:"},
      CellPermLToRelativeNephelometricUnit[10 Cell/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID]],
      20 RelativeNephelometricUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from Cell/Milliliter to RelativeNephelometricUnit:"},
      CellPermLToRelativeNephelometricUnit[
        {
          10 Cell/Milliliter,
          10 Cell/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID]
        }
      ],
      {20 RelativeNephelometricUnit, 100 RelativeNephelometricUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, Cell/Milliliter, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, Cell/Milliliter, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to rnu) for CellPermLToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CellPermLToNephelometricTurbidityUnit*)
DefineTests[
  CellPermLToNephelometricTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from Cell/Milliliter to NephelometricTurbidityUnit:"},
      CellPermLToNephelometricTurbidityUnit[10 Cell/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID]],
      20 NephelometricTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from Cell/Milliliter to NephelometricTurbidityUnit:"},
      CellPermLToNephelometricTurbidityUnit[
        {
          10 Cell/Milliliter,
          10 Cell/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 NephelometricTurbidityUnit, 100 NephelometricTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, Cell/Milliliter, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, Cell/Milliliter, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to ntu) for CellPermLToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CellPermLToFormazinTurbidityUnit*)
DefineTests[
  CellPermLToFormazinTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from Cell/Milliliter to FormazinTurbidityUnit:"},
      CellPermLToFormazinTurbidityUnit[10 Cell/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID]],
      20 FormazinTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from Cell/Milliliter to FormazinTurbidityUnit:"},
      CellPermLToFormazinTurbidityUnit[
        {
          10 Cell/Milliliter,
          10 Cell/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 FormazinTurbidityUnit, 100 FormazinTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, Cell/Milliliter, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {Cell/Milliliter,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, Cell/Milliliter, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cell/ml to ftu) for CellPermLToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToOD600*)
DefineTests[
  CFUPermLToOD600,
  {
    Example[{Basic,"Use a Standard curve to convert from CFU/Milliliter to OD600:"},
      CFUPermLToOD600[10 CFU/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID]],
      20 OD600
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from CFU/Milliliter to OD600:"},
      CFUPermLToOD600[
        {
          10 CFU/Milliliter,
          10 CFU/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID]
        }
      ],
      {20 OD600, 100 OD600}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,OD600},
            BestFitFunction -> QuantityFunction[#1 * 2 &, CFU/Milliliter, OD600],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,OD600},
            BestFitFunction -> QuantityFunction[#1 * 10 &, CFU/Milliliter, OD600],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to arb) for CFUPermLToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToCellPermL*)
DefineTests[
  CFUPermLToCellPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from CFU/Milliliter to Cell/Milliliter:"},
      CFUPermLToCellPermL[10 CFU/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID]],
      20 Cell/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from CFU/Milliliter to Cell/Milliliter:"},
      CFUPermLToCellPermL[
        {
          10 CFU/Milliliter,
          10 CFU/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID]
        }
      ],
      {20 Cell/Milliliter, 100 Cell/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, CFU/Milliliter, Cell/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, CFU/Milliliter, Cell/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to cell/ml) for CFUPermLToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToRelativeNephelometricUnit*)
DefineTests[
  CFUPermLToRelativeNephelometricUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from CFU/Milliliter to RelativeNephelometricUnit:"},
      CFUPermLToRelativeNephelometricUnit[10 CFU/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID]],
      20 RelativeNephelometricUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from CFU/Milliliter to RelativeNephelometricUnit:"},
      CFUPermLToRelativeNephelometricUnit[
        {
          10 CFU/Milliliter,
          10 CFU/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID]
        }
      ],
      {20 RelativeNephelometricUnit, 100 RelativeNephelometricUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, CFU/Milliliter, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, CFU/Milliliter, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to rnu) for CFUPermLToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToNephelometricTurbidityUnit*)
DefineTests[
  CFUPermLToNephelometricTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from CFU/Milliliter to NephelometricTurbidityUnit:"},
      CFUPermLToNephelometricTurbidityUnit[10 CFU/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID]],
      20 NephelometricTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from CFU/Milliliter to NephelometricTurbidityUnit:"},
      CFUPermLToNephelometricTurbidityUnit[
        {
          10 CFU/Milliliter,
          10 CFU/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 NephelometricTurbidityUnit, 100 NephelometricTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, CFU/Milliliter, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, CFU/Milliliter, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to ntu) for CFUPermLToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*CFUPermLToFormazinTurbidityUnit*)
DefineTests[
  CFUPermLToFormazinTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from CFU/Milliliter to FormazinTurbidityUnit:"},
      CFUPermLToFormazinTurbidityUnit[10 CFU/Milliliter, Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID]],
      20 FormazinTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from CFU/Milliliter to FormazinTurbidityUnit:"},
      CFUPermLToFormazinTurbidityUnit[
        {
          10 CFU/Milliliter,
          10 CFU/Milliliter
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 FormazinTurbidityUnit, 100 FormazinTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, CFU/Milliliter, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {CFU/Milliliter,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, CFU/Milliliter, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (cfu/ml to ftu) for CFUPermLToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToOD600*)
DefineTests[
  RelativeNephelometricUnitToOD600,
  {
    Example[{Basic,"Use a Standard curve to convert from RelativeNephelometricUnit to OD600:"},
      RelativeNephelometricUnitToOD600[10 RelativeNephelometricUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID]],
      20 OD600
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from RelativeNephelometricUnit to OD600:"},
      RelativeNephelometricUnitToOD600[
        {
          10 RelativeNephelometricUnit,
          10 RelativeNephelometricUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID]
        }
      ],
      {20 OD600, 100 OD600}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,OD600},
            BestFitFunction -> QuantityFunction[#1 * 2 &, RelativeNephelometricUnit, OD600],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,OD600},
            BestFitFunction -> QuantityFunction[#1 * 10 &, RelativeNephelometricUnit, OD600],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to arb) for RelativeNephelometricUnitToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToCellPermL*)
DefineTests[
  RelativeNephelometricUnitToCellPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from RelativeNephelometricUnit to Cell/Milliliter:"},
      RelativeNephelometricUnitToCellPermL[10 RelativeNephelometricUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID]],
      20 Cell/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from RelativeNephelometricUnit to Cell/Milliliter:"},
      RelativeNephelometricUnitToCellPermL[
        {
          10 RelativeNephelometricUnit,
          10 RelativeNephelometricUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID]
        }
      ],
      {20 Cell/Milliliter, 100 Cell/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, RelativeNephelometricUnit, Cell/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, RelativeNephelometricUnit, Cell/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to cell/ml) for RelativeNephelometricUnitToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToCFUPermL*)
DefineTests[
  RelativeNephelometricUnitToCFUPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from RelativeNephelometricUnit to CFU/Milliliter:"},
      RelativeNephelometricUnitToCFUPermL[10 RelativeNephelometricUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID]],
      20 CFU/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from RelativeNephelometricUnit to CFU/Milliliter:"},
      RelativeNephelometricUnitToCFUPermL[
        {
          10 RelativeNephelometricUnit,
          10 RelativeNephelometricUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID]
        }
      ],
      {20 CFU/Milliliter, 100 CFU/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, RelativeNephelometricUnit, CFU/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, RelativeNephelometricUnit, CFU/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to cfu/ml) for RelativeNephelometricUnitToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToNephelometricTurbidityUnit*)
DefineTests[
  RelativeNephelometricUnitToNephelometricTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from RelativeNephelometricUnit to NephelometricTurbidityUnit:"},
      RelativeNephelometricUnitToNephelometricTurbidityUnit[10 RelativeNephelometricUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID]],
      20 NephelometricTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from RelativeNephelometricUnit to NephelometricTurbidityUnit:"},
      RelativeNephelometricUnitToNephelometricTurbidityUnit[
        {
          10 RelativeNephelometricUnit,
          10 RelativeNephelometricUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 NephelometricTurbidityUnit, 100 NephelometricTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, RelativeNephelometricUnit, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, RelativeNephelometricUnit, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to ntu) for RelativeNephelometricUnitToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*RelativeNephelometricUnitToFormazinTurbidityUnit*)
DefineTests[
  RelativeNephelometricUnitToFormazinTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from RelativeNephelometricUnit to FormazinTurbidityUnit:"},
      RelativeNephelometricUnitToFormazinTurbidityUnit[10 RelativeNephelometricUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID]],
      20 FormazinTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from RelativeNephelometricUnit to FormazinTurbidityUnit:"},
      RelativeNephelometricUnitToFormazinTurbidityUnit[
        {
          10 RelativeNephelometricUnit,
          10 RelativeNephelometricUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 FormazinTurbidityUnit, 100 FormazinTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, RelativeNephelometricUnit, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {RelativeNephelometricUnit,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, RelativeNephelometricUnit, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (rnu to ftu) for RelativeNephelometricUnitToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToOD600*)
DefineTests[
  NephelometricTurbidityUnitToOD600,
  {
    Example[{Basic,"Use a Standard curve to convert from NephelometricTurbidityUnit to OD600:"},
      NephelometricTurbidityUnitToOD600[10 NephelometricTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID]],
      20 OD600
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from NephelometricTurbidityUnit to OD600:"},
      NephelometricTurbidityUnitToOD600[
        {
          10 NephelometricTurbidityUnit,
          10 NephelometricTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID]
        }
      ],
      {20 OD600, 100 OD600}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,OD600},
            BestFitFunction -> QuantityFunction[#1 * 2 &, NephelometricTurbidityUnit, OD600],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,OD600},
            BestFitFunction -> QuantityFunction[#1 * 10 &, NephelometricTurbidityUnit, OD600],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to arb) for NephelometricTurbidityUnitToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToCellPermL*)
DefineTests[
  NephelometricTurbidityUnitToCellPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from NephelometricTurbidityUnit to Cell/Milliliter:"},
      NephelometricTurbidityUnitToCellPermL[10 NephelometricTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID]],
      20 Cell/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from NephelometricTurbidityUnit to Cell/Milliliter:"},
      NephelometricTurbidityUnitToCellPermL[
        {
          10 NephelometricTurbidityUnit,
          10 NephelometricTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID]
        }
      ],
      {20 Cell/Milliliter, 100 Cell/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, NephelometricTurbidityUnit, Cell/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, NephelometricTurbidityUnit, Cell/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to cell/ml) for NephelometricTurbidityUnitToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToCFUPermL*)
DefineTests[
  NephelometricTurbidityUnitToCFUPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from NephelometricTurbidityUnit to CFU/Milliliter:"},
      NephelometricTurbidityUnitToCFUPermL[10 NephelometricTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID]],
      20 CFU/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from NephelometricTurbidityUnit to CFU/Milliliter:"},
      NephelometricTurbidityUnitToCFUPermL[
        {
          10 NephelometricTurbidityUnit,
          10 NephelometricTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID]
        }
      ],
      {20 CFU/Milliliter, 100 CFU/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, NephelometricTurbidityUnit, CFU/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, NephelometricTurbidityUnit, CFU/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to cfu/ml) for NephelometricTurbidityUnitToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToRelativeNephelometricUnit*)
DefineTests[
  NephelometricTurbidityUnitToRelativeNephelometricUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from NephelometricTurbidityUnit to RelativeNephelometricUnit:"},
      NephelometricTurbidityUnitToRelativeNephelometricUnit[10 NephelometricTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]],
      20 RelativeNephelometricUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from NephelometricTurbidityUnit to RelativeNephelometricUnit:"},
      NephelometricTurbidityUnitToRelativeNephelometricUnit[
        {
          10 NephelometricTurbidityUnit,
          10 NephelometricTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]
        }
      ],
      {20 RelativeNephelometricUnit, 100 RelativeNephelometricUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, NephelometricTurbidityUnit, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, NephelometricTurbidityUnit, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to rnu) for NephelometricTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*NephelometricTurbidityUnitToFormazinTurbidityUnit*)
DefineTests[
  NephelometricTurbidityUnitToFormazinTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from NephelometricTurbidityUnit to FormazinTurbidityUnit:"},
      NephelometricTurbidityUnitToFormazinTurbidityUnit[10 NephelometricTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID]],
      20 FormazinTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from NephelometricTurbidityUnit to FormazinTurbidityUnit:"},
      NephelometricTurbidityUnitToFormazinTurbidityUnit[
        {
          10 NephelometricTurbidityUnit,
          10 NephelometricTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 FormazinTurbidityUnit, 100 FormazinTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, NephelometricTurbidityUnit, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {NephelometricTurbidityUnit,FormazinTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, NephelometricTurbidityUnit, FormazinTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ntu to ftu) for NephelometricTurbidityUnitToFormazinTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToOD600*)
DefineTests[
  FormazinTurbidityUnitToOD600,
  {
    Example[{Basic,"Use a Standard curve to convert from FormazinTurbidityUnit to OD600:"},
      FormazinTurbidityUnitToOD600[10 FormazinTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID]],
      20 OD600
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from FormazinTurbidityUnit to OD600:"},
      FormazinTurbidityUnitToOD600[
        {
          10 FormazinTurbidityUnit,
          10 FormazinTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID]
        }
      ],
      {20 OD600, 100 OD600}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,OD600},
            BestFitFunction -> QuantityFunction[#1 * 2 &, FormazinTurbidityUnit, OD600],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,OD600},
            BestFitFunction -> QuantityFunction[#1 * 10 &, FormazinTurbidityUnit, OD600],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to arb) for FormazinTurbidityUnitToOD600" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToCellPermL*)
DefineTests[
  FormazinTurbidityUnitToCellPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from FormazinTurbidityUnit to Cell/Milliliter:"},
      FormazinTurbidityUnitToCellPermL[10 FormazinTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID]],
      20 Cell/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from FormazinTurbidityUnit to Cell/Milliliter:"},
      FormazinTurbidityUnitToCellPermL[
        {
          10 FormazinTurbidityUnit,
          10 FormazinTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID]
        }
      ],
      {20 Cell/Milliliter, 100 Cell/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, FormazinTurbidityUnit, Cell/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,Cell/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, FormazinTurbidityUnit, Cell/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to cell/ml) for FormazinTurbidityUnitToCellPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToCFUPermL*)
DefineTests[
  FormazinTurbidityUnitToCFUPermL,
  {
    Example[{Basic,"Use a Standard curve to convert from FormazinTurbidityUnit to CFU/Milliliter:"},
      FormazinTurbidityUnitToCFUPermL[10 FormazinTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID]],
      20 CFU/Milliliter
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from FormazinTurbidityUnit to CFU/Milliliter:"},
      FormazinTurbidityUnitToCFUPermL[
        {
          10 FormazinTurbidityUnit,
          10 FormazinTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID]
        }
      ],
      {20 CFU/Milliliter, 100 CFU/Milliliter}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 2 &, FormazinTurbidityUnit, CFU/Milliliter],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,CFU/Milliliter},
            BestFitFunction -> QuantityFunction[#1 * 10 &, FormazinTurbidityUnit, CFU/Milliliter],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to cfu/ml) for FormazinTurbidityUnitToCFUPermL" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToRelativeNephelometricUnit*)
DefineTests[
  FormazinTurbidityUnitToRelativeNephelometricUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from FormazinTurbidityUnit to RelativeNephelometricUnit:"},
      FormazinTurbidityUnitToRelativeNephelometricUnit[10 FormazinTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]],
      20 RelativeNephelometricUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from FormazinTurbidityUnit to RelativeNephelometricUnit:"},
      FormazinTurbidityUnitToRelativeNephelometricUnit[
        {
          10 FormazinTurbidityUnit,
          10 FormazinTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]
        }
      ],
      {20 RelativeNephelometricUnit, 100 RelativeNephelometricUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, FormazinTurbidityUnit, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,RelativeNephelometricUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, FormazinTurbidityUnit, RelativeNephelometricUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to rnu) for FormazinTurbidityUnitToRelativeNephelometricUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];
(* ::Subsubsection::Closed:: *)
(*FormazinTurbidityUnitToNephelometricTurbidityUnit*)
DefineTests[
  FormazinTurbidityUnitToNephelometricTurbidityUnit,
  {
    Example[{Basic,"Use a Standard curve to convert from FormazinTurbidityUnit to NephelometricTurbidityUnit:"},
      FormazinTurbidityUnitToNephelometricTurbidityUnit[10 FormazinTurbidityUnit, Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID]],
      20 NephelometricTurbidityUnit
    ],
    Example[{Basic,"Use multiple Standard curves to convert multiple values from FormazinTurbidityUnit to NephelometricTurbidityUnit:"},
      FormazinTurbidityUnitToNephelometricTurbidityUnit[
        {
          10 FormazinTurbidityUnit,
          10 FormazinTurbidityUnit
        },
        {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID]
        }
      ],
      {20 NephelometricTurbidityUnit, 100 NephelometricTurbidityUnit}
    ]
  },
  SymbolSetUp :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ];
    Module[
      {},

      (* Create test Object[Analysis,StandardCurve] *)
      (* For now, just make these hollow dummy objects *)
      Upload[
        {
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 1 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 2 &, FormazinTurbidityUnit, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>,
          <|
            Type->Object[Analysis,StandardCurve],
            Name->"Test StandardCurve 2 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID,
            Replace[StandardDataUnits] -> {FormazinTurbidityUnit,NephelometricTurbidityUnit},
            BestFitFunction -> QuantityFunction[#1 * 10 &, FormazinTurbidityUnit, NephelometricTurbidityUnit],
            DeveloperObject -> True
          |>
        }
      ]
    ];
  },
  SymbolTearDown :> {
    Module[{allObjects, existingObjects},
      (* Define a list of all of the objects that are created in the SymbolSetUp *)
      allObjects = Cases[
        Flatten[
          {
            Object[Analysis,StandardCurve,"Test StandardCurve 1 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID],
            Object[Analysis,StandardCurve,"Test StandardCurve 2 (ftu to ntu) for FormazinTurbidityUnitToNephelometricTurbidityUnit" <> $SessionUUID]
          }
        ],
        ObjectP[]
      ];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
    ]
  }
];