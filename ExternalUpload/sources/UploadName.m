(* ::Package:: *)

(* ::Subsection:: *)
(*UploadName*)


(* ::Subsubsection::Closed:: *)
(*UploadName Options and Messages*)


(* Define Options *)
DefineOptions[UploadName,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Inputs",
			{
				OptionName -> Synonyms,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word], Orientation -> Horizontal],
				Description -> "Additional names of the object.",
				ResolutionDescription -> "Automatically resolves based on the number of objects being named."
			}
		],
		{
			OptionName -> OverwriteSynonyms,
			Default -> True,
			Description -> "If True, will overwrite any existing synonyms. If False, will append given synonyms to current synonyms.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},
		OutputOption,
		UploadOption,
		CacheOption,
		FastTrackOption
	}
];

(* Define Messages *)
Error::NameAlreadyInUse="The name `1` for type `2` is already taken, please try a different name.";


(* ::Subsubsection::Closed:: *)
(*UploadName*)

(* Define Main Function *)
UploadName[myObjects:ListableP[ObjectP[]], myNames:ListableP[_String], myOptions:OptionsPattern[]]:=Module[
	{
		listedObjects, listedNames, listedOptions,
		outputSpecification, output, gatherTests, safeOptions, safeOptionTests,
		validLengths, validLengthTests,
		allObjects, cache, newCache, inputPacketSpecs, inputDownload,
		overwritePrefix, synonyms, resolvedSynonyms, resolvedOptions,
		databaseMembers, type, databaseCheck, duplicateNameCheck, allTypes, namesWithSameType,
		nameTests, validNameChecks, validNameBool, badObjects, badNames,
		packetsToUpload, alreadyUploadedSynonyms, synonymsToUpload,
		optionsRule, previewRule, testsRule, resultRule
	},

	(* Make sure the inputs are lists *)
	listedObjects=ToList[myObjects];
	listedNames=ToList[myNames];

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[UploadName, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[UploadName, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidOptionLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths, validLengthTests}=Quiet[
		If[gatherTests,
			ValidInputLengthsQ[UploadName, {listedObjects, listedNames}, safeOptions, Output -> {Result, Tests}],
			{ValidInputLengthsQ[UploadName, {listedObjects, listedNames}, safeOptions], Null}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* -------------------------------- Download call ------------------------------------------ *)

	(* look up cache *)
	cache=Lookup[safeOptions, Cache];

	(* Convert and links or packets in listedObjects to objects *)
	allObjects=Download[listedObjects, Object];

	(* create packet spects for downloading from each of the input objects *)
	inputPacketSpecs=
		If[MemberQ[ECL`Fields[Download[#, Type], Output -> Short], Synonyms],
			{Packet[Synonyms, Name]},
			{Packet[Name]}
		]& /@ allObjects;

	(* Download information from input objects according to packet specs. Pass the cache *)
	inputDownload=Download[allObjects, inputPacketSpecs, Cache -> cache];

	(* Create new cache *)
	newCache=Join[cache, Cases[inputDownload, PacketP[]]];

	(* --------------------------- Resolve all of the options -------------------------------*)

	(* Resolve overwrite Synonyms *)
	overwritePrefix=If[Lookup[safeOptions, OverwriteSynonyms],
		Replace,
		Append
	];

	(* Resolve synonyms Option *)
	synonyms=Lookup[safeOptions, Synonyms];

	resolvedSynonyms=Which[

		(* If Null or automatic*)
		MatchQ[synonyms, (Null | Automatic)], {#}& /@ listedNames,

		(* If a single list of strings*)
		MatchQ[synonyms, {_String..}], {Prepend[synonyms, First[listedNames]]},

		(* If multiple lists of strings/Automatic/Null*)
		MatchQ[synonyms, {(({_String..} | Automatic) | Null)..}], MapThread[
			Function[{synonyms, name},
				If[MatchQ[synonyms, (Automatic | Null)],
					{name},
					Prepend[synonyms, name]
				]
			],
			{synonyms, listedNames}
		]
	];

	resolvedOptions={Synonyms -> resolvedSynonyms, OverwriteSynonyms -> Lookup[safeOptions, OverwriteSynonyms]};

	(*----------------------------------- Generate Packets to Upload -------------------------- *)

	(* Check if names are already in the database*)
	databaseMembers=DatabaseMemberQ[
		MapThread[
			Function[{packet, name},
				type=First[Download[packet, Type]];
				Append[type, name]
			],
			{inputDownload, listedNames}
		]
	];


	(* Either already in the database but already has this name or not in the database*)
	databaseCheck=MapThread[
		Function[{packet, name, inDatabase},
			inDatabase && MatchQ[First[Lookup[packet, Name]], name] || !inDatabase
		],
		{inputDownload, listedNames, databaseMembers}
	];

	(* Check if multiple objects of the same type are being given the same name *)
	allTypes=Download[listedObjects, Type];

	duplicateNameCheck=MapThread[
		Function[{object, name},
			namesWithSameType=PickList[listedNames, allTypes, Download[object, Type]];
			Count[namesWithSameType, name] < 2
		],
		{allObjects, listedNames}
	];


	(* If Testing, generate unique name tests for each object *)
	nameTests=If[gatherTests,
		MapThread[
			Function[{database, duplicate, packet, name},
				Test[("Test if "<>name<>" is a valid name for "<>ToString[Download[packet, Object]]<>"."),
					database && duplicate,
					True
				]
			],
			{databaseCheck, duplicateNameCheck, inputDownload, listedNames}
		],
		{}
	];

	(* Make sure every name is not already being used *)
	validNameChecks=MapThread[
		Function[{database, duplicate},
			database && duplicate
		],
		{databaseCheck, duplicateNameCheck}
	];

	validNameBool=validNameChecks /. {List -> And};

	(* Throw error messages if there is a nonunique name and tests are not being outputted *)
	If[!gatherTests && !validNameBool,
		badNames=PickList[listedNames, validNameChecks, False];
		badObjects=PickList[listedObjects, validNameChecks, False];
		Message[Error::NameAlreadyInUse, badNames, badObjects]
	];

	(* Generate packets to upload *)
	packetsToUpload=
		MapThread[
			Function[{object, name, resolvedSyn, packet},
				If[KeyExistsQ[First[packet], Synonyms],
					alreadyUploadedSynonyms=First[Lookup[packet, Synonyms]];
					synonymsToUpload=If[MemberQ[alreadyUploadedSynonyms, name] && MatchQ[overwritePrefix, Append],
						DeleteCases[resolvedSyn, name],
						resolvedSyn
					];
					<|Object -> object, Name -> name, overwritePrefix[Synonyms] -> synonymsToUpload|>,
					<|Object -> object, Name -> name|>
				]
			]
			, {allObjects, listedNames, resolvedSynonyms, inputDownload}
		];


	(* ---------------------Generate Rules for each possible Output value -------------------------*)

	(* Prepare the Options result if asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		resolvedOptions,
		Null
	];

	(* There is nothing to preview, always return Null *)
	previewRule=(Preview -> Null);

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all existing tests generated by helper functions with any additional tests *)
		Flatten[{safeOptionTests, validLengthTests, nameTests}],
		Null
	];

	(* Prepare the standard result if we were asked for it and can safely do so *)
	resultRule=Result -> If[MemberQ[output, Result],
		If[!validNameBool,
			$Failed,
			Upload[packetsToUpload]
		],
		Null
	];

	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}

];


(* ::Subsubsection::Closed:: *)
(*UploadNameOptions*)


DefineOptions[UploadNameOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {UploadName}
];


(* Define Main Function*)
UploadNameOptions[myObjects:ListableP[ObjectP[]], myNames:ListableP[_String], myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions, noOutputOptions, options
	},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to core function because it does not make sense to have *)
	noOutputOptions=DeleteCases[listedOptions, (Output | OutputFormat) -> _];

	(* return only the options for UploadName *)
	options=UploadName[myObjects, myNames, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadName],
		options
	]
];


(* ::Subsubsection::Closed:: *)
(*UploadNamePreview*)


DefineOptions[UploadNamePreview,
	SharedOptions :> {UploadName}
];


(* Main Function Definition *)
(* Singleton Input Overload *)
UploadNamePreview[myObjects:ListableP[ObjectP[]], myNames:ListableP[_String], myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions, noOutputOptions
	},
	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense *)
	noOutputOptions=DeleteCases[listedOptions, Output -> _];

	(* return only the preview for UploadName *)
	UploadName[myObjects, myNames, Append[noOutputOptions, Output -> Preview]]
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadNameQ*)


DefineOptions[ValidUploadNameQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadName}
];


(* Define Main Function *)
ValidUploadNameQ[myObjects:ListableP[ObjectP[]], myNames:ListableP[_String], myOptions:OptionsPattern[]]:=Module[
	{
		listedObjects, listedOptions, preparedOptions, uploadNameTests, initialTestDescription, allTests,
		verbose, outputFormat
	},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* get the inputs as a list *)
	listedObjects=ToList[myObjects];

	(* remove the Output, Verbose option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for DiscardSamples *)
	uploadNameTests=UploadName[listedObjects, myNames, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[uploadNameTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far *)
			initialTest=Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[listedObjects, OutputFormat -> Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1, InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{listedObjects, validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, uploadNameTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidDiscardSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadNameQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadNameQ"]
];
