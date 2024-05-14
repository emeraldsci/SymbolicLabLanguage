(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentNephelometryKineticsSisters*)


(* ::Subsection::Closed:: *)
(*ExperimentNephelometryKineticsPreview*)


DefineOptions[ExperimentNephelometryKineticsPreview,
	SharedOptions:>{ExperimentNephelometryKinetics}
];


ExperimentNephelometryKineticsPreview[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentNephelometryKineticsPreview[{sampleIn},myOptions];

ExperimentNephelometryKineticsPreview[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptionsNamed,noOutputOptions},

	(* get the options as a list *)
	listedOptionsNamed=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptionsNamed,Output->_];

	(* return only the preview for ExperimentNephelometryKinetics *)
	ExperimentNephelometryKinetics[samplesIn,Append[noOutputOptions,Output->Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentNephelometryKineticsOptions*)


DefineOptions[ExperimentNephelometryKineticsOptions,
	SharedOptions:>{ExperimentNephelometryKinetics},
	{
		OptionName->OutputFormat,
		Default->Table,
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
		Description->"Determines whether the function returns a table or a list of the options."
	}
];

ExperimentNephelometryKineticsOptions[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentNephelometryKineticsOptions[{sampleIn},myOptions];

ExperimentNephelometryKineticsOptions[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptionsNamed,noOutputOptions,options},

	(* get the options as a list *)
	listedOptionsNamed=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions=DeleteCases[listedOptionsNamed,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentNephelometryKinetics *)
	options=ExperimentNephelometryKinetics[samplesIn,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptionsNamed,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentNephelometryKinetics],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentNephelometryKineticsQ*)


DefineOptions[ValidExperimentNephelometryKineticsQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentNephelometryKinetics}
];


ValidExperimentNephelometryKineticsQ[myInput:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentNephelometryKineticsQ]]:=Module[
	{listedInput,listedOptionsNamed,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptionsNamed=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptionsNamed,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentNephelometryKinetics[myInput,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentNephelometryKineticsQ,Normal@KeyTake[listedOptionsNamed,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentNephelometryKinetics"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentNephelometryKinetics"
	]
];


