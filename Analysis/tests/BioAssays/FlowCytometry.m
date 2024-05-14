(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeFlowCytometry*)


(* Define Tests *)
DefineTests[AnalyzeFlowCytometry,
	{
		(*** Basic Usage ***)
		Example[{Basic,"Partition data points in a flow cytometry data object using clustering analysis:"},
			AnalyzeFlowCytometry[Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"]],
			ObjectP[Object[Analysis, FlowCytometry]]
		],
		Example[{Basic,"Partition data in each data object from a flow cytometry protocol:"},
			AnalyzeFlowCytometry[Object[Protocol,FlowCytometry,"AnalyzeFlowCytometry test protocol"]],
			{ObjectP[Object[Analysis, FlowCytometry]]..}
		],
		Example[{Additional,"Interactive Preview App","Set Method->Manual and click on the 1D and 2D projection tabs to perform interactive clustering with thresholds and polygonal gates:"},
			AnalyzeFlowCytometryPreview[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 1"],
				Method->Manual
			],
			_Image,
			Stubs:>{
				AnalyzeFlowCytometryPreview[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					Method->Manual
				]=Module[{localSymbol5},
					Rasterize[AnalyzeFlowCytometryPreview[Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],Method->Manual,PreviewSymbol->localSymbol5],ImageResolution->100]
				]
			}
		],
		Example[{Additional,"Interactive Preview App","Set the clustering method, algorithm, and other options from the option selector. The interactive app will show automatically identified clusters. By default, AnalyzeFlowCytometry will cluster using peak areas from all detectors for which data is available:"},
			AnalyzeFlowCytometryPreview[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 1"],
				Method->Automatic,
				ClusteringAlgorithm->KMeans,
				NumberOfClusters->2,
				ClusterLabels->{"Cell Population A","Cell Population B"}
			],
			_Image,
			Stubs:>{
				AnalyzeFlowCytometryPreview[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					Method->Automatic,
					ClusteringAlgorithm->KMeans,
					NumberOfClusters->2,
					ClusterLabels->{"Cell Population A","Cell Population B"}
				]=Rasterize[Module[{localSymbol4},
					AnalyzeFlowCytometryPreview[
						Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
						Method->Automatic,
						ClusteringAlgorithm->KMeans,
						NumberOfClusters->2,
						ClusterLabels->{"Cell Population A","Cell Population B"},
						PreviewSymbol->localSymbol4
					]
				],ImageResolution->100]
			}
		],
		Example[{Additional,"Interactive Preview App",
			StringJoin[
				"Use the interactive AnalyzeFlowCytometry preview app to set options for the analysis. To access all interactive features, please load AnalyzeFlowCytometry in the command builder. ",
				"By default, the projection selector is shown first - Press the [Update Grid] button to generate a multi-dimensional display of flow cytometry data. ",
				"The default dimensions in the projection selector are automatically chosen to maximize cluster variance:"
			]},
			AnalyzeFlowCytometryPreview[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 1"]
			],
			_Image,
			Stubs:>{
				AnalyzeFlowCytometryPreview[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"]
				]=Rasterize[Module[{localSymbol2},
					AnalyzeFlowCytometryPreview[Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],PreviewSymbol->localSymbol2]
				],ImageResolution->100]
			}
		],

		(*** Options ***)
		Example[{Options,CompensationMatrix,"Use a compensation matrix, calculated using AnalyzeCompensationMatrix, to compensate for signal spillover between detection channels in the input flow cytometry data:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
				CompensationMatrix->Object[Analysis,CompensationMatrix,"AnalyzeFlowCytometry Unit Test Compensation Matrix"]
			],
			ObjectP[Object[Analysis, FlowCytometry]]
		],
		Example[{Options,CompensationMatrix,"Specify that a compensation matrix should not be used by setting the CompensationMatrix option to None:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
				CompensationMatrix->None
			],
			ObjectP[Object[Analysis, FlowCytometry]]
		],
		Example[{Options,Normalize,"By default, flow cytometry data is normalized by rescaling data so it fits within the interval [0,1] for clustering:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
				Normalize->True
			],
			obj:ObjectP[Object[Analysis, FlowCytometry]]/;(Length[obj[ClusterLabels]]==1)
		],
		Example[{Options,Normalize,"Set normalize to False to cluster on original data points:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
				Normalize->False
			],
			obj:ObjectP[Object[Analysis, FlowCytometry]]/;(Length[obj[ClusterLabels]]==1)
		],
		Example[{Options,ClusteredDimensions,"Specify which dimensions of data (as a {detector,peak measurement} pair) should be considered while clustering. If not specified, all dimensions will be used in the analysis:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 2"],
				ClusteredDimensions->{
					{"488 FSC",Area},
					{"488 750LP",Height},
					{"561 670/30",Width}
				}
			],
			obj:ObjectP[Object[Analysis, FlowCytometry]]/;MatchQ[
				Lookup[obj[ResolvedOptions],ClusteredDimensions],
				{{"488 FSC",Area}, {"488 750LP",Height}, {"561 670/30",Width}}
			]
		],
		Test["ClusteredDimensions resolves to all area measurements when left as Automatic:",
			Lookup[
				AnalyzeFlowCytometry[
					{
						Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 2"],
						Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 3"]
					},
					ClusteredDimensions->{
						{
							{"488 FSC",Area},
							{"488 750LP",Height},
							{"561 670/30",Width}
						},
						Automatic
					},
					Output->Options
				],
				ClusteredDimensions
			],
			{
				{{"488 FSC",Area}, {"488 750LP",Height}, {"561 670/30",Width}},
				{
					{"405 FSC", Area}, {"488 FSC", Area}, {"488 SSC", Area}, {"488 525/35", Area},
					{"488 593/52", Area}, {"488 692/80", Area}, {"488 750LP", Area},
					{"561 670/30", Area}, {"561 720/60", Area}, {"561 750LP", Area}
				}
			}
		],
		Example[{Options,DimensionLabels,"By default, dimensions are labeled by their detector, and then either an \"A\", \"W\", or \"H\" denoting a peak area, width, or height measured by that detector:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"]
			][DimensionLabels],
			strList:{_String..}/;MatchQ[StringTake[#,;;-3]&/@strList,{FlowCytometryDetectorP ..}]
		],
		Example[{Options,DimensionLabels,"Override default dimension labels by supplying a list of new names. This must match the number of dimensions in the input data:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
				DimensionLabels->(ToString[StringForm["Dim `1`",#]]&/@Range[90])
			],
			ObjectP[Object[Analysis, FlowCytometry]]
		],
		Example[{Options,ClusterLabels,"Provide a label for each cluster of data points identified in the input data:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 2"],
				NumberOfClusters->3,
				ClusterLabels->{
					"Live",
					"Target",
					"Dead Cells"
				}
			],
			obj:ObjectP[Object[Analysis, FlowCytometry]]/;MatchQ[obj[ClusterLabels],{"Live","Target","Dead Cells"}]
		],
		Example[{Options,ClusterLabels,"If no ClusterLabels are provided, then clusters will be labeled as \"Group x\" where x are sequential integers:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 2"],
				NumberOfClusters->3
			][ClusterLabels],
			{"Group 1","Group 2","Group 3"}
		],
		Example[{Options,ClusterAssignments,"Assign a cell identity model to each cluster of cells identified in the analysis:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 2"],
				NumberOfClusters->3,
				ClusterLabels->{
					"K562",
					"Unknown",
					"YAC-1"
				},
				ClusterAssignments->{
					Model[Cell,Mammalian,"id:4pO6dM5dPrrX"],
					Null,
					Model[Cell,Mammalian,"id:mnk9jOReopeZ"]
				}
			],
			obj:ObjectP[Object[Analysis, FlowCytometry]]/;MatchQ[obj[ClusterAssignments],{ObjectP[Model[Cell]],Null,ObjectP[Model[Cell]]}]
		],
		Example[{Options,ClusterAssignments,"If no ClusterAssignments are specified, then assignments will default to Null:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 2"],
				NumberOfClusters->3
			][ClusterAssignments],
			{Null,Null,Null}
		],
		Example[{Options,ClusterAnalysisTree,"This option is used to track level in subclustering analysis, and is automatically set by the command builder preview (should not be set manually). Input is a graph where each node is a cluster label, and each node weight is an object reference for a clustering analysis packet:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 3"],
				ClusterAnalysisTree->smallTestTree
			],
			obj:ObjectP[Object[Analysis, FlowCytometry]]/;MatchQ[obj[ClusterLabels],{"CHO1","CHO2","Dead"}],
			Variables:>{smallTestTree},
			SetUp:>Module[{clustersAll,clustersLive},
				clustersAll=Download[
					AnalyzeFlowCytometry[Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
						ClusterLabels->{"Live","Dead"},NumberOfClusters->2
					],
					ClustersAnalyses[[-1]][Object]
				];
				clustersLive=AnalyzeClusters[
					Download[clustersAll,ClusteredData]["Live"],
					NumberOfClusters->2,ClusterLabels->{"CHO1","CHO2"},
					Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
				];
				smallTestTree=Graph[
					{
						"All"->"Live"
					},
					VertexWeight->{
						"All"->clustersAll,
						"Live"->clustersLive
					},
					VertexLabels->"Name"
				];
			]
		],
		Example[{Options,ActiveSubcluster,"This option is used to track current subcluster in nested analysis, and is automatically set by command builder preview (should not be set manually). This option takes a subcluster/node name in the clustering analysis graph:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 3"],
				ClusterAnalysisTree->bigTestTree,
				ActiveSubcluster->"Live"
			],
			obj:ObjectP[Object[Analysis,FlowCytometry]]/;MatchQ[obj[ClusterLabels],{"Target","Unknown","CHO2","Group 1"}],
			Variables:>{bigTestTree},
			SetUp:>Module[{clustersAll,clustersLive,clustersDead,clustersCHO1},
				(* Initialize clustering packets for testing subcluster analysis *)
				clustersAll=Download[
					AnalyzeFlowCytometry[Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
						ClusterLabels->{"Live","Dead"},NumberOfClusters->2
					],
					ClustersAnalyses[[-1]][Object]
				];
				clustersLive=AnalyzeClusters[
					Download[clustersAll,ClusteredData]["Live"],
					NumberOfClusters->2,ClusterLabels->{"CHO1","CHO2"},
					Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
				];
				clustersDead=AnalyzeClusters[
					Download[clustersAll,ClusteredData]["Dead"],
					Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
				];
				clustersCHO1=AnalyzeClusters[
					Download[clustersLive,ClusteredData]["CHO1"],
					NumberOfClusters->2,ClusterLabels->{"Target","Unknown"},
					Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
				];
				bigTestTree=Graph[
					{
						"All"->"Live",
						"All"->"Dead",
						"Live"->"CHO1"
					},
					VertexWeight->{
						"All"->clustersAll,
						"Live"->clustersLive,
						"CHO1"->clustersCHO1,
						"Dead"->clustersDead
					},
					VertexLabels->"Name"
				];
			]
		],
		Example[{Options,Name,"Supply a name for the resulting analysis object:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
				Name->"Named FlowCytometry Object for Unit Testing"
			][Name],
			"Named FlowCytometry Object for Unit Testing"
		],
		Example[{Options,Template,"Use an existing analysis object as a template for a new analysis. The current analysis will inherit options from the template analysis:"},
			AnalyzeFlowCytometry[
				Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
				Template->AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 2"],
					NumberOfClusters->3,
					ClusterLabels->{"Apple", "Bottom", "Jeans"}
				]
			][ClusterLabels],
			{"Apple","Bottom","Jeans"}
		],
		Example[{Options,Template,"If the template analysis object used subclustering analysis, subclustering options will be inherited and the subclustering analysis tree will be regenerated:"},
			Download[
				AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					Template->Object[Analysis, FlowCytometry, "Template FlowCytometry Analysis for Unit Testing"]
				],
				{ClusterLabels,ClusterAnalysisTree}
			],
			{{"CHO1","CHO2","Dead"},_Graph}
		],

		(*** Messages ***)
		Example[{Messages,"DuplicateClusterLabels","All cluster labels must be unique:"},
			AnalyzeFlowCytometry[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
				NumberOfClusters->3,
				ClusterLabels->{"Population 1","Population 1","Population 2"}
			],
			$Failed,
			Messages:>{Error::DuplicateClusterLabels,Error::InvalidOption}
		],
		Example[{Messages,"InvalidActiveSubcluster","When specified, the ActiveSubcluster must correspond to a vertex in the ClusterAnalysisTree (i.e. any cluster label in subcluster analyses). Use the interactive preview app to generate values for this option:"},
			AnalyzeFlowCytometry[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
				ActiveSubcluster->"Taco"
			],
			$Failed,
			Messages:>{Error::InvalidActiveSubcluster,Error::InvalidOption}
		],
		Example[{Messages,"InvalidClusterTree","When specified, ClusterAnalysisTree must be a tree graph for which the vertex weights are Object[Analysis, Clusters] packets. Analysis will fail if these conditions are not met. Use the interactive preview app to generate values for this option:"},
			AnalyzeFlowCytometry[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
				ClusterAnalysisTree->CycleGraph[3]
			],
			$Failed,
			Messages:>{Error::InvalidClusterTree,Error::InvalidOption}
		],
		Example[{Messages,"NoDataInChannel","Clustered dimensions will be ignored if specification corresponds to a detector for which there is no data in the input object:"},
			AnalyzeFlowCytometry[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 4"],
				ClusteredDimensions->{
					{"488 FSC",Area},
					{"405 670/30",Height},
					{"355 387/11",Width}
				}
			],
			obj:ObjectP[Object[Analysis,FlowCytometry]]/;MatchQ[Lookup[obj[ResolvedOptions],ClusteredDimensions],{{"488 FSC",Area}}],
			Messages:>{Warning::NoDataInChannel}
		],
		Example[{Messages,"CompensationMatrixNotFound","Warning is shown if parent protocol of input data object has compensation samples but no compensation matrix analyses:"},
			AnalyzeFlowCytometry[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 5"]
			],
			ObjectP[Object[Analysis,FlowCytometry]],
			Messages:>{Warning::CompensationMatrixNotFound}
		],

		(*** Tests ***)
		Test["CompensationMatrix resolves automatically if an existing compensation matrix analysis is linked to parent protocol:",
			Lookup[
				AnalyzeFlowCytometry[
					{Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 1"],Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 6"]},
					Upload->False
				],
				CompensationMatrix
			],
			{Null,ObjectP[Object[Analysis,CompensationMatrix]]}
		],
		Test["CompensationMatrix only affects mean cluster intensity in selected dimensions (corresponding to the detectors field of the compensatinomatrix object):",
			With[
				{
					meanWithCompensation=(Mean@Lookup[
						AnalyzeFlowCytometry[
							Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 6"],
							NumberOfClusters->1,
							CompensationMatrix->Object[Analysis,CompensationMatrix,"AnalyzeFlowCytometry Unit Test Compensation Matrix"],
							Upload->False
						],
						ClusteredData
					]["Group 1"]),

					meanWithoutCompensation=(
					Mean@Lookup[
						AnalyzeFlowCytometry[
							Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 6"],
							NumberOfClusters->1,
							CompensationMatrix->None,
							Upload->False
						],
						ClusteredData
					]["Group 1"])
				},
				Partition[
					MapThread[
						#1==#2&,
						{meanWithoutCompensation,meanWithCompensation}
					],
					10
				]
			],
			{
				(* Compensation is done on detectors corresponding to dims 2, 7, and 9 *)
				{True, False, True, True, True, True, False, True, False, True},
				{True, False, True, True, True, True, False, True, False, True},
				{True, False, True, True, True, True, False, True, False, True}
			}
		],
		Test["The mapping between flow cytometry detector names (strings) matches the fields in Object[Data,FlowCytometry]. If this test fails, please check the FlowCytometryDataFieldsP and FlowCytometryDetectorP patterns and update this test:",
			flowCytometryFieldToDetector,
			{
				ForwardScatter488Excitation -> "488 FSC",
				ForwardScatter405Excitation -> "405 FSC",
				SideScatter488Excitation -> "488 SSC",
				Fluorescence488Excitation525Emission -> "488 525/35",
				Fluorescence488Excitation593Emission -> "488 593/52",
				Fluorescence488Excitation750Emission -> "488 750LP",
				Fluorescence488Excitation692Emission -> "488 692/80",
				Fluorescence561Excitation750Emission -> "561 750LP",
				Fluorescence561Excitation670Emission -> "561 670/30",
				Fluorescence561Excitation720Emission -> "561 720/60",
				Fluorescence561Excitation589Emission -> "561 589/15",
				Fluorescence561Excitation577Emission -> "561 577/15",
				Fluorescence561Excitation640Emission -> "561 640/20",
				Fluorescence561Excitation615Emission -> "561 615/24",
				Fluorescence405Excitation670Emission -> "405 670/30",
				Fluorescence405Excitation720Emission -> "405 720/60",
				Fluorescence405Excitation750Emission -> "405 750LP",
				Fluorescence405Excitation460Emission -> "405 460/22",
				Fluorescence405Excitation420Emission -> "405 420/10",
				Fluorescence405Excitation615Emission -> "405 615/24",
				Fluorescence405Excitation525Emission -> "405 525/50",
				Fluorescence355Excitation525Emission -> "355 525/50",
				Fluorescence355Excitation670Emission -> "355 670/30",
				Fluorescence355Excitation700Emission -> "355 700LP",
				Fluorescence355Excitation447Emission -> "355 447/60",
				Fluorescence355Excitation387Emission -> "355 387/11",
				Fluorescence640Excitation720Emission -> "640 720/60",
				Fluorescence640Excitation775Emission -> "640 775/50",
				Fluorescence640Excitation800Emission -> "640 800LP",
				Fluorescence640Excitation670Emission -> "640 670/30"
			}
		],
		Test["Flow cytometry app graphics are valid when Method->Automatic:",
			Module[{autoApp,clustersApp,selectorApp,preview1D,preview2D,graphic1D,valid1D,graphic2D,valid2D},
				autoApp=AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					Output->Preview
				];
				(* Load dynamic module variables from the front-end *)
				First[autoApp];
				
				(* $CCD is true a mouse guide is added, which we need to peel off with part *)
				autoApp = removeMouseGuide[autoApp];
				
				(* Extract the underlying clusters app  *)
				clustersApp=FirstOrDefault[Cases[autoApp,_DynamicModule,10]];
				(* Load dynamic module variables from the front-end *)
				First[clustersApp];
				(* Extract only the selector sub-app *)
				{selectorApp,preview1D,preview2D}=Cases[clustersApp,_DynamicModule,10];

				(* Check the 1D graphic *)
				Part[preview1D,1];
				graphic1D=setCytometryDynamics[Part[Cases[preview1D,_LocatorPane,11],1,2,1]];
				valid1D=ValidGraphicsQ[graphic1D];

				(* Check the 2D graphic *)
				Part[preview2D,1];
				graphic2D=setCytometryDynamics[Part[Cases[preview2D,_Show,15],1]];
				valid2D=ValidGraphicsQ[graphic2D];

				And[valid1D,valid2D]
			],
			True
		],
		Test["Flow cytometry app graphics are valid when Method->Manual:",
			Module[{autoApp,clustersApp,selectorApp,preview1D,preview2D,graphic1D,valid1D,graphic2D,valid2D},
				autoApp=AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					Method->Manual,
					Output->Preview
				];
				(* Load dynamic module variables from the front-end *)
				First[autoApp];
				
				(* $CCD is true a mouse guide is added, which we need to peel off with part *)
				autoApp = removeMouseGuide[autoApp];
				
				(* Extract the underlying clusters app  *)
				clustersApp=FirstOrDefault[Cases[autoApp,_DynamicModule,10]];
				(* Load dynamic module variables from the front-end *)
				First[clustersApp];
				(* Extract only the selector sub-app *)
				{selectorApp,preview1D,preview2D}=Cases[clustersApp,_DynamicModule,10];

				(* Check the 1D graphic *)
				Part[preview1D,1];
				(* remove the dynamics and set the variables to their current values *)
				graphic1D=setCytometryDynamics[Part[Cases[preview1D,_LocatorPane,11],1,2,1]];
				valid1D=ValidGraphicsQ[graphic1D];

				(* Check the 2D graphic *)
				Part[preview2D,1];
				(* remove the dynamics and set the variables to their current values *)
				graphic2D=setCytometryDynamics[Part[Cases[preview2D,_Show,15],1]];
				valid2D=ValidGraphicsQ[graphic2D];

				And[valid1D,valid2D]
			],
			True
		],
		Test["Flow cytometry app automatically resolves best clustering dimensions correctly when Method->Automatic:",
			Module[{autoApp,clustersApp,selectorApp},
				autoApp=AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					Output->Preview
				];
				(* Load dynamic module variables from the front-end *)
				First[autoApp];
				(* $CCD is true a mouse guide is added, which we need to peel off with part *)
				autoApp = removeMouseGuide[autoApp];
				(* Extract the underlying clusters app  *)
				clustersApp=FirstOrDefault[Cases[autoApp,_DynamicModule,10]];
				(* Load dynamic module variables from the front-end *)
				First[clustersApp];
				(* Extract only the selector sub-app *)
				selectorApp=First@Cases[clustersApp,_DynamicModule,10];
				(* Extract the bestdims2 module variable from the selector *)
				First@Cases[selectorApp,HoldPattern[Set[Analysis`Private`bestDims2, _]],3]
			],
			{1,2,4,7,8,9,10}
		],
		Test["Flow cytometry app automatically resolves best clustering dimensions correctly when Method->Manual:",
			Module[{manualApp,clustersApp,selectorApp},
				manualApp=AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					Method->Manual,
					Output->Preview
				];
				(* Load dynamic module variables from the front-end *)
				First[manualApp];
				(* $CCD is true a mouse guide is added, which we need to peel off with part *)
				manualApp = removeMouseGuide[manualApp];
				(* Extract the underlying clusters app  *)
				clustersApp=FirstOrDefault[Cases[manualApp,_DynamicModule,10]];
				(* Load dynamic module variables from the front-end *)
				First[clustersApp];
				(* Extract only the selector sub-app *)
				selectorApp=First@Cases[clustersApp,_DynamicModule,10];
				(* Extract the bestdims2 module variable from the selector *)
				First@Cases[selectorApp,HoldPattern[Set[Analysis`Private`bestDims2, _]],3]
			],
			{1,2,4,7,8,9,10}
		],
		Test["The subclusters button updates the clustering graph correctly:",
			Module[{pkt,preview,finalGraph},
				{pkt,preview}=AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 1"],
					NumberOfClusters->2,
					ClusteringAlgorithm->KMeans,
					ClusterLabels->{"Live","Dead"},
					Upload->False,
					Output->{Result,Preview}
				];

				(* Subcluster on Live *)
				Analysis`Private`updateSubclusters[PreviewSymbol[AnalyzeFlowCytometry],
					"Live",
					pkt,
					{}
				];

				(* Switch active cluster back to All *)
				LogPreviewChanges[PreviewSymbol[AnalyzeFlowCytometry],ActiveSubcluster->"All"];

				(* Subcluster on Dead *)
				Analysis`Private`updateSubclusters[PreviewSymbol[AnalyzeFlowCytometry],
					"Dead",
					pkt,
					{}
				];

				finalGraph=PreviewValue[PreviewSymbol[AnalyzeFlowCytometry],ClusterAnalysisTree];

				{
					Sort@VertexList[finalGraph],
					Sort@EdgeList[finalGraph],
					PreviewValue[PreviewSymbol[AnalyzeFlowCytometry],ActiveSubcluster]
				}
			],
			{
				{"All", "Dead", "Live"},
				{"All" \[DirectedEdge] "Dead", "All" \[DirectedEdge] "Live"},
				"Dead"
			}
		],
		Test["The remove subclusters button updates the clustering graph correctly:",
			Module[{pkt,preview,finalGraph},
				{pkt,preview}=AnalyzeFlowCytometry[
					Object[Data, FlowCytometry, "AnalyzeFlowCytometry test data 3"],
					ClusterAnalysisTree->bigTestTree,
					ActiveSubcluster->"CHO1",
					Upload->False,
					Output->{Result,Preview}
				];

				(* Subcluster on Live *)
				Analysis`Private`removeSubcluster[PreviewSymbol[AnalyzeFlowCytometry]];

				finalGraph=PreviewValue[PreviewSymbol[AnalyzeFlowCytometry],ClusterAnalysisTree];

				{
					Sort@VertexList[finalGraph],
					Sort@EdgeList[finalGraph],
					PreviewValue[PreviewSymbol[AnalyzeFlowCytometry],ActiveSubcluster]
				}
			],
			{
				{"All", "Dead", "Live"},
				{"All" \[DirectedEdge] "Dead", "All" \[DirectedEdge] "Live"},
				"Live"
			},
			SetUp:>Module[{clustersAll,clustersLive,clustersDead,clustersCHO1},
				(* Initialize clustering packets for testing subcluster analysis *)
				clustersAll=Download[
					AnalyzeFlowCytometry[Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
						ClusterLabels->{"Live","Dead"},NumberOfClusters->2
					],
					ClustersAnalyses[[-1]][Object]
				];
				clustersLive=AnalyzeClusters[
					Download[clustersAll,ClusteredData]["Live"],
					NumberOfClusters->2,ClusterLabels->{"CHO1","CHO2"},
					Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
				];
				clustersDead=AnalyzeClusters[
					Download[clustersAll,ClusteredData]["Dead"],
					Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
				];
				clustersCHO1=AnalyzeClusters[
					Download[clustersLive,ClusteredData]["CHO1"],
					NumberOfClusters->2,ClusterLabels->{"Target","Unknown"},
					Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
				];
				bigTestTree=Graph[
					{
						"All"->"Live",
						"All"->"Dead",
						"Live"->"CHO1"
					},
					VertexWeight->{
						"All"->clustersAll,
						"Live"->clustersLive,
						"CHO1"->clustersCHO1,
						"Dead"->clustersDead
					},
					VertexLabels->"Name"
				];
			]
		]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list *)
		$CreatedObjects={};
		SeedRandom[345];

		(* Erase any objects we missed in the last unit test run *)
		Module[
			{
				allObjects,existingObjects,testObj1,testObj2,testObj3,testObj4,testObj5,testObj6,
				testProtocol,testProtocol2,testProtocol3,clustersAll,clustersLive,testTree,
				compMatrixID,compMatrixPacket
			},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 1"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 2"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 4"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 5"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 6"],
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometry test protocol"],
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometry test protocol with missing compensation"],
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometry test protocol with compensation"],
				Object[Analysis,FlowCytometry,"Template FlowCytometry Analysis for Unit Testing"],
				Object[Analysis,FlowCytometry,"Named FlowCytometry Object for Unit Testing"],
				Object[Analysis,CompensationMatrix,"AnalyzeFlowCytometry Unit Test Compensation Matrix"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test objects *)
			testObj1=Analysis`Private`makeTestFlowCytometryDataPacket[200,30,2,"AnalyzeFlowCytometry test data 1"];
			testObj2=Analysis`Private`makeTestFlowCytometryDataPacket[400,30,3,"AnalyzeFlowCytometry test data 2"];
			testObj3=Analysis`Private`makeTestFlowCytometryDataPacket[1000,30,5,"AnalyzeFlowCytometry test data 3"];
			testObj4=Analysis`Private`makeTestFlowCytometryDataPacket[200,3,2,"AnalyzeFlowCytometry test data 4"];
			testObj5=Analysis`Private`makeTestFlowCytometryDataPacket[400,30,3,"AnalyzeFlowCytometry test data 5"];
			testObj6=Analysis`Private`makeTestFlowCytometryDataPacket[400,30,3,"AnalyzeFlowCytometry test data 6"];

			(* Load up a test protocol *)
			testProtocol=<|
				Type->Object[Protocol,FlowCytometry],
				Name->"AnalyzeFlowCytometry test protocol",
				Replace[Detectors]->{"488 FSC","405 FSC","488 SSC","488 525/35","488 593/52","488 750LP","488 692/80","561 750LP","561 670/30","561 720/60"},
				DateCreated->Now,
				DeveloperObject->True,
				Replace[Data]->(Link[#,Protocol]&/@{testObj1,testObj2,testObj3})
			|>;

			(* Load up a test protocol *)
			testProtocol2=<|
				Type->Object[Protocol,FlowCytometry],
				Name->"AnalyzeFlowCytometry test protocol with missing compensation",
				DateCreated->Now,
				DeveloperObject->True,
				CompensationSamplesIncluded->True,
				Replace[Data]->{Link[testObj5,Protocol]}
			|>;

			(* Create an ID for the compensation matrix test object *)
			compMatrixID=CreateID[Object[Analysis,CompensationMatrix]];

			(* Create a test compensation matrix packet *)
			compMatrixPacket=<|
				Object->compMatrixID,
				Name->"AnalyzeFlowCytometry Unit Test Compensation Matrix",
				Author->Link[$PersonID],
				DateCreated->Now,
				DeveloperObject->True,
				Replace[Detectors]->{"488 FSC", "488 750LP", "561 720/60"},
				CompensationMatrix->{
					{ 1.0, -0.15, -0.05},
					{-0.1,  1.00, -0.20},
					{-0.2, -0.10,  1.00}
				}
			|>;

			(* Load up a test protocol *)
			testProtocol3=<|
				Type->Object[Protocol,FlowCytometry],
				Name->"AnalyzeFlowCytometry test protocol with compensation",
				Replace[Detectors]->{"488 FSC","405 FSC","488 SSC","488 525/35","488 593/52","488 750LP","488 692/80","561 750LP","561 670/30","561 720/60"},
				DateCreated->Now,
				DeveloperObject->True,
				CompensationSamplesIncluded->True,
				Append[CompensationMatrixAnalyses]->{Link[compMatrixID,Reference]},
				Replace[Data]->{Link[testObj6,Protocol]}
			|>;

			(* Upload everything *)
			Upload[{testObj1,testObj2,testObj3,testObj4,testObj5,testObj6,testProtocol,testProtocol2,compMatrixPacket,testProtocol3}];

			(* Clustering analyses for testing nested subclustering *)
			clustersAll=Download[
				AnalyzeFlowCytometry[Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
					ClusterLabels->{"Live","Dead"},NumberOfClusters->2
				],
				ClustersAnalyses[[-1]][Object]
			];

			clustersLive=AnalyzeClusters[
				Download[clustersAll,ClusteredData]["Live"],
				NumberOfClusters->2,ClusterLabels->{"CHO1","CHO2"},
				Sequence@@FilterRules[Download[clustersAll,ResolvedOptions],Scale|DimensionLabels|Normalize]
			];

			(* Construct a simple one-stage subclustering analysis *)
			testTree=Graph[
				{"All"->"Live"},
				VertexWeight->{"All"->clustersAll,"Live"->clustersLive},
				VertexLabels->"Name"
			];

			(* Create a flow cytometry analysis to use as a template *)
			AnalyzeFlowCytometry[Object[Data,FlowCytometry,"AnalyzeFlowCytometry test data 3"],
				ClusterAnalysisTree->testTree,
				Name->"Template FlowCytometry Analysis for Unit Testing"
			];
		];
	),

	(* Erase test objects when testing is complete*)
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeFlowCytometryOptions*)


(* Define Tests *)
DefineTests[AnalyzeFlowCytometryOptions,
	{
		Example[{Basic, "Return the resolved options for a single flow cytometry data object:"},
			AnalyzeFlowCytometryOptions[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 1"]
			],
			_Grid
		],
		Example[{Basic, "Return the resolved options for multiple flow cytometry data objects:"},
			AnalyzeFlowCytometryOptions[
				{
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 2"],
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 3"]
				}
			],
			_Grid
		],
		Example[{Basic, "Return the resolved options for all data objects in a FlowCytometry protocol:"},
			AnalyzeFlowCytometryOptions[
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometryOptions test protocol"]
			],
			_Grid
		],
		Example[{Options, OutputFormat, "By default, AnalyzeFlowCytometryOptions returns a table:"},
			AnalyzeFlowCytometryOptions[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 1"],
				OutputFormat->Table
			],
			_Grid
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			AnalyzeFlowCytometryOptions[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 1"],
				OutputFormat->List
			],
			{
				Template->Null,
				Name->Null,
				CompensationMatrix->None,
				ActiveSubcluster->"All",
				ClusterAnalysisTree->_Graph,
				ClusteredDimensions->{{FlowCytometryDetectorP,Area|Height|Width}..},
				DimensionLabels->{_String..},
				ClusterAssignments->{Null..},
				ClusterLabels->{_String..},
				Normalize->True,
				Scale->Linear,
				Method->Automatic,
				ManualGates->Null,
				ClusteringAlgorithm->DBSCAN,
				NumberOfClusters->Automatic,
				Domain->{},
				ClusterDomainOutliers->False,
				DistanceFunction->EuclideanDistance,
				PerformanceGoal->Speed,
				CriterionFunction->Silhouette,
				DimensionUnits->{UnitsP[]..},
				CovarianceType->Null,
				MaxIterations->Null,
				NeighborhoodRadius->Automatic,
				NeighborsNumber->Automatic,
				ClusterDissimilarityFunction->Null,
				MaxEdgeLength->Null,
				DensityResamplingThreshold->Null,
				OutlierDensityQuantile->Null,
				TargetDensityQuantile->Null
			}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list *)
		$CreatedObjects={};
		SeedRandom[123];

		(* Erase any objects we missed in the last unit test run *)
		Module[{allObjects,existingObjects,testObj1,testObj2,testObj3,testObj4,testProtocol},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 1"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 2"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 3"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryOptions test data 4"],
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometryOptions test protocol"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test objects *)
			testObj1=Analysis`Private`makeTestFlowCytometryDataPacket[200,30,2,"AnalyzeFlowCytometryOptions test data 1"];
			testObj2=Analysis`Private`makeTestFlowCytometryDataPacket[400,30,3,"AnalyzeFlowCytometryOptions test data 2"];
			testObj3=Analysis`Private`makeTestFlowCytometryDataPacket[1000,30,5,"AnalyzeFlowCytometryOptions test data 3"];
			testObj4=Analysis`Private`makeTestFlowCytometryDataPacket[200,5,2,"AnalyzeFlowCytometryOptions test data 4"];

			(* Load up a test protocol *)
			testProtocol=<|
				Type->Object[Protocol,FlowCytometry],
				Name->"AnalyzeFlowCytometryOptions test protocol",
				DateCreated->Now,
				DeveloperObject->True,
				Replace[Data]->(Link[#,Protocol]&/@{testObj1,testObj2,testObj3})
			|>;

			(* Upload everything *)
			Upload[{testObj1,testObj2,testObj3,testObj4,testProtocol}];
		];
	),

	(* Erase test objects when testing is complete*)
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeFlowCytometryPreview*)


(* Define Tests *)
DefineTests[AnalyzeFlowCytometryPreview,
	{
		(* These tests are for documentation and to lead users towards the builder. See AnalyzeFlowCytometry for rigorous app tests *)
		Example[{Basic, "Preview the interactive app for a single flow cytometry data object. To use the app, please load AnalyzeFlowCytometry in the command builder:"},
			AnalyzeFlowCytometryPreview[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 1"]
			],
			_Image,
			Stubs:>{
				AnalyzeFlowCytometryPreview[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 1"]
			] = Rasterize[AnalyzeFlowCytometryPreview[
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 1",Upload->False]
			],ImageResolution->100]
			}
		],
		Example[{Basic, "Preview the interactive app for each object in a list of flow cytometry data objects:"},
			AnalyzeFlowCytometryPreview[
				{
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 2"],
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 3"]
				}
			],
			_Image,
			Stubs:>{
				AnalyzeFlowCytometryPreview[
				{
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 2"],
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 3"]
				}
			] = Rasterize[AnalyzeFlowCytometryPreview[
				{
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 2"],
					Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 3"]
				}, Upload->False
			], ImageResolution->100]
			}
		],
		Example[{Basic, "Preview the interactive app for each data object in a flow cytometry protocol:"},
			AnalyzeFlowCytometryPreview[
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometryPreview test protocol"]
			],
			_Image,
			Stubs:>{
				AnalyzeFlowCytometryPreview[
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometryPreview test protocol"]
			] = Rasterize[AnalyzeFlowCytometryPreview[
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometryPreview test protocol"], Upload->False
			],ImageResolution->100]
			}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list *)
		$CreatedObjects={};
		SeedRandom[123];

		(* Erase any objects we missed in the last unit test run *)
		Module[{allObjects,existingObjects,testObj1,testObj2,testObj3,testProtocol},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 1"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 2"],
				Object[Data,FlowCytometry,"AnalyzeFlowCytometryPreview test data 3"],
				Object[Protocol,FlowCytometry,"AnalyzeFlowCytometryPreview test protocol"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test objects *)
			testObj1=Analysis`Private`makeTestFlowCytometryDataPacket[200,30,2,"AnalyzeFlowCytometryPreview test data 1"];
			testObj2=Analysis`Private`makeTestFlowCytometryDataPacket[400,30,3,"AnalyzeFlowCytometryPreview test data 2"];
			testObj3=Analysis`Private`makeTestFlowCytometryDataPacket[1000,30,5,"AnalyzeFlowCytometryPreview test data 3"];

			(* Load up a test protocol *)
			testProtocol=<|
				Type->Object[Protocol,FlowCytometry],
				Name->"AnalyzeFlowCytometryPreview test protocol",
				DateCreated->Now,
				DeveloperObject->True,
				Replace[Data]->(Link[#,Protocol]&/@{testObj1,testObj2,testObj3})
			|>;

			(* Upload everything *)
			Upload[{testObj1,testObj2,testObj3,testProtocol}];
		];
	),

	(* Erase test objects when testing is complete*)
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeFlowCytometryQ*)


(* Define Tests *)
DefineTests[ValidAnalyzeFlowCytometryQ,
	{
		Example[{Basic, "Validate input of a single flow cytometry data object:"},
			ValidAnalyzeFlowCytometryQ[
				Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 1"]
			],
			True
		],
		Example[{Basic, "Validate input of multiple flow cytometry data objects:"},
			ValidAnalyzeFlowCytometryQ[
				{
					Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 2"],
					Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 3"]
				},
				Method->{Manual,Automatic}
			],
			True
		],
		Example[{Basic, "Validate input of a protocol with multiple flow cytometry data objects. This function call will return failed because the test protocol is invalid:"},
			ValidAnalyzeFlowCytometryQ[
				Object[Protocol,FlowCytometry,"ValidAnalyzeFlowCytometryQ test protocol"],
				Normalize->{True,False,True,False}
			],
			False
		],
		Example[{Options, OutputFormat, "By default, ValidAnalyzeFlowCytometryQ returns a boolean:"},
			ValidAnalyzeFlowCytometryQ[
				Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 1"],
				OutputFormat->Boolean
			],
			True
		],
		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			ValidAnalyzeFlowCytometryQ[
				Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 1"],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose output indicating test passage/failure for each test:"},
			ValidAnalyzeFlowCytometryQ[
				{
					Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 2"],
					Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 3"]
				},
				Normalize->{True,False,True},
				Verbose->True
			],
			False
		],
		Example[{Options, Verbose, "Print verbose messages for failures only:"},
			ValidAnalyzeFlowCytometryQ[
				{
					Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 2"],
					Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 3"]
				},
				Normalize->{True,False,True},
				Verbose->Failures
			],
			False
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Create test objects when tests start *)
	SymbolSetUp:>(
		(* Reset the created objects list *)
		$CreatedObjects={};
		SeedRandom[123];

		(* Erase any objects we missed in the last unit test run *)
		Module[{allObjects,existingObjects,testObj1,testObj2,testObj3,testObj4,testProtocol},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 1"],
				Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 2"],
				Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 3"],
				Object[Data,FlowCytometry,"ValidAnalyzeFlowCytometryQ test data 4"],
				Object[Protocol,FlowCytometry,"ValidAnalyzeFlowCytometryQ test protocol"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test objects *)
			testObj1=Analysis`Private`makeTestFlowCytometryDataPacket[200,30,2,"ValidAnalyzeFlowCytometryQ test data 1"];
			testObj2=Analysis`Private`makeTestFlowCytometryDataPacket[400,30,3,"ValidAnalyzeFlowCytometryQ test data 2"];
			testObj3=Analysis`Private`makeTestFlowCytometryDataPacket[1000,30,5,"ValidAnalyzeFlowCytometryQ test data 3"];
			testObj4=Analysis`Private`makeTestFlowCytometryDataPacket[200,5,2,"ValidAnalyzeFlowCytometryQ test data 4"];

			(* Load up a test protocol *)
			testProtocol=<|
				Type->Object[Protocol,FlowCytometry],
				Name->"ValidAnalyzeFlowCytometryQ test protocol",
				DateCreated->Now,
				DeveloperObject->True,
				Replace[Data]->(Link[#,Protocol]&/@{testObj1,testObj2,testObj3})
			|>;

			(* Upload everything *)
			Upload[{testObj1,testObj2,testObj3,testObj4,testProtocol}];
		];
	),

	(* Erase test objects when testing is complete*)
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];

(* pull out app from mouse guide *)
removeMouseGuide[app_] := If[$CCD,
	Part[app, 2,1,2,1],
	app
];

(* In MM 13.2 there is a HoldForm wrapped around Dynamic that we need to Replace as well *)
setCytometryDynamics[dynamicModule_]:=dynamicModule/.{Verbatim[HoldForm][d_Dynamic]:>Setting[d],d_Dynamic:>Setting[d]};