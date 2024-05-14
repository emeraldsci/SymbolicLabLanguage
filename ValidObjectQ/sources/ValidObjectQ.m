(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ValidObjectQ*)


(* ::Subsubsection::Closed:: *)
(*registerValidQTestFunction*)


validQTestFunctions=Association[];
registerValidQTestFunction::DownValues="Failed to define ValidObjectQ test functions for `1`: function `2` has no DownValues.";

registerValidQTestFunction[type:TypeP[],testFunction_Symbol]:=Module[
	{},

	(* verify that the provided test function is defined (has DownValues) *)
	If[MatchQ[DownValues[testFunction],{}],
		Message[registerValidQTestFunction::DownValues,type,testFunction];
		Return[$Failed]
	];

	(* add the function to the global association that stores the type->test function mapping *)
	AppendTo[
		validQTestFunctions,
		type -> testFunction
	];

	(* ensure that this mapping is preserved if the package is reloaded *)
	OnLoad[
		AppendTo[
			validQTestFunctions,
			type -> testFunction
		];
	];

	testFunction
];


(* ::Subsubsection::Closed:: *)
(*ValidObjectQ*)


DefineOptions[ValidObjectQ,
	Options :> {
		{Messages -> False, BooleanP, "Indicates if a message should be printed when objects are invalid."}
	},
	SharedOptions :> {
		RunValidQTest
	}
];

ValidObjectQ::BadObjects="The following objects are not passing ValidObjectQ: `1`. Run ValidObjectQ with Verbose->Failures for more information on failures.";

(* Type overload *)
ValidObjectQ[type:TypeP[],ops:OptionsPattern[]]:=ValidObjectQ[selectObjectsToTest[type],ops];

(* Overload to validate objects that changed during the supplied time period *)
ValidObjectQ[type:TypeP[], startDate:_DateObject, endDate:_DateObject, ops:OptionsPattern[]]:=ValidObjectQ[selectObjectsToTest[type,startDate,endDate],ops];

ValidObjectQ[object:ObjectP[],ops:OptionsPattern[]]:=With[
	{
		return = ValidObjectQ[
			{object},
			ops
		]
	},
	If[Length[return]!=0,
		FirstOrDefault[
			return,
			$Failed
		],
		return
	]
];

ValidObjectQ[{},ops:OptionsPattern[]]:={};

ValidObjectQ[objects:{ObjectP[]..},ops:OptionsPattern[]]:=Module[
	{safeOps,allPackets,objectPToPacketAssoc,testResult},

	safeOps=SafeOptions[ValidObjectQ, ToList[ops]];

	(* some of these may be $Failed if the object is not a database member *)
	allPackets=Download[objects];

	(* create an association of objects to packets *)
	objectPToPacketAssoc = AssociationThread[
		objects,
		allPackets
	];

	testResult=RunValidQTest[
		objects,
		{
			Function[
				object,
				testsForObject[object,objectPToPacketAssoc]
			]
		},
		PassOptions[ValidObjectQ,RunValidQTest,safeOps]
	];

	(* return the best possible message given the result format *)
	If[Messages/.safeOps,
		Module[{badObjects},

			(* parse out the failing objects from the test return *)
			badObjects=Switch[testResult,
				True,
					{},
				False,
					{objects},
				{BooleanP..},
					PickList[objects,testResult,False],
				_Association,
					Keys[Select[testResult,MatchQ[#,False]&]],
				{__EmeraldTestSummary},
					PickList[objects,#[Passed]&/@testResult,False]
			];

			(* throw the message if there were any failed objects *)
			If[MatchQ[badObjects,{ObjectP[]..}],
				Message[ValidObjectQ::BadObjects,badObjects]
			]
		]
	];

	testResult
];

(* scrape definition *)
ValidObjectQ[input_,ops:OptionsPattern[]]:=With[
	{
		objects = Cases[{input},ObjectP[],Infinity]
	},
	ValidObjectQ[objects,ops]
];

testsForObject[object:ObjectP[],objectPToPacketAssoc_Association]:=With[
	{packetForObject = objectPToPacketAssoc[object]},
	testsForPacket[packetForObject]
];

(* overload to handle case where object is not in DB *)
(* cheating here, this test always fails from this overload since we already know the object doesn't exist *)
testsForPacket[$Failed]:={
	Test["Object exists in the database:",
		False,
		True,
		Category->"General",
		FatalFailure->True
	]
};

testsForPacket[myPacket:PacketP[]]:=Module[
	{formatTest,indexMatchingTests,packetType,typesAtAllDepth,testLookupFunctions},

	formatTest=Test["Object passes ValidPacketFormatQ:",
		ValidPacketFormatQ[myPacket,OutputFormat->TestSummary],
		_EmeraldTestSummary?(TrueQ[#[Passed]]&),
		Category->"General",
		FatalFailure->False,
		TimeConstraint->1000
	];

	indexMatchingTests = Module[
		{indexMatchedDefinitions,protocolStatus,indexMatchedDefinitionsWithExclusions,indexMatchedFields,indexingFields,indexMatchedFieldValues,
		indexingFieldValues,indexMatchedFieldsWithExclusions, sortedIndexMatchedFields, sortedIndexingFields},

		(* Pull out any field definitions that index match *)
		indexMatchedDefinitions=Select[Fields /. LookupTypeDefinition[Lookup[myPacket,Type]], MemberQ[Last[#], IndexMatching -> _] &];

		protocolStatus=Lookup[myPacket,Status];

		(* If there are no index matching fields, do not run any tests *)
		If[MatchQ[indexMatchedDefinitions,{}],
			Return[{},Module]
		];

		(* If the protocol has been aborted/processing, do not run any tests *)
		If[MatchQ[protocolStatus,Alternatives[Aborted,Processing]],
			Return[{},Module]
		];

		(* Exclude from the index matching check any fields that should not be expected to index match based on the particular state of the object *)
		indexMatchedDefinitionsWithExclusions = DeleteCases[
			indexMatchedDefinitions,
			Rule[
				Alternatives@@Flatten@{
					(* If testing a centrifuge protocol that has not yet been compiled, exclude ContainerWeights from index matching *)
					If[MatchQ[Lookup[myPacket, {Type, CentrifugePrograms}, Null], {Object[Protocol, Centrifuge], {}}],
						ContainerWeights,
						Nothing
					],
					(* If testing an incomplete VacEvap, FullyEvaporated need not be index-matched *)
					If[MatchQ[Lookup[myPacket, {Type, Status}, Null], {Object[Protocol, VacuumEvaporation], Except[Completed]}],
						FullyEvaporated,
						Nothing
					],
					(* If testing an incomplete VacEvap, PreparatoryVolumes/PreparatoryContainers need not be index-matched since Prep Samples doesn't exist *)
					If[MatchQ[Lookup[myPacket, {Type, PreparatorySamples}, Null], {Object[Protocol, StockSolution], {}}],
						{PreparatoryVolumes,PreparatoryContainers},
						Nothing
					]
					(* --- Other conditional exclusions can be added here in the same form as above --- *)
				},
				_
			]
		];

		(* Pull out the names of fields that have an IndexMatching rule *)
		indexMatchedFields=indexMatchedDefinitionsWithExclusions[[All, 1]];

		(* Pull out the fields that are pointed to by a IndexMatching rule *)
		indexingFields=IndexMatching /.indexMatchedDefinitionsWithExclusions[[All, 2]];

		(* Gather all {indexMatching, indexing} field pairs by indexing field so tests will appear in blocks based on indexing field *)
		(* Sort both indexing field groups and their index-matching fields alphabetically for more readable test ordering *)
		{sortedIndexMatchedFields, sortedIndexingFields} = Transpose[
			Flatten[
				(* Sort indexing field groups alphabetically *)
				SortBy[
					(* Within each indexing field group, sort alphabetically *)
					Map[SortBy[#, Last]&, GatherBy[Transpose[{indexMatchedFields, indexingFields}], Last]],
					#[[1,2]]&
				],
				1
			]
		];

		(* Find the values of the fields that have an IndexMatching rule *)
		indexMatchedFieldValues=Lookup[myPacket, sortedIndexMatchedFields];

		(* Find the values of the fields that are pointed to by a IndexMatching rule *)
		indexingFieldValues=Lookup[myPacket, sortedIndexingFields];

		(* Create a Test to check that each field and its corresponding index matching field are the same length. *)
		(* If either of the fields in any given pair is empty, return a passing test. *)
		MapThread[
			Function[
				{indMatchedFieldValue, indFieldValue, indMatchedFieldName, indFieldName},
				Test[
					StringJoin["If index-matched fields ", ToString[indFieldName], " and ", ToString[indMatchedFieldName], " are both populated, they have the same length:"],
					If[Or[Length[indMatchedFieldValue]==0, Length[indFieldValue]==0],
						True,
						SameLengthQ[indMatchedFieldValue, indFieldValue]
					],
					True
				]
			],
			{indexMatchedFieldValues,indexingFieldValues, sortedIndexMatchedFields, sortedIndexingFields}
		]
	];

	packetType = myPacket[Type];

	typesAtAllDepth = returnAllSubTypesForType[packetType];

	testLookupFunctions = Map[
		Function[
			type,
			Lookup[validQTestFunctions,type]
		],
		typesAtAllDepth
	];

	Join[
		{formatTest},
		indexMatchingTests,
		Flatten[
			Map[
				Function[
					testFunction,
					testFunction[myPacket]
				],
				testLookupFunctions
			]
		]
	]
];

returnAllSubTypesForType[type:TypeP[]]:=returnAllSubTypesForType[{},type];
returnAllSubTypesForType[types:{TypeP[]...},type:TypeP[]]:=If[Length[type]>1,
	returnAllSubTypesForType[Prepend[types,type],Most[type]],
	Prepend[types,type]
];


(* ::Subsection:: *)
(*Test Functions*)


(* ::Subsubsection::Closed:: *)
(*NotNullFieldTest*)


NotNullFieldTest[myPacket:PacketP[],myField:_Symbol,myOptions:OptionsPattern[]]:=NotNullFieldTest[myPacket,{myField},myOptions];
NotNullFieldTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:= Module[{fieldValues},

	fieldValues=Lookup[myPacket,myFields];

	MapThread[
		Test[
			ToString[#1]<>" is informed:",
			#2,
			Except[NullP|{}|#1],

			Message->Lookup[ToList[myOptions],Message,Null],

			(* If we're throwing messages, append the field that to the beginning of the message argument. *)
			MessageArguments->If[MatchQ[Lookup[ToList[myOptions],Message,Null],Hold[Error::RequiredOptions]],
				Prepend[Lookup[ToList[myOptions],MessageArguments,{}],#1],
				Lookup[ToList[myOptions],MessageArguments,{}]
			]
		]&,
		{myFields,fieldValues}
	]
];


(* ::Subsubsection::Closed:: *)
(*NullFieldTest*)


NullFieldTest[myPacket:PacketP[],myField:_Symbol,myOptions:OptionsPattern[]]:=NullFieldTest[myPacket,{myField}];

NullFieldTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:= Module[{fieldValues},

	fieldValues=Lookup[myPacket,myFields];

	MapThread[
		Test[
			ToString[#1]<>" is Null or {}:",
			MatchQ[#2, Null|{}],
			True,

			Message->Lookup[ToList[myOptions],Message,Null],
			MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
		]&,
		{myFields,fieldValues}
	]

];



(* ::Subsubsection::Closed:: *)
(*RequiredTogetherTest*)


RequiredTogetherTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:=
	Test[
		"Fields required together ("<>StringTrim[ToString[myFields],"{"|"}"]<>") are either all informed or all Null or {}:",
		Equal@@Map[
			MatchQ[#,Null|{}]&,
			Lookup[myPacket,myFields]
		],
		True,

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	];


(* ::Subsubsection::Closed:: *)
(*FieldSyncTest*)


FieldSyncTest[myPackets:{(PacketP[]|Null)...},myField:_Symbol,myOptions:OptionsPattern[]]:= Module[
	{
		fieldValues, fieldValuesNoLinks
	},

	fieldValues = Lookup[myPackets, myField, {}];

	fieldValuesNoLinks = Map[
		If[MatchQ[#, LinkP[]|{LinkP[]...}],
			Download[#, Object],
			#
		]&,
		fieldValues
	];

	Test[
		ToString[myField]<>" is synced between objects ("<>ToString[Lookup[myPackets, Object]]<>"):",
		If[MatchQ[fieldValuesNoLinks, {EmeraldCloudFileP..}],
			sameCloudFileQ@@fieldValuesNoLinks,
			SameQ@@fieldValuesNoLinks
		],
		True,

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]
];

(* given a sequence of cloud files, return True if they're the same: if all parameters besides their ID match *)
sameCloudFileQ[cloudFiles:EmeraldCloudFileP...]:=
	SameQ@@Map[Part[#,1]& (* provider *), List[cloudFiles]] &&
	SameQ@@Map[Part[#,2]& (* bucket *), List[cloudFiles]] &&
	SameQ@@Map[Part[#,3]& (* key *), List[cloudFiles]];


(* ::Subsubsection::Closed:: *)
(*ObjectTypeTest*)


ObjectTypeTest[myPacket:PacketP[],myField:_Symbol,myOptions:OptionsPattern[]]:=Module[
	{
		myPacketType, itemsInField,typesOnly,allTypesSame,fieldExists, sameSubtypeResults, allSubtypesSame
	},

	myPacketType=myPacket[Type];

	(*Determine if the myField exists*)
	fieldExists=MatchQ[
		myField,
		FieldP[Lookup[myPacket,Type],Output->Short]
	];

	(* Pull a list of SLL Objects from the given myField in the given object, if the myField doesn't exist return an empty list *)
	itemsInField=If[
		fieldExists,
    Cases[
			Flatten[Lookup[myPacket,myField]],
			ObjectP[]
		],
		{}
	];

	(* Download the object types *)
	typesOnly=DeleteDuplicates[Download[itemsInField,Type]];

	(* check to make sure all the types are the same subtype *)
	sameSubtypeQ[typeOne_, typeTwo_] :=	SameQ[{Sequence@@typeOne},{Sequence@@typeTwo}];
	sameSubtypeResults = Map[
		sameSubtypeQ[#, myPacketType]&,
		typesOnly
	];
	allSubtypesSame = AllTrue[sameSubtypeResults, TrueQ];

	(* Ouput the test *)
	Test[
		"The field "<>ToString[myField]<>" exists in the object, and objects stored in the field are of the same family as the parent object:",
		And[
			fieldExists,
			allSubtypesSame
		],
		True,

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]

];


(* ::Subsubsection::Closed:: *)
(*FieldComparisonTest*)


FieldComparisonTest[myPacket : PacketP[], myFields : {Repeated[_Symbol, {2, Infinity}]}, myComparisonHead : (Greater | Less | GreaterEqual | LessEqual), myOptions : OptionsPattern[]] := Module[
	{
		objType, invalidFields, multipleFields, lengths, englishTranslationRules, testDescription, fieldContents, comparison
	},

	objType = Lookup[myPacket, Type];

	(* Figure out whether any of the provided fields are invalid for the provided Type *)
	invalidFields = Select[myFields, !MatchQ[#, FieldP[objType, Output -> Short]]&];

	(* In the case where invalid fields were provided, return a test that makes clear what went wrong. *)
	If[invalidFields =!= {},
		Return[
			Test[
				"One or more of the provided fields do not exist in the provided Object",
				"Unevaluated comparison",
				"Valid fields"
			]
		]
	];

	(* Determine which fields are multiple fields *)
	multipleFields = MultipleFieldQ[objType[#]]& /@ myFields;

	(* In the case where a mix of singleton and multiple fields were provided, return a test that makes clear what went wrong. *)
	If[!MatchQ[multipleFields, Alternatives[{True..}, {False..}]],
		Return[
			Test[
				"Unable to compare values between singleton and multiple fields",
				"Unevaluated comparison",
				"Valid fields"
			]
		]
	];

	(* Set up some rules to translate the comparator function into english for display *)
	If[multipleFields[[1]],
		(*For index-matched multiple field comparisons:*)
		lengths = Length[Lookup[myPacket, #]]& /@ myFields;

		If[!MatchQ[lengths, {lengths[[1]]..}],
			Return[
				Test[
					"Unable to compare values between multiple fields that have different number of elements (i.e. not index-matched)",
					"Unevaluated comparison",
					"Valid fields"
				]
			]
		];
		englishTranslationRules = {Greater -> " is greater than the corresponding element of ", Less -> " is less than the corresponding element of ", GreaterEqual -> " is greater than or equal to the corresponding element of ", LessEqual -> " is less than or equal to the corresponding element of "};
		testDescription = "Each " <> StringJoin@@Riffle[ToString/@myFields,myComparisonHead/.englishTranslationRules],

		(*Otherwise, for singleton field comparisons:*)
		englishTranslationRules = {Greater -> " is greater than ", Less -> " is less than ", GreaterEqual -> " is greater than or equal to ", LessEqual -> " is less than or equal to "};
		testDescription = StringJoin@@Riffle[ToString/@myFields,myComparisonHead/.englishTranslationRules]
	];

	(* Pull the contents of all the provided fields *)
	fieldContents = ToList[Lookup[myPacket, #]]& /@ myFields;

	(* Perform the comparison *)
	comparison=MapThread[myComparisonHead,fieldContents];

	(* In the case where none of the myField values are Null and the comparison did not evaluate to a Boolean, return a test that makes clear what went wrong. *)
	If[!MatchQ[Select[comparison, MemberQ[#, Null, 2] &], Select[comparison, MemberQ[#, myComparisonHead, 2, Heads -> True] &]],
		Return[
			Test[
				"The contents of the specified fields cannot be compared",
				"Unevaluated comparison",
				"Valid comparison"
			]
		]
	];

	(* Return the test *)
	Test[
		testDescription,
		!MemberQ[comparison, False],
		True,

		Message -> Lookup[ToList[myOptions], Message, Null],
		MessageArguments -> Lookup[ToList[myOptions], MessageArguments, {}]
	]
];


(* ::Subsubsection::Closed:: *)
(*UniqueFieldTest*)


UniqueFieldTest[myPacket:PacketP[],myField:_Symbol,myOptions:OptionsPattern[]]:=Module[{fieldValue,objectsWithSameFieldField,isUnique},

	(* Find the value of the field being tested. *)
	fieldValue=Lookup[myPacket,myField];

	(* If the field value is null, return the test here. *)
	If[MatchQ[fieldValue,Null|{}],
		Return[
			Test[
				"The "<>ToString[myField]<>" field's value, "<>ToString[fieldValue]<>", is unique or null or {}:",
				MatchQ[fieldValue,Null|{}],
				True
			]]
	];

	(* Search for other objects of the same type with the same field value. *)
	objectsWithSameFieldField=With[
		{type=Lookup[myPacket,Type]},
		Search[type,myField==fieldValue,MaxResults->2]
	];

	(* Return a Boolean indicating whether this is the only object of the specified type with the specified field value. *)
	isUnique=MatchQ[objectsWithSameFieldField,{myPacket[Object]}];

	(* Return the test. *)
	Test[
		"The "<>ToString[myField]<>" field's value, "<>ToString[fieldValue]<>", is unique or null or {}:",
		isUnique,
		True,

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]
];


(* ::Subsubsection::Closed:: *)
(*AnyInformedTest*)


AnyInformedTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:=Module[
	{
		fieldValues
	},

	fieldValues=Lookup[myPacket,myFields];
	Test[
		"At least one of the fields ("<>StringTrim[ToString[myFields],"{"|"}"]<>") is informed:",
		Or@@(!MatchQ[#, NullP|{}]&/@fieldValues),
		True,

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]

];


(* ::Subsubsection::Closed:: *)
(*UniquelyInformedTest*)


UniquelyInformedTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:=Module[
	{
		fieldValues
	},

	fieldValues=Lookup[myPacket,myFields];
	Test[
		"Only one of the fields ("<>StringTrim[ToString[myFields],"{"|"}"]<>") is informed:",
		If[
			Count[
				!MatchQ[#, Null|{}]&/@fieldValues,
				True
			] == 1,
			True
		],
		True,

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]

];

(* ::Subsubsection::Closed:: *)
(* URLFieldTest *)

URLFieldAccessibleTest[myPacket : PacketP[], myURLFields : {Repeated[_Symbol, {1, Infinity}]}, myOptions : OptionsPattern[]] := Module[
	{urls, statusCodeList, statusCodeListNullsRemoved, statusCodeHundredsDigitList},

	(*Test if google.com is accessible*)
	If[MatchQ[URLRead["https://www.google.com"]["StatusCode"], 200],

		(*If it was, get the urls from the fields*)
		urls = Lookup[myPacket, myURLFields];

		(*Get the HTTPS Status Codes for the urls*)
		statusCodeList = URLRead[#]["StatusCode"] & /@ urls;

		(* Spoof 200 Status Codes for any field that was Null *)
		statusCodeListNullsRemoved = statusCodeList /. URLRead[Null]["StatusCode"] -> 200;

		(* Take the leading digit of the Status Codes *)
		statusCodeHundredsDigitList = IntegerDigits[#][[1]] & /@ statusCodeListNullsRemoved;

				Which[
					(* If the URLs all return 200 Status Codes.. *)
					MatchQ[statusCodeHundredsDigitList, {2 ..}],
					(* then they were accessible,return a passing test *)
					Test["The URL(s) in Field(s) " <> StringTake[ToString[myURLFields], {2, -2}] <> " were accessible:", True, True],

					(* If some URLs return server error Status Codes (500,503) *)
					MatchQ[statusCodeHundredsDigitList, {Alternatives[1, 2, 5] ..}],
					(* then return a passing test (indicating the presence of server errors) *)
					Test["The URL(s) in Field(s) " <> StringTake[ToString[myURLFields], {2, -2}] <> " were accessible (or there was a problem with the requested server):", True, True],

					(* Otherwise,some URLs were redirects (301, 302) or were not found (404) or gone (410).. *)
					True,
					(* then return a failing test directing the user to the bad URLs *)
					Test["The URL(s) in Field(s) " <> StringTake[ToString[PickList[myURLFields, statusCodeHundredsDigitList, Alternatives[3, 4]]], {2, -2}] <> " were inaccessible or redirects and need to be updated:", False, True]
				],

				(* If google.com is inaccessible, return a passing test noting that internet access could not be established *)
				Test["Internet Connection Could Not Be Established, the URL Fields, " <> StringTake[ToString[myURLFields], {2, -2}] <> ", pass by proxy:"]
			]
		];

(*Singleton Overload*)
URLFieldAccessibleTest[myPacket : PacketP[], myURLField : _Symbol, myOptions : OptionsPattern[]] := URLFieldAccessibleTest[myPacket, {myURLField}, myOptions];

(* ::Subsubsection::Closed:: *)
(*RequiredWhenCompleted*)

(* Singleton case *)
RequiredWhenCompleted[myPacket:PacketP[{Object[Protocol],Object[Qualification],Object[Maintenance],Object[Simulation],Object[Program]}], myField:_Symbol, myOptions:OptionsPattern[]]:=RequiredWhenCompleted[myPacket,{myField}];

RequiredWhenCompleted[myPacket:PacketP[{Object[Protocol],Object[Qualification],Object[Maintenance],Object[Simulation],Object[Program]}], myFields:{_Symbol..}, myOptions:OptionsPattern[]] := Module[{status,fieldValues},

	(* Pull out the status of the object or (if it's a program) of its parent. *)
	status=If[MatchQ[myPacket,PacketP[{Object[Protocol],Object[Qualification],Object[Maintenance],Object[Simulation]}]],
		Lookup[myPacket,Status],
		Download[myPacket,Protocol[Status]]
	];

	(* Pull out the status and the field values*)
	fieldValues=Lookup[myPacket,#]&/@myFields;

	(* Return the test. *)
	Test[
		"If Status is Completed, the field(s) "<>StringTrim[ToString[myFields],"{"|"}"]<>", should be informed:",
		{status,fieldValues},
		Alternatives[
			{Except[Completed],Table[_, Length[myFields]]},
			{Completed,Table[Except[NullP|{}], Length[myFields]]}
		],

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]
];


(* ::Subsubsection::Closed:: *)
(*ResolvedWhenCompleted*)


RequiredWhenCompleted[myPacket:PacketP[{Object[Protocol],Object[Qualification],Object[Maintenance],Object[Simulation],Object[Program]}], myField:_Symbol,myOptions:OptionsPattern[]]:=RequiredWhenCompleted[myPacket,{myField}];

ResolvedWhenCompleted[myPacket:PacketP[{Object[Protocol],Object[Qualification],Object[Maintenance],Object[Simulation],Object[Program]}], myFields:{_Symbol..}, myOptions:OptionsPattern[]] := Module[
	{
		status,fieldValues
	},

(* Pull out the status of the object or (if it's a program) of its parent. *)
	status=If[MatchQ[myPacket,PacketP[{Object[Protocol],Object[Qualification],Object[Maintenance],Object[Simulation]}]],
		Lookup[myPacket,Status],
		Download[myPacket,Protocol[Status]]
	];

	fieldValues=Lookup[myPacket,#]&/@{Status, myFields};

	Test[
		"If Status is Completed, the field(s): "<>StringTrim[ToString[myFields],"{"|"}"]<>", should be resolved to sample, instrument, container or part:",
		fieldValues,
		Alternatives[
			{
				Except[Completed],
				Table[_, Length[myFields]]
			},
			{
				Completed,
				{Alternatives[
					ObjectP[Object],
					{ObjectP[Object]..}
				]..}
			}
		],

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]
];


(* ::Subsubsection::Closed:: *)
(*RequiredAfterCheckpoint*)


RequiredAfterCheckpoint[myPacket:PacketP[], checkpoint_String, myField:_Symbol, myOptions:OptionsPattern[]] := RequiredAfterCheckpoint[myPacket, checkpoint, {myField}];
RequiredAfterCheckpoint[myPacket:PacketP[], checkpoint_String, myFields:{_Symbol..}, myOptions:OptionsPattern[]] := Module[
	{progress,checkpointsCompleted,description, fieldsValues},

	(* Look up the values of the provided fields *)
	fieldsValues = Lookup[myPacket, myFields];

	(* Look up a list of checkpoints that have started and/or completed so far*)
	progress = Lookup[myPacket, CheckpointProgress];

	(* Extract only checkpoints which have a completion time *)
	checkpointsCompleted = extractCompletedCheckpoints[progress];

	(* Assemble test description *)
	description=StringJoin[
		"If procedure contains a CheckpointEnd labeled:  ",
		StringTrim[checkpoint,"{"|"}"],
		", the field(s) ",
		StringTrim[ToString[myFields],"{"|"}"],
		", should be informed:"
	];

	Test[description,
		{MemberQ[checkpointsCompleted, checkpoint], fieldsValues},
		Alternatives[
			(* If the checkpoint hasn't been completed, test passes on any value *)
			{False, Table[_, Length[myFields]]},
			(* If the checkpoint has been completed, all input fields must not be Null or {} *)
			{True, Table[Except[NullP|{}], Length[myFields]]}
		],

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]
];


(* Helper shared with ResolvedAfterCompleted to extract checkpoints that have been completed *)
extractCompletedCheckpoints[Null] := {};
extractCompletedCheckpoints[checkpointProgress_List] := Select[
		checkpointProgress,
		(* Completed checkpoints will have the third index populated with an end date *)
		MatchQ[#[[3]],_?DateObjectQ]&
	][[All,1]];


(* ::Subsubsection::Closed:: *)
(*ResolvedAfterCheckpoint*)


ResolvedAfterCheckpoint[myPacket:PacketP[], checkpoint_String, myField:_Symbol, myOptions:OptionsPattern[]] := ResolvedAfterCheckpoint[myPacket, checkpoint, {myField}];
ResolvedAfterCheckpoint[myPacket:PacketP[], checkpoint_String, myFields:{_Symbol..}, myOptions:OptionsPattern[]] := Module[
	{progress,checkpointsCompleted,description,fieldsValues},

	(* Look up the values of the provided fields *)
	fieldsValues= Lookup[myPacket, myFields];

	(* Look up a list of checkpoints that have started and/or completed so far*)
	progress = Lookup[myPacket, CheckpointProgress];

	(* Extract only checkpoints which have a completion time *)
	checkpointsCompleted = extractCompletedCheckpoints[progress];

	(* Assemble test description *)
	description=StringJoin[
		"If procedure contains a CheckpointEnd labeled:  ",
		StringTrim[checkpoint,"{"|"}"],
		", the field(s) ",
		StringTrim[ToString[myFields],"{"|"}"],
		", should be resolved to a sample, instrument, container or part:"
	];

	Test[description,
		{MemberQ[checkpointsCompleted, checkpoint], Flatten[fieldsValues]},
		Alternatives[
			(* If the checkpoint hasn't been completed, test passes on any value *)
			{False, _},
			(* If the checkpoint has been completed, all input fields must be populated with Object(s) *)
			{True, {ObjectP[{Object[Sample], Object[Instrument], Object[Container], Object[Part], Object[Item]}]..}}
		],

		Message->Lookup[ToList[myOptions],Message,Null],
		MessageArguments->Lookup[ToList[myOptions],MessageArguments,{}]
	]
];


(* ::Subsubsection::Closed:: *)
(*selectObjectsToTest*)

(* Select all objects of the supplied type up to the max *)
selectObjectsToTest[type:TypeP[]]:=Module[
	{searchConditions,logicSearchConditions,maxResults},

	searchConditions = searchConditionsForType[type];

	logicSearchConditions = Apply[
		And,
		searchConditions
	];

	maxResults = maxResultsForType[type];

	With[
		{
			searchConds = logicSearchConditions,
			maxResluts = maxResults
		},
		Search[
			type,
			searchConds,
			MaxResults->maxResluts,
			SubTypes->False
		]
	]
];

(* Overload based on objects that have changed in a specific time period *)
selectObjectsToTest[type:TypeP[], startDate:_DateObject, endDate:_DateObject]:=ObjectLogAssociation[type, StartDate->startDate, EndDate->endDate, ObjectIdsOnly->True, MaxResults->5000];

(* Analysis *)
searchConditionsForType[type:TypeP[Object[Analysis]]]:={
	DateCreated>DateObject["February 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Analysis,TotalProteinQuantification]]]:={
	DateCreated>DateObject["March 27, 2020"]
};

(* Calibration *)
searchConditionsForType[type:TypeP[Object[Calibration]]]:={
	DateCreated>DateObject["June 1, 2016"]
};

(*  *)
searchConditionsForType[type:TypeP[Object[Company]]]:={
	OutOfBusiness!=True
};

(* Container *)
searchConditionsForType[type:TypeP[Object[Container]]]:={
	Status==(Stocked|Available|InUse)
};

searchConditionsForType[
	type:TypeP[
		{
			Object[Container,Plate],
			Object[Container,Vessel]
		}
	]
]:={
	Status==(Stocked|Available|InUse),
	Or[
		DateStocked>(Now-2 Week),
		DateUnsealed>(Now-2 Week)
	]
};

maxResultsForType[
	type:TypeP[
		{
			Object[Container,Rack],
			Object[Container,Shelf]
		}
	]
]:=Infinity;

(* Qualification *)
searchConditionsForType[type:TypeP[Object[Qualification,Autoclave]]]:={
	DateConfirmed>DateObject["January 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Qualification,LiquidLevelDetection]]]:={
	DateConfirmed>DateObject["September 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Qualification,PipettingLinearity]]]:={
	DateConfirmed>DateObject["October 1, 2016"]
};

(* Data *)
searchConditionsForType[type:TypeP[Object[Data,MeltingCurve]]]:={
	DateCreated>DateObject["November 16, 2020"]
};

searchConditionsForType[type:TypeP[Object[Data,FluorescenceKinetics]]]:={
	DateCreated>DateObject["March 15, 2019"]
};

searchConditionsForType[type:TypeP[Object[Data,FluorescenceIntensity]]]:={
	DateCreated>DateObject["March 15, 2019"]
};

searchConditionsForType[type:TypeP[Object[Data,DynamicLightScattering]]]:={
	DateCreated>DateObject["October 1, 2020"]
};

searchConditionsForType[type:TypeP[Object[Data, qPCR]]]:={
	DateCreated>DateObject["January 20, 2020"]
};

searchConditionsForType[type:TypeP[Object[Data]]]:={
	DateCreated>DateObject["January 1, 2016"]
};

maxResultsForType[type:TypeP[Model[DeckLayout]]]:=Infinity;
searchConditionsForType[TypeP[Model[DeckLayout]]]:={
	Deprecated!=True
};

(* Instrument *)
searchConditionsForType[type:TypeP[Object[Instrument]]]:={
	Status==(Available|Running|UndergoingMaintenance)
};

maxResultsForType[type:TypeP[Object[Instrument]]]:=Infinity;

(* Inventory *)
searchConditionsForType[type:TypeP[Object[Inventory]]]:={
	Status == Active
};

maxResultsForType[type:TypeP[Object[Inventory]]]:=Infinity;

(* Maintenance *)

searchConditionsForType[type:TypeP[Object[Maintenance,CalibrateDNASynthesizer]]]:={
	DateConfirmed>DateObject["December 12, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,CalibrateVolume]]]:={
	DateConfirmed>DateObject["March 15, 2017"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,CalibratePathLength]]]:={
	DateConfirmed>DateObject["March 15, 2017"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,Clean]]]:={
	DateConfirmed>DateObject["June 14, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,Handwash]]]:={
	DateConfirmed>DateObject["November 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,Decontaminate]]]:={
	DateConfirmed>DateObject["July 8, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,Decontaminate, LiquidHandler]]]:={
	DateConfirmed>DateObject["July 8, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,Dishwash]]]:={
	DateConfirmed>DateObject["June 29, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,EmptyWaste]]]:={
	DateConfirmed>DateObject["August 26, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,InstallGasCylinder]]]:={
	DateConfirmed>DateObject["December 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,RefillReservoir]]]:={
	DateConfirmed>DateObject["July 19, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance,StorageUpdate]]]:={
	DateConfirmed>DateObject["August 15, 2016"]
};

searchConditionsForType[type:TypeP[Object[Maintenance]]]:={
	DateConfirmed>DateObject["January 1, 2016"]
};

(* Method *)
(* all defaults *)

(* Model[Sample] *)
searchConditionsForType[type:TypeP[Model[Sample]]]:={
	Deprecated!=True
};

maxResultsForType[
	type:TypeP[
		{
			Model[Sample],
			Model[Sample,Matrix],
			Model[Sample,Media],
			Model[Sample,StockSolution]
		}
	]
]:=Infinity;

(* Model[Container] *)
searchConditionsForType[type:TypeP[Model[Container]]]:={
	Deprecated!=True
};

maxResultsForType[
	type:TypeP[
		{
			Model[Container,Plate],
			Model[Container,Vessel]
		}
	]
]:=Infinity;

(* Model[Item] *)
searchConditionsForType[type:TypeP[Model[Item]]]:={
	Deprecated!=True
};

(* Model[Qualification] *)
searchConditionsForType[type:TypeP[Model[Qualification]]]:={
	Deprecated!=True
};

(* Model[Instrument] *)
searchConditionsForType[type:TypeP[Model[Instrument]]]:={
	Deprecated!=True
};

(* Model[Maintenance] *)
searchConditionsForType[type:TypeP[Model[Maintenance]]]:={
	Deprecated!=True
};

(* Model[Part] *)
searchConditionsForType[type:TypeP[Model[Part]]]:={
	Deprecated!=True
};

(* Model[Plumbing] *)
searchConditionsForType[type:TypeP[Model[Plumbing]]]:={
	Deprecated!=True
};

(* Model[Wiring] *)
searchConditionsForType[type:TypeP[Model[Wiring]]]:={
	Deprecated!=True
};

(* Model[Sensor] *)
searchConditionsForType[type:TypeP[Model[Sensor]]]:={
	Deprecated!=True
};

(* Part *)
searchConditionsForType[type:TypeP[Object[Part]]]:={
	Status==(Available|Stocked|InUse)
};

(* Person *)
searchConditionsForType[type:TypeP[Object[User]]]:={
	Status==Active
};

maxResultsForType[type:TypeP[Object[User]]]:=Infinity;

(* Plumbing *)
searchConditionsForType[type:TypeP[Object[Plumbing]]]:= {
	Status == (Available | Stocked | InUse)
};

maxResultsForType[type:TypeP[
	{
		Object[Plumbing,Valve],
		Object[Plumbing,AspirationCap]
	}
]]:=Infinity;

(* Wiring *)
searchConditionsForType[type:TypeP[Object[Wiring]]]:= {
	Status == (Available | Stocked | InUse)
};

maxResultsForType[type:TypeP[Object[Wiring]]]:=Infinity;

(* Product *)
searchConditionsForType[type:TypeP[Object[Product]]]:={
	Deprecated!=True
};

maxResultsForType[
	type:TypeP[
		{
			Object[Product]
		}
	]
]:=Infinity;

(* Program *)

searchConditionsForType[type:TypeP[Object[Program,Cleavage]]]:={
	DateCreated>DateObject["August 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Program,MeasureWeight]]]:={
	DateCreated>DateObject["August 12, 2016"]
};

searchConditionsForType[type:TypeP[Object[Program,Mix]]]:={
	DateCreated>DateObject["August 8, 2016"]
};

searchConditionsForType[TypeP[Object[Program,SampleManipulation]]]:={
	DateCreated>DateObject["August 20, 2017"]
};

searchConditionsForType[TypeP[Object[Program,Transfer]]]:={
	DateCreated>DateObject["August 30, 2017"]
};

searchConditionsForType[type:TypeP[Object[Program]]]:={
	DateCreated>DateObject["January 1, 2016"]
};

(* Protocol *)
searchConditionsForType[type:TypeP[Object[Protocol,UVMelting]]]:={
	DateConfirmed>DateObject["November 6, 2016"]
};

searchConditionsForType[type:TypeP[Object[Protocol,AbsorbanceSpectroscopy]]]:={
	DateConfirmed>DateObject["December 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Protocol,AbsorbanceQuantification]]]:={
	DateConfirmed>DateObject["January 1, 2020"]
};

searchConditionsForType[type:TypeP[Object[Protocol,Autoclave]]]:={
	DateConfirmed>DateObject["September 30, 2016"]
};

searchConditionsForType[type:TypeP[Object[Protocol,Centrifuge]]]:={
	DateConfirmed>DateObject["September 1, 2016"]
};

searchConditionsForType[type:TypeP[Object[Protocol,SolidPhaseExtraction]]]:={
	DateConfirmed>DateObject["December 2, 2017"]
};

searchConditionsForType[type:TypeP[Object[Protocol,DNASynthesis]]]:={
	DateConfirmed>DateObject["December 7, 2016"]
};

searchConditionsForType[type:TypeP[Object[Protocol,DynamicLightScattering]]]:={
	DateConfirmed>DateObject["October 1, 2020"]
};

searchConditionsForType[type:TypeP[Object[Protocol,Filter]]]:={
	DateConfirmed>DateObject["April 1, 2017"]
};

searchConditionsForType[type:TypeP[Object[Protocol,FluorescenceIntensity]]]:={
	DateConfirmed>DateObject["March 15, 2019"]
};

searchConditionsForType[type:TypeP[Object[Protocol,FluorescenceKinetics]]]:={
	DateConfirmed>DateObject["March 15, 2019"]
};

searchConditionsForType[type:TypeP[Object[Protocol,MeasureVolume]]]:={
	DateConfirmed>DateObject["June 27, 2017"],
	Or[
		WeightMeasurement!=Null,
		VolumeMeasurements!=Null
	]
};

searchConditionsForType[type:TypeP[Object[Protocol,MeasureWeight]]]:={
	DateConfirmed>DateObject["August 12, 2016"]
};

searchConditionsForType[type:TypeP[Object[Protocol,PAGE]]]:={
	DateConfirmed>DateObject["August 21, 2020"]
};

searchConditionsForType[type:TypeP[Object[Protocol,PNASynthesis]]]:={
	DateConfirmed>DateObject["November 15, 2016"]
};

searchConditionsForType[type:TypeP[Object[Protocol,StockSolution]]]:={
	DateConfirmed>DateObject["July 23, 2017"]
};

searchConditionsForType[type:TypeP[Object[Protocol,IncubateOld]]]:={
	DateConfirmed>DateObject["January 15, 2017"]
};

searchConditionsForType[type:TypeP[Object[Protocol,VacuumEvaporation]]]:={
	DateConfirmed>DateObject["March 15, 2017"]
};

searchConditionsForType[type:TypeP[Object[Protocol,HPLC]]]:={
  DateConfirmed>DateObject["March 17, 2017"]
};

searchConditionsForType[type:TypeP[Object[Protocol,ThermalShift]]]:={
	DateConfirmed>DateObject["November 13, 2020"]
};

searchConditionsForType[type:TypeP[Object[Protocol,TotalProteinDetection]]]:={
	DateConfirmed>DateObject["August 10, 2019"]
};

searchConditionsForType[type:TypeP[Object[Protocol,TotalProteinQuantification]]]:={
	DateConfirmed>DateObject["March 27, 2020"]
};

searchConditionsForType[type:TypeP[Object[Protocol,Western]]]:={
	DateConfirmed>DateObject["July 24, 2019"]
};

searchConditionsForType[type:TypeP[Object[Protocol, qPCR]]]:={
	DateConfirmed>DateObject["January 20, 2020"]
};

searchConditionsForType[type:TypeP[Object[Protocol]]]:={
	DateConfirmed>DateObject["July 1, 2016"]
};

(* Report *)
searchConditionsForType[type:TypeP[Object[Report,Locations]]]:={
	DateCreated>DateObject["March 1, 2017"]
};

searchConditionsForType[type:TypeP[Object[Report]]]:={
	DateCreated>DateObject["July 1, 2016"]
};

(* Resource *)
(* all defaults *)

(* Sample *)
searchConditionsForType[type:TypeP[Object[Sample]]]:={
	Status==(Available|Stocked|InUse)
};

(* Protein *)
searchConditionsForType[type:TypeP[Object[Sample]]]:={
	Status==(Available|Stocked|InUse),
	DateUnsealed>DateObject["January 1, 2018"]
};

(* Sensor *)
searchConditionsForType[type:TypeP[Object[Sensor]]]:={
	Status==(Available|UndergoingMaintenance)
};

maxResultsForType[type:TypeP[Object[Sensor]]]:=Infinity;

(* Simulation *)
searchConditionsForType[type:TypeP[Object[Simulation]]]:={
	DateStarted>DateObject["January 1, 2016"]
};

(* Team *)
(* all defaults *)

(* Transaction *)
(* all defaults *)

(* Troubleshooting *)
(* all defaults *)


(* Defaults *)
searchConditionsForType[type:TypeP[]]:={};

maxResultsForType[type:TypeP[]]:=50;