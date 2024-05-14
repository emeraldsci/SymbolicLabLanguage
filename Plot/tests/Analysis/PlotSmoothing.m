(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotSmoothing*)


DefineTests[PlotSmoothing,

  {
    (* Basic *)

    Example[{Basic, "Plotting the smoothing analysis of a list of coordinates:"},
      PlotSmoothing[AnalyzeSmoothing[simpleList,Upload->False]],
      Legended[Graphics[_, _], _]
    ],
    Example[{Basic, "Plotting the smoothing analysis results of a spiral curve:"},
      PlotSmoothing[AnalyzeSmoothing[spiralData,EqualSpacing->False,AscendingOrder->False,Upload->False]],
      Legended[Graphics[_, _], _]
    ],
    Example[{Basic, "Plotting the smoothing analysis for a chromatography data object:"},
      PlotSmoothing[AnalyzeSmoothing[Object[Data, Chromatography, "id:GmzlKjPKWeD4"],Method->Median,Radius->0.5]],
      Legended[Graphics[_, _], _],
      Stubs:>{
        AnalyzeSmoothing[Object[Data, Chromatography, "id:GmzlKjPKWeD4"],Method->Median,Radius->0.5]=
          AnalyzeSmoothing[Object[Data, Chromatography, "id:GmzlKjPKWeD4"],Method->Median,Radius->0.5,Upload->False]
      }
    ],

    (* Additional *)

    Example[{Additional, "Plotting the smoothing analysis for a list of distribution:"},
      PlotSmoothing[AnalyzeSmoothing[simpleDistribution,EqualSpacing->False,Upload->False]],
      Legended[Graphics[_, _], _]
    ],

    Example[{Additional, "Plotting the smoothing analysis for multiple mass spectroscopy data object:"},
      PlotSmoothing[
        AnalyzeSmoothing[
          {
            Object[Data, MassSpectrometry, "id:4pO6dM5dwqoX"],
            Object[Data, MassSpectrometry, "id:Vrbp1jK15Ode"]
          },
          Method->{LowpassFilter,SavitzkyGolay},Radius -> {Automatic,10}, EqualSpacing->False
        ]
      ],
      {Legended[Graphics[_, _], _],Legended[Graphics[_, _], _]},
      Stubs:>{
        AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:4pO6dM5dwqoX"],Object[Data, MassSpectrometry, "id:Vrbp1jK15Ode"]},Method->{LowpassFilter,SavitzkyGolay},Radius -> {Automatic,10}, EqualSpacing->False]=
          AnalyzeSmoothing[{Object[Data, MassSpectrometry, "id:4pO6dM5dwqoX"],Object[Data, MassSpectrometry, "id:Vrbp1jK15Ode"]},Method->{LowpassFilter,SavitzkyGolay},Radius -> {Automatic,10}, EqualSpacing->False,Upload->False]
      }
    ],

    (* Options *)

    Example[{Options, SymbolPointsShowCutoff, "Specify the number of datapoints above which the datapoint symbols are not shown together with the curve line:"},
      {
        PlotSmoothing[AnalyzeSmoothing[spiralData,EqualSpacing->False,AscendingOrder->False,Upload->False]],
        PlotSmoothing[AnalyzeSmoothing[spiralData,EqualSpacing->False,AscendingOrder->False,Upload->False],SymbolPointsShowCutoff->1000]
      },
      {Legended[Graphics[_, _], _]..}
    ],

    Example[{Options, Legend, "Specify the legends for the three curves being plotted:"},
      PlotSmoothing[AnalyzeSmoothing[spiralData,EqualSpacing->False,AscendingOrder->False,Upload->False],Legend->{"Original","Smooth","Local STD"}],
      Legended[Graphics[_, _], _]
    ],

    Example[{Options, PlotMarkers, "Specify if we want plot markers for the curves:"},
      PlotSmoothing[AnalyzeSmoothing[spiralData,EqualSpacing->False,AscendingOrder->False,Upload->False],PlotMarkers->{{Automatic,Large},{Automatic,Medium},None}],
      Legended[Graphics[_, _], _]
    ],

		Example[{Options, PlotStyle, "Specify the style for the three curves being plotted:"},
			PlotSmoothing[AnalyzeSmoothing[spiralData,EqualSpacing->False,AscendingOrder->False,Upload->False],PlotStyle->{Automatic,Automatic,{Dashed}}],
			Legended[Graphics[_, _], _]
		],

		Example[{Options, Joined, "Not connecting the orignial data:"},
			PlotSmoothing[AnalyzeSmoothing[simpleList,EqualSpacing->False,AscendingOrder->False,Upload->False],Joined->{False,True,True}],
			Legended[Graphics[_, _], _]
		],

		Example[{Options, Frame, "Removing the frame for the final plot:"},
			PlotSmoothing[AnalyzeSmoothing[simpleList,EqualSpacing->False,AscendingOrder->False,Upload->False],Frame->False],
			Legended[Graphics[_, _], _]
		],

    Example[{Options, Zoomable, "Plotting the smoothing analysis of a list of coordinates with zoomable graph (note that if boxes is false, zoomable results in black legends this is a temporary issue with zoomable):"},
      PlotSmoothing[AnalyzeSmoothing[simpleList,Upload->False],Zoomable->True,Boxes->True],
      Legended[DynamicModule[_, _, _], _]
    ],

    Example[{Options, Boxes, "Plotting the smoothing analysis of a list of coordinates with boxes turned off (note that if boxes is true, zoomable results in black legends this is a temporary issue with zoomable):"},
      PlotSmoothing[AnalyzeSmoothing[simpleList,Upload->False],Boxes->False,Zoomable->False],
      Legended[Graphics[_, _], _]
    ]

  },

  Variables:>{simpleList,simpleDistribution,spiralData},
  SetUp:>(
    simpleList = QuantityArray[{{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5,10}, {6,15}}, {Second, Meter}];
    simpleDistribution = Table[{idx, QuantityDistribution[NormalDistribution[RandomReal[{-10, 10}], RandomReal[{0, 1}]], Minute]}, {idx, Range[10]}];
    spiralData = Table[FromPolarCoordinates[{0.5 + t/2, Mod[t, 2 \[Pi]] - \[Pi]}], {t, 0.0001, 4 \[Pi], 6 \[Pi]/200}];
  )
];
