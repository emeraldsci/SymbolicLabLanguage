(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
DefineObjectType[Model[Part,BristlePlate],
  {
    Description->"A model plate with bristles sticking out that is used to clean ColonyHandlerHeadCassettes.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {
      NumberOfBristles -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "The number of bristles on the bristle plate that are used to clean a ColonyHandlerHeadCassette.",
        Category -> "Organizational Information"
      }
    }
  }
];