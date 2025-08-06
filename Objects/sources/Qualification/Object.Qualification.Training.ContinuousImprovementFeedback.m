(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,ContinuousImprovementFeedback], {
  Description -> "A protocol that verifies an operator's ability to follow the continuous improvement feedback submission process.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    FeedbackVerified -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if a trainer has verified that the trainee followed the continuous improvement feedback process correctly.",
      Category -> "General"
    }
  }
}]