(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeDesignOfExperiment*)


(* Define options for AnalyzeDesignOfExperiment *)

DefineOptions[AnalyzeDesignOfExperiment,
    Options :> {
        {
            OptionName -> ParameterSpace,
            Default -> Automatic,
            AllowNull -> False,
            Description -> "The symbols that define the variable parameters used in this design of experiments.",
            Category -> "Method",
            Widget -> Alternatives[
        		Adder[Widget[Type->Expression,Pattern:>_Symbol, Size->Word]],
        		Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]]
        	]
        },
		{
			OptionName -> Method,
			Default -> Custom,
			Description -> "The optimization algorithm which should be used to maximize the provided ObjectiveFunction over the input search space.",
			AllowNull->False,
			Category -> "Method",
			Widget -> Alternatives[
				"Preset"->Widget[Type->Enumeration, Pattern:>Alternatives[Custom, GridSearch]],
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
						Automatic,
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
			OptionName -> UpdateAnalysis,
			Default -> Null,
			Description -> "An existing analysis function that will be updated during the current function evaluation.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type->Object,
				Pattern :> ObjectP[Object[Analysis, DesignOfExperiment]],
				ObjectTypes -> {Object[Analysis, DesignOfExperiment]}
			]
		},
        UploadOption,
        OutputOption
    	(*AnalysisTemplateOption*)
    }
];


(* protocol pattern for analysis function input *)
myProtocolP = ObjectP[Object[Protocol]];


(* Messages *)
AnalyzeDesignOfExperiment::MultipleTypes="Multiple different types of protocols were found in the input list, `1`. This is not currently supported since comparing across different protocol types (e.g. HPLC and NMR) may not be possible.";
AnalyzeDesignOfExperiment::NoOptions="No explicitly specified experiment parameters were found in this list of protocols, `1`. Please ensure that each protocol was made with explicitly defined options (e.g. FlowRate->1 Milli Liter / Minute).";
AnalyzeDesignOfExperiment::UnknownExperiment="The current experiment type, `1`, is not supported by AnalyzeDesignOfExperiment. Bear with us since this function is so new.";
AnalyzeDesignOfExperiment::NoParameterSpace="No ParameterSpace was found in the inputs. This needs to be set.";
AnalyzeDesignOfExperiment::NoObjectiveFunction="No objective function was found in the input or options. The analysis of a Design of Experiment run requires an objective function to be set.";
AnalyzeDesignOfExperiment::ParameterNotFound="One, or more, of the parameters in ParameterSpace was not found amongst the experimental parameters set in the input protocol objects.";
AnalyzeDesignOfExperiment::MismatchedParameterSpace="The input ParameterSpace found in the specified options does not match the ParameterSpace found in the analysis object linked via the UpdateAnalysis option.";


(* overload to take in a completed script *)
AnalyzeDesignOfExperiment[myDOE:ObjectP[Object[DesignOfExperiment]], myOps:OptionsPattern[]]:= Module[{},

    (*check for objective function in options*)

    (*Create a new analysis object with a link to the script*)
	doeAnalysisObject = Upload[
		Association[
			Type->Object[Analysis,DesignOfExperiment],
			Method->myDOE[Method],
			Replace[ParameterSpace]->myDOE[Parameters],
            Replace[Reference]->Link[myDOE,DesignOfExperimentAnalyses]
		]
	];

    AnalyzeDesignOfExperiment[myDOE[CompletedProtocols], UpdateAnalysis->doeAnalysisObject, myOps]
];

(* overload to turn singleton input into a list *)
AnalyzeDesignOfExperiment[myProtocol:myProtocolP, myOps:OptionsPattern[]]:=AnalyzeDesignOfExperiment[{myProtocol}, myOps];
(* define analysis function for design of experiments *)
DefineAnalyzeFunction[
	AnalyzeDesignOfExperiment,
	(* input pattern *)
	<|InputProtocols -> {myProtocolP..}|>,
	{
		resolveAnalyzeDOEInputs,
		resolveAnalyzeDOEOptions,
		evaluateObjectiveFunction,
		findOptimalObjectiveValue,
		analyzeDOEPreview
	}
];


(* ::Subsection::Closed:: *)
(*resolveAnalyzeDOEInputs*)


(* -------------------- input resolver -------------------- *)
(* helper that resolves inputs into lists of lists of rules *)
resolveAnalyzeDOEInputs[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{InputProtocols->myProtocols_}]
	}]
]:=Module[
	{
		experiments, inputSymbols, dataReferences, numericData, protocolOptions, resolvedProtocolOptions,
		dataDownload, dataLinks, protocolLinks, protocols
	},

	(* ensure that input protocols is a list *)
    (* unlink myProtocols *)
	protocols = Download[myProtocols, Object];

	(* get input symbols for each experiment *)
	inputSymbols = resolveExperimentDataSymbol[protocols];

    (* if any of the input symbols failed to find, then return $Failed to the
    framework, relying on the messages in the helper function *)
    If[MatchQ[inputSymbols, $Failed],
        Return[$Failed]
    ];

	(* get the protocol type for the packet *)
	protocolType = First[Download[protocols, Type], Null];

	(* download the data references for each protocol *)
	(* dimension of download blob: (num protocols, 2, ) *)
	(* TODO: is there a way to download different fields from a list of objects *)
	(* e.g. Download[Object[Protocol,HPLC,"id:xx"], Object[Protocol,PAGE,"id:yy"], {Data[Absorbance], Data[OptimalLaneIntensity]}])
	and get the list of two data-sets *)
	dataDownload = Download[protocols, {Data[Object], Data[inputSymbols], UnresolvedOptions, ResolvedOptions}];

	(* transpose the outer list from the protocol list to get lists of data lists *)
	{dataReferences, numericData, protocolOptions, resolvedProtocolOptions} = Transpose[dataDownload];

    (* if protocol options are null throw error and exit *)
    If[MemberQ[protocolOptions, (Null|{})] && MemberQ[resolvedProtocolOptions, (Null|{})],
        Message[AnalyzeDesignOfExperiment::NoOptions, protocols];
        Return[$Failed]
    ];

	(* create links by mapping link on flattened data references *)
	dataLinks = Link /@ Flatten[dataReferences];

	(* create protocol links *)
	protocolLinks = Link /@ protocols;

	(* store the data in the resolved inputs association and return *)
	<|ResolvedInputs ->
		<|
			ProtocolOptions -> protocolOptions,
            ResolvedProtocolOptions -> resolvedProtocolOptions,
			References -> dataReferences,
			NumericData -> numericData,
			Protocols -> protocolLinks
		|>,
		Intermediate -> <|DataLinks -> dataLinks|>
	|>
];


(* ::Subsubsection::Closed:: *)
(*Input resolvers for different protocols*)

(* overload for a list of input symbols that maps the inputs *)
resolveExperimentDataSymbol[in_List]:=Module[
	{uniqueTypes},

	(* check that all inputs are the same Type *)
	uniqueTypes = Union[Download[in, Type]];
	If[MatchQ[Length[uniqueTypes], GreaterP[1,1]],
		(* this means there are multiple different types in the input, which is currently not supported,
		Send a message and return $Failed *)
		Message[AnalyzeDesignOfExperiment::MultipleTypes, in];
		Return[$Failed]
	];

	(* no failures detected so return the symbol of the first element of in since they are all the same type *)
	resolveExperimentDataSymbol[First[in]]
];

(* resolver for fields of interest for each experiment symbol *)
resolveExperimentDataSymbol[in:Object[Protocol,exp_Symbol,___]]:=Module[
	{},

	(* Return the symbol Absorbance for now, but leave a module here in case more
	complicated stuff needs to happen in the future *)

	Switch[exp,
		HPLC, Absorbance,

        AbsorbanceSpectroscopy, AbsorbanceSpectrum,
		(* TODO: hook this in with LegacySLL stuff to auto-determine relevant data field in protocol *)
		(* for example only code for HPLC for demonstrations *)
		_,  (* all other cases send message and return failed *)
            Message[AnalyzeDesignOfExperiment::UnknownExperiment, exp];
            Return[$Failed]
	]
];

(* TODO: Fix this to work in the general case, linked to the above TODO. This
is only going to work for our test object made by ExperimentFake *)
resolveExperimentDataSymbol[in:Object[Protocol,_String]]:=Module[
	{},
	(* Only return absorbance for the simplest test case we've made *)
	Absorbance
];

(* base case is an unknown experiment symbol, which returns an error *)
resolveExperimentDataSymbol[in_]:=Module[{},
	Message[AnalyzeDesignOfExperiment::UnknownExperiment, in];
	(* return failed *)
	Return[$Failed]
];


(* ::Subsection::Closed:: *)
(*resolveDOEOptions*)
(* -------------- option resolver -------------- *)
(* helper that resolves the parameter space option *)
resolveAnalyzeDOEOptions[
	KeyValuePattern[{
		ResolvedInputs -> KeyValuePattern[{
			ProtocolOptions -> protocolOptions_,
            ResolvedProtocolOptions -> resolvedProtocolOptions_,
			References -> dataObjects_,
			NumericData -> myData_,
			Protocols -> myProtocols_
		}],
		ResolvedOptions -> resolvedOps_,
		UnresolvedOptions -> unresolvedOps_,
		Intermediate -> KeyValuePattern[{DataLinks -> dataLinks_}]
	}]
]:=Module[
	{
		initialPspace, pspace, paramLists, unresolvedParamLists, resolvedParamLists, expandedParams, paramExpander, protocolOptionExpander,
        flattenedData, flattenedParams, optionTests, analysisObject, uploadHead, method, objectPacketRule,
		objectiveFunction, updatedObjectiveFunction
	},

	(* find the parameter space defined by the resolved inputs *)
	initialPspace = Lookup[resolvedOps, ParameterSpace];

	(* look up the analysis object from the resolved options *)
	analysisObject = Lookup[resolvedOps, UpdateAnalysis];
	analysisPacket = Download[analysisObject];

	(* if analysis object is not null get the analysis params *)
	(* else use the pspace as is *)
	pspace = resolveParamSpace[initialPspace, analysisPacket];

    (* if parameter space failed to resolve return $Failed to the framework *)
    If[MatchQ[pspace,$Failed], Return[$Failed]];

	(* update the method considering what is in the current analysis object *)
	method = updateOption[Method, unresolvedOps, resolvedOps, analysisPacket];

	(* update the objective function considering what's in the analysis packet *)
	updatedObjectiveFunction = updateOption[ObjectiveFunction, unresolvedOps, resolvedOps, analysisPacket];

	(* if objective function is automatic at this point set it to Null *)
	(* this will error out the function until we know how to better resolve automatic *)
	objectiveFunction = updatedObjectiveFunction /. {Automatic -> Null};

	(* throw error if ParameterSpace and ObjectiveFunction are not defined in ResolvedOptions *)
	If[MatchQ[pspace, ({}|$Failed)],
		(* throw error *)
		Message[AnalyzeDesignOfExperiment::NoParameterSpace];
		Return[$Failed]
	];

	(* throw error if objective function is not defined *)
	If[MatchQ[objectiveFunction, (Null|$Failed)],
		(* throw error *)
		Message[AnalyzeDesignOfExperiment::NoObjectiveFunction];
		Return[$Failed]
	];

    (* Pull out the resolved options in the parameter space *)
    parameterSpaceRules = Map[FilterRules[#1, pspace]&,resolvedProtocolOptions];

    (*Flatten the paramters for each protocol*)
    parameterSpaceRules = Map[Flatten, parameterSpaceRules];

	(*
        check if pvalues were successfully found
        if length of found rules matches the pspace, and handle errors
    *)
    If[Length[Flatten[parameterSpaceRules]]<Length[pspace],
		(* send message and return failed *)
		(* TODO: return actual failing parameter space symbols and protocol objects that failed *)
		Message[AnalyzeDesignOfExperiment::ParameterNotFound];
		Return[$Failed]
	];

    (* sort the parameter space rules in order of the parameter space *)
    pSpaceSort[ruleSort_]:= SortBy[ruleSort, Position[pspace, First[#]] &];

    optimalParamRules = Map[
        pSpaceSort[#]&,
        parameterSpaceRules
    ];

    (*Function to split a rule to a list to a list of rules *)
    ruleSplitter[Rule[key_, values_]] := Module[{},
        Map[
   	        key -> # &,
   	        values
        ]
    ];

	(* need to make sure that parameter space is index matched to data objects *)
	(* to do this, first, make a function that expands singleton inputs and leaves list inputs alone *)
	(*paramExpander[param:Except[_List], objects_]:=paramExpander[{param}, objects];*)
	paramExpander[params_Rule, objectLength_] := Module[
		{},

        (* Error handling for length parameters not match length data objects or 1 *)
		If[And[MatchQ[Length[Values[params]], objectLength],MatchQ[Values[params], _List]],
            (*split the rule based on the object length*)
            ruleSplitter[params],

            (*Otherwise duplicate the params across the length of the protocols*)
    		ConstantArray[params, objectLength]

            (*
                TODO there are scenarios where an option may not be index mathed to the data objects
                Maybe only split if the parameter is in the parameter space where we know it is index matched?
            *)
		]
	];

    (*Map over each protocol option and expand to length of data objects*)
    protocolOptionExpander[paramList_List, objectLength_]:=Module[{},

        (*map over each option in the parameter space and expand it if needed *)
        Map[
            paramExpander[#, objectLength]&,
            paramList
        ]

    ];

	(* now map the function over the list of parameters *)
    (* expand just the parameter space options to match the data length within each protocol *)
    (* this should yield an array that has dimensions (num params, num protocols, num data) *)
    expandedParameterSpace = MapThread[
		protocolOptionExpander,
		{optimalParamRules, Length/@dataObjects},
		1
	];

    (* flatten and transpose the parameter space options to get the set for each data object *)
    flattenedParameterSpace = Flatten[
        Map[
            Transpose,
            expandedParameterSpace
        ],
        1
    ];

	(* do the same thing for numeric data, but stop flatten at lvl 1
	to preserve (x,y) list structure *)
	(* data objects that have no numeric data will show up as {},
	which will mess up the flatten, so replace them to $Failed *)
	flattenedData = Flatten[Replace[myData, {}->$Failed], 1];

	(* transpose both parameters to get shape of (total data, num params) *)
	(* make silly option tests *)
	(*TODO: fix this later *)
	optionTests = {
		Test["Something:",1+1,2]
	};

	(* if the analysis object is Null, then make the uploadHead equal to Replace *)
	uploadHead = If[MatchQ[analysisObject, Null],
		Replace,
		(* else set it to Append, which will update the current analysis object *)
		Append
	];

	(* create rule for adding the object reference to the packet; rule can be nothing *)
	objectPacketRule = If[MatchQ[analysisObject,ObjectP[Object[Analysis, DesignOfExperiment]]],
		Object->analysisObject,
		(* if there is no analysis object return nothing *)
		Nothing
	];

	(* return the resolved options *)
	<|
		ResolvedOptions -> <|
            ParameterSpace -> pspace,
            ObjectiveFunction -> objectiveFunction,
            Method -> method
		|>,
		ResolvedInputs -> <|
			NumericData -> flattenedData
		|>,
		(* download the analysis object into the stashed space *)
		(* TODO: optimize this download in the future *)
		Intermediate -> <|
			ParameterRules -> flattenedParameterSpace,
			UploadHead -> uploadHead,
            AnalysisObject -> analysisPacket
        |>,
		(* add necessary options data to packet *)
		Packet -> <|
		(* check if UpdateAnalysis is an object, if yes, add that as the object to the packet *)
			objectPacketRule,
			Method -> method,
			(* always add the replace head here because param space is a multiple field *)
			(* if that ever changes, then change the following line *)
			Replace[ParameterSpace] -> pspace,
			uploadHead[ExperimentParameters] -> flattenedParameterSpace,
			uploadHead[Data] -> dataLinks,
			uploadHead[Protocols] -> myProtocols,
			ObjectiveFunction -> objectiveFunction
		|>,
		Tests -> <|Options -> optionTests|>
	|>
];

(* helpers to resolve the method from the analysis object if necessary *)
(* first case is when the analsysis obj is null, just return the method from the resolved ops *)
updateOption[option_Symbol, unresolvedOps_, resolvedOps_, Null]:=Lookup[resolvedOps, option];
(* if analysis obj is not null, then return the option from either the analysis
packet, or the unresolved options, defaulting to the unresolved options *)
updateOption[
	option_Symbol,
	unresolvedOps_,
	resolvedOps_,
	analysisPacket_
]:=Module[
	{},

	(* return option from either unresolved ops or analysis object *)
	If[MemberQ[unresolvedOps, HoldPattern[Rule[option, _]]],
		(* TRUE: use option from unresolved ops *)
		Lookup[unresolvedOps, option],
		(* FALSE: use the option set in the analysis object *)
		Lookup[analysisPacket, option]
	]
];


(* TODO: re-write this logic puzzle using overloads to resolve the logic *)
resolveParamSpace[initialPspace_, analysisPacket_]:=Module[
	{analysisPspace},

	(* check if analysis object is not null and resolve parameter space and handle errors along the way *)
	If[
		Not[MatchQ[analysisPacket, Null]],
		analysisPspace = Lookup[analysisPacket, ParameterSpace];
		(* check if input pspace is Automatic *)
		If[MatchQ[initialPspace, Automatic],
			(* return the analysis object pspace *)
			analysisPspace,
			(* else check if these are the same *)
			If[MatchQ[analysisPspace, initialPspace],
				(* return one of the pspaces *)
				initialPspace,
				(* else send message and return $Failed *)
				Message[AnalyzeDesignOfExperiment::MismatchedParameterSpace, initialPspace, analysisPspace];
				Return[$Failed]
			]
		],
		(* ELSE: analysis object is Null, use initial pspace *)
		(* check if param space is Automatic here, and return error *)
		If[MatchQ[initialPspace, Automatic],
			Message[AnalyzeDesignOfExperiment::NoParameterSpace];
			Return[$Failed],
			(* else the initial param space is good *)
			initialPspace
		]
	]
];


(* ::Subsection::Closed:: *)
(*evaluateObjectiveFunction*)


(* -------------------- objective function eval -------------------- *)
(* helper that evaluates objective function for a list of data objects *)
evaluateObjectiveFunction[
  KeyValuePattern[{
		Intermediate -> KeyValuePattern[{
            DataLinks -> myDataReferences_,
			ParameterRules -> myParamRules_,
			UploadHead -> uploadHead_
		}],
		Packet -> KeyValuePattern[{
			ObjectiveFunction -> objectiveFunction_
		}]
  }]
]:=Module[
	{evaluations},

	(* use the objective function to evaluate the data objects *)

    (*add in error catch if the objective function does not evaluate*)
	evaluations = Map[objectiveFunction, myDataReferences];

	(* return the data *)
	<|
		Packet -> <|
			uploadHead[ObjectiveValues] -> evaluations
		|>
	|>
];


(* ::Subsection::Closed:: *)
(*findOptimalObjectiveValue*)


(* -------------------- find optimal values -------------------- *)
(* helper that finds the optimal obj func value given an opt function *)
findOptimalObjectiveValue[KeyValuePattern[{
	Packet -> KeyValuePattern[{
		_[ObjectiveValues] -> myEvaluations_,
		_[ParameterSpace] -> pspace_
	}],
	Intermediate -> KeyValuePattern[{
        AnalysisObject->analysisObject_,
		ParameterRules -> myParamRules_
    }]
}]]:=Module[
	{
		allEvaluations, allParamValues, oldEvals, oldParams, optimalParams, maxObjValue,
		optimalParamRules, expParams
	},

	(* join the old evaluations and param values with the new ones *)
	{allEvaluations, allParamValues} = If[
		MatchQ[analysisObject,Null],
	(* TRUE: just return the parameter values *)
		{myEvaluations, myParamRules},
	(* ELSE: join the new evaluations with the old ones *)
		oldEvals = Lookup[analysisObject, ObjectiveValues];

		(* lookup the old params from the resolved ops of the analysis obj *)

        expParams = Lookup[analysisObject, ExperimentParameters];

		(* return the joined list of the old and new lists *)
		{Join[oldEvals, myEvaluations], Join[expParams, myParamRules]}
	];

	(* find the maximum objective value *)
	(* TODO: figure out how to incorporate minimal values *)
	maxObjValue = Max[allEvaluations];

	(* pick the parameter values that correspond to the optimal value *)
	optimalParams = PickList[allParamValues, allEvaluations, maxObjValue];
	(* thread into a list of rules to make the output more clear *)
	(* be sure to use first on optimal params because it should be a one element list *)
	(* TODO: figure out if this should be a list or not *)

    (* sort the rules to be in the order of the parameter space *)
    optimalParamRules = SortBy[optimalParams, Position[pspace, First[#]] &];

    (*
        Pull the values out. These will be presented as index matched to the parameter space.
        Sorting ensures the parameter space and optimal parameters line up correctly.
    *)
    optimalParamValues = Values[optimalParamRules];

	(* return the results *)
	<|
		Packet -> <|
			(* always use the Replace head for optimal params *)
			Replace[OptimalParameters] -> Flatten[optimalParamValues,1],
			OptimalObjectiveValue -> maxObjValue,
			Type -> Object[Analysis, DesignOfExperiment]
		|>
	|>
];


(* ::Subsection::Closed:: *)
(*analyzeDOEPreview*)


(* return a simple line plot as the preview *)
(* TODO: figure out how to make this better for high dimensional optimizations *)
analyzeDOEPreview[
	KeyValuePattern[{
		OutputList -> outputList_,
		Packet -> packet_ (*KeyValuePattern[{
			(* add blank head around key to account for Append and Replace heads *)
			_[ObjectiveValues] -> values_
		}]*)
	}]
]:=Module[
	{xData},

	(* if Preview is not in the output list just return Null *)
	If[Not[MemberQ[outputList, Preview]],
		Return[<|Preview->Null|>]
	];

	(* make emerald list line plot of the flattened list of objective values vs the run number *)
	(* TODO: this needs to be changed/cleaned up in the future bc this preview won't be super helpful *)
	(*xData = Range[Length[values]];
	plot = EmeraldListLinePlot[Transpose[{xData, values}]];*)
    plot = PlotDesignOfExperiment[stripAppendReplaceKeyHeads[packet]];

	(* return the preview association value *)
	<|Preview->plot|>
];
