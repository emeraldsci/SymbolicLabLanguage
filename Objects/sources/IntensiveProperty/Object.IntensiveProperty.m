(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty], {
	Description->"Information about a property of a mixture of compounds that does not change with the total amount of sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Models ->{ (* Note: This field is sorted using the function Sort[...]. *)
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->IdentityModelTypeP,
			Description->"The molecular identities that pertain to this intensive property.",
			Category -> "Organizational Information",
			Abstract->True
		},
		Compositions ->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(CompositionP|Null)...},
			Relation->Null,
			Description->"The amount of each molecular model for each given measurement of the itensive property.",
			Category -> "Organizational Information",
			Abstract->True
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
