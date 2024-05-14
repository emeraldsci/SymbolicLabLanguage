(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentAliquotQ*)


DefineOptions[ValidExperimentAliquotQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentAliquot}
];

(* --- Overloads --- *)
ValidExperimentAliquotQ[mySample:ObjectP[Object[Sample]],myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[{{mySample}},myOptions];

ValidExperimentAliquotQ[mySample:ObjectP[Object[Sample]],myAmount:(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All),myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[{{mySample}},{{myAmount}},myOptions];

ValidExperimentAliquotQ[myContainer:ObjectP[Object[Container]], myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[{{myContainer}}, myOptions];

ValidExperimentAliquotQ[myContainers:{ListableP[ObjectP[Object[Container]]]..}, myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=Module[
	{listedOptions, preparedOptions, aliquotTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentAliquot *)
	aliquotTests = ExperimentAliquot[myContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[aliquotTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[myContainers, Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[myContainers, Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, aliquotTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentAliquotQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentAliquotQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentAliquotQ"]

];

ValidExperimentAliquotQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myAmount:(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All),myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[mySamples,ConstantArray[myAmount,Length[mySamples]],myOptions];

ValidExperimentAliquotQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myAmounts:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=Module[
	{updatedOptions},

	(* update these option values in the provided options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {Amount -> myAmounts}];

	(* pipe to the main overload *)
	ValidExperimentAliquotQ[mySamples,updatedOptions]
];

ValidExperimentAliquotQ[myContainer:ObjectP[Object[Container]], myAmount:(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[{{myContainer}}, {{myAmount}}, myOptions];

ValidExperimentAliquotQ[myContainers:{ListableP[ObjectP[Object[Container]]]..}, myAmount:(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[myContainers, ConstantArray[myAmount, Length[myContainers]], myOptions];

ValidExperimentAliquotQ[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myAmounts : {ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..}, myOptions : OptionsPattern[ValidExperimentAliquotQ]] := Module[
	{updatedOptions},

	(* update these option values in the provided options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {Amount -> myAmounts}];

	(* pipe to the main overload *)
	ValidExperimentAliquotQ[myContainers, updatedOptions]

];

ValidExperimentAliquotQ[mySample:ObjectP[Object[Sample]],myConcentration:(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)]),myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[{{mySample}},{{myConcentration}},myOptions];

ValidExperimentAliquotQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myConcentration:(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)]),myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[mySamples,ConstantArray[myConcentration,Length[mySamples]],myOptions];

ValidExperimentAliquotQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myConcentrations:{ListableP[(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)])]..},myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=Module[
	{updatedOptions},

	(* update these option values in the safe options *)
	updatedOptions=Normal@Append[<|ToList[myOptions]|>,
		{
			TargetConcentration->myConcentrations
		}
	];

	(* pipe to the main overload *)
	ValidExperimentAliquotQ[mySamples,updatedOptions]
];

ValidExperimentAliquotQ[myContainer:ObjectP[Object[Container]], myConcentration:(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)]), myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[{{myContainer}}, {{myConcentration}}, myOptions];

ValidExperimentAliquotQ[myContainers:{ListableP[ObjectP[Object[Container]]]..}, myConcentration:(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)]), myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=ValidExperimentAliquotQ[myContainers, ConstantArray[myConcentration, Length[myContainers]], myOptions];

ValidExperimentAliquotQ[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myConcentrations : {ListableP[(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)])]..}, myOptions : OptionsPattern[ValidExperimentAliquotQ]] := Module[
	{updatedOptions},

	(* update these option values in the safe options *)
	updatedOptions = Normal@Append[<|ToList[myOptions]|>,
		{
			TargetConcentration -> myConcentrations
		}
	];

	(* pipe to the main overload *)
	ValidExperimentAliquotQ[myContainers, updatedOptions]

];

(* --- Core Function --- *)
ValidExperimentAliquotQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myOptions:OptionsPattern[ValidExperimentAliquotQ]]:=Module[
	{listedOptions,preparedOptions,aliquotTests,allTests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* return only the tests for ExperimentAliquot *)
	aliquotTests=ExperimentAliquot[mySamples,Append[preparedOptions,Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests=Module[
		{validObjectBooleans,voqWarnings,testResults},

		(* create warnings for invalid objects *)
		validObjectBooleans=ValidObjectQ[mySamples,OutputFormat->Boolean];
		voqWarnings=MapThread[
			Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{mySamples,validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{aliquotTests,voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentAliquotQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]],
		it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out - Steven
	 	^ what he said - Cam *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentAliquotQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentAliquotQ"]
];


(* ::Subsection::Closed:: *)
(*ExperimentAliquotOptions*)


DefineOptions[ExperimentAliquotOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentAliquot}
];

(* --- Overloads --- *)
ExperimentAliquotOptions[mySample : ObjectP[Object[Sample]], myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[{{mySample}}, myOptions];

ExperimentAliquotOptions[myContainer : ObjectP[Object[Container]], myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[{{myContainer}}, myOptions];

ExperimentAliquotOptions[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myOptions : OptionsPattern[ExperimentAliquotOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentAliquot *)
	options = ExperimentAliquot[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentAliquot],
		options
	]

];

ExperimentAliquotOptions[mySample : ObjectP[Object[Sample]], myAmount : (GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[{{mySample}}, {{myAmount}}, myOptions];

ExperimentAliquotOptions[mySamples : {ListableP[ObjectP[Object[Sample]]]..}, myAmount : (GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[mySamples, ConstantArray[myAmount, Length[mySamples]], myOptions];

ExperimentAliquotOptions[mySamples : {ListableP[ObjectP[Object[Sample]]]..}, myAmounts : {ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..}, myOptions : OptionsPattern[ExperimentAliquotOptions]] := Module[
	{updatedOptions},

	(* update these option values in the provided options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {Amount -> myAmounts}];

	(* pipe to the main overload *)
	ExperimentAliquotOptions[mySamples, updatedOptions]
];

ExperimentAliquotOptions[myContainer : ObjectP[Object[Container]], myAmount : (GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[{{myContainer}}, {{myAmount}}, myOptions];

ExperimentAliquotOptions[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myAmount : (GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[myContainers, ConstantArray[myAmount, Length[myContainers]], myOptions];

ExperimentAliquotOptions[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myAmounts : {ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..}, myOptions : OptionsPattern[ExperimentAliquotOptions]] := Module[
	{updatedOptions},

	(* update these option values in the safe options *)
	updatedOptions = Normal@Append[<|ToList[myOptions]|>,
		{
			Amount -> myAmounts
		}
	];

	(* pipe to the main overload *)
	ExperimentAliquotOptions[myContainers, updatedOptions]
];

ExperimentAliquotOptions[mySample : ObjectP[Object[Sample]], myConcentration : (GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[{{mySample}}, {{myConcentration}}, myOptions];

ExperimentAliquotOptions[mySamples : {ListableP[ObjectP[Object[Sample]]]..}, myConcentration : (GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[mySamples, ConstantArray[myConcentration, Length[mySamples]], myOptions];

ExperimentAliquotOptions[mySamples : {ListableP[ObjectP[Object[Sample]]]..}, myConcentrations : {ListableP[(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)])]..}, myOptions : OptionsPattern[ExperimentAliquotOptions]] := Module[
	{updatedOptions},

	(* update these option values in the safe options *)
	updatedOptions = Normal@Append[<|ToList[myOptions]|>,
		{
			TargetConcentration -> myConcentrations
		}
	];

	(* pipe to the main overload *)
	ExperimentAliquotOptions[mySamples, updatedOptions]
];


ExperimentAliquotOptions[myContainer : ObjectP[Object[Container]], myConcentration : (GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[{{myContainer}}, {{myConcentration}}, myOptions];

ExperimentAliquotOptions[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myConcentration : (GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions : OptionsPattern[ExperimentAliquotOptions]] := ExperimentAliquotOptions[myContainers, ConstantArray[myConcentration, Length[myContainers]], myOptions];

ExperimentAliquotOptions[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myConcentrations : {ListableP[(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)])]..}, myOptions : OptionsPattern[ExperimentAliquotOptions]] := Module[
	{updatedOptions},

	(* update these option values in the safe options *)
	updatedOptions = Normal@Append[<|ToList[myOptions]|>,
		{
			TargetConcentration -> myConcentrations
		}
	];

	(* pipe to the main overload *)
	ExperimentAliquotOptions[myContainers, updatedOptions]
];


(* --- Core Function --- *)
ExperimentAliquotOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myOptions:OptionsPattern[ExperimentAliquotOptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentAliquot *)
	options=ExperimentAliquot[mySamples,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentAliquot],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentAliquotPreview*)


DefineOptions[ExperimentAliquotPreview,
	SharedOptions:>{ExperimentAliquot}
];

(* --- Overloads --- *)
ExperimentAliquotPreview[mySample:ObjectP[Object[Sample]],myOptions:OptionsPattern[ExperimentAliquotPreview]]:=ExperimentAliquotPreview[{{mySample}},myOptions];

ExperimentAliquotPreview[mySample:ObjectP[Object[Sample]],myAmount:(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All),myOptions:OptionsPattern[ExperimentAliquotPreview]]:=ExperimentAliquotPreview[{{mySample}},{{myAmount}},myOptions];

ExperimentAliquotPreview[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myAmount:(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All),myOptions:OptionsPattern[ExperimentAliquotPreview]]:=ExperimentAliquotPreview[mySamples,ConstantArray[myAmount,Length[mySamples]],myOptions];

ExperimentAliquotPreview[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myAmounts:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},myOptions:OptionsPattern[ExperimentAliquotPreview]]:=Module[
	{updatedOptions},

	(* update these option values in the provided options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {Amount -> myAmounts}];

	(* pipe to the main overload *)
	ExperimentAliquotPreview[mySamples,updatedOptions]
];

ExperimentAliquotPreview[mySample:ObjectP[Object[Sample]],myConcentration:(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)]),myOptions:OptionsPattern[ExperimentAliquotPreview]]:=ExperimentAliquotPreview[{{mySample}},{{myConcentration}},myOptions];

ExperimentAliquotPreview[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myConcentration:(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)]),myOptions:OptionsPattern[ExperimentAliquotPreview]]:=ExperimentAliquotPreview[mySamples,ConstantArray[myConcentration,Length[mySamples]],myOptions];

ExperimentAliquotPreview[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myConcentrations:{ListableP[(GreaterP[0 Molar]|GreaterP[0 (Gram/Liter)])]..},myOptions:OptionsPattern[ExperimentAliquotPreview]]:=Module[
	{updatedOptions},

	(* update these option values in the safe options *)
	updatedOptions=Normal@Append[<|ToList[myOptions]|>,
		{
			TargetConcentration->myConcentrations
		}
	];

	(* pipe to the main overload *)
	ExperimentAliquotPreview[mySamples,updatedOptions]
];

(* --- Core Function --- *)
ExperimentAliquotPreview[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myOptions:OptionsPattern[ExperimentAliquotPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Output->_];

	(* return only the options for ExperimentAliquot *)
	ExperimentAliquot[mySamples,Append[noOutputOptions,Output->Preview]]
];
