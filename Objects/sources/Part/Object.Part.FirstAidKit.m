(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, FirstAidKit], {
  Description->"A part that contains materials and tools used for giving emergency treatment to a sick or injured person.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    CurrentCount->{
      Format->Multiple,
      Class->{String,Integer},
      Pattern:>{_String,GreaterP[0,1]},
      Description->"A list of all the first aid objects and the current count of each item.",
      Category->"Part Specifications",
      Headers->{"Item","Count"}
    }
  }
}];