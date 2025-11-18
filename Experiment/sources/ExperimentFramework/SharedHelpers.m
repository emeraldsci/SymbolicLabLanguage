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
commonFumeHoodHandlingStationModels[fakeString_] := commonFumeHoodHandlingStationModels[fakeString] = (
	If[!MemberQ[$Memoization, Experiment`Private`commonFumeHoodHandlingStationModels],
		AppendTo[$Memoization, Experiment`Private`commonFumeHoodHandlingStationModels]
	];
	Complement[Search[Model[Instrument, HandlingStation, FumeHood], Deprecated != True && DeveloperObject != True], $SpecializedHandlingStationModels]
);
