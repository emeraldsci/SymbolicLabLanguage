(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Help Files*)


(* ::Subsection:: *)
(*Defining Options*)


(* ::Subsubsection::Closed:: *)
(*DefineOptionSet*)


DefineUsage[DefineOptionSet,
	{
		BasicDefinitions->{
			{
				"DefineOptionSet[symbol,ops]",
				"Null",
				"sets the Options for 'symbol' and saves metadata about the options for later usage."
			}
		},
		Input:>{
			{"symbol",_Symbol,"Name of the symbol whose options are being defined."},
			{"ops",{(_Rule)..},"List of options to add to Options defined for this function."}
		},
		MoreInformation->{
			"Option sets should be defined to describe a collection of common options used by many different functions which cannot inherited from a parent function.",
			"When calling DefineOptions, option set symbols are meant to be used in-line, instead of directly defining every option they describe."
		},
		SeeAlso->{"DefineOptions","DefineUsage"},
		Author->{"robert", "alou", "hayley"}
	}
];


(* ::Subsubsection:: *)
(*DefineOptions*)


DefineUsage[DefineOptions,
	{
		BasicDefinitions->{
			{
				"DefineOptions[function,Options:>ops,SharedOptions:>sharedOps]",
				"Null",
				"sets the Options for 'function' and saves metadata about the options for later usage."
			}
		},
		MoreInformation->{
			"The order of input rules does not matter.",
			"Only one of Options/SharedOptions is required."
		},
		Input:>{
			{"function",_Symbol,"Name of the symbol whose options are being defined."},
			{"ops",{{(Rule|RuleDelayed)[_Symbol,_],_,_String}...},"List of options to add to Options defined for this function."},
			{"sharedOps",{(_Symbol|{_Symbol,{(_Symbol|_String)...}})...},"List of options defined for another function to be shared by this function."}
		},
		SeeAlso->{"OptionDefault","DefineUsage"},
		Author->{"taylor.hochuli", "harrison.gronlund", "thomas"},
		Tutorials->{}
	}
];



(* ::Subsubsection:: *)
(*OptionDefinition*)


DefineUsage[OptionDefinition,
	{
		BasicDefinitions->{
			{"OptionDefinition[function]", "definition", "returns the options 'definition' for the 'function'."}
		},
		MoreInformation->{
			"Each option Association has the following keys:",
			"\"OptionName\" (_String): the name of the option.",
			"\"Default\" (_Hold): the default value of the option wrapped in Hold.",
			"\"Head\" (Rule|RuleDelayed): describes if the option was defined as Rule or RuleDelayed.",
			"\"Pattern\" (_Hold): the pattern the option must match wrapped in Hold (defaults to Hold[_]).",
			"\"Description\" (_String): the description for the option (defaults to \"\").",
			"\"Category\" (_String): the category the option should be grouped under (defaults to \"General\").",
			"\"Symbol\" (_Symbol): the symbol the option is defined for.",
			"\"MapThread\" (True|False): whether or not this is a MapThreaded option (defaults to False)."
		},
		Input:>{
			{"function",_Symbol,"Name of the symbol to query options for."}
		},
		Output:>{
			{"definition",{___Association},"A list of Associations (one per-option)."}
		},
		SeeAlso->{"DefineOptions","Options","OptionDefault","DefineUsage"},
		Author->{"platform"},
		Tutorials->{}
	}
];


(* ::Subsection::Closed:: *)
(*Option Parsing*)


(* ::Subsubsection:: *)
(*OptionDefaults*)


DefineUsage[OptionDefaults,
	{
		BasicDefinitions->{
			{"OptionDefaults[function]","defaultRules","returns the default values for the Options of 'function'."},
			{"OptionDefaults[function,options]","defaultRules","returns the default values for the Options of 'function', where the values in 'options' take precedence over defaults."}
		},
		MoreInformation->{
			"Options which are explicitly specified that do not match the expected patterns will be defaulted.",
			"Option names are always strings."
		},
		Input:>{
			{"function",_Symbol,"Symbol to lookup default options for."},
			{"options",{(_Rule|_RuleDelayed)...},"List of rules containing default overrides."}
		},
		Output:>{
			{"defaultRules",{(_Rule|_RuleDelayed)...},"List of rules containg option defaults."}
		},
		SeeAlso->{"OptionDefault","DefineOptions","OptionDefinition","ValidOptions"},
		Author->{"platform"},
		Tutorials->{}
	}
];



(* ::Subsubsection::Closed:: *)
(*OptionDefault*)


DefineUsage[OptionDefault,
	{
		BasicDefinitions->{
			{"OptionDefault[OptionValue[functionName,ops,optionName]]","out","pulls the value of 'optionName' for function 'functionName' given options 'ops'.  If the value in 'ops' does not match the pattern defined in the Usage rules, it returns the default value defined in the Usage rules."},
			{"OptionDefault[OptionValue[functionName,optionName]]","out","pulls the value of 'optionName' for function 'functionName'."},
			{"OptionDefault[OptionValue[optionName]]","out","is equivalent to OptionValue[functionName,ops,optionName] when called inside of a function 'functionName' with options 'ops'."}
		},
		Input:>{
			{"functionName",_Symbol,"A function with options."},
			{"ops",_List,"A list of user-specified options for 'functionName'."},
			{"optionName",_Symbol,"The option whose value you want."}
		},
		Output:>{
			{"out",_,"The value of 'optionName'."}
		},
		Author->{"platform"},
		Tutorials->{},
		SeeAlso->{"DefineOptions","OptionDefinition","OptionDefaults","PassOptions"}
	}
];


(* ::Subsection::Closed:: *)
(*Option Passing*)


(* ::Subsubsection::Closed:: *)
(*PassOptions*)


DefineUsage[PassOptions,
	{
		BasicDefinitions->{
			{"PassOptions[function,ops]","out","returns a sequence of all the options for 'function'.  Values specified in 'ops' take precedence over default values, illegal values are defaulted, and duplicate options are deleted from the end."},
			{"PassOptions[function,receivingFunction,ops]","out","returns a sequence of all the options for 'receivingFunction'.  Values specified in 'ops' take precedence over default values, defaults for 'function' take precendence over defaults for 'receivingFunction', illegal values are defaulted with respect to 'receivingFunction', and duplicate options are deleted from the end."}
		},
		Input:>{
			{"function",_Symbol,"A function whose options and defaults will be taken."},
			{"receivingFunction",_Symbol,"A function who will be receiving a set of options from 'function'."},
			{"ops",((_Rule|_RuleDelayed)...)|{(_Rule|_RuleDelayed)...},"A set of options (as a sequence or in a list) that will take precedence over default options for a function, and will be defaulted if their values are illegal."}
		},
		Output:>{
			{"out",((_Rule|_RuleDelayed)...),"Sequence of Options."}
		},
		SeeAlso->{"OptionDefault","DefineOptions"},
		Author->{"scicomp", "brad"},
		Tutorials->{}
	}
];




DefineUsage[LazyLoading,
	{
		BasicDefinitions->{
			{"LazyLoading[flag,function]","out","If 'flag' is true, adds lazy loading to 'function'."}
		},
		Input:>{
			{"flag",True|False,"Controls whether or not lazy loading will happen for this function."},
			{"function",_Symbol,"The function getting lazy loading added."}
		},
		Output:>{
			{"out",Null,"Returns nothing."}
		},
		SeeAlso->{"OptionDefault","DefineOptions"},
		Author->{"scicomp", "brad"}
	}
];