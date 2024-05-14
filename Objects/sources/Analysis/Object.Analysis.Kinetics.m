(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, Kinetics], {
	Description->"Fitting the unknown kinetic rates in a ReactionMechanism using experimental or simulated kinetic trajectories.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Species -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "All of the participating reagents involved in the ReactionMechanism.",
			Category -> "General",
			Abstract -> True
		},
		FitMechanism -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> ReactionMechanismP,
			Units -> None,
			Description -> "A ReactionMechanism containing some unkonwn kinetic rates, which is fitted by this analysis.",
			Category -> "General"
		},
		TrainingData -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Expression, Expression},
			Pattern :> {ECL`StateFormatP,ECL`InjectionsFormatP|{},ECL`TrajectoryFormatP,VolumeP},
			Description -> "The data that the kinetic rates are fitted to.",
			Category -> "General",
			Headers->{"Initial State", "Injections", "Trajectory", "InitialVolume"}
		},
		StandardCurve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, Fit][PredictedValues],
			Description -> "Standard curve fitting analysis characterizing the relationship between concentration and fluorescence.",
			Category -> "General"
		},
		Rates -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {_Symbol, NumericP},
			Units -> {None, None},
			Description -> "The unknown rate variables from the InitialMechanism along with their fitted values.",
			Category -> "Analysis & Reports",
			Headers->{"Rate Variable Name", "Fitted Value"}
		},
		RatesStandardDeviation -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {_Symbol, NumericP},
			Units -> {None, None},
			Description -> "The standard deviation of the fitted rate values.",
			Category -> "Analysis & Reports",
			Headers -> {"Rate Variable Name", "Standard Deviation"}
		},
		RatesDistribution -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {_Symbol, QuantityDistributionP[]},
			Units -> {None, None},
			Description -> "The distribution of the fitted rate values.",
			Category -> "Analysis & Reports",
			Headers -> {"Rate Variable Name", "Distribution"}
		},
		ReactionMechanism -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> ReactionMechanismP,
			Units -> None,
			Description -> "The fully specified ReactionMechanism that best fits the training data, which is the initial ReactionMechanism with the fitted rates substituted in for the unknown rates.",
			Category -> "Analysis & Reports"
		},
		KineticsEquations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> KineticsEquationP,
			Description -> "The equations that are fitted to sovle for the Rates.",
			Category -> "General",
			Abstract -> True
		},
		PredictedTrajectories -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {TrajectoryP...},
			Units -> None,
			Description -> "The kinetic trajectories predicted by the fitted model when simulated with the intial states and injections specified in the TrainingData.",
			Category -> "Analysis & Reports"
		},
		NumberOfIterations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of steps required to by the optimizer to solve for the kinetic rates, which is a measure of how difficult the fitting was.",
			Category -> "Analysis & Reports"
		},
		Residual -> {
			Format -> Single,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "The minimum value of the objective function, which is achieved at the solution of the optimization problem (i.e. the fitted rates).  This is a measure of how well the fitted model matches the training data.",
			Category -> "Analysis & Reports"
		},
		SumSquaredError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Sum of squared errors across all training trajectories and predicted trajectories.",
			Category -> "Statistical Information"
		}
	}
}];
