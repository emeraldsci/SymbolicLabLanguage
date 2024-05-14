(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*DownstreamSampleUsage*)

(* a helper to visualize the usage of a sample - particularly helpful to assess the extent of the damage if there was something wrong with the object or physical sample *)
(* the output options allow for a graph, an association or a list of downstream samples *)

DefineOptions[DownstreamSampleUsage,
	Options:>{
		{
			OptionName -> Output,
			Default -> Graph,
			Description -> "The output form displaying either a graph, association, or list of downstream samples.",
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

DownstreamSampleUsage::NoTransfersOut = "There are no TransfersOut from the input sample.";

DownstreamSampleUsage[sample_, ops:OptionsPattern[]]:=Module[
	{
		safeOps, originalTransferOut, transfersOut, allTransferOutElements, transferOutAssociation, graph, downstreamSamples,
		firstgen, secondgen,vertexStyle, graphLayout, output, safeGraphLayout
	},

	(*get the output option*)
	safeOps = ECL`OptionsHandling`SafeOptions[DownstreamSampleUsage, ToList[ops]];

	(* lookup the options *)
	{output, graphLayout}= Lookup[safeOps, {Output, GraphLayout}];

	(* get the recursive downloaded transfersIn and out *)
	{originalTransferOut, transfersOut} = Download[
		sample,
		{
			TransfersOut,
			TransfersOut[[All,3]]..
		}
	];

	(* remove any terminal transfers - this gives a flat list of all transfers in the form {sample 1, {sample 2, {sample 3}}} *)
	allTransferOutElements = Cases[transfersOut, {ObjectP[], Except[{}]}, Infinity];

	(* make the association linking samples *)
	transferOutAssociation = Join[

		(*  *)
		Flatten[
			Map[
				Function[element,
					Map[
						(element[[1]]->#)&,
						element[[2,All,1]]
					]
				],
				allTransferOutElements
			]
		]/.x:ObjectP[]:>Download[x, Object],
		(*use the top level Transfers Out*)
		Map[(sample -> #)&, originalTransferOut[[All,3]]]/.x:ObjectP[]:>Download[x, Object]
	];

	(*do a little graph formatting for readability - Red -> yellow -> black*)
	firstgen = Values[Select[transferOutAssociation, MatchQ[Keys[#],ObjectP[sample]]&]];
	secondgen = Values[Select[transferOutAssociation, MatchQ[Keys[#], Alternatives@@firstgen]&]];

	(* color code the samples accordingly *)
	vertexStyle = Flatten[
		Map[
			Which[
				MatchQ[Keys[#], ObjectP[sample]],
				{Keys[#]-> Red, Values[#]-> Orange},

				MatchQ[Keys[#], Alternatives@@firstgen],
				{Keys[#] -> Orange, Values[#]-> Yellow},

				MatchQ[Keys[#], Alternatives@@secondgen],
				{Keys[#] -> Yellow, Values[#]-> Black},

				True,
				{Keys[#] -> Black, Values[#]->Black}
			]&,
			DeleteDuplicates[transferOutAssociation]
		]
	];

	(* lookup the layout from the options *)
	safeGraphLayout = graphLayout/.{Null-> "RadialDrawing"};

	(*identify the graph and downstream samples*)
	graph = If[MatchQ[transferOutAssociation, {}],
		Message[DownstreamSampleUsage::NoTransfersOut];
		Null,
		Graph[
			DeleteDuplicates[transferOutAssociation],
			VertexLabels -> Placed["Name", Tooltip],
			VertexStyle -> vertexStyle,
			ImageSize ->Large,
			VertexSize ->Large,
			GraphLayout -> safeGraphLayout,
			EdgeStyle->Black,
			VertexShapeFunction -> "Hexagon"
		]
	];
	downstreamSamples = DeleteDuplicates[Flatten[{Keys[transferOutAssociation], Values[transferOutAssociation]}]];

	(*output the results*)
	Which[
		MatchQ[output, All],
		{graph, transferOutAssociation, downstreamSamples},
		MatchQ[output, Association],
		transferOutAssociation,
		MatchQ[output, List],
		downstreamSamples,
		MatchQ[output, Graph],
		graph
	]
];

