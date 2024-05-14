(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBindingKinetics*)


DefineUsage[PlotBindingKinetics,
  {
    BasicDefinitions->{
      {
        Definition->{"PlotBindingKinetics[analysis]", "plot"},
        Description->"plots the association and dissociation data in 'analysis' with predicted kinetic trajectories overlayed.",
        Inputs:>{
          {
            InputName->"analysis",
            Description->"An analysis object which fitted association and dissociation binding curves.",
            Widget-> Widget[Type->Object,Pattern:>ObjectP[Object[Analysis, BindingKinetics]]]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"The kinetics predicted trajectories plotted with the experimental data.",
            Pattern:>ValidGraphicsP[]
          }
        }
      },
      {
        Definition->{"PlotBindingKinetics[data]", "plot"},
        Description->"plots the association and dissociation curves associated with 'data' with predicted kinetic trajectories overlayed.",
        Inputs:>{
          {
            InputName->"data",
            Description->"An analysis object which fitted association and dissociation binding curves.",
            Widget-> Widget[Type->Object,Pattern:>ObjectP[Object[Data, BioLayerInterferometry]]]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"The kinetics predicted trajectories plotted with the experimental data.",
            Pattern:>ValidGraphicsP[]
          }
        }
      }
    },
    SeeAlso->{
      "AnalyzeBindingKinetics",
      "AnalyzeBindingQuantitation",
      "PlotBioLayerInterferometry",
      "PlotFit"
    },
    Author->{"alou", "robert"},
    Preview -> True
  }
];