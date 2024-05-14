(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, TabletCutter], {
  Description -> "An enclosed blade used to split tablets.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    AsymmetricCut -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AsymmetricCut]],
      Pattern :> BooleanP,
      Description -> "Indicates if this item can be used to cut a tablet along a specified line other than through a central axis.",
      Category -> "Operating Limits",
      Abstract -> True
    }
  }
}];