(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(* deleteJLink *)
(* removes JLink` from the $ContextPath *)
Authors[deleteJLink]={"dima"};
deleteJLink[]:=($ContextPath=DeleteCases[$ContextPath,"JLink`"]);




(* ::Subsection:: *)
(*commonFumeHoodHandlingStationModels*)
(* a memoized search to get common fumehood handling station models *)
commonFumeHoodHandlingStationModels[memoizationString_] := commonFumeHoodHandlingStationModels[memoizationString] = (
	If[!MemberQ[$Memoization, Experiment`Private`commonFumeHoodHandlingStationModels],
		AppendTo[$Memoization, Experiment`Private`commonFumeHoodHandlingStationModels]
	];
	Search[Model[Instrument, HandlingStation, FumeHood], Deprecated != True && DeveloperObject != True && Specialized != True]
);


(* ::Subsection:: *)
(*microbialBSCModels*)
(* a memoized search to get microbial BSC handling station models *)
microbialBSCModels[memoizationString_] := microbialBSCModels[memoizationString] = (
	If[!MemberQ[$Memoization, Experiment`Private`microbialBSCModels],
		AppendTo[$Memoization, Experiment`Private`microbialBSCModels]
	];
	Search[Model[Instrument, HandlingStation, BiosafetyCabinet], Deprecated != True && DeveloperObject != True && Specialized != True && CultureHandling == Microbial]
);


(* ::Subsection:: *)
(*nonMicrobialBSCModels*)
(* a memoized search to get non-microbial BSC handling station models *)
nonMicrobialBSCModels[memoizationString_] := nonMicrobialBSCModels[memoizationString] = (
	If[!MemberQ[$Memoization, Experiment`Private`nonMicrobialBSCModels],
		AppendTo[$Memoization, Experiment`Private`nonMicrobialBSCModels]
	];
	Search[Model[Instrument, HandlingStation, BiosafetyCabinet], Deprecated != True && DeveloperObject != True && Specialized != True && CultureHandling == NonMicrobial]
);


(* ::Subsection:: *)
(*asepticTransferBSCModels*)
(* a memoized search to get aseptic transfer BSC handling station models *)
asepticTransferBSCModels[memoizationString_] := asepticTransferBSCModels[memoizationString] = (
	If[!MemberQ[$Memoization, Experiment`Private`asepticTransferBSCModels],
		AppendTo[$Memoization, Experiment`Private`asepticTransferBSCModels]
	];
	Search[Model[Instrument, HandlingStation, BiosafetyCabinet], Deprecated != True && DeveloperObject != True && Specialized != True && CultureHandling == Null]
);



(* ::Subsection:: *)
(*specializedHandlingStationModels*)
(* a memoized search to get all SPECIALIZED handling station models *)
(* this is a list of handling station models that we should only try to use when specified, but not via auto-resolution since they contain specialized instruments inside and we do not want to just direct normal transfers inside *)


specializedHandlingStationModels[memoizationString_] := specializedHandlingStationModels[memoizationString] = (
	If[!MemberQ[$Memoization, Experiment`Private`specializedHandlingStationModels],
		AppendTo[$Memoization, Experiment`Private`specializedHandlingStationModels]
	];
	Search[Model[Instrument, HandlingStation], Deprecated != True && DeveloperObject != True && Specialized == True]
);

(* ::Subsection:: *)
(*indexMatchingOptions*)

(* this is a function that gets all the index matching option names (as symbols) of a given fucntion (usually an Experiment function) *)
(* by default it looks for the ones indexed matched to "experiment samples", but you can specify the index matching pattern if you want *)
indexMatchingOptions[myFunction_Symbol]:=indexMatchingOptions[myFunction, "experiment samples"];
indexMatchingOptions[myFunction_Symbol, myIndexMatchingParent:(_String | _Symbol)]:=Module[
	{optionDefinitions, relevantOptionDefinitions},

	optionDefinitions = OptionDefinition[myFunction];

	(* need to check IndexMatchingInput OR IndexMatchingParent *)
	(* also we need to have a string, even if it's defined as a Symbol in the code; ToString is fine either way *)
	relevantOptionDefinitions = Cases[
		optionDefinitions,
		KeyValuePattern["IndexMatchingInput" -> ToString[myIndexMatchingParent]] | KeyValuePattern["IndexMatchingParent" -> ToString[myIndexMatchingParent]]
	];

	ToExpression[Lookup[relevantOptionDefinitions, "OptionName", {}]]
];