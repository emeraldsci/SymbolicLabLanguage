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
(*specializedHandlingStationModels*)
(* a memoized search to get all SPECIALIZED handling station models *)
(* this is a list of handling station models that we should only try to use when specified, but not via auto-resolution since they contain specialized instruments inside and we do not want to just direct normal transfers inside *)


specializedHandlingStationModels[memoizationString_] := specializedHandlingStationModels[memoizationString] = (
	If[!MemberQ[$Memoization, Experiment`Private`specializedHandlingStationModels],
		AppendTo[$Memoization, Experiment`Private`specializedHandlingStationModels]
	];
	Search[Model[Instrument, HandlingStation], Deprecated != True && DeveloperObject != True && Specialized == True]
);