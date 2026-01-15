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



(* ::Subsubsection::Closed:: *)
(*SafeNow*)
DefineUsage[SafeNow,
	{
		BasicDefinitions -> {
			{"SafeNow[]", "dateTime", "returns a DateObject representing the current moment in time, that isn't affected by overwriting the definition of Now."}
		},
		MoreInformation -> {
			"Defined in the same way as the Now function, however its value is not affected by Block/Stub of Now symbol.",
			"SafeNow symbol is Locked, preventing the symbol for being Blocked or Stubbed.",
			"Important for core infrastructure that requires the correct time, even when the value of Now is overridden, such as in the unit testing environment.",
			"The value of SafeNow can still be corrupted by redefining DateObject[] but this should never be done."
		},
		Input :> {
		},
		Output :> {
			{"dateTime", _?DateObjectQ, "A DateObject representing the current moment in time."}
		},
		SeeAlso -> {
			"Protect",
			"Now",
			"Locked"
		},
		Author -> {
			"david.ascough"
		}
	}
];