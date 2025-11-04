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
(*additionalValidQTestOptions*)

DefineOptionSet[
	additionalValidQTestOptions :> {
		CacheOption,
		{FieldSource -> <||>, _Association, "Indicate where the field value is originated in the provided packet. This option may affect certain tests and error messages, especially when using this function to perform error-checking on packets from UploadXX functions."}
	}
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

DefineOptions[
	testsForPacket,
	Options :> {
		additionalValidQTestOptions
	}
];

(* overload to handle case where object is not in DB *)
(* cheating here, this test always fails from this overload since we already know the object doesn't exist *)
testsForPacket[$Failed, ops:OptionsPattern[]]:={
	Test["Object exists in the database:",
		False,
		True,
		Category->"General",
		FatalFailure->True
	]
};

testsForPacket::NoOptionsDefinedForTestLookupFunctions = "At least one of the following functions `1` do not have options defined, therefore default version of ValidQTests have to be used instead.";

testsForPacket[myPacket:PacketP[], ops:OptionsPattern[]]:=Module[
	{formatTest,indexMatchingTests,packetType,typesAtAllDepth,testLookupFunctions, listedOps, lookupFunctionsMissingOptionQ},

	listedOps = ToList[ops];

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

	(* If we have supplied options when running testsForPacket, we want to check that all the test lookup functions also allow options *)
	lookupFunctionsMissingOptionQ = If[Length[listedOps] > 0,
		MemberQ[Options /@ testLookupFunctions, {}],
		False
	];

	If[TrueQ[lookupFunctionsMissingOptionQ],
		Message[testsForPacket::NoOptionsDefinedForTestLookupFunctions, testLookupFunctions]
	];

	(* Find all tests defined for all subtypes *)
	Join[
		{formatTest},
		indexMatchingTests,
		Flatten[
			Map[
				Function[
					testFunction,
					(* If the test function doesn't have options defined, do NOT pass options so the function can still evaluate *)
					(* a message should have been thrown previously to inform the user that options can't be passed in *)
					If[MatchQ[Options[testFunction], {}],
						testFunction[myPacket],
						testFunction[myPacket, ops]
					]
				],
				testLookupFunctions
			]
		]
	]
];

(* This function returns all parent types and itself of any given type. For example: *)
(* Model[Container, Vessel] -> {Model[Container, Vessel], Model[Container]} *)
returnAllSubTypesForType[type:TypeP[]]:=returnAllSubTypesForType[{},type];
returnAllSubTypesForType[types:{TypeP[]...},type:TypeP[]]:=If[Length[type]>1,
	returnAllSubTypesForType[Prepend[types,type],Most[type]],
	Prepend[types,type]
];



(* ::Subsection:: *)
(*Test Functions*)

(* ::Subsubsection::Closed:: *)
(*sharedOptions*)
DefineOptionSet[
	testFunctionSharedOptionSet :> {
		{Message -> Null, (Null | Automatic | {Hold[HoldPattern[MessageName[___]]], ___}), "The message that should be thrown if this test does not succeed. The format should be {Hold[MessageName], arg1, arg2...}."},
		{FieldSource -> <||>, _Association, "Indicate where the field value is originated in the provided packet. This option may affect certain tests and error messages, especially when using this function to perform error-checking on packets from UploadXX functions."},
		{ParentFunction -> "current function", _String, "Name of the function that requested the VOQ tests."},
		{ExternalSource -> "web source", _String, "A short description of which external source we tried to find information from for options with FieldSource -> External."}
	}
];

(* ::Subsubsection::Closed:: *)
(*NotNullFieldTest*)
DefineOptions[NotNullFieldTest, Options :> {testFunctionSharedOptionSet}];

NotNullFieldTest[myPacket:PacketP[],myField:_Symbol,myOptions:OptionsPattern[]]:=NotNullFieldTest[myPacket,{myField},myOptions];
NotNullFieldTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:= Module[{fieldValues, messageComponents, fieldSource, parentFunctionName, safeOps, externalSource},

	fieldValues=Lookup[myPacket,myFields];
	safeOps = SafeOptions[NotNullFieldTest, ToList[myOptions]];
	{messageComponents, fieldSource, parentFunctionName, externalSource} = Lookup[safeOps, {Message, FieldSource, ParentFunction, ExternalSource}];

	(* This With is not required for the code itself, but it's required for the manual review function *)
	With[{message = messageComponents},
		MapThread[
			Test[
				ToString[#1]<>" is informed:",
				#2,
				Except[NullP|{}|#1],

				(* If we're throwing messages, append the field that to the beginning of the message argument. *)
				Message->Which[
					MatchQ[message, {Hold[Error::RequiredOptions], ___}],
					Join[{Hold[Error::RequiredOptions]}, {#1}, Rest[message]],

					MatchQ[message, Automatic],
					Switch[Lookup[fieldSource, #1],
						User, {Hold[Error::RequiredOptions], #1, Lookup[myPacket, Type]},
						External, {Hold[Error::UnableToFindInfo], #1, Lookup[myPacket, Type], externalSource, parentFunctionName},
						Template, {Hold[Error::UnableToFindInfo], #1, Lookup[myPacket, Type], "object specified in Template option", parentFunctionName},
						Resolved, {Hold[Error::UnableToResolveOption], #1, Lookup[myPacket, Type]},
						Field, {Hold[Error::UnableToFindInfo], #1, Lookup[myPacket, Type], "database", parentFunctionName},
						_, {Hold[Error::RequiredOptions], #1, Lookup[myPacket, Type]}
					],

					True,
					message
				]
			]&,
			{myFields,fieldValues}
		]
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

			Message->Lookup[ToList[myOptions],Message,Null]
		]&,
		{myFields,fieldValues}
	]

];



(* ::Subsubsection::Closed:: *)
(*RequiredTogetherTest*)

DefineOptions[RequiredTogetherTest, Options :> {testFunctionSharedOptionSet}];
RequiredTogetherTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:= Module[{messageComponents, fieldSource, field1, field2, safeOps, externalSource},
	safeOps = SafeOptions[RequiredTogetherTest, ToList[myOptions]];
	{messageComponents, fieldSource, externalSource} = Lookup[safeOps, {Message, FieldSource, ExternalSource}];
	field1 = First[myFields];
	field2 = Last[myFields];

	(* This With is not required for the code itself, but it's required for the manual review function *)
	With[{message = messageComponents, firstFieldNull = MatchQ[Lookup[myPacket, field1], NullP|{}]},
		Test[
			"Fields required together ("<>StringTrim[ToString[myFields],"{"|"}"]<>") are either all informed or all Null or {}:",
			Equal@@Map[
				MatchQ[#,NullP|{}]&,
				Lookup[myPacket,myFields]
			],
			True,

			Message-> Which[
				MatchQ[message, Automatic] && Length[myFields] == 2,
				Switch[Append[Lookup[fieldSource, myFields], firstFieldNull],
					{User, User, _}, {Hold[Error::RequiredTogetherOptions], Lookup[myPacket, Type], myFields},
					{User, External, True}, {Hold[Error::RequiredTogetherOptionsFromExternalSource], Lookup[myPacket, Type], field1, field2, externalSource},
					{User, External, False}, {Hold[Error::RequiredTogetherOptionsCannotFindFromExternalSource], Lookup[myPacket, Type], field1, field2, externalSource},
					{External, User, False}, {Hold[Error::RequiredTogetherOptionsFromExternalSource], Lookup[myPacket, Type], field2, field1, externalSource},
					{External, User, True}, {Hold[Error::RequiredTogetherOptionsCannotFindFromExternalSource], Lookup[myPacket, Type], field2, field1, externalSource},
					{User, Template, True}, {Hold[Error::RequiredTogetherOptionsFromExternalSource], Lookup[myPacket, Type], field1, field2, "Template option"},
					{User, Template, False}, {Hold[Error::RequiredTogetherOptionsCannotFindFromExternalSource], Lookup[myPacket, Type], field1, field2, "Template option"},
					{Template, User, False}, {Hold[Error::RequiredTogetherOptionsFromExternalSource], Lookup[myPacket, Type], field2, field1, "Template option"},
					{Template, User, True}, {Hold[Error::RequiredTogetherOptionsCannotFindFromExternalSource], Lookup[myPacket, Type], field2, field1, "Template option"},
					{User, Field, True}, {Hold[Error::RequiredTogetherOptionsFromExternalSource], Lookup[myPacket, Type], field1, field2, "database"},
					{User, Field, False}, {Hold[Error::RequiredTogetherOptionsCannotFindFromExternalSource], Lookup[myPacket, Type], field1, field2, "database"},
					{Field, User, False}, {Hold[Error::RequiredTogetherOptionsFromExternalSource], Lookup[myPacket, Type], field2, field1, "database"},
					{Field, User, True}, {Hold[Error::RequiredTogetherOptionsCannotFindFromExternalSource], Lookup[myPacket, Type], field2, field1, "database"},
					(* The following conditions may look redundant, but the point is {Resolved, Resolved, _} won't match, but {External, Resolved, _}, {Resolved, External, _} and {External, External, _} matches *)
					{(External | Resolved), External, False}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field1, field2, externalSource},
					{(External | Resolved), External, True}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field2, field1, externalSource},
					{External, (External | Resolved), False}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field1, field2, externalSource},
					{External, (External | Resolved), True}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field2, field1, externalSource},
					{(Template | Resolved), Template, False}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field1, field2, "Template option"},
					{(Template | Resolved), Template, True}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field2, field1, "Template option"},
					{Template, (Template | Resolved), False}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field1, field2, "Template option"},
					{Template, (Template | Resolved), True}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field2, field1, "Template option"},
					{(Field | Resolved), Field, False}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field1, field2, "database"},
					{(Field | Resolved), Field, True}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field2, field1, "database"},
					{Field, (Field | Resolved), False}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field1, field2, "database"},
					{Field, (Field | Resolved), True}, {Hold[Error::RequiredTogetherOptionsConflictFromExternalSource], Lookup[myPacket, Type], field2, field1, "database"},
					{_, _, _}, {Hold[Error::RequiredTogetherOptions], Lookup[myPacket, Type], myFields}
				],

				MatchQ[message, Automatic],
				{Hold[Error::RequiredTogetherOptions], Lookup[myPacket, Type], myFields},

				True,
				message
			]
		]
	]
];


(* ::Subsubsection:: *)
(*RequiredTogetherIndexMatchingTest*)


RequiredTogetherIndexMatchingTest[myPacket:PacketP[], myFields:{_Symbol..}, myOptions:OptionsPattern[]] := Test[
	"At each index, the index-matching fields required together ("<>StringTrim[ToString[myFields], "{" | "}"]<>") are either all informed or all Null or {}:",
	Equal @@ MapThread[
		Equal @@ Map[
			Function[{element},
				MatchQ[element, NullP | {}]
			],
			{##}
		]&,
		Lookup[myPacket, myFields]
	],
	True,
	Message -> Lookup[ToList[myOptions], Message, Null]
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

		Message->Lookup[ToList[myOptions],Message,Null]
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

		Message->Lookup[ToList[myOptions],Message,Null]
	]

];


(* ::Subsubsection::Closed:: *)
(*FieldComparisonTest*)

DefineOptions[FieldComparisonTest, Options :> {testFunctionSharedOptionSet}];
FieldComparisonTest[myPacket : PacketP[], myFields : {Repeated[_Symbol, {2, Infinity}]}, myComparisonHead : (Greater | Less | GreaterEqual | LessEqual), myOptions : OptionsPattern[]] := Module[
	{
		objType, invalidFields, multipleFields, lengths, englishTranslationRules, testDescription, fieldContents, comparison,
		messageComponents, fieldSource, field1, field2, reverseComparisonHead, comparisonText, reverseComparisonText, safeOps,
		externalSource
	},

	objType = Lookup[myPacket, Type];
	safeOps = SafeOptions[FieldComparisonTest, ToList[myOptions]];

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
		englishTranslationRules = {Greater -> " greater than the corresponding element of ", Less -> " less than the corresponding element of ", GreaterEqual -> " greater than or equal to the corresponding element of ", LessEqual -> " less than or equal to the corresponding element of "};
		testDescription = "Each " <> StringJoin@@Riffle[ToString/@myFields, StringJoin[" is", (myComparisonHead/.englishTranslationRules)]],

		(*Otherwise, for singleton field comparisons:*)
		englishTranslationRules = {Greater -> " greater than ", Less -> " less than ", GreaterEqual -> " greater than or equal to ", LessEqual -> " less than or equal to "};
		testDescription = StringJoin@@Riffle[ToString/@myFields, StringJoin[" is", (myComparisonHead/.englishTranslationRules)]]
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

	(* Construct custom error message in case Message -> Automatic *)
	{messageComponents, fieldSource, externalSource} = Lookup[safeOps, {Message, FieldSource, ExternalSource}];
	{field1, field2} = {First[myFields], Last[myFields]};
	reverseComparisonHead = myComparisonHead /. {Less -> Greater, LessEqual -> GreaterEqual, Greater -> Less, GreaterEqual -> LessEqual};
	comparisonText = myComparisonHead /. englishTranslationRules;
	reverseComparisonText = reverseComparisonHead /. englishTranslationRules;

	With[{message = messageComponents},
		(* Return the test *)
		Test[
			testDescription,
			!MemberQ[comparison, False],
			True,

			Message -> Which[
				MatchQ[message, Automatic] && Length[myFields] == 2,
				Switch[Lookup[fieldSource, {field1, field2}],
					{(User | Resolved), (User | Resolved)}, {Hold[Error::ConflictingOptionsMagnitude], field1, field2, comparisonText},
					{(User | Resolved), External}, {Hold[Error::ConflictingOptionsMagnitudeWithExistingField], field2, externalSource, Lookup[myPacket, field2], field1, Lookup[myPacket, field1], reverseComparisonText},
					{External, (User | Resolved)}, {Hold[Error::ConflictingOptionsMagnitudeWithExistingField], field1, externalSource, Lookup[myPacket, field1], field2, Lookup[myPacket, field2], comparisonText},
					{(User | Resolved), Template}, {Hold[Error::ConflictingOptionsMagnitudeWithExistingField], field2, "Template option", Lookup[myPacket, field2], field1, Lookup[myPacket, field1], reverseComparisonText},
					{Template, (User | Resolved)}, {Hold[Error::ConflictingOptionsMagnitudeWithExistingField], field1, "Template option", Lookup[myPacket, field1], field2, Lookup[myPacket, field2], comparisonText},
					{(User | Resolved), Field}, {Hold[Error::ConflictingOptionsMagnitudeWithExistingField], field2, "database", Lookup[myPacket, field2], field1, Lookup[myPacket, field1], reverseComparisonText},
					{Field, (User | Resolved)}, {Hold[Error::ConflictingOptionsMagnitudeWithExistingField], field1, "database", Lookup[myPacket, field1], field2, Lookup[myPacket, field2], comparisonText},
					{External, External}, {Hold[Error::ConflictingOptionsMagnitudeFromExistingField], field1, field2, comparisonText, externalSource},
					{Template, Template}, {Hold[Error::ConflictingOptionsMagnitudeFromExistingField], field1, field2, comparisonText, "Template object"},
					{Field, Field}, {Hold[Error::ConflictingOptionsMagnitudeFromExistingField], field1, field2, comparisonText, "current object"},
					_, {Hold[Error::ConflictingOptionsMagnitude], field1, field2, comparisonText}
				],

				(* If we are comparing more than 2 fields simultaneously, it's too complicated to do custom error handling and therefore only output a general error message *)
				MatchQ[message, Automatic],
				{Hold[Error::IncorrectOptionMagnitude], myFields, comparisonText},

				True,
				message
			]
		]
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

		Message->Lookup[ToList[myOptions],Message,Null]
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

		Message->Lookup[ToList[myOptions],Message,Null]
	]

];


(* ::Subsubsection::Closed:: *)
(*UniquelyInformedTest*)
DefineOptions[UniquelyInformedTest, Options :> {testFunctionSharedOptionSet}];

UniquelyInformedTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:=Module[
	{
		fieldValues, messageComponents, fieldSource, safeOps, field1, field2
	},

	fieldValues=Lookup[myPacket,myFields];
	safeOps = SafeOptions[UniquelyInformedTest, ToList[myOptions]];
	{messageComponents, fieldSource} = Lookup[safeOps, {Message, FieldSource}];
	field1 = First[myFields];
	field2 = Last[myFields];
	With[{message = messageComponents},
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

			Message -> Which[
				MatchQ[message, Automatic] && Length[myFields] == 2,
				Switch[Lookup[fieldSource, {field1, field2}],
					{(User | Resolved), (User | Resolved)}, {Hold[Error::MutuallyExclusiveOptions], field1, field2},
					{(User | Resolved), Template}, {Hold[Error::MutuallyExclusiveOptionsWithExistingField], field1, field2, "Template option"},
					{(User | Resolved), Field}, {Hold[Error::MutuallyExclusiveOptionsWithExistingField], field1, field2, "database"},
					{Template, (User | Resolved)}, {Hold[Error::MutuallyExclusiveOptionsWithExistingField], field2, field1, "Template option"},
					{Field, (User | Resolved)}, {Hold[Error::MutuallyExclusiveOptionsWithExistingField], field2, field1, "database"},
					{Template, Template}, {Hold[Error::MutuallyExclusiveOptionsBetweenExistingField], field1, field2, "Template option", If[NullQ[Lookup[myPacket, field1]], "Null", "not Null"]},
					{Field, Field}, {Hold[Error::MutuallyExclusiveOptionsBetweenExistingField], field1, field2, "database", If[NullQ[Lookup[myPacket, field1]], "Null", "not Null"]},
					{_, _}, {Hold[Error::MutuallyExclusiveOptions], field1, field2}
				],

				MatchQ[message, Automatic],
				{Hold[Error::MultipleMutuallyExclusiveOptions], myFields},

				True,
				message
			]
		]
	]
];

(* Overload for a parent field symbol matching criteria *)
UniquelyInformedTest[myPacket:PacketP[], myFields:{_Symbol..}, myParentField_Symbol, myParentFieldPattern_Alternatives, myOptions:OptionsPattern[]]:=Module[
	{
		parentFieldValues, fieldValues, parentFieldPositions, fieldValuesAtPositions, comparisonBools, messageComponents, fieldSource, safeOps
	},

	safeOps = SafeOptions[UniquelyInformedTest, ToList[myOptions]];
	{messageComponents, fieldSource} = Lookup[safeOps, {Message, FieldSource}];
	(* Lookup the values for the fields of interest *)
	parentFieldValues = Lookup[myPacket, myParentField];
	fieldValues=Lookup[myPacket, myFields];

	(* Filter*)
	parentFieldPositions = Position[parentFieldValues, myParentFieldPattern];
	fieldValuesAtPositions = Extract[#, parentFieldPositions]& /@ fieldValues;
	Test[
		"At indices where " <> ToString[myParentField] <> " is (" <>StringTrim[ToString[List @@ myParentFieldPattern],"{"|"}"]<>"), only one of the fields ("<>StringTrim[ToString[myFields],"{"|"}"]<>") is informed:",
		Which[
			(* In the trivial case where there is something to compare return True *)
			MatchQ[fieldValuesAtPositions, {{}, {}..}],
			True,
			(* Otherwise.. *)
			True,
			(* Check which indices are informed *)
			comparisonBools = Map[!MatchQ[#, Null|{}]&, Transpose[fieldValuesAtPositions], {2}];
			(* Check that each index has only one informed field *)
			MatchQ[(Count[#, True]& /@ comparisonBools), {1..., 1}]
		],
		True,

		Message->Replace[messageComponents, Automatic -> Null]
	]
];

(* ::Subsubsection::Closed:: *)
(*UniquelyInformedIndexTest*)


UniquelyInformedIndexTest[myPacket:PacketP[],myFields:{_Symbol..},myOptions:OptionsPattern[]]:=Module[
	{
		fieldValues, comparisonBools
	},

	fieldValues=Lookup[myPacket,myFields];
	Test[
		"At each index, only one of the index-matched multiple fields ("<>StringTrim[ToString[myFields],"{"|"}"]<>") is informed:",
		Which[
			(* If the fields are not index-matched, return false prior to transposing field values of different length *)
			!SameLengthQ @@ fieldValues, False,
			(* Otherwise, *)
			True,
			(* Check which indices are informed *)
			comparisonBools= Map[!MatchQ[#, Null|{}]&, Transpose[fieldValues], {2}];
			(* Check that each index has only one informed field *)
			MatchQ[(Count[#, True]& /@ comparisonBools), {1..., 1}]
		],
		True,

		Message->Lookup[ToList[myOptions],Message,Null]
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

		Message->Lookup[ToList[myOptions],Message,Null]
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

		Message->Lookup[ToList[myOptions],Message,Null]
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

		Message->Lookup[ToList[myOptions],Message,Null]
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

		Message->Lookup[ToList[myOptions],Message,Null]
	]
];

(* ::Subsubsection::Closed:: *)
(*fetchPacketFromCacheOrDownload*)

(* Purpose of this function is to replace Download in the voq tests. This is because sometimes we run VOQ tests on packets that are not consistent with Constellation, or even object that doesn't exist *)
(* We do this especially for the External UploadXX functions, which a lot of times we use the VOQ tests for error checking *)
(* Therefore, sometimes we may need to lookup packets from Cache, instead of doing Download from Constellation *)
(* However, not all packets are necessarily available in cache, especially the ones aren't changed in upstream. e.g., say we are only modifying the Name of a Model, then likely we don't have Cache on the packets of the Objects of that model *)

SetAttributes[fetchPacketFromCacheOrDownload, HoldFirst];

(* The syntax of the first input needs to be a list of list. The inner list are the layers of fields it will need to go through in order to get the final packet *)
(* For example, say the main packet is a Model[Container, Vessel], and I want the packet of the Site *)
(* Then the inner list will be {Site} *)
(* If I instead want the packet of the ReceivingContainer of the Site, the inner list will be *)
(* {Site, ReceivingContainer} *)
(* If only specific fields are desired in a packet, add a Packet[fields] entry at last *)
(* e.g. I need packet of Site, but only the ReceivingContainer field, then the inner list should be {Site, Packet[ReceivingContainer]} *)

fetchPacketFromCacheOrDownload[myPacketsToDownload:{{(_Packet | _Symbol | _Field | _Repeated?(MatchQ[First[#1], (_Field | _Symbol)] &))...}...}, myMainPacket:PacketP[], myCache:{PacketP[]...}] := Module[
	{
		inputObject, correctedCache, packetsToDownloadNoLast, fastAssoc, fieldsToLookThrough, fieldsInPacket,
		allObjectsToFetchPackets, flattenedObjects, packetsFromFastAssoc, needDownloadQ, needDownloadFieldList,
		fieldsToDownloadInCorrectFormat, needDownloadFieldListWithPacketSpec, downloadedResults, cachedResults,
		reverseFlatten, flattenedDownloadedPackets, allPackets
	},

	(* If no fields to download, return {} early *)
	If[MatchQ[myPacketsToDownload, {}],
		Return[{}, Module]
	];

	inputObject = Lookup[myMainPacket, Object, Null];

	(* If we can't find the Object entry, retrun $Failed early *)
	If[NullQ[inputObject],
		Return[ConstantArray[$Failed, Length[myPacketsToDownload]], Module]
	];

	(* Check if we have any packet in the Cache which Object -> inputObject. This is usually the case if we are running upstream function to modify an existing object *)
	(* Remove the old packet if we find that in the cache, and add the input packet *)
	correctedCache = Prepend[
		DeleteCases[myCache, KeyValuePattern[Object -> inputObject]],
		myMainPacket
	];

	(* Error check: Packet[xxx] is only supposed to appear in the last entry of each inner list of myPacketsToDownload *)
	packetsToDownloadNoLast = If[Length[#] > 0,
		Most[#],
		#
	]& /@ myPacketsToDownload;

	If[MemberQ[Flatten[packetsToDownloadNoLast], _Packet],
		Return[ConstantArray[$Failed, Length[myPacketsToDownload]], Module]
	];

	fastAssoc = Experiment`Private`makeFastAssocFromCache[correctedCache];

	(* Construct list of fields to go through for the fastAssocLookup function *)
	(* Essentially, if the last entry is Packet[xx], remove that *)
	fieldsToLookThrough = Map[
		Function[{individualFieldList},
			Which[
				(* Empty list: keep it as is *)
				MatchQ[individualFieldList, {}],
					{},
				(* list end with Packet[xx]: remove the last one *)
				MatchQ[Head[Last[individualFieldList]], Packet],
					Most[individualFieldList],
				(* Otherwise keep the entire list *)
				True,
					individualFieldList
			]
		],
		myPacketsToDownload
	];

	(* Find the objects that we want to fetch packets eventually through field values *)
	(* We may be failed to find some fields; that's fine, all Null and $Failed can be correctly handled downstream *)
	allObjectsToFetchPackets = Map[
		Function[{packetFields},
			Experiment`Private`fastAssocLookup[fastAssoc, inputObject, packetFields] /. {x:LinkP[] :> Download[x, Object]}
		],
		fieldsToLookThrough
	];

	(* Ensure we are only getting objects, Null and/or $Failed. If we have anything else, return $Failed *)
	If[MemberQ[Flatten[allObjectsToFetchPackets], Except[Alternatives[ObjectP[], Null, $Failed]]],
		Return[ConstantArray[$Failed, Length[myPacketsToDownload]], Module]
	];


	(* The resulted objects may have more than one layer of lists if we traveled through multiple fields. Flatten all the inner lists *)
	(* However, Flatten function doesn't have the feature to flatten from higher level, so need to do some tricks *)
	(* Define a small helper for this purpose *)
	reverseFlatten[myList_List, removeFailed:BooleanP] := Module[{individuallyFlattenedObjects, listedObjectQ, nonListPositions, cleanedList},
		(* First make each entry into list and flatten individually *)
		individuallyFlattenedObjects = Flatten[ToList[#]]& /@ myList;
		(* If we are removing $Failed, do it now *)
		cleanedList = If[removeFailed,
			DeleteCases[individuallyFlattenedObjects, $Failed, 2],
			individuallyFlattenedObjects
		];
		(* Record whether the original position was a list or not *)
		listedObjectQ = MatchQ[Head[#], List]& /@ myList;
		nonListPositions = Position[listedObjectQ, False];
		(* Then flatten again only at non-list positions *)
		FlattenAt[cleanedList, nonListPositions]
	];

	(* Use the helper to reverse-flatten list *)
	flattenedObjects = reverseFlatten[allObjectsToFetchPackets, False];

	(* Construct the fields in the packet that we want to present in the final result *)
	fieldsInPacket = Map[
		Function[{individualFieldList},
			Which[
				(* Empty list: use Packet[All] *)
				MatchQ[individualFieldList, {}],
					Packet[All],
				(* list end with Packet[xx]: use these specified fields *)
				MatchQ[Head[Last[individualFieldList]], Packet],
					Last[individualFieldList],
				(* Otherwise use Packet[All] *)
				True,
					Packet[All]
			]
		],
		myPacketsToDownload
	];

	(* Now call fetchPacketFromFastAssoc to obtain the packets *)
	packetsFromFastAssoc = MapThread[
		Experiment`Private`fetchPacketFromFastAssoc[#1, fastAssoc, #2, Null]&,
		{flattenedObjects, fieldsInPacket}
	];

	(* Now inspect our results, check if we have successfully fetched everything we need. If not, we need to call Download to do the additional work *)
	(* Note that if we get one $Failed in a field list, we are going to need download even if other packets are found *)
	(* Failures at the fastAssocLookup step is $Failed, while failures at the fetchPacketFromFastAssoc is usually {}, indicates no packet can be found. Include both in the check below *)
	needDownloadQ = Or[
		MatchQ[#, ($Failed | {})],
		MemberQ[ToList[#], ($Failed | {})]
	]& /@ packetsFromFastAssoc;

	(* If no need to download, return the results now *)
	If[!MemberQ[needDownloadQ, True],
		Return[packetsFromFastAssoc]
	];

	(* Gather the packets that were successfully fetched from cache *)
	cachedResults = PickList[packetsFromFastAssoc, needDownloadQ, False];

	(* Filter our list of fields to download *)
	needDownloadFieldList = PickList[myPacketsToDownload, needDownloadQ, True];

	needDownloadFieldListWithPacketSpec = If[MatchQ[Last[#], _Packet],
		#,
		Append[#, Packet[All]]
	]& /@ needDownloadFieldList;

	(* Construct the packet notation for download *)
	fieldsToDownloadInCorrectFormat = Map[
		Function[{singleFieldList},
			If[
				(* If the list length is 1, no need to change anything other than take it out of the list *)
				MatchQ[singleFieldList, {_Packet}],
					First[singleFieldList],
				(* If the list length > 1, construct the field to download *)
				Module[
					{firstField, intermedianFields, packetFields, listOfSubsequentFields},
					(* Isolate the fields we need in the final packet *)
					packetFields = Last[singleFieldList];
					(* separate the first field from the rest *)
					{firstField, intermedianFields} = TakeDrop[Most[singleFieldList], 1];
					(* Change the Head of Packet to List, wrap all intermediate element with another layer of List, then append that packet list  *)
					listOfSubsequentFields = Join[List /@ intermedianFields, {List @@ packetFields}];
					(* Finally, construct the field to download *)
					Packet[Fold[Apply, First[firstField], listOfSubsequentFields]]
				]
			]
		],
		needDownloadFieldListWithPacketSpec
	];

	downloadedResults = Quiet[Download[inputObject, fieldsToDownloadInCorrectFormat]];
	flattenedDownloadedPackets = reverseFlatten[downloadedResults, False];

	(* Combine packets from cache and constellation *)
	allPackets = RiffleAlternatives[flattenedDownloadedPackets, cachedResults, needDownloadQ];

	(* Finally, remove the $Failed for all inner list *)
	DeleteCases[#, $Failed]& /@ allPackets

];

(* Single packet overload *)
fetchPacketFromCacheOrDownload[myPacketsToDownload:{(_Packet | _Symbol | _Field | _Repeated?(MatchQ[First[#1], (_Field | _Symbol)] &))...}, myMainPacket:PacketP[], myCache:{PacketP[]...}] := First[fetchPacketFromCacheOrDownload[{myPacketsToDownload}, myMainPacket, myCache]];

(* updateFastAssoc *)
updateFastAssoc[myPacketsToDownload:{{(_Packet | _Symbol | _Field)...}...}, myMainPacket:PacketP[], myCache:{PacketP[]...}] := Module[
	{newPackets, cacheBall},
	newPackets = fetchPacketFromCacheOrDownload[myPacketsToDownload, myMainPacket, myCache];
	cacheBall = Experiment`Private`FlattenCachePackets[{myCache, myMainPacket, newPackets}];
	Experiment`Private`makeFastAssocFromCache[cacheBall]
];
(* Single packet overload *)
updateFastAssoc[myPacketsToDownload:{(_Packet | _Symbol | _Field)...}, myMainPacket:PacketP[], myCache:{PacketP[]...}] := updateFastAssoc[{myPacketsToDownload}, myMainPacket, myCache];


(* ::Subsubsection::Closed:: *)
(*errorToOptionMapComplete*)

(* We often use function errorToOptionMap to find the failing fields given the error message. However, that function only find error *)
(* of the specific subtype. For example, errorToOptionMap[Model[Container, Vessel]] only look up error for Model[Container, Vessel], not Model[Container] *)
(* we define this helper to map errorToOptionMap over all parent types *)
errorToOptionMapComplete[myType:TypeP[]] := Module[
	{parentTypes, allErrorToOptionRules},
	(* Find all parent types *)
	parentTypes = returnAllSubTypesForType[myType];
	(* call errorToOptionMap for input type and all parent types. *)
	(* In case errorToOptionMap is not defined for a given type, filter out everything except list of rules *)
	allErrorToOptionRules = Cases[
		errorToOptionMap /@ parentTypes,
		{(_Rule | _RuleDelayed)...}
	];

	(* Now, combine all rules with the same key (i.e., same error message). Delete duplicate fields from the same error messsage *)
	GroupBy[
		Flatten[allErrorToOptionRules],
		First -> Last,
		DeleteDuplicates[Flatten[#]]&
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