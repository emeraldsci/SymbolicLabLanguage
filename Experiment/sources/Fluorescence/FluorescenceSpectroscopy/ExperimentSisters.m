(* ::Package:: *)

(* ::Subsection:: *)
(*ExperimentFluorescenceSpectroscopyPreview*)


DefineOptions[ExperimentFluorescenceSpectroscopyPreview,
	SharedOptions :> {ExperimentFluorescenceSpectroscopy}
];

ExperimentFluorescenceSpectroscopyPreview[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ExperimentFluorescenceSpectroscopyPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentFluorescenceSpectroscopy[myInput,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection:: *)
(*ExperimentFluorescenceSpectroscopyOptions*)


DefineOptions[ExperimentFluorescenceSpectroscopyOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentFluorescenceSpectroscopy}
];

ExperimentFluorescenceSpectroscopyOptions[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ExperimentFluorescenceSpectroscopyOptions]]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentFluorescenceSpectroscopy[myInput,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentFluorescenceSpectroscopy],
		resolvedOptions
	]
];


(* ::Subsection:: *)
(*ValidExperimentFluorescenceSpectroscopyQ*)


DefineOptions[ValidExperimentFluorescenceSpectroscopyQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentFluorescenceSpectroscopy}
];

ValidExperimentFluorescenceSpectroscopyQ[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ValidExperimentFluorescenceSpectroscopyQ]]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentFluorescenceSpectroscopy[myInput,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{DeleteCases[listedInput,_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest},functionTests,voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps=SafeOptions[ValidExperimentFluorescenceSpectroscopyQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"FK"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"FK"
	]
];
