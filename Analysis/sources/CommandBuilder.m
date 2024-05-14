
(* ::Subsection::Closed:: *)
(*Command Builder Preview Dynamics*)

$VerbosePreview = False;

(*Command builder sends us everything, so there is no need for the first overload.*)
SetAttributes[PreviewValue,HoldRest];
PreviewValue[dvar_Symbol,Part[opName_,ind_Integer],rest___]:=
	dvar[optName][[ind]];

PreviewValue[dvar_Symbol,opName_]:= dvar[opName];

(*Next two overloads facilitate stripping units because MMA's graphics directive coordinates do not accept Quantity.*)
PreviewValue[dvar_Symbol,opName_,xOrY:(XUnit|YUnit)]:= With[
	{un=PreviewValue[dvar,xOrY]},
	PreviewValue[dvar,opName,un]
];

With[{unitPattern = UnitsP[]},
	PreviewValue[dvar_Symbol,opName_,unit:unitPattern]:= With[{val = dvar[opName]},
		With[{ans=Quiet[
			Check[
				If[MatchQ[val,_List],
					safeUnitless[#,unit]&/@val,
					safeUnitless[val,unit]
				],
				val
			]
		]},
			If[MatchQ[ans,_Unitless],val,ans]
		]
	];
];

safeUnitless[val_?NumericQ,targetUnit_]:=val;
safeUnitless[val_,targetUnit_]:=Unitless[val,targetUnit];


UpdatePreview[dvar_Symbol,opName_Symbol -> val_]:=
	UpdatePreview[dvar, {opName->val}];

UpdatePreview[dvar_Symbol,rules:{___Rule}]:= Module[{},

	If[TrueQ[hasClumpQ[dvar]],
		Module[{clump=dvarToClump[dvar],f=PreviewFunction[dvar]},
			ClumpSet[clump, SciCompFramework`Private`ExpandOptions[dvToFunction[dvar], clump[IndexLength], rules]];
		];
		,
		(* legacy system, set values in 'dvar' directly *)
		Map[
			(dvar[#[[1]]] = #[[2]])&,
			rules
		]
	];
];


LogPreviewChanges[c_Clump, opUpdates:{(_String->_) ..}, index_Integer]:=Module[
	{oldFullValues, collapsedValues},
	(*
        LogPreviewChanges[c, { "TopPeaks" -> 2, "Include" -> {3,4,7}, "Domain"->{20,50} }, 3]
        means we are setting these values for these options for index 3 of the index-expanded options
        For example, if our call was
        AnalyzeFractions[
            {data1,data2,data3,data4},
            TopPeaks -> {X,X,X,X}, Include -> {X,X,X,X}, Domain -> {X,X,X,X}}
        ]
        where X is whatever the old values were (those are not changing, but we need to send this full exapnded list to command builder (for now)),
        then we are settings up this set of updated options
        { TopPeaks -> {X,X,2,X}, Include -> {X,X,{3,4,7},X}, Domain -> {X,X,{20,50},X} }
    *)

	(* 
		The old values, for every index 
		{ TopPeaks -> {X,X,X,X}, Include -> {X,X,X,X}, Domain -> {X,X,X,X}} 
	*)
	oldFullValues = c[opUpdates[[;;,1]]];
	(*
		WIth the new values inserted in the correct index 
		{ TopPeaks -> {X,X,2,X..}, Include -> {X,X,{3,4,7},X..}, Domain -> {X,X,{20,50},X..}} 
	*)
	newFullValues = MapThread[updateOptionAtIndex[#1,#2,index]&,{oldFullValues,opUpdates}];
	(* 
		collapse options that have the same value at each index 
		{ TopPeaks -> {2,2,2,2}, Include->{{1},{3,4},{},{5}} }
		becomes
		{ TopPeaks -> 2, Includee -> {{1},{3,4},{},{5}} }
	*)
	collapsedValues = ReduceOptions[c[FunctionName], c[IndexLength], newFullValues];
	(* redirect to other definition *)
	If[$VerbosePreview,
		Print[collapsedValues];
	];
	LogPreviewChanges[clumpToDvar[c],collapsedValues]
];

(* convert string option name to symbol, because thats' what command builder wants *)
updateOptionAtIndex[ fullVals_List, newOption:Rule[opName_,singleVal_],ind_Integer]:=
	Rule[Symbol[opName], ReplacePart[fullVals,ind->singleVal]];


LogPreviewChanges[dv_Symbol,Null]:=Null;

LogPreviewChanges[dv_Symbol,rule_Rule]:=
	LogPreviewChanges[dv,{rule}];

LogPreviewChanges[dv_Symbol,valChanges:{Rule[_Symbol,_]...}]:=Module[{oldChanges,allNewChanges,postNow=True, postResult, opChanges},
	If[$VerbosePreview,
		Print["Updating: ",valChanges];
	];
	(* update values in dv *)
	UpdatePreview[dv,valChanges];

	(*  *)
	If[postNow,
		(* only post changes to actual options.  filter out internal variables *)
		opChanges = Intersection[
			valChanges,
			Options[dvToFunction[dv]],
			SameTest -> (ToString[First[#1]]===ToString[First[#2]]&)
		];

		If[$VerbosePreview,
			Print["Posting: ",opChanges];
		];

		If[Length[opChanges]>0,
			With[{jsonVal = previewChangesJSON[dv,opChanges]},
				If[$VerbosePreview,
					Print["json posting: ",jsonVal];
				];
				postResult = AppHelpers`Private`postJSON[jsonVal];
				If[$VerbosePreview,
					Print["postResult: ",postResult];
				];

				Return[postResult];
			]];
	];

];


previewChangesJSON[dv_,opChanges:{___Rule}]:= Module[{mmOptionRules,jsonOptionRules},

	(* association of widget stuff *)
	(* <|"Method" -> <| "Type" -> "Alternatives", ... |>, ... |> *)
	mmOptionRules = AppHelpers`Private`resolvedOptionsAssoc[Analysis`Private`dvToFunction[dv], {}, opChanges, Null, True, True, Resolve->False, PreviewSymbol->dv];

	(* turn into one giant json *)
	jsonOptionRules = ECL`Web`ExportJSON[mmOptionRules];

	{
		"previewSymbol" -> ToString[dv],
		"options"-> jsonOptionRules
	}
];

(*
	State of all current interactive options for the preview
*)
PreviewOptionsJSON[dv_Symbol]:=Module[{previewOps},
	previewOps = DeleteCases[
		Map[Symbol[#] -> dv[Symbol[#]] &, Keys[Options[dvToFunction[dv]]]],
		Rule[_, _dv],
		{1}
	];
	ECL`Web`ExportJSON[
		AppHelpers`Private`resolvedOptionsAssoc[dvToFunction[dv], {}, previewOps, Null, True, True, Resolve->False, PreviewSymbol->dv]
	]
];

(* everything starts as Null.  Specific values get set by SetupPreviewSymbol *)
PreviewSymbol[_]:=Null;

DefineOptions[SetupPreviewSymbol,Options:>{
	{PreviewSymbol->Null, _Symbol, "If specified, the value of this option will be used as the preview symbol."}
}];


SetupPreviewSymbol[analysisFunction_Symbol]:= SetupPreviewSymbol[analysisFunction,Null]
SetupPreviewSymbol[analysisFunction_Symbol,xy_,resolvedOps_,ops:OptionsPattern[]]:=With[
	{
		dv = If[MatchQ[OptionValue[PreviewSymbol],Null],
			Unique["dvar"],
			OptionValue[PreviewSymbol]
		]
	},

	(* store the variable in a known place *)
	PreviewSymbol[analysisFunction] = dv;
	dvToFunction[dv] = analysisFunction;

	(* copy resolved options as starting values *)
	If[Length[resolvedOps]>0,
		MapThread[
			(dv[#1]=#2)&,
			Transpose[List@@@resolvedOps]
		]
	];


	(* load some defaults, if given data *)
	If[ xy =!= Null,
		Module[{xmin,xmax,ymin,ymax},
			dv[XUnit] = Units[xy[[1,1]]];
			dv[YUnit] = Units[xy[[1,2]]];
			{{xmin,xmax},{ymin,ymax}} = CoordinateBounds[Unitless[xy]];
			dv[XMin] = xmin;
			dv[XMax] = xmax;
			dv[YMin] = ymin;
			dv[YMax] = ymax;
		]
	];

	(* return the variable name *)
	dv
];




makeCommandBuilderLinks[f_,dv_,cl_]:=Module[{},
	PreviewSymbol[f] = dv;
	hasClumpQ[dv]=True;
	dvarToClump[dv] = cl;
	clumpToDvar[cl] = dv;
	dvToFunction[dv] = f;
	functionToClump[f] = cl;
];

(* used in tests *)
opsFromJSON[raw_] := Lookup[Lookup[ImportString[raw, "RawJSON"],
	"ResolvedOptionValues"], {"TopPeaks", "Include", "Exclude",
	"Domain"}]


(*|==================================================|*)
(*|    New Command Builder connection using Clumps   |*)
(*|==================================================|*)

(* DefinePreviewClump is called in the main body of an Analysis function.  It stores the
   connection between the preview symbol (formerly dvar, now a Clump), and the analysis
   function name.  PreviewSymbol is exported, and called during ResolvedOptionsJSON to inform
   Command Builder of the Clump at initialization *)
DefinePreviewClump[analysisFunction_Symbol, clump_Clump] :=
	(
		PreviewSymbol[analysisFunction] = clump;
		PreviewAnalysisFunction[clump] = analysisFunction;
	);

(* When user edits a widget, Command Builder makes a request containing the Mathematica call:

       UpdatePreview[clump, {opt1 -> newVal1, opt2 -> newVal2, ...}].

   We want to update the appropriate clump properties, which are programmed to
   trigger updates to state-variable properties in the clump, which in turn
   updates the preview). *)
(* ReplaceRule with $AnalyzeColoniesResolvedOptions is a band-aid fix, but will not interfere with other functions since the default is {} *)
UpdatePreview[clump_Clump, op_List] := ClumpSet[clump, ReplaceRule[$AnalyzeColoniesResolvedOptions, Prepend[op, UpdatePreviewBoolean -> True]]];
(*UpdatePreview[clump_Clump, op_List] := ClumpSet[clump, op];*)

(* When user interacts with the preview, code in the preview function will update
   the preview state-variable in the clump, and the clump will automatically update
   new option values.  A subsequent call in the preview code is to be made:

       LogPreviewChanges[clump, {opt1 -> newVal1, opt2->newVal2, ...}]

   which sends a JSON string containing the new option values to Command Builder
   for the widgets to automatically update. *)
LogPreviewChanges[clump_Clump, newOptions_List]:=
	Module[{optionDefinitions, resolvedOptionsWidget, widgetJSONstring},

		(*AppHelpers`Private`optionWidgetResolver is the main helper function that turns the
		list of option-value pairs into an Association tree containing all the widget information.*)
		optionDefinitions = OptionDefinition[PreviewAnalysisFunction[clump]];
		resolvedOptionsWidget =
			AppHelpers`Private`optionWidgetResolver[
				optionDefinitions,
				newOptions,
				{},
				True];

		(*Add the clump variable, and turn the widget association tree into a JSON string*)
		widgetJSONstring =
			ExportString[
				ECL`AppHelpers`JSONConvertibleExpression[<|
					"ResolvedOptions" -> resolvedOptionsWidget,
					"PreviewSymbol" -> clump
				|>],
				"JSON", "Compact" -> True
			];

		If[$VerbosePreview,
			Print["New JSON posting:"];
			Print[{"previewSymbol"->ToString[clump], "options"->widgetJSONstring}]
		];
		(*Send JSON string to CommandBuilder*)
		AppHelpers`Private`postJSON[{"previewSymbol"->ToString[clump], "options"->widgetJSONstring}]
	];

commandBuilderSimulate::UnknownFunction = "`1` is not a function known to CommandBuilder.  Check that `1` is defined in $CommandBuilderFunctions.";
SetAttributes[commandBuilderSimulate, HoldFirst];
commandBuilderSimulate[inputExpr_] :=
	RuleCondition[Catch[
		Block[{
			cbFunctions, cbFunctionsDev, inputFunctionName, inputFunctionNameTrimmed,
			ECL`$ECLApplication=ECL`CommandCenter, inputArgumentsList, inputOptionsList, nb, task
		},

			cbFunctions = Values@Values@$CommandBuilderFunctions;
			cbFunctionsDev = Values@Values@$CommandBuilderFunctionsDev;

			(*Get the name of the function call, and drop Preview*)
			inputFunctionName = Extract[Unevaluated[inputExpr],0,ToString];
			inputFunctionNameTrimmed = StringReplace[inputFunctionName,
				WordBoundary ~~ functionName__ ~~ "Preview" :> functionName];

			(*Get the name of the function call, and drop Preview*)
			If[!MemberQ[{cbFunctions,cbFunctionsDev}, inputFunctionNameTrimmed, {4}],
				Message[commandBuilderSimulate::UnknownFunction, inputFunctionNameTrimmed];
				Throw[Fail, "commandBuilderSimulate"]
			];


			(*Now proceed to build the MMA call Command Center makes in Command Builder *)
			{inputArgumentsList, inputOptionsList}=
				Replace[Unevaluated[inputExpr],head_[arg_,opt___]:>{{arg},{opt}}];
			nb = NotebookPut[Notebook[{Cell["Command builder starting up...","Text"]}, WindowSize -> {1160, 310}]];

			task = With[{
				functionName=Symbol[inputFunctionNameTrimmed],
				inputArgumentsList=inputArgumentsList,
				inputOptionsList=inputOptionsList,
				nb=nb},

				(*
					The ScheduledTask makes calls from outside MM to simulate the fact that CC calls AnalyzeFunctions from JS.
					This is critical in revealing any crashes/hangups that would occur in CC.
				*)
				ScheduledTask[
					Block[{ECL`$FastDownload=True,$Notebook=Object[LaboratoryNotebook,"dummyNotebook"]},
						ECL`AppHelpers`ResolvedOptionsJSON[
							functionName,
							inputArgumentsList,
							inputOptionsList,
							nb
						]
					],
					Now
				]
			];

			SessionSubmit[Evaluate[task]]

		],"commandBuilderSimulate"]
	];

(* --------------------------------------------------------------*)


(* given button guide rules *)
mouseGuideRulesP = {KeyValuePattern[{Description->_String}]..};

makeMouseGuideToggler[guideRules:mouseGuideRulesP] := Module[
	{
		descriptions,buttonSets,styledDescriptions, mouseGuideElement, mouseGuideLabel, startingState,
		expandedState
	},

	(* must have descriptions, but button sets can be null*)
	descriptions = Lookup[guideRules, Description];
	buttonSets = Lookup[guideRules,ButtonSet, Null];
	(* add a colon if not already there, and make Bold *)
	styledDescriptions = MapThread[ Style[If[ #2===Null || StringEndsQ[#1, ":"], #1, #1<>":"],Bold]&, {descriptions,buttonSets}];
	
	mouseGuideElement = Column[
		MapThread[ Column[{##}]&, {styledDescriptions, buttonSets} ],
		Spacings -> 2
	];
	
	(* alignment details are important to prevent things from moving when you toggle *)
	mouseGuideLabel = Column [ { Button["Mouse Guide", Null, Appearance->"Palette", FrameMargins->5] }, Alignment->Right, Spacing->2 ];

	(* default state of Toggler *)
	(* put inside a pane to match the expanded state format so that button does not move when clicked *)
	startingState = Pane[Column[{mouseGuideLabel}, Frame->True], Alignment->Right];
	
	(* expanded state *)
	expandedState = Pane[
		Column [
			{ mouseGuideLabel, mouseGuideElement },
			Alignment->Right,
			Frame -> True
		],
		Alignment->Right
	];

	(* adding the pane prevents the toggler occupying the whole expandedState area even when in the startingState *)
	Pane[
		Toggler[
			(* starting state *)
			startingState,
			{
				startingState,
				expandedState
			},
			ImageSize->Automatic,
			Alignment->Right,
			ContentPadding -> False,
			BaselinePosition -> Right,
			Background -> RGBColor[ConstantArray[0.96, 3]]
		],
		Alignment -> {Right, Top},
		ImageSizeAction -> "ShrinkToFit"
	]

];
makeMouseGuideToggler[else_] := Null;


addMouseGuideToggler::usage = "addMouseGuideToggler[expression,function] places a mouse guide _Toggler next to expression.  
The guide contains the information from function's ButtonActionsGuide usage rule."

(* pull BuggtonActionsGuide from function's usage *)
addMouseGuideToggler[expression_,function_Symbol] := With[
	{ mouseGuideRules = Lookup[Usage[function],"ButtonActionsGuide",{}] },
	addMouseGuideToggler[expression, mouseGuideRules ]
];

(* set the toggler to a global variable called in ResolvedOptionsJSON to attach to the preview *)
addMouseGuideToggler[expression_, guideRules:mouseGuideRulesP] := $PreviewMouseGuide = makeMouseGuideToggler[ guideRules ];

(* anything else -- no toggler *)
addMouseGuideToggler[expression_, else_] := expression;

AdjustForCCD::usage = "AdjustForCCD[expression, function] modifies expression, if $CCD=Tru, to have a mouse guide around it.";

AdjustForCCD[ expression_ , function_Symbol] := If[TrueQ[$CCD],
	addMouseGuideToggler[expression, function];
	expression,
	expression
];
