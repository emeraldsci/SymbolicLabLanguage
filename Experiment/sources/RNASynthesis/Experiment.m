(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Experiment RNASynthesis: Source*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentRNASynthesis*)

(* ::Subsubsection:: *)
(*ExperimentRNASynthesis Options*)

DefineOptions[ExperimentRNASynthesis,
	Options :> {
		RNASynthesisOptions,
		NNASharedSet,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption,
		ProtocolOptions,
		PostProcessingOptions,
		SamplesOutStorageOptions
	}
];


(* ::Subsubsection:: *)
(*ExperimentRNASynthesis *)
ExperimentRNASynthesis[myStrands : ListableP[Alternatives[ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], SequenceP, StrandP, StructureP]], myOptions : OptionsPattern[]]:= experimentNNASynthesis[RNA, ToList[myStrands], myOptions];



(* ::Subsubsection::Closed:: *)
(*ExperimentRNASynthesisOptions*)


DefineOptions[ExperimentRNASynthesisOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentRNASynthesis}
];

ExperimentRNASynthesisOptions[myInputs : ListableP[Alternatives[ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], SequenceP, StrandP, StructureP]], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentRNASynthesis *)
	options = ExperimentRNASynthesis[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentRNASynthesis],
		options
	]
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentRNASynthesisQ*)

DefineOptions[ValidExperimentRNASynthesisQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentRNASynthesis}
];


ValidExperimentRNASynthesisQ[myInputs : ListableP[Alternatives[ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], SequenceP, StrandP, StructureP]], myOptions : OptionsPattern[]] := Module[
	{listedOptions, preparedOptions, ExperimentRNASynthesisTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentRNASynthesis *)
	ExperimentRNASynthesisTests = ExperimentRNASynthesis[myInputs, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[ExperimentRNASynthesisTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{
				initialTest, validObjectBooleans, voqWarnings, inputObjects, inputStrands,
				inputSequences, validStrandBooleans, validStrandsWarnings,
				validSequenceBooleans, validSequencesWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* sort inputs by what kind of input this is *)
			inputObjects = Cases[ToList[myInputs], ObjectP[]];
			inputStrands = Cases[ToList[myInputs], StrandP[]];
			inputSequences = Cases[ToList[myInputs], SequenceP[]];

			(* create warnings for invalid objects *)
			validObjectBooleans=If[
				Length[inputObjects] > 0,
				ValidObjectQ[inputObjects, OutputFormat -> Boolean],
				{}
			];
			voqWarnings=If[Length[inputObjects] > 0, Module[{}, MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{inputObjects, validObjectBooleans}
			]],
				{}
			];

			(* create warnings for invalid Strands *)
			validStrandBooleans=If[
				Length[inputStrands] > 0,
				ValidStrandQ[inputStrands],
				{}
			];
			validStrandsWarnings=If[Length[inputStrands] > 0, Module[{}, MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidStrandQ for more detailed information):"],
					#2,
					True
				]&,
				{inputStrands, validStrandBooleans}
			]],
				{}
			];

			(* create warnings for invalid Strands *)
			validSequenceBooleans=If[
				Length[inputSequences] > 0,
				ValidSequenceQ[inputSequences],
				{}
			];
			validSequencesWarnings=If[Length[inputSequences] > 0, Module[{}, MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidSequenceQ for more detailed information):"],
					#2,
					True
				]&,
				{inputSequences, validSequenceBooleans}
			]],
				{}
			];

			(* get all the tests/warnings *)
			DeleteCases[Flatten[{initialTest, ExperimentRNASynthesisTests, voqWarnings, validStrandsWarnings, validSequencesWarnings}], Null]
		]
	];
	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentRNASynthesisQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentRNASynthesisQ"]
];



(* ::Subsubsection::Closed:: *)
(*ExperimentRNASynthesisPreview*)


DefineOptions[ExperimentRNASynthesisPreview,
	SharedOptions :> {ExperimentRNASynthesis}
];

ExperimentRNASynthesisPreview[myInputs : ListableP[Alternatives[ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], SequenceP, StrandP, StructureP]], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentRNASynthesis *)
	ExperimentRNASynthesis[myInputs, Append[noOutputOptions, Output -> Preview]]

];
