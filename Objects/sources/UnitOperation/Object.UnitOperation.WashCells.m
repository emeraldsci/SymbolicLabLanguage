(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* NOTE: WashCells is the same as ChangeMedia. *)
With[{insertMe=$SharedChangeMediaUnitOperationFields},
  DefineObjectType[Object[UnitOperation, WashCells],{
    Description->"The group of default settings that should be used when washing a given cell culture.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->Flatten[{
      insertMe,
      {
        MethodLink -> {
          Format -> Multiple,
          Class -> Link,
          Pattern :> _Link,
          Relation -> Alternatives[Object[Method,WashCells]],
          Description -> "For each member of SampleLink, the set of reagents and recommended operating conditions which are used to change media of the cell sample.",
          Category -> "General",
          IndexMatching -> SampleLink,
          Migration -> SplitField
        }
      }
    }]
  }]
];
