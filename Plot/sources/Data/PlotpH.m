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


PlotpH[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotpH]]:=rawToPacket[primaryData,Object[Data,pH],PlotpH,SafeOptions[PlotpH, ToList[inputOptions]]];
(*PlotpH[infs:plotInputP,inputOptions:OptionsPattern[PlotpH]]:=packetToELLP[infs,PlotpH,{inputOptions}];*)


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
