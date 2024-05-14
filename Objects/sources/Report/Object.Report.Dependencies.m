

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Dependencies], {
	Description->"Report of a dependency graph calculation of all symbols in an Emerald`* Context.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Commit -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "SHA1 hash of the git commit the graph was calculated on.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Branch -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Git branch the dependency graph was calculated on.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Graph -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> _Graph,
			Units -> None,
			Description -> "Dependency graph of all symbols in an Emerald`* Context.",
			Category -> "Organizational Information"
		},
		ObjectFunctions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> _Association,
			Units -> None,
			Description -> "A lookup of object references to the functions that contain them within their source code.",
			Category -> "Organizational Information"
		},
		TypeFunctions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> _Association,
			Units -> None,
			Description -> "A lookup of types to the functions that contain references to those types within their source code.",
			Category -> "Organizational Information"
		},
		Distro-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Software,Distro],
			Description -> "The pre-built set of packages for a specific commit of SLL used to generate this report.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
