
(* ::Subsubsection::Closed:: *)
(*AnalyzeSmoothing*)


DefineTests[AnalyzeSmoothing,
  {
    (* Examples for Basic usage *)
    Example[{Basic, "A unitless set of data points:"},
      AnalyzeSmoothing[unitlessSimpleList,Method -> Gaussian, Radius -> 2, Upload -> False][SmoothedDataPoints],
      {{1, 2.3136}, {2, 3.05088}, {3, 4.20353}, {4, 6.25441}, {5, 9.94912}, {6, 13.432}},
      EquivalenceFunction -> RoundMatchQ[3]
    ],

    Example[{Basic, "A simple set of data points with units:"},
      AnalyzeSmoothing[simpleList, Method -> Median, Radius -> 2*Second, Upload -> False][Residuals],
      {1, 1/2, 0, 0, -(5/2), -5},
      EquivalenceFunction -> RoundMatchQ[3]
    ],

    Example[{Basic, "A nonequally spaced set of data points with units:"},
      AnalyzeSmoothing[simpleNotEqualSpacedList, Method -> Mean, Radius -> 5*Minute, Upload -> False][Residuals],
      {1.29167, 0.78125, 0.225, -1.34375, -0.916667},
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1]}
    ],

    Example[{Additional, "List of quantity datasets:"},
      AnalyzeSmoothing[simpleListOfQuantities, Method -> Mean, Radius -> 1*Second, Upload -> False][TotalResidual],
      {0.408248, 3.46944},
      EquivalenceFunction -> RoundMatchQ[3]
    ],

    Example[{Additional, "Multiple datasets:"},
      AnalyzeSmoothing[{simpleNotEqualSpacedList,simpleList}, Method -> Mean, Radius -> {5*Minute,2}, Upload -> False][TotalResidual],
      {0.997529, 2.41178},
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1]},
      TimeConstraint -> 200
    ],

    Example[{Additional, "Unordered data that folds onto itself:"},
      PlotSmoothing[AnalyzeSmoothing[secondUnorderedList, AscendingOrder -> False, EqualSpacing -> False, Radius -> 1.5, Upload -> False]],
      ValidGraphicsP[],
      EquivalenceFunction -> RoundMatchQ[3]
    ],

    Example[{Additional, "Vertical lines:"},
      AnalyzeSmoothing[{{3, 3}, {3, -2}, {3, 0}}, AscendingOrder -> False, Upload -> False][Residuals],
      {-0.496902, 0.695663, -0.198761},
      EquivalenceFunction -> RoundMatchQ[3]
    ],

    Example[{Additional, "Spiral dataset:"},
      PlotSmoothing[AnalyzeSmoothing[spiralData, Upload -> False, AscendingOrder -> False]],
      ValidGraphicsP[],
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1]}
    ],

    Example[{Additional, "Dataset with distribution entries:"},
      PlotSmoothing[AnalyzeSmoothing[simpleDistribution, Radius->1, Method->Gaussian, Upload -> False]],
      ValidGraphicsP[],
      EquivalenceFunction -> RoundMatchQ[3]
    ],

    (* Examples for single and multiple objects *)
    Example[{Additional, "Multiple MassSpectrometry objects:"},
      PlotSmoothing[AnalyzeSmoothing[
        {Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"],
        Object[Data, MassSpectrometry, "id:4pO6dM5dW4BX"],
        Object[Data, MassSpectrometry, "id:4pO6dM5dwqoX"],
        Object[Data, MassSpectrometry, "id:Vrbp1jK15Ode"]},
        EqualSpacing -> False, Method -> {Median,SavitzkyGolay,Median,TrimmedMean}, Radius -> {Automatic, 100, 10, 10}, Upload -> False],ImageSize->400],
      {ValidGraphicsP[]..},
      EquivalenceFunction -> MatchQ,
      TimeConstraint -> 300
    ],

    Example[{Additional, "Different types of data objects:"},
      PlotSmoothing[AnalyzeSmoothing[
        {Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"],
        Object[Data, Chromatography, "id:GmzlKjPKWeD4"]},
        EqualSpacing -> False, Method -> {Mean,SavitzkyGolay}, Radius -> {3, 1}, Upload -> False],ImageSize->600],
      {ValidGraphicsP[]..},
      EquivalenceFunction -> MatchQ
    ],

    (* Examples for protocol objects *)

    Example[{Additional, "A protocol object:"},
      PlotSmoothing[AnalyzeSmoothing[Object[Protocol,MassSpectrometry, "id:BYDOjvGoO1aE"],
        EqualSpacing -> False, Upload -> False]],
      {ValidGraphicsP[]..},
      EquivalenceFunction -> MatchQ
    ],

    (* Examples for Options *)

    Example[{Options, Method,"Bilateral method is successful to denoise the data and retain its trend:"},
      PlotSmoothing[AnalyzeSmoothing[bindingKineticsData, Method->Bilateral, Radius->10, Upload -> False],ImageSize->600],
      ValidGraphicsP[],
      EquivalenceFunction -> MatchQ
    ],

    Example[{Options, CutoffFrequency,"The option CutoffFrequency is used for smoothing with LowpassFilter or HighpassFilter. So all frequencies higher/lower than this value will be removed, respectively:"},
      AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]}, Method -> LowpassFilter, CutoffFrequency -> 0.04, Upload -> False][TotalResidual],
      {11.7702},
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1]}
    ],

    Example[{Options, Radius,"The option Radius is used for smoothing with all options except LowpassFilter or HighpassFilter. This radius is used for smoothing around each datapoint with the neighborhood equal to radius in either directions:"},
      AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]}, EqualSpacing -> False, Method -> Gaussian, Radius -> 2, Upload->False][TotalResidual],
      {7.5583},
      EquivalenceFunction -> RoundMatchQ[3]
    ],

    Example[{Options, BaselineAdjust,"Baseline adjustment can be used for cases where there is a systematic drift:"},
      PlotSmoothing[AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]}, EqualSpacing -> False, BaselineAdjust -> True, Upload -> False],ImageSize->600],
      {ValidGraphicsP[]..},
      EquivalenceFunction -> MatchQ
    ],

    Example[{Options, ReferenceField,"Explicitly specifying the reference field which contains the dataset:"},
      PlotSmoothing[AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]}, EqualSpacing -> False, ReferenceField -> MassSpectrum, Upload -> False],ImageSize->600],
      {ValidGraphicsP[]..},
      EquivalenceFunction -> MatchQ
    ],

    Example[{Options, EqualSpacing, "Making the dataset equally spaced:"},
      PlotSmoothing[AnalyzeSmoothing[Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"],
        EqualSpacing -> True, Method -> SavitzkyGolay, Radius -> 50, Upload -> False],ImageSize->600],
      ValidGraphicsP[],
      EquivalenceFunction -> MatchQ,
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1]}
    ],

    Example[{Options, AscendingOrder, "If we want to check the ascending order of the dataset:"},
      AnalyzeSmoothing[simpleUnorderedList, Method -> Mean, AscendingOrder->False, Upload -> False][SmoothedDataPoints],
      {{100., 35.2311}, {253.963, 35.2311}, {739.331, 35.2311}, {774.443, 35.2311}, {287.221, 35.2311}, {-200., 35.2311}},
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1]}
    ],

    (* Examples for Messages *)

    Example[{Messages, "NonAscendingOrderedDataSet", "Unordered dataset:"},
      AnalyzeSmoothing[simpleUnorderedList, Method -> Gaussian,Upload->False][SmoothedDataPoints],
      {{-200, 34.7871}, {40, 41.6526}, {280, 48.8661}, {520, 56.1953}, {760, 63.3953}, {1000, 70.2319}},
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1],Message[Warning::NonAscendingOrderedDataSet,1]}
    ],

    Example[{Messages, "MismatchedUnits", "Dataset with mismatched units:"},
      AnalyzeSmoothing[mismatchedunitsList],
      $Failed,
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Error::MismatchedUnits,1]}
    ],

    Example[{Messages,"UnusedRadius","The provided Radius is redundant and not used for LowpassFilter and HighpassFilter methods:"},
      AnalyzeSmoothing[unitlessSimpleList, Method -> LowpassFilter, Radius -> 2, Upload -> False][SmoothedDataPoints],
      {{1, 2.20291}, {2, 2.70291}, {3, 3.65067}, {4, 5.31164}, {5, 8.16097}, {6, 11.606}},
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::UnusedRadius,1,LowpassFilter]}
    ],

    Example[{Messages,"UnusedCutoffFrequency","The provided CutoffFrequency is redundant and not used for methods other than LowpassFilter and HighpassFilter:"},
      AnalyzeSmoothing[unitlessSimpleList, Method -> Gaussian, Radius -> 2, CutoffFrequency-> 100, Upload -> False][SmoothedDataPoints],
      {{1, 2.3136}, {2, 3.05088}, {3, 4.20353}, {4, 6.25441}, {5, 9.94912}, {6, 13.432}},
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::UnusedCutoffFrequency,1,Gaussian]}
    ],

    Example[{Messages,"MissingReferenceField","The reference field information is not stored in SmoothingInputDataTypes:"},
      AnalyzeSmoothing[Object[Data, qPCR, "id:mnk9jORjOxYl"]],
      $Failed,
      EquivalenceFunction -> MatchQ,
      Messages:>{Message[Error::MissingReferenceField,Object[Data, qPCR, "id:mnk9jORjOxYl"]],Message[Error::InvalidInput,Object[Data, qPCR, "id:mnk9jORjOxYl"]]}
    ],

    Example[{Messages,"NonEqualSpacedDataSet","The pattern should be a set of {x,y} coordinates:"},
      AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]}, Method -> LowpassFilter, CutoffFrequency -> 0.04],
      ListableP[ObjectP[Object[Analysis,Smoothing]]],
      EquivalenceFunction -> MatchQ,
      Messages:>{Message[Warning::NonEqualSpacedDataSet,1]}
    ],

    Example[{Messages,"NonCompliantPattern","The pattern should be a set of {x,y} coordinates:"},
      AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]}, Method -> LowpassFilter, CutoffFrequency -> 0.04, ReferenceField -> AccelerationVoltage],
      $Failed,
      EquivalenceFunction -> MatchQ,
      Messages:>{Message[Error::NonCompliantPattern,1],Message[Error::InvalidOption,Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]]}
    ],

    Example[{Messages,"EmptyReferenceField","The field should exist in the data object packet:"},
      AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]}, Method -> LowpassFilter, CutoffFrequency -> 0.04, ReferenceField -> DataField],
      $Failed,
      EquivalenceFunction -> MatchQ,
      Messages:>{Message[Error::EmptyReferenceField,DataField],Message[Error::InvalidOption,Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"]]}
    ],

    Example[{Messages,"OutOfBoundCutoffFrequency","The CutoffFrequency should be between 1/ x-coordinate range and 1/mean distance of the data points:"},
      AnalyzeSmoothing[Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"], EqualSpacing -> False, Method -> LowpassFilter, CutoffFrequency -> 0.0],
      $Failed,
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Error::OutOfBoundCutoffFrequency,1,Quantity[0.00036666411552269476`, ("Moles")/("Grams")]],Message[Error::InvalidOption, CutoffFrequency]}
    ],

    Example[{Messages,"OutOfBoundRadius","The radius should be between the mean distance between data points in x-direction and the range of the x-coordinate:"},
      AnalyzeSmoothing[Object[Data, MassSpectrometry, "id:P5ZnEjd9GLWW"], EqualSpacing -> False, Method -> Gaussian, Radius -> 0],
      ListableP[ObjectP[Object[Analysis,Smoothing]]],
      EquivalenceFunction -> RoundMatchQ[3],
      Messages:>{Message[Warning::OutOfBoundRadius,1,Quantity[1.5619414136207435`, ("Grams")/("Moles")]]}
    ]
  },
  Variables:>{unitlessSimpleList,simpleList,simpleNotEqualSpacedList,bindingKineticsData},
  SetUp:>(
    unitlessSimpleList = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5,10}, {6,15}};
    simpleList = QuantityArray[{{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5,10}, {6,15}}, {Second, Meter}];
    simpleUnorderedList = {{100, 2}, {1/30, 10000/127}, {1/2, 144}, {200, 5}, {1000,100}, {-200,4}};
    secondUnorderedList = {{1.0, 2.0}, {3.0, 2.0}, {2.0, 3.0}, {1.0, 4.0}, {3.0, 4.0}, {2.0, 3.0}, {1.01, 1.5}};
    simpleListOfQuantities =  { {{1 Second, 1 Foot}, {2 Second, 2 Foot}, {3 Second, 3 Foot}}, {{5 Second, 2 Inch}, {6 Second, 2 Inch}, {7 Second, 12 Inch}} };
    mismatchedunitsList = {{1 Second, 1 Foot}, {2 Kilogram, 2 Foot}, {3 Second, 3 Foot}};
    simpleNotEqualSpacedList = QuantityArray[{{1., 5}, {2., 7}, {4., 6}, {8., 10}, {10., 10}}, {Minute, Meter}];
    spiralData = Table[FromPolarCoordinates[{0.5 + t/2, Mod[t, 2 \[Pi]] - \[Pi]}], {t, 0.0001, 4 \[Pi], 6 \[Pi]/200}];
    simpleDistribution = Table[{idx, QuantityDistribution[NormalDistribution[RandomReal[{-10, 10}], RandomReal[{0, 1}]], Minute]}, {idx, Range[10]}];
    bindingKineticsData = Table[{t, N[(2*(1 - Exp[-(20000*10*10^-8 + 0.0001)*t]) + RandomReal[{-0.2, 0.2}])]}, {t, 0, 1000}]
  )

];


(* ::Subsubsection::Closed:: *)
(*AnalyzeSmoothingOptions*)


DefineTests[AnalyzeSmoothingOptions,

  {
    Example[{Basic, "Return options for smoothing a simple unitless array:"},
      AnalyzeSmoothingOptions[{{1, 3}, {2, -2}, {3, 0}}],
      _Grid
    ],
    Example[{Basic, "Return options for smoothing a quantity array:"},
      AnalyzeSmoothingOptions[QuantityArray[{{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5,10}, {6,15}}, {Second, Meter}]],
      _Grid
    ],
    Example[{Basic, "Return options for smoothing a chromatography object:"},
      AnalyzeSmoothingOptions[Object[Data, Chromatography, "id:GmzlKjPKWeD4"]],
      _Grid
    ],
    Example[{Options,OutputFormat,"Return the options as a list for a simple unitless array:"},
      AnalyzeSmoothingOptions[{{1, 3}, {2, -2}, {3, 0}}, OutputFormat->List],
      {
        Method -> Gaussian, CutoffFrequency -> {Null}, Radius -> {10},
        AscendingOrder -> True, EqualSpacing -> True, BaselineAdjust -> False,
        ReferenceField -> {Null}, Output -> Options, Upload -> True
      },
      EquivalenceFunction->MatchQ
    ]
  }

];


(* ::Subsubsection::Closed:: *)
(*AnalyzeSmoothingPreview*)


DefineTests[AnalyzeSmoothingPreview,

  {
    Example[{Basic, "Return preview for smoothing a simple unitless array:"},
      AnalyzeSmoothingPreview[{{1, 3}, {2, -2}, {3, 0}}],
      Legended[DynamicModule[_, _, _], _],
      EquivalenceFunction->MatchQ
    ],
    Example[{Basic, "Return preview for smoothing a quantity array:"},
      AnalyzeSmoothingPreview[QuantityArray[{{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5,10}, {6,15}}, {Second, Meter}]],
      Legended[DynamicModule[_, _, _], _],
      EquivalenceFunction->MatchQ
    ],
    Example[{Basic, "Return preview for smoothing a chromatography object:"},
      AnalyzeSmoothingPreview[Object[Data, Chromatography, "id:GmzlKjPKWeD4"]],
      Legended[DynamicModule[_, _, _], _],
      EquivalenceFunction->MatchQ
    ]
  }

];

(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeSmoothingQ*)


DefineTests[ValidAnalyzeSmoothingQ,

  {

    Example[{Basic, "Return test results for smoothing a simple unitless array:"},
      ValidAnalyzeSmoothingQ[{{1, 3}, {2, -2}, {3, 0}}, Upload -> False],
      True
    ],
    Example[{Basic, "Return test results for smoothing a quantity array:"},
      AnalyzeSmoothingPreview[QuantityArray[{{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5,10}, {6,15}}, {Second, Meter}]],
      Legended[DynamicModule[_, _, _], _],
      EquivalenceFunction->MatchQ
    ],
    Example[{Basic, "Return test results for smoothing a chromatography object:"},
      ValidAnalyzeSmoothingQ[Object[Data, Chromatography, "id:GmzlKjPKWeD4"]],
      True
    ],
    Example[{Options, OutputFormat, "Specify OutputFormat to be TestSummary:"},
      ValidAnalyzeSmoothingQ[Object[Data, Chromatography, "id:GmzlKjPKWeD4"],
      OutputFormat -> TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options, Verbose, "Specify Verbose to be True:"},
      ValidAnalyzeSmoothingQ[Object[Data, Chromatography, "id:GmzlKjPKWeD4"], Verbose -> True],
      True
    ]

  }

];
