(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Favorite, Bookmark], {
  Description -> "A bookmark object that is either automatically created or marked by a user.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Status -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> FavoriteStatusP, (* Active | Inactive *)
      Description -> "Indicates if the user has flagged the favorite object for deletion.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    BookmarkPath -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The bookmark path where the bookmark for the object is located inside the page.",
      Category -> "Organizational Information",
      Developer -> True
    },
    BookmarkLocationIdentifier -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "Unique identifier for mathematica cell containing the bookmark within the notebook page.",
      Category -> "Organizational Information"
    },
    BookmarkNotebook -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Notebook, Script] | Object[Notebook, Page],
      Description -> "The script or page where the bookmark is located.",
      Category -> "Organizational Information"
    },
    NotebookScriptType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> NotebookScriptTypeP,
      Description -> "Within a script, indicates if the bookmark is on the template or the instance.",
      Category -> "Organizational Information"
    }
  }
}];
