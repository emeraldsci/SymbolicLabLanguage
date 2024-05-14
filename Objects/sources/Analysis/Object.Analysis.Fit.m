(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, Fit], {
	Description->"Curve fitting analysis of connected {x,y} datapoints.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		DataPoints -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> MatrixP[NumericP] | MatrixP[UnitsP[]] | MatrixP[NumericP | _?DistributionParameterQ] | _?QuantityMatrixQ,
			Units -> {None, None},
			Description -> "List of {x,y} datapoints in the set (including outliers and excluded points).",
			Category -> "General"
		},
		DataUnits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UnitsP[],
			Description -> "Units associated with the DataPoints used for fitting.",
			Category -> "General"
		},
		Response -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_?NumericQ...}|_?QuantityVectorQ,
			Units -> None,
			Description -> "The actual y-values from the data points that were used in fitting analysis.",
			Category -> "General"
		},
		Exclude -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> MatrixP[NumericP] | {},
			Units -> {None, None},
			Description -> "List of {x,y} datapoints excluded from the fit.",
			Category -> "General"
		},
		MinDomain -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "The minimum of the domain of values considered when calculating the fit.  Any data points whose x-value is less than MinDomain is excluded from fitting.",
			Category -> "General"
		},
		MaxDomain -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "The maximum of the domain of values considered when calculating the fit.  Any data point whose x-value is greater than MaxDomain is excluded from fitting.",
			Category -> "General"
		},
		Outliers -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> MatrixP[NumericP] | {},
			Units -> {None, None},
			Description -> "List of {x,y} datapoints identified as outliers.",
			Category -> "General"
		},
		SymbolicExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Except[_String],
			Description -> "The symbolic expression representing the type of function used in this fit, with best fit parameters still represented as symbolic variables.",
			Category -> "General"
		},
		ExpressionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FitExpressionP,
			Description -> "The type of expression or function used to fit the provided data.",
			Category -> "General"
		},
		DependentVariableData -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression},
			Pattern :> {_Link, FieldP[Output->Short], _Function|Identity},
			Relation -> {Object[Data] | Object[Analysis] | Object[Sample]| Model[Sample, StockSolution, Standard], Null, Null},
			Description -> "The objects and respective fields containing the values that were transformed to create the dependent variable data.",
			Category -> "General",
			Headers ->{"Object","Field","Transformation"}
		},
		IndependentVariableData -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression},
			Pattern :> {_Link, FieldP[Output->Short], _Function|Identity},
			Relation -> {Object[Data] | Object[Analysis] | Object[Sample]| Model[Sample, StockSolution, Standard], Null, Null},
			Description -> "The objects and respective fields containing the values that were transformed to create the first dimension of independent variable data.",
			Category -> "General",
			Headers ->{"Object","Field","Transformation"}
		},
		SecondaryIndependentVariableData -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression},
			Pattern :> {_Link, FieldP[Output->Short], _Function|Identity},
			Relation -> {Object[Data] | Object[Analysis] | Object[Sample] | Model[Sample, StockSolution, Standard], Null, Null},
			Description -> "The objects and respective fields containing the values that were transformed to create the second dimension of independent variable data.",
			Category -> "General",
			Headers ->{"Object","Field","Transformation"}
		},
		TertiaryIndependentVariableData -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression},
			Pattern :> {_Link, FieldP[Output->Short], _Function|Identity},
			Relation -> {Object[Data] | Object[Analysis] | Object[Sample]| Model[Sample, StockSolution, Standard], Null, Null},
			Description -> "The objects and respective fields containing the values that were transformed to create the third dimension of independent variable data.",
			Category -> "General",
			Headers ->{"Object","Field","Transformation"}
		},
		BestFitFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "Fit function that calculates the expected Y as a function of X, stored as a pure function.",
			Category -> "Analysis & Reports"
		},
		BestFitExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Except[_String],
			Description -> "The symbolic expression with the best fit parameters replaced by their fitted values.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		BestFitParameters -> {
			Format -> Multiple,
			Class -> {Expression, Real, Real},
			Pattern :> {_Symbol, NumericP, NumericP?NonNegative},
			Units -> {None, None, None},
			Description -> "The unknown parameters from the SymbolicExpression along with their fitted values and standard deviations.",
			Category -> "Analysis & Reports",
			Headers->{"Parameter Name","Fitted Value","Standard Deviation"}
		},
		BestFitParametersDistribution -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> _MultinormalDistribution | _DataDistribution,
			Units -> None,
			Description -> "The multivariate distribution describing the best fit parameters.",
			Category -> "Analysis & Reports"
		},
		MarginalBestFitDistribution -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {_Symbol,DistributionP[]},
			Units -> {None, None},
			Description -> "The marginal distribution describing the best fit parameters.",
			Category -> "Analysis & Reports",
			Headers->{"Parameter Name","Fitted Distribution"}
		},
		BestFitVariables -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "A list of the variables present in the BestFitExpression of the fit function.",
			Category -> "Analysis & Reports"
		},
		PredictedResponse -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_?NumericQ...}|_?QuantityVectorQ,
			Units -> None,
			Description -> "Predicted y-values when best fit function is applied to data x-values.",
			Category -> "Analysis & Reports"
		},
		BestFitResiduals -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_?NumericQ...},
			Units -> None,
			Description -> "Difference between fit-calculated y-values and the actual y-values from the data points.",
			Category -> "Analysis & Reports"
		},
		Derivative -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[BestFitFunction]}, Computables`Private`derivativeComputable[Field[BestFitFunction]]],
			Pattern :> _Function,
			Description -> "Derivative of the fitted function.",
			Category -> "Analysis & Reports"
		},
		CovarianceMatrix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SquareNumericMatrixP,
			Description -> "Describes the sensitivity of the model to changes in the values of the fitted parameters, and is used in the calculation of model unertainty.",
			Category -> "Analysis & Reports"
		},
		HatDiagonal -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_?NumericQ...},
			Units -> None,
			Description -> "Describes the influence each response value has on each fitted value, and is used in outlier detection. Also known as the influence matrix or the projection matrix.",
			Category -> "Analysis & Reports"
		},
		ParallelLineAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Parallel Line Analyses performed based on this fit analysis.",
			Category -> "Analysis & Reports"
		},
		ANOVATable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Pane,
			Units -> None,
			Description -> "The statistic table generfated by performing an ANOVA analysis.",
			Category -> "Statistical Information"
		},
		ANOVAOfModel -> {
			Format -> Multiple,
			Class -> {Real, Real, Real, Real, Real, Real},
			Pattern :> {NumericP, NumericP, NumericP, NumericP, NumericP, NumericP},
			Units -> {None, None, None, None, None, None},
			Description -> "The ANOVA results when source of variation is from the regression model.",
			Category -> "Statistical Information",
			Headers->{"DF","Sum of Squares","Mean Squares","F-Statistic","F-Critical (95%)","P-Value"},
			Abstract -> True
		},
		ANOVAOfError -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {NumericP, NumericP, NumericP},
			Units -> {None, None, None},
			Description -> "The ANOVA results when source of variation is from the residual error.",
			Category -> "Statistical Information",
			Headers->{"DF","Sum of Squares","Mean Squares"},
			Abstract -> True
		},
		ANOVAOfTotal -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {NumericP, NumericP},
			Units -> {None, None},
			Description -> "The ANOVA results when source of variation is from the original data.",
			Category -> "Statistical Information",
			Headers->{"DF","Sum of Squares"},
			Abstract -> True
		},
		FStatistic -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "F Statistic is calculated by performing a F hypothesis test, following the equation MSR/MSE where MSR is the regression mean square, MSE is the mean square error.",
			Category -> "Statistical Information",
			Abstract -> True
		},
		FCritical -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "By default, it is the 95% critical value for the F-ratio distribution determined by the degrees of freedom in this object.",
			Category -> "Statistical Information",
			Abstract -> True
		},
		FTestPValue -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "The cumulative probability beyond FStatistic for the F-ratio distribution.",
			Category -> "Statistical Information",
			Abstract -> True
		},
		RSquared -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "R^2 value, also known as coefficient of determination, is a measure of how well the generated model fits its data.",
			Category -> "Statistical Information",
			Abstract -> True
		},
		AdjustedRSquared -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "An adjustment to the R^2 value that penalizes additional complexity in the model.",
			Category -> "Statistical Information"
		},
		AIC -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Akaike information criterion, a measure of the fit model's quality compared with other models.",
			Category -> "Statistical Information"
		},
		AICc -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Corrected Akaike information criterion, a measure of the fit model's quality compared with other models, corrected for small sample sizes.",
			Category -> "Statistical Information"
		},
		BIC -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Bayesian information criterion, a measure of a fit model's quality relative to other fit models, which penalizes model complexity more strongly than AIC.",
			Category -> "Statistical Information"
		},
		EstimatedVariance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Estimate of the error variance, calculated by dividing the sum squared error by the degrees of freedom (difference between the number of data points and number of model parameters).",
			Category -> "Statistical Information"
		},
		SumSquaredError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Sum of squared errors between fit-predicted and actual y-values.",
			Category -> "Statistical Information"
		},
		StandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "StandardDeviation of the fit error, which is equal to the squre root of the EstimatedVariance.",
			Category -> "Statistical Information"
		},
		MeanPredictionError -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes mean prediction error from a given x-value.  Mean prediction error is the expected error bewteen a predicted y-value and the average of repeated observations of that value.",
			Category -> "Statistical Information"
		},
		MeanPredictionDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes mean prediction distribution from a given x-value.",
			Category -> "Statistical Information"
		},
		SinglePredictionError -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes single prediction error from a given x-value.  Single prediction error is the expected error between a predicted y-value and a single obersvation of that value.",
			Category -> "Statistical Information"
		},
		SinglePredictionDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes single prediction distribution from a given x-value.",
			Category -> "Statistical Information"
		},
		MeanPredictionInterval -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes a 95% confidence interval for a mean predicted value from a given x-value.",
			Category -> "Statistical Information"
		},
		SinglePredictionInterval -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes a 95% confidence interval for a single predicted value from a given x-value.",
			Category -> "Statistical Information"
		},
		PredictedValues -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis, TotalProteinQuantification][StandardCurve],
				Object[Analysis, CopyNumber][StandardCurve],
				Object[Analysis, Kinetics][StandardCurve],
				Object[Analysis, CriticalMicelleConcentration][PreMicellarFit],
				Object[Analysis, CriticalMicelleConcentration][PostMicellarFit]
			],
			Description -> "The objects containing values predicted by this standard curve function.",
			Category -> "Standard Curve"
		}
	}
}];
