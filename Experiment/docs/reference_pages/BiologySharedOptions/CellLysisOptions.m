(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*checkLysisConflictingOptions*)

DefineUsage[checkLysisConflictingOptions,
  {
    BasicDefinitions -> {
      {"checkLysisConflictingOptions[samples, mapThreadFriendlyOptions, messagesQ]",
        "{lysisConflictingOptions, lysisConflictingOptionsTest}",
        "returns a list of lysis options that are set even though Lyse is set to False. If messagesQ is True, checkLysisConflictingOptions also returns an error (Error::LysisConflictingOptions). If messagesQ is False, checkLysisConflictingOptions returns tests and does not throw an error message."}
    },
    Input :> {
      {"samples", {ObjectP[Object[Sample]]..}, "A sample object or list of sample objects for which mapThreadFriendlyOptions will be checked for conflicting lysis options."},
      {"mapThreadFriendlyOptions", {_Association..}, "A list of associations made by calling Options`Private`mapThreadOptions[] on experiment options"},
      {"messagesQ", BooleanP, "Indicates if messages are being thrown or tests are being gathered and messages silenced."}
    },
    Output :> {
      {"lysisConflictingOptions", _List, "A list of lysis options that are set even though Lyse is set to False."},
      {"lysisConflictingOptionsTest", {TestP...}, "A list of tests checking if there are conflicting lysis options for the input samples."}
    },
    SeeAlso -> {"checkSolidMedia", "checkPurificationConflictingOptions"},
    Author -> {"taylor.hochuli", "josh.kenchel"}
  }
]