(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*resolveQuantifyCellsMethod*)


DefineOptions[resolveQuantifyCellsMethod,
	SharedOptions :> {
		ExperimentQuantifyCells,
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


resolveQuantifyCellsMethod[
	mySamples:ListableP[Automatic | ObjectP[{Object[Sample], Object[Container]}] | {LocationPositionP, ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[]
] := Module[
	{
		outputSpecification, output, gatherTests, safeOps, methods, instruments,
		safeMethods, safeInstruments, allPrimitiveInformation, childPreparations, childMethodResolverTests, result, tests
	},

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* get the safe ops *)
	safeOps = SafeOptions[resolveQuantifyCellsMethod, ToList[myOptions]];

	(* --- SET VARIABLES --- *)
	{methods, instruments} = ToList /@ Lookup[safeOps, {Methods, Instruments}];

	(* at this point, we really should have already resolved everything, so we are just going to go through to try to call child method resolver *)
	(* just to be safe, we will pad Automatic to make sure methods, and instruments are of the same length *)
	{safeMethods, safeInstruments} = Module[{maxLength},
		(* get the longest length from Methods and Instruments *)
		maxLength = Max[Length /@ {methods, instruments}];

		(* pad Automatic *)
		PadRight[#, maxLength, Automatic]& /@ {methods, instruments}
	];

	(* get the primitive information so we can lookup method resolver later *)
	allPrimitiveInformation = Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]], Primitives];

	(* go over each method and call the method resolver to get methods *)
	{childPreparations, childMethodResolverTests} = Transpose@MapThread[
		Function[{method, instrument},
			If[MatchQ[method, Automatic],
				(* if we are hitting the padding with Automatic, just return manual and robotic *)
				{{Manual, Robotic}, {}},
				(* otherwise try to get the child method resolver *)
				Module[
					{
						childFunction, childPrimitiveHead, childMethodResolver, childOutputSpecification, optionsInput, optionsMap, optionsInputRenamed, childOutput, childOutputRules, childOutputRulesWithDefaults
					},

					(* get the child method resolver function *)
					childFunction = Lookup[Lookup[$QuantifyCellsMethodInformationLookup, method, <||>], "Function"];
					(* remove the 'Experiment' which will be the primitive head *)
					childPrimitiveHead = ToExpression[StringDelete[ToString[childFunction], "Experiment"]];
					(* get the method resolver function *)
					childMethodResolver = Lookup[Lookup[allPrimitiveInformation, childPrimitiveHead], MethodResolverFunction];

					(* shortcut if we did not find a method resolver *)
					If[MatchQ[childMethodResolver, _Missing],
						Return[{{Manual, Robotic}, {}}, Module]
					];

					(* get the output spec for child method resolver call *)
					childOutputSpecification = If[gatherTests, {Result, Tests}, {Result}];

					(* get the options for method resolver using our helper *)
					optionsInput = Join[
						splitMethodOptions[safeOps, method, instrument],
						{
							Output -> childOutputSpecification
						}
					];

					(* get the options map *)
					optionsMap = Lookup[Lookup[$QuantifyCellsMethodInformationLookup, method, <||>], "OptionsMap", {}];

					(* rename the options input such that it is accepted by the child option *)
					optionsInputRenamed = ((#[[1]] /. optionsMap) -> #[[2]]&) /@ optionsInput;

					(* call the child method resolver *)
					(* if we are 100% accurate, the input here also needs to be simulated with aliquot,
					but we know for sure that if Aliquot sample prep is specified then the whole preparation will be Manual anyway so no need to check the liquid handler compatibility anymore,
					shortcutting here to skip aliquot simulation *)
					childOutput = If[MemberQ[plateReaderPrimitiveTypes, childPrimitiveHead],
						childMethodResolver[
							mySamples,
							Object[Protocol, childPrimitiveHead],
							optionsInputRenamed,
							(* we have to feed Cache, Simulation, Output options separately to resolveReadPlateMethod to avoid it being defaulted by SafeOptions,
							which is just a result of how resolveReadPlateMethod takes in the experiment options arguments differently ({__Rule} + OptionsPattern[])
							compared to other method resolver functions (just a single OptionsPattern[])*)
							{
								Cache -> Lookup[safeOps, Cache, {}],
								Simulation -> Lookup[safeOps, Simulation, Null],
								Output -> childOutputSpecification
							}
						],
						childMethodResolver[
							mySamples,
							optionsInputRenamed
						]
					];

					(* make output specification rules for the actual child method resolver function returns *)
					childOutputRules = Rule @@@ Transpose[{childOutputSpecification, childOutput}];

					(* default Preparation to be {Manual, Robotic}, and Tests to be {} *)
					childOutputRulesWithDefaults = ReplaceRule[
						{Result -> {Manual, Robotic}, Tests -> {}},
						childOutputRules
					];

					(* parse the output and return *)
					{Result, Tests} /. childOutputRulesWithDefaults
				]
			]
		],
		{safeMethods, safeInstruments}
	];

	result = Which[
		(* if it is set it is set *)
		MatchQ[Lookup[safeOps, Preparation, Automatic], Except[Automatic]],
		Lookup[safeOps, Preparation],
		(* otherwise if we have resolved something from calling child method resolvers, get the unsorted intersection *)
		MemberQ[Flatten[childPreparations], PreparationMethodP],
		Apply[UnsortedIntersection, ToList /@ childPreparations],
		True,
		{Manual, Robotic}
	];

	tests = Flatten[childMethodResolverTests];

	outputSpecification /. {
		Result -> result,
		Tests -> tests
	}
];



(* ::Subsection:: *)
(*resolveQuantifyCellsWorkCell*)


DefineOptions[resolveQuantifyCellsWorkCell,
	SharedOptions :> {
		ExperimentQuantifyCells,
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


resolveQuantifyCellsWorkCell[
	mySamples:ListableP[Automatic | ObjectP[{Object[Sample], Object[Container]}] | {LocationPositionP, ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[]
] := Module[{safeOps, methods, instruments, safeMethods, safeInstruments, allPrimitiveInformation, childWorkCells, cache, simulation, samplePackets, cacheBall, cellsPresentQ, microbialQ, allowedWorkCells},

	(* get the safe ops *)
	safeOps = SafeOptions[resolveQuantifyCellsWorkCell, ToList[myOptions]];

	(* --- SET VARIABLES --- *)
	{methods, instruments} = ToList /@ Lookup[safeOps, {Methods, Instruments}];
	cache = Lookup[safeOps, Cache];
	simulation = Lookup[safeOps, Simulation];
	
	(* download necessary information for mySamples to check if there is cells present or not *)
	samplePackets = Download[
		mySamples,
		Packet[Living, CellType, Composition],
		Cache -> cache,
		Simulation -> simulation
	];

	cacheBall = Experiment`Private`FlattenCachePackets[{cache, samplePackets}];

	(* at this point, we really should have already resolved everything, so we are just going to go through to try to call child workcell resolver *)
	(* just to be safe, we will pad Automatic to make sure methods, and instruments are of the same length *)
	{safeMethods, safeInstruments} = Module[{maxLength},
		(* get the longest length from Methods and Instruments *)
		maxLength = Max[Length /@ {methods, instruments}];

		(* pad Automatic *)
		PadRight[#, maxLength, Automatic]& /@ {methods, instruments}
	];

	(* get the primitive information so we can lookup workcell resolver later *)
	allPrimitiveInformation = Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]], Primitives];

	(* go over each method and call the workcell resolver to get methods *)
	childWorkCells = MapThread[
		Function[{method, instrument},
			If[MatchQ[method, Automatic],
				(* if we are hitting the padding with Automatic, just return {microbioSTAR, bioSTAR, STAR} *)
				{microbioSTAR, bioSTAR, STAR},
				(* otherwise try to get the child workcell resolver *)
				Module[{childFunction, childPrimitiveHead, childWorkCellResolver, childOutputSpecification, optionsInput, optionsMap, optionsInputRenamed},

					(* get the child workcell resolver function *)
					childFunction = Lookup[Lookup[$QuantifyCellsMethodInformationLookup, method, <||>], "Function"];
					(* remove the 'Experiment' which will be the primitive head *)
					childPrimitiveHead = ToExpression[StringDelete[ToString[childFunction], "Experiment"]];
					(* get the workcell resolver function *)
					childWorkCellResolver = Lookup[Lookup[allPrimitiveInformation, childPrimitiveHead], WorkCellResolverFunction];

					(* shortcut if we did not find a workcell resolver *)
					If[MatchQ[childWorkCellResolver, _Missing],
						Return[{microbioSTAR, bioSTAR, STAR}, Module]
					];

					(* get the options for workcell resolver using our helper *)
					(* need to pass Cache/Simulation in in case method resolver needs some downloads for sample *)
					optionsInput = ReplaceRule[
						splitMethodOptions[safeOps, method, instrument],
						{
							Output -> childOutputSpecification,
							Cache -> cacheBall,
							Simulation -> simulation
						}
					];

					(* get the options map *)
					optionsMap = Lookup[Lookup[$QuantifyCellsMethodInformationLookup, method, <||>], "OptionsMap", {}];

					(* rename the options input such that it is accepted by the child option *)
					optionsInputRenamed = ((#[[1]] /. optionsMap) -> #[[2]]&) /@ optionsInput;

					(* call the child workcell resolver *)
					(* if we are 100% accurate, the input here also needs to be simulated with aliquot,
					but we know for sure that if Aliquot sample prep is specified then the whole preparation will be Manual anyway so no need to check the liquid handler compatibility anymore,
					shortcutting here to skip aliquot simulation *)
					(* quieting in case some method resolver does not take Cache/Simulation as an option when they do not need download *)
					If[MemberQ[plateReaderPrimitiveTypes, childPrimitiveHead],
						Quiet[
							childWorkCellResolver[
								childFunction,
								mySamples,
								optionsInputRenamed
							],
							{Warning::UnknownOption}
						],
						Quiet[
							childWorkCellResolver[
								mySamples,
								optionsInputRenamed
							],
							{Warning::UnknownOption}
						]
					]
				]
			]
		],
		{safeMethods, safeInstruments}
	];
	
	(* see if our sample contain living cells and/or microbial cells *)
	(* this code is modified from SP framework, Experiment/sources/PrimitiveFramework/Framework.m:9203, when setting {cellsPresentQ, sterileQ, microbialQ, cellSamplesForErrorChecking} *)
	{cellsPresentQ, microbialQ} = Module[{samplesContainingCells, livingMaterialQ, microbialMaterialQ, cellModels, cellTypes},

		samplesContainingCells = Map[
			Function[{cachePacket},
				Which[
					(* Check for Living -> True. *)
					TrueQ[Lookup[cachePacket, Living, Null]],
						Lookup[cachePacket, Object],
					(* Check for CellType -> CellTypeP. *)
					MemberQ[Lookup[cachePacket, CellType, Null], CellTypeP],
						Lookup[cachePacket, Object],
					(* Check for cell models in the Composition. *)
					MemberQ[Flatten@Lookup[cachePacket, Composition], ObjectP[Model[Cell]]],
						Lookup[cachePacket, Object],
					(* If we made it this far, consider this sample cell-free. *)
					True, Nothing
				]
			],
			samplePackets
		];

		(* Determine whether we have any cells or living samples. *)
		livingMaterialQ = GreaterQ[Length[samplesContainingCells], 0];

		(* If we have cells, get any cell models and cell types from the composition of all samples. *)
		{cellModels, cellTypes} = If[livingMaterialQ,
			{
				Cases[Flatten[Lookup[samplePackets, Composition]], ObjectP[Model[Cell]], Infinity],
				Lookup[samplePackets, CellType, Null]
			},
			{{}, {}}
		];

		(* Determine whether we have microbes. *)
		microbialMaterialQ = Or[
			MemberQ[cellModels, ObjectP[{Model[Cell, Bacteria], Model[Cell, Yeast]}]],
			MemberQ[cellTypes, MicrobialCellTypeP]
		];

		{livingMaterialQ, microbialMaterialQ}
	];

	(* pre-resolve a list of work cells to use *)
	allowedWorkCells = Switch[{cellsPresentQ, microbialQ},
		(* can only use microbioSTAR for microbial cells *)
		{True, True},
			{microbioSTAR},
		(* can only use {microbioSTAR, bioSTAR} for cells *)
		{True, _},
			{microbioSTAR, bioSTAR},
		(* otherwise, prioritize STAR *)
		_,
			{STAR, bioSTAR, microbioSTAR}
	];

	Which[
		(* if it is set it is set *)
		MatchQ[Lookup[safeOps, WorkCell, Automatic], Except[Automatic]],
			ToList[Lookup[safeOps, WorkCell, Automatic]],
		(* otherwise if we have resolved something from calling child workcell resolvers, get the unsorted intersection *)
		MemberQ[Flatten[childWorkCells], WorkCellP],
			UnsortedIntersection[allowedWorkCells, Apply[Sequence, ToList /@ childWorkCells]],
		True,
		allowedWorkCells
	]
];


