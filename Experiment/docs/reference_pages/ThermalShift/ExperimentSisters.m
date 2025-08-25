(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ValidExperimentThermalShiftQ*)
(* TODO check these usages after meeting with Frezza about the main experiment function usage *)

DefineUsage[ValidExperimentThermalShiftQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentThermalShiftQ[Samples]", "Boolean"},
        Description -> "returns a 'Boolean' indicating the validity of an ExperimentThermalShift call for measuring sample fluorescence during heating and cooling (melting curve analysis) to determine shifts in thermal stability of 'Samples' under varying conditions.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples to be analyzed for thermal stability.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
                Dereference->{Object[Container]->Field[Contents[[All,2]]]}
              ],
              Expandable->False,
              NestedIndexMatching->True
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Boolean",
            Description -> "A True/False value indicating the validity of the provided ExperimentThermalShift call.",
            Pattern :> BooleanP
          }
        }
      }
    },
    MoreInformation -> {
      "This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentThermalShift proper, will return a valid experiment."
    },
    SeeAlso -> {
      "ExperimentThermalShift",
      "ExperimentThermalShiftOptions",
      "ExperimentThermalShiftPreview"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"dima", "steven", "simon.vu", "millie.shah"}
  }
];


(* ::Subsection:: *)
(*ExperimentThermalShiftOptions*)

DefineUsage[ExperimentThermalShiftOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentThermalShiftOptions[Samples]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for measuring sample fluorescence during heating and cooling (melting curve analysis) to determine shifts in thermal stability of 'Samples' under varying conditions.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples to be analyzed for thermal stability.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
                Dereference->{Object[Container]->Field[Contents[[All,2]]]}
              ],
              Expandable->False,
              NestedIndexMatching->True
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "ResolvedOptions",
            Description -> "Resolved options when ExperimentThermalShiftOptions is called on the input samples.",
            Pattern :> {(_Rule|_RuleDelayed)..}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentThermalShift."
    },
    SeeAlso -> {
      "ExperimentThermalShift",
      "ValidExperimentThermalShiftQ",
      "ExperimentThermalShiftPreview"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"dima", "steven", "simon.vu", "millie.shah"}
  }
];


(* ::Subsection:: *)
(*ExperimentThermalShiftPreview*)

DefineUsage[ExperimentThermalShiftPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentThermalShiftPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for measuring sample fluorescence during heating and cooling (melting curve analysis) to determine shifts in thermal stability of 'Samples' under varying conditions.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples to be analyzed for thermal stability.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
                Dereference->{Object[Container]->Field[Contents[[All,2]]]}
              ],
              Expandable->False,
              NestedIndexMatching->True
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Preview",
            Description -> "A graphical representation of the provided ThermalShift experiment. This value is always Null.",
            Pattern :> BooleanP
          }
        }
      }
    },
    MoreInformation -> {

    },
    SeeAlso -> {
      "ExperimentThermalShift",
      "ValidExperimentThermalShiftQ",
      "ExperimentThermalShiftOptions"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"dima", "steven", "simon.vu", "millie.shah"}
  }
];