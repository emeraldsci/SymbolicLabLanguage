(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Example], {
		Description -> "Model data. Mostly used for unit testing.",
		CreatePrivileges->Developer,
		Cache -> Session,
		Fields -> {
			DeveloperObject -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> True | False,
				Description -> "True if a developer object (will be filtered out of searches).",
				Category -> "Organizational Information",
				Developer -> True
			}
		}
	}
];
