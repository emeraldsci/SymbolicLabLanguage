(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, Ladder], {
	Description->"A standard curve fit relating oligomer fragment size to positions obtained through peaks analysis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Sizes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "A list of the fragment lengths included in a standard sample, which are used as the dependent coordinates in this standard curve fit.",
			Category -> "General"
		},
		SizeUnit -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?UnitsQ,
			Description -> "The unit of the known sizes, which can be lengths or weights,  used in the standard curve fit.",
			Category -> "General"
		},
		PositionUnit -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?UnitsQ,
			Description -> "The unit of the peak positions, which can be times or distances, used in the standard curve fit.",
			Category -> "General"
		},
		FragmentPeaks -> {
			Format -> Multiple,
			Class -> {Integer, Real},
			Pattern :> {GreaterEqualP[0, 1], GreaterP[0]},
			Units -> {None, None},
			Description -> "List of paired data points.",
			Category -> "General",
			Abstract -> True,
			Headers ->{"Standard Peak Position", "Fragment Size"}
		},
		StandardFit -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The standard curve fit created from the FragmentPeaks data points.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		ExpectedSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[StandardFit], Field[PositionUnit], Field[SizeUnit]}, Computables`Private`expectedSize[Field[StandardFit], Field[PositionUnit], Field[SizeUnit]]],
			Pattern :> Verbatim[Function][_QuantityFunction[_]] | Null,
			Description -> "A pure function that will return an expected size if given a position.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		ExpectedSizeFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function,
			Description -> "A pure function that will return an expected size if given a position.",
			Category -> "Analysis & Reports"
		},
		ExpectedPosition -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[StandardFit], Field[PositionUnit], Field[SizeUnit]}, Computables`Private`expectedPosition[Field[StandardFit], Field[PositionUnit], Field[SizeUnit]]],
			Pattern :> Verbatim[Function][_QuantityFunction[_]] | Null,
			Description -> "A pure function that will return an expected position if given a size.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		ExpectedPositionFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function,
			Description -> "A pure function that will return an expected position if given a size.",
			Category -> "Analysis & Reports"
		},
		PeaksAnalysis -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, Peaks][StandardAnalysis],
			Description -> "The peaks analysis whose positions are used as the indepenent coordinates in this standard curve fit.",
			Category -> "Analysis & Reports"
		},
		Ladder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Model[Sample, StockSolution, Standard][LadderAnalyses],
			Description -> "The ladder object containing the sizes used for fitting.",
			Category -> "Analysis & Reports"
		}
	}
}];
