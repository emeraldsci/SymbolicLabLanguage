(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*AnalyzeCopyNumber*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeCopyNumber Options and Messages*)


DefineOptions[AnalyzeCopyNumber,
	Options:>{
		(*===Method===*)
		{
			OptionName->Template,
			Default->Null,
			Description->"The template copy number analysis object whose methodology should be reproduced in running this analysis. Option values will be inherited from the template analysis object, but can be individually overridden by directly specifying values for the options for this analysis function.",
			AllowNull->True,
			Category->"Method",
			Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CopyNumber]]]
		},


		(*Shared Options*)
		OutputOption,
		UploadOption
	}
];


Error::InvalidFit="If a fit is provided, the ExpressionType is Linear and the DataUnits are {1, 1 Cycle}. Please select a valid fit object.";


(* ::Subsubsection::Closed:: *)
(*AnalyzeCopyNumber*)


AnalyzeCopyNumber[
	myAnalyses:ListableP[ObjectP[Object[Analysis,QuantificationCycle]]],
	myStandardCurve:ObjectP[Object[Analysis,Fit]]|ListableP[{GreaterP[0],ObjectP[Object[Analysis,QuantificationCycle]]}],
	ops:OptionsPattern[AnalyzeCopyNumber]
]:=Module[
	{listedAnalyses,listedStandardCurve,listedOptions,outputSpecification,output,gatherTests,messages,
		safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,
		upload,standardCurveDownloadFields,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,allTests,
		analysisPackets,uploadPackets,resultRule,testsRule,optionsRule,previewRule},

	(*Make sure we're working with a list of inputs (unless a fitted standard curve is given) and options*)
	listedAnalyses=ToList[myAnalyses];
	listedStandardCurve=If[MatchQ[myStandardCurve,ObjectP[Object[Analysis,Fit]]],
		myStandardCurve,
		ToList[myStandardCurve]
	];
	listedOptions=ToList[ops];

	(*Determine the requested return value from the function*)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Call SafeOptions to make sure all options match patterns*)
	{safeOps,safeOpsTests}=If[gatherTests,
		SafeOptions[AnalyzeCopyNumber,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeCopyNumber,listedOptions,AutoCorrect->False],Null}
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
		ValidInputLengthsQ[AnalyzeCopyNumber,{listedAnalyses,listedStandardCurve},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeCopyNumber,{listedAnalyses,listedStandardCurve},listedOptions],Null}
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
		ApplyTemplateOptions[AnalyzeCopyNumber,{listedAnalyses,listedStandardCurve},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeCopyNumber,{listedAnalyses,listedStandardCurve},listedOptions],Null}
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

	(*Look up the Upload option from inheritedOptions*)
	upload=Lookup[inheritedOptions,Upload];

	(*Determine which fields we need to download, depending on the StandardCurve input type*)
	standardCurveDownloadFields=If[MatchQ[listedStandardCurve,ObjectP[Object[Analysis,Fit]]],
		All,
		Packet[QuantificationCycle]
	];

	(*Make the upfront Download call*)
	cacheBall=Quiet[
		Download[
			{listedAnalyses,Cases[Flatten[ToList[listedStandardCurve]],ObjectP[]]},
			{
				{Packet[Protocol,Reference,Template,ForwardPrimer,ReversePrimer,Probe,QuantificationCycle]},
				{standardCurveDownloadFields}
			}
		],
		{Download::FieldDoesntExist}
	];

	(*--Build the resolved options--*)
	resolvedOptionsResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{resolvedOptions,resolvedOptionsTests}=resolveAnalyzeCopyNumberOptions[listedAnalyses,listedStandardCurve,inheritedOptions,Cache->cacheBall,Output->{Result,Tests}];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveAnalyzeCopyNumberOptions[listedAnalyses,listedStandardCurve,inheritedOptions,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(*Collapse the resolved options*)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		AnalyzeCopyNumber,
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
			Options->RemoveHiddenOptions[AnalyzeCopyNumber,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(*---Call the analyze helper function to perform copy number analysis and return packets---*)
	analysisPackets=analyzeCopyNumber[listedAnalyses,listedStandardCurve,resolvedOptions,Cache->cacheBall];

	uploadPackets=If[Length[analysisPackets]==1,
		First@analysisPackets,
		analysisPackets
	];


	(*---Prepare and return the output---*)

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
		RemoveHiddenOptions[AnalyzeCopyNumber,collapsedResolvedOptions],
		Null
	];

	(*Prepare the Preview result if we were asked to do so*)
	previewRule=Preview->If[MemberQ[output,Preview],
		ECL`PlotCopyNumber[uploadPackets,Legend->Null],
		Null
	];

	(*Return the requested output*)
	outputSpecification/.{resultRule,testsRule,optionsRule,previewRule}
];


(* ::Subsubsection:: *)
(*resolveAnalyzeCopyNumberOptions*)


DefineOptions[resolveAnalyzeCopyNumberOptions,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];


resolveAnalyzeCopyNumberOptions[
	myListedAnalyses:{ObjectP[Object[Analysis,QuantificationCycle]]..},
	myListedStandardCurve:ObjectP[Object[Analysis,Fit]]|ListableP[{GreaterP[0],ObjectP[Object[Analysis,QuantificationCycle]]}],
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[resolveAnalyzeCopyNumberOptions]
]:=Module[
	{outputSpecification,output,gatherTests,messages,myOptionsAssociation,template,upload,inheritedCache,
		standardCurvePackets,fittedStandardCurvePacket,validFitQ,invalidFitInputs,validFitTest,
		invalidInputs,resolvedOptions,allTests,resultRule,testsRule},

	(*---Set up the user-specified options and cache---*)

	(*Determine the requested return value from the function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	myOptionsAssociation=Association[myOptions];

	(*Look up the Template and Upload value*)
	{template,upload}=Lookup[myOptionsAssociation,{Template,Upload}];

	(*Get the inherited cache*)
	inheritedCache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(*Get the listed standard curve packet(s)*)
	standardCurvePackets=Flatten[inheritedCache[[2]]];

	(*If standardCurvePackets is a listed single fit packet, get the packet*)
	fittedStandardCurvePacket=If[MatchQ[standardCurvePackets,{PacketP[Object[Analysis,Fit]]}],
		First@standardCurvePackets
	];


	(*---Conflicting options checks---*)

	(*--Check that the provided fit is valid--*)

	(*If fittedStandardCurvePacket is a fit packet, check its Expression Type is Linear and the DataUnits are {1, 1 Cycle)*)
	validFitQ=If[!NullQ[fittedStandardCurvePacket],
		MatchQ[Lookup[fittedStandardCurvePacket,ExpressionType],Linear]&&MatchQ[Lookup[fittedStandardCurvePacket,DataUnits],{1,1 Cycle}],
		True
	];

	(*Set invalidFitInputs to the fit object if validTypeQ is False*)
	invalidFitInputs=If[validFitQ,
		{},
		Lookup[fittedStandardCurvePacket,Object]
	];

	(*If there are invalid inputs and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid inputs*)
	If[Length[invalidFitInputs]>0&&messages,
		Message[Error::InvalidFit,ECL`InternalUpload`ObjectToString[invalidFitInputs,Cache->Experiment`Private`FlattenCachePackets[inheritedCache]]]
	];

	(*If we are gathering tests, create a test*)
	validFitTest=If[gatherTests,
		Test["If a fit is provided, the ExpressionType is Linear and the DataUnits are {1, 1 Cycle}:",
			validFitQ,
			True
		],
		Nothing
	];


	(*---Check our invalid input variables and throw Error::InvalidInput if necessary---*)
	invalidInputs=DeleteDuplicates[Flatten[{
		invalidFitInputs
	}]];

	(*Throw Error::InvalidInput if there are invalid inputs*)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,ECL`InternalUpload`ObjectToString[invalidInputs,Cache->Experiment`Private`FlattenCachePackets[inheritedCache]]]
	];


	(*---Return our resolved options and tests---*)

	(*Gather the resolved options (pre-collapsed; that is happening outside the function)*)
	resolvedOptions=Flatten[{
		Template->template,
		Output->output,
		Upload->upload
	}];

	(*Gather the tests*)
	allTests=Cases[Flatten[{
		validFitTest
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


(* ::Subsubsection:: *)
(*analyzeCopyNumber*)


DefineOptions[analyzeCopyNumber,
	Options:>{
		CacheOption
	}
];


analyzeCopyNumber[
	myListedAnalyses:{ObjectP[Object[Analysis,QuantificationCycle]]..},
	myListedStandardCurve:ObjectP[Object[Analysis,Fit]]|ListableP[{GreaterP[0],ObjectP[Object[Analysis,QuantificationCycle]]}],
	myResolvedOptions:{_Rule..},
	myOptions:OptionsPattern[analyzeCopyNumber]
]:=Module[
	{inheritedCache,cqPackets,protocol,data,templateLink,forwardPrimerLink,reversePrimerLink,probeLink,cqValues,cqObjects,
		standardCurvePackets,fittedStandardCurvePacket,bestFit,logCopyNumberSolutions,copyNumberValues,bestFitSlope,efficiency,standardCurveObject},

	(*Get the inherited cache*)
	inheritedCache=Lookup[myOptions,Cache];

	(*Get information from the input Cq analysis objects*)
	cqPackets=Flatten[inheritedCache[[1]]];

	protocol=Lookup[cqPackets,Protocol]/.x:LinkP[]:>Download[x,Object];

	data=Lookup[cqPackets,Reference]/.{x:{}:>Null,x:{LinkP[]}:>First@Download[x,Object]};

	{templateLink,forwardPrimerLink,reversePrimerLink,probeLink,cqValues,cqObjects}=Transpose[Lookup[cqPackets,
		{Template,ForwardPrimer,ReversePrimer,Probe,QuantificationCycle,Object}
	]]/.x:LinkP[]:>Link[x];

	(*Get the listed standard curve packet(s)*)
	standardCurvePackets=Flatten[inheritedCache[[2]]];

	(*If standardCurvePackets is a listed single fit packet, use the packet, or make a new fit packet otherwise*)
	fittedStandardCurvePacket=If[MatchQ[standardCurvePackets,{PacketP[Object[Analysis,Fit]]}],
		First@standardCurvePackets,
		Module[
			{standardCurveCopyNumbers,standardCurveLogCopyNumbers,standardCurveCqValues,standardCurveDataPoints,newStandardCurvePacket},

			(*Get the data points for fitting a new standard curve*)
			standardCurveCopyNumbers=Cases[Flatten[myListedStandardCurve],GreaterP[0]];
			standardCurveLogCopyNumbers=Log10[standardCurveCopyNumbers];
			standardCurveCqValues=Lookup[standardCurvePackets,QuantificationCycle];
			standardCurveDataPoints=MapThread[
				{#1,#2}&,
				{standardCurveLogCopyNumbers,standardCurveCqValues}
			];

			(*Fit a new standard curve and return the packet*)
			newStandardCurvePacket=AnalyzeFit[
				standardCurveDataPoints,
				Linear,
				Upload->False
			];

			(*Add Reference and ReferenceField to the new fit object*)
			Append[newStandardCurvePacket,
				{
					Replace[Reference]->Map[Link[#,StandardCurveAnalyses]&,Lookup[standardCurvePackets,Object]],
					ReferenceField->QuantificationCycle
				}
			]

		]
	];

	(*Calculate the copy numbers corresponding to the input Cq values*)
	bestFit=Lookup[fittedStandardCurvePacket,BestFitExpression];
	logCopyNumberSolutions=Solve[#==bestFit,x]&/@Unitless[cqValues];
	copyNumberValues=SafeRound[10^Lookup[Flatten[logCopyNumberSolutions,1],x],1];

	(*Calculate the PCR efficiency corresponding to the fit*)
	bestFitSlope=D[bestFit,x];
	efficiency=(10^(-1/bestFitSlope)-1)*100;

	(*If a new fit was created, upload the packet*)
	standardCurveObject=If[KeyExistsQ[fittedStandardCurvePacket,Object],
		Lookup[fittedStandardCurvePacket,Object],
		Upload[fittedStandardCurvePacket]
	];

	(*Assemble the packet*)
	MapThread[
		<|
			Type->Object[Analysis,CopyNumber],
			Author->Link[$PersonID],
			ResolvedOptions->myResolvedOptions,
			Protocol->Link[#1,CopyNumberAnalyses],
			Data->Link[#2,CopyNumberAnalyses],
			Template->#3,
			ForwardPrimer->#4,
			ReversePrimer->#5,
			Probe->#6,
			StandardCurve->Link[standardCurveObject,PredictedValues],
			CopyNumber->#7,
			Efficiency->efficiency*Percent,
			Replace[Reference]->Link[#8,CopyNumberAnalyses],
			ReferenceField->QuantificationCycle
		|>&,
		{protocol,data,templateLink,forwardPrimerLink,reversePrimerLink,probeLink,copyNumberValues,cqObjects}
	]

];


(* ::Subsection::Closed:: *)
(*AnalyzeCopyNumberOptions*)


DefineOptions[AnalyzeCopyNumberOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{
		AnalyzeCopyNumber
	}
];


AnalyzeCopyNumberOptions[
	myAnalyses:ListableP[ObjectP[Object[Analysis,QuantificationCycle]]],
	myStandardCurve:ObjectP[Object[Analysis,Fit]]|ListableP[{GreaterP[0],ObjectP[Object[Analysis,QuantificationCycle]]}],
	myOptions:OptionsPattern[AnalyzeCopyNumberOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	(*Get the resolved options for AnalyzeCopyNumber*)
	resolvedOptions=AnalyzeCopyNumber[myAnalyses,myStandardCurve,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeCopyNumber],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*AnalyzeCopyNumberPreview*)


DefineOptions[AnalyzeCopyNumberPreview,
	SharedOptions:>{
		AnalyzeCopyNumber
	}
];


AnalyzeCopyNumberPreview[
	myAnalyses:ListableP[ObjectP[Object[Analysis,QuantificationCycle]]],
	myStandardCurve:ObjectP[Object[Analysis,Fit]]|ListableP[{GreaterP[0],ObjectP[Object[Analysis,QuantificationCycle]]}],
	myOptions:OptionsPattern[AnalyzeCopyNumberPreview]
]:=Module[{listedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Display the plot preview for AnalyzeCopyNumber*)
	AnalyzeCopyNumber[myAnalyses,myStandardCurve,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeCopyNumberQ*)


DefineOptions[ValidAnalyzeCopyNumberQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{
		AnalyzeCopyNumber
	}
];


ValidAnalyzeCopyNumberQ[
	myAnalyses:ListableP[ObjectP[Object[Analysis,QuantificationCycle]]],
	myStandardCurve:ObjectP[Object[Analysis,Fit]]|ListableP[{GreaterP[0],ObjectP[Object[Analysis,QuantificationCycle]]}],
	myOptions:OptionsPattern[ValidAnalyzeCopyNumberQ]
]:=Module[
	{listedOptions,preparedOptions,analyzeCopyNumberTests,initialTestDescription,allTests,verbose,outputFormat},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Remove the output option before passing to the core function because it doesn't make sense here*)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(*Get the tests for AnalyzeCopyNumber*)
	analyzeCopyNumberTests=AnalyzeCopyNumber[myAnalyses,myStandardCurve,Append[preparedOptions,Output->Tests]];

	(*Define the general test description*)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all the tests, including the blanket test*)
	allTests=If[MatchQ[analyzeCopyNumberTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(*Generate the initial test, which should pass if we got this far*)
			initialTest=Test[initialTestDescription,True,True];

			(*Create warnings for invalid objects*)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[{myAnalyses,myStandardCurve}],ObjectP[]],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[{myAnalyses,myStandardCurve}],ObjectP[]],validObjectBooleans}
			];

			(*Get all the tests/warnings*)
			Cases[Flatten[{initialTest,analyzeCopyNumberTests,voqWarnings}],_EmeraldTest]
		]
	];

	(*Look up the test-running options*)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(*Run the tests as requested*)
	Lookup[RunUnitTest[<|"ValidAnalyzeCopyNumberQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],"ValidAnalyzeCopyNumberQ"]
];