(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-02-24 *)

DefineTests[ClassifyTransfer,
  {
    Example[{Basic, "Classifying a single transfer yields an updated transfer object:"},
      ClassifyTransfer[Object[UnitOperation, Transfer, "id:rea9jlaZnERe"]],
      ObjectP[Object[UnitOperation, Transfer]]
    ],
    Example[{Basic, "Downloading the classification results from a classified transfer provides the classifications and confidences for each aspiration in the transfer object:"},
      Module[{updatedTransferObject},
        updatedTransferObject = ClassifyTransfer[Object[UnitOperation, Transfer, "id:rea9jlaZnERe"]];
        Download[updatedTransferObject, {AspirationClassifications, AspirationClassificationConfidences}]
      ],
      {{(Success | Failure)..}, {RangeP[0 Percent, 100 Percent]..}},
      Variables :> {updatedTransferObject}
    ],
    Example[{Basic, "Classifying multiple transfers yields an updated transfer object for each input transfer:"},
      ClassifyTransfer[{Object[UnitOperation, Transfer, "id:rea9jlaZnERe"], Object[UnitOperation, Transfer, "id:qdkmxzk19LvY"]}],
      {ObjectP[Object[UnitOperation, Transfer]], ObjectP[Object[UnitOperation, Transfer]]}
    ],
    Example[{Basic, "ClassifyTransfer also directly works on the OutputUnitOperations field of a Object[Protocol, RoboticSamplePreparation] object by classifying any transfer unit operations in the input list, and leaving the other unit operations alone:"},
      Module[{outputUnitOperations},
        outputUnitOperations = Download[Object[Protocol, RoboticCellPreparation, "id:N80DNj0kZR1D"], OutputUnitOperations];
        ClassifyTransfer[outputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation, LabelContainer]],
        ObjectP[Object[UnitOperation, Transfer]],
        ObjectP[Object[UnitOperation, Pellet]],
        ObjectP[Object[UnitOperation, Cover]]
      },
      Variables :> {outputUnitOperations}
    ],
    Test["Calling ClassifyTransfer on a non-transfer object leaves the unit operation alone:",
      Module[{labelObject},
        labelObject = ClassifyTransfer[Object[UnitOperation, LabelContainer, "id:8qZ1VWZzYb0p"]];
        Download[labelObject]
      ],
      Download[Object[UnitOperation, LabelContainer, "id:8qZ1VWZzYb0p"]],
      Variables :> {labelObject}
    ],
    Test["Calling ClassifyTransfer on object with Null fields:",
      Module[{testTransfer},
        testTransfer = ClassifyTransfer[Object[UnitOperation, Transfer, "test transfer with nulls"]];
        Download[testTransfer, {AspirationClassifications, AspirationClassificationConfidences}]
      ],
      {
        {(Success | Failure), Null, Null},
        {RangeP[0 Percent, 100 Percent], Null, Null}
      },
      Variables :> {testTransfer}
    ]
  },
  SymbolSetUp :> (
    Quiet[
      Upload[<|
        Type -> Object[UnitOperation, Transfer],
        Name -> "test transfer with nulls",
        Replace[AspirationPressure] -> {
          QuantityArray[{{0 Second, -12 Pascal}, {10 Millisecond, -40 Pascal}, {20 Millisecond, -100 Pascal}, {30 Millisecond, 0 Pascal}}],
          Null,
          Null
        },
        Replace[AspirationClassifications] -> Null,
        Replace[AspirationClassificationConfidences] -> Null
      |>],
      {Upload::NonUniqueName}
    ]
  ),
  TearDown :> {
    (* remove the classifications and confidences from the test objects *)
    Upload[{
      <|
        Object -> Object[UnitOperation, Transfer, "id:rea9jlaZnERe"],
        Replace[AspirationClassifications] -> Null,
        Replace[AspirationClassificationConfidences] -> Null
      |>,
      <|
        Object -> Object[UnitOperation, Transfer, "id:qdkmxzk19LvY"],
        Replace[AspirationClassifications] -> Null,
        Replace[AspirationClassificationConfidences] -> Null
      |>
    }]
  }
];