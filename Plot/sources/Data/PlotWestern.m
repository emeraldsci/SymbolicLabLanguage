(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotWestern*)


DefineOptions[PlotWestern,
	optionsJoin[
		Options :> {ModifyOptions[EmeraldListLinePlot, Filling,Default-> Bottom,Category->"Hidden"]},
		generateSharedOptions[Object[Data,Western], MassSpectrum, PlotTypes -> {LinePlot}, Display -> {Peaks, Ladder}]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

Error::NoWesternDataToPlot = "The protocol object does not contain any associated Western data.";
Error::WesternProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotWestern or PlotObject on an individual data object to identify the missing values.";

PlotWestern[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotWestern]]:=
    rawToPacket[primaryData,Object[Data,Western],PlotWestern,SafeOptions[PlotWestern, ToList[inputOptions]]];
(* PlotWestern[infs:plotInputP,inputOptions:OptionsPattern[PlotWestern]]:= *)
PlotWestern[infs:ListableP[ObjectP[Object[Data,Western]],2],inputOptions:OptionsPattern[PlotWestern]]:=
    packetToELLP[infs,PlotWestern,ToList[inputOptions]];

(* Protocol Overload *)
PlotWestern[
	obj: Alternatives[ObjectP[Object[Protocol, Western]], ObjectP[Object[Protocol, TotalProteinDetection]]],
	ops: OptionsPattern[PlotWestern]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotWestern, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, Western]]..}],
		Message[Error::NoWesternDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotWestern[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotWestern[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::WesternProtocolDataNotPlotted];
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
