(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBindingQuantitation*)

DefineOptions[PlotBindingQuantitation,
  Options:>{
    {
      OptionName -> Cache,
      Default -> Null,
      Description -> "An inherited cache containing information about the protocol, data, and analysis objects.",
      AllowNull -> True,
      Category -> "Hidden",
      Widget -> Widget[Type -> Expression, Pattern :> {_Association...}, Size -> Paragraph]
    },
    {
      OptionName -> Color,
      Default -> Orange,
      Description -> "The color used to display the measured sample data point against the standard curve.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[Type -> Expression, Pattern :> ColorP, Size -> Word]
    },
    {
      OptionName -> PointSize,
      Default -> 0.025,
      Description -> "The size at which the measured sample value is displayed against the standard curve.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[Type -> Number, Pattern :> GreaterP[0]]
    }
  },
  SharedOptions:>{
    OutputOption,
    {
      EmeraldListLinePlot,
      {
        AspectRatio, ImageSize,
        PlotRange, PlotRangeClipping, ClippingStyle,
        PlotLabel, FrameLabel, RotateLabel, LabelingFunction,LabelStyle,
        Background, ColorFunction, ColorFunctionScaling, Filling, FillingStyle,
        Frame, FrameStyle, FrameTicks, FrameTicksStyle,
        GridLines, GridLinesStyle,
        Prolog,Epilog
      }
    }
  }
];

(*Messages*)
Warning::BindingQuantitationAnalysisMissing="There is no BindingQuantitation analysis object linked to the input data object(s). If you would like the data to be fit, please run AnalyzeBindingQuantitation on the data objects.";

(*Function overload accepting one BLI data object*)
PlotBindingQuantitation[
  objs:ObjectP[Object[Data,BioLayerInterferometry]],
  ops:OptionsPattern[PlotBindingQuantitation]
]:=Module[{analysisObjs, safeOps, cache, dataFields, analysisFields, newCache, allDownloads},

  (* lookup and clean up the cache *)
  safeOps = SafeOptions[PlotBindingQuantitation,ToList[ops]];
  cache = ToList[Lookup[safeOps, Cache, {Null}]];

  (* download all fields again for speed *)
  dataFields = Packet[QuantitationAnalysis];
  analysisFields = Packet[QuantitationAnalysis[{StandardCurveFitAnalysis, SamplesInConcentrations, Rate, EquilibriumResponse}]];

  (* download the analysis object *)
  allDownloads = Quiet[
    Download[
      objs,
      {
        dataFields,
        analysisFields
      },
      Cache -> cache,
      Date -> Now
    ],
    {
      Download::FieldDoesntExist,
      Download::MissingCacheField
    }
  ];

  (* generate a new cache to pass to the next overload *)
  newCache = Cases[Flatten[{allDownloads, cache}], PacketP[]];

  (* identify the analysis objects *)
  analysisObjs = Flatten[ToList[Download[Download[objs, QuantitationAnalysis, Cache -> newCache], Object]]];

  (* if there's no analysis object we cant plot anything useful *)
  If[MatchQ[analysisObjs,({}|Null|{Null..})],
    Message[Warning::BindingQuantitationAnalysisMissing];

    (* return the plot of the data object *)
    $Failed,

    (* pass to the next overload using the most recent analysis object *)
    PlotBindingQuantitation[
      Last[analysisObjs],
      ReplaceRule[safeOps, {Cache -> newCache}]
    ]
  ]
];


(* -- CORE -- *)
(* Plots the standard curve with the data point *)
PlotBindingQuantitation[
  objs:ObjectP[Object[Analysis,BindingQuantitation]],
  ops:OptionsPattern[PlotBindingQuantitation]
]:=Module[{packet, valueToPlot, units, safeOps, cache, cachelessOps,
  resolvedFrameLabel, plot, mostlyResolvedOps, outputSpecification, output, outputPlot,
  resolvedPointSize, resolvedColor, fullyResolvedOptions, plotFitOptions
},

  (* lookup the hidden option *)
  safeOps = SafeOptions[PlotBindingQuantitation,ToList[ops]];
  cache = ToList[Lookup[safeOps, Cache, {Null}]];
  cachelessOps = DeleteCases[safeOps, (Cache -> _)];

  (* download the fields we need to plot *)
  packet = Quiet[
    Download[
      objs,
      Packet[StandardCurveFitAnalysis, SamplesInConcentrations, Rate, EquilibriumResponse],
      Cache -> cache,
      Date ->Now
    ],
    {
      Download::FieldDoesntExist,
      Download::MissingCacheField
    }
  ];

  (* if we fit the rate, that was the standard curve has also *)
  valueToPlot = First[DeleteCases[Lookup[packet, {Rate, EquilibriumResponse}],Null]];

  (* get the units so we can make sure everything is on the same scale *)
  units = Download[Lookup[packet, StandardCurveFitAnalysis], DataUnits][[1]];

  (* resolve the frame label option here *)
  resolvedFrameLabel = Lookup[cachelessOps, FrameLabel]/.Automatic -> {"Concentration", "Observed Rate (1/s)"};
  plotFitOptions = DeleteCases[cachelessOps,  (Color -> _) | (PointSize -> _)];

  (* resolve the options *)
  {plot, mostlyResolvedOps} = PlotFit[
    Download[Lookup[packet, StandardCurveFitAnalysis], Object],
    Sequence@@ReplaceRule[plotFitOptions, {Output -> {Result, Options}, FrameLabel -> resolvedFrameLabel}]
  ];

  (* resolve the overlay options *)
  resolvedColor = Lookup[cachelessOps, Color];
  resolvedPointSize = Lookup[cachelessOps, PointSize];

  (* return the full option set *)
  fullyResolvedOptions = ReplaceRule[
    cachelessOps,
    ReplaceRule[Join[mostlyResolvedOps, {Color -> resolvedColor}], Join[{PointSize -> resolvedPointSize}]],
    Append ->False
  ];

  (* in the future this can be updated to be better, but it does ok for now *)
  outputPlot = Show[
    plot,
    ListPlot[
      {
        {
          UnitConvert[First[Lookup[packet, SamplesInConcentrations]], units], Unitless[First[valueToPlot]]
        }
      },
      PlotStyle -> {resolvedColor, PointSize[resolvedPointSize]}
    ]
  ];

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=outputSpecification;

  (* return the requested result *)
  output/.{
    Result->outputPlot,
    Options->RemoveHiddenOptions[PlotBindingQuantitation, fullyResolvedOptions],
    Preview->outputPlot,
    Tests->{}
  }
];
