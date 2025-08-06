(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotDistribution*)


DefineOptions[PlotDistribution,

	Options:>{
		{
			OptionName -> DistributionFunction,
			Default -> PDF,
			Description -> "The statistical function to be visualized.",
			AllowNull -> False,
			Category -> "Data Specifications",
			Widget -> Widget[Type->Enumeration,Pattern:>PDF|CDF|SurvivalFunction|HazardFunction]
		},
		{
			OptionName->Display,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None,{}]],
				Adder[Widget[Type->Enumeration, Pattern:>Alternatives[Mean,Deviations,SmoothHistogram,FittedModel]]]
			],
			Description->"The statistics and model fits to overlay on the distribution plot.",
			Category->"Data Specifications"
		},
		{
			OptionName->EstimatedDistribution,
			Default->NormalDistribution[\[Alpha],\[Beta]],
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>DistributionP[],Size->Line],
			Description->"Parametric distribution to be fit to the input data and overlayed on the plot.",
			Category->"Data Specifications"
		},

		(* Options to be inherited from the ListPlotOptions shared option set, with modification *)
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->TargetUnits,
					Description -> "The units of the random variable. If these are distinct from the units currently associated with the random variable, unit conversions will occur before plotting.",
					Widget->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
						Widget[Type->Expression, Pattern:>(_?UnitsQ|_?KnownUnitQ|Automatic)|{(_?UnitsQ|_?KnownUnitQ|Automatic)..}, Size->Line]
					]
				},
				{
					OptionName->PlotLabel,
					Default->Automatic
				},
				{
					OptionName->Axes,
					Default->False,
					Category->"Hidden"
				},
				{
					OptionName->ImageSize,
					Default->Automatic,
					Category->"Image Format"
				},
				{
					OptionName->AspectRatio,
					Default->Automatic,
					Category->"Image Format"
				},
				{
					OptionName->Filling,
					Default->Automatic
				},
				{
					OptionName->MeshFunctions,
					Default->Automatic,
					Category->"Mesh"
				}
			}
		],

		(* Inherited SmoothHistogramOptions *)
		ModifyOptions[SmoothHistogramOptions,{
			{
				OptionName->MaxRecursion,
				Category->"Hidden"
			},
			{
				OptionName->WorkingPrecision,
				Category->"Hidden"
			}
		}
		],

		(* Output option *)
		OutputOption

	},
	SharedOptions:>{

		(* Inherit options from EmeraldListLinePlot *)
		{EmeraldListLinePlot,
			{AlignmentPoint,AxesLabel,AxesOrigin,AxesStyle,Background,
			BaselinePosition,BaseStyle,ClippingStyle,
			ColorOutput,ContentSelectable,CoordinatesToolOptions,DisplayFunction,Epilog,
			FillingStyle,FormatType,Frame,FrameLabel,FrameStyle,FrameTicks,
			FrameTicksStyle,GridLines,GridLinesStyle,ImageMargins,ImagePadding,
			ImageSizeRaw,LabelingSize,LabelStyle,Method,PerformanceGoal,
			PlotLabels,PlotLegends,PlotRange,PlotRangeClipping,PlotRangePadding,
			PlotRegion,PlotStyle,PlotTheme,PreserveImageOptions,Prolog,
			RotateLabel,ScalingFunctions,Ticks,TicksStyle}
		},

		(* Inherit options from EmeraldSmoothHistogram3D *)
		{EmeraldSmoothHistogram3D,
			{Mesh,MeshShading,MeshStyle,PlotPoints}
		}

	}
];



(* Messages for PlotDistribution *)
Warning::InvalidTargetUnits="The input data could not be converted to the specified TargetUnits (`1`). Please check that the TargetUnits are consistent with the data. Defaulting to the original units associated with the input data.";

(* Define helper function that returns True if the input is a 1-dimensional quantity array *)
quantityArray1DQ[myInput_]:=MatchQ[myInput,QuantityArrayP[]]&&Length[Dimensions[myInput]]==1;


(* Primary overload *)
PlotDistribution[in:(_?DistributionParameterQ|{UnitsP[]..}|_?quantityArray1DQ),ops:OptionsPattern[]]:=Module[
	{safeOps,targetUnits,resolvedIn,finalPlot,output,finalGraphics},

	safeOps=SafeOptions[PlotDistribution,ToList[ops]];

	(* Attempt to convert input to target units. *)
	targetUnits=Lookup[safeOps,TargetUnits];

	resolvedIn=If[
		MatchQ[targetUnits,ListableP[Automatic,2]],
		in,

		(* If conversion fails, throw a warning and default to the associated units *)
		Check[Convert[in,targetUnits],Message[Warning::InvalidTargetUnits,targetUnits];in]
	];

	(* Generate final plot *)
	finalPlot=Which[
		MatchQ[resolvedIn,EmpiricalDistributionP[]|_DataDistribution|_SampleDistribution|_List|_?QuantityArrayQ]&&UnitsQ[Mean[resolvedIn]],
			LabeledHistogram[resolvedIn,safeOps],
		MatchQ[resolvedIn,EmpiricalDistributionP[]|_DataDistribution|_SampleDistribution|_List|_?QuantityArrayQ]&&MatchQ[resolvedIn["Dimension"],2],
			LabeledHistogram3D[resolvedIn,safeOps],
		Analysis`Private`MultivariateDistributionQ[resolvedIn],
			LabeledDistribution3D[resolvedIn,safeOps],
		DistributionParameterQ[resolvedIn],
			(* If it's a quantity distribution, strip the units *)
			LabeledDistribution[If[QuantityDistributionQ[resolvedIn],QuantityMagnitude@resolvedIn,resolvedIn],safeOps]
	];

	(* Extract output option value *)
	output=Lookup[safeOps,Output];

	(* Extract the final Graphics *)
	finalGraphics=First@Cases[ToList@finalPlot,_Graphics,-1];

	(* Return the result, according to the output option. *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},

		(* Replace the user Graphics options with resolved Graphics options *)
		Options->ReplaceRule[safeOps,Options[finalGraphics]]
	}
];

(* Object[Analysis,Fit] overload *)
PlotDistribution[obj:ObjectReferenceP[Object[Analysis,Fit]]|LinkP[Object[Analysis,Fit]],ops:OptionsPattern[]]:=PlotDistribution[Download[obj],ops];
PlotDistribution[inf:PacketP[Object[Analysis,Fit]],ops:OptionsPattern[]]:=Module[{pDist,parNames,parPairs,safeOps,output,plotOutput,aggregatedPlotOutputs,finalOutput},

	(* Extract safe options *)
	safeOps=SafeOptions[PlotDistribution,ToList[ops]];

	pDist = Lookup[inf,BestFitParametersDistribution];
	parNames = Lookup[inf,BestFitParameters][[;;,1]];
	parPairs = Subsets[Range[Length[parNames]],{2}];

	(* Extract output option value *)
	output=ToList@Lookup[safeOps,Output];

	(* Map PlotDistribution across the list of parameters found within the fit object *)
	plotOutput=Map[
		parNames[[#]]->PlotDistribution[
			MarginalDistribution[pDist,#],
			Sequence@@ReplaceRule[safeOps,{
				PlotLabel->Replace[Lookup[safeOps,PlotLabel],Automatic->Lookup[inf,SymbolicExpression]],
				FrameLabel->Replace[Lookup[safeOps,FrameLabel],Automatic->parNames[[#]]],
				AxesLabel->Append[parNames[[#]],""],
				ImageSize->Replace[Lookup[safeOps,ImageSize],Automatic->300],
				Output->output
			}]
		]&,
		parPairs
		];

	(* Aggregate outputs across each parameter pair *)
	aggregatedPlotOutputs=MapIndexed[#1->(Values@plotOutput)[[;;,First@#2]]&,output];

	(* Assemble the specified output *)
	finalOutput=ReleaseHold/@(output/.{

		(* Return original form of Results *)
		Result->Hold@MapThread[#1->#2&,{Keys@plotOutput,Result/.aggregatedPlotOutputs}],

		(* Return original form of Preview *)
		Preview->Hold@SlideView[Preview/.aggregatedPlotOutputs],

		(* Return aggregated tests from all generated graphics *)
		Tests->Hold@Join@@(Tests/.aggregatedPlotOutputs),

		(* Only return options common to all generated graphics *)
		Options->Hold@ReplaceRule[safeOps,Intersection@@(Options/.aggregatedPlotOutputs)]

	});

	(* If the original Output specification was a list, return a list of outputs. Otherwise, just return the first output. *)
	If[MatchQ[Lookup[safeOps,Output],_List],finalOutput,First@finalOutput]

];


(* ::Subsubsection::Closed:: *)
(*PlotDistributionOptions*)


DefineOptions[PlotDistributionOptions,
	SharedOptions :> {PlotDistribution}
];

PlotDistributionOptions[myInput_,ops:OptionsPattern[]]:=PlotDistribution[myInput,ops,Output->Options];


(* ::Subsubsection::Closed:: *)
(*PlotDistributionPreview*)


DefineOptions[PlotDistributionPreview,
	SharedOptions :> {PlotDistribution}
];

PlotDistributionPreview[myInput_,ops:OptionsPattern[]]:=PlotDistribution[myInput,ops,Output->Preview];


(* ::Subsubsection::Closed:: *)
(*epilogs*)


distributionMeanEpilog[Indeterminate,___]:={};
distributionMeanEpilog[mean_,y_]:=Tooltip[{Darker[Red],Thick,Line[{{mean,0},{mean,y}}]},Column[{"\[Mu]",mean},ItemStyle->15]];

distributionMedianEpilog[Indeterminate,___]:={};
distributionMedianEpilog[med_,y_]:=Tooltip[{Lighter[Red],Thick,Line[{{med,0},{med,y}}]},Column[{"Median",med},ItemStyle->15]];

distributionDeviationEpilog[_,0|0.,_,_]:={};
distributionDeviationEpilog[Indeterminate,___]:={};
distributionDeviationEpilog[_,Indeterminate,___]:={};
distributionDeviationEpilog[mean_,dx_,{yL_,yR_},n_]:={
	Tooltip[{Red,Thick,Line[{{mean+dx,0},{mean+dx,yR}}]},Column[{"\[Mu]+"<>ToString[n]<>"\[Sigma]",mean+dx,Null,ToString[n]<>"\[Sigma]",dx,dx/mean*100*Percent},ItemStyle->15]],
	Tooltip[{Red,Thick,Line[{{mean-dx,0},{mean-dx,yL}}]},Column[{"\[Mu]-"<>ToString[n]<>"\[Sigma]",mean-dx,Null,"-"<>ToString[n]<>"\[Sigma]",-dx,-dx/mean*100*Percent},ItemStyle->15]]
};

distributionMinMaxEpilog[_,0|0.,_,_]:={};
distributionMinMaxEpilog[Indeterminate,___]:={};
distributionMinMaxEpilog[_,Indeterminate,___]:={};
distributionMinMaxEpilog[mean_,sigma_,{min_,max_},ymax_]:={
	Tooltip[{Pink,Thick,Line[{{max,0},{max,ymax}}]},Column[{"Max",max,Null,(max-mean)/sigma*\[Sigma],max-mean,(max-mean)/mean*100*Percent},ItemStyle->15]],
	Tooltip[{Pink,Thick,Line[{{min,0},{min,ymax}}]},Column[{"Min",min,Null,(min-mean)/sigma*\[Sigma],min-mean,(min-mean)/mean*100*Percent},ItemStyle->15]]
};

distributionPlotRange[mean:Indeterminate,stddev:Indeterminate,median_]:={median-6,median+6};
distributionPlotRange[mean_,stddev_,median_]:={mean-3stddev,mean+3stddev};
distributionPlotRange[mean_,stddev:Indeterminate,median_]:={mean-6,mean+6};
distributionPlotRange[mean_,stddev_,median_]:={mean-3stddev,mean+3stddev};

distributionPercentTicks[mean_?PossibleZeroQ,median_,r:{rangemin_,rangemax_}]:=None;
distributionPercentTicks[mean:Indeterminate,median_,r:{rangemin_,rangemax_}]:=distributionPercentTicks[median,r];
distributionPercentTicks[mean_,median_,r:{rangemin_,rangemax_}]:=distributionPercentTicks[mean,r];
distributionPercentTicks[m_,{rangemin_,rangemax_}]:=MapIndexed[{#1,If[EvenQ[First[#2]],"",Round[(#1-m)/m*100,.01]]}&,System`FindDivisions[{rangemin,rangemax},15]];

distributionYLabel[PDF]:="Probability Density";
distributionYLabel[CDF]:="Cumulative Density";
distributionYLabel[HazardFunction]:="Failure Rate";
distributionYLabel[SurvivalFunction]:="Survival";


(* ::Subsubsection::Closed:: *)
(*LabeledHistogram*)

(* Obtain points from empirical distribution *)
LabeledHistogram[dist:EmpiricalDistributionP[],safeOps_List]:=LabeledHistogram[EmpiricalDistributionPoints[dist],safeOps];

(* Primary function *)
LabeledHistogram[vals0:(_List|QuantityArrayP[]),safeOps_List]:=Module[{
		mean,sigma,se,meanEpilog,sdEpilog,seEpilog,min,max,ymean,ysigL,ysigR,y2sigL,y2sigR,frameLabel,fittedModelPlot,medianEpilog,
		percentEpilogs,percentTicks,sd2Epilog,maxminEpilog,rangemin,rangemax,hspec,plotFunc,median,ymedian,
		deviuations,epilogs,displays,frame,smoothDist,countTicks,ymax,histlist,smoothHistFig,y2max,vals,un,aspectRatio,frameTicks
	},
	un = Quantity[First[QuantityUnit[vals0]]];
	vals = Unitless[vals0,un];
	displays = If[MatchQ[Lookup[safeOps,Display],None],{},ToList@Lookup[safeOps,Display]];
	{min,max,mean,median} = {Min[#],Max[#],Mean[#],Median[#]}&[vals];
	sigma=Analysis`Private`safeStandardDeviation[vals];
	se=sigma/Sqrt[Length[vals]];
	{rangemin,rangemax}={Min[{min,mean-2*sigma}],Max[{max,mean+2*sigma}]};

	{hspec,plotFunc}=Switch[Lookup[safeOps,DistributionFunction],
		PDF, {"PDF",PDF},
		CDF, {"CDF",CDF},
		SurvivalFunction, {"SF",SurvivalFunction},
		HazardFunction, {"HF",HazardFunction}
	];

	(* Resolve AspectRatio *)
	aspectRatio=Replace[Lookup[safeOps,AspectRatio],Automatic->1/GoldenRatio];

	smoothDist = plotFunc[SmoothKernelDistribution[vals]];

	(* Plot fitted statistical model *)
	fittedModelPlot = If[MemberQ[displays,FittedModel],
		Module[{fittedDist,distToFit},

			(* Fit the distribution *)
			distToFit = Lookup[safeOps,EstimatedDistribution];
			fittedDist = Switch[distToFit,
				NormalDistribution|_NormalDistribution, NormalDistribution[mean,sigma],
				_, EstimatedDistribution[vals,distToFit]
			];

			(* Plot the specified statistical function *)
			Plot[plotFunc[fittedDist,x],{x,rangemin,rangemax},Evaluate[PassOptions[LabeledHistogram,Plot,safeOps]]]

		],
		{}
	];

	{ymean,ysigL,ysigR,y2sigL,y2sigR,ymedian} = smoothDist/@{mean,mean-sigma,mean+sigma,mean-2sigma,mean+2sigma,median};

	maxminEpilog=distributionMinMaxEpilog[mean,sigma,{min,max},ymean];

	frame = Replace[Lookup[safeOps,Frame],Automatic->{True,True,True,Switch[hspec,"PDF"|"CDF"|"SF",True,_,False]}];
	(*If[Lookup[safeOps,RightFrame]===False, frame = ReplacePart[frame,4->False]];*)
	(*If[Lookup[safeOps,TopFrame]===False, frame = ReplacePart[frame,3->False]];*)
	frameLabel = Replace[Lookup[safeOps,FrameLabel],Automatic->{"x "<>UnitForm[un,Number->False],distributionYLabel[plotFunc],"Percent from mean",Switch[hspec,"PDF","Count","CDF","Cumulative Count","SF","Survival Count",_,Null]}];

	percentTicks = If[!PossibleZeroQ[mean],
		MapIndexed[{#1,If[EvenQ[First[#2]],"",Round[(#1-mean)/mean*100,.01]]}&,System`FindDivisions[{rangemin,rangemax},15]],
		None
	];

	histlist = HistogramList[vals,Automatic,hspec];
	ymax = Max[histlist[[2]]];
	y2max = Switch[hspec,
		"PDF",Ceiling[ymax*Length[vals]],
		"CDF"|"SF", Length[vals],
		_, Length[vals]
	];
	countTicks = EmeraldFrameTicks[{0,ymax},{0,y2max}];

	(* Resolve FrameTicks *)
	frameTicks=Replace[Lookup[safeOps,FrameTicks],Automatic->{{Automatic,countTicks},{Automatic,percentTicks}}];

	(* Resolve Epilogs *)
	epilogs={};
	smoothHistFig=If[MemberQ[displays,SmoothHistogram],
		SmoothHistogram[vals,Automatic,hspec,PlotStyle->Lookup[safeOps,PlotStyle]],
		{}
	];

	If[MemberQ[displays,Deviations],
		sdEpilog=distributionDeviationEpilog[mean,sigma,{ysigL,ysigR},""];
		sd2Epilog=distributionDeviationEpilog[mean,2sigma,{y2sigL,y2sigR},2];
		AppendTo[epilogs,{sdEpilog,sd2Epilog}]
	];

	If[MemberQ[displays,Mean],
		meanEpilog=distributionMeanEpilog[mean,ymean];
		AppendTo[epilogs,meanEpilog]
	];

	If[MemberQ[displays,Median],
		medianEpilog=distributionMedianEpilog[median,ymedian];
		AppendTo[epilogs,medianEpilog]
	];

	Show[
		Histogram[vals,Automatic,hspec,
			Epilog->{maxminEpilog},
			PlotRange->{{rangemin,rangemax},Automatic}
		],
		fittedModelPlot,
		smoothHistFig,
		Epilog->epilogs,
		Frame->frame,
		FrameTicks->frameTicks,
		FrameLabel->frameLabel,
		LabelStyle->Lookup[safeOps,LabelStyle],
		ImageSize->Replace[Lookup[safeOps,ImageSize],Automatic->500],
		AspectRatio->aspectRatio,
		PlotLabel->Replace[Lookup[safeOps,PlotLabel],Automatic->None],

		(* Pass along remaining Graphics options *)
		PassOptions[Graphics,safeOps]
	]
];


(* ::Subsubsection::Closed:: *)
(*LabeledDistribution*)


LabeledDistribution[dist_?DistributionParameterQ,safeOps_List]:=Module[{
		plotFunc,mean,sigma,meanEpilog,sdEpilog,seEpilog,min,max,ymean,ysigL,ysigR,y2sigL,y2sigR,medianEpilog,
		percentEpilogs,percentTicks,sd2Epilog,rangemin,rangemax,densityFunction,median,ymedian,frameLabel,
		epilogs,displays,frame,aspectRatio,filling,plotRange,frameTicks
	},

	densityFunction = Lookup[safeOps,DistributionFunction];

	(*
		Ideally we have the mean, median, and standard deviation,
		which we use to calculate a reasonable plot range.
		Sometimes these are not calculable.  Try numerical expectation if Mean fails.
		If no standard deviation we pick a fixed window.
	*)

	median = Replace[Median[dist], m_Median->Indeterminate];
	mean=TimeConstrained[
		Mean[dist],
		3,
		Indeterminate
	];
	sigma = If[NumericQ[mean],
			StandardDeviation[dist],
			Indeterminate
	];
	(* recalc mean numerically if we have nothing else to go on *)
	If[Nor[NumericQ[mean],NumericQ[median]],
		mean = Quiet[NExpectation[X,Distributed[X,dist]]];
	];

	plotFunc=densityFunction[dist];
	{min,max} = mean + sigma*{-3,3};
	{ymean,ysigL,ysigR,y2sigL,y2sigR,ymedian} = plotFunc/@{mean,mean-sigma,mean+sigma,mean-2sigma,mean+2sigma,median};

	(* Resolve AspectRatio *)
	aspectRatio=Replace[Lookup[safeOps,AspectRatio],Automatic->1/GoldenRatio];

	(* Resolve Filling *)
	filling=Replace[Lookup[safeOps,Filling],Automatic->Bottom];

	(* Resolve PlotRange *)
	{rangemin,rangemax}=distributionPlotRange[mean,sigma,median];
	plotRange=Replace[Lookup[safeOps,PlotRange],Automatic->{{rangemin,rangemax},Automatic}];

	(* Locate percent ticks *)
	percentTicks = Quiet[distributionPercentTicks[mean,median,{rangemin,rangemax}]];

	(* Resolve FrameTicks *)
	frameTicks=Replace[Lookup[safeOps,FrameTicks],Automatic->{{Automatic,Automatic},{Automatic,percentTicks}}];

	(* Resolve Frame *)
	frame = Replace[Lookup[safeOps,Frame],Automatic->{True,True,True,False}];
	If[Lookup[safeOps,TopFrame]===False, frame = ReplacePart[frame,3->False]];

	(* Resolve FrameLabel *)
	frameLabel = Replace[Lookup[safeOps,FrameLabel],Automatic->{"x",distributionYLabel[densityFunction],"Percent from mean",None}];

	displays = If[MatchQ[Lookup[safeOps,Display],None],{},ToList@Lookup[safeOps,Display]];
	epilogs={};

	If[MemberQ[displays,Deviations],
		sdEpilog=Quiet[distributionDeviationEpilog[mean,sigma,{ysigL,ysigR},""]];
		sd2Epilog=Quiet[distributionDeviationEpilog[mean,2sigma,{y2sigL,y2sigR},2]];
		AppendTo[epilogs,{sdEpilog,sd2Epilog}]
	];

	If[MemberQ[displays,Mean],
		meanEpilog=distributionMeanEpilog[mean,ymean];
		AppendTo[epilogs,meanEpilog]
	];

	If[MemberQ[displays,Median],
		medianEpilog=distributionMedianEpilog[median,ymedian];
		AppendTo[epilogs,medianEpilog]
	];

	(* Plot distribution *)
	Plot[
		plotFunc[x],{x,rangemin,rangemax},
		Epilog->Evaluate[epilogs],
		Frame->frame,
		FrameTicks->frameTicks,
		PlotRange->plotRange,
		FrameLabel->frameLabel,
		Filling->filling,
		ImageSize->Replace[Lookup[safeOps,ImageSize],Automatic->500],
		AspectRatio->aspectRatio,
		PlotLabel->Replace[Lookup[safeOps,PlotLabel],Automatic->None],
		Evaluate[PassOptions[Plot,safeOps]]
	]

];


(* ::Subsubsection::Closed:: *)
(*LabeledHistogram3D*)

LabeledHistogram3D[dist_DataDistribution|EmpiricalDistributionP[],safeOps_List]:=LabeledHistogram3D[EmpiricalDistributionPoints[dist],safeOps];
LabeledHistogram3D[vals_List,safeOps_List]:=Module[{
		displays,hspec,plotFunc
	},

	(* If Display is None, set displays to an empty list *)
	displays = If[MatchQ[Lookup[safeOps,Display],None],{},ToList@Lookup[safeOps,Display]];

	{hspec,plotFunc}=Switch[Lookup[safeOps,DistributionFunction],
		PDF, {"PDF",PDF},
		CDF, {"CDF",CDF},
		SurvivalFunction, {"SF",SurvivalFunction},
		HazardFunction, {"HF",HazardFunction}
	];

	Show[
		(* Histogram3D[vals,Automatic,hspec*)
		SmoothHistogram3D[vals,Automatic,hspec,PassOptions[SmoothHistogram3D,safeOps]],

		(* Pass along options *)
		AxesLabel->Lookup[safeOps,AxesLabel],
		PlotRange->Replace[Lookup[safeOps,PlotRange],Automatic->All],
		ImageSize->Replace[Lookup[safeOps,ImageSize],Automatic->300],
		AspectRatio->Replace[Lookup[safeOps,AspectRatio],Automatic->1],
		PlotLabel->Replace[Lookup[safeOps,PlotLabel],Automatic->None],

		(* Pass along remaining Graphics options *)
		PassOptions[Graphics,safeOps]

	]
];


(* ::Subsubsection::Closed:: *)
(*LabeledDistribution3D*)


LabeledDistribution3D[dist_?DistributionParameterQ,safeOps_List]:=Module[{
		plotFunc,means,sigmas,xrangemin,xrangemax,yrangemin,yrangemax,densityFunction
	},

	densityFunction = Lookup[safeOps,DistributionFunction];

	means=Mean[dist];
	sigmas=StandardDeviation[dist];
	plotFunc=densityFunction[dist];

	{xrangemin,xrangemax}=distributionPlotRange[means[[1]],sigmas[[1]],Null];
	{yrangemin,yrangemax}=distributionPlotRange[means[[2]],sigmas[[2]],Null];

	(* Generate ContourPlot *)
	ContourPlot[
		plotFunc[{x,y}],
		{x,xrangemin,xrangemax},{y,yrangemin,yrangemax},
		Evaluate@PassOptions[ContourPlot,
			MeshFunctions->Replace[Lookup[safeOps,MeshFunctions],Automatic->{#3&}],
			PlotPoints->Replace[Lookup[safeOps,PlotPoints],Automatic->50],
			LabelStyle->Lookup[safeOps,LabelStyle],
			AxesLabel->Lookup[safeOps,AxesLabel],
			FrameLabel->Lookup[safeOps,FrameLabel],
			PlotRange->Replace[Lookup[safeOps,PlotRange],Automatic->All],
			ImageSize->Replace[Lookup[safeOps,ImageSize],Automatic->300],
			AspectRatio->Replace[Lookup[safeOps,AspectRatio],Automatic->1],
			PlotLabel->Replace[Lookup[safeOps,PlotLabel],Automatic->None],

			(* Pass along remaining Graphics options *)
			Sequence@@safeOps
			]
	]

];
