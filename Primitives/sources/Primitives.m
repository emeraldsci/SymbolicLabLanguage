(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*Patterns*)

ManualSamplePreparationMethodP=Verbatim[ManualSamplePreparation][___];
RoboticSamplePreparationMethodP=Verbatim[RoboticSamplePreparation][___];
ManualCellPreparationMethodP=Verbatim[ManualCellPreparation][___];
RoboticCellPreparationMethodP=Verbatim[RoboticCellPreparation][___];
ExperimentMethodP=Verbatim[Experiment][___];


(* ::Subsection:: *)
(*Option Setting*)

(* ::Subsubsection::Closed:: *)
(*DefinePrimitiveSet*)

(* Pattern for backend primitive information. Not exported because the user should never see this. *)
PrimitiveP=KeyValuePattern[{
	PrimitiveHead -> _Symbol,
	Pattern -> _,
	OptionDefinition -> {_Association..},

	Methods -> {_Symbol...},
	WorkCells -> {_Symbol...},

	ExperimentFunction -> (_Symbol | Null | None),
	RoboticExporterFunction -> (_Symbol | Null),
	RoboticParserFunction -> (_Symbol | Null),
	MethodResolverFunction -> (_Symbol | Null),
	WorkCellResolverFunction -> (_Symbol | Null),
	OutputUnitOperationParserFunction -> (_Symbol|Null),

	LabeledOptions -> _List,
	InputOptions -> _List,
	CompletedOptions -> _List,
	Generative -> (True|False),

	Description -> _String|Null,
	Category -> _String,
	Icon -> (_Image | _Graphics | Null),

	(* NOTE: GenerativeLabelOption MUST be supplied and filled out to ListableP[_String] if you're generating samples out. *)
	(* This is because primitives will be autofilled from the generative output of the previous primitive -- therefore we *)
	(* need a way of referencing the previous generative result. *)
	GenerativeLabelOption -> _Symbol
}];

PrimitiveSetP=KeyValuePattern[{
	Primitives->{(_Symbol->PrimitiveP)..},
	MethodOptions->{(_Symbol -> {_Association..})..}
}];

(* NOTE: This lookup converts between the given primitive set pattern (held so it doesn't evaluate) and detailed information *)
(* for all of the primitives as defined by DefinePrimitive[...]. *)

(* NOTE: This is in the form <|(Hold[primitiveSetPattern_Symbol] -> PrimitiveSetP)..|>. *)
$PrimitiveSetPrimitiveLookup=<||>;

(* Helper function to make a pattern for a primitive given some key information. *)
(* NOTE: This does NOT do any symbol installation or setting, just construction of the pattern. *)
constructPrimitivePattern[mySymbol_Symbol, allRequiredOptions_List, allOptions_List, inputOptions_List, patternLookup:(_Association|{_Rule..})]:=Module[
	{realRequiredOptions},

	(* Figure out our real required options. The first input option isn't really required because we can autofill it. *)
	realRequiredOptions=Cases[allRequiredOptions, Except[FirstOrDefault[inputOptions]]];

	With[
		{insertMe1=realRequiredOptions, insertMe2=allOptions, insertMe3=patternLookup},

		Alternatives[
			ObjectP[Object[UnitOperation, mySymbol]],
			_mySymbol?(
				And[
					(* Make sure that head matches and that we have an association inside. *)
					MatchQ[#,mySymbol[_Association]],

					(* Make sure that we have our required options provided. *)
					Length[Complement[insertMe1, Keys[#[[1]]]]]==0,

					(* Make sure that all of our options match their patterns. *)
					And@@(
						KeyValueMap[
							Function[{option, value},
								Or[
									(* Automatically include the PrimitiveMethod->PrimitiveMethodP option in the pattern since we use this for *)
									(* internal resolving in the primitive framework. Not exposed to the user or return to the user in the resolved *)
									(* primitive though. *)
									MatchQ[option, PrimitiveMethod] && MatchQ[value, ECL`PrimitiveMethodP],

									(* This is an automatically added key that we use inside of the primitive framework to do resolving. *)
									(* We remove it before returning information to the user but we still pattern match inside of the framework. *)
									MatchQ[option, PrimitiveMethodIndex],

									(* These are fields used in Object[UnitOperation]'s in SamplePreparationP to extracted options from resolved unit operations *)
									(* They are removed before returning information to the user but we still pattern match inside of the framework *)
									MatchQ[option, UnresolvedUnitOperationOptions] && MatchQ[value,{_Rule...}],
									MatchQ[option, ResolvedUnitOperationOptions] && MatchQ[value,{_Rule...}],

									And[
										(* The option is defined for this primitive. *)
										MemberQ[insertMe2, option],
										(* The option matches the pattern. *)
										(* NOTE: Default to _ for CompletedPatterns that don't have a real option definition so they still match *)
										(* the pattern check. *)
										MatchQ[value, ReleaseHold[Lookup[insertMe3, option, _]]]
									]
								]
							],
							#[[1]]
						]
					)
				]
			&)
		]
	]
];

(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_,Hold[expr__]]:=Hold[f[expr]];
SetAttributes[holdComposition,HoldAll];

(* Delete any duplicate options by taking the last one. *)
(* NOTE: We don't use DeleteDuplicatesBy here because that resolves duplicates by taking the first, we want the last. *)
holdCompositionList[f_,{helds___Hold}]:=Module[{joinedHelds},
	(* Join the held heads. *)
	joinedHelds=Join[helds];

	(* Swap the outter most hold with f. Then hold the result. *)
	With[{insertMe=joinedHelds},holdComposition[f,insertMe]]
];
SetAttributes[holdCompositionList,HoldAll];

DefinePrimitiveSet[mySymbol_Symbol, primitives:{PrimitiveP..}, myPrimitiveRules:(RuleDelayed[(MethodOptions),{Verbatim[RuleDelayed][_Symbol,_List]..}]...)]:=Module[
	{wasProtectedQ, methodOptionCleanedDefinitions, allowablePrimitivePattern, pattern, allowedMethods},

	(* Record whether the symbol was protected coming into defining of options *)
	wasProtectedQ=MemberQ[Attributes[mySymbol],Protected];

	(* Unprotect the symbol *)
	Unprotect[mySymbol];

	(* For each method head, get the cleaned option definitions. *)
	methodOptionCleanedDefinitions=If[MatchQ[ECL`ToList[myPrimitiveRules], {}],
		{},
		(#[[1]]->Options`Private`optionDefinitions[#[[1]],Options:>Evaluate[#[[2]]]]&)/@Lookup[ToList[myPrimitiveRules], MethodOptions]
	];

	(* optionDefinitions does validation and will throw a message if returning $Failed. *)
	If[MemberQ[methodOptionCleanedDefinitions[[All,2]], $Failed],
		If[wasProtectedQ,
			Protect[mySymbol]
		];

		Return[$Failed];
	];

	(* Install this information into $PrimitiveSetPrimitiveLookup so that we can lookup the information in our framework functions. *)
	(* NOTE: We have to put this in the Lookup as a Hold[...] because it will evaluate the moment we install the pattern. *)
	With[{insertMe=mySymbol},
		$PrimitiveSetPrimitiveLookup[Hold[insertMe]]={
			Primitives->(Lookup[#, PrimitiveHead] -> #&)/@primitives,
			MethodOptions->methodOptionCleanedDefinitions
		};
	];

	(* Install a pattern for this primitive set. *)
	(* NOTE: We don't have to clear the symbol because by definition, if it matched the pattern check for the input as *)
	(* _Symbol, it can't have an OwnValue yet. *)
	allowablePrimitivePattern=Alternatives@@Lookup[primitives, Pattern];

	(* Lookup all of the methods that we can use in this primitive set. *)
	allowedMethods=DeleteDuplicates[Flatten[Lookup[primitives, Methods]]];

	(* The full pattern is either a raw primitive or a series of primitives wrapped in an allowed method head. *)
	pattern=Alternatives[
		allowablePrimitivePattern,
		(Alternatives@@allowedMethods)[
			Alternatives[
				allowablePrimitivePattern,
				(* For any additional options for the method head. *)
				_Rule
			]..
		]
	];

	(* Reprotect if necessary. *)
	If[wasProtectedQ,
		Protect[mySymbol]
	];

	(* Install the new definition. Make sure that the required keys are provided. *)
	With[{insertMe=pattern},
		mySymbol:=insertMe;
	]
];


(* ::Subsubsection::Closed:: *)
(*DefinePrimitive*)

DefinePrimitive::InvalidKey="`2` are not valid keys for DefinePrimitive. You may only use {RequiredSharedOptions, SharedOptions, Options, ExperimentFunction}.";
DefinePrimitive::RequiredExperimentFunction="The ExperimentFunction option is required when defining a primitive, if a work cell is not specified. Please provide the ExpeirmentFunction option for the primitive, `1`.";
DefinePrimitive::WorkCellOptions="The options WorkCell and RoboticExporterFunction/RoboticParserFunction must either both be specified or not be specified at all for the primitive `1`. Please correct these options.";
DefinePrimitive::UnknownLabeledOption="The options, `1`, given as the LabeledOptions are not known option for `2`. Please only include known options in the LabeledOptions key to DefinePrimitive";
DefinePrimitive::RequiredMethodResolverFunction="The primitive `1` has multiple methods by which it can be performed (ex. both Manually and on a WorkCell) but does not have a MethodResolverFunction set. A MethodResolverFunction is required in order to distinguish between the multiple methods that this primitive can be performed.";
DefinePrimitive::RequiredOutputUnitOperationParserFunction="The OutputUnitOperationParserFunction option is required to define a valid primitive for `1` if an ExperimentFunction or WorkCell is given. Please define a OutputUnitOperationParserFunction for your primitive.";
DefinePrimitive::MissingUnitOperationObject="The type Object[UnitOperation,`1`] was not found. All unit operation primitives that are defined must have a corresponding unit operation object. Please create your unit operation object before calling DefinePrimitive.";
DefinePrimitive::MissingUnitOperationFields="The type Object[UnitOperation, `1`] is missing the following fields `2` that were specified as non-hidden options to the unit operation primitive (via DefinePrimitive). Please either includes these as fields in the unit operation object or mark them as Hidden. (Hint: The first thing you should do is make sure these symbols are exported in \"Objects'\" via AddManifestSymbols[...].)";
DefinePrimitive::CannotSpecifyPreparatoryUnitOperations="The option(s) PreparatoryUnitOperations were specified as SharedOptions of the primitive `1`. These options cannot be used inside of primitives since they would cause an infinite loop. Please exclude them from your primitive.";

$NumberOfPrimitiveKeysToShow=3;

(* Ensure that reloading the package will re-initialize the primitive blobs dereferencing: *)
(* NOTE: We will lose the itai blob making but this should be pretty rare as no one should be reloading the Primitives` package. *)
OnLoad[
	If[KeyExistsQ[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]],
		OverloadSummaryHead/@Keys[Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]], Primitives]]
	];
];

DefinePrimitive[
	mySymbol_Symbol,
	myPrimitiveRules:(Alternatives[
		RuleDelayed[(RequiredSharedOptions|SharedOptions|Options),_List],
		Rule[(ExperimentFunction|OutputUnitOperationParserFunction|WorkCellResolverFunction|RoboticExporterFunction|RoboticParserFunction|MethodResolverFunction|GenerativeLabelOption), _Symbol],
		Rule[Category|Description, _String],
		Rule[Icon, _Image],
		Rule[Generative|FastTrack, True|False],
		Rule[LabeledOptions, {(_Symbol->_Symbol)..}],
		Rule[InputOptions|CompletedOptions|Methods|WorkCells, _Symbol|{_Symbol..}],
		Rule[Author, _String|{___String}]
		]..)
]:=Module[
	{listedPrimitiveRules, allowedKeys, invalidKeys, wasProtectedQ, cleanedDefinitions, requiredOptions, optionalOptions,
		allOptions, globalPatternString, globalPattern, unknownLabeledOptions, completedOptions,  allOptionsWithoutCompletedOptions,
		reverseCompatibilityOptions,nonHiddenOptions, unitOperationFieldStrings, missingUnitOperationFields, specifiedAuthor,
		specifiedExperimentFunction, defineUsageAuthors, experimentFunctionUsage, usageAuthor},

	(* Create a list version of the sequence of our primitive rules *)
	listedPrimitiveRules=List[myPrimitiveRules];

	(* Determine if any of the option rule keys are invalid (can't use a pattern since we haven't loaded that package) *)
	allowedKeys={FastTrack, RequiredSharedOptions, SharedOptions, Options, ExperimentFunction, Icon, Methods, WorkCells, WorkCellResolverFunction, RoboticExporterFunction, RoboticParserFunction, Category, Description, LabeledOptions, MethodResolverFunction, InputOptions, CompletedOptions, Generative, GenerativeLabelOption, OutputUnitOperationParserFunction, Author};
	invalidKeys=Cases[Keys[listedPrimitiveRules],Except[Alternatives@@allowedKeys]];

	If[!MatchQ[invalidKeys,{}],
		Message[DefinePrimitive::InvalidKey,mySymbol,invalidKeys];
		Return[$Failed]
	];

	(* Make sure that if we're given shared options, PreparatoryUnitOperations is not given because that will *)
	(* cause an infinite loop. *)
	If[MemberQ[
			{Lookup[listedPrimitiveRules, RequiredSharedOptions, Null],Lookup[listedPrimitiveRules, SharedOptions, Null],Lookup[listedPrimitiveRules, Options, Null]},
			{_,PreparatoryUnitOperations},
			Infinity
		],
		Message[DefinePrimitive::CannotSpecifyPreparatoryUnitOperations, mySymbol];
	];

	(* The OutputUnitOperationParserFunction key is required if ExperimentFunction/WorkCell is given. *)
	If[And[
			Or[
				!MatchQ[Lookup[listedPrimitiveRules, ExperimentFunction, Null], Null|None],
				!MatchQ[Lookup[listedPrimitiveRules, WorkCells, Null], Null]
			],
			MatchQ[Lookup[listedPrimitiveRules, OutputUnitOperationParserFunction, Null], Null],
			MatchQ[Lookup[listedPrimitiveRules, FastTrack, False], False]
		],
		Message[DefinePrimitive::RequiredOutputUnitOperationParserFunction, mySymbol];
	];

	(* The ExperimentFunction key and is required if not given a work cell. *)
	If[And[
			MatchQ[Lookup[listedPrimitiveRules, ExperimentFunction, Null], Null],
			MatchQ[Lookup[listedPrimitiveRules, WorkCells, Null], Null],
			MatchQ[Lookup[listedPrimitiveRules, FastTrack, False], False]
		],
		Message[DefinePrimitive::RequiredExperimentFunction, mySymbol];
		Return[$Failed];
	];

	(* The MethodResolver key is required if we have both a Manual version and a WorkCell. *)
	If[And[
			MatchQ[Lookup[listedPrimitiveRules, MethodResolverFunction, Null], Null],
			MatchQ[Lookup[listedPrimitiveRules, ExperimentFunction, Null], Except[Null]],
			MatchQ[Lookup[listedPrimitiveRules, WorkCell, Null], Except[Null]],
			MatchQ[Lookup[listedPrimitiveRules, FastTrack, False], False]
		],
		Message[DefinePrimitive::RequiredMethodResolverFunction, mySymbol];
		Return[$Failed];
	];

	(* Make sure that the options WorkCells and RoboticParserFunction/RoboticExporterFunction are specified together. *)
	If[And[
			MatchQ[
				Lookup[listedPrimitiveRules, {Key[WorkCells], Key[RoboticParserFunction], Key[RoboticExporterFunction]}, Null],
				_?(MemberQ[#, Null] && MemberQ[#, Except[Null]]&)
			],
			MatchQ[Lookup[listedPrimitiveRules, FastTrack, False], False]
		],
		Message[DefinePrimitive::WorkCellOptions, mySymbol];
		Return[$Failed];
	];

	(* Record whether the symbol was protected coming into defining of options *)
	wasProtectedQ=MemberQ[Attributes[mySymbol],Protected];

	(* Unprotect the symbol *)
	Unprotect[mySymbol];

	(* Get the cleaned definitions. *)
	(* Remove any options given that are not RequiredSharedOptions, SharedOptions, or Options. For example, we don't *)
	(* want to pass the ExperimentFunction key down to the optionDefinitions[...] helper. *)
	cleanedDefinitions=Options`Private`optionDefinitions[mySymbol,Sequence@@Cases[listedPrimitiveRules, Verbatim[RuleDelayed][(RequiredSharedOptions|SharedOptions|Options),_List]]];

	(* For some unknown reason, Image keeps getting back to protected after this call *)
	If[MatchQ[mySymbol,Image],Unprotect[mySymbol]];

	(* optionDefinitions does validation and will throw a message if returning $Failed. *)
	If[MatchQ[cleanedDefinitions, $Failed],
		If[wasProtectedQ,
			Protect[mySymbol]
		];

		Return[$Failed];
	];

	(* Get all of the required and non-required options. *)
	requiredOptions=(Lookup[#,"OptionSymbol"]&)/@Cases[cleanedDefinitions, KeyValuePattern["Required"->True]];
	completedOptions=Lookup[ToList[myPrimitiveRules], CompletedOptions, {}];
	optionalOptions=(Lookup[#,"OptionSymbol"]&)/@Cases[cleanedDefinitions, KeyValuePattern["Required"->Except[True]]];

	(* NOTE: SM used to support the Volume key and redirect it to Amount. We'll throw an error in SP, but at least show *)
	(* the key for really old primitives made by SM. *)
	reverseCompatibilityOptions=Switch[mySymbol,
		Transfer,
			{Volume},
		_,
			{}
	];

	(* Combine all of our keys, required options first, then optional options. Leave out the completed options since *)
	(* they aren't real options. *)
	allOptionsWithoutCompletedOptions=DeleteDuplicates[Flatten[{requiredOptions, optionalOptions}]];
	allOptions=DeleteDuplicates[Flatten[{requiredOptions, completedOptions, optionalOptions, reverseCompatibilityOptions}]];

	(* Make sure that we have a unit operation object. *)
	If[And[
			!MatchQ[Object[UnitOperation, mySymbol], TypeP[Object[UnitOperation]]],
			MatchQ[Lookup[listedPrimitiveRules, FastTrack, False], False]
		],
		Message[DefinePrimitive::MissingUnitOperationObject, mySymbol];
	];

	(* Get all option that are not hidden. These need to be fields in the Object[UnitOperation]. *)
	nonHiddenOptions=Lookup[Cases[cleanedDefinitions, KeyValuePattern["Category"->Except["Hidden"]]], "OptionSymbol"];

	(* Try to get the fields from the unit operation. *)
	unitOperationFieldStrings=If[!MatchQ[Object[UnitOperation, mySymbol], TypeP[Object[UnitOperation]]],
		{},
		Module[{splitFieldLookup, combinedFields, splitFields},
			(* Get the split field lookup. *)
			splitFieldLookup=Constellation`Private`getUnitOperationsSplitFieldsLookup[Object[UnitOperation, mySymbol]];

			(* Get the new combined fields and the split fields. *)
			combinedFields=Keys[splitFieldLookup];
			splitFields=Flatten[Values[splitFieldLookup]];

			ToString/@Join[
				combinedFields,
				Complement[Fields[Object[UnitOperation, mySymbol], Output->Short], splitFields]
			]
		]
	];

	(* NOTE: Make an exception for PreparatoryUnitOperations -- it should not be in the UOs. *)
	missingUnitOperationFields=Select[
		nonHiddenOptions,
		Function[{symbol},!MatchQ[symbol, PreparatoryUnitOperations] && !MemberQ[unitOperationFieldStrings, ToString[symbol]]]
	];

	(* Make sure that all of the non-hidden options exist has fields in the unit operation object. *)
	If[And[
			Length[missingUnitOperationFields] > 0,
			MatchQ[Lookup[listedPrimitiveRules, FastTrack, False], False]
		],
		Message[DefinePrimitive::MissingUnitOperationFields, mySymbol, missingUnitOperationFields];

		Return[$Failed];
	];

	(* Make sure that all options given to LabeledOptions are real options. *)
	unknownLabeledOptions=Cases[
		Complement[
			DeleteDuplicates[Flatten[{
				Lookup[listedPrimitiveRules, LabeledOptions, {}][[All,1]],
				Lookup[listedPrimitiveRules, LabeledOptions, {}][[All,2]]
			}]],
			allOptionsWithoutCompletedOptions
		],
		(* NOTE: It's okay to pass Null because some label options don't have a corresponding sample/container option *)
		(* like with FiltrateLabel or RetentateLabel since they're SamplesOut. *)
		Except[Null]
	];

	If[Length[unknownLabeledOptions]>0,
		Message[DefinePrimitive::UnknownLabeledOption, unknownLabeledOptions, mySymbol];
		Return[$Failed];
	];

	(* Automatically turn rules wrapped in this primitive head into an itai blob. *)
	mySymbol[rules___Rule]:=mySymbol[<|rules|>];

	(* Install the itai blob. *)
	(* NOTE: This will just overwrite the previous MakeBoxes definition if we've already defined a primitive for this head. *)
	With[{
		insertMe1=Lookup[listedPrimitiveRules, Icon, Null],
		insertMe2=allOptions,
		insertMe3=$NumberOfPrimitiveKeysToShow
		},
		mySymbol/:MakeBoxes[summary:mySymbol[assoc_Association],StandardForm]:=Quiet@BoxForm`ArrangeSummaryBox[
			mySymbol,
			summary,
			insertMe1,

			(* Only show the key in the itai blob if it isn't Null: *)

			(* Main itai blob: *)
			((
				If[MatchQ[Lookup[assoc,#,Null],ListableP[Null]|{}],
					Nothing,
					BoxForm`SummaryItem[{ToString[#]<>": ", If[MatchQ[Lookup[assoc,#,Null], _List?(Length[#]==1&)], Lookup[assoc,#,Null][[1]], Lookup[assoc,#,Null]]}]
				]
			&)/@Prepend[Take[insertMe2,UpTo[insertMe3]], Object]),

			(* Collapsed keys: *)
			If[Length[insertMe2]>insertMe3,
				((
					If[MatchQ[Lookup[assoc,#,Null],ListableP[Null]|{}],
						Nothing,
						BoxForm`SummaryItem[{ToString[#]<>": ", If[MatchQ[Lookup[assoc,#,Null], _List?(Length[#]==1&)], Lookup[assoc,#,Null][[1]], Lookup[assoc,#,Null]]}]
					]
				&)/@Quiet[insertMe2[[insertMe3+1;;-1]]]),
				{}
			],
			StandardForm
		]
	];

	(* Make sure that curried dereferencing works (ex. myPrimitive[Keys]). *)
	OverloadSummaryHead[mySymbol];

	(* Reprotect if the symbol was previously protected. *)
	If[wasProtectedQ,
		Protect[mySymbol]
	];

	(* Install the GLOBAL pattern for this primitive. *)
	(* NOTE: This global pattern has to support all types of this primitive (macro and micro) so we're using the joined *)
	(* requiredOptions here. *)
	globalPatternString="ECL`" <> SymbolName[mySymbol] <> "P";
	globalPattern=constructPrimitivePattern[
		mySymbol,
		requiredOptions,
		DeleteDuplicates[Flatten[{requiredOptions, completedOptions, optionalOptions}]],
		Lookup[listedPrimitiveRules, InputOptions, {}],
		(#[[1]]->#[[2]]&)/@Lookup[cleanedDefinitions, {Key["OptionSymbol"], Key["Pattern"]}]
	];

	(* Clear out any old definitions. *)
	With[{insertMe=globalPatternString},
		Clear[insertMe]
	];

	(* Install the new definition. Make sure that the required keys are provided. *)
	With[{insertMe=Symbol[globalPatternString], insertMe2=globalPattern},
		insertMe:=insertMe2;
	];

	(* determine the Authors of this unit operation that will go into the DefineUsage call *)
	(* if Author is specified, then go with that value *)
	(* otherwise, go with thomas *)
	specifiedAuthor = Lookup[listedPrimitiveRules, Author, {}];
	defineUsageAuthors = If[MatchQ[specifiedAuthor, _String|{__String}], ToList[specifiedAuthor],
		{"steven"}
	];

	(* Call DefineUsage on the primitive head for this primitive. *)
	With[{authors = defineUsageAuthors},
		DefineUsage[mySymbol,
			{
				BasicDefinitions -> {
					{
						Definition -> {ToString[mySymbol]<>"[options]","unitOperation"},
						Description -> Decapitalize[Lookup[listedPrimitiveRules, Description, Null]],
						Inputs :> {
							{
								InputName -> "options",
								Description-> "The options that specify the parameters of this unit operation.",
								Widget->Widget[
									Type -> Expression,
									Pattern :> {_Rule..},
									Size -> Line
								],
								Expandable->False
							}
						},
						Outputs:>{
							{
								OutputName -> "unitOperation",
								Description -> "The unit operation that is to be used in sample/cell preparation.",
								Pattern :> _List
							}
						}
					}
				},
				SeeAlso -> {
					"ExperimentSamplePreparation",
					"ExperimentCellPreparation",
					"Experiment"
				},
				Author -> authors
			}
		]
	];

	(* Call DefineOptions on the primitive head for this primitive. *)
	(* NOTE: Don't do this for system symbols since DefineOptions doesn't work on system symbols. This is the case for some *)
	(* SciComp image processing unit operations. *)
	If[!MatchQ[Context[mySymbol], "System`"],
		DefineOptions[mySymbol,
			Sequence@@(Cases[listedPrimitiveRules, Verbatim[RuleDelayed][(RequiredSharedOptions|SharedOptions|Options),_List]]/.{RequiredSharedOptions->SharedOptions})
		];
	];

	(* NOTE: This will just overwrite any existing patterns if we're calling DefinePrimitive multiple times. Since we're *)
	(* using the global key lookups this is fine. *)

	(* Return an association with the information that we need to pass into DefinePrimitiveSet. *)
	<|
		PrimitiveHead->mySymbol,
		Pattern->globalPattern,
		OptionDefinition->cleanedDefinitions,
		ExperimentFunction->Lookup[listedPrimitiveRules, ExperimentFunction, Null],
		Description->Lookup[listedPrimitiveRules, Description, Null],
		Category->Lookup[listedPrimitiveRules, Category, "General"],
		Icon->Lookup[listedPrimitiveRules, Icon, Null],
		Methods->Lookup[listedPrimitiveRules, Methods, {}],
		WorkCells->Lookup[listedPrimitiveRules, WorkCells, {}],
		WorkCellResolverFunction->Lookup[listedPrimitiveRules, WorkCellResolverFunction, Null],
		RoboticExporterFunction -> Lookup[listedPrimitiveRules, RoboticExporterFunction, Null],
		RoboticParserFunction -> Lookup[listedPrimitiveRules, RoboticParserFunction, Null],
		MethodResolverFunction->Lookup[listedPrimitiveRules, MethodResolverFunction, Null],
		LabeledOptions->Lookup[listedPrimitiveRules, LabeledOptions, {}],
		InputOptions->Lookup[listedPrimitiveRules, InputOptions, {}],
		CompletedOptions->Lookup[listedPrimitiveRules, CompletedOptions, {}],
		Generative->Lookup[listedPrimitiveRules, Generative, False],
		GenerativeLabelOption->Lookup[listedPrimitiveRules, GenerativeLabelOption, Null],
		OutputUnitOperationParserFunction->Lookup[listedPrimitiveRules, OutputUnitOperationParserFunction, Null]
	|>
];
