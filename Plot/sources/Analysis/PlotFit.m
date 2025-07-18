(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Safety Overloads for Analysis/Plot context dependency *)
outlierPositions=Analysis`Private`outlierPositions;
computeFitError=Analysis`Private`computeFitError;


(* ::Subsection:: *)
(*PlotFit*)


DefineOptions[PlotFit,
	Options :> {
		{
			OptionName -> PlotStyle,
			Default -> Fit,
			Description -> "Style of plot to show.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Fit,Error]],
			Category->"Plot Fit"
		},
		{
			OptionName -> Display,
			Default -> {Fit, Error, Outliers, Exclude, Quantile},
			Description -> "Elements to display on the plot.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Single Element"->Widget[Type->Enumeration, Pattern:>Alternatives[Fit,Error,Outliers,Exclude,Quantile,ConfidenceBands,PredictionBands,DataError]],
				"Multiple Elements"->Adder[Widget[Type->Enumeration, Pattern:>Alternatives[Fit,Error,Outliers,Exclude,Quantile,ConfidenceBands,PredictionBands,DataError]]],
				"Other"->Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
			],
			Category->"Plot Fit"
		},
		{
			OptionName -> Exclude,
			Default -> None,
			Description -> "Points to color as excluded.",
			AllowNull -> False,
			Widget -> Alternatives[
				"List of Points"->Widget[Type->Expression, Pattern:>(_?MatrixQ | {_Integer?Positive..}), Size->Paragraph],
				"No Exclusions"->Widget[Type->Enumeration, Pattern:>Alternatives[None,Null,{}]]
			],
			Category->"Plot Fit"
		},
		{
			OptionName -> Outliers,
			Default -> Automatic,
			Description -> "Points to color as outliers.",
			ResolutionDescription -> "Automatic uses both HatDiagonal and IQR methods to identify outliers.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				"List of Points"->Widget[Type->Expression, Pattern:>(_?MatrixQ | {_Integer?Positive..}), Size->Paragraph],
				"No Outliers"->Widget[Type->Enumeration, Pattern:>Alternatives[None,Null,{}]]
			],
			Category->"Outliers"
		},
		{
			OptionName -> OutlierDistance,
			Default -> 1.5,
			Description -> "Coefficient of interquartile range of the fit residuals to be used for computing outliers. A point will be considered an outlier if its residual is less that the Q1 - OutlierDistance*IQR, or greater than Q3 + OutlierDistance*IQR.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]],
				Widget[Type->Enumeration, Pattern:>Alternatives[Infinity]]
			],
			Category->"Outliers"
		},
		{
			OptionName -> HatDiagonal,
			Default -> Null,
			Description -> "Influence matrix for the fit, to be used for computing outliers.",
			AllowNull -> True,
			Widget->Widget[Type->Expression, Pattern:>_List, Size->Paragraph],
			Category->"Hidden"
		},
		{
			OptionName -> ConfidenceLevel,
			Default -> 0.95,
			Description -> "Confidence level(s) used to compute confidence bands.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Single"->Widget[Type->Number, Pattern:>RangeP[0,1]],
				"Multiple"->Adder[Widget[Type->Number, Pattern:>RangeP[0,1]]]
			],
			Category->"Error Bands"
		},
		{
			OptionName -> ErrorBandFilling,
			Default -> False,
			Description -> "If True, fills error bands on plot.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Category->"Error Bands"
		},
		{
			OptionName -> SamplePoints,
			Default -> 10,
			Description -> "Determines x-values of error bars shown. If Integer, they are evenly distributed across domain.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Single"->Widget[Type->Number, Pattern:>GreaterEqualP[0,1]],
				"Multiple"->Adder[Widget[Type->Number, Pattern:>GreaterEqualP[0,1]]]
			],
			Category->"Error Bands"
		},
		{
			OptionName -> StandardDeviation,
			Default -> Automatic,
			Description -> "Standard deviation of the fit.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Expression, Pattern:>(_?NumericQ | _Function), Size->Line]
			],
			Category->"Error Bands"
		},
		{
			OptionName -> DegreesOfFreedom,
			Default -> Automatic,
			Description -> "Degrees of freedom of the fit.  Used to calculate error bands.",
			AllowNull -> False,
			Widget -> Widget[Type->Number,Pattern:>GreaterEqualP[0]],
			Category->"Error Bands"
		},
		{
			OptionName -> MeanPredictionError,
			Default -> Null,
			Description -> "Function defining mean prediction error for the fit.",
			AllowNull -> True,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Paragraph],
			Category->"Hidden"
		},
		{
			OptionName -> SinglePredictionError,
			Default -> Null,
			Description -> "Function defining single prediction error for the fit.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:>_, Size->Paragraph],
			Category->"Hidden"
		},
		{
			OptionName -> Legend,
			Default -> False,
			Description -> "Legend specification for the plot.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False,Automatic]],
			Category->"Legend"
		},
		ListPlotOptions,
		{
			OptionName -> PointSize,
			Default -> Automatic,
			Description -> "Size of plot points and markers.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type->Number, Pattern:>GreaterEqualP[0]],
				Widget[Type->Enumeration, Pattern:>Alternatives[Small,Medium,Large,Automatic]]
			],
			Category->"Plot Style"
		},
		{
			OptionName->InterpolationOrder,
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				Widget[Type->Number,Pattern:>GreaterEqualP[0]]
			],
			Description->"Specifies the order of interpolation to use when the points of the dataset are joined together.",
			Category->"Hidden"
		},
		{
			OptionName->Joined,
			Default->False,
			AllowNull->False,
			Widget->Alternatives[
				"All Datasets"->Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic,BooleanP]],
				"Each Dataset"->Adder[Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic,BooleanP]]]
			],
			Description->"Specifies whether points in each dataset should be joined into a line, or should be plotted as separate points.",
			Category->"Hidden"
		},
		{
			OptionName -> PlotType,
			Default -> Linear,
			Description -> "Type of axes to use on the plot.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Linear,LinearLog,LogLinear,Log]],
			Category->"Data Specifications"
		},
		OutputOption
	}
];

(*** Patterns ***)
analyzeFitObjectInputP = Alternatives[
	{{(ObjectP[]|FieldReferenceP[]|UnitsP[])..}..},
	{(ObjectP[]|FieldReferenceP[]|{ObjectP[]..}|{FieldReferenceP[]..}|{UnitsP[]..})..}
];
analyzeFitDataP = Alternatives[DataPointsP, analyzeFitObjectInputP];

(*** Messages ***)
Error::NoPlotAvailabe="No plot available for the given PlotStyle and data dimension. Please make sure the input data dimension is 2 or 3.";


PlotFit[xyIn:(_?QuantityMatrixQ|UnitCoordinatesP[]),uf:QuantityFunction[f_,inputUnits_,outputUnit_],opts:OptionsPattern[]]:=Module[{xy},
	xy = Convert[xyIn,Append[inputUnits,outputUnit]];
	PlotFit[xy,f,opts]
];

PlotFit[xyIn:analyzeFitDataP,f:FunctionP,opts:OptionsPattern[]]:=Module[{
		listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,
		resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,outputPlot,
		dy,xdy,plotStyle,plotType,safeOps,inputUnits,outputUnit,dataUnits,outputPlotForOptions,
		xyMeansQ,xStdDevs,yStdDevs,badPos,xy,finalResolvedOps,optionsRule,previewRule,testsRule,resultRule,blackOptionList
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[opts];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		{SafeOptions[PlotFit,listedOptions,AutoCorrect->False],{}},
		{SafeOptions[PlotFit,listedOptions,AutoCorrect->False],Null}
	];


	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];


	(* Call resolve<Function>Options *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{outputPlot, resolvedOptions,resolvedOptionsTests}= If[gatherTests,
			resolvePlotFitOptions[xyIn,f,safeOptions,Output->{Result,Tests}],
			resolvePlotFitOptions[xyIn,f,safeOptions]
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Return early if the option resolution failed *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[
			outputSpecification/.{
				Result->$Failed,
				Preview->Null,
				Options->$Failed,
				Tests->{}
			}
		]
	];

	(*The list of options are not used in new Zoomable, thus will generate error.
	TODO: this is not a complete list yet
	*)
	blackOptionList = {ClippingStyle, ColorFunction, ColorFunctionScaling, DataRange, Filling, FillingStyle,
		InterpolationOrder, IntervalMarkers, IntervalMarkersStyle, Joined, LabelingFunction, LabelingSize, MaxPlotPoints,
		Mesh};
	(* Ugly workaround for a weird bug in PlotStyle->Error *)
	outputPlotForOptions=If[MatchQ[Lookup[resolvedOptions,PlotStyle],Error]&&Head[outputPlot]=!=Legended,
		Graphics[First[outputPlot],
			Sequence@@FilterRules[List@@Rest[outputPlot],
				ToExpression/@First/@Options[Graphics]
			]
		],
		outputPlot
	];

	(*TODO: filter out unused options when $CCD is True*)
	(*
		outputPlot = If[$CCD,
		Graphics[First[outputPlot],
		Apply[Sequence,
			KeyDrop[
				List@@Rest[outputPlot], blackOptionList
			]/.Association->List
		]],
		outputPlot
	];
	*)


	(*outputPlotForOptions = KeyDrop[outputPlotForOptions, blackOptionList]/.Association->List;*)
	(* Resolve any options which require us to peek at the final graphic *)
	finalResolvedOps=Quiet[
		resolvedPlotOptions[outputPlotForOptions,resolvedOptions,ListLinePlot],
		(* Absolute Options is bugged, remove this quiet once WRI has fixed it *)
		{Axes::axes,Graphics3D::optx,Graphics::optx}
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		If[MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
			Block[{$CCD=False}, Zoomable[Show[outputPlot]]]
		],
		Null
	];

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[PlotFit,finalResolvedOps],
		Null
	];


	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Join[safeOptionTests,resolvedOptionsTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
			outputPlotForOptions
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}

];




(* SLL Object *)
PlotFit[in:(ObjectReferenceP[Object[Analysis,Fit]]|LinkP[Object[Analysis,Fit]]),ops:OptionsPattern[]]:=
    PlotFit[Download[in],ops];

(* SLL Packet *)
PlotFit[inf0:PacketP[Object[Analysis, Fit]],ops:OptionsPattern[]]:=Module[
	{inf,xy,extraOps},
	inf = Analysis`Private`stripAppendReplaceKeyHeads[inf0];
	xy = DataPoints/.inf;

	extraOps = {
		DegreesOfFreedom->(Length[xy]-Length[Lookup[inf,BestFitParameters]]),
		TargetUnits -> Replace[Lookup[inf,DataUnits],{}->{1,1}]
	};

	PlotFit[xy,BestFitFunction/.inf,PassOptions[PlotFit,PlotFit,Join[{ops},extraOps,Normal[inf]]]]
];


PlotFit[obj:ObjectP[Object[Analysis, Fit]], Automatic, ops:OptionsPattern[]]:= PlotFit[obj, ops];


PlotFit[objs:{ObjectP[Object[Analysis, Fit]]..}, ops:OptionsPattern[]]:= Show[PlotFit[#, ops]&/@objs];


(* ::Subsubsection:: *)
(*resolvePlotFitOptions*)


DefineOptions[resolvePlotFitOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];


resolvePlotFitOptions[xyIn_, f_, myOptions_List, ops:OptionsPattern[]]:= Module[
	{output,listedOutput,collectTestsBoolean,messagesBoolean,plotStyle,plotType,xyMeansQ,xStdDevs,yStdDevs,dataDimension,
	dataUnits, xy,outputUnit,inputUnits,badPos,dy,xdy,dataDimensionDescription,dataDimensionTest,resolvedOptions, outputPlot,allTests},

	(* From resolvePlotFitOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

	{plotStyle,plotType}={PlotStyle,PlotType}/.myOptions;

	(* ---------- data processing ----------- *)
	{xyMeansQ,xStdDevs,yStdDevs} = Analysis`Private`resolveDistributionInputs[xyIn];
	{dataUnits, xy} = Analysis`Private`unitsAndMagnitudes[xyMeansQ];
	outputUnit = Last[dataUnits];
	inputUnits = dataUnits[[1;;-2]];

	(* filter out negative pts if doing log plot *)
	badPos=Switch[plotType,
		Linear,
			{},
		LinearLog,
			Position[xy,{_,_?NonPositive},1],
		LogLinear,
			Position[xy,{_?NonPositive,_},1],
		Log,
			Position[xy,{_?NonPositive,_}|{_,_?NonPositive},1]
	];

	xy = Delete[xy,badPos];
	xStdDevs = Delete[xStdDevs,badPos];
	yStdDevs = Delete[yStdDevs,badPos];

	(* check the input data dimension *)
	dataDimension = Length[First[xy]];
	dataDimensionDescription = Error::NoPlotAvailabe;
	dataDimensionTest = testOrNullPlotFit[PlotStyle, collectTestsBoolean, dataDimensionDescription, MatchQ[dataDimension, 2|3]];

	(* compute dy data *)
	dy=xy[[;;,-1]]-(f@@@xy[[;;,1;;-2]]);
	xdy=MapThread[Append[#1,#2]&,{xy[[;;,1;;-2]],dy}];

	{outputPlot, resolvedOptions} = Switch[plotStyle,
		Fit,
			Switch[dataDimension,
				2, plotFitFit[xy,xdy,xStdDevs,yStdDevs,f,myOptions],
				3, plotFitFit3D[xy,xdy,xStdDevs,yStdDevs,f,myOptions],
				_, {Null, Null}
			],
		Error,
			Switch[dataDimension,
				2, plotFitError[xy,xdy,f,myOptions],
				3, plotFitError3D[xy,xdy,f,myOptions],
				_, {Null, Null}
			]
	];

	allTests= {dataDimensionTest};

	{outputPlot, resolvedOptions, allTests}
];


testOrNullPlotFit[option_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	(* if tests are not requested to be returned, throw an error when fail *)
	If[expression,
		Null,

		Message[Error::NoPlotAvailabe];
		Message[Error::InvalidOption,option]
	]
];


(* ::Subsubsection::Closed:: *)
(*plotFitFit*)


plotFitFit[
	xyQ_,
	xdy_,
	xStdDevs_,
	yStdDevs_,
	f:FunctionP,
	resolvedOps_List
]:=Module[{
		pointSize,xsize,excludePoints,outlierPoints,plotFcn,listPlotFcn,cls,tvals,df,cl,xy,legendBool,units,
		excludePlot,outlierPlot,bars,dataPointPlot,curvePlot,pointErrors,confidenceBands,predictionBands,
		fillingBool, resolvedFrameLabel, finalResolvedOps, plotRange
	},

	xy=QuantityMagnitude[xyQ];
	legendBool = MatchQ[Lookup[resolvedOps,Legend],True|Automatic];
	fillingBool = MatchQ[Lookup[resolvedOps,ErrorBandFilling],True];
	(* ------- resolve options ----------- *)
	{cl,df}=Lookup[resolvedOps,{ConfidenceLevel,DegreesOfFreedom}];
	cls = ToList[Unitless[cl,1]];
	tvals= Quiet[Map[HypothesisTesting`StudentTCI[0,1,df,ConfidenceLevel->#]&,cls],{StudentTDistribution::posprm}];
	units = Replace[Lookup[resolvedOps,TargetUnits],thing:Except[_List]:>Table[thing,{Length[First[xyQ]]}]]/.{Null->1,Automatic->1};

	{pointSize,xsize}=resolvePointSize[Lookup[resolvedOps,PointSize],xy];

	excludePoints=resolveExcludeList[Lookup[resolvedOps,Exclude],xy,xy];

	outlierPoints = Quiet[resolveOutlierList[Lookup[resolvedOps,Outliers],xy,xy,excludePoints,xdy,{Method -> Both, ExtractRule[resolvedOps,OutlierDistance], ExtractRule[resolvedOps,HatDiagonal]}]];

	listPlotFcn = resolveListPlotFunction[Lookup[resolvedOps,PlotType]];

	plotFcn = resolvePlotFunction[Lookup[resolvedOps,PlotType]];

	(* ---------- make plots & graphics ---------- *)

	excludePlot = If[MemberQ[Lookup[resolvedOps,Display],Exclude],
		listPlotFcn[safeLegended[excludePoints,"Excluded Points",legendBool],PlotStyle->Red,PlotMarkers->{"\[Times]",xsize}],
		{}
	];

	outlierPlot=If[MemberQ[Lookup[resolvedOps,Display],Outliers],
		listPlotFcn[safeLegended[outlierPoints,"Outlier Points",legendBool],PlotStyle->{Red,PointSize[pointSize]}],
		{}
	];

	bars = If[MemberQ[Lookup[resolvedOps,Display],Error],
		drawErrorBars[f,Lookup[resolvedOps,StandardDeviation],xy,excludePoints,Lookup[resolvedOps,SamplePoints],Lookup[resolvedOps,PlotType]],
		{}
	];

	pointErrors = If[MemberQ[Lookup[resolvedOps,Display],DataError],
		drawPointErrors[xy,excludePoints,outlierPoints,xStdDevs[[;;,1]],yStdDevs,MemberQ[Lookup[resolvedOps,Display],Outliers]]/.{x_Quantity:>Unitless[x]},
		{}
	];

	(* need this for all the curves *)
	plotRange = resolvePlotRange[Lookup[resolvedOps,PlotRange],xy,units,{}];

	confidenceBands = If[MemberQ[Lookup[resolvedOps,Display],ConfidenceBands],
		With[
			{
				styles = Map[Directive[Dashed,#]&,ColorFade[Purple,Length[tvals]]],
				legends = Map[ToString[#*100]<>"% Mean Confidence Bands"&,cls]
			},
			drawErrorBands[f,Lookup[resolvedOps,MeanPredictionError],xy,tvals,styles,legends,legendBool,fillingBool,plotRange]
		],
		{}
	];

	predictionBands = If[MemberQ[Lookup[resolvedOps,Display],PredictionBands],
		With[
			{
				styles = Map[Directive[DotDashed,#]&,ColorFade[Orange,Length[tvals]]],
				legends = Map[ToString[#*100]<>"% Prexdiction Bands"&,cls]
			},
			drawErrorBands[f,Lookup[resolvedOps,SinglePredictionError],xy,tvals,styles,legends,legendBool,fillingBool,plotRange]
		],
		{}
	];

	curvePlot = If[True,(*MemberQ[Lookup[resolvedOps,Display],Fit],*)
		drawFittedCurvePlot[f,xy,{PlotStyle->{Blue,Thick}},Lookup[resolvedOps,PlotType],plotFcn,listPlotFcn,legendBool,plotRange],
		{}
	];

	dataPointPlot = drawDataPointPlot[xy,excludePoints,outlierPoints,pointSize,listPlotFcn,legendBool,PassOptions[PlotFit,listPlotFcn,resolvedOps]];

	(* get the resolved option list *)
	resolvedFrameLabel = resolveFrameLabel[Lookup[resolvedOps,FrameLabel],units,units,Null,Null];

	finalResolvedOps = ReplaceRule[resolvedOps, {PlotRange->plotRange, Outliers->outlierPoints, PointSize->pointSize, TargetUnits->units, FrameLabel->resolvedFrameLabel}];


	(* ---------- put it all together ---------- *)
{
	Show[
		dataPointPlot,
		outlierPlot,
		excludePlot,
		curvePlot,
		confidenceBands,
		predictionBands,
		Epilog->{bars,pointErrors},
		PlotRange->plotRange,
		FrameLabel->resolvedFrameLabel,
		PassOptions[PlotFit,Graphics,resolvedOps]
	],
	finalResolvedOps
}


];



(* ::Subsubsection::Closed:: *)
(*plotFitFit3D*)


plotFitFit3D[
	xyzQ_,
	xydz_,
	xStdDevs_,
	yStdDevs_,
	f:FunctionP,
	resolvedOps_List
]:=Module[{
	pointSize,xsize,excludePoints,outlierPoints,plotFcn,listPlotFcn,cl,df,xyz,legendBool,units,xmin,xmax,ymin,ymax,
	excludePlot,outlierPlot,bars,dataPointPlot,curvePlot,pointErrors,confidenceBands,predictionBands,
	mainStyle,outlierStyle,excludeStyle,mainPts,resolvedFrameLabel,finalResolvedOps},

	xyz=QuantityMagnitude[xyzQ];
	legendBool = MatchQ[Lookup[resolvedOps,Legend],True|Automatic];
	(* ------- resolve options ----------- *)
	units = Replace[Lookup[resolvedOps,TargetUnits],thing:Except[_List]:>Table[thing,{Length[First[xyzQ]]}]]/.{Null->1,Automatic->1};

	excludePoints=resolveExcludeList[Lookup[resolvedOps,Exclude],xyz,xyz];
	outlierPoints=Lookup[resolvedOps,Outliers];

	{xmin,xmax}=MinMax[xyz[[;;,1]]];
	{ymin,ymax}=MinMax[xyz[[;;,2]]];

	{pointSize,xsize}=resolvePointSize[Lookup[resolvedOps,PointSize],xyz];

	(* ---------- make plots & graphics ---------- *)

	(* need to mark these with x or something, but doesn't seem possible *)
(*	excludePlot = ListPointPlot3D[excludePoints,PlotStyle->Red];*)

	curvePlot = Plot3D[f[x,y],{x,xmin,xmax},{y,ymin,ymax},PlotStyle->{Opacity[0.5]},PlotRange->All];

	{mainPts,mainStyle} = {Complement[xyz,outlierPoints,excludePoints],Directive[PointSize[pointSize],Darker[Darker[Green]]]};
	{outlierPoints,outlierStyle} = If[And[!MatchQ[outlierPoints,{}|{{Null..}}],MemberQ[Lookup[resolvedOps,Display],Outliers]],{outlierPoints,Directive[PointSize[pointSize],Red]},{Null,Null}];
	{excludePoints,excludeStyle} = If[And[!MatchQ[excludePoints,{}|{{Null..}}],MemberQ[Lookup[resolvedOps,Display],Exclude]],{excludePoints,Directive[PointSize[pointSize],Red]},{Null,Null}];
	dataPointPlot = ListPointPlot3D[DeleteCases[{mainPts,outlierPoints,excludePoints},Null],PlotStyle->DeleteCases[{mainStyle,outlierStyle,excludeStyle},Null]];

	(* get the resolved option list *)
	resolvedFrameLabel = resolveFrameLabel[Lookup[resolvedOps,FrameLabel],units,units,Null,Null];

	finalResolvedOps = ReplaceRule[resolvedOps, {Outliers->outlierPoints, PointSize->pointSize, TargetUnits->units, FrameLabel->resolvedFrameLabel}];

	(* ---------- put it all together ---------- *)
{
	Show[
		dataPointPlot,
	(*	outlierPlot,*)
(*		excludePlot,*)
		curvePlot,
(*
		confidenceBands,
		predictionBands,
		Epilog->{bars,pointErrors},
*)
		PlotRange->All,
		FrameLabel -> resolvedFrameLabel,
		PassOptions[PlotFit,Show,resolvedOps]
	],
	finalResolvedOps
}

];



(* ::Subsubsection::Closed:: *)
(*plotFitError*)


plotFitError[
	xyQ_,
	xdy_,
	f:FunctionP,
	resolvedOps_List
]:=Module[{
	pointSize,xsize,excludePoints,outlierPoints,plotFcn,listPlotFcn,xy,units,resolvedFrameLabel,finalResolvedOps,
	excludePlot,outlierPlot,quantileLines,errorPointPlot},

	xy=QuantityMagnitude[xyQ];
	(* ------- resolve options ----------- *)

	{pointSize,xsize}=resolvePointSize[Lookup[resolvedOps,PointSize],xdy];

	excludePoints=resolveExcludeList[Lookup[resolvedOps,Exclude],xdy,xy];

	outlierPoints = Quiet[resolveOutlierList[Lookup[resolvedOps,Outliers],xdy,xy,excludePoints,xdy,{Method -> Both, ExtractRule[resolvedOps,OutlierDistance], ExtractRule[resolvedOps,HatDiagonal]}]];

	listPlotFcn = resolveListPlotFunction[Lookup[resolvedOps,PlotType]];

	plotFcn = resolvePlotFunction[Lookup[resolvedOps,PlotType]];


	(* ---------- make plots & graphics ---------- *)

	excludePlot = If[MemberQ[Lookup[resolvedOps,Display],Exclude],
		listPlotFcn[excludePoints,PlotStyle->Red,PlotMarkers->{"\[Times]",xsize}],
		{}
	];

	outlierPlot = If[MemberQ[Lookup[resolvedOps,Display],Outliers],
		listPlotFcn[outlierPoints,PlotStyle->{Red,PointSize->pointSize}],
		{}
	];

	quantileLines = If[MemberQ[Lookup[resolvedOps,Display],Quantile],
		drawQuantileLines[xy,xdy,Lookup[resolvedOps,OutlierDistance]],
		{}
	];

	errorPointPlot = drawDataPointPlot[xdy,excludePoints,outlierPoints,pointSize,listPlotFcn,False,PassOptions[PlotFit,listPlotFcn,resolvedOps]];

	(* get the resolved option list *)
	units = Replace[Lookup[resolvedOps,TargetUnits],thing:Except[_List]:>Table[thing,{Length[First[xyQ]]}]]/.{Null->1,Automatic->1};
	resolvedFrameLabel = resolveFrameLabel[Lookup[resolvedOps,FrameLabel],units,units,Null,Null];

	finalResolvedOps = ReplaceRule[resolvedOps, {Outliers->outlierPoints, PointSize->pointSize, TargetUnits->units, FrameLabel->resolvedFrameLabel}];

	(* ---------- put it all together ---------- *)
{
	Show[
		errorPointPlot,
		outlierPlot,
		excludePlot,
		Epilog->quantileLines,
		PlotRange->Replace[Lookup[resolvedOps,PlotRange],Full->All],
		FrameLabel->resolvedFrameLabel,
		PassOptions[PlotFit,ListPlot,resolvedOps]
	],
	finalResolvedOps
}

];


(* ::Subsubsection::Closed:: *)
(*plotFitError3D*)


plotFitError3D[
	xyQ_,
	xdy_,
	f:FunctionP,
	resolvedOps_List
]:=Module[{
	pointSize,xsize,excludePoints,outlierPoints,plotFcn,listPlotFcn,xy,
	excludePlot,outlierPlot,quantileLines,errorPointPlot},

	xy=QuantityMagnitude[xyQ];
	(* ------- resolve options ----------- *)

	errorPointPlot = ListDensityPlot[xdy,PlotLegends->Automatic,LabelStyle->(LabelStyle/.Options[ListPlot]),PlotRange->All];

	(* ---------- put it all together ---------- *)
{
	Show[
		errorPointPlot
		(*PassOptions[PlotFit,ListDensityPlot,resolvedOps]*)
	],
	resolvedOps
}
];


(* ::Subsubsection::Closed:: *)
(*PlotFit helpers*)


safeLegended[arg_,label_,True]:=Legended[arg,label];
safeLegended[arg_,label_,_]:=arg;


resolvePlotFunction[Linear]:=Plot;
resolvePlotFunction[LogLinear]:=LogLinearPlot;
resolvePlotFunction[LinearLog]:=LogPlot;
resolvePlotFunction[Log]:=Log;


resolveListPlotFunction[Linear]:=ListPlot;
resolveListPlotFunction[LogLinear]:=ListLogLinearPlot;
resolveListPlotFunction[LinearLog]:=ListLogPlot;
resolveListPlotFunction[Log]:=ListLogLogPlot;


uniformPoints[xy_,numSamples_,plotType_]:=uniformPoints[Min[xy[[;;,1]]],Max[xy[[;;,1]]],numSamples,plotType];
uniformPoints[xmin_,xmax_,numSamples_,Linear|LinearLog]:=Range[xmin,xmax,(xmax-xmin)/(numSamples-1)];
uniformPoints[xmin_,xmax_,numSamples_,LogLinear|Log]:=10.^Range[N@Log10@xmin,N@Log10@xmax,N[Log10@(xmax/xmin)/(numSamples-1)]];


resolveExcludeList[excludeList:(Null|None|{}),pts_,xy_]:={Table[Null,{Length[First[xy]]}]};
resolveExcludeList[excludeList:{_Integer..},pts_,xy_]:=pts[[excludeList]];
resolveExcludeList[excludeList_?MatrixQ,pts_,xy_]:=(pts[[Flatten[Position[xy,#]&/@excludeList]]])/.({}->{Table[Null,{Length[First[xy]]}]});
resolveExcludeList[excludeList_,pts_,xy_]:={Table[Null,{Length[First[xy]]}]};


resolveOutlierList[outlierList_,pts_,xy_,excludePoints_,xdy_, ops0_]:=
	Replace[
		Complement[
			resolveOutlierListX[outlierList,pts,xy,excludePoints,xdy,ops0],
			excludePoints
		],
		{}->{Table[Null,{Length[First[xy]]}]}
	];
resolveOutlierListX[outlierList:(Null|None|{}),pts_,xy_,excludePoints_,xdy_,outlierOps_]:={};
resolveOutlierListX[outlierList:CoordinatesP,pts_,xy_,excludePoints_,xdy_,outlierOps_]:=pts[[Flatten[Position[xy,#]&/@outlierList]]];
resolveOutlierListX[outlierList:{_Integer..},pts_,xy_,excludePoints_,xdy_,outlierOps_]:=pts[[outlierList]];
resolveOutlierListX[outlierList:Automatic,pts_,xy_,excludePoints_,xdy_,outlierOps_]:=With[{outlierInds=Analysis`Private`outlierPositions[Cases[xdy[[;;,2]],NumericP],outlierOps]},pts[[outlierInds]]];


resolvePointSize[ps_,pts:{{_,_,__}..}]:={
		ps/.{Automatic->0.02,Small->0.01,Medium->0.02,Large->0.04},
		ps/.{Automatic->0.01,Small->9,Medium->12,Large->20}
	};
resolvePointSize[ps_,pts_]:=With[
	{
		mt=Analysis`Private`monotonicity[SortBy[pts,First]],
		n=Length[pts]
	},
	{
		ps/.{Automatic->automaticPointSize[n,0.0025,0.04,mt],Small->0.005,Medium->0.01,Large->0.02},
		ps/.{Automatic->automaticPointSize[n,8,25,mt],Small->9,Medium->12,Large->20}
	}
];



resolveErrorFunction[f_,errorFcn:Automatic,xy_,excludePoints_]:=With[{sign=computeFitError[f,Complement[xy,excludePoints]]},sign&];
resolveErrorFunction[f_,errorFcn_?NumericQ,xy_,excludePoints_]:=errorFcn&;
resolveErrorFunction[f_,errorFcn_Function,xy_,excludePoints_]:=errorFcn;
resolveErrorFunction[f_,errorFcn:None,xy_,excludePoints_]:=0&;


resolveSamplePoints[samplePoints_Integer,xy_,plotType_]:=uniformPoints[xy,samplePoints,plotType];
resolveSamplePoints[samplePoints:{_?NumericQ...},xy_,plotType_]:=samplePoints;


drawQuantileLines[xy_,xdy_,outlierDistance_]:=Module[{dy,xmin,xmax,ymin,ymax,q1,q2,q3},
	dy=xdy[[;;,2]];
	{{xmin,xmax},{ymin,ymax}} = CoordinateBounds[xy];
	{q1,q2,q3}=Quantile[dy,{0.25,0.5,0.75}];
	If[outlierDistance===Infinity,
		{Line[{{xmin,q2},{xmax,q2}}],{Dashed,Line[{{xmin,q1},{xmax,q1}}]},{Dashed,Line[{{xmin,q3},{xmax,q3}}]}},
		Module[{bot,top},
			{bot,top}={q1-outlierDistance*(q3-q1),q3+outlierDistance*(q3-q1)};
			{Line[{{xmin,q2},{xmax,q2}}],{Dashed,Line[{{xmin,q1},{xmax,q1}}]},{Dashed,Line[{{xmin,q3},{xmax,q3}}]},{Dotted,Line[{{xmin,bot},{xmax,bot}}]},{Dotted,Line[{{xmin,top},{xmax,top}}]}}
		]
	]
];



drawErrorBars[f_,errorFcn_,xy_,excludePoints_,samplePoints_,plotType_]:=Module[{xsample,ysample,sig,errorPoints},
	sig=resolveErrorFunction[f,errorFcn,xy,excludePoints];
	xsample = resolveSamplePoints[samplePoints,xy,plotType];
	ysample=f/@xsample;
	If[NumericQ[ysample],ysample=ConstantArray[ysample,Length[xsample]]];
	errorPoints=Cases[
		N@Table[{{xsample[[i]],ysample[[i]]},sig[xsample[[i]]]},{i,1,Length@xsample}],
		{{_Real,_Real},_}
	];

	ReplaceAll[
		ErrorBar[
			Cases[errorPoints,{{_?NumericQ,_?NumericQ},_?NumericQ}],
			PlotType->(plotType/.{Log->LogLog}),
			Ticks->0
		],
		l_Line:>{Blue,l}
	]
];


drawErrorBands[f_,fe:Null,xy_,style_,___]:={};
drawErrorBands[f_,fe:Null,___]:={};
drawErrorBands[f_Function,fe_QuantityFunction,rest___]:=	drawErrorBands[f,First[fe],rest];
drawErrorBands[f_Function,fe_Function,xy_,tvals_,style_,legends_,legendBool_,fillingBool_,plotRange_]:=Module[
	{x,fs,fsleg,fill,xmin,xmax},
	xmin = Replace[plotRange[[1,1]],Automatic->Min[xy[[;;,1]]]];
	xmax = Replace[plotRange[[1,2]],Automatic->Max[xy[[;;,1]]]];
	fs = Map[f[x]+#*fe[x]&,tvals];
	fsleg = Table[safeLegended[fs[[ix]],legends[[ix]],legendBool],{ix,1,Length[legends]}];
	fill = If[TrueQ[fillingBool]&&Length[tvals]>0,
		Join[{1->{2}},Table[ix+2->{ix},{ix,1,Length[tvals]+1}]],
		False
	];
	Plot[Evaluate[Flatten[fsleg,1]],{x,xmin,xmax},PlotStyle->Flatten[Map[{#,#}&,style],1],Filling->fill]
];


drawPointErrors[xy_,xStdDevs_,yStdDevs_,style_]:=Module[{},
	{
		style,
		MapThread[
			Circle[#1,Replace[{#2,#3},Null->0,{1}]]&,
			{
				xy,
				xStdDevs,
				yStdDevs
			}
		]
	}
];


drawPointErrors[xy_,excludePoints_,outlierPoints_,xStdDevs_,yStdDevs_,colorOutliers_]:=Module[{posEx,posOut},
	posEx = Flatten[Map[Position[xy,#,1]&,excludePoints],1];
	posOut = Flatten[Map[Position[xy,#,1]&,outlierPoints],1];

	If[TrueQ[colorOutliers],
		{
			drawPointErrors[Delete[xy,Join[posEx,posOut]],Delete[xStdDevs,Join[posEx,posOut]],Delete[yStdDevs,Join[posEx,posOut]],Darker[Darker[Green]]],
			drawPointErrors[Extract[xy,posOut],Extract[xStdDevs,posOut],Extract[yStdDevs,posOut],Red]
		},
		drawPointErrors[Delete[xy,posEx],Delete[xStdDevs,posEx],Delete[yStdDevs,posEx],Darker[Darker[Green]]]
	]

];


drawDataPointPlot[xy_,excludePoints_,outlierPoints_,pointSize_,listPlotFcn_,legendBool_,ops:((_Rule|_RuleDelayed)...)]:=Module[{goodPoints},
(*	goodPoints = Replace[Complement[xy,excludePoints,outlierPoints],{}->{{Null,Null}}];*)
	goodPoints = Replace[Complement[xy,excludePoints],{}->{{Null,Null}}];
	listPlotFcn[safeLegended[goodPoints,"Fitting Points",legendBool],PlotStyle->{PointSize[pointSize],Darker[Darker[Green]]},LabelStyle->{},PassOptions[PlotFit,listPlotFcn,ops]]
];



drawFittedCurvePlot[f_,xy_,curveStyleOptions_,Linear,plotFcn_,listPlotFcn_,legendBool_,plotRange_]:=Module[
	{xmin,xmax},

	(* If the plot range is automatic, replace bounds with minimum and maximum in the data points to be plotted *)
	xmin = Replace[plotRange[[1,1]],Automatic->Min[xy[[;;,1]]]];
	xmax = Replace[plotRange[[1,2]],Automatic->Max[xy[[;;,1]]]];

	(* If xmin=xmax, increase xmax by a small amount so the plot doesn't error *)
	If[xmin==xmax,xmin=xmin-1;xmax=xmax+1];

	plotFcn[Evaluate[safeLegended[f[x],"Fitted Model",legendBool]],{x,xmin,xmax},Evaluate[Sequence@@curveStyleOptions]]
];
drawFittedCurvePlot[f_,xy_,curveStyleOptions_,plotType_,plotFcn_,listPlotFcn_,legendBool_,plotRange_]:=With[
	{xdensesample = uniformPoints[xy,Switch[plotType,Linear|LinearLog,2001,_,1001],plotType]},
	listPlotFcn[safeLegended[Transpose[{xdensesample,f/@xdensesample}],"Fitted Model",legendBool],Sequence@@curveStyleOptions,PlotRange->Full,Joined->True]
];



(* ::Subsubsection::Closed:: *)
(*PlotPredictedValue*)


DefineOptions[
	PlotPredictedValue,
	Options:>{
		{FitError->0,_,""},
		{XError->0,_,""},
		{YError->0,_,""},
		{PlotType->Linear,_,""}
	},
	SharedOptions:>{
		Plot
	}
];


PlotPredictedValue[f_,xys0:{{NumericP,NumericP}...},ops:OptionsPattern[]]:=Module[
	{safeOps,resolvedOps,fitError,xError,yError,xErrorLines,yErrorLines,pts,
	plotRange,xmin,xmax,plotFunction,x,xys},

	safeOps = SafeOptions[PlotPredictedValue, ToList[ops]];
	resolvedOps = safeOps;

	{plotFunction,xys} = Switch[Lookup[resolvedOps,PlotType],
		Linear,
			{Plot,xys0},
		LinearLog,
			{LogPlot,MapAt[Log,xys0,{;;,2}]},
		LogLinear,
			{LogLinearPlot,MapAt[Log,xys0,{;;,1}]},
		LogLog|Log,
			{LogLogPlot,Map[{Log[#[[1]]],Log[#[[2]]]}&,xys0]}
	];


	plotRange = Lookup[resolvedOps,PlotRange];
	xmin = Min[Append[xys[[;;,1]],plotRange[[1,1]]]];
	xmax = Max[Append[xys[[;;,1]],plotRange[[1,2]]]];
	plotRange = {{xmin,xmax},Last[plotRange]};

	{fitError,xError,yError} = Lookup[safeOps,{FitError,XError,YError}];

	xErrorLines = Map[Line[{#+{xError,0},#+{-xError,0}}]&,xys];
	yErrorLines=Map[Line[{#+{0,yError},#+{0,-yError}}]&,xys];


	plotFunction[
		Evaluate[{f[x],f[x]+fitError,f[x]-fitError}],{x,xmin,xmax},
		PlotStyle->{Blue,Lighter[Blue,.7],Lighter[Blue,.7]},
		Epilog->{
			{Thick,Darker[Orange,0.3],xErrorLines},
			{Darker[Green,0.5],yErrorLines},
			{Red,PointSize[Large],Point[xys]}
		},
		PlotRange->plotRange,
		Evaluate[PassOptions[plotFunction,ops]]
	]

];


(* ::Subsection::Closed:: *)
(*PlotFitOptions*)


DefineOptions[PlotFitOptions,
	SharedOptions :> {PlotFit},
	{OutputFormat -> Table,
		Table|List,
		"Determines whether the function returns a table or a list of the options."
	}
];


PlotFitOptions[xyIn:analyzeFitDataP,f:FunctionP,ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = PlotFit[xyIn,f,Append[noOutputOptions,Output->Options]]/.RuleDelayed->Rule;

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,PlotFit],
		options
	]
];


PlotFitOptions[in:ObjectP[Object[Analysis,Fit]],ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = PlotFit[in,Sequence@@Append[noOutputOptions,Output->Options]]/.RuleDelayed->Rule;

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,PlotFit],
		options
	]
];


(* ::Subsection::Closed:: *)
(*PlotFitPreview*)


DefineOptions[PlotFitPreview,
	SharedOptions :> {PlotFit}
];


PlotFitPreview[xyIn:analyzeFitDataP,f:FunctionP,ops:OptionsPattern[]]:=Module[
	{preview},

	preview = PlotFit[xyIn,f,Append[ToList[ops],Output->Preview]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];


PlotFitPreview[in:ObjectP[Object[Analysis,Fit]],ops:OptionsPattern[]]:=Module[
	{preview},

	preview = PlotFit[in,Sequence@@Append[ToList[ops],Output->Preview]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];


(* ::Subsection::Closed:: *)
(*ValidPlotFitQ*)


DefineOptions[ValidPlotFitQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {PlotFit}
];


ValidPlotFitQ[xyIn:analyzeFitDataP,f:FunctionP,ops:OptionsPattern[]]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[ops],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=PlotFit[xyIn,f,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},

		Module[{initialTest,validObjectBooleans,inputObjs,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			inputObjs = Cases[Flatten[xyIn,1], _Object | _Model];

			If[!MatchQ[inputObjs, {}],
				validObjectBooleans=ValidObjectQ[inputObjs,OutputFormat->Boolean];

				voqWarnings=MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{inputObjs,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* TODO: update to call with options or use different function once that's worked out*)
	(* Run the tests as requested *)
	RunUnitTest[<|"ValidPlotFitQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidPlotFitQ"]
];


ValidPlotFitQ[in:ObjectP[Object[Analysis,Fit]],ops:OptionsPattern[]]:= Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[ops],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=PlotFit[in,Sequence@@preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},

		Module[{initialTest,validObjectBoolean,voqWarning},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBoolean=ValidObjectQ[in,OutputFormat->Boolean];

			voqWarning=Warning[ToString[in,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					validObjectBoolean,
					True
				];

			(* Get all the tests/warnings *)
			Append[functionTests,voqWarning]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* TODO: update to call with options or use different function once that's worked out*)
	(* Run the tests as requested *)
	RunUnitTest[<|"ValidPlotFitQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidPlotFitQ"]

];
