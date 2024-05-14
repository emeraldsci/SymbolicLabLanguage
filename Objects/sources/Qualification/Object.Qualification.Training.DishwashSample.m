(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,DishwashSample], {
  Description -> "A protocol that verifies an operator's ability to dishwash samples.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    QualificationTargetContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description -> "The target container object to be dishwashed in the qualification.",
      Category -> "General"
    }
  }
}];