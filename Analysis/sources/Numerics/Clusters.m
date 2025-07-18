(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Patterns*)


(* Define pattern matching tabular data in quantity array form *)
tabularDataQuantityArrayQ[in_]:=QuantityArrayQ[in]&&MatchQ[List@@(QuantityMagnitude@in),{{_?NumericQ..}..}];


(* Define list of support data objects *)
clusterableDataObjects={Object[Data,DigitalPCR],Object[Data,FlowCytometry]};


(* ::Subsection::Closed:: *)
(*Options*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeClusters Options*)


DefineOptions[AnalyzeClusters,
	Options:>{
		{
			OptionName->Scale,
			Description->"Specifies any transformations to be applied to each dimension of the input data prior to all subsequent data processing and partitioning. Please note that scaling precedes normalization.",
			Default->Linear,
			AllowNull->False,
			Widget->Alternatives[
				"Scale All Dimensions"->Widget[Type->Enumeration,Pattern:>Linear|Log|Reciprocal],
				"Scale Individual Dimensions"->Adder[Widget[Type->Enumeration,Pattern:>Linear|Log|Reciprocal]]
			],
			Category->"Data Preprocessing"
		},
		{
			OptionName->Normalize,
			Description->"If set to True, the input data will be linearly rescaled to a [0,1] interval prior to all subsequent data processing and partitioning.",
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Data Preprocessing"
		},
		{
			OptionName->Method,
			Description->"The overall strategy used to partition the input data into distinct groups. May be set to either Automatic or Manual. If set to Automatic, the specified ClusteringAlgorithm will be used to automatically partition the input data. If set to Manual, the specified ManualGates will be applied to the input data.",
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Automatic|Manual],
			Category->"Methodology"
		},
		{
			OptionName->ManualGates,
			Description->"Specifies one or more lists of filters, each of which defines a distinct cluster when applied sequentially to the data. To be included in a partition, a given data point must pass all filters in the corresponding list. Filters may be defined in 1D, 2D, or 3D, so long as all filters are of the same dimensionality. Each 1D filter includes an index denoting the data column used for gating, a real-valued threshold, and an indicator denoting whether data points below or above the threshold are included. Each 2D filter includes a pair of indices denoting the two data columns used for gating, a 2D polygon defining the gate, and an indicator denoting whether data points within the polygon are included or excluded. Each 3D filter includes a set of indices denoting the three data columns used for gating, a 3D ellipsoid defining the gate, and an indicator denoting whether data points within the polygon are included or excluded. Any data points excluded by all ManualGates will be treated as excluded data.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,{}]],
				Widget[Type->Expression,Pattern:>{{OneDimensionalGateP..}..}|{{TwoDimensionalGateP..}..}|{{ThreeDimensionalGateP..}..},Size->Paragraph],
				Alternatives[
					"1D Gates"->Adder[
						Adder[
							{
								"Dimension"->Widget[Type->Expression,Pattern:>_?((IntegerQ[#]&&GreaterEqualQ[#,1])&),Size->Word],
								"Threshold"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Indicator"->Widget[Type->Enumeration,Pattern:>Below|Above]
							}
						]
					],
					"2D Polygonal Gates"->Adder[
						Adder[
							{
								"Dimension 1"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
								"Dimension 2"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
								"2D Polygon"->Widget[Type->Expression,Pattern:>_Polygon,Size->Line],
								"Indicator"->Widget[Type->Enumeration,Pattern:>Include|Exclude]
							}
						]
					],
					"3D Ellipsoidal Gates"->Adder[
						Adder[
							{
								"Dimension 1"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
								"Dimension 2"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
								"Dimension 3"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
								"3D Ellipsoid"->Widget[Type->Expression,Pattern:>_Polygon|_Ellipsoid,Size->Line],
								"Indicator"->Widget[Type->Enumeration,Pattern:>Include|Exclude]
							}
						]
					]
				]
			],
			Category->"Methodology"
		},
		{
			OptionName->ClusteringAlgorithm,
			Description->"The algorithm or approach used to automatically partition the input data into distinct groups when Method is set to Automatic.",
			ResolutionDescription->"If set to Automatic, an unsupervised clustering algorithm will be selected depending on the dimensionality of the data, the specified PerformanceGoal, and whether or not the NumberOfClusters was specified.",
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>ClusteringAlgorithmP],
			Category->"Methodology"
		},
		{
			OptionName->NumberOfClusters,
			Description->"Specifies how many groups the input data should be partitioned into when Method is set to Automatic.",
			ResolutionDescription->"If set to Automatic and ClusteringMethod is set to an algorithm that requires the number of groups to be specified, the number of groups will be determined by optimizing the specified CriterionFunction.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,Sequence@@Range[2,10]]],
				Widget[Type->Number,Pattern:>GreaterEqualP[1],Min->1]
			],
			Category->"Methodology"
		},
		{
			OptionName->Domain,
			Description->"Specifies a set of constraints that dictate which data points are subject to automated clustering when Method is set to Automatic. A given data point must satisfy all constraints in order to be subject to automated clustering. A constraint may be defined as a pure function that accepts a data point as input and returns True if that data point should be subject to automated clustering. Constraints may also be defined using 1D, 2D, or 3D gates, so long as all gates are of the same dimensionality. Each 1D gate includes an index denoting the data column used for gating, a real-valued threshold, and an indicator denoting whether data points below or above the threshold are included. Each 2D gate definition must include a pair of indices denoting the two data columns to which the gate is applied, a 2D polygon defining the gate, and an indicator denoting whether data points within the polygon are to be included or excluded from automated clustering. Each 3D gate definition must include a set of indices denoting the three data columns to which the gate is applied, a 3D ellipsoid defining the gate, and an indicator denoting whether data points within the ellipsoid are to be included or excluded from automated clustering.",
			ResolutionDescription->"If set to Automatic, all data points will be used during automated clustering.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Multiple Constraints"->Widget[Type->Expression,Pattern:>{OneDimensionalGateP..}|{TwoDimensionalGateP..}|{ThreeDimensionalGateP..}|{_Function..}|{},Size->Paragraph,PatternTooltip->"A list of constraint definitions."],
				"Individual Constraint"->Alternatives[
					"1D Threshold Gates"->Adder[
						{
							"Dimension"->Widget[Type->Expression,Pattern:>_?((IntegerQ[#]&&GreaterEqualQ[#,1])&),Size->Word],
							"Threshold"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
							"Indicator"->Widget[Type->Enumeration,Pattern:>Below|Above]
						}
					],
					"2D Polygonal Gates"->Adder[
						{
							"Dimension 1"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
							"Dimension 2"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
							"2D Polygon"->Widget[Type->Expression,Pattern:>_Polygon,Size->Line],
							"Indicator"->Widget[Type->Enumeration,Pattern:>Include|Exclude]
						}
					],
					"3D Ellipsoidal Gates"->Adder[
						{
							"Dimension 1"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
							"Dimension 2"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
							"Dimension 3"->Widget[Type->Expression,Pattern:>_Integer,Size->Word],
							"3D Ellipsoid"->Widget[Type->Expression,Pattern:>_Polygon|_Ellipsoid,Size->Line],
							"Indicator"->Widget[Type->Enumeration,Pattern:>Include|Exclude]
						}
					],
					"Pure Function"->Adder[
						Widget[Type->Expression,Pattern:>_Function,Size->Line]
					]
				]
			],
			Category->"Methodology"
		},
		{
			OptionName->ClusterDomainOutliers,
			Description->"If set to True, any data points located outside of the specified Domain, identified as outliers, or excluded by all ManualGates will be assigned to the nearest partition once automated clustering is complete. If set to False, the excluded data points will not be assigned to a partition.",
			Default->False,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Methodology"
		},
		{
			OptionName->ClusteredDimensions,
			Description->"Specifies which data columns are used to perform automated clustering when Method is set to Automatic.",
			ResolutionDescription->"If set to Automatic, all dimensions of the input data will be used.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Indexed Dimensions"->Adder[Widget[Type->Number,Pattern:>GreaterEqualP[1,1],PatternTooltip->"A positive integer."]]
			],
			Category->"Methodology"
		},
		{
			OptionName->DistanceFunction,
			Description->"The method used to quantify the similarity between a pair of data points. Possible settings are ManhattanDistance, EuclideanDistance, SquaredEuclideanDistance, NormalizedSquaredEuclideanDistance, CosineDistance, CorrelationDistance, or any pure function that returns a numeric value when given one data point each as its first and second input argument.",
			Default->EuclideanDistance,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>DistanceFunctionP],
				"Custom"->Widget[Type->Expression,Pattern:>_Function,Size->Line,PatternTooltip->"A pure function that returns a numeric value when given one data point each as its first and second input argument."]
			],
			Category->"Methodology"
		},
		{
			OptionName->PerformanceGoal,
			Description->"Specifies whether to prioritize the speed or quality of clustering when selecting an appropriate clustering algorithm.",
			Default->Speed,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Quality|Speed],
			Category->"Methodology"
		},
		{
			OptionName->CriterionFunction,
			Description->"Specifies the evaluation metric used to determine the most appropriate clustering algorithm.",
			Default->Silhouette,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>ClusterCriterionFunctionP],
			Category->"Methodology"
		},
		{
			OptionName->DimensionLabels,
			Description->"Specifies the name of the property described by each column of the input data.",
			Default->None,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				"Labels"->Adder[Alternatives[
					"String"->Widget[Type->String,Pattern:>_String,Size->Word],
					"Symbol"->Widget[Type->Expression,Pattern:>_Symbol,Size->Word]
				]]
			],
			Category->"Data Annotation"
		},
		{
			OptionName->DimensionUnits,
			Description->"Specifies the units attached to each column of the input data.",
			ResolutionDescription->"If set to Automatic, units will be inferred from the input data. If set to units that differ from the input data, the input data will be converted to match the specified units.",
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,None]],
				Adder[Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]]
			],
			Category->"Data Annotation"
		},
		{
			OptionName->ClusterLabels,
			Description->"Specifies a set of names used to identify the groups of partitioned data points.",
			ResolutionDescription->"If set to Automatic, the groups will be named using sequential integers beginning with 1.",
			Default->Automatic,
			AllowNull->False,
			Widget->Adder[Alternatives[
				"String"->Widget[Type->String,Pattern:>_String,Size->Word],
				"Integer"->Widget[Type->Number,Pattern:>GreaterEqualP[0,1]]
			]],
			Category->"Data Annotation"
		},
		{
			OptionName->ClusterAssignments,
			Default->Automatic,
			Description->"Putative identity model associated with each cluster.",
			ResolutionDescription->"Automatic defaults to a list of Null with length equal to the number of clusters.",
			AllowNull->False,
			Widget->Adder[Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Model[]]],
				Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
			]],
			Category->"Data Annotation"
		},

		(* Suboptions for automated clustering algorithms *)
		{
			OptionName->CovarianceType,
			Description->"Specifies the form of the covariance matrix for each mixture component when ClusteringAlgorithm is set to GaussianMixture. May be either Diagonal, Full, FullShared, or Spherical.",
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Automatic|CovarianceTypeP],
			Category->"Methodology"
		},
		{
			OptionName->MaxIterations,
			Description->"Specifies the maximum number of expectation maximization iterations when ClusteringAlgorithm is set to GaussianMixture.",
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Number,Min->1,Pattern:>GreaterP[1]],
			Category->"Methodology"
		},
		{
			OptionName->NeighborhoodRadius,
			Description->"Specifies the maximum separation distance at which adjacent data points are considered neighbors when ClusteringAlgorithm is set to MeanShift, DBSCAN, or Spectral.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Min->0,Pattern:>GreaterP[0]]
			],
			Category->"Methodology"
		},
		{
			OptionName->NeighborsNumber,
			Description->"Specifies the minimum number of neighbors required for a given data point to be considered a core node when ClusteringAlgorithm is set to DBSCAN.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Min->1,Pattern:>GreaterP[1]]
			],
			Category->"Methodology"
		},
		{
			OptionName->ClusterDissimilarityFunction,
			Description->"Specifies the function used to evaluate the pairwise separation distance between partitions when ClusteringAlgorithm is set to Spectral or SPADE. May be either Single, Complete, Average, Centroid, Median, Ward, WeightedAverage, or a pure function.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Automatic|ClusterDissimilarityFunctionP],
				Widget[Type->Expression,Pattern:>_Function,Size->Line]
			],
			Category->"Methodology"
		},
		{
			OptionName->MaxEdgeLength,
			Description->"Specifies the maximum distance at which adjacent data points are considered neighbors when ClusteringAlgorithm is set to SpanningTree.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Min->0,Pattern:>GreaterP[0]]
			],
			Category->"Methodology"
		},
		{
			OptionName->DensityResamplingThreshold,
			Description->"Multiplies the median minimum distance between each data point and its nearest neighbor to determine the radius used for density-dependent downsampling when ClusteringAlgorithm is set to SPADE.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Min->0,Pattern:>GreaterP[0]]
			],
			Category->"Methodology"
		},
		{
			OptionName->OutlierDensityQuantile,
			Description->"Specifies the quantile of local densities used to set the outlier density during density-dependent downsampling when ClusteringAlgorithm is set to SPADE.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Min->0,Pattern:>RangeP[0,1]]
			],
			Category->"Methodology"
		},
		{
			OptionName->TargetDensityQuantile,
			Description->"Specifies the quantile of local densities used to set the target density during density-dependent downsampling when ClusteringAlgorithm is set to SPADE.",
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Min->0,Pattern:>RangeP[0,1]]
			],
			Category->"Methodology"
		},
		OutputOption,
		UploadOption
	}

];


(* ::Subsection::Closed:: *)
(*Messages*)


AnalyzeClusters::Invalid1DGateDefinition="The specified 1D gate `1` is invalid. Please check that the specified gate dimension is valid. This gate definition will be ignored throughout the remaining analysis.";
AnalyzeClusters::Invalid2DGateDefinition="The specified 2D polygonal gate `1` is invalid. Please check that all specified gate dimensions are valid, and that the specified polygon contains at least three non-collinear points lying in a 2D plane. This gate definition will be ignored throughout the remaining analysis.";
AnalyzeClusters::Invalid3DGateDefinition="The specified 3D gate `1` is invalid. Please check that all specified gate dimensions are valid, and that the specified ellipsoid is defined in 3D. This gate definition will be ignored throughout the remaining analysis.";
AnalyzeClusters::InvalidDomainFunctionDefinition="The specified domain constraint `1` is invalid because it does not return a boolean value when given a single data point as input. Please check that the function accepts single points as input and only returns True or False. This domain constraint will be ignored throughout the remaining analysis.";
AnalyzeClusters::ScaleDimensionMismatch="The specified Scale (`1`) does not match the number of columns present in the data (`2`). Please check that the Scale is correctly specified, or consider specifying a single value to be applied to all dimensions of the data. Defaulting the value of Scale to Linear.";
AnalyzeClusters::InvalidClusteredDimensions="The specified value of ClusteredDimensions (`1`) contains dimensions that are inconsistent with the shape of the input data. Please check that the dimensionality of ClusteredDimensions is correct. All dimensions of the data will be used throughout the remaining analysis.";
AnalyzeClusters::DimensionLabelsLengthMismatch="The specified number of dimension labels (`1`) does not match the number of dimensions in the input data (`2`). Please ensure that the number of labels matches the dimensionality of the input data. Defaulting DimensionLabels to None.";
AnalyzeClusters::DimensionUnitsLengthMismatch="The specified DimensionUnits `1` do not match the number of columns in the input data (`2`). Please check that the DimensionUnits are correctly specified. Any units present in the input data will be used for all remaining analysis. If the input data do not contain units, DimensionUnits will be set to None.";
AnalyzeClusters::ClusterAssignmentsLengthMismatch="The specified number of cluster assignments (`1`) does not match the number of partitions generated for the input data (`2`). Please ensure that the number of assignments matches the expected number of partitions. The provided ClusterAssignments will either be truncated or padded with Null to match the number of detected partitions.";
AnalyzeClusters::ClusterLabelsLengthMismatch="The specified number of cluster labels (`1`) does not match the number of partitions generated for the input data (`2`). Please ensure that the number of labels matches the expected number of partitions. The provided ClusterLabels will either be truncated or padded with sequential integers to match the number of detected partitions.";
AnalyzeClusters::EmptyManualGates="None of the input data lie within the specified ManualGates. Please specify one or more lists of gates defining each partition.";
AnalyzeClusters::InvalidLogTransformation="Applying the specified Scale (`1`) would result in the log-transformation of negative values. Please check that the choice of Scale is well suited to the input data. Defaulting Scale to Linear for any dimensions of the data that contain negative values.";
AnalyzeClusters::RedundantDomain="Method is set to Manual but one or more domain constraints were also specified. Please either set Method to Automatic or remove the specified Domain. The specified Domain will be ignored in all subsequent analyses.";
AnalyzeClusters::NumberOfClustersNotSupported="The Method `1` does not support specifying NumberOfClusters. Please consider setting NumberOfClusters to Automatic so that the number of clusters may be inferred from the input data. If a specific number of clusters is required, you might also consider specifying an alternate Method. Defaulting NumberOfClusters to Automatic.";
AnalyzeClusters::NumberOfClustersRequired="The Method `1` requires that NumberOfClusters also be specified. Please specify NumberOfClusters. If the expected number of clusters is unknown you might also consider specifying an alternate Method. The NumberOfClusters will be estimated using the Spectral clustering algorithm.";
AnalyzeClusters::NumberOfClustersExceedsDataSize="The specified NumberOfClusters (`1`) exceeds the number of points in the input data (`2`). Please consider specifying a lower value for NumberOfClusters. Defaulting NumberOfClusters to Automatic.";
AnalyzeClusters::GatesOverlap="The specified ManualGates assign at least one point to multiple distinct partitions. Please ensure that the ManualGates definition assigns each point to at most one partition. Defaulting each point to the first viable partition.";

(* Errors *)
AnalyzeClusters::NoIncludedData="The specified gates (`1`) exclude all points in the input data. Please check that the gates are correctly specified, and consider specifying less restrictive gates.";


(* ::Subsection::Closed:: *)
(*AnalyzeClusters*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeClusters Main Function*)


(* Main AnalyzeClusters entry point is for a single set of raw numeric points *)
AnalyzeClusters[tabularData:{{_?NumericQ..}..},ops:OptionsPattern[AnalyzeClusters]]:=Module[
	{safeOps,output,listedOutput,rawResult,result,options,preview},

	(* Gather safe options, setting Method->Manual if ManualGates was specified but Method was not *)
	safeOps=With[
		{inputOps=ToList[ops]},
		SafeOptions[
			AnalyzeClusters,
			If[
				!MemberQ[Keys@inputOps,Method]&&MemberQ[Keys@inputOps,ManualGates],
				Prepend[inputOps,Method->Manual],
				inputOps
			]
		]
	];

	(* Get output *)
	output=Lookup[safeOps,Output];
	listedOutput=ToList[output];

	(* Pass inputs + options to core function, only requesting Preview if it's needed *)
	Quiet[
		Check[
			{rawResult,options,preview}=If[
				MatchQ[output,Preview]||MemberQ[output,Preview],
				analyzeClusters[N@tabularData,ToList[ops],ReplaceRule[safeOps,{Output->{Result,Options,Preview},Upload->False}]],
				Append[analyzeClusters[N@tabularData,ToList[ops],ReplaceRule[safeOps,{Output->{Result,Options},Upload->False}]],None]
			];,
			Return[$Failed],
			{Error::InvalidOption}
		],
		{Append::normal,Set::shape}
	];

	(* Determine if we should upload *)
	result=If[Lookup[safeOps,Upload]&&MemberQ[listedOutput,Result],
		Upload[rawResult],
		rawResult
	];

	(* Return requested result *)
	output/.{
		Result->result,
		Options->options,
		Preview->AdjustForCCD[preview, AnalyzeClusters],
		Tests->{}
	}
];

(* Overload for 1D data *)
AnalyzeClusters[listedData:{_?NumericQ..}|{_?QuantityQ..},ops:OptionsPattern[AnalyzeClusters]]:=AnalyzeClusters[List/@listedData,ops];

(* Overload for lists of quantities and quantity arrays by stripping units from input data and passing them through via the DimensionUnits option *)
AnalyzeClusters[tabularData:{{_?QuantityQ..}..}|_?tabularDataQuantityArrayQ,ops:OptionsPattern[AnalyzeClusters]]:=Module[
	{safeOps,rawTabularData,dimensionUnits,resolvedDimensionUnits},

	safeOps=SafeOptions[AnalyzeClusters,ToList@ops];

	(* Resolve DimensionUnits *)
	dimensionUnits=Lookup[safeOps,DimensionUnits];
	resolvedDimensionUnits=Switch[
		dimensionUnits,

		(* If the specified DimensionUnits are of the wrong length, throw a warning and use the units present in the data *)
		_List,
		If[
			Length@dimensionUnits!=Length@First@tabularData,
			Message[AnalyzeClusters::DimensionUnitsLengthMismatch,dimensionUnits,Length@First@tabularData];First@Units@tabularData,
			dimensionUnits
		],

		(* Resolve Automatic to the units present in the data *)
		Automatic,First@Units@tabularData,

		(* Anything else is set to None *)
		_,None

	];

	(* If DimensionUnits is None, strip the units from the input data *)
	rawTabularData=If[
		MatchQ[resolvedDimensionUnits,None],
		QuantityMagnitude@tabularData,

		(* Otherwise, convert the input data to the specified DimensionUnits before stripping the units *)
		QuantityMagnitude@Transpose@MapThread[Convert,{Transpose@tabularData,resolvedDimensionUnits}]
	];

	(* Call the main overload, passing through DimensionUnits *)
	AnalyzeClusters[rawTabularData,Sequence@@ReplaceRule[ToList[ops],{DimensionUnits->resolvedDimensionUnits}]]

];

(* Add an overload that strips any string/symbol column headers from the first row and passes them through via the DimensionLabels option *)
AnalyzeClusters[tabularData:{{(_String|_Symbol)..},{UnitsP[]..}..}/;CountDistinct[Length/@tabularData]==1,ops:OptionsPattern[AnalyzeClusters]]:=Module[
	{safeOps},
	safeOps=SafeOptions[AnalyzeClusters,ToList@ops];
	AnalyzeClusters[Rest@tabularData,Sequence@@ReplaceRule[ToList[ops],{DimensionLabels->First@tabularData}]]
];


(* ::Subsubsection::Closed:: *)
(*AnalyzeClusters Overloads for data object input*)


(* Define general overload that takes a supported data object as input, extracts the relevant point data, and passes it to the main AnalyzeClusters function *)
AnalyzeClusters[myObject:ObjectP[Object[Data]],ops:OptionsPattern[AnalyzeClusters]]:=Module[
	{originalOps,safeOps,output,listedOutput,pointData,resolvedInputOps,clusterDataPacket,finalClusterDataPacket,clusterDataOutput,resolvedOps},

	(* Defaulted options *)
	safeOps=SafeOptions[AnalyzeClusters,ToList@ops];
	originalOps=ToList[ops];

	(* Requested output *)
	output=Lookup[safeOps,Output];
	listedOutput=ToList[output];

	(* Extract point data and resolved option values from input data object  *)
	{pointData,resolvedInputOps}=resolveAnalyzeClustersObjectInputs[myObject,originalOps];

	(* Call core function to get cluster data *)
	{clusterDataPacket,resolvedOps}=AnalyzeClusters[pointData,Sequence@@ReplaceRule[resolvedInputOps,{Output->{Result,Options},Upload->False}]];

	(* PLACEHOLDER: Augment packet with any input object specific fields *)
	finalClusterDataPacket=clusterDataPacket;

	(* Either upload the augmented packet or return it as is *)
	clusterDataOutput=If[Lookup[safeOps,Upload]&&MemberQ[output,Result],
		Upload[finalClusterDataPacket],
		finalClusterDataPacket
	];

	(* Return requested result *)
	output/.{
		Result->clusterDataOutput,
		Preview->clusterDataOutput,
		Options->resolvedOps,
		Tests->{}
	}
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeClustersObjectInputs*)


(* Define private resolver for data object inputs *)
resolveAnalyzeClustersObjectInputs[dataObject_,optionsList_]:=Module[
	{tabularData,resolvedOps},

	(* Return tabular data and resolved options *)
	{tabularData,resolvedOps}
];


(* ::Subsection::Closed:: *)
(*Resolution*)


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeClustersOptions*)


resolveAnalyzeClustersOptions[tabularData_,ops_]:=Module[
	{resolvedOps,method,resolvedDomain,examplePoint,numberOfDimensions,scale,resolvedScale,domainFunctions,domainGates,manualGates,numberOfClusters,resolvedNumberOfClusters,resolvedPerformanceGoal,clusteringAlgorithm,resolvedClusteringAlgorithm,resolvedCriterionFunction,
	clusteredDimensions,resolvedClusteredDimensions,dimensionUnits,resolvedDimensionUnits,dimensionLabels,resolvedDimensionLabels,checkGates},

	(* Determine dimensionality of data *)
	examplePoint=First@tabularData;
	numberOfDimensions=Length@examplePoint;

	(* Extract specified method and number of clusters *)
	method=Lookup[ops,Method];
	clusteringAlgorithm=Lookup[ops,ClusteringAlgorithm];
	numberOfClusters=Lookup[ops,NumberOfClusters];

	(* If NumberOfClusters exceeds the size of the input data, throw a warning and use spectral clustering to estimate the number of clusters *)
	numberOfClusters=If[
		MatchQ[numberOfClusters,_Integer]&&numberOfClusters>Length@tabularData,
		Message[AnalyzeClusters::NumberOfClustersExceedsDataSize,numberOfClusters,Length@tabularData];Automatic,
		numberOfClusters
	];

	(* Ensure that any values to be log-transformed are non-negative *)
	scale=With[
		{s=Lookup[ops,Scale]},
		Switch[
			s,
			_Symbol,
			Table[s,{numberOfDimensions}],
			_List,

			(* If the dimensionality of the specified Scale doesn't match the input data, issue a warning and default to linear *)
			If[
				Length@s!=numberOfDimensions,
				Message[AnalyzeClusters::ScaleDimensionMismatch,s,numberOfDimensions];Table[Linear,{numberOfDimensions}],
				s
			]
		]
	];

	resolvedScale=MapThread[
		If[
			MatchQ[#2,Log],
			If[Min[#1]<=0,Message[AnalyzeClusters::InvalidLogTransformation,Lookup[ops,Scale]];Linear,#2],
			#2
		]&,
		{Transpose@tabularData,scale}
	];

	(* If Method is set to Manual but the Domain is specified, issue a warning and remove the domain constraints *)
	resolvedDomain=With[
		{domain=Replace[Lookup[ops,Domain],Automatic->{}]},
		If[
			MatchQ[method,Manual]&&Length[domain]>0,
			Message[AnalyzeClusters::RedundantDomain];{},
			domain
		]
	];

	(* Check that all pure functions used to specify the Domain return a boolean. Throw a warning and ignore any functions that do not  *)
	domainFunctions=If[
		!validDomainFunctionQ[#,examplePoint],
		Message[AnalyzeClusters::InvalidDomainFunctionDefinition,#];Null,
		#
	]&/@Cases[resolvedDomain,_Function];

	(* Define helper function that takes a list of gate definitions and throws a warning and discards any that are invalid *)
	checkGates=Function[
		{gates},
		Select[
			Join[

				(* Check 1D gates *)
				If[
					!valid1DGateQ[#,numberOfDimensions],
					Message[AnalyzeClusters::Invalid1DGateDefinition,#];Null,
					#
				]&/@Cases[gates,{_,_,_}],

				(* Check 2D gates *)
				If[
					!valid2DGateQ[#,numberOfDimensions],
					Message[AnalyzeClusters::Invalid2DGateDefinition,#];Null,
					#
				]&/@Cases[gates,{_,_,_,_}],

				(* Check 3D gates *)
				If[
					!valid3DGateQ[#,numberOfDimensions],
					Message[AnalyzeClusters::Invalid3DGateDefinition,#];Null,
					#
				]&/@Cases[gates,{_,_,_,_,_}]
			],
			!NullQ[#]&
		]
	];

	(* Check that all gates used to specify the Domain are valid. Throw a warning and ignore any that are not *)
	domainGates=checkGates[Cases[resolvedDomain,_List]];

	(* Resolve clustered dimensions - default to using all dimensions if none were specified, and ignore this option for manual clustering methods *)
	clusteredDimensions=Replace[Lookup[ops,ClusteredDimensions],Automatic->Range[numberOfDimensions]];
	resolvedClusteredDimensions=If[
		!SubsetQ[Range[numberOfDimensions],clusteredDimensions],
		Message[AnalyzeClusters::InvalidClusteredDimensions,clusteredDimensions];Range[numberOfDimensions],
		clusteredDimensions
	];

	(* Resolve DimensionUnits *)
	dimensionUnits=Lookup[ops,DimensionUnits];
	resolvedDimensionUnits=Switch[
		dimensionUnits,

		(* If Automatic or None, set them to ones because by this point any units would have already been inherited from the data *)
		None,Table[1,{numberOfDimensions}],
		Automatic,Table[1,{numberOfDimensions}],

		(* If DimensionUnits were specified but of the wrong length, throw a warning and default to ones *)
		_List,If[
			Length@dimensionUnits!=numberOfDimensions,
			Message[AnalyzeClusters::DimensionUnitsLengthMismatch,dimensionUnits,numberOfDimensions];Table[1,{numberOfDimensions}],
			dimensionUnits
		]
	];

	(* Resolve DimensionLabels - throw a warning if they don't match the number of dimensions in the input data *)
	dimensionLabels=Lookup[ops,DimensionLabels];
	resolvedDimensionLabels=If[
		MatchQ[dimensionLabels,None],dimensionLabels,
		If[
			!Length@dimensionLabels==numberOfDimensions,
			Message[AnalyzeClusters::DimensionLabelsLengthMismatch,Length@dimensionLabels,numberOfDimensions];None,
			dimensionLabels
		]
	];

	(* Resolve PerformanceGoal and CriterionFunction - if a clustering algorithm was specified, set both to Null so they are hidden in command builder *)
	resolvedPerformanceGoal=If[MatchQ[Lookup[ops,ClusteringAlgorithm],Automatic],Lookup[ops,PerformanceGoal],Null];
	resolvedCriterionFunction=If[MatchQ[Lookup[ops,ClusteringAlgorithm],Automatic],Lookup[ops,CriterionFunction],Null];

	(* Resolve NumberOfClusters - issuing warnings if NumberOfClusters is incorrectly specified given the choice of ClusteringAlgorithm *)
	resolvedNumberOfClusters=Which[

		(* If the method is Manual, set NumberOfClusters to Automatic *)
		MatchQ[method,Manual],Automatic,

		(* NumberOfClusters is specified when it shouldn't be (anything other than Agglomerate,GaussianMixture,KMeans,KMedoids,SPADE,SpanningTree,Spectral) *)
		(!MatchQ[numberOfClusters,Automatic])&&(!MemberQ[{Automatic,Agglomerate,GaussianMixture,KMeans,KMedoids,SPADE,SpanningTree,Spectral},clusteringAlgorithm]),
		Message[AnalyzeClusters::NumberOfClustersNotSupported,clusteringAlgorithm];Automatic,

		(* NumberOfClusters is not specified when it should be - throw a warning and use spectral clustering to estimate the number of clusters *)
		(MatchQ[numberOfClusters,Automatic])&&(MemberQ[{KMeans,KMedoids},clusteringAlgorithm]),
		Message[AnalyzeClusters::NumberOfClustersRequired,clusteringAlgorithm];Length@FindClusters[tabularData,Method->"Spectral"],

		(* Otherwise if all is well return the specified value *)
		True,numberOfClusters
	];

	(* Resolve ClusteringAlgorithm if Method is set to Automatic *)
	resolvedClusteringAlgorithm=If[
		MatchQ[method,Automatic],
		Replace[
			clusteringAlgorithm,
			Automatic:>resolveClusteringAlgorithm[tabularData,resolvedNumberOfClusters,resolvedCriterionFunction,resolvedPerformanceGoal]
		],
		Automatic
	];

	(* If Method is Manual, make sure all specified gates are valid and resolve Automatic to an empty list *)
	manualGates=If[
		MatchQ[method,Manual],
		checkGates/@Replace[Lookup[ops,ManualGates],Automatic->{{}}],

		(* Otherwise return Null so ManualGates is hidden in the command builder *)
		Null
	];

	(* Compile resolved options *)
	resolvedOps=ReplaceRule[
		ops,
		{
			Scale->resolvedScale,
			Method->method,
			ClusteringAlgorithm->resolvedClusteringAlgorithm,
			NumberOfClusters->resolvedNumberOfClusters,
			Domain->Join[domainFunctions,domainGates],
			ClusteredDimensions->resolvedClusteredDimensions,
			ManualGates->manualGates,
			DimensionUnits->resolvedDimensionUnits,
			DimensionLabels->resolvedDimensionLabels,
			PerformanceGoal->resolvedPerformanceGoal,
			CriterionFunction->resolvedCriterionFunction,

			(* Default suboptions for clustering algorithms *)
			CovarianceType->Replace[Lookup[ops,CovarianceType],Automatic->Full],
			MaxIterations->Replace[Lookup[ops,MaxIterations],Automatic->250],
			ClusterDissimilarityFunction->Replace[Lookup[ops,ClusterDissimilarityFunction],Automatic->Ward],
			DensityResamplingThreshold->Replace[Lookup[ops,DensityResamplingThreshold],Automatic->5.0],
			OutlierDensityQuantile->Replace[Lookup[ops,OutlierDensityQuantile],Automatic->0.01],
			TargetDensityQuantile->Replace[Lookup[ops,TargetDensityQuantile],Automatic->0.03]
		}
	];

	(* Depending on specified Method, set unused options to Null *)
	ReplaceRule[
		resolvedOps,
		Switch[
			method,
			Manual,Rule[#,Null]&/@{ClusteringAlgorithm,Domain,ClusterDomainOutliers,NumberOfClusters,PerformanceGoal,CriterionFunction,CovarianceType,MaxIterations,NeighborhoodRadius,NeighborsNumber,ClusterDissimilarityFunction,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
			Automatic,
			Switch[
				resolvedClusteringAlgorithm,
				KMeans,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborhoodRadius,NeighborsNumber,ClusterDissimilarityFunction,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				Spectral,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborsNumber,ClusterDissimilarityFunction,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				DBSCAN,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,ClusterDissimilarityFunction,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				SPADE,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborhoodRadius,NeighborsNumber,MaxEdgeLength},
				Agglomerate,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborhoodRadius,NeighborsNumber,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				MeanShift,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborsNumber,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				GaussianMixture,Rule[#,Null]&/@{ManualGates,NeighborhoodRadius,NeighborsNumber,ClusterDissimilarityFunction,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				JarvisPatrick,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborsNumber,ClusterDissimilarityFunction,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				SpanningTree,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborhoodRadius,NeighborsNumber,ClusterDissimilarityFunction,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile},
				_,Rule[#,Null]&/@{ManualGates,CovarianceType,MaxIterations,NeighborhoodRadius,NeighborsNumber,ClusterDissimilarityFunction,MaxEdgeLength,DensityResamplingThreshold,OutlierDensityQuantile,TargetDensityQuantile}
			]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveClusteringAlgorithm*)


(* Define helper function that selects a clustering algorithm *)
resolveClusteringAlgorithm[data_,numberOfClusters_,criterionFunction_,performanceGoal_]:=Module[
	{},

	(* We have to do some error handling to catch a bug in MM's built-in clustering code *)
	Quiet[
		Check[
			Module[
				{tracedMethods},

				(* Trace which methods were tried by the built-in option resolver *)
				tracedMethods=Trace[
					FindClusters[
						data,numberOfClusters,
						Method->Automatic,
						CriterionFunction->ToString@criterionFunction,
						PerformanceGoal->ToString@performanceGoal
					],
					HoldPattern[Rule["Method",_]],
					TraceInternal->True
				];

				(* Return the selected method *)
				First@Cases[Symbol[Last[#]]&/@(ReleaseHold@DeleteDuplicates[Flatten@tracedMethods]),ClusteringAlgorithmP]

			],

			(* If MM's built in function messes up, default to our own heuristics *)
			Module[
				{},
				If[
					(* If the number of clusters was specified, use k-means for speed and spectral for quality *)
					!MatchQ[numberOfClusters,Automatic],
					If[MatchQ[performanceGoal,Speed],KMeans,Spectral],

					(* If the number of clusters is yet to be determined, use DBSCAN *)
					DBSCAN
				]
			]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveClusterLabels*)


(* Define helper function that takes the raw clustered data and any user-supplied cluster labels, and returns a resolved list of labels *)
resolveClusterLabels[clusters_,inputLabels_]:=Module[
	{labels,resolvedLabels},

	(* Resolve Automatic to a list of sequential integers *)
	labels=Replace[inputLabels,Automatic->((ToString@StringForm["Group `1`",#])&/@Range[Length@clusters])];

	(* Check that the number of labels matches the number of identified clusters *)
	resolvedLabels=Which[

		(* If too few labels, throw a warning and pad them with integer values *)
		Length@labels<Length@clusters,
		Message[AnalyzeClusters::ClusterLabelsLengthMismatch,Length@labels,Length@clusters];
		Join[labels,(ToString@StringForm["Group `1`",#])&/@Range[1+Length@labels,Length@clusters]],

		(* If too many labels, throw a warning and truncate them *)
		Length@labels>Length@clusters,
		Message[AnalyzeClusters::ClusterLabelsLengthMismatch,Length@labels,Length@clusters];
		labels[[;;Length@clusters]],

		(* Otherwise, return labels as is *)
		True,labels
	];

	(* Return resolved labels *)
	resolvedLabels
];


(* ::Subsubsection::Closed:: *)
(*resolveClusterAssignments*)


(* Take raw clustered data and user-supplied cluster assignments, and return a padded, resolved list of labels *)
resolveClusterAssignments[clusters_,clusterAssignments_]:=Module[
	{numClusters,assignments,resolvedAssignments},

	(* Number of clusters identified *)
	numClusters=Length[clusters];

	(* Automatic resolves to a list of Null *)
	assignments=clusterAssignments/.{
		Automatic->Repeat[Null,numClusters]
	};

	(* Check that the numbre of assignments matches the number of identified clusters *)
	resolvedAssignments=If[Length[assignments]!=numClusters,
		(* If the number of clusters does not match, then pad with Null or truncate *)
		Message[AnalyzeClusters::ClusterAssignmentsLengthMismatch,Length[assignments],numClusters];
		PadRight[assignments,numClusters,Null],
		(* If lengths match then we good *)
		assignments
	];

	(* Return the resolved assignments *)
	resolvedAssignments
];


(* ::Subsubsection::Closed:: *)
(*validDomainFunctionQ*)


validDomainFunctionQ[constraint_Function,examplePoint_]:=MatchQ[constraint[examplePoint],BooleanP];


(* ::Subsubsection::Closed:: *)
(*valid1DGateQ*)


valid1DGateQ[gate_,numberOfDimensions_]:=Module[
	{validDimension},
	validDimension=MemberQ[Range[numberOfDimensions],gate[[1]]];
	validDimension
];


(* ::Subsubsection::Closed:: *)
(*valid2DGateQ*)


(* Define helper function that takes a polygonal gate definition and returns True if its dimensions are valid and its polygon contains at least 3 non-collinear points *)
valid2DGateQ[gate_,numberOfDimensions_]:=Module[
	{validDimensions, validPolygon},
	validDimensions=SubsetQ[Range[numberOfDimensions],gate[[1;;2]]];
	validPolygon=valid2DPolygonQ[gate[[3]]];
	And[validDimensions,validPolygon]
];

(* Define helper function that takes a 2D polygon and returns True if it contains at least 3 non-collinear points *)
valid2DPolygonQ[polygon_]:=False;
valid2DPolygonQ[polygon_Polygon]:=Module[
	{points},
	points=First[polygon];
	(Length[points]>=3)&&MatchQ[points,{{_?NumericQ,_?NumericQ}..}]&&!collinearQ[points]
];

(* Define helper function that takes a list of 2D coordinates and returns True if they are collinear *)
collinearQ[list:{{_?NumericQ,_?NumericQ}..}]:=Quiet@Module[
	{firstP, secondP, kk, bb},
	{firstP, secondP} = list[[{1, 2}]];
	kk = (firstP[[2]] - secondP[[2]]) / (firstP[[1]] - secondP[[1]]);
	bb = firstP[[2]] - kk * firstP[[1]];
	AllTrue[list[[3;;]], MatchQ[kk * #[[1]] + bb - #[[2]], 0] &]
];


(* ::Subsubsection::Closed:: *)
(*valid3DGateQ*)


(* Define helper function that takes a 3D gate definition and returns True if its dimensions and region are valid *)
valid3DGateQ[gate_,numberOfDimensions_]:=Module[
	{validDimensions,validRegion},
	validDimensions=SubsetQ[Range[numberOfDimensions],gate[[1;;3]]];
	validRegion=valid3DPolygonQ[gate[[4]]]||valid3DEllipsoidQ[gate[[4]]];
	And[validDimensions,validRegion]
];

(* Define helper function that returns True when given a valid 3D ellipsoid as input *)
valid3DEllipsoidQ[ellipsoid_]:=False;
valid3DEllipsoidQ[ellipsoid_Ellipsoid]:=(Length[First[ellipsoid]]==3)&&RegionQ[ellipsoid];

(* Define helper function that returns True when given a 3D polygon containing 4 non-coplanar points as input *)
valid3DPolygonQ[polygon_]:=False;
valid3DPolygonQ[polygon_Polygon]:=Module[
	{points},
	points=First[polygon];
	(Length[points]>=4)&&MatchQ[points,{{_?NumericQ,_?NumericQ,_?NumericQ}..}]&&!coplanarQ[points]
];

(* Define helper function that takes a list of 3D coordinates and returns True if they are coplanar *)
coplanarQ[points_]:=Module[
	{A,B,C,plane},
	{A,B,C}=Part[points,Range[3]];
	plane=Cross[A-B,A-C];
	And@@(Dot[plane,#]==0&/@points[[4;;]])
];


(* ::Subsection::Closed:: *)
(*Data Preprocessing*)


(* ::Subsubsection::Closed:: *)
(*preprocessData*)


preprocessData[tabularData_,scale_,normalize_]:=Module[
	{scalingFunction,scaledData,normalizedData},

	(* Define pure function for applying scaling transforms *)
	scalingFunction=Function[{transform,x},Switch[transform,Linear,x,Log,Log10[x],Reciprocal,1/x]];

	(* Apply any scaling transformations *)
	scaledData=Switch[
		scale,

		(* If standalone Linear, return original data *)
		Linear,tabularData,

		(* If standalone Log or Reciprocal, apply the appropriate scaling *)
		Log|Reciprocal,N@scalingFunction[scale,tabularData],

		(* If a list of transformations... *)
		{(Linear|Log|Reciprocal)..},

		(* First make sure that the list matches the dimensionality of the data, throwing a warning and returning unscaled data if it doesn't. *)
		If[
			Length@scale!=Length@First@tabularData,
			Message[AnalyzeClusters::ScaleDimensionMismatch,scale,Length@First@tabularData];tabularData,

			(* If it does match, apply the respective transform to each dimension *)
			N@Transpose@MapThread[scalingFunction,{scale,Transpose@tabularData}]
		]

	];

	(* If Normalize is True, normalize each dimension to a [0-1] interval *)
	normalizedData=If[
		TrueQ@normalize,
		N@Transpose@MapThread[Rescale[{##}]&,scaledData],
		scaledData
	];

	(* Return the preprocessed data *)
	normalizedData

];


(* ::Subsection::Closed:: *)
(*Core Function*)


(* ::Subsubsection::Closed:: *)
(*pointsSelectedQ*)


(* Helper function takes a list of points and a list of constraints and returns a boolean mask indicating whether each point is selected by all gates and functions *)
pointsSelectedQ=Function[
	{pts,constraints},
	MapThread[
		And,
		Join[

			(* Add a list of True values so no constraints defaults to all points being selected *)
			{Table[True,{Length[pts]}]},

			(* Check 1D gates *)
			Map[Function[value,LessEqual[value,Part[#,2]]],Part[pts,All,Part[#,1]]]&/@Cases[constraints,{_,_,Below}],
			Map[Function[value,Greater[value,Part[#,2]]],Part[pts,All,Part[#,1]]]&/@Cases[constraints,{_,_,Above}],

			(* Check 2D gates *)
			RegionMember[Part[#,3],Part[pts,All,Part[#,{1,2}]]]&/@Cases[constraints,{_,_,_,Include}],
			(Not/@RegionMember[Part[#,3],Part[pts,All,Part[#,{1,2}]]])&/@Cases[constraints,{_,_,_,Exclude}],

			(* Check 3D polygonal gates treating polygon definitions as convex hull *)
			RegionMember[ConvexHullMesh@@Part[#,4],Part[pts,All,Part[#,{1,2,3}]]]&/@Cases[constraints,{_,_,_,_Polygon,Include}],
			(Not/@RegionMember[ConvexHullMesh@@Part[#,4],Part[pts,All,Part[#,{1,2,3}]]])&/@Cases[constraints,{_,_,_,_Polygon,Exclude}],

			(* Check 3D ellipsoidal gates *)
			RegionMember[Part[#,4],Part[pts,All,Part[#,{1,2,3}]]]&/@Cases[constraints,{_,_,_,_Ellipsoid,Include}],
			(Not/@RegionMember[Part[#,4],Part[pts,All,Part[#,{1,2,3}]]])&/@Cases[constraints,{_,_,_,_Ellipsoid,Exclude}],

			(* Check pure function constraints *)
			Map[#1,pts]&/@Cases[constraints,_Function]

		]
	]
];


(* ::Subsubsection::Closed:: *)
(*clusterUsingGMM*)


(* Define a helper function that takes input data and returns the index and posterior probability of the GMM component to which each point in the input data belongs *)
clusterUsingGMM[data_,numberOfClusters_:Automatic,covarianceType_:Full,maxIterations_:250,timeGoal_:10]:=Module[
	{distribution,model,mu,sigma,means,covariances,weights,components,posteriors},

	(* Fit GMM with full covariance matrix *)
	distribution=LearnDistribution[
		data,
		Method->{
			"GaussianMixture",
			"ComponentsNumber"->numberOfClusters,
			"CovarianceType"->ToString[covarianceType],
			MaxIterations->maxIterations
		},
		FeatureExtractor->"StandardizedVector",
		TrainingProgressReporting->None
	];

	(* Extract the model *)
	model=Lookup[First@distribution,"Model"];

	(* Unstandardize the fitted model parameters (they are z-scored) *)
	mu=Mean[data];
	sigma=StandardDeviation[data];
	means=mu+(sigma*#)&/@model["Means"];
	covariances=With[{rescaling=Transpose[{sigma}].{sigma}}, rescaling*(Transpose[#].#)&/@model["CholeskyCovariances"]];

	(* Assemble mixture components and weights *)
	components=MapThread[MultinormalDistribution[#1,#2]&,{means,covariances}];
	weights=model["MixingCoefficients"];

	(* Evaluate the posterior probability that each point belongs to each component *)
	posteriors=With[
		{posterior=MapThread[#1*PDF[#2,data]&,{weights,components}]},
		Quiet[
			(Transpose@posterior)/(Total@posterior),
			{Power::infy,Infinity::indet}
		]
	];

	(* Return the most probable component ID and associated confidence for each point *)
	{
		(* Most probable component *)
		First@Ordering[#,-1]&/@posteriors,

		(* Relative posterior probability density *)
		Max/@posteriors

	}
];


(* ::Subsubsection::Closed:: *)
(*clusteringUsingSPADE*)


(* Define a helper function that takes input data and returns the component to which each point belongs following density-normalized agglomerative clustering *)
clusteringUsingSPADE[data_,numberOfClusters_:Automatic,alpha_Real:5.0,outlierDensityQuantile_Real:0.01,targetDensityQuantile_Real:0.03,ops_List:{}]:=Module[
	{distanceFunction,Function,medianMinimumDistance,distanceThreshold,localDensity,outlierDensity,targetDensity,probabilities,downsampledData,classifier,labels,dissimilarityFunction},

	(* Extract distance function *)
	distanceFunction=Lookup[ops,DistanceFunction];

	(* Extract dissimilarity function *)
	dissimilarityFunction=With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]];

	(* Estimate the median minimum distance between nearest neighbors *)
	medianMinimumDistance=Median[distanceFunction[First@#,Last@#]&/@Nearest[data,data,2,DistanceFunction->distanceFunction]];

	(* Establish distance threshold *)
	distanceThreshold=medianMinimumDistance*alpha;

	(* Estimate the local density at each point *)
	localDensity=(Length/@Nearest[data,data,{All,distanceThreshold},DistanceFunction->distanceFunction])-1;

	(* Set the outlier and target densities to the 1st and 3rd percentiles *)
	outlierDensity=Quantile[localDensity,outlierDensityQuantile];
	targetDensity=Quantile[localDensity,targetDensityQuantile];

	(* Evaluate the probability that each sample is included during downsampling *)
	probabilities=Which[
		#<=outlierDensity,0,
		outlierDensity<#<=targetDensity,1,
		True,N@targetDensity/#
	]&/@localDensity;

	(* Downsample the data *)
	downsampledData=Part[data,First/@Position[GreaterEqual[#,RandomReal[]]&/@probabilities,True]];

	(* Fit agglomerative clustering classifier *)
	classifier=ClusterClassify[downsampledData,numberOfClusters,Method->{"Agglomerate",ClusterDissimilarityFunction->dissimilarityFunction},DistanceFunction->distanceFunction];

	(* Return the labeled input data *)
	classifier[data]

];


(* ::Subsubsection::Closed:: *)
(*clusterUsingManualGates*)


(* Define helper function that takes tabular data + one or more sets of gates and returns a list of grouped points *)
clusterUsingManualGates[data_,gateSets_]:=Module[
	{applyGates,pointSelectionMask,gateIndices},

	(* If no gates were specified, assign all points to a single cluster *)
	If[
		Length@gateSets==0,
		Return[Table[1,{Length@data}]]
	];

	(* Construct boolean mask for each data point belonging to each partition, adding an extra partition for data excluded by all gates *)
	pointSelectionMask=With[
		{mask=pointsSelectedQ[data,#]&/@gateSets},
		Append[mask,Not/@MapThread[Or,mask]]
	];

	(* Compile a list of viable partition indices for each point in the input data *)
	gateIndices=MapThread[Flatten@Position[ToList@##,True]&,pointSelectionMask];

	(* If any points belong to more than one partition, throw an error and return $Failed *)
	If[
		Or@@(Length[#]>1&/@gateIndices),
		Message[AnalyzeClusters::GatesOverlap];
	];

	(* Return the unique partition indices *)
	First/@gateIndices

];


(* ::Subsubsection::Closed:: *)
(*excludedByManualGates*)


(* Define helper function that takes tabular data + one or more sets of gates and returns a list of indices denoting which points are excluded by all gates *)
excludedByManualGates[data_,gateSets_]:=Module[
	{applyGates,pointSelectionMask,gateIndices},

	(* If no gates were specified, mark all points as excluded *)
	If[
		Length@gateSets==0,
		Return[Range[Length@data]]
	];

	(* Construct boolean mask for each data point belonging to each partition, adding an extra partition for data excluded by all gates *)
	With[
		{mask=pointsSelectedQ[data,#]&/@gateSets},
		First/@Position[MapThread[Or,mask],False]
	]
];


(* ::Subsubsection::Closed:: *)
(*formatClustersPacket*)


formatAnalysisClustersPacket[standardFields_,packetData_Association,resolvedOps_List,unresolvedOps_List]:=Module[
	{packet,upload},

	(* Construct Object[Analysis,Clusters] packet *)
	packet=Association[
		Join[
			{
				Type->Object[Analysis,Clusters]
			},

			ReplaceRule[
				standardFields,
				{
				UnresolvedOptions->unresolvedOps,
				ResolvedOptions->resolvedOps,
				NumberOfDimensions->Lookup[packetData,NumberOfDimensions],
				DimensionLabels->Lookup[resolvedOps,DimensionLabels],
				Replace[DimensionUnits]->Lookup[resolvedOps,DimensionUnits],
				Normalize->Lookup[resolvedOps,Normalize],
				Replace[Scale]->Lookup[resolvedOps,Scale],
				PreprocessedData->Lookup[packetData,PreprocessedData],
				Replace[Domain]->Lookup[resolvedOps,Domain],
				ClusterDomainOutliers->Lookup[resolvedOps,ClusterDomainOutliers],
				Method->Lookup[resolvedOps,Method],
				ClusteringAlgorithm->Lookup[resolvedOps,ClusteringAlgorithm],
				Replace[ManualGates]->Lookup[resolvedOps,ManualGates],
				Replace[ClusteredDimensions]->Lookup[resolvedOps,ClusteredDimensions],
				DistanceFunction->Lookup[resolvedOps,DistanceFunction],
				NumberOfClusters->Lookup[packetData,NumberOfClusters],
				Replace[ClusterLabels]->Lookup[resolvedOps,ClusterLabels],
				Replace[ClusterAssignments]->Lookup[resolvedOps,ClusterAssignments]/.{obj:ObjectP[]:>Link[obj]},
				IncludedIndices->Lookup[packetData,IncludedIndices],
				IncludedData->Lookup[packetData,IncludedData],
				ExcludedIndices->Lookup[packetData,ExcludedIndices],
				ExcludedData->Lookup[packetData,ExcludedData],
				ClusteredData->Lookup[packetData,ClusteredData],
				ClusteredDataConfidence->Lookup[packetData,ClusteredDataConfidence],
				WithinClusterSumOfSquares->Lookup[packetData,WithinClusterSumOfSquares],
				SilhouetteScore->Lookup[packetData,SilhouetteScore],
				VarianceRatioCriterion->Lookup[packetData,VarianceRatioCriterion]
			}
			]
		]
	];

	(* Return packet *)
	packet

];


(* ::Subsubsection::Closed:: *)
(*partitionData*)


(* Helper function that takes a list of points and returns a list of indices denoting which partition each point in the input belongs to *)
partitionData[data_,ops_]:=Module[
	{method,clusteringAlgorithm,numberOfClusters,distanceFunction,timeGoal,clusteringInputData,partitionIndices,partitionIndicesConfidence,subOptions},

	(* Extract options required for Mathematica's built in clustering function (FindClusters) *)
	method=Lookup[ops,Method];
	clusteringAlgorithm=Lookup[ops,ClusteringAlgorithm];
	numberOfClusters=Lookup[ops,NumberOfClusters];
	distanceFunction=Lookup[ops,DistanceFunction];

	(* Determine time goal (used for mixture model EM fit) *)
	timeGoal=If[MatchQ[Lookup[ops,PerformanceGoal],Speed],2,10];

	(* Constrain data to ClusteredDimensions if using an automatic clustering method *)
	clusteringInputData=If[
		MatchQ[method,Automatic],
		Part[data,All,Lookup[ops,ClusteredDimensions]],
		data
	];

	(* Assemble suboptions for built-in MM clustering algorithms *)
	subOptions=Switch[
		clusteringAlgorithm,
		DBSCAN,{"NeighborhoodRadius"->Lookup[ops,NeighborhoodRadius],"NeighborsNumber"->Lookup[ops,NeighborsNumber]},
		MeanShift,{"NeighborhoodRadius"->Lookup[ops,NeighborhoodRadius]},
		Spectral,{"NeighborhoodRadius"->Lookup[ops,NeighborhoodRadius]},
		Agglomerate,{"ClusterDissimilarityFunction"->With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]]},
		SpanningTree,{"MaxEdgeLength"->Lookup[ops,MaxEdgeLength]},
		_,{}
	];

	(* If the input data are empty, return empty lists *)
	If[
		Length@clusteringInputData==0,
		Return[
			Switch[
				clusteringAlgorithm,
				GaussianMixture,{{},{}},
				_,{{},None}
			]
		]
	];

	(* Call appropriate partitioning method *)
	{partitionIndices,partitionIndicesConfidence}=If[

		(* Automatic clustering *)
		MatchQ[method,Automatic],
		Switch[
			clusteringAlgorithm,

			(* Use ClusteringComponents built-in method where available *)
			Alternatives@@{Agglomerate,DBSCAN,JarvisPatrick,KMeans,KMedoids,MeanShift,NeighborhoodContraction,SpanningTree,Spectral},
			{
				ClusteringComponents[clusteringInputData,numberOfClusters,1,Method->{ToString@clusteringAlgorithm,Sequence@@Select[subOptions,!MatchQ[Last[#],Automatic]&]},DistanceFunction->distanceFunction],
				None
			},

			(* Model-based clustering using GMMs. The expectation-maximization runtime is set based on the specified PerformanceGoal *)
			GaussianMixture,
			clusterUsingGMM[clusteringInputData,numberOfClusters,Lookup[ops,CovarianceType],Lookup[ops,MaxIterations],timeGoal],

			(* Density-based hierarchical clustering *)
			SPADE,
			{
				clusteringUsingSPADE[
					clusteringInputData,
					numberOfClusters,
					Lookup[ops,DensityResamplingThreshold],
					Lookup[ops,OutlierDensityQuantile],
					Lookup[ops,TargetDensityQuantile],
					Lookup[ops,ClusterDissimilarityFunction],
					ops
				],
				None
			}
		],

		(* Manual gating *)
		{
			clusterUsingManualGates[clusteringInputData,Lookup[ops,ManualGates]],
			None
		}

	];

	(* Return partition indices and associated confidence levels *)
	{partitionIndices,partitionIndicesConfidence}

];


(* ::Subsubsection::Closed:: *)
(*analyzeClusters*)


analyzeClusters[tabularData_,originalOps_,ops_]:=Module[
	{
		numberOfDimensions,standardFields,method,preprocessedTabularData,includedIndices,excludedIndices,
		excludedData,partitionIndices,partitionIndicesConfidence,outlierIndices,clusteredData,
		clusteredDataConfidence,clusterLabels,clusterAssignments,labeledClusterData,labeledClusteredDataConfidence,
		labeledClusterDataIncludingOutliers,finalClusters,finalConfidenceLevels,withinClusterSumOfSquares,
		silhouetteScore,varianceRatioCriterion,resolvedInputOps,resolvedOps,collapsedResolvedOps,
		output,listedOutput,preview,packetData,packet,result
	},

	(* Extract number of dimensions *)
	numberOfDimensions=Length@First@tabularData;

	(* Populate standard Analysis object fields *)
	standardFields=analysisPacketStandardFieldsStart[{}];

	(* Resolve AnalyzeClusters  *)
	resolvedInputOps=resolveAnalyzeClustersOptions[tabularData,ops];

	(* Determine method *)
	method=Lookup[resolvedInputOps,Method];

	(* Pre-process data (normalize and scale) *)
	preprocessedTabularData=preprocessData[tabularData,Lookup[resolvedInputOps,Scale],Lookup[resolvedInputOps,Normalize]];

	(* Determine which points are included vs excluded by the specified Domain or ManualGates *)
	excludedIndices=excludedByManualGates[
		preprocessedTabularData,
		Switch[
			method,

			(* If Method is Automatic, only include points within the specified Domain *)
			Automatic,
			{Lookup[resolvedInputOps,Domain]},

			(* If Method is Manual, include all points *)
			Manual,
			Lookup[resolvedInputOps,ManualGates]
		]
	];
	includedIndices=Complement[Range[Length@preprocessedTabularData],excludedIndices];

	(* If no data points remain, throw an error if method is Automatic and a warning if method is Manual *)
	If[
		Length@includedIndices==0,

		Switch[
			method,

			Automatic,
			Message[AnalyzeClusters::NoIncludedData,Lookup[resolvedInputOps,Domain]];
			Message[Error::InvalidOption,Domain];
			Return[$Failed],

			Manual,
			Message[AnalyzeClusters::EmptyManualGates];
		]
	];

	(* Perform clustering to assign a partition index to each point in the included data *)
	{partitionIndices,partitionIndicesConfidence}=partitionData[Part[preprocessedTabularData,includedIndices],resolvedInputOps];

	(* Move any outliers into excludedData (we have to do this because some algorithms, like DBSCAN, exclude outliers during clustering *)
	outlierIndices=First/@Position[partitionIndices,_Missing,-1];
	excludedIndices=Join[excludedIndices,Part[includedIndices,outlierIndices]];
	excludedData=Part[tabularData,excludedIndices];
	includedIndices=Part[includedIndices,Complement[Range[Length@includedIndices],outlierIndices]];
	partitionIndices=Select[partitionIndices,!MatchQ[#,_Missing]&];
	partitionIndicesConfidence=If[
		!MatchQ[partitionIndicesConfidence,None],
		Part[partitionIndicesConfidence,Complement[Range[Length@partitionIndicesConfidence],outlierIndices]],
		partitionIndicesConfidence
	];

	(* Use partition indices to assemble the original data into partitions *)
	clusteredData=SortBy[GatherBy[Thread[{partitionIndices,Part[tabularData,includedIndices]}],First],#[[1,1]]&][[All,All,-1]];
	clusteredDataConfidence=If[
		MatchQ[partitionIndicesConfidence,None],
		None,
		SortBy[GatherBy[Thread[{partitionIndices,partitionIndicesConfidence}],First],#[[1,1]]&][[All,All,-1]]
	];

	(* Resolve ClusterLabels and label data *)
	clusterLabels=resolveClusterLabels[clusteredData,Lookup[resolvedInputOps,ClusterLabels]];
	clusterAssignments=resolveClusterAssignments[clusteredData,Lookup[resolvedInputOps,ClusterAssignments]];

	(* Label clustered data and (when available) associated confidence levels *)
	labeledClusterData=Association[MapThread[Rule,{clusterLabels,clusteredData}]];
	labeledClusteredDataConfidence=If[
		MatchQ[clusteredDataConfidence,_List],
		Association[MapThread[Rule,{clusterLabels,clusteredDataConfidence}]],
		clusteredDataConfidence
	];

	(* Compute clustering performance metrics, returning 0 for SilhouetteScore and VarianceRatioCriterion if only a single cluster exists *)
	withinClusterSumOfSquares=evaluateWithinClusterSumOfSquares[labeledClusterData,resolvedInputOps];
	silhouetteScore=If[
		Length@labeledClusterData<=1,
		None,
		evaluateSilhouetteScore[labeledClusterData,resolvedInputOps]
	];
	varianceRatioCriterion=If[
		Length@labeledClusterData<=1,
		None,
		evaluateVarianceRatioCriterion[labeledClusterData,resolvedInputOps]
	];

	(* Assign domain outliers to clusters if requested *)
	{finalClusters,finalConfidenceLevels}=If[

		(* If ClusterDomainOutliers is True, append the excluded data points to the cluster with the nearest centroid *)
		TrueQ@Lookup[resolvedInputOps,ClusterDomainOutliers],
		Module[
			{centroids,outlierPartitions,mergedClusters,mergedClusterConfidence},

			(* Evaluate the cluster centroids *)
			centroids=MapThread[Mean[#2]->#1&,{Keys@labeledClusterData,Values@labeledClusterData}];

			(* Determine the nearest cluster centroid to each domain outlier *)
			outlierPartitions=First/@Nearest[centroids,excludedData,DistanceFunction->Lookup[resolvedInputOps,DistanceFunction]];

			(* Assemble the excluded data into a partitioned association, then merge it with the existing clustered data *)
			mergedClusters=Merge[
				{
					labeledClusterData,
					(#->Part[excludedData,(First/@Position[outlierPartitions,#])])&/@(DeleteDuplicates@outlierPartitions)
				},
				Join@@#&
			];

			(* If confidence levels are available, append Nulls for the domain outliers *)
			mergedClusterConfidence=If[
				MatchQ[labeledClusteredDataConfidence,None],
				None,
				Merge[
					{
						labeledClusteredDataConfidence,
						(#->Table[Null,{Length@Position[outlierPartitions,#]}])&/@(DeleteDuplicates@outlierPartitions)
					},
					Join@@#&
				]
			];

			(* Return the merged clusters and confidence levels *)
			{mergedClusters,mergedClusterConfidence}

		],

		(* If ClusterDomainOutliers is False, leave clusters and confidence levels as is *)
		{labeledClusterData,labeledClusteredDataConfidence}
	];

	(* Assemble fully resolved options *)
	resolvedOps=ReplaceRule[resolvedInputOps,{
		ClusterLabels->clusterLabels,
		ClusterAssignments->clusterAssignments
	}];

	(* Assemble data for packet *)
	packetData=Association[
		NumberOfDimensions->numberOfDimensions,
		PreprocessedData->preprocessedTabularData,
		IncludedIndices->includedIndices,
		IncludedData->Part[tabularData,includedIndices],
		ExcludedIndices->excludedIndices,
		ExcludedData->excludedData,
		ClusteredData->finalClusters,
		ClusteredDataConfidence->finalConfidenceLevels,
		NumberOfClusters->Length@finalClusters,
		WithinClusterSumOfSquares->withinClusterSumOfSquares,
		SilhouetteScore->silhouetteScore,
		VarianceRatioCriterion->varianceRatioCriterion
	];

	(* Format Object[Analysis,Clusters] packet *)
	packet=formatAnalysisClustersPacket[standardFields,packetData,resolvedOps,originalOps];

	(* Do some options cleanup, i.e. collapse the scale option for the builder output *)
	collapsedResolvedOps=resolvedOps/.{
		(* If Scale option is repeated identical elements, collapse it *)
		Rule[Scale,{(p_)..}]:>Rule[Scale,p]
	};

	(* Get requested output *)
	output=Lookup[resolvedOps,Output];
	listedOutput=ToList[output];

	(* Generate preview if it was requested *)
	preview=If[MemberQ[listedOutput,Preview],
		analyzeClustersPreview[packet],
		None
	];

	(* Generate the result if it was requested *)
	result=If[Lookup[resolvedOps,Upload]&&MemberQ[listedOutput,Result],
		Upload[packet],
		packet
	];

	(* Return the requested output, hiding much of the result code in case only the preview function is needed *)
	output/.{
		Result->result,
		Options->collapsedResolvedOps,
		Preview->preview,
		Tests->{}
	}
];


(* ::Subsection::Closed:: *)
(*Cluster Evaluation Metrics*)


(* ::Subsubsection::Closed:: *)
(*evaluateWithinClusterSumOfSquares*)


(* Sum the within-cluster dispersion across all clusters *)
evaluateWithinClusterSumOfSquares[clusters_,ops_]:=Module[
	{distanceFunction,sumSquaredDistances},

	(* Define a helper function that takes a list of points and returns the total distance from each of them to the mean *)
	distanceFunction=Lookup[ops,DistanceFunction];
	sumSquaredDistances=Function[
		pts,
		Total[#^2&/@Flatten@DistanceMatrix[pts,{Mean[pts]},DistanceFunction->distanceFunction]]
	];

	(* Return the total within-cluster sum of squared distances across all clusters *)
	Total[sumSquaredDistances/@(Values@clusters)]

];


(* ::Subsubsection::Closed:: *)
(*evaluateVarianceRatioCriterion*)


evaluateVarianceRatioCriterion[clusters_,ops_]:=Module[
	{distanceFunction,sumSquaredDistances,tss,ssw,k,N},

	(* Define a helper function that takes a list of points and returns the total distance from each of them to the mean *)
	distanceFunction=Lookup[ops,DistanceFunction];
	sumSquaredDistances=Function[
		pts,
		Total[#^2&/@Flatten@DistanceMatrix[pts,{Mean[pts]},DistanceFunction->distanceFunction]]
	];

	(* Determine the number of clusters and number of datapoints *)
	k=Length@clusters;
	N=Length[Join@@Values@clusters];

	(* Calculate the total sum of squares for the whole dataset *)
	tss=sumSquaredDistances[Join@@Values@clusters];

	(* Calculate the sum of squares within each cluster *)
	ssw=evaluateWithinClusterSumOfSquares[clusters,ops];

	(* Evaluate the variance ratio criterion *)
	((tss-ssw)/ssw)*(N-k)/(k-1)

];


(* ::Subsubsection::Closed:: *)
(*evaluateSilhouetteScore*)


evaluateSilhouetteScore[clusters_,ops_]:=Module[
	{centroids,neighbors,scores},

	(* Compute the centroid of each cluster *)
	centroids=Mean/@clusters;

	(* Map the label for each cluster to its nearest neighbor *)
	neighbors=Last@Nearest[MapThread[Rule,{Values@centroids,Keys@centroids}],#,2]&/@centroids;

	(* Evaluate the Silhouette score for all points *)
	scores=Join@@(Module[
		{distancesWithin,distancesBetween,meanDistanceWithin,meanDistanceBetween},
		distancesWithin=DistanceMatrix[Lookup[clusters,#],DistanceFunction->Lookup[ops,DistanceFunction]];
		distancesBetween=DistanceMatrix[Lookup[clusters,#],Lookup[clusters,Lookup[neighbors,#]],DistanceFunction->Lookup[ops,DistanceFunction]];
		meanDistanceWithin=If[Length@distancesWithin==1,{0},Total@distancesWithin/(Length@distancesWithin-1)];
		meanDistanceBetween=Total[distancesBetween,{2}]/Part[Dimensions@distancesBetween,2];
		(meanDistanceBetween-meanDistanceWithin)/MapThread[Max,{meanDistanceWithin,meanDistanceBetween}]
	]&/@Keys@neighbors);

	(* Return the mean silhouette score *)
	Mean@scores

];


(* ::Subsubsection::Closed:: *)
(*drawPolygon*)


(* Define preset colormap for polygons *)
clusterColors=ColorData[54,"ColorList"];

(* Define helper function that draws a polygonal gate *)
drawPolygon[{},___]:={};
drawPolygon[{x_}, ___]:={};
drawPolygon[polygon_,type_,color_:None,text_:None,lineColor_:Automatic,textColor_:Automatic]:=With[
	{
		polygonColor=If[
			MatchQ[color,None],
			Switch[type,Include,Black,Exclude,Red],
			color
		]
	},
	{
		EdgeForm[{Thick,Replace[lineColor,Automatic->polygonColor]}],
		FaceForm[{Opacity[.1],polygonColor}],

		(* If polygon is defined in 3D, render the convex hull *)
		If[Length[Part[polygon,1,1]]==3,ConvexHullMesh@@polygon,polygon],

		(* Overlay text if specified *)
		If[
			!MatchQ[text,None],
			Text[Style[text,FontSize->largeFontSize,FontWeight->Bold,FontColor->Replace[textColor,Automatic->polygonColor]],Mean@First@polygon]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*toAxisAngleForm*)


(* Define helper function that takes a rotation matrix and returns an axis/angle equivalent *)
toAxisAngleForm[matrix_] := Module[
	{axis,ovec,nvec},
	{axis,ovec}=N@Orthogonalize[{{1,-1,1}#,Permute[#,Cycles[{{1,3,2}}]]}]&@Extract[matrix-Transpose[matrix],{{3,2},{3,1},{2,1}}];
	nvec=N@Cross[axis, ovec];
	{Arg[Complex@@(((matrix.ovec).#&)/@{ovec,nvec})],axis}
];


(* ::Subsubsection::Closed:: *)
(*parseEllipsoid*)


(* Define helper function that takes any 3D ellipsoid and extracts the position, radii, and angles *)
parseEllipsoid[ellipsoid_]:=Module[
	{position,radii,angles,eigenValues,eigenVectors,eigenVectorsNormalized},

	(* Extract position vector *)
	position={Part[ellipsoid,1,{1,2}],Part[ellipsoid,1,3]};

	(* Check if format is axis-aligned *)
	{radii,angles}=If[
		MatchQ[Part[ellipsoid,2],{_?NumericQ,_?NumericQ,_?NumericQ}],

		(* If it is, return lengths and set angles to zero *)
		{Part[ellipsoid,2],{0.,0.,0.}},

		(* If it's not, perform an eigendecomposition to identify axis lengths and rotations *)
		{eigenValues,eigenVectors}=Eigensystem[Part[ellipsoid,2]];

		(* Normalize the eigenvectors *)
		eigenVectorsNormalized=#/Norm[#,2]&/@eigenVectors;

		(* Reverse the order if the determinant of the orientation matrix is negative *)
		{eigenValues,eigenVectorsNormalized}=If[Det[eigenVectorsNormalized]<0,Reverse,Identity]/@{eigenValues,eigenVectorsNormalized};

		(* Extract the ellipsoid radii and roll/pitch/yaw *)
		{
			Sqrt[eigenValues],
			RollPitchYawAngles[Transpose@eigenVectorsNormalized]
		}
	];

	(* Return position, radii, and angles *)
	{position,radii,angles}

];


(* ::Subsubsection::Closed:: *)
(*App Stylesheet*)


(* Define colormap for partitions (same as default used by mathematica plot functions) *)
partitionColors=Join@@Table[ColorData[97,"ColorList"],{10}];

(* Define font sizes *)
smallFontSize=11;
mediumFontSize=12;
largeFontSize=24;

(* Define font colors *)
baseFontColor=Darker[Gray,0.5];

(* Button formatting *)
buttonFontSize=12;
buttonColor=Gray;
buttonInactiveColor=Lighter[Gray,0.5];

(* Color used for excluded data points *)
excludedColor=Lighter[Gray,0.5];

(* Color used for the active gate in domain specification mode *)
activeGateColor=Orange;

(* Define table header/row colors *)
tableHeaderColor=Lighter[Gray,0.7];
tableRowColor=Lighter[Gray,0.9];

(* Define menu header/row colors *)
menuHeaderColor=Gray;
menuRowColor=Lighter[Gray,0.9];

(* Popupmenus *)
popupMenuDefaultOps={
	FieldSize->{{2,10},1},
	ContentPadding->False,
	FrameMargins->0,
	BaselinePosition->Center,
	Alignment->{Left,Top}
};


(* ::Subsubsection::Closed:: *)
(*App Helper Functions*)


(* Define a helper function that takes a string and a max length and truncates the string to that length, appending ellipsis *)
truncateString[myString_,maxLength_Integer]:=If[StringLength[myString]<=maxLength,myString,StringJoin[StringTake[myString,maxLength],"..."]];

(* Define helper Q function that returns True if its input is not Null *)
notNullQ=Function[input,!NullQ[input]];


(* ::Subsubsection:: *)
(*buildSelectorApp*)


(* Define a helper function which takes a packet and builds a grid of buttons which show quick 1D and 2D previews for clustering dimension selection *)
buildSelectorApp[myPacket_, myOps_, myMethod_, dv_]:=Module[
	{
		dimensionLabels,clusteredDimensions,ndim,allData,stdevPerDimension,
		sortedDimIndices,filteredDimIndices,initialIndices
	},

	(* Unpack dimension labels and clustered dimensions *)
	dimensionLabels=Lookup[myPacket,DimensionLabels];
	clusteredDimensions=Lookup[myPacket,ClusteredDimensions];

	(* Dimensionality of data *)
	ndim=Lookup[myPacket,NumberOfDimensions];

	(* All data points *)
	allData=Lookup[myPacket,PreprocessedData];

	(* Standard deviation per dimension of data *)
	stdevPerDimension=StandardDeviation/@Transpose[allData];

	(* Sort each dimension by decreasing variance *)
	sortedDimIndices=Last/@ReverseSortBy[
		Thread[Range[ndim]->Ordering[stdevPerDimension]],
		First
	];

	(* Keep only indices which are in the clustered dimensions *)
	filteredDimIndices=Cases[sortedDimIndices,Alternatives@@clusteredDimensions];

	(* Take only the first 7 sorted indices since that's all that fits on screen *)
	initialIndices=Sort@Part[filteredDimIndices,1;;Min[7,ndim,Length[clusteredDimensions]]];

	(* Construct and return interactive app *)
	DynamicModule[
		{
			(* Keep a local dynamic copy of packet and options so things don't explode on reload *)
			packet=myPacket,
			ops=myOps,
			method=myMethod,

			(* Dimensions and their labels  *)
			numberOfDimensions=ndim,
			dimensionDisplayNames=If[MatchQ[dimensionLabels,None],
				StringJoin["Dimension ",ToString[#]]&/@Range[Lookup[myPacket,NumberOfDimensions]],
				dimensionLabels
			],

			(* Set initial values of clustering dimensions *)
			bestDims1=Part[initialIndices,1;;Min[4,Length[initialIndices]]],
			bestDims2=initialIndices,
			selectorDims1=Part[initialIndices,1;;Min[4,Length[initialIndices]]],
			selectorDims2=initialIndices,
			initialized=False,

			(* Functions; these must be Dynamic Module variables so they persist *)
			makeGrid,makeSmallPlot,

			(* Dynamic Variables *)
			menus,gridButtons
		},

		(* Create subplots for selector buttons *)
		makeSmallPlot[pkt_, dim1_Integer, dim2_Integer]:=Module[
			{clusteredData, slicedData},

			(* Retrieve clustered data from the packet *)
			clusteredData=Lookup[pkt,ClusteredData];

			(* Return a histogram if dim1==dim2 *)
			If[dim1==dim2,
				Return@Histogram[
					Map[
						Part[#,All,dim1]&,
						Values[clusteredData]
					],
					PassOptions[
						EmeraldHistogram,
						Histogram,
						{
							Frame->True,
							AspectRatio->1,
							ImageSize->120,
							FrameTicks->None,
							ImagePadding->{{0,0.5},{0.5,0}},
							PerformanceGoal->"Speed",
							Background->White,
							ChartStyle->partitionColors
						}
					]
				]
			];

			(* Slice data from the requested dimensions *)
			slicedData=Map[
				Part[#,All,{dim1,dim2}]&,
				Values[clusteredData]
			];

			(* Generate a scatter plot *)
			ListPlot[slicedData,
				PassOptions[
					EmeraldListLinePlot,
					ListPlot,
					{
						Joined->False,
						Frame->True,
						AspectRatio->1,
						ImageSize->120,
						FrameTicks->None,
						ImagePadding->{{0,0.5},{0.5,0}},
						Background->White,
						PlotRange->All,
						PerformanceGoal->"Quality"
					}
				]
			]
		];

		(* Create a grid of selector buttons *)
		makeGrid[pkt_, dims1_, dims2_, init_]:=Module[
			{gridPlots,paddedPlots,dimNames1,dimNames2},

			If[Or[!init,MatchQ[dims1,{}]&&MatchQ[dims2,{}]],
				Return@(gridButtons=Graphics[
					{
						{Gray,Opacity[0.1],Rectangle[{-3,-2},{3,2}]},
						{Opacity[1],Style[Text["Select dimensions and click\n[Update Grid] to generate preview"],FontFamily->"Arial",FontSize->24]}
					},
					ImageSize->500
				])
			];

			(* Create an array of plots *)
			gridPlots=Table[
				(* Need this with statement to force evluation of delayed indices i and j *)
				With[{newDim1=j,newDim2=i},
					(* Pull up the 1D app if i==j, 2D app otherwise, and update active dimensions *)
					If[i==j,
						Button[makeSmallPlot[pkt,j,i],(activeTab=2;app1Ddim1=newDim1;)],
						Button[makeSmallPlot[pkt,j,i],(activeTab=3;app2Ddim1=newDim1;app2Ddim2=newDim2;)]
					]
				],
				{i,dims2},
				{j,dims1}
			];

			(* Get a list of dimension display names selected *)
			dimNames1=Flatten@Part[dimensionDisplayNames,dims1];
			dimNames2=Flatten@Part[dimensionDisplayNames,dims2];

			(* Pad the plots to create headers *)
			paddedPlots=Prepend[
				Transpose[Prepend[gridPlots,dimNames1]],
				Prepend[dimNames2,Null]
			];

			(* Make a grid for output *)
			gridButtons=Grid[
				paddedPlots,
				Spacings->{0.5,0.5},
				BaselinePosition->Top
			]
		];

		(* Add the recordState function to the tagging rules, along with any button functions we want to test *)
		SetOptions[
			$FrontEndSession,
			TaggingRules->ReplaceRule[
				(TaggingRules/.Options[$FrontEndSession,TaggingRules])/.{None|<||>->{}},
				{"SelectorMakeGrid"->makeGrid}
			]
		];

		(* Selector menus and a button for updating the grid graphic *)
		menus=Grid[
			{
				{
					Labeled[
						ListPicker[Dynamic[selectorDims1],
							Thread[Range[numberOfDimensions]->(#<>" "&/@dimensionDisplayNames)],
							AppearanceElements->All,
							Multiselection->True
						],
						"Dimension 1",
						Top
					],
					Spacer[35],
					Labeled[
						ListPicker[Dynamic[selectorDims2],
							Thread[Range[numberOfDimensions]->(#<>" "&/@dimensionDisplayNames)],
							AppearanceElements->All,
							Multiselection->True
						],
						"Dimension 2",
						Top
					]
				},
				{
					Framed[
						Button[
							Style[" Reset to Default ",Thick,Bold,FontSize->buttonFontSize],
							(
								selectorDims1=bestDims1;
								selectorDims2=bestDims2;
								makeGrid[packet,selectorDims1,selectorDims2,True]
							),
							Appearance->"Frameless",
							FrameMargins->5,
							Background->None
						],
						FrameStyle->Directive[Thick],
						FrameMargins->None
					],
					SpanFromLeft,
					Framed[
						Button[
							Style[" Update Grid ",Thick,Bold,FontSize->buttonFontSize],
							(
								makeGrid[packet,selectorDims1,selectorDims2,True]
							),
							Appearance->"Frameless",
							FrameMargins->5,
							Background->None
						],
						FrameStyle->Directive[Thick],
						FrameMargins->None
					]
				}
			},
			Spacings->{0.6,2},
			Alignment->{{Left,Center,Right},Center},
			BaselinePosition->Top
		];

		(* Grid of buttons for the selector *)
		gridButtons=makeGrid[packet,selectorDims1,selectorDims2,False];

		(* Return the final graphic *)
		Grid[{{Dynamic[gridButtons], Spacer[30], menus}},Alignment->Top],

		(* Inherit dynamic variables from the parent app *)
		InheritScope->True
	]
];


(* ::Subsubsection:: *)
(*build1DGatingApp*)


(* Define a helper function that takes a packet and constructs a dynamic module for interactive partitioning of data by drawing 1D decision boundaries *)
build1DGatingApp[myPacket_,myOps_,myMethod_:Automatic,dv_]:=Module[
	{
		dimensionLabels,rawClusterLabels,clusterLabels,clusteredDimensions,initialGates,
		initialIncludedIndices,initialExcludedIndices,initialIncludedData,initialExcludedData,
		initialPartitionIndices,initialOutlierIndices,initialClusteredData
	},

	(* Unpack dimension labels and clustered dimensions *)
	dimensionLabels=Lookup[myPacket,DimensionLabels];
	clusteredDimensions=Lookup[myPacket,ClusteredDimensions];

	(* Unpack Cluster Labels *)
	rawClusterLabels=ClusterLabels/.Lookup[myPacket,UnresolvedOptions,{}];
	clusterLabels=If[MatchQ[rawClusterLabels,Automatic|ClusterLabels|Null|{}],
		Lookup[myPacket,ClusterLabels],
		rawClusterLabels
	];

	(* Extract initial gate lists *)
	initialGates=Switch[
		myMethod,
		Manual,
		Cases[#,OneDimensionalGateP]&/@Lookup[myOps,ManualGates],

		(* Wrap domain constraints in an additional outer list so they're treated as a single cluster *)
		Automatic,
		{Cases[Lookup[myOps,Domain],OneDimensionalGateP]}
	];

	(* Determine which points are included vs excluded by the gates *)
	initialExcludedIndices=excludedByManualGates[Lookup[myPacket,PreprocessedData],initialGates];
	initialIncludedIndices=Complement[Range[Length@Lookup[myPacket,PreprocessedData]],initialExcludedIndices];
	initialExcludedData=Part[Lookup[myPacket,PreprocessedData],initialExcludedIndices];
	initialIncludedData=Part[Lookup[myPacket,PreprocessedData],initialIncludedIndices];

	(* Compute initial partition indices *)
	initialPartitionIndices=First[partitionData[initialIncludedData,myOps]];

	(* Move any outliers into excludedData (this is because some algorithms, like DBSCAN, exclude outliers) *)
	initialOutlierIndices=First/@Position[initialPartitionIndices,_Missing,-1];
	initialExcludedIndices=Join[initialExcludedIndices,Part[initialIncludedIndices,initialOutlierIndices]];
	initialExcludedData=Part[Lookup[myPacket,PreprocessedData],initialExcludedIndices];
	initialIncludedIndices=Part[initialIncludedIndices,Complement[Range[Length@initialIncludedIndices],initialOutlierIndices]];
	initialIncludedData=Part[Lookup[myPacket,PreprocessedData],initialIncludedIndices];
	initialPartitionIndices=Select[initialPartitionIndices,!MatchQ[#,_Missing]&];

	(* Use partition indices to assemble the original data into partitions *)
	initialClusteredData=Association@MapIndexed[First@#2->#1&,SortBy[GatherBy[Thread[{initialPartitionIndices,initialIncludedData}],First],#[[1,1]]&][[All,All,-1]]];

	(* Construct and return interactive app *)
	DynamicModule[
		{
			packet=myPacket,
			ops=myOps,
			method=myMethod,

			(* Input data *)
			allData=Lookup[myPacket,PreprocessedData],
			includedData=initialIncludedData,
			excludedData=initialExcludedData,

			(* Indices of included and excluded data points *)
			excludedIndices=initialExcludedIndices,
			includedIndices=initialIncludedIndices,
			outlierIndices,

			(* Clustering result *)
			partitionIndices=initialPartitionIndices,
			clusteredData=initialClusteredData,

			(* Performance metrics (sum of squared residuals) *)
			globalSSR=evaluateWithinClusterSumOfSquares[Association@{"Group 1"->initialIncludedData},{DistanceFunction->Lookup[myPacket,DistanceFunction]}],
			SSR=evaluateWithinClusterSumOfSquares[initialClusteredData,{DistanceFunction->Lookup[myPacket,DistanceFunction]}],

			(* Gating interface components *)
			gateControls,
			appInterface,
			gatingInterface,

			(* Projection components *)
			numberOfDimensions=Lookup[myPacket,NumberOfDimensions],
			clusterNames=clusterLabels,
			dimensionDisplayNames=truncateString[#,12]&/@(If[MatchQ[dimensionLabels,None],StringJoin["Dimension ",ToString[#]]&/@Range[Lookup[myPacket,NumberOfDimensions]],dimensionLabels]),
			dimensionUnits=Lookup[myPacket,DimensionUnits],

			(* Actual dynamic variables *)
			polygon,

			(* Dynamic components *)
			gates=initialGates,
			activeGateGraphics,
			gateIndex=None,
			gateActive=False,

			(* Initialize the cluster index *)
			clusterIndex=1,

			(* Add dynamic variable for locator position *)
			pts={0,0},

			(* Add toggle for tracking whether the gates were changed within the app *)
			gatesChanged=False,

			(* Add a toggle for overlaying the usage instructions *)
			showInstructions=False,
			gateActivelyMoving=False,

			(* Add functions triggered by button clicks *)
			addGate,removeGate,addCluster,removeCluster,updateResults,getGates,setGates,recordState
		},

		(* Define helper functions that retrieves the current preview value for 'gates' *)
		getGates[]:=Switch[
			method,
			Automatic,{Cases[PreviewValue[dv,Domain],OneDimensionalGateP]},
			Manual,Cases[#,OneDimensionalGateP]&/@PreviewValue[dv,ManualGates]
		];

		(* Define helper functions that logs the current preview value for 'gates' *)
		setGates[gates_]:=LogPreviewChanges[
			dv,
			{
				Switch[
					method,
					Automatic,Domain->First[Replace[gates,gate:_Dynamic:>Setting@gate,{3}]],
					Manual,ManualGates->Replace[gates,gate:_Dynamic:>Setting@gate,{3}]
				]
			}
		];

		(* Add gate button *)
		addGate[partitionTableIndex_]:=DynamicModule[
			{},

			(* Save the current active gate by setting it to its static value *)
			If[
				!MatchQ[gateIndex,None],
				Part[gates,clusterIndex,gateIndex,2]=Setting@Part[gates,clusterIndex,gateIndex,2];
			];

			(* Add a gate to this partition *)
			AppendTo[Part[gates,partitionTableIndex],{app1Ddim1,Mean@Part[allData,All,app1Ddim1],Below}];

			(* Update the active gate index and cluster index and the number of gates in the current cluster *)
			clusterIndex=partitionTableIndex;
			gateIndex=Length@Part[gates,partitionTableIndex];

			(* Link the active gate to the locator *)
			pts={Setting@Part[gates,clusterIndex,gateIndex,2],0.5};
			Part[gates,clusterIndex,gateIndex,2]=Dynamic[First[pts]];

			(* Activate the gate *)
			gateActive=True;

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Toggle on the usage instructions *)
			showInstructions=True;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Remove gate button *)
		removeGate[partitionTableIndex_,removedGateIndex_]:=DynamicModule[
			{},

			(* Remove the gate *)
			Part[gates,partitionTableIndex]=Drop[Part[gates,partitionTableIndex],{removedGateIndex}];

			(* If a different gate than the one that was deleted was active, update the gate index appropriately *)
			gateIndex=Which[

				(* If the deleted gate belongs to a different cluster than the active gate, don't change anything *)
				clusterIndex!=partitionTableIndex,
				gateIndex,

				(* If no gate is currently active, keep it that way *)
				MatchQ[gateIndex,None],
				None,

				(* If the active gate was deleted, set the gate Index to None *)
				gateIndex==removedGateIndex,
				None,

				(* If the active gate has a higher index than the deleted gate, decrement its index *)
				gateIndex>removedGateIndex,
				gateIndex-1,

				(* If the active gate has a lower index, no need to do anything *)
				gateIndex<removedGateIndex,
				gateIndex

			];

			(* Deactivate the gate *)
			If[
				MatchQ[gateIndex,None],
				gateActive=False;
				pts={};
			];

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Toggle off the usage instructions *)
			showInstructions=False;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Add cluster button *)
		addCluster[]:=DynamicModule[
			{},

			(* Save the current active gate by setting it to its static value *)
			If[
				!MatchQ[gateIndex,None],
				Part[gates,clusterIndex,gateIndex,2]=Setting@Part[gates,clusterIndex,gateIndex,2];
			];

			(* Add an empty partition *)
			AppendTo[gates,{}];

			(* Update the active gate and cluster indices and the number of gates in the current cluster *)
			clusterIndex=Length@gates;
			gateIndex=None;
			gateActive=False;
			pts={};

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Remove cluster button *)
		removeCluster[partitionTableIndex_]:=DynamicModule[
			{},

			(* Remove the partition *)
			gates=Drop[gates,{partitionTableIndex}];

			(* If no partitions remain, add back an empty one *)
			gates=If[
				Length@gates==0,
				Append[gates,{}],
				gates
			];

			(* If the deleted partition was active, set the gate index to None *)
			gateIndex=If[
				clusterIndex!=partitionTableIndex,
				gateIndex,
				None
			];

			(* If a gate was deactivated, change the gateActive flag so the graphic stops rendering *)
			gateActive=If[
				MatchQ[gateIndex,None],
				False,
				gateActive
			];

			(* Reset the locator *)
			If[
				!TrueQ@gateActive,
				pts={};
			];

			(* Update the cluster index *)
			clusterIndex=Which[

				(* If the deleted partition was active, default to the last partition *)
				clusterIndex==partitionTableIndex,
				Length@gates,

				(* If the deleted partition has a higher index than the active partition, don't do anything *)
				clusterIndex<partitionTableIndex,
				clusterIndex,

				(* If deleted partition had a lower index than the active partition, decrement the active partition index *)
				clusterIndex>partitionTableIndex,
				clusterIndex-1

			];

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Toggle off the usage instructions *)
			showInstructions=False;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Define function called by Update Results button *)
		updateResults[]:=DynamicModule[
			{},

			(* Retrieve gates from Preview *)
			gates=getGates[];

			(* If there's an active gate, link it to the click locator *)
			If[
				gateActive,
				Quiet[
					Check[
						(* Try to link the locator to the active gate *)
						pts={Part[gates,clusterIndex,gateIndex,2],0.5};
						app1Ddim1=Part[gates,clusterIndex,gateIndex,1];
						Part[gates,clusterIndex,gateIndex,2]=Dynamic[First[pts]];,

						(* If it doesn't work (due to gate definitions changing), deactivate all gates *)
						gateActive=False;
						gateIndex=None;
					]
				]
			];

			(* Update which points are included vs excluded by the gates *)
			excludedIndices=excludedByManualGates[allData,Replace[gates,gate:_Dynamic:>Setting@gate,{3}]];
			includedIndices=Complement[Range[Length@allData],excludedIndices];
			excludedData=Part[allData,excludedIndices];
			includedData=Part[allData,includedIndices];

			(* Partition the data *)
			partitionIndices=Quiet[
				First[partitionData[includedData,ReplaceRule[ops,ManualGates->Replace[gates,gate:_Dynamic:>Setting@gate,{3}]]]],
				{AnalyzeClusters::GatesOverlap}
			];

			(* Move any outliers into excludedData (e.g. some algorithms, like DBSCAN, exclude outliers) *)
			outlierIndices=First/@Position[partitionIndices,_Missing,-1];
			excludedIndices=Join[excludedIndices,Part[includedIndices,outlierIndices]];
			excludedData=Part[allData,excludedIndices];
			includedIndices=Part[includedIndices,Complement[Range[Length@includedIndices],outlierIndices]];
			includedData=Part[allData,includedIndices];
			partitionIndices=Select[partitionIndices,!MatchQ[#,_Missing]&];

			(* Use partition indices to assemble the original data into partitions *)
			clusteredData=Association@MapIndexed[First@#2->#1&,SortBy[GatherBy[Thread[{partitionIndices,includedData}],First],#[[1,1]]&][[All,All,-1]]];

			(* Evaluate SSR *)
			SSR=evaluateWithinClusterSumOfSquares[clusteredData,{DistanceFunction->Lookup[packet,DistanceFunction]}];

			(* Toggle plot as updated *)
			gatesChanged=False;,

			InheritScope->True
		];

		(* Define a function that records the state of the app, its variables, and functions by stashing them in the front end tagging rules *)
		recordState[]:=SetOptions[
			$FrontEndSession,
			TaggingRules->ReplaceRule[
				(TaggingRules/.Options[$FrontEndSession,TaggingRules])/.{None|<||>->{}},
				{
					"gateIndex"->gateIndex,
					"clusterIndex"->clusterIndex,
					"gateActive"->gateActive,
					"gatesChanged"->gatesChanged,
					"showInstructions"->showInstructions
				}
			]
		];

		(* Add the recordState function to the tagging rules, along with any button functions we want to test *)
		SetOptions[
			$FrontEndSession,
			TaggingRules->ReplaceRule[
				(TaggingRules/.Options[$FrontEndSession,TaggingRules])/.{None|<||>->{}},
				{"recordState1D"->recordState,"AddGate1D"->addGate,"RemoveGate1D"->removeGate,"AddCluster1D"->addCluster,"RemoveCluster1D"->removeCluster,"UpdateResults1D"->updateResults}
			]
		];

		(* Define helper function that returns a single tab in the domain specification app interface *)
		appInterface=Module[
			{},

			(* Assemble the center column for the gating interface *)
			gatingInterface=Grid[
				{
					(* Dimension selectors *)
					{
							Dynamic@Row[
								{
									(* X-Axis selector *)
									Labeled[
										PopupMenu[
											(* Changing app1Ddim1 first triggers saving the active gate by storing its static values *)
											Dynamic[
												app1Ddim1,
												{
													(
														If[
															!MatchQ[gateIndex,None],
															Part[gates,clusterIndex,gateIndex,2]=Setting@Part[gates,clusterIndex,gateIndex,2];
															gateIndex=None;
															gateActive=False;

															(* Reset the locator *)
															pts={};

														];
													)&,
													(app1Ddim1=#)&,
													None
												}
											],
											MapIndexed[First@#2->#1&,dimensionDisplayNames],
											Sequence@@popupMenuDefaultOps,
											ImageSize->Automatic
										],
										"X-Axis",
										Left
									]
								}
							]
						},
						{
							Pane[
								Grid[
								{
									{

									Dynamic[

										(* Add locator pane wrapped around histogram graphic *)
										LocatorPane[

											(* Moving the boundary triggers turning off the usage instructions and rendering the current gates obsolete *)
											Dynamic[
												pts,
												{
													(* Before *)
													showInstructions=False;gateActivelyMoving=True;&,

													(* During *)
													Automatic,

													(* After *)
													gatesChanged=True;
													gateActivelyMoving=False;
													setGates[gates];&
												}
											],

											Dynamic[

												(* Display the 1D projected data *)
												With[

													(* Bin data into 10 bins and get counts *)
													{
														histogram=HistogramList[Part[allData,All,app1Ddim1],25],
														color=Part[partitionColors,clusterIndex]
													},

													Show[

														(* Histogram active decision boundary *)
														Histogram[
															If[
																(* If the gate is actively being moved, just show the overall split below/above the gate *)
																gateActive&&gateActivelyMoving,
																SortBy[GatherBy[Part[allData,All,app1Ddim1],#<=(First[pts])&],First],

																(* Otherwise, overlay histograms of all partitions, along with any excluded data points *)
																Join[{Part[excludedData,All,app1Ddim1]},Part[#,All,app1Ddim1]&/@(Values@clusteredData)]
															],
															25,
															Automatic,

															(* Set the histogram bar colors *)
															ChartStyle->If[
																gateActive&&gateActivelyMoving,

																(* If the boundary is actively being moved, use light grey for excluded points and either the active gate color (domain specification) or partition color for included points *)
																If[
																	MatchQ[Part[gates,clusterIndex,gateIndex,3],Below],
																	{Switch[method,Automatic,Lighter[activeGateColor,0.8],Manual,Part[partitionColors,clusterIndex]],excludedColor},
																	{excludedColor,Switch[method,Automatic,Lighter[activeGateColor,0.8],Manual,Part[partitionColors,clusterIndex]]}
																],
																(* If the boundary is not being moved, color the partitions according to their colors, prepending grey for the excluded data *)
																Prepend[partitionColors,excludedColor]
															],
															Frame->{True,True,False,False},
															FrameLabel->{Dynamic[Part[dimensionDisplayNames,app1Ddim1],TrackedSymbols:>{app1Ddim1}],"Number of Points"},

															(* Add and format the decision boundary line *)
															GridLines->{If[gateActive,{First[pts]},{}],{}},
															GridLinesStyle->Directive[
																Thick,Dashed,
																(* Line is the active gate color in Automatic mode, and takes the corresponding cluster color in Manual mode *)
																Switch[method,Automatic,activeGateColor,Manual,Part[partitionColors,clusterIndex]]
															],
															Method->{"GridLinesInFront"->True},
															PlotRange->{MinMax@First[histogram],{0,Max[Last[histogram]]}},
															PlotRangePadding->{Automatic,{0,Automatic}},
															ImageSize->Large,
															PassOptions[EmeraldHistogram,Histogram,{}]
														],

														(* Overlay usage instructions if a gate is active but no boundary has been drawn *)
														Graphics@If[
															TrueQ@showInstructions,
															{
																White,Opacity[0.8],Rectangle[Sequence@@Transpose[{MinMax[First@histogram,Scaled[-0.05]],MinMax[Last@histogram,Scaled[-0.2]]}]],
																Opacity[1],Style[Text["Click+Drag to move the threshold",{Mean[MinMax@First@histogram],Mean[MinMax@Last@histogram]}],FontFamily->"Arial",FontSize->largeFontSize,FontColor->baseFontColor]
															},
															{}
														],

														(* Specify fixed ImagePadding to make limited room for axes labels *)
														ImagePadding->{{60,5},{60,5}}

													]
												],
												TrackedSymbols:>{app1Ddim1,pts,gateActive,gateActivelyMoving,clusteredData,clusterIndex,showInstructions}
											],
											Enabled->TrueQ@gateActive,
											Appearance->None
										],
										TrackedSymbols:>{gateActive,app1Ddim1}
									]

									}
								}
							],
							(* Set the size of the histogram plot *)
							Alignment->{Center,Center},
							ImageSize->{500,325},
							ImageSizeAction->"ResizeToFit"
							]
						}
					},
					(* Set spacing between dimension selectors and plot graphics *)
					Spacings->{Automatic,{2->1}},
					Alignment->{Center,Center}
			];

			(* Generate and return the app interface *)
			Dynamic[
					Grid[
						{
							{

								(* Add tables describing the input data, the clustering method, and the result *)
								Pane[
									Grid[
										{
											{Style["Input Data",Bold],SpanFromLeft},
											{"Number of Data Points",Length@allData},
											{"Number of Dimensions",numberOfDimensions},
											{"Global SSR",Dynamic@globalSSR},
											{Style["Result",Bold],SpanFromLeft},
											{"Number of Points Excluded",Dynamic[Length@excludedIndices]},
											{"Number of Clusters",Dynamic[If[Length@clusteredData==0,"NA",Length@clusteredData]]},
											{"Mean Cluster Size",Dynamic[If[Length@clusteredData==0,"NA",N@Mean[Length/@clusteredData]]]},
											{"Within Cluster SSR",Dynamic@If[Length@clusteredData==0,"NA",SSR]},
											Sequence@@If[
												MatchQ[method,Automatic],
												{
													{Style["Clustering Method",Bold],SpanFromLeft},
													{"Algorithm",Lookup[packet,ClusteringAlgorithm]},
													{"Clustered Dimensions",StringJoin@@(Riffle[ToString/@Lookup[packet,ClusteredDimensions],","])},
													{"Distance Function",Lookup[packet,DistanceFunction]},

													(* Add algorithm-specific sub options *)
													Sequence@@Switch[
														Lookup[packet,ClusteringAlgorithm],
														DBSCAN,{
															{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]},
															{"NeighborsNumber",Lookup[ops,NeighborsNumber]}
														},
														MeanShift,{{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]}},
														Spectral,{{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]}},
														Agglomerate,{{"Dissimilarity Function",With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]]}},
														SpanningTree,{{"Max Edge Length",Lookup[ops,MaxEdgeLength]}},
														GaussianMixture,{
															{"Covariance Type",Lookup[ops,CovarianceType]},
															{"Max Iterations",Lookup[ops,MaxIterations]}
														},
														SPADE,{
															{"Density Threshold",Lookup[ops,DensityResamplingThreshold]},
															{"Outlier Density",Lookup[ops,OutlierDensityQuantile]},
															{"Target Density",Lookup[ops,TargetDensityQuantile]},
															{"Dissimilarity Function",With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]]}
														},
														_,{}
													]
												},
												{}
											]
										},
										Alignment->{{Left,Right},Center},
										Background->{{},{
											tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,
											tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,
											Sequence@@If[MatchQ[method,Automatic],{tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor},{}]
											}
										},
										Frame->All,
										FrameStyle->{Thick,White},
										ItemSize->{{Automatic,Automatic},2},
										BaseStyle->{FontSize->smallFontSize}
									],

									(* Fix pane dimensions to max height of 500px, after which it scrolls *)
									ImageSize->{UpTo[375],UpTo[500]},
									ImageSizeAction->"Scrollable"
								],

								(* Display gating interface in the middle *)
								Column[
									{
										gatingInterface
									},
									Alignment->Center
								],

								(* Display cluster information on the right *)
								Pane[Column[Select[Join[

									(* If we are doing automatic clustering, then show a summary table with per-cluster statistics and subclustering buttons *)
									If[MatchQ[method,Automatic],
										(* A table summarizing the number of points in each cluster. The function below generates each row. *)
										{Dynamic@Grid[
											{
												{
													Style["Clustering Summary",{Thick,Bold,White}],
													If[TrueQ[nestedQ],SpanFromLeft,Nothing],
													If[TrueQ[nestedQ],SpanFromLeft,Nothing]
												},
												Sequence@@MapIndexed[
													Function[{dataPts,dataIdx},
														With[
															{
																clusterName=Quiet@Check[
																	(* Use cluster name if available *)
																	Part[PreviewValue[dv,ClusterLabels],First[dataIdx]],
																	(* Otherwise, use group + Index *)
																	"Group "<>ToString[First[dataIdx]]
																]
															},
															{
																StringJoin[
																	clusterName,
																	" ("<>ToString[Length[dataPts]]<>" points)"
																],
																If[TrueQ[nestedQ],Spacer[1],Nothing],
																If[TrueQ[nestedQ]&&!subclusterExistsQ[dv,clusterName],
																	Framed[
																		Button[
																			Style["\[LowerRightArrow] Analyze Subclusters",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																			updateSubclusters[dv,clusterName,myPacket,ops],
																			Method->"Queued",
																			Appearance->"Frameless",
																			FrameMargins->5,
																			Background->Lighter[Part[partitionColors,First[dataIdx]],0.8]
																		],
																		FrameStyle->Directive[Thick,buttonColor],
																		FrameMargins->None
																	],
																	Nothing
																]
															}
														]
													],
													Values[clusteredData]
												]
											},
											Alignment->{{Left,Center,Right},Center},
											Background->{{},
												{
													menuHeaderColor,
													Sequence@@MapIndexed[Lighter[Part[partitionColors,First[#2]],0.8]&,Values[clusteredData]]
												}
											},
											FrameStyle->{Thick,White},
											Dividers->{{1->White,-1->White},White},
											Spacings->{{2,{}},Automatic},
											ItemSize->{If[TrueQ[nestedQ],Automatic,25.75],2}
										]},

										(* Empty lists hides this element when Method->Manual *)
										{}
									],

									(* For each cluster, build a table interface for selecting gates *)
									Function[{partitionTableIndex},

										(* Hide the partition-specific tables if no gates have been defined *)
										If[MatchQ[gates,{{}}],
											Null,

											(* Table 1 *)
											Grid[
												{
													(* Title Grid *)
													{
														Item[
															Grid[
																{
																	{
																		(* Add a button that removes this partition *)
																		Item[
																			Button[
																				Style["\[Times]",Thick,Large,White],
																				removeCluster[partitionTableIndex],

																				(* Button appearance *)
																				Appearance->"Frameless",
																				BaseStyle->{Bold,Thick,White},
																				ContentPadding->False
																			],
																			Alignment->{Left,Center}
																		],

																		(* Partition table label *)
																		Item[
																			Style[
																				Switch[
																					method,
																					Automatic,
																					"Domain Constraints",
																					Manual,
																					Dynamic[StringJoin[
																						Quiet@Check[
																							(* Use cluster name if available *)
																							Part[PreviewValue[dv,ClusterLabels],partitionTableIndex],
																							(* Otherwise, use group + Index *)
																							"Group "<>ToString[partitionTableIndex]
																						],
																						" ("<>ToString[Length@Lookup[clusteredData,partitionTableIndex,{}]]<>" points)"
																					]]
																				],
																				Thick,Bold,White
																			],
																			Alignment->{Left,Center}
																		]
																	}
																},
																Background->None
															],
															Alignment->Left
														],

														(* Add some spans to account for all the columns in the table below *)
														SpanFromLeft,SpanFromLeft,SpanFromLeft
													},

													(* Table Rows (individual gates) *)
													Sequence@@MapIndexed[
														List[

															(* Add a button that removes the gate *)
															Button[
																Style["\[Times]",Thick,Large,buttonColor],

																removeGate[partitionTableIndex,First[#2]],

																(* Button appearance *)
																Appearance->"Frameless",
																BaseStyle->{Bold,Thick}
															],

															(* Display a radial button that can be used to select this particular gate and cluster *)
															Item[
																Labeled[
																	RadioButton[
																		Dynamic[
																			{gateIndex,clusterIndex},
																			{
																				(* Before updating gateIndex, save the previous gate by storing its static value *)
																				Function[val,
																					If[
																						!MatchQ[gateIndex,None],
																						Part[gates,clusterIndex,gateIndex,2]=Setting@Part[gates,clusterIndex,gateIndex,2];
																					];

																					(* Toggle off the usage instructions *)
																					showInstructions=False;

																				],

																				(* While updating gateIndex, switch to the new gate's dimensions *)
																				Function[val,
																					gateActive=False;
																					app1Ddim1=Part[#1,1];

																					(* Update the gate and cluster indices *)
																					clusterIndex=Last@val;
																					gateIndex=First@val;

																					(* Link the active gate to the locator *)
																					pts={Setting@Part[gates,clusterIndex,gateIndex,2],0.5};
																					Part[gates,clusterIndex,gateIndex,2]=Dynamic[First[pts]];

																				],

																				(* After updating gateIndex, make the gate active again *)
																				Function[val,gateActive=True;]
																			}
																		],
																		{First[#2],partitionTableIndex}
																	],
																	StringForm["Gate `1`",First[#2]],
																	Right
																],
																Alignment->{Center,Center}
															],

															(* Display the gate dimensions using dropdown menus that allow the user to set the corresponding dimension *)
															Labeled[
																PopupMenu[
																	Dynamic[
																		Part[gates,partitionTableIndex,First[#2],1],
																		{
																			None,
																			(* Set the corresponding gate dimension *)
																			Function[val,Part[gates,partitionTableIndex,First[#2],1]=val;],
																			(* Once it's set, if the current gate is active, switch to those dimensions *)
																			Function[
																				val,
																				If[
																					MatchQ[clusterIndex,partitionTableIndex]&&MatchQ[gateIndex,First[#2]],

																					(* Change the corresponding dimension *)
																					app1Ddim1=val;
																				];

																				(* Toggle the plot status to obsolete *)
																				gatesChanged=True;

																				(* Log the preview changes *)
																				setGates[gates];
																			]
																		}
																	],
																	MapIndexed[Function[{name,idx},First[idx]->name],dimensionDisplayNames],
																	Sequence@@popupMenuDefaultOps
																],
																Style["X",Bold],
																Left
															],

															(* Display the gate type with a popup menu that allows the user to set its value to either Include or Exclude *)
															PopupMenu[
																Dynamic[
																	Part[gates,partitionTableIndex,First[#2],3],
																	{
																		gateActivelyMoving=True;&,
																		Automatic,
																		(
																			gatesChanged=True;
																			gateActivelyMoving=False;
																			setGates[gates];
																		)&
																	}
																],
																{
																	Below->Style["Include Below",Black],
																	Above->Style["Include Above",Black]
																}
															]

														]&,
														Part[gates,partitionTableIndex]
													],

													{
														(* Add a button in the bottom left corner that creates a new gate *)
														Dynamic@Item[Row[{
															(* If manually gating, include the subcluster analysis button here *)
															With[
																{
																	clusterName=Quiet@Check[
																		(* Use cluster name if available *)
																		Part[PreviewValue[dv,ClusterLabels],partitionTableIndex],
																		(* Otherwise, use group + Index *)
																		"Group "<>ToString[partitionTableIndex]
																	]
																},
																If[MatchQ[method,Manual]&&TrueQ[nestedQ]&&!subclusterExistsQ[dv,clusterName],
																	Sequence@@{
																		Framed[
																			Button[
																				Style["\[LowerRightArrow] Analyze Subclusters",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																				updateSubclusters[dv,clusterName,myPacket,ops];,
																				Method->"Queued",
																				Appearance->"Frameless",
																				FrameMargins->5,
																				Background->Switch[method,Automatic,menuRowColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]]
																			],
																			FrameStyle->Directive[Thick,buttonColor],
																			FrameMargins->None
																		],
																		Spacer[15]
																	},
																	Nothing
																]
															],
															Framed[
																Button[
																	Style["+ Add Gate",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																	addGate[partitionTableIndex],
																	Appearance->"Frameless",
																	FrameMargins->5,
																	Background->Switch[method,Automatic,menuRowColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]]
																],
																FrameStyle->Directive[Thick,buttonColor],
																FrameMargins->None
															]
															}],
															Alignment->{Left,Center}
														],
														SpanFromLeft,
														SpanFromLeft,
														SpanFromLeft
													}
												},

												(* In domain specification mode, set the title row to dark gray and all other rows to light gray *)
												(* In manual gating mode, set the title row to the corresponding cluster color, and all other rows to a lighter shade of the cluster color *)
												Background->{
													None,
													Dynamic@Join[
														{
															1->Switch[method,Automatic,menuHeaderColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.5]],
															(Length@Part[gates,partitionTableIndex])+2->White
														},
														Table[
															i+1->Switch[
																method,
																Automatic,menuRowColor,
																Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]
															],
															{i,Length@Part[gates,partitionTableIndex]+1}
														]
													]
												},
												Frame->{All,All},
												FrameStyle->White,
												Spacings->{2,1},
												Alignment->{Center,Center}
											]
										]

									(* Build a table for each partition by mapping the function over all clusters *)
									]/@Range[Length@gates],


									(* If we are in either manual gating mode or domain specification mode without any constraints, include an "Add Cluster/Add Domain Constraints" button in the bottom right *)
									{
										If[
											MatchQ[method,Manual]||(MatchQ[method,Automatic]&&Length@Part[gates,1]==0),
											Grid[{{
												Item[
													Framed[
														Button[
															Style[
																Switch[method,Automatic,"+ Add Domain Constraints",Manual,"+ Add Cluster"],
																Thick,Bold,FontSize->buttonFontSize,FontColor->If[MatchQ[gates,{{}}],Part[partitionColors,1],buttonColor]
															],

															(* Add a cluster initialized with a default gate *)
															If[
																MatchQ[gates,{{}}],

																(* If there aren't any gates but we have an empty first cluster, just add a gate *)
																addGate[1],

																(* Otherwise add a new cluster and a gate *)
																addCluster[];addGate[Length[gates]]
															],

															Appearance->"Frameless",
															FrameMargins->5,
															Background->None
														],
														FrameStyle->Directive[Thick,If[MatchQ[gates,{{}}],Part[partitionColors,1],buttonColor]],
														FrameMargins->None
													],
													Alignment->{Left,Center}
												]
												}},
												Alignment->Left,
												Background->None
											]
										]
									},

									(* Include an "Update Results" button in the bottom right that synchronizes the plot with the current gate definition, along with a status update *)
									{
										Dynamic[
											With[
												{
													(* Track how the widget definition of either Domain or ManualGates was changed by the user *)
													gatesChangedViaWidget=!MatchQ[Replace[gates,gate:_Dynamic:>Setting@gate,{3}],getGates[]],
													gatesChangedViaApp=gatesChanged
												},

												Grid[{{
													Item[
														Framed[
															Button[
																Style[
																	"Update Results",
																	Thick,Bold,FontSize->buttonFontSize,
																	FontColor->If[gatesChangedViaApp||gatesChangedViaWidget,buttonColor,buttonInactiveColor]
																],
																updateResults[],
																Appearance->"Frameless",
																FrameMargins->5,
																Background->None,

																(* Disable button if the displayed results are up to date *)
																Enabled->gatesChangedViaApp||gatesChangedViaWidget,
																Method->"Queued"
															],
															FrameStyle->Directive[Thick,If[gatesChangedViaApp||gatesChangedViaWidget,buttonColor,buttonInactiveColor]],
															FrameMargins->None
														],
														Alignment->{Left,Center}
													],

													(* Display any warning/error messages *)
													Spacer[10],
													Which[

														(* If the currently displayed results are not up to date, display a warning *)
														gatesChangedViaApp,
														Style["Warning: Results expired, please update.",Red],

														(* If the currently displayed results are not up to date, display a warning *)
														gatesChangedViaWidget,
														Style[StringForm["Warning: `` has changed, please update.",Switch[method,Automatic,Domain,Manual,ManualGates]],Red],

														(* If all input data were excluded, display a warning *)
														Length[includedIndices]==0,
														Style["Warning: The specified gates exclude all data points.",Red],

														(*  Otherwise, there aren't any issues so don't show a message *)
														True,
														Style["",baseFontColor]
													]
													}},
													Alignment->{Left,Center},
													Background->None
												]
											],
											TrackedSymbols:>{dv,gatesChanged}
										]
									}
									],
									notNullQ],

									(* Make all items have the same width *)
									ItemSize->{All,Automatic},

									(* Set spacing between partition tables *)
									Spacings->{Sequence@@Table[1,{Length@gates}],1,1}
									],

									(* Fix pane dimensions to max height of 500px, after which it scrolls *)
									ImageSize->{UpTo[600],UpTo[500]},
									ImageSizeAction->"Scrollable"
								]
							}
						},
						Alignment->{Center,Top},
						Spacings->{{0,2,2},Automatic}
					],
					TrackedSymbols:>{gates,app1Ddim1,gatingInterface}
			]

		];

		(* Return the app interface *)
		appInterface,

		(* Inherit scope from outermost context so we can set and retrieve the PreviewValues *)
		InheritScope->True
	]

];


(* ::Subsubsection:: *)
(*build2DGatingApp*)


(* Define a helper function that takes a packet and constructs a dynamic module for interactive partitioning of data by drawing 2D polygonal gates *)
build2DGatingApp[myPacket_,myOps_,myMethod_:Manual,dv_]:=Module[
	{dimensionLabels,rawClusterLabels,clusterLabels,clusteredDimensions,initialGates,initialIncludedIndices,initialExcludedIndices,initialIncludedData,initialExcludedData,initialPartitionIndices,initialOutlierIndices,initialClusteredData},

	(* Unpack dimension and cluster labels *)
	dimensionLabels=Lookup[myPacket,DimensionLabels];
	rawClusterLabels=ClusterLabels/.Lookup[myPacket,UnresolvedOptions,{}];
	clusterLabels=If[MatchQ[rawClusterLabels,Automatic|ClusterLabels|Null|{}],
		Lookup[myPacket,ClusterLabels],
		rawClusterLabels
	];

	(* Retrieve clustered dimensions for default view *)
	clusteredDimensions=Lookup[myPacket,ClusteredDimensions];

	(* Extract initial gate lists *)
	initialGates=Switch[
		myMethod,
		Manual,
		Cases[#,TwoDimensionalGateP]&/@Replace[Lookup[myOps,ManualGates],Null->{{}}],

		(* Wrap domain constraints in an additional outer list so they're treated as a single cluster *)
		Automatic,
		{Cases[Replace[Lookup[myOps,Domain],Null->{{}}],TwoDimensionalGateP]}
	];

	(* Determine which points are included vs excluded by the gates *)
	initialExcludedIndices=excludedByManualGates[Lookup[myPacket,PreprocessedData],initialGates];
	initialIncludedIndices=Complement[Range[Length@Lookup[myPacket,PreprocessedData]],initialExcludedIndices];
	initialExcludedData=Part[Lookup[myPacket,PreprocessedData],initialExcludedIndices];
	initialIncludedData=Part[Lookup[myPacket,PreprocessedData],initialIncludedIndices];

	(* Compute initial partition indices *)
	initialPartitionIndices=First[partitionData[initialIncludedData,myOps]];

	(* Move any outliers into excludedData (this is because some algorithms, like DBSCAN, exclude outliers) *)
	initialOutlierIndices=First/@Position[initialPartitionIndices,_Missing,-1];
	initialExcludedIndices=Join[initialExcludedIndices,Part[initialIncludedIndices,initialOutlierIndices]];
	initialExcludedData=Part[Lookup[myPacket,PreprocessedData],initialExcludedIndices];
	initialIncludedIndices=Part[initialIncludedIndices,Complement[Range[Length@initialIncludedIndices],initialOutlierIndices]];
	initialIncludedData=Part[Lookup[myPacket,PreprocessedData],initialIncludedIndices];
	initialPartitionIndices=Select[initialPartitionIndices,!MatchQ[#,_Missing]&];

	(* Use partition indices to assemble the original data into partitions *)
	initialClusteredData=Association@MapIndexed[First@#2->#1&,SortBy[GatherBy[Thread[{initialPartitionIndices,initialIncludedData}],First],#[[1,1]]&][[All,All,-1]]];

	(* Construct and return interactive app *)
	DynamicModule[
		{
			packet=myPacket,
			ops=myOps,
			method=myMethod,

			(* Input data *)
			allData=Lookup[myPacket,PreprocessedData],
			includedData=initialIncludedData,
			excludedData=initialExcludedData,

			(* Indices of included and excluded data points *)
			excludedIndices=initialExcludedIndices,
			includedIndices=initialIncludedIndices,
			outlierIndices,

			(* Clustering result *)
			partitionIndices=initialPartitionIndices,
			clusteredData=initialClusteredData,

			(* Performance metrics (sum of squared residuals) *)
			globalSSR=evaluateWithinClusterSumOfSquares[Association@{"Group 1"->initialIncludedData},{DistanceFunction->Lookup[myPacket,DistanceFunction]}],
			SSR=evaluateWithinClusterSumOfSquares[initialClusteredData,{DistanceFunction->Lookup[myPacket,DistanceFunction]}],

			(* Gating interface components *)
			gateControls,
			appInterface,
			gatingInterface,

			(* Projection components *)
			numberOfDimensions=Lookup[myPacket,NumberOfDimensions],
			clusterNames=clusterLabels,
			dimensionDisplayNames=truncateString[#,12]&/@(If[MatchQ[dimensionLabels,None],StringJoin["Dimension ",ToString[#]]&/@Range[Lookup[myPacket,NumberOfDimensions]],dimensionLabels]),
			dimensionUnits=Lookup[myPacket,DimensionUnits],

			(* Actual dynamic variables *)
			polygon,

			(* Dynamic components *)
			gateActive=False,
			activeGateGraphics,
			polygonGraphics,
			gateIndex=None,

			(* Initialize the cluster index *)
			clusterIndex=1,

			(* Inherit any provided gates *)
			gates=initialGates,

			(* Toggles for density projections *)
			xDensity=False,
			yDensity=False,

			(* Add dynamic variable for locator position *)
			pts={0,0},

			(* Add toggle for tracking whether the gates were changed within the app *)
			gatesChanged=False,

			(* Add functions triggered by button clicks *)
			addGate,removeGate,addCluster,removeCluster,updateResults,setGates,getGates,recordState
		},

		(* Define helper functions that retrieves the current preview value for 'gates' *)
		getGates[]:=Switch[
			method,
			Automatic,{Cases[PreviewValue[dv,Domain],TwoDimensionalGateP]},
			Manual,Cases[#,TwoDimensionalGateP]&/@PreviewValue[dv,ManualGates]
		];

		(* Define helper functions that logs the current preview value for 'gates' *)
		setGates[gates_]:=LogPreviewChanges[
			dv,
			{
				Switch[
					method,
					Automatic,Domain->First[Replace[gates,gate:_Dynamic:>Setting@gate,{3}]],
					Manual,ManualGates->Replace[gates,gate:_Dynamic:>Setting@gate,{3}]
				]
			}
		];

		(* Add gate button *)
		addGate[partitionTableIndex_]:=DynamicModule[
			{},

			(* Save the current active gate by setting it to its static value *)
			If[
				!MatchQ[gateIndex,None],
				Part[gates,clusterIndex,gateIndex,3]=Setting@Part[gates,clusterIndex,gateIndex,3];

				(* If the current active gate has fewer than 3 points, delete it *)
				If[
					Length@Part[gates,clusterIndex,gateIndex,3,1]<3,
					Part[gates,clusterIndex]=Drop[Part[gates,clusterIndex],{gateIndex}];
				];
			];

			(* Add a gate to this partition *)
			AppendTo[Part[gates,partitionTableIndex],{app2Ddim1,app2Ddim2,Polygon[{}],Include}];

			(* Update the active gate index and cluster index and the number of gates in the current cluster *)
			clusterIndex=partitionTableIndex;
			gateIndex=Length@Part[gates,partitionTableIndex];

			(* Link the active polygon to the locator *)
			pts=Setting@Part[gates,clusterIndex,gateIndex,3,1];
			Part[gates,clusterIndex,gateIndex,3]=Dynamic[Polygon[pts]];

			(* Activate the gate *)
			gateActive=True;

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Remove gate button *)
		removeGate[partitionTableIndex_,removedGateIndex_]:=DynamicModule[
			{},

			(* Remove the gate *)
			Part[gates,partitionTableIndex]=Drop[Part[gates,partitionTableIndex],{removedGateIndex}];

			(* If a different gate than the one that was deleted was active, update the gate index appropriately *)
			gateIndex=Which[

				(* If the deleted gate belongs to a different cluster than the active gate, don't change anything *)
				clusterIndex!=partitionTableIndex,
				gateIndex,

				(* If no gate is currently active, keep it that way *)
				MatchQ[gateIndex,None],
				None,

				(* If the active gate was deleted, set the gate Index to None *)
				gateIndex==removedGateIndex,
				None,

				(* If the active gate has a higher index than the deleted gate, decrement its index *)
				gateIndex>removedGateIndex,
				gateIndex-1,

				(* If the active gate has a lower index, no need to do anything *)
				gateIndex<removedGateIndex,
				gateIndex

			];

			(* Deactivate the gate *)
			If[
				MatchQ[gateIndex,None],
				gateActive=False;
				pts={};
			];

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Add cluster button *)
		addCluster[]:=DynamicModule[
			{},

			(* Save the current active gate by setting it to its static value *)
			If[
				!MatchQ[gateIndex,None],
				Part[gates,clusterIndex,gateIndex,3]=Setting@Part[gates,clusterIndex,gateIndex,3];

				(* If the current active gate has fewer than 3 points, delete it *)
				If[
					Length@Part[gates,clusterIndex,gateIndex,3,1]<3,
					Part[gates,clusterIndex]=Drop[Part[gates,clusterIndex],{gateIndex}];
				];
			];

			(* Add an empty partition *)
			AppendTo[gates,{}];

			(* Update the active gate and cluster indices and the number of gates in the current cluster *)
			clusterIndex=Length@gates;
			gateIndex=None;
			gateActive=False;
			pts={};

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Remove cluster button *)
		removeCluster[partitionTableIndex_]:=DynamicModule[
			{},

			(* Remove the partition *)
			gates=Drop[gates,{partitionTableIndex}];

			(* If no partitions remain, add back an empty one *)
			gates=If[
				Length@gates==0,
				Append[gates,{}],
				gates
			];

			(* If the deleted partition was active, set the gate index to None *)
			gateIndex=If[
				clusterIndex!=partitionTableIndex,
				gateIndex,
				None
			];

			(* If a gate was deactivated, change the gateActive flag so the graphic stops rendering *)
			gateActive=If[
				MatchQ[gateIndex,None],
				False,
				gateActive
			];

			(* Reset the locator *)
			If[
				!TrueQ@gateActive,
				pts={};
			];

			(* Update the cluster index *)
			clusterIndex=Which[

				(* If the deleted partition was active, default to the last partition *)
				clusterIndex==partitionTableIndex,
				Length@gates,

				(* If the deleted partition has a higher index than the active partition, don't do anything *)
				clusterIndex<partitionTableIndex,
				clusterIndex,

				(* If deleted partition had a lower index than the active partition, decrement the active partition index *)
				clusterIndex>partitionTableIndex,
				clusterIndex-1

			];

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Define function called by Update Results button *)
		updateResults[]:=DynamicModule[
			{},

			(* Retrieve gates from Preview *)
			gates=getGates[];

			(* If there's an active gate, link it to the click locator *)
			If[
				gateActive,
				Quiet[
					Check[
						(* Try to link the locator to the active gate *)
						pts=Part[gates,clusterIndex,gateIndex,3,1];
						{app2Ddim1,app2Ddim2}=Part[gates,clusterIndex,gateIndex,{1,2}];
						Part[gates,clusterIndex,gateIndex,3]=Dynamic[Polygon[pts]];,

						(* If it doesn't work (due to gate definitions changing), deactivate all gates *)
						gateActive=False;
						gateIndex=None;
					]
				]
			];

			(* Update which points are included vs excluded by the gates *)
			excludedIndices=excludedByManualGates[allData,Replace[gates,gate:_Dynamic:>Setting@gate,{3}]];
			includedIndices=Complement[Range[Length@allData],excludedIndices];
			excludedData=Part[allData,excludedIndices];
			includedData=Part[allData,includedIndices];

			(* Partition the data *)
			Quiet[
				partitionIndices=First[partitionData[includedData,ReplaceRule[ops,ManualGates->Replace[gates,gate:_Dynamic:>Setting@gate,{3}]]]],
				{AnalyzeClusters::GatesOverlap}
			];

			(* Move any outliers into excludedData (e.g. some algorithms, like DBSCAN, exclude outliers) *)
			outlierIndices=First/@Position[partitionIndices,_Missing,-1];
			excludedIndices=Join[excludedIndices,Part[includedIndices,outlierIndices]];
			excludedData=Part[allData,excludedIndices];
			includedIndices=Part[includedIndices,Complement[Range[Length@includedIndices],outlierIndices]];
			includedData=Part[allData,includedIndices];
			partitionIndices=Select[partitionIndices,!MatchQ[#,_Missing]&];

			(* Use partition indices to assemble the original data into partitions *)
			clusteredData=Association@MapIndexed[First@#2->#1&,SortBy[GatherBy[Thread[{partitionIndices,includedData}],First],#[[1,1]]&][[All,All,-1]]];

			(* Evaluate SSR *)
			SSR=evaluateWithinClusterSumOfSquares[clusteredData,{DistanceFunction->Lookup[packet,DistanceFunction]}];

			(* Toggle plot as updated *)
			gatesChanged=False;,

			InheritScope->True
		];

		(* Define a function that records the state of the app, its variables, and functions by stashing them in the front end tagging rules *)
		recordState[]:=SetOptions[
			$FrontEndSession,
			TaggingRules->ReplaceRule[
				(TaggingRules/.Options[$FrontEndSession,TaggingRules])/.{None|<||>->{}},
				{
					"gateIndex"->gateIndex,
					"clusterIndex"->clusterIndex,
					"gateActive"->gateActive,
					"gatesChanged"->gatesChanged
				}
			]
		];

		(* Add the recordState function to the tagging rules, along with any button functions we want to test *)
		SetOptions[
			$FrontEndSession,
			TaggingRules->ReplaceRule[
				(TaggingRules/.Options[$FrontEndSession,TaggingRules])/.{None|<||>->{}},
				{"recordState2D"->recordState,"AddGate2D"->addGate,"RemoveGate2D"->removeGate,"AddCluster2D"->addCluster,"RemoveCluster2D"->removeCluster,"UpdateResults2D"->updateResults}
			]
		];

		(* Define helper function that returns a single tab in the domain specification app interface *)
		appInterface=Module[
			{},

			(*  Draw all gates except the active one, colored in accordance with the corresponding cluster and labeled with the corresponding gate ID *)
			polygonGraphics=Graphics@Dynamic[
				Reap@MapIndexed[
					Function[
						{cluster,clusterID},
						MapIndexed[
							Function[
								{gate,gateID},

								If[
									(* If the gate exists within the current dimensions and is not the active gate, render it *)
									MatchQ[Sort@Part[gate,{1,2}],Sort@{app2Ddim1,app2Ddim2}]&&Length[Part[gate,3,1]]>=3,
									Sow[
										drawPolygon[
											(* Transpose the gate if the dimensions are flipped *)
											If[MatchQ[Part[gate,{1,2}],{app2Ddim1,app2Ddim2}],Part[gate,3],Part[gate,3]/.{Polygon[pts_]:>Polygon[Reverse[pts,2]]}],
											Last@gate,

											(* Depending on the mode, set the polygon color *)
											Switch[method,
												(* In the manual gating mode, use the partition colors *)
												Manual,partitionColors[[First@clusterID]],
												(* In the Domain Specification mode, set inclusion gates to black and exclusion gates to red *)
												Automatic,If[MatchQ[Part[gate,4],Include],Black,Red]
											],

											(* Use the gate ID if we are drawing Domains, and the cluster ID if we are ID'ing clusters *)
											Switch[method,
												(* ClusterID is always 1 for Automatic, so use the gate ID*)
												Automatic,First@gateID,
												(* If manually gating, then use the cluster labels, defaulting to index if labels cannot be found *)
												Manual,Quiet@Check[
													(* Strip the "group" off of default labels *)
													StringReplace[ToString@Part[PreviewValue[dv,ClusterLabels],First@clusterID],"Group "~~d:DigitCharacter:>d],
													First@clusterID
												]
											],

											(* Use the polygon color as the line color, and color the label red if it's an exclusion gate *)
											Automatic,
											If[MatchQ[Part[gate,4],Include],Black,Red]
										]
									]
								]
							],
							cluster
						]
					],
					gates
				],
				TrackedSymbols:>{app2Ddim1,app2Ddim2,gates,dv}
			];

			(* Draw the active gate using higher opacity and a thicker border *)
			activeGateGraphics=Graphics@Dynamic@If[
				TrueQ@gateActive&&Length[pts]>1,
				With[
					(* Depending on the mode, set the gate color *)
					{
						(* In domain specification mode, the active gate's face is either black (include) or red (exclude) while its edge is the active gate color. In manual gating mode, it takes the associated cluster color.  *)
						gateFaceColor=Switch[method,Automatic,If[MatchQ[Part[gates,clusterIndex,gateIndex,4],Include],Black,Red],Manual,Part[partitionColors,clusterIndex]],
						gateEdgeColor=Switch[method,Automatic,activeGateColor,Manual,Part[partitionColors,clusterIndex]],
						fontColor=If[MatchQ[Part[gates,clusterIndex,gateIndex,4],Include],Black,Red]
					},
					{
						EdgeForm[{Thick,gateEdgeColor}],
						FaceForm[{Opacity[.1],gateFaceColor}],

						(* If the active gate has <3 points, draw a line. Otherwise draw the polygon *)
						If[
							Length[pts]<3,
							Sequence@@{Thick,gateEdgeColor,Line[pts]},
							Part[gates,clusterIndex,gateIndex,3]
						],
						Text[
							Style[
								(* Use the gate ID if we are drawing Domains, and the cluster ID if we are ID'ing clusters *)
								Switch[method,
									(* ClusterID is always 1 for Automatic, so use the gate ID*)
									Automatic,ToString@gateIndex,
									(* If manually gating, then use the cluster labels, defaulting to index if labels cannot be found *)
									Manual,Quiet@Check[
										(* Strip the "group" off of default labels *)
										StringReplace[ToString@Part[PreviewValue[dv,ClusterLabels],clusterIndex],"Group "~~d:DigitCharacter:>d],
										ToString@clusterIndex
									]
								],
								FontSize->largeFontSize,
								FontWeight->Bold,
								FontColor->fontColor
							],
							Mean@pts
						]
					}
				],
				{}
			];

			(* Display projected data with gates overlayed *)
			gatingInterface=Grid[
				{
					{
						(* Dimension selector panel *)
						Dynamic@Row[{
							(* X-Axis selector *)
							Labeled[
								PopupMenu[
									(* Changing app2Ddim1 first triggers saving the active gate by storing its static values *)
									Dynamic[
										app2Ddim1,
										{
											(
												If[
													!MatchQ[gateIndex,None],
														Part[gates,clusterIndex,gateIndex,3]=Setting@Part[gates,clusterIndex,gateIndex,3];
														gateIndex=None;
														gateActive=False;

														(* Reset the locator *)
														pts={};
												];
											)&,
												(app2Ddim1=#)&,
												None
										}
									],
									Select[MapIndexed[First@#2->#1&,dimensionDisplayNames],!MemberQ[{app2Ddim2},First[#]]&],
									Sequence@@popupMenuDefaultOps,
									ImageSize->Automatic
								],
								"X-Axis",
								Left
							],
							Spacer[30],

							(* Y-Axis selector *)
							Labeled[
								PopupMenu[
									(* Changing app2Ddim2 first triggers saving the active gate by storing its static values *)
									Dynamic[
										app2Ddim2,
										{
											(
												If[
													!MatchQ[gateIndex,None],
													Part[gates,clusterIndex,gateIndex,3]=Setting@Part[gates,clusterIndex,gateIndex,3];
													gateIndex=None;
													gateActive=False;

													(* Reset the locator *)
													pts={};
												];
											)&,
											(app2Ddim2=#)&,
											None
										}
									],
									Select[MapIndexed[First@#2->#1&,dimensionDisplayNames],!MemberQ[{app2Ddim1},First[#]]&],
									Sequence@@popupMenuDefaultOps,
									ImageSize->Automatic
								],
								"Y-Axis",
								Left
							]
						}]
					},

					(* Density projection checkboxes *)
					{
						Grid[
							{
								{
									Labeled[Checkbox[Dynamic[xDensity]],"X Density",Right],
									Labeled[Checkbox[Dynamic[yDensity]],"Y Density",Right]
								}
							},
							Alignment->{Center,Center}
						]
					},

					(* Assemble gating interface *)
					{
							Pane[
								Grid[
								{
									{

									Dynamic[

										(* Add locator pane wrapped around 2D projection graphic *)
										LocatorPane[
											Dynamic[pts,{None,Automatic,gatesChanged=True;setGates[gates];&}],

											Show[

												(* Display the 2D projected data *)
												ListPlot[
													Repeat[{},Length[clusterNames]],
													PassOptions[
														EmeraldListLinePlot,
														ListPlot,
														{
															(* Add dynamic frame labels *)
															FrameLabel->{
																Dynamic[Part[dimensionDisplayNames,app2Ddim1],TrackedSymbols:>{app2Ddim1}],
																Dynamic[Part[dimensionDisplayNames,app2Ddim2],TrackedSymbols:>{app2Ddim2}]
															},
															FrameUnits->{
																Dynamic[Part[dimensionUnits,app2Ddim1],TrackedSymbols:>{app2Ddim1}],
																Dynamic[Part[dimensionUnits,app2Ddim2],TrackedSymbols:>{app2Ddim2}]
															},
															(* Styling options *)
															Frame->{{True,False},{True,False}},
															Joined->False,
															AspectRatio->1/GoldenRatio,
															ImageSize->Large
														}
													]
												],

												(* Add the inactive gates *)
												polygonGraphics,

												(* Add the active gate *)
												activeGateGraphics,

												(* Overlay usage instructions *)
												With[
													(* Assemble bounding box for text positioning *)
													{
														xmin=First@MinMax[Part[allData,All,app2Ddim1],Scaled[-0.1]],
														xmax=Last@MinMax[Part[allData,All,app2Ddim1],Scaled[-0.1]],
														ymin=First@MinMax[Part[allData,All,app2Ddim2],Scaled[-0.1]],
														ymax=Last@MinMax[Part[allData,All,app2Ddim2],Scaled[-0.1]]
													},
													(* If a gate is active but no points have been added, display the usage instructions *)
													Graphics@Dynamic[
														If[
															TrueQ@gateActive&&Length[Setting@pts]==0,
															{
																White,Opacity[0.8],Rectangle[{xmin,ymin},{xmax,ymax}],
																Opacity[1],Style[Text["Click to add a vertex\nClick+Drag to move a vertex\nCtrl+Click to remove a vertex",{Mean[{xmin,xmax}],Mean[{ymin,ymax}]}],FontFamily->"Arial",FontSize->largeFontSize,FontColor->baseFontColor]
															},
															{}
														],
														TrackedSymbols:>{gateActive,pts}
													]
												],

												(* Add marginal distributions if xDensity or yDensity are True *)
												With[
													{
														(* Compute domain for X/Y marginal distributions *)
														xDomain=Subdivide[Sequence@@(MinMax[Part[allData,All,app2Ddim1],Scaled[.1]]),100][[5;;95]],
														yDomain=Subdivide[Sequence@@(MinMax[Part[allData,All,app2Ddim2],Scaled[.1]]),100][[5;;95]],
														xmin=First@MinMax[Part[allData,All,app2Ddim1],Scaled[.1]],
														xmax=Last@MinMax[Part[allData,All,app2Ddim1],Scaled[.1]],
														ymin=First@MinMax[Part[allData,All,app2Ddim2],Scaled[.1]],
														ymax=Last@MinMax[Part[allData,All,app2Ddim2],Scaled[.1]]
													},
													Graphics@Dynamic@{

														(* Add the active marginal distributions *)
														Thick,partitionColors[[1]],
														Sequence@@Pick[
															{
																(* Evaluate PDFs for X/Y marginal distributions, then rescale each so its height is ~10% of the width or height of the respective axis *)
																Line[MapThread[{#1,#2}&,{xDomain,(Rescale[PDF[SmoothKernelDistribution[Part[allData,All,app2Ddim1]],xDomain]]*(0.1*(ymax-ymin)))+ymax}]],
																Line[MapThread[{#1,#2}&,{(Rescale[PDF[SmoothKernelDistribution[Part[allData,All,app2Ddim2]],yDomain]]*(0.1*(xmax-xmin)))+xmax,yDomain}]]
															},
															{TrueQ@xDensity,TrueQ@yDensity}
														]
													}
												],

												(* Set the plot range *)
												PlotRange->{MinMax[Part[allData,All,app2Ddim1],Scaled[.1]],MinMax[Part[allData,All,app2Ddim2],Scaled[.1]]},
												PlotRangePadding->None,
												PlotRangeClipping->False,

												(* Add the scattered point data as a prolog *)
												Prolog->Dynamic[
													{
														PointSize[0.01],

														(* Add excluded data using light gray *)
														Dynamic[Point[Part[excludedData,All,{app2Ddim1,app2Ddim2}],VertexColors->Table[excludedColor,{Length@excludedIndices}]],TrackedSymbols:>{app2Ddim1,app2Ddim2,excludedData}],

														(* Add included data using corresponding partition colors *)
														Dynamic[
															Point[
																Part[includedData,All,{app2Ddim1,app2Ddim2}],
																VertexColors->Part[partitionColors,partitionIndices]
															],
															TrackedSymbols:>{app2Ddim1,app2Ddim2,includedData,partitionIndices}
														]
													},
													TrackedSymbols:>{app2Ddim1,app2Ddim2}
												],

												(* Pad the image beyond the PlotRange if marginal X/Y distributions are present *)
												ImagePadding->{
													{60,If[TrueQ@yDensity,(50*GoldenRatio),10]},
													{50,If[TrueQ@xDensity,50,10]}
												}

											],
											LocatorAutoCreate->All,
											Enabled->TrueQ@gateActive,
											Appearance->Style["\[CircleDot]",Switch[method,Automatic,activeGateColor,Manual,Part[partitionColors,clusterIndex]],24]
										],
										TrackedSymbols:>{activeGateGraphics,polygonGraphics,xDensity,yDensity,gateActive,app2Ddim1,app2Ddim2}
									]
									}
								}
							],
							(* Set the size of the 2D plot *)
							Alignment->{Center,Center},
							ImageSize->{500,325},
							ImageSizeAction->"ResizeToFit"
							]
						}
				},
				(* Set spacing between dimension selectors and plot graphics *)
				Spacings->{Automatic,{2->0.5,3->1}},
				Alignment->{Center,Center}
			];

			(* Generate and return the app interface *)
			Dynamic[
					Grid[
						{
							{

								(* Display a table describing the input data, the clustering method, and the result *)
								Pane[
									Grid[
										{
											{Style["Input Data",Bold],SpanFromLeft},
											{"Number of Data Points",Length@allData},
											{"Number of Dimensions",numberOfDimensions},
											{"Global SSR",Dynamic@globalSSR},
											{Style["Result",Bold],SpanFromLeft},
											{"Number of Points Excluded",Dynamic[Length@excludedIndices]},
											{"Number of Clusters",Dynamic[If[Length@clusteredData==0,"NA",Length@clusteredData]]},
											{"Mean Cluster Size",Dynamic[If[Length@clusteredData==0,"NA",N@Mean[Length/@clusteredData]]]},
											{"Within Cluster SSR",Dynamic@If[Length@clusteredData==0,"NA",SSR]},
											Sequence@@If[
												MatchQ[method,Automatic],
												{
													{Style["Clustering Method",Bold],SpanFromLeft},
													{"Algorithm",Lookup[packet,ClusteringAlgorithm]},
													{"Clustered Dimensions",StringJoin@@(Riffle[ToString/@Lookup[packet,ClusteredDimensions],","])},
													{"Distance Function",Lookup[packet,DistanceFunction]},

													(* Add algorithm-specific sub options *)
													Sequence@@Switch[
														Lookup[packet,ClusteringAlgorithm],
														DBSCAN,{
															{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]},
															{"NeighborsNumber",Lookup[ops,NeighborsNumber]}
														},
														MeanShift,{{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]}},
														Spectral,{{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]}},
														Agglomerate,{{"Dissimilarity Function",With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]]}},
														SpanningTree,{{"Max Edge Length",Lookup[ops,MaxEdgeLength]}},
														GaussianMixture,{
															{"Covariance Type",Lookup[ops,CovarianceType]},
															{"Max Iterations",Lookup[ops,MaxIterations]}
														},
														SPADE,{
															{"Density Threshold",Lookup[ops,DensityResamplingThreshold]},
															{"Outlier Density",Lookup[ops,OutlierDensityQuantile]},
															{"Target Density",Lookup[ops,TargetDensityQuantile]},
															{"Dissimilarity Function",With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]]}
														},
														_,{}
													]
												},
												{}
											]
										},
										Alignment->{{Left,Right},Center},
										Background->{{},{
											tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,
											tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,
											Sequence@@If[MatchQ[method,Automatic],{tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor},{}]
											}
										},
										Frame->All,
										FrameStyle->{Thick,White},
										ItemSize->{{Automatic,Automatic},2},
										BaseStyle->{FontSize->smallFontSize}
									],

									(* Fix pane dimensions to max height of 500px, after which it scrolls *)
									ImageSize->{UpTo[375],UpTo[500]},
									ImageSizeAction->"Scrollable"
								],

								(* Display gating interface in the middle *)
								Column[
									{
										gatingInterface
									},
									Alignment->Center
								],

								(* Tabulate user defined gates on the right *)
								Pane[Column[Select[Join[

									(* If we are doing automatic clustering, then show a summary table with per-cluster statistics and subclustering buttons *)
									If[MatchQ[method,Automatic],
										(* A table summarizing the number of points in each cluster. The function below generates each row. *)
										{Dynamic@Grid[
											{
												{
													Style["Clustering Summary",{Thick,Bold,White}],
													If[TrueQ[nestedQ],SpanFromLeft,Nothing],
													If[TrueQ[nestedQ],SpanFromLeft,Nothing]
												},
												Sequence@@MapIndexed[
													Function[{dataPts,dataIdx},
														With[
															{
																clusterName=Quiet@Check[
																	(* Use cluster name if available *)
																	Part[PreviewValue[dv,ClusterLabels],First[dataIdx]],
																	(* Otherwise, use group + Index *)
																	"Group "<>ToString[First[dataIdx]]
																]
															},
															{
																StringJoin[
																	clusterName,
																	" ("<>ToString[Length[dataPts]]<>" points)"
																],
																If[TrueQ[nestedQ],Spacer[1],Nothing],
																If[TrueQ[nestedQ]&&!subclusterExistsQ[dv,clusterName],
																	Framed[
																		Button[
																			Style["\[LowerRightArrow] Analyze Subclusters",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																			updateSubclusters[dv,clusterName,myPacket,ops];,
																			Method->"Queued",
																			Appearance->"Frameless",
																			FrameMargins->5,
																			Background->Lighter[Part[partitionColors,First[dataIdx]],0.8]
																		],
																		FrameStyle->Directive[Thick,buttonColor],
																		FrameMargins->None
																	],
																	Nothing
																]
															}
														]
													],
													Values[clusteredData]
												]
											},
											Alignment->{{Left,Center,Right},Center},
											Background->{{},
												{
													menuHeaderColor,
													Sequence@@MapIndexed[Lighter[Part[partitionColors,First[#2]],0.8]&,Values[clusteredData]]
												}
											},
											FrameStyle->{Thick,White},
											Dividers->{{1->White,-1->White},White},
											Spacings->{{2,{}},Automatic},
											ItemSize->{If[TrueQ[nestedQ],Automatic,33.6],2}
										]},

										(* Empty lists hides this element when Method->Manual *)
										{}
									],

									(* Define a helper function that takes a cluster index and builds a table containing a row for each of that cluster's gates, then map it over all the clusters. We have to explicitly define the mapped function
									because there are nested map operations occurring within each table which would conflict with the shorthand #& syntax. *)
									Function[
										{partitionTableIndex},

										(* Hide the partition-specific tables if no gates have been defined *)
										If[
											MatchQ[gates,{{}}],Null,

											Grid[
											{
												(* Title Grid *)
												{

												Item[
													Grid[
													{
														{
															(* Add a button that removes this partition *)
															Item[
																Button[
																	Style["\[Times]",Thick,Large,White],
																	removeCluster[partitionTableIndex],

																	(* Button appearance *)
																	Appearance->"Frameless",
																	BaseStyle->{Bold,Thick,White},
																	ContentPadding->False
																],
																Alignment->{Left,Center}
															],

															(* Partition table label *)
															Item[
																Style[
																	Switch[method,
																		Automatic,
																		"Domain Constraints",
																		Manual,
																		Dynamic[StringJoin[
																			Quiet@Check[
																				(* Use cluster name if available *)
																				Part[PreviewValue[dv,ClusterLabels],partitionTableIndex],
																				(* Otherwise, use group + Index *)
																				"Group "<>ToString[partitionTableIndex]
																			],
																			" ("<>ToString[Length@Lookup[clusteredData,partitionTableIndex,{}]]<>" points)"
																		]]
																	],
																	Thick,Bold,White
																],
																Alignment->{Left,Center}
															]
														}
													},
													Background->None
												],
												Alignment->Left

												],

												(* Add some spans to account for all the columns in the table below *)
												SpanFromLeft,SpanFromLeft,SpanFromLeft
												},

												(* Table Rows (individual gates) *)
												Sequence@@MapIndexed[
													List[

														(* Add a button that removes the gate *)
														Button[
															Style["\[Times]",Thick,Large,buttonColor],

															removeGate[partitionTableIndex,First[#2]],

															(* Button appearance *)
															Appearance->"Frameless",
															BaseStyle->{Bold,Thick}
														],

														(* Display a radial button that can be used to select this particular gate and cluster *)
														Item[
															Labeled[
																RadioButton[
																	Dynamic[
																		{gateIndex,clusterIndex},
																		{
																			(* Before updating gateIndex, save the previous gate by storing its static value *)
																			Function[val,
																				If[
																					!MatchQ[gateIndex,None],
																					Part[gates,clusterIndex,gateIndex,3]=Setting@Part[gates,clusterIndex,gateIndex,3];
																				];

																			],

																			(* While updating gateIndex, switch to the new gate's dimensions *)
																			Function[val,
																				gateActive=False;
																				{app2Ddim1,app2Ddim2}=Part[#1,{1,2}];

																				(* Update the gate and cluster indices *)
																				clusterIndex=Last@val;
																				gateIndex=First@val;

																				(* Link the active polygon to the locator *)
																				pts=Setting@Part[gates,clusterIndex,gateIndex,3,1];
																				Part[gates,clusterIndex,gateIndex,3]=Dynamic[Polygon[pts]];

																			],

																			(* After updating gateIndex, make the gate active again *)
																			Function[val,gateActive=True;]
																		}
																	],
																	{First[#2],partitionTableIndex}
																],
																StringForm["Gate `1`",First[#2]],
																Right
															],
															Alignment->{Center,Center}
														],

														(* Display the gate dimensions using dropdown menus that allow the user to set the corresponding dimension *)
														Labeled[
															PopupMenu[
																Dynamic[
																	Part[gates,partitionTableIndex,First[#2],1],
																	{
																		None,
																		(* Set the corresponding gate dimension *)
																		Function[val,Part[gates,partitionTableIndex,First[#2],1]=val;],
																		(* Once it's set, if the current gate is active, switch to those dimensions *)
																		Function[
																			val,
																			If[
																				MatchQ[clusterIndex,partitionTableIndex]&&MatchQ[gateIndex,First[#2]],

																				(* Change the corresponding dimension *)
																				app2Ddim1=val;
																			];

																			(* Toggle the plot status to obsolete and update the preview *)
																			gatesChanged=True;
																			setGates[gates];
																		]
																	}
																],
																Select[MapIndexed[Function[{name,idx},First[idx]->name],dimensionDisplayNames],Function[rule,!MemberQ[Part[gates,partitionTableIndex,First[#2],{2}],First[rule]]]],
																Sequence@@popupMenuDefaultOps
															],
															Style["X",Bold],
															Left
														],

														(* Display the gate dimensions using dropdown menus that allow the user to set the corresponding dimension *)
														Labeled[
															PopupMenu[
																Dynamic[
																	Part[gates,partitionTableIndex,First[#2],2],
																	{
																		None,
																		(* Set the corresponding gate dimension *)
																		Function[val,Part[gates,partitionTableIndex,First[#2],2]=val;],
																		(* Once it's set, if the current gate is active, switch to those dimensions *)
																		Function[
																			val,
																			If[
																				MatchQ[clusterIndex,partitionTableIndex]&&MatchQ[gateIndex,First[#2]],

																				(* Change the corresponding dimension *)
																				app2Ddim2=val;
																			];

																			(* Toggle the plot status to obsolete and update the preview *)
																			gatesChanged=True;
																			setGates[gates];
																		]
																	}
																],
																Select[MapIndexed[Function[{name,idx},First[idx]->name],dimensionDisplayNames],Function[rule,!MemberQ[Part[gates,partitionTableIndex,First[#2],{1}],First[rule]]]],
																Sequence@@popupMenuDefaultOps
															],
															Style["Y",Bold],
															Left
														],

														(* Display the gate type with a popup menu that allows the user to set its value to either Include or Exclude *)
														PopupMenu[
															Dynamic[
																Part[gates,partitionTableIndex,First[#2],4],
																{
																	None,
																	Automatic,
																	gatesChanged=True;setGates[gates];&
																}
															],
															{
																Include->Style["Include Interior",Black],
																Exclude->Style["Exclude Interior",Black]
															}
														]

													]&,
													Part[gates,partitionTableIndex]
												],

												{
													(* Add a button in the bottom left corner that creates a new gate *)
													Dynamic@Item[Row[{
														With[
															{
																clusterName=Quiet@Check[
																	(* Use cluster name if available *)
																	Part[PreviewValue[dv,ClusterLabels],partitionTableIndex],
																	(* Otherwise, use group + Index *)
																	"Group "<>ToString[partitionTableIndex]
																]
															},
															(* If manually gating, include the subcluster analysis button here *)
															If[MatchQ[method,Manual]&&TrueQ[nestedQ]&&!subclusterExistsQ[dv,clusterName],
																Sequence@@{
																	Framed[
																		Button[
																			Style["\[LowerRightArrow] Analyze Subclusters",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																			updateSubclusters[dv,clusterName,myPacket,ops];,
																			Method->"Queued",
																			Appearance->"Frameless",
																			FrameMargins->5,
																			Background->Switch[method,Automatic,menuRowColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]]
																		],
																		FrameStyle->Directive[Thick,buttonColor],
																		FrameMargins->None
																	],
																	Spacer[15]
																},
																Nothing
															]
														],
														Framed[
															Button[
																Style["+ Add Gate",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																addGate[partitionTableIndex],
																Appearance->"Frameless",
																FrameMargins->5,
																Background->Switch[method,Automatic,menuRowColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]]
															],
															FrameStyle->Directive[Thick,buttonColor],
															FrameMargins->None
														]
														}],
														Alignment->{Left,Center}
													],
													SpanFromLeft,
													SpanFromLeft,
													SpanFromLeft
												}
											},

											(* In domain specification mode, set the title row to dark gray and all other rows to light gray *)
											(* In manual gating mode, set the title row to the corresponding cluster color, and all other rows to a lighter shade of the cluster color *)
											Background->{
												None,
												Dynamic@Join[
													{
														1->Switch[method,Automatic,menuHeaderColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.5]],
														(Length@Part[gates,partitionTableIndex])+2->White
													},
													Table[
														i+1->Switch[
															method,
															Automatic,menuRowColor,
															Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]
														],
														{i,Length@Part[gates,partitionTableIndex]+1}
													]
												]
											},
											Frame->{All,All},
											FrameStyle->White,
											Spacings->{2,1},
											Alignment->{Center,Center}
										]
										]

									(* Build a table for each partition by mapping the function over all clusters *)
									]/@Range[Length@gates],

									(* If we are in manual gating mode, include an "Add Cluster" button in the bottom left corner *)
									(* If no gates have been defined, make the button blue *)
									{
										If[
											MatchQ[method,Manual]||(MatchQ[method,Automatic]&&Length@Part[gates,1]==0),
											Grid[{{
												Item[
													Framed[
														Button[
															Style[
																Switch[method,Automatic,"+ Add Domain Constraints",Manual,"+ Add Cluster"],
																Thick,Bold,FontSize->buttonFontSize,FontColor->If[MatchQ[gates,{{}}],Part[partitionColors,1],buttonColor]
															],

															(* Add a cluster initialized with a default gate *)
															If[
																MatchQ[gates,{{}}],

																(* If there aren't any gates but we have an empty first cluster, just add a gate *)
																addGate[1],

																(* Otherwise add a new cluster and a gate *)
																addCluster[];addGate[Length[gates]]
															],
															Appearance->"Frameless",
															FrameMargins->5,
															Background->None
														],
														FrameStyle->Directive[Thick,If[MatchQ[gates,{{}}],Part[partitionColors,1],buttonColor]],
														FrameMargins->None
													],
													Alignment->{Left,Center}
												]
												}},
												Alignment->Left,
												Background->None
											]
										]
									},

									(* Include an "Update Results" button in the bottom left that synchronizes the plot with the current gate definition, along with any status updates *)
									{
										Dynamic[

											With[
												{
													(* Track how the widget definition of either Domain or ManualGates was changed by the user *)
													gatesChangedViaWidget=!MatchQ[Replace[gates,gate:_Dynamic:>Setting@gate,{3}],getGates[]],
													gatesChangedViaApp=gatesChanged
												},

												Grid[{{
													Item[
														Framed[
															Button[
																Style[
																	"Update Results",
																	Thick,Bold,FontSize->buttonFontSize,
																	FontColor->If[gatesChangedViaApp||gatesChangedViaWidget,buttonColor,buttonInactiveColor]
																],
																updateResults[],
																Appearance->"Frameless",
																FrameMargins->5,
																Background->None,

																(* Disable button if the displayed results are up to date *)
																Enabled->gatesChangedViaApp||gatesChangedViaWidget,
																Method->"Queued"
															],
															FrameStyle->Directive[Thick,If[gatesChangedViaApp||gatesChangedViaWidget,buttonColor,buttonInactiveColor]],
															FrameMargins->None
														],
														Alignment->{Left,Center}
													],

													(* Display any warning/error messages *)
													Spacer[10],
													Which[

														(* If the currently displayed results are not up to date, display a warning *)
														gatesChangedViaApp,
														Style["Warning: Results expired, please update.",Red],

														(* If the currently displayed results are not up to date, display a warning *)
														gatesChangedViaWidget,
														Style[StringForm["Warning: `` has changed, please update.",Switch[method,Automatic,Domain,Manual,ManualGates]],Red],

														(* If all input data were excluded, display a warning *)
														Length[includedIndices]==0,
														Style["Warning: The specified gates exclude all data points.",Red],

														(*  Otherwise, there aren't any issues so don't show a message *)
														True,
														Style["",baseFontColor]
													]
													}},
													Alignment->{Left,Center},
													Background->None
												]
											],
											TrackedSymbols:>{dv,gatesChanged}
										]
									}

								],
								notNullQ],

								(* Set spacing between partition tables *)
								Spacings->{Sequence@@Table[1,{Length@gates}],1,1}
								],

								(* Fix pane dimensions to max height of 500px, after which it scrolls *)
								ImageSize->{Automatic,UpTo[500]},
								ImageSizeAction->"Scrollable"
								]

							}
						},
						Alignment->{Center,Top},
						Spacings->{{0,2,2},Automatic}
					],
					TrackedSymbols:>{gates,app2Ddim1,app2Ddim2,gatingInterface}
			]

		];

		(* Return the app interface *)
		appInterface,

		(* Inherit scope from outermost context so we can set and retrieve the PreviewValues *)
		InheritScope->True
	]
];


(* ::Subsubsection:: *)
(*build3DGatingApp*)


(* Define a helper function that takes a packet and constructs a dynamic module for interactive partitioning of data by drawing 3D gates. The last argument is used to set the mode - "Automatic" restricts gating to a single partition *)
build3DGatingApp[myPacket_,myOps_,myMethod_:Manual,dv_]:=Module[
	{dimensionLabels,rawClusterLabels,clusterLabels,initialBoundingBox,initialGates,initialExcludedIndices,initialIncludedIndices,initialExcludedData,initialIncludedData,initialPartitionIndices,initialOutlierIndices,initialClusteredData},

	(* Unpack dimension labels *)
	dimensionLabels=Lookup[myPacket,DimensionLabels];
	rawClusterLabels=ClusterLabels/.Lookup[myPacket,UnresolvedOptions,{}];
	clusterLabels=If[MatchQ[rawClusterLabels,Automatic|ClusterLabels|Null|{}],
		Lookup[myPacket,ClusterLabels],
		rawClusterLabels
	];

	(* Extract bounds on first three dimensions (used to initialize ellipsoid positioning slider values) *)
	initialBoundingBox=Part[MinMax[#,Scaled[0.1]]&/@Transpose@Lookup[myPacket,PreprocessedData],{1,2,3}];

	(* Extract initial gate lists *)
	initialGates=Switch[
		myMethod,
		Manual,
		Cases[#,ThreeDimensionalGateP]&/@Lookup[myOps,ManualGates],

		(* Wrap domain constraints in an additional outer list so they're treated as a single cluster *)
		Automatic,
		{Cases[Lookup[myOps,Domain],ThreeDimensionalGateP]}
	];

	(* Determine which points are included vs excluded by the gates *)
	initialExcludedIndices=excludedByManualGates[Lookup[myPacket,PreprocessedData],initialGates];
	initialIncludedIndices=Complement[Range[Length@Lookup[myPacket,PreprocessedData]],initialExcludedIndices];
	initialExcludedData=Part[Lookup[myPacket,PreprocessedData],initialExcludedIndices];
	initialIncludedData=Part[Lookup[myPacket,PreprocessedData],initialIncludedIndices];

	(* Compute initial partition indices *)
	initialPartitionIndices=First[partitionData[initialIncludedData,myOps]];

	(* Move any outliers into excludedData (this is because some algorithms, like DBSCAN, exclude outliers) *)
	initialOutlierIndices=First/@Position[initialPartitionIndices,_Missing,-1];
	initialExcludedIndices=Join[initialExcludedIndices,Part[initialIncludedIndices,initialOutlierIndices]];
	initialExcludedData=Part[Lookup[myPacket,PreprocessedData],initialExcludedIndices];
	initialIncludedIndices=Part[initialIncludedIndices,Complement[Range[Length@initialIncludedIndices],initialOutlierIndices]];
	initialIncludedData=Part[Lookup[myPacket,PreprocessedData],initialIncludedIndices];
	initialPartitionIndices=Select[initialPartitionIndices,!MatchQ[#,_Missing]&];

	(* Use partition indices to assemble the original data into partitions *)
	initialClusteredData=Association@MapIndexed[First@#2->#1&,SortBy[GatherBy[Thread[{initialPartitionIndices,initialIncludedData}],First],#[[1,1]]&][[All,All,-1]]];

	(* Construct and return interactive app *)
	DynamicModule[
		{
			packet=myPacket,
			ops=myOps,
			method=myMethod,

			(* Input data *)
			allData=Lookup[myPacket,PreprocessedData],
			includedData=initialIncludedData,
			excludedData=initialExcludedData,

			(* Indices of included and excluded data points *)
			excludedIndices=initialExcludedIndices,
			includedIndices=initialIncludedIndices,
			outlierIndices,

			(* Clustering result *)
			partitionIndices=initialPartitionIndices,
			clusteredData=initialClusteredData,

			(* Performance metrics (sum of squared residuals) *)
			globalSSR=evaluateWithinClusterSumOfSquares[Association@{"Group 1"->initialIncludedData},{DistanceFunction->Lookup[myPacket,DistanceFunction]}],
			SSR=evaluateWithinClusterSumOfSquares[initialClusteredData,{DistanceFunction->Lookup[myPacket,DistanceFunction]}],

			(* Gating interface components *)
			gateControls,
			appInterface,
			gatingInterface,

			(* Projection components *)
			numberOfDimensions=Lookup[myPacket,NumberOfDimensions],
			clusterNames=clusterLabels,
			dimensionDisplayNames=truncateString[#,12]&/@(If[MatchQ[dimensionLabels,None],StringJoin["Dimension ",ToString[#]]&/@Range[Lookup[myPacket,NumberOfDimensions]],dimensionLabels]),
			dimensionUnits=Lookup[myPacket,DimensionUnits],
			projection,

			(* Dynamic components *)
			ellipsoid,
			gateActive=False,
			gateIndex=None,

			(* Initialize the cluster index *)
			clusterIndex=1,

			(* Inherit any provided gates *)
			gates=initialGates,

			(* Toggles for density projections *)
			xyDensity=True,
			yzDensity=False,
			xzDensity=False,

			(* Ellipsoid placement parameters *)
			xy=Part[Mean/@initialBoundingBox,{1,2}],
			z=Part[Mean/@initialBoundingBox,3],
			length=Part[.2*(Last[#]-First[#])&/@initialBoundingBox,1],
			width=Part[.2*(Last[#]-First[#])&/@initialBoundingBox,2],
			height=Part[.2*(Last[#]-First[#])&/@initialBoundingBox,3],
			zAngle=0.0,
			yAngle=0.0,
			xAngle=0.0,

			(* Add toggle for tracking whether the gates were changed within the app *)
			gatesChanged=False,

			(* Add a toggle for overlaying the usage instructions *)
			showInstructions=False,

			(* Add functions triggered by button clicks *)
			addGate,removeGate,addCluster,removeCluster,updateResults,setGates,getGates,recordState

		},

		(* Replace any 3D polygons with fitted ellipsoids *)
		gates=Replace[gates,polygon:_Polygon:>BoundingRegion[First[List@@polygon],"FastEllipsoid"],{3}];

		(* Define helper functions that retrieves the current preview value for 'gates' *)
		getGates[]:=Switch[
			method,
			Automatic,{Cases[PreviewValue[dv,Domain],ThreeDimensionalGateP]},
			Manual,Cases[#,ThreeDimensionalGateP]&/@PreviewValue[dv,ManualGates]
		];

		(* Define helper functions that logs the current preview value for 'gates' *)
		setGates[gates_]:=LogPreviewChanges[
			dv,
			{
				Switch[
					method,
					Automatic,Domain->First[Replace[gates,gate:_Dynamic:>Setting@gate,{3}]],
					Manual,ManualGates->Replace[gates,gate:_Dynamic:>Setting@gate,{3}]
				]
			}
		];

		(* Add gate button *)
		addGate[partitionTableIndex_,bbCenter_,bbRange_]:=DynamicModule[
			{},

			(* Save the current active gate by setting it to its static value *)
			If[
				!MatchQ[gateIndex,None],
				Part[gates,clusterIndex,gateIndex,4]=Setting@Part[gates,clusterIndex,gateIndex,4];
			];

			(* Add a gate to this partition *)
			AppendTo[Part[gates,partitionTableIndex],{app3Ddim1,app3Ddim2,app3Ddim3,Ellipsoid[Setting@bbCenter,0.2*Setting@bbRange],Include}];

			(* Update the active gate index and cluster index and the number of gates in the current cluster *)
			clusterIndex=partitionTableIndex;
			gateIndex=Length@Part[gates,partitionTableIndex];
			gateActive=True;

			(* Inherit slider values from the active gate *)
			{{xy,z},{length,width,height},{zAngle,yAngle,xAngle}}=parseEllipsoid[Setting@Part[gates,clusterIndex,gateIndex,4]];

			(* Link the active gate to the ellipsoid *)
			Part[gates,clusterIndex,gateIndex,4]=Dynamic[
				N@TransformedRegion[
					Ellipsoid[{Sequence@@xy,z},{length,width,height}],
					With[
						{rotation=toAxisAngleForm[RollPitchYawMatrix[{xAngle,yAngle,zAngle}]]},
						If[
							Part[rotation,1]==0,
							RotationTransform[0,{1,0,0}],
							RotationTransform[Sequence@@rotation,{Sequence@@xy,z}]
						]
					]
				]
			];

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Toggle on the usage instructions *)
			showInstructions=True;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Remove gate button *)
		removeGate[partitionTableIndex_,removedGateIndex_,bbCenter_,bbRange_]:=DynamicModule[
			{},

			(* Remove the gate *)
			Part[gates,partitionTableIndex]=Drop[Part[gates,partitionTableIndex],{removedGateIndex}];

			(* If a different gate than the one that was deleted was active, update the gate index appropriately *)
			gateIndex=Which[

				(* If the deleted gate belongs to a different cluster than the active gate, don't change anything *)
				clusterIndex!=partitionTableIndex,
				gateIndex,

				(* If no gate is currently active, keep it that way *)
				MatchQ[gateIndex,None],
				None,

				(* If the active gate was deleted, set the gate Index to None *)
				gateIndex==removedGateIndex,
				None,

				(* If the active gate has a higher index than the deleted gate, decrement its index *)
				gateIndex>removedGateIndex,
				gateIndex-1,

				(* If the active gate has a lower index, no need to do anything *)
				gateIndex<removedGateIndex,
				gateIndex

			];

			(* Update the ellipsoid positioning sliders *)
			If[
				MatchQ[gateIndex,None],

				(* If no active gate remains, reset the slider values *)
				gateActive=False;
				{{xy,z},{length,width,height},{zAngle,yAngle,xAngle}}={{Part[Setting@bbCenter,{1,2}],Part[Setting@bbCenter,3]},0.25*Setting@bbRange,{0.,0.,0.}}
			];

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Toggle off the usage instructions *)
			showInstructions=False;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Add cluster button *)
		addCluster[bbCenter_,bbRange_]:=DynamicModule[
			{},

			(* Save the current active gate by setting it to its static value *)
			If[
				!MatchQ[gateIndex,None],
				Part[gates,clusterIndex,gateIndex,4]=Setting@Part[gates,clusterIndex,gateIndex,4];
			];

			(* Add an empty partition *)
			AppendTo[gates,{}];

			(* Update the active gate and cluster indices and the number of gates in the current cluster *)
			clusterIndex=Length@gates;
			gateIndex=None;
			gateActive=False;

			(* Reset the slider values *)
			{{xy,z},{length,width,height},{zAngle,yAngle,xAngle}}={{Part[Setting@bbCenter,{1,2}],Part[Setting@bbCenter,3]},0.25*Setting@bbRange,{0.,0.,0.}};

			(* Toggle off the usage instructions *)
			showInstructions=False;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Remove cluster button *)
		removeCluster[partitionTableIndex_,bbCenter_,bbRange_]:=DynamicModule[
			{},

			(* Remove the partition *)
			gates=Drop[gates,{partitionTableIndex}];

			(* If no partitions remain, add back an empty one *)
			gates=If[
				Length@gates==0,
				Append[gates,{}],
				gates
			];

			(* If the deleted partition was active, set the gate index to None *)
			gateIndex=If[
				clusterIndex!=partitionTableIndex,
				gateIndex,
				None
			];

			(* Update the cluster index *)
			clusterIndex=Which[

				(* If the deleted partition was active, default to the last partition *)
				clusterIndex==partitionTableIndex,
				Length@gates,

				(* If the deleted partition has a higher index than the active partition, don't do anything *)
				clusterIndex<partitionTableIndex,
				clusterIndex,

				(* If deleted partition had a lower index than the active partition, decrement the active partition index *)
				clusterIndex>partitionTableIndex,
				clusterIndex-1

			];

			(* Update the ellipsoid positioning sliders *)
			If[
				MatchQ[gateIndex,None],

				(* If no active gate remains, reset the slider values *)
				gateActive=False;
				{{xy,z},{length,width,height},{zAngle,yAngle,xAngle}}={{Part[Setting@bbCenter,{1,2}],Part[Setting@bbCenter,3]},0.25*(Setting@bbRange),{0.,0.,0.}}

			];

			(* Toggle the plot status to obsolete *)
			gatesChanged=True;

			(* Toggle off the usage instructions *)
			showInstructions=False;

			(* Log the preview changes to update the appropriate command builder widget *)
			setGates[gates];,

			InheritScope->True
		];

		(* Define function called by Update Results button *)
		updateResults[]:=DynamicModule[
			{},

			(* Retrieve gates from Preview *)
			gates=getGates[];

			(* If there's an active gate, link it to the click locator *)
			If[
				gateActive,
				Quiet[
					Check[
						(* Inherit slider values from the active gate *)
						{{xy,z},{length,width,height},{zAngle,yAngle,xAngle}}=parseEllipsoid[Part[gates,clusterIndex,gateIndex,4]];
						{app3Ddim1,app3Ddim2,app3Ddim3}=Part[gates,clusterIndex,gateIndex,{1,2,3}];

						(* Link the active gate to the gate controls *)
						Part[gates,clusterIndex,gateIndex,4]=Dynamic[
							N@TransformedRegion[
							Ellipsoid[{Sequence@@xy,z},{length,width,height}],
							With[
								{rotation=toAxisAngleForm[RollPitchYawMatrix[{xAngle,yAngle,zAngle}]]},
								If[
									Part[rotation,1]==0,
									RotationTransform[0,{1,0,0}],
									RotationTransform[Sequence@@rotation,{Sequence@@xy,z}]
								]
							]
							]
						];,

						(* If it doesn't work (due to gate definitions changing), deactivate all gates *)
						gateActive=False;
						gateIndex=None;
					]
				]
			];

			(* Update which points are included vs excluded by the gates *)
			excludedIndices=excludedByManualGates[allData,Replace[gates,gate:_Dynamic:>Setting@gate,{3}]];
			includedIndices=Complement[Range[Length@allData],excludedIndices];
			excludedData=Part[allData,excludedIndices];
			includedData=Part[allData,includedIndices];

			(* Partition the data *)
			Quiet[
				partitionIndices=First[partitionData[includedData,ReplaceRule[ops,ManualGates->Replace[gates,gate:_Dynamic:>Setting@gate,{3}]]]],
				{AnalyzeClusters::GatesOverlap}
			];

			(* Move any outliers into excludedData (e.g. some algorithms, like DBSCAN, exclude outliers) *)
			outlierIndices=First/@Position[partitionIndices,_Missing,-1];
			excludedIndices=Join[excludedIndices,Part[includedIndices,outlierIndices]];
			excludedData=Part[allData,excludedIndices];
			includedIndices=Part[includedIndices,Complement[Range[Length@includedIndices],outlierIndices]];
			includedData=Part[allData,includedIndices];
			partitionIndices=Select[partitionIndices,!MatchQ[#,_Missing]&];

			(* Use partition indices to assemble the original data into partitions *)
			clusteredData=Association@MapIndexed[First@#2->#1&,SortBy[GatherBy[Thread[{partitionIndices,includedData}],First],#[[1,1]]&][[All,All,-1]]];

			(* Evaluate SSR *)
			SSR=evaluateWithinClusterSumOfSquares[clusteredData,{DistanceFunction->Lookup[packet,DistanceFunction]}];

			(* Toggle plot as updated *)
			gatesChanged=False;

			(* Toggle off the usage instructions *)
			showInstructions=False;,

			InheritScope->True
		];

		(* Define a function that records the state of the app, its variables, and functions by stashing them in the front end tagging rules *)
		recordState[]:=SetOptions[
			$FrontEndSession,
			TaggingRules->ReplaceRule[
				(TaggingRules/.Options[$FrontEndSession,TaggingRules])/.{None|<||>->{}},
				{
					"gateIndex"->gateIndex,
					"clusterIndex"->clusterIndex,
					"gateActive"->gateActive,
					"gatesChanged"->gatesChanged,
					"showInstructions"->showInstructions
				}
			]
		];

		(* Add the recordState function to the tagging rules, along with any button functions we want to test *)
		SetOptions[
			$FrontEndSession,
			TaggingRules->ReplaceRule[
				(TaggingRules/.Options[$FrontEndSession,TaggingRules])/.{None|<||>->{}},
				{"recordState3D"->recordState,"AddGate3D"->addGate,"RemoveGate3D"->removeGate,"AddCluster3D"->addCluster,"RemoveCluster3D"->removeCluster,"UpdateResults3D"->updateResults}
			]
		];

		(* Define helper function that returns a single tab in the domain specification app interface *)
		appInterface=Module[
			{},

			(* Display projected data with ellipsoids overlayed *)
			gatingInterface=Grid[
				{
					{
							(* Dimension selectors *)
							Dynamic@Row[
								{
									(* X-Axis selector *)
									Labeled[
										PopupMenu[
											(* Changing app3Ddim1 first triggers saving the active gate by storing its static values *)
											Dynamic[
												app3Ddim1,
												{
													(
														If[
															!MatchQ[gateIndex,None],
															Part[gates,clusterIndex,gateIndex,4]=Setting@Part[gates,clusterIndex,gateIndex,4];
															gateIndex=None;
															gateActive=False;
														];
													)&,
													(app3Ddim1=#)&,
													None
												}
											],
											Select[MapIndexed[First@#2->#1&,dimensionDisplayNames],!MemberQ[{app3Ddim2,app3Ddim3},First[#]]&],
											Sequence@@popupMenuDefaultOps,
											ImageSize->Automatic
										],
										"X-Axis",
										Left
									],
									Spacer[30],

									(* Y-Axis selector *)
									Labeled[
										PopupMenu[
											(* Changing app3Ddim2 first triggers saving the active gate by storing its static values *)
											Dynamic[
												app3Ddim2,
												{
													(
														If[
															!MatchQ[gateIndex,None],
															Part[gates,clusterIndex,gateIndex,4]=Setting@Part[gates,clusterIndex,gateIndex,4];
															gateIndex=None;
															gateActive=False;
														];
													)&,
													(app3Ddim2=#)&,
													None
												}
											],
											Select[MapIndexed[First@#2->#1&,dimensionDisplayNames],!MemberQ[{app3Ddim1,app3Ddim3},First[#]]&],
											Sequence@@popupMenuDefaultOps,
											ImageSize->Automatic
										],
										"Y-Axis",
										Left
									],
									Spacer[30],

									(* Z-Axis selector *)
									Labeled[
										PopupMenu[
											(* Changing app3Ddim3 first triggers saving the active gate by storing its static values, then disabling the active ellipsoid *)
											Dynamic[
												app3Ddim3,
												{
													(
														If[
															!MatchQ[gateIndex,None],
															Part[gates,clusterIndex,gateIndex,4]=Setting@Part[gates,clusterIndex,gateIndex,4];
															gateIndex=None;
															gateActive=False;
														];
													)&,
													(app3Ddim3=#)&,
													None
												}
											],
											Select[MapIndexed[First@#2->#1&,dimensionDisplayNames],!MemberQ[{app3Ddim1,app3Ddim2},First[#]]&],
											Sequence@@popupMenuDefaultOps,
											ImageSize->Automatic
										],
										"Z-Axis",
										Left
									]
								}
							]
						},

						(* Density projection checkboxes *)
						{
							Grid[
								{
									{
										Labeled[Checkbox[Dynamic[xyDensity]],"XY Density",Right],
										Labeled[Checkbox[Dynamic[yzDensity]],"YZ Density",Right],
										Labeled[Checkbox[Dynamic[xzDensity]],"XZ Density",Right]
									}
								},
								Alignment->{Center,Center}
							]
					},

					(* Plot all 3D graphics *)
						{
							Pane[
								Grid[
								{
									{
										Dynamic[
											With[
												{
													bb=MinMax[#,Scaled[.1]]&/@(Transpose@Part[allData,All,{app3Ddim1,app3Ddim2,app3Ddim3}])
												},

											Show[

												(* Display the empty 3D axes *)
												ListPointPlot3D[
													{},
													PassOptions[
														EmeraldListPointPlot3D,
														ListPointPlot3D,
														{
															Boxed->False,
															ViewPoint->Front,
															BoxRatios->{1,1,1/GoldenRatio},
															ImageSize->Large
														}
													]
												],

												(* Add the scattered point data *)
												Graphics3D[
													{
														PointSize[0.01],

														(* Color excluded data using light gray *)
														Dynamic[Point[Part[excludedData,All,{app3Ddim1,app3Ddim2,app3Ddim3}],VertexColors->Table[excludedColor,{Length@excludedIndices}]],TrackedSymbols:>{app3Ddim1,app3Ddim2,app3Ddim3,excludedData}],

														(* Color included data by the associated partition color *)
														Dynamic[Point[Part[includedData,All,{app3Ddim1,app3Ddim2,app3Ddim3}],VertexColors->Part[partitionColors,partitionIndices]],TrackedSymbols:>{app3Ddim1,app3Ddim2,app3Ddim3,includedData,partitionIndices}]
													}
												],

												(* Add smoothed XY,YZ,and XZ histograms *)
												Sequence@@Pick[
													{
														Graphics3D[First[SmoothDensityHistogram[Part[allData,All,{app3Ddim1,app3Ddim2}],PlotRange->Part[bb,{1,2}],Mesh->3,MeshStyle->{Red,Dashed},ColorFunction->"SunsetColors",BaseStyle->Opacity[0.5]]]/.{x:_Real,y:_Real}:>{x,y,Part[bb,3,1]}],
														Graphics3D[First[SmoothDensityHistogram[Part[allData,All,{app3Ddim2,app3Ddim3}],PlotRange->Part[bb,{2,3}],Mesh->3,MeshStyle->{Red,Dashed},ColorFunction->"SunsetColors",BaseStyle->Opacity[0.7]]]/.{y:_Real,z:_Real}:>{Part[bb,1,1],y,z}],
														Graphics3D[First[SmoothDensityHistogram[Part[allData,All,{app3Ddim1,app3Ddim3}],PlotRange->Part[bb,{1,3}],Mesh->3,MeshStyle->{Red,Dashed},ColorFunction->"SunsetColors",BaseStyle->Opacity[0.9]]]/.{x:_Real,z:_Real}:>{x,Part[bb,2,2],z}]
													},
													{TrueQ@xyDensity,TrueQ@yzDensity,TrueQ@xzDensity}
												],

												(* Draw active ellipsoid, guide lines, and boundaries between XY/YZ/XZ planes *)
												Graphics3D@If[
													TrueQ@gateActive,
														{
															(* Styling directives for guidelines *)
															Opacity[0.5],Gray,Thickness[Large],

															(* XY plane guide lines *)
															Dynamic@Line[{{First[xy], bb[[2, 1]], bb[[3, 1]]}, {First[xy], bb[[2, 2]],bb[[3, 1]]}}],
															Dynamic@Line[{{bb[[1, 1]], Last[xy], bb[[3, 1]]}, {bb[[1, 2]], Last[xy], bb[[3, 1]]}}],
															Dynamic@Line[{Append[xy,bb[[3,1]]],Append[xy,z]}],

															(* YZ plane guide lines *)
															Sequence@@If[
																TrueQ@yzDensity,
																{
																	Dynamic@Line[{{bb[[1, 1]], Last[xy], bb[[3, 1]]}, {bb[[1, 1]], Last[xy],bb[[3, 2]]}}],
																	Dynamic@Line[{{bb[[1, 1]], bb[[2, 1]], z},{bb[[1, 1]],bb[[2, 2]],z}}]
																},
																{}
															],

															(* XZ plane guide lines *)
															Sequence@@If[
																TrueQ@xzDensity,
																{
																	Dynamic@Line[{{bb[[1, 1]], bb[[2, 2]], z}, {bb[[1, 2]], bb[[2, 2]],z}}],
																	Dynamic@Line[{{First[xy], bb[[2, 2]], bb[[3,1]]},{First[xy],bb[[2, 2]],bb[[3,2]]}}]
																},
																{}
															],

															(* Active ellipsoid - use the partition color if in manual gating mode *)
															Opacity[0.5],Switch[method,Automatic,activeGateColor,Manual,Part[partitionColors,clusterIndex]],
															Part[gates,clusterIndex,gateIndex,4],
															Dynamic@Style[Text[ToString@gateIndex,{First@xy,Last@xy,z}],Black,Bold,18]

														},
														{}
												],

												(* Add white lines dividing XY/YZ, XY/XZ, and YZ/XZ planes *)
												Graphics3D@{
													White,
													Pick[
														{
															Dynamic@Line[{{bb[[1,1]],bb[[2,1]],bb[[3,1]]},{bb[[1,1]],bb[[2,2]],bb[[3,1]]}}],
															Dynamic@Line[{{bb[[1,1]],bb[[2,2]],bb[[3,1]]},{bb[[1,1]],bb[[2,2]],bb[[3,2]]}}],
															Dynamic@Line[{{bb[[1,1]],bb[[2,2]],bb[[3,1]]},{bb[[1,2]],bb[[2,2]],bb[[3,1]]}}]
														},
														{
															TrueQ@xyDensity&&TrueQ@yzDensity,
															TrueQ@yzDensity&&TrueQ@xzDensity,
															TrueQ@xyDensity&&TrueQ@xzDensity
														}
													]
												},

												(* Overlay usage instructions *)
												Epilog->Dynamic[

													(* If a gate is active but the default ellipsoid hasn't been moved, display the usage instructions *)
													If[
														showInstructions,
														{
															White,Opacity[0.8],Rectangle[{-0.2,0.2},{1.2,0.8}],
															Opacity[1],Style[Text["Use the controls below to resize,\nreposition, and rotate the ellipsoid",{.5,.5}],FontFamily->"Arial",FontSize->largeFontSize,FontColor->baseFontColor]
														},
														{}
													],
													TrackedSymbols:>{showInstructions}
												],

												(* Set the plot range *)
												PlotRange->bb,
												PlotRangePadding->None,
												PlotRangeClipping->False,

												(* Add dynamic frame labels *)
												AxesLabel->{
													Dynamic[Part[dimensionDisplayNames,app3Ddim1],TrackedSymbols:>{app3Ddim1}],
													Dynamic[Part[dimensionDisplayNames,app3Ddim2],TrackedSymbols:>{app3Ddim2}],
													Dynamic[Part[dimensionDisplayNames,app3Ddim3],TrackedSymbols:>{app3Ddim3}]
												},
												AxesUnits->{
													Dynamic[Part[dimensionUnits,app3Ddim1],TrackedSymbols:>{app3Ddim1}],
													Dynamic[Part[dimensionUnits,app3Ddim2],TrackedSymbols:>{app3Ddim2}],
													Dynamic[Part[dimensionUnits,app3Ddim3],TrackedSymbols:>{app3Ddim3}]
												},

												(* Specify fixed ImagePadding to make limited room for axes labels *)
												ImagePadding->{{80,10},{50,10}},

												(* Make Graphics3D selectable so they can be manipulated in command builder *)
												Selectable->True

											]
											],
											TrackedSymbols:>{gates,gateActive,xyDensity,yzDensity,xzDensity,app3Ddim1,app3Ddim2,app3Ddim3}
										]
									}
								}
							],
							(* Set the size of the 3D plot, scaling it up 30% if there's no active gate because the gate controls are hidden *)
							Alignment->{Center,Center},
							ImageSize->If[gateActive,{400,250},{533,333}],
							ImageSizeAction->"ResizeToFit"
							]
						}
					},
					(* Set spacing between dimension selectors and plot graphics *)
					Spacings->{Automatic,{2->0.5,3->1}},
					Alignment->{Center,Center}
				];

				(* Define gate control panels. For each control, any update to the dynamically controlled variable triggers gatesChanged to be True *)
				gateControls=Dynamic@With[
					{
						xmin=First@MinMax[Part[allData,All,app3Ddim1],Scaled[.1]],
						xmax=Last@MinMax[Part[allData,All,app3Ddim1],Scaled[.1]],
						ymin=First@MinMax[Part[allData,All,app3Ddim2],Scaled[.1]],
						ymax=Last@MinMax[Part[allData,All,app3Ddim2],Scaled[.1]],
						zmin=First@MinMax[Part[allData,All,app3Ddim3],Scaled[.1]],
						zmax=Last@MinMax[Part[allData,All,app3Ddim3],Scaled[.1]]
					},

					Panel[Grid[
						{
							{
								(* Gate size controls *)
								Column[
									{
										Row[{Style["Gate Size",12,Bold]},Alignment->Center],
										Labeled[Slider[Dynamic[length,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],{0.03*(xmax-xmin),0.5*(xmax-xmin)},ImageSize->Small,Enabled->Dynamic@gateActive],"Length",Left],
										Labeled[Slider[Dynamic[width,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],{0.03*(ymax-ymin),0.5*(ymax-ymin)},ImageSize->Small,Enabled->Dynamic@gateActive],"Width",Left],
										Labeled[Slider[Dynamic[height,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],{0.03*(zmax-zmin),0.5*(zmax-zmin)},ImageSize->Small,Enabled->Dynamic@gateActive],"Height",Left]
									}
								],

								(* Gate positioning controls *)
								Column[
									{
										Row[{Style["Gate Position",12,Bold]},Alignment->Center],
										Row[
											{
												Labeled[Slider2D[Dynamic[xy,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],{{xmin,ymin},{xmax,ymax}},Enabled->Dynamic@gateActive],"XY",Left],
												Spacer[15],
												Labeled[VerticalSlider[Dynamic[z,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],{zmin,zmax},ImageSize->Tiny,Enabled->Dynamic@gateActive],"Z",Left]
											}
										]
									}
								],

								(* Gate rotation controls *)
								Column[
									{
										Row[{Style["Gate Rotation",12,Bold]},Alignment->Center],
										Labeled[Slider[Dynamic[zAngle,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],N@{-Pi,Pi},ImageSize->Small,Enabled->Dynamic@gateActive],"Roll",Left],
										Labeled[Slider[Dynamic[yAngle,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],N@{-Pi,Pi},ImageSize->Small,Enabled->Dynamic@gateActive],"Pitch",Left],
										Labeled[Slider[Dynamic[xAngle,{showInstructions=False;&,Automatic,gatesChanged=True;setGates[gates];&}],N@{-Pi,Pi},ImageSize->Small,Enabled->Dynamic@gateActive],"Yaw",Left]
									}
								]

							}
						},
						Spacings->{5,2}
					],
					Background->tableRowColor,
					ImageMargins->5
					]
				];

				(* Generate and return the app interface *)
				Dynamic[

						With[
							{

								(* Extract the bounding box for the current dimensions and compute the mean and range for each dimension. We need these in advance so we can reset the gate controls to appropriate values *)
								bb={MinMax[Part[allData,All,app3Ddim1],Scaled[0.1]],MinMax[Part[allData,All,app3Ddim2],Scaled[0.1]],MinMax[Part[allData,All,app3Ddim3],Scaled[0.1]]},
								bbCenter=Mean/@{MinMax[Part[allData,All,app3Ddim1],Scaled[0.1]],MinMax[Part[allData,All,app3Ddim2],Scaled[0.1]],MinMax[Part[allData,All,app3Ddim3],Scaled[0.1]]},
								bbRange=(Last[#]-First[#])&/@{MinMax[Part[allData,All,app3Ddim1],Scaled[0.1]],MinMax[Part[allData,All,app3Ddim2],Scaled[0.1]],MinMax[Part[allData,All,app3Ddim3],Scaled[0.1]]}

							},

						Grid[
							{
								{

									(* Add tables describing the input data, the clustering method, and the result on the left *)
									Pane[
										Grid[
											{
												{Style["Input Data",Bold],SpanFromLeft},
												{"Number of Data Points",Length@allData},
												{"Number of Dimensions",numberOfDimensions},
												{"Global SSR",Dynamic@globalSSR},
												{Style["Result",Bold],SpanFromLeft},
												{"Number of Points Excluded",Dynamic[Length@excludedIndices]},
												{"Number of Clusters",Dynamic[If[Length@clusteredData==0,"NA",Length@clusteredData]]},
												{"Mean Cluster Size",Dynamic[If[Length@clusteredData==0,"NA",N@Mean[Length/@clusteredData]]]},
												{"Within Cluster SSR",Dynamic@If[Length@clusteredData==0,"NA",SSR]},
												Sequence@@If[
													MatchQ[method,Automatic],
													{
														{Style["Clustering Method",Bold],SpanFromLeft},
														{"Algorithm",Lookup[packet,ClusteringAlgorithm]},
														{"Clustered Dimensions",StringJoin@@(Riffle[ToString/@Lookup[packet,ClusteredDimensions],","])},
														{"Distance Function",Lookup[packet,DistanceFunction]},

														(* Add algorithm-specific sub options *)
														Sequence@@Switch[
															Lookup[packet,ClusteringAlgorithm],
															DBSCAN,{
																{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]},
																{"NeighborsNumber",Lookup[ops,NeighborsNumber]}
															},
															MeanShift,{{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]}},
															Spectral,{{"Neighborhood Radius",Lookup[ops,NeighborhoodRadius]}},
															Agglomerate,{{"Dissimilarity Function",With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]]}},
															SpanningTree,{{"Max Edge Length",Lookup[ops,MaxEdgeLength]}},
															GaussianMixture,{
																{"Covariance Type",Lookup[ops,CovarianceType]},
																{"Max Iterations",Lookup[ops,MaxIterations]}
															},
															SPADE,{
																{"Density Threshold",Lookup[ops,DensityResamplingThreshold]},
																{"Outlier Density",Lookup[ops,OutlierDensityQuantile]},
																{"Target Density",Lookup[ops,TargetDensityQuantile]},
																{"Dissimilarity Function",With[{f=Lookup[ops,ClusterDissimilarityFunction]},If[MatchQ[f,_Function],f,ToString@f]]}
															},
															_,{}
														]
													},
													{}
												]
											},
											Alignment->{{Left,Right},Center},
											Background->{{},{
												tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,
												tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,
												Sequence@@If[MatchQ[method,Automatic],{tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor},{}]
												}
											},
											Frame->All,
											FrameStyle->{Thick,White},
											ItemSize->{{Automatic,Automatic},2},
											BaseStyle->{FontSize->smallFontSize}
										],

										(* Fix pane dimensions to max height of 500px, after which it scrolls *)
										ImageSize->{UpTo[375],UpTo[500]},
										ImageSizeAction->"Scrollable"
									],

									(* Display gating interface in the middle, hiding the gate controls if there's no active gate *)
									Column[
										Select[
											{
												gatingInterface,
												If[gateActive,Pane@gateControls,Null]
											},
											notNullQ
										],
										Alignment->Center
									],

									(* Generate an interactive table of all gates on the right *)
									Pane[Column[Select[Join[

										(* If we are doing automatic clustering, then show a summary table with per-cluster statistics and subclustering buttons *)
										If[MatchQ[method,Automatic],
											(* A table summarizing the number of points in each cluster. The function below generates each row. *)
											{Dynamic@Grid[
												{
													{
														Style["Clustering Summary",{Thick,Bold,White}],
														If[TrueQ[nestedQ],SpanFromLeft,Nothing],
														If[TrueQ[nestedQ],SpanFromLeft,Nothing]
													},
													Sequence@@MapIndexed[
														Function[{dataPts,dataIdx},
															With[
																{
																	clusterName=Quiet@Check[
																		(* Use cluster name if available *)
																		Part[PreviewValue[dv,ClusterLabels],First[dataIdx]],
																		(* Otherwise, use group + Index *)
																		"Group "<>ToString[First[dataIdx]]
																	]
																},
																{
																	StringJoin[
																		clusterName,
																		" ("<>ToString[Length[dataPts]]<>" points)"
																	],
																	If[TrueQ[nestedQ],Spacer[1],Nothing],
																	If[TrueQ[nestedQ]&&!subclusterExistsQ[dv,clusterName],
																		Framed[
																			Button[
																				Style["\[LowerRightArrow] Analyze Subclusters",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																				updateSubclusters[dv,clusterName,myPacket,ops];,
																				Method->"Queued",
																				Appearance->"Frameless",
																				FrameMargins->5,
																				Background->Lighter[Part[partitionColors,First[dataIdx]],0.8]
																			],
																			FrameStyle->Directive[Thick,buttonColor],
																			FrameMargins->None
																		],
																		Nothing
																	]
																}
															]
														],
														Values[clusteredData]
													]
												},
												Alignment->{{Left,Center,Right},Center},
												Background->{{},
													{
														menuHeaderColor,
														Sequence@@MapIndexed[Lighter[Part[partitionColors,First[#2]],0.8]&,Values[clusteredData]]
													}
												},
												FrameStyle->{Thick,White},
												Dividers->{{1->White,-1->White},White},
												Spacings->{{2,{}},Automatic},
												ItemSize->{If[TrueQ[nestedQ],Automatic,40.9],2}
											]},

											(* Empty lists hides this element when Method->Manual *)
											{}
										],

										(* Define a helper function that takes a cluster index and builds a table containing a row for each of that cluster's gates, then map it over all the clusters. We have to explicitly define the mapped function
										because there are nested map operations occurring within each table which would conflict with the shorthand #& syntax. *)
										Function[
											{partitionTableIndex},

											(* Hide the partition-specific tables if no gates have been defined *)
											If[
												Length[Part[gates,partitionTableIndex]]==0,Null,

												(* Table 1 *)
												Grid[
												{
													(* Title Grid *)
													{

													Item[
														Grid[
														{
															{
																(* Add a button that removes this partition *)
																Item[
																	Button[
																		Style["\[Times]",Thick,Large,White],
																		removeCluster[partitionTableIndex,bbCenter,bbRange],

																		(* Button appearance *)
																		Appearance->"Frameless",
																		BaseStyle->{Bold,Thick,White},
																		ContentPadding->False
																	],
																	Alignment->{Left,Center}
																],

																(* Partition table label *)
																Item[
																	Style[
																		Switch[
																			method,
																			Automatic,
																			"Domain Constraints",
																			Manual,
																			Dynamic[StringJoin[
																				Quiet@Check[
																					(* Use cluster name if available *)
																					Part[PreviewValue[dv,ClusterLabels], partitionTableIndex],
																					(* Otherwise, use group + Index *)
																					"Group "<>ToString[partitionTableIndex]
																				],
																				" ("<>ToString[Length@Lookup[clusteredData,partitionTableIndex,{}]]<>" points)"
																			]]
																		],
																		Thick,Bold,White
																	],
																	Alignment->{Left,Center}
																]
															}
														},
														Background->None
													],
													Alignment->Left

													],

													(* Add some spans to account for all the columns in the table below *)
													SpanFromLeft,SpanFromLeft,SpanFromLeft,SpanFromLeft
													},

													(* Table Rows (individual gates) *)
													Sequence@@MapIndexed[
														List[

															(* Add a button that removes the gate *)
															Button[
																Style["\[Times]",Thick,Large,buttonColor],

																removeGate[partitionTableIndex,First[#2],bbCenter,bbRange],

																(* Button appearance *)
																Appearance->"Frameless",
																BaseStyle->{Bold,Thick}
															],

															(* Display a radial button that can be used to select this particular gate and cluster *)
															Item[
																Labeled[
																	RadioButton[
																		Dynamic[
																			{gateIndex,clusterIndex},
																			{
																				(* Before updating gateIndex, save the previous gate by storing its static value *)
																				Function[val,
																					If[
																						!MatchQ[gateIndex,None],
																						Part[gates,clusterIndex,gateIndex,4]=Setting@Part[gates,clusterIndex,gateIndex,4];
																					];

																					(* Toggle off the usage instructions *)
																					showInstructions=False;
																				],

																				(* While updating gateIndex, switch to the new gate's dimensions *)
																				Function[val,
																					gateActive=False;
																					{app3Ddim1,app3Ddim2,app3Ddim3}=Part[#1,{1,2,3}];

																					(* Update the gate and cluster indices *)
																					clusterIndex=Last@val;
																					gateIndex=First@val;
																					gateActive=True;

																					(* Inherit slider values from the active gate *)
																					{{xy,z},{length,width,height},{zAngle,yAngle,xAngle}}=parseEllipsoid[Setting@Part[gates,clusterIndex,gateIndex,4]];

																					(* Link the active gate to the ellipsoid *)
																					Part[gates,clusterIndex,gateIndex,4]=Dynamic[
																						N@TransformedRegion[
																							Ellipsoid[{Sequence@@xy,z},{length,width,height}],
																							With[
																								{rotation=toAxisAngleForm[RollPitchYawMatrix[{xAngle,yAngle,zAngle}]]},
																								If[
																									Part[rotation,1]==0,
																									RotationTransform[0,{1,0,0}],
																									RotationTransform[Sequence@@rotation,{Sequence@@xy,z}]
																								]
																							]
																						]
																					];
																				],

																				(* After updating gateIndex, make the ellipsoid active again *)
																				Function[val,gateActive=True;]
																			}
																		],
																		{First[#2],partitionTableIndex}
																	],
																	StringForm["Gate `1`",First[#2]],
																	Right
																],
																Alignment->{Center,Center}
															],

															(* Display the gate dimensions using dropdown menus that allow the user to set the corresponding dimension *)
															Labeled[
																PopupMenu[
																	Dynamic[
																		Part[gates,partitionTableIndex,First[#2],1],
																		{
																			None,
																			(* Set the corresponding gate dimension *)
																			Function[val,Part[gates,partitionTableIndex,First[#2],1]=val;],
																			(* Once it's set, if the current gate is active, switch to those dimensions *)
																			Function[
																				val,
																				If[
																					MatchQ[clusterIndex,partitionTableIndex]&&MatchQ[gateIndex,First[#2]],

																					(* Change the corresponding dimension *)
																					app3Ddim1=val;
																				];

																				(* Toggle the plot status to obsolete and update the preview *)
																				gatesChanged=True;
																				setGates[gates];
																			]
																		}
																	],
																	Select[MapIndexed[Function[{name,idx},First[idx]->name],dimensionDisplayNames],Function[rule,!MemberQ[Part[gates,partitionTableIndex,First[#2],{2,3}],First[rule]]]],
																	Sequence@@popupMenuDefaultOps
																],
																Style["X",Bold],
																Left
															],

															(* Display the gate dimensions using dropdown menus that allow the user to set the corresponding dimension *)
															Labeled[
																PopupMenu[
																	Dynamic[
																		Part[gates,partitionTableIndex,First[#2],2],
																		{
																			None,
																			(* Set the corresponding gate dimension *)
																			Function[val,Part[gates,partitionTableIndex,First[#2],2]=val;],
																			(* Once it's set, if the current gate is active, switch to those dimensions *)
																			Function[
																				val,
																				If[
																					MatchQ[clusterIndex,partitionTableIndex]&&MatchQ[gateIndex,First[#2]],
																					(* Change the corresponding dimension *)
																					app3Ddim2=val;
																				];
																				(* Toggle the plot status to obsolete and update the preview *)
																				gatesChanged=True;
																				setGates[gates];
																			]
																		}
																	],
																	Select[MapIndexed[Function[{name,idx},First[idx]->name],dimensionDisplayNames],Function[rule,!MemberQ[Part[gates,partitionTableIndex,First[#2],{1,3}],First[rule]]]],
																	Sequence@@popupMenuDefaultOps
																],
																Style["Y",Bold],
																Left
															],

															(* Display the gate dimensions using dropdown menus that allow the user to set the corresponding dimension *)
															Labeled[
																PopupMenu[
																	Dynamic[
																		Part[gates,partitionTableIndex,First[#2],3],
																		{
																			None,
																			(* Set the corresponding gate dimension *)
																			Function[val,Part[gates,partitionTableIndex,First[#2],3]=val;],
																			(* Once it's set, if the current gate is active, switch to those dimensions *)
																			Function[
																				val,
																				If[
																					MatchQ[clusterIndex,partitionTableIndex]&&MatchQ[gateIndex,First[#2]],
																					(* Change the corresponding dimension *)
																					app3Ddim3=val;
																				];
																				(* Toggle the plot status to obsolete and update the preview *)
																				gatesChanged=True;
																				setGates[gates];
																			]
																		}
																	],
																	Select[MapIndexed[Function[{name,idx},First[idx]->name],dimensionDisplayNames],Function[rule,!MemberQ[Part[gates,partitionTableIndex,First[#2],{1,2}],First[rule]]]],
																	Sequence@@popupMenuDefaultOps
																],
																Style["Z",Bold],
																Left
															],

															(* Display the gate type with a popup menu that allows the user to set its value to either Include or Exclude *)
															PopupMenu[
																Dynamic[
																	Part[gates,partitionTableIndex,First[#2],5],
																	{
																		None,
																		Automatic,
																		(* Toggle the plot status to obsolete and update the preview*)
																		Function[
																			val,
																			gatesChanged=True;
																			setGates[gates];
																		]
																	}
																],
																{
																	Include->Style["Include Interior",Black],
																	Exclude->Style["Exclude Interior",Red]
																}
															]
														]&,
														Part[gates,partitionTableIndex]
													],

													{
														(* Add a button in the bottom left corner that creates a new gate *)
														Dynamic@Item[
															Row[{
																With[
																	{
																		clusterName=Quiet@Check[
																			(* Use cluster name if available *)
																			Part[PreviewValue[dv,ClusterLabels],partitionTableIndex],
																			(* Otherwise, use group + Index *)
																			"Group "<>ToString[partitionTableIndex]
																		]
																	},
																	If[MatchQ[method,Manual]&&TrueQ[nestedQ]&&!subclusterExistsQ[dv,clusterName],
																	(* If manually gating, include the subcluster analysis button here *)

																		Sequence@@{
																			Framed[
																				Button[
																					Style["\[LowerRightArrow] Analyze Subclusters",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																					updateSubclusters[dv,clusterName,myPacket,ops];,
																					Method->"Queued",
																					Appearance->"Frameless",
																					FrameMargins->5,
																					Background->Switch[method,Automatic,menuRowColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]]
																				],
																				FrameStyle->Directive[Thick,buttonColor],
																				FrameMargins->None
																			],
																			Spacer[15]
																		},
																		Nothing
																	]
																],
																Framed[
																	Button[
																		Style["+ Add Gate",Thick,Bold,FontSize->buttonFontSize,FontColor->buttonColor],
																		addGate[partitionTableIndex,bbCenter,bbRange],
																		Appearance->"Frameless",
																		FrameMargins->5,
																		Background->Switch[method,Automatic,menuRowColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]]
																	],
																	FrameStyle->Directive[Thick,buttonColor],
																	FrameMargins->None
																]

															}],
															Alignment->{Left,Center}
														],
														SpanFromLeft,SpanFromLeft,SpanFromLeft,SpanFromLeft
													}
												},

												(* In domain specification mode, set the title row to dark gray and all other rows to light gray *)
												(* In manual gating mode, set the title row to the corresponding cluster color, and all other rows to a lighter shade of the cluster color *)
												Background->{
													None,
													Dynamic@Join[
														{
															1->Switch[method,Automatic,menuHeaderColor,Manual,Lighter[Part[partitionColors,partitionTableIndex],0.5]],
															(Length@Part[gates,partitionTableIndex])+2->White
														},
														Table[
															i+1->Switch[
																method,
																Automatic,menuRowColor,
																Manual,Lighter[Part[partitionColors,partitionTableIndex],0.8]
															],
															{i,Length@Part[gates,partitionTableIndex]+1}
														]
													]
												},
												Frame->{All,All},
												FrameStyle->White,
												Spacings->{2,1},
												Alignment->{Center,Center}
											]
										]

										(* Build a table for each partition by mapping the function over all clusters *)
										]/@Range[Length@gates],

										(* If we are in either manual gating mode or domain specification mode with zero gates, include an "Add Cluster/Add Domain Constraints" button in the bottom left corner *)
										{
											If[
												MatchQ[method,Manual]||(MatchQ[method,Automatic]&&Length@Part[gates,1]==0),
												Grid[{{
													Item[
														Framed[
															Button[
																Style[
																	Switch[method,Automatic,"+ Add Domain Constraints",Manual,"+ Add Cluster"],
																	Thick,Bold,FontSize->buttonFontSize,FontColor->If[MatchQ[gates,{{}}],Part[partitionColors,1],buttonColor]
																],

																(* Add a cluster initialized with a default gate *)
																If[
																	(* If there currently aren't any clusters, just add a gate *)
																	MatchQ[gates,{{}}],addGate[1,bbCenter,bbRange],

																	(* Otherwise, add a cluster and a gate *)
																	addCluster[bbCenter,bbRange];
																	addGate[Length[gates],bbCenter,bbRange]

																],
																Appearance->"Frameless",
																FrameMargins->5,
																Background->None
															],
															FrameStyle->Directive[Thick,If[MatchQ[gates,{{}}],Part[partitionColors,1],buttonColor]],
															FrameMargins->None
														],
														Alignment->{Left,Center}
													]
													}},
													Alignment->Left,
													Background->None
												]
											]
										},

										(* Include an "Update Results" button in the bottom left that synchronizes the plot with the current gate definition, along with any status updates *)
										{
											Dynamic[

												With[
													{
														(* Track how the widget definition of either Domain or ManualGates was changed by the user *)
														gatesChangedViaWidget=!MatchQ[Replace[gates,gate:_Dynamic:>Setting@gate,{3}],getGates[]],
														gatesChangedViaApp=gatesChanged
													},

													Grid[{{
														Item[
															Framed[
																Button[
																	Style[
																		"Update Results",
																		Thick,Bold,FontSize->buttonFontSize,
																		FontColor->If[gatesChangedViaApp||gatesChangedViaWidget,buttonColor,buttonInactiveColor]
																	],
																	updateResults[],
																	Appearance->"Frameless",
																	FrameMargins->5,
																	Background->None,

																	(* Disable button if the displayed results are up to date *)
																	Enabled->gatesChangedViaApp||gatesChangedViaWidget,
																	Method->"Queued"
																],
																FrameStyle->Directive[Thick,If[gatesChangedViaApp||gatesChangedViaWidget,buttonColor,buttonInactiveColor]],
																FrameMargins->None
															],
															Alignment->{Left,Center}
														],

														(* Display any warning/error messages *)
														Spacer[10],
														Which[

															(* If the currently displayed results are not up to date, display a warning *)
															gatesChangedViaApp,
															Style["Warning: Results expired, please update.",Red],

															(* If the currently displayed results are not up to date, display a warning *)
															gatesChangedViaWidget,
															Style[StringForm["Warning: `` has changed, please update.",Switch[method,Automatic,Domain,Manual,ManualGates]],Red],

															(* If all input data were excluded, display a warning *)
															Length[includedIndices]==0,
															Style["Warning: The specified gates exclude all data points.",Red],

															(*  Otherwise, there aren't any issues so don't show a message *)
															True,
															Style["",baseFontColor]
														]
														}},
														Alignment->{Left,Center},
														Background->None
													]
												],
												TrackedSymbols:>{dv,gatesChanged}
											]
										}

									],
									notNullQ],

									(* Set spacing between partition tables *)
									Spacings->{Sequence@@Table[1,{Length@gates}],1,1}

									],

									(* Fix pane dimensions to max height of 500px, after which it scrolls *)
									ImageSize->{Automatic,UpTo[500]},
									ImageSizeAction->"Scrollable"
									]

								}
							},
							Alignment->{Center,Top},
							Spacings->{{0,2,2},Automatic}
						]
						],
						TrackedSymbols:>{gates,app3Ddim1,app3Ddim2,app3Ddim3,gateControls,gateActive}
				]

		];

		(* Return the app interface *)
		appInterface,

		(* Inherit scope from outermost context so we can set and retrieve the PreviewValues *)
		InheritScope->True
	]
];


(* ::Subsubsection:: *)
(*analyzeClustersPreview*)


(* Define an option *)
DefineOptions[analyzeClustersPreview,
	Options:>{
		{NestedClustering->False, BooleanP, "Indicates if nested clustering should be enabled in the preview, i.e. determines if the AnalyzeSubclusters and Remove Subcluster buttons appear."},
		{PreviewSymbol->Null, _, "Reference to the preview symbol (made with SetupPreviewSymbol) that this app should use. If Null, a new preview symbol will be initialized."},
		{ReadOnly->False, BooleanP, "Indicates if this preview app should be read-only, i.e. is not currently linked to the command builder preview."},
		{Enable3DClustering->True, BooleanP, "Indicates if the preview should include the 3D clsutering app."}
	}
];


(* Define helper function that takes an Object[Analysis,Clusters] packet and returns an appropriate TabView *)
analyzeClustersPreview[objectPacket_, previewOps:OptionsPattern[]]:=Module[
	{
		inputPacket,resolvedOps,clusteredDimensions,nestedClusteringQ,suppliedDV,
		defaultTabs,panelWidth=1500,panelHeight=650,app
	},

	(* Strip Replace/Append header from packet keys *)
	inputPacket=stripAppendReplaceKeyHeads[objectPacket];

	(* Lookup values from the packet *)
	resolvedOps=Lookup[inputPacket,ResolvedOptions];
	clusteredDimensions=Lookup[inputPacket,ClusteredDimensions];

	(* Retrieve values from options to analyzeClustersPreview *)
	nestedClusteringQ=OptionValue[NestedClustering];
	suppliedDV=OptionValue[PreviewSymbol];
	defaultTabs={
		"Selector",
		"1D",
		"2D",
		If[OptionValue[Enable3DClustering],"3D",Nothing]
	};

	(* Generate preview for either automated or manual clustering *)
	app=With[
		{
			packet=inputPacket,
			ops=resolvedOps,
			method=Lookup[resolvedOps,Method],
			numberOfDimensions=Lookup[inputPacket,NumberOfDimensions],

			(* Determine which tabs are to be included based on dimensionality of the data *)
			includedTabs=Switch[Lookup[inputPacket,NumberOfDimensions],
				1,{"1D"},
				2,{"1D","2D"},
				_,defaultTabs
			],

			(* Initialize the preview symbol *)
			dv=If[MatchQ[suppliedDV,Null],
				SetupPreviewSymbol[
					AnalyzeClusters,
					Null,
					{
						Domain->Lookup[resolvedOps,Domain],
						ManualGates->Lookup[resolvedOps,ManualGates],
						ClusterLabels->Lookup[resolvedOps,ClusterLabels]
					}
				],
				suppliedDV
			]
		},

		(* Return the app as a dynamic module *)
		DynamicModule[
			{
				(* Set the initial active tab in accordance with the user provided gates. *)
				(* If none were specified, default to selector if it is present, or the highest dimensional tab that is available *)
				activeTab=(
					(* Increment all indices if the selector is included in the preview *)
					If[MemberQ[includedTabs,"Selector"],1,0]+
					Switch[
						Switch[method,
							Automatic,{Lookup[resolvedOps,Domain]},
							Manual,Lookup[resolvedOps,ManualGates]
						],
						{{OneDimensionalGateP..}..},1,
						{{TwoDimensionalGateP..}..},2,
						{{ThreeDimensionalGateP..}..},3,
						_,If[MemberQ[includedTabs,"Selector"],0,Min[numberOfDimensions,2]]
					]
				),

				(* Whether or not subclustering buttons should appear *)
				nestedQ=nestedClusteringQ,

				(* Initial active dimensions for the 1D app *)
				app1Ddim1=FirstOrDefault[clusteredDimensions,1],

				(* Initial active dimensions for the 2D app *)
				app2Ddim1=If[Length[clusteredDimensions]>=2,Part[clusteredDimensions,1],1],
				app2Ddim2=If[Length[clusteredDimensions]>=2,Part[clusteredDimensions,2],2],

				(* Initial active dimensions for the 3D app *)
				app3Ddim1=If[Length[clusteredDimensions]>=3,Part[clusteredDimensions,1],1],
				app3Ddim2=If[Length[clusteredDimensions]>=3,Part[clusteredDimensions,2],2],
				app3Ddim3=If[Length[clusteredDimensions]>=3,Part[clusteredDimensions,3],3]
			},

			(* Assemble the preview interface, using a grid to set the dimensions *)
			Grid[{{
				TabView[
					Replace[
						includedTabs,
						{
							(* Compile tab for domain specification *)
							"Selector":>("Projection Selector"->buildSelectorApp[packet,ops,method,dv]),
							"1D":>("1D Projection"->build1DGatingApp[packet,ops,method,dv]),
							"2D":>("2D Projection"->build2DGatingApp[packet,ops,method,dv]),
							"3D":>("3D Projection"->build3DGatingApp[packet,ops,method,dv])
						},
						2
					],
					Dynamic[activeTab],
					LabelStyle->{Bold,Medium},
					Alignment->{Center,Top}
				]
			}}]
		]
	];

	(* Return the app. Pane is used to include scrollbars in the preview if the app size changes *)
	Pane[
		app,
		ImageSize->{UpTo[panelWidth],UpTo[panelHeight]},
		Scrollbars->{True,True},
		Alignment->Center
	]
];


(* ::Subsubsection::Closed:: *)
(*updateSubclusters*)

updateSubclusters[previewSym_, name_, packet_, ops_]:=Module[
	{
		currGraph,currObjRef,currPacket,updatedCurrPacket,subclusterData,newLabels,
		subclusterPacket,newObjRef,subPacketWithID,newGraph,newGraphWithPacket,
		newLabelsResolved
	},

	(* Current graph and active node *)
	currGraph=PreviewValue[previewSym,ClusterAnalysisTree];

	(* Current objref in the graph *)
	currObjRef=AnnotationValue[
		{currGraph,PreviewValue[previewSym,ActiveSubcluster]},
		VertexWeight
	];

	(* Current packet being analyzed *)
	currPacket=stripAppendReplaceKeyHeads@downloadFromFlowCytometryCache[currObjRef];

	(* We need to regenerate the original packet with the dynamic state of options *)
	updatedCurrPacket=Quiet[AnalyzeClusters[
		Join@@Lookup[currPacket,{IncludedData,ExcludedData}],
		ReplaceRule[ToList[ops],{
			Domain->PreviewValue[previewSym,Domain],
			ManualGates->PreviewValue[previewSym,ManualGates],
			ClusterLabels->PreviewValue[previewSym,ClusterLabels],
			Upload->False,
			Output->Result
		}]
	]];

	(* Update the cache used by the clustering tree *)
	$FlowCytometryClustersCache[currObjRef]=updatedCurrPacket;

	(* Packet for the new subcluster *)
	subclusterData=Lookup[
		Lookup[stripAppendReplaceKeyHeads@updatedCurrPacket,ClusteredData],
		name,
		{{1}}
	];

	(* Generate new default labels to pipe into the subclustering packet *)
	newLabels=DeleteCases[
		Map[
			name<>"-"<>ToString[#]&,
			Range[100]
		],
		Alternatives@@(VertexList[currGraph])
	];

	(* Generate the next cluster analysis packet *)
	subclusterPacket=Quiet[AnalyzeClusters[
		subclusterData,
		ReplaceRule[ToList[ops],{
			ClusterLabels->newLabels,
			Upload->False,
			Output->Result
		}]
	]];

	(* Create a new object reference for the subclustering packet *)
	newObjRef=CreateID[Object[Analysis,Clusters]];

	(* Give the packet an ID for future linking *)
	subclusterPacketWithID=Append[subclusterPacket,
		Object->newObjRef
	];

	(* Add to the flowcytometry cache *)
	$FlowCytometryClustersCache[newObjRef]=subclusterPacketWithID;

	(* Get the current graph and add an edge to new node with given name  *)
	newGraph=If[VertexQ[currGraph,name],
		currGraph,
		EdgeAdd[currGraph,
			DirectedEdge[PreviewValue[previewSym,ActiveSubcluster],name]
		]
	];

	(* Give the new node a weight of the subcluster packet *)
	newGraphWithPacket=SetProperty[newGraph,
		VertexWeight->{name->newObjRef}
	];

	(* Cluster labels from the new level *)
	newLabelsResolved=Lookup[Lookup[subclusterPacketWithID,ResolvedOptions,{}],ClusterLabels];

	(* Return the option updates *)
	LogPreviewChanges[previewSym,
		{
			ClusterAnalysisTree->newGraphWithPacket,
			ActiveSubcluster->name,
			Domain->Automatic,
			ManualGates->Automatic,
			ClusterLabels->newLabelsResolved
		}
	];
];


(* ::Subsubsection::Closed:: *)
(*removeSubcluster*)

removeSubcluster[previewSym_]:=Module[
	{currGraph,activeSubcluster,parent,parentPkt,parentOps},

	(* Current graph and active node *)
	currGraph=PreviewValue[previewSym,ClusterAnalysisTree];
	activeSubcluster=PreviewValue[previewSym,ActiveSubcluster];

	(* Parent node *)
	parent=FirstOrDefault[AdjacencyList[currGraph,activeSubcluster]];

	(* Packet associated with the parent node *)
	parentPkt=downloadFromFlowCytometryCache[AnnotationValue[{currGraph,parent},VertexWeight]];

	(* Options from parent packet *)
	parentOps=Lookup[stripAppendReplaceKeyHeads@parentPkt,ResolvedOptions,{}];

	(* Delete the current subcluster if the current node is a leaf *)
	If[!MatchQ[activeSubcluster,"All"]&&VertexOutDegree[currGraph,activeSubcluster]===0,
		LogPreviewChanges[previewSym,
			{
				ClusterAnalysisTree->VertexDelete[currGraph,activeSubcluster],
				ActiveSubcluster->parent,
				Domain->Lookup[parentOps,Domain,Automatic],
				ManualGates->Lookup[parentOps,ManualGates,Automatic],
				ClusterLabels->Lookup[stripAppendReplaceKeyHeads@parentPkt,ClusterLabels,Automatic]
			}
		],
		Null
	]
];


(* ::Subsubsection::Closed:: *)
(*subclusterExistsQ*)

(* True if the subcluster already exists *)
subclusterExistsQ[previewSym_,name_]:=Module[
	{subclusters},

	(* List of subclusters in the analysis graph *)
	subclusters=Quiet@VertexList[PreviewValue[previewSym,ClusterAnalysisTree]];

	(* Check if the current node is in the analysis tree already *)
	TrueQ[MemberQ[subclusters,name]]
];


(* ::Subsection::Closed:: *)
(*Testing Helper Functions*)


(* ::Subsubsection::Closed:: *)
(*generateMultidimensionalClusters*)


generateMultidimensionalClusters[numberOfDimensions_,numberOfSamples_:5000]:=Module[
	{mixtureModel},

	(* Define gaussian mixture model with one cluster offset in each dimension *)
	mixtureModel=MixtureDistribution[
		Table[1,{numberOfDimensions}],
		MultinormalDistribution[Table[10,{numberOfDimensions}]+5*#,IdentityMatrix[numberOfDimensions]*0.5]&/@IdentityMatrix[numberOfDimensions]
	];

	(* Generate a random sample from the mixture model *)
	RandomVariate[mixtureModel,numberOfSamples]

];


(* ::Subsubsection::Closed:: *)
(*generateOverlappingClusters*)


generateOverlappingClusters[numberOfSamples_:5000]:=Module[
	{mixtureModel},

	(* Define gaussian mixture model with one cluster offset in each dimension *)
	mixtureModel=MixtureDistribution[
		{1,1},
		{
			MultinormalDistribution[{0,0,0},IdentityMatrix[3]*0.5],
			MultinormalDistribution[{0,0,5},IdentityMatrix[3]*0.5]
		}
	];

	(* Generate a random sample from the mixture model *)
	RandomVariate[mixtureModel,numberOfSamples]
];


(* ::Section::Closed:: *)
(*Sister Functions*)


(* ::Subsection::Closed:: *)
(*AnalyzeClustersOptions*)

DefineOptions[AnalyzeClustersOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the resolved options."
		}
	},
	SharedOptions:>{
		AnalyzeClusters
	}
];

(* Call the parent function with Output->Options and format output *)
AnalyzeClustersOptions[
	myInput_,
	ops:OptionsPattern[AnalyzeClustersOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get options as a list *)
	listedOptions=ToList[ops];

	(* Send in the correct Output option and remove the OutputFormat option *)
	preparedOptions=Normal@KeyDrop[
		ReplaceRule[listedOptions,Output->Options],
		{OutputFormat}
	];

	(* Get the resolved options from AnalyzeClusters *)
	resolvedOptions=DeleteCases[AnalyzeClusters[myInput,preparedOptions],(Output->_)];

	(* Since the input format for this is a little wonky, return a fail state if this is unevaluated *)
	If[MatchQ[resolvedOptions,_AnalyzeClusters],
		Return[$Failed];
	];

	(* Return the options as a list or table, depending on the option format *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeClusters],
		resolvedOptions
	]
];


(* ::Subsection:: *)
(*AnalyzeClustersPreview*)

DefineOptions[AnalyzeClustersPreview,
	SharedOptions:>{
		AnalyzeClusters
	}
];

(* Call parent function with Output->Preview *)
AnalyzeClustersPreview[
	myInput_,
	ops:OptionsPattern[AnalyzeClustersPreview]
]:=Module[{listedOptions,preview},

	(* Convert options to a list *)
	listedOptions=ToList[ops];

	(* Call parent function with Output->Preview *)
	preview=AnalyzeClusters[myInput,ReplaceRule[listedOptions,Output->Preview]];

	(* Return $Failed if clusters returns unevaluated *)
	If[MatchQ[preview,_AnalyzeClusters],
		$Failed,
		preview
	]
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeClustersQ*)

DefineOptions[ValidAnalyzeClustersQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{
		AnalyzeClusters
	}
];

(* Use OutputFormat->Tests to determine if parent function call is valid, +format the output *)
ValidAnalyzeClustersQ[
	myInputs_,
	myOptions:OptionsPattern[ValidAnalyzeClustersQ]
]:=Module[
	{
		listedOptions,preparedOptions,analyzeClustersTests,
		initialTestDescription,allTests,verbose,outputFormat
	},

	(* Ensure that options are provided as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output, Verbose, and OutputFormat options from provided options *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Call AnalyzeClusters with Output->Tests to get a list of EmeraldTest objects *)
	analyzeClustersTests=AnalyzeClusters[myInputs,Append[preparedOptions,Output->Tests]];

	(* Define general test description *)
	initialTestDescription="All provided inputs and options match their provided patterns (no further testing is possible if this test fails):";

	(* Make a list of all tests, including the blanket correctness check *)
	allTests=If[MatchQ[analyzeClustersTests,$Failed|_AnalyzeClusters],
		(* Generic test that always fails if the Output->Tests output failed *)
		{Test[initialTestDescription,False,True]},
		(* Generate a list of tests, including valid object and VOQ checks *)
		Module[{validObjectBooleans,voqWarnings},
			(* Check for invalid objects *)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[{myInputs}],ObjectP[]],OutputFormat->Boolean];

			(* Return warnings for any invalid objects *)
			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[{myInputs}],ObjectP[]],validObjectBooleans}
			];

			(* Gather all tests and warnings *)
			Cases[Flatten[{analyzeClustersTests,voqWarnings}],_EmeraldTest]
		]
	];

	(* Look up options exclusive to running tests in the validQ function *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[
		RunUnitTest[<|"ValidAnalyzeClustersQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],
		"ValidAnalyzeClustersQ"
	]
];
