(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*AnalyzeClusters: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeClusters*)


(* ::Subsubsection:: *)
(*AnalyzeClusters*)


DefineTests[AnalyzeClusters,
	{
		(* ---- Basic ---- *)
		Example[{Basic,"Perform unsupervised clustering of multi-dimensional point data:"},
			AnalyzeClusters[sample3D,Output->Preview],
			_Image,
			Stubs:>{
				AnalyzeClusters[sample3D,Output->Preview] = Rasterize[AnalyzeClusters[sample3D,Output->Preview,Upload->False],ImageResolution->100]
			}
		],

		(* ---- Input Tests ---- *)
		Test["Inputs consisting of lists of quantities are converted into raw tabular data and the units are passed through as DimensionUnits:",
			AnalyzeClusters[Table[{x RFU,x RFU},{x,10}],ClusteringAlgorithm->DBSCAN,Upload->False],
			packet:PacketP[Object[Analysis,Clusters]]/;MatchQ[Lookup[stripAppendReplaceKeyHeads@packet,DimensionUnits],{RFU,RFU}]
		],

		Test["QuantityArray inputs are converted into raw tabular data and the units are passed through as DimensionUnits:",
			AnalyzeClusters[QuantityArray[sample2D,{RFU,RFU}],ClusteringAlgorithm->DBSCAN,Upload->False],
			packet:PacketP[Object[Analysis,Clusters]]/;MatchQ[Lookup[stripAppendReplaceKeyHeads@packet,DimensionUnits],{RFU,RFU}]
		],

		Test["Column headers are automatically stripped from the first row of otherwise raw tabular data and passed through as DimensionLabels:",
			AnalyzeClusters[Prepend[Table[{x,x},{x,10}],{"Column 1","Column 2"}],ClusteringAlgorithm->DBSCAN,Upload->False],
			packet:PacketP[Object[Analysis,Clusters]]/;MatchQ[Lookup[stripAppendReplaceKeyHeads@packet,DimensionLabels],{"Column 1","Column 2"}]
		],

		Test["Column headers are automatically stripped from the first row of tabular data with units and passed through as DimensionLabels:",
			AnalyzeClusters[Prepend[Table[{x Foot,x Foot},{x,10}],{"Column 1","Column 2"}],ClusteringAlgorithm->DBSCAN,Upload->False],
			packet:PacketP[Object[Analysis,Clusters]]/;MatchQ[Lookup[stripAppendReplaceKeyHeads@packet,DimensionLabels],{"Column 1","Column 2"}]&&MatchQ[Lookup[stripAppendReplaceKeyHeads@packet,DimensionUnits],{Foot,Foot}]
		],

		Test["Unresolved options only returns supplied options:",
			Lookup[
				AnalyzeClusters[sample5D,
					DimensionLabels->{"A1","A2","B1","B2","I"},
					Upload->False
				],
				UnresolvedOptions
			],
			{DimensionLabels->{"A1", "A2", "B1", "B2", "I"}, Upload -> False}
		],

		(* ---- Option Examples: Data Preprocessing ---- *)
		Example[{Options,Normalize,"Transform each dimension of the input data to a 0 to 1 interval:"},
			AnalyzeClusters[sample2D,Normalize->True][PreprocessedData],
			data_List/;MatchQ[Round[Transpose[Rescale/@Transpose[sample2D]],0.001],Round[data,0.001]]
		],

		Example[{Options,Scale,"Log-transform all of the input data:"},
			AnalyzeClusters[sample2D,Scale->Log][PreprocessedData],
			data_List/;MatchQ[Log10[sample2D],data]
		],

		Example[{Options,Scale,"Apply Log and Reciprocal transformations to specific dimensions of the input data:"},
			AnalyzeClusters[sample2D,Scale->{Reciprocal,Log}][PreprocessedData],
			data_List/;MatchQ[Transpose@{1/Part[sample2D,All,1],Log10[Part[sample2D,All,2]]},data]
		],

		Example[{Options,Domain,"Specify which input data points are used to partition the input data by defining one or more 2D polygonal gates:"},
			AnalyzeClusters[sample2D,Domain->{{1,2,Polygon[{{8.2,15},{9,16.5},{10,17},{11,16.5},{11.5,15},{11,12.5},{10,12},{9,12.5}}],Include}}][IncludedData],
			data_List/;Max[Part[data,All,1]]<15
		],

		Example[{Options,Domain,"Specify which input data points are used to partition the input data by defining one or more 3D gates:"},
			AnalyzeClusters[sample3D,Domain->{{1,2,3,Polygon[{{8.2,15,10},{9,16.5,10},{10,17,10},{11,16.5,10},{11.5,15,10},{11,12.5,10},{10,12,10},{9,12.5,10},{10,15,13},{10,15,7}}],Include}}][IncludedData],
			data_List/;Max[Part[data,All,3]]<13
		],

		Example[{Options,Domain,"Specify which input data points are used to partition the input data by defining one or more constraint functions:"},
			AnalyzeClusters[sample2D,Domain->{First[#]<13&}][IncludedData],
			data_List/;Max[Part[data,All,1]]<13
		],

		(* ---- Option Examples: Method master switch ---- *)
		Example[{Options,Method,"Use an automated clustering algorithm to partition the input data:"},
			AnalyzeClusters[sample2D,Method->Automatic][ClusteringAlgorithm],
			ClusteringAlgorithmP
		],

		Test[
			"Method defaults to Manual if ManualGates are specified but Method is not:",
			AnalyzeClusters[
				Analysis`Private`generateMultidimensionalClusters[2,1000],
				ManualGates->{{{1,2,Polygon[{{9.690000000000001, 17.740000000000002`}, {8.96, 17.5}, {8.34, 17.}, {8.040000000000001, 15.98}, {7.960000000000001, 15.5}, {8.155000000000001, 14.36}, {8.755, 13.3}, {9.305, 12.9}, {10.97, 12.86}, {11.82, 13.5}, {12.155000000000001`, 14.68}, {12.145, 15.18}, {11.475000000000001`, 16.82}, {11.145, 17.18}, {10.870000000000001`, 17.560000000000002`}, {10.63, 17.78}}],Include}},{{1,2,Polygon[{{14.49, 12.96}, {13.245000000000001`, 12.14}, {12.7, 11.36}, {12.555, 10.760000000000002`}, {12.510000000000002`, 10.24}, {12.565000000000001`, 9.4}, {13.65, 7.960000000000001}, {14.4, 7.540000000000001}, {14.775000000000002`, 7.260000000000001}, {15.165, 7.1000000000000005`}, {16.915, 7.840000000000001}, {17.220000000000002`, 8.84}, {17.075, 10.92}, {16.64, 12.080000000000002`}, {16.205000000000002`, 12.56}, {15.45, 12.940000000000001`}, {14.940000000000001`, 13.100000000000001`}}],Include}}},
				Output->Options
			],
			ops_List/;MatchQ[Lookup[ops,Method],Manual]
		],

		(* ---- Option Examples: Manual Gating ---- *)
		Example[
			{
				Options,ManualGates,"Manually partition data using 1D threshold gates:"
			},
			AnalyzeClusters[
				sample2D,
				Method->Manual,
				ManualGates->{
					{{1,12.795`,Below}},
					{{1,12.795`,Above}}
				}
			][NumberOfClusters],
			2
		],

		Example[
			{
				Options,ManualGates,"Manually partition data using 2D polygonal gates:"
			},
			AnalyzeClusters[
				sample2D,
				Method->Manual,
				ManualGates->{{{1,2,Polygon[{{9.690000000000001, 17.740000000000002`}, {8.96, 17.5}, {8.34, 17.}, {8.040000000000001, 15.98}, {7.960000000000001, 15.5}, {8.155000000000001, 14.36}, {8.755, 13.3}, {9.305, 12.9}, {10.97, 12.86}, {11.82, 13.5}, {12.155000000000001`, 14.68}, {12.145, 15.18}, {11.475000000000001`, 16.82}, {11.145, 17.18}, {10.870000000000001`, 17.560000000000002`}, {10.63, 17.78}}],Include}},{{1,2,Polygon[{{14.49, 12.96}, {13.245000000000001`, 12.14}, {12.7, 11.36}, {12.555, 10.760000000000002`}, {12.510000000000002`, 10.24}, {12.565000000000001`, 9.4}, {13.65, 7.960000000000001}, {14.4, 7.540000000000001}, {14.775000000000002`, 7.260000000000001}, {15.165, 7.1000000000000005`}, {16.915, 7.840000000000001}, {17.220000000000002`, 8.84}, {17.075, 10.92}, {16.64, 12.080000000000002`}, {16.205000000000002`, 12.56}, {15.45, 12.940000000000001`}, {14.940000000000001`, 13.100000000000001`}}],Include}}}
			][NumberOfClusters],
			2
		],

		Example[
			{
				Options,ManualGates,"Manually partition data using 3D ellipsoidal gates:"
			},
			AnalyzeClusters[
				sample3D,
				Method->Manual,
				ManualGates->{
					{
						{1,2,3,Ellipsoid[{10.15`,9.8`,14.9`},{2.45,2.13`,2.19`}],Include}
					},
					{
						{1,2,3,Ellipsoid[{15.05`,9.9`,10.20`},{2.43`,2.13`,2.19`}],Include}
					},
					{
						{1,2,3,Ellipsoid[{10., 14.8, 10.10}, {2.43, 2.13, 2.19}],Include}
					}
				}
			][NumberOfClusters],
			3
		],

		(* ---- Additional Option Examples ---- *)
		Example[{Options,NumberOfClusters,"Specify the desired number of partitions to be detected during automatic clustering:"},
			AnalyzeClusters[sample2D,NumberOfClusters->2][ClusteredData],
			data_Association/;Length@data==2
		],

		Example[{Options,ClusterLabels,"Specify a name for each partition:"},
			AnalyzeClusters[sample2D,NumberOfClusters->2,ClusterLabels->{"Alpha","Beta"}][ClusteredData],
			data_Association/;MatchQ[Keys@data,{"Alpha","Beta"}]
		],
		Example[{Options,ClusterAssignments,"Assign identity models to each partition:"},
			AnalyzeClusters[sample2D,
				NumberOfClusters->3,
				ClusterAssignments->{
					Model[Cell,Mammalian,"id:4pO6dM5dPrrX"],
					Null,
					Model[Cell,Mammalian,"id:mnk9jOReopeZ"]
				}
			][ClusterAssignments],
			{LinkP[Model[Cell,Mammalian]], Null, LinkP[Model[Cell,Mammalian]]}
		],
		Example[{Options,ClusterAssignments,"If no ClusterAssignments are specified, they will default to Null:"},
			AnalyzeClusters[sample2D,NumberOfClusters->2][ClusterAssignments],
			{Null,Null}
		],


		Example[{Options,DimensionLabels,"Specify a name for each dimension of the input data:"},
			AnalyzeClusters[sample2D,DimensionLabels->{"Channel 1","Channel 2"}][DimensionLabels],
			{"Channel 1","Channel 2"}
		],

		Example[{Options,DimensionUnits,"Specify units for each dimension of the input data:"},
			AnalyzeClusters[sample2D,DimensionUnits->{RFU,RFU}][DimensionUnits],
			{RFU,RFU}
		],

		Example[{Options,ClusteredDimensions,"Specify which dimensions are used to automatically partition the input data:"},
			AnalyzeClusters[
				(* Generate a random 3D sample in which only two clusters are identifiable within a pair of dimensions *)
				RandomVariate[
					MixtureDistribution[
						{1,1,1},
						{
							MultinormalDistribution[{5,0,0},IdentityMatrix[3]*0.5],
							MultinormalDistribution[{0,0,0},IdentityMatrix[3]*0.5],
							MultinormalDistribution[{0,0,5},IdentityMatrix[3]*0.5]
						}
					],
					5000
				],
				ClusteredDimensions->{2,3},
				Method->Automatic,
				NumberOfClusters->2
			][NumberOfClusters],
			2
		],

		Example[{Options,ClusterDomainOutliers,"Assign each point excluded by the specified Domain to the nearest identified partition:"},
			AnalyzeClusters[
				sample2D,
				Domain->{
					{1,2,Polygon[{{8,15},{10,17},{11,17},{15,12},{17,10},{16,8},{14,8}}],Include}
				},
				ClusterDomainOutliers->True
			][ClusteredData],
			data_Association/;Length[Join@@Values@data]==Length[sample2D]
		],

		Example[{Options,ClusteringAlgorithm,"Specify which strategy is used to automatically partition the input data when Method is set to Automatic:"},
			AnalyzeClusters[sample2D,Method->Automatic,ClusteringAlgorithm->DBSCAN][ClusteringAlgorithm],
			DBSCAN
		],

		Example[{Options,PerformanceGoal,"Specify the PerformanceGoal used to select an automated clustering method:"},
			AnalyzeClusters[sample2D,NumberOfClusters->2,PerformanceGoal->Speed][ClusteringAlgorithm],
			ClusteringAlgorithmP
		],

		Example[{Options,DistanceFunction,"Specify the function used to evaluate the similarity of two data points during automated clustering:"},
			DistanceFunction/.AnalyzeClusters[sample2D,DistanceFunction->ManhattanDistance][ResolvedOptions],
			ManhattanDistance
		],

		Example[{Options,CriterionFunction,"Specify the evaluation metric used to select an appropriate clustering algorithm during automated clustering:"},
			CriterionFunction/.AnalyzeClusters[sample2D,CriterionFunction->Silhouette][ResolvedOptions],
			Silhouette
		],

		(* ---- Option Examples: Algorithm-specific Suboptions ---- *)

		Example[{Options,CovarianceType,"Specify the form of the covariance matrix when ClusteringAlgorithm is set to GaussianMixture:"},
			CovarianceType/.AnalyzeClusters[sample2D,ClusteringAlgorithm->GaussianMixture,CovarianceType->Diagonal][ResolvedOptions],
			Diagonal,
			Stubs:>{
				AnalyzeClusters[sample2D,ClusteringAlgorithm->GaussianMixture,CovarianceType->Diagonal][ResolvedOptions]=Quiet[
					AnalyzeClusters[sample2D,ClusteringAlgorithm->GaussianMixture,CovarianceType->Diagonal],
					{NeuralNetworks`ReloadFile::shdw}
				][ResolvedOptions]
			}
		],

		Example[{Options,MaxIterations,"Specify the maximum allowable number of expectation-maximization iterations used to fit a mixture model when ClusteringAlgorithm is set to GaussianMixture:"},
			MaxIterations/.(AnalyzeClusters[sample2D,ClusteringAlgorithm->GaussianMixture,MaxIterations->10][ResolvedOptions]),
			10,
			Stubs:>{
				AnalyzeClusters[sample2D,ClusteringAlgorithm->GaussianMixture,MaxIterations->10][ResolvedOptions]=Quiet[
					AnalyzeClusters[sample2D,ClusteringAlgorithm->GaussianMixture,MaxIterations->10],
					{NeuralNetworks`ReloadFile::shdw}
				][ResolvedOptions]
			}
		],

		Example[{Options,NeighborhoodRadius,"Specify the separation distance below which two data points are considered neighbors when ClusteringAlgorithm is set to DBSCAN, MeanShift, or Spectral:"},
			NeighborhoodRadius/.AnalyzeClusters[sample2D,ClusteringAlgorithm->DBSCAN,NeighborhoodRadius->5][ResolvedOptions],
			5
		],

		Example[{Options,NeighborsNumber,"Specify the minimum number of adjacent points required for a data point to be considered a core point when ClusteringAlgorithm is set to DBSCAN:"},
			NeighborsNumber/.AnalyzeClusters[sample2D,ClusteringAlgorithm->DBSCAN,NeighborsNumber->5][ResolvedOptions],
			5
		],

		Example[{Options,ClusterDissimilarityFunction,"Specify the function used to assess the pairwise distance between clusters when ClusteringAlgorithm is set to Agglomerate or SPADE:"},
			ClusterDissimilarityFunction/.AnalyzeClusters[sample2D,ClusteringAlgorithm->Agglomerate,ClusterDissimilarityFunction->Average][ResolvedOptions],
			Average
		],

		Example[{Options,MaxEdgeLength,"Specify the maximum allowable distance between adjacent clusters when ClusteringAlgorithm is set to SpanningTree:"},
			MaxEdgeLength/.AnalyzeClusters[sample2D,ClusteringAlgorithm->SpanningTree,MaxEdgeLength->1][ResolvedOptions],
			1
		],

		Example[{Options,DensityResamplingThreshold,"Specify the maximum local density at which a data point is subject to density-dependent resampling when ClusteringAlgorithm is set to SPADE:"},
			DensityResamplingThreshold/.AnalyzeClusters[sample2D,NumberOfClusters->2,ClusteringAlgorithm->SPADE,DensityResamplingThreshold->3.0][ResolvedOptions],
			3.0
		],

		Example[{Options,OutlierDensityQuantile,"Specify the quantile of local densities below which a given data point should be considered an outlier when ClusteringAlgorithm is set to SPADE:"},
			OutlierDensityQuantile/.AnalyzeClusters[sample2D,NumberOfClusters->2,ClusteringAlgorithm->SPADE,OutlierDensityQuantile->0.005][ResolvedOptions],
			0.005
		],

		Example[{Options,TargetDensityQuantile,"Specify the quantile of local densities to which the density of data points should be resampled when ClusteringAlgorithm is set to SPADE:"},
			TargetDensityQuantile/.AnalyzeClusters[sample2D,NumberOfClusters->2,ClusteringAlgorithm->SPADE,TargetDensityQuantile->0.05][ResolvedOptions],
			0.05
		],

		(* ---- Option Examples: Upload & Output ---- *)

		Example[{Options,Upload,"Upload the resultant Object[Analysis,Clusters] object to Constellation:"},
			AnalyzeClusters[sample2D,Upload->True],
			ObjectP[Object[Analysis,Clusters]]
		],

		Example[{Options,Output,"Return an interactive preview of the analysis result:"},
			AnalyzeClusters[sample2D,Output->Preview],
			_Image,
			Stubs:>{
				AnalyzeClusters[sample2D,Output->Preview] = 
				Rasterize[AnalyzeClusters[sample2D,Output->Preview,Upload->False],ImageResolution->100]
			}
		],

		Example[{Options,Output,"Return the entire set of resolved option values:"},
			AnalyzeClusters[sample2D,Output->Options],
			{_Rule..}
		],

		Test[
			"Setting Output to a list of values returns the desired content:",
			AnalyzeClusters[sample2D,Output->{Result,Options,Preview}],
			{ObjectP[Object[Analysis,Clusters]],{_Rule..},_Pane|_Grid}
		],

		(* ---- Message Examples ---- *)

		Example[{Messages,"Invalid1DGateDefinition","Issue a warning if an invalid 1D gate is specified:"},
			AnalyzeClusters[
				sample2D,
				Method->Manual,
				ManualGates->{
					{{1,12.795`,Below},{5,12.795`,Above}}
				}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::Invalid1DGateDefinition}
		],

		Example[{Messages,"Invalid2DGateDefinition","Issue a warning if an invalid 2D gate is specified:"},
			AnalyzeClusters[
				sample2D,
				Method->Manual,
				ManualGates->{
					{{3,4,Polygon[{0,0,0}],Include}}
				}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::Invalid2DGateDefinition}
		],

		Example[{Messages,"Invalid3DGateDefinition","Issue a warning if an invalid 3D gate is specified:"},
			AnalyzeClusters[
				sample3D,
				Method->Manual,
				ManualGates->{
					{{1,1,1,Ellipsoid[{5,4},{2,1}],Include}}
				}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::Invalid3DGateDefinition}
		],

		Example[{Messages,"RedundantDomain","Issue a warning if Method is set to Manual but the Domain is specified:"},
			AnalyzeClusters[
				sample2D,
				Method->Manual,
				Domain->{
					{1,-100,Below}
				}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::RedundantDomain}
		],

		Example[{Messages,"NoIncludedData","Issue an error if the specified Domain excludes all points in the input data:"},
			AnalyzeClusters[
				sample2D,
				Method->Automatic,
				Domain->{
					{1,-100,Below}
				}
			],
			$Failed,
			Messages:>{AnalyzeClusters::NoIncludedData,Error::InvalidOption}
		],

		Example[{Messages,"GatesOverlap","Issue a warning if the specified ManualGates assign any of the input data points to multiple distinct partitions:"},
			AnalyzeClusters[
				sample3D,
				Method->Manual,
				ManualGates->{
					{{1,10,Below}},
					{{1,15,Below}}
				}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::GatesOverlap}
		],

		Example[{Messages,"NumberOfClustersNotSupported","Issue a warning if specifying NumberOfClusters is not supported for the selected ClusteringAlgorithm:"},
			AnalyzeClusters[
				sample2D,
				Method->Automatic,
				ClusteringAlgorithm->DBSCAN,
				NumberOfClusters->2
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::NumberOfClustersNotSupported}
		],

		Example[{Messages,"NumberOfClustersRequired","Issue a warning if NumberOfClusters was not specified but the specified ClusteringAlgorithm requires specifying the desired number of clusters:"},
			AnalyzeClusters[
				sample2D,
				Method->Automatic,
				ClusteringAlgorithm->KMeans
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::NumberOfClustersRequired}
		],

		Example[{Messages,"NumberOfClustersExceedsDataSize","Issue a warning if NumberOfClusters exceeds the number of points to be clustered:"},
			AnalyzeClusters[
				{{1,1},{2,2},{3,3}},
				Method->Automatic,
				NumberOfClusters->10
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::NumberOfClustersExceedsDataSize}
		],

		Example[{Messages,"InvalidLogTransformation","Issue a warning if the specified Scale entails log-transforming a negative value:"},
			AnalyzeClusters[
				Table[{x,x},{x,-100,100}],
				Scale->{Log,Linear},
				ClusteringAlgorithm->DBSCAN
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::InvalidLogTransformation}
		],

		Example[{Messages,"ScaleDimensionMismatch","Issue a warning if the specified Scale does not match the dimensionality of the input data:"},
			AnalyzeClusters[
				sample2D,
				Scale->{Linear,Linear,Log}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::ScaleDimensionMismatch}
		],

		Example[{Messages,"EmptyManualGates","Issue an error if the specified Domain excludes all points in the input data:"},
			AnalyzeClusters[
				sample2D,
				Method->Manual,
				ManualGates->{}
			],
			object:ObjectP[Object[Analysis,Clusters]]/;object[NumberOfClusters]==0,
			Messages:>{AnalyzeClusters::EmptyManualGates}
		],

		Example[{Messages,"DimensionLabelsLengthMismatch","Issue a warning if the specified DimensionLabels do not match the length of the input data:"},
			AnalyzeClusters[
				sample2D,
				DimensionLabels->{"Channel A","Channel B","Channel C"}
			],
			object:ObjectP[Object[Analysis,Clusters]]/;MatchQ[object[DimensionLabels],None],
			Messages:>{AnalyzeClusters::DimensionLabelsLengthMismatch}
		],

		Example[{Messages,"DimensionUnitsLengthMismatch","Issue a warning if the specified DimensionUnits do not match the length of the input data:"},
			AnalyzeClusters[
				sample2D,
				DimensionUnits->{RFU,RFU,RFU}
			],
			object:ObjectP[Object[Analysis,Clusters]]/;MatchQ[object[DimensionUnits],{1,1}],
			Messages:>{AnalyzeClusters::DimensionUnitsLengthMismatch}
		],

		Example[{Messages,"ClusterLabelsLengthMismatch","Issue a warning if the specified ClusterLabels do not match the number of identified clusters:"},
			AnalyzeClusters[
				sample2D,
				ClusteringAlgorithm->KMeans,
				NumberOfClusters->2,
				ClusterLabels->{"Group 1","Group 2","Group 3"}
			],
			object:ObjectP[Object[Analysis,Clusters]]/;MatchQ[object[ClusterLabels],{"Group 1","Group 2"}],
			Messages:>{AnalyzeClusters::ClusterLabelsLengthMismatch}
		],

		Example[{Messages,"ClusterAssignmentsLengthMismatch","Issue a warning if the specified ClusterAssignments does not match the number of identified clusters:"},
			AnalyzeClusters[
				sample2D,
				ClusteringAlgorithm->KMeans,
				NumberOfClusters->2,
				ClusterAssignments->{
					Model[Cell,Mammalian,"id:4pO6dM5dPrrX"],
					Model[Cell,Mammalian,"id:9RdZXv106Y0x"],
					Model[Cell,Mammalian,"id:mnk9jOReopeZ"]
				}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::ClusterAssignmentsLengthMismatch}
		],

		Test["ClusterAssignments is truncated if more assignments than clusters are provided:",
			AnalyzeClusters[
				sample2D,
				ClusteringAlgorithm->KMeans,
				NumberOfClusters->2,
				ClusterAssignments->{
					Model[Cell,Mammalian,"id:4pO6dM5dPrrX"],
					Model[Cell,Mammalian,"id:9RdZXv106Y0x"],
					Model[Cell,Mammalian,"id:mnk9jOReopeZ"]
				}
			][ClusterAssignments]/.{lnk_Link:>lnk[Object]},
			{
				Model[Cell,Mammalian,"id:4pO6dM5dPrrX"],
				Model[Cell,Mammalian,"id:9RdZXv106Y0x"]
			},
			Messages:>{AnalyzeClusters::ClusterAssignmentsLengthMismatch}
		],
		Test["ClusterAssignments is padded with Null if less assignments than clusters are provided:",
			AnalyzeClusters[
				sample2D,
				ClusteringAlgorithm->KMeans,
				NumberOfClusters->5,
				ClusterAssignments->{
					Model[Cell,Mammalian,"id:4pO6dM5dPrrX"],
					Model[Cell,Mammalian,"id:9RdZXv106Y0x"],
					Model[Cell,Mammalian,"id:mnk9jOReopeZ"]
				}
			][ClusterAssignments]/.{lnk_Link:>lnk[Object]},
			{
				Model[Cell,Mammalian,"id:4pO6dM5dPrrX"],
				Model[Cell,Mammalian,"id:9RdZXv106Y0x"],
				Model[Cell,Mammalian,"id:mnk9jOReopeZ"],
				Null,
				Null
			},
			Messages:>{AnalyzeClusters::ClusterAssignmentsLengthMismatch}
		],

		Example[{Messages,"InvalidClusteredDimensions","Issue a warning if the specified ClusteredDimensions are inconsistent with the dimensionality of the input data:"},
			AnalyzeClusters[
				sample2D,
				ClusteredDimensions->{1,3}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::InvalidClusteredDimensions}
		],

		Example[{Messages,"InvalidDomainFunctionDefinition","Issue a warning if a pure function constraint in the specified Domain does not return a boolean value when given an input data point:"},
			AnalyzeClusters[
				sample2D,
				Domain->{
					2#&
				}
			],
			ObjectP[Object[Analysis,Clusters]],
			Messages:>{AnalyzeClusters::InvalidDomainFunctionDefinition}
		],

		(* ---- Preview App Tests ---- *)

		Test[
			"The 2D and 3D app interfaces are hidden when the input is 1D:",
			AnalyzeClusters[
				sample1D,
				Output->Preview,
				Upload->False
			],
			app:_Pane|_Grid/;Module[
				{tabNames,preview1D,graphic1D,validGraphics,validTabNames},

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[{Analysis`Private`app1Ddim1=1},

					(* Verify that the correct tabs are shown *)
					tabNames=First/@First@First@Cases[app,_TabView,-1];
					validTabNames=MatchQ[tabNames,{"1D Projection"}];

					(* Extract Graphics from preview app *)
					preview1D=FirstOrDefault[extractClustersDynamicModule[app]];
					Part[preview1D,1]; (* DO NOT DELETE - this forces front end values into the app so we can test the graphics *)
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic1D=Part[Cases[preview1D,_LocatorPane,11],1,2,1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};

					(* Verify that all graphics are valid *)
					validGraphics=ValidGraphicsQ[graphic1D];
				];

				(* Check that all requiresments were met *)
				validGraphics&&validTabNames
			]
		],

		Test[
			"All app graphics are valid when Method is set to Automatic:",
			AnalyzeClusters[
				RandomVariate[MultinormalDistribution[{0,0,0},IdentityMatrix[3]],1000],
				Method->Automatic,
				ClusteringAlgorithm->DBSCAN,
				Output->Preview,
				Upload->False
			],
			app:_Pane|_Grid/;Module[
				{selector,preview1D,preview2D,preview3D,graphic1D,graphic2D,graphic3D,valid1D,valid2D,valid3D},
				
				(* Extract Graphics/Graphics3D from preview app *)
				{selector,preview1D,preview2D,preview3D}=extractClustersDynamicModule[app];
				
				(* In the below, Part[preview,1] forces values into the front end and is needed for testing *)
				
				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3
					},
					
					(* Check the 1D graphic *)
					Part[preview1D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic1D=Part[Cases[preview1D,_LocatorPane,11],1,2,1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid1D=ValidGraphicsQ[graphic1D];
					
					(* Check the 2D graphic *)
					Part[preview2D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic2D=Part[Cases[preview2D,_Show,15],1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid2D=ValidGraphicsQ[graphic2D];
					
					(* Check the 3D graphic *)
					Part[preview3D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic3D=Part[Cases[preview3D,_Dynamic,{10}],1,1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid3D=ValidGraphicsQ[graphic3D];
				
				];
				
				(* Verify that all graphics are valid *)
				And[valid1D,valid2D,valid3D]
			]
		],

		Test[
			"All app graphics are valid when Method is set to Manual:",
			AnalyzeClusters[
				RandomVariate[MultinormalDistribution[{0,0,0},IdentityMatrix[3]],1000],
				Method->Manual,
				Output->Preview,
				Upload->False
			],
			app:_Pane|_Grid/;Module[
				{selector,preview1D,preview2D,preview3D,graphic1D,graphic2D,graphic3D,valid1D,valid2D,valid3D},

				(* Extract Graphics/Graphics3D from preview app *)
				{selector,preview1D,preview2D,preview3D}=extractClustersDynamicModule[app];

				(* In the below, Part[preview,1] forces values into the front end and is needed for testing *)

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3
					},

					(* Check the 1D graphic *)
					Part[preview1D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic1D=Part[Cases[preview1D,_LocatorPane,11],1,2,1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid1D=ValidGraphicsQ[graphic1D];

					(* Check the 2D graphic *)
					Part[preview2D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic2D=Part[Cases[preview2D,_Show,15],1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid2D=ValidGraphicsQ[graphic2D];

					(* Check the 3D graphic *)
					Part[preview3D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic3D=Part[Cases[preview3D,_Dynamic,{10}],1,1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid3D=ValidGraphicsQ[graphic3D];

				];

				(* Verify that all graphics are valid *)
				And[valid1D,valid2D,valid3D]
			]
		],

		Test[
			"The 3D interface is hidden when the input data are 2D:",
			AnalyzeClusters[
				RandomVariate[MultinormalDistribution[{0,0},IdentityMatrix[2]],1000],
				Method->Manual,
				Output->Preview,
				Upload->False
			],
			app:_Pane|_Grid/;Module[
				{tabNames,validTabNames,preview1D,preview2D,graphic1D,graphic2D,valid1D,valid2D},

				(* Verify that the correct tabs are shown *)
				tabNames=First/@First@First@Cases[app,_TabView,-1];
				validTabNames=MatchQ[tabNames,{"1D Projection","2D Projection"}];

				(* Extract Graphics/Graphics3D from preview app *)
				{preview1D,preview2D}=extractClustersDynamicModule[app];

				(* In the below, Part[preview,1] forces values into the front end and is needed for testing *)

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[{Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,Analysis`Private`app2Ddim2=2},

					(* Check the 1D graphic *)
					Part[preview1D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic1D=Part[Cases[preview1D,_LocatorPane,11],1,2,1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid1D=ValidGraphicsQ[graphic1D];

					(* Check the 2D graphic *)
					Part[preview2D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic2D=Part[Cases[preview2D,_Show,15],1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid2D=ValidGraphicsQ[graphic2D];

				];

				(* Verify that all graphics are valid *)
				And[validTabNames,valid1D,valid2D]
			]
		],

		Test[
			"User specified 2D gates are rendered when Method is set to Manual and ManualGates is specified:",
			AnalyzeClusters[
				Analysis`Private`generateMultidimensionalClusters[2,2000],
				Method->Manual,
				ManualGates->{{{1,2,Polygon[{{9.690000000000001, 17.740000000000002`}, {8.96, 17.5}, {8.34, 17.}, {8.040000000000001, 15.98}, {7.960000000000001, 15.5}, {8.155000000000001, 14.36}, {8.755, 13.3}, {9.305, 12.9}, {10.97, 12.86}, {11.82, 13.5}, {12.155000000000001`, 14.68}, {12.145, 15.18}, {11.475000000000001`, 16.82}, {11.145, 17.18}, {10.870000000000001`, 17.560000000000002`}, {10.63, 17.78}}],Include}},{{1,2,Polygon[{{14.49, 12.96}, {13.245000000000001`, 12.14}, {12.7, 11.36}, {12.555, 10.760000000000002`}, {12.510000000000002`, 10.24}, {12.565000000000001`, 9.4}, {13.65, 7.960000000000001}, {14.4, 7.540000000000001}, {14.775000000000002`, 7.260000000000001}, {15.165, 7.1000000000000005`}, {16.915, 7.840000000000001}, {17.220000000000002`, 8.84}, {17.075, 10.92}, {16.64, 12.080000000000002`}, {16.205000000000002`, 12.56}, {15.45, 12.940000000000001`}, {14.940000000000001`, 13.100000000000001`}}],Include}}},
				Output->Preview,
				Upload->False
			],
			app:_Pane|_Grid/;Module[
				{preview1D,preview2D,graphic1D,graphic2D,valid1D,valid2D,gatesRendered},

				(* Extract Graphics/Graphics3D from preview app *)
				{preview1D,preview2D}=extractClustersDynamicModule[app];

				(* In the below, Part[preview,1] forces values into the front end and is needed for testing *)

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3
					},

					(* Check the 1D graphic *)
					Part[preview1D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic1D=Part[Cases[preview1D,_LocatorPane,11],1,2,1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid1D=ValidGraphicsQ[graphic1D];

					(* Check the 2D graphic *)
					Part[preview2D,1];
					(* Replace the Dynamic variables with their values in the graphics using Setting *)
					(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
					graphic2D=Part[Cases[preview2D,_Show,15],1]/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};
					valid2D=ValidGraphicsQ[graphic2D];

					(* Check that polygonal gates are present *)
					gatesRendered=Or[
						(Length@Cases[graphic2D,_Polygon,-1])==2,
						(* Stripping dynamics from the 2D graphic duplicates the polygons for some reason *)
						(Length@Cases[graphic2D,_Polygon,-1])==4
					];

				];

				(* Verify that all graphics are valid *)
				And[valid1D,valid2D,gatesRendered]
			]
		],

		Test[
			"Dimension selector menus change which dimensions of the data are visualized:",
			Module[
				{app,previews,selector,preview1D,preview2D,preview3D,graphic1D,graphic2D,graphic3D,app1Dsuccess,app2Dsuccess,app3Dsuccess},

				(* Launch preview app *)
				app=AnalyzeClusters[sample5D,ClusteringAlgorithm->DBSCAN,Output->Preview,Upload->False];

				(* Extract Graphics from preview app *)
				previews=extractClustersDynamicModule[app];
				Part[#,1]&/@previews; (* DO NOT DELETE - this forces front end values into the app so we can test the graphics *)
				{selector,preview1D,preview2D,preview3D}=previews;

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=4,Analysis`Private`app2Ddim1=4,
						Analysis`Private`app2Ddim2=3,Analysis`Private`app3Ddim1=4,
						Analysis`Private`app3Ddim2=3,Analysis`Private`app3Ddim3=5
					},

					(* Test that the 1D app histogram updated appropriately *)
					graphic1D=First@Cases[preview1D,_LocatorPane,-1];
					app1Dsuccess=MatchQ[
						First@Cases[graphic1D,_HistogramList,-1],
						HistogramList[Part[sample5D,All,4],25]
					];

					(* Test that the 2D app points updated appropriately *)
					graphic2D=First@Cases[preview2D,_LocatorPane,-1];
					app2Dsuccess=MatchQ[
						First@First@Cases[graphic2D,pt:_Point/;Length[First[pt]]>0,-1],
						Part[sample5D,All,{4,3}]
					];

					(* Test that the 3D app points updated appropriately *)
					graphic3D=Setting@First@Cases[preview3D,_Dynamic,{10}];
					app3Dsuccess=MatchQ[
						First@First@Cases[graphic3D,pt:_Point/;Length[First[pt]]>0,-1],
						Part[sample5D,All,{4,3,5}]
					];
				];

				(* Return True if all tests passed *)
				app1Dsuccess&&app2Dsuccess&&app3Dsuccess

			],
			True
		],

		Test[
			"Density projection checkboxes toggle the display of lower-dimensional density projections in the 2D plot:",
			Module[
				{app,previews,preview1D,preview2D,preview3D,graphic2D,xAxisSuccess,yAxisSuccess,offSuccess},

				(* Launch preview app *)
				app=AnalyzeClusters[sample3D,ClusteringAlgorithm->DBSCAN,Output->Preview,Upload->False];

				(* Extract Graphics from preview app *)
				previews=extractClustersDynamicModule[app];
				Part[#,1]&/@previews; (* DO NOT DELETE - this forces front end values into the app so we can test the graphics *)
				{selector,preview1D,preview2D,preview3D}=previews;

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3
					},

					(* Extract the 2D graphics *)
					graphic2D=First@Cases[preview2D,_LocatorPane,-1];

					(* Turn x-density on *)
					Analysis`Private`xDensity=True;
					xAxisSuccess=Length@Cases[Setting@First@Cases[graphic2D,_Graphics,-1],_Line,-1]==1;

					(* Turn y-density on *)
					Analysis`Private`yDensity=True;
					yAxisSuccess=Length@Cases[Setting@First@Cases[graphic2D,_Graphics,-1],_Line,-1]==2;

					(* Turn both off *)
					Analysis`Private`xDensity=False;
					Analysis`Private`yDensity=False;
					offSuccess=Length@Cases[Setting@First@Cases[graphic2D,_Graphics,-1],_Line,-1]==0;
				];

				(* Return True if all tests passed *)
				xAxisSuccess&&yAxisSuccess&&offSuccess
			],
			True
		],

		Test[
			"Density projection checkboxes toggle the display of lower-dimensional density projections in the 3D plot:",
			Module[
				{app,previews,preview1D,preview2D,preview3D,graphic3D,yzSuccess,xzSucess,offSuccess},

				(* Launch preview app *)
				app=AnalyzeClusters[sample3D,ClusteringAlgorithm->DBSCAN,Output->Preview,Upload->False];

				(* Extract Graphics from preview app *)
				previews=extractClustersDynamicModule[app];
				
				Part[#,1]&/@previews; (* DO NOT DELETE - this forces front end values into the app so we can test the graphics *)
				{selector,preview1D,preview2D,preview3D}=previews;

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3
					},

					(* Extract the 3D graphics *)
					graphic3D=First@Cases[preview3D,_Dynamic,{10}];

					(* Turn yz-density on *)
					Analysis`Private`yzDensity=True;
					yzSuccess=Length@Part[Setting@graphic3D,1]==6;

					(* Turn xz-density on *)
					Analysis`Private`xzDensity=True;
					xzSucess=Length@Part[Setting@graphic3D,1]==7;

					(* Turn all three off *)
					Analysis`Private`xyDensity=False;
					Analysis`Private`yzDensity=False;
					Analysis`Private`xzDensity=False;
					offSuccess=Length@Part[Setting@graphic3D,1]==4;
				];

				(* Return True if all tests passed *)
				yzSuccess&&xzSucess&&offSuccess

			],
			True
		],

		Test[
			"Buttons behave as intended in 1D app:",
			Module[
				{app,recordState,addGateButton,removeGateButton,addClusterButton,removeClusterButton,updateResultButton,addGateSuccess,removeGateSuccess,addClusterSuccess,removeClusterSuccess,updateSuccess},

				(* Launch preview app *)
				app=AnalyzeClusters[sample5D,ClusteringAlgorithm->DBSCAN,Output->Preview,Upload->False];

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3
					},

					(* Retrieve button functions from frontend *)
					recordState="recordState1D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					addGateButton="AddGate1D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					removeGateButton="RemoveGate1D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					addClusterButton="AddCluster1D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					removeClusterButton="RemoveCluster1D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					updateResultButton="UpdateResults1D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);

					(* Test 1: Add a gate to the first partition *)
					addGateButton[1];recordState[];
					addGateSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,1,True,True}];

					(* Test 2: Remove the added gate *)
					removeGateButton[1,1];recordState[];
					removeGateSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,None,True,False}];

					(* Test 3: Add a new partition *)
					addClusterButton[];recordState[];
					addClusterSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{2,None,True,False}];

					(* Test 4: Remove the added partition *)
					removeClusterButton[2];recordState[];
					removeClusterSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,None,True,False}];

					(* Test 5: Update the clustering result *)
					updateResultButton[];recordState[];
					updateSuccess=MatchQ["gatesChanged"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),False];
				];

				(* Return True if all tests passed *)
				And@@{addGateSuccess,removeGateSuccess,addClusterSuccess,removeClusterSuccess,updateSuccess}

			],
			True
		],

		Test[
			"Buttons behave as intended in 2D app:",
			Module[
				{app,recordState,addGateButton,removeGateButton,addClusterButton,removeClusterButton,updateResultButton,addGateSuccess,removeGateSuccess,addClusterSuccess,removeClusterSuccess,updateSuccess},

				(* Launch preview app *)
				app=AnalyzeClusters[sample5D,ClusteringAlgorithm->DBSCAN,Output->Preview,Upload->False];

				(* The clusters preview uses a wormhole (InheritScope->True) to share these dims with the selector pane, *)
				(* so these must be explicitly set if we test one pane at a time. *)
				Block[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3
					},

					(* Retrieve button functions from frontend *)
					recordState="recordState2D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					addGateButton="AddGate2D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					removeGateButton="RemoveGate2D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					addClusterButton="AddCluster2D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					removeClusterButton="RemoveCluster2D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
					updateResultButton="UpdateResults2D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);

					(* Test 1: Add a gate to the first partition *)
					addGateButton[1];recordState[];
					addGateSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,1,True}];

					(* Test 2: Remove the added gate *)
					removeGateButton[1,1];recordState[];
					removeGateSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,None,True}];

					(* Test 3: Add a new partition *)
					addClusterButton[];recordState[];
					addClusterSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{2,None,True}];

					(* Test 4: Remove the added partition *)
					removeClusterButton[2];recordState[];
					removeClusterSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,None,True}];

					(* Test 5: Update the clustering result *)
					updateResultButton[];recordState[];
					updateSuccess=MatchQ["gatesChanged"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),False];
				];

				(* Return True if all tests passed *)
				And@@{addGateSuccess,removeGateSuccess,addClusterSuccess,removeClusterSuccess,updateSuccess}
			],
			True
		],

		Test[
			"Buttons behave as intended in 3D app:",
			Module[
				{app,recordState,addGateButton,removeGateButton,addClusterButton,removeClusterButton,updateResultButton,addGateSuccess,removeGateSuccess,addClusterSuccess,removeClusterSuccess,updateSuccess},

				(* Launch preview app *)
				app=AnalyzeClusters[sample5D,ClusteringAlgorithm->DBSCAN,Output->Preview,Upload->False];

				(* Retrieve button functions from frontend *)
				recordState="recordState3D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
				addGateButton="AddGate3D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
				removeGateButton="RemoveGate3D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
				addClusterButton="AddCluster3D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
				removeClusterButton="RemoveCluster3D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
				updateResultButton="UpdateResults3D"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);

				With[
					{
						Analysis`Private`app1Ddim1=1,Analysis`Private`app2Ddim1=1,
						Analysis`Private`app2Ddim2=2,Analysis`Private`app3Ddim1=1,
						Analysis`Private`app3Ddim2=2,Analysis`Private`app3Ddim3=3,
						bbCenter=Mean/@{MinMax[Part[sample5D,All,1],Scaled[0.1]],MinMax[Part[sample5D,All,2],Scaled[0.1]],MinMax[Part[sample5D,All,3],Scaled[0.1]]},
						bbRange=(Last[#]-First[#])&/@{MinMax[Part[sample5D,All,1],Scaled[0.1]],MinMax[Part[sample5D,All,2],Scaled[0.1]],MinMax[Part[sample5D,All,3],Scaled[0.1]]}
					},

					(* Test 1: Add a gate to the first partition *)
					addGateButton[1,bbCenter,bbRange];recordState[];
					addGateSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,1,True,True}];

					(* Test 2: Remove the added gate *)
					removeGateButton[1,1,bbCenter,bbRange];recordState[];
					removeGateSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,None,True,False}];

					(* Test 3: Add a new partition *)
					addClusterButton[bbCenter,bbRange];recordState[];
					addClusterSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{2,None,True,False}];

					(* Test 4: Remove the added partition *)
					removeClusterButton[2,bbCenter,bbRange];recordState[];
					removeClusterSuccess=MatchQ[{"clusterIndex","gateIndex","gatesChanged","showInstructions"}/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),{1,None,True,False}];

					(* Test 5: Update the clustering result *)
					updateResultButton[];recordState[];
					updateSuccess=MatchQ["gatesChanged"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]),False];

				];

				(* Return True if all tests passed *)
				And@@{addGateSuccess,removeGateSuccess,addClusterSuccess,removeClusterSuccess,updateSuccess}

			],
			True
		],

		Test["Cluster names update dynamically in the automatic preview when options are changed:",
			Module[{autoApp,clustersApp,app1D,app2D,table1D,table2D,checks1D,checks2D},
				autoApp=AnalyzeClusters[
					sample2D,
					ClusteringAlgorithm->KMeans,
					NumberOfClusters->2,
					Output->Preview
				];
				LogPreviewChanges[PreviewSymbol[AnalyzeClusters],ClusterLabels->{"A","B"}];
				(* Extract the underlying clusters app  *)
				clustersApp=FirstOrDefault[autoApp];
				(* Load dynamic module variables from the front-end *)
				First[clustersApp];
				(* Extract sub-apps *)
				{app1D,app2D}= extractClustersApps[clustersApp];
				
				Block[
					{
						Analysis`Private`app1Ddim1 = 1, Analysis`Private`app2Ddim1 = 1,
						Analysis`Private`app2Ddim2 = 2
					},
					
					(* Load apps into memory *)
					Part[app1D,1];Part[app2D,1];
					(* Sorry, but this is the best way I could find to strip out rows of the clustering summary *)
					table1D=Part[app1D/.{d:_Dynamic:>Setting[d]},2,1,1,-1,1,1,1,1,All,1];
					checks1D=And@@MapThread[StringMatchQ[#1,#2]&,{Rest[table1D],{"A"~~__,"B"~~__}}];
					table2D=Part[app2D/.{d:_Dynamic:>Setting[d]},2,1,1,-1,1,1,1,1,All,1];
					checks2D=And@@MapThread[StringMatchQ[#1,#2]&,{Rest[table1D],{"A"~~__,"B"~~__}}];
					(* Check if conditions match *)
					And[checks1D,checks2D]
					
				]
			],
			True
		],

		Test["Cluster names update dynamically in the manual preview when options are changed:",
			Module[
				{
					manualApp,clustersApp,app1D,app2D,table1D,table2D,strings1D,strings2D,
					labels1D,labels2D,checks1D,checks2D
				},
				manualApp=AnalyzeClusters[
					sample2D,
					ClusteringAlgorithm->KMeans,
					ManualGates->{{{1,2,Polygon[{{8.71, 13.86}, {8.32, 16.64}, {10.14, 17.18}, {12.46, 15.379999999999999`}, {12.545, 14.34}, {11.615, 12.719999999999999`}, {10.615, 12.58}, {9.165000000000001, 12.899999999999999`}, {8.775, 13.}}],Include}},{{1,2,Polygon[{{13.045, 9.219999999999999}, {13.15, 12.64}, {15.295, 12.6}, {16.92, 10.16}, {16.855, 8.54}, {15.535, 7.92}, {13.95, 7.96}}],Include}}},
					Output->Preview
				];
				(* Emulate renaming the clusters from the builder preview *)
				LogPreviewChanges[PreviewSymbol[AnalyzeClusters],ClusterLabels->{"A","B"}];
				(* Extract the underlying clusters app  *)
				clustersApp=FirstOrDefault[manualApp];
				(* Load dynamic module variables from the front-end *)
				First[clustersApp];
				(* Extract sub-apps *)
				{app1D,app2D}=extractClustersApps[clustersApp];
				
				Block[
					{
						Analysis`Private`app1Ddim1 = 1, Analysis`Private`app2Ddim1 = 1,
						Analysis`Private`app2Ddim2 = 2
					},
				
					(* Load apps into memory *)
					Part[app1D,1];Part[app2D,1];
					(* Sorry, but this is the best way I could find to strip out rows of the clustering summary *)
					table1D=Part[app1D/.{d:_Dynamic:>Setting[d]},2,1,1,-1,1,1,;;2];
					strings1D=Cases[table1D,_Style,12]/.{s_Style:>First[s]};
					labels1D=Select[strings1D,StringMatchQ[#,__~~"points)"]&];
					checks1D=And@@MapThread[StringMatchQ[#1,#2]&,{labels1D,{"A"~~__,"B"~~__}}];
					table2D=Part[app2D/.{d:_Dynamic:>Setting[d]},2,1,1,-1,1,1,;;2];
					strings2D=Cases[table2D,_Style,12]/.{s_Style:>First[s]};
					labels2D=Select[strings2D,StringMatchQ[#,__~~"points)"]&];
					checks2D=And@@MapThread[StringMatchQ[#1,#2]&,{labels2D,{"A"~~__,"B"~~__}}];
					And[checks1D,checks2D]
				]
			],
			True
		],

		Test["The update subclusters button works and generates valid graphics:",
			Module[{pkt,preview,makeGridButton,buttonsGrid,buttons,buttonPlots},
				{pkt,preview}=AnalyzeClusters[
					sample5D,
					ClusteringAlgorithm->KMeans,
					NumberOfClusters->2,
					Upload->False,
					Output->{Result,Preview}
				];
				(* Use the tagging rules to *)
				makeGridButton="SelectorMakeGrid"/.(TaggingRules/.Options[$FrontEndSession,TaggingRules]);
				buttonsGrid=makeGridButton[pkt,{1,3,5},{2,3},True];
				buttons=Cases[Flatten[buttonsGrid[[1]]],_Button];
				And@@(ValidGraphicsQ[First/@buttons])
			],
			True
		]
	},
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
	SetUp:>{
		(* Track created objects *)
		$CreatedObjects={};
		sample1D = {2.76456, 2.63901, -2.73431, 1.11422, 2.49814, 1.24703, -1.65977, \
								2.00792, 1.20329, -1.76083, -2.97074, 1.22836, 2.12466, -1.52485, \
								2.05197, 0.0144635, 1.32985, 1.86378, 0.996042, -3.70344, -1.70974, \
								3.93464, -2.47104, 3.5295, -2.57374, -2.14422, -2.41839, -2.13955, \
								1.5219, -3.60246, -1.1703, -2.1024, 3.70275, 1.03382, 2.38463, \
								-2.29242, -2.74348, 2.38022, -2.54978, 1.59935, 1.56162, 1.9604, \
								1.65449, -0.00472201, -2.22681, -0.27061, 2.15878, 2.62274, 2.58745, \
								-1.80757, 2.08766, -2.03597, 1.7908, -1.79118, -2.76118, -0.869364, \
								1.82064, -1.68587, 2.14474, 3.09798, -1.44892, 2.27813, 0.522918, \
								2.16831, 1.58175, 2.76277, -2.92604, -2.3015, -1.81813, 1.31344, \
								3.51836, 1.76434, -2.96349, 0.0274405, -1.78484, 1.66949, -1.92847, \
								3.24733, -1.37026, 2.48453, -2.8884, 1.35922, 1.30889, -3.30711, \
								2.25824, 1.76495, -2.08617, 3.62074, 4.15418, 1.64393, 2.64936, \
								2.72598, -1.74951, -2.72641, 3.97501, -2.58093, -1.62871, -4.77728, \
								-1.79251, 1.87448};
		sample2D = {{10.1083, 14.5213}, {10.4397, 15.9217}, {15.1619, 10.7892}, {10.1853,
							   14.4473}, {14.9402, 9.28496}, {12.7732, 8.54725}, {9.63268,
							  15.4336}, {14.9745, 9.51215}, {13.7335, 10.2914}, {9.05917,
							  14.872}, {9.30969, 15.0371}, {14.6119, 12.5623}, {14.3677,
							  10.5836}, {14.9775, 10.4074}, {11.284, 14.4453}, {14.8761,
							  10.4021}, {15.3679, 10.0214}, {16.1506, 9.72156}, {14.9412,
							  10.509}, {14.8344, 10.0737}, {15.386, 11.066}, {9.82523,
							  14.1153}, {10.2553, 14.8242}, {14.5711, 9.6657}, {15.368,
							  10.9255}, {9.48218, 14.576}, {9.56631, 14.7584}, {15.1576,
							  9.72437}, {15.8177, 9.59954}, {8.3598, 15.4425}, {15.6032,
							  9.28328}, {15.4817, 9.06949}, {14.7546, 10.9374}, {15.4257,
							  10.0558}, {10.1936, 14.7435}, {9.44287, 14.0018}, {9.74429,
							  15.5555}, {9.66728, 14.3097}, {14.5796, 10.1338}, {15.1016,
							  11.9172}, {9.30599, 14.5405}, {14.3611, 9.90937}, {14.8227,
							  9.64876}, {15.1289, 9.49967}, {10.9378, 15.721}, {15.1574,
							  10.0872}, {14.9205, 10.5136}, {14.6887, 10.1257}, {12.8551,
							  9.75527}, {15.1918, 10.0085}, {14.1775, 9.68763}, {9.61187,
							  15.0019}, {9.82742, 15.6624}, {9.37812, 16.9643}, {15.2469,
							  10.4752}, {9.66083, 16.2318}, {15.5388, 9.58382}, {13.8297,
							  9.72469}, {15.1395, 11.7081}, {10.3236, 14.6374}, {14.564,
							  9.66397}, {15.561, 9.47646}, {9.99688, 16.4928}, {10.2007,
							  15.8877}, {15.07, 9.84718}, {14.6307, 10.4684}, {10.604,
							  15.2796}, {10.8885, 14.6186}, {14.7662, 9.51472}, {14.9381,
							  10.5283}, {10.0625, 15.4425}, {16.3767, 9.55003}, {9.48602,
							  15.7086}, {11.4988, 15.6608}, {15.7509, 10.1222}, {15.6142,
							  9.48675}, {16.5582, 9.12858}, {14.7801, 10.0102}, {14.9847,
							  9.89383}, {14.1352, 9.43269}, {15.2803, 10.266}, {16.1231,
							  9.70355}, {15.8878, 9.55199}, {15.05, 10.4673}, {10.2044,
							  15.9047}, {10.9374, 15.8282}, {15.0359, 11.7449}, {15.0213,
							  10.259}, {14.982, 9.20448}, {10.3815, 15.8665}, {9.45709,
							  13.9891}, {15.4815, 9.75772}, {14.5978, 11.2682}, {9.58535,
							  14.2957}, {10.6097, 14.7372}, {13.4784, 10.2954}, {10.6784,
							  14.8211}, {8.81731, 14.2282}, {9.5664, 15.6583}, {9.87198, 14.6075}};
		sample3D = {{14.5192, 9.40337, 10.3308}, {14.0234, 11.7445, 11.027}, {10.0225,
							  10.9658, 14.3678}, {10.631, 10.8411, 15.1807}, {9.64799, 15.435,
							  9.51502}, {9.46336, 9.19765, 14.3638}, {11.2119, 10.4624,
							  15.4724}, {9.16702, 16.4043, 9.61799}, {16.5836, 10.4487,
							  10.6078}, {9.83303, 15.3262, 9.27899}, {10.7373, 15.008,
							  10.6143}, {10.7231, 10.574, 15.2567}, {14.9303, 11.2277,
							  10.5435}, {8.34096, 9.75971, 15.3291}, {8.75704, 10.0391,
							  14.048}, {8.83909, 14.5614, 9.66419}, {11.1342, 9.78233,
							  14.9463}, {9.0885, 15.6632, 10.6994}, {14.84, 10.7057,
							  9.2047}, {15.369, 9.78524, 10.0669}, {15.9633, 9.5211,
							  9.15832}, {9.31786, 14.5933, 10.2495}, {14.869, 10.6865,
							  9.41608}, {10.3863, 10.6984, 15.4433}, {8.88666, 15.3206,
							  9.08877}, {9.88576, 10.611, 15.0784}, {14.7054, 10.3469,
							  10.3719}, {15.3047, 9.73491, 9.66913}, {14.4728, 10.4917,
							  9.632}, {14.639, 10.7928, 10.2821}, {14.6358, 9.53894,
							  9.50377}, {10.9497, 8.371, 15.0516}, {10.0581, 15.1557,
							  10.1921}, {15.3263, 9.664, 9.42259}, {10.0876, 9.87748,
							  15.5587}, {10.325, 10.5443, 15.692}, {10.2265, 9.16182,
							  14.5596}, {9.80837, 14.5592, 11.0639}, {10.033, 14.2449,
							  9.79375}, {11.0603, 10.3963, 14.2359}, {15.1768, 10.0568,
							  10.5383}, {10.3539, 14.6463, 10.5677}, {9.31185, 14.9186,
							  10.5419}, {9.78312, 15.2603, 11.2155}, {10.4064, 9.65751,
							  16.4638}, {9.57226, 9.51241, 15.6823}, {15.0837, 10.2605,
							  10.1566}, {14.3267, 9.87083, 9.5001}, {14.5816, 9.72166,
							  9.04688}, {15.923, 10.0116, 11.4106}, {9.58248, 10.9047,
							  14.3581}, {10.3155, 9.42357, 14.7582}, {14.5843, 8.74809,
							  10.319}, {9.52504, 9.72321, 15.3269}, {14.9927, 9.24453,
							  10.0989}, {9.63326, 15.7792, 8.79577}, {10.3938, 9.8533,
							  14.9028}, {15.2078, 10.0645, 9.87736}, {9.74603, 15.2076,
							  10.3342}, {15.2612, 10.7335, 9.55647}, {13.7817, 10.3167,
							  9.96879}, {15.634, 10.3276, 8.93186}, {11.0759, 10.2138,
							  14.9495}, {10.0431, 15.397, 9.50679}, {14.4639, 9.62451,
							  10.5542}, {8.83761, 16.0965, 11.7679}, {15.3351, 11.1075,
							  10.4242}, {11.2233, 16.5596, 10.5033}, {10.5631, 15.0741,
							  9.61206}, {9.71941, 9.55196, 14.8145}, {9.4582, 10.2498,
							  14.7719}, {15.8659, 9.11897, 9.52715}, {14.9648, 11.0485,
							  9.4424}, {8.32447, 14.7927, 10.1297}, {9.62097, 9.52552,
							  14.9084}, {14.1117, 9.99611, 10.169}, {15.5356, 9.27077,
							  10.7057}, {15.9775, 12.2338, 11.1857}, {10.1162, 14.2613,
							  8.93387}, {8.71396, 14.8426, 9.96319}, {10.5211, 13.8054,
							  9.56228}, {9.88621, 14.5561, 10.0998}, {14.7237, 10.0158,
							  10.735}, {16.3607, 10.9958, 8.52098}, {11.2324, 9.84861,
							  15.6088}, {11.5248, 16.851, 9.63979}, {14.6177, 8.41208,
							  11.1644}, {15.0116, 8.56804, 9.19389}, {14.2306, 10.2454,
							  10.6756}, {14.4034, 11.2457, 11.2276}, {14.8609, 10.6976,
							  9.07999}, {9.48997, 10.2532, 15.0217}, {9.28543, 10.1958,
							  16.0236}, {15.8394, 9.63504, 9.31923}, {15.5867, 10.9134,
							  10.1843}, {8.7676, 9.98797, 16.0264}, {11.0074, 9.77713,
							  14.2867}, {10.1784, 9.43394, 15.4104}, {10.1986, 9.86429,
							  15.4396}, {10.5048, 11.2851, 16.7863}};
		sample5D = {{11.5563, 9.83606, 14.8967, 10.3856, 9.96366}, {15.2719, 10.8688,
							  9.41588, 9.44675, 10.7089}, {14.4699, 10.9204, 9.16719, 11.9529,
							  9.15097}, {9.52201, 16.5728, 10.0647, 9.88185, 9.91134}, {10.2914,
							  9.55713, 10.8695, 15.5108, 10.603}, {9.43273, 10.0302, 9.94627,
							  16.4771, 9.83658}, {9.59671, 9.74179, 15.6477, 9.49843,
							  10.0562}, {9.35986, 10.0472, 10.8383, 11.0382, 15.3787}, {9.11683,
							  15.4983, 8.70692, 9.39204, 9.64961}, {15.376, 8.69288, 10.0639,
							  10.5203, 9.66686}, {8.69906, 10.1134, 10.1776, 9.79685,
							  15.7328}, {15.0012, 10.2837, 9.31664, 10.019, 9.25105}, {10.3272,
							  11.0823, 10.031, 14.0333, 9.54864}, {9.68347, 8.88054, 14.43,
							  10.1576, 9.59933}, {9.10549, 15.7686, 10.334, 9.40164,
							  9.75567}, {15.6399, 9.3966, 10.0252, 10.4499, 8.6907}, {10.0993,
							  8.94287, 15.054, 9.17505, 10.8389}, {9.95935, 9.11746, 14.5517,
							  9.32076, 10.8695}, {10.7853, 10.2558, 10.0524, 9.44606,
							  13.0598}, {11.5447, 9.18347, 9.67141, 14.5199, 11.5933}, {9.35861,
							  14.4357, 10.1673, 8.84649, 10.9458}, {10.4877, 10.1733, 9.31246,
							  10.4425, 13.5476}, {14.7876, 9.83269, 8.93301, 11.2869,
							  8.9942}, {10.1811, 9.9798, 15.5631, 10.3264, 9.49888}, {9.92388,
							  15.3378, 10.9951, 9.84377, 10.3839}, {9.36628, 9.32132, 9.66182,
							  9.88763, 15.0021}, {10.0252, 9.03555, 9.93775, 9.73571,
							  14.3853}, {10.2232, 15.067, 10.2589, 9.70464, 9.12198}, {13.9927,
							  9.46727, 10.8553, 11.2251, 10.7067}, {10.3105, 8.10472, 10.6201,
							  10.8167, 15.2334}, {8.82963, 11.2249, 14.1623, 9.41469,
							  11.2769}, {9.61437, 10.2836, 15.6624, 10.6445, 8.53864}, {14.3989,
							  10.0221, 9.51196, 10.0969, 10.1652}, {9.01829, 15.8082, 10.5373,
							  9.64813, 10.1475}, {9.86333, 9.57339, 10.3787, 10.2468,
							  14.0257}, {15.2943, 9.45562, 9.2069, 9.35481, 11.5877}, {9.97619,
							  9.92912, 15.7903, 9.96735, 8.90721}, {9.35719, 9.27059, 9.95188,
							  14.0787, 9.43696}, {15.911, 10.4027, 8.81304, 9.59708,
							  9.88947}, {10.1907, 10.4745, 9.54208, 15.2653, 9.22456}, {9.92068,
							  9.68694, 8.66371, 9.57895, 14.246}, {13.3523, 10.7441, 10.4395,
							  9.64753, 11.1574}, {9.50838, 10.9508, 14.4495, 9.68254,
							  10.5944}, {9.39291, 14.9658, 11.0283, 9.31953, 9.23861}, {13.7248,
							  10.3901, 9.0096, 10.326, 9.97822}, {9.44993, 10.2969, 16.1893,
							  8.52771, 9.01023}, {11.5984, 10.3522, 10.8045, 15.2991,
							  10.5502}, {14.8693, 9.98128, 10.0157, 10.1796, 10.5991}, {10.4498,
							  9.06993, 15.526, 10.7592, 10.4632}, {10.5039, 10.3114, 15.9026,
							  11.203, 9.38834}, {14.0749, 10.9459, 10.1029, 9.5957,
							  10.3212}, {9.97258, 9.86139, 14.8696, 9.70848, 10.9032}, {9.57012,
							  9.53601, 9.36538, 15.2571, 9.64725}, {14.513, 10.5276, 11.3373,
							  9.83694, 9.81347}, {10.3334, 14.1681, 10.7645, 8.43869,
							  10.0797}, {16.1523, 8.91091, 9.76995, 9.79878, 10.0069}, {9.9158,
							  14.1335, 10.3246, 9.05024, 10.3744}, {8.55412, 11.689, 9.51611,
							  13.9328, 9.7812}, {10.6566, 14.229, 10.7233, 9.68929,
							  9.39909}, {9.83202, 10.1846, 9.55615, 8.89973, 14.1531}, {9.46723,
							  8.9332, 9.31155, 16.59, 8.12862}, {10.0887, 10.0896, 9.78169,
							  15.7136, 9.51208}, {10.5475, 11.6664, 9.43914, 14.8801,
							  8.95649}, {10.5136, 9.95144, 9.41552, 8.88819, 14.2216}, {15.0036,
							  9.78758, 10.2662, 9.05962, 10.5888}, {13.9853, 9.04278, 10.1364,
							  10.1127, 9.86405}, {11.5863, 9.5667, 11.5094, 9.86507,
							  14.181}, {13.6046, 9.63226, 10.5552, 9.46711, 9.83236}, {9.08337,
							  14.8693, 10.0871, 9.69784, 11.1478}, {10.6002, 10.8233, 10.2447,
							  14.2651, 11.0955}, {9.49681, 10.5525, 9.90385, 14.9523,
							  10.1622}, {9.46394, 14.08, 8.8391, 9.36928, 9.64692}, {10.3736,
							  15.8005, 9.15973, 10.26, 9.45368}, {10.6063, 10.4271, 10.3197,
							  14.2003, 9.92811}, {9.35858, 9.93326, 14.2861, 10.264,
							  10.1711}, {14.3484, 8.77801, 10.7236, 10.0347, 8.55776}, {10.8485,
							  9.84741, 9.81146, 9.94553, 15.701}, {9.87637, 9.68015, 8.87782,
							  14.7009, 8.28184}, {14.58, 8.6577, 10.0699, 10.5051,
							  10.3226}, {16.1503, 9.23609, 10.2235, 10.1977, 9.96131}, {10.2343,
							  9.44976, 10.1957, 10.3911, 15.5068}, {9.67643, 8.78943, 8.91285,
							  10.1703, 16.4423}, {11.3329, 10.2665, 10.0966, 14.337,
							  9.01681}, {9.40464, 11.2968, 8.27202, 15.5675, 9.98361}, {9.4851,
							  15.1179, 10.0033, 9.02441, 10.6304}, {9.67628, 10.6073, 9.93071,
							  14.0929, 9.38381}, {14.3582, 9.96967, 10.7878, 9.40742,
							  9.36181}, {9.75128, 15.477, 9.73037, 9.464, 9.21243}, {10.2294,
							  10.0025, 15.2633, 9.78696, 9.22094}, {8.73893, 9.94054, 10.872,
							  15.0546, 9.35843}, {9.51664, 8.71521, 14.2734, 9.93935,
							  8.43645}, {10.7705, 15.2758, 10.0383, 10.4295, 10.8297}, {10.8384,
							  9.01127, 15.9815, 10.0104, 10.393}, {10.581, 9.74842, 8.66225,
							  9.13472, 14.4575}, {9.34053, 10.5316, 15.0952, 9.36147,
							  8.88349}, {10.0548, 14.8085, 10.7424, 11.0861, 10.5511}, {10.6452,
							  9.3943, 15.9175, 8.75673, 10.4073}, {14.7452, 9.00732, 9.62563,
							  9.22377, 10.2523}, {9.34273, 10.9241, 15.0142, 9.14938,
							  10.7296}, {9.69809, 14.0783, 8.46111, 9.86284, 9.70487}};
	},
	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(*AnalyzeClustersOptions*)


DefineTests[AnalyzeClustersOptions,
	{
		Example[{Basic,"Return the resolved options for a 1D dataset:"},
			AnalyzeClustersOptions[sample1D],
			_Grid
		],
		Example[{Basic,"Return the resolved options for a 2D dataset clustered using K-means:"},
			AnalyzeClustersOptions[sample2D, NumberOfClusters->2, ClusteringAlgorithm->KMeans],
			_Grid
		],
		Example[{Basic,"Return the resolved options for a 5D dataset clustered using DBSCAN:"},
			AnalyzeClustersOptions[sample5D, ClusteringAlgorithm->DBSCAN],
			_Grid
		],
		Example[{Options,OutputFormat,"By default, AnalyzeClustersOption returns a table of resolved options:"},
			AnalyzeClustersOptions[sample3D,OutputFormat->Table],
			_Grid
		],
		Example[{Options,OutputFormat,"Return the resolved options as a list:"},
			AnalyzeClustersOptions[sample2D,OutputFormat->List],
			{
				Scale->Linear,
				Normalize->False,
				Method->Automatic,
				ManualGates->Null,
				ClusteringAlgorithm->DBSCAN,
				NumberOfClusters->Automatic,
				Domain->{},
				ClusterDomainOutliers->False,
				ClusteredDimensions->{1,2},
				DistanceFunction->EuclideanDistance,
				PerformanceGoal->Speed,
				CriterionFunction->Silhouette,
				DimensionLabels->None,
				DimensionUnits->{1,1},
				(* the built in clustering algo, ClusteringComponents, changed in 12.1 and gets different number of groups in MM 12.0.1 and MM 13.2.1 *)
				ClusterLabels->{"Group 1","Group 2", "Group 3", "Group 4", "Group 5"}|{"Group 1","Group 2"},
				ClusterAssignments->{Null,Null,Null,Null,Null}|{Null, Null},
				CovarianceType->Null,
				MaxIterations->Null,
				NeighborhoodRadius->Automatic,
				NeighborsNumber->Automatic,
				ClusterDissimilarityFunction->Null,
				MaxEdgeLength->Null,
				DensityResamplingThreshold->Null,
				OutlierDensityQuantile->Null,
				TargetDensityQuantile->Null,
				Upload->False
			}
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>{
		(* Track created objects *)
		$CreatedObjects={};
		sample1D = {2.76456, 2.63901, -2.73431, 1.11422, 2.49814, 1.24703, -1.65977, \
								2.00792, 1.20329, -1.76083, -2.97074, 1.22836, 2.12466, -1.52485, \
								2.05197, 0.0144635, 1.32985, 1.86378, 0.996042, -3.70344, -1.70974, \
								3.93464, -2.47104, 3.5295, -2.57374, -2.14422, -2.41839, -2.13955, \
								1.5219, -3.60246, -1.1703, -2.1024, 3.70275, 1.03382, 2.38463, \
								-2.29242, -2.74348, 2.38022, -2.54978, 1.59935, 1.56162, 1.9604, \
								1.65449, -0.00472201, -2.22681, -0.27061, 2.15878, 2.62274, 2.58745, \
								-1.80757, 2.08766, -2.03597, 1.7908, -1.79118, -2.76118, -0.869364, \
								1.82064, -1.68587, 2.14474, 3.09798, -1.44892, 2.27813, 0.522918, \
								2.16831, 1.58175, 2.76277, -2.92604, -2.3015, -1.81813, 1.31344, \
								3.51836, 1.76434, -2.96349, 0.0274405, -1.78484, 1.66949, -1.92847, \
								3.24733, -1.37026, 2.48453, -2.8884, 1.35922, 1.30889, -3.30711, \
								2.25824, 1.76495, -2.08617, 3.62074, 4.15418, 1.64393, 2.64936, \
								2.72598, -1.74951, -2.72641, 3.97501, -2.58093, -1.62871, -4.77728, \
								-1.79251, 1.87448};
		sample2D = {{10.1083, 14.5213}, {10.4397, 15.9217}, {15.1619, 10.7892}, {10.1853,
							   14.4473}, {14.9402, 9.28496}, {12.7732, 8.54725}, {9.63268,
							  15.4336}, {14.9745, 9.51215}, {13.7335, 10.2914}, {9.05917,
							  14.872}, {9.30969, 15.0371}, {14.6119, 12.5623}, {14.3677,
							  10.5836}, {14.9775, 10.4074}, {11.284, 14.4453}, {14.8761,
							  10.4021}, {15.3679, 10.0214}, {16.1506, 9.72156}, {14.9412,
							  10.509}, {14.8344, 10.0737}, {15.386, 11.066}, {9.82523,
							  14.1153}, {10.2553, 14.8242}, {14.5711, 9.6657}, {15.368,
							  10.9255}, {9.48218, 14.576}, {9.56631, 14.7584}, {15.1576,
							  9.72437}, {15.8177, 9.59954}, {8.3598, 15.4425}, {15.6032,
							  9.28328}, {15.4817, 9.06949}, {14.7546, 10.9374}, {15.4257,
							  10.0558}, {10.1936, 14.7435}, {9.44287, 14.0018}, {9.74429,
							  15.5555}, {9.66728, 14.3097}, {14.5796, 10.1338}, {15.1016,
							  11.9172}, {9.30599, 14.5405}, {14.3611, 9.90937}, {14.8227,
							  9.64876}, {15.1289, 9.49967}, {10.9378, 15.721}, {15.1574,
							  10.0872}, {14.9205, 10.5136}, {14.6887, 10.1257}, {12.8551,
							  9.75527}, {15.1918, 10.0085}, {14.1775, 9.68763}, {9.61187,
							  15.0019}, {9.82742, 15.6624}, {9.37812, 16.9643}, {15.2469,
							  10.4752}, {9.66083, 16.2318}, {15.5388, 9.58382}, {13.8297,
							  9.72469}, {15.1395, 11.7081}, {10.3236, 14.6374}, {14.564,
							  9.66397}, {15.561, 9.47646}, {9.99688, 16.4928}, {10.2007,
							  15.8877}, {15.07, 9.84718}, {14.6307, 10.4684}, {10.604,
							  15.2796}, {10.8885, 14.6186}, {14.7662, 9.51472}, {14.9381,
							  10.5283}, {10.0625, 15.4425}, {16.3767, 9.55003}, {9.48602,
							  15.7086}, {11.4988, 15.6608}, {15.7509, 10.1222}, {15.6142,
							  9.48675}, {16.5582, 9.12858}, {14.7801, 10.0102}, {14.9847,
							  9.89383}, {14.1352, 9.43269}, {15.2803, 10.266}, {16.1231,
							  9.70355}, {15.8878, 9.55199}, {15.05, 10.4673}, {10.2044,
							  15.9047}, {10.9374, 15.8282}, {15.0359, 11.7449}, {15.0213,
							  10.259}, {14.982, 9.20448}, {10.3815, 15.8665}, {9.45709,
							  13.9891}, {15.4815, 9.75772}, {14.5978, 11.2682}, {9.58535,
							  14.2957}, {10.6097, 14.7372}, {13.4784, 10.2954}, {10.6784,
							  14.8211}, {8.81731, 14.2282}, {9.5664, 15.6583}, {9.87198, 14.6075}};
		sample3D = {{14.5192, 9.40337, 10.3308}, {14.0234, 11.7445, 11.027}, {10.0225,
							  10.9658, 14.3678}, {10.631, 10.8411, 15.1807}, {9.64799, 15.435,
							  9.51502}, {9.46336, 9.19765, 14.3638}, {11.2119, 10.4624,
							  15.4724}, {9.16702, 16.4043, 9.61799}, {16.5836, 10.4487,
							  10.6078}, {9.83303, 15.3262, 9.27899}, {10.7373, 15.008,
							  10.6143}, {10.7231, 10.574, 15.2567}, {14.9303, 11.2277,
							  10.5435}, {8.34096, 9.75971, 15.3291}, {8.75704, 10.0391,
							  14.048}, {8.83909, 14.5614, 9.66419}, {11.1342, 9.78233,
							  14.9463}, {9.0885, 15.6632, 10.6994}, {14.84, 10.7057,
							  9.2047}, {15.369, 9.78524, 10.0669}, {15.9633, 9.5211,
							  9.15832}, {9.31786, 14.5933, 10.2495}, {14.869, 10.6865,
							  9.41608}, {10.3863, 10.6984, 15.4433}, {8.88666, 15.3206,
							  9.08877}, {9.88576, 10.611, 15.0784}, {14.7054, 10.3469,
							  10.3719}, {15.3047, 9.73491, 9.66913}, {14.4728, 10.4917,
							  9.632}, {14.639, 10.7928, 10.2821}, {14.6358, 9.53894,
							  9.50377}, {10.9497, 8.371, 15.0516}, {10.0581, 15.1557,
							  10.1921}, {15.3263, 9.664, 9.42259}, {10.0876, 9.87748,
							  15.5587}, {10.325, 10.5443, 15.692}, {10.2265, 9.16182,
							  14.5596}, {9.80837, 14.5592, 11.0639}, {10.033, 14.2449,
							  9.79375}, {11.0603, 10.3963, 14.2359}, {15.1768, 10.0568,
							  10.5383}, {10.3539, 14.6463, 10.5677}, {9.31185, 14.9186,
							  10.5419}, {9.78312, 15.2603, 11.2155}, {10.4064, 9.65751,
							  16.4638}, {9.57226, 9.51241, 15.6823}, {15.0837, 10.2605,
							  10.1566}, {14.3267, 9.87083, 9.5001}, {14.5816, 9.72166,
							  9.04688}, {15.923, 10.0116, 11.4106}, {9.58248, 10.9047,
							  14.3581}, {10.3155, 9.42357, 14.7582}, {14.5843, 8.74809,
							  10.319}, {9.52504, 9.72321, 15.3269}, {14.9927, 9.24453,
							  10.0989}, {9.63326, 15.7792, 8.79577}, {10.3938, 9.8533,
							  14.9028}, {15.2078, 10.0645, 9.87736}, {9.74603, 15.2076,
							  10.3342}, {15.2612, 10.7335, 9.55647}, {13.7817, 10.3167,
							  9.96879}, {15.634, 10.3276, 8.93186}, {11.0759, 10.2138,
							  14.9495}, {10.0431, 15.397, 9.50679}, {14.4639, 9.62451,
							  10.5542}, {8.83761, 16.0965, 11.7679}, {15.3351, 11.1075,
							  10.4242}, {11.2233, 16.5596, 10.5033}, {10.5631, 15.0741,
							  9.61206}, {9.71941, 9.55196, 14.8145}, {9.4582, 10.2498,
							  14.7719}, {15.8659, 9.11897, 9.52715}, {14.9648, 11.0485,
							  9.4424}, {8.32447, 14.7927, 10.1297}, {9.62097, 9.52552,
							  14.9084}, {14.1117, 9.99611, 10.169}, {15.5356, 9.27077,
							  10.7057}, {15.9775, 12.2338, 11.1857}, {10.1162, 14.2613,
							  8.93387}, {8.71396, 14.8426, 9.96319}, {10.5211, 13.8054,
							  9.56228}, {9.88621, 14.5561, 10.0998}, {14.7237, 10.0158,
							  10.735}, {16.3607, 10.9958, 8.52098}, {11.2324, 9.84861,
							  15.6088}, {11.5248, 16.851, 9.63979}, {14.6177, 8.41208,
							  11.1644}, {15.0116, 8.56804, 9.19389}, {14.2306, 10.2454,
							  10.6756}, {14.4034, 11.2457, 11.2276}, {14.8609, 10.6976,
							  9.07999}, {9.48997, 10.2532, 15.0217}, {9.28543, 10.1958,
							  16.0236}, {15.8394, 9.63504, 9.31923}, {15.5867, 10.9134,
							  10.1843}, {8.7676, 9.98797, 16.0264}, {11.0074, 9.77713,
							  14.2867}, {10.1784, 9.43394, 15.4104}, {10.1986, 9.86429,
							  15.4396}, {10.5048, 11.2851, 16.7863}};
		sample5D = {{11.5563, 9.83606, 14.8967, 10.3856, 9.96366}, {15.2719, 10.8688,
							  9.41588, 9.44675, 10.7089}, {14.4699, 10.9204, 9.16719, 11.9529,
							  9.15097}, {9.52201, 16.5728, 10.0647, 9.88185, 9.91134}, {10.2914,
							  9.55713, 10.8695, 15.5108, 10.603}, {9.43273, 10.0302, 9.94627,
							  16.4771, 9.83658}, {9.59671, 9.74179, 15.6477, 9.49843,
							  10.0562}, {9.35986, 10.0472, 10.8383, 11.0382, 15.3787}, {9.11683,
							  15.4983, 8.70692, 9.39204, 9.64961}, {15.376, 8.69288, 10.0639,
							  10.5203, 9.66686}, {8.69906, 10.1134, 10.1776, 9.79685,
							  15.7328}, {15.0012, 10.2837, 9.31664, 10.019, 9.25105}, {10.3272,
							  11.0823, 10.031, 14.0333, 9.54864}, {9.68347, 8.88054, 14.43,
							  10.1576, 9.59933}, {9.10549, 15.7686, 10.334, 9.40164,
							  9.75567}, {15.6399, 9.3966, 10.0252, 10.4499, 8.6907}, {10.0993,
							  8.94287, 15.054, 9.17505, 10.8389}, {9.95935, 9.11746, 14.5517,
							  9.32076, 10.8695}, {10.7853, 10.2558, 10.0524, 9.44606,
							  13.0598}, {11.5447, 9.18347, 9.67141, 14.5199, 11.5933}, {9.35861,
							  14.4357, 10.1673, 8.84649, 10.9458}, {10.4877, 10.1733, 9.31246,
							  10.4425, 13.5476}, {14.7876, 9.83269, 8.93301, 11.2869,
							  8.9942}, {10.1811, 9.9798, 15.5631, 10.3264, 9.49888}, {9.92388,
							  15.3378, 10.9951, 9.84377, 10.3839}, {9.36628, 9.32132, 9.66182,
							  9.88763, 15.0021}, {10.0252, 9.03555, 9.93775, 9.73571,
							  14.3853}, {10.2232, 15.067, 10.2589, 9.70464, 9.12198}, {13.9927,
							  9.46727, 10.8553, 11.2251, 10.7067}, {10.3105, 8.10472, 10.6201,
							  10.8167, 15.2334}, {8.82963, 11.2249, 14.1623, 9.41469,
							  11.2769}, {9.61437, 10.2836, 15.6624, 10.6445, 8.53864}, {14.3989,
							  10.0221, 9.51196, 10.0969, 10.1652}, {9.01829, 15.8082, 10.5373,
							  9.64813, 10.1475}, {9.86333, 9.57339, 10.3787, 10.2468,
							  14.0257}, {15.2943, 9.45562, 9.2069, 9.35481, 11.5877}, {9.97619,
							  9.92912, 15.7903, 9.96735, 8.90721}, {9.35719, 9.27059, 9.95188,
							  14.0787, 9.43696}, {15.911, 10.4027, 8.81304, 9.59708,
							  9.88947}, {10.1907, 10.4745, 9.54208, 15.2653, 9.22456}, {9.92068,
							  9.68694, 8.66371, 9.57895, 14.246}, {13.3523, 10.7441, 10.4395,
							  9.64753, 11.1574}, {9.50838, 10.9508, 14.4495, 9.68254,
							  10.5944}, {9.39291, 14.9658, 11.0283, 9.31953, 9.23861}, {13.7248,
							  10.3901, 9.0096, 10.326, 9.97822}, {9.44993, 10.2969, 16.1893,
							  8.52771, 9.01023}, {11.5984, 10.3522, 10.8045, 15.2991,
							  10.5502}, {14.8693, 9.98128, 10.0157, 10.1796, 10.5991}, {10.4498,
							  9.06993, 15.526, 10.7592, 10.4632}, {10.5039, 10.3114, 15.9026,
							  11.203, 9.38834}, {14.0749, 10.9459, 10.1029, 9.5957,
							  10.3212}, {9.97258, 9.86139, 14.8696, 9.70848, 10.9032}, {9.57012,
							  9.53601, 9.36538, 15.2571, 9.64725}, {14.513, 10.5276, 11.3373,
							  9.83694, 9.81347}, {10.3334, 14.1681, 10.7645, 8.43869,
							  10.0797}, {16.1523, 8.91091, 9.76995, 9.79878, 10.0069}, {9.9158,
							  14.1335, 10.3246, 9.05024, 10.3744}, {8.55412, 11.689, 9.51611,
							  13.9328, 9.7812}, {10.6566, 14.229, 10.7233, 9.68929,
							  9.39909}, {9.83202, 10.1846, 9.55615, 8.89973, 14.1531}, {9.46723,
							  8.9332, 9.31155, 16.59, 8.12862}, {10.0887, 10.0896, 9.78169,
							  15.7136, 9.51208}, {10.5475, 11.6664, 9.43914, 14.8801,
							  8.95649}, {10.5136, 9.95144, 9.41552, 8.88819, 14.2216}, {15.0036,
							  9.78758, 10.2662, 9.05962, 10.5888}, {13.9853, 9.04278, 10.1364,
							  10.1127, 9.86405}, {11.5863, 9.5667, 11.5094, 9.86507,
							  14.181}, {13.6046, 9.63226, 10.5552, 9.46711, 9.83236}, {9.08337,
							  14.8693, 10.0871, 9.69784, 11.1478}, {10.6002, 10.8233, 10.2447,
							  14.2651, 11.0955}, {9.49681, 10.5525, 9.90385, 14.9523,
							  10.1622}, {9.46394, 14.08, 8.8391, 9.36928, 9.64692}, {10.3736,
							  15.8005, 9.15973, 10.26, 9.45368}, {10.6063, 10.4271, 10.3197,
							  14.2003, 9.92811}, {9.35858, 9.93326, 14.2861, 10.264,
							  10.1711}, {14.3484, 8.77801, 10.7236, 10.0347, 8.55776}, {10.8485,
							  9.84741, 9.81146, 9.94553, 15.701}, {9.87637, 9.68015, 8.87782,
							  14.7009, 8.28184}, {14.58, 8.6577, 10.0699, 10.5051,
							  10.3226}, {16.1503, 9.23609, 10.2235, 10.1977, 9.96131}, {10.2343,
							  9.44976, 10.1957, 10.3911, 15.5068}, {9.67643, 8.78943, 8.91285,
							  10.1703, 16.4423}, {11.3329, 10.2665, 10.0966, 14.337,
							  9.01681}, {9.40464, 11.2968, 8.27202, 15.5675, 9.98361}, {9.4851,
							  15.1179, 10.0033, 9.02441, 10.6304}, {9.67628, 10.6073, 9.93071,
							  14.0929, 9.38381}, {14.3582, 9.96967, 10.7878, 9.40742,
							  9.36181}, {9.75128, 15.477, 9.73037, 9.464, 9.21243}, {10.2294,
							  10.0025, 15.2633, 9.78696, 9.22094}, {8.73893, 9.94054, 10.872,
							  15.0546, 9.35843}, {9.51664, 8.71521, 14.2734, 9.93935,
							  8.43645}, {10.7705, 15.2758, 10.0383, 10.4295, 10.8297}, {10.8384,
							  9.01127, 15.9815, 10.0104, 10.393}, {10.581, 9.74842, 8.66225,
							  9.13472, 14.4575}, {9.34053, 10.5316, 15.0952, 9.36147,
							  8.88349}, {10.0548, 14.8085, 10.7424, 11.0861, 10.5511}, {10.6452,
							  9.3943, 15.9175, 8.75673, 10.4073}, {14.7452, 9.00732, 9.62563,
							  9.22377, 10.2523}, {9.34273, 10.9241, 15.0142, 9.14938,
							  10.7296}, {9.69809, 14.0783, 8.46111, 9.86284, 9.70487}};
	},
	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(*AnalyzeClustersPreview*)


DefineTests[AnalyzeClustersPreview,
	{
		Example[{Basic,"Show a preview for 1D clustering (by threshold):"},
			AnalyzeClustersPreview[sample1D,Method->Manual,ManualGates->{{{1,-0.5,Below}},{{1,0.5,Above}}}],
			_Image,
			Stubs:>{
				AnalyzeClustersPreview[sample1D,Method->Manual,ManualGates->{{{1,-0.5,Below}},{{1,0.5,Above}}}] =
					Rasterize[AnalyzeClustersPreview[sample1D,Method->Manual,ManualGates->{{{1,-0.5,Below}},{{1,0.5,Above}}},Upload->False],ImageResolution->100]
			}
		],
		Example[{Basic,"Show a preview for 2D automatic clustering:"},
			AnalyzeClustersPreview[sample2D],
			_Image,
			Stubs:>{
				AnalyzeClustersPreview[sample2D] =
					Rasterize[AnalyzeClustersPreview[sample2D,Upload->False],ImageResolution->100]
			}

		],
		Example[{Basic,"Show a preview for 5D automatic clustering:"},
			AnalyzeClustersPreview[sample5D],
			_Image,
			Stubs:>{
				AnalyzeClustersPreview[sample5D] =
					Rasterize[AnalyzeClustersPreview[sample5D,Upload->False],ImageResolution->100]
			}

		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>{
		(* Track created objects *)
		$CreatedObjects={};
		sample1D = {2.76456, 2.63901, -2.73431, 1.11422, 2.49814, 1.24703, -1.65977, \
								2.00792, 1.20329, -1.76083, -2.97074, 1.22836, 2.12466, -1.52485, \
								2.05197, 0.0144635, 1.32985, 1.86378, 0.996042, -3.70344, -1.70974, \
								3.93464, -2.47104, 3.5295, -2.57374, -2.14422, -2.41839, -2.13955, \
								1.5219, -3.60246, -1.1703, -2.1024, 3.70275, 1.03382, 2.38463, \
								-2.29242, -2.74348, 2.38022, -2.54978, 1.59935, 1.56162, 1.9604, \
								1.65449, -0.00472201, -2.22681, -0.27061, 2.15878, 2.62274, 2.58745, \
								-1.80757, 2.08766, -2.03597, 1.7908, -1.79118, -2.76118, -0.869364, \
								1.82064, -1.68587, 2.14474, 3.09798, -1.44892, 2.27813, 0.522918, \
								2.16831, 1.58175, 2.76277, -2.92604, -2.3015, -1.81813, 1.31344, \
								3.51836, 1.76434, -2.96349, 0.0274405, -1.78484, 1.66949, -1.92847, \
								3.24733, -1.37026, 2.48453, -2.8884, 1.35922, 1.30889, -3.30711, \
								2.25824, 1.76495, -2.08617, 3.62074, 4.15418, 1.64393, 2.64936, \
								2.72598, -1.74951, -2.72641, 3.97501, -2.58093, -1.62871, -4.77728, \
								-1.79251, 1.87448};
		sample2D = {{10.1083, 14.5213}, {10.4397, 15.9217}, {15.1619, 10.7892}, {10.1853,
							   14.4473}, {14.9402, 9.28496}, {12.7732, 8.54725}, {9.63268,
							  15.4336}, {14.9745, 9.51215}, {13.7335, 10.2914}, {9.05917,
							  14.872}, {9.30969, 15.0371}, {14.6119, 12.5623}, {14.3677,
							  10.5836}, {14.9775, 10.4074}, {11.284, 14.4453}, {14.8761,
							  10.4021}, {15.3679, 10.0214}, {16.1506, 9.72156}, {14.9412,
							  10.509}, {14.8344, 10.0737}, {15.386, 11.066}, {9.82523,
							  14.1153}, {10.2553, 14.8242}, {14.5711, 9.6657}, {15.368,
							  10.9255}, {9.48218, 14.576}, {9.56631, 14.7584}, {15.1576,
							  9.72437}, {15.8177, 9.59954}, {8.3598, 15.4425}, {15.6032,
							  9.28328}, {15.4817, 9.06949}, {14.7546, 10.9374}, {15.4257,
							  10.0558}, {10.1936, 14.7435}, {9.44287, 14.0018}, {9.74429,
							  15.5555}, {9.66728, 14.3097}, {14.5796, 10.1338}, {15.1016,
							  11.9172}, {9.30599, 14.5405}, {14.3611, 9.90937}, {14.8227,
							  9.64876}, {15.1289, 9.49967}, {10.9378, 15.721}, {15.1574,
							  10.0872}, {14.9205, 10.5136}, {14.6887, 10.1257}, {12.8551,
							  9.75527}, {15.1918, 10.0085}, {14.1775, 9.68763}, {9.61187,
							  15.0019}, {9.82742, 15.6624}, {9.37812, 16.9643}, {15.2469,
							  10.4752}, {9.66083, 16.2318}, {15.5388, 9.58382}, {13.8297,
							  9.72469}, {15.1395, 11.7081}, {10.3236, 14.6374}, {14.564,
							  9.66397}, {15.561, 9.47646}, {9.99688, 16.4928}, {10.2007,
							  15.8877}, {15.07, 9.84718}, {14.6307, 10.4684}, {10.604,
							  15.2796}, {10.8885, 14.6186}, {14.7662, 9.51472}, {14.9381,
							  10.5283}, {10.0625, 15.4425}, {16.3767, 9.55003}, {9.48602,
							  15.7086}, {11.4988, 15.6608}, {15.7509, 10.1222}, {15.6142,
							  9.48675}, {16.5582, 9.12858}, {14.7801, 10.0102}, {14.9847,
							  9.89383}, {14.1352, 9.43269}, {15.2803, 10.266}, {16.1231,
							  9.70355}, {15.8878, 9.55199}, {15.05, 10.4673}, {10.2044,
							  15.9047}, {10.9374, 15.8282}, {15.0359, 11.7449}, {15.0213,
							  10.259}, {14.982, 9.20448}, {10.3815, 15.8665}, {9.45709,
							  13.9891}, {15.4815, 9.75772}, {14.5978, 11.2682}, {9.58535,
							  14.2957}, {10.6097, 14.7372}, {13.4784, 10.2954}, {10.6784,
							  14.8211}, {8.81731, 14.2282}, {9.5664, 15.6583}, {9.87198, 14.6075}};
		sample3D = {{14.5192, 9.40337, 10.3308}, {14.0234, 11.7445, 11.027}, {10.0225,
							  10.9658, 14.3678}, {10.631, 10.8411, 15.1807}, {9.64799, 15.435,
							  9.51502}, {9.46336, 9.19765, 14.3638}, {11.2119, 10.4624,
							  15.4724}, {9.16702, 16.4043, 9.61799}, {16.5836, 10.4487,
							  10.6078}, {9.83303, 15.3262, 9.27899}, {10.7373, 15.008,
							  10.6143}, {10.7231, 10.574, 15.2567}, {14.9303, 11.2277,
							  10.5435}, {8.34096, 9.75971, 15.3291}, {8.75704, 10.0391,
							  14.048}, {8.83909, 14.5614, 9.66419}, {11.1342, 9.78233,
							  14.9463}, {9.0885, 15.6632, 10.6994}, {14.84, 10.7057,
							  9.2047}, {15.369, 9.78524, 10.0669}, {15.9633, 9.5211,
							  9.15832}, {9.31786, 14.5933, 10.2495}, {14.869, 10.6865,
							  9.41608}, {10.3863, 10.6984, 15.4433}, {8.88666, 15.3206,
							  9.08877}, {9.88576, 10.611, 15.0784}, {14.7054, 10.3469,
							  10.3719}, {15.3047, 9.73491, 9.66913}, {14.4728, 10.4917,
							  9.632}, {14.639, 10.7928, 10.2821}, {14.6358, 9.53894,
							  9.50377}, {10.9497, 8.371, 15.0516}, {10.0581, 15.1557,
							  10.1921}, {15.3263, 9.664, 9.42259}, {10.0876, 9.87748,
							  15.5587}, {10.325, 10.5443, 15.692}, {10.2265, 9.16182,
							  14.5596}, {9.80837, 14.5592, 11.0639}, {10.033, 14.2449,
							  9.79375}, {11.0603, 10.3963, 14.2359}, {15.1768, 10.0568,
							  10.5383}, {10.3539, 14.6463, 10.5677}, {9.31185, 14.9186,
							  10.5419}, {9.78312, 15.2603, 11.2155}, {10.4064, 9.65751,
							  16.4638}, {9.57226, 9.51241, 15.6823}, {15.0837, 10.2605,
							  10.1566}, {14.3267, 9.87083, 9.5001}, {14.5816, 9.72166,
							  9.04688}, {15.923, 10.0116, 11.4106}, {9.58248, 10.9047,
							  14.3581}, {10.3155, 9.42357, 14.7582}, {14.5843, 8.74809,
							  10.319}, {9.52504, 9.72321, 15.3269}, {14.9927, 9.24453,
							  10.0989}, {9.63326, 15.7792, 8.79577}, {10.3938, 9.8533,
							  14.9028}, {15.2078, 10.0645, 9.87736}, {9.74603, 15.2076,
							  10.3342}, {15.2612, 10.7335, 9.55647}, {13.7817, 10.3167,
							  9.96879}, {15.634, 10.3276, 8.93186}, {11.0759, 10.2138,
							  14.9495}, {10.0431, 15.397, 9.50679}, {14.4639, 9.62451,
							  10.5542}, {8.83761, 16.0965, 11.7679}, {15.3351, 11.1075,
							  10.4242}, {11.2233, 16.5596, 10.5033}, {10.5631, 15.0741,
							  9.61206}, {9.71941, 9.55196, 14.8145}, {9.4582, 10.2498,
							  14.7719}, {15.8659, 9.11897, 9.52715}, {14.9648, 11.0485,
							  9.4424}, {8.32447, 14.7927, 10.1297}, {9.62097, 9.52552,
							  14.9084}, {14.1117, 9.99611, 10.169}, {15.5356, 9.27077,
							  10.7057}, {15.9775, 12.2338, 11.1857}, {10.1162, 14.2613,
							  8.93387}, {8.71396, 14.8426, 9.96319}, {10.5211, 13.8054,
							  9.56228}, {9.88621, 14.5561, 10.0998}, {14.7237, 10.0158,
							  10.735}, {16.3607, 10.9958, 8.52098}, {11.2324, 9.84861,
							  15.6088}, {11.5248, 16.851, 9.63979}, {14.6177, 8.41208,
							  11.1644}, {15.0116, 8.56804, 9.19389}, {14.2306, 10.2454,
							  10.6756}, {14.4034, 11.2457, 11.2276}, {14.8609, 10.6976,
							  9.07999}, {9.48997, 10.2532, 15.0217}, {9.28543, 10.1958,
							  16.0236}, {15.8394, 9.63504, 9.31923}, {15.5867, 10.9134,
							  10.1843}, {8.7676, 9.98797, 16.0264}, {11.0074, 9.77713,
							  14.2867}, {10.1784, 9.43394, 15.4104}, {10.1986, 9.86429,
							  15.4396}, {10.5048, 11.2851, 16.7863}};
		sample5D = {{11.5563, 9.83606, 14.8967, 10.3856, 9.96366}, {15.2719, 10.8688,
							  9.41588, 9.44675, 10.7089}, {14.4699, 10.9204, 9.16719, 11.9529,
							  9.15097}, {9.52201, 16.5728, 10.0647, 9.88185, 9.91134}, {10.2914,
							  9.55713, 10.8695, 15.5108, 10.603}, {9.43273, 10.0302, 9.94627,
							  16.4771, 9.83658}, {9.59671, 9.74179, 15.6477, 9.49843,
							  10.0562}, {9.35986, 10.0472, 10.8383, 11.0382, 15.3787}, {9.11683,
							  15.4983, 8.70692, 9.39204, 9.64961}, {15.376, 8.69288, 10.0639,
							  10.5203, 9.66686}, {8.69906, 10.1134, 10.1776, 9.79685,
							  15.7328}, {15.0012, 10.2837, 9.31664, 10.019, 9.25105}, {10.3272,
							  11.0823, 10.031, 14.0333, 9.54864}, {9.68347, 8.88054, 14.43,
							  10.1576, 9.59933}, {9.10549, 15.7686, 10.334, 9.40164,
							  9.75567}, {15.6399, 9.3966, 10.0252, 10.4499, 8.6907}, {10.0993,
							  8.94287, 15.054, 9.17505, 10.8389}, {9.95935, 9.11746, 14.5517,
							  9.32076, 10.8695}, {10.7853, 10.2558, 10.0524, 9.44606,
							  13.0598}, {11.5447, 9.18347, 9.67141, 14.5199, 11.5933}, {9.35861,
							  14.4357, 10.1673, 8.84649, 10.9458}, {10.4877, 10.1733, 9.31246,
							  10.4425, 13.5476}, {14.7876, 9.83269, 8.93301, 11.2869,
							  8.9942}, {10.1811, 9.9798, 15.5631, 10.3264, 9.49888}, {9.92388,
							  15.3378, 10.9951, 9.84377, 10.3839}, {9.36628, 9.32132, 9.66182,
							  9.88763, 15.0021}, {10.0252, 9.03555, 9.93775, 9.73571,
							  14.3853}, {10.2232, 15.067, 10.2589, 9.70464, 9.12198}, {13.9927,
							  9.46727, 10.8553, 11.2251, 10.7067}, {10.3105, 8.10472, 10.6201,
							  10.8167, 15.2334}, {8.82963, 11.2249, 14.1623, 9.41469,
							  11.2769}, {9.61437, 10.2836, 15.6624, 10.6445, 8.53864}, {14.3989,
							  10.0221, 9.51196, 10.0969, 10.1652}, {9.01829, 15.8082, 10.5373,
							  9.64813, 10.1475}, {9.86333, 9.57339, 10.3787, 10.2468,
							  14.0257}, {15.2943, 9.45562, 9.2069, 9.35481, 11.5877}, {9.97619,
							  9.92912, 15.7903, 9.96735, 8.90721}, {9.35719, 9.27059, 9.95188,
							  14.0787, 9.43696}, {15.911, 10.4027, 8.81304, 9.59708,
							  9.88947}, {10.1907, 10.4745, 9.54208, 15.2653, 9.22456}, {9.92068,
							  9.68694, 8.66371, 9.57895, 14.246}, {13.3523, 10.7441, 10.4395,
							  9.64753, 11.1574}, {9.50838, 10.9508, 14.4495, 9.68254,
							  10.5944}, {9.39291, 14.9658, 11.0283, 9.31953, 9.23861}, {13.7248,
							  10.3901, 9.0096, 10.326, 9.97822}, {9.44993, 10.2969, 16.1893,
							  8.52771, 9.01023}, {11.5984, 10.3522, 10.8045, 15.2991,
							  10.5502}, {14.8693, 9.98128, 10.0157, 10.1796, 10.5991}, {10.4498,
							  9.06993, 15.526, 10.7592, 10.4632}, {10.5039, 10.3114, 15.9026,
							  11.203, 9.38834}, {14.0749, 10.9459, 10.1029, 9.5957,
							  10.3212}, {9.97258, 9.86139, 14.8696, 9.70848, 10.9032}, {9.57012,
							  9.53601, 9.36538, 15.2571, 9.64725}, {14.513, 10.5276, 11.3373,
							  9.83694, 9.81347}, {10.3334, 14.1681, 10.7645, 8.43869,
							  10.0797}, {16.1523, 8.91091, 9.76995, 9.79878, 10.0069}, {9.9158,
							  14.1335, 10.3246, 9.05024, 10.3744}, {8.55412, 11.689, 9.51611,
							  13.9328, 9.7812}, {10.6566, 14.229, 10.7233, 9.68929,
							  9.39909}, {9.83202, 10.1846, 9.55615, 8.89973, 14.1531}, {9.46723,
							  8.9332, 9.31155, 16.59, 8.12862}, {10.0887, 10.0896, 9.78169,
							  15.7136, 9.51208}, {10.5475, 11.6664, 9.43914, 14.8801,
							  8.95649}, {10.5136, 9.95144, 9.41552, 8.88819, 14.2216}, {15.0036,
							  9.78758, 10.2662, 9.05962, 10.5888}, {13.9853, 9.04278, 10.1364,
							  10.1127, 9.86405}, {11.5863, 9.5667, 11.5094, 9.86507,
							  14.181}, {13.6046, 9.63226, 10.5552, 9.46711, 9.83236}, {9.08337,
							  14.8693, 10.0871, 9.69784, 11.1478}, {10.6002, 10.8233, 10.2447,
							  14.2651, 11.0955}, {9.49681, 10.5525, 9.90385, 14.9523,
							  10.1622}, {9.46394, 14.08, 8.8391, 9.36928, 9.64692}, {10.3736,
							  15.8005, 9.15973, 10.26, 9.45368}, {10.6063, 10.4271, 10.3197,
							  14.2003, 9.92811}, {9.35858, 9.93326, 14.2861, 10.264,
							  10.1711}, {14.3484, 8.77801, 10.7236, 10.0347, 8.55776}, {10.8485,
							  9.84741, 9.81146, 9.94553, 15.701}, {9.87637, 9.68015, 8.87782,
							  14.7009, 8.28184}, {14.58, 8.6577, 10.0699, 10.5051,
							  10.3226}, {16.1503, 9.23609, 10.2235, 10.1977, 9.96131}, {10.2343,
							  9.44976, 10.1957, 10.3911, 15.5068}, {9.67643, 8.78943, 8.91285,
							  10.1703, 16.4423}, {11.3329, 10.2665, 10.0966, 14.337,
							  9.01681}, {9.40464, 11.2968, 8.27202, 15.5675, 9.98361}, {9.4851,
							  15.1179, 10.0033, 9.02441, 10.6304}, {9.67628, 10.6073, 9.93071,
							  14.0929, 9.38381}, {14.3582, 9.96967, 10.7878, 9.40742,
							  9.36181}, {9.75128, 15.477, 9.73037, 9.464, 9.21243}, {10.2294,
							  10.0025, 15.2633, 9.78696, 9.22094}, {8.73893, 9.94054, 10.872,
							  15.0546, 9.35843}, {9.51664, 8.71521, 14.2734, 9.93935,
							  8.43645}, {10.7705, 15.2758, 10.0383, 10.4295, 10.8297}, {10.8384,
							  9.01127, 15.9815, 10.0104, 10.393}, {10.581, 9.74842, 8.66225,
							  9.13472, 14.4575}, {9.34053, 10.5316, 15.0952, 9.36147,
							  8.88349}, {10.0548, 14.8085, 10.7424, 11.0861, 10.5511}, {10.6452,
							  9.3943, 15.9175, 8.75673, 10.4073}, {14.7452, 9.00732, 9.62563,
							  9.22377, 10.2523}, {9.34273, 10.9241, 15.0142, 9.14938,
							  10.7296}, {9.69809, 14.0783, 8.46111, 9.86284, 9.70487}};
	},
	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)
];

(* ::Subsubsection:: *)
(*ValidAnalyzeClustersQ*)


DefineTests[ValidAnalyzeClustersQ,
	{
		Example[{Basic,"Return True if all inputs and options are valid. This indicates the Analysis is ready to proceed:"},
			ValidAnalyzeClustersQ[sample5D],
			True
		],
		Example[{Basic,"Return False if analysis cannot continue, for example if the input is not supported or in an incorrect format:"},
			ValidAnalyzeClustersQ["Taco"],
			False
		],
		Example[{Options, OutputFormat, "By default, ValidAnalyzeClustersQ returns a boolean:"},
			ValidAnalyzeClustersQ[sample2D,OutputFormat->Boolean],
			True
		],
		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			ValidAnalyzeClustersQ[sample2D,OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose output indicating test passage/failure for each test. Here, the input is an invalid format so an error is shown:"},
			ValidAnalyzeClustersQ["Taco",Verbose->True],
			False
		],
		Example[{Options, Verbose, "Print verbose messages for failures only:"},
			ValidAnalyzeClustersQ["Taco",Verbose->Failures],
			False
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>{
		(* Track created objects *)
		$CreatedObjects={};
		sample1D = {2.76456, 2.63901, -2.73431, 1.11422, 2.49814, 1.24703, -1.65977, \
								2.00792, 1.20329, -1.76083, -2.97074, 1.22836, 2.12466, -1.52485, \
								2.05197, 0.0144635, 1.32985, 1.86378, 0.996042, -3.70344, -1.70974, \
								3.93464, -2.47104, 3.5295, -2.57374, -2.14422, -2.41839, -2.13955, \
								1.5219, -3.60246, -1.1703, -2.1024, 3.70275, 1.03382, 2.38463, \
								-2.29242, -2.74348, 2.38022, -2.54978, 1.59935, 1.56162, 1.9604, \
								1.65449, -0.00472201, -2.22681, -0.27061, 2.15878, 2.62274, 2.58745, \
								-1.80757, 2.08766, -2.03597, 1.7908, -1.79118, -2.76118, -0.869364, \
								1.82064, -1.68587, 2.14474, 3.09798, -1.44892, 2.27813, 0.522918, \
								2.16831, 1.58175, 2.76277, -2.92604, -2.3015, -1.81813, 1.31344, \
								3.51836, 1.76434, -2.96349, 0.0274405, -1.78484, 1.66949, -1.92847, \
								3.24733, -1.37026, 2.48453, -2.8884, 1.35922, 1.30889, -3.30711, \
								2.25824, 1.76495, -2.08617, 3.62074, 4.15418, 1.64393, 2.64936, \
								2.72598, -1.74951, -2.72641, 3.97501, -2.58093, -1.62871, -4.77728, \
								-1.79251, 1.87448};
		sample2D = {{10.1083, 14.5213}, {10.4397, 15.9217}, {15.1619, 10.7892}, {10.1853,
							   14.4473}, {14.9402, 9.28496}, {12.7732, 8.54725}, {9.63268,
							  15.4336}, {14.9745, 9.51215}, {13.7335, 10.2914}, {9.05917,
							  14.872}, {9.30969, 15.0371}, {14.6119, 12.5623}, {14.3677,
							  10.5836}, {14.9775, 10.4074}, {11.284, 14.4453}, {14.8761,
							  10.4021}, {15.3679, 10.0214}, {16.1506, 9.72156}, {14.9412,
							  10.509}, {14.8344, 10.0737}, {15.386, 11.066}, {9.82523,
							  14.1153}, {10.2553, 14.8242}, {14.5711, 9.6657}, {15.368,
							  10.9255}, {9.48218, 14.576}, {9.56631, 14.7584}, {15.1576,
							  9.72437}, {15.8177, 9.59954}, {8.3598, 15.4425}, {15.6032,
							  9.28328}, {15.4817, 9.06949}, {14.7546, 10.9374}, {15.4257,
							  10.0558}, {10.1936, 14.7435}, {9.44287, 14.0018}, {9.74429,
							  15.5555}, {9.66728, 14.3097}, {14.5796, 10.1338}, {15.1016,
							  11.9172}, {9.30599, 14.5405}, {14.3611, 9.90937}, {14.8227,
							  9.64876}, {15.1289, 9.49967}, {10.9378, 15.721}, {15.1574,
							  10.0872}, {14.9205, 10.5136}, {14.6887, 10.1257}, {12.8551,
							  9.75527}, {15.1918, 10.0085}, {14.1775, 9.68763}, {9.61187,
							  15.0019}, {9.82742, 15.6624}, {9.37812, 16.9643}, {15.2469,
							  10.4752}, {9.66083, 16.2318}, {15.5388, 9.58382}, {13.8297,
							  9.72469}, {15.1395, 11.7081}, {10.3236, 14.6374}, {14.564,
							  9.66397}, {15.561, 9.47646}, {9.99688, 16.4928}, {10.2007,
							  15.8877}, {15.07, 9.84718}, {14.6307, 10.4684}, {10.604,
							  15.2796}, {10.8885, 14.6186}, {14.7662, 9.51472}, {14.9381,
							  10.5283}, {10.0625, 15.4425}, {16.3767, 9.55003}, {9.48602,
							  15.7086}, {11.4988, 15.6608}, {15.7509, 10.1222}, {15.6142,
							  9.48675}, {16.5582, 9.12858}, {14.7801, 10.0102}, {14.9847,
							  9.89383}, {14.1352, 9.43269}, {15.2803, 10.266}, {16.1231,
							  9.70355}, {15.8878, 9.55199}, {15.05, 10.4673}, {10.2044,
							  15.9047}, {10.9374, 15.8282}, {15.0359, 11.7449}, {15.0213,
							  10.259}, {14.982, 9.20448}, {10.3815, 15.8665}, {9.45709,
							  13.9891}, {15.4815, 9.75772}, {14.5978, 11.2682}, {9.58535,
							  14.2957}, {10.6097, 14.7372}, {13.4784, 10.2954}, {10.6784,
							  14.8211}, {8.81731, 14.2282}, {9.5664, 15.6583}, {9.87198, 14.6075}};
		sample3D = {{14.5192, 9.40337, 10.3308}, {14.0234, 11.7445, 11.027}, {10.0225,
							  10.9658, 14.3678}, {10.631, 10.8411, 15.1807}, {9.64799, 15.435,
							  9.51502}, {9.46336, 9.19765, 14.3638}, {11.2119, 10.4624,
							  15.4724}, {9.16702, 16.4043, 9.61799}, {16.5836, 10.4487,
							  10.6078}, {9.83303, 15.3262, 9.27899}, {10.7373, 15.008,
							  10.6143}, {10.7231, 10.574, 15.2567}, {14.9303, 11.2277,
							  10.5435}, {8.34096, 9.75971, 15.3291}, {8.75704, 10.0391,
							  14.048}, {8.83909, 14.5614, 9.66419}, {11.1342, 9.78233,
							  14.9463}, {9.0885, 15.6632, 10.6994}, {14.84, 10.7057,
							  9.2047}, {15.369, 9.78524, 10.0669}, {15.9633, 9.5211,
							  9.15832}, {9.31786, 14.5933, 10.2495}, {14.869, 10.6865,
							  9.41608}, {10.3863, 10.6984, 15.4433}, {8.88666, 15.3206,
							  9.08877}, {9.88576, 10.611, 15.0784}, {14.7054, 10.3469,
							  10.3719}, {15.3047, 9.73491, 9.66913}, {14.4728, 10.4917,
							  9.632}, {14.639, 10.7928, 10.2821}, {14.6358, 9.53894,
							  9.50377}, {10.9497, 8.371, 15.0516}, {10.0581, 15.1557,
							  10.1921}, {15.3263, 9.664, 9.42259}, {10.0876, 9.87748,
							  15.5587}, {10.325, 10.5443, 15.692}, {10.2265, 9.16182,
							  14.5596}, {9.80837, 14.5592, 11.0639}, {10.033, 14.2449,
							  9.79375}, {11.0603, 10.3963, 14.2359}, {15.1768, 10.0568,
							  10.5383}, {10.3539, 14.6463, 10.5677}, {9.31185, 14.9186,
							  10.5419}, {9.78312, 15.2603, 11.2155}, {10.4064, 9.65751,
							  16.4638}, {9.57226, 9.51241, 15.6823}, {15.0837, 10.2605,
							  10.1566}, {14.3267, 9.87083, 9.5001}, {14.5816, 9.72166,
							  9.04688}, {15.923, 10.0116, 11.4106}, {9.58248, 10.9047,
							  14.3581}, {10.3155, 9.42357, 14.7582}, {14.5843, 8.74809,
							  10.319}, {9.52504, 9.72321, 15.3269}, {14.9927, 9.24453,
							  10.0989}, {9.63326, 15.7792, 8.79577}, {10.3938, 9.8533,
							  14.9028}, {15.2078, 10.0645, 9.87736}, {9.74603, 15.2076,
							  10.3342}, {15.2612, 10.7335, 9.55647}, {13.7817, 10.3167,
							  9.96879}, {15.634, 10.3276, 8.93186}, {11.0759, 10.2138,
							  14.9495}, {10.0431, 15.397, 9.50679}, {14.4639, 9.62451,
							  10.5542}, {8.83761, 16.0965, 11.7679}, {15.3351, 11.1075,
							  10.4242}, {11.2233, 16.5596, 10.5033}, {10.5631, 15.0741,
							  9.61206}, {9.71941, 9.55196, 14.8145}, {9.4582, 10.2498,
							  14.7719}, {15.8659, 9.11897, 9.52715}, {14.9648, 11.0485,
							  9.4424}, {8.32447, 14.7927, 10.1297}, {9.62097, 9.52552,
							  14.9084}, {14.1117, 9.99611, 10.169}, {15.5356, 9.27077,
							  10.7057}, {15.9775, 12.2338, 11.1857}, {10.1162, 14.2613,
							  8.93387}, {8.71396, 14.8426, 9.96319}, {10.5211, 13.8054,
							  9.56228}, {9.88621, 14.5561, 10.0998}, {14.7237, 10.0158,
							  10.735}, {16.3607, 10.9958, 8.52098}, {11.2324, 9.84861,
							  15.6088}, {11.5248, 16.851, 9.63979}, {14.6177, 8.41208,
							  11.1644}, {15.0116, 8.56804, 9.19389}, {14.2306, 10.2454,
							  10.6756}, {14.4034, 11.2457, 11.2276}, {14.8609, 10.6976,
							  9.07999}, {9.48997, 10.2532, 15.0217}, {9.28543, 10.1958,
							  16.0236}, {15.8394, 9.63504, 9.31923}, {15.5867, 10.9134,
							  10.1843}, {8.7676, 9.98797, 16.0264}, {11.0074, 9.77713,
							  14.2867}, {10.1784, 9.43394, 15.4104}, {10.1986, 9.86429,
							  15.4396}, {10.5048, 11.2851, 16.7863}};
		sample5D = {{11.5563, 9.83606, 14.8967, 10.3856, 9.96366}, {15.2719, 10.8688,
							  9.41588, 9.44675, 10.7089}, {14.4699, 10.9204, 9.16719, 11.9529,
							  9.15097}, {9.52201, 16.5728, 10.0647, 9.88185, 9.91134}, {10.2914,
							  9.55713, 10.8695, 15.5108, 10.603}, {9.43273, 10.0302, 9.94627,
							  16.4771, 9.83658}, {9.59671, 9.74179, 15.6477, 9.49843,
							  10.0562}, {9.35986, 10.0472, 10.8383, 11.0382, 15.3787}, {9.11683,
							  15.4983, 8.70692, 9.39204, 9.64961}, {15.376, 8.69288, 10.0639,
							  10.5203, 9.66686}, {8.69906, 10.1134, 10.1776, 9.79685,
							  15.7328}, {15.0012, 10.2837, 9.31664, 10.019, 9.25105}, {10.3272,
							  11.0823, 10.031, 14.0333, 9.54864}, {9.68347, 8.88054, 14.43,
							  10.1576, 9.59933}, {9.10549, 15.7686, 10.334, 9.40164,
							  9.75567}, {15.6399, 9.3966, 10.0252, 10.4499, 8.6907}, {10.0993,
							  8.94287, 15.054, 9.17505, 10.8389}, {9.95935, 9.11746, 14.5517,
							  9.32076, 10.8695}, {10.7853, 10.2558, 10.0524, 9.44606,
							  13.0598}, {11.5447, 9.18347, 9.67141, 14.5199, 11.5933}, {9.35861,
							  14.4357, 10.1673, 8.84649, 10.9458}, {10.4877, 10.1733, 9.31246,
							  10.4425, 13.5476}, {14.7876, 9.83269, 8.93301, 11.2869,
							  8.9942}, {10.1811, 9.9798, 15.5631, 10.3264, 9.49888}, {9.92388,
							  15.3378, 10.9951, 9.84377, 10.3839}, {9.36628, 9.32132, 9.66182,
							  9.88763, 15.0021}, {10.0252, 9.03555, 9.93775, 9.73571,
							  14.3853}, {10.2232, 15.067, 10.2589, 9.70464, 9.12198}, {13.9927,
							  9.46727, 10.8553, 11.2251, 10.7067}, {10.3105, 8.10472, 10.6201,
							  10.8167, 15.2334}, {8.82963, 11.2249, 14.1623, 9.41469,
							  11.2769}, {9.61437, 10.2836, 15.6624, 10.6445, 8.53864}, {14.3989,
							  10.0221, 9.51196, 10.0969, 10.1652}, {9.01829, 15.8082, 10.5373,
							  9.64813, 10.1475}, {9.86333, 9.57339, 10.3787, 10.2468,
							  14.0257}, {15.2943, 9.45562, 9.2069, 9.35481, 11.5877}, {9.97619,
							  9.92912, 15.7903, 9.96735, 8.90721}, {9.35719, 9.27059, 9.95188,
							  14.0787, 9.43696}, {15.911, 10.4027, 8.81304, 9.59708,
							  9.88947}, {10.1907, 10.4745, 9.54208, 15.2653, 9.22456}, {9.92068,
							  9.68694, 8.66371, 9.57895, 14.246}, {13.3523, 10.7441, 10.4395,
							  9.64753, 11.1574}, {9.50838, 10.9508, 14.4495, 9.68254,
							  10.5944}, {9.39291, 14.9658, 11.0283, 9.31953, 9.23861}, {13.7248,
							  10.3901, 9.0096, 10.326, 9.97822}, {9.44993, 10.2969, 16.1893,
							  8.52771, 9.01023}, {11.5984, 10.3522, 10.8045, 15.2991,
							  10.5502}, {14.8693, 9.98128, 10.0157, 10.1796, 10.5991}, {10.4498,
							  9.06993, 15.526, 10.7592, 10.4632}, {10.5039, 10.3114, 15.9026,
							  11.203, 9.38834}, {14.0749, 10.9459, 10.1029, 9.5957,
							  10.3212}, {9.97258, 9.86139, 14.8696, 9.70848, 10.9032}, {9.57012,
							  9.53601, 9.36538, 15.2571, 9.64725}, {14.513, 10.5276, 11.3373,
							  9.83694, 9.81347}, {10.3334, 14.1681, 10.7645, 8.43869,
							  10.0797}, {16.1523, 8.91091, 9.76995, 9.79878, 10.0069}, {9.9158,
							  14.1335, 10.3246, 9.05024, 10.3744}, {8.55412, 11.689, 9.51611,
							  13.9328, 9.7812}, {10.6566, 14.229, 10.7233, 9.68929,
							  9.39909}, {9.83202, 10.1846, 9.55615, 8.89973, 14.1531}, {9.46723,
							  8.9332, 9.31155, 16.59, 8.12862}, {10.0887, 10.0896, 9.78169,
							  15.7136, 9.51208}, {10.5475, 11.6664, 9.43914, 14.8801,
							  8.95649}, {10.5136, 9.95144, 9.41552, 8.88819, 14.2216}, {15.0036,
							  9.78758, 10.2662, 9.05962, 10.5888}, {13.9853, 9.04278, 10.1364,
							  10.1127, 9.86405}, {11.5863, 9.5667, 11.5094, 9.86507,
							  14.181}, {13.6046, 9.63226, 10.5552, 9.46711, 9.83236}, {9.08337,
							  14.8693, 10.0871, 9.69784, 11.1478}, {10.6002, 10.8233, 10.2447,
							  14.2651, 11.0955}, {9.49681, 10.5525, 9.90385, 14.9523,
							  10.1622}, {9.46394, 14.08, 8.8391, 9.36928, 9.64692}, {10.3736,
							  15.8005, 9.15973, 10.26, 9.45368}, {10.6063, 10.4271, 10.3197,
							  14.2003, 9.92811}, {9.35858, 9.93326, 14.2861, 10.264,
							  10.1711}, {14.3484, 8.77801, 10.7236, 10.0347, 8.55776}, {10.8485,
							  9.84741, 9.81146, 9.94553, 15.701}, {9.87637, 9.68015, 8.87782,
							  14.7009, 8.28184}, {14.58, 8.6577, 10.0699, 10.5051,
							  10.3226}, {16.1503, 9.23609, 10.2235, 10.1977, 9.96131}, {10.2343,
							  9.44976, 10.1957, 10.3911, 15.5068}, {9.67643, 8.78943, 8.91285,
							  10.1703, 16.4423}, {11.3329, 10.2665, 10.0966, 14.337,
							  9.01681}, {9.40464, 11.2968, 8.27202, 15.5675, 9.98361}, {9.4851,
							  15.1179, 10.0033, 9.02441, 10.6304}, {9.67628, 10.6073, 9.93071,
							  14.0929, 9.38381}, {14.3582, 9.96967, 10.7878, 9.40742,
							  9.36181}, {9.75128, 15.477, 9.73037, 9.464, 9.21243}, {10.2294,
							  10.0025, 15.2633, 9.78696, 9.22094}, {8.73893, 9.94054, 10.872,
							  15.0546, 9.35843}, {9.51664, 8.71521, 14.2734, 9.93935,
							  8.43645}, {10.7705, 15.2758, 10.0383, 10.4295, 10.8297}, {10.8384,
							  9.01127, 15.9815, 10.0104, 10.393}, {10.581, 9.74842, 8.66225,
							  9.13472, 14.4575}, {9.34053, 10.5316, 15.0952, 9.36147,
							  8.88349}, {10.0548, 14.8085, 10.7424, 11.0861, 10.5511}, {10.6452,
							  9.3943, 15.9175, 8.75673, 10.4073}, {14.7452, 9.00732, 9.62563,
							  9.22377, 10.2523}, {9.34273, 10.9241, 15.0142, 9.14938,
							  10.7296}, {9.69809, 14.0783, 8.46111, 9.86284, 9.70487}};

						},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)
];

(* helper functions *)
extractClustersDynamicModule[app_]:=Cases[Part[app,1,2],_DynamicModule,{6}];

extractClustersApps[clustersApp_]:= Cases[clustersApp,_DynamicModule,10];


(* ::Section:: *)
(*End Test Package*)
