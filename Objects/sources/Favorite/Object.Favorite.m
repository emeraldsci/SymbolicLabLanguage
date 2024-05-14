(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Favorite], {
  Description->"A favorite object used to represent base type for favorite or bookmark marked by command center user.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    (* --- Organizational Information --- *)
    Authors -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[User][FavoriteObjects],
      Description -> "The people who selected the object to be marked as favorite. When more than one person marks as favorite, this field will be appended.",
      Category -> "General"
    },
    FavoriteFolder -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Favorite, Folder][FavoriteObjects],
      Description -> "The folder where the favorite object is stored. Foe bookmark objects, this will always be Null.",
      Category -> "General"
    },
    TargetObject -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[],
        Model[]
      ],
      Description -> "The target object being saved as a favorite so it can be quickly accessed later.",
      Category -> "General"
    },
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information",
      Developer -> True
    }
  }
}];
