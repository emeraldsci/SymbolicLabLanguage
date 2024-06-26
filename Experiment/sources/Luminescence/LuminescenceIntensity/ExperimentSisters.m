(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentLuminescenceIntensityPreview*)

DefineOptions[ExperimentLuminescenceIntensityPreview,
	SharedOptions :> {ExperimentLuminescenceIntensity}
];

Authors[ExperimentLuminescenceIntensityPreview] := {"hayley"};

ExperimentLuminescenceIntensityPreview[myInput:(ListableP[ObjectP[Object[Sample]]]|ListableP[ObjectP[Object[Container,Plate]]]),myOptions:OptionsPattern[ExperimentLuminescenceIntensityPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentLuminescenceIntensity[myInput,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection:: *)
(*ExperimentLuminescenceIntensityOptions*)

DefineOptions[ExperimentLuminescenceIntensityOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentLuminescenceIntensity}
];

Authors[ExperimentLuminescenceIntensityOptions] := {"hayley"};

ExperimentLuminescenceIntensityOptions[myInput:(ListableP[ObjectP[Object[Sample]]]|ListableP[ObjectP[Object[Container,Plate]]]),myOptions:OptionsPattern[ExperimentLuminescenceIntensityOptions]]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentLuminescenceIntensity[myInput,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentLuminescenceIntensity],
		resolvedOptions
	]
];


(* ::Subsection:: *)
(*ValidExperimentLuminescenceIntensityQ*)


DefineOptions[ValidExperimentLuminescenceIntensityQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentLuminescenceIntensity}
];

Authors[ValidExperimentLuminescenceIntensityQ] := {"hayley"};

ValidExperimentLuminescenceIntensityQ[myInput:(ListableP[ObjectP[Object[Sample]]]|ListableP[ObjectP[Object[Container,Plate]]]),myOptions:OptionsPattern[ValidExperimentLuminescenceIntensityQ]]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentLuminescenceIntensity[myInput,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[listedInput,OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{listedInput,validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest},functionTests,voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps=SafeOptions[ValidExperimentLuminescenceIntensityQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"LI"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"LI"
	]
];


