(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, TabletCutter], {
  Description -> "Model information for an enclosed blade used to split tablets.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    AsymmetricCut -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if this item can be used to cut a tablet along a specified line other than through a central axis.",
      Category -> "Physical Properties",
      Abstract -> True
    }
  }
}];



