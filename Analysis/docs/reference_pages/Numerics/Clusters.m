(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeClusters*)


DefineUsage[AnalyzeClusters,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeClusters[data]","clusteringObject"},
				Description->"partitions the data points contained in 'data' into distinct similarity groups.",
				Inputs:>{
					{
						InputName->"data",
						Description->"A rectangular matrix of data points to be partitioned by clustering.",
						Widget->Widget[Type->Expression,Pattern:>{{UnitsP[]..}..}|_?tabularDataQuantityArrayQ,Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"clusteringObject",
						Description->"A Constellation object that contains both the identified similarity groups and the methodology used to detect them.",
						Pattern:>ObjectP[Object[Analysis,Clusters]]
					}
				}
			}
		},
		MoreInformation -> {
			"Suitable tabular data include any rectangular matrix in the form {{_?NumericQ|_?QuantityQ..}..}.",
			"Manual gating entails defining lists of 1D, 2D, or 3D filters. To be included in a partition, a given data point must pass all filters in the corresponding list. Any points not captured by any of the manual gates are excluded from the analysis.",
			"Each 1D filter includes an index denoting the data column used for gating, a real-valued threshold, and an indicator denoting whether data points below or above the threshold are included.",
			"Each 2D filter includes a pair of indices denoting the two data columns used for gating, a 2D polygon defining the gate, and an indicator denoting whether data points within the polygon are included or excluded.",
			"Each 3D filter includes a set of indices denoting the three data columns used for gating, a 3D ellipsoid defining the gate, and an indicator denoting whether data points within the ellipsoid are included or excluded."
		},
		SeeAlso -> {
			"AnalyzeClustersOptions",
			"AnalyzeClustersPreview",
			"ValidAnalyzeClustersQ",
			"AnalyzeDigitalPCR"
		},
		Author -> {"malav.desai", "kevin.hou", "sebastian.bernasek", "brad"},
		Guides -> {
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Preview->True,
		PreviewOptions->{"Domain","ManualGates","ClusterLabels"},
		ButtonActionsGuide->{
			{Description->"Select multiple contiguous elements from a list", ButtonSet->"'Shift' + 'LeftClick'"},
			{Description->"Select multiple non-contiguous elements from a list", ButtonSet->"'ControlKey' + 'LeftClick'"},
			{Description->"Move interactive elements such as gating points or thresholds", ButtonSet->"'LeftDrag'"}
		}
	}
];


(* ::Subsubsection:: *)
(*AnalyzeClustersOptions*)


DefineUsage[AnalyzeClustersOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeClustersOptions[data]","resolvedOptions"},
				Description->"returns the resolved options for AnalyzeClusters when it is called on 'data'.",
				Inputs:>{
					{
						InputName->"data",
						Description->"A rectangular matrix of data points to be partitioned by clustering.",
						Widget->Widget[Type->Expression,Pattern:>{{UnitsP[]..}..}|_?tabularDataQuantityArrayQ,Size->Paragraph]
					}
				},
				Outputs:>{
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options when AnalyzeClusters is called on the provided input data.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
				}
			}
		},
		SeeAlso -> {
			"AnalyzeClusters",
			"AnalyzeClustersPreview",
			"ValidAnalyzeClustersQ"
		},
		Author -> {"scicomp", "brad", "kevin.hou"}
	}
];


(* ::Subsubsection:: *)
(*AnalyzeClustersPreview*)


DefineUsage[AnalyzeClustersPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeClustersPreview[data]","preview"},
				Description->"returns an interactive graphical 'preview' of the output of AnalyzeClusters when it is called on 'data'.",
				Inputs:>{
					{
						InputName->"data",
						Description->"A rectangular matrix of data points to be partitioned by clustering.",
						Widget->Widget[Type->Expression,Pattern:>{{UnitsP[]..}..}|_?tabularDataQuantityArrayQ,Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"The interactive graphical preview showing input data partitioned by clustering analysis.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeClusters",
			"AnalyzeClustersOptions",
			"ValidAnalyzeClustersQ"
		},
		Author -> {"scicomp", "brad", "kevin.hou"}
	}
];


(* ::Subsubsection:: *)
(*ValidAnalyzeClustersQ*)


DefineUsage[ValidAnalyzeClustersQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidAnalyzeClustersQ[data]","boolean"},
				Description->"checks whether 'data' and any specified options are valid inputs to AnalyzeClusters.",
				Inputs:>{
					{
						InputName->"data",
						Description->"A rectangular matrix of data points to be partitioned by clustering.",
						Widget->Widget[Type->Expression,Pattern:>{{UnitsP[]..}..}|_?tabularDataQuantityArrayQ,Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"boolean",
						Description->"A value indicating whether the AnalyzeDNASequencing call is valid. The return value can be changed with the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeClusters",
			"AnalyzeClustersOptions",
			"AnalyzeClustersPreview"
		},
		Author -> {"scicomp", "brad", "kevin.hou"}
	}
];