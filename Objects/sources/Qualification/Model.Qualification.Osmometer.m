(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Osmometer],{
  Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of an osmometer.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    Samples -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The sample model that will be measured.",
      Category -> "Standard"
    },
    Replicates -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0,1],
      Description -> "The total number of times each test sample is measured for this qualification.",
      Category -> "General"
    }
  }
}];
