(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotIRSpectroscopy*)


DefineUsage[PlotIRSpectroscopy,
	{
    BasicDefinitions -> {
      {
        Definition -> {"PlotIRSpectroscopy[IRData]", "plot"},
        Description -> "generates a graphical plot of the spectrum stored in the input IR spectroscopy data object.",
	 			Inputs :> {
					IndexMatching[
						{
							InputName -> "IRData",
							Description -> "IRSpectroscopy object you wish to plot.",
							Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Data,IRSpectroscopy]]]
						},
						IndexName -> "IRData"
					]
	 			},
        Outputs :> {
          {
            OutputName -> "plot",
            Description -> "A graphical representation of the spectra.",
            Pattern :> _Graphics
          }
        }
      },
      {
		  Definition -> {"PlotIRSpectroscopy[protocol]", "plot"},
		  Description -> "creates a 'plot' of the IR spectroscopy data found in the Data field of 'protocol'.",
		  Inputs :> {
		      {
			      InputName -> "protocol",
			      Description -> "The protocol object containing IR spectroscopy data objects.",
			      Widget -> Alternatives[
				      Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, IRSpectroscopy]]]
			      ]
		      }
		  },
		  Outputs :> {
		      {
			      OutputName -> "plot",
			      Description -> "The figure generated from data found in the IR spectroscopy protocol.",
			      Pattern :> ValidGraphicsP[]
		      }
		  }
      }
  	},
	SeeAlso -> {
		"ExperimentIRSpectroscopy",
		"AnalyzePeaks"
	},
	Author -> {"yanzhe.zhu", "kevin.hou", "brad"}
	}
];