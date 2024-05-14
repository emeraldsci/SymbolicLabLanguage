(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*MM11.1 patches*)


(* ::Subsubsection::Closed:: *)
(*joinPatch*)


(*
 In MM11.1, Join fails when given empty lists and QuantityArrays, e.g.
 Join[{},QuantityArray[{1,2,3},Meter]
 joinPatch removes the empty lists and then joins as usual
*)
joinPatch[args___]:=Join@@DeleteCases[{args},{}|Null,{1}];



(* ::Subsubsection::Closed:: *)
(*minMaxPatch*)


(*
 In MM11.0: MinMax[{}] returns {-Infinity,Infinity}
 In MM11.1: MinMax[{}] returns {Infinity,-Infinity}
 not sure if this is a bug or intentional, so preserve old behavior for the time being
*)
minMaxPatch[{}]:={-Infinity,Infinity};
minMaxPatch[in_]:=MinMax[in];


(* ::Subsection::Closed:: *)
(* Messages *)


OnLoad[
	General::IncompatibleUnits="Incompatible units in `1`.";
	General::InvalidSecondYSpecification="Invalid SecondYCoordinates specification.";
	General::InvalidPrimaryDataSpecification="Invalid primary data specification.";
	General::InvalidValueSpecification="The specified options, `1`, must be the same length. These values will not be used. Please pad with Nulls as necessary to clarify indexing.";
	Warning::ExplicitNullOptions="Options `1` cannot be explicitly specified as Null. Null values will be ignored, and these options have been set to their default values.";
	Warning::UnresolvedPlotOptions="Resolved option(s) `1` are equal to Automatic. Please ensure that these options have resolved correctly.";
];


(* ::Subsection::Closed:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*objectOrLinkP*)


objectOrLinkP[]:=ObjectReferenceP[]|LinkP[];
objectOrLinkP[arg_]:=ObjectReferenceP[arg]|LinkP[arg];

(*packetOrInfoP*)
packetOrInfoP[]:=PacketP[];
packetOrInfoP[arg_]:=PacketP[arg];

(*plotInputP*)
plotInputP:=ListableP[ObjectP[Object[Data]],2];
rawPlotInputP:=ListableP[UnitCoordinatesP[],2];



(* ::Subsubsection::Closed:: *)
(* General Patterns *)


nullCoordinatesP = {{(_?UnitsQ|Null),(_?UnitsQ|Null)}..};
nullComplexCoordinates3DP = {{(_?UnitsQ|Null|Infinity|ComplexInfinity),(_?UnitsQ|Null|Infinity|ComplexInfinity),(_?UnitsQ|Null|Infinity|ComplexInfinity)}..};
oneDateP = _DateObject | _String | {_Integer} | {_Integer,_Integer,Repeated[NumberP,{0,4}]} ;
dateCoordinatesP = {{oneDateP,UnitsP[]}..};
(* only checking first element of coordinates here to be fast.  otherwise pattern matching on huge sets of coordinates can take multilpe seconds (in date case *)
QuantityDateCoordinatesP = _?(And[QuantityCoordinatesQ[#],MatchQ[Normal[#[[1,1]]],oneDateP]]&);
oneDataSetP = Null|nullCoordinatesP|_Replicates | CoordinatesP | _?(And[QuantityCoordinatesQ[#],MatchQ[Normal[#[[1,1]]],_Quantity|_?NumericQ]]&) | _?(And[MatchQ[Dimensions[#], {_Integer, 2}],
	MatchQ[#, MatrixP[UnitsP[] | _?DistributionParameterQ]]] &);
oneDateListDataSetP = Null|Replicates[dateCoordinatesP..] | dateCoordinatesP | QuantityDateCoordinatesP;



(* ::Subsubsection::Closed:: *)
(*charts*)


oneChartDataPointP = Null | UnitsP[] | Replicates[UnitsP[]..] | PlusMinus[UnitsP[],UnitsP[]] | _?DistributionParameterQ;
oneChartDataSetP = Null|{oneChartDataPointP..}|_?QuantityVectorQ;


(* ::Subsubsection::Closed:: *)
(*other*)


ColumnOfGraphicsP=_Column?(MatchQ[First[#],{___Graphics}]&);


(* ::Subsection::Closed:: *)
(*Option Formatting & Resolution*)


(* ::Subsubsection::Closed:: *)
(*expandOptionToTwoLists*)


expandOptionToTwoLists[val_,allowedPattern_]:=Module[{elementQ,expandFunction},

	elementQ[x:allowedPattern]:=True;
	elementQ[_]:=False;

	expandFunction[x_?elementQ]:={{x,x},{x,x}};
	expandFunction[{x__?elementQ}]:=Module[{bottom,left,top,right},
		{bottom,left,top,right}=Take[{x,x,x,x},4];
		{{left,right},{bottom,top}}
	];
	expandFunction[f:{{_?elementQ,_?elementQ},{_?elementQ,_?elementQ}}]:=f;
	expandFunction[_]:=$Failed;

	expandFunction[val]

];


(* ::Subsubsection::Closed:: *)
(*resolveTargetUnits*)


(* 1d *)
resolveTargetUnits[Automatic,default_?UnitsQ]:=default;
resolveTargetUnits[explicit_,default_?UnitsQ]:=explicit;
resolveTargetUnits[explicit_,ListableP[Null]]:=explicit;

(* 2d *)
resolveTargetUnits[Automatic|{Automatic..},defaults:{_?UnitsQ..}]:=defaults;
resolveTargetUnits[specified:{(Automatic|_?UnitsQ)..},defaults:{_?UnitsQ..}]:=MapThread[Replace[#1,Automatic->#2]&,{specified,defaults}];
(*
resolveTargetUnits[{Automatic,y_},{xDefault_?UnitsQ,yDefault_?UnitsQ}]:={xDefault, y};
resolveTargetUnits[{x_,Automatic},{xDefault_?UnitsQ,yDefault_?UnitsQ}]:={x, yDefault};
resolveTargetUnits[{x_,y_},{xDefault_?UnitsQ,yDefault_?UnitsQ}]:={x, y};
*)

(* get defaults *)
resolveDefaultTargetUnits[unitSpec_,dataFull_]:=Module[{flatData,defaultUnits},
	flatData = joinPatch@@ReplaceAll[Flatten[dataFull,1],Replicates->Sequence];
	If[MatchQ[flatData,{}],Return[{Automatic,1}]];
	defaultUnits = Map[safeUnitsOne,First[flatData]];
	resolveTargetUnits[unitSpec,defaultUnits]
];


resolveDefaultTargetUnits2[unitSpec_,dataFull_]:=Module[{flatData,defaultUnits},
	flatData = joinPatch@@ReplaceAll[dataFull,Replicates->Sequence];
	defaultUnits = safeUnitsOne[First[flatData]]/.{Units[Null]->Nothing};
	resolveTargetUnits[unitSpec,defaultUnits]
];

resolveDefaultTargetUnits3[unitSpec_,dataFull_]:=Module[{flatData,defaultUnits},
	flatData = joinPatch@@ReplaceAll[Flatten[dataFull,1],Replicates->Sequence];
	defaultUnits = safeUnitsOne[First[flatData]];
	resolveTargetUnits[unitSpec,defaultUnits]
];


safeUnits[arg:{_Quantity..}]:=Units[arg];
safeUnits[arg_List]:=Map[safeUnitsOne,arg];
safeUnits[Null]:=Null;
safeUnits[other_]:=Units[other];

safeUnitsOne[arg:Null]:=Null;
safeUnitsOne[unit_?EmeraldUnits`Private`knownUnitQ]:=Quantity[1,unit];
safeUnitsOne[arg:oneDateP]:=1;
safeUnitsOne[{oneDateP,y_}]:={1,Units[y]};
safeUnitsOne[arg:UnitsP[]]:=Units[arg];
safeUnitsOne[arg_QuantityDistribution]:=Units[arg];
safeUnitsOne[arg_?DistributionParameterQ]:=safeUnitsOne[Mean[arg]];
safeUnitsOne[other_]:=Units[other];


(* ::Subsubsection::Closed:: *)
(*resolvePlotRange*)


DefineOptions[
	resolvePlotRange,
	Options:>
		{
			{ScaleX->1,_?NumericQ,"Factor by which to scale the x-axis."},
			{ScaleY->1.05`,_?NumericQ,"Factor by which to scale the y-axis."},
			{Reflected->False,_,""}
		}
];


Warning::InvalidRangeSpecification="The provided plot range `1` is invalid and has been defaulted to Automatic. A valid plot range has the form {{xmin,xmax},{ymin,ymax}}. Each {min,max} may also be specified as All, Full, or Automatic.";
resolvePlotRange::IncompatibleUnits="Invalid units for `1`.  The given value's units `2` are not compatible with the target units `3`.";


validPlotRangePattern = Alternatives[
	Full|Automatic|All,
	{
		Full|Automatic|All | {_?UnitsQ|_?DateObjectQ|Full|Automatic|All, _?UnitsQ|_?DateObjectQ|Full|Automatic|All},
		Full|Automatic|All | {_?UnitsQ|Full|Automatic|All, _?UnitsQ|Full|Automatic|All}
	}
];



(* ::Text:: *)
(*2D*)


(*
	Base case takes list of traces b/c want to find range when all traces overlaid on same plot
*)
resolvePlotRange[unresolvedPlotRange_,xysNumeric:({(CoordinatesP|dateCoordinatesP|{})..}),targetUnits:{xUnit_,yUnit_},eps_,ops:OptionsPattern[]]:=Module[
	{safePlotRange,safeOps,xrange,yrange,xmin,xmax,ymin,ymax,xminRaw,xmaxRaw,yminRaw,ymaxRaw,xoffset,yoffset,
		yminRawEps,ymaxRawEps, xminRawEps, xmaxRawEps, epilogPts, xysNumericEps},

	(* Check if the provided plot range is in a valid format *)
	safePlotRange=If[MatchQ[unresolvedPlotRange,validPlotRangePattern],
		unresolvedPlotRange,
		Message[Warning::InvalidRangeSpecification,unresolvedPlotRange];
		Automatic
	];

	safeOps = SafeOptions[resolvePlotRange, ToList[ops]];

	(* find extremes of epilog data *)
	(*{{xminRawEps,xmaxRawEps}, {yminRawEps,ymaxRawEps}} = epilogExtremes[eps];*)

	(* get any points from epilog Lines *)
	epilogPts = Flatten[Cases[eps,Line[pts_]:>pts,Infinity],1];

	(* append those to the data we use to find plot ranges *)
	xysNumericEps = Join[xysNumeric, {epilogPts}];

	(*
		resolve xmin & xmax first, then use those to filter out the points to use to resolve ymin & ymax
	*)

	{xminRaw,xmaxRaw} = minMaxPatch[Flatten[xysNumericEps,1][[;;,1]]];
	(* adjust based on epilog extremes *)
	(*xminRaw = Min[{xminRaw,xminRawEps}];*)
	(*xmaxRaw = Max[{xmaxRaw,xmaxRawEps}];*)

	{xrange,yrange} = Replace[safePlotRange,{Full->{Full,Full},All->{All,All},Automatic->{Automatic,Automatic}}];

	{xmin,xmax} = Replace[xrange,{Full->{Full,Full},All->{All,All},Automatic->{Automatic,Automatic}}];

	xmin = resolveOnePlotRangeValue[xmin,Min,xUnit,xminRaw];
	xmax = resolveOnePlotRangeValue[xmax,Max,xUnit,xmaxRaw];
	(* If no primary data, leave x-range unresolved *)

	(* flip x-range if Reflected\[Rule]True && given explicit numerical values *)
	If[MatchQ[{OptionValue[Reflected],xrange},{True,{NumericP,NumericP}}],
		{xmin,xmax} = {-xmax,-xmin};
	];

	{xmin,xmax} = fixInfiniteRangeValues[{xmin,xmax},{Automatic,Automatic}];

	{yminRaw,ymaxRaw} = With[
		{flatxys=Flatten[xysNumericEps,1]},If[And[!MatchQ[flatxys,{}],MatchQ[flatxys[[1,1]],oneDateP]],
		(* doing this because date comparisons are super slow on big lists *)
		minMaxPatch[Select[MapAt[AbsoluteTime,flatxys,{;;,1}],AbsoluteTime[xmin]<=First[#]<=AbsoluteTime[xmax]&][[;;,2]]],
		minMaxPatch[Select[flatxys,xmin<=First[#]<=xmax&][[;;,2]]]
	]];

	(*yminRaw = Min[{yminRaw,yminRawEps}];*)
	(*ymaxRaw = Max[{ymaxRaw,ymaxRawEps}];*)

	{ymin,ymax} = Replace[yrange,{Full->{Full,Full},All->{All,All},Automatic->{Automatic,Automatic}}];

	ymin = resolveOnePlotRangeValue[ymin,Min,yUnit,yminRaw];
	ymax = resolveOnePlotRangeValue[ymax,Max,yUnit,ymaxRaw];
	(* if no primary data, set y-range to something arbitrary *)
	{ymin,ymax} = fixInfiniteRangeValues[{ymin,ymax},{0,1}];

	xoffset = (xmax-xmin) * (Lookup[safeOps,ScaleX]-1);
	yoffset = (ymax-ymin) * (Lookup[safeOps,ScaleY]-1);

	{
		{xmin-xoffset,xmax+xoffset},
		{ymin-yoffset,ymax+yoffset}
	}

];


fixInfiniteRangeValues[{-Infinity,Infinity},default:{min_,max_}]:=default;
fixInfiniteRangeValues[{xmin_,xmax_},default_]:={xmin,xmax};


(* ::Text:: *)
(*1D*)


(*
	Base case takes list of traces b/c want to find range when all traces overlaid on same plot
*)
resolvePlotRange[unresolvedPlotRange_,xys_,{targetUnitX_,targetUnitY_},eps_,ops:OptionsPattern[]]:=Module[
	{safePlotRange,xysNumeric, safeOps,xrange,yrange,ymin,ymax,yoffset,yminRaw,ymaxRaw,xmin,xmax},


	(* Check if the provided plot range is in a valid format *)
	safePlotRange=If[MatchQ[unresolvedPlotRange,validPlotRangePattern],
		unresolvedPlotRange,
		Message[Warning::InvalidRangeSpecification,unresolvedPlotRange];
		Automatic
	];

	xysNumeric = DeleteCases[xys,Null,{3}];
	safeOps = SafeOptions[resolvePlotRange, ToList[ops]];

	{xrange,yrange} = Replace[safePlotRange,{Full->{Full,Full},All->{All,All},Automatic->{Automatic,Automatic}}];

	{yminRaw,ymaxRaw} = minMaxPatch[Flatten[xysNumeric,1]];

	{xmin,xmax} = Replace[xrange,{Full->{Full,Full},All->{All,All},Automatic->{Automatic,Automatic}}];
	{ymin,ymax} = Replace[yrange,{Full->{Full,Full},All->{All,All},Automatic->{Automatic,Automatic}}];

(*	ymin = resolveOnePlotRangeValue[ymin,Min,targetUnit,yminRaw];*)
	(* Leave Automatic as the default and let it get resolved later by the plot function.  It will do a better job than we can here. *)
	ymin = resolveOnePlotRangeValue[ymin,Min,targetUnitY,Automatic];
	ymax = resolveOnePlotRangeValue[ymax,Max,targetUnitY,Automatic];

	(* Leave Automatic as the default and let it get resolved later by the plot function.  It will do a better job than we can here. *)
	xmin = resolveOnePlotRangeValue[xmin,Min,targetUnitX,Automatic];
	xmax = resolveOnePlotRangeValue[xmax,Max,targetUnitX,Automatic];

	{{xmin,xmax},{ymin,ymax}}

];


resolveOnePlotRangeValue[val:(All|Full), f:(Min|Max),targetUnit_, Automatic]:= val;
resolveOnePlotRangeValue[val:(All|Automatic), f:(Min|Max),targetUnit_, extreme_]:= extreme;
resolveOnePlotRangeValue[val:(Full), f:(Min|Max),targetUnit_, extreme_]:= f[{0*extreme,extreme}];
resolveOnePlotRangeValue[val:NumericP|_DateObject, f:(Min|Max),targetUnit_, extreme_]:= val;
resolveOnePlotRangeValue[val_, f:(Min|Max),targetUnit:Automatic, extreme_]:= val;
resolveOnePlotRangeValue[val_, f:(Min|Max),targetUnit_, extreme_]:= Unitless[quietCheckConvert[resolvePlotRange,val,targetUnit,"PlotRange option"]];


(*
	Reverse mapping definition
*)
resolvePlotRange[unresolvedPlotRange_,xy:(CoordinatesP|_?QuantityMatrixQ),eps_,ops:OptionsPattern[]]:=
	resolvePlotRange[unresolvedPlotRange,{xy},eps,ops];



epilogExtremes[eps_]:=With[
	{xypts=Flatten[Cases[eps,Line[pts_]:>pts,Infinity],1]},
	If[MatchQ[xypts,{}],
		{{Infinity,-Infinity},{Infinity,-Infinity}},
		CoordinateBounds[xypts]
	]
];


(* ::Subsubsection:: *)
(*resolveFrame*)


DefineUsage[resolveFrame,
{
	BasicDefinitions->
		{
			{"resolveFrame[unresolvedFrame,secondYData]","frameSpec","expands 'unresolvedFrame' into a fully resolved frame specification for a plot."}
		},
	MoreInformation->{
		"Top frame Automatic resolves to False.",
		"Bottom frame Automatic resolves to True.",
		"Left frame Automatic resolves to True.",
		"Right frame Automatic resolves to True if 'secondYData' is not empty, otherwise resolves to False."
	},
	Input:>
		{
			{"unresolvedFrame",Pattern,"An unresolved frame specification."},
			{"secondYData",{(CoordinatesP|QuantityCoordinatesP[])...},"Data for second-y axis.  This is used to determine whether or not to include the right frame."}
		},
	Output:>
		{
			{"frameSpec",{{BooleanP,BooleanP},{BooleanP,BooleanP}},"Fully resolved Frame specification, in the form of {{left,right},{bottom,top}}."}
		},
	SeeAlso->
		{
			"resolvePlotLegends",
			"resolveFrameLabel"
		},
	Author->{"brad"}
}];


(*
	Resolve to {{left,right},{bottom,top}}
*)

resolveFrame[unresolvedFrame_?frameSpecQ,secondY_]:=Module[{bottom,left,top,right},

	{{left,right},{bottom,top}} = expandFrameOption[unresolvedFrame];

	(* resolve left to True *)
	left = Replace[left, Automatic->True];

	(* resolve bottom to True *)
	bottom = Replace[bottom, Automatic->True];

	(* resolve Top to False *)
	top = Replace[top, Automatic->False];

	(* resolve right based on second-y data *)
	If[MatchQ[right,Automatic],
		right = If[MatchQ[secondY,{}|Null],
			False,
			True
		];
	];

	{{left,right},{bottom,top}}

];


frameElementQ[True|False|Automatic|None]:=True;
frameElementQ[_]:=False;


frameSpecQ[_?frameElementQ]:=True;
frameSpecQ[{{_?frameElementQ,_?frameElementQ},{_?frameElementQ,_?frameElementQ}}]:=True;
frameSpecQ[{__?frameElementQ}]:=True;
frameSpecQ[_]:=False;


expandFrameOption[f_?frameElementQ]:={{f,f},{f,f}};
expandFrameOption[{l__?frameElementQ}]:=Module[{bottom,left,top,right},
	{bottom,left,top,right}=Take[{l,l,l,l},4];
	{{left,right},{bottom,top}}
];
expandFrameOption[f:{{_?frameElementQ,_?frameElementQ},{_?frameElementQ,_?frameElementQ}}]:=f;
expandFrameOption[_]:=$Failed;


(* ::Subsubsection:: *)
(*rawToPacket*)


DefineUsage[rawToPacket,{
	BasicDefinitions->
		{
			{"rawToPacket[rawData]","plot","reformats raw data so that it may be used by a plot's core packet definition."}
		},
	MoreInformation->{
		"This converts rawData into an option for the parent plot function and creates an appropriate number of null packets based on the rawData specified.",
		"In order to allow the user maximum flexibility when specifying their data, the function will pad the input as necessary, however this relies on proper specification of the PrimaryData option.",
		"The data can also be arbitrarily nested as long as there are core lists of coordinates containing the expected set of primary data traces.",
		"If the data cannot be sensibly padded, a message will be thrown and execution will cease."
	},
	Input:>
		{
			{"rawData",ListableP[CoordinatesP,2] | ListableP[QuantityArrayP[],2],"A list of coordinates."}
		},
	Output:>
		{
			{"plot",ZoomableP|_Graphics|_Legended,"A figure, which chould have a legend and could be zoomable."}
		},
	SeeAlso->
		{
			"ListLinePlot",
			"EmeraldListLinePlot",
			"packetToELLP"
		},
	Author->{"hayley", "mohamad.zandian"}
}];


(* Map over inner lists when specified *)
rawToPacket[rawPrimaryData:ListableP[CoordinatesP,2] | ListableP[QuantityArrayP[],2],typ:TypeP[],plotFunction:_Symbol,ops:{(_Rule|_RuleDelayed)..}]:=(rawToPacket[#,typ,plotFunction,ReplaceRule[ops,Map->False]]&/@rawPrimaryData)/;(Map/.ops);
rawToPacket[rawPrimaryData:ListableP[CoordinatesP,2] | ListableP[QuantityArrayP[],2],typ:TypeP[],plotFunction:_Symbol,ops:{(_Rule|_RuleDelayed)..}]:=Module[
	{primaryDataOptions,allTraces,tracesPerPacket,primaryData,primaryDataRules,numPacketsNeeded,infs, primaryMultipleQ,
		flatPrimaryData},

	(* Get the option which will indicate if there is multiple primary data *)
	primaryDataOptions = Flatten[ToList[Lookup[ops, PrimaryData]]];
	allTraces = Cases[{rawPrimaryData}, CoordinatesP | QuantityArrayP[], Infinity];

	(* figure out if each PrimaryData field is a multiple or not *)
	primaryMultipleQ = Map[
		MatchQ[Lookup[LookupTypeDefinition[typ, #], Format], Multiple]&,
		primaryDataOptions
	];

	(* total traces = number of packets * traces per packet *)
	tracesPerPacket = Length[primaryDataOptions];
	numPacketsNeeded = Length[allTraces] / tracesPerPacket;

	(* Need to pad data so that it is appropriately listed for the 'multiple primary data fields' case and the single primary data fields case *)
	(* General cases is to create multiple packets for multiple primary data => {{t1,t2,...},{T1,T2,..},..}. For single data and packet, then collapses to {{t1}} *)

	primaryData = Switch[{tracesPerPacket, rawPrimaryData, numPacketsNeeded},
		(*If only one primary data field, just get a flat list of all traces, then pad*)
		{1, _, _}, {allTraces},
		(* If there are multiple primary data fields and a single object, but only given a flat list, map across *)
		{_, _, 1}, {#}& /@ allTraces,
		(* In any other circumstance, allow an arbitrarily nested list, with core groups by 'object' *)
		{_, _, _}, Select[rawPrimaryData, MatchQ[#, ConstantArray[(CoordinatesP | QuantityArrayP[] | Null), tracesPerPacket]]&]
	];

	(* Data should be grouped by 'object' : e.g. {{obj1Data1,obj1Data2},{obj2Data1,obj2Data2}} - Transpose when plotting multiple primary data*)

	primaryData = If[(numPacketsNeeded > 1 && Length[primaryDataOptions] > 1),
		Transpose[primaryData],
		primaryData
	];

	(* If we were unable to resolve the primary data appropriately, throw a message to the user and do not call the next plot function *)
	If[MatchQ[tracesPerPacket, Length[primaryData]],
		(* Associate the input values with the primary data options *)
		primaryDataRules = MapThread[(#1 -> #2)&, {primaryDataOptions, primaryData}];

		(* Generate null packets *)
		infs = Table[Association[Type -> typ, Units -> LegacySLL`Private`typeUnits[typ]], numPacketsNeeded];

		(* Call the packet definition *)
		plotFunction[infs, ReplaceRule[ToList[ops],primaryDataRules]],

		Message[Error::InvalidPrimaryDataSpecification];
		Return[$Failed];
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveFrameTicks*)


(*
	Resovle to {{left,right},{bottom,top}}
*)
frameTickP=True|False|_List|_Charting`ScaledTicks|None;

(* expand frame tick list to 4 paired elements *)
resolveFrameTicks[val:(Automatic|None),secondYTicks_,reflectedBottomTicks_,scale_]:=resolveFrameTicks[{{val,val},{val,val}},secondYTicks,reflectedBottomTicks,scale];

(* left frame *)
resolveFrameTicks[frameTicks:{{a:Automatic,b_},{c_,d_}},secondYTicks_,reflectedBottomTicks_,scale:(Log|LogLog|LinearLog)]:=resolveFrameTicks[{{Charting`ScaledTicks[{Log10,10.`^#1&}],b},{c,d}},secondYTicks,reflectedBottomTicks,scale];
resolveFrameTicks[frameTicks:{{a:Automatic,b_},{c_,d_}},secondYTicks_,reflectedBottomTicks_,scale_]:=resolveFrameTicks[{{True,b},{c,d}},secondYTicks,reflectedBottomTicks,scale];
(* right frame *)
resolveFrameTicks[frameTicks:{{a:frameTickP,b:Automatic},{c_,d_}},secondYTicks:({}|Null),reflectedBottomTicks_,scale_]:=resolveFrameTicks[{{a,False},{c,d}},secondYTicks,reflectedBottomTicks,scale];
resolveFrameTicks[frameTicks:{{a:frameTickP,b:Automatic},{c_,d_}},secondYTicks_,reflectedBottomTicks_,scale_]:=resolveFrameTicks[{{a,secondYTicks},{c,d}},secondYTicks,reflectedBottomTicks,scale];
(* bottom ticks *)
resolveFrameTicks[frameTicks:{{a:frameTickP,b:frameTickP},{c:Automatic,d_}},secondYTicks_,reflectedBottomTicks:Null,scale_]:=resolveFrameTicks[{{a,b},{True,d}},secondYTicks,reflectedBottomTicks,scale];
resolveFrameTicks[frameTicks:{{a:frameTickP,b:frameTickP},{c:Automatic,d_}},secondYTicks_,reflectedBottomTicks:Null,scale:(LogLog|LogLinear)]:=resolveFrameTicks[{{a,b},{Charting`ScaledTicks[{Log10,10.`^#1&}],d}},secondYTicks,reflectedBottomTicks,scale];
resolveFrameTicks[frameTicks:{{a:frameTickP,b:frameTickP},{c:Automatic,d_}},secondYTicks_,reflectedBottomTicks_,scale_]:=resolveFrameTicks[{{a,b},{reflectedBottomTicks,d}},secondYTicks,reflectedBottomTicks,scale];
(* top ticks *)
resolveFrameTicks[frameTicks:{{a:frameTickP,b:frameTickP},{c:frameTickP,Automatic}},secondYTicks_,reflectedBottomTicks_,scale_]:=resolveFrameTicks[{{a,b},{c,False}},secondYTicks,reflectedBottomTicks,scale];
(* all done *)
resolveFrameTicks[frameTicks:{{frameTickP,frameTickP},{frameTickP,frameTickP}},secondYTicks_,reflectedBottomTicks_,scale_]:=frameTicks;



(* ::Subsubsection::Closed:: *)
(*resolveFrameTicksChart*)


(*
	Resovle to {{left,right},{bottom,top}}
*)

(* just leave it alone *)
resolveFrameTicksChart[frameTicks_]:=frameTicks;


(* ::Subsubsection:: *)
(*resolveFrameLabel*)


defaultLabelColor=GrayLevel[0.3];
resolveFrameLabel[Automatic,{},{},Null, Null,ops:OptionsPattern[]]:= Null;


(*
		Resolve to {{left,right},{bottom,top}}
*)
(*Options[resolveFrameLabel]={LabelColor->defaultLabelColor,DefaultLabel\[Rule]None};*)
resolveFrameLabel[unresolvedFrameLabels_,frameUnits_,primaryUnits:{xUnit_,yUnit_},secondaryUnit_,ops:OptionsPattern[]]:=
	resolveFrameLabel[unresolvedFrameLabels,frameUnits,primaryUnits,secondaryUnit,defaultLabelColor,ops];
resolveFrameLabel[unresolvedFrameLabels_,frameUnits_,primaryUnits:{xUnit_,yUnit_},secondaryUnit_,secondaryColor_,OptionsPattern[]]:=Module[
	{left,right,bottom,top,secondaryYUnit,leftUnit,rightUnit,topUnit,bottomUnit,leftLabel,rightLabel,topLabel,bottomLabel},

	{{leftLabel,rightLabel},{bottomLabel,topLabel}} = expandFrameLabelOption[unresolvedFrameLabels];

	secondaryYUnit = Switch[secondaryUnit,
		{_?UnitsQ,_?UnitsQ},  Last[secondaryUnit],
		_?UnitsQ, secondaryUnit,
		_, Null
	];

	{{leftUnit,rightUnit},{bottomUnit,topUnit}} = expandOptionToTwoLists[frameUnits,Automatic|_?UnitsQ|None|True|False];

	(* resolve unit automatics based on data units *)
	bottomUnit = Replace[bottomUnit,{Automatic->xUnit,None|False->Null}];
	leftUnit = Replace[leftUnit,{Automatic->yUnit,None|False->Null}];
	rightUnit = Replace[rightUnit,{Automatic->secondaryYUnit,None|False->Null}];
	topUnit = Null;

	(* resolve label automatics based on unit dimension *)
	bottomLabel = With[{tmp = Replace[bottomLabel,{Automatic->safeUnitDimension[bottomUnit],None|False->""}]},
					If[MatchQ[yUnit, AbsorbanceUnit] && MatchQ[tmp, "Distance"],
						"Wavelength",
						tmp
					]
				];

	leftLabel = Replace[leftLabel,{Automatic->safeUnitDimension[leftUnit],None|False->""}];
	rightLabel = Replace[rightLabel,{Automatic->safeUnitDimension[rightUnit],None|False->""}];
	topLabel = Replace[topLabel,{Automatic|None|False->""}];

	(* join labels and units *)
	left = constructFrameLabel[leftLabel,leftUnit,defaultLabelColor];
	right = constructFrameLabel[rightLabel,rightUnit,secondaryColor];
	bottom = constructFrameLabel[bottomLabel,bottomUnit,defaultLabelColor];
	top = constructFrameLabel[topLabel,topUnit,defaultLabelColor];

	{{left,right},{bottom,top}}

];

constructFrameLabel[Automatic,unit:Null,color_]:=makeFrameLabel["",unit,color];
constructFrameLabel[Automatic,unit_?UnitsQ,color_]:=makeFrameLabel[UnitDimensions[unit],unit,color];
constructFrameLabel[Null,unit_,color_]:="";
constructFrameLabel[label:(_String|_Row|_Style),unit_,color_]:=makeFrameLabel[label,unit,color];


safeUnitDimension[Null|Automatic]:="";
safeUnitDimension[1]:="";
safeUnitDimension[other_]:=UnitDimension[other];


makeFrameLabel[label_String,unit_Quantity,color_?ColorQ]:=
	Style[
		StringJoin[
			label,
			" ",
			UnitForm[unit,Number->False,Metric->False]
		],
		color
	];
makeFrameLabel[label_String,unit_,color_?ColorQ]:=
	Style[
		label,
		color
	];

makeFrameLabel[preStyled_Row,unit_,color_]:=preStyled;
makeFrameLabel[preStyled_Style,unit_,color_]:=preStyled;

makeFrameLabel[___]:=("");


frameLabelElementQ[True|False|Automatic|None|_String|_Style|_Row]:=True;
frameLabelElementQ[_]:=False;


frameLabelSpecQ[_?frameLabelElementQ]:=True;
frameLabelSpecQ[{{_?frameLabelElementQ,_?frameLabelElementQ},{_?frameLabelElementQ,_?frameLabelElementQ}}]:=True;
frameLabelSpecQ[{__?frameLabelElementQ}]:=True;
frameLabelSpecQ[_]:=False;


expandFrameLabelOption[f_?frameLabelElementQ]:={{f,f},{f,f}};
expandFrameLabelOption[{l__?frameLabelElementQ}]:=Module[{bottom,left,top,right},
	{bottom,left,top,right}=Take[{l,l,l,l},4];
	{{left,right},{bottom,top}}
];
expandFrameLabelOption[f:{{_?frameLabelElementQ,_?frameLabelElementQ},{_?frameLabelElementQ,_?frameLabelElementQ}}]:=f;
expandFrameLabelOption[in_]:=$Failed;


(* ::Subsubsection::Closed:: *)
(*resolveAxesLabel*)


defaultLabelColor=GrayLevel[0.3];


(*
		Resolve to {x,y,z}
*)
resolveAxesLabel[unresolvedFrameLabels_,axesUnits_,primaryUnits:{xUnit0_,yUnit0_,zUnit0_}]:=Module[
	{xLabel,yLabel,zLabel,xUnit,yUnit,zUnit},

	{xLabel,yLabel,zLabel} = PadRight[ToList[unresolvedFrameLabels],3,Automatic];
	{xUnit,yUnit,zUnit} = PadRight[ToList[axesUnits],3,Automatic];

	(* resolve unit automatics based on data units *)
	xUnit = Replace[xUnit,{Automatic->xUnit0,None|False->Null}];
	yUnit = Replace[yUnit,{Automatic->yUnit0,None|False->Null}];
	zUnit = Replace[zUnit,{Automatic->zUnit0,None|False->Null}];

	(* resolve label automatics based on unit dimension *)
	xLabel = Replace[xLabel,{Automatic->safeUnitDimension[xUnit],None|False->""}];
	yLabel = Replace[yLabel,{Automatic->safeUnitDimension[yUnit],None|False->""}];
	zLabel = Replace[zLabel,{Automatic->safeUnitDimension[zUnit],None|False->""}];

	(* join labels and units *)
	xLabel = constructFrameLabel[xLabel,xUnit,defaultLabelColor];
	yLabel = constructFrameLabel[yLabel,yUnit,defaultLabelColor];
	zLabel = constructFrameLabel[zLabel,zUnit,defaultLabelColor];

	{xLabel,yLabel,zLabel}

];


(* ::Subsubsection:: *)
(*formatPlotLegend*)


DefineUsage[formatPlotLegend,
{
	BasicDefinitions->
		{
			{"formatPlotLegend[labels]","legend","formats a legend specification for the PlotLegends option."}
		},
	MoreInformation->{""},
	Input:>
		{
			{"labels",{_String..},"Labels for the legend."}
		},
	Output:>
		{
			{"legend",_Placed,"Legend specification that can be used as a value for the PlotLegends option in a plotting function."}
		},
	SeeAlso->
		{
			"PlotLegends",
			"PlotWestern",
			"resolvePlotRange"
		},
	Author->{"brad"}
}];

DefineOptions[formatPlotLegend,
	Options:>{
		{LegendPlacement->Bottom,Right|Left|Top|Bottom,"Positioning of legend relative to plot."},
		{Boxes->False,True|False,""},
		{PlotMarkers->Automatic,_,""},
		{LegendColors->Automatic,Automatic|_,""},
		{LegendLabel->None,_,""}
	}
];


formatPlotLegend[labels:{{(_String|_Style|_Image|_Graphics|Null)..}..},rest___]:=
	formatPlotLegend[Flatten[labels],rest];
formatPlotLegend[labels:{(_String|_Style|_Image|_Graphics|Null)..},numObjects_Integer,numPrimaryPer_Integer,ops:OptionsPattern[]]:=Module[
	{placement,legendType,labelsFormatted,markers,lineColors,safeOps,posKeep,defaultLineColors,unresolvedLineColors,label},

	safeOps = SafeOptions[formatPlotLegend, ToList[ops]];

	(* make legend colors and format *)
	(* if given style, make sure it has a color in it *)
	defaultLineColors = resolvePlotStyle[Automatic,numObjects,numPrimaryPer];
	lineColors=Lookup[safeOps,LegendColors];

	unresolvedLineColors = Lookup[safeOps,LegendColors];
	lineColors = Switch[unresolvedLineColors,
		Automatic,
			unresolvedLineColors,
		_,
			MapThread[If[MatchQ[#2,_RGBColor],#2,Directive[#1,#2]]&,{defaultLineColors,PadRight[ToList[unresolvedLineColors],Length[defaultLineColors],Null]}]
	];

	placement = Lookup[safeOps,LegendPlacement];

	legendType = Switch[Lookup[safeOps,Boxes],
		True, SwatchLegend,
		False, LineLegend
	];

	markers=Lookup[safeOps,PlotMarkers];
	label=Lookup[safeOps,LegendLabel];

	labelsFormatted = Map[Style[#,12]&,labels];

	posKeep = Select[Flatten[Position[labels,Except[Null,_String|_Style|_Image|_Graphics],{1}]],#<=Min[{Length[labels],If[MatchQ[lineColors,_List],Length[lineColors],Infinity]}]&];

	If[lineColors===Automatic,
		Placed[legendType[Automatic,labelsFormatted[[posKeep]],LegendMarkers->markers,LegendLabel->label],placement],
		Placed[legendType[lineColors[[posKeep]],labelsFormatted[[posKeep]],LegendMarkers->markers,LegendLabel->label],placement]
	]

];

(* empty case, resolve to None.  Some plots/charts can't handle empty list *)
formatPlotLegend[None|{}|NullP|Automatic,___]:=None;
formatPlotLegend[labels_LineLegend, ___] := labels;
formatPlotLegend[___]:=None;


(* ::Subsubsection::Closed:: *)
(*autoResolvePlotLabel*)


(* Called by packetToELLP to resolve automatic labeling *)
autoResolvePlotLabel[labels:(_String|{_String..}),labelStyle_List,imageSize_]:=Module[{labelText},
	(* If resolving for raw case, just show type *)
	labelText=Switch[ToExpression[labels],
		ObjectP[Object[Data]]|{ObjectP[Object[Data]]..},
			Switch[labels,
				(* Label is the string supplied *)
				_String, labels,

				(* Label is a nicely formatted string list *)
				_?(Length[#]<3&),StringJoin[Riffle[labels,", "]],

				(* Label is first and last item with tooltip giving full information *)
				_,Tooltip[StringJoin[Riffle[Part[Sort[labels],{1,-1}],"..."]],StringJoin[Riffle[labels,", "]]]
			],
		Null|{Null...},
			Return[Null],
		_,
			ToString[First[Flatten[{ToExpression[labels][Type]}]]]
	];

	Pane[Style[labelText,Sequence@@labelStyle],{imageSize,All},Alignment->Center]
];


(* ::Subsubsection::Closed:: *)
(*autoResolveLegend*)


(* Called by packetToELLP to resolve automatic legending *)
(* Multiple objects plotted *)
autoResolveLegend[myPackets:{packetOrInfoP[]..},linkedLength:_Integer,ops:_Association]:=Module[
	{linkedName,baseNames,linkedUpdates,linkedIds,rawLegend, primaryData, type, primaryMultipleQ},

	linkedName = Lookup[ops, LinkedObjects];

	(* figure out if each PrimaryData field is a multiple or not *)
	primaryData = Lookup[ops, PrimaryData, {}];
	type = Lookup[First[myPackets], Type];
	primaryMultipleQ = Map[
		MatchQ[Lookup[LookupTypeDefinition[type, #], Format], Multiple]&,
		primaryData
	];

	(* Legend is in the form "object#: PrimaryDataField#" if there are multiple objects, in the form "PrimaryDataField...", if there are multiple primary traces and only one object. If PrimaryData contains a single field and a single object, no legend *)
	(* gets a little goofy if we are dealing with a PrimaryData field that is a multiple field; basically we want each individual scan (or something more generic if someone else ever needs this for non-DSC experiments) to have its own legend entry *)
	baseNames = Flatten[Which[
		MatchQ[myPackets, {PacketP[Object[Data], {Object}]..}] && MatchQ[primaryMultipleQ, {True..}],
			Map[
				Function[packet,
					If[Length[Lookup[packet, First[primaryData]]] > 1,
						Table[ToString[Lookup[packet, Object]] <> " Scan " <> ToString[scanNum], {scanNum, 1, Length[Lookup[packet, First[primaryData]]]}],
						Lookup[packet, Object]
					]
				],
				myPackets
			],
		MatchQ[myPackets, {PacketP[Object[Data], {Object}]..}], Lookup[myPackets, Object],
		True, Table["Data Set " <> ToString[num], {num, 1, Length[myPackets]}]
	]];

	linkedUpdates = (ToString[#]<>" : ")&/@Flatten[ConstantArray[linkedName,linkedLength]];
	linkedIds = If[linkedLength>0,
		Join[ConstantArray["Analyte : ",Length[baseNames]-linkedLength],linkedUpdates],
		ConstantArray["",Length[baseNames]]
	];

	(* put together the legend based on how many data objects there are and how many PrimaryData fields there are *)
	(* essentially, you want a legend if you have multiple objects, multiple scans per object, or multiple PrimaryData fields, but NOT if you just have one field, one scan, and one object *)
	rawLegend = Which[
		Length[primaryData] > 1 && Length[baseNames] > 1,
			MapThread[
				Function[{baseName, linkedID},
					Map[
						StringJoin[ToString[linkedID]," ",ToString[#],": ",ToString[baseName]]&,
						primaryData
					]
				],
				{baseNames, linkedIds}
			],
		Length[baseNames] > 1,
			MapThread[
				ToString[#1] <> ToString[#2]&,
				{linkedIds, baseNames}
			],
		Length[primaryData] > 1,
			ToString[#]& /@ primaryData,
		True, Null
	]
];



(* ::Subsubsection::Closed:: *)
(*EmeraldTheme*)


Themes`AddThemeRules["EmeraldTheme",
	AlignmentPoint->Center,
	AspectRatio->1/GoldenRatio,
	Axes->False,
	AxesLabel->None,
	AxesOrigin->Automatic,
	AxesStyle->{},
	Background->None,
	BaselinePosition->Automatic,
	BaseStyle->{},
	Frame->{True,True,False,False},
	LabelStyle->{Bold,14,FontFamily->"Arial"},
	(* Must be evaluated: PlotStyle->  Directive[ColorData[97][#],Thick]&/@Range[10] *)
	PlotStyle-> {Directive[RGBColor[0.368417, 0.506779, 0.709798],Thickness[Large]],Directive[RGBColor[0.880722, 0.611041, 0.142051],Thickness[Large]],Directive[RGBColor[0.560181, 0.691569, 0.194885],Thickness[Large]],Directive[RGBColor[0.922526, 0.385626, 0.209179],Thickness[Large]],Directive[RGBColor[0.528488, 0.470624, 0.701351],Thickness[Large]],
			Directive[RGBColor[0.772079, 0.431554, 0.102387],Thickness[Large]],Directive[RGBColor[0.363898, 0.618501, 0.782349],Thickness[Large]],Directive[RGBColor[1, 0.75, 0],Thickness[Large]],Directive[RGBColor[0.647624, 0.37816, 0.614037],Thickness[Large]],Directive[RGBColor[0.571589, 0.586483, 0.],Thickness[Large]]}
];


(* ::Subsubsection:: *)
(*resolvePlotStyle*)


defaultStyleColorFunction = ColorData[97];


(* if only one primary per object, then use the normal colors, so leave as automatic *)
resolvePlotStyle[unresolvedPlotStyle:Automatic,numObjects_,numPrimaryPer:1]:=Table[ColorData[97][index],{index,numObjects}];

(*  if more than one primary data per object, use default colors and fade them for the different primary traces *)
resolvePlotStyle[unresolvedPlotStyle:Automatic,numObjects_,numPrimaryPer_]:=Module[{},
	(*  flatten out b/c it wants a flat list.  start nested to get correct order to match primary signals *)
	Flatten[
		Map[ColorFade[defaultStyleColorFunction[#],numPrimaryPer]&,Range[numObjects]],
		1
	]

];



(* if anything else, leave as-is *)
resolvePlotStyle[unresolvedPlotStyle_,numObjects_,numPrimaryPer_]:=unresolvedPlotStyle;


(* ::Subsubsection:: *)
(*stringOptionsToSymbolOptions*)


stringOptionsToSymbolOptions[ops___]:=Sequence@@Map[
	Rule[Replace[#[[1]],s_String:>Symbol[s]],#[[2]]]&,
	{ops}
];



(* ::Subsection::Closed:: *)
(*Replicates & Errors*)


(* ::Subsubsection::Closed:: *)
(*errorBarsXY*)


errorBarsXY[pts:{{_,_}...},xstds:{___},ystds:{___},plotRange_,color_]:=
    DeleteCases[MapThread[errorBarXY[#1,#2,#3,plotRange,color]&,{pts,xstds,ystds}],{}];

errorBarXY[{x_,y_},0|0.|ListableP[Null],0|0.|ListableP[Null],plotRange_,color_]:={};

errorBarXY[{x_,y_},0|0.|ListableP[Null],dy_,plotRange_,color_]:=
		ErrorBar[{{x,y},dy},Color->color,PlotRange->plotRange,Orientation->Vertical,Ticks->0.015];

errorBarXY[{x_,y_},dx_,0|0.|ListableP[Null],plotRange_,color_]:=
		ErrorBar[{{x,y},dx},Color->color,PlotRange->plotRange,Orientation->Horizontal,Ticks->0.015];

errorBarXY[{x_,y_},dx_,dy_,plotRange_,color_]:=Module[{},
	Join[
		ErrorBar[{{x,y},dx},Color->color,PlotRange->plotRange,Orientation->Horizontal,Ticks->0.015],
		ErrorBar[{{x,y},dy},Color->color,PlotRange->plotRange,Orientation->Vertical,Ticks->0.015]
	]
];



(* ::Subsubsection::Closed:: *)
(*processReplicates*)


(* ::Text:: *)
(*2D*)


processReplicates[in_List,errorBarsBool_,errorType_,dim:2]:=Module[{paired,newData,ebars},

	paired=Map[
		If[MatchQ[#,_Replicates],
			Lookup[processOneReplicates[#],{Mean,errorType/.{StandardDeviation->ErrorBars,StandardError->StandardErrorBars}}],
			{#,{}}
		]&,
		in,
		{2}
	];

	(* special Transpose b/c of extra list nesting on the data *)
	{newData,ebars}=Transpose[paired,{2,3,1}];
	ebars=MapIndexed[Replace[#1,_?ColorQ->ColorData[97][First[#2]],{3}]&,ebars];
	If[!errorBarsBool, ebars={}];
	{newData,ebars}
];


(* ::Text:: *)
(*1D*)


processListDataReplicates2[in_List,errorBarsBool_,errorType_]:=Module[
	{paired,newData,ebars,dists},
	paired=Map[processListDataReplicates1[#,errorBarsBool,errorType]&,in];
	newData = paired[[;;,1]];
	ebars = paired[[;;,2]];
	dists = paired[[;;,3]];
	If[!errorBarsBool,
		ebars=ConstantArray[{},Dimensions[newData]];
		dists = ConstantArray[{},Dimensions[newData]];
	];
	{newData,ebars,dists}
];

processListDataReplicates1[in:Null,errorBarsBool_,errorType_]:={Null,{},Null};
processListDataReplicates1[in_,errorBarsBool_,errorType_]:=Module[{paired},
	paired=Map[
		If[MatchQ[#,_Replicates|_PlusMinus|_?DistributionParameterQ],
			Lookup[processOneReplicates[#],{Mean,errorType,Distribution}],
			{#,{},{}}
		]&,
		in
	];
	Transpose[paired]
];


(* ::Text:: *)
(*helpers*)


processOneReplicates[Replicates[args___]]:=Module[{stats},
	Switch[{args},
		{NumericP..},
			processOneReplicatesNumberList[{args}],
		{CoordinatesP..},
			processOneReplicatesCoordinates[{args}],
		{dateCoordinatesP..},
				processOneReplicatesCoordinates[{args}],
		{{_?NumericQ..}..},
			processOneReplicatesLists[{args}],
		_,
			Message[processOneReplicates::ShouldNotReachThis]
	]

];


processOneReplicates[other_]:=Module[{stats},
	Switch[other,
		_PlusMinus,
			processOnePlusMinus[other],
		_?DistributionParameterQ,
			processOneDistribution[other],
		_,
			Message[processOneReplicates::ShouldNotReachThis]
	]

];


processOneReplicatesCoordinates[coordsLists_]:=Module[{},
	If[SameQ@@coordsLists[[;;,;;,1]],
		processOneReplicatesCoordinatesUniformX[coordsLists],
		Message[processReplicates::NonUniformXValues]
	]
];

processOneReplicatesCoordinatesUniformX[coordsLists_]:=Module[
	{xvals,yvals,mean,stdDev,stdErr,errBars,stdErrBars},
	xvals = coordsLists[[1,;;,1]];
	mean = Mean[coordsLists[[;;,;;,2]]];
	stdDev = safeStandardDeviationList[coordsLists[[;;,;;,2]]];
	stdErr = stdDev/Sqrt[Length[coordsLists]];
	errBars = ErrorBar[MapThread[{{#1,#2},#3}&,{xvals,mean,stdDev}]];
	stdErrBars=ErrorBar[MapThread[{{#1,#2},#3}&,{xvals,mean,stdErr}]];
	{Mean->Transpose[{xvals,mean}],StandardDeviation->Transpose[{xvals,stdDev}],StandardError->Transpose[{xvals,stdErr}],
		ErrorBars->errBars,StandardErrorBars->stdErrBars}
];

processOneReplicatesLists[coordsLists_]:=Module[{},
	If[SameQ@@Map[Length,coordsLists],
		processOneReplicatesListsUniformLength[coordsLists],
		Message[processReplicates::NonUniformLengths]
	]
];

processOneReplicatesListsUniformLength[numLists_]:=Module[{xvals,mean,stdDev,stdErr,errBars,stdErrBars},
	xvals = Length[First[numLists]];
	mean = Mean[numLists];
	stdDev = safeStandardDeviation[numLists];
	stdErr = stdDev/Sqrt[Length[numLists]];
	errBars = ErrorBar[MapThread[{{#1,#2},#3}&,{xvals,mean,stdDev}]];
	stdErrBars=ErrorBar[MapThread[{{#1,#2},#3}&,{xvals,mean,stdErr}]];
	{Mean->mean,StandardDeviation->stdDev,StandardError->stdErr,ErrorBars->errBars,StandardErrorBars->stdErrBars}
];




processOneReplicatesNumberList[numList_]:=Module[{n,mean,stdDev,stdErr},
	mean = Mean[numList];
	stdDev = safeStandardDeviation[numList];
	stdErr = stdDev/Sqrt[Length[numList]];
	{Mean->mean,StandardDeviation->stdDev,StandardError->stdErr,Distribution->EmpiricalDistribution[numList]}
];


processOnePlusMinus[PlusMinus[m_,s_]]:=Module[{},
	{Mean->m,StandardDeviation->s,Distribution->NormalDistribution[m,s],StandardError->s}
];


processOneDistribution[d_?DistributionParameterQ]:=Module[{m,sd,se},
	m=Mean[d];
	sd=StandardDeviation[d];
	se = safeStandardError[d];
	{Mean->m,StandardDeviation->sd,Distribution->d,StandardError->se}
];


safeStandardDeviation[{Except[_List]}]:=0;
safeStandardDeviation[list_List]:=StandardDeviation[list];

safeStandardDeviationList[{innerList_List}]:=0.*innerList;
safeStandardDeviationList[list:{_List..}]:=StandardDeviation[list];


safeStandardError[d_DataDistribution]:=StandardDeviation[d]/Sqrt[d["SampleSize"]];
safeStandardError[d_]:=StandardDeviation[d];


(* ::Subsubsection::Closed:: *)
(*chartErrorBarFunction*)


chartErrorBarFunction[type_:"Rectangle",scaling_][{{x0_,x1_},{y0_,y1_}},value_,meta_]:=Block[{errorSpec,dist,color,error,bar},
	(*
		'value' is the original value.  'y0' and 'y1' are scaling by 'scaling'
	*)
	bar = ChartElementData[type][{{x0,x1},{y0,y1}},value,meta];
	If[MatchQ[meta,{}],Return[bar]];
	errorSpec = Last[meta];
	If[MatchQ[errorSpec,{}],Return[bar]];
	{color, error, dist} = Switch[errorSpec,
		NumericP, {Black,errorSpec,value},
		{_,_}, Append[errorSpec,value],
		{_,_,_}, errorSpec,
		_, {Null,Null,Null}
	];
	If[MatchQ[error,{}], Return[bar]];
	{bar, chartErrorBar[scaling,{{x0,x1},{y0,y1}},Unitless[error],dist,color]}
];


(* ::Subsubsection::Closed:: *)
(*chartErrorBar*)


chartErrorBar[scaling:(None|Identity),{{x0_,x1_},{y0_,y1_}},error_,dist_,color_]:=With[
	{
		ybot=y1-error,
		ytop=y1+error
	},
	{
		color,
		Tooltip[
			chartErrorBarLine[{x0,x1},{ybot,ytop}],
			distributionSummary[dist,y1,error]
		]
	}
];


chartErrorBar[scaling:"Log10",{{x0_,x1_},{y0_,y1_}},error_,dist_,color_]:=With[
	{
		ylbot = Log10[10^y1-error],
		yltop = Log10[10^y1+error]
	},
	{
		color,
		Tooltip[
			Which[
				!MatchQ[N[ylbot],_Real|_Integer|_Rational],
					chartErrorBarLineTop[{x0,x1},yltop,y0],
				True,
					chartErrorBarLine[{x0,x1},{ylbot,yltop}]
			],
			distributionSummary[dist,y1,error]
		]
	}
];


chartErrorBarLine[{xLeft_,xRight_},{yBot_,yTop_}]:=
	Line[{
		{{(xLeft+xRight)/2,yBot},{(xLeft+xRight)/2,yTop}},
		{{1/4 (3 xLeft+xRight),yTop},{1/4 (xLeft+3 xRight),yTop}},
		{{1/4 (3 xLeft+xRight),yBot},{1/4 (xLeft+3 xRight),yBot}}
	}];


chartErrorBarLineTop[{xLeft_,xRight_},yTop_,yMean_]:=
	Line[{
		{{(xLeft+xRight)/2,yMean},{(xLeft+xRight)/2,yTop}},
		{{1/4 (3 xLeft+xRight),yTop},{1/4 (xLeft+3 xRight),yTop}}
	}];


(* ::Subsubsection::Closed:: *)
(*addErrorTooltips2*)


addErrorTooltips2[dataFull_,errorValues_,dists_,tooltips:(False|Null)]:=dataFull;

addErrorTooltips2[dataFull_,errorValues_,dists_,tooltips:True]:=
	MapThread[addErrorTooltips1,{dataFull,errorValues,dists}];



addErrorTooltips1[oneDataList:Null,erroValueList_,dists_]:=Null;
addErrorTooltips1[oneDataList_,erroValueList:Null,dists_]:=oneDataList;


addErrorTooltips1[oneDataList_,erroValueList_,dists_]:=
	MapThread[
		Rule[errorTooltip[#1,#2],{Black,#2,#3}]&,
		{oneDataList,erroValueList,dists}
	];


(* ::Subsubsection::Closed:: *)
(*errorTooltip*)


errorTooltip[m_,s:({}|Null)]:=Tooltip[m,Style[m,Bold,18,FontFamily->"Arial"]];
errorTooltip[m_,s_]:=Tooltip[m,Style[ToString[PlusMinus[m,s]],Bold,18,FontFamily->"Arial"]];


(* ::Subsubsection::Closed:: *)
(*distributionSummary*)


distributionSummary[dist_,m_,s_]:=Row[{distributionBlobSummary[dist,m,s],distributionBlobPicture[dist,m,s]}," "];

Authors[DistributionBlobs]:={"brad"};
distributionBlobSummary[dist_PlusMinus,_,_]:= dist;
distributionBlobSummary[dist_DataDistribution,m_,s_]:=Column[{Head[dist],Row[{"Mean: ",m}],Row[{"StandardDeviation: ",s}],Row[{"Number of Points: ",dist[[4]]}]}];
distributionBlobSummary[dist_,m_,s_]:=Column[{Head[dist],Row[{"Mean: ",m}],Row[{"StandardDeviation: ",s}]}];

distributionBlobPicture[dist_DataDistribution,m_,s_]:=With[{pts=WeightedData[dist[[2,2]],dist[[2,1]]]},Histogram[pts,LabelStyle->{},Frame->False,Axes->True]];
distributionBlobPicture[dist_,m_,s_]:=With[{pdf=safePDF[dist]},safePlotPDF[pdf,m,s]];

safePDF[dist_]:=Quiet[Check[TimeConstrained[PDF[dist],1,$Failed],$Failed]];
safePlotPDF[pdf:$Failed,m_,s_]:=Null;
safePlotPDF[pdf_,m_?NumericQ,s_?NumericQ]:=Quiet[Check[TimeConstrained[Plot[pdf[x],{x,m-3*s,m+3*s},LabelStyle->{},Frame->False,Axes->True],1,Null],Null]];
safePlotPDF[pdf_,m_,s_]:=Null;



(* ::Subsection::Closed:: *)
(*Data Padding & Checking*)


(* ::Subsubsection::Closed:: *)
(*padAndCheckData*)


invalidPrimaryDataError[f_]:=(
	Message[f::InvalidPrimaryDataSpecification];
	Throw[$Failed,"InvalidDimensions"]
);

(* boolean check for positive x-coordinate *)
positiveXCoordQ = Function[{data}, QuantityMagnitude[data[[1]]] > 0];

(* check to clean up input data *)
(* base case is to do nothing *)
cleanLogLinearData[data_, scale_, plotFunction_]:=data;
(* if the scale is log linear, remove the negative values *)
(* second level of mapping needed because data is padded to the form {{{{x,y}..}..}} *)
cleanLogLinearData[data_, LogLinear, EmeraldListLinePlot]:=Map[
    removeNonPositiveData,
    data
];

(* if input is coordinates use select to keep positive x-values, otherwise return as is *)
removeNonPositiveData[data:Alternatives[{CoordinatesP[]..}, {QuantityCoordinatesP[]..}]]:=Map[
    QuantityArray[Select[Normal[#], positiveXCoordQ]] &,
    data
];
removeNonPositiveData[data_]:=data;


padAndCheckData[f_,dataPartial_,oneTraceP_, scale_]:=Module[{dataFull,numObjects,numTracesPer},

	dataFull = padCoordinatesTo3D[dataPartial,oneTraceP,f];
    
    (* if the scale is loglinear in a list line plot, remove data points with negative x-values *)
    dataFull = cleanLogLinearData[dataFull, scale, f];

	If[!SameQ@@Map[Length,dataFull],
		invalidPrimaryDataError[f]
	];

	numObjects = Length[dataFull];
	numTracesPer = Length[First[dataFull]];

	(* other helpers can handle {} but not Null, so use that as empty case *)
	dataFull=Replace[dataFull,Null->{},{2}];

	{dataFull,numObjects,numTracesPer}

];



(* ::Subsubsection::Closed:: *)
(*padAndCheckSecondaryData*)


invalidSecondaryDataError[f_]:=(
	Message[f::InvalidSecondYSpecification];
	Throw[$Failed,"InvalidDimensions"]
);
padAndCheckSecondaryData[f_,secondY_,numObjects_,oneTraceP_]:=Module[{secondYFull,numSecondYTypes,emptyPositions},

	If[MatchQ[secondY,{}|Null|{{}}|{Null}|None],
		Return[{{},Null,{}}]
	];

	secondYFull = Which[
	(* correct format *)
		MatchQ[secondY,{({oneTraceP..}|Null)..}],
		secondY,
	(* single trace, pad two levels *)
		MatchQ[secondY,oneTraceP],
			{{secondY}},
		(* list of traces and primary input is singleton, treat as list of different second-y signals *)
		And[MatchQ[secondY,{oneTraceP..}],
			MatchQ[numObjects,1]], {secondY},
		(* treat as a single second-y for different inputs *)
		And[MatchQ[secondY,{oneTraceP..}], Greater[numObjects,1]],
			Map[List,secondY],
		True,
			invalidSecondaryDataError[f]
	];

	(* number of types of different secondY data *)
	numSecondYTypes = Max[Length/@secondYFull];
	(* use {} as place holder instead of Null *)
	secondYFull = Replace[secondYFull,Null->Table[Null,{numSecondYTypes}],{1}];
	secondYFull = Replace[secondYFull,Null->{},{2}];

	(* length of secondy must match length of primary if greater than one.  If no secondary data, user should use Null as spacers. *)
	If[!MatchQ[Length[secondYFull],numObjects]&&Length[secondYFull]!=1,
		invalidSecondaryDataError[f]
	];

	(* every secondy must have same number of subtraces.  If any don't exist, user should use Null as spacers *)
	If[!MatchQ[Length/@secondYFull,{numSecondYTypes...}],
		invalidSecondaryDataError[f]
	];

	(* delete any traces that are empty at all elements *)
	(* must do this after previous size-related error checks because Transpose will break if data is ragged *)
	emptyPositions = Position[Transpose[secondYFull],{{}...},{1}];
	secondYFull = If[MatchQ[secondYFull,{{{}..}..}],
		{},
		Transpose[DeleteCases[Transpose[secondYFull],{{}...}]]
	];

	{secondYFull,numSecondYTypes,emptyPositions}

];



(* ::Subsubsection:: *)
(*padCoordinatesTo2D*)


(* ::Subsubsection::Closed:: *)
(*padCoordinatesTo3D*)


padCoordinatesTo3D[dataPartial_,oneTraceP_,f_]:=Module[{},
	Switch[dataPartial,
		oneTraceP,
			{{dataPartial}},
		{oneTraceP..},
			Map[List,dataPartial],
		{{oneTraceP..}..},
			dataPartial,
		_,
			invalidPrimaryDataError[f]
	]
];


(* ::Subsubsection::Closed:: *)
(*padValuesTo2D*)


padValuesTo2D[partialData_,oneTraceP_]:=Module[{},
	Switch[partialData,
		oneTraceP, {partialData},
		{oneTraceP..}, partialData,
		QuantityArrayP[2],partialData,
		_, (Message[]; $Failed)
	]
];



(* ::Subsubsection::Closed:: *)
(*padValuesTo3D*)


padValuesTo3D[partialData_,oneTraceP_]:=Module[{},
	Switch[partialData,
		oneTraceP, {{partialData}},
		{oneTraceP..}, {partialData},
		{{oneTraceP..}..}, partialData,
		QuantityArrayP[2],{partialData},
		QuantityArrayP[3],partialData,
		_, (Message[]; $Failed)
	]
];



(* ::Subsection::Closed:: *)
(*Data Scaling*)


(* ::Subsubsection::Closed:: *)
(*scalePrimaryData*)


scalePrimaryData[f_,primaryDataOriginal_,yUnit_,unresolvedNormalizeOption:False,reflectX_,scale_,_]:=Module[
	{primaryData,ymin,ymax,xmin,xmax,reflectedTicks,xTransf,yTransf,primaryDataScaled,primaryDataScaledClean},
	{{xmin,xmax},{ymin,ymax}} = minAndMaxFromPrimaryData[primaryDataOriginal];
	{primaryData,reflectedTicks} = If[reflectX,
		reflectAllPrimaryData[primaryDataOriginal,{{xmin,xmax},{ymin,ymax}}],
		{primaryDataOriginal,Null}
	];
	{xTransf,yTransf} = resolveScaleFunctions[scale];
	(* make numeric here so next filter step doesn't catch valid things *)
	primaryDataScaled = N@Map[{xTransf[#[[1]]],yTransf[#[[2]]]}&,primaryData,{3}];
	(* replace any complex values (resulting from transformation) with Null, which will be ignored *)
	primaryDataScaledClean = Replace[primaryDataScaled,Except[_Integer|_Real|_Rational|_DateObject]->Null,{4}];
	{primaryDataScaledClean,{xmin,xmax},{ymin,ymax},Table[Table[1,{Length[First[primaryData]]}],{Length[primaryData]}],reflectedTicks}
];

scalePrimaryData[f_,primaryData_,yUnit_,unresolvedNormalizeOption_,reflectX_,scale_,dateFlag_]:=Module[{
		primaryDataScaled,newMax,normalize,normalizedPrimaryData,ymin,ymax,oldymaxs,normalizeYVals,
		xmin,xmax,reflectedTicks,xTransf,yTransf,primaryDataScaledClean
	},
	newMax = Unitless[quietCheckConvert[f,unresolvedNormalizeOption,yUnit,"Normalize option",dateFlag]];
	oldymaxs = Map[Max[#[[;;,2]]]&,primaryData,{2}];
	normalizedPrimaryData = MapThread[scaleOneDataTrace[#1,#2,newMax]&,{primaryData,oldymaxs},2];
	{{xmin,xmax},{ymin,ymax}} = minAndMaxFromPrimaryData[normalizedPrimaryData];
	normalizeYVals = ymax/oldymaxs;
	{normalizedPrimaryData,reflectedTicks} = If[reflectX,
		reflectAllPrimaryData[normalizedPrimaryData,{{xmin,xmax},{ymin,ymax}}],
		{normalizedPrimaryData,Null}
	];

	{xTransf,yTransf} = resolveScaleFunctions[scale];
	primaryDataScaled = Map[{xTransf[#[[1]]],yTransf[#[[2]]]}&,normalizedPrimaryData,{3}];
	(* replace any complex values (resulting from transformation) with Null, which will be ignored *)
	primaryDataScaledClean = Replace[primaryDataScaled,Except[_Integer|_Real|_Rational|_DateObject]->Null,{4}];

	{primaryDataScaledClean,{xmin,xmax},{ymin,ymax},normalizeYVals,reflectedTicks}
];

scaleOneDataTrace[xy_,oldMax_,newMax_]:=Module[{},
	(* this is a really fast way to do this *)
	Transpose[Transpose[xy]*{1,newMax/oldMax}]
];




reflectAllPrimaryData[primaryData_,{{xmin_,xmax_},{ymin_,ymax_}}]:=Module[{reflectedData,reflectedTicks},
	reflectedData = Map[Reverse@Transpose[Transpose[#]*{-1,1}]&,primaryData,{2}];
	reflectedTicks = MapAt[#*-1&,First[Lookup[AbsoluteOptions[Graphics[{Point[{xmax,ymax}]},PlotRange->{{xmin,xmax},{ymin,ymax}}]],Ticks]],{;;,1}];
	{reflectedData,reflectedTicks}
];


(* get Min and Max across all primary data. *)
(* need this for plot range resolution and scaling secondary data *)
minAndMaxFromPrimaryData[primaryData_]:=Module[{flatPrimary},
	flatPrimary = Join@@Join@@primaryData;
	{
		{Min[flatPrimary[[;;,1]]],Max[flatPrimary[[;;,1]]]},
		{Min[flatPrimary[[;;,2]]],Max[flatPrimary[[;;,2]]]}
	}
];


resolveScaleFunctions[Linear]:={Identity,Identity};
resolveScaleFunctions[Log|LinearLog]:={Identity,Log10};
resolveScaleFunctions[LogLinear]:={Log10,Identity};
resolveScaleFunctions[LogLog]:={Log10,Log10};




(* ::Subsection:: *)
(*Unit Conversion & Stripping*)


(* ::Subsubsection::Closed:: *)
(*convertAndStripSecondaryData*)


convertAndStripSecondaryData[f_,secondYFull_,xUnit0_,secondYUnit_,reflectX_,dateFlag_]:=Module[{allYUnitsList,secondYFinal,xUnit},

	xUnit = xUnit0;

	If[MatchQ[secondYFull,{}|Null|{{}}|{Null}|None],
		Return[{{},{},Null,xUnit}]
	];

	(* arbitrarily pick a y unit for each of the different signals sets by looking at first data points *)
	allYUnitsList = Map[safeUnits[(joinPatch@@#)[[1,2]]]&,Transpose[secondYFull]];

	(* Use specified unit for first second-y if it's not Automatic *)
	If[!MatchQ[secondYUnit,Automatic],
		allYUnitsList = ReplacePart[allYUnitsList,1->secondYUnit];
	];

	If[MatchQ[xUnit,Automatic],
		xUnit = FirstCase[Map[safeUnits[(Join@@#)[[1,1]]]&,Transpose[secondYFull]],Except[Null]];
	];

	(* convert corresponding signals to same units, where x is definied by primary target units, and y is from above list *)
	secondYFinal = Unitless[Transpose[
		MapThread[
			quietCheckConvertList[f,#1,{xUnit,#2},"Second Y data",dateFlag]&,
			{Transpose[secondYFull],allYUnitsList}
		]
	]];


	If[reflectX,
		secondYFinal = Map[If[MatchQ[#,{}],{},Reverse@Transpose[Transpose[#]*{-1,1}]]&,secondYFinal,{2}];
	];


	{secondYFinal,allYUnitsList,First[allYUnitsList],xUnit}

];


(* ::Subsubsection::Closed:: *)
(*quietCheckConvert*)


quietCheckConvert[f_,qa_,newUnits_,label_String]:=quietCheckConvert[f,qa,newUnits,label,Numerical];
quietCheckConvert[f_,qa_,newUnits_,label_String,dateFlag_]:=
	Quiet[
		Check[
			If[MatchQ[dateFlag,Date],safeConvertDate,safeConvert][qa,newUnits],
			(
				Message[f::IncompatibleUnits,label,Units[qa],newUnits];
				Throw[$Failed,"IncompatibleUnits"]
			),
			{Quantity::compat,UnitConvert::unkunit}
		],
		{Quantity::compat,UnitConvert::unkunit}
	];


quietCheckConvertList[f_,qaList_,newUnits_,label_String]:=quietCheckConvertList[f,qaList,newUnits,label,Numerical];
quietCheckConvertList[f_,qaList_,newUnits_,label_String,dateFlag_]:=
	Map[
		If[MatchQ[#,_Replicates],
			Map[Function[coords,quietCheckConvert[f,coords,newUnits,label,dateFlag]],#],
			quietCheckConvert[f,#,newUnits,label,dateFlag]
		]&,
		qaList
	];


(* ::Subsubsection::Closed:: *)
(*convertAndStripData*)


convertAndStripData[f_,dataFull_,unresolvedTargetUnits_,dateFlag_]:=Module[{targetUnits,dataFullConverted,dataFullUnitless},

	targetUnits = resolveDefaultTargetUnits[unresolvedTargetUnits,dataFull];

	dataFullConverted = Map[quietCheckConvertList[f,#,targetUnits,"Primary data",dateFlag]&,dataFull];

	dataFullUnitless = Unitless[dataFullConverted];

	{dataFullUnitless,targetUnits}

];


(* ::Subsubsection::Closed:: *)
(*convertAndStripListData2D*)


convertAndStripListData2D[f_,dataFull_,unresolvedTargetUnits_]:=Module[{targetUnits,dataFullConverted,dataFullUnitless},

	targetUnits = resolveDefaultTargetUnits2[unresolvedTargetUnits,dataFull];

	dataFullConverted = Map[quietCheckConvert1D[f,#,targetUnits,"Primary data"]&,dataFull];

	dataFullUnitless = Unitless[dataFullConverted];

	{dataFullUnitless,targetUnits}

];



(* ::Subsubsection::Closed:: *)
(*convertAndStripListData3D*)


convertAndStripListData3D[f_,dataFull_,unresolvedTargetUnits_]:=Module[{targetUnits,dataFullConverted,dataFullUnitless},

	targetUnits = resolveDefaultTargetUnits3[unresolvedTargetUnits,dataFull];

	dataFullConverted = Map[quietCheckConvert1D[f,#,targetUnits,"Primary data"]&,dataFull,{2}];

	dataFullUnitless = Unitless[dataFullConverted];

	{dataFullUnitless,targetUnits}

];


(* ::Subsubsection::Closed:: *)
(*quietCheckConvert1D*)


quietCheckConvert1D[f_,in_,newUnit_,label_String]:=
	Quiet[
		Check[
			convertWithReplicates1D[in,newUnit],
			(
				Message[f::IncompatibleUnits,label,Units[in],newUnit];
				Throw[$Failed,"IncompatibleUnits"]
			),
			{Quantity::compat,UnitConvert::unkunit}
		],
		{Quantity::compat,UnitConvert::unkunit}
	];


convertWithReplicates1D[in:{UnitsP[]..},newUnit_]:=safeConvert[in,newUnit];
convertWithReplicates1D[in_,newUnit_]:=Map[convertSingleWithReplicates[#,newUnit]&,in];

convertSingleWithReplicates[in:UnitsP[],newUnit_]:=safeConvert[in,newUnit];
convertSingleWithReplicates[in:PlusMinus[a_,b_],newUnit_]:=safeConvert[in,newUnit];
convertSingleWithReplicates[in:Replicates[args___],newUnit_]:=Replicates@@Map[safeConvert[#,newUnit]&,{args}];
(*convertSingleWithReplicates[d_?DistributionParameterQ,newUnit_]:=PlusMinus@@safeConvert[{Mean[d],StandardDeviation[d]},newUnit]*)
convertSingleWithReplicates[d_?DistributionParameterQ,newUnit_]:=safeConvert[d,newUnit];
convertSingleWithReplicates[Null,newUnit_]:=Null;


(* ::Text:: *)
(*Lots of definitions here so we can be fast when possible, but avoiding the ambiguous case of date lists.*)


safeConvert[vals:CoordinatesP,newUnit_]:=Convert[vals,newUnit];
safeConvert[vals:QuantityCoordinatesP[],newUnit_]:=Convert[vals,newUnit];
safeConvert[vals:nullCoordinatesP,{newUnitX_,newUnitY_}]:=
	Transpose[{safeConvert[vals[[;;,1]],newUnitX],safeConvert[vals[[;;,2]],newUnitY]}];
safeConvert[vals:nullComplexCoordinates3DP,{newUnitX_,newUnitY_,newUnitZ_}]:=
	Transpose[{safeConvert[vals[[;;,1]],newUnitX],safeConvert[vals[[;;,2]],newUnitY],safeConvert[vals[[;;,3]],newUnitZ]}];
safeConvert[vals:{UnitsP[]..},newUnit:UnitsP[]]:=Convert[vals,newUnit];
safeConvert[vals_List,newUnit:UnitsP[]]:=Map[safeConvert[#,newUnit]&,vals];

(* FIX THIS ONCE QUANTITYDISTRIBUTION IS A THING *)
safeConvert[d_?DistributionParameterQ,newUnit_]:=d;

safeConvert[Null,newUnit_]:=Null;
safeConvert[{Null,Null},newUnit_]:=Convert[Null,newUnit];
safeConvert[{x_,Null},{newUnitX_,newUnitY_}]:={Convert[x,newUnitX],Null};
safeConvert[{Null,y_},{newUnitX_,newUnitY_}]:={Null,Convert[y,newUnitY]};

safeConvert[val_,newUnit_]:=Convert[val,newUnit];



safeConvertDate[vals:{{{}}},{_,_}]:=vals;
safeConvertDate[vals:{{}},{_,_}]:=vals;
safeConvertDate[vals:{{oneDateP,UnitsP[]}..},newUnits:{xYunit:UnitsP[],yUnit:UnitsP[]}]:=Transpose[{Map[DateObject,vals[[;;,1]]],Convert[vals[[;;,2]],yUnit]}];
safeConvertDate[vals:{{oneDateP,UnitsP[]}..},newUnit:UnitsP[]]:=Transpose[{Map[DateObject,vals[[;;,1]]],Convert[vals[[;;,2]],newUnit]}];
safeConvertDate[val:oneDateP,newUnit_]:=DateObject[val];
safeConvertDate[{x:oneDateP,y:UnitsP[]},newUnits:{xYunit:UnitsP[],yUnit:UnitsP[]}]:={DateObject[x],Convert[y,yUnit]};
safeConvertDate[{x:oneDateP,y:UnitsP[]},newUnit:UnitsP[]]:={DateObject[x],Convert[y,newUnit]};
safeConvertDate[x:{},newUnits_]:={};



(* ::Subsubsection::Closed:: *)
(*elutedVolume*)


Options[elutedVolume]={returnTransform->False};

elutedVolume[dataToAlter:{{_Quantity,_Quantity}..},flowRateData:{{_Quantity,_Quantity}..},xUnit_Quantity,myOps:OptionsPattern[]]:=
    elutedVolume[QuantityArray[dataToAlter],flowRateData,xUnit,myOps];

(* Define elutedVolume function for TransformX option of PlotChromatography *)
elutedVolume[dataToAlter:(_StructuredArray|_QuantityArray),flowRateData:{{_Quantity,_Quantity}..},xUnit_Quantity,myOps:OptionsPattern[]]:=
    Module[
		{
			units,times,unitlessFlowRates,timesWithZero,
			fRTimes,fRRates,default,updatedFlowRates,pwFunc,
			outputData,combinedData,volumeFunction,volumes
		},

		(* Get the original units of the data to change *)
		units=Units[dataToAlter[[1]]];

		(* Make the calculations easier by making data unitless *)
		times=Unitless[dataToAlter[[All,1]],Minute];
		unitlessFlowRates=Unitless[flowRateData,{Minute,(xUnit/Minute)}];

		(* Make sure time starts at 0 *)
		timesWithZero=Prepend[times,0];

		(* Make piecewise function from flow rates *)
		fRTimes=unitlessFlowRates[[All,1]];
		fRRates=unitlessFlowRates[[All,2]];
		default=Last[fRRates];
		updatedFlowRates=Transpose[{Most[fRRates],Rest[fRTimes]}];
		pwFunc=Piecewise[MapAt[t<=#&,{All,-1}]@updatedFlowRates,default];

		(* Integrate to get accumulated volume at a particular time *)
		volumeFunction=Integrate[pwFunc,{t,0,T},Assumptions->T>0];

		(* Convert the times to volumes *)
		volumes=(volumeFunction/.T->#)&/@times;

		(* Put data back together *)
		combinedData=Transpose[{volumes,Unitless[dataToAlter[[All,2]]]}];

		(* Add Units back *)
		outputData=QuantityArray[combinedData,{xUnit,Last[units]}];

		(* Return what is specified *)
		If[OptionValue[returnTransform],
			volumeFunction,
			outputData
		]
	];



(* ::Subsection::Closed:: *)
(*Graphics output massaging*)


(* ::Subsubsection::Closed:: *)
(*log plots*)


logFrameTicksQ[g_Graphics]:=logFrameTicksQ[Lookup[g[[2]],FrameTicks]];
logFrameTicksQ[frameTicks_]:=MatchQ[
	N@frameTicks,
	{{Charting`ScaledTicks[{Log10,10.^#1&}],_},{Except[Charting`ScaledTicks[{Log10,10.^#1&}]],_}}
];


loglogFrameTicksQ[g_Graphics]:=loglogFrameTicksQ[Lookup[g[[2]],FrameTicks]];
loglogFrameTicksQ[frameTicks_]:=MatchQ[
	N@frameTicks,
	{{Charting`ScaledTicks[{Log10,10.^#1&}],_},{Charting`ScaledTicks[{Log10,10.^#1&}],_}}
];


loglinearFrameTicksQ[g_Graphics]:=loglinearFrameTicksQ[Lookup[g[[2]],FrameTicks]];
loglinearFrameTicksQ[frameTicks_]:=MatchQ[
	N@frameTicks,
	{{Except[Charting`ScaledTicks[{Log10,10.^#1&}]],_},{Charting`ScaledTicks[{Log10,10.^#1&}],_}}
];


(* ::Subsubsection::Closed:: *)
(*date plots*)


dateFrameTicksQ[g_Graphics]:=dateFrameTicksQ[Lookup[g[[2]],FrameTicks]];
dateFrameTicksQ[frameTicks_]:=MatchQ[
	N@frameTicks,
	If[$VersionNumber >= 12.0,
		{{_,_}, {Charting`DateTicksFunction[_,_], _}},
		{{_,_},{Charting`FindScaledTicks[(Charting`getDateTicks[___]&)[___],___]&,_}}
		]
];


(* ::Subsection:: *)
(*Plot helpers*)


(* ::Subsubsection::Closed:: *)
(*addInsetImages*)


addInsetImages[fig_,{}|NullP,___]:=fig;
addInsetImages[fig_,insetImagesList_,plotRange:{{xmin_,xmax_},{ymin_,ymax_}},imageSize_]:=Module[
	{images,pos,opos,size,ymaxNew},

	(* position in outer image *)
	pos = {xmin,ymax/1};
	(* line up this point on inset with pos *)
	opos={0,ymax/1};
	size=xmax-xmin;
	(* make sure it's a list of images *)
	images = ToList[insetImagesList];
	images = Map[If[Less@@ImageDimensions[#],ImageRotate[#],#]&,images];
	images = Map[ImageResize[#, {First[imageSize],Automatic}]&,images];
	images = MapIndexed[
		Graphics[Inset[#1,pos+{0,(0.1*(First[#2]-1))*ymax},opos+{0,(0.1*(First[#2]-1))*ymax},size]]&,
		images
	];
	ymaxNew = ymax + 0.1*Length[images]*ymax;

	Show[fig,images,PlotRange->{{xmin,xmax},{ymin,ymaxNew}}]

];


(* ::Subsubsection::Closed:: *)
(*resolveImageSize*)


resolveImageSize[unresolvedImageSize:Automatic]:={Lookup[SafeOptions[EmeraldListLinePlot],ImageSize],Automatic};
resolveImageSize[unresolvedImageSize:{Automatic,other_}]:={Lookup[SafeOptions[EmeraldListLinePlot],ImageSize],other};
resolveImageSize[unresolvedImageSize:{a_,b_}]:={a,b};
resolveImageSize[unresolvedImageSize_]:={unresolvedImageSize,Automatic};


(* ::Subsubsection:: *)
(*makePeakEpilogs*)

EmeraldListLinePlot::BadPeaks="Peaks option format not recognized. Peak epilogs could not be created.";

makePeakEpilogs[_Missing,___]:={};
makePeakEpilogs[rawUnresolvedPeaks_,rawPrimaryData_,secondaryDataUnscaledNumeric_,secondaryDataScaledNumeric_,plotRange_,{xUnit_,yUnit_},normalizeYVals_,reflectX:(True|False),safeOps_]:=Module[
	{
		unresolvedPeaks,primaryData,flattenedPrimaryData,flattenedYVals,flattenedPeaks,paddedPeaks,unresolvedLabels,paddedLabels,convertedPeaks,resolvedPeaks,
		firstSecondYListUnscaled,firstSecondYListScaled,transformationFunctions,resolvedTransformationFunctions, scale, resolvedOptions,
		dataSetTransformationFunction, resolvedPeaksOptions
	},

	(* Remove missing entries due to making reference fields multiples *)
	unresolvedPeaks=If[MatchQ[rawUnresolvedPeaks,_List],
		Replace[rawUnresolvedPeaks,Null->Nothing,{1}],
		rawUnresolvedPeaks
	];
    
	primaryData=rawPrimaryData/.{{}->Nothing};

	(* Early stop if peaks could not be resolved *)
	If[MatchQ[unresolvedPeaks,NullP|{}],
		Return[{}]
	];

	(* Handle case of multiple inputs each with multiple datasets *)
	flattenedPrimaryData=If[MatchQ[primaryData,{{CoordinatesP..}..}],
		Flatten[primaryData,1],
		primaryData
	];

	(* Delist the scale factors too *)
	flattenedYVals=If[MatchQ[primaryData,{{CoordinatesP..}..}],
		Flatten[normalizeYVals,1],
		normalizeYVals
	];

	flattenedYVals=If[Length[flattenedYVals]>Length[flattenedPrimaryData],
		Part[flattenedYVals,1;;Length[flattenedPrimaryData]],
		flattenedYVals
	];

	(* Delist peaks; these could technically be incorrectly specified *)
	flattenedPeaks=If[MatchQ[unresolvedPeaks,{{(_Association|Null)..}..}],
		Flatten[unresolvedPeaks,1],
		unresolvedPeaks
	];

	paddedPeaks = Switch[flattenedPeaks,
		ObjectP[Object[Analysis,Peaks]], PadRight[{addPeakUnits[Download[flattenedPeaks]]},Length[flattenedPrimaryData],Null],
		{(ObjectP[Object[Analysis,Peaks]]|Null|{})..}, PadRight[addPeakUnits/@Download[flattenedPeaks],Length[flattenedPrimaryData],Null],
		_, (Message[EmeraldListLinePlot::BadPeaks];Return[{}])
	];

	unresolvedLabels=Lookup[safeOps,PeakLabels];

	paddedLabels = Switch[unresolvedLabels,
		Automatic|None|Null, PadRight[{unresolvedLabels},Length[flattenedPrimaryData],Automatic],
		_String, PadRight[{{unresolvedLabels}},Length[flattenedPrimaryData],Automatic],
		{_String..}, PadRight[{unresolvedLabels},Length[flattenedPrimaryData],Automatic],
		{(Automatic|Null|{_String..})..},PadRight[unresolvedLabels,Length[flattenedPrimaryData],Automatic],
		_, (Message[EmeraldListLinePlot::BadPeaks];Return[{}])
	];

	resolvedPeaks = If[SameLengthQ[paddedPeaks,paddedLabels],
		MapThread[
			Function[{peakSet,labelSet},
				Module[{},
					Which[
						MatchQ[peakSet,Null], peakSet,
						(* By default don't include labels when we're plotting multiple sets of data *)
						(*MatchQ[labelSet,Automatic]&&Length[flattenedPrimaryData]>1,KeyDrop[peakSet,PeakLabel],*)
						MatchQ[labelSet,Automatic],peakSet,
						MatchQ[labelSet,Null], KeyDrop[peakSet,PeakLabel],
						SameLengthQ[Position/.peakSet,labelSet], Append[peakSet,PeakLabel->labelSet],
						True, Message[EmeraldListLinePlot::PeakLabels];peakSet
					]
				]
			],
			{paddedPeaks,paddedLabels}
		],
		Message[EmeraldListLinePlot::PeakLabels];paddedPeaks
	];

	resolvedPeaks = Replace[resolvedPeaks,Null->{},{1}];

	(* See if there is a transformation function *)
	transformationFunctions=Lookup[safeOps,XTransformationFunction];

	(* Resolve XTransformationFunction Option *)
	resolvedTransformationFunctions=If[NullQ[transformationFunctions],
		Repeat[Null,Length[resolvedPeaks]],
		transformationFunctions
	];

	(* If there is a transformation function, convert peaks in PeakEpilog, not here *)
	convertedPeaks=If[!MemberQ[resolvedTransformationFunctions,Null],
		resolvedPeaks,
		Map[
		If[MatchQ[#,{}|<||>],
			{},
			Quiet[
				Check[
					(* if all values are numeric (no quantities), assume units are correct and leave as-is *)
					With[
						{temp = If[MatchQ[#, ObjectP[Object[Analysis, Peaks]]],
								<|
									MapThread[#1 -> #2&,
										{
											Append[PeaksFields, BaselineFunction],
											Quiet[Download[#, Evaluate@Append[PeaksFields, BaselineFunction]],{Download::MissingField,First::nofirst}]
										}
									]
								|>,
								#
							]
						},
						If[MatchQ[Flatten[Lookup[temp,Append[PeaksFields,BaselineFunction],{}]],{(NumericP|_String|Null|_Function)...}],
							#,
							(* otherwise convert to target units *)
							convertPeaksWithUnitsToUnitless[Append[temp, Type->Object[Analysis,Peaks]],{xUnit,yUnit}]
						]
					],
					(
						Message[EmeraldListLinePlot::IncompatibleUnits,"Peaks option"];
						Throw[$Failed,"IncompatibleUnits"]
					),
					Quantity::compat
				],
				{Quantity::compat}
			]
		]&,
		resolvedPeaks
		]
	];

	(* fix this when I allow peaks for more than just first primary data set *)
	convertedPeaks = MapThread[scaleUnitlessPeaksY[#1,#2]&,{convertedPeaks,flattenedYVals}];

	(* find if the peaks has already been transformed *)
	resolvedPeaksOptions = Lookup[#, ResolvedOptions, {}]&/@convertedPeaks;
	
    (* Symbol[SymbolName[]] is used to strip context *)
	dataSetTransformationFunction = Lookup[resolvedPeaksOptions, Symbol[SymbolName[ DataSetTransformationFunction]], Null];

	(* if the scale is LogLinear we will log the x values in the converted peaks data for the epilog *)
	convertedPeaks = MapThread[
		scaleUnitlessPeaksLogLinear[#1, Lookup[safeOps,Scale], #2]&,
		{convertedPeaks, dataSetTransformationFunction}
	];

	(* get just the primary secondary data *)
	firstSecondYListUnscaled=If[MatchQ[secondaryDataUnscaledNumeric,{}],
		Table[{},{Length[flattenedPrimaryData]}],
		secondaryDataUnscaledNumeric[[;;,1]]
	];

	firstSecondYListScaled=If[MatchQ[secondaryDataScaledNumeric,{}],
		Table[{},{Length[flattenedPrimaryData]}],
		secondaryDataScaledNumeric[[;;,1]]
	];

	MapThread[
		If[MatchQ[#2,{}],
			{},
			PeakEpilog[#1,#2,PassOptions[PeakEpilog,Join[{LabelStyle->Lookup[safeOps,PeakLabelStyle],PlotRange->plotRange,SecondYUnscaled->#3,SecondYScaled->#4,XTransformationFunction->#5,Reflected->reflectX},safeOps]]
			]
		]&,
		(* fix this to use all primaryData when I add ability to have peaks for addition primary data sets *)
		{flattenedPrimaryData,convertedPeaks,firstSecondYListUnscaled,firstSecondYListScaled,resolvedTransformationFunctions}
	]
];


convertPeaksWithUnitsToUnitless[peakData:PacketP[Object[Analysis,Peaks]],{newXUnit_,newYUnit_}]:=Module[{safeUnitless,dimensionlessFields,dimensionlessRules},

	(* Overload to Unitless[x,y] which returns x unchanged if x is already unitless *)
	safeUnitless[x_,unitType_]:=If[MatchQ[Units[x],1|{1..}],x,Unitless[x,unitType]];

	(* Replacement rules for dimensionless fields *)
	dimensionlessFields={AsymmetryFactor,TailingFactor,RelativeArea,RelativePosition,PeakLabel};
	dimensionlessRules=Map[If[KeyExistsQ[peakData,#],#->Unitless[#/.peakData],Nothing]&,dimensionlessFields];

	(* Output the peaks fields with units stripped *)
	Join[
		peakData,
		<|
			Position->safeUnitless[Position/.peakData,newXUnit],
			Height->safeUnitless[Height/.peakData,newYUnit],
			HalfHeightWidth->safeUnitless[HalfHeightWidth/.peakData,newXUnit],
			Area->safeUnitless[Area/.peakData, newXUnit*newYUnit],
			PeakRangeStart->safeUnitless[PeakRangeStart/.peakData,newXUnit],
			PeakRangeEnd->safeUnitless[PeakRangeEnd/.peakData,newXUnit],
			WidthRangeStart->safeUnitless[WidthRangeStart/.peakData,newXUnit],
			WidthRangeEnd->safeUnitless[WidthRangeEnd/.peakData,newXUnit],
			BaselineIntercept->safeUnitless[BaselineIntercept/.peakData,newYUnit],
			BaselineSlope->safeUnitless[BaselineSlope/.peakData,newYUnit/newXUnit],
			BaselineFunction->convertBaselineFunctionUnits[BaselineFunction/.peakData,{newXUnit,newYUnit}],
			Sequence@@dimensionlessRules
		|>
	]
];

convertBaselineFunctionUnits[QuantityFunction[blf_Function,{xU_},yU_],{xU_,yU_}]:=blf;

(* If baseline function has no units then return it with no units *)
convertBaselineFunctionUnits[blf_Function,{xU_,yU_}]:=blf;

convertBaselineFunctionUnits[QuantityFunction[blf_Function,{xU_},yU_],{xUNew_,yUNew_}]:=With[
	{xScale=Convert[1,xUNew,xU],yScale=Convert[1,yUNew,yU]},
	Function[x,(1/yScale)*blf[x*xScale]]
];

scaleUnitlessPeaksY[peakData_,scaleVal_]:=Module[{},
	Association[ReplaceRule[Normal[peakData],{
		Height->Times[Height/.peakData,scaleVal],
		Area->Times[Area/.peakData, scaleVal],
		BaselineIntercept->Times[BaselineIntercept/.peakData,scaleVal],
		BaselineSlope->Times[BaselineSlope/.peakData,scaleVal]
	},Append->False]]
];

(*
	if the scale is loglinear with an empty transformation apply a transformation,
	otherwise return the data as is
*)
scaleUnitlessPeaksLogLinear[peakData_, scale_, transformation_]:=peakData;
scaleUnitlessPeaksLogLinear[peakData_, scale:LogLinear, Null]:=Module[{},
	(* find the scaling transforms *)
	{xTransf,yTransf} = resolveScaleFunctions[scale];
	baselineFunction = BaselineFunction/.peakData;

	(* if the scale is logliner, we need to update the baseline *)
	baselineFunction = If[MatchQ[scale, LogLinear],
		ReplaceAll[
			baselineFunction,
			{
				(* replace the x in the equation with 10^x, later we replace the x (slot[1]) in the bounds *)
				Slot[1]->10^Slot[1],
				(* redo the bounds with log boundaries *)
				LessEqual[x_?NumericQ, y_, z_?NumericQ] -> LessEqual[Log10[x], y, Log10[z]],
				Inequality[x_?NumericQ ,LessEqual,y_ ,LessEqual, z_?NumericQ] -> Inequality[Log10[x] ,LessEqual,y ,LessEqual, Log10[z]]
			}
		],
		baselineFunction
	];

	Association[ReplaceRule[Normal[peakData],{
		(* transform x axis correctly for postions and ranges *)
		Position->xTransf[Position/.peakData],
		PeakRangeStart->xTransf[PeakRangeStart/.peakData],
		PeakRangeEnd->xTransf[PeakRangeEnd/.peakData],
		WidthRangeStart->xTransf[WidthRangeStart/.peakData],
		WidthRangeEnd->xTransf[WidthRangeEnd/.peakData],

		(* transform the baseline function *)
		BaselineFunction -> baselineFunction

	},Append->False]]
];


reflectPeaks[peakData_]:=Module[{},
	Association[ReplaceRule[Normal[peakData],{
		Position->Times[Position/.peakData,-1],
		PeakRangeStart->Times[PeakRangeStart/.peakData,-1],
		PeakRangeEnd->Times[PeakRangeEnd/.peakData,-1],
		WidthRangeStart->Times[WidthRangeStart/.peakData,-1],
		WidthRangeEnd->Times[WidthRangeEnd/.peakData,-1]
	},Append->False]]
];


(* ::Subsubsection::Closed:: *)
(*makeLadderEpilogs*)


makeLadderEpilogs[_Missing|NullP,___]:={};

makeLadderEpilogs[ladderCoords_,primaryData_,plotRange_,xUnit_]:=Module[
	{flattenedPrimaryData,flattenedLadderCoords,fullLadderCoords,numericFullLadderCoords,colors,epilog},

	(* Handle case of multiple inputs each with multiple datasets *)
	flattenedPrimaryData=If[MatchQ[primaryData,{{CoordinatesP..}..}],
		Flatten[primaryData,1],
		primaryData
	];

	(* Delist ladder coordinates *)
	flattenedLadderCoords=If[MatchQ[primaryData,{{CoordinatesP..}..}]&&MatchQ[ladderCoords,{({(Null|{{_?NumericQ,_?UnitsQ}..})..}|{(Null | {__Rule})..})..}],
		Flatten[ladderCoords,1],
		ladderCoords
	];

	fullLadderCoords = Switch[flattenedLadderCoords,
		{{_?NumericQ,_?UnitsQ}..}, {ladderCoords},
		{(Null|{{_?NumericQ,_?UnitsQ}..})..}, ladderCoords,
		{__Rule}, {List@@@ladderCoords},
		{(Null | {__Rule})..}, List@@@#&/@flattenedLadderCoords
	];

	numericFullLadderCoords = Map[
		removeYUnitsFromCoordinates[xUnit,#]&,
		fullLadderCoords
	];

	colors = ColorData[97][#]&/@Range[Length[numericFullLadderCoords]];

	MapThread[
		ladderEpilog[#1,#2,#3]&,
		{numericFullLadderCoords,primaryData[[;;,1,;;]],colors}
	]
];

removeYUnitsFromCoordinates[xUnit_,coordinates:{{_?NumericQ,_?UnitsQ}..}]:= MapAt[
	If[NumericQ[#],
		#,
		Unitless[#,xUnit]
	]&,
	coordinates,{All,2}
];

removeYUnitsFromCoordinates[xUnit_,Null]:=Null;


(* ::Subsubsection:: *)
(*makeFractionEpilogs*)


makeFractionEpilogs[_Missing,_Missing,___]:={};
makeFractionEpilogs[unresolvedFractions_,unresolvedFractionHighlights_,unresolvedLabels_,plotRange_,targetXUnit_,dateFlag_,fracColor_,fracHighlightColor_]:=Module[
	{fracs,fracHighlights,fracLabels},

	If[And[MatchQ[Flatten[unresolvedFractions/.Null->{}],{}],MatchQ[Flatten[unresolvedFractionHighlights/.Null->{}],{}]],
		Return[{}]
	];

	fracs=cleanUpFractionSet[unresolvedFractions,targetXUnit,dateFlag];
	fracHighlights=cleanUpFractionSet[unresolvedFractionHighlights,targetXUnit,dateFlag];
	fracLabels = cleanupFractionLabels[unresolvedLabels,dateFlag];
	Core`Private`fractionEpilog[fracs,PlotRange->plotRange,FractionHighlights->fracHighlights,FractionColor->fracColor,FractionHighlightColor->fracHighlightColor,FractionLabels->fracLabels]
];


cleanUpFractionSet[unresolvedFractions:({}|{{}}|Null|{Null}),targetXUnit_,dateFlag_]:={Null};
cleanUpFractionSet[unresolvedFractions_,targetXUnit_,dateFlag:Date]:={Null};
cleanUpFractionSet[unresolvedFractions_,targetXUnit_,dateFlag_]:=Module[
	{resolvedFractions,unitlessFractions},

	resolvedFractions = Switch[unresolvedFractions,
		(FractionP|Null|{}), {unresolvedFractions},
		{(FractionP|Null|{})..}, unresolvedFractions,
		{({(FractionP|Null|{})..}|Null|{})..}, Flatten[unresolvedFractions,1],
		{{({(FractionP|Null|{})..}|Null|{})..}..}, Flatten[First[unresolvedFractions],1],
		_, (Message[EmeraldListLinePlot::BadFractions];Return[{}])
	];
	resolvedFractions = DeleteCases[resolvedFractions,Null|{}];

	unitlessFractions = Unitless[MapAt[
		quietCheckConvert[EmeraldListLinePlot,#,targetXUnit,"Fractions option",dateFlag]&,
		resolvedFractions,
		{;;,1;;2}
	]];

	unitlessFractions

];


cleanupFractionLabels[unresolvedLabels:({}|Null|{Null}),dateFlag_]:={Null};
cleanupFractionLabels[unresolvedLabels_,dateFlag:Date]:={Null};
cleanupFractionLabels[unresolvedLabels_,dateFlag_]:=Module[
	{resolvedLabels},

	resolvedLabels = Switch[unresolvedLabels,
		Except[_List], {unresolvedLabels},
		{({}|Except[_List])..}, unresolvedLabels,
		{({(Except[_List]|{})..}|{})..}, Flatten[unresolvedLabels,1],
		_, (Message[EmeraldListLinePlot::BadFractions];Return[{}])
	];
	resolvedLabels = DeleteCases[resolvedLabels,Null|{}];

	resolvedLabels

];

(* scale second x and y data if it is transformed from linear to log *)
(* for an empty list return an empty list *)
logSecondData[_,{},___]:={};
(* look at the scale transform and apply to the x and y data *)
logSecondData[EmeraldListLinePlot,secondaryData:{_List..}, scale_]:=Module[
	{xTransf,yTransf},

	{xTransf,yTransf} = resolveScaleFunctions[scale];
	secondaryDataScaled = Map[{xTransf[#[[1]]],yTransf[#[[2]]]}&,secondaryData,{3}];
	(* replace any complex values (resulting from transformation) with Null, which will be ignored *)
	secondaryDataScaled = Replace[secondaryDataScaled,Except[_Integer|_Real|_Rational|_DateObject]->Null,{4}]

];


(* ::Subsubsection::Closed:: *)
(*scaleSecondYData*)


scaleSecondYData[_,{},___]:={};
scaleSecondYData[EmeraldListLinePlot,secondYData:{_List..},secondYRanges:{{_,_}..},newMinMax:{ymin_,ymax_},{scaleMin_,scaleMax_}]:=Module[
	{rawSecondYData,oldMinMaxList},
	rawSecondYData = Transpose[QuantityMagnitude[secondYData]];

	(* shenanigans to protect against flat data *)
	oldMinMaxList = Map[perturbSecondRange[N[#]]&,secondYRanges];
	(* scale *)
	Transpose[MapThread[scaleSecondYDataList[#1,#2,newMinMax]&,{rawSecondYData,oldMinMaxList}]]
];


scaleSecondYDataList[coordsList_,oldMinMax_,newMinMax_]:=
	Map[scaleOneSecondY[#,oldMinMax,newMinMax]&,coordsList];

scaleOneSecondY[{},oldMinMax_,newMinMax_]:={};
scaleOneSecondY[coords_,oldMinMax_,newMinMax_]:=With[
	{rescaleF = Function[x,Evaluate[Rescale[x,oldMinMax,newMinMax]]]},
	MapAt[rescaleF,coords,{;;,2}]
];


scaleSecondYData[_,{},___]:={};
scaleSecondYData[EmeraldDateListPlot,secondYData:{_List..},secondYRanges:{{_,_}..},newMinMax:{ymin_,ymax_},{scaleMin_,scaleMax_}]:=Module[
	{rawSecondYData,oldMinMaxList},
	rawSecondYData = Transpose[MapAt[QuantityMagnitude,secondYData,{;;,;;,;;,2}]];
	(* shenanigans to protect against flat data *)
	oldMinMaxList = Map[perturbSecondRange[N[#]]&,secondYRanges];
	(* scale *)
	Transpose[MapThread[scaleSecondYDateDataList[#1,#2,newMinMax]&,{rawSecondYData,oldMinMaxList}]]
];

scaleSecondYDateDataList[coordsList_,oldMinMax_,newMinMax_]:=
	Map[scaleOneSecondY[#,oldMinMax,newMinMax]&,coordsList];


(* ::Subsubsection::Closed:: *)
(*makeSecondYGraphic*)


makeSecondYGraphic[{},___]:={};
makeSecondYGraphic[secondYDataScaled:{_List..},secondYColors:{_List..},secondYStyle_]:=Module[{},
	Which[
		(* No style has been specified *)
		secondYStyle===None,
		MapThread[{#2,Line[#1]}&,{secondYDataScaled,secondYColors},2],

		(* Multiple styles are specified *)
		MatchQ[secondYStyle,_List],
		MapThread[{#2,Sequence@@secondYStyle,Line[#1]}&,{secondYDataScaled,secondYColors},2],

		(* Only one of the style settings is specified *)
		True,
		MapThread[{#2,secondYStyle,Line[#1]}&,{secondYDataScaled,secondYColors},2]
	]
];



(* ::Subsubsection::Closed:: *)
(*makeSecondYTicks*)


(*
	This should also take in the SecondYColors
*)
makeSecondYTicks[secondYValues:({}|Null),secondYRange_,{y1min_,y1max_},{scaleMin_,scaleMax_}]:={};
makeSecondYTicks[secondYValues_List,secondYRange:{y2min_,y2max_},{y1min_,y1max_},{scaleMin_,scaleMax_}]:=Module[{},
	EmeraldFrameTicks[{y1min,y1max},{y2min*scaleMin,y2max*scaleMax},Round->True]
];


(* ::Subsubsection::Closed:: *)
(*resolveSecondYColors*)


resolveSecondYColors[colors:{_?ColorQ...},secondYData_]:=Module[
	{fullColors,m,n},

	n=Length[secondYData];
	If[n===0,Return[{}]];
	m=Length[First[secondYData]];
	fullColors = Join[colors,Map[ColorData[99],Range[m]]];

	Transpose[
		Which[
			(* For the case that the number of curves on the second Y are the same as the number of colors and m==1, don't use fading *)
			(m==1 && n==Length[colors]),
			{fullColors[[1;;n]]},

			True,
			Table[
				ColorFade[fullColors[[ix]],n],
				{ix,1,m}
			]
		]
	]

];

resolveSecondYColors[color_?ColorQ,secondYData_]:=resolveSecondYColors[{color},secondYData];

resolveSecondYColors[Automatic,secondYData_]:=resolveSecondYColors[{},secondYData];


(* ::Subsubsection::Closed:: *)
(*makeVerticalLineEpilog*)


makeVerticalLineEpilog[_Missing]:={};
makeVerticalLineEpilog[unresolvedVerticalLineSpec_,xUnit_,plotRange:{xrange_,{ymin_,ymax_}}]:=Module[{verticalLineSpec},

	If[MatchQ[unresolvedVerticalLineSpec,{}|Null],
		Return[{}]
	];

	verticalLineSpec = unresolvedVerticalLineSpec;

	(* pad with lists as necessary *)
	verticalLineSpec = Switch[verticalLineSpec,
		_?UnitsQ, {verticalLineSpec},
		{_?UnitsQ..}, verticalLineSpec,
		{_?UnitsQ,_,_String|_Style,___}, {verticalLineSpec},
		_, verticalLineSpec
	];

	(* fill out default stuff for each element *)
	verticalLineSpec = MapThread[
		Function[{oneSpec,ind},padVerticalLineSpec[oneSpec,ind]],
		{verticalLineSpec,Range[Length[verticalLineSpec]]}
	];

	(* convert units of the position and height *)
	verticalLineSpec = Map[resolveOneVerticalLine[#,xUnit]&,verticalLineSpec];

	(*
		verticalLineSpec has the form
		{ {xpos,relativeHeight,textLabel,style___}.. }
	*)
	Function[
		{##4,Line[{{#1,ymin},{#1,ymax*#2}}],Text[#3,{#1,1.05*ymax*#2}]}
	]@@@verticalLineSpec

];


resolveOneVerticalLine[{xpos_?UnitsQ,height_,label_,style___},xUnit_]:=Module[{},
	{
		Unitless[xpos,xUnit],  (* convert to same units as primary data *)
		Unitless[height,1], (* convert from percent (or any dimensionless unit) to fraction *)
		label,
		style
	}
];


defaultLabel="";
defaultRelativeHeight=0.5;
defaultStyle = Thick;
defaultColor[n_Integer]:=ColorData[25][n];
padVerticalLineSpec[xpos_?UnitsQ,ind_Integer]:={xpos,defaultRelativeHeight,defaultLabel,defaultColor[ind],defaultStyle};
padVerticalLineSpec[{xpos_?UnitsQ},ind_Integer]:={xpos,defaultRelativeHeight,defaultLabel,defaultColor[ind],defaultStyle};
padVerticalLineSpec[{xpos_?UnitsQ,height_},ind_Integer]:={xpos,height,defaultLabel,defaultColor[ind],defaultStyle};
padVerticalLineSpec[{xpos_?UnitsQ,height_,label_},ind_Integer]:={xpos,height,label,defaultColor[ind],defaultStyle};
padVerticalLineSpec[{xpos_?UnitsQ,height_,label_,style___},ind_Integer]:={xpos,height,label,defaultColor[ind],defaultStyle,style};


(* ::Subsubsection::Closed:: *)
(*resolveSecondPlotRanges*)


resolveSecondPlotRanges[unresolvedSecondYRange_,{},xUnit_,secondYUnits_List,{scaleMin_,scaleMax_},numSecondaryTypes_,emptyPositions_]:={{},{}};
resolveSecondPlotRanges[unresolvedSecondYRange_,secondaryData_,xUnit_,secondYUnits_List,{scaleMin_,scaleMax_},numSecondaryTypes_Integer,emptyPositions_] := Module[
	{unresolvedSecondYRangePadded,fullSecondRanges,secondRangesY,secondRangesX},

	unresolvedSecondYRangePadded = paddSecondYRanges[unresolvedSecondYRange,numSecondaryTypes];

	unresolvedSecondYRangePadded = Delete[unresolvedSecondYRangePadded,emptyPositions];

	fullSecondRanges = MapThread[resolvePlotRange[{Automatic,#1},#2,{xUnit,#3},{},ScaleX->1,ScaleY->1]&,
		{unresolvedSecondYRangePadded,Transpose[secondaryData],secondYUnits}
	];
	secondRangesY = Map[Last[#] * {scaleMin,scaleMax}&,fullSecondRanges];
	secondRangesX = Map[First[#] * {scaleMin,scaleMax}&,fullSecondRanges];
	(* shenanigans to protect against flat data *)
	secondRangesY = Map[perturbSecondRange[N[#]]&,secondRangesY];
	{secondRangesX,secondRangesY}
];

perturbSecondRange[{0.,0.}]:={-0.1,0.1};
perturbSecondRange[{x_,x_}]:=x*(1+10^-3{-1,1});
perturbSecondRange[other_]:=other;


onePlotRangeYP = {UnitsP[],UnitsP[]};
paddSecondYRanges[val:Automatic|All|Full,n_Integer]:=Table[val,{n}];
paddSecondYRanges[val:onePlotRangeYP,n_Integer]:=Join[{val},Table[Automatic,{n-1}]];
paddSecondYRanges[vals:{(Automatic|All|Full|onePlotRangeYP)..},n_Integer]:=PadRight[vals,n,Automatic];


(* ::Subsubsection::Closed:: *)
(*resolvePrimaryTooltips*)


resolvePrimaryTooltips[xys_,ListableP[Null,2]]:=Null;
resolvePrimaryTooltips[xys_,unresolvedTooltips_]:=Module[
	{numDataSets,numPrimaryPer,tooltipDims},
	{numDataSets,numPrimaryPer} = Dimensions[xys][[;;2]];
	tooltipDims = Dimensions[unresolvedTooltips];
	expandTooltipOption[{numDataSets,numPrimaryPer},unresolvedTooltips]
];

expandTooltipOption[dataDims:{numDataSets_,numPrimaryPer_},tooltip:{Except[_List]..}]:=
	Take[Flatten[Table[PadRight[tooltip,numDataSets,Null],{numPrimaryPer}],1],Times@@dataDims];
expandTooltipOption[dataDims:{numDataSets_,numPrimaryPer_},tooltip:{_List..}]:=
	Take[PadRight[Flatten[tooltip,1],Times@@dataDims,Null],Times@@dataDims];
expandTooltipOption[___]:=Null;


(* ::Subsubsection::Closed:: *)
(*Helpers to show data specified in options on plot *)


(* Any values that are directly specified should be shown on the plot *)
(* Prepend the directly specified values to the existing Display-style options *)
updateDisplayOptionsToShowSpecified[rawOps:_Association,typ:TypeP[]]:=Module[{updatedOps,traceFields,images,displays},

	(* Lookup all trace fields, aside from the primary data fields (don't want to plot twice) *)
	traceFields=Complement[linePlotTypeUnits[typ][[All,1]],Lookup[rawOps,PrimaryData,{}]];
	updatedOps=(prependSpecifiedToDisplayOptions[rawOps,traceFields,SecondaryData]);

	images=imageFields[typ];
	updatedOps=prependSpecifiedToDisplayOptions[updatedOps,images,Images];

	displays=Join[peaksFields[typ],fractionsFields[typ]];
	updatedOps=prependSpecifiedToDisplayOptions[updatedOps,displays,Display];

	Normal[updatedOps]

];

(* Add option to the Display field *)
prependSpecifiedToDisplayOptions[rawOps:_Association,optionNames:_List,optionType:_Symbol]:=Module[{updatedOps,optionValues},

	updatedOps=rawOps;
	(* Prepend specified to currently specified displays (default or specified by user) *)
	optionValues=Lookup[updatedOps,optionNames,Null];
	MapThread[
		If[!MatchQ[#1,NullP] && !MatchQ[Flatten[{#1}],{}],
			updatedOps[optionType]=DeleteDuplicates[Prepend[Lookup[updatedOps,optionType,{}],#2]]
		]&,
		{optionValues,optionNames}
	];
	updatedOps
];


(* Update fields in a packet with user specified values *)
overrideFieldsWithSpecified[infs:{packetOrInfoP[]..},ops:_Association]:=Module[{optionsToCheck,rawValues,values,fieldNames,rawRules,rules,return},
	optionsToCheck=valueOptions[First[Type/.infs],ops[PrimaryData]];
	rawValues=Lookup[ops,optionsToCheck,Null];
	values=padValues[rawValues,Length[infs]];
	fieldNames=DeleteCases[DeleteDuplicates[Flatten[optionNameToFieldName[optionsToCheck,First[Type/.infs],ops[PrimaryData]]]],Null];

	(* Turn each option specified as A\[Rule]{t1,t2,t3} into a list of repeated rules: A\[Rule]t1,A\[Rule]t2,A\[Rule]t3 *)
	rawRules=If[MatchQ[Length[values],Length[fieldNames]] && RepeatedQ[Length/@DeleteCases[values,NullP]],
		DeleteCases[MapThread[
			Function[{curOptionName,curOptionValues},(curOptionName->#&)/@curOptionValues],
			{fieldNames,values}
		],{}|NullP],
		Message[Plot::InvalidValueSpecification,fieldNames];
		{};
	];

	(* If the rules generated can be sensibly turned into updates for the packet, do so. Otherwise return the orignal packet *)
	rules=If[MatrixQ[rawRules],
		DeleteCases[Transpose[rawRules],_->(NullP|{}),Infinity],
		{}
	];

	If[!MatchQ[Flatten[rules],{}|NullP],
		MapThread[
			Join[
				#1,
				Association[#2]
			]&,
			{infs,rules}
		],
		infs
	]

];


(* Get all the options that could specify values to be plotted for the given type *)
valueOptions[dataType:TypeP[],primaryData_]:=Module[{},
	DeleteCases[Flatten[Join[
		linePlotTypeUnits[dataType][[All,1]],
		imageFields[dataType],
		sourceToPeaks[dataType,primaryData]/.({_FieldP[Output->Short]..}->{Peaks}),
		sourceToFractions[dataType,primaryData]/.({_FieldP[Output->Short]..}->{Fractions})
	]],Null]
];


padValues[values_,infsNumber_Integer]:=Module[{},
	If[MatchQ[#,CoordinatesP|QuantityArrayP[]|PacketP[Object[Analysis,Peaks]]|unitlessFractionP|FractionP] && !NullQ[#],
		{#},
		If[MatchQ[#,Null],
			ConstantArray[Null,infsNumber],
			#
		]
	]&/@values
];


(* ::Subsubsection::Closed:: *)
(*resolveSecondDatePlotRange*)


resolveSecondDatePlotRange[unresolvedSecondYRange_,{},{xUnti_,secondYUnit_},{scaleMin_,scaleMax_}]:={};
resolveSecondDatePlotRange[unresolvedSecondYRange_,secondaryData_,{xUnit_,secondYUnit_},{scaleMin_,scaleMax_}] := Module[{fullSecondRange,secondRange},
	fullSecondRange = resolvePlotRange[{Automatic,unresolvedSecondYRange},First[Transpose[secondaryData]],{xUnit,secondYUnit},{}];
	secondRange = Last[fullSecondRange] * {scaleMin,scaleMax};
	If[MatchQ[secondRange,{0|0.,0|0.}],
		secondRange = {-0.1,0.1};
	];
	secondRange
];


(* ::Subsubsection::Closed:: *)
(*addTooltipsToPrimaryData*)


addTooltipsToPrimaryData[data_,Null|{}]:= data;
addTooltipsToPrimaryData[data_,tooltips_]:= MapThread[addOneTooltip[#1,#2]&,{data,tooltips},1];
addOneTooltip[x_,Null]:=x;
addOneTooltip[x_,y_]:=Tooltip[x,y];


(* ::Subsubsection::Closed:: *)
(*resolveJoinedOption*)


resolveJoinedOption[xy3_,joinedOption0:{(True|False|Automatic)..}]:=Module[{joinedOption,out},
	joinedOption = PadRight[joinedOption0,Length[xy3],Last[joinedOption0]];
	out = MapThread[With[{z=resolveJoinedOption[{#1},#2]},Table[z,{Length[#1]}]]&,{xy3,joinedOption}];
	Flatten[out]
];
resolveJoinedOption[xy3_,joinedOption:(True|False)]:=joinedOption;
resolveJoinedOption[xy3_,joinedOption:Automatic]:=
	If[AllTrue[xy3[[;;,;;,;;,1]],monotoniclyIncreasingX,2],
		True,
		False
	];

monotoniclyIncreasingX[vals_]:=Min[Differences[vals]]>0;


(* ::Subsection:: *)
(*Chart helpers*)


(* ::Subsubsection:: *)
(*resolveChartOptions*)


resolveChartOptions[plotType_,safeOps_,targetUnit_,oneDataSetBool_,primarDataFullUnitless_]:=Module[
	{legend,frame,frameTicks,frameLabels,imageSize,chartStyle,plotRangeUnitless,scalingFunctions},

	legend = formatPlotLegend[Lookup[safeOps,Legend],1,1,LegendPlacement->Lookup[safeOps,LegendPlacement],Boxes->Lookup[safeOps,Boxes]];
	(* need this for sizing any inset images that will be added later *)
	imageSize = resolveImageSize[Lookup[safeOps,ImageSize]];
	(* ColorFade primary data within each object *)
	chartStyle = resolveChartStyle2[Lookup[safeOps,ChartStyle],oneDataSetBool];

	(* full frame specification *)
	frame = resolveFrame[Lookup[safeOps,Frame],Null];
	(* full FrameTicks specification.  Add SecondY ticks if SecondY data exists. *)
	frameTicks = resolveFrameTicksChart[Lookup[safeOps,FrameTicks]];
	(*  full FrameLabel specification.  Autoamtics resolve based on axis units *)
	frameLabels = resolveChartFrameLabel[plotType,safeOps,targetUnit];
	(* *)
	scalingFunctions = resolveChartScalingFunctions[Lookup[safeOps,Scale]];
	(* resolve the plot range.  Look at data if not specified *)
	plotRangeUnitless = resolveChartPlotRange[plotType,safeOps,targetUnit,primarDataFullUnitless];

	{
		ChartLegends->legend, ImageSize->imageSize, ChartStyle->chartStyle, Frame->frame,
		Frame->frame, FrameTicks->frameTicks, FrameLabel->frameLabels,
		Epilog -> Lookup[safeOps,Epilog],
		PlotRange->plotRangeUnitless,
		ScalingFunctions->scalingFunctions,
		TargetUnits->targetUnit
	}

];

resolveChartFrameLabel[PieChart,safeOps_,targetUnit_]:=None;
resolveChartFrameLabel[BarChart|BoxWhiskerChart,safeOps_,targetUnit_]:=resolveFrameLabel[Lookup[safeOps,FrameLabel],Lookup[safeOps,FrameUnits],{1,targetUnit},Null,Null];
resolveChartFrameLabel[Histogram,safeOps_,targetUnit_]:=resolveFrameLabel[Lookup[safeOps,FrameLabel],Lookup[safeOps,FrameUnits],{targetUnit,1},Null,Null];
resolveChartFrameLabel[SmoothHistogram,safeOps_,targetUnit_]:=resolveFrameLabel[Lookup[safeOps,FrameLabel],Lookup[safeOps,FrameUnits],{targetUnit,1},Null,Null];

resolveChartScalingFunctions[_Missing]:=None;
resolveChartScalingFunctions[plotType:Linear]:=None;
resolveChartScalingFunctions[plotType:(Log|LinearLog)]:="Log10";
resolveChartScalingFunctions[plotType:LogLinear]:={"Log10",None};
resolveChartScalingFunctions[plotType:LogLog]:={"Log10","Log10"};


(* ::Subsubsection::Closed:: *)
(*resolveChartData*)


resolveChartData[f_,plotType:BoxWhiskerChart,in_,safeOps_,oneTraceP_]:=Module[
	{primaryDataFull,numDataSets,primarDataFullUnitless,targetUnit,dataToPlot,oneDataSetBool},

	oneDataSetBool=MatchQ[in,oneTraceP|{oneTraceP..}|QuantityArrayP[2]];
	primaryDataFull = padValuesTo3D[in,oneTraceP];
	numDataSets = Length[primaryDataFull];
	(* convert all QAs to the same unit.  Need this so their magnitudes are all on same scale *)
	(* if anything can't be converted due to incompatbile units, then exit *)
	(* this also converts things inside Replicates head but does not average yet *)
	(* also return the units that things were converted to *)
	{primarDataFullUnitless,targetUnit} = convertAndStripListData3D[f,primaryDataFull,Lookup[safeOps,TargetUnits]];
	(* replace empty placeholders with a thing that BarChart can handle *)
	dataToPlot = Replace[primarDataFullUnitless,{{}}|{}->Null,{2}];
	dataToPlot = Replace[dataToPlot,{{}}|{}->Null,{1}];

	{dataToPlot,targetUnit,oneDataSetBool,Null,Null}

];

resolveChartData[f_,plotType_,in0_,safeOps_,oneTraceP_]:=Module[
	{primaryDataFull,numDataSets,primarDataFullUnitless,targetUnit,dataToPlot,
		oneDataSetBool,errorValues,dists,in},

	oneDataSetBool=MatchQ[in0,oneTraceP];
	(* for Histogram, expand distributions to their contained points.  others stay as-is *)
	in = Switch[plotType,
		Histogram,
			ReplaceAll[in0,dist:EmpiricalDistributionP[]:>EmpiricalDistributionPoints[dist]],
		_,
		in0
	];
	primaryDataFull = padValuesTo2D[in,oneTraceP];
	numDataSets = Length[primaryDataFull];

	(* convert all QAs to the same unit.  Need this so their magnitudes are all on same scale *)
	(* if anything can't be converted due to incompatbile units, then exit *)
	(* this also converts things inside Replicates head but does not average yet *)
	(* also return the units that things were converted to *)
	{primarDataFullUnitless,targetUnit} = convertAndStripListData2D[f,primaryDataFull,Lookup[safeOps,TargetUnits]];

	{primarDataFullUnitless,errorValues,dists} = resolveChartErrorBars[plotType,primarDataFullUnitless,safeOps];

	(* replace empty placeholders with a thing that BarChart can handle *)
	dataToPlot = Replace[primarDataFullUnitless,{{}}|{}->Null,{1}];

	{dataToPlot,targetUnit,oneDataSetBool,errorValues,dists}

];

resolveChartPlotRange[PieChart,safeOps_,targetUnit_,primarDataFullUnitless_]:=Automatic;
resolveChartPlotRange[BarChart|BoxWhiskerChart,safeOps_,targetUnit_,primarDataFullUnitless_]:=resolvePlotRange[ReplaceAll[Lookup[safeOps,PlotRange],Full->All],Flatten[primarDataFullUnitless,1],{targetUnit,1},{}];
resolveChartPlotRange[Histogram|SmoothHistogram,safeOps_,targetUnit_,primarDataFullUnitless_]:=resolvePlotRange[ReplaceAll[Lookup[safeOps,PlotRange],Full->All],Flatten[primarDataFullUnitless,1],{1,targetUnit},{}];


resolveChartErrorBars[chartType:BarChart,primarDataFullUnitless_,safeOps_]:=Module[{errorValues,meanData,dists},
	(* average replicates and replace them with numeric data set *)
	{meanData,errorValues,dists} = processListDataReplicates2[primarDataFullUnitless,Lookup[safeOps,ErrorBars],Lookup[safeOps,ErrorType]];
	errorValues = Replace[errorValues,{{}}|{}->Null,{1}];
	{meanData,errorValues,dists}
];
resolveChartErrorBars[chartType_,primarDataFullUnitless_,safeOps_]:={primarDataFullUnitless,Null,Null};


(* ::Subsubsection::Closed:: *)
(*resolveChartStyle2*)


defaultChartStyleColorList[n_] := ColorFade[{ColorData[97][2],ColorData[97][4],ColorData[97][5],ColorData[97][1]},n];


(* if only one primary per object, then use the normal colors, so leave as automatic *)
(*resolveChartStyle2[unresolvedPlotStyle:Automatic,dataSetSizes_]:=Table[ColorData[97][index],{index,numObjects}];*)

resolveChartStyle2[unresolvedPlotStyle:Automatic,oneDataSet:True]:=ColorData[97][1];
resolveChartStyle2[unresolvedPlotStyle:Automatic,oneDataSet_]:=97;


(* if anything else, leave as-is *)
resolveChartStyle2[unresolvedPlotStyle_,dataSetSizes_]:=unresolvedPlotStyle;


(* ::Subsection:: *)
(*3D Plots*)


(* ::Subsubsection::Closed:: *)
(*patterns*)


QuantityArrayRawPCoordinates3D = EmeraldUnits`Private`quantityArrayRawPTriplets;
nullCoordinates3DP = {{(_?NumericQ|Null),(_?NumericQ|Null),(_?NumericQ|Null)}..};
oneDataSet3DP = Null|nullCoordinates3DP|QuantityArrayRawPCoordinates3D;

nullQuantity3DP = Alternatives[
	{{(_?QuantityQ|Null),(_?QuantityQ|Null),(_?QuantityQ|Null)}..},
	{{(_?NumericQ|Null),(_?NumericQ|Null),(_?NumericQ|Null)}..},
	QuantityArrayRawPCoordinates3D
];

(* This pattern allows the infinity and complex infinity entries *)
nullComplexQuantity3DP = Alternatives[
	{{(_?QuantityQ|Null|Infinity|ComplexInfinity),(_?QuantityQ|Null|Infinity|ComplexInfinity),(_?QuantityQ|Null|Infinity|ComplexInfinity)}..},
	{{(_?NumericQ|Null|Infinity|ComplexInfinity),(_?NumericQ|Null|Infinity|ComplexInfinity),(_?NumericQ|Null|Infinity|ComplexInfinity)}..},
	QuantityArrayRawPCoordinates3D
];



(* ::Subsubsection:: *)
(*Option Functions*)


arrowEpilog[infs:_,ops:_]:=Module[{datas,targetUnits,datasUnitless,colors,epilogs},
	(* Call ELLP's plot styler so that arrow colors will match line colors *)
	colors=Partition[resolvePlotStyle[Automatic,Length[infs],Length[ops[PrimaryData]]],Length[ops[PrimaryData]]];

	(* Extract non-null data *)
	datas=DeleteCases[Lookup[infs,ops[PrimaryData]],NullP,Infinity];

	(* Convert to target units, then strip units *)
	targetUnits=ops[TargetUnits];
	datasUnitless=Unitless[
		If[
			MatchQ[targetUnits,Automatic],
			datas,
			UnitConvert[datas,targetUnits]
		]
	];

	(* Generate arrow epilogs *)
	epilogs=MapThread[buildArrowEpilog[#1,#2,ops]&,{datasUnitless,colors}];
	{Epilog->epilogs}
];


buildArrowEpilog[datas:_,colors:_,ops:_]:=Module[{partitions,arrows},
	(* --- Arrow epilogs: Connect pairs of data points with arrows --- *)
	partitions=(Partition[#,2,1]&/@datas);
	arrows=Table[{Directive[{Arrowheads[ops[ArrowheadSize]],colors[[l]]}],Arrow/@partitions[[l]]},{l,Length@datas}]
];

addCoordinatesToAbsThermoPackets[pac:PacketP[Object[Data,MeltingCurve]],options:OptionsPattern[]]:=pac;
addCoordinatesToAbsThermoPackets[pacs:{packetOrInfoP[Object[Data,MeltingCurve]]..},options:OptionsPattern[]]:=Map[(addCoordinatesToAbsThermoPackets[#,options]&),pacs];
addCoordinatesToAbsThermoPackets[objs:ListableP[ObjectReferenceP[Object[Data,MeltingCurve]]],options:OptionsPattern[]]:=addCoordinatesToAbsThermoPackets[Download[objs],options];
addCoordinatesToAbsThermoPackets[objs:ListableP[LinkP[Object[Data,MeltingCurve]]],options:OptionsPattern[]]:=addCoordinatesToAbsThermoPackets[Download[objs],options];



(* ::Subsection:: *)
(* Extract resolved options from MM Graphics *)


resolvedPlotOptions[
	myFinalPlot:_Graphics|_Graphics3D|_Legended,
	myMostlyResolvedOps:{(_Rule|_RuleDelayed)..},
	plotType_Symbol
]:=Module[
	{unzoomedFinalPlot,optionsToUpdate,absOptions,otherOptions,refinedOptions,updatedOptions},

	(* If the plot is zoomable, return an unzoomable version, otherwise return the original plot *)
	unzoomedFinalPlot=Unzoomable[myFinalPlot];

	(* All remaining options to resolve myMostlyResolvedOps, i.e. those which are Automatic or contain Automatic *)
	optionsToUpdate=Select[myMostlyResolvedOps,!FreeQ[#,Automatic]&];

	(* Read absolute options from the final plot. NOTE: AbsoluteOptions can be slow *)
	absOptions=Quiet[
		AbsoluteOptions[unzoomedFinalPlot/.{
			(* Workaround for bug with AbsoluteOptions *)
			Rule[Frame,{{l_,r_},{b_,t_}}]:>Rule[Frame,{b,l,t,r}]
		}],
		(* Known issues with AbsoluteOptions, Wolfram Redmine #1201 *)
		{Ticks::ticks,ViewPoint::nlist3}
	];

	(* List of options which need to be updated that AbsoluteOptions did NOT return a value for *)
	otherOptions=Complement[optionsToUpdate,FilterRules[optionsToUpdate,absOptions]];

	(* Special resolutions for anything that AbsoluteOptions didn't cover*)
	refinedOptions=Join[absOptions,otherOptions]/.{
		(* Round the significant figures of the PlotRange *)
		Rule[AspectRatio,ar:NumericP]:>Rule[AspectRatio,RoundReals[ar,3]],

		(* Round the signifiant figures of the resolved AspectRatio *)
		Rule[PlotRange,{{l:NumericP,r:NumericP},{b:NumericP,t:NumericP}}]:>Rule[PlotRange,{{RoundReals[l,3],RoundReals[r,3]},{RoundReals[b,3],RoundReals[t,3]}}],
		Rule[PlotRange,{{l:NumericP,r:NumericP},{b:NumericP,t:NumericP},{z1:NumericP,z2:NumericP}}]:>Rule[PlotRange,{{RoundReals[l,3],RoundReals[r,3]},{RoundReals[b,3],RoundReals[t,3]},{RoundReals[z1,3],RoundReals[z2,3]}}],

		(* Reorganize the Frame if it gets output in the old bltr format *)
		Rule[op:Frame|FrameStyle|FrameTicks|FrameTicksStyle|FrameUnits,{b_,l_,t_,r_}]:>Rule[op,{{l,r},{b,t}}],

		(* Resolve GridLines to None if AbsoluteOptions messes things up *)
		Rule[GridLines,{{},{}}]->Rule[GridLines,None],

		(* If ImageSize resolves to a pair replace it with singular number*)
		Rule[ImageSize,{x:NumericP,Automatic}]:>Rule[ImageSize,x],

		(* ChartLayout resolves based on the plotType *)
		Rule[ChartLayout,Automatic]->Rule[ChartLayout,
			Switch[plotType,
				PieChart,"Grouped",
				BarChart,"Grouped",
				BoxWhiskerChart,"Grouped",
				Histogram,"Overlapped",
				_,Null
			]
		],

		(* ChartElementFunction also resolves based on plotType *)
		Rule[ChartElementFunction,Automatic]->Rule[ChartElementFunction,
			Switch[plotType,
				BarChart,"Rectangle",
				BarChart3D,"FadingCube",
				BoxWhiskerChart,"BoxWhisker",
				DistributionChart,"SmoothDensity",
				Histogram,"Rectangle",
				PieChart,"Sector",
				SectorChart,"Sector",
				Histogram3D,"Cube",
				_,Null
			]
		],

		(* Use Mathematica internals to resolve the ChartBaseStyle *)
		Rule[ChartBaseStyle,Automatic]->Rule[
			ChartBaseStyle,
			("DefaultChartBaseStyle"/.(Method/.Charting`ResolvePlotTheme[Automatic,plotType]))/.{"DefaultChartBaseStyle"->None}
		],

		(* Use Mathematica internals to determine the default color function for the plot explicitly *)
		Rule[ColorFunction,Automatic]->Rule[
			ColorFunction,
			("DefaultColorFunction"/.(Method/.Charting`ResolvePlotTheme[Automatic,plotType]))/.{"DefaultColorFunction"->None}
		],

		(* Content selectable should default to false, override in function body if True is needed. *)
		Rule[ContentSelectable,Automatic]->Rule[ContentSelectable,False],

		(* If PolarAxes->False then set PolarAxesOrigin and PolarTicks to Null *)
		Sequence@@If[TrueQ[Lookup[myMostlyResolvedOps,PolarAxes]],
			Nothing,
			{
				Rule[PolarAxesOrigin,Automatic]->Rule[PolarAxesOrigin,Null],
				Rule[PolarTicks,Automatic]->Rule[PolarTicks,Null]
			}
		],

		(* The default plot region is the full scaled coordinate range, but MM doesn't always resolve this for some reason *)
		Rule[PlotRegion,Automatic]->Rule[PlotRegion,{{0,1},{0,1}}],

		(* If PlotTheme is unresolved set it to default. *)
		Rule[PlotTheme,Automatic]->Rule[PlotTheme,"Default"],

		(* The default value of LegendAppearnance is "Column" *)
		Rule[LegendAppearance,Automatic]->Rule[LegendAppearance,"Column"],

		(*** MM Options we want hidden from the user in CC when unused ***)

		(* Baseline Position determine how figures are aligned if they appear in a list, e.g. with text. *)
		Rule[BaselinePosition,Automatic]->Rule[BaselinePosition,Null],
		(* ColorOutput has been deprecated by ColorFunction and does nothing *)
		Rule[ColorOutput,Automatic]->Rule[ColorOutput,Null],
		(* ImageSizeRaw is only used for web embedding and generally has no effect *)
		Rule[ImageSizeRaw,Automatic]->Rule[ImageSizeRaw,Null],
		(* These options can be used as an alternative way to specify chart labels, and should be hidden when unused. *)
		Rule[LabelingFunction,Automatic]->Rule[LabelingFunction,Null],
		Rule[LabelingSize,Automatic]->Rule[LabelingSize,Null],
		(* Method takes a bunch of undocumented values; it's on WRI to do a better job specifying what can go here. *)
		Rule[Method,Automatic]->Rule[Method,Null],
		(* CoordinatesToolOptions passes options to the CoordinatePicker tool, which will generally not be modified *)
		Rule[CoordinatesToolOptions,Automatic]->Rule[CoordinatesToolOptions,Null],
		(* PreserveImageOptions typically only affects dynamics and usually does nothing *)
		Rule[PreserveImageOptions,Automatic]->Rule[PreserveImageOptions,Null]
	};

	(* Join the update rules together *)
	updatedOptions=ReplaceRule[optionsToUpdate,refinedOptions];

	(* Apply the updates and return the result, with Append\[Rule]False to ensure no extra options have been appended. *)
	ReplaceRule[myMostlyResolvedOps,updatedOptions,Append->False]
];

(* Overload for Null input *)
resolvedPlotOptions[Null,myMostlyResolvedOps:{(_Rule|_RuleDelayed)..},plotType_Symbol]:=myMostlyResolvedOps;

(* Overload for generic input, for example, when DisplayFunction is used *)
resolvedPlotOptions[in_,myMostlyResolvedOps:{(_Rule|_RuleDelayed)..},plotType_Symbol]:=resolvedPlotOptions[
	With[{extractedGraphics=Cases[in,Graphics3D[___]|Graphics[___]|Legended[___],Infinity]},
		If[MatchQ[extractedGraphics,{}],Null,Last[extractedGraphics]]
	],
	myMostlyResolvedOps,
	plotType
];



(* ::Subsection::Closed:: *)
(* checkForNullOptions *)


(* If the provided options contain any Null values, warn the user, then drop them from the list. *)
checkForNullOptions[listedOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{nullOptions,nullReplaceRules},

	(* Select all options in listedOps with value of Null *)
	nullOptions=First/@Select[listedOps,Last[#]===Null&];

	(* Warn the user if an option was explicitly specified as Null *)
	If[Length[nullOptions]>0,
		Message[Warning::ExplicitNullOptions,nullOptions]
	];

	(* Return the original options with Null values removed *)
	DeleteCases[listedOps,Rule[_,Null]]
];
checkForNullOptions[emptyOrInvalidOps:{}|Null|$Failed]:=emptyOrInvalidOps;


(* ::Subsection:: *)
(* consolidateOutputs *)


(* Helper function that takes a function, maps it across listed inputs, then returns the aggregated outputs *)
consolidateOutputs[myFunction_Symbol,myInputs_List,ops:OptionsPattern[]]:=Module[
	{safeOps,output,listedOutputs,consolidate},

	(* Extract output *)
	safeOps=SafeOptions[myFunction,ToList@ops];
	output=Lookup[safeOps,Output];

	(* Map function over inputs, returning a list of listed outputs  *)
	listedOutputs=myFunction[Sequence@#,ReplaceRule[safeOps,Output->ToList@output]]&/@myInputs;

	(* Define helper function to combine output content generated by repeated function calls *)
	consolidate=Function[{outputType,outputContent},
		Switch[outputType,

			(* Results are returned as a list *)
			Result,outputType->outputContent,

			(* Previews are merged into a SlideView *)
			Preview,outputType->If[MatchQ[outputContent,_List],SlideView[outputContent],outputContent],

			(* All tests are aggregated into a single list *)
			Tests,outputType->Flatten@outputContent,

			(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
			Options,outputType->MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,DeleteDuplicates@ToList[##]]&,outputContent]

		]
	];

	(* Return specified outputs *)
	output/.MapThread[consolidate,{ToList@output,Transpose[listedOutputs]}]
];


(* Equivalent to consolidateOutputs, except takes the output of mapping the function as input *)
consolidateRawListedOutputs[rawListedOutputs_,myFunction_Symbol,ops:OptionsPattern[]]:=Module[
	{safeOps,output,consolidate},

	(* Extract output *)
	safeOps=SafeOptions[myFunction,ToList@ops];
	output=Lookup[safeOps,Output];

	(* If raw output isn't double listed (Output->Result vs Output->{Result}) then add the list *)
	safeRawOutput=If[MatchQ[output,{__}],
		Transpose@rawListedOutputs,
		{rawListedOutputs}
	];

	(* Define helper function to combine output content generated by repeated function calls *)
	consolidate=Function[{outputType,outputContent},
		Switch[outputType,

			(* Results are returned as a list *)
			Result,outputType->outputContent,

			(* Previews are merged into a SlideView *)
			Preview,outputType->If[MatchQ[outputContent,_List],SlideView[outputContent,Alignment->Center],outputContent],

			(* All tests are aggregated into a single list *)
			Tests,outputType->Flatten@outputContent,

			(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
			Options,outputType->MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,Sequence@@DeleteDuplicates[List@##]]&,outputContent]
		]
	];

	(* Return specified outputs *)
	output/.MapThread[consolidate,{ToList@output,safeRawOutput}]
];


(* ::Subsection:: *)
(* showOptionsTables *)


showOptionsTables[sym_]:=Module[
	{opsByCategory,groupedOpsWithDefaults,groupedOpsList},

	(* Group options by the category they are assigned to *)
	opsByCategory=GroupBy[OptionDefinition[sym],(Lookup[#,"Category"])&];

	(* Extract the option names and their defaults from each group *)
	groupedOpsWithDefaults=Map[
		Transpose@ReleaseHold[{Lookup[#,"OptionName"],Lookup[#,"Default"]}]&,
		opsByCategory
	];

	(* Convert association to list so it is easier to work with *)
	groupedOpsList=Normal[groupedOpsWithDefaults];

	(* Generate a table for each category of options *)
	Map[
		If[MatchQ[First[#],"Hidden"],
			Nothing,
			PlotTable[Last[#],Title->First[#]]
		]&,
		groupedOpsList
	]
];
