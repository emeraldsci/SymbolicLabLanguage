(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*removeConflictingNonAutomaticOptions*)

(* this function is useful for generating UOs for options that are not automatic.  this changes Automatics to the default values *)
removeConflictingNonAutomaticOptions[myUnitOperationHead_Symbol, myProvidedOptions_List]:=Module[{safeOps, nonAutomaticOptions, changedOptions},

  (* get the safe options for the unit operation in question *)
  safeOps = SafeOptions[myUnitOperationHead];

  (* get the non-Automatic options *)
  nonAutomaticOptions = Select[safeOps, Not[MatchQ[#[[2]], Automatic]] && MemberQ[Keys[myProvidedOptions], #[[1]]]&];

  (* get the options that we want to remove from the ones provided *)
  changedOptions = Map[
    With[{optionName = First[#], optionDefault = Last[#]},
      optionName -> Lookup[myProvidedOptions, optionName] /. {Automatic -> optionDefault}
    ]&,
    nonAutomaticOptions
  ];

  ReplaceRule[myProvidedOptions, changedOptions]

];