(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*ExperimentLyophilizePreview*)


DefineOptions[ExperimentLyophilizePreview,
	SharedOptions :> {ExperimentLyophilize}
];


ExperimentLyophilizePreview[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentLyophilizePreview[{sampleIn},myOptions];
ExperimentLyophilizePreview[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for ExperimentLyophilize *)
	ExperimentLyophilize[samplesIn, Append[noOutputOptions, Output -> Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentLyophilizeOptions*)


DefineOptions[ExperimentLyophilizeOptions,
	SharedOptions :> {ExperimentLyophilize},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];


ExperimentLyophilizeOptions[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentLyophilizeOptions[{sampleIn},myOptions];
ExperimentLyophilizeOptions[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentLyophilize *)
	options = ExperimentLyophilize[samplesIn, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options,ExperimentLyophilize],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentLyophilizeQ*)


DefineOptions[ValidExperimentLyophilizeQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentLyophilize}
];


ValidExperimentLyophilizeQ[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ValidExperimentLyophilizeQ[{sampleIn},myOptions];
ValidExperimentLyophilizeQ[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, preparedOptions, massSpecTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentLyophilize *)
	massSpecTests = ExperimentLyophilize[samplesIn, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[massSpecTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[samplesIn,_String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[samplesIn,_String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, massSpecTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentLyophilizeQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentLyophilizeQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentLyophilizeQ"]];



(* ::Section:: *)
(*End Private*)