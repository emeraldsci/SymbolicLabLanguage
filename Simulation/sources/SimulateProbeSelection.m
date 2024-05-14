(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Conversions*)



(* ::Subsection:: *)
(*Probe Selection*)


(* ::Subsubsection:: *)
(*Pattern*)


inputPatternSimulateProbeSelectionP = Alternatives[
	_String,
	MotifP,
	ObjectP[Model[Sample]],
	PatternSequence[_String | MotifP, {{GreaterP[0, 1], GreaterP[0, 1]}..} | {{{GreaterP[0, 1], GreaterP[0, 1]}..}..}]
];


(* ::Subsubsection:: *)
(*SimulateProbeSelection*)


DefineOptions[SimulateProbeSelection,
	Options :> {
		{Depth -> 1, GreaterP[0, 1], "Depth of interactions in mechanism search."},
		{FoldingDepth -> Infinity, Infinity|GreaterP[0, 1], "Depth of folding reactions to consider during mechanism generation."},
		{HybridizationDepth -> 1, Infinity|GreaterP[0, 1], "Depth of hybridization reactions to consider during mechanism generation."},
		{Time -> 60*Second, GreaterEqualP[0 Second], "Length of time for each kinetic simulation in which a probe is binding to a specific site on the target."},
		{Temperature -> 75*Celsius, GreaterEqualP[0 Kelvin], "Temperature at which each kinetic simulation is running while a probe is binding to a specific site on the target."},
		{ProbeLength -> {20}, GreaterP[0, 1] | {GreaterP[0, 1]..} | GreaterP[0, 1] ;; GreaterP[0, 1], "Length of the probes to consider.  Can be single length, span of lengths, or list of lengths."},
		{ProbeConcentration -> Micro*Molar, GreaterEqualP[0 Molar], "Concentration of the probe that will be binding to the target."},
		{TargetConcentration -> Molar*Nano, GreaterEqualP[0 Molar], "Concentration of the target strand."},
		{BeaconStemLength -> 0, GreaterEqualP[0, 1], "If Beacon length is specified as n>0, then the reverse complement of the first n bases of the probe sequence are added to the end of the probe, resulting in a probe that can fold into a hairpin loop with stem length of n."},
		{ProbeTarget -> All, All | Site, "Interactions to consider between probe and target.  If Site, consider only interactions at target site.  If All, consider interactions on any position on target sequence."},
		{ProbeFolding -> True, True | False, "Whether a probe can fold on itself.  If True, model probe foldings.  If False, model no probe foldings."},
		{ProbeHybridizing -> True, True | False, "Whether a probe can bind to itself (second order homogeneous interactions). If True, model probe hybridizations. If False model no probe hybridizations."},
		{TargetFolding -> Site, All | Site | False, "Whether a target can fold on itself. If Site, model only target folds on regions that interact with sites being tested.  If All, model all target folds.  If False, model no target folds."},
		{TargetHybridizing -> Site, All | Site | False, "Whether a target can bind to itself (second order homogeneous interactions). If Site, model only target hybridization on regions that interact with sites being tested.  If All, model all target hybridization.  If False, model no target hybridization."},
		{MinPairLevel -> 10, GreaterP[0, 1], "Minimum number of bases allowed in each binding region in a pairing event."},
		{MinFoldLevel -> 10, GreaterP[0, 1], "Minimum number of bases allowed in each binding region in a folding event."},
		{Options -> Null, Null|ObjectReferenceP[Object[Simulation, ProbeSelection]], "Use ResolvedOptions in given object for default option resolution in current simulation."},
		{Output -> ProbeStrands, (Packet | Object | FieldP[Object[Simulation, ProbeSelection], Output -> Short] | {FieldP[Object[Simulation, ProbeSelection], Output -> Short]..}), "Determines which field(s) are returned by the function."},
		{Upload -> True, BooleanP, "Upload result to database.", Category->Hidden}
	},
	SharedOptions:>{
		{SimulateReactivity,{MaxMismatch,MinPieceSize}}
	}
];


SimulateProbeSelection::ProbeFoldFalse = "ProbeFolding is False but Beacon length is set to be nonzero. Please set ProbeFolding to be True or set BeaconStemLength to be zero according to the experimental requirements.";
SimulateProbeSelection::SiteShort = "At least one of the target sites has a length shorter than the MinPairLevel (`1`). Please increase the probe length.";
SimulateProbeSelection::ProbeShort = "ProbeLength (`1`) cannot be smaller than MinPairLevel (`2`).  Please increase ProbeLength or decrease MinPairLevel";
(*SimulateProbeSelection::BeaconShort = "BeaconStemLength (`1`) cannot be smaller than MinFoldLevel (`2`).  Please increase BeaconStemLength or decrease MinFoldLevel";*)


SimulateProbeSelection[in: inputPatternSimulateProbeSelectionP, ops: OptionsPattern[]] := Module[
	{startFields, inListD, refList, endFields,resolvedOps,targetSeq,sites,coreFields, packetList,safeOps},

	startFields = simulationPacketStandardFieldsStart[{ops}];

	safeOps = safeSimulateOptions[SimulateProbeSelection, {ops}];

	{targetSeq, sites} = resolveInputsSimulateProbeSelection[in, safeOps];

	resolvedOps = resolveOptionsSimulateProbeSelection[targetSeq,sites, safeOps];

	If[resolvedOps === $Failed, Return[$Failed]];

	coreFields = simulateProbeSelectionCore[targetSeq, sites, resolvedOps];

	endFields = simulationPacketStandardFieldsFinish[resolvedOps];

	packetList = formatOutputSimulateProbeSelection[targetSeq, startFields, endFields, coreFields, resolvedOps];

	First[uploadAndReturn[{packetList}]]

];


(* ::Subsubsection:: *)
(*resolveOptionsSimulateProbeSelection*)


resolveOptionsSimulateProbeSelection[targetSeq_,sites_, safeOps_List] := Module[
	{smallestSiteSize},

	SimulateProbeSelection::ProbeFoldFalse = "ProbeFolding is False but Beacon length is set to be nonzero. Please set ProbeFolding to be True or set BeaconStemLength to be zero according to the experimental requirements.";
	SimulateProbeSelection::SiteShort = "At least one of the target sites has a length shorter than the MinPairLevel (`1`). Please increase the probe length.";
	SimulateProbeSelection::ProbeShort = "ProbeLength (`1`) cannot be smaller than MinPairLevel (`2`).  Please increase ProbeLength or decrease MinPairLevel";

	(*SimulateProbeSelection::BeaconShort = "BeaconStemLength (`1`) cannot be smaller than MinFoldLevel (`2`).  Please increase BeaconStemLength or decrease MinFoldLevel";*)
	smallestSiteSize = Min[Flatten[Map[Last[#]-First[#]+1&,sites,{2}]]];

	If[Lookup[safeOps, ProbeLength] < Lookup[safeOps, MinPairLevel],
		Message[SimulateProbeSelection::ProbeShort,ToString[Lookup[safeOps, ProbeLength]], ToString[Lookup[safeOps, MinPairLevel]]];
		Message[Error::InvalidOption,ToString[ProbeLength]];
		Return[$Failed];
	];

	If[smallestSiteSize < Lookup[safeOps, MinPairLevel],
		Message[SimulateProbeSelection::SiteShort, ToString[Lookup[safeOps, MinPairLevel]]];
		Message[Error::InvalidOption,ToString[MinPairLevel]];
		Return[$Failed];
	];

	(*If[Lookup[safeOps, BeaconStemLength]>0 && (Lookup[safeOps, BeaconStemLength] < Lookup[safeOps, MinFoldLevel]),*)
		(*Message[SimulateProbeSelection::BeaconShort,Lookup[safeOps, BeaconStemLength],Lookup[safeOps, MinFoldLevel]];*)
		(*Message[Error::InvalidOption,MinFoldLevel];*)
		(*Return[$Failed]*)
	(*];*)

	If[Lookup[safeOps, ProbeFolding]===False && Lookup[safeOps, BeaconStemLength]!=0,
		Message[SimulateProbeSelection::ProbeFoldFalse];
		Message[Error::InvalidOption,ToString[ProbeFolding]];
		Return[$Failed]
	];

	safeOps

];


(* ::Subsubsection:: *)
(*resolveInputsSimulateProbeSelection*)


resolveInputsSimulateProbeSelection[in__]/;MemberQ[{in}, $Failed]:= {$Failed, $Failed};


(* get down to a sequence *)
resolveInputsSimulateProbeSelection[strand:StrandP, rest__]:=	resolveInputsSimulateProbeSelection[First[ToSequence[strand]], rest];
resolveInputsSimulateProbeSelection[structure:StructureP, rest__]:=	resolveInputsSimulateProbeSelection[First[ToStrand[structure]], rest];
resolveInputsSimulateProbeSelection[in: ObjectP[Model[Sample]], rest__]:= Module[{singleStrandOrStructure},
	(* Get the strands from the composition field. *)
	singleStrandOrStructure = FirstOrDefault[Cases[Download[in,Composition[[All,2]][Molecule]],StrandP|StructureP],Null];
	resolveInputsSimulateProbeSelection[singleStrandOrStructure, rest]
];

(* finish the sequence and get/pad the sites *)
resolveInputsSimulateProbeSelection[in: _String | MotifP, sites: {{GreaterP[0, 1],GreaterP[0, 1]}..}, resolvedOps_List]:= {NucleicAcids`Private`resolveSequence[in, SimulateProbeSelection], {sites}};
resolveInputsSimulateProbeSelection[in: _String | MotifP, sites: {{{GreaterP[0, 1],GreaterP[0, 1]}..}..}, resolvedOps_List]:= {NucleicAcids`Private`resolveSequence[in, SimulateProbeSelection], sites};
resolveInputsSimulateProbeSelection[in: _String | MotifP, resolvedOps_List]:= Module[
	{targetSeq, ProbeLengthOption, ProbeLengths, sites},

	(* resolve string to sequence *)
	targetSeq = NucleicAcids`Private`resolveSequence[in, SimulateProbeSelection];

	(* find default sites *)
	ProbeLengthOption = Lookup[resolvedOps, ProbeLength];

	ProbeLengths = DeleteDuplicates[
						Switch[ProbeLengthOption,
							_Integer,{ProbeLengthOption},
							{_Integer..},ProbeLengthOption,
							Span[_Integer,_Integer],Range@@ProbeLengthOption,
							{Span[_Integer,_Integer]..},Flatten[Range@@@ProbeLengthOption]
						]
					];

	sites = partitionTargetSequence[UnTypeSequence[targetSeq],ProbeLengths];

	{targetSeq, sites}

];


(* ::Subsubsection:: *)
(*formatOutputSimulateProbeSelection*)


formatOutputSimulateProbeSelection[targetSeq_, startFields_, endFields_, $Failed, resolvedOps_] := $Failed;
formatOutputSimulateProbeSelection[targetSeq_, startFields_, endFields_, coreFields_, resolvedOps_]:= Module[
	{packet},
	packet=Association[Join[{Type -> Object[Simulation, ProbeSelection]},
		startFields,
		coreFields,
		formatSimulateProbeSelectionOptionFields[targetSeq, resolvedOps],
		endFields
	]]
];


formatSimulateProbeSelectionOptionFields[targetSeq_, resolvedOps_] := {
	TargetSequence -> targetSeq,
	Temperature -> Lookup[resolvedOps, Temperature],
	Time -> Lookup[resolvedOps, Time],
	TargetConcentration -> Lookup[resolvedOps, TargetConcentration],
	ProbeConcentration -> Lookup[resolvedOps, ProbeConcentration],
	ProbeLength -> Lookup[resolvedOps, ProbeLength],
	BeaconStemLength -> Lookup[resolvedOps, BeaconStemLength]
};


(* ::Subsubsection:: *)
(*simulateProbeSelectionCore*)


simulateProbeSelectionCore[$Failed, sites_, resolvedOps_] := $Failed;


simulateProbeSelectionCore[target:MotifP, sites:{{{GreaterP[0, 1],GreaterP[0, 1]}..}..}, resolvedOps_]:= Module[
	{tStructure,out,temp,tFinal,targetConc,probeConc},

	temp=Lookup[resolvedOps,Temperature];
	tFinal=Lookup[resolvedOps,Time];
	targetConc=Lookup[resolvedOps,TargetConcentration];
	probeConc=Lookup[resolvedOps,ProbeConcentration];


	(* format target into Structure *)
	tStructure = ToStructure[target, Motif->"Target"];

(*	If[Lookup[safeOps,Verbose],Print["Total number of sets tested: ",Total[Length/@sites]]];*)


	(* test all sites *)
	out = testAllSites[tStructure,sites,{temp,tFinal},{targetConc,probeConc},Lookup[resolvedOps,BeaconStemLength],resolvedOps];


	out = Reverse[SortBy[Flatten[out,1],#[[2]]&]];

	{
		Replace[TargetPosition] -> out[[;;,1]],
		Replace[ProbeStrands] -> out[[;;,4]],
		Replace[BoundProbeConcentration] -> out[[;;,2]],
		Replace[FreeProbeConcentration] -> out[[;;,3]],
		Replace[FalseAmpliconConcentration] -> out[[;;,6]],
		Replace[FoldedBeaconConcentration] -> (out[[;;,5]]/.{Null..}->{})
	}

];


(* ::Subsubsection:: *)
(*helpers*)


partitionTargetSequence[targetSequence_String,probeSizeList:{_Integer..}]:=
	Table[deconstructIntervalC[1,StringLength[targetSequence],jj,jj],{jj,probeSizeList}];

makeProbeStructure[tStructure_Structure,site_,beacon_Integer]:=Module[{probeSequence,targetSequence,polymer,label,junk,len},
	{label,junk,targetSequence,polymer}=First[ParseStrand[tStructure[[1,1]]]];
	probeSequence=StringJoin[ReverseComplementSequence[StringTake[targetSequence,site],Polymer->polymer],StringTake[StringTake[targetSequence,site],-beacon]];
	len=SequenceLength[probeSequence];
	Structure[{ToStrand[probeSequence,Motif->"Probe",Polymer->polymer]},{}]
];

makeCorrectStructure[mech_,pStructure_,tStructure_,site_]:=
	First[Select[Cases[mech,Structure[StructureJoin[pStructure,tStructure][[1]],_List],Infinity],Intersection[Range@@List@@#[[2,1,2,3]],Range@@site]===Range@@site &]];



(* ::Subsubsection:: *)
(*testAllSites*)


(* no parallel *)
testAllSites[tStructure_Structure,sites_,{temp_,tFinal_},{targetConc_,probeConc_},beacon_,resolvedOps_]:= Module[
	{verbose,monitor,out},

	verbose = True;

	If[verbose, Monitor, List][
		out=Table[
				Table[
					monitor="Position: "<>ToString[sites[[ii,jj]]]<>",  "<>ToString[jj]<>"/"<>ToString[Length[sites[[ii]]]]<>",  "<>ToString[ii]<>"/"<>ToString[Length[sites]];
					testOneSite[tStructure,sites[[ii,jj]],{temp,tFinal},{targetConc,probeConc},beacon,resolvedOps],{jj,1,Length[sites[[ii]]]}
				],
				{ii,1,Length[sites]}
			],
		monitor
	];
	out
];



(* ::Subsubsection:: *)
(*testOneSite*)


"
DEFINITION
	testOneSite[targetStructure, probePosition, {temp,tFinal}, {targetConc,probeConc}, beacon]  ==> {position, amountBound}
		Given a target sequence, test the accessibility of a single site.

INPUTS
	targetStructure - Structure; the sequence you want to bind to
	probePosition  - {a_Integer,b_Integer} ; the position you want to bind to
	{targetConc,probeConc}    - Concentrations of target and probe
	temp           - Temperature; with or without Units
	tFinal         - Time; with or without Units
	beacon - Integer; Length of beacon to add to probes

OUTPUTS
	position    - the probe position
	amountBound - Number; Concentration of the probe bound to the specified position

EXAMPLES

AUTHORS
	Brad
";

testOneSite[tStructure_Structure,site_,{temp_,tFinal_},{targetConc_,probeConc_},beacon_Integer,resolvedOps_]:= Module[
	{mech,initial,pStructure,sim,correctStructure,boundConc,freeConc,beaconFoldConc,beaconFoldedStructure,falseAmpliconConc,falseAmpliconStructures,
	falseAmpliconPattern,ProbeLength,correctStructureProbeInd,mechanismOps},

	ProbeLength=site.{-1,1}+1;


	(* construct probe Structure for this site *)
	pStructure = makeProbeStructure[tStructure,site,beacon];




(****************************************************************************)
(****************************************************************************)
(*********************fix rule replace after ReactionMechanism is fixed************************************)
(****************************************************************************)
(****************************************************************************)
	(* generate ReactionMechanism, make initial condition, and find correct Structure *)
	mechanismOps = ReplaceRule[resolvedOps, {Output->ReactionMechanism, Options -> Null, Upload->False}];

	{mech, initial, correctStructure} = mechanismOneSite[tStructure,pStructure,site,{targetConc,probeConc},beacon,mechanismOps];

	(* simulate *)
	sim = Lookup[SimulateKinetics[mech, initial, tFinal, Temperature->temp, AccuracyGoal -> 8, PrecisionGoal -> 8, Upload->False], Trajectory, $Failed];

	(* if simulation didn't run, throw an error and return *)
	If[Or[sim===$Failed,Head[sim]===SimulateKinetics], Return@Message[SimulateProbeSelection::Failure,"SimulateKinetics","testOneSite"]];

	(* find the 'false amplicon' structures in the Trajectory (i.e. those bound at start or end of probe) *)
	correctStructureProbeInd=First@Flatten@Position[correctStructure[[1]][[1]],pStructure[[1,1]]];
	falseAmpliconPattern=ReplaceAll[First@correctStructure,{
		Bond[{correctStructureProbeInd,1,Span[1,ProbeLength]},{a_,b_,_Span}]:>Bond[{correctStructureProbeInd,1,Alternatives[Span[1,Except[ProbeLength]],Span[Except[1],ProbeLength]]},{a,b,_}],
		Bond[{a_,b_,_Span},{correctStructureProbeInd,1,Span[1,ProbeLength]}]:>Bond[{a,b,_},{correctStructureProbeInd,1,Alternatives[Span[1,Except[ProbeLength]],Span[Except[1],ProbeLength]]}]
	}];
	falseAmpliconStructures=Cases[sim[[1]],falseAmpliconPattern];

	(* evaluate concentration of special species at end of simulation *)
	boundConc = Total@TrajectoryRegression[sim,correctStructure,End] * Last[sim[Units]];

	freeConc = TrajectoryRegression[sim,pStructure,End] * Last[sim[Units]];

	falseAmpliconConc=Total@TrajectoryRegression[sim,falseAmpliconStructures,End] * Last[sim[Units]];

	beaconFoldConc=If[beacon===0,
		Null,
		(* can't make this Structure by hand b/c probe could fold longer than beacon *)
		beaconFoldedStructure=Select[NucleicAcids`Private`reformatBonds[#,StrandMotifBase]&/@(Append[FoldedStructures] /. SimulateFolding[pStructure, Upload->False, Output->Result, MinLevel->beacon, Breadth->5, Depth->{1}]), And[#[[2,1,1,3,1]]===1,#[[2,1,1,3,2]]>=beacon]&];

		Total@TrajectoryRegression[sim,beaconFoldedStructure,End]
	];

	(* return site and concentration of something *)
	{site,boundConc,freeConc,pStructure[[1,1]],beaconFoldConc,Replace[falseAmpliconConc,{}->0]}

];


(* ::Subsubsection:: *)
(*mechanismOneSite*)


mechanismOneSite[tStructure_,pStructure_,site_,{targetConc_,probeConc_},beacon_,resolvedOps_]:=
	Module[{initial,correctStructure,verbose,mechPT,mechPF,mechTF,mechTT,mechPP,mechPTPPTFTT,
		mechDispPT,mechDispPF,mechDispTF,mechDispPP,mechDispTT,pLength},
	verbose=False;

	pLength = site.{-1,1}+1;

	correctStructure=If[beacon===0,
		(*{StructureSort@pairStructure[pStructure,tStructure,{{1,1,Span@@{1,site.{-1,1}+1}},{2,1,Span@@site}}]},*)
		Pairing[{pStructure, {1,pLength}}, {tStructure, site}, MinLevel->pLength],
		StructureSort/@Select[NucleicAcids`Private`reformatBonds[#,StrandMotifBase]&/@Pairing[pStructure,tStructure,MinLevel->pLength],Or[And[#[[2,1,1,3,1]]===1,#[[2,1,1,3,2]]>=pLength],And[#[[2,1,2,3,1]]===1,#[[2,1,2,3,2]]>=pLength]]&]
	];

	(* probe folding mech *)
	mechPF = mechanismProbeFold[pStructure,site,Lookup[resolvedOps,ProbeFolding],resolvedOps];

	(* probe-target, probe-probe, target-fold and target-target mech *)
	mechPTPPTFTT = mechanismPTPPTFTT[pStructure, tStructure, site, {Lookup[resolvedOps,ProbeTarget], Lookup[resolvedOps,ProbeHybridizing], Lookup[resolvedOps,TargetFolding], Lookup[resolvedOps,TargetHybridizing]}, resolvedOps];

	(* initial concentration *)
	initial = {tStructure->targetConc, pStructure->probeConc};

(*	{ Join[mechPT,mechDispPT,mechPF,mechDispPF,mechTF,mechDispTF,mechPP,mechDispPP,mechTT,mechDispTT,mechPX,mechTX],
		initial, correctStructure } *)

	{MechanismJoin[mechPF, mechPTPPTFTT], initial, correctStructure}

];


(* ::Subsubsection:: *)
(*sub mech fcns*)


mechanismProbeFold[pStructure_, site_, level_, resolvedOps_]:= Module[
	{interactions, minFoldLevel, simulateReactivityOptions},

	If[MatchQ[level, False], Return[ReactionMechanism[]]];

	minFoldLevel = Min[{Lookup[resolvedOps,MinFoldLevel], Replace[Lookup[resolvedOps,BeaconStemLength],0->Infinity]}];

  simulateReactivityOptions = Join[DeleteCases[ToList[resolvedOps], Alternatives[Output->_, Depth->_, Upload->_ ]], {Output->Result, Upload->False, Depth -> 1}];

	SimulateReactivity[{pStructure}, Reactions->{FoldingReaction[pStructure]}, MinFoldLevel->minFoldLevel, PassOptions[SimulateProbeSelection, SimulateReactivity, simulateReactivityOptions]][ReactionMechanism]
];

mechanismPTPPTFTT[pStructure_, tStructure_, site_, levels_, resolvedOps_]:= Module[
	{interactionPT, interactionPP, interactionTF, interactionTT, interactions, simulateReactivityOptions},

	interactionPT = Switch[levels[[1]],
						All, HybridizationReaction[pStructure, tStructure],
						Site, HybridizationReaction[pStructure, {tStructure,{1, site}}],
						False, Nothing
					];

	interactionPP = Switch[levels[[2]],
						True, HybridizationReaction[pStructure, pStructure],
						False, Nothing
					];

	interactionTF = Switch[levels[[3]],
						All, FoldingReaction[tStructure],
						Site, FoldingReaction[tStructure, site],
						False, Nothing
					];

	interactionTT = Switch[levels[[4]],
						All, HybridizationReaction[tStructure, tStructure],
						Site, HybridizationReaction[{tStructure, site}, tStructure],
						False, Nothing
					];

	interactions = {interactionPT, interactionPP, interactionTF, interactionTT};

	simulateReactivityOptions = Join[DeleteCases[ToList[resolvedOps], Alternatives[Output->_, Depth->_, Upload->_ ]], {InterStrandFolding->False,IntraStrandFolding->False,Output->Result, Upload->False, Depth->1}];

	Switch[interactions,
		{}, ReactionMechanism[],
		_, SimulateReactivity[{pStructure, tStructure}, Reactions->interactions, PassOptions[SimulateProbeSelection, SimulateReactivity, simulateReactivityOptions]][ReactionMechanism]
	]

];
