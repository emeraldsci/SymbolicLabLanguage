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
