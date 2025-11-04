(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(* PlotPeaksTable *)

DefineTests[PlotPeaksTable,
  {
    (* Basic Examples *)
    Example[
      {Basic, "When provided a peaks analysis object, a dynamic table of peak information is generated:"},
      PlotPeaksTable[Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID]],
      _DynamicModule
    ],
    Example[
      {Basic, "When provided multiple peaks analysis objects, a list of dynamic tables with peak information is generated:"},
      PlotPeaksTable[
        {
          Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test HPLC peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        }
      ],
      {_DynamicModule..}
    ],
    Example[
      {Options, Dynamic, "When provided a peaks analysis object and Dynamic is set to False, a static table of peak information is generated:"},
      PlotPeaksTable[Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID], Dynamic -> False],
      _Grid
    ],
    Example[
      {Options, Dynamic, "When provided multiple peaks analysis objects and Dynamic is set to False, a list of static tables with peak information is generated:"},
      PlotPeaksTable[
        {
          Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test HPLC peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        },
        Dynamic -> False
      ],
      {_Grid..}
    ],
    Example[
      {Basic, "When a peak analysis of NMR data is provided, the NMR splitting information will be displayed in a dynamic table:"},
      PlotPeaksTable[Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID]],
      _DynamicModule
    ],
    Test[
      "When provided multiple NMR peaks analysis objects, the NMR splitting will be displayed in dynamic tables:",
      PlotPeaksTable[
        {
          Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        }
      ],
      {_DynamicModule..}
    ],

    (* Options *)
    Example[
      {Options, Column, "When provided a peaks analysis object and peak fields are specified in Column, a dynamic table of peak information is generated which displays the submitted columns:"},
      PlotPeaksTable[Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID], Columns -> {Position, Area}],
      _DynamicModule
    ],
    Example[
      {Options, Column, "Columns are automatically determined based on the type of data used for the peak analysis:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        _DynamicModule,
        KeyValuePattern[Columns -> {Position, RelativePosition, Height, Area, RelativeArea}]
      }
    ],
    Test[
      "When provided a peaks analysis object and a single peak field is specified in Column, a dynamic table of peak information is generated which displays the submitted columns:",
      PlotPeaksTable[Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID], Columns -> Area],
      _DynamicModule
    ],
    Example[
      {Options, NMR, "When a peak analysis of NMR data is provided and NMR is set to True, the traditional (non-NMR) peak information will be displayed in a dynamic table:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        NMR -> True,
        Output -> {Result, Options}
      ],
      {
        _DynamicModule,
        KeyValuePattern[Columns -> {NMRChemicalShift, NMRNuclearIntegral, NMRMultiplicity, NMRJCoupling}]
      }
    ],
    Example[
      {Options, NMR, "When a peak analysis of NMR data is provided and NMR is set to False, the traditional (non-NMR) peak information will be displayed in a dynamic table:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        NMR -> False,
        Output -> {Result, Options}
      ],
      {
        _DynamicModule,
        KeyValuePattern[Columns -> {Position, Height, Area}]
      }
    ],
    Example[
      {Options, MaxHeight, "When MaxHeight is set, the peaks table will only show a number of elements equal to the max height at one time with the rest of the table being accessed by scrolling:"},
      PlotPeaksTable[Object[Analysis, Peaks, "Test large HPLC peak analysis for PlotPeaksTable testing " <> $SessionUUID], MaxHeight -> 100],
      _DynamicModule
    ],
    Example[
      {Options, MaxHeight, "If an analysis has over 6 peaks, MaxHeight is automatically set to 200:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test large HPLC peak analysis for PlotPeaksTable testing " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        _DynamicModule,
        KeyValuePattern[MaxHeight -> 200]
      }
    ],
    Example[
      {Options, MaxHeight, "If an analysis has fewer than 6 peaks, MaxHeight is automatically set to Null (entire table is displayed at once):"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        Output -> {Result, Options}
      ],
      {
        _DynamicModule,
        KeyValuePattern[MaxHeight -> Null]
      }
    ],
    Example[
      {Options, ConvertTableHeadings, "If ConvertTableHeadings is set to True, then the field names with common names for the data being analyzed (such as \"Retention Time\" instead of \"Position\") will be converted to show the common name in the table headings instead of the field name itself:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        ConvertTableHeadings -> True
      ],
      _DynamicModule
    ],
    Example[
      {Options, ConvertTableHeadings, "If ConvertTableHeadings is set to False, then the field names will be used in the table headings instead of the common names for those fields:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        ConvertTableHeadings -> False
      ],
      _DynamicModule
    ],

    Test[
      "If NMR is set to True and Dynamic is set to False, then a static table with NMR field peak information will be displayed:",
      PlotPeaksTable[Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID], NMR -> False, Dynamic -> False],
      _Grid
    ],
    Test[
      "When provided multiple NMR peaks analysis objects and NMR is set to False, the traditional (non-NMR) peak information will be displayed in a dynamic table:",
      PlotPeaksTable[
        {
          Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        },
        NMR -> False
      ],
      {_DynamicModule..}
    ],
    Test[
      "If NMR is set to True and Dynamic is set to False, then a static table with NMR field peak information will be displayed:",
      PlotPeaksTable[
        {
          Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        },
        NMR -> False,
        Dynamic -> False
      ],
      {_Grid..}
    ],

    Test[
      "If an output is Preview and there is more than one peak analysis object input, slides of each peaks table will be returned:",
      PlotPeaksTable[
        {
          Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        },
        Output -> Preview
      ],
      _SlideView
    ],
    Test[
      "If an output is Preview and there is only one peak analysis object input, a single peaks table will be returned:",
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        Output -> Preview
      ],
      _DynamicModule
    ],

    (* Warnings and Errors *)
    Example[
      {Message, "NoPeaksInAnalysis", "If the analysis object does not have any peaks, then a warning will be thrown and a peaks table will not be generated:"},
      PlotPeaksTable[Object[Analysis, Peaks, "Test empty peak analysis for PlotPeaksTable testing " <> $SessionUUID]],
      Null,
      Messages :> {Warning::NoPeaksInAnalysis}
    ],
    Example[
      {Message, "InvalidNMRColumns", "If Columns are specified that do not match NMR and the data type, a warning will be thrown and the invalid columns will not appear in the peaks table:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        Columns -> {Position}
      ],
      _DynamicModule,
      Messages :> {Warning::InvalidNMRColumns}
    ],
    Test[
      "If NMR peak analysis fields are entered in Columns but the reference data is not NMR data, a warning will be thrown and the invalid columns will not appear in the peaks table:",
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        Columns -> {NMRChemicalShift}
      ],
      _DynamicModule,
      Messages :> {Warning::InvalidNMRColumns}
    ],
    Test[
      "If NMR peak analysis fields are entered in Columns but NMR is set to False, a warning will be thrown and the invalid columns will not appear in the peaks table:",
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        NMR -> False,
        Columns -> {NMRChemicalShift}
      ],
      _DynamicModule,
      Messages :> {Warning::InvalidNMRColumns}
    ],
    Test[
      "If traditional peak analysis fields are entered in Columns but NMR is set to True and the reference data is NMR data, a warning will be thrown and the invalid columns will not appear in the peaks table:",
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
        NMR -> True,
        Columns -> {Position}
      ],
      _DynamicModule,
      Messages :> {Warning::InvalidNMRColumns}
    ],
    Example[
      {Message, "NoNMRAnalysisToDisplay", "If NMR is set to True, the reference data is NMR data, and NMR peak splitting information is not available, a warning will be thrown and the peaks table will use the traditional peak fields (such as Position instead of NMRChemicalShift):"},
      PlotPeaksTable[Object[Analysis, Peaks, "Test empty NMR peak analysis for PlotPeaksTable testing " <> $SessionUUID]],
      _DynamicModule,
      Messages :> {Warning::NoNMRAnalysisToDisplay}
    ],
    Example[
      {Message, "InvalidColumnInformations", "If Columns are specified which do not have information for all peaks, a warning will be thrown and the invalid columns will not appear in the peaks table:"},
      PlotPeaksTable[
        Object[Analysis, Peaks, "Test large HPLC peak analysis for PlotPeaksTable testing " <> $SessionUUID],
        Columns -> {Area, WidthRangeEnd}
      ],
      _DynamicModule,
      Messages :> {Warning::InvalidColumnInformation}
    ]
  },
  SetUp :> Module[
    {
      testHPLCData1, testHPLCData2, testLargeHPLCData, testNMRData1, testNMRData2, testEmptyData, testEmptyNMRData,
      testHPLCPeakAnalysis1, testHPLCPeakAnalysis2, testNMRPeakAnalysis1, testNMRPeakAnalysis2, testLargeHPLCPeakAnalysis,
      testEmptyPeakAnalysis, testEmptyNMRPeakAnalysis, testHPLCPeakAnalysis1Packet, testHPLCPeakAnalysis2Packet,
      testLargeHPLCPeakAnalysisPacket, testNMRPeakAnalysis1Packet, testNMRPeakAnalysis2Packet, testEmptyPeakAnalysisPacket,
      testEmptyNMRPeakAnalysisPacket
    },

    $CreatedObjects={};

    Quiet[
      EraseObject[
        {
          Object[Analysis, Peaks, "Test empty peak analysis for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test empty NMR peak analysis for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test HPLC peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test large HPLC peak analysis for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        },
        Force -> True,
        Verbose -> False
      ]
    ];

    (* Reserve IDs for test objects. *)
    {
      testHPLCData1,
      testHPLCData2,
      testLargeHPLCData,
      testNMRData1,
      testNMRData2,
      testEmptyData,
      testEmptyNMRData,
      testHPLCPeakAnalysis1,
      testHPLCPeakAnalysis2,
      testLargeHPLCPeakAnalysis,
      testNMRPeakAnalysis1,
      testNMRPeakAnalysis2,
      testEmptyPeakAnalysis,
      testEmptyNMRPeakAnalysis
    } = CreateID[
      {
        Object[Data, Chromatography],
        Object[Data, Chromatography],
        Object[Data, Chromatography],
        Object[Data, NMR],
        Object[Data, NMR],
        Object[Data, Chromatography],
        Object[Data, NMR],
        Object[Analysis, Peaks],
        Object[Analysis, Peaks],
        Object[Analysis, Peaks],
        Object[Analysis, Peaks],
        Object[Analysis, Peaks],
        Object[Analysis, Peaks],
        Object[Analysis, Peaks]
      }
    ];

    (* Set up test HPLC peak analysis object packets. *)
    {testHPLCPeakAnalysis1Packet, testHPLCPeakAnalysis2Packet, testLargeHPLCPeakAnalysisPacket} = Upload[
      {
        <|
          Object -> testHPLCPeakAnalysis1,
          Name -> "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID,
          Replace[Reference] -> {Link[testHPLCData1, AbsorbancePeaksAnalyses]},
          ReferenceField -> Absorbance,
          Replace[AbsoluteThreshold] -> {50.},
          Replace[AdjacentResolution] -> {0., 1.17647},
          Replace[Area] -> {6.19375, 9.22743},
          Replace[AreaThreshold] -> {0.},
          Replace[AsymmetryFactor] -> {0.545455, 1.33333},
          Replace[BaselineIntercept] -> {-0.0389846, -0.0389846},
          Replace[BaselineSlope] -> {0., 0.},
          Replace[Domain] -> {{0.5, 1.5}},
          Replace[HalfHeightNumberOfPlates] -> {334.01, 2751.46},
          Replace[HalfHeightResolution] -> {{0., -1.17647}, {1.17647, 0.}},
          Replace[HalfHeightWidth] -> {0.113333, 0.0466667},
          Replace[Height] -> {58.9527, 173.426},
          Replace[ParentPeak] -> {"Caffeine", "Caffeine"},
          Replace[PeakAssignment] -> {Link[Model[Molecule, "id:E8zoYvN6m61A"]], Link[Model[Molecule, "id:eGakldJvLvbB"]]},
          Replace[PeakAssignmentLibrary] -> {
            <|
              Label -> "Caffeine",
              Model -> Link[Model[Molecule, "id:E8zoYvN6m61A"]],
              Position -> 0.88, Tolerance -> 0.166667
            |>,
            <|
              Label -> "Uracil",
              Model -> Link[Model[Molecule, "id:eGakldJvLvbB"]],
              Position -> 1.04, Tolerance -> 0.166667
            |>
          },
          Replace[PeakLabel] -> {"Caffeine", "Uracil"},
          Replace[PeakRangeEnd] -> {0.973333, 1.38},
          Replace[PeakRangeStart] -> {0.766667, 0.973333},
          Replace[PeakSamples] -> {Link[Object[Sample, "id:KBL5Dvw9pBpv"]]},
          Replace[Position] -> {0.88, 1.04},
          Purity -> {
            Area -> {6.19375, 9.22743, 0.046946},
            RelativeArea -> {40.042 Percent, 59.6545 Percent, 0.303502 Percent},
            PeakLabels -> {"Caffeine", "Uracil", "Background"}
          },
          Replace[RelativeArea] -> {1., 1.4898},
          Replace[RelativePosition] -> {1., 1.18182},
          Replace[RelativeRetentionTime] -> {1., 1.18182},
          Replace[RelativeThreshold] -> {3.47},
          Replace[TailingFactor] -> {0.772727, 1.16667},
          Replace[WidthRangeEnd] -> {0.92, 1.06667},
          Replace[WidthRangeStart] -> {0.806667, 1.02},
          Replace[WidthThreshold] -> {0.001}
        |>,
        <|
          Object -> testHPLCPeakAnalysis2,
          Name -> "Test HPLC peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID,
          Replace[Reference] -> {Link[testHPLCData2, AbsorbancePeaksAnalyses]},
          ReferenceField -> Absorbance,
          Replace[AbsoluteThreshold] -> {50.},
          Replace[AdjacentResolution] -> {0., 1.17647},
          Replace[Area] -> {6.19375, 9.22743},
          Replace[AreaThreshold] -> {0.},
          Replace[AsymmetryFactor] -> {0.545455, 1.33333},
          Replace[BaselineIntercept] -> {-0.0389846, -0.0389846},
          Replace[BaselineSlope] -> {0., 0.},
          Replace[Domain] -> {{0.5, 1.5}},
          Replace[HalfHeightNumberOfPlates] -> {334.01, 2751.46},
          Replace[HalfHeightResolution] -> {{0., -1.17647}, {1.17647, 0.}},
          Replace[HalfHeightWidth] -> {0.113333, 0.0466667},
          Replace[Height] -> {58.9527, 173.426},
          Replace[ParentPeak] -> {"Uracil", "Uracil"},
          Replace[PeakAssignment] -> {
            Link[Model[Molecule, "id:E8zoYvN6m61A"]],
            Link[Model[Molecule, "id:eGakldJvLvbB"]]
          },
          Replace[PeakAssignmentLibrary] -> {
            <|
              Label -> "Caffeine",
              Model -> Link[Model[Molecule, "id:E8zoYvN6m61A"]],
              Position -> 0.88,
              Tolerance -> 0.166667
            |>,
            <|
              Label -> "Uracil",
              Model -> Link[Model[Molecule, "id:eGakldJvLvbB"]],
              Position -> 1.04,
              Tolerance -> 0.166667
            |>
          },
          Replace[PeakLabel] -> {"Caffeine", "Uracil"},
          Replace[PeakRangeEnd] -> {0.973333, 1.38},
          Replace[PeakRangeStart] -> {0.766667, 0.973333},
          Replace[PeakSamples] -> {Link[Object[Sample, "id:KBL5Dvw9pBpv"]]},
          Replace[Position] -> {0.88, 1.04},
          Purity -> {
            Area -> {6.19375, 9.22743, 0.046946},
            RelativeArea -> {40.042 Percent, 59.6545 Percent, 0.303502 Percent},
            PeakLabels -> {"Caffeine", "Uracil", "Background"}
          },
          Replace[RelativeArea] -> {0.671233, 1.},
          Replace[RelativePosition] -> {0.846154, 1.},
          Replace[RelativeRetentionTime] -> {0.846154, 1.},
          Replace[RelativeThreshold] -> {3.47},
          Replace[TailingFactor] -> {0.772727, 1.16667},
          Replace[WidthRangeEnd] -> {0.92, 1.06667},
          Replace[WidthRangeStart] -> {0.806667, 1.02},
          Replace[WidthThreshold] -> {0.}
        |>,
        <|
          Object -> testLargeHPLCPeakAnalysis,
          Name -> "Test large HPLC peak analysis for PlotPeaksTable testing " <> $SessionUUID,
          Replace[Reference] -> {Link[testHPLCData2, FluorescencePeaksAnalyses]},
          ReferenceField -> Fluorescence,
          Replace[AdjacentResolution] -> {
            0., 48.4316, 116.176, 39.7059, 4.21569, 2.10084, 1.56863, 18.8236, 2.56684, 13.9216, 27.4866, 7.23982,
            1.76471, 1.27451, 61.3725, 7.05882, 1.32353, 3.95722, 37.4332, 56.2569, 22.3529
          },
          Replace[Area] -> {
            0.0000214094, 0.0000386253, 0.0000237879, 0.0000312291, 0.000027389, 0.0000556659, 0.0000665292,
            0.0000295011, 0.0000251289, 0.0000527738, 0.0000270585, 0.0000471062, 0.0000307586, 0.0000387648,
            0.0000467544, 0.0000488748, 0.000020864, 0.0000327949, 0.0000229448, 0.0000403965, 0.0000302587
          },
          Replace[AsymmetryFactor] -> {
            0.666667, 0.75, 1.5, 0.75, 0.666667, 2., 0.8, 1., 0.666667, 0.75, 1., 2., 0.666667, 1.33333, 1.5, 0.375,
            0.666667, 1., 1.5, 0.5, 0.75
          },
          Replace[BaselineIntercept] -> {
            0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018,
            0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018, 0.525018,
            0.525018
          },
          Replace[BaselineSlope] -> {
            0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.
          },
          Replace[Domain] -> {{0.0001, 3.}},
          Replace[HalfHeightNumberOfPlates] -> {
            256192., 278409., 1.681*10^6, 1.12843*10^6, 2.27234*10^6, 712333., 182078., 2.04707*10^6, 2.9867*10^6,
            1.64399*10^6, 5.73624*10^6, 1.17806*10^6, 3.85565*10^6, 1.97945*10^6, 5.12744*10^6, 1.1021*10^6,
            5.37336*10^6, 3.78779*10^6, 6.25114*10^6, 5.24349*10^6, 4.18528*10^6
          },
          Replace[HalfHeightResolution] -> {
            {0., -48.4316, -197.53, -204.314, -250.236, -180.841, -111.918, -275.081, -305.412, -268.432, -391.504, -258.404, -364.236, -304.804, -439.412, -281.692, -452.824, -415.615, -498.353, -509.306, -491.079},
            {48.4316, 0., -116.176, -133.613, -160.098, -121.912, -79.7176, -188.054, -206.079, -188.572, -267.487, -189.78, -255.098, -219.748, -317.745, -218.105, -328.922, -306.969, -366.863, -386.245, -379.412},
            {197.53, 116.176, 0., -39.7059, -52.7059, -39.7479, -26.0358, -95.5083, -107.883, -103.824, -172.026, -117.311, -166.706, -140.196, -241.883, -158.235, -255.294, -236.043, -300.824, -329.733, -326.471},
            {204.314, 133.613, 39.7059, 0., -4.21569, -5., -4.89412, -44.1631, -50.1963, -54.9582, -97.4334, -72.8678, -99.2159, -86.1346, -161.863, -114.183, -173.039, -163.077, -210.981, -242.353, -245.799},
            {250.236, 160.098, 52.7059, 4.21569, 0., -2.10084, -3.1202, -47.5938, -55.1767, -59.9022, -113.464, -79.6641, -114., -96.2747, -189.177, -125.294, -202.588, -188.129, -248.118, -281.819, -282.549},
            {180.841, 121.912, 39.7479, 5., 2.10084, 0., -1.56863, -32.9414, -37.3111, -43.0884, -76.2898, -60.3269, -79.3279, -70.3678, -133.025, -98.7648, -142.605, -136., -175.126, -204.706, -210.074},
            {111.918, 79.7176, 26.0358, 4.89412, 3.1202, 1.56863, 0., -18.8236, -20.8697, -25.8825, -43.1552, -38.6493, -46.4451, -43.3413, -79.1305, -66.6532, -84.9618, -83.2354, -104.757, -126.177, -132.753},
            {275.081, 188.054, 95.5083, 44.1631, 47.5938, 32.9414, 18.8236, 0., -2.56684, -15.0226, -49.7647, -39.451, -56.0428, -48.5973, -124.385, -87.128, -136.578, -128.824, -177.968, -214.706, -220.543},
            {305.412, 206.079, 107.883, 50.1963, 55.1767, 37.3111, 20.8697, 2.56684, 0., -13.9216, -52.1569, -40.2521, -58.8235, -50.2941, -134., -90.8088, -147.412, -137.968, -192.941, -231.658, -236.569},
            {268.432, 188.572, 103.824, 54.9582, 59.9022, 43.0884, 25.8825, 15.0226, 13.9216, 0., -27.4866, -24.7794, -35.098, -31.1765, -97.7451, -71.4379, -108.922, -103.891, -146.863, -183.168, -190.841},
            {391.504, 267.487, 172.026, 97.4334, 113.464, 76.2898, 43.1552, 49.7647, 52.1569, 27.4866, 0., -7.23982, -13.2026, -12.1925, -96.732, -65.5686, -111.634, -104.824, -162.222, -207.883, -215.401},
            {258.404, 189.78, 117.311, 72.8678, 79.6641, 60.3269, 38.6493, 39.451, 40.2521, 24.7794, 7.23982, 0., -1.76471, -2.5, -55.4622, -44.4706, -65.042, -63.6078, -97.563, -132.314, -142.206},
            {364.236, 255.098, 166.706, 99.2159, 114., 79.3279, 46.4451, 56.0428, 58.8235, 35.098, 13.2026, 1.76471, 0., -1.27451, -75.1765, -54.0441, -88.5882, -84.492, -134.118, -178.182, -187.549},
            {304.804, 219.748, 140.196, 86.1346, 96.2747, 70.3678, 43.3413, 48.5973, 50.2941, 31.1765, 12.1925, 2.5, 1.27451, 0., -61.3725, -47.1895, -72.549, -70.3167, -110.49, -149.593, -159.664},
            {439.412, 317.745, 241.883, 161.863, 189.177, 133.025, 79.1305, 124.385, 134., 97.7451, 96.732, 55.4622, 75.1765, 61.3725, 0., -7.05882, -13.4118, -16.1497, -58.9412, -109.84, -124.902},
            {281.692, 218.105, 158.235, 114.183, 125.294, 98.7648, 66.6532, 87.128, 90.8088, 71.4379, 65.5686, 44.4706, 54.0441, 47.1895, 7.05882, 0., -1.32353, -3.80623, -29.7794, -64.4292, -76.9936},
            {452.824, 328.922, 255.294, 173.039, 202.588, 142.605, 84.9618, 136.578, 147.412, 108.922, 111.634, 65.042, 88.5882, 72.549, 13.4118, 1.32353, 0., -3.95722, -45.5294, -97.6473, -113.726},
            {415.615, 306.969, 236.043, 163.077, 188.129, 136., 83.2354, 128.824, 137.968, 103.891, 104.824, 63.6078, 84.492, 70.3167, 16.1497, 3.80623, 3.95722, 0., -37.4332, -85.8826, -101.629},
            {498.353, 366.863, 300.824, 210.981, 248.118, 175.126, 104.757, 177.968, 192.941, 146.863, 162.222, 97.563, 134.118, 110.49, 58.9412, 29.7794, 45.5294, 37.4332, 0., -56.2569, -75.7845},
            {509.306, 386.245, 329.733, 242.353, 281.819, 204.706, 126.177, 214.706, 231.658, 183.168, 207.883, 132.314, 178.182, 149.593, 109.84, 64.4292, 97.6473, 85.8826, 56.2569, 0., -22.3529},
            {491.079, 379.412, 326.471, 245.799, 282.549, 210.074, 132.753, 220.543, 236.569, 190.841, 215.401, 142.206, 187.549, 159.664, 124.902, 76.9936, 113.726, 101.629, 75.7845, 22.3529, 0.}
          },
          Replace[HalfHeightWidth] -> {
            0.00225, 0.00315, 0.00225, 0.00315, 0.00225, 0.00405, 0.0081, 0.0027, 0.00225, 0.00315, 0.0018, 0.00405,
            0.00225, 0.00315, 0.00225, 0.00495, 0.00225, 0.0027, 0.00225, 0.0027, 0.00315
          },
          Replace[Height] -> {
            0.009194, 0.010341, 0.009153, 0.009457, 0.010421, 0.011124, 0.009064, 0.009754, 0.009146, 0.011391, 0.009693,
            0.010122, 0.010508, 0.009504, 0.009568, 0.009369, 0.009349, 0.011687, 0.009659, 0.010281, 0.009688
          },
          Replace[ParentPeak] -> {
            "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7", "7"
          },
          Replace[PeakLabel] -> {
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
            "20", "21"
          },
          Replace[PeakRangeEnd] -> {
            0.487, 0.709301, 1.24255, 1.42435, 1.44415, 1.45945, 1.4734, 1.6453, 1.6543, 1.7218, 1.8361, 1.873,
            1.87975, 1.88695, 2.16685, 2.21275, 2.21725, 2.23435, 2.39185, 2.629, 2.7397
          },
          Replace[PeakRangeStart] -> {
            0.48205, 0.703001, 1.23805, 1.4185, 1.4392, 1.4491, 1.45945, 1.639, 1.6489, 1.7092, 1.83025, 1.864,
            1.873, 1.87975, 2.1565, 2.2033, 2.21275, 2.2294, 2.38825, 2.62225, 2.73475
          },
          Replace[Position] -> {
            0.48385, 0.706151, 1.2394, 1.42165, 1.441, 1.45225, 1.46845, 1.64125, 1.65205, 1.71595, 1.8316, 1.8676,
            1.87705, 1.8829, 2.1646, 2.2078, 2.2159, 2.23255, 2.39005, 2.62675, 2.7379
          },
          Purity -> {
            Area -> {0.0000214094, 0.0000386253, 0.0000237879, 0.0000312291, 0.000027389, 0.0000556659, 0.0000665292, 0.0000295011, 0.0000251289, 0.0000527738, 0.0000270585, 0.0000471062, 0.0000307586, 0.0000387648, 0.0000467544, 0.0000488748, 0.000020864, 0.0000327949, 0.0000229448, 0.0000403965, 0.0000302587, 0.00395265},
            RelativeArea -> {0.45443 Percent, 0.819849 Percent, 0.504915 Percent, 0.66286 Percent, 0.581351 Percent, 1.18155 Percent, 1.41213 Percent, 0.626182 Percent, 0.533379 Percent, 1.12016 Percent, 0.574336 Percent, 0.999863 Percent, 0.652874 Percent, 0.82281 Percent, 0.992394 Percent, 1.0374 Percent, 0.442854 Percent, 0.696094 Percent, 0.48702 Percent, 0.857444 Percent, 0.642262 Percent, 83.8978 Percent},
            PeakLabels -> {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "Background"}
          },
          Replace[RelativeArea] -> {
            0.321805, 0.580577, 0.357556, 0.469405, 0.411685, 0.836715, 1., 0.443431, 0.377713, 0.793243, 0.406717,
            0.708054, 0.462333, 0.582674, 0.702765, 0.734636, 0.313607, 0.49294, 0.344884, 0.6072, 0.454818
          },
          Replace[RelativePosition] -> {
            0.329497, 0.480882, 0.844019, 0.96813, 0.981307, 0.988968, 1., 1.11768, 1.12503, 1.16855, 1.2473, 1.27182,
            1.27825, 1.28224, 1.47407, 1.50349, 1.50901, 1.52034, 1.6276, 1.78879, 1.86448
          },
          Replace[RelativeRetentionTime] -> {
            0.329497, 0.480882, 0.844019, 0.96813, 0.981307, 0.988968, 1., 1.11768, 1.12503, 1.16855, 1.2473,
            1.27182, 1.27825, 1.28224, 1.47407, 1.50349, 1.50901, 1.52034, 1.6276, 1.78879, 1.86448
          },
          Replace[RelativeThreshold] -> {0.000478},
          Replace[TailingFactor] -> {
            0.833333, 0.875, 1.25, 0.875, 0.833333, 1.5, 0.9, 1., 0.833333, 0.875, 1., 1.5, 0.833333, 1.16667, 1.25,
            0.6875, 0.833333, 1., 1.25, 0.75, 0.875
          },
          Replace[WidthRangeEnd] -> {},
          Replace[WidthRangeStart] -> {
            0.4825, 0.704351, 1.2385, 1.41985, 1.43965, 1.4509, 1.46395, 1.6399, 1.6507, 1.71415, 1.8307, 1.86625,
            1.8757, 1.88155, 2.1637, 2.2042, 2.21455, 2.2312, 2.38915, 2.62495,
            2.7361
          },
          Replace[WidthThreshold] -> {0.}
        |>
      }
    ];

    (* Set up test NMR peak analysis object packets. *)
    {testNMRPeakAnalysis1Packet, testNMRPeakAnalysis2Packet} = Upload[
      {
        <|
          Object -> testNMRPeakAnalysis1,
          Name -> "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID,
          Replace[Reference] -> {Link[testNMRData1, NMRSpectrumPeaksAnalyses]},
          ReferenceField -> NMRSpectrum,
          Replace[AbsoluteThreshold] -> {314000.},
          Replace[AdjacentResolution] -> {0., 6.86273, 6.86273},
          Replace[Area] -> {589392., 587338., 597691.},
          Replace[AreaThreshold] -> {0.},
          Replace[AsymmetryFactor] -> {0.499965, 0.499965, 0.499965},
          Replace[BaselineIntercept] -> {860.364, 860.364, 860.364},
          Replace[BaselineSlope] -> {0., 0., 0.},
          Replace[Domain] -> {{-18.3, 218.}},
          Replace[HalfHeightNumberOfPlates] -> {6.95359*10^7, 6.99946*10^7, 7.04548*10^7},
          Replace[HalfHeightResolution] -> {{0., -6.86273, -13.7255}, {6.86273, 0., -6.86273}, {13.7255, 6.86273, 0.}},
          Replace[HalfHeightWidth] -> {0.021667, 0.021667, 0.021667},
          Replace[Height] -> {1.75646*10^7, 1.868*10^7, 1.88568*10^7},
          Replace[NMRAssignment] -> {{Unknown, {}}, {Unknown, {}}, {Unknown, {}}},
          Replace[NMRChemicalShift] -> {76.76 PPM, 77.02 PPM, 77.27 PPM},
          Replace[NMRJCoupling] -> {{}, {}, {}},
          Replace[NMRMultiplicity] -> {{1}, {1}, {1}},
          Replace[NMRNuclearIntegral] -> {1., 1., 1.01},
          NMRNucleus -> "13C",
          NMROperatingFrequency -> 125.7 Megahertz,
          Replace[NMRSplittingGroup] -> {1, 2, 3},
          Replace[ParentPeak] -> {"3", "3", "3"},
          Replace[PeakLabel] -> {"1", "2", "3"},
          Replace[PeakRangeEnd] -> {76.8851, 77.1163, 77.3763},
          Replace[PeakRangeStart] -> {76.654, 76.9068, 77.1668},
          Replace[PeakSamples] -> {Link[Object[Sample, "id:n0k9mG80j7p1"]]},
          Replace[Position] -> {76.7624, 77.0151, 77.2679},
          Purity -> {
            Area -> {589392., 587338., 597691., 1.66372*10^6},
            RelativeArea -> {17.1428 Percent, 17.083 Percent, 17.3841 Percent, 48.3901 Percent},
            PeakLabels -> {"1", "2", "3", "Background"}
          },
          Replace[RelativeArea] -> {0.986116, 0.982678, 1.},
          Replace[RelativePosition] -> {0.993457, 0.996729, 1.},
          Replace[RelativeRetentionTime] -> {0.993457, 0.996729, 1.},
          Replace[RelativeThreshold] -> {1000.},
          Replace[TailingFactor] -> {0.749983, 0.749983, 0.749983},
          Replace[WidthRangeEnd] -> {76.7696, 77.0224, 77.2752},
          Replace[WidthRangeStart] -> {76.7479, 77.0007, 77.2535},
          Replace[WidthThreshold] -> {0.118}
        |>,
        <|
          Object -> testNMRPeakAnalysis2,
          Name -> "Test NMR peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID,
          Replace[Reference] -> {Link[testNMRData2, NMRSpectrumPeaksAnalyses]},
          ReferenceField -> NMRSpectrum,
          Replace[AbsoluteThreshold] -> {7.89*10^9},
          Replace[AdjacentResolution] -> {0., 25.0012, 5.19485, 79.5497, 252.738, 3.17516},
          Replace[Area] -> {8.99027*10^8, 2.12405*10^8, 2.37464*10^8, 2.16937*10^8, 2.1962*10^8, 2.26868*10^8},
          Replace[AreaThreshold] -> {0.},
          Replace[AsymmetryFactor] -> {1., 0.998908, 0.998908, 0.66776, 0.665939, 0.66776},
          Replace[BaselineIntercept] -> {1.04932*10^8, 1.04932*10^8, 1.04932*10^8, 1.04932*10^8, 1.04932*10^8, 1.04932*10^8},
          Replace[BaselineSlope] -> {0., 0., 0., 0., 0., 0.},
          Replace[Domain] -> {{-4., 16.}},
          Replace[HalfHeightNumberOfPlates] -> {8.77629*10^7, 8.95499*10^7, 8.99437*10^7, 1.37581*10^8, 1.62328*10^8, 1.62652*10^8},
          Replace[HalfHeightResolution] -> {
            {0., -25.0012, -30.1975, -112.515, -342.359, -345.247},
            {25.0012, 0., -5.19485, -85.2165, -314.992, -317.879},
            {30.1975, 5.19485, 0., -79.5497, -309.325, -312.212},
            {112.515, 85.2165, 79.5497, 0., -252.738, -255.913},
            {342.359, 314.992, 309.325, 252.738, 0., -3.17516},
            {345.247, 317.879, 312.212, 255.913, 3.17516, 0.}
          },
          Replace[HalfHeightWidth] -> {0.00183, 0.001831, 0.001831, 0.001526, 0.001526, 0.001526},
          Replace[Height] -> {4.00063*10^11, 9.15155*10^10, 1.00742*10^11, 9.84667*10^10, 9.97929*10^10, 9.87602*10^10},
          Replace[NMRAssignment] -> {{Unknown, {}}, {Unknown, {}}, {Unknown, {}}, {Unknown, {}}},
          Replace[NMRChemicalShift] -> {7.28 PPM, 7.37 PPM, 7.6 PPM, 8.26 PPM},
          Replace[NMRJCoupling] -> {{}, {8.08 Hertz}, {}, {4.12 Hertz}},
          Replace[NMRMultiplicity] -> {{1}, {2}, {1}, {2}},
          Replace[NMRNuclearIntegral] -> {4., 2., 0.96, 1.98},
          NMRNucleus -> "1H",
          NMROperatingFrequency -> 500. Megahertz,
          Replace[NMRSplittingGroup] -> {1, 2, 2, 3, 4, 4},
          Replace[ParentPeak] -> {"1", "1", "1", "1", "1", "1"},
          Replace[PeakLabel] -> {"1", "2", "3", "4", "5", "6"},
          Replace[PeakRangeEnd] -> {7.29681, 7.36424, 7.38621, 7.62144, 8.26122, 8.28227}, Replace[PeakRangeStart] -> {7.26935, 7.35295, 7.37461, 7.60343, 8.24536, 8.26732},
          Replace[PeakSamples] -> {Link[Object[Sample, "id:D8KAEvDPNV00"]]},
          Replace[Position] -> {7.28369, 7.36149, 7.37766, 7.60465, 8.26031, 8.26854},
          Purity -> {
            Area -> {8.99027*10^8, 2.12405*10^8, 2.37464*10^8, 2.16937*10^8, 2.1962*10^8, 2.26868*10^8, 1.79842*10^9},
            RelativeArea -> {23.5919 Percent, 5.57384 Percent, 6.23144 Percent, 5.69278 Percent, 5.76319 Percent, 5.95339 Percent, 47.1934 Percent},
            PeakLabels -> {"1", "2", "3", "4", "5", "6", "Background"}
          },
          Replace[RelativeArea] -> {1., 0.23626, 0.264134, 0.241302, 0.244286, 0.252349},
          Replace[RelativePosition] -> {1., 1.01068, 1.0129, 1.04407, 1.13408, 1.13521},
          Replace[RelativeRetentionTime] -> {1., 1.01068, 1.0129, 1.04407, 1.13408, 1.13521},
          Replace[RelativeThreshold] -> {8.01*10^9},
          Replace[TailingFactor] -> {1., 0.999454, 0.999454, 0.83388, 0.832969, 0.83388},
          Replace[WidthRangeEnd] -> {7.28461, 7.36241, 7.37858, 7.60527, 8.26092, 8.26916},
          Replace[WidthRangeStart] -> {7.28278, 7.36058, 7.37675, 7.60374, 8.25939, 8.26763},
          Replace[WidthThreshold] -> {0.01}
        |>
      }
    ];

    (* Set up empty peak analysis packet. *)
    testEmptyPeakAnalysisPacket = Upload[
      <|
        Object -> testEmptyPeakAnalysis,
        Name -> "Test empty peak analysis for PlotPeaksTable testing " <> $SessionUUID,
        Replace[Reference] -> Link[testEmptyData, Absorbance3DPeaksAnalyses]
      |>
    ];

    (* Set up peak analysis with traditional peak analysis and no NMR splitting data. *)
    testEmptyNMRPeakAnalysisPacket = Upload[
      <|
        Object -> testEmptyNMRPeakAnalysis,
        Name -> "Test empty NMR peak analysis for PlotPeaksTable testing " <> $SessionUUID,
        Replace[Reference] -> Link[testEmptyNMRData, NMRSpectrumPeaksAnalyses],

        Replace[Area] -> {100.341, 97.8073, 45.4062},
        Replace[AsymmetryFactor] -> {4.71429, 1.07143, 0.9},
        Replace[BaselineIntercept] -> {1.40401, 1.40401, 1.40401},
        Replace[BaselineSlope] -> {0., 0., 0.},
        Replace[HalfHeightNumberOfPlates] -> {161.552, 4703.68, 16471.4},
        Replace[HalfHeightResolution] -> {
          {0., -1.55547, -3.28396, -4.11765, -5.63834},
          {1.55547, 0., -4.68137, -7.29412, -12.0321},
          {3.28396, 4.68137, 0., -2.95798, -8.96194}
        },
        Replace[HalfHeightWidth] -> {1.99997, 0.483326, 0.316662},
        Replace[Height] -> {51.728, 111.836, 73.428},
        Replace[PeakLabel] -> {"Peak 1", "Peak 2", "Peak 3"},
        Replace[PeakRangeEnd] -> {13.0333, 15.9999, 18.2166},
        Replace[PeakRangeStart] -> {10.25, 13.0333, 15.9999},
        Replace[Position] -> {10.8, 14.0833, 17.2666},
        Replace[RelativeArea] -> {1.55728, 1.51795, 0.704697},
        Replace[RelativePosition] -> {0.50039, 0.652512, 0.800002},
        Replace[TailingFactor] -> {2.85714, 1.03571, 0.95},
        Replace[WidthRangeEnd] -> {12.45, 14.3333, 17.4166},
        Replace[WidthRangeStart] -> {10.45, 13.85, 17.0999}
      |>
    ];

    (* Upload all packets. *)
    Upload[
      {
        testHPLCPeakAnalysis1Packet, testHPLCPeakAnalysis2Packet, testLargeHPLCPeakAnalysisPacket,
        testNMRPeakAnalysis1Packet, testNMRPeakAnalysis2Packet, testEmptyPeakAnalysisPacket,
        testEmptyNMRPeakAnalysisPacket
      }
    ];
  ],
  TearDown :> (
    Quiet[
      EraseObject[
        {
          Object[Analysis, Peaks, "Test empty peak analysis for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test empty NMR peak analysis for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test HPLC peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test HPLC peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test large HPLC peak analysis for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 1 for PlotPeaksTable testing " <> $SessionUUID],
          Object[Analysis, Peaks, "Test NMR peak analysis 2 for PlotPeaksTable testing " <> $SessionUUID]
        },
        Force -> True, Verbose -> False
      ]
    ];

    EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
  )
];