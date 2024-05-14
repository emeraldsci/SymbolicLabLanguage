(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*CoefficientOfVariation*)


DefineUsage[CoefficientOfVariation,
{
	BasicDefinitions -> {
		{"CoefficientOfVariation[mu,sigma]", "cv", "computes the coefficient of variation for the given mean and standard deviation."},
		{"CoefficientOfVariation[dist]", "cv", "uses the mean and standard deviation of the given distribution."},
		{"CoefficientOfVariation[mu\[PlusMinus]sigma]", "cv", "also accepts PlusMinus format."}
	},
	Input :> {
		{"mu", UnitsP[], "The mean of distribution or collection of values."},
		{"sigma", UnitsP[], "The standard deviation of distribution or collection of values."},
		{"dist", _?DistributionParameterQ, "A valid distribution."}
	},
	Output :> {
		{"cv", _?NumericQ, "Coefficient of variation, computed from the mean and standard deviation."}
	},
	SeeAlso -> {
		"ConfidenceInterval",
		"PropagateUncertainty",
		"Mean",
		"StandardDeviation"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian"}
}];


(* ::Subsubsection::Closed:: *)
(*ConfidenceInterval*)


DefineUsage[ConfidenceInterval,
{
	BasicDefinitions -> {
		{"ConfidenceInterval[dist]", "interval", "computes the 95% confidence interval for given distribution."},
		{"ConfidenceInterval[dist,confidenceLevel]", "interval", "computes confidence interval for specified confidence level for given distribution."}
	},
	Input :> {
		{"dist", _?DistributionParameterQ, "A distribution."}
	},
	Output :> {
		{"interval", {UnitsP[], UnitsP[]}, "Lower and upper bound of the computed confidence interval."}
	},
	SeeAlso -> {
		"CoefficientOfVariation",
		"PropagateUncertainty",
		"Mean",
		"StandardDeviation"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian"}
}];


(* ::Subsubsection::Closed:: *)
(*MeanPrediction*)


DefineUsage[MeanPrediction,
{
	BasicDefinitions -> {
		{"MeanPrediction[fitObject,x]", "yDistribution", "computes the mean predicted value distribution obtained by propagating the input 'x' through the function in 'fitObject'."}
	},
	MoreInformation -> {

	},
	Input :> {
		{"fitObject", ObjectP[Object[Analysis,Fit]], "A fit object containing a function and fit error information."},
		{"x", _?UnitsQ | _?DistributionParameterQ, "A value or distribution to propagate through the function in 'fitObject'."}
	},
	Output :> {
		{"yDistribution", _?DistributionParameterQ, "Distribution describing the predicted mean value of f at x."}
	},
	SeeAlso -> {
		"PropagateUncertainty",
		"AnalyzeFit",
		"SinglePrediction",
		"PlotPrediction"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian"}
}];


(* ::Subsubsection::Closed:: *)
(*PropagateUncertainty*)


DefineUsage[PropagateUncertainty,
{
	BasicDefinitions -> {
		{"PropagateUncertainty[expr,pars]", "stats", "computes the uncertainty in the evaluation of 'expr' using the parameter values and distributions specified in 'pars'."}
	},
	MoreInformation -> {
		"In SLL, measurements with uncertainty are represented using Distributions, which may have physical units.",
		StringJoin[
			"PropagateUncertainty is the low-level SLL function used to compute the uncertainty of expressions dependent on uncertain values. ",
			"This function is invoked automatically when performing arithmetic operations on distributions, ",
			"and can be explicitly called with options to compute confidence intervals and/or use non-standard error propagation methods, such as empirical sampling."
		],
		StringJoin[
			"Textbook error propagation formulae (e.g. Object[Report,Literature,\"id:eGakldJBRRxE\"]) are typically first-order approximations derived by assuming ",
			"uncertain values are Gaussian-distributed, and that the uncertainty of each measurement is much smaller than the measurement itself. ",
			"PropagateUncertainty is a generalization of error propagation to arbitrary distributions, and computes uncertainty without relying on these assumptions."
		],
		StringJoin[
			"When possible, uncertainty is propagated analytically using the parametric forms of distributions, resulting in either a parametric or transformed distribution. ",
			"For example, the sum of two independent Gaussian-distributed uncertain measurements A \[Distributed] 1.0 \[PlusMinus] 1.0 and B \[Distributed] 2.0 \[PlusMinus] 1.0 ",
			"is a Gaussian distribution 3.0 \[PlusMinus] \[Sqrt] 2."
		],
		StringJoin[
			"If uncertainty cannot be propagated analytically, ",
			"the input expression will be repeatedly sampled to generate an approximate EmpiricalDistribution representing the uncertainty of the final expression. ",
			"The NumberOfSamples and SamplingMethod may be changed by setting the corresponding options of PropagateUncertainty - otherwise, these parameters will be automatically set to optimize precision within reasonable compute bounds."
		],
		"Fixed parameters should be specified using Rule, and represent values with no uncertainty. Uncertain parameters should be specified as distributions using Distributed."
	},
	Input :> {
		{"expr", _, "An expression to evaluate.  Contains symbolic parameters whose values or distributions are specified in 'pars'."},
		{"pars", ListableP[_Rule | _Distributed], "Values and distributions to substitute in for the symbols in 'expr'."}
	},
	Output :> {
		{"stats", {_Rule..}, "List of rules describing the Mean, StandardDeviation, optional Confidence Interval, and Distribution of 'expr' when evaluated using 'pars'."}
	},
	SeeAlso -> {
		"Mean",
		"StandardDeviation",
		"EmpiricalDistribution",
		"TransformedDistribution",
		"Distributed"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian", "kevin.hou"}
}];



(* ::Subsubsection::Closed:: *)
(*RSquared*)


DefineUsage[RSquared,
{
	BasicDefinitions -> {
		{"RSquared[measurements, modeled]", "out", "compute R-Squared value between measured values 'measurements' and modeled values 'modeled'."},
		{"RSquared[xy,f]", "out", "compute R-Squared value between measured values y and modeled values f[x]."}
	},
	Input :> {
		{"measurements", {_?NumericQ..}, "List of measured values."},
		{"modeled", {_?NumericQ..}, "List of modeled values."},
		{"xy", {{_?NumericQ,_?NumericQ}..}, "List of measurement data pairs {x,y}."},
		{"f", _Function, "Model function that predicts y from x."}
	},
	Output :> {
		{"out", _?NumericQ, "R-Squared value for the given measurement data and model."}
	},
	SeeAlso -> {
		"SumSquaredError",
		"StandardError",
		"StandardDeviation"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian"}
}];


(* ::Subsubsection::Closed:: *)
(*SampleFromDistribution*)


DefineUsage[SampleFromDistribution,
{
	BasicDefinitions -> {
		{"SampleFromDistribution[distribution,n]", "randomSample", "draws 'n' samples from 'distribution' using the method specified in SamplingMethod option."}
	},
	MoreInformation -> {
		""
	},
	Input :> {
		{"n", _Integer?Positive, "Number of samples to take from the distributions."},
		{"distribution", _?DistributionParameterQ, "A distribution to be sampled from."}
	},
	Output :> {
		{"randomSample", {_?NumericQ..}, "List of samples from 'distribution' of length 'n'."}
	},
	SeeAlso -> {
		"RandomVariate",
		"PropagateUncertainty",
		"TransformedDistribution"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian"}
}];


(* ::Subsubsection::Closed:: *)
(*SinglePrediction*)


DefineUsage[SinglePrediction,
{
	BasicDefinitions -> {
		{"SinglePrediction[fitObject,x]", "yDistribution", "computes the single predicted value distribution obtained by propagating the input 'x' through the function in 'fitObject'."}
	},
	Input :> {
		{"fitObject", ObjectP[Object[Analysis,Fit]], "A fit object containing a function and fit error information."},
		{"x", _?UnitsQ | _?DistributionParameterQ, "A value or distribution to propagate through the function in 'fitObject'."}
	},
	Output :> {
		{"yDistribution", _?DistributionParameterQ, "Distribution describing the predicted single value of f at x."}
	},
	SeeAlso -> {
		"PropagateUncertainty",
		"AnalyzeFit",
		"MeanPrediction",
		"PlotPrediction"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian"}
}];


(* ::Subsubsection::Closed:: *)
(*ForwardPrediction*)


DefineUsage[ForwardPrediction,
{
	BasicDefinitions -> {
		{"ForwardPrediction[fitObject,x]", "yDistribution", "computes the single or mean predicted value distribution obtained by propagating the input 'x' through the function in 'fitObject'."}
	},
	Input :> {
		{"fitObject", ObjectP[Object[Analysis,Fit]], "A fit object containing a function and fit error information."},
		{"x", _?UnitsQ | _?DistributionParameterQ, "A value or distribution to propagate through the function in 'fitObject'."}
	},
	Output :> {
		{"yDistribution", _?DistributionParameterQ, "Distribution describing the predicted single value of f at x."}
	},
	SeeAlso -> {
		"PropagateUncertainty",
		"AnalyzeFit",
		"SinglePrediction",
		"MeanPrediction",
		"PlotPrediction"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];


(* ::Subsubsection::Closed:: *)
(*InversePrediction*)


DefineUsage[InversePrediction,
{
	BasicDefinitions -> {
		{"InversePrediction[fitObject,y]", "xDistribution", "computes the single or mean predicted value distribution obtained by propagating the input 'y' through the inverse function in 'fitObject'."}
	},
	Input :> {
		{"fitObject", ObjectP[Object[Analysis,Fit]], "A fit object containing a function and fit error information."},
		{"y", _?UnitsQ | _?DistributionParameterQ, "A value or distribution to propagate through the function in 'fitObject'."}
	},
	Output :> {
		{"xDistribution", _?DistributionParameterQ, "Distribution describing the predicted single value of f inverse at y."}
	},
	SeeAlso -> {
		"PropagateUncertainty",
		"AnalyzeFit",
		"ForwardPrediction",
		"SinglePrediction",
		"MeanPrediction",
		"PlotPrediction"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];


(* ::Subsubsection::Closed:: *)
(*SumSquaredError*)


DefineUsage[SumSquaredError,
{
	BasicDefinitions -> {
		{"SumSquaredError[listA, listB]", "error", "compute sum of squares of differences between two lists of data points."},
		{"SumSquaredError[xy, f]", "error", "given xy points, compute the sum of squared differences between y and f[x]."},
		{"SumSquaredError[xy,expression,params,variable]", "error", "takes a set of {x,y}, and a proposed fit and calculated the sum squared error of each datapoint fitted to the expression using the parameters."}
	},
	Input :> {
		{"listA", {_?NumericQ..}, "List of values."},
		{"listB", {_?NumericQ..}, "List of values."},
		{"xy", {{_?NumericQ,_?NumericQ}..}, "The list of {x,y} datapoints you apply the sum squared error function to."},
		{"f", _Function, "A function to apply to x points."},
		{"expression", _, "A Mathematica expression that represents the fit function."},
		{"params", {Rule[_,_?NumericQ]..}, "List of paramaters int numeric form that are found in the expression."},
		{"variable", _, "The independent varible in the provoided expression."}
	},
	Output :> {
		{"error", _?NumericQ, "The sum squared error of the expression applied to the data using the provided paramaters."}
	},
	SeeAlso -> {
		"RSquared",
		"StandardError",
		"StandardDeviation"
	},
	Author -> {"scicomp", "brad", "thomas", "alice", "qian"}
}];


(* ::Subsubsection::Closed:: *)
(*SampleDistribution*)


DefineUsage[SampleDistribution,
	{
		BasicDefinitions -> {
			{"SampleDistribution[values]", "sampleDistribution", "creates a SampleDistribution type of distribution."}
		},
		MoreInformation -> {
			"SampleDistribution represents a sample, and its StandardDeviation is the sample standard deviation, unlike EmpiricalDistribution which represents a distribution and whose StandardDeviation is population standard deviation."
		},
		Input :> {
			{"values", {_?UnitsQ...} | _?QuantityVectorQ, "The sample values."}
		},
		Output :> {
			{"sampleDistribution", _SampleDistribution, "A distribution representing a sample."}
		},
		SeeAlso -> {
			"EmpiricalDistribution",
			"DataDistribution",
			"StandardDeviation"
		},
		Author -> {"scicomp", "brad", "srikant"}
	}];