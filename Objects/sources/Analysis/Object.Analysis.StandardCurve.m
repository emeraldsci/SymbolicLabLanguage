(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


nestedFieldQ[arg_Symbol]:=True;
nestedFieldQ[head_Symbol[arg_]]:=nestedFieldQ[arg];
nestedFieldQ[_]:=False;
nestedFieldP = _?nestedFieldQ|_Field|_Symbol;


DefineObjectType[Object[Analysis, StandardCurve], {
  Description->"Analysis for fitting and applying a standard curve to input data.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    (* Method Information *)
    InputData->{
  		Format->Multiple,
  		Class->{Integer, Link, Expression, Expression},
  		Pattern:>{GreaterP[0,1], _Link, FieldP[Output->Short]|nestedFieldP, _Function|Identity},
  		Relation -> {Null, Object[Data]|Object[Analysis]|Object[Sample]|Model[Sample,StockSolution,Standard], Null, Null},
  		Description -> "The objects, fields, and transformations used to obtain data to apply the standard curve to.",
  		Category -> "General",
  		Headers ->{"Index","Object","Field","Transformation"}
  	},
    StandardIndependentVariableData->{
  		Format -> Multiple,
  		Class -> {Link, Expression, Expression},
  		Pattern :> {_Link, FieldP[Output->Short]|nestedFieldP, _Function|Identity},
  		Relation -> {Object[Data]|Object[Analysis]|Object[Sample]|Model[Sample,StockSolution,Standard], Null, Null},
  		Description -> "The objects, fields, and transformations used to obtain the x-values of data for standard curve fitting.",
  		Category -> "General",
  		Headers ->{"Object","Field","Transformation"}
  	},
    StandardDependentVariableData->{
  		Format -> Multiple,
  		Class -> {Link, Expression, Expression},
  		Pattern :> {_Link, FieldP[Output->Short]|nestedFieldP, _Function|Identity},
  		Relation -> {Object[Data]|Object[Analysis]|Object[Sample]|Model[Sample,StockSolution,Standard], Null, Null},
  		Description -> "The objects, fields, and transformations used to obtain the y-values of data for standard curve fitting.",
  		Category -> "General",
  		Headers ->{"Object","Field","Transformation"}
  	},
    InversePrediction->{
      Format->Single,
      Class->Boolean,
      Pattern:>BooleanP,
      Description->"Indicates if the standard curve should be applied in reverse, i.e. transform y to x instead of x to y.",
      Category -> "General"
    },
    Protocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol],
				Object[Protocol,Nephelometry][QuantificationAnalyses],
				Object[Protocol,NephelometryKinetics][QuantificationAnalyses]
			],
			Description->"The experimental procedure associated with this standard curve analysis.",
			Category -> "General"
		},
		ReferenceStandardCurve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, StandardCurve],
			Description -> "The intermediate standard curve that was used to convert the input data.",
			Category -> "General"
		},
    (* Analysis and Reports *)
    InputDataPoints->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(UnitsP[]|DistributionP[])..}|_?QuantityVectorQ,
			Description -> "List of numerical values in each dataset which the standard curve will be applied to.",
			Category -> "Analysis & Reports"
		},
		InputDataUnits->{
			Format -> Single,
			Class -> Expression,
			Pattern :> UnitsP[],
			Description -> "Physical units associated with the data which the standard curve will be applied to.",
			Category -> "Analysis & Reports"
		},
    StandardDataPoints->{
			Format -> Single,
			Class -> Compressed,
			Pattern :> MatrixP[NumericP]|MatrixP[UnitsP[]]|MatrixP[NumericP|_?DistributionParameterQ]|_?QuantityMatrixQ,
			Units -> {None, None},
			Description -> "List of {x,y} data points used to fit the standard curve.",
			Category -> "Analysis & Reports"
		},
		StandardDataUnits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UnitsP[],
			Description -> "Physical units associated with the data points used for fitting the standard curve.",
			Category -> "Analysis & Reports"
		},
    PredictedValues -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(UnitsP[]|DistributionP[])..}|_?QuantityVectorQ,
      Description -> "List of numerical values obtained from applying the standard curve to each input dataset.",
      Category -> "Analysis & Reports"
    },

    (* Standard Curve *)
    StandardCurveFit->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis,Fit],
      Description -> "The Analysis object representing the fitted standard curve.",
      Category -> "Standard Curve"
    },
    StandardCurveDomain->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> UnitsP[],
      Description -> "The minimum and maximum x-value in the data points used to fit the standard curve.",
      Category -> "Standard Curve"
    },
    StandardCurveRange->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> UnitsP[],
      Description -> "The minimum and maximum y-value in the data points used to fit the standard curve.",
      Category -> "Standard Curve"
    },
    SymbolicExpression->{
			Format -> Single,
			Class -> Expression,
			Pattern :> Except[_String],
			Description -> "The symbolic expression representing the function used to fit the standard curve, with best fit parameters represented as symbolic variables.",
			Category -> "Standard Curve"
		},
		ExpressionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FitExpressionP,
			Description -> "The mathematical function used to fit the standard curve.",
			Category -> "Standard Curve"
		},
    BestFitFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "Pure function that calculates the expected Y as a function of X.",
			Category -> "Standard Curve"
		},
		BestFitExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Except[_String],
			Description -> "The symbolic standard curve expression with the best fit parameters replaced by their fitted values.",
			Category -> "Standard Curve"
		},
		BestFitParameters -> {
			Format -> Multiple,
			Class -> {Expression, Real, Real},
			Pattern :> {_Symbol, NumericP, NumericP?NonNegative},
			Units -> {None, None, None},
			Description -> "The unknown parameters from the SymbolicExpression along with their fitted values and standard deviations.",
			Category -> "Standard Curve",
			Headers->{"Parameter Name","Fitted Value","Standard Deviation"}
		},
		BestFitParametersDistribution -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> _MultinormalDistribution | _DataDistribution,
			Units -> None,
			Description -> "The multivariate distribution describing the best fit parameters of the standard curve.",
			Category -> "Standard Curve"
		},
		MarginalBestFitDistribution -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {_Symbol,DistributionP[]},
			Units -> {None, None},
			Description -> "The marginal distributions describing the best fit parameters for the standard curve.",
			Category -> "Standard Curve",
			Headers->{"Parameter Name","Fitted Distribution"}
		},
		BestFitVariables -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "A list of the variables present in the BestFitExpression of the standard curve.",
			Category -> "Standard Curve"
		},

    (* Standard Curve Statistics *)
    ANOVATable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Pane,
			Units -> None,
			Description -> "The statistics table generated by performing an ANOVA analysis.",
			Category -> "Standard Curve Statistics"
		},
		ANOVAOfModel -> {
			Format -> Multiple,
			Class -> {Real, Real, Real, Real, Real, Real},
			Pattern :> {NumericP, NumericP, NumericP, NumericP, NumericP, NumericP},
			Units -> {None, None, None, None, None, None},
			Description -> "The ANOVA results when source of variation is from the regression model.",
			Category -> "Standard Curve Statistics",
			Headers->{"DF","Sum of Squares","Mean Squares","F-Statistic","F-Critical (95%)","P-Value"}
		},
		ANOVAOfError -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {NumericP, NumericP, NumericP},
			Units -> {None, None, None},
			Description -> "The ANOVA results when source of variation is from the residual error.",
			Category -> "Standard Curve Statistics",
			Headers->{"DF","Sum of Squares","Mean Squares"}
		},
		ANOVAOfTotal -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {NumericP, NumericP},
			Units -> {None, None},
			Description -> "The ANOVA results when source of variation is from the original data.",
			Category -> "Standard Curve Statistics",
			Headers->{"DF","Sum of Squares"}
		},
		FStatistic -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "F Statistic is calculated by performing a F hypothesis test, following the equation MSR/MSE where MSR is the regression mean square, MSE is the mean square error.",
			Category -> "Standard Curve Statistics"
		},
		FCritical -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "By default, it is the 95% critical value for the F-ratio distribution determined by the degrees of freedom in this object.",
			Category -> "Standard Curve Statistics"
		},
		FTestPValue -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "The cumulative probability beyond FStatistic for the F-ratio distribution.",
			Category -> "Standard Curve Statistics"
		},
		RSquared -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "R^2 value, also known as coefficient of determination, is a measure of how well the generated model fits its data.",
			Category -> "Standard Curve Statistics"
		},
		AdjustedRSquared -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "An adjustment to the R^2 value that penalizes additional complexity in the model.",
			Category -> "Standard Curve Statistics"
		},
		AIC -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Akaike information criterion, a measure of the fit model's quality compared with other models.",
			Category -> "Standard Curve Statistics"
		},
		AICc -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Corrected Akaike information criterion, a measure of the fit model's quality compared with other models, corrected for small sample sizes.",
			Category -> "Standard Curve Statistics"
		},
		BIC -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Bayesian information criterion, a measure of a fit model's quality relative to other fit models, which penalizes model complexity more strongly than AIC.",
			Category -> "Standard Curve Statistics"
		},
		EstimatedVariance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Estimate of the error variance, calculated by dividing the sum squared error by the degrees of freedom (difference between the number of data points and number of model parameters).",
			Category -> "Standard Curve Statistics"
		},
		SumSquaredError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Sum of squared errors between fit-predicted and actual y-values.",
			Category -> "Standard Curve Statistics"
		},
		StandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "StandardDeviation of the fit error, which is equal to the squre root of the EstimatedVariance.",
			Category -> "Standard Curve Statistics"
		}
  }
}];
