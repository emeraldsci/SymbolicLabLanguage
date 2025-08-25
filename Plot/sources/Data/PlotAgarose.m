(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAgarose*)


DefineOptions[PlotAgarose,
	optionsJoin[
		Options:>{
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Filling,
						Default->Bottom,
						Description->"Indicates how the region under the spectrum should be shaded.",
						Category->"Hidden"
					}
				}
			],
			ModifyOptions[ScaleOption,
				{
					{
						OptionName->Scale,
						Default->LogLinear,
						Description->"Specifies the type of scaling the x and y axis will have.",
						Category->"Hidden"
					}
				}
			]
		},
		generateSharedOptions[Object[Data,AgaroseGelElectrophoresis], SampleElectropherogram,PlotTypes -> {LinePlot}, Display -> {Peaks},DefaultUpdates -> {FrameLabel -> {"Strand Length (bp)", "Fluorescence (RFU)"}}]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

Error::NoAgaroseGelElectrophoresisDataToPlot = "The protocol object does not contain any associated agarose gel electrophoresis data.";
Error::AgaroseGelElectrophoresisProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotAgarose or PlotObject on an individual data object to identify the missing values.";


PlotAgarose[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotAgarose]]:=rawToPacket[primaryData,Object[Data,AgaroseGelElectrophoresis],PlotAgarose,SafeOptions[PlotAgarose, ToList[inputOptions]]];

(* protocol overload *)
PlotAgarose[
	obj:ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
	ops:OptionsPattern[PlotAgarose]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotAgarose, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, AgaroseGelElectrophoresis]]..}],
		Message[Error::NoAgaroseGelElectrophoresisDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotAgarose[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotAgarose[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::AgaroseGelElectrophoresisProtocolDataNotPlotted];
		Return[$Failed],
		Nothing
	];

	(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
	outputPlot = If[MemberQ[output, Result],
		If[Length[plots] > 1,
			SlideView[plots],
			First[plots]
		]
	];

	(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
	outputOptions = If[MemberQ[output, Options],
		First[ToList[resolvedOptions]]
	];

	(* Prepare our final result *)
	finalResult = output /. {
		Result -> outputPlot,
		Options -> outputOptions,
		Preview -> previewPlot,
		Tests -> {}
	};

	(* Return the result *)
	If[
		Length[finalResult] == 1,
		First[finalResult],
		finalResult
	]
];


(* PlotAgarose[infs:plotInputP,inputOptions:OptionsPattern[PlotAgarose]]:= *)
PlotAgarose[infs:ListableP[ObjectP[Object[Data, AgaroseGelElectrophoresis]],2],inputOptions:OptionsPattern[PlotAgarose]]:=Quiet[packetToELLP[infs,PlotAgarose,ToList[inputOptions]],CompiledFunction::cfnlts];
