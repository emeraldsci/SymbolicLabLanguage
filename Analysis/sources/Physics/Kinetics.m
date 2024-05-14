(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeKinetics*)


(* ::Subsubsection:: *)
(*AnalyzeKinetics*)


DefineOptions[AnalyzeKinetics,
	Options :> {
		{
			OptionName -> Domain,
			Default -> All,
			Description -> "Data points whose x-values lie outside Domain are excluded during fitting.",
			AllowNull -> False,
			Widget -> Alternatives[
						{
							"Min" -> Alternatives[
										Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Second], Units->Alternatives[Second,Minute,Hour]],
										Widget[Type->Enumeration, Pattern:>Alternatives[All]]
									],
							"Max" -> Alternatives[
										Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Second], Units->Alternatives[Second,Minute,Hour]],
										Widget[Type->Enumeration, Pattern:>Alternatives[All]]
									]
						},
						Widget[Type->Enumeration, Pattern:>Alternatives[All]]
					]
		},
		{
			OptionName -> StandardCurve,
			Default -> Automatic,
			Description -> "Standard curve to use in analysis.",
			ResolutionDescription -> "If Automatic, uses standard curve wells in protocol.",
			AllowNull -> True,
			Widget -> Alternatives[
						Widget[Type->Object, Pattern:>ObjectP[{Object[Analysis,Fit],Object[Analysis,Kinetics]}]],
						Adder[{
							"Intensity" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 RFU]|GreaterEqualP[0 RLU]|GreaterEqualP[0 AbsorbanceUnit], Units->Alternatives[RFU,RLU,AbsorbanceUnit]],
							"Concentration" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Molar], Units->Alternatives[Molar,Nano Molar,Micro Molar]]
						}],
						Adder[{
							"Object" -> Widget[Type->Object, Pattern:>ObjectP[{
								Object[Data, AbsorbanceKinetics],
								Object[Data, FluorescenceKinetics],
								Object[Data, FluorescencePolarizationKinetics],
								Object[Data, LuminescenceKinetics],
								Object[Data, NephelometryKinetics]
							}]],
							"Concentration" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Molar], Units->Alternatives[Molar,Nano Molar,Micro Molar]]
						}]
					]
		},
		{
			OptionName -> StandardCurveFitType,
			Default -> Linear,
			Description -> "Expression type to fit standard curve to, if creating new standard curve for analysis.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>FitTypeP]
		},
		{
			OptionName -> StandardCurveFitOptions,
			Default -> {},
			Description -> "Options for standard curve fitting that get passed to AnalyzeFit.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>{___Rule}, PatternTooltip->"Specify the options used in AnalyzeFit, e.g. Method\[Rule]NMinimize.", Size->Line]
		},
		{
			OptionName -> OptimizationType,
			Default -> Global,
			Description -> "Specify whether to use global or local optimization to solve for rates.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Global,Local,Manual]]
		},
		{
			OptionName -> OptimizationOptions,
			Default -> {AccuracyGoal -> 6, PrecisionGoal -> 6},
			Description -> "Additional options to pass to the optimization function.  Any option for NMinimize or FindMinimum can be used.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>{___Rule}, PatternTooltip->"Specify the options used in SimulateKinetics, e.g. {PrecisionGoal\[Rule]4,AccuracyGoal\[Rule]4}.", Size->Line]
		},
		{
			OptionName -> Rates,
			Default -> {},
			Description -> "Initial guesses or intervals for the rate variables being solved for.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Expression, Pattern:>{(RateFormatP -> _?NumericQ | {_?NumericQ, _?NumericQ})...}, PatternTooltip->"The rate variables with initial numbers, e.g. {kf->{10^4,10^6},kb-> {10^-6, 10^-4}}.", Size->Paragraph],
						Widget[Type->Object, Pattern:>ObjectP[{Object[Simulation,Kinetics]}]]
					]
		},
		{
			OptionName -> InitialVolume,
			Default -> Automatic,
			Description -> "Initial volume in each well.",
			ResolutionDescription -> "If Automatic, the volumes are pulled from the SamplesIn in each well.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Liter], Units->Alternatives[Liter,Micro Liter]],
						Adder[
							Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Liter], Units->Alternatives[Liter,Micro Liter]]
						]
					]
		},
		{
			OptionName -> InitialConcentration,
			Default -> Automatic,
			Description -> "Initial concentration of each species in each well.  Any unspecified species are assumed to be at zero.",
			ResolutionDescription -> "If Automatic, the concentrations are pulled from the SamplesIn in each well.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>({(SpeciesP -> (_Symbol_UnitsP[]))..}|{{(SpeciesP -> (_Symbol|UnitsP[]))..}..}), Size->Paragraph]
		},
		{
			OptionName -> AssayWells,
			Default -> Automatic,
			Description -> "Specify which wells contain data to be analyzed if given protocol input.",
			ResolutionDescription -> "If Automatic, AssayWells are taken as any wells containing Object[Sample] and having injections.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>{WellP..}, Size->Line]
		},
		{
			OptionName -> Injections,
			Default -> Automatic,
			Description -> "Injections for each assay well.",
			ResolutionDescription -> "If Automatic, injections are pulled from the protocols.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>(InjectionFormatP|{InjectionsFormatP..}), Size->Paragraph]
		},
		{
			OptionName -> ObservedSpecies,
			Default -> Automatic,
			Description -> "The species in the ReactionMechanism corresponding to the observed kinetic data.  The specified species must exist in the given ReactionMechanism.",
			ResolutionDescription -> "If Automatic, looks for structures in the ReactionMechanism with unquenched fluorescers.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>(SpeciesP|{SpeciesP..}|{{SpeciesP..}..}), PatternTooltip->"Species can be a single structure/symbol, or a list/nested list of structures/symbols.", Size->Paragraph]
		},
		{
			OptionName -> InitialSpecies,
			Default -> Automatic,
			Description -> "The initial species in the well.  The specified species must exist in the given ReactionMechanism.",
			ResolutionDescription -> "If Automatic, the Structure in initial sample will be used.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:>SpeciesP, PatternTooltip->"Species can be a single structure or a symbol.", Size->Line]
		},
		{
			OptionName -> PrimaryInjectionSpecies,
			Default -> Automatic,
			Description -> "The species being injected during the first injection.  The specified species must exist in the given ReactionMechanism.",
			ResolutionDescription -> "If Automatic, the Structure in injected sample will be used.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:>SpeciesP, PatternTooltip->"Species can be a single structure or a symbol.", Size->Line]
		},
		{
			OptionName -> SecondaryInjectionSpecies,
			Default -> Automatic,
			Description -> "The species being injected during the second injection.  The specified species must exist in the given ReactionMechanism.",
			ResolutionDescription -> "If Automatic, the Structure in injected sample will be used.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:>SpeciesP, PatternTooltip->"Species can be a single structure or a symbol.",  Size->Line]
		},
		{
			OptionName -> TertiaryInjectionSpecies,
			Default -> Automatic,
			Description -> "The species being injected during the third injection.  The specified species must exist in the given ReactionMechanism.",
			ResolutionDescription -> "If Automatic, the Structure in injected sample will be used.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:>SpeciesP, PatternTooltip->"Species can be a single structure or a symbol.", Size->Line]
		},
		{
			OptionName -> ScaleConcentration,
			Default -> False,
			Description -> "Whether or not to normalize concentrations for fitting.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
			Category -> "Hidden"
		},
		{
			OptionName -> ScaleRates,
			Default -> False,
			Description -> "Whether or not to normalize rates for fitting.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
			Category -> "Hidden"
		},
		{
			OptionName -> TimeVariable,
			Default -> t,
			Description -> "Symbol used to represent the time in the equations.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>_Symbol, Size->Line],
			Category -> "Hidden"
		},
		{
			OptionName -> EvaluationMonitor,
			Default -> False,
			Description -> "Function to apply to each step of the fitting process.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Enumeration, Pattern:>BooleanP],
						Widget[Type->Expression, Pattern:>_Function, Size->Line]
					],
			Category -> "Hidden"
		},

		OutputOption,
		UploadOption,
		AnalysisTemplateOption
	}
];

Error::InvalidInjectionSpecies="The injected species `1` do not exist in the given ReactionMechanism.";
Error::InvalidObservedSpecies="The ObservedSpecies `1` do not exist in the given ReactionMechanism.";
Error::InvalidAnalyzeKineticsOption="The option `1` should be a list of length `2`.  The resolved value is `3`";
Error::NoAssayWells="No valid assay wells found in protocol `1`.";
Error::NoUnknownRates="No unknown rates in the given ReactionMechanism.";
Warning::PredictedValueOutOfDomain="Warning, values predicted by the standard curve function are outside the range of the standard curve data.  Extrapolation is being used.";
AnalyzeKinetics::PoorOptimization = "Unable to determine optimal rate constants. Calculated rate constants may yield a bad fit, or be identical to the initial guess. This is typically caused by a bad initial guess, or data which cannot be described by the given reactions.";

bindingKineticsModelP = Alternatives[OneToOne, HeterogeneousLigand, BivalentAnalyte, MassTransport];

(* Define supported data and protocol types *)
kineticsDataTypes = {
	Object[Data, AbsorbanceKinetics],
	Object[Data, FluorescenceKinetics],
	Object[Data, LuminescenceKinetics]
	(*
	Object[Data, FluorescencePolarizationKinetics],
	Object[Data, NephelometryKinetics]
	*)
};

kineticsProtocolTypes = {
	Object[Protocol, AbsorbanceKinetics],
	Object[Protocol, FluorescenceKinetics],
	Object[Protocol, LuminescenceKinetics]
	(*
	Object[Protocol, FluorescencePolarizationKinetics],
	Object[Protocol, NephelometryKinetics]
	*)
};

(* Useful patterns for internal functions *)
kineticsDataP=ObjectP[kineticsDataTypes];
kineticsDataReferenceP=ObjectReferenceP[kineticsDataTypes];
kineticsDataPacketP=PacketP[kineticsDataTypes];

kineticsProtocolP=ObjectP[kineticsProtocolTypes];
kineticsProtocolReferenceP=ObjectReferenceP[kineticsProtocolTypes];
kineticsProtocolPacketP=PacketP[kineticsProtocolTypes];

(* bindingKineticsODEs[OneToOne] := {R'[t] == ka*A[0]*Rmax - R[t]*(ka*A[0]-kd)} *)
bindingKineticsODEs[OneToOne] := {R'[t] == 10^ka*A[0]*Rmax - R[t]*(10^ka*A[0]-10^kd)};

reactionsModelP = Alternatives[
	MechanismFormatP,
	ListableP[ListableP[NucleicAcids`Private`implicitReactionFormatP|_Rule|_Equilibrium]],
	NamedReactionP,
	bindingKineticsModelP,
	ListableP[KineticsEquationP]
];

inputAnalyzeKineticRatesP = Alternatives[
	kineticsProtocolP,
	{kineticsDataP..},
	{TrajectoryFormatP..},
	{CoordinatesP..},
	{QuantityCoordinatesP[{Second, Molar}]..},
	{QuantityCoordinatesP[]..}, (* need to restrict x to be time *)
	{{StateFormatP|{__Rule}, InjectionsFormatP | {}, TrajectoryFormatP, VolumeP}...},
	{{StateFormatP|{__Rule}, InjectionsFormatP | {}, {kineticsDataP, SpeciesP}, VolumeP}...}
];


DefineAnalyzeFunction[
	AnalyzeKinetics,
	<|TrainingData-> inputAnalyzeKineticRatesP, Model-> reactionsModelP|>,
	{
		resolveAnalyzeKineticsOptions,
		calculateKineticRateFields,
		formatKineticsPacket,
		analyzeKineticsPreviewStep
	}
];


analyzeKineticsPreviewStep[assoc:SingletonAssociationP]:= <|
	Preview -> If[MemberQ[assoc[OutputList],Preview],
		Block[{$CCD = False},Zoomable@ECL`PlotKineticRates[assoc[Packet]]],
		Null
	]
|>

(* ::Subsection:: *)
(*Resolution*)


(* ::Subsubsection:: *)
(*resolveAnalyzeKineticsOptions*)

resolveAnalyzeKineticsOptions[assoc:SingletonAssociationP]:= Module[
	{output, listedOutput, collectTestsBoolean, allTests, resolvedAll,resolvedOps,stdcPacket,trainingDataSets,
	reactionList,refRelations,domain,domainTestDescription,domainTest},

	combinedOptions = Normal[assoc[ResolvedOptions]];
	(* From resolveAnalyzeFitOptions's options, get Output value *)
	output=Lookup[combinedOptions,Output];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	reactionModel = assoc[UnresolvedInputs][Model];
	{userReactions, userEquations} = Switch[reactionModel,
		ListableP[KineticsEquationP],
			{Null, reactionModel},
		bindingKineticsModelP,
			{Null, bindingKineticsODEs[reactionModel]},
		_,
			{reactionModel,Null}
	];

	resolvedAll = {resolveAnalyzeKineticRatesInputsAndOptions[assoc[UnresolvedInputs][TrainingData], userReactions, userEquations, combinedOptions]};

	If[MatchQ[resolvedAll,{{Null..}..}],Return[{{$Failed},$Failed}]];

	{resolvedOps,stdcPacket,trainingDataSets,reactionList,equationList,refRelations} = First/@Transpose[resolvedAll];

	(* --- Check if Domain has valid span --- *)
	domain=Lookup[First[resolvedOps],Domain];
	domainTestDescription="The left boundary is greater than or equal to the right boundary in the specified domain:";
	domainTest = analyzekineticsTestOrNull[Domain, collectTestsBoolean, domainTestDescription, First[domain]<Last[domain]];

	allTests=If[collectTestsBoolean,
		{domainTest},
		Null
	];

	<|
		ResolvedOptions -> Association[resolvedOps],
		Tests -> <|OptionTests -> allTests|>,
		ResolvedInputs -> <|
			TrainingData -> trainingDataSets,
			Reactions -> reactionList,
			Equations -> equationList,
			Relations -> refRelations,
			StandardCurves -> stdcPacket
		|>
	|>

];


analyzekineticsTestOrNull[opsName_, makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		Null,
		Message[Error::InvalidOption, opsName]
	]
];


(* ::Subsubsection:: *)
(*resolveTrainingDataInput*)

(* base case, given trajectories and standard curve *)
resolveTrainingDataInput[trajs:{_Trajectory..},standardCurvePacket:Null,observedSpecs_,assayWells_]:=Module[{},
	trajs
];
resolveTrainingDataInput[trajs:{_Trajectory..},standardCurvePacket_,observedSpecs_,assayWells_]:= Module[{
		xys, yTransformed, minMax, dataUnit, oldUnit,newUnit, fitDataMinMax, xValues, yValues
	},

	(* numerical data from trajectories *)
	xys = Flatten[#[Coordinates],1]&/@trajs;
	xValues = xys[[;;,;;,1]];
	yValues = xys[[;;,;;,2]];
	dataUnit = trajs[[1]][YUnit];

	(* standard curve and its units *)
	standardFitFunction = packetLookup[standardCurvePacket,BestFitFunction];
	{oldUnit,newUnit} = If[MatchQ[standardFitFunction,_QuantityFunction],
		{standardFitFunction[[2,1]],standardFitFunction[[3]]},
		{1,Molar}
	];

	(* get min and max of data and standard curve, and convert to same unit *)
	fitDataMinMax = MinMax[packetLookup[standardCurvePacket,DataPoints][[;;,1]]];
	minMax =MinMax[Flatten[yValues]];
	If[QuantityQ[fitDataMinMax[[1]]],
		fitDataMinMax = Unitless[Convert[fitDataMinMax,oldUnit,dataUnit]];
	];

	(* Extrapolation warning *)
	If[AnyTrue[minMax, !MatchQ[#, RangeP[Sequence @@ fitDataMinMax]] &],
		Message[Warning::PredictedValueOutOfDomain]
	];

	(* transform the y-values and strip units *)
	yTransformed = Unitless[Map[standardFitFunction,yValues,{2}]];


	concTrajs = MapThread[
		ToTrajectory[
			#3,
			List/@#2*Convert[1,newUnit,Molar],#1,{Second,Molar}
		]&,
		{xValues,yTransformed,observedSpecs}
	];

	resolveTrainingDataInput[concTrajs,Null,observedSpecs,assayWells]
];


resolveTrainingDataInput[in:{(CoordinatesP|QuantityCoordinatesP[])..},standardCurvePacket_,observedSpecs_,assayWells_]:=Module[{trajectories},

	trajectories = 	MapThread[
		ToTrajectory[
			#2,
			If[
				ConcentrationQ[#1[[1,2]]],
				UnitConvert[#1,{QuantityUnit[#1[[1,1]]],"Molar"}],
				#1
			]
		]&,
		{in,observedSpecs}
	];

	resolveTrainingDataInput[trajectories,standardCurvePacket, observedSpecs, assayWells]

	];

resolveTrainingDataInput[in:{{_,_,TrajectoryFormatP,_}..},standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[in[[;;,3]],standardCurvePacket,observedSpecs,assayWells];
resolveTrainingDataInput[in:{{_,_,{kineticsDataReferenceP,_},_}..},standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[in[[;;,3,;;,1]],standardCurvePacket,observedSpecs,assayWells];
resolveTrainingDataInput[in:{{_,_, {kineticsDataPacketP,_},_}..},standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[in[[;;,3,;;,1]],standardCurvePacket,observedSpecs,assayWells];

resolveTrainingDataInput[in:kineticsProtocolReferenceP,standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[Download[in, Packet[Data]],standardCurvePacket,observedSpecs,assayWells];
resolveTrainingDataInput[in:kineticsProtocolPacketP,standardCurvePacket_,observedSpecs_,assayWells_]:=Module[{dataWellRules},
	If[MatchQ[Data/.in,{Null}],Message[AnalyzeKinetics::NoData,Object/.in];Return[Null]];
	dataWellRules = Map[Rule[Well/.#,Object/.#]&,Download[Data/.in, Packet[Well]]];
	resolveTrainingDataInput[assayWells/.dataWellRules,standardCurvePacket,observedSpecs,assayWells]
];

(* Overloads to download specific fields from data objects *)
resolveTrainingDataInput[in:{ObjectReferenceP[Object[Data, AbsorbanceKinetics]]..},standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[Download[in, Packet[AbsorbanceTrajectories]],standardCurvePacket,observedSpecs,assayWells];

resolveTrainingDataInput[in:{ObjectReferenceP[{Object[Data, FluorescenceKinetics],Object[Data, LuminescenceKinetics]}]..},standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[Download[in, Packet[EmissionTrajectories]],standardCurvePacket,observedSpecs,assayWells];

resolveTrainingDataInput[in:{ObjectReferenceP[Object[Data, FluorescencePolarizationKinetics]]..},standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[Download[in, Packet[ParallelTrajectories]],standardCurvePacket,observedSpecs,assayWells];

resolveTrainingDataInput[in:{ObjectReferenceP[Object[Data, NephelometryKinetics]]..},standardCurvePacket_,observedSpecs_,assayWells_]:=
	resolveTrainingDataInput[Download[in, Packet[TurbidityTrajectories]],standardCurvePacket,observedSpecs,assayWells];

(* Packet lookup *)
resolveTrainingDataInput[infs:{kineticsDataPacketP..},standardCurvePacket_,observedSpecs_,assayWells_]:=Module[
	{trajectoryField,flTrajs,concTrajs,stdc,standardFitFunction},

	trajectoryField=Switch[First[Lookup[infs,Type]],
		Object[Data, AbsorbanceKinetics], AbsorbanceTrajectories,
		Object[Data, FluorescenceKinetics], EmissionTrajectories,
		Object[Data, FluorescencePolarizationKinetics], ParallelTrajectories,
		Object[Data, LuminescenceKinetics], EmissionTrajectories,
		Object[Data, NephelometryKinetics], TurbidityTrajectories
	];

	flTrajs = First/@(trajectoryField/.infs);

	resolveTrainingDataInput[flTrajs,standardCurvePacket,observedSpecs,assayWells]
];




(* ::Subsubsection:: *)
(*resolveAnalyzeKineticRatesInputsAndOptions*)


(* go to info so we don't have to check this a bunch of times in the sub-resolutions *)
resolveAnalyzeKineticRatesInputsAndOptions[in:kineticsProtocolReferenceP, reactionModel_, userEquations_, ops0_List]:=
	resolveAnalyzeKineticRatesInputsAndOptions[Download[in], reactionModel, userEquations, ops0];

resolveAnalyzeKineticRatesInputsAndOptions[in_, reactionModel_, userEquations_, safeOps_List] := Module[
	{
		resolvedOps, standardCurvePacket, standardCurveOption,failedOut={Null,Null,Null,Null,Null},correctOptionLength,
		trainingDataSets,reactionList,trajectoryList,domain,rateGuesses,allMechanismSpecies, optOps,
		observedSpecsLists,assayWells,injsLists,initConcLists,initVolLists,debug=False,n,refDatas,
		geometricMean
	},

	correctOptionLength[val_,optName_]:=If[MatchQ[Length[val],n],
		True,
		(
			Message[Error::InvalidAnalyzeKineticsOption,optName,n,val];
			False
		)
	];

	(* resolve ReactionMechanism input *)
	reactionList = Switch[reactionModel,
		NamedReactionP,	NucleicAcids`Private`toFullImplicitReactions[NamedReactions[reactionModel]],
		Null|{}, {},
		_, NucleicAcids`Private`toFullImplicitReactions[reactionModel]
	];

	allMechanismSpecies = Simulation`Private`allReactionSpecies[reactionList];

	(* first resolve standard curve *)
	{standardCurvePacket,standardCurveOption} = resolveAnalyzeKineticRatesStandardCurve[Lookup[safeOps,StandardCurve],in, safeOps];

	(* then resolve observed species, because need this for input resolution *)
	assayWells = resolveAnalyzeKineticRatesAssayWells[Lookup[safeOps,AssayWells],in,safeOps];
	If[MatchQ[assayWells,{}],Message[Error::NoAssayWells,Object/.in];Return[failedOut]];
	n = Length[assayWells];

	(*
		then resolve observed species, because need this for input resolution
		make sure all observed species exist in ReactionMechanism
	 *)
	observedSpecsLists = resolveTrainingDataObservedSpecies[Lookup[safeOps,ObservedSpecies],in,assayWells,allMechanismSpecies];
	If[And[userEquations===Null, !ContainsAll[allMechanismSpecies,Union[Flatten[observedSpecsLists]]]],
		Message[Error::InvalidObservedSpecies,Complement[Union[Flatten[observedSpecsLists]],allMechanismSpecies]];
		Return[failedOut]
	];
	If[!correctOptionLength[observedSpecsLists,ObservedSpecies],Return[failedOut]];

	(* then resolve input to {_Trajectory..} *)
	trajectoryList = resolveTrainingDataInput[in,standardCurvePacket,observedSpecsLists,assayWells];

	If[MatchQ[trajectoryList,Null],Return[failedOut]];

	initVolLists = resolveAnalyzeKinetcRatesInitialVolumeOption[Lookup[safeOps,InitialVolume],in,assayWells,safeOps];

	If[!correctOptionLength[initVolLists,InitialVolume],Return[failedOut]];

	injsLists = resolveAnalyzeKinetcRatesInjectionsOption[Lookup[safeOps,Injections],in,assayWells,safeOps];

	If[!ContainsAll[allMechanismSpecies,Union[Flatten[injsLists[[;;,;;,2]]]]],
		Message[Error::InvalidInjectionSpecies,Complement[Union[Flatten[injsLists[[;;,;;,2]]]],allMechanismSpecies]];
		Return[failedOut]
	];
	If[!correctOptionLength[injsLists,Injections],Return[failedOut]];
	initConcLists = resolveAnalyzeKinetcRatesInitialConcentrationOption[Lookup[safeOps,InitialConcentration],in,assayWells,trajectoryList,safeOps];

	If[!correctOptionLength[initConcLists,InitialConcentration],Return[failedOut]];

	domain = resolveAnalyzeKineticRatesOptionsDomain[trajectoryList, Lookup[safeOps, Domain]];

	geometricMean = MatchQ[userEquations,Null];
	rateGuesses = resolveRateGuesses[reactionList,Lookup[safeOps,Rates],Lookup[safeOps,OptimizationType],geometricMean];

	refDatas = resolveAnalyzeKineticRatesDataReference[in,assayWells];

	(* construct training data array *)
	trainingDataSets = Transpose[{
		initConcLists,
		injsLists,
		trajectoryList,
		initVolLists
	}];

	optOps = resolveAnalyzeKineticRatesOptionsOptimizationOptions[Lookup[safeOps, OptimizationOptions]];

	(* resolve remainder of options *)
	resolvedOps = ReplaceRule[safeOps,
		{
			OptimizationOptions -> optOps,
			Domain -> domain,
			StandardCurve->standardCurveOption,
			Rates -> rateGuesses,
			ObservedSpecies -> observedSpecsLists,
			AssayWells -> assayWells,
			Injections -> injsLists,
			InitialConcentration -> initConcLists,
			InitialVolume -> initVolLists,
			InitialSpecies -> Replace[Lookup[safeOps,InitialSpecies],Automatic->Null],
			PrimaryInjectionSpecies -> Replace[Lookup[safeOps,PrimaryInjectionSpecies],Automatic->Null],
			SecondaryInjectionSpecies -> Replace[Lookup[safeOps,SecondaryInjectionSpecies],Automatic->Null],
			TertiaryInjectionSpecies -> Replace[Lookup[safeOps,TertiaryInjectionSpecies],Automatic->Null],
			Upload -> resolveInformOption[Lookup[safeOps,Upload],Lookup[safeOps,Output],AnalyzeKinetics]
		}
	];


	{resolvedOps, standardCurvePacket, trainingDataSets, reactionList, userEquations, refDatas}

];


resolveAnalyzeKineticRatesOptionsOptimizationOptions[optOps_List] := Module[
	{li},
	li = AllTrue[Last /@ optOps, (MatchQ[#, Alternatives[Infinity, Automatic, _Integer]] || (MachineNumberQ[#] && MatchQ[Re[#], #])) &];
	If[TrueQ[li], optOps, Message[AnalyzeKinetics::InvalidOptimizationOptions]; {AccuracyGoal -> 6, PrecisionGoal -> 6}]
];


resolveAnalyzeKineticRatesOptionsDomain[in_, domain: {_?TimeQ, _?TimeQ}] := Convert[domain,Second];
resolveAnalyzeKineticRatesOptionsDomain[in_, domain: {_?TimeQ, All}] := {Convert[First[domain],Second], Second*Max[Flatten[Map[#[Time]&, in]]]};
resolveAnalyzeKineticRatesOptionsDomain[in_, domain: {All, _?TimeQ}] := {Second*Min[Flatten[Map[#[Time]&, in]]],Convert[Last[domain],Second]};
resolveAnalyzeKineticRatesOptionsDomain[in_, All |{All,All}] := in[[1]][XUnit]*{Min[#], Max[#]} & @ Flatten[Map[#[Time]&, in]];


resolveAnalyzeKineticRatesOptionsRateIntervals[unresolvedRateIntervals_] := Module[
	{resolvedRateIntervals},
	resolvedRateIntervals = unresolvedRateIntervals;
	resolvedRateIntervals = Replace[resolvedRateIntervals,Rule[k_,{kmin_,kmax_}]:>Rule[k,{k,kmin,kmax}],{1}];
	resolvedRateIntervals = Replace[resolvedRateIntervals,Rule[k_,Folding]:>Rule[k,{k,10^-3,10}],{1}];
	resolvedRateIntervals = Replace[resolvedRateIntervals,Rule[k_,Hybridization]:>Rule[k,{k,10^3,10^6}],{1}];
	resolvedRateIntervals = Replace[resolvedRateIntervals,Rule[k_,Melting|Dissociation]:>Rule[k,{k,10^-5,10^-2}],{1}];
	resolvedRateIntervals
];


resolveTrainingDataObservedSpecies[spec:Except[Automatic,SpeciesP],in_,assayWells_List,allSpecs_]:=Table[{spec},{Length[assayWells]}];
resolveTrainingDataObservedSpecies[specss:{{SpeciesP..}..},in_,assayWells_List,allSpecs_]:=specss;
resolveTrainingDataObservedSpecies[Automatic,in:{_Trajectory..},assayWells_,allSpecs_]:=Map[#[Species]&,in];
resolveTrainingDataObservedSpecies[Automatic,in:{{_,_,_Trajectory,_}..},assayWells_,allSpecs_]:=Map[#[Species]&,in[[;;,3]]];
resolveTrainingDataObservedSpecies[Automatic,in_,assayWells_,allSpecs_]:=Table[ObservableSpecies[allSpecs],{Length[assayWells]}];


resolveAnalyzeKineticRatesAssayWells[assayWells_List,in_,safeOps_List]:=assayWells;
resolveAnalyzeKineticRatesAssayWells[Automatic,in:{kineticsDataReferenceP..},safeOps_List]:=Download[in,Well];
resolveAnalyzeKineticRatesAssayWells[Automatic,protInfo:kineticsProtocolPacketP,safeOps_List]:=Module[{wellRules},
	wellRules = protocolWellRules[protInfo,safeOps];
	Keys[Select[wellRules,And[MatchQ[#[Sample], ObjectP[Object[Sample]]],!MatchQ[#[Injections],{}]]&]]
];
resolveAnalyzeKineticRatesAssayWells[Automatic,in_,safeOps_List]:=Map[StringJoin["A",ToString[#]]&,Range[Length[in]]];


resolveAnalyzeKinetcRatesInitialVolumeOption[Automatic,in:{{_,_,_Trajectory,_}..},assayWells_,safeOps_List]:=in[[;;,4]];
resolveAnalyzeKinetcRatesInitialVolumeOption[vol_?VolumeQ,protInfo_,assayWells_List,safeOps_List]:= Table[vol,{Length[assayWells]}];
(*resolveAnalyzeKinetcRatesInitialVolumeOption[vols:{_?VolumeQ..},protInfo_,assayWells_List]:= PadRight[vols,{Length[assayWells]},Last[vols]];*)
resolveAnalyzeKinetcRatesInitialVolumeOption[vols:{_?VolumeQ..},protInfo_,assayWells_List,safeOps_List]:= vols;
resolveAnalyzeKinetcRatesInitialVolumeOption[Automatic,in: {kineticsDataReferenceP..},assayWells_List,safeOps_List]:= Module[{},
	Map[protocolWellRules[#,safeOps][InitialVolume]&,in]
];
resolveAnalyzeKinetcRatesInitialVolumeOption[Automatic,protInfo: kineticsProtocolPacketP,assayWells_List,safeOps_List]:= Module[{},
	InitialVolume /. (assayWells /. protocolWellRules[protInfo,safeOps])
];
resolveAnalyzeKinetcRatesInitialVolumeOption[Automatic,in_,assayWells_List,safeOps_List]:=Table[150*Microliter,{Length[assayWells]}];

resolveAnalyzeKinetcRatesInitialConcentrationOption[Automatic,in:{{_,_,_Trajectory,_}..},assayWells_,trajectoryList_,safeOps_]:=in[[;;,1]];
resolveAnalyzeKinetcRatesInitialConcentrationOption[ic:{_Rule..},protInfo_,assayWells_,trajectoryList_,safeOps_]:=Table[ic,{Length[assayWells]}];
(*resolveAnalyzeKinetcRatesInitialConcentrationOption[ics:{{_Rule..}..},protInfo_,assayWells_,trajectoryList_,safeOps_]:=PadRight[ics,{Length[assayWells]},{Last[ics]}];(* need {_Last} b/c PadRight sees the inner list and interprets it wrong *)*)
resolveAnalyzeKinetcRatesInitialConcentrationOption[ics:{{_Rule..}..},protInfo_,assayWells_,trajectoryList_,safeOps_]:=ics;
resolveAnalyzeKinetcRatesInitialConcentrationOption[Automatic,protInfo: kineticsProtocolPacketP,assayWells_,trajectoryList_,safeOps_]:=Module[{wellRules},
	wellRules = protocolWellRules[protInfo,safeOps];
	Map[{Rule[If[MatchQ[Lookup[safeOps,InitialSpecies],Automatic],Species/.#,Lookup[safeOps,InitialSpecies]],Replace[Concentration/.#,{Null->0*Micromolar,(0|0.)->0*Micromolar}]]}&,(assayWells/.wellRules)]
];
resolveAnalyzeKinetcRatesInitialConcentrationOption[Automatic,in:{kineticsDataReferenceP..},assayWells_List,trajectoryList_,safeOps_List]:= Module[{},
	Join@@Map[resolveAnalyzeKinetcRatesInitialConcentrationOption[Automatic,Download[Download[#, Protocol]],{Download[#, Well]},trajectoryList,safeOps]&,in]
];
resolveAnalyzeKinetcRatesInitialConcentrationOption[Automatic, in_, assayWells_, trajectoryList_, safeOps_]:=Module[{},
	Map[Module[{specs,startConc,un},
		specs = #[Species];
		(* could Mean up until first injection, if that info is available *)
		startConc = Mean[TrajectoryRegression[#,specs][[1;;1]]];
		un = Last[#[Units]];
		Thread[Rule[specs,startConc*un]]
	]&,trajectoryList]
];


resolveAnalyzeKinetcRatesInjectionsOption[Automatic,in:{{_,_,_Trajectory,_}..},assayWells_,safeOps_List]:= in[[;;,2]];
resolveAnalyzeKinetcRatesInjectionsOption[inj:{{_?TimeQ,_,__}},in_,assayWells_List,safeOps_List]:= Table[inj,{Length[assayWells]}];
resolveAnalyzeKinetcRatesInjectionsOption[injs:{{{_?TimeQ,_,__}..}..},in_,assayWells_List,safeOps_List]:= injs;
resolveAnalyzeKinetcRatesInjectionsOption[Automatic,in:{(_Trajectory|QuantityArrayP[]|CoordinatesP)..},assayWells_List,safeOps_List]:= Table[{},{Length[assayWells]}];
resolveAnalyzeKinetcRatesInjectionsOption[Automatic,in: {kineticsDataReferenceP..},assayWells_List,safeOps_List]:= Module[{},
	Map[protocolWellRules[#,safeOps][Injections]&,in]
];
resolveAnalyzeKinetcRatesInjectionsOption[Automatic,protInfo: kineticsProtocolPacketP,assayWells_List,safeOps_List]:= Module[{},
	Injections/.(assayWells/.protocolWellRules[protInfo,safeOps])
];


resolveAnalyzeKineticRatesDataReference[in: {kineticsDataReferenceP..},assayWells_]:= Map[Link[#,RateFittingAnalyses]&,in];
resolveAnalyzeKineticRatesDataReference[in: {kineticsDataPacketP..},assayWells_]:= resolveAnalyzeKineticRatesDataReference[Object/.in,assayWells];
resolveAnalyzeKineticRatesDataReference[in: kineticsProtocolPacketP,assayWells_]:=
    resolveAnalyzeKineticRatesDataReference[Download[Pick[Data/.in,Download[Data/.in, Well],Alternatives@@assayWells],Object],assayWells];
resolveAnalyzeKineticRatesDataReference[in_,assayWells_]:= {Null};


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeKineticRatesStandardCurve*)



resolveAnalyzeKineticRatesStandardCurve[akr:ObjectReferenceP[Object[Analysis, Kinetics]],in_,safeOps_List]:=
	{Download[Download[akr,StandardCurve]],akr};
resolveAnalyzeKineticRatesStandardCurve[prot:kineticsProtocolReferenceP,in_,safeOps_List]:=
	{Download[Download[prot,StandardCurve]],prot};
resolveAnalyzeKineticRatesStandardCurve[Automatic,in:kineticsProtocolPacketP,safeOps_List]:=
	{Download[Lookup[in, StandardCurve]], Lookup[in, Object]};

resolveAnalyzeKineticRatesStandardCurve[Automatic,in:{ObjectReferenceP[Object[Data]]..},safeOps_List]:=
	resolveAnalyzeKineticRatesStandardCurve[Download[First[Cases[Download[in, Protocol],kineticsProtocolP]],Object],in,safeOps];

(* default to default fitting *)
resolveAnalyzeKineticRatesStandardCurve[standardCurveOption_,in_,safeOps_List,___]:=resolveStandardCurvePacket[standardCurveOption,safeOps];

(* no standard curve  *)
resolveAnalyzeKineticRatesStandardCurve[standardCurveOption:Automatic,___]:={Null,Null};


(* ::Subsubsection:: *)
(*resolution helpers*)


resolveRateGuesses[rxnList_,obj: ObjectReferenceP[Object[Simulation, Kinetics]],optMethod_,geometricMean:(True|False)]:=Module[{inputRates,objMech,objRates,rateRules},
	objMech = Download[obj, ReactionMechanism];
	inputRates = Flatten[reactionsToRates[rxnList]];
	objRates = Flatten[objMech[Rates]];
	rateRules=DeleteCases[Thread[Rule[inputRates,objRates]],Rule[_?NumericQ,_?NumericQ]];
	resolveRateGuesses[rxnList,rateRules,optMethod,geometricMean]
];
resolveRateGuesses[rxnList_,rates0_List,optMethod_,geometricMean:(True|False)]:=Module[{defaultRates,specifiedRates,out},
	specifiedRates=Map[reformatOneRateVarInterval[#,optMethod,geometricMean]&,rates0];
	defaultRates = N@Flatten[Map[defaultReactionRateGuess[#,optMethod,geometricMean]&,rxnList]];
	out=DeleteDuplicatesBy[Join[specifiedRates,defaultRates],First];
	out
];
reformatOneRateVarInterval[k_->{min_,max_},Global,_]:=k->{min,max};
reformatOneRateVarInterval[k_->{min_,max_},Local|Manual,True]:=k->10^Mean[{Log10[min],Log10[max]}];
reformatOneRateVarInterval[k_->{min_,max_},Local|Manual,False]:=k->Mean[{min,max}];
reformatOneRateVarInterval[k_->(0|0.0),Global,False]:=k->{-0.5,1.5};
reformatOneRateVarInterval[k_->k0_,Global,False]:=k->Sort[{0.5*k0,1.5*k0}];
reformatOneRateVarInterval[k_->(0|0.0),Global,True]:=k->Sort[{0.1,10}];
reformatOneRateVarInterval[k_->(1|1.0),Global,True]:=k->10^{0.75,1.25};
reformatOneRateVarInterval[k_->k0_,Global,True]:=k->Sort[10^{0.75*Log10[k0],1.25*Log10[k0]}];
reformatOneRateVarInterval[k_->k0_,Local|Manual,_]:=k->k0;


(* ::Subsection:: *)
(*Calculate*)


(* ::Subsubsection:: *)
(*calculateKineticRateFields*)

calculateKineticRateFields[assoc:SingletonAssociationP]:=Module[{resolvedInputs,trainingSpec,rxnsFull,userEquations,resolvedOps,out},
	resolvedInputs = assoc[ResolvedInputs];
	trainingSpec = resolvedInputs[TrainingData]; (* :{{(ic,inj,traj,vol}..}) *)
	rxnsFull = resolvedInputs[Reactions];
	userEquations = resolvedInputs[Equations];
	resolvedOps = assoc[ResolvedOptions];
	out = calculateKineticRateFields[trainingSpec, rxnsFull, userEquations, Normal@resolvedOps];
	<|Result -> out|>

];

calculateKineticRateFields[trainingSpec:{{(*ic*)_,(*inj*)_,(*traj*)_,(*vol*)_}..},rxnsFull_,userEquations_,resolvedOps_List]:=Module[
  {allSpecs,equationss,unknownRates,exprToMinimize,tvars,resTotal,fittedPars,log=Log,rateScalingRules,specVarRules,
    ics0,injs0,ess,estv,xys0,rateGuessRules,ratesWithGuesses,rxnsFullScaled,debug=True,
	  ics,injs,tfs,trajs,scaleVals,allRates,count=0,initialVolumes,xys,obsSpecs,predictedTrajectories,startTime,
		obsEqnSpecies,targetUnits,inputUnit},

	If[Or[MatchQ[resolvedOps,Null|$Failed],MatchQ[trainingSpec,Null|$Failed]],
		Return[$Failed]
	];

	startTime = AbsoluteTime[];

	(* all species in the mechanism *)
	allSpecs = Simulation`Private`allReactionSpecies[rxnsFull];

	(* separate out the training data components *)
  {ics0,injs0,trajs,initialVolumes} = Transpose[trainingSpec];

	(* targetUnits = {Second,Molar}; *)
	targetUnits = First[trajs]["Units"];

	(* observed species in the training data *)
	obsSpecs = #[Species]&/@trajs;

	inputUnit = Units[First[Values[Flatten[ics0]]]];
	inputUnit = If[ConcentrationQ[inputUnit], Molar, CanonicalUnit[inputUnit]];

	ics0 = resolveInitialCondition[#,inputUnit]&/@ics0;

	(* strip units off everything *)
	initialVolumes = resolveInitialVolume/@initialVolumes;
	injs0 = resolveInjections/@injs0;

	(* ---- DATA ----- *)
	(* convert the training data concentration trajectories to {Second,Molar} VERY IMPORTANT *)
	xys0 = Convert[#[Coordinates],#[Units],targetUnits]&/@trajs;

	(* filter data outside of Domain option *)
	xys0 = Map[selectInDomain[#, Unitless[Lookup[resolvedOps, Domain],First[targetUnits]]] &, xys0,{2}];

	(* scale everything to make optimization easier *)
	{ics,injs,xys,scaleVals} = If[userEquations===Null,
		Transpose[scaleKineticProblem[ics0,injs0,xys0,True]],
		{ics0, injs0, xys0, Table[1,Length[xys0]]}
	];

	rxnsFullScaled = Map[logKnownRates[scaleSecondOrderRates[#,First[scaleVals]]]&,rxnsFull];

	(* switch to using symbolic species for everything *)
	specVarRules = Map[#->Unique[x]&,allSpecs];

	obsEqnSpecies = obsSpecs /. specVarRules;

	(* ------ EQUATIONS ------ *)
	(* the ODEs desribing the kinetics *)

	If[userEquations===Null,
		tvars = Table[Unique[t],{Length[trainingSpec]}];
		{rxnEquations, icEquations, equationss} = Transpose[MapThread[
  		Function[{ic,inj,tv,vol0},Simulation`Private`formatODESystem[rxnsFullScaled/.specVarRules,ic/.specVarRules,inj/.specVarRules,vol0,tv,log]],
  		{ics,injs,tvars,initialVolumes}
		]];,
		icEquations = ics /. { Rule[s_Symbol,val_]:>Equal[s[0],val]};

		(* rxnEquations = Table[userEquations,Length[xys]]; *)
		rxnEquations = Map[userEquations /. Replace[#,Rule[s_Symbol, val_] :> Rule[s[0], val], {1}]&,ics];

		tvars = Map[FirstCase[#,Derivative[_Integer][_Symbol][t_]:>t,$Failed,Infinity]&,rxnEquations];
	];

	(* already in seconds *)
	tfs = resolveSimulationTime[Max[Flatten[#,1][[;;,1]]],First[targetUnits]]&/@xys;

		(* full list of species from reactions -- parse things like A[t] and A'[t] *)
		allSpecies = MapThread[
			Union[Cases[#1, h_[#2] :> h, Infinity] /. Derivative[_][s_] :> s]&,
			{rxnEquations,tvars}
		];

		icDefaults = Map[
			(Function[spec,spec[0]==0.] /@ #) &,
			allSpecies
		];

		allEquations = MapThread[
			Join[#1,DeleteDuplicatesBy[Join[#2,#3],First]]&,
			{rxnEquations,icEquations,icDefaults}
		];
		tvarsOld = tvars;
		tvars = Table[Unique["t"],Length[allEquations]];
		allEquations=MapThread[#1/.#2->#3&,{allEquations,tvarsOld,tvars}];

		(* rates and guesses *)
		(* full list of rates from the equations *)
		allRates = DeleteCases[
			Union[Cases[allEquations, _Symbol, Infinity]],
			Alternatives@@tvars | Alternatives@@tvarsOld
		];

		(* unknown symbolic rates *)
	  unknownRates = DeleteCases[allRates,_?NumericQ];
		(* must have some unknown rates to solve for *)
		If[MatchQ[unknownRates,{}],
			Message[Error::NoUnknownRates];
			Return[$Failed]
		];

		(* get initial guesses for the rates *)
		rateGuessRules = If[userEquations===Null,
			Join[Map[#[[1]]->Prepend[Log10[ToList[#[[2]]]],#[[1]]]&,Lookup[resolvedOps,Rates]],Map[#->#&,unknownRates]],
			Join[Map[#[[1]]->Prepend[ToList[#[[2]]],#[[1]]]&,Lookup[resolvedOps,Rates]],Map[#->#&,unknownRates]]
		];
		ratesWithGuesses = N@Replace[unknownRates,rateGuessRules,{1}];

		(* this is the thing we are minimizing.  The sum of the error expression across all training data *)
	  exprToMinimize = Total[
			MapThread[
				Function[
					{xy,eqns,tf,spec,tv,scale,allSpecs},
			    		errorExpression[xy,eqns,allSpecs,{tv,0.,tf},spec,unknownRates,tv,scale]
				],
	    	{xys,allEquations,tfs,obsEqnSpecies,tvars,scaleVals,allSpecies}
	  	]
		];

		(* Solve the optimization problem.  which function solves it depends on teh OptimizationType option *)
		List[
	  With[
			{
				exprToMinimize=exprToMinimize,
				optFunc = Switch[Lookup[resolvedOps,OptimizationType],Global,NMinimize,Local,FindMinimum,Manual,noOptimization]
			},
	    Quiet[
				Check[
					{resTotal,fittedPars} = optFunc[
						exprToMinimize,
						ratesWithGuesses,
						Evaluate[Sequence@@Lookup[resolvedOps,OptimizationOptions]],
						EvaluationMonitor:>(count++)
					],
					(*
					If messages were thrown, just return the initial guesses.
					This is normally the behavior of the solver functions anyways when these messages occur, but we will be extra explicit.
					*)
					Message[AnalyzeKinetics::PoorOptimization];
				],
				{FindMinimum::lstol,FindMinimum::sdprec,FindMinimum::fmgz,InterpolatingFunction::dmval,NMinimize::cvmit}
			]
	  ];
		(* 12.1 error *)
		{NMinimize::ctuc}
		];

	(* scale the rates back from exponents *)
	fittedParsFinal = If[userEquations===Null,
		MapAt[10^#&, fittedPars, {;;, 2}],
		fittedPars
	];

	(* predicted trajectores is the new model's attempt to match the training data *)
	predictedTrajectories =
		MapThread[
			Function[{ic,inj,traj,vol,tf,spec,eqns},
				Lookup[ECL`SimulateKinetics[
					If[MatchQ[rxnsFull,Null|{}],eqns,rxnsFull]/.fittedParsFinal,
						ic,tf, Injections->inj, Volume->vol, ObservedSpecies->spec, Upload->False, Output->Result
					],
					Trajectory
				]
			],
			Join[Transpose[trainingSpec],{tfs,obsSpecs,rxnEquations}]
	];

	(*  *)
	{
		Residual -> resTotal,
		SumSquaredError -> First[scaleVals]^2*resTotal (* scaleVals is a list but all elements are the same, so just use first *),
		NumberOfIterations -> count,
		Replace[Rates] -> Transpose[{unknownRates,unknownRates/.fittedParsFinal}],
		Replace[TrainingData] -> MapAt[ToState,trainingSpec,{;;,1}],
		PredictedTrajectories -> predictedTrajectories,
		FitMechanism -> ToReactionMechanism[rxnsFull],
		ReactionMechanism -> ToReactionMechanism[rxnsFull /. fittedParsFinal],
		Replace[Species] -> allSpecs,
		Replace[KineticsEquations]->First[rxnEquations] (* this part of equations (without ICs) are all the same, so take first *)
	}

];


(*
	For 'Manual' method don't do anything, just use the given values
*)
noOptimization[exprToMinimize_,ratesWithGuesses_,optimizationOps___]:=Module[{},
	{
		exprToMinimize /. Rule@@@ratesWithGuesses,
		Rule@@@ratesWithGuesses
	}
];

resolveSimulationTime[tF_Quantity,xUnit_]:=Unitless[tF,xUnit];
resolveSimulationTime[tF_?NumericQ,xUnit_]:=tF;

resolveInitialVolume[vol_Quantity]:=Unitless[vol,Liter];
resolveInitialVolume[vol_?NumericQ]:=vol;

resolveInitialCondition[st_State,yUnit_]:=resolveInitialCondition[st[Rules],yUnit];
resolveInitialCondition[ics_,yUnit_]:=Map[ Rule[#[[1]], Replace[#[[2]],q_Quantity:>Unitless[q,yUnit]]]& ,ics];

resolveInjections[injs_]:=Map[resolveOneInjection[#]&,injs];
resolveOneInjection[inj:{startTime:TimeP,spec_,vol:VolumeP,conc:ConcentrationP}]:={
	Unitless[startTime,Second],
	spec,
	Unitless[vol,Liter],
	Null,
	Unitless[conc,Molar]
};
resolveOneInjection[inj:{startTime:TimeP,spec_,vol:VolumeP,flowRate_,conc:ConcentrationP}]:={
	Unitless[startTime,Second],
	spec,
	Unitless[vol,Liter],
	Unitless[flowRate,Liter/Second],
	Unitless[conc,Molar]
};


(* ::Subsubsection::Closed:: *)
(*calculate helpers*)


(* a+b -> c *)
defaultReactionRateGuess[{Equilibrium[_Plus|_Times,Except[_Plus|_Times]],kf_,kb_},optMethod_,geomtricMean_]:=
	Map[reformatOneRateVarInterval[#,optMethod,geomtricMean]&,{kf->10^5,kb->10^-5}];
defaultReactionRateGuess[{Rule[_Plus|_Times,Except[_Plus|_Times]],kf_},optMethod_,geomtricMean_]:=
	Map[reformatOneRateVarInterval[#,optMethod,geomtricMean]&,{kf->10^5}];
(* a+b -> c+d *)
defaultReactionRateGuess[{Equilibrium[_Plus|_Times,_Plus|_Times],kf_,kb_},optMethod_,geomtricMean_]:=
	Map[reformatOneRateVarInterval[#,optMethod,geomtricMean]&,{kf->10^5,kb->10^-5}];
defaultReactionRateGuess[{Rule[_Plus|_Times,_Plus|_Times],kf_},optMethod_,geomtricMean_]:=
	Map[reformatOneRateVarInterval[#,optMethod,geomtricMean]&,{kf->10^5}];
(* a -> b *)
defaultReactionRateGuess[{Equilibrium[Except[_Plus|_Times],Except[_Plus|_Times]],kf_,kb_},optMethod_,geomtricMean_]:=
	Map[reformatOneRateVarInterval[#,optMethod,geomtricMean]&,{kf->1,kb->10^-5}];
defaultReactionRateGuess[{Rule[Except[_Plus|_Times],Except[_Plus|_Times]],kf_},optMethod_,geomtricMean_]:=
	Map[reformatOneRateVarInterval[#,optMethod,geomtricMean]&,{kf->1}];
defaultReactionRateGuess[___]:={};
Clear[errorExpression];
errorExpression[trainingData_,equations_,allSpecs_,{tvar_,t0_,tF_},observedSpec_,unknownRates:{_?NumericQ..},ignore_,scale_]:=Module[
  {sol,specSol,res},
	sol = Simulation`Private`solveReactionODEs[equations,allSpecs,{tvar,t0,tF},{AccuracyGoal->6,PrecisionGoal->6}];
	specSol = Lookup[sol,observedSpec];
	(* don't need to scale here *)
  Quiet[res=computeResidual[specSol,trainingData,1];,{InterpolatingFunction::dprec}];
  res
];
computePredictedValues[f_InterpolatingFunction,times_List,scale_]:=With[{ys=f[times]/scale}, ys];
computeResiduals[f_InterpolatingFunction,xy_,scale_] := (xy[[;;,2]]-computePredictedValues[f,xy[[;;,1]],scale])^2;
computeResidual[f_InterpolatingFunction,xy_,scale_] := (Total[computeResiduals[f,xy,scale]]);
computeResidual[fs:{_InterpolatingFunction..},xys_,scale_] := Total[MapThread[computeResidual[#1,#2,scale]&,{fs,xys}]];


(* ::Subsubsection::Closed:: *)
(*scaling*)


(* ::Text:: *)
(*For scaling, we divide the data by scaling value, and multiply any second-order known/guessed rates BEFORE fitting.*)
(*Then after fitting we divide the fitted rates by the scaling value to end up with the correct values.*)
(*MUST SCALE EVERYTHING THAT TOUCHES A CONCENTRATION*)
(*(data y-values, initial values, injected values, second-order rates, ...)*)


(* If not scaling *)
scaleKineticProblem[ics_,injs_,trajs_,False] := Transpose[{ics,injs,trajs,Table[1,{Length[ics]}]}];
(* return scaled initial condition, scaled xy data, and the scaling value *)
scaleKineticProblem[ics_,injs_,trajs_,True]:=Module[{scaleVal,maxIC,maxConc,maxInj},
  maxIC = Max[ics[[;;,;;,2]]];
  maxConc = Max[Flatten[trajs[[;;,;;,;;,2]]]];
  maxInj = Max[Flatten[injs[[;;,;;,5]]]];
  scaleVal = Norm[DeleteCases[{maxIC,maxConc,maxInj},Infinity|-Infinity]];
	MapThread[
    scaleKineticProblem[#1,#2,#3,scaleVal]&,
    {ics,injs,trajs}
  ]
];
scaleKineticProblem[ic_,inj_,traj_,scaleVal_]:=Module[{scaledIC,scaledInj,scaledTraj},
  scaledIC = MapAt[#/scaleVal&,ic,{All,2}];
  scaledTraj = MapAt[#/scaleVal&,traj,{All,All,2}];
  scaledInj = If[MatchQ[inj,{}],{},MapAt[#/scaleVal&,inj,{All,5}]];
  {scaledIC,scaledInj,scaledTraj,scaleVal}
];


(* multiply by scale val, since this is before the fitting *)
scaleInitialRateGuesses[rateIntervals_,secondOrderRateVars_,scaleVal_?NumberQ]:=Module[{},
  Replace[rateIntervals,Rule[name:(Alternatives@@secondOrderRateVars),{k_,kmin_,kmax_}]:>Rule[name,{k,kmin*scaleVal,kmax*scaleVal}],{1}]
];


scaleSecondOrderRates[{r:Rule[_Plus,_],val_},scaleVal_]:={r,val+Log10[scaleVal]};
scaleSecondOrderRates[{r:Equilibrium[_Plus,_Plus],val_,val2_},scaleVal_]:={r,val+Log10[scaleVal],val2+Log10[scaleVal]};
scaleSecondOrderRates[{r:Equilibrium[_,_Plus],val_,val2_},scaleVal_]:={r,val,val2+Log10[scaleVal]};
scaleSecondOrderRates[{r:Equilibrium[_Plus,_],val_,val2_},scaleVal_]:={r,val+Log10[scaleVal],val2};
scaleSecondOrderRates[rx_,val_]:=rx;


logKnownRates[{r_Rule,val_?NumericQ}]:={r,Log10[val]};
logKnownRates[{r_Equilibrium,val_?NumericQ,val2_?NumericQ}]:={r,Log10[val],Log10[val2]};
logKnownRates[{r_Equilibrium,val_?NumericQ,val2_}]:={r,Log10[val],val2};
logKnownRates[{r_Equilibrium,val_,val2_?NumericQ}]:={r,val,Log10[val2]};
logKnownRates[rx_]:=rx;


(* ::Subsection::Closed:: *)
(*Format*)


(* ::Subsubsection::Closed:: *)
(*formatKineticsPacket*)
formatKineticsPacket[assoc:SingletonAssociationP]:=Module[{kineticsFields,trainingDataSets,refRelations,stdcPacket,resolvedOptions, kineticsPacket},
	kineticsFields = assoc[Result];
	trainingDataSets = assoc[ResolvedInputs][TrainingData];
	refRelations = assoc[ResolvedInputs][Relations];
	stdcPacket = assoc[ResolvedInputs][StandardCurves];
	resolvedOptions = assoc[ResolvedOptions];

	kineticsPacket = formatKineticsPacket[kineticsFields,trainingDataSets,
		assoc[Packet],refRelations,stdcPacket,resolvedOptions
	];

	<|
		Packet -> kineticsPacket
	|>

]

formatKineticsPacket[corePacket_,  trainingData_, standardFieldsStart_, refRelations_, stdcPacket_, resolvedOps_] := Module[
	{packet,stdcObject, tempOut},

	If[Or[MatchQ[resolvedOps,Null|$Failed],MatchQ[corePacket,Null|$Failed]],
		Return[$Failed]
	];

	Association[Join[<|Type -> Object[Analysis, Kinetics]|>,
		standardFieldsStart,
		Association[corePacket],
		<|
			Append[Reference] -> (refRelations /. {Null} -> {}),
			ResolvedOptions -> Normal[resolvedOps],
			StandardCurve -> If[Or[MatchQ[stdcPacket, Null],MatchQ[Lookup[stdcPacket,Object],_Missing]], Null, Link[Lookup[stdcPacket,Object],PredictedValues]]
		|>
	]]
];


(* ::Subsection:: *)
(*Protocol Parsing*)


(* ::Subsubsection::Closed:: *)
(*protocolWellRules*)


Clear[protocolWellRules];
protocolWellRules[protInfo:kineticsProtocolPacketP,safeOps_List]:=protocolWellRules[protInfo,safeOps]=Module[
	{datas,samps,dataWellRules,sampleWellRules,wells,injectionWellRules,injTimeUnit,injVolUnit,primInjs,dataInfs,sampInfs},
	{injTimeUnit,injVolUnit} = Lookup[LegacySLL`Private`typeUnits[Lookup[protInfo,Type]],PrimaryInjections][[{1,3}]];
	{datas,samps,primInjs} = {Data,SamplesIn,PrimaryInjections}/.protInfo;
	If[MatchQ[datas,{Null}],Return[<||>]];
	dataInfs = Download[datas, Packet[Well]];
	sampInfs = Download[samps, Packet[Well, Volume, Concentration]];
	sampleMolecules=Download[samps, Composition[[1]][[2]][Molecule]];

	dataWellRules = Map[Rule[Well/.#,{Rule[Data,Object/.#]}]&,dataInfs];

	sampleWellRules = MapThread[Rule[Well/.#1,{Rule[Sample,Object/.#1],Rule[InitialVolume,Volume /. #1],Rule[Concentration,Concentration/.#1],Rule[Species,#2]}]&,{sampInfs,sampleMolecules}];

	wells = Union[sampleWellRules[[;;,1]]];

	(* injections are index-matched against samples.  Only way to pair them with the well at the moment *)
	injectionWellRules = protocolInjectionToFullInjection[protInfo,sampInfs,Lookup[safeOps,{PrimaryInjectionSpecies,SecondaryInjectionSpecies,TertiaryInjectionSpecies}]];
	Association[
		Map[
			#1->Association[Join[#/.{dataWellRules,sampleWellRules,injectionWellRules}]
			]&,
			wells
		]
	]
];
protocolWellRules[dat:kineticsDataReferenceP,safeOps_List]:=Module[{},
	(Download[dat, Well]) /. protocolWellRules[Download[Download[dat, Protocol], Packet[Data,SamplesIn,PrimaryInjections, SecondaryInjections, TertiaryInjections, PrimaryInjectionFlowRate, SecondaryInjectionFlowRate, TertiaryInjectionFlowRate, QuaternaryInjectionFlowRate]],safeOps]
];


protocolInjectionToFullInjection[protInfo: kineticsProtocolPacketP,sampInfs_,{spec1_,spec2_,spec3_}]:=Module[
	{gmUnits,firstInjs,secondInjs,thirdInjs,allWells,flowRate1,flowRate2,flowRate3,flowrate4},
	gmUnits = PrimaryInjections/.LegacySLL`Private`typeUnits[Lookup[protInfo,Type]];
	allWells = Well/.sampInfs;
	{flowRate1,flowRate2,flowRate3,flowrate4} = Lookup[protInfo,{PrimaryInjectionFlowRate,SecondaryInjectionFlowRate,TertiaryInjectionFlowRate,QuaternaryInjectionFlowRate}];
	firstInjs = Map[oneProtocolInjectionToFullInjection[#,spec1,flowRate1]&,PrimaryInjections/.protInfo];
	secondInjs = Map[oneProtocolInjectionToFullInjection[#,spec2,flowRate2]&,SecondaryInjections/.protInfo];
	thirdInjs = Map[oneProtocolInjectionToFullInjection[#,spec3,flowRate3]&,TertiaryInjections/.protInfo];

	Replace[
		MapThread[Rule[#1,{Injections->#2}]&,{allWells,Transpose[DeleteCases[{firstInjs,secondInjs,thirdInjs},{}]]}],
		Rule[w_,{Injections->{{Null..}}}]:>Rule[w,{Injections->{}}],
		{1}
	]
];
oneProtocolInjectionToFullInjection[{_,Null,_},spec_,flowRate_]:={Null,Null,Null,Null,Null};
oneProtocolInjectionToFullInjection[{time_,samp_,vol_},spec_,flowRate_]:=Module[{conc,specSample},
	{conc,specSample} = Download[samp, {Concentration,Composition[[1]][[2]][Molecule]}];
	{
		time,
		If[MatchQ[spec,Automatic],specSample,spec],
		vol,
		Null, (* flowRate is buggy still *)
		(*	flowRate, (* already has units b/c single field *)*)
		conc
	}
];


(* ::Subsection::Closed:: *)
(*Observable Species*)


(* ::Subsubsection:: *)
(*ObservableSpecies*)


ObservableSpecies[mech_]:=ObservableSpecies[mech,Modification["Fluorescein"]];
ObservableSpecies[mech_,observableMotif:Modification["Fluorescein"]]:=
ObservableSpecies[mech,observableMotif,Modification["Dabcyl"]];
ObservableSpecies[mech_ReactionMechanism,observableMotif_,quenchingMotif_]:=Module[{specList},
	specList = mech[Species];
	ObservableSpecies[specList,observableMotif,quenchingMotif]
];
ObservableSpecies[specList:{_Structure...},observableMotif_,quenchingMotif_]:=
	Select[specList,observableQ[#,observableMotif,quenchingMotif]&];
ObservableSpecies[___]:=$Failed;

observableQ[c_Structure,observableMotif:Modification["Fluorescein"]]:=
observableQ[c,observableMotif,Modification["Dabcyl"]];
observableQ[c_Structure,observableMotif_,quenchingMotif_]:=Module[
	{observableMotifPositions,quenchingMotifPositions,pairs},
	observableMotifPositions=Position[c,observableMotif][[;;,2;;3]];
	(* no observable things present *)
	If[MatchQ[observableMotifPositions,{}],Return[False]];
	quenchingMotifPositions = Position[c,quenchingMotif][[;;,2;;3]];
	(* observable things present and nothing to quench it *)
	If[MatchQ[quenchingMotifPositions,{}],Return[True]];
	pairs = (List@@@c[Bonds])[[;;,;;,1;;2]];
	(* if nothing is paired then nothing can be quenched *)
	If[MatchQ[pairs,{}],Return[True]];
	(* observable if no pairs joining strands with the observable and quencher *)
	!MemberQ[pairs,pairedPairsP[observableMotifPositions,quenchingMotifPositions]]
];

pairedPairsP[posA:{{_Integer,_Integer}..},posB:{{_Integer,_Integer}..}]:=
	Alternatives@@Map[pairedPairsP@@#&,Join[Tuples[{posA,posB}],Tuples[{posB,posA}]]];
pairedPairsP[{strA_Integer,motA_Integer},{strB_Integer,motB_Integer}]:=Alternatives[{{strA,motA-1},{strB,motB+1}},{{strA,motA+1},{strB,motB-1}}]/;And[motA>1,motB>1];
pairedPairsP[{strA_Integer,motA_Integer},{strB_Integer,motB_Integer}]:={{strA,motA+1},{strB,motB-1}}/;motB>1;
pairedPairsP[{strA_Integer,motA_Integer},{strB_Integer,motB_Integer}]:={{strA,motA-1},{strB,motB+1}}/;motA>1;
pairedPairsP[{strA_Integer,motA_Integer},{strB_Integer,motB_Integer}]:=Null;



(* ::Subsection:: *)
(*Goodness of Fit*)


(* ::Subsubsection:: *)
(*ObjectiveFunctionTable*)


Options[ObjectiveFunctionTable]={AdditionalPoints->{}};


kRangeP = Alternatives[
	{RateFormatP,{_?NumberQ...}},
	{RateFormatP,_?NumberQ,_?NumberQ},
	{RateFormatP,_?NumberQ,_?NumberQ,_?NumberQ},
	{RateFormatP,_?NumberQ,_?NumberQ,Log},
	{RateFormatP,_?NumberQ,_?NumberQ,{Log,_?NumberQ}}
];

kineticTrainingDataP = Alternatives[
	{PacketP[Object[Simulation, Kinetics]]..},
	{{StateFormatP|{__Rule}, InjectionsFormatP | {}|{{Null..}..}, TrajectoryFormatP, VolumeP}...}
];

ObjectiveFunctionTable[rxs_,kts:kineticTrainingDataP,kRanges:{kRangeP...},ops:OptionsPattern[]]:=Module[{trainingData},Module[{evaluatedRanges,additionalPoints},
	evaluatedRanges = resolveRateRanges[kRanges];
	additionalPoints = OptionValue[AdditionalPoints];
  evaluatedRanges = If[MatchQ[additionalPoints,{}|Automatic|{{}}],evaluatedRanges,Fold[Function[{args,point},MapThread[{#1[[1]],Append[#1[[2]],#2]}&,{args,point}]],evaluatedRanges,additionalPoints]];
	trainingData = Map[resolveKineticRateTrainingDataInput[#]&,kts];
	objectiveFunctionTableCore[rxs,trainingData,evaluatedRanges]
]];



objectiveFunctionTableCore[rxs_,trainingData_,kRanges:{{Except[_List],{_?NumberQ...}}...}]:=Module[
	{kGrid,kvars,objVals,startTime,speciesPerTraj,icList,trajList,outList,allSpecies,icStatesFull,mechFull,simOpsSets,outputSpecies,injections,initialVolumes},
	kGrid = Outer[List,Sequence@@kRanges[[;;,2]]];
	(*kvars = Cases[Flatten[rxs[[;;,2;;]]],Except[_?NumberQ]];*)
	kvars = kRanges[[;;,1]];
	startTime = 0.0;
	speciesPerTraj = Map[Length[#[Species]]&,trainingData[[;;,3]]];
	(* BE VERY CAREFUL ABOUT UNITS ON STATE HERE.  CONCENTRATIONS SHOULD BE MOLAR *)
	icList = Join@@MapThread[Table[Unitless[#1[Rules],Molar],{#3}]&,{trainingData[[;;,1]],trainingData[[;;,3]],speciesPerTraj}];
	trajList = Join@@Map[Convert[#[Coordinates],#[Units],{Second,Molar}]&,trainingData[[;;,3]]];
	outList = Flatten[Map[#[Species]&,trainingData[[;;,3]]]];
	injections = Replace[trainingData[[;;,2]],{{Null..}..}->{},{1}];
	initialVolumes = trainingData[[;;,4]];

	(*
		do all the parsing/formatting of simulation inputs one time up front to make the optimizer's simulations faster
	*)
	(* full species list is all things from model and anything else from any initial condition *)
	injections = Join @@ MapThread[Table[#1, {#2}] &, {injections,speciesPerTraj}];
	initialVolumes = Join @@ MapThread[Table[#1, {#2}] &, {initialVolumes,speciesPerTraj}];
	allSpecies = SpeciesList[rxs,Flatten[icList],Sort->False,Structures->True];
	icStatesFull = Map[ToState[DeleteDuplicatesBy[Join[#,Thread[Rule[allSpecies,0.]]],First],Molar]&,icList];
	mechFull = ToReactionMechanism[rxs,allSpecies];
	outputSpecies = Flatten[Map[#[Species]&,trainingData[[;;,3]]]];

	simOpsSets = MapThread[
		FilterRules[
			Simulation`Private`resolveOptionsSimulateKinetics[SafeOptions[ECL`SimulateKinetics,{ObservedSpecies->{#2},Injections->#3,Volume->#4}],{#1},allSpecies,Null],
			Options[ECL`SimulateKinetics]
		]&,
		{icStatesFull,outputSpecies,injections,initialVolumes}
	];

	kGrid = 10^kGrid;

	objVals = Map[(

		{ReplaceAll[Hold[simErr][Numerical,#,{trajList,icStatesFull,outList,simOpsSets},mechFull,allSpecies,startTime]/.Thread[Rule[kvars,#]],Hold->Identity]}
)&,
		kGrid,
		{Length[kRanges]}
	];

	Flatten[
		Join[
			kGrid,
			objVals,
			Length[kRanges]+1
		],
		Length[kRanges]-1
	]
];


resolveKineticRateTrainingDataInput[simPacket: PacketP[Object[Simulation, Kinetics]]]:=Module[{},
	resolveKineticRateTrainingDataInput[Lookup[simPacket,{InitialState,Injections,Trajectory,InitialVolume}]]
];
resolveKineticRateTrainingDataInput[{state_,inj_,traj_Trajectory,vol_}]:={
	Replace[state,rules:{__Rule}:>ToState[rules]],
	Replace[inj,{{Null..}..}->{}],
	traj,
	vol
};


(* ::Subsubsection::Closed:: *)
(*resolveRateRanges*)


resolveRateRanges[kRanges_]:=Replace[
	kRanges,
	{
		{k:RateFormatP,min_?NumberQ,max_?NumberQ}:>{k,Range[min,max]},
		{k:RateFormatP,min_?NumberQ,max_?NumberQ,d_?NumberQ}:>{k,Range[min,max,d]},
		{k:RateFormatP,min_?NumberQ,max_?NumberQ,Log}:>{k,10.^Range[Log10[min],Log10[max]]},
		{k:RateFormatP,min_?NumberQ,max_?NumberQ,{Log,d_?NumberQ}}:>{k,10.^Range[Log10[min],Log10[max],d]}
	},
	{1}
];
resolveRateRanges[kRanges_,kRules_]:=Replace[
	kRanges,
	{
		k:RateFormatP :> {k,Range@@((k/.kRules)*{0.5,1.5,0.1})},
		{k:RateFormatP,min_?NumberQ,max_?NumberQ}:>{k,Range[min,max]},
		{k:RateFormatP,min_?NumberQ,max_?NumberQ,d_?NumberQ}:>{k,Range[min,max,d]},
		{k:RateFormatP,min_?NumberQ,max_?NumberQ,Log}:>{k,10.^Range[Log10[min],Log10[max]]},
		{k:RateFormatP,min_?NumberQ,max_?NumberQ,{Log,d_?NumberQ}}:>{k,10.^Range[Log10[min],Log10[max],d]}
	},
	{1}
];


(* ::Subsubsection::Closed:: *)
(*simErr*)


simErr[method_,k_List,trainingSets:{xys_,icsFull_,outputSpecies_List,simOpsSets_},mechFull_,allSpecies_,startTime_]:=(
	Re@Total[
		MapThread[
			simErrOne[method,k,{#1,#2,#3},mechFull,allSpecies,startTime,#4]&,
			trainingSets
		]
	]);

simErrOne[method_,k_List,{xy_,icFull_,outputSpecies:Except[_List]},mechFull_,allSpecies_,startTime_,simOps_]:=Module[{simConc,out},
	simConc=simExpr[method,k,xy,mechFull,icFull,outputSpecies,allSpecies,startTime,simOps];
	out=Total[
		(xy[[;;,2]]-simConc)^2*(1+1/Max[{Abs[xy[[;;,2]]],Norm[icFull[Magnitudes]]}])
	];
	out
]/;Or[
	MatchQ[method,Analytic],
	And[
		(* need this b/c don't want it to evaluate until simConc is numerical *)
		MatchQ[method,Numerical],
		MatchQ[k,{_?NumericQ..}]
	]
];



(* ::Subsubsection:: *)
(*simExpr*)


(* can't evaluate until k is numeric *)
simExpr[Numerical,k:{_?NumberQ..},xy_,mechFull_,icFull_,outputSpecies_,allSpecies_,startTime_,simOps_List]:=Module[
	{times,kt,out,thing,opsWithoutUnits},
	times = xy[[;;,1]];

	opsWithoutUnits = ReplaceRule[simOps,
		{
			Volume -> Unitless[Lookup[simOps, Volume], Liter],
			Injections -> Map[Simulation`Private`stripInjectionUnits[#]&,Lookup[simOps,Injections],{1}]
		}
	];

	kt=Simulation`Private`kineticTrajectoryCore[mechFull,icFull,{t,startTime,Last[times]},allSpecies,opsWithoutUnits];

	(* out=TrajectoryRegression[kt,outputSpecies,times]; *)
	(* this is faster, than eval. *)
	(* add some shenanigans to handle duplicated time points, which happens when using instantaneous injections *)
	(* need low interpolation order to prevent bad jumps near the injection point *)
	(* out=With[{intf=Interpolation[Transpose[{kt[[3]]+Prepend[Replace[Differences[kt[[3]]],{0.->Mean[times]*10^-9,_->0.},{1}],0.],Flatten[kt[[2]]]}],InterpolationOrder->1]},intf[times]]; *)

	(** NOTE: The part is updated to take the first element of the list and then the third element of that, since trajectory is the first element **)
	out=With[{intf=Interpolation[Transpose[{kt[[1,3]]+Prepend[Replace[Differences[kt[[1,3]]],{0.->Mean[times]*10^-9,_->0.},{1}],0.],Flatten[kt[[1,2]]]}],InterpolationOrder->1]},intf[times]];

	out
];



(* ::Subsection::Closed:: *)
(*App*)


(* ::Subsubsection:: *)
(*analyzeKineticsApp*)


analyzeKineticsApp[trainingDataSets_,reactionList_,observedSpecs_,resolvedOps_]:=Module[
	{
		outputOptions,displayPanel,controlPanel,
		updateRateFitPlot,corePacket,updateRateFit,fig,updateFitAndPlot,
		domainController,optTypeController,rateController,mechController,refitController,
		domain,optType,rateGuesses,xmin,xmax,mech, validMechanism, epilog, xys, ymax, validRateInput, validMechInput
	},

	{domain,optType,rateGuesses} = Lookup[resolvedOps,{Domain,OptimizationType,Rates}];
	mech=reactionList;

	outputOptions[]:=ReplaceRule[resolvedOps,{
		Domain->domain*Second,
		OptimizationType->optType,
		Rates->resolveRateGuesses[mech, rateGuesses, optType],
		App -> True
	}];

	updateRateFit[]:=Module[{},
		corePacket = calculateKineticRateFields[trainingDataSets, mech, outputOptions[]]
	];

	updateRateFitPlot[]:=Module[{},
		fig = Plot`Private`plotKineticRatesTrajectories[corePacket,SafeOptions[Plot`Private`PlotKineticRates,{Epilog -> Dynamic @ epilog[Unitless[domain]], ImageSize->550}]];
	];
	xys = {#[[1]], 1000000000 * #[[2]]} & /@ (Join[Sequence @@ Flatten[#[[3]][Coordinates], 1] & /@ trainingDataSets]);
	ymax = Max[Last /@ xys];
	epilog[dom_] := Module[
		{selectedData, twoLines, dots},
		selectedData = selectInDomain[xys, dom];
		dots = {Opacity[0.3], Black, PointSize[0.02], Point[selectedData]};
		twoLines = {Black, Line[{{dom[[1]], 0}, {dom[[1]], ymax}}], Line[{{dom[[2]], 0}, {dom[[2]], ymax}}]};
		{twoLines, dots}
	];

	updateFitAndPlot[]:=Module[{},
		updateRateFit[];
		updateRateFitPlot[];
	];

	validMechanism[mech_] := Module[
		{allMechanismSpecies},
		allMechanismSpecies = Simulation`Private`allReactionSpecies[mech];
		If[!ContainsAll[allMechanismSpecies, observedSpecs], False, True]
	];

	validMechInput[mech_] := MatchQ[mech, {Alternatives[{_Equilibrium, _Symbol, _Symbol}, {_Rule, _Symbol}]..}];

	validRateInput[rate_] := MatchQ[rate, {(_Symbol -> Alternatives[_?NumericQ, {_?NumericQ, _?NumericQ}])..}];

	{xmin,xmax}=MinMax[Flatten[Map[#[Times]&,trainingDataSets[[;;,3]]]]];
	(*domainController=Row[{"Domain: ",IntervalSlider[Dynamic[domain,{(domain=#)&,(domain=#; updateFitAndPlot[])&}],{xmin,xmax},Method->"Stop",ContinuouAction->False]}];*)
	domainController=Row[{"Domain: ", ToString[xmin], IntervalSlider[Dynamic[domain],{xmin,xmax},Method->"Stop",ContinuouAction->False], ToString[xmax]}];

	(*optTypeController=Row[{"Optimization Type: ",PopupMenu[Dynamic[optType,(optType=#; updateFitAndPlot[])&],{Global,Local},ContinuouAction->False]}];*)
	optTypeController=Row[{"Optimization Type: ",PopupMenu[Dynamic[optType],{Global,Local},ContinuouAction->False]}];

	(*mechController=Column[{"ReactionMechanism",InputField[Dynamic[mech,(mech=#; updateFitAndPlot[])&],ContinuouAction->False,ImageSize->{200,200}]}];*)
	mechController=Column[{"ReactionMechanism: ",
		Dynamic@Style["(must include all ObservedSpecies " <> ToString[observedSpecs] <> ")", If[!And[validMechInput[mech], validMechanism[mech]], Red, Black]],
		Dynamic@Style["(specify ReactionMechanism as {{reaction, forwardRate(, backwardRate)}..})", If[!validMechInput[mech], Red, Black]],
		InputField[Dynamic[mech],ContinuouAction->False,ImageSize->{200,150}]
		}];

	rateController=Column[{
		"Rate Guesses: ",
		Dynamic@Style["(specify rate as {rate \[Rule] guess | {minGuess, maxGuess})..})", If[!validRateInput[rateGuesses], Red, Black]],
		InputField[Dynamic[rateGuesses]]
	}];

	refitController = Row[{Button["Refit Rates",updateFitAndPlot[], Enabled -> Dynamic@And[validMechInput[mech], validRateInput[rateGuesses], validMechanism[mech]]]}];

	displayPanel=Panel[Grid[{
		{
			Quiet[Dynamic[fig]]
		},
		{Grid[{
			{}
		}]}
	}]];

	controlPanel=Panel[Grid[{
		{domainController},
		{optTypeController},
		{mechController},
		{rateController},
		{refitController}
	}, Alignment->Left]];


	(* ------------------------------ *)

	updateFitAndPlot[];

	makeAppWindow[
		DisplayPanel -> displayPanel,
		ControlPanel -> controlPanel,
		Return :> outputOptions[],
		ReturnOptions -> {Rates,ReactionMechanism},
		Cancel -> $Canceled,
		Skip -> Null,
		WindowSize->{930,535},
		WindowTitle->"Kinetics App",
		AppTest->Lookup[resolvedOps,AppTest]
	]
]
