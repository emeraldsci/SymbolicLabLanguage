(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDissolvedOxygen*)

DefineOptions[PlotDissolvedOxygen,
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
				{OptionName ->FrameLabel,Default->{None,"DissolvedOxygen",None,None}}
			}
		]
	},
	SharedOptions:>{EmeraldBarChart}
];


PlotDissolvedOxygen[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotDissolvedOxygen]]:=rawToPacket[primaryData,Object[Data,DissolvedOxygen],PlotDissolvedOxygen,SafeOptions[PlotDissolvedOxygen, ToList[inputOptions]]];
(*PlotDissolvedOxygen[infs:plotInputP,inputOptions:OptionsPattern[PlotDissolvedOxygen]]:=packetToELLP[infs,PlotDissolvedOxygen,{inputOptions}];*)


PlotDissolvedOxygen[input:ListableP[ObjectP[Object[Data,DissolvedOxygen]],2],inputOptions:OptionsPattern[]]:=Module[
	{
		listedInput, download, resolvedChartLabels,resolvedFrameLabel,
		plot, mostlyResolvedOps, resolvedOps, finalResolvedOps, output,originalOps,
		safeOps, plotOptions
	},

	(* Convert the original options into a list *)
	originalOps=ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotDissolvedOxygen,ToList[inputOptions]];

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
		{Automatic, "DissolvedOxygen", None, None},
		Lookup[safeOps,FrameLabel]
	];

	plotOptions=ReplaceRule[originalOps,
		{
			ChartLabels->resolvedChartLabels,
			FrameLabel ->resolvedFrameLabel
		}
	];

	(* Call one of the MegaPlots.m functions, typically EmeraldListLinePlot, and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldBarChart[Lookup[download,DissolvedOxygen],
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
