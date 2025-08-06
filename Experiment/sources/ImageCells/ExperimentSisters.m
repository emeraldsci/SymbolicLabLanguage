(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentImageCellsQ*)


DefineOptions[ValidExperimentImageCellsQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentImageCells}
];


(* --- Overloads --- *)
ValidExperimentImageCellsQ[mySample:ObjectP[{Object[Sample],Model[Sample]}],myOptions:OptionsPattern[ValidExperimentImageCellsQ]]:=ValidExperimentImageCellsQ[{mySample},myOptions];
ValidExperimentImageCellsQ[myContainer:ObjectP[Object[Container]],myOptions:OptionsPattern[ValidExperimentImageCellsQ]]:=ValidExperimentImageCellsQ[{myContainer},myOptions];

ValidExperimentImageCellsQ[myContainers:{ObjectP[Object[Container]]..},myOptions:OptionsPattern[ValidExperimentImageCellsQ]]:=Module[
	{listedOptions,preparedOptions,imageCellsTests,initialTestDescription,allTests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* return only the tests for ExperimentImageCells *)
	imageCellsTests=ExperimentImageCells[myContainers,Append[preparedOptions,Output->Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[imageCellsTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription,True,True];

			(* create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[Download[myContainers,Object],OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[myContainers,Object],validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest,imageCellsTests,voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentImageCellsQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentImageCellsQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentImageCellsQ"]

];

(* --- Overload for SemiPooledInputs --- *)
ValidExperimentImageCellsQ[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[Object[Sample]],ObjectP[Model[Sample]],ObjectP[Object[Container]],_String]]],myOptions:OptionsPattern[ValidExperimentImageCellsQ]]:=Module[
	{listedOptions,preparedOptions,imageCellsTests,allTests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* return only the tests for ExperimentImageCells *)
	imageCellsTests=ExperimentImageCells[mySemiPooledInputs,Append[preparedOptions,Output->Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests=Module[
		{validObjectBooleans,voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans=ValidObjectQ[Flatten[mySemiPooledInputs],OutputFormat->Boolean];
		voqWarnings=MapThread[
			Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{Flatten[mySemiPooledInputs],validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{imageCellsTests,voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentImageCellsQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentImageCellsQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentImageCellsQ"]

];


(* --- Core Function --- *)
ValidExperimentImageCellsQ[myPooledSamples:ListableP[{ObjectP[{Object[Sample],Model[Sample]}]..}],myOptions:OptionsPattern[ValidExperimentImageCellsQ]]:=Module[
	{listedOptions,preparedOptions,imageCellsTests,allTests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* return only the tests for ExperimentImageCells *)
	imageCellsTests=ExperimentImageCells[myPooledSamples,Append[preparedOptions,Output->Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests=Module[
		{validObjectBooleans,voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans=ValidObjectQ[Flatten[myPooledSamples],OutputFormat->Boolean];
		voqWarnings=MapThread[
			Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{Flatten[myPooledSamples],validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{imageCellsTests,voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentImageCellsQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentImageCellsQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentImageCellsQ"]

];



(* ::Subsection::Closed:: *)
(*ExperimentImageCellsOptions*)


DefineOptions[ExperimentImageCellsOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentImageCells}
];

(* --- Overloads --- *)
ExperimentImageCellsOptions[mySample:ObjectP[{Object[Sample],Model[Sample]}],myOptions:OptionsPattern[ExperimentImageCellsOptions]]:=ExperimentImageCellsOptions[{mySample},myOptions];
ExperimentImageCellsOptions[myContainer:ObjectP[Object[Container]],myOptions:OptionsPattern[ExperimentImageCellsOptions]]:=ExperimentImageCellsOptions[{myContainer},myOptions];
ExperimentImageCellsOptions[myContainers:{ObjectP[Object[Container]]..},myOptions:OptionsPattern[ExperimentImageCellsOptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentImageCells *)
	options=ExperimentImageCells[myContainers,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentImageCells],
		options
	]

];

(* --- Overload for SemiPooledInputs --- *)
ExperimentImageCellsOptions[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[Object[Sample]],ObjectP[Model[Sample]],ObjectP[Object[Container]],_String]]],myOptions:OptionsPattern[ExperimentImageCellsOptions]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentImageCells *)
	options=ExperimentImageCells[mySemiPooledInputs,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentImageCells],
		options
	]
];

(* --- Core Function for PooledSamples--- *)
ExperimentImageCellsOptions[myPooledSamples:ListableP[{ObjectP[{Object[Sample],Model[Sample]}]..}],myOptions:OptionsPattern[ExperimentImageCellsOptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentImageCells *)
	options=ExperimentImageCells[myPooledSamples,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentImageCells],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentImageCellsPreview*)


DefineOptions[ExperimentImageCellsPreview,
	SharedOptions:>{ExperimentImageCells}
];

(* --- Overloads --- *)
ExperimentImageCellsPreview[mySample:ObjectP[{Object[Sample],Model[Sample]}],myOptions:OptionsPattern[ExperimentImageCellsPreview]]:=ExperimentImageCellsPreview[{mySample},myOptions];
ExperimentImageCellsPreview[myContainer:ObjectP[Object[Container]],myOptions:OptionsPattern[ExperimentImageCellsPreview]]:=ExperimentImageCellsPreview[{myContainer},myOptions];
ExperimentImageCellsPreview[myContainers:{ObjectP[Object[Container]]..},myOptions:OptionsPattern[ExperimentImageCellsPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_]];

	(* return only the preview for ExperimentImageCells *)
	ExperimentImageCells[myContainers,Append[noOutputOptions,Output->Preview]]

];

(* SemiPooledInputs *)
ExperimentImageCellsPreview[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[Object[Sample]],ObjectP[Model[Sample]],ObjectP[Object[Container]],_String]]],myOptions:OptionsPattern[ExperimentImageCellsPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_]];

	(* return only the preview for ExperimentImageCells *)
	ExperimentImageCells[mySemiPooledInputs,Append[noOutputOptions,Output->Preview]]
];

(* --- Core Function --- *)
ExperimentImageCellsPreview[myPooledSamples:ListableP[{ObjectP[{Object[Sample],Model[Sample]}]..}],myOptions:OptionsPattern[ExperimentImageCellsPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_]];

	(* return only the preview for ExperimentImageCells *)
	ExperimentImageCells[myPooledSamples,Append[noOutputOptions,Output->Preview]]
];