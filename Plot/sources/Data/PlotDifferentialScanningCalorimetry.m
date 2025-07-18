(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDifferentialScanningCalorimetry*)


DefineOptions[PlotDifferentialScanningCalorimetry,
	generateSharedOptions[Object[Data, DifferentialScanningCalorimetry], HeatingCurves, PlotTypes -> {LinePlot}, Display -> {Peaks}, DefaultUpdates -> {FrameLabel -> {Automatic, "Differential Enthalpy", None, None}}],
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
		ModifyOptions["Shared", EmeraldListLinePlot, {OptionName -> Filling, Default -> Bottom, Category -> "Hidden"}],
		EmeraldListLinePlot
	}
];

Error::NoDifferentialScanningCalorimetryDataToPlot = "The protocol object does not contain any associated differential scanning calorimetry data.";
Error::DifferentialScanningCalorimetryProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotDifferentialScanningCalorimetry or PlotObject on an individual data object to identify the missing values.";

PlotDifferentialScanningCalorimetry[primaryData:rawPlotInputP,myOptions:OptionsPattern[PlotDifferentialScanningCalorimetry]]:=Module[
	{originalOps, safeOps, plotOutputs},

	(* Convert the original options into a list *)
	originalOps = ToList[myOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotDifferentialScanningCalorimetry, ToList[myOptions]];

	(* get the plot(s) *)
	plotOutputs = rawToPacket[primaryData, Object[Data, DifferentialScanningCalorimetry], PlotDifferentialScanningCalorimetry, SafeOptions[PlotDifferentialScanningCalorimetry, originalOps]];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs, safeOps]
];

(* Protocol Overload *)
PlotDifferentialScanningCalorimetry[
	obj: ObjectP[Object[Protocol, DifferentialScanningCalorimetry]],
	ops: OptionsPattern[PlotDifferentialScanningCalorimetry]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotDifferentialScanningCalorimetry, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, DifferentialScanningCalorimetry]]..}],
		Message[Error::NoDifferentialScanningCalorimetryDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotDifferentialScanningCalorimetry[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotDifferentialScanningCalorimetry[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::DifferentialScanningCalorimetryProtocolDataNotPlotted];
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

(*PlotDifferentialScanningCalorimetry[myDataObjs:plotInputP,myOptions:OptionsPattern[PlotDifferentialScanningCalorimetry]]:=*)
PlotDifferentialScanningCalorimetry[myDataObjs:ListableP[ObjectP[Object[Data, DifferentialScanningCalorimetry]],2],myOptions:OptionsPattern[PlotDifferentialScanningCalorimetry]]:=Module[
	{originalOps, safeOps, plotOutputs, nearlyCompletePlot, analysisObjects, plotEdits},

	(* Convert the original options into a list *)
	originalOps = ToList[myOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotDifferentialScanningCalorimetry, ToList[myOptions]];

	(* get the plot(s); note that packetToELLP takes the original options, NOT the safe options *)
	plotOutputs = packetToELLP[myDataObjs, PlotDifferentialScanningCalorimetry, originalOps];

	(* Use the processELLPOutput helper *)
	nearlyCompletePlot = processELLPOutput[plotOutputs, safeOps];

	(* check that the heating curves option is not set *)
	(* if it is just return the nearly complete plot b/c the DSC analysis
	will not make sense on completely new data *)
	heatingCurvesOp = Lookup[safeOps, HeatingCurves];
	If[Not[NullQ[heatingCurvesOp]], Return[nearlyCompletePlot]];

	(* check if data has analysis object attached *)
	(* download the dsc analysis objects from data objects *)
	analysisObjects = Quiet[Download[ToList[myDataObjs], Analyses], {Download::MissingField}];

	(* map these analysis objects with data plot objects into helper that appends analysis data onto epilogs *)
	plotEdits = Map[addDSCAnalysisToEpilog[nearlyCompletePlot, #]&, analysisObjects];

	(* return the last plot, which contains all the edits in the epilog *)
	Last[plotEdits]
];


(* helper that edits the plot epilogs to include DSC analysis info *)
(* overload that returns plot if no analysis is present *)
addDSCAnalysisToEpilog[plot_, {}]:=plot;
addDSCAnalysisToEpilog[plot_, $Failed]:=plot;

(* overload that actually edits the epilog *)
addDSCAnalysisToEpilog[plot_, analyses_]:=Module[
	{
		mostRecentAnalysis, meltTemps, onsetTemp, meltDEs, onsetDE,
		meltTempPositions, onsetTempPosition,
		meltTempMouseovers, onsetTempMouseover, mouseoverPoints
	},

	(* pick out the most recent analysis object *)
	mostRecentAnalysis = First[analyses];

	(* get the melting temp and onset temp data points from analysis *)
	(* TODO: add these fields to packet in analysis function *)
	{meltTemps, meltDEs, onsetTemp, onsetDE} = Download[mostRecentAnalysis,
		{MeltingTemperatures, MeltingDifferentialEnthalpies, OnsetTemperature, OnsetDifferentialEnthalpy}
	];
	meltTempPositions = Transpose[{meltTemps, meltDEs}];
	onsetTempPosition = {onsetTemp, onsetDE};

	(* create mouseover objects for melt temp and onset temp *)
	(* the mouseover will look like a standard, unlabeled point, but when hovered,
	it will make the dot larger, blue, and labeled with a title and position *)
	meltTempMouseovers = makeDSCMouseoverPoint[#, "Melting Temperature"]& /@ meltTempPositions;
	onsetTempMouseover = If[MatchQ[onsetTempPosition, {Null,Null}],
		Nothing,
		makeDSCMouseoverPoint[onsetTempPosition, "Onset Temperature"]
	];

	(* join the points together *)
	mouseoverPoints = Join[meltTempMouseovers, {onsetTempMouseover}];

	(* append to the existing epilog of the plot using some replace magic *)
	ReplaceAll[plot, (Epilog->list_List) :>
		(Epilog -> Append[list, mouseoverPoints])
	]
];

(* helper that makes mouseover points for this specific plot theme *)
makeDSCMouseoverPoint[position_List, title_String]:=Mouseover[
	mediumPoint[Unitless[position]],
	largeDotWithTitle[Unitless[position], title<>"\n"<>ToString[First[position]]]
];

(* helper to make large graphics dot with text *)
largeDotWithTitle[position_List, title_String]:={
	Blue,
	PointSize[Large],
	Point[position],
	Text[
		Style[title, Blue, 14],
		Offset[{0,-30}, position]
	]
};

(* helper that makes a simple medium sized graphics point *)
mediumPoint[position_List]:={PointSize[Medium], Point[position]};
