(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPowderXRD*)


DefineOptions[PlotPowderXRD,
	generateSharedOptions[Object[Data, XRayDiffraction], DiffractionSpectrum, PlotTypes -> {LinePlot}, Display -> {Peaks}, DefaultUpdates -> {FrameLabel -> {"2\[Theta] (Degrees)", "Intensity (counts per second)"}}],
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
