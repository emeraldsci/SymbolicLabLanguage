(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Favorite, Folder], {
  Description -> "A folder object that can hold multiple favorite objects.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    DisplayName -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "Display name of the folder containing favorite objects, this is a required field.",
      Category -> "Organizational Information"
    },
    Team -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Team,Financing][FavoriteFolders],
      Description -> "The team whose members should be able to see this folder.",
      Category -> "General"
    },
    Columns -> {
      Format->Multiple,
      Class -> {
        ColumnObjectType -> String,
        ColumnFields -> String,
        ColumnLabels -> String
      },
      Pattern :> {
        ColumnObjectType -> _,
        ColumnFields -> _String,
        ColumnLabels -> _String
      },
      Description -> "The information needed to display objects of each type including their requested fields and field labels.",
      Category -> "General"
    },
    FavoriteObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Favorite][FavoriteFolder],
      Description -> "All the favorite objects within this folder that have been saved for later.",
      Category -> "General"
    }
  }
}];
