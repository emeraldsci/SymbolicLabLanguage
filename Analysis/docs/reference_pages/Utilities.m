(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



DefineUsage[PreviewSymbol,
{
	BasicDefinitions -> {
		{"PreviewSymbol[analysisFunction]", "dvar", "returns the symbol linked to the most recent preview plot created by 'analysisFunction'."}
	},
	Input :> {
		{"analysisFunction", _Symbol, "Name of the analysis function whose preview you want to interact with."}
	},
	Output :> {
		{"dvar", _Symbol, "The symbol linked to the interactive components of the preview figure."}
	},
	SeeAlso -> {
		"PreviewValue",
		"LogPreviewChanges",
		"SetupPreviewSymbol",
		"UpdatePreview"
	},
	Author -> {
		"brad"
	}
}];

DefineUsage[UpdatePreview,
{
	BasicDefinitions -> {
		{"UpdatePreview[dvar,newOptionRules]", "out", "updates the dynamic variable 'dvar' with the new option values from 'newOptionRules', which automatically updates the preview figure associated with 'dvar'."}
	},
	Input :> {
		{"dvar", _Symbol, "Symbol associated with the preview figure being updated."},
		{"newOptionRules",ListableP[Rule[_Symbol,_]], "New option values that will cause the preview figure to update."}
	},
	Output :> {
		{"out", Null, "Returns Null."}
	},
	SeeAlso -> {
		"PreviewValue",
		"LogPreviewChanges",
		"SetupPreviewSymbol",
		"PreviewSymbol"
	},
	Author -> {
		"brad"
	}
}];


DefineUsage[SetupPreviewSymbol,
{
	BasicDefinitions -> {
		{"SetupPreviewSymbol[func,xy,resolvedOptions]", "dv", "initializes the symbol 'dv' for use with an interactive preview in command builder."}
	},
	Input :> {
		{"func", _Symbol, "The function the preview is for."},
		{"xy", _, "The data coordinates used in the preview."},
		{"resolvedOptions",_List, "List of resolved options for 'func'."}
	},
	Output :> {
		{"df",_Symbol, "The symbol linked to the values in interactive preview for 'func'."}
	},
	SeeAlso -> {
		"UpdatePreview",
		"LogPreviewChanges",
		"PreviewSymbol"
	},
	Author -> {
		"brad"
	}
}];

DefineUsage[PreviewValue,
{
	BasicDefinitions -> {
		{"PreviewValue[dv,optionName]", "val", "returns the value associated with the option 'optionName' in the preview symbol 'dv'."}
	},
	Input :> {
		{"dv",_Symbol, "The symbol linked to the values in interactive preview being queried."},
		{"optionName", _Symbol, "The option whose value is returned."}
	},
	Output :> {
		{"val",_, "The current value of 'optionName' from 'dv'."}
	},
	SeeAlso -> {
		"UpdatePreview",
		"SetupPreviewSymbol",
		"LogPreviewChanges",
		"PreviewSymbol"
	},
	Author -> {
		"brad"
	}
}];

DefineUsage[LogPreviewChanges,
{
	BasicDefinitions -> {
		{"LogPreviewChanges[dv,newOptions]", "Null", "updates the give option values in 'dv'."}
	},
	Input :> {
		{"dv",_Symbol, "The symbol linked to the values in interactive preview being updated."},
		{"newOptions", {(_Symbol->_)..}, "List of option values to be updated in 'dv'."}
	},
	Output :> {
		{"Null",Null, "Returns nothing."}
	},
	SeeAlso -> {
		"PreviewValue",
		"SetupPreviewSymbol",
		"LogPreviewChanges",
		"PreviewSymbol"
	},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*InvertData*)


DefineUsage[InvertData,
{
	BasicDefinitions -> {
		{"InvertData[xy]", "out", "invert the given data 'xy' such that the range of 'xy' and 'out' are the same, but the peaks and troughs are switched."}
	},
	MoreInformation -> {
		"Used in peak picking when you want to find troughs instead of peaks"
	},
	Input :> {
		{"xy", {{_?NumericQ, _?NumericQ}..}, "Data to be inverted."}
	},
	Output :> {
		{"out", {{_?NumericQ, _?NumericQ}..}, "Inverted version of 'xy'."}
	},
	SeeAlso -> {
		"MinMax",
		"Transpose"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*LinearFunctionQ*)


DefineUsage[LinearFunctionQ,
{
	BasicDefinitions -> {
		{"LinearFunctionQ[func]", "out", "determines if the provided 'func' is a linear function in the form of (a#+b)&, where a is the non-zero slope of the line, b is the y-intercept, and the # is the independent variable."}
	},
	MoreInformation -> {
		"This function does not always evaluate.  It must be given a Function as input in order to evaluate.",
		"When provided with a 'func' that has more than one variable, the function will only check linearity with respect to the first variable."
	},
	Input :> {
		{"func", _Function, "A function to be tested for linearity."}
	},
	Output :> {
		{"out", BooleanP, "Returns True if the provided 'func' is linear, and False if the 'func' is not linear."}
	},
	SeeAlso -> {
		"RSquared",
		"AnalyzeFit"
	},
	Author -> {"melanie.reschke", "alice", "catherine", "brad"}
}];