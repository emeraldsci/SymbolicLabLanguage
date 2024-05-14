(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*SimulateReactivity*)


(* ::Subsubsection:: *)
(*Options*)


DefineOptions[SimulateReactivity,
	Options :> {
		{
			OptionName->Method,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Motif | Base ],
			Description->"If use Motif Method, ReactionMechanism will be simulated by matching motifs with respect to motif names. If use Base Method, ReactionMechaism will be simulated by pairing nucleic acid bases with respect to Watson-Crick base pairs.",
			ResolutionDescription->"If Method is Automatic or Null, the function will use Base Method on explicit strands and Motif Method on implicit strands with Motif names. When input is a ReactionMechanism, SimulateReactivity only adds reaction rates and Method option will be set to Null."
		},
		{
			OptionName->Reactions,
			Default->All,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:> Alternatives[All]],
				Adder[Widget[Type->Expression, Pattern:> ReactionsOptionP, PatternTooltip->"A reaction like FoldingReaction[Structure[{Strand[DNA[\"ACGTACGTACGTACGT\"]]}, {}]] or HybridizationReaction[ Structure[{Strand[DNA[\"ACGTACGTACGTACGT\"]]}, {}]].", Size->Line]]
			],
			Description->"List of reactions to model, described using FoldingReaction, HybridizationReaction, MeltingReaction, ToeholdStrandExchangeReaction, ToeholdDuplexExchangeReaction, DualToeholdDuplexExchangeReaction."
		},
		{
			OptionName->Temperature,
			Default->37 Celsius,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin ],
				Widget[Type->Expression, Pattern:> _Function, PatternTooltip->"A pure function like (273 + 30 + #1/3 &).", Size->Paragraph]
			],
			Description->"Temperature to be used when calculating Gibbs free energy. In addition, if temperature is Null, leaves rates as symbols/expressions, otherwise, calculates reaction rates with respect to temperature and rate related options."
		},
		{
			OptionName->PrunePercentage,
			Default-> 5 Percent,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> RangeP[0 Percent, 100 Percent], Units->Percent],
			Description->"Structures with equilibrium concentration lower than specified percentage of the total concentration at each depth level will be ignored. There will be no pruning if PrunePercentage is 0% (by default)."
		},
		{
			OptionName->Time,
			Default-> 30*Day,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterP[0 Second], Units-> Second | Minute | Hour | Day | Week | Month ],
			Description->"Motif method uses SimulateKinetics to simulate for given length of time to decide product."
		},
		{
			OptionName->MinFoldLevel,
			Default-> 3,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterP[0, 1]],
			Description->"Minimum number of consecutive bases required in a fold."
		},
		{
			OptionName->MinPairLevel,
			Default-> 5,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterP[1, 1]],
			Description->"Minimum number of consecutive bases requried in a pair."
		},
		{
			OptionName->Depth,
			Default-> 5,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterP[0, 1]],
			Description->"At Depth 1, all input species are treated as potential reactants in searching for reactions. At Depth more than 1, all input species and all products from the previous generated reactions are treated as potential reactants in searching for new reactions."
		},
		{
			OptionName->FoldingDepth,
			Default->Infinity,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[1, 1], PatternTooltip->"Structures folded from 1 to n times"],
				Widget[Type->Enumeration, Pattern:> Alternatives[Infinity], PatternTooltip->"All possible structures foldings"]
			],
			Description->"Number of iterative folding steps conducted by the folding algorithm to reach the final structures.."
		},
		{
			OptionName->HybridizationDepth,
			Default->1,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[1, 1], PatternTooltip->"Structures hybridized from 1 to n times"],
				Widget[Type->Enumeration, Pattern:> Alternatives[Infinity], PatternTooltip->"All possible structures foldings"]
			],
			Description->"Number of iterative hybridization steps conducted by the folding algorithm to reach the final structures.."
		},
		{
			OptionName->InterStrandFolding,
			Default-> True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			Description->"For a hybridized structure, allow Folding among different Strands that are already bonded in this Structure."
		},
		{
			OptionName->IntraStrandFolding,
			Default-> True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			Description->"For a hybridized structure, allow self Folding of individual Strand."
		},
		{
			OptionName->MaxMismatch,
			Default-> 0,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Maximum number of mismatches that can exist in consecutive base pairs."
		},
		{
			OptionName->MinPieceSize,
			Default-> 1,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterP[0, 1]],
			Description->"Minimum number of consecutive paired bases required when containing mismatches."
		},
		{
			OptionName->Template,
			Default -> Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,ReactionMechanism]],ObjectTypes->{Object[Simulation,ReactionMechanism]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,ReactionMechanism],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"A template simulation whose methodology should be reproduced in running this simulation. Option values will be inherited from the template simulation, but can be individually overridden by directly specifying values for those options to this simulation function."
		},
		OutputOption,
		UploadOption
	}
];



(* ::Subsubsection:: *)
(*SimulateReactivity*)

Warning::UnsupportedMethod = "Unable to use Base method on degenerate sequences due to vagueness of pairing rules on degenerate sequences. Will default to Motif method.";
Error::InconsistentReactants = "There is Structure specified in Reactions option that is not included in input. Please check if all structures in Reactions option also appear in the inpit.";


InputPatternSimulateMechanismP = Alternatives[
	ReactionMechanismP,
	ObjectP[Object[Simulation,ReactionMechanism]],
	StateP,
	{InitialConditionP..},
	{SpeciesP..}
];


SimulateReactivity[in: InputPatternSimulateMechanismP, ops:OptionsPattern[]]:= Module[
	{startFields, initialState, inList, definitionNumber, outputSpecification, output, listedOptions, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests, unresolvedOptions, templateTests, combinedOptions, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, optionsRule, previewRule, testsRule, resultRule, mech},
	
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Get simulation options which account for when Option Object is specified *)
	listedOptions = ToList[ops];

	(* set object creation timestamp and populate packet start fields *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateReactivity,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateReactivity,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get mechanism if input is an Object *)
	inList = If[MatchQ[in,ObjectP[Object[Simulation,ReactionMechanism]]],
		in[ReactionMechanism],
		in
	] /. s_Strand:>flattenDegenerate[s];

	(* Get definition number for validlengths call *)
	definitionNumber = If[MatchQ[inList, ReactionMechanismP],
		2,
		1
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests} = Quiet[
		If[gatherTests,
			ValidInputLengthsQ[SimulateReactivity,{in},listedOptions,definitionNumber,Output->{Result,Tests}],
			{ValidInputLengthsQ[SimulateReactivity,{in},listedOptions,definitionNumber],{}}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[Join[safeOptionTests,validLengthTests]],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateReactivity,{inList},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateReactivity,{inList},listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult = Check[
		(* format input model into initial state before resolving options *)
		{initialState,resolvedOptions,resolvedOptionsTests} = With[{testInitialState = resolveInputsSimulateMechanism[inList]},
			If[gatherTests,
				Join[{testInitialState},resolveOptionsSimulateMechanism[testInitialState,combinedOptions, Output->{Result,Tests}]],
				{testInitialState,resolveOptionsSimulateMechanism[testInitialState,combinedOptions],{}}
			]
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* generate ReactionMechanism *)
		mech = Quiet[simulateMechanismCore[initialState, resolvedOptions]];
	];


	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		Module[{},
			(* Check for valid mechanism *)
			If[MatchQ[mech, ReactionMechanismP],
				PlotReactionMechanism[mech],
				$Failed
			]
		],
		Null
	];
	
	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,{resolvedOptionsTests}]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || resolvedOptions===$Failed,
			$Failed,
			Module[{result, endFields, packetList},

				(* Check for valid mechanism *)
				packetList = If[MatchQ[mech, ReactionMechanismP],
					(* create simulation packet end information *)
					endFields = simulationPacketStandardFieldsFinish[resolvedOptions];

					(* organize all information and simulation results into corresponding object fields *)
					ToList[formatOutputSimulateMechanism[startFields, endFields, initialState, mech, resolvedOptions]],

					(* else failed *)
					{$Failed}
				];

				If[Lookup[resolvedOptions, Upload],
					If[MemberQ[packetList, $Failed],
						$Failed,
						First[uploadAndReturn[packetList]]
					],
					First[packetList]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection:: *)
(*ValidSimulateReactivityQ*)

DefineOptions[ValidSimulateReactivityQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateReactivity}
];

Authors[ValidSimulateReactivityQ] := {"brad"};

ValidSimulateReactivityQ[myInput: InputPatternSimulateMechanismP, myOptions:OptionsPattern[ValidSimulateReactivityQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	(* get mechanism if input is an Object *)
	listedInput = ToList[If[MatchQ[myInput,ObjectP[Object[Simulation,ReactionMechanism]]],
		myInput[ReactionMechanism],
		myInput
	]];
	listedObjects = Cases[ToList[myInput], ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];
	(* Call the function to get a list of tests *)
	functionTests = SimulateReactivity[myInput,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedObjects,OutputFormat->Boolean];

			If[!MatchQ[listedObjects, {}],
				voqWarnings = MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{listedObjects,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[{initialTest},functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	RunUnitTest[<|"ValidSimulateReactivityQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidSimulateReactivityQ"]
];



(* ::Subsubsection:: *)
(*SimulateReactivityOptions*)

Authors[SimulateReactivityOptions] := {"brad"};

SimulateReactivityOptions[in: InputPatternSimulateMechanismP, ops : OptionsPattern[SimulateReactivity]] := Module[{listedOptions, noOutputOptions},
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	SimulateReactivity[in, PassOptions[SimulateReactivity, Append[noOutputOptions, Output->Options]]]
];



(* ::Subsubsection:: *)
(*SimulateReactivityPreview*)

Authors[SimulateReactivityPreview] := {"brad"};

SimulateReactivityPreview[in: InputPatternSimulateMechanismP, ops : OptionsPattern[SimulateReactivity]] := Module[
	{listedOptions, noOutputOptions},
	
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	SimulateReactivity[in, PassOptions[SimulateReactivity, Append[noOutputOptions, Output->Preview]]]
];


(* ::Subsubsection::Closed:: *)
(*validReactionsOptionsTestOrEmpty*)

validReactionsOptionsTestOrEmpty[initialState_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::InconsistentReactants];
		Message[Error::InvalidInput,initialState];
	]
];


(* ::Subsubsection:: *)
(*resolveOptionsSimulateMechanism*)

DefineOptions[resolveOptionsSimulateMechanism,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveOptionsSimulateMechanism[initialState_,unresolvedOptions_List, ops:OptionsPattern[]]:=Module[
	{method, safeOps, resolvedOptions, output, listedOutput, collectTestsBoolean, expandedOptions, messagesBoolean, allTests},

	(* From resolveSimulateFoldingOptions's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	expandedOptions = Last[ExpandIndexMatchedInputs[SimulateReactivity,{initialState},unresolvedOptions]];
	safeOps = safeSimulateOptions[SimulateReactivity, unresolvedOptions];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean = !collectTestsBoolean;

	(* Gather all the tests (this will be a list of Nulls if !Output->Test) *)
	allTests = validReactionsOptionsTestOrEmpty[initialState,collectTestsBoolean,"Reaction option is valid for initial state",validReactionsOptionQ[initialState, Lookup[safeOps, Reactions]]];

	method = resolveSimulateMechanismOptionMethod[initialState, Lookup[safeOps, Method]];

	If[MatchQ[method, $Failed], Message[Error::InvalidOption,Lookup[safeOps, Method]]];

	resolvedOptions = If[MatchQ[method, $Failed] || !validReactionsOptionQ[initialState, Lookup[safeOps, Reactions]],
		$Failed,
		ReplaceRule[
			unresolvedOptions,
			{
				Method -> method,
				Temperature -> resolveSimulateMechanismOptionTemperature[initialState, Lookup[safeOps, Temperature]]
			}
		]
	];

	output/.{Tests->allTests,Result->resolvedOptions}
];


validReactionsOptionQ[initialState_, All] := True;
validReactionsOptionQ[initialState_, interactions_] := SubsetQ[initialState[Species] /. x: {_Bond..} :> Sort[x], DeleteDuplicates[DeleteCases[Flatten[(Delete[#, 0] & /@ interactions)], _Integer]] /. x: {_Bond..} :> Sort[x]];


resolveSimulateMechanismOptionMethod[in: ReactionMechanismP, Automatic] := Null;
resolveSimulateMechanismOptionMethod[in: ReactionMechanismP, method_] := method;
resolveSimulateMechanismOptionMethod[initialState_State, Null] := resolveSimulateMechanismOptionMethod[initialState, Base];
resolveSimulateMechanismOptionMethod[in_, Null] := Motif;
resolveSimulateMechanismOptionMethod[in_, method: Motif] := method;
resolveSimulateMechanismOptionMethod[initialState_State, method: Base] := Module[
	{checks},
	checks = Flatten[initialState[Species][Sequences]];

	Switch[checks,
		{(_Integer|_String?(StringMatchQ[#,"N"..]&))..}, Message[Warning::UnsupportedMethod]; Motif,
		{_String..}, Base
	]
];

resolveSimulateMechanismOptionMethod[initialState_State, method: Automatic] := Module[
	{motifNames,sequences},
	motifNames = Flatten[initialState[Species][Names]] /. ""->Null;
	sequences = Flatten[initialState[Species][Sequences]];

	Which[
		MatchQ[motifNames,{Null..}], Base,
		AllTrue[sequences,StringMatchQ[#,"N"..]&], Motif,
		MatchQ[sequences,{_String..}], Base,
		MatchQ[motifNames,{_String..}], Motif,
		True, Base
	]
]


resolveSimulateMechanismOptionTemperature[in_, temp_?TemperatureQ] := temp;
resolveSimulateMechanismOptionTemperature[in_, temp_Function] := temp;
resolveSimulateMechanismOptionTemperature[in: ReactionMechanismP, Null] := Quantity[37, Celsius];
resolveSimulateMechanismOptionTemperature[in_, Null] := Null;


(* ::Subsubsection::Closed:: *)
(*resolveInputsSimulateMechanism*)


resolveInputsSimulateMechanism[in: ReactionMechanismP] := in;

resolveInputsSimulateMechanism[in: {SpeciesP..}] := resolveInputsSimulateMechanism[State[Sequence @@ Map[{ToStructure[#], 10 Micromolar} &, in]]];
resolveInputsSimulateMechanism[in: {InitialConditionP..}] := resolveInputsSimulateMechanism[ToState[in]];
resolveInputsSimulateMechanism[in: StateP] := Module[
	{flag},
	flag = Switch[Flatten[in[Species][Sequences]],
		{_Integer..}, False,
		_, True
	];
	splitOneStructureRule[#, flag] & /@ in
];
splitOneStructureRule[{struct_Structure, conc: _?NumericQ|_?ConcentrationQ|_?AmountQ}, False] := Sequence @@ ({#, conc} & /@ SplitStructure[struct]);
splitOneStructureRule[{struct_Structure, conc: _?NumericQ|_?ConcentrationQ|_?AmountQ}, True] := Sequence @@ ({# /. {DNA[x_Integer, y___] :> DNA[StringRepeat["N", x], y], RNA[x_Integer, y___] :> RNA[StringRepeat["N", x], y]}, conc} & /@ SplitStructure[struct]);


(* ::Subsubsection:: *)
(*simulateMechanismCore*)


simulateMechanismCore[initialState: ReactionMechanismP, resolvedOps_] := addKineticRatesToMechanism[initialState, Lookup[resolvedOps, Temperature], resolvedOps];

simulateMechanismCore[initialState: StateP, resolvedOps_] := Module[
	{foldingOps, hybridizationOps, mech, verbose = False},

	foldingOps = SafeOptions[SimulateFolding, {PassOptions[SimulateReactivity, SimulateFolding, Join[
		ReplaceRule[resolvedOps, {Upload->False, Output->Result, Template->Null, Method->Kinetic, Temperature->Replace[Lookup[resolvedOps, Temperature], Null->37 Celsius], Depth->Lookup[resolvedOps,FoldingDepth]}],
		{MinLevel->Lookup[resolvedOps, MinFoldLevel], Breadth->Infinity}
	]]}];
If[verbose,Print["FoldingOps: ",foldingOps]];
	hybridizationOps = SafeOptions[SimulateHybridization, {PassOptions[SimulateReactivity, SimulateHybridization, Join[
		ReplaceRule[resolvedOps, {Upload->False, Output->Result, Template->Null, Method->Energy, Temperature->Replace[Lookup[resolvedOps, Temperature], Null->37 Celsius], Depth->Lookup[resolvedOps,HybridizationDepth]}],
		{MinLevel->Lookup[resolvedOps, MinPairLevel], Folding->Lookup[resolvedOps, InterStrandFolding]}
	]]}];
If[verbose,Print["HybridOps: ",hybridizationOps]];
	mech = If[MatchQ[Lookup[resolvedOps, Reactions], _List],
		reactionsMechanism[Lookup[resolvedOps, Reactions], resolvedOps, foldingOps, hybridizationOps],
If[verbose,Print["Switching: ",Lookup[resolvedOps, Method]]];
		Switch[Lookup[resolvedOps, Method],
			Motif, generateMotifMechanism[initialState, resolvedOps],
			Base, generateBaseMechanism[initialState, resolvedOps, foldingOps, hybridizationOps]
		]
	];
If[verbose,Print["Mech: ",mech]];
	Switch[Lookup[resolvedOps, Temperature],
		Null, mech,
		_, addKineticRatesToMechanism[mech, Lookup[resolvedOps, Temperature], resolvedOps]
	]
];


(* ::Subsubsection::Closed:: *)
(*formatOutputSimulateMechanism*)


formatOutputSimulateMechanism[startFields_,endFields_, initialState_, mech_, resolvedOps_] := Module[
	{finalPacket},

	finalPacket = <|Join[
		{Type -> Object[Simulation, ReactionMechanism]},
		startFields,
		{
			ReactionMechanism->mech,
			InitialState -> (initialState /. x: ReactionMechanismP -> Null),
			Replace[Species] -> SpeciesList[mech]
		},
		{
			Temperature -> (Temperature/.resolvedOps)
		},
		endFields
	]|>
];


(* ::Subsection:: *)
(*reactionsMechanism*)


(* ::Subsubsection:: *)
(*reactionsMechanism*)


reactionsMechanism[interactions_, resolvedOps_, foldingOps_, hybridizationOps_] := Module[
	{mech},

	mech = ReactionMechanism[Join @@ (interactions /. interactionMechanismRules[resolvedOps, foldingOps, hybridizationOps])]
];


interactionMechanismRules[ops_, foldingOps_, hybridizationOps_] := {
	FoldingReaction[stuff_Structure] :> foldingPart[{stuff}, foldingOps][[2]],
	FoldingReaction[stuff_Structure, int_List] :> foldingPart[{stuff}, ReplaceRule[foldingOps, FoldingInterval -> {1,int}]][[2]],
	HybridizationReaction[stuff1_Structure] :> hybridizationFullStep[{stuff1, stuff1}, hybridizationOps, Lookup[ops, IntraStrandFolding], foldingOps, PairSelf->False][[2]],
	HybridizationReaction[stuff1_,stuff2_] :> hybridizationFullStep[{stuff1, stuff2}, hybridizationOps, Lookup[ops, IntraStrandFolding], foldingOps, PairSelf->False][[2]],
	MeltingReaction[stuff_Structure] :> meltingPart[{stuff}][[2]],
	ToeholdStrandExchangeReaction[stuff1_, stuff2_] :> Cases[toeholdPart[{stuff1, stuff2}][[2]], Reaction[_, _, ToeholdMediatedStrandExchange]],
	ToeholdDuplexExchangeReaction[stuff1_, stuff2_] :> Cases[toeholdPart[{stuff1, stuff2}][[2]], Reaction[_, _, ToeholdMediatedDuplexExchange]],
	DualToeholdDuplexExchangeReaction[stuff1_, stuff2_] :> Cases[toeholdPart[{stuff1, stuff2}][[2]], Reaction[_, _, DualToeholdMediatedDuplexExchange]]
};


(* ::Subsection:: *)
(*generateMotifMechanism*)


(* ::Subsubsection:: *)
(*generateMotifMechanism*)


generateMotifMechanism[initialState: StateP, resolvedOps_] := Module[
	{initial, sortedIC, reactions, mechTemp},

	initial = {Rule@@@(List@@initialState)};
	sortedIC = initial /. com: StructureP :> StructureSort[com];

	(* Use expand to get the ReactionMechanism *)
	reactions = Cases[expand[{},{},{},mol[sortedIC],Unitless[Lookup[resolvedOps, Time], Second]], Except[Reaction[_, _, Unknown]]];

	(* Convert to ReactionMechanism[__] and prune non-dominant reactons *)
	mechTemp = ReactionMechanism @@ (reactions /. x_Structure :> NucleicAcids`Private`reformatBonds[x, StrandBase]);

	First[reactionPruner[mechTemp, initialState, Lookup[resolvedOps, PrunePercentage], Lookup[resolvedOps, Temperature]]]
];


(* ::Subsubsection::Closed:: *)
(*expand*)


(* expand does all the work *)
expand[in2:{{_Structure,_Structure}...}, in1:{_Structure...}, reactions:{_Reaction...}, initial:{{_Rule..}..}, tFinal_] := Module[
	{species,peak,next1,next2,highSpecies,highPeak,shapeSpecies,shapePeak, verbose = False, newReactions,firstPrivateNext},

	If[verbose,
		Union@@(select[reactions, #, tFinal]& /@ initial) // PlotReactionMechanism // Print
	];

	species = DeleteDuplicates[Cases[{reactions,initial},_Structure,Infinity]]; (* Find all the species *)

	peak = simulate[species, reactions, #, tFinal]& /@ initial;

If[verbose,Print["Species: ",species]];
If[verbose,Print["Reactions: ",reactions]];
If[verbose,Print["Initial: ",initial]];
If[verbose,Print["Peak: ",Short[peak]]];

	shapeSpecies = Dimensions[species];
	shapePeak = Dimensions[peak];
	peak = N[Max /@ Transpose[peak, {3,2,1}]];
	next1 = Complement[Pick[species, Thread[peak>10^-15]], in1];

	(* keep going until no new first order reactions *)
	firstPrivateNext = Flatten[firstPrivate/@next1];
	newReactions = simplify[Union[reactions,firstPrivateNext]];
	newReactions = DeleteCases[ newReactions, Reaction[r_,p_,Zipping|Unzipping]];

	If[next1 =!= {},
		Return[
			expand[
				in2,
				Union[in1,next1],
				newReactions,
				initial,
				tFinal
			]
		]
	];

	highSpecies = Pick[species, Thread[peak>10^-20/Max[peak]]];
	highPeak = N[Pick[peak, Thread[peak>10^-20/Max[peak]]]];
	next2 = Complement[Pick[Subsets[highSpecies,{2}], Thread[Times@@@Subsets[highPeak,{2}] > 10^-20]], in2];

	(*  keep going until no new second order reactions *)
	If[next2 =!= {},
		Return[
			expand[
				Union[in2,next2],
				in1,
				simplify[Union[reactions,Flatten[second@@@next2]]],
				initial,
				tFinal
			]
		]
	];

	(* when done, trim away "fuzz" around the edges *)
	Union@@(select[Cases[reactions, Except[Reaction[_, _, Unknown]]], #, tFinal]& /@ initial)
];


mol[x_ -> y_Quantity] := x -> Unitless[y, Molar];
mol[x_ -> y_] := x -> y;
SetAttributes[mol, {Listable}];

lastPrivate[{}] := {Null, Null};
lastPrivate[list_List] := Last[list];

(* Identify the highest-concentration species not already flagged by in *)
next[species_, max_, in_] := With[{pairs = Transpose[{max,species}]},
	lastPrivate@Sort@Select[pairs, !MemberQ[in,Last[#]]&]
];

(* No reactions -> flatline concentrations *)
simulate[species:{_Structure..}, {}, initial:{_Rule..}, tFinal_] :=
	Transpose[List /@ (species /. initial /. Thread[species->0.])]

simulate[species:{_Structure..}, reactions:{_Reaction..}, initial:{_Rule..}, tFinal_] :=(
	SimulateKinetics[
		ReactionMechanism@@reactions,
		initial,
		tFinal,
		Upload->False
	][Trajectory][Concentrations]
)

pow[x_,0] := 1;
pow[x_,y_] := x^y;

select[___] := {};
select[reactions:{_Reaction..}, initial:{_Rule..}, tFinal_] :=
	Module[{R,P,k,species,inverse,traj,time,x,flux,tot},
		{R,P,k,species} = reactantProductMatrices[Map[addKineticRatesToReaction[#, (273.15+37), SafeOptions[SimulateReactivity]] &, reactions] /. x_Quantity :> Unitless[x]];

		(* Identify reactions that are inverse of each other *)
		inverse = Boole[Outer[SameQ, Transpose[P-R], Transpose[R-P], 1]];
		(* Figure out x versus time *)

		traj = Lookup[SimulateKinetics[{R,P,k,species}, species/.initial/.Thread[species->0.], tFinal, Upload->False],Trajectory, $Failed];

		time = traj[[3]];
		x = traj[[2]];
		(* Figure out rate of each reaction at each point in time *)
		flux = Inner[pow, x, R, Times].DiagonalMatrix[k];

		flux = flux - flux.inverse;
		flux = Most[flux]*Differences[time];
		tot = Total[flux];

		(*Pick[reactions, Thread[tot > 10^-12]]*)
		Pick[reactions, Thread[tot >= 0.]]
	]

zip[x_Structure] :=
	With[{
		options = Cases[firstOrder[x], Reaction[{in_Structure},{out_Structure},Zipping] :> out]
	},
		If[Length[options] > 0,
			zip[First[options]]
			, (* else *)
			x
		]
	]

(* simplify[{_Reaction...}] determines all zipping reactions and fast-forwards through them *)
simplify[{}] := {}

simplify[reactions:{_Reaction..}] := Union[simplify/@reactions]

(* don't zip unzipping products! *)
simplify[reaction:Reaction[inputs_,products_,Unzipping]] := reaction;
(* zip everything else *)
simplify[reaction:Reaction[inputs_,products_,type_]] :=
		reaction /. x_Structure :> zip[x]


second[x__] :=
	Cases[
		Flatten[secondOrder[x]],
		Reaction[in_,out_,Except[0]] /; in =!= out,
		{1}
	];

firstPrivate[x__] :=
	Cases[
		Flatten[firstOrder[x]],
		Reaction[in_,out_,Except[0]] /; in =!= out,
		{1}
	];

subRates[reactions_List] :=
	Replace[reactions, Reaction[in_,out_,rate_] :> Reaction[in,out, rate], {1}];


(* ::Subsubsection::Closed:: *)
(*bondMotifs*)


bondMotifs[strands:{_Strand..}, Bond[{a_,b_},{c_,d_}]] :=
	{ParseStrand[strands[[a]]][[b]], ParseStrand[strands[[c]]][[d]]}

bondMotifs[strands:{_Strand..}, {Bond[{a_,b_},{c_,d_}]}] :=
	{ParseStrand[strands[[a]]][[b]], ParseStrand[strands[[c]]][[d]]}

bondMotifs[{_Strand..}, {}] := Sequence[]

bondMotifs[strands1:{_Strand..}, strands2:{_Strand..}, Bond[{a_,b_},{c_,d_}]] :=
	{ParseStrand[strands1[[a]]][[b]], ParseStrand[strands2[[c]]][[d]]}
(* Call to this is commented out, so it will never happen *)


(* ::Subsubsection::Closed:: *)
(*secondOrderDuplexExchange*)


secondOrderDuplexExchange[c1:Structure[strands1_, pairs1_],
							c2:Structure[strands2_, pairs2_],
							bond_,
							partner1_,
							partner2_] := "secondOrderDuplexExchange -- IMPOSSIBLE!"



(* ::Subsubsection::Closed:: *)
(*secondOrderStrandExchange*)


(*  *)
secondOrderStrandExchange[c1:Structure[strands1_, pairs1_],
							c2:Structure[strands2_, pairs2_],
							form_,
							p1_,
							p2_] :=
	Cases[Reaction[Sort@{c1, c2},
				pairAndSplit[c1,c2,{form}],
				ClassifyReaction[Sort@{c1, c2}, pairAndSplit[c1,c2,{form}]]
	], Except[Reaction[_, _, Unknown]]];



(* ::Subsubsection::Closed:: *)
(*secondOrderPairingInternal*)


(* naked Pairing *)
secondOrderPairingInternal[c1:Structure[strands1:{_Strand..}, pairs1:{BondP...}],
					 c2:Structure[strands2:{_Strand..}, pairs2:{BondP...}],
					 form:Bond[{a_,b_},{c_,d_}]] :=
	Reaction[Sort@{c1, c2},
				pairAndSplit[c1,c2,{form}],
				Hybridization
	];


(* ::Subsubsection::Closed:: *)
(*pairAndSplit*)

Authors[pairAndSplit]:={"scicomp", "brad"};
pairAndSplit[comp1:Structure[strands1_,pairs1_], comp2:Structure[strands2_,pairs2_], new:{_Bond..}] :=
	Module[{strands,pairs,newShifted},
		strands = Join[strands1, strands2];
		pairs = Join[pairs1, NucleicAcids`Private`offsetPairs[pairs2, Length[strands1]]];
		newShifted = NucleicAcids`Private`offsetPairs[new, 0, Length[strands1]];
		pairs = deleteBrokenPairs[pairs, newShifted];
		pairs = Join[pairs, newShifted];
		SplitStructure[Structure[strands, pairs]]
	]
pairAndSplit[comp:Structure[strands_,pairs_], new:{_Bond..}] :=
	Module[{newPairs},
		newPairs = deleteBrokenPairs[pairs, new];
		newPairs = Join[newPairs, new];
		SplitStructure[Structure[strands, newPairs]]
	]



(* ::Subsubsection::Closed:: *)
(*structureAdjacency*)


(* Gives adjacency matrix of a Structure *)
structureAdjacency[struct:Structure[strands:{_Strand..}, pairs:{BondP...}]] :=
		Module[{lengths, index, rules, dim},
			lengths = Length /@ strands;
			index = structureIndices[struct];
			rules = Map[index[[ #[[1]], #[[2]] ]]&, pairs, {2}];
			rules = List @@@ rules;

			dim = Total[lengths]*{1,1};
			SparseArray[If[lengths==={1},{},{Band[{1,2}]->Flatten[Riffle[ConstantArray[1,#]& /@ (lengths - 1), 0]]}], dim] + (* covalent *)
					SparseArray[Join[Thread[rules->1], Thread[Reverse /@ rules->1]], dim] (* Pairing *)
		]



(* ::Subsubsection::Closed:: *)
(*graphSplit*)


graphSplit[A_?MatrixQ] := graphSplit[AdjacencyGraph[Simulation`Private`BoolOr[A,Transpose[A]]]]

graphSplit[graph_Graph] :=
		With[{
			groups = NucleicAcids`Private`splitIndices[graph]
		},
			Subgraph[graph,#]& /@ groups
		]


(* ::Subsubsection::Closed:: *)
(*separation*)


(*  *)
separation[Structure[strands:{_Strand..}, pairs:{BondP...}], bond:{{a_,b_},{c_,d_}}] :=
	With[{
		result = graphSplit[Structure[strands, Complement[pairs, {bond}]]]
	},
			Cases[Reaction[{Structure[strands, pairs]},
					result,
					ClassifyReaction[{Structure[strands, pairs]}, result]
			], Except[Reaction[_, _, Unknown]]]
	]


(* ::Subsubsection::Closed:: *)
(*hubMatrix*)


(* Figure out which motifs are joined in hubs *)
hubMatrix[c:Structure[strands:{_Strand..}, pairs:{BondP...}]] :=
	Module[{lengths, index, rules, dim, covalent, pairmat, hubbed},
		lengths = Length /@ strands;
		index = structureIndices[c];
		rules = Map[index[[ #[[1]], #[[2]] ]]&, pairs, {2}];
		rules = List @@@ rules;

		dim = Total[lengths]*{1,1};

		covalent = SparseArray[If[lengths==={1},{},{Band[{1,2}]->Flatten[Riffle[ConstantArray[1,#]& /@ (lengths - 1), 0]]}], dim]; (* covalent *)
		pairmat = SparseArray[Join[Thread[rules->1], Thread[Reverse /@ rules->1]], dim]; (* Pairing *)

		hubbed = BoolOr[
			pairHopper[covalent,pairmat,IdentityMatrix[First[dim]]],
			covalentHopper[covalent,pairmat,IdentityMatrix[First[dim]]]
		];
		BoolOr[hubbed,Transpose[hubbed]]
	]



(* ::Subsubsection::Closed:: *)
(*pairHopper*)


(* result = pairHopper[covalent,paired,hubbed]
 * If :
 *   covalent(i,j) = 1 if motif i is connected at its 3' end to motif j at its 5' end
 *                   0 otherwise
 *   paired(i,j) = 1 if motif i is base-paired to motif j
 *                 0 otherwise
 *   hubbed(i,j) = 1 or 0 if motif i participates in a hub with motif j
 *                 0 otherwise
 * Then:
 * result(i,j) = 1 if motif i participates in a hub with motif j
 *               0 otherwise
 *)
pairHopper[covalent_, paired_, hubbed_] :=
	With[{
		next = BoolAnd[paired.hubbed, BoolNot[IdentityMatrix[Length[paired]]]] (* break infinite recursion in cyclic hub *)
	},
		If[Total[next,2]>0,
			BoolOr[hubbed, covalentHopper[covalent,paired,next]],
			hubbed
		]
	]



(* ::Subsubsection::Closed:: *)
(*covalentHopper*)


covalentHopper[covalent_, paired_, hubbed_] :=
	With[{
		next = BoolAnd[covalent.hubbed, BoolNot[IdentityMatrix[Length[paired]]]] (* break infinite recursion in cyclic hub *)
	},
		If[Total[next,2]>0,
			BoolOr[hubbed, pairHopper[covalent,paired,next]],
			hubbed
		]
	]



(* ::Subsubsection::Closed:: *)
(*reactantProductMatrices*)


reactantProductMatrices[reactions:{_Reaction..}] :=
	With[{
		species = DeleteDuplicates[Cases[reactions,_Structure,{3}]]
	},
		Append[reactantProductMatrices[reactions, species], species]
	]




reactantProductMatrices[reactions:{_Reaction..}, species:{_Structure..}] :=
	Module[{reactants, products, index, R, P, k, rules},
		reactants = reactions[[All,1]];
		products = reactions[[All,2]];
		k = reactions[[All,3]];

		index = Thread[species->Range[Length[species]]];

		reactants = Replace[reactants, index, {2}];
		products = Replace[products, index, {2}];

		rules = Flatten@MapIndexed[rrule, reactants];
		R = SparseArray[rules, {Length[species], Length[reactions]}];

		rules = Flatten@MapIndexed[rrule, products];
		P = SparseArray[rules, {Length[species], Length[reactions]}];

		{R,P,k}
	]



(* ::Subsubsection::Closed:: *)
(*findRC*)


(* Need this to make findRC work properly *)
andListable[in___]:=And[in]
SetAttributes[andListable,Listable]

findRC[x_Strand, y_Strand] := findRC[x,y] =
	Position[andListable[Outer[SameQ, x[Names], y[Names]] , Outer[UnsameQ, x[RevComps], y[RevComps]]], True]

findRC[strands:{_Strand..}] :=
	Flatten[
		Table[
			Bond[{i,First[bond]},{j,Last[bond]}],
			{i,Length[strands]},
			{j,i,Length[strands]},
			{bond,
				If[i==j,
					DeleteDuplicates[Sort /@ findRC[strands[[i]], strands[[j]]]],
					findRC[strands[[i]], strands[[j]]]
				]
			}
		],
		2
	]

findRC[Structure[strands:{_Strand..},___]] :=
	findRC[strands]

findRC[strands1:{_Strand..}, strands2:{_Strand..}] :=
	Flatten[
		Table[
			Bond[{i,First[bond]},{j,Last[bond]}],
			{i,Length[strands1]},
			{j,Length[strands2]},
			{bond, findRC[strands1[[i]], strands2[[j]]]}
		],
		2
	]

findRC[Structure[strands1:{_Strand..},___], Structure[strands2:{_Strand..},___]] :=
	findRC[strands1, strands2]


(* ::Subsubsection:: *)
(*secondOrder*)


(*  make reactions for second order pairingns *)
secondOrder::multiplePartners="Strand `1` or `2` has multiple partners" ;
secondOrder[list1:{StructureP..},list2:{StructureP..}]:=MapThread[secondOrder[#1,#2]&,{list1,list2}];/;SameLengthQ[list1,list2]

(* Sometimes structures get embedded into lists during rendering *)
secondOrder[{strand1_}, strand2_] := secondOrder[strand1, strand2]
secondOrder[strand1_, {strand2_}] := secondOrder[strand1, strand2]
secondOrder[{strands__}] := secondOrder[strands]

secondOrder[strand1_String, strand2_String] :=
	secondOrder[Structure[strand1], Structure[strand2]]

secondOrder[c1_Structure, c2_Structure] :=
	secondOrder[c1, c2, #]& /@ findRC[c1,c2]

secondOrder[c1:Structure[strands1:{_Strand..}, pairs1:{BondP...}],
			c2:Structure[strands2:{_Strand..}, pairs2:{BondP...}],
			bond:Bond[{a_,b_},{c_,d_}]] :=
	With[{
		p1 = Cases[pairs1, Bond[{a,b},{_,_}]|Bond[{_,_},{a,b}]],
		p2 = Cases[pairs2, Bond[{c,d},{_,_}]|Bond[{_,_},{c,d}]]
	},
		Switch[Length /@ {p1,p2},
			{1,1}, (* If both are bound, this is going to be very unlikely *)
				{}(*secondOrderDuplexExchange[c1, c2, bond, partner1, partner2 ]*),
			{1,0}|{0,1}, (* If one is bound, still pretty unlikely *)
				{},(*secondOrderStrandExchange[c1, c2, bond, p1, p2],*)
			{0,0}, (* If neither is bound then this is reasonable *)
				secondOrderPairingInternal[c1, c2, bond],
			_, Message[secondOrder::multiplePartners, strands1[[a]], strands2[[c]]]
		]
	]


(* ::Subsubsection::Closed:: *)
(*partner*)


(* Returns the Pairing partner of {a,b}, if it exists *)
partner[pairs_, {a_,b_}] :=
	FirstOrDefault[Cases[pairs, Bond[{a,b},{c_,d_}]|Bond[{c_,d_},{a,b}] :> {c,d}]]


(* ::Subsubsection::Closed:: *)
(*acrossQ*)


(* Returns True if there is an adjacent toehold *)
acrossQ[pairs_, {{a_,b_}, {c_,d_}}] := acrossQ[pairs, {a,b}, {c,d}]
acrossQ[pairs_, {a_,b_}, {c_,d_}] :=
	MemberQ[pairs, Bond[{a,b-1},{c,d+1}]|Bond[{c,d+1},{a,b-1}]|Bond[{a,b+1},{c,d-1}]|Bond[{c,d-1},{a,b+1}]]


(* ::Subsubsection::Closed:: *)
(*pairingMatrix*)


(* Gives adjacency matrix of a Structure *)
pairingMatrix[c:Structure[strands:{_Strand..}, pairs:{BondP...}]] :=
	Module[{lengths, index, rules, dim},
		lengths = Length /@ strands;
		index = structureIndices[c];
		rules = Map[index[[ #[[1]], #[[2]] ]]&, pairs, {2}];
		rules = List @@@ rules;

		dim = Total[lengths]*{1,1};

		SparseArray[Join[Thread[rules->1], Thread[Reverse /@ rules->1]], dim] (* Pairing *)
	]



(* ::Subsubsection::Closed:: *)
(*structureIndices*)


(* Gives a unique index to each motif.  The indices are returned in a nested list structure with the
	 shape # strands x # motifs (same format as strands_)*)
structureIndices[Structure[strands:{_Strand..},___]] :=
		Module[{lengths, offsets},
			lengths = Length /@  strands;
			offsets = Accumulate[lengths]-lengths;
			Range[offsets+1,offsets+lengths]
		]




(* ::Subsubsection::Closed:: *)
(*parseStructure*)


parseStructure[in:StructureP] := List @@ ParseStrand /@ First[in];



(* ::Subsubsection::Closed:: *)
(*firstOrder*)


(*  make reactions for first order pairings *)

firstOrder[list:{StructureP..}]:=firstOrder/@list
firstOrder[{x_}] := firstOrder[x] (* Sometimes structures get embedded into lists during rendering *)
firstOrder[x_Strand] := 	firstOrder[Structure[x]]
firstOrder[cx:Structure[strands:{_Strand..}, pairs:{BondP...}]] :=
	Module[{mtfs,nms,revc,idx,rc,distance,pairMat,anyPair,i,j,ii,jj,bnd,new,newPairs,newStructure,hubReactions,sepReactions,motifLengths},
		mtfs = Strand @@ Flatten[strands,Infinity,Strand];
		nms = mtfs[Names];
		revc = mtfs[RevComps];
		idx = structureIndices[cx];
		rc = BoolAnd[Boole[Outer[SameQ, nms, nms]], Boole[Outer[UnsameQ, revc, revc]]];
		distance = GraphDistanceMatrix[AdjacencyGraph[structureAdjacency[cx],DirectedEdges->False]];
		pairMat = pairingMatrix[cx];
		anyPair = Total[pairMat];

	hubReactions = Table[

			{i,j} = bnd;

			Switch[anyPair[[{i,j}]],
				{1,1}, (* this is a 4-way reaction *)
					ii = First@BoolFind[pairMat[[i]]]; (* current partner of i *)
					jj = First@BoolFind[pairMat[[j]]]; (* current partner of j *)
					new = Flatten[Position[idx,#]& /@ {i,j,ii,jj},1]; (* identify {strand, motif} location of these indices *)
					(*Print["Del " <> ToString@{Bond@@Sort@new[[{1,3}]], Bond@@Sort@new[[{2,4}]]}];
					Print["Add " <> ToString@{Bond@@Sort@new[[{1,2}]], Bond@@Sort@new[[{3,4}]]}];*)
					newPairs = Union[Complement[pairs, {Bond@@Sort@new[[{1,3}]], Bond@@Sort@new[[{2,4}]]}], {Bond@@Sort@new[[{1,2}]], Bond@@Sort@new[[{3,4}]]}]; (* delete some bonds, add others *)
					newStructure = Structure[strands, newPairs] // SplitStructure;
					Reaction[{cx}, newStructure, ClassifyReaction[{cx}, newStructure]],
				{0,1}, (* i is invading j *)
					jj = First@BoolFind[pairMat[[j]]];
					new = Flatten[Position[idx,#]& /@ {i,j,jj},1];
					newPairs = Union[Complement[pairs, {Bond@@Sort@new[[{2,3}]]}], {Bond@@Sort@new[[{1,2}]]}];
					newStructure = Structure[strands, newPairs] // SplitStructure;
					Reaction[{cx}, newStructure, ClassifyReaction[{cx}, newStructure]],
				{1,0}, (* j is invading i *)
					ii = First@BoolFind[pairMat[[i]]];
					new = Flatten[Position[idx,#]& /@ {i,j,ii},1];
					newPairs = Union[Complement[pairs, {Bond@@Sort@new[[{1,3}]]}], {Bond@@Sort@new[[{1,2}]]}];
					newStructure = Structure[strands, newPairs] // SplitStructure;
					Reaction[{cx}, newStructure, ClassifyReaction[{cx}, newStructure]],
				{0,0},
					new = Flatten[Position[idx,#]& /@ {i,j},1];
					newPairs = Union[pairs, {Bond@@Sort@new}];
					newStructure = Structure[strands, newPairs] // SplitStructure;
					Switch[distance[[i,j]],
						1,
							Reaction[{cx}, newStructure, Hybridization],
						3,
							Reaction[{cx}, newStructure, Zipping],
						_,
							Reaction[{cx}, newStructure, Folding]
					]
			],

			(* loop over possible pairs that are no currently Pairing, are an odd number of steps away (accounts for geometric orientation problems), and are in hubs *)
			{bnd, BoolFind[UpperTriangularize[BoolAnd[rc, BoolNot[pairMat], Mod[distance,2], hubMatrix[cx]]]]}
		];

		motifLengths = Flatten[StrandLength[#,Total->False]& /@ strands];
		sepReactions = Table[
			{i,j} = bnd;

			new = Flatten[Position[idx,#]& /@ {i,j},1];
			newPairs = Complement[pairs, {Bond@@Sort@new}];
			newStructure = Structure[strands, newPairs] // SplitStructure;
			Reaction[{cx}, newStructure, ClassifyReaction[{cx}, newStructure]],

			(* looping over possible pairings that are less than 17 in length (one might melt in huge volume in a month) *)
			{bnd, BoolFind[UpperTriangularize[BoolAnd[pairMat, BoolLess[motifLengths,17]]]]}
		];

		Cases[Union[hubReactions, sepReactions], Except[Reaction[_, _, Unknown]]]
	]



(* ::Subsubsection::Closed:: *)
(*greedy1*)


greedy1[clist:{_Structure..}] :=
	clist~Append~Cases[
		Flatten[firstOrder /@ clist],
		Reaction[{in_Structure}, {out_Structure}, Folding | Zipping] :> {in,out}
	] // Flatten // DeleteDuplicates


(* ::Subsubsection::Closed:: *)
(*greedy2*)


greedy2[clist:{_Structure..}] :=
	clist~Append~Cases[
		Flatten[secondOrder @@@ Subsets[clist,{2}]],
		Reaction[in:{_Structure..}, out:{_Structure..}, Hybridization] :> {in,out}
	] // Flatten // DeleteDuplicates


(* ::Subsubsection::Closed:: *)
(*greedy12*)


greedy12[clist:{_Structure..}] :=
	greedy2[NestWhile[greedy1, clist, UnsameQ, 2, 5]]



(* ::Subsubsection::Closed:: *)
(*Hybridize*)


(* pair as many things as you can, and keep going up to 5 levels of Pairing *)
Options[Hybridize]={Depth->5};
Hybridize[in:(_String..),ops:OptionsPattern[Hybridize]]:=Hybridize[ToStrand[in],ops];
Hybridize[stuff__,OptionsPattern[Hybridize]] :=
	With[{
		local = Replace[
			Flatten[{stuff}],
			{
				x_Strand :> ToStructure[x],
				x_String :> ToStructure[x]
			},
			{1}
		]
	},
		NestWhile[greedy12, local, UnsameQ, 2, Max[{2,OptionValue[Depth]}]]
	]


(* ::Subsubsection::Closed:: *)
(*rrule*)


rrule[{left_,right_},{reaction_}] := {left,reaction} -> 2 /; left===right
rrule[{left_,right_},{reaction_}] := {{left,reaction}->1, {right,reaction}->1}
rrule[many_List,{reaction_}] := Thread[Thread[{many,reaction}]->1]
rrule[{left_},{reaction_}] := {left,reaction} -> 1



(* ::Subsection:: *)
(*generateBaseMechanism*)


(* ::Subsubsection:: *)
(*generateBaseMechanism*)


generateBaseMechanism[initialState_, resolvedOps_, foldingOps_, hybridizationOps_] := Module[
	{allReactions, meltProducts, meltReactions, stateIn, oneStep},

	allReactions = {};

	{meltProducts, meltReactions} = meltingPart[initialState[Species]];
	allReactions = Append[allReactions, meltReactions];

	stateIn = initialState;
	oneStep[pairInput_] := Module[
		{nextSpeciesList, reactions, stateOut},

		{nextSpeciesList, reactions, stateOut} = baseMechanismOneStep[stateIn, resolvedOps, foldingOps, hybridizationOps];
		stateIn = stateOut;
		allReactions = Append[allReactions, reactions];(*Print[allReactions];*)
		nextSpeciesList
	];

	Nest[oneStep, Join[initialState[Species], meltProducts], Lookup[resolvedOps, Depth]];

	ReactionMechanism[DeleteDuplicates[Flatten[allReactions]]]
];


(* ::Subsubsection:: *)
(*baseMechanismOneStep*)


baseMechanismOneStep[{}, resolvedOps_, foldingOps_, hybridizationOps_] := {{}, {}, {}};
baseMechanismOneStep[initialState_, resolvedOps_, foldingOps_, hybridizationOps_] := Module[
	{speciesList, allProducts, allReactions, mechanismTemp, mechanismOut, stateOut},

	speciesList = initialState[Species];
	{allProducts, allReactions} = allReactionsOneStep[speciesList, resolvedOps, foldingOps, hybridizationOps];

	mechanismTemp = ReactionMechanism[allReactions];
	If[MatchQ[mechanismTemp, ReactionMechanism[]], Return[{{}, {}, {}}]];

	{mechanismOut, stateOut} = reactionPruner[mechanismTemp, initialState, Lookup[resolvedOps, PrunePercentage], Lookup[resolvedOps, Temperature]];

	{stateOut[Species], mechanismOut[Reactions], stateOut}
];


(* ::Subsubsection:: *)
(*allReactionsOneStep*)


allReactionsOneStep[speciesList: {}, resolvedOps_, foldingOps_, hybridizationOps_] := {{}, {}};
allReactionsOneStep[speciesList: {struct_Structure}, resolvedOps_, foldingOps_, hybridizationOps_] := allReactionsOneStep[{struct, struct}, resolvedOps, foldingOps, hybridizationOps];
allReactionsOneStep[speciesList_, resolvedOps_, foldingOps_, hybridizationOps_] := Module[
	{foldProducts, foldReactions, hybridizeProducts, hybridizeReactions, allHybridizeReactions, toeholdProducts, toeholdReactions, extraFirstProducts, extraFirstReactions, allProducts, allReactions, verbose = False},

	{foldProducts, foldReactions} = foldingPart[speciesList, foldingOps];
If[verbose, Print[{foldProducts, foldReactions}]];

	{hybridizeProducts, hybridizeReactions, allHybridizeReactions} = hybridizationFullStep[speciesList, hybridizationOps, Lookup[resolvedOps, IntraStrandFolding], foldingOps];
If[verbose, Print[{hybridizeProducts, hybridizeReactions}]];

	{toeholdProducts, toeholdReactions} = toeholdPart[speciesList];
If[verbose, Print[{toeholdProducts, toeholdReactions}]];

	{extraFirstProducts, extraFirstReactions} = extraFirstOrder[speciesList, {PassOptions[SimulateHybridization, Pairing, ReplaceRule[hybridizationOps, Depth -> {1}]]}, foldingOps];
If[verbose, Print[{extraFirstProducts, extraFirstReactions}]];

	allProducts = DeleteDuplicates[Flatten[{foldProducts, hybridizeProducts, toeholdProducts, extraFirstProducts}]];
	allReactions = DeleteDuplicates[Flatten[{foldReactions, allHybridizeReactions, toeholdReactions, extraFirstReactions}]];

	{allProducts, allReactions}
];


(* ::Subsubsection::Closed:: *)
(*mechanismFullOneStep*)


mechanismFullOneStep[{}, foldingOps_, pairingOps_, foldFilter_, initialState_, resolvedOps_] := {{}, {}, {}};
mechanismFullOneStep[pairIn_, foldingOps_, pairingOps_, foldFilter_, initialState_, resolvedOps_] := Module[
	{pairOutRaw, pairOut, pairReactions, foldIn, foldOut, foldOutFiltered, foldReactions, nextPairIn, reactions, mechanismIn, mechanismOut, stateOut},

	(* first do pairing *)
	pairOutRaw = Rest[Pairing[Sequence @@ #, Sequence @@ pairingOps]] & /@ pairIn;
	If[MatchQ[Flatten[pairOutRaw], {}], Return[{{}, {}, State[]}]];

	(* format pairing results into reactions *)
	pairOut = DeleteDuplicates[Flatten[Function[{onePair}, {#, onePair[[2]]} & /@ onePair[[1]]] /@ Cases[Flatten[pairOutRaw, Min[2, Lookup[pairingOps, Depth]]], Except[{}]], 1] /. x: {_Structure, _Structure} :> Sort[x]];
	pairReactions = makeReactionPair[#[[2]], #[[1]]] & /@ pairOut;

	(* fold on pairing results and filter out inter/intra results based on option *)
	If[MatchQ[foldFilter, {False, False}],
		foldReactions = {},
		foldIn = DeleteDuplicates[First /@ pairOut];
		foldOut = kineticFolding[#, Replace[Lookup[foldingOps, FoldingInterval], All -> Null], foldingOps] & /@ foldIn;
		foldOutFiltered = MapThread[filterFoldedStructure[#1, #2, foldFilter] &, {foldIn, foldOut}];
		foldReactions = Flatten @ MapThread[Map[Function[{prod}, makeReactionFold[#1, prod]], #2] &, {foldIn, foldOutFiltered}]
	];

	(* eliminate nondominate reactions *)
	mechanismIn = ReactionMechanism[DeleteDuplicates[Join[pairReactions, foldReactions]]];
	If[MatchQ[mechanismIn, ReactionMechanism[]], Return[{{}, {}, {}}]];
	{mechanismOut, stateOut} = reactionPruner[mechanismIn, initialState, Lookup[resolvedOps, PrunePercentage], Lookup[resolvedOps, Temperature]];

	(* reformat result species into tuples ready for next level *)
	nextPairIn = If[MatchQ[stateOut[Species], {}],
		{},
		With[{allStr = DeleteDuplicates[Flatten[Join[stateOut[Species], pairIn]]]}, Complement[DeleteDuplicates[Sort /@ Tuples[{allStr, allStr}]], pairIn]]
	];

	{nextPairIn, mechanismOut[Reactions], stateOut}
];


(* ::Subsection:: *)
(*reactionPruner*)


(* ::Subsubsection:: *)
(*reactionPruner*)


reactionPruner[mech_, initialState_, prune_, temperature_] := Module[
	{eqState, total, speciesLeft, eqStateOut, mechanismOut, verbose = False},

	If[Or[MatchQ[prune, Quantity[0, "Percent"]], MatchQ[mech, ReactionMechanism[]]], Return[{mech, State@@({#, Quantity[1,"Micromolar"]} & /@ DeleteDuplicates[Flatten[mech[Products]]])}]];

	eqState = Quiet @ SimulateEquilibrium[mech, initialState, Upload -> False, Temperature -> (temperature /. Null -> 37 Celsius)][EquilibriumState];
If[verbose, Print[{eqState, initialState}]];

	total = Total[eqState[Quantities]];
	eqStateOut = Select[eqState, And[(#[[2]] > (Unitless[prune] / 100) * total), !MemberQ[initialState[Species], #[[1]]]] &];
If[verbose, Print[eqStateOut]];

	speciesLeft = eqStateOut[Species];
If[verbose, Print[speciesLeft]];

(* BEWARE: SimulateKinetics & SimulateEqulibrium consoldiate bonds, but they are not conslidated in motif-based mechansim generation *)
	mechanismOut = ReactionMechanism[Select[mech[Reactions] /. s_Structure :> NucleicAcids`Private`consolidateBonds[s] , MemberQ[speciesLeft, First[#[[2]]]] &]];
If[verbose, Print[{mech, mechanismOut[Reactions]}]];

	{mechanismOut, eqStateOut}
];


(* ::Subsection:: *)
(*single pieces*)


(* ::Subsubsection::Closed:: *)
(*meltingPart*)


meltingPart[structList_] := Module[
	{meltReactions, meltProducts},
	meltReactions = DeleteDuplicates[Flatten[meltingR /@ structList]];
	meltProducts = Cases[DeleteDuplicates[Flatten[#[Products] & /@ meltReactions]], Structure[_, {}]];
	{meltProducts, meltReactions}
];


meltingR[reactant: Structure[strs: {_Strand..}, bonds: {}]] := {};
meltingR[reactant: Structure[strs: {_Strand..}, bonds: {_Bond..}]] := Module[
	{products, productsNext, reactionsNext, reactions},
	products = Table[SplitStructure[Structure[strs, Delete[bonds, i]]], {i, 1, Length[bonds]}];
	productsNext = Cases[Flatten[products], Except[Structure[{_Strand}, {}]]];
	reactionsNext = meltingR /@ productsNext;
	reactions = DeleteDuplicates[Flatten[Join[reactionsNext, Map[makeReactionMelt[reactant, #] &, products]]]]
];


(* ::Subsubsection::Closed:: *)
(*foldingPart*)


foldingPart[{}, foldingOps_] := {{}, {}};
foldingPart[structList_, foldingOps_] := Module[
	{foldOut, foldReactions, foldProducts},
	foldOut = kineticFolding[#, Replace[Lookup[foldingOps, FoldingInterval], All -> Null], foldingOps] & /@ structList;
	foldReactions = Flatten @ MapThread[Map[Function[{prod}, makeReactionFold[#1, prod]], #2] &, {structList, foldOut}];
	foldProducts = DeleteDuplicates[Flatten[foldOut]];
	{foldProducts, foldReactions}
];


filterFoldedStructure[foldIn_, {}, _] := {};
filterFoldedStructure[foldIn_, foldOutList_, {True, True}] := foldOutList;
filterFoldedStructure[foldIn_, foldOutList_, {False, False}] := {};
filterFoldedStructure[foldIn_, foldOutList_, {inter_, intra_}] := Module[
	{bondsIn, bondsOutList, bondsPropertyList, afterInter, afterInterIntra},
	bondsIn = foldIn[Bonds];
	bondsOutList = (Complement[#, bondsIn]) & /@ foldOutList[Bonds];
	bondsPropertyList = Map[bondListProperty, bondsOutList];
	Cases[Transpose[{foldOutList, bondsPropertyList}], {x_, {inter, intra}} -> x]
];


bondListProperty[bondList_] := Module[
	{strandList},
	strandList = Flatten[Differences /@ (Map[First /@ # &, bondList] /. Bond -> List)];
	(* {ContainsInterTrue, ContainsIntraTrue} *)
	{MemberQ[strandList, Except[0]], MemberQ[strandList, 0]}
];


(* ::Subsubsection:: *)
(*extraFirstOrder*)


extraFirstOrder[{}, pairingOps_, foldingOps_] := {{}, {}};
extraFirstOrder[structList_, pairingOps_, foldingOps_] := Module[
	{products, reactions},
	reactions = Flatten[extraFirstOrderOne[#, pairingOps, foldingOps] & /@ DeleteDuplicates[structList]];
	products = DeleteDuplicates[Flatten[#[Products] & /@ reactions]];
	{products, reactions}
];
extraFirstOrderOne[struct_, pairingOps_, foldingOps_] := Module[
	{meltOnce, meltTwice, candidates, invasions, toeholds},
	meltOnce = Last /@ Simulation`Private`meltOneLevel[struct, False];
	meltOnce = Select[meltOnce, Length[#] == 2 &];
	If[MatchQ[meltOnce, {}], Return[{}]];
	meltTwice = Map[Function[{s}, Last /@ Simulation`Private`meltOneLevel[s, False]], #] & /@ meltOnce;
	If[MatchQ[Flatten[meltTwice], {}], Return[{}]];

	candidates = Flatten[MapThread[Join[combineMelts[#1[[1]], #2[[2]]], combineMelts[#1[[2]], #2[[1]]]] &, {meltOnce, meltTwice}], 1];
	If[MatchQ[candidates, {}], Return[{}]];

	invasions = pairForOne[struct, #, pairingOps] & /@ candidates;
	toeholds = pairForTwo[struct, #, pairingOps, foldingOps] & /@ candidates[[1;;1]];
	DeleteDuplicates[Flatten[Join[invasions, toeholds]]]
];
combineMelts[one_, two_] := Module[
	{melts},
	melts = Append[#, one] & /@ two;
	Select[melts, Length[#] == 3 &]
];
pairForOne[reactant_, {r1_, r2_, r3_}, pairingOps_] := Module[
	{oneTry, prods, reactions},

	oneTry[s1_, s2_, s3_] := Module[
		{one},
		one = Pairing[s1, s2, Sequence @@ pairingOps];
		If[MatchQ[one, {}], Return[{}]];
		Pairing[s3, #, Sequence @@ pairingOps] & /@ one
	];

	prods = DeleteDuplicates[Flatten[{oneTry[r1, r2, r3], oneTry[r2, r3, r1], oneTry[r1, r3, r2]}]];

	reactions = Reaction[{reactant}, {#}, ClassifyReaction[{reactant}, {#}]] & /@ prods;
	Cases[reactions, Reaction[_, _, StrandInvasion]]
];
pairForTwo[reactant_, {r1_, r2_, r3_}, pairingOps_, foldingOps_] := Module[
	{oneTry, prods, reactions},

	oneTry[s1_, s2_, s3_] := Module[
		{one, two},
		one = Pairing[s1, s2, Sequence @@ pairingOps];
		If[MatchQ[one, {}], Return[{}]];
		two = Simulation`Private`kineticFolding[s3, Replace[Lookup[foldingOps, FoldingInterval], All -> Null], foldingOps];
		Tuples[{one, two}]
		(*reactions = Reaction[{reactant}, {#}, ClassifyReaction[{reactant}, {#}]] & /@ prods*)
	];
	prods = DeleteDuplicates[Sort /@ Flatten[{oneTry[r1, r2, r3], oneTry[r2, r3, r1], oneTry[r1, r3, r2]}, 1]];
	reactions = Reaction[{reactant}, #, ClassifyReaction[{reactant}, #]] & /@ prods;
	Cases[reactions, Reaction[_, _, ToeholdMediatedDuplexExchange]]
];


(* ::Subsubsection:: *)
(*pairingPart*)


pairingPart[{}, pairingOps_] := {{}, {}};
pairingPart[structList_, pairingOps_] := Module[
	{pairIn, pairOutRaw, pairOut, pairReactions, pairProducts},
	pairIn = DeleteDuplicates[Sort /@ Tuples[{structList, structList}]];
	pairOutRaw = Rest[Pairing[Sequence @@ #, Sequence @@ pairingOps]] & /@ pairIn;
	If[MatchQ[Flatten[pairOutRaw], {}], Return[{{}, {}}]];
	pairOut = DeleteDuplicates[Flatten[Function[{onePair}, {#, onePair[[2]]} & /@ onePair[[1]]] /@ Cases[Flatten[pairOutRaw, Min[2, Lookup[pairingOps, Depth]]], Except[{}]], 1] /. x: {_Structure, _Structure} :> Sort[x]];
	pairReactions = makeReactionPair[#[[2]], #[[1]]] & /@ pairOut;
	pairProducts = DeleteDuplicates[Flatten[First /@ pairOut]];
	{pairProducts, pairReactions}
];


(* ::Subsubsection::Closed:: *)
(*toehold related*)


toeholdPart[species_] := Module[
	{meltedLists, toeholdStrand, toeholdDuplex, allToeholds, toeholdProducts, toeholdReactions},

	meltedLists = DeleteCases[meltOneLevel[#, False] & /@ species, {}];

	toeholdStrand = toeholdStrandReactions[species, meltedLists];

	toeholdDuplex = toeholdDuplexReactions[meltedLists];

	allToeholds = Join[toeholdStrand, toeholdDuplex];
	If[MatchQ[allToeholds, {}], Return[{{}, {}}]];

	toeholdProducts = DeleteDuplicates[Flatten[#[[2]] & /@ allToeholds]];
	toeholdReactions = Reaction @@ # & /@ allToeholds;

	{toeholdProducts, toeholdReactions}
];


toeholdStrandReactions[single_, double_] := Module[
	{meltedTupleLists, allPossibleReactantTuples},
	meltedTupleLists = DeleteDuplicates[Sort /@ Tuples[{single, double}]];
	If[MatchQ[meltedTupleLists, {}], Return[{}]];

	allPossibleReactantTuples = Flatten[DeleteDuplicates[Sort /@ Tuples[{#[[1]], {#[[2]]}}]] & /@ meltedTupleLists, 1];
	DeleteCases[Flatten[makeCandidateReactionsStrand /@ allPossibleReactantTuples, 1], $Failed]
];


makeCandidateReactionsStrand[{Rule[str1_, {str11_, str12_}], str2_}] := Module[
	{pairedCase1, pairedCase2},
	pairedCase1 = pairOneCaseStrand[str11, str2, {str1, str2}, str12];
	pairedCase2 = pairOneCaseStrand[str12, str2, {str1, str2}, str11];
	Flatten[{pairedCase1, pairedCase2}, 1]
];


pairOneCaseStrand[str1_, str2_, reactants_, productPart_] := Module[
	{prod, reactantsProductsPairs},
	prod = Pairing[str1, str2];
	If[MatchQ[prod, {}], Return[$Failed]];

	reactantsProductsPairs = {reactants, {#, productPart}, Quiet @ ClassifyReaction[reactants, {#, productPart}]} & /@ prod;
	Cases[reactantsProductsPairs, {_, _, ToeholdMediatedStrandExchange | StrandInvasion}]
];


toeholdDuplexReactions[double_] := Module[
	{meltedTupleLists, allPossibleReactantTuples},
	(* format into a list of tuples of melted results for two structures *)
	meltedTupleLists = DeleteDuplicates[Sort /@ Tuples[{double, double}]];
	If[MatchQ[meltedTupleLists, {}], Return[{}]];

	allPossibleReactantTuples = Flatten[DeleteDuplicates[Sort /@ Tuples[{#[[1]], #[[2]]}]] & /@ meltedTupleLists, 1];
	DeleteCases[Flatten[makeCandidateReactionsDuplex /@ allPossibleReactantTuples, 1], $Failed]
];


makeCandidateReactionsDuplex[{Rule[str1_, {str11_, str12_}], Rule[str2_, {str21_, str22_}]}] := Module[
	{pairedCase1, pairedCase2},
	pairedCase1 = pairOneCaseDuplex[str11, str21, str12, str22, {str1, str2}];
	pairedCase2 = pairOneCaseDuplex[str11, str22, str12, str21, {str1, str2}];
	Flatten[{pairedCase1, pairedCase2}, 1]
];


pairOneCaseDuplex[strA1_, strA2_, strB1_, strB2_, reactants_] := Module[
	{prodA, prodB, reactantsProductsPairs},
	prodA = Pairing[strA1, strA2];
	If[MatchQ[prodA, {}], Return[$Failed]];
	prodB = Pairing[strB1, strB2];
	If[MatchQ[prodB, {}], Return[$Failed]];
	reactantsProductsPairs = {reactants, #, Quiet @ ClassifyReaction[reactants, #]} & /@ Tuples[{prodA, prodB}];
	Cases[reactantsProductsPairs, {_, _, ToeholdMediatedDuplexExchange | DualToeholdMediatedDuplexExchange | DuplexInvasion}]
]


meltOneLevel[structure: Structure[strands_, bonds_], returnBond: True] := Table[
	With[
		{temp = {SplitStructure[Structure[strands, Delete[bonds, i]]], bonds[[i]]}},
		If[MatchQ[Length[temp], 2], structure -> temp, Nothing]
	],
	{i, 1, Length[bonds]}
];
meltOneLevel[structure: Structure[strands_, bonds_], returnBond: False] := Table[
	With[
		{temp = SplitStructure[Structure[strands, Delete[bonds, i]]]},
		If[MatchQ[Length[temp], 2], structure -> temp, Nothing]
	],
	{i, 1, Length[bonds]}
];

meltOneLevel[structure: Structure[strands_, {}], returnBond: True] := {structure->{strands, {}}};


(* ::Subsection:: *)
(*make Reactions*)


(* ::Subsubsection::Closed:: *)
(*makeReactionFold*)


makeReactionFold[reactant: StructureP, product: StructureP] := Reaction[{reactant}, {product}, ClassifyReaction[{reactant}, {product}], ClassifyReaction[{product}, {reactant}]];


(* ::Subsubsection::Closed:: *)
(*makeReactionPair*)


makeReactionPair[reactants: {StructureP, StructureP}, product: StructureP] := Reaction[reactants, {product}, Hybridization, Dissociation];


(* ::Subsubsection:: *)
(*makeReactionMelt*)


makeReactionMelt[reactant_Structure, product: {_Structure}] := Reaction[{reactant}, product, Melting];
makeReactionMelt[reactant_Structure, product: {_Structure, _Structure}] := Reaction[{reactant}, Sort[product], Dissociation];


(* ::Subsection:: *)
(*addKineticRatesToMechanism*)


(* ::Subsubsection:: *)
(*addKineticRatesToMechanism*)


Authors[addKineticRatesToMechanism]={"scicomp", "brad"};


(* default temp is 37 Celsius *)
addKineticRatesToMechanism[mech:ReactionMechanismP, resolvedOps_]:=addKineticRatesToMechanismKelvin[mech,(273.15+37), resolvedOps]

(* Convert to Kelvin if given TemperatureQ, then call internal function *)
addKineticRatesToMechanism[mech:ReactionMechanismP,temp:_?TemperatureQ, resolvedOps_]:=
	addKineticRatesToMechanismKelvin[mech,Unitless[Replace[temp,0->10.^-6Celsius],Kelvin], resolvedOps];

(* symbolic temperature, call internal function *)
addKineticRatesToMechanism[mech:ReactionMechanismP,temp:(_Function|_Symbol), resolvedOps_]:=(
	If[MatchQ[temp,HoldPattern[Function[_?NumberQ]]|HoldPattern[Function[_,_?NumberQ]]],
		addKineticRatesToMechanismKelvin[mech,temp[Null], resolvedOps],  (* if constant function, evaluate rates immediately *)
		addKineticRatesToMechanismKelvin[mech,Temperature, resolvedOps]  (* otherwise wait and leave symbolic *)
]);

(* core internal function *)
addKineticRatesToMechanismKelvin[mech_,tempK_, resolvedOps_]:=Module[{specs,eqs,out,fes,enths,entrs},

	(* if rates already numeric, just return *)
	If[Or[
			tempK===Null,
			MatchQ[
				(* substitute a nuemric value for Temperature var so things that are already eq rate expressions do not get re-computed *)
				ReplaceAll[Flatten[mech[Rates]],Temperature->300.],
				{(_?NumberQ|_?FirstOrderRateQ|_?SecondOrderRateQ)..}
			]
		],
		Return[NucleicAcids`Private`sortAndReformatStructures[convertRateUnits[mech]]]
	];

	out=Map[addKineticRatesToReaction[#,tempK, resolvedOps]&,mech];

	NucleicAcids`Private`sortAndReformatStructures[out]
];

(* things that aren't mechanisms should already have rates *)
addKineticRatesToMechanism[mech:{ImplicitReactionP..},rest___]:=convertRateUnits[mech];

(* these matrices should already have numeric rates *)
addKineticRatesToMechanism[mech:{_SparseArray,_SparseArray,_,_},rest___]:=mech;


(* ::Subsubsection:: *)
(*addKineticRatesToReaction*)


(* reversible reaction *)
addKineticRatesToReaction[rx:Reaction[reactants_,products_,forward_?NumericQ,___],___]:=rx;
addKineticRatesToReaction[rx:Reaction[reactants_,products_,forward_Symbol,___],temp_, ops_]:= KineticRates[rx, Temperature -> If[MatchQ[temp, _Symbol | _Function], temp, temp * Kelvin]];

addKineticRatesToReaction[rx_Reaction,___]:=rx;


(* ::Subsubsection:: *)
(*convertRateUnits*)


convertRateUnits[mech:ReactionMechanism[_Reaction...]]:=convertRateUnits/@mech
convertRateUnits[Reaction[a_,b_,rate_]]:=Reaction[a,b,fixRate[rate]]
convertRateUnits[Reaction[a_,b_,frate_,brate_]]:=Reaction[a,b,fixRate[frate],fixRate[brate]]
convertRateUnits[model:{ImplicitReactionP..}]:=convertRateUnits/@model;
convertRateUnits[{rx_,rate_}]:={rx,fixRate[rate]};
convertRateUnits[{rx_,frate_,brate_}]:={rx,fixRate[frate],fixRate[brate]};
convertRateUnits[model:{_SparseArray,_SparseArray,_List,_List}]:=model
fixRate[r_?NumericQ]:=r;
fixRate[r_?FirstOrderRateQ]:=Unitless[r,1/Second];
fixRate[r_?SecondOrderRateQ]:=Unitless[r,1/Molar/Second];
