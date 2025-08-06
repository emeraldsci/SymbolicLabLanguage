(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentQuantifyCells Sisters*)

(* ::Subsection:: *)
(*ValidExperimentQuantifyCellsQ*)


DefineOptions[ValidExperimentQuantifyCellsQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentQuantifyCells}
];


ValidExperimentQuantifyCellsQ[mySamples:ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions:OptionsPattern[ValidExperimentQuantifyCellsQ]] := Module[
	{listedOptions, preparedOptions, experimentQuantifyCellsTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Get the options as a list *)
	listedOptions = ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* Return only the tests for ExperimentQuantifyCells *)
	experimentQuantifyCellsTests = ExperimentQuantifyCells[mySamples, Append[preparedOptions, Output -> Tests]];

	(* Define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test *)
	allTests = If[MatchQ[experimentQuantifyCellsTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[ToList[mySamples], _String], OutputFormat -> Boolean];

			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[mySamples], _String], validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest, experimentQuantifyCellsTests, voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentQuantifyCellsQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentQuantifyCellsQ"]
];



(* ::Subsection:: *)
(*ExperimentQuantifyCellsOptions*)


DefineOptions[ExperimentQuantifyCellsOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentQuantifyCells}
];


ExperimentQuantifyCellsOptions[mySamples:ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions:OptionsPattern[ExperimentQuantifyCellsOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* Get only the options for ExperimentQuantifyCells *)
	options = ExperimentQuantifyCells[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentQuantifyCells],
		options
	]
];




(* ::Subsection::Closed:: *)
(*ExperimentQuantifyCellsPreview*)


DefineOptions[ExperimentQuantifyCellsPreview,
	SharedOptions :> {ExperimentQuantifyCells}
];


ExperimentQuantifyCellsPreview[mySamples:ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions:OptionsPattern[ExperimentQuantifyCellsPreview]] := Module[
	{listedOptions},

	listedOptions = ToList[myOptions];

	ExperimentQuantifyCells[mySamples, ReplaceRule[listedOptions, Output -> Preview]]
]