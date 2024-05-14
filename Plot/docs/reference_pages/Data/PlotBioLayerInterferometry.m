(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBioLayerInterferometry*)


DefineUsage[PlotBioLayerInterferometry,
  {
    BasicDefinitions->{
      {
        Definition -> {"PlotBioLayerInterferometry[data]", "figure"},
        Description -> "plots the data contained in 'data' as appropriate for the type of assay the data was generated from.",
        Inputs:>
            {
              {
                InputName -> "data",
                Description -> "A BioLayerInterferometry data or protocol.",
                Widget -> Alternatives[
                  Adder[
                    Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
                  ],
                  Widget[Type -> Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
                ]
              }
            },
        Outputs :> {
          {
            OutputName -> "figure",
            Description -> "A plot or multiple plots displaying the results of the biolayer interferometry assay.",
            Pattern :> (ValidGraphicsP[]| {ValidGraphicsP[]..})
          }
        }
      },
      {
        Definition -> {"PlotBioLayerInterferometry[protocol]", "figure"},
        Description -> "plots the data contained in 'protocol' as appropriate for the type of assay the data was generated from.",
        Inputs:>
            {
              {
                InputName -> "protocol",
                Description -> "A BioLayerInterferometry protocol with associated data.",
                Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
              }
            },
        Outputs :> {
          {
            OutputName -> "figure",
            Description -> "A plot or multiple plots displaying the results of the biolayer interferometry assay.",
            Pattern :> (ValidGraphicsP[]| {ValidGraphicsP[]..})
          }
        }
      }
    },
    SeeAlso->{
      "AnalyzeBindingKinetics",
      "AnalyzeBindingQuantitation",
      "PlotBindingKinetics"
    },
    Author->{"alou", "robert"},
    Preview ->True
  }
];