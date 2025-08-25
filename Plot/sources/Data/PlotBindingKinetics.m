(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBindingKinetics*)


DefineOptions[PlotBindingKinetics,
  Options:>{},
  SharedOptions:>{
    EmeraldListLinePlot
  }
];

(*Messages*)
Warning::BindingKineticsAnalysisMissing="There is no BindingKinetics analysis object linked to the input data object(s). If you would like the data to be fit, please run AnalyzeBindingKinetics on the data objects.";

(*Function overload accepting one BLI data objects*)
PlotBindingKinetics[
  objs:ObjectReferenceP[Object[Data,BioLayerInterferometry]]|LinkP[Object[Data,BioLayerInterferometry]],
  ops:OptionsPattern[PlotBindingKinetics]
]:=Module[{analysisObjs},

  (* download the analysis object *)
  analysisObjs=Download[Download[objs,KineticsAnalysis, Date->Now],Object];

  (* if theres no analysis object we cant plot anything useful *)
  If[MatchQ[analysisObjs,({}|Null|{Null..})],
    Return[Message[Warning::BindingKineticsAnalysisMissing]];
    $Failed,
    PlotBindingKinetics[
      Last[ToList[analysisObjs]],
      ops
    ]
  ]
];

(* -- CORE -- *)
(* Plots the trajectories on top of the data *)
PlotBindingKinetics[objs:ObjectReferenceP[Object[Analysis,BindingKinetics]]|LinkP[Object[Analysis,BindingKinetics]],
  ops:OptionsPattern[PlotBindingKinetics]
]:=Module[{packet, fieldsToPlot, listOps, safeOptions, safeOptionTests,
  plot, resolvedOptions, outputSpecification, output, resolvedPlotLabel, resolvedFrameLabel},

  listOps = ToList[ops];
  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=outputSpecification;

  (* Call SafeOptions to make sure all options match pattern - don't gather tests *)
  {safeOptions, safeOptionTests} =
      {
        SafeOptions[PlotBindingKinetics, listOps, AutoCorrect -> False],
        Null
      };

  (* download the fields we need to plot *)
  packet = Download[objs, Packet[PredictedTrajectories, AssociationTrainingData, DissociationTrainingData], Date->Now];

  fieldsToPlot = DeleteCases[Lookup[packet, {AssociationTrainingData, DissociationTrainingData}], Null];
  resolvedFrameLabel = Lookup[safeOptions, FrameLabel]/.Automatic -> {"Time (Seconds)","Biolayer Thickness (Nanometers)"};
  resolvedPlotLabel = Lookup[safeOptions, PlotLabel]/.Automatic -> "Predicted Trajectory";

  (* output the plot *)
  {plot, resolvedOptions}= EmeraldListLinePlot[
    {Sequence@@fieldsToPlot,Lookup[packet, PredictedTrajectories]},
    Sequence@@ReplaceRule[
      safeOptions,
      {Output -> {Result, Options},
        FrameLabel->resolvedFrameLabel,
        PlotLabel -> resolvedPlotLabel
      }
    ]
  ];

  (*output*)
  output/.{
    Result->plot,
    Options->RemoveHiddenOptions[PlotBindingKinetics, resolvedOptions],
    Preview->plot,
    Tests->{}
  }
];
