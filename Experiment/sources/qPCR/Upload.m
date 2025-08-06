(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*UploadArrayCard*)


(* ::Subsubsection::Closed:: *)
(*UploadArrayCard Options and Messages*)


DefineOptions[UploadArrayCard,
	Options:>{
		{
			OptionName->Name,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->String,Pattern:>_String,Size->Line],
			Description->"The name of the array card model.",
			Category->"Organizational Information"
		},
		OutputOption
	}
];


Error::TooManyInputsForArrayCard="The number of inputs cannot exceed 384. Please reduce the number of inputs.";
Warning::ArrayCardExists="An array card with these primers and probes already exists. Please use `1` directly in ExperimentqPCR.";


(* ::Subsubsection::Closed:: *)
(*UploadArrayCard*)


UploadArrayCard[
	myPrimerPairs:ListableP[{ObjectP[Model[Molecule,Oligomer]],ObjectP[Model[Molecule,Oligomer]]}],
	myProbes:ListableP[ObjectP[Model[Molecule]]],
	myOptions:OptionsPattern[UploadArrayCard]
]:=Module[
	{outputSpecification,output,gatherTests,messages,
		myPrimerPairsNamed,myProbesNamed,myOptionsNamed,safeOptionsNamed,safeOptionTests,
		listedPrimerPairs,listedProbes,safeOptions,listedOptions,listedForwardPrimers,listedReversePrimers,
		validLengths,validLengthTests,tooManyInputsQ,tooManyInputs,tooManyInputsTest,
		existingArrayCards,arrayCardExistsQ,arrayCardExistsTest,
		name,validNameQ,invalidNameOptions,validNameTest,author,resolvedName,
		invalidInputs,invalidOptions,allTests,resolvedOptionsResult,
		testsRule,optionsRule,previewRule,positions,positionPlotting,arrayCardModelPacket,
		allTestResults,resultRule},

	(*Determine the requested return value from the function*)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*--Remove temporal links--*)
	{{myPrimerPairsNamed,myProbesNamed},myOptionsNamed}=removeLinks[
		{ToList[myPrimerPairs],ToList[myProbes]},
		ToList[myOptions]
	];

	(*--Call SafeOptions and ValidInputLengthsQ--*)
	(*Call SafeOptions to make sure all options match patterns*)
	{safeOptionsNamed,safeOptionTests}=If[gatherTests,
		SafeOptions[UploadArrayCard,myOptionsNamed,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[UploadArrayCard,myOptionsNamed,AutoCorrect->False],{}}
	];

	(*Sanitize the inputs and options*)
	{{listedPrimerPairs,listedProbes},{safeOptions,listedOptions}}=sanitizeInputs[{myPrimerPairsNamed,myProbesNamed},{safeOptionsNamed,myOptionsNamed}];

	(*Separate the forward and reverse primers*)
	listedForwardPrimers=listedPrimerPairs[[All,1]];
	listedReversePrimers=listedPrimerPairs[[All,2]];

	(*Call ValidInputLengthsQ to make sure all inputs and options have matching lengths*)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[UploadArrayCard,{listedPrimerPairs,listedProbes},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[UploadArrayCard,{listedPrimerPairs,listedProbes},listedOptions],Null}
	];

	(*If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[
			outputSpecification /. {
				Result->$Failed,
				Tests->safeOptionTests,
				Preview->Null,
				Options->$Failed
			}
		]
	];

	(*If input and option lengths are invalid, return $Failed (or the tests up to this point)*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(*--Input validation and option resolution--*)

	(*-Too many inputs check-*)

	(*Check if there are too many samples for the array card*)
	tooManyInputsQ=TrueQ[Length[listedPrimerPairs]>384];

	(*Set tooManyInputs to all sample objects*)
	tooManyInputs=If[tooManyInputsQ,
		Flatten[{listedForwardPrimers,listedReversePrimers,listedProbes}],
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message*)
	If[Length[tooManyInputs]>0&&messages,
		Message[Error::TooManyInputsForArrayCard]
	];

	(*If we are gathering tests, create a test for too many inputs*)
	tooManyInputsTest=If[gatherTests,
		Test["The number of inputs does not exceed 384:",
			tooManyInputsQ,
			False
		],
		Nothing
	];

	(*-Existing array card check-*)

	(*Search for array cards with the same detection reagents*)
	existingArrayCards=Intersection@@MapThread[
		Search[
			Model[Container,Plate,Irregular,ArrayCard],
			ForwardPrimers==#1&&ReversePrimers==#2&&Probes==#3
		]&,
		{listedForwardPrimers,listedReversePrimers,listedProbes}
	];

	(*Check if there are too many samples for the array card*)
	arrayCardExistsQ=!MatchQ[existingArrayCards,{}];

	(*If arrayCardExistsQ is True and we are throwing messages, throw an error message*)
	If[arrayCardExistsQ&&messages,
		Message[Warning::ArrayCardExists,ObjectToString[existingArrayCards[[1]]]]
	];

	(*If we are gathering tests, create a test for existing array card*)
	arrayCardExistsTest=If[gatherTests,
		Test["An array card with these primers and probes doesn't already exist:",
			arrayCardExistsQ,
			False
		],
		Nothing
	];

	(*--Check that Name is properly specified--*)
	name=Lookup[safeOptions,Name];

	(*If the specified Name is a string, check if this name exists in the Database already*)
	validNameQ=If[MatchQ[name,_String],
		!DatabaseMemberQ[Model[Container,Plate,Irregular,ArrayCard,name]],
		True
	];

	(*If validNameQ is False and we are throwing messages, then throw an error message*)
	invalidNameOptions=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"array card"];
			{Name}
		),
		{}
	];

	(*If we are gathering tests, create a test for Name*)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already an array card model name:",
			validNameQ,
			True
		],
		Nothing
	];

	(*-Resolve the hidden Author option. Either it's Null (meaning we're being called by a User, so they are the author) or it's passed via Engine, and is a root protocol Author-*)
	author=If[MatchQ[Lookup[safeOptions,Author],ObjectP[Object[User]]],
		Lookup[safeOptions,Author],
		$PersonID
	];

	(*-Resolve the Name option. If it's not specified, make a unique name with the current time-*)
	resolvedName=If[NullQ[name],
		"Array Card"<>DateString[Now,"ISODateTime"],
		name
	];

	(*--Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary--*)
	invalidInputs=DeleteDuplicates[Flatten[{tooManyInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{invalidNameOptions}]];
	allTests=Flatten[{safeOptionTests,tooManyInputsTest,arrayCardExistsTest,validNameTest}];

	(*Throw Error::InvalidInput if there are invalid inputs*)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs]]
	];

	(*Throw Error::InvalidOption if there are invalid options*)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	resolvedOptionsResult=If[Length[invalidInputs]>0||Length[invalidOptions]>0,
		$Failed,
		safeOptions
	];

	(*Make output rules*)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];
	optionsRule=Options->safeOptions;
	previewRule=Preview->Null;

	(*Return early if option resolution failed*)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{Result->$Failed,testsRule,optionsRule,previewRule}]
	];

	(*Return early if we already have an array card*)
	If[arrayCardExistsQ&&messages,
		Return[outputSpecification/.{Result->existingArrayCards[[1]],testsRule,optionsRule,previewRule}]
	];

	(*--Prepare the upload packet--*)
	positions=MapThread[
		<|
			Name->#1,
			Footprint->Null,
			MaxWidth->#2,
			MaxDepth->#3,
			MaxHeight->#4
		|>&,
		{
			Join[
				Flatten[AllWells[NumberOfWells->384]],
				ToString/@Range[8]
			],
			Join[
				Table[2.5 Millimeter,384],
				Table[7.0 Millimeter,8]
			],
			Join[
				Table[2.5 Millimeter,384],
				Table[7.0 Millimeter,8]
			],
			Join[
				Table[0.5 Millimeter,384],
				Table[2.0 Millimeter,8]
			]
		}
	];

	positionPlotting=MapThread[
			<|
				Name->#1,
				XOffset->#2,
				YOffset->#3,
				ZOffset->0.0 Millimeter,
				CrossSectionalShape->#4,
				Rotation->0.0
			|>&,
		{
			Join[
				Flatten[AllWells[NumberOfWells->384]],
				ToString/@Range[8]
			],
			Flatten[Join[
				Table[Table[12.1 Millimeter+4.5 Millimeter*x,{x,0,23}],16],
				Table[141.9 Millimeter,8]
			]],
			Flatten[Join[
				Table[#,24]&/@Table[75.85 Millimeter-4.5 Millimeter*x,{x,0,15}],
				Table[73.51 Millimeter-9 Millimeter*x,{x,0,7}]
			]],
			Table[Circle,392]
		}
	];

	arrayCardModelPacket=<|
		Type->Model[Container,Plate,Irregular,ArrayCard],
		Name->resolvedName,
		Replace[Synonyms]->resolvedName,
		Replace[Authors]->Link[author],

		(*Storage Information*)
		Expires->True,
		ShelfLife->12 Month,
		DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],

		(*Container Specifications*)
		ImageFile->Link[Object[EmeraldCloudFile,"id:D8KAEvGOeDvl"]],
		Replace[Schematics]->{Link[Object[EmeraldCloudFile,"id:o1k9jAGYBBd7"]],"A quantitative polymerase chain reaction (qPCR) microfluidic array card that contains 8 sample loading reservoirs and 384 reaction wells."},
		Reusable->False,
		Opaque->True,
		SelfStanding->True,
		TareWeight->29.5 Gram,
		Treatment->NonTreated,
		PlateColor->OpaqueWhite,
		WellColor->OpaqueWhite,
		WellDiameter->2.5 Millimeter,
		HorizontalMargin->10.85 Millimeter,
		VerticalMargin->8.55 Millimeter,
		DepthMargin->0 Millimeter,
		HorizontalPitch->4.5 Millimeter,
		VerticalPitch->4.5 Millimeter,
		HorizontalOffset->0 Millimeter,
		VerticalOffset->0 Millimeter,
		WellDepth->0.5 Millimeter,
		WellBottom->FlatBottom,
		Replace[WellColors]->Table[OpaqueWhite,392],
		Replace[WellTreatments]->Table[NonTreated,392],
		Replace[WellDiameters]->Join[Table[2.5 Millimeter,384],Table[7.0 Millimeter,8]],
		Replace[WellDepths]->Join[Table[0.5 Millimeter,384],Table[2.0 Millimeter,8]],
		Replace[WellBottoms]->Table[FlatBottom,392],
		Replace[ForwardPrimers]->Link[listedForwardPrimers],
		Replace[ReversePrimers]->Link[listedReversePrimers],
		Replace[Probes]->Link[listedProbes],

		(*Operating Limits*)
		MinTemperature->-80 Celsius,
		MaxTemperature->121 Celsius,
		MinVolume->0.001Microliter,
		MaxVolume->100 Microliter,
		Replace[MinVolumes]->Table[0.001 Microliter,392],
		Replace[MaxVolumes]->Join[Table[2 Microliter,384],Table[100 Microliter,8]],
		Replace[RecommendedFillVolumes]->Join[Table[2 Microliter,384],Table[100 Microliter,8]],

		(*Qualifications & Maintenance*)
		VerifiedContainerModel->True,

		(*Dimensions & Positions*)
		Dimensions->{152.63 Millimeter,85.65 Millimeter,9.39 Millimeter},
		CrossSectionalShape->Rectangle,
		Footprint->ArrayCard,
		Replace[Positions]->positions,
		Replace[PositionPlotting]->positionPlotting,
		Rows->16,
		Columns->24,
		NumberOfWells->384,
		AspectRatio->3/2,

		(*Health & Safety*)
		RNaseFree->True,
		
		(*Cover*)
		Replace[CoverTypes]->{Seal},

		(*Method Information*)
		Replace[Counterweights]->Link[Model[Item,Counterweight,"Array Card Counterweight"],Counterweights]
	|>;

	(*run the tests that we have generated to make sure we can go on*)
	allTestResults=If[gatherTests,
		RunUnitTest[<|"Tests"->allTests|>,OutputFormat->SingleBoolean,Verbose->False],
		MatchQ[resolvedOptionsResult,Except[$Failed]]
	];

	(*prepare the Result rule if asked; do not bother if we hit a failure on any of our above checks*)
	resultRule=Result->If[MemberQ[output,Result],
		If[!TrueQ[allTestResults],
			$Failed,
			Upload[arrayCardModelPacket]
		],
		Null
	];

	(*return the requested outputs per the non-listed Output option*)
	outputSpecification/.{resultRule,testsRule,optionsRule,previewRule}
];


(* ::Subsection::Closed:: *)
(*UploadArrayCardOptions*)


DefineOptions[UploadArrayCardOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{UploadArrayCard}
];


UploadArrayCardOptions[
	myPrimerPairs:ListableP[{ObjectP[Model[Molecule,Oligomer]],ObjectP[Model[Molecule,Oligomer]]}],
	myProbes:ListableP[ObjectP[Model[Molecule]]],
	myOptions:OptionsPattern[UploadArrayCardOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=UploadArrayCard[myPrimerPairs,myProbes,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,UploadArrayCard],
		resolvedOptions
	]
];


(* ::Subsection:: *)
(*UploadArrayCardPreview*)


DefineOptions[UploadArrayCardPreview,
	SharedOptions:>{UploadArrayCard}
];


UploadArrayCardPreview[
	myPrimerPairs:ListableP[{ObjectP[Model[Molecule,Oligomer]],ObjectP[Model[Molecule,Oligomer]]}],
	myProbes:ListableP[ObjectP[Model[Molecule]]],
	myOptions:OptionsPattern[UploadArrayCardPreview]
]:=Module[
	{listedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	UploadArrayCard[myPrimerPairs,myProbes,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection::Closed:: *)
(*ValidUploadArrayCardQ*)


DefineOptions[ValidUploadArrayCardQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{UploadArrayCard}
];


ValidUploadArrayCardQ[
	myPrimerPairs:ListableP[{ObjectP[Model[Molecule,Oligomer]],ObjectP[Model[Molecule,Oligomer]]}],
	myProbes:ListableP[ObjectP[Model[Molecule]]],
	myOptions:OptionsPattern[ValidUploadArrayCardQ]
]:=Module[
	{listedOptions,preparedOptions,uploadArrayCardTests,initialTestDescription,allTests,verbose,outputFormat},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Remove the output option before passing to the core function because it doesn't make sense here*)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(*Call the ExperimentPCR function to get a list of tests*)
	uploadArrayCardTests=UploadArrayCard[myPrimerPairs,myProbes,Append[preparedOptions,Output->Tests]];

	(*Define the general test description*)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test*)
	allTests=If[MatchQ[uploadArrayCardTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(*Generate the initial test, which should pass if we got this far*)
			initialTest=Test[initialTestDescription,True,True];

			(*Create warnings for invalid objects*)
			validObjectBooleans=ValidObjectQ[Flatten[{myPrimerPairs,myProbes}],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Flatten[{myPrimerPairs,myProbes}],validObjectBooleans}
			];

			(*Get all the tests/warnings*)
			Flatten[{initialTest,uploadArrayCardTests,voqWarnings}]
		]
	];

	(*Look up the test-running options*)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(*Run the tests as requested*)
	Lookup[RunUnitTest[<|"ValidUploadArrayCardQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidUploadArrayCardQ"]
];