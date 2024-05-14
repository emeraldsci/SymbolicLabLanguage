(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Method],
	{
		Description -> "Model information describing a reusable set of parameters that describes the execution a granular experimental task.",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {
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
			}
		}
	}
];
