(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotStandardCurve*)


DefineOptions[PlotStandardCurve,
	Options:>{
		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				ImageSize,Zoomable,PlotRangeClipping,ClippingStyle,ScaleX,ScaleY,LegendLabel,
				SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle,SecondYUnit,TargetUnits,
				ErrorBars,ErrorType,Reflected,Scale,Joined,InterpolationOrder,PlotStyle,
				PeakLabels,PeakLabelStyle,FractionColor,FractionHighlightColor,Tooltip,VerticalLine,
				Peaks,Fractions,FractionHighlights,Ladder
			},
			Category->"Hidden"
		]
	},
  SharedOptions:>{EmeraldListLinePlot}
];


PlotStandardCurve[
	myPacket:PacketP[Object[Analysis,StandardCurve]],
	myOptions:OptionsPattern[PlotStandardCurve]
]:=Module[
	{
		safePacket,originalOps,safeOptions,output,inverseQ,safeMean,standardCurveDataPoints,standardCurveFitFunction,dimensionlessFitFunction,defaultBlue,
		rawInputData,myInputData,myInputDataUnits,resolvedInputUnit,inputXMin,inputXMax,standardXUnit,standardYUnit,unitCorrectedInputData,
		unitlessStandardDataQ,resolvedStandardDataPoints,rawPredictedValues,myPredictedValues,inputXYData,inputDataLabels,setDefaultOption,plotOptions,
		inputDataPlot,resolvedOps,standardXMin,standardXMax,standardXDifference,resolvedPlotRange,standardCurvePlot,plotResult,finalResolvedOps
	},

	(* Remove lingering Replace[] or Append[] syntax from myPacket *)
	safePacket=Analysis`Private`stripAppendReplaceKeyHeads[myPacket];

	(* Get the original options passed to the function *)
	originalOps=ToList[myOptions];

	(* Convert options to a list *)
	safeOptions=SafeOptions[PlotStandardCurve,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOptions,Output];

	(* True if InversePrediction has been used to map y-to-x instead of x-to-y using the standard curve *)
	inverseQ=Lookup[safePacket,InversePrediction];

	(* Define a safeMean Helper to process distributions *)
	safeMean[x:DistributionP[]]:=Mean[x];
	safeMean[x_]:=x;

	(* The pure function associated with the fit *)
	standardCurveFitFunction=Lookup[safePacket,BestFitFunction];

	(* Get units of the standard curve *)
	{standardXUnit,standardYUnit}=Lookup[safePacket,StandardDataUnits];

	(* Data points used for the fit, with units *)
	standardCurveDataPoints=Lookup[safePacket,StandardDataPoints];

	(* Extract the pure unit-less function *)
	dimensionlessFitFunction=If[MatchQ[Head[standardCurveFitFunction],QuantityFunction],
		First[standardCurveFitFunction],
		standardCurveFitFunction
	];

	(* Get the default blue color for plotting *)
	defaultBlue=ColorData[97,"ColorList"][[1]];

	(* Get the input data point values from object packet *)
	rawInputData=Lookup[safePacket,InputDataPoints];

	(* Do not show any Input Data in the plot, if rawInputData is null or fake value*)
	If[MatchQ[rawInputData, {}]||SameQ[rawInputData, {0.017}],
		outputNoInputData = generateOutputWithoutInputData[
			safePacket,safeOptions,originalOps,dimensionlessFitFunction,defaultBlue,standardCurveDataPoints
		];
		Return[outputNoInputData]
	];

	(* Wrap input data in a list if there is only one input dataset *)
	myInputData=If[MatchQ[First[rawInputData],_List],
		rawInputData,
		{rawInputData}
	];

	(* Get the units of input data *)
	myInputDataUnits=Lookup[safePacket,InputDataUnits];

	(* Resolve the input unit for plotting *)
	resolvedInputUnit=Which[
		(* If the standard X unit is defined and we are not inverting, use that *)
		(!inverseQ)&&MatchQ[standardXUnit,Except[1]],standardXUnit,

		(* If the standard Y unit is defined and we are inverting, use that *)
		inverseQ&&MatchQ[standardYUnit,Except[1]],standardYUnit,

		(* Otherwise use the Input Data Unit*)
		MatchQ[myInputDataUnits,Except[1]],myInputDataUnits,

		(* If both standard and input data have dimensionless X, the resolved unit is dimensionless*)
		True,1
	];

	(* If the Input Data is unitless, convert its units to the standard curve units *)
	unitCorrectedInputData=Map[
		Which[
			(* Input data is dimensionless distributions *)
			MatchQ[#,{DistributionP[]..}]&&MatchQ[Units[Mean/@#],{1..}],
			Map[Function[{x},QuantityDistribution[x,resolvedInputUnit]],#],

			(* Input data is dimensionless numbers *)
			MatchQ[Units[#],{1..}],
			QuantityArray[#,resolvedInputUnit],

			(* Input data has units already *)
			True,#
		]&,
		myInputData
	];

	(* True if standard data dimension associated with inputs has no units *)
	unitlessStandardDataQ=If[inverseQ,
		MatchQ[standardYUnit,1]&&MatchQ[myInputDataUnits,Except[1]],
		MatchQ[standardXUnit,1]&&MatchQ[myInputDataUnits,Except[1]]
	];

	(* If the Standard data has unitless X data but input data has units, apply these units to the standard curve *)
	resolvedStandardDataPoints=Which[
		(* Standard Y data needs units applied AND is a list of distributions *)
		MatchQ[standardCurveDataPoints,{{DistributionP[],_}..}|_?QuantityMatrixQ]&&unitlessStandardDataQ&&inverseQ,
		{First[#],QuantityDistribution[Last[#],resolvedInputUnit]}&/@standardCurveDataPoints,

		(* Standard X data needs units applied AND is a list of distributions *)
		MatchQ[standardCurveDataPoints,{{DistributionP[],_}..}|_?QuantityMatrixQ]&&unitlessStandardDataQ&&(!inverseQ),
		{QuantityDistribution[First[#],resolvedInputUnit],Last[#]}&/@standardCurveDataPoints,

		(* Standard X data needs units applied and is not a list of distributions *)
		unitlessStandardDataQ&&(!inverseQ),
		{First[#]*resolvedInputUnit,Last[#]}&/@standardCurveDataPoints,

		(* Standard Y data needs units applied and is not a list of distributions *)
		unitlessStandardDataQ&&inverseQ,
		{First[#],Last[#]*resolvedInputUnit}&/@standardCurveDataPoints,

		(* Otherwise, use the standard data points directly *)
		True,
		standardCurveDataPoints
	];

	(* Get the corresponding predicted values from applying the standard curve *)
	rawPredictedValues=safePacket[PredictedValues];

	(* Wrap predited values in a list if there was only one input dataset *)
	myPredictedValues=If[MatchQ[First[rawPredictedValues],_List],
		rawPredictedValues,
		{rawPredictedValues}
	];

	(* Create a list of xy data using input data and predicted values from applying standard curve *)
	inputXYData=If[inverseQ,
	MapThread[
		Transpose@{#1,#2}&,
			{myPredictedValues,unitCorrectedInputData}
		],
		MapThread[
			Transpose@{#1,#2}&,
			{unitCorrectedInputData,myPredictedValues}
		]
	];

	(* Get the minimum and maximum values in the input data *)
	{inputXMin,inputXMax}=If[inverseQ,
		MinMax[QuantityMagnitude[safeMean/@Flatten[myPredictedValues]]],
		MinMax[QuantityMagnitude[safeMean/@Flatten[unitCorrectedInputData]]]
	];

	(* Get the minimum and maximum x value of the standard data *)
	{standardXMin,standardXMax}=QuantityMagnitude[Lookup[safePacket,StandardCurveDomain]];

	(* Get the difference between standard min and max *)
	standardXDifference=standardXMax-standardXMin;

	(* If PlotRange is Automatic, calculate a plot range for the x-variable for which both all data points and the entire standard curve will be shown *)
	resolvedPlotRange=If[Lookup[safeOptions,PlotRange]===Automatic,
		{
			{
				Min[inputXMin-0.05*standardXDifference,standardXMin-0.15*standardXDifference],
				Max[inputXMax+0.05*standardXDifference,standardXMax+0.15*standardXDifference]
			},
			Automatic
		},
		Lookup[safeOptions,PlotRange]
	];

	(* Generate legend entries for the plot *)
	inputDataLabels=Table[Style["Input Dataset "<>ToString[i],14],{i,1,Length[inputXYData]}];

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[originalOps,op],_Missing],
		Rule[op,default],
		Rule[op,Lookup[originalOps,op]]
	];

	(* Override unspecified input options with standard-curve specific formatting *)
	plotOptions=ReplaceRule[safeOptions,
		{
			setDefaultOption[Joined,False],
			setDefaultOption[Legend,Prepend[inputDataLabels,Style["Standard Curve",14]]],
			setDefaultOption[LegendPlacement,Right],
			setDefaultOption[PlotRange,resolvedPlotRange]
		}
	];

	(* Generate a plot of the input data. Prepend Null to save color for standard curve. *)
	{inputDataPlot,resolvedOps}=EmeraldListLinePlot[Prepend[inputXYData,resolvedStandardDataPoints],
		ReplaceRule[plotOptions,{Output->{Result,Options}}]
	];

	(* Create a graphic for the standard curve *)
	standardCurvePlot=Plot[
		{
			Piecewise[{{dimensionlessFitFunction[x],x>standardXMin&&x<standardXMax}},None],
			Piecewise[{{dimensionlessFitFunction[x],x<standardXMin}},None],
			Piecewise[{{dimensionlessFitFunction[x],x>standardXMax}},None]
		},
		{x,Sequence@@First[resolvedPlotRange]},
		PlotStyle->{defaultBlue,{defaultBlue,Dotted},{defaultBlue,Dotted}}
	];

	(* Create the result plot *)
	plotResult=Show[Unzoomable[inputDataPlot],standardCurvePlot];

	(* Resolve the legend option manually *)
	finalResolvedOps=ReplaceRule[
		resolvedOps,
		If[MemberQ[originalOps,Legend->_],
			{Legend->Lookup[originalOps,Legend]},
			{Legend->Prepend[inputDataLabels,Style["Standard Curve",14]]}
		]
	];

	(* Return the requested output *)
	output/.{
		Result->plotResult,
		(* Unfortunate workaround for aspect ratio bug with legended graphics in the builder preview *)
		Preview->Framed[
			Pane[Framed[plotResult,FrameStyle->White],ImageSize->{800,Full},Alignment->{Center,Automatic},ImageSizeAction->"ResizeToFit"],
			FrameStyle->White
		],
		Options->finalResolvedOps,
		Tests->{}
	}
];

(* Generate output figure without plotting the inputData*)
generateOutputWithoutInputData[
	safePacket_, safeOptions_, originalOps_,dimensionlessFitFunction_,defaultBlue_,standardCurveDataPoints_
]:=Module[{
	standardXMin,standardXMax,standardXDifference,resolvedPlotRange,plotOptions,standardCurvePlot,inputDataPlot,
	resolvedStandardDataPoints,plotResult,finalResolvedOps,output
},

	(* Get the minimum and maximum x value of the standard data *)
	{standardXMin,standardXMax}=QuantityMagnitude[Lookup[safePacket,StandardCurveDomain]];

	(* Get the difference between standard min and max *)
	standardXDifference=standardXMax-standardXMin;

	(* If PlotRange is Automatic, calculate a plot range for the x-variable for which both all data points and the entire standard curve will be shown *)
	resolvedPlotRange=If[Lookup[safeOptions,PlotRange]===Automatic,
		{
			{
				standardXMin-0.15*standardXDifference,
				standardXMax+0.15*standardXDifference
			},
			Automatic
		},
		Lookup[safeOptions,PlotRange]
	];

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[originalOps,op],_Missing],
		Rule[op,default],
		Rule[op,Lookup[originalOps,op]]
	];

	(* Override unspecified input options with standard-curve specific formatting *)
	plotOptions=ReplaceRule[safeOptions,
		{
			setDefaultOption[Joined,False],
			setDefaultOption[Legend,Style["Standard Curve",14]],
			setDefaultOption[LegendPlacement,Right],
			setDefaultOption[PlotRange,resolvedPlotRange]
		}
	];
	resolvedStandardDataPoints = standardCurveDataPoints;
	(* Generate a plot of the input data. Prepend Null to save color for standard curve. *)
	{inputDataPlot,resolvedOps}=EmeraldListLinePlot[resolvedStandardDataPoints,
		ReplaceRule[plotOptions,{Output->{Result,Options}}]
	];

	(* Create a graphic for the standard curve *)
	standardCurvePlot=Plot[
		{
			Piecewise[{{dimensionlessFitFunction[x],x>standardXMin&&x<standardXMax}},None],
			Piecewise[{{dimensionlessFitFunction[x],x<standardXMin}},None],
			Piecewise[{{dimensionlessFitFunction[x],x>standardXMax}},None]
		},
		{x,Sequence@@First[resolvedPlotRange]},
		PlotStyle->{defaultBlue,{defaultBlue,Dotted},{defaultBlue,Dotted}}
	];

	(* Create the result plot *)
	plotResult=Show[Unzoomable[inputDataPlot],standardCurvePlot];

	(* Resolve the legend option manually *)
	finalResolvedOps=ReplaceRule[
		resolvedOps,
		If[MemberQ[originalOps,Legend->_],
			{Legend->Lookup[originalOps,Legend]},
			{Legend->Style["Standard Curve",14]}
		]
	];

	output=Lookup[safeOptions,Output];
	(* Return the requested output *)
	output/.{
		Result->plotResult,
		(* Unfortunate workaround for aspect ratio bug with legended graphics in the builder preview *)
		Preview->Framed[
			Pane[Framed[plotResult,FrameStyle->White],ImageSize->{800,Full},Alignment->{Center,Automatic},ImageSizeAction->"ResizeToFit"],
			FrameStyle->White
		],
		Options->finalResolvedOps,
		Tests->{}
	}

];


(* Listable Overload *)
PlotStandardCurve[myPackets:{PacketP[Object[Analysis,StandardCurve]]},myOptions:OptionsPattern[PlotStandardCurve]]:=PlotStandardCurve[First[myPackets],myOptions];
PlotStandardCurve[myPackets:{PacketP[Object[Analysis,StandardCurve]]..},myOptions:OptionsPattern[PlotStandardCurve]]:=Module[
	{safeOptions,output,listedOutputs,results,previews,resOps},

	(* Convert options to a list *)
	safeOptions=SafeOptions[PlotStandardCurve,ToList[myOptions]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOptions,Output];

	(* Collect results, previews, and options from each mapped call *)
	{results,previews,resOps}=Transpose@Map[
		PlotStandardCurve[#,ReplaceRule[ToList[myOptions],{Output->{Result,Preview,Options}}]]&,
		myPackets
	];

	(* Return the selected outputs *)
	output/.{
		Result->results,
		Preview->SlideView[previews],
		Options->First[resOps],
		Tests->{}
	}
];

(* Object Type Overloads *)
PlotStandardCurve[myObject: ObjectP[Object[Analysis,StandardCurve]]|ObjectReferenceP[Object[Analysis,StandardCurve]]|LinkP[Object[Analysis,StandardCurve]],myOptions: OptionsPattern[]]:=PlotStandardCurve[Download[myObject],myOptions];
PlotStandardCurve[myObjects: {ObjectP[Object[Analysis,StandardCurve]]...},myOptions: OptionsPattern[PlotStandardCurve]]:=PlotStandardCurve[Download[myObjects],myOptions];
PlotStandardCurve[myObjects: {ObjectReferenceP[Object[Analysis,StandardCurve]]...},myOptions: OptionsPattern[PlotStandardCurve]]:=PlotStandardCurve[Download[myObjects],myOptions];
PlotStandardCurve[myObjects: {LinkP[Object[Analysis,StandardCurve]]...},myOptions: OptionsPattern[PlotStandardCurve]]:=PlotStandardCurve[Download[myObjects],myOptions];
