(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[
	ObjectLog,
	{
		Example[{Options, TransactionIds, "Returns changes for custom transaction in upload call:"},
			ObjectLog[transactionTestObject, TransactionIds -> {"CustomTransaction"}],
			ObjectLogOutputP
		],
		Example[{Options, TransactionIds, "Returns changes for manual transaction started with BeginUploadTransaction[\"s1\"]:"},
			ObjectLog[testObject, TransactionIds -> {"s1"}],
			ObjectLogOutputP
		],
		Example[{Basic, "Specifying an object returns the change log of that object:"},
			ObjectLog[testObject, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Basic, "List of Objects work too:"},
			ObjectLog[{testObject, Object[Sample, "ObjLogTestingTwo"]}, MaxResults -> 10],
			ObjectLogOutputP
		],
		Example[{Basic, "Get the changes for an object of a given type:"},
			ObjectLog[Object[Sample], MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Basic, "Object Log also displays shows the history for deleted Objects:"},
			Module[{obj},
				obj=Upload[<|Object -> CreateID[Object[Sample]]|>,AllowPublicObjects->True];
				EraseObject[obj, Force -> True];
				ObjectLog[obj]
			],
			ObjectLogOutputP
		],
		Example[{Options, MaxResults, "MaxResults limits the number of results from ObjectLog[]:"},
			ObjectLog[Object[Sample], MaxResults -> 2],
			ObjectLogOutputP
		],
		Example[{Options, SubTypes, "SubTypes->True also considers subtypes as part of a Type's object log:"},
			ObjectLog[Object[Sample], SubTypes -> True, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, User, "User returns a log of the most recent changes made by the specified user:"},
			ObjectLog[Object[User], User -> $PersonID, Fields -> CakePreference, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, StartDate, "StartDate specifies a lower bound for the object log. Default is None and represents the earliest possible changes:"},
			ObjectLog[Object[Sample], StartDate -> Yesterday, Order -> OldToNew, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, EndDate, "EndDate specifies an upper bound for the object log. Default is Now:"},
			ObjectLog[Object[Sample], EndDate -> Yesterday, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, Fields, "The Field option only returns logs with changes given on specified fields:"},
			ObjectLog[Object[Sample], Fields -> {Count}, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, Fields, "The Field option only returns logs with changes given on specified singleton field:"},
			ObjectLog[Object[Sample], Fields -> Count, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, Order, "Order represents whether the logs are sorted by most recent or by most oldest. Order is descending by default with the most recent changes on top:"},
			ObjectLog[Object[User], Order -> OldToNew, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, OutputFormat, "If a Table output is not desired, the Object Log can also be represented as a list of associations:"},
			ObjectLog[Object[Sample], MaxResults -> 3, OutputFormat -> Association],
			ObjectLogOutputP
		],
		Example[{Options, RevisionHistory, "By default revision history is hidden, but revision history displays whether the object log was modified and by whom:"},
			ObjectLog[Object[Sample], MaxResults -> 5, RevisionHistory -> True],
			ObjectLogOutputP
		],
		Example[{Options, LogKinds, "LogKinds option returns list of all object log entries of a particular kind e.g. FieldAdditionModification, ObjectCreation etc. Default is All:"},
			ObjectLog[Object[Sample, "ObjLogTesting"], LogKinds -> {FieldAdditionModification}],
			ObjectLogOutputP
		],
		Test["LogKinds option returns list of all object log entries of a particular kind, works for both types and specific objects e.g. FieldDefinitionCreation etc. Default is All:",
			ObjectLog[Object[Sample], LogKinds -> {FieldDefinitionCreation}, MaxResults -> 1],
			ObjectLogOutputP
		],
		Example[{Messages, "NotLoggedIn", "Fails if returned if the user is not logged in:"},
			ObjectLog[]
			,
			$Failed,
			Messages :> {ObjectLogAssociation::NotLoggedIn},
			Stubs :> {
				Constellation`Private`loggedInQ[]:=False
			}
		],
		Example[{Messages, "RequestError", "Fails if there is an error in the request call that can't be caught by a pattern:"},
			ObjectLog[Object[User, Emerald, Developer, "id:1"]],
			$Failed,
			Messages :> {ObjectLogAssociation::RequestError}],
		Example[{Messages, "NoResults", "If there are no results, ObjectLog returns null:"},
			ObjectLog[StartDate -> Now + 1 Hour],
			Null,
			Messages :> {ObjectLogAssociation::NoResults}
		],
		Example[{Messages, "InvalidData", "Some older data has some invalid inconsistencies. If there is one, ObjectLog will warn the user:"},
			Message[ObjectLogAssociation::InvalidData],
			Null,
			Messages :> {ObjectLogAssociation::InvalidData}
		],
		Example[{Messages, "SomeMetaDataUnavailable", "Meta data on fields with multiple entries were not tracked for some older data. For results containing such data, ObjectLog will warn the user:"},
			Message[ObjectLogAssociation::SomeMetaDataUnavailable,"{SamplesIn, SamplesOut}"],
			Null,
			Messages :> {ObjectLogAssociation::SomeMetaDataUnavailable}
		],
		Test["Returns all recent changes:",
			Length[ObjectLog[MaxResults -> 10, OutputFormat -> Association]] == 10,
			True
		],
		Test["Returns changes on a given object:",
			Module[{uniqueObjects},
				(* grabs unique Objects from the results *)
				uniqueObjects=DeleteDuplicates[Lookup[Object] /@ ObjectLog[testObject, MaxResults -> 1, OutputFormat -> Association]];
				Length[Download[uniqueObjects, ID]] == 1
			],
			True
		],

		Test["Returns changes on a given type:",
			Module[{types, testType},
				testType=Object[Sample];
				(* Grabs the types of all the objects *)
				types=#[Type] & /@ Lookup[Object] /@ ObjectLog[testType, SubTypes -> True, MaxResults -> 5, OutputFormat -> Association];
				(* Ensures all the types are a inclusive subtype of the testing type *)
				AllTrue[types, MatchQ[#, TypeP[testType]] &]
			],
			True
		],

		Test["Returns changes by a given user:",
			Module[{uniqPersons},
				uniqPersons=DeleteDuplicates[Flatten[Lookup[User] /@ ObjectLog[Object[User], User -> $PersonID, Fields -> CakePreference, MaxResults -> 1, OutputFormat -> Association]]];
				(* Ensure we only recieves object logs of things modified by the user *)
				Length[uniqPersons] == 1 && First[uniqPersons] == $PersonID
			],
			True
		],

		Test["Returns changes in a certain date range:",
			Length[ObjectLog[testObject, StartDate -> afterChangeOne, EndDate -> afterChangeTwo, OutputFormat -> Association]] == 3,
			True
		],

		Test["Returns changes on certain fields:",
			Module[{uniqFields},
				(* Ensures that only one field is retrieved from the object log *)
				uniqFields=DeleteDuplicates[Flatten[Keys /@ Lookup[Fields] /@ Quiet[ObjectLog[testType, Fields -> {Products}, OutputFormat -> Association],ObjectLogAssociation::SomeMetaDataUnavailable]]];
				Length[uniqFields] == 1 && First[uniqFields] == Products
			],
			True
		],

		Test["Returns changes with multiple filters set:",
			Module[{result},
				result=ObjectLog[testObject, StartDate -> beforeChanges, EndDate -> afterChangeOne, User -> $PersonID, Fields -> {Count, BoilingPoint}, OutputFormat -> Association];
				Length[result] == 3
			],
			True
		],

		Test["ObjectLogAssociationP handles Transaction properly in output:",
			Module[{result, records},
				records=ObjectLog[testObject, StartDate -> beforeChanges, EndDate -> afterChangeOne, User -> $PersonID, Fields -> {Count, BoilingPoint}, TransactionIds -> All, OutputFormat -> Association];
				result=Lookup[records[[1]], Transactions];
				result == {"s1"}
			],
			True
		],

		Test["Logs of erased objects are still displayed:",
			Length@Normal@ObjectLog[erasedTestObject, OutputFormat -> Association],
			GreaterP[0]
		]
	},
	SymbolSetUp :> ({testObject, secondTestObject, transactionTestObject, erasedTestObject, beforeChanges, afterChangeOne, afterChangeTwo}=RunInitialSetup[]; testType=Model[Item, Cap];)
];

(* We're going to run these once to setup the initial object log *)
RunInitialSetup[]:=Module[{obj, obj2, transactionObj, erasedObject, start, beforeBigChanges, afterBigChanges},
	obj=Upload[<|Type -> Object[Sample], Name -> "My Object Log Test Sample " <> $SessionUUID, DeveloperObject -> True|>,AllowPublicObjects->True];

	Constellation`Private`BeginUploadTransaction["s1"];
	start=Now;
	(* make changes to fields with a different user, also update additional fields *)
	Upload[Association[Object -> obj, Count -> #, BoilingPoint -> # Celsius],AllowPublicObjects->True] & /@ {3, 4, 5};

	(* Wait a few seconds *)
	Pause[2];
	Constellation`Private`BeginUploadTransaction[];
	beforeBigChanges=Now;

	(* testing custom transaction *)
	transactionObj=Upload[<|Type -> Object[Sample], Name -> "My Object Log Transaction Test Sample " <> $SessionUUID, DeveloperObject -> True|>,AllowPublicObjects->True];

	(* do an upload with a given transaction on a new object *)
	Upload[Association[Object -> transactionObj, Radioactive -> True], Transaction -> "CustomTransaction",AllowPublicObjects->True];

	(* make targeted changes to the fields in obj *)
	Upload[Association[Object -> obj, BoilingPoint -> # Celsius],AllowPublicObjects->True] & /@ {1, 2, 3};

	Pause[2];
	EndUploadTransaction[];
	afterBigChanges=Now;

	obj2= Upload[<|Type -> Object[Sample], Name -> "ObjLogTestingTwo" <> $SessionUUID, DeveloperObject -> True|>,AllowPublicObjects->True];

	Upload[Association[Object -> obj2, Count -> 100],AllowPublicObjects->True];
	EndUploadTransaction[];

	(* Create an erased object *)
	erasedObject=Upload[<|Type -> Object[Sample], Name -> "ObjLogTestingThree" <> $SessionUUID, DeveloperObject -> True|>,AllowPublicObjects->True];
	EraseObject[erasedObject, Force -> True];

	Upload[<|Object -> $PersonID, CakePreference -> "Oreo CheeseCake"|>,AllowPublicObjects->True];
	{obj, obj2, transactionObj, erasedObject, start, beforeBigChanges, afterBigChanges}

];
