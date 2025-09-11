(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentNephelometrySisters*)



(* ::Subsection::Closed:: *)
(*ExperimentNephelometryPreview*)


DefineOptions[ExperimentNephelometryPreview,
	SharedOptions:>{ExperimentNephelometry}
];


ExperimentNephelometryPreview[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentNephelometryPreview[{sampleIn},myOptions];

ExperimentNephelometryPreview[samplesIn:{(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptionsNamed,noOutputOptions},

	(* get the options as a list *)
	listedOptionsNamed=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptionsNamed,Output->_];

	(* return only the preview for ExperimentNephelometry *)
	ExperimentNephelometry[samplesIn,Append[noOutputOptions,Output->Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentNephelometryOptions*)


DefineOptions[ExperimentNephelometryOptions,
	SharedOptions:>{ExperimentNephelometry},
	{
		OptionName->OutputFormat,
		Default->Table,
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
		Description->"Determines whether the function returns a table or a list of the options."
	}
];

ExperimentNephelometryOptions[sampleIn:(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentNephelometryOptions[{sampleIn},myOptions];

ExperimentNephelometryOptions[samplesIn:{(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptionsNamed,noOutputOptions,options},

	(* get the options as a list *)
	listedOptionsNamed=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptionsNamed,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentNephelometry *)
	options=ExperimentNephelometry[samplesIn,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptionsNamed,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentNephelometry],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentNephelometryQ*)


DefineOptions[ValidExperimentNephelometryQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentNephelometry}
];


ValidExperimentNephelometryQ[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentNephelometryQ]]:=Module[
	{listedInput,listedOptionsNamed,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptionsNamed=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptionsNamed,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentNephelometry[myInput,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentNephelometryQ,Normal@KeyTake[listedOptionsNamed,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentNephelometry"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentNephelometry"
	]
];


