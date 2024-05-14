(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* AnalyzeFlowCytometry *)


(* ::Subsection:: *)
(* Patterns *)

(* Mapping between the string labels for flow cytometry detectors and their fields in Object[Data,FlowCytometry] *)
flowCytometryDetectorToField=Thread[List@@FlowCytometryDetectorP->List@@FlowCytometryDataFieldsP];
flowCytometryFieldToDetector=Thread[List@@FlowCytometryDataFieldsP->List@@FlowCytometryDetectorP];


(* ::Subsection:: *)
(* Options *)


DefineOptions[AnalyzeFlowCytometry,
	Options:>{
		IndexMatching[
			{
				OptionName->CompensationMatrix,
				Default->Automatic,
				Description->"Specify the numerical correction that should be used to correct for fluorophore signal spilling over between detectors.",
				ResolutionDescription->"If not explicitly specified, the most recent compensation matrix linked to input will be used. If no compensation matrix is found, then this option will default to None.",
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[None]],
					Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CompensationMatrix]]]
				],
				Category->"Data Processing"
			},
			{
				OptionName->ActiveSubcluster,
				Default->"All",
				Description->"The cluster label corresponding to the subcluster currently being analyzed in the preview. All indicates that all data points in the input are being analyzed.",
				ResolutionDescription->"ActiveSubcluster refers to the node in the ClusterAnalysisTree to which all other options should apply.",
				AllowNull->False,
				Category->"Subclusters",
				Widget->Widget[Type->String,Pattern:>_String,Size->Line]
			},
			{
				OptionName->ClusterAnalysisTree,
				Default->Automatic,
				Description->"A directed tree which represents all cluster and subcluster analyses in this flow cytometry analysis, where each node is a clustering analysis packet.",
				AllowNull->False,
				Category->"Subclusters",
				Widget->Widget[Type->Expression,Pattern:>_Graph|All,Size->Paragraph]
			},
			IndexMatchingInput->"Flow Cytometry Data"
		],
		ModifyOptions[AnalyzeClusters,{
			{
				OptionName->ClusteredDimensions,
				Default->Automatic,
				ResolutionDescription->"Defaults to the peak area in all detection channels specified in the Detectors field of the input protocol.",
				Widget->Adder[{
					"Detector"->Widget[Type->Enumeration,Pattern:>FlowCytometryDetectorP],
					"Measurement"->Widget[Type->Enumeration,Pattern:>Alternatives[Height,Area,Width]]
				}],
				IndexMatching->ClusteredDimensions,
				IndexMatchingInput->"Flow Cytometry Data"
			},
			{
				OptionName->DimensionLabels,
				Default->Automatic, (* Change default from None->Automatic *)
				ResolutionDescription->"Defaults to the name of the detector + the measurement (height, area, or width) in the channel.",
				IndexMatching->DimensionLabels,
				IndexMatchingInput->"Flow Cytometry Data"
			},
			{
				OptionName->ClusterAssignments,
				Description->"Putative cell identity model associated with each cluster of partitioned cells.",
				ResolutionDescription->"By default, each group of cells is labeled with sequential integers.",
				IndexMatching->ClusterAssignments,
				IndexMatchingInput->"Flow Cytometry Data"
			},
			{
				OptionName->ClusterLabels,
				Description->"Labels for each cluster of partitioned cells.",
				ResolutionDescription->"By default, each group of cells is labeled with sequential integers.",
				IndexMatching->ClusterLabels,
				IndexMatchingInput->"Flow Cytometry Data"
			},
			{
				OptionName->Normalize,
				Default->True,
				IndexMatching->Normalize,
				IndexMatchingInput->"Flow Cytometry Data"
			}
		}],
		AnalysisPreviewSymbolOption,
    AnalysisTemplateOption,
		NameOption,
    OutputOption,
    UploadOption
  },
	SharedOptions:>{
		(* Index match the Clustering options to flow cytometry input *)
		ModifyOptions["Shared",AnalyzeClusters,
			IndexMatchingInput->"Flow Cytometry Data",
			(* This can be anything except None|Null, but should be fixed when ModifyOptions gets fixed *)
			IndexMatching->ClusteredDimensions
		]
	}
];



(* ::Subsection::Closed:: *)
(*Messages and Errors*)

(* ---------------------------- *)
(* --- MESSAGES AND ERRORS  --- *)
(* ---------------------------- *)

Error::DuplicateClusterLabels="ClusterLabels `1` have already been used in this cluster analysis. Please use unique cluster labels (used labels: `2`).";
Error::InvalidActiveSubcluster="The ActiveSubcluster `1` could not be matched to any clustering analyses. Please choose ActiveSubcluster from among the labels `2`.";
Error::InvalidClusterTree="The graph `1` provided in option ClusterAnalysisTree is not a tree. Please use the AnalyzeFlowCytometry preview app in the command builder to generate valid entries for this option.";
Warning::CompensationMatrixNotFound="The parent protocol `1` of object `2` has CompensationSamplesIncluded set to True, but no CompensationMatrixAnalyses. No compensation will be used in this analysis - if compensation is desired, please run AnalyzeCompensationMatrix on parent protocol and then re-run this analysis.";
Warning::NoDataInChannel="No data was found in channels `2` of input `1`. These channels will be ignored in the ClusteredDimensions option.";



(* ::Subsection::Closed:: *)
(*Overloads*)

(* --------------------------- *)
(* --- SECONDARY OVERLOADS --- *)
(* --------------------------- *)

(* Protocol Overload *)
AnalyzeFlowCytometry[
	protocol:ObjectP[Object[Protocol,FlowCytometry]],
	myOps:OptionsPattern[AnalyzeFlowCytometry]
]:=AnalyzeFlowCytometry[Download[protocol,Packet[Data[All]]],myOps];



(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* ------------------------ *)
(* --- PRIMARY OVERLOAD --- *)
(* ------------------------ *)
AnalyzeFlowCytometry[
	myInputs:ListableP[ObjectP[Object[Data,FlowCytometry]]],
	myOps:OptionsPattern[AnalyzeFlowCytometry]
]:=Module[
	{
		outputSpecification,output,gatherTests,listedInputs,listedOptions,
		standardFieldsStart,safeOptions,safeOptionsTests,expandedOriginalOps,
		validLengths,validLengthTests,templateGraph,templateCompensationMatrix,
		templatePacket,templateSubclustersQ,templatedOptions,templateTests,
		combinedOptions,expandedInputs,expandedOptions,inputPackets,
		inputPacketsWithDetectors,protocolDetectors,protocolCompensationQ,compMatrix,
		resolvedInputs,resolvedInputLabels,partiallyResolvedOptions,
		clusteringPackets,clusteringPacketsWithIDs,resolvedClusterOptions,
		cleanedOptions,joinedOptions,collapsedOptions,analysisPackets,
		uploadResult,resultRule,previewRule
	},

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Ensure that inputs and options are in a list *)
	listedInputs=ToList[myInputs];
	listedOptions=ToList[myOps];

	(* Populate standard fields for constructing analysis object packets later *)
	standardFieldsStart=analysisPacketStandardFieldsStart[listedOptions];

	(* Call safe options to ensure all options are populated and match patterns *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeFlowCytometry,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeFlowCytometry,listedOptions,AutoCorrect->False],Null}
	];

	(* Return $Failed (and tests to this point) if specified options do not match patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];

	(* Verify that index-matched inputs are the correct length. *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeFlowCytometry,{listedInputs},safeOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeFlowCytometry,{listedInputs},safeOptions],Null}
	];

	(* If index-matched options are not matched to inputs, return $Failed. Return tests up to this point. *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->Join[safeOptionsTests,validLengthTests]
		}]
	];

	(* Batch download all input packets ad the template. Download the whole thing because we need all data points. *)
	{inputPacketsWithDetectors,{templatePacket}}=Check[
		Download[
			{
				listedInputs,
				{Lookup[listedOptions,Template,Null]}
			},
			{
				{Packet[All],Protocol[Detectors],Protocol[CompensationSamplesIncluded],Protocol[CompensationMatrixAnalyses][Object]},
				{Packet[All]}
			}
		],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests, templateTests]
		}]
	];

	(* Unwrap the output of the download a little bit *)
	{inputPackets,protocolDetectors,protocolCompensationQ,compMatrix}=Transpose@inputPacketsWithDetectors;

	(* Get the template graph and compensation matrix *)
	{templateGraph,templateCompensationMatrix}=If[MatchQ[templatePacket,Null|{}|{Null}],
		{Null,Null},
		Lookup[
			FirstOrDefault[templatePacket],
			{ClusterAnalysisTree,CompensationMatrix}
		]
	];

	(* True if the template object uses subclusters *)
	templateSubclustersQ=(Length[VertexList[templateGraph]]>1);

	(* Templating is special for this function because subcluster analysis must be re-resolved *)
	{templatedOptions,templateTests}=If[templateSubclustersQ,
		flowCytometryTemplateOptions[inputPackets,templateGraph,templateCompensationMatrix],
		If[gatherTests,
			ApplyTemplateOptions[AnalyzeFlowCytometry,listedInputs,listedOptions,Output->{Result,Tests}],
			{ApplyTemplateOptions[AnalyzeFlowCytometry,listedInputs,listedOptions],Null}
		]
	];

	(* Return $Failed if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests, templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Expand original options *)
	{expandedInputs,expandedOriginalOps}=ExpandIndexMatchedInputs[AnalyzeFlowCytometry,
		{listedInputs},
		listedOptions
	];

	(* Expand index matched options. expandedInputs is not used/needed because there is only one input. *)
	{expandedInputs,expandedOptions}=ExpandIndexMatchedInputs[AnalyzeFlowCytometry,
		{listedInputs},
		combinedOptions
	];

	(* Resolve the inputs; convert each input into a multi-dimensional array of data points with labels *)
	{resolvedInputs,resolvedInputLabels}=resolveAnalyzeFlowCytometryInputs[
		inputPackets,
		protocolDetectors,
		expandedOptions,
		compMatrix
	];

	(* Resolve options to pass to clusters. This returns a list, index-matched to inputs. *)
	partiallyResolvedOptions=Check[
		resolveAnalyzeFlowCytometryOptions[
			listedInputs,
			resolvedInputLabels,
			expandedOptions,
			expandedOriginalOps,
			protocolCompensationQ,
			compMatrix
		],
		(* Early fail state if we hit an invalid option error *)
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests, templateTests]
		}],
		{Error::InvalidOption}
	];

	(* Call clusters with Options and Upload->False *)
	{clusteringPackets,resolvedClusterOptions}=Quiet[Transpose@MapThread[
		AnalyzeClusters[#1,
			ReplaceRule[
				ToList[Plot`Private`stringOptionsToSymbolOptions[
					PassOptions[AnalyzeFlowCytometry,AnalyzeClusters,#2]
				]],
				{Output->{Result,Options},Upload->False}
			]
		]&,
		{resolvedInputs,partiallyResolvedOptions}
	]];

	(* Create IDs for the clustering packets so we can upload them later *)
	clusteringPacketsWithIDs=Map[
		Append[#,Object->CreateID[Object[Analysis,Clusters]]]&,
		clusteringPackets
	];

	(* Convert clustering options to flow cytometry format *)
	cleanedOptions=MapThread[
		cleanupResolvedOptions[#1,#2,#3,#4]&,
		{
			clusteringPacketsWithIDs,
			resolvedInputLabels,
			partiallyResolvedOptions,
			resolvedClusterOptions
		}
	];

	(* Convert a list of resolved options back to index-matched format *)
	joinedOptions=joinResolvedOptions[cleanedOptions];

	(* Collapse index-matched options for return to the command builder *)
	collapsedOptions=CollapseIndexMatchedOptions[
		AnalyzeFlowCytometry,
		joinedOptions,
		Messages->False
	];

	(* For each input, assemble the analysis packet *)
	analysisPackets=MapThread[
		assembleFlowCytometryPacket[#1,#2,#3,standardFieldsStart]&,
		{
			inputPackets,
			clusteringPacketsWithIDs,
			cleanedOptions
		}
	];

	(* Upload packets if requested, otherwise just return analysis packets *)
	uploadResult=If[Lookup[collapsedOptions,Upload]&&MemberQ[output,Result],
		(* If Upload was requested, upload intermediate clustering packets with flow cyt packets *)
		Part[
			Upload[Flatten[{analysisPackets,clusteringPacketsWithIDs}]],
			1;;Length[analysisPackets]
		],
		(* Otherwise, just return the packets *)
		analysisPackets
	];

	(* Return the result if requested, de-listing if needed *)
	resultRule=Result->If[MemberQ[output,Result],
		If[Length[uploadResult]==1,
			First[uploadResult],
			uploadResult
		],
		Null
	];

	(* Prepare the preview rule; return plot if single input, otherwise throw multiple plots into a slide view *)
	previewRule=Preview->If[MemberQ[output,Preview],
		AdjustForCCD[If[Length[analysisPackets]>1,
			SlideView[flowCytometryPreview/@analysisPackets],
			flowCytometryPreview[First[analysisPackets]]
		], AnalyzeFlowCytometry],
		Null
	];

	(* Return the requested outputs *)
	outputSpecification/.{
		resultRule,
		previewRule,
		Options->RemoveHiddenOptions[AnalyzeFlowCytometry,collapsedOptions],
		Tests->Join[safeOptionsTests,validLengthTests,templateTests]
	}
];



(* ::Subsection::Closed:: *)
(*Resolution Functions*)


(* ::Subsubsection::Closed:: *)
(*flowCytometryTemplateOptions*)

(* Resolve the ClusterAnalysisTree and CompensationMatrix options *)
flowCytometryTemplateOptions[inputList_,templateGraph_,templateMatrix_]:=Module[
	{vertexWeights,templateMatPacket,newGraphs},

	(* Vertex weights of the graph are object references of existing clusters analyses *)
	vertexWeights=AnnotationValue[templateGraph,VertexWeight];

	(* Load the flow cytometry cache *)
	MapThread[
		($FlowCytometryClustersCache[#1]=#2;)&,
		{vertexWeights,Download[vertexWeights]}
	];

	(* Packet for the compensation matrix *)
	templateMatPacket=If[MatchQ[templateMatrix,ObjectP[Object[Analysis,CompensationMatrix]]],
		Download[templateMatrix],
		Null
	];

	(* For each input, recompute the subclustering graph using inherited options from templateGraph *)
	newGraphs=Map[
		recomputeSubclusters[#,templateGraph]&,
		inputList
	];

	(* Return template options and tests *)
	{
		(* Template options *)
		{
			ClusterAnalysisTree->newGraphs,
			CompensationMatrix->(templateMatrix/.{Null->None})
		},
		(* This overload does not produce any tests*)
		{}
	}
];


(* Given an input and a template graph, recompute the subclustering analysis tree *)
recomputeSubclusters[dataPkt_,tree_]:=Module[
	{newVertexWeights,visitQueue,currNode,parentNode,currNodeOps,currData,currAnalysisRef,currAnalysis},

	(* A mapping of label to vertex weight which we will build *)
	newVertexWeights={};

	(* Breadth-first traversal to recompute tree. "All" is the root note of the tree *)
	visitQueue={"All"};

	(* Traversal *)
	While[Length[visitQueue]>0,
		(* Pop the first node of the queue *)
		currNode=First[visitQueue];
		visitQueue=Rest[visitQueue];

		(* Parent node of current node *)
		parentNode=If[currNode=="All",
			Null,
			FirstOrDefault[AdjacencyList[tree,currNode]]
		];

		(* Get unresolved options from the current node *)
		currNodeOps=Lookup[
			downloadFromFlowCytometryCache[
				AnnotationValue[{tree,currNode},VertexWeight]
			],
			UnresolvedOptions
		];

		(* Get data from the parent node *)
		currData=If[currNode=="All",
			(* Use input packet at head *)
			First@resolveSingleFlowCytometryInput[
				dataPkt,
				Automatic,
				"All",
				(Quiet@Download[Lookup[dataPkt,Protocol],Detectors]/.{$Failed|Null->{}}),
				LastOrDefault[Quiet@Download[Lookup[dataPkt,Protocol],Packet[CompensationMatrixAnalyses[All]]]]
			],
			(* Otherwise, propagate data from the parent node *)
			Lookup[
				downloadFromFlowCytometryCache[Lookup[newVertexWeights,parentNode]],
				ClusteredData
			][currNode]
		];


		(* Create an ID for new subclusters object *)
		currAnalysisRef=CreateID[Object[Analysis,Clusters]];

		(* Sub-analyses for subclustering, with an ID generated *)
		$FlowCytometryClustersCache[currAnalysisRef]=Join[
			AnalyzeClusters[
				currData,
				Sequence@@ReplaceRule[currNodeOps,{Upload->False,Output->Result}]
			],
			<|Object->currAnalysisRef|>
		];

		(* Create the new rule *)
		newVertexWeights=Append[newVertexWeights,currNode->currAnalysisRef];

		(* Add children of the current node to the queue *)
		visitQueue=Join[visitQueue,Drop[VertexOutComponent[tree,currNode,1],1]];
	];

	(* Sub in the new vertex weights *)
	Annotate[tree,VertexWeight->newVertexWeights]
];



(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFlowCytometryInputs*)

(* Convert a list of flow cytometry data object types to a list of multi-dimensional data sets with labeled dimensions *)
resolveAnalyzeFlowCytometryInputs[inputPackets:{PacketP[Object[Data,FlowCytometry]]..},protocolDetectors_,expandedOps_,cmats_]:=Module[
	{trees,activeClusters,compensationMatrices,compMatPackets},

	(* Subcluster analysis tree and active cluster for each input *)
	trees=Lookup[expandedOps,ClusterAnalysisTree];
	activeClusters=Lookup[expandedOps,ActiveSubcluster];

	(* Compensation matrix for each input *)
	compensationMatrices=MapThread[
		If[MatchQ[#1,ObjectP[Object[Analysis,CompensationMatrix]]|None],
			#1/.{None->Null},
			LastOrDefault[#2,None]/.{Null|{}|Automatic|None->Null}
		]&,
		{Lookup[expandedOps,CompensationMatrix],cmats}
	];

	(* Get compensation matrix packets *)
	compMatPackets=Flatten@Download[compensationMatrices];

	(* Resolve each input separately from its packet *)
	Transpose@MapThread[
		resolveSingleFlowCytometryInput[#1,#2,#3,#4,#5]&,
		{inputPackets,trees,activeClusters,protocolDetectors,compMatPackets}
	]
];


(* Given a flow cytometry data packet, return {multi-D data, list of labels} *)
resolveSingleFlowCytometryInput[in_,tree_,active_,detectors_,compMatPacket_]:=Module[
	{activeSubPacket,filteredFieldsToDetectors,dataLabelPairs,sortedPairs,allData,allLabels,compensatedData},

	(* If tree is a graph, try to retrive the active subcluster packet *)
	activeSubPacket=If[MatchQ[tree,_Graph],
		downloadFromFlowCytometryCache[AnnotationValue[{tree,active},VertexWeight]],
		$Failed
	];

	(* If we resolved to a packet, then retrieve that data *)
	If[MatchQ[activeSubPacket,PacketP[Object[Analysis,Clusters]]],
		Return[{
			Join@@Values[Lookup[activeSubPacket,ClusteredData]],
			Lookup[activeSubPacket,DimensionLabels]
		}]
	];

	(* Restrict the analysis to only the detectors specified in the parent protocol. If missing, use all available data. *)
	filteredFieldsToDetectors=If[MatchQ[detectors,{}|Null],
		flowCytometryFieldToDetector,
		Select[flowCytometryFieldToDetector,MemberQ[detectors,Last[#]]&]
	];

	(* For each possible detector, get the Nx3 array of {height, area, width} data, make labels, and flatten it *)
	dataLabelPairs=Map[
		Function[{fieldAndDetector},
			(* Check if the field we want to check has data *)
			If[MatchQ[Lookup[in,First[fieldAndDetector]],Null],
				(* If there is no data, return no entry *)
				Nothing,
				(* Otherwise, split the 3x1 array of height, area, and width for the detector and make labels *)
				Sequence@@MapThread[
					{
						N[Part[Lookup[in,First[fieldAndDetector]],All,#1]],
						(Last[fieldAndDetector]<>#2)
					}&,
					{{1,2,3},{" H"," A"," W"}}
				]
			]
		],
		filteredFieldsToDetectors
	];

	(* Rearrange the data *)
	sortedPairs=SortBy[dataLabelPairs,
		{
			(* First group by area, height, or width *)
			StringTake[Last[#],-1]&,
			(* Then put the Forward and Side Scatter in front (they have shorter names ) *)
			StringLength[Last[#]]>10&,
			(* Then sort by excitation wavelength *)
			StringTake[Last[#],1;;3]&,
			(* Then sort by emission wavelength *)
			StringTake[Last[#],5;;7]&
		}
	];

	(* Join all the data together *)
	allData=Transpose@QuantityArray[
		Part[sortedPairs,All,1]
	];

	(* Get just the labels *)
	allLabels=Part[sortedPairs,All,-1];

	(* If a compensation matrix packet is provided, then apply it to the input data *)
	compensatedData=If[MatchQ[compMatPacket,_Association],
		applyCompensationMatrix[allData,allLabels,compMatPacket],
		allData
	];

	(* Return the data with labeled dimensions *)
	{compensatedData,allLabels}
];


(* Apply compensation matrix to data *)
applyCompensationMatrix[data_,dimLabels_,compPacket_]:=Module[
	{
		ndim,areaData,heightData,widthData,dataDimToIndex,compDimToIndex,
		dataDimToCompDim,rawCompMatrix,partlyExpandedMatrix,expandedCompMatrix,
		compensatedAreaData,compensatedHeightData,compensatedWidthData
	},

	(* Dim labels is always three times the number of detectors, sorted area->height->width *)
	ndim=Length[dimLabels]/3;

	(* Split data by area, height, then width *)
	{areaData,heightData,widthData}=Transpose/@Partition[
		Transpose[data],
		ndim
	];

	(* Mapping of dimension labels to index in the data array *)
	dataDimToIndex=MapIndexed[
		StringTake[#1,;;-3]->First[#2]&,
		dimLabels[[;;ndim]]
	];

	(* Mapping of dimension labels to index in the compensation matrix *)
	compDimToIndex=MapIndexed[
		#1->First[#2]&,
		Lookup[compPacket,Detectors]
	];

	(* Map data dimension indices to compensation matrix indices *)
	dataDimToCompDim=Map[
		Last[#]->Lookup[compDimToIndex,First[#],Null]&,
		dataDimToIndex
	];

	(* Get the compensation matrix from the packet, which may have reduced dimension *)
	rawCompMatrix=2.0*IdentityMatrix[3];(*Lookup[compPacket,CompensationMatrix];*)

	(* Rearrange and expand the compensation matrix rows to match dimensions of data *)
	partlyExpandedMatrix=Map[
		If[MatchQ[Last[#],Null],
			Repeat[0.0,ndim],
			PadRight[Part[rawCompMatrix,Last[#]],ndim,0.0]
		]&,
		SortBy[dataDimToCompDim,First]
	];

	(* Rearrange the columns to complete the expansion *)
	expandedCompMatrix=Transpose@Map[
		If[MatchQ[Last[#],Null],
			UnitVector[ndim,First[#]],
			Part[Transpose@partlyExpandedMatrix,Last[#]]
		]&,
		SortBy[dataDimToCompDim,First]
	];

	(* Apply the matrix to each data set *)
	{compensatedAreaData,compensatedHeightData,compensatedWidthData}=Map[
		Transpose[expandedCompMatrix.Transpose[#]]&,
		{areaData,heightData,widthData}
	];

	(* Join them back together *)
	Join[compensatedAreaData,compensatedHeightData,compensatedWidthData,2]
];



(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFlowCytometryOptions*)

(* Resolve options specific to FlowCytometry. Clusters options will be resolved by AnalyzeClusters *)
resolveAnalyzeFlowCytometryOptions[inputs_,inputLabels_,expandedOps_,expandedOriginalOps_,compensationProtocolQ_,compMatrices_]:=Module[
	{onlyIndexMatchedOps,onlyIndexOriginalOps,resolvedOpsPerInput},

	(* Drop the non-index-matched options. These do not need further resolution *)
	onlyIndexMatchedOps=DeleteCases[expandedOps,
		HoldPattern[Output|Upload|Name|Template|PreviewSymbol->_]
	];

	(* Index-matched original options only *)
	onlyIndexOriginalOps=DeleteCases[expandedOriginalOps,
		HoldPattern[Output|Upload|Name|Template|PreviewSymbol->_]
	];

	(* Resolve options per input *)
	resolvedOpsPerInput=MapThread[
		Function[{objRef,labels,idx,compQ,compMat},
			resolveAnalyzeFlowCytometryOptionsSingle[
				objRef,
				labels,
				(First[#]->Part[Last[#],idx])&/@onlyIndexMatchedOps,
				(First[#]->Part[Last[#],idx])&/@onlyIndexOriginalOps,
				compQ,
				compMat
			]
		],
		{
			Download[inputs,Object],
			inputLabels,
			Range[Length[inputLabels]],
			compensationProtocolQ,
			compMatrices
		}
	];

	(* Reappend the Output, Upload, and Template options *)
	Map[
		ReplaceRule[#,
			Cases[expandedOps,HoldPattern[Output|Upload|Name|Template|PreviewSymbol->_]]
		]&,
		resolvedOpsPerInput
	]
];


(* Given a single set of labels and options corresponding to a single input, resolve options *)
resolveAnalyzeFlowCytometryOptionsSingle[objRef_,labels_,ops_,origOps_,compensateQ_,compMatrix_]:=Module[
	{
		resolvedDimLabels,originalClusterDims,clusterDimStrings,
		clusterDimIndices,resolvedClusteredDims,defaultMatrix,
		resolvedCompensationMatrix,subclusterTree,activeSubcluster,
		validSubclusters,clusterLabels,duplicateLabels,
		subclusterOps,filteredSubclusterOps,defaultOps
	},

	(* Automatic dimension labels resolves to the label list *)
	resolvedDimLabels=Lookup[ops,DimensionLabels]/.{
		Automatic->labels
	};

	(* Value of the supplied cluster dimensions option *)
	originalClusterDims=Lookup[ops,ClusteredDimensions];

	(* Convert the clustered dimensions options into strings which match labels *)
	clusterDimStrings=If[!MatchQ[originalClusterDims,Automatic],
		Map[
			First[#]<>Switch[Last[#],
				Height," H",
				Area," A",
				Width," W"
			]&,
			originalClusterDims
		],
		(* Automatic resovles to all area measurements *)
		Select[labels,StringTake[#,-1]=="A"&]
	];

	(* Convert dimension strings to indices present in the data *)
	clusterDimIndices=Map[
		FirstOrDefault[FirstPosition[labels,#]]&,
		clusterDimStrings
	];

	(* Warning if any dims are not present in data *)
	If[MemberQ[clusterDimIndices,"NotFound"],
		Message[Warning::NoDataInChannel,
			objRef,
			PickList[clusterDimStrings,(#=="NotFound")&/@clusterDimIndices]
		]
	];

	(* Take only properly resolved integer indices *)
	resolvedClusterDims=Cases[clusterDimIndices,_Integer,1]/.{
		{}->Automatic
	};

	(* Compensation matrix resolved from the linked protocol to input object, Null if not present *)
	defaultMatrix=If[TrueQ[compensateQ],
		LastOrDefault[compMatrix,None],
		None
	];

	(* Automatic resolves to the default matrix *)
	resolvedCompensationMatrix=Lookup[ops,CompensationMatrix]/.{
		Automatic->defaultMatrix
	};

	(* Warning message if linked protocol had CompensationSampleIncluded->True but no compensation matrix  *)
	If[TrueQ[compensateQ]&&MatchQ[defaultMatrix,None],
		Message[Warning::CompensationMatrixNotFound,Download[objRef,Protocol[Object]],objRef];
	];

	(* Check the analysis tree option *)
	subclusterTree=Lookup[ops,ClusterAnalysisTree];

	(* Check to see if the cluster analysis tree is a valid tree graph *)
	If[MatchQ[subclusterTree,_Graph]&&(!TreeGraphQ[subclusterTree]),
		Message[Error::InvalidClusterTree,subclusterTree];
		Message[Error::InvalidOption,ClusterAnalysisTree];
		Return[{}];
	];

	(* Get the active subcluster option *)
	activeSubcluster=Lookup[ops,ActiveSubcluster];

	(* List of valid specifications for the active subcluster *)
	validSubclusters=If[MatchQ[subclusterTree,_Graph],
		VertexList[subclusterTree],
		{"All"}
	];

	(* If the specified active cluster is not a member of the valid ones, return an error *)
	If[!MemberQ[validSubclusters,activeSubcluster],
		Message[Error::InvalidActiveSubcluster,activeSubcluster,validSubclusters];
		Message[Error::InvalidOption,ActiveSubcluster];
	];

	(* User supplied cluster labels option *)
	clusterLabels=Lookup[ops,ClusterLabels,{}]/.{Automatic->{}};

	(* Make sure none of the cluster labels overlap with existing labels in the subcluster analysis *)
	duplicateLabels=If[MatchQ[subclusterTree,_Graph],
		Select[clusterLabels,MemberQ[VertexList[subclusterTree],#]&],
		{}
	];

	(* Error message if labels option includes duplicates *)
	If[!DuplicateFreeQ[clusterLabels/.{Automatic->{}}],
		Message[Error::DuplicateClusterLabels,
			First/@Select[Tally[clusterLabels],Last[#]>1&],
			If[MatchQ[subclusterTree,_Graph],VertexList[subclusterTree],DeleteDuplicates[clusterLabels]]
		];
		Message[Error::InvalidOption,ClusterLabels];
	];

	(* Error message if labels have already been used *)
	If[Length[duplicateLabels]>0,
		Message[Error::DuplicateClusterLabels,duplicateLabels,VertexList[subclusterTree]];
		Message[Error::InvalidOption,ClusterLabels];
	];

	(* If the active subcluster already has resolved options, then use those *)
	subclusterOps=If[MatchQ[subclusterTree,_Graph]&&!MatchQ[AnnotationValue[{subclusterTree,activeSubcluster},VertexWeight],$Failed],
		Lookup[
			stripAppendReplaceKeyHeads@downloadFromFlowCytometryCache[
				AnnotationValue[{subclusterTree,activeSubcluster},VertexWeight]
			],
			UnresolvedOptions,
			{}
		],
		{}
	];

	(* Filter out subcluster options *)
	filteredSubclusterOps=DeleteCases[subclusterOps,
		Rule[
			Alternatives@@{Output,Upload,If[MatchQ[resolvedClusterDims,Automatic],Nothing,ClusteredDimensions]},
			_
		]
	];

	(* Replace safe/default options with subcluster-specific options, then sub-in the original options *)
	defaultOps=ReplaceRule[
		ReplaceRule[ops,filteredSubclusterOps],
		origOps
	];

	(* Then, sub-in the resolutions *)
	ReplaceRule[defaultOps,{
		CompensationMatrix->resolvedCompensationMatrix,
		ClusteredDimensions->resolvedClusterDims,
		DimensionLabels->resolvedDimLabels
	}]
];



(* ::Subsubsection::Closed:: *)
(*cleanupResolvedOptions*)

(* Take resolved options from AnalyzeClusters and convert them back to AnalyzeFlowCytometry format *)
cleanupResolvedOptions[activePacket_,labels_,partialOps_,clusterOps_]:=Module[
	{fullOps,clusterDimIndices,resolvedClusterDims,resolvedScale,clusterTree,activeSubcluster,resolvedClusterTree},

	(* Re-add any clustering options which got filtered out in the AnalyzeClusters call(s) *)
	fullOps=ReplaceRule[partialOps,
		DeleteCases[clusterOps,Rule[Template|Upload|Name|Output|PreviewSymbol,_]]
	];

	(* If Scale option is repeated identical elements, collapse it *)
	resolvedScale=Lookup[clusterOps,Scale]/.{
			Rule[Scale,{(p_)..}]:>Rule[Scale,p]
	};

	(* Indices of clustered dimensions *)
	clusterDimIndices=Lookup[clusterOps,ClusteredDimensions];

	(* Convert labels back into the options format *)
	resolvedClusterDims=If[MatchQ[clusterDimIndices,Null],
		Null,
		Map[
			{
				StringTake[#,1;;-3],
				Switch[StringTake[#,-1],
					"A",Area,
					"W",Width,
					"H",Height,
					_,Null
				]
			}&,
			Part[labels,clusterDimIndices]
		]
	];

	(* Get the cluster analysis tree, resolving Automatic if applicable *)
	clusterTree=Lookup[fullOps,ClusterAnalysisTree]/.{
		Automatic->Graph[
			{"All"},
			{},
			VertexWeight->{"All"->Lookup[activePacket,Object]},
			VertexLabels->"Name"
		]
	};

	(* Get the label for the current subcluster *)
	activeSubcluster=Lookup[fullOps,ActiveSubcluster];

	(* Substitute in the active packet if we are looking at a child node *)
	resolvedClusterTree=If[isLeafNode[clusterTree,activeSubcluster],
		Annotate[clusterTree,
			VertexWeight->{activeSubcluster->Lookup[activePacket,Object]}
		],
		clusterTree
	];

	(* Update the flow cytometry cache *)
	$FlowCytometryClustersCache[Lookup[activePacket,Object]]=activePacket;

	(* Return the resolved options *)
	ReplaceRule[fullOps,{
		ClusteredDimensions->resolvedClusterDims,
		ClusterAnalysisTree->resolvedClusterTree,
		Scale->resolvedScale
	}]
];



(* ::Subsubsection::Closed:: *)
(*joinResolvedOptions*)

(* Convert multiple lists of options into a single options list in the index-matched format *)
joinResolvedOptions[cleanOps_]:=Module[
	{indexMatchedOps,nonIndexMatchedOps,flatOps,collapsedOps},

	(* List of index matched option symbols for AnalyzeFlowCytometry *)
	indexMatchedOps=ToExpression@Lookup[
		Select[OptionDefinition[AnalyzeFlowCytometry],(Lookup[#,"IndexMatchingInput"]=!=Null)&],
		"OptionName"
	];

	(* List of non index matched option symbols for AnalyzeFlowCytometry *)
	nonIndexMatchedOps=ToExpression@Lookup[
		Select[OptionDefinition[AnalyzeFlowCytometry],(Lookup[#,"IndexMatchingInput"]===Null)&],
		"OptionName"
	];

	(* Non index matched options as rules *)
	flatOps=Map[
		Function[{opSymbol},
			opSymbol->Lookup[First[cleanOps],opSymbol]
		],
		nonIndexMatchedOps
	];

	(* Index-matched options as rules *)
	collapsedOps=Map[
		Function[{opSymbol},
			(opSymbol->Lookup[cleanOps,opSymbol])/.{
				Rule[Scale,{x_}]:>Rule[Scale,x]
			}
		],
		indexMatchedOps
	];

	(* Join the two option sets together *)
	Join[flatOps,collapsedOps]
];



(* ::Subsubsection::Closed:: *)
(*assembleFlowCytometryPacket*)

(* Assemble a flow cytometry analysis packet *)
assembleFlowCytometryPacket[dataPacket_,activeClusterPacket_,resolvedOps_,standardFields_]:=Module[
	{
		clusterTree,activeCluster,subclustersQ,dataObjRef,totalEvents,sampleVolume,clusterRefs,
		clusterFields,clusteredData,clusterCounts,clusterDensities,formattedClusterFields
	},

	(* The resolved subcluster analysis tree *)
	clusterTree=Lookup[resolvedOps,ClusterAnalysisTree];
	activeCluster=Lookup[resolvedOps,ActiveSubcluster];

	(* True if subclustering analysis was done (i.e. there is more than one node in the subcluster tree) *)
	subclustersQ=Length[VertexList[clusterTree]]>1;

	(* Lookup the event count and input volume from the input data packet to compute cluster cell counts *)
	{dataObjRef,totalEvents,sampleVolume}=Lookup[dataPacket,{Object,Events,Volume}];

	(* Retreive the IDs we generated for clustering packets *)
	clusterRefs=If[subclustersQ,
		(* If yes, then extract all object IDs from the analysis tree *)
		AnnotationValue[clusterTree,VertexWeight],
		(* If no subclustering, just use the active clusters packet *)
		ToList[Lookup[activeClusterPacket,Object]]
	];

	(* Get all fields related to clustered data *)
	clusterFields=If[subclustersQ,
		(* If we are subclustering, then we need to collapse the tree *)
		collapseClusterTree[clusterTree],
		(* If we are not subclustering, we can just download these fields from the active packet *)
		Quiet@Download[stripAppendReplaceKeyHeads@activeClusterPacket,
			Packet[
				ClusterLabels,
				ClusterAssignments,
				NumberOfDimensions,
				DimensionLabels,
				DimensionUnits,
				ClusteredData
			]
		]
	];

	(* Association of clustered data points *)
	clusteredData=Lookup[clusterFields,ClusteredData];

	(* Count the number of cells in each cluster *)
	clusterCounts=Map[
		Length[Lookup[clusteredData,#]]&,
		Lookup[clusterFields,ClusterLabels]
	];

	(* Get density per milliliter *)
	clusterDensities=N[clusterCounts]/sampleVolume;

	(* Drop the Object, ID, and Type fields, and restore formatting for multiple fields *)
	formattedClusterFields=Normal[KeyDrop[clusterFields,{Object,ID,Type}]]/.{
		ClusterLabels->Replace[ClusterLabels],
		ClusterAssignments->Replace[ClusterAssignments],
		DimensionLabels->Replace[DimensionLabels],
		DimensionUnits->Replace[DimensionUnits],
		None->Null,
		$Failed->Null
	};

	(* Assemble the analysis packet *)
	Join[
		(* Shared fields *)
		<|
			Type->Object[Analysis,FlowCytometry],
			Replace[Reference]->Link[dataObjRef,FlowCytometryAnalyses],
			Name->Lookup[resolvedOps,Name],
			ResolvedOptions->resolvedOps,
			Sequence@@standardFields
		|>,
		Association@@standardFields,
		<|
			(* Flow cytometry specific fields *)
			Replace[CellCounts]->clusterDensities,
			Replace[AbsoluteCellCounts]->clusterCounts,
			CompensationMatrix->Lookup[resolvedOps,CompensationMatrix,Null]/.{
				None->Null,obj:ObjectP[Object[Analysis,CompensationMatrix]]:>Link[obj]
			},
			ClusterAnalysisTree->clusterTree,
			Replace[ClustersAnalyses]->(Link[#,FlowCytometryAnalyses]&/@clusterRefs),
			Sequence@@formattedClusterFields
		|>
	]
];


(* ::Subsubsection::Closed:: *)
(*collapseClusterTree*)

(* Given a clustering analysis tree and an edited active packet, collapse the tree by partitions *)
collapseClusterTree[tree_]:=Module[
	{labelsToPackets,rootPacket,labelAssignmentData,visitQueue,currNode,collapsedLAD,finalClusteredData},

	(* Extract rules mapping text labels to packets. Prepend the node index to preserve uniqueness *)
	labelsToPackets=Map[
		(#->downloadFromFlowCytometryCache[AnnotationValue[{tree,#},VertexWeight]])&,
		VertexList[tree]
	];

	(* Get the root packet *)
	rootPacket=Analysis`Private`stripAppendReplaceKeyHeads@Lookup[labelsToPackets,"All"];

	(* Convert each packet into a list of {cluster label, cluster assignment, data pts} tuples *)
	labelAssignmentData=Map[
		Module[{label,packet,clusterLabels,clusterAssignments,clusteredData},
			label=First[#];
			packet=Analysis`Private`stripAppendReplaceKeyHeads@Last[#];
			clusterLabels=Lookup[packet,ClusterLabels,{}];
			clusterAssignments=Lookup[packet,ClusterAssignments,{}];
			clusteredData=Lookup[Lookup[packet,ClusteredData,<||>],clusterLabels];
			(* Assemble the tuples *)
			label->Transpose[{clusterLabels,clusterAssignments,First/@clusteredData}]
		]&,
		labelsToPackets
	];

	(* Breadth-first traversal to collapse tree. "All" is the root note of the tree *)
	visitQueue=Drop[VertexOutComponent[tree,"All",1],1];
	currNode="All";
	collapsedLAD=Lookup[labelAssignmentData,"All"];

	(* Traversal *)
	While[Length[visitQueue]>0,
		(* Pop the first node of the queue *)
		currNode=First[visitQueue];
		visitQueue=Rest[visitQueue];
		(* Replace the current rules *)
		collapsedLAD=collapsedLAD/.{
			{n:currNode,assign_,pts_}:>Sequence@@Lookup[labelAssignmentData,n]
		};

		(* Add children of the current node to the queue *)
		visitQueue=Join[visitQueue,Drop[VertexOutComponent[tree,currNode,1],1]];
	];

	(* Convert final clustered data into an association keyed by groups *)
	finalClusteredData=Association@@Thread[
		collapsedLAD[[All,1]]->collapsedLAD[[All,3]]
	];

	(* Return the resolved clusters fields *)
	<|
		DimensionLabels->Lookup[rootPacket,DimensionLabels],
		DimensionUnits->Lookup[rootPacket,DimensionUnits],
		NumberOfDimensions->Lookup[rootPacket,NumberOfDimensions],
		ClusterLabels->collapsedLAD[[All,1]],
		ClusterAssignments->collapsedLAD[[All,2]],
		ClusteredData->finalClusteredData
	|>
];



(* ::Subsection::Closed:: *)
(*Preview App*)


(* Convenience overload; if given a packet, generate a graph with a single root node representing that packet *)
flowCytometryPreview[initialPacket:PacketP[Object[Analysis,FlowCytometry]]]:=Module[
	{resolvedOps,tree,active},

	(* Get resolved options from the initial packet *)
	resolvedOps=Lookup[stripAppendReplaceKeyHeads@initialPacket, ResolvedOptions];

	(* Get the clustering tree and active subcluster *)
	{tree,active}=Lookup[resolvedOps,{ClusterAnalysisTree,ActiveSubcluster}];

	(* Call the primary overload *)
	flowCytometryPreview[tree,active,resolvedOps]
];

(* Top-level app generates dynamic preview from a tree of clustering analysis packets *)
flowCytometryPreview[clusteringTree_Graph, currentNode_String, resolvedOps_]:=Module[
	{writeableQ,rootQ,currPacket,initialVals,dv,getClusterPreview,menuViewContents},

	(* True if the current node has no dependencies *)
	writeableQ=isLeafNode[clusteringTree,currentNode];
	rootQ=MatchQ[currentNode,"All"];

	(* Initial values for options which are dynamically linked to the CB preview *)
	initialVals={
		ClusterAnalysisTree->clusteringTree,
		ActiveSubcluster->currentNode,
		Domain->Lookup[resolvedOps,Domain],
		ManualGates->Lookup[resolvedOps,ManualGates],
		ClusterLabels->Lookup[resolvedOps,ClusterLabels]
	};

	(* Set up a preview symbol. Use the existing symbol if it's already been initialized *)
	dv=SetupPreviewSymbol[AnalyzeFlowCytometry,Null,initialVals,PreviewSymbol->Lookup[resolvedOps,PreviewSymbol]];

	(* Helper function which generates subcluster previews from a subcluster label *)
	getClusterPreview[label_]:=Module[
		{objRef,packet},

		(* Clustering object reference associated with label in clusteringTree *)
		objRef=AnnotationValue[{clusteringTree,label},VertexWeight];

		(* Get the packet associated with this reference, using the flow cytometry cache *)
		packet=downloadFromFlowCytometryCache[objRef];

		(* Generate the clusters preview *)
		analyzeClustersPreview[
			packet,
			Enable3DClustering->False,
			NestedClustering->True,
			PreviewSymbol->dv
		]
	];

	(* Generate a list of rules to all previews. Use cached results when possible. *)
	menuViewContents=Map[
		With[{label=First[#],menuEntry=Last[#]},
			{label,menuEntry->getClusterPreview[label]}
		]&,
		treeToLabels[clusteringTree]
	];

	(* Use with to force values to evaluate *)
	With[{dvar=dv,contents=menuViewContents},

		(* Create a dynamic module for the preview *)
		DynamicModule[
			{
				(* String label for the current preview node is dynamically scoped *)
				resolutionNeeded=False,
				numNodes=Length[VertexList[clusteringTree]]
			},

			(* Overlay controls message indicating when apply and recalculate is needed *)
			Grid[
				{
					{
						(* Information panel *)
						Dynamic[
							With[{g=PreviewValue[dvar,ClusterAnalysisTree],node=PreviewValue[dvar,ActiveSubcluster]},
								Which[
									(* Nodes have been changed, must regenerate preview *)
									Length[VertexList[g]]!=numNodes,
										Text[Style[
											"Subclusters have been updated! Please click on the [Apply and Recalculate] button in the option editor.",
											15,Red,TextAlignment->Center
										]],

									(* Read only because not leaf node *)
									!isLeafNode[g,node],
										Text[Style[
											"Warning - Read Only! Subcluster cannot be updated. Please select a subcluster without children, or delete child nodes to edit this level of clustering.",
											15,Red,TextAlignment->Center
										]],

									(* No messages *)
									True,Spacer[0.0]
								]
							],
							TrackedSymbols:>{dvar}
						]
					},
					(* MenuView to construct the primary preview *)
					{
						MenuView[
							(* Contents have already been computed *)
							contents,
							(* Link the menu selector to the preview symbol *)
							Dynamic[PreviewValue[dvar,ActiveSubcluster],
								Function[{val,expr},
									Module[{packet,newOps,packetOps},
										(* Get the packet being switched too *)
										packet=downloadFromFlowCytometryCache[
											AnnotationValue[
												{PreviewValue[dvar,ClusterAnalysisTree],val},
												VertexWeight
											]
										];
										(* Resolved options from the packet *)
										packetOps=Lookup[stripAppendReplaceKeyHeads@packet,ResolvedOptions,{}];
										(* Construct new options to update to  *)
										newOps={
											ActiveSubcluster->val,
											Domain->Lookup[packetOps,Domain,{}],
											ManualGates->Lookup[packetOps,ManualGates,{}],
											ClusterLabels->Lookup[stripAppendReplaceKeyHeads@packet,ClusterLabels]
										};
										(* Log preview changes *)
										LogPreviewChanges[dvar,newOps]
									],
									HoldRest
								]
							],
							ImageSize->Automatic
						]
					},
					{
						Button[
							Style["\[UpperLeftArrow] Remove Subcluster ",Thick,Bold,FontSize->buttonFontSize],
							removeSubcluster[dvar];,
							Method->"Queued",
							FrameMargins->5,
							Enabled->Dynamic[
								With[{g=PreviewValue[dvar,ClusterAnalysisTree],node=PreviewValue[dvar,ActiveSubcluster]},
									!MatchQ[node,"All"]&&isLeafNode[g,node]
								],
								TrackedSymbols:>{dvar}
							]
						]
					}
				},
				Alignment->Center
			]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*treeToLabels*)

(* Converts a directed tree graph into a list of formatted labels with indentation for the flow cytometry preview *)
treeToLabels[g_]:=Module[
	{dfsNodeOrder,rootPos,depths,menuLabelStrings},

	(* DFS to get a node ordering for the tree like a drop down menu *)
	dfsNodeOrder=Reap[DepthFirstScan[g,"All",{"PrevisitVertex"->Sow}]][[2,1]];

	(* Root position *)
	rootPos=FirstPosition[VertexList[g],"All"];

	(* Depth of each node in the tree. This could be done in the preceding ordering, but the trees are small and dynamics will be rate limiting *)
	depths=Thread[VertexList[g]->Flatten@Part[GraphDistanceMatrix[g],rootPos]];

	(* Labels for the drop down menu, with indentation consistent with depth in tree *)
	menuLabelStrings=Map[
		With[{d=#/.depths},
			StringJoin[
				If[d>1,Sequence@@Repeat["      ",(d-1)],""],
				If[d>0," \[RightTee]--- ",""],
				#
			]
		]&,
		dfsNodeOrder
	];

	(* Format the strings into a mono-spaced font *)
	MapThread[
		Rule[#1,Style[#2,16,FontFamily->"Consolas"]]&,
		{dfsNodeOrder,menuLabelStrings}
	]
];


(* ::Subsubsection::Closed:: *)
(*isLeafNode*)

(* True if a node in a graph is a leaf node, i.e. has no outgoing edges *)
isLeafNode[g_,node_]:=(VertexOutDegree[g,node]===0);



(* ------------------------- *)
(* --- SISTER FUNCTIONS  --- *)
(* ------------------------- *)

(* ::Section:: *)
(*AnalyzeFlowCytometryOptions*)

(* Options shared with parent function, with additional OutputFormat option *)
DefineOptions[AnalyzeFlowCytometryOptions,
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
		AnalyzeFlowCytometry
	}
];

(* Call parent function with Output->Options and format output *)
AnalyzeFlowCytometryOptions[
	myInputs:ListableP[ObjectP[Object[Data,FlowCytometry]]]|ObjectP[Object[Protocol,FlowCytometry]],
	myOptions:OptionsPattern[AnalyzeFlowCytometryOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove the OutputFormat option *)
	preparedOptions=Normal@KeyDrop[
		ReplaceRule[listedOptions,Output->Options],
		{OutputFormat}
	];

	(* Get the resolved options from AnalyzeFlowCytometry *)
	resolvedOptions=DeleteCases[AnalyzeFlowCytometry[myInputs,preparedOptions],(Output->_)];

	(* Return the options as a list or table, depending on the option format *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeFlowCytometry],
		resolvedOptions
	]
];



(* ::Section:: *)
(*AnalyzeFlowCytometryPreview*)

(* Options shared with parent function *)
DefineOptions[AnalyzeFlowCytometryPreview,
	SharedOptions:>{
		AnalyzeFlowCytometry
	}
];

(* Call parent function with Output->Preview *)
AnalyzeFlowCytometryPreview[
	myInputs:ListableP[ObjectP[Object[Data,FlowCytometry]]]|ObjectP[Object[Protocol,FlowCytometry]],
	myOptions:OptionsPattern[AnalyzeFlowCytometryPreview]
]:=Module[{listedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Call the parent function with Output->Preview *)
	AnalyzeFlowCytometry[myInputs,ReplaceRule[listedOptions,Output->Preview]]
];



(* ::Section:: *)
(*ValidAnalyzeFlowCytometryQ*)

(* Options shared with parent function, plus additional Verbose and OutputFormat options *)
DefineOptions[ValidAnalyzeFlowCytometryQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{
		AnalyzeFlowCytometry
	}
];

(* Use OutputFormat->Tests to determine if parent function call is valid, +format the output *)
ValidAnalyzeFlowCytometryQ[
	myInputs:ListableP[ObjectP[Object[Data,FlowCytometry]]]|ObjectP[Object[Protocol,FlowCytometry]],
	myOptions:OptionsPattern[ValidAnalyzeFlowCytometryQ]
]:=Module[
	{
		listedOptions,preparedOptions,analyzeFlowCytometryTests,
		initialTestDescription,allTests,verbose,outputFormat
	},

	(* Ensure that options are provided as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output, Verbose, and OutputFormat options from provided options *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Call AnalyzeFlowCytometry with Output->Tests to get a list of EmeraldTest objects *)
	analyzeFlowCytometryTests=AnalyzeFlowCytometry[myInputs,Append[preparedOptions,Output->Tests]];

	(* Define general test description *)
	initialTestDescription="All provided inputs and options match their provided patterns (no further testing is possible if this test fails):";

	(* Make a list of all tests, including the blanket correctness check *)
	allTests=If[MatchQ[analyzeFlowCytometryTests,$Failed],
		(* Generic test that always fails if the Output->Tests output failed *)
		{Test[initialTestDescription,False,True]},
		(* Generate a list of tests, including valid object and VOQ checks *)
		Module[{validObjectBooleans,voqWarnings},
			(* Check for invalid objects *)
			validObjectBooleans=ValidObjectQ[
				DeleteCases[Cases[Flatten[{myInputs}],ObjectP[]],EmeraldCloudFileP],
				OutputFormat->Boolean
			];

			(* Return warnings for any invalid objects *)
			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[Cases[Flatten[{myInputs}],ObjectP[]],EmeraldCloudFileP],validObjectBooleans}
			];

			(* Gather all tests and warnings *)
			Cases[Flatten[{analyzeFlowCytometryTests,voqWarnings}],_EmeraldTest]
		]
	];

	(* Look up options exclusive to running tests in the validQ function *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[
		RunUnitTest[<|"ValidAnalyzeFlowCytometryQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],
		"ValidAnalyzeFlowCytometryQ"
	]
];



(* ::Subsection::Closed:: *)
(*Intermediate Clusters Caches *)


(* ::Subsubsection::Closed:: *)
(*$FlowCytometryClustersCache*)

(* Maintain a cache in the mm kernel for Flow Cytometry clustering analyses *)
If[!MemberQ[$Memoization,$FlowCytometryClustersCache],
	AppendTo[$Memoization,$FlowCytometryClustersCache]
];

(* Helper function to retrieve from cache *)
downloadFromFlowCytometryCache[objref_]:=With[
	{cacheResult=$FlowCytometryClustersCache[objref]},
	If[MatchQ[cacheResult,_Association],
		cacheResult,
		(* Update the cache *)
		$FlowCytometryClustersCache[objref]=Download[objref]
	]
];



(* ::Subsection::Closed:: *)
(*Testing Helper Functions*)


(* ::Subsubsection::Closed:: *)
(*makeTestFlowCytometryDataPacket*)

(* Make a Gaussian-distributed flow cytometry packet with nPoints points, nChannelsx3 dimensions, and nClusters split clusters *)
makeTestFlowCytometryDataPacket[nPoints_,nChannels_,nClusters_,name_]:=Module[
	{offsetDims,mixModel,randomData,channelsToUse,dataArrays,primaryDetectorData,secondaryDetectorData},

	(* Pick the first nClusters dimensions from nChannels to offset clusters in *)
	offsetDims=Range[nClusters];

	(* Define a mixture of nClusters Gaussians to emulate clusters *)
	mixModel=MixtureDistribution[
		Repeat[1,nClusters],
		Map[
			MultinormalDistribution[
				Repeat[10.0,nChannels]+RandomReal[{2.0,4.0}]*ReplacePart[Repeat[0.0,nChannels],#->1.0],
				0.9*IdentityMatrix[nChannels]
			]&,
			offsetDims
		]
	];

	(* Sample nPoints from this distribution to create test data *)
	randomData=RandomVariate[mixModel,nPoints];

	(* The first 3 FS/SS channels should always be present; randomly select the others to fill in *)
	(* At time of writing this test function, there are 30 possible detectors *)
	channelsToUse=RandomSample[Range[4,30],nChannels-3];

	(* The first 3 detectors. Take the randomdata to be area, and add noise for the height and width *)
	primaryDetectorData=Map[
		QuantityArray[
			Transpose@{
				(Part[randomData,All,#]+RandomReal[{-2.2,2.2},nPoints])*RandomReal[{15000,20000}]*100000,
				Part[randomData,All,#]*RandomReal[{15000,20000}],
				(Part[randomData,All,#]+RandomReal[{-2.0,2.0},nPoints])*RandomReal[{15000,20000}]*0.05
			},
			{ArbitraryUnit, ArbitraryUnit Second, Second}
		]&,
		Range[3]
	];

	(* For each other channel *)
	secondaryDetectorData=Map[
		QuantityArray[
			Transpose@{
				(Part[randomData,All,#]+RandomReal[{-2.2,2.2},nPoints])*RandomReal[{100000,200000}],
				Part[randomData,All,#]*RandomReal[{15000,20000}],
				(Part[randomData,All,#]+RandomReal[{-2.0,2.0},nPoints])*RandomReal[{200,1000}]
			},
			{ArbitraryUnit, ArbitraryUnit Second, Second}
		]&,
		Range[Length[channelsToUse]]
	];

	(* Create upload rules for the data we just synthesized *)
	dataArrays=ReplaceRule[
		(* Populate all data fields *)
		(Replace[#]->Null)&/@(List@@FlowCytometryDataFieldsP),
		Join[
			{
				Replace[ForwardScatter488Excitation]->Part[primaryDetectorData,1],
				Replace[ForwardScatter405Excitation]->Part[primaryDetectorData,2],
				Replace[SideScatter488Excitation]->Part[primaryDetectorData,3]
			},
			MapThread[
				(Replace[Part[List@@FlowCytometryDataFieldsP,#1]]->#2)&,
				{channelsToUse,secondaryDetectorData}
			]
		]
	];

	(* Assemble the packet *)
	Join[
		<|
			Object->CreateID[Object[Data,FlowCytometry]],
			DeveloperObject->True,
			Volume->(40.0 Milliliter),
			Events->N[nPoints],
			CellCount->((N[nPoints]*Event)/(40.0 Milliliter)),
			Name->name
		|>,
		Association@@dataArrays
	]
];
