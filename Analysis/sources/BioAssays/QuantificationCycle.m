(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*AnalyzeQuantificationCycle*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeQuantificationCycle Options and Messages*)


DefineOptions[AnalyzeQuantificationCycle,
	Options:>{
		(*===Method===*)
		{
			OptionName->Method,
			Default->Threshold,
			Description->"The calculation method to be used for quantification cycle analysis.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Threshold|InflectionPoint],
			Category->"Method"
		},
		{
			OptionName->Domain,
			Default->Automatic,
			Description->"The first and last cycle delimiting the range for analysis.",
			ResolutionDescription->"Automatically set to the first and last cycle from the quantitative polymerase chain reaction (qPCR) data.",
			AllowNull->False,
			Widget->{
				"Analysis Start Cycle"->Widget[Type->Quantity,Pattern:>GreaterP[0 Cycle,1 Cycle],Units->{Cycle,{Cycle}}],
				"Analysis End Cycle"->Widget[Type->Quantity,Pattern:>GreaterP[0 Cycle,1 Cycle],Units->{Cycle,{Cycle}}]
			},
			Category->"Method"
		},
		{
			OptionName->BaselineDomain,
			Default->Automatic,
			Description->"The first and last cycle delimiting the range of the baseline.",
			ResolutionDescription->"Automatically set to {'the larger of 3 Cycles and the first cycle of Domain', 15 Cycle}.",
			AllowNull->False,
			Widget->{
				"Baseline Start Cycle"->Widget[Type->Quantity,Pattern:>GreaterP[0 Cycle,1 Cycle],Units->{Cycle,{Cycle}}],
				"Baseline End Cycle"->Widget[Type->Quantity,Pattern:>GreaterP[0 Cycle,1 Cycle],Units->{Cycle,{Cycle}}]
			},
			Category->"Method"
		},
		{
			OptionName->SmoothingRadius,
			Default->Automatic,
			Description->"The radius in cycles for GaussianFilter smoothing of the normalized and baseline-subtracted amplification curves.",
			ResolutionDescription->"Automatically set to 2 cycles if Method is set to InflectionPoint, or Null otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Cycle,1 Cycle],Units->{Cycle,{Cycle}}],
			Category->"Method"
		},

		(*The amplification targets and the associated thresholds*)
		IndexMatching[
			IndexMatchingParent->ForwardPrimer,
			{
				OptionName->ForwardPrimer,
				Default->Automatic,
				Description->"The forward primer used to amplify the target sequence.",
				ResolutionDescription->"Automatically set to unique forward primers from the quantitative polymerase chain reaction (qPCR) data if Method is set to Threshold, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Molecule]}]],
				Category->"Method"
			},
			{
				OptionName->ReversePrimer,
				Default->Automatic,
				Description->"The reverse primer used to amplify the target sequence.",
				ResolutionDescription->"Automatically set to unique reverse primers from the quantitative polymerase chain reaction (qPCR) data if Method is set to Threshold, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Molecule]}]],
				Category->"Method"
			},
			{
				OptionName->Probe,
				Default->Automatic,
				Description->"The reporter probe (composed of a short, sequence-specific oligomer conjugated with a reporter and quencher) used to quantify the target sequence.",
				ResolutionDescription->"Automatically set to unique probes from the quantitative polymerase chain reaction (qPCR) data if Method is set to Threshold, or Null otherwise.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Molecule]}]],
				Category->"Method"
			},
			{
				OptionName->Threshold,
				Default->Automatic,
				Description->"The fluorescence signal significantly above baseline fluorescence at which amplification is considered to have begun.",
				ResolutionDescription->"Automatically set to 10*(standard deviation of the normalized and baseline-subtracted mean fluorescence value in BaselineDomain) for each target if Method is set to Threshold, or Null otherwise.",
				AllowNull->True,
				Category->"Method",
				Widget->Widget[Type->Quantity,Pattern:>GreaterP[0 RFU],Units->{RFU,{RFU}}]
			}
		],
		{
			OptionName->Template,
			Default->Null,
			Description->"The template quantification cycle analysis object whose methodology should be reproduced in running this analysis. Option values will be inherited from the template analysis object, but can be individually overridden by directly specifying values for the options for this analysis function.",
			AllowNull->True,
			Category->"Method",
			Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
		},


		(*Shared Options*)
		OutputOption,
		UploadOption
	}
];


Error::MethodMismatch="If Method->Threshold, SmoothingRadius cannot be specified and Threshold cannot be Null; if Method->InflectionPoint, SmoothingRadius cannot be Null and Threshold cannot be specified. Please change the values of these options or leave them unspecified to be set automatically.";
Error::ThresholdMethodTargetMissing="If Method->Threshold, ForwardPrimer and ReversePrimer cannot be Null. Please change the values of these options or leave them unspecified to be set automatically.";
Error::InflectionPointMethodTargetSpecified="If Method->InflectionPoint, ForwardPrimer, ReversePrimer, and Probe must be Null. Please change the values of these options or leave them unspecified to be set automatically.";
Error::InvalidDomainRange="If Domain is specified, Analysis End Cycle must be greater than Analysis Start Cycle and less than or equal to the minimum end cycle among all the amplification curves for analysis. Please change the value of Domain or leave it unspecified to be set automatically.";
Error::InvalidBaselineDomainRange="If BaselineDomain is specified, Baseline End Cycle must be greater than Baseline Start Cycle and less than or equal to either Analysis End Cycle or the minimum end cycle among all the amplification curves for analysis, and Baseline Start Cycle must be greater than or equal to Analysis Start Cycle. Please change the value of BaselineDomain or leave it unspecified to be set automatically.";
Error::PrimerPairMismatch="ForwardPrimer and ReversePrimer must both be either specified or Null. Please change the values of these options or leave them unspecified to be set automatically.";
Error::PrimersProbeMismatch="If ForwardPrimer and ReversePrimer are specified, Probe must be either specified or Null; if ForwardPrimer and ReversePrimer are Null, Probe must also be Null. Please change the values of these options or leave them unspecified to be set automatically.";
Error::ProbePrimersRequired="If Probe is specified, ForwardPrimer and ReversePrimer must also be specified. Please change the values of these options or leave them unspecified to be set automatically.";
Error::ForwardPrimerMissingFromqPCRData="If ForwardPrimer is specified, the primer sample(s) must exist in the qPCR data inputs. Please change the value of ForwardPrimer or leave it unspecified to be set automatically.";
Error::ReversePrimerMissingFromqPCRData="If ReversePrimer is specified, the primer sample(s) must exist in the qPCR data inputs. Please change the value of ReversePrimer or leave it unspecified to be set automatically.";
Error::ProbeMissingFromqPCRData="If Probe is specified, the probe sample(s) must exist in the qPCR data inputs. Please change the value of Probe or leave it unspecified to be set automatically.";
Error::QuantificationCycleTargetMismatch="If a target (ForwardPrimer, ReversePrimer, Probe) is specified, the reagents must belong in the same set. Please change the values of these options or leave it unspecified to be set automatically.";
Error::InvalidThresholdLength="If Threshold is specified, it must be either a singleton or a list matching the number of unique targets in the qPCR data. Please change the value of Threshold or leave it unspecified to be set automatically.";
Warning::QuantificationCycleNotFound="No quantification cycle within the amplification range is found for template sample(s) `1` and is being set to 0 Cycle. If a quantification cycle is expected, please check and adjust the values of BaselineDomain and/or Threshold.";


(* ::Subsubsection::Closed:: *)
(*AnalyzeQuantificationCycle*)


(*Function definition 1, accepting a qPCR protocol object*)
AnalyzeQuantificationCycle[
	myProtocol:ObjectP[Object[Protocol,qPCR]],
	ops:OptionsPattern[AnalyzeQuantificationCycle]
]:=AnalyzeQuantificationCycle[
	Download[Flatten[Download[myProtocol,{Data,StandardData}]],Object],
	ops
];


(*Function definition 2, accepting one or more qPCR data objects*)
AnalyzeQuantificationCycle[
	myData:ListableP[ObjectP[Object[Data,qPCR]]],
	ops:OptionsPattern[AnalyzeQuantificationCycle]
]:=Module[
	{listedInputs,listedOptions,outputSpecification,output,gatherTests,messages,
		safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedOptions,
		upload,cacheBall,arrayCardModels,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,allTests,
		amplificationCurves,amplificationCurveTypes,uniqueForwardPrimers,uniqueReversePrimers,uniqueProbes,uniqueTargetSets,halfResolvedThresholds,
		qPCRDataForwardPrimersObjects,qPCRDataReversePrimersObjects,qPCRDataProbesObjects,qPCRDataTargetSets,
		amplificationCurvesForThresholdAnalysis,amplificationCurvesForInflectionPointAnalysis,analysisPackets,flatAnalysisPackets,uploadPackets,
		resolvedOptionsWithThreshold,collapsedResolvedOptionsWithThreshold,resultRule,testsRule,optionsRule,previewRule},

	(*Make sure we're working with a list of inputs and options*)
	listedInputs=ToList[myData];
	listedOptions=ToList[ops];

	(*Determine the requested return value from the function*)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Call SafeOptions to make sure all options match patterns*)
	{safeOps,safeOpsTests}=If[gatherTests,
		SafeOptions[AnalyzeQuantificationCycle,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeQuantificationCycle,listedOptions,AutoCorrect->False],Null}
	];

	(*If the specified options don't match their patterns or if option lengths are invalid, return $Failed*)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(*Call ValidInputLengthsQ to make sure all options have matching lengths*)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeQuantificationCycle,{listedInputs},listedOptions,2,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeQuantificationCycle,{listedInputs},listedOptions,2],Null}
	];

	(*If option lengths are invalid, return $Failed (or the tests up to this point)*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(*Use any template options to get values for options not specified in myOptions*)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeQuantificationCycle,{listedInputs},listedOptions,2,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeQuantificationCycle,{listedInputs},listedOptions,2],Null}
	];

	(*Return early if the template cannot be used - will only occur if the template object does not exist*)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(*Replace our safe options with the inherited options from the template*)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(*Expand index-matching inputs and options*)
	expandedOptions=Last[ExpandIndexMatchedInputs[AnalyzeQuantificationCycle,{listedInputs},inheritedOptions,2]];

	(*Look up the Upload option from inheritedOptions*)
	upload=Lookup[inheritedOptions,Upload];

	(*Make the upfront Download call*)
	cacheBall=Quiet[
		Flatten@Download[
			listedInputs,
			{
				(* Information from data objects *)
				Packet[Protocol,SamplesIn,Primers,Probes,AmplificationCurveTypes,AmplificationCurves,ExcitationWavelengths,EmissionWavelengths],
				(* Models for Forward/Reverse Primers and Probes *)
				Packet[Primers[[All, 1]][{Model,Composition}]],
				Packet[Primers[[All, 2]][{Model,Composition}]],
				Packet[Probes[{Model,Composition}]]
			}
		],
		{Download::FieldDoesntExist}
	];

	(* Get a list of all identity models associated with input ArrayCards, if they are present *)
	(* At time of this push, doing a separate download on unique protocols is faster than mapping over many samples from the same protocol *)
	arrayCardModels=Quiet[
		Flatten@Download[
			(* All unique protocols associated with the input *)
			DeleteDuplicates[Download[listedInputs,Protocol[Object],Cache->cacheBall]],
			Packet[ArrayCard[Model][{ForwardPrimers,ReversePrimers,Probes}]]
		]/.{l:_Link:>l[Object],Null->Nothing},
		{Download::FieldDoesntExist}
	];

	(*--Build the resolved options--*)
	resolvedOptionsResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{resolvedOptions,resolvedOptionsTests}=resolveAnalyzeQuantificationCycleOptions[listedInputs,expandedOptions,arrayCardModels,Cache->cacheBall,Output->{Result,Tests}];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveAnalyzeQuantificationCycleOptions[listedInputs,expandedOptions,arrayCardModels,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(*Collapse the resolved options*)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		AnalyzeQuantificationCycle,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	allTests=Cases[Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests}],_EmeraldTest];

	(*If option resolution failed, return early*)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->allTests,
			Options->RemoveHiddenOptions[AnalyzeQuantificationCycle,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(*---Call the analyze helper function to perform amplification curve analysis and return packets---*)

	(*Look up AmplificationCurves from the input data objects*)
	amplificationCurves=Download[listedInputs,AmplificationCurves,Cache->cacheBall];

	(*--If Method->Threshold, group AmplificationCurves by amplification target i.e. same {ForwardPrimer,ReversePrimer,Probe}--*)
	If[MatchQ[OptionValue[Method],Threshold],

		(*Look up the resolved primers and probes and group them into triplets*)
		uniqueForwardPrimers=Lookup[resolvedOptions,ForwardPrimer];
		uniqueReversePrimers=Lookup[resolvedOptions,ReversePrimer];
		uniqueProbes=Lookup[resolvedOptions,Probe];
		uniqueTargetSets=MapThread[
			{#1,#2,#3}&,
			{uniqueForwardPrimers,uniqueReversePrimers,uniqueProbes}
		];

		(*Look up the resolved Threshold value, which is either {Automatic..} or a list index-matched to ForwardPrimer*)
		halfResolvedThresholds=Lookup[resolvedOptions,Threshold];

		(* Forward Primers *)
		qPCRDataForwardPrimersObjects=primerOrProbeSampleToModel[
			Download[listedInputs,Primers[[All,1]],Cache->cacheBall]/.x:LinkP[]:>Download[x,Object],
			ForwardPrimers,
			arrayCardModels,
			Cache->cacheBall
		];

		(* Reverse Primers *)
		qPCRDataReversePrimersObjects=primerOrProbeSampleToModel[
			Download[listedInputs,Primers[[All,2]],Cache->cacheBall]/.x:LinkP[]:>Download[x,Object],
			ReversePrimers,
			arrayCardModels,
			Cache->cacheBall
		];

		(* Probes *)
		qPCRDataProbesObjects=primerOrProbeSampleToModel[
			Download[listedInputs,Probes,Cache->cacheBall]/.{x:LinkP[]:>Download[x,Object]},
			Probes,
			arrayCardModels,
			Cache->cacheBall
		];

		(*Group the index-matched primers and probes into triplets*)
		qPCRDataTargetSets=MapThread[
			{#1,#2,#3}&,
			{Flatten[qPCRDataForwardPrimersObjects],Flatten[qPCRDataReversePrimersObjects],Flatten[qPCRDataProbesObjects]}
		];

		(*Group those AmplificationCurves who share the same target*)
		amplificationCurvesForThresholdAnalysis=QuantityMagnitude[
			Map[
				PickList[Flatten[amplificationCurves,1],qPCRDataTargetSets,#]&,
				uniqueTargetSets
			]
		];
	];

	(*--If Method->InflectionPoint, gather all AmplificationCurves whose AmplificationCurveTypes are PrimaryAmplicon or EndogenousControl--*)

	(*Look up AmplificationCurveTypes from the input data objects*)
	amplificationCurveTypes=Download[listedInputs,AmplificationCurveTypes,Cache->cacheBall];

	(*Extract those AmplificationCurves whose AmplificationCurveTypes==PrimaryAmplicon|EndogenousControl*)
	amplificationCurvesForInflectionPointAnalysis=QuantityMagnitude[
		MapThread[
			PickList[#1,#2,PrimaryAmplicon|EndogenousControl]&,
			{amplificationCurves,amplificationCurveTypes}
		]
	];

	(*--Call either analyzeQuantificationCycleThreshold or analyzeQuantificationCycleInflectionPoint, depending on Method--*)
	analysisPackets=If[MatchQ[OptionValue[Method],Threshold],

		(*If Method->Threshold, call the helper function for each set of amplification curves with the same target*)
		MapThread[
			analyzeQuantificationCycleThreshold[listedInputs,#1,#2,#3,resolvedOptions,Cache->cacheBall]&,
			{amplificationCurvesForThresholdAnalysis,halfResolvedThresholds,uniqueTargetSets}
		],

		(*If Method->InflectionPoint, call the helper function for each amplification curve*)
		Map[
			Function[curvesPerDataObject,

				(*For each set of curves in a data object, map the helper function over each curve*)
				Map[
					analyzeQuantificationCycleInflectionPoint[listedInputs,#,resolvedOptions,Cache->cacheBall]&,
					curvesPerDataObject
				]

			],
			amplificationCurvesForInflectionPointAnalysis
		]

	];

	flatAnalysisPackets=Flatten[analysisPackets];

	(*Throw a warning if interpolation failed, which set Cq to 0 Cycle*)
	If[MemberQ[Lookup[flatAnalysisPackets,QuantificationCycle],0 Cycle]&&messages,
		Message[Warning::QuantificationCycleNotFound,ToString[PickList[Lookup[flatAnalysisPackets,Template][Object],Lookup[flatAnalysisPackets,QuantificationCycle],0 Cycle]]]
	];

	(*--If Method->Threshold, replace and collapse the Threshold option--*)
	resolvedOptionsWithThreshold=If[MatchQ[OptionValue[Method],Threshold],
		ReplaceRule[resolvedOptions,Threshold->Map[First@Lookup[#,Threshold]&,analysisPackets]],
		resolvedOptions
	];

	(*Collapse the resolved options*)
	collapsedResolvedOptionsWithThreshold=CollapseIndexMatchedOptions[
		AnalyzeQuantificationCycle,
		resolvedOptionsWithThreshold,
		Ignore->listedOptions,
		Messages->False
	];


	(*---Prepare and return the output---*)
	uploadPackets=If[Length[flatAnalysisPackets]==1,
		First@flatAnalysisPackets,
		flatAnalysisPackets
	];

	(*Prepare the standard result if we were asked for it and we can safely do so*)
	resultRule=Result->If[MemberQ[output,Result],
		If[TrueQ[upload]&&MemberQ[output,Result],
			Upload[uploadPackets],
			uploadPackets
		],
		Null
	];

	(*Prepare the Tests result if we were asked to do so*)
	testsRule=Tests->If[MemberQ[output,Tests],
		allTests,
		Null
	];

	(*Prepare the Options result if we were asked to do so*)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[AnalyzeQuantificationCycle,collapsedResolvedOptionsWithThreshold],
		Null
	];

	(*Prepare the Preview result if we were asked to do so*)
	previewRule=Preview->If[MemberQ[output,Preview],
		ECL`PlotQuantificationCycle[uploadPackets,Legend->Null],
		Null
	];

	(*Return the requested output*)
	outputSpecification/.{resultRule,testsRule,optionsRule,previewRule}
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeQuantificationCycleOptions*)


DefineOptions[resolveAnalyzeQuantificationCycleOptions,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];


resolveAnalyzeQuantificationCycleOptions[
	myListedData:{ObjectP[Object[Data,qPCR]]..},
	myOptions:{_Rule..},
	arrayCardPackets_,
	myResolutionOptions:OptionsPattern[resolveAnalyzeQuantificationCycleOptions]
]:=Module[
	{outputSpecification,output,gatherTests,messages,inheritedCache,myOptionsAssociation,
		method,baselineDomain,domain,smoothingRadius,forwardPrimers,reversePrimers,probes,thresholds,template,upload,
		allDataPackets,amplificationCurves,specifiedForwardPrimersObjects,qPCRDataForwardPrimersObjects,specifiedReversePrimersObjects,qPCRDataReversePrimersObjects,specifiedProbesObjects,qPCRDataProbesObjects,
		validMethodQ,invalidMethodOptions,validMethodTest,validThresholdMethodTargetQ,invalidThresholdMethodTargetOptions,validThresholdMethodTargetTest,validInflectionPointMethodTargetQ,invalidInflectionPointMethodTargetOptions,validInflectionPointMethodTargetTest,
		minEndCycle,validDomainQ,invalidDomainOptions,validDomainTest,validBaselineDomainQ,invalidBaselineDomainOptions,validBaselineDomainTest,
		validPrimerPairQ,invalidPrimerPairOptions,validPrimerPairTest,validPrimersProbeQ,invalidPrimersProbeOptions,validPrimersProbeTest,validProbePrimersQ,invalidProbePrimersOptions,validProbePrimersTest,
		validForwardPrimerQ,invalidForwardPrimerOptions,validForwardPrimerTest,validReversePrimerQ,invalidReversePrimerOptions,validReversePrimerTest,validProbeQ,invalidProbeOptions,validProbeTest,
		resolvedDomain,resolvedSmoothingRadius,resolvedBaselineDomain,qPCRDataTargetSets,uniqueTargetSets,resolvedForwardPrimers,resolvedReversePrimers,resolvedProbes,validTargetQ,invalidTargetOptions,validTargetTest,
		validThresholdQ,invalidThresholdOptions,validThresholdTest,halfResolvedThresholds,invalidOptions,resolvedOptions,allTests,resultRule,testsRule},


	(*---Set up the user-specified options and cache---*)

	(*Determine the requested return value from the function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Fetch our options cache from the parent function*)
	inheritedCache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	myOptionsAssociation=Association[myOptions];

	(*Pull out the options that are defaulted or specified*)
	{method,domain,smoothingRadius,baselineDomain,forwardPrimers,reversePrimers,probes,thresholds,template,upload}=Lookup[myOptionsAssociation,{Method,Domain,SmoothingRadius,BaselineDomain,ForwardPrimer,ReversePrimer,Probe,Threshold,Template,Upload}];

	(*Extract the packets that we need from our downloaded cache*)
	allDataPackets=Quiet[
		Download[
			myListedData,
			Packet[Primers,Probes,AmplificationCurveTypes,AmplificationCurves,ExcitationWavelengths,EmissionWavelengths],
			Cache->inheritedCache
		],
		{Download::FieldDoesntExist}
	];

	(*--Gather some information from the options/downloaded packet--*)

	(*AmplificationCurves*)
	amplificationCurves=Lookup[allDataPackets,AmplificationCurves];

	(* Gather primers and probes specified in options *)
	specifiedForwardPrimersObjects=ToList[forwardPrimers/.{x:ObjectP[]:>Download[x,Object],x:LinkP[]:>Download[x,Object],x:PacketP[]:>Lookup[x,Object]}];
	specifiedReversePrimersObjects=ToList[reversePrimers/.{x:ObjectP[]:>Download[x,Object],x:LinkP[]:>Download[x,Object],x:PacketP[]:>Lookup[x,Object]}];
	specifiedProbesObjects=ToList[probes/.{x:ObjectP[]:>Download[x,Object],x:LinkP[]:>Download[x,Object],x:PacketP[]:>Lookup[x,Object]}];

	(*** In the below, automatically resolve primer/probes. If samples are linked in the input data, try to resolve an identity model. ***)

	(* Forward Primers *)
	qPCRDataForwardPrimersObjects=primerOrProbeSampleToModel[
		Lookup[allDataPackets,Primers][[All,All,1]]/.{x:LinkP[]:>Download[x,Object]},
		ForwardPrimers,
		arrayCardPackets,
		Cache->inheritedCache
	];

	(* Reverse Primers *)
	qPCRDataReversePrimersObjects=primerOrProbeSampleToModel[
		Lookup[allDataPackets,Primers][[All,All,2]]/.{x:LinkP[]:>Download[x,Object]},
		ReversePrimers,
		arrayCardPackets,
		Cache->inheritedCache
	];

	(* Probes *)
	qPCRDataProbesObjects=primerOrProbeSampleToModel[
		Lookup[allDataPackets,Probes]/.{x:LinkP[]:>Download[x,Object]},
		Probes,
		arrayCardPackets,
		Cache->inheritedCache
	];

	(*---Conflicting options checks---*)

	(*--Check that the Method options aren't in conflict--*)
	validMethodQ=Or[
		(*Check if Method->Threshold, SmoothingRadius is not specified (Automatic or Null) and Threshold is not Null*)
		MatchQ[method,Threshold]&&MatchQ[smoothingRadius,Automatic|Null]&&!NullQ[thresholds],
		(*Check if Method->InflectionPoint, SmoothingRadius is not Null and Threshold is not specified (Automatic or Null)*)
		MatchQ[method,InflectionPoint]&&!NullQ[smoothingRadius]&&MatchQ[thresholds,ListableP[Automatic|Null]]
	];

	(*If validMethodQ is False and we are throwing messages, then throw an error message*)
	invalidMethodOptions=If[!validMethodQ&&messages,
		(
			Message[Error::MethodMismatch];
			{Method,SmoothingRadius,Threshold}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validMethodTest=If[gatherTests,
		Test["If Method->Threshold, SmoothingRadius is not specified and Threshold is not Null; if Method->InflectionPoint, SmoothingRadius is not Null and Threshold is not specified:",
			validMethodQ,
			True
		],
		Nothing
	];

	(*--Check that the primers are not Null if Method->Threshold--*)
	validThresholdMethodTargetQ=If[MatchQ[method,Threshold],
		!NullQ[forwardPrimers]&&!NullQ[reversePrimers],
		True
	];

	(*If validThresholdMethodTargetQ is False and we are throwing messages, then throw an error message*)
	invalidThresholdMethodTargetOptions=If[!validThresholdMethodTargetQ&&messages,
		(
			Message[Error::ThresholdMethodTargetMissing];
			{Method,ForwardPrimer,ReversePrimer}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validThresholdMethodTargetTest=If[gatherTests,
		Test["If Method->Threshold, ForwardPrimer and ReversePrimer are not Null:",
			validThresholdMethodTargetQ,
			True
		],
		Nothing
	];

	(*--Check that the primers and probes are Null or Automatic if Method->InflectionPoint--*)
	validInflectionPointMethodTargetQ=If[MatchQ[method,InflectionPoint],
		MatchQ[{forwardPrimers,reversePrimers,probes},{ListableP[Null]..|ListableP[Automatic]..}],
		True
	];

	(*If validInflectionPointMethodTargetQ is False and we are throwing messages, then throw an error message*)
	invalidInflectionPointMethodTargetOptions=If[!validInflectionPointMethodTargetQ&&messages,
		(
			Message[Error::InflectionPointMethodTargetSpecified];
			{Method,ForwardPrimer,ReversePrimer,Probe}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validInflectionPointMethodTargetTest=If[gatherTests,
		Test["If Method->InflectionPoint, ForwardPrimer, ReversePrimer, and Probe are Null:",
			validInflectionPointMethodTargetQ,
			True
		],
		Nothing
	];

	(*--Check that if Domain is specified, end cycle > start cycle && <= minEndCycle--*)
	minEndCycle=Min[Map[Length/@#&,amplificationCurves]] Cycle;
	validDomainQ=If[MatchQ[domain,Except[Automatic]],
		Last[domain]>First[domain]&&Last[domain]<=minEndCycle,
		True
	];

	(*If validDomainQ is False and we are throwing messages, then throw an error message*)
	invalidDomainOptions=If[!validDomainQ&&messages,
		(
			Message[Error::InvalidDomainRange];
			{Domain}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validDomainTest=If[gatherTests,
		Test["If Domain is specified, Analysis End Cycle is greater than Analysis Start Cycle and less than or equal to the minimum end cycle among all the amplification curves for analysis:",
			validDomainQ,
			True
		],
		Nothing
	];

	(*--Check that if BaselineDomain is specified, end cycle > start cycle && <= either end cycle of Domain (if specified) or minEndCycle, and start cycle >= either start cycle of Domain (if specified)--*)
	validBaselineDomainQ=If[MatchQ[baselineDomain,Except[Automatic]],
		Last[baselineDomain]>First[baselineDomain]&&Last[baselineDomain]<=If[MatchQ[domain,Except[Automatic]],Last[domain],minEndCycle]&&If[MatchQ[domain,Except[Automatic]],First[baselineDomain]>=First[domain],True],
		True
	];

	(*If validBaselineDomainQ is False and we are throwing messages, then throw an error message*)
	invalidBaselineDomainOptions=If[!validBaselineDomainQ&&messages,
		(
			Message[Error::InvalidBaselineDomainRange];
			{BaselineDomain}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validBaselineDomainTest=If[gatherTests,
		Test["If BaselineDomain is specified, Baseline End Cycle is greater than Baseline Start Cycle and less than or equal to Analysis End Cycle or the minimum end cycle among all the amplification curves for analysis, and Baseline Start Cycle is greater than or equal to Analysis Start Cycle:",
			validBaselineDomainQ,
			True
		],
		Nothing
	];

	(*--Check that ForwardPrimer and ReversePrimer are both specified, Null, or Automatic--*)
	validPrimerPairQ=MatchQ[
		{forwardPrimers,reversePrimers},
		{ListableP[ObjectP[]]..|ListableP[Null]..|ListableP[Automatic]..}
	];

	(*If validPrimerPairQ is False and we are throwing messages, then throw an error message*)
	invalidPrimerPairOptions=If[!validPrimerPairQ&&messages,
		(
			Message[Error::PrimerPairMismatch];
			{ForwardPrimer,ReversePrimer}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validPrimerPairTest=If[gatherTests,
		Test["ForwardPrimer and ReversePrimer are both either specified or Null:",
			validPrimerPairQ,
			True
		],
		Nothing
	];

	(*--Check that if ForwardPrimer and ReversePrimer are specified, Probe is either specified or Null; if ForwardPrimer and ReversePrimer are Null, Probe is also Null--*)
	validPrimersProbeQ=Which[
		MatchQ[{forwardPrimers,reversePrimers},{ListableP[ObjectP[]]..}],MatchQ[probes,ListableP[ObjectP[]]|ListableP[Null]],
		MatchQ[{forwardPrimers,reversePrimers},{ListableP[Null]..}],MatchQ[probes,ListableP[Null]],
		True,True
	];

	(*If validPrimersProbeQ is False and we are throwing messages, then throw an error message*)
	invalidPrimersProbeOptions=If[!validPrimersProbeQ&&messages,
		(
			Message[Error::PrimersProbeMismatch];
			{ForwardPrimer,ReversePrimer,Probe}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validPrimersProbeTest=If[gatherTests,
		Test["If ForwardPrimer and ReversePrimer are specified, Probe is either specified or Null; if ForwardPrimer and ReversePrimer are Null, Probe is also Null:",
			validPrimersProbeQ,
			True
		],
		Nothing
	];

	(*--Check that if Probe is specified, ForwardPrimer or ReversePrimer are also specified--*)
	validProbePrimersQ=If[MatchQ[probes,ListableP[ObjectP[]]],
		MatchQ[{forwardPrimers,reversePrimers},{ListableP[ObjectP[]]..}],
		True
	];

	(*If validProbePrimersQ is False and we are throwing messages, then throw an error message*)
	invalidProbePrimersOptions=If[!validProbePrimersQ&&messages,
		(
			Message[Error::ProbePrimersRequired];
			{Probe,ForwardPrimer,ReversePrimer}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validProbePrimersTest=If[gatherTests,
		Test["If Probe is specified, ForwardPrimer and ReversePrimer are also specified:",
			validProbePrimersQ,
			True
		],
		Nothing
	];

	(*--Check that the specified ForwardPrimer exists in the qPCR data objects--*)
	validForwardPrimerQ=If[MatchQ[forwardPrimers,ListableP[ObjectP[]]],
		MatchQ[Complement[Flatten[specifiedForwardPrimersObjects],Flatten[qPCRDataForwardPrimersObjects]],{}],
		True
	];

	(*If validForwardPrimerQ is False and we are throwing messages, then throw an error message*)
	invalidForwardPrimerOptions=If[!validForwardPrimerQ&&messages,
		(
			Message[Error::ForwardPrimerMissingFromqPCRData];
			{ForwardPrimer}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validForwardPrimerTest=If[gatherTests,
		Test["If ForwardPrimer is specified, the primer samples exist in the qPCR data inputs:",
			validForwardPrimerQ,
			True
		],
		Nothing
	];

	(*--Check that the specified ReversePrimer exists in the qPCR data objects--*)
	validReversePrimerQ=If[MatchQ[reversePrimers,ListableP[ObjectP[]]],
		MatchQ[Complement[Flatten[specifiedReversePrimersObjects],Flatten[qPCRDataReversePrimersObjects]],{}],
		True
	];

	(*If validReversePrimerQ is False and we are throwing messages, then throw an error message*)
	invalidReversePrimerOptions=If[!validReversePrimerQ&&messages,
		(
			Message[Error::ReversePrimerMissingFromqPCRData];
			{ReversePrimer}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validReversePrimerTest=If[gatherTests,
		Test["If ReversePrimer is specified, the primer samples exist in the qPCR data inputs:",
			validReversePrimerQ,
			True
		],
		Nothing
	];

	(*--Check that the specified Probe exists in the qPCR data objects--*)
	validProbeQ=If[MatchQ[probes,ListableP[ObjectP[]]],
		MatchQ[Complement[Flatten[specifiedProbesObjects],Flatten[qPCRDataProbesObjects]],{}],
		True
	];

	(*If validProbeQ is False and we are throwing messages, then throw an error message*)
	invalidProbeOptions=If[!validProbeQ&&messages,
		(
			Message[Error::ProbeMissingFromqPCRData];
			{Probe}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validProbeTest=If[gatherTests,
		Test["If Probe is specified, the primer samples exist in the qPCR data inputs:",
			validProbeQ,
			True
		],
		Nothing
	];


	(*---Resolve the options---*)

	(*Resolve Domain*)
	resolvedDomain=Switch[domain,
		{CycleP,CycleP},domain,
		Automatic,{1 Cycle,minEndCycle}
	];

	(*Resolve SmoothingRadius*)
	resolvedSmoothingRadius=Switch[smoothingRadius,
		CycleP,smoothingRadius,
		Automatic&&MatchQ[method,InflectionPoint],2 Cycle,
		(*If Method->Threshold, set SmoothingRadius to Null*)
		_,Null
	];

	(*Resolve BaselineDomain*)
	resolvedBaselineDomain=Switch[baselineDomain,
		{CycleP,CycleP},baselineDomain,
		Automatic,{Max[3 Cycle,Min[resolvedDomain]],15 Cycle}
	];

	(*Resolve ForwardPrimer, ReversePrimer, and Probe*)

	(*Find all the targets found in the input qPCR data and group them into triplets*)
	qPCRDataTargetSets=MapThread[
		{#1,#2,#3}&,
		{Flatten[qPCRDataForwardPrimersObjects],Flatten[qPCRDataReversePrimersObjects],Flatten[qPCRDataProbesObjects]}
	];

	(*Remove duplicate sets and sets of Nulls*)
	uniqueTargetSets=DeleteDuplicates[DeleteCases[qPCRDataTargetSets,{Null..}]];

	{resolvedForwardPrimers,resolvedReversePrimers,resolvedProbes}=If[MatchQ[method,InflectionPoint],
		ConstantArray[Null,3],
		(*If Method->Threshold and target is specified, set to that target, or set to all the unique targets from the input qPCR data otherwise*)
		If[MatchQ[{specifiedForwardPrimersObjects,specifiedReversePrimersObjects,specifiedProbesObjects},{ListableP[ObjectP[]],ListableP[ObjectP[]],ListableP[ObjectP[]]|ListableP[Null]}],
			{specifiedForwardPrimersObjects,specifiedReversePrimersObjects,specifiedProbesObjects},
			Transpose[uniqueTargetSets]
		]
	];

	(*--Check that if a target (ForwardPrimer, ReversePrimer, Probe) is specified, the reagents belong in the same set--*)
	validTargetQ=If[!MatchQ[{resolvedForwardPrimers,resolvedReversePrimers,resolvedProbes},ConstantArray[Null,3]],
		MatchQ[Complement[Transpose[{resolvedForwardPrimers,resolvedReversePrimers,resolvedProbes}],uniqueTargetSets],{}],
		True
	];

	(*If validTargetQ is False and we are throwing messages, then throw an error message*)
	invalidTargetOptions=If[!validTargetQ&&messages,
		(
			Message[Error::QuantificationCycleTargetMismatch];
			{ForwardPrimer,ReversePrimer,Probe}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validTargetTest=If[gatherTests,
		Test["If a target (ForwardPrimer, ReversePrimer, Probe) is specified, the reagents belong in the same set:",
			validTargetQ,
			True
		],
		Nothing
	];

	(*--Check that the specified Threshold is either a singleton or a list matching the number of unique targets in the qPCR data--*)
	validThresholdQ=If[MatchQ[thresholds,Except[ListableP[Automatic]]],
		MatchQ[Length[Unitless[thresholds]],0|Length[resolvedForwardPrimers]],
		True
	];

	(*If validForwardPrimerQ is False and we are throwing messages, then throw an error message*)
	invalidThresholdOptions=If[!validThresholdQ&&messages,
		(
			Message[Error::InvalidThresholdLength];
			{Threshold}
		),
		{}
	];

	(*If we are gathering tests, create a test*)
	validThresholdTest=If[gatherTests,
		Test["If Threshold is specified, it is either a singleton or a list matching the number of unique targets in the qPCR data:",
			validThresholdQ,
			True
		],
		Nothing
	];

	(*--If Threshold->Automatic, resolve it to the extent that is possible at this point--*)
	halfResolvedThresholds=If[MatchQ[method,InflectionPoint],
		Null,
		If[MatchQ[thresholds,Except[Automatic]],
			If[Length[Unitless[thresholds]]==0,
				Flatten[ConstantArray[thresholds,Length[resolvedForwardPrimers]]],
				thresholds
				],
			ConstantArray[Automatic,Length[resolvedForwardPrimers]]
		]
	];


	(*---Check our invalid option variables and throw Error::InvalidOption if necessary---*)
	invalidOptions=DeleteDuplicates[Flatten[{
		invalidMethodOptions,
		invalidThresholdMethodTargetOptions,
		invalidInflectionPointMethodTargetOptions,
		invalidDomainOptions,
		invalidBaselineDomainOptions,
		invalidPrimerPairOptions,
		invalidPrimersProbeOptions,
		invalidProbePrimersOptions,
		invalidForwardPrimerOptions,
		invalidReversePrimerOptions,
		invalidProbeOptions,
		invalidTargetOptions,
		invalidThresholdOptions
	}]];

	(*Throw Error::InvalidOption if there are invalid options*)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];


	(*---Return our resolved options and tests---*)

	(*Gather the resolved options (pre-collapsed; that is happening outside the function)*)
	resolvedOptions=Flatten[{
		Method->method,
		Domain->resolvedDomain,
		SmoothingRadius->resolvedSmoothingRadius,
		BaselineDomain->resolvedBaselineDomain,
		ForwardPrimer->resolvedForwardPrimers,
		ReversePrimer->resolvedReversePrimers,
		Probe->resolvedProbes,
		Threshold->halfResolvedThresholds,
		Template->template,
		Output->output,
		Upload->upload
	}];

	(*Gather the tests*)
	allTests=Cases[Flatten[{
		validMethodTest,
		validThresholdMethodTargetTest,
		validInflectionPointMethodTargetTest,
		validDomainTest,
		validBaselineDomainTest,
		validPrimerPairTest,
		validPrimersProbeTest,
		validProbePrimersTest,
		validForwardPrimerTest,
		validReversePrimerTest,
		validProbeTest,
		validTargetTest,
		validThresholdTest
	}],_EmeraldTest];

	(*Generate the result output rule: if not returning result, result rule is just Null*)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(*Generate the tests output rule*)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(*Return the output as we desire it*)
	outputSpecification/.{resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*analyzeQuantificationCycleThreshold*)


DefineOptions[analyzeQuantificationCycleThreshold,
	Options:>{
		CacheOption
	}
];


analyzeQuantificationCycleThreshold[
	myListedInputs_,
	myAmplificationCurves:{CoordinatesP..},
	myThreshold:(Automatic|FluorescenceUnitP),
	myTarget:{
		ObjectP[{Object[Sample],Model[Molecule]}],
		ObjectP[{Object[Sample],Model[Molecule]}],
		Null|ObjectP[{Object[Sample],Model[Molecule]}]
	},
	myResolvedOptions:{_Rule..},
	myOptions:OptionsPattern[analyzeQuantificationCycleThreshold]
]:=Module[
	{inheritedCache,resolvedDomain,resolvedBaselineDomain,myAmplificationCurvesInDomain,myAmplificationCurvesInBaselineDomain,
		baselineMeanFluor,correctedFluor,domainOffset,correctedBaselineFluor,correctedBaselineFluorStdDev,threshold,correctedCurves,
		xdyFull,xdy,rootGuess,curveFit,cqSolution,cq,
		curveDataLookup,completePosition,sourceDataPosition,amplificationCurveSource,sourceCurvePosition,excitationWavelength,emissionWavelength,
		protocol,template},

	(*Get the inherited cache*)
	inheritedCache=Lookup[myOptions,Cache];


	(*---Data Processing---*)
	resolvedDomain=Unitless[Lookup[myResolvedOptions,Domain]];
	resolvedBaselineDomain=Unitless[Lookup[myResolvedOptions,BaselineDomain]];

	(*Pull out the curves' data points in Domain and BaselineDomain*)
	myAmplificationCurvesInDomain=Map[
		selectInDomain[#,resolvedDomain]&,
		myAmplificationCurves
	];
	myAmplificationCurvesInBaselineDomain=Map[
		selectInDomain[#,resolvedBaselineDomain]&,
		myAmplificationCurves
	];

	(*For each curve, find the mean baseline fluorescence value*)
	baselineMeanFluor=Mean/@myAmplificationCurvesInBaselineDomain[[All,All,2]];

	(*For each curve, subtract baselineMeanFluor from all the fluorescence values in Domain*)
	correctedFluor=MapThread[
		#1-#2&,
		{myAmplificationCurvesInDomain[[All,All,2]],baselineMeanFluor}
	];

	(*Get the offset between the starting values of Domain and BaselineDomain*)
	domainOffset=Min@resolvedBaselineDomain-Min@resolvedDomain+1;

	(*For each corrected curve, get the fluorescence values in BaselineDomain*)
	correctedBaselineFluor=Map[
		Take[#,{domainOffset,domainOffset+(Max@resolvedBaselineDomain-Min@resolvedBaselineDomain)}]&,
		correctedFluor
	];

	(*Calculate the baseline standard deviation*)
	correctedBaselineFluorStdDev=StandardDeviation[Flatten[correctedBaselineFluor]];

	(*Set Threshold to 10*(standard deviation of the baseline-subtracted mean fluorescence value in BaselineDomain) if Automatic, or leave as specified otherwise*)
	threshold=If[MatchQ[myThreshold,Automatic],
		10*correctedBaselineFluorStdDev,
		Unitless[myThreshold]
	];

	(*Reassemble the corrected fluorescence values with the cycle numbers*)
	correctedCurves=Map[
		Function[correctedFluorPerCurve,

			MapThread[
				{#1,#2}&,
				{Range[Min@resolvedDomain,Max@resolvedDomain],correctedFluorPerCurve}
			]

		],
		correctedFluor
	];


	(*---Calculation---*)

	MapThread[
		Function[{correctedCurve,originalCurve},

			(*Compute derivative of the data*)
			xdyFull=finiteDifferences2D[correctedCurve];
			xdy=selectInDomain[xdyFull,resolvedDomain];
			rootGuess=SortBy[xdy,Last][[-1,1]];

			(*Fit an interpolating function*)
			curveFit=Interpolation[correctedCurve];

			(*Solve where the interpolating function meets Threshold*)
			cqSolution=Quiet[Check[
				FindRoot[curveFit[x]==threshold,{x,rootGuess}],
				{x->0},
				{InterpolatingFunction::dmval,FindRoot::lstol}
			]];
			cq=Lookup[cqSolution,x];

			(*---Assemble the packet to return---*)

			(*--Get the source data, protocol, and sample in corresponding to the analyzed amplification curve--*)

			(*MapThread all the amplification curves with the data objects*)
			curveDataLookup=MapThread[
				{#1,#2}&,
				{QuantityMagnitude[Download[myListedInputs,AmplificationCurves,Cache->inheritedCache]],Download[myListedInputs,Object,Cache->inheritedCache]}
			];

			(*Identify the overall position of the analyzed amplification curve in curveDataLookup*)
			completePosition=Position[curveDataLookup,originalCurve];

			(*Identify the position of the analyzed amplification curve in curveDataLookup and use it to find the source data object*)
			sourceDataPosition=First@@completePosition;
			amplificationCurveSource=First@Cases[curveDataLookup[[sourceDataPosition]],ObjectP[Object[Data,qPCR]]];

			(*Identify the position of the analyzed amplification curve in the data object's AmplificationCurves and use it to find the em/ex wavelength*)
			sourceCurvePosition=Last@@completePosition;
			excitationWavelength=Download[amplificationCurveSource,ExcitationWavelengths,Cache->inheritedCache][[sourceCurvePosition]];
			emissionWavelength=Download[amplificationCurveSource,EmissionWavelengths,Cache->inheritedCache][[sourceCurvePosition]];

			(*Get the protocol and sample in and give them new links*)
			protocol=Download[amplificationCurveSource,Protocol,Cache->inheritedCache]/.x:LinkP[]:>Download[x,Object];
			template=First@Download[amplificationCurveSource,SamplesIn,Cache->inheritedCache]/.x:LinkP[]:>Download[x,Object];

			(*--Assemble the packet--*)
			<|
				Type->Object[Analysis,QuantificationCycle],
				Author->Link[$PersonID],
				ResolvedOptions->ReplaceRule[myResolvedOptions,{
					ForwardPrimer->myTarget[[1]],
					ReversePrimer->myTarget[[2]],
					Probe->myTarget[[3]],
					Threshold->threshold*RFU
				}],
				Protocol->Link[protocol,QuantificationCycleAnalyses],
				Method->Lookup[myResolvedOptions,Method],
				Domain->resolvedDomain*Cycle,
				BaselineDomain->resolvedBaselineDomain*Cycle,
				Template->Link[template],
        ForwardPrimer->Link[myTarget[[1]]],
				ReversePrimer->Link[myTarget[[2]]],
				Probe->Link[myTarget[[3]]],
				FittingDataPoints->QuantityArray[correctedCurve,{Cycle,RFU}],
				ExcitationWavelength->excitationWavelength,
				EmissionWavelength->emissionWavelength,
				Threshold->threshold*RFU,
				QuantificationCycle->cq*Cycle,
				Replace[Reference]->Link[amplificationCurveSource,QuantificationCycleAnalyses],
				ReferenceField->AmplificationCurves
			|>

		],
		{correctedCurves,myAmplificationCurves}
	]

];


(* ::Subsubsection::Closed:: *)
(*analyzeQuantificationCycleInflectionPoint*)


DefineOptions[analyzeQuantificationCycleInflectionPoint,
	Options:>{
		CacheOption
	}
];


analyzeQuantificationCycleInflectionPoint[
	myListedInputs_,
	myAmplificationCurve:CoordinatesP,
	myResolvedOptions:{_Rule..},
	myOptions:OptionsPattern[analyzeQuantificationCycleInflectionPoint]
]:=Module[
	{inheritedCache,resolvedDomain,resolvedBaselineDomain,xy,xyBaseline,yMeanBaseline,xyBaselineSubtracted,resolvedSmoothingRadius,smoothxy,
		xdyFull,xdy,rootGuess,curveFit,root,
		curveDataLookup,completePosition,sourceDataPosition,amplificationCurveSource,sourceCurvePosition,excitationWavelength,emissionWavelength,
		protocol,template},

	(*Get the inherited cache*)
	inheritedCache=Lookup[myOptions,Cache];


	(*---Data Processing---*)
	resolvedDomain=Unitless[Lookup[myResolvedOptions,Domain]];
	resolvedBaselineDomain=Unitless[Lookup[myResolvedOptions,BaselineDomain]];

	(*Pull out the curve's data points in Domain and BaselineDomain*)
	xy=selectInDomain[myAmplificationCurve,resolvedDomain];
	xyBaseline=selectInDomain[myAmplificationCurve,resolvedBaselineDomain];

	(*Find the mean baseline fluorescence value*)
	yMeanBaseline=Mean@xyBaseline[[All,2]];

	(*Subtract yMeanBaseline from all the fluorescence values in Domain*)
	xyBaselineSubtracted=Map[{First[#],Last[#]-yMeanBaseline}&,xy];

	(*Smooth xyBaselineSubtracted*)
	resolvedSmoothingRadius=Unitless[Lookup[myResolvedOptions,SmoothingRadius]];
	smoothxy=gaussianSmooth1D[xyBaselineSubtracted,resolvedSmoothingRadius];


	(*---Calculation---*)

	(*Compute derivative of the data*)
	xdyFull=finiteDifferences2D[myAmplificationCurve];
	xdy=selectInDomain[xdyFull,resolvedDomain];
	rootGuess=SortBy[xdy,Last][[-1,1]];

	(*Fit a sigmoid-like function*)
	{curveFit,root}=extractCqFromAmplificationCurve[smoothxy,rootGuess];


	(*---Assemble the packet to return---*)

	(*--Get the source data, protocol, and sample in corresponding to the analyzed amplification curve--*)

	(*MapThread all the amplification curves with the data objects*)
	curveDataLookup=MapThread[
		{#1,#2}&,
		{QuantityMagnitude[Download[myListedInputs,AmplificationCurves,Cache->inheritedCache]],Download[myListedInputs,Object,Cache->inheritedCache]}
	];

	(*Identify the overall position of the analyzed amplification curve in curveDataLookup*)
	completePosition=Position[curveDataLookup,myAmplificationCurve];

	(*Identify the position of the analyzed amplification curve in curveDataLookup and use it to find the source data object*)
	sourceDataPosition=First@@completePosition;
	amplificationCurveSource=First@Cases[curveDataLookup[[sourceDataPosition]],ObjectP[Object[Data,qPCR]]];

	(*Identify the position of the analyzed amplification curve in the data object's AmplificationCurves and use it to find the em/ex wavelength*)
	sourceCurvePosition=Last@@completePosition;
	excitationWavelength=Download[amplificationCurveSource,ExcitationWavelengths,Cache->inheritedCache][[sourceCurvePosition]];
	emissionWavelength=Download[amplificationCurveSource,EmissionWavelengths,Cache->inheritedCache][[sourceCurvePosition]];

	(*Get the protocol and sample in and give them new links*)
	protocol=Download[amplificationCurveSource,Protocol,Cache->inheritedCache]/.x:LinkP[]:>Download[x,Object];
	template=First@Download[amplificationCurveSource,SamplesIn,Cache->inheritedCache]/.x:LinkP[]:>Download[x,Object];

	(*--Assemble the packet--*)
	<|
		Type->Object[Analysis,QuantificationCycle],
		Author->Link[$PersonID],
		ResolvedOptions->myResolvedOptions,
		Protocol->Link[protocol,QuantificationCycleAnalyses],
		Method->Lookup[myResolvedOptions,Method],
		Domain->resolvedDomain*Cycle,
		BaselineDomain->resolvedBaselineDomain*Cycle,
		SmoothingRadius->resolvedSmoothingRadius*Cycle,
		Template->Link[template],
		FittingDataPoints->QuantityArray[smoothxy,{Cycle,RFU}],
		ExcitationWavelength->excitationWavelength,
		EmissionWavelength->emissionWavelength,
		AmplificationFit->curveFit,
		QuantificationCycle->root*Cycle,
		Replace[Reference]->Link[amplificationCurveSource,QuantificationCycleAnalyses],
		ReferenceField->AmplificationCurves
	|>
];


(* ::Subsubsection::Closed:: *)
(*extractCqFromAmplificationCurve*)


extractCqFromAmplificationCurve[
	xy_,
	rootGuess_
]:=Module[{fitCqPacket},

	fitCqPacket=Quiet[
		analyzeFitLogisticCurve[xy,rootGuess],
		{AnalyzeFit::OverFit}
	];

	{
		packetLookup[fitCqPacket,BestFitFunction],
		First@Cases[packetLookup[fitCqPacket,BestFitParameters],{InflectionPoint,val_,stdDev_}:>val]
	}
];


(* ::Subsubsection::Closed:: *)
(*primerOrProbeSampleToModel*)

DefineOptions[primerOrProbeSampleToModel,
	Options:>{CacheOption}
];

(* Helper function to extract identity model from a sample, with an extra argument to handle ArrayCards *)
primerOrProbeSampleToModel[
	samples:{{(ObjectP[{Model[Molecule],Object[Sample]}]|Null)..}..},
	type:ForwardPrimers|ReversePrimers|Probes,
	arrayCardPackets_,
	ops:OptionsPattern[primerOrProbeSampleToModel]
]:=Module[
	{inheritedCache,linkedModels,compositions,cardModels,commonModels},

	(* Get the cache if we were provided one *)
	inheritedCache=Lookup[ToList[ops],Cache,Null];

	(* Try to download the Model associated with each sample. If there is no model (or is already a model), then show Null *)
	linkedModels=Quiet[
		Download[samples,Model,Cache->inheritedCache]/.{$Failed->Null},
		{Download::FieldDoesntExist}
	];

	(* Download compositions, using cache to avoid an extra network connection *)
	compositions=Quiet[
		Download[samples,Composition[[All,2]][Object],Cache->inheritedCache]/.{$Failed->{},Null->{}},
		{Download::FieldDoesntExist}
	];

	(* Grab the identity models associated with array cards, if they were used as inputs *)
	cardModels=Flatten@Lookup[arrayCardPackets,type,{}];

	(* For each sample, check if any of the primers/probe identity models of the requested type are present in the sample composition *)
	commonModels=Map[
		Intersection[cardModels,#]&,
		compositions,
		{2}
	];

	(* Decide what to return for each input *)
	MapThread[
		Function[{orig,model,modelsFromCard},
			Which[
				(* If the provided option was already a molecule identity model, return it unchanged *)
				MatchQ[orig,ObjectP[Model[Molecule]]],orig,
				(* Return the linked model if it exists *)
				MatchQ[model,ObjectP[Model[Molecule]]],model,
				(* If the sample contains one of the primers/probes from the protocol-linked ArrayCard, use that identity model *)
				MatchQ[modelsFromCard,{ObjectP[Model,Molecule]..}],First[modelsFromCard],
				(* Return the input unchanged if none of the conditions above were met *)
				True,orig
			]
		],
		{samples,linkedModels,commonModels},
		2
	]
];

(* Single listable overload *)
primerOrProbeSampleToModel[
	singleListSamples:{(ObjectP[{Model[Molecule],Object[Sample]}]|Null)..},
	type:ForwardPrimer|ReversePrimer|Probe,
	arrayCardPackets_,
	ops:OptionsPattern[primerOrProbeSampleToModel]
]:=primerOrProbeSampleToModel[{singleListSamples},type,arrayCardPackets,ops];



(* ::Subsection::Closed:: *)
(*AnalyzeQuantificationCycleOptions*)


DefineOptions[AnalyzeQuantificationCycleOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{AnalyzeQuantificationCycle}
];


AnalyzeQuantificationCycleOptions[
	myData:(ObjectP[Object[Protocol,qPCR]]|ListableP[ObjectP[Object[Data,qPCR]]]),
	myOptions:OptionsPattern[AnalyzeQuantificationCycleOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	(*Get the resolved options for AnalyzeQuantificationCycle*)
	resolvedOptions=AnalyzeQuantificationCycle[myData,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeQuantificationCycle],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*AnalyzeQuantificationCyclePreview*)


DefineOptions[AnalyzeQuantificationCyclePreview,
	SharedOptions:>{AnalyzeQuantificationCycle}
];


AnalyzeQuantificationCyclePreview[
	myData:(ObjectP[Object[Protocol,qPCR]]|ListableP[ObjectP[Object[Data,qPCR]]]),
	myOptions:OptionsPattern[AnalyzeQuantificationCyclePreview]
]:=Module[{listedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Display the plot preview for AnalyzeQuantificationCycle*)
	AnalyzeQuantificationCycle[myData,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeQuantificationCycleQ*)


DefineOptions[ValidAnalyzeQuantificationCycleQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{AnalyzeQuantificationCycle}
];


ValidAnalyzeQuantificationCycleQ[
	myData:(ObjectP[Object[Protocol,qPCR]]|ListableP[ObjectP[Object[Data,qPCR]]]),
	myOptions:OptionsPattern[ValidAnalyzeQuantificationCycleQ]
]:=Module[
	{listedOptions,preparedOptions,analyzeQuantificationCycleTests,initialTestDescription,allTests,verbose,outputFormat},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Remove the output option before passing to the core function because it doesn't make sense here*)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(*Get the tests for AnalyzeQuantificationCycle*)
	analyzeQuantificationCycleTests=AnalyzeQuantificationCycle[myData,Append[preparedOptions,Output->Tests]];

	(*Define the general test description*)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all the tests, including the blanket test*)
	allTests=If[MatchQ[analyzeQuantificationCycleTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(*Generate the initial test, which should pass if we got this far*)
			initialTest=Test[initialTestDescription,True,True];

			(*Create warnings for invalid objects*)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myData],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myData],_String],validObjectBooleans}
			];

			(*Get all the tests/warnings*)
			Cases[Flatten[{initialTest,analyzeQuantificationCycleTests,voqWarnings}],_EmeraldTest]
		]
	];

	(*Look up the test-running options*)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(*Run the tests as requested*)
	Lookup[RunUnitTest[<|"ValidAnalyzeQuantificationCycleQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],"ValidAnalyzeQuantificationCycleQ"]
];
