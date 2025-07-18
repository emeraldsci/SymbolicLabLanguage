(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Option Setting*)


(* ::Subsubsection::Closed:: *)
(*DefineOptionSet*)


DefineOptionSet[RuleDelayed[setName_Symbol,optionsList:{(_List|_Symbol|_IndexMatching|_)...}]]:=With[
	{
		optionsRule = RuleDelayed[
			Options,
			optionsList
		]
	},

	DefineOptions[
		setName,
		optionsRule
	]
];


(* ::Subsubsection::Closed:: *)
(*DefineOptions*)


DefineOptions::InvalidKey="`2` are not valid keys for DefineOptions. You may only use Options or SharedOptions.";
DefineOptions::SystemSymbol="Cannot define options for Mathematica symbol `1`.";
DefineOptions::Format="Unable to define options for `1`. Invalid options format.";
DefineOptions::Duplicate="Unable to define options for `1`. Multiple options defined with the same names: `2`.";
DefineOptions::MissingOptions="Failure to copy options from `2` to `3`. Make sure `1` exist as options for `2` when defining options for `3`.";
DefineOptions::NoOptions="Failure to copy options from `1` to `2`. No options found for `1` when defining options for `2`.";
DefineOptions::BadPattern="Options for `1` marked as IndexMatching, or to which other options IndexMatch, must use a single call to ListableP to define their pattern. Check `2`";

(* Helper function to convert a Held pattern into a string. (Ex. Hold[GreaterP[0*Kilogram*Meter/Second^2]] \[Rule] "GreaterP[0*Kilogram*Meter/Second^2]" *)
(* Input: Held pattern *)
(* Output: String of the inputted held pattern *)

SetAttributes[SequenceForm,HoldFirst];
SetAttributes[heldPatternToString,HoldFirst];

heldPatternToString[myPattern_]:=ToString[myPattern/.{Hold->SequenceForm},InputForm];

Options[LazyLoading] = {
	Exclude->{},
	UpValueTriggers -> False,
	DownValueTrigger -> False,
	OwnValueTrigger -> False
};

(* so things don't evaluate when we try to look them up *)
SetAttributes[holdingFunction,HoldFirst];

(* this is where we stash the unevaluated Define___ calls *)
(* default to no held calls.  we append to this list as we hold *)
holdingFunction[symbol_]:=<||>;

LazyLoading[
	flag:True,
	functionBeingDelayed_Symbol,
	OptionsPattern[]
]:=With[{
		upValueTriggers = OptionValue[UpValueTriggers],
		downValueTrigger = OptionValue[DownValueTrigger],
		ownValueTrigger = OptionValue[OwnValueTrigger]
	},


	Module[{
	(* this temporariliy blocks the delaying function when we're ready to release *)
		evaluationBlocker=Symbol["$block"<>SymbolName[functionBeingDelayed]],
		(* this is a thing to grab onto when clearing the UpValues *)
		definitionTag = Symbol["tag"<>SymbolName[functionBeingDelayed]]
		},
	(* make sure the thing being delayed holds its args *)
	SetAttributes[functionBeingDelayed, HoldRest];
	(* always True, because we don't want to delay the evaluation, just grab onto this *)
	definitionTag=True;
	evaluationBlocker=True;
	If[$VerboseLazyLoading,Print["DELAYING ",SymbolName[functionBeingDelayed]];];
	(*  *)
	functionBeingDelayed[f_Symbol, rest___] /; evaluationBlocker := With[
		{wasProtected=MemberQ[Attributes[f],Protected]},
			(* Print["delay ",Hold[f]," for ",functionBeingDelayed]; *)
			(* if this function is in the exclude list, don't delay it *)
			If[MemberQ[OptionValue[Exclude],f],
				Block[{evaluationBlocker=False},
					Return[functionBeingDelayed[f, rest]]
				];
			];
			(* stash the call for later *)
				holdingFunction[f] = Append[
					holdingFunction[f],
					functionBeingDelayed -> HoldComplete[With[{restEval=rest},functionBeingDelayed[f, restEval]]]
				];
			If[wasProtected,Unprotect[f]];
			If[MatchQ[upValueTriggers,{_Symbol..}],
			(* If[$VerboseLazyLoading,Print["UpValue triggers on ",SymbolName[functionBeingDelayed]];]; *)
			(* set an UpValue on the function whose thing is being defined for each releasing function *)
			Map[
				f /: #[f,args___] /; definitionTag := Module[{},
					If[wasProtected,Unprotect[f]];
					If[$VerboseLazyLoading,
						Print["releasing ",SymbolName[functionBeingDelayed],"[",SymbolName[f],"], triggered by ",#," in ",Packager`Private`packageFile," in ",Packager`Private`packagePackage];
					];
					(* is there a cleaner way to clear these upvalues? *)
					UpValues[f] = Select[UpValues[f], Function[def, !StringContainsQ[ToString[def], SymbolName[Unevaluated[definitionTag]]]]];
					If[wasProtected,Protect[f]];
					(* release the held Define___ call *)
					Block[{evaluationBlocker=False},
						ReleaseHold[holdingFunction[f][functionBeingDelayed]];
					];
					(* now run the thing that triggered the release and return that *)
					#[f,args]
				];&,
				upValueTriggers
			];
			];
			If[downValueTrigger,
			(* If[$VerboseLazyLoading,Print["DownValue trigger on ",Hold[f]];]; *)
			f[args___] /; definitionTag := Module[{},
				If[wasProtected,Unprotect[f]];
				If[$VerboseLazyLoading,
					Print["releasing ",SymbolName[functionBeingDelayed],"[",SymbolName[f],"], triggered by ",f,"[___]"];
				];
				(* is there a cleaner way to clear these upvalues? *)
				DownValues[f] = Select[DownValues[f], Function[def, !StringContainsQ[ToString[def], SymbolName[Unevaluated[definitionTag]]]]];
				If[wasProtected,Protect[f]];
				(* release the held Define___ call *)
				Block[{evaluationBlocker=False},
					ReleaseHold[holdingFunction[f][functionBeingDelayed]];
				];
				(* now run the thing that triggered the release and return that *)
				f[args]
			];
			];
			If[ownValueTrigger,
			(* If[$VerboseLazyLoading,Print["OwnValue trigger on ",Hold[f]];]; *)
			f := Module[{},
				If[wasProtected,Unprotect[f]];
				If[$VerboseLazyLoading,
					Print["releasing ",SymbolName[functionBeingDelayed],"[",Hold[f],"], triggered by ",Hold[f]];
				];
				(* is there a cleaner way to clear these upvalues? *)
				f =. ;
				If[wasProtected,Protect[f]];
				(* release the held Define___ call *)
				Block[{evaluationBlocker=False},
					ReleaseHold[holdingFunction[f][functionBeingDelayed]];
				];
				(* now run the thing that triggered the release and return that *)
				f
			];
			];

			If[wasProtected,Protect[f]];
	 	]
	]
];


LazyLoading[flag:False,___]:=Null;
LazyLoading[flag_,rest___]:=LazyLoading[$LazyLoading,rest];

$VerboseLazyLoading=TrueQ[$VerboseLazyLoading];
$LazyLoading=TrueQ[$LazyLoading];

LazyLoading[
	$DelayOptions,
	DefineOptions,
	UpValueTriggers->{ECL`OptionsHandling`SafeOptions,ECL`OptionsHandling`ValidOptions,OptionDefaults,OptionDefinition,Options,OptionValue},
	Exclude->{OptionDefaults,Test,Example,Tests,Examples}
];

DefineOptions[mySymbol_Symbol,myOptionRules0:(RuleDelayed[_Symbol,_List]..)]:=Module[
	{optionRuleList, invalidKeys, wasProtectedQ, cleanedDefinitions,myOptionRules},

	(* let this evaluate *)
	myOptionRules = myOptionRules0;

	(* Create a list version of the sequence of options rules *)
	optionRuleList=List[myOptionRules];

	(* Determine if any of the option rule keys are invalid (can't use a pattern since we haven't loaded that package) *)
	invalidKeys=Cases[Keys[optionRuleList],Except[Options|SharedOptions]];
	If[!MatchQ[invalidKeys,{}],
		Message[DefineOptions::InvalidKey,mySymbol,invalidKeys];
		Return[$Failed]
	];

	(* Do not allow definition of options for a system symbol *)
	If[Context[mySymbol]==="System`",
		Message[DefineOptions::SystemSymbol,mySymbol];
		Return[$Failed]
	];

	(* Record whether the symbol was protected coming into defining of options *)
	wasProtectedQ=MemberQ[Attributes[mySymbol],Protected];

	(* Unprotect the symbol *)
	Unprotect[mySymbol];

	(* Get the cleaned definitions. *)
	cleanedDefinitions=optionDefinitions[mySymbol,myOptionRules];

	(* optionDefinitions does validation and will throw a message if returning $Failed. *)
	If[MatchQ[cleanedDefinitions, $Failed],
		If[wasProtectedQ,
			Protect[mySymbol]
		];

		Return[$Failed];
	];

	(* set the option definition of the symbol *)
	mySymbol/:OptionDefinition[mySymbol]=cleanedDefinitions;
	Options[mySymbol]=OptionDefaults[mySymbol];

	(* re-protect the symbol if it came in protected, and return Null *)
	If[wasProtectedQ,
		Protect[mySymbol]
	];
];

(* ::Subsubsection::Closed:: *)
(*Helper Functions*)

(* Core function that actually cleans and validates the option definitions. *)
(* DefinePrimitive and DefineOptions both call this function in order to get the option definitions in a standard *)
(* format that is stashed as an UpValue -- but how they get stashed is different per each function. *)
optionDefinitions[mySymbol_Symbol,myOptionRules:(RuleDelayed[_Symbol,_List]..)]:=Module[
	{optionRuleList,invalidKeys,wasProtectedQ,definitionsLists,flatOptionDefinitions,
		explicitOptionNames,duplicateOptionNames,explictOverrideOptionDefinitions,
		optionSetOptionNames,optionSetOverrideOptionDefinitions,duplicateFreeOptionDefinitions,cleanedDefinitions,
		indexMatchingDefinitions,indexMatchingTargets,targetDefinitions,allIndexDefinitionsToCheck,
		allIndexMatchingPatterns,allIndexMatchingOptionNames,indexMatchingPatterns,indexMatchingOptionNames,badPatternOptions
	},

	(* Create a list version of the sequence of options rules *)
	optionRuleList=List[myOptionRules];

	(* Define the options within each of the option rule lists *)
	definitionsLists=toOptionDefinitions[mySymbol,#,optionRuleList]&/@optionRuleList;

	(* pass a failure if we couldn't define options for any of the option rule symbols *)
	If[MemberQ[definitionsLists,$Failed],
		Message[DefineOptions::Format,mySymbol];
		Return[$Failed];
	];

	(* flatten the definitions from each of the option types *)
	flatOptionDefinitions=Flatten[definitionsLists,1];

	(* pull out the explicitly-provided options (i.e. not shared) *)
	explicitOptionNames=Select[flatOptionDefinitions,Lookup[#,"OptionSource"]==="Explicit"&][[All,"OptionName"]];

	(* return any duplicated option names that were explicitly provided *)
	duplicateOptionNames=Select[Tally[explicitOptionNames],Last[#]>1&][[All,1]];

	(* do not allow specification of duplicate option names *)
	If[MatchQ[duplicateOptionNames,{_String..}],
		Message[DefineOptions::Duplicate,mySymbol,duplicateOptionNames];
		Return[$Failed]
	];

	(*Drop all shared options, option set options which are overridden by explicitly defined options for this symbol*)
	explictOverrideOptionDefinitions=Select[
		flatOptionDefinitions,
		Or[
			MatchQ[Lookup[#,"OptionSource"],"Explicit"],
			!MemberQ[explicitOptionNames,Lookup[#,"OptionName"]]
		]&
	];

	(* get the name of all the options coming from option sets *)
	optionSetOptionNames=Select[flatOptionDefinitions,Lookup[#,"OptionSource"]==="OptionSet"&][[All,"OptionName"]];

	(* Remove any shared options which overlap with an option coming from an option set *)
	optionSetOverrideOptionDefinitions=DeleteCases[explictOverrideOptionDefinitions, _?(And[
		MatchQ[#["OptionName"],Alternatives@@optionSetOptionNames],
		MatchQ[#[OptionSource],"SharedOptions"]
	]&)];

	(* Remove any remaining duplicates - this should only happen if multiple option sets have some of the same options or if multiple of the shared option functions have some of the same option(s) *)
	duplicateFreeOptionDefinitions=DeleteDuplicatesBy[optionSetOverrideOptionDefinitions,#["OptionName"]&];

	(* Get all the explicit options *)
	(* DeleteDuplicates that appear twice in an option set *)
	(* Remove any duplicate shared options (if any of the shared symbols provide the same option) *)

	(* eliminate the OptionSource key, after tying the option to the appropriate symbol that we are now defining the option set for *)
	cleanedDefinitions=Map[
		KeyDrop[
			If[MatchQ[#["OptionSource"],"OptionSet"],
				Append[#,"Symbol"->mySymbol],
				#
			],
			"OptionSource"
		]&,
		duplicateFreeOptionDefinitions
	];

	(* verify index-matching options use a single call to ListableP to define their pattern *)
	(* this allows downstream code to determine if a singleton value was provided since it will match x if the pattern is ListableP[x] *)
	(* We only verify index-matching options on legacy formatted options because the pattern is automatically built from the Widget in our current version. *)
	indexMatchingDefinitions=Select[cleanedDefinitions, (#["IndexMatching"]!="None"&&!KeyExistsQ[#,"Widget"]&)];
	indexMatchingTargets=DeleteDuplicates[Lookup[indexMatchingDefinitions,"IndexMatching",{}]];
	targetDefinitions=Select[cleanedDefinitions, MemberQ[indexMatchingTargets,#["OptionName"]]&];
	allIndexDefinitionsToCheck=Join[indexMatchingDefinitions,targetDefinitions];

	allIndexMatchingPatterns=Lookup[allIndexDefinitionsToCheck,"Pattern",{}];
	allIndexMatchingOptionNames=Lookup[allIndexDefinitionsToCheck,"OptionName",{}];
	badPatternOptions=MapThread[

		(* Manually check that the pattern is specified as a ListableP. *)
		If[MatchQ[#1,Hold[ListableP[x___]]],
			Nothing,
			#2
		]&,
		{allIndexMatchingPatterns,allIndexMatchingOptionNames}
	];

	(* Return $Failed if patterns are invalid *)
	If[!MatchQ[badPatternOptions,{}],
		Message[DefineOptions::BadPattern,mySymbol,badPatternOptions];
		Return[$Failed]
	];

	(* Return the cleaned definitions if everything went fine. *)
	cleanedDefinitions
];

(* Helper function to convert each type of option list into option definition association *)
(* NOTE: myAllOptionRules is basically {Options:>{...}, SharedOptions:>{...}} etc. This is because we need to know ALL of the options in *)
(* order to construct the IndexMatchingOptions key since we can have multiple IndexMatching[...] blocks across different Options:>{...} sets. *)
toOptionDefinitions[mySymbol_Symbol,myOptionRule:RuleDelayed[myOptionType:(Options|SharedOptions|RequiredSharedOptions),myOptionList_List],myAllOptionRules_List]:=Module[
	{heldOptionLists,heldAllOptionLists,parsedDefinitions,definitions},

	(* convert the delayed rule setting the options for this option type to held lists *)
	heldOptionLists=If[MatchQ[Hold[myOptionList],Hold[{}]],
		{},
		ReleaseHold[MapAt[
			Hold,
			Extract[myOptionRule,{2},Hold],
			{1,All}
		]]
	];

	(* Hold all of our entire option list. *)
	(* NOTE: This is basically what we're doing above, but for out entire options list. *)
	heldAllOptionLists=(Sequence@@If[MatchQ[#,{}|(_Symbol:>{})],
		{},
		ReleaseHold[MapAt[
			Hold,
			Extract[#,{2},Hold],
			{1,All}
		]]
	]&)/@myAllOptionRules;

	(* First parse all of the definitions. *)
	parsedDefinitions=Map[
		Function[heldOptionList,
				(* define each of the options, using a helper that will handle the many different cases *)
				{heldOptionList,{defineOption[mySymbol,heldOptionList,heldAllOptionLists]}}
		],
		heldOptionLists
	];

	(* Add additional information to our parsed definitions. *)
	definitions=Map[
		Function[{optionsBlob},
			Module[{heldOptionList,optionDefinitions},
				(* Pull out the options list and the options definition from the {heldOptionList,optionDefinitions} blob. *)
				{heldOptionList,optionDefinitions}=optionsBlob;

				(* For each of the option definition packets in optionDefinitions, add additional information to each packet. Return the resulting list as a sequence. *)
				Sequence@@Function[{optionDefinition},
					(* add additional information regarding the source of the option *)
					Which[
						MemberQ[optionDefinition,$Failed],
							$Failed,
						And[
							MatchQ[heldOptionList,Hold[_Symbol]],
							MatchQ[myOptionType,Options]
						],
							Append[#,"OptionSource"->"OptionSet"]&/@optionDefinition,
						MatchQ[myOptionType,SharedOptions],
							Append[#,"OptionSource"->"SharedOptions"]&/@optionDefinition,
						(* NOTE: Force "Required"->True if the option was given under the RequiredSharedOptions:> key. *)
						MatchQ[myOptionType,RequiredSharedOptions],
							Append[#,<|"OptionSource"->"SharedOptions", "Required"->True|>]&/@optionDefinition,
						True,
							Append[#,"OptionSource"->"Explicit"]&/@optionDefinition
					]
				]/@optionDefinitions
			]
		],
		parsedDefinitions
	];

	(* return a single failure if we encountered an issue defining any of the options in this option type *)
	If[MemberQ[definitions,$Failed],
		$Failed,
		Apply[Join,definitions]
	]
];


(* ::Subsubsection::Closed:: *)
(*defineOptions Command Builder (New) Helpers*)


(* ::Subsubsubsection::Closed:: *)
(*IndexMatching Block*)


DefineOptions::XorIndexMatchingInputAndParent="Exactly one of IndexMatchingInput and IndexMatchingParent must be set for each IndexMatching block in the options. Please include only one of these keys in order to define a valid index matching options block.";

(* Convert an IndexMatching[...] block into the correct format for them to be stashed on the backend. *)
(* Note: The third input (allOptions) is only used for this overload to figure out the other index matching blocks that are present in the DefineOptions call. *)
(* There could be more than 1 index matching block that point at the same parent and we need to link all of the index matching options together correctly. *)
(* The third input is passed into the other function signatures so that overloading works. *)
defineOption[mySymbol_Symbol,Hold[IndexMatching[myOptionsSequence___]],allOptions_List]:=Module[
	{indexMatchingInputAssociation,myOptionsList,indexMatchingInputList,indexMatchingInput,indexMatchingParent,optionPacketsList,
	correspondingIndexMatchingBlocks,indexMatchingOptions,optionName,optionPacketsWithMoreInformation,
	formattedOptionsPackets},

	(* IMPORTANT: *)
	(* In order to use Widgets with DefineOptions in yourPackage, you must set Widgets` as a dependency of yourPackage. *)
	(* This is because we cannot set Widgets` as a dependency of Options` since (Widgets->Units->Options->Widgets). *)

	(* Make sure that the Widget module is loaded by checking the DownValues of Widget. (This is set in Widgets`.) *)
	If[Length[DownValues[Widget]]==0,
		Return[$Failed];
	];

	(* Covert myOptionsSequence into a List. *)
	myOptionsList=List[myOptionsSequence];

	(* Remove anything that is not a rule from myOptionsList. We are trying to extract the IndexMatchingInput key. *)
	indexMatchingInputList=(If[MatchQ[#,_Rule],
		#,
		Nothing
	]&)/@myOptionsList;

	(* Now we have a list of rules. Convert this to an association. *)
	indexMatchingInputAssociation=Association[indexMatchingInputList];

	(* Pull out the IndexMatchingInput key from the Association. Default it to null if there is no IndexMatchingInput. *)
	indexMatchingInput=Lookup[indexMatchingInputAssociation,Key[IndexMatchingInput],Null];

	(* Pull out the IndexMatchingParent key from the Association. Default it to null if there is no IndexMatchingParent. *)
	indexMatchingParent=Lookup[indexMatchingInputAssociation,Key[IndexMatchingParent],Null];

	(* Only one of indexMatchingInput and indexMatchingParent can be Null. *)
	If[!Xor[NullQ[indexMatchingInput],NullQ[indexMatchingParent]],
		Message[DefineOptions::XorIndexMatchingInputAndParent];
		Return[$Failed];
	];

	(* Remove the IndexMatchingInput\[Rule]_String rule from the input List. This is because we only want to recurse on the option packets. *)
	optionPacketsList=(Which[
		MatchQ[#,Verbatim[Rule][IndexMatchingInput|IndexMatchingParent, _]],
			Nothing,
		MatchQ[#, KeyValuePattern[OptionName->_]],
			#,
		(* NOTE: Use an existing option to initialize our new option -- also rename it. *)
		(* NOTE: Using this overload, we should only get one result back from defineOption[...]. *)
		MatchQ[#, {_Symbol,_Symbol}->_Symbol],
			With[{newOptionName=#[[2]]},
				Sequence@@(
					({
						OptionName->newOptionName, (* We were told to overwrite the name here. *)
						Default->ReleaseHold[Lookup[#, "Default"]],
						Description->Lookup[#, "Description"],
						AllowNull->Lookup[#, "AllowNull"],
						ResolutionDescription->Lookup[#, "ResolutionDescription"],
						Widget->Lookup[#, "Widget"],
						PatternTooltip->Lookup[#, "PatternTooltip"],
						NestedIndexMatching->Lookup[#, "NestedIndexMatching"],
						Expandable->Lookup[#, "Expandable"],
						Category->Lookup[#, "Category"]
					}&)/@With[{insertMe=#},defineOption[mySymbol, Hold[insertMe], allOptions]]
				)
			],
		(* NOTE: Use an existing option to initialize our new option. *)
		MatchQ[#, Alternatives[_Symbol, {_Symbol|Hold[_Symbol],({_Symbol..}|_Symbol)}]],
			Sequence@@(
				({
					OptionName->Lookup[#, "OptionSymbol"],
					Default->ReleaseHold[Lookup[#, "Default"]],
					Description->Lookup[#, "Description"],
					AllowNull->Lookup[#, "AllowNull"],
					ResolutionDescription->Lookup[#, "ResolutionDescription"],
					Widget->Lookup[#, "Widget"],
					PatternTooltip->Lookup[#, "PatternTooltip"],
					NestedIndexMatching->Lookup[#, "NestedIndexMatching"],
					Expandable->Lookup[#, "Expandable"],
					Category->Lookup[#, "Category"]
				}&)/@With[{insertMe=#},defineOption[mySymbol, Hold[insertMe], allOptions]]
			),
		True,
			Nothing
	]&)/@myOptionsList;

	(* Make sure that the OptionName key exists in the first options packet. *)
	If[!KeyExistsQ[Association@@(optionPacketsList[[1]]),OptionName],
		Message[DefineOptions::MissingRequiredKeys,"OptionName",ToString[optionPacketsList[[1]]]]; Return[$Failed];
	];

	(* Depending on whether IndexMatchingInput or IndexMatchingParent is set for this current IndexMatching block, get all corresponding blocks with that same key set. *)
	correspondingIndexMatchingBlocks=If[MatchQ[indexMatchingInput,Null],
		Cases[allOptions,With[{insertMe=indexMatchingParent},Hold[IndexMatching[___,IndexMatchingParent->insertMe,___]]]],
		Cases[allOptions,With[{insertMe=indexMatchingInput},Hold[IndexMatching[___,IndexMatchingInput->insertMe,___]]]]
	];

	(* Once we have all the corresponding blocks (which also includes our own block, get all of the option names in the block to get the IndexMatchingOptions. *)
	(* Note: We have to drop the IndexMatchingParent|IndexMatchingInput from our list before doing a lookup. *)
	(* Note: This Cases[...] is at level 4 because we don't want to go too deep and accidentally look into a pattern or widget and get nonsense. *)
	(* This is level {4} because the deepest we can go is Hold[IndexMatching[{OptionName->_}]]. *)
	indexMatchingOptions=DeleteDuplicates@Cases[correspondingIndexMatchingBlocks,((OptionName->x_)|(Verbatim[Rule][{_Symbol, _Symbol}, x_Symbol])|IndexMatching[___, {_Symbol, x_Symbol}, ___]):>x, 4];

	(* Figure out the OptionName of the first options packet. *)
	optionName=ECL`FirstOrDefault[indexMatchingOptions];

	(* Stash the IndexMatching\[Rule]FirstOptionName and IndexMatchingInput\[Rule]_String rules in each of the options packets. *)
	optionPacketsWithMoreInformation=(
		Join[#,{IndexMatching->optionName,IndexMatchingInput->indexMatchingInput,IndexMatchingOptions->indexMatchingOptions,IndexMatchingParent->indexMatchingParent}]
	&)/@optionPacketsList;

	(* Now resolve each of out options packets into their correct format in order to be stashed on the backend. *)
	(* The defineOption function expects our packet to be inside a hold, use a With[...] to get it inside said Hold. *)
	formattedOptionsPackets=(With[{insertMe=#},defineOption[mySymbol,Hold[insertMe],allOptions]]&)/@optionPacketsWithMoreInformation;

	(* Check for $Failed. This would occur if one of our option packets inside of the IndexMatching[...] block was malformed. *)
	If[MemberQ[formattedOptionsPackets,$Failed],
		Return[$Failed];
	];

	(* Now convert our resolved packets into a sequence. This is because this function is called within defineOptions itself and we don't want to return a nested list. *)
	Sequence@@formattedOptionsPackets
];


(* ::Subsubsubsection::Closed:: *)
(*Singleton Options Packet*)


DefineOptions::InvalidKeys="The following keys were used in an list of rules to define an option and are invalid `1`. Only {OptionName,Default,AllowNull,Description,ResolutionDescription,Category,IndexMatchingInput,IndexMatching,Expandable,Pattern,SingletonPattern,Widget,Pooled,NestedIndexMatching} are valid keys. Please remove these invalid keys.";
DefineOptions::MissingRequiredKeys="The following keys, `1`, are required to define an option but are missing. Please include these required keys in the options definition `2`.";
DefineOptions::OptionNamePattern="OptionName's value `1` must match _Symbol. Please change OptionName's value.";
DefineOptions::AllowNullPattern="AllowNull's value `1` must match BooleanP. Please change AllowNull's value.";
DefineOptions::DescriptionPattern="Description's value `1` must match _String. Please change Description's value.";
DefineOptions::PooledPattern="Pooled's value `1` must match BooleanP. Please change Pooled's value.";
DefineOptions::CategoryPattern="Category's value `1` must match _String. Please change Category's value.";
DefineOptions::PatternXorWidget="One and only one of the keys {Pattern, Widget} can be used to define an option. Please add/remove these keys to satisfy ";
DefineOptions::InvalidWidget="A widget `1` was specified that does not match WidgetP. Please reformat this widget so that it is valid.";
DefineOptions::UnableToFindPrimitiveHead="Unable to find option information about the primitive, `1`, from the primitive set, `2`. Please make sure that DefinePrimitiveSet[...] was called on this primitive set.";

(* Convert a command builder format (new) format of options into an association to stash on the backend. *)
defineOption[mySymbol_Symbol,Hold[myOptionsList:List[(_Rule|_RuleDelayed)..]],allOptions_List]:=Module[
	{myAssociation,validKeys,invalidKeys,requiredKeys,missingRequiredKeys,optionPattern,
	widget,specifiedTooltip,patternTooltip},

	(* IMPORTANT: *)
	(* In order to use Widgets with DefineOptions in yourPackage, you must set Widgets` as a dependency of yourPackage. *)
	(* This is because we cannot set Widgets` as a dependency of Options` since (Widgets->Units->Options->Widgets). *)

	(* Make sure that the Widget module is loaded by checking the DownValues of Widget. (This is set in Widgets`.) *)
	If[Length[DownValues[Widget]]==0,
		Return[$Failed];
	];

	(* Convert the options list into an association. *)
	myAssociation=Association[myOptionsList];

	(* Define a list of valid keys that can exist in this options list. *)
	validKeys={OptionName,Default,AllowNull,Description,ResolutionDescription,Category,IndexMatchingInput,IndexMatchingParent,IndexMatchingOptions,IndexMatching,Expandable,Pattern,PatternTooltip,SingletonPattern,Widget,Pooled,Required,UnitOperation,NestedIndexMatching,HideNull};

	(* Get the set difference between the valid keys and the keys in the given options list. This gives us the invalid keys in the association. *)
	invalidKeys=Complement[Keys[myAssociation],validKeys];

	(* If there are invalid keys, return $Failed. *)
	If[Length[invalidKeys]!=0,
		Message[DefineOptions::InvalidKeys,invalidKeys]; Return[$Failed];
	];

	(* Check that the required keys are provided. *)
	requiredKeys={OptionName,Default,AllowNull,Description};

	(* Get the missing required keys. *)
	missingRequiredKeys=Complement[requiredKeys,Keys[myAssociation]];

	(* If there are missing keys that are required, return $Failed. *)
	If[Length[missingRequiredKeys]!=0,
		Message[DefineOptions::MissingRequiredKeys,missingRequiredKeys,myOptionsList]; Return[$Failed];
	];

	(* Check that OptionName matches _Symbol. *)
	If[!MatchQ[myAssociation[OptionName],_Symbol],
		Message[DefineOptions::OptionNamePattern,ToString[myAssociation[OptionName]]]; Return[$Failed];
	];

	(* Check that AllowNull matches BooleanP (we can't use Patterns b/c we can't load that package). *)
	If[!MatchQ[myAssociation[AllowNull],True|False],
		Message[DefineOptions::AllowNullPattern,ToString[myAssociation[AllowNull]]]; Return[$Failed];
	];

	(* Check that Description matches _String. *)
	If[!MatchQ[myAssociation[Description],_String],
		Message[DefineOptions::DescriptionPattern,ToString[myAssociation[Description]]]; Return[$Failed];
	];

	(* Check that Category, if specified, matches _Symbol. *)
	If[KeyExistsQ[myAssociation,Category]&&!MatchQ[myAssociation[Category],_String],
		Message[DefineOptions::CategoryPattern,ToString[myAssociation[Category]]]; Return[$Failed];
	];

	(* Check that one and only one of the keys {Pattern, Widget} is specified (XOR). *)
	If[!Xor[KeyExistsQ[myAssociation,Pattern],KeyExistsQ[myAssociation,Widget]],
		Message[DefineOptions::PatternXorWidget]; Return[$Failed];
	];

	(* NOTE: We don't call ValidWidgetQ here because it really doesn't do any additional checks that Widget[...] doesn't. *)
	If[KeyExistsQ[myAssociation,Widget]&&!MatchQ[Lookup[myAssociation, Widget], ECL`WidgetP],
		Message[DefineOptions::InvalidWidget,ToString[myAssociation[Widget]]]; Return[$Failed];
	];

	(* Compute the pattern of this option. *)
	optionPattern=If[KeyExistsQ[myAssociation,Pattern],
		(* If the Pattern key exists, use that: *)
		<|
			Pattern:>With[{insertMe=myAssociation[Pattern]},Hold[insertMe]],
			SingletonPattern:>With[{insertMe=myAssociation[SingletonPattern]},Hold[insertMe]],
			PooledPattern:>With[{insertMe=myAssociation[PooledPattern]},Hold[insertMe]]
		|>,

		(* If the Pattern key doesn't exist, compute the pattern from the Widget. *)
		GenerateInputPattern[myOptionsList]
	];

	(* Pull out the widget and perform the necessary surgery on it (change the PatternTooltip if it's an AtomicWidgetP and add Null if it's AllowNull\[Rule]true) *)
	widget=Module[{widgetLookup},
		(* Lookup the widget *)
		widgetLookup=Lookup[myAssociation,Key[Widget],Null];

		(* Check to see if the Widget is Null. *)
		If[!SameQ[widgetLookup,Null],
			Module[{modifiedWidget, modifiedWidgetWithNull},
				(* The widget is not Null. *)

				(* Modify the PatternTooltip if it is an AtomicWidgetP. AtomicWidgetP is guarenteed to have a PatternTooltip key. *)
				modifiedWidget=If[MatchQ[widgetLookup,AtomicWidgetP],
					Module[{newPatternTooltip},
						(* Swap the first word of the PatternTooltip string for the name of this option. *)
						newPatternTooltip=ToString[myAssociation[OptionName]]<>" "<>First@StringCases[widgetLookup[PatternTooltip],StartOfString~~x:(Except[" "]..)~~" "~~y___:>y];

						(* Replace the PatternTooltip. *)
						Widget[Append[widgetLookup[[1]],PatternTooltip->newPatternTooltip]]
					],
					(* Otherwise, don't modify the widget. *)
					widgetLookup
				];

				(* If the developer set AllowNull -> True and Null doesn't match the specified widget pattern, add it for them. *)
				(* NOTE: We have to regenerate the widget pattern here because we already added the default to the Pattern in Widgets.m *)
				modifiedWidgetWithNull=If[MatchQ[Lookup[myAssociation,AllowNull,True], True] && !MatchQ[Null, ReleaseHold[GenerateInputPattern[modifiedWidget]]],
					(* AllowNull\[Rule]True *)
					Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
						modifiedWidget
					],
					(* AllowNull\[Rule]False *)
					modifiedWidget
				];

				If[And[
						(* Default isn't Automatic. *)
						!MatchQ[Lookup[myAssociation,Default,Null], Automatic],
						(* The developer has a default that doesn't match the widget pattern *)
						(* NOTE: We have to regenerate the widget pattern here because we already added the default to the Pattern in Widgets.m *)
					!MatchQ[Lookup[myAssociation,Default,Null], ReleaseHold[GenerateInputPattern[modifiedWidgetWithNull]]],
						(* The Default isn't Null with AllowNull->True, covered above. *)
						!And[
							MatchQ[Lookup[myAssociation,Default,Null], Null],
							MatchQ[Lookup[myAssociation,AllowNull,True],True]
						]
					],
					(* AllowNull\[Rule]True *)
					Alternatives[
						Widget[Type->Enumeration,With[{insertMe=Lookup[myAssociation,Default,Null]},Pattern:>Alternatives[insertMe]]],
						modifiedWidgetWithNull
					],
					(* AllowNull\[Rule]False *)
					modifiedWidgetWithNull
				]
			],
			(* The widget is Null. *)
			Null
		]
	];

	(* Programmatically generate our tooltip *)
	specifiedTooltip = Lookup[myAssociation,PatternTooltip,Null];
	patternTooltip=If[MatchQ[specifiedTooltip,Null],
		OverallPatternTooltip[widget],
		specifiedTooltip
	];

	(* Return the correct format of information for this option. *)
	(* Engineering stashes strings on the backend since symbols are hard to transfer out of Mathematica. *)
	(* If we need to check for validity later in ValidDocumentationQ, we will convert the string back to a symbol using ToExpression. *)
	{
		<|
			(* Convert OptionName to a string. *)
			"OptionName"->SymbolName[myAssociation[OptionName]],

			(* Provide OptionName as a symbol. *)
			"OptionSymbol"->myAssociation[OptionName],

			(* "Default" wants the Default value, held. *)
			"Default"->Extract[myAssociation,Key[Default],Hold],

			(* "Head" is asking about whether Default\[Rule]defaultValue is \[Rule] or \[RuleDelayed]. Right now we only support \[Rule], TODO: ask sean why you would want to \[RuleDelayed]. *)
			"Head"->Rule,

			(* We already resolved the optionPattern from the Pattern key or from the Widget, above. *)
			"Pattern"->optionPattern[Pattern],

			(* We already resolved the optionPattern from the Pattern key or from the Widget, above. *)
			"SingletonPattern"->optionPattern[SingletonPattern],

			(* We already resolved the optionPattern from the Pattern key or from the Widget, above. *)
			"PooledPattern"->optionPattern[PooledPattern],

			(* optionPattern resolved from the Widget above includes overall pattern tooltip *)
			"PatternTooltip"->patternTooltip,

			(* Store if our option is pooled. *)
			"NestedIndexMatching"->Lookup[myAssociation,NestedIndexMatching,False],

			(* Pull out the Description. *)
			"Description"->myAssociation[Description],

			(* The ResolutionDescription is optional. Default it to "None" if it isn't present. *)
			"ResolutionDescription"->If[MatchQ[Lookup[myAssociation,ResolutionDescription,"None"],Null], (* Catch the case where the developer manually specifies Null. *)
				"None",
				ToString[Lookup[myAssociation,ResolutionDescription,"None"]]
			],

			(* "Symbol" is the name of the function. *)
			"Symbol"->mySymbol,

			(* Pull out category. It is an optional key so default it to "General". If it is specified, it will be a symbol. *)
			"Category"->If[MatchQ[Lookup[myAssociation,Key[Category],"General"],Null], (* Catch the case where the developer manually specifies Null. *)
				"General",
				ToString[Lookup[myAssociation,Key[Category],"General"]]
			],

			(* AllowNull defaults to True. *)
			"AllowNull"->Lookup[myAssociation,AllowNull,True],

			(* AllowNull defaults to True. *)
			"HideNull"->Lookup[myAssociation,HideNull,True],

			(* IndexMatching is a list of strings and symbols. This is an optional key so default it to Null. *)
			"IndexMatching"->If[MatchQ[Lookup[myAssociation,Key[IndexMatching],Null],Null],
				"None",
				ToString[myAssociation[IndexMatching]]
			],

			(* IndexMatchingInput is the name of the input block that this option matches to. Defaults to Null. *)
			"IndexMatchingInput" -> Lookup[myAssociation,Key[IndexMatchingInput],Null],

			(* IndexMatchingParent is the name of parent option in this index matching block if IndexMatchingInput is not set. Defaults to Null. *)
			"IndexMatchingParent" -> If[MatchQ[Lookup[myAssociation,Key[IndexMatchingParent],Null],Null],
				Null,
				ToString[myAssociation[IndexMatchingParent]]
			],

			(* IndexMatchingOptions is a list of the other options that are in the same index matching block as this option. Defaults to {}. *)
			"IndexMatchingOptions" -> ToString/@Lookup[myAssociation,Key[IndexMatchingOptions],{}],

			(* Expandable defaults to True. *)
			"Expandable"->Lookup[myAssociation,Key[Expandable],True],

			(* Put the widget inside. This key is optional, default it to Null if it is not provided. *)
			(* We store this symbolically because it may not be able to convert to string and back to a symbol. *)

			(* If the Widget is not null and AllowNull\[Rule]True, wrap the widget in Alternatives[Null,myWidget]. *)
			"Widget"->widget,

			(* Required tells us if this option must be specified. Right now, it's just used for options inside of primitives *)
			(* but we have plans to expand it to regular functions in the command builder as well. *)
			"Required"->Lookup[myAssociation,Key[Required],False],

			"UnitOperation"->Lookup[myAssociation,Key[UnitOperation],False]
		|>
	}
];


(* ::Subsubsection::Closed:: *)
(*defineOptions Legacy Helper Functions*)


(* core overload for explicitly-defined option (legacy version) *)
defineOption[mySymbol_Symbol,Hold[{myDefaultRule:(_Rule|_RuleDelayed),myPattern_,myDescription:(_String|{_String..}),myAdditionalRules:Repeated[Rule[Category|IndexMatching|PatternTooltip,_Symbol],{0,2}]}],allOptions_]:=Module[
	{defaultValue,optionName,fullDescription,additionalRulesList,category,indexMatching,patternTooltip},

	(* pull out the option default value and option name *)
	defaultValue=Extract[myDefaultRule,{2},Hold];
	optionName=myDefaultRule[[1]];

	(* if the description is a list of strings, riffle them together with spaces *)
	fullDescription=If[ListQ[myDescription],
		StringRiffle[myDescription," "],
		myDescription
	];

	(* determine if we have a category or index-matching symbol in the additional rules *)
	additionalRulesList=List[myAdditionalRules];
	category=Lookup[additionalRulesList,Category,Null];
	indexMatching=Lookup[additionalRulesList,IndexMatching,Null];
	patternTooltip=Lookup[additionalRulesList,PatternTooltip,Null];

	(* return a listed option association for this explicitly-defined option *)
	{
		<|
			(* support option names that are already strings *)
			"OptionName"->If[MatchQ[optionName,_String],
				optionName,
				SymbolName[optionName]
			],
			If[MatchQ[optionName,_Symbol],
				"OptionSymbol"->optionName,
				Nothing
			],
			"Default"->defaultValue,
			"Head"->Head[myDefaultRule],
			"Pattern"->Hold[myPattern],
			"PatternTooltip"->patternTooltip,
			"Description"->fullDescription,
			"Symbol"->mySymbol,
			"Category"->If[!MatchQ[category,Null],
				SymbolName[category],
				"General"
			],
			"IndexMatching"->If[!MatchQ[indexMatching,Null],
				SymbolName[indexMatching],
				"None"
			]
		|>
	}
];

(*Shared options, copy all options*)
defineOption[mySymbol_Symbol,Hold[mySharedSymbol_Symbol],allOptions_]:=Module[
	{sharedSymbolOptions},

	(* get the options for the (must be already defined) shared symbol *)
	sharedSymbolOptions=OptionDefinition[mySharedSymbol];

	(* throw a soft message to warn that we got no options from the shared symbol *)
	If[MatchQ[sharedSymbolOptions,{}],
		Message[DefineOptions::NoOptions,mySharedSymbol,mySymbol];
	];

	(* return the options from the shared symbol *)
	sharedSymbolOptions
];

(*Shared options, copy only specific options*)
defineOption[mySymbol_Symbol,Hold[{mySharedSymbol_Symbol,myOptionToCopy_Symbol}],allOptions_]:=defineOption[mySymbol,Hold[{mySharedSymbol,{myOptionToCopy}}],allOptions];
defineOption[mySymbol_Symbol,Hold[{mySharedSymbol_Symbol,myOptionsToCopy:{_Symbol..}}],allOptions_]:=Module[
	{sharedSymbolOptions,stringOptionNamesToCopy,filteredOptions,missingOptions},

	(* get the options for the (must be already defined) shared symbol *)
	sharedSymbolOptions=OptionDefinition[mySharedSymbol];

	(* convert the options to copy to strings (they are in string form in the option definitions of the shared symbol) *)
	stringOptionNamesToCopy=SymbolName/@myOptionsToCopy;

	(* filter the shared symbol options based on the ones to copy *)
	filteredOptions=Select[sharedSymbolOptions,MemberQ[stringOptionNamesToCopy,Lookup[#,"OptionName"]]&];

	(* detect any specific options that were requested to copy over, but aren't actually defined for the shared symbol *)
	missingOptions=Complement[stringOptionNamesToCopy,filteredOptions[[All,"OptionName"]]];
	If[!MatchQ[missingOptions,{}],
		Message[DefineOptions::MissingOptions,missingOptions,mySharedSymbol,mySymbol];
	];

	(* return the copied options *)
	filteredOptions
];

(*Shared options, copy a single option and rename it*)
defineOption[mySymbol_Symbol,Hold[{mySharedSymbol_Symbol,myOptionToCopy_Symbol}->myOptionToRename_Symbol],allOptions_]:=Module[
	{sharedSymbolOptions,optionToCopy,missingOptions},

	(* get the options for the (must be already defined) shared symbol *)
	sharedSymbolOptions=OptionDefinition[mySharedSymbol];

	(* filter the shared symbol options based on the ones to copy *)
	optionToCopy=FirstCase[sharedSymbolOptions,KeyValuePattern["OptionName"->SymbolName[myOptionToCopy]],Null];

	If[MatchQ[optionToCopy,Null],
		Message[DefineOptions::MissingOptions,myOptionToCopy,mySharedSymbol,mySymbol];
	];

	(* return the copied option, with the rename*)
	{
		Append[
			optionToCopy,
			<|
				"OptionName"->SymbolName[myOptionToRename],
				"OptionSymbol"->myOptionToRename
			|>
		]
	}
];

(* Copy over a primitive's options. *)
defineOption[mySymbol_Symbol,Hold[{myPrimitivePattern_Hold,primitiveHead_Symbol}],allOptions_]:=Module[
	{primitiveSetInformation, allPrimitiveInformation, primitiveHeads},

	(* Lookup information about our primitive set from our backend association. *)
	primitiveSetInformation=Lookup[ECL`$PrimitiveSetPrimitiveLookup, myPrimitivePattern];
	allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
	primitiveHeads=Keys[allPrimitiveInformation];

	(* Throw a message if we can't find information about the primitive. *)
	If[!MemberQ[primitiveHeads, primitiveHead],
		Message[DefineOptions::UnableToFindPrimitiveHead,primitiveHead,myPrimitivePattern];
	];

	Lookup[Lookup[allPrimitiveInformation, primitiveHead], OptionDefinition]
];

(* Copy over a verbatim option definition. *)
defineOption[mySymbol_Symbol,Hold[optionDefinition_Association],allOptions_]:=Module[
	{},
	{optionDefinition}
];


(*Options without description information (such as from Options[symbol])*)
defineOption[mySymbol_Symbol,myDefaultRule:(_Rule|_RuleDelayed),allOptions_]:=Module[
	{defaultValue,optionName},

	defaultValue=Extract[myDefaultRule,{2},Hold];
	optionName=myDefaultRule[[1]];

	(* return an informational association (that is mostly empty) *)
	<|
		"OptionName"->If[MatchQ[optionName,_String],
			optionName,
			SymbolName[optionName]
		],
		If[MatchQ[optionName,_Symbol],
			"OptionSymbol"->optionName,
			Nothing
		],
		"Default"->defaultValue,
		"Head"->Head[myDefaultRule],
		"Pattern"->_,
		"PatternTooltip"->_String,
		"Description"->"",
		"Symbol"->mySymbol,
		"Category"->"System",
		"IndexMatching"->"None"
	|>
];

(* Try to Evaluate the function generateSharedOption if given inside the body of DefineOptions *)
defineOption[mySymbol_Symbol,Hold[Analysis`Private`generateSharedOptions[x__]],allOptions_]:=
	With[
		{out = Analysis`Private`generateSharedOptions[x]},
		Which[
			(* With one single set of options just call the core function directly *)
			MatchQ[out,{(_Rule|_RuleDelayed)..}],
			defineOption[mySymbol,Hold[out],allOptions],

			(* With multiple set of options Map over the core function and option sets *)
			MatchQ[out,{{(_Rule|_RuleDelayed)..}..}],
			Sequence@@(defineOption[mySymbol,Hold[#],allOptions]& /@ out)
		]
	];

(* Try to Evaluate the function ModifyOptions with Shared upfront *)
defineOption[mySymbol_Symbol,Hold[ECL`OptionsHandling`ModifyOptions["Shared",mySharedSymbol_Symbol,myInputs__]],allOptions_]:=
	With[
		{myOutput = ECL`OptionsHandling`ModifyOptions["Shared",mySharedSymbol,myInputs]},
		Which[
			(* With one single set of options just call the core function directly *)
			MatchQ[myOutput,{(_Rule|_RuleDelayed)..}],
			defineOption[mySharedSymbol,Hold[myOutput],allOptions],

			(* With multiple set of options Map over the core function and option sets *)
			MatchQ[myOutput,{{(_Rule|_RuleDelayed)..}..}],
			Sequence@@(defineOption[mySharedSymbol,Hold[#],allOptions]& /@ myOutput)
		]
	];

(* Try to Evaluate the function ModifyOptions with Shared upfront *)
defineOption[mySymbol_Symbol,Hold[ECL`OptionsHandling`ModifyOptions["ShareAll",mySharedSymbol_Symbol,myInputs__]],allOptions_]:=
	With[
		{myOutput = ECL`OptionsHandling`ModifyOptions["ShareAll",mySharedSymbol,myInputs]},
		Which[
			(* With one single set of options just call the core function directly *)
			MatchQ[myOutput,{(_Rule|_RuleDelayed)..}],
			defineOption[mySharedSymbol,Hold[myOutput],allOptions],

			(* With multiple set of options Map over the core function and option sets *)
			MatchQ[myOutput,{{(_Rule|_RuleDelayed)..}..}],
			Sequence@@(defineOption[mySharedSymbol,Hold[#],allOptions]& /@ myOutput)
		]
	];

(* Try to Evaluate the function ModifyOptions if given inside the body of DefineOptions *)
defineOption[mySymbol_Symbol,Hold[ECL`OptionsHandling`ModifyOptions[myInputs__]],allOptions_]:=
	With[
		{myOutput = ECL`OptionsHandling`ModifyOptions[myInputs]},
		Which[
			(* With one single set of options just call the core function directly *)
			MatchQ[myOutput,{(_Rule|_RuleDelayed)..}],
			defineOption[mySymbol,Hold[myOutput],allOptions],

			(* With multiple set of options Map over the core function and option sets *)
			MatchQ[myOutput,{{(_Rule|_RuleDelayed)..}..}],
			Sequence@@(defineOption[mySymbol,Hold[#],allOptions]& /@ myOutput)
		]
	];


(*If options do not match any known pattern, try to evaluate it are incorrectly specified *)
tryOnce=True;
defineOption[x_,y_Hold,z_]/;tryOnce:=With[{evaluated = ReleaseHold[y]},
	Block[{tryOnce=False},
		defineOption[x,Hold[evaluated],z]
	]
];


(*If options still do not match any known pattern, they are incorrectly specified*)
defineOption[x_,y_,z_]:=Module[{},
	Message[DefineOptions::Format,y];
	{$Failed}
];

defineOption[x___]:={$Failed};


OptionDefinition[symbol_Symbol]:=(
	(* we are removing JLink` because it is known to shadow some symbols that we use in SLL *)
	Experiment`Private`deleteJLink[];

	Map[
		defineOption[symbol,#,Null]&,
		Options[symbol]
	]
);





(* ::Subsection::Closed:: *)
(*Option Parsing*)


(* use DefineOptionSet to define the HelperOutputOption *)
DefineOptionSet[
	HelperOutputOption :> {
		{
			Output -> Result,
			ListableP[Result|Tests],
			"Indicate what the helper function that does not need the Preview or Options output should return.",
			Category->Hidden
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*OptionDefaults*)


DefineOptions[OptionDefaults,
	Options:> {
		HelperOutputOption
	}
];

(* if only specifying the symbol, need to do some weird shenanigans to ensure we don't encounter some of the logic below which creates come recursion errors *)
OptionDefaults[mySymbol_Symbol]:=OptionDefaults[mySymbol, {}, Output -> Result];

(* if only specifying the symbol + the output option, pass to the core function *)
OptionDefaults[mySymbol_Symbol, myOutputOption:Rule[Output, ListableP[Result|Tests]]]:=OptionDefaults[mySymbol, {}, myOutputOption];

(* if options were provided, but no Output option was given, pass to the core function *)
OptionDefaults[mySymbol_Symbol, myOptions:{(_Rule|_RuleDelayed)...}]:=OptionDefaults[mySymbol, myOptions, Output -> Result];

(* core function: give the full option list, replacing incorrectly-specified options with the default *)
OptionDefaults[mySymbol_Symbol, myOptions:{(_Rule|_RuleDelayed)...}, myOutputOption:Rule[Output, ListableP[Result|Tests]]]:=Module[
	{defaults,stringOptions,definition, unknownOptions, unknownOptionTests, opsNames, opsHeldPatterns, opsPatterns,
		opsHeads, opsDefaults, messages, optionValuesWithMissing, incorrectPatternOptions, patternMatchesTests,
		heldOptionValues, allOptions, resultRule, testsRule, output, outputSpecification},

	(* get the value of the Output option; can't use ToList because it's not below in the dependency tree *)
	outputSpecification = Lookup[myOutputOption, Output];
	output = If[MatchQ[outputSpecification, _List],
		outputSpecification,
		{outputSpecification}
	];

	(* figure out whether to display messages or not; if we want to return Tests (or Tests + Result) do NOT show messages *)
	messages = Not[MemberQ[output, Tests]];

	(* change all the keys of the options to strings *)
	stringOptions = If[MatchQ[myOptions, {}],
		{},
		MapAt[
			If[MatchQ[#,_Symbol],
				SymbolName[#],
				#
			]&,
			myOptions,
			{All,1}
		]
	];

	(* get the definitions of all the options *)
	definition = OptionDefinition[mySymbol];

	(* get all the option names that don't appear in the definition *)
	unknownOptions = Complement[Keys[stringOptions], definition[[All, "OptionName"]]];

	(* generate the Warning tests for the UnknownOption error; ONLY do this if Tests is specified in the options; otherwise, definitely don't do this because we will make recursion errors since Warning calls OptionDefaults and we will hit issues *)
	unknownOptionTests = If[messages,
		{},
		Map[
			Warning[StringJoin["The ", #, " option for the ", ToString[mySymbol], " function exists:"],
				Not[MemberQ[unknownOptions, #]],
				True
			]&,
			Keys[stringOptions]
		]
	];

	(* if there are any unknown options and we are throwing messages, throw a warning *)
	If[messages && Not[MatchQ[unknownOptions, {}]],
		Message[Warning::UnknownOption, unknownOptions, mySymbol]
	];

	(* get all the option definition names *)
	opsNames = Lookup[definition, "OptionName", {}];

	(* get the patterns of all the options, and also releasing the Hold *)
	opsHeldPatterns = Lookup[definition, "Pattern", {}];
	opsPatterns = memoReleaseHold[#]& /@ opsHeldPatterns;

	(* get the option heads, and the option defaults *)
	opsHeads = Lookup[definition, "Head", {}];
	opsDefaults = Lookup[definition, "Default", {}];

	(* get the values of all the options from the stringOptions *)
	optionValuesWithMissing = Map[
		Lookup[stringOptions, #]&,
		opsNames
	];

	(* get the options with the incorrect patterns as a set of ordered quadruples *)
	incorrectPatternOptions = MapThread[
		Function[{value, pattern, name, heldPattern, default},
			If[MatchQ[value, pattern|_Missing],
				Nothing,
				{value, heldPattern, name, default}
			]
		],
		{optionValuesWithMissing, opsPatterns, opsNames, opsHeldPatterns, opsDefaults}
	];

	(* make a list of tests indicating whether the patterns match; ONLY do this if Tests is specified in the options; otherwise, definitely don't do this because we will make recursion errors since Warning calls OptionDefaults and we will hit issues *)
	(* if the option wasn't specified in the first place, don't generate a test for it *)
	patternMatchesTests = If[messages,
		{},
		MapThread[
			Function[{value, pattern, name, heldPattern},
				If[MatchQ[value, _Missing],
					Nothing,
					Warning[StringJoin["The specified value for the ", ToString[name], " option for the ", ToString[mySymbol], " function matches the pattern ", heldPatternToString[heldPattern], ":"],
						MatchQ[value, pattern|_Missing],
						True
					]
				]
			],
			{optionValuesWithMissing, opsPatterns, opsNames, opsHeldPatterns}
		]
	];

	(* throw a message for all cases where the pattern is not correct *)
	If[messages,
		Message[Warning::OptionPattern, #[[1]], HoldForm @@ #[[2]], #[[3]], mySymbol, HoldForm @@ #[[4]]]& /@ incorrectPatternOptions
	];

	(* get the correct held option value *)
	heldOptionValues = MapThread[
		Function[{value, pattern, default},
			(* this Except is important, because sometimes option patterns are just _ and so _Missing won't get caught here *)
			If[MatchQ[value, Except[_Missing, pattern]],
				Hold[value],
				default
			]
		],
		{optionValuesWithMissing, opsPatterns, opsDefaults}
	];

	(* get all the options together as a list of rules; doing the weird Prepend/Apply shenanigans to remove the Holds *)
	allOptions = MapThread[
		Function[{head, heldValue, name},
			head @@ Prepend[heldValue, name]
		],
		{opsHeads, heldOptionValues, opsNames}
	];

	(* make the full options rule if Result is in the output *)
	resultRule = Result -> If[MemberQ[output, Result],
		allOptions,
		Null
	];

	(* get all the tests together if they are wanted *)
	testsRule = Tests -> If[MemberQ[output, Tests],
		Flatten[{unknownOptionTests, patternMatchesTests}],
		Null
	];

	(* return the output based on what the input option is *)
	outputSpecification /. {testsRule, resultRule}
];

memoReleaseHold[Hold[arg_]]:=With[{out=arg},
	If[$LazyLoading,
		memoReleaseHold[Verbatim[Hold[arg]]] = out;
	];
	out
];
memoReleaseHold[arg_]:=(
	ReleaseHold[arg]
);

(* ::Subsection::Closed:: *)
(*Option Validity*)


(* ::Subsubsection::Closed:: *)
(*OptionDefault*)


DefineOptions[
	OptionDefault,
	Options:>{
		{Verbose->True,True|False,"When True, prints messages if the given options match their patterns or do not exist."},
		{Hold->False,True|False,"When True, compares the held value of the option against the pattern and returns the held value."}
	}
];

SetAttributes[OptionDefault,HoldFirst];

Warning::OptionPattern="The given option value `1` does not match the pattern `2` for the option `3` in the function `4`.  Defaulting the value to `5`.";
Warning::UnknownOption="The following specified option(s) are not options for `2`: `1`.";


(* list of option names, map over them *)
OptionDefault[OptionValue[function_Symbol,opts:OptionsPattern[],names:((_Symbol|_String)..)|{(_Symbol|_String)...}],ops:OptionsPattern[]]:=With[
	{
		nameList=If[MatchQ[names,_List],
			names,
			List[names]
		]
	},
	Map[
		OptionDefault[OptionValue[function,{opts},#],ops]&,
		nameList
	]
];

(* given function name and option name *)
OptionDefault[OptionValue[function_Symbol,names:((_Symbol|_String)..)|{(_Symbol|_String)...}],ops:OptionsPattern[]]:=OptionDefault[
	OptionValue[function,{},names],
	ops
];

(* core definition *)
OptionDefault[opValue:OptionValue[function_Symbol,opts:OptionsPattern[],name:_Symbol|_String],OptionsPattern[]]:=Module[
	{verbose,definition,optionName,
	heldPattern,pattern,hold,value,default},

	verbose=TrueQ[OptionValue[Verbose]];
	hold=TrueQ[OptionValue[Hold]];

	optionName=If[MatchQ[name,_String],
		name,
		SymbolName[name]
	];

	definition=SelectFirst[
		OptionDefinition[function],
		Lookup[#,"OptionName"] === optionName&,
		$Failed
	];

	If[definition === $Failed,
		If[verbose,
			Message[Warning::UnknownOption,optionName,function]
		];
		Return[Missing["Option", optionName]];
	];

	heldPattern = Lookup[definition,"Pattern",_];

	With[
		{evaluatedPattern=ReleaseHold[heldPattern]},

		pattern = If[hold,
			heldPattern,
			evaluatedPattern
		]
	];

	value = If[hold,
		OptionValue[function,{opts},name,Hold],
		OptionValue[function,{opts},name]
	];

	If[MatchQ[value,pattern],
		Return[value]
	];

	default=Lookup[definition,"Default"];
	If[verbose,
		Message[Warning::OptionPattern,value,heldPatternToString[heldPattern],optionName,function,HoldForm@@default]
	];

	If[hold,
		default,
		ReleaseHold[default]
	]
] ;


(* ::Subsection::Closed:: *)
(*Option Passing*)


(* ::Subsubsection:: *)
(*PassOptions*)


(*Only source function is specified*)
PassOptions[function_Symbol,ops:((_Rule|_RuleDelayed)...)]:=PassOptions[function,{ops}];
PassOptions[function_Symbol,ops:{(_Rule|_RuleDelayed)...}]:=PassOptions[function,function,ops];

(* when source and dest function are the same *)
PassOptions[function_Symbol,function_Symbol,ops:{(_Rule|_RuleDelayed)...}]:=Quiet[
	Apply[
		Sequence,
		keysToSymbols[
			OptionDefaults[function,ops],
			function
		]
	],
	{Warning::UnknownOption,OptionValue::nodef}
];

(*Source and receiving functions are different*)
PassOptions[function_Symbol,receivingFunction_Symbol,ops:((_Rule|_RuleDelayed)...)]:=PassOptions[function,receivingFunction,{ops}];
PassOptions[function_Symbol,receivingFunction_Symbol,ops:{(_Rule|_RuleDelayed)...}]:=With[
	{sourceOptions = OptionDefaults[function]},

	Quiet[
		Apply[
			Sequence,
			keysToSymbols[
				OptionDefaults[
					receivingFunction,
					Join[ops, sourceOptions]
				],
				receivingFunction
			]
		],
		{Warning::UnknownOption,OptionValue::nodef}
	]
];

(*Converts string keys to symbols when the options are defined as symbols for the
receiving function because a number of Mathematica functions do not respect
Options as strings.*)
keysToSymbols[options:{}, receivingFunction_Symbol]:={};
keysToSymbols[options:{(_Rule|_RuleDelayed)...}, receivingFunction_Symbol]:=With[
	{
		replacements=Cases[
			Keys[Options[receivingFunction]],
			x_Symbol :> (SymbolName[x] -> x),
			{1}
		]
	},

	MapAt[
		Replace[#, replacements, {0}] &,
		options,
		{All, 1}
	]
];
