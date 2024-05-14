(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*AnalyzeCompensationMatrix*)


DefineUsage[AnalyzeCompensationMatrix,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeCompensationMatrix[flowCytometryProtocol]", "compensationMatrix"},
        Description -> StringJoin[
					"uses the AdjustmentSampleData collected in the provided 'flowCytometryProtocol' ",
					"to compute the 'compensationMatrix' that corrects for fluorophore signal overlap."
				],
        Inputs :> {
          {
            InputName -> "flowCytometryProtocol",
            Description -> "A flow cytometry protocol for which CompensationSamplesIncluded is True.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,FlowCytometry]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "compensationMatrix",
            Description -> StringJoin[
							"An analysis object containing the compensation matrix which corrects for ",
							"signal overlap between the fluorophores and detectors used in the input protocol."
						],
            Pattern :> {ObjectP[Object[Analysis,CompensationMatrix]]..}
          }
        }
      }
  	},
    MoreInformation->{
      "AnalyzeCompensationMatrix computes spillover and compensation matrices using event peak areas."
    },
    SeeAlso -> {
			"ExperimentFlowCytometry",
      "AnalyzeFlowCytometry"
    },
    Author -> {"scicomp", "brad", "kevin.hou"},
    Preview -> True,
    PreviewOptions -> {"DetectionThresholds"},
    ButtonActionsGuide -> {
      {Description->"Move the threshold sliders", ButtonSet->"'LeftDrag'"}
    }
  }
];



(* ::Subsection:: *)
(*AnalyzeCompensationMatrixOptions*)

DefineUsage[AnalyzeCompensationMatrixOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeCompensationMatrixOptions[flowCytometryProtocol]", "resolvedOptions"},
        Description -> "returns the resolved options for AnalyzeCompensationMatrix when it is called on 'flowCytometryProtocol'.",
        Inputs :> {
          {
            InputName -> "flowCytometryProtocol",
            Description -> "A flow cytometry protocol for which CompensationSamplesIncluded is True.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,FlowCytometry]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeCompensationMatrix is called on the given inputs.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
  	},
    SeeAlso -> {
			"AnalyzeCompensationMatrix",
			"AnalyzeCompensationMatrixPreview",
			"ValidAnalyzeCompensationMatrixQ"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];



(* ::Subsection:: *)
(*AnalyzeCompensationMatrixPreview*)

DefineUsage[AnalyzeCompensationMatrixPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeCompensationMatrixPreview[flowCytometryProtocol]", "preview"},
        Description -> "returns a graphical 'preview' of the output of AnalyzeCompensationMatrix when it is called on 'flowCytometryProtocol'.",
        Inputs :> {
          {
            InputName -> "flowCytometryProtocol",
            Description -> "A flow cytometry protocol for which CompensationSamplesIncluded is True.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,FlowCytometry]]]
          }
        },
        Outputs :> {
          {
	          OutputName -> "preview",
	          Description -> "The graphical preview representing the output of AnalyzeCompensationMatrix.",
	          Pattern :> ValidGraphicsP[]
	        }
        }
      }
  	},
    SeeAlso -> {
			"AnalyzeCompensationMatrix",
			"AnalyzeCompensationMatrixOptions",
			"ValidAnalyzeCompensationMatrixQ"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];



(* ::Subsection:: *)
(*ValidAnalyzeCompensationMatrixQ*)

DefineUsage[ValidAnalyzeCompensationMatrixQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidAnalyzeCompensationMatrixQ[flowCytometryProtocol]", "boolean"},
        Description -> "checks whether 'flowCytometryProtocol' and any specified options are valid inputs to AnalyzeCompensationMatrix.",
        Inputs :> {
          {
            InputName -> "flowCytometryProtocol",
            Description -> "A flow cytometry protocol for which CompensationSamplesIncluded is True.",
            Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,FlowCytometry]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "A value indicating whether the AnalyzeCompensationMatrix call is valid. The return value can be changed with the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      }
  	},
    SeeAlso -> {
			"AnalyzeCompensationMatrix",
			"AnalyzeCompensationMatrixOptions",
			"AnalyzeCompensationMatrixPreview"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];