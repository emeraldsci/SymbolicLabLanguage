(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* AnalyzeDNASequencing *)


(* ::Subsection:: *)
(* Patterns *)


(* Custom Patterns *)
DNASequenceP=_?(ValidSequenceQ[#,Polymer->DNA]&);
analyzeDNASequencingInputP=Alternatives[
	ListableP[ObjectP[Object[Protocol,DNASequencing]]],
	ListableP[ObjectP[Object[Data,DNASequencing]]],
	{Repeated[(CoordinatesP|QuantityCoordinatesP[]),4]}
];


(* ::Subsection:: *)
(* Options *)


DefineOptions[AnalyzeDNASequencing,
	Options:>{
		{
			OptionName->Method,
			Default->Phred,
			Description->"The base-calling algorithm to use in this sequence analysis.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Phred,BayesCall]],
			Category->"Assignment"
		},
		{
			OptionName->MixedBases,
			Default->Automatic,
			Description->"Indicates if secondary peaks should be treated as mixed bases. Choose True if samples are PCR amplicons, or False if samples are plasmid templates.",
			ResolutionDescription->"Automatic defaults to True if the selected Method supports mixed bases, and False otherwise.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Hidden"
		},
		{
			OptionName->MixedBasesThreshold,
			Default->Automatic,
			Description->"The ratio of secondary peak height to primary peak height above which secondary peaks will be treated as mixed bases.",
			ResolutionDescription->"When MixedBases is True, Automatic defaults to 25, otherwise Automatic defaults to Null.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Percent,100 Percent],Units->Percent],
			Category->"Hidden"
		},
		{
			OptionName->UnassignedBases,
			Default->True,
			Description->"If there are ambiguous bases in the sequence, assign the letter N to those bases based on a quality value threshold.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Assignment"
		},
		{
			OptionName->UnassignedBasesThreshold,
			Default->Automatic,
			Description->"Base assignments with quality value at or below this threshold will be considered ambigious and be assigned the letter N.",
			ResolutionDescription->"When UnassignedBases is True, Automatic defaults to 5, otherwise Automatic defaults to Null.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[0,100]],
			Category->"Assignment"
		},
		{
			OptionName->Trimming,
			Default->None,
			Description->"Indicate whether one or both ends of the assigned sequence should be trimmed according to the TrimmingMethod option.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Start|End|Both|None]],
			Category->"Trimming"
		},
		{
			OptionName->TrimmingMethod,
			Default->Automatic,
			Description->"Specify how the DNA sequence assignment should be trimmed. The sequence can be trimmed at the location of the PCR primer, by a set number of bases, by the indices of bases in the assigned sequence, or after a set number of unassignable bases.",
			ResolutionDescription->"Automatic resolves to BaseIndices if Trimming is Start, End or Both, and resolves to Null if Trimming is None.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[BaseIndices,PrimerTerminus,NumberOfBases,UnassignableBases,Window]],
			Category->"Trimming"
		},
		{
			OptionName->TrimBeforeIndex,
			Default->Automatic,
			Description->"Assigned bases with indices less than this index will be trimmed.",
			ResolutionDescription->"Automatic resolves to 1 (no trimming) if Trimming is Start|Both and TrimmingMethod is set to BaseIndices, and Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
			Category->"Trimming"
		},
		{
			OptionName->TrimAfterIndex,
			Default->Automatic,
			Description->"Assigned bases with indices greater than this index will be trimmed.",
			ResolutionDescription->"Automatic resolves to the length of the assigned sequence (no trimming) if Trimming is After|Both and TrimmingMethod is set to BaseIndices, and Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
			Category->"Trimming"
		},
		{
			OptionName->TerminationSequence,
			Default->Automatic,
			Description->"Specify a DNA sequence, such as a PCR primer, after which the sequence assignment should be trimmed.",
			ResolutionDescription->"Automatic defaults to the PCR primer sequence if TrimmingMethod is set to PrimerTerminus, and Null otherwise.",
			AllowNull->True,
			Widget->Adder[
				Alternatives[
					Widget[Type->Expression,Pattern:>StrandP|DNASequenceP,Size->Line],
					"Enter String"->Widget[Type->String,Pattern:>DNASequenceP,Size->Line]
				]
			],
			Category->"Trimming"
		},
		{
			OptionName->TerminationNumberOfBases,
			Default->Automatic,
			Description->"The number of bases after which base assignment should stop. Assigned bases after this cutoff will be trimmed. Only compatible with Trimming->End.",
			ResolutionDescription->"Automatically defaults to 1000 if TrimmingMethod is set to NumberOfBases, and Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
			Category->"Trimming"
		},
		{
			OptionName->TotalUnassignableBases,
			Default->Automatic,
			Description->"The number of unassignable bases after which the sequence will be trimmed. The trimmed sequence is guaranteed to have no more than this number of unassigned bases.",
			ResolutionDescription->"Automatically defaults to 10 if EndBaseAssignment is set to UnassignableBases, and Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[0,1000,1]],
			Category->"Trimming"
		},
   	{
			OptionName->WindowSize,
			Default->Automatic,
			Description->"The number of contiguous bases to check in each window for trimming.",
			ResolutionDescription->"Automatically defaults to 20 if TrimmingMethod is set to Window, and Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[2,10000,1]],
			Category->"Trimming"
		},
		{
			OptionName->WindowUnassignablePercentage,
			Default->Automatic,
			Description->"The percentage of unassignable bases in a contiguous window above which trimming will occur. The trimmed sequence is guaranteed to contain no runs of WindowSize contiguous bases with a percentage of unassignable bases greater than this threshold.",
			ResolutionDescription->"Automatically defaults to 50 Percent if TrimmingMethod is set to Window, and Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Percent,100 Percent],Units->Percent],
			Category->"Trimming"
		},
    OutputOption,
    UploadOption,
    AnalysisTemplateOption
  }
];

(* ::Subsection::Closed:: *)
(*Messages and Errors*)

(* ---------------------------- *)
(* --- MESSAGES AND ERRORS  --- *)
(* ---------------------------- *)
Warning::IncompatibleTrimmingOptions="The trimming options `1` are incompatible with the TrimmingMethod `2` and will be ignored. Please remove these options, or change the TrimmingMethod.";
Warning::InvalidTrimRange="The provided TrimAfterIndex (`2`) must be greater than or equal to the provided TrimBeforeIndex (`1`). Please specify a valid trimming range.";
Warning::InvalidWindowSize="The provided WindowSize (`1`) must be 2 or greater and less than the length of the sequence. Please specify a WindowSize in the range {2,`2`}.";
Warning::MixedBasesUnsupported="The requested Method `1` does not support assignment of MixedBases. Please set MixedBases to False, or choose a Method that supports mixed base assignments (`2`).";
Warning::PrimersNotFound="No PCR primers could be resolved for the provided input. Please provide a TerminationSequence, or change TrimmingMethod from PrimerTerminus to another option.";
Warning::TrimDirectionIncompatible="The requested Trimming direction `1` is incompatible with TrimmingMethod `2`, and results will be calculated as if Trimming->`3`. Please change the option Trimming to one of `4`, or choose a different TrimmingMethod.";
Warning::TrimImpossible="No satisfactory trimming could be found for the inputs at indices `1`. Please change the direction of the Trimming option, increase trimming thresholds, or choose a different TrimmingMethod.";
Warning::TrimmingOptionsIgnored="The trimming options `1` were specified but Trimming was either not set or set to None. Trimming options will be ignored. Please change Trimming to Start|End|Both, or remove these options.";
Warning::UnsupportedTrimmingMethod="The requested TrimmingMethod (`1`) is not supported if UnassignedBases->False. Please set UnassignableBases->True, or choose a different trimming method.";
Warning::UnsupportedUnits="Unsupported units `1` detected in input. Units will be ignored in analysis. Please ensure that input xyData is either unitless, or has units of ArbitraryUnit.";
Error::MismatchedXValues="Input(s) `1` of `2` contain mismatched x-values. Please ensure that electropherogram traces from the same sequencing experiment have the same x-values.";
Warning::TrimOutOfBounds="The provided TrimAfterIndex (`1`) is out of bound. TrimAfterIndex must be lesser than or equal to the length of analyzing sequence (`2`). Please specify a valid TrimAfterIndex value.";

(* ::Subsection::Closed:: *)
(*Overloads*)

(* --------------------------- *)
(* --- SECONDARY OVERLOADS --- *)
(* --------------------------- *)

(* Protocol Overload - download all data objects and pass on to primary overload *)
AnalyzeDNASequencing[protocols:ListableP[ObjectP[Object[Protocol,DNASequencing]]],myOps:OptionsPattern[AnalyzeDNASequencing]]:=Module[
	{outputSpecification,output,listedOptions,listedProtocols,dataPackets,sequencingResults,groupedOutputRules},

	(* Check for temporal links *)
	checkTemporalLinks[protocols,myOps];

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Convert the input to a list if it isn't already *)
	listedProtocols=ToList[protocols];

	(* First download links to all of the data objects, then download the data objects as packets *)
	dataPackets=Download[listedProtocols,Data[All]];

	(* Map AnalyzeDNASequencing across the lists of packets *)
	sequencingResults=Map[
		AnalyzeDNASequencing[#,
			(* Need to use the listed form of output for combined option rules below (e.g. {Result} instead of Result) *)
			ReplaceRule[listedOptions,Output->output]
		]&,
		dataPackets
	];

	(* Since the AnalyzeDNASequencing call was mapped on lists of data, we must consolidate the options, preview, and tests for builder *)
	groupedOutputRules=MapIndexed[
		Function[{requestedOutput,idx},
			requestedOutput->Switch[requestedOutput,
				(* Extract just the results from each function call *)
				Result,If[Length[listedProtocols]==1,
					First[Part[#,First[idx]]&/@sequencingResults],
					(Part[#,First[idx]]&/@sequencingResults)
				],
				(* AnalyzeDNASequencing resolves the same options for each function call, so we can just take the first one *)
				Options,First[Part[#,First[idx]]&/@sequencingResults],
				(* Incorporate all previews into a single slide view *)
				Preview,If[Length[listedProtocols]==1,
					First[Part[#,First[idx]]&/@sequencingResults],
					SlideView[Part[#,First[idx]]&/@sequencingResults]
				],
				(* Combine the lists of tests for each run *)
				Tests,Flatten[Part[#,First[idx]]&/@sequencingResults]
			]
		],
		output
	];

	(* Return the requested output *)
	outputSpecification/.groupedOutputRules
];


(* ObjectReference/Link overload - download list of objects into packets and pass to primary overload *)
AnalyzeDNASequencing[objs:ListableP[(ObjectReferenceP[Object[Data,DNASequencing]]|LinkP[Object[Data,DNASequencing]])],myOps:OptionsPattern[AnalyzeDNASequencing]]:=Module[
	{listedObjs,dataPackets},

	(* Check for temporal links *)
	checkTemporalLinks[objs,myOps];

	(* Convert the input into a list if it isn't already *)
	listedObjs=ToList[objs];

	(* Download as packets *)
	dataPackets=Download[listedObjs];

	(* Pass to the main AnalyzeDNASequencing function *)
	AnalyzeDNASequencing[dataPackets,myOps]
];


(* Raw data overload. Input is assunmed to be four chromatograms in order of A, C, G then T *)
AnalyzeDNASequencing[xyData:{Repeated[(CoordinatesP|QuantityCoordinatesP[]),4]},myOps:OptionsPattern[AnalyzeDNASequencing]]:=Module[
	{traceUnits,validUnitsPerTrace,unitConvertedData,dataPacket},

	(* Units for each of the four traces *)
	traceUnits=Map[
		Units[First[#]]&,
		xyData
	];

	(* True or False for each chromatogram if Units match either 1 or ArbitraryUnit *)
	validUnitsPerTrace=Map[
		MatchQ[#,{(1|1 ArbitraryUnit),(1|1 ArbitraryUnit)}]&,
		traceUnits
	];

	(* Indices of traces in xyData which have unsupported units *)
	invalidUnitsIndices=Flatten@Position[validUnitsPerTrace,False];

	(* Return a warning if the units of any of the raw inputs cannot be recognized *)
	If[!And@@(validUnitsPerTrace),
		Message[Warning::UnsupportedUnits,DeleteDuplicates[Part[traceUnits,invalidUnitsIndices]]]
	];

	(* Strip units and assign ArbitraryUnit to match the definition of ObjectP[Data,DNASequencing] *)
	unitConvertedData=Map[
		QuantityArray[#,{ArbitraryUnit,ArbitraryUnit}]&,
		xyData
	];

	(* Create a fake data packet *)
	dataPacket=<|
		Type->Object[Data, DNASequencing],
		(* Just in case this gets accidentally uploaded *)
		DeveloperObject->True,
		Channel1BaseAssignment->"A",
		Channel2BaseAssignment->"C",
		Channel3BaseAssignment->"G",
		Channel4BaseAssignment->"T",
		SequencingElectropherogramChannel1->unitConvertedData[[1]],
		SequencingElectropherogramChannel2->unitConvertedData[[2]],
		SequencingElectropherogramChannel3->unitConvertedData[[3]],
		SequencingElectropherogramChannel4->unitConvertedData[[4]]
	|>;

	(* Pass the fake data packet to the primary overload *)
	AnalyzeDNASequencing[dataPacket,myOps]
];


(* Return an empty list if an empty list was provided *)
AnalyzeDNASequencing[{},myOps:OptionsPattern[AnalyzeDNASequencing]]:={};



(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* ------------------------ *)
(* --- PRIMARY OVERLOAD --- *)
(* ------------------------ *)
AnalyzeDNASequencing[myPackets:ListableP[PacketP[Object[Data,DNASequencing]]],myOps:OptionsPattern[AnalyzeDNASequencing]]:=Module[
	{
		outputSpecification,output,gatherTests,listedInputs,listedOptions,
		templatedOptions,templateTests,combinedOptions,baseCallingResult,
		standardFieldsStart,safeOptions,safeOptionsTests,resolvedOptions,
		calledSequences,qualityVals,pkPackets,processedCalledSequences,
		qvParams,trimmedSequences,trimmedQualityVals,uploadPackets,secondaryUploadPackets,
		uploadResult,resultRule,previewPlots,previewRule
	},

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Ensure that inputs and options are in a list *)
	listedInputs=ToList[myPackets];
	listedOptions=ToList[myOps];

	(* Populate standard fields for constructing analysis object packets later *)
	standardFieldsStart=analysisPacketStandardFieldsStart[listedOptions];

	(* Resolve inputs - Extract and order the sequencing traces (A,C,G,T) from input packets *)
	orderedSequencingTraces=sortTracesStripUnits[listedInputs];

	(* Return $Failed if there were problems with extracting the input data *)
	If[MatchQ[orderedSequencingTraces,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> {}
		}]
	];

	(* Call safe options to ensure all options are populated and match patterns *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeDNASequencing,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeDNASequencing,listedOptions,AutoCorrect->False],Null}
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

	(* Use template options to get values for options that were not specified in ops *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeDNASequencing,listedInputs,listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeDNASequencing,listedInputs,listedOptions],Null}
	];

	(* Return $Failed if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Call option resolver *)
	resolvedOptions=resolveAnalyzeDNASequencingOptions[listedInputs,combinedOptions,listedOptions];

	(* Raw output of the base-calling algorithm *)
	baseCallingResult=Switch[Lookup[resolvedOptions,Method],
		(* Default is Phred *)
		Phred|_,
			(* Algorithm is time-intensive so memoize the call for option resolution in the builder *)
			Map[
				applyPhredBaseCaller[#]&,
				orderedSequencingTraces
			]
	];

	(* Apply the base-calling algorithm specified by option Method to get called peaks *)
	{calledSequences,qualityVals,pkPackets,qvParams}=If[MatchQ[baseCallingResult,{{}}],
		(* Match list structure but make these empty *)
		{{{}},{{}},{{}},{{}}},
		Transpose@baseCallingResult
	];

	(* Apply the UnassignedBases option *)
	processedCalledSequences=applyUnassignedMixedBases[calledSequences,qualityVals,orderedSequencingTraces,resolvedOptions];

	(* Trim the called sequence according to the resolved trimming options *)
	{trimmedSequences,trimmedQualityVals}=trimPredictedSequences[processedCalledSequences,qualityVals,resolvedOptions];

	(* Assemble upload packets for new Analysis objects and updating data objects *)
	{uploadPackets,secondaryUploadPackets}=Transpose@MapThread[
		constructUploadPacket[standardFieldsStart,resolvedOptions,#1,#2,#3,#4,#5,#6,#7,#8]&,
		{
			listedInputs,
			orderedSequencingTraces,
			processedCalledSequences,
			qualityVals,
			pkPackets,
			trimmedSequences,
			trimmedQualityVals,
			qvParams
		}
	];

	(* Check the Upload option to see if we should upload or not *)
	uploadResult=If[Lookup[resolvedOptions,Upload]&&MemberQ[output,Result],
		With[{allUploads=Upload[Join[uploadPackets,Flatten@secondaryUploadPackets]]},
			(* Return only the AnalyzeDNASequencing packets *)
			Part[allUploads,1;;Length[listedInputs]]/.{Upload[{$Failed..}]->{$Failed}}
		],
		uploadPackets
	];

	(* Upload the packets if requested, otherwise return packets *)
	resultRule=Result->If[MemberQ[output,Result],
		If[Length[uploadResult]===1,
			First[uploadResult],
			uploadResult
		],
		Null
	];

	(* Generate a preview plot for each analyze input packet *)
	previewPlots=If[MemberQ[output,Preview],
		MapThread[
			(* Call the undocumented overload with Analyze intermediates so we can take advantage of memoization in the builder *)
			PlotDNASequencingAnalysis[#1,#2,#3,#4]&,
			{orderedSequencingTraces,processedCalledSequences,qualityVals,trimmedSequences}
		],
		Null
	];

	(* Prepare the preview rule; return plot if single input, otherwise throw multiple plots into a slide view *)
	previewRule=Preview->If[MemberQ[output,Preview],
		If[Length[listedInputs]==1,
			First[previewPlots],
			SlideView[previewPlots]
		],
		Null
	];

	(* Return the requested outputs *)
	outputSpecification/.{
		resultRule,
		previewRule,
		Options->resolvedOptions,
		Tests->Join[safeOptionsTests,templateTests]
	}
];



(* ::Subsubsection::Closed:: *)
(*sortTracesStripUnits*)

(* Exract sequencing traces from input packets, order them alphabetically (A,C,G,T), and strip units for speed *)
sortTracesStripUnits[myPackets:{PacketP[Object[Data,DNASequencing]]..}]:=Module[
	{
		myBaseAssignments,myElectropherograms,baseToDataRules,sortedElectropherograms,
		xValsPerPacket,sameXPerPacket
	},

	(* Extract the base assigned to each channel in each input data packet *)
	myBaseAssignments=Lookup[myPackets,
		{
			Channel1BaseAssignment,
			Channel2BaseAssignment,
			Channel3BaseAssignment,
			Channel4BaseAssignment
		}
	];

	(* Extract the electropherograms for each channel, stripping units *)
	myElectropherograms=Unitless/@Lookup[myPackets,
		{
			SequencingElectropherogramChannel1,
			SequencingElectropherogramChannel2,
			SequencingElectropherogramChannel3,
			SequencingElectropherogramChannel4
		}
	];

	(* For each input packet, generate a mapping of each base to its corresponding electropherogram *)
	baseToDataRules=MapThread[
		Function[{bases,traces},
			MapThread[Rule[#1,#2]&,{bases,traces}]
		],
		{myBaseAssignments,myElectropherograms}
	];

	(* Apply the rules and sort by alphabetical order *)
	sortedElectropherograms=Map[
		{"A","C","G","T"}/.#&,
		baseToDataRules
	];

	(* {{xvals of trace 1},{xvals of trace 2},{xvals of trace 3},{xvals of trace 4}} for each input packet *)
	xValuesPerPacket=Map[
		Part[#,;;,;;,1]&,
		sortedElectropherograms
	];

	(* For each packet, True if all traces have the same xvalues *)
	sameXPerPacket=Map[
		Equal@@#&,
		xValuesPerPacket
	];

	(* Return an error if any of the input packets contain traces which do not have the same x-values/sampling points *)
	If[MemberQ[sameXPerPacket,False],
		Message[Error::MismatchedXValues,Flatten@Position[sameXPerPacket,False],Length[myPackets]];
		Return[$Failed];
	];

	(* Return the sorted electropherograms *)
	sortedElectropherograms
];



(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeDNASequencingOptions*)

(* Resolve all options which do not depend on the base identification *)
resolveAnalyzeDNASequencingOptions[
	packets:{PacketP[Object[Data,DNASequencing]]..},
	safeOps:{(_Rule|_RuleDelayed)..},
	originalOps:{(_Rule|_RuleDelayed)...}
]:=Module[
	{
		baseCallingMethod,mixedBasesMethodQ,
		resolvedMixedBasesOption,resolvedMixedBasesThreshold,mixedOptions,
		resolvedUnassignedThreshold,unassignedOptions,resolvedTerminationSequence,
		trimmingOps,unusedTrimOptionsQ,incompatibleTrimOps,originalTrimOps,
		resolvedTrimDirection,resolvedTrimMethod,resolvedTrimBeforeIndex,resolvedTrimAfterIndex,
		resolvedTerminationNumber,resolvedTotalUnassignable,resolvedTrimWindowSize,resolvedTrimWindowCutoff,
		miscOptions
	},

	(*** Method options ***)

	(* The algorithm requested for base-calling analysis *)
	baseCallingMethod=Lookup[safeOps,Method];

	(*** MixedBases options ***)

	(* True if the requested baseCallingMethod supports mixed base assignment *)
	mixedBasesMethodQ=MatchQ[baseCallingMethod,Alternatives[BayesCall]];

	(* Warn the user if MixedBases are requested but the algorithm supports it. *)
	If[!mixedBasesMethodQ&&Lookup[safeOps,MixedBases]===True,
		Message[Warning::MixedBasesUnsupported,baseCallingMethod,{BayesCall}]
	];

	(* MixedBases Automatic resolves to True if supported, False otherwise *)
	resolvedMixedBasesOption=Lookup[safeOps,MixedBases]/.{
		(Automatic|Null)->mixedBasesMethodQ
	};

	(* Threshold resolves to 25 is supported, Null otherwise *)
	resolvedMixedBasesThreshold=Lookup[safeOps,MixedBasesThreshold]/.{
		(Automatic|Null)->If[mixedBasesMethodQ,
			25,
			Null
		]
	};

	(* Collect the resolved mixed bases options *)
	mixedOptions={
		Method->baseCallingMethod,
		MixedBases->resolvedMixedBasesOption,
		MixedBasesThreshold->resolvedMixedBasesThreshold
	};

	(*** Unassigned Bases options ***)

	(* The unassigned threshold defaults to a QV of 5, or Null if unassigned bases are not requested *)
	resolvedUnassignedThreshold=Lookup[safeOps,UnassignedBasesThreshold]/.{
		(Automatic|Null)->If[Lookup[safeOps,UnassignedBases],
			5,
			Null
		]
	};

	(* Collect the resolved unassigned bases options *)
	unassignedOptions={
		UnassignedBases->Lookup[safeOps,UnassignedBases],
		UnassignedBasesThreshold->resolvedUnassignedThreshold
	};

	(*** Trimming Options ***)
	trimmingOps={
		(* TrimmingMethod must be first *)
		TrimmingMethod,
		TrimBeforeIndex,
		TrimAfterIndex,
		TerminationNumberOfBases,
		TotalUnassignableBases,
		WindowSize,
		WindowUnassignablePercentage,
		TerminationSequence
	};

	(* By default, there is no trimming *)
	resolvedTrimDirection=Lookup[safeOps,Trimming]/.{
		Automatic->None
	};

	(* True if Trimming is None but other trimming ops were specified *)
	unusedTrimOptionsQ=If[MatchQ[resolvedTrimDirection,None],
		MemberQ[originalOps,Rule[Alternatives@@trimmingOps,_]],
		False
	];

	(* Warn user if any trimming options would go unused *)
	If[unusedTrimOptionsQ,
		Message[Warning::TrimmingOptionsIgnored,Cases[trimmingOps,Alternatives@@(First/@originalOps)]];
	];

	(* The requested type of trimming. Defaults to Null if Trimming is set to None *)
	resolvedTrimMethod=Lookup[safeOps,TrimmingMethod]/.{
		(Automatic|Null)->If[MatchQ[resolvedTrimDirection,None],
			Null,
			BaseIndices
		]
	};

	(* Any trimming options selected by the user *)
	originalTrimOps=Cases[First/@originalOps, Alternatives@@trimmingOps];

	(* List of incompatible trim options set in the input options *)
	incompatibleTrimOps=Complement[
		DeleteCases[originalTrimOps,TrimmingMethod],
		Switch[resolvedTrimMethod,
			BaseIndices,{TrimBeforeIndex,TrimAfterIndex},
			PrimerTerminus,{TerminationSequence},
			NumberOfBases,{TerminationNumberOfBases},
			UnassignableBases,{TotalUnassignableBases},
			Window,{WindowSize,WindowUnassignablePercentage},
			_,{}
		]
	];

	(* Warn user if any incomptaible trimming options were specified *)
	If[!MatchQ[resolvedTrimDirection,None]&&Length[incompatibleTrimOps]>0,
		Message[Warning::IncompatibleTrimmingOptions,incompatibleTrimOps,resolvedTrimDirection];
	];

	(* Warn the user if the trimming method is incompatible with the UnassignedBases option *)
	If[Lookup[safeOps,UnassignedBases]===False&&MatchQ[resolvedTrimMethod,Window|UnassignableBases],
		Message[Warning::UnsupportedTrimmingMethod,resolvedTrimMethod];
	];

	(* Warn the user if the trimming method is incompatible with the trim direction *)
	If[MatchQ[resolvedTrimMethod,NumberOfBases]&&MatchQ[resolvedTrimDirection,Start|Both],
		Message[Warning::TrimDirectionIncompatible,resolvedTrimDirection,NumberOfBases,End,{End}];
	];

	(* Resolve options for termination sequence method *)
	resolvedTerminationSequence=If[MatchQ[Lookup[safeOps,TerminationSequence],Automatic|Null],
		If[MatchQ[resolvedTrimMethod,PrimerTerminus],
			bestPCRPrimers[packets],
			Null
		],
		Lookup[safeOps,TerminationSequence]
	];

	(* Resolve options for trimming by base indices *)
	resolvedTrimBeforeIndex=Lookup[safeOps,TrimBeforeIndex]/.{
		(Automatic|Null)->If[MatchQ[resolvedTrimDirection,Start|Both]&&MatchQ[resolvedTrimMethod,BaseIndices],
			1,
			Null
		]
	};
	resolvedTrimAfterIndex=Lookup[safeOps,TrimAfterIndex]/.{
		(Automatic|Null)->If[MatchQ[resolvedTrimDirection,End|Both]&&MatchQ[resolvedTrimMethod,BaseIndices],
			Automatic,
			Null
		]
	};

	(* Resolve options for trimming by number of bases *)
	resolvedTerminationNumber=Lookup[safeOps,TerminationNumberOfBases]/.{
		(Automatic|Null)->If[MatchQ[resolvedTrimMethod,NumberOfBases],
			1000,
			Null
		]
	};

	(* Resolve options for trimming by total unassignable *)
	resolvedTotalUnassignable=Lookup[safeOps,TotalUnassignableBases]/.{
		(Automatic|Null)->If[MatchQ[resolvedTrimMethod,UnassignableBases],
			10,
			Null
		]
	};

	(* Resolved options for trimming by windows *)
	resolvedTrimWindowSize=Lookup[safeOps,WindowSize]/.{
		(Automatic|Null)->If[MatchQ[resolvedTrimMethod,Window],
			20,
			Null
		]
	};
	resolvedTrimWindowCutoff=Lookup[safeOps,WindowUnassignablePercentage]/.{
		(Automatic|Null)->If[MatchQ[resolvedTrimMethod,Window],
			50 Percent,
			Null
		]
	};

	(* Compile the trimming options *)
	trimmingOptions={
		Trimming->resolvedTrimDirection,
		TrimmingMethod->resolvedTrimMethod,
		TrimBeforeIndex->resolvedTrimBeforeIndex,
		TrimAfterIndex->resolvedTrimAfterIndex,
		TerminationNumberOfBases->resolvedTerminationNumber,
		TotalUnassignableBases->resolvedTotalUnassignable,
		WindowSize->resolvedTrimWindowSize,
		WindowUnassignablePercentage->resolvedTrimWindowCutoff,
		TerminationSequence->resolvedTerminationSequence
	};

	(* Miscellaneous options which do not need additional resolution *)
	miscOptions=Thread[Rule[
		{Output,Upload,Template},
		Lookup[safeOps,{Output,Upload,Template}]
	]];

	(* Return the resolved Options *)
	Join[
		mixedOptions,
		unassignedOptions,
		trimmingOptions,
		miscOptions
	]
];

(* Helper function for extracting PCR primers associated with DNA sequencing data objects *)
bestPCRPrimers[packets:{PacketP[Object[Data,DNASequencing]]..}]:=Module[
	{samplesInPerPacket,protocolsPerPacket,onlyPCRProtocols,uniquePrimers,bestPrimers},

	(* Extract the SamplesIn from each input packet *)
	samplesInPerPacket=Lookup[packets,SamplesIn,{}];

	(* The protocols associated with the samples in for each input packet *)
	protocolsPerPacket=Flatten/@Download[samplesInPerPacket,Protocols];

	(* Select only PCR and qPCR protocols *)
	onlyPCRProtocols=Map[
		Cases[#,ObjectP[{Object[Protocol,PCR],Object[Protocol,qPCR]}]]&,
		protocolsPerPacket
	];

	(* Get primer objects from any PCR/qPCR protocols *)
	uniquePrimers=Map[
		DeleteDuplicates[Flatten[#]]&,
		Download[onlyPCRProtocols,{ForwardPrimers,ReversePrimers}]
	];

	(* Extract the Strand or sequence objects representing primers *)
	uniquePrimerMolecules=Map[
		Cases[DeleteDuplicates[Flatten[#]],SequenceP|StrandP]&,
		Quiet[Download[uniquePrimers,Composition[[All,-1]][Molecule]]]
	];

	(* Take the first of the molecules for each one for automatic option resolution *)
	bestPrimers=DeleteCases[FirstOrDefault/@uniquePrimerMolecules,Null];

	(* Return a list of resolved primers. *)
	If[MatchQ[bestPrimers,{}],
		(* If no primers could be resolved, then warn the user. *)
		Message[Warning::PrimersNotFound];
		{DNA[""]},
		bestPrimers
	]
];



(* ::Subsubsection::Closed:: *)
(* applyUnassignedMixedBases *)

(* Either mark or un-mark bases as unassigned based on the unassignedBasesOption *)
applyUnassignedMixedBases[calledSeqs_,qualityVals_,orderedTraces_,resolvedOps:OptionsPattern[AnalyzeDNASequencing]]:=Module[
	{unassignBoolean,unassignThreshold},

	(* Look up the value of the UnassignedBases option *)
	unassignBoolean=Lookup[resolvedOps,UnassignedBases];

	(* Look up the value of the UnassignedBasesThreshold *)
	unassignThreshold=Lookup[resolvedOps,UnassignedBasesThreshold];

	(* Process each called sequence accordingly *)
	MapThread[
		applyUnassignedMixedBasesSingle[#1,#2,#3,unassignBoolean,unassignThreshold]&,
		{calledSeqs,qualityVals,orderedTraces}
	]
];

(* For a single called sequence, if unassigned bases are true, set any unassigned bases with QV<threshold to unassigned *)
applyUnassignedMixedBasesSingle[calledSeq_,qualityVals_,traces_,True,threshold_]:=MapThread[
	{
		First[#1],
		If[#2<threshold,"N",Last[#1]]
	}&,
	{calledSeq,qualityVals}
];

(* For a single called sequence, if unassigned bases are false, set any unassigned bases to the max intensity channel at that location *)
applyUnassignedMixedBasesSingle[calledSeq_,qualityVals_,traces_,False,threshold_]:=Map[
	{
		First[#],
		If[Last[#]==="N",
			getMaxBase[traces,First[#]],
			Last[#]
		]
	}&,
	calledSeq
];

(* Given an x-axis value (cycle-read) for the chromatograms, return the largest intensity channel at that point *)
getMaxBase[traces_,pos_]:=Module[
	{interpVals,maxIndex},

	(* Interpolation functions for each trace *)
	interpFuncs=Map[
		Interpolation[Unitless[#],InterpolationOrder->1]&,
		traces
	];

	(* Value of the A, C, G and T interpolation functions at pos *)
	interpVals=#[pos]&/@interpFuncs;

	(* Index of the maximum value *)
	index=First@FirstPosition[interpVals,Max[interpVals]];

	(* Return the channel with the maximum position *)
	Switch[index,
		1,"A",
		2,"C",
		3,"G",
		4,"T"
	]
];


(* ::Subsubsection::Closed:: *)
(*trimPredictedSequences*)

(* Apply the trimming options specified by resolvedOps *)
trimPredictedSequences[predictedSequences_,qualityVals_,resolvedOps:OptionsPattern[AnalyzeDNASequencing]]:=Module[
	{trimming,trimmingMethod,trimIndices,safeTrimIndices,trimmedSeqs,trimmedQVs},

	(* Check the trimming and trimming method options *)
	trimming=Lookup[resolvedOps,Trimming];
	trimmingMethod=Lookup[resolvedOps,TrimmingMethod];

	(* If the resolved Trimming options is None, return the predicted sequences and quality values unchanged *)
	If[trimming===None,
		Return[{predictedSequences,qualityVals}]
	];

	(* A pair of indices defining the trim. Null indicates no trimming in that direction *)
	trimIndices=MapThread[
		getTrimIndices[trimmingMethod,trimming,#1,#2,resolvedOps]&,
		{predictedSequences,qualityVals}
	];

	(* Return an error message if there are any invalid trimmings *)
	If[MemberQ[trimIndices,_?(Last[#]<First[#]&)],
		Message[Warning::TrimImpossible,Flatten@Position[(Last[#]<First[#]&)/@trimIndices,True]]
	];

	(* Check the trim indices to see if they are valid *)
	safeTrimIndices=MapThread[
		If[Last[#1]<First[#1],
			{1,Length[#2]},
			#1
		]&,
		{trimIndices,predictedSequences}
	];

	(* Trim sequences by slicing *)
	trimmedSeqs=MapThread[
		Part[#1,Span@@#2]&,
		{predictedSequences,safeTrimIndices}
	];

	(* Trim the quality values in the same way *)
	trimmedQVs=MapThread[
		Part[#1,Span@@#2]&,
		{qualityVals,safeTrimIndices}
	];

	(* Return the trimmed values *)
	{trimmedSeqs,trimmedQVs}
];


(* Trim by Base Indices *)
getTrimIndices[BaseIndices,dir_,seq_,qvs_,rops_]:=Module[
	{maxIndex,leftIndex,rightIndex,checkedLeftIndex,checkedRightIndex},

	(* The maximum index, i.e. the length of the sequence being trimmed *)
	maxIndex=Length[seq];

	(* Get the 5' end trim index *)
	leftIndex=If[MatchQ[dir,Start|Both],
		Lookup[rops,TrimBeforeIndex],
		1
	];

	(* Get the 3' end trim index *)
	rightIndex=If[MatchQ[dir,End|Both],
		Lookup[rops,TrimAfterIndex]/.{Automatic->maxIndex},
		maxIndex
	];

	(* Check bounds *)
	checkedLeftIndex=If[leftIndex<1||leftIndex>maxIndex,
		Message[Warning::TrimOutOfBounds,TrimBeforeIndex,leftIndex,maxIndex];
		1,
		leftIndex
	];

	(* Check bounds on right side *)
	checkedRightIndex=If[rightIndex>maxIndex||rightIndex<1,
		Message[Warning::TrimOutOfBounds,TrimAfterIndex,rightIndex,maxIndex];
		maxIndex,
		rightIndex
	];

	(* Check that the bounds define a valid range *)
	If[checkedRightIndex<checkedLeftIndex,
		Message[Warning::InvalidTrimRange,checkedLeftIndex,checkedRightIndex];
		{checkedLeftIndex,checkedRightIndex}={1,maxIndex}
	];

	(* Return the resolved trimming indices *)
	{checkedLeftIndex,checkedRightIndex}
];

(* Trim by termination sequence (e.g. PCR primers) *)
getTrimIndices[PrimerTerminus,dir_,seq_,qvs_,rops_]:=Module[
	{
		termSeqs,basesOnly,baseString,termStrings,reverseComplements,
		allTermSeqs,termSeqPositions,adjacentSeqPosPairs,possibleTrimIndices
	},

	(* A list of DNA sequences to terminate at *)
	termSeqs=Lookup[rops,TerminationSequence];

	(* Extract only the bases from the sequence *)
	basesOnly=Last/@seq;

	(* Convert the sequence bases to a string *)
	baseString=StringJoin[basesOnly];

	(* Convert all the termination sequences into strings *)
	termStrings=Map[
		Switch[#,
			StrandP,First@First[#[Motifs]],
			_DNA,First[#],
			_String,#
		]&,
		termSeqs
	];

	(* Get the reverse complements of each termination string *)
	reverseComplements=ReverseComplementSequence[#,Polymer->DNA]&/@termStrings;

	(* A list of all termination sequences to search for *)
	allTermSeqs=DeleteDuplicates[Join[termStrings,reverseComplements]]/.{""->Nothing};

	(* If no term sequences were resolved, then quit without trimming *)
	If[MatchQ[allTermSeqs,{}],
		Return[{1,Length[seq]}];
	];

	(* The positions of the termination sequences in the base string *)
	termSeqPositions=SortBy[
		Flatten[StringPosition[baseString,#]&/@allTermSeqs,1],
		First
	];

	(* Paired positions of term sequences, with padding, for computation of trim indices *)
	adjacentSeqPosPairs=Partition[
		Join[{{0,0}},termSeqPositions,{{Length[seq]+1,Length[seq]+1}}],
		2,
		1
	];

	(* Indices of possible trims, defined as contiguous subsequences between termination sequences *)
	possibleTrimIndices=Map[
		{#[[1,-1]]+1,#[[-1,1]]-1}&,
		adjacentSeqPosPairs
	];

	(* Return the best trim *)
	Switch[dir,
		(* +/- Infinity is the no trim found state, so convert that to 1;;0 for proper handling *)
		Start,MinMax[Join@@Rest[possibleTrimIndices]]/.{{\[Infinity],-\[Infinity]}->{1,0}},
		End,MinMax[Join@@Most[possibleTrimIndices]]/.{{\[Infinity],-\[Infinity]}->{1,0}},
		Both,First@MaximalBy[possibleTrimIndices,Last[#]-First[#]&]
	]
];

(* Trim by Base Indices. Note that Direction will behave as End regardless of the value of Trimming; this is error-checked in the option resolver *)
getTrimIndices[NumberOfBases,dir_,seq_,qvs_,rops_]:=Module[
	{maxIndex,trimAfterIndex},

	(* The maximum index, i.e. the length of the sequence being trimmed *)
	maxIndex=Length[seq];

	(* Trim after this number of bases have been read *)
	trimAfterIndex=Lookup[rops,TerminationNumberOfBases];

	(* Return either the length of the sequence or the requested index, whichever is shorter *)
	{1,Min[maxIndex,trimAfterIndex]}
];

(* Trim by total number of unassignable bases *)
getTrimIndices[UnassignableBases,dir_,seq_,qvs_,rops_]:=Module[
	{maxUnassignable,basesOnly,unassignableBooleans},

	(* The maximum number of unassignable bases in the trimmed sequence *)
	maxUnassignable=Lookup[rops,TotalUnassignableBases];

	(* Extract only bases from the resolved sequence *)
	basesOnly=Last/@seq;

	(* Convert to a list of booleans, where True indicates the base could not be assigned *)
	unassignableBooleans=(#==="N")&/@basesOnly;

	(* Return the indices which return a trimmed strand with no more than the requested number of total unassignable bases *)
	bestTrimByThreshold[unassignableBooleans,maxUnassignable,dir]
];

(* Trim by total number of unassignable bases *)
getTrimIndices[Window,dir_,seq_,qvs_,rops_]:=Module[
	{
		windowSize,windowThreshold,safeWindowSize,basesOnly,windowBooleans,windowIndices
	},

	(* Extract window parameters from the resolved options *)
	windowSize=Lookup[rops,WindowSize];
	windowThreshold=Lookup[rops,WindowUnassignablePercentage];

	(* Ensure window size is valid *)
	safeWindowSize=If[windowSize>Length[seq]||windowSize<=1,
		Message[Warning::InvalidWindowSize,windowSize,Length[seq]];
		Length[seq],
		windowSize
	];

	(* Only the bases in the sequence *)
	basesOnly=Last/@seq;

	(* For each of the Length[seq]-windowSize windows *)
	windowBooleans=MovingMap[
		(N[Count[#,"N"]/Length[#]]>=windowThreshold)&,
		basesOnly,
		safeWindowSize-1
	];

	(* Get the longest trim indices for which the window criterion is not broken (threshold = 0) *)
	windowIndices=bestTrimByThreshold[windowBooleans,0,dir];

	(* If zero windows meet the criteria, then return a generic empty span 1;;0, otherwise adjust for window size *)
	If[Last[windowIndices]<First[windowIndices],
		{1,0},
		{First[windowIndices],Last[windowIndices]+safeWindowSize-1}
	]
];

(* Catch-all overload to prevent error message cascading *)
getTrimIndices[unrecognized_,dir_,sq_,qvs_,rops_]:={1,Length[sq]};


(* Given a list of booleans where True indicates that some threshold has been met, find the optimal trim which results in a sequence with a True count less than or equal to threshold *)
bestTrimByThreshold[booleanList:{BooleanP..},threshold_Integer,dir:Start|End|Both]:=Module[
	{
		zeroOneList,totalTrues,startTrimCounts,endTrimCounts,startTrimIndices,endTrimIndices,
		currentTruePos,truePosDiffs,currIndexRange,bothTrimIndices
	},

	(* Convert the booleans to zeros and ones *)
	zeroOneList=booleanList/.{True->1,False->0};

	(* Total number of Trues in the booleanList *)
	totalTrues=Count[booleanList,True];

	(* At each index, the number of Trues in the list if entries including and to the left of index are trimmed *)
	startTrimCounts=totalTrues-Accumulate[zeroOneList];

	(* At each index, the number of Trues in the list if entries including and to the right of index are trimmed *)
	endTrimCounts=totalTrues-Reverse@Accumulate[Reverse@zeroOneList];

	(* A map of (# of trues in trimmed sequence)\[Rule]start trim position *)
	startTrimIndices=Map[
		#->1+First@FirstPosition[startTrimCounts,#]&,
		Range[0,totalTrues-1]
	];

	(* A map of (# of trues in trimmed sequence)\[Rule]end trim position *)
	endTrimIndices=Map[
		#->Length[booleanList]-First@FirstPosition[Reverse@endTrimCounts,#]&,
		Range[0,totalTrues-1]
	];

	(* True positions *)
	currentTruePos=Flatten@Position[booleanList,True];

	(* Distance between true positions, with padding for end elements *)
	truePosDiffs=Differences@Flatten[{0,currentTruePos,Length[booleanList]+1}];

	(* Initialize the current index *)
	currIndexRange={1,Length[booleanList]};

	(* Build the lookup list for Both trimming sequentially, making the minimum trim each time to meet the threshold *)
	bothTrimIndices=Map[
		Function[{currThreshold},
			(* Update Values *)
			If[First[truePosDiffs]<Last[truePosDiffs],
				(* Trimming left side retains more bases *)
				truePosDiffs=Rest[truePosDiffs];
				currIndexRange={First[currentTruePos]+1,Last[currIndexRange]};
				currentTruePos=Rest[currentTruePos];,
				(* Trimming right side retains more bases *)
				truePosDiffs=Most[truePosDiffs];
				currIndexRange={First[currIndexRange],Last[currentTruePos]-1};
				currentTruePos=Most[currentTruePos];
			];
			(* Create the entry *)
			currThreshold->currIndexRange
		],
		Range[totalTrues-1,0,-1]
	];

	(* Return the trim indices based on the direction specification *)
	Switch[dir,
		(* If request is not found in startTrimIndices, then return the whole range *)
		Start,{Lookup[startTrimIndices,threshold,1],Length[booleanList]},
		(* If requested threshold is not found in endTrimIndices, return the whole range *)
		End,{1,Lookup[endTrimIndices,threshold,Length[booleanList]]},
		(* Likewise, default for both is going to be the entire range *)
		Both,Lookup[bothTrimIndices,threshold,{1,Length[booleanList]}]
	]
];



(* ::Subsubsection::Closed:: *)
(*constructUploadPacket*)

(* Assemble upload packets for all DNASequencing and Peaks Analysis objects, as well as data object updates *)
constructUploadPacket[
	stdFields:{_Rule..},
	resolvedOps:{(_Rule|_RuleDelayed)..},
	sequenceDataPacket:PacketP[Object[Data,DNASequencing]],
	orderedSeqTraces:{CoordinatesP,CoordinatesP,CoordinatesP,CoordinatesP},
	calledSeqs:{{NumericP,_String}..},
	untrimmedQualityVals:{NumericP..},
	pkPackets:{Repeated[PacketP[Object[Analysis,Peaks]],4]},
	trimmedSeqs:{{NumericP,_String}..},
	trimmedQualityVals:{NumericP..},
	qvPars:MatrixP[]
]:=Module[
	{
		newAnalysisID,dataObjID,untrimmedPositions,untrimmedBases,
		trimmedPositions,trimmedBases,baseAssignmentString,
		peakPacketIDs,sequenceAnalysisPacket,linkedPeakPackets,dataPacketUpdate
	},

	(* Create an object ID for the DNA sequence analysis so that we can link tto it  *)
	newAnalysisID=CreateID[Object[Analysis,DNASequencing]];

	(* Object reference for the data object used for this analysis *)
	dataObjId=Lookup[sequenceDataPacket,Object,Null];

	(* Extract positions and bases from the base calls *)
	{untrimmedPositions,untrimmedBases}=Transpose@calledSeqs;
	{trimmedPositions,trimmedBases}=Transpose@trimmedSeqs;

	(* Join the trimmed assigned bases into a single string *)
	baseAssignmentString=StringJoin[trimmedBases];

	(* Generate IDs for each of the four peak packets *)
	peakPacketIDs=CreateID[Repeat[Object[Analysis,Peaks],4]];

	(* Construct the analysis packet *)
	sequenceAnalysisPacket=Association@@Join[
		stdFields,
		{
			Object->newAnalysisID,
			Replace[Reference]->Link[dataObjId,SequenceAnalyses],
			ResolvedOptions->resolvedOps,
			SequenceAssignment->baseAssignmentString,
			Replace[SequenceBases]->trimmedBases,
			Replace[QualityValues]->trimmedQualityVals,
			Replace[BaseProbabilities]->Null,
			Replace[SequencePeakPositions]->trimmedPositions,
			Replace[UntrimmedSequenceBases]->untrimmedBases,
			Replace[UntrimmedQualityValues]->untrimmedQualityVals,
			Replace[UntrimmedBaseProbabilities]->Null,
			Replace[UntrimmedSequencePeakPositions]->untrimmedPositions,
			SequencingElectropherogramTraceA->orderedSeqTraces[[1]],
			SequencingElectropherogramTraceC->orderedSeqTraces[[2]],
			SequencingElectropherogramTraceG->orderedSeqTraces[[3]],
			SequencingElectropherogramTraceT->orderedSeqTraces[[4]],
			Replace[PhredQualityParameters]->qvPars,
			Replace[PeaksAnalyses]->(Link[#,SequenceAnalysis]&/@peakPacketIDs)
		}
	];

	(* Add object IDs and links to the peak packets *)
	linkedPeakPackets=MapThread[
		Join[
			<|
				Object->#2
			|>,
			#1
		]&,
		{pkPackets,peakPacketIDs}
	];

	(* Return all packets to upload *)
	{sequenceAnalysisPacket,linkedPeakPackets}
];

(* If pattern don't match, return $Failed *)
constructUploadPacket[unmatched:___]:={$Failed,$Failed};



(* ::Subsection::Closed:: *)
(*Phred Algorithm*)

(* ----------------------- *)
(* --- PHRED ALGORITHM --- *)
(* ----------------------- *)

(*****
	The Phred Algorithm consists of four general steps
		1. Identifying theoretical peaks by enforcing constant peak-spacing with a Fourier Fit
		2. Identifying observed peaks in the data traces
		3. Aligning observed peaks with theoretical peaks using dynamic programming
		4. Cleaning up and correcting any unaligned peaks
 *****)
applyPhredBaseCaller[traces:Repeated[_,4]]:=applyPhredBaseCaller[traces]=Module[
	{
		minCycle,maxCycle,stepSize,traceInterpolationFunctions,tracePeakPackets,
		cleanedPeakPackets,predictedPeaks,observedPeaks,alignedPeaks,newPredPeaks,
		calledPks,bestUncalledPks,unassignedPks,finalPks,sortedFinalPks,qualityValues,phredParams
	},

	(* Memoize this function *)
	If[!MemberQ[$Memoization, Analysis`Private`applyPhredBaseCaller],
		AppendTo[$Memoization, Analysis`Private`applyPhredBaseCaller]
	];

	(* Determine the smallest and largest x-values in the electropherograms *)
	{minCycle,maxCycle}=MinMax[First/@Unitless[First[traces]]];

	(* Get the step size between adjacent data points (1.0 in most cases) *)
	stepSize=First@Differences[First/@Unitless[First[traces]]];

	(* Construct linear interpolation functions for each trace *)
	traceInterpolationFunctions=Map[
		Interpolation[Unitless[#],InterpolationOrder->1]&,
		traces
	];

	(* Use AnalyzePeaks to locate peaks in each of the data traces, with a small width threshold to ensure narrow peaks are captured. *)
	tracePeakPackets=AnalyzePeaks[traces,
		WidthThreshold->{5*stepSize},
		Upload->False,
		SkipTangentFieldCalculation->True
	];

	(* Strip the upload formatting from the raw peak packets *)
	cleanedPeakPackets=stripAppendReplaceKeyHeads[tracePeakPackets];

	(* Use a Fourier fit enforcing uniform peak spacing to get "predicted" peak positions *)
	predictedPeaks=getPredictedPeaks[
		cleanedPeakPackets,
		traceInterpolationFunctions,
		{minCycle,maxCycle},
		stepSize
	];

	(* If no predicted peaks could be resolved, then early return an empty list *)
	If[MatchQ[predictedPeaks,{}],
		Return[{}]
	];

	(* Extra filtering of noise beyond analyze peaks, and calculation of Phred auxiliary fields *)
	observedPeaks=getObservedPeaks[
		traces,
		traceInterpolationFunctions,
		cleanedPeakPackets,
		{minCycle,maxCycle},
		stepSize
	];

	(* Use dynamic programming to match predicted peaks to observed peaks, allowing splitting of peaks *)
	{calledPks,bestUncalledPks,unassignedPks,newPredPeaks}=alignObservedPredictedPeaks[
		predictedPeaks,
		observedPeaks,
		traceInterpolationFunctions
	];

	(* Match the called peaks to predicted peaks, preserving the location of the actual called peaks *)
	finalPks=MapThread[
		If[MatchQ[#2,None],
			{First[#1],"N"},
			{First[#1],First[#2]}
		]&,
		{newPredPeaks,calledPks}
	];

	(* The peaks must be sorted *)
	sortedFinalPks=SortBy[finalPks,First];

	(* Compute quality values from the final assigned peaks *)
	{qualityValues,phredParams}=phredQualityScore[sortedFinalPks,unassignedPks,traces,traceInterpolationFunctions];

	(* Just in case there was an error during processing, set invalid quality score values to zero *)
	qualityValues=Replace[qualityValues,
		Except[NumericP]->0,
		{1}
	];

	(* Output basecalling results *)
	{finalPks,qualityValues,tracePeakPackets,phredParams}
];



(* ::Subsubsection::Closed:: *)
(*getPredictedPeaks*)

(* Use the Fourier-fit method of the Phred algorithm to predict idealized peak locations which maintain even peak spacing *)
getPredictedPeaks[
	pkPackets:Repeated[_,4],
	pkInterps:Repeated[_,4],
	{xmin:NumericP,xmax:NumericP},
	stepSize:NumericP
]:=Module[
	{
		alignmentPeaks,alignmentPeakPositions,syntheticSqWave,
		startRegionMidpoint,startingDampedSqWave,bestPeriod,
		leftNestHelper,rightNestHelper,leftResults,rightResults
	},

	(* Get a combined list of the peaks with maximum signal at each cycle, with low-intensity noisy peaks removed *)
	alignmentPeaks=getPeaksForAlignment[pkPackets,pkInterps];

	(* Return an empty list of no peaks were found *)
	If[MatchQ[alignmentPeaks,{}],
		Return[{}];
	];

	(* Only the positions of the denoised peaks *)
	alignmentPeakPositions=Part[#,2]&/@alignmentPeaks;

	(* Generate the synthetic, peak-centered square wave used for alignment in the Phred algorithm *)
	syntheticSqWave=generateSyntheticSquareWave[alignmentPeaks,{xmin,xmax},stepSize];

	(* Locate the peak-centered region with the most uniform peak spacing *)
	startRegionMidpoint=findStartingRegionCenter[alignmentPeakPositions];

	(* Apply a symmetric triangular filter to synthetic square wave in the start region for period fitting *)
	startingDampedSqWave=makeDampedSquareWave[syntheticSqWave,startRegionMidpoint];

	(* The period of the sine wave with the best Fourier-fit to the starting damped square wave  *)
	bestPeriod={findOptimalPeriod[startingDampedSqWave]};

	(* Create pure functions so we can apply NestWhile *)
	leftNestHelper=nestHelper[alignmentPeakPositions,syntheticSqWave,Left];
	rightNestHelper=nestHelper[alignmentPeakPositions,syntheticSqWave,Right];

	(* Use NestWhile to propagate (iterate by dynamic programming) to the trace ends *)
	leftResults=Last@NestWhile[leftNestHelper,{{startRegionMidpoint,bestPeriod},{}},MatchQ[First[#],Except[None]]&];
	rightResults=Last@NestWhile[rightNestHelper,{{startRegionMidpoint,bestPeriod},{}},MatchQ[First[#],Except[None]]&];

	(* Join the two directions together *)
	Join[leftResults,Rest@rightResults]
];

(* Format the output of nextRegionPeak so it can be used with NestWhile *)
nestHelper[pkPositions_List,sqWave_,dir:Left|Right]:=Function[{fullState},
	Module[{midpt,periods,allStates,thisState,nextState},

		(* Extract midpoint and periods from the input state *)
		{midpt,periods}=First[fullState];

		(* Growing list of computed states *)
		allStates=Last[fullState];

		(* Call nextRegionPeak to get the next state *)
		{thisState,nextState}=nextRegionPeak[pkPositions,sqWave,midpt,periods,dir];

		(* Format the output *)
		{
			nextState,
			If[MatchQ[dir,Right],
				Append[allStates,thisState],
				Prepend[allStates,thisState]
			]
		}
	]
];



(* ::Subsubsection::Closed:: *)
(*getPeaksForAlignment*)

(* Given peak packets and interpolations for each trace, keep only the largest peak at each cycle and remove noise *)
getPeaksForAlignment[
	tracePeakPackets:Repeated[_,4],
	traceInterpolationFunctions:Repeated[_,4]
]:=Module[
	{
		peakPositionsHeights,joinedPeaks,sortedPeaks,
		trimmedPeaks,trimmedPeakHeights,prevPeakHeights,currPeakHeight
	},

	(* Extract a list of {base,pkPosition,pkHeight} from each peak packet *)
	peakPositionsHeights=MapThread[
		Function[{packet,base},
			Map[
				Prepend[#,base]&,
				Transpose[Lookup[packet,{Position,Height}]]
			]
		],
		{tracePeakPackets,{"A","C","G","T"}}
	];

	(* Join all the peaks together *)
	joinedPeaks=Join@@peakPositionsHeights;

	(* Sort the joined peaks by position/cycle number *)
	sortedPks=SortBy[joinedPeaks,Part[#,2]&];

	(* Trim peaks where the peak is not the maximal signal at that cycle *)
	trimmedPeaks=If[MatchQ[sortedPks,{}],
		{},
		Select[sortedPks,checkMaxSignal[traceInterpolationFunctions,#[[2]],#[[1]]]&]
	];

	(* Only the heights from the trimmed peaks *)
	trimmedPeakHeights=Last/@trimmedPeaks;

	(* Previous peak heights with zero padding, for comparing peaks to previous adjacent peaks *)
	prevPeakHeights=Most@RotateRight[Append[trimmedPeakHeights,0.0]];

	(* Loop variable to be updated during the following MapThread *)
	currPeakHeight=If[MatchQ[joinedPeaks,{}],
		0.0,
		joinedPeaks[[1,-1]]
	];

	(* Denoise the peaks by removing peaks with less than 10% of the height of the previous peak *)
	MapThread[
		Function[{peakTuple,currHeight,prevHeight},
			If[currHeight>0.10*prevHeight,
				currPeakHeight=currHeight;
				peakTuple,
				Nothing
			]
		],
		{trimmedPeaks,trimmedPeakHeights,prevPeakHeights}
	]
];



(* ::Subsubsection::Closed:: *)
(*generateSyntheticSquareWave*)

(* Generate a synthetic square wave with peaks centered where peaks appear across all traces, and peak widths related to spacing. *)
generateSyntheticSquareWave[
	denoisedPeaks:{{"A"|"C"|"T"|"G",NumericP,NumericP}..},
	{xmin:NumericP,xmax:NumericP},
	stepSize:NumericP
]:=Module[
	{
		denoisedPeakPositions,safeMeanHalfWidth,paddedPkPos,
		syntheticHalfWidths,syntheticPeakRanges,syntheticPeakRangeIndices,
		trimmedPeakRangeIndices,newRange,squareWaveYvals
	},

	(* Extract just the positions of denoised peaks to construct a synthetic trace for alignment *)
	denoisedPeakPositions=Part[#,2]&/@denoisedPeaks;

	(* Helper function for getting average local peak spacing *)
	safeMeanHalfWidth[a:NumericP,b:NumericP]=(a+b)/4.0;
	safeMeanHalfWidth[a:NumericP,b_]=a/2.0;
	safeMeanHalfWidth[a_,b:NumericP]=b/2.0;

	(* Add a Null to each end of the denoised peak positions for half-width calculation *)
	paddedPkPos=Prepend[Append[denoisedPeakPositions,Null],Null];

	(* Synthetic peak half-widths - each peak half-width is 1/4 of average local peak spacing *)
	syntheticHalfWidths=MapThread[
		Function[{currPos,nextPos,prevPos},
			(* If statement trims Null-padding from paddedPkPos *)
			If[FreeQ[currPos,Null],
				safeMeanHalfWidth[nextPos-currPos,currPos-prevPos],
				Nothing
			]
		],
		{paddedPkPos,RotateLeft[paddedPkPos],RotateRight[paddedPkPos]}
	];

	(* X-values for the synthetic square wave are the xvalues of the original data *)
	newRange=N@Range[xmin,xmax,stepSize];

	(* Generate the synthetic square wave with peaks centered at identified peaks, and widths = 1/4 of local peak spacing *)
	syntheticPeakRanges=MapThread[
		{#1-0.25*#2,#1+0.25*#2}&,
		{denoisedPeakPositions,syntheticHalfWidths}
	];

	(* Convert the peak ranges to indices in the upsampled data  *)
	syntheticPeakRangeIndices=Flatten@Map[
		Function[minmax,
			Range@@(Round[1+(#-xmin)/stepSize]&/@minmax)
		],
		syntheticPeakRanges
	];

	(* Keep only the indices that are in bound *)
	trimmedPeakRangeIndices=Select[syntheticPeakRangeIndices,(xmin<=#<=xmax)&];

	(* Generate the square wave by using peak range indices to flip -1s to +1s *)
	squareWaveYvals=Repeat[-1,Length[newRange]];
	squareWaveYvals[[trimmedPeakRangeIndices]]=1;

	(* Return the synthetic square wave *)
	Transpose@{newRange,squareWaveYvals}
];



(* ::Subsubsection::Closed:: *)
(*findStartingRegionCenter*)

(* Given a list of peak positions, return the center of the region with the most uniform peak spacing *)
findStartingRegionCenter[pkPositions_List,regionWidth_Integer]:=Module[
	{pkSpacings,pkRegionIndices,pkRegionSpans,pkSpacingsPerRegion,spacingStdevs,startRegionIndex},

	(* Peak spacings between identified peaks *)
	pkSpacings=Differences[pkPositions];

	(* Get the left-most and right-most peaks in each peak range, with ranges centered on peak positions *)
	pkRegionIndices=Map[
		Function[{pos},
			(* Get the position of peaks with position within 100 cycle-reads of the current peak *)
			MinMax[Position[pkPositions,_?(And[#<=pos+regionWidth/2,#>=pos-regionWidth/2]&)]]
		],
		pkPositions
	];

	(* Convert the indices of peaks to spans, with the last element decremented by 1 *)
	pkRegionSpans=Map[
		Span[First[#],Last[#]-1]&,
		pkRegionIndices
	];

	(* The peak spacings in each peak-centered region *)
	pkSpacingsPerRegion=Part[pkSpacings,#]&/@pkRegionSpans;

	(* Mean-scaled standard deviation of peak spacings in each peak-centered region of +/-100 cycle reads. *)
	spacingStdevs=Map[
		N[If[Length[#]>1,StandardDeviation[#],Mean[#]]/Mean[#]]&,
		pkSpacingsPerRegion
	];

	(* The starting region is the peak-centered window of 200 cycle-reads with the smallest mean-scaled stdev *)
	startRegionIndex=First@FirstPosition[spacingStdevs,Min[spacingStdevs]];

	(* Return the location of the central peak in the starting position *)
	Part[pkPositions,startRegionIndex]
];

(* Default width of the region is 200 cycle reads *)
findStartingRegionCenter[pkPositions_List]:=findStartingRegionCenter[pkPositions,200];



(* ::Subsubsection::Closed:: *)
(*makeDampedSquareWave*)

(* Given a square wave, and a region (center + width), apply a triangular filter to the square wave for fitting. *)
compiledMakeDampedSquareWave=Core`Private`SafeCompile[
	{
		{xyvals,_Real,2},
		{center,_Real},
		{width,_Real}
	},
	Map[
		{First[#],Last[#]*Max[0.0,(1.0-2.0*Abs[First[#]-center]/width)]}&,
		Part[xyvals,
			Span[
				Max[1,1+Round[center-width/2]],
				Min[Length[xyvals],1+Round[center+width/2]]
			]
		]
	],
	RuntimeOptions->{"EvaluateSymbolically"->False}
];

(* Default region width is 200 *)
makeDampedSquareWave[sqWave_,center:NumericP,width:NumericP]:=compiledMakeDampedSquareWave[sqWave,center,width];
makeDampedSquareWave[sqWave_,center:NumericP]:=compiledMakeDampedSquareWave[sqWave,center,200.0];



(* ::Subsubsection::Closed:: *)
(*findOptimalPeriod*)

(* Use the FFT power spectrum to fit the inner-product maximizing frequency to the damped square wave *)
findOptimalPeriod[dampedWave_]:=Module[
	{fourierFrequencies,powerSpectrum,halfPowerSpectrum,optimalFrequency},

	(* Compute the frequencies corresponding to each point in the power spectrum of the damped wave *)
	fourierFrequencies=Range[0,Length[dampedWave]-1]/((Last[#]-First[#])&@(First/@dampedWave));

	(* Compute the absolute square value of the FFT of the square-wave intensity values *)
	powerSpectrum=PeriodogramArray[Last/@dampedWave];

	(* Take only the first half of the power spectrum; the second half is symmetric and redundant because input is real *)
	halfPowerSpectrum=Part[
		Transpose[{fourierFrequencies,powerSpectrum}],
		(* Exclude the first element, since it corresponds to constant shifts in the average intensity from zero *)
		Span[2,Round[Length[dampedWave]/2]]
	];

	(* The optimal frequency is the intensity maximum of the power spectrum *)
	optimalFrequency=MaximalBy[halfPowerSpectrum,Last][[1,1]];

	(* Return the optimal period as 1/optimalFrequency *)
	1.0/MaximalBy[halfPowerSpectrum,Last][[1,1]]
];



(* ::Subsubsection::Closed:: *)
(*fitSineWave*)

(* Given a list of candidate periods, return the sin wave period and x-shift which results in maximal inner product with the damped square wave *)
fitSineWave[dampedWave_,candidatePeriods_List]:=Module[
	{shift,maximizationResult,periodShiftProduct},

	(* For each candidate period, numerically optimize the shift so the inner product with dampedWave is maximized *)
	maximizationResult=Map[
		FindMaximum[
			sineInnerProduct[dampedWave,#,shift],
			shift,
			Method->"PrincipalAxis"
		]&,
		candidatePeriods
	];

	(* Tuples of {period, optimal shift, inner product} for each candidate period *)
	periodShiftProduct=MapThread[
		{
			#1,
			shift/.Last[#2],
			First[#2]
		}&,
		{candidatePeriods,maximizationResult}
	];

	(* Return the {period, shift} of the sine wave which maximizes inner product *)
	Most[First@MaximalBy[periodShiftProduct,Last]]
];

(* Inner product of sin((2pi/period)*(x+shift)) with data given by {xvals,yvals} *)
sineInnerProduct=Core`Private`SafeCompile[
	{
		{xyvals,_Real,2},
		{period,_Real},
		{xshift,_Real}
	},
	Dot[
		Sin[(2\[Pi]/period)*(First/@xyvals+xshift)],
		Last/@xyvals
	],
	RuntimeOptions->{"EvaluateSymbolically"->False}
];



(* ::Subsubsection::Closed:: *)
(*fitSineToRegion*)

(* Given square wave, region (center+width), and candidate periods, fit a sine wave and return its period and shift *)
fitSineToRegion[sqWave_,center:NumericP,candidates_List,regionWidth_Integer]:=Module[
	{dampedSqWave,tmp},

	(* Slice and apply symmetric triangular filter to the sliced wave *)
	dampedSqWave=makeDampedSquareWave[sqWave,center,regionWidth];

	(* Fit the sine wave *)
	fitSineWave[dampedSqWave,candidates]
];

(* Default region width is 200 *)
fitSineToRegion[sqWave_,center:NumericP,candidates_List]:=fitSineToRegion[sqWave,center,candidates,200];



(* ::Subsubsection::Closed:: *)
(*getClosestSinePeak*)

(* Given a region midpoint and sine wave (described by period+shift), find the sine wave peak closest to the center of the region *)
getClosestSinePeak[midpt:NumericP,period:NumericP,shift:NumericP]:=Module[
	{napprox},

	(* Peaks correspond to x where (2pi/period)*(x+shift) = pi/2 + 2*pi*n, where n is any integer. Solve for the real number n which would make x = midpt *)
	nApprox=(midpt+shift)/period-1/4;

	(* Get the closet peak by solving for x and rounding nApprox to an integer *)
	period*(Round[nApprox]+1/4)-shift
];


(* ::Subsubsection::Closed:: *)
(*nextRegionPeak*)

(* Given a region + candidate frequencies, fit the best frequency, compute peak center, and return the next region to check *)
nextRegionPeak[
	pkPositions_List,
	sqWave_,
	currCenter:NumericP,
	periods_List,
	dir:Left|Right,
	regionWidth_Integer
]:=Module[
	{
		bestSineWavePeriod,bestSineWaveShift,mostCenteredPeak,nextCenter,
		nextRegionPeaks,nextRegionPeakSpacings,nextRegionScaledStdev,nextRegionUniformlySpacedQ,
		nextPeriods,nextRegion
	},

	(* Find the sine wave {period, shift} with frequency among freqs which maximizes its inner product with the damped square wave *)
	{bestSineWavePeriod,bestSineWaveShift}=fitSineToRegion[sqWave,currCenter,periods];

	(* Find the peak of the bestSineWave closest to currCenter *)
	mostCenteredPeak=getClosestSinePeak[currCenter,bestSineWavePeriod,bestSineWaveShift];

	(* Compute the center of the next region *)
	nextCenter=If[MatchQ[dir,Left],
		mostCenteredPeak-bestSineWavePeriod,
		mostCenteredPeak+bestSineWavePeriod
	];

	(* Centers of all peaks in the next region *)
	nextRegionPeaks=Select[pkPositions,(nextCenter-regionWidth/2<=#<=nextCenter+regionWidth/2)&];

	(* Adjacent peak spacings in the next region *)
	nextRegionPeakSpacings=Differences[nextRegionPeaks];

	(* Mean-scaled standard deviation of peak spacings in the next region. Default to 100.0 if there aren't enough peaks to calculate a stdev. *)
	nextRegionScaledStdev=N@If[Length[nextRegionPeakSpacings]>1,
		StandardDeviation[nextRegionPeakSpacings]/Mean[nextRegionPeakSpacings],
		100.0
	];

	(* The next region is uniformly spaced if the scaled stdev is less than 0.45, as set by the Phred algorithm *)
	nextRegionUniformlySpacedQ=(nextRegionScaledStdev<100.0);

	(* Determine the candidate periods for the next window according to the Phred algorithm *)
	nextPeriods=Which[
		(* If the next region is not uniformly spaced, then carry over the current period *)
		!nextRegionUniformlySpacedQ,{bestSineWavePeriod},
		(* If going right, consider a small, discrete number of small deviations*)
		MatchQ[dir,Right],bestSineWavePeriod+{-0.03,0.0,0.03},
		(* If going left, consider a broader range of deviations to capture early-sequence variance *)
		MatchQ[dir,Left],bestSineWavePeriod+Range[-0.25,0.25,0.05]
	];

	(* Determine the next region to check. If out of bounds, then stop by setting nextRegion to None *)
	nextRegion=If[(nextCenter>sqWave[[-1,1]])||(nextCenter<sqWave[[1,1]]),
		None,
		{nextCenter,nextPeriods}
	];

	(* Output *)
	{
		{mostCenteredPeak,bestSineWavePeriod},
		nextRegion
	}
];

(* Default window size is 200 *)
nextRegionPeak[
	pkPositions_List,
	sqWave_,
	currCenter:NumericP,
	periods_List,
	dir:Left|Right
]:=nextRegionPeak[pkPositions,sqWave,currCenter,periods,dir,200];



(* ::Subsubsection::Closed:: *)
(*getObservedPeaks*)

(* Return a list of observed peaks (alongside relative areas and area division points) in the input traces, with noisy peaks filtered out. *)
getObservedPeaks[
	traces:Repeated[_,4],
	traceInterpolations:Repeated[_,4],
	pkPackets:Repeated[_,4],
	{xmin:NumericP,xmax:NumericP},
	stepSize:NumericP
]:=Module[
	{
		unitlessTraces,pkPosAreasRanges,sortedPkTuples,lastTenPeakAreas,filteredPeakTuples,
		traceXValues,filteredPeakRanges,filteredPeakRangeIndices,areaSplitPoints
	},

	(* Work with unitless data because it's faster *)
	unitlessTraces=Unitless[traces];

	(* Extract the peak position, area, and range from each peaks analysis. The traces are in alphabetical base order. *)
	pkPosAreasRanges=Join@@MapThread[
		Function[{base,packet},
			ArrayPad[
				Transpose@Lookup[packet,{Position,Area,PeakRangeStart,PeakRangeEnd}],
				{{0,0},{1,0}},
				base
			]
		],
		{{"A","C","G","T"},pkPackets}
	];

	(* Trim peaks where the peak is not the maximal signal at that cycle *)
	trimmedPeaks=If[MatchQ[pkPosAreasRanges,{}],
		{},
		Select[pkPosAreasRanges,checkMaxSignal[traceInterpolations,#[[2]],#[[1]]]&]
	];

	(* Sort the tuples of peak information by ascending position *)
	sortedPkTuples=SortBy[trimmedPeaks,Part[#,2]&];

	(* Track the last 10 accepted peaks to compute relative area according to the Phred algorithm *)
	lastTenPeakAreas={};

	(* Filter out noisy peaks, i.e. peaks with less than 10% of the avg area of the last 10 peaks, or less than 5% of the area of the last peak *)
	filteredPeakTuples=Map[
		Function[{basePositionAreaRange},Module[{base,pos,area,a,b,lastPeakArea,avgLastTenAreas},

			(* Extract components of the tuple being iterated over (range is [a,b]) *)
			{base,pos,area,a,b}=basePositionAreaRange;

			(* The last peak area is the most recently added one to the list of ten we track *)
			lastPeakArea=LastOrDefault[lastTenPeakAreas,area];

			(* The average of the last ten accepted peaks *)
			avgLastTenAreas=If[MatchQ[lastTenPeakAreas,{}],
				area,
				Mean[lastTenPeakAreas]
			];

			(* If the area cutoffs are met then update peak areas, otherwise return Nothing to filter out the current peak *)
			If[(area>0.10*avgLastTenAreas)&&(area>0.05*lastPeakArea),

				(* Update the last ten peak areas *)
				lastTenPeakAreas=If[Length[lastTenPeakAreas]>=10,
					Rest@Append[lastTenPeakAreas,area],
					Append[lastTenPeakAreas,area]
				];

				(* Return {base, position, relative area, range} tuples *)
				{base,pos,area/avgLastTenAreas,{a,b}},

				(* Return Nothing to filter out the current peak *)
				Nothing
			]
		]],
		sortedPkTuples
	];

	(* Assume that each trace has identical x-values, this is checked in a previous step *)
	traceXValues=Round[First/@First[unitlessTraces],stepSize];

	(* For each peak tuple, extract only the peak range *)
	filteredPeakRanges=Last/@filteredPeakTuples;

	(* For each peak range, find the indices it corresponds to it in the input trace data *)
	filteredPeakRangeIndices=Map[
		First@FirstPosition[traceXValues,Round[#,stepSize]]&,
		filteredPeakRanges,
		{2}
	];

	(* If the index matching process failed, return a fail state *)
	If[!MatchQ[Flatten[filteredPeakRangeIndices],{_Integer..}],
		Return[$Failed]
	];

	(* For each peak, find the trisection, quadrisection, and pentisection points of its peak range *)
	areaSplitPoints=MapThread[
		Function[{base,idxRange},
			getAreaDividers[Part[unitlessTraces,baseToIndex[base]],idxRange]
		],
		{First/@filteredPeakTuples,filteredPeakRangeIndices}
	];


	(* Return the observed peaks, a list of {base, position, relative area, {trisectionPts,quadPts,pentPts}} *)
	MapThread[
		{#1[[1]],#2[[2,2]],#1[[3]],#2}&,
		{filteredPeakTuples,areaSplitPoints}
	]
];



(* ::Subsubsection::Closed:: *)
(*getObservedPeaks*)

(* Given a single trace and a range of indices in that trace denoting a peak area, find the area trisection, quadrisection, and pentisection points *)
getAreaDividers[trace_,pkRange:{_Integer,_Integer}]:=Module[
	{positions,heights,cumulativeAreas,totalArea,getSplitPosition},

	(* Slice the trace data to get positions and heights of points in the peak *)
	{positions,heights}=Transpose@Part[trace,Span@@pkRange];

	(* Calculate the cumulative peak area by summing heights *)
	cumulativeAreas=Accumulate[heights];

	(* The total area is the last element in the cumulative area list *)
	totalArea=Last[cumulativeAreas];

	(* Helper subfunction for finding the absolute index of the point in the peak range which is closest to frac of peak area *)
	getSplitPosition[frac_]:=Part[positions,First@FirstPosition[cumulativeAreas,_?(#>=frac*totalArea&)]];

	(* Return the trisection, quadrisection, and pentisection points *)
	{
		{getSplitPosition[N[1/3]],getSplitPosition[N[2/3]]},
		{getSplitPosition[0.25],getSplitPosition[0.5],getSplitPosition[0.75]},
		{getSplitPosition[0.2],getSplitPosition[0.4],getSplitPosition[0.6],getSplitPosition[0.8]}
	}
];



(* ::Subsubsection::Closed:: *)
(*alignObservedPredictedPeaks*)

(* Assign an observed peak to each predicted peak using the multi-step Phred matching algorithm *)
alignObservedPredictedPeaks[
	predictedPeaks_,
	observedPeaks_,
	traceInterps_
]:=Module[
	{
		initialMatchedPeaks,bestObservedPeaks,matchedPeaks,unmatchedPeaks,
		optimizedPeaks,stillUnmatchedPeaks,calledPeaks,
		optimizedCalledPeaks,bestUncalledPeaks,unassignedPeaks,
		finalCalledPeaks,finalUnassignedPeaks,finalPredPeaks
	},

	(* Assign each observed peak tuple to the index of the predicted peak it is closest to {(idx\[Rule]pkTuple)..} *)
	initialMatchedPeaks=matchClosestPeaks[predictedPeaks,observedPeaks];

	(* Parse the matched peaks and return the best ones for each predicted peak (by relative area), and calculate shifts and new relative areas *)
	bestObservedPeaks=findBestClosestPeaks[predictedPeaks,initialMatchedPeaks];

	(* Find easy matches, i.e. observed peaks with |shift|<0.2 and relative area > 0.2 *)
	{matchedPeaks,unmatchedPeaks}=findEasyMatches[predictedPeaks,bestObservedPeaks];

	(* Use a dynamic programming algorithm to optimize the splitting and assignment of remaining picks *)
	{optimizedPeaks,stillUnmatchedPeaks}=optimizedUnmatchedPeaks[predictedPeaks,unmatchedPeaks];

	(* Combine the optimized peaks with the easy matched peaks *)
	calledPeaks=Join[
		matchedPeaks/.{Rule[x_,y_]:>Rule[x,Append[y,1]]},
		optimizedPeaks
	];

	(* Handle edge cases to assign as many of the still unmatched peaks as possible *)
	{optimizedCalledPeaks,bestUncalledPeaks}=cleanupUnmatchedPeaks[calledPeaks,stillUnmatchedPeaks,predictedPeaks,traceInterps];

	(* Any peaks in obs peaks which did not get assigned *)
	unassignedPeaks=Select[observedPeaks,
		!MemberQ[
			DeleteDuplicates[Part[#,;;2]&/@DeleteCases[optimizedCalledPeaks,None]],
			#[[;;2]]
		]&
	];

	(* Check if any of the unassigned peaks are valid for assignment *)
	{finalCalledPeaks,finalUnassignedPeaks,finalPredPeaks}=checkUnassignedPeaks[
		predictedPeaks,
		optimizedCalledPeaks,
		unassignedPeaks,
		traceInterps
	];

	(* Return the final calls, as well as the best uncalled peaks for mixed base determination *)
	{finalCalledPeaks,bestUncalledPeaks,finalUnassignedPeaks,finalPredPeaks}
];



(* ::Subsubsection::Closed:: *)
(*matchClosestPeaks*)

(* Return a list of {((idx of predicted peak)\[Rule]{base,pkPos,pkArea,divPts})..} mapping observed peaks to the closest predicted peak *)
matchClosestPeaks[predictedPeaks_,observedPeaks_]:=Module[
	{predictedPeakLocations,closestPeakIndices,closestObsPeaks},

	(* Extract only the positions of predicted peaks *)
	predictedPeakLocations=First/@predictedPeaks;

	(* Assign each observed peak to the index of the closest predicted peak *)
	closestPeakIndices=Map[
		{
			First@Nearest[
				(* A mapping of predicted peak locations to their index in the predicted peaks list *)
				Thread[predictedPeakLocations->Range[Length[predictedPeakLocations]]],
				(* Extract the peak position from observed peaks tuples *)
				Part[#,2]
			],
			#
		}&,
		observedPeaks
	];

	(* A mapping of idx (of a predicted peak) to one or more observed peaks that are closest to it *)
	closestObsPeaks=Normal@GroupBy[closestPeakIndices,First->Last]
];



(* ::Subsubsection::Closed:: *)
(*findBestClosestPeaks*)

(* Given a list of peaks closest to each predicted peak, select the one with the largest relative area. Then compute peak shifts and rescale relative areas. *)
findBestClosestPeaks[predictedPeaks_,matchedPeaks_]:=Module[
	{largestMatchedPeaks,bestPeakShifts,last10Areas,bestPeakNewAreas},

	(* For each set of matched peaks (to a predicted peak), select the peak tuple with the largest relative area *)
	largestMatchedPeaks=Map[
		Function[{idxToPeaks},
			First[idxToPeaks]->First@MaximalBy[Last[idxToPeaks],(Part[#,3]&)]
		],
		matchedPeaks
	];

	(* For the best observed peaks, compute the shift (pred pos - obs pos / local period) between observed and predicted peaks *)
	bestPeakShifts=Map[
		With[
			{
				idx=First[#],
				predPosPeriod=Part[predictedPeaks,First[#]],
				pkTuple=Last[#]
			},
			((First[predPosPeriod]-Part[pkTuple,2])/Last[predPosPeriod])
		]&,
		largestMatchedPeaks
	];

	(* Recalculate the relative areas of the best observed peaks by scaling to the average area of the last 10 best peaks *)
	last10Areas={};
	bestPeakNewAreas=Map[
		Function[{idxToPkTuple},Module[{idx,base,pos,area,divpts,avgLastTenAreas,newArea},
			(* Get the index of the predicted peak assigned to this peak *)
			idx=First[idxToPkTuple];

			(* Unwrap the peak tuple we are iterating over *)
			{base,pos,area,divpts}=Last[idxToPkTuple];

			(* The average of the last ten accepted peaks *)
			avgLastTenAreas=If[MatchQ[last10Areas,{}],
				area,
				Mean[last10Areas]
			];

			(* Rescale the relative area *)
			newArea=area/avgLastTenAreas;

			(* Update the last ten peak areas *)
			last10Areas=If[Length[last10Areas]>=10,
				Rest@Append[last10Areas,newArea],
				Append[last10Areas,newArea]
			];

			(* Return an index rule *)
			newArea
		]],
		largestMatchedPeaks
	];

	(* Reformat the data to be a list of <pred peak index> \[Rule] {base, shift, newArea, divPts} *)
	MapThread[
		Function[{idxToPkTuple,shift,newArea},
			Rule[
				First[idxToPkTuple],
				{Last[idxToPkTuple][[1]],Last[idxToPkTuple][[2]],shift,newArea,Last[idxToPkTuple][[4]]}
			]
		],
		{largestMatchedPeaks,bestPeakShifts,bestPeakNewAreas}
	]
];



(* ::Subsubsection::Closed:: *)
(*findEasyMatches*)

(* Select any groups of 4+ consecutive peaks with |shift|<0.2 and relative area>0.2 as "easy" matches to the predicted peaks *)
findEasyMatches[predictedPeaks_,bestObsPeaks_]:=Module[
	{
		predictedIndices,bestPeakTuples,alignedPeakBooleans,partialAlignedPeakIndices,
		alignedPeakIndices,consecutiveAlignedPeakIndices,easyPeakIndices,
		unassignedPeakIndices,assignedPeaks,unassignedPeaks
	},

	(* Extract only the indices of the observed peaks from the input *)
	predictedIndices=First/@bestObsPeaks;

	(* Extract only the peak tuples of best observed peaks from the inputs *)
	bestPeakTuples=Last/@bestObsPeaks;

	(* For each peak tuple, True if |shift| is less than 0.2 and relative area is greater than 0.2 *)
	alignedPeakBooleans=MapThread[
		Function[{base,pos,shift,newArea,divPts},
			Abs[shift]<=0.2&&newArea>=0.2
		],
		Transpose@bestPeakTuples
	];

	(* A mapping of predicted peak indices to whether or not the peaks are aligned by the "easy" criterion *)
	partialAlignedPeakIndices=MapThread[
		Rule[#1,#2]&,
		{predictedIndices,alignedPeakBooleans}
	];

	(* Expand the peak indices to all predicted peaks, defaulting False if no observed peaks were assign to a predicted peak s*)
	alignedPeakIndices=Lookup[
		partialAlignedPeakIndices,
		Range[Length[predictedPeaks]],
		False
	];

	(* Split the indices by consecutive runs *)
	consecutiveAlignedPeakIndices=Split[
		Flatten@Position[alignedPeakIndices,True],
		(#2-#1==1&)
	];

	(* Return only the indices of consecutive runs of at least 4 bases *)
	easyPeakIndices=Flatten@Select[consecutiveAlignedPeakIndices,Length[#]>=4&];

	(* Return the aligned peaks alongside the matched peak tuples *)
	assignedPeaks=Thread[easyPeakIndices->Lookup[bestObsPeaks,easyPeakIndices]];

	(* Unassigned peak indices *)
	unassignedPeakIndices=Complement[Range[Length[predictedPeaks]],easyPeakIndices];

	(* Unassigned predicted peaks, *)
	unassignedPeaks=Thread[unassignedPeakIndices->Lookup[bestObsPeaks,unassignedPeakIndices,None]];

	(* Return lists of the assigned peaks and unassigned peaks *)
	{assignedPeaks,unassignedPeaks}
];



(* ::Subsubsection::Closed:: *)
(*optimizedUnmatchedPeaks*)

(* Memoized DP algorithm for finding optimal peak splittings among unmatched peaks to match predicted peaks *)
optimizedUnmatchedPeaks[predictedPeaks_,unmatchedPeaks_]:=Module[
	{
		obsPeaks,predPeakIndices,predPeaks,contiguousPredPeaks,
		remainingObsPeaks,optimalAssigns,assignedPeaks
	},

	(* Observed peaks which have not been assigned yet, with relative area greater than 0.1 *)
	obsPeaks=DeleteCases[Last/@unmatchedPeaks,None|_?(Part[#,4]<=0.1&)];

	(* Indices of predicted peaks which have not been matched *)
	predPeakIndices=First/@unmatchedPeaks;

	(* {index,position,period}s of predicted peaks which have not been matched *)
	predPeaks=MapThread[
		Prepend[#2,#1]&,
		{predPeakIndices,Part[predictedPeaks,predPeakIndices]}
	];

	(* Divide the predicted peaks by contiguous runs *)
	contiguousPredPeaks=Split[
		predPeaks,
		First[#2]-First[#1]==1&
	];

	(* Track the obs peaks that have not yet been assigned *)
	remainingObsPeaks=obsPeaks;

	(* Determine the optimal assignment for each contiguous span *)
	optimalAssigns=Map[
		Module[{bestAssign,newlyAssignedPks,obsPeaksAssigned},
			(* Call the DP algorithm to get the best assignment *)
			bestAssign=optimalContiguousPeakAssignment[remainingObsPeaks,#];

			(* A list of peaks assigned by this assignment *)
			newlyAssignedPks=If[MatchQ[bestAssign,None],
				{},
				Last[bestAssign]
			];

			(* A list of observed peaks from the list of observed peaks which have been assigned *)
			obsPeaksAssigned=If[MatchQ[newlyAssignedPks,{}],{},Most/@(Last/@newlyAssignedPks)];

			(* Update the remaining observed peaks *)
			remainingObsPeaks=SortBy[Complement[remainingObsPeaks,obsPeaksAssigned],#[[2]]&];

			(* Return the best assignment, defaulting to Nothing if the best assignment was None *)
			If[MatchQ[bestAssign,None],
				Nothing,
				bestAssign
			]
		]&,
		contiguousPredPeaks
	];

	(* Return the joined assignments, defaulting to an empty list if no assignments could be made *)
	assignedPeaks=If[MatchQ[optimalAssigns,{}],
		{},
		Join@@(Last/@optimalAssigns)
	];

	(* Return newly assigned peaks, as well as peaks that could not be assigned *)
	{assignedPeaks,remainingObsPeaks}
];



(* ::Subsubsection::Closed:: *)
(*optimalContiguousPeakAssignment*)

(* Given contiguous predicted peaks, return the optimal assignment as {score,{idx->obsPeak...}}, or None if no assignment can be made *)
optimalContiguousPeakAssignment[{},_]:=None;
optimalContiguousPeakAssignment[_,{}]:=None;
optimalContiguousPeakAssignment[obsPks_,predPks_]:=Module[
	{
		pkCount,avgSpacing,predPkRange,obsPkRange,obsPksInRange,
		bestPeakAssign,bestAssignArray,remainingObsPksArray,
		checkSubproblem,checkRemainingPks
	},

	(* Total number of predicted peaks to match *)
	pkCount=Length[predPks];

	(* The average spacing of the predicted peaks to be matched *)
	avgSpacing=Mean[Part[#,3]&/@predPks];

	(* The minimum and maximum cycle read number (x-value) of the predicted peaks to be matched *)
	predPkRange=MinMax[Part[#,2]&/@predPks];

	(* Only observed peaks within this range of cycle reads (x-values) will be considered *)
	obsPkRange={First[predPkRange]-2.*avgSpacing,Last[predPkRange]+2.*avgSpacing};

	(* Select only observed peaks which are reasonable matches to the predicted peaks *)
	obsPksInRange=Select[obsPks,(First[obsPkRange]<Part[#,2]<Last[obsPkRange])&];

	(* Initialize sub-problem solutions *)
	bestAssignArray=Repeat[None,pkCount];
	remainingObsPksArray=Repeat[{},pkCount];

	(* Check for an existing subproblem solution *)
	checkSubproblem[0]:=None;
	checkSubproblem[n_Integer]:=Part[bestAssignArray,n];

	(* Check for remaining observed peaks *)
	checkRemainingPks[0]:=obsPksInRange;
	checkRemainingPks[n_Integer]:=Part[remainingObsPksArray,n];

	(*** The best peak assignment for predPks[[1;;n]], for dynamic programming algorithm ***)
	bestPeakAssign[n_Integer]:=Module[
		{splits,processedSplits,combinedSplits},

		(* Generate possible divisions of subproblems *)
		splits=generateSplits[n];

		(* Check for solution of existing subproblems (first part), then best solution for next assignment (last part) *)
		processedSplits=Map[
			{
				checkSubproblem[First[#]],
				findBestAssignment[
					checkRemainingPks[First[#]],
					Part[predPks,Last[#]]
				]
			}&,
			splits
		];

		(* Combine the splits *)
		combinedSplits=MapThread[
			Which[
				(* No assignments can be made, delete this entry *)
				MatchQ[#1,None]&&MatchQ[#2,None],Nothing,

				(* No assignments on one set, only keep the last set *)
				MatchQ[#1,None]&&MatchQ[#2,{NumericP,_}],#2,
				MatchQ[#1,{NumericP,_}]&&MatchQ[#2,None],#1,

				(* Join the predictions if both are good *)
				MatchQ[#1,{NumericP,_}]&&MatchQ[#2,{NumericP,_}],
					{First[#1]+First[#2],Join[Last[#1],Last[#2]]},

				(* Catch-all - set to Nothing to make sure nothing breaks*)
				_,Nothing
			]&,
			Transpose@processedSplits
		];

		(* If there are no valid splits, then the best assignment is None, else pick the one with best score *)
		If[MatchQ[combinedSplits,{}],
			None,
			First@MaximalBy[combinedSplits,First]
		]
	];

	(* DP time! Solve the subproblems in order *)
	Map[
		With[{bestAssign=bestPeakAssign[#]},
			(* Update best assignments *)
			bestAssignArray[[#]]=bestAssign;

			(* Update remaining peaks *)
			remainingObsPksArray[[#]]=If[MatchQ[bestAssign,None],
				(* If there was no assignment made, then use the previous subproblem obs peaks *)
				checkRemainingPks[#-1],
				(* Remove peaks assigned in this step *)
				Complement[
					checkRemainingPks[#-1],
					Most/@Last/@Last[bestAssign]
				]
			]
		]&,
		Range[pkCount]
	];

	(* The problem solution is the solution to the maximal subproblem *)
	checkSubproblem[pkCount]
];

(* Helper function generates split indices for the dynamic algorithm *)
generateSplits[n_Integer]:=Module[
	{splits},

	(* Generate the general split rule for splitting of peaks up to 4x *)
	splits=Map[
		{#-1,#;;n}&,
		Range[n-3,n,1]
	];

	(* Strip edge cases *)
	Select[splits,Part[#,-1,1]>0&]
];

(* Given a list of unmatched observed peaks and a single predicted peak, find the best single match, returning None if none are possible *)
findBestAssignment[{},___]:=None;
findBestAssignment[obsPks_,predPks_?(Length[#]==1&)]:=Module[
	{peakScores,bestScore,bestPeak},

	(* Compute the alignment score *)
	peakScores=Map[
		{scoreAssignment[#,First[predPks]],#}&,
		obsPks
	];

	(* Select the best peak according to its alignment score *)
	{bestScore,bestPeak}=First@MaximalBy[peakScores,First];

	(* Negative scores are out of range (no satisfactory match), so if the best score is negative return None *)
	If[bestScore<=0.0,
		None,
		{bestScore,{predPks[[1,1]]->Append[bestPeak,1]}}
	]
];

(* Given a list of unmatched observed peaks and a multiple predicted peak, find the best area-split match, returning None if none are possible *)
findBestAssignment[obsPks_,predPks_?(Length[#]>1&)]:=Module[
	{numPks,splitIdx,bigObsPks,peakScores,bestScore,bestPeak},

	(* The number of peaks to fit to. Since numPks>1, we are trying to split observed peaks and match *)
	numPks=Length[predPks];

	(* The index of the appropriate split pts, 2 peaks \[Rule] trisection, 3 peaks\[Rule]quadrisection, etc. *)
	splitIdx=numPks-1;

	(* For peak splitting, we only consider observed peaks with relative area > 1.6 *)
	bigObsPks=Select[obsPks,Part[#,4]>=1.6&];

	(* Return None if there are no peaks big enough to split *)
	If[MatchQ[bigObsPks,{}],Return[None]];

	(* Pairs of peaks (to split into npeaks) and the resulting alignment scores *)
	peakScores=Map[
		{scoreAssignment[#,predPks,numPks],#}&,
		bigObsPks
	];

	(* Select the best peak according to its alignment score *)
	{bestScore,bestPeak}=First@MaximalBy[peakScores,First];

	(* Negative scores are out of range (no satisfactory match), so if the best score is negative return None *)
	If[bestScore<=0.0,
		None,
		{bestScore,Rule[#,Append[bestPeak,numPks]]&/@(First/@predPks)}
	]
];

(* Score assignment of an observed peak to a predicted peak based relative area and shift *)
scoreAssignment[obsPeak_,predPeak_]:=Module[
	{
		base,pos,shift,area,divPts,predIdx,predPos,predPeriod,
		newShift,shiftFactor
	},

	(* Unwrap the tuple inputs *)
	{base,pos,shift,area,divPts}=obsPeak;
	{predIdx,predPos,predPeriod}=predPeak;

	(* The shift of this assignment *)
	newShift=(predPos-pos)/predPeriod;

	(* Penalty factor <1 to apply to the score *)
	shiftFactor=If[newShift<0,
		1.0+4.0*newShift,
		1.0-4.0*newShift/3.0
	];

	(* Score is the observed peak area times the shift factor *)
	area*shiftFactor
];

(* Score assignment of an observed peak to a predicted peak based relative area and shift *)
scoreAssignment[obsPeak_,predPks_,numPks_Integer]:=Module[
	{
		base,pos,shift,area,divPts,predIdxs,predPositions,predPeriods,
		divPositions,newShifts,maxShiftChange,shiftFactors
	},

	(* Unwrap the tuple inputs *)
	{base,pos,shift,area,divPts}=obsPeak;
	{predIdxs,predPositions,predPeriods}=Transpose@predPks;

	(* Positions of dividing the observed peak into numPks*)
	divPositions=divPts[[numPks-1]];

	(* Calculate the shift between each division point and the prediction position *)
	newShifts=MapThread[
		((#1-#2)/#3)&,
		{predPositions,divPositions,predPeriods}
	];

	(* Compute the max shift changes within the peak division *)
	maxShiftChange=Max[Differences[newShifts]];

	(* Set the score to -100 if any of the shift fall outside the range -0.5 to 2.1, or if the max shift change is >=0.7 *)
	If[!(And@@Map[-0.5<#<2.1&,newShifts])||maxShiftChange>=0.7,
		Return[-100]
	];

	(* Calculate shift factors *)
	shiftFactors=Map[
		If[#<0,1.0+4.0*#,1-4.0*#/3.0]&,
		newShifts
	];

	(* Score is the shift factor multiplied by the subdivided area for each split *)
	Total[shiftFactors]*(area/numPks)
];



(* ::Subsubsection::Closed:: *)
(*cleanupUnmatchedPeaks*)

(* For the remaining unassigned predPeaks, consider splitting already-aligned "easy" matches and default to the best option when available *)
cleanupUnmatchedPeaks[matchedPks_,unmatchedPks_,predPks_,traceInterps_]:=Module[
	{
		unmatchedClosestPredIdxs,predIdxToUnmatched,calledPks,bestObsPks,bestUncalledPks,
		unassignedPredPkIdxs,orderedUnassignedIdxs,currMatchedPks,newAssignments
	},

	(* Indices of the predicted peaks closest to the still unmatched peaks *)
	unmatchedClosestPredIdxs=MapIndexed[
		{
			First[#2],
			First@FirstPosition[First/@predPks,First@Nearest[First/@predPks,#1[[2]]]]
		}&,
		unmatchedPks
	];

	(* Reverse mapping of predicted peaks to the unmatched peak groups that are closest to that predicted peak *)
	predIdxToUnmatched=Normal@GroupBy[unmatchedClosestPredIdxs,Last->(Part[unmatchedPks,First[#]]&)];

	(* The called peak for each of the predIdx, with None if the predicted peak was not called yet *)
	calledPks=Lookup[matchedPks,First/@predIdxToUnmatched,None];

	(* The best (by area) observed peak of each predicted peak to check in this step, using None if it has already been called *)
	bestObsPks=MapThread[
		First[#1]->If[MatchQ[#2,None],
			First@MaximalBy[Last[#1],Function[{pk},pk[[4]]]],
			None
		]&,
		{predIdxToUnmatched,calledPks}
	];

	(* The best uncalled peak for each predicted peak by relative area *)
	bestUncalledPks=MapThread[
		First[#1]->FirstOrDefault[
			MaximalBy[
				If[MatchQ[Last[#2],None],Last[#1],Complement[Last[#1],{Last[#2]}]],
				Function[{pk},pk[[4]]]
			],
			None
		]&,
		{predIdxToUnmatched,bestObsPks}
	];

	(* Indices of predicted peaks that have not been assigned yet *)
	unassignedPredPkIdxs=Complement[Range[Length[predPks]],First/@matchedPks];

	(* Reorder the unassigned indices so that those corresponding to unmatched peaks are tested first. *)
	orderedUnassignedIdxs=Join[
		Intersection[predIdxToUnmatched,unassignedPredPkIdxs],
		Complement[unassignedPredPkIdxs,predIdxToUnmatched]
	];

	(* Keep track of the current list of matched peaks *)
	currMatchedPks=matchedPks;

	(* Go through the unassigned predicted peaks and apply our best guess *)
	newAssignments=Map[
		Module[{idx,bestObsPeak,leftNeighbor,rightNeighbor,leftArea,rightArea,newAssign},
			(* Indexing *)
			idx=#;
			bestObsPeak=Lookup[bestObsPks,idx,None];
			leftNeighbor=Lookup[currMatchedPks,idx-1,None];
			rightNeighbor=Lookup[currMatchedPks,idx+1,None];

			(* If no neighbor or maximal splitting is reached, or if left peak isn't the maximal signal at the location idx, then default to zero *)
			leftArea=If[MatchQ[leftNeighbor,None]||leftNeighbor[[6]]>=4||(!checkMaxSignal[traceInterps,predPks[[idx,1]],leftNeighbor[[1]]]),
				0.0,
				leftNeighbor[[4]]
			];

			(* If no neighbor or maximal splitting is reached, or if right peak isn't the maximal signal at the location idx, then default to zero *)
			rightArea=If[MatchQ[rightNeighbor,None]||rightNeighbor[[6]]>=4||(!checkMaxSignal[traceInterps,predPks[[idx,1]],rightNeighbor[[1]]]),
				0.0,
				rightNeighbor[[4]]
			];

			(* New assignment for idx *)
			newAssign=idx->Which[
				(* Use the best obs peak if available *)
				MatchQ[bestObsPeak,Except[None]],Append[bestObsPeak,1],

				(* Split the left peak if the left area exceeds threshold and bigger than right area  *)
				leftArea>=1.4&&leftArea>rightArea,Append[Most[leftNeighbor],Last[leftNeighbor]+1],

				(* Otherwise split the right peak if the right area exceeds threshold *)
				rightArea>=1.4,Append[Most[rightNeighbor],Last[rightNeighbor]+1],

				(* Default to no assignment *)
				True,None
			];

			(* Update the list of matched peaks *)
			currMatchedPks=Append[currMatchedPks,newAssign];

			(* Return the new assignment *)
			newAssign
		]&,
		orderedUnassignedIdxs
	];

	(* Return the final assignments plus best uncalled peaks *)
	{Last/@SortBy[currMatchedPks,First],bestUncalledPks}
];



(* ::Subsubsection::Closed:: *)
(*checkUnassignedPeaks*)

(* Phred algorithm step IV - check if any of the unassigned peaks are resolved and could be inserted *)
checkUnassignedPeaks[predPks_,calledPks_,unassignedPks_,traceInterps_]:=Module[
	{
		calledPkPositions,onlyMaxPeaks,nearestPkIndices,nearestPkBases,
		pksWithGoodNeighbors,maxSubsignalIntensity,goodUncalledPks,
		insertChecks,insertIndices,insertRules,updatedUnassignedPks,updatedCalledPks,updatedPredPks
	},

	(* Only the positions of called peaks *)
	calledPkPositions=First/@predPks;

	(* Filter out unassigned peaks which do not have the maximal intensity at their positions *)
	onlyMaxPeaks=Select[unassignedPks,checkMaxSignal[traceInterps,#[[2]],#[[1]]]&];

	(* Indices of the two nearest called peaks to each maximal uncalled peak *)
	nearestPkIndices=Map[
		{
			First@Nearest[calledPkPositions->"Index",#[[2]],DistanceFunction->Function[{x,y},If[x-y>0,Abs[x-y],10*Abs[x-y]]]],
			First@Nearest[calledPkPositions->"Index",#[[2]],DistanceFunction->Function[{x,y},If[x-y<0,Abs[x-y],10*Abs[x-y]]]]
		}&,
		onlyMaxPeaks
	];

	(* The bases assigned the two nearest called peaks to each maximal uncalled peak *)
	nearestPkBases=Map[
		{
			FirstOrDefault[Part[calledPks,First[#]],"N"],
			FirstOrDefault[Part[calledPks,Last[#]],"N"]
		}&,
		nearestPkIndices
	];

	(* Select only unassigned peaks whose neighbors are both non-N, and at least one is different *)
	pksWithGoodNeighbors=MapThread[
		Function[{uncalledPk,nearestBases},
			If[MemberQ[nearestBases,"N"]||And@@(First[uncalledPk]==#&/@nearestBases),
				Nothing,
				uncalledPk
			]
		],
		{onlyMaxPeaks,nearestPkBases}
	];

	(* Maximum subsignal intensity for each peak with good neighbors (ratio of largest other channel intensity to assigned channel intensity) *)
	maxSubsignalIntensity=Part[#,1,-1]&/@Map[
		Function[{baseToIntensityRules},MaximalBy[baseToIntensityRules,Last]],
		maxSubsignalRatios[traceInterps,#[[2]],#[[1]]]&/@pksWithGoodNeighbors
	];

	(* Filter out uncalled peaks where the next highest intensity (i.e. not to the peak) is more than 50% *)
	goodUncalledPks=MapThread[
		If[#2<=0.5,
			#1,
			Nothing
		]&,
		{pksWithGoodNeighbors,maxSubsignalIntensity}
	];

	(* Pre-processing to determine which index to insert each good peak at *)
	insertChecks=Map[
		{
			First@Nearest[calledPkPositions->"Index",#[[2]],DistanceFunction->Function[{x,y},If[x-y>0,Abs[x-y],10*Abs[x-y]]]],
			First@Nearest[calledPkPositions->"Index",#[[2]],DistanceFunction->Function[{x,y},If[x-y<0,Abs[x-y],10*Abs[x-y]]]]
		}&,
		goodUncalledPks
	];

	(* Index to insert each good peak at *)
	insertIndices=Map[
		Switch[#,
			(* Less than the first peak *)
			{1,1},1,
			(* Greater than the last peak *)
			{Length[calledPkPositions],Length[calledPkPositions]},Length[calledPkPositions]+1,
			(* Otherwise, take the larger index *)
			_,Max[#]
		]&,
		insertChecks
	];

	(* Rules for insertion, sorted by declining index *)
	insertRules=ReverseSortBy[
		Thread[insertIndices->goodUncalledPks],
		First
	];

	(* Initialize updates *)
	updatedPredPks=predPks;
	updatedCalledPks=calledPks;

	(* Map in reverse index order to insert the required updates *)
	Map[
		With[{idx=First[#],pkTuple=Last[#]},
			updatedPredPks=Insert[updatedPredPks,{pkTuple[[2]],predPks[[Min[idx,Length[predPks]]]]},idx];
			updatedCalledPks=Insert[updatedCalledPks,Append[pkTuple,1],idx];
		]&,
		insertRules
	];

	(* Removed the good uncalled peaks from unassigned peaks since we will be inserting these *)
	updatedUnassignedPks=Complement[unassignedPks,goodUncalledPks];

	(* Return the updated called and unassigned peaks *)
	{updatedCalledPks,updatedUnassignedPks,updatedPredPks}
];



(* ::Subsection::Closed:: *)
(*Phred Quality Scorem*)

(* --------------------------- *)
(* --- PHRED QUALITY SCORE --- *)
(* --------------------------- *)

(* Compute the Phred quality score from called/unassigned peaks, traces, and interpolations *)
phredQualityScore[calledPks_,unassignedPks_,traces_,interpFuncs_]:=Module[
	{
		uncalledPks,calledPkHeights,uncalledPkHeights,
		calledPksWithHeights,uncalledPksWithHeights,phredParams,phredQualityScores
	},

	(* Reformat the unassigned peaks in the same {pos,base} format as calledPks *)
	uncalledPks={#[[2]],#[[1]]}&/@unassignedPks;

	(* Compute the peak amplitudes of called and uncalled peaks rom the interpolation functions *)
	calledPkHeights=interpolatePeakHeights[calledPks,interpFuncs];
	uncalledPkHeights=interpolatePeakHeights[uncalledPks,interpFuncs];

	(* Pair the called and unassigned peak positions with their heights *)
	calledPksWithHeights=MapThread[Append[#1,#2]&,{calledPks,calledPkHeights}];
	uncalledPksWithHeights=MapThread[Append[#1,#2]&,{uncalledPks,uncalledPkHeights}];

	(* Compute the Phred Trace parameters *)
	phredParams=computePhredTraceParameters[
		calledPksWithHeights,
		uncalledPksWithHeights,
		traces,
		interpFuncs
	];

	(* Compute the quality score from the Phred trace parameters *)
	phredQualityScores=Map[computePhredScore[#]&,phredParams];

	(* Return the quality scores and parameter array *)
	{phredQualityScores,phredParams}
];



(* ::Subsubsection::Closed:: *)
(*interpolatePeakHeights*)

(* Given a list of {position, base} peak identifiers, use the interpolation functions (in A,C,G,T order) to get peak amplitudes *)
interpolatePeakHeights[pkPosBasePairs_,interpFuncs_]:=Map[
	Function[{posBase},
		Switch[Last[posBase],
			"A",interpFuncs[[1]][First@posBase],
			"C",interpFuncs[[2]][First@posBase],
			"G",interpFuncs[[3]][First@posBase],
			"T",interpFuncs[[4]][First@posBase],
			"N",Max[interpFuncs[[#]][First@posBase]&/@Range[4]]
		]
	],
	pkPosBasePairs
];



(* ::Subsubsection::Closed:: *)
(*computePhredTraceParameters*)

(* Compute the four Phred metrics used to determine quality value - peak spacing, 7peak ratio, 3peak ratio, and peak resolution *)
computePhredTraceParameters[calledPkPosHeights_,uncalledPkPosHeights_,traces_,interpFuncs_]:=Module[
	{
		paddedPkPosSeven,sevenPeakWindows,paddedPkPosThree,threePeakWindows,pkPairUnresolved,
		traceMaxes,traceCycles,adjacentPeakPairs,adjacentPeakSpans,smallestIntermediateIntensity,pkUnresolved,
		unresolvedCalledPks,leftCounter,leftDistance,rightCounter,rightDistance,
		peakSpacingParams,sevenPeakRatios,threePeakRatios,peakResolutionParams
	},

	(*** Pre-compute three and seven-peak contiguous windows, plus unresolved called peaks  ***)

	(* Get the peak positions of the called peaks, and pad with three None in both directions *)
	paddedPkPosSeven=ArrayPad[calledPkPosHeights,{{3,3},{0,0}},None];

	(* A list of seven-peak position windows centered on each peak, with Nones removed *)
	sevenPeakWindows=Partition[paddedPkPosSeven,7,1]/.{{None..}->Nothing};

	(* Get the peak positions of the called peaks, and pad with one None in both directions *)
	paddedPkPosThree=ArrayPad[calledPkPosHeights,{{1,1},{0,0}},None];

	(* A list of three-peak position windows centered on each peak, with Nones removed *)
	threePeakWindows=Partition[paddedPkPosThree,3,1]/.{{None..}->Nothing};

	(* Maximum value of each trace at each position, assuming same x-axis points *)
	traceMaxes=MapThread[
		Function[{ptA,ptC,ptG,ptT},
			{First[ptA],Max[Last/@{ptA,ptC,ptG,ptT}]}
		],
		traces
	];

	(* The cycle reads at which we have data *)
	traceCycles=First/@traceMaxes;

	(* Pairs of adjacent called peaks *)
	adjacentPeakPairs=Partition[calledPkPosHeights,2,1];

	(* Spans defining the regions between adjacent peaks *)
	adjacentPeakSpans=Map[
		(* Awful indexing necessary because instrument deletes datapoints for invalid reads *)
		Span[
			First@FirstPosition[traceCycles,First@Nearest[traceCycles,Ceiling[#[[1,1]]]]],
			First@FirstPosition[traceCycles,First@Nearest[traceCycles,Floor[#[[-1,1]]]]]
		]&,
		adjacentPeakPairs
	];

	(* The smallest value of maximal intensity in each peak range *)
	smallestIntermediateIntensity=Map[
		Min[Last/@Part[traceMaxes,#]]&,
		adjacentPeakSpans
	];

	(* True or False depending on if the pair of peaks fails to meet the unresolved criterion *)
	pkPairUnresolved=MapThread[
		!And[
			#2<#1[[1,3]],
			#2<#1[[-1,3]]
		]&,
		{adjacentPeakPairs,smallestIntermediateIntensity}
	];

	(* The booleans in pkPairResolved are for {1,2},{2,3}, etc. A peak is unresolved if either of its neighbors make an unresolved pair *)
	pkUnresolved=MapThread[
		Or,
		{Append[pkPairUnresolved,False],RotateRight@Append[pkPairUnresolved,False]}
	];

	(* Set all unassignable peaks N to unresolved as well *)
	unresolvedCalledPks=MapThread[
		(Last[#1]==="N")||#2&,
		{calledPkPosHeights,pkUnresolved}
	];

	(* Distance (in called bases) to the nearest unresolved base on the left *)
	leftCounter=Infinity;
	leftDistance=Map[
	If[#,leftCounter=0,leftCounter=leftCounter+1]&,
		unresolvedCalledPks
	];

	(* Distance (in called bases) to the nearest unresolved base on the right *)
	rightCounter=Infinity;
	rightDistance=Reverse@Map[
		If[#,rightCounter=0,rightCounter=rightCounter+1]&,
		Reverse@unresolvedCalledPks
	];

	(*** Compute the QV metrics (features for the QV model) ***)

	(* For each 7peak window, the ratio of the largest peak spacing to the smallest peak spacing *)
	peakSpacingParams=Map[
		Function[{pkRange},
			(#[[2]]/#[[1]])&@MinMax[Differences[First/@pkRange]]
		],
		sevenPeakWindows
	];

	(* For each 7peak window, the ratio of the largest uncalled peak amplitude to the smallest called peak amplitude *)
	sevenPeakRatios=MapThread[
		Function[{calledPk,pkRange},
			If[MatchQ[calledPk[[2]],"N"]||MatchQ[Min[Last/@pkRange],0.0],
				100.0,
				largestUncalledPeakAmplitude[calledPk,pkRange,uncalledPkPosHeights,interpFuncs]/Min[Last/@pkRange]
			]
		],
		{calledPkPosHeights,sevenPeakWindows}
	];

	(* For each 7peak window, the ratio of the largest uncalled peak amplitude to the smallest called peak amplitude *)
	threePeakRatios=MapThread[
		Function[{calledPk,pkRange},
			If[MatchQ[calledPk[[2]],"N"]||MatchQ[Min[Last/@pkRange],0.0],
				100.0,
				largestUncalledPeakAmplitude[calledPk,pkRange,uncalledPkPosHeights,interpFuncs]/Min[Last/@pkRange]
			]
		],
		{calledPkPosHeights,threePeakWindows}
	];

	(* The peak resolution parameter is the negative of the smallest distance to the nearest unresolved base. *)
	peakResolutionParams=N@MapThread[
		(* The maximum allowed distance is the number of bases in the trace divided by two *)
		-Min[#1,#2,Length[calledPkPosHeights]/2.0]&,
		{leftDistance,rightDistance}
	];

	(* Return a list of the four phred metrics for each called peak *)
	Transpose@{
		peakSpacingParams,
		sevenPeakRatios,
		threePeakRatios,
		peakResolutionParams
	}
];

(* Given a pkRange centered on calledPk, find the largest amplitude among uncalled peaks, defaulting to the raw trace value at that point if unavailable *)
largestUncalledPeakAmplitude[calledPk_,pkRange_,uncalledPks_,interpFuncs_]:=Module[
	{otherBases,pkRangeMin,pkRangeMax,uncalledPksInRange,smallestCalled,nextLargestAtCall},

	(* A list of all bases other than the one assigned to the currently called peak *)
	otherBases=DeleteCases[{"A","C","G","T"},calledPk[[2]]];

	(* Minimum and maximum x value in this peak range *)
	{pkRangeMin,pkRangeMax}=MinMax[First/@pkRange];

	(* Select any uncalled peaks in the range *)
	uncalledPksInRange=Select[uncalledPks,pkRangeMin<=First[#]<=pkRangeMax&];

	(* The largest amplitude among other traces than the ID at the position of the called Pk *)
	nextLargestAtCall=Max[interpolatePeakHeights[{First[calledPk],#}&/@otherBases,interpFuncs]];

	(* Return the amplitude of the largest uncalled peak, defaulting to the peak-center value of the called peak *)
	If[MatchQ[uncalledPksInRange,{}],
		nextLargestAtCall,
		Max[Last/@uncalledPksInRange]
	]
];



(* ::Subsubsection::Closed:: *)
(*computePhredScore*)

(* Compute phred scores from the set of four phred parameters *)
computePhredScore[params:{{NumericP,NumericP,NumericP,NumericP}..}]:=computePhredScore/@params;
computePhredScore[fourPars:{NumericP,NumericP,NumericP,NumericP}]:=Module[
	{phredTable},

	(* TODO: Temporary trained parameters while learning model is being hooked up *)
	phredTable={
		31->{1.33344,0.491277,101.,-2.},
		21->{1.01675,101.,0.762593,0.},
		17->{1.01675,101.,0.1867,3.08},
		14->{1.04651,0.491277,101.,0.},
		12->{1.02449,0.225008,101.,3.08},
		11->{1.04651,0.491277,101.,3.08},
		11->{1.02449,101.,0.762593,0.},
		10->{1.33344,101.,101.,-2.},
		9->{1.33344,0.225008,101.,3.08},
		8->{1.33344,1.03264,101.,0.},
		7->{1.02449,101.,0.373847,3.08},
		6->{1.33344,101.,0.762593,0.},
		5->{1.33344,1.03264,0.373847,3.08},
		3->{1.04651,101.,101.,3.08},
		4->{1.33344,101.,101.,0.},
		3->{1.33344,101.,0.373847,3.08},
		2->{1.33344,101.,101.,3.08}
	};

	(* Look up the first line in the table which the paramaters are all less than, and return zero if none are found *)
	First@FirstOrDefault[
  	Select[phredTable, And@@Thread[fourPars<Last[#]]&],
		0->{\[Infinity],\[Infinity],\[Infinity],\[Infinity]}
	]
];



(* ::Subsection::Closed:: *)
(*Miscellaneous Helper Functions*)

(* Convert each DNA base to an index 1-4, going in alphabetical order *)
baseToIndex[bases:{("A"|"C"|"G"|"T")..}]:=baseToIndex/@bases;
baseToIndex[base:"A"|"C"|"G"|"T"]:=Switch[base,
	"A",1,
	"C",2,
	"G",3,
	"T",4
];

(* Using interpolations, check that at "cycle" the signal of "base" is maximal among the four channels *)
checkMaxSignal[interps:Repeated[_,4],cycle:NumericP,base:"A"|"C"|"G"|"T"]:=(
	Part[interps,baseToIndex[base]][cycle]>=Max[#[cycle]&/@interps]
);

(* Using interpolations, return the ratio of the smaller intensities to the maximal intensity at this position *)
maxSubsignalRatios[interps:Repeated[_,4],cycle:NumericP,base:"A"|"C"|"G"|"T"]:=Map[
	Function[{b},
		b->N[Part[interps,baseToIndex[b]][cycle]/Max[#[cycle]&/@interps]]
	],
	Complement[{"A","C","G","T"},{base}]
];



(* ::Subsection::Closed:: *)
(*Miscellaneous Test Code*)

(* Visualization of sine wave fit for testing purposes only *)
vizFit[wave_,{p_,s_}]:=EmeraldListLinePlot[
	{wave,Table[{x,Sin[(2\[Pi]/p)(x+s)]},{x,First/@wave}]},
	PlotStyle->{Black,{Red,Opacity[0.3]}},
	PlotLabel->"Sine wave fit to damped square wave"
];

(* Wrap an expression in this to echo its absolute run time *)
SetAttributes[profileRunTime, HoldAll];
profileRunTime[expr:___]:=Echo[
	(StringTake[#,;;Min[StringLength[#],100]]&@ToString[Hold[expr]])<>": "<>ToString[First@AbsoluteTiming[ReleaseHold[expr]]]<>" s."
];



(* ::Section:: *)
(*AnalyzeDNASequencingOptions*)

(* Options shared with parent function, with additional OutputFormat option *)
DefineOptions[AnalyzeDNASequencingOptions,
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
		AnalyzeDNASequencing
	}
];

(* Call parent function with Output->Options and format output *)
AnalyzeDNASequencingOptions[
	myInputs:analyzeDNASequencingInputP,
	myOptions:OptionsPattern[AnalyzeDNASequencingOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove the OutputFormat option *)
	preparedOptions=Normal@KeyDrop[
		ReplaceRule[listedOptions,Output->Options],
		{OutputFormat}
	];

	(* Get the resolved options from AnalyzeDNASequencing *)
	resolvedOptions=DeleteCases[AnalyzeDNASequencing[myInputs,preparedOptions],(Output->_)];

	(* Return the options as a list or table, depending on the option format *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeDNASequencing],
		resolvedOptions
	]
];



(* ::Section:: *)
(*AnalyzeDNASequencingPreview*)

(* Options shared with parent function *)
DefineOptions[AnalyzeDNASequencingPreview,
	SharedOptions:>{
		AnalyzeDNASequencing
	}
];

(* Call parent function with Output->Preview *)
AnalyzeDNASequencingPreview[
	myInputs:analyzeDNASequencingInputP,
	myOptions:OptionsPattern[AnalyzeDNASequencingPreview]
]:=Module[{listedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Call the parent function with Output->Preview *)
	AnalyzeDNASequencing[myInputs,ReplaceRule[listedOptions,Output->Preview]]
];



(* ::Section:: *)
(*ValidAnalyzeDNASequencingQ*)

(* Options shared with parent function, plus additional Verbose and OutputFormat options *)
DefineOptions[ValidAnalyzeDNASequencingQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{
		AnalyzeDNASequencing
	}
];

(* Use OutputFormat->Tests to determine if parent function call is valid, +format the output *)
ValidAnalyzeDNASequencingQ[
	myInputs:analyzeDNASequencingInputP,
	myOptions:OptionsPattern[ValidAnalyzeDNASequencingQ]
]:=Module[
	{
		listedOptions,preparedOptions,analyzeDNASequencingTests,
		initialTestDescription,allTests,verbose,outputFormat
	},

	(* Ensure that options are provided as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output, Verbose, and OutputFormat options from provided options *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Call AnalyzeDNASequencing with Output->Tests to get a list of EmeraldTest objects *)
	analyzeDNASequencingTests=AnalyzeDNASequencing[myInputs,Append[preparedOptions,Output->Tests]];

	(* Define general test description *)
	initialTestDescription="All provided inputs and options match their provided patterns (no further testing is possible if this test fails):";

	(* Make a list of all tests, including the blanket correctness check *)
	allTests=If[MatchQ[analyzeDNASequencingTests,$Failed],
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
			Cases[Flatten[{analyzeDNASequencingTests,voqWarnings}],_EmeraldTest]
		]
	];

	(* Look up options exclusive to running tests in the validQ function *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[
		RunUnitTest[<|"ValidAnalyzeDNASequencingQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],
		"ValidAnalyzeDNASequencingQ"
	]
];
