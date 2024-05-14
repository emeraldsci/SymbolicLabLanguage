(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotReactionMechanism*)


DefineOptions[PlotReactionMechanism,
	Options	:> {

		(*** Data Specifications Options ***)
		{
			OptionName->Style,
			Default->Default,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Default,Complex,Volpert]],
			Description->"Specifies to view as Vopert graph or Complex graph.",
			Category->"Data Specifications"
		},
		{
			OptionName -> Display,
			Default -> Automatic,
			Description -> "Choose the function used to display the structures.",
			AllowNull -> True,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[MotifForm,StructureForm,Automatic]],
			Category->"Data Specifications"
		},
		{
			OptionName -> NetworkInput,
			Default -> Null,
			Description -> "Highlights specified species as input to network, and draws path to output if Output also specified.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:>Alternatives[SpeciesP], Size->Line],
			Category->"Data Specifications"
		},
		{
			OptionName -> NetworkOutput,
			Default -> Null,
			Description -> "Highlights specified species as output of network, and draws path from input if Input also specified.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:>Alternatives[SpeciesP], Size->Line],
			Category->"Data Specifications"
		},

		(*** General Options ***)
		{
			OptionName->Tooltip,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Description->"Specifies whether to show mouseover reactions shows rates.",
			Category->"General"
		},

		(*** Plot Style Options ***)
		{
			OptionName->Disks,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,True,False]],
			Description->"Specifies whether to represent structures as small disks, instead of as a Structure plot.",
			Category->"Plot Style"
		},
		{
			OptionName->DirectedEdges,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True, False]],
			Description->"Specifies whether to show the direction of the edges.",
			Category->"Plot Style"
		},

		(*** Hidden Options ***)
		{
			OptionName->GraphLayout,
			Default->"SpringEmbedding",
			AllowNull->True,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Line],
			Description->"Layout of the graph.",
			Category->"Hidden"
		},

		(*** Output Option ***)
		OutputOption
	},

	SharedOptions:>
		{

			(*** Image Format Options ***)
			ModifyOptions["Shared",EmeraldListLinePlot,
				{
					{
						OptionName->ImageSize,
						Default->Automatic,
						AllowNull->True
					}
				}
			]
		}

];


PlotReactionMechanism[in:ObjectP[{Object[Simulation,ReactionMechanism],Model[ReactionMechanism]}],ops:OptionsPattern[PlotReactionMechanism]]:=
  PlotReactionMechanism[in[ReactionMechanism],ops];


PlotReactionMechanism[in_,ops:OptionsPattern[PlotReactionMechanism]]:=Module[
	{safeOps,output,finalPlot,returnedOps,resolvedOps},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotReactionMechanism,ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	{finalPlot,returnedOps}=plotVolpert[in,safeOps];

	(* The final resolved options based on returnedOps - These options won't have any impact on plotVolpert *)
	resolvedOps=ReplaceRule[returnedOps,
		{Display->Null,Disks->Null}
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},
		Options->resolvedOps
	}

]/;SameQ[Lookup[SafeOptions[PlotReactionMechanism,ToList[ops]],Style],Volpert];

PlotReactionMechanism[in_,ops:OptionsPattern[PlotReactionMechanism]]:=Module[
	{safeOps,output,finalPlot,resolvedOps},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotReactionMechanism,ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	{finalPlot,returnedOps}=plotComplex[in,safeOps];

	(* The final resolved options based on returnedOps - These options won't have any impact on plotComplex *)
	resolvedOps=ReplaceRule[returnedOps,
		{Display->Null,Disks->Null}
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},
		Options->resolvedOps
	}

]/;SameQ[Lookup[SafeOptions[PlotReactionMechanism,ToList[ops]],Style],Complex];

PlotReactionMechanism[ReactionMechanism[reactions:(_Reaction..)],ops:OptionsPattern[PlotReactionMechanism]] :=
	PlotReactionMechanism[{reactions},ops]/;SameQ[OptionValue[Style],Default];

PlotReactionMechanism[reactions:{(_Reaction|{})..},ops:OptionsPattern[PlotReactionMechanism]] :=
	With[
		{
			order1 = formatFirstOrderEdges[reactions],
			order2Raw = formatSecondOrderEdges[reactions],
			x = Length[DeleteDuplicates[Cases[reactions,_Structure,{3}]]],
			imageSize=Replace[
				Lookup[SafeOptions[PlotReactionMechanism,ToList[ops]],ImageSize],
				Automatic->Min[{(500+125*Length[reactions]),1200}]
			]
		},

		Module[
			{
				order2, order2Toolyips, sources={},sinks={},networkInput,networkOutput,shortestPath,shortestPathColors,
				gBasic,notDiskBool,displayForm,output,finalPlot,safeOps,resolvedOps
			},

			(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
			safeOps=SafeOptions[PlotReactionMechanism,ToList[ops]];

			(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
			output=Lookup[safeOps,Output];

			order2 = Flatten[order2Raw[[1]]];
			order2Toolyips = order2Raw[[2]];
			gBasic=Graph[Join[order1,order2]];
			(*sources=If[False,DeleteCases[Complement[Union[Cases[{order1,order2},Rule[g_Graphics,_]:>g,Infinity]],Union[Cases[{order1,order2},Rule[_,g_Graphics]:>g,Infinity]]],_String],{}];*)
			(*sinks=If[False,DeleteCases[Complement[Union[Cases[{order1,order2},Rule[_,g_Graphics]:>g,Infinity]],Union[Cases[{order1,order2},Rule[g_Graphics,_]:>g,Infinity]]],_String],{}];*)
			{networkInput,networkOutput}=Lookup[safeOps,{NetworkInput,NetworkOutput}];
			If[And[networkInput=!=Null,networkOutput=!=Null],
				shortestPath=DirectedEdge@@@Partition[FindShortestPath[gBasic,networkInput,networkOutput],2,1];
				shortestPathColors=MapThread[Rule[#1,#2]&,{shortestPath,ColorFade[{Red,Blue},Length[shortestPath]]}];,
				{shortestPath,shortestPathColors}={{},{}};
			];

			(* determine whether to display the species or just disks *)
			notDiskBool = Or[Lookup[safeOps,Disks]===False,And[x<=20,MatchQ[Lookup[safeOps,Disks],Automatic]]];

			displayForm = Replace[Lookup[safeOps,Display],Automatic->StandardForm];

			finalPlot=Graph[
				Join[order1, Flatten[order2,1]],
				VertexShapeFunction->
					Function[{coord,obj},
						Which[
							(* if species are strings, always show as Disks *)
							MatchQ[obj,_String],
								{Black, Tooltip[Disk[coord,.04], obj /. order2Toolyips]},
							(* if not disks, size the species pictures *)
							notDiskBool,
								(* set the position *)
								Inset[
									(* set the size *)
									Magnify[
										Which[
											(* networkInput species gets LightRed background *)
											MatchQ[obj,networkInput],
												Style[renderVertex[obj,displayForm],Background->LightRed],
											(* networkOutput species gets LightBlue background *)
											MatchQ[obj,networkOutput],
												Style[renderVertex[obj,displayForm],Background->LightBlue],
											(* any other source species is framed by Red *)
											MemberQ[sources,obj],
												Framed[renderVertex[obj,displayForm],FrameStyle->Red],
											(* any other sink species is framed by Blue *)
											MemberQ[sinks,obj],
												Framed[renderVertex[obj,displayForm],FrameStyle->Blue],
											(* everything else is normal *)
											True,
												renderVertex[obj,displayForm]
										],
										.85
									],
									coord
								],
							(* otherwise show disks *)
							True,
								Tooltip[Disk[coord,.04],Magnify[obj,.75]]
						]
					],
				EdgeShapeFunction ->
					Function[{coord,obj},
						Which[
							(* edges on the NetworkInput <> NetworkOutput path get colored Red *)
							MemberQ[shortestPath,obj],
								{Red, Thick,Arrowheads[Small], Arrow[coord, 0.3]},
							(* everything else is black *)
							True,
								{Black, Arrowheads[Small], Arrow[coord, 0.3]}
					] ],
				GraphLayout->Lookup[safeOps,GraphLayout],
				ImageSize->imageSize
			];

			(* The final resolved options based on safeOps and the imageSize *)
			resolvedOps=ReplaceRule[safeOps,
				{
					ImageSize->imageSize,
					Display->displayForm,
					Disks->notDiskBool
				}
			];

			(* Return the result, options, or tests according to the output option. *)
			output/.{
				Result->finalPlot,
				Preview->finalPlot,
				Tests->{},
				Options->resolvedOps
			}

		]

	]/;SameQ[Lookup[SafeOptions[PlotReactionMechanism,ToList[ops]],Style],Default];


renderVertex[vert_,Automatic]:= renderVertex[vert,StandardForm];
renderVertex[vert_,dispForm:(StandardForm|StructureForm|MotifForm)]:=dispForm[vert];



formatFirstOrderEdges[reactions_]:=Flatten@Cases[reactions,
	Reaction[{in_},{out_},rates__] :> formatFirstOrderEdge[Reaction[{in},{out},rates]]
];
formatFirstOrderEdge[Reaction[{in_},{out_},rate_]]:=Tooltip[in->out,rate];
formatFirstOrderEdge[Reaction[{in_},{out_},rate1_,rate2_]]:={Tooltip[in->out,rate1],Tooltip[out->in,rate2]};


formatSecondOrderEdges[reactions_] := With[
	{temp = Cases[reactions, r:Reaction[in_,out_,rate__] :> formatSecondOrderEdge[r] /; Length[in]>1 || Length[out]>1]},
	If[MatchQ[temp, {}], {{}, {}}, Transpose[temp]]
];
formatSecondOrderEdge[Reaction[in_,out_,rate_]]:=With[
	{nexus = ToString[Unique["nexus"]]},
	{{Tooltip[#->nexus,rate]& /@ in, Tooltip[nexus->#,rate]& /@ out}, nexus -> Reaction[in,out,rate]}
];
formatSecondOrderEdge[Reaction[in_,out_,rate1_,rate2_]]:=With[
	{nexus = ToString[Unique["nexus"]]},
	{{
		{Tooltip[#->nexus,rate1]& /@ in, Tooltip[nexus->#,rate1]& /@ out},
		{Tooltip[#->nexus,rate2]& /@ out, Tooltip[nexus->#,rate2]& /@ in}
	},
	nexus -> Reaction[in, out, rate1, rate2]
	}
];


(* ::Subsubsection:: *)
(*plotVolpert*)


plotVolpert[mech:ReactionMechanismP,safeOps:{(_Rule|_RuleDelayed)..}]:=plotVolpert[NucleicAcids`Private`mechanismToImplicitReactions[mech],safeOps];
plotVolpert[mech:{__Reaction},safeOps:{(_Rule|_RuleDelayed)..}]:=plotVolpert[NucleicAcids`Private`mechanismToImplicitReactions[ReactionMechanism[mech]],safeOps];
plotVolpert[mech:{ImplicitReactionP..},safeOps:{(_Rule|_RuleDelayed)..}]:=plotVolpert[mech[[;;,1]],safeOps];
plotVolpert[reactionsWithEqui:{(_Rule|_Equilibrium)..},safeOps:{(_Rule|_RuleDelayed)..}] := Module[{a,b},
  Module[
		{reactions,list,listStrings,rules,internalGraphPlotOps,plot,returnedOps},

    reactions = reactionsWithEqui/.{Equilibrium[a_,b_]->Sequence@@{Rule[a,b],Rule[b,a]}};
    list = Map[{{#},SpeciesList[{First[#]}],SpeciesList[{Last[#]}]}&,reactions];
    listStrings = Map[ToString[#]&,list,{3}];
    rules = Table[Sequence@@Join[
	    Table[listStrings[[i,2,j]]->listStrings[[i,1,1]],{j,1,Length[listStrings[[i,2]]]}],
	    Table[listStrings[[i,1,1]]->listStrings[[i,3,j]],{j,1,Length[listStrings[[i,3]]]}]
	    ],{i,1,Length[listStrings]}
		];

		(* The options passed to GraphPlot *)
		internalGraphPlotOps=Join[
			(* Any option passed to the function *)
			ToList@PassOptions[PlotReactionMechanism,GraphPlot,
				ReplaceRule[safeOps,
					{
					}
				]
			],
			(* These options do not exist in the available options of GraphPlot *)
			{
				VertexLabeling->True,
				(* True or False of this doesn't change still arrows will be shown *)
				DirectedEdges->True,
				EdgeRenderingFunction->
					(If[ StringCount[First[#2],"->"]>0,
					 {Red,{Arrowheads[Large],Arrow[#1,0.6]}},
					 {Blue,{Arrowheads[Large],Arrow[#1,0.6]}}
				]&),
				VertexCoordinateRules->Join[Table[ToString[SpeciesList[reactions,Sort->False][[i]]]->{4*i,0},{i,1,Length[SpeciesList[reactions]]}],
					Table[ToString[reactions[[i]]]->{6*i,8},{i,1,Length[reactions]}]
				]
			}
		];

		(* Don't pass things with Automatic,None, or {} to the GraphPlot. Otherwise it won't work well. *)
    plot=GraphPlot[rules,
			Sequence@@
				(
					DeleteCases[internalGraphPlotOps,
						Rule[_,Automatic|None|{}]
					]
				)
		];

		returnedOps=ReplaceRule[internalGraphPlotOps,AbsoluteOptions[plot]];

		{plot,returnedOps}
  ]
];


(* ::Subsubsection:: *)
(*plotComplex*)


plotComplex[mech:ReactionMechanismP,safeOps:{(_Rule|_RuleDelayed)..}]:=plotComplex[NucleicAcids`Private`mechanismToImplicitReactions[mech],safeOps];
plotComplex[mech:{ImplicitReactionP..},safeOps:{(_Rule|_RuleDelayed)..}]:=plotComplex[mech[[;;,1]],safeOps];
plotComplex[reactions:{(_Rule|_Equilibrium)..},safeOps:{(_Rule|_RuleDelayed)..}] :=Module[
	{internalGraphPlotOps,plot,returnedOps},

	(* The options passed to GraphPlot *)
	internalGraphPlotOps=Join[
		(* Any option passed to the function *)
		ToList@PassOptions[PlotReactionMechanism,GraphPlot,
			ReplaceRule[safeOps,
				{
				}
			]
		],
		(* These options do not exist in the available options of GraphPlot *)
		{
			VertexLabeling->True
		}
	];

	(* Don't pass things with Automatic,None, or {} to the GraphPlot. Otherwise it won't work well. *)
  plot=GraphPlot[reactions/.{Equilibrium[a_,b_]:>Sequence@@{Rule[a,b],Rule[b,a]}},
		Sequence@@
			(
				DeleteCases[internalGraphPlotOps,
					Rule[_,Automatic|None|{}]
				]
			)
	];

	returnedOps=ReplaceRule[internalGraphPlotOps,AbsoluteOptions[plot]];

	{plot,returnedOps}

];



(* ::Subsubsection:: *)
(*drawStructure*)


(* full Structure name *)

(* given Structure with base pairings *)
drawStructure[in:Structure[strs:{_Strand..},bonds_],ops:OptionsPattern[StructureForm]] :=  Module[
	{name, g,sequences,labels,fig,formattedGraph,strPieces,imageSize,safeOps, sequenceTypes},

	name = NucleicAcids`Private`reformatBonds[in,StrandMotifBase];

	safeOps = SafeOptions[StructureForm, ToList[ops]];
	(* get list of all Monomers in the Structure *)
	strPieces=ParseStrand/@name[Strands];

	(* fill in motif lengths with 'N' bases *)
	sequences=ReplaceAll[strPieces,{{_,_,seq_String,pol_}:>Monomers[seq,Polymer->pol],{_,_,n_Integer,pol_}:>Table["N",{n}]}];
	sequenceTypes = Flatten[ReplaceAll[strPieces,{{_,_,seq_String,pol_}:>Table[pol, Length[Monomers[seq,Polymer->pol]]],{_,_,n_Integer,pol_}:>Table[pol,{n}]}]];

	imageSize = resolveStructureImageSize[Lookup[safeOps,ImageSize],Max[Map[Total,Map[Length,sequences,{2}]]]];

	(* get the labels for each motif. Add OverBar if the motif had a prime ' *)
	labels=Map[Switch[#,{_,True},OverBar[First[#]],{_,False},First[#]]&,strPieces[[;;,;;,{1,2}]],{2}];

	g = name[Graph];
	formattedGraph = formatStructureGraph[g,Flatten[sequences,1], Flatten[labels,1], sequenceTypes, Sequence@@safeOps ];

	(* draw the figure *)
	fig=Show[
		FullGraphics[formattedGraph],
		ImageSize->imageSize
	];

	(* display the figure, but keep underlying representation *)
	Interpretation[fig, name]

];


resolveStructureImageSize[Automatic,1]:=100;
resolveStructureImageSize[Automatic,length_]:=Clip[10*length,{200,500}];
resolveStructureImageSize[other_,length_]:=other;


(* ::Subsubsection::Closed:: *)
(*formatStructureGraph*)


formatStructureGraph[g_Graph, seqs:{{_String..}..}, labels_List, sequenceTypes_List, ops:OptionsPattern[StructureForm]] := Module[{
		seq,baselabels, edgeF, vertF,colors,
		basecolors,fontScale,diskScale,arrowScale,edgeScale,arrowHead,
		edgeWeightRules, nodes, edgeWeight, edgeRescale, testG
	},

	nodes = VertexList[g];
	edgeWeightRules = MapThread[Rule,{EdgeList[g],Lookup[Options[g],EdgeWeight,{}]}];

	(* full sequence *)
	seq = Join @@ seqs;

	(* Other nice choices for ColorData: 47,66,86,88 *)
	colors= $MotifColors;

	basecolors=Flatten[Table[ConstantArray[colors[[Mod[ix,Length[colors],1]]],Length[seqs[[ix]]]],{ix,1,Length[seqs]}],1];

	baselabels=Flatten[Table[ConstantArray[labels[[ix]],Length[seqs[[ix]]]],{ix,1,Length[seqs]}],1];

	(* Given the number of nodes, numerically determine reasonable scales for the fonts, disks and edges *)
	fontScale=If[Length[nodes]===1,0.75,Min[{.25,1.0/Length[nodes]}]];
	diskScale=Min[{.4,2/Sqrt[Length[nodes]]}];
	edgeScale=Min[{.15,0.3/Length[nodes]}];
	arrowScale=Min[{.2,3/Sqrt@Length[nodes]}];

	testG = Graph[
		EdgeList[g],
		GraphLayout-> "SpringEmbedding"
	];

	edgeWeight = edgeW[g, testG, sequenceTypes, Flatten[seqs], N[diskScale * 10]];

	(* ------------------------------------- *)
	(* edge function *)
	edgeF[coord : {c1_, c2_}, edg_] := Module[
		{sortEdg, edgeProps, sortCoord},
		sortEdg = Sort @ edg;
		edgeProps = Lookup[edgeWeightRules, sortEdg];
		sortCoord = If[MatchQ[sortEdg, edg], coord, {c2, c1}];

		Which[
			(* order matters here, b/c some edges have multiple properties *)
			MemberQ[edgeProps, "Arrow"], edgeArrowGraphic[sortCoord, edgeScale, arrowScale],
			MemberQ[edgeProps, "Covalent" | "Motif"], edgeCovalentGraphic[sortCoord, edgeScale],
			MemberQ[edgeProps, "Hydrogen"], edgeHydrogenGraphic[sortCoord, edgeScale],
			MemberQ[edgeProps, "Label"], edgeLabelGraphic[sortCoord, edgeScale, arrowScale, baselabels, sortEdg, fontScale, basecolors],
			True ,{Red, Thick, Line[coord]}
		]
	];

	(* vertex function *)
	vertF[coord_, a_,___] := vertexBaseGraphic[coord, a,basecolors,diskScale,fontScale,seq, sequenceTypes];

	(* ------------------------------------- *)
	With[{edgeList = EdgeList[g]},
		Graph[
			Sequence @@ If[MatchQ[edgeList, {}],
				List[g, GraphLayout-> "SpringEmbedding"],
				List[edgeList, EdgeWeight -> edgeWeight, GraphLayout-> {"SpringEmbedding", "EdgeWeighted" -> True}]
			],
			EdgeShapeFunction->edgeF,
			VertexShapeFunction->vertF,
			PassOptions[StructureForm,Graph,ops]
		]
	]

];


(* ::Subsubsection::Closed:: *)
(*edge & vertex formatting*)


edgeW[graph_Graph, testGraph_Graph, seqType_, seq_, scale_] := Module[
	{edgeType, edgeList, coords},

	coords = GraphEmbedding[testGraph];
	edgeType = PropertyValue[graph, EdgeWeight];
	edgeList = EdgeList[graph];
	If[MatchQ[edgeList, {}], Return[{scale}]];
	MapThread[edgeLengthOne[#1 /. UndirectedEdge -> List, First[{Delete[0][#2]}], seqType, seq, scale, coords] &, {edgeList, edgeType}]
];


edgeLengthOne[edge_, edgeType: "Label", seqType_List, seq_List, scale_, coords_] := edgeLength[seqType[[edge]], seq[[edge]], scale, coords[[edge]]];
edgeLengthOne[edge_, edgeType: "Covalent", seqType_List, seq_List, scale_, coords_] := edgeLength[seqType[[edge]], seq[[edge]], scale, coords[[edge]]];
edgeLengthOne[edge_, edgeType: "Motif", seqType_List, seq_List, scale_, coords_] := edgeLength[seqType[[edge]], seq[[edge]], scale, coords[[edge]]];
edgeLengthOne[edge_, edgeType: "Hydrogen", seqType_List, seq_List, scale_, coords_] := scale;
edgeLengthOne[edge_, edgeType: "Arrow", seqType_List, seq_List, scale_, coords_] := edgeLength[seqType[[edge]], seq[[edge]], scale, coords[[edge]]];


edgeLength[{typeL: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | LNAChimera | PNA | GammaLeftPNA | GammaRightPNA), typeR: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | LNAChimera | PNA | GammaLeftPNA | GammaRightPNA)}, {baseL_, baseR_}, scale_, coord_] := scale;

edgeLength[{typeL: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | PNA | GammaLeftPNA | GammaRightPNA), typeR: LNAChimera|LDNA|LRNA}, {baseL_, baseR_}, scale_, coord_] := 1. * scale;
edgeLength[{typeL: LNAChimera|LDNA|LRNA, typeR: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | PNA | GammaLeftPNA | GammaRightPNA)}, {baseL_, baseR_}, scale_, coord_] := 1. * scale;

edgeLength[{typeL: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | PNA | GammaLeftPNA | GammaRightPNA), typeR: Peptide | Modification}, {baseL_, baseR_}, scale_, coord_] := 1.4 * scale;
edgeLength[{typeL: Peptide | Modification, typeR: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | PNA | GammaLeftPNA | GammaRightPNA)}, {baseL_, baseR_}, scale_, coord_] := 1.4 * scale;

edgeLength[{typeL: LNAChimera|LDNA|LRNA, typeR: LNAChimera|LDNA|LRNA}, {baseL_, baseR_}, scale_, coord_] := 1. * scale;

edgeLength[{typeL: LNAChimera|LDNA|LRNA, typeR: Peptide | Modification}, {baseL_, baseR_}, scale_, coord_] := 1.4 * scale;
edgeLength[{typeL: Peptide | Modification, typeR: LNAChimera|LDNA|LRNA}, {baseL_, baseR_}, scale_, coord_] := 1.4 * scale;

edgeLength[{typeL: Peptide | Modification, typeR: Peptide | Modification}, {baseL_, baseR_}, scale_, coord_] := 1.8 * scale;

(* Any other unassigned oligomer type interacting with all other oligomer types with a known type will take this format *)
edgeLength[{typeL: PolymerP, typeR: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | LNAChimera | PNA | GammaLeftPNA | GammaRightPNA)}, {baseL_, baseR_}, scale_, coord_] := 1. * scale;
edgeLength[{typeL: (DNA | RNA | RNAtom | RNAtbdms | LDNA | LRNA | LNAChimera | PNA | GammaLeftPNA | GammaRightPNA), typeR: PolymerP}, {baseL_, baseR_}, scale_, coord_] := 1. * scale;

(* Any other unassigned oligomer type interacting with Peptide and Modification with a known type will take this format *)
edgeLength[{typeL: PolymerP, typeR: Peptide | Modification}, {baseL_, baseR_}, scale_, coord_] := 1.4 * scale;
edgeLength[{typeL: Peptide | Modification, typeR: PolymerP}, {baseL_, baseR_}, scale_, coord_] := 1.4 * scale;

(* Any other unassigned oligomer type with itself will take this format *)
edgeLength[{typeL: PolymerP, typeR: PolymerP}, {baseL_, baseR_}, scale_, coord_] := 1. * scale;


angle[{c1: {x1_, y1_}, c2: {x2_, y2_}}] := Abs[x1 - x2] / Sqrt[(x1 - x2)^2 + (y1 - y2)^2];


vertexBaseGraphic[coord_, a_, basecolors_,diskScale_,fontScale_,seq_, sequenceTypes_] := {
	basecolors[[a]],
	EdgeForm[None],
	shapeF[coord, diskScale, seq[[a]], sequenceTypes[[a]]],
	Tooltip[Text[Style[safeShortForm[seq[[a]]],Black,Bold,FontFamily->"Arial",FontSize->Scaled[adjustFontSize[sequenceTypes[[a]],fontScale]]], coord], seq[[a]]]
};

(* A helper function to adjust the fontsize of the monomers *)
adjustFontSize[type:PolymerP,fontScale_]:=
	Switch[type,
		(* There are up to three letters in LNAChimera *)
		LNAChimera,
		fontScale*.4,
		(* For other types, there are only one letter and it fits well *)
		_,
		fontScale*.6
	];

safeShortForm[str_] := If[StringLength[str] > 3,
	StringTake[StringReplace[str, # -> ""& /@{DigitCharacter~~"-" , DigitCharacter~~"'-", "R-", "L-", "S-"}], 1;;3],
	str
];

shapeF[coord_, diskScale_, text_, DNA] := Disk[coord, diskScale];
shapeF[coord_, diskScale_, text_, RNA] := RegularPolygon[coord, diskScale * 1.2, 4];
(* All modified oligomers with pentagons *)
shapeF[coord_, diskScale_, text_, RNAtom | RNAtbdms | LDNA | LRNA] := RegularPolygon[coord, diskScale * 1.2, 5];
shapeF[coord_, diskScale_, text_, LNAChimera] := RegularPolygon[coord, diskScale * 1.2, 5];
shapeF[coord_, diskScale_, text_, PNA | GammaLeftPNA | GammaRightPNA] := RegularPolygon[coord, diskScale, 6];
shapeF[coord_, diskScale_, text_, Peptide] := Disk[coord, diskScale * {1.77, 1}];
shapeF[coord_, diskScale_, text_, Modification] := With[{temp = diskScale * {1.57, 1.0}}, Rectangle[coord - temp, coord + temp]];
(* Any other unassigned oligomer type will take this format *)
shapeF[coord_, diskScale_, text_, PolymerP] := RegularPolygon[coord, diskScale * 1.2, 5];

edgeArrowGraphic[coord : {c1_, c2_},edgeScale_,arrowScale_]:=With[{
		end1a=c2+(0.6-.85*edgeScale)*(c2-c1), (* end of line that extends past the base (offset a bit because thickness makes it longer) *)
		end1=c2+0.6*(c2-c1), (* start of arrow head *)
		end2=c2+.8(c2-c1) (* end of arrow head *)
	},
	{Black,Opacity[1],Thickness[edgeScale*0.8],
		(* line connecting bases and extending a bit beyond the second base *)
		Line[{c1,end1a}],
		(* Triangle arrowhead at end of line segment above *)
		Polygon[{
			end1,
			end1+7*arrowScale{end1[[2]]-end2[[2]],end2[[1]]-end1[[1]]},
			end2,
			end1-7*arrowScale{end1[[2]]-end2[[2]],end2[[1]]-end1[[1]]},
			end1
		}]
	}
];

edgeLabelGraphic[coord : {c1_, c2_},edgeScale_,arrowScale_,baselabels_,edg_,fontScale_,basecolors_]:={
	{Text[Style[baselabels[[Min[List@@edg]]], FontSize->Scaled[fontScale], FontFamily->"Arial",Bold,Italic, basecolors[[Min[List@@edg]]]], c1+Reverse[(c2-c1)*1.5]]},
	{Black, Opacity[1],Thickness[edgeScale*0.8], Line[coord]}
};

edgeHydrogenGraphic[coord : {c1_, c2_},edgeScale_]:={Gray,Opacity[1], Thickness[edgeScale],Line[coord]};

edgeCovalentGraphic[coord : {c1_, c2_},edgeScale_]:={Black, Opacity[1],Thickness[edgeScale*0.8], Line[coord]};


(* ::Subsubsection:: *)
(*mechanismTable*)


mechanismTable[mech_ReactionMechanism]:=
	TableForm[
		List@@mech/.
			 {Reaction[a_,b_,c_,d_]:>{Plus@@a,"\[Equilibrium]",Plus@@b,{c[[1]],ToString[c[[2]]]},{d[[1]],ToString[d[[2]]]}},
			Reaction[a_,b_,c_]:>{Plus@@a,"->",Plus@@b,{c[[1]],ToString[c[[2]]]},""}},
		TableHeadings->{None,Style[#,Bold,Large]&/@{"Reactants","","Products","Forward ReactionMechanism","Reverse ReactionMechanism"}}
	];


(* ::Subsubsection::Closed:: *)
(*plotMotifDiagram*)


sfirst[""] := "";
sfirst[x_String] := StringFirst[x];
SetAttributes[sfirst, Listable];

plotMotifDiagram[Structure[strands:{_Strand..}, pairs:{BondP...}]] :=
	Module[{len, internalCovalent, externalCovalent, pairing, colors, namesForColors, naming, alphabet, isRC, edgeF, vertF,pols},

	len=Map[Round[StrandLength[#,Total->False]/2]&,strands];
	len = Map[Max[#,2]&, len, {2}]; (* Every motif must be at least length 2 to get rendered *)

		internalCovalent =
			Flatten[
				Table[
					{s, m, i}->{s, m, i+1},
					{s, Length[len]},
					{m, Length[len[[s]]]},
					{i, len[[s,m]]-1}
				],
				2
			];

		externalCovalent =
			Flatten[
				Table[
					{s, m, len[[s,m]]}->{s, m+1, 1},
					{s, Length[len]},
					{m, Length[len[[s]]]-1}
				],
				1
			];

		pairing =
			Flatten[
				Replace[
					pairs,
					Bond[{a_,b_},{c_,d_}] :> Table[{a,b,i}->{c,d,len[[c,d]]-i+1}, {i,Min[len[[a,b]],len[[c,d]]]}],
					{1}
				]
			];

		naming = strands[Names];
		namesForColors = Module[{pos=Position[naming,""],alph=ToUpperCase/@Flatten[sfirst[naming]],newAlph},
			newAlph = Complement[CharacterRange["A","Z"],alph];
			ReplacePart[naming,MapThread[Rule,{pos,Flatten[Table[newAlph,{Ceiling[Length[pos]/Length[newAlph]]}]][[;;Length[pos]]]}]]
		];
		colors = $MotifColors; (* Get some crayola colors *)
		alphabet = FromCharacterCode /@ Join[Range @@ ToCharacterCode["AZ"], Range @@ ToCharacterCode["az"]];
		alphabet = Join[alphabet, Complement[Flatten[sfirst[naming]],alphabet]]; (* Flat, sorted list of unique motif names *)
		isRC=strands[RevComps];

		colors = sfirst[namesForColors] /. Thread[alphabet -> colors[[ Mod[Range[Length[alphabet]],Length[colors],1] ]] ];

		edgeF[coord:{c1_,___,c2_},h_[{a_,b_,c_},{d_,e_,f_}],___] :=
			Which[
				MemberQ[pairing, {a,b,c}->{d,e,f}],
					{Gray, Thin, Line[coord]},
				MemberQ[externalCovalent, {a,b,c}->{d,e,f}],
					{colors[[a,b]], Thickness[.01], Line[coord]},
				b==Length[isRC[[a]]]&&c==len[[a,b]]-1,
					{colors[[a,b]], Thickness[.01], Arrow[{c1,c1+(c2-c1)*2}]},
				(*c==Ceiling[len[[a,b]]/2],
					{colors[[a,b]], Thickness[.01], Inset[Labeled["hi!",Line[coord]]]},*)
				isRC[[a,b]]&&OddQ[c],
					{Darker@colors[[a,b]], Thickness[.01], Line[coord]},
				True,
					{colors[[a,b]], Thickness[.01], Line[coord]}
			];
		edgeF[anything__] := Print[{anything}];

		vertF[coord_,{a_,b_,c_},___] :=
			If[c==Ceiling[len[[a,b]]/2],
				{If[isRC[[a,b]],
					Text[OverBar@naming[[a,b]], coord, BaseStyle->{Medium, Bold}],
					Text[naming[[a,b]], coord, BaseStyle->{Medium, Bold}]
				]
				},
				(*{Text[naming[[a,b]]<>If[isRC[[a,b]],"'",""], coord, BaseStyle->{Medium, Bold}]},*)
				{}
			];

		GraphPlot[
			Join[internalCovalent, externalCovalent, pairing],
			(*Method -> {"SpringEmbedding", "RecursionMethod" -> {"Multilevel", "Randomization" -> False, "CoarseningScheme" -> "MaximalIndependentEdgeSet"}},*)
			Method -> "SpringEmbedding",
			EdgeRenderingFunction -> edgeF,
			VertexRenderingFunction -> vertF
		]
	]
