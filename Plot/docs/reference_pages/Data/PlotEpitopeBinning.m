(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotEpitopeBinning*)


DefineUsage[PlotEpitopeBinning,
  {
    BasicDefinitions->{
      {
        Definition->{"PlotEpitopeBinning[analysis]","plot"},
        Description->"creates a 'plot' with a graph indicating the grouping of samples with respect to their interaction with a particular target in 'analysis' object.",
        Inputs:>{
          {
            InputName->"analysis",
            Description->"An analysis object which contains interaction strengths and grouped samples.",
            Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,EpitopeBinning]]]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"Graphs indicating the grouping of the samples with respect to their binding to a particular target.",
            Pattern:>_Graph
          }
        }
      },
      {
        Definition->{"PlotEpitopeBinning[protocol]","plot"},
        Description->"creates a 'plot' with a graph indicating the grouping of samples with respect to their interaction with a particular target derived from analyzed data related to 'protocol' object.",
        Inputs:>{
          {
            InputName->"protocol",
            Description->"A protocol object which contains analyzed data with interaction strengths and grouped samples.",
            Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"Graphs indicating the grouping of the samples with respect to their binding to a particular target.",
            Pattern:>_Graph
          }
        }
      }
    },
    SeeAlso->{
      "AnalyzeBindingKinetics",
      "AnalyzeEpitopeBinning",
      "PlotBioLayerInterferometry"
    },
    Author->{"alou", "robert", "malav.desai"},
    Preview->True
  }
]