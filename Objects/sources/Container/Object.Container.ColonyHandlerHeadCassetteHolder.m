(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
DefineObjectType[Object[Container,ColonyHandlerHeadCassetteHolder],
  {
    Description->"A container that can hold a ColonyHandlerHeadCassette without the pins touching the container.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {
      ColonyHandlerHeadCassette -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Object[Part, ColonyHandlerHeadCassette][ColonyHandlerHeadCassetteHolder],
        Description -> "The ColonyHandlerHeadCassette that is currently sitting in this holder.",
        Category -> "General"
      }
    }
  }
];