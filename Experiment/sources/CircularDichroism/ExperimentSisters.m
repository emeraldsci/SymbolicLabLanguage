(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentCircularDichroismSisters*)


(* ::Subsection::Closed:: *)
(*ValidExperimentCircularDichroismQ*)


DefineOptions[ValidExperimentCircularDichroismQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentCircularDichroism}
];


(* samples overloads *)
ValidExperimentCircularDichroismQ[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ValidExperimentCircularDichroismQ]] := Module[
	{listedOptions, preparedOptions, absSpecTests, initialTestDescription, allTests, verbose, outputFormat, listedSamples},

	(* get the options as a list *)
	(* also get the samples as a list *)
	listedOptions = ToList[myOptions];
	listedSamples = ToList[mySamples];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentCircularDichroism *)
	absSpecTests = ExperimentCircularDichroism[listedSamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[absSpecTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[listedSamples, _String], Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ObjectToString[#1], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[listedSamples, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, absSpecTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentCircularDichroismQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests  *)
	Lookup[RunUnitTest[<|"ValidExperimentCircularDichroismQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentCircularDichroismQ"]

];


(* plates overloads *)
ValidExperimentCircularDichroismQ[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentCircularDichroismQ]] := Module[
	{listedOptions, preparedOptions, absSpecTests, initialTestDescription, allTests, verbose, outputFormat, listedContainers},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedContainers = ToList[myContainers];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentCircularDichroism *)
	absSpecTests = ExperimentCircularDichroism[listedContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[absSpecTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[listedContainers, _String], Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ObjectToString[#1], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[listedContainers, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, absSpecTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentCircularDichroismQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests *)
	Lookup[RunUnitTest[<|"ValidExperimentCircularDichroismQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentCircularDichroismQ"]

];


(* ::Subsection::Closed:: *)
(*ExperimentCircularDichroismOptions*)


DefineOptions[ExperimentCircularDichroismOptions,
	SharedOptions :> {ExperimentCircularDichroism},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

(* samples overloads *)
ExperimentCircularDichroismOptions[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentCircularDichroismOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentCircularDichroism *)
	options = ExperimentCircularDichroism[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentCircularDichroism],
		options
	]
];


(* containers overloads *)
ExperimentCircularDichroismOptions[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentCircularDichroismOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentCircularDichroism *)
	options = ExperimentCircularDichroism[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentCircularDichroism],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentCircularDichroismPreview*)


DefineOptions[ExperimentCircularDichroismPreview,
	SharedOptions :> {ExperimentCircularDichroism}
];


(* samples overloads *)
ExperimentCircularDichroismPreview[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentCircularDichroismPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentCircularDichroism[mySamples, Append[noOutputOptions, Output -> Preview]]
];


(* container overloads *)
ExperimentCircularDichroismPreview[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentCircularDichroismPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentCircularDichroism[myContainers, Append[noOutputOptions, Output -> Preview]]
];
