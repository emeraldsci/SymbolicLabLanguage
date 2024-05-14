(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*preResolveExtractMixOptions*)

DefineUsage[preResolveExtractMixOptions,
  {
    BasicDefinitions -> {
      {"preResolveExtractMixOptions[OptionList, MethodPacket, MixStepBoolean, MixOptionNameMap]", "Pre-resolvedMixOptions", "uses the `OptionsList` to pull mix options using the `MixOptionNameMap` and either sets the mix options to the value specified in the `OptionsList`, their value in the method (from the `MethodPacket`), sets the mix options to Null (if `MixStepBoolean` is False), or sets them to Null or default values according to the mix options that are already set. The mix options (including Automatics if specified to be resolved later in a different function) are then returned as a list of rules in the `Pre-resolvedMixOptions`."}
    },
    Input :> {
      {
        "OptionsList", _Association, "An association of options that contain the mix options and their values."
      },
      {
        "MethodPacket", PacketP[Object[Method]] | Null, "A packet with method information to inform the mix options."
      },
      {
        "MixStepBoolean", BooleanP, "A boolean which indicates if the overall step that the mix options are used in will be used in the experiment (True) or not (False)."
      },
      {
        "MixOptionNameMap", {_Rule..}, "A list of rules that link the mix option name in the options list to the basic mix option name: MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, and MixInstrument."
      }
    },
    Output :> {
      {
        "Pre-resolvedMixOptions", RulesP, "Mix options that are either Automatic to be resolved later, or resolved to their default values based on any already set values."
      }
    },
    SeeAlso -> {
      "resolveExtractMixOptions"
    },
    Author -> {
      "taylor.hochuli"
    }
  }
];

(* ::Subsection:: *)
(*resolveExtractMixOptions*)

DefineUsage[resolveExtractMixOptions,
  {
    BasicDefinitions -> {
      {"resolveExtractMixOptions[OptionList, MethodPacket, MixStepBoolean, MixOptionNameMap]", "ResolvedMixOptions", "uses the `OptionsList` to pull mix options using the `MixOptionNameMap` and either sets the mix options to the value specified in the `OptionsList`, their value in the method (from the `MethodPacket`), sets the mix options to Null (if `MixStepBoolean` is False), or sets them to Null or default values according to the mix options that are already set. The mix options are then returned as a list of rules in the `ResolvedMixOptions`."}
    },
    Input :> {
      {
        "OptionsList", _Association, "An association of options that contain the mix options and their values."
      },
      {
        "MethodPacket", PacketP[Object[Method]] | Null, "A packet with method information to inform the mix options."
      },
      {
        "MixStepBoolean", BooleanP, "A boolean which indicates if the overall step that the mix options are used in will be used in the experiment (True) or not (False)."
      },
      {
        "MixOptionNameMap", {_Rule..}, "A list of rules that link the mix option name in the options list to the basic mix option name: MixType, MixRate, MixTime, NumberOfMixes, MixVolume, MixTemperature, and MixInstrument."
      }
    },
    Output :> {
      {
        "ResolvedMixOptions", RulesP, "Mix options that are resolved to their default values based on any already set values."
      }
    },
    SeeAlso -> {
      "preResolveExtractMixOptions"
    },
    Author -> {
      "taylor.hochuli"
    }
  }
];
(* ::Subsection:: *)
(*extractionMethodValidityTest*)
DefineUsage[extractionMethodValidityTest,
  {
    BasicDefinitions -> {
      {
        "extractionMethodValidityTest[samples, resolvedOptions, gatherTestsQ]",
        "{invalidMethodTests, invalidMethodOptions}",
        "returns a list of tests and invalid options of Method if the method object failed ValidObjectQ for the method type. If gatherTestsQ is False, extractionMethodValidityTest returns empty tests and also returns Error::InvalidExtractionMethod if triggered. If gatherTestsQ is True, extractionMethodValidityTest returns tests and does not throw an error message."
      }
    },
    {
      Input :> {
        {"samples", {ObjectP[Object[Sample]]..}, "A sample object or list of sample objects for which the Method from resolvedOptions will be checked for validity."},
        {"resolvedOptions", {_Rule..}, "The experiment options of the parent function that contains the resolved Method option."},
        {"gatherTestsQ", BooleanP, "Indicates if tests are being gathered and messages are silenced, or tests are not gathered and messages are thrown."}
      },
      Output :> {
        {"invalidMethodTests", {ListableP[TestP]...}, "A list of tests checking if the method object passes ValidObjectQ for the method type."},
        {"invalidMethodOptions", _List, "A list of Method if the method object failed ValidObjectQ for the method type."}
      },
      SeeAlso -> {"ValidObjectQ", "checkPurificationConflictingOptions","solidPhaseExtractionConflictingOptionsChecks","mbsMethodsConflictingOptionsTests"},
      Author -> {"taylor.hochuli"}
    }
  }
];
