(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* PlotWeighingTimeline *)


(* ::Subsubsection::Closed:: *)
(* PlotWeighingTimeline Patterns *)

(* ::Subsubsubsection::Closed:: *)
(* WeighingEventTypeP *)

(* Patterns package is loaded after Plot package, so need to define input pattern here. *)
ECL`Authors[WeighingEventTypeP]:={"taylor.hochuli"};
WeighingEventTypeP = (TareWeight | EmptyContainerWeight | TransferWeight | MaterialLossWeight | ResidueWeight);


(* ::Subsubsection::Closed:: *)
(* PlotWeighingTimeline Options *)

DefineOptions[PlotWeighingTimeline,
  Options :> {
    (* General Options *)
    {
      OptionName -> SummaryTable,
      Default -> True,
      Description -> "Determine if a summary table with weighing event information is generated and displayed. Otherwise, weighing events will be listed in the legend.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "General"
    },
    IndexMatching[
      IndexMatchingInput -> "transfer unit operations",
      {
        OptionName -> WeighingEventIndices,
        Default -> All,
        Description -> "Determine how many or which specific weighing events are displayed. All will include all weighing events and None will plot no weighing events. Setting this to an integer will display that number of weighing events starting with the first weighing event. Setting this to a list of integers will display the weighing events corresponding to those indices.",
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Enumeration,
            Pattern :> (All | None)
          ],
          Widget[
            Type -> Number,
            Pattern :> GreaterP[0]
          ],
          Adder[
            Widget[
              Type -> Number,
              Pattern :> GreaterP[0]
            ]
          ]
        ],
        Category -> "General"
      },
      {
        OptionName -> WeighingEventTypes,
        Default -> All,
        Description -> "Determine which weighing event types are plotted. All will include all weighing event types while None will plot no weighing events.",
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Enumeration,
            Pattern :> (All | None | WeighingEventTypeP)
          ],
          Adder[
            Widget[
              Type -> Enumeration,
              Pattern :> WeighingEventTypeP
            ]
          ]
        ],
        Category -> "General"
      }
    ],

    (* Plot Options *)
    IndexMatching[
      IndexMatchingInput -> "transfer unit operations",
      ModifyOptions[
        EmeraldDateListPlot,
        PlotLabel,
        Default -> Automatic,
        ResolutionDescription -> "If set to Automatic, plot label is set to 'Weight Data for <unit operation object>'.",
        Widget -> Widget[
          Type -> Expression,
          Pattern :> None|_String|_Pane|_Style|Automatic,
          Size -> Line
        ],
        Category -> "Plot Style"
      ]
    ],
    ModifyOptions[
      EmeraldDateListPlot,
      AspectRatio,
      Default -> 0.3,
      Category -> "Plot Style"
    ],
    ModifyOptions[
      EmeraldDateListPlot,
      ImageSize,
      Default -> 1000,
      Category -> "Plot Style"
    ],
    IndexMatching[
      IndexMatchingInput -> "transfer unit operations",
      ModifyOptions[
        EmeraldDateListPlot,
        PlotRange,
        Default -> Automatic,
        Description -> "PlotRange specification for the primary data. Automatic will use pre-recorded weight, temperature, and relative humidity data logs while All will pull additional data from sensors if it is not available in the pre-recorded data logs and the Sensors package is loaded.",
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, All]],
          {
            "X Range" -> Alternatives[
              Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, All]],
              {
                "X Range Minimum" -> Alternatives[
                  Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, All]],
                  Widget[Type -> Date, Pattern :> _?DateObjectQ, PatternTooltip -> "Any valid date.", TimeSelector -> True]
                ],
                "X Range Maximum" -> Alternatives[
                  Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, All]],
                  Widget[Type -> Date, Pattern :> _?DateObjectQ, PatternTooltip -> "Any valid date.", TimeSelector -> True]
                ]
              }
            ],
            "Y Range" -> Alternatives[
              Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, All]],
              {
                "Y Range Minimum" -> Alternatives[
                  Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, All]],
                  Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]],
                  Widget[Type -> Expression, Pattern :> _?UnitsQ, Size -> Word, PatternTooltip -> "Any valid quantity that matches _?UnitsQ."]
                ],
                "Y Range Maximum" -> Alternatives[
                  Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, All]],
                  Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]],
                  Widget[Type -> Expression, Pattern :> _?UnitsQ, Size -> Word, PatternTooltip -> "Any valid quantity that matches _?UnitsQ."]
                ]
              }
            ]
          }
        ],
        Category -> "Plot Style"
      ]
    ],

    (* Secondary Data Options *)
    {
      OptionName -> SecondaryData,
      Default -> Null,
      Description -> "Additional field to display along with the primary data",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> (Temperature | RelativeHumidity)
      ],
      Category -> "Secondary Data"
    },
    {
      OptionName -> SecondYColor,
      Default -> Automatic,
      Description -> "Color to associate with second-y data.",
      ResolutionDescription -> "Use default color scheme",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> (Automatic | ColorP)
      ],
      Category -> "Secondary Data"
    },
    IndexMatching[
      IndexMatchingInput -> "transfer unit operations",
      ModifyOptions[
        EmeraldDateListPlot,
        SecondYRange,
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]],
          {
            "Y Minimum" -> Alternatives[
              Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]],
              Widget[Type -> Expression, Pattern :> _?UnitsQ, Size -> Line, PatternTooltip -> "Any valid number or quantity."]
            ],
            "Y Maximum" -> Alternatives[
              Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]],
              Widget[Type -> Expression, Pattern :> _?UnitsQ, Size -> Line, PatternTooltip -> "Any valid number or quantity."]
            ]
          }
        ],
        Category -> "Secondary Data"
      ]
    ],
    ModifyOptions[
      EmeraldDateListPlot,
      SecondYStyle,
      Category -> "Secondary Data"
    ]
  },
  SharedOptions :> {
    ZoomableOption, 
    OutputOption,
    CacheOption, 
    SimulationOption
  }
];


(* ::Subsubsection::Closed:: *)
(* PlotWeighingTimeline Messages *)

Warning::UnitOperationTypeNotSupported = "The transfer unit operations, `1`, at indices, `2`, are of type `3` which is not supported and therefore will not be plotted. Only Batched transfer unit operations are currently supported.";
Warning::NoWeighingToPlot = "The transfer unit operations, `1`, at indices, `2`, do not use a balance and therefore do not have weighing data. These transfer unit operations will not be plotted.";
Warning::IncompleteUnitOperations = "The transfer unit operations, `1`, at indices, `2`, are not yet complete. These transfer unit operations will not be plotted.";
Warning::MissingWeighingEventData = "The transfer unit operations, `1`, at indices, `2`, do not have data for weighing events, `3`. Those weighing events will not be plotted for their respective unit operations.";
Warning::InvalidWeighingIndices = "The transfer unit operations, `1`, at indices, `2`, do not have data for requested weighing event indices, `3`, since they only have, `4`, weighing events to plot for the requested weighing event types. Invalid event indices will not be displayed.";

(* ::Subsubsection::Closed:: *)
(* PlotWeighingTimeline Source *)

(* Unit Operation Input *)

PlotWeighingTimeline[
  myUnitOperations: ListableP[ObjectP[Object[UnitOperation, Transfer]]],
  myOps: OptionsPattern[PlotWeighingTimeline]
] := Module[
  {
    outputSpecification, output, gatherTests, messages, listedOptions, safeOptions, safeOptionTests, inheritedCache, simulation,
    listedTransferUOs, unitOperationFields, weighingEventFields, cacheBall, inputPlotLabels, inputPlotRange,
    inputSecondYRange, inputWeighingEvents, inputWeighingIndices, resolvedPlotLabels,
    expandedPlotRanges, expandedSecondaryPlotRanges, expandedWeighingEvents,
    expandedWeighingIndices, uoTypes,
    balances, endDates,
    tareDataObjects, emptyContainerDataObjects, transferWeightDataObjects,
    materialLossDataObjects, residueDataObjects, nonBatchedTransferUOs, batchedTransferUOs, uoTypeTest,
    noWeighingTransferUOs, weighingTransferUOs,
    uoBalanceTest, incompleteTransferUOs, completeTransferUOs, incompleteTransferUOTest,
    missingWeighingEventTransferUOs,
    allMissingWeighingEvents, weighingEventsToPlot, invalidIndexTransferUOs, allInvalidIndices, weighingDataCounts,
    weighingIndicesToPlot,
    missingWeighingEventTest, invalidWeighingEventIndicesTest,
    plotableTransferUOs,
    uoCount, messageString, index,
    progressIndicator, weighingTimelinePlots, resolvedPlottingOptions, resolvedOptions, collapsedResolvedOptions,
    previewRule, optionsRule,
    testsRule, resultRule
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Make sure that options are in a list. *)
  listedOptions = ToList[myOps];

  (* Call SafeOptions to make sure all options match the option patterns. *)
  {safeOptions, safeOptionTests} = If[gatherTests,
    SafeOptions[PlotWeighingTimeline, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[PlotWeighingTimeline, listedOptions, AutoCorrect -> False], {}}
  ];

  (* Fetch the cache & simulation from listedOptions. *)
  inheritedCache = ToList[Lookup[listedOptions, Cache, {}]];
  simulation = Lookup[listedOptions, Simulation, Null];

  (* Put input unit operations into a list (since singleton entries are allowed. *)
  listedTransferUOs = ToList[myUnitOperations];

  (* Download all required information from each unit operations. *)
  unitOperationFields = {
    Protocol, DateStarted, DateCompleted, Balance, UnitOperationType, BalanceLog, EnvironmentalData,
    TareData, EmptyContainerWeightData, MeasuredTransferWeightData, MaterialLossWeightData,
    ResidueWeightData, UnitOperationType
  };

  weighingEventFields = {Weight, WeightLog, WeightAppearance, FirstDataPoint};

  cacheBall = Experiment`Private`FlattenCachePackets[
    Quiet[
      Download[
        listedTransferUOs,
        Evaluate[{
          Packet[Sequence@@unitOperationFields],
          Packet[Balance[{WeightSensor, EnvironmentalSensors}]],
          Packet[BalanceLog[WeightLog]],
          Packet[EnvironmentalData[{TemperatureLog, RelativeHumidityLog}]],
          Packet[TareData[Sequence@@weighingEventFields]],
          Packet[TareData[WeightAppearance][UncroppedImageFile]],
          Packet[EmptyContainerWeightData[Sequence@@weighingEventFields]],
          Packet[EmptyContainerWeightData[WeightAppearance][UncroppedImageFile]],
          Packet[MeasuredTransferWeightData[Sequence@@weighingEventFields]],
          Packet[MeasuredTransferWeightData[WeightAppearance][UncroppedImageFile]],
          Packet[MaterialLossWeightData[Sequence@@weighingEventFields]],
          Packet[MaterialLossWeightData[WeightAppearance][UncroppedImageFile]],
          Packet[ResidueWeightData[Sequence@@weighingEventFields]],
          Packet[ResidueWeightData[WeightAppearance][UncroppedImageFile]],
          Packet[Protocol[Streams][{StartTime, EndTime}]]
        }],
        Cache -> inheritedCache,
        Simulation -> simulation
      ],
      {Download::FieldDoesntExist}
    ]
  ];

  (* Option resolving *)

  (* Expand options to match number of transfer UOs if not already expanded. *)
  {
    inputPlotLabels, inputPlotRange, inputSecondYRange,
    inputWeighingEvents, inputWeighingIndices
  } = Lookup[safeOptions,
    {
      PlotLabel, PlotRange, SecondYRange,
      WeighingEventTypes, WeighingEventIndices
    }
  ];

  resolvedPlotLabels = Module[{expandedInputPlotLabels},
    expandedInputPlotLabels = If[
      MatchQ[inputPlotLabels, _List],
      inputPlotLabels,
      ConstantArray[inputPlotLabels, Length[listedTransferUOs]]
    ];

    MapThread[
      Function[{inputLabel, transferUO},
        If[MatchQ[inputLabel, Automatic],
          "Weight Data for " <> ToString[InputForm[transferUO[Object]]],
          inputLabel
        ]
      ],
      {expandedInputPlotLabels, listedTransferUOs}
    ]
  ];

  expandedPlotRanges = If[
    And[
      Length[inputPlotRange] == Length[listedTransferUOs],
      !MatchQ[
        inputPlotRange,
        {
          (Automatic|All|{Automatic|All|_?UnitsQ, Automatic|All|_?UnitsQ}),
          (Automatic|All|{Automatic|All|_?UnitsQ, Automatic|All|_?UnitsQ})
        }
      ]
    ],
    inputPlotRange,
    ConstantArray[inputPlotRange, Length[listedTransferUOs]]
  ];

  expandedSecondaryPlotRanges = If[
    And[
      Length[inputSecondYRange] == Length[listedTransferUOs],
      !MatchQ[
        inputSecondYRange,
        {
          (Automatic|{Automatic|_?UnitsQ, Automatic|_?UnitsQ}),
          (Automatic|{Automatic|_?UnitsQ, Automatic|_?UnitsQ})
        }
      ]
    ],
    inputSecondYRange,
    ConstantArray[inputSecondYRange, Length[listedTransferUOs]]
  ];

  {
    expandedWeighingEvents,
    expandedWeighingIndices
  } = Map[
    If[
      And[
        MatchQ[#, _List],
        Length[#] == Length[listedTransferUOs]
      ],
      #,
      ConstantArray[#, Length[listedTransferUOs]]
    ]&,
    {inputWeighingEvents, inputWeighingIndices}
  ];

  (* Error-checking *)
  (* Note: ObjectToString does not work for unit operations, so have to do a version here to accommodate that. *)

  (* Pull info out of cache for error checking. *)
  {
    uoTypes, balances, endDates, tareDataObjects, emptyContainerDataObjects,
    transferWeightDataObjects, materialLossDataObjects, residueDataObjects
  } = Transpose[Map[
    Lookup[
      FirstCase[cacheBall, KeyValuePattern[Object -> #[Object]]],
      {
        UnitOperationType, Balance, DateCompleted, TareData, EmptyContainerWeightData,
        TransferWeightData, MaterialLossWeightData, ResidueWeightData
      }
    ]&,
    listedTransferUOs
  ]];

  (* If the unit operation is not a Batched unit operation, such as an Output unit operation, then throw an warning and do not plot those unit operations. *)
  (* Output unit operations show the final weight values for each individual weighing, thus do not require a weight timeline. *)
  nonBatchedTransferUOs = PickList[listedTransferUOs, uoTypes, Except[Batched]];
  batchedTransferUOs = UnsortedComplement[listedTransferUOs, nonBatchedTransferUOs];

  If[Length[nonBatchedTransferUOs] > 0,
    Module[{nonBatchedIndices, nonBatchedUOTypes},
      (* Need to pick out input indices for warning. *)
      {
        nonBatchedIndices,
        nonBatchedUOTypes
      } = Transpose[PickList[
        Transpose[{Range[Length[listedTransferUOs]], uoTypes}],
        listedTransferUOs,
        ObjectP[nonBatchedTransferUOs]
      ]];

      Message[
        Warning::UnitOperationTypeNotSupported,
        Map[ToString[InputForm[#]]&, nonBatchedTransferUOs],
        nonBatchedIndices,
        nonBatchedUOTypes
      ]
    ]
  ];

  uoTypeTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = nonBatchedTransferUOs;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, affectedObjects]] <> " are batched unit operations:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[listedTransferUOs],
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, batchedTransferUOs]] <> " are batched unit operations:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* If the unit operation does not use a balance, then throw a warning and do not plot that unit operation. *)
  (* NOTE: Only using batched transfer UOs to avoid doubled warnings. *)
  noWeighingTransferUOs = PickList[
    batchedTransferUOs,
    PickList[balances, listedTransferUOs, ObjectP[batchedTransferUOs]],
    {} | NullP
  ];
  weighingTransferUOs = UnsortedComplement[batchedTransferUOs, noWeighingTransferUOs];

  If[Length[noWeighingTransferUOs] > 0,
    Module[{noWeighingIndices},
      (* Need to pick out input indices for warning. *)
      noWeighingIndices = PickList[
        Range[Length[listedTransferUOs]],
        listedTransferUOs,
        ObjectP[noWeighingTransferUOs]
      ];

      Message[
        Warning::NoWeighingToPlot,
        Map[ToString[InputForm[#]]&, noWeighingTransferUOs],
        noWeighingIndices
      ]
    ]
  ];

  uoBalanceTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = noWeighingTransferUOs;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, affectedObjects]] <> " use a balance and thus have weighing data:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[listedTransferUOs],
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, weighingTransferUOs]] <> " use a balance and thus have weighing data:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* If a unit operation has not been completed, then throw a warning and do not plot those unit operations. *)
  (* NOTE: Only using batched transfer UOs with a balance to avoid doubled warnings. *)
  incompleteTransferUOs = PickList[
    weighingTransferUOs,
    PickList[endDates, listedTransferUOs, ObjectP[weighingTransferUOs]],
    Except[_DateObject]
  ];
  completeTransferUOs = UnsortedComplement[weighingTransferUOs, incompleteTransferUOs];

  If[Length[incompleteTransferUOs] > 0,
    Module[{incompleteTransferIndices},
      (* Need to pick out input indices for warning. *)
      incompleteTransferIndices = PickList[
        Range[Length[listedTransferUOs]],
        listedTransferUOs,
        ObjectP[incompleteTransferUOs]
      ];

      Message[
        Warning::IncompleteUnitOperations,
        Map[ToString[InputForm[#]]&, incompleteTransferUOs],
        incompleteTransferIndices
      ]
    ]
  ];

  incompleteTransferUOTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = incompleteTransferUOs;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, affectedObjects]] <> " have been completed:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[listedTransferUOs],
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, completeTransferUOs]] <> " have been completed:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* If a unit operation does not have a specified weighing event, then throw a warning that it cannot be displayed. *)
  (* Also check for WeighingEventIndices error here since we already have that information. *)
  {
    missingWeighingEventTransferUOs, allMissingWeighingEvents, weighingEventsToPlot,
    invalidIndexTransferUOs, allInvalidIndices, weighingDataCounts, weighingIndicesToPlot
  } = ReplaceAll[Transpose[
    MapThread[
      Function[
        {
          transferUO, tareData, emptyContainerData, transferWeightData, materialLossData, residueData,
          requestedWeighingEvents, requestedWeighingIndices
        },
        If[MemberQ[completeTransferUOs, transferUO],
          Module[
            {
              missingEvents, dataForPlotableEvents, plotableEvents, plotableDataCount, invalidIndices,
              plotableIndices, formattedPlotableEvents
            },

            {missingEvents, plotableEvents, dataForPlotableEvents} = ReplaceAll[
              Transpose[
                MapThread[
                  Function[{key, data},
                    Which[
                      (* If weight is requested and has no data, then it is a "missing event" and will not be plotted. *)
                      And[
                        Or[
                          MatchQ[requestedWeighingEvents, All],
                          MemberQ[requestedWeighingEvents, key]
                        ],
                        Length[data] == 0
                      ],
                        {key, Null, Null},
                      (* If no weighing events are requested, then we won't plot them. *)
                      MatchQ[requestedWeighingEvents, None],
                        {Null, Null, Null},
                      (* Otherwise, we want to plot that weighing event and return the data we'll plot. *)
                      True,
                        {Null, key, data}
                    ]
                  ],
                  {
                    {TareWeight, EmptyContainerWeight, TransferWeight, MaterialLossWeight, ResidueWeight},
                    {tareData, emptyContainerData, transferWeightData, materialLossData, residueData}
                  }
                ]
              ],
              Null -> Nothing
            ];

            (* Determine how many weighing events we can plot. *)
            plotableDataCount = Length[Flatten[dataForPlotableEvents]];

            (* Make sure that we can plot all requested weighing event indices. *)
            {invalidIndices, plotableIndices} = Which[
              (* If all weighing events are requested, or none are requested, then there are no invalid indices. *)
              MatchQ[requestedWeighingIndices, (All | None)],
                {Null, requestedWeighingIndices},
              (* If a certain number of weighing events were requested, but we don't have enough data, then determine how many we can plot. *)
              And[
                MatchQ[requestedWeighingIndices, _Integer],
                plotableDataCount < requestedWeighingIndices
              ],
                {requestedWeighingIndices, plotableDataCount},
              (* If a certain number of weighing events were requested and we have enough data, then plot it all. *)
              MatchQ[requestedWeighingIndices, _Integer],
                {Null, requestedWeighingIndices},
              (* If certain indices are requested, then pull out any that are greater than the amount of data we can plot. *)
              True,
                {Cases[requestedWeighingIndices, GreaterP[plotableDataCount]], Cases[requestedWeighingIndices, LessEqualP[plotableDataCount]]}
            ];

            formattedPlotableEvents = If[Length[plotableEvents] == 0,
              None,
              plotableEvents
            ];

            Join[
              If[Length[missingEvents] > 0,
                {transferUO, missingEvents, formattedPlotableEvents},
                {Null, Null, formattedPlotableEvents}
              ],
              If[Or[Length[invalidIndices] > 0, MatchQ[invalidIndices, _Integer]],
                {transferUO, invalidIndices, plotableDataCount, plotableIndices},
                {Null, Null, Null, plotableIndices}
              ]
            ]
          ],
          {Null, Null, None, Null, Null, Null, None}
        ]
      ],
      {
        listedTransferUOs, tareDataObjects, emptyContainerDataObjects, transferWeightDataObjects,
        materialLossDataObjects, residueDataObjects, expandedWeighingEvents, expandedWeighingIndices
      }
    ]
  ], Null -> Nothing];

  If[Length[missingWeighingEventTransferUOs] > 0,
    Module[{missingWeighingEventIndices},
      (* Need to pick out input indices for warning. *)
      missingWeighingEventIndices = PickList[
        Range[Length[listedTransferUOs]],
        listedTransferUOs,
        ObjectP[missingWeighingEventTransferUOs]
      ];

      Message[
        Warning::MissingWeighingEventData,
        Map[ToString[InputForm[#]]&, missingWeighingEventTransferUOs],
        missingWeighingEventIndices,
        allMissingWeighingEvents
      ]
    ]
  ];

  missingWeighingEventTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = missingWeighingEventTransferUOs;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, affectedObjects]] <> " have data for all of the requested weighing events:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[listedTransferUOs],
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, UnsortedComplement[listedTransferUOs, affectedObjects]]] <> " have data for all of the requested weighing events:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* If the user specifies to show indices or a total number of weighing events that exceed the available *)
  (* weighing events, then throw a warning and only display the indices we can. *)
  If[Length[invalidIndexTransferUOs] > 0,
    Module[{invalidTransferUOIndices},
      (* Need to pick out input indices for warning. *)
      invalidTransferUOIndices = PickList[
        Range[Length[listedTransferUOs]],
        listedTransferUOs,
        ObjectP[invalidIndexTransferUOs]
      ];

      Message[
        Warning::InvalidWeighingIndices,
        Map[ToString[InputForm[#]]&, invalidIndexTransferUOs],
        invalidTransferUOIndices,
        allInvalidIndices,
        weighingDataCounts
      ]
    ]
  ];

  invalidWeighingEventIndicesTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = invalidIndexTransferUOs;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, affectedObjects]] <> " have data for each requested weighing event index:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[listedTransferUOs],
        Nothing,
        Test["The transfer unit operation object(s) " <> ToString[Map[ToString[InputForm[#]]&, UnsortedComplement[listedTransferUOs, affectedObjects]]] <> " have data for each requested weighing event index:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Determine which transfer unit operations that we can actually plot. *)
  (* NOTE: Can't use Complement here because duplicate transfer UOs are collapsed and thus no longer index-matched. *)
  plotableTransferUOs = UnsortedComplement[
    listedTransferUOs,
    DeleteDuplicates[Flatten[{
      nonBatchedTransferUOs,
      noWeighingTransferUOs,
      incompleteTransferUOs
    }]]
  ];

  (* Determine how many unit operations we will be plotting to keep count in progress bar and progress messages. *)
  uoCount = Length[plotableTransferUOs];

  (* Set up function to display which unit operation is being analyzed and how many are left. *)
  messageString[index_Integer] := "Plotting weight data for unit operation " <> ToString[index] <> "/" <> ToString[uoCount];

  (* Start the index at 0 and count up as we plot transfer UOs. *)
  index = 0;

  (* Set up our progress indicator bar. Subtracting 0.7 so that it better reflects that we're working on the UO rather than having completed the plot for it. *)
  (* Only show the progress bar if we're plotting more than one unit operation. *)
  progressIndicator = If[uoCount > 1,
    PrintTemporary[Dynamic[ProgressIndicator[(index - 0.7)/uoCount]]],
    Null
  ];

  (* Generate the weighing timeline plot for each valid unit operation. *)
  {weighingTimelinePlots, resolvedPlottingOptions} = Transpose[
    MapThread[
      Function[
        {
          unitOperation, resolvedPlotLabel,
          expandedPlotRange, expandedSecondaryPlotRange,
          weighingEvents, weighingIndices
        },

        If[MemberQ[plotableTransferUOs, unitOperation],
          Module[{progressMessage, uoWeightSlide},
            index += 1;
            (* Only display the progress message if we're plotting more than one unit operation. *)
            progressMessage = If[uoCount > 1,
              PrintTemporary[Row[{messageString[index], ProgressIndicator[Appearance -> "Percolate"]}]],
              Null
            ];
            uoWeightSlide = plotUOWeighingTimeline[
              unitOperation,
              ReplaceRule[
                safeOptions,
                {
                  WeighingEventTypes -> weighingEvents,
                  WeighingEventIndices -> weighingIndices,
                  PlotLabel -> resolvedPlotLabel,
                  PlotRange -> expandedPlotRange,
                  SecondYRange -> expandedSecondaryPlotRange,
                  Cache -> cacheBall
                }
              ]
            ];
            NotebookDelete[progressMessage];
            uoWeightSlide
          ],
          {
            Null,
            {
              PlotLabel -> resolvedPlotLabel,
              PlotRange -> expandedPlotRange,
              SecondYRange -> expandedSecondaryPlotRange
            }
          }
        ]
      ],
      {
        listedTransferUOs, resolvedPlotLabels, expandedPlotRanges, expandedSecondaryPlotRanges,
        weighingEventsToPlot, weighingIndicesToPlot
      }
    ]
  ];

  (* Assemble resolved options. *)
  resolvedOptions = ReplaceRule[
    safeOptions,
    {
      PlotLabel -> resolvedPlotLabels,
      PlotRange -> Lookup[resolvedPlottingOptions, PlotRange],
      SecondYRange -> Lookup[resolvedPlottingOptions, SecondYRange]
    }
  ];

  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    PlotWeighingTimeline,
    RemoveHiddenOptions[PlotWeighingTimeline, resolvedOptions],
    Messages -> False
  ];

  (* Prepare the Options result if we were asked to do so *)
  (* Return timelines in a slideshow to emulate other plotting functions. *)
  previewRule = Preview -> If[MemberQ[output, Preview],
    SlideView[weighingTimelinePlots],
    Null
  ];

  (* Prepare the Options result if we were asked to do so *)
  optionsRule = Options -> If[MemberQ[output,Options],
    collapsedResolvedOptions,
    Null
  ];

  (* Prepare the Test result if we were asked to do so *)
  testsRule = Tests -> If[MemberQ[output,Tests],
    (* Join all existing tests generated by helper functions with any additional tests *)
    Join[
      safeOptionTests,
      Flatten[
        {
          uoTypeTest,
          uoBalanceTest,
          incompleteTransferUOTest,
          missingWeighingEventTest,
          invalidWeighingEventIndicesTest
        }
      ]
    ],
    Null
  ];

  (* Prepare the standard result if we were asked for it and we can safely do so *)
  resultRule = Result -> If[MemberQ[output,Result],
    (* Return list of plots. If singular input, then return singular plot. *)
    If[Length[weighingTimelinePlots] > 1,
      weighingTimelinePlots,
      First[weighingTimelinePlots]
    ],
    Null
  ];

  outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];



(* Actual plotting function which plots each weighing timeline. *)

plotUOWeighingTimeline[
  myUnitOperation: ObjectP[Object[UnitOperation, Transfer]],
  myOps: OptionsPattern[PlotWeighingTimeline]
] := Module[
  {
    outputSpecification, output, gatherTests, messages, listedOptions, safeOptions, safeOptionTests,
    cache, simulation, summaryTableQ, weighingIndices, weighingEvents, aspectRatio, imageSize, plotLabel, plotRange,
    zoomable, secondaryData, secondYColor, secondYRange,
    secondYStyle, recordSensorAvailableQ, listedWeighingEvents, startDate, endDate,
    balances, weightSensors, balanceEnvironmentalSensors, weightLogs, temperatureLogs,
    relativeHumidityLogs, tareDataObjects, tareWeights, tareWeightLogs, tareAppearanceFiles, tareStartTimes,
    emptyContainerDataObjects, emptyContainerWeights, emptyContainerWeightLogs, emptyContainerAppearanceFiles,
    emptyContainerStartTimes, transferDataObjects, transferWeights, transferWeightLogs, transferAppearanceFiles,
    transferStartTimes, materialLossDataObjects, materialLossWeights, materialLossWeightLogs, materialLossAppearanceFiles,
    materialLossStartTimes, residueDataObjects, residueWeights, residueWeightLogs, residueAppearanceFiles,
    residueStartTimes, unitOperationType, streamPackets,
    retrievingDataMessage, temperatureLogRequestedQ,
    relativeHumidityRequestedQ, rangeStartDate, rangeEndDate, localWeightLog, targetWeightSensor,
    missingWeightSensorQ, localTemperatureLog, targetTemperatureSensor, missingTemperatureSensorQ,
    localRelativeHumidityLog, targetRelativeHumiditySensor, missingRelativeHumiditySensorQ,
    sensorsToRecord, recordSensorData, weightLog, temperatureLog, relativeHumidityLog,
    plotGenerationMessage, weightLogSpecs, weighingEventsToPlot, finalWeightLogs,
    finalDerivativeColors, finalLegendLabels, weighingTable, plotStyle, secondaryDataCoordinates,
    resolvedPlotOptions, weightPlot,
    weighingTimelinePlot
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Make sure that options are in a list. *)
  listedOptions = ToList[myOps];

  (* Call SafeOptions to make sure all options match the option patterns. *)
  {safeOptions, safeOptionTests} = If[gatherTests,
    SafeOptions[PlotWeighingTimeline, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[PlotWeighingTimeline, listedOptions, AutoCorrect -> False], {}}
  ];

  (* Fetch the cache & simulation from listedOptions. *)
  cache = ToList[Lookup[listedOptions, Cache, {}]];
  simulation = Lookup[listedOptions, Simulation, Null];

  {
    summaryTableQ, weighingIndices,
    weighingEvents, aspectRatio,
    imageSize, plotLabel,
    plotRange, zoomable,
    secondaryData, secondYColor,
    secondYRange, secondYStyle
  } = Lookup[
    safeOptions,
    {
      SummaryTable, WeighingEventIndices,
      WeighingEventTypes, AspectRatio,
      ImageSize, PlotLabel,
      PlotRange, Zoomable,
      SecondaryData, SecondYColor,
      SecondYRange, SecondYStyle
    }
  ];

  (* Determine if we can use RecordSensor for any missing data. *)
  recordSensorAvailableQ = MemberQ[$Packages, "Sensors`"];

  (* Put weighing events into a list since singleton inputs are allowed. *)
  listedWeighingEvents = If[MatchQ[weighingEvents, Except[All | None]], ToList[weighingEvents], weighingEvents];

  (* Download all required information from the unit operation. *)
  (* NOTE: This should already be downloaded from the function overload. *)
  {
    (*1*)startDate,
    (*2*)endDate,
    (*3*)balances,
    (*4*)weightSensors,
    (*5*)balanceEnvironmentalSensors,

    (*6*)weightLogs,
    (*7*)temperatureLogs,
    (*8*)relativeHumidityLogs,

    (*9*)tareDataObjects,
    (*10*)tareWeights,
    (*11*)tareWeightLogs,
    (*12*)tareAppearanceFiles,
    (*13*)tareStartTimes,

    (*14*)emptyContainerDataObjects,
    (*15*)emptyContainerWeights,
    (*16*)emptyContainerWeightLogs,
    (*17*)emptyContainerAppearanceFiles,
    (*18*)emptyContainerStartTimes,

    (*19*)transferDataObjects,
    (*20*)transferWeights,
    (*21*)transferWeightLogs,
    (*22*)transferAppearanceFiles,
    (*23*)transferStartTimes,

    (*24*)materialLossDataObjects,
    (*25*)materialLossWeights,
    (*26*)materialLossWeightLogs,
    (*27*)materialLossAppearanceFiles,
    (*28*)materialLossStartTimes,

    (*29*)residueDataObjects,
    (*30*)residueWeights,
    (*31*)residueWeightLogs,
    (*32*)residueAppearanceFiles,
    (*33*)residueStartTimes,

    (*34*)unitOperationType,
    (*35*)streamPackets
  } = Quiet[
    Download[
      myUnitOperation,
      {
        (*1*)DateStarted,
        (*2*)DateCompleted,
        (*3*)Balance,
        (*4*)Balance[WeightSensor][Object],
        (*5*)Balance[EnvironmentalSensors][Object],

        (*6*)BalanceLog[WeightLog],
        (*7*)EnvironmentalData[TemperatureLog],
        (*8*)EnvironmentalData[RelativeHumidityLog],

        (*9*)TareData,
        (*10*)TareData[Weight],
        (*11*)TareData[WeightLog],
        (*12*)TareData[WeightAppearance][UncroppedImageFile],
        (*13*)TareData[FirstDataPoint],

        (*14*)EmptyContainerWeightData,
        (*15*)EmptyContainerWeightData[Weight],
        (*16*)EmptyContainerWeightData[WeightLog],
        (*17*)EmptyContainerWeightData[WeightAppearance][UncroppedImageFile],
        (*18*)EmptyContainerWeightData[FirstDataPoint],

        (*19*)MeasuredTransferWeightData,
        (*20*)MeasuredTransferWeightData[Weight],
        (*21*)MeasuredTransferWeightData[WeightLog],
        (*22*)MeasuredTransferWeightData[WeightAppearance][UncroppedImageFile],
        (*23*)MeasuredTransferWeightData[FirstDataPoint],

        (*24*)MaterialLossWeightData,
        (*25*)MaterialLossWeightData[Weight],
        (*26*)MaterialLossWeightData[WeightLog],
        (*27*)MaterialLossWeightData[WeightAppearance][UncroppedImageFile],
        (*28*)MaterialLossWeightData[FirstDataPoint],

        (*29*)ResidueWeightData,
        (*30*)ResidueWeightData[Weight],
        (*31*)ResidueWeightData[WeightLog],
        (*32*)ResidueWeightData[WeightAppearance][UncroppedImageFile],
        (*33*)ResidueWeightData[FirstDataPoint],

        (*34*)UnitOperationType,
        (*35*)Packet[Protocol[Streams][{StartTime, EndTime}]]
      },
      Cache -> cache,
      Simulation -> simulation
    ],
    {Download::FieldDoesntExist}
  ];

  (* Set up message for getting weight data from the balance's sensors since we may need to call RecordSensor which takes a while to evaluate. *)
  retrievingDataMessage = If[NullQ[secondaryData],
    PrintTemporary[Row[{"Retrieving weight data for " <> ToString[InputForm[myUnitOperation[Object]]],ProgressIndicator[Appearance -> "Percolate"]}]],
    PrintTemporary[Row[{"Retrieving weight data & secondary data for " <> ToString[InputForm[myUnitOperation[Object]]],ProgressIndicator[Appearance -> "Percolate"]}]]
  ];

  (* Determine which logs have been requested. *)
  {temperatureLogRequestedQ, relativeHumidityRequestedQ} = Map[
    MatchQ[secondaryData, #]&,
    {Temperature, RelativeHumidity}
  ];

  (* Determine what range of data we need to plot in case our local data doesn't cover the entire unit operation or specified range. *)
  {
    rangeStartDate,
    rangeEndDate
  }= Which[
    (* If All, then go from start of UO to end of UO. *)
    MatchQ[plotRange, All],
      {startDate, endDate},
    (* If Automatic, then just use whatever data is locally available. *)
    MatchQ[plotRange, Automatic],
      {Null, Null},
    (* If x range is All, then go from start to end of UO. *)
    MatchQ[plotRange[[1]], All],
      {startDate, endDate},
    (* If x range is Automatic, then just use whatever data is locally available. *)
    MatchQ[plotRange[[1]], Automatic],
      {Null, Null},
    (* Use same rules as above for Full, Automatic, or All, but if a date is specified, then use that for fully expanded x range input. *)
    True,
      MapThread[
        Switch[#1,
          _DateString, #1,
          All, #2,
          _, (* Automatic *) Null
        ]&,
        {
          plotRange[[1]],
          {startDate, endDate}
        }
      ]
  ];

  (* Compile our local logs, determine if they will work for our plot, and if not flag them to be recorded with *)
  (* RecordSensor. Also note if we're missing the sensor and thus can't get the requested data. *)
  {
    {localWeightLog, targetWeightSensor, missingWeightSensorQ},
    {localTemperatureLog, targetTemperatureSensor, missingTemperatureSensorQ},
    {localRelativeHumidityLog, targetRelativeHumiditySensor, missingRelativeHumiditySensorQ}
  } = MapThread[
    Function[{dataRequestedQ, logs, sensorList, targetSensorType},
      Module[{dataLog, requiredRangeQ, targetSensor},
        (* Pull out the data log if we have it already downloaded. *)
        dataLog = FirstCase[logs, Except[$Failed], Null];

        (* Determine if our local data log has the requested range from the user. *)
        requiredRangeQ = And[
          !NullQ[dataLog],
          Or[
            MatchQ[rangeStartDate, Null],
            MatchQ[dataLog[[1, 1]], LessEqualP[rangeStartDate]]
          ],
          Or[
            MatchQ[rangeEndDate, Null],
            MatchQ[dataLog[[-1, 1]], GreaterEqualP[rangeEndDate]]
          ]
        ];

        (* Determine the sensor this data can be pulled from. *)
        targetSensor = FirstCase[Flatten[sensorList], ObjectP[targetSensorType], Null];

        Which[
          (* If we need the data, have the log, and it has the requested range then provide it. *)
          (* Also use the log if we don't have the requested range, but don't have RecordSensor loaded. *)
          Or[
            dataRequestedQ && !NullQ[dataLog] && requiredRangeQ,
            dataRequestedQ && !NullQ[dataLog] && Not[recordSensorAvailableQ]
          ],
            {dataLog, Null, False},
          (* If we need the data and don't have a log, or the log does not have the requested range,
            then check if we have a sensor to run RecordSensor on. *)
          dataRequestedQ && !NullQ[targetSensor] && recordSensorAvailableQ,
            {Null, targetSensor, False},
          (* If we need the data and don't have a sensor to record it from, then mark to thrown a warning. *)
          dataRequestedQ,
            {Null, Null, True},
          (* If we don't need the data, then don't retrieve it. *)
          True,
            {Null, Null, False}
        ]
      ]
    ],
    {
      {True, temperatureLogRequestedQ, relativeHumidityRequestedQ},
      {weightLogs, temperatureLogs, relativeHumidityLogs},
      {weightSensors, balanceEnvironmentalSensors, balanceEnvironmentalSensors},
      {Object[Sensor, Weight], Object[Sensor, Temperature], Object[Sensor, RelativeHumidity]}
    }
  ];

  (* Run RecordSensor on the requested sensors. *)
  sensorsToRecord = ReplaceAll[
    {targetWeightSensor, targetTemperatureSensor, targetRelativeHumiditySensor},
    Null -> Nothing
  ];

  recordSensorData = If[
    !MatchQ[sensorsToRecord, {}] && recordSensorAvailableQ,
    RecordSensor[
      sensorsToRecord,
      Span[
        startDate,
        (* If the UO hasn't finished yet, then just grab the data up until now. *)
        If[MatchQ[endDate, _DateObject],
          endDate,
          Now - 2 Second
        ]
      ],
      Output -> Values
    ],
    {}
  ];

  (* Use either the local data or data via RecordSensor for the plot. *)
  {weightLog, temperatureLog, relativeHumidityLog} = MapThread[
    Function[{localLog, targetSensor},
      Which[
        !NullQ[localLog],
          localLog,
        !NullQ[targetSensor],
          First[PickList[recordSensorData, sensorsToRecord, ObjectP[targetSensor]]],
        True,
          Null
      ]
    ],
    {
      {localWeightLog, localTemperatureLog, localRelativeHumidityLog},
      {targetWeightSensor, targetTemperatureSensor, targetRelativeHumiditySensor}
    }
  ];

  (* Remove the weight gathering message and set up a message for getting secondary data if we're getting secondary data. *)
  NotebookDelete[retrievingDataMessage];
  plotGenerationMessage = PrintTemporary[Row[{"Plotting weight data for " <> ToString[InputForm[myUnitOperation[Object]]],ProgressIndicator[Appearance -> "Percolate"]}]];

  (* Put together the specifications for the entire weight log from the sensor (a grey line). *)
  weightLogSpecs = {weightLog, Gray, "Weight Sensor Log"};

  (* Determine events that can be plotted. If the data field corresponding to a weighing event is empty, then we cannot plot it. *)
  (* Note: We also do this check in the main function, but check here too in case this function is called directly. *)
  weighingEventsToPlot = UnsortedComplement[
    ReplaceAll[listedWeighingEvents, {All -> List@@WeighingEventTypeP, None -> {}}],
    MapThread[
      Function[{key, data},
        If[MemberQ[listedWeighingEvents, key] && Length[data] == 0,
          key,
          Nothing
        ]
      ],
      {
        {TareWeight, EmptyContainerWeight, TransferWeight, MaterialLossWeight, ResidueWeight},
        {tareDataObjects, emptyContainerDataObjects, transferDataObjects, materialLossDataObjects, residueDataObjects}
      }
    ]
  ];

  (* Add weight sensor specs to weighing event specs. *)
  {
    {finalWeightLogs, finalDerivativeColors, finalLegendLabels},
    weighingTable
  } = If[And[Length[weighingEventsToPlot] > 0, MatchQ[weighingIndices, Except[None]]],
    Module[
      {
        tareBaseColor, emptyContainerBaseColor, transferBaseColor,
        materialLossBaseColor, residueBaseColor, allBaseColors, allWeights, allWeightLogs, allLabelPrefixes,
        allDataObjects, allAppearances, allStartTimes, rawWeights, rawWeightLogs, derivativeColors, legendLabels,
        dataObjects, appearanceFiles, startTimes, sortedWeights, sortedWeightLogs, sortedDerivativeColors, sortedLegendLabels,
        sortedDataObjects, sortedAppearanceFile, sortedStartTimes, filteredWeights, filteredWeightLogs, filteredDerivativeColors,
        filteredLegendLabels, filteredDataObjects, filteredAppearanceFiles, filteredStartTimes,
        filteredAppearanceButtons, filteredStreamButtons, weighingEventTable
      },

      (* Set the base colors for each step of the weighing process. Each iteration of these weights (ex. "Tare 1", "Tare 2") will be a shade of this base color. *)
      {
        tareBaseColor,
        emptyContainerBaseColor,
        transferBaseColor,
        materialLossBaseColor,
        residueBaseColor
      } = {
        RGBColor[0.368417`,0.506779`,0.709798`],
        RGBColor[0.880722`,0.611041`,0.142051`],
        RGBColor[0.560181`,0.691569`,0.194885`],
        RGBColor[0.922526`,0.385626`,0.209179`],
        RGBColor[0.528488`,0.470624`,0.701351`]
      };

      (* Filter data based on secondary input if weighing event types were specified. *)
      {
        allBaseColors, allWeights,
        allWeightLogs, allLabelPrefixes,
        allDataObjects, allAppearances,
        allStartTimes
      } = Transpose[MapThread[
        Function[{key, labelPrefix, baseColor, weight, weightLog, dataObjects, appearanceFiles, startTimes},
          If[
            And[
              MemberQ[weighingEventsToPlot, key],
              !NullQ[weightLog],
              Length[weightLog] > 0
            ],
            {
              baseColor, weight,
              weightLog, labelPrefix,
              dataObjects, appearanceFiles,
              startTimes
            },
            Nothing
          ]
        ],
        {
          {TareWeight, EmptyContainerWeight, TransferWeight, MaterialLossWeight, ResidueWeight},
          {"Tare Weight", "Empty Container Weight", "Transfer Weight", "Material Loss Weight", "Residue Weight"},
          {tareBaseColor, emptyContainerBaseColor, transferBaseColor, materialLossBaseColor, residueBaseColor},
          {tareWeights, emptyContainerWeights, transferWeights, materialLossWeights, residueWeights},
          {tareWeightLogs, emptyContainerWeightLogs, transferWeightLogs, materialLossWeightLogs, residueWeightLogs},
          {tareDataObjects, emptyContainerDataObjects, transferDataObjects, materialLossDataObjects, residueDataObjects},
          {tareAppearanceFiles, emptyContainerAppearanceFiles, transferAppearanceFiles, materialLossAppearanceFiles, residueAppearanceFiles},
          {tareStartTimes, emptyContainerStartTimes, transferStartTimes, materialLossStartTimes, residueStartTimes}
        }
      ]];

      (* For each step of the weighing process (ie. "Taring", "Empty Container", etc.), get the points that were weighed for each iteration, *)
      (* make a color varient for them, and make labels for the events. *)
      {
        rawWeights, rawWeightLogs,
        derivativeColors, legendLabels,
        dataObjects, appearanceFiles,
        startTimes
      } = Transpose[
        MapThread[
          Function[{baseColor, weights, weightLogs, labelPrefix, dataObjects, appearanceFiles, startTimes},
            (* If there is only one entry for a weighing event, then don't give it an index. *)
            If[Length[weightLogs] == 1,
              {
                weights[[1]], weightLogs[[1]],
                baseColor, labelPrefix,
                dataObjects[[1]], appearanceFiles[[1]],
                (* If we don't have a formal start time, can just use the first data point from the weight log. *)
                If[NullQ[startTimes[[1]]],
                  Normal[weightLogs[[1, 1, 1]]],
                  startTimes[[1]]
                ]
              },
              (* Otherwise, give each weighing event it's own derivative color and label index. *)
              Sequence@@MapThread[
                Function[{weight, weightLog, derivativeColor, index, dataObject, appearanceFile, startTime},
                  {
                    weight, weightLog,
                    derivativeColor, labelPrefix <> " " <> ToString[index],
                    dataObject, appearanceFile,
                    (* If we don't have a formal start time, can just use the first data point from the weight log. *)
                    If[NullQ[startTime],
                      Normal[weightLog[[1, 1]]],
                      startTime
                    ]
                  }
                ],
                {
                  weights, weightLogs,
                  ColorFade[baseColor, Length[weightLogs] + 2][[2;;-2]], Range[Length[weightLogs]],
                  dataObjects, appearanceFiles,
                  startTimes
                }
              ]
            ]
          ],
          {
            allBaseColors, allWeights,
            allWeightLogs, allLabelPrefixes,
            allDataObjects, allAppearances,
            allStartTimes
          }
        ]
      ];

      (* Sort all weighing events based on when they happened, thus in what order they will be displayed on the timeline. *)
      {
        sortedWeights, sortedWeightLogs,
        sortedDerivativeColors, sortedLegendLabels,
        sortedDataObjects, sortedAppearanceFile,
        sortedStartTimes
      } = Transpose[SortBy[
        Transpose[{
          rawWeights, rawWeightLogs,
          derivativeColors, legendLabels,
          dataObjects, appearanceFiles,
          startTimes
        }],
        #[[2, 1]]&
      ]];

      (* Pick out the weighing event indices provided by the user. *)
      {
        filteredWeights, filteredWeightLogs,
        filteredDerivativeColors, filteredLegendLabels,
        filteredDataObjects, filteredAppearanceFiles,
        filteredStartTimes
      } = Which[
        MatchQ[weighingIndices, All],
          {
            sortedWeights, sortedWeightLogs,
            sortedDerivativeColors, sortedLegendLabels,
            sortedDataObjects, sortedAppearanceFile,
            sortedStartTimes
          },
        MatchQ[weighingIndices, _Integer],
          {
            sortedWeights, sortedWeightLogs,
            sortedDerivativeColors, sortedLegendLabels,
            sortedDataObjects, sortedAppearanceFile,
            sortedStartTimes
          }[[All, ;;weighingIndices]],
        True,
          {
            sortedWeights, sortedWeightLogs,
            sortedDerivativeColors, sortedLegendLabels,
            sortedDataObjects, sortedAppearanceFile,
            sortedStartTimes
          }[[All, ToList[weighingIndices]]]
      ];

      (* Make button to open image file. *)
      filteredAppearanceButtons = Map[
        If[MatchQ[#, ObjectP[Object[EmeraldCloudFile]]],
          With[{explicitAppearanceFile = #},
            Button[
              "Open Image",
              OpenCloudFile[explicitAppearanceFile],
              ImageSize -> All,
              Method -> "Queued"
            ]
          ],
          Button[
            "Image Not Found",
            Null,
            ImageSize -> All,
            Enabled -> False
          ]
        ]&,
        filteredAppearanceFiles
      ];

      (* Make button to open stream to weighing event. *)
      filteredStreamButtons = Map[
        Module[{streamPacket, streamObject, streamTimepoint},
          streamPacket = FirstCase[
            streamPackets,
            KeyValuePattern[{StartTime -> LessEqualP[#], EndTime -> GreaterEqualP[#]}],
            Null
          ];

          {
            streamObject,
            streamTimepoint
          } = If[!NullQ[streamPacket],
            {
              Lookup[streamPacket, Object],
              (* WatchProtocol need a second input of an integer, so Round to nearest integer. *)
              (* Stream can be slightly offset from actual time, so add a buffer of 16 seconds based on testing. *)
              Round[QuantityMagnitude[
                UnitConvert[
                  # - Lookup[streamPacket, StartTime],
                  Second
                ]
              ], 1] - 16
            },
            {Null, Null}
          ];

          If[!NullQ[streamPacket],
            With[{explicitStreamObject = streamObject, explicitStreamTimepoint = streamTimepoint},
              Button[
                "Open Stream",
                WatchProtocol[explicitStreamObject, explicitStreamTimepoint],
                ImageSize -> All,
                Method -> "Queued"
              ]
            ],
            Button[
              "Stream Not Found",
              Null,
              ImageSize -> All,
              Enabled -> False
            ]
          ]
        ]&,
        filteredStartTimes
      ];

      (* If specified and appropriate, make a table with weighing event information. *)
      weighingEventTable = If[summaryTableQ && Length[filteredDerivativeColors]>0,
        PlotTable[
          Transpose[{
            Map[Framed[Magnify[Graphics[{#, Disk[]}], 0.05], FrameMargins -> 8, FrameStyle -> None]&, filteredDerivativeColors],
            filteredLegendLabels, filteredWeights,
            filteredDataObjects, filteredStartTimes,
            filteredAppearanceButtons, filteredStreamButtons
          }],
          TableHeadings -> {
            Range[Length[filteredDerivativeColors]],
            {"Icon", "Weighing Event", "Weight", "Data Object", "First Weight Time", "Image", "Stream"}
          },
          ItemSize -> {{2, Automatic, Automatic, Automatic, Automatic, Automatic, Automatic}, Automatic},
          Tooltips -> False
        ],
        Null
      ];

      {
        Transpose[
          Prepend[
            Transpose[{filteredWeightLogs, filteredDerivativeColors, filteredLegendLabels}],
            weightLogSpecs
          ]
        ],
        weighingEventTable
      }
    ],
    {
      Partition[weightLogSpecs, 1],
      Null
    }
  ];

  (* Set up the plot style. This should match the legend if that is used or the table if that is used. *)
  plotStyle = If[Length[finalDerivativeColors] > 1,
    Prepend[
      Map[Directive[#, PointSize[0.01]]&, finalDerivativeColors[[2;;]]],
      Directive[finalDerivativeColors[[1]], Opacity[0.5]]
    ],
    Directive[finalDerivativeColors[[1]], Opacity[0.5]]
  ];

  secondaryDataCoordinates = Switch[secondaryData,
    Temperature, Normal[temperatureLog],
    RelativeHumidity, Normal[relativeHumidityLog],
    _, None
  ];

  (* Make a plot of the different weight logs on top of the weight log for the balance's weight sensor from the beginning of the UO to the end. *)
  {weightPlot, resolvedPlotOptions} = EmeraldDateListPlot[
    finalWeightLogs,
    {
      PlotStyle -> plotStyle,
      Zoomable -> zoomable,
      Joined -> Prepend[ConstantArray[False, (Length[finalWeightLogs] - 1)], True],
      If[!summaryTableQ,
        Legend -> finalLegendLabels,
        Nothing
      ],
      LegendPlacement -> Right,
      PlotLabel -> plotLabel,
      AspectRatio -> aspectRatio,
      ImageSize -> imageSize,
      Tooltip -> {finalLegendLabels},
      PlotRange -> plotRange,
      SecondYCoordinates -> secondaryDataCoordinates,
      (* Color needs to be in a list to match option pattern. *)
      SecondYColors -> If[MatchQ[secondYColor, Automatic],
        secondYColor,
        ToList[secondYColor]
      ],
      SecondYRange -> secondYRange,
      SecondYStyle -> secondYStyle,
      Output -> {Result, Options}
    }
  ];

  (* Remove the plot generation message since the plot has been generated. *)
  NotebookDelete[plotGenerationMessage];

  (* Assemble plotted weighing timeline. *)
  weighingTimelinePlot = If[summaryTableQ,
    ReplaceAll[
      Column[
        {
          weightPlot,
          weighingTable
        },
        Spacings -> {1},
        Alignment -> Center
      ],
      Null -> Nothing
    ],
    weightPlot
  ];

  {weighingTimelinePlot, resolvedPlotOptions}
];
