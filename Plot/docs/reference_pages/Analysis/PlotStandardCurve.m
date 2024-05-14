(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotStandardCurve*)


DefineUsage[PlotStandardCurve,
  {
    BasicDefinitions -> {
      {
        Definition -> {"PlotStandardCurve[standardCurve]", "plot"},
        Description -> "plots a fitted standard curve alongside the data points it was applied to.",
	 			Inputs :> {
	 				{
	 					InputName -> "standardCurve",
	 					Description -> "A standard curve analysis object (generated from AnalyzeStandardCurve) or packet.",
	 					Widget -> Adder[
							Widget[Type->Object, Pattern:>ObjectP[Object[Analysis,StandardCurve]]]
						]
	 				}
	 			},
        Outputs :> {
          {
            OutputName -> "plot",
            Description -> "A plot of the fitted standard curve, the data points used to fit it, and the data that the standard was applied to.",
            Pattern :> _Graphics
          }
        }
      }
  	},
		MoreInformation->{
			"PlotStandardCurve inherits options from EmeraldListLinePlot. Please see the documentation for EmeraldListLinePlot for more examples."
		},
    SeeAlso -> {
			"EmeraldListLinePlot",
      "AnalyzeStandardCurve",
      "AnalyzeStandardCurveOptions",
      "AnalyzeStandardCurvePreview"
    },
    Author -> {"scicomp", "brad", "kevin.hou"},
		Preview->True
  }
];