(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*AnalyzeSmoothing*)

DefineUsage[AnalyzeSmoothing,
  {
    BasicDefinitions -> {

      {
        Definition -> {"AnalyzeSmoothing[data]", "object"},
        Description -> "this function takes either a list of data objects or a list of xy coordinates and applies different types of smoothing functions to the datasets in order to reduce the noise and make clear the broader trends in your data.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "data",
              Description -> "The input can be a set of data objects, a set of protocol objects, a set of raw data points, or a set of raw coordinates (including quantities and distributions), respectively.",
              Widget -> Alternatives[
                "Data" -> Widget[Type->Object, Pattern :> ObjectP[Object[Data]], PatternTooltip->"Any set of data objects which contain valid set of coordinates.", ObjectTypes -> {Object[Data]}],
                "Protocol" -> Widget[Type->Object, Pattern:> ObjectP[Object[Protocol]], PatternTooltip->"Any set of protocol objects which contain valid set of coordinates.", ObjectTypes -> {Object[Protocol]}],
                "X-Y Values" -> Adder[
                  {
                    "X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
                    "Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
                  }
                ],
                "Coordinates" -> Widget[Type->Expression, Pattern :> CoordinatesP|DistributionCoordinatesP|QuantityCoordinatesP[]|listOfQuantityDistributionsP, PatternTooltip->"Please input a list of numerical coordinates, or a list of quantities, or a list containing distributions.", Size->Paragraph]
              ],
              Expandable->False
            },
            IndexName->"main input"
          ]
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The object containing analysis results of smoothing the curves.",
            Pattern :> ObjectP[Object[Analysis, Smoothing]]
          }
        }
      }

    },
    MoreInformation -> {
      "Smoothen input data based on a particular approach provided by the user."
      (* add your table here *)
      (* how to make a table in the additional information ask from Rob or slack *)
    },
    SeeAlso -> {
      "AnalyzeKinetics",
      "AnalyzePeaks",
      "NMinimize",
      "FindMinimum"
    },
    Author -> {"scicomp", "brad", "amir.saadat"},
    Guides -> {
      "AnalysisCategories",
      "ExperimentAnalysis"
    },
    Preview->True,
    ButtonActionsGuide->{
      

    }
  }
];


(* ::Section::Closed:: *)
(*AnalyzeSmoothingOptions*)


DefineUsage[AnalyzeSmoothingOptions,
{
	BasicDefinitions -> {

    {
      Definition -> {"AnalyzeSmoothingOptions[data]", "options"},
      Description -> "returns all 'options' for AnalyzeSmoothing['data'] with all Automatic options resolved to fixed values.",
      Inputs :> {
        IndexMatching[
          {
            InputName -> "data",
            Description -> "The input can be a set of data objects, a set of protocol objects, a set of raw data points, or a set of raw coordinates (including quantities and distributions), respectively.",
            Widget -> Alternatives[
              Widget[Type->Object, Pattern :> ObjectP[Object[Data]], ObjectTypes -> {Object[Data]}],
              Widget[Type->Object, Pattern:> ObjectP[Object[Protocol]], ObjectTypes -> {Object[Protocol]}],
              Adder[
                {
                  "X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
                  "Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
                }
              ],
              Widget[Type->Expression, Pattern :> CoordinatesP|DistributionCoordinatesP|QuantityCoordinatesP[]|listOfQuantityDistributionsP, PatternTooltip->"Please input a list of numerical coordinates, or a list of quantities, or a list containing distributions.", Size->Paragraph]
            ],
            Expandable->False
          },
          IndexName->"main input"
        ]
      },
      Outputs :> {
        {
					OutputName -> "options",
					Description -> "The resolved options in the AnalyzeSmoothing call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
    }
  },
	SeeAlso -> {
    "AnalyzeKineticsPreview",
    "AnalyzePeaksPreview",
    "NMinimize",
    "FindMinimum"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];



(* ::Section::Closed:: *)
(*AnalyzeSmoothingPreview*)


DefineUsage[AnalyzeSmoothingPreview,
{
	BasicDefinitions -> {

    {
      Definition -> {"AnalyzeSmoothingPreview[data]", "preview"},
      Description -> "returns a graphical display representing AnalyzeSmoothing['data'] output.",
      Inputs :> {
        IndexMatching[
          {
            InputName -> "data",
            Description -> "The input can be a set of data objects, a set of protocol objects, a set of raw data points, or a set of raw coordinates (including quantities and distributions), respectively.",
            Widget -> Alternatives[
              Widget[Type->Object, Pattern :> ObjectP[Object[Data]], ObjectTypes -> {Object[Data]}],
              Widget[Type->Object, Pattern:> ObjectP[Object[Protocol]], ObjectTypes -> {Object[Protocol]}],
              Adder[
                {
                  "X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
                  "Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
                }
              ],
              Widget[Type->Expression, Pattern :> CoordinatesP|DistributionCoordinatesP|QuantityCoordinatesP[]|listOfQuantityDistributionsP, PatternTooltip->"Please input a list of numerical coordinates, or a list of quantities, or a list containing distributions.", Size->Paragraph]
            ],
            Expandable->False
          },
          IndexName->"main input"
        ]
      },
      Outputs :> {
				{
					OutputName -> "preview",
					Description -> "The graphical display representing the AnalyzeSmoothing call output.",
					Pattern :> (ValidGraphicsP[] | Null)
				}
			}
    }
  },
	SeeAlso -> {
    "AnalyzeKineticsPreview",
    "AnalyzePeaksPreview",
    "NMinimize",
    "FindMinimum"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];


(* ::Section::Closed:: *)
(*ValidAnalyzeSmoothingQ*)


DefineUsage[ValidAnalyzeSmoothingQ,
{
	BasicDefinitions -> {

    {
      Definition -> {"ValidAnalyzeSmoothingQ[data]", "testSummary"},
      Description -> "this function takes either a set of data objects (see MoreInformation for a list of possible data objects) or a list of xy coordinates and applies different types of filtering to the datasets in order to reduce the noise and make clear the broader trends in your data.",
      Inputs :> {
        IndexMatching[
          {
            InputName -> "data",
            Description -> "Returns an EmeraldTestSummary which contains the test results of AnalyzeSmoothing['data'] for all the gathered tests/warnings or a single Boolean indicating validity.",
            Widget -> Alternatives[
              Widget[Type->Object, Pattern :> ObjectP[Object[Data]], ObjectTypes -> {Object[Data]}],
              Widget[Type->Object, Pattern:> ObjectP[Object[Protocol]], ObjectTypes -> {Object[Protocol]}],
              Adder[
                {
                  "X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
                  "Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
                }
              ],
              Widget[Type->Expression, Pattern :> CoordinatesP|DistributionCoordinatesP|QuantityCoordinatesP[]|listOfQuantityDistributionsP, PatternTooltip->"Please input a list of numerical coordinates, or a list of quantities, or a list containing distributions.", Size->Paragraph]
            ],
            Expandable->False
          },
          IndexName->"main input"
        ]
      },
      Outputs :> {
        {
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of AnalyzeSmoothing['data'].",
					Pattern :> (EmeraldTestSummary| Boolean)
				}
      }
    }

	},

	SeeAlso -> {
    "AnalyzeSmoothing",
    "AnalyzeFit",
    "ValidAnalyzeFitQ",
		"ValidAnalyzePeaksQ"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];