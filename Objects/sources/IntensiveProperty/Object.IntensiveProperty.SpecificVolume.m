(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[IntensiveProperty,SpecificVolume], {
  Description->"Information about the pH of a mixture of compounds at room temperature.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    SpecificVolume ->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterEqualP[0*Milliliter/Gram],
      Relation->Null,
      Units->Milliliter/Gram,
      Description->"For each member of Compositions, the SpecificVolume of the mixture of components at room temperature.",
      Category -> "Organizational Information",
      IndexMatching->Compositions
    }
  }
}];
