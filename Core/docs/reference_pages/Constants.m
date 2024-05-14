(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*DefineConstant*)

DefineUsage[DefineConstant,
	{
		BasicDefinitions -> {
			{"DefineConstant[sym,val]", "out", "defines a protected constant value."},
			{"DefineConstant[sym,val,Usage]", "out", "defines a protected constant value with the given Usage definition."}
		},
		MoreInformation -> {
			"Will unprotect and protect the symbol so that the definition can be re-evaluated without throwing errors."
		},
		Input :> {
			{"sym", _Symbol, "Symbol to assign constant value to."},
			{"val", _, "Value to assign to the Symbol \"sym\"."},
			{"Usage", _String, "Usage string for the Symbol \"sym\"."}
		},
		Output :> {
			{"out", Null, "Returns Null."}
		},
		SeeAlso -> {
			"Protect",
			"Unprotect",
			"Information",
			"Message"
		},
		Author -> {
			"platform"
		}
	}];
