(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*SampleDistribution*)


(* ::Subsubsection:: *)
(*SampleDistribution*)


SampleDistribution/:DistributionParameterQ[_SampleDistribution]:=True;


SampleDistribution[pts_]["DataPoints"]:=pts;
SampleDistribution[pts_]["SampleSize"]:=Length[pts];

sampleOperationsP = Mean|StandardDeviation|Variance|Median|Quantile;
SampleDistribution/: (f:sampleOperationsP)[SampleDistribution[pts_],rest___]:=f[pts,rest];
(* these retain their SampleDistribution head after operation *)
sampleSampleOperationsP = QuantityMagnitude|UnitConvert|Convert;
SampleDistribution/: (f:sampleSampleOperationsP)[SampleDistribution[pts_],rest___]:=SampleDistribution[f[pts,rest]];

SampleDistribution[d_DataDistribution]:=SampleDistribution[Normal[EmpiricalDistributionPoints[d]]];
SampleDistribution[QuantityDistribution[d_DataDistribution,un_]]:=SampleDistribution[EmpiricalDistributionPoints[d]*Quantity[un]];
SampleDistribution/: EmpiricalDistribution[SampleDistribution[pts_List]]:=EmpiricalDistribution[pts];




(* ::Subsubsection:: *)
(*SampleDistributionP*)


SampleDistributionP = SampleDistribution[{UnitsP[]...}|QuantityArrayP[]];


(* ::Subsection::Closed:: *)
(*Probability and Statistics*)


(* ::Subsubsection::Closed:: *)
(*CoefficientOfVariation*)


CoefficientOfVariation[mean_,stddev_]:= stddev/mean;
CoefficientOfVariation[PlusMinus[mean_,stddev_]]:=CoefficientOfVariation[mean,stddev];
CoefficientOfVariation[NormalDistribution[m_,s_]]:=CoefficientOfVariation[m,s];
CoefficientOfVariation[d_?DistributionParameterQ]:=CoefficientOfVariation[Mean[d],StandardDeviation[d]]

(* small sample correction *)
CoefficientOfVariation[vals_List]:=With[{n=Length[vals],m=Mean[vals],s=StandardDeviation[vals]},(1+4/n)*s/m];



(* ::Subsubsection::Closed:: *)
(*ConfidenceInterval*)


ConfidenceInterval[d:(_?DistributionParameterQ|{_?NumericQ..})]:=ConfidenceInterval[d,0.95];
ConfidenceInterval[d:(_?DistributionParameterQ|{_?NumericQ..}),cl_]:=safeQuantile[d,{(1-cl)/2,1-(1-cl)/2}];


safeQuantile[d_,q_]:=Module[{distQuantile},
	distQuantile=Quantile[d,q];
	If[AnyTrue[distQuantile,MatchQ[Head[#],Quantile]&],
		Quantile[RandomVariate[d,1000],q],
		distQuantile
	]
]


(* ::Subsubsection::Closed:: *)
(*transformGaussian*)


transformGaussian[g_Function,ms:{{_?NumericQ,_?NumericQ}..},ops:OptionsPattern[]]:=Map[transformGaussian[g,#,ops]&,ms]
transformGaussian[g_Function,{m_?NumericQ,s_?NumericQ}]:=Module[{X},
	{Expectation[g[X],X \[Distributed] NormalDistribution[m,s]],StandardDeviation[TransformedDistribution[g[X], X \[Distributed] NormalDistribution[m, s]]]}
]


(* ::Subsubsection::Closed:: *)
(*computePropagatedError*)


computePropagatedError::BadXYPoints="Length of xVals and \[Sigma]x must match if \[Sigma]x is a list.";
computePropagatedError[g_Function,xVals:NVectorP,\[Sigma]x_,\[Sigma]yfit_?NumericQ]:=Module[
		{yVals,\[Sigma]y,\[Sigma]yfcn,sxvals},

	(* get sd for each x point *)
	sxvals=Switch[\[Sigma]x,
		_?NumericQ, ConstantArray[\[Sigma]x,Length[xVals]],
		_Function, \[Sigma]x[xVals],
		_List, If[SameQ[Length[xVals],Length[\[Sigma]x]],\[Sigma]x,Message[computePropagatedError::BadXYPoints]; Return[Null]]
	];

	(* Compute mean and sd of y=g[X] at each x point *)
	{yVals, \[Sigma]yfcn} = Transpose[transformGaussian[g, Transpose[{xVals, sxvals}]]];

	(* Total error is fit error plus uncertainty error  *)
	\[Sigma]y=\[Sigma]yfit+\[Sigma]yfcn;

	(* Return list of sd and mean pairs *)
	Transpose[{\[Sigma]y,yVals}]
	]

(*  *)
computePropagatedError[g_Function,xVals:NVectorP,\[Sigma]x_,ops:OptionsPattern[]]:=
	computePropagatedError[g,xVals,\[Sigma]x,0.,ops]


(* ::Subsubsection::Closed:: *)
(*RSquared*)


RSquared[measurements:{_?NumericQ..},modeled:{_?NumericQ..}]:=	1 - (SumSquaredError[measurements,modeled] / SumSquaredError[measurements,Mean[measurements]])
RSquared[xy:CoordinatesP,f_Function]:=	RSquared[ xy[[;;,2]] , f/@xy[[;;,1]] ]


(* ::Subsubsection::Closed:: *)
(*adjustedRSquared*)


adjustedRSquared[measurements:{_?NumericQ..},modeled:{_?NumericQ..},numPars_Integer]:=With[
	{
		r2=RSquared[measurements,modeled],
		n = Length[measurements]
	},
(*	1 - (1-r2)*(n-1)/(n-numPars-1) *) (* thought this was the formula, but apparenlty not *)
	1 - (1-r2)*(n-1)/(n-numPars)  (* this is what matches MM's AdjustedRSquared *)

]


(* ::Subsubsection::Closed:: *)
(*safeNormalDistribution*)


(*
	NormalDistributions can't have zero StandardDeviation,
	so in that case we make EmpiricalDistribution with one data point.
*)
safeNormalDistribution[m_,s_] := If[MatchQ[m, Null] || MatchQ[s, Null], Null,
	With[
		{
			smag=QuantityMagnitude[s],
			mmag=QuantityMagnitude[m]
		},
		If[smag == 0,
			EmpiricalDistribution[{mmag}],
			NormalDistribution[mmag,smag]
		]
	]
];


(* ::Subsubsection:: *)
(*SumSquaredError*)


SumSquaredError[listA:{_?NumericQ..},b_?NumericQ]:=Total[(listA-b)^2]
SumSquaredError[listA:{_?NumericQ..},listB:{_?NumericQ..}]:=Total[(listA-listB)^2]

SumSquaredError[dataPoints:{{_?NumericQ,_?NumericQ}..},func_Function]:=SumSquaredError[func/@dataPoints[[;;,1]],dataPoints[[;;,2]]]

SumSquaredError[dataPoints:{{_?NumericQ,_?NumericQ}..},expression_,params:{Rule[_,_?NumericQ]..},variable_]:=
	SumSquaredError[dataPoints, (expression/.params)/.variable->#& ]



(* ::Subsection::Closed:: *)
(*Uncertainty Propagation & Prediction*)


(* ::Subsubsection::Closed:: *)
(*PropagateUncertainty*)


DefineOptions[PropagateUncertainty,
	Options :> {
		{Method -> Automatic, Parametric | Empirical | TransformedDistribution | Automatic, "If Parametric, propagate uncertainty analytically to obtain parametric distribution.  If Empirical, sample expression repeatedly to obtain empirical distribution."},
		{NumberOfSamples -> Automatic, Automatic | _Integer?Positive, "Number of samples to use if using Empirical method."},
		{SamplingMethod -> Automatic, Automatic | LatinHypercube | Sobol | Random, "Method to be used in sampling."},
		{Output -> Distribution, All | Packet | _Symbol, "Value to be returned."},
		{ConfidenceLevel -> 95*Percent, UnitsP[1], "Confidence interval to be used in calculation."}
	}
];


(* prevent expression from evaluating immediately *)
SetAttributes[PropagateUncertainty,HoldFirst];


(* evaluate expression for single distribution case *)
PropagateUncertainty[dist_,ops:(___Rule)]:=Block[{$DistributionMath=False},With[{x=Unique["X"]},
	PropagateUncertainty[x,{x\[Distributed]dist},ops]
	(*
		use /; at end here to prevent it evaluating until it checks structure of all arguments,
		because DistributionParameterQ sometimes throws messages
	*)
]]/; Block[{$DistributionMath=False},DistributionParameterQ[dist]];

(* evaluate expression for general case *)
PropagateUncertainty[expr_,ops:(___Rule)]:=Block[{$DistributionMath=False},Module[
	{
		exprHold,
		posTransformed,
		distTransformed,
		uniqueTransformed,
		varsTransformed,
		rulesTransformed,
		exprTransformed,
		distReplaceList,
		exprReplaced,
		rulesReplaced
	},

	(* hold expression to prevent early evaluation *)
	exprHold=Hold[expr];

	(* positions and distributions of TransformedDistributions in input expression *)
	posTransformed=Position[exprHold,_TransformedDistribution];
	distTransformed=Extract[exprHold,posTransformed];

	(* replace random variables in TransformedDistributions with unique random variables *)
	uniqueTransformed=replaceTransformedDistribution/@distTransformed;

	(* extract transformations and rules from TransformedDistributions *)
	varsTransformed=Part[#,1,1]&/@uniqueTransformed;
	rulesTransformed=Flatten[extractTransformedDistributionRules[Part[#,1,2]]&/@uniqueTransformed];

	exprTransformed=ReplacePart[exprHold,MapThread[Rule[#1,#2]&,{posTransformed,varsTransformed}]];

	(* initialize ordered distribution replace list *)
	distReplaceList={_QuantityDistribution,_};

	(* replace distributions in distReplaceList with unique random variables *)
	{exprReplaced,rulesReplaced}=Fold[replaceDistribution,{exprHold,{}},distReplaceList];

	PropagateUncertainty[
		Evaluate[ReleaseHold[exprReplaced]],
		Join[rulesReplaced],
		ops
	]
]];


(* apply function (possibly with uncertainty) to uncertain value *)
PropagateUncertainty[f_Function,d_?DistributionParameterQ,ops:OptionsPattern[]]:=Block[{$DistributionMath=False},Module[{X},
	PropagateUncertainty[f[X],X\[Distributed]d,ops]
]];

(* apply function (possibly with uncertainty) to fixed value *)
PropagateUncertainty[f_Function,x_?NumericQ,ops:OptionsPattern[]]:=Block[{$DistributionMath=False},PropagateUncertainty[f[x],ops]];


PropagateUncertainty[expr_,ds:(_Rule|_Distributed),ops:OptionsPattern[]]:=Block[{$DistributionMath=False},PropagateUncertainty[expr,{ds},ops]];
PropagateUncertainty[expr0_,ds0:{(_Rule|_Distributed)...},ops:OptionsPattern[]]:=Block[{$DistributionMath=False},Module[
	{ds,constantVals,distributionVals,expr,safeOps,out,method, sampleDistributionQ},

	safeOps = SafeOptions[PropagateUncertainty, ToList[ops]];

	(* replace any terms with zero uncertainy with fixed value rules *)
	ds = Replace[ds0,(Distributed|Rule)[x_,NormalDistribution[m_,0|0.]]:>Rule[x,m],{1}];

	distributionVals = Cases[ds,_Distributed|Rule[_,Except[_Quantity|_?NumericQ,_?DistributionParameterQ]]];

	(* do this before swapping out the SampleDistributions *)
	method = resolvePropagateUncertaintyMethod[Lookup[safeOps,Method],distributionVals];

	sampleDistributionQ = MemberQ[distributionVals,_[_,_SampleDistribution]];
	If[sampleDistributionQ,
		distributionVals = distributionVals /. {
			(h:(Rule|Distributed))[n_,s_SampleDistribution] :> h[n,EmpiricalDistribution[s]]
		};
	];

	constantVals = Select[ds,!MemberQ[distributionVals[[;;,1]],#[[1]]]&];

(*
	Need to fix issue with Hold and substituting in the constant values
*)

	out = Switch[method,
		Automatic|TransformedDistribution,
			expr = expr0/.constantVals;
			PropagateUncertaintyTransformedDistribution[expr,distributionVals,safeOps],
		Parametric,
			expr = expr0/.constantVals;
			PropagateUncertaintyParametric[expr,distributionVals,safeOps],
		Empirical,
			expr = Hold[expr0]/.constantVals;
			PropagateUncertaintyEmpirical@@Append[Append[expr,distributionVals],safeOps]
	];

	If[sampleDistributionQ,
		out = out /. {
			qd:QuantityDistribution[_DataDistribution,_]:> SampleDistribution[qd],
		  ed_DataDistribution :> SampleDistribution[ed]
		}
	];

	Switch[Lookup[safeOps,Output],
		All|Packet|Null,
			out,
		_,
			Lookup[out,OptionValue[Output]]
	]
]];


replaceTransformedDistributionRules[Distributed[rvList_List,rvDist_]]:=Module[{replaceVars},
	replaceVars=Table[Unique["X"],Length[rvList]];
	MapThread[Rule[#1,#2]&,{rvList,replaceVars}]
];
replaceTransformedDistributionRules[Distributed[rv_,rvDist_]]:=Rule[rv,Unique["X"]];
replaceTransformedDistributionRules[distributedList_List]:=Module[{rvList,replaceVars},
	rvList=First/@distributedList;
	replaceVars=Table[Unique["X"],Length[rvList]];
	MapThread[Rule[#1,#2]&,{rvList,replaceVars}]
];

replaceTransformedDistribution[transDist_]:=Module[{replaceRules},
	replaceRules=replaceTransformedDistributionRules[Part[transDist,2]];
	ReplaceAll[Hold[transDist],replaceRules]
];


extractTransformedDistributionRules[Distributed[rvList_List,rvDist_]]:=Distributed[#,rvDist]&/@rvList;
extractTransformedDistributionRules[distributed_]:=distributed;


replaceDistribution[{expr0_,rules0_},patt_]:=Module[{pos,dist,vars,rules},
	pos=Position[expr0,_?(MatchQ[#,patt]&&DistributionParameterQ[#]&)];
	dist=Extract[expr0,pos];
	vars=Table[Unique["X"],{Length[dist]}];
	rules=Thread[Distributed[vars,dist]];
	{ReplacePart[expr0,Thread[Rule[pos,vars]]],Join[rules0,rules]}
];


(* if single data distribution, use TransformedDistribution *)
resolvePropagateUncertaintyMethod[Automatic,dists:{Distributed[_,_DataDistribution]}]:=TransformedDistribution;
(* else if more than just one data distribution, use Empirical *)
resolvePropagateUncertaintyMethod[Automatic,dists:{___,Distributed[_,((_DataDistribution|_SampleDistribution)|QuantityDistribution[(_DataDistribution|_SampleDistribution),_])],___}]:=Empirical;
(* else if empty list, use Parametric *)
resolvePropagateUncertaintyMethod[Automatic,dists:{}]:=Parametric;
(* else if list, use TransformedDistribution *)
resolvePropagateUncertaintyMethod[Automatic,dists_List]:=TransformedDistribution;
(* else leave as is *)
resolvePropagateUncertaintyMethod[method_,_]:=method;


(* ::Subsubsection::Closed:: *)
(*PropagateUncertaintyTransformedDistribution*)


PropagateUncertaintyTransformedDistribution[expr_,distributionVals:{(_Distributed|_Rule)...},safeOps_]:=Module[
	{returnOp,dist},
	returnOp=Lookup[safeOps,Output];
	dist = TransformedDistribution[expr,distributionVals];
	{
		checkPropagateUncertaintyReturn[returnOp,Mean,Mean[dist]],
		checkPropagateUncertaintyReturn[returnOp,StandardDeviation,StandardDeviation[dist]],
		checkPropagateUncertaintyReturn[returnOp,Distribution,dist],
		checkPropagateUncertaintyReturn[returnOp,Method,TransformedDistribution],
		checkPropagateUncertaintyReturn[returnOp,NumberOfSamples,Null],
		checkPropagateUncertaintyReturn[returnOp,ConfidenceInterval,ConfidenceInterval[dist,Lookup[safeOps,ConfidenceLevel]]]
	}
];


(* ::Subsubsection::Closed:: *)
(*PropagateUncertaintyParametric*)


PropagateUncertaintyParametric[expr0_,distributionVals:{(_Distributed|_Rule)...},safeOps_]:=Module[
	{returnOp,expr,exprUnit,exprMagnitude,distPars,distDists,distParLengths,distUnits,means,grad,covarianceMatrix,m,s,dist},

	returnOp=Lookup[safeOps,Output];

	distPars=distributionVals[[;;,1]];
	distDists=distributionVals[[;;,2]];
	distParLengths=Max[Length[#],1]&/@distPars;

	distPars=Flatten[{distPars}];
	distUnits=MapThread[Sequence@@Table[safeQuantityUnit[#1],#2]&,{distDists,distParLengths}];
	distDists=safeQuantityMagnitude/@distDists;

	expr=ReplaceAll[expr0,MapThread[Rule[#1,safeQuantity[#1,#2]]&,{distPars,distUnits}]];
	exprUnit=safeQuantityUnit[expr];
	exprMagnitude=safeQuantityMagnitude[expr];

	means = Flatten[{Mean/@distDists}];
	covarianceMatrix = fullCovarianceMatrix[distDists];
	grad = If[MatchQ[distPars,{}],
		{},
		Grad[exprMagnitude,distPars]/.Thread[Rule[distPars,means]]
	];

	m=safeQuantity[ReplaceAll[exprMagnitude,Thread[Rule[distPars,means]]],exprUnit];
	s=safeQuantity[Which[
		MatchQ[grad,{}], 0.0,
		True, First[Flatten[Sqrt[{grad}.covarianceMatrix.Transpose[{grad}]]]]
	],exprUnit];

	dist = If[MatchQ[s,0|0.0|_Quantity?(MatchQ[QuantityMagnitude[#],0|0.]&)],
		EmpiricalDistribution[{m}],
		NormalDistribution[m,s]
	];

	{
		checkPropagateUncertaintyReturn[returnOp,Mean,m],
		checkPropagateUncertaintyReturn[returnOp,StandardDeviation,s],
		checkPropagateUncertaintyReturn[returnOp,Distribution,dist],
		checkPropagateUncertaintyReturn[returnOp,Method,Parametric],
		checkPropagateUncertaintyReturn[returnOp,NumberOfSamples,Null],
		checkPropagateUncertaintyReturn[returnOp,ConfidenceInterval,ConfidenceInterval[dist,Lookup[safeOps,ConfidenceLevel]]]
	}
];


(* make a block-diagonal matrix of the covariance matrices of each distribution *)
fullCovarianceMatrix[dists:{}]:={}; (* if no distributions *)
fullCovarianceMatrix[dists_List]:=ArrayFlatten[ReplacePart[IdentityMatrix[Length[dists]],Table[{ix,ix}->safeCovariance[dists[[ix]]],{ix,1,Length[dists]}]]];
(* because Covariance does not work on multidimensional distributions *)
safeCovariance[d_]:=Quiet[Check[Covariance[d],{{Variance[d]}}],{Covariance::arg1}];



(* ::Subsubsection::Closed:: *)
(*PropagateUncertaintyEmpirical*)


SetAttributes[PropagateUncertaintyEmpirical,HoldFirst];
PropagateUncertaintyEmpirical[expr0_,distributionVals:{(_Distributed|_Rule)...},safeOps_]:=Module[
	{returnOp,expr,distPars,distDists,distUnits,samplingMethod,n,distrSets,distrSamples,exprSamples,dist},
	returnOp=Lookup[safeOps,Output];

	distPars=distributionVals[[;;,1]];
	distDists=distributionVals[[;;,2]];

	distUnits=safeQuantityUnit/@distDists;

	(* NOTE: expr is evaluated here to speed up QuantityDistribution calculations *)
	expr=Quiet[
		ReleaseHold[ReplaceAll[Hold[expr0],MapThread[Rule[#1,safeFakeQuantity[#1,#2]]&,{distPars,distUnits}]]]/.IndependentUnit["1"]->1,
		{Quantity::compat}
	];

	distDists=safeQuantityMagnitude/@distDists;

	{samplingMethod,n}=resolveSamplingMethodAndSampleSize[Lookup[safeOps,SamplingMethod],Lookup[safeOps,NumberOfSamples],distDists];

	distrSets=SampleFromDistribution[distDists,n,SamplingMethod->samplingMethod];

	distrSamples=MapThread[Rule,{distPars,distrSets}];

	(* this is flattening out anything that came from a multivariate distribution *)
	distrSamples=Flatten[Map[
		If[MatchQ[#[[1]],_List],Thread[#[[1]]->Transpose[#[[2]]]],{#}]&,
		distrSamples
	],1];

	(* substitute all samples in at once.  Works as long as expression is made of listable functions *)
	(* also, to make this faster, should convert all compatible quantities to same units, but that's a little tricky to do based just on the distributions *)
	(* if there are no distributions, just repeat the expression *)
	exprSamples=If[MatchQ[distrSamples,{}],
		Table[expr,n],
		Map[ReplaceAll[expr,#]&,Transpose[Map[Thread,distrSamples]]]/.Hold->Identity
	];

	dist = If[And[Cases[distributionVals,_DataDistribution,Infinity]==={},Cases[distributionVals,_SampleDistribution,Infinity]=!={}],
		SampleDistribution[exprSamples],
		EmpiricalDistribution[exprSamples]
	];

	{
		checkPropagateUncertaintyReturn[returnOp,Mean,Mean[exprSamples]],
		checkPropagateUncertaintyReturn[returnOp,StandardDeviation,safeStandardDeviation[exprSamples]],
		checkPropagateUncertaintyReturn[returnOp,Distribution,dist],
		checkPropagateUncertaintyReturn[returnOp,Method,Empirical],
		checkPropagateUncertaintyReturn[returnOp,NumberOfSamples,n],
		checkPropagateUncertaintyReturn[returnOp,ConfidenceInterval,ConfidenceInterval[dist,Lookup[safeOps,ConfidenceLevel]]]
	}
];




resolveSamplingMethodAndSampleSize[Automatic,Automatic,dists:{(_DataDistribution|_SampleDistribution|QuantityDistribution[_DataDistribution|_SampleDistribution,_])..}]:=Module[{sizes},
	sizes=Map[Length[EmpiricalDistributionPoints[#]]&,Replace[dists,qd_QuantityDistribution:>QuantityMagnitude[qd],{1}]];
	If[
		Times@@sizes<1000,
		{All,Times@@sizes},
		{resolveSamplingMethod[Automatic,dists],1000}
	]
];
resolveSamplingMethodAndSampleSize[method_,Automatic,dists_]:={resolveSamplingMethod[method,dists],1000};
resolveSamplingMethodAndSampleSize[method_,n_,dists_]:={resolveSamplingMethod[method,dists],n};


resolveSamplingMethod[method_,dists_]:=Switch[method,
	Automatic, If[AnyTrue[dists,MultivariateDistributionQ],Random,Sobol],
	_, method
];


safeStandardDeviation[{}]:=0.;
safeStandardDeviation[{Except[_List]}]:=0.;
safeStandardDeviation[in_]:=StandardDeviation[in];


(* ::Subsubsection::Closed:: *)
(*safeQuantity Functions*)


safeQuantity[par_,Null]:=par;
safeQuantity[par_,unit_]:=Quantity[par,unit];

safeFakeQuantity[par_,Null]:=Quantity[par,IndependentUnit["1"]];
safeFakeQuantity[par_,unit_]:=Quantity[par,unit];



safeQuantityUnit[d_]:=Module[{distQuantityUnit},
	distQuantityUnit=QuantityUnit[d];
	If[MatchQ[Head[distQuantityUnit],QuantityUnit],
		Null,
		distQuantityUnit
	]
];


safeQuantityMagnitude[d_]:=Module[{distQuantityMagnitude},
	distQuantityMagnitude=QuantityMagnitude[d];
	If[MatchQ[Head[distQuantityMagnitude],QuantityMagnitude],
		d,
		distQuantityMagnitude
	]
];


(* ::Subsubsection::Closed:: *)
(*checkPropagateUncertaintyReturn*)


SetAttributes[checkPropagateUncertaintyReturn,HoldAll];
checkPropagateUncertaintyReturn[returnOp_,exprOp_,expr_]:=If[MatchQ[returnOp,exprOp|All|Packet|Null],exprOp->expr,Nothing];


(* ::Subsubsection::Closed:: *)
(*MeanPrediction*)


(*
	amir: 07.01.2020 note that Automatic does not behave well as the PropagateUncertainty for
 	TransformedDistribution is not written yet
*)

DefineOptions[MeanPrediction,
	Options :> {
		{Method -> Parametric, Parametric | Empirical | Automatic, "If Parametric, propagate uncertainty analytically to obtain parametric distribution.  If Empirical, sample expression repeatedly to obtain empirical distribution."},
		{NumberOfSamples -> Automatic, Automatic | _Integer?Positive, "Number of samples to use if using Empirical method."}
	}];


MeanPrediction[fitObj:ObjectReferenceP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=MeanPrediction[Download[fitObj],x,ops];
MeanPrediction[fitPacket:PacketP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=Module[
	{errF,ym,ysd,dyFromdx,xUnit,yUnit,xdist,xm,xsd,f,safeOps,fExpr,pdist,xvar},
	safeOps = SafeOptions[MeanPrediction, ToList[ops]];

	{xUnit,yUnit}=packetLookup[fitPacket,DataUnits];

	xdist = toDistribution[x,xUnit];

	fExpr = Function@@packetLookup[fitPacket,{BestFitVariables,SymbolicExpression}];

	pdist = fitAnalysisParameterDistribution[packetLookup[fitPacket,{BestFitParametersDistribution,CovarianceMatrix,BestFitParameters}]];

	PropagateUncertainty[
		Evaluate[Quantity[fExpr[xvar],yUnit]],
		Flatten[{pdist,xvar\[Distributed]xdist}],
		PassOptions[MeanPrediction,PropagateUncertainty,safeOps]
	]

];

(*
	bfp - BestFitParameters, field from Fit object
		{ {pName, pMean, pStdDev}, ... }
*)
bfpP = {{_Symbol,_?NumericQ, _?NumericQ}...};
(* 
	no distribution and no covariance matrix, so everything is constant (mean values)
*)
fitAnalysisParameterDistribution[{pdist:Null,cm:Null,bfp:bfpP}]:=MapThread[#1->#2&,{bfp[[;;,1]],bfp[[;;,2]]}];
(* 
	if we have a covariance matrix but no full distribution, make a mutlinormal distribution
*)
fitAnalysisParameterDistribution[{pdist:Null,cm_,bfp:bfpP}]:=Distributed[bfp[[;;,1]],MultinormalDistribution[bfp[[;;,2]],symmetrize[cm]]];
(* 
	else we have a distribution, so use it
*)
(* for multinormal, make sure covariance is symmetric *)
fitAnalysisParameterDistribution[{pdist:MultinormalDistribution[means_,covs_],cm_,bfp:bfpP}]:=Distributed[bfp[[;;,1]],MultinormalDistribution[means,symmetrize[covs]]];
fitAnalysisParameterDistribution[{pdist_,cm_,bfp:bfpP}]:=Distributed[bfp[[;;,1]],pdist];
(* TODO: make covariance matrices be already SPD *)
symmetrize[mat_]:=0.5*(mat+Transpose[mat]);


(* ::Subsubsection::Closed:: *)
(*SinglePrediction*)


(*
	amir: 07.01.2020 note that Automatic does not behave well as the PropagateUncertainty for
 	TransformedDistribution is not written yet
*)


DefineOptions[SinglePrediction,
	Options :> {
		{Method -> Parametric, Parametric | Empirical | Automatic, "If Parametric, propagate uncertainty analytically to obtain parametric distribution.  If Empirical, sample expression repeatedly to obtain empirical distribution."},
		{NumberOfSamples -> Automatic, Automatic | _Integer?Positive, "Number of samples to use if using Empirical method."}
	}];


SinglePrediction[fitObj:ObjectReferenceP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=SinglePrediction[Download[fitObj],x,ops];
SinglePrediction[fitPacket:PacketP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=Module[
	{estv,meanPred,ymeandist,safeOps,yunit,errorDist,errorRule},
	safeOps = SafeOptions[SinglePrediction, ToList[ops]];
	ymeandist = MeanPrediction[fitPacket,x,ops];
	estv = packetLookup[fitPacket,EstimatedVariance];
	yunit=Last[packetLookup[fitPacket,DataUnits]];
	errorDist = If[NumericQ[estv],
		QuantityDistribution[NormalDistribution[0,Sqrt[estv]],yunit],
		NormalDistribution[0*yunit,Sqrt[estv]]
	];

	(* If there is no estimated variance data, then treat the error as a known value instead of a randomly distributed one. *)
	errorRule=If[MatchQ[estv,Null],
		B->0.0,
		B\[Distributed]errorDist
	];

	PropagateUncertainty[
		A+B,
		{A\[Distributed]ymeandist,errorRule},
		PassOptions[SinglePrediction,PropagateUncertainty,safeOps]
	]
];


(* ::Subsubsection::Closed:: *)
(*ForwardPrediction*)


DefineOptions[ForwardPrediction,
	Options :> {
		{Method -> Parametric, Parametric | Empirical | Automatic, "If Parametric, propagate uncertainty analytically to obtain parametric distribution.  If Empirical, sample expression repeatedly to obtain empirical distribution."},
		{NumberOfSamples -> Automatic, Automatic | _Integer?Positive, "Number of samples to use if using Empirical method."},
		{PredictionMethod -> Single, Single | Mean, "If Single, obtain the SinglePrediction which is the total error in predicting a 'y' value given an 'x' value which takes noise in the data into account. If Mean, obtain MeanPrediction which obtain error including the uncertainy in the fit parameters only. Single  is chosen automatically."}
	}];


ForwardPrediction[fitObj:ObjectReferenceP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=ForwardPrediction[Download[fitObj],x,ops];
ForwardPrediction[fitPacket:PacketP[Object[Analysis,Fit]],x:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=Module[
	{safeOps,predictOps},

	safeOps = SafeOptions[ForwardPrediction, ToList[ops]];

	(* only these two options should be passed to prediction functions *)
	predictOps = FilterRules[safeOps,{Method,NumberOfSamples}];

	Switch[Lookup[safeOps,PredictionMethod],
		Single,SinglePrediction[fitPacket,x,predictOps],
		Mean,MeanPrediction[fitPacket,x,predictOps]
	]
];


(* ::Subsubsection::Closed:: *)
(*InversePrediction*)


DefineOptions[InversePrediction,
	Options :> {
		{Method -> Empirical, Parametric | Empirical | Automatic, "If Parametric, propagate uncertainty analytically to obtain parametric distribution.  If Empirical, sample expression repeatedly to obtain empirical distribution."},
		{NumberOfSamples -> Automatic, Automatic | _Integer?Positive, "Number of samples to use if using Empirical method."},
		{PredictionMethod -> Single, Single | Mean, "If Single, obtain the SinglePrediction which is the total error in predicting a 'y' value given an 'x' value which takes noise in the data into account. If Mean, obtain MeanPrediction which obtain error including the uncertainy in the fit parameters only. Single  is chosen automatically."},
		{EstimatedValue -> Automatic, Automatic | _?NumericQ, "Starting value in FindRoot function."}
	}];


(*
	the method is not smart enough to give multiple answers or pick the one the makes more sense
*)

InversePrediction[fitObj:ObjectReferenceP[Object[Analysis,Fit]],y:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=InversePrediction[Download[fitObj],y,ops];
InversePrediction[fitPacket:PacketP[Object[Analysis,Fit]],y:(_?UnitsQ|_?DistributionParameterQ),ops:OptionsPattern[]]:=Module[
	{
		safeOps,method,noSamples,fExpr,pdist,xEmpiricalDist,xUnit,yUnit,yDist,yVal,xVar,yVar,ystDev,yNoise,
		findRoot
	},

	safeOps = SafeOptions[InversePrediction, ToList[ops]];

	(* resolving the method *)
	method=resolveInversePredictionMethod[Lookup[safeOps,Method]]; (* everything is empirical now *)

	(* resolving the number of samples *)
	noSamples=resolveInversePredictionNumberOfSamples[Lookup[safeOps,NumberOfSamples]];

	(* x and y units, it is set to 1 if there are no units *)
	{xUnit,yUnit}=packetLookup[fitPacket,DataUnits];

	(* y distribution after applyting Unitless *)
	yDist = Distributed[yVar,toDistribution[y,yUnit]];

	(* the mean value of the y distribution after applyting Unitless *)
	yVal=Mean[toDistribution[y,yUnit]];

	(* A helper function to find the branch of the piecewise expression based on the root given the yVal *)
	findRoot[fExpr:_Function,yVal_]:=
		Quiet[NSolve[fExpr[xVar] - yVal == 0, xVar, Reals]];

	(* Check to see if the expression is piecewise, then return with the root *)
	If[MatchQ[packetLookup[fitPacket,BestFitExpression],_Piecewise],
		Return[
			QuantityDistribution[
				EmpiricalDistribution[
					xVar /. findRoot[Function@@packetLookup[fitPacket,{BestFitVariables,BestFitExpression}],yVal]
				],xUnit
			]
		]
	];

	(* the function expression from the fit packet *)
	fExpr = Function@@packetLookup[fitPacket,{BestFitVariables,SymbolicExpression}];

	(* distribution of fit parameters *)
	pdist = fitAnalysisParameterDistribution[packetLookup[fitPacket,{BestFitParametersDistribution,CovarianceMatrix,BestFitParameters}]];

	(* depending on the selected PredictionMethod, yNoise can be included *)
	ystDev = If[MatchQ[First@packetLookup[fitPacket,{StandardDeviation}],Except[Null]],
		First@packetLookup[fitPacket,{StandardDeviation}],
		0.0 (* Set standard deviation to zero if it is missing from the fitpacket *)
	];

	yNoise = Switch[Lookup[safeOps,PredictionMethod],
		Mean,0,
		Single,ystDev
	];

	xEmpiricalDist =
		Switch[Lookup[safeOps,EstimatedValue],

			Automatic,
			EmpiricalDistribution[
  			DeleteCases[Table[
   				First[xVar /. NSolve[fitFunctionRandomVariables[fExpr[xVar], pdist, yDist, yNoise] == 0, xVar, Reals],Null],
   				noSamples
   			],Null]
			],
			(*
				In case there are multiple answers, FindRoot	might help to get the one requested by the user,
				otherwise, NSolve will give multiple answers and only the first one will be taken
			*)
			_?NumericQ,
			EmpiricalDistribution[
				DeleteCases[Table[
					First[xVar /. {FindRoot[fitFunctionRandomVariables[fExpr[xVar], pdist, yDist, yNoise], {xVar,OptionValue[EstimatedValue]}]},Null],
					noSamples
				],Null]
			]
  ];

	QuantityDistribution[xEmpiricalDist,xUnit]

];

(* if Automatic change to Empirical *)
resolveInversePredictionMethod[Automatic]:=Empirical;
(* else leave as is *)
resolveInversePredictionMethod[method_]:=Empirical;

(* resolving the number of samples used in the empirical approach *)
resolveInversePredictionNumberOfSamples[Automatic]:=1000;
resolveInversePredictionNumberOfSamples[n_Integer]:=n;

(* for mean prediction *)
fitFunctionRandomVariables[
  expr_,
  Distributed[pars_List, dist_],
  Distributed[yVar_, yDist_],
  0|0.] :=
		(expr - yVar) /. Join[Thread[Rule[pars, RandomVariate[dist]]], {Rule[yVar, RandomVariate[yDist]]}];

(* for single prediction *)
fitFunctionRandomVariables[
  expr_,
  Distributed[pars_List, dist_],
  Distributed[yVar_, yDist_],
  yNoise_?NumericQ] :=
		(expr - yVar) /. Join[Thread[Rule[pars, RandomVariate[dist]]], {Rule[yVar, RandomVariate[yDist]+RandomVariate[NormalDistribution[0,yNoise]]]}]

(* KH - overload for inverse prediction when the input packet is missing statistical data *)
fitFunctionRandomVariables[
  expr_,
  paramRules:{_Rule..},
  Distributed[yVar_, yDist_],
  0|0.] :=
		(expr - yVar) /. Join[paramRules, {Rule[yVar, RandomVariate[yDist]]}];



(* ::Subsection::Closed:: *)
(*Distribution Manipulation*)


(* ::Subsubsection::Closed:: *)
(*toDistribution*)


toDistribution[d_DataDistribution]:=EmpiricalDistribution[Unitless[EmpiricalDistributionPoints[d]]];
toDistribution[qd_QuantityDistribution]:=Unitless[qd];
toDistribution[d_?DistributionParameterQ]:=d;
toDistribution[d_?NumericQ]:=EmpiricalDistribution[{d}];
toDistribution[d_?UnitsQ]:=EmpiricalDistribution[{Unitless[d]}];

toDistribution[d_DataDistribution,unit_]:=EmpiricalDistribution[Unitless[EmpiricalDistributionPoints[d],unit]];
toDistribution[qd_QuantityDistribution,unit_]:=Unitless[qd,unit];
toDistribution[d_?DistributionParameterQ,unit_]:=d;
toDistribution[d_?NumericQ,unit_]:=EmpiricalDistribution[{d}];
toDistribution[d_?UnitsQ,unit_]:=EmpiricalDistribution[{Unitless[d,unit]}];




(* ::Subsection::Closed:: *)
(*Distribution Sampling*)


(* ::Subsubsection::Closed:: *)
(*bootstrapSet*)


DefineOptions[bootstrapSet,
	Options:>{
		{NumberOfSamples->500,_Integer,""}
	}
];


bootstrapSet[func_, arg_, ops:OptionsPattern[]] := Module[
	{shuffledArg,temp},
	Table[
			shuffledArg=arg[[ Table[Random[Integer, {1,Length[arg]}],{Length[arg]}] ]];
			func[shuffledArg],
			{OptionValue[NumberOfSamples]}
		]
 ];



(* ::Subsubsection::Closed:: *)
(*LatinHypercubeMatrix*)


LatinHypercubeMatrix[inputMatrix_List, samples_Integer] := Module[{segmentSize, numVars, out, pointValue, n, i, segmentMin, point},
	(*
		LatinHypercubeMatrix(x) returns a latin-hypercube matrix (each row is a
		different set of sample inputs) using a default sample size of 20 for
		each column of x. x must be a 2xN matrix that contains the lower and
		upper bounds of each column. The lower bound(s) should be in the first
		row and the upper bound(s) should be in the second row.

		Example:
		>>> x = {{0,-1,3},
			     {1,2,6};
		>>> LatinHypercubeMatrix[x]

		>>> {{ 0.02989122 -0.93918734  3.14432618}
             { 0.08869833 -0.82140706  3.19875152}
             { 0.10627442 -0.66999234  3.33814979}
             { 0.15202861 -0.44157763  3.57036894}
             { 0.2067089  -0.34845384  3.66930908}
             { 0.26542056 -0.23706445  3.76361414}
             { 0.34201421 -0.00779306  3.90818257}
             { 0.37891646  0.15458423  4.15031708}
             { 0.43501575  0.23561118  4.20320064}
             { 0.4865449   0.36350601  4.45792314}
             { 0.54804367  0.56069855  4.60911539}
             { 0.59400712  0.7468415   4.69923486}
             { 0.63708876  0.9159176   4.83611204}
             { 0.68819855  0.98596354  4.97659182}
             { 0.7368695   1.18923511  5.11135111}
             { 0.78885724  1.28369441  5.2900157 }
             { 0.80966513  1.47415703  5.4081971 }
             { 0.86196731  1.57844205  5.61067689}
             { 0.94784517  1.71823504  5.78021164}
             { 0.96739728  1.94169017  5.88604772}}
	*)

	segmentSize = 1/samples;

	(*Get the number of dimensions to sample (number of columns)*)
	numVars = Length[inputMatrix[[1]]];

	(*Populate each dimension*)
	out = ConstantArray[0, {samples, numVars}];
	pointValue = ConstantArray[0, samples];

	For[n = 1, n <= numVars, n++,
		For[i = 1, i <= samples, i++,
			segmentMin = (i-1) * segmentSize;
			point = segmentMin + (RandomReal[{0,1}] * segmentSize);
			pointValue[[i]] = (point * (inputMatrix[[2,n]] - inputMatrix[[1,n]])) + inputMatrix[[1,n]];
		];

		out[[All,n]] = pointValue;
	];

	MixMatrix[out, Column]
]


(* ::Subsubsection::Closed:: *)
(*MixMatrix*)


MixMatrix[inputMatrix_?MatrixQ, dimension_] := Module[{n,i,inputMatrix1},

	(* Make a local copy of the matrix so that we can edit it *)
	If[MatchQ[dimension, Row],  inputMatrix1 = Transpose[inputMatrix];, inputMatrix1 = inputMatrix;];

	For[i = 1, i <= Length[inputMatrix1[[1]]], i++,
		inputMatrix1[[All,i]] = RandomSample[inputMatrix1[[All,i]]];
	];

	If[dimension == Row, Return[Transpose[inputMatrix1]]];

	inputMatrix1
]


(* ::Subsubsection::Closed:: *)
(*LatinHypercubeSampleDesign*)


LatinHypercubeSampleDesign[inputLists_List, sampleSize_Integer] := Module[{n,i,inputMatrix1, numVars, latinHypercubeInput, uniformData, distributionData},

	(*LatinHypercubeSampleDesign takes in a list distribution objects.
	These distribution objects can be either parametric or emperical.

	Example: {{1,2,3,4,5},{2,3,4,1}}
			 {NormalDistribution[0,1], ChiSquareDistribution[5], StudentTDistribution[2]} *)

	numVars = Length[inputLists];
	latinHypercubeInput = {ConstantArray[0,numVars], ConstantArray[1,numVars]};
	uniformData = LatinHypercubeMatrix[latinHypercubeInput, sampleSize];
	distributionData = Quantile[inputLists[[#]], uniformData[[All,#]]]& /@ Range[numVars];
	Transpose[distributionData]
]


LatinHypercubeSampleDesign[inputLists_, inputListDimension_Integer, sampleSize_Integer] := Module[{n,i,inputMatrix1, numVars, latinHypercubeInput, uniformData, distributionData,fullQuantileAtGivenDimension,fullQuantile,numDistribution,currentDistribution,currentDistributionDimension,currentDistributionAtGivenDimension,numSample,variableIndex,currentDistributionFullQuantile},

	(*LatinHypercubeSampleDesign takes in a list distribution objects.
	These distribution objects can be either parametric or emperical.

	Example: {{1,2,3,4,5},{2,3,4,1}}
			 {NormalDistribution[0,1], ChiSquareDistribution[5], StudentTDistribution[2]} *)

	numVars = Length[inputLists];
	latinHypercubeInput = {ConstantArray[0,numVars], ConstantArray[1,numVars]};
	uniformData = LatinHypercubeMatrix[latinHypercubeInput, sampleSize];
	(*Once we have our uniform quantile numbers from 0-1, get our quantile answers using the specified dimension*)
	fullQuantileAtGivenDimension = Quantile[inputLists[[#]][[All,inputListDimension]], uniformData[[All,#]]]& /@ Range[numVars];

	fullQuantile = {}; (*List for all of the quantile information for all the distribution \[Rule] the whole coordinate, not only for the specified dimension*)
	For[numDistribution = 1, numDistribution <= numVars, numDistribution++,
		currentDistributionFullQuantile = {}; (*The full quantile information for the current distribution*)
		currentDistributionAtGivenDimension = inputLists[[numDistribution]][[All,inputListDimension]];

		For[numSample = 1, numSample <= sampleSize, numSample++, (*Loop through all of the samples drawn for this distribution*)
			variableIndex = RandomChoice[Flatten[Position[currentDistributionAtGivenDimension, fullQuantileAtGivenDimension[[numDistribution]][[numSample]]]]];
			currentDistributionFullQuantile = Append[currentDistributionFullQuantile, inputLists[[numDistribution]][[variableIndex]]];
		];
		fullQuantile = Append[fullQuantile,currentDistributionFullQuantile];
	];
	Transpose[fullQuantile]
]


(* ::Subsubsection::Closed:: *)
(*SobolMatrix*)


(* ::Input:: *)
(*(*TODO: Should it be [sampleSize, numVars] or [numVars,sampleSize]? Since it generates a sampleSize x numVars size matrix that seems more intuitive (but all the other methods are flipped right now*)*)

(*
	MKL no longer works on Apple Silicon in MM 13.2. There are no Sobol or other low-discrepency methods available.
	We use another simpler RNG, so this is no longer technically a Sobol Matrix
*)
SobolMatrix[sampleSize_Integer, numVars_Integer] := Module[{sobolData},
	BlockRandom[
		SeedRandom[Method -> "ExtendedCA"];
		sobolData = RandomReal[1, {sampleSize, numVars}];
		sobolData
	]
]


(* ::Subsubsection::Closed:: *)
(*SobolSampleDesign*)


SobolSampleDesign[inputLists_List, sampleSize_Integer] := Module[{n,i,inputMatrix1, numVars, sobolData, distributionData},

	(*SobolSampleDesign takes in a list distribution objects.
	These distribution objects can be either parametric or emperical.

	Example: {{1,2,3,4,5},{2,3,4,1}}
			 {NormalDistribution[0,1], ChiSquareDistribution[5], StudentTDistribution[2]} *)

	numVars = Length[inputLists];
    sobolData = SobolMatrix[sampleSize,numVars];
	distributionData = Quantile[inputLists[[#]], sobolData[[All,#]]]& /@ Range[numVars];
	Transpose[distributionData]
]


SobolSampleDesign[inputLists_, inputListDimension_Integer, sampleSize_Integer] := Module[{n,i,inputMatrix1, numVars, sobolData, distributionData, fullQuantileAtGivenDimension, fullQuantile, numDistribution, currentDistributionFullQuantile, currentDistributionAtGivenDimension, numSample, variableIndex},

	(*SobolSampleDesign takes in a list distribution objects.
	These distribution objects can be either parametric or emperical.

	Example: {{1,2,3,4,5},{2,3,4,1}}
			 {NormalDistribution[0,1], ChiSquareDistribution[5], StudentTDistribution[2]} *)

	numVars = Length[inputLists];
    sobolData = SobolMatrix[sampleSize,numVars];
	distributionData = Quantile[inputLists[[#]], sobolData[[All,#]]]& /@ Range[numVars];

	fullQuantileAtGivenDimension = Quantile[inputLists[[#]][[All,inputListDimension]], sobolData[[All,#]]]& /@ Range[numVars];

	fullQuantile = {}; (*List for all of the quantile information for all the distribution \[Rule] the whole coordinate, not only for the specified dimension*)
	For[numDistribution = 1, numDistribution <= numVars, numDistribution++,
		currentDistributionFullQuantile = {}; (*The full quantile information for the current distribution*)
		currentDistributionAtGivenDimension = inputLists[[numDistribution]][[All,inputListDimension]];

		For[numSample = 1, numSample <= sampleSize, numSample++, (*Loop through all of the samples drawn for this distribution*)
			variableIndex = RandomChoice[Flatten[Position[currentDistributionAtGivenDimension, fullQuantileAtGivenDimension[[numDistribution]][[numSample]]]]];
			currentDistributionFullQuantile = Append[currentDistributionFullQuantile, inputLists[[numDistribution]][[variableIndex]]];
		];
		fullQuantile = Append[fullQuantile,currentDistributionFullQuantile];
	];
	Transpose[fullQuantile]
]


(* ::Subsubsection::Closed:: *)
(*allSampleCombinations*)


allSampleCombinations[dists:{(_DataDistribution|_SampleDistribution|QuantityDistribution[_DataDistribution|_SampleDistribution,_])..}]:=Module[{ptSets},
	ptSets = Map[EmpiricalDistributionPoints[#]&,dists];
	Distribute[Normal[ptSets],List]
];
allSampleCombinations[___]:=Message[];


(* ::Subsubsection::Closed:: *)
(*SampleFromDistribution*)


DefineOptions[SampleFromDistribution,
	Options :> {
		{SamplingMethod -> Sobol, LatinHypercube | Sobol | Random | All, "Method to be used in sampling."}
	}];


SampleFromDistribution[dist_?DistributionParameterQ,n_Integer,ops:OptionsPattern[]]:=
	First[SampleFromDistribution[{dist},n,ops]]

(* return empty list if given no distributions *)
SampleFromDistribution[dists:{},n_Integer?Positive,ops:OptionsPattern[]]:={};

SampleFromDistribution[dists:{__},n_Integer?Positive,ops:OptionsPattern[]]:=Module[{safeOps},
	safeOps = SafeOptions[SampleFromDistribution, ToList[ops]];
	Switch[Lookup[safeOps,SamplingMethod],
		Random, Map[RandomVariate[#,n]&,dists],
		LatinHypercube, Transpose@LatinHypercubeSampleDesign[dists,n],
		Sobol, Transpose@SobolSampleDesign[dists,n],
		All, Transpose@allSampleCombinations[dists]
	]
]


(* ::Subsection::Closed:: *)
(*Distribution Plotting*)


(* ::Subsubsection::Closed:: *)
(*MultivariateDistributionQ*)


MultivariateDistributionQ[_MultinormalDistribution]:=True;
MultivariateDistributionQ[_CopulaDistribution]:=True;
MultivariateDistributionQ[_ProductDistribution]:=True;
MultivariateDistributionQ[_MarginalDistribution]:=True;
MultivariateDistributionQ[DataDistribution["Empirical",_,Except[1,_Integer],___]]:=True;
MultivariateDistributionQ[QuantityDistribution[_?MultivariateDistributionQ,_]]:=True;
MultivariateDistributionQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(*UnivariateDistributionQ*)


UnivariateDistributionQ[_?MultivariateDistributionQ]:=False;
UnivariateDistributionQ[_]:=True;


(* ::Subsection::Closed:: *)
(*Distribution Blobs*)


(* ::Subsubsection:: *)
(*Patterns*)


continuousDistributionP=Alternatives[
	HalfNormalDistribution,ChiSquareDistribution,InverseChiSquareDistribution,
	StudentTDistribution,ChiDistribution,RayleighDistribution,MaxwellDistribution,
	ChiDistribution,ExponentialDistribution,LogNormalDistribution,
	InverseGaussianDistribution,FRatioDistribution,NoncentralStudentTDistribution,
	NoncentralChiSquareDistribution,WeibullDistribution,ParetoDistribution,
	LogisticDistribution,LevyDistribution,LaplaceDistribution,InverseGammaDistribution,
	GumbelDistribution,GammaDistribution,ExtremeValueDistribution,CauchyDistribution,
	BetaDistribution,NormalDistribution,UniformDistribution
];
discreteDistributionP=Alternatives[
	BernoulliDistribution,GeometricDistribution,LogSeriesDistribution,PoissonDistribution,
	ZipfDistribution,BinomialDistribution,NegativeBinomialDistribution,
	BetaBinomialDistribution,BetaNegativeBinomialDistribution,HypergeometricDistribution,
	DiscreteUniformDistribution
];
derivedDistributionP=Alternatives[
	TransformedDistribution,SplicedDistribution,OrderDistribution,TruncatedDistribution,
	MixtureDistribution,ParameterMixtureDistribution,CompoundPoissonDistribution,
	CensoredDistribution,CopulaDistribution,ProductDistribution,MarginalDistribution,
	ReliabilityDistribution,FailureDistribution,StandbyDistribution,SliceDistribution,
	StationaryDistribution,GraphPropertyDistribution,BernoulliGraphDistribution,
	BarabasiAlbertGraphDistribution,BinormalDistribution,MultinormalDistribution,
	MultivariateTDistribution,DirichletDistribution,MultinomialDistribution,
	MultivariateHypergeometricDistribution,NegativeMultinomialDistribution,
	MultivariatePoissonDistribution
];
distributionP=Flatten[Alternatives[
	continuousDistributionP,
	discreteDistributionP,
	derivedDistributionP,
	QuantityDistribution,
	DataDistribution,
	SampleDistribution
]];


(* ::Subsubsection:: *)
(*Tooltip Styling*)


distributionBackgroundGray=GrayLevel[0.92];
distributionForegroundGray=GrayLevel[0.35];

styleDistributionDisplay[in_]:=With[
	{val=Style[in,distributionForegroundGray]},
	Mouseover[
		Framed[val,Background->White,FrameStyle->White,RoundingRadius->5,FrameMargins->2],
		Framed[val,Background->distributionBackgroundGray,FrameStyle->distributionBackgroundGray,RoundingRadius->5,FrameMargins->2],
		ImageSize->All
	]
];


(* ::Subsubsection:: *)
(*Make Distribution Box*)


makeDistributionBox[dist_?DistributionParameterQ]:=With[
	{
		m=TimeConstrained[Mean[dist],1+$DistributionBlobTiming,Null],
		s=TimeConstrained[
			If[MultivariateDistributionQ[dist],
				Covariance[dist],
				StandardDeviation[dist]
			],
			1+$DistributionBlobTiming,
			Null
		]
	},
	TimeConstrained[
		makeDistributionBox[dist,m,s],
		3+$DistributionBlobTiming,
		Block[{$DistributionBlobs=False},ToBoxes[dist]]
	]
];

makeDistributionBox[dist_]:=Block[{$DistributionBlobs=False},ToBoxes[dist]]


mInvalidP=Alternatives[Null,Mean[___],Quantity[Mean[___],___]];
sInvalidP=Alternatives[Null,(StandardDeviation|Covariance)[___],Quantity[(StandardDeviation|Covariance)[___],___]];
makeDistributionBox[dist_,m:mInvalidP,s_]:=Block[{$DistributionBlobs=False},ToBoxes[dist]];
makeDistributionBox[dist_,m_,s:sInvalidP]:=Block[{$DistributionBlobs=False},ToBoxes[dist]];

makeDistributionBox[dist_,m_,s_]:=With[
	{
		plusMinus = styleDistributionDisplay[PlusMinus[m,formatStdDevPiece[s]]],
		tooltipSummary = Row[
			{
				distributionBlobSummary[dist,m,s],
				TimeConstrained[
					Quiet[Check[Catch[distributionBlobPicture[dist,m,s],_SystemException],Null]],
					2.5+$DistributionBlobTiming,
					Null
				],
				Null
			},
			" "
		]
	},
	With[
		{boxes = ToBoxes[Tooltip[plusMinus,tooltipSummary]]},
		InterpretationBox[boxes,dist,SelectWithContents->True,Selectable->True]
	]
];


formatStdDevPiece[cv_List]:=Defer[Sqrt[cv]];
formatStdDevPiece[s_]:=s;


(* QD case, strip off wrapper *)
distributionBlobSummary[QuantityDistribution[dist_,unit_],m_,s_]:=distributionBlobSummary[dist,m,s];
(* multivariate case, use Covariance *)
distributionBlobSummary[dist_DataDistribution,m_List,cv_List]:=Column[{Head[dist],Row[{"Mean: ",m}],Row[{"Covariance: ",cv}],Row[{"Number of Points: ",dist["SampleSize"]}]},Spacings->1];
distributionBlobSummary[dist_,m_List,cv_List]:=Column[{Head[dist],Row[{"Mean: ",m}],Row[{"Covariance: ",cv}]},Spacings->1];
(* univariate case, use StandardDeviation *)
distributionBlobSummary[dist_DataDistribution,m_,s_]:=Column[{Head[dist],Row[{"Mean: ",m}],Row[{"StandardDeviation: ",s}],Row[{"Number of Points: ",dist["SampleSize"]}]},Spacings->1];
distributionBlobSummary[dist_SampleDistribution,m_,s_]:=Column[{Head[dist],Row[{"Mean: ",m}],Row[{"StandardDeviation: ",s}],Row[{"Number of Points: ",dist["SampleSize"]}]},Spacings->1];
distributionBlobSummary[dist_,m_,s_]:=Column[{Head[dist],Row[{"Mean: ",m}],Row[{"StandardDeviation: ",s}]},Spacings->1];


(* QD case, strip off wrapper *)
distributionBlobPicture[QuantityDistribution[dist_,unit_],m_,s_]:=distributionBlobPicture[dist,m,s];
distributionBlobPicture[dist_DataDistribution?MultivariateDistributionQ,m_,s_]:=Null
distributionBlobPicture[dist_,m_,s_]:=With[
	{
		pdf=safePDF[dist],
		msSafe = safeMeanStandardDeviation[dist,m,s]
	},
	If[MatchQ[dist,discreteDistributionP[___]],
		safeDiscretePlotPDF[pdf,First[msSafe],Last[msSafe]],
		safePlotPDF[pdf,First[msSafe],Last[msSafe]]
	]
];


safeMeanStandardDeviation[dist_,m_?NumericQ,s_?NumericQ]:={m,s};
safeMeanStandardDeviation[dist_,m_Quantity,s_Quantity]:={m,s} /; And[NumericQ[QuantityMagnitude[m]],NumericQ[QuantityMagnitude[s]]];
safeMeanStandardDeviation[dist_,m_,s_List]:={m,s};
(* otherwise, try sampling and estimate stats from samples *)
safeMeanStandardDeviation[dist_,m_,s_]:=With[
	{samps=RandomVariate[dist,100]},
	{Mean[samps],StandardDeviation[samps]}
];


(* ::Subsubsection::Closed:: *)
(*PDF Plots*)


(*
	compute the PDF for the plot
	TimeConstrain this because some transformed dists can take a long time
*)
safePDF[dist_MultinormalDistribution]:=Function[{x,y},Evaluate[PDF[dist,{x,y}]]];
safePDF[dist_DataDistribution]:=WeightedData[dist["Domain"],dist["Weights"]];
safePDF[dist_SampleDistribution]:=WeightedData[dist["DataPoints"]];
safePDF[dist_]:=PDF[dist];

(*
	make the plot
	TimeConstrain this because some dists can take a long time
*)
(* default distribution blob plot size *)
ddbps = 200;
safePlotPDF[pdf:$Failed,m_,s_]:=Null
(* univariate cases *)
safePlotPDF[pts_WeightedData,m_?NumericQ,s_?NumericQ]:=Histogram[pts,LabelStyle->{},Frame->False,Axes->True,ImageSize->ddbps];
safePlotPDF[pts_WeightedData,m_Quantity,s_Quantity]:=Histogram[pts,LabelStyle->{},Frame->False,Axes->True,AxesLabel->Automatic,TargetUnits->{QuantityUnit[m],None},ImageSize->ddbps];
safePlotPDF[pdf_,m_?NumericQ,s_?NumericQ]:=With[{min=m-3*s,max=m+3*s},
	ListLinePlot[Table[{x,pdf[x]},{x,min,max,(max-min)/101}],LabelStyle->{},Frame->False,Axes->True,ImageSize->ddbps]];
safePlotPDF[pdf_,m_Quantity,s_Quantity]:=With[{min=QuantityMagnitude[m-3*s],max=QuantityMagnitude[m+3*s]},
	ListLinePlot[Table[{x,pdf[x]},{x,min,max,(max-min)/101}],LabelStyle->{},Frame->False,Axes->True,AxesLabel->Automatic,TargetUnits->{QuantityUnit[m],1/QuantityUnit[m]},ImageSize->ddbps]];
(* multivariate cases *)
(* 2d case, can make 3d plot *)
safePlotPDF[pdf_,{m1_?NumericQ,m2_?NumericQ},cv:{{c11_,_},{_,c22_}}]:=Plot3D[pdf[x,y],{x,m1-3*Sqrt[c11],m1+3*Sqrt[c11]},{y,m2-3*Sqrt[c22],m2+3*Sqrt[c22]},LabelStyle->{},ImageSize->ddbps];
(* higher-d cases, no plot *)
safePlotPDF[pdf_,m:{_?NumericQ..},cv_List]:=Null;
(* anything else, no plot *)
safePlotPDF[pdf_,m_,s_]:=Null

safeDiscretePlotPDF[pdf:$Failed,m_,s_]:=Null
safeDiscretePlotPDF[pdf_,m_Quantity,s_Quantity]:=With[
	{min=QuantityMagnitude@Floor[m-3*s],max=QuantityMagnitude@Ceiling[m+3*s],unit=QuantityUnit[m]},
	DiscretePlot[pdf[x],{x,min,max},LabelStyle->{},Frame->False,Axes->True,ImageSize->ddbps]
];
safeDiscretePlotPDF[pdf_,m_?NumericQ,s_?NumericQ]:=With[
	{min=Min[{Floor[m-3*s],m-6}],max=Max[{Ceiling[m+3*s],m+6}]},
	DiscretePlot[pdf[x],{x,min,max},LabelStyle->{},Frame->False,Axes->True,ImageSize->ddbps]
];
safeDiscretePlotPDF[pdf_,m_,s_]:=Null;


(* ::Subsubsection::Closed:: *)
(*MakeBox Definitions*)


addDistributionBlob[distP_]:=Module[{},
	(* unprotect so we can write to FormatValues directly *)
	Unprotect[distP];

	FormatValues[distP]=Prepend[
		FormatValues[distP],
		HoldPattern[MakeBoxes[dist:distP[___], StandardForm]] :> makeDistributionBox[dist] /; TrueQ[$DistributionBlobs]
	];

	Protect[distP];
]


Authors[DistributionBlobs]={"brad","thomas","alice","qian"};

installDistributionBlobs[]:=Module[{},

	$DistributionBlobTiming=0;
	$DistributionBlobs=False;

	(* unprotect so we can write to its FormatValues directly *)
	Unprotect[QuantityDistribution];
	(*
		QuantityDistribution already has FormatValues which supercede any new MakeBoxes definitions, so to add new ones without clearing the old ones
		we will explicitly create the list of new definitions and join them with the old ones at the end
	*)
	FormatValues[QuantityDistribution]=Join[
		{
			(* special multivariate *)
			HoldPattern[MakeBoxes[qd:QuantityDistribution[dist:MultinormalDistribution[m_,cv_],unit_], StandardForm]] :>
				makeDistributionBox[qd,MapThread[Quantity,{m,unit}],MapThread[Quantity,{cv,Outer[Times,unit,unit]},2]]/;TrueQ[$DistributionBlobs],
			(* anything else.  need this to be _QuantityDistribution instead of more specific pattern because otherwise MM freaks the F out *)
			HoldPattern[MakeBoxes[qd:_QuantityDistribution, StandardForm]] :>
				makeDistributionBox[qd] /; TrueQ[$DistributionBlobs]
		},
		FormatValues[QuantityDistribution]
	];
	Protect[QuantityDistribution];

	addDistributionBlob/@(List@@derivedDistributionP);
	addDistributionBlob[DataDistribution];
	addDistributionBlob[SampleDistribution];

	With[
		{distP=continuousDistributionP|discreteDistributionP},
		MakeBoxes[dist:distP[___],StandardForm]:=makeDistributionBox[dist]/;TrueQ[$DistributionBlobs];
	];

	$DistributionBlobs=True;

];

OnLoad[
	(* need to do this first to trigger initialization of all QD and DataDistribution definitions and formats *)
	EmpiricalDistribution[{1,2,3}];
	QuantityDistribution[NormalDistribution[3,2],"Meters"];
	TransformedDistribution[u^2,u\[Distributed]BetaDistribution[4,3]];

	installDistributionBlobs[];
];


(* ::Subsection::Closed:: *)
(*Distribution Algebra*)


(* ::Subsubsection::Closed:: *)
(*Mathematical Functions*)


mathematicalFunctionList={
	Plus,Times,Power,Sqrt,Exp,Log,Sin,Cos,Tan,ArcSin,ArcCos,ArcTan,Factorial,Abs,Max,Min,Mean,Floor,Ceiling,Total
};


(* ::Subsubsection::Closed:: *)
(*Add Distribution Overload*)


$DistributionMath=True;
addDistributionOverload[f_,dist_]:=Module[{},
	Unprotect[dist];

	dist/:f[a___,b_dist]:=Block[{
		QuantityUnits`$AutomaticUnitTimes = True,
		QuantityUnits`$AutomaticUnitPlus = True
	},
		Module[{args,inputError},
		args={a,b};

		(* re-evaluate f[a,b] to catch errors in original input *)
		inputError=Block[{$DistributionMath=False},
			Quiet[Check[Activate[Inactivate[f[a,b]]],$Failed]]
		];

		Block[{$DistributionMath=False},If[SameQ[inputError,$Failed],
			f@@args,
			PropagateUncertainty[f[a,b]]
		]]
	]]/;TrueQ[$DistributionMath];

	dist/:f[b_dist,c___]:=Module[{args,inputError},
		args={b,c};

		(* re-evaluate f[b,c] to catch errors in original input *)
		inputError=Block[{$DistributionMath=False},
			Quiet[Check[Activate[Inactivate[f[b,c]]],$Failed]]
		];

		Block[{$DistributionMath=False},If[SameQ[inputError,$Failed],
			f@@args,
			PropagateUncertainty[f[b,c]]
		]]
	]/;TrueQ[$DistributionMath];

	Protect[dist];
]


OnLoad[
	Outer[addDistributionOverload,mathematicalFunctionList,List@@distributionP];
];



uncertaintyPacketQ[packet_] := MatchQ[
	Lookup[packet,{Mean,StandardDeviation,Distribution,Method,NumberOfSamples}],
	{_?NumericQ|_?QuantityQ,_?NumericQ|_?QuantityQ,_?DistributionParameterQ,Parametric|Empirical|TransformedDistribution,_Integer?Positive|Null}
];
