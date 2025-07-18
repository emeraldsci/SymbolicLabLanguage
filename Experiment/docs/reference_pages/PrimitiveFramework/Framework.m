(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Help Files*)

DefineUsage[ValidOpenPathsQ,
	{
		BasicDefinitions -> {
			{"ValidOpenPathsQ[myFunction]", "boolean", "returns True if all options of 'myFunction' have OpenPaths properly defined for its options that can take models, products, or methods."}
		},
		Input :> {
			{"myFunction", _Symbol, "Function whose options are checked for whether they are using OpenPaths and using it correctly."}
		},
		Output :> {
			{"boolean", BooleanP, "A boolean that indicates if 'myFunction' has OpenPaths defined correctly."}
		},
		SeeAlso -> {"DefineOptions", "Widget", "ValidWidgetQ"},
		Author -> {"steven"}
	}
];