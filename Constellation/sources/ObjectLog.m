(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ObjectLog*)

ObjectLogAssociation::NotLoggedIn="Not logged in.";
ObjectLogAssociation::RequestError="Some error occurred when making the request to Constellation: `1`. Please change your query and try again.";
ObjectLogAssociation::NoResults="No results found.";
ObjectLogAssociation::InvalidData="Some of the extracted data may not be missing or corrupted.";
ObjectLogAssociation::SomeMetaDataUnavailable="Meta data on fields with multiple entries were not tracked until after 06/22/2023. Changes that happened to the multiple fields: `1` prior to 06/22/2023 will not return entries that were Null or a list of entirely Null. For instance, a field that contained {Value1, Null, Value 2} will compute as {Value1, Value2} and a field that contained {{Value1, Value2}, {Null, Null}, {Null, Value3}} will compute as {{Value1, Value2}, {Null, Value3}}";
ObjectLogAssociation::InvalidField="The type(s) with Computable field(s) `1` cannot be retrieved using ObjectLog. Please change your query to not include Computable fields and try again.";

(* Define pattern for different object log event kinds *)
LogKindsP=FieldAdditionModification | FieldDeletion | ObjectCreation | ObjectDeletion | TypeMigration | TypeCreation | FieldDefinitionCreation | FieldDefinitionModification | FieldReordered;

DefineOptions[
	ObjectLogBaseOptions,
	Options :> {
		{MaxResults -> 100, GreaterEqualP[1, 1] | Infinity, "The maximum number of object log records to return.  Defaults to 100."},
		{SubTypes -> True, True | False, "Determines whether or not to include sub types when the 'Type' option is supplied.  Defaults to False."},
		{StartDate -> Null, _?DateObjectQ | Null, "Only retrieve changes after this date.  Defaults to Null, which includes all changes."},
		{EndDate -> Null, _?DateObjectQ | Null, "Only retrieve changes before this date.  Defaults to Null, which includes all changes."},
		{Fields -> All, ListableP[FieldP[Output -> Short]] | All, "Only retrieve changes to the specified fields.  Defaults to including all fields."},
		{User -> All, ObjectP[Object[User]] | All, "Only retrieve records corresponding to changes made by a specific user.  Defaults to Null."},
		{Order -> NewToOld, OldToNew | NewToOld, "If ascending, records will be recorded in increasing order of time; if descending, then the opposite.  Defaults to descending."},
		{RevisionHistory -> False, True | False, "Displays the revision history information of the object logs."},
		{LogKinds -> All, ListableP[LogKindsP] | All, "Only retrieve changes corresponding to given log event kinds e.g. Field Modification or creation. Defaults to including all log event kinds."},
		{TransactionIds -> Null, Null | All | _List, "Retrieve records by transaction ids."}
	}
];

DefineOptions[
	ObjectLogAssociation,
	Options :> {
		{DatesOnly -> False, True | False, "Whether to return the whole change log, or just a list of timestamps."},
		{ObjectIdsOnly -> False, True | False, "If true, return only the object ids of the objects that have changed. This is significantly faster than grabbing all info for large queries."}
	},
	SharedOptions :> {
		ObjectLogBaseOptions
	}
];

(*
	When neither object or type are specified, the user can get the most recent changes to constellations.
	Doing so isn't very useful outside of the User option -> where one can lookup the chronological changes made
	by a particular user independent of object or type
*)



(* Authors definition for ObjectLogAssociation *)
Authors[ObjectLogAssociation]:={"platform", "scicomp", "brad"};

ObjectLogAssociation[ops:OptionsPattern[]]:=objectLogCore[Nothing, ops];

(* Object overload *)
ObjectLogAssociation[objects:ListableP[objectP | modelP | linkP], ops:OptionsPattern[]]:=Module[{safeOps, objectList, fields, listedTypes, listedFields, requestRule},
	safeOps=OptionDefaults[ObjectLogAssociation, ToList[ops]];
	fields=Lookup[safeOps, "Fields"];

	If[!MatchQ[fields, All],
		listedTypes=If[MatchQ[objects, _List],
			objectToType/@objects,
			{objectToType[objects]}
		];
		listedFields=If[MatchQ[fields, _List],
			fields,
			{fields}
		];

		If[MatchQ[checkForComputableFields[listedTypes, listedFields], $Failed],
			Return[$Failed]
		];
	];

	objectList=If[MatchQ[objects, _List],
		ConstellationObjectReferenceAssocWithOptionalType /@ objects,
		{ConstellationObjectReferenceAssocWithOptionalType[objects]}
	];
	requestRule="object" -> objectList;
	objectLogCore[requestRule, ops]
];

(* Type overload *)
ObjectLogAssociation[types:ListableP[typeP], ops:OptionsPattern[]]:=Module[{safeOps, fields, listedFields, listedTypes, typeList, requestRule},
	safeOps=OptionDefaults[ObjectLogAssociation, ToList[ops]];
	fields=Lookup[safeOps, "Fields"];

	listedTypes=If[MatchQ[types, _List],
		types,
		{types}
	];

	If[!MatchQ[fields, All],
		listedFields=If[MatchQ[fields, _List],
			fields,
			{fields}
		];

		If[MatchQ[checkForComputableFields[listedTypes, listedFields], $Failed],
			Return[$Failed]
		];
	];

	typeList=typeToString /@ listedTypes;
	requestRule="types" -> typeList;
	objectLogCore[requestRule, ops]
];

checkForComputableFields[types:ListableP[typeP], fields:ListableP[_Symbol]]:=Module[
	{tuples, computables},
	tuples=Tuples[{types, fields}];
	computables=DeleteDuplicates[Select[tuples, ComputableFieldQ[#[[1]][#[[2]]]]&]];

	If[Length[computables]>0,
		Message[ObjectLogAssociation::InvalidField, computables];
		Return[$Failed]
	];
];

objectLogCore[targetRule:(_Rule | Nothing), ops:OptionsPattern[]]:=TraceExpression["ObjectLog", Module[
	{
		requestBody, requestBodyJSON, response, safeOps, startDate, endDate, fields, logKindEvents, logKinds,
		user, orderMap, logKindsMap, tableVals, tableHeadings,
		showRevisionHistory, datesOnly, cloudFilesToCache, transactionIds, objectIdsOnly, result
	},

	If[!loggedInQ[],
		Message[ObjectLogAssociation::NotLoggedIn];
		Return[$Failed]
	];

	safeOps=ECL`OptionsHandling`SafeOptions[ObjectLogAssociation, ToList[ops], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	startDate=Lookup[safeOps, StartDate];
	endDate=Lookup[safeOps, EndDate];
	fields=Lookup[safeOps, Fields];
	user=Lookup[safeOps, User];
	showRevisionHistory=Lookup[safeOps, RevisionHistory];
	datesOnly=Lookup[safeOps, DatesOnly];
	objectIdsOnly=Lookup[safeOps, ObjectIdsOnly];
	transactionIds=Lookup[safeOps, TransactionIds];

	(* Map the order keyword to a format that the API wants *)
	orderMap=Association[NewToOld -> "dsc", OldToNew -> "asc"];

	(* Map the object log event kinds to a format the API expects *)
	(* The values here should be in sync with object.go from package object *)
	logKindsMap=Association[
		FieldAdditionModification -> "FIELD_VALUE_WRITES",
		FieldDeletion -> "FIELD_VALUE_REMOVAL",
		ObjectCreation -> "CREATE_OBJECT",
		ObjectDeletion -> "REMOVE_OBJECT",
		TypeMigration -> "MIGRATE_TYPE",
		TypeCreation -> "CREATE_TYPE",
		FieldDefinitionCreation -> "CREATE_FIELD",
		FieldDefinitionModification -> "CHANGE_FIELD",
		FieldReordered -> "REORDER_FIELD"
	];

	logKinds=Lookup[safeOps, LogKinds];
	logKindEvents=Switch[logKinds,
		All, Null,
		_List, Lookup[logKindsMap, #]& /@ logKinds,
		_, {Lookup[logKindsMap, logKinds]}
	];

	(* Build the request body based on the options and whether or not an object was passed *)
	requestBody={
		targetRule,
		"limit" -> Lookup[safeOps, MaxResults],
		If[!MatchQ[transactionIds, All],
			"slltxs" -> transactionIds,
			Nothing
		],
		"subTypes" -> Lookup[safeOps, SubTypes],
		"order" -> Lookup[orderMap, Lookup[safeOps, Order]],
		If[datesOnly,
			"IncludeFieldValues" -> False,
			Nothing
		],
		If[objectIdsOnly,
			"IncludeOnlyObjectIds" -> True,
			Nothing
		],
		If[!NullQ[startDate],
			(* Check if a start date was supplied to filter on *)
			(* Ensure the start date is rfc3339 formatted, which is basically iso with a time zone identifier *)
			"startDate" -> DateObjectToRFC3339[startDate],
			Nothing
		],
		If[!NullQ[endDate],
			(* Ensure the end date is rfc3339 formatted, which is basically iso with a time zone identifier *)
			"endDate" -> DateObjectToRFC3339[endDate],
			Nothing
		],
		If[!MatchQ[fields, All],
			(* Check if any fields were passed to filter on *)
			(* Need to convert everything to strings rather than symbols/expressions *)
			If[MatchQ[fields, _List], "fields" -> ToString /@ fields, "fields" -> {ToString[fields]}],
			Nothing
		],
		If[MatchQ[logKindEvents, _List],
			(* Check if any event kinds were passed to filter on *)
			(* Need to convert everything to strings rather than symbols/expressions *)
			"kinds" -> logKindEvents,
			Nothing
		],
		If[!MatchQ[user, All],
			(* Check if a user was passed to filter on *)
			(* Note the API just wants the user ID, not the full user object, so drop everything else *)
			"userObj" -> ConstellationObjectReferenceAssocWithOptionalType[user],
			Nothing
		]
	};

	(* Convert the body into JSON *)
	requestBodyJSON=Association[requestBody];

	(* Send the request to constellation! *)
	response=ConstellationRequest[
		<|
			"Path" -> "obj/objectlog",
			"Body" -> requestBodyJSON,
			"Method" -> "POST",
			"Timeout" -> 360000
		|>,
		Retries -> 5,
		RetryMode -> Read
	];

	(* If something failed, just bail and return the failure *)
	If[MatchQ[response, $Failed], Return[$Failed]];

	(* For now, I'm grabbing the error message outside of the JSON. We should consolidate how errors get returned across all constellations' API functions *)
	(* Once they are consistent, the error messages can be encapsulated inside Constellation Request. *)
	If[MatchQ[response, _HTTPError],
		Message[ObjectLogAssociation::RequestError, Last[response]];
		Return[$Failed]
	];

	(* If there are no qualifying object logs return Null*)
	If[MatchQ[response, {}], Message[ObjectLogAssociation::NoResults]; Return[Null]];

	(* If we've retrieved cloud files, insert them into the cache*)
	cloudFilesToCache=Lookup[response, "cloud_files_to_cache"];
	If[!NullQ[cloudFilesToCache],
		cacheDownloadResponse /@ First[cloudFilesToCache];
	];

	If[datesOnly, Return[SafelyExtractCreationTimeFromResponse[response]]];

	If[objectIdsOnly, Return[SafelyExtractObjectIdsFromResponse[response]]];

	(* turn the vals horizontal, so we can easily extract and append columns as rows *)
	tableVals=Transpose[formatObjectLogRecord /@ response];

	tableHeadings={Date, Object, ObjectName, User, Username, DateLogRevised, UserWhoRevisedLog, LogKind, Fields, Transactions};

	(* Look through dates and fields for random fields for failures. For fields check both fields and values *)
	If[AnyTrue[tableVals[[1]], !DateObjectQ[#] &] ||
		AnyTrue[tableVals[[9]], MatchQ[#, $Failed] &, 2] ||
		AnyTrue[Flatten@Keys@tableVals[[9]], MatchQ[#, $Failed] &],
		Message[ObjectLogAssociation::InvalidData]];

	(* Only superusers can pull transactions *)
	(* Also drop the transactions column if it wasn't specifically requested *)
	tableVals=If[NullQ[transactionIds], Drop[tableVals, {10}], tableVals];
	tableHeadings=If[NullQ[transactionIds], Drop[tableHeadings, {10}], tableHeadings];

	(* Drop the revision history columns if they're not required*)
	tableVals=If[!showRevisionHistory, Drop[tableVals, {6, 7}], tableVals];
	tableHeadings=If[!showRevisionHistory, Drop[tableHeadings, {6, 7}], tableHeadings];

	(* bring the table values right side up *)
	tableVals=Transpose[tableVals /. _Missing -> Null];

	(* Once we grab the names, splice them into the *)
	result = AssociationThread[tableHeadings, #] & /@ tableVals;

	(* We do not have the data to tell the state of a multiple field with 100% confidence before INSERT_CHANGE_DATE_HERE.
		 Throw a warning if we are not confident with the result *)
	checkHistoricalNullWarning[result];

	result
]];

(* checks if any entry is before the metadata enhancement date AND contains a multiple field change  *)
checkHistoricalNullWarning[response:{_Association...}]:=
    If[MemberQ[response, _?dateBeforeHistoricalNullMetadataEnhancementQ],
			With[{multipleFields=findMultipleFields[response]},
				If[Length[multipleFields]>0,
					Message[ObjectLogAssociation::SomeMetaDataUnavailable, ToString[multipleFields]]
				]
			]
		];

(* Checks if the date in an association is before the historical null metadata enhancement *)
dateBeforeHistoricalNullMetadataEnhancementQ[<||>]:=False;
dateBeforeHistoricalNullMetadataEnhancementQ[record:_Association]:=Lookup[record,Date]<DateObject["2023-06-22T00:00:00", TimeZone -> 0];

(* returns all multiple fields in a given ObjectLog response *)
findMultipleFields[response:{_Association...}]:=DeleteDuplicates[Flatten[Map[findMultipleFields,response]]];
findMultipleFields[record:_Association]:=Module[{type, fields},
	(* Grab the type of the object *)
	type=Download[Lookup[record,Object,Null],Type];

	(* Grab the field changes *)
	fields=Lookup[record, Fields, {}];

	(* If the field changes are not properly formatted ignore the record *)
	If[!MatchQ[fields,_Association],
		Return[{}]
	];

	(* Find all multiple fields *)
	Select[
		Keys[fields],
		Quiet[
			MatchQ[LookupTypeDefinition[type,#,Format],Multiple],
			{LookupTypeDefinition::NoFieldDefError, LookupTypeDefinition::NoFieldComponentDefError}
		]&
	]
];

(* Drop the extraneous info and convert all the object references into real objects *)
formatObjectLogRecord[record_Association]:=TraceExpression["formatObjectLogRecord", Module[
	{object, objectInfo, formattedRecord, fieldNames,
		symbolFieldToRawValue, fieldTraversals, fieldAssociations, fieldValues,
		noObject, fieldLog, rawFields, fieldValuesWithNullRemoved, objectName, user, username, logKind, timeString, sllTxs, userInfo},
	(* convert keys to symbols for
		1. Lookup into fields
		2. We also want to ensure we're returning Symbols and not strings as Keys
	*)

	objectInfo=record[["object"]];
	noObject=If[MatchQ[Lookup[record, "log_type", ""], "TYPE"], True, False];
	object=If[noObject, stringToType[Lookup[objectInfo, "type", ""]], objectReferenceToObject[objectInfo]];
	objectName=Lookup[objectInfo, "name", ""];
	userInfo=Lookup[record, "user", Association[]];
	user=objectReferenceToObject[userInfo];
	username=Lookup[userInfo, "name", ""];
	logKind=Lookup[record, "kind", ""];

	rawFields=Lookup[record, "fields", <||>];
	symbolFieldToRawValue=KeyMap[Symbol, rawFields];
	fieldNames=Keys[symbolFieldToRawValue];

	timeString=Lookup[record, "creation_time", ""];
	sllTxs=Lookup[record, "sll_txs", {}];
	If[timeString == "", timeString=DateString[DateObject[{1970, 1, 1, 0, 0, 0}, TimeZone -> 0]]];

	(*
		Pre-processing that needs to be done in order to reuse Download Code
		1. Convert field keys to traversal form
		2. Remove Null field values
		3. Add a "resolved object" field in the record
	*)

	fieldLog=If[noObject,
		symbolFieldToRawValue,
		fieldTraversals=toTraversals[#, None] & /@ fieldNames;
		fieldValuesWithNullRemoved=DeleteCases[rawFields, Null];
		formattedRecord=Append[record, "fields" -> fieldValuesWithNullRemoved];
		formattedRecord=Append[formattedRecord, "resolved_object" -> objectInfo];
		formattedRecord=Append[formattedRecord, "date" -> timeString];
		fieldAssociations=responseToSeperateCacheAssociations[formattedRecord];
		fieldValues=getCacheValue[object, Rfc3339ToDateObject[timeString], fieldTraversals, fieldAssociations];
		fieldLog=AssociationThread[fieldNames, fieldValues];
		(* If any values failed (usually because of the field has been renamed), just display the raw value *)
		Association@KeyValueMap[
			If[
				MatchQ[#2, $Failed],
				#1 -> Lookup[rawFields, SymbolName[#1]],
				#1 -> #2
			] &,
			fieldLog
		]
	];
	{
		Quiet[Rfc3339ToDateObject[timeString]],
		object,
		objectName,
		objectReferenceToObject[userInfo],
		username,
		Null,
		Null,
		logKind,
		fieldLog,
		sllTxs
	}

]];

SafelyExtractCreationTimeFromResponse[response:{_Association..}]:=Module[{dateStrings, dateObjects},
	dateStrings=Lookup[#, "creation_time", ""] & /@ response;
	dateObjects=TimeZoneConvert[DateObject[#, TimeZone -> 0]] & /@ dateStrings;
	DeleteCases[dateObjects, Except[_?DateObjectQ]]
];

SafelyExtractObjectIdsFromResponse[response:{_Association..}]:=Module[{objectInfos},
	objectInfos=Lookup[#, "object"] & /@ response;
	objectReferenceToObject /@ objectInfos
];