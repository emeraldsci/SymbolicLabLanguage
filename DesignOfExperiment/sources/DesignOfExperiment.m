(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Messages*)

DesignOfExperiment::TooManyExperiments="The total number of experiments specified exceeds the limit of `1` set by FinanceTeam policy.";
DesignOfExperiment::NoVariableInput="DesignOfExperiment input needs at least 1 variable parameter to be optimized.";
(*DesignOfExperiment::InvalidOptions="The options you specified are not valid for this experiment";*)
DesignOfExperiment::NoObjectiveFunction="No objective function was specified for this design of experiment";
DesignOfExperiment::UnequalVariableLengths="The variable parameters must be the same length for CustomSearch.";


(*TODO: make this message more verbose once we have the method handling more developed *)
(*DesignOfExperiment::InvalidObjectiveFunction="`1` is not a valid objective function.";
DesignOfExperiment::InvalidMethod="`1` is not a valid method.";
DesignOfExperiment::InvalidOptions="Options for `1` are invalid.";*)

(* ::Subsection:: *)
(*DesignOfExperiment*)


(* ::Subsubsection:: *)
(*DefineOptions*)

DOEMethodP=Alternatives[GridSearch, CustomSearch];

DefineOptions[DesignOfExperiment,
	Options:>{
		{
			OptionName -> Method,
			Default -> GridSearch,
			Description -> "The optimization algorithm which should be used to maximize the provided ObjectiveFunction over the input search space.",
			AllowNull->False,
			Category -> "Method",
			Widget -> Alternatives[
				"Preset"->Widget[Type->Enumeration, Pattern:>DOEMethodP],
				(* TODO: What is the API for a custom optimization method? *)
				"Custom"->Widget[Type->Expression, Pattern:>"Temporary", Size->Word]
			]
		},
		{
			OptionName -> ObjectiveFunction,
			Default -> Automatic,
			Description -> "The objective function, which takes an input a list of Data objects and outputs a number, to optimize in this design of experiment.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Alternatives[
				"Preset"->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[
						AreaOfTallestPeak,
						MeanPeakSeparation,
						MeanPeakHeightWidthRatio,
						ResolutionOfTallestPeak
					]
				],
				(* TODO: What is the API for a custom objective function? *)
				"Custom"->Widget[Type->Expression, Pattern:>"Temporary", Size->Word]
			]
		},
		{
			OptionName -> MaxExperimentThreads,
			Default -> Automatic,
			Description -> "Maximum number of experimental threads that this design of experiment may use concurrently.",
			ResolutionDescription -> "Defaults to the maximum number of experimental threads owned by submitter's financing team.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[Type->Number, Pattern:>GreaterP[0,1]]
		},
		{
			OptionName -> MaxExperimentNumber,
			Default -> 20,
			Description -> "The maximum number of experimental protocols that this DesignOfExperiment may enqueue.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[Type->Number, Pattern:>GreaterP[0,1]]
		},
		OutputOption
	}
];


(* ::Subsubsection:: *)
(*Implementation*)

(* Main function body *)
SetAttributes[DesignOfExperiment, HoldFirst];
DesignOfExperiment[myExperiment_[myExpParameters___],ops:OptionsPattern[]]:=Module[
	{heldCalls,allOps,allVarOps,safeOps,safeExpOps,expFunc,samples,variableOptions,varOpNames,fixedOptions,fixedOpNames,resolvedVarOps,fullyResolvedVarOps,
	objFunc,doeObject,doeScript,optMethod,doeAnalysisObject,scriptExpression},

	(* Get default input options *)
	safeOps=SafeOptions[DesignOfExperiment,ToList[ops]];

	(* Get objective function and method *)
	{objFunc, optMethod}=Lookup[safeOps,{ObjectiveFunction,Method}];

	(* Identify experiment, samples, and parse experimental parameters into variableOptions and fixedOptions *)
	{expFunc, samples, variableOptions, fixedOptions}=resolveDesignOfExperimentInputs[myExperiment[myExpParameters]];

	(* Get parameter names *)
	varOpNames=Keys[variableOptions];
	fixedOpNames=Keys[fixedOptions];

	(* Throw an error message and returned$Failed if there is no variable input parameter *)
	If[MatchQ[varOpNames,{}],
		Message[DesignOfExperiment::NoVariableInput];
		Return[$Failed]
	];

	(* Throw an error message and returned$Failed if there is no objective function *)
	If[MatchQ[objFunc,Automatic],
		Message[DesignOfExperiment::NoObjectiveFunction];
		Return[$Failed]
	];

	(* Generate parameter space, currently only gridSearch is implemented *)
	allOps=Switch[optMethod,

		(* Grid search *)
		GridSearch, gridGeneration[expFunc,variableOptions,fixedOptions,Method->GridSearch],

		(* Enumerated search *)
		CustomSearch, gridGeneration[expFunc,variableOptions,fixedOptions,Method->CustomSearch]

		(* placeholder for non-gridsearch method *)

	];

	(* If all allOps failed, return $Failed*)
	If[MatchQ[allOps, $Failed],

		Return[$Failed]

	];

	(* Pull out range values for DOE script object *)
	ranges = pullVariableOptions/@variableOptions;

	(* Return $Failed if total number of experiments exceeds the limit set by options  *)
	If[Length[allOps]>Lookup[safeOps, MaxExperimentNumber],
		Message[DesignOfExperiment::TooManyExperiments, Lookup[safeOps, MaxExperimentNumber]];
		Return[$Failed]
	];

	(* Rebuild experiment function calls *)
	heldCalls=With[{mySamples=samples},reconstructCall[expFunc,mySamples,#]&/@allOps];

	(* Initialize DOE Analysis Object *)
	doeAnalysisObject = Upload[
		Association[
			Type->Object[Analysis,DesignOfExperiment],
			Method->optMethod,
			ObjectiveFunction->objFunc,
			Replace[ParameterSpace]->varOpNames
		]
	];

	(* Generate scriptExpression *)
	scriptExpression = generateScriptCalls[samples, allOps, expFunc, varOpNames, doeScript, doeAnalysisObject];

	(* Call ExperimentScript on the helod expression to create a new script object *)
	script = ExperimentScript@@scriptExpression;

	(* Initialize doe object *)
	doeObject = Upload[
		Association[
			Type->Object[DesignOfExperiment],
			Method->optMethod,
			ObjectiveFunction->objFunc,
			Replace[Parameters]->varOpNames,
			Replace[Ranges]->ranges,
			Script->Link[script, DesignOfExperiment],
			Replace[DesignOfExperimentAnalyses]->Link[doeAnalysisObject,Reference]
		]
	];

	(* Output doeScript *)
	doeObject
];

(*Helper to strip out value for ranges field in script object*)
pullVariableOptions[Rule[key_, Variable[value_]]] := Module[{},
  value
];

(* ::Subsubsection:: *)
(*Helper Functions*)

(* Function to extract the experiment function, any variable and fixed options from the input experiment function call *)
SetAttributes[resolveDesignOfExperimentInputs, HoldFirst];
resolveDesignOfExperimentInputs[experimentFunction_[args___]]:=Module[
	{heldArgs,samples,fixedOptions,variableOptions},

	heldArgs={args};

	(* Extract the variable options from experiment function arguments *)
	variableOptions=Cases[heldArgs,op:Rule[opName_,_Variable]:>op];

	(* Extract fixed options from experiment function arguments *)
	fixedOptions=Cases[heldArgs,op:Rule[opName_,Except[_Variable]]:>op];

	(* Samples *)
	samples=Flatten[Select[heldArgs,MatchQ[#,ObjectP[Object[Sample]]|{ObjectP[Object[Sample]]..}]&]];

	(* Return the base experiment function, samples, variable and fixed options *)
	{experimentFunction, samples, variableOptions, fixedOptions}
];

(* Function to generate experiment parameters search space *)
DefineOptions[gridGeneration,Options:>{},SharedOptions:>{DesignOfExperiment}];
gridGeneration[expFunction_,variableOptions_,fixedOptions_,ops:OptionsPattern[]]:=Module[
	{method,safeOps,resolvedVarOps,fullyResolvedVarOps,allVarOps,allOps},

	safeOps=SafeOptions[gridGeneration,ToList[ops]];
	method=Lookup[safeOps,Method];

	(* Resolve variable argumnets into enumerated lists *)
	resolvedVarOps=expandVariable[expFunction,#]&/@variableOptions;

	(* Method\[Rule]GridSearch only for v0 *)
	allOps=Which[

		MatchQ[method,GridSearch],

			(* Fully resolved variable arguments *)
			fullyResolvedVarOps=fullExpandVariable[#]&/@resolvedVarOps;

			(* List of all variable options combinations *)
			allVarOps=Tuples[fullyResolvedVarOps];

			(* Put fixed options back into experiment parameters *)
			Join[#, fixedOptions]&/@allVarOps,

		MatchQ[method,CustomSearch],

			(*Pull out lengths of variable options*)
			variableLengths = Length[pullVariableOptions[#]]&/@resolvedVarOps;

			(*Check that all lists are equal length, otherwise error out*)
			If[CountDistinct[variableLengths]>1,

				Message[DesignOfExperiment::UnequalVariableLengths];
				Return[$Failed]

			];

			(* Fully resolved variable arguments *)
			fullyResolvedVarOps=fullExpandVariable[#]&/@resolvedVarOps;

			(* List of all variable options combinations *)
			allVarOps=Thread[fullyResolvedVarOps];

			(* Put fixed options back into experiment parameters *)
			Join[#, fixedOptions]&/@allVarOps
	];

	(* Return all experiment parameter combinations *)
	allOps
];

(* automatic script generation. returns a list of held compound expressions *)
generateScriptCalls[samples_,allOps_,experimentHead_,varOpNames_,doeID_,anaObj_]:=Module[{calls},
	(*Add map indexed*)
	calls = Join@@MapIndexed[
		(* Replace the sequence head *)
		ReplaceAll[
			(* Pair protocols and analysis steps *)
			With[
				{
					(* create a unique protocol name *)
					protocol = Unique["protocol"],

					(* create a new sequence of inputs *)
					opsSeq = Sequence@@#1
				},

				(* use holds to ensure that none of the tasks get executed *)
				Hold[

					(* call the experiment with the samples in opsSeq *)
					protocol=experimentHead[samples,opsSeq],

					(* call analysis after each experiment *)
					AnalyzeDesignOfExperiment[{protocol},UpdateAnalysis->anaObj]
				]
			],
			(*replace the Sequence head *)
			f_[args___, Verbatim[Sequence][stuff___], more___] :> f[args, stuff, more]
		]&,
		(*map over all sets of parameter options *)
		allOps
	];

	(*Append plot call to the end of the script generation *)
	calls = Join[calls, Hold[PlotDesignOfExperiment[anaObj]]];

	(*Turn calls into compound expressions and append upload to be false *)
	calls = With[{calls=calls},
		With[{expr=With[{hcalls=Hold[calls]},CompoundExpression@@@hcalls]},
		Append[expr,Upload->True]
		]
	]

];

(* Function to expand variable arguments into enumerated list of values *)
expandVariable[experimentFunction_,opName_->var:Variable[list_List]]:=opName->var;
expandVariable[experimentFunction_,opName_->Variable[min_,max_,step_]]:=opName->Variable[Range[min,max,step]];

(* Function to complete expansion of all varialbe options *)
fullExpandVariable[opName_Symbol->Variable[vals_List]]:=Map[opName->#&,vals];

(* Function to rebuild calls to the original experiment *)
SetAttributes[reconstructCall,HoldRest];
reconstructCall[expSymbol_,samples_,{args__}]:=Hold[expSymbol[samples,args]];


(* helper to get enumerated options from an experiment's OptionDefinition*)
enumeratedOptions[experimentFunction_Symbol, param_Symbol] := Module[
	{option, optionList, widgetType},

	(* get the option definition *)
	expOptions = OptionDefinition[experimentFunction];

	(* get the option definition from associated with the input parameter *)
	optionList =  Select[expOptions, (MatchQ[#["OptionName"], ToString[param]])&];

	(* the list should be a single element, get the first, or return $Failed if list is empty *)
	(* an empty optionList means that the option symbol was not in the option definition likely meaning there's a typo *)
	option = FirstOrDefault[#,Return[$Failed]]& @ optionList;

	(* get the widget of the associated option definition *)
	widgetType = option["Widget"][Type];

	(* check widget for enumeration *)
	If[MatchQ[widgetType, Enumeration],
		(* return a list of all possible enumerations *)
		option["Widget"][Items],
		(* else return the default *)
		{Lookup[option, "Default"]}
	]
];


(*Options for RunScriptDesignOfExperiment*)
DefineOptions[RunScriptDesignOfExperiment,
	Options:>{
		{
			OptionName -> SimulationMode,
			Default -> False,
			Description -> "The boolean to determine if the script protocols are simulations to be automatically set to complete.",
			AllowNull->False,
			Category -> "General",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	},
	Options:>{
		{
			OptionName -> PlotAnalysis,
			Default -> False,
			Description -> "The boolean to determine if the analysis object should be plotted after each protocol.",
			AllowNull->False,
			Category -> "General",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(*Warnings and errors*)
RunScriptDesignOfExperiment::NoAnalysis = "No analysis object is linked to the design of experiment script.";

(*Global variable to jump into demo mode that is faster*)
$DemoDOE=False;

(* Overload to run the script in the design of experiment *)
RunScriptDesignOfExperiment[doeObject:ObjectP[Object[DesignOfExperiment]], ops:OptionsPattern[]] := RunScriptDesignOfExperiment[First[doeObject[Script]], ops];

(* Overload to pull the link out of the script *)
RunScriptDesignOfExperiment[script:LinkP[Object[Notebook, Script]], ops:OptionsPattern[]] := RunScriptDesignOfExperiment[First@script, ops];

(*Main code functionality*)
RunScriptDesignOfExperiment[script:ObjectP[Object[Notebook, Script]], ops:OptionsPattern[]]:=Module[
	{keepGoing=True,colors, myNB,anaObj,doePlot},



	(* Get the analysis object if it exists, otherwise fail *)
	anaObj = Quiet[Check[Last[script[DesignOfExperiment][DesignOfExperimentAnalyses]],
		Message[RunScriptDesignOfExperiment::NoAnalysis];
		Return[$Failed],
		Last::nolast
		], Last::nolast
	];

	(* Get default input options *)
	safeOps=SafeOptions[RunScriptDesignOfExperiment,ToList[ops]];

	(* For a demo use the fast run through of DemoDOE *)
	If[$DemoDOE,

		(*Run script in demo mode*)
		{script, anaObj} =RunScriptDemoDOE[script, safeOps];

		(*Return all the script and object and exit the function*)
		Return[{script, anaObj}]
	];

	(*boolean to show the plot*)
	boolPlotAnalysis = Lookup[safeOps,PlotAnalysis];

	(*If plotting is enabled, prepare the dynamic object*)
	If[boolPlotAnalysis,
		doePlot = ECL`PlotDesignOfExperiment[anaObj];
		PrintTemporary[Dynamic[doePlot,TrackedSymbols:>{doePlot}]];
	];

	(*Catch to fail in case of error*)
	Catch[While[keepGoing,
		Module[{currentProts,completedProts,resolvedProtOps,currentValues},
			(*
				re-start script evaluation
				it will run until it generates a protocol
			 *)

			Check[RunScript[script],
				(
					keepGoing=False;
					Throw[script,"ScriptDone"];
				)
				(* Want this to fail on all errors *)
			];

			(*Pull out last protocol that ran*)
			prot = pullProtocol[NotebookImport[ImportCloudFile@script[CompletedNotebookFile], "Input"][[-1]]];

			(*plot the updated analysis object*)
			If[boolPlotAnalysis,
				doePlot = ECL`PlotDesignOfExperiment[anaObj]
			];

			(*
				update the current protocol status to completed
				now, next time we RunScript it will continue to the next step
			*)
			currentProts = Download[script,CurrentProtocols[Object]];

			(*Update protocol status to move script along*)
			Upload[Map[<|Object->#,Status->Completed|>&,currentProts]];

			(*Check if script status is completed to finish to exit the While loop otherwise update the most recent protocol as completed*)
			If[script[Status]===Completed,
				keepGoing=False;
				Throw[script,"ScriptDone"]
			];
		]
	],"ScriptDone"];

	(*return the design of experiment object and analysis object links*)
	{script[DesignOfExperiment], anaObj}
];

(* Used if DemoDOE is True *)
RunScriptDemoDOE[script:ObjectP[Object[Notebook, Script]], ops:OptionsPattern[]]:=Module[{},

	(*
		$DemoDOE evaluate the entire notebook at once
		Does:
			-Update completed protocols
			-Update the object analysis
		Does not:
			-Update the running protocols since they finish instantly
			-Update pending and completed scripts
			-Stop when a protocol is uploaded
	*)


	(*Pull out latest analysis object to return the one attached to this object*)
	anaObj = Last[script[DesignOfExperiment][DesignOfExperimentAnalyses]];

	(*Boolean to enable plotting*)
	boolPlotAnalysis = Lookup[ops,PlotAnalysis];

	(*Prepare plotting*)
	If[boolPlotAnalysis,
		(*plot design of experiment, this is only done in the demo*)
		doePlot = ECL`PlotDesignOfExperiment[anaObj];
		PrintTemporary[Dynamic[doePlot,TrackedSymbols:>{doePlot}]];
	];

	(*Over write down values to redirect to the simulation*)
	PrependTo[DownValues[ExperimentHPLC],HoldPattern[ExperimentHPLC[args___]] :> DesignOfExperiment`Private`SimulateHPLC[args]];

	(*pull in notebook*)
	myNB = NotebookPut[ImportCloudFile@script[TemplateNotebookFile]];
	(* import the expressions from the notebook *)
	nbExpressions = NotebookImport[myNB,"Input"->"HeldExpression"];

	(* evaluate them, and update the plot after the AnalyzeDOE calls *)
	(* mapping pulls the updates into a single call*)
	Map[
		(
			(* run the step *)
			ReleaseHold[#];
			(* if it was an AnalyzeDOE call, then update the plot *)
			If[boolPlotAnalysis && MatchQ[#,HoldComplete[_ECL`AnalyzeDesignOfExperiment | HoldPattern[CompoundExpression[_ECL`AnalyzeDesignOfExperiment, ___]]]],
				doePlot = ECL`PlotDesignOfExperiment[anaObj]
			];

			(*Pull out last protocol that ran*)
			prot = pullProtocol[#];

			(*Check that a protocol was generated*)
			If[MatchQ[prot, ObjectP[Object[Protocol]]],

				(* update as completed, running status is skipped*)
				updateStatusCompleted[script, prot]

			];
		)&,
		(* map over all notebook expressions*)
		nbExpressions
	];

	(*Delete overwritten ExperimentHPLC downvalues*)
	DownValues[ExperimentHPLC] = DeleteCases[DownValues[ExperimentHPLC], ___ :> DesignOfExperiment`Private`SimulateHPLC[___]];

	(*return design of analysis object and analysis object*)
	{script[DesignOfExperiment], anaObj}

];

(* change the status of the protocol to completed*)
updateStatusCompleted[doeScript_,prot_]:=Module[{},
	Upload[<|Object->First[doeScript[DesignOfExperiment]],
		(* remove the protocol from running *)
		Replace[RunningProtocols]->DeleteCases[First[doeScript[DesignOfExperiment]][RunningProtocols],prot|Link[prot,___]],
		(* add the protocol to completed *)
		Append[CompletedProtocols]->Link[prot]
	|>]
];

(* helper to pull the protocol out of the notebook expression *)
pullProtocol[HoldComplete[CompoundExpression[Set[currentProtocol_, exp_], Null]]] := Module[{},
	currentProtocol
];
