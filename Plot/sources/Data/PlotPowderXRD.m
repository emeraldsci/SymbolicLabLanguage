(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPowderXRD*)


DefineOptions[PlotPowderXRD,
	generateSharedOptions[Object[Data, XRayDiffraction], BlankedDiffractionPattern, PlotTypes -> {LinePlot}, Display -> {Peaks}, DefaultUpdates -> {FrameLabel -> {"2\[Theta] (Degrees)", "Intensity (counts per second)"}}],
	SharedOptions :> {
		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				ErrorBars,ErrorType,InterpolationOrder,
				TargetUnits,
				Fractions,FractionColor,FractionHighlights,FractionHighlightColor,
				Ladder,Display,Scale,
				PeakSplitting,PeakPointSize,PeakPointColor,PeakWidthColor,PeakAreaColor
			},
			Category->"Hidden"
		],
		EmeraldListLinePlot
	}
];

Error::NoXRayDiffractionDataToPlot = "The protocol object does not contain any associated X-ray diffraction data.";
Error::XRayDiffractionProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotPowderXRD or PlotObject on an individual data object to identify the missing values.";

(* Protocol Overload *)
PlotPowderXRD[
	obj: ObjectP[Object[Protocol, PowderXRD]],
	ops: OptionsPattern[PlotPowderXRD]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotPowderXRD, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, XRayDiffraction]]..}],
		Message[Error::NoXRayDiffractionDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotPowderXRD[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotPowderXRD[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::XRayDiffractionProtocolDataNotPlotted];
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

(* PlotPowderXRD[myDataObjs:plotInputP, myOptions:OptionsPattern[PlotPowderXRD]]:= *)
PlotPowderXRD[myDataObjs:ListableP[ObjectP[Object[Data,XRayDiffraction]],2], myOptions:OptionsPattern[PlotPowderXRD]]:=Module[
	{originalOps, safeOps, plotOutputs},

	(* Convert the original options into a list *)
	originalOps = ToList[myOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotPowderXRD, ToList[myOptions]];

	(* get the plot(s); note that packetToELLP takes the original options, NOT the safe options *)
	plotOutputs = packetToELLP[myDataObjs, PlotPowderXRD, originalOps];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs, safeOps]
];

PlotPowderXRD[myPrimaryData:rawPlotInputP, myOptions:OptionsPattern[PlotPowderXRD]]:=Module[
	{originalOps, safeOps, plotOutputs},

	(* Convert the original options into a list *)
	originalOps = ToList[myOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotPowderXRD, ToList[myOptions]];

	(* get the plot(s) *)
	plotOutputs = rawToPacket[myPrimaryData, Object[Data, XRayDiffraction], PlotPowderXRD, safeOps];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs, safeOps]
];
