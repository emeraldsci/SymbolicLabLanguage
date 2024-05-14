(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, ParallelLine], {
	Description->"Dose-response parallel line analysis of connected {x,y} datapoints.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		DataPointsStandard -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> MatrixP[NumericP] | MatrixP[UnitsP[]] | MatrixP[NumericP | _?DistributionParameterQ] | _?QuantityMatrixQ,
			Units -> {None, None},
			Description -> "List of {x,y} datapoints in the standard sample set (including outliers and excluded points).",
			Category -> "General"
		},
		DataPointsAnalyte -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> MatrixP[NumericP] | MatrixP[UnitsP[]] | MatrixP[NumericP | _?DistributionParameterQ] | _?QuantityMatrixQ,
			Units -> {None, None},
			Description -> "List of {x,y} datapoints in the analyte sample set (including outliers and excluded points).",
			Category -> "General"
		},
		DataUnits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UnitsP[],
			Description -> "Units associated with the DataPoints used for fitting.",
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
		SymbolicExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Except[_String],
			Description -> "The symbolic expression representing the type of function used in this fit, with best fit parameters still represented as symbolic variables.",
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
		ExpressionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FitExpressionP,
			Description -> "The type of expression or function used to fit the provided data.",
			Category -> "General"
		},
		BestFitFunction -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {_Function|_QuantityFunction, _Function|_QuantityFunction},
			Units -> {None, None},
			Description -> "Fit function that calculates the expected Y as a function of X, stored as a pure function.",
			Category -> "Analysis & Reports",
			Headers->{"Standard Samples","Analyte Samples"},
			Abstract -> True
		},
		BestFitExpression -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {Except[_String], Except[_String]},
			Units -> {None, None},
			Description -> "The symbolic expression with the best fit parameters replaced by their fitted values.",
			Category -> "Analysis & Reports",
			Headers->{"Standard Samples","Analyte Samples"},
			Abstract -> True
		},
		BestFitParametersStandard -> {
			Format -> Multiple,
			Class -> {Expression, Real, Real},
			Pattern :> {_Symbol, NumericP, NumericP?NonNegative},
			Units -> {None, None, None},
			Description -> "The estimated best fit four parameters for standard samples along with their fitted values and standard deviations.",
			Category -> "Analysis & Reports",
			Headers->{"Parameter Name","Fitted Value","Standard Deviation"}
		},
		BestFitParametersAnalyte -> {
			Format -> Multiple,
			Class -> {Expression, Real, Real},
			Pattern :> {_Symbol, NumericP, NumericP?NonNegative},
			Units -> {None, None, None},
			Description -> "The estimated best fit four parameters for analyte samples along with their fitted values and standard deviations.",
			Category -> "Analysis & Reports",
			Headers->{"Parameter Name","Fitted Value","Standard Deviation"}
		},
		RelativePotency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "The ratio of relative potency which is determined in the linear region of the curve where the response changes relative to the concentration at 50% effective dose or EC50.",
			Category -> "Statistical Information",
			Abstract -> True
		},
		RelativePotencyDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[],
			Description -> "Distribution of relative potency as a result of the division between standard and analyte inflection point distributions.",
			Category -> "Statistical Information",
			Abstract -> True
		},
		ANOVATableStandard -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Pane,
			Units -> None,
			Description -> "The statistic table generfated by performing an ANOVA analysis on standard samples.",
			Category -> "Statistical Information"
		},
		ANOVATableAnalyte -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Pane,
			Units -> None,
			Description -> "The statistic table generfated by performing an ANOVA analysis on analyte samples.",
			Category -> "Statistical Information"
		},
		ANOVAOfModel -> {
			Format -> Multiple,
			Class -> {Expression, Real, Real, Real, Real, Real, Real},
			Pattern :> {_Symbol, NumericP, NumericP, NumericP, NumericP, NumericP, NumericP},
			Units -> {None, None, None, None, None, None, None},
			Description -> "The ANOVA results when source of variation is from the regression model.",
			Category -> "Statistical Information",
			Headers->{"Samples","DF","Sum of Squares","Mean Squares","F-Statistic","F-Critical (95%)","P-Value"},
			Abstract -> True
		},
		ANOVAOfError -> {
			Format -> Multiple,
			Class -> {Expression, Real, Real, Real},
			Pattern :> {_Symbol, NumericP, NumericP, NumericP},
			Units -> {None, None, None, None},
			Description -> "The ANOVA results when source of variation is from the residual error.",
			Category -> "Statistical Information",
			Headers->{"Samples","DF","Sum of Squares","Mean Squares"},
			Abstract -> True
		},
		ANOVAOfTotal -> {
			Format -> Multiple,
			Class -> {Expression, Real, Real},
			Pattern :> {_Symbol, NumericP, NumericP},
			Units -> {None, None, None},
			Description -> "The ANOVA results when source of variation is from the original data.",
			Category -> "Statistical Information",
			Headers->{"Samples","DF","Sum of Squares"},
			Abstract -> True
		},
		FStatistic -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {NumericP, NumericP},
			Units -> {None, None},
			Description -> "F Statistic is calculated by performing a F hypothesis test, following the equation MSR/MSE where MSR is the regression mean square, MSE is the mean square error.",
			Category -> "Statistical Information",
			Headers->{"Standard Samples","Analyte Samples"},
			Abstract -> True
		},
		FCritical -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {NumericP, NumericP},
			Units -> {None, None},
			Description -> "By default, it is the 95% critical value for the F-ratio distribution determined by the degrees of freedom in this object.",
			Category -> "Statistical Information",
			Headers->{"Standard Samples","Analyte Samples"},
			Abstract -> True
		},
		FTestPValue -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {NumericP, NumericP},
			Units -> {None, None},
			Description -> "The cumulative probability beyond FStatistic for the F-ratio distribution.",
			Category -> "Statistical Information",
			Headers->{"Standard Samples","Analyte Samples"},
			Abstract -> True
		},
		RSquared -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {NumericP?NonNegative, NumericP?NonNegative},
			Units -> {None, None},
			Description -> "R^2 value, also known as coefficient of determination, is a measure of how well the generated model fits its data.",
			Category -> "Statistical Information",
			Headers->{"Standard Samples","Analyte Samples"},
			Abstract -> True
		},
		AdjustedRSquared -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {NumericP?NonNegative, NumericP?NonNegative},
			Units -> {None, None},
			Description -> "An adjustment to the R^2 value that penalizes additional complexity in the model.",
			Category -> "Statistical Information",
			Headers->{"Standard Samples","Analyte Samples"},
			Abstract -> True
		}
	}
}]
