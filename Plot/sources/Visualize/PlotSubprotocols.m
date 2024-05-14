
(* ::Subsubsection::Closed:: *)
(* PlotSubprotocols *)

(* An alternative visualization of sub protocols which may be helpful if there is a lot of layers of subs *)
(* Use Output -> All to show a graph and table. There are also options for the graph and the color scheme, which can be set to OperationStatus or Status *)

DefineOptions[PlotSubprotocols,
	Options:>{
		{
			OptionName -> Output,
			Default -> Graph,
			Description -> "The output form displaying either a graph, table, or list of subprotocols.",
			Pattern:> All|Table|Graph|Association,
			Category -> "Method",
			AllowNull->False
		},
		{
			OptionName -> GraphLayout,
			Default -> "LayeredEmbedding",
			Pattern:> "LayeredEmbedding"|"RadialDrawing",
			AllowNull -> True,
			Description -> "Graph layout for readability.",
			Category -> "Method"
		},
		{
			OptionName -> ColorFunction,
			Default -> OperationStatus,
			Pattern:> Status|OperationStatus|None,
			AllowNull -> False,
			Description -> "Indicates if the Status or OperationStatus is used to color code the Graph and Table output.",
			Category -> "Method"
		}
	}
];

PlotSubprotocols::NoSubprotocols = "`1` does not have any subprotocols.";

PlotSubprotocols[protocol:ObjectP[ProtocolTypes[]], ops:OptionsPattern[PlotSubprotocols]]:=Module[
	{safeOps, rawoutput, rawcolorfunction, rawGraphLayout, graphLayout, output, colorfunction, allSubs, firstSubsGraph, flatSubs, flatSubsOpsStatus, flatSubsStatus, subsGraph},

	(*get the output option*)
	safeOps = ECL`OptionsHandling`SafeOptions[PlotSubprotocols, ToList[ops]];

	(* lookup the options *)
	{output, colorfunction, graphLayout}= Lookup[safeOps, {Output, ColorFunction, GraphLayout}];

	(* download all the subprotocols recursivly *)
	allSubs = Download[protocol, Subprotocols..];

	(* make the initial relationship *)
	firstSubsGraph = Map[(protocol[Object]->#)&, Download[allSubs[[All, 1]],Object]];

	(* get a flat list of subprotocols *)
	flatSubs = Append[Flatten[allSubs], protocol][Object];

	(* get the status from each *)
	(* TODO: can grab more info here if anyone wants to update this function *)
	{flatSubsOpsStatus, flatSubsStatus} =Transpose[Download[flatSubs, {OperationStatus, Status}]];

	(* format the relationships *)
	subsGraph = If[MatchQ[Length[flatSubs], GreaterP[1]],

		Module[{listUnits, graph},
			(* pull out each set of protocol/subprotocol pairings *)
			listUnits = Cases[allSubs, {ObjectP[ProtocolTypes[]], _List}, Infinity];

			(* generate the realtionships and append the initial realtionship to the parent protocol *)
			graph = Join[
				Flatten[
					Map[
						Function[unit,
							Module[{parent, subprots},
								parent = unit[[1]][Object];
								subprots =Download[ unit[[2,All,1]],Object];
								Map[(parent->#)&,subprots]
							]
						],
						listUnits
					]
				],
				firstSubsGraph
			]
		],

		Null
	];


	(* -- OUTPUT --*)
	If[MatchQ[Length[flatSubs], GreaterP[1]],
		Module[{statusMap, opsStatusMap, vertexStyle},

			statusMap = MapThread[(#1->#2)&, {flatSubs, flatSubsStatus}]/.{Null -> Grey,InCart -> Blue, Backlogged -> Yellow, ShippingMaterials ->Orange, Processing -> Green, Completed -> Black, Aborted->Red, Canceled->Pink};
			opsStatusMap = MapThread[(#1->#2)&, {flatSubs, flatSubsOpsStatus}]/.{Null -> Grey,None ->Black, OperatorStart -> Blue, OperatorProcessing -> Green, InstrumentProcessing ->Green, OperatorReady ->Green, Troubleshooting->Red};

			(* select the vertex color map to use based on the option value *)
			vertexStyle = Which[

				MatchQ[colorfunction, Status],
				(VertexStyle -> statusMap),

				MatchQ[colorfunction, OperationStatus],
				(VertexStyle -> opsStatusMap),

				True,
				(VertexStyle -> Black)
			];

			(* return either the graph of the assocaition *)
			Which[
				MatchQ[output, All],
				(* output the graph and a table with the status and color *)
				TableForm[{
					Zoomable[Graph[subsGraph, VertexLabels -> Placed["Name", Tooltip], EdgeStyle -> Black, ImageSize -> Large, VertexSize -> Medium, GraphLayout -> graphLayout, vertexStyle, VertexShapeFunction -> "Hexagon"]],
					Zoomable[PlotTable[Transpose[{flatSubs, flatSubsStatus, Values[statusMap], flatSubsOpsStatus, Values[opsStatusMap]}], TableHeadings -> {None, {"Protocol", "Status",  "StatusKey", "OperationStatus","OperationsStatusKey"}}]]
				}],

				MatchQ[output, Graph],
				(* output the graph only *)
				Zoomable[Graph[subsGraph, VertexLabels -> Placed["Name", Tooltip], EdgeStyle -> Black, ImageSize -> Large, VertexSize -> Large, vertexStyle, GraphLayout ->{graphLayout, "RootVertex"->Download[protocol,Object]}, VertexShapeFunction -> "Hexagon"]],

				MatchQ[output, Table],
				Zoomable[PlotTable[Transpose[{flatSubs, flatSubsStatus, Values[statusMap], flatSubsOpsStatus, Values[opsStatusMap]}], TableHeadings -> {None, {"Protocol", "Status", "StatusKey", "OperationStatus", "OperationsStatusKey"}}]],

				MatchQ[output, Association],
				subsGraph
			]
		],

		(*return no protocols*)
		Message[PlotSubprotocols::NoSubprotocols, ToString[protocol]];
		Null
	]
];

