(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBindingQuantitation*)


DefineUsage[PlotBindingQuantitation,
  {
    BasicDefinitions->{
      (*analysis object*)
      {
        Definition->{"PlotBindingQuantitation[analysisObject]", "plot"},
        Description->"plots the bio-layer thickness during the quantitation step of a bio-layer interferometry assay.",
        Inputs:>{
          {
            InputName->"analysisObject",
            Description->"An analysis object which contains the standard curve and fitting information.",
            Widget-> Widget[Type->Object,Pattern:>ObjectP[Object[Analysis, BindingQuantitation]]]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"Plots of the standard curve and fitting of the standards and sample used to derive the standard curve.",
            Pattern:>ValidGraphicsP[]
          }
        }
      },
      (* data object *)
      {
        Definition->{"PlotBindingQuantitation[dataObject]", "plot"},
        Description->"plots the bio-layer thickness during the quantitation step of a bio-layer interferometry assay.",
        Inputs:>{
          {
            InputName->"dataObject",
            Description->"A data object which contains analysis objects.",
            Widget-> Widget[Type->Object,Pattern:>ObjectP[Object[Data, BioLayerInterferometry]]]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"Plots of the standard curve and fitting of the standards and sample used to derive the standard curve.",
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