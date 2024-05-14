(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*UpstreamSampleUsage*)

(* a helper to visualize every sample that could have possibly impacted the contents/quality of a given sample - particularly helpful to identify a culprit that might be contaminated or have low volume *)
(* the output options allow for a graph, an association or a list of downstream samples *)

DefineOptions[UpstreamSampleUsage,
	Options:>{
		{
			OptionName -> Output,
			Default -> Graph,
			Description -> "The output form displaying either a graph, association, or list of upstream samples.",
			Pattern:> All|Association|Graph|List,
			Category -> "Method",
			AllowNull->False
		},
		{
			OptionName -> GraphLayout,
			Default -> "RadialDrawing",
			Pattern:> "LayeredEmbedding"|"RadialDrawing",
			AllowNull -> True,
			Description -> "Graph layout for readability.",
			Category -> "Method"
		}
	}
];

UpstreamSampleUsage::NoTransfersOut = "There are no TransfersIn from the input sample.";
(* also visualize and determine sources of error in a particular sample using the upstream samples *)


UpstreamSampleUsage[sample_, ops:OptionsPattern[]]:=Module[
	{transfersIn, originalTransfersIn, allTransferInElements, transferInAssociation, firstgen, secondgen, vertexStyle, graphLayout, graph, downstreamSamples, safeOps, output, safeGraphLayout},

	safeOps = ECL`OptionsHandling`SafeOptions[UpstreamSampleUsage, ToList[ops]];

	(* get the recursive downloaded transfersIn and out *)
	{transfersIn, originalTransfersIn} = Download[
		sample,
		{
			TransfersIn[[All,3]]..,
			TransfersIn
		}
	];

	(* lookup the options *)
	{output, graphLayout}= Lookup[safeOps, {Output, GraphLayout}];
	
	(* remove any terminal transfers *)
	allTransferInElements = Cases[transfersIn, {ObjectP[], Except[{}]}, Infinity];

	(* make the association *)
	transferInAssociation = Join[
		Flatten[Map[Function[element, Map[(#-> element[[1]])&,element[[2,All,1]]]], allTransferInElements]]/.x:ObjectP[]:>Download[x, Object],
		Map[(#->sample)&, originalTransfersIn[[All,3]]]/.x:ObjectP[]:>Download[x, Object]
	];

	(*do a little graph formatting for readability - Red -> Orange -> yellow -> black*)
	firstgen = Keys[Select[transferInAssociation, MatchQ[Values[#],ObjectP[sample]]&]];
	secondgen = Keys[Select[transferInAssociation, MatchQ[Values[#], Alternatives@@firstgen]&]];

	(* color code the samples accordingly *)
	vertexStyle = Flatten[
		Map[
			Which[
				MatchQ[Values[#], ObjectP[sample]],
				{Values[#]-> Red, Keys[#]->Orange},
				MatchQ[Values[#], Alternatives@@firstgen],
				{Values[#] -> Orange, Keys[#]->Yellow},
				MatchQ[Values[#], Alternatives@@secondgen],
				{Values[#] -> Yellow, Keys[#]->Black},
				True,
				{Keys[#] -> Black, Values[#]->Black}
			]&,
			DeleteDuplicates[transferInAssociation]
		]
	];

	(* lookup the layout from teh options *)
	safeGraphLayout = graphLayout/.{Null-> "RadialDrawing"};

	(*identify the graph and downstream samples*)
	graph = If[MatchQ[transferInAssociation, {}],
		Message[UpstreamSampleUsage::NoTransfersOut];
		Null,
		Graph[
			DeleteDuplicates[transferInAssociation],
			VertexLabels -> Placed["Name", Tooltip],
			VertexStyle -> vertexStyle,
			ImageSize ->Large,
			VertexSize ->Large,
			GraphLayout -> safeGraphLayout,
			EdgeStyle->Black,
			VertexShapeFunction -> "Hexagon"
		]
	];
	downstreamSamples = DeleteDuplicates[Flatten[{Keys[transferInAssociation], Values[transferInAssociation]}]];

	(*output the results*)
	Which[
		MatchQ[output, All],
		{graph, transferInAssociation, downstreamSamples},

		MatchQ[output, Association],
		transferInAssociation,
		
		MatchQ[output, List],
		downstreamSamples,
		
		MatchQ[output, Graph],
		graph
	]
];

