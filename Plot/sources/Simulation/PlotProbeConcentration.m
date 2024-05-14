(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProbeConcentration*)


(* ::Subsubsection:: *)
(*PlotPrimerSet*)


(*DefineOptions[PlotPrimerSet,
	Options :> {
		{Display -> Best, All | Best | First | _Integer, "All displays all primer sets.  Best displays the top non-overlapping primer sets.  First displays the first (top) primer set.  An _Integer displays the top number of primer sets."},
		{PlotType -> Automatic, Automatic | ListPlot | StructureForm | MotifForm, "When PlotType is set to Structure form, the structure of the primer set strands bound to the template will be displayed.  When PlotType is set to MotifForm, the motifs of the primer set strands bound to the template will be displayed. Whe PlotType is set to ListPlot, a list plot of all of the primer positions vs bound (to the target) concentrations will be shown, with the final primer sets overlayed on the plot.  When PlotType is set to Automatic, it will plot the StructureForm of model[PrimerSet] objects or the ListPlot of simulation[PrimerSet] objects."},
		{Mod5Prime -> RGBColor[0, 1, 0], _?ColorQ, "The color with which to display the 5' Modification on the beacon."},
		{Mod3Prime -> GrayLevel[0], _?ColorQ, "The color with which to display the 3' Modification on the beacon."},
		{TargetUnits -> Automatic, Automatic | {_?UnitsQ | Automatic, _?UnitsQ | Automatic | Percent}, "The axes with which to plot the primer set data.  If Percent is inputted for the y-axis, the percent of target bound by probe will be plotted."},
		{TargetConcentration -> Femtomolar, _?ConcentrationQ, "The concentration of target used in the simulated binding reaction.  Used when plotting Percent on the y-axis."},
		{SecondYAxis -> False, BooleanP, "If True, will plot the concentration (or Percent) of free (unbound) probe concentration."},
		{ProbeConcentration -> 0.5*Micromolar, _?ConcentrationQ, "The concentration of probe used in the simulated binding reaction.  Used when plotting Percent on the second y-axis."},
		{Legend -> None, _, "Plot legend.",Category->Hidden},
		{Boxes -> True, _, "Boxes.",Category->Hidden},
		{Orientation -> Column, _, "Plot orientation.",Category->Hidden},
		{PlotRange -> Automatic, _, "Range.",Category->Hidden},
		{ImageSize -> 500, _, "Plot image size.",Category->Hidden},
		{FastTrack -> False, _, "Fast track.",Category->Hidden},
		{Units -> {Nucleotide, Micromolar},_, "Units.",Category->Hidden},
		{Sort -> False,_, "Sort.",Category->Hidden},
		{Amplicon -> True,_,"Amplicon.",Category->Hidden}
	},
	SharedOptions :> {
		ListPlot
	}
];*)


Options[plotPrimerSet]:= {
	TopProbes->10,
	Display -> Best,
	PlotType -> Automatic,
	Mod5Prime -> RGBColor[0, 1, 0],
	Mod3Prime -> GrayLevel[0],
	TargetUnits -> Automatic,
	TargetConcentration -> Femtomolar,
	SecondYAxis -> False,
	ProbeConcentration -> 0.5*Micromolar,
	Legend -> None,
	Boxes -> True,
	Orientation -> Column,
	PlotRange -> Automatic,
	ImageSize -> 800,
	Units -> {Nucleotide, Micromolar},
	Sort -> False,
	Amplicon -> True
};


(*PlotPrimerSet::MissingInteraction="Two or more of your provided primer sequences contain no binding interactions.  Please check your input.";*)
PlotProtein::IncompleteInfo="The PDBIDs field in your provided object, `1`, is Null.  A protein structure therefore cannot be visualized.";
PlotProtein::InvalidPDBID="The provided PDB Object, `1`, is invalid and cannot be found in the protein databank.  A protein structure therefore cannot be visualized.";


(* --- Error messages --- *)
plotPrimerSet[simObject:(ListableP[objectOrLinkP[Object[Simulation,PrimerSet]]]|ListableP[objectOrLinkP[Model[Sample]]]),opts:OptionsPattern[]]:=
	Message[Generic::MissingObject,plotPrimerSet,simObject]/;!DatabaseMemberQ[simObject];


(* --- Core Function: StructureForm or MotifForm --- *)
plotPrimerSet[{forward_?StrandQ,beacon_?StrandQ,reverse_?StrandQ},template_?StrandQ,opts:OptionsPattern[]]:=Module[
	{defaultedOptions,forwardNamed,beaconNamed,reverseNamed,templateNamed,reverseAndTemplate1,revTemplate,forwardAndTemplate2,forwardBeaconTemplate2,joinedStructure},

	(* pull out the defaulted options *)
	defaultedOptions = SafeOptions[plotPrimerSet, ToList[opts]];

	(*give the strands motif names*)
	forwardNamed = ToStrand[forward[[1]],Motif->"Forward"];
	beaconNamed = StrandJoin[ToStrand[beacon[[1]]],ToStrand[beacon[[2]],Motif->"Beacon"],ToStrand[beacon[[3]]]];
	reverseNamed = ToStrand[reverse[[1]],Motif->"Reverse"];
	templateNamed = ToStrand[template[[1]],Motif->"Template"];

	(*get the reverse complement of the template*)
	revTemplate =ReverseComplementSequence[templateNamed];

	(*find the interaction between the forward primer and the ReverseComplementSequence template*)
	forwardAndTemplate2 = Select[
		Pairing[forwardNamed,revTemplate],
		fullyPairedStrandQ[#,forwardNamed,StrandLength[forwardNamed]]&
	];

	(*find the interaction between the reverse primer and the template*)
	reverseAndTemplate1 = Select[
		Pairing[reverseNamed,templateNamed],
		fullyPairedStrandQ[#,reverseNamed,StrandLength[reverseNamed]]&
	];

	(*find the interaction between the forward primer, beacon, and ReverseComplementSequence template*)
	forwardBeaconTemplate2 = Select[
		If[MatchQ[forwardAndTemplate2,{}],
			{},
			Pairing@@Join[{beaconNamed},forwardAndTemplate2]
		],
		anyPairedBeaconQ[#,beaconNamed,StrandLength[beaconNamed]]&
	];

	(* join the structures if possible *)
	joinedStructure = If[Or[MatchQ[reverseAndTemplate1,{}],MatchQ[forwardBeaconTemplate2,{}]],
		(
			Message[plotPrimerSet::MissingInteraction];
			FirstOrDefault[Join[reverseAndTemplate1,forwardBeaconTemplate2]]
		),
		StructureJoin[FirstOrDefault[reverseAndTemplate1],FirstOrDefault[forwardBeaconTemplate2]]
	];

	(*output the stuff*)
	Switch[OptionValue[PlotType],
		MotifForm,MotifForm[joinedStructure,Axes->False,Frame->False,PassOptions[plotPrimerSet,MotifForm,defaultedOptions]],
		_|StructureForm,StructureForm[joinedStructure,Axes->False,Frame->False,PassOptions[plotPrimerSet,StructureForm,defaultedOptions]]
	]

];

(*
	return True if 'strand' is fully bonded in structure
*)
fullyPairedStrandQ[structure_Structure,strand_Strand,length_]:= Module[{pos},
	pos=Position[structure[Strands],strand,{1}][[1,1]];
	And[
		Length[structure[Strands]]===2,
		Length[structure[Bonds]]===1,
		MemberQ[structure[Strands],strand],
		MemberQ[structure[Bonds],	Bond[{pos,1;;length},_]|Bond[_,{pos,1;;length}]]
	]
];

anyPairedBeaconQ[structure_Structure,beacon_,length_]:=Module[{pos},
	pos=Position[structure[Strands],beacon,{1}][[1,1]];
	And[
		Length[structure[Strands]]===3,
		Length[structure[Bonds]]===2,
		MemberQ[structure[Strands],beacon],
		MemberQ[
			structure[Bonds],
			Bond[{pos,2;;_Integer},_]|Bond[_,{pos,2;;_Integer}]
		]
	]
];


(* --- Listable --- *)
plotPrimerSet[primers:{{forward_?StrandQ,beacon_?StrandQ,reverse_?StrandQ}..},template_?StrandQ,opts:OptionsPattern[]]:=
	(plotPrimerSet[#,template,opts]&/@primers);


(* --- Core Function: ListPlot --- *)
plotPrimerSet[forwards:({{_Integer,_Integer,_?StrandQ,_?NumericQ}..}|{{_Integer,_Integer,_?StrandQ,_?NumericQ,_?NumericQ}..}|{{_Integer,_Integer,_?StrandQ,_?NumericQ,_?NumericQ,_?NumericQ}..}),primerProbeSets:{{{_Integer,_Integer},_?StrandQ,_Real,{_Integer,_Integer},_?StrandQ,_Real,{_Integer,_Integer},_?StrandQ,_Real,_Real,_Integer}..},opts:OptionsPattern[]]:=Module[
	{defaultedOptions,axes,yUnit,converted,toPlot,plotrange,minLength,sortedSets,forwardWinners,reverseWinners,beaconWinners,winnerFConcs,winnerRConcs,winnerBConcs,
	forwardEpis,reverseEpis,beaconEpis,colors,epilog,y2Unit,secondYData,convertedSecond,secondYTicks,secondYGraphic,listPlot,unresolvedLegend,resolvedLegend},

	(* pull out the defaulted options *)
	defaultedOptions = SafeOptions[plotPrimerSet, ToList[opts]];

	(*set the axes*)
	axes = Switch[(TargetUnits/.defaultedOptions),
		{_?UnitsQ,_?UnitsQ},(TargetUnits/.defaultedOptions),
		{Automatic,_?UnitsQ},{First[(Units/.defaultedOptions)],(TargetUnits/.defaultedOptions)[[2]]},
		{_?UnitsQ,Automatic},{(TargetUnits/.defaultedOptions)[[1]],Automatic},
		{Automatic,Percent},{First[(Units/.defaultedOptions)],Automatic},
		{_?UnitsQ,Percent},{(TargetUnits/.defaultedOptions)[[1]],Automatic},
		_|Automatic,{First[(Units/.defaultedOptions)],Automatic}
	];

	(*Convert the concentrations and transpose points*)
	yUnit = Switch[axes[[2]],
		Automatic,First[Commonest[Units[UnitScale[forwards[[All,4]]*Last[(Units/.defaultedOptions)]]]]],
		_,axes[[2]]
	];

	converted = SortBy[Transpose[{
		Convert[forwards[[All,1]],Nucleotide,axes[[1]]],
		Convert[forwards[[All,2]],Nucleotide,axes[[1]]],
		If[Or[MatchQ[(TargetUnits/.defaultedOptions),Automatic],!MatchQ[Last[(TargetUnits/.defaultedOptions)],Percent]],
			Convert[forwards[[All,4]],Last[(Units/.defaultedOptions)],yUnit],
			Convert[forwards[[All,4]],Last[(Units/.defaultedOptions)],Units[(TargetConcentration/.defaultedOptions)]]/Unitless[(TargetConcentration/.defaultedOptions)]*100
		],
		StrandLength[forwards[[All,3]]]
	}],First];

	toPlot = Middle[Gather[converted,#1[[4]]==#2[[4]]&]][[All,{1,3}]];

	(*set the plot range*)
	plotrange = FindPlotRange[(PlotRange/.defaultedOptions),Join[converted[[All,{1,3}]],converted[[All,{2,3}]]]];

	(*sort the primerprobesets if we want*)
	minLength = Min[(#[[2]]-#[[1]]+1)&/@(primerProbeSets[[All,1]])];
	sortedSets = Switch[(Display/.defaultedOptions),
		First,{SelectqPCRSets[minLength,primerProbeSets,PassOptions[plotPrimerSet,SelectqPCRSets,defaultedOptions]][[1]]},
		All,primerProbeSets,
		_Integer,Take[primerProbeSets,Min[{Length[primerProbeSets],(Display/.defaultedOptions)}]],
		_|Best,SelectqPCRSets[minLength,primerProbeSets,PassOptions[plotPrimerSet,SelectqPCRSets,defaultedOptions]]
	];

	(*pull the winning coordinates out of the primerProbeSets input*)
	forwardWinners = Convert[sortedSets[[All,1]],{First[(Units/.defaultedOptions)],First[(Units/.defaultedOptions)]},{axes[[1]],axes[[1]]}];
	reverseWinners = Convert[sortedSets[[All,4]],{First[(Units/.defaultedOptions)],First[(Units/.defaultedOptions)]},{axes[[1]],axes[[1]]}];
	beaconWinners = Convert[sortedSets[[All,7]],{First[(Units/.defaultedOptions)],First[(Units/.defaultedOptions)]},{axes[[1]],axes[[1]]}];

	(*find the bound concentrations associated with each winning primer/probe*)
	winnerFConcs = Transpose[{forwardWinners,Cases[converted,{#[[1]],#[[2]],conc_,_Integer}:>conc]&/@forwardWinners}];
	winnerRConcs = Transpose[{reverseWinners,Cases[converted,{#[[1]],#[[2]],conc_,_Integer}:>conc]&/@reverseWinners}];
	winnerBConcs = Transpose[{beaconWinners,Cases[converted,{#[[1]],#[[2]],conc_,_Integer}:>conc]&/@beaconWinners}];

	(*make the prolog lines for all the winning primers*)
	forwardEpis = MapThread[Arrow[{{#1[[2]],#2[[1]]},{#1[[1]],#2[[1]]}}]&,Transpose[winnerFConcs]];
	reverseEpis= MapThread[Arrow[{{#1[[1]],#2[[1]]},{#1[[2]],#2[[1]]}}]&,Transpose[winnerRConcs]];
	beaconEpis = MapThread[{
		Line[{{#1[[1]],#2[[1]]},{#1[[2]],#2[[1]]}}],
		PointSize[Large],
		(Mod3Prime/.defaultedOptions),Point[{#1[[1]],#2[[1]]}],
		(Mod5Prime/.defaultedOptions),Point[{#1[[2]],#2[[1]]}]
	}&,Transpose[winnerBConcs]];

	(*put the color coded prolog together*)
	colors = Table[ColorData[97,i],{i,1,Length[forwardEpis]}];
	epilog = Transpose[{colors,forwardEpis,reverseEpis,beaconEpis}];

	(*create the epilog for the second y-axis*)

	(*get the correct Units*)
	y2Unit = If[And[MatchQ[(SecondYAxis/.defaultedOptions),True],MatchQ[forwards,{{_Integer,_Integer,_?StrandQ,_Real,_Real}..}]],
		Switch[axes[[2]],
			Automatic,First[Commonest[Units[UnitScale[forwards[[All,5]]*Last[(Units/.defaultedOptions)]]]]],
			_,axes[[2]]
		]
	];

	(*get the datapoints*)
	secondYData = If[And[MatchQ[(SecondYAxis/.defaultedOptions),True],MatchQ[forwards,{{_Integer,_Integer,_?StrandQ,_Real,_Real}..}]],
		convertedSecond = SortBy[Transpose[{
			Convert[forwards[[All,1]],Nucleotide,axes[[1]]],
			Convert[forwards[[All,2]],Nucleotide,axes[[1]]],
			If[Or[MatchQ[(TargetUnits/.defaultedOptions),Automatic],!MatchQ[Last[(TargetUnits/.defaultedOptions)],Percent]],
				Convert[forwards[[All,5]],Last[(Units/.defaultedOptions)],y2Unit],
				Convert[forwards[[All,5]],Last[(Units/.defaultedOptions)],Units[(ProbeConcentration/.defaultedOptions)]]/Unitless[(ProbeConcentration/.defaultedOptions)]*100
			],
			StrandLength[forwards[[All,3]]]
		}],First];
		Middle[Gather[convertedSecond,#1[[4]]==#2[[4]]&]][[All,{1,3}]]
	];

	(*make the frame ticks for the second y*)
	secondYTicks = If[And[MatchQ[(SecondYAxis/.defaultedOptions),True],MatchQ[forwards,{{_Integer,_Integer,_?StrandQ,_Real,_Real}..}]],
		EmeraldFrameTicks[plotrange[[2]],{0,Automatic},{secondYData}],
		None
	];

	(*create the second y-axis graphic*)
	secondYGraphic = If[And[MatchQ[(SecondYAxis/.defaultedOptions),True],MatchQ[forwards,{{_Integer,_Integer,_?StrandQ,_Real,_Real}..}]],
		Core`Private`secondYEpilog[{secondYData},DataPoints,{0,Automatic},PlotRange->plotrange],
		{}
	];
	(* --- Legend --- *)
	unresolvedLegend = If[MatchQ[(Legend/.defaultedOptions),Automatic],
			Table["PrimerSet #"<>ToString[i],{i,1,Length[forwardEpis]}],
			OptionValue[Legend]
	];
	resolvedLegend = Core`Private`resolvePlotLegends[unresolvedLegend,PassOptions[plotPrimerSet,Core`Private`resolvePlotLegends,LegendColors->Flatten@{colors,colors},opts]];

	(*output the plot*)
	EmeraldListLinePlot[
		toPlot,
		Frame->{True,True,False,If[And[MatchQ[(SecondYAxis/.defaultedOptions),True],MatchQ[forwards,{{_Integer,_Integer,_?StrandQ,_Real,_Real}..}]],True,False]},
		FrameLabel->{
			"Probe Position "<>UnitForm[axes[[1]],Number->False],
			If[Or[MatchQ[(TargetUnits/.defaultedOptions),Automatic],!MatchQ[Last[(TargetUnits/.defaultedOptions)],Percent]],
				"Bound Probe "<>UnitForm[yUnit,Number->False],
				"Percent of Target Bound by Probe "<>UnitForm[Percent,Number->False]
			],
			None,
			If[And[MatchQ[(SecondYAxis/.defaultedOptions),True],MatchQ[forwards,{{_Integer,_Integer,_?StrandQ,_Real,_Real}..}]],
				If[Or[MatchQ[(TargetUnits/.defaultedOptions),Automatic],!MatchQ[Last[(TargetUnits/.defaultedOptions)],Percent]],
					"Free Probe "<>UnitForm[y2Unit,Number->False],
					"Percent of Probe Not Bound to Target "<>UnitForm[Percent,Number->False]
				],
				None
			]
		},
		ImageSize->800,
		PlotRange->plotrange,
		Epilog->Join[secondYGraphic,{AbsoluteThickness[1.5]},Reverse[Rest[epilog]],{AbsoluteThickness[3],First[epilog]}],
		PlotLegends->resolvedLegend,
		PassOptions[plotPrimerSet,ListPlot,defaultedOptions]
	]

];


(* --- SLLified: info packet --- *)

(* StructureForm *)
plotPrimerSet[simObject:PacketP[Object[Simulation,PrimerSet]],opts:OptionsPattern[]]:=Module[{defaultedOptions,sorted},

	(* pull out the defaulted options *)
	defaultedOptions = SafeOptions[plotPrimerSet, ToList[opts]];

	sorted = Switch[(Display/.defaultedOptions),
		First,{GetqPCRPrimerSequences[simObject,Amplicon->False,Sort->True][[1]]},
		All,GetqPCRPrimerSequences[simObject,Amplicon->False,Sort->False],
		_Integer,Take[GetqPCRPrimerSequences[simObject,Amplicon->False,Sort->False],Min[{NumberOfCandidates/.simObject,OptionValue[Display]}]],
		_|Best,GetqPCRPrimerSequences[simObject,Amplicon->False,Sort->True]
	];

	plotPrimerSet[#,Strand[DNA[TargetSequence/.simObject]],defaultedOptions]&/@sorted
]/;And[MatchQ[OptionDefault[OptionValue[PlotType],Verbose->False],StructureForm|MotifForm],MatchQ[OptionDefault[OptionValue[FastTrack],Verbose->False],True]];

(* ListPlot *)
plotPrimerSet[simObject:PacketP[Object[Simulation,PrimerSet]],opts:OptionsPattern[plotPrimerSet]]:=
	plotPrimerSet[Unitless[ForwardPrimers/.simObject],Unitless[PrimerProbeSets/.simObject],TargetConcentration->(TargetConcentration/.simObject),ProbeConcentration->(PrimerConcentration/.simObject),opts]/;MatchQ[OptionDefault[OptionValue[PlotType],Verbose->False],ListPlot|Automatic];


(* --- SLLified: simulation Object --- *)
plotPrimerSet[simObject:(objectOrLinkP[Object[Simulation,PrimerSet]]|{objectOrLinkP[Object[Simulation,PrimerSet]]..}),opts:OptionsPattern[]]:= plotPrimerSet[Download[simObject],opts];


(* --- SLLified: model[PrimerSet] --- *)
plotPrimerSet[primerSet:PacketP[Model[Sample]],opts:OptionsPattern[]]:=
Module[
	{oligos,forward,reverse,beacon,template},

	(* pull the primer objects from the primer set *)
	oligos = Unitless[{ForwardPrimer,ReversePrimer,Beacon,SenseAmplicon}/.primerSet];

	(* pull the strands out of the Oligomer objects *)
	{forward,reverse,beacon,template} = Map[First,Strand/.Download[oligos]];

	(* pass on to core function *)
	plotPrimerSet[{forward,beacon,reverse},template,opts]

]/;MatchQ[OptionDefault[OptionValue[PlotType],Verbose->False],StructureForm|MotifForm|Automatic];


plotPrimerSet[primerSet:PacketP[Model[Sample]],opts:OptionsPattern[]]:=
	plotPrimerSet[DesignSimulation/.primerSet,opts]/;MatchQ[OptionDefault[OptionValue[PlotType],Verbose->False],ListPlot];


plotPrimerSet[primerSet:(objectOrLinkP[Model[Sample]]|{objectOrLinkP[Model[Sample]]..}),opts:OptionsPattern[]]:=
	plotPrimerSet[Download[primerSet],opts];


plotPrimerSet[primerSet:({PacketP[Model[Sample]]..}|{PacketP[Object[Simulation,PrimerSet]]..}),opts:OptionsPattern[]]:=
	plotPrimerSet[#,opts]&/@primerSet;


(* ::Subsubsection::Closed:: *)
(*GetqPCRPrimerSequences*)


DefineOptions[GetqPCRPrimerSequences,
	Options :> {
		{Sort -> False, True | False, "If True, the function will automatically sort and select the primer sets before outputing the sequences.  If False, sequences will be returned for all primer sets."},
		{Orientation -> Antisense, Sense | Antisense, "The orientation of the primer set: ie, whether the beacon probe binds to the sense strand or the antisense strand."},
		{Mod5Prime -> "Fluorescein", _String, "The 5' modifier of the probe."},
		{Mod3Prime -> "Bhqtwo", _String, "The 3' modifier of the probe."},
		{Amplicon -> True, True | False, "If True, the function will return both the sense and antisense amplicon sequences. If False, only the Forward Primer, Probe, and Reverse Primer will be returned."},
		{BeaconStemLength -> False, _, "Stem length of beacon.", Category->Hidden}
	}
];


(* --- Core Function --- *)
GetqPCRPrimerSequences[target_,primerProbes:{{{_Integer,_Integer},_?StrandQ,_Real,{_Integer,_Integer},_?StrandQ,_Real,{_Integer,_Integer},_?StrandQ,_Real,_Real,_Integer}..},opts:OptionsPattern[GetqPCRPrimerSequences]]:=Module[
	{forward, reverse, probe,amplicon,revAmplicon,beaconStems},

	(*pull out the easy stuff*)
	forward = primerProbes[[All,2]];
	reverse = primerProbes[[All,5]];
	probe = ToStrand[{OptionValue[Mod5Prime],#[[1]],OptionValue[Mod3Prime]}]&/@(primerProbes[[All,8]]);

	(*pull out the amplicon sequences*)
	amplicon = MapThread[ReverseComplementSequence[StringTake[ReverseComplementSequence[target],{#1,#2}]]&,{primerProbes[[All,4,1]],primerProbes[[All,1,2]]}];
	revAmplicon = ReverseComplementSequence[amplicon];

	(*add the beacon stem lengths if we want them*)
	beaconStems = If[MatchQ[OptionValue[BeaconStemLength],True],{Last/@primerProbes},{}];

	(*output*)
	If[OptionValue[Amplicon],
		Transpose[Join[{forward,probe,reverse,Strand[DNA[#]]&/@amplicon,Strand[DNA[#]]&/@revAmplicon},beaconStems]],
		Transpose[Join[{forward,probe,reverse},beaconStems]]
	]
]/;MatchQ[OptionValue[Sort],False];

(* --- Sort->True --- *)
GetqPCRPrimerSequences[target_,primerProbes:{{{_Integer,_Integer},_?StrandQ,_Real,{_Integer,_Integer},_?StrandQ,_Real,{_Integer,_Integer},_?StrandQ,_Real,_Real,_Integer}..},opts:OptionsPattern[GetqPCRPrimerSequences]]:=Module[
	{probeLengthMin,sorted},

	probeLengthMin = MapThread[#2-#1+1&,Transpose[primerProbes[[All,1]]]];

	sorted = SelectqPCRSets[probeLengthMin,primerProbes];
	GetqPCRPrimerSequences[target,sorted,Sort->False,opts]

]/;MatchQ[OptionValue[Sort],True];

(* --- SLLified --- *)
GetqPCRPrimerSequences[simObject: PacketP[Object[Simulation, PrimerSet]],opts:OptionsPattern[GetqPCRPrimerSequences]]:=
	GetqPCRPrimerSequences[TargetSequence/.simObject,Unitless[PrimerProbeSets/.simObject],opts]/;MatchQ[OptionValue[Sort],False];

GetqPCRPrimerSequences[simObject: PacketP[Object[Simulation, PrimerSet]],opts:OptionsPattern[GetqPCRPrimerSequences]]:=Module[{sorted},
	sorted = SelectqPCRSets[simObject];
	GetqPCRPrimerSequences[TargetSequence/.simObject,sorted,Sort->False,opts]
]/;MatchQ[OptionValue[Sort],True];

GetqPCRPrimerSequences[simObject: objectOrLinkP[Object[Simulation, PrimerSet]],opts:OptionsPattern[GetqPCRPrimerSequences]]:=GetqPCRPrimerSequences[Download[simObject],opts];


(* ::Subsubsection::Closed:: *)
(*SelectqPCRSets*)


(* --- Core Function --- *)
SelectqPCRSets[probeLengthMin_,probeList_]:=Module[{sorted},

	(*first sort the items in the probeList according to maximum free concentrations of primers and probes and minimum primer dimer concentration*)
	sorted = Sort[probeList,Total[#1[[{3,6,9}]]]>Total[#2[[{3,6,9}]]]&&#1[[10]]<#2[[10]]&];

	(*pull out non-overlapping primer sets*)
	Fold[Function[{list,item},If[(Or@@(MemberQ[list[[All,1,1]],#]&/@Range[item[[1,1]]-probeLengthMin,item[[1,1]]+probeLengthMin])),list,Append[list,item]]],{First[sorted]},Rest[sorted]]
];

(* --- SLLified for simulation objects --- *)
SelectqPCRSets[simObject:PacketP[Object[Simulation,PrimerSet]]]:=SelectqPCRSets[Unitless[MinPrimerLength/.simObject],Unitless[PrimerProbeSets/.simObject]];

SelectqPCRSets[simObject: ObjectP[Object[Simulation, PrimerSet]]]:=SelectqPCRSets[Download[simObject]];


(* ::Subsection::Closed:: *)
(*Structure & Strand Blobs*)


$DisplayStructures=True;
$DisplayStrands=True;
$MaxMotifLength=50;

installEmeraldStructureBlobs[]:=Module[{},

	Structure /: MakeBoxes[structure_Structure?StructureQ, StandardForm] := With[
		{ns=Map[StrandLength[#,Total->False]&,structure[[1]]]},
		Which[
			Or[
				(* structure with bonds at motif level *)
				MatchQ[structure[Bonds],{MotifBondP..}],
				(* Any doubly long strand *)
				Max[Flatten[ns]]>2*$MaxMotifLength,
				(* Long strands with no bonds *)
				And[MatchQ[structure[Bonds],{}],Max[Flatten[ns]]>$MaxMotifLength]
			],
				(* MotifForm *)
				With[{boxes = ToBoxes[Show[First@MotifForm[structure]]]},
					InterpretationBox[boxes,structure,SelectWithContents->False]
				],
			True,
				(* StructureForm *)
				With[
					{boxes=ToBoxes[Show[First@StructureForm[structure]]]},
					InterpretationBox[boxes,structure,SelectWithContents->False]
				]
		]


	]/; TrueQ[$DisplayStructures];


	Strand /: MakeBoxes[strand_Strand?StrandQ, StandardForm] := With[
		{ns=StrandLength[strand,Total->False]},

		Which[
			(* long strand *)
			Max[ns]>$MaxMotifLength,
				(* MotifForm *)
				With[{boxes = ToBoxes[Show[First@MotifForm[strand]]]},
					InterpretationBox[boxes,strand,SelectWithContents->False]
				],
			(* short strand *)
			True,
				(* StructureForm *)
				With[{boxes=ToBoxes[Show[First@StructureForm[strand]]]},
					InterpretationBox[boxes,strand,SelectWithContents->False]
				]
		]

	]/; And[TrueQ[$DisplayStructures],TrueQ[$DisplayStrands]];
];
OnLoad[installEmeraldStructureBlobs[]];

shortenStructure[structure_Structure]:=MapAt[shortenStrand/@#&,structure,1];

shortenStrand[strand_Strand]:=Map[shortenMotif,strand];

shortenMotif[pol_[seq_,rest___]]:=pol[shortenSequenceString[seq,pol,3],rest];

shortenSequenceString[seq_,pol_,showSize_]:=With[
	{n=SequenceLength[seq,Polymer->pol,FastTrack->True]},
	If[n>$MaxMotifLength,
		Tooltip[
			StringJoin[
				SequenceTake[seq,showSize,Polymer->pol,FastTrack->True],
				"...<<",
				ToString[n-2*showSize],
				">>...",
				SequenceTake[seq,-showSize,Polymer->pol,FastTrack->True]
			],
			seq
		],
		seq
	]
];


(* ::Subsection::Closed:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*MotifFormP*)


MotifFormP = Verbatim[Interpretation][_?ValidGraphicsQ,_Structure|_Strand];


(* ::Subsection::Closed:: *)
(*PlotProbeConcentration*)


DefineOptions[PlotProbeConcentration,
	Options :> {
		{
			OptionName -> TopProbes,
			Default -> 10,
			Description -> "Displays the top N selected probes ranked by their correctly-bound concentrations.",
			AllowNull -> False,
			Category -> "Probes",
			Widget -> Widget[Type->Number, Pattern:>GreaterP[0,1]]
		},
		OutputOption
	},
	SharedOptions :> {
		{EmeraldListLinePlot,
			{
				AspectRatio,ImageSize,Zoomable,
				PlotRange,PlotRangeClipping,ClippingStyle,
				PlotLabel,FrameLabel,RotateLabel,LabelStyle,
				Background,ColorFunction,ColorFunctionScaling,Filling,FillingStyle,
				InterpolationOrder,Joined,PlotMarkers,PlotStyle,
				Frame,FrameStyle,FrameTicks,FrameTicksStyle,
				GridLines,GridLinesStyle,Prolog,Epilog
			}
		}
	}
];

(* Messages *)
Error::PrimersNotFound="Required primers are missing in `1`. Please ensure both ForwardPrimers and PrimerProbeSets are informed in this object.";

(* Packet overload for Object[Simulation,ProbeSelection] *)
PlotProbeConcentration[psPacket:PacketP[Object[Simulation, ProbeSelection]], ops:OptionsPattern[]]:= Module[
	{pos, boundConc, probeStrands},

	(* Grab necessary fields *)
	pos = Lookup[psPacket, Replace[TargetPosition]];
	boundConc = Lookup[psPacket, Replace[BoundProbeConcentration]];
	probeStrands = Lookup[psPacket, Replace[ProbeStrands]];

	(* Pass to main overload *)
	PlotProbeConcentration[pos, boundConc, probeStrands, ops]
];


(* Object overload for Object[Simulation, ProbeSelection] *)
PlotProbeConcentration[obj:ObjectP[Object[Simulation, ProbeSelection]], ops:OptionsPattern[]]:= Module[
	{packet, pos, boundConc, probeStrands},

	(* Download from the requested object *)
	packet = Download[obj];

	(* Grab necessary fields *)
	pos = Lookup[packet, TargetPosition];
	boundConc = Lookup[packet, BoundProbeConcentration];
	probeStrands = Lookup[packet, ProbeStrands];

	(* Pass to the main overload *)
	PlotProbeConcentration[pos, boundConc, probeStrands, ops]
];


(* Primary overload for ProbeSelection simulation *)
PlotProbeConcentration[
	pos:{{GreaterP[0,1],GreaterP[0,1]}..},
	boundConc:{GreaterEqualP[0 Molar]..},
	probeStrands:{StrandP...},
	ops:OptionsPattern[PlotProbeConcentration]
]:=Module[
	{
		originalOps,safeOps,output,topK,targetUnit,sortedX,dataToPlot,optionsToPass,maxYVal,
		probeEpilogs,automaticPlotRange,applyDefaultOption,result,mostlyResolvedOps,resolvedOps
	},

	(* Original options passed, as a list *)
	originalOps=ToList[ops];

	(* Unspecified options set to defaults *)
	safeOps=SafeOptions[PlotProbeConcentration,originalOps];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* top k selected probes to display *)
	topK=Lookup[safeOps,TopProbes];

	(* Units of bound concentration *)
	targetUnit=Units[UnitScale[Max[boundConc]]];

	(* Maximum numerical y-value in data, for plot range *)
	maxYVal=Unitless@Convert[Max[boundConc],targetUnit];

	(* Process inputs to generate the xy data to plot *)
	dataToPlot=SortBy[Transpose[{pos[[;;,1]],boundConc}],First];

	(* Probe epilogs *)
	probeEpilogs=epilogProbeSelection[
		pos[[1;;topK]],
		boundConc[[1;;topK]],
		targetUnit,
		probeStrands[[1;;topK]],
		topK
	];

	(* Plot range to use if PlotRange is Automatic or unspecified *)
	automaticPlotRange={{0,Last[Last[SortBy[pos,First]]]*1.07},{0,maxYVal*1.02}};

	(* Options to pass to EmeraldListLinePlot *)
	optionsToPass=ToList@stringOptionsToSymbolOptions[
		PassOptions[PlotProbeConcentration,EmeraldListLinePlot,Sequence@@safeOps]
	];

	(* Generate a default option if original option was unspecified or Automatic, Nothing otherwise *)
	applyDefaultOption[opName_Symbol,val_]:=If[MatchQ[Lookup[originalOps,opName],_Missing|Automatic],
		opName->val,
		Nothing
	];

	(* Call ELLP and get the plot and resolved options *)
	{result,mostlyResolvedOps}=EmeraldListLinePlot[dataToPlot,
		ReplaceRule[optionsToPass,
			{
				(* Apply default option if option wasn't specified or was Automatic *)
				applyDefaultOption[Filling,Bottom],
				applyDefaultOption[FrameLabel,{"Probe Position (nt)", "Bound Probe Concentration"<>UnitForm[targetUnit, Number->False]}],
				applyDefaultOption[Epilog,probeEpilogs],
				applyDefaultOption[TargetUnits,{Automatic, targetUnit}],
				applyDefaultOption[PlotRange,automaticPlotRange],
				applyDefaultOption[ImageSize,800],
				(* Get result and resolved options *)
				ScaleY->1,
				Output->{Result,Options}
			}
		]
	];

	(* Resolve remaining options *)
	resolvedOps=ReplaceRule[safeOps,
		(* Drop the output option so we return the Output option passed to THIS function *)
		DeleteCases[mostlyResolvedOps,Output->_],
		Append->False
	];

	(* Return the requested outputs *)
	output/.{
		Result->result,
		Preview->result/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Options->resolvedOps,
		Tests->{}
	}
];


(* Generate epilogs for showing probe locations *)
epilogProbeSelection[pos_, boundConc_, targetUnit_, probeStrands_, topK_]:= Module[
	{boundConcNum, combined, split, sortedSplit, sortedSplitGap, arrow2Rank, arrow2Seq, arrow2DashHight},

	boundConcNum = Unitless[boundConc, targetUnit];
	combined = Transpose[{pos, boundConcNum}];

	(* split positions by overlapping regions *)
	split = Split[SortBy[combined, First[First[#]]&], Last[First[#1]]>First[First[#2]]&];
	sortedSplit = Reverse[SortBy[#,Last]]&/@split;

	(* plot gap between adjacent rectangles *)
	sortedSplitGap = Flatten[Function[{x}, MapIndexed[{First[#1], Last[#1]-(#2-1)*If[topK==10, 50, 700/topK]}&, x]]/@sortedSplit, 1];

	(* create a mapping to annotate arrows with rank indices and actual sequence *)
	arrow2Rank = Thread[First/@SortBy[Transpose[{pos[[;;,1]], boundConc}], Last] -> Reverse[Range[Length[pos]]]];
	arrow2Seq = Thread[pos[[;;,1]] -> (First[#[Sequences]]&/@probeStrands)];
	arrow2DashHight = Thread[First/@First/@combined -> Last/@combined];

	mouseoverEvent[#1, arrow2Rank, arrow2Seq, arrow2DashHight]&/@sortedSplitGap
];

(* Helper function for creating mouseover labels in epilogs *)
mouseoverEvent[postCell_, arrow2Rank_, arrow2Seq_, arrow2DashHight_]:= Module[
	{nonMouseLook, xLeft, xRight, y, mouseoverLook},

	(* if no mouse over, plot simple arrows *)
	{xLeft, xRight, y} = {First[First[postCell]], Last[First[postCell]], First[Last[postCell]]};

	(* Display when there is no mouseover *)
	nonMouseLook = {RGBColor[0, 0.51, 0.96], Thickness[0.005], Arrowheads[Large],
		Tooltip[Arrow[{{xRight, y},{xLeft, y}}], xLeft/.arrow2Seq],
		Text[Style[ToString[xLeft/.arrow2Rank], FontSize->20], {xRight+3, y}]
	};

	(* if mouse over, hightlight and plot vertical lines *)
	mouseoverLook = {Red, Thickness[0.005], Arrowheads[Large],
		Tooltip[Arrow[{{xRight, y},{xLeft, y}}], xLeft/.arrow2Seq],
		Text[Style[ToString[xLeft/.arrow2Rank], FontSize->20], {xRight+3, y}],
		Dashed, Thick, Line[{{xLeft, 0}, {xLeft, xLeft/.arrow2DashHight}}]
	};

	(* Return the mouseover graphic *)
	Mouseover[nonMouseLook, mouseoverLook]
];


(* Primary overload for Object[Simulation,PrimerSet] *)
PlotProbeConcentration[
	obj:ObjectP[Object[Simulation,PrimerSet]],
	ops:OptionsPattern[PlotProbeConcentration]
]:=Module[
	{
		originalOps,safeOps,output,packet,forwardPrimer,primerProbes,targetConc,probeConc,
		arrow2Seq,arrow2DashHight,y2Unit,plotPrimerSetOps,axes,yUnit,converted,
		plotData,plotrange,minLength,sortedSets,forwardWinners,reverseWinners,beaconWinners,
		winnerFConcs,winnerRConcs,winnerBConcs,optionsToPass,applyDefaultOption,
		primerEpilogs,result,mostlyResolvedOps,resolvedOps
	},

	(* Original options passed, as a list *)
	originalOps=ToList[ops];

	(* Unspecified options set to defaults *)
	safeOps=SafeOptions[PlotProbeConcentration,originalOps];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Download packet form of input object *)
	packet=Download[obj];

	(* Extract position and concentration info from downloaded packet *)
	{forwardPrimer,primerProbes,targetConc,probeConc}={
		Unitless[ForwardPrimers/.packet],
		Unitless[PrimerProbeSets/.packet],
		TargetConcentration/.packet,
		ProbeConcentration/.packet
	};

	(* Return early if required fields are empty *)
	If[(forwardPrimer==={})||(primerProbes==={}),
		Message[Error::PrimersNotFound,obj];
		Message[Error::InvalidInput,obj];
		Return[output/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->{}
		}]
	];

	(* Pull defaulted options from plotPrimerSet *)
	plotPrimerSetOps=SafeOptions[plotPrimerSet,
		ToList@stringOptionsToSymbolOptions[
			PassOptions[PlotProbeConcentration,plotPrimerSet,ops]
		]
	];

	(* Set the axes *)
	axes=Switch[(TargetUnits/.plotPrimerSetOps),
		{_?UnitsQ,_?UnitsQ},
			(TargetUnits/.plotPrimerSetOps),
		{Automatic,_?UnitsQ},
			{First[(Units/.plotPrimerSetOps)],(TargetUnits/.plotPrimerSetOps)[[2]]},
		{_?UnitsQ,Automatic},
			{(TargetUnits/.plotPrimerSetOps)[[1]],Automatic},
		{Automatic,Percent},
			{First[(Units/.plotPrimerSetOps)],Automatic},
		{_?UnitsQ,Percent},
			{(TargetUnits/.plotPrimerSetOps)[[1]],Automatic},
		_|Automatic,
			{First[(Units/.plotPrimerSetOps)],Automatic}
	];

	(* Convert the concentrations and transpose points *)
	yUnit=If[axes[[2]]===Automatic,
		First[Commonest[Units[UnitScale[forwardPrimer[[All,4]]*Last[(Units/.plotPrimerSetOps)]]]]],
		axes[[2]]
	];

	(* Converted primers *)
	converted=SortBy[
		Transpose[{
			Convert[forwardPrimer[[All,1]],Nucleotide,axes[[1]]],
			Convert[forwardPrimer[[All,2]],Nucleotide,axes[[1]]],
			If[Or[MatchQ[(TargetUnits/.plotPrimerSetOps),Automatic],!MatchQ[Last[(TargetUnits/.plotPrimerSetOps)],Percent]],
				Convert[
					forwardPrimer[[All,4]],
					Last[(Units/.plotPrimerSetOps)],
					yUnit
				],
				Convert[
					forwardPrimer[[All,4]],
					Last[(Units/.plotPrimerSetOps)],
					Units[(TargetConcentration/.plotPrimerSetOps)]
				]/Unitless[(TargetConcentration/.plotPrimerSetOps)]*100
			],
			StrandLength[forwardPrimer[[All,3]]]
		}],
		First
	];

	(* Data points to plot *)
	plotData=Middle[Gather[converted,#1[[4]]==#2[[4]]&]][[All,{1,3}]];

	(* Set the plot range *)
	plotrange=FindPlotRange[(PlotRange/.plotPrimerSetOps),
		Join[converted[[All,{1,3}]],
		converted[[All,{2,3}]]]
	];

	(* Sort primer probe sets *)
	minLength=Min[(#[[2]]-#[[1]]+1)&/@(primerProbes[[All,1]])];
	sortedSets=Take[primerProbes,Min[{Length[primerProbes],(TopProbes/.safeOps)}]];

	(* Extract coordinates from 'winning' primers/probes *)
	forwardWinners=Convert[sortedSets[[All,1]],{First[(Units/.plotPrimerSetOps)],First[(Units/.plotPrimerSetOps)]},{axes[[1]],axes[[1]]}];
	reverseWinners=Convert[sortedSets[[All,4]],{First[(Units/.plotPrimerSetOps)],First[(Units/.plotPrimerSetOps)]},{axes[[1]],axes[[1]]}];
	beaconWinners=Convert[sortedSets[[All,7]],{First[(Units/.plotPrimerSetOps)],First[(Units/.plotPrimerSetOps)]},{axes[[1]],axes[[1]]}];

	(* Extract concentrations from each 'winning' primer/probe *)
	winnerFConcs=Transpose[{forwardWinners,Cases[converted,{#[[1]],#[[2]],conc_,_Integer}:>conc]&/@forwardWinners}];
	winnerRConcs=Transpose[{reverseWinners,Cases[converted,{#[[1]],#[[2]],conc_,_Integer}:>conc]&/@reverseWinners}];
	winnerBConcs=Transpose[{beaconWinners,Cases[converted,{#[[1]],#[[2]],conc_,_Integer}:>conc]&/@beaconWinners}];

	(* Map positions to sequences *)
	arrow2Seq=DeleteDuplicates[
		Flatten[
			{
				#[[1]][[1]]->First[#[[2]][Sequences]],
				#[[4]][[1]]->First[#[[5]][Sequences]],
				#[[7]][[1]]->First[#[[8]][Sequences]]
			}&/@sortedSets
		]
	];

	(* Map positions to concentrations/dashed lines *)
	arrow2DashHight=(First[#]->Last[#])&/@plotData;

	(* Get correct units *)
	y2Unit=First[Commonest[
		Units[UnitScale[forwardPrimer[[All,5]]*Last[(Units/.plotPrimerSetOps)]]]
	]];

	(* Generate epilogs for the primer set *)
	primerEpilogs=epilogPrimerSet[winnerFConcs,winnerRConcs,winnerBConcs,plotPrimerSetOps,arrow2Seq,arrow2DashHight];

	(* Options to pass to EmeraldListLinePlot *)
	optionsToPass=ToList@stringOptionsToSymbolOptions[
		PassOptions[PlotProbeConcentration,EmeraldListLinePlot,Sequence@@safeOps]
	];

	(* Generate a default option if original option was unspecified or Automatic, Nothing otherwise *)
	applyDefaultOption[opName_Symbol,val_]:=If[MatchQ[Lookup[originalOps,opName],_Missing|Automatic],
		opName->val,
		Nothing
	];

	(* Call ELLP to get the plot and resolved options *)
	{result,mostlyResolvedOps}=EmeraldListLinePlot[plotData,
		ReplaceRule[optionsToPass,
			{
				(* Apply default option if option wasn't specified or was Automatic *)
				applyDefaultOption[Filling,Bottom],
				applyDefaultOption[FrameLabel,
					{"Probe Position (nt)", "Bound Probe Concentration"<>UnitForm[y2Unit, Number->False]}
				],
				applyDefaultOption[Epilog,primerEpilogs],
				applyDefaultOption[PlotRange,plotrange],
				applyDefaultOption[ImageSize,800],
				(* Force these options *)
				ScaleY->1,
				Output->{Result,Options}
			}
		]
	];

	(* Resolve remaining options *)
	resolvedOps=ReplaceRule[safeOps,
		(* Drop the output option so we return the Output option passed to THIS function *)
		DeleteCases[mostlyResolvedOps,Output->_],
		Append->False
	];

	(* Return the requested outputs *)
	output/.{
		Result->result,
		Preview->result/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Options->resolvedOps,
		Tests->{}
	}
];


(* Primer set epilogs *)
epilogPrimerSet[winnerFConcs_, winnerRConcs_, winnerBConcs_, defaultedOptions_, arrow2Seq_, arrow2DashHight_]:=Module[
	{forwardEpis, reverseEpis, beaconEpis},

	(* Make graphics for all forward primers *)
	forwardEpis=MapThread[
		Mouseover[
			{
				RGBColor[0, 0.51, 0.96],
				Thickness[0.005],
				Arrowheads[Large],
				Tooltip[Arrow[{{#1[[2]],#2[[1]]},{#1[[1]],#2[[1]]}}],#1[[1]]/.arrow2Seq]
			},
			{
				Red,
				Thickness[0.005],
				Arrowheads[Large],
				Tooltip[Arrow[{{#1[[2]],#2[[1]]},{#1[[1]],#2[[1]]}}],#1[[1]]/.arrow2Seq],
				Dashed,
				Thick,
				Line[{{#1[[1]], 0},{#1[[1]], #1[[1]]/.arrow2DashHight}}]
			}
		]&,
		Transpose[winnerFConcs]
	];

	(* Make graphics for all reverse primers *)
	reverseEpis=MapThread[
		Mouseover[
			{
				RGBColor[0, 0.51, 0.96],
				Thickness[0.005],
				Arrowheads[Large],
				Tooltip[Arrow[{{#1[[1]],#2[[1]]},{#1[[2]],#2[[1]]}}], #1[[1]]/.arrow2Seq]
			},
			{
				Red,
				Thickness[0.005],
				Arrowheads[Large],
				Tooltip[Arrow[{{#1[[1]],#2[[1]]},{#1[[2]],#2[[1]]}}], #1[[1]]/.arrow2Seq],
				Dashed,
				Thick,
				Line[{{#1[[1]], 0}, {#1[[1]], #1[[1]]/.arrow2DashHight}}]
			}
		]&,
		Transpose[winnerRConcs]
	];

	(* Make graphics for all beacon primers *)
	beaconEpis=MapThread[
		Mouseover[
			{
				RGBColor[0, 0.51, 0.96],
				Thickness[0.005],
	  		Tooltip[Line[{{#1[[1]],#2[[1]]},{#1[[2]],#2[[1]]}}], #1[[1]]/.arrow2Seq],
        PointSize[Large],
				(Mod3Prime/.defaultedOptions),
				Point[{#1[[1]],#2[[1]]}],
				(Mod5Prime/.defaultedOptions),
				Point[{#1[[2]],#2[[1]]}]
			},
			{
				RGBColor[0, 0.51, 0.96],
				Thickness[0.005],
				Tooltip[Line[{{#1[[1]],#2[[1]]},{#1[[2]],#2[[1]]}}], #1[[1]]/.arrow2Seq],
				PointSize[Large],
				(Mod3Prime/.defaultedOptions),
				Point[{#1[[1]],#2[[1]]}],
				(Mod5Prime/.defaultedOptions),
				Point[{#1[[2]],#2[[1]]}],
 				Dashed,
				Red,
				Thick,
				Line[{{#1[[1]],0},{#1[[1]], #1[[1]]/.arrow2DashHight}}]
			}
 		]&,
		Transpose[winnerBConcs]
	];

	(* Return all three types of epilogs *)
	Join@@{forwardEpis, reverseEpis, beaconEpis}
];
