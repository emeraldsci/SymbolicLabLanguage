(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGelAnimation*)


DefineUsage[PlotGelAnimation,
  {
    BasicDefinitions ->{
      {
        Definition->{"PlotGelAnimation['gelObject']","plot"},
        Description->"plots the 'gelObject' gel images as animated GIF.",
        Inputs:>{
          {
            InputName->"gelObject",
            Description->"The Object[Data,AgaroseGelElectrophoresis] or Object[Data,PAGE] object to be plotted.",
            Widget->Alternatives[
              Widget[Type->Object,Pattern:>ObjectP[Object[Data,AgaroseGelElectrophoresis]]],
              Widget[Type->Object,Pattern:>ObjectP[Object[Data,PAGE]]],
              Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,AgaroseGelElectrophoresis]]],
              Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,AgaroseGelElectrophoresis]]]
            ]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"A graphical representation of the data as an animation.",
            Pattern:>_TabView
          }
        }
     }
  },
  SeeAlso -> {
    "PlotAgaroseElectrophoresis","PlotPAGE"
  },
  Author -> {"SciComp"},
  Preview->False
}
];