(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceSpectroscopy*)


DefineOptions[PlotFluorescenceSpectroscopy,
	optionsJoin[
		generateSharedOptions[Object[Data,FluorescenceSpectroscopy],{ExcitationSpectrum,EmissionSpectrum},PlotTypes->{LinePlot},SecondaryData->{},Display->{Peaks},CategoryUpdates->{OptionFunctions->"Hidden"}],
		Options:>{ModifyOptions["Shared",EmeraldListLinePlot,{OptionName->Filling,Default->Bottom,Category->"Hidden"}]}
	],
	SharedOptions:>{EmeraldListLinePlot}
];

Error::NoFluorescenceSpectroscopyDataToPlot = "The protocol object does not contain any associated fluorescence spectroscopy data.";
Error::FluorescenceSpectroscopyProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotFluorescenceSpectroscopy or PlotObject on an individual data object to identify the missing values.";

(* Raw Definition *)
PlotFluorescenceSpectroscopy[
	primaryData:rawPlotInputP,
	inputOptions:OptionsPattern[PlotFluorescenceSpectroscopy]
]:=Module[
	{originalOps, safeOps, plotOutputs},

	(* Convert the original options into a list *)
	originalOps = ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotFluorescenceSpectroscopy, originalOps]/.{
		Rule[PrimaryData,_]->Rule[PrimaryData,ExcitationSpectrum]
	};

	(* get the plot(s) *)
	plotOutputs = rawToPacket[
		primaryData,
		Object[Data,FluorescenceSpectroscopy],
		PlotFluorescenceSpectroscopy,
		safeOps
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs, safeOps]
];

(* Protocol Overload *)
PlotFluorescenceSpectroscopy[
	obj: Alternatives[ObjectP[Object[Protocol, FluorescenceSpectroscopy]], ObjectP[Object[Protocol, LuminescenceSpectroscopy]]],
	ops: OptionsPattern[PlotFluorescenceSpectroscopy]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFluorescenceSpectroscopy, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, Alternatives[{ObjectP[Object[Data, FluorescenceSpectroscopy]]..}, {ObjectP[Object[Data, LuminescenceSpectroscopy]]..}]],
		Message[Error::NoFluorescenceSpectroscopyDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotFluorescenceSpectroscopy[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotFluorescenceSpectroscopy[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::FluorescenceSpectroscopyProtocolDataNotPlotted];
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

(* Packet Definition *)
(* PlotFluorescenceSpectroscopy[infs:plotInputP,inputOptions:OptionsPattern[PlotFluorescenceSpectroscopy]]:= *)
PlotFluorescenceSpectroscopy[
	infs:ListableP[ObjectP[{Object[Data, FluorescenceSpectroscopy],Object[Data, LuminescenceSpectroscopy]}],2],
	inputOptions:OptionsPattern[PlotFluorescenceSpectroscopy]
]:=Module[
	{originalOps, safeOps, plotOutputs, preResolvedPlotLabel},

	(* Convert the original options into a list *)
	originalOps = ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotFluorescenceSpectroscopy, originalOps];

	(* pre resolve the PlotLabel to be Null if we have a single object or multiple objects without Map -> True *)
	preResolvedPlotLabel = Which[
		Not[MatchQ[Lookup[safeOps, PlotLabel], Automatic]], Lookup[safeOps, PlotLabel],
		Not[TrueQ[Lookup[safeOps, Map]]] && ListQ[infs], Null,
		MatchQ[infs, ObjectP[]], Null,
		True, Automatic
	];

	(* get the plot(s) *)
	plotOutputs = packetToELLP[
		infs,
		PlotFluorescenceSpectroscopy,
		ReplaceRule[safeOps, PlotLabel -> preResolvedPlotLabel]
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs, safeOps]
];
