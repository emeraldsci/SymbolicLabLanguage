(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsubsection:: *)
(* ExperimentAcousticLiquidHandlingPreview *)


DefineOptions[ExperimentAcousticLiquidHandlingPreview,
	SharedOptions:>{ExperimentAcousticLiquidHandling}
];

(* ---overloads--- *)
ExperimentAcousticLiquidHandlingPreview[myPrimitive:SampleManipulationP,myOptions:OptionsPattern[]]:=ExperimentAcousticLiquidHandlingPreview[{myPrimitive},myOptions];
ExperimentAcousticLiquidHandlingPreview[myPrimitives:{SampleManipulationP..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Output->_];

	(* return only the preview for ExperimentAcousticLiquidHandling *)
	ExperimentAcousticLiquidHandling[myPrimitives,Append[noOutputOptions,Output->Preview]]
];


(* ::Subsection::Closed:: *)
(*ExperimentAcousticLiquidHandlingOptions*)


DefineOptions[ExperimentAcousticLiquidHandlingOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentAcousticLiquidHandling}
];

(* ---overloads--- *)
ExperimentAcousticLiquidHandlingOptions[myPrimitive:SampleManipulationP,myOptions:OptionsPattern[]]:=ExperimentAcousticLiquidHandlingOptions[{myPrimitive},myOptions];
ExperimentAcousticLiquidHandlingOptions[myPrimitives:{SampleManipulationP..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentAcousticLiquidHandling *)
	options=ExperimentAcousticLiquidHandling[myPrimitives,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentAcousticLiquidHandling],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentAcousticLiquidHandlingQ*)


DefineOptions[ValidExperimentAcousticLiquidHandlingQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentAcousticLiquidHandling}
];

(* ---overloads--- *)
ValidExperimentAcousticLiquidHandlingQ[myPrimitive:SampleManipulationP,myOptions:OptionsPattern[ValidExperimentAcousticLiquidHandlingQ]]:=ValidExperimentAcousticLiquidHandlingQ[{myPrimitive},myOptions];
ValidExperimentAcousticLiquidHandlingQ[myPrimitives:{SampleManipulationP..},myOptions:OptionsPattern[ValidExperimentAcousticLiquidHandlingQ]]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat},

	(* extract all the objects from our primitives to run VOQ*)
	listedInput=Cases[myPrimitives,ObjectP[],Infinity];

	(* make sure our options is in a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for ExperimentAcousticLiquidHandling *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentAcousticLiquidHandling[myPrimitives,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[listedInput,OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{listedInput,validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest},functionTests,voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps=SafeOptions[ValidExperimentAcousticLiquidHandlingQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentAcousticLiquidHandling"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentAcousticLiquidHandling"
	]
];


(* ::Subsection::Closed:: *)
(*resolveAcousticLiquidHandlingSamplePrepOptions*)


DefineOptions[resolveAcousticLiquidHandlingSamplePrepOptions,
	Options:>{
		SamplePrepOptions,
		AliquotOptions,
		CacheOption,
		OutputOption
	}
];


resolveAcousticLiquidHandlingSamplePrepOptions[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,cache,collapsedOptions,expandedOptions,samplePrepOptions,
		aliquotOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[listedOptions],Cache,{}];

	(* collapse our index-matched options so that we can re-expand since SamplesIn length may have changed *)
	collapsedOptions=CollapseIndexMatchedOptions[
		Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions,
		listedOptions,
		Messages->False
	];

	(* Expand index-matching options *)
	expandedOptions=Last[ExpandIndexMatchedInputs[Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions,{ToList[mySamples]},collapsedOptions]];

	(* Separate out our Sample Prep options. *)
	samplePrepOptions=First[Experiment`Private`splitPrepOptions[expandedOptions]];

	(* Separate out our AliquotOptions from our Sample Prep options. *)
	aliquotOptions=First[Experiment`Private`splitPrepOptions[samplePrepOptions,PrepOptionSets->{AliquotOptions}]];

	(* Resolve our sample prep options *)
	(* TODO: samplePrepTests seems to be returned as {}. double check if this happens in every cases *)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
		Experiment`Private`resolveSamplePrepOptions[
			resolveAcousticLiquidHandlingSamplePrepOptions,
			mySamples,
			samplePrepOptions,
			Cache->cache,
			Output->{Result,Tests}
		],
		{Experiment`Private`resolveSamplePrepOptions[
			resolveAcousticLiquidHandlingSamplePrepOptions,
			mySamples,
			samplePrepOptions,
			Cache->cache,
			Output->Result],{}}
	];

	(* Return our results *)
	(* call FlattenCachePackets on simulatedCache to remove duplicates and non-packet items *)
	{
		{
			simulatedSamples,
			Flatten[{resolvedSamplePrepOptions,aliquotOptions}],
			FlattenCachePackets[simulatedCache]
		},
		samplePrepTests
	}

];

