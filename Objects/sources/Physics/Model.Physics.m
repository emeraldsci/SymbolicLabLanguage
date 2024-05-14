(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics], {
  Description->"Definition of a set of physical parameters used to calculate or predict the expected experimental values. Whenever possible, these parameters are referenced from literature sources.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    (* --- Organizational Information --- *)
    Name -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The name of this model.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    Authors -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> ObjectP[Object[User]],
      Relation -> Object[User],
      Description -> "The users who generated this model.",
      Category -> "Organizational Information"
    },
    LiteratureReferences -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Report, Literature][References],
      Description -> "Publications containing references to the derivation of the parameters stored in this model.",
      Category -> "Organizational Information"
    },
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this physics model is historical and no longer used in the lab.",
			Category -> "Organizational Information"
		},
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this model is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information",
      Developer -> True
    }
  }
}];
