(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* PlotWeighingTimeline *)

DefineTests[PlotWeighingTimeline,
  {
    (* Basic Examples *)
    Example[
      {Basic, "When provided a batched transfer unit operation, a timeline of weighing events is plotted:"},
      PlotWeighingTimeline[Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]],
      _Column
    ],
    Example[
      {Basic, "When provided multiple batched transfer unit operations, timelines of the weighing events for each transfer unit operation are plotted:"},
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        }
      ],
      {_Column..}
    ],

    (* Options *)
    Example[
      {Options, SummaryTable, "When provided a batched transfer unit operation and SummaryTable is set to True, a table summarizing plotted weighing events is presented below the weighing event plot:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        SummaryTable -> True
      ],
      _Column
    ],
    Example[
      {Options, SummaryTable, "When provided a batched transfer unit operation and SummaryTable is set to False, only the weighing event plot will be returned:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        SummaryTable -> False
      ],
      ValidGraphicsP[]
    ],
    Test[
      "When provided with multiple batched transfer unit operation and SummaryTable is set to False, only the weighing event plots will be returned:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        SummaryTable -> False
      ],
      {ValidGraphicsP[]..}
    ],

    Example[
      {Options, WeighingEventIndices, "When provided a batched transfer unit operation and when WeighingEventIndices is set to a certain number, that number of weighing events, starting with the first weighing event, will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventIndices -> 2
      ],
      _Column
    ],
    Example[
      {Options, WeighingEventIndices, "When provided a batched transfer unit operation and when WeighingEventIndices is set to a list of indices, weighing events matching those indices, starting with the first weighing event, will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventIndices -> {1, 3, 5}
      ],
      _Column
    ],
    Example[
      {Options, WeighingEventIndices, "When provided a batched transfer unit operation and when WeighingEventIndices is set All, every weighing events will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventIndices -> All
      ],
      _Column
    ],
    Example[
      {Options, WeighingEventIndices, "When provided a batched transfer unit operation and when WeighingEventIndices is set None, no weighing events will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventIndices -> None
      ],
      _Column
    ],
    Test[
      "When provided with multiple batched transfer unit operations and when WeighingEventIndices is set to a certain number, that number of weighing events, starting with the first weighing event, will be plotted for each batched transfer unit operations:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        WeighingEventIndices -> 2
      ],
      {_Column..}
    ],
    Test[
      "When provided with multiple batched transfer unit operations and when WeighingEventIndices is set to a list of indices, weighing events matching those indices, starting with the first weighing event, will be plotted for each batched transfer unit operation:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        WeighingEventIndices -> {1, 3, 5}
      ],
      {_Column..}
    ],
    Test[
      "Individual WeighingEventIndices using integers can be provided for each input batched transfer unit operation:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        WeighingEventIndices -> {2, 5}
      ],
      {_Column..}
    ],
    Test[
      "Individual WeighingEventIndices using lists of indices can be provided for each input batched transfer unit operation:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        WeighingEventIndices -> {{2, 5}, {3, 4}}
      ],
      {_Column..}
    ],


    Example[
      {Options, WeighingEventTypes, "When provided a batched transfer unit operation and when WeighingEventTypes is set to All, every weighing event will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventTypes -> All
      ],
      _Column
    ],
    Example[
      {Options, WeighingEventTypes, "When provided a batched transfer unit operation and when WeighingEventTypes is set to None, no weighing events will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventTypes -> None
      ],
      _Column
    ],
    Example[
      {Options, WeighingEventTypes, "When provided a batched transfer unit operation and when WeighingEventTypes is set to a weighing event, only that weighing event will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventTypes -> TransferWeight
      ],
      _Column
    ],
    Example[
      {Options, WeighingEventTypes, "When provided a batched transfer unit operation and when WeighingEventTypes is set to multiple weighing events, only the specified weighing events will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventTypes -> {TareWeight, TransferWeight}
      ],
      _Column
    ],
    Test[
      "One set of weighing events can be specified for multiple batched transfer unit oeprations:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        WeighingEventTypes -> {TareWeight, TransferWeight, ResidueWeight}
      ],
      {_Column..}
    ],
    Test[
      "Multiple sets of weighing events can be specified for multiple batched transfer unit oeprations:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        WeighingEventTypes -> {{TareWeight, TransferWeight}, {EmptyContainerWeight}}
      ],
      {_Column..}
    ],


    Example[
      {Options, PlotLabel, "When provided a batched transfer unit operation and a PlotLabel, the provided label will be used for the plotted weighing timeline:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        PlotLabel -> "Test batched transfer unit operation 1 weighing timeline"
      ],
      _Column
    ],
    Test[
      "Can set plot labels for multiple plots:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        PlotLabel -> {
          "Test batched transfer unit operation 1 weighing timeline",
          "Test batched transfer unit operation 2 weighing timeline"
        }
      ],
      {_Column..}
    ],

    Example[
      {Options, AspectRatio, "When provided a batched transfer unit operation and an AspectRatio, the aspect ratio will be used for the plotted weighing timeline:"},
      {
        PlotWeighingTimeline[
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          AspectRatio -> 0.3
        ],
        PlotWeighingTimeline[
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          AspectRatio -> 0.7
        ]
      },
      {_Column..}
    ],
    Test[
      "An aspect ratio can be specified for multiple transfer unit operations:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        AspectRatio -> 0.7
      ],
      {_Column..}
    ],

    Example[
      {Options, ImageSize, "When provided a batched transfer unit operation and an ImageSize, the plotted weighing timeline will be plotted at the indicated size:"},
      {
        PlotWeighingTimeline[
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          ImageSize -> 500
        ],
        PlotWeighingTimeline[
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          ImageSize -> 1000
        ]
      },
      {_Column..}
    ],
    Test[
      "An image size can be specified for multiple transfer unit operations:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        ImageSize -> 500
      ],
      {_Column..}
    ],

    Example[
      {Options, PlotRange, "When provided a batched transfer unit operation and a PlotRange, the provided range will be used for the plotted weighing timeline:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        PlotRange -> {
          {
            DateObject["Sunday, November 16th, 2025, 9:38:05", "Instant", "Gregorian", "America/Chicago"],
            DateObject["Sunday, November 16th, 2025, 9:40:05", "Instant", "Gregorian", "America/Chicago"]
          },
          {0.4 Gram, 1 Gram}
        }
      ],
      _Column
    ],

    Example[
      {Options, SecondaryData, "When provided a batched transfer unit operation and SecondaryData is set to Temperature, temperature data will be plotted with weight data on the weighing timeline:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        SecondaryData -> Temperature
      ],
      _Column
    ],
    Example[
      {Options, SecondaryData, "When provided a batched transfer unit operation and SecondaryData is set to RelativeHumidity, relative humidity data will be plotted with weight data on the weighing timeline:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        SecondaryData -> RelativeHumidity
      ],
      _Column
    ],
    Test[
      "Temperature data is plotted for multiple batched transfer unit operations when SecondaryData is set to Temperature",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        SecondaryData -> Temperature
      ],
      {_Column..}
    ],
    Test[
      "Relative humidity data is plotted for multiple batched transfer unit operations when SecondaryData is set to RelativeHumidity",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        SecondaryData -> RelativeHumidity
      ],
      {_Column..}
    ],

    Example[
      {Options, SecondYColor, "When provided a batched transfer unit operation, SecondaryData is specified, and SecondaryYColor is set to a color, the secondary data will be plotted with the specified color:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        SecondaryData -> Temperature,
        SecondYColor -> Green
      ],
      _Column
    ],

    Example[
      {Options, SecondYRange, "When provided a batched transfer unit operation, SecondaryData is specified, and SecondYRange is set, the secondary data will be plotted with the specified range:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        SecondaryData -> Temperature,
        SecondYRange -> {15 Celsius, 20 Celsius}
      ],
      _Column
    ],

    Example[
      {Options, SecondYStyle, "When provided a batched transfer unit operation, SecondaryData is specified, and SecondYStyle is set, the secondary data will be plotted with the specified style:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        SecondaryData -> Temperature,
        SecondYStyle -> Dashed
      ],
      _Column
    ],

    Example[
      {Options, Zoomable, "When provided a batched transfer unit operation and Zoomable is set to False, an interactive weighing timeline plot will be displayed:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Zoomable -> True
      ],
      _Column
    ],
    Example[
      {Options, Zoomable, "When provided a batched transfer unit operation and Zoomable is set to False, a static (non-interactive) weighing timeline plot will be displayed:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Zoomable -> False
      ],
      _Column
    ],


    (* Warnings and Errors *)
    Example[
      {Messages, "Warning::UnitOperationTypeNotSupported", "If the input transfer unit operation is not a Batched unit operation, such as an Output or Calculated unit operation, then a warning will be displayed and the weighing timeline will not be plotted:"},
      PlotWeighingTimeline[Object[UnitOperation, Transfer, "Test output transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]],
      Null,
      Messages :> {Warning::UnitOperationTypeNotSupported}
    ],
    Test[
      "If a list of batched and non-batched unit operations are provided, only the batched unit operations are plotted:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test output transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]
        }
      ],
      {Null, _Column},
      Messages :> {Warning::UnitOperationTypeNotSupported}
    ],

    Example[
      {Messages, "Warning::NoWeighingToPlot", "If the input transfer unit operation did not use a balance, and therefore did not weigh any material, then a warning will be displayed and the weighing timeline will not be plotted:"},
      PlotWeighingTimeline[Object[UnitOperation, Transfer, "Test no weighing transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]],
      Null,
      Messages :> {Warning::NoWeighingToPlot}
    ],
    Test[
      "If a list of unit operations are provided, only the unit operations where a reagent was weighed out are plotted:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test no weighing transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]
        }
      ],
      {_Column, Null},
      Messages :> {Warning::NoWeighingToPlot}
    ],

    Example[
      {Messages, "Warning::IncompleteUnitOperations", "If the input transfer unit operation is not yet complete, then a warning will be displayed and the weighing timeline will not be plotted:"},
      PlotWeighingTimeline[Object[UnitOperation, Transfer, "Test incomplete transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]],
      Null,
      Messages :> {Warning::IncompleteUnitOperations}
    ],
    Test[
      "If a list of batched and non-batched unit operations are provided, only the completed batched unit operations are plotted:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test incomplete transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]
        }
      ],
      {Null, _Column},
      Messages :> {Warning::IncompleteUnitOperations}
    ],

    Example[
      {Messages, "Warning::MissingWeighingEventData", "If the input transfer unit operation is missing a requested weighing event, then a warning will be displayed and that particular weighing event or weighing event(s) will not be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test no residue weight transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventTypes -> {TareWeight, ResidueWeight}
      ],
      _Column,
      Messages :> {Warning::MissingWeighingEventData}
    ],
    Test[
      "If a list of unit operations are provided, only available weighing data will be plotted for each respective unit operation:",
      PlotWeighingTimeline[
        {
          Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
          Object[UnitOperation, Transfer, "Test no residue weight transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]
        },
        WeighingEventTypes -> {TareWeight, TransferWeight, ResidueWeight}
      ],
      {_Column, _Column},
      Messages :> {Warning::MissingWeighingEventData}
    ],


    Example[
      {Messages, "Warning::InvalidWeighingIndices", "If the requested number of plotted weighing events indicated by WeighingEventIndices is greater than the number of weighing events in the transfer unit operation, then a warning will be displayed and only available weighing events will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventIndices -> 8
      ],
      _Column,
      Messages :> {Warning::InvalidWeighingIndices}
    ],
    Example[
      {Messages, "Warning::InvalidWeighingIndices", "If any requested weighing event indices indicated by WeighingEventIndices is greater than the number of weighing events in the transfer unit operation, then a warning will be displayed and only available weighing events will be plotted:"},
      PlotWeighingTimeline[
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        WeighingEventIndices -> {1, 3, 8}
      ],
      _Column,
      Messages :> {Warning::InvalidWeighingIndices}
    ]
  },
  SetUp :> Module[
    {
      allTestObjects, existsQ,
      testBalanceObject1, testTareWeightAppearanceData1, testEmptyContainerWeightAppearanceData1,
      testTransferWeightAppearanceData1, testMaterialLossWeightAppearanceData1, testResidueWeightAppearanceData1,
      testBalanceWeightData1, testTareWeightData1, testEmptyContainerWeightData1, testTransferWeightData1,
      testMaterialLossWeightData1, testResidueWeightData1, testTransferUO1, testBalanceWeightData2,
      testTareWeightData2, testEmptyContainerWeightData2, testTransferWeightData2, testMaterialLossWeightData2,
      testResidueWeightData2, testTemperatureData1, testTemperatureData2, testRelativeHumidityData1,
      testRelativeHumidityData2, testTransferProtocol1,
      testTransferProtocol2, testTransferUO2, testOutputTransferUO1, testNoWeighingTransferUO1, testIncompleteTransferUO1, testNoResidueWeightTransferUO1,
      testBalanceObject1Packet, testTareWeightAppearanceData1Packet, testEmptyContainerWeightAppearanceData1Packet,
      testTransferWeightAppearanceData1Packet, testMaterialLossWeightAppearanceData1Packet,
      testResidueWeightAppearanceData1Packet, generateTestWeightLogData, generateTestEnvironmentalData, tareWeight1,
      testTransferUO1StartDate, testTransferUO1EndDate, emptyContainerWeight1, transferWeight1, materialLossWeight1,
      residueWeight1, testBalanceWeightLog1, testTareWeightLog1, testEmptyContainerWeightLog1, testTransferWeightLog1,
      testMaterialLossWeightLog1, testResidueWeightLog1, testTemperatureLog1, testRelativeHumidityLog1,
      testTransferUO2StartDate, testTransferUO2EndDate, tareWeight2, emptyContainerWeight2, transferWeight2,
      materialLossWeight2, residueWeight2, testBalanceWeightLog2, testTareWeightLog2, testEmptyContainerWeightLog2,
      testTransferWeightLog2, testMaterialLossWeightLog2, testResidueWeightLog2, testTemperatureLog2,
      testRelativeHumidityLog2, testBalanceWeightData1Packet, testTareWeightData1Packet,
      testEmptyContainerWeightData1Packet, testTransferWeightData1Packet, testMaterialLossWeightData1Packet,
      testResidueWeightData1Packet, testTransferUO1Packet, testBalanceWeightData2Packet, testTareWeightData2Packet,
      testEmptyContainerWeightData2Packet, testTransferWeightData2Packet, testMaterialLossWeightData2Packet,
      testResidueWeightData2Packet, testTemperatureData1Packet, testTemperatureData2Packet,
      testRelativeHumidityData1Packet, testRelativeHumidityData2Packet, testTransferProtocol1Packet, testTransferProtocol2Packet, testTransferUO2Packet,
      testOutputTransferUO1Packet, testNoWeighingTransferUO1Packet, testIncompleteTransferUO1Packet, testNoResidueWeightTransferUO1Packet
    },

    $CreatedObjects={};

    allTestObjects = {
      Object[Instrument, Balance, "Test balance 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Appearance, "Test tare weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Appearance, "Test empty container weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Appearance, "Test transfer weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Appearance, "Test material loss weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Appearance, "Test residue weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test balance weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test tare weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test empty container weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test transfer weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test material loss weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test residue weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test balance weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test tare weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test empty container weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test transfer weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test material loss weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Weight, "Test residue weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Temperature, "Test temperature data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, Temperature, "Test temperature data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, RelativeHumidity, "Test relative humidity data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[Data, RelativeHumidity, "Test relative humidity data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[UnitOperation, Transfer, "Test output transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[UnitOperation, Transfer, "Test no weighing transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[UnitOperation, Transfer, "Test incomplete transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
      Object[UnitOperation, Transfer, "Test no residue weight transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]
    };

    existsQ = DatabaseMemberQ[allTestObjects];

    Quiet[EraseObject[PickList[allTestObjects, existsQ], Force -> True, Verbose -> False]];

    (* Reserve IDs for test objects. *)
    {
      testBalanceObject1,
      testTareWeightAppearanceData1,
      testEmptyContainerWeightAppearanceData1,
      testTransferWeightAppearanceData1,
      testMaterialLossWeightAppearanceData1,
      testResidueWeightAppearanceData1,
      testBalanceWeightData1,
      testTareWeightData1,
      testEmptyContainerWeightData1,
      testTransferWeightData1,
      testMaterialLossWeightData1,
      testResidueWeightData1,
      testBalanceWeightData2,
      testTareWeightData2,
      testEmptyContainerWeightData2,
      testTransferWeightData2,
      testMaterialLossWeightData2,
      testResidueWeightData2,
      testTemperatureData1,
      testTemperatureData2,
      testRelativeHumidityData1,
      testRelativeHumidityData2,
      testTransferProtocol1,
      testTransferProtocol2,
      testTransferUO1,
      testTransferUO2,
      testOutputTransferUO1,
      testNoWeighingTransferUO1,
      testIncompleteTransferUO1,
      testNoResidueWeightTransferUO1
    } = CreateID[
      {
        Object[Instrument, Balance],
        Object[Data, Appearance],
        Object[Data, Appearance],
        Object[Data, Appearance],
        Object[Data, Appearance],
        Object[Data, Appearance],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Weight],
        Object[Data, Temperature],
        Object[Data, Temperature],
        Object[Data, RelativeHumidity],
        Object[Data, RelativeHumidity],
        Object[Protocol, Transfer],
        Object[Protocol, Transfer],
        Object[UnitOperation, Transfer],
        Object[UnitOperation, Transfer],
        Object[UnitOperation, Transfer],
        Object[UnitOperation, Transfer],
        Object[UnitOperation, Transfer],
        Object[UnitOperation, Transfer]
      }
    ];

    (* Set up a test balance. *)
    testBalanceObject1Packet = <|
      Object -> testBalanceObject1,
      Name -> "Test balance 1 for PlotWeighingTimeline testing " <> $SessionUUID,
      Type -> Object[Instrument, Balance]
    |>;

    (* Set up test weight appearance data object packets. *)
    {
      testTareWeightAppearanceData1Packet,
      testEmptyContainerWeightAppearanceData1Packet,
      testTransferWeightAppearanceData1Packet,
      testMaterialLossWeightAppearanceData1Packet,
      testResidueWeightAppearanceData1Packet
    } = {
      (* Images from Object[UnitOperation, Transfer, "id:mnk9jOG05Dk7"] *)
      <|
        Object -> testTareWeightAppearanceData1,
        Name -> "Test tare weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Appearance],
        UncroppedImageFile -> If[DatabaseMemberQ[Object[EmeraldCloudFile, "id:01G6nvPlL0kA"]],
          Link[Object[EmeraldCloudFile, "id:01G6nvPlL0kA"]],
          Null
        ]
      |>,
      <|
        Object -> testEmptyContainerWeightAppearanceData1,
        Name -> "Test empty container weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Appearance],
        UncroppedImageFile -> If[DatabaseMemberQ[Object[EmeraldCloudFile, "id:GmzlKjRxZD6E"]],
          Link[Object[EmeraldCloudFile, "id:GmzlKjRxZD6E"]],
          Null
        ]
      |>,
      <|
        Object -> testTransferWeightAppearanceData1,
        Name -> "Test transfer weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Appearance],
        UncroppedImageFile -> If[DatabaseMemberQ[Object[EmeraldCloudFile, "id:pZx9jo0ApaXp"]],
          Link[Object[EmeraldCloudFile, "id:pZx9jo0ApaXp"]],
          Null
        ]
      |>,
      <|
        Object -> testMaterialLossWeightAppearanceData1,
        Name -> "Test material loss weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Appearance],
        UncroppedImageFile -> If[DatabaseMemberQ[Object[EmeraldCloudFile, "id:9RdZXv9DJBdL"]],
          Link[Object[EmeraldCloudFile, "id:9RdZXv9DJBdL"]],
          Null
        ]
      |>,
      <|
        Object -> testResidueWeightAppearanceData1,
        Name -> "Test residue weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Appearance],
        UncroppedImageFile -> If[DatabaseMemberQ[Object[EmeraldCloudFile, "id:9RdZXv9DJBZJ"]],
          Link[Object[EmeraldCloudFile, "id:9RdZXv9DJBZJ"]],
          Null
        ]
      |>
    };

    (* Mock up some test data based on actual measurements. *)

    (* Set up helpers to generate test weight data and test secondary data. *)
    generateTestWeightLogData[startDate: _DateObject, endDate: _DateObject] := generateTestWeightLogData[startDate, {}, endDate];

    generateTestWeightLogData[
      startDate: _DateObject,
      weightEvents: {{WeighingEventTypeP, GreaterEqualP[0 Milligram], _DateObject}..}|{},
      endDate: _DateObject
    ] := Module[
      {
        weightMeasurementRate, fullDuration, numberOfTimepoints, weighingTimepoints, startingWeight, endingWeight,
        fullWeighingEventsList, priorWeighingEventList, weighingEventList, followingWeighingEventList,
        weightTransitions, generateWeightPoint, weightValues, normalWeightLog, weightLog, weighingEventLogs
      },

      (* Create timepoints from the start of the balance weight log to the end of the balance weight log. *)
      weightMeasurementRate = 15 Second (* 100 Millisecond *);
      fullDuration = endDate - startDate;
      numberOfTimepoints = fullDuration/(weightMeasurementRate);
      weighingTimepoints = Table[startDate + (i * weightMeasurementRate), {i, 0, numberOfTimepoints}];

      (* Determine the starting and ending weight for the balance weight log. *)
      {
        startingWeight,
        endingWeight
      } = If[Length[weightEvents] == 0,
        {
          0 Milligram,
          0 Milligram
        },
        {
          weightEvents[[1, 2]],
          weightEvents[[-1, 2]]
        }
      ];

      (* Gather information for each weighing event that have the prior weighing event and following weighing event in a list. *)
      fullWeighingEventsList = Append[Prepend[weightEvents, {Null, startingWeight, startDate}], {Null, endingWeight, endDate}];
      {
        priorWeighingEventList,
        weighingEventList,
        followingWeighingEventList
      } = Transpose[
        Table[fullWeighingEventsList[[i;;i+2]], {i, 1, Length[weightEvents]}]
      ];

      (* Note each weight, when that weight reading starts, and when that weight reading ends for the balance weight log. *)
      weightTransitions = If[Length[weightEvents] > 0,
        MapThread[
          Function[{priorWeighingEventInfo, weighingEventInfo, followingWeighingEventInfo},
            Module[
              {
                priorEventType, priorWeight, priorEventStartDate, eventType, newWeight, eventStartDate, followingEventType, followingWeight,
                followingEventStartDate, priorEventEndDate, eventEndDate
              },

              (* Unpack input information. *)
              {priorEventType, priorWeight, priorEventStartDate} = priorWeighingEventInfo;
              {eventType, newWeight, eventStartDate} = weighingEventInfo;
              {followingEventType, followingWeight, followingEventStartDate} = followingWeighingEventInfo;

              (* Determine end dates for measurements to make sure we don't transition, mid-measurement. *)
              {priorEventEndDate, eventEndDate} = Map[
                Function[{startTime}, startTime + 1 Minute],
                {priorEventStartDate, eventStartDate}
              ];

              (* If the weighing event is TransferWeight, then make steps to mimic adding material. Otherwise, just make our single transition.*)
              If[MatchQ[eventType, TransferWeight],
                Module[{transitionStartDate, firstTransitionThirdsDuration, weightJumpInterval},
                  (* Determine when we start the transition to the transfer weight. *)
                  transitionStartDate = priorEventEndDate + ((eventStartDate - priorEventEndDate)/2);
                  (* Break up transition duration into thirds and weight difference into thirds. *)
                  firstTransitionThirdsDuration = (eventStartDate - transitionStartDate)/3;
                  weightJumpInterval = (newWeight - priorWeight)/3;

                  (* Move weight up by 1/3 of final transfer weight two times, mimicking three additions to reach transfer weight. *)
                  Sequence@@{
                    {newWeight - (2*weightJumpInterval), transitionStartDate, transitionStartDate + firstTransitionThirdsDuration},
                    {newWeight - weightJumpInterval, transitionStartDate + firstTransitionThirdsDuration, transitionStartDate + (2*firstTransitionThirdsDuration)},
                    {newWeight, transitionStartDate + (2*firstTransitionThirdsDuration), eventEndDate + ((followingEventStartDate - eventEndDate)/2)}
                  }
                ],
                {
                  newWeight,
                  priorEventEndDate + ((eventStartDate - priorEventEndDate)/2),
                  eventEndDate + ((followingEventStartDate - eventEndDate)/2)
                }
              ]
            ]
          ],
          {
            priorWeighingEventList,
            weighingEventList,
            followingWeighingEventList
          }
        ],
        Null
      ];

      (* Make a helper to determine a weight based on the timepoint and the weighing events. *)
      generateWeightPoint[weighingTimepoint_DateObject] := If[Length[weightEvents] > 0,
        Piecewise[
          {
            {startingWeight, weighingTimepoint < startDate},
            {startingWeight, startDate <= weighingTimepoint < weightTransitions[[1, 2]]},
            Sequence @@ Map[
              {#1[[1]], #1[[2]] <= weighingTimepoint < #1[[3]]}&,
              weightTransitions
            ],
            {endingWeight, weightTransitions[[-1, 3]] <= weighingTimepoint < endDate},
            {endingWeight, weighingTimepoint >= endDate}
          }
        ],
        startingWeight
      ];

      (* Generate weight values with the weighing timepoints and combine into a balance weight log. *)
      weightValues = Map[generateWeightPoint, weighingTimepoints];
      normalWeightLog = Transpose[{weighingTimepoints, weightValues}];
      weightLog = QuantityArray[normalWeightLog];

      (* Walk through each weighing event, checking the balance log and grabbing the weight logs for each weighing event. *)
      weighingEventLogs = Map[
        QuantityArray[Cases[normalWeightLog, {RangeP[#, # + 1 Minute], _}]]&,
        weightEvents[[All, 3]]
      ];

      {
        weightLog,
        weighingEventLogs
      }
    ];

    generateTestEnvironmentalData[
      targetValue: GreaterEqualP[0 Kelvin] | GreaterEqualP[0 Percent],
      maxVariance: GreaterEqualP[0 Kelvin] | GreaterEqualP[0 Percent],
      startDate: _DateObject,
      endDate: _DateObject
    ] := Module[{fullDuration, numberOfTimepoints, weighingTimepoints, unitlessVariance, varianceUnit},
      (* Create timepoints from the start to the end of the temperature log. *)
      fullDuration = endDate - startDate;
      numberOfTimepoints = fullDuration/(1 Minute);
      weighingTimepoints = Table[startDate + (i * 1 Minute), {i, 0, numberOfTimepoints}];

      (* Convert max variance to Celsius or Percent and remove units for randomization. *)
      {unitlessVariance, varianceUnit} = If[MatchQ[targetValue, GreaterEqualP[0 Kelvin]],
        {QuantityMagnitude[UnitConvert[maxVariance, Celsius]], Celsius},
        {QuantityMagnitude[UnitConvert[maxVariance, Percent]], Percent}
      ];

      (* Random walk the temperature around the target temperature based on the max variance. *)
      QuantityArray[
        Map[
          {#, targetValue + (RandomReal[{-unitlessVariance, unitlessVariance}] * varianceUnit)}&,
          weighingTimepoints
        ]
      ]
    ];

    (* Generate test data using helper functions. *)
    (* Based on Object[UnitOperation, Transfer, "id:mnk9jOG05Dk7"] *)
    {testTransferUO1StartDate, testTransferUO1EndDate} = {
      DateObject["Sunday, November 16th, 2025, 9:36:34", "Instant", "Gregorian", "America/Chicago"],
      DateObject["Sunday, November 16th, 2025, 9:55:23", "Instant", "Gregorian", "America/Chicago"]
    };

    {
      tareWeight1, emptyContainerWeight1, transferWeight1, materialLossWeight1, residueWeight1
    } = {
      5.05349 Milligram, 637.488 Milligram, 8.15381 Gram, 5.06871 Milligram, 637.613 Milligram
    };

    {
      testBalanceWeightLog1,
      {
        testTareWeightLog1, testEmptyContainerWeightLog1, testTransferWeightLog1,
        testMaterialLossWeightLog1, testResidueWeightLog1
      }
    } = generateTestWeightLogData[
      testTransferUO1StartDate,
      {
        {TareWeight, tareWeight1, DateObject["Sunday, November 16th, 2025, 9:36:34", "Instant", "Gregorian", "America/Chicago"]},
        {EmptyContainerWeight, emptyContainerWeight1, DateObject["Sunday, November 16th, 2025, 9:39:05", "Instant", "Gregorian", "America/Chicago"]},
        {TransferWeight, transferWeight1, DateObject["Sunday, November 16th, 2025, 9:47:12", "Instant", "Gregorian", "America/Chicago"]},
        {MaterialLossWeight, materialLossWeight1, DateObject["Sunday, November 16th, 2025, 9:49:45", "Instant", "Gregorian", "America/Chicago"]},
        {ResidueWeight, residueWeight1, DateObject["Sunday, November 16th, 2025, 9:54:24", "Instant", "Gregorian", "America/Chicago"]}
      },
      testTransferUO1EndDate
    ];

    {testTemperatureLog1, testRelativeHumidityLog1} = Map[
      generateTestEnvironmentalData[Sequence@@#]&,
      {
        {18.10 Celsius, 0.1 Celsius, DateObject["Sunday, November 16th, 2025, 9:36:34", "Instant", "Gregorian", "America/Chicago"], DateObject["Sunday, November 16th, 2025, 9:55:23", "Instant", "Gregorian", "America/Chicago"]},
        {49.95 Percent, 0.3 Percent, DateObject["Sunday, November 16th, 2025, 9:36:34", "Instant", "Gregorian", "America/Chicago"], DateObject["Sunday, November 16th, 2025, 9:55:23", "Instant", "Gregorian", "America/Chicago"]}
      }
    ];

    (* Based on Object[UnitOperation, Transfer, "id:xRO9n3XjApd6"] *)
    {testTransferUO2StartDate, testTransferUO2EndDate} = {
      DateObject["Sunday, November 16th, 2025, 11:03:40", "Instant", "Gregorian", "America/Chicago"],
      DateObject["Sunday, November 16th, 2025, 11:56:31", "Instant", "Gregorian", "America/Chicago"]
    };

    {
      tareWeight2, emptyContainerWeight2, transferWeight2, materialLossWeight2, residueWeight2
    } = {
      2.7 Milligram, 647.42 Milligram, 4.40723 Gram, 2.78554 Milligram, 650.518 Milligram
    };

    {
      testBalanceWeightLog2,
      {
        testTareWeightLog2, testEmptyContainerWeightLog2, testTransferWeightLog2,
        testMaterialLossWeightLog2, testResidueWeightLog2
      }
    } = generateTestWeightLogData[
      testTransferUO2StartDate,
      {
        {TareWeight, tareWeight2, DateObject["Sunday, November 16th, 2025, 11:10:53", "Instant", "Gregorian", "America/Chicago"]},
        {EmptyContainerWeight, emptyContainerWeight2, DateObject["Sunday, November 16th, 2025, 11:19:17", "Instant", "Gregorian", "America/Chicago"]},
        {TransferWeight, transferWeight2, DateObject["Sunday, November 16th, 2025, 11:26:26", "Instant", "Gregorian", "America/Chicago"]},
        {MaterialLossWeight, materialLossWeight2, DateObject["Sunday, November 16th, 2025, 11:30:10", "Instant", "Gregorian", "America/Chicago"]},
        {ResidueWeight, residueWeight2, DateObject["Sunday, November 16th, 2025, 11:39:14", "Instant", "Gregorian", "America/Chicago"]}
      },
      testTransferUO2EndDate
    ];

    {testTemperatureLog2, testRelativeHumidityLog2} = Map[
      generateTestEnvironmentalData[Sequence@@#]&,
      {
        {18.5 Celsius, 0.15 Celsius, DateObject["Sunday, November 16th, 2025, 11:03:40", "Instant", "Gregorian", "America/Chicago"], DateObject["Sunday, November 16th, 2025, 11:56:31", "Instant", "Gregorian", "America/Chicago"]},
        {52.0 Percent, 1.00 Percent, DateObject["Sunday, November 16th, 2025, 11:03:40", "Instant", "Gregorian", "America/Chicago"], DateObject["Sunday, November 16th, 2025, 11:56:31", "Instant", "Gregorian", "America/Chicago"]}
      }
    ];

    (* Set up test weight data object packets. *)
    {
      testBalanceWeightData1Packet, testTareWeightData1Packet, testEmptyContainerWeightData1Packet, testTransferWeightData1Packet,
      testMaterialLossWeightData1Packet, testResidueWeightData1Packet, testBalanceWeightData2Packet, testTareWeightData2Packet,
      testEmptyContainerWeightData2Packet, testTransferWeightData2Packet, testMaterialLossWeightData2Packet,
      testResidueWeightData2Packet
    } = {
      <|
        Object -> testBalanceWeightData1,
        Name -> "Test balance weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        WeightLog -> testBalanceWeightLog1
      |>,
      <|
        Object -> testTareWeightData1,
        Name -> "Test tare weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        WeightAppearance -> Link[testTareWeightAppearanceData1],
        Weight -> tareWeight1,
        WeightLog -> testTareWeightLog1
      |>,
      <|
        Object -> testEmptyContainerWeightData1,
        Name -> "Test empty container weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        WeightAppearance -> Link[testEmptyContainerWeightAppearanceData1],
        Weight -> emptyContainerWeight1,
        WeightLog -> testEmptyContainerWeightLog1
      |>,
      <|
        Object -> testTransferWeightData1,
        Name -> "Test transfer weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        WeightAppearance -> Link[testTransferWeightAppearanceData1],
        Weight -> transferWeight1,
        WeightLog -> testTransferWeightLog1
      |>,
      <|
        Object -> testMaterialLossWeightData1,
        Name -> "Test material loss weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        WeightAppearance -> Link[testMaterialLossWeightAppearanceData1],
        Weight -> materialLossWeight1,
        WeightLog -> testMaterialLossWeightLog1
      |>,
      <|
        Object -> testResidueWeightData1,
        Name -> "Test residue weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        WeightAppearance -> Link[testResidueWeightAppearanceData1],
        Weight -> residueWeight1,
        WeightLog -> testResidueWeightLog1
      |>,
      <|
        Object -> testBalanceWeightData2,
        Name -> "Test balance weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        WeightLog -> testBalanceWeightLog2
      |>,
      <|
        Object -> testTareWeightData2,
        Name -> "Test tare weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        Weight -> tareWeight2,
        WeightLog -> testTareWeightLog2
      |>,
      <|
        Object -> testEmptyContainerWeightData2,
        Name -> "Test empty container weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        Weight -> emptyContainerWeight2,
        WeightLog -> testEmptyContainerWeightLog2
      |>,
      <|
        Object -> testTransferWeightData2,
        Name -> "Test transfer weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        Weight -> transferWeight2,
        WeightLog -> testTransferWeightLog2
      |>,
      <|
        Object -> testMaterialLossWeightData2,
        Name -> "Test material loss weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        Weight -> materialLossWeight2,
        WeightLog -> testMaterialLossWeightLog2
      |>,
      <|
        Object -> testResidueWeightData2,
        Name -> "Test residue weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Weight],
        Weight -> residueWeight2,
        WeightLog -> testResidueWeightLog2
      |>
    };

    (* Set up test environmental data objects (temperature & relative humidity). *)
    {testTemperatureData1Packet, testTemperatureData2Packet} = {
      <|
        Object -> testTemperatureData1,
        Name -> "Test temperature data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Temperature],
        TemperatureLog -> testTemperatureLog1
      |>,
      <|
        Object -> testTemperatureData2,
        Name -> "Test temperature data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, Temperature],
        TemperatureLog -> testTemperatureLog2
      |>
    };

    {testRelativeHumidityData1Packet, testRelativeHumidityData2Packet} = {
      <|
        Object -> testRelativeHumidityData1,
        Name -> "Test relative humidity data 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, RelativeHumidity],
        RelativeHumidityLog -> testRelativeHumidityLog1
      |>,
      <|
        Object -> testRelativeHumidityData2,
        Name -> "Test relative humidity data 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Data, RelativeHumidity],
        RelativeHumidityLog -> testRelativeHumidityLog2
      |>
    };

    (* Set up test transfer protocols (mainly to link streams to the transfer UOs. *)
    {testTransferProtocol1Packet, testTransferProtocol2Packet} = {
      <|
        (* Based off of Object[UnitOperation, Transfer, "id:mnk9jOG05Dk7"] *)
        Object -> testTransferProtocol1,
        Name -> "Test transfer protocol 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Protocol, Transfer],
        Replace[Streams] -> {
          If[DatabaseMemberQ[Object[Stream, "id:rea9jlZzV74o"]],
            Link[Object[Stream, "id:rea9jlZzV74o"], Protocol],
            Nothing
          ]
        }
      |>,
      <|
        (* Based off of Object[UnitOperation, Transfer, "id:xRO9n3XjApd6"] *)
        Object -> testTransferProtocol2,
        Name -> "Test transfer protocol 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[Protocol, Transfer],
        Replace[Streams] -> {
          If[DatabaseMemberQ[Object[Stream, "id:01G6nvPlLqJ4"]],
            Link[Object[Stream, "id:01G6nvPlLqJ4"], Protocol],
            Nothing
          ]
        }
      |>
    };

    (* Set up test transfer unit operation packets. *)
    {testTransferUO1Packet, testTransferUO2Packet} = {
      <|
        (* Based off of Object[UnitOperation, Transfer, "id:mnk9jOG05Dk7"] *)
        Object -> testTransferUO1,
        Name -> "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[UnitOperation, Transfer],
        UnitOperationType -> Batched,
        Protocol -> Link[testTransferProtocol1, BatchedUnitOperations],
        DateStarted -> testTransferUO1StartDate,
        DateCompleted -> testTransferUO1EndDate,
        Append[Balance] -> Link[testBalanceObject1],
        Append[BalanceLog] -> Link[testBalanceWeightData1],
        Append[TareData] -> Link[testTareWeightData1],
        Append[EmptyContainerWeightData] -> Link[testEmptyContainerWeightData1],
        Append[MeasuredTransferWeightData] -> Link[testTransferWeightData1],
        Append[MaterialLossWeightData] -> Link[testMaterialLossWeightData1],
        Append[ResidueWeightData] -> Link[testResidueWeightData1],
        Append[EnvironmentalData] -> {Link[testTemperatureData1], Link[testRelativeHumidityData1]}
      |>,
      <|
        (* Based off of Object[UnitOperation, Transfer, "id:xRO9n3XjApd6"] *)
        Object -> testTransferUO2,
        Name -> "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID,
        Type -> Object[UnitOperation, Transfer],
        UnitOperationType -> Batched,
        Protocol -> Link[testTransferProtocol2, BatchedUnitOperations],
        DateStarted -> testTransferUO2StartDate,
        DateCompleted -> testTransferUO2EndDate,
        Append[Balance] -> Link[testBalanceObject1],
        Append[BalanceLog] -> Link[testBalanceWeightData2],
        Append[TareData] -> Link[testTareWeightData2],
        Append[EmptyContainerWeightData] -> Link[testEmptyContainerWeightData2],
        Append[MeasuredTransferWeightData] -> Link[testTransferWeightData2],
        Append[MaterialLossWeightData] -> Link[testMaterialLossWeightData2],
        Append[ResidueWeightData] -> Link[testResidueWeightData2],
        Append[EnvironmentalData] -> {Link[testTemperatureData2], Link[testRelativeHumidityData2]}
      |>
    };

    testOutputTransferUO1Packet = <|
      Object -> testOutputTransferUO1,
      Name -> "Test output transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID,
      Type -> Object[UnitOperation, Transfer],
      UnitOperationType -> Output
    |>;

    testNoWeighingTransferUO1Packet = <|
      Object -> testNoWeighingTransferUO1,
      Name -> "Test no weighing transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID,
      Type -> Object[UnitOperation, Transfer],
      UnitOperationType -> Batched
    |>;

    testIncompleteTransferUO1Packet = <|
      Object -> testIncompleteTransferUO1,
      Name -> "Test incomplete transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID,
      Type -> Object[UnitOperation, Transfer],
      UnitOperationType -> Batched,
      Append[Balance] -> Link[testBalanceObject1]
    |>;

    testNoResidueWeightTransferUO1Packet = <|
      Object -> testNoResidueWeightTransferUO1,
      Name -> "Test no residue weight transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID,
      Type -> Object[UnitOperation, Transfer],
      UnitOperationType -> Batched,
      Append[Balance] -> Link[testBalanceObject1],
      DateStarted -> testTransferUO1StartDate,
      DateCompleted -> testTransferUO1EndDate,
      Append[Balance] -> Link[testBalanceObject1],
      Append[BalanceLog] -> Link[testBalanceWeightData1],
      Append[TareData] -> Link[testTareWeightData1],
      Append[EmptyContainerWeightData] -> Link[testEmptyContainerWeightData1],
      Append[MeasuredTransferWeightData] -> Link[testTransferWeightData1],
      Append[MaterialLossWeightData] -> Link[testMaterialLossWeightData1],
      Append[EnvironmentalData] -> {Link[testTemperatureData1], Link[testRelativeHumidityData1]}
    |>;

    (* Upload all packets. *)
    Upload[
      {
        testBalanceObject1Packet, testTareWeightAppearanceData1Packet,
        testEmptyContainerWeightAppearanceData1Packet,
        testTransferWeightAppearanceData1Packet,
        testMaterialLossWeightAppearanceData1Packet,
        testResidueWeightAppearanceData1Packet, testBalanceWeightData1Packet, testTareWeightData1Packet,
        testEmptyContainerWeightData1Packet, testTransferWeightData1Packet, testMaterialLossWeightData1Packet,
        testResidueWeightData1Packet, testTransferUO1Packet, testBalanceWeightData2Packet, testTareWeightData2Packet,
        testEmptyContainerWeightData2Packet, testTransferWeightData2Packet, testMaterialLossWeightData2Packet,
        testResidueWeightData2Packet, testTemperatureData1Packet, testTemperatureData2Packet, testRelativeHumidityData1Packet, testRelativeHumidityData2Packet, testTransferProtocol1Packet, testTransferProtocol2Packet, testTransferUO2Packet, testOutputTransferUO1Packet, testNoWeighingTransferUO1Packet, testIncompleteTransferUO1Packet,
        testNoResidueWeightTransferUO1Packet
      }
    ];
  ],
  TearDown :> (
    Module[{allTestObjects, existsQ},
      allTestObjects = {
        Object[Instrument, Balance, "Test balance 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Appearance, "Test tare weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Appearance, "Test empty container weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Appearance, "Test transfer weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Appearance, "Test material loss weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Appearance, "Test residue weight appearance data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test balance weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test tare weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test empty container weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test transfer weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test material loss weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test residue weight data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test balance weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test tare weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test empty container weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test transfer weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test material loss weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Weight, "Test residue weight data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Temperature, "Test temperature data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, Temperature, "Test temperature data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, RelativeHumidity, "Test relative humidity data 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[Data, RelativeHumidity, "Test relative humidity data 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[UnitOperation, Transfer, "Test batched transfer unit operation 2 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[UnitOperation, Transfer, "Test output transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[UnitOperation, Transfer, "Test no weighing transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[UnitOperation, Transfer, "Test incomplete transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID],
        Object[UnitOperation, Transfer, "Test no residue weight transfer unit operation 1 for PlotWeighingTimeline testing " <> $SessionUUID]
      };

      existsQ = DatabaseMemberQ[allTestObjects];

      Quiet[EraseObject[PickList[allTestObjects, existsQ], Force -> True, Verbose -> False]];

      EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
    ];
  )
];