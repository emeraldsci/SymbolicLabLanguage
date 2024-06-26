(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



(* ::Subsection:: *)
(*AnalyzeBubbleRadius*)

DefineUsage[AnalyzeBubbleRadius,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeBubbleRadius[dataObject]", "analysisObject"},
        Description -> "computes the distribution of bubble radii at each frame of the RawVideoFile in a DynamicFoamAnalysis 'dataObject'.",
        Inputs :> {
          IndexMatching[
						{
	            InputName -> "dataObject",
	            Description -> "A DynamicFoamAnalysis data object containing a RawVideoFile of foam bubbles to analyze.",
	            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DynamicFoamAnalysis]]]
	          },
						IndexName->"Foaming Data"
					]
        },
        Outputs :> {
          {
            OutputName -> "analysisObject",
            Description -> "An analysis object containing the distribution of foam bubble radii at each frame of the input video.",
            Pattern :> ObjectP[Object[Analysis,BubbleRadius]]
          }
        }
      },
      {
        Definition -> {"AnalyzeBubbleRadius[protocol]", "analysisObjects"},
        Description -> "computes the distribution of bubble radii at each frame of each RawVideoFile found in all data objects generated by 'protocol'.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "A DynamicFoamAnalysis protocol containing one or more DynamicFoamAnalysis data objects.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DynamicFoamAnalysis]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "analysisObjects",
            Description -> "For each data object in the input protocol containing a RawVideoFile, analysis object(s) containing computed distributions of bubble radii.",
            Pattern :> {ObjectP[Object[Analysis,BubbleRadius]]..}
          }
        }
      },
      {
        Definition -> {"AnalyzeBubbleRadius[video]", "analysisObject"},
        Description -> "computes the distribution of bubble radii at each frame of the input 'video'.",
        Inputs :> {
          {
            InputName -> "video",
            Description -> "An EmeraldCloudFile video showing the evolution of foam bubbles over time.",
            Widget -> Widget[Type->Expression, Pattern:>EmeraldCloudFileP, Size->Line]
          }
        },
        Outputs :> {
          {
            OutputName -> "analysisObject",
            Description -> "An analysis object containing the distribution of foam bubble radii at each frame of the input video.",
            Pattern :> ObjectP[Object[Analysis,BubbleRadius]]
          }
        }
      }
  	},
    SeeAlso -> {
			"ExperimentDynamicFoamAnalysis",
			"PlotDistribution"
    },
    Author -> {"scicomp", "brad", "kevin.hou"},
    Preview->True
  }
];



(* ::Subsection:: *)
(*AnalyzeBubbleRadiusOptions*)

DefineUsage[AnalyzeBubbleRadiusOptions,
  {
		BasicDefinitions -> {
			{
				Definition -> {"AnalyzeBubbleRadiusOptions[dataObject]", "resolvedOptions"},
        Description -> "returns the resolved options for AnalyzeBubbleRadius when it is called on 'dataObject'.",
        Inputs :> {
          {
            InputName -> "dataObject",
            Description -> "A DynamicFoamAnalysis data object containing a RawVideoFile of foam bubbles to analyze.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DynamicFoamAnalysis]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeBubbleRadius is called on the given inputs.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      },
      {
        Definition -> {"AnalyzeBubbleRadiusOptions[protocol]", "resolvedOptions"},
        Description -> "returns the resolved options for AnalyzeBubbleRadius when it is called on 'protocol'.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "A DynamicFoamAnalysis protocol containing one or more DynamicFoamAnalysis data objects.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DynamicFoamAnalysis]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeBubbleRadius is called on the given inputs.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      },
      {
        Definition -> {"AnalyzeBubbleRadiusOptions[video]", "resolvedOptions"},
        Description -> "returns the resolved options of AnalyzeBubbleRadius when it is called on 'video'.",
        Inputs :> {
          {
            InputName -> "video",
            Description -> "An EmeraldCloudFile video showing the evolution of foam bubbles over time.",
            Widget -> Widget[Type->Expression, Pattern:>EmeraldCloudFileP, Size->Line]
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeBubbleRadius is called on the given inputs.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
  	},
    SeeAlso -> {
			"AnalyzeBubbleRadius",
			"AnalyzeBubbleRadiusPreview",
			"ValidAnalyzeBubbleRadiusQ"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];



(* ::Subsection:: *)
(*AnalyzeBubbleRadiusPreview*)

DefineUsage[AnalyzeBubbleRadiusPreview,
  {
		BasicDefinitions -> {
			{
				Definition -> {"AnalyzeBubbleRadiusPreview[dataObject]", "preview"},
	      Description -> "returns a graphical 'preview' of the output of AnalyzeBubbleRadius when it is called on 'dataObject'.",
	      Inputs :> {
	        {
	          InputName -> "dataObject",
	          Description -> "A DynamicFoamAnalysis data object containing a RawVideoFile of foam bubbles to analyze.",
	          Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DynamicFoamAnalysis]]]
	        }
	      },
	      Outputs :> {
	        {
	          OutputName -> "preview",
	          Description -> "The graphical preview representing the output of AnalyzeBubbleRadius.",
	          Pattern :> ValidGraphicsP[]
	        }
	      }
	    },
	    {
	      Definition -> {"AnalyzeBubbleRadiusPreview[protocol]", "preview"},
	      Description -> "returns a graphical 'preview' of the output of AnalyzeBubbleRadius when it is called on 'protocol'.",
	      Inputs :> {
	        {
	          InputName -> "protocol",
	          Description -> "A DynamicFoamAnalysis protocol containing one or more DynamicFoamAnalysis data objects.",
	          Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DynamicFoamAnalysis]]]
	        }
	      },
	      Outputs :> {
	        {
	          OutputName -> "preview",
	          Description -> "The graphical preview representing the output of AnalyzeBubbleRadius.",
	          Pattern :> ValidGraphicsP[]
	        }
	      }
	    },
	    {
	      Definition -> {"AnalyzeBubbleRadiusPreview[video]", "preview"},
	      Description -> "returns a graphical preview of the output of AnalyzeBubbleRadius when it is called on 'video'.",
	      Inputs :> {
	        {
	          InputName -> "video",
	          Description -> "An EmeraldCloudFile video showing the evolution of foam bubbles over time.",
	          Widget -> Widget[Type->Expression, Pattern:>EmeraldCloudFileP, Size->Line]
	        }
	      },
	      Outputs :> {
	        {
	          OutputName -> "preview",
	          Description -> "The graphical preview representing the output of AnalyzeBubbleRadius.",
	          Pattern :> ValidGraphicsP[]
	        }
	      }
	    }
		},
    SeeAlso -> {
			"AnalyzeBubbleRadius",
			"AnalyzeBubbleRadiusOptions",
			"ValidAnalyzeBubbleRadiusQ"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];



(* ::Subsection:: *)
(*ValidAnalyzeBubbleRadiusQ*)

DefineUsage[ValidAnalyzeBubbleRadiusQ,
  {
		BasicDefinitions -> {
			{
				Definition -> {"ValidAnalyzeBubbleRadiusQ[dataObject]", "boolean"},
	      Description -> "checks whether 'dataObject' and any specified options are valid inputs to AnalyzeBubbleRadius.",
	      Inputs :> {
	        {
	          InputName -> "dataObject",
	          Description -> "A DynamicFoamAnalysis data object containing a RawVideoFile of foam bubbles to analyze.",
	          Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Data,DynamicFoamAnalysis]]]
	        }
	      },
	      Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "A value indicating whether the AnalyzeBubbleRadius call is valid. The return value can be changed with the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
	      }
	    },
	    {
	      Definition -> {"ValidAnalyzeBubbleRadiusQ[protocol]", "boolean"},
	      Description -> "checks whether 'protocol' and any specified options are valid inputs to AnalyzeBubbleRadius.",
	      Inputs :> {
	        {
	          InputName -> "protocol",
	          Description -> "A DynamicFoamAnalysis protocol containing one or more DynamicFoamAnalysis data objects.",
	          Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DynamicFoamAnalysis]]]
	        }
	      },
	      Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "A value indicating whether the AnalyzeBubbleRadius call is valid. The return value can be changed with the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
	      }
	    },
	    {
	      Definition -> {"ValidAnalyzeBubbleRadiusQ[video]", "boolean"},
	      Description -> "checks whether 'video' and any specified options are valid inputs to AnalyzeBubbleRadius.",
	      Inputs :> {
	        {
	          InputName -> "video",
	          Description -> "An EmeraldCloudFile video showing the evolution of foam bubbles over time.",
	          Widget -> Widget[Type->Expression, Pattern:>EmeraldCloudFileP, Size->Line]
	        }
	      },
	      Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "A value indicating whether the AnalyzeBubbleRadius call is valid. The return value can be changed with the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
	      }
	    }
		},
    SeeAlso -> {
			"AnalyzeBubbleRadius",
			"AnalyzeBubbleRadiusOptions",
			"AnalyzeBubbleRadiusPreview"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];