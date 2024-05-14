(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeBindingKinetics*)

DefineUsage[AnalyzeBindingKinetics,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeBindingKinetics[associationData, dissociationData]", "object"},
        Description -> "solves for kinetic association and dissociation rates such that the model described by 'reactions' fits the input 'associationData' and 'dissociationData'.",
        Inputs :> {
          {
            InputName -> "associationData",
            Description -> "List of QuantityArray from an analyte association step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          },
          {
            InputName -> "dissociationData",
            Description -> "List of QuantityArray from an analyte dissociation step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          }
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The object containing analysis results from solving the kinetic rates.",
            Pattern :> ObjectP[Object[Analysis, BindingKinetics]]
          }
        }
      },

      {
        Definition -> {"AnalyzeBindingKinetics[kineticData]", "object"},
        Description -> "fits to the trajectories in the data objects or protocol from ExperimentBioLayerInterferometry.",
        Inputs :> {
          {
            InputName -> "kineticData",
            Description -> "BioLayerInterferometry kinetics data or protocol containing kinetics data fields.",
            Widget -> Alternatives[
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ],
              Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The object containing analysis results from solving the kinetic rates.",
            Pattern :> ObjectP[Object[Analysis, Kinetics]]
          }
        }
      }

    },
    MoreInformation -> {
      "Uses least-squares optimization to solve for the unknown kinetic rates such that the predicted trajectories from the resulting mechanism best fit the training trajectories.",
      "Global optimization uses NMinimize, while Local optimization uses FindMinimum.",
      "Simulated trajectories are generated during optimization using SimulateKinetics, which uses NDSolve to numerically solve the differential equations describing the reaction network."
    },
    SeeAlso -> {
      "AnalyzeKinetics",
      "PlotBindingKinetics",
      "NMinimize"
    },
    Author -> {"alou", "robert"},
    Guides -> {
      "AnalysisCategories",
      "ExperimentAnalysis"
    },
    Preview->True
  }];


(* ::Subsubsection:: *)
(*AnalyzeBindingKineticsOptions*)


DefineUsage[AnalyzeBindingKineticsOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeBindingKineticsOptions[associationData, dissociationData]", "options"},
        Description -> "returns all 'options' for AnalyzeBindingKinetics['associationData', 'dissociationData'] with all Automatic options resolved to fixed values.",
        Inputs :> {
          {
            InputName -> "associationData",
            Description -> "List of QuantityArray from an analyte association step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          },
          {
            InputName -> "dissociationData",
            Description -> "List of QuantityArray from an analyte dissociation step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          }
        },
        Outputs :> {
          {
            OutputName -> "options",
            Description -> "The resolved options in the AnalyzeBindingKinetics call.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
          }
        }
      },

      {
        Definition -> {"AnalyzeBindingKineticsOptions[kineticData]", "options"},
        Description -> "returns all 'options' for AnalyzeBindingKinetics['kineticData'] with all Automatic options resolved to fixed values.",
        Inputs :> {
          {
            InputName -> "kineticData",
            Description -> "BioLayerInterferometry kinetics data or protocol containing kinetics data fields.",
            Widget -> Alternatives[
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ],
              Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "options",
            Description -> "The resolved options in the AnalyzeBindingKinetics call.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
          }
        }
      }

    },

    SeeAlso -> {
      "AnalyzeKinetics",
      "AnalyzeBindingKinetics",
      "PlotBindingKinetics"
    },
    Author -> {"alou", "robert"}
  }];


(* ::Subsubsection:: *)
(*AnalyzeBindingKineticsPreview*)


DefineUsage[AnalyzeBindingKineticsPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeBindingKineticsPreview[associationData, dissociationData]", "preview"},
        Description -> "returns a graphical display representing AnalyzeBindingKinetics['associationData', 'dissociationData'] output.",
        Inputs :> {
          {
            InputName -> "associationData",
            Description -> "List of QuantityArray from an analyte association step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          },
          {
            InputName -> "dissociationData",
            Description -> "List of QuantityArray from an analyte dissociation step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical display representing the AnalyzeBindingKinetics call output.",
            Pattern :> (ValidGraphicsP[] | Null)
          }
        }
      },

      {
        Definition -> {"AnalyzeBindingKineticsPreview[kineticData]", "preview"},
        Description -> "returns a graphical display representing AnalyzeBindingKinetics['kineticData'] output.",
        Inputs :> {
          {
            InputName -> "kineticData",
            Description -> "BioLayerInterferometry kinetics data or protocol containing kinetics data fields.",
            Widget -> Alternatives[
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ],
              Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical display representing the AnalyzeBindingKinetics call output.",
            Pattern :> (ValidGraphicsP[] | Null)
          }
        }
      }

    },

    SeeAlso -> {
      "AnalyzeKinetics",
      "AnalyzeBindingKinetics",
      "PlotBindingKinetics"
    },
    Author -> {"alou", "robert"}
  }];


(* ::Subsubsection:: *)
(*ValidAnalyzeBindingKineticsQ*)


DefineUsage[ValidAnalyzeBindingKineticsQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidAnalyzeBindingKineticsQ[associationData, dissociationData]", "testSummary"},
        Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeBindingKinetics['associationData', 'dissociationData'] for all the gathered tests/warnings or a single Boolean indicating validity.",
        Inputs :> {
          {
            InputName -> "associationData",
            Description -> "List of QuantityArray from an analyte association step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          },
          {
            InputName -> "dissociationData",
            Description -> "List of QuantityArray from an analyte dissociation step to fit to.",
            Widget -> Widget[Type->Expression, Pattern:>{QuantityCoordinatesP[]..}, PatternTooltip->"A list of quantity arrays which are in the form of {time, response}.", Size->Paragraph]
          }
        },
        Outputs :> {
          {
            OutputName -> "testSummary",
            Description -> "The EmeraldTestSummary of AnalyzeBindingKinetics['associationData', 'dissociationData'].",
            Pattern :> (EmeraldTestSummary| Boolean)
          }
        }
      },

      {
        Definition -> {"ValidAnalyzeBindingKineticsQ[kineticData]", "testSummary"},
        Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeBindingKinetics['kineticData'] for all the gathered tests/warnings or a single Boolean indicating validity.",
        Inputs :> {
          {
            InputName -> "kineticData",
            Description -> "BioLayerInterferometry kinetics data or protocol containing kinetics data fields.",
            Widget -> Alternatives[
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ],
              Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "testSummary",
            Description -> "The EmeraldTestSummary of AnalyzeBindingKinetics['kineticData'].",
            Pattern :> (EmeraldTestSummary| Boolean)
          }
        }
      }

    },

    SeeAlso -> {
      "AnalyzeKinetics",
      "AnalyzeBindingKinetics"
    },
    Author -> {"alou", "robert"}
  }];