(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsubsection::Closed:: *)
(*objectOrLinkP*)


objectOrLinkP[]:=ObjectReferenceP[]|LinkP[];
objectOrLinkP[arg_]:=ObjectReferenceP[arg]|LinkP[arg];


(* ::Subsection:: *)
(*Common packet fields*)


simulationPacketStandardFieldsStart[unresolvedOps_List]:={
	Author->Link[$PersonID,SimulationsAuthored],
	DateConfirmed->Now,
	DateStarted->Now,
	UnresolvedOptions->unresolvedOps
};


simulationPacketStandardFieldsFinish[resolvedOps_List]:={
	DateCompleted->Now,
	Status->Completed,
	ResolvedOptions->resolvedOps
};


(* ::Subsection::Closed:: *)
(*upload related*)


(* ::Subsubsection::Closed:: *)
(*uploadSimulationPackets*)


uploadSimulationPackets[args___]:=
	Analysis`Private`uploadAnalyzePackets[args];


(* ::Subsubsection::Closed:: *)
(*returnSimulationValue*)


returnSimulationValue[args___]:=
	Analysis`Private`returnAnalyzeValue[args];


(* ::Subsubsection::Closed:: *)
(*uploadAndReturn*)


uploadAndReturn[packetList:$Failed]:=$Failed;
uploadAndReturn[packetList:{$Failed}]:={$Failed};
uploadAndReturn[packetList_] := Module[
	{nullPos, noNullList, uploadOps, returnOps, outList, objs, newPacketList, tempOut},

	nullPos = Map[List, Position[packetList, Null | $Failed, 1]];

	noNullList = DeleteCases[packetList, Null | $Failed];
	If[MatchQ[noNullList, {}], Return[packetList]];

	uploadOps = Lookup[Lookup[First[noNullList], ResolvedOptions], Upload];
	returnOps = Lookup[Lookup[#, ResolvedOptions, {Output -> Null}], Output] & /@ noNullList;
	(* This sets default command builder Result output to make an Object *)
	returnOps=If[MatchQ[#, Result] || MemberQ[#, Result], Object,#] &/@ returnOps;

	newPacketList = If[MatchQ[uploadOps, True], objs = Upload[noNullList]; MapThread[Module[{temp}, temp = #1; AssociateTo[temp, Object -> #2]] &, {noNullList, objs}], noNullList];

	tempOut = MapThread[finalReturn[#1, {}, {}, #2, False] &, {newPacketList, returnOps}];

	Fold[Insert[#1, $Failed, #2] &, tempOut , nullPos]
];


(*finalReturn*)
finalReturn[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Object, returnAllBool:False] := Download[primaryInsertPackets, Object];
finalReturn[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Packet, returnAllBool:False] := primaryInsertPackets;

finalReturn[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, field: ListableP[FieldP[Types[Object[Simulation]],Output->Short]],returnAllBool_] := Module[{stripRelationsBool,out},
	out=Download[
		If[MatchQ[primaryInsertPackets, _Association],
			Analysis`Private`stripAppendReplaceKeyHeads[primaryInsertPackets],
			primaryInsertPackets
		],field
	];

	stripRelationsBool=True;
	If[stripRelationsBool,
		ReplaceAll[out,r_Link :> r[Object]], (* strip _relation wrapper off links *)
		out
	]
];

finalReturn[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Object, returnAllBool:True] := {Lookup[primaryInsertPackets,Object],Lookup[secondaryInsertPackets,Object,{}],updatePackets[[;;,1]]};
finalReturn[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Packet,returnAllBool:True] := {primaryInsertPackets,secondaryInsertPackets,updatePackets};
finalReturn[$Failed, __] := $Failed;
finalReturn[Null, __] := Null;





(* ::Subsection::Closed:: *)
(*download related*)


(* ::Subsubsection::Closed:: *)
(*megaDownload*)


megaDownload[in_List] := Module[
	{objs, pkts},
	objs = DeleteDuplicates[Cases[in, ObjectReferenceP[] | LinkP[]]];
	pkts = Download[objs];
	ReplaceAll[in, MapThread[Rule, {objs, pkts}]]
];


(* ::Subsection:: *)
(*shared resolution*)


(* ::Subsubsection::Closed:: *)
(*resolveInformOption*)


(* only allow informing if user is logged in *)
resolveUploadOption[False,functionName_]:=False;
resolveUploadOption[True,functionName_]:=If[
	MatchQ[$PersonID,ObjectP[Object[User]]],
	True,
	(
		Message[functionName::UnknownUser];
		False
	)
];


(* ::Subsubsection:: *)
(*safeSimulateOptions*)


(* pull Options option and pass it through *)
safeSimulateOptions[f_,unresolvedOps_List]:=
	Module[{key},
		key = If[MemberQ[First /@ unresolvedOps, Template], Template, Options];
		safeSimulateOptions[f, unresolvedOps, Lookup[unresolvedOps, key, Null]]
	];
(* if Options is object, pull ResolvedOptions field and pass it through *)
safeSimulateOptions[f_,unresolvedOps_List,optionsObject:ObjectP[Object[Simulation]]]:=
	safeSimulateOptions[f,unresolvedOps,optionsObject[ResolvedOptions]];
(* get all options using user-specified with top priority, then things from Options object *)
safeSimulateOptions[f_,unresolvedOps_List,optionOps:{(_Rule|_RuleDelayed)...}]:=Module[
	{safeOps},
	safeOps = SafeOptions[
		f,
		ToList[ReplaceRule[
			(* need Join here to prevent case where an option isn't in optionsOps (due to oldness or changing fields or whatever) but is in unresolvedOps *)
			(* also quietly filter out illegal option names which may no longer exist as options *)
			Join[FilterRules[optionOps,Options[f]],Options[f]],
			unresolvedOps,
			Append->False
		]]
	];
	ReplaceRule[safeOps, Upload -> resolveUploadOption[Lookup[safeOps, Upload], f]]
];
(* for anything else, use SafeOptions as normal *)
safeSimulateOptions[f_,unresolvedOps_List,optionsOption_]:= Module[
	{safeOps},
	safeOps = SafeOptions[f, ToList[unresolvedOps]];
	ReplaceRule[safeOps, Upload -> resolveUploadOption[Lookup[safeOps, Upload], f]]
];


(* ::Subsection:: *)
(*packet with important fields*)


(* ::Subsubsection:: *)
(*validSimulationPacketQ*)


Options[validSimulationPacketQ]={
	Round->None,
	NonNullFields -> {},
	NullFields -> {},
	ResolvedOptions -> {},
	Verbose->False
};

validSimulationPacketQ[packet_,type_,exactFieldRules_,ops:OptionsPattern[]]:=Module[
	{f,requiredSimulationFields},

	requiredSimulationFields = {ResolvedOptions,UnresolvedOptions,DateConfirmed,DateStarted,DateCompleted,Status};
	f = simulationTypeToFunction[type];

	RunValidQTest[
		type,
		{
			simulationPacketValidPacketQ[packet,type]&,
			resolvedSimulationOptionsTests[packet,type,f,OptionValue[ResolvedOptions]]&,
			simulationPacketNullFieldTests[packet,type,OptionValue[NullFields]]&,
			simulationPacketNonNullFieldTests[packet,type,requiredSimulationFields,OptionValue[NonNullFields]]&,
			simulationPacketExactFieldTests[packet,type,exactFieldRules,OptionValue[Round]]&
		},
		OutputFormat->SingleBoolean,
		PassOptions[
			validSimulationPacketQ,
			RunValidQTest,
			ops
		]
	]

];

resolvedSimulationOptionsTests[packet_,type_,f_,resolvedOpRules_]:={
	Test["All options exist in ResolvedOptions:",
		SameQ[ToString/@Sort[Lookup[packet,ResolvedOptions][[;;,1]]],DeleteDuplicates@Sort[Options[f][[;;,1]]]],
		True
	],
	Test["ResolvedOptions rules match expected values:",
		MatchQ[Lookup[Lookup[packet,ResolvedOptions],resolvedOpRules[[;;,1]]],resolvedOpRules[[;;,2]]],
		True
	],
	Test["ResolvedOptions are all fully resolved (no Automatic values left):",
		MatchQ[Lookup[packet,ResolvedOptions][[;;,2]],{Except[Automatic]...}],
		True
	]
};


simulationPacketNonNullFieldTests[packet_,type_,alwaysNonNullFields_,extraNonNullFields_]:={
	Test["Required simulation fields all non-null:",
		Lookup[packet,alwaysNonNullFields],
		{Except[NullP|_Missing]...}
	],
	Test["Additional simulation fields all non-null:",
		Lookup[packet,extraNonNullFields],
		{Except[NullP|_Missing]...}
	]
};


simulationPacketNullFieldTests[packet_,type_,nullFields_]:={
	Test["Null fields contain Null values:",
		Lookup[packet,nullFields],
		{NullP...}
	]
};


simulationPacketExactFieldTests[packet_,type_,exactFieldRules_,round_]:=With[
	{comparisonFunc = resolveComparisonFunction[round]},
	{
	Test["Exact field values match expected:",
		comparisonFunc[Lookup[packet,exactFieldRules[[;;,1]]],exactFieldRules[[;;,2]]],
		True
	]
}];
resolveComparisonFunction[None|Infinity]:=MatchQ;
resolveComparisonFunction[n_Integer]:=RoundMatchQ[n];


simulationPacketValidPacketQ[packet_Association,type_]:={
	Test["Packet passes ValidPacketFormatQ or ValidUploadQ:",
		Or[Quiet[ValidPacketFormatQ[packet,type]],ValidUploadQ[packet]],
		True
	]
};


simulationPacketValidPacketQ[packet_,type_]:={
	Test["Packet passes ValidPacketFormatQ:",
		ValidPacketFormatQ[packet,type],
		True
	]
};




(* ::Subsubsection::Closed:: *)
(*validSimulationPacketP*)


Options[validSimulationPacketP]=Options[validSimulationPacketQ];
validSimulationPacketP[type_,exactRules:{Rule[_Symbol | _Symbol[_Symbol],_]...},ops:OptionsPattern[]]:=
	PatternTest[_List | _Association,Function[packet,validSimulationPacketQ[packet,type,exactRules,ops]]];




(* ::Subsubsection::Closed:: *)
(*simulationTypeToFunction*)


simulationTypeToFunction[Object[Simulation, ReactionMechanism]]:=SimulateReactivity;
simulationTypeToFunction[Object[Simulation, fam_]]:=ToExpression["Simulate"<>ToString[fam]];


(* ::Subsection::Closed:: *)
(*Pattern-making helpers*)


(* ::Subsubsection::Closed:: *)
(*mappingPermutations*)


mappingPermutations[args___]:=Module[{n,largs,arrangements,out},
	largs={args};
	n=Length[largs];
	arrangements = Flatten[
		Table[
			Permutations[Join[Table[{#..}&,{k}],Table[Identity,{n-k}]]],
			{k,1,n}
		],
		1
	];
	out=Map[
		Function[perm,
			MapThread[
				#1[#2]&,
				{perm,largs}
			]
		],
		arrangements
	];
	Alternatives@@PatternSequence@@@out
];


(* ::Subsection::Closed:: *)
(*Utility*)


(* ::Subsubsection::Closed:: *)
(*reactionTypes*)


reactionTypes[]={
  FirstOrderIrreversible,
  FirstOrderReversible,
  FirstOrderIrreversibleHeterogeneous,
  FirstOrderReversibleHeterogeneous,
  FirstOrderIrreversibleHomogeneous,
  FirstOrderReversibleHomogeneous,
  SecondOrderHeterogeneousIrreversibleFirstOrder,
  SecondOrderHeterogeneousReversibleFirstOrder,
  SecondOrderHeterogeneousIrreversibleSecondOrderHeterogeneous,
  SecondOrderHeterogeneousReversibleSecondOrderHeterogeneous,
  SecondOrderHeterogeneousIrreversibleSecondOrderHomogeneous,
  SecondOrderHeterogeneousReversibleSecondOrderHomogeneous,
  SecondOrderHomogeneousIrreversible,
  SecondOrderHomogeneousReversibleFirstOrder,
  SecondOrderHomogeneousIrreversibleSecondOrderHeterogeneous,
  SecondOrderHomogeneousReversibleSecondOrderHeterogeneous,
  SecondOrderHomogeneousIrreversibleSecondOrderHomogenous,
  CompetitiveFirstOrderIrreversible,
  CompetitiveFirstOrderReversible,
  CompetitiveSecondOrderHomogeneousIrreversible,
  ConsecutiveFirstOrderIrreversibleFirstOrderIrreversible,
  ConsecutiveFirstOrderIrreversibleFirstOrderIrreversibleFirstOrderIrreversible
};


(* ::Subsubsection::Closed:: *)
(*linkageClasses*)

Authors[linkageClasses]:={"scicomp", "brad"};

linkageClasses[reactionsGraph_Graph] :=
    ConnectedComponents[reactionsGraph];
linkageClasses[reactions:{(_Rule|_Equilibrium)..}] :=
    linkageClasses[reactionsToGraphU[reactions]];



(* ::Subsubsection::Closed:: *)
(*checkMassConservation*)


checkMassConservation::Bad = "*** WARNING: YOUR REACTION SYSTEM VIOLATES CONSERVATION OF MASS ***";
checkMassConservation[model:{rx_List,rates_List}] :=
    checkMassConservation[reactionMatrices[model,0,"massCheck"->False]];
checkMassConservation[model:{R_,P_,k_,species_}] :=
    Module[ {eqns,vec,sol,i,m},
        vec = Table[{Subscript[m, i]},{i,1,Dimensions[P][[1]]}];
        eqns = N[Flatten[Transpose[P-R].vec]];
        sol = First[Quiet[Solve[Map[#==0.&,eqns],Flatten[vec]]]];
        If[ Times[Sequence@@Boole[Map[MatchQ[#,0.]&,(Flatten[vec]/.sol)]]]==1,
            Message[checkMassConservation::Bad]
        ]];


(* ::Subsubsection::Closed:: *)
(*unUnit*)


(* Unitless that allows no unit.  Operates only on right side of rules *)
unUnit[list_List,unit_]:=unUnit[#,unit]&/@list;
unUnit[Rule[a_,x_],unit_]:=Rule[a,unUnit[x,unit]];
unUnit[x_?NumericQ,unit_]:=x;
unUnit[x_,unit_]:=Unitless[x,unit];


(* ::Subsection::Closed:: *)
(*Fitting Kinetic Data*)


(* ::Subsubsection::Closed:: *)
(*fitKinetics*)


"
DEFINITIONS
	constants:{_Rule..} = fitKinetics[problem:{model:{reactions:{_Rule..},rates:{_Real|_Symbol..}}, initial:{_Rule..}, time_?VectorQ, data_?MatrixQ, observables:{_Symbol..}}]
	constants:{_Rule..} = fitKinetics[{problem1, problem2, ...}]

	Given a system of reactions 'reactions', a set of initial conditions 'initial' and a set of data, fitKinetics
	will numerically fit rate constants wherever the rate constant given in 'rates' is a
	Symbol.

	You may also give several such problems simultaneously where there are rate constants
	shared between problems, and fitKinetics will fit all the data simultaneously.

INPUTS
	problem - a fitting problem consisting of:
		model - a reaction network consisting of:
			reactions : {_Rule..} - A list of reactions
			rates : {_Real|_Symbol..} - A list of rate constants, some of which may be unknown
		initial : {_Rule..} - A list of initial concentrations
		time : _?VectorQ - The times when we observed concentrations
		data : _?MatrixQ - Observed concentrations in Molar as a #times X #observables matrix
		observables : {_Symbol..} - The species we observe in data

	OR

	{problem, problem, problem, ...}

OUTPUTS
	constants : {_Rule..} - The fitted values for all the rate constants in 'rates' which were given as symbols

EXAMPLES
	fitKinetics[
		{{a+a->b, b->c}, {k, .01}},    (* Reaction network where rate of a+a->b is unknown, rate of b->c is known .01 *)
		{a->10^-6},    (* Initial conditions *)
		{1,100,1000},    (* Times at which the data was sampled *)
		{{0}, {10^-7}, {10^-6}},    (* Data matrix with one observable *)
		{c}    (* c is the species that we observe *)
	]

AUTHORS
	Brad
";

problemPattern = {
	{{(_Rule|_Equilibrium),_|PatternSequence[_,_]}..}, (* list of reactions with rates (numeric or symbol) *)
	{_Rule..},   (* initial condition *)
	_?VectorQ,  (* time points *)
	_?MatrixQ,  (* data points *)
	{_Symbol..} (* species you observed *)
};

fitKinetics[problem:problemPattern] := fitKinetics[{problem}];
fitKinetics[problems:{problemPattern..}, OptionsPattern["Predict"->False]] :=
	Module[{order,firstOrderDefault,secondOrderDefault,coeff,coeff0,sim,species,time,data,fit,reactions,splitReactions},

		reactions = revReactions/@problems[[;;,1,;;,1]];
		coeff=Flatten[#[[1,;;,2;;]]]&/@problems;

		(* Determine the order of every reaction, and from that an initial estimate of the rate constant *)
		order = Total /@ reactantMatrix /@ problems[[;;,1,;;,1]];
		firstOrderDefault = 1/Max[problems[[All,3]]];
		secondOrderDefault = 1/Mean[Flatten[problems[[All,2,All,2]]]]/Max[problems[[All,3]]];
		order = order /. {1->firstOrderDefault, 2->secondOrderDefault};

		(* Identify all the coefficients.  Some will be specified, some will be variables *)
		coeff0 = Transpose[{Flatten[coeff], Flatten[order]}];

		coeff0 = Cases[coeff0, {_Symbol,_}]; (* Only interested in unspecified coefficients *)
		coeff0 = DeleteDuplicates[coeff0];

		species = SpeciesList /@ reactions;
		time = problems[[All,3]];
		data = problems[[All,4]];
		sim[rates:{_?NumericQ..}, i_Integer] :=
			With[{
				sol = First[SimulateKinetics[problems[[i,1]], problems[[i,2]], Max[problems[[i,3]]]]],
				index = Flatten[ Position[species[[i]], #]& /@ problems[[i,-1]] ]
			},
				sim[rates,i] = Function[{r,c}, sol[ time[[1, r]] ][[ index[[c]], 1 ]] ] (* Memoize so that we only simulate once *)
			];

		fit = FindMinimum[
			Sum[(* across problems *)
				Sum[(* across time points *)
					Sum[(* across variables *)
						(sim[ coeff[[i]], i ][ j,k ] - data[[i,j,k]])^2,
						{k,Length[data[[i,j]]]}
					],
					{j,Length[data[[i]]]}
				],
				{i,Length[data]}
			],
			coeff0,
			Method -> "LevenbergMarquardt"
		] // Last;

		If[OptionValue["Predict"],
			Table[
				sim[ coeff[[i]] /. fit, i][ j,k ],
				{i,Length[data]},
				{j,Length[data[[i]]]},
				{k,Length[data[[i,j]]]}
			]
			,(* else *)
			fit
		]
	];

resampleResiduals[problems:{problemPattern..}, prediction:{_?ArrayQ..}, residuals:{_?ArrayQ..}] :=
	Module[{
		new
	},
		new = problems;

		Do[
			new[[i,4]] = prediction[[i]] + RandomChoice[ Flatten[ residuals[[i]] ], Dimensions[ prediction[[i]] ] ],
			{i,Length[problems]}
		];

		new
	];



(* ::Subsubsection::Closed:: *)
(*bootKinetics*)


"bootKinetics[model:{{_Rule..},{_Real|_Symbol..}}, initial:{_Rule..}, time_?VectorQ, data_?MatrixQ, observables:{_Symbol..} n_Integer]

Same as fitKinetics, but returns a matrix where each row is a different result of fitKinetics after resampling the residuals (bootstrapping)";

bootKinetics[problem:problemPattern, n_Integer:100] := bootKinetics[{problem}, n];
bootKinetics[problems:{problemPattern..}, n_Integer:100] :=
	Module[{data,prediction,residuals,fits},
		data = problems[[All,4]];
		prediction = fitKinetics[problems, "Predict"->True];
		residuals = data - prediction;

		fits = ParallelTable[
			fitKinetics[resampleResiduals[problems,prediction,residuals]],
			{n},
			DistributedContexts->{"Global`","Analysis`Private`","Simulation`","Core`","DifferentialEquations`InterpolatingFunctionAnatomy`"}
		]; (* {{k1->?, k2->?}, {k1->?,...}, ...} *)

		{fits[[1,All,1]], Transpose[fits[[All,All,2]]]}

	];


(* ::Subsection::Closed:: *)
(*Accessibility plots*)


(* ::Subsubsection::Closed:: *)
(*plotProbeAffinity*)


Options[plotProbeAffinity]={
	Style->Sequence,
	Scale->Log
};


plotProbeAffinity[mot_,scorings:{{{_Integer,_Integer},_?NumberQ}..},ops:OptionsPattern[plotProbeAffinity]]:=
	plotProbeAffinity[mot,{scorings},ops];



plotProbeAffinity[mot_,scorings:{{{{_Integer,_Integer},_?NumberQ}..}..},OptionsPattern[]]:=Module[
	{seqBaseList,fontStyle,fontSize,seqWhiteList,seq},
	seq=mot[[1]];
	fontStyle="Arial";
	fontSize=16;
	seqBaseList=Style[#,Black,fontSize,FontFamily->fontStyle]&/@Characters[seq];
	seqWhiteList=Style[#,White,fontSize,FontFamily->fontStyle]&/@Characters[seq];
	Pane[
		Panel[
			Style[Column[Map[colorOneStrand[seq,#,seqBaseList,seqWhiteList,OptionValue[Scale],fontStyle,fontSize]&,scorings]],LineBreakWithin->False],
		FrameMargins->20],
	1000,Scrollbars->True]
]/;OptionValue[Style]===Sequence;

colorOneStrand[seq_String,scorings_,seqBaseList_,seqWhiteList_,color_,fontStyle_,fontSize_]:=With[{
	ymin=Switch[color,Log,Log10,Linear,Identity][Min[scorings[[;;,2]]]],
	ymax=Switch[color,Log,Log10,Linear,Identity][Max[scorings[[;;,2]]]]
	},
	Column[{
		Row[Fold[ReplacePart[#1,#2->Style["-",Green,fontSize,FontFamily->fontStyle]]&,seqWhiteList,Range@@scorings[[1,1]]]],
		Row[Fold[ReplacePart[#1,Floor[Mean[#2[[1]]]]->Tooltip[Style[StringTake[seq,{Floor@Mean[#2[[1]]]}],baseColor[Switch[color,Log,Log10,Linear,Identity][#2[[2]]],ymin,ymax],fontSize,FontFamily->fontStyle],{StringTake[seq,#2[[1]]],#2[[2]]}]]&,seqBaseList,scorings]],
		Row[Fold[ReplacePart[#1,#2->Style["-",Red,fontSize,FontFamily->fontStyle]]&,seqWhiteList,Range@@scorings[[-1,1]]]]
		},Spacings->{0,0}]
];

baseColor[y_,ymin_,ymax_]:=RGBColor[1-(y-ymin)/(ymax-ymin),(y-ymin)/(ymax-ymin),0];



plotProbeAffinity[mot:MotifP,scorings:{{{{_Integer,_Integer},_?NumberQ}..}..},OptionsPattern[plotProbeAffinity]]:=Module[{frameLabel},
	frameLabel={"Position index of probe center",Switch[OptionValue[Scale],Log,"Log Scale\n",Linear,""]<>"Correctly bound probe [M]"};
	Switch[OptionValue[Scale],Log,ListLogPlot,Linear,ListPlot][
		Table[SortBy[Tooltip[N@{Mean[#[[1]]],#[[2]]},{StringTake[mot[[1]],#[[1]]],#[[1]]}]&/@one,First],{one,scorings}],
		FrameLabel->frameLabel,
		ImageSize->1000,Joined->True,PlotMarkers->"\[FilledCircle]",PlotRange->{{0,SequenceLength[mot]},Automatic},AspectRatio->.2
	]
]/;OptionValue[Style]=!=Sequence;


(* ::Subsubsection::Closed:: *)
(*plotAccessibility*)


plotAccessibility[sim_]:=plotAccessibility[sim,End];
plotAccessibility[sim_,time_]:=plotAccessibility[sim,time,1];
plotAccessibility[sim_List,time:(_Times|Second|End),length_Integer]:=Module[
{list,seqRules,temp,sym,seq},
seqRules=Last[sim];
list=Table[
	{sym,seq}={seqRules[[i,1]],seqRules[[i,2]]};
	temp=getIntervalOccupancy[sim, {seqRules[[i,1]], #} & /@ deconstructIntervalC[1, StringLength[seq],length,length], End];
	{sym,seq,{Mean[#[[2]]], Last[#]} & /@ temp}, {i,1,Length[seqRules]}];
plotSequenceAccessibility/@list
];



(* ::Subsubsection::Closed:: *)
(*getIntervalOccupancy*)


getIntervalOccupancy[in_,sites:{{ReactionSpeciesP,{_,_}}..},time_]:=Module[{info,things,symbol,interval,occ,overlaps},
	info=baseConcentrationInfo[in,time];
	Table[
		{symbol,interval}=sites[[i]];
		things=Cases[info,{ToString[symbol],_List,_?NumericQ}];
		overlaps=Select[things,!(Intersection[#[[2]],Range[interval[[1]],interval[[2]]]]==={})&];
		occ=Total[overlaps[[;;,3]]];
		{symbol, interval,occ*100/Total[things[[;;,3]]] }
	,{i,1,Length[sites]}]
];


(* ::Subsubsection::Closed:: *)
(*getSiteOccupancy*)


getSiteOccupancy[in_,time_]:=getSiteOccupancy[in,Last[in],time];
getSiteOccupancy[in_,stuff:{(_Rule|_List)..},time_]:=Module[{info,things,vec,symbol},
	info=baseConcentrationInfo[in,time];
	Table[
		symbol=stuff[[i,1]];
		things=Cases[info,{symbol,_List,_?NumericQ}];
		vec=ConstantArray[0.,StringLength[stuff[[i,2]]]];
		Map[vec[[#[[2]]]]+=#[[3]]&,things];
		{symbol, stuff[[i,2]],vec*100/Total[things[[;;,3]]] }
	,{i,1,Length[stuff]}]
];


(* ::Subsubsection:: *)
(*baseConcentrationInfo*)


baseConcentrationInfo[in:{f_InterpolatingFunction,specs_List,__}]:= baseConcentrationInfo[f,specs];
baseConcentrationInfo[in:{f_InterpolatingFunction,specs_List,__},time_]:= baseConcentrationInfo[f,specs,time];
baseConcentrationInfo[f_InterpolatingFunction,specs_List]:= baseConcentrationInfo[f,specs,End];
baseConcentrationInfo[f_InterpolatingFunction,specs_List,time_]:= Module[{conc,info},
conc=TrajectoryRegression[f,time];
info=getOccupiedSitesFromStructureName[specs];
Flatten[Table[Map[Append[#,conc[[i]]]&,Download[[i]]],{i,1,Length[conc]}],1]
];


(* ::Subsubsection::Closed:: *)
(*plotSequenceAccessibility*)


plotSequenceAccessibility[{symbol:ReactionSpeciesP,sequence_String,data_List}]:=
ListLinePlot[data,PlotRange->{{0,StringLength[sequence]},{0,100}}, Axes-> False, Frame-> True,
LabelStyle-> {FontFamily-> Arial, FontSize-> 14, Bold}, Filling -> Axis, PlotStyle->{Black,Dashed,Thick},
FrameLabel-> {"sequence position", "percent in Duplex","Species: "<>ToString[symbol]},ImageSize->400];


(* ::Subsubsection::Closed:: *)
(*getFoldedEdgesFromSymbolName*)


getFoldedEdgesFromSymbolName[name:ReactionSpeciesP]:=With[{pairs=getFoldPositionsFromSymbolName[name]},
Flatten[Map[Table[{#[[1,1]]+i,#[[2,2]]-i},{i,0,#[[1,2]]-#[[1,1]]}]&,pairs],1]];



(* ::Subsubsection::Closed:: *)
(*Get info from species names*)


getOccupiedSitesFromStructureName[list:{_Structure..}]:=getOccupiedSitesFromStructureName/@list;
getOccupiedSitesFromStructureName[name_Structure]:=Module[{pairs,syms},
	pairs = name[[2]] /. {Bond[a_, b_] -> Sequence[a, b]};
	syms=name[[1]];
	Map[{syms[[#[[1]]]], Range[First[#[[3]]], Last[#[[3]]]]} &, pairs]
];

parseSymbolNames[list_List]:=parseSymbolName/@list;
parseSymbolName[name_Structure]:={name[[1]],{}};
parseSymbolName[name:(_String|_Symbol)]:={{name,{}}};
parseSymbolName[name_fold]:=Module[{flatName,ranges},
flatName=Flatten[name];
ranges=intervalsToRange[Flatten[List@@flatName[[2;;]],1]];
{{flatName[[1]],ranges}}];

parseSymbolName[name_Bond]:=Module[{flatName,ranges1,ranges2},
flatName=Flatten[name];
ranges1=intervalToRange[Flatten[List@@flatName[[2;;,1]],1]];
ranges2=intervalToRange[Flatten[List@@flatName[[2;;,2]],1]];
{{flatName[[1,1]],ranges1},{flatName[[1,2]],ranges2}}];

intervalToRange[pos:{_Integer,_Integer}]:=Range[First[pos],Last[pos]];
intervalsToRange[poss:{{_Integer,_Integer}...}]:=Join@@(intervalToRange/@poss);


(* ::Subsubsection:: *)
(*Reaction Network Solutions*)
Authors[implicitReactionTable]:={"scicomp", "brad"};


implicitReactionTable::BadSpeciesName="Warning, one or more of the species in the reactions are functions and may evaluate. Do not trust the results. Avoid using 'D|E|N' as species name.";
implicitReactionTable::NoSolution="No solution found.";

implicitReactionTable[model_]:=implicitReactionTable[model,{},{}];
implicitReactionTable[model_,ics:{Rule[Except[_List],Except[_List]]...}]:=implicitReactionTable[model,ics,{}];
implicitReactionTable[model_,injections:InjectionsFormatP]:=implicitReactionTable[model,{},injections];

implicitReactionTable[mech_ReactionMechanism,ics:{Rule[Except[_List],Except[_List]]...},injections:(InjectionsFormatP|{})]:=
		implicitReactionTable[NucleicAcids`Private`mechanismToImplicitReactions[mech],ics,injections];

implicitReactionTable[reacs_,ics:{Rule[Except[_List],Except[_List]]...},injections:(InjectionsFormatP|{})]:=Module[
	{icRules,fullReactions,connReacList,joinedSols},
	icRules = Map[Rule[#[[1]][0],#[[2]]]&,ics];
	fullReactions = NucleicAcids`Private`toFullImplicitReactions[reacs];
	If[MemberQ[NucleicAcids`Private`implicitReactionsToSpecies[fullReactions],D|E|N],
		Message[implicitReactionTable::BadSpeciesName]
	];
	connReacList = connectedReactions[fullReactions];
	joinedSols=Join@@Map[reactionSolutionCore[#,injections]&,connReacList];
	joinedSols/.icRules
];


(* ::Subsubsection::Closed:: *)
(*linearNetworkQ*)


linearNetworkQ[reacs:ImplicitReactionsFormatP]:=Module[{rxs,maxDegree},
	rxs=NucleicAcids`Private`implicitReactionsToReactions[reacs];
	maxDegree = Max[#[Degree]&/@rxs];
	If[maxDegree==1,
		True,
		False
	]
];


interactionToSpecies = NucleicAcids`Private`interactionToSpecies;
implicitReactionHalfToReactionHalf = NucleicAcids`Private`implicitReactionHalfToReactionHalf;

reactionICs[reactions_List]:=Through[interactionToSpecies[reactions][0]];
reactionICs[reaction_]:=reactionICs[{reaction}];

reactionRates[reactions:{(_Rule|_Equilibrium)..}]:=With[{rsol=implicitReactionTable[reactions]},
	Union[Cases[rsol,_k,Infinity]]
];
reactionRates[reaction:(_Rule|_Equilibrium)]:=reactionRates[{reaction}];
reactionRates[fullReactionList:{_List...}]:=fullReactionList[[;;,2;;]];

ratesFromReaction[_Rule,ind_Integer]:=k[ind,F];
ratesFromReaction[_Equilibrium,ind_Integer]:=Sequence[k[ind,F],k[ind,R]];

reactionFull[reactions_List]:=MapIndexed[{#1,ratesFromReaction[#1,First[#2]]}&,reactions];
reactionFull[reaction_]:=reactionFull[{reaction}];



(* for linear network, solve with DSolve *)
reactionSolutionCore[fullReactionList:ImplicitReactionsFormatP?linearNetworkQ]:=linearReactionSolution[fullReactionList];
(*reactionSolutionCore[fullReactionList:ImplicitReactionsFormatP?linearNetworkQ]:=linearReactionSolutionDSolve[fullReactionList]*)


reactionSolutionCore[fullReactionList_,{}]:=reactionSolutionCore[fullReactionList];
reactionSolutionCore[fullReactionList_]:=Module[{canonReac,matchingReaction,rxs,rates,speciesReplacementRules,sols},
	canonReac = NucleicAcids`Private`canonicalImplicitReaction[fullReactionList];
	speciesReplacementRules = Thread[Rule[interactionToSpecies[canonReac],NucleicAcids`Private`implicitReactionsToSpecies[fullReactionList]]];
	rates = Thread[Rule[
		Flatten[reactionRates[reactionFull[fullReactionList[[;;,1]]]]],
		Flatten[reactionRates[fullReactionList]]
	]];
	matchingReaction=Cases[NucleicAcids`Private`implicitReactionTable[],{name_,tags_,canonReac,specs_,sol_}:>sol];
	If[MatchQ[matchingReaction,{}],
		(
			Message[implicitReactionTable::NoSolution];
			{}
		),
		(
			sols=First[matchingReaction]/.rates/.speciesReplacementRules;
			Thread[Rule[NucleicAcids`Private`implicitReactionsToSpecies[fullReactionList],sols]]
		)
	]
];


reactionSolutionCore[reacs:ImplicitReactionsFormatP,injections:FastInjectionsFormatP]:=Module[
	{specs,sol0,icVars,solList,vec0},
	specs=NucleicAcids`Private`implicitReactionsToSpecies[reacs];
	sol0 = reactionSolutionCore[reacs];
	vec0 = Replace[specs,sol0,{1}];
	icVars = Through[specs[0]];
	solList = FoldList[
		(
			ReplaceAll[vec0,Join[{t->(t-#2[[1]])},makeIcRules[#2[[2]],specs,solAtTime[#1,#2[[1]]]]]]
		)&,
		vec0,
		injections
	];
	Piecewise[MapThread[{Thread[Rule[specs,#1]],t<#2}&,{solList,Append[injections[[;;,1]],Infinity]}]]
];


solAtTime[vec_,tval_]:=ReplaceAll[vec,t->tval];
makeIcRules[specs_,xT_]:=Thread[Rule[Through[specs[0]],xT]];
makeIcRules[icRules:{___Rule}]:=Map[Rule[#[[1]][0],#[[2]]]&,icRules];
makeIcRules[icRules_,specs_,xT_]:=DeleteDuplicates[Join[makeIcRules[icRules],makeIcRules[specs,xT]],MatchQ[#1[[1]],#2[[1]]]&];
resetSol[vec_,specs_List,Rule[tval_,newIC:{___Rule}]]:=resetSol[vec,specs,tval->newIC,solAtTime[vec,tval]];
resetSol[vec_,specs_List,Rule[tval_,newIC:{___Rule}],xT_]:=ReplaceAll[vec,Join[{t->(t-tval)},makeIcRules[newIC,specs,xT]]];



(* ::Subsubsection::Closed:: *)
(*linearReactionSolution*)


linearReactionSolution[reacs:ImplicitReactionsFormatP]:=linearReactionSolution[reacs,{}];
linearReactionSolution[reacs:ImplicitReactionsFormatP,injections_]:=Module[{A1,A2,inds,specs,xvars0,sol,timeVar,atExp,Bu,bterm},
	{A1,A2,inds,specs}=stateSpaceMatrices[reacs];
	xvars0=Through[specs[0]];
	timeVar=t;
	atExp = MatrixFunction[Exp,A1*timeVar];
	(*
	bterm = If[True (*MatchQ[injections,{}]*),
		0.,
		(
		(*	Bu = Flatten[Simulation`Private`injectionsToInputVectorFunction[injections,specs][timeVar]];*)
			LinearSolve[A1,atExp.Bu-Bu]
		)
	];
*)
	sol = atExp.xvars0;
	Thread[Rule[specs,sol]]
];


(* I think this method is always going to be slower than the one above, so don't use this *)
linearReactionSolutionDSolve[reacs:ImplicitReactionsFormatP]:=
		linearReactionSolutionDSolve[reacs,{}];
linearReactionSolutionDSolve[reacs:ImplicitReactionsFormatP,injections_]:=Module[
	{A1,A2,inds,specs,xvars,xdotvars,xvars0,fakexvars0,xtmp,sol,Bvars,Bu,timeVar=t},
	{A1,A2,inds,specs}=stateSpaceMatrices[reacs];
	xvars=Through[specs[timeVar]];
	xdotvars=Through[Map[Derivative[1],specs][timeVar]];
	xvars0=Through[specs[0]];
	(*
	Bvars = Table[Unique["B"],{Length[xvars]}];
	(*Bu = Flatten[Simulation`Private`injectionsToInputVectorFunction[injections,specs][timeVar]];*)
	Bu=0.*Bvars;
*)
	(*
		Must specify initial condition. Can be symbol, but cannot be of the form x[blah].
		Therefore, make fake vars, solve, then substitute back in symbolic x[0] list
	 *)
	fakexvars0 = Table[Unique["xtmp"],{Length[specs]}];
	sol = First[DSolve[{Thread[Equal[xdotvars,A1.xvars]],Thread[Equal[xvars0,fakexvars0]]},xvars,t]];
	ReplaceAll[Rule@@@Transpose[{specs,sol[[;;,2]]}],Join[Thread[Rule[fakexvars0,xvars0]]]]
];


(* ::Subsubsection::Closed:: *)
(*nonlinearReactionSolution*)


nonlinearReactionSolution[reacs:ImplicitReactionsFormatP,ics0:{___Rule},injections:{{_,_,_,_}...}]:=Module[
	{A1,A2,inds1,inds2,specs,xvars,xdotvars,xvars0,fakexvars0,xtmp,sol,Bvars,Bu,timeVar=t,ics},
	{A1,A2,{inds1,inds2},specs}=stateSpaceMatrices[reacs];
	xvars=Through[specs[timeVar]];
	xdotvars=Through[Map[Derivative[1],specs][timeVar]];
	xvars0=Through[specs[0]];
	Bu = Flatten[Simulation`Private`injectionsToInputVectorFunction[injections,specs][timeVar]];
	fakexvars0 = Table[Unique[xtmp],{Length[specs]}];
	ics=DeleteDuplicates[Join[Map[Rule[#[[1]][0],#[[2]]]&,ics0],MapThread[Rule,{xvars0,fakexvars0}]],MatchQ[#1[[1]],#2[[1]]]&];
	(*
		Must specify initial condition. Can be symbol, but cannot be of the form x[blah].
		Therefore, make fake vars, solve, then substitute back in symbolic x[0] list
	 *)
	sol = First[Quiet[DSolve[{Thread[Equal[xdotvars,A1.xvars+A2.(xvars[[inds1]]*xvars[[inds2]])+Bu]],Equal@@@ics},xvars,t],{Solve::ifun}]];
	ReplaceAll[Rule@@@Transpose[{specs,sol[[;;,2]]}],Join[Thread[Rule[fakexvars0,xvars0]]]]
];




(* ::Subsubsection::Closed:: *)
(*adjacencyMatrices*)

Authors[adjacencyMatrices]:={"scicomp", "brad"};
adjacencyMatrices[{}] :={};
adjacencyMatrices[Rorig_] :=
		Module[ {linLocations,rules1,rules2,rowChooser,i,R,inds1,inds2,rInds,vars,uniqueColInds,uniqueCols,
			numEqns,numVars,M1,M2,ind1,ind2,colInds,ix,r,rules,indsinds},
			R = Transpose[SparseArray[Rorig]];
			{numEqns,numVars} = Dimensions[R];
			linLocations = Flatten[Position[Total[R, {2}], 1]];
			rules1 = Table[{linLocations[[i]], linLocations[[i]]} -> 1, {i, 1, Length[linLocations]}];
			rowChooser = SparseArray[rules1, {numEqns, numEqns}];
			M1 = Transpose[Transpose[R].rowChooser];
			rInds = Flatten[Position[Total[Transpose[R]], 2]];
			rules = ArrayRules[R];
			indsinds = Map[Flatten[Position[rules[[All, 1, 1]], #]] &, rInds];
			vars = Map[rules[[#, 1, 2]] &, indsinds];
			r = Length[indsinds];
			rules2 = ConstantArray[0,r];
			inds1 = ConstantArray[0,r];
			inds2 = ConstantArray[0,r];
			For[ix = 1,ix<=r,ix++,
				If[ Length[indsinds[[ix]]]==2,
					{ind1,ind2} = {vars[[ix,1]],vars[[ix,2]]},
					{ind1,ind2} = {vars[[ix,1]],vars[[ix,1]]}
				];
				rules2[[ix]] = {rInds[[ix]],(ind1-1)*numVars+ind2}->1;
				inds1[[ix]] = ind1;
				inds2[[ix]] = ind2
			];
			colInds = (inds1-1)*numVars+inds2;
			M2 = SparseArray[rules2, {numEqns,numVars*numVars}];
			(* Must delete duplicates, otherwise we end up adding the terms multiple times *)
			uniqueCols = DeleteDuplicates[colInds];
			uniqueColInds = Map[Flatten[Position[colInds,#]]&,uniqueCols][[All,1]];
			{M1,M2,uniqueCols,inds1[[uniqueColInds]],inds2[[uniqueColInds]]}
		];


(* ::Subsubsection:: *)
(*stateSpaceMatrices*)


stateSpaceMatrices::usage="
DEFINITIONS
	stateSpaceMatrices[ {ImplicitReactionP..} ]  ==>  {A1, A2, inds, species}
		Transforms list of reactions and rate constants into a pair of sparse matrices that are used in the ODE model

	stateSpaceMatrices[ {R_,P_,k_,specs_} ]  ==>  {A1, A2, inds, species}
		Transforms list of reactions and rate constants into a pair of sparse matrices that are used in the ODE model

	stateSpaceMatrices[ mech_ReactionMechanism ]  ==>  {A1, A2, inds, species}
		Transforms list of reactions and rate constants into a pair of sparse matrices that are used in the ODE model

OUTPUTS
  A1   - Sparse matrix; Descirbes first order reactions
  A2   - Sparse matrix; Describes second order reactions
  inds - list of indices relating columns in A2 to terms in KroneckerProduct[species,species]
  species - list of all species in the reactions

SEE ALSO
  reactionMatrices, stateSpaceMatrices

AUTHORS
	Brad
";
Authors[stateSpaceMatrices]:={"scicomp", "brad"};
stateSpaceMatrices::BadModelFormat="Invalid model format: `1`";

Options[stateSpaceMatrices]={Verbose->False,Full->False};

(* given empty ReactionMechanism or no reactions *)
stateSpaceMatrices[ReactionMechanism[]|{},OptionsPattern[stateSpaceMatrices]]:={{},{0},{{},{}},{}};

(* given implicit reactions *)
stateSpaceMatrices[reacs:ImplicitReactionsFormatP,ops:OptionsPattern[]]:=
    stateSpaceMatrices[Map[Reaction,reacs],ops];

(* --- given ReactionMechanism --- *)
stateSpaceMatrices[mech:ReactionMechanismP,ops:OptionsPattern[]]:=stateSpaceMatrices[mech[Reactions],ops];

stateSpaceMatrices[rxns:{_Reaction..},OptionsPattern[]] := Module[
	{specs, reactions2, reactions3,left,right,symtonum},
	specs = Union[Flatten[Map[#[Species]&,rxns]]];
	symtonum= MapIndexed[Rule[#1,First[#2]] &, specs];
	reactions2=revReactions[rxns];
	reactions3 = reactions2 /. Dispatch[symtonum];
	loadSSMatsFromIntegersReaction[reactions3,specs]
]/;OptionValue[Full]===False;


(* --- Given reaction matrices (R,P,k) --- *)
stateSpaceMatrices[model:{R_SparseArray,P_SparseArray,k_List,specs_List},OptionsPattern[stateSpaceMatrices]] :=
		Module[ {A1,A2,M1,M2,inds,ind1,ind2,K},
			K = DiagonalMatrix[SparseArray[k]];
			{M1,M2,inds,ind1,ind2} = adjacencyMatrices[R]; (* M1,M2 Sparse *)
			A1 = (P-R).K.M1;   (* Sparse *)
			A2 = (P-R).K.M2;   (* Sparse *)
			If[ Length[inds]==0,
				A2 = {},
				A2 = SparseArray[A2[[;;,inds]]]
			];  (* Emtpy A2 screws things up *)
			{A1,A2,{ind1,ind2},specs}
		]/;OptionValue[Full]===False;


(* full A2 *)
stateSpaceMatrices[R_SparseArray,P_SparseArray,K_SparseArray,OptionsPattern[stateSpaceMatrices]] :=
		Module[ {A1,A2,M1,M2,inds,ind1,ind2},
			{M1,M2,inds,ind1,ind2} = adjacencyMatrices[R];  (* M1,M2 Sparse *)
			A1 = (P-R).K.M1;   (* Sparse *)
			A2 = (P-R).K.M2;   (* Sparse *)
			{A1,A2,{ind1,ind2}}
		]/;OptionValue[Full]===True;

(* Full A2 matrix *)
stateSpaceMatrices[model:{ImplicitReactionP..},OptionsPattern[stateSpaceMatrices]] :=
		Module[ {A1,A2,inds,R,P,k,specs},
			{R,P,k,specs} = reactionMatrices[model];
			{A1,A2,inds} = stateSpaceMatrices[R,P,DiagonalMatrix[SparseArray[k]]];
			{A1,A2,inds,specs}
		] /;OptionValue[Full]===True;



stateSpaceMatrices[other_,OptionsPattern[]]:=(
	Message[stateSpaceMatrices::BadModelFormat,other];
	$Failed
);

loadSSMatsFromIntegersReaction[reactions3:{_Reaction..},specs_] := Module[
	{nn, tmp, rules, rulesA1, rulesA2,A1, A2, a1, a2,ind, inds, newrules},
	nn = Length[specs];
	(* replace reactions with sparse array rules *)
	rules = Flatten[Map[reactionToArraySSIndices[#,{a1,a2,ind}]&,reactions3],1];

	rulesA1 = Cases[rules, a1[stufff_] :> stufff];
	rulesA1=consolidateAdditiveRules[rulesA1];
	rulesA2 = Cases[rules, a2[stufff_] :> stufff];

	tmp=Union[Cases[Flatten[rulesA2[[;; , 1]]], ind[a_, b_] :> {a, b}]];

	If[tmp==={},
		rulesA2={0};
		inds={{},{}};
		,
		inds = Transpose[tmp];
		newrules = MapIndexed[ind[#[[1]], #[[2]]] -> #2[[1]] &, Transpose[inds]];
		rulesA2 = rulesA2 /. Dispatch[newrules];
		rulesA2 = consolidateAdditiveRules[rulesA2];
	];
	A1 = SparseArray[rulesA1, {nn, nn}];

	A2 = If[tmp==={},SparseArray[rulesA2],SparseArray[rulesA2,{nn,Dimensions[inds][[2]]}]];
	{A1, A2, inds, specs}
];

reactionToArraySSIndices[Reaction[{a_Integer},prods:{_Integer..},kf_],{a1_,a2_,ind_}]:=Join[
	{a1[Rule[{a,a},-kf]]},
	Map[a1[Rule[{#,a},kf]]&,prods]
];
reactionToArraySSIndices[Reaction[{a_Integer,b_Integer},prods:{_Integer..},kf_],{a1_,a2_,ind_}]:=Join[
	{
		a2[Rule[{a,ind[a,b]},-kf]],
		a2[Rule[{b,ind[a,b]},-kf]]
	},
	Map[a2[Rule[{#,ind[a,b]},kf]]&,prods]
];


consolidateAdditiveRules[rules_] := Map[#[[1, 1]] -> Total[#[[;; , 2]]] &, GatherBy[rules, First[#] &]];


(* ::Subsubsection::Closed:: *)
(*stoichiometricMatrix*)
Authors[stoichiometricMatrix]:={"scicomp", "brad"};


stoichiometricMatrix[{}]:={};
stoichiometricMatrix[reactions:{(_Rule|_Equilibrium)..}] := productMatrix[reactions]-reactantMatrix[reactions];


(* ::Subsubsection::Closed:: *)
(*reactantMatrix*)

Authors[reactantMatrix]:={"scicomp", "brad"};

(* # species X # reactions *)
reactantMatrix[{}]:={};
reactantMatrix[reactions0:{(_Rule|_Equilibrium)..}] :=
		Module[ {reactants,species,speciesEach,coefs,ix,rows,cols,reactions,specRules},
			reactions=reactions0;
			species = interactionToSpecies[reactions];
			reactants = revReactions[reactions]/.    Rule[left_, right_]:> left;
			speciesEach = Map[DeleteDuplicates[implicitReactionHalfToReactionHalf[#]] &, reactants];
			coefs = Flatten[Table[Map[D[reactants[[ix]], #] &, speciesEach[[ix]]], {ix, 1,Length[reactants]}]];
			rows = Flatten[Map[Position[species, #] &, Flatten[speciesEach]]];
			cols = Flatten[Table[ConstantArray[ix, Length[speciesEach[[ix]]]], {ix, 1,Length[speciesEach]}]];
			SparseArray[MapThread[Rule[{#1, #2}, #3] &, {rows, cols, coefs}],{Length[species],Length[reactants]}]
		];


(* ::Subsubsection::Closed:: *)
(*productMatrix*)
Authors[productMatrix]:={"scicomp", "brad"};


productMatrix[{}]:={};
productMatrix[reactions0:{(_Rule|_Equilibrium)..}] :=
		Module[ {products,species,speciesEach,coefs,cols,rows,ix,reactions,specRules},
			reactions=reactions0;
			species = interactionToSpecies[reactions];
			products = revReactions[reactions]/.    Rule[left_, right_]:> right;
			speciesEach = Map[DeleteDuplicates[implicitReactionHalfToReactionHalf[#]] &, products];
			coefs = Flatten[Table[Map[D[products[[ix]], #] &, speciesEach[[ix]]], {ix, 1,Length[products]}]];
			rows = Flatten[Map[Position[species, #] &, Flatten[speciesEach]]];
			cols = Flatten[Table[ConstantArray[ix, Length[speciesEach[[ix]]]], {ix, 1,Length[speciesEach]}]];
			SparseArray[MapThread[Rule[{#1, #2}, #3] &, {rows, cols, coefs}],{Length[species],Length[products]}]
		];


(* ::Subsubsection:: *)
(*reactionMatrices*)


reactionMatrices::usage="
DEFINITIONS
  reactionMatrices[ {ImplicitReactionP..} ]  ==> {R, P, k, species}
	  Transforms list of reactions and rate constants into reactant matrix R, product matrix P, and list of rate constants k

INPUTS
  reactions
  rates

OUTPUTS
  R - Reactant matrix
  P - Product matrix
  k - list of rate constants
  species - list of all species in the reactions

SEE ALSO
  stateSpaceMatrices, stateSpaceMatrices

AUTHORS
	Brad
";
Authors[reactionMatrices]:={"scicomp", "brad"};
reactionMatrices[mech_ReactionMechanism]:=
		reactionMatrices[NucleicAcids`Private`mechanismToImplicitReactions[mech]];

reactionMatrices[model:{ImplicitReactionP..}] :=
		Module[ {R,P,reactions,rates,species,uniqueSymbolSpecies},
			reactions=Flatten[model[[;;,1]]];
			species= NucleicAcids`Private`implicitReactionsToSpecies[model];
			uniqueSymbolSpecies = Replace[species,{s_String:>Unique[s],sy_Symbol:>Unique[sy]},{1}];
			rates=Flatten[model[[;;,2;;]]];
			reactions=reactions/.(Rule@@@Transpose[{species,uniqueSymbolSpecies}]);
			R = reactantMatrix[reactions];  (* Sparse *)
			P = productMatrix[reactions];   (* Sparse *)
			{R,P,rates,NucleicAcids`Private`sortAndReformatStructures[species]}
		];


reactionMatricesFull[in_]:=Module[{R,P,rates,species},
	{R,P,rates,species} = reactionMatrices[in];
	{Normal[R],Normal[P],rates,species}
];



(* ::Subsubsection:: *)
(*revReactions*)

Authors[revReactions]:={"scicomp", "brad"};

(* Replace equilibrium reactions with two irreversible reactions, one in each direction *)
revReactions[mech:ReactionMechanismP]:=
		ReactionMechanism[revReactions[mech[Reactions]]];
revReactions[list:{_Reaction...}]:=
		list /. Reaction[a_,b_,c_,d_]:>Sequence[Reaction[a,b,c],Reaction[b,a,d]];
revReactions[list:{{(_Rule|_Equilibrium),_List}..}]:=
		list /. {Equilibrium[left_,right_],{c_,d_}}:>Sequence[{Rule[left,right],{c}},{Rule[right,left],{d}}];
revReactions[list:{{(_Rule|_Equilibrium),__}..}]:=
		list /. {Equilibrium[left_,right_],c_,d_}:>Sequence[{Rule[left,right],c},{Rule[right,left],d}];
revReactions[reactions:{(_Rule|_Equilibrium)..}] :=
		reactions /. Equilibrium[left_,right_]:>Sequence[Rule[left,right],Rule[right,left]];



(* ::Subsubsection::Closed:: *)
(*reactionsToRates*)


reactionsToRates[reacs:ImplicitReactionsFormatP]:=Map[NucleicAcids`Private`implicitReactionToRates,reacs];


(* ::Subsubsection:: *)
(* IsotopeData/MoleculeValue Fix for 12.2 *)

Authors[fixedPacletWithProgress]={"kevin.hou"};
Authors[applyDataPacletFix]={"kevin.hou"};

(* MM's internal getPacletWithProgress function is bugged in 12.2 and will not load already-installed paclets if $AllowDataUpdates=False. *)
(* The code below is exactly the same as the 12.2 getPacletWithProgress function, except it uses PacletFind to look for local installs when $AllowDataUpdates is False *)
fixedPacletWithProgress[pacletName_String, Optional[pacletDisplayName:_String|Automatic, Automatic], OptionsPattern[]]:=Module[
	{quietingFunc, updateSites, didSiteUpdate},
	updateSites = OptionValue @ "UpdateSites";
	quietingFunc = If[TrueQ[OptionValue @ "AllowMessages"], Identity, Quiet];
	quietingFunc[
		If[
			Or[TrueQ[updateSites],
				And[SameQ[updateSites, Automatic], !TrueQ[PacletManager`Package`$checkedForUpdates]]
			],
			Quiet @ Map[PacletSiteUpdate, PacletSites[]];
			PacletManager`Package`$checkedForUpdates = didSiteUpdate = True
		];
		If[TrueQ[$AllowInternet] && TrueQ[$AllowDataUpdates],
			Block[{$inGetPacletWithProgress = True},
				PacletInstall[pacletName,
					"ShowProgress" -> True,
					UpdatePacletSites -> If[TrueQ[didSiteUpdate], False, Automatic]
				]
			],
			(* If updating is not allowed, attempt to locate required paclets with PacletFind. Return $Failed if they cannot be found *)
			(* Original - $Failed *)
			With[{matchingPaclets=PacletFind[pacletName]},
				If[MatchQ[matchingPaclets,{_PacletObject..}],
					First[matchingPaclets],
					$Failed
				]
			]
		]
	]
];

(* Must duplicate the option definitions of PacletManager`Package`getPacletWithProgress *)
Options[fixedPacletWithProgress] = {
	"IsDataPaclet" -> False,
	"AllowUpdate" -> Automatic,
	"UpdateSites" -> False,
	"AllowMessages" -> False
};


(* Wrapper function to impose a block *)
SetAttributes[applyDataPacletFix, HoldFirst];
applyDataPacletFix[expr_]:=If[MatchQ[$VersionNumber, Alternatives[12.2, 12.3]],
	Block[{PacletManager`Package`getPacletWithProgress=fixedPacletWithProgress},
		ReleaseHold[expr]
	],
	ReleaseHold[expr]
];

(* Evaluate an IsotopeData and MoleculeValue call to initialize data indices for the IsotopeData and ElementData Paclets *)
applyDataPacletFix[{
	IsotopeData["C", "AtomicMass"],
	MoleculeValue[Molecule["Caffeine"], "ElementTally"]
}];