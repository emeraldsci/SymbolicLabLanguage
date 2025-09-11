(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



(* ::Subsection:: *)
(*AnalyzeDownsampling*)

DefineUsage[AnalyzeDownsampling,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeDownsampling[dataObject,field]", "analysisObject"},
        Description -> "downsamples and compresses the numerical data in a 'field' of 'dataObject', storing the downsampled result in 'analysisObject'.",
        Inputs :> {
          {
            InputName -> "dataObject",
            Description -> "The data object containing data to be downsampled.",
            Widget -> Widget[
							Type->Object,
							Pattern:>ObjectP[{
								(* List of supported types *)
								Object[Data,ChromatographyMassSpectra]
							}]
						]
          },
					{
						InputName -> "field",
						Description -> "The field in the data object containing two- or three-dimensional data points to be downsampled.",
						Widget -> Widget[Type->Expression,Pattern:>_Symbol,Size->Word]
					}
        },
        Outputs :> {
          {
            OutputName -> "analysisObject",
            Description -> "An analysis object containing the downsampled data.",
            Pattern :> ObjectP[Object[Analysis,Downsampling]]
          }
        }
      }
    },
		MoreInformation -> {
			"N-dimensional data is assumed to have one dependent variable and N-1 independent variables. The dependent variable is assumed to be the last dimension.",
			"Data is downsampled onto an evenly spaced grid in the independent variables.",
			"If input data is unevenly sampled in its second-to-last dimension (last independent variable), data will be resampled along this dimension onto a regularly spaced grid using linear interpolation.",
			"Input data which is unevenly sampled in more than one independent variable cannot be downsampled with this function."
		},
    SeeAlso -> {
			"PlotChromatographyMassSpectra",
			"AnalyzeSmoothing"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];