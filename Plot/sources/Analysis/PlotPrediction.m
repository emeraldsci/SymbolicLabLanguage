(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotPrediction*)


DefineOptions[PlotPrediction,
	Options :> {

		(*** Image Format Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->ImageSize,Default->500}
			}
		],

		(*** Data Specification options ***)
		{
			OptionName->Display,
			Description->"Different types of information to include in the final prediction plot.",
			Default->PredictionInterval,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[PredictionInterval]],
				Widget[Type->Expression,Pattern:>_,Size->Word]
			],
			Category->"Data Specifications"
		},
		{
			OptionName->PredictionMethod,
			Description->"If Single, the function finds the SinglePrediction which is the total error in predicting a y value given an x value which takes noise in the data into account. If Mean, the function finds the MeanPrediction which calculates the error including the uncertainy in the fit parameters only.",
			Default->Single,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Single,Mean]],
			Category->"Data Specifications"
		},
		{
			OptionName->Direction,
			Description->"If Forward, the function finds the y value given x value, and if Inverse, the function finds x given y. Forward is chosen by default and for Automatic.",
			Default->Forward,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Forward,Inverse,Automatic]],
			Category->"Data Specifications"
		},
		{
			OptionName -> ConfidenceLevel,
			Default -> 0.95,
			Description -> "Confidence level that is used to compute the confidence bands.",
			AllowNull -> False,
			Widget -> Widget[Type->Number, Pattern:>RangeP[0,1]],
			Category->"Data Specifications"
		},
		ModifyOptions[ListPlotOptions,
			{TargetUnits}
		],

		(*** PlotStyle Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->Frame,Default->{True,True,False,False}}
			}
		],

		(*** PlotRange Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->PlotRangeClipping,Default->False}
			}
		],

		(*** PlotStyle Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->PlotStyle,
					Default->Fit,
					Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Fit,Error]]
				}
			}
		],

		(*** Legend Options ***)
		ModifyOptions[PlotFit,
			{
				OptionName -> Legend,
				Default -> True
			}
		],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->Joined,Default->False}
			}
		],

		(*** Hidden Options ***)
		{
			OptionName -> DegreesOfFreedom,
			Default -> Automatic,
			Description -> "Degrees of freedom of the fit.  Used to calculate error bands.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>_, Size->Paragraph],
			Category->"Hidden"
		},

		(*** Output Option ***)
		OutputOption

	},
	SharedOptions:>{
		PlotFit
	}
];


PlotPrediction[fitObj:ObjectReferenceP[Object[Analysis,Fit]]|LinkP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[PlotPrediction]]:=
	PlotPrediction[Download[fitObj],x,ops];

PlotPrediction[
	fitPacket:PacketP[Object[Analysis,Fit]],
	x:(_?UnitsQ|_?DistributionParameterQ),
	ops:OptionsPattern[PlotPrediction]
]:=Module[
	{
		safeOps,ydist
	},

	safeOps = SafeOptions[PlotPrediction, ToList[ops]];

	(*
		Naming clarification:
		In case the direction is Inverse, x is actually taking the y value
		and therefore, ydist is basically the resulting x disribution
	*)

	ydist =
		Switch[Lookup[safeOps,Direction],
			(* we don't want to take the "Method" option from ListPlot *)
			Forward|Automatic,ForwardPrediction[fitPacket,x,Sequence@@DeleteCases[{PassOptions[PlotPrediction,SinglePrediction,safeOps]},Rule["Method"|EstimatedValue,_]]],
			Inverse,InversePrediction[fitPacket,x,Sequence@@DeleteCases[{PassOptions[PlotPrediction,SinglePrediction,safeOps]},Rule["Method",_]]]
		];

	Switch[Lookup[safeOps,Direction],
		Forward|Automatic,PlotPrediction[fitPacket,x,ydist,Sequence@@safeOps],
		(* reverse the direction and pretend that ydist is the user xdist *)
		Inverse,PlotPrediction[fitPacket,ydist,PassOptions[PlotPrediction,safeOps/.{Direction->Forward}]]
	]
];


PlotPrediction[fitObj:ObjectReferenceP[Object[Analysis,Fit]]|LinkP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),y:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[PlotPrediction]]:=
	PlotPrediction[Download[fitObj],x,y,ops];


PlotPrediction[
	fitPacket:PacketP[Object[Analysis,Fit]],
	x:(_?UnitsQ|_?DistributionParameterQ),
	y:(_?UnitsQ|_?DistributionParameterQ),
	ops:OptionsPattern[PlotPrediction]
]:=Module[
	{
		xUnit,yUnit,xstar,ystar,xdist,ydist,display,displayElement,cl,safeOps,legendBool,dyFromX,dy,xm,xp,ym,yp,xy,
		xmin,xmax,ymin,xyDists, xyMeans,xStdDevs, yStdDevs, plotRange, xsg, pvg,originalOps,output,internalPlotFitOps,
		plotFitPlot,plotFitOptions,internalShowOps,resolvedOps
	},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotPrediction,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	cl=Lookup[safeOps,ConfidenceLevel];
	xyDists = Lookup[fitPacket,DataPoints];
	{xyMeans,xStdDevs,yStdDevs} = Analysis`Private`resolveDistributionInputs[xyDists];
	xy=Unitless[xyMeans];
	{xmin,xmax} = MinMax[xy[[;;,1]]];
	ymin = Min[xy[[;;,2]]];
	legendBool = MatchQ[Lookup[safeOps,Legend],True|Automatic];
	display = If[MatchQ[OptionValue[Display],None],{},ToList@OptionValue[Display]];
	displayElement[displayElement_,displayVal_]:=If[MemberQ[display,displayElement],displayVal,{}];

	(* Take the x and y units from  the fit object*)
	{xUnit,yUnit}=Lookup[fitPacket,DataUnits];

	(* Converting the unit to match what we have in the fit object *)
	xdist = If[QuantityQ[x],
		Analysis`Private`toDistribution[Unitless[x,xUnit]],
		Analysis`Private`toDistribution[x]
	];
	ydist = If[QuantityQ[y],
		Analysis`Private`toDistribution[Unitless[y,yUnit]],
		Analysis`Private`toDistribution[y]
	];

	xstar=Mean[xdist];
	If[QuantityQ[xstar],xstar=Unitless[xstar,xUnit]];
	ystar=Mean[ydist];
	If[QuantityQ[ystar],ystar=Unitless[ystar,yUnit]];
	dy = StandardDeviation[ydist];
	{xm,xp}=safeConfidenceInterval[xdist,cl];
	{ym,yp}=safeConfidenceInterval[ydist,cl];

	xsg = xstarGraphic[ymin,xstar,{xm,xp},{ym,yp},{xUnit,yUnit}];
	pvg = predictedValueGraphic[{xmin,ymin},xstar,ystar,{xUnit,yUnit}];

	plotRange = resolvePlotRange[Lookup[safeOps,PlotRange],xy,{xUnit,yUnit},{}];
	(* make sure the predicted point is in the plot range *)
	plotRange[[1,1]] = Replace[plotRange[[1,1]],Automatic->Min[xmin, xm-(xmax-xmin)*0.02]];
	plotRange[[1,2]] = Replace[plotRange[[1,2]],Automatic->Max[xmax, xp+(xmax-xmin)*0.02]];

	(* The options to pass to PlotFit - Options specified by the user takes precedence over PlotPrediction/PlotFit defaults *)
	internalPlotFitOps=ToList@PassOptions[PlotPrediction,PlotFit,
		ReplaceRule[safeOps,
			{
				PlotRange->plotRange,Legend->legendBool,Display->{},PlotLabel->Lookup[safeOps,PlotLabel],Output->{Result,Options}
			}
		]
	];

	(* The result and options from calling the PlotFit function *)
	{plotFitPlot,plotFitOptions}=PlotFit[fitPacket,Sequence@@internalPlotFitOps];

	(* The options to pass to Show *)
	internalShowOps=
		{
			ExtractRule[safeOps,ImageSize],
			ExtractRule[safeOps,PlotRangeClipping],
			PlotRange->plotRange,
			Sequence@@DeleteCases[{PassOptions[Graphics,safeOps]},Rule[FrameLabel,_]]
		};

	finalPlot=Show[
		plotFitPlot,
		safeLegended[displayElement[PredictionInterval,predictedValueIntervalGraphic[xmin,xstar,ystar,{xm,xp},{ym,yp},{xUnit,yUnit}]],LineLegend[{Directive[DotDashed,Darker[Orange],Thick]},{ToString[Unitless[cl,1]*100]<>"% Prediction Bands"},ExtractRule[Options[ListPlot],LabelStyle]],legendBool],
		xsg,
		pvg,
		Sequence@@internalShowOps
	];

	(* The final resolved options based on safeOps and the return from PlotFit giving precedence to internalShowOps *)
	resolvedOps=ReplaceRule[safeOps,ReplaceRule[plotFitOptions,Prepend[internalShowOps,Output->output]]];


	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},
		Options->resolvedOps
	}

];


safeConfidenceInterval[dist_?DistributionParameterQ,cl_]:=If[MatchQ[Unitless@StandardDeviation[dist],0.],{Null,Null},ConfidenceInterval[dist,cl]];
safeConfidenceInterval[_,_]:={Null,Null};


predictedValueGraphic[{xmin_,ymin_},xstar_,ystar_,{xUnit_,yUnit_}]:=Module[{},
	Graphics[{Dashed,Darker[Blue],Thick,
		Tooltip[Line[{{xstar,ymin},{xstar,ystar}}],Style[xstar*xUnit,15]],
		Tooltip[Line[{{xstar,ystar},{xmin,ystar}}],Style[ystar*yUnit,15]]
	}]
];


predictedValueIntervalGraphic[xmin_,xstar_,ystar_,{xm_,xp_},{ym:Null,yp:Null},{xUnit_,yUnit_}]:={};
predictedValueIntervalGraphic[xmin_,xstar_,ystar_,{xm:Null,xp:Null},{ym_,yp_},{xUnit_,yUnit_}]:=
	predictedValueIntervalGraphic[xmin,xstar,ystar,{xstar,xstar},{ym,yp},{xUnit,yUnit}];
predictedValueIntervalGraphic[xmin_,xstar_,ystar_,{xm_,xp_},{ym_,yp_},{xUnit_,yUnit_}]:=Module[{},
	Graphics[{
		{
			Lighter[Gray],Opacity[0.15],
			Tooltip[Rectangle[{xmin,ym},{xstar,yp}],Style[{ym,yp}*yUnit,15]]
		},
		{
			DotDashed,Darker[Orange],Thick,
			Tooltip[Line[{{xm,ym},{xmin,ym}}],Style[ym*yUnit,15]],
			Tooltip[Line[{{xp,yp},{xmin,yp}}],Style[yp*yUnit,15]]
		}
	}]
];



xstarGraphic[ymin_,xstar_,{Null,Null},{ym_,yp_},{xUnit_,yUnit_}]:={};
xstarGraphic[ymin_,xstar_,{x_,x_},{ym_,yp_},{xUnit_,yUnit_}]:={}; (* if interval values are same, then no interval *)
xstarGraphic[ymin_,xstar_,{xm_,xp_},{ym_,yp_},{xUnit_,yUnit_}]:=Module[{},
	Graphics[{
		{
			Lighter[Gray],Opacity[0.15],
			(* draw two rectangles so we don't overlay with the dy rectangle *)
			Tooltip[Rectangle[{xm,ymin},{xstar,ym}],Style[{xm,xp}*xUnit,15]],
			Tooltip[Rectangle[{xstar,ymin},{xp,yp}],Style[{xm,xp}*xUnit,15]]
		},
		{
			DotDashed,Darker[Orange],Thick,
			Tooltip[Line[{{xm,ymin},{xm,ym}}],Style[xm*xUnit,15]],
			Tooltip[Line[{{xp,ymin},{xp,yp}}],Style[xp*xUnit,15]]
		}
	}]
];
