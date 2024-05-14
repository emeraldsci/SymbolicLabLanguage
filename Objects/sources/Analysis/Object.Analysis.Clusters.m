(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,Clusters], {
	Description->"Automated or manual grouping of point data in tabular form.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		NumberOfDimensions->{
			Format->Single,
			Class->Expression,
			Pattern:>_Integer,
			Description->"The number of values defined for each data point.",
			Category->"Data Processing"
		},
		DimensionLabels->{
			Format->Single,
			Class->Expression,
			Pattern:>ListableP[_String|_Symbol|None],
			Description->"The name of the property described by each value of a data point.",
			Category->"Data Processing"
		},
		DimensionUnits->{
			Format->Multiple,
			Class->Expression,
			Pattern:>UnitsP[]|_IndependentUnit,
			Description->"The units of measure attached to each value of a data point.",
			Category->"Data Processing"
		},
		Normalize->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the input data were linearly rescaled to a 0-1 inclusive interval prior to subsequent data processing and partioning.",
			Category -> "General"
		},
		Scale->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Linear|Log|Reciprocal,
			Description->"Indicates how each dimension of the input data was transformed prior to subsequent data processing and partioning.",
			Category -> "General"
		},
		Domain->{
			Format->Multiple,
			Class->Expression,
			Pattern:>OneDimensionalGateP|TwoDimensionalGateP|ThreeDimensionalGateP|_Function|{},
			Description->"A set of constraints that dictate which data points are subject to automated clustering when Method is set to Automatic. A given data point must satisfy all constraints in order to be subject to automated clustering. A constraint may be defined as a pure function that accepts a data point as input and returns True if that data point should be subject to automated clustering. Constraints may also be defined using 1D, 2D, or 3D gates, so long as all gates are of the same dimensionality. Each 1D gate includes an index denoting the data column used for gating, a real-valued threshold, and an indicator denoting whether data points below or above the threshold are included. Each 2D gate definition must include a pair of indices denoting the two data columns to which the gate is applied, a 2D polygon defining the gate, and an indicator denoting whether data points within the polygon are to be included or excluded from automated clustering. Each 3D gate definition must include a set of indices denoting the three data columns to which the gate is applied, a 3D ellipsoid defining the gate, and an indicator denoting whether data points within the ellipsoid are to be included or excluded from automated clustering.",
			Category -> "General"
		},
		ClusterDomainOutliers->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether any data points located outside of the specified Domain were assigned to the nearest partition once partitioning was complete. If set to False, the excluded data points were not assigned to a partition.",
			Category -> "General"
		},
		Method->{
			Format->Single,
			Class->Expression,
			Pattern:>Automatic|Manual,
			Description->"The methodology used to partition the data points.",
			Category -> "General"
		},
		ClusteringAlgorithm->{
			Format->Single,
			Class->Expression,
			Pattern:>ClusteringAlgorithmP,
			Description->"The unsupervised clustering algorithm used to automatically partition the data points.",
			Category -> "General"
		},
		ManualGates->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{}|{OneDimensionalGateP..}|{TwoDimensionalGateP..}|{ThreeDimensionalGateP..},
			Description->"One or more lists of filters, each of which defines a distinct cluster when applied sequentially to the data. To be included in a partition, a given data point must pass all filters in the corresponding list. Filters may be defined in 1D, 2D, or 3D, so long as all filters are of the same dimensionality. Each 1D filter includes an index denoting the data column used for gating, a real-valued threshold, and an indicator denoting whether data points below or above the threshold are included. Each 2D filter includes a pair of indices denoting the two data columns used for gating, a 2D polygon defining the gate, and an indicator denoting whether data points within the polygon are included or excluded. Each 3D filter includes a set of indices denoting the three data columns used for gating, a 3D ellipsoid defining the gate, and an indicator denoting whether data points within the polygon are included or excluded. If any data points  are excluded by all ManualGates, a single additional partition will be added and all such points will be assigned to it.",
			Category -> "General"
		},
		ClusteredDimensions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_Integer,
			Description->"Indices denoting which data columns were used to perform automated clustering.",
			Category -> "General"
		},
		NumberOfClusters->{
			Format->Single,
			Class->Expression,
			Pattern:>Automatic|0|_?(IntegerQ[#1]&&Positive[#1]&),
			Description->"The specified number of groups that were to be identified during automated clustering. A value of Automatic implies that an appropriate number of groups was inferred from the data.",
			Category -> "General"
		},
		DistanceFunction->{
			Format->Single,
			Class->Expression,
			Pattern:>DistanceFunctionP|_Function,
			Description->"The method used to quantify the similarity between a pair of data points.",
			Category -> "General"
		},
		ClusterLabels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_String|_Integer,
			Description->"The name assigned to each group included in ClusteredData.",
			Category->"Analysis & Reports"
		},
		ClusterAssignments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Cell],
			Description->"For each member of ClusterLabels, the putative cell identity model associated with that cluster.",
			Category->"Analysis & Reports",
			IndexMatching->ClusterLabels
		},
		PreprocessedData->{
			Format->Single,
			Class->Compressed,
			Pattern:>{}|{{_?NumericQ..}..}|_?((QuantityArrayQ[#]&&Length@Dimensions[#]==2)&),
			Units->None,
			Description->"The data points after normalization and scaling have been applied.",
			Category->"Analysis & Reports"
		},
		IncludedIndices->{
			Format->Single,
			Class->Compressed,
			Pattern:>{_?IntegerQ..}|{},
			Units->None,
			Description->"The positional indices of all input data points that either lie within the specified Domain or were selected by at least one of the specified ManualGates.",
			Category->"Analysis & Reports"
		},
		IncludedData->{
			Format->Single,
			Class->Compressed,
			Pattern:>{}|{{_?NumericQ..}..}|_?((QuantityArrayQ[#]&&Length@Dimensions[#]==2)&),
			Units->None,
			Description->"The data points that either lie within the specified Domain or were selected by at least one of the specified ManualGates. These values have not been subject to any preprocessing via Normalize or Scale.",
			Category->"Analysis & Reports"
		},
		ExcludedIndices->{
			Format->Single,
			Class->Compressed,
			Pattern:>{_?IntegerQ..}|{},
			Units->None,
			Description->"The positional indices of all input data points that either lie outside the specified Domain, were identified as outliers during automated clustering, or were not selected by any of the specified ManualGates.",
			Category->"Analysis & Reports"
		},
		ExcludedData->{
			Format->Single,
			Class->Compressed,
			Pattern:>{}|{{_?NumericQ..}..}|_?((QuantityArrayQ[#]&&Length@Dimensions[#]==2)&),
			Units->None,
			Description->"The data points that either lie outside of the specified Domain, were identified as outliers during automated clustering, or were not selected by any of the specified ManualGates. These values have not been subject to any preprocessing via Normalize or Scale.",
			Category->"Analysis & Reports"
		},
		ClusteredData->{
			Format->Single,
			Class->Compressed,
			Pattern:>_Association,
			Units->None,
			Description->"The original data points partitioned into distinct groups. If ClusterDomainOutliers is True, all data points appearing in ExcludedData are also included.",
			Category->"Analysis & Reports"
		},
		ClusteredDataConfidence->{
			Format->Single,
			Class->Compressed,
			Pattern:>None|_Association,
			Units->None,
			Description->"The posterior probability of the group assignment for each data point in ClusteredData.",
			Category->"Analysis & Reports"
		},
		WithinClusterSumOfSquares->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The total squared distance from each data point to the mean value of its respective partition.",
			Category->"Analysis & Reports"
		},
		SilhouetteScore->{
			Format->Single,
			Class->Expression,
			Pattern:>None|_?NumericQ,
			Units->None,
			Description->"A clustering evaluation metric that compares the distance between each point and its within-cluster neighbors against the distance between each point and all members of the next-nearest cluster. The metric is bounded between -1 and 1, with larger values reflecting better separability between clusters. For more information, see https://doi.org/10.1016/0377-0427(87)90125-7.",
			Category->"Analysis & Reports"
		},
		VarianceRatioCriterion->{
			Format->Single,
			Class->Expression,
			Pattern:>None|_?NumericQ,
			Units->None,
			Description->"A clustering evaluation metric that compares the dispersion between clusters against the dispersion within each cluster. Larger values reflecting better separability between clusters. For more information, see https://doi.org/10.1080/03610927408827101.",
			Category->"Analysis & Reports"
		},
		FlowCytometryAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis,FlowCytometry][ClustersAnalyses],
			Description -> "The flow cytometry analysis object relating cell counts to this clustering analysis.",
			Category -> "Analysis & Reports"
		}
	}
}];
