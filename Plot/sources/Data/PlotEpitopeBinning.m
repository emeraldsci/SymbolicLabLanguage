(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* PlotEpitopeBinning *)

Authors[PlotEpitopeBinning]={"alou", "robert"};

DefineOptions[PlotEpitopeBinning,
  Options:>{
    OutputOption
  },
	SharedOptions:>{
		ModifyOptions["Shared",EmeraldListLinePlot,{
			{OptionName->AspectRatio,Default->0.618},
			{OptionName->PlotLabel,Default->"Binned Antibodies"},
			{OptionName->Frame,Default->{{False,False},{False,False}}}
		}],
		{EmeraldListLinePlot,{ImageSize,LabelStyle,Frame,FrameStyle,GridLines,GridLinesStyle}}
	}
];

(*Messages*)
Warning::EpitopeBinningAnalysisMissing="There is no BindingQuantitation analysis object linked to the input data object(s). If you would like the data to be fit, please run AnalyzeBindingKinetics on the data objects.";

(* overload for protocol input *)
PlotEpitopeBinning[
  objs:ObjectReferenceP[Object[Protocol, BioLayerInterferometry]]|LinkP[Object[Protocol, BioLayerInterferometry]],
  ops:OptionsPattern[PlotEpitopeBinning]
]:=Module[
	{originalOps,safeOps,output,mappedOutputs,outputRules},

  (* Convert the original options into a list *)
  originalOps=ToList[ops];

  (* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
  safeOps=SafeOptions[PlotEpitopeBinning,originalOps];

  (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
  output=Lookup[safeOps,Output];

	(* Map the outputs *)
	mappedOutputs=Map[
		PlotEpitopeBinning[#, ReplaceRule[originalOps,{Output->ToList[output]}]]&,
		ToList[Download[objs, Data]]
	]/.{Null->Repeat[$Failed,Length@ToList[output]]};

	(* Consolidate the output rules *)
	outputRules=MapThread[
		Switch[#1,
			(* Result is just a list of graphics *)
			Result,Result->If[MatchQ[#2,$Failed],
				$Failed,
				#2
			],

			(* Preview puts the graphics in a SlideView *)
			Preview,Preview->If[MatchQ[#2,$Failed],
				Null,
				SlideView[#2,ImageSize->Full,Alignment->Center]
			],

			(* Options *)
			Options,If[MatchQ[#2,$Failed],
				$Failed,
				Options->First[#2]
			],

			(* Tests return nothing *)
			Tests,Tests->{}
		]&,
		{ToList[output],Transpose@mappedOutputs}
	];

	(* Return the requested output *)
	output/.outputRules
];


(*Function overload accepting one BLI data objects*)
PlotEpitopeBinning[
  objs:ObjectP[Object[Data,BioLayerInterferometry]],
  ops:OptionsPattern[PlotEpitopeBinning]
]:=Module[{analysisObjs},
  (* Download the analysis object(s) *)
  analysisObjs=Flatten[Download[Download[objs,{BinningAnalysis}],Object]];

  (* if theres no analysis object we cant plot anything useful *)
  If[MatchQ[analysisObjs,({}|Null|{Null..})],
		(* No analysis objs - warn the user and plot the data *)
    Return[Message[Warning::EpitopeBinningAnalysisMissing]];
    PlotObject[objs],

    (* If epitope binning analysis is present, pass to core overload *)
    PlotEpitopeBinning[Last[analysisObjs],ops]
  ]
];


(* -- CORE OVERLOAD -- *)
PlotEpitopeBinning[
	objs:ObjectP[Object[Analysis,EpitopeBinning]],
  ops:OptionsPattern[PlotEpitopeBinning]
]:=Module[
  {
    originalOps, safeOps, output, plot,
    packet, threshold, slowBindingThreshold, slowBindingSpecies, competitionData,
    responsePackets, crossBlockingPackets,
    colorFunction, slowBinderColorFunction, unformattedGraph, edgeStyle, graphVertices,
    graphVerticesLabels, composedVertexLabels, composedGraph, bins
  },

  (* Convert the original options into a list *)
  originalOps=ToList[ops];

  (* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
  safeOps=SafeOptions[PlotEpitopeBinning,originalOps];

  (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
  output=Lookup[safeOps,Output];

  (* download the fields we need to plot *)
  packet=Download[objs,Packet[Threshold, SlowBindingThreshold, SlowBindingSpecies, CompetitionData]];

  (* extract the values and strip links *)
  {
    threshold,
    slowBindingThreshold,
    slowBindingSpecies,
    competitionData
  } = Lookup[
    packet,
    {
      Threshold,
      SlowBindingThreshold,
      SlowBindingSpecies,
      CompetitionData
    }
  ]/.x:LinkP:>x[Object];

  (* format the packets for easier handling *)
  responsePackets = Map[<|Bound -> #[[1]], Competing -> #[[2]], NormalizedResponse -> #[[3]]|>&,competitionData];

  (* find any steps that are cross blocking *)
  crossBlockingPackets = Select[
    responsePackets,
    Or[
      MatchQ[Lookup[#, NormalizedResponse], LessP[Unitless[threshold]]]&&MatchQ[Lookup[#,Competing], Except[Alternatives[Download[slowBindingSpecies, Object]]]],
      MatchQ[Lookup[#, NormalizedResponse], LessP[Unitless[slowBindingThreshold/.Null -> 0]]]&&MatchQ[Lookup[#,Competing], Alternatives[Download[slowBindingSpecies, Object]]]
    ]&
  ];

  (* make a color function to show how strong the binding is *)
  colorFunction = {
    x:GreaterP[Unitless[threshold]*0.75] -> Red,
    x:RangeP[Unitless[threshold]*0.5, Unitless[threshold]*0.75]->Orange,
    x:RangeP[Unitless[threshold]*0.25, Unitless[threshold]*0.5]->Yellow,
    x:LessP[Unitless[threshold]*0.25]->Green
  };

  (* make a color function for the slow binders also *)
  slowBinderColorFunction = If[MatchQ[slowBindingThreshold, Null],
    {},
    {
      x:GreaterP[Unitless[slowBindingThreshold]*0.75] -> Red,
      x:RangeP[Unitless[slowBindingThreshold]*0.5, Unitless[slowBindingThreshold]*0.75]->Orange,
      x:RangeP[Unitless[slowBindingThreshold]*0.25, Unitless[slowBindingThreshold]*0.5]->Yellow,
      x:LessP[Unitless[slowBindingThreshold]*0.25]->Green
    }
  ];

  (* make the graph input with formatting *)
  unformattedGraph =
      Map[
        Module[{bound, competing, response, colorRule},
          {bound, competing, response} = Lookup[#, {Bound, Competing, NormalizedResponse}];

          (* determine our color rule *)
          colorRule = If[MemberQ[Download[slowBindingSpecies,Object],competing],
            slowBinderColorFunction,
            colorFunction
          ];

          (* make the color function graph *)
          bound<->competing
        ]&,
        crossBlockingPackets
      ];

  (* make the edges color scheme based on how good the blocking is *)
  edgeStyle = MapThread[Module[{colorRule, color},
    colorRule = If[MemberQ[Download[slowBindingSpecies,Object],#1[[2]]],
      slowBinderColorFunction,
      colorFunction
    ];

    color = Lookup[#2, NormalizedResponse]/.colorRule;
    #1 -> color
  ]&,
    {unformattedGraph, crossBlockingPackets}
  ];

  (* graph the vertices also so we can label them *)
  graphVertices = Lookup[crossBlockingPackets, Bound];
  graphVerticesLabels = Download[graphVertices, ID];
  composedVertexLabels = MapThread[(#1->#2)&, {graphVertices, graphVerticesLabels}];

	(* Compose the graph *)
  composedGraph = Graph[
    unformattedGraph,
		ReplaceRule[{stringOptionsToSymbolOptions@PassOptions[PlotEpitopeBinning,Graph,safeOps]},
			{
				(* Options which cannot be changed *)
		    VertexLabels -> composedVertexLabels,
		    EdgeStyle -> edgeStyle,
		    VertexStyle -> Blue,
		    VertexSize -> Small,
		    VertexShapeFunction -> "Hexagon"
			}
		]
  ];

  (* check for any true bins, ie those where every element blocks every other element *)
  bins=ConnectedComponents[composedGraph];

  (* also visualize as bins on the graph *)
  plot=HighlightGraph[composedGraph, bins];

  (* Return the requested outputs *)
  output/.{
    Result->plot,
    Options->safeOps,
    Preview->Show[plot,ImageSize->Full],
    Tests->{}
  }
];