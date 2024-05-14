(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotSmoothing*)


DefineUsage[PlotSmoothing,
{
	BasicDefinitions -> {

    {
      Definition -> {"PlotSmoothing[smoothingObject]", "plot"},
      Description -> "this function plots the curves available in 'smoothingObject' which contains curves that are used for smoothing analysis overlaid with the smoothed curves and the local standard deviation of smoothed and original curve difference.",
      Inputs :> {
        {
          InputName -> "smoothingObject",
          Description -> "The analysis object which is the output of smoothing analysis performed with AnalyzeSmoothing.",
          Widget -> Alternatives[
            "Single Object" -> Widget[Type->Object, Pattern :> ObjectP[Object[Analysis,Smoothing]]],
            "Mutiple Objects" -> Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Smoothing]],PatternTooltip->"A single analysis object."]]
          ],
          Expandable->False
        }
      },
      Outputs :> {
      {
					OutputName -> "plot",
					Description -> "The resulting curves of smoothing analysis, including the original curve, smoothed curve, and the local standard deviation of the difference of the two.",
					Pattern :> ValidGraphicsP[]
				}
				}
    }

	},

	SeeAlso -> {
	    "AnalyzeSmoothing",
	    "AnalyzeFit",
	    "PlotFit",
		"PlotMeltingPoint",
	    "PlotPeaks"
	},
	Author -> {"scicomp", "brad", "amir.saadat"},
	Sync->Automatic,
	Preview->True
}];