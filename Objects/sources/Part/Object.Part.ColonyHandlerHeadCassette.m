(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

DefineObjectType[Object[Part,ColonyHandlerHeadCassette],
  {
    Description->"Tools used to pick spread or streak colonies onto plates.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->{
      ColonyHandlerHeadCassetteHolder -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Object[Container, ColonyHandlerHeadCassetteHolder][ColonyHandlerHeadCassette],
        Description -> "The container a ColonyHandlerHeadCassette sits in while not in use by the QPix.",
        Category -> "General"
      }
    }
  }
];

