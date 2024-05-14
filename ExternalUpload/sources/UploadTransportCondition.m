(* ::Package:: *)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*UploadTransportCondition*)


(* Define Options *)
DefineOptions[UploadTransportCondition,
	Options :> {
		OutputOption,
		UploadOption,
		CacheOption,
		FastTrackOption
	}
];

(* Define Messages *)
Warning::DiscardedSamples="The samples `1` are discarded. The transport condition will be uploaded but have no effect on the sample.";
Warning::DuplicateSamples="The samples `1` are duplicated. Therefore the last transport condition will be uploaded and others will be ignored.";
Error::IncompatibleTransportConditions="The samples and transport conditions, `1`, are not compatible. Please consider changing the transport condition.";

(* Singleton Input Overload *)
UploadTransportCondition[myObject:ObjectP[{Object[Sample], Model[Sample]}], myTransportCondition:Alternatives[TransportConditionP, RangeP[-86 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	First[UploadTransportCondition[{myObject}, {myTransportCondition}, myOptions]];

(* Overload with multiple objects all going to the same condition *)
UploadTransportCondition[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportCondition:Alternatives[TransportConditionP, RangeP[-86 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	UploadTransportCondition[myObjects, Repeat[myTransportCondition, Length[myObjects]], myOptions];

(* Define Main Function *)
UploadTransportCondition[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportConditions:{Alternatives[TransportConditionP, RangeP[-86 Celsius, 105 Celsius]]..}, myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions, outputSpecification, output,
		gatherTests, safeOptions, safeOptionTests,
		validLengths, validLengthsTests, upload,
		cache, inputPacketSpecs, inputDownload, allObjects, allIDs, newCache,
		notInEngine, discardedSamples, discardedSamplesCheck, discardedTests,
		idCounts, duplicateSamples, duplicateSamplesCheck, duplicateTests,
		packetsToUpload,
		optionsRule, previewRule, testsRule, resultRule, allResultingTransportInstruments,
		positionsOfFailed, failingObjectsAndConditions,objectsAndTCsFailed
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[UploadTransportCondition, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[UploadTransportCondition, listedOptions, AutoCorrect -> False], {}}
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
	{validLengths, validLengthsTests}=Quiet[
		If[gatherTests,
			ValidInputLengthsQ[UploadTransportCondition, {myObjects, myTransportConditions}, safeOptions, Output -> {Result, Tests}],
			{ValidInputLengthsQ[UploadTransportCondition, {myObjects, myTransportConditions}, safeOptions, Output -> Result], Null}
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

	(* Lookup the upload option *)
	upload=Lookup[safeOptions, Upload];

	(* --------------------------------------- Download call --------------------------------------- *)

	(* Look up cache *)
	cache=Lookup[safeOptions, Cache];

	(* Create packet spects for downloading from each of the input objects *)
	inputPacketSpecs={Packet[Object, ID, Status]}& /@ myObjects;

	(* Download information from input objects according to packet specs. Pass the cache *)
	inputDownload=Quiet[
		Download[myObjects, inputPacketSpecs, Cache -> cache],
		Download::FieldDoesntExist
	];

	(* Convert all links or packets in myObjects to objects *)
	{allObjects, allIDs, allStatus}=Transpose[
		{
			Lookup[First[#], Object],
			Lookup[First[#], ID],
			Lookup[First[#], Status]
		}& /@ inputDownload
	];

	newCache=Join[cache, Cases[inputDownload, PacketP[]]];

	(* ----------------------------- Generate Packets to Upload ------------------------------------ *)

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication, Engine]];

	(* Check if any of the samples are discarded *)
	discardedSamples=PickList[allObjects, allStatus, Discarded];
	discardedSamplesCheck=MatchQ[discardedSamples, {}];

	(* If Testing, generate discarded sample tests for each object *)
	discardedTests=If[gatherTests,
		MapThread[
			Function[{object, status},
				Warning[("Test if "<>ToString[object]<>" is discarded."),
					MatchQ[status, Discarded],
					False
				]
			],
			{allObjects, allStatus}
		],
		{}
	];

	(* Throw error message if a sample is discarded, tests are not being outputted, and we are not in Engine *)
	If[!gatherTests && !discardedSamplesCheck && notInEngine,
		Message[Warning::DiscardedSamples, discardedSamples]
	];

	(* Check if any of the samples are duplicates *)
	idCounts=Counts[allIDs];
	duplicateSamplesCheck=(Lookup[idCounts, #] < 2)& /@ allIDs;

	(* If Testing, generate discarded sample tests for each object *)
	duplicateTests=If[gatherTests,
		MapThread[
			Function[{object, duplicateCheck},
				Warning[("Test if "<>ToString[object]<>" is not a duplicate."),
					duplicateCheck,
					True
				]
			],
			{allObjects, duplicateSamplesCheck}
		],
		{}
	];

	(* Get the duplicate samples *)
	duplicateSamples=PickList[myObjects, duplicateSamplesCheck, False];

	(* Throw error messages if there is a nonunique object, tests are not being outputted, and we are not in Engine *)
	If[!gatherTests && !DuplicateFreeQ[allIDs] && notInEngine,
		Message[Warning::DuplicateSamples, duplicateSamples]
	];

	(* Generate packets to upload *)
	packetsToUpload=
		MapThread[
			Function[{sample, transportCondition},
				Switch[transportCondition,
					OvenDried, <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"OvenDried"]]|>,
					LightBox, <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"LightBox"]]|>,
					Chilled, <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"Chilled"]]|>,
					Minus40, <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"Minus 40"]]|>,
					Minus80, <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"Minus 80"]]|>,

					(*incubator for warm transport*)
					RangeP[37 Celsius, 105 Celsius], <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"OvenDried"]]|>,
					(*LightBox for room temp transport*)
					RangeP[25 Celsius, 37 Celsius], <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"LightBox"]]|>,
					(*cooler for chilled transport*)
					RangeP[4 Celsius, 25 Celsius], <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"Chilled"]]|>,
					(*cooler for Minus40 transport*)
					RangeP[-40 Celsius, 4 Celsius], <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"Minus 40"]]|>,
					(*cooler for Minus80 transport*)
					RangeP[-86 Celsius, -40 Celsius], <|Object -> sample, TransportCondition -> Link[Model[TransportCondition,"Minus 80"]]|>
				]
			],
			{allObjects, myTransportConditions}
		];

	(* call TransportDevices on each Object[Sample]/Model[Sample] and TransportCondition pair, if there are any failures in the outputs then throw an error *)
	allResultingTransportInstruments = Map[
		Quiet[TransportDevices[Lookup[#,Object],Lookup[#,TransportCondition][[1]]]]&,
		packetsToUpload
	];

	(*get objects and tcs of $Failed*)
	objectsAndTCsFailed = Lookup[PickList[packetsToUpload,allResultingTransportInstruments,$Failed],{Object,TransportCondition},{{},{}}];

	(*get corresponding samples and tcs from packetsToUpload*)
	If[Length[Flatten[objectsAndTCsFailed]]>0,
		Message[Error::IncompatibleTransportConditions,ToString[objectsAndTCsFailed]];
		Return[$Failed]
	];

	(* ----------------------- Generate Rules for each possible Output value -------------------------- *)

	(* No function specific options so always Null *)
	optionsRule=Options -> If[MemberQ[output, Options],
		{},
		Null
	];

	(* There is nothing to preview, always return Null *)
	previewRule=(Preview -> Null);

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all existing tests generated by helper functions with any additional tests *)
		Flatten[{safeOptionTests, validLengthsTests, discardedTests, duplicateTests}],
		Null
	];

	(* Prepare the standard result if we were asked for it *)
	resultRule=Result -> If[MemberQ[output, Result],
		If[upload,
			Upload[packetsToUpload],
			packetsToUpload
		],
		Null
	];

	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}

];


(* ::Subsection:: *)
(*UploadTransportConditionOptions*)

DefineOptions[UploadTransportConditionOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {UploadTransportCondition}
];

(* Singleton Overload *)
UploadTransportConditionOptions[myObject:ObjectP[{Object[Sample], Model[Sample]}], myTransportCondition:Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	UploadTransportConditionOptions[{myObject}, {myTransportCondition}, myOptions];

(* Overload with multiple objects all going to the same condition *)
UploadTransportConditionOptions[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportCondition:Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	UploadTransportConditionOptions[myObjects, Repeat[myTransportCondition, Length[myObjects]], myOptions];

(* Main function *)
UploadTransportConditionOptions[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportConditions:{Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]]..}, myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to core function because it does not make sense to have *)
	noOutputOptions=DeleteCases[listedOptions, (Output | OutputFormat) -> _];

	(* return only the options for UploadName *)
	options=UploadTransportCondition[myObjects, myTransportConditions, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadTransportCondition],
		options
	]

];


(* ::Subsection:: *)
(*UploadTransportConditionPreview*)

DefineOptions[UploadTransportConditionPreview,
	SharedOptions :> {UploadTransportCondition}
];

(* Singleton Overload *)
UploadTransportConditionPreview[myObject:ObjectP[{Object[Sample], Model[Sample]}], myTransportCondition:Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	UploadTransportConditionPreview[{myObject}, {myTransportCondition}, myOptions];

(* Overload with multiple objects all going to the same condition *)
UploadTransportConditionPreview[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportCondition:Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	UploadTransportConditionPreview[myObjects, Repeat[myTransportCondition, Length[myObjects]], myOptions];

(* Main Function *)
UploadTransportConditionPreview[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportConditions:{Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]]..}, myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to core function because it does not make sense to have *)
	noOutputOptions=DeleteCases[listedOptions, (Output | OutputFormat) -> _];

	(* return only the preview for UploadTransportCondition *)
	UploadTransportCondition[myObjects, myTransportConditions, Append[noOutputOptions, Output -> Preview]]

];


(* ::Subsection:: *)
(*ValidUploadTransportConditionQ*)

DefineOptions[ValidUploadTransportConditionQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadTransportCondition}
];

(* Singleton Overload *)
ValidUploadTransportConditionQ[myObject:ObjectP[{Object[Sample], Model[Sample]}], myTransportCondition:Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	ValidUploadTransportConditionQ[{myObject}, {myTransportCondition}, myOptions];

(* Overload with multiple objects all going to the same condition *)
ValidUploadTransportConditionQ[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportCondition:Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]], myOptions:OptionsPattern[]]:=
	ValidUploadTransportConditionQ[myObjects, Repeat[myTransportCondition, Length[myObjects]], myOptions];

(* Main Function *)
ValidUploadTransportConditionQ[myObjects:{ObjectP[{Object[Sample], Model[Sample]}]..}, myTransportConditions:{Alternatives[Chilled, Ambient, RangeP[27 Celsius, 105 Celsius]]..}, myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, uploadTransportConditionTests, initialTestDescription, allTests,
		verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output, Verbose option before passing to the core function because it doens't make sense here *)
	preparedOptions=DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for DiscardSamples *)
	uploadTransportConditionTests=UploadTransportCondition[myObjects, myTransportConditions, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[uploadTransportConditionTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[myObjects, OutputFormat -> Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1, InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{myObjects, validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, uploadTransportConditionTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidDiscardSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadTransportConditionQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadTransportConditionQ"]

];
