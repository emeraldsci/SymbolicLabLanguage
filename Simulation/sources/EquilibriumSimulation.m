(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)



(* ::Subsection:: *)
(*SimulateEquilibrium*)

(* ::Subsubsection:: *)
(*Options*)

DefineOptions[SimulateEquilibrium,
	Options :> {
		{
			OptionName->Temperature,
			Default-> 37Celsius,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin ],
			Description->"Temperature at which equilibrium is computed."
		},
		{
			OptionName->Template,
			Default-> Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Equilibrium]],ObjectTypes->{Object[Simulation,Equilibrium]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,Equilibrium],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description-> "A template analysis whose methodology should be reproduced in running this analysis. Option values will be inherited from the template analysis, but can be individually overridden by directly specifying values for those options to this analysis function."
		},
		OutputOption,
		UploadOption
	}
];

(* TODO: surface some simulation options to help combat this error message *)
SimulateEquilibrium::NegativeConcentration = "The equilibrium state contains speices with substantial negative concentrations.";

(* ::Subsubsection::Closed:: *)
(*Messages and Tests*)

Error::InvalidMechanism = "Input is not a valid ReactionMechanism. Please check input ReactionMechanism to contain at least one reaction.";
Error::InvalidStructureList = "Input structure list `1` is invalid. Please check all input structures are from the same unfolded sequence.";

validMechanismTestOrEmpty[mech_, makeTest:BooleanP, description_, expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::InvalidMechanism];
		Message[Error::InvalidInput,mech];
	]
];

validStructureListTestOrEmpty[structure_, makeTest:BooleanP, description_, expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::InvalidStructureList,structure];
		Message[Error::InvalidInput,structure];
	]
];



(* ::Subsubsection:: *)
(*SimulateEquilibrium*)

inputPatternSimulateEquilibriumP = Alternatives[
	PatternSequence[ObjectP[Model[ReactionMechanism]],(StateP|{InitialConditionP...}|ListableP[InitialConditionListP])],
	PatternSequence[ObjectP[Object[Simulation, Folding]] | {StructureP..},(StateP|{InitialConditionP...}|ListableP[InitialConditionListP])],
	PatternSequence[(ReactionMechanismP | {ImplicitReactionP..} | ImplicitReactionP),(StateP|{InitialConditionP...}|ListableP[InitialConditionListP])],
	StateP|{InitialConditionP...}|ListableP[InitialConditionListP]
];

InitialConditionListP = {_?StringQ, _?ConcentrationQ};

SimulateEquilibrium[in:inputPatternSimulateEquilibriumP,ops:OptionsPattern[]]:=Module[
	{inList, initialConditionRules, definitionNumber, startFields, listedOptions, mechanism, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests, resolvedOpsSets, combinedOptions, coreFields, initialState, optionsRule, previewRule, testsRule, resultRule, resolvedOptions, resolvedOptionsTests, resolvedOptionsResult, unresolvedOptions, templateTests, inputTests},

	(* Make sure we're working with a list of options and inputs *)
	listedOptions = ToList[ops];

	(* Get simulation options which account for when Option Object is specified *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateEquilibrium,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateEquilibrium,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are  invalid return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Convert initial condition list which is supported in command center to rules if necessary *)
	initialConditionRules = Which[
		MatchQ[Last[ToList[in]], InitialConditionListP], Flatten[{ Last[ToList[in]] /. {s_String , x_} :> {Symbol[s] -> x} }],
		MatchQ[Last[ToList[in]], ListableP[InitialConditionListP]], Flatten[Last[ToList[in]] /. {s_String , x_} :> {Symbol[s] -> x}],
		True, {}
	];

	(* If we have converted initial condition list to rules, use rules instead of the list *)
	inList = If[Length[initialConditionRules]==0,
		{in},
		ReplacePart[{in}, -1->initialConditionRules]
	];

	definitionNumber = If[MatchQ[First[inList],(ObjectP[Object[Simulation, Folding]] | ListableP[StructureP])],
		2,
		1
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests} = Quiet[
		If[gatherTests,
			ValidInputLengthsQ[SimulateEquilibrium,inList,listedOptions,definitionNumber,Output->{Result,Tests}],
			{ValidInputLengthsQ[SimulateEquilibrium,inList,listedOptions,definitionNumber],{}}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateEquilibrium,inList,listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateEquilibrium,inList,listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	(* resolve inputs, options sets for each input, and tests together--if we have a good set of options sets, use first one for function *)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
			resolveOptionsSimulateEquilibrium[combinedOptions, Output->{Result,Tests}],
			{resolveOptionsSimulateEquilibrium[combinedOptions],{}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	{mechanism, initialState} = Quiet@resolveInputsSimulateEquilibrium[Sequence@@inList, resolvedOptions];

	inputTests = Which[
		MatchQ[First[inList], ObjectP[Object[Simulation, Folding]]], validStructureListTestOrEmpty[First[inList], gatherTests, "Input is a valid structure list:", Length[DeleteDuplicates[#[Strands]& /@ First[inList][FoldedStructures]]]==1],
		MatchQ[First[inList], ListableP[StructureP]], validStructureListTestOrEmpty[First[inList], gatherTests, "Input is a valid structure list:", Length[DeleteDuplicates[#[Strands]& /@ First[inList]]]==1],
		True, validMechanismTestOrEmpty[First[inList], gatherTests, "Input is a valid mechanism:", !MatchQ[mechanism, Null]]
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		coreFields = If[MatchQ[mechanism, Null],
			$Failed,
			simulateEquilibriumCore[mechanism,initialState,resolvedOptions]
		];
	];


	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		If[MatchQ[coreFields,$Failed],
			$Failed,
			Module[{preview},
			(* Get the states *)
				preview =  Lookup[coreFields, EquilibriumState, $Failed];
				If[MatchQ[preview,$Failed],
					$Failed,
					Zoomable[Rasterize[ECL`PlotState[preview],ImageSize->600]]
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
	(* Join all existing tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests],ToList[inputTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MatchQ[coreFields,$Failed],
			$Failed,
			Module[{result, endFields, packet},
			(* Make Object-specific fields for packet *)
				endFields = simulationPacketStandardFieldsFinish[resolvedOptions];

				packet = formatOutputSimulateEquilibrium[startFields,endFields,coreFields,resolvedOptions];

				(* If not uploading, just output the packetLists *)
				If[Lookup[resolvedOptions, Upload],
					First[uploadAndReturn[{packet}]],
					packet
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection:: *)
(*SimulateEquilibriumOptions*)

Authors[SimulateEquilibriumOptions] := {"brad"};

SimulateEquilibriumOptions[in: inputPatternSimulateEquilibriumP, ops : OptionsPattern[SimulateEquilibrium]] := Module[{listedOptions, noOutputOptions},
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	SimulateEquilibrium[in, PassOptions[SimulateEquilibrium, Append[noOutputOptions, Output->Options]]]
];



(* ::Subsubsection:: *)
(*SimulateEquilibriumPreview*)

Authors[SimulateEquilibriumPreview] := {"brad"};

SimulateEquilibriumPreview[in: inputPatternSimulateEquilibriumP, ops : OptionsPattern[SimulateEquilibrium]] := Module[
	{listedOptions, noOutputOptions},
	
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	SimulateEquilibrium[in, PassOptions[SimulateEquilibrium, Append[noOutputOptions, Output->Preview]]]
];



(* ::Subsubsection:: *)
(*ValidSimulateEquilibriumQ*)

DefineOptions[ValidSimulateEquilibriumQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateEquilibrium}
];

Authors[ValidSimulateEquilibriumQ] := {"brad"};

ValidSimulateEquilibriumQ[myInput: inputPatternSimulateEquilibriumP, myOptions:OptionsPattern[ValidSimulateEquilibriumQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

(* get mechanism if input is an Object *)
	listedInput = ToList[If[MatchQ[{myInput},{ObjectP[Object[Simulation,ReactionMechanism]]}],
		myInput[ReactionMechanism],
		myInput
	]];
	listedObjects = Cases[ToList[myInput], ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];
	(* Call the function to get a list of tests *)
	functionTests = SimulateEquilibrium[myInput,preparedOptions];

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

	RunUnitTest[<|"ValidSimulateEquilibriumQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidSimulateEquilibriumQ"]
];




(* ::Subsubsection:: *)
(*resolveInputsSimulateEquilibrium*)

resolveInputsSimulateEquilibrium[mechanism: ObjectP[Model[ReactionMechanism]], ic_, resolvedOps_] := resolveInputsSimulateEquilibrium[mechanism[ReactionMechanism], ic, resolvedOps];

resolveInputsSimulateEquilibrium[fold: ObjectP[Object[Simulation, Folding]], ic_, resolvedOps_] := resolveInputsSimulateEquilibrium[fold[FoldedStructures], ic, resolvedOps];

resolveInputsSimulateEquilibrium[structList: {StructureP..}, ic_, resolvedOps_] := resolveInputsSimulateEquilibrium[formTwoStateMechanism[structList], ic, resolvedOps];

resolveInputsSimulateEquilibrium[$Failed, ic_, resolvedOps_] := {Null, Null};

resolveInputsSimulateEquilibrium[reaction: ImplicitReactionP, ic:(StateP|{InitialConditionP...}), resolvedOps_] := resolveInputsSimulateEquilibrium[{reaction}, ic, resolvedOps];

resolveInputsSimulateEquilibrium[mechanism: ReactionMechanismP | {ImplicitReactionP..}, ic:(StateP|{InitialConditionP...}), resolvedOps_] := Module[
	{mechFull, initialC, model},
	mechFull = Quiet @ SimulateReactivity[resolveMechanism[mechanism, resolvedOps], Temperature->Lookup[resolvedOps, Temperature], Upload->False, Output->Result][ReactionMechanism];
	If[MatchQ[NucleicAcids`Private`mechanismToImplicitReactions[mechFull], {}] || MatchQ[mechFull, Null], Message[Error::InvalidMechanism]; Return[{Null, Null}]];
	model = reactionMatrices[mechFull];
	initialC = resolveInitialConditions[model, ic];
	{model, initialC}
];

resolveInputsSimulateEquilibrium[ic:(StateP|{InitialConditionP...}), resolvedOps_] := Module[
	{mechFull, initialC, model},
	mechFull = Quiet @ resolveMechanism[ic, resolvedOps];
	If[MatchQ[mechFull, Null], Message[Error::InvalidMechanism]; Return[{Null, Null}]];
	model = reactionMatrices[mechFull];
	initialC = resolveInitialConditions[model, ic];
	{model, initialC}
];


resolveMechanism[mechanism: ReactionMechanismP, ops_] := mechanism;
resolveMechanism[ir: {ImplicitReactionP..}, ops_] := ReactionMechanism[ir];
resolveMechanism[ic:(StateP|{InitialConditionP...}), ops_] := SimulateReactivity[ic,PassOptions[SimulateEquilibrium,SimulateReactivity,Method->Automatic, Sequence@@ReplaceRule[ops, {Upload->False, Output -> Result}]]][ReactionMechanism];


resolveInitialConditions[model_, ic: StateP] := resolveInitialConditions[model, ic["Rules"]];
resolveInitialConditions[model_, ic: {InitialConditionP...}] := Module[
	{allSpecies, initialState},
	(*allSpecies = DeleteDuplicates[Join[SpeciesList[model], SpeciesList[ic]]];*)
	allSpecies = DeleteDuplicates[SpeciesList[model]];
	ToState[ic, allSpecies]
];


(* ::Subsubsection:: *)
(*formTwoStateMechanism*)


formTwoStateMechanism[structList: {StructureP..}] := Module[
	{strandList, unfolded, reactionRates},
	strandList = DeleteDuplicates[#[Strands]& /@ structList];
	If[!MatchQ[Length[strandList], 1], Message[Error::InvalidStructureList,structList]; Return[$Failed]];
	unfolded = ToStructure[First[strandList]];
	reactionRates = Switch[Length[First[strandList]],
		1, {Folding, Melting},
		2, {Hybridization, Dissociation},
		_, Return[$Failed]
	];
	ReactionMechanism[Sequence@@(Reaction[{unfolded}, {#}, Sequence@@reactionRates] & /@ structList)]
];


(* ::Subsubsection::Closed:: *)
(*resolveOptionsSimulateEquilibrium*)

DefineOptions[resolveOptionsSimulateEquilibrium,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveOptionsSimulateEquilibrium[unresolvedOps_List, ops:OptionsPattern[]]:=Module[{},
	SafeOptions[SimulateEquilibrium, ToList[unresolvedOps], ops]
];


(* ::Subsubsection::Closed:: *)
(*formatOutputSimulateEquilibrium*)


formatOutputSimulateEquilibrium[startFields_,endFields_,coreFields_,resolvedOps_] := Module[{out},
	out = <|Join[
		{Type -> Object[Simulation, Equilibrium]},
		startFields,
		coreFields,
		{
			Temperature -> Lookup[resolvedOps,Temperature]
		},
		endFields
	]|>
];


(* ::Subsubsection:: *)
(*simulateEquilibriumCore*)


simulateEquilibriumCore[model: {R_,P_,k_,species_}, initialState_,resolvedOps_List]:=Module[
	{kUnitless, initialStateN, eqState, xGuess, xEq, A1, A2, inds, S, dx, z0, z, tF, Us, Ss, Vs, Q, B1, B2, B3, rhs},

	(*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*)
	(* added temporarily to remove rate units, should remove when updating for full support for rate units *)
	kUnitless = Unitless /@ k;

	initialStateN = loadInitialConditions[species, initialState["Rules"]];
	(*
		Simulate for a bit to get a good initial guess
		Estimate good simulation time based on the slowest (smallest) rate constant
		But don't let it get too big, or NDSolve craps out
	*)
	tF = 10 / Min[kUnitless] / Norm[initialStateN];
	tF = Min[{tF, 10^9}];

	xGuess = (FinalState /. SimulateKinetics[{R,P,kUnitless,species}, initialState, tF * Second, Upload -> False])[Magnitudes];

	(* reformat from list to column vector *)
	xGuess = Transpose[{xGuess}];

	(* Construct the stoichiometry matrix *)
	S = N[P - R];

	(* SVD to get orthonormal bases of subspace definded by S's columns (i.e. reactions) *)
	 {Us, Ss, Vs} = Quiet[SingularValueDecomposition[S], SingularValueDecomposition::arh];
	 Q = Us[[All, 1;;MatrixRank[Ss]]];

	(* transform to state-space matrices *)
	{A1, A2, inds} = stateSpaceMatrices[R, P, DiagonalMatrix[SparseArray[kUnitless]], Full -> True];

	(* project As into Q-spaceby left multiply QT then we will be solving rhs[x]\[Equal]0 *)
	(* with x = xGuess + Qz, rhs[x] = QT.A1.x +QT.A2.KroneckerProduct[x, x], which can be simplified to following expression *)
	B1 = Transpose[Q].A1.xGuess + Transpose[Q].A2.KroneckerProduct[xGuess, xGuess];
	B2 = Transpose[Q].A1.Q + Transpose[Q].A2.KroneckerProduct[xGuess, Q] + Transpose[Q].A2.KroneckerProduct[Q, xGuess];
	B3 = Transpose[Q].A2.KroneckerProduct[Q, Q];
	rhs[x_List] := With[{xx = x}, B1 + B2.xx + B3.KroneckerProduct[xx, xx]];

	(* initial guess for dn is 0 vector (because we are solving for dx) *)
	z0 = Table[{0.}, Last[Dimensions[Q]]];

	(* solve for dn (purturbation from 0 to the solution in S-space) *)
	z = z /. Quiet[FindRoot[rhs[z], {z, z0}], {Message::msgl, RowReduce::luc, FindRoot::lstol}];

	(* transform back to x-space and add the perturbation to the initial guess *)
	xEq = xGuess + Q.z;

	(* check for negative concentrations *)
	If[Min[Flatten[xEq]]<0,
		(* if negative concentrations are more than 0.01% of total, give a warning *)
		If[ Min[Flatten[xEq]] > 0.0001*Norm[xEq],
			SimulateEquilibrium::NegativeConcentration
		];
		(* zero anything negative and keep going *)
		xEq = xEq /. x_?Negative :> 0.0;

	];

	(* return a State thingy *)
	eqState = ToState[ToState[species, Flatten[xEq]],Molar];

	{
		InitialState->initialState,
		ReactionMechanism -> ToReactionMechanism[model],
		EquilibriumState->eqState,
		Append[Species] -> species
	}
];


(* ::Section:: *)
(*End*)
