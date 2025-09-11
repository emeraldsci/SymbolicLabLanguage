(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Temp*)


IntervalP={_Integer,_Integer}; (* for specifying interval that folding/pairing must overlap with, NOT the interval of a Bond *)


(* ::Subsection::Closed:: *)
(*Interval partitioning*)


(* ::Subsubsection::Closed:: *)
(*deconstructIntervalC*)
Authors[deconstructIntervalByLength]:={"scicomp", "brad"};

(*
	Partition the interval {start, end} into a flat list of all possible sub-intervals
	of sizes ranging from 'min' to 'max'.
	e.g.
	deconstructIntervalC[1,4, 1, 2] \[Equal]>
		{{1,1},{2,2},{3,3},{4,4},{1,2},{2,3},{3,4}}
	deconstructInterval[2, 6, 3, 4] \[Equal]>
		{{2,4},{3,5},{4,6},{2,5},{3,6}}
*)
deconstructInterval[start_,end_,min_,max_]:=Flatten[
	(* iterate over interval size (from min to max) *)
	Table[
		(* ending positions are starting positions offset by size *)
		(* so make the range of starts, then pair them with offset versions *)
		With[
			{starts = Range[start,end-(size-1)]},
			Transpose[{starts,starts+size-1}]
		],
	{size,min,max}
	],
1];

deconstructIntervalC := deconstructIntervalC = Core`Private`SafeCompile[{{start,_Integer},{end,_Integer},{min,_Integer},{max,_Integer}},
Module[ {out,count=0,ix,iy,length,dist=end-start+1},
	length = Total[Range[Max[0,dist-max+1],dist-min+1]];
	out = Table[1,{length},{2}];
	For[ix = min,ix<=max,ix++,For[ iy = ix,iy<=dist,iy++,
	count = count+1;
	out[[count,1]] = iy-ix+start;
	out[[count,2]] = start+iy-1;
	]];
	out
]];



(* ::Subsubsection::Closed:: *)
(*deconstructIntervalReverseC*)

deconstructIntervalReverseC := deconstructIntervalReverseC = Core`Private`SafeCompile[{{start,_Integer},{end,_Integer},{min,_Integer},{max,_Integer}},
Module[ {out,count=0,ix,iy,length,dist=end-start+1},
	length = Total[Range[Max[0,dist-max+1],dist-min+1]];
	out = Table[1,{length},{2}];
	For[ix = min,ix<=max,ix++,For[ iy = ix,iy<=dist,iy++,
	count = count+1;
	out[[count,1]] = end+1-iy;
	out[[count,2]] = end-iy+ix;
	]];
	out
]];



(* ::Subsubsection::Closed:: *)
(*deconstructIntervalByLength*)

deconstructIntervalByLength::usage="
DEFINITIONS
	deconstructIntervalByLength[ {xx_Integer,yy_Integer}, m_Integer] ==> out:{ {{w_Integer,z_Integer}..}..}
		Deconstruct the interval {xx,yy} into groups of sub-intervals {w,z}, where w>=xx, z<=yy, (z-w)>=m, and each grouping has z-w=const

MORE INFORMATION
	deconstructIntervalByLength[{a,b},m] is used in sequence interaction analysis

INPUTS
	xx - start of the span
	yy - end of the span
	m  - The minimum length of subpositions to consider

OUTPUTS
	out - list of intervals of the form {w_Integer,z_Integer} where w>=xx and z<=yy

OPTIONS
	IncludeFull - (True|False):False
		If True, out includes {xx,yy}

EXAMPLES
	deconstructIntervalByLength[{1,4}]

AUTHORS
	Brad
";
Options[deconstructIntervalByLength] = {IncludeFull -> False};
deconstructIntervalByLength[{xx_Integer, yy_Integer}, m_Integer: 1, OptionsPattern[]] :=
Module[{offset, tops, bots},
	offset = If[OptionValue[IncludeFull], 0, 1];
	tops = Table[Range[xx, yy - i], {i, m - 1, yy - xx - offset}];
	bots = Table[Range[xx + i, yy], {i, m - 1, yy - xx - offset}];
	MapThread[Transpose[{#1, #2}] &, {tops, bots}]
];



(* ::Subsubsection::Closed:: *)
(*overlappingIntervalQ*)

overlappingIntervalQ::usage="
DEFINTION
		overlappingIntervalQ[a1,a2,b1,b2] ==> bool_?(MatchQ[#,True|False]&)
				Check if the interval {a1,a2} overlaps with the interval {b1,b2}
MORE INFORMATION
		Is not currently pattern matching. Be careful with inputs.
INPUTS
		'a1' - the minimum of the first interval
		'a2' - the maximum of the first interval
		'b1' - the minimum of the second interval
		'b2' - the maximum of the second interval

OUTPUTS
		'bool' - A boolean value representing True if the intervals overlap and False if the intervals do not overlap

ATTRIBUTES

OPTIONS

ERROR MESSAGES

EXAMPLES
		overlappingIntervalQ[1,4,3,10]
		overlappingIntervalQ[10,4,5,2]
		overlappingIntervalQ[-15,-5,-4,8]
		overlappingIntervalQ[-10,0,0,10]
SEE ALSO
		overlappingIntervalSortedQ,
		MatchQ,
		overlappiingFoldQ,
		deconstructIntervalC,
		deconstructInterval,
		deconstructIntervalReverseC,
		deconstructIntervalReverse

SOURCE
		Math.m

AUTHORS
		(Likely Frezza)
";

overlappingIntervalSortedQ = Core`Private`SafeCompile[{{a,_Integer},{b,_Integer},{c,_Integer},{d,_Integer}},
	Or[And[a<=c,b>=c],And[a<=d,b>=d],And[a<=c,b>=d],And[a>=c,b<=d]]];

overlappingIntervalQ= Core`Private`SafeCompile[{{a,_Integer},{b,_Integer},{c,_Integer},{d,_Integer}},
 overlappingIntervalSortedQ[Min[a,b],Max[a,b],Min[c,d],Max[c,d]]];



(* ::Subsubsection::Closed:: *)
(*overlappingFoldQ*)

overlappingFoldQ= Core`Private`SafeCompile[{{a1,_Integer},{a2,_Integer},{a3,_Integer},{a4,_Integer},{b1,_Integer},{b2,_Integer},{b3,_Integer},{b4,_Integer}},
	Or[overlappingIntervalQ[a1,a2,b1,b2],
	overlappingIntervalQ[a1,a2,b3,b4],
	overlappingIntervalQ[a3,a4,b1,b2],
	overlappingIntervalQ[a3,a4,b3,b4]]
];



(* ::Subsection:: *)
(*SimulateFolding*)


(* ::Subsubsection::Closed:: *)
(*Pattern*)


(* ::Subsubsection:: *)
(*foldsTranspose*)
Authors[foldStructure]:={"scicomp", "brad"};


foldsTranspose[foldings: {structures_, energies_, bonds_, percentages_}] := Map[Association[MapThread[#1 -> #2 &, {FoldingsFields, #}]] &, Transpose[foldings]];



(* ::Subsubsection:: *)
(*Options*)

DefineOptions[SimulateFolding,
	Options :> {
		{
			OptionName->Method,
			Default->Kinetic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> Kinetic|Thermodynamic],
			Description->"Thermodynamic method uses planar folding and returns the most thermodyanmically stable configurations. Kinetic method constructs a tree of folded structures, by recursively searching for folded regions, and returns folded structures at leaf nodes."
		},
		{
			OptionName->Heuristic,
			Default->Energy,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> HybridizationMethodP],
			Description->"Whether to optimize for maximum number of bonds or minimal energy."
		},
		{
			OptionName->Polymer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> DNA | RNA ],
			Description->"The polymer type that defines the potential alphabet a valid sequence should be composed of when the input sequence is ambiguous.",
			ResolutionDescription->"If Null or Automatic, polymer type is determined from the structure.  When multiple polymer inputs are provided, it resolves to Null which is the preferred choice when multiple inputs with different polymer types are used.  With multiple polymers, the individual polymer types are determined by subfunctions when needed."
		},
		{
			OptionName->Temperature,
			Default->37*Celsius,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Kelvin | Celsius ],
			Description->"The Gibbs free energies of the folded structures are computed at this temperature."
		},
		{
			OptionName->FoldingInterval,
			Default->All,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:> Alternatives[All]],
				Widget[Type->Expression, Pattern:> FoldingIntervalP, PatternTooltip ->"For example {1,4} or {9,10}", Size->Line]
			],
			Description->"Only folds that overlap with the strand and base positions specified here will be returned. All considers the entire sequence."
		},
		{
			OptionName->Depth,
			Default->Infinity,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[1, 1], PatternTooltip->"Structures folded from 1 to n times"],
				Widget[Type->Expression, Pattern:> {_Integer}, Size->Line, PatternTooltip->"Structures folded exactly n times"],
				Widget[Type->Enumeration, Pattern:> Alternatives[Infinity], PatternTooltip->"All possible structures foldings"]
			],
			Description->"Number of iterative folding steps conducted by the folding algorithm to reach the final structures. {n} returns structures folded exactly n times where as n returns structures folded 1 to n times."
		},
		{
			OptionName->Breadth,
			Default->20,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[1, 1]],
				Widget[Type->Enumeration, Pattern:> Alternatives[Infinity]]
			],
			Description->"Number of candidate structures to propagate forward at each iterative step in the folding algorithm."
		},
		{
			OptionName->Consolidate,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP ],
			Description->"If True, all folds are extended to their maximum length, and their subfolds are not returned."
		},
		{
			OptionName->SubOptimalStructureTolerance,
			Default->25*Percent,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
				Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Percent], Units->Percent],
				Widget[Type->Quantity, Pattern:> GreaterEqualP[0 KilocaloriePerMole], Units-> KilocaloriePerMole]
			],
			Description->"Threshold below which suboptimal structures will not be considered. If specified as integer, results will include all structures within the provided number of the optimal folded structure's bond count. If specified as energy, results will include all structures whose energy is within the provided absolute energy of the optimal folded structure's energy. If specified as percent, result will include all structures whose energy is within the provided percent of the optimal folded structure's energy."
		},
		{
			OptionName->MaxMismatch,
			Default->0,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Maximum number of mismatches allowed in a fold."
		},
		{
			OptionName->MinPieceSize,
			Default->1,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Minimum number of consecutive paired bases required in a fold containing mismatches."
		},
		{
			OptionName->MinLevel,
			Default->3,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Minimum number of bases required in each fold."
		},
		{
			OptionName->ExcludedSubstructures,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[{}] ],
				Widget[Type->Enumeration, Pattern:> LoopTypeP],
				Adder[
					Widget[Type->Enumeration, Pattern:> LoopTypeP]
				]
			],
			Description->"Substructures that are not allowed in folded strand.  Possible types are: StackingLoop, HairpinLoop, BulgeLoop, InternalLoop, and MultipleLoop."
		},
		{
			OptionName->MinHairpinLoopSize,
			Default->3,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Lower bound (inclusive) on the allowed number of unpaired bases in a hairpin."
		},
		{
			OptionName->MaxHairpinLoopSize,
			Default->Infinity,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
				Widget[Type->Enumeration, Pattern:> Alternatives[Infinity] ]
			],
			Description->"Upper bound (inclusive) on the allowed number of unpaired bases in a hairpin."
		},
		{
			OptionName->MinInternalLoopSize,
			Default->2,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[2, 1]],
			Description->"Lower bound (inclusive) on the allowed number of unpaired bases in an interior loop."
		},
		{
			OptionName->MaxInternalLoopSize,
			Default->Infinity,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[2, 1]],
				Widget[Type->Enumeration, Pattern:> Alternatives[Infinity] ]
			],
			Description->"Upper bound (inclusive) on the allowed number of unpaired bases in an interior loop."
		},
		{
			OptionName->MinBulgeLoopSize,
			Default->1,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[1, 1]],
			Description->"Lower bound (inclusive) on the allowed number of unpaired bases in a bulge loop."
		},
		{
			OptionName->MaxBulgeLoopSize,
			Default->Infinity,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[1, 1]],
				Widget[Type->Enumeration, Pattern:> Alternatives[Infinity] ]
			],
			Description->"Upper bound (inclusive) on the allowed number of unpaired bases in a bulge loop."
		},
		{
			OptionName->MinMultipleLoopSize,
			Default->0,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
			Description->"Lower bound (inclusive) on the allowed number of unpaired bases between each paired section in a multi loop."
		},
		{
			OptionName->AlternativeParameterization,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			ResolutionDescription->"If Automatic and the Thermodynamics field for the model oligomer is not available and the AlternativeParameterization is populated, it resolves to True. If Automatic and the thermodynamics object is available, it resolves to False.",
			Description->"If True, the thermodynamics object in the ReferenceOligomer field of the AlternativeParameterization field of the oligomer is used for thermodynamic properties."
		},
		{
			OptionName->ThermodynamicsModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object, Pattern:> ObjectP[Model[Physics,Thermodynamics]],ObjectTypes->{Model[Physics,Thermodynamics]}],
				Widget[Type->Expression, Pattern:> None, PatternTooltip->"None leaves the parameter determination up to the lookup functions.", Size->Line]
			],
			ResolutionDescription->"If Automatic, it will be resolved to Thermodynamics field of the model oligomer object. It is resolved to None if there is no model available and the thermodynamic properties are set to zero.",
			Description->"The thermodynamic properties of the polymer that determine the polymer folding structure are stored in this field."
		},
		{
			OptionName->Template,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Folding]],ObjectTypes->{Object[Simulation,Folding]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Types[Object[Simulation,Folding]],{UnresolvedOptions, ResolvedOptions}]]
			],
			Description->"Use ResolvedOptions in given object for default option resolution in current simulation."
		},
		OutputOption,
		UploadOption
	}
];



(* ::Subsubsection:: *)
(*SimulateFolding*)

Error::MixPolymerType = "Mix polymer type is currently unsupported.";
Error::UnboundStructure = "The input structure may have multiple strands without bonds and is currently unsupported, please try adding bonds between them.";
Warning::AlternativeParameterizationNotAvailable = "The AlternativeParameterization for oligomer `1` does not exist. Setting AlternativeParameterization to False.";
Error::InvalidThermodynamicsModel="The option ThermodynamicsModel does not match the correct pattern. Please check if the fields Wavelengths and MolarExtinctions are populated and if the MolarExtinctions have the {{_String->x LiterPerCentimeterMole}..} pattern.";

inputPatternSimulateFoldingP = SequenceP | StrandP | StructureP | ObjectP[Object[Sample]] | ObjectP[Model[Sample]];


SimulateFolding[in: ListableP[inputPatternSimulateFoldingP], ops: OptionsPattern[]] := Module[
	{startFields, inList, inListD, resolvedOptions, unresolvedOptions, resolvedOptionsResult, combinedOptions, outputSpecification, output, listedOptions, gatherTests, optionsRule, previewRule, testsRule, resultRule, safeOptions, safeOptionTests, validLengths, validLengthTests, templateTests, resolvedOptionsTests, foldingInterval, resolvedOpsSets, refList, initialStructure, initialStructureTests, coreFields},

	(* Make sure we're working with a list of options and inputs *)
	listedOptions = ToList[ops];
	inList = ToList[in];

	(* Get simulation options which account for when Option Object is specified *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateFolding,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateFolding,listedOptions,AutoCorrect->False],{}}
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
			ValidInputLengthsQ[SimulateFolding,{inList},listedOptions,Output->{Result,Tests}],
			{ValidInputLengthsQ[SimulateFolding,{inList},listedOptions],{}}
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
		ApplyTemplateOptions[SimulateFolding,{inList},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateFolding,{inList},listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	(* Note that function doesn't support cache and download is protected inside check *)
	resolvedOptionsResult = Check[
		{inListD,resolvedOptions,resolvedOptionsTests} = With[
			{testInListD = megaDownload[inList]},
			If[gatherTests,
				Join[{testInListD}, resolveSimulateFoldingOptions[testInListD, combinedOptions, Output->{Result,Tests}]],
				{testInListD, resolveSimulateFoldingOptions[testInListD, combinedOptions], {}}
			]
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* Get safeOptions value for FoldingInterval to put into resolvedOptions for downstream functions and to save with object *)
	(* The resolveSimulateFoldingOptions value for FoldingInterval option is specific to each input polymer--and there can be several different types in input.  In the above, FoldingInterval is set based on the first Polymer.  Rerurnning on subsequent or different polymers will fail to work so we need the safeOptions FoldingInterval for later use *)
	resolvedOptions = ReplaceRule[resolvedOptions, {FoldingInterval->Lookup[safeOptions,FoldingInterval]}];

	If[MemberQ[output,Preview] || MemberQ[output,Result] || gatherTests,
		Module[{structuresAndTests},
			(* Make the list of lists resolvedOptions customized for each input/Polymer *)
			resolvedOpsSets = resolveSimulateFoldingOptions[#, resolvedOptions] &/@ inListD;

			(* Set the starting point *)
			refList = resolveReferenceFolding /@ inList;

			(* Get the initial structures for each input *)
			structuresAndTests = If[gatherTests,
				MapThread[resolveInputsSimulateFolding[#1, #2, Output->{Result,Tests}] &,{inListD, resolvedOpsSets}],
				MapThread[{resolveInputsSimulateFolding[#1, #2],{}} &,{inListD, resolvedOpsSets}]
			];

			initialStructure = structuresAndTests[[;;,1]];
			initialStructureTests = structuresAndTests[[;;,2]];
		];
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* Do the folding *)
		coreFields = MapThread[
			simulateFoldingCore[#1, #2] &,
			{initialStructure, resolvedOpsSets}
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
		Module[
			{preview},

			(* Test that corefields exist *)
			preview = If[MemberQ[coreFields,$Failed],
				$Failed,
				(* else pull out the field to preview *)
				Append[FoldedStructures] /. coreFields
			];

			(* Catch case where there are no preview fields *)
			If[preview===Append[FoldedStructures] || preview===$Failed,
				$Failed,
				(* Because we are no longer taking first with single-nonlist inputs call to SimulatFolding we need the Following to keep from having output lists that are too deep *)
				If[MatchQ[preview,_List] && !MatchQ[in,_List],
					Zoomable[Rasterize[First[preview], ImageSize->If[MatchQ[preview,{{}..}],250,1000]]],
					Zoomable[Rasterize[preview, ImageSize->If[MatchQ[preview,{{}..}],250,1000]]]
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,initialStructureTests]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || resolvedOptions===$Failed,
			$Failed,
			Module[
				{endFields, packetList},

				(* Setup the Object fields *)
				endFields = Map[simulationPacketStandardFieldsFinish, resolvedOpsSets];

				packetList = MapThread[
					formatOutputSimulateFolding[startFields, #1, #2, #3, #4] &,
					{endFields, coreFields, resolvedOpsSets, refList}
				];

				(* Because we are no longer taking first with single-nonlist inputs call to SimulatFolding we need the Following to keep from having output lists that are too deep *)
				If[Lookup[resolvedOptions, Upload],
					With[{result=uploadAndReturn[packetList]},
						If[MatchQ[result,_List] && MatchQ[in,inputPatternSimulateFoldingP],
							First[result],
							result
						]
					],
					If[MatchQ[packetList,_List] && MatchQ[in,inputPatternSimulateFoldingP],
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
(*SimulateFoldingOptions*)

Authors[SimulateFoldingOptions] := {"brad"};

SimulateFoldingOptions[inList: ListableP[inputPatternSimulateFoldingP], ops : OptionsPattern[SimulateFolding]] :=	Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	SimulateFolding[inList, Sequence@@Append[noOutputOptions,Output->Options]]
];


(* ::Subsubsection::Closed:: *)
(*SimulateFoldingPreview*)

Authors[SimulateFoldingPreview] := {"brad"};

SimulateFoldingPreview[inList: ListableP[inputPatternSimulateFoldingP], ops : OptionsPattern[SimulateFolding]] := Module[
	{listedOptions, noOutputOptions},
	
	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	SimulateFolding[inList, Sequence@@Append[noOutputOptions,Output->Preview]]
];



(* ::Subsubsection:: *)
(*ValidSimulateFoldingQ*)

DefineOptions[ValidSimulateFoldingQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateFolding}
];

Authors[ValidSimulateFoldingQ] := {"brad"};

ValidSimulateFoldingQ[myInput: ListableP[inputPatternSimulateFoldingP], myOptions:OptionsPattern[ValidSimulateFoldingQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = ToList[myInput];
	listedObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];

	(* Call the function to get a list of tests *)
	functionTests = SimulateFolding[myInput,preparedOptions];

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

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidSimulateFoldingQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidSimulateFoldingQ"]
];



(* ::Subsubsection:: *)
(*resolveReference*)

resolveReferenceFolding[x: SequenceP | StrandP | StructureP] := StartingMaterial -> Null;
resolveReferenceFolding[x: ObjectP[{Object[Sample],Model[Sample]}] ] := StartingMaterial ->
    Link[First[Download[x,Composition[[All, 2]]], Null][Object], Simulations];



(* ::Subsubsection::Closed:: *)
(*polymerMixTestOrEmpty*)

polymerMixTestOrEmpty[struct_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::MixPolymerType];
		Message[Error::InvalidInput,struct];
	]
];


(* ::Subsubsection::Closed:: *)
(*inputLengthTestOrEmpty*)

polymerBondsTestOrEmpty[struct_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::UnboundStructure];
		Message[Error::InvalidInput,struct];
	]
];


(* ::Subsubsection:: *)
(*resolveInputsSimulateFolding*)

DefineOptions[resolveInputsSimulateFolding,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveInputsSimulateFolding[in_, resolvedOps_, ops:OptionsPattern[]]:=Module[
	{struct, result, output, listedOutput, collectTestsBoolean, polymerMixTest, polymerBondsTest},

	(* From resolveInputsSimulateFolding's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	{struct, polymerBondsTest} = If[collectTestsBoolean,
		resolveSimulateFoldingInputToStructure[in, resolvedOps, Output->{Result,Tests}],
		{resolveSimulateFoldingInputToStructure[in, resolvedOps], {}}
	];

	result = If[struct===$Failed || !SameQ@@DeleteCases[PolymerType[Flatten[struct[Motifs]]], Modification],
		$Failed,
		If[MatchQ[struct,Null],
			$Failed,
			NucleicAcids`Private`reformatBonds[StructureSort[struct],StrandBase]
		]
	];

	polymerMixTest = polymerMixTestOrEmpty[in,collectTestsBoolean,"No mixed polymer types",SameQ@@DeleteCases[PolymerType[Flatten[struct[Motifs]]], Modification]];

	output/.{Tests->Join[ToList[polymerMixTest],ToList[polymerBondsTest]],Result->result}
];



DefineOptions[resolveSimulateFoldingInputToStructure,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveSimulateFoldingInputToStructure[s_Structure,resolvedOps_, ops:OptionsPattern[]]:= Module[
	{struct, numStrands, boundStrandsIdx, result, output, listedOutput, collectTestsBoolean, polymerBondsTest},

	(* From resolveInputsSimulateFolding's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];
	struct = flattenDegenerate[ToStructure[s]];

	(* check if there is any strand with no bonds *)
	numStrands = Length[struct[Strands]];

	polymerBondsTest = polymerBondsTestOrEmpty[s,collectTestsBoolean,"Polymer has bonds",!(numStrands>1 && struct[Bonds]==={})];

	result = If[numStrands>1 && struct[Bonds]==={},
		$Failed,
		struct
	];


	output/.{Tests->polymerBondsTest,Result->result}
];

resolveSimulateFoldingInputToStructure[s:(SequenceP|_Strand),resolvedOps_, ops:OptionsPattern[]]:=Module[
	{result, output},

	(* get Output value but there are no tests here *)
	output = OptionDefault[OptionValue[Output]];

	result = flattenDegenerate[ToStructure[s, PassOptions[SimulateFolding,ToStructure,resolvedOps /. Rule[Polymer, Null] -> Rule[Polymer, Automatic]]]];

	output/.{Tests->{},Result->result}
];

resolveSimulateFoldingInputToStructure[obj: ObjectP[{Model[Sample],Object[Sample]}], resolvedOps_, ops:OptionsPattern[]] := Module[
	{result, singleStrandOrStructure, output,realObj},

	(* get Output value but there are no tests here *)
	output = OptionDefault[OptionValue[Output]];

	realObj = If[ObjectReferenceQ[obj],obj,obj[Object]];

	(* Get the strands from the composition field. *)
	singleStrandOrStructure = FirstOrDefault[Cases[Download[realObj,Composition[[All,2]][Molecule]],StrandP|StructureP],Null];

	result = resolveSimulateFoldingInputToStructure[singleStrandOrStructure, resolvedOps];

	output/.{Tests->{},Result->result}
];

resolveSimulateFoldingInputToStructure[_,_, ops:OptionsPattern[]]:=Module[
	{output},

	(* get Output value but there are no tests here *)
	output = OptionDefault[OptionValue[Output]];

	output/.{Tests->{},Result->$Failed};
];


(* ::Subsubsection::Closed:: *)
(*resolveSimulateFoldingOptions*)

DefineOptions[resolveSimulateFoldingOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveSimulateFoldingOptions[inList: ListableP[inputPatternSimulateFoldingP], myOptions:{(_Rule|_RuleDelayed)..}, ops:OptionsPattern[]]:=Module[
	{
		expandedOptions, output, listedOutput, collectTestsBoolean, messagesBoolean, method, heuristic, polymer, temperature, foldingInterval, depth, breadth, consolidate, subOptimalStructureTolerance, maxMismatch, minPieceSize, minLevel, excludedSubstructures, minHairpinLoopSize, maxHairpinLoopSize, minInternalLoopSize, maxInternalLoopSize, minBulgeLoopSize, maxBulgeLoopSize, minMultipleLoopSize, options, outputTypes, allTests, resolvedOptions,

		thermodynamicsModelBase,modelOligomerThermodynamics,thermodynamicsModel,

		(* For AlternativeParameterization*)
		alternativeParameterizationBase,modelOligomerAlternativeParameterization,alternativeParameterization
	},
	(* From resolveSimulateFoldingOptions's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	expandedOptions = Last[ExpandIndexMatchedInputs[SimulateFolding,{inList},myOptions]];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean = !collectTestsBoolean;

	(* Gather all the tests (this will be a list of Nulls if !Output->Test) *)
	allTests = {};

	(* If the polymer is specified or can be detected *)
	polymer=resolveOptionsSimulateFoldingPolymer[inList, Lookup[expandedOptions, Polymer]];

	(* The base ThermodynamicsModel provided in the option *)
	thermodynamicsModelBase=Lookup[expandedOptions,ThermodynamicsModel];

	(* The Thermodynamics field in the model oligomer *)
	modelOligomerThermodynamics=Quiet[Download[Model[Physics,Oligomer,SymbolName[polymer]],Thermodynamics]];

	(* Resolving the ThermodynamicsModel *)
	thermodynamicsModel=Which[
		(* If None, set it to None and the fields are properly populated to zeros in lookupModelThermodynamics *)
		MatchQ[thermodynamicsModelBase,None],
		None,

		(** TODO: If Automatic, we should use the Thermodynamics field in the model oligomer, however, the simulate folding is written such that RNA information may get inquired eventhough the polymer is DNA so for now use Null so lookupModelThermodynamics decides what to provide **)
		(* If Automatic use None *)
		(MatchQ[thermodynamicsModelBase,Automatic] && !MatchQ[modelOligomerThermodynamics,$Failed|Null|{}]),
		None,

		(* If Automatic and there is no Thermodynamics field, set it to None and it will be taken care of in the Physics.m functions *)
		(MatchQ[thermodynamicsModelBase,Automatic] && MatchQ[modelOligomerThermodynamics,$Failed|Null|{}]),
		None,

		(* If not Automatic and the model does not match the valid pattern for ThermodynamicsModel, throw an error *)
		(!MatchQ[thermodynamicsModelBase,Automatic] && !Physics`Private`validThermodynamicsModelQ[thermodynamicsModelBase]),
		(Message[Error::InvalidThermodynamicsModel];Message[Error::InvalidOption,ThermodynamicsModel];Null),

		(* If not Automatic and the model does match the valid pattern for ThermodynamicsModel, use the model provided *)
		True,
		thermodynamicsModelBase
	];

	(* The base AlternativeParameterization provided in the option *)
	alternativeParameterizationBase=Lookup[expandedOptions,AlternativeParameterization];

	(* The Thermodynamics field in the model oligomer *)
	modelOligomerAlternativeParameterization=Module[
		{parameterization},

		(* The alternativeParameterization field *)
		parameterization=If[!MatchQ[polymer,Null],
			Select[Physics`Private`lookupModelOligomer[polymer,AlternativeParameterization],(#[Model] == Thermodynamics &)],
			{}
		];

		If[!MatchQ[parameterization,{}],
			Quiet[Download[First[parameterization][ReferenceOligomer],Thermodynamics]],
			{}
		]
	];

	(* Resolving the AlternativeParameterization *)
	alternativeParameterization=Which[
		(* If Automatic and the thermo object is avaialble or a model thermodynamics is given use the Thermodynamics and set this to False *)
		(MatchQ[alternativeParameterizationBase,Automatic] && (!MatchQ[modelOligomerThermodynamics,$Failed|Null|{}] || !MatchQ[thermodynamicsModel,$Failed|Null|{}|None]) ),
		False,

		(* If Automatic and the thermo object is not avaialble and the AlternativeParameterization field is not available use the Thermodynamics field in the reference oligomer and set this to False *)
		(MatchQ[alternativeParameterizationBase,Automatic] && MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		False,

		(* If Automatic and the thermo object is not avaialble and the AlternativeParameterization field is available use the Thermodynamics field in the reference oligomer and set this to True *)
		(MatchQ[alternativeParameterizationBase,Automatic] && !MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		True,

		(* If Automatic and the thermo object is not avaialble and the AlternativeParameterization field is not available set this to False *)
		(MatchQ[alternativeParameterizationBase,Automatic] && MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		False,

		(* If polymer is specified and the AlternativeParameterization field is not available set this to False *)
		(MatchQ[alternativeParameterizationBase,True] && !MatchQ[polymer,Null] && MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		(Message[Warning::AlternativeParameterizationNotAvailable,polymer];False),

		(* If not Automatic and AlternativeParameterization is available use the user option *)
		True,
		alternativeParameterizationBase
	];

	(* Update options *)
	resolvedOptions = ReplaceRule[myOptions,
		Join[
			{
				Polymer -> polymer,
				FoldingInterval -> resolveOptionsSimulateFoldingFoldingInterval[inList, Lookup[expandedOptions, FoldingInterval]],
				ExcludedSubstructures -> resolveOptionsSimulateFoldingExcludedSubstructures[Lookup[expandedOptions, ExcludedSubstructures]],
				AlternativeParameterization->alternativeParameterization,
				ThermodynamicsModel->thermodynamicsModel
			},
			Map[
				(# -> resolveOptionsSimulateFoldingLoopSize[#, Lookup[expandedOptions, #]]) &,
				{MinHairpinLoopSize, MaxHairpinLoopSize, MinInternalLoopSize, MaxInternalLoopSize, MinBulgeLoopSize, MaxBulgeLoopSize, MinMultipleLoopSize}
			]
		]
	];
	output/.{Tests->allTests,Result->resolvedOptions}
];


resolveOptionsSimulateFoldingExcludedSubstructures[loop: LoopTypeP] := {loop};
resolveOptionsSimulateFoldingExcludedSubstructures[loop_] := loop;


resolveOptionsSimulateFoldingPolymer[seq:SequenceP,pol_]:=Quiet@PolymerType[seq,Polymer->pol];
resolveOptionsSimulateFoldingPolymer[seq_,pol:Automatic]:=Null;
resolveOptionsSimulateFoldingPolymer[seq_,pol_]:=pol;


resolveOptionsSimulateFoldingFoldingInterval[_,int:All]:=int;
resolveOptionsSimulateFoldingFoldingInterval[_,int:IntervalP]:={1,int};
resolveOptionsSimulateFoldingFoldingInterval[_Structure,int:{_Integer, IntervalP}]:=int;
resolveOptionsSimulateFoldingFoldingInterval[_Strand,int:{_Integer, IntervalP}]:=int;
resolveOptionsSimulateFoldingFoldingInterval[struct_Structure,int:{_Integer,_Integer,IntervalP}]:={First[int],List@@motifPositionToStrandPosition[struct[[1,int[[1]]]],int[[2]],int[[3]]]};
resolveOptionsSimulateFoldingFoldingInterval[strand_Strand,int:{_Integer, IntervalP}]:={1,List@@motifPositionToStrandPosition[strand,int[[1]],int[[2]]]};


resolveOptionsSimulateFoldingLoopSize[op_, Automatic] := Lookup[SafeOptions[SimulateFolding], op];
resolveOptionsSimulateFoldingLoopSize[op_, n_] := n;

motifPositionToStrandPosition = NucleicAcids`Private`motifPositionToStrandPosition;



(* ::Subsubsection:: *)
(*formatOutputSimulateFolding*)

formatOutputSimulateFolding[startFields_, endFields_, $Failed, resolvedOps_, ref_] := $Failed;
formatOutputSimulateFolding[startFields_, endFields_, coreFields_, resolvedOps_, ref_]:=Module[{packet},
	packet=Association[Join[{Type -> Object[Simulation, Folding]},
		startFields,
		coreFields,
		formatSimulateFoldingOptionFields[resolvedOps],
		{
			ref,
			With[{foldingsEval = foldsTranspose[Lookup[coreFields, {Append[FoldedStructures], Append[FoldedEnergies], Append[FoldedNumberOfBonds], Append[FoldedPercentage]}]]}, Foldings :> foldingsEval]
		},
		endFields
	]]
];


formatSimulateFoldingOptionFields[resolvedOps_] := {
	Method -> Lookup[resolvedOps, Method],
	Heuristic -> Lookup[resolvedOps, Heuristic],
	Temperature -> Lookup[resolvedOps, Temperature],
	Depth -> Lookup[resolvedOps, Depth],
	Breadth -> Lookup[resolvedOps, Breadth],
	Consolidate -> Lookup[resolvedOps, Consolidate],
	SubOptimalStructureTolerance -> Lookup[resolvedOps, SubOptimalStructureTolerance],
	MaxMismatch -> Lookup[resolvedOps, MaxMismatch],
	MinPieceSize -> Lookup[resolvedOps, MinPieceSize],
	MinLevel -> Lookup[resolvedOps, MinLevel],
	Append[ExcludedSubstructures] -> Lookup[resolvedOps, ExcludedSubstructures],
	MinHairpinLoopSize -> Lookup[resolvedOps, MinHairpinLoopSize],
	MaxHairpinLoopSize -> Lookup[resolvedOps, MaxHairpinLoopSize],
	MinInternalLoopSize -> Lookup[resolvedOps, MinInternalLoopSize],
	MaxInternalLoopSize -> Lookup[resolvedOps, MaxInternalLoopSize],
	MinBulgeLoopSize -> Lookup[resolvedOps, MinBulgeLoopSize],
	MaxBulgeLoopSize -> Lookup[resolvedOps, MaxBulgeLoopSize],
	MinMultipleLoopSize -> Lookup[resolvedOps, MinMultipleLoopSize]
};


(* ::Subsubsection:: *)
(*simulateFoldingCore*)


simulateFoldingCore[$Failed, resolvedOps_] := $Failed;
simulateFoldingCore[initialStructure_,resolvedOps_]:=Module[
	{foldedStructures, energies, flatFoldingInterval, bonds, eq, percentage, reactions, badPositions},

	foldedStructures = Switch[Lookup[resolvedOps, Method],
		Kinetic, foldingCore[initialStructure, resolvedOps],
		Thermodynamic, Select[foldingCore[initialStructure, resolvedOps], NumberOfBonds[#]>= Lookup[resolvedOps, MinLevel]&]
	];

	reactions = Map[Reaction[{initialStructure}, {#}, ClassifyReaction[{initialStructure}, {#}], ClassifyReaction[{#}, {initialStructure}]] &, foldedStructures];

	energies = If[
		MatchQ[foldedStructures, {}],
		{},
		SimulateFreeEnergy[
			#,Lookup[resolvedOps,Temperature],
			AlternativeParameterization->Lookup[resolvedOps,AlternativeParameterization],
			ThermodynamicsModel->Lookup[resolvedOps,ThermodynamicsModel],
			Upload->False
		][FreeEnergy] & /@ reactions
	];

	(*
		Find any unrealisitic (infinite energy) structures and remove them
	*)
	badPositions = Position[energies,Quantity[-Infinity, "KilocaloriesThermochemical"/"Moles"]|Quantity[Infinity, "KilocaloriesThermochemical"/"Moles"]];
	energies = Delete[energies,badPositions];
	reactions = Delete[reactions,badPositions];
	foldedStructures = Delete[foldedStructures,badPositions];

	flatFoldingInterval = {Flatten[Replace[Lookup[resolvedOps,FoldingInterval],(Null|All)->{Null,Null,Null}]]};
	(* add units *)
	flatFoldingInterval = MapAt[If[MatchQ[#,_Integer],#*Nucleotide,#]&,flatFoldingInterval,{;; , 2 ;; 3}];

	bonds = NumberOfBonds /@ foldedStructures;

	If[MatchQ[foldedStructures, {}],
		eq = {}; percentage = {},
		eq = Rest[SimulateEquilibrium[ReactionMechanism @@ reactions, {initialStructure -> 1 Molar}, Upload -> False][EquilibriumState][Magnitudes]]; percentage = (eq / Total[eq]) * 100;
];

	If[!MatchQ[Length[percentage], Length[foldedStructures]], percentage = With[{n = Length[foldedStructures]}, Table[1.0 / n, n]]];

	{
		InitialStructure->initialStructure,
		Append[FoldedStructures]-> foldedStructures,
		Append[FoldedEnergies]->energies,
		Append[FoldedNumberOfBonds] -> bonds,
		Append[FoldedPercentage] -> percentage,
		Append[FoldingInterval] -> First[flatFoldingInterval]
	}

];


getStructure[struc: {StructureP..}] := struc;
getStructure[else_] := Lookup[else, Structure];


(* given an interval *)
foldingCore[struct_, resolvedOps_List]:=Module[
	{interval, strandSpanStructures},

	interval = Replace[Lookup[resolvedOps, FoldingInterval], All->Null];

	(* Returns the result of either Kinetic or Thermodynamic folding on "structure" *)
	strandSpanStructures = Switch[Lookup[resolvedOps, Method],
		Kinetic,
			kineticFolding[struct,interval, resolvedOps],
		Thermodynamic,
			thermodynamicPlanarFolding[struct,resolvedOps]
	]
];


(* ::Subsection::Closed:: *)
(*Pairing*)


DefineOptions[Pairing,
	Options :> {
		{MinLevel -> 5, _Integer, "Minimum number of bases allowed in each pair."},
		{Depth -> {1}, _Integer | {_Integer}, "Number of times to pair the given sequences.  {n_Integer} returns structures paired exactly n times.  n_Integer returns structures paired 1 to n times."},
		{Consolidate -> True, True | False, "If True, all pairs are extended to their maximum length, and their subpairs are not returned."},
		{MaxMismatch -> 0, _Integer, "Maximum number of mismatches allowed in a pair."},
		{MinPieceSize -> 1, _Integer, "Minimum number of consecutive paired bases required in a pair containing mismatches."},
		{Polymer -> Automatic, DNA | RNA | Automatic | Null, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of when the input sequence is ambiguous."},
		{Parents -> False, BooleanP, "Returns an association, with values as the paired structures and keys as the parents.", Category->Hidden}
	}
];


(* ::Subsubsection:: *)
(*formatSequenceInput*)


formatSequenceInput::BadFormat="Bad input format: `1`";
formatSequenceInput::BadIntervalFormat="Bad interval format: `1`";

formatSequenceInput[inf: ObjectP[{Model[Sample],Object[Sample]}], pol_] := formatSequenceInput[{inf, Null}, pol];
formatSequenceInput[{obj: ObjectP[{Model[Sample],Object[Sample]}], int: (_List | Null)}, pol_] := Module[{singleStrandOrStructure},
	(* Get the strands from the composition field. *)
	singleStrandOrStructure = FirstOrDefault[Cases[Download[obj,Composition[[All,2]][Molecule]],StrandP|StructureP],Null];

	formatSequenceInput[{singleStrandOrStructure,int},pol];
];

formatSequenceInput[thing:(_Structure|_Strand|_String|Map[Blank,PolymerP]), pol_]:= formatSequenceInput[{thing, Null}, pol];
formatSequenceInput[{thing:(_Structure|_Strand|_String|Map[Blank,PolymerP]), int:(_List|Null)}, pol_]:= Module[
	{structInitial,struct,interval},

	(* format as structure *)
	structInitial = ToStructure[thing, Polymer -> pol];

	(* exit if input can't be properly formatted *)
	If[MatchQ[structInitial, Null], Return[{Null, Null}]];

	(* put into canonical form *)
	struct = NucleicAcids`Private`reformatBonds[StructureSort[structInitial],StrandBase];

	(* resolve interval argument *)
	interval = Switch[{thing,int},
					{_,Null}, Null,
					{_Structure,{_Integer,_Integer,IntervalP}}, {First[int], List@@motifPositionToStrandPosition[thing[[1,int[[1]]]],int[[2]],int[[3]]]},
					{_Structure,{_Integer, IntervalP}}, int,
					{_Strand,{_Integer, IntervalP}}, {1, List@@motifPositionToStrandPosition[thing,int[[1]],int[[2]]]},
					{_,IntervalP}, {1,int},
					{_,_}, (Message[formatSequenceInput::BadIntervalFormat,int]; Null)
				];

	{struct, interval}
];

formatSequenceInput[{thing_, int:(_List|Null)}, pol_]:= Message[formatSequenceInput::BadFormat, thing];


(* ::Subsubsection::Closed:: *)
(*Pairing*)


Pairing[thingA_, thingB_, ops:OptionsPattern[]]:= Module[
	{compA, intA, compB, intB, newOps, nestCommand, depth, newStructures, allStructures, cache, oldStructures={}, out, tmp, tmpOut, tmpOutParents, tmpRes, verbose, safeOps},

	verbose = False;

	safeOps = SafeOptions[Pairing, ToList[ops]];

	(* transform to proper format *)
	{compA, intA} = formatSequenceInput[thingA, Lookup[safeOps, Polymer]];
	{compB, intB} = formatSequenceInput[thingB, Lookup[safeOps, Polymer]];


	(* Fold fold over depth *)
	depth = Switch[Depth/.safeOps,
				_Integer, Depth/.safeOps,
				{_Integer}, First[Depth/.safeOps]
			];

	newStructures = {{compA, compB}}; (* initial pair *)
	allStructures = {compA, compB};

	(*=======================================================================================*)
	(* if depth == 1, then don't need to build a cache to store paired sturctures, will directly compute *)
	(*=======================================================================================*)
	If[depth==1,
		Return[
			With[{res = StructureSort/@pairComp[{compA, intA}, {compB, intB}, safeOps]},

				(* if Parents set to true, return the parents of each structure *)
				If[Parents/.safeOps,

					tmpRes = If[MatchQ[res, {}], {}, {res, {compA, compB}}];
					Switch[Depth/.safeOps,
						1, Prepend[{tmpRes}, {{{compA}, {Null, Null}}, {{compB}, {Null, Null}}}],
						{1}, tmpRes
					]/. {s_Structure :> NucleicAcids`Private`reformatBonds[s,StrandBase]},

					Switch[Depth/.safeOps,
						1, Prepend[{DeleteDuplicates[res]}, {compA, compB}],
						{1}, DeleteDuplicates[res]
					]/. {s_Structure :> NucleicAcids`Private`reformatBonds[s,StrandBase]}

				]
			]
		]
	];

	(*=======================================================================================*)
	(* if depth > 1, then build a cache to save computing time *)
	(*=======================================================================================*)

	(* build cache that stores strand pairing info *)
	cache = pairStructCache[{compA[Strands], intA}, {compB[Strands], intB}, safeOps];

	(* loop over Depth *)
	out=Table[

	(* loop over pairs of structures *)
		tmp = Table[
				StructureSort/@pairStruct[c[[1]], c[[2]], cache, safeOps],
				{c, newStructures}
			];

		(* all possible structures with their parental structures *)
		tmpOutParents = Select[Transpose[{tmp, newStructures}], !MatchQ[First[#], {}]&];

		(* all possible structures by its own *)
		tmpOut = Flatten[First/@tmpOutParents, 1];

		(* list of used structure pairs *)
		oldStructures = Union[Join[oldStructures, newStructures]];

		(* remove already counted structures *)
		tmpOut = Complement[tmpOut, allStructures];

		If[d<depth,
			(* list of all structures encountered so far *)
			allStructures = Union[Join[allStructures, tmpOut]];

			(* all possible pairs *)
			newStructures = Tuples[{allStructures, allStructures}];

			(* remove Structure pairs that were already tested *)
			newStructures = Complement[Sort/@newStructures, oldStructures];

		];

		{tmpOut, tmpOutParents},
		{d, depth}
	];

	(* if Parents set to true, return the parents of each structure *)
	If[Parents/.safeOps,

		Switch[Depth/.safeOps,
			_Integer, Prepend[Last/@out, {{{compA}, {Null, Null}}, {{compB}, {Null, Null}}}],
			{_Integer}, Last[Last/@out]
		] /. {s_Structure :> NucleicAcids`Private`reformatBonds[s, StrandBase]},

		Switch[Depth/.safeOps,
			_Integer, Prepend[First/@out, {compA, compB}],
			{_Integer}, Last[First/@out]
		] /. {s_Structure :> NucleicAcids`Private`reformatBonds[s,StrandBase]}
	]

];


(* ::Subsubsection:: *)
(*pairStructCache*)


pairStructCache[{strdsA_, intA_}, {strdsB_, intB_}, ops_]:= Module[
	{structA, structB, allPairs, pairedStruct = <||>},

	allPairs = Tuples[{Join[strdsA, strdsB], Join[strdsA, strdsB]}];

	Table[
		AssociateTo[pairedStruct, p -> Flatten[#[Bonds]&/@pairComp[{Structure[{p[[1]]}, {}], intA}, {Structure[{p[[2]]}, {}], intA}, ops]]],
		{p, allPairs}
	];

	pairedStruct

];


(* ::Subsubsection:: *)
(*pairStruct*)


pairStruct[structA_, structB_, pairedStructCache_, ops_]:= Module[
	{strandsInA, strandsInB, combs, existingBondsA, existingBondsB, tmpRes},

	(* all strands that are possible to get paired *)
	strandsInA = structA[Strands];
	strandsInB = structB[Strands];

	(* all possible combinations *)
	combs = Tuples[{Range[Length[strandsInA]], Range[Length[strandsInB]]}];

	(* pair the possible combinations but keep the existing bonds *)
	existingBondsA = structA[Bonds];
	existingBondsB = structB[Bonds];

	tmpRes = pairStructCore[#, strandsInA, strandsInB, pairedStructCache, existingBondsA, existingBondsB, Lookup[ops, MinLevel]]&/@combs;

	Flatten[tmpRes]


];


(* ::Subsubsection:: *)
(*pairStructCore*)


pairStructCore[comb_, strandsInA_, strandsInB_, pairedStructCache_, existingBondsA_, existingBondsB_, minLevel_]:= Module[
	{idx1, idx2, strandPair, possibleBonds, int1, int2, tmpBonds, existingBondsBNew, finalBonds},

	{idx1, idx2} = comb;

	(* retrieve possible pairings from chache *)
	strandPair = {strandsInA[[idx1]], strandsInB[[idx2]]};
	possibleBonds = pairedStructCache[strandPair];

	If[MatchQ[possibleBonds, {}], Return[{}]];

	(* intervals in each strand that are already bonded *)
	int1 = Cases[bondedIntervals[idx1, #]&/@existingBondsA, _Span];
	int2 = Cases[bondedIntervals[idx2, #]&/@existingBondsB, _Span];

	(* check if intervals in the possible bonds will overlap with the existing bonds*)
(*	tmpBonds = Select[possibleBonds, (MatchQ[IntervalIntersection[Interval[{#[[1]][[2]][[1]], #[[1]][[2]][[2]]}], Interval@@(Apply[List,#]&/@int1)], Interval[]]&&
											MatchQ[IntervalIntersection[Interval[{#[[2]][[2]][[1]], #[[2]][[2]][[2]]}], Interval@@(Apply[List,#]&/@int2)], Interval[]])&];*)

	tmpBonds = DeleteCases[truncatedBond[#, int1, int2, minLevel]&/@possibleBonds, {}];

	If[MatchQ[tmpBonds, {}], Return[{}]];

	Authors[Bond]:={"brad"};
	(* form the new structures *)
	existingBondsBNew = existingBondsB/.Bond[{numA_, AInt_}, {numB_, BInt_}]:> Bond[{numA+Length[strandsInA], AInt}, {numB+Length[strandsInA], BInt}];
	finalBonds = tmpBonds/.Bond[{1, AInt_}, {2, BInt_}]:> Bond[{idx1, AInt}, {idx2+Length[strandsInA], BInt}];

	Structure[Join[strandsInA, strandsInB], Join[existingBondsA, {#}, existingBondsBNew]]&/@finalBonds

];


bondedIntervals[idx_, Bond[{idx_, int1_Span}, {idx_, int2_Span}]] := Sequence[int1, int2];
bondedIntervals[idx_, Bond[{idx_, int_Span}, {___}]] := int;
bondedIntervals[idx_, Bond[{___}, {idx_, int_Span}]] := int;


(* this function checks if a possible bond intersects with an existing bond, but the remaining (un-intersected) part can still form a new bond *)
truncatedBond[possibleBond_, int1_, int2_, minLevel_]:= Module[
	{range1, range2, map1to2, map2to1, truncated1, truncated2, intersectBondIn1, finalInt},

	(* get the intervals of the possible bond on each strand *)
	range1 = Range[possibleBond[[1,2,1]], possibleBond[[1,2,2]]];
	range2 = Range[possibleBond[[2,2,1]], possibleBond[[2,2,2]]];

	(* build a mapping to know the correspondence between bases on the possible bonded strands *)
	map1to2 = AssociationThread[range1, Reverse[range2]];
	map2to1 = AssociationThread[Reverse[range2], range1];

	(* for the possible bond, exclude the existing bonded intervals in each strand, get the remaining parts *)
	truncated1 = Complement[range1, Flatten[Range@@#&/@int1]];
	truncated2 = Complement[range2, Flatten[Range@@#&/@int2]];

	(* check whether the remaining part in each strand can still form a bond *)
	intersectBondIn1 = Intersection[truncated1, truncated2/.map2to1];

	finalInt = If[Length[intersectBondIn1]<=1,
					{},
					Select[consecutiveInt[intersectBondIn1], Last[#]-First[#]>=(minLevel-1)&]
				];

	If[MatchQ[Flatten[finalInt], {}],
		{},
		Sequence@@Map[Bond[{1, First[#];;Last[#]}, {2, map1to2[Last[#]];; map1to2[First[#]]}]&, finalInt]
	]

];


consecutiveInt[a_List]:={a[[Prepend[#+1,1]]],a[[Append[#,-1]]]}\[Transpose]&@SparseArray[Differences@a,Automatic,1]["AdjacencyLists"];


(* ::Subsubsection:: *)
(*pairComp*)


(* table over all strand combinations *)
pairComp[{compA_Structure,intA_}, {compB_Structure,intB_}, ops_]:=
	Join@@Table[pairMinComp[{c[[1]], intA}, {c[[2]], intB}, ops], {c, Tuples[{SplitStructure[compA], SplitStructure[compB]}]}];


(* given two intervals, only look at those two strands *)
pairMinComp[{compA_Structure,intA:{strIndA_Integer,intervalA:IntervalP}},{compB_Structure,intB:{strIndB_Integer,intervalB:IntervalP}},ops_]:= Module[
	{interactions,strs,out,strsA,strsB,newComp},

	strsA=ToStrand[compA,Replace->True,FastTrack->True];
	strsB=ToStrand[compB,Replace->True,FastTrack->True];
	interactions=pairStrand[{strsA[[strIndA]],intervalA},{strsB[[strIndB]],intervalB},ops];
	newComp=StructureJoin[compA,compB];

	structureFromStructureInteraction[newComp,strIndA,strIndB+Length[strsA],interactions]
		(* offset strand index in Structure ? *)
];

(* given one interval, look at that interval with everything else *)
pairMinComp[{compA_Structure,Null},{compB_Structure,intB:{strIndA_Integer,intervalA:IntervalP}},ops_]:= pairMinComp[{compB,intB},{compA,Null},ops];

pairMinComp[{compA_Structure,intA:{strIndA_Integer,intervalA:IntervalP}},{compB_Structure,Null},ops_]:= Module[
	{interactions,strs,out,subsets,strsA,strsB,newComp},

	strsA=ToStrand[compA,Replace->True,FastTrack->True];
	strsB=ToStrand[compB,Replace->True,FastTrack->True];
	subsets=Tuples[{{strIndA},Range[Length[strsB]]}];
	out = Table[
		interactions=pairStrand[{strsA[[First[i]]],intervalA},{strsB[[Last[i]]],{1,StrandLength[strsB[[Last[i]]],FastTrack->True]}},ops];
		newComp=StructureJoin[compA,compB];
		structureFromStructureInteraction[newComp,First[i],Last[i]+Length[strsA],interactions],
		(* offset strand index in Structure ? *)
	{i,subsets}];

	Flatten[out,1]

];

(* given no intervals, table over all combinations *)
pairMinComp[{compA_Structure,Null}, {compB_Structure,Null}, ops_]:= Module[
	{interactions,strs,out,subsets,strsA,strsB,newComp,verbose},

	verbose = False;

	strsA = ToStrand[compA, Replace->True, FastTrack->True];
	strsB = ToStrand[compB, Replace->True, FastTrack->True];

	subsets = Tuples[{Range[Length[strsA]], Range[Length[strsB]]}];

	out = Table[
			interactions = pairStrand[{strsA[[First[i]]], {1, StrandLength[strsA[[First[i]]], FastTrack->True]}},
										{strsB[[Last[i]]], {1, StrandLength[strsB[[Last[i]]], FastTrack->True]}}, ops];
				newComp = StructureJoin[compA, compB];
			structureFromStructureInteraction[newComp, First[i], Last[i]+Length[strsA], interactions],
			(* offset strand index in Structure ? *)
			{i, subsets}
		];

	Flatten[out,1]

];


(* ::Subsubsection:: *)
(*pairStrand*)


(* do all the string matching *)
pairingStrand[{strA_Strand,intA:IntervalP},{strB_Strand,intB:IntervalP},ops_]:=pairStrand[{strA,intA},{strB,intB},ops];
pairingStrand[strA_Strand,strB_Strand,ops_]:=pairStrand[{strA,{1,StrandLength[strA]}},{strB,{1,StrandLength[strB]}},ops];

pairStrand[{strA_Strand,intA:IntervalP},{strB_Strand,intB:IntervalP},ops_]:=Module[
	{seqA,seqB,interactions,tmp},

	seqA=transformStrandToUniqueBases[strA];
	seqB=transformStrandToUniqueBases[strB];

	interactions=sequenceInteractions[{seqA,intA},{seqB,intB},Lookup[ops, MinLevel],Null,Lookup[ops, MaxMismatch],
		Lookup[ops, MinPieceSize],{},Lookup[ops, Consolidate],False,0]; (* no hairpin constraint for pairing *)

	interactions

];


(* ::Subsection::Closed:: *)
(*Kinetic Folding*)

(* these reset the memoized results on reload *)
baseCharIndex = 97; (* start with 'a' to skip 'X' *)
uniqueBasePairingRules = {"X"->"Y",_->"Y"}; (* need this for things that don't pair to prevent infinite loop *)
Clear[uniqueBaseReplacementRules];

(* ::Subsubsection::Closed:: *)
(*unique base Pairing rules*)
uniqueBaseReplacementRules[pol_] :=
  Module[{pac, bases, newBases, pairings, newPairings, newPairingRules, out},
		(* get the list of bases *)
	 pac = Physics`Private`modelOligomerParameters[pol];
  bases = pac[Alphabet];
	 (* get list of new single-character bases *)
   newBases =
    FromCharacterCode /@
     Range[baseCharIndex, baseCharIndex + Length[bases] - 1, 1];
		 (* rules to go from old bases to new single-char bases *)
   out = MapThread[Rule, {bases, newBases}];
	 (* memoize answer *)
	 uniqueBaseReplacementRules[pol] = out;

	 (* update the starting char for the next polymer type *)
	 baseCharIndex = baseCharIndex + Length[bases];

   (* pairing bases *)
	 pairings = pac[Pairing];
	 (* swap in the new single-char bases *)
   newPairings = If[MatchQ[pairings, {{__String} ..}],
   	pairings /. out,
   	Table[{"X"}, Length[bases]]
   ];
	 (* pairing rules using new single-char bases *)
 	newPairingRules = MapThread[Rule[#1, If[Length[#2] > 1, Alternatives @@ #2, First[#2]]] &, {newBases, newPairings}];
	 (* memoize this result *)
   uniqueBasePairingRules = Join[newPairingRules,uniqueBasePairingRules]; (* new rules at start so blank rule stays at end *)

		(* return the base map *)
   out
   ];

(* transform a sequence into the unique-base alphabet *)
transformSequenceToUniqueBases[seq_String,pol_Symbol]:=StringReplace[seq,uniqueBaseReplacementRules[pol]];

(* transform a strand into a string in the unique-base alphabet *)
transformStrandToUniqueBases[str_Strand]:=	StringJoin@@Table[transformSequenceToUniqueBases[s[[3]],s[[4]]],{s,ParseStrand[str]}];



(* ::Subsubsection:: *)
(*kineticFolding*)


(*
 * Function: foldingTree
 ***********************
 * The Kinetic folding method.
 *)

(* This is the setup version of foldingTree[]. It is called by Folding[] *)
kineticFolding[com_Structure,interval_,ops_List]:=Module[
	{finalDepth,foldsWithDepth,foldRules, depth, levelBreadth, branchBreadth, foldOut},

	branchBreadth = Infinity;
	{depth, levelBreadth} = Lookup[ops, {Depth, Breadth}];
	(* Stores the final depth reached by foldingTree in finalDepth.
	 * Stores in foldsWithDepth a list of Rule[depthOfFold, foldedStructure] for all folds
	 * made by recursive calls to foldingTree. *)

	{finalDepth,foldsWithDepth} = Reap[
		If[depth=!=Infinity,Sow[0->com,"Species"]];
		foldingTree[{com},interval,{depth,levelBreadth,branchBreadth},1,ops],
		"Species"
	];

	(* First, gathers folded Structures by their depths (# of folds).
	 * Then, makes a list of rules with lhs=depth and rhs=list of folded structures at that depth.
	 * Then appends a rule with lhs = any other Integer and rhs={} - so all depths without corresponding
	 * folded Structures have a null set of Structures associated with them. *)
	foldRules= Append[
		Rule[#[[1,1]],#[[;;,2]]]&/@GatherBy[Flatten[foldsWithDepth],#[[1]]&],
		Rule[_Integer,{}]
	];

	(* Return a subset of all folded structures produced by foldingTree *)
	foldOut = Switch[depth,
		(* If only one depth was requested, return all folded Structures with that depth (# of folds) *)
		{_Integer}, First[Replace[depth,foldRules,{1}]],

		(* If multiple depths were requested, return a list of lists, where each sublist contains folded Structures
		 * with the same # of folds. *)
		_Integer, Flatten[Replace[Range[1,depth],foldRules,{1}]],

		(* If all possible depths were requested, do the same as the Switch case above this one, but do it for all
		 * depths reached by foldingTree *)
		Infinity, DeleteCases[Flatten[Replace[Range[0,Min[finalDepth,depth]],foldRules,{1}]],com,{1}]
	];

	NucleicAcids`Private`consolidateBonds[NucleicAcids`Private`reformatBonds[#, StrandBase]]& /@ foldOut

];


(* ::Subsubsection:: *)
(*foldingTree*)


(* This is the recursive version of foldingTree *)
foldingTree[in:{_Structure...},interval_,{depth_,levelBreadth_,branchBreadth_},d_,ops_List]:=Module[
	{newFoldRules,newFolds,sowMe,keepFolding,stopFolding,m},

	(* BASE CASE: when there are no more Structures to propagate with folds or when the current depth is greater than that requested by the user.
		 * This value of currentDepth will be returned to the Reap call in the setup version of foldingTree[]. It will be stored in the "finalDepth" variable
		 * of that module. *)
	If[(d>depth)||(in==={}),Return[d]];

	(* Fold all given structures once.
	 * foldComp is the main workhorse of foldingTree. It finds pairings and folds of the proper length and returns the resulting structure. *)
	newFolds = Map[StructureSort/@foldComp[#,interval,ReplaceRule[ops, {Depth->{1}}]]&,in];

	newFoldRules = MapThread[Thread[Rule[#1,#2]]&,{in,newFolds}];

	sowMe = foldsToSow[in,newFolds,depth,levelBreadth,branchBreadth,d];

	Map[Sow[#,"Reaction"];&,Flatten[newFoldRules]];

	(* Sow all folds as rules from lhs=currentDepth to rhs=foldedStructure
	 * These will be picked up by the Reap *)
	sowFolds[sowMe,d];

	keepFolding = foldsToPropagate[in,newFolds,sowMe,depth,levelBreadth,branchBreadth,d];

	foldingTree[keepFolding,interval,{depth,levelBreadth,branchBreadth},d+1,ops]

];



(*
 * Function: foldsToSow
 * -----------------
 * Returns only the fields that should be sown
 *)
foldsToSow[old_,new_,depth:Infinity,Infinity,branchBreadth_,d_]:=
	DeleteDuplicates@Flatten[Extract[old,Position[new,{},{1}]],1];
foldsToSow[old_,new_,depth:Infinity,levelBreadth_,branchBreadth_,d_]:=
	DeleteDuplicates@Flatten[Extract[old,Position[new,{},{1}]],1];

foldsToSow[old_,new_,_Integer,Infinity,     branchBreadth_,d_]:=DeleteDuplicates@Flatten[new,1];
foldsToSow[old_,new_,_Integer,levelBreadth_,branchBreadth_,d_]:=
	takeFolds[new,levelBreadth,branchBreadth];

foldsToSow[old_,new_,{d_Integer},Infinity,branchBreadth_,d_]:=DeleteDuplicates@Flatten[new,1];
foldsToSow[old_,new_,{d_Integer},levelBreadth_,branchBreadth_,d_]:=takeFolds[new,levelBreadth,branchBreadth];
foldsToSow[old_,new_,{_Integer},levelBreadth_,branchBreadth_,d_]:={};


(*
 * Function: sowFolds
 * ---------------
 * Sows each folded Structure, forming each sow as: Rule[depthOfFold, foldedStructure]
 *)
sowFolds[foldsList_List,d_]:= Sow[Rule[d,#],"Species"]&/@foldsList;


(*
 * Function: foldsToPropagate
 * ----------------------
 * Selects a number of possible folds (Structures) to propagate forward according
 * to the "breadth" parameter. The folds with the highest number of bonds are taken.
 *)
foldsToPropagate[old_,new_,sowed_,depth_,levelBreadth_,branchBreadth_,depth_]:={};
foldsToPropagate[old_,new_,sowed_,{depth_},levelBreadth_,branchBreadth_,depth_]:={};
(*
	foldsToPropagate[old_,new_,sowed_,depth_,Infinity,branchBreadth_,d_]:=
	DeleteDuplicates[Flatten@new];
*)
foldsToPropagate[old_,new_,sowed_,depth_,levelBreadth:Infinity,branchBreadth_,d_]:=
	takeFolds[new,levelBreadth,branchBreadth];
foldsToPropagate[old_,new_,sowed_,depth:{_Integer},levelBreadth_,branchBreadth_,d_]:=
	takeFolds[new,levelBreadth,branchBreadth];
foldsToPropagate[old_,new_,sowed_,Infinity,levelBreadth:Except[Infinity],branchBreadth_,d_]:=
	takeFolds[new,levelBreadth,branchBreadth];
foldsToPropagate[old_,new_,sowed_,depth_,levelBreadth_,branchBreadth_,d_]:=sowed;


(*
 * Function: foldLength
 * -----------------
 * Note: Equivalent to function "NumberOfBonds[]"
 * Returns the number of bonds in the Structure
 *)
foldLength[product_Structure,reactant_Structure]:=foldLength[reactant];
foldLength[Structure[strs_,{}]]:=0;
foldLength[Structure[strs_,pairs_]]:=With[{
		pairSizes=List@@@pairs[[;;,1,2]]
	},
	Total[1+pairSizes.{-1,1}]
];

(*
 * Function: takeFolds
 * ----------------
 * First, takeFolds sorts a list of possible folds (Structures) in descending order by number of folds. (Exact-duplicate folds are deleted)
 * If breadth is less than the length of the list, the function returns the first breadth # of folds.
 * If breadth is greater than the list's length, the function returns the entire sorted possible folds list.
 * Returns {} if the list of possible folds is empty.
 *
 * Possible issue: DeleteDuplicates[] may not recognize two structures as equivalent if their strands or bonds are in different orders or formats.
 *)
takeFolds[{},levelBreadth_,branchBreadth_]:={};
takeFolds[foldListList:{_List..},levelBreadth_,branchBreadth:Infinity]:=
	takeFolds[Flatten[foldListList],levelBreadth];
takeFolds[foldListList:{_List..},levelBreadth_,branchBreadth_]:=With[
	{branchPruned = Map[takeFolds[#,branchBreadth]&,foldListList]},
(*
	Print["BEFORE:",{Length[Flatten[foldListList]],Length/@foldListList}];
	Print["AFTER:",{Length[Flatten[branchPruned]],Length/@branchPruned}];
*)
	takeFolds[Flatten[branchPruned],levelBreadth]
];
takeFolds[foldList_List,breadth_Integer]:=With[
	{uniqueFolds=DeleteDuplicates[Flatten@foldList]},
	Take[
		Reverse[SortBy[uniqueFolds,foldLength]],
		If[breadth>Length[uniqueFolds],All,breadth]
	]
];
takeFolds[foldList_List,breadth:Infinity]:=DeleteDuplicates[Flatten@foldList];


(* ::Subsubsection::Closed:: *)
(*foldComp*)


(*
 * Function: foldComp
 * -----------------
 * Fold a Structure by splitting it into minimal structures, then folding each of those.
 * Arguments:
 *  - struct is the existing structure
 *  - int is in the form Null | {strandIndex_Integer, intervalToFoldOver:IntervalP}.
 *    Each alternative will call its own version of foldMinStruct (one where folding happens
 *    over the whole structure and one where it's just over a specific interval)
 *)
foldComp[struct_Structure,int_,ops_]:=

	(* 'structureList': a list of 'minimal structures', which are structures that
	 * are in 'struct' but not bonded to each other. For example, a structure with 3
	 * strands but only 2 bonded to each other will split into 2 structures: one with
	 * the two bonded strands and one with the other free strand.
	 * in SplitStructure, each minimal structure has StructureSort called on them. *)
	With[{structureList=SplitStructure[struct]},

		(* Why Join? *)
		Apply[Join,

			(* Call foldMinStruct on each 'minimal structure' in structureList *)
			Table[
				foldMinStruct[s,int,ops],
				{s,structureList}
			]
		]
	];



(* ::Subsubsection::Closed:: *)
(*foldMinStruct*)


(*
 * Function: foldMinStruct
 * Condition: We are NOT pairing/folding over an interval
 * ----------------------------------------------
 * Fold a minimal Structure by folding each strand onto itself, and also Pairing the strands together
 * (any paired strands combining in other places counts as folding).
 * Arguments:
 *  - struct: a minimal structure to fold. 'Minimal structure' means you can get from any base to any
 *          other base in the structure by traversing hydrogen and covalent bonds (i.e. the structure
 *          is one big connected graph)
 *)
foldMinStruct[struct_Structure,Null,ops_]:=
	Module[{interactions,strs,out,newOps,depth,nestCommand,interStrand,intraStrand,subsets},

	(* pull strand pieces from Structure, and replace paired bases with \" X \" *)
	strs=ToStrand[struct,Replace->True,FastTrack->True];

	(* find all intra-strand interactions *)
	intraStrand =
		Table[
			(* interactions at strand level *)
			interactions=foldStrand[strs[[i]],{1,StrandLength[strs[[i]],FastTrack->True]},ops];

			(* make list of structures by adding interactions to original Structure *)
			structureFromStructureInteraction[struct,i,i,interactions],

			(* ITERATION: i goes from 1 to the number of strands in struct *)
			{i,Length[strs]}
		];

	(* All the 2-tuples of strand Pairing to consider (pairs of strands to pair). *)
	subsets=Subsets[Range[1,Length[strs]],{2}];

	(* Find all inter-strand interactions.
	 * These strands are already bonded with one another, so this is still considered folding. *)
	interStrand=
		Table[

			With[{strInd1=s[[1]], strInd2=s[[2]]},

				(* interactions from Pairing two strands *)
				interactions=
				pairStrand[
					{strs[[strInd1]], {1, StrandLength[strs[[strInd1]], FastTrack->True]}},
					{strs[[strInd2]], {1, StrandLength[strs[[strInd2]], FastTrack->True]}},
					ops
				];

				(* make structures from the pairs and the original component *)
				structureFromStructureInteraction[struct,strInd1,strInd2,interactions]
			],

			(* iterating over subsets of strand pairing, which are pairs of strands to pair with each other *)
			{s,subsets}
		];

		(* Return list of both inter- and intra- strand foldings *)
		Flatten[Join[interStrand,intraStrand],1]
];


(*
 * Function: foldMinStruct
 * Condition: We are pairing/folding over an interval
 * -------------------------------------------
 * Fold Structure strands over an interval
 * Arguments:
 *  - struct: a minimal structure to fold. 'Minimal structure' means you can get from any base to any
 *          other base in the structure by traversing hydrogen and covalent bonds (i.e. the structure
 *          is one big connected graph)
 *  - strInd: the index of a strand that your folding interval is over.
 *  - interval: an interval on the strand of interest that you're folding over.
 *)
foldMinStruct[struct_Structure,{strInd_Integer,interval:IntervalP},ops_]:=
	Module[{interactions,strs,out,newOps,depth,nestCommand,interStrand,intraStrand,subsets},

		(* Return a list of strands in the structure with paired bases replaced by the letter 'X'. *)
		strs=ToStrand[struct,Replace->True,FastTrack->True];

		interactions=foldStrand[strs[[strInd]],interval,ops];

		intraStrand = {structureFromStructureInteraction[struct,strInd,strInd,interactions]};
		(* offset strand index in structures *)

		(* look for new pairs between the strands that are already paired *)
		subsets=Tuples[{{strInd},Complement[Range[1,Length[strs]],{strInd}]}];
		interStrand=
			Table[
				interactions=pairStrand[{strs[[s[[1]]]],interval},{strs[[s[[2]]]],{1,StrandLength[strs[[s[[2]]]],FastTrack->True]}},ops];
				structureFromStructureInteraction[struct,s[[1]],s[[2]],interactions],
				{s,subsets}
			];

		Flatten[Join[interStrand,intraStrand],1]
	];


(* ::Subsubsection:: *)
(*foldStrand*)


(* Fold a strand by turning it into a string of unique bases, and folding that onto itself *)
foldStrand[str_Strand,interval:IntervalP,ops_]:=Module[{seq,interactions,tmp},
	(* transform strand into string of unique letters so we can do simple string matching *)
	seq=transformStrandToUniqueBases[str];
	interactions=sequenceInteractions[{seq,{1,StringLength[seq]}},{seq,interval},Lookup[ops, MinLevel], Null,
		Lookup[ops, MaxMismatch],Lookup[ops, MinPieceSize],{},Lookup[ops, Consolidate],True,Lookup[ops, MinHairpinLoopSize]];
	interactions
];


(* ::Subsubsection::Closed:: *)
(*listInteractionsToSpanInteractions*)


listInteractionsToSpanInteractions[interactions_]:=Replace[interactions,List->Span,{4},Heads->True];


(* ::Subsubsection:: *)
(*sequenceInteractions *)


sequenceInteractions[{aseq_,aint_},{bseq_,bint_},minLevel_,maxLevel_,maxMismatch_,minPieceSize_,ignoreList_,consolidateFlag_,foldingFlag_,minHairpinSize_]:=Module[{},
		Reverse/@ sequenceInteractions[{bseq,bint},{aseq,aint},minLevel,maxLevel,maxMismatch,minPieceSize,Reverse/@ignoreList,consolidateFlag,foldingFlag,minHairpinSize]
]/;(bint-aint).{-1,1}>0;

sequenceInteractions[{topSeq_,topInt_},{botSeq_,botInt_},minLevel_,maxLevel0_,maxMismatch_,minPieceSize_,ignoreList0_,consolidateFlag_,foldingFlag_,minHairpinSize_]:=Module[
		{seeds,tmp,out,olds,length,patts,botComp,nTop,nBot,maxLevel,ignoreList,new,
	matchingPositions,tmptmp,tmptmptmp,eachPos,eachSeq,topIntPos,botPos,topPos,verbose,intervalToSearch,intervalsToSearch,startPositionsToSearch,topStart,botStart,topEnd,botEnd,
		botList,botCompList
	},

	verbose=False;

	ignoreList=Flatten[ignoreList0 /. {{a_Integer, b_Integer}, {c_Integer, d_Integer}} :> {{{{a, b}}, {{d, c}}}, {{{d, c}}, {{a, b}}}}, 1];
	botList = Characters[botSeq];
	(*
		Modifications get replaced with X.
		Any paired bases should already be X
		In bottom strand we need to swap all the X with Y
		X and Y are reserved for things that we don't want to pair.
		Top strand should contain X and bottom should contain Y.
		Need to double replace X in bottom strand because otherwise mods will get turned to X and stuck as X.
	*)
	botCompList = Replace[Replace[botList,uniqueBasePairingRules,{1}],"X"->"Y",{1}];

	(* find seeds of all interactions *)
	(* leave botCompList as a list of bases because it can contain alternatives, which makes it a
	StringExpression, which doesn't work with all the usual string functions *)
	seeds = getSeedPositions[botCompList, topSeq, botInt, topInt, minLevel, maxLevel, maxMismatch, minPieceSize, ignoreList];


	(* If Folding (which means forming bonds within 1 strand, as opposed to Bonding, which is between multiple strands),
	 * prune seeds of interactions that overlap and thus cannot be folds *)
	If[foldingFlag,
		seeds=
			Union[
				Map[
					Sort,
					Select[
						Select[
							seeds,
							Function[seed,
								!SameQ[seed[[1]], seed[[2]]]
							]
						],
						Function[seed,
							Apply[
								And,
								Table[
									!overlappingIntervalQ[i[[1,1]], i[[1,2]], i[[2,1]], i[[2,2]]],
									{i,Tuples[seed]}
								]
							]
						]
					]
				]
			]
	];

	(* Filter out seeds that violate minhairpinsize constraint *)
	If[foldingFlag,
		seeds = Select[seeds,Function[seed,seed[[1,1,2]]+minHairpinSize<seed[[2,1,1]]]];
	];

	(* extend each seed as much as possible *)
	out = Table[extendSeedInteractions[botCompList,topSeq,s,consolidateFlag,foldingFlag,minHairpinSize], {s,seeds}];

	(* Flatten if not consolidating *)
	If[!consolidateFlag, out = Flatten[out,1] ];

	(* clean up *)
	listInteractionsToSpanInteractions[Sort[DeleteDuplicates[If[foldingFlag,out,Reverse/@ out]]]]
];


(* ::Subsubsection::Closed:: *)
(*extendSeedInteractions*)


extendSeedInteractions[botCompList_,top_,seed:{{{_Integer,_Integer}..},{{_Integer,_Integer}..}},consolidateFlag_,foldingFlag_,minHairpinSize_]:=Module[
	{out,a,b,c,d,matches,outwardShift,inwardShift,nTop,nBot,nestCommand,outerConstraint,innerConstraint},

	nTop=StringLength[top];
	nBot=Length[botCompList];
	{a,b,c,d}={seed[[1,1,1]],seed[[1,-1,2]],seed[[2,1,1]],seed[[2,-1,2]]};
	nestCommand=If[consolidateFlag,NestWhile,NestWhileList];
	(* this prevents pairs from growing beyond the ends of the sequences *)
	outerConstraint[x_]:=And[d+x+1<=nTop,a-x-1>=1];
	(* this prevents pairs from growing into each other (also enforces hairpin size constraint) *)
	innerConstraint[x_]:=If[foldingFlag, (b+x+1<c-x-1 - minHairpinSize ),And[b+x+1<=nBot,c-x-1>=1]];

	(* MIGHT ONLY NEED TO GROW IN ONE DIRECTION... LOOK INTO THAT *)

	(* extend the seeds *)
	outwardShift=nestCommand[
		#+1&,
		0,
		And[outerConstraint[#],StringMatchQ[StringTake[top,{d+#+1}],StringExpression@@Take[botCompList,{a-#-1}]]]&
	];

	inwardShift=nestCommand[
		#+1&,
		0,
		And[innerConstraint[#],StringMatchQ[StringTake[top,{c-#-1}],StringExpression@@Take[botCompList,{b+#+1}]]]&
	];

	(* make the new intervals *)
	If[consolidateFlag,
		(
			out=seed;
			out[[1,1,1]]+=(-outwardShift);
			out[[1,-1,2]]+=(inwardShift);
			out[[2,1,1]]+=(-inwardShift);
			out[[2,-1,2]]+=(outwardShift);
			out
		)
		,
		(
			Flatten[Table[
				(
					out=seed;
					out[[1,1,1]]+=(-o);
					out[[1,-1,2]]+=(i);
					out[[2,1,1]]+=(-i);
					out[[2,-1,2]]+=(o);
					out
				),
				{o,outwardShift},{i,inwardShift}],
				1
			]
		)
	]
];


(* ::Subsubsection::Closed:: *)
(*getSeedPositions*)


getSeedPositions[botCompList_,topSeq_,botInt_,topInt_,minLevel_,maxLevel_,maxMismatch_,minPieceSize_,ignoreList_]:=
	Module[{intervalsToSearch,botRevCompSub,eachPos,patts,
			topStart,topEnd,botStart,botEnd,exactMatches,misMatches},

		(* intervals to search on top and bottom strand *)
		topStart = Max[1,                      First[topInt]-minLevel+1];
		topEnd   = Min[StringLength[topSeq],   topInt[[2]]+minLevel-1];
		botStart = Max[1,                       botInt[[1]]-minLevel+1];
		botEnd   = Min[Length[botCompList],   botInt[[2]]+minLevel-1];

		(* EXACT MATCHES *)
		intervalsToSearch = Transpose[{Range[botStart,botEnd-minLevel+1],Range[botStart+minLevel-1,botEnd]}]; 	(* all subsets of that bottom range *)

		exactMatches=
			Table[
				With[{intervalToSearch=intervalsToSearch[[i]]},
					(* botRevCompSub is what we will be searching topSeq for *)
					botRevCompSub = StringExpression@@Reverse[Take[botCompList,intervalToSearch]];
					eachPos = seqPairingPositions[topSeq,botRevCompSub,{topStart,topEnd},intervalToSearch];
					(* must do this here after searching; can't Complement on intervalsToSearch List... *)
					Complement[eachPos,ignoreList]
				],
				{i,1,Length[intervalsToSearch]}
			];

		(* MISMATCHES *)
		If[maxMismatch>0,
			With[{lengthForMismatches = maxMismatch + minPieceSize*(maxMismatch+1)},
				(* all subsets of that bottom range *)
				intervalsToSearch = Transpose[{Range[botStart,botEnd-lengthForMismatches+1],Range[botStart+lengthForMismatches-1,botEnd]}];
				misMatches =
					Table[
						With[{intervalToSearch=intervalsToSearch[[i]]},
							(* Need to change this if | in uniqueBasePairingRules... *)
							botRevCompSub = StringExpression@@Reverse[Take[botCompList,intervalToSearch]];
							(* all string patterns for the top strand *)
							patts=mismatchPatterns[botRevCompSub,maxMismatch,minPieceSize];
							eachPos=Flatten[ Table[ seqMismatchPairingPositions[topSeq,botRevCompSub,{topStart,topEnd},p,intervalToSearch], {p,patts}] ,1];
							(* must do this here after searching; can't Complement on intervalsToSearch List... *)
							Complement[eachPos,ignoreList]
						],
						{i,1,Length[intervalsToSearch]}
					];
			],
			misMatches={{}};
		];

		Flatten[Join[exactMatches, misMatches], 1]
	];



(* ::Subsubsection::Closed:: *)
(*seqPairingPositions*)


seqPairingPositions[topSeq_,botRevCompSub_,topRange_,int_]:=
	Map[
		{{int}, {#+topRange[[1]]-1}}&,
		StringPosition[StringTake[topSeq,topRange],botRevCompSub]
	];


(* ::Subsubsection::Closed:: *)
(*seqMismatchPairingPositions*)


seqMismatchPairingPositions[topSeq_,botRevCompSub_,topRange_,pattern_,intervalToSearch_]:=Module[
	{botPos,topPos,topMatches},

	(* bottom strand interval to search *)
	botPos = pattern[[2]]+intervalToSearch[[1]]-1;  (* positions in bottom strand *)

	(* intervals in the top that match the bottom pattern *)
	topMatches=StringPosition[StringTake[topSeq,topRange],pattern[[1]]];  (* positions in top interval *)

	(* offset topMatches by the pattern offset *)
	Table[
		(
			topPos = Table[posInTop[[1]]-1+pp,{pp,pattern[[3]]}];
			{botPos,topPos}
		),
		{posInTop,topMatches}
	]
];




(* ::Subsubsection::Closed:: *)
(*subInteractions*)


(* Given an interaction (as a rule of positions), find all possible sub-interactions.
	 Calls fast compiled functions *)
Options[subInteractions]={IncludeFull->False,Aggressive->False};
subInteractions[in_,opts_]:=subInteractions[in,1,opts];
subInteractions[in_,k_Integer,opts_]:=subInteractions[in,opts];


(* Structure interval *)
subInteractions[in:{{a1_Integer,b1_Integer,c1_List},{a2_Integer,b2_Integer,c2_List}},m_Integer,opts_]:=
	{{a1,b1,#[[1]]},{a2,b2,#[[2]]}}&/@subInteractions[{c1,c2},m,opts];

(* strand interval *)
subInteractions[in:{{a1_Integer,b1_List},{a2_Integer,b2_List}},m_Integer,opts_]:=
	{{a1,#[[1]]},{a2,#[[2]]}}&/@subInteractions[{b1,b2},m,opts];

(* sequence interval *)
subInteractions[in:{top:{__},bot:{__}},m_Integer,opts_]:=Module[{pieces,sets,inds},
		inds = Rest[Subsets[Range[1,Length[top]]]];
	If[!Lookup[opts, Aggressive],inds={Last[inds]}];
		sets=Table[subInteractionsHelper[{top[[i]],bot[[Sort[Length[bot]+1-i]]]},m],{i,inds}];
		DeleteCases[Flatten[sets,1],in]
];
subInteractionsHelper[in:{top:{IntervalP..},bot:{IntervalP..}},m_Integer]:=Module[{pieces,sets,inds},
		pieces=MapThread[subInteractions[{#1,#2},m,IncludeFull->True]&,{top,Reverse[bot]}];
		inds = Tuples[Table[Range[1,Length[i]],{i,pieces}]];
		sets={#[[1]],Reverse[#[[2]]]}&/@Table[Transpose[Table[Part[pieces,i,j[[i]]],{i,1,Length[top]}]],{j,inds}];
		sets
];

(* interval *)
subInteractions[List[{a_Integer,b_Integer},{c_Integer,d_Integer}],m_Integer,opts_]:=Module[{},
If[And[Or[a===b,c===d],!Lookup[opts, IncludeFull]],
		{},
		If[Lookup[opts, IncludeFull],
				subInteractionsC[a,b,c,d,m,b-a+1],
				subInteractionsC[a,b,c,d,m,b-a]
		]
]];
subInteractionsC:=
(
deconstructInterval;
deconstructIntervalReverseC;
subInteractionsC=Core`Private`SafeCompile[{{a,_Integer},{b,_Integer},{c,_Integer},{d,_Integer},{min,_Integer},{max,_Integer}},
Transpose[{deconstructInterval[a,b,min,max],deconstructIntervalReverseC[c,d,min,max]}]]
);


(* ::Subsubsection::Closed:: *)
(*mismatchPatterns*)
Authors[mismatchPatterns]:={"scicomp", "brad"};


mismatchPatterns[sub_,maxMismatch_,minPieceSize_]:=Module[{full,bulge,topBubble,botBubble,verbose},
	verbose=False;
	full={{sub,{{1,StringLength[sub]}},{{1,StringLength[sub]}}}};
	bulge=getBulgePositions[sub,maxMismatch,minPieceSize];
	topBubble=getBottomBubblePositions[sub,maxMismatch,minPieceSize];
	botBubble=getTopBubblePositions[sub,maxMismatch,minPieceSize];
	Complement[DeleteDuplicates[Join[ (*full,*)   bulge, topBubble, botBubble ]],full]
];

getBulgePositions[sub_,maxMismatch_,minPieceSize_]:=Module[{n,allBlanks,goodBlanks,posBot,patts,verbose,t1,t2,outBot,outTop},
	verbose=False;
	n=StringLength[sub];
	allBlanks=Union[Flatten[Table[Subsets[Range[minPieceSize+1,n-minPieceSize],{Max[0,Min[i,n-2minPieceSize]]}],{i,1,maxMismatch}],1]];
	goodBlanks=Select[allBlanks, Intersection[Differences[#], Range[2, minPieceSize]]==={}&];
	posBot=Table[Complement[Range[1,n],i],{i,goodBlanks}];
	outBot=rangeToIntervals/@posBot;
	outTop=Table[Reverse[Reverse/@each],{each,(n+1)-outBot}];
	patts=StringExpression@@ReplacePart[Characters[sub],Table[i->Except[StringTake[sub,{i}]],{i,#}]]&/@goodBlanks;
	Transpose[{patts,outTop,outBot}]
];

getBottomBubblePositions[sub_,maxMismatch_,minPieceSize_]:=Module[{n=StringLength[sub],sets,patts,topPos,botPos,out,outBot,outTop,verbose},
	verbose=False;
	sets=Union[Flatten[Table[Subsets[Range[minPieceSize+1,n-minPieceSize],{Max[0,Min[i,n-2minPieceSize]]}],{i,1,maxMismatch}],1]];
	sets = Select[sets, Intersection[Differences[#], Range[2, minPieceSize]]==={}&];
	botPos=Table[Complement[Range[1,n],i],{i,sets}];
	topPos=Table[{{1,Length[i]}},{i,botPos}];
	botPos = n+1-botPos;
	botPos=rangeToIntervals/@Reverse/@botPos;
	patts=Join@@StringReplacePart[sub,ConstantArray["",Length[#]],Transpose[{#,#}]]&/@sets;
	out=MapThread[alignIntervals[#1,#2]&,{botPos,topPos}];
	{outBot,outTop}=If[out==={},{{},{}},Transpose[out]];
	Transpose[{patts,outBot,outTop}]
];

getTopBubblePositions[sub_,maxMismatch_,minPieceSize_]:={}/;StringLength[sub] <= (minPieceSize*(maxMismatch+1));
getTopBubblePositions[sub_,maxMismatch_,minPieceSize_]:=Module[{n},
	n=StringLength[sub];
	Flatten[
		Table[Flatten[Table[
			If[False, Print[{j, k}, {StringTake[sub, {j + 1, n - k + j}], k, minPieceSize}]];
			getTopBubblePositionsHelper[StringTake[sub, {j + 1, n - k + j}], k, minPieceSize, k - j],
			{j, 0, k}], 1], {k, 1, maxMismatch}],
		1]
];

getTopBubblePositionsHelper[sub_,maxMismatch_,minPieceSize_,offset_]:=Module[{n, allBlanks, goodBlanks, patts, botPos, topPos, outBot, outTop, out, return, verbose},
	verbose=False;
	n=StringLength[sub];
	(* allBlanks=Subsets[Range[minPieceSize+1,n-minPieceSize+maxMismatch],{Min[maxMismatch,n-2minPieceSize]}];*)
	allBlanks=Subsets[Range[minPieceSize + 1, n - minPieceSize + maxMismatch], {maxMismatch}];
	return=If[allBlanks === {{}},
		{},

		goodBlanks=Select[allBlanks, Intersection[Differences[#], Range[2, minPieceSize]] === {}&];
		topPos=Table[Complement[Range[1, n + Length[i]], i], {i, goodBlanks}];
		botPos=Table[{{1, n}}, {Length[goodBlanks]}];
		topPos=rangeToIntervals /@ topPos;
		out=MapThread[alignIntervals[#1, #2]&, {topPos, botPos}];
		{outTop, outBot}=If[out === {}, {{}, {}}, Transpose[out]];
		patts=StringExpression @@ Insert[Characters[sub], Blank[], Transpose[{# - Range[0, maxMismatch - 1]}]]& /@ goodBlanks;
		Transpose[{patts, outBot + offset, outTop}]
	];
	return
];

(* Turn an ordered list of integers into a list of intervals *)
rangeToIntervals[list_]:=
Transpose[{Prepend[First/@Cases[Transpose[{Rest[list],Differences[list]}],{_,Except[1]}],First[list]],
	Append[First/@Cases[Transpose[{Most[list],Differences[list]}],{_,Except[1]}],Last[list]]}];  (* this is the fastest *)

alignIntervals[first_List,second_List]:={first,second}/;Length[first]===Length[second];
alignIntervals[first_List,second_List]:=alignIntervals[second,first]/;Length[second]>Length[first];
alignIntervals[first_List, second:{{z1_,z2_}}]:=Module[{starts,ends},
	starts=Accumulate[Join[{0},#.{-1,1}+1&/@Most[Reverse[first]]]]+1;
	ends=Accumulate[#.{-1,1}+1&/@Reverse[first]];
	{first,Transpose[{starts,ends}]+z1-1}
];


(* ::Subsection::Closed:: *)
(*Thermodynamic Folding*)


(* ::Subsubsection::Closed:: *)
(*planarComp*)


(* Function: planarComp
 * -----------------
 * Returns 0 if no base pair
 * Returns 1 if A-U base pair
 * Returns 2 if C-G base pair
 * Returns 3 if G-U base pair
 * Returns 1 if A-T base pair
*)

planarComp[b1_,b2_]:=planarComp[b1,b2]=
	Switch[b1,
		"A",
			Switch[b2,
				"A", 0,
				"C", 0,
				"G", 0,
				"U", 1,
				"T", 1
			],
		"C",
			Switch[b2,
				"A", 0,
				"C", 0,
				"G", 2,
				"U", 0,
				"T", 0
			],
		"G",
			Switch[b2,
				"A", 0,
				"C", 2,
				"G", 0,
				"U", 3,
				"T", 0
			],
		"U",
			Switch[b2,
				"A", 1,
				"C", 0,
				"G", 3,
				"U", 0,
				"T", 0
			],
		"T",
			Switch[b2,
				"A", 1,
				"C", 0,
				"G", 0,
				"U", 0,
				"T", 0
			]
	];

(* ::Subsubsection::Closed:: *)
(*loopIncrementsValue*)

(* Function: loopIncrementsValue
 * ---------------------
 * Returns free energy according to the size
 * of a certain type of structural loop.
 *)
loopIncrementsValue[polymerType:PolymerP,loopType:(BulgeLoop|InternalLoop|HairpinLoop),size_Integer,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{internalParameterValues,internalParameterFunction},

	(* The values of hairpin parameter associated with pol and propery *)
	internalParameterValues=Physics`Private`lookupModelThermodynamics[polymerType,\[CapitalDelta]G,loopType,Sequence@@resolvedOptions][[1]];

	(* The function evaluating the hairpin parameter associated with pol and propery *)
	internalParameterFunction=Physics`Private`lookupModelThermodynamics[polymerType,\[CapitalDelta]G,loopType,Sequence@@resolvedOptions][[2]];

	If[MemberQ[internalParameterValues[[All,1]],size],
		(* Take the values from the lookup table *)
		First@Cases[internalParameterValues,{size,x_Quantity}->x],

		(* Use the function to calculate based on size *)
		internalParameterFunction[size]
	]
];

(* ::Subsubsection::Closed:: *)
(*planarEnergyFH and planarEnergyFL*)

(* Function: planarEnergyFH
 * ---------------------
 * Returns the energy contributed by a hairpin loop closed by
 * hydrogen bond seq_i - seq_j. Also returns the bond pair involved
 * in the loop's closing.
 * This function uses memoization.
 *)
(** TODO: taking the polymer type from ops should be used **)
planarEnergyFH[seq_,{i_,j_},ops_]:=planarEnergyFH[seq,{i,j},ops]=
	Module[{hairpinSize,maxHairpinSize,dGLength,dGMismatch,dGExtra,dG,baseI,baseII,baseJJ,baseJ,lastMatch,firstMismatch},

		(* The number of unpaired bases in the hairpin loop. *)
		hairpinSize=j-i-1;

		(* The limit on how big hairpins can be. *)
		maxHairpinSize=MaxHairpinLoopSize/.ops;

		(* If the hairpin size is larger than the limit, return an energy of Infinity and no bonds,
		 * which effectively throws out this particular hairpin as a possibility. *)
		If[hairpinSize>maxHairpinSize,
			Return[{Energy->Infinity,Bonds->{}}]
		];

		(* If the heuristic we're aiming for is to maximize the number of bonds, then we don't need
		 * to do any real energy calculations and can just return -1 for the one bond that was formed
		 * along with the indices of the bases involved in the bond. *)
		If[(Heuristic/.ops)===Bonds,
			Return[{Energy->-1,Bonds->{{i,j}}}]
		];

		(* ------------------------------------------------------------- *)
		(* The rest of the code only gets executed when the Heuristic is Energy. *)
		(* ------------------------------------------------------------- *)

		(** TODO: this might need to be revisited if we use polymer type from ops **)

		(* Get the bases (string characters) corresponding with the indices i, j, i+1, and j-1 in 'seq'. *)
		baseI=StringReplace[StringTake[seq,{i}],"T"->"U"];
		baseII=StringReplace[StringTake[seq,{i+1}],"T"->"U"];
		baseJ=StringReplace[StringTake[seq,{j}],"T"->"U"];
		baseJJ=StringReplace[StringTake[seq,{j-1}],"T"->"U"];

		(* baseI and baseJ form the hydrogen bond that closes the hairpin loop. This is the 'last match'
		 * of the helix that came before the hairpin. So if the hairpin loop is ...ACTGCTT... with the
		 * leftmost A bound to the rightmost T, then 'lastMatch' will be "A-T". *)
		lastMatch=baseI<>"-"<>baseJ;

		(* baseII and baseJJ are the bases that form the first mismatch of the hairpin loop. So if the
		 * hairpin loop is ...ACTGCTT... with the leftmost A bound to the rightmost T, then 'firstMismatch' will
		 * be "C-T". *)
		firstMismatch=baseII<>"-"<>baseJJ;

		(* 'dGLength' is the energy penalty sustained by the loop due to its size. *)
		dGLength=
			Unitless[loopIncrementsValue[RNA,HairpinLoop,hairpinSize,FilterRules[ops,ThermodynamicsModel]],KilocaloriePerMole];

		(* There is an energy penalty/reward that depends on the first mismatch of the loop (see above). *)
		dGMismatch=
			ReplaceAll[
				firstMismatch,
				lastMatch/.Physics`Private`thermodynamicParameters[RNA,\[CapitalDelta]G,Mismatch,Sequence@@FilterRules[ops,ThermodynamicsModel]]
			];

		(* If the first mismatch is G-A or U-U, there is a slight energy reward.
		 * If the last match is not C-G, there is a slight penalty. *)
		dGExtra=
			Plus[
				firstMismatch/.{"G-A"->-0.8,"U-U"->-0.8,_String->0.0},
				lastMatch/.{"U-A"|"A-U"|"U-G"|"G-U"->0.45,_String->0}
			];

		(* The total energy for this hairpin loop is the sum of its loop size penalty, its
		 * mismatch reward/penalty, and its possible closing bond penalty. *)
		dG=
			Plus[
				dGLength,
				dGMismatch,
				dGExtra
			];

		(* Return the energy of the loop and the closing match (last match) indices. *)
		{Energy->dG,Bonds->{{i,j}}}
	];


(* Function: planarEnergyFL
 * ---------------------
 * Returns the energy contributed by a stacking/bulge/internal loop closed by
 * hydrogen bonds seq_i - seq_j and seq_ii - seq_jj. Also returns the bond bonds
 * involved in the loop's closing.
 * This function uses memoization.
 *)
planarEnergyFL[seq_,{i_,j_,ii_,jj_},ops_]:=planarEnergyFL[seq,{i,j,ii,jj},ops]=
	Module[{iSideLength,jSideLength,sideLength,loopBounds,numFreeLoopBases,type,baseI,baseII,baseJJ,baseJ,firstMatch,lastMatch,iStack,jStack,extra,firstMismatch,dG},

		(* The number of unpaired bases on the lower-indexed side of the loop. *)
		iSideLength=ii-i-1;

		(* The number of unpaired bases on the higher-indexed side of the loop. *)
		jSideLength=j-jj-1;

		(* The total number of unpaired bases in the loop. *)
		numFreeLoopBases=iSideLength+jSideLength;

		(* Determine which type of loop this is. *)
		type=
			Which[

				(* Stacking loop if the only bases involved in the loop are also
				 * forming the hydrogen bond walls of the loop. *)
				iSideLength===0&&jSideLength===0,
					1, (* StackingLoop *)

				(* Bulge loop if one side of the loop has 0 unpaired bases but the other
				 * has at least one unpaired base (we say that the loop "bulges" toward
				 * the side with the unpaired base). *)
				iSideLength===0||jSideLength===0,
					2, (* BulgeLoop *)

				(* Internal loop if both sides of the loop have extra unpaired bases. *)
				True,
					3 (* InternalLoop *)
			];

		(* Determine the bounds on the number of unpaired bases in the loop based on Options.
		 * Note: By definition, stacking loops have 0 unpaired bases. *)
		loopBounds=
			Switch[type,
				1,  (* StackingLoop *)
					{0,0},
				2,  (* BulgeLoop *)
					{MinBulgeLoopSize,MaxBulgeLoopSize}/.ops,
				3,  (* InternalLoop *)
					{MinInternalLoopSize,MaxInternalLoopSize}/.ops
			];


		(* IF the closing pair of the loop can't actually hydrogen bond
		 * OR the type of loop being formed isn't allowed by the user
		 * OR the size of the loop is not within 'loopBounds'
		 * THEN tell the calling function that this substructure is invalid by returning
		 * the appropriate Energy and Bonds. *)
		If[planarComp[StringTake[seq,{ii}],StringTake[seq,{jj}]]===0
			 || MemberQ[(ExcludedSubstructures/.ops) /. {StackingLoop -> 1, BulgeLoop -> 2, InternalLoop -> 3, MultipleLoop -> 4},type]
			 || !(First[loopBounds]<=numFreeLoopBases<=Last[loopBounds]),
			Switch[Heuristic/.ops,
				Energy,
					Return[{Energy->Infinity,Bonds->{}}],
				Bonds,
					Return[{Energy->Infinity,Bonds->{{i,j}}}]
			]
		];

		(* If we've gotten to this point, we know this loop is a valid substructure.
		 * We return the appropriate energy and new bonds for the Bonds heuristic. *)
		If[(Heuristic/.ops)===Bonds,
			Return[{Energy->-1,Bonds->{{i,j},{ii,jj}}}]
		];

		(* ------------------------------------------------------------- *)
		(* The rest of the code only gets executed when the Heuristic is Energy. *)
		(* ------------------------------------------------------------- *)

		(* Get the bases (string characters) corresponding with the indices i, j, i+1, and j-1 in 'seq'. *)
		baseI=StringReplace[StringTake[seq,{i}],"T"->"U"];
		baseII=StringReplace[StringTake[seq,{ii}],"T"->"U"];
		baseJ=StringReplace[StringTake[seq,{j}],"T"->"U"];
		baseJJ=StringReplace[StringTake[seq,{jj}],"T"->"U"];

		(* Matches are hydrogen bonded bonds *)
		firstMatch=baseI<>baseJ;
		lastMatch=baseII<>baseJJ;

		(* Stacks are base pairs that are not hydrogen bonded, but form the corners of one size of the loop. *)
		If[type=!=3,
			iStack=baseI<>baseII;
			jStack=baseJJ<>baseJ;

			(** TODO: There are no quarupole interaction parameters in the object. Although there were in Parameters[RNA]. Make sure about consistency. **)
			(* If we're dealing with a "GU-GU" bulge or stack, then there are special rules for
			 * the reward/penalty of this loop, which depends on the surrounding bases as well. *)
			jStack=
				If[iStack==="GU" && jStack==="GU" && i>1 && j<StringLength[seq],
					Switch[StringTake[seq,{i-1,ii+1}],
						"AGUU-AGUU"|"CGUG-CGUG"|"UGUA-UGUA",
							"GU+",
						"GGUC",
							"GU-",
						_String,
							"GU="
					],
					jStack
				];
		];

		(* Calculate deltaG for this loop, which depends on loop size penalties, nearest neighbor
		 * stacking rewards, mismatch penalties, and penalties/rewards for how helices are terminated. *)
		dG=
			Switch[type,
				1,  (* StackingLoop *)
					jStack/.(iStack/.Physics`Private`thermodynamicParameters[RNA,\[CapitalDelta]G,Stacking,Sequence@@FilterRules[ops,ThermodynamicsModel]]),
				2,  (* BulgeLoop *)
					sideLength=If[iSideLength===0,jSideLength,iSideLength];
					extra=If[sideLength===1,
								jStack/.(iStack/.Physics`Private`thermodynamicParameters[RNA,\[CapitalDelta]G,Stacking,Sequence@@FilterRules[ops,ThermodynamicsModel]]),
								(firstMatch+lastMatch)/.{"UA"|"AU"|"UG"|"GU"->0.45,_String->0}];
					extra + Unitless[loopIncrementsValue[RNA,BulgeLoop,sideLength,FilterRules[ops,ThermodynamicsModel]],KilocaloriePerMole],
				3,  (* InternalLoop *)
					extra=(firstMatch+lastMatch)/.{"UA"|"AU"|"UG"|"GU"->0.65,_String->0};
					extra + Unitless[loopIncrementsValue[RNA,InternalLoop,(iSideLength+jSideLength),FilterRules[ops,ThermodynamicsModel]],KilocaloriePerMole]
			];

		(* Return the energy of this loop and the indices of the hydrogen bond pairs involved. *)
		{Energy->dG,Bonds->{{i,j},{ii,jj}}}
	];


(* ::Input:: *)
(**)


(* ::Subsubsection::Closed:: *)
(*planarE1*)


(* Function: planarE1
 * ----------------
 * planarE1 is equivalent to a call to planarEnergyFH. It finds the energy of a hairpin loop
 * bounded by a hydrogen bond between bases at indices i and j.
 * The result is memoized.
 *)
planarE1[seq_,{i_,j_},ops_]:=planarE1[seq,{i,j},ops]=
	planarEnergyFH[seq,{i,j},ops];


(* ::Subsubsection::Closed:: *)
(*planarE2*)


(* Function: planarE2
 * ----------------
 * Finds an optimal substructure between (and including) bases i and j
 * containing at least one non-hairpin loop and exactly 1 hairpin loop.
 * This means no bifurcation. The function attempts to find an ii/jj pair
 * such that the ii-jj bond closes the loop started by the i-j bond and the
 * energy of the resulting loop and substructure between ii and jj is minimized.
 * In the case of a Bonds Heuristic, minimizing energy means maximizing bonds.
 * The result is memoized.
 *)
planarE2[seq_,{i_,j_},ops_]:=planarE2[seq,{i,j},ops]=
	Module[{results,fixedResults},

		(* Get a list of possible substructures including all bases between (and including) the bases
		 * at indices i and j. Each substructure is defined by its gibbs free energy and
		 * the bonds that comprise it. Each substructure in this function (planarE2) includes
		 * one loop with i and j and ii and jj in it, possibly other loops between ii and jj, and definitely
		 * a hairpin loop between ii and jj. planarEnergyFL calculates the loop that includes i and j.
		 * planarV calculates the optimal set of loops (including 1 hairpin) between ii and jj. *)
		results=
			Flatten[

				(* A table of possible substructures, attempting to bind bases between i and j (which
				 * are denoted as ii and jj here) as the closers of i and j's loop and the beginners of
				 * the rest of the substructure. *)
				Table[
					{
						Rule[
							Energy,
							Plus[
								Energy/.planarEnergyFL[seq,{i,j,ii,jj},ops],
								Energy/. planarV[seq,{ii,jj},ops]
							]
						],
						Rule[
							Bonds,
							DeleteDuplicates@Join[
								Bonds/.planarEnergyFL[seq,{i,j,ii,jj},ops],
								Bonds/. planarV[seq,{ii,jj},ops]
							]
						]
					},
					{ii,i+1,j-2},{jj,ii+1,j-1}
				],
				1
			];

		(* If the Heuristic is Bonds, correct any Energy's that read Infinity
		 * to negative the number of hydrogen bonds in the substructure. Infinity
		 * is acceptable for when the heuristic is Energy but not when it's Bonds. *)
		fixedResults=
			Switch[Heuristic/.ops,

				Energy,
					results,

				Bonds,
					Map[
						{
							Rule[
								Energy,
								If[(Energy/.#)===Infinity,
									Infinity,
									-Length[Bonds/.#]
								]
							],
							Last[#]
						}&,
						results
					]
			];

		(* Pick the substructure between i and j with the lowest energy. *)
		First@MinimalBy[
			fixedResults,
			(Energy/.#)&
		]
	];


(* ::Subsubsection::Closed:: *)
(*planarE3*)


(* Function: planarE3
 * ----------------
 * Find the optimal substructure where i and j bond and bifurcation occurs at least once
 * between i and j (meaning at least 2 hairpins). Substructures produced by planarE3 always
 * contain at least 1 multiple loop, which is produced by bifurcation.
 * This function uses memoization.
 *)
planarE3[seq_,{i_,j_},ops_]:=planarE3[seq,{i,j},ops]=
	Module[{results,fixedResults,minHairpinSize,minMultiLoopSize},

		(* If multiple loops are not allowed, return a result indicating that planarE3 would
		 * return an unacceptable substructure. *)
		If[MemberQ[(ExcludedSubstructures/.ops) /. {StackingLoop -> 1, BulgeLoop -> 2, InternalLoop -> 3, MultipleLoop -> 4},4], (* If multiple loops are excluded from result by the user *)
			Return[{Energy->Infinity,Bonds->{}}];
		];

		(* Get lower bounds on hairpin and multiple loops. *)
		minHairpinSize=MinHairpinLoopSize/.ops;
		minMultiLoopSize=MinMultipleLoopSize/.ops;

		(* If there is not enough room between bases i and j for two hairpins and a
		 * multiple loop of appropriate size, tell this function's caller that no
		 * valid substructure could be produced. *)
		If[(j-i-1)<(2*(minHairpinSize+2)+3*minMultiLoopSize),
			Return[{Energy->Infinity,Bonds->{}}];
		];

		(* Get a list of possible substructures including all bases between (and including) the bases
		 * at indices i and j. Each substructure is defined by its gibbs free energy and
		 * the bonds that comprise it. Each substructure in this function (planarE3) includes
		 * one multiple loop with i and j comprising one hydrogen bond boundary of that loop,
		 * a bifurcation point at base ii, where the bases between i and ii and the bases between ii and j
		 * each contain at least one hairpin and possibly other loops too. The two calls to planarW find optimal
		 * substructures between i and ii and between ii and j (the two sides of the bifurcation). *)
		results=
			Table[
				{
					Rule[
						Energy,
						Plus[
							Energy/.planarW[seq,{i+minMultiLoopSize+1,ii},ops],
							Energy/.planarW[seq,{ii+minMultiLoopSize+1,j-minMultiLoopSize-1},ops]
						]
					],
					Rule[
						Bonds,
						DeleteDuplicates@Join[
							Bonds/.planarW[seq,{i+minMultiLoopSize+1,ii},ops],
							Bonds/.planarW[seq,{ii+minMultiLoopSize+1,j-minMultiLoopSize-1},ops],
							{{i,j}}
						]
					]
				},
				{ii,i+minMultiLoopSize+2,j-minMultiLoopSize-3}
			];

		(* If the Heuristic is Bonds, correct any Energy's that read Infinity
		 * to negative the number of hydrogen bonds in the substructure. Infinity
		 * is acceptable for when the heuristic is Energy but not when it's Bonds. *)
		fixedResults=
			Switch[Heuristic/.ops,

				Energy,
					results,

				Bonds,
					Map[
						{
							Rule[
								Energy,
								If[(Energy/.#)===Infinity,
									Infinity,
									-Length[Bonds/.#]
								]
							],
							Last[#]
						}&,
						results
					]
			];

		(* Pick the substructure between i and j with the lowest energy. *)
		First@MinimalBy[
			fixedResults,
			Energy/.#&
		]
	];


(* ::Subsubsection::Closed:: *)
(*planarE4*)


(* Function: planarE4
 * ----------------
 * Find the optimal substructure where i and j do not bond and bifurcation occurs at least once
 * between i and j (meaning at least 2 hairpins). Substructures produced by planarE4 may contain a
 * multiple loop, but they may also not (imagine a piece of string that you pinch at two far-away
 * locations near the center). Bases i and j do not bind to each other here.
 * This function uses memoization.
 *)
planarE4[seq_,{i_,j_},ops_]:=planarE4[seq,{i,j},ops]=
	Module[{results,fixedResults,minHairpinSize},

		(* Get lower bound hairpin loop size. *)
		minHairpinSize=MinHairpinLoopSize/.ops;

		(* If there's not enough room between i and j for 2 minimally-sized hairpins,
		 * tell this function's caller that no valid substructure could be found through planarE4. *)
		If[(j-i-1)<(2*(minHairpinSize+2)),
			Return[{Energy->Infinity,Bonds->{}}];
		];

		(* Get a list of possible substructures including all bases between (and including) the bases
		 * at indices i and j. Each substructure is defined by its gibbs free energy and
		 * the bonds that comprise it. Each substructure in this function (planarE4) includes
		 * no hydrogen bond between i and j,
		 * a bifurcation point at base ii, where the bases between i and ii and the bases between ii and j
		 * each contain at least one hairpin and possibly other loops too. The two calls to planarW find optimal
		 * substructures between i and ii and between ii and j (the two sides of the bifurcation). *)
		results=
			Table[
				{
					Rule[
						Energy,
						Plus[
							Energy/.planarW[seq,{i,ii},ops],
							Energy/.planarW[seq,{ii+1,j},ops]
						]
					],
					Rule[
						Bonds,
						DeleteDuplicates@Join[
							Bonds/.planarW[seq,{i,ii},ops],
							Bonds/.planarW[seq,{ii+1,j},ops]
						]
					]
				},
				{ii,i+1,j-2}
			];

		(* If the Heuristic is Bonds, correct any Energy's that read Infinity
		 * to negative the number of hydrogen bonds in the substructure. Infinity
		 * is acceptable for when the heuristic is Energy but not when it's Bonds. *)
		fixedResults=
			Switch[Heuristic/.ops,

				Energy,
					results,

				Bonds,
					Map[
						{
							Rule[
								Energy,
								If[(Energy/.#)===Infinity,
									Infinity,
									-Length[Bonds/.#]
								]
							],
							Last[#]
						}&,
						results
					]
			];

		(* Pick the substructure between i and j with the lowest energy. *)
		First@MinimalBy[
			fixedResults,
			Energy/.#&
		]
	];


(* ::Subsubsection::Closed:: *)
(*planarV*)


(* Function: planarV
 * -----------------
 * Returns the optimal substructure (defined by its Energy and its Bonds) where
 * i and j MUST form a hydrogen bond.
 * This function uses memoization.
 *)
planarV[seq_,{i_,j_},ops_]:=planarV[seq,{i,j},ops]=
	Module[{subSeqLength,minSubSeqLength,endPairVal,Vij,result},

		(* Returns 0 if the bases at indices i and j in seq are not Watson-Crick compatible. *)
		endPairVal=planarComp[StringTake[seq,{i}],StringTake[seq,{j}]];

		(* The number of bases between base i and base j. The bases between i and j are
		 * denoted as the "subsequence" here. *)
		subSeqLength=j-i-1;

		(* The minimum hairpin loop size is also the minimum subsequence length. *)
		minSubSeqLength=(MinHairpinLoopSize/.ops);

		(* If the i-j bond is invalid, return an energy of infinity and no bonds.
		 * If the i-j bond is valid, return the minimum energy substructure of the bases between (and including) i and j. *)
		Vij=
			Which[

				(* Disallow any situations where i\[GreaterEqual]j, which are either copies of previously examined pairs
				 * or pairs with no bases between them (which can't hydrogen bond). *)
				i>=j,
					{Energy->Infinity,Bonds->{}},

				(* Disallow situations where bases i and j can't hydrogen bond. *)
				endPairVal===0,
					Return[{Energy->Infinity,Bonds->{}}],

				(* Disallow situations where the subsequence between bases i and j is too short to fold on itself. *)
				subSeqLength<minSubSeqLength,
					Return[{Energy->Infinity,Bonds->{}}],

				(* If the subsequence length is the minimum subsequence length, then the subsequence can only be
				 * a hairpin (see above). Therefore, the optimal substructure here is a hairpin, the energy of which
				 * is retrieved through planarEnergyFH and the bonds of which are simply just i-j. *)
				subSeqLength===minSubSeqLength,
					planarEnergyFH[seq,{i,j},ops],

				(* If the subsequence length is large enough to possibly include more than just a hairpin loop, investigate
				 * three distinct possibilities for folding the subsequence (and choose the one with minimal energy):
				 *  - planarE1 finds the energy of a substructure with a hairpin loop (where the i-j closes it off) and no other loops
				 *  - planarE2 finds the optimal substructure where i and j form a hydrogen bond as part of a stacking, bulge, or internal loop
				 *  - planarE3 finds the optimal substructure where i and j form a hydrogen bond as part of a multiple loop *)
				subSeqLength>minSubSeqLength,
					First@MinimalBy[
						{
							planarE1[seq,{i,j},ops],
							planarE2[seq,{i,j},ops],
							planarE3[seq,{i,j},ops]
						},
						Energy/.#&
					]
			];

		(* If the heuristic is Energy and the substructure's energy is Infinity, make sure
		 * no bonds are returned, as an energy of Infinity should always correspond with no bonds.
		 * If the heuristic is Bonds, make sure the energy is either Infinity or the negative
		 * of the number of bonds. *)
		result=
			Switch[(Heuristic/.ops),
				Energy,
					{
						First[Vij],
						If[(Energy/.Vij)===Infinity,
							Bonds->{},
							Last[Vij]
						]
					},
				Bonds,
					{
						Rule[
							Energy,
							If[(Energy/.Vij)===Infinity,
								Infinity,
								-Length[Bonds/.Vij]
							]
						],
						Last[Vij]
					}
			];

		(* Return minimum energy structure. *)
		result
	];

(* This piece of code could be useful in the future. *)
(* planarMatrixV[seq_,ops_]:=Table[Energy/.planarV[seq,{i,j},ops],{i,1,StringLength[seq]},{j,1,StringLength[seq]}] *)


(* ::Subsubsection::Closed:: *)
(*planarW*)


(* Function: planarW
 * -----------------
 * Returns the optimal substructure (defined by its Energy and its Bonds) where
 * i and j may or may not form a hydrogen bond.
 * This function uses memoization.
 *)
planarW[seq_,{i_,j_},ops_]:=planarW[seq,{i,j},ops]=
	Module[{subSeqLength,minSubSeqLength,Wij,result},

		(* The number of bases between base i and base j. The bases between i and j are
		 * denoted as the "subsequence" here. *)
		subSeqLength=j-i-1;

		(* The minimum hairpin loop size is also the minimum subsequence length. *)
		minSubSeqLength=(MinHairpinLoopSize/.ops);

		(* If i is not a sufficient distance from j, return an energy of infinity and no bonds.
		 * Otherwise, return the minimum energy substructure of the bases between (and including) i and j. *)
		Wij=
			Which[

				(* Disallow any situations where i\[GreaterEqual]j, which are either copies of previously examined pairs
				 * or pairs with no bases between them (which can't hydrogen bond). *)
				i>=j,
					{Energy->Infinity,Bonds->{}},

				(* Disallow situations where the subsequence between bases i and j is too short to fold on itself. *)
				subSeqLength<minSubSeqLength,
					Return[{Energy->Infinity,Bonds->{}}],

				(* If the subsequence length is large enough to include at least one loop, investigate
				 * four distinct possibilities for folding the subsequence (and choose the one with minimal energy). *)
				subSeqLength>=minSubSeqLength,
					First@MinimalBy[
						{
							planarW[seq,{i+1,j},ops],  (* Any substructure where base i does not hydrogen bond. *)
							planarW[seq,{i,j-1},ops],  (* Any substructure where base j does not hydrogen bond. *)
							planarV[seq,{i,j},ops],     (* Any substructure where bases i and j form a hydrogen bond. *)
							planarE4[seq,{i,j},ops]    (* Any substructure where there is a bifurcation between base i and base j. *)
						},
						Energy/.#&
					]
			];

		(* If the heuristic is Energy and the substructure's energy is Infinity, make sure
		 * no bonds are returned, as an energy of Infinity should always correspond with no bonds.
		 * If the heuristic is Bonds, make sure the energy is either Infinity or the negative
		 * of the number of bonds. *)
		result=
			Switch[(Heuristic/.ops),
				Energy,
					{
						First[Wij],
						If[(Energy/.Wij)===Infinity,
							Bonds->{},
							Last[Wij]
						]
					},
				Bonds,
					{
						Rule[
							Energy,
							If[(Energy/.Wij)===Infinity,
								Infinity,
								-Length[Bonds/.Wij]
							]
						],
						Last[Wij]
					}
			];

		(* Return minimum energy structure. *)
		result
	];

(* This piece of code could be useful in the future. *)
(* planarMatrixW[seq_,ops_]:=Table[Energy/.planarW[seq,{i,j},ops],{i,1,StringLength[seq]},{j,1,StringLength[seq]}] *)


(* ::Subsubsection:: *)
(*thermodynamicPlanarFolding*)


(* Function: thermodynamicPlanarFolding
 * -------------------------------
 * Implements a planar folding algorithm to fold a single strand of RNA/DNA.
 * No pseudoknots are allowed. The algorithm uses dynamic programming, and so
 * the intermediate results are memoized, so one future edit would be
 * to delete all memoized values after completion to free up space.
 *)
thermodynamicPlanarFolding[structure_,safeOps_]:=Module[
	{strands, seqs, seq, foldOut},
	(* must be single strand & single motif *)
	(* should we first consolidate motifs of same polymer type? *)

	(* Extract the strands from the structure. *)
	strands = structure[Strands];

	(* This algorithm only works on single strands, so we throw an error
	 * message if the user provided more than one strand. *)
	If[Length[strands]>1,
		Return[Message[]]
	];

	(* Get the simple sequence version of the strand. *)
	seqs = ToSequence[StrandFlatten[First[strands]]];

	(* Deal with multiple motifs. *)
(*	If[Length[seqs]>1,
		Return[Message[]]
	];*)

	If[Length[seqs]>1,
		seq=StringJoin[Sequence@@seqs],
		seq=First[seqs]
	];


	(* TODO: update to mixed polymer motifs *)
(*	seq = First[seqs];*)

	(* Call the version of planarFolding that returns suboptimal structures
	 * if the user so wishes. *)
	foldOut = If[MatchQ[Lookup[safeOps,SubOptimalStructureTolerance],0],
		thermodynamicPlanarFoldingOptimal[seq,safeOps],
		thermodynamicPlanarFoldingSuboptimal[seq,safeOps]
	];

	ReplaceAll[foldOut, {s_Structure :> NucleicAcids`Private`consolidateBonds[NucleicAcids`Private`reformatBonds[s, StrandBase]]}]
];


(* ::Subsubsection:: *)
(*thermodynamicPlanarFoldingOptimal, thermodynamicPlanarFoldingSuboptimal*)


(* Function: thermodynamicPlanarFoldingOptimal
 * -------------------------------------------
 * Finds the minimum energy (optimal) folded structure
 * given a nucleic acid sequence.
 *)
thermodynamicPlanarFoldingOptimal[seq_,safeOps_List]:=
	Module[{result,energy,strand,bonds,struct,consolidatedStruct,pol},

		(* planarW here finds the minimum energy structure between (and including) the 5' and 3'
		 * bases of seq. Therefore, the structure returned here is the minimum energy structure. *)
		result=planarW[seq,{1,StringLength[seq]},safeOps];

		(* Delete duplicate bonds. *)
		result = {First[result],Bonds->DeleteDuplicates[Bonds/.result]};

		(* Get the polymer type of the sequence given (e.g. DNA, RNA, PNA). *)
		pol = PolymerType[seq];

		(* Extract the indices of the folds returned by planarW and make Bonds out
		 * of them. Each of these Bonds is between two bases and no more (i.e. a single hydrogen bond). *)
		bonds=
			Map[
				Function[bondIndices,
					Bond[
						{1,1,Span[First[bondIndices],First[bondIndices]]},
						{1,1,Span[Last[bondIndices],Last[bondIndices]]}
					]
				],
				Bonds/.result
			];

		(* Make an explicitly typed Strand out of the sequence. *)
		strand = Strand[pol[seq]];

		(* Make a structure from the strand and bonds. *)
		struct = Structure[{strand},bonds];

		(* Consolidate the individual hydrogen bonds into runs of hydrogen bonds (helices). *)
		consolidatedStruct=NucleicAcids`Private`consolidateBonds[struct];

		(* The reason a list of structures or Energy/Bond/Structure's is returned here is that
		 * thermodynamicPlanarFoldingSuboptimal returns a list of structures, and the output pattern between
		 * optimal and suboptimal folding should be consistent. *)
		{consolidatedStruct}
	];


(* Function: thermodynamicPlanarFoldingSuboptimal
 * -------------------------------------------
 * Finds the minimum energy (optimal) folded structure
 * and other 'suboptimal' folded structures, which are
 * folded structures that are within some energy/bond-count
 * tolerance of the optimal structure.
 *)
thermodynamicPlanarFoldingSuboptimal[seq_,safeOps_List]:=
	Module[{subOptimalStructureTolerance,result,optimalEnergy,optimalBonds,optimalBondCount,optimalStruct,allResults,subOptimalResults,allStructs,allEnergies,allBonds,allResultsData,pol},

		(* planarW here finds the minimum energy structure between (and including) the 5' and 3'
		 * bases of seq. Therefore, the structure returned here is the minimum energy structure. *)
		result=planarW[seq,{1,StringLength[seq]},safeOps];

		(* Delete duplicate bonds from the optimal structure. *)
		result={First[result],Bonds->DeleteDuplicates[Bonds/.result]};

		(* Get the polymer type of the sequence given (e.g. DNA, RNA, PNA). *)
		pol = PolymerType[seq];

		(* Convert the bond indices from the optimal result to actual Bonds. *)
		optimalBonds=
			Map[
				Function[bondIndices,
					Bond[
						{1,1,Span[First[bondIndices],First[bondIndices]]},
						{1,1,Span[Last[bondIndices],Last[bondIndices]]}
					]
				],
				Bonds/.result
			];

		(* Create a structure with consolidated bonds (i.e. bond runs to helices) from
		 * the results of planarW. *)
		optimalStruct=
			NucleicAcids`Private`consolidateBonds[
				Structure[
					{Strand[pol[seq]]},
					optimalBonds
				]
			];

		(* The gibbs free energy of the optimal structure. *)
		optimalEnergy = SimulateFreeEnergy[
			optimalStruct, Lookup[safeOps, Temperature, 37 Celsius],
			AlternativeParameterization->Lookup[safeOps,AlternativeParameterization],
			ThermodynamicsModel->Lookup[safeOps,ThermodynamicsModel],
			Upload -> False
		][FreeEnergy];

		(* The number of bonds in the optimal structure. *)
		optimalBondCount = NumberOfBonds[optimalStruct];

		(* Get a a list of all possible substructures for 'seq'. We will
		 * be choosing some of these as suboptimal structures later. *)
		allResults=
			Flatten[
				Table[
					planarW[seq,{i,j},safeOps],
					{i,1,StringLength[seq]-1},
					{j,i+1,StringLength[seq]}
				],
				1
			];

		(* For each possible substructure, delete duplicate bonds and sort
		 * the bonds so they can be more easily compared against other substructures. *)
		allResults=
			Map[
				Function[planarWResult,
					{
						First[planarWResult],
						Rule[
							Bonds,
							SortBy[DeleteDuplicates[Bonds/.planarWResult], First]
						]
					}
				],
				allResults
			];

		(* Delete identical substructures (same bonds/energies). *)
		allResults=DeleteDuplicatesBy[allResults,Last];

		(* Make Structure[] constructs out of each result's bonds, using 'seq' as the one strand. *)
		allStructs=
			Function[
				possibleResult,

				(* If there are no bonds in the folded structure, return a structure with no bonds.
				 * Otherwise, make real Bond[] structures out of the indices and consolidate adjacent bonds. *)
				If[(Bonds/.possibleResult)==={},

					(* Create a structure with no bonds. *)
					Structure[{Strand[pol[seq]]},{}],

					(* Consolidate adjacent bonds into spans (i.e. runs, helices). *)
					NucleicAcids`Private`consolidateBonds[
						Structure[
							{Strand[pol[seq]]},

							(* Make real Bond[] structures out of the list of bonding bases. *)
							Map[
								Function[aPair,
									Bond[
										{1,1,Span[First[aPair], First[aPair]]},
										{1,1,Span[Last[aPair], Last[aPair]]}
									]
								],
								Bonds/.possibleResult
							]
						]
					]
				]
			]/@allResults;

		(* Get the gibbs free energy of each substructure. *)
		allEnergies = SimulateFreeEnergy[
			#, Lookup[safeOps, Temperature, 37 Celsius],
			AlternativeParameterization->Lookup[safeOps,AlternativeParameterization],
			ThermodynamicsModel->Lookup[safeOps,ThermodynamicsModel],
			Upload -> False
		][FreeEnergy]& /@ allStructs;

		(* Get the number of bonds in each substructure. *)
		allBonds = NumberOfBonds /@ allStructs;

		(* Group together the energy, bond count, and structure for each
		 * possible suboptimal structure. *)
		allResultsData = Thread[{allEnergies,allBonds,allStructs}];

		(* Extract the suboptimal structure tolerance from the options. *)
		subOptimalStructureTolerance = SubOptimalStructureTolerance/.safeOps;

		(* The tolerance is either an integer (meaning tolerance is by number of bonds),
		 * a percent (meaning tolerance is by percent away from the optimal structure's energy),
		 * or a Quantity[_, Kilo Calorie / Mole] (meaning tolerance is by kcal/mole away from
		 * the optimal structure's energy). *)
		subOptimalResults=
			Switch[Units[subOptimalStructureTolerance],

				(* If tolerance is by percent, subOptimalResults will include all structures whose energy is
				 * within a certain percent of the optimal folded structure's energy. *)
				Quantity[1,Percent],
					Select[
						allResultsData,
						Function[result,
							With[{resultEnergy = First[result]},
								(100 Abs[resultEnergy-optimalEnergy]/Abs[optimalEnergy]) <= Unitless[subOptimalStructureTolerance]
							]
						]
					],

				(* If tolerance is by kcal/mole, subOptimalResults will include all structures whose energy is
				 * within a certain absolute energy of the optimal folded structure's energy. *)
				Quantity[1,Kilo Calorie/Mole],
					Select[
						allResultsData,
						Function[result,
							With[{resultEnergy = First[result]},
								Abs[resultEnergy-optimalEnergy] <= subOptimalStructureTolerance
							]
						]
					],

				(* If tolerance is by integer, subOptimalResults will include all structures whose bond count is
				 * within a certain number of the optimal folded structure's bond count. *)
				_,
					Select[
						allResultsData,
						Abs[#[[2]]-optimalBondCount]<=subOptimalStructureTolerance&
					]
			];

		(* If the Heuristic is Energy, sort the suboptimal results by their energies.
		 * Vice versa for Heuristic\[Rule]Bonds. *)
		subOptimalResults=
			Switch[(Heuristic/.safeOps),
				Energy,
					SortBy[subOptimalResults, Part[#,1]&],
				Bonds,
					SortBy[subOptimalResults, -Part[#,2]&]
			];


		Last /@ subOptimalResults
	];


(* ::Subsection::Closed:: *)
(*Constructing structures*)


(* ::Subsubsection::Closed:: *)
(*structureFromStructureInteraction*)


structureSequenceP={{_String..},_Symbol};


structureFromStructureInteraction[comp:StructureP,interactions:{{{StructureSpanP,StructureSpanP},{structureSequenceP,structureSequenceP}}...}]:=
	Map[foldStructure[comp,{#[[1,1]],{#[[1,2,1]],#[[1,2,2]],Reverse[#[[1,2,3]]]}}]&,interactions];

structureFromStructureInteraction[compA_Structure,compB_Structure,interactions:{{{StructureSpanP,StructureSpanP},{structureSequenceP,structureSequenceP}}...}]:=
	Map[pairStructure[compA,compB,{#[[1,1]],{#[[1,2,1]],#[[1,2,2]],Reverse[#[[1,2,3]]]}}]&,interactions];

structureFromStructureInteraction[compA_Structure,compB_Structure,interactions:{{StructureSpanP,StructureSpanP}...}]:=
	Map[pairStructure[compA,compB,{#[[1,1]],{#[[1,2,1]],#[[1,2,2]],Reverse[#[[1,2,3]]]}}]&,interactions];

structureFromStructureInteraction[compA_Structure,compB_Structure,interactions:{{SequenceSpanP,SequenceSpanP}...}]:=
	Map[pairStructure[compA,compB,{{1,1,#[[1]]},{2,1,Reverse[#[[2]]]}}]&,interactions];

structureFromStructureInteraction[comp_Structure,interactions:{{SequenceSpanP,SequenceSpanP}...}]:=
	Map[foldStructure[comp,{{1,1,#[[1]]},{1,1,Reverse[#[[2]]]}}]&,interactions];

structureFromStructureInteraction[comp_Structure,a_Integer,b_Integer,interactions:{{SequenceSpanP,SequenceSpanP}...}]:=
	Map[foldStructure[comp,{{a,#[[1]]},{b,Reverse[#[[2]]]}}]&,interactions];



(* ::Subsubsection::Closed:: *)
(*addStructurePair*)


addStructurePair[com:StructureP,pos:{first:{_Integer,_Integer,Span[_Integer,_Integer]},second:{_Integer,_Integer,Span[_Integer,_Integer]}}] :=
	Structure[com[Strands],Append[com[Bonds], Bond[first,second] ]];

addStructurePair[com:StructureP,pos:{first:{_Integer,Span[_Integer,_Integer]},second:{_Integer,Span[_Integer,_Integer]}}] :=
	Structure[com[Strands],Append[com[Bonds], Bond[first,second] ]];


(* ::Subsubsection::Closed:: *)
(*deleteBrokenPairs*)


(* Filters out bonds that involve the motifs that are about to form a new bond *)
deleteBrokenPairs[pairs:{BondP...}, form:{BondP...}] :=
		Cases[pairs, Except[Alternatives@@Replace[form, Bond[x_,y_] :> Bond[x,_]|Bond[_,x]|Bond[y,_]|Bond[_,y], {1}]]];


(* ::Subsubsection::Closed:: *)
(*foldStructure*)


(* add multiple pairs between motifs *)
foldStructure[com:StructureP,pos:{{a_Integer,b_Integer,first:{_Span..}},{c_Integer,d_Integer,second:{_Span..}}}] := (
	Fold[addStructurePair[#1,{{a,b,#2[[1]]},{c,d,#2[[2]]}}]&,com,Transpose[{first,second}]]
);

foldStructure[com:StructureP,pos:{{a_Integer,first:{_Span..}},{c_Integer,second:{_Span..}}}] := (
	Fold[addStructurePair[#1,{{a,#2[[1]]},{c,#2[[2]]}}]&,com,Transpose[{first,second}]]
);



(* ::Subsubsection::Closed:: *)
(*pairStructure*)
Authors[pairStructure]:={"scicomp", "brad"};


(* pair two separate structures *)
pairStructure[comp1_Structure,comp2_Structure, pos:{first:{_Integer,_Integer,_Span},second:{_Integer,_Integer,_Span}}]:=With[
	{newStructure=StructureJoin[comp1,comp2]},
	addStructurePair[newStructure,pos]
	];

pairStructure[comp1_Structure,comp2_Structure, pos:{{a_Integer,b_Integer,first:{_Span..}},{c_Integer,d_Integer,second:{_Span..}}}]:=Module[
	{newStructure,offset},
	newStructure=StructureJoin[comp1,comp2];
	offset=Length[comp1[[1]]];
	Fold[addStructurePair[#1,{{a,b,#2[[1]]},{c+offset,d,#2[[2]]}}]&,newStructure,Transpose[{first,Reverse[second]}]]
	];

pairStructure[comp1_Structure,comp2_Structure, pos:{{{_Integer,_Integer,_Span},{_Integer,_Integer,_Span}}..}]:=Module[
	{newStructure,offset},
	newStructure=StructureJoin[comp1,comp2];
	offset=Length[comp1[[1]]];
	Fold[addStructurePair[#1,{#2[[1]],{offset,0,{0,0}}+#2[[2]]}]&,newStructure,pos]
	];



(* ::Section:: *)
(*End*)
