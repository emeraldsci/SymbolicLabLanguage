(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotQuantificationCycle*)


DefineOptions[PlotQuantificationCycle,
	Options:>{

		(* Default Zoomable to True *)
		ModifyOptions[ZoomableOption,Default->True],

		(* Hide irrelevant options *)
		ModifyOptions[EmeraldListLinePlot,{Peaks,PeakLabels,PeakLabelStyle,Fractions,FractionColor,FractionHighlightColor},Category->"Hidden"],
		ModifyOptions[EmeraldListLinePlot,{FrameUnits,TargetUnits,ErrorBars,ErrorType},Category->"Hidden"]

	},
	SharedOptions:>{
		EmeraldListLinePlot
	}
];


resolvePlotQuantificationCycleOptions[listedCqPackets_,safeOps_]:=Module[
	{aspectRatio,frameLabel,legend},

	(* Resolve AspectRatio *)
	aspectRatio=Replace[Lookup[safeOps,AspectRatio],Automatic->1/GoldenRatio];

	(* Resolve FrameLabel *)
	frameLabel=Replace[Lookup[safeOps,FrameLabel],Automatic->{"Cycle","\[CapitalDelta]Rn (RFU)"}];

	(* Resolve Legend *)
	legend=Replace[Lookup[safeOps,Legend],Automatic->ToString/@Lookup[listedCqPackets,Object]];

	(* Return resolved options *)
	ReplaceRule[safeOps,{
		AspectRatio->aspectRatio,
		FrameLabel->frameLabel,
		Legend->legend
		}
	]
];


PlotQuantificationCycle[
	objs:ListableP[ObjectReferenceP[Object[Analysis,QuantificationCycle]]|LinkP[Object[Analysis,QuantificationCycle]]],
	ops:OptionsPattern[PlotQuantificationCycle]
]:=PlotQuantificationCycle[
	ToList[Download[objs]],
	ops
];

(*Main function accepting a list of QuantificationCycle analysis packets*)
PlotQuantificationCycle[
	cqPackets:ListableP[PacketP[Object[Analysis,QuantificationCycle]]],
	ops:OptionsPattern[PlotQuantificationCycle]
]:=Module[
	{listedCqPackets,safeOps,fittingDataPoints,cqvals,yints,cqyvals,resolvedOps,epilog,calculatedEpilog,finalPlot,finalGraphics,output},

	listedCqPackets=ToList[cqPackets];
	safeOps=SafeOptions[PlotQuantificationCycle,ToList[ops]];

	(*Look up some values from the analysis packets*)
	fittingDataPoints=QuantityMagnitude[Lookup[listedCqPackets,FittingDataPoints]];
	cqvals=Unitless[Lookup[listedCqPackets,QuantificationCycle]];

	(*Get the fluorescence values corresponding to the Cq values, using the interpolating functions*)
	yints=Interpolation/@fittingDataPoints;
	cqyvals=Quiet[MapThread[#1[#2]&,{yints,cqvals}],InterpolatingFunction::dmval];

	(* Resolve options *)
	resolvedOps=resolvePlotQuantificationCycleOptions[listedCqPackets,safeOps];

	(* Merge user-specified Epilog with calculated epilog *)
	epilog=ToList@Lookup[resolvedOps,Epilog];
	calculatedEpilog=MapThread[
		Mouseover[
			{ColorData[97][#3],PointSize[0.02],Tooltip[Point[{#1,#2}],{#1 Cycle,#2 RFU}]},
			{ColorData[97][#3],PointSize[0.03],Tooltip[Point[{#1,#2}],{#1 Cycle,#2 RFU}]}
			]&,
		{cqvals,cqyvals,Range[Length[cqyvals]]}
	];

	(* Generate plot *)
	finalPlot=EmeraldListLinePlot[
		fittingDataPoints,
		Epilog->Append[epilog,calculatedEpilog],
		Output->Result,
		PassOptions[
			EmeraldListLinePlot,
			Sequence@@resolvedOps
		]
	];

	(* Extract Graphics[] from final plot, stripping any DynamicModule/EventHandler/Legended heads *)
	finalGraphics=First@Cases[ToList@finalPlot,_Graphics,-1];

	(* Return the result, according to the output option *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},

		(* Update the resolved options before returning them *)
		Options->ReplaceRule[resolvedOps,ReplaceRule[Options[finalGraphics],Epilog->epilog]]
	}

];
