(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotPrediction*)


DefineUsage[PlotPrediction,
{
	BasicDefinitions -> {

    {
      Definition -> {"PlotPrediction[fitObject,inputValue]", "fig"},
      Description -> "this function plots the result of the fitting analysis along with predicted value and distributions.",
      Inputs :> {
        {
          InputName -> "fitObject",
          Description -> "The analysis object which is the output of fit analysis performed with AnalyzeFit.",
          Widget -> Widget[Type->Object, Pattern :> ObjectP[Object[Analysis,Fit]]]
        },
				{
          InputName -> "inputValue",
					Description -> "The coordinate value in the dataset that is used for finding the other coordinate prediction from the fit analysis. This is the first coordinate if Direction->Forward or second if Direction->Inverse.",
					Widget -> Alternatives[
						"Value or Quantity"->Widget[Type->Expression, Pattern :> UnitsP[], Size->Word],
						"Distribution"->Widget[Type->Expression, Pattern :> _?DistributionParameterQ, Size->Word]
					]
        }
      },
      Outputs :> {
				{
					OutputName -> "fig",
					Description -> "The resulting curves of fit analysis, along with dashed lines that show the input value and the prediction from the fit analysis.",
					Pattern :> ValidGraphicsP[]
				}
      }
    },

		{
			Definition -> {"PlotPrediction[fitObject,x]", "fig"},
			Description -> "this function plots the result of the fitting analysis along with predicted value and distributions.",
			Inputs :> {
				{
          InputName -> "fitObject",
          Description -> "The analysis object which is the output of fit analysis performed with AnalyzeFit.",
          Widget -> Widget[Type->Object, Pattern :> ObjectP[Object[Analysis,Fit]]]
        },
				{
					InputName -> "x",
					Description -> "The value of first entry in the coordinate set that is used for finding the second entry prediction from the fit analysis.",
					Widget -> Alternatives[
						"Value or Quantity"->Widget[Type->Expression, Pattern :> UnitsP[], Size->Word],
						"Distribution"->Widget[Type->Expression, Pattern :> _?DistributionParameterQ, Size->Word]
					]
				},
				{
					InputName -> "y",
					Description -> "The value of the second entry in the coordinate set that is predicted from the fit analysis.",
					Widget -> Alternatives[
						"Value or Quantity"->Widget[Type->Expression, Pattern :> UnitsP[], Size->Word],
						"Distribution"->Widget[Type->Expression, Pattern :> _?DistributionParameterQ, Size->Word]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "fig",
					Description -> "The resulting curves of fit analysis, along with dashed lines that show the input value and the prediction from the fit analysis.",
					Pattern :> ValidGraphicsP[]
				}
			}
		}

	},
	SeeAlso -> {
    "SinglePrediction",
    "PlotDistribution",
    "AnalyzeFit"
	},
	Author -> {
		"amir.saadat",
		"brad",
		"thomas",
		"alice",
		"qian"
	},
	Sync->Automatic,
	Preview->True
}];
