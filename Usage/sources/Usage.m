(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*DefineUsage*)

$ProvisionalFunctions=<||>;

(* ::Subsubsection::Closed:: *)
(*Private Patterns*)



BehaviorP = Alternatives["Caching","Memoizing","ReverseMapping", "Listable"];

$InputColor::usage="The color for Input in Usage messages and documentation.";
$InputColor=RGBColor[0.047058823529411764, 0.7411764705882353, 0.5882352941176471];

$OutputColor::usage="The color for Output in Usage messages and documentation.";
$OutputColor=RGBColor[0.047058823529411764, 0.7411764705882353, 0.5882352941176471];

usageRulesFiles=Association[];

moreInformationP=(_String|Grid[_?(MatchQ[Dimensions[#],{_,Alternatives@@Range[1,6]}]&)]);

functionVersionP = _String?(StringMatchQ[#,DigitCharacter..~~"."~~DigitCharacter..]&);


(* A private pattern that represents how the outputted information should be formatted. *)
fieldInformation=Association[
	"BasicDefinitions"->Association[
		"Fields"->{"Definition","Output","Description"},
		"Pattern"->{{_String,_String|None,_String}..},
		"OutlineValue"->{},
		"Required"->True
	],
	"AdditionalDefinitions"->Association[
		"Fields"->{"Definition","Output","Description"},
		"Pattern"->{{_String,_String,_String}...},
		"Default"->{},
		"OutlineValue"->{},
		"Required"->False
	],
	"MoreInformation"->Association[
		"Fields"->{},
		"Pattern"->{moreInformationP...},
		"Default"->{},
		"OutlineValue"->{},
		"Required"->False
	],
	"Input"->Association[
		"Fields"->{"Name","Pattern","Description"},
		"HoldParts"->{1, All, 2},
		"Pattern"->{{_String,_,_String}...},
		"Default"->{},
		"OutlineValue"->{},
		"Required"->False
	],
	"Output"->Association[
		"Fields"->{"Name","Pattern","Description"},
		"HoldParts"->{1, All, 2},
		"Pattern"->{{_String,_,_String}...},
		"Default"->{},
		"OutlineValue"->{},
		"Required"->False
	],
	"Behaviors"->Association[
		"Fields"->{},
		"Default"->{},
		"Pattern"->{BehaviorP...},
		"OutlineValue"->{},
		"Required"->False
	],
	"Guides"->Association[
		"Fields"->{},
		"Default"->{},
		"Pattern"->{_String...},
		"OutlineValue"->{},
		"Required"->False
	],
	"Tutorials"->Association[
		"Fields"->{},
		"Default"->{},
		"Pattern"->{_String...},
		"OutlineValue"->{},
		"Required"->False
	],
	"Sync"->Association[
		"Fields"->{},
		"Default"->Automatic,
		"Pattern"->Automatic|Manual,
		"OutlineValue"->Automatic,
		"Required"->False,
		"Single"->True
	],
	"SeeAlso"->Association[
		"Fields"->{},
		"Default"->{},
		"Pattern"->{_String...},
		"OutlineValue"->{},
		"Required"->False
	],
	"Author"->Association[
		"Fields"->{},
		"Pattern"->{_String..},
		"OutlineValue"->{},
		"Required"->True
	],
	"DisplayExampleSetup"->Association[
		"Fields"->{},
		"Default"->True,
		"Pattern"->True|False,
		"OutlineValue"->{},
		"Required"->False,
		"Single"->True
	],
	"Version"->Association[
		"Fields"->{},
		"Default"-> "1.0",
		"Pattern"-> functionVersionP,
		"OutlineValue"->Null,
		"Required"->False,
		"Single"->True
	],
	"TestsRequired"->Association[
		"Fields"->{},
		"Default"-> True,
		"Pattern"-> True | False,
		"OutlineValue"->{},
		"Required"->False,
		"Single"->True
	],
	"ButtonActionsGuide"->Association[
		"Fields"->{"OperatingSystem","Description","ButtonSet"},
		"Pattern"->{{(MacOSX|Unix|Windows),_String,_String}...},
		"Default"->{},
		"OutlineValue"->{},
		"Required"->False
	],
	"Provisional"->Association[
		"Fields"->{},
		"Default"-> False,
		"Pattern"-> True | False,
		"OutlineValue"->{},
		"Required"->False,
		"Single"->True
	]
];


(* ::Subsubsection::Closed:: *)
(*Private Legacy Helper Functions*)


(* Helper function to test if a Symbol is protected. *)
protectedQ[sym_Symbol]:=MemberQ[
	Attributes[sym],
	Protected
];
SetAttributes[protectedQ,HoldFirst];


(* Get the default value of a field. For example, defaultValue["AdditionalDefinitions"] returns {}. *)
defaultValue[fieldName_String]:=With[
	{entry=Lookup[fieldInformation, fieldName]},
	If[MatchQ[entry, _Missing],

		Message[DefineUsage::InvalidUsageField, fieldName];
		$Failed,

		If[entry["Required"],
			Message[DefineUsage::NoDefaultForRequiredUsageFields, fieldName];
			$Failed,
			With[
				{value=Rule[fieldName, entry["Default"]]},
				If[KeyExistsQ[entry, "HoldParts"],
					Apply[RuleDelayed, value],
					value
				]
			]
		]
	]
];


(* Helper function that will look into the field information pattern and find the fields that are not required (optional fields). *)
(* This should return {"AdditionalDefinitions","MoreInformation","Input","Output","Behaviors","Guides","Tutorials","Sync","SeeAlso","DisplayExampleSetup","Version","TestsRequired"} *)
optionalUsageFields[]:=Keys[Select[fieldInformation, Not[Lookup[#, "Required", False]] &]];


(* Helper function that returns the default value of the optional fields. *)
(* This should return \[LeftAssociation]"AdditionalDefinitions"\[Rule]{},"MoreInformation"\[Rule]{},"Input"\[RuleDelayed]{},"Output"\[RuleDelayed]{},"Behaviors"\[Rule]{},"Guides"\[Rule]{},"Tutorials"\[Rule]{},"Sync"\[Rule]Automatic,"SeeAlso"\[Rule]{},"DisplayExampleSetup"\[Rule]True,"TestsRequired"\[Rule]True,"Version"\[Rule]"1.0"\[RightAssociation] *)
optionalDefaults[]:=Association@Map[
	defaultValue[#]&,
	optionalUsageFields[]
];


(* Helper function that combines the input association of usage rules with the defaults of any keys that are missing. *)
joinUsageFields[inputUsage_Association]:=KeyMap[
	ToString,
	Join[
		optionalDefaults[],
		inputUsage
	]
];


(* Format a usage rule. *)
formatUsageForField[functionName_String, RuleDelayed[name_String, value_]]:=If[SameQ[value, {}],
	{},
	formatUsageForField[functionName, Rule[name, Hold[value]]]
];

(* Format a usage rule. *)
formatUsageForField[functionName_String, Rule[name_String, value_]]:=Module[
	{fieldInfo, realValue},

	(* Lookup the pattern of the given key. *)
	fieldInfo=Lookup[fieldInformation, name];

	(* If we don't know about this key, throw a message and return $Failed. *)
	If[MatchQ[fieldInfo, _Missing],
		Message[DefineUsage::UnknownUsageField, functionName, name];
		Return[$Failed]
	];


	realValue=If[KeyExistsQ[fieldInfo, "HoldParts"],
		If[Not[MatchQ[value, _Hold]],
			Message[DefineUsage::RuleDelayedRequired, name];
			$Failed,

			ReleaseHold[
				MapAt[
					Hold,
					value,
					fieldInfo["HoldParts"]
				]
			]
		],
		value
	];

	If[realValue===$Failed,
		Return[$Failed]
	];

	(* Verify the pattern matches*)
	With[
		{fieldPattern=Lookup[fieldInfo, "Pattern"]},
		If[Not[MatchQ[realValue, fieldPattern]],
			Message[DefineUsage::UsageFieldPatternError, functionName, name];
			$Failed,

			With[
				{
					subFields=fieldInfo["Fields"],
					single=Lookup[fieldInfo, "Single", False]
				},
				If[subFields==={},
					realValue,
					If[single,
						formatUsageSubFields[subFields, realValue],
						Map[formatUsageSubFields[subFields, #]&, realValue]
					]
				]
			]
		]
	]
];


(* Format the sub fields?? *)
formatUsageSubFields[subFields:{_String..}, subValues_List]:=Association[
	MapThread[
		Function[{subField, subValue},
			subField->subValue
		],
		{
			subFields,
			subValues
		}
	]
];


(* Compute the missing keys in our combined usage association. *)
missingKeys[joinedUsage_Association]:=With[
	{
		info=Keys[fieldInformation],
		input=Keys[joinedUsage]
	},
	Complement[info, input]
];


(* ::Subsubsubsection::Closed:: *)
(*writeUsageMessageFromUsageRules*)


writeUsageMessageFromUsageRules[function_Symbol]:=Set[
	MessageName[function,"usage"],
	formatUsageMessage[function]
];
SetAttributes[writeUsageMessageFromUsageRules,HoldFirst];


lookupInputOutput[fieldValue:{_Association..}]:=Transpose[{
	Lookup[fieldValue, "Name"],
	Lookup[fieldValue, "Pattern"],
	Lookup[fieldValue, "Description"]
}];
lookupInputOutput[{}]:={};

prepFormatUsageMessage[function_Symbol]:=With[
	{
		defs=Usage[function]["BasicDefinitions"],
		inputs=Usage[function]["Input"],
		outputs=Usage[function]["Output"]
	},
	{
		Lookup[defs, {"Definition","Output", "Description"}],
		lookupInputOutput[inputs],
		lookupInputOutput[outputs]
	}
];
SetAttributes[prepFormatUsageMessage,HoldFirst];

formatUsageMessage[function_Symbol]:=Module[
	{defs, inputs, outputs, outputReplacements,
	inputReplacements, descriptionReplacements},

	{defs, inputs, outputs} = prepFormatUsageMessage[function];

	outputReplacements = Map[
		toDefinitionReplacement[#,$OutputColor]&,
		outputs
	];

	inputReplacements = Map[
		toDefinitionReplacement[#,$InputColor]&,
		inputs
	];

	descriptionReplacements = Join[
		Map[
			toDescriptionReplacement[#,$OutputColor]&,
			outputs
		],
		Map[
			toDescriptionReplacement[#,$InputColor]&,
			inputs
		]
	];

	StringJoin[
		Riffle[
			Map[
				Function[definition,
					If[MatchQ[definition[[2]],None],
						(*Pattern Usage*)
						StringJoin[definition[[1]], " ", definition[[3]]],
						(*Function Usage*)
						StringJoin[
							StringReplace[definition[[1]],inputReplacements],
							" \[DoubleLongRightArrow] ",
							StringReplace[definition[[2]],outputReplacements],
							"\n\t",
							StringReplace[definition[[3]],descriptionReplacements]
						]
					]
				],
				Take[defs,Min[Length[defs],3]]
			],
			"\n"
		],
		If[Length[defs]>3,
			"\n...",
			""
		]
	]
];
SetAttributes[formatUsageMessage,HoldFirst];

toReplacement[name_String, pattern_Hold, colour_]:=toReplacement[
 name,
 pattern,
 colour,
 ""
];
toReplacement[name_String, pattern_Hold, colour_, delimiter_String]:=With[
	{boxPattern = Apply[MakeBoxes, pattern]},

	Rule[
		RegularExpression[StringJoin[delimiter,"\\b", name, "\\b",delimiter]],
		StringJoin[
			"\!\(\*",
			ToString[
				TooltipBox[
					StyleBox[name, "TI", FontColor -> colour],
					boxPattern,
					TooltipStyle -> "TextStyling"
				],
				InputForm
			],
			"\)"
		]
	]
];
toDefinitionReplacement[{name_String, pattern_Hold, ___},colour_]:=toReplacement[name,pattern,colour];
toDescriptionReplacement[{name_String, pattern_Hold, ___},colour_]:=toReplacement[name,pattern,colour,"'"];


(* ::Subsubsection:: *)
(*Private Helper Functions*)


(* ::Subsubsubsection::Closed:: *)
(*Parse Inputs Helper Function (Atomic Version)*)


(* We define a helper function here as well because it makes the head replacing easier. *)
(* This is the case where we are given an atomic packet. *)
parseInput[List[myInput___]]:=Module[
	{inputAssociation,requiredInputsKeys,missingInputKeys,patterns,widget},

	(* Convert the list to an association. *)
	inputAssociation=Association[myInput];

	(* Define a list of required keys inside for Inputs. *)
	requiredInputsKeys={InputName, Description, Widget};

	(* Make sure that we were given all of the required keys. *)
	missingInputKeys=Complement[requiredInputsKeys,Keys[inputAssociation]];

	(* If we are missing a requied key, return $Failed. *)
	If[Length[missingKeys]!=0,
		Message[DefineUsage::MissingField,ToString[inputAssociation],ToString[missingInputKeys]]; Return[$Failed];
	];

	(* Make sure that either a Pattern or a Widget key is provided. (XOR) *)
	If[!Xor[KeyExistsQ[inputAssociation,Widget],KeyExistsQ[inputAssociation,Pattern]],
		Message[DefineUsage::InvalidUsageField, "Including both Pattern and Widget keys in "<>ToString[inputAssociation]]; Return[$Failed];
	];

	(* Get the pattern for this input in the form {Pattern\[RuleDelayed]_, SingletonPattern\[RuleDelayed]_}. *)
	patterns=If[KeyExistsQ[inputAssociation,Widget],
		(* If the widget key is given, construct the pattern based on the Widget. Also pass the rest of the information to GenerateInputPattern[...] from the input packet. *)
		GenerateInputPattern[List[myInput]],
		(* Otherwise, the Pattern key is given. Simply return the value from the Pattern key. *)
		{Pattern:>inputAssociation[Pattern],SingletonPattern:>inputAssociation[Pattern]}
	];

	(* Get the widget. If the widget is defined and it is an AtomicWidget, perform surgery on the PatternTooltip. *)
	widget=If[!SameQ[Lookup[inputAssociation,Key[Widget],Null],Null]&&MatchQ[Lookup[inputAssociation,Key[Widget],Null],AtomicWidgetP],
		Module[{rawWidget,patternTooltip,newPatternTooltip},
			(* Get the raw widget. *)
			rawWidget=Lookup[inputAssociation,Key[Widget],Null];

			(* Get the raw PatternTooltip *)
			patternTooltip=rawWidget[PatternTooltip];

			(* Perform surgery on the PatternTooltip for the Widget to have it use the input name. *)
			newPatternTooltip=ToString[inputAssociation[InputName]]<>" "<>First[StringCases[patternTooltip,StartOfString~~x:Except[" "]..~~" "~~y__:>y]];

			(* Replace the PatternTooltip *)
			Widget[Append[rawWidget[[1]],PatternTooltip->newPatternTooltip]]
		],
		Lookup[inputAssociation,Key[Widget],Null]
	];


	(* Return an association for this input. *)
	<|
		(* NOTE: We always want our input names capitalized. *)
		"Name"->Capitalize@ToString[inputAssociation[InputName]],

		"Pattern"->patterns[Pattern],

		"SingletonPattern"->patterns[SingletonPattern],

		"PooledPattern"->patterns[PooledPattern],

		"Description"->ToString[inputAssociation[Description]],

		"IndexName"->Lookup[inputAssociation,Key[IndexName],Null],

		"NestedIndexMatching"->Lookup[inputAssociation,Key[NestedIndexMatching],False],

		"Expandable"->Lookup[inputAssociation,Key[Expandable],True],

		(* Default to Null if the Widget key wasn't specified (this means that the pattern key was specified. *)
		"Widget"->widget
	|>
];


(* ::Subsubsubsection::Closed:: *)
(*Parse Inputs Helper Function (IndexMatching Version)*)


(* We define a helper function here as well because it makes the head replacing easier. *)
(* This is the case where we are given an IndexMatching block. *)
parseInput[IndexMatching[myInput___]]:=Module[
	{inputPacketsList,inputPacketsAssociation,indexName,inputPacketsWithoutIndexNameRule,inputPacketsWithIndexName,parsedInputs},

	(* Convert the sequence of input packets into a list. *)
	inputPacketsList=List[myInput];

	(* Also convert the sequence of input packets into an association (so it's easier to pull out the IndexName key. *)
	inputPacketsAssociation=Association[myInput];

	(* Pull out the IndexName key. *)
	indexName=Lookup[inputPacketsAssociation,Key[IndexName],Null];

	(* If the IndexName key is missing, throw an error. *)
	If[SameQ[indexName,Null],
		Message[DefineUsage::MissingField,ToString[IndexMatching[myInput]],ToString[IndexName]]; Return[$Failed];
	];

	(* The IndexMatching head is in the form IndexMatching[{...}..,IndexName\[Rule]_String]. Remove the last rule. *)
	(* Remove the IndexName rule from our list of input packets. *)
	inputPacketsWithoutIndexNameRule=(If[MatchQ[#,_List],
		#,
		Nothing
	]&)/@inputPacketsList;

	(* Go through each of the input packets and add the IndexName key. *)
	(* This is because each input packet is wrapped in an IndexMatching[...] head and we have to convey this information to GenerateInputPattern[...]. *)
	inputPacketsWithIndexName=(Append[#,(IndexName->indexName)]&)/@inputPacketsWithoutIndexNameRule;

	(* Call the singleton version of parseInput now that each input packet is assembled. *)
	parsedInputs=parseInput/@inputPacketsWithIndexName;

	(* Check for $Failed. *)
	If[MemberQ[parsedInputs,$Failed],
		Return[$Failed];
	];

	(* This function was called using Map. In order not to return our result with an unwanted layer of nesting, return a sequence. *)
	Sequence@@parsedInputs
];


(* ::Subsubsubsection::Closed:: *)
(*Parse Outputs Helper Function*)


parseOutput[outputList_]:=Module[
	{requiredOutputsKeys,outputsAssociation,missingOutputsKeys},
	(* Make sure that the Outputs key has the required keys. *)
	requiredOutputsKeys={OutputName,Pattern,Description};

	(* Convert the list to an Association. *)
	outputsAssociation=Association@@outputList;

	(* Make sure that we were given all of the required keys. *)
	missingOutputsKeys=Complement[requiredOutputsKeys,Keys[outputsAssociation]];

	(* If we are missing a requied key, return $Failed. *)
	If[Length[missingOutputsKeys]!=0,
		Message[DefineUsage::MissingField,ToString[outputsAssociation],ToString[missingOutputsKeys]]; Return[$Failed];
	];

	(* Put the Outputs association in the format that the documentation system expects. *)
	<|
		"Name"->Capitalize@outputsAssociation[OutputName],
		"Pattern"->Extract[outputsAssociation,Key[Pattern],Hold],
		"Description"->outputsAssociation[Description]
	|>
];


(* ::Subsubsubsection:: *)
(*Parse BasicDefinitions Helper Function*)


(* We define a helper function because it makes replacing heads much easier. *)
parseBasicDefinition[List[myBasicDefinition___]]:=Module[
	{basicDefinitionAssociation,requiredBasicDefinitionsKeys,missingBasicDefintionsKeys,parsedInputs,recapitalizedDefinition,
	requiredOutputsKeys,missingOutputsKeys,outputsAssociation,parsedOutputs,inputDefinition,rawInputOrdering,
	rawInputWithoutBrackets,inputList,sortedParsedInputs},

	(* Swap the list head for an association head. *)
	basicDefinitionAssociation=Association[myBasicDefinition];

	(* Define a list of required keys for BasicDefinitions. *)
	requiredBasicDefinitionsKeys={Definition, Description, Inputs, Outputs};

	(* Make sure that all of our required keys are here. *)
	missingBasicDefintionsKeys=Complement[requiredBasicDefinitionsKeys,Keys[basicDefinitionAssociation]];

	(* If there are missing keys, return $Failed. *)
	If[Length[missingBasicDefintionsKeys]!=0,
		Message[DefineUsage::MissingField,ToString[basicDefinitionAssociation],ToString[missingBasicDefintionsKeys]]; Return[$Failed];
	];

	(* Make sure that Definition is a List[..] of length 2. *)
	If[!MatchQ[basicDefinitionAssociation[Definition],_List]||Length[basicDefinitionAssociation[Definition]]!=2,
		Message[DefineUsage::UsageFieldPatternError, ToString[basicDefinitionAssociation], "Definition"]; Return[$Failed];
	];

	(* Use our helper function (defined above) to parse all of the inputs. *)
	(* NOTE: parseInput will capitalize our input name for us. *)
	parsedInputs=parseInput/@basicDefinitionAssociation[Inputs];

	(* Check for $Failed. *)
	If[MemberQ[parsedInputs,$Failed],
		Return[$Failed];
	];

	(* Parse out the input ordering from the function definition. *)
	inputDefinition=basicDefinitionAssociation[Definition][[1]];

	(* Get the raw string inside of the brackets in the definition. *)
	rawInputOrdering=First[StringCases[inputDefinition,"["~~___~~"]"]];

	(* Remove the brackets on each side. *)
	rawInputWithoutBrackets=StringTake[rawInputOrdering,{2,-2}];

	(* Split by commas and remove trailing whitespace. Also capitalize. *)
	inputList=Capitalize/@StringTrim[StringSplit[rawInputWithoutBrackets,{","}]];

	(* Sort the parsed inputs. This is such that our parsed input associations are in the same ordering as they show up in the string definition. *)
	sortedParsedInputs=SortBy[parsedInputs,(First[FirstPosition[inputList,#["Name"]]]&)];

	(* Make sure that Output is a nested List. *)
	If[!MatchQ[basicDefinitionAssociation[Outputs],_List]||MatchQ[basicDefinitionAssociation[Outputs][[1]],_Rule],
		Message[DefineUsage::UsageFieldPatternError, ToString[basicDefinitionAssociation], "Outputs"]; Return[$Failed];
	];

	(* Use our helper function (defined above) to parse all of the outputs. *)
	parsedOutputs=parseOutput/@basicDefinitionAssociation[Outputs];

	(* only try to capitalize after [ part of the basic definition *)
	(* since the old logic of replacing any lower-cased input string in the definition will cause a small bug
	where some definitions like "PlotSub(p)rotocols[(p)rotocol]" will always get capitalized to PlotSub(P)rotocols[(P)rotocol]
	whereas what we really want is PlotSub(p)rotocols[(P)rotocol] *)
	recapitalizedDefinition = Module[{completeDefinitionString, functionSymbol, rawInputs},
		(* get the raw definition string *)
		completeDefinitionString = Lookup[basicDefinitionAssociation, Definition][[1]];
		(* split the part by [, we will only try to capitalize input for any strings after [ *)
		{functionSymbol, rawInputs} = TakeDrop[StringSplit[completeDefinitionString, "[" -> "["], 1];
		(* do the string replacement and rejoin string *)
		StringJoin @@ {
			functionSymbol,
			StringReplace[StringJoin @@ rawInputs, (Decapitalize[#] -> Capitalize[#]&) /@ inputList]
		}
	];

	(* Return an association. *)
	<|
		"Definition"->recapitalizedDefinition,
		(* Replace any uncapitalized 'inputs' or 'outputs' in our function description as well. *)
		"Description"->StringReplace[
			Lookup[basicDefinitionAssociation,Description],
			Append[
				("'"<>Decapitalize[#]<>"'"->"'"<>Capitalize[#]<>"'"&)/@inputList,
				"'"<>Lookup[basicDefinitionAssociation,Definition][[2]]<>"'"->"'"<>Capitalize[Lookup[basicDefinitionAssociation,Definition][[2]]]<>"'"
			]
		],
		"Inputs"->sortedParsedInputs,
		(* Capitalize our output. *)
		"Output"->Capitalize[Lookup[basicDefinitionAssociation,Definition][[2]]],
		"Outputs"->parsedOutputs,
		"CommandBuilder"->Lookup[basicDefinitionAssociation,CommandBuilder,True] (* By default, include definitions in the command builder. *)
	|>
];


(* ::Subsubsubsection::Closed:: *)
(*Main Helper Function*)

Error::IntersectingInputAndOptionNames="The input and option names, `1`, for the function, `2`, will overwrite each other in the command builder. Please make sure your input names and option names are distinct for your function.";

(* This is the current version of DefineUsage that deals with Widgets. This function parses the input fields, and stashes the correct information in Usage[...]. *)
defineUsageCurrent[function_Symbol, usageFields_Association]:=Module[
	{validKeys,invalidKeys,requiredKeys,missingKeys,parsedOutputs,allOptionNames,allInputNames,
	basicDefinitionsAssociation,seperatedInputsAndOutputs,seperatedInputs,seperatedOutputs,documentationAssociation,protectedSymbol},

	(* IMPORTANT: *)
	(* In order to use Widgets with DefineUsage in yourPackage, you must set Widgets` as a dependency of yourPackage. *)
	(* This is because we cannot set Widgets` as a dependency of Usage` since (Widgets->Units\[Rule]Usage->Widgets). *)

	(* Make sure that the Widget module is loaded by checking the DownValues of Widget. (This is set in Widgets`.) *)
	If[Length[DownValues[Widget]]==0,
		Return[$Failed];
	];

	(* Define the list of valid keys. *)
	validKeys={BasicDefinitions, MoreInformation, SeeAlso, Author, AdditionalDefinitions, MoreInformation, Guides, Tutorials, Sync, DisplayExampleSetup, TestsRequired, Version, Preview, PreviewOptions, ResolveInputs, ResolveLabels, ButtonActionsGuide, PreviewFinalizedUnitOperations};

	(* Find the invalid keys. *)
	invalidKeys=Complement[Keys[usageFields],validKeys];

	(* Return $Failed if we are given invalid keys. *)
	If[Length[invalidKeys]!=0,
		Message[DefineUsage::InvalidUsageField,invalidKeys]; Return[$Failed];
	];

	(* Define the list of required keys. *)
	requiredKeys={BasicDefinitions, SeeAlso, Author};

	(* Make sure that we were given all of the required keys. *)
	missingKeys=Complement[requiredKeys,Keys[usageFields]];

	(* If we are missing any keys, return $Failed. *)
	If[Length[missingKeys]!=0,
		Message[DefineUsage::MissingField,ToString[usageFields],ToString[missingKeys]]; Return[$Failed];
	];

	(* Everything looks good. Now we replace List[...] with Association[...] in a few places for BasicDefinitions. *)
	(* This is because the Documentation backend requires this format. *)

	(* Correctly format the BasicDefinitions field. *)
	basicDefinitionsAssociation=parseBasicDefinition/@usageFields[BasicDefinitions];

	(* Check for $Failed. *)
	If[MemberQ[basicDefinitionsAssociation, $Failed],
		Return[$Failed];
	];

	(* We now have to pull out the {Input, Output} fields from the BasicDefinitions field. *)
	(* We do this to comply with the format that SyncDocumentation currently uses. *)

	seperatedInputsAndOutputs=Function[myBasicDefinition,
		{
			myBasicDefinition["Inputs"],
			myBasicDefinition["Outputs"]
		}
	 ]/@basicDefinitionsAssociation;

	 (* Gather up all of the inputs and outputs. *)
	 {seperatedInputs, seperatedOutputs}=Transpose[seperatedInputsAndOutputs];

	 (* Create an association in the correct format that ValidDocumentationQ and SyncDocumentation want. *)
	 documentationAssociation=<|
		 "AdditionalDefinitions"->Lookup[usageFields,Key[AdditionalDefinitions],{}],
		 "MoreInformation"->Lookup[usageFields,Key[MoreInformation],{}],
		 "Input"->DeleteDuplicates[Flatten[seperatedInputs]],
		 "Output"->DeleteDuplicates[Flatten[seperatedOutputs]],
		 "Behaviors"->{}, (* We're sunsetting this key. *)
		 "Guides"->Lookup[usageFields,Key[Guides],{}],
		 "Tutorials"->Lookup[usageFields,Key[Tutorials],{}],
		 "Sync"->Lookup[usageFields,Key[Sync],Automatic],
		 "SeeAlso"->Lookup[usageFields,Key[SeeAlso],{}],
		 "DisplayExampleSetup"->Lookup[usageFields,Key[DisplayExampleSetup],True],
		 "TestsRequired"->Lookup[usageFields,Key[TestsRequired],True],
		 "Version"->Lookup[usageFields,Key[Version],"1.0"],
		 "BasicDefinitions"->basicDefinitionsAssociation,
		 "Author"->Lookup[usageFields,Key[Author],{}],
		 "Preview"->Lookup[usageFields,Key[Preview],False],
		 "PreviewOptions"->Lookup[usageFields,Key[PreviewOptions],{}],
		 "ResolveInputs"->Lookup[usageFields,ResolveInputs,False],
		 "ResolveLabels"->If[KeyExistsQ[usageFields,ResolveLabels],
			 Lookup[usageFields,ResolveLabels],
			 MemberQ[OptionDefinition[function], KeyValuePattern["OptionSymbol"->ECL`PreparatoryUnitOperations]]
		 ],
		 "PreviewFinalizedUnitOperations"->Lookup[usageFields,PreviewFinalizedUnitOperations,False],
		 "ButtonActionsGuide"->Lookup[usageFields,Key[ButtonActionsGuide],{}]
	 |>;

	(* Make sure that none of the names conflict with the options for the function. The command builder crashes when this happens. *)
	allInputNames=DeleteDuplicates[Flatten[Lookup[basicDefinitionsAssociation, "Inputs"][[All, All, "Name"]]]];
	allOptionNames=If[MissingQ[Lookup[OptionDefinition[function], "OptionName"]],{},Lookup[OptionDefinition[function], "OptionName"]];

	If[MemberQ[Flatten[Values /@ Values[ECL`$CommandBuilderFunctions]], ToString[function]] && Length[Intersection[allInputNames, allOptionNames]]>0,
		Message[Error::IntersectingInputAndOptionNames, Intersection[allInputNames, allOptionNames], function];

		Return[$Failed];
	];

	(* See if this function is protected. Returns a boolean. *)
	protectedSymbol=protectedQ[function];

	(* If our symbol is protected, unprotect it before we modify its documentation. *)
	If[protectedSymbol,
		Unprotect[function]
	];

	(* Set the usage of this function via its UpValue. *)
	Usage[function]^:=Evaluate[documentationAssociation];

	(* Call this legacy helper function that lets us use ?FunctionName. *)
	writeUsageMessageFromUsageRules[function];

	(* If our symbol was protected coming in, reprotect it. *)
	If[protectedSymbol,
		Protect[function]
	];

	(* Stash the $InputFileName in a private association in this package. (Not exactly sure what this does, but the package seems to be using usageRulesFiles somehow. Hold over from the legacy system - Thomas) *)
	AssociateTo[usageRulesFiles, SymbolName[function]->$InputFileName];

	documentationAssociation
];


(* ::Subsubsection::Closed:: *)
(*Public DefineUsage[...] Function*)


DefineUsage::MissingField="Usage definition for function `1` missing usage field `2`";
DefineUsage::UnknownUsageField="The function `1` has an unknown usage field definition `2`.";
DefineUsage::UsageFieldPatternError="The function `1` has a usage field definition `2` that does not match its pattern.";
DefineUsage::InvalidUsageField="`1` is not a valid usage field.";
DefineUsage::NoDefaultForRequiredUsageFields="The usage field `1` does not have a default. It is required.";
DefineUsage::RuleDelayedRequired="The usage field `1` is required to be a RuleDelayed.";


LazyLoading[$DelayUsagedefineUsage,defineUsage, UpValueTriggers->{Usage}];
(*
	also have manually made System`InformationDump`getInformationData trigger usage
*)


(* Helper function to convert from a list of usage rules to an association. *)
DefineUsage[function_Symbol, usageRules:{(_Rule|_RuleDelayed)...}]:=DefineUsage[function, Association[usageRules]];

(* DefineUsage parses the given usage information and stashes the result in the Usage[...] function as an UpValue. *)
DefineUsage[function_Symbol, usageFields_Association] := Module[{},

	If[ TrueQ[Lookup[usageFields,Provisional,False]],
		$ProvisionalFunctions[function] = <|"Provisional"->True, File -> $InputFileName|>;
	 ];

	 defineUsage[function, usageFields]

];



defineUsage[function_Symbol, usageFields_Association]:=Module[
	{fields, missing, symbolName, formattedUsage, protectedSymbol},




	(* First, check to see if we match the current version of input specification. *)
	(* We don't want to blindly pattern match on the new input pattern because it is possible that the *)
	(* developer meant to use the new version, but made a mistake. These basic checks ensure that the *)
	(* developer probably meant to use the new version of DefineUsage[...]. *)
	If[
		And[
			!KeyExistsQ[usageFields,Input], (* If there is no Input key on the outtermost level *)
			MatchQ[(usageFields[BasicDefinitions][[1]]),{(_Rule|_RuleDelayed)..}], (* If the elements inside of each basic definitions are rules or delayed rules. *)
			KeyExistsQ[Association@@(usageFields[BasicDefinitions][[1]]),Inputs] (* If an Inputs key exists inside of the first basic definition. *)
		],
		(* If these checks pass, execute the current DefineUsage[...] functionality. *)
		Return[defineUsageCurrent[function,usageFields]];
	];

	(* Otherwise, execute the legacy version of DefineUsage (the following code below). *)

	(* Join the inputted usage fields with the default usage fields. This gives us an association with all of the necessary keys populated. *)
	(* For example, if Authors wasn't populated in usageFields, it sets the field to a default value. *)
	fields=joinUsageFields[usageFields];

	(* Get the name of this function as a string. *)
	symbolName=SymbolName[Unevaluated[function]];

	(* See if this function is protected. Returns a boolean. *)
	protectedSymbol=protectedQ[function];

	(* Check that the requried fields exist. If a required field is missing, throw messages for the missing fields. *)
	missing=Map[
		Message[DefineUsage::MissingField, symbolName, #];&,
		missingKeys[fields]
	];

	(* If we threw messages, return $Failed. *)
	If[Length[missing]>0,
		Return[$Failed];
	];

	formattedUsage=AssociationMap[
		Function[{rule},
			First[rule]->formatUsageForField[symbolName, rule]
		],
		fields
	];

	If[MemberQ[Values[formattedUsage], $Failed],
		$Failed,
		(
			If[protectedSymbol,
				Unprotect[function]
			];

			Usage[function]^:=Evaluate[formattedUsage];
			writeUsageMessageFromUsageRules[function];

			If[protectedSymbol,
				Protect[function]
			];
			AssociateTo[usageRulesFiles, symbolName->$InputFileName];
			formattedUsage
		)
	]
];

(* We set DefineUsage and Usage to be HoldFirst because the first argument (the symbol that we are defining the usage of) could be a pattern (ex. UnitsP) *)
SetAttributes[DefineUsage,HoldFirst];
SetAttributes[Usage,HoldFirst];


(* ::Subsubsection:: *)
(*Setting DownValues on Usage is deprecated. *)


DefineUsage::DeprecatedForm="Defining usage with the form Usage[`1`] (in SLL package: `2`) is deprecated. Use DefineUsage instead.";
Usage/:SetDelayed[Usage[deprecated_], _]:=(
	Message[DefineUsage::DeprecatedForm, ToString[deprecated], FunctionPackage[deprecated]];
	$Failed
);

productionDocumentationJsonLocation="documentation-paclets/latest-documentation.json";
stageDocumentationJsonLocation="documentation-paclets/stage-documentation.json";

(*Overload CreateMessageLink to force the >> button to be created for symbols defined in Emerald packages.*)
OnLoad[
	(* The paclet mapping describes where to go in s3 for the various documentation notebooks.  This will change dynamically as the docs-service
	updates the documentation.  We want to download this on load of SLL (and not every time help is accessed, for example), but we unfortunately
	cannot, as downloading the paclet mapping requires you to be logged in (which not possible on SLL load).  Instead, we set this flag to true
	and then each time the help is accessed, we check to see if the flag has been set. *)
	$DownloadNewestPacletMapping=true;

	Unprotect[Documentation`CreateMessageLink];

	(*Prepend ECL's definition so that the kernel tries to match it first before moving on to the built-in ones.
	Added 'unused' argument since CreateMessageLink is called with 5 arguments in 13.2 (previously only 4 in v12)*)
	PrependTo[DownValues[Documentation`CreateMessageLink],
		HoldPattern[Condition[Documentation`CreateMessageLink[context_String, symbolName_String, "usage", language_String, Optional[unused_, False]],
			MatchQ[FunctionPackage[Evaluate[context<>symbolName]],_String]]] :>
			Module[
				{packageName,refName,uri,localFile,downloadResponse,remoteLocationIsInPacletMap},

				(* Everything in the docs world is referred to by "paclet uris" that look like "paclet:Analysis/guide/AnalysisCategories".  This can be
                turned into real file paths by calling Documentation`ResolveLink.  This can be turned into a remote location to pull from by looking
                at the documentation.json file, which contains what's called a "PacletMapping" which maps paclets to locations in the cloud to pull from. *)
				packageName = Lookup[PackageMetadata[FunctionPackage[Evaluate[context<>symbolName]]],"Name"];
				refName=If[StringMatchQ[context,__~~"Private`"],
					symbolName<>"Private",
					symbolName
				];
				uri=pacletRef[packageName,refName];

				(* If the documentation is up to date, we should just use that.  The rules for when documentation is up to date can get confusing, so check
                   out that functions docs for more info. *)
				If[documentationNotebookUpToDateQ[uri],
					Return[uri]
				];

				(* Ensure that that paclet map is up to date before we access any of the data in it.  Note that there's a subtle reason why we do this here
                instead of in OnLoad, which is that if we call it here, we can be authenticated (necessary to download the new paclet mapping via a signed url)
                whereas if we called this OnLoad, we could not yet have logged in.  If the paclet download failed, we're going to continue on with our lives
                and attempt to use the previously downloaded version. *)
				ensurePacletMappingUpToDate[];

				(* If we're not managing the docs, then we should just check if they're downloadable, and the application that's managing the docs
                can handle actually downloading the docs or whatever it needs to do.  For example, if the docs are downloadable and we're running
                in command center, command center will take care of actually downloading them. *)
				remoteLocationIsInPacletMap=And[AssociationQ[PacletMapping[]], KeyExistsQ[PacletMapping[], uri]];
				If[!dynamicallyUpdateDocumentationQ[],
					If[remoteLocationIsInPacletMap,
						Return[uri],
						Return[Null]
					];
				];

				(* If we're managing the docs, then its almost time to go download.  The last thing we should check before trying to download is
                to see if we actually have a paclet entry for them. *)
				If [!remoteLocationIsInPacletMap,
					Return[Null]
				];

				(* At this point, we need to go download the file!  Very exciting!  If we download the file, then we should pass the original uri back (because
                now the notebook will be in the right spot).  If we fail to download the file, then we should return Null, as this will prevent the UI from showing
                a broken link. *)
				downloadResult=downloadDocumentationNotebook[uri];

				If[And[AssociationQ[downloadResult],downloadResult["Success"]],
					uri,
					Null
				]
			]
	];

	Protect[Documentation`CreateMessageLink];
];

pacletRef[packageName_String,ref_String]:=StringJoin[
	"paclet:",
	packageName,
	"/ref/",
	ref
];

PacletMapping[]:=With[
	(*This file is written as part of BuildDistroArchives and will be present once the Documentation
	archive is extracted in a packaged build.  If we're not running from a distro (say, running from a git repo), we'll need to make sure we download this.*)
	{file=FileNameJoin[{ParentDirectory[PackageDirectory["Usage`"]],"documentation.json"}]},

	If[FileExistsQ[file],
		PacletMapping[]=Import[file,"RawJSON"],
		Null
	]
];

ensurePacletMappingUpToDate[]:=Module[
	{result},

	(* If we're not dynamically updating the documentation, then the paclet mapping is always considered up to date. For example, in command center,
	we will never download a new paclet mapping and instead rely on the distro process to update it. *)
	If[!dynamicallyUpdateDocumentationQ[],
		Return[]
	];

	(* Check if the paclet file has been refresed since SLL load, and if it has, then don't bother loading it again *)
	If[!$DownloadNewestPacletMapping,
		Return[]
	];

	(* Downloading the paclet file will require the user to be logged in (in order to get a signed download URL), so give people a helpful error
	message if they're not logged in so they can update their help files. *)
	If[!Constellation`Private`loggedInQ[],
		Message[RemoteDocumentation::NotLoggedIn];
		Return[$Failed]
	];

	(* Download the latest documentation.json to ensure docs are up to date when running locally. There's an interesting side effect of this,
	which is that because documentation.json lives in the root folder of SLL, we'll be triggering changes within the gitrepo, so we need to
	add documentation.json to .gitignore to avoid confusing people.  Also, note that the doc-service will always make sure that the documentation.json
	file in the documentation-paclets directory of the docs bucket contains the most up to date paclet mapping. *)
	result=GoCall["DownloadCloudFile", <|
		"Path" -> FileNameJoin[{ParentDirectory[PackageDirectory["Usage`"]],"documentation.json"}],
		"Bucket" -> "emeraldsci-documentation-argo",
		"Key" -> productionDocumentationJsonLocation,
		"Retries" -> 4
	|>];

	(* If we successfully downloaded the new paclet file, then remember not try again this session *)
	If[AssociationQ[result] && result["Success"],
		$DownloadNewestPacletMapping=False;
	];

	result
];

documentationNotebookUpToDateQ[uri_String]:=Module[
	{notebookPath},
	(* Resolve the link to get the path of the notebook on disk *)
	notebookPath=Documentation`ResolveLink[uri];

	(* A doc notebook is up to date if we're running from a distro and the file exists OR if we're running locally the file is no more than 24 hours old *)
	(* Need to include the distro check *)
	If[!StringQ[notebookPath] || !FileExistsQ[notebookPath],
		False,
		DateDifference[FileDate[notebookPath],Now] < Quantity[1, "Days"]
	]
];

RemoteDocumentation::NotLoggedIn="Detailed documentation is not available because you are not logged in.  Please log in and try again.";
downloadDocumentationNotebook[uri_String]:=Module[
	{pacletInfo, notebookLink, notebookPath, directoryPath},

	(* Because downloading the docs requires the blobsign API, you must be logged in.  This extra handling ensures people get back something
	actionable rather than just a blank page *)
	If[!Constellation`Private`loggedInQ[],
		Message[RemoteDocumentation::NotLoggedIn];
		Return[$Failed]
	];

	(* Grab the paclet info - this will tell us where to look for the file on s3 *)
	pacletInfo=PacletMapping[][uri];

	(* Its possible that notebookLink will be Null here.  This happens when the file does not exist at all on disk, as ResolveLink checks
	that there's really a file there.  If this is the case, then we can manually build the location where the file should live based off
	of the key of the file on S3 *)
	notebookLink=Documentation`ResolveLink[uri];
	If[NullQ[notebookLink],
		notebookPath=FileNameJoin[Prepend[Rest[StringSplit[pacletInfo["key"], "/"]], ParentDirectory[PackageDirectory["Usage`"]]]],
		notebookPath=notebookLink
	];

	(* If the directory for the documentation does not exist, create it *)
	directoryPath = DirectoryName[notebookPath];
	If[!DirectoryQ[directoryPath],
		CreateDirectory[directoryPath];
	];

	(* If we have a file at the path already, delete it so we can overwrite it with a newer version *)
	If[StringQ[notebookPath] && FileExistsQ[notebookPath],
		DeleteFile[notebookPath]
	];

	(* Download the notebook from S3.  We do this via telescope because the notebooks are not publically available, which means the request
	must be signed in order to for it to succeed.  Telescope takes care of getting a signed URL from constellation for us.  This is also why
	you need to be logged in to see full documentation. *)
	GoCall["DownloadCloudFile", <|
		"Path" -> notebookPath,
		"Bucket" -> pacletInfo["bucket"],
		"Key" -> pacletInfo["key"],
		"Retries" -> 4
	|>]
];

(* If true, then documentation should be dynamically updated as newer documentation is available.  If not true, then we should stick
with whatever was distributed with the application *)
dynamicallyUpdateDocumentationQ[]:=Module[
	{},
	(* Right now the logic is simple - if we are running this from a packaged distro (like in command center), we shouldn't touch anything,
	but if we're running from a non-packaged distro (like from a git repo), then we should automatically update it *)
	$Distro==$Failed
];


(* ::Subsection::Closed:: *)
(*Authors*)

Authors::PatternStringInput="The input string is `1`, which is likely an evaluated pattern or pure function. As such, authors cannot be found. The symbol that was used to make the input string likely had own values of another pattern, causing it to be evaluated before the symbol was converted to a string.";


DefineOptions[Authors,
	Options :> {
		{Default -> None, None | _String, "Default sets the return value for the author if none is found in the Usage rules.  If Default->None, the function returns an empty list when it can't identify the author."}
	}];


Authors[Object[Analysis],ops:OptionsPattern[Authors]]:={"brad"};
Authors[Object[Company],ops:OptionsPattern[Authors]]:={"hayley"};
Authors[Object[Data],ops:OptionsPattern[Authors]]:={"hayley"};
Authors[Object[Instrument],ops:OptionsPattern[Authors]]:={"hayley"};
Authors[Model[Sample],ops:OptionsPattern[Authors]]:={"hayley"};
Authors[Object[User],ops:OptionsPattern[Authors]]:={"paul"};
Authors[Object[Protocol],ops:OptionsPattern[Authors]]:={"ben"};
Authors[Object[Report],ops:OptionsPattern[Authors]]:={"ben"};
Authors[Object[Program],ops:OptionsPattern[Authors]]:={"hayley"};
Authors[Object[Sample],ops:OptionsPattern[Authors]]:={"ben"};
Authors[Object[Simulation],ops:OptionsPattern[Authors]]:={"robert"};


(* Authors of strings for pattern purposes *)
Authors[symString_String, ops:OptionsPattern[Authors]]:=Module[
{safeOps,defaultInput},

	(* check input string for not symbol characters *)
	If[StringContainsQ[symString, ("|" | "(" | ")" | "_" | "&" | "#" | "?")],
		(* send message and return something that makes sense *)
		Message[Authors::PatternStringInput,symString];
		Return[$Failed]
	];

	(* get default option *)
	defaultInput = OptionValue[Default];
	defaultDefault = Lookup[Options[Authors],"Default"];
	(* if the inputted option for Default is the same as the fallback option, then set no options *)
	optionsString = If[MatchQ[defaultInput,defaultDefault],
		"",
		","<>ToString[Default->OptionValue[Default]]
	];

	(* turn this mashup of strings into an expression to evaluate at once *)
	ToExpression["Authors["<>ToString[symString]<>optionsString<>"]"]
];


Authors[list_List,ops:OptionsPattern[Authors]]:=Map[Authors[#,ops]&,list];

Authors[symbol_,ops:OptionsPattern[Authors]]:=Module[
{usg,usageAuthors,combined,defaultOption,dvAuthors},

	defaultOption = OptionDefault[OptionValue[Default]];

	usg = Usage[symbol];

	If[!MatchQ[usg,_Association],
		usg=<||>;
	];

	(* authors from Usage rules *)
	usageAuthors=Lookup[usg,"Author",{}];

	(* combine and delete duplicates *)
	combined=DeleteDuplicates[usageAuthors];

	(* default if necessary *)
	If[combined==={},
		(* check downvalues of authors *)
		dvAuthors = HoldPattern[Authors[symbol]]/.DownValues[Authors];
		(* return if dvAuthors is a list *)
		If[MatchQ[dvAuthors,_[_List]],
			ReleaseHold[dvAuthors],
			(* else return default option *)
			Switch[defaultOption,
				None, combined,
				_String, {defaultOption}
			]
		],
		combined
	]

];

(* Set HoldFirst for Authors to find authors of patterns with own values *)
SetAttributes[Authors,HoldFirst];
