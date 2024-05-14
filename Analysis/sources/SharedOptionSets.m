(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Option Sets *)


(* ::Subsection:: *)
(*AnalysisTemplateOption*)


DefineOptionSet[AnalysisTemplateOption:>{
	{
		OptionName -> Template,
		Default -> Null,
		Description -> "A template analysis object whose methodology should be reproduced in running this analysis. Option values will be inherited from the template analysis object, but can be individually overridden by directly specifying values for those options to this Analysis function.",
		AllowNull -> True,
		Category -> "Method",
		Widget -> Widget[Type->Object,Pattern:>ObjectP[Types[Object[Analysis]]],ObjectTypes->{Object[Analysis]}]
	}
}];


(* ::Subsection:: *)
(*AnalysisPreviewSymbolOption*)


DefineOptionSet[AnalysisPreviewSymbolOption:>{
	{
		OptionName->PreviewSymbol,
		Default->Null,
		Description->"A specific symbol to use as the preview symbol for this function when the preview app is generated.",
		ResolutionDescription->"This should only be used to generate embedded preview graphics for documentations and other stand-alone notebooks.",
		AllowNull->True,
		Widget->Widget[Type->Expression, Pattern:>_Symbol, Size->Word],
		Category->"Hidden"
	}
}];
