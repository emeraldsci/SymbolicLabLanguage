(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(* resolveRoboticAliquotContainers *)

(*::Subsection::Closed::*)
(* removeConflictingNonAutomaticOptions *)

DefineUsage[removeConflictingNonAutomaticOptions,
  {
    BasicDefinitions -> {
      {
        "removeConflictingNonAutomaticOptions[unitOperationHead, options]",
        "processedOptions",
        "removes Automatic in the options of the parent function if the corresponding option in the UO child function has a default value instead of Automatic. This helper function can be called to process the options before generating the unit operation or calling the child function resolver."
      }
    },
    Input :> {
      {
        "unitOperationHead", {_Symbol..}, "The symbol of the unit operation head that the child function resolver will be called with the processedOptions."
      },
      {
        "options", {_Rule..}, "A list of preResolved or unresolved options that may contain option values of Automatic."
      }
    },
    Output :> {
      {
        "processedOptions", {_Rule..}, "The list of options with Automatic replaced by child function's default if the child function does not have Automatic defined for the corresponding option in the parent function."
      }
    },
    SeeAlso -> {},
    Author -> {"taylor.hochuli"}
  }
]