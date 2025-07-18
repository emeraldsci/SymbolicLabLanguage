(* ::Package:: *)

(* ::Subsection:: *)
(*ExperimentTotalProteinDetectionPreview*)

DefineOptions[ExperimentTotalProteinDetectionPreview,
	SharedOptions:>{ExperimentTotalProteinDetection}
];

ExperimentTotalProteinDetectionPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentTotalProteinDetectionPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentTotalProteinDetection[myInputs,ReplaceRule[listedOptions,Output->Preview]]
];

(* ::Subsection:: *)
(*ExperimentTotalProteinDetectionOptions*)

DefineOptions[ExperimentTotalProteinDetectionOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentTotalProteinDetection}
];

ExperimentTotalProteinDetectionOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentTotalProteinDetectionOptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* Get only the options for ExperimentTotalProteinDetection *)
	options=ExperimentTotalProteinDetection[myInputs,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentTotalProteinDetection],
		options
	]
];

(* ::Subsection:: *)
(*ValidExperimentTotalProteinDetectionQ*)

DefineOptions[ValidExperimentTotalProteinDetectionQ,
	Options:>
			{
				VerboseOption,
				OutputFormatOption
			},
	SharedOptions:>{ExperimentTotalProteinDetection}
];

ValidExperimentTotalProteinDetectionQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentTotalProteinDetectionQ]]:=Module[
	{listedOptions,preparedOptions,experimentTotalProteinDetectionTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentTotalProteinDetection *)
	experimentTotalProteinDetectionTests=ExperimentTotalProteinDetection[myInputs,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[experimentTotalProteinDetectionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myInputs],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,experimentTotalProteinDetectionTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentTotalProteinDetectionQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentTotalProteinDetectionQ"]
];
