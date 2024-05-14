(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*Options: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Option Setting*)


(* ::Subsubsection::Closed:: *)
(*DefineOptionSet*)


DefineTests[
	DefineOptionSet,
	{
		Example[{Basic,"Set Options:"},
			Module[{func},DefineOptionSet[func:>{{A->2,_Integer,"An integer."},{B:>{"a","b","c"},{_String..},"A list of strings."}}];
				Lookup[OptionDefinition[func],"OptionName"]
			],
			{"A","B"}
		],

		Example[{Basic,"Set all types of options:"},
			Module[{func},
				DefineOptionSet[func:>{{A->2,_Integer,"An integer."},{B:>{"a","b","c"},{_String..},"A list of strings."}}];
				Lookup[OptionDefinition[func],{"OptionName","Pattern"}]
			],
			Verbatim[{{"A",Hold[_Integer]},{"B",Hold[{_String..}]}}]
		],
		Example[{Basic,"Option set can be overwritten by explicity listed options:"},
			Module[{f1,f2},
				DefineOptionSet[f2:>{{B->3,_Integer,"An integer."},{C->4,_Integer,"An integer."}}];
				DefineOptions[f1,
					Options:>{
						f2,
						{A->2,_Integer,"An integer."},
						{C->2,_Integer,"My local 'C' integer."}
					}
				];
				Options[f1]
			],
			{
				"B"->3,
				"A"->2,
				"C"->2
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*DefineOptions*)


DefineTests[
	DefineOptions,
	{
		Example[{Basic,"Set Options (using the legacy syntax):"},
			Module[{func},DefineOptions[func,Options:>{{A->2,_Integer,"An integer."},{B:>{"a","b","c"},{_String..},"A list of strings."}}];
				Options[func]
			],
			{"A"->2,"B":>{"a","b","c"}}
		],
		Example[{Basic,"Set Options (using the new syntax):"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						},
					{
							OptionName->Heuristic,
							Default->Energy,
							AllowNull->False,
							Description->"Whether to optimize for maximum number of bonds or minimal energy.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>HybridizationMethodP
							]
						},
					{
							OptionName->Polymer,
							Default->Automatic,
							AllowNull->True,
							Description->"The polymer type that defines the potnetial alphabaet a valid sequence should be composed of when the input sequence is ambiguous.",
							ResolutionDescription->"Resolves based on the type of nucleic acid that is given as input.",
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>DNA | RNA 
							]
						},
						{
							OptionName->Temperature,
							Default->37*Celsius,
							AllowNull->True,
							Description->"The Gibbs free energies of the folded structures are computed at this temperature.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterEqualP[0 Kelvin],
								Units->Kelvin
							]
						}
					}
				];
				
				Options[testTemperatureFunction]
			],
			{"Method"->Kinetic,"Heuristic"->Energy,"Polymer"->Automatic,"Temperature"->Quantity[37,"DegreesCelsius"]}
		],
		Example[{Basic,"Set SharedOptions, which are copied from other functions:"},
			Module[{func},DefineOptions[func,SharedOptions:>{StringCases,{Plot,{AxesLabel}}}];
				Options[func]
			],
			{"IgnoreCase"->False,"MetaCharacters"->None,"Overlaps"->False,"AxesLabel"->None}
		],

		Example[{Basic,"Set all types of options:"},
			Module[{func},
				DefineOptions[func,
					Options:>{{A->2,_Integer,"An integer."},{B:>{"a","b","c"},{_String..},"A list of strings."}},
					SharedOptions:>{StringCases,{Plot,{AxesLabel}}}
				];
				Options[func]
			],
			{"A"->2,"B":>{"a","b","c"},"IgnoreCase"->False,"MetaCharacters"->None,"Overlaps"->False,"AxesLabel"->None}
		],
		Example[{Additional,"Use two separate IndexMatching[...] blocks:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					IndexMatching[
						IndexMatchingParent->Method,
						{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						},
						{
							OptionName->Heuristic,
							Default->Energy,
							AllowNull->False,
							Description->"Whether to optimize for maximum number of bonds or minimal energy.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>HybridizationMethodP
							]
						}
					],
						{
							OptionName->Polymer,
							Default->Automatic,
							AllowNull->True,
							Description->"The polymer type that defines the potnetial alphabaet a valid sequence should be composed of when the input sequence is ambiguous.",
							ResolutionDescription->"Resolves based on the type of nucleic acid that is given as input.",
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>DNA | RNA 
							]
						},
					IndexMatching[	
						{
							OptionName->Temperature,
							Default->37*Celsius,
							AllowNull->True,
							Description->"The Gibbs free energies of the folded structures are computed at this temperature.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterEqualP[0 Kelvin],
								Units->Kelvin
							]
						},
						IndexMatchingParent->Method
					]
					}
				];
				
				Lookup[OptionDefinition[testTemperatureFunction],{"OptionName","IndexMatchingParent","IndexMatchingOptions"}]
			],
			OrderlessPatternSequence[{{"Method","Method",{"Method","Heuristic","Temperature"}},{"Heuristic","Method",{"Method","Heuristic","Temperature"}},{"Polymer",Null,{}},{"Temperature","Method",{"Method","Heuristic","Temperature"}}}]
		],
		Example[{Additional,"Options override SharedOptions:"},
			Module[{f1,f2},
				DefineOptions[f1,
					Options:>{{A->2,_Integer,"An integer."}}
				];
				DefineOptions[f2,
					Options:>{{A->4,_Integer,"An even better integer."}},
					SharedOptions:>{f1}
				];
				Options[f1]
			],
			{"A"->2}
		],

		Example[{Additional,"Set all types of options:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{A->2,_Integer,"An integer.",Category->General},
						{B:>{"a","b","c",Method},{_String..},"A list of strings.",Category->General},
						{F->7,_Integer,"Another integer.", Category->General}
					},
					SharedOptions:>{StringCases,{Plot,{Axes,AxesLabel}}}
				];
				OptionDefinition[func][[All,"OptionName"]]
			],
			{"A","B","F","IgnoreCase","MetaCharacters","Overlaps","Axes","AxesLabel"}
		],

		Example[{Additional,"Use option set in line with other options:"},
			Module[{f1,f2},
				DefineOptions[f1,
					Options:>{
						MySet,
						{A->2,_Integer,"An integer."}
					}
				];
				Options[f1]
			],
			{
				"B"->3,
				"A"->2
			},
			Stubs:>{
				OptionDefinition[MySet]={
					Association[
						"OptionName" -> "B",
						"Default" -> Hold[3],
						"Head" -> Rule,
						"Pattern" -> Hold[_Integer],
						"Description" -> "Description.",
						"Category" -> "General",
						"Symbol" -> MySet,
						"IndexMatching" -> "None"
					]
				}
			}
		],

		Example[{Additional,"Use multiple option sets:"},
			Module[{f1,f2},
				DefineOptions[f1,
					Options:>{
						MySet,
						{A->2,_Integer,"An integer."},
						MyOtherSet
					}
				];
				Options[f1]
			],
			{
				"B"->3,
				"A"->2,
				"C"->4
			},
			Stubs:>{
				OptionDefinition[MySet]={
					Association[
						"OptionName" -> "B",
						"Default" -> Hold[3],
						"Head" -> Rule,
						"Pattern" -> Hold[_Integer],
						"Description" -> "Description.",
						"Category" -> "General",
						"Symbol" -> MySet,
						"IndexMatching" -> "None"
					]
				},
				OptionDefinition[MyOtherSet]={
					Association[
						"OptionName" -> "C",
						"Default" -> Hold[4],
						"Head" -> Rule,
						"Pattern" -> Hold[_Integer],
						"Description" -> "Another another integer.",
						"Category" -> "General",
						"Symbol" -> MySet,
						"IndexMatching" -> "None"
					]
				}
			}
		],

		Example[{Additional,"Option set can be overwritten by explicity listed options:"},
			Module[{f1,f2},
				DefineOptions[f1,
					Options:>{
						MySet,
						{A->2,_Integer,"An integer."},
						{C->2,_Integer,"My local 'C' integer."}
					}
				];
				Options[f1]
			],
			{
				"B"->3,
				"A"->2,
				"C"->2
			},
			Stubs:>{
				OptionDefinition[MySet]={
					Association[
						"OptionName" -> "B",
						"Default" -> Hold[3],
						"Head" -> Rule,
						"Pattern" -> Hold[_Integer],
						"Description" -> "Another integer.",
						"Category" -> "General",
						"Symbol" -> MySet,
						"IndexMatching" -> "None"
					],
					Association[
						"OptionName" -> "C",
						"Default" -> Hold[4],
						"Head" -> Rule,
						"Pattern" -> Hold[_Integer],
						"Description" -> "Another another integer.",
						"Category" -> "General",
						"Symbol" -> MySet,
						"IndexMatching" -> "None"
					]
				}
			}
		],
		Example[{Additional,"Explicitly defined options always take precedence over option sets. Option sets take precedence over shared options. After than any duplicated options from option sets or shared options are deleted (no duplicates are allowed in explictly defined options):"},
			Module[{f1,f2,setName,f3},
				DefineOptions[f1,
					Options:>{{A->1,_Integer,"An integer."},{B->1,_Integer,"Another integer."},{C->1,_Integer,"Another integer."}}
				];
				DefineOptions[f2,
					Options:>{{B->2,_Integer,"Another integer."},{C->2,_Integer,"Another integer."}}
				];
				DefineOptionSet[setName:>{{A->3,_Integer,"An integer."},{B->3,_Integer,"An integer."}}];
				DefineOptions[f3,
					Options:>{
						{A->4,_Integer,"An even better integer."},
						setName
					},
					SharedOptions:>{f1,f2}
				];
				Options[f3]
			],
			{"A"->4,"B"->3,"C"->1}
		],
		Example[{Messages,"XorIndexMatchingInputAndParent", "Exactly one of IndexMatchingInput and IndexMatchingParent must be set for each IndexMatching block in the options:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					IndexMatching[
					{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
					},
					{
							OptionName->Heuristic,
							Default->Energy,
							AllowNull->False,
							Description->"Whether to optimize for maximum number of bonds or minimal energy.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>HybridizationMethodP
							]
					},
					{
							OptionName->Polymer,
							Default->Automatic,
							AllowNull->True,
							Description->"The polymer type that defines the potnetial alphabaet a valid sequence should be composed of when the input sequence is ambiguous.",
							ResolutionDescription->"Resolves based on the type of nucleic acid that is given as input.",
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>DNA | RNA 
							]
					},
					{
							OptionName->Temperature,
							Default->37*Celsius,
							AllowNull->True,
							Description->"The Gibbs free energies of the folded structures are computed at this temperature.",
							ResolutionDescription->Null,
							Category->"Folding Method",
							IndexMatching->Null,
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterEqualP[0 Kelvin],
								Units->Kelvin
							]
					}
					]
					}
				];
				
				Options[testTemperatureFunction]
			],
			{},
			Messages:>{DefineOptions::XorIndexMatchingInputAndParent, DefineOptions::Format}
		],
		Example[{Messages,"InvalidKeys","If an illegal key is specified, returns $Failed:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->Null,
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							],
							FavoriteFood->Taco
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::InvalidKeys,DefineOptions::Format}
		],
		Example[{Messages,"MissingRequiredKeys","If a required key is missing, returns $Failed. In this test, we are missing the OptionName key:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->Null,
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::MissingRequiredKeys,DefineOptions::Format}
		],
		Example[{Messages,"OptionNamePattern","The OptionName must be provided as a _Symbol:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->"Tacos!",
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->Null,
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::OptionNamePattern,DefineOptions::Format}
		],
		Example[{Messages,"AllowNullPattern","AllowNull must match BooleanP:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->"Tacos!",
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->Null,
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::AllowNullPattern,DefineOptions::Format}
		],
		Example[{Messages,"DescriptionPattern","Description must match _String:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->False,
							Description->Taco,
							ResolutionDescription->Null,
							Category->Null,
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::DescriptionPattern,DefineOptions::Format}
		],
		Example[{Messages,"CategoryPattern","Category must match _String:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->TACOS,
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::CategoryPattern,DefineOptions::Format}
		],
		Example[{Messages,"PatternXorWidget","Only the Pattern or the Widget key can be provided:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->Method,
							Default->Kinetic,
							Pattern:>MyAwesomePatternP,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->"Taco Category",
							IndexMatching->Null,
							Widget->Widget[
								Type->Enumeration,
								Pattern:>Kinetic|Thermodynamic
							]
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::PatternXorWidget,DefineOptions::Format}
		],
		Example[{Messages,"InvalidWidget","The provided widgets must be valid:"},
			Module[{testTemperatureFunction},
				DefineOptions[testTemperatureFunction,
					Options :> {
					{
							OptionName->Method,
							Default->Kinetic,
							AllowNull->False,
							Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes.",
							ResolutionDescription->Null,
							Category->"Taco Category",
							IndexMatching->Null,
							Widget->TacoWidget
						}
					}
				]
			],
			$Failed,
			Messages:>{DefineOptions::InvalidWidget,DefineOptions::Format}
		],
		Test["Options with lists for descriptions are joined to a single description:",
			With[{},
				ClearAll[myPrivateFunction];
				DefineOptions[myPrivateFunction,
					Options:>{
						{B:>{"a","b","c",Method},{_String..},{"Two descriptions.","Joined."},Category->General}
					}
				];
				OptionDefinition[myPrivateFunction][[1,"Description"]]
			],
			"Two descriptions. Joined."
		],

		Test["Allows empty lists for any top-level rule:",
			With[{},
				ClearAll[myPrivateFunction];
				DefineOptions[myPrivateFunction,
					Options:>{
						{A->2,_,""}
					},
					SharedOptions:>{}
				];
				OptionDefinition[myPrivateFunction]
			],
			{KeyValuePattern[{
				"OptionName" -> "A",
				"OptionSymbol" -> A,
				"Default" -> Hold[2],
				"Head" -> Rule,
				"Pattern" -> Hold[_],
				"Description" -> "",
				"Symbol" -> myPrivateFunction,
				"Category" -> "General",
				"IndexMatching" -> "None"
			}]}
		],

		Example[{Additional,"Define options as index-matching to inputs:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{A->2,ListableP[_Integer],"An integer.",IndexMatching->Input},
						{F->7,ListableP[_Integer],"Another integer.", Category->General, IndexMatching->Input},
						{G->7,_Integer,"Another integer.", Category->General}
					}
				];
				OptionDefinition[func][[All,{"OptionName","IndexMatching"}]]
			],
			{
				Association[
					"OptionName"->"A",
					"IndexMatching"->"Input"
				],
				Association[
					"OptionName"->"F",
					"IndexMatching"->"Input"
				],
				Association[
					"OptionName"->"G",
					"IndexMatching"->"None"
				]
			}
		],
		Example[{Messages,"BadPattern","Print a message and returns $Failed if an IndexMatching option does not use ListableP to define its pattern:"},
			DefineOptions[func,
				Options:>{
					{A->2,ListableP[_Integer],"An integer.",IndexMatching->Input},
					{F->7,_Integer,"Another integer.", Category->General, IndexMatching->Input},
					{G->7,_Integer,"Another integer.", Category->General}
				}
			],
			$Failed,
			Messages:>{Message[DefineOptions::BadPattern,func,{"F"}]}
		],

		Example[{Messages,"BadPattern","Print a message and returns $Failed if the option to which an option is Index-Matched does not use ListableP to define its pattern:"},
			DefineOptions[func,
				Options:>{
					{A->2,ListableP[_Integer],"An integer.",IndexMatching->F},
					{F->7,Integer|{_Integer..},"Another integer.", Category->General},
					{G->7,_Integer,"Another integer.", Category->General}
				}
			],
			$Failed,
			Messages:>{Message[DefineOptions::BadPattern,func,{"F"}]}
		],

		Example[{Additional,"Protected symbols are unprotected and re-protected:"},
			Module[{func},
				Protect[func];
				DefineOptions[func,Options:>{{A->2,_Integer,"An integer.",Category->General},{B:>{"a","b","c",Method},{_String..},"A list of strings.",Category->General}}];
				MemberQ[Attributes[func],Protected]
			],
			True
		],
		Example[{Additional,"Unprotected symbols stay unprotected:"},
			Module[{func},
				DefineOptions[func,Options:>{{A->2,_Integer,"An integer.",Category->General},{B:>{"a","b","c",Method},{_String..},"A list of strings.",Category->General}}];
				MemberQ[Attributes[func],Protected]
			],
			False
		],

		Example[{Messages,"SystemSymbol","Cannot define options for Mathematica symbols:"},
			DefineOptions[First,Options:>{{Map->False,_,"Description"}}],
			$Failed,
			Messages:>{DefineOptions::SystemSymbol}
		],

		Example[{Messages,"Format","Invalid options format:"},
			DefineOptions[MyFunc,Options:>{{Map->False,"Description",12}}],
			$Failed,
			Messages:>{
				Message[DefineOptions::Format,MyFunc],
				DefineOptions::Format
			}
		],
		Example[{Messages,"InvalidKey","Valid Options keys are Options and SharedOptions:"},
			DefineOptions[MyFunc,FakeKey:>{}],
			$Failed,
			Messages:>{
				Message[DefineOptions::InvalidKey,MyFunc,{FakeKey}]
			}
		],
		Example[{Messages,"MissingOptions","Cannot share an option that does not exist for sharing function:"},
			DefineOptions[MyFunc,SharedOptions:>{{MyOtherFunc,{Horse}}}],
			Null,
			Messages:>{
				Message[DefineOptions::MissingOptions,{"Horse"},MyOtherFunc,MyFunc]
			},
			TearDown:>{
				ClearAll[MyFunc,MyOtherFunc];
			}
		],
		Example[{Messages,"NoOptions","Cannot share options if they have not yet been defined for sharing function:"},
			DefineOptions[MyFunc,SharedOptions:>{MyOtherFunc}],
			Null,
			Messages:>{
				Message[DefineOptions::NoOptions,MyOtherFunc,MyFunc]
			},
			TearDown:>{
				ClearAll[MyFunc,MyOtherFunc];
			}
		],

		Test["Shared options preserve rule head:",
			Module[{f1,f2},
				DefineOptions[f1,Options:>{{A:>1,_,"Description"},{B->2,_,"Description"}}];
				DefineOptions[f2,SharedOptions:>{f1}];
				Options[f2]
			],
			{"A":>1,"B"->2}
		],

		Example[{Messages,"Duplicate","Throws a message and does not define options if the same option name is used twice:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{A->2,_Integer,"An integer."},
						{B:>{"a","b","c"},{_String..},"A list of strings."},
						{A->"Hello",_String,"A String."}
					},
					SharedOptions:>{StringCases,{Plot,{Axes,AxesLabel}}}
				];
				Options[func]
			],
			{},
			Messages:>{
				DefineOptions::Duplicate
			}
		],

		Example[{Additional,"Options defined for the symbol take precedence over shared options:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{A->2,_Integer,"An integer."},
						{B:>{"a","b","c"},{_String..},"A list of strings."},
						{Axes->4,_Integer,"Axes numbers and stuff."}
					},
					SharedOptions:>{StringCases,{Plot,{Axes,AxesLabel}}}
				];
				Select[
					OptionDefinition[func],
					Lookup[#,"OptionName"]==="Axes"&
				]
			],
			{KeyValuePattern[{
				"OptionName" -> "Axes",
				"OptionSymbol" -> Axes,
				"Default" -> Hold[4],
				"Head" -> Rule,
				"Pattern" -> Verbatim[Hold[_Integer]],
				"Description" -> "Axes numbers and stuff.",
				"Symbol" -> _Symbol,
				"Category" -> "General",
				"IndexMatching" -> "None"
			}]}
		],

		Test["Options from option sets are associated with the function for which they are defined:",
			Module[{f1,f2},
				DefineOptions[f1,
					Options:>{
						MySet,
						{A->2,_Integer,"An integer."}
					}
				];
				OptionDefinition[f1][[All,"Symbol"]]
			],
			_?(Apply[SameQ, #] &),
			Stubs:>{
				OptionDefinition[MySet]={
					Association[
						"OptionName" -> "B",
						"Default" -> Hold[3],
						"Head" -> Rule,
						"Pattern" -> Hold[_Integer],
						"Description" -> "Description.",
						"Category" -> "General",
						"Symbol" -> MySet,
						"IndexMatching" -> "None"
					]
				}
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*CacheOption*)


DefineTests[
	CacheOption,
	{
		Example[{Basic,"Set Options using CacheOption:"},
			Module[{func},
				DefineOptions[func,Options:>{CacheOption}];
			Options[func]
			],
			{"Cache" -> {}}
		],
		Example[{Basic,"Set Options using CacheOption and other options:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{Number->2,_Integer,"An integer."},
						CacheOption
					}
				];
				Options[func]
			],
			{"Number"->2,"Cache"->{}}
		],
		Example[{Basic,"Redefining Cache will override it:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{Cache->2,_Integer,"An integer."},
						CacheOption
					}
				];
				Options[func]
			],
			{"Cache"->2}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*CacheOption*)


DefineTests[
	UploadOption,
	{
		Example[{Basic,"Set Options using UploadOption:"},
			Module[{func},
				DefineOptions[func,Options:>{UploadOption}];
				Options[func]
			],
			{"Upload" -> True}
		],
		Example[{Basic,"Set Options using UploadOption and other options:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{Number->2,_Integer,"An integer."},
						UploadOption
					}
				];
				Options[func]
			],
			{"Number"->2,"Upload" -> True}
		],
		Example[{Basic,"Redefining Cache will override it:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{Upload->2,_Integer,"An integer."},
						UploadOption
					}
				];
				Options[func]
			],
			{"Upload" -> 2}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExportOption*)

DefineTests[
	ExportOption,
	{
		Example[{Basic,"Set Options using ExportOption:"},
			Module[{func},
				DefineOptions[func,Options:>{ExportOption}];
				Options[func]
			],
			{"Export" -> True}
		],
		Example[{Basic,"Set Options using ExportOption and other options:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{Number->2,_Integer,"An integer."},
						ExportOption
					}
				];
				Options[func]
			],
			{"Number"->2,"Export"->True}
		],
		Example[{Basic,"Redefining Export will override it:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{Export->2,_Integer,"An integer."},
						ExportOption
					}
				];
				Options[func]
			],
			{"Export"->2}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*FastTrackOption*)

DefineTests[
	FastTrackOption,
	{
		Example[{Basic,"Set Options using FastTrackOption:"},
			Module[{func},
				DefineOptions[func,Options:>{FastTrackOption}];
				Options[func]
			],
			{"FastTrack" -> False}
		],
		Example[{Basic,"Set Options using FastTrack and other options:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{Number->2,_Integer,"An integer."},
						FastTrackOption
					}
				];
				Options[func]
			],
			{"Number"->2,"FastTrack"->False}
		],
		Example[{Basic,"Redefining FastTrack will override it:"},
			Module[{func},
				DefineOptions[func,
					Options:>{
						{FastTrack->2,_Integer,"An integer."},
						FastTrackOption
					}
				];
				Options[func]
			],
			{"FastTrack"->2}
		]
	}
];
(* ::Subsubsection::Closed:: *)
(*OptionDefinition*)


DefineTests[
	OptionDefinition,
	{
		Example[{Basic,"For System` symbols returns association parsed from Options[symbol]:"},
			OptionDefinition[Replace],
			{
				KeyValuePattern[{
					"OptionName"->"Heads",
					"OptionSymbol"->Heads,
					"Default"->Hold[False],
					"Head"->Rule,
					"Pattern"->Verbatim[_],
					"Description"->"",
					"Symbol"->Replace,
					"Category"->"System"
				}]
			}
		],

		Example[{Basic,"Query the Options definition for Download:"},
			OptionDefinition[Download],
			{__Association}
		],

		Example[{Basic,"For a symbol with no options defined, returns an empty list:"},
			OptionDefinition[Part],
			{}
		]
	}
];



(* ::Subsection:: *)
(*Option Parsing*)


(* ::Subsubsection::Closed:: *)
(*OptionDefaults*)


DefineTests[
	OptionDefaults,
	{
		Example[{Basic,"Default Options are pulled from OptionDefinition[symbol]:"},
			OptionDefaults[fABC],
			{"A"->"Hi","B"->6,"C"->x}
		],

		Example[{Basic,"Options specified in input take precedence over defaults:"},
			OptionDefaults[fABC,{"B"->12,C->Y}],
			{"A"->"Hi","B"->12,"C"->Y}
		],

		Example[{Additional,"Retrieve default options for built in function as string keys:"},
			OptionDefaults[StringCases],
			MapAt[
				SymbolName,
				Options[StringCases],
				{All,1}
			]
		],

		Example[{Messages,"Pattern","Throws a message for options which are specified and don't match their patterns, returns their default values:"},
			OptionDefaults[fABC,{"B"->12.0,C->Verbose}],
			{"A"->"Hi","B"->6,"C"->Verbose},
			Messages:>{
				Message[Warning::OptionPattern,12.0,HoldForm[_Integer],"B",fABC,HoldForm[6]]
			}
		],

		Example[{Messages,"UnknownOption","Throws a message and filters out options which are specified and are not defined for the function:"},
			OptionDefaults[fABC,{C->Verbose,NotAndOption->4}],
			{"A"->"Hi","B"->6,"C"->Verbose},
			Messages:>{
				Message[Warning::UnknownOption,{"NotAndOption"},fABC]
			}
		],

		Example[{Basic,"Returns empty list for functions without Usage rules:"},
			OptionDefaults[ThisHasNoUsage],
			{}
		],

		Example[{Basic,"Returns options with string keys for built in functions:"},
			OptionDefaults[Plot],
			{((Rule|RuleDelayed)[_String,_])..}
		],
		Test["If Output -> Tests with no options specified, return an empty list of no tests:",
			OptionDefaults[fABC, Output -> Tests],
			{}
		],
		Test["If Output -> Tests with options specified, return a list of tests:",
			OptionDefaults[fABC, {"B"->12,C->Y}, Output -> Tests],
			{__EmeraldTest}
		],
		Test["If Output -> {Result, Tests} with options specified, return a list of results and tests:",
			OptionDefaults[fABC,{"B"->12,C->Y}, Output -> {Result, Tests}],
			{
				{"A"->"Hi","B"->12,"C"->Y},
				{__EmeraldTest}
			}
		]
	},
	SetUp:>(
		ClearAll[fABC];
		DefineOptions[fABC,Options:>{{A->"Hi",_String,"A string.",Category->General},{B->6,_Integer,"An integer.",Category->Method},{C->x,_Symbol,"A symbol.",Category->General}}];
	)
];



(* ::Subsection:: *)
(*Option Validity*)


(* ::Subsubsection::Closed:: *)
(*OptionDefault*)


DefineTests[
	OptionDefault,
	{
		Example[{Basic,"Returns the default value of A:"},
			OptionDefault[OptionValue[fABC,A]],
			"Hi"
		],

		Example[{Basic,"Returns the default value of A:"},
			OptionDefault[OptionValue[fABC,{},A]],
			"Hi"
		],

		Example[{Basic,"Returns the value of A specified in the input options:"},
			OptionDefault[OptionValue[fABC,{A->"Bye"},A]],
			"Bye"
		],

		Example[{Additional,"Specified options can have extra layers of listing:"},
			OptionDefault[OptionValue[fABC,{{A->"Bye"}},A]],
			"Bye"
		],
		Example[{Additional,"Specified options can be a sequence:"},
			OptionDefault[OptionValue[fABC,{A->"Bye",B->12},A]],
			"Bye"
		],

		Example[{Messages,"Pattern","Given an option value that does not match the Usage rules pattern:"},
			OptionDefault[OptionValue[fABC,{A->3},A]],
			"Hi",
			Messages:>{
				Warning::OptionPattern
			}
		],

		Example[{Messages,"UnknownOption","Throw message and return Missing[\"Option\",optionName] if option is not in Usage rules but is specified in options:"},
			OptionDefault[OptionValue[fABC,{AxesStyle->1},AxesStyle]],
			Missing["Option","AxesStyle"],
			Messages:>{
				Warning::UnknownOption
			}
		],

		Example[{Messages,"UnknownOption","Throw message and return Missing[\"Option\",optionName] if optionName is not an option for function:"},
			OptionDefault[OptionValue[fABC,{},AxesStyle]],
			Missing["Option","AxesStyle"],
			Messages:>{
				Warning::UnknownOption
			}
		],

		Example[{Options,Verbose,"Use Verbose option to quiet the Pattern message:"},
			OptionDefault[OptionValue[fABC,{A->3},A],Verbose->False],
			"Hi"
		],

		Example[{Options,Verbose,"Use Verbose option to quiet the UnknownOption message:"},
			OptionDefault[OptionValue[fABC,{Horse->6},Horse],Verbose->False],
			Missing["Option","Horse"]
		],

		Example[{Options,Hold,"Return the option value unevaluated and held:"},
			OptionDefault[OptionValue[fABC,{},A],Hold->True],
			Hold["Hi"]
		],

		Example[{Attributes,HoldFirst,"Return the option value unevaluated and held:"},
			OptionDefault[Evaluate[OptionValue[fABC,{},{A,B}]]],
			_OptionDefault
		],

		Example[{Additional,"Extract values for multiple option names:"},
			OptionDefault[OptionValue[fABC,{},{A,B}]],
			{"Hi",6}
		]
	},
	Variables->{fABC},
	SetUp:>(
		DefineOptions[fABC,Options:>{{A->"Hi",_String,"A string."},{B->6,_Integer,"An integer."},{C->x,_Symbol,"A symbol."}}];
	)
];


(* ::Subsection:: *)
(*Option Passing*)


(* ::Subsubsection::Closed:: *)
(*PassOptions*)


DefineTests[
	PassOptions,
	{
		Example[{Basic,"Pad given options with unspecified defaults for given function:"},
			{PassOptions[fABC,A->"brad",B->35]},
			{"A"->"brad","B"->35,"C"->x}
		],

		Example[{Basic,"Filter out options that are unknown to receiving function, and pad with unspecified defaults for receiving function:"},
			{PassOptions[fABC,fBCD,A->9999,B->100,C->E,Level->\[Pi]]},
			{"B"->100,"C"->E,"D"->{}}
		],

		Example[{Additional,"Options can also be specified as a list:"},
			{PassOptions[fABC,fBCD,{A->9999,B->100,C->E,D->{1,2,3},Level->Pi}]},
			{"B"->100,"C"->E,"D"->{1,2,3}}
		],

		Example[{Additional,"Specify options as a list for single function case:"},
			{PassOptions[fABC,{A->"brad",B->35}]},
			{"A"->"brad","B"->35,"C"->x}
		],

		Example[{Additional,"A function's default options:"},
			{PassOptions[fABC]},
			{"A"->"Hi","B"->6,"C"->x}
		],

		Example[{Additional,"Filters and pads options if given functions have no Usage rules, but cannot default values:"},
			{PassOptions[TableForm,Map,Heads->12,TableHeadings->17]},
			{Heads->12}
		],

		Example[{Additional,"Converts strings to symbols when the receiving function has Options defined as symbols not strings:"},
			{PassOptions[TableForm,Map,"Heads"->12,TableHeadings->17]},
			{Heads->12}
		],

		Example[{Messages,"Pattern","Illegal values are defaulted with respect to the receiving function:"},
			{PassOptions[fABC,fBCD,C->3]},
			{"B"->6,"C"->y,"D"->{}},
			Messages:>{
				Warning::OptionPattern
			}
		],

		Test["If receiving function has no options, returns empty sequence:",
			{PassOptions[fABC,Show,C->3]},
			{}
		],

		Example[{Messages,"Pattern","Given one function, illegal values default with respect to that:"},
			{PassOptions[fABC,C->3]},
			{"A"->"Hi","B"->6,"C"->x},
			Messages:>{
				Warning::OptionPattern
			}
		]
	},
	Variables->{fABC,fBCD},
	SetUp:>(
		DefineOptions[fABC,Options:>{{A->"Hi",_String,"A string."},{B->6,_Integer,"An integer."},{C->x,_Symbol,"A symbol."}}];
		DefineOptions[fBCD,Options:>{{B->1/2,_?NumericQ,"A numeric quantity."},{C->y,_Symbol,"A symbol."},{D->{},_List,"A list."}}];
	)
];



DefineTests[LazyLoading,{
	Example[{Basic,"Add lazy loading to a function:"},
		Module[{myFunction},
			LazyLoading[True,myFunction];		
			DownValues[myFunction]
		],
		{_RuleDelayed}	
	],
	Example[{Basic,"Don't add lazy loading to a function:"},
		Module[{myFunction},
			LazyLoading[False,myFunction];		
			DownValues[myFunction]
		],
		{}	
	]

}]