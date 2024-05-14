(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, Smoothing], {
	Description->"Smoothing analysis of curves constructed via connected {x,y} datapoints.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

    (* does it need to have any Information about the object that it took the data from? *)

		ResolvedDataPoints -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP),
			Description -> "List of {x,y} datapoints that is ensured to have equal spacing before applying smoothing analysis.",
			Category -> "Analysis & Reports"
		},

    SmoothedDataPoints -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> (CoordinatesP|QuantityCoordinatesP[]),
			Description -> "List of {x,y} datapoints after applying the smoothing analysis.",
			Category -> "Analysis & Reports"
		},

    (* ask about if we need to add units as an extra field maybe quantity array pattern would be sufficient*)
		(* WeightFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SmoothingMethodP,
			Description -> "The type of smoothing weighting function used to fit the provided data.",
			Category -> "General"
		}, *)

		Radius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0]|GreaterEqualP[0*ArbitraryUnit],
			Units -> None,
			Description -> "The best smoothing radius which is used in all methods except LowpassFilter and HighpassFilter.",
			Category -> "Analysis & Reports"
		},

		CutoffFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0]|GreaterP[0*ArbitraryUnit],
			Units -> None,
			Description -> "The best smoothing cutoff frequency which is used for LowpassFilter or HighpassFilter methods.",
			Category -> "Analysis & Reports"
		},

		EstimatedBaseline -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> (CoordinatesP|QuantityCoordinatesP[]),
			Description -> "List of {x,y} datapoints that estimates the baseline of the dataset.",
			Category -> "Analysis & Reports"
		},

		SmoothingLocalStandardDeviation -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> (CoordinatesP|QuantityCoordinatesP[]),
			Description -> "List of {x,y} datapoints that estimates the standard deviation of the difference between the smoothed dataset and the original dataset which can be used as a goodness of smoothing criteria.",
			Category -> "Analysis & Reports"
		},

		Residuals -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_?NumericQ...}|_?NumericQ,
			Units -> None,
			Description -> "Mean squared value of the difference between smoothed y-values and the actual y-values from the data points for each data point.",
			Category -> "Analysis & Reports"
		},

		TotalResidual -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Total mean squared value of the difference between smoothed y-values and the actual y-values from the data points.",
			Category -> "Analysis & Reports"
		}

	}
}];
