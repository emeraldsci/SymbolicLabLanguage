(*
	This adds a definition at the top of a symbol's downvalue list that
	wraps TraceExpression around the outside of the call.
	Also adds some TagTrace calls to functions once it makes it	inside the definition.
*)



(* Authors definition for Core`Private`AddTracingDefinition *)
Authors[Core`Private`AddTracingDefinition]:={"xu.yi"};

AddTracingDefinition[f_String, rest___] := AddTracingDefinition[Symbol[f],rest];
AddTracingDefinition[f_Symbol, tagRules_Association] := AddTracingDefinition[f,tagRules,Null];
AddTracingDefinition[f_Symbol, tagRules_Association, optionsPosition:(_Integer|Null)] := With[
	{
        fstring = ToString[f], 
		(* predictably-named symbol, one for each function *)
		blocker = Symbol["$tracelog"<>SymbolName[f]]
	},

        (*
            If no definitions for the function, do nothing.
            Note: this is happening here instead of elsewhere because this function is mapped over
            scraped lists of symbols, and easier to do it all here than the check this condition in each of those places.
        *)
        If[
            DownValues[f]==={},
            Return[$Failed]
        ];


		(* set to True to make sure we always make it into this definition *)
		blocker = True;
		(* add to top of DownValues list so it always gets hit first *)
        PrependTo[
            DownValues[f],
			(* block the blocker so we don't get back to this definition *)
			(* 
				also block $ECLTracing to be on, because right now it's disabled by default on Production,
				but we are specifically trying to track real calls made by users
			*)
		    HoldPattern[f[args___] /; TrueQ[blocker]] :> Block[{blocker=False , ECL`Web`$ECLTracing:=!MatchQ[ECL`$UnitTestObject, _ECL`Object]},
				(* logging wrapped around main definition*)
            	With[{out=TraceExpression[
  					fstring,
					(
						(* 
							generic tags for all function calls
						*)
                        TagTrace["sll.function.name",fstring];
	                    TagTrace["sll.function.context",Context[f]];
						(* TraceExpression fails if values are too large, so shorten the call if necessary *)
	                    TagTrace["sll.function.call", shrunkenStringExpression[Hold[f[args]]]];
	                    TagTrace["sll.function.user", ToString[$PersonID,InputForm]];
                        TagTrace["sll.function.package",Packager`FunctionPackage[f]];
                        TagTrace["sll.notebook",ToString[$Notebook,InputForm]];
                        TagTrace["sll.page",ToString[$NotebookPage,InputForm]];
					    (* specific tagging for this function *)
                        KeyValueMap[TagTrace, tagRules];
                        If[$VerboseTracing,
                            (
                                Echo[shrunkenStringExpression[Hold[f[args]]],f];
                            )
                        ];
                        (*
                            We want to separate the inputs from the options, but in general this is tricky at best, and impossible at worst (ambiguous cases).
							If an integer corresponding to the index of the options was passed in explicitly, use the argument as the options.
                        *)
                        If[
                            And[
								(* option index was given *)
                                IntegerQ[optionsPosition],
								(* options exist in the call being saved *) 
                                Length[Hold[args]] >= optionsPosition
                            ],
							(*
								If 'n' is options position, drop 1;;n-1 elements from the input call
								this leaves us with just the options
							*)
                            With[{heldOps = Drop[Hold[args], optionsPosition - 1]},
                                TagTrace["sll.function.call.options",shrunkenStringExpression[heldOps]];
                            ]
                        ];

                    	(*
							re-call the exact call that got us here, 
							but now with blocker blocked we'll hit the regular definition 
						*)
						(* 
							if we're in command center, stop subsequent tracing to avoid dynamic things
							repeatedly hitting tracing. not a problem in any other ECLApplication.
						*)
						If[ $ECLApplication === CommandCenter,
							Block[ {ECL`Web`$ECLTracing=False}, f[args] ],
							f[args]
						 ]
					)
				]},
                out
                ]
			]
		]
	];


(* 
	Replace big things with small representations.
    Crude shrinking for now -- will try to improve this later.
    Be VERY careful about how shrinking happens, because some things want to evaluate and cause problems.
*)
shrunkenStringExpression[expression_] := StringTake[ToString[ReplaceAll[
    expression,
    {
        img_Image :> "Image", 
        g_Graphics :> "Graphics",
        a_Association:> "Association"[Keys[a]]
    }
], InputForm], UpTo[100]];


(* ****************************

    ADDING THE LOGGING

************************** *)
addLogging[] := (
	addPlotLogging[];
	addAnalysisLogging[];
	addExperimentLogging[];
	(* Ideally, I would like to use check for Engine here instead of this, but for some reason I could not make it work *)
	If[Length[Names["InternalExperiment`Private`*"]]>100,
		addEngineTracing[]
	];
);

(*
	Add logging to all command builder plot functions
	One reason couldn't put this in Plot` is that some "Plot" command builder functions,
	such as Inspect, live in a different package.
*)
addPlotLogging[] := Module[{plotFuncs},
	plotFuncs = Flatten[ Values[ $CommandBuilderFunctions["Plot"] ] ];
	Map[ 
		AddTracingDefinition[#,<|"sll.function.category" -> "Plot"|>]&, 
		plotFuncs 
	]
];



(*
	Add logging to all command builder Analysis functions.
	Explicitly constructs companion functions in order to get companion-specific tags on them
*)
addAnalysisLogging[] := Module[{parentAnalysisFunctions},
	parentAnalysisFunctions = Flatten[ Values[ $CommandBuilderFunctions["Analysis"] ] ];
	Map[
		(
			(* parent function *)
			AddTracingDefinition[#,<|"sll.function.category"->"Analysis"|>];
			(* options function *)
			AddTracingDefinition[#<>"Options" ,<|"sll.function.category"->"Analysis", "sll.companion.type"->"Options","sll.companion"->"True"|>];
			(* preview function *)
			AddTracingDefinition[#<>"Preview", <|"sll.function.category"->"Analysis", "sll.companion.type"->"Preview","sll.companion"->"True"|>];
			(* validq function *)
			AddTracingDefinition["Valid"<>#<>"Q", <|"sll.function.category"->"Analysis", "sll.companion.type"->"ValidQ","sll.companion"->"True"|>];
		)&,
    	parentAnalysisFunctions
	];

	(* this is not in $CommandBuilderFunctions but is used *)
	AddTracingDefinition[ECL`AnalyzeFractionsApp,<|"sll.function.category"->"Analysis"|>];

];

(*
	Add logging to all command builder Experiment functions.
	Explicitly constructs companion functions in order to get companion-specific tags on them
*)
addExperimentLogging[] := Module[{parentExperimentFunctions},
	parentExperimentFunctions = DeleteDuplicates@Flatten[Values[$CommandBuilderFunctions["Experiment"]]];
	Map[
		(
			(* parent function *)
			AddTracingDefinition[#,<|"sll.function.category"->"Experiment"|>];
			(* options function *)
			AddTracingDefinition[#<>"Options" ,<|"sll.function.category"->"Experiment", "sll.companion.type"->"Options","sll.companion"->"True"|>];
			(* preview function *)
			AddTracingDefinition[#<>"Preview", <|"sll.function.category"->"Experiment", "sll.companion.type"->"Preview","sll.companion"->"True"|>];
			(* validq function *)
			AddTracingDefinition["Valid"<>#<>"Q", <|"sll.function.category"->"Experiment", "sll.companion.type"->"ValidQ","sll.companion"->"True"|>];
		)&,
		parentExperimentFunctions
	];
];


(*
	Add logging of all functions we are calling in Engine. We are currently only auto-include helper functions from the InternalExperiment` package and not force-adding anything else since we expect these to be called more frequently
*)
addEngineTracing[]:=Module[
	{
		executeTasks,executeFunctions,branchTasks,allBranchFunctions,sllBranchFunctions,compileFunctions,parseFunctions,
		exportFunctions,importFunctions,engineFunctions,allIEprivateSymbols,meaningfulIESymbols,engineSymbolsToTrace,
		emptyListMemory,extraFunctions
	},

	(* Pull out  the functions called in Execute and Branch tasks if we have procedures loaded *)
	If[MatchQ[ProcedureFramework`Private`procedures,<||>],
		(
		sllBranchFunctions={};
		executeFunctions={};
		),
		(
			executeTasks=Cases[Flatten[Values[ProcedureFramework`Private`procedures[[All,"Tasks"]]]],KeyValuePattern[{"TaskType"->"Execute"}]];
			executeFunctions=ReleaseHold/@DeleteDuplicates[Lookup[Lookup[executeTasks,"Args"],"Function"]];
			branchTasks=Cases[Flatten[Values[ProcedureFramework`Private`procedures[[All,"Tasks"]]]],KeyValuePattern[{"TaskType"->"Branch"}]];

			(* Get the names of the actual functions (removing input args) *)
			allBranchFunctions=ReleaseHold/@DeleteDuplicates[Cases[branchTasks,(Verbatim[Function][func_[___]]:>func),Infinity]];

			(* Branch functions may point to Mathematica functions, pull out only SLL functions *)
			sllBranchFunctions=Select[allBranchFunctions,MatchQ[FunctionPackage[#],_String]&];
		)
	];

	(* Lookup functions defined by compiler/parser registers and in software exporter/importer look-ups *)
	compileFunctions = Values[ECL`CompilerLookup];
	parseFunctions = Values[ECL`ParserLookup];
	exportFunctions = Values[ECL`$ExporterLookup];
	importFunctions = Values[ECL`$ImporterLookup];
	extraFunctions = {Experiment`Private`ExperimentCover,Experiment`Private`ExperimentUncover};

	engineFunctions = Join[executeFunctions, sllBranchFunctions, compileFunctions, parseFunctions, exportFunctions, importFunctions, extraFunctions];

	(*Determine what functions in the InternalExperiment` package are worth tracing*)
	allIEprivateSymbols = ToString/@Names["InternalExperiment`Private`*"];
	emptyListMemory=ByteCount[{}];
	meaningfulIESymbols = Select[allIEprivateSymbols, Quiet[Check[ByteCount@DownValues[#],0]] > emptyListMemory &];

	(* only pick Private functions since we don't want to accidentally trace something like NullQ *)
	(* we need ToExpression here because Names returns strings but DownValues are totally fine with this and conveniently Hold everything from evaluating for us *)
	engineSymbolsToTrace=Select[
		DeleteDuplicates[ToExpression/@Join[engineFunctions, meaningfulIESymbols]],
		And[
			StringContainsQ[ToString[#], "Private"],
			StringFreeQ[ToString[#], "$"]
		]&
	];

	Map[
		AddTracingDefinition[#,<|"sll.function.category"->StringSplit[ToString[#],"`"][[1]]|>]&,
		engineSymbolsToTrace
	]
];