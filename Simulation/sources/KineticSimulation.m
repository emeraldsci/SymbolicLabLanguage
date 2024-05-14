(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*patterns*)


specP = _Symbol|_String|_Strand|_Structure;
anyReactionSideP = specP | HoldPattern[Times][_Integer,specP] | HoldPattern[Plus][specP..] | HoldPattern[Plus][(specP|HoldPattern[Times][_Integer,specP])..];


(* ::Subsection:: *)
(*Kinetic Simulation*)


(* ::Subsubsection:: *)
(*Options*)

DefineOptions[SimulateKinetics,
	Options:>{
		{
			OptionName->Temperature,
			Default-> 37Celsius,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Kelvin | Celsius ],
				Widget[Type->Expression, Pattern:> _Function, PatternTooltip->"A pure function to vary temperature over time (which is #) like: (273 + #/3 &).", Size->Paragraph]
			],
			Description->"Temperature at which to run the simulation.  If a Function, Temperature must be in Kelvin."
		},
		{
			OptionName->Volume,
			Default-> 150*Microliter,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Picoliter], Units-> Picoliter | Nanoliter | Microliter | Milliliter | Liter | Gallon | Quart | Pint | Cup | FluidOunce | Meter^3 | Foot^3 | Inch^3 ],
				Adder[
					Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Picoliter], Units-> Picoliter | Nanoliter | Microliter | Milliliter | Liter | Gallon | Quart | Pint | Cup | FluidOunce | Meter^3 | Foot^3 | Inch^3 ]
				]
			],
			Description->"Volume for stochastic simulation. If Volume===Null, uses deterministic simulation."
		},
		{
			OptionName->Method,
			Default->Deterministic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> Deterministic | Stochastic | Analytic ],
			Description->"Method to use for solving the kinetic equations.  Stochastic simulations will have multiple outputs and requires that Volume option is not Null."
		},
		{
			OptionName->NumberOfPoints,
			Default-> 50,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterP[0,1]],
			Description->"Number of times at which to sample the solution when the Method option is set to Analytic."
		},
		{
			OptionName->ObservedSpecies,
			Default->All,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:> Alternatives[All]],
				Widget[Type->Expression, Pattern:> ListableP[SpeciesP,2], PatternTooltip->"A list of species like {\"a\",\"b\"..}.", Size->Line]
			],
			Description->"The species that should be returned in the resulting Trajectory."
		},
		{
			OptionName->Injections,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:> Alternatives[{}]],
				Adder[{
					"Time"->Widget[Type->Quantity, Pattern:> GreaterP[0 Second], Units-> Second | Minute | Hour | Day ],
					"Species"->Widget[Type->String, Pattern:> _?StringQ, Size -> Word],
					"Volume"->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Picoliter], Units-> Picoliter | Nanoliter | Microliter | Milliliter | Liter | Gallon | Quart | Pint | FluidOunce ],
					"FlowRate (null if instantaneous)"->Alternatives[
						Widget[Type->Enumeration, Pattern:> Alternatives[Null]],
						Widget[Type-> Quantity, Pattern:> GreaterEqualP[0 Picoliter / Second], Units-> Picoliter / Second | Nanoliter / Second | Microliter / Second | Milliliter / Second | Liter / Second | Gallon / Second | Quart / Second | Pint / Second | FluidOunce / Second ]
					],
					"Concentration"->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Picomolar], Units-> Picomolar | Nanomolar | Micromolar | Millimolar | Molar ]
				}, Orientation -> Vertical],
				Widget[Type->Expression, Pattern:> ListableP[InjectionsFormatP], PatternTooltip->"A list of injections like {{Time, Species, Volume, FlowRate, Concentration}..}.", Size->Line]
			],
			Description->"Species injected during the run, in the form of: {Time, Species, Volume, FlowRate, Concentration} where FlowRate can be omitted or Null for instantaneous injections."
		},
		{
			OptionName->Template,
			Default-> Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Kinetics]],ObjectTypes->{Object[Simulation,Kinetics]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,Kinetics],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description-> "A template analysis whose methodology should be reproduced in running this analysis. Option values will be inherited from the template analysis, but can be individually overridden by directly specifying values for those options to this analysis function."
		},
		{
			OptionName->NumberOfTrajectories,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Number, Pattern:> GreaterEqualP[1, 1]],
			Description->"Number of simulated trajectories when performing a stochatic simulation.  If Null, simulation returns a single trajectory.  If an Integer, simulation always returns a list of trajectories."
		},
		{
			OptionName->AccuracyGoal,
			Default->6,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterP[0,1]],
			Description->"The desired absolute tolerance of the computed solution."
		},
		{
			OptionName->PrecisionGoal,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> GreaterP[0,1]],
			Description->"The desired relative tolerance of the computed solution.",
			ResolutionDescription->"If Automatic, PrecisionGoal is set to the Log10 ratio of the max/min Molar quantities in InitialStates for respective part of the calculation."
		},
		{
			OptionName->MaxStepFraction,
			Default->1/100,
			AllowNull->False,
			Widget->Widget[Type->Number, Pattern:> RangeP[0,1]],
			Description->"Maximum fraction of total simulation time to step during integration."
		},
		{
			OptionName->Noise,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Number, Pattern:> GreaterEqualP[0]],
				Widget[Type->Expression, Pattern:> _?DistributionParameterQ | ConcentrationP, PatternTooltip->"A concentration or distribution like NormalDistribution[0,10^-8].", Size->Line],
				Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Percent], Units->Percent]
			],
			Description->"Noise to add to simulation result.  If 0 or Null, no noise is added.",
			Category->"Hidden"
		},
		{
			OptionName->Vectorized,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			Description->"Use vectorized problem formulation.",
			Category->"Hidden"
		},
		{
			OptionName->Jacobian,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			Description->"If True, use Jacobian for solving.",
			ResolutionDescription->"If Automatic and Injections is an empty set, Jacobian is True, otherwise False.",
			Category->"Hidden"
		},
		OutputOption,
		UploadOption
	}
];



(* ::Subsubsection:: *)
(*SimulateKinetics*)

Error::InvalidOptionLength = "The option `1` should be a list of length `2`.  The resolved value is `3`.";
Warning::FailedToComplete = "Simulation failed to run to specified \"simulationDuration\" completion time.  Try increasing AccuracyGoal and PrecisionGoal, and decreasing MaxStepFraction.";
Warning::NegativeConcentration = "Simulation produced negative concentrations which indicates an inaccurate result.  Try increasing AccuracyGoal and PrecisionGoal, and decreasing MaxStepFraction.";
Error::IncompleteModel = "The reaction model contains unresolvable non-numeric rates and the simulation cannot be run.";
Error::InconsistentInitialConditionUnits = "Initial condition `1` has units incompatible with an initial condition.";
Warning::BadObservableSpecies = "Selected observable species `1` is invalid, so defaulting to `2` as observable species.";
Warning::InitialConditionPadding = "Padding non-species-specific initial conditions `1` with zeros to `2` so it matches the number of model species `3`.";

modelSimulateKineticsP = Alternatives[
	ObjectP[Model[ReactionMechanism]],
	ObjectP[Object[Simulation,ReactionMechanism]],
	_ReactionMechanism,
	{ImplicitReactionP...},
	ImplicitReactionP,
	{_SparseArray,_SparseArray,_List,_List},
	ListableP[KineticsEquationP]
];
initialConditionSimulateKinecticsP = _State|{InitialConditionP..}|{_?NumericQ..}|ListableP[InitialConditionListP]|
	ListableP[{Rule[_,_Quantity]..}];
InitialConditionListP = {_?StringQ, _?ConcentrationQ};


(* given only initial conditions, find mechanisms first *)
SimulateKinetics[inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], simTime:(_?NumericQ|_?TimeQ), ops:OptionsPattern[]]:= Module[
	{reactionModels, listedOptions, noOutputOptions, newOutputOptions},
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the SimulateReactivity function because want the preview to get reaction mechanisms *)
	noOutputOptions = DeleteCases[listedOptions, {Upload->_, Output->_} ];

	newOutputOptions = Append[noOutputOptions, {Upload->False, Output->Result}];
	reactionModels =  Map[Lookup[SimulateReactivity[#, PassOptions[SimulateKinetics, SimulateReactivity, newOutputOptions]], ReactionMechanism, $Failed] &,
		ToList[inputInitialConditions]
	];
	SimulateKinetics[reactionModels,inputInitialConditions,simTime,ops]
];


(* single and multiple wells *)
SimulateKinetics[inputMechanism:modelSimulateKineticsP, inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], inputSimTime:(_?NumericQ|_?TimeQ), ops:OptionsPattern[]]:= Catch[
	Module[
		{startFields, listedOptions, initialConsList, inModel, simTime, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests, resolvedOpsSets,combinedOptions, coreFields, reactionModel, initialStates, tspec, allSpecs, optionsRule, previewRule, testsRule, resultRule, resolvedOptions, resolvedOptionsTests, resolvedOptionsResult, unresolvedOptions, templateTests, modelRateTest, tempTests},

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
			SafeOptions[SimulateKinetics,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
			{SafeOptions[SimulateKinetics,listedOptions,AutoCorrect->False],{}}
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

		(* Get reaction if input is an object *)
		inModel = Switch[inputMechanism,
			ObjectP[{Model[ReactionMechanism],Object[Simulation, ReactionMechanism]}],
				inputMechanism[ReactionMechanism],
			KineticsEquationP,
				{inputMechanism},
			{KineticsEquationP..},
				inputMechanism,
			_,
				inputMechanism
		];

		initialConsList = Which[
			MatchQ[inputInitialConditions, InitialConditionListP], {{ Rule @@ inputInitialConditions }},
			MatchQ[inputInitialConditions, {InitialConditionListP..}], {Rule @@ # & /@ inputInitialConditions },
			MatchQ[inputInitialConditions, {{InitialConditionP..}..}], inputInitialConditions,
			MatchQ[inputInitialConditions,initialConditionSimulateKinecticsP], {inputInitialConditions},
			True, inputInitialConditions
		];

		(* Check if inputSimTime is missing units and if so use seconds *)
		simTime = If[NumericQ[inputSimTime],
			Quantity[inputSimTime, "Seconds"],
			inputSimTime
		];

		(* Call ValidInputLengthsQ to make sure all options are the right length *)
		(* Silence the missing option errors *)
		{validLengths,validLengthTests} = Quiet[
			If[gatherTests,
				ValidInputLengthsQ[SimulateKinetics,{inModel,inputInitialConditions,simTime},listedOptions,Output->{Result,Tests}],
				{ValidInputLengthsQ[SimulateKinetics,{inModel,inputInitialConditions,simTime},listedOptions],{}}
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
			ApplyTemplateOptions[SimulateKinetics,{inputMechanism,inputInitialConditions,simTime},listedOptions,Output->{Result,Tests}],
			{ApplyTemplateOptions[SimulateKinetics,{inputMechanism,inputInitialConditions,simTime},listedOptions],{}}
		];
		combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

		(*
			INPUT AND OPTION RESOLUTION -- #1
			* fill out the species list
			* fill out the initial state
			* fill out the reaction mechanism
			* put units on everything
			The results here go into the object
		*)

		(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
		(* resolve inputs, options sets for each input, and tests together--if we have a good set of options sets, use first one for function *)
		resolvedOptionsResult = Check[
			{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
				{{{reactionModel, initialStates, allSpecs, tspec}, resolvedOpsSets}, tempTests}=
				resolveInputsAndOptionsSimulateKinetics[inModel,initialConsList,simTime,combinedOptions, listedOptions, Output->{Result,Tests}];

				{If[MatchQ[First[resolvedOpsSets],_List],resolvedOpsSets[[1]],resolvedOpsSets], tempTests},

				(* Else *)
				{{reactionModel, initialStates, allSpecs, tspec}, resolvedOpsSets}=
				resolveInputsAndOptionsSimulateKinetics[inModel,initialConsList,simTime,combinedOptions, listedOptions];

				Quiet[{If[MatchQ[First[resolvedOpsSets],_List],resolvedOpsSets[[1]],resolvedOpsSets],{}}, {First::normal}]
			],
			Return[$Failed],
			{Error::InvalidInput,Error::InvalidOption}
		];

		(* add rates to mechanism if not already there so we can test for complete model *)
		modelRateTest = If[!MatchQ[reactionModel,ListableP[ReactionMechanismP]],
			{},
			modelRatesTestOrEmpty[reactionModel, gatherTests, "Mechanism model is fully specified:", !MemberQ[Flatten[(reactionModel/.Temperature->300.)[Rates]],Except[_?NumericQ|_Quantity|NucleicAcidReactionTypeP]]]
		];

		(* Print["reactionModel: ",reactionModel];
		Print["initialStates: ",initialStates];
		Print["allSpecs: ",allSpecs];
		Print["tspec: ",tspec]; *)


				(*
					INTERNAL INPUT AND OPTION RESOLUTION -- #2
					{reactionModel, initialStates, allSpecs} are all in their full form with original species,
					ready to be saved in the object.

					But for simulation, we need slightly different versions of these
					* make list of rules to transform species into symbols (because NDSolve only handles _Symbol variables)
					* swap those new species into reactions, initialStates, and species list
					* transform reactions into equations
				*)



		If[MemberQ[output,Preview] || MemberQ[output,Result],
			(* Check actual initial states and reactionModel model and if not there set core to failed--use specified temp if provided *)
			coreFields = If[MemberQ[resolvedOpsSets,$Failed] || MatchQ[initialStates,$Failed] || !MatchQ[reactionModel,ListableP[ReactionMechanismP]|{KineticsEquationP..}],
				$Failed,
				MapThread[
					simulateKineticsCore[reactionModel, #1, allSpecs, tspec, Lookup[listedOptions, Temperature, False], #2]&,
					{initialStates, resolvedOpsSets}
				]
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
					(* Get all the trajectories *)
					preview = Flatten[Trajectory /. # & /@coreFields];
					If[!MatchQ[preview,{TrajectoryP..}],
						$Failed,
						Zoomable[PlotTrajectory[preview]]
					]
				]
			],
			Null
		];

		(* Prepare the Test result if we were asked to do so *)
		testsRule = Tests->If[MemberQ[output,Tests],
			(* Join all exisiting tests generated by helper functions with any additional tests *)
			Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests],ToList[modelRateTest]]],
			Null
		];

		(* Prepare the standard result if we were asked for it and we can safely do so *)
		resultRule = Result->If[MemberQ[output,Result],
			If[MatchQ[resolvedOptionsResult,$Failed] || MemberQ[resolvedOpsSets,$Failed] || MatchQ[coreFields,$Failed],
				$Failed,
				Module[{result, endFields, packetLists, outList},
					(* Make Object-specific fields for packet *)
					endFields = Map[simulationPacketStandardFieldsFinish[#]&, resolvedOpsSets];

					packetLists = MapThread[
						formatOutputSimulateKinetics[startFields, #1, #2, #3]&,
						{endFields,coreFields,resolvedOpsSets}
					];

					(* If not uploading, just output the packetLists *)
					If[Lookup[resolvedOptions, Upload],
						outList = Map[uploadAndReturn[#]&, packetLists];
						result = MapThread[smartReturn[#1, Lookup[#2, {NumberOfTrajectories, Method}]] &,
						 	{outList, resolvedOpsSets}
						];
						(* For single set of initial conditions, output just the first object unless failed *)
						If[MatchQ[inputInitialConditions,initialConditionSimulateKinecticsP] && MatchQ[result,_List],
							First[result],
							result
						],

						(* For single set of initial conditions, output just the first packet unless failed flatten packets so they behave like objects *)
						If[MatchQ[packetLists,_List] && Length[Flatten[packetLists]]==1,
							First[Flatten[packetLists]],
							If[MatchQ[packetLists,_List],
								Flatten[packetLists],
								packetLists
							]
						]
					]
				]
			],
			Null
		];

		outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
	]
];



(* ::Subsubsection::Closed:: *)

(* ::Subsubsection:: *)
(*ValidSimulateKineticsQ*)

DefineOptions[ValidSimulateKineticsQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateKinetics}
];

Authors[ValidSimulateKineticsQ] := {"brad"};

(* Without model, make it first and then check *)
ValidSimulateKineticsQ[inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], simTime:(_?NumericQ|_?TimeQ), ops:OptionsPattern[]]:= Module[
	{reactionModels, listedOptions, noOutputOptions, newOutputOptions},
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the SimulateReactivity function because want the preview to get reaction mechanisms *)
	noOutputOptions = DeleteCases[listedOptions, {Upload->_, Output->_} ];

	newOutputOptions = Append[noOutputOptions, {Upload->False, Output->Result}];
	reactionModels =  Map[SimulateReactivity[#, PassOptions[SimulateKinetics, SimulateReactivity, newOutputOptions]][ReactionMechanism] &,
		ToList[inputInitialConditions]
	];

	ValidSimulateKineticsQ[reactionModels,inputInitialConditions,simTime,ops]
];


ValidSimulateKineticsQ[inputMechanism:modelSimulateKineticsP, inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], simTime:(_?NumericQ|_?TimeQ), myOptions:OptionsPattern[ValidSimulateKineticsQ]]:=Module[
	{listedInput, listedOptions, inputObjects, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = {inputMechanism,inputInitialConditions,simTime};
	inputObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output -> Tests}];

	(* Call the function to get a list of tests *)
	functionTests = SimulateKinetics[inputMechanism,inputInitialConditions,simTime,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[!MatchQ[functionTests,$Failed],
		functionTests,

		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[inputObjects,OutputFormat->Boolean];

			voqWarnings = If[!MatchQ[inputObjects, {}],
				MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{inputObjects,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[{initialTest},functionTests,voqWarnings]
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidSimulateKineticsQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidSimulateKineticsQ"]
];


(* ::Subsubsection:: *)
(*SimulateKineticsOptions*)

Authors[SimulateKineticsOptions] := {"brad"};

SimulateKineticsOptions[inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], simTime:(_?NumericQ|_?TimeQ), ops : OptionsPattern[SimulateKinetics]] := Module[{listedOptions, noOutputOptions},
	listedOptions = ToList[ops];
	noOutputOptions = DeleteCases[listedOptions, Output -> _ ];
	SimulateKinetics[inputInitialConditions, simTime, Sequence@@Append[noOutputOptions, Output->Options]]
];

SimulateKineticsOptions[inputMechanism:modelSimulateKineticsP, inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], simTime:(_?NumericQ|_?TimeQ), ops : OptionsPattern[SimulateKinetics]] := Module[{listedOptions, noOutputOptions},
	listedOptions = ToList[ops];
	noOutputOptions = DeleteCases[listedOptions, Output -> _ ];
	SimulateKinetics[inputMechanism, inputInitialConditions, simTime, Sequence@@Append[noOutputOptions, Output->Options]]
];


(* ::Subsubsection:: *)
(*SimulateKineticsPreview*)

Authors[SimulateKineticsPreview] := {"brad"};

SimulateKineticsPreview[inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], simTime:(_?NumericQ|_?TimeQ), ops : OptionsPattern[SimulateKinetics]] := Module[
	{listedOptions, noOutputOptions},
	
	listedOptions = ToList[ops];
	noOutputOptions = DeleteCases[listedOptions, Output -> _ ];
	SimulateKinetics[inputInitialConditions, simTime, Sequence@@Append[noOutputOptions, Output->Preview]]
];

SimulateKineticsPreview[inputMechanism:modelSimulateKineticsP, inputInitialConditions:ListableP[initialConditionSimulateKinecticsP], simTime:(_?NumericQ|_?TimeQ), ops : OptionsPattern[SimulateKinetics]] := Module[
	{listedOptions, noOutputOptions},
	
	listedOptions = ToList[ops];
	noOutputOptions = DeleteCases[listedOptions, Output -> _ ];
	SimulateKinetics[inputMechanism, inputInitialConditions, simTime, Sequence@@Append[noOutputOptions, Output->Preview]]
];


(* ::Subsubsection:: *)
(*simulateKineticsCore*)


simulateKineticsCore[reactionModel_, initialState_, allSpecies_, {tspan_,timeUnit_,tFinal_}, rerate_, resolvedOps_]:= Module[

	{ icUnit, volUnit, temperatureFunction, trajs, opsWithoutUnits, tempProfiles, volProfiles, finalStates, injFinal, volumeExpression, debug=False, getReactionRates, kineticsEquationsSets},

	icUnit = initialState["Unit"];
	volUnit = Lookup[LegacySLL`Private`typeUnits[Object[Simulation,Kinetics]],InitialVolume];
	temperatureFunction = Lookup[resolvedOps,Temperature];


	(* remove units for computation *)
	opsWithoutUnits = ReplaceRule[resolvedOps,
		{
			Volume -> Unitless[Lookup[resolvedOps, Volume], Liter],
			Injections -> Map[stripInjectionUnits[#]&,Lookup[resolvedOps,Injections],{1}]
		}
	];




	(* compute trajectory *)
	{trajs, kineticsEquationsSets} = Transpose[Table[
		kineticTrajectoryCore[reactionModel,initialState,tspan,allSpecies,opsWithoutUnits],
		Replace[Lookup[opsWithoutUnits,NumberOfTrajectories],Null->1]
	]];

	(* apply temperature function to the times in the trajectory to create the temperature profile *)
	tempProfiles = Map[With[{times=#[Time]},
		Transpose[{times,Convert[temperatureFunction/@times,Kelvin,Celsius]}]
		]&,
		trajs
	];

	volumeExpression = constructVolumeExpression[Lookup[opsWithoutUnits,Injections],First[tspan],Lookup[opsWithoutUnits,Volume]];
	volProfiles = Map[constructVolumeProfile[volumeExpression,#,volUnit]&,trajs];

	finalStates = Map[ToState[Thread[Rule[#[Species],TrajectoryRegression[#,End]]]]&,trajs];

	(* this one is converted to different unitless form, so do not use this for anything except putting into the packet *)
	injFinal = Map[formatOneInjectionForPacket[#]&,Lookup[opsWithoutUnits,Injections]];

	MapThread[
		Function[{traj,volProf,tempProf,finState,kinEqns},
			{
				Append[Species] -> allSpecies,
				Trajectory->traj,
				InitialState->initialState,
				FinalState->finState,
				Temperature->If[$VersionNumber >= 12.0,
					UnitConvert[N[temperatureFunction[tspan[[2]]]]*Kelvin,"DegreesCelsius"],
					UnitConvert[N[temperatureFunction[tspan[[2]]]]*Kelvin,"Celsius"]
				],
				TemperatureFunction -> temperatureFunction,
				TemperatureProfile->QuantityArray[tempProf,{Second,Celsius}],
				ReactionMechanism -> If[MatchQ[reactionModel,_ReactionMechanism],reactionModel,Null],
				SimulationTime -> N[If[NumericQ[tFinal],tFinal*timeUnit,tFinal]],
				InitialVolume -> If[MatchQ[#,Null],Null,Convert[#*Liter,volUnit]]&[(Volume/.opsWithoutUnits)],
				VolumeProfile -> QuantityArray[volProf,{Second,volUnit}],
				Append[Injections] -> Replace[injFinal,{}->{{Null,Null,Null,Null,Null}}],
				Append[ObservedSpecies]->(ObservedSpecies/.opsWithoutUnits),
				Replace[KineticsEquations] -> kinEqns
			}
		],
		{trajs,volProfiles,tempProfiles,finalStates,kineticsEquationsSets}
	]

];


constructVolumeProfile[volumeExpression_,traj_,volUnit_]:= Module[
	{volProfile},

	(* evaluated expression at time points *)
	volProfile = If[MatchQ[volumeExpression,Null],Null,Table[{t,volumeExpression},{t,traj[Time]}]];

	(* deal with unit scaling *)
	If[MatchQ[volProfile,Null],Null,With[{vscale=Convert[1,Liter,volUnit]},MapAt[vscale*#&,volProfile,{;;,2}]]]

];


removeReactionRates[Reaction[reactants_, products_, r:Except[0|0.]]] := Reaction[reactants, products, ClassifyReaction[reactants, products]];
removeReactionRates[Reaction[reactants_, products_, r1:Except[0|0.], r2:Except[0|0.]]] := Reaction[reactants, products, ClassifyReaction[reactants, products], ClassifyReaction[products, reactants]];
removeReactionRates[r_Reaction]:=r;


(* ::Subsection:: *)
(*Resolution*)

(* ::Subsubsection:: *)
(*resolveInputsAndOptionsSimulateKinetics*)

DefineOptions[resolveInputsAndOptionsSimulateKinetics,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveInputsAndOptionsSimulateKinetics[inputMechanism_,inputIC_,simTime_,unresolvedOps_List, inputOptions_List, ops:OptionsPattern[]]:=Module[
	{
		output, listedOutput, collectTestsBoolean, result, icSpecs, numIC, allSpecs, numSpecies, reactionModel, initialStates, initialConditions, tSpecs, tspan, tunit, resolvedOpsSets, resolvedOptionsTests, tfNum, t0Num, numWells, stateUnits, su, allWells, failOut=Table[$Failed,{4}], initialStateTests, verbose=False, timeSymbol, tempFunc0,
		getReactionRates, rerate
	},

	(* From resolveSimulateKineticsOptions's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];

	listedOutput = ToList[output];

	collectTestsBoolean = MemberQ[listedOutput,Tests];

	(* get a list of all species across all initial conditions *)
	icSpecs = DeleteDuplicates[Flatten[SpeciesList[#,Sort->False,Structures->True]& /@ inputIC,1]];

	(* get list of all species, from either mechanism or initial conditions *)
	allSpecs = SpeciesList[inputMechanism,icSpecs,Sort->False,Structures->True];

	(* For all numeric ics, pad with zeros to length of all species and print warning message *)
	initialConditions = If[MatchQ[inputIC, ListableP[_?NumericQ, 2]],
		numIC = Length[Flatten[inputIC]];
		numSpecies = Length[allSpecs];
		If[numIC != numSpecies,
			Message[Warning::InitialConditionPadding, Flatten[inputIC], Flatten[{Join[Flatten[inputIC], Table[0, {numSpecies - numIC}]]}], allSpecs];
			{Join[Flatten[inputIC], Table[0, {numSpecies - numIC}]]},
			inputIC
		],
		inputIC
	];

	initialConditions = MapAt[
		If[MatchQ[inputMechanism,{KineticsEquationP..}],
			#,
			If[NumericQ[#],
				Quantity[#,"Molar"],
				(* Convert[#,Molar] *)
				#
			]
		]&,
		If[MatchQ[initialConditions,{_State..}],#[Rules]&/@initialConditions,initialConditions],
		{;;,;;,If[MatchQ[initialConditions[[1,1]],_Rule]||MatchQ[initialConditions,{_State..}],2,Nothing]}
	];

	(* format all ICs as states with full species list *)
	initialStates = ToState[#,allSpecs]& /@ initialConditions  /.s_Strand:>flattenDegenerate[s]/.  s_Structure :> StructureSort[NucleicAcids`Private`consolidateBonds[s]];
	stateUnits = #[Units]& /@ initialStates;

	su = Quiet[#["Unit"]&/@initialStates,{Quantity::compat, Max::nord2}];
	(* add Units if necessary, or complain about them *)
	initialStateTests = Quiet[Check[
									MapThread[inconsistentInitialConditionUnitsTestOrEmpty[#1,collectTestsBoolean,"Consistent initial state units:",CompatibleUnitQ[#2]] &, {initialStates, stateUnits}],
									$Failed,
									{Error::InvalidInput, Error::InvalidOption}
									], {Quantity::compat, Max::nord2}];

	initialStates = MapThread[
		Which[
			Not[CompatibleUnitQ[#2]],$Failed,
			True, #1
		]&, {initialStates, stateUnits, su}
	];

	t0Num = 0.0;
	{tfNum, tunit} = Switch[simTime,
		_?NumericQ, {simTime, Second},
		TimeP, {Unitless[simTime,Second], Units[simTime]}
	];

	(* resolve all the options *)
	{resolvedOpsSets,resolvedOptionsTests} = If[MatchQ[initialStates,$Failed],
		{$Failed,{}},
		If[collectTestsBoolean,
			resolveOptionsSimulateKinetics[unresolvedOps,initialStates,allSpecs,inputMechanism,PassOptions[resolveInputsAndOptionsSimulateKinetics,resolveOptionsSimulateKinetics,Output->{Result,Tests}]],
			{resolveOptionsSimulateKinetics[unresolvedOps,initialStates,allSpecs,inputMechanism,PassOptions[resolveInputsAndOptionsSimulateKinetics,resolveOptionsSimulateKinetics]],{}}
		]
	];

	If[!MatchQ[resolvedOpsSets,{}] && !MemberQ[resolvedOpsSets,$Failed],
		Module[{},
		(* make sure all species represented by reactions *)
		reactionModel = If[MatchQ[inputMechanism,{KineticsEquationP..}],
			NucleicAcids`Private`addInitialConditionReactions[inputMechanism,allSpecs],
			ToReactionMechanism[inputMechanism,allSpecs]
		];

			rerate = Lookup[inputOptions, Temperature, False];
			getReactionRates[model_ReactionMechanism]:= model[Rates];
			getReactionRates[_]:={};

			(* if any non-numeric rates left, error and exit *)
			If[MemberQ[Flatten[getReactionRates[reactionModel]],Except[_?NumericQ|_Quantity|NucleicAcidReactionTypeP]],
				Message[Error::IncompleteModel];
				Message[Error::InvalidInput,reactionModel];
				Return[Join[{failOut},{{$Failed}}]]
			];

			If[!MatchQ[rerate, False], reactionModel = reactionModel /. x_Reaction :> removeReactionRates[x]];

			tempFunc0 = First[Lookup[resolvedOpsSets,Temperature],Null];
			If[Not[MatchQ[reactionModel,{KineticsEquationP..}]],
			reactionModel = SimulateReactivity[reactionModel,Temperature->tempFunc0, Upload->False, Output->Result][ReactionMechanism];
			];

			(* if any non-numeric rates left, error and exit *)
			If[MemberQ[Flatten[getReactionRates[reactionModel]],Except[_?NumericQ|_Quantity,_Symbol|_String]],
				Message[Error::IncompleteModel];
				Message[Error::InvalidInput,reactionModel];
				Return[$Join[{failOut},{{$Failed}}]]
			];

		timeSymbol = Which[
		MatchQ[inputMechanism,{KineticsEquationP..}],
			NucleicAcids`Private`kineticsEquationsTimeSymbol[inputMechanism],
		And[Head[tempFunc0]===Function ,Head[First[tempFunc0]]===List],
			First[First[tempFunc0]],
		And[Head[tempFunc0]===Function ,Head[First[tempFunc0]]===Symbol],
			First[tempFunc0],
		Head[tempFunc0]===Integer,
			t,
		True,
			t
	];
]];

	result = If[MemberQ[listedOutput,Result],
		If[MatchQ[resolvedOpsSets,{}] || MemberQ[resolvedOpsSets,$Failed],
			Join[{failOut},{{$Failed}}],
			Module[{newInputs},

				newInputs = {
					reactionModel,
					initialStates,
					allSpecs,
					{{timeSymbol, t0Num, tfNum},tunit,tfNum*tunit}
				};

				Join[{newInputs},{resolvedOpsSets}]
			]
		],
		Null
	];

	output/.{Tests->Flatten[Join[{initialStateTests},{resolvedOptionsTests}]],Result->result}
];



(* ::Subsubsection::Closed:: *)
(*incorrectOptionLengthTestOrEmpty*)

incorrectOptionLengthTestOrEmpty[targetLength_Integer, optVal_, optName_ ,makeTest:BooleanP, description_, expression_]:=
If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::InvalidOptionLength,optName,targetLength,optVal];
		Message[Error::InvalidOption,optVal];
	]
];



(* ::Subsubsection::Closed:: *)
(*modelRatesTestOrEmpty*)

modelRatesTestOrEmpty[struct_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::IncompleteModel];
		Message[Error::InvalidInput,struct];
	]
];



(* ::Subsubsection::Closed:: *)
(*inconsistentInitialConditionUnitsTestOrEmpty*)

inconsistentInitialConditionUnitsTestOrEmpty[struct_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		{},
		Message[Error::InconsistentInitialConditionUnits,struct];
		Message[Error::InvalidInput,struct];
	]
];



(* ::Subsubsection:: *)
(*resolveOptionsSimulateKinetics*)

DefineOptions[resolveOptionsSimulateKinetics,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveOptionsSimulateKinetics[unresolvedOps_List, initialStates_List, allSpecies_, inputModel_, ops:OptionsPattern[]]:=Module[
	{
		output, listedOutput, collectTestsBoolean, resolvedOptions, allTests, numWells, injections,volumes, jacobian, method, noise, temp, obsSpecs, wells, accGoal, precGoals, maxStepFrac,  verbose=False, vectorized
	},

	vectorized = Lookup[unresolvedOps,Vectorized] /. Automatic -> Not[MatchQ[inputModel,{KineticsEquationP..}]];

	(* From resolveSimulateKineticsOptions's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	(* Gather all the tests (this will be a list of Nulls if !Output->Test) *)
	allTests = {};

	noise = resolveKineticSimulationNoiseOption[Noise/.unresolvedOps, First[initialStates]];

	temp = resolveKineticSimulationTemperatureOption[Temperature/.unresolvedOps];

	(*
		These options can be lists, and must match number of wells in size.
		Number of wells is determined by the number of initial states
	*)
	numWells = Length[initialStates];

	(* check length and pad, then resolve each value *)
	injections = With[{injs=Lookup[unresolvedOps,Injections]},
		Switch[injs,
			(InjectionsFormatP | {}), Table[injs,{numWells}],
			_,	injs
		]
	];

	allTests = Append[allTests, incorrectOptionLengthTestOrEmpty[numWells,injections,Injections,collectTestsBoolean,"Number of injections matches number of wells:",Length[injections]==numWells]];
	injections = If[!MatchQ[Length[injections],numWells],
		$Failed,
		MapThread[
			resolveKineticSimulationInjection[#2,allSpecies,#1,Volume/.unresolvedOps]&,
			{initialStates,injections}
		]
	];

	(* check length and pad, then resolve each value *)
	volumes = With[{vs=Lookup[unresolvedOps,Volume]},
		Switch[vs,
			_List, vs,
			_,	Table[vs,{numWells}]
		]
	];

	allTests = Append[allTests, incorrectOptionLengthTestOrEmpty[numWells,volumes,Volume,collectTestsBoolean,"Number of volumes matches number of wells:",Length[volumes]==numWells]];
	volumes = If[!MatchQ[Length[volumes],numWells] || MatchQ[injections,$Failed],
		$Failed,
		MapThread[
			resolveKineticSimulationVolumeOption[#1,#2]&,
			{volumes,injections}
		]
	];

	(* check length and pad, then resolve each value *)
	wells = Take[wells96,numWells];


	(* check length and pad, then resolve each value *)
	obsSpecs = With[{obs=Lookup[unresolvedOps,ObservedSpecies]},
		Switch[obs,
			All, Table[obs,{numWells}],
			{{SpeciesP..}..}_,	obs,
			{SpeciesP..}, Table[obs,{numWells}]
		]
	];

	allTests = Append[allTests, incorrectOptionLengthTestOrEmpty[numWells,obsSpecs,ObservedSpecies,collectTestsBoolean,"Number of observed species matches number of wells:",Length[obsSpecs]==numWells]];
	obsSpecs = If[!MatchQ[Length[obsSpecs],numWells],
		$Failed,
		Map[
			resolveKineticSimulationObservedSpecies[#,allSpecies]&,
			obsSpecs
		]
	] /.s_Strand:>flattenDegenerate[s]/.  s_Structure :> StructureSort[NucleicAcids`Private`consolidateBonds[s]] ;

	jacobian = Switch[Lookup[unresolvedOps,Jacobian],
		Automatic, If[MatchQ[Flatten[injections],{}], True, False],
		_, Lookup[unresolvedOps,Jacobian]
	];

	precGoals = Map[resolveKineticSimulationPrecisionGoal[Lookup[unresolvedOps,PrecisionGoal],#]&,initialStates];

	resolvedOptions = If[MemberQ[Flatten[{injections, volumes, obsSpecs, precGoals, wells}],$Failed],
		{$Failed},
		MapThread[Function[{inj,vol,os,pg,well},
			ReplaceRule[unresolvedOps,
				{
					Volume -> vol,
					Noise -> noise,
					Temperature -> temp,
					ObservedSpecies -> os,
					Injections -> inj,
					PrecisionGoal->pg,
					Jacobian->jacobian,
					Vectorized -> vectorized
				}
			]],
			{
				injections,
				volumes,
				obsSpecs,
				precGoals,
				wells
			}
		]
	];

	output/.{Tests->allTests,Result->resolvedOptions}
];


wells96 := wells96 = Flatten[AllWells[96, InputFormat -> Index, OutputFormat -> Position]];

resolveKineticSimulationPrecisionGoal[val:Automatic,x0_]:=Module[{nonzeroinit,scale},
	nonzeroinit = Select[Unitless[x0[Quantities]],#>0&];
	If[nonzeroinit==={},
		6,
		Max[{
			Log10[Max[nonzeroinit]/Min[nonzeroinit]]+3,
			8
			}]
		]
];
resolveKineticSimulationPrecisionGoal[val_,x0_]:=val;

(*
	Resolve to a unitless distribution
*)
resolveKineticSimulationNoiseOption[noiseOption_,st_State]:=Switch[noiseOption,
	Null|0|0.|0Percent|0.Percent, (* no noise *)
		Null,
	_Quantity?PercentQ,
		NormalDistribution[0,Convert[noiseOption,1]*Max[Unitless[st[Quantities]]]],
	NumericP,
		NormalDistribution[0,noiseOption],
	ConcentrationP,
		NormalDistribution[0,Unitless[noiseOption]],
	_?DistributionParameterQ,
		noiseOption,
	_,
		Message[]
];
addNoise[traj_Trajectory,Null]:=traj;
addNoise[traj_Trajectory,noiseDistribution_]:=With[{concs=traj[[2]]},
	ReplacePart[traj,2 -> concs+RandomVariate[noiseDistribution,Dimensions[concs]]]
];


resolveKineticSimulationObservedSpecies[All|Null|Automatic,speclist_]:=speclist;
resolveKineticSimulationObservedSpecies[labeled_List,speclist_]:=labeled/;MatchQ[Complement[labeled,speclist],{}];
resolveKineticSimulationObservedSpecies[single_,speclist_]:={single}/;MemberQ[speclist,single,{}];
resolveKineticSimulationObservedSpecies[bad_,speclist_]:=(
	Message[Warning::BadObservableSpecies,bad,speclist];
	speclist
);


defaultSimulationVolumeUnit = Lookup[LegacySLL`Private`typeUnits[Object[Simulation,Kinetics]],InitialVolume];


resolveKineticSimulationVolumeOption[volume_,injections_]:=Switch[volume,
	Null, Null,
(*	VolumeP, Unitless[volume,defaultSimulationVolumeUnit],*)
	VolumeP, volume,
	NumericP, volume*Liter,
	_, Message[]
];


resolveKineticSimulationTemperatureOption[tempOption_]:=Switch[tempOption,
	TemperatureP,
		With[{ktemp=QuantityMagnitude[UnitConvert[tempOption,"Kelvins"]]},
			ktemp&
		],
	_Function,
		tempOption,
	_,
		(
			Message[];
			$Failed
		)
];


resolveKineticSimulationInjection[injections_List,specList_List,initialState_State,volume_]:=Module[{},
	Map[resolveKineticSimulationSingleInjection[#,specList,initialState,volume]&,injections]
];


(* FAST injection, add a Null placeholder for flow rate *)
resolveKineticSimulationSingleInjection[injection:{startTime:TimeP,spec_,injectionVolume:VolumeP,injectionConcentration:ConcentrationP},specList_List,initialState_State,volume_]:=
	resolveKineticSimulationSingleInjection[{startTime,spec,injectionVolume,Null,injectionConcentration},specList,initialState,volume];

resolveKineticSimulationSingleInjection[injection:{startTime:TimeP,spec_,injectionVolume:VolumeP,injectionFlowRate:(FlowRateP|Null),injectionConcentration:ConcentrationP},specList_List,initialState_State,volume_]:=Module[{},
	{
		startTime,
		spec,
		injectionVolume,
		If[MatchQ[injectionFlowRate,Null],Null,injectionFlowRate],
		injectionConcentration
	}
];


stripInjectionUnits[inj:{startTime:TimeP,spec_,vol:VolumeP,conc:ConcentrationP}]:={
	Unitless[startTime,Second],
	spec,
	Unitless[vol,Liter],
	Null,
	Unitless[conc,Molar]
};
stripInjectionUnits[inj:{startTime:TimeP,spec_,vol:VolumeP,flowRate_,conc:ConcentrationP}]:={
	Unitless[startTime,Second],
	spec,
	Unitless[vol,Liter],
	Unitless[flowRate,Liter/Second],
	Unitless[conc,Molar]
};


(* ::Subsection::Closed:: *)
(*Formatting packet*)


(* ::Subsubsection::Closed:: *)
(*formatOutputSimulateKinetics*)


formatOutputSimulateKinetics[startFields_,endFields_,coreFields:$Failed,resolvedOps_]:= $Failed;
formatOutputSimulateKinetics[startFields_,endFields_,coreFields_,resolvedOps_]:=Module[
	{simPackets,out},
	simPackets = Map[Association[Join[{Type -> Object[Simulation, Kinetics]},
		startFields,
		#,
		{Method -> (Method /. resolvedOps)},
		endFields
	]]&, coreFields]
];


(* ::Subsubsection::Closed:: *)
(*smartReturn*)


smartReturn[$Failed, _] := $Failed;
smartReturn[out_, {Null, _}] := First[out];
smartReturn[out_, {_, Except[Stochastic]}] := First[out];
smartReturn[out_, {_, Stochastic}]:= out;


(* ::Subsubsection::Closed:: *)
(*formatOneInjectionForPacket*)


formatOneInjectionForPacket[{t0_,spec_,vol_,fr_,c0_}]:={
	Convert[t0,Second,Minute] * Minute,
	spec,
	Convert[vol,Liter,Microliter] * Microliter,
	If[MatchQ[fr,Null],Null,Convert[fr,Liter/Second,Microliter/Second]],
	Convert[c0,Molar,Micromolar] * Micromolar
};
formatOneInjectionForPacket[_]:={Null,Null,Null,Null,Null};


(* ::Subsubsection::Closed:: *)
(*constructVolumeExpression*)


constructVolumeExpression[{},tvar_,initialVolume_]:= initialVolume;
constructVolumeExpression[injs:{{_,_,_,_,_}..},tvar_,Null]:= Null;
constructVolumeExpression[injs:{{_,_,_,_,_}..},tvar_,initialVolume_]:=Module[{},
	PiecewiseExpand[initialVolume+Total[Map[injectionToPiecewiseVolume[#,tvar]&,Reverse[SortBy[injs,First]]]]]
];
injectionToPiecewiseVolume[inj:{t1_,spec_,vol_,flowRate:Null,conc_},tvar_]:=Piecewise[{{vol,tvar>=t1}},0];
injectionToPiecewiseVolume[inj:{t1_,spec_,vol_,flowRate_?NumericQ,conc_},tvar_]:=With[{t2=t1+vol/flowRate},Piecewise[{{flowRate*(tvar-t1),t1<=tvar<=t2},{vol,tvar>t2}},0]];



(* ::Subsection:: *)
(*Kinetics solving*)


(* ::Subsubsection:: *)
(*kineticTrajectoryCore*)


(* takes in only resolved inputs and resolved options *)
kineticTrajectoryCore[inputMechanism:(_ReactionMechanism|{KineticsEquationP..}),initialState_State,tspan_,allSpecies_,resolveOps_List]:=Module[{
	traj,method,volume,tempOption,injections,noisyTraj,observableTraj,volumeExpression,debug=False,mechUnitless},

	{method,volume,tempOption,injections}=Lookup[resolveOps,{Method,Volume,Temperature,Injections}];

	volumeExpression = constructVolumeExpression[injections,First[tspan],volume];

	(* strip units off rates *)
	mechUnitless = ReplaceAll[inputMechanism,{
		QuantityFunction[f_,_,_]:>f[Temperature],
		perSec:UnitsP[1/Second]:>Unitless[perSec,1/Second],
		perMolarPerSec:UnitsP[1/Molar/Second]:>Unitless[perMolarPerSec,1/Molar/Second]
	}];
		(* simulate *)
		(*
			At this point everything (volumes, injection, time span, ...) should be unitless in standard units (Second, Liter, Molar, ...)
		*)

	{traj, kineticsEquations} = Switch[method,
			Stochastic,
				stochasticReaction[mechUnitless,initialState,tspan,Lookup[resolveOps,Volume]],
			Deterministic,
				deterministicReaction[mechUnitless,initialState,tspan,tempOption,injections,volumeExpression,resolveOps],
			Analytic,
				analyticReaction[mechUnitless,initialState,allSpecies,tspan,tempOption,resolveOps]
		];

		If[MatchQ[traj,$Failed|Null],Return[traj]];

		noisyTraj = addNoise[traj,Lookup[resolveOps,Noise]];

		observableTraj = Trajectory[noisyTraj,Lookup[resolveOps,ObservedSpecies]];

	{observableTraj, kineticsEquations}

];


(* ::Subsubsection::Closed:: *)
(*analytic solution*)


analyticReaction[inputMechanism_ReactionMechanism,initialState_State,species_,tspan:{tvar_,t0_,tF_},temp_,resolvedOps_List]:=Module[
	{dt,x0,xy,analyticSol,delayedSol,tvals,debug=False},
	x0=N[initialState[Magnitudes]];
	analyticSol = Replace[species,implicitReactionTable[NucleicAcids`Private`mechanismToImplicitReactions[inputMechanism],Unitless[initialState[Rules]]],{1}];
	dt = (tF-t0)/(Lookup[resolvedOps,NumberOfPoints]-1);
	tvals = Range[t0,tF,dt];

	xy = Map[analyticSol/. {t -> #}&,tvals];

	{
		ToTrajectory[species,xy,tvals,{Second,Molar}],
		Null
	}

];


(* ::Subsubsection::Closed:: *)
(*deterministicReaction*)


deterministicReaction::BadModelFormat="Bad model format: `1`";
deterministicReaction[inputMechanism:(_ReactionMechanism|{KineticsEquationP..}), initialState_State, tspan:{t_,t0_,tF_}, tempFunc0_,injections_,volumeExpression_,resolvedOps_List] :=
	Module[{},
		Switch[Lookup[resolvedOps,Vectorized],
			True,
				deterministicReactionVectorized[inputMechanism,initialState,tspan,tempFunc0,injections,volumeExpression,resolvedOps],
			_,
				deterministicReactionNonVectorized[inputMechanism,initialState,tspan,tempFunc0,injections,volumeExpression,resolvedOps]
		]

	] ;



deterministicReactionVectorized[inputMechanism_ReactionMechanism, initialState_State, tspan:{t_,t0_,tF_}, tempFunc0_,injections_,volumeExpression_,resolvedOps_List] :=
		Module[ {
			x,x0,oldA1,oldA2,A1,A2,inds,species,t1,t2,simPacket,
			tempFunc,Bu,Bx,events,traj,debug=False, tFsim
		},
		(* get the model into the correct format *)
		t1=AbsoluteTime[];

		{oldA1,oldA2,inds,species} = stateSpaceMatrices[inputMechanism];

		If[species===Null,Return[Null]];
		t2=AbsoluteTime[];

		(* If no temperature-dependence in the system, ignore the temp function *)
		tempFunc=If[And[MatchQ[Total[Flatten[oldA2]],_?NumberQ],
			MatchQ[Total[Abs@Flatten[oldA1]],_?NumberQ]],
			Null,
			tempFunc0
		];

		 (* swap pure function into sparse matrix to save computation time later in quadOdeSimNDSolve *)
		A1 = SparseArray[ArrayRules[oldA1]/.{Temperature->tempFunc[Slot[1]]},Dimensions[oldA1]];
		A2 = SparseArray[ArrayRules[oldA2]/.{Temperature->tempFunc[Slot[1]]},Dimensions[oldA2]];

		(* get IC into correct ofrmat *)
		x0 =  species/.Rule@@@Transpose[{initialState[Species],N[QuantityMagnitude[UnitConvert[initialState[Quantities],QuantityUnit[Molar]]]]}];
		(* handle injections from App or option input, remove Units for computing *)
		{Bu,Bx,events} = injectionAndEventMatrix[injections,species,t,volumeExpression];

		simPacket = quadOdeSimNDSolve[A1,A2,inds,x0,tspan,tempFunc,Bx,Bu,events,Lookup[resolvedOps,{Jacobian,AccuracyGoal,PrecisionGoal,MaxStepFraction}]];

		traj = ToTrajectory[species,InterpolatingFunction/.simPacket,{Second,Molar}];

		(* warning message if end of interpolation function doesn't match desired final simulation time *)
		tFsim=Last[traj[Times]];
		If[
			Norm[(tFsim-tF)/tF] > 10^-6,
			Message[Warning::FailedToComplete,tFsim];
		];

		(* warning message if concentrations go negative (more than numerical noise) *)
		If[
			Min[Flatten[traj[Concentrations]]] < - 10^-4 * Norm[x0],
			Message[Warning::NegativeConcentration];
		];

		{traj, Null}

];



(* ::Subsubsection::Closed:: *)
(*quadOdeSimNDSolve*)


(*  Given model in state-space form and simulation parameters, simulate  *)
quadOdeSimNDSolve[A1_,A2_,inds_,x0_,tspan:{t_,t0_,tF_},tempFunc_,Bx0_,Bu0_,events0_,{jacOption_,accGoal_,precGoal_,maxStepFraction_}] :=
		Module[{
			sol,x,rhs,eye,jac,time1,inds1,inds2,scale,
			A1func,A2func,a1dim,a2dim,Bx,Bu,events,Bufunc,Bxfunc,
			debug=False,full=False,scaleVars=True,tt
		},
		time1 = AbsoluteTime[];

		a1dim=Dimensions[A1];
		a2dim=Dimensions[A2];

		(* get scaling and set tolerances *)
		scale = concentrationScaleValue[x0];


		Bx = SparseArray[ArrayRules[Bx0]/.{Scale->scale},{Length[x0],Length[x0]}];
		Bu = Bu0/.Scale->scale;
		events = events0 /.Scale->scale;

		{inds1,inds2} = inds;
		eye = IdentityMatrix[Length[x0],SparseArray];

		Bufunc[tv_]:=Bu/.t->tv;
		If[MatchQ[Norm[Bx],0|0.0],
			Bxfunc[tv_]:=SparseArray[{},{Length[x0],Length[x0]}],
			Bxfunc[tv_]:=SparseArray[ArrayRules[Bx]/.{t->tv}]
		];

		(* matrix functions *)
		If[ tempFunc===Null,
			(* If no temperature dependence *)
			A1func[_]:=A1;
			A2func[_]:=A2;
		,
			(* If mats are functions of temp *)
			(* For 13.2, needed to change how we generate the sparse arrays, since sparse arrays of functions would no longer
			evaluate when given a value. Instead, generate a list of rules from the array, provide whatever values for
			evaluation, then use the evaluated list of rules to generate the array. *)
			A1func[tvar_]:=With[{AR = ArrayRules[A1]}, SparseArray@Function[AR][tvar]];
			A2func[tvar_]:=With[{AR = ArrayRules[A2]}, SparseArray@Function[AR][tvar]];
		];

		(* functions for NDSolve *)
		Which[
			(* full system matrices (not reduced nonlinear terms *)
			full,
					rhs[xvar_List,tvar_] := rhsFunc[A1func[tvar].xvar +  Bxfunc[tvar].xvar + Bufunc[tvar] + A2func[tvar].KroneckerProduct[xvar,xvar]];
					jac[xvar_List,tvar_] := jacFunc[A1func[tvar] + Bxfunc[tvar] + A2func[tvar].(KroneckerProduct[eye,xvar]+KroneckerProduct[xvar,eye])];
		,
			(* Linear system *)
						(Length[inds1]+Length[inds2])==0,
			rhs[xvar_List,tvar_] :=     rhsFunc[A1func[tvar].xvar + Bxfunc[tvar].xvar + Bufunc[tvar] ];
			jac[xvar_List,tvar_] :=     jacFunc[A1func[tvar] + Bxfunc[tvar]];
		,
						(* Nonlinear system *)
			True,
						rhs[xvar_List,tvar_] :=     rhsFunc[A1func[tvar].xvar + Bxfunc[tvar].xvar + Bufunc[tvar] + (A2func[tvar]*scale).(xvar[[inds1]]*xvar[[inds2]])];
						jac[xvar_List,tvar_] :=     jacFunc[A1func[tvar] + Bxfunc[tvar] + (A2func[tvar]*scale).(eye[[inds1,;;]]*SparseArray[Flatten[xvar[[inds2]]]] + SparseArray[Flatten[xvar[[inds1]]]]*eye[[inds2,;;]])];
				];

	Off[NDSolve::nderr];
		(* Simulate *)
		sol = If[And[Max[Abs[A1]]===0,Max[Abs[A2]]===0,MatchQ[Norm[Bu[t]],0.]],
			(* If no dynamics and no injections, return initial state as interpolation function *)
			{x->Interpolation[{{t0,Transpose[{x0/scale}]},{(tF-t0)/2,Transpose[{x0/scale}]},{tF,Transpose[{x0/scale}]}},InterpolationOrder->0]}
			,
			(* call NDSolve *)
			Quiet[
				First[
					ndsolve[
						Join[{x'[t] == rhs[x[t],t] , x[tspan[[2]]]==Transpose[{x0/scale}]}, ReplaceAll[events,{X->x,Scale->scale}]],
						x,
						tspan,
						MaxStepFraction->maxStepFraction,
						AccuracyGoal->accGoal,
						PrecisionGoal->precGoal
					]
				],
				{Reduce::ratnz}
			]
		];

		(* extract solution and un-scale *)
		{
			InterpolatingFunction->scaleInterpolatingFunction[(x/.sol),scale,x0],
			Scale->scale,
			TimeElapsed->(AbsoluteTime[]-time1)
		}

];




ndsolve[args___]:=NDSolve[args];
rhsFunc[in_]:=in;
jacFunc[in_]:=in;


(* ::Subsubsection::Closed:: *)
(*injectionAndEventMatrix*)


injectionAndEventMatrix[injections_,species_,tvar_,volumeExpression_]:=Module[{injectionsScaled,Bu,Bx,events},
	injectionsScaled = If[MatchQ[injections,{}],{},MapAt[#/Scale&,injections,{;;,5}]];
	Bx = constructInjectionTermVectorBx[injectionsScaled,species,tvar,volumeExpression];
	Bu = constructInjectionTermVectorBu[injectionsScaled,species,tvar,volumeExpression];
	events = constructInjectionEvents[injectionsScaled,species,tvar,volumeExpression];
	{Bu,Bx,events}
];



(* Bx term *)
constructInjectionTermVectorBx[injs:{{_,_,_,Null,_}...},specs_List,tvar_,volumeExpression_]:= SparseArray[{},{Length[specs],Length[specs]}];
constructInjectionTermVectorBx[injs:{{_,_,_,_?NumericQ,_}..},specs_List,tvar_,volumeExpression_]:=Module[{allTerms,assoc},
	allTerms = constructInjectionTerms[injectionToConcentrationFluxBx,injs,specs,tvar,volumeExpression];
	assoc = GroupBy[Flatten[allTerms],First->Last,PiecewiseExpand[Total[#]]&];
	DiagonalMatrix[SparseArray[Lookup[assoc,specs]]]
];
injectionToConcentrationFluxBx[inj:{t1_,injSpec_,vol_,flowRate_,injConc_},otherSpec_,tvar_,volumeExpression_] := -flowRate/volumeExpression;

(* Bu term *)
constructInjectionTermVectorBu[injs:{{_,_,_,Null,_}...},specs_List,tvar_,volumeExpression_]:= Table[0.0,{Length[specs]}];
constructInjectionTermVectorBu[injs:{{_,_,_,_?NumericQ,_}..},specs_List,tvar_,volumeExpression_]:=Module[{allTerms,assoc},
	allTerms = constructInjectionTerms[injectionToConcentrationFluxBu,injs,specs,tvar,volumeExpression];
	assoc = GroupBy[Flatten[allTerms],First->Last,PiecewiseExpand[Total[#]]&];
	Transpose[{Lookup[assoc,specs]}]
];
injectionToConcentrationFluxBu[inj:{t1_,injSpec_,vol_,flowRate_,injConc_},otherSpec_,tvar_,volumeExpression_] := injConc*flowRate/volumeExpression /; SameQ[injSpec,otherSpec];
injectionToConcentrationFluxBu[inj:{t1_,injSpec_,vol_,flowRate_,injConc_},otherSpec_,tvar_,volumeExpression_] := 0.0;

(* injection expression construction *)
constructInjectionTerms[f_,injs:{{_,_,_,_,_}..},specs_List,tvar_,volumeExpression_]:=Map[constructInjectionTerms[f,#,specs,tvar,volumeExpression]&,injs];
constructInjectionTerms[f_,inj:{_,_,_,_,_},specs_List,tvar_,volumeExpression_]:=Map[constructInjectionTerm[f,inj,#,tvar,volumeExpression]&,specs];
constructInjectionTerm[f_,inj:{t1_,injSpec_,vol_,flowRate_,injConc_},spec:Except[_List],tvar_,volumeExpression_]:=With[
	{val=f[inj,spec,tvar,volumeExpression],t2=t1+vol/flowRate},
	spec -> Piecewise[{{val,t1<=tvar<=t2}},0.0]
];


(* WhenEvent equations for the injections *)
constructInjectionEvents[injs:{{_,_,_,_?NumericQ,_}...},specs_List,tvar_,volumeExpression_]:= {};
constructInjectionEvents[injs:{{_,_,_,Null,_}..},specs_List,tvar_,volumeExpression_]:= Module[{},
	Map[constructInjectionEvent[#,specs,tvar,volumeExpression]&,injs]
];
constructInjectionEvent[inj:{time_,spec_,dV_,flowRate:Null,dC_},specs_List,tvar_,volumeExpression_]:=Module[{volPlus,volMinus},
	volPlus =ReplaceAll[volumeExpression,tvar->time];
	volMinus = volPlus - dV;
	With[
(*		{concVector =Map[{computeInjectionEventConcentration[inj,#,tvar,volMinus,volPlus]}&,specs]},*)
(*		{concVector = Transpose[{Table[1.,{Length[specs]}]*X[tvar]*(volMinus/volPlus) + Map[If[SameQ[#,spec],(dV*dC/volPlus),0.0]&,specs]}]},*)
		{concVector = computeInjectionEventConcentration[X[tvar],inj,specs,tvar,volMinus,volPlus]},
		N@WhenEvent[tvar==time, X[tvar]->concVector]
	]
];

computeInjectionEventConcentration[x_List,inj:{time_,injSpec_,dV_,flowRate:Null,dC_},allSpecs_,tvar_,volMinus_,volPlus_]:= x * volMinus/volPlus + Map[List@If[SameQ[#,injSpec],(dV*dC/volPlus),0.0]&,allSpecs];

(*
computeInjectionEventConcentration[inj:{time_,injSpec_,dV_,flowRate:Null,dC_},otherSpec_,tvar_,volMinus_,volPlus_] := otherSpec[tvar]*volMinus/volPlus /; !SameQ[injSpec,otherSpec];
computeInjectionEventConcentration[inj:{time_,injSpec_,dV_,flowRate:Null,dC_},injSpec_,tvar_,volMinus_,volPlus_]:=(injSpec[tvar]*volMinus+dV*dC)/volPlus;
*)


(* ::Subsubsection::Closed:: *)
(*scaling*)


concentrationScaleValue[x0_State]:=concentrationScaleValue[Unitless[x0[Quantities],Molar]];
concentrationScaleValue[x0_]:=Min[Select[x0,#>0&]];


(* scale the input argument of an interpolating function *)
scaleInterpolatingFunction[f_InterpolatingFunction,scale_,x0_]:=Module[{x0Col,dx0Col},
	x0Col = Transpose[{x0}];
	dx0Col = 0.*x0Col;

	ReplacePart[
		f,
		{
			4->scale*f[[4]],
			3->f[[3]],
			1->f[[1]]
		}
	]
];



(* ::Subsubsection::Closed:: *)
(*stochasticReaction*)


stochasticReaction::InvalidVolume="Volume must be non-Null for stochastic simulation.";


stochasticReaction[inputMechanism_ReactionMechanism,
									 initialState_State,
									 time:{t_,tStart:(_Integer|_Rational|_Real),tEnd:(_Integer|_Rational|_Real)}, (* time range {t,start,end} *)
									 volumeLiter_
								] :=
		Module[ {x,scale,order,structures,sol,i,whichStructure, whichSpecies, nStructures,stoich,state0,inds,yUnit,
		R,P,rates,species,debug=False},

		If[MatchQ[volumeLiter,Null],
			Return[Message[stochasticReaction::InvalidVolume]]
		];

		{R,P,rates,species} = reactionMatricesFull[inputMechanism];
		 x = N[QuantityMagnitude[UnitConvert[initialState[Quantities],Molar]]];
				scale = AvogadroConstant*Mole * volumeLiter;

		(* expected # of molecules *)
		x = x * scale;
		x = poiss[x];

			state0 = Table[ToPackedArray[N[Prepend[x,tStart]]],{1}];
				order = Total[R]; (* order of the reaction *)
				structures = Inner[Table[#1, {#2}] &, Range[Length[x]], R, Join]; (* structures[[i]] ~ species involved in structure i *)
		whichStructure = Flatten[Table[ConstantArray[i,Length[structures[[i]]]],{i,Length[structures]}]];
				whichSpecies = Flatten[structures];
				nStructures = Length[structures];
				stoich = Transpose[P-R];

				(*{state0[[1]], whichSpecies, whichStructure, nStructures, rates, 1/scale^(order - 1), stoich, tEnd}*)
				sol = Quiet[NestWhileList[
					(
						gill[#,whichSpecies, whichStructure, nStructures, rates, 1/scale^(order - 1), stoich, tEnd]
					)&,
						state0,
						Min[#[[All,1]]] < tEnd&
				],{MessageName[CCompilerDriver`CreateLibrary, "nocomp"]}];


			sol[[All,All,2;;]] = sol[[All,All,2;;]]/scale;
				yUnit=Molar;
			inds=Range[Length[DeleteDuplicates[sol[[;;,1,1]]]]];
			{
				ToTrajectory[species,sol[[inds,1,2;;]],sol[[inds,1,1]],{Second,yUnit}],
				Null
			}
	 ];



poiss[0.] :=    0.;
poiss[0] :=    0.;
poiss[x_?NumericQ] :=    N[RandomVariate[PoissonDistribution[x]]];
SetAttributes[poiss, Listable];

(* Fast compiled implementation of Gillespie's algorithm *)
gill := (

choose = Core`Private`SafeCompile[{{weights,_Real,1}},
		Module[ {
				random = RandomReal[Total[weights]],
				choice = 1
		},
				While[random > 0,
						random -= weights[[choice]];
						++choice
				];
				choice-1
		],
		CompilationTarget->"C"
];

maxChange = Core`Private`SafeCompile[{
		{state0,_Real,1},
		{state,_Real,1}
},
		Module[ {max = 0.},
				Do[
						If[ state0[[i]]>0,
								max = Max[max, Abs[ state[[i]]-state0[[i]] ] / state0[[i]] ]
						],
						{i,2,Length[state0]}
				];
				max
		]
];

gill = Core`Private`SafeCompile[{
		{state0,_Real,1}, (* {t, x...} *)
		{whichSpecies,_Integer,1},
		{whichStructure,_Integer,1},
		{nStructures,_Integer},
		{rates,_Real,1},
		{scale,_Real,1},
		{stoich,_Integer,2},
		{tEnd,_Real}
},
		Module[ {
				propensity = Table[1.,{nStructures}],
				wait = 0.,
				choice = 0,
				state = state0,
				nSpecies = Length[state0]-1
		},
				While[state0[[1]]<tEnd && maxChange[state0, state] < .01, (* While there is less than a 1% change in any of the species *)
						propensity = scale;
						Do[
								propensity[[ whichStructure[[i]] ]] *= state[[ whichSpecies[[i]]+1 ]],
								{i,Length[whichStructure]}
						];
						propensity *= rates;
						If[ Total[propensity]==0.,
								state[[1]] = tEnd;
								Break[]
						];

						(* Exponential waiting time for next reaction *)
						wait = -(1/Total[propensity])*Log[RandomReal[1.0]];

						(* Choose one reaction, weighted by propensity *)
						choice = choose[propensity];
						state[[1]] += wait;
						state[[2;;nSpecies+1]] += stoich[[choice]];
				];
				state
		],

		CompilationTarget->"C",
		CompilationOptions->{
				"InlineExternalDefinitions"->True
		},
		RuntimeAttributes -> {Listable},
		Parallelization -> True,
		RuntimeOptions -> {"EvaluateSymbolically" -> False}
]
);


(* ::Subsubsection:: *)
(*deterministicReactionNonVectorized*)

deterministicReactionNonVectorized[inputMechanism:(_ReactionMechanism|{KineticsEquationP..}), initialState_State, tspan:{t_,t0_,tF_},tempFunc0_,injections_,volumeExpression_,resolvedOps_List]:=Module[{
		mechRep,initialStateRep,opsRep,revRules,rxnsFull,allSpecs,equations,tFsim,
		sol,specSol,tfInSeconds,initialVolume,injectionsFull,icIncomplete,
		outSpecs,scaleRates=False,debug=False,traj, icEquations, initialConditionFull, allEquations, yUnit
	},

	(* handle structure input, replace them with symbolic input *)
	{mechRep, initialStateRep, opsRep, revRules} = structToSymbol[inputMechanism, initialState, resolvedOps];

	outSpecs = Lookup[opsRep, ObservedSpecies];

	tfInSeconds = tF;
	initialVolume = Lookup[opsRep,Volume];
	injectionsFull = injections;


	(* make the final system of ODEs and ICs *)
	{equations, icEquations, allEquations} = If[MatchQ[inputMechanism,{KineticsEquationP..}],
		Module[{},
				icIncomplete = Map[#[[1]]->Unitless[#[[2]]]&,initialStateRep[Rules]]; (* units might not be concentration *)
			initialConditionFull = N@Unitless[initialState[Rules]];
			icEquations = icsToEqualVector[initialConditionFull,t0];
			{inputMechanism, icEquations, Join[inputMechanism, icEquations]}
		],
		Module[{},
			icIncomplete = Map[#[[1]]->Unitless[#[[2]],Molar]&,initialStateRep[Rules]]; (* this should always be Molar *)
			rxnsFull = NucleicAcids`Private`toFullImplicitReactions[NucleicAcids`Private`mechanismToImplicitReactions[mechRep]];
			formatODESystem[rxnsFull,icIncomplete,injectionsFull,initialVolume,t,Replace[scaleRates,True->Log]]/.Temperature->Lookup[opsRep, Temperature][t]
		]
	];

	(* do this after the structure -> symbol transformations *)

	allSpecs = SpeciesList[mechRep];

	sol = solveReactionODEs[allEquations,allSpecs,{t,t0,tF},
		FilterRules[opsRep,{MaxStepFraction,AccuracyGoal,PrecisionGoal}]
	];

	outSpecs = Lookup[opsRep, ObservedSpecies];

	specSol = Lookup[sol,outSpecs];

	yUnit = initialState["Unit"];
	traj = interpFuncsToTraj[outSpecs, specSol,yUnit];

	(* warning message if end of interpolation function doesn't match desired final simulation time *)
	tFsim=Last[traj[Times]];
	If[
		Norm[(tFsim-tF)/tF] > 10^-6,
		Message[Warning::FailedToComplete,tFsim];
	];

	traj = traj /. revRules;

		(* warning message if concentrations go negative (more than numerical noise) *)
			If[
				And[
					MatchQ[
						UnitDimensions[initialState["Unit"]],
						{{"AmountUnit",1},___}
					],
					Min[Flatten[traj[Concentrations]]] < - 10^-4 * Norm[Unitless[Values[icIncomplete]]]
				],
				Message[Warning::NegativeConcentration];
			];

	{traj, stringSpeciesToSymbols[equations]}

];



interpFuncsToTraj[allSpecs_List, interpFuncs_, yUnit_]:=Module[{times,concs},
	times=First[interpFuncs][[3,1]];
	concs = Table[Through[interpFuncs[t]],{t,times}];
	ToTrajectory[allSpecs,concs,times,{Second,yUnit}]
];


structToSymbol[inputMechanism_, initialState_, resolvedOps_]:= Module[
	{allStructs, symbols, rules, revRules},

	(* get all structures in mechanism *)
	allStructs = DeleteDuplicates[Cases[inputMechanism, _Structure, Infinity]];

	(* symbols to replace the structures *)
	symbols = Table["x"<>ToString[cnt], {cnt, 1, Length[allStructs]}];

	(* rules and reverse rules *)
	rules = MapThread[Rule[#1, #2]&, {allStructs, symbols}];
	revRules = MapThread[Rule[#1, #2]&, {symbols, allStructs}];

	{inputMechanism/.rules, initialState/.rules, resolvedOps/.rules, revRules}

];


(* ::Subsection:: *)
(*Non-vectorized formulation and solving*)


(* ::Subsubsection::Closed:: *)
(*solveReactionODEs*)


solveReactionODEs[equationss:{_List..},allSpecs_,{t_,t0_,tF_},ndsolveOps_List]:=
			Map[solveReactionODEs[#,allSpecs,{t,t0,tF},ndsolveOps]&,equationss];

solveReactionODEs[equations_List,allSpecs_,{t_,t0_,tF_},ndsolveOps_List]:=Module[
	{stringFlag, out, safeEquations, safeSpecies},
	(* have to do the sting-expression transformation because MM11.3 no longer support String as variable names *)
	stringFlag = StringQ[allSpecs[[1]]];

	safeEquations = stringSpeciesToSymbols[equations];
	safeSpecies = stringSpeciesToSymbols[allSpecs];

	out = Quiet[
		First[NDSolve[safeEquations, safeSpecies,{t,t0,tF},Sequence@@ndsolveOps]],
		{NDSolve::ndsz}
	];

	If[stringFlag,
		out /. Rule[x_Symbol, y_] :> Rule[ToString[x], y],
		out
	]
];

stringSpeciesToSymbols[in_] := in /. (x_String :> ToExpression[x]);

(* ::Subsubsection::Closed:: *)
(*ReactionEquations*)
Options[ReactionEquations]= {
	TimeVariable->t,
	LogRates->False
};

ReactionEquations[name:NamedReactionP,ops:OptionsPattern[]]:=
	ReactionEquations[NamedReactions[name],ops];

ReactionEquations[rxnList_,ops:OptionsPattern[]]:=Module[{safeOps},

	safeOps = SafeOptions[ReactionEquations,ops];

	rxnsFull = NucleicAcids`Private`toFullImplicitReactions[rxnList];

	rxnEquations = ToSpeciesODEs[rxnsFull,Lookup[safeOps,TimeVariable],Lookup[safeOps,LogRates]];

	rxnEquations

];


(* ::Subsubsection::Closed:: *)
(*formatODESystem*)


formatODESystem[rxnList_,icIncomplete_,injSpec:{{_,_,_,_,_}...},v0_,tvar_,log_]:=Module[
	{rxnsFull,allRateVars,allSpecs,initialConditionFull,icEquations,t0=0,rxnEquations,reactionAndInjectionEquations,equations,
	debug=False},

	rxnsFull = NucleicAcids`Private`toFullImplicitReactions[rxnList];

	allRateVars = Flatten[rxnsFull[[;;,2;;]]];
	allSpecs = allReactionSpecies[rxnsFull];

	initialConditionFull = N@toFullInitialCondition[icIncomplete,allSpecs];
	icEquations = icsToEqualVector[initialConditionFull,t0];

	rxnEquations = ToSpeciesODEs[rxnsFull,tvar,log];

	reactionAndInjectionEquations = formatReactionAndInjectionEquations[rxnEquations,injSpec,v0,tvar,allSpecs];

	equations = Join[reactionAndInjectionEquations,icEquations];

	{reactionAndInjectionEquations, icEquations, equations}
];


formatODESystem[wellList_List,tvar_Symbol,rxnList_List,allSpecs_,icVar_,t0_,v0Assoc_Association,allRateVars_,rateVar_Symbol,injVar_Symbol,log_]:=Map[
	Function[well,
		formatODESystem[rxnList,Map[#1->icVar[well,#1]&,allSpecs],injVar[well,Spec],v0Assoc[well],tvar,log]
	],wellList
]/.Map[#->rateVar[#]&,allRateVars];



(* ::Subsubsection::Closed:: *)
(*formatReactionAndInjectionEquations*)


(* FAST injections *)
formatReactionAndInjectionEquations[rxnEquations_,injSpec:({{_,_,_,Null,_}...}),v0_,tvar_,allSpecs_]:=Module[
	{allVolumes,injEquations},
	allVolumes = injectionsToTotalVolumes[injSpec,v0];
	injEquations = Map[formatOneInjectionEvent[#,tvar,allSpecs,v0,allVolumes]&,injSpec];
	Join[rxnEquations,injEquations]
];


(* SLOW injections *)
formatReactionAndInjectionEquations[rxnEquations_,injSpec:({{_,_,_,_?NumericQ,_}...}),v0_,tvar_,allSpecs_]:=Module[
	{volumeExpression,injEquations,allFluxEquations},
	volumeExpression = constructVolumeExpression[injSpec,tvar,v0];
	injEquations = constructInjectionTermEquations[injSpec,allSpecs,tvar,volumeExpression];
	allFluxEquations = joinFluxEquations[rxnEquations,injEquations];
	allFluxEquations
];


(* ::Subsubsection::Closed:: *)
(*joinFluxEquations*)


joinFluxEquations[eqs1_,eqs2_]:= Map[Equal[#[[1,1]],Total[#[[;;,2]]]]&,GatherBy[Join[eqs1,eqs2],First]];



(* ::Subsubsection::Closed:: *)
(*allReactionSpecies*)


allReactionSpecies[rxnsFull_]:=Union[Flatten[Map[reactionSpecies[#]&,rxnsFull]]];



(* ::Subsubsection::Closed:: *)
(*toFullInitialCondition*)


toFullInitialCondition[partialRules_,allSpecs_]:=DeleteDuplicatesBy[
	Join[
		partialRules,
		Map[Rule[#,0]&,allSpecs]
	],
	First
];


(* ::Subsubsection::Closed:: *)
(*icsToEqualVector*)


icsToEqualVector[fullInitialCondition_,t0_]:= Map[Equal[#[[1]][t0],#[[2]]]&,fullInitialCondition];



(* ::Subsubsection::Closed:: *)
(*ToSpeciesODEs*)


ToSpeciesODEs[rxns_,t_,scale_]:=Module[{rxnsFull,rxnFlows,rxnSpecs,speciesRxnRules,specs,rxnsFullSplit},
	rxnsFull = NucleicAcids`Private`toFullImplicitReactions[rxns];
	rxnsFullSplit = toReversibleReactions[rxnsFull];
	rxnFlows = ToReactionFlows[rxnsFullSplit,t,scale];
	rxnSpecs = Map[reactionSpecies[#]&,rxnsFullSplit];
	speciesRxnRules = Map[Append[reactionSpeciesFlowRules[#,t,scale],_->0]&,rxnsFullSplit];
	specs = Union[Flatten[rxnSpecs]];
	Map[Derivative[1][#][t]==Total[ -ReplaceAll[#,speciesRxnRules]]&,specs]
];


(* ::Subsubsection::Closed:: *)
(*injectionsToTotalVolumes*)


injectionsToTotalVolumes[injs:{{{_,_,_,Null,_}..}..},initialVolumes_List]:=MapThread[injectionsToTotalVolumes,{injs,initialVolumes}];
injectionsToTotalVolumes[injs:{{_,_,_,Null,_}..},initialVolume_]:=Module[{gatheredByTime,times,totalledByTime,accumulatedByTimeAfter,accumulatedByTimeBefore},
	gatheredByTime= GatherBy[injs[[;;,{1,3}]],#[[1]]&];
	times = gatheredByTime[[;;,1,1]];
	totalledByTime=Total/@gatheredByTime[[;;,;;,2]];
	accumulatedByTimeBefore = initialVolume + Most[Prepend[Accumulate[totalledByTime],0]];
	accumulatedByTimeAfter= initialVolume + Accumulate[totalledByTime];
	(*
		return association whose elements are the volumes immediately before and after each injection time:
		time \[Rule] {volBefore,volAfter}
	*)
	Association[Rule@@@Transpose[{times,Transpose[{accumulatedByTimeBefore,accumulatedByTimeAfter}]}]]
];



(* ::Subsubsection::Closed:: *)
(*formatOneInjectionEvent*)


formatOneInjectionEvent[{time_,spec_,dV_,flowRate:Null,dC_},tvar_,allSpecs_List,v0_,allVolumes_]:=With[
	{concRules = Join[{spec[tvar]->Simplify[(spec[tvar]*allVolumes[time][[1]]+dV*dC)/(allVolumes[time][[1]]+dV)]},Map[#[tvar]->#[tvar]*allVolumes[time][[1]]/(allVolumes[time][[1]]+dV)&,Complement[allSpecs,{spec}]]]},
	N@WhenEvent[tvar==time,concRules]
];


(* ::Subsubsection::Closed:: *)
(*constructInjectionTermEquations*)


constructInjectionTermEquations[injs:{{_,_,_,_,_}..},specs_List,tvar_,volumeExpression_]:=Module[{injPiecewiseAssoc},
	injPiecewiseAssoc = constructInjectionTermAssociation[injs,specs,tvar,volumeExpression];
	Map[Equal[D[#[tvar],tvar],Lookup[injPiecewiseAssoc,#,0]]&,specs]
];

(* construct injection terms as Piecewise expressions *)
constructInjectionTermAssociation[injs:{{_,_,_,_,_}..},specs_List,tvar_,volumeFunction_]:=Module[{allTerms},
	allTerms = constructInjectionTerms[injs,specs,tvar,volumeFunction];
	GroupBy[Flatten[allTerms],First->Last,PiecewiseExpand[Total[#]]&]
];
constructInjectionTerms[injs:{{_,_,_,_,_}..},specs_List,tvar_,volumeExpression_]:=Map[constructInjectionTerms[#,specs,tvar,volumeExpression]&,injs];
constructInjectionTerms[inj:{_,_,_,_,_},specs_List,tvar_,volumeExpression_]:=Map[constructInjectionTerm[inj,#,tvar,volumeExpression]&,specs];
constructInjectionTerm[inj:{t1_,injSpec_,vol_,flowRate_,injConc_},spec:Except[_List],tvar_,volumeExpression_]:=With[
	{val=injectionToConcentrationFlux[inj,spec,tvar,volumeExpression],t2=t1+vol/flowRate},
	spec -> Piecewise[{{val,t1<=tvar<=t2}},0.0]
];

injectionToConcentrationFlux[inj:{t1_,injSpec_,vol_,flowRate_,injConc_},otherSpec_,tvar_,volumeExpression_] :=
	(injConc-injSpec[tvar])*flowRate/volumeExpression /; SameQ[injSpec,otherSpec];
injectionToConcentrationFlux[inj:{t1_,injSpec_,vol_,flowRate_,injConc_},otherSpec_,tvar_,volumeExpression_] :=
	-otherSpec[tvar]*flowRate/volumeExpression;




(* ::Subsubsection::Closed:: *)
(*reactantSpecies*)


reactantSpecies[{Rule[left_,_],kf_}]:=reactionSideUniqueSpecies[left];
reactantSpecies[{Equilibrium[left_,_],kf_,kb_}]:=reactionSideUniqueSpecies[left];


(* ::Subsubsection::Closed:: *)
(*productSpecies*)


productSpecies[{Rule[_,right_],kf_}]:=reactionSideUniqueSpecies[right];
productSpecies[{Equilibrium[_,right_],kf_,kb_}]:=reactionSideUniqueSpecies[right];



(* ::Subsubsection::Closed:: *)
(*reactionSpecies*)


reactionSpecies[rx_]:=Join[reactantSpecies[rx],productSpecies[rx]];



(* ::Subsubsection::Closed:: *)
(*toReversibleReactions*)


toReversibleReactions[rxnsFull:{{_,__}..}]:=Flatten[Map[splitReversibleReaction[#]&,rxnsFull],1];
splitReversibleReaction[{Equilibrium[left_,right_],kf_,kb_}]:={{Rule[left,right],kf},{Rule[right,left],kb}};
splitReversibleReaction[rx:{_Rule,kf_}]:={rx};



(* ::Subsubsection::Closed:: *)
(*ToReactionFlows*)


ToReactionFlows[rxns_,t_,scale_]:=Module[{rxnsFull},
	rxnsFull = NucleicAcids`Private`toFullImplicitReactions[rxns];
	Map[reactionODE[#,t,scale]&,rxnsFull]
];



(* ::Subsubsection::Closed:: *)
(*reactionSpeciesFlowRules*)


reactionSpeciesFlowRules[rx_,t_,scale_]:=With[
	{rate=reactionODE[rx,t,scale]},
	Join[
		Map[Rule[#,stoichCoeff[rx,#,Reactant]*rate]&,reactantSpecies[rx]],
		Map[Rule[#,-stoichCoeff[rx,#,Product]*rate]&,productSpecies[rx]]
	]
];



(* ::Subsubsection::Closed:: *)
(*reactionSideUniqueSpecies*)


reactionSideUniqueSpecies[rx_]:=DeleteDuplicates[reactionSideAllSpecies[rx]];



(* ::Subsubsection::Closed:: *)
(*reactionSideAllSpecies*)


reactionSideAllSpecies[s:specP]:={s};
reactionSideAllSpecies[p:HoldPattern[Plus][specP..]]:=List@@p;
reactionSideAllSpecies[p:HoldPattern[Plus][(specP|HoldPattern[Times][_Integer,specP])..]]:=Flatten[p/.{Plus->List,HoldPattern[Times][n_Integer,s:specP]:>Table[s,{n}]}];
reactionSideAllSpecies[HoldPattern[Times][n_Integer,s:specP]]:=Table[s,{n}];



(* ::Subsubsection::Closed:: *)
(*stoichCoeff*)


stoichCoeff[rx:{rule_Rule,kf_},spec_,side_]:=stoichCoeff[rule,spec,side];
stoichCoeff[rx:Rule[react_,prod_],spec_,Reactant]:=Max[{1,Count[reactionSideAllSpecies[react],spec]}];
stoichCoeff[rx:Rule[react_,prod_],spec_,Product]:=Max[{1,Count[reactionSideAllSpecies[prod],spec]}];


(* ::Subsubsection::Closed:: *)
(*reactionODE*)


reactionODE[rxn_,t_,Log]:=reactionODE[Join[rxn[[{1}]],10^rxn[[2;;]]],t];
reactionODE[rxn_,t_,_]:=reactionODE[rxn,t];



reactionODE[{Rule[left:anyReactionSideP,right:anyReactionSideP],kf_},t_]:=kf*reactionSideODEpart[left,t];
reactionODE[{Equilibrium[left:anyReactionSideP,right:anyReactionSideP],kf_,kb_},t_]:=kf*reactionSideODEpart[left,t] - kb*reactionSideODEpart[right,t];



(* ::Subsubsection::Closed:: *)
(*reactionSideODEpart*)


(* this is 'part' b/c it doesn't include the rake factor k *)
reactionSideODEpart[a:specP,t_]:= a[t];
reactionSideODEpart[p:HoldPattern[Plus][specP..],t_]:=Times@@Through[reactionSideAllSpecies[p][t]];
reactionSideODEpart[p:HoldPattern[Times][n_Integer,s:specP],t_]:=s[t]^n;
reactionSideODEpart[p:HoldPattern[Plus][(specP|HoldPattern[Times][_Integer,specP])..],t_]:=Times@@Through[reactionSideAllSpecies[p][t]];
