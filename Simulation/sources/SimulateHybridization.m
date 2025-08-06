(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*SimulateHybridization*)


(* ::Subsubsection:: *)
(*Pattern*)


singleHybP = SequenceP | StrandP | StructureP | ObjectP[Object[Sample]] | ObjectP[Model[Sample]];
InputPatternSimulateHybridizationP = {singleHybP..};


(* ::Subsubsection:: *)
(*SimulateHybridization*)

(* ::Subsubsection:: *)
(*Options*)

DefineOptions[SimulateHybridization,
	Options :> {
		{
			OptionName->Folding,
			Default-> True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			Description->"Whether to do a folding after pairing, if true, then paired structures will continue performing an inter-strand folding to infinity depth."
		},
		{
			OptionName->Method,
			Default-> Energy,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> HybridizationMethodP],
			Description->"Determines whether the returned hybridized structures are sorted by ascending energy or descending number of bonds."
		},
		{
			OptionName->Temperature,
			Default-> 37*Celsius,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Kelvin | Celsius ],
			Description->"The Gibbs free energies of the hybridized structures are computed at this temperature."
		},
		{
			OptionName->Depth,
			Default-> {1},
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[1, 1], PatternTooltip->"Hybridization from 1 to n"],
				Widget[Type->Expression, Pattern:> {_Integer}, Size->Line, PatternTooltip->"Hybridization at exact depth {n}"]
			],
			Description->"In each depth, a set of original input structures is added to existing structure pool, then a round of hybridization is performed between current structures.  {n_Integer} returns structures hybridized at exactly n depth.  n_Integer returns all structures hybridized 1 to n depth."
		},
		{
			OptionName->Consolidate,
			Default-> True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			Description->"If True, all hybridizations are extended to their maximum length so that the neighbouring bases of each bond cannot be further paired."
		},
		{
			OptionName->MaxMismatch,
			Default-> 0,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Maximum number of mismatches allowed in any given duplex."
		},
		{
			OptionName->MinPieceSize,
			Default-> 1,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Minimum number of consecutive paired bases required in a duplex containing mismatches."
		},
		{
			OptionName->MinLevel,
			Default-> 3,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Minimum number of bases required in each duplex."
		},
		{
			OptionName->Template,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Hybridization]],ObjectTypes->{Object[Simulation,Hybridization]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,Hybridization],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"Use ResolvedOptions in given object for default option resolution in current simulation."
		},
		{
			OptionName->Polymer,
			Default-> Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> DNA | RNA ],
			Description->"The polymer type that defines the potnetial alphabaet a valid sequence should be composed of when the input sequence is ambiguous.",
			ResolutionDescription->"If Null or Automatic, polymer type is determined automatically.  When multiple polymers of different types are used it is preferred to use Null or Automatic and then the individual polymers will be determined by subfunctions when needed.",
			Category->"Hidden"
		},
		OutputOption,
		UploadOption
	}
];


(* ::Subsubsection:: *)
(*Function*)

Warning::InputTooLong = "Input can be a maximum of two lists of oligomers.  Truncating input to first two lists.";


SimulateHybridization[in: ListableP[InputPatternSimulateHybridizationP], ops: OptionsPattern[]]:= Module[
	{startFields, inListD, inList, rawInList, resolvedOptions, resolvedOptionsSets, resolvedOptionsTests, resolvedOptionsResult, outputSpecification, output, listedOptions, gatherTests, optionsRule, previewRule, testsRule, resultRule, safeOptions, safeOptionTests, validLengths, validLengthTests, unresolvedOptions, templateTests, combinedOptions, initialStructure, coreFields, inputLengthTest, acceptablePolymerTests, structuresAndTests},

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Make sure we're working with a list of options and inputs *)
	listedOptions = ToList[ops];
	rawInList = If[MatchQ[ToList[in],InputPatternSimulateHybridizationP],
		{ToList[in]},
		ToList[in]
	];
	inList = If[Length[rawInList]>2,
		rawInList[[;;2]],
		rawInList
	];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Test input list length *)
	inputLengthTest = inputLengthTestOrEmpty[gatherTests, "Maximum input list length of 2", Length[rawInList]<=2];

	(* Get simulation options which account for when Option Object is specified *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateHybridization,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateHybridization,listedOptions,AutoCorrect->False],{}}
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

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests} = Quiet[
		If[gatherTests,
			ValidInputLengthsQ[SimulateHybridization, {inList}, listedOptions, Output->{Result,Tests}],
			{ValidInputLengthsQ[SimulateHybridization, {inList}, listedOptions], {}}
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
		ApplyTemplateOptions[SimulateHybridization, {inList}, listedOptions, Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateHybridization, {inList}, listedOptions], {}}
	];
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* Download any needed objects *)
	inListD = megaDownload[inList];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
			resolveOptionsSimulateHybridization[inListD, combinedOptions, Output->{Result,Tests}],
			{resolveOptionsSimulateHybridization[inListD,combinedOptions], {}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result] || gatherTests,
		(* Get initial structures and polymer tests *)
	 	structuresAndTests = If[gatherTests,
			Map[resolveInputsSimulateHybridization[#1, resolvedOptions, Output->{Result,Tests}] &, inListD, {2}],
			Map[{resolveInputsSimulateHybridization[#1, resolvedOptions], {}} &, inListD, {2}]
		];

		initialStructure = structuresAndTests[[;;,;;,1]];
		acceptablePolymerTests = structuresAndTests[[;;,;;,2]];
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* Do the hybridization *)
		coreFields = Map[simulateHybridizationCore[#, resolvedOptions]&, initialStructure];
	];


	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		Module[{preview,previewList},

			(* Check for failed here *)
			preview = If[MemberQ[coreFields,$Failed],
				$Failed,
				(* else pull out the preview field *)
				 Lookup[coreFields, Append[HybridizedStructures], $Failed]
			];

			(* Catch case where there are no preview fields otherwise rasterize and show *)
			If[preview===$Failed,
				$Failed,
				previewList = Rasterize[#, ImageResolution->600] & /@ preview;
				Grid[{Zoomable/@previewList}]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, ToList[inputLengthTest], ToList[acceptablePolymerTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || resolvedOptions===$Failed,
			$Failed,
			Module[{refList, endFields, packetList},

				(* Check for failed here and then make packet *)
				packetList = If[MemberQ[coreFields,$Failed],
					$Failed,

					(* Else get the reflist and make the packet *)
					refList = Append[StartingMaterials]-># & /@Map[resolveReferenceHybridization, inList, {2}];

					(* Get end packet fields *)
					endFields = simulationPacketStandardFieldsFinish[resolvedOptions];

					(* Make the packet *)
					MapThread[formatOutputSimulateHybridization[startFields, endFields, #1, resolvedOptions, #2]&, {coreFields, refList}]
				];

				(* If not uploading, just return the packet, otherwise upload it *)
				If[Lookup[resolvedOptions, Upload] && !MatchQ[packetList,$Failed],
					With[{result=uploadAndReturn[packetList]},
						If[Length[result]==1,
							First[result],
							result
						]
					],
					If[MatchQ[packetList,_List] && MatchQ[in,InputPatternSimulateHybridizationP],
						First[packetList],
						packetList
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection::Closed:: *)
(*ValidSimulateHybridizationQ*)

DefineOptions[ValidSimulateHybridizationQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateHybridization}
];

Authors[ValidSimulateHybridizationQ] := {"brad"};

ValidSimulateHybridizationQ[myInput: ListableP[InputPatternSimulateHybridizationP], myOptions:OptionsPattern[ValidSimulateHybridizationQ]]:= Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = ToList[myInput];
	listedObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];
	(* Call the function to get a list of tests *)
	functionTests = SimulateHybridization[listedInput,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
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

	RunUnitTest[<|"ValidSimulateHybridizationQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidSimulateHybridizationQ"]
];



(* ::Subsubsection::Closed:: *)
(*SimulateHybridizationOptions*)

Authors[SimulateHybridizationOptions] := {"brad"};

SimulateHybridizationOptions[in: ListableP[InputPatternSimulateHybridizationP], ops : OptionsPattern[SimulateHybridization]]:= Module[
	{listedOptions, noOutputOptions},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output->_];

	SimulateHybridization[in, Sequence@@Append[noOutputOptions,Output->Options]]
];


(* ::Subsubsection::Closed:: *)
(*SimulateHybridizationPreview*)

Authors[SimulateHybridizationPreview] := {"brad"};

SimulateHybridizationPreview[in: ListableP[InputPatternSimulateHybridizationP], ops : OptionsPattern[SimulateHybridization]]:= Module[
	{listedOptions, noOutputOptions},
	
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output->_];

	SimulateHybridization[in, Sequence@@Append[noOutputOptions,Output->Preview]]
];


(* ::Subsubsection:: *)
(*resolveReference*)

resolveReferenceHybridization[x: SequenceP | StrandP | StructureP] := Null;
resolveReferenceHybridization[x: ObjectP[{Model[Sample],Object[Sample]}]] := Module[{moleculeComposition},
	moleculeComposition=FirstOrDefault[Cases[Download[x,Composition[[All,2]][{Object,Molecule}]],{_,StrandP|StructureP}],{Null,Null}][[1]];
	Link[moleculeComposition,Simulations]
];


(* ::Subsubsection::Closed:: *)
(*inputLengthTestOrEmpty*)

inputLengthTestOrEmpty[makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Warning::InputTooLong]
	]
];






(* ::Subsubsection:: *)
(*resolveInputsSimulateHybridization*)

DefineOptions[resolveInputsSimulateHybridization,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveInputsSimulateHybridization[in_, resolvedOps_, ops:OptionsPattern[]]:= Module[
	{struct, result, output, listedOutput, collectTestsBoolean},

	(* From resolveInputsSimulateHybridization's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	struct = flattenDegenerate[resolveSimulateHybridizationInputToStructure[in,resolvedOps]];

	result =If[MatchQ[struct,Null],
		$Failed,
		NucleicAcids`Private`reformatBonds[StructureSort[struct],StrandBase]
	];

	output/.{Tests->{},Result->result}
];


resolveSimulateHybridizationInputToStructure[s_Structure,resolvedOps_]:=flattenDegenerate[ToStructure[s]];
resolveSimulateHybridizationInputToStructure[s:(SequenceP|_Strand),resolvedOps_]:=flattenDegenerate[ToStructure[s, PassOptions[SimulateHybridization,ToStructure,resolvedOps /. Rule[Polymer, Null] -> Rule[Polymer, Automatic]]]];
resolveSimulateHybridizationInputToStructure[obj: ObjectP[{Model[Sample],Object[Sample]}], resolvedOps_] := Module[{singleStrandOrStructure},
	(* Get the strands from the composition field. *)
	singleStrandOrStructure = FirstOrDefault[Cases[Download[obj,Composition[[All,2]][Molecule]],StrandP|StructureP],Null];

	resolveSimulateHybridizationInputToStructure[singleStrandOrStructure, resolvedOps]
];
resolveSimulateHybridizationInputToStructure[_,_]:=$Failed;


(* ::Subsubsection:: *)
(*resolveOptionsSimulateHybridization*)

DefineOptions[resolveOptionsSimulateHybridization,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveOptionsSimulateHybridization[in_,unresolvedOps_List, ops:OptionsPattern[]] := Module[
	{output, listedOutput, collectTestsBoolean, allTests, resolvedOptions},

	(* From resolveSimulateFoldingOptions's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	(* Gather all the tests (this will be a list of Nulls if !Output->Test) *)
	allTests = {};

	resolvedOptions = ReplaceRule[
		unresolvedOps,
		{
			Polymer -> resolveOptionsSimulateHybridizationPolymer[in, Lookup[unresolvedOps, Polymer]]
		}
	];

	output/.{Tests->allTests,Result->resolvedOptions}
];


resolveOptionsSimulateHybridizationPolymer[seq:SequenceP,pol_]:=Quiet@PolymerType[seq,Polymer->pol];
resolveOptionsSimulateHybridizationPolymer[seq_,pol:Automatic]:=Null;
resolveOptionsSimulateHybridizationPolymer[seq_,pol_]:=pol;


motifPositionToStrandPosition = NucleicAcids`Private`motifPositionToStrandPosition;


(* ::Subsubsection:: *)
(*formatOutputSimulateHybridization*)


formatOutputSimulateHybridization[startFields_, endFields_, $Failed, resolvedOps_, ref_] := $Failed;
formatOutputSimulateHybridization[startFields_, endFields_, coreFields_, resolvedOps_, ref_]:=Module[{packet},
	packet=Association[Join[{Type -> Object[Simulation, Hybridization]},
		startFields,
		coreFields,
		formatSimulateHybridizationOptionFields[resolvedOps],
		postRefHybridization[ref],
		endFields
	]]
];


formatSimulateHybridizationOptionFields[resolvedOps_] := {
	Method -> Lookup[resolvedOps, Method],
	Temperature -> Lookup[resolvedOps, Temperature],
	Depth -> Lookup[resolvedOps, Depth],
	Consolidate -> Lookup[resolvedOps, Consolidate],
	MaxMismatch -> Lookup[resolvedOps, MaxMismatch],
	MinPieceSize -> Lookup[resolvedOps, MinPieceSize],
	MinLevel -> Lookup[resolvedOps, MinLevel]
};


postRefHybridization[ref_]:= With[
	{res = ref/.Null->Nothing},

	If[Last[res]==={},
		{Nothing},
		{res}
	]

];


(* ::Subsubsection:: *)
(*simulateHybridizationCore*)


simulateHybridizationCore[failed_, resolvedOps_]/;MemberQ[failed, $Failed] := $Failed;
simulateHybridizationCore[initialStructure_,resolvedOps_]:=Module[
	{finalSpecies, finalReactions, hybridizedStructures, energies, bonds, eq, percentage, resAll, hybridizedStructuresSorted, energiesSorted, bondsSorted, percentageSorted, msStruct, reactionsWithInter},

	(* conduct full hybridization steps based on Depth, obtaining final species and reactions *)
	{finalSpecies, finalReactions, reactionsWithInter} = hybridizationFullStep[initialStructure, resolvedOps, False, {}];

	(* remove initial species *)
	hybridizedStructures = NucleicAcids`Private`reformatBonds[#, StrandBase]& /@ Complement[finalSpecies, initialStructure];

	(* calculate energies *)
	energies = If[
		MatchQ[hybridizedStructures, {}],
		{},
		SimulateFreeEnergy[Reaction[{StructureJoin[Sequence@@initialStructure]}, {#}, anything], Lookup[resolvedOps,Temperature], Upload->False][FreeEnergy] & /@ hybridizedStructures
	];

	bonds = NumberOfBonds /@ hybridizedStructures;

	(* calculate equilibrium *)
	If[MatchQ[hybridizedStructures, {}],
		{eq, percentage} = {{}, {}},
		{eq, percentage} = getEqPercent[reactionsWithInter, hybridizedStructures, initialStructure]
	];

	If[!MatchQ[Length[percentage], Length[hybridizedStructures]], percentage = With[{n = Length[hybridizedStructures]}, Table[1.0 / n, n]]];

	(* sort the hybridized structures by ascending energy or descending number of bonds *)
	resAll = Transpose[{hybridizedStructures, energies, bonds, percentage}];

	{hybridizedStructuresSorted, energiesSorted, bondsSorted, percentageSorted} = If[
		resAll==={},
		{{},{},{},{}},
		Switch[Lookup[resolvedOps, Method],
			Energy, Transpose[SortBy[resAll, #[[2]]&]],
			Bonds, Transpose[Reverse[SortBy[resAll, #[[3]]&]]]
		]
	];

	msStruct = If[hybridizedStructuresSorted==={}, Null, First[hybridizedStructuresSorted]];

	(* output a packet for later upload *)
	{
		MostStableStructure -> msStruct,
		Append[InitialStructures]->initialStructure,
		Append[HybridizedStructures]-> hybridizedStructuresSorted,
		Append[HybridizedEnergies]-> energiesSorted,
		Append[HybridizedNumberOfBonds] -> bondsSorted,
		Append[HybridizedPercentage] -> percentageSorted,
		HybridizationMechanism -> ReactionMechanism[reactionsWithInter]
	}

];


getStructure[struc: {StructureP..}] := struc;
getStructure[else_] := Lookup[else, Structure];


getEqPercent[reactionsWithInter_, hybridizedStructures_, initialStructure_]:= Module[
	{eq, eqAll, eqAsso, percentage},

	(* default all initial concentrations to 1Micromolar *)
	icSim = ToState[Map[Rule[#,Micromolar]&,initialStructure]];

	eqAll = SimulateEquilibrium[ReactionMechanism[reactionsWithInter], icSim, Upload -> False][EquilibriumState];
	eqAsso = First[#]->Last[#]& /@ (List@@eqAll);

	eq = hybridizedStructures/.eqAsso;
	percentage = (eq/Total[eq])*100;

	{eq, percentage}

];


(* ::Subsubsection:: *)
(*Full Hybridization Steps*)


Options[hybridizationFullStep]:= {
	PairSelf -> True
};


hybridizationFullStep[initialStructure_, resolvedOps_, intraForMechanism_, foldingOpsForMechanism_, ops: OptionsPattern[]]:= Module[
	{foldingOps, pairingOps, allStructs, allReactions, structsFirstDepth, reactionsFirstDepth, nextPairIn, oneDepth, foldOutFiltered, foldReactions, pairOut, pairReactions, structsOut, reactionsOut, listIn,
	reactions, depth, finalSpecies, finalReactions, reactionsWithInter},

	(* initial inputs, depth 0 *)
	foldingOps = If[MatchQ[foldingOpsForMechanism, {}],
		SafeOptions[SimulateFolding, ToList[PassOptions[SimulateHybridization, SimulateFolding, ReplaceRule[resolvedOps, {Method->Kinetic, Depth->Infinity, Template->Null, Upload->False, Output->Result}]]]],
		foldingOpsForMechanism
	];

	pairingOps = SafeOptions[Pairing, {MinLevel -> Lookup[resolvedOps, MinLevel], Consolidate->Lookup[resolvedOps, Consolidate], Depth->1, Parents->True}];
	allStructs = {};
	allReactions = {};

	(* a global variable to record already counted pairs *)
	countedPairs = {};

	(* a global variable to record structures which can be further hybridizaed at the current depth *)
	childrenList = {};

	depth = Switch[Lookup[resolvedOps, Depth],
				_Integer, Lookup[resolvedOps, Depth],
				{_Integer}, First[Lookup[resolvedOps, Depth]]
			];
	(*===============================*)
	(* when depth\[Equal]1, loop over all possible permutaed order of structures and conduct pairing followed by folding *)
	{pairOut, pairReactions} = pairFirstDepth[initialStructure, pairingOps, OptionValue[PairSelf]];

	{foldOutFiltered, foldReactions} = foldEachDepth[pairOut, initialStructure, foldingOps, {Lookup[resolvedOps, Folding], intraForMechanism}];

	{structsFirstDepth, reactionsFirstDepth} = {Join[pairOut, Flatten[foldOutFiltered]], Join[pairReactions, foldReactions]};

	allStructs = Append[allStructs, structsFirstDepth];
	allReactions = Append[allReactions, reactionsFirstDepth];


	(*===============================*)
	(*
		when depth\[GreaterEqual]2, in each depth:
		1) for each pair of current structures, conduct a normal pairing
		2) add one set of initial structures, and for each current structure conduct a permutated pairing
		3) fold all structures to infinity depth
	*)

	oneDepth[listInput_] := Module[
		{structsIn, initStruct, foldFilter},

		{structsIn, initStruct, pairingOps, foldingOps, foldFilter} = listInput;

		(* Perform a Pairing for current pairs, followed by a Folding (if turned on, an inter-strand folding) to infinity depth *)
		{structsOut, reactionsOut} = pairFoldEachMoreDepth[structsIn, initStruct, pairingOps, foldingOps, foldFilter, OptionValue[PairSelf]];

		allReactions = Append[allReactions, reactionsOut];
		allStructs = Append[allStructs, structsOut];

		{Join[structsIn, structsOut], initStruct, pairingOps, foldingOps, foldFilter}

	];

	(* loop over all depth *)
	depth = Switch[Lookup[resolvedOps, Depth],
				_Integer, Lookup[resolvedOps, Depth],
				{_Integer}, First[Lookup[resolvedOps, Depth]]
			];

	listIn = {structsFirstDepth, initialStructure, pairingOps, foldingOps, {Lookup[resolvedOps, Folding], intraForMechanism}};

	Nest[oneDepth, listIn, depth-1];
	(*===============================*)

	(* extract final species and reactions *)
	{finalSpecies, finalReactions} = Switch[Lookup[resolvedOps, Depth],
										_Integer | {1}, {Flatten[allStructs], Flatten[allReactions]},
										{_Integer}, {Last[allStructs], Last[allReactions]}
									];

	(* save unfiltered reactions before Consolidate, to calculate Equilibrium *)
	reactionsWithInter = Flatten[allReactions];


	(* If Consolidate\[Rule]True, discard intermediate products which can further be hybridized at this depth *)
	If[Lookup[resolvedOps, Consolidate],
		finalReactions = Select[finalReactions, Intersection[#[Products], childrenList]==={}&];
		finalSpecies = Complement[finalSpecies, childrenList];
	];


	{finalSpecies, finalReactions, reactionsWithInter}

];


pairFirstDepth[initialStructure_, pairingOps_, pairSelf_]:= Module[
	{allOrder, pairReactions, pairOut, foldReactions, foldIn, foldOut, foldOutFiltered},

	(* considering multiple structures input, permute them and do a pair-fold in the first depth *)
	allOrder = Permutations[initialStructure];

	(* loop over all structures to get all possible reactions, record pairs that already counted *)
	pairReactions = DeleteDuplicates[Flatten[
						Table[
							DeleteDuplicates[Flatten[FoldPairList[pairEachStep[#1, #2, pairingOps, pairSelf]&, {{First[oneOrder]}, Sequence@@Rest[oneOrder]}]]],
							{oneOrder, allOrder}
						]
					]];

	(* If Consolidate\[Rule]True, discard intermediate products which can further be hybridized at this depth *)
	If[Lookup[pairingOps, Consolidate],
		pairReactions = Select[pairReactions, Intersection[#[Products], childrenList]==={}&]
	];

	pairOut = Join[initialStructure, Flatten[#[Products]& /@ pairReactions]];

	{pairOut, pairReactions}

];


pairEachStep[prevstructs_, currStruct_, pairingOps_, pairSelf_]:= Module[
	{currPairs, currPairsUncnt, pairOutRaw, pairOut, reactions, nextStructs, canProduce},

	currPairs = Flatten[Table[DeleteDuplicates[Sort/@If[pairSelf, Tuples[{s, currStruct},2], {{s, currStruct}}]], {s, prevstructs}], 1];
	currPairsUncnt = Complement[currPairs, countedPairs];
	countedPairs = Union[countedPairs, currPairsUncnt];

	(* conduct Pairing after adding a new structure *)
	pairOutRaw = Rest[Pairing[Sequence@@#, Sequence@@pairingOps]]& /@ currPairsUncnt;
	If[MatchQ[Flatten[pairOutRaw], {}], Return[{{}, Append[prevstructs, currStruct]}]];

	(* Consolidate\[Rule]True, record all intermediate (non-leaf) nodes for further pruning *)
	canProduce = DeleteDuplicates[Flatten[First/@Select[Transpose[{currPairsUncnt,pairOutRaw}],Last[#]=!={{}}&]]];
	childrenList = Union[childrenList, canProduce];

	(* format pairing results into reactions *)
	pairOut = DeleteDuplicates[Flatten[Function[{onePair}, {#, onePair[[2]]} & /@ onePair[[1]]] /@ Cases[Flatten[pairOutRaw, Min[2, Lookup[pairingOps, Depth]]], Except[{}]], 1] /. x: {_Structure, _Structure} :> Sort[x]];
	reactions = makeReactionPair[#[[2]], #[[1]]] & /@ pairOut;

	(* unique structures to carry on in next pairing step *)
	nextStructs = DeleteDuplicates[Join[Flatten[First/@pairOut], prevstructs, {currStruct}]/. s_Structure :> StructureSort[s]];

	{reactions, nextStructs}

];


(* fold on pairing results and filter out inter/intra results based on option *)
foldEachDepth[pairOut_, initialStructure_, foldingOps_, foldFilter_]:= Module[
	{foldReactions, foldIn, foldOut, foldOutFiltered, canProduce},

	If[MatchQ[foldFilter, {False, False}],
		foldOutFiltered = {};
		foldReactions = {},

		foldIn = Complement[pairOut, initialStructure];
		foldOut = kineticFolding[#, Replace[Lookup[foldingOps, FoldingInterval], All -> Null], foldingOps] & /@ foldIn;
		foldOutFiltered = MapThread[filterFoldedStructure[#1, #2, foldFilter] &, {foldIn, foldOut}];
		foldReactions = Flatten @ MapThread[Map[Function[{prod}, makeReactionFold[#1, prod]], #2] &, {foldIn, foldOutFiltered}]
	];

	(* Consolidate\[Rule]True, record all intermediate (non-leaf) nodes for further pruning *)
	canProduce = DeleteDuplicates[Flatten[#[Reactants]&/@foldReactions]];
	childrenList = Union[childrenList, canProduce];

	{foldOutFiltered, foldReactions}

];


pairFoldEachMoreDepth[structsInput_, initialStructure_, pairingOps_, foldingOps_, foldFilter_, pairSelf_]:= Module[
	{currPairs, currRawPaired, currPaired, currPairedReactions, permutePaired, permuteReactions, permuteAll, allPaired, allPairReactions, foldOutFiltered, foldReactions, structsPairFold, reactionsPairFold},

	(* for current structures, pair each two of them *)
	currPairs = Complement[DeleteDuplicates[Sort/@If[pairSelf, Tuples[structsInput, 2], {structsInput}]], countedPairs];
	currRawPaired = Rest[Pairing[Sequence @@ #, Sequence @@ pairingOps]] & /@ currPairs;
	currPaired = DeleteDuplicates[Flatten[Function[{onePair}, {#, onePair[[2]]} & /@ onePair[[1]]] /@ Cases[Flatten[currRawPaired, Min[2, Lookup[pairingOps, Depth]]], Except[{}]], 1] /. x: {_Structure, _Structure} :> Sort[x]];

	currPairedReactions = makeReactionPair[#[[2]], #[[1]]] & /@ currPaired;

	(* permutated pairing after adding a new set of initial structures *)
	permuteAll = Table[pairFirstDepth[Append[initialStructure, s], pairingOps, pairSelf], {s, structsInput}];

	permuteReactions = Flatten[Last/@permuteAll];
	permutePaired = Flatten[#[Products]& /@ permuteReactions];

	(* combine the paired results from the above two approaches *)
	allPairReactions = Union[currPairedReactions, permuteReactions];
	allPaired = DeleteDuplicates[Flatten[#[Products]&/@allPairReactions]];

	(* fold to infinity afterwards *)
	{foldOutFiltered, foldReactions} = foldEachDepth[allPaired, initialStructure, foldingOps, foldFilter];

	(* results from a complete pair-fold step *)
	{structsPairFold, reactionsPairFold} = {Join[allPaired, Flatten[foldOutFiltered]], Join[allPairReactions, foldReactions]};

	{structsPairFold, reactionsPairFold}

];


(* ::Section:: *)
(*End*)
