(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*ExperimentEvaporatePreview*)


DefineOptions[ExperimentEvaporatePreview,
	SharedOptions :> {ExperimentEvaporate}
];


ExperimentEvaporatePreview[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentEvaporatePreview[{sampleIn},myOptions];
ExperimentEvaporatePreview[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for ExperimentEvaporate *)
	ExperimentEvaporate[samplesIn, Append[noOutputOptions, Output -> Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentEvaporateOptions*)


DefineOptions[ExperimentEvaporateOptions,
	SharedOptions :> {ExperimentEvaporate},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];


ExperimentEvaporateOptions[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentEvaporateOptions[{sampleIn},myOptions];
ExperimentEvaporateOptions[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentEvaporate *)
	options = ExperimentEvaporate[samplesIn, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options,ExperimentEvaporate],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentEvaporateQ*)


DefineOptions[ValidExperimentEvaporateQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentEvaporate}
];


ValidExperimentEvaporateQ[myInput:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentEvaporateQ]]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentEvaporate[myInput,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentEvaporateQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentEvaporate"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentEvaporate"
	]
];



(* ::Section:: *)
(*End Private*)
