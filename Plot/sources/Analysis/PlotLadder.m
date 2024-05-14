(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotLadder*)


DefineOptions[PlotLadder,
	Options :> {
		{
			OptionName->PlotType,
			Default->Fit,
			Description->"If Fit, plots standard fit. If Peaks, plots coordinates with peaks and standard size epilogs.",
			AllowNull->False,
			Category->"Ladder",
			Widget->Widget[Type->Enumeration,Pattern:>Fit|Peaks|All]
		},
		{
			OptionName->Display,
			Default->Automatic,
			Description->"Controls whether plot is ExpectedSize or ExpectedPosition. Can plot either given either function.",
			AllowNull->True,
			Category->"Ladder",
			Widget->Widget[Type->Enumeration,Pattern:>ExpectedSize|ExpectedPosition]
		},
		{
			OptionName->PositionUnit,
			Default->Automatic,
			Description->"Units of the Position axis in to apply to the data.",
			AllowNull->True,
			Category->"Ladder",
			Widget->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word,PatternTooltip->"Position units, default is Minute."]
		},
		{
			OptionName->SizeUnit,
			Default->Automatic,
			Description->"Units of the Size axis to apply to the data.",
			AllowNull->True,
			Category->"Ladder",
			Widget->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word,PatternTooltip->"Size units, default is Nucleotide."]
		},
		{
			OptionName->AxesUnits,
			Default->{Automatic,Automatic},
			Description->"The units in which the data should be displayed on the plot. PositionUnit and SizeUnit will be converted to these units.",
			AllowNull->True,
			Category->"Ladder",
			Widget->{
				"x"->Alternatives[
					"Set Unit"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
				],
				"y"->Alternatives[
					"Set Unit"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
				]
			}
		},
		{
			OptionName->ExpectedSize,
			Default->Null,
			Description->"A pure function that predicts size from position.",
			AllowNull->True,
			Category->"Ladder",
			Widget->Widget[Type->Expression,Pattern:>_Function|_QuantityFunction,Size->Line,PatternTooltip->"A function that maps position to size."]
		},
		{
			OptionName->ExpectedPosition,
			Default->Null,
			Description->"A pure function that predicts position from size.",
			AllowNull->True,
			Category->"Ladder",
			Widget->Widget[Type->Expression,Pattern:>_Function|_QuantityFunction,Size->Line,PatternTooltip->"A function that maps size to position."]
		},
		{
			OptionName->Point,
			Default->Null,
			Description->"Point for interpolation.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[Type->Expression,Pattern:>_,Size->Line]
		},

		(* ELLP Options which should be hidden *)
		ModifyOptions[EmeraldListLinePlot,
			{
				Zoomable,ScaleX,ScaleY,LegendLabel,
				SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle,TargetUnits,
				ErrorBars,ErrorType,Reflected,Scale,Joined,InterpolationOrder,PlotStyle,
				PeakLabels,PeakLabelStyle,FractionColor,FractionHighlightColor,
				Tooltip,VerticalLine,SecondYUnit,Legend,LegendPlacement,Boxes,
				LabelingFunction,Peaks,Fractions,FractionHighlights,Ladder,
				PlotRangeClipping,ClippingStyle,FrameUnits,PlotMarkers,Prolog,Epilog
			},
			Category->"Hidden"
		]
	},
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

(* PlotType->All *)
PlotLadder[inf: ObjectP[Object[Analysis, Ladder]],ops:OptionsPattern[]]:=Module[
	{origOps,safeOps,fitPlot,fitPlotOps,peaksPlot,peaksPlotOps,result,resolvedOps},

	(* Convert the original option into a list *)
	origOps=ToList[ops];

	(* Populate default options *)
	safeOps=SafeOptions[PlotLadder,origOps];

	(* Get the requested output type *)
	output=Lookup[safeOps,Output];

	(* Generate each plot type, and get the corresponding options *)
	{fitPlot,fitPlotOps}=PlotLadder[inf,Sequence@@ReplaceRule[origOps,{PlotType->Fit,Output->{Result,Options}}]];
	{peaksPlot,peaksPlotOps}=PlotLadder[inf,Sequence@@ReplaceRule[origOps,{PlotType->Peaks,Output->{Result,Options}}]];

	(* Generate the result *)
	result=TabView[MapThread[Rule,{{"Peaks","Fit"},{peaksPlot,fitPlot}}]];

	(* Consolidate resolved options  *)
	resolvedOps=ReplaceRule[peaksPlotOps,
		Join[
			{PlotType->All,Output->output},
			(#->Lookup[fitPlotOps,#])&/@{Display,PositionUnit,SizeUnit,AxesUnits,ExpectedSize,ExpectedPosition,Point}
		]
	];

	(* Return the requested output *)
	output/.{
		Result->result,
		Preview->result,
		Options->resolvedOps,
		Tests->{}
	}

]/;MatchQ[OptionValue[PlotType],All];


(* PlotType->Peaks *)
PlotLadder[inf:PacketP[Object[Analysis, Ladder]],ops:OptionsPattern[]]:=Module[
	{safeOps,output,pkFrags,pksInf,dataInf,coords,un,prange,rawELLPOps,ellpOps,pkPlot,mostlyResolvedOps,resolvedOps},

	(* Prepare the ELLP *)
	safeOps = SafeOptions[PlotLadder,ToList[ops]];
	output = Lookup[safeOps,Output];
	pkFrags = Analysis`Private`packetLookup[inf,FragmentPeaks];
	pksInf = Download[Analysis`Private`packetLookup[inf,PeaksAnalysis], Evaluate[Packet[Sequence@@Append[PeaksFields,BaselineFunction], Reference, ReferenceField]]];
	dataInf = Download[Last[Lookup[pksInf,Reference]]];
	coords = Lookup[dataInf,Replace[Lookup[pksInf,ReferenceField],OptimalLaneImage->OptimalLaneIntensity]];
	un = Lookup[LegacySLL`Private`typeUnits[Object/.dataInf],Lookup[pksInf,ReferenceField]];
	prange = Lookup[safeOps,PlotRange]/.{Automatic->{Automatic,{Automatic,1.025*Max[coords[[;;,2]]]}}};

	(* Options to pass on to ELLP. Strip AxesUnits and Display manually because they are doubly defined. *)
	rawEllpOps=DeleteCases[
		ToList@stringOptionsToSymbolOptions[Quiet@PassOptions[PlotLadder,EmeraldListLinePlot,ops]],
		(AxesUnits|Display->_)
	];

	(* Swap in resolved resolutions *)
	ellpOps=ReplaceRule[rawEllpOps,{Peaks->pksInf,Prolog->ladderEpilog[pkFrags,coords],PlotRange->prange}];

	(* Do the ListLinePlot *)
	{pkPlot,mostlyResolvedOps}=EmeraldListLinePlot[coords,ReplaceRule[ellpOps,Output->{Result,Options}]];

	(* Fill in missing options *)
	resolvedOps=ReplaceRule[
		ReplaceRule[safeOps,mostlyResolvedOps,Append->False],
		(* Null out unused options *)
		{
			PlotType->Peaks,
			Display->Null,
			PositionUnit->Null,
			SizeUnit->Null,
			AxesUnits->Null,
			Output->output
		}
	];

	(* Return the requested outputs *)
	output/.{
		Result->pkPlot,
		Preview->pkPlot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Options->resolvedOps,
		Tests->{}
	}
]/;MatchQ[OptionValue[PlotType],Peaks];


(* List of rules gets converted to ordered pairs *)
PlotLadder[standard:{Rule[_Integer,_?NumericQ]..},ops:OptionsPattern[PlotLadder]]:=PlotLadder[List@@@standard,ops];

(*** PlotType->Fit ***)
PlotLadder[standard:{List[_Integer,_?NumericQ]...},ops:OptionsPattern[PlotLadder]]:=Module[
	{
		originalOps,safeOps,output,xyunits,axesUnits,pointPlot,fitPlot,
		resolvedSizeUnit,resolvedPositionUnit,f,displayLength,bool,xf,display,interpPlot,
		partiallyResolvedOps,mostlyResolvedOps,resolvedOps,finalPlot
	},

	(* Make sure we are working with a list of options *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotLadder,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* figure out what to display, and which function to use *)
	{f,bool,xf,display} = fToPlot[OptionValue[Display],OptionValue[ExpectedSize],OptionValue[ExpectedPosition],standard];
	displayLength=If[display===ExpectedSize,True,False];

	(* set up data and display units *)
	{resolvedSizeUnit,resolvedPositionUnit}=Replace[{OptionValue[SizeUnit],OptionValue[PositionUnit]},{
		{Automatic,Automatic}->{Nucleotide,Minute},
		{Automatic,y_}:>{Nucleotide,y},
		{x_,Automatic}:>{x,Minute}
	}];

	(* Flip the xy units if needed *)
	xyunits=If[displayLength,
		{resolvedPositionUnit,resolvedSizeUnit},
		{resolvedSizeUnit,resolvedPositionUnit}
	];

	(* Set the plot axesUnits *)
	axesUnits=setAxesUnits[OptionValue[AxesUnits],xyunits];

	(* Resolve the input options *)
	partiallyResolvedOps=ReplaceRule[safeOps,
		{
			PlotType->Fit,
			PositionUnit->resolvedPositionUnit,
			SizeUnit->resolvedSizeUnit
		}
	];

	(* Primary plot is scatter plot of data points. Pass original options, not the safe options. *)
	{pointPlot,mostlyResolvedOps}=plotStandardPts[standard,xyunits,axesUnits,displayLength,
		Sequence@@ReplaceRule[originalOps,{Output->{Result,Options}}]
	];

	(* Fill in missing options *)
	resolvedOps=ReplaceRule[
		ReplaceRule[partiallyResolvedOps,mostlyResolvedOps,Append->False],
		(* Unfortunately this is necessary because of namespace clashes with ELLP *)
		{Display->display,AxesUnits->axesUnits,Output->output}
	];

	(* Generate secondary plots for the fit and interpolation *)
	fitPlot=plotStandardFit[f,xf,xyunits,axesUnits,bool];
	interpPlot=plotStandardInterpolation[OptionValue[Point],displayLength,xyunits,f];

	(* show together *)
	finalPlot=Show[pointPlot,fitPlot,interpPlot,PlotRange->All];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Options->resolvedOps,
		Tests->{}
	}

];


(* given info *)
PlotLadder[inf:PacketP[Object[Analysis, Ladder]],ops:OptionsPattern[PlotLadder]]:=Module[
	{esu,epu,axesUnits,su,pu},

	If[Analysis`Private`packetLookup[inf,StandardPeaks]===Null,
		Return[Message[Generic::NoStandardPeaks,Object/.inf]]
	];

	{su,pu}= Analysis`Private`packetLookup[inf,{SizeUnit,PositionUnit}];

	axesUnits = If[OptionValue[Display]===ExpectedPosition,Identity,Reverse][
		(*analyzeLadderUnits[LastOrDefault[Reference/.inf]]*)
		{su,pu}
	];

	PlotLadder[
		Analysis`Private`packetLookup[inf,FragmentPeaks],
		Sequence@@ReplaceRule[
			{
				AxesUnits->axesUnits,
				PositionUnit->pu,
				SizeUnit->su,
				ExpectedSize -> Analysis`Private`packetLookup[inf,ExpectedSize],
				ExpectedPosition -> Analysis`Private`packetLookup[inf,ExpectedPosition]
			},
			ToList[ops],
			Append->True
		]
	]

];

(* Object Reference/Link Overload *)
PlotLadder[d:ObjectReferenceP[Object[Data]]|LinkP[Object[Data]],ops:OptionsPattern[PlotLadder]]:=PlotLadder[Download[d],ops];

(* Chromatography Data Overload *)
PlotLadder[inf: PacketP[Object[Data, Chromatography]],ops:OptionsPattern[PlotLadder]]:=Module[{standardID,pt,pks,order},
	Echo["DEF"];

	{standardID,pt}=If[!MatchQ[(StandardData/.inf),Null|{Null}],
		pks = FirstOrDefault[FirstOrDefault[LegacySLL`Private`typeToPeaksSourceFields[Type/.inf]/.inf]];
		order = Reverse[Ordering[pks[Area]]];
		{StandardData/.inf,First[pks[Position][[order]]]},
		{LastOrDefault[StandardAnalyses/.inf],OptionValue[Point]}
	];
	PlotLadder[standardID,Point->pt,ops]
];

(* Generic Packet overload *)
PlotLadder[inf:PacketP[],ops:OptionsPattern[PlotLadder]]:=Module[{standardID,pt,pks,order},
	{standardID,pt}=If[!MatchQ[(StandardData/.inf),Null|{Null}],
		pks = FirstOrDefault[FirstOrDefault[LegacySLL`Private`typeToPeaksSourceFields[Type/.inf]/.inf]];
		order = Reverse[Ordering[pks[Area]]];
		{Analysis`Private`packetLookup[inf,StandardData],First[pks[Position][[order]]]},
		{LastOrDefault[StandardAnalyses/.inf],OptionValue[Point]}
	];

	Echo["ASD"];

	PlotLadder[standardID,Point->pt,ops]
];

(*Safety Overloads *)
PlotLadder[id:ObjectP[Object[Analysis,Ladder]],ops:OptionsPattern[PlotLadder]]:=PlotLadder[Download[id],ops];
PlotLadder[Null,rest___]:=PlotLadder[{},rest];


(* Plot Helpers *)

(* AxesUnits *)
setAxesUnits[{Automatic,Automatic},xyunits_]:=xyunits;
setAxesUnits[{x_,Automatic},{_,y_}]:={x,y};
setAxesUnits[{Automatic,y_},{x_,_}]:={x,y};
setAxesUnits[{x_,y_},_]:={x,y};
setAxesUnits[axesUnits_,xyunits_]:=Return[Message[Generic::BadOptionValue,axesUnits,AxesUnits]];

(* Resolve plot type *)
fToPlot[Automatic,Null,Null,_]:={Null,Null,Null,ExpectedSize};
fToPlot[d:(ExpectedSize|ExpectedPosition),Null,Null,_]:={Null,Null,Null,d};
fToPlot[Automatic,lf:(_Function|_QuantityFunction),_,standard_]:={lf,False,standard[[;;,2]],ExpectedSize};
fToPlot[Automatic,Null,rf:(_Function|_QuantityFunction),standard_]:={rf,False,standard[[;;,1]],ExpectedPosition};
fToPlot[d:ExpectedSize,lf:(_Function|_QuantityFunction),_,standard_]:={lf,False,standard[[;;,2]],d};
fToPlot[d:ExpectedSize,Null,rf:(_Function|_QuantityFunction),standard_]:={rf,True,standard[[;;,1]],d};
fToPlot[d:ExpectedPosition,lf:(_Function|_QuantityFunction),Null,standard_]:={lf,True,standard[[;;,2]],d};
fToPlot[d:ExpectedPosition,_,rf:(_Function|_QuantityFunction),standard_]:={rf,False,standard[[;;,1]],d};
fToPlot[___]:={Null,Null,Null,ExpectedSize};

(* Plot the fit if available *)
plotStandardFit[Null,___]:={};
plotStandardFit[f_,xf_,xyunits_,axesUnits_,bool_]:=Module[{xyf,xyfconverted},
	xyf=N@Unitless[Map[{#,f[#]}&,xf]];
	If[bool,xyf=Reverse/@xyf];
	xyfconverted=If[MemberQ[xyunits,None],xyf,Convert[xyf,xyunits,axesUnits]];
	ListLinePlot[xyfconverted,PlotStyle->(ColorData[1][1])]
];

(* Plot the standard data points, if available  *)
plotStandardPts[standard_,xyunits_,axesUnits_,displayLength_,ops___]:=Module[
	{xy,xyconverted,frameLabels,safexy,passthroughOps,resolvedFrameLabels,resolvedPlotStyle},

	(* Determine if the xy points should be flipped *)
	xy=If[displayLength,Reverse,Identity]/@(List@@@standard);

	(* Convert the points into the appropriate units *)
	xyconverted = If[MemberQ[xyunits,None],xy,Convert[xy, xyunits, axesUnits]];

	(* Generate Frame labels *)
	frameLabels={UnitDimension[First[axesUnits]]<>" "<>UnitForm[First[axesUnits],Number->False],
				UnitDimension[Last[axesUnits]]<>" "<>UnitForm[Last[axesUnits],Number->False]};

	(* If xyconverted is empty replace it with {Null} so ELLP can process it appropriately *)
	safexy=If[MatchQ[xyconverted,{}],{Null},xyconverted];

	(* Need to drop the AxesUnits and Display options since these do different things in ELLP *)
	passthroughOps=DeleteCases[
		ToList@stringOptionsToSymbolOptions[Quiet@PassOptions[PlotLadder,EmeraldListLinePlot,ops]],
		(AxesUnits|Display->_)
	];

	(* Use default frame labels if none were specified *)
	resolvedFrameLabels=If[MemberQ[ToList[ops],FrameLabel->_],
		Lookup[ToList[ops],FrameLabel]/.{Automatic->frameLabels},
		frameLabels
	];

	(* Use default plot style if none were specified *)
	resolvedPlotStyle=If[MemberQ[ToList[ops],PlotStyle->_],
		Lookup[ToList[ops],PlotStyle]/.{Automatic->Directive[PointSize[Large],ColorData[1][4]]},
		Directive[PointSize[Large],ColorData[1][4]]
	];

	(* Call EmeraldListLinePlot *)
	EmeraldListLinePlot[safexy,
		ReplaceRule[passthroughOps,{Axes->False,Joined->False,PlotStyle->resolvedPlotStyle,FrameLabel->resolvedFrameLabels}]
	]
];


(* Plot the interpolation around the standard curve, if available *)
plotStandardInterpolation[Null,___]:={};
plotStandardInterpolation[coord_,displayLength_,xyunits_,f_]:=Module[{pts,makePoint},
	makePoint[in_]:=Which[
		MatchQ[in,_?NumericQ],{in,Unitless[f[in]]},
		MatchQ[Units[in],Units[FirstOrDefault[xyunits]]],{Unitless[in,FirstOrDefault[xyunits]],Unitless[f[in],LastOrDefault[xyunits]]},
		True,Message[""]
	];
	pts=makePoint/@Switch[coord,_List,coord,_,{coord}];
	ListPlot[pts,PlotMarkers->{"+",Large},PlotStyle->(Red)]
];


(* ::Subsubsection::Closed:: *)
(*ladderEpilog*)


(* Create a ladder epilog to place in a plot *)
ladderEpilog[standardPeaks:CoordinatesP,xy:CoordinatesP]:=
	ladderEpilog[standardPeaks,xy,Red];
ladderEpilog[standardPeaks:CoordinatesP,xy:CoordinatesP,color_?ColorQ]:=Module[{ymin,ymax,peakCoords,findClosestY},

	findClosestY[val_]:=Last[First[SortBy[{Abs[#[[1]]-val],#[[2]]}&/@xy,First]]];

	{ymin,ymax}=MinMax[xy[[;;,2]]];

	peakCoords = {#,.06*Mean[{ymin,ymax}]+findClosestY[#]}&/@standardPeaks[[;;,2]];

	MapThread[
		Style[Text[First[#],#2],color,Bold,Background->White]&,
		{standardPeaks,peakCoords}
	]
];

(* Overloads *)
ladderEpilog[standardPeaks:CoordinatesP,xy:QuantityCoordinatesP[],rest___]:=ladderEpilog[standardPeaks,Unitless[xy],rest];
ladderEpilog[___]:={}
