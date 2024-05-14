(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Common packet fields*)


analysisPacketStandardFieldsStart[unresolvedOps_List]:={
	Author->Link[$PersonID,Simulations],
	UnresolvedOptions->unresolvedOps
};


analysisPacketStandardFieldsFinish[resolvedOps_List]:={
	ResolvedOptions->resolvedOps
};


(* ::Subsection::Closed:: *)
(*Evaluation helpers*)


(* ::Subsubsection::Closed:: *)
(*firstIfEvaluated*)


firstIfEvaluatedVerbose=False;
SetAttributes[firstIfEvaluated,HoldFirst];
firstIfEvaluated[f_[args___]]:=With[
	{out=f[args]},
	If[MatchQ[out,_f],
		Module[{},
			Message[f::EvaluationFailure,ToString[f]];
			If[TrueQ[firstIfEvaluatedVerbose],Print[f[args]];];
			$Failed
		],
		First[out]
	]
];


(* ::Subsection::Closed:: *)
(*Analysis Options*)


Options[analysisOptions]={
	Reference->Null,
	ReferenceField->Null,
	Upload->False,
	App->False,
	Window->DialogInput
};


(* ::Subsection::Closed:: *)
(*Calculus*)


(* ::Subsubsection::Closed:: *)
(*ND*)


ND[dataPts_]:=ND[dataPts,1];
ND[dataPts_,n_]:=Module[{h,xs,ys},
	h=getH[dataPts];
	xs = Table[First[dataPts[[i]]],{i,3,Length[dataPts]-3,1}];
	ys = Table[fivePointStencil[dataPts,i,n,h],{i,3,Length[dataPts]-3,1}];
	Transpose[{xs,ys}]
]/;n<=4;
ND[dataPts_,n_]:=ND[ND[dataPts,4],n-4]/;n>4;

getH[dataPts_]:=(First[Last[dataPts]]-First[First[dataPts]])/Length[dataPts]/;Length[dataPts]>1;
get5[dataPts_,i_]:=Take[dataPts,{i-2,i+2}];

fivePointStencil[dataPts_,i_,n_,h_]:=With[{five=get5[dataPts,i]},1/(12 h) (-Last[(five[[5]])]+8 Last[(five[[4]])]-8 Last[(five[[2]])]+Last[(five[[1]])])]/;n==1;
fivePointStencil[dataPts_,i_,n_,h_]:=With[{five=get5[dataPts,i]},1/(12 h^2) (-Last[five[[5]]]+16 Last[five[[4]]]-30 Last[five[[3]]]+16 Last[five[[2]]]-Last[five[[1]]])]/;n==2;
fivePointStencil[dataPts_,i_,n_,h_]:=With[{five=get5[dataPts,i]},1/(2 h^3) (Last[five[[5]]]-2 Last[five[[4]]]+2Last[five[[2]]]-Last[five[[1]]])]/;n==3;
fivePointStencil[dataPts_,i_,n_,h_]:=With[{five=get5[dataPts,i]},1/h^4 (Last[five[[5]]]-4 Last[five[[4]]]+6 Last[five[[3]]]-4Last[five[[2]]]+Last[five[[1]]])]/;n==4;


(* ::Subsubsection::Closed:: *)
(*nI*)


nI[dataPts_,n_Integer]:=nI[nI[dataPts],n-1];
nI[dataPts_]:=With[{x0=First[dataPts[[1]]],y0=Last[dataPts[[1]]],x1=First[dataPts[[2]]],y1=Last[dataPts[[2]]]},nI[Rest[dataPts],{{(x1+x0)/2,NewtonCotes[{x0,y0},{x1,y1}]}}]];
nI[dataPts_,final_List]:=final/;Length[dataPts]<2;
nI[dataPts_,final_List]:=With[{x0=First[dataPts[[1]]],y0=Last[dataPts[[1]]],x1=First[dataPts[[2]]],y1=Last[dataPts[[2]]],prev=Last[Last[final]]},nI[Rest[dataPts],Append[final,{(x1+x0)/2,prev+NewtonCotes[{x0,y0},{x1,y1}]}]]]/;Length[dataPts]>=2;

NewtonCotes[{x0_,y0_},{x1_,y1_}]:=((x1-x0)/2)(y1+y0);



(* ::Subsection::Closed:: *)
(*Other*)


(* ::Subsubsection::Closed:: *)
(*Domains*)


(* --- Given Explicit Ranges --- *)
Domains[plotData:CoordinatesP,range:{_?NumericQ,_?NumericQ},ops:OptionsPattern[]]:=selectInclusiveMatrixPointsInsideRangeC[plotData,range[[1]],range[[2]]];
Domains[plotData:CoordinatesP,ranges:{{_?NumericQ,_?NumericQ}..},ops:OptionsPattern[]]:=Function[range,selectInclusiveMatrixPointsInsideRangeC[plotData,range[[1]],range[[2]]]]/@ranges;


Domains[qa_?QuantityMatrixQ,ranges:{{_?UnitsQ,_?UnitsQ}},ops:OptionsPattern[]]:=Map[Domains[qa,#]&,ranges];
Domains[qa_?QuantityMatrixQ,range:{_?UnitsQ,_?UnitsQ},ops:OptionsPattern[]]:=Module[{xy,xmin,xmax,unit},
	unit = QuantityUnit[First[range]];
	xy = Unitless[qa,unit];
	{xmin,xmax} = Unitless[range,unit];
	Domains[xy,{xmin,xmax}]
];

(* --- Plot Range Option Form --- *)
Domains[dataPoints:CoordinatesP,ops:OptionsPattern[]]:=Module[{xmin,xmax,ymin,ymax,rangeRules},

	(* expland the plot range to its full form *)
	{{xmin,xmax},{ymin,ymax}}=FullPlotRange[OptionValue[PlotRange]];

	(* Determine the list of rules for what is in range *)
	rangeRules=And[
		First[#]>=(xmin/.{All->-\[Infinity],Full->0,Automatic->-\[Infinity]}),
		First[#]<=(xmax/.{All->\[Infinity],Full->\[Infinity],Automatic->\[Infinity]}),
		Last[#]>=(ymin/.{All->-\[Infinity],Full->0,Automatic->-\[Infinity]}),
		Last[#]<=(ymax/.{All->\[Infinity],Full->\[Infinity],Automatic->\[Infinity]})
	]&;

	(* Select out only the points that meet the rules *)
	Select[dataPoints,rangeRules]

];

(* --- Plot Range Option Form that takes in DateCoordinateP--- *)
Domains[dataPoints:DateCoordinateP,ops:OptionsPattern[]]:=Module[{xmin,xmax,ymin,ymax,xminFinal,xmaxFinal,yminFinal,ymaxFinal,rangeRules},

	(* expland the plot range to its full form *)
	{{xmin,xmax},{ymin,ymax}}=FullPlotRange[OptionValue[PlotRange]];

	(*pull out the xmin,xmax,ymin,ymax to their values*)
	xminFinal = (xmin/.{All->(DateList[0]),Full->(DateList[0]),Automatic->(DateList[0])});
	xmaxFinal = (xmax/.{All->{9999,12,31,11,59,59.},Full->{9999,12,31,11,59,59.},Automatic->{9999,12,31,11,59,59.}});
	yminFinal = (ymin/.{All->-\[Infinity],Full->0,Automatic->-\[Infinity]});
	ymaxFinal = (ymax/.{All->\[Infinity],Full->\[Infinity],Automatic->\[Infinity]});

	(* Determine the list of rules for what is in range *)
	rangeRules=Quiet@And[
		QuantityMagnitude[DateDifference[First[#],xminFinal]]<=0,
		QuantityMagnitude[DateDifference[First[#],xmaxFinal]]>=0,
		Last[#]>=yminFinal,
		Last[#]<=ymaxFinal
	]&;

	(* Select out only the points that meet the rules *)
	Select[dataPoints,rangeRules]

];


Domains[dataPoints:{(CoordinatesP|DateCoordinateP)..},ops:OptionsPattern[]]:=Domains[#,ops]&/@dataPoints;

Domains[plotDatas:{CoordinatesP..},ranges:({{_?NumericQ,_?NumericQ}..}|{_?NumericQ,_?NumericQ}),ops:OptionsPattern[]]:=Domains[#,ranges,ops]&/@plotDatas;



(* ::Subsection::Closed:: *)
(*Indexing*)


(* ::Subsubsection::Closed:: *)
(*XIndexAtExtremeY*)


XIndexAtExtremeY[xy_, Min] := Position[xy[[;;, 2]], Min[xy[[;;, 2]]]][[1, 1]];
XIndexAtExtremeY[xy_, Max] := Position[xy[[;;, 2]], Max[xy[[;;, 2]]]][[1, 1]];


(* ::Subsubsection::Closed:: *)
(*XIndexAtExtremeDY*)


XIndexAtExtremeDY[xy_, Min] := With[{dy = finiteDifferences2D[xy][[;;, 2]]}, Position[dy, Min[dy]][[1, 1]]];
XIndexAtExtremeDY[xy_, Max] := With[{dy = finiteDifferences2D[xy][[;;, 2]]}, Position[dy, Max[dy]][[1, 1]]];


(* ::Subsection::Closed:: *)
(*Smoothing*)


(* ::Subsubsection::Closed:: *)
(*gaussianSmooth1D*)


gaussianSmooth1D[xy_] := gaussianSmooth1D[xy, 3];
gaussianSmooth1D[xy_, radius_] := Transpose[{xy[[;;, 1]], GaussianFilter[xy[[;;, 2]], radius]}];


(* ::Subsection::Closed:: *)
(*Differentiation*)


(* ::Subsubsection::Closed:: *)
(*finiteDifferences2D*)


(* Using default Interpolation is not strictly a finite difference by definition *)
finiteDifferences2D[xy_] := Module[{x}, Transpose[{xy[[;;, 1]], ReplaceAll[D[Interpolation[xy][x], x], x -> xy[[;;, 1]]]}]];


(* ::Subsection::Closed:: *)
(*MidPoint*)


(* ::Subsubsection::Closed:: *)
(*sigmoidMidPoint*)


sigmoidMidPoint[func_Function, min_, max_] := midPointFromFunction[func, min, max]; (* midpoint relative to min & max, not relative to sigmoid's min & max *)
sigmoidMidPoint[func_, g_] := sigmoidInflectionPoint[func, g]; (* same for symmetric sigmoid *)

sigmoidMidPoint[xy: CoordinatesP, min_, max_] := Module[
	{xmin, xmax, initialTemps, xyInterp, roots, filteredRoots},

	(* create a list of possible initial temperature guesses from xy data *)
	{xmin, xmax} = MinMax[First/@xy];
	initialTemps = Subdivide[xmin, xmax, 10];

	(* create interpolator of the xy data *)
	xyInterp = Interpolation[xy];

	(* now map the find root helper function over the initial temps *)
	roots = findRoots[xyInterp, 0.5, initialTemps];

	(* remove any roots that are outside the domain *)
	filteredRoots = DeleteCases[roots, _?((#<xmin || #>xmax)&)];

	(* return the mean of the roots *)
	Mean[filteredRoots]
];

(* not working if data looks like a parabola TODO: find out who did this and beat them*)
(*sigmoidMidPoint[xy: CoordinatesP, min_, max_] := Interpolation[Reverse /@ xy][(min + max) / 2.];*)

(* helper that finds roots of 'func[x] = constant' equation by sampling the specified starting points *)
findRoots[function_, constant_, initialPoints_List]:=Module[
	{rootFindingFunc, rootValues, rootResults, functionEvalAtRoots, goodRootValues},

	(* define the root finding function here *)
	rootFindingFunc = Function[{initialPoint},
		FindRoot[function[input]==constant, {input, initialPoint}]
	];

	(* Turn off the messages because they are getting picked up by the unit-testing framework despite the quiet calls below *)
	Off[InterpolatingFunction::dmval];
	Off[FindRoot::lstol];
	
	(* find the single valued roots for each starting point *)
	rootResults = Quiet[
		Map[rootFindingFunc, initialPoints],
		{InterpolatingFunction::dmval, FindRoot::lstol}
	];

	(* flatten the results into a single list of rules, and extract the values *)
	rootValues = Values[Flatten[rootResults]];

	(* evaluate the input function at root values and check for convergence *)
	(* sometimes FindRoot gets confused and stuck in a local minimum that is far from optimal *)
	functionEvalAtRoots = Quiet[(function /@ rootValues), {InterpolatingFunction::dmval}] - constant;

	(* turn the messages back on *)
	Off[InterpolatingFunction::dmval];
	Off[FindRoot::lstol];

	(* pick root values with function[root] - constant ~ zero *)
	goodRootValues = PickList[rootValues, functionEvalAtRoots, _?(Abs[#]<0.01&)];

	(* round the values to 5 decimal places, and find unique values *)
	Union[Round[goodRootValues,0.00001]]
];


(* ::Subsubsection::Closed:: *)
(*midPointFromFunction*)


midPointFromFunction[f_, min_, max_] := Module[
	{x, xsols},
	xsols = Quiet[x /. NSolve[f[x] == ((min + max) / 2.), x, Reals], {Solve::ratnz}];
	If[Length[xsols] > 1, Message[midPointFromFunction::NotOneToOneMapping]];
	First[Sort[Select[xsols, Positive]]]
];


(* ::Subsubsection::Closed:: *)
(*XAtExtremeY*)


XAtExtremeY[xy_, Min] := SortBy[xy, Last][[1, 1]];
XAtExtremeY[xy_, Max] := SortBy[xy, Last][[-1, 1]];


(* ::Subsubsection::Closed:: *)
(*sigmoidInflectionPoint*)


sigmoidInflectionPoint[f_Function, g_] := First[#1 /. Solve[Evaluate[First[Cases[f, g[args___] :> args, Infinity]]] == 0, #1]];


(* ::Section:: *)
(*End Context*)


(* ::Section:: *)
(*End Package*)
