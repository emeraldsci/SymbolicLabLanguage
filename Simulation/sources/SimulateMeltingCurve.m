(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Messages and Tests*)

Error::InvalidTemperature = "The input HighTemperature `1` is lower than LowTemperature `2`. Please make sure HighTemperature is higher than LowTemperature.";

(* ::Text:: *)
(*validHighLowTemperaturesTestOrEmpty*)

validHighLowTemperaturesTestOrEmpty[lowTemperature_, highTemperature_, makeTest:BooleanP,description_,passedQ_]:=If[makeTest,
	Test[description,passedQ,True],
	If[TrueQ[passedQ],
		{},
		Message[Error::InvalidTemperature, highTemperature, lowTemperature];
		Message[Error::InvalidOption,{LowTemperature,HighTemperature}];
	]
];


(* ::Subsection:: *)
(*MeltingCurve Simulation*)

(* ::Subsubsection:: *)
(*Options*)

DefineOptions[SimulateMeltingCurve,
	Options :> {
		{
			OptionName->LowTemperature,
			Default->5*Celsius,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Kelvin | Celsius ],
			Description->"The ending temperature for simulating the cooling curve, and it is the starting temperature for simulating the melting curve."
		},
		{
			OptionName->HighTemperature,
			Default->95*Celsius,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Kelvin | Celsius ],
			Description->"The initial temperature to begin with for simulating the cooling curve, and it is the ending temperature for simulating the melting curve."
		},
		{
			OptionName->TemperatureRampRate,
			Default->Celsius/Second,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin/Second], Units-> Kelvin / Second],
			Description->"The rate at which the temperature is continuously changing."
		},
		{
			OptionName->EquilibrationTime,
			Default->5*Minute,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Second], Units->Second],
			Description->"The amount of time to start with and stay the same temperature for simulation at the temperature extremes (high temp and low temp)."
		},
		{
			OptionName->Method,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> Discrete | Continuous],
			Description->"If Discrete, the function simulates discrete temperature steps with equilibrium time at each step. If Continuous, continuous temperature changes without equilibrium time at each step is simulated. If Automatic, will pick Discrete or Continuous depends on StepEquilibriumTime."
		},
		{
			OptionName->TemperatureStep,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units->Kelvin],
			Description->"The number of degrees the temperature changes from a previous stable temperature to the next stable temperature."
		},
		{
			OptionName->StepEquilibriumTime,
			Default->Minute,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Second], Units->Second],
			Description->"The amount of time to stay the same temperature for simulation between each temperature change."
		},
		{
			OptionName->TrackedSpecies,
			Default->{Initial, MaxFold, MaxPair},
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->MultiSelect, Pattern:> DuplicateFreeListableP[ Initial | MaxFold | MaxPair ]],
				Widget[Type->Expression, Pattern:> ListableP[ Initial | MaxFold | MaxPair | StructureP], PatternTooltip->"One or a list of groups and species like {Initial,'AAGGCC'}", Size->Line]
			],
			Description->"A subset of species in LabeledStructures. Can be Initial (initial structure), MaxFold or MaxPair (structures with the most base pairs formed by folding or pairing), or any other specified structures."
		},
		{
			OptionName->Template,
			Default -> Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,MeltingCurve]],ObjectTypes->{Object[Simulation,MeltingCurve]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,MeltingCurve],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"A template simulation whose methodology should be reproduced in running this simulation. Option values will be inherited from the template simulation, but can be individually overridden by directly specifying values for those options to this simulation function."
		},
		OutputOption,
		UploadOption
	}
];



(* ::Subsubsection:: *)
(*SimulateMeltingCurve*)

(* ::Text:: *)
(*Singleton input case*)

inputSpeciesSimulateMeltingCurveP = Alternatives[
	ReactionSpeciesP,
	ObjectP[Model[Sample]],
	ObjectP[Object[Sample]]
];

InputPatternSimulateMeltingCurveP = {inputSpeciesSimulateMeltingCurveP, _?ConcentrationQ};


SimulateMeltingCurve[in:ListableP[InputPatternSimulateMeltingCurveP],ops:OptionsPattern[]]:=Module[
	{startFields, coreFields, inList, unboundState, listedOptions, initialConsList, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests, combinedOptions, optionsRule, previewRule, testsRule, resultRule, resolvedOptions, resolvedOptionsTests, resolvedOptionsResult, unresolvedOptions, templateTests, tempStep},

	(* Make sure we're working with a list of options and inputs *)
	listedOptions = ToList[ops];

	(* Embed in list if single input *)
	inList = If[MatchQ[{in},{InputPatternSimulateMeltingCurveP}],
		{in},
		in
	];

	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateMeltingCurve,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateMeltingCurve,listedOptions,AutoCorrect->False],{}}
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
			ValidInputLengthsQ[SimulateMeltingCurve,{inList},listedOptions,Output->{Result,Tests}],
			{ValidInputLengthsQ[SimulateMeltingCurve,{inList},listedOptions],{}}
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

	unboundState = resolveInputsSimulateMeltingCurve[inList];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateMeltingCurve,{inList},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateMeltingCurve,{inList},listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	(* resolve inputs, options sets for each input, and tests together--if we have a good set of options sets, use first one for function *)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
			resolveOptionsSimulateMeltingCurve[combinedOptions,{}, Output->{Result,Tests}],
			{resolveOptionsSimulateMeltingCurve[combinedOptions,{}],{}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		{coreFields, tempStep} = If[MatchQ[resolvedOptions,$Failed],
			{$Failed,$Failed},
			simulateMeltingCurveCore[unboundState,resolvedOptions]
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
			Module[{previewMelting, previewCooling},
				(* Get all the trajectories *)
				previewMelting = Lookup[coreFields, MeltingCurve, $Failed];
				previewCooling = Lookup[coreFields, CoolingCurve, $Failed];

				(* Check for errors and plot *)
				If[MatchQ[previewMelting,$Failed] || MatchQ[previewCooling,$Failed],
					$Failed,
					Zoomable[ECL`PlotTrajectory[{previewMelting, previewCooling}]]
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
	(* Join all existing tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MatchQ[coreFields,$Failed],
			$Failed,
			Module[{result, endFields, packetList},
			(* Make Object-specific fields for packet *)
				endFields = simulationPacketStandardFieldsFinish[resolvedOptions];

				packetList = ToList[formatOutputSimulateMeltingCurve[startFields, endFields, unboundState, coreFields, tempStep, resolvedOptions]];

				(* If not uploading, just output the packetLists *)
				If[Lookup[resolvedOptions, Upload],
					result = uploadAndReturn[packetList];
					If[MatchQ[result,_List] && Length[Flatten[result]]==1,
						First[Flatten[result]],
						result
					],

				(* For single set of initial conditions, output just the first packetList unless failed flatten packets so they behave like objects *)
					If[MatchQ[packetList,_List] && Length[Flatten[packetList]]==1,
						First[Flatten[packetList]],
						packetList
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Text:: *)
(*Multiple/PrimerSet*)

inputPatternSimulateMeltingCurveListP = Alternatives[
	ObjectP[Model[PrimerSet]]
];

(* --- Model[Sample] --- *)
SimulateMeltingCurve[in:inputPatternSimulateMeltingCurveListP,ops:OptionsPattern[]]:=Module[
	{startFields, beaconState, beaconWithRevState, beaconAlone, inputOps, coreFields, listedOptions, initialConsList, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests, combinedOptions, optionsRule, previewRule, testsRule, resultRule, resolvedOptions, resolvedOptionsTests, resolvedOptionsResult, unresolvedOptions, templateTests},

(* Make sure we're working with a list of options and inputs *)
	listedOptions = ToList[ops];

	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateMeltingCurve,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateMeltingCurve,listedOptions,AutoCorrect->False],{}}
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
			ValidInputLengthsQ[SimulateMeltingCurve,{in},listedOptions,2,Output->{Result,Tests}],
			{ValidInputLengthsQ[SimulateMeltingCurve,{in},listedOptions,2],{}}
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

	{beaconState,beaconWithRevState,inputOps} = resolveListInputsSimulateMeltingCurve[in];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateMeltingCurve,{in},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateMeltingCurve,{in},listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	(* resolve inputs, options sets for each input, and tests together--if we have a good set of options sets, use first one for function *)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
			resolveOptionsSimulateMeltingCurve[combinedOptions, inputOps, Output->{Result,Tests}],
			{resolveOptionsSimulateMeltingCurve[combinedOptions, inputOps],{}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		coreFields = If[MatchQ[resolvedOptions,$Failed],
			$Failed,
			Map[simulateMeltingCurveCore[#, resolvedOptions]&, {beaconState,beaconWithRevState}]
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
			Module[{preview, previewMelting, previewCooling},
				(* Get all the trajectories *)
				previewMelting = Lookup[First[#], MeltingCurve, $Failed] & /@ ToList[coreFields];
				previewCooling = Lookup[First[#], CoolingCurve, $Failed] & /@ ToList[coreFields];

				(* Check for errors and plot *)
				If[MemberQ[previewMelting,$Failed] || MemberQ[previewCooling,$Failed],
					$Failed,
					preview = MapThread[ECL`PlotTrajectory[{#1,#2}, ImageSize->400] &, {previewMelting, previewCooling}];
					Grid[{Zoomable[preview]}]
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
	(* Join all existing tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MatchQ[coreFields,$Failed],
			$Failed,
			Module[{result, endFields, packetList},
			(* Make Object-specific fields for packet *)
				endFields = simulationPacketStandardFieldsFinish[resolvedOptions];

				packetList = MapThread[formatOutputSimulateMeltingCurve[startFields, endFields,#1,#2,#3,resolvedOptions]&, {{beaconState,beaconWithRevState}, First/@coreFields, Last/@coreFields}];

				(* If not uploading, just output the packetLists *)
				If[Lookup[resolvedOptions, Upload],
					result = uploadAndReturn[packetList];
					If[MatchQ[result,_List] && Length[Flatten[result]]==1,
						First[Flatten[result]],
						result
					],

				(* For single set of initial conditions, output just the first packetList unless failed flatten packets so they behave like objects *)
					If[MatchQ[packetList,_List] && Length[Flatten[packetList]]==1,
						First[Flatten[packetList]],
						packetList
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection:: *)
(*ValidSimulateMeltingCurveQ*)

DefineOptions[ValidSimulateMeltingCurveQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateMeltingCurve}
];

Authors[ValidSimulateMeltingCurveQ] := {"brad"};

ValidSimulateMeltingCurveQ[myInput: Alternatives[ListableP[InputPatternSimulateMeltingCurveP] | inputPatternSimulateMeltingCurveListP], myOptions:OptionsPattern[ValidSimulateMeltingCurveQ]]:=Module[
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
	functionTests = SimulateMeltingCurve[myInput,preparedOptions];

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

	RunUnitTest[<|"ValidSimulateMeltingCurveQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidSimulateMeltingCurveQ"]
];



(* ::Subsubsection:: *)
(*SimulateMeltingCurveOptions*)

Authors[SimulateMeltingCurveOptions] := {"brad"};

SimulateMeltingCurveOptions[in: Alternatives[ListableP[InputPatternSimulateMeltingCurveP] | inputPatternSimulateMeltingCurveListP], ops : OptionsPattern[SimulateMeltingCurve]] := Module[{listedOptions, noOutputOptions},
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	SimulateMeltingCurve[in, PassOptions[SimulateMeltingCurve, Append[noOutputOptions, Output->Options]]]
];



(* ::Subsubsection:: *)
(*SimulateMeltingCurvePreview*)

Authors[SimulateMeltingCurvePreview] := {"brad"};

SimulateMeltingCurvePreview[in: Alternatives[ListableP[InputPatternSimulateMeltingCurveP] | inputPatternSimulateMeltingCurveListP], ops : OptionsPattern[SimulateMeltingCurve]] := Module[{listedOptions, noOutputOptions},
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	SimulateMeltingCurve[in, PassOptions[SimulateMeltingCurve, Append[noOutputOptions, Output->Preview]]]
];



(* ::Subsubsection:: *)
(*resolveInputsSimulateMeltingCurve*)

resolveInputsSimulateMeltingCurve[in:{List[SequenceP | StrandP | StructureP, _?ConcentrationQ]..}]:= resolveInputsSimulateMeltingCurve[ToState[Rule@@#&/@in]];
resolveInputsSimulateMeltingCurve[in:List[SequenceP | StrandP | StructureP, _?ConcentrationQ]]:= resolveInputsSimulateMeltingCurve[{in}];

resolveInputsSimulateMeltingCurve[in:{List[ObjectReferenceP[{Object[Sample], Model[Sample]}], _?ConcentrationQ]..}]:= Module[
	{structs},

	structs = ToStructure[FirstCase[#,StrandP|StructureP,Null]]&/@Download[First/@in, Composition[[All,2]][Molecule]];
	resolveInputsSimulateMeltingCurve[Transpose[{structs, Last/@in}]]

];

resolveInputsSimulateMeltingCurve[List[obj:ObjectReferenceP[{Object[Sample], Model[Sample]}],conc_?ConcentrationQ]]:=
    resolveInputsSimulateMeltingCurve[List[Download[obj],conc]];

resolveInputsSimulateMeltingCurve[List[pac:PacketP[{Model[Sample],Object[Sample]}],conc_?ConcentrationQ]]:=Module[{singleStrandOrStructure},
	(* Get the strands from the composition field. *)
	singleStrandOrStructure = FirstOrDefault[Cases[Download[pac,Composition[[All,2]][Molecule]],StrandP|StructureP],Null];

	resolveInputsSimulateMeltingCurve[{singleStrandOrStructure,conc}]
];
resolveInputsSimulateMeltingCurve[List[pac:PacketP[Object[Model,PrimerSet]],conc_?ConcentrationQ]]:=Module[{singleStrandOrStructure},
	(* Get the strands from the composition field. *)
	singleStrandOrStructure = FirstOrDefault[Cases[Download[pac,Composition[[All,2]][Molecule]],StrandP|StructureP],Null];

	resolveInputsSimulateMeltingCurve[{singleStrandOrStructure,conc}]
];

resolveInputsSimulateMeltingCurve[in:StateP]:=in;



(* ::Subsubsection::Closed:: *)
(*resolveListInputsSimulateMeltingCurve*)

Options[resolveListInputsSimulateMeltingCurve]:={
	BeaconConcentration -> 0.25*Micro*Molar,
	BeaconTargetConcentration -> Micro*Molar,
	MolecularBeacons -> {Null}
};


resolveListInputsSimulateMeltingCurve[obj:Except[PacketP[{Model[Sample],Model[PrimerSet]}],ObjectP[{Model[Sample],Model[PrimerSet]}]], ops: OptionsPattern[]]:=resolveListInputsSimulateMeltingCurve[Download[obj], ops];


resolveListInputsSimulateMeltingCurve[pac:PacketP[{Model[Sample],Model[PrimerSet]}], ops: OptionsPattern[]]:=Module[
	{beaconSeq,beaconRev,beaconState,beaconWithRevState,inputOps},
	(*beaconSeq = First[Cases[Molecule/.Download[Beacon/.pac],_DNA,{2}]];*)
	beaconSeq = (Molecule/.Download[Beacon/.pac])[Motifs][[1,1]];
	beaconState = ToState[{ToStructure[beaconSeq]->OptionValue[BeaconConcentration]}];
	(*beaconRev = First[First[Strand/.Download[BeaconTarget/.pac]]];*)
	beaconRev = (Molecule/.Download[BeaconTarget/.pac])[Motifs][[1,1]];
	beaconWithRevState = ToState[{
		ToStructure[beaconSeq]->OptionValue[BeaconConcentration],
		ToStructure[beaconRev]->OptionValue[BeaconTargetConcentration ]
	}];
	inputOps = {MolecularBeacons->{Object/.pac}};
	{beaconState,beaconWithRevState,inputOps}
];

(* ::Subsubsection::Closed:: *)
(*resolveOptionsSimulateMeltingCurve*)

DefineOptions[resolveOptionsSimulateMeltingCurve,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveOptionsSimulateMeltingCurve[unresolvedOps_List,inputOptions_List, ops:OptionsPattern[]]:=Module[
	{method, lowTemperature, highTemperature, output, listedOutput, collectTestsBoolean, result, allTests},

	(* From resolveOptionsSimulateMeltingCurve's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	method = Switch[Lookup[unresolvedOps,Method,Automatic],
		Automatic, If[Lookup[unresolvedOps, StepEquilibriumTime, Null] == 0 Minute, Continuous, Discrete],
		_, Lookup[unresolvedOps,Method]
	];

	lowTemperature = Lookup[unresolvedOps, LowTemperature, Null];
	highTemperature = Lookup[unresolvedOps, HighTemperature, Null];

	allTests = {validHighLowTemperaturesTestOrEmpty[lowTemperature, highTemperature, collectTestsBoolean, "Low temperature is at or below high temperature:", lowTemperature<=highTemperature]};

	(* check highTemp must be higher than lowTemp *)
	result = If[highTemperature <= lowTemperature,
		$Failed,
		ReplaceRule[unresolvedOps, Method->method]
	];

	output/.{Tests->ToList[allTests],Result->result}
];



(* ::Subsubsection:: *)
(*formatOutputSimulateMeltingCurve*)

formatOutputSimulateMeltingCurve[nominalStartFields_,nominalEndFields_,unboundState_,coreResultFields_,tempStep_,resolvedOps_List]:=Module[{out},

	out = Association[
		Join[
			{Type -> Object[Simulation,MeltingCurve]},
			nominalStartFields,
			coreResultFields,
			{
				UnboundState->unboundState,
				EquilibrationTime->Lookup[resolvedOps,EquilibrationTime],
				HighTemperature->Lookup[resolvedOps,HighTemperature],
				LowTemperature->Lookup[resolvedOps,LowTemperature],
				TemperatureStep->tempStep,
				TemperatureRampRate->Lookup[resolvedOps,TemperatureRampRate],
				StepEquilibriumTime->Lookup[resolvedOps,StepEquilibriumTime]
			},
			nominalEndFields
		]
	]

];



(* ::Subsubsection:: *)
(*simulateMeltingCurveCore*)

simulateMeltingCurveCore[unboundState_State, resolvedOps_List]:= Module[
	{
		mech,meltCurve,coolCurve,labeledStructures,
		initialSpecies,initialConcentrations,allSpecies,eqs,changeTime,
		ic,sim,tempRate,eqTime,highTemp,lowTemp,stepEqTime, turningPoint, timeFunc, tempFunc,
		coolingFunc, coolingTempRange, htUnitless, ltUnitless, trUnitless, eqTimeUnitless, stepEqTimeunitless, tempStepUnitless
	},

	tempRate=Lookup[resolvedOps,TemperatureRampRate];
	eqTime = Lookup[resolvedOps,EquilibrationTime];
	highTemp = Lookup[resolvedOps,HighTemperature];
	lowTemp = Lookup[resolvedOps,LowTemperature];
	stepEqTime = Lookup[resolvedOps,StepEquilibriumTime];

	(* remove unit for faster computation *)
	{htUnitless, ltUnitless, trUnitless, eqTimeUnitless, stepEqTimeunitless} = {Unitless[highTemp, Celsius], Unitless[lowTemp, Celsius], Unitless[tempRate, "DegreesCelsius"/"Seconds"], Unitless[eqTime, Second], Unitless[stepEqTime, Second]};

	(* If TemperatureStep is Automatic, default there are 50 temperature changes in cooling/melting *)
	tempStepUnitless = Switch[Lookup[resolvedOps,TemperatureStep],
						Automatic, (htUnitless - ltUnitless)/50,
						_, Unitless[Lookup[resolvedOps,TemperatureStep], Celsius]
					];

	changeTime = tempStepUnitless/trUnitless;

	(* initial state *)
	{initialSpecies,initialConcentrations}=Transpose[List@@unboundState];

	(* generate the mechanism *)
	mech = SimulateReactivity[initialSpecies,Quiet@PassOptions[SimulateMeltingCurve,SimulateReactivity, Join[ReplaceRule[resolvedOps, {Upload->False, Output->Result}], {Temperature->Null, Depth->1, InterStrandFolding->False, IntraStrandFolding->False, MinFoldLevel->3, MinPairLevel->5}]]][ReactionMechanism];

	(* all species that will be created *)
	allSpecies = SpeciesList[mech, Sort->False];

	(* list of species to return *)
	If[allSpecies=!={},
		eqs = SimulateEquilibriumConstant[allSpecies, Upload->False][EquilibriumConstant];
		labeledStructures = Cases[
			Flatten[Lookup[resolvedOps, TrackedSpecies]/.{Initial->initialSpecies, MaxFold->maxFold[allSpecies,eqs], MaxPair->maxPair[allSpecies,eqs]}],
			_Structure,
			{1}
		],

		allSpecies = initialSpecies;
		labeledStructures = initialSpecies
	];



	ic = Thread[Rule[initialSpecies, initialConcentrations]];

	(*==========================================================*)
	(* just conduct SimulateKinetics once to get concentration vs. time *)
	(*==========================================================*)

	(* input temperature and get corresponding time for cooling *)
	timeFunc = Ceiling[temp2Time[# + 0.01, htUnitless, trUnitless, eqTimeUnitless, changeTime, stepEqTimeunitless, Lookup[resolvedOps, Method]]]&;

	(* turningPoint between cooling and melting *)
	turningPoint = timeFunc@@{ltUnitless};

	(* temperature function for cooling combined with melting *)
	tempFunc = If[#<=turningPoint,
				time2Temp[#, htUnitless, trUnitless, eqTimeUnitless, changeTime, stepEqTimeunitless, Lookup[resolvedOps, Method]],
				-time2Temp[#-turningPoint, htUnitless, trUnitless, eqTimeUnitless, changeTime, stepEqTimeunitless, Lookup[resolvedOps, Method]] + htUnitless + ltUnitless + 273.15*2
			]&;

(* print out temperature function *)
(*Print[Plot[tempFunc[x], {x, 0, 2*turningPoint}, PlotPoints->3000]];*)

	(* conduct one kenetics simulation*)
	simTraj = Lookup[SimulateKinetics[mech, ic, 2*turningPoint Second, Temperature-> tempFunc, Upload->False], Trajectory, $Failed];
	(*==========================================================*)

	coolingTempRange = Range[htUnitless, ltUnitless, -tempStepUnitless];

	(* Here the interpolationOrder is set to 1 to avoid overfitting interpolation in TrajectoryRegression *)
	coolCurve=ToTrajectory[allSpecies,TrajectoryRegression[simTraj, timeFunc/@coolingTempRange, InterpolationOrder -> 1],coolingTempRange,{Celsius,Molar}];
	meltCurve=ToTrajectory[allSpecies,TrajectoryRegression[simTraj, timeFunc/@coolingTempRange + turningPoint, InterpolationOrder -> 1],Reverse[coolingTempRange],{Celsius,Molar}];


	{
		{
			ReactionMechanism->mech,
			MeltingCurve->meltCurve,
			CoolingCurve->coolCurve,
			Replace[LabeledStructures]->labeledStructures
		},
		tempStepUnitless*Celsius
	}

];


time2Temp[t_, highTemp_, tempRate_, eqTime_, changeTime_, setpEqTime_, Continuous]:= 273.15 + highTemp /; t <= eqTime;
time2Temp[t_, highTemp_, tempRate_, eqTime_, changeTime_, setpEqTime_, Continuous]:= 273.15 + highTemp - tempRate*(t - eqTime);

time2Temp[t_, highTemp_, tempRate_, eqTime_, changeTime_, setpEqTime_, Discrete]:= 273.15 + highTemp /; t <= eqTime;
time2Temp[t_, highTemp_, tempRate_, eqTime_, changeTime_, setpEqTime_, Discrete]:= 273.15 + highTemp - tempRate*(t - eqTime) + tempRate*setpEqTime*Quotient[t-eqTime, setpEqTime+changeTime] /; Mod[t-eqTime, setpEqTime+changeTime] < changeTime;
time2Temp[t_, highTemp_, tempRate_, eqTime_, changeTime_, setpEqTime_, Discrete]:= With[
	{x = (setpEqTime+changeTime)*Quotient[t-eqTime, setpEqTime+changeTime] + changeTime + eqTime},

	273.15 + highTemp - tempRate*(x - eqTime) + tempRate*setpEqTime*Quotient[t-eqTime, setpEqTime+changeTime]

];


temp2Time[T_, highTemp_, tempRate_, eqTime_, changeTime_, setpEqTime_, Continuous] := (1/tempRate)*(highTemp - T) + eqTime;
temp2Time[T_, highTemp_, tempRate_, eqTime_, changeTime_, setpEqTime_, Discrete]:= (1/tempRate)*(highTemp - T) + eqTime + setpEqTime*Quotient[highTemp - T, tempRate*changeTime];


maxFold[cs_,eqs_]:=maxStructureFromList[Cases[Transpose[{cs,eqs}],{Structure[{_Strand},_],_}]];
maxPair[cs_,eqs_]:=maxStructureFromList[Cases[Transpose[{cs,eqs}],{Structure[{_Strand,__Strand},_],_}]];

maxStructureFromList[{}]:={};
maxStructureFromList[in_]:=Sort[in,#1[[2]]>#2[[2]]&][[1,1]];


(* ::Section:: *)
(*End*)
