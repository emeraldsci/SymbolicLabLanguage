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
      }
  	},
		SeeAlso -> {
			"ExperimentIRSpectroscopy",
			"AnalyzePeaks"
		},
		Author -> {
			"kevin.hou",
			"brad"
		}
	}
];
