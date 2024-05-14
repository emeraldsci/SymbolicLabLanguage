(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Patterns*)


numericMatrixP = _?(ArrayQ[#,2,NumberQ]&);



(* ::Subsection::Closed:: *)
(*unitsAndMagnitudes*)


(* ::Subsubsection:: *)
(*unitsAndMagnitudes*)


unitsAndMagnitudes[qa_?QuantityMatrixQ]:=Module[{ub,units,mags},
	ub = qa["UnitBlock"];
	Switch[ub,
		{Except[_List]..},
			units=ub;
			mags= QuantityMagnitude[qa];,
		Except[_List],
			units = Table[ub,{Length[First[qa]]}];
			mags = QuantityMagnitude[qa];,
		_,
			units = Units[First[qa]];
			mags = QuantityMagnitude[UnitConvert[qa,units]];
	];
	{Map[Quantity[1,#]&,units],mags}
];
unitsAndMagnitudes[qas:{_?QuantityMatrixQ..}]:=Module[{ub, units, mags},
	ub = First[qas]["UnitBlock"];
	Switch[ub,
		{Except[_List]..},
			units=ub;
			mags= QuantityMagnitude[#]& /@ qas;,
		Except[_List],
			units = Table[ub,{Length[First[qas]]}];
			mags = QuantityMagnitude[qas];,
		_,
			units = Units[First[qas]];
			mags = QuantityMagnitude[UnitConvert[qas,units]];
	];
	{Map[Quantity[1,#]&,units],mags}
];
unitsAndMagnitudes[xy_?(MatrixQ[#,NumericQ]&)]:={
	Units[First[xy]],
	xy
};
unitsAndMagnitudes[xy_?MatrixQ]:=Module[{units},
	units = Units[First[xy]];
	{
		units,
		QuantityMagnitude[UnitConvert[xy,units]]
	}
];


(* ::Subsection::Closed:: *)
(*Domain and Range resolution*)


(* ::Subsubsection:: *)
(*resolveDomain*)


resolveDomain[coords_] := MinMax[Map[First, coords]];


(* ::Subsubsection:: *)
(*resolveRange*)


resolveRange[coords_] := MinMax[Map[Last, coords]];


(* ::Subsubsection::Closed:: *)
(*selectInDomain*)


DefineOptions[selectInDomain,
	Options :> {
		{Inclusive -> All, All | Left | Right | None, "Specify if the value on the domain boundary should be selected or not."}
	}];




(* Authors definition for Analysis`Private`selectInDomain *)
Authors[Analysis`Private`selectInDomain]:={"scicomp", "brad"};

selectInDomain[coords_, domain: {xmin_, xmax_}, OptionsPattern[]] := Module[
	{leftComparator, rightComparator},
	{leftComparator, rightComparator} = resolveComparators[OptionValue[Inclusive]];
	Select[coords, And[leftComparator[xmin, #[[1]]], rightComparator[#[[1]], xmax]]&]
];


(* ::Subsubsection::Closed:: *)
(*selectInRange*)


DefineOptions[selectInRange,
	Options :> {
		{Inclusive -> All, All | Left | Right | None, "Specify if the value on the range boundary should be selected or not."}
	}];

Authors[selectInRange]:={"scicomp", "brad"};

selectInRange[coords_, range: {ymin_, ymax_}, OptionsPattern[]] := Module[
	{leftComparator, rightComparator},
	{leftComparator, rightComparator} = resolveComparators[OptionValue[Inclusive]];
	Select[coords, And[leftComparator[ymin, #[[2]]], rightComparator[#[[2]], ymax]]&]
];


(* ::Subsubsection::Closed:: *)
(*selectInDomainAndRange*)


DefineOptions[selectInDomainAndRange,
	Options :> {
		{DomainInclusive -> All, All | Left | Right | None, "Specify if the value on the domain boundary should be selected or not."},
		{RangeInclusive -> All, All | Left | Right | None, "Specify if the value on the range boundary should be selected or not."}
	}];


Authors[selectInDomainAndRange]:={"scicomp", "brad"};
selectInDomainAndRange[coords_, domain: {xmin_, xmax_}, range: {ymin_, ymax_}, OptionsPattern[]] := selectInRange[selectInDomain[coords, domain, Inclusive -> OptionValue[DomainInclusive]], range, Inclusive -> OptionValue[RangeInclusive]];


(* ::Subsubsection::Closed:: *)
(*selectInInterval*)


DefineOptions[selectInInterval,
	Options :> {
		{Inclusive -> All, All | Left | Right | None, "Specify if the value on the interval boundary should be selected or not."}
	}];

Authors[selectInInterval]:={"scicomp", "brad"};

selectInInterval[oneDlist_, interval: {xmin_, xmax_}, OptionsPattern[]] := Module[
	{leftComparator, rightComparator},
	{leftComparator, rightComparator} = resolveComparators[OptionValue[Inclusive]];
	Select[oneDlist, And[leftComparator[xmin, #], rightComparator[#, xmax]]&]
];


(* ::Subsubsection:: *)
(*resolveComparators*)


resolveComparators[All] := {LessEqual, LessEqual};
resolveComparators[Left] := {LessEqual, Less};
resolveComparators[Right] := {Less, LessEqual};
resolveComparators[None] := {Less, Less};


(* ::Subsection::Closed:: *)
(*Nearest*)


nearestXFromX[xlist_,xval_]:=First[Nearest[xlist,xval]];
nearestXFromXY[xy_,xval_]:=With[{nearestX=nearestXFromX[xy[[;;,1]],xval]},First[Pick[xy,xy[[;;,1]],nearestX]]];
nearestYFromXY[xy_,yval_]:=With[{nearestY=nearestXFromX[xy[[;;,2]],yval]},First[Pick[xy,xy[[;;,2]],nearestY]]];



interpolateNearest[xy_,xval_]:=Module[{lower,upper,sorted},
	sorted = SortBy[xy,#[[1]]-xval&];
	upper = First[Select[sorted,#[[1]]>=0&]];
	lower = Last[Select[sorted,#[[1]]<=0&]];
	Interpolation[{lower,upper},InterpolationOrder->1][xval]
];



(* ::Subsection::Closed:: *)
(*Selecting Points*)


(* ::Text:: *)
(*THIS IS REDUNDANTLY DEFINED IN Math.m*)


selectInclusiveMatrixPointsOutsideRangeC:=	selectInclusiveMatrixPointsOutsideRangeC=Core`Private`SafeCompile[{{xy,_Real,2},{b,_Real},{c,_Real}},Select[xy,Or[#[[1]]<=b,#[[1]]>=c]&]];
selectInclusiveListPointsOutsideRangeC:=	selectInclusiveListPointsOutsideRangeC=Core`Private`SafeCompile[{{xy,_Real,1},{b,_Real},{c,_Real}},Select[xy,Or[#<=b,#>=c]&]];

selectInclusiveMatrixPointsInsideRangeC:=	selectInclusiveMatrixPointsInsideRangeC=Core`Private`SafeCompile[{{xy,_Real,2},{b,_Real},{c,_Real}},Select[xy,And[#[[1]]>=b,#[[1]]<=c]&]];

selectInclusiveMatrixPointsLeftOfValueC:=	selectInclusiveMatrixPointsLeftOfValueC=Core`Private`SafeCompile[{{xy,_Real,2},{value,_Real}},Select[xy,#[[1]]<=value&]];
selectInclusiveMatrixPointsRightOfValueC:=	selectInclusiveMatrixPointsRightOfValueC=Core`Private`SafeCompile[{{xy,_Real,2},{value,_Real}},Select[xy,#[[1]]>=value&]];


(* ::Subsection::Closed:: *)
(*Finding Extreme*)


maxPointInterpolateXY[xy_,{xmin_,xmax_}]:=Module[{x},NArgMax[{Interpolation[xy][x],x>=xmin,x<=xmax},x]];
maxPointNearestXY[xy_]:=SortBy[xy,Last][[-1,1]];



extremeFromFunction[f_Function,Min]:=extremeFromFunction[Function[Evaluate[f[-#]]],Max];
extremeFromFunction[f_Function,Max]:=Module[{x,xsol},
	xsol=x/.Last[Quiet[FindMaximum[Abs[f[x]],x],{FindMaximum::lstol}]];
	xsol
];

extremeFromData[xy:numericMatrixP,Min]:=SortBy[xy,Last][[1,1]];
extremeFromData[xy:numericMatrixP,Max]:=SortBy[xy,Last][[-1,1]];


(* ::Subsubsection:: *)
(*y-coord*)


(* ::Subsubsection:: *)
(*x-coord*)


(* ::Text:: *)
(*Sort is faster than Cases or Position here*)


XAtMaxY[xy_]:=SortBy[xy,Last][[-1,1]];
XAtMaxDY[xy_]:=With[{xdy=FiniteDifferencesXY[xy]},XAtMaxY[xdy]];


(* ::Subsubsection:: *)
(*index*)


(* ::Text:: *)
(*Position is fastest here*)


IndexAtMaxY[xy_]:=Position[xy,{_,Max[xy[[;;,2]]]},{1}][[1,1]];
IndexAtMaxDY[xy_]:=With[{dy=FiniteDifferencesXY[xy][[;;,2]]},Position[dy,Max[dy]][[1,1]]];


(* ::Subsection::Closed:: *)
(*Inflection point*)


inflectionPointInterpolateXY[xy_,{xmin_,xmax_}]:=Module[{x},NArgMax[{D[Interpolation[xy][x],x],x>=xmin,x<=xmax},x]];
inflectionPointNearestXY[xy_]:=maxPointNearestXY[finiteDifferences[xy]];




InflectionPointFromFunction[f_Function,"Decreasing"]:=InflectionPointFromFunction[Function[Evaluate[f[-#]]],"Increasing"];
InflectionPointFromFunction[f_Function,"Increasing"]:=Module[{x,df,xsol},
	df=D[f[x],x];
	xsol=x/.Last[Quiet[FindMaximum[Abs[df],x],{FindMaximum::lstol}]];
	xsol
];

inflectionPointFromData[xy:numericMatrixP]:=Module[{},
	{}
];


(* ::Subsection::Closed:: *)
(*Differentiation*)


FiniteDifferencesXY[xy_]:=Module[{x},Transpose[{xy[[;;,1]],ReplaceAll[D[Interpolation[xy][x],x],x->xy[[;;,1]]]}]];
(* this looks incorrect *)
finiteDifferencesX[xlist_]:=Module[{x},ReplaceAll[D[Interpolation[xy][x],x],x->x[[;;,1]]]];


(* ::Subsection::Closed:: *)
(*Interpolation*)


InterpolateXYAtX[xy_,xval_]:=Interpolation[xy][xval];

InterpolateXYAtX[xy_,xval_List]:=Map[Interpolation[xy][#]&,xval];

(* ::Subsection:: *)
(*List Alignment*)


(* ::Subsubsection:: *)
(*ListAlignment*)


DefineOptions[ListAlignment,
	Options:>{
		{Method->Greedy,Greedy,"Alignment method."},
		{Threshold->Automatic,Automatic|ListableP[UnitsP[]],"Any values whose different is greater than this threshold will not be alignmed."}
	}
];



ListAlignment[listA:{},listB:{},ops:OptionsPattern[]]:={};
ListAlignment[listA:{_?NumericQ...},listB:{_?NumericQ...},ops:OptionsPattern[]]:=Module[
	{thresholds,greedy},

	greedy[a_,b:{},dx_,combined_List]:=combined;
	greedy[a:{},b_,dx_,combined_List]:=combined;
	greedy[a_,b_,dx_,combined_List]:=Module[{posA,posB,min,distMat,dxMat},
		distMat = Abs[Outer[List,a,b].{-1,1}];
		dxMat = Table[{1},Length[a]].{dx};
		(* filter out things beyond threshold *)
		distMat = MapThread[If[#1<=#2,#1,Infinity]&,{distMat,dxMat},2];
		min = Min[distMat];
		If[min===Infinity,
			greedy[{},{},{},combined],
			(
				{posA,posB} = First[Position[distMat,min]];
				greedy[Delete[a,posA],Delete[b,posB],Delete[dx,posB],Append[combined,{a[[posA]],b[[posB]]}]]
			)
		]
	];

	thresholds = resolveListAlignmentThreshold[OptionValue[Threshold],listA,listB];

	greedy[listA,listB,thresholds,{}]

];

(* Expand the alignment threshold to correct dimensions for greedy recursive algorithm *)
resolveListAlignmentThreshold[Automatic,listA_,listB_]:=Table[0.5*Mean[MinMax[Join[listA,listB]]],Length[listB]];
resolveListAlignmentThreshold[Null,listA_,listB_]:=Table[0.0,Length[listB]];
resolveListAlignmentThreshold[val_?NumericQ,listA_,listB_]:=Table[val,Length[listB]];
resolveListAlignmentThreshold[val:{_?NumericQ...},listA_,listB_]:=val;
resolveListAlignmentThreshold[val_,listA_,listB_]:=resolveListAlignmentThreshold[Automatic,listA,listB];


(* ::Section:: *)
(*End Context*)


(* ::Section:: *)
(*End Package*)