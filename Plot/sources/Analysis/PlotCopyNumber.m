(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotCopyNumber*)

DefineOptions[PlotCopyNumber,
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


resolvePlotCopyNumberOptions[standardCurvePackets_,standardCurveLogCnVals_,safeOps_]:=Module[
	{legend,plotRange,frameLabel},

	(* Resolve PlotRange *)
	plotRange=Replace[
		Lookup[safeOps,PlotRange],
		Automatic->{{Min[Flatten[standardCurveLogCnVals]]-0.25,Max[Flatten[standardCurveLogCnVals]]+0.25},Automatic}
	];

	(* Resolve FrameLabel *)
	frameLabel=Replace[Lookup[safeOps,FrameLabel],Automatic->{"Log10 Copy Number","Quantification Cycle"}];

	(* Resolve Legend *)
	legend=Replace[Lookup[safeOps,Legend],Automatic->ToString/@Lookup[standardCurvePackets,Object]];

	(* Return resolved options *)
	ReplaceRule[safeOps,{
		PlotRange->plotRange,
		FrameLabel->frameLabel,
		Legend->legend
		}
	]
];


(*Function overload accepting one or more CopyNumber analysis objects*)
PlotCopyNumber[
	objs:ListableP[ObjectReferenceP[Object[Analysis,CopyNumber]]|LinkP[Object[Analysis,CopyNumber]]],
	ops:OptionsPattern[PlotCopyNumber]
]:=PlotCopyNumber[
	ToList[Download[objs]],
	ops
];

(*Main function accepting a list of CopyNumber analysis packets*)
PlotCopyNumber[
	cnPackets:ListableP[PacketP[Object[Analysis,CopyNumber]]],
	ops:OptionsPattern[PlotCopyNumber]
]:=Module[
	{listedCnPackets,safeOps,cnVals,logCnVals,cqVals,cqValsFromCnObjects,cqValsFromCnPackets,
		standardCurvePackets,standardCurveFits,standardCurveDataPoints,standardCurveLogCnVals,standardCurveCqVals,
		resolvedOps,epilog,calculatedEpilog,finalPlot,finalGraphics,output},

	listedCnPackets=ToList[cnPackets];
	safeOps=SafeOptions[PlotCopyNumber,ToList[ops]];

	(*Look up calculated copy numbers from the analysis packets*)
	cnVals=Lookup[listedCnPackets,CopyNumber];
	logCnVals=Log10[cnVals];

	(*Get the input Cq values from copy number objects or packets (i.e. AnalyzeCopyNumberPreview)*)
	cqValsFromCnObjects=Unitless[Download[Last/@Lookup[listedCnPackets,Reference],QuantificationCycle]];
	cqValsFromCnPackets=Unitless[Download[Lookup[listedCnPackets,Replace[Reference]],QuantificationCycle]];
	cqVals=If[MatchQ[cqValsFromCnObjects,{_Real..}],
		cqValsFromCnObjects,
		cqValsFromCnPackets
	];

	(*Download the standard curve packets*)
	standardCurvePackets=Download[Lookup[listedCnPackets,StandardCurve],Packet[BestFitExpression,DataPoints]];

	(*Get the fits and log-transformed data points from standardCurvePackets*)
	standardCurveFits=DeleteDuplicates[Lookup[standardCurvePackets,BestFitExpression]];
	standardCurveDataPoints=Unitless[DeleteDuplicates[Lookup[standardCurvePackets,DataPoints]]];
	standardCurveLogCnVals=standardCurveDataPoints[[All,All,1]];
	standardCurveCqVals=standardCurveDataPoints[[All,All,2]];

	(* Resolve options *)
	resolvedOps=resolvePlotCopyNumberOptions[standardCurvePackets,standardCurveLogCnVals,safeOps];

	(* Merge user-specified Epilog with calculated epilog *)
	epilog=ToList@Lookup[resolvedOps,Epilog];
	calculatedEpilog={
		MapThread[
			{ColorData[97][#3],PointSize[0.015],Point[Transpose[{#1,#2}]]}&,
			{standardCurveLogCnVals,standardCurveCqVals,Range[Length[standardCurveCqVals]]}
		],
		MapThread[
			Mouseover[
				{Red,PointSize[0.02],Tooltip[Point[{#1,#2}],{#1,#2 Cycle}]},
				{Red,PointSize[0.03],Tooltip[Point[{#1,#2}],{#1,#2 Cycle}]}
			]&,
			{logCnVals,cqVals}
		]
	};

	(* Generate plot *)
	finalPlot=EmeraldListLinePlot[
		MapThread[
			Table[{x,#1},{x,Range[Min[#2],Max[#2]]}]&,
			{standardCurveFits,standardCurveLogCnVals}
		],
		Output->Result,
		PassOptions[
			EmeraldListLinePlot,
			Epilog->Append[calculatedEpilog,epilog],
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
