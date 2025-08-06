(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Help Files*)


(* ::Subsection:: *)
(*Ps & Qs*)


DefineUsage[ValidWidgetQ,
	{
		BasicDefinitions->{
			{
				"ValidWidgetQ[myWidget]",
				"boolean",
				"returns True if 'myWidget' is a valid Widget."
			}
		},
		Input:>{
			{"myWidget",_Widget,"Widget that should be tested for validity."}
		},
		Output:>{
			{"boolean",BooleanP,"A boolean that indicates if 'myWidget' is a valid Widget."}
		},
		SeeAlso->{"DefineOptions","DefineUsage","ValidDocumentationQ"},
		Author->{"yanzhe.zhu", "kelmen.low", "taylor.hochuli", "josh.kenchel", "thomas"}
	}
];


(* ::Subsection:: *)
(*Short Hand Functions*)


DefineUsage[Widget,
	{
		BasicDefinitions->{
			{
				"Widget[mySequence]",
				"myWidget",
				"returns a widget that is consistent with the sequence of inputs given in 'mySequence'."
			}
		},
		Input:>{
			{"mySequence",_Sequence,"A sequence of inputs that is used to construct myWidget."}
		},
		Output:>{
			{"myWidget",WidgetP,"A widget that is consistent with the sequence of inputs given in mySequence."}
		},
		SeeAlso->{"DefineOptions","DefineUsage","ValidDocumentationQ","ValidWidgetQ"},
		Author->{"yanzhe.zhu", "kelmen.low", "harrison.gronlund", "josh.kenchel", "thomas"}
	}
];

DefineUsage[Adder,
	{
		BasicDefinitions->{
			{
				"Adder[myWidget]",
				"adderWidget",
				"returns an 'adderWidget' whose singleton element is 'myWidget'."
			}
		},
		Input:>{
			{"myWidget",_Widget,"The singleton widget of this Adder."}
		},
		Output:>{
			{"adderWidget",AdderWidgetP,"An adder widget that allows the user to input a list of one or more singleton widgets."}
		},
		SeeAlso->{"Widget","ValidWidgetQ","GenerateInputPattern"},
		Author->{"yanzhe.zhu", "kelmen.low", "harrison.gronlund", "josh.kenchel", "thomas"}
	}
];


DefineUsage[WidgetTypeQ,
	{
		BasicDefinitions->{
			{
				"WidgetTypeQ[widgetType]",
				"isWidgetType",
				"returns a boolean 'isWidgetType' that indicates if the given symbol 'widgetType' is a known widget type."
			}
		},
		Input:>{
			{"widgetType",_,"The symbol that we want to test."}
		},
		Output:>{
			{"isWidgetType",BooleanP,"A boolean that indicates if the given symbol 'widgetType' is a known widget type."}
		},
		SeeAlso->{"Widget","ValidWidgetQ","GenerateInputPattern"},
		Author->{"yanzhe.zhu", "kelmen.low", "harrison.gronlund", "josh.kenchel", "thomas"}
	}
];


(* ::Subsection::Closed:: *)
(*Pattern Builder*)


DefineUsage[GenerateInputPattern,
	{
		BasicDefinitions->{
			{
				"GenerateInputPattern[myWidget]",
				"pattern",
				"returns a 'pattern' that is consistent with 'myWidget'."
			},
			{
				"GenerateInputPattern[myOptionsList]",
				"pattern",
				"returns a 'pattern' for an option that is consistent with 'myOptionsList'."
			},
			{
				"GenerateInputPattern[myInputsList]",
				"pattern",
				"returns a 'pattern' for an input that is consistent with 'myInputsList'."
			}
		},
		Input:>{
			{"myWidget",WidgetP,"A widget that is used to construct the pattern."},
			{"myOptionsList",{Default->_,AllowNull->_,IndexMatching->_,Widget->_,__},"A list of rules that specifies how to construct the pattern for an option."},
			{"myInputsList",{Widget->_,IndexMatching->_,__},"A list of rules that specifies how to construct the pattern for an input."}
		},
		Output:>{
			{"pattern",_,"A pattern that is consistent with the information provided in the input."}
		},
		SeeAlso->{"DefineOptions","DefineUsage","ValidDocumentationQ","ValidWidgetQ"},
		Author->{"yanzhe.zhu", "kelmen.low", "harrison.gronlund", "josh.kenchel", "thomas"}
	}
];


DefineUsage[
	OverallPatternTooltip,
	{
		BasicDefinitions->{
			{"OverallPatternTooltip[Widget]","PatternDescription","Provides a string describing the widget pattern, combining the patterns of any sub-widgets as needed."}
		},
		MoreInformation->{
		},
		Input:>{
			{"Widget",WidgetP,"The single or compound widget whose pattern needs to be described."}
		},
		Output:>{
			{"PatternDescription",_String,"A human readable description of the widget pattern."}
		},
		SeeAlso->{
		},
		Author->{"scicomp", "hayley"}
	}
];