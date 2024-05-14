(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Method], {
	Description->"A reusable set of parameters that describes the execution a granular experimental subtask.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A unique name used to identify this method.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		(* --- Replicate Methods --- *)
		Template -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method][MethodsTemplated],
			Description -> "The method whose option selections should be selected as the default options for this method.",
			Category -> "General"
		},
		MethodsTemplated -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method][Template],
			Description -> "Methods which were generated using this method's options as a starting point for its option defaults.",
			Category -> "General"
		},
		(* --- Migration Support --- *)
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		}
	}
}];
