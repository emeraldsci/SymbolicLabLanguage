(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* AnalyzeCompensationMatrix *)


(* ::Subsection:: *)
(* Patterns *)


(* ::Subsection:: *)
(* Options *)


DefineOptions[AnalyzeCompensationMatrix,
	Options:>{
		IndexMatching[
			IndexMatchingParent->Detectors,
			{
				(* Detection Wavelength *)
				OptionName->Detectors,
				Default->Automatic,
				Description->"The detectors used to measure light scattering in the flow cytometry experiment.",
				ResolutionDescription->"Defaults to the list of detectors specified in input protocol.",
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>FlowCytometryDetectorP],
				Category->"General"
			},
			{
				(* Fluorophores *)
				OptionName->DetectionLabels,
				Default->Automatic,
				Description->"For each member of Detectors, the tag, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be analyzed by that detector.",
				ResolutionDescription->"Defaults to the detection labels specified in the input protocol.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule]]],
				Category->"General"
			},
			{
				(* Intensity value separating positive from negative control *)
				OptionName->DetectionThresholds,
				Default->Automatic,
				Description->"For each member of Detectors, the intensity threshold (in units of ArbitraryUnit*Second) which separates positive adjustment samples from the negative control.",
				ResolutionDescription->"If no unstained samples are used, default threshold is set using Kittler-Illingworth minimum error thresholding. Otherwise, thresholds resolve to Null.",
				AllowNull->True,
				Widget->Widget[Type->Number, Pattern:>GreaterEqualP[0.0]],
				Category->"General"
			}
		],
		AnalysisPreviewSymbolOption,
    AnalysisTemplateOption,
    OutputOption,
    UploadOption
  }
];



(* ::Subsection::Closed:: *)
(*Messages and Errors*)

(* ---------------------------- *)
(* --- MESSAGES AND ERRORS  --- *)
(* ---------------------------- *)

Error::DetectorsNotInProtocol="The detectors `1` in the Detectors option could not be matched to the detectors `2` used in the input protocol. Please remove the unmatched detectors, and only specify detectors used in the Detectors field of the input protocol.";
Error::DetectorsNotSet="The Detectors option must be specified explicitly to use option(s) `1`. Please remove the option(s) `1`, or explicitly set the Detectors option.";
Error::DuplicateDetectors="Duplicate entries found in the Detectors option `1`. Please remove duplicate entries.";
Error::EmptyPartition="The thresholds `1` at positions `2` resulted in empty partitions, i.e. no separation between positive and negative sample. Please change these thresholds or do not specify the threshold option to choose thresholds automatically.";
Error::NoCompensationSamplesFound="No compensation data could be found in input protocol `1`. Please verify that this protocol has CompensationSamplesIncluded equal to True, has Status Completed, and has one or more data objects linked in AdjustmentSampleData.";
Warning::AdjustmentDataNotFound="No compensation sample was provided for detector(s) `1` and compensation will not be computed for these detectors. If no control samples were prepared for these detectors, this warning may be safely ignored. If control samples were prepared, please ensure that the AdjustmentSamples field of input protocol is correctly linked to all samples, and that the AdjustmentSampleData field contains the corresponding data.";
Warning::UnusedThresholds="The DetectionThresholds option `1` cannot be used because input protocol has UnstainedSampleData which is being used as a global negative. The DetectionThresholds option will be ignored.";



(* ::Subsection::Closed:: *)
(*Overloads*)

(* --------------------------- *)
(* --- SECONDARY OVERLOADS --- *)
(* --------------------------- *)

(* Listable overload *)
AnalyzeCompensationMatrix[protocols:{ObjectP[Object[Protocol,FlowCytometry]]..},myOps:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,compensationMatrixResults,groupedOutputRules},

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Map AnalyzeCompensationMatrix across the lists of packets *)
	compensationMatrixResults=Map[
		AnalyzeCompensationMatrix[#,
			(* Need to use the listed form of output for combined option rules below (e.g. {Result} instead of Result) *)
			ReplaceRule[listedOptions,Output->output]
		]&,
		protocols
	];

	(* Since the AnalyzeCompensationMatrix call was mapped on lists of data, we must consolidate the options, preview, and tests for builder *)
	groupedOutputRules=MapIndexed[
		Function[{requestedOutput,idx},
			requestedOutput->Switch[requestedOutput,
				(* Extract just the results from each function call *)
				Result,If[Length[protocols]==1,
					First[Part[#,First[idx]]&/@compensationMatrixResults],
					(Part[#,First[idx]]&/@compensationMatrixResults)
				],
				(* AnalyzeCompensationMatrix resolves the same options for each function call, so we can just take the first one *)
				Options,First[Part[#,First[idx]]&/@compensationMatrixResults],
				(* Incorporate all previews into a single slide view *)
				Preview,If[Length[protocols]==1,
					First[Part[#,First[idx]]&/@compensationMatrixResults],
					SlideView[Part[#,First[idx]]&/@compensationMatrixResults]
				],
				(* Combine the lists of tests for each run *)
				Tests,Flatten[Part[#,First[idx]]&/@compensationMatrixResults]
			]
		],
		output
	];

	(* Return the requested output *)
	outputSpecification/.groupedOutputRules
];



(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* ------------------------ *)
(* --- PRIMARY OVERLOAD --- *)
(* ------------------------ *)
AnalyzeCompensationMatrix[myProtocol:ObjectP[Object[Protocol,FlowCytometry]],myOps:OptionsPattern[AnalyzeCompensationMatrix]]:=Module[
	{
		outputSpecification,output,gatherTests,listedOptions,standardFieldsStart,
		compensationQ,compensationQTests,detectors,detectionlabels,samples,unstainedSample,
		adjustmentDataPackets,unstainedDataPackets,optionResTest,
		safeOptions,safeOptionsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,combinedOptions,expandedInputs,expandedOptions,
		mostlyResolvedOptions,dataRules,matchedPackets,unstainedData,resolvedOptions,
		collapsedOptions,compensationMatrix,
		analysisPacket,uploadResult,resultRule,previewRule
	},

	(* Check for temporal links *)
	checkTemporalLinks[myProtocol,myOps];

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Ensure that options are in a list *)
	listedOptions=ToList[myOps];

	(* Populate standard fields for constructing analysis object packets later *)
	standardFieldsStart=analysisPacketStandardFieldsStart[listedOptions];

	(* Batch download fields required for the analysis *)
	{
		compensationQ,
		detectors,
		detectionLabels,
		samples,
		unstainedSample,
		adjustmentDataPackets,
		unstainedDataPackets
	}=Download[myProtocol,
		{
			CompensationSamplesIncluded,
			Detectors,
			DetectionLabels,
			AdjustmentSamples[Object],
			UnstainedSample,
			Packet[AdjustmentSampleData[All]],
			Packet[UnstainedSampleData[All]]
		}
	];

	(* Test if CompensationSamplesIncluded was true *)
	compensationQTests={
		Test["Input protocol has CompensationSamplesIncluded of True:",compensationQ,True],
		Test["Input protocol contains at least one linked data object in AdjustmentSampleData:",MatchQ[adjustmentDataPackets,Null|{}],False]
	};

	(* Return $Failed if compensation was not included  *)
	If[!compensationQ,
		Message[Error::NoCompensationSamplesFound,myProtocol];
		Return[outputSpecification/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->compensationQTests
		}]
	];

	(* Error message if the input protocol has no adjustment data *)
	If[MatchQ[adjustmentDataPackets,Null|{}],
		Message[Error::NoCompensationSamplesFound,myProtocol];
		Return[outputSpecification/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->compensationQTests
		}]
	];

	(* Call safe options to ensure all options are populated and match patterns *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeCompensationMatrix,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeCompensationMatrix,listedOptions,AutoCorrect->False],Null}
	];

	(* Return $Failed (and tests to this point) if specified options do not match patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[compensationQTests,safeOptionsTests]
		}]
	];

	(* Verify that index-matched inputs are the correct length. *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeCompensationMatrix,{myProtocol},safeOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeCompensationMatrix,{myProtocol},safeOptions],Null}
	];

	(* If index-matched options are not matched to inputs, return $Failed. Return tests up to this point. *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->Join[compensationQTests,safeOptionsTests,validLengthTests]
		}]
	];

	(* Resolve the analysis template option *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeCompensationMatrix,{myProtocol},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeCompensationMatrix,{myProtocol},listedOptions],Null}
	];

	(* Return $Failed if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->Join[compensationQTests, safeOptionsTests, validLengthTests, templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Expand index matched options. expandedInputs is not used/needed because there is only one input. *)
	{expandedInputs,expandedOptions}=ExpandIndexMatchedInputs[AnalyzeCompensationMatrix,
		{myProtocol},
		combinedOptions
	];

	(* Resolve all options except for the thresholds *)
	mostlyResolvedOptions=resolveAnalyzeCompensationMatrixOptions[
		expandedOptions,
		detectors,
		detectionLabels
	];

	(* Option resolution test *)
	optionResTest={Test["Option resolution successful:",MatchQ[mostlyResolvedOptions,$Failed],False]};

	(* Error message if option resolution failed *)
	If[MatchQ[mostlyResolvedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->Join[compensationQTests,safeOptionsTests,validLengthTests,templateTests,optionResTest]
		}]
	];

	(* For each detector, generate a list of rules {detector->{datapts}} and update resolved options with thresholds *)
	{dataRules,matchedPackets,unstainedData,resolvedOptions}=resolveAnalyzeCompensationMatrixInput[
		adjustmentDataPackets,
		unstainedDataPackets,
		detectors,
		samples,
		mostlyResolvedOptions
	];

	(* Collapse index matched options for return *)
	collapsedOptions=CollapseIndexMatchedOptions[
		AnalyzeCompensationMatrix,
		resolvedOptions,
		Messages->False
	];

	(* Use the processed data and thresholds to build the compensation matrix *)
	compensationMatrix=buildCompensationMatrix[dataRules,unstainedData,resolvedOptions];

	(* Return fail state if partitions are empty *)
	If[MatchQ[compensationMatrix,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->Join[compensationQTests, safeOptionsTests, validLengthTests, templateTests, {Test["Thresholds result in two populations (positive and negative) for each detector:",False,True]}]
		}]
	];

	(* Assemble the analysis packet *)
	analysisPacket=assembleCompensationMatrixPacket[
		myProtocol,
		matchedPackets,
		LastOrDefault[unstainedDataPackets],
		compensationMatrix,
		standardFieldsStart,
		resolvedOptions,
		collapsedOptions
	];

	(* Upload new packet if requested, otherwise just return packet *)
	uploadResult=If[Lookup[collapsedOptions,Upload]&&MemberQ[output,Result],
		Upload[analysisPacket],
		analysisPacket
	];

	(* Upload the packets if requested, otherwise return packets *)
	resultRule=Result->If[MemberQ[output,Result],
		uploadResult,
		Null
	];

	(* Prepare the preview rule; return plot if single input, otherwise throw multiple plots into a slide view *)
	previewRule=Preview->If[MemberQ[output,Preview],
		AdjustForCCD[compensationMatrixPreviewApp[dataRules,unstainedData,resolvedOptions], AnalyzeCompensationMatrix],
		Null
	];

	(* Return the requested outputs *)
	outputSpecification/.{
		resultRule,
		previewRule,
		Options->RemoveHiddenOptions[AnalyzeCompensationMatrix,collapsedOptions],
		Tests->Join[compensationQTests,safeOptionsTests,validLengthTests,templateTests,optionResTest]
	}
];



(* ::Subsection::Closed:: *)
(*Resolution Functions*)


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCompensationMatrixOptions*)

(* Resolve compensation matrix options and check for errors *)
resolveAnalyzeCompensationMatrixOptions[expandedOps_,detectors_,detectorLabels_]:=Module[
	{
		detectorsOp,detectorLabelOp,thresholdsOp,unsetOps,
		unmatchedDetectors,resolvedDetectors,resolvedLabels
	},

	(* Look up original values of options which need further resolution *)
	{detectorsOp,detectorLabelOp,thresholdsOp}=Lookup[expandedOps,
		{
			Detectors,
			DetectionLabels,
			DetectionThresholds
		}
	];

	(* A mapping of each detector to its label, taken from the input protocol *)
	detectorsToLabels=Thread[detectors->detectorLabels];

	(* Resolve the detectors option *)
	resolvedDetectors=detectorsOp/.{
		{Automatic..}->detectors,
		Automatic->detectors
	};

	(* If the detector option is Automatic, then DetectionLabels and DetectionThresholds must be Automatic *)
	unsetOps=If[MatchQ[detectorsOp,ListableP[Automatic]],
		{
			If[!MatchQ[detectorLabelOp,ListableP[Automatic]],DetectionLabels,Nothing],
			If[(Length[ToList[thresholdsOp]]==Length[resolvedDetectors])||MatchQ[thresholdsOp,ListableP[Automatic]],
				Nothing,
				DetectionThresholds
			]
		},
		{}
	];

	(* Error message for this case *)
	If[Length[unsetOps]>0,
		Message[Error::DetectorsNotSet,unsetOps];
		Return[$Failed];
	];


	(* All resolved detectors must be present in the detectors list of the protocol*)
	unmatchedDetectors=Complement[resolvedDetectors,detectors];

	(* Throw an error if any detectors can't be matched to the protocol *)
	If[Length[unmatchedDetectors]>0,
		Message[Error::DetectorsNotInProtocol,unmatchedDetectors,detectors];
		Return[$Failed];
	];

	(* No duplicates in Detectors*)
	If[!DuplicateFreeQ[resolvedDetectors],
		Message[Error::DuplicateDetectors,resolvedDetectors];
		Return[$Failed];
	];

	(* Detection labels resolve to Null if not specified *)
	resolvedLabels=detectorLabelOp/.{
		ListableP[Automatic]->(resolvedDetectors/.detectorsToLabels)
	};

	(* Return the mostly resolved options *)
	ReplaceRule[expandedOps,{
		Detectors->resolvedDetectors,
		DetectionLabels->resolvedLabels
	}]
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCompensationMatrixInputs*)

(* For each detector, match available compensation data, extract data arrays, and compute thresholds *)
resolveAnalyzeCompensationMatrixInput[dataPackets_,unstainedDataPackets_,detectors_,samples_,mostOps_]:=Module[
	{
		sampleToPacketRules,detectorToSampleRules,detectorToPacketRules,
		myDetectors,myThresholds,myPackets,resolvedData,detectorsMissingData,
		unstainedPacket,unstainedData,calculatedThresholds,resolvedThresholds
	},

	(* We need to match data packets to samples, so generate sample->packet rules *)
	sampleToPacketRules=Map[
		(First[Lookup[#,SamplesIn]][Object]->#)&,
		dataPackets
	];

	(* Generate detector to sample rules as well *)
	detectorToSampleRules=Rule@@@Transpose[{detectors,samples}];

	(* Use rulesets to match detectors to data packets *)
	detectorToPacketRules=Map[
		(First[#]->(Last[#]/.sampleToPacketRules))&,
		detectorToSampleRules
	];

	(* Detectors and thresholds from resolved options *)
	{myDetectors,myThresholds}=Lookup[mostOps,{Detectors,DetectionThresholds}];

	(* Data packets associated with resolved detectors *)
	myPackets=Lookup[detectorToPacketRules,myDetectors,Null];

	(* For each detector, resolve data as a list of {x1,x2,...} data points, where x's are ordered by detectors *)
	resolvedData=MapThread[
		#1->extractDataFromPacket[myDetectors,#2]&,
		{myDetectors,myPackets}
	];

	(* List of detectors which no data could be resolved for *)
	detectorsMissingData=First/@Select[resolvedData,Last[#]==Null&];

	(* Warn user if detectors are missing data *)
	If[Length[detectorsMissingData]>0,
		Message[Warning::AdjustmentDataNotFound,detectorsMissingData];
	];

	(* Unstained data is Null if not present, otherwise the most recent packet *)
	unstainedPacket=LastOrDefault[unstainedDataPackets,Null];

	(* Rule mapping unstained reference to extracted data *)
	unstainedData=If[MatchQ[unstainedPacket,Null],
		Null,
		extractDataFromPacket[myDetectors,unstainedPacket]
	];

	(* Using the resolved data, compute thresholds for each using FindThreshold. Null if there is unstained data *)
	calculatedThresholds=If[MatchQ[unstainedData,Null],
		MapIndexed[
			If[MatchQ[#1,Null],
				Null,
				(* Averaging thresholds for the pos and neg data is equivalent to re=normalizing its mean to zero *)
				Mean[{
					FindThreshold[
						Unitless[Part[#1,All,First[#2]],Second*ArbitraryUnit],
						Method->"MinimumError"
					],
					-FindThreshold[
						-Unitless[Part[#1,All,First[#2]],Second*ArbitraryUnit],
						Method->"MinimumError"
					]
				}]
			]&,
			Last/@resolvedData
		],
		Null
	];

	(* Replace the automatic threshold value with *)
	resolvedThresholds=If[MatchQ[unstainedData,Null],
		Map[
			If[MatchQ[#,Null],
				Null,
				Round[#,0.001]
			]&,
			Lookup[mostOps,DetectionThresholds]/.{{Automatic..}->calculatedThresholds,Automatic->calculatedThresholds}
		],
		Null
	];

	(* Warning message if thresholds would be ignored *)
	If[!MatchQ[unstainedData,Null]&&MatchQ[Lookup[mostOps,DetectionThresholds],ListableP[UnitsP[]]],
		Message[Warning::UnusedThresholds,Lookup[mostOps,DetectionThresholds]]
	];

	(* Return the resolved data and options updated with resolved thresholds *)
	{
		resolvedData,
		detectorToPacketRules,
		unstainedData,
		ReplaceRule[mostOps,DetectionThresholds->resolvedThresholds]
	}
];


(* ::Subsubsection::Closed:: *)
(*extractDataFromPacket*)

(* Given a list of detectors and a flow cytometry data packet, extract data points in those detectors *)
extractDataFromPacket[detectors_,pkt_Association]:=Module[
	{detectorFields,rawDataArrays,areaDataPerDetector},

	(* Map detector names to detector fields *)
	detectorFields=Lookup[flowCytometryDetectorToField,detectors,Null];

	(* Pull data from these fields of the data packet *)
	rawDataArrays=Lookup[pkt,detectorFields,{}];

	(* Extract area data only from each detector field *)
	areaDataPerDetector=N[Part[#,All,2]]&/@rawDataArrays;

	(* Transpose the data into a list of multi-dimensional data points*)
	Transpose[areaDataPerDetector]
];

(* If the packet is null, return Null *)
extractDataFromPacket[detectors_,pkt:Null]:=Null;


(* ::Subsubsection::Closed:: *)
(*assembleCompensationMatrixPacket*)

(* Given a compensation matrix and resolved options, construct the analysis packet *)
assembleCompensationMatrixPacket[protocol_,packetRules_,unstainedPkt_,matrix_,standardFields_,resolvedOps_,collapsedOps_]:=Module[
	{protocolRef,unstainedDataLink,adjustmentDataLinks,myDetectors,myLabelLinks,myThresholds},

	(* Protocol reference *)
	protocolRef=Download[protocol,Object];

	(* Link to unstained data if it was provided *)
	unstainedDataLink=If[MatchQ[unstainedPkt,Null],
		Null,
		Link[Lookup[unstainedPkt,Object]]
	];

	(* Resolved detectors *)
	myDetectors=Lookup[resolvedOps,Detectors];

	(* For each detector, link to *)
	adjustmentDataLinks=Map[
		If[MatchQ[#,Null],
			Null,
			Link[Lookup[#,Object]]
		]&,
		Lookup[packetRules,myDetectors,Null]
	];

	(* Links to the detection labels *)
	myLabelLinks=Map[
		If[MatchQ[#,Null],
			Null,
			Link[#]
		]&,
		Lookup[resolvedOps,DetectionLabels]
	];

	(* Resolved thresholds *)
	myThresholds=Lookup[resolvedOps,DetectionThresholds]/.{
		num:NumericP:>(num*Second*ArbitraryUnit)
	};

	(* Build the packet *)
	Association@@Join[
		{
			Type->Object[Analysis,CompensationMatrix],
			Replace[Reference]->Link[protocolRef,CompensationMatrixAnalyses],
			ResolvedOptions->collapsedOps,
			CompensationMatrix->matrix,
			Replace[Detectors]->myDetectors,
			Replace[DetectionLabels]->myLabelLinks,
			Replace[DetectionThresholds]->myThresholds,
			Replace[AdjustmentSampleData]->adjustmentDataLinks,
			Replace[UnstainedSampleData]->unstainedDataLink
		},
		standardFields
	]
];



(* ::Subsection::Closed:: *)
(* Helper Functions *)

(* Given rules mapping detectors->datapoints and resolved options, construct the compensation matrix *)
buildCompensationMatrix[dataRules_,unstainedData_,resolvedOps_]:=Module[
	{commonNegativeQ,ndim,thresholds,partitionedData,partitionMeans,spilloverMatrix},

	(* If unstained data is not Null, then we are using a common negative and thresholds are not needed *)
	commonNegativeQ=!MatchQ[unstainedData,Null];

	(* Dimensionality of compensation matrix, i.e. length of detectors field *)
	ndim=Length[dataRules];

	(* Retrieve resolved thresholds from options *)
	thresholds=Lookup[resolvedOps,DetectionThresholds]/.{
		Automatic|Null->Repeat[Null,ndim]
	};

	(* Partition the data in each detector by threshold. Order is {positive,negative} *)
	partitionedData=MapThread[
		Function[{labelData,cutoff,idx},
			If[MatchQ[Last[labelData],Null],
				Null,
				If[commonNegativeQ,
					(* If using a common negative, no thresholding is needed *)
					{
						Last[labelData],
						unstainedData
					},
					(* Each adjustment sample has a positive and negative; use thresholds *)
					GatherBy[
						Last[labelData],
						(Unitless[Part[#,idx],Second*ArbitraryUnit]<=cutoff)&
					]
				]
			]
		],
		{dataRules,thresholds,Range[ndim]}
	];

	(* Find the mean of each positive and negative partition *)
	partitionMeans=Map[
		If[MatchQ[#,Null],
			Null,
			Mean/@Unitless[#,Second*ArbitraryUnit]
		]&,
		partitionedData
	];

	(* If we didn't get positive/negative separation in each, return with an error *)
	If[!MatchQ[Length/@(partitionMeans/.{Null->{1,1}}),{2..}],
		With[{badIndices=Flatten@Position[Length/@(partitionMeans/.{Null->{1,1}}),Except[2],{1},Heads->False]},
			Message[Error::EmptyPartition,Part[thresholds,badIndices],badIndices];
		];
		Return[$Failed];
	];

	(* Calculate the spillover matrix by taking pairwise distance between positive/negative partitions and normalizing by dimension *)
	spilloverMatrix=MapIndexed[
		Function[{twoMeans,idx},
			If[MatchQ[twoMeans,Null],
				(* If no compensation standard, then no compensation, i.e. identity vector *)
				UnitVector[ndim,First[idx]],
				(* Otherwise, use the absolute difference between means, normalized by dimension *)
				(First[twoMeans]-Last[twoMeans])/Part[(First[twoMeans]-Last[twoMeans]),First[idx]]
			]
		],
		partitionMeans
	];

	(* Need to transpose the spillover matrix to get the right dimensions for the output compensation matrix *)
	Inverse[Transpose@spilloverMatrix]
];



(* ::Subsection::Closed:: *)
(*Testing Helper Functions*)


(* ::Subsubsection::Closed:: *)
(*makeCompensationMatrixTestProtocol*)

(* Create a flow cytometry protocol with adjustment/compensation data for n detectors and nPoints *)
makeCompensationMatrixTestProtocol[nDetectors_, nSamples_, nPoints_, universalNegativeQ:True|False, name_]:=Module[
	{
		testDetectors,testDetectorFields,adjustmentSamples,unstainedSample,
		unstainedDataFields,adjustmentDataFields,unstainedData,adjustmentData,
		protocolPacket
	},

	(* Pick a random selection of detectors *)
	testDetectors=Part[List@@FlowCytometryDetectorP,1;;nDetectors];

	(* Get the field names for these detectors *)
	testDetectorFields=testDetectors/.flowCytometryDetectorToField;

	(* Generate packets for the adjustment samples *)
	adjustmentSamples=Map[
		<|
			Object->CreateID[Object[Sample]],
			Name->(name<>" AdjustmentSample "<>ToString[#]),
			DeveloperObject->True
		|>&,
		Range[nSamples]
	];

	(* Generate an unstained sample if we are using a universal negative *)
	unstainedSample=If[universalNegativeQ,
		<|
			Object->CreateID[Object[Sample]],
			Name->(name<>" UnstainedSample"),
			DeveloperObject->True
		|>,
		Nothing
	];

	(* Generate unstained test data, abs value of a near-zero Gaussian with small variance *)
	unstainedDataFields=If[universalNegativeQ,
		Map[
			Function[{field},
				field->QuantityArray[
					Transpose@Repeat[Abs[RandomVariate[NormalDistribution[0.0,0.01],nPoints]],3],
					{ArbitraryUnit,ArbitraryUnit*Second,Second}
				]
			],
			testDetectorFields
		],
		Null
	];

	(* Create adjustment data for each adjustment sample *)
	adjustmentDataFields=If[universalNegativeQ,
		(* can just make a bunch of gaussians without worrying about covariance if every sample is positive  *)
		Map[
			Function[{n},
				Map[
					#->QuantityArray[
						Transpose@Repeat[
							Abs[RandomVariate[
								(* Single Gaussian at 10.0 for on-signal, random between 0.3 to 0.5 if not *)
								NormalDistribution[If[#===Part[testDetectorFields,n],1.0,RandomReal[{0.05,0.15}]],0.01],
								nPoints
							]],
							3
						],
						{ArbitraryUnit,ArbitraryUnit*Second,Second}
					]&,
					testDetectorFields
				]
			],
			Range[nSamples]
		],
		(* if we have positives and negatives in each sample, we need the populations to correlate *)
		Map[
			Function[{n},Module[
				{positiveMean,negativeMean,variance,positiveSamples,negativeSamples,allSamples},
				(*Means for positive and negative test distributions *)
				positiveMean=If[#==n,1.0,RandomReal[{0.05,0.15}]]&/@Range[nDetectors];
				negativeMean=Repeat[0.0,nDetectors];
				(* Use a symetric covariance matrix *)
				variance=0.01*IdentityMatrix[nDetectors];
				(* Random samples *)
				positiveSamples=Abs@RandomVariate[MultinormalDistribution[positiveMean,variance],Round[nPoints*0.7]];
				negativeSamples=Abs@RandomVariate[MultinormalDistribution[negativeMean,variance],Round[nPoints*0.3]];
				allSamples=Join[positiveSamples,negativeSamples];
				(* Map to get rules *)
				MapIndexed[
					#1->QuantityArray[
						Transpose@Repeat[Part[allSamples,All,First[#2]],3],
						{ArbitraryUnit,ArbitraryUnit*Second,Second}
					]&,
					testDetectorFields
				]
			]],
			Range[nSamples]
		]
	];

	(* Create the unstained data object packet if needed *)
	unstainedData=If[universalNegativeQ,
		Join[
			<|
				Object->CreateID[Object[Data,FlowCytometry]],
				Name->(name<>" UnstainedData"),
				Replace[SamplesIn]->Link[Lookup[unstainedSample,Object],Data],
				DeveloperObject->True
			|>,
			Association@@unstainedDataFields
		],
		Nothing
	];

	(* Create adjustment data packets *)
	adjustmentData=MapThread[
		Function[{samplePacket,dfields,idx},
			Join[
				<|
					Object->CreateID[Object[Data,FlowCytometry]],
					Name->(name<>" AdjustmentData "<>ToString[idx]),
					Replace[SamplesIn]->Link[Lookup[samplePacket,Object],Data],
					DeveloperObject->True
				|>,
				Association@@dfields
			]
		],
		{adjustmentSamples,adjustmentDataFields,Range[nSamples]}
	];

	(* Create the protocol packet *)
	protocolPacket=<|
		Type->Object[Protocol,FlowCytometry],
		Name->(name<>" Protocol"),
		CompensationSamplesIncluded->True,
		DeveloperObject->True,
		Replace[Detectors]->testDetectors,
		Replace[DetectionLabels]->Repeat[Null,nDetectors],
		Replace[AdjustmentSamples]->PadRight[Link/@Lookup[adjustmentSamples,Object],nDetectors,Null],
		UnstainedSample->If[universalNegativeQ,Link[Lookup[unstainedSample,Object]],Null],
		Replace[UnstainedSampleData]->{If[universalNegativeQ,Link[Lookup[unstainedData,Object]],Null]},
		Replace[AdjustmentSampleData]->Link/@Lookup[adjustmentData,Object]
	|>;

	(* Upload all the packets and return the protocol object reference *)
	Last@Upload[Flatten[{
		adjustmentSamples,
		unstainedSample,
		unstainedData,
		adjustmentData,
		protocolPacket
	}]]
];



(* ------------------- *)
(* --- PREVIEW APP --- *)
(* ------------------- *)

(* ::Section::Closed:: *)
(*Resolution Functions*)


(* ::Subsection::Closed:: *)
(*compensationMatrixPreviewApp*)

(* Use resolved inputs and options to generate a preview  *)
compensationMatrixPreviewApp[dataRules_, unstainedData_, resolvedOps_]:=Module[
	{showThresholdsQ,dataPerDetector,detectors,thresholds,partitionedDataPerDetector,dv,app,panelWidth=1000,panelHeight=650},

	(* True if thresholds should be shown, False if an unstained global negative was provided *)
	showThresholdsQ=MatchQ[unstainedData,Null];

	(* Get only data from the detector each sample is meant to provide compensation for *)
	(* E.g. given compensation data for the 488 FSC channel, extract only data from that channel (and not spillover into other channels) *)
	dataPerDetector=MapIndexed[
		(First[#1]->Unitless[Part[Last[#1],All,First[#2]],Second*ArbitraryUnit])&,
		dataRules
	];

	(* Mapping of detector to corresponding channel of the unstained global negative  *)
	unstainedPerDetector=If[showThresholdsQ,
		{},
		MapIndexed[
			(#1->Unitless[Part[unstainedData,All,First[#2]],Second*ArbitraryUnit])&,
			First/@dataRules
		]
	];

	(* Detectors from resolved options *)
	detectors=Lookup[resolvedOps,Detectors];

	(* Thresholds option *)
	thresholds=Unitless[Lookup[resolvedOps,DetectionThresholds]];

	(* Partitioned data (pos and neg) per dimension *)
	partitionedDataPerDetector=If[showThresholdsQ,
		(* If we are thresholding, partition the data *)
		MapThread[
			#1->{
				Select[Lookup[dataPerDetector,#1],Function[{x},x<=#2]],
				Select[Lookup[dataPerDetector,#1],Function[{x},x>#2]]
			}&,
			{detectors,thresholds}
		],
		(* If we have a universal negative, clusters are set already *)
		Map[
			#->{
				Lookup[unstainedPerDetector,#],
				Lookup[dataPerDetector,#]
			}&,
			detectors
		]
	];

	(* Set up a preview symbol *)
	dv=SetupPreviewSymbol[
		AnalyzeCompensationMatrix,
		Null,
		{DetectionThresholds->Lookup[resolvedOps,DetectionThresholds]},
		PreviewSymbol->Lookup[resolvedOps,PreviewSymbol]
	];

	(* Build the preview app based on if thresholds can be set  *)
	app=If[showThresholdsQ,
		buildDynamicCompensationMatrixApp[dataPerDetector,partitionedDataPerDetector,thresholds,dv],
		buildStaticCompensationMatrixApp[partitionedDataPerDetector,dv]
	];

	(* Return the app. Pane is used to include scrollbars in the preview if the app size changes *)
	Pane[
		app,
		ImageSize->{UpTo[panelWidth],UpTo[panelHeight]},
		Alignment->Center
	]
];


(* If each adjustment sample contains both positive/negative samples, then app sets thresholds *)
buildDynamicCompensationMatrixApp[allData_,splitData_,thresholds_,dvar_]:=With[
	(* these things are static *)
	{
		(* Pull out detector names and data points from all data *)
		detectors=First/@allData,
		dataPts=Last/@allData	
	},

	DynamicModule[{
		(* Locator pane points *)
		pts={First[thresholds],0},

	(* Gates controls which data falls into which group *)
		gates=thresholds,

		(* Index of the current detector *)
		idx=1,
		(* For neater code *)
		tabContents
		},

	(* Generate the contents of the TabView *)
	tabContents=MapThread[
		Function[{det,currIdx},
			{
				currIdx,
				(* Enclosing LocatorPane for interactivity *)
				det->LocatorPane[
					(* Pane updates points *)
					Dynamic[pts,{
						(* Before *)
						None,
						(* During *)
						(pts=#;gates[[currIdx]]=First[pts])&,
						(* After *)
						LogPreviewChanges[dvar,{DetectionThresholds->(Round[gates,0.001])}]&
					}],

					(* Grid contains preview graphic *)
					Grid[{
						(* Generate dynamic histogram which interactive threshold *)
						{
							Dynamic[
								(* If dvar is changed, then update gates *)
								gates=PreviewValue[dvar,DetectionThresholds];

								Dynamic[
									(* Histogram is faster than EmeraldHistogram *)
									Histogram[
										(* Partition datapoints based on gates *)
										ReverseSortBy[GatherBy[Part[dataPts,currIdx],(#>Part[gates,currIdx])&],First],
										25,
										PassOptions[
											EmeraldHistogram,
											Histogram,
											{
												Frame->{True,True,False,False},
												FrameLabel->{{"Count",Automatic},{"Event Peak Area",Automatic}},
												PlotLabel->(Part[detectors,currIdx]/.flowCytometryDetectorLabelRules)<>" Positive and Negative Control",
												GridLines->{{Part[gates,currIdx]},{}},
												GridLinesStyle->Directive[Thick,Dashed,Gray],
												Method->{"GridLinesInFront"->True}
											}
										]
									],
									TrackedSymbols:>{gates}
								],
								TrackedSymbols:>{dvar}
							]
						},
						(* The legend takes a while to draw so render it separately for performance *)
						{
							SwatchLegend[
								{ColorData[97][1], ColorData[97][2]},
								{"Negative  ","Positive"},
								LegendLayout->"Row",
								LabelStyle->{14,Bold,FontFamily->"Arial"}
							]
						}
					}],
					Enabled->True,
					Appearance->None
				]
			}
		],
		{detectors,Range[Length[detectors]]}
	];

	(* Construct the TabView to select between detectors *)
	TabView[
		tabContents,
		Dynamic[idx],
		ControlPlacement->Left
	]
]];


(* If a universal negative was used, thresholds cannot be set so we should just generate a tab-view showing separations *)
buildStaticCompensationMatrixApp[splitDataPerDetector_,dvar_]:=DynamicModule[
	{histogramRules},

	(* Rules mapping detectors to histogram graphics *)
	histogramRules=Map[
		First[#]->EmeraldHistogram[
			Last[#],
			25,
			PlotLabel->(First[#]/.flowCytometryDetectorLabelRules)<>" Positive and Negative Control",
			FrameLabel->{{"Count",Automatic},{"Event Peak Area",Automatic}},
			Legend->{"Unstained (Negative)  ","Adjustment Sample (Positive)"},
			LegendPlacement->Bottom
		]&,
		splitDataPerDetector
	];

	(* Generate a tab view showing each detector *)
	TabView[
		histogramRules,
		ControlPlacement->Left
	]
];

(* DetectorLabelRules for nice plot formatting *)
flowCytometryDetectorLabelRules={
	"488 FSC"->"488 ForwardScatter",
	"405 FSC"->"405 ForwardScatter",
	"488 SSC"->"488 SideScatter"
};



(* ------------------------ *)
(* --- SISTER FUNCTIONS --- *)
(* ------------------------ *)

(* ::Section:: *)
(*AnalyzeCompensationMatrixOptions*)

(* Options shared with parent function, with additional OutputFormat option *)
DefineOptions[AnalyzeCompensationMatrixOptions,
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
		AnalyzeCompensationMatrix
	}
];

(* Call parent function with Output->Options and format output *)
AnalyzeCompensationMatrixOptions[
	myInputs:ListableP[ObjectP[Object[Protocol,FlowCytometry]]],
	myOptions:OptionsPattern[AnalyzeCompensationMatrixOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove the OutputFormat option *)
	preparedOptions=Normal@KeyDrop[
		ReplaceRule[listedOptions,Output->Options],
		{OutputFormat}
	];

	(* Get the resolved options from AnalyzeCompensationMatrix *)
	resolvedOptions=DeleteCases[AnalyzeCompensationMatrix[myInputs,preparedOptions],(Output->_)];

	(* Return the options as a list or table, depending on the option format *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeCompensationMatrix],
		resolvedOptions
	]
];



(* ::Section:: *)
(*AnalyzeCompensationMatrixPreview*)

(* Options shared with parent function *)
DefineOptions[AnalyzeCompensationMatrixPreview,
	SharedOptions:>{
		AnalyzeCompensationMatrix
	}
];

(* Call parent function with Output->Preview *)
AnalyzeCompensationMatrixPreview[
	myInputs:ListableP[ObjectP[Object[Protocol,FlowCytometry]]],
	myOptions:OptionsPattern[AnalyzeCompensationMatrixPreview]
]:=Module[{listedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Call the parent function with Output->Preview *)
	AnalyzeCompensationMatrix[myInputs,ReplaceRule[listedOptions,Output->Preview]]
];



(* ::Section:: *)
(*ValidAnalyzeCompensationMatrixQ*)

(* Options shared with parent function, plus additional Verbose and OutputFormat options *)
DefineOptions[ValidAnalyzeCompensationMatrixQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{
		AnalyzeCompensationMatrix
	}
];

(* Use OutputFormat->Tests to determine if parent function call is valid, +format the output *)
ValidAnalyzeCompensationMatrixQ[
	myInputs:ListableP[ObjectP[Object[Protocol,FlowCytometry]]],
	myOptions:OptionsPattern[ValidAnalyzeCompensationMatrixQ]
]:=Module[
	{
		listedOptions,preparedOptions,analyzeCompensationMatrixTests,
		initialTestDescription,allTests,verbose,outputFormat
	},

	(* Ensure that options are provided as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output, Verbose, and OutputFormat options from provided options *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Call AnalyzeCompensationMatrix with Output->Tests to get a list of EmeraldTest objects *)
	analyzeCompensationMatrixTests=AnalyzeCompensationMatrix[myInputs,Append[preparedOptions,Output->Tests]];

	(* Define general test description *)
	initialTestDescription="All provided inputs and options match their provided patterns (no further testing is possible if this test fails):";

	(* Make a list of all tests, including the blanket correctness check *)
	allTests=If[MatchQ[analyzeCompensationMatrixTests,$Failed],
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
			Cases[Flatten[{analyzeCompensationMatrixTests,voqWarnings}],_EmeraldTest]
		]
	];

	(* Look up options exclusive to running tests in the validQ function *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[
		RunUnitTest[<|"ValidAnalyzeCompensationMatrixQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],
		"ValidAnalyzeCompensationMatrixQ"
	]
];
