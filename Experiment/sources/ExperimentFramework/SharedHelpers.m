(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(* deleteJLink *)
(* removes JLink` from the $ContextPath *)
Authors[deleteJLink]={"dima"};
deleteJLink[]:=($ContextPath=DeleteCases[$ContextPath,"JLink`"]);