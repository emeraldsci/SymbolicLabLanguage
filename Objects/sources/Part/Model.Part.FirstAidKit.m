(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,FirstAidKit],{
  Description->"Model information for a part that contains materials and tools used for giving emergency treatment to a sick or injured person.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    FirstAidKitClassification -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> FirstAidKitTypeP,
      Description -> "Classification of the portability, resistance to water, corrosion, and impacts, and their ability to be mounted of first aid kits.",
      Category -> "Part Specifications"
    },
    FirstAidKitUsage -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> FirstAidKitClassP,
      Description -> "Description of the intended use for type of injuries first aid kit treats.",
      Category -> "Part Specifications"
    },
    InitialContents ->{
      Format->Multiple,
      Class->{String,Integer},
      Pattern:>{_String,GreaterP[0,1]},
      Description->"A list of all the first aid objects that this kit comes with and the count of each item.",
      Category->"Part Specifications",
      Headers->{"Item","Count"}
    },
    MinimumContents -> {
      Format->Multiple,
      Class->{String,Integer},
      Pattern:>{_String,GreaterP[0,1]},
      Description->"A list of all the first aid objects that this kit comes has and the minimum count of each item.",
      Category->"Part Specifications",
      Headers->{"Item","Count"}
    }
  }
}];