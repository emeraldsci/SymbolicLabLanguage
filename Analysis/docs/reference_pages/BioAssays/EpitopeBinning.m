(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeEpitopeBinnning*)

DefineUsage[AnalyzeEpitopeBinning,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeEpitopeBinning[dataObject]", "object"},
        Description -> "classifies antibodies by their interaction with a given antigen using 'dataObject' collected by biolayer interferometry.",
        Inputs :> {
          {
            InputName -> "dataObject",
            Description -> "BioLayerInterferometry data objects generated from ExperimentBioLayerInterferometry.",
            Widget -> Alternatives[
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ],
              Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The object containing quantitative analysis of cross blocking between a given set of antibodies when binding the same antigen.",
            Pattern :> ObjectP[Object[Analysis, EpitopeBinning]]
          }
        }
      },

      {
        Definition -> {"AnalyzeEpitopeBinning[protocolObject]", "object"},
        Description -> "classifies antibodies by their interaction with a given antigen using data found in 'protocolObject' for ExperimentBioLayerInterferometry.",
        Inputs :> {
          {
            InputName -> "protocolObject",
            Description -> "BioLayerInterferometry protocol object for an epitope binning experiment.",
            Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The object containing quantitative analysis of cross blocking between a given set of antibodies when binding the same antigen.",
            Pattern :> ObjectP[Object[Analysis, EpitopeBinning]]
          }
        }
      }

    },
    MoreInformation -> {
      "Cross blocking is quantitated by the maximum bio-layer thickness achieved during the association of the second (competing) antibody. If the change in biolayer thickness during exposure to the secondary (competing) antibody exceeds the specified threshold, the two antibodies are considered to bind distinct epitopes and are placed in different bins. If the change in biolayer thickness does not exceed this threshold, they will be placed in the same bin. There are options to set a low binding threshold for certain species, in the even that some antibody-antigen interactions are sufficiently slow that even with long association times they may not reach a comparable bio-layer thickness to the other measured antibodies.",
      "The success of this experiment and validity of the analysis is highly dependent on verifying the on and off rates of the tested antibody/antigen pairings. Ensure that the initial antibody/antigen pairing does not have an excessively high dissociation rate, which will invalidate the experimental results.",
      "All pairings are reported in the A -> B and B -> A binding format.",
      "Any number of data object can be input to this function, though it is highly recommended that every combination of antibodies is studies for most accurate results. If this is not the case, it is possible that antibodies that bind the same epitope will appear in different bins due to a lack of experimental data."
    },
    SeeAlso -> {
      "AnalyzeBindingKinetics",
      "ExperimentBioLayerInterferometry",
      "AnalyzeBindignQuantitation",
      "AnalyzeEpitopeBinningPreview",
      "AnalyzeEpitopeBinningOptions",
      "ValidAnalyzeEpitoepBinningQ"
    },
    Author -> {"alou", "robert"},
    Guides -> {
      "AnalysisCategories",
      "ExperimentAnalysis"
    },
    Preview->True
  }];


(* ::Subsubsection:: *)
(*AnalyzeEpitopeBinningOptions*)


DefineUsage[AnalyzeEpitopeBinningOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeEpitopeBinningOptions[dataObject]", "options"},
        Description -> "returns all 'options' for AnalyzeEpitopeBinning['dataObject'] with all Automatic options resolved to fixed values.",
        Inputs :> {
          {
            InputName -> "dataObject",
            Description -> "BioLayerInterferometry data objects generated from ExperimentBioLayerInterferometry.",
            Widget ->
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ]
          }
        },
        Outputs :> {
          {
            OutputName -> "options",
            Description -> "The resolved options in the AnalyzeEpitopeBinning call.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
          }
        }
      },
      {
        Definition -> {"AnalyzeEpitopeBinningOptions[protocolObject]", "options"},
        Description -> "returns all 'options' for AnalyzeEpitopeBinning['protocolObject'] with all Automatic options resolved to fixed values.",
        Inputs :> {
          {
            InputName -> "protocolObject",
            Description -> "BioLayerInterferometry protocol object for an epitope binning experiment.",
            Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "options",
            Description -> "The resolved options in the AnalyzeEpitopeBinning call.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
          }
        }
      }
    },

    SeeAlso -> {
      "AnalyzeEpitopeBinning",
      "ExperimentBioLayerInterferomtry",
      "AnalyzeBindingKinetics",
      "AnalyzeBindingQuantitation"
    },
    Author -> {"alou", "robert"}
  }];


(* ::Subsubsection:: *)
(*AnalyzeEpitopeBinningPreview*)


DefineUsage[AnalyzeEpitopeBinningPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeEpitopeBinningPreview[dataObject]", "preview"},
        Description -> "returns a graphical display representing AnalyzeEpitopeBinning['protocolObject'] output.",
        Inputs :> {
          {
            InputName -> "dataObject",
            Description -> "BioLayerInterferometry data objects generated from ExperimentBioLayerInterferometry.",
            Widget ->
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ]
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical display representing the AnalyzeEpitopeBinning call output.",
            Pattern :> (ValidGraphicsP[] | Null)
          }
        }
      },
      {
        Definition -> {"AnalyzeEpitopeBinningPreview[protocolObject]", "preview"},
        Description -> "returns a graphical display representing AnalyzeEpitopeBinning['protocolObject'] output.",
        Inputs :> {
          {
            InputName -> "protocolObject",
            Description -> "BioLayerInterferometry protocol object for an epitope binning experiment.",
            Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical display representing the AnalyzeEpitopeBinning call output.",
            Pattern :> (ValidGraphicsP[] | Null)
          }
        }
      }

    },

    SeeAlso -> {
      "AnalyzeEpitopeBinning",
      "ValidAnalyzeEpitopeBinningQ",
      "AnalyzeBindingQuantitation",
      "AnalyzeBindingKinetics",
      "ExperimentBioLayerInterferometry"
    },
    Author -> {"alou", "robert"}
  }];


(* ::Subsubsection:: *)
(*ValidAnalyzeEpitopeBinningQ*)


DefineUsage[ValidAnalyzeEpitopeBinningQ,
  {
    BasicDefinitions -> {

      {
        Definition -> {"ValidAnalyzeEpitopeBinningQ[dataObject]", "testSummary"},
        Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeEpitopeBinning['dataObjects'] for all the gathered tests/warnings or a single Boolean indicating validity.",
        Inputs :> {
          {
            InputName -> "dataObject",
            Description -> "BioLayerInterferometry data objects generated from ExperimentBioLayerInterferometry.",
            Widget ->
              Adder[
                Widget[Type->Object, Pattern:>ObjectP[Object[Data,BioLayerInterferometry]]]
              ]
          }
        },
        Outputs :> {
          {
            OutputName -> "testSummary",
            Description -> "The EmeraldTestSummary of AnalyzeEpitopeBinning['dataObjects'].",
            Pattern :> (EmeraldTestSummary| Boolean)
          }
        }
      },
      {
        Definition -> {"ValidAnalyzeEpitopeBinningQ[protocolObject]", "testSummary"},
        Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeEpitopeBinning['protocolObject'] for all the gathered tests/warnings or a single Boolean indicating validity.",
        Inputs :> {
          {
            InputName -> "protocolObject",
            Description -> "BioLayerInterferometry protocol object for an epitope binning experiment.",
            Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,BioLayerInterferometry]]]
          }
        },
        Outputs :> {
          {
            OutputName -> "testSummary",
            Description -> "The EmeraldTestSummary of AnalyzeEpitopeBinning['protocolObject'].",
            Pattern :> (EmeraldTestSummary| Boolean)
          }
        }
      }
    },

    SeeAlso -> {
      "AnalyzeEpitopeBinning",
      "AnalyzeEpitopeBinningPreview",
      "ExperimentBioLayerInterferometry",
      "AnalyzeBindingKinetics",
      "AnalyzeBindingQuantitation"
    },
    Author -> {"alou", "robert"}
  }];