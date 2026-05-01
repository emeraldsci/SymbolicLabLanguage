(* ::Package:: *)

(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*indexMatchingOptions*)

DefineUsage[indexMatchingOptions,
	{
		BasicDefinitions -> {
			{"indexMatchingOptions[functionName]", "optionNames", "returns the 'optionNames' of 'functionName' that are index matching to the experiment samples."},
			{"indexMatchingOptions[functionName, indexMatchingParent]", "optionNames", "returns the 'optionNames' of 'functionName' that are index matching to the specified 'indexMatchingParent'"}
		},
		Input:>{
			{"functionName", _Symbol, "The function whose index matching options are being returned."},
			{"indexMatchingParent", _Symbol | _String, "The index matching input or parent option used to determine which options to return."}
		},
		Output:>{
			{"optionNames", {_Symbol...},"All option symbols that are index matching to the specified parent (or index matching to the experiment samples if unspecified)."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"OptionDefinition",
			"DefineOptions"
		},
		Author->{"steven"}
	}
];
