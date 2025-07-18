(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotpH*)


DefineOptions[PlotpH,
	Options:>{
		ModifyOptions[EmeraldBarChart,
			{
				{
					OptionName->ChartLabels,
					Default->Automatic,
					Widget->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[None,Automatic]],
						"Specify Labels"->Adder[Alternatives[
							"Integer"->Widget[Type->Number,Pattern:>GreaterP[0,1]],
							"String"->Widget[Type->String,Pattern:>_String,Size->Word]
						]]
					]
				},
				{OptionName ->FrameLabel,Default->{None,"pH",None,None}}
			}
		]
	},
	SharedOptions:>{EmeraldBarChart}
];

Error::NopHDataToPlot = "The protocol object does not contain any associated pH data.";
Error::MeasurepHProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotpH or PlotObject on an individual data object to identify the missing values.";

PlotpH[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotpH]]:=rawToPacket[primaryData,Object[Data,pH],PlotpH,SafeOptions[PlotpH, ToList[inputOptions]]];
(*PlotpH[infs:plotInputP,inputOptions:OptionsPattern[PlotpH]]:=packetToELLP[infs,PlotpH,{inputOptions}];*)

(* Protocol Overload *)
PlotpH[
	obj: ObjectP[Object[Protocol, MeasurepH]],
	ops: OptionsPattern[PlotpH]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotpH, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, pH]]..}],
		Message[Error::NopHDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotpH[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotpH[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::MeasurepHProtocolDataNotPlotted];
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

PlotpH[input:ListableP[ObjectP[Object[Data,pH]],2],inputOptions:OptionsPattern[]]:=Module[
	{
		 listedInput, download, resolvedChartLabels,resolvedFrameLabel,
		plot, mostlyResolvedOps, resolvedOps, finalResolvedOps, output,originalOps,
			safeOps, plotOptions
	},

	(* Convert the original options into a list *)
	originalOps=ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotpH,ToList[inputOptions]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Listify the input *)
	listedInput = ToList[input];

	(*perform our download*)
	download = Download[listedInput];

	(*use the object id for the label if not specified*)
	resolvedChartLabels=If[MatchQ[Lookup[safeOps,ChartLabels],Automatic],
		If[Length[listedInput]>1,
			Placed[ECL`InternalUpload`ObjectToString/@Lookup[download,Object], Axis, Rotate[#, Pi/2] &],
			None
		],
		Lookup[safeOps,ChartLabels]
	];

	(*default the label if not specified*)
	resolvedFrameLabel=If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
		{Automatic, "pH", None, None},
		Lookup[safeOps,FrameLabel]
	];

	plotOptions=ReplaceRule[originalOps,
		{
			ChartLabels->resolvedChartLabels,
			FrameLabel ->resolvedFrameLabel
		}
	];

	(* Call one of the MegaPlots.m functions, typically EmeraldListLinePlot, and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldBarChart[Lookup[download,pH],
		ReplaceRule[plotOptions,Output->{Result,Options}]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOps,mostlyResolvedOps,Append->False];

	(* Any special resolutions specific to your plot (which are not covered by underlying plot function) *)
	finalResolvedOps=resolvedOps;

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->finalResolvedOps,
		Preview->plot,
		Tests->{}
	}
];
