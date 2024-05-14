(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(* Patterns *)

fetchKindP:="Download" | "Dereference";

(* A value that can go in a Part *)
indexP=_Integer | _Span | All | Key[_Symbol] | {___Key} | {___Integer};

(* ::Subsection:: *)
(* Object, ID, Name Cache Definitions *)

(*
	The object cache (Constellation`Private`objectCache) looks like:

	objectCacheKeyP = Object[...., "id:objectId"] |  {Object[...., "id:objectId"], _DateObject}

	<|
		objectKeyP-><|
			(* NOTE: This is the "CheckAndSet" token returned by the server so that we will know if our cache is up to date *)
			(* or not. We will first ask the server for the current CAS of the object before relying on the fields in our *)
			(* objectCache. The objectCache stores the CAS of the object at the time at which the fields in the cache were *)
			(* downloaded. *)
			"CAS"->_String,

			(* NOTE: This is the name of the object. We always store the object in the cache in the ID form. *)
			"Name"->_String,

			(* NOTE: This is the main cache of fields that we think about when talking about the object cache. *)
			(* NOTE: DownloadCount is a 0-indexed incremented counter that tells us on which download call we got that field *)
			(* information. In the following example, we downloaded the CakePreference field for this object on the first call *)
			(* to Download since SLL was loaded. *)
			(* NOTE: Limit is the value of the PaginationLength to Download when the Download was done. *)
			"Fields"-><|
				Constellation`Private`Traversal[CakePreference] -> <|
					"Rule" -> CakePreference -> "cheese(cake)",
					"Limit" -> 50,
					"DownloadCount" -> 0
				|>..
			|>,

			(* NOTE: This stores summary information about different fields. Most importantly is the "Count" key that stores *)
			(* the length of the field. *)

			(* NOTE: If a field is really empty (ex. ProtocolsAuthored->{} because my $PersonID doesn't have any protocols authored) *)
			(* then, the "FieldSummaries" for ProtocolsAuthored is important because the ProtocolsAuthored field will not show up in *)
			(* the "Fields" part of the objectCache and only show up in the "FieldSummaries" part of the objectCache. *)
			(* That is, if a field is Null/{}, then the field will not show up in the "Fields" section of the cache and we'll only know *)
			(* that we have it because it will have a "Count" -> 0 in the "FieldSummaries" part of the cache. *)
			"FieldSummaries"-><|
				CakePreference -> <|"$Type" -> "__JsonFieldSummary__", "FieldId" -> "5qVr0L", "Count" -> 1|>
			|>,

			"Tags"->{},

			(* NOTE: This indicates if the object is Download or Session cached. *)
			"Session"->BooleanP
		|>
	|>

	It is used as a client side cache and will be checked before we look at field values from constellation.
*)

(*
	The ID cache (Constellation`Private`idCache) looks like:

	<|
		"id:J8AY5jDlY16b" -> Object[User, Emerald, Developer, "id:J8AY5jDlY16b"]
	|>

	It is used to quickly go from Object["id:J8AY5jDlY16b"] to Object[User, Emerald, Developer, "id:J8AY5jDlY16b"].
*)

(*
	The Name cache (Constellation`Private`nameCache) looks like:

	<|
		Object[User, Emerald, Developer, "thomas"] -> Object[User, Emerald, Developer, "id:J8AY5jDlY16b"]
	|>

	It is used to quickly go from Object[User, Emerald, Developer, "thomas"] to Object[User, Emerald, Developer, "id:J8AY5jDlY16b"].
*)

(* ::Subsubsection:: *)
(* clearCache *)

(* Listable Overload *)
clearCache[objects:{(objectP | modelP | _String)...}]:=Map[
	clearCache,
	objects
];

(* Singleton Overload. *)
clearCache[object:objectP | modelP]:=clearCache[
	Last[
		cacheObjectID[object]
	]
];

(* Overload for an object ID. *)
(* Go from the ID -> Object, then KeyDrop. *)
clearCache[id_String]:=Module[
	{object},

	object=Lookup[
		idCache,
		id
	];

	If[MissingQ[object],
		Return[Nothing]
	];

	(*Reset cache association variables*)
	objectCache=KeyDrop[objectCache, Key[getObjectCacheKey[object]]];
	nameCache=DeleteCases[nameCache, object];
	idCache=KeyDrop[idCache, id];

	object
];

clearCache[]:=(
	Set[downloadCounter, 0];
	Set[objectCache, <||>];
	Set[nameCache, <||>];
	Set[idCache, <||>];
);

(* ::Subsubsection:: *)
(* cacheObjectID *)

(* Use the Name & ID caches to convert the input object ID to the fully qualified ID (if possible). Otherwise just returns the ID.*)
Authors[cacheObjectID]:={"platform"};

cacheObjectID[object:objectP | modelP]:=Lookup[
	nameCache,
	object,
	Lookup[
		idCache,
		object,
		object
	]
];

cacheObjectID[{object:objectP | modelP, date:optionalDateP}]:={cacheObjectID[object], date};

cacheObjectID[packet:_]:=packet;

OnLoad[clearCache[]];

(* ::Subsubsection:: *)
(* typeSymbols *)

(* Returns the list of fields symbols in a type wrapped in Traversal *)
typeSymbols[type:typeP]:=typeSymbols[type]=With[
	{definition=LookupTypeDefinition[type]},

	If[FailureQ[definition],
		$Failed,
		Map[
			Traversal,
			Lookup[definition, Fields][[All, 1]]
		]
	]
];

(* ::Subsubsection:: *)
(* setSessionCache *)

setSessionCache[object:objectP | modelP, Download]:=With[
	{id=cacheObjectID[object]},
	objectCache[getObjectCacheKey[id]]["Session"]=False;
];

setSessionCache[object:objectP | modelP, Session]:=With[
	{id=cacheObjectID[object]},
	objectCache[getObjectCacheKey[id]]["Session"]=True;
];

setSessionCache[object:objectP | modelP, Automatic | {___Association}]:=Module[
	{id, typeValue, existingValue},
	id=cacheObjectID[object];

	cacheValue=Lookup[objectCache, Key[getObjectCacheKey[id]], Null];

	(* TODO: figure out what we actually want to do for temporal objects *)
	If[MatchQ[cacheValue, Null], Return[Null]];

	(* Only overwrite the Session value if it has never been set before *)
	If[Not[KeyExistsQ[cacheValue, "Session"]],
		setSessionCache[
			id,
			(* Fetch the Session/Download value from the type definition. Default to Download if it does not exist. *)
			Lookup[LookupTypeDefinition[objectToType[object]], Cache, Download]
		]
	]
];

(* ::Subsubsection:: *)
(* addDefaultValues *)

(* All this function does is add the rest of the fields of the type that are not in the packet to the packet. *)
(* That is, if we were given a Object[User, Emerald] packet and it had all Object[User, Emerald] fields except *)
(* for CakePreference, it would add the CakePreference->Null rule to the packet. *)
addDefaultValues[packet_Association]:=With[
	{type=Lookup[packet, Type]},

	(* NOTE: Keys[type] gives us the fields of that type. *)
	addDefaultValues[packet, Keys[type]]
];

addDefaultValues[packet_Association, fields:{___Symbol}]:=With[
	{type=Lookup[packet, Type]},

	Join[
		packet,
		AssociationMap[
			defaultValue[type[#]]&,
			Complement[
				Intersection[fields, Keys[type]],
				Keys[packet]
			]
		]
	]
];

(* defaultValue will return Null for Single and Computable fields, it will return {} for all other field formats. *)

(* Field overload -- Type[Field]. *)
defaultValue[field:fieldP]:=defaultValue[field]=defaultValue[
	Head[field],
	First[field]
];

defaultValue[type:typeP, field_Symbol]:=defaultValue[type, field]=Quiet[
	defaultValue[
		LookupTypeDefinition[type, field]
	],
	{LookupTypeDefinition::NoFieldDefError}
];

defaultValue[$Failed]:=$Failed;
defaultValue[$Failed, _Symbol]:=$Failed;
defaultValue[definition:{(_Rule | _RuleDelayed)...}]:=With[
	{
		format=Lookup[definition, Format],
		class=Lookup[definition, Class]
	},

	If[MatchQ[format, Single | Computable],
		Null,
		{}
	]
];

(* ::Subsubsection:: *)
(* filterSessionCachedObjects *)

(* Takes an association of objects to lists of Field expressions indicating the fields that are to be downloaded.
Filter out all objects which are already in the session cache. This is used in the whole-object download case. *)

(* NOTE: The cache input variable that we are passed is objectCache in the Download[...] code in Constellation.m *)
(*
	If[MatchQ[cacheOption,Download],
		Identity,
		filterSessionCachedObjects[#,objectCache]&
	]
*)
(* NOTE: objectFields is information we get from objectRequestsAssociation[objects] in Download[...]. *)
(* The Keys of objectFields are just regular objects so since we KeySelect we're just passing the objects to sessionQ. *)
(* Please see objectRequestsAssociation[...] for more information. *)
filterSessionCachedObjects[objectFields_Association, cache_Association]:=KeySelect[
	objectFields,
	!sessionQ[#, cache]&
];

(* Function version *)
filterSessionCachedObjects[cache_Association]:=Function[{objectFields},
	filterSessionCachedObject[objectFields, cache]
];

filterSessionCachedObjectsWithDate[objectFields_Association, cache_Association]:=KeySelect[
	objectFields,
	!sessionQ[First[#], Last[#], cache]&
];

filterSessionCachedObjectsWithDate[cache_Association]:=Function[{objectFields},
	filterSessionCachedObjectsWithDate[objectFields, cache]
];

(* ::Subsubsection:: *)
(* filterSessionCachedObjects *)

(* Takes an association of objects to lists of Field expressions indicating the fields that are to be downloaded. *)
(* Filter out all fields for objects which are already in the session cache and are not _RuleDelayed (computable/long multiples).*)
Authors[filterSessionCachedFieldsWithDate]:={"platform"};

filterSessionCachedFieldsWithDate[objectFields_Association, cache_Association]:=Merge[
	KeyValueMap[
		nonSessionFields[First[#1], Last[#1], #2, cache]&,
		objectFields
	],
	mergeFields
];


(* NOTE: This function is only used as the merge function of the Merge[...] of a list of *)
(* <|object -> <|"Fields" -> {list of fields to download}|>|> associations -- so we'll only be merging for objects *)
(* that are the same. In this merge function, we simply take the union of all the fields that we're supposed to *)
(* download for the object. *)
mergeFields[assocs:{___Association}]:=Append[
	Apply[Join, assocs],
	"Fields" -> Apply[
		Union,
		assocs[[All, "Fields"]]
	]
];

nonSessionFields[object:objectP | modelP, date_, request_Association, cache_Association]:=nonSessionFields[object, date, request, cache];


nonSessionFields[object:objectP | modelP, date:optionalDateP, request_Association, cache_Association]:=With[
	{
		fields=Lookup[request, "Fields", {}]
	},
	If[sessionQ[object, date, cache],
		Merge[
			Map[
				nonSessionFields[object, date, #, cache]&,
				fields
			],
			mergeFields
		],
		Association[{object, date} -> <|"Fields" -> fields|>]
	]
];

(*Filters the field only if the object is session cached and the field is not rule delayed*)
nonSessionFields[object:objectP | modelP, date:optionalDateP, part:Verbatim[Traversal][field_Symbol, Repeated[PatternSequence[All, _Integer], {0, 1}]], cache_Association]:=If[
	And[
		sessionQ[object, date, cache],
		MatchQ[
			cache[[Key[getObjectCacheKey[object, date]], "Fields", Key[Traversal[field]], "Rule"]],
			Except[_RuleDelayed]
		]
	],
	Nothing,
	<|getObjectCacheKey[object, date] -> <|"Fields" -> {part}|>|>
];

(* Download through links case where we have to check that our links that we're traversing through are also session cached. *)
nonSessionFields[object:objectP | modelP, date:optionalDateP, part:Verbatim[Traversal][field_Symbol, Repeated[PatternSequence[All, _Integer], {0, 1}], rest__], cache_Association]:=If[sessionQ[object, date, cache],
	With[
		{
			fieldValue=ToList[getCacheValue[object, date, Traversal[field], cache]]
		},

		Switch[fieldValue,
			{(objectP | modelP | linkP)...},
			If[AllTrue[fieldValue, sessionQ[#, date, cache]&],
				Merge[
					Map[
						nonSessionFields[linkToObject[#], If[TrueQ[linkHasDateQ[#]], getLinkDate[#], date], Traversal[rest], cache]&,
						fieldValue
					],
					mergeFields
				],
				<|{object, date} -> <|"Fields" -> {part}|>|>
			],
			{Null},
			Nothing,
			_,
			<|{object, date} -> <|"Fields" -> {part}|>|>
		]
	],
	<|{object, date} -> <|"Fields" -> {part}|>|>
];

nonSessionFields[object:objectP | modelP, date:optionalDateP, field_Traversal, cache_Association]:=<|{object, date} -> <|"Fields" -> {field}|>|>;

sessionQ[link:linkP, date:optionalDateP, cache_Association]:=sessionQ[linkToObject[link], If[linkHasDateQ[link], getLinkDate[link], date], cache];
sessionQ[object:objectP | modelP, date:optionalDateP, cache_Association]:=TrueQ[
	Lookup[
		Lookup[
			cache,
			Key[getObjectCacheKey[object, date]],
			<||>
		],
		"Session",
		False
	]
];

(* ::Subsubsection:: *)
(* filterLocalFields *)

(* Removes all fields which can be computed locally. For objects with IDs, these are Object/ID/Type. For objects with *)
(* names, this is only Type. *)
Authors[filterLocalFieldsWithDate]:={"platform"};

filterLocalFieldsWithDate[objectFields_Association]:=Association[
	KeyValueMap[
		removeLocalFields[First[#1], #2, Last[#1]]&,
		objectFields
	]
];

removeLocalFields[object:ReferenceWithNameP, request_Association, date_]:=Module[
	{fields, filteredFields},
	fields=Lookup[request, "Fields", {}];
	filteredFields=DeleteCases[
		fields,
		Alternatives[
			Traversal[Type],
			Traversal[PacketTarget[Type | {Type}]]
		]
	];

	If[Length[filteredFields] > 0,
		{object, date} -> Association["Fields" -> filteredFields],
		Nothing
	]
];

removeLocalFields[object:objectP | modelP, request_Association, date_]:=Module[
	{fields, filteredFields},

	fields=Lookup[request, "Fields", {}];
	filteredFields=DeleteCases[
		fields,
		Alternatives[
			Traversal[Object | Type | ID],
			Traversal[PacketTarget[Object | Type | ID | {(Object | Type | ID)..}]]
		]
	];

	If[Length[filteredFields] > 0,
		{object, date} -> Association["Fields" -> filteredFields],
		Nothing
	]
];

(* ::Subsubsection:: *)
(* makeExplicitCache *)

DefineOptions[makeExplicitCache,
	Options :> {
		{Object -> False, BooleanP, "Indicates if we are Downloading specific fields or the whole object."}
	}
];

(* Takes in a list of packets and reformats the data in the regular object cache format. *)
(* We will add all of the fields with Missing["cache"] as a value if we are called from the whole object (Object->True) *)
(* overload. We also always add the Type and ID fields to the object cache. *)
makeExplicitCache[packets:{__}, ops:OptionsPattern[]]:=Module[
	{options, objectOption, packetMetadata, nonNullPackets, objectPackets, badPackets, packetsWithKeys},
	options=OptionDefaults[makeExplicitCache, ToList[ops]];
	objectOption=Lookup[options, "Object"];

	(* Remove Null packets from our explicit cache. *)
	nonNullPackets=DeleteCases[packetMetadata, KeyValuePattern["packet" -> Null]];
	(* remove and message on packets with no Object *)
	{badPackets, objectPackets}=groupGoodObjectPackets[packets];

	packetsWithKeys=Append[#,
		"key" -> getObjectCacheKey[Lookup["object"]@#, Lookup[Lookup["packet"]@#, DownloadDate, None]]]& /@ objectPackets;

	If[MissingQ[packetsWithKeys],
		<||>,

		(* NOTE: Wrapping <|...|> around a list is equivalent to doing Association@@{}. *)
		(* NOTE: Mapping over an association will map over the values and maintain the keys. In this case, that means mapping *)
		(* over the packets. *)
		<|Map[
			(* NOTE: We ALWAYS need to be passing the Object option here to indicate whether we're Downloading specific fields or the whole thing *)
			explicitMissing[#, {Object -> objectOption}]&,
			(* NOTE: This means that if we are given multiple packets for the same object, take the last packet. *)
			(* The result of this GroupBy is <|(objectP -> packetP)..|> *)
			GroupBy[packetsWithKeys, Key["key"], Query[-1, "packet"]]
		]|>
	]
];

(* No cache fallthrough *)
makeExplicitCache[_, ops:OptionsPattern[]]:=<||>;

(* This is to preserve the helpful user error messages, because makeExplicitCache no longer gauruntees user ordering (due to simulation) *)
messageBadCachePackages[packets:{__}]:=Module[
	{objectPackets, badPackets},
	{badPackets, objectPackets}=groupGoodObjectPackets[packets];
	If[!MissingQ[badPackets],
		Message[Download::BadCache, badPackets[[All, "index"]]]
	];
];

groupGoodObjectPackets[packets:{__}]:=Module[{packetMetadata, nonNullPackets, badPackets, objectPackets},
	(* NOTE: The "index" key is included for messages in case there is something wrong with the packets given. *)
	packetMetadata=MapIndexed[
		<|
			"packet" -> #1,
			"index" -> First[#2],
			(* NOTE: This is equivalent to Lookup[#1, Object]. It's actually slower than Lookup, but it gracefully handles Null  *)
			"object" -> Query[Key[Object]]@#1
		|> &,
		packets
	];

	(* Remove Null packets from our explicit cache. *)
	nonNullPackets=DeleteCases[packetMetadata, KeyValuePattern["packet" -> Null]];

	(* remove and message on packets with no Object *)
	{badPackets, objectPackets}=Lookup[
		GroupBy[
			nonNullPackets,
			(* NOTE: This is equivalent to doing Lookup[#, "object"] and takes the same time to evaluate. *)
			MissingQ[#object] &
		],
		{True, False}
	];
	{badPackets, objectPackets}
];
(*Removes all fields which are specified in the list of packets given as the second argument.*)
DefineOptions[explicitMissing,
	Options :> {
		{Object -> False, BooleanP, "Indicates if we are Downloading specific fields or the whole object."}
	}
];

(* Construct the explicit cache but do NOT make all the missing fields have $Failed *)
explicitMissing[packet:KeyValuePattern[Object -> objectP | modelP], ops:OptionsPattern[]]:=Module[
	{objectOption, object, type, id, fields},

	(* not calling OptionDefaults here because it can be slow; just assume that we are being passed the Object option here *)
	objectOption=Lookup[ops, Object];

	object=cacheObjectID[packet[Object]];
	type=objectToType[object];
	id=If[StringStartsQ[Last[object], "id:"],
		ID -> Last[object],
		Name -> Last[object]
	];

	(* if we are Downloading the whole object, then we do want to add the missing cache things in; if we are downloading specific fields, we don't want to here *)
	(* NOTE: The later associations in the Join[...] call will "overwrite" the previous ones. So if we indeed have the field *)
	(* value in the packet, we will get the value and not Missing["cache"]. *)
	fields=Join[
		If[objectOption,
			AssociationMap[Missing["cache"] &, Fields[type, Output -> Short]],
			<||>
		],
		<|Type -> type, id|>,
		packet
	];

	(* AssociationMap preserves the rule or delayed rule head *)
	(* so we don't evaluate the delayed rules *)
	<|
		"Fields" -> KeyMap[Traversal,
			AssociationMap[
				#[[1]] -> <|
					"Rule" -> #,
					"Limit" -> None,
					"DownloadCount" -> "ExplicitCache"
				|>&,
				fields
			]
		]
	|>
];

(* ::Subsubsection:: *)
(* filterExplicitFields *)

Authors[filterExplicitFieldsWithDate]:={"platform"};
(* This function will remove the field requests if that field is in the explicit cache for the given object. *)

(* Function Overload *)
(* NOTE: packetsByObject is given to us as our explicit cache in regular object cache format. *)
filterExplicitFieldsWithDate[packetsByObject:_Association]:=Function[{objectFields},
	filterExplicitFieldsWithDate[objectFields, packetsByObject]
];
filterExplicitFieldsWithDate[objectFields_Association, <||>]:=objectFields;

filterExplicitFieldsWithDate[objectFields_Association, packetsByObject:_Association]:=Module[{},
	Merge[
		KeyValueMap[
			removeExplicitFields[First[#1], Last[#1], #2, packetsByObject]&,
			objectFields
		],
		mergeFields
	]
];

removeExplicitFields[object:objectP | modelP, date_, request_Association, packetCache_Association]:=Module[
	{packet, initialPacketFromCache, splitFields, nonRepeatedFields, repeatedFields, allQ, nonRepeatedFieldsAllReplaced, cacheKey},
	cacheKey=getObjectCacheKey[object, date];
	(*If object is not in the explicit packet cache, return all fields*)
	If[!KeyExistsQ[packetCache, cacheKey],
		Return[<|cacheKey -> request|>]
	];
	splitFields=GroupBy[
		Lookup[request, "Fields", {}],
		MatchQ[Verbatim[Traversal][
			_Symbol | _Query | _PacketTarget | Verbatim[Length][Except[_Repeated]],
			___
		]]
	];

	{nonRepeatedFields, repeatedFields}=Lookup[splitFields, {True, False}, {}];
	initialPacketFromCache=packetCache[[Key[cacheKey], "Fields", All, "Rule"]];

	(* turn the non-repeated fields that are All into the fields we are worried about *)
	(* figure out if we need to get all the fields for the given traversal *)
	allQ=MemberQ[nonRepeatedFields, Verbatim[Traversal][All]];

	(* transform the All traversal into all the fields for that given type *)
	nonRepeatedFieldsAllReplaced=If[allQ,
		With[{fields=Traversal[#] & /@ Keys[objectToType[object]]},
			DeleteCases[Join[nonRepeatedFields, fields], Verbatim[Traversal][All]]
		],
		nonRepeatedFields
	];

	packet=If[MissingQ[initialPacketFromCache],
		<||>,
		<|Values[initialPacketFromCache]|>
	];

	Merge[
		Join[
			{<|getObjectCacheKey[object, date] -> <|"Fields" -> repeatedFields|>|>},
			Map[
				nextTraversal[#, date, packet]&,
				nonRepeatedFieldsAllReplaced
			]
		],
		mergeFields
	]
];

(* NOTE: Remove the fields that come from an object where we're given a packet directly as input since we don't *)
(* talk to the database in this case. We will sow "missing-cache-fields" if we can't find a field. *)
filterPacketFields[(packet:_Association) -> KeyValuePattern["Fields" -> (traversals:{_Traversal ...})]]:=Module[
	{},

	(* if we are only getting fields directly and we have packets, then we are not going to go to the database for them; otherwise we need to use nextTraversal to figure out how we need to go to the database for them *)
	(* if we're Downloading through links but the root field doesn't exist in the packet, then short circuit and go to Nothing anyway *)
	Merge[
		Map[
			Which[
				MatchQ[#, Verbatim[Traversal][_Symbol | {___Symbol} | PacketTarget[_Symbol | {___Symbol}]]], Nothing,
				MatchQ[#, Verbatim[Traversal][_Symbol, ((_Symbol | _Query)...), ___PacketTarget]] && Not[KeyMemberQ[packet, FirstOrDefault[#]]], Nothing,
				True, nextTraversal[#, None, packet]
			]&,
			traversals
		],
		mergeFields
	]

];

(* if we don't have any packets here then it doesn't matter and we just return the input *)
filterPacketFields[rule:_]:=rule;

filterPacketFieldsWithDate[{(packet:_Association), (date:_)} -> KeyValuePattern["Fields" -> (traversals:{_Traversal ...})]]:=Module[
	{},
	(* if we are only getting fields directly and we have packets, then we are not going to go to the database for them; otherwise we need to use nextTraversal to figure out how we need to go to the database for them *)
	(* if we're Downloading through links but the root field doesn't exist in the packet, then short circuit and go to Nothing anyway *)
	Merge[
		Map[
			Which[
				MatchQ[#, Verbatim[Traversal][_Symbol | {___Symbol} | PacketTarget[_Symbol | {___Symbol}]]], Nothing,
				MatchQ[#, Verbatim[Traversal][_Symbol, ((_Symbol | _Query)...), ___PacketTarget]] && Not[KeyMemberQ[packet, FirstOrDefault[#]]], Nothing,
				True, nextTraversal[#, date, packet]
			]&,
			traversals
		],
		mergeFields
	]
];

filterPacketFieldsWithDate[rule:_]:=rule;

(* ::Subsubsection:: *)
(*nextTraversal*)

(* nextTraversal goes through the cache and sees if a given field traversal is actually in the cache; if it is not, we *)
(* indicate that we still need to go to the server for that, and if it is we indicate we DON'T need to go to the server. *)

(* lots of overloads because there are lots of ways to do a Traversal and the syntax is slightly different each time *)

(* There was an explicit cache error, do not replace the cache value with a server value or default value*)
nextTraversal[$Failed, _Association]:=Nothing;
nextTraversal[$Failed, date_, _Association]:=Nothing;

(*
	Often when traversing through links from a cache, some fields may be null or missing. Ignore these, since they break
 	the list of links pattern and we still want to know which links we can do the work with even if other provided stuff is invalid
 *)
removeNullsFromLinks[expr_]:=If[MatchQ[expr, ListableP[LinkP[IncludeTemporalLinks -> True] | Null]],
	DeleteCases[expr, Null],
	expr (* simply return the original expression if its not even a link or list or links*)
];

(*Single level field request does not need to go to server IF the field is in the cache; if it is not, then we are going to go to the server *)
nextTraversal[Verbatim[Traversal][field_Symbol], date_, packet_Association]:=Module[
	{type, fieldValue},

	type=objectToType[Lookup[packet, Object]];
	fieldValue=Lookup[
		packet,
		field,
		"Missing from explicit cache"
	];

	(* if the field is missing, then we're going to go to the server to get it *)
	(* note that if fieldValue explicitly is Missing["cache"] then that's actually ok and we are going to pass Nothing here *)
	(* note that if the field is All, then we're going to say that that is ok since it's not a real field anyway *)
	If[MatchQ[fieldValue, "Missing from explicit cache"] && Not[MatchQ[field, All]],
		(
			Sow[{Lookup[packet, Object], field}, "missing-cache-fields"];
			<|getObjectCacheKey[Lookup[packet, Object], date] -> <|"Fields" -> {Traversal[field]}|>|>
		),
		Nothing
	]

];


(* same as above except using the listably *)
nextTraversal[Verbatim[Traversal][fields:{___Symbol}], date_, packet_Association]:=Module[
	{fieldValues, mergedFields},

	fieldValues=Map[
		Lookup[packet, #, "Missing from explicit cache"]&,
		fields
	];

	(* if the field is missing, then we're going to go to the server to get it *)
	(* note that if fieldValue explicitly is Missing["cache"] then that's actually ok and we are going to pass Nothing here *)
	(* note that if the field is All, then we're going to say that that is ok since it's not a real field anyway *)
	mergedFields=Merge[
		MapThread[
			If[MatchQ[#1, "Missing from explicit cache"] && Not[MatchQ[#2, All]],
				(
					Sow[{Lookup[packet, Object], #2}, "missing-cache-fields"];
					<|getObjectCacheKey[Lookup[packet, Object], date] -> <|"Fields" -> {Traversal[#2]}|>|>
				),
				Nothing
			]&,
			{ToList[fieldValues], fields}
		],
		mergeFields
	];

	(* if we don't need to go to the server at all, return Nothing instead of the empty association *)
	If[MatchQ[mergedFields, <||>],
		Nothing,
		mergedFields
	]

];

(* same as above except using the packet wrapper *)
nextTraversal[Verbatim[Traversal][PacketTarget[field_Symbol]], date_, packet_Association]:=Module[
	{fieldValue},

	fieldValue=Lookup[
		packet,
		field,
		"Missing from explicit cache"
	];

	(* if the field is missing, then $Failed is going to be subbed in there, then we're going to go to the server to get it *)
	(* note that if fieldValue explicitly is Missing["cache"] then that's actually ok and we are going to pass Nothing here *)
	(* note that if the field is All, then we're going to say that that is ok since it's not a real field anyway *)
	If[MatchQ[fieldValue, "Missing from explicit cache"] && Not[MatchQ[field, All]],
		(
			Sow[{Lookup[packet, Object], field}, "missing-cache-fields"];
			<| getObjectCacheKey[Lookup[packet, Object], date] -> <|"Fields" -> {Traversal[field]}|>|>
		),
		Nothing
	]

];


(* same as above except using the packet wrapper listably *)
nextTraversal[Verbatim[Traversal][PacketTarget[fields:{___Symbol}]], date_, packet_Association]:=Module[
	{fieldValues, mergedFields},

	fieldValues=Map[
		Lookup[packet, #, "Missing from explicit cache"]&,
		fields
	];

	(* if the field is missing, then we're going to go to the server to get it *)
	(* note that if fieldValue explicitly is Missing["cache"] then that's actually ok and we are going to pass Nothing here *)
	(* note that if the field is All, then we're going to say that that is ok since it's not a real field anyway*)
	mergedFields=Merge[
		MapThread[
			If[MatchQ[#1, "Missing from explicit cache"] && Not[MatchQ[#2, All]],
				(
					Sow[{Lookup[packet, Object], #2}, "missing-cache-fields"];
					<|getObjectCacheKey[Lookup[packet, Object], date] -> <|"Fields" -> {Traversal[#2]}|>|>
				),
				Nothing
			]&,
			{ToList[fieldValues], fields}
		],
		mergeFields
	];

	(* if we don't need to go to the server at all, return Nothing instead of the empty association *)
	If[MatchQ[mergedFields, <||>],
		Nothing,
		mergedFields
	]

];

(* if we're doing a Query or Length call and the object is in the cache, we're just always going to not go to the database (mainly because steven doesn't fully understand how queries and/or Length calls work) *)
(* TODO the tricky thing here is that we still want the original behavior for when we have packets, but my change makes it so that we always go to the database for that too, which we don't want *)
nextTraversal[
	Verbatim[Traversal][
		Alternatives[
			Verbatim[Length][Except[_Repeated]],
			_Query
		]
	],
	date_,
	_Association
]:=Nothing;

nextTraversal[
	Verbatim[Traversal][Verbatim[Length][Verbatim[Repeated][field:_, rest:___]]],
	date_,
	packet:_Association
]:=With[
	{repeatedTraversal=Traversal[Repeated[Traversal[field], rest]]},
	nextTraversal[repeatedTraversal, date, packet]
];

(*Link taversal, check if field contains a link in the packet and go fetch the remaining values from the server.*)
nextTraversal[Verbatim[Traversal][field_Symbol, rest__], date_, packet_Association]:=Module[
	{fieldValue},

	fieldValue=removeNullsFromLinks[Lookup[
		packet,
		field,
		$Failed
	]];

	(* If field contains a link, then go to server to get the rest of the values in the traversal*)
	(* if the field is missing from the cache, go to the server for all those values *)
	(* note that if fieldValue explicitly is Missing["cache"] then that's actually ok and we are going to pass Nothing here *)
	(* if we ended up here where rest is weirdly the Rest symbol (passed in the Repeated syntax) then jump straight to Nothing*)
	Which[
		MatchQ[fieldValue, ListableP[LinkP[IncludeTemporalLinks -> True]]],
		Merge[
			Map[(* If it's a temporal link, we're grabbing the date off of it for the next traversal *)
				<|{linkToObject[#], If[linkHasDateQ[#], getLinkDate[#], date]} -> <|"Fields" -> {Traversal[rest]}|>|>&,
				ToList[fieldValue]
			],
			mergeFields
		],
		MatchQ[ToList[rest], {Verbatim[Rest]}], Nothing,
		MatchQ[fieldValue, $Failed],
		(
			Sow[{Lookup[packet, Object], field}, "missing-cache-fields"];
			<|{Lookup[packet, Object], date} -> <|"Fields" -> {Traversal[field, rest]}|>|>
		),
		True, Nothing
	]
];

(*Link taversal of an indexed multiple field at the root, check if field contains a link in the packet
and go fetch the remaining values from the server.*)
nextTraversal[
	Verbatim[Traversal][
		query:_Query,
		rest__
	],
	date_,
	packet_Association
]:=With[
	{indexValues=removeNullsFromLinks[query[packet]]},

	(*If field contains a link, then go to server to get the rest of the values in the traversal*)
	If[MatchQ[indexValues, ListableP[LinkP[IncludeTemporalLinks -> True]]],
		Merge[
			Map[
				<|{linkToObject[#], If[linkHasDateQ[#], getLinkDate[#], date]} -> <|"Fields" -> {Traversal[rest]}|>|>&,
				ToList[indexValues]
			],
			mergeFields
		],
		Nothing
	]
];

nextTraversal[
	Verbatim[Traversal][repeated:Verbatim[Repeated][
		Verbatim[Traversal][
			query:_Query | _Symbol,
			repeatedRemainder___
		],
		___],
		rest___],
	date_,
	packet_Association
]:=Module[
	{fieldRule, newRepeated, newFields},

	(* TODO: why does this require the Rest head? *)
	(* TODO update: it _seems_ like we want this to get properly sent to the right nextTraversal overload which is used for other stuff.  Not really sure I understand why but note that there I'm accounting for the case where we're passing Rest*)
	fieldRule=nextTraversal[Traversal[query, Rest], date , packet];

	newRepeated=decrementRepeated[repeated];
	newFields=<|"Fields" -> {Traversal[
		Traversal[repeatedRemainder],
		Evaluate[newRepeated],
		rest
	], Traversal[repeatedRemainder, rest]}|>;

	If[fieldRule === Nothing,
		Nothing,
		Map[newFields &, fieldRule]
	]
];

(* ::Subsubsection:: *)
(*addCASTokens*)

(* Adds the "CAS" token to the request association if we have all of the fields for the type in the cache. *)
(* If we do not have all of the fields of the type in the cache, we will add "" as the CAS token which will *)
(* guarantee that we fetch all of the fields from the server again. *)
addCASTokens[objectFieldRequests_Association, cache_Association]:=Association[
	KeyValueMap[
		addTokenIfAllFields[#1, #2, cache]&,
		objectFieldRequests
	]
];

addTokenIfAllFields[{object:objectP | modelP, date:optionalDateP}, request_Association, cache_Association]:=Module[
	{cacheValue, cacheFields, cacheCAS, type},

	type=objectToType[object];
	cacheValue=Lookup[cache, Key[getObjectCacheKey[object]], <||>];
	cacheCAS=Lookup[cacheValue, "CAS", ""];
	cacheFields=Lookup[cacheValue, "Fields", {}][[All, 1]];
	If[ContainsAll[cacheFields, typeSymbols[type]],
		getObjectCacheKey[object, date] -> Append[request, "CAS" -> cacheCAS],
		getObjectCacheKey[object, date] -> Append[request, "CAS" -> ""]
	]
];

(* ::Subsubsection:: *)
(*filterCachedFields*)

(*Takes an association of objects to field request associations with the key "Fields" that is a list of FieldParts requested.*)
Authors[filterCachedFieldsWithDate]:={"platform"};

(* NOTE: We will have just fetched the CAS tokens from the server at this point and added them to the objectFieldRequests *)
(* association, so we should check that CAS against the CAS in the cache to see if we can rely on the cache value that we have. *)
filterCachedFieldsWithDate[objectFieldRequests_Association, cache_Association]:=
	<|KeyValueMap[
		removeCachedFields[First[#1], Last[#1], #2, cache]&,
		objectFieldRequests
	]|>;

filterCachedFieldsWithDate[cache_Association]:=Function[{objectFieldRequests},
	filterCachedFieldsWithDate[objectFieldRequests, cache]
];

(*For a single object field request and cache entry, remove any fields in the cache*)
removeCachedFields[object:objectP | modelP, date_, request_Association, cache_Association]:=Module[
	{requestedCAS, cachedFields, cacheEntry, cachedCAS, nonCachedFields,
		nonLengthFields, lengthFields, nonCachedSummaries, cacheKey},

	cacheKey=getObjectCacheKey[object, date];
	(*If object does not exist in cache, return request*)
	cacheEntry=Lookup[
		cache,
		Key[cacheKey]
	];
	If[MissingQ[cacheEntry],
		Return[getObjectCacheKey[object, date] -> request]
	];

	(*If the check-and-set tokens are not the same, return all fields*)
	cachedCAS=Lookup[cacheEntry, "CAS"];
	requestedCAS=Lookup[request, "CAS"];

	If[Not[SameQ[cachedCAS, requestedCAS]],
		Return[getObjectCacheKey[object, date] -> request]
	];

	(*Lookup cached fields for this object*)
	cachedFields=Lookup[
		cacheEntry,
		"Fields",
		<||>
	];

	(*Lookup cached summaries for this object*)
	cachedSummaries=Lookup[
		cacheEntry,
		"FieldSummaries",
		<||>
	];

	requestedLimit=Lookup[request, "Limit", None];

	(*Separate field requests for Length from all other field requests for values.
	Length requests must check the FieldSummaries collection in the cache.*)
	lengthFields=Cases[
		Lookup[request, "Fields"],
		HoldPattern[Traversal[Verbatim[Length][_]]],
		{1}
	];

	nonLengthFields=Complement[
		Lookup[request, "Fields"],
		lengthFields
	];

	(*Filter out any fields already in the cache and reconstruct the request*)
	nonCachedFields=Map[
		selectDirtyFields[#, requestedLimit, cachedFields, cachedSummaries]&,
		nonLengthFields
	];

	(*Filter out any field length requests not already cached as summaries*)
	nonCachedSummaries=Select[
		lengthFields,
		Not[KeyExistsQ[cachedSummaries, cacheableSymbols[#]]]&
	];

	If[Length[nonCachedFields] > 0 || Length[nonCachedSummaries] > 0,
		Rule[
			getObjectCacheKey[object, date],
			Association[
				"Fields" -> Join[nonCachedFields, nonCachedSummaries],
				"CAS" -> requestedCAS,
				"Limit" -> requestedLimit
			]
		],
		Nothing
	]
];

(* selectDirtyFields filters out any fields already in the cache and reconstructs the request *)

(* traversal of packet target *)
selectDirtyFields[
	Verbatim[Traversal][PacketTarget[fields:_List]],
	limit:_Integer | None,
	cachedFields_Association,
	cachedSummaries_Association
]:=With[
	{
		dirtyFields=Map[First,
			Map[selectDirtyFields[Traversal[#], limit, cachedFields, cachedSummaries]&, fields]
		]
	},

	If[dirtyFields === {},
		Nothing,
		Traversal[PacketTarget[dirtyFields]]
	]
];

(* traversal of list *)
selectDirtyFields[
	Verbatim[Traversal][fields:_List],
	limit:_Integer | None,
	cachedFields_Association,
	cachedSummaries_Association
]:=With[
	{
		dirtyFields=Map[First,
			Map[selectDirtyFields[Traversal[#], limit, cachedFields, cachedSummaries]&, fields]
		]
	},

	If[dirtyFields === {},
		Nothing,
		Traversal[dirtyFields]
	]
];

(* traversal of _ *)
selectDirtyFields[field_Traversal, limit:_Integer | None, cachedFields_Association, cachedSummaries_Association]:=Module[
	{root, cachedField, cachedSummary, summaryCount, isRuleDelayedField, rawCachedField, cacheLimit, requestLimit},

	(* For traversals which are just a Part of the field, chop off the Part for looking up the field in the cache *)
	root=rootField[field];
	cachedField=Lookup[cachedFields, root];
	cachedSummary=Lookup[cachedSummaries, Key[First[root]]];

	summaryCount=cachedSummaries[[Key[First[root]], "Count"]];

	(* Cache is dirty if field is not in the cache AND if there is no field summary with Count == 0 (no value). *)
	If[MissingQ[cachedField],
		If[summaryCount === 0,
			Return[Nothing],
			Return[field]
		]
	];

	isRuleDelayedField=Head[Lookup[cachedField, "Rule"]] === RuleDelayed;

	(* computable fields *)
	If[MissingQ[cachedSummary] && isRuleDelayedField,
		Return[Nothing]
	];

	rawCachedField=Lookup[cachedField, "Limit", 0];

	(* lazy download needed after summary-only fetching *)
	(* limit:None indicates that the data is already there, but it's not *)
	If[rawCachedField === None && isRuleDelayedField,
		Return[field]
	];

	(*Convert None values to Infinity for >= comparison*)
	cacheLimit=Replace[rawCachedField, None -> Infinity, {0}];
	requestLimit=Replace[limit, None -> Infinity, {0}];

	(*Cache is dirty if cached PaginationLimit is less than what is requested*)
	If[cacheLimit < requestLimit,
		field,
		Nothing
	]
];

(*For traversals which are just Parts (such as Contents, All, 2) we just need to check if
Contents is in the cache. Need to make sure that All is not the last element as that means
we DO have to go to the server to get the packet on the other side of the link*)
rootField[Verbatim[Traversal][Query[Key[field:_Symbol], __]]]:=Traversal[field];
rootField[trav_Traversal]:=trav;

(* ::Subsubsection:: *)
(*getCacheValue*)

cacheKeyExistsQ[object_, date_, cache_Association]:=With[
	{
		key=getObjectCacheKey[cacheObjectID[object], date]
	},
	KeyExistsQ[cache, key]
];

(*Looks up specific fields for a Download input in the cache.*)
Authors[getCacheValue]:={"platform"};

(*Null/$Failed cases are mostly no-ops*)
getCacheValue[Null, date:optionalDateP, _Association]:=Null;
getCacheValue[$Failed, date:optionalDateP, _Association]:=$Failed;
getCacheValue[Null, date:optionalDateP, _Traversal | {___Traversal}, _Association]:=Null;
getCacheValue[$Failed, date:optionalDateP, _Traversal, _Association]:=$Failed;
getCacheValue[_, date:optionalDateP, _Missing, _]:=$Failed;
getCacheValue[$Failed, date:optionalDateP, parts:{___Traversal}, _Association]:=Table[
	$Failed,
	Length[parts]
];
getCacheValue[$Failed, date:optionalDateP, Verbatim[Traversal][PacketTarget[field_Symbol]], _Association]:=AssociationMap[
	$Failed&,
	{field, Object, Type, ID}
];
getCacheValue[$Failed, date:optionalDateP, Verbatim[Traversal][PacketTarget[fields:{___Symbol}]], _Association]:=AssociationMap[
	$Failed&,
	Union[fields, {Object, Type, ID}]
];

(*For fields which are not links, return up the tree to the top level.*)
getCacheValue[val_InvalidLinkField, traversal_Traversal, cache_Association]:=getCacheValue[val, Null, traversal, cache];

(*Given a packet and no fields, just return the packet*)
getCacheValue[packet_Association, cache_Association]:=getCacheValue[packet, Null, cache];

(*For fields which are not links, return up the tree to the top level.*)
getCacheValue[val_InvalidLinkField, date:optionalDateP, _Traversal, _Association]:=val;

(*Given a packet and no fields, just return the packet*)
getCacheValue[packet_Association, date:optionalDateP, _Association]:=packet;

(*Given a packet, just look up the fields in the packet and ignore the date *)
getCacheValue[packet_Association, date:optionalDateP, part_Traversal, cache_Association]:=First[
	getCacheValue[packet, date, {part}, cache]
];

getCacheValue[packet_Association, date:optionalDateP, parts:{___Traversal}, cache_Association]:=Module[
	{object, type, id, cachePacket, newCache, results, downloadDate},
	(* packet will be stored in the cache under the key:
		1) it's object if that is available.
		2) Object[type, "id:packetplaceholder"] if the type is available.
		3) Object[NoType, "id:packetplaceholder"] if the type and object and unavailable

		The placeholder works as long as there is only one packet in the cache.
	*)
	object=Lookup[packet, Object];
	If[MissingQ[object],
		(
			id=Lookup[packet, ID, "id:packetplaceholder"];
			type=Lookup[packet, Type, Object[NoType]];
			object=Append[type, id]
		),
		(
			type=objectToType[object];
			object=cacheObjectID[object];
			id=objectToId[object];
		)
	];
	(*
		If a date is specified add it into the provided packet.
		This is because the packet reflects the object we want to look up and the specified time (if any).
		So ignore any DownloadDate inside the packet
	*)
	cachePacket=<|
		AssociationMap[Missing["packet", #]&, Fields[type, Output -> Short]],
		Object -> object,
		Type -> type,
		ID -> id,
		If[MatchQ[date, _DateObject], "date" -> DateObjectToRFC3339[date], Nothing],
		"CAS" -> "packet",
		packet
	|>;

	newCache=newCacheAssociation[
		cachePacket,
		<||>,
		cache,
		"Packet"
	];

	results=Map[
		If[MatchQ[#, Traversal[All]],
			packet,
			getCacheValue[object, date, #, newCache]
		]&,
		parts
	];

	Map[
		Replace[#,
			{
				(Object | Model)[__, "id:packetplaceholder"] -> $Failed,
				Missing["packet", field:_Symbol] :> (
					Sow[<|"field" -> field, "object" -> object|>, "missing-field"];
					$Failed
				)
			},
			{0, 1}
		]&,
		results
	]
];

(* Object List case *)
(* TODO: do i need this? Maybe I can remove and have the client code handle the mapping? *)
getCacheValue[items:{(objectP | modelP | linkP | _Association | Null)...}, date:optionalDateP, parts:_Traversal | {___Traversal}, cache_Association]:=
	Map[getCacheValue[#, date, parts, cache]&, items];

(*Given an object or link with no fields, assume all fields in the type*)
getCacheValue[link:linkP, date:optionalDateP, cache_Association]:=With[
	{
		objectRef=linkToObject[link],
		(* If there is no date, prioritize the date that was passed in *)
		linkDate=If[MatchQ[getLinkDate[link], Null], date, getLinkDate[link]]
	},
	getCacheValue[
		objectRef,
		linkDate,
		cache
	]
];

(* get the cache value for a whole object *)
getCacheValue[object:objectP | modelP, date:optionalDateP, cache_Association]:=With[
	{
		convertedObject=cacheObjectID[object],
		fields=Keys[objectToType[object]],
		key=getObjectCacheKey[cacheObjectID[object], date]
	},
	If[KeyExistsQ[cache, key],
		(*lookupCacheValue returns a rule with Traversal[field] -> value
		so remove Traversal from all the keys*)
		KeyMap[
			First,
			Association[
				Map[
					lookupCacheValue[convertedObject, date, Traversal[#], cache]&,
					fields
				],
				(*Add a DownloadDate to represent a temporal download*)
				If[!MatchQ[date, _DateObject], Nothing, Traversal[DownloadDate] -> date]
			]
		],
		$Failed
	]
];

(* get the cache value for a whole object when using All (i.e., actually throw the missing-cache-errors here but not if getting a whole object) *)
getCacheValue[object:objectP | modelP, date:optionalDateP, cache_Association, All]:=With[
	{
		convertedObject=cacheObjectID[object],
		fields=Keys[objectToType[object]],
		key=getObjectCacheKey[cacheObjectID[object], date]
	},

	If[KeyExistsQ[cache, key],
		(*lookupCacheValue returns a rule with Traversal[field] -> value
		so remove Traversal from all the keys*)
		KeyMap[
			First,
			Association[
				Map[
					lookupCacheValue[convertedObject, date, Traversal[#], cache, All]&,
					fields
				]
			]
		],
		$Failed
	]
];

(*Given a link, extract the object and pass it along to the object overload*)
getCacheValue[link:linkP, date:optionalDateP, parts:_Traversal | {___Traversal}, cache_Association]:=With[
	{
		objectRef=linkToObject[link],
		(* This returns null if there is not a temporal link! But doens't mean there's no date. Look at what date was provided if null*)
		linkDate=If[MatchQ[getLinkDate[link], Null], date, getLinkDate[link]]
	},
	getCacheValue[
		objectRef,
		linkDate,
		parts,
		cache
	]
];

(*Given an object, lookup the values for the fields in the provided cache*)
getCacheValue[object:objectP | modelP, date:optionalDateP, part_Traversal, cache_Association]:=First[
	getCacheValue[object, date, {part}, cache]
];

getCacheValue[object:objectP | modelP, date:optionalDateP, parts:{___Traversal}, cache_Association]:=With[
	{
		(*Convert named objects to fully qualified IDs if possible.*)
		convertedObject=cacheObjectID[object]
	},

	(*Lookup the Rule from each field in the cache (or return a rule with a default value for that field)*)
	Map[
		lookupCacheValue[convertedObject, date, #, cache][[2]]&,
		parts
	]
];

(*Catch-all attempting to fetch a field from anything else should return $Failed*)
getCacheValue[_, _, _Traversal, _Association]:=$Failed;

(* Stopping condition for recursion limit *)
lookupRepeated[
	object:objectP | modelP,
	date:optionalDateP,
	Verbatim[Repeated][field:_Traversal, 1, _String | PatternSequence[], tag:_String],
	cache:_Association
]:=Module[
	{currentValue},
	If[MemberQ[$VisitedObjects, object],
		Sow[True, "cycle-detected"];
		Return[{}]
	];
	currentValue=lookupCacheValue[object, date, field, cache][[2]];

	currentValue=Switch[currentValue,
		{linkP...},
		Select[currentValue, Composition[MemberQ[tag], cacheTags[#, date]&]],

		linkP,
		If[MemberQ[cacheTags[currentValue, date], tag], currentValue, Nothing],

		Null,
		{},

		_,
		currentValue
	];

	ToList[currentValue]
];

(* Stopping condition for failed lookup *)
lookupRepeated[
	$Failed,
	_,
	_Repeated,
	_Association
]:={};

(* Recursively fetch up to `repetitions` links from the cache, until a Null link is encountered *)
lookupRepeated[
	object:objectP | modelP,
	date:optionalDateP,
	repeated:Verbatim[Repeated][field_Traversal, ___, tag_String],
	cache_Association
]:=Module[
	{currentValue, nextRepeated, nextVisited},
	If[MemberQ[$VisitedObjects, object],
		Sow[True, "cycle-detected"];
		Return[{}]
	];
	nextVisited=If[ListQ[$VisitedObjects],
		Append[$VisitedObjects, object],
		{object}
	];
	nextRepeated=decrementRepeated[repeated];
	currentValue=lookupCacheValue[object, date, field, cache][[2]];
	(* Filter terms for which our search terms are not true *)
	currentValue=Switch[currentValue,
		{linkP...},
		Select[currentValue, Composition[MemberQ[tag], cacheTags[#, date] &]],

		linkP,
		If[MemberQ[cacheTags[currentValue, date], tag], currentValue, Nothing],

		_,
		currentValue
	];
	Block[{$VisitedObjects=nextVisited},
		Switch[currentValue,
			{linkP...},
			Map[{#, lookupRepeated[#, date, nextRepeated, cache]}&, currentValue],

			linkP | Nothing,
			Prepend[
				ReplaceAll[
					lookupRepeated[currentValue, date, nextRepeated, cache],
					$Failed -> {}
				],
				currentValue
			],

			$Failed,
			$Failed,

			Null,
			{},

			_, (* Not a link termination *)
			With[{notLink=First[field]},
				InvalidLinkField[Defer[notLink]]
			]
		]
	]
];

(* dates on temporal links override provided date*)
lookupRepeated[
	link:linkP,
	date:optionalDateP,
	repeated_Repeated,
	cache_Association
]:=With[
	{
		overridingDate=If[linkHasDateQ[link], getLinkDate[link], date]
	},
	lookupRepeated[linkToObject[link], overridingDate, repeated, cache]
];

(* Stopping condition for dead link *)
lookupRepeated[
	Except[objectP | modelP],
	_,
	_Repeated,
	_Association
]:={};

(* Catchall for invalid fields *)
lookupRepeated[___]:=$Failed;

decrementRepeated[Verbatim[Repeated][_Traversal, 1, ___]]:=Sequence[];

decrementRepeated[Verbatim[Repeated][field:_Traversal, repetitions:_Integer, rest:___]]:=Repeated[field, repetitions - 1, rest];

decrementRepeated[repeated:Verbatim[Repeated][_Traversal, Infinity | PatternSequence[], ___]]:=repeated;

(*Get the response tags for an object in the cache*)
cacheTags[link:linkP]:=cacheTags[linkToObject[link]];
cacheTags[object:objectP | modelP]:=Lookup[
	Lookup[objectCache, object, <||>],
	"Tags",
	{}
];

(* date in the link overrides provided date *)
cacheTags[link:linkP, date:optionalDateP]:=With[
	{
		overridingDate=If[linkHasDateQ[link], getLinkDate[link], date]
	},
	cacheTags[linkToObject[link], overridingDate]
];

cacheTags[object:objectP | modelP, date:optionalDateP]:=With[
	{key=getObjectCacheKey[object, date]},
	Lookup[
		Lookup[objectCache, Key[key], <||>],
		"Tags",
		{}
	]
];

(*Don't care if only downloading from 1 field*)
linkFieldQ[object:objectP | modelP, Verbatim[Traversal][field:_]]:=True;
(*Downloading the Length field is not a real traversal*)
linkFieldQ[object:objectP | modelP, Verbatim[Traversal][Verbatim[Length][_]]]:=True;
linkFieldQ[object:objectP | modelP, Verbatim[Traversal][Verbatim[Length][_], __]]:=False;
(*Downloading through links with specific columns (indexed multiple)*)

linkFieldQ[
	object:objectP | modelP,
	Verbatim[Traversal][Query[Key[field_Symbol], rows:indexP], __]
]:=Module[
	{definition, format, class, subField},

	definition=Quiet[LookupTypeDefinition[objectToType[object][field]]];

	{format, class}=Lookup[definition, {Format, Class}];

	subField=Quiet[Check[
		Which[
			format === Single && MatchQ[class, {_Rule ..}], (* Named Single Field *)
			Lookup[class, rows],

			format === Single && MatchQ[class, Except[{_Rule ..}, _List]],
			class[[rows]],

			format === Multiple,
			class
		],
		$Failed
	]];

	MatchQ[subField, Link | TemporalLink];
];

linkFieldQ[
	object:objectP | modelP,
	Verbatim[Traversal][Query[Key[field_Symbol], indexP, cols:indexP], __]
]:=Module[
	{definition, classes, fields},

	definition=Quiet[LookupTypeDefinition[objectToType[object][field]]];
	classes=Quiet[Check[Lookup[definition, Class], $Failed]];

	fields=Quiet[Check[
		If[MatchQ[cols, _Key],
			Lookup[classes, cols],
			classes[[cols]]
		],
		$Failed
	]];

	MatchQ[fields, ListableP[Link | TemporalLink]]
];

(*Downloading through links (non-indexed)*)
linkFieldQ[object:objectP | modelP, Verbatim[Traversal][field_Symbol, __]]:=With[
	{
		definition=Quiet[LookupTypeDefinition[objectToType[object][field]]]
	},

	And[
		MatchQ[definition, _List],
		MatchQ[Lookup[definition, Class], Link | TemporalLink]
	]
];

(*Catch-All returns false*)
linkFieldQ[_, _Traversal]:=False;

getObjectCacheKey[object:objectP | modelP, date:optionalDateP]:=Module[{},
	ret:={object, None};
	If[DateObjectQ[date] && !timeIgnored, ret={object, standardizeDateObj[date]}];
	ret
];

getObjectCacheKey[object:objectP | modelP]:=getObjectCacheKey[object, None];

getDateFromObjectCacheKey[key:objectCacheKeyP]:=If[MatchQ[key, _List], Last[key], None];


lookupCacheValue[$Failed, date:optionalDateP, field:_Traversal, ___]:=field -> $Failed;
lookupCacheValue[Null, date:optionalDateP, field:_Traversal, ___]:=field -> $Failed;
lookupCacheValue[_, date:optionalDateP, field:_Traversal?(MemberQ[#, _InvalidPart, Infinity]&), ___]:=field -> $Failed;

(* Ignore All/Length for link checking as these are handled elsewhere *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	traversal:Verbatim[Traversal][field:_Symbol | _Query | Verbatim[Length][_], ___],
	_Association
]:=Condition[
	traversal -> InvalidLinkField[Defer[field]],
	!linkFieldQ[object, traversal]
];

(* Single Repeated Field *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][repeated:_Repeated],
	cache_Association
]:=Module[
	{value, cycles},

	{value, cycles}=Reap[
		lookupRepeated[object, date, repeated, cache],
		"cycle-detected"
	];

	If[Length[cycles] > 0,
		Sow[{object, part}, "cycle"]
	];

	part -> value
];

(* Repeated Field with subsequent fields. *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][repeated:_Repeated, rest__],
	cache_Association
]:=Module[
	{recursiveValues, cycles, restValues},

	{recursiveValues, cycles}=Reap[
		lookupRepeated[object, date, repeated, cache],
		"cycle-detected"
	];

	If[Length[cycles] > 0,
		Sow[{object, part}, "cycle"]
	];

	recursiveValues=Switch[recursiveValues,
		$Failed,
		Return[part -> $Failed],

		Null,
		{},

		_,
		recursiveValues
	];

	(*TODO: is date really mapped like this?*)
	restValues=AssociationMap[
		Values[lookupCacheValue[linkToObject[#], date, Traversal[rest], cache]] &,
		Cases[DeleteDuplicates[Flatten[recursiveValues]], linkP]
	];

	Rule[
		part,
		recursiveValues /. restValues
	]
];

(* When provided the field Length, download the count of that field.*)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][Verbatim[Length][lengthTraversal:Except[_Repeated]]],
	cache_Association
]:=Module[
	{length, type, field, value, key},
	field=First[Traversal[lengthTraversal]];
	key=getObjectCacheKey[object, date];

	If[!KeyExistsQ[cache, key],
		Return[part -> $Failed]
	];

	type=objectToType[object];

	If[(type =!= Object[NoType]) && Not[MultipleFieldQ[type[field]]],
		(
			Sow[{object, field}, "length-error"];
			Return[part -> $Failed]
		)
	];

	(* packets do not require a well defined type *)
	If[(Last[object] =!= "id:packetplaceholder") && !FieldQ[type[field]],
		Sow[{object, field}, "doesnt-exist"];
		Return[part -> $Failed]
	];

	If[$DebugDownload,
		sowDebugData[object, date, field, cache]
	];

	length=cache[[Key[key], "FieldSummaries", Key[field], "Count"]];

	If[!MissingQ[length],
		Return[part -> length]
	];

	value=cache[[Key[key], "Fields", Key[Traversal[Evaluate[field]]], "Rule", -1]];

	If[!MissingQ[value],
		Return[part -> Length[value]]
	];

	Sow[<|"field" -> field, "object" -> object|>, "missing-field"];
	part -> $Failed
];

(* for length of a repeated field, download the elements of that field then count the length of the repeated elements *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][Verbatim[Length][repeated:_Repeated]],
	cache:_Association
]:=Module[{repeatedTraversal, result},

	repeatedTraversal=MapAt[Traversal, repeated, 1];

	(* TODO: does date really get traversed as well? *)
	result=Last[
		lookupCacheValue[object, date, Traversal[Evaluate[repeatedTraversal]], cache]
	];

	If[FailureQ[result] || MatchQ[result, _InvalidLinkField],
		part -> result,
		part -> Length[result]
	]
];

(* Field of more than 1 level, recursively fetch the values from the cache *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][first_, rest__],
	cache_Association
]:=With[
	{firstLevel=lookupCacheValue[object, date, Traversal[first], cache][[2]]},
	part -> getCacheValue[firstLevel, date, Traversal[rest], cache]
];

(* When provided the field All, download every field for the given object. *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	Verbatim[Traversal][All],
	cache_Association
]:=Rule[
	Traversal[All],
	getCacheValue[object, date, cache, All]
];

lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][fields:{___Symbol}],
	cache_Association
]:=
	part -> Values[Map[lookupCacheValue[object, date, Traversal[#], cache] &, fields]];

lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][field_Symbol],
	cache_Association
]:=Module[{cacheValue, type, result, objectOrMissing, key, fieldClass},
	key=getObjectCacheKey[object, date];
	cacheValue=Part[cache, Key[key], Key["Fields"], Key[part]];
	type=objectToType[object];
	(* If object is not in the cache,
		look up the field value from the locally Computable fields (Object/Type/ID)
		or return $Failed. *)
	If[!KeyExistsQ[cache, key],
		Return[
			Lookup[
				Lookup[
					localFields[object],
					part,
					<|"Rule" -> Rule[part, $Failed]|>
				],
				"Rule"
			]
		]
	];

	objectOrMissing=Replace[
		object,
		Object[NoType, _] | Object[___, "id:packetplaceholder"] -> Missing[Object]
	];

	(* packets do not require a well defined type *)
	If[(Last[object] =!= "id:packetplaceholder") && !FieldQ[type[field]],
		Sow[{objectOrMissing, field}, "doesnt-exist"];
		Return[part -> $Failed]
	];

	result=If[MissingQ[cacheValue],
		part -> Quiet[defaultValue[type, field], DefineObjectType::NoTypeDefError],
		cacheValue[["Rule"]]
	];

	If[$DebugDownload,
		sowDebugData[objectOrMissing, date, field, cache]
	];

	fieldClass=Quiet[Lookup[LookupTypeDefinition[type, field], Class]];

	(* If it's from an external file, download it and put that into the result without putting the whole data in the cache *)
	(*TODO: maybe the same logic should apply to BigCompressedFields?*)
	result=Switch[fieldClass,
		BigQuantityArray, First[result] -> downloadBigQAArray[Last[result]],
		_, result
	];

	(*Return the default value for the field if the field does not exist in the cache (or $Failed in certain contexts).*)
	Switch[result,
		_ -> $Failed,
		(
			Sow[<|"object" -> objectOrMissing, "field" -> field|>, "missing-field"];
			part -> $Failed
		),
		_ -> BigQuantityArrayByteLimit,
		(
			Sow[<|"object" -> objectOrMissing, "field" -> field|>, "too-big"];
			part -> $Failed
		),
		_ -> Missing["cache"],
		part -> $Failed,
		_,
		MapAt[Traversal, result, {1}]
	]
];

(* look up the cache value for the case where we are Downloading All, which has some special cases  *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][field_Symbol],
	cache_Association,
	All
]:=Module[{cacheValue, type, result, objectOrMissing, key},
	key=getObjectCacheKey[object, date];
	cacheValue=Part[cache, Key[key], Key["Fields"], Key[part]];
	type=objectToType[object];

	(* If object is not in the cache,
		look up the field value from the locally Computable fields (Object/Type/ID)
		or return $Failed. *)
	If[!KeyExistsQ[cache, key],
		Return[
			Lookup[
				Lookup[
					localFields[object],
					part,
					<|"Rule" -> Rule[part, $Failed]|>
				],
				"Rule"
			]
		]
	];

	objectOrMissing=Replace[
		object,
		Object[NoType, _] | Object[___, "id:packetplaceholder"] -> Missing[Object]
	];

	(* packets do not require a well defined type *)
	If[(Last[object] =!= "id:packetplaceholder") && !FieldQ[type[field]],
		Sow[{objectOrMissing, field}, "doesnt-exist"];
		Return[part -> $Failed]
	];

	result=If[MissingQ[cacheValue],
		part -> Missing["cache"],
		cacheValue[["Rule"]]
	];

	If[$DebugDownload,
		sowDebugData[objectOrMissing, date, field, cache]
	];

	(*Return the default value for the field if the field does not exist in the cache *)
	(* note that this is different behavior in the All case vs other cases (others we want $Failed in there) *)
	(* note that if the object doesn't actually exist but we did pass cache, it's going to get confused and sow missing-field.  To get around this, we remove it from that after we Reap later; I know it's crazy but this whole function is crazy so sorry not sorry *)
	Switch[result,
		_ -> $Failed,
		(
			Sow[<|"object" -> objectOrMissing, "field" -> field|>, "missing-field"];
			part -> $Failed
		),
		(* NOTE that here I am using the default value.  This is because if we got this far and the thing still isn't in the cache, it's because the server side of Download just doesn't return something to be cached if the value is Null (or something like that?) *)
		_ -> Missing["cache"], part -> defaultValue[type, field],
		_, MapAt[Traversal, result, {1}]
	]
];

(* If an index is specified in the Field,
	return all values at the given index if possible.
	Return failed if value in field cannot be parted as expected. *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][Query[Key[field_Symbol], index:(indexP ..)]],
	cache_Association
]:=Module[
	{cacheValue, type, badParts, badPosition, result, key},
	key=getObjectCacheKey[object, date];
	(*If object is not in the cache, return $Failed*)
	If[!KeyExistsQ[cache, key],
		Return[part -> $Failed]
	];

	type=objectToType[object];

	(* packets do not require a well defined type *)
	If[(Last[object] =!= "id:packetplaceholder") && !FieldQ[type[field]],
		Sow[{object, field}, "doesnt-exist"];
		Return[part -> $Failed]
	];

	If[$DebugDownload,
		sowDebugData[object, date, field, cache]
	];

	cacheValue=Part[
		cache,
		Key[key],
		Key["Fields"],
		Key[Traversal[field]],
		"Rule",
		2
	];

	cacheValue=Switch[cacheValue,
		Missing["packet", _], (* Do not use default values for packets *)
		(
			Sow[<|"field" -> field, "object" -> object|>, "missing-field"];
			Return[part -> $Failed]
		),

		_Missing,
		defaultValue[type, field],

		_,
		cacheValue
	];

	(* bad parts are of the form _Missing, <|_ -> _Missing|> or {<|_ -> _Missing|>} *)
	result=If[MatchQ[cacheValue, Missing["packet", _]],
		cacheValue,
		Quiet[
			Check[
				Part[cacheValue, index],
				Missing["bad-part", {index}]
			]
		]
	];

	(* find the position requested parts that are not available *)
	badPosition=Position[result, _Missing, {0, Infinity}];

	(* Reconstruct the part syntax to message with *)
	badParts=Switch[badPosition,
		{{}}, (* entire value is missing *)
		StringRiffle[Map[ToString, Replace[{index}, Key[badKey:_] -> badKey, {0, Infinity}]], ", "],

		{{_Key} ..}, (* some of [[{A, B, ...}]] are missing *)
		ToString[badPosition[[All, 1, 1]]],

		{{_Integer, _Key} ..}, (* some of [[?, {A, B, ...}]] are missing *)
		ToString[First[{index}]]<>", "<>ToString[badPosition[[All, 2, 1]]],

		_,
		""
	];

	If[badParts =!= "",
		Sow[
			<|
				"part" -> "[["<>badParts<>"]]",
				"field" -> field,
				"object" -> object
			|>,
			"part-error"
		]
	];

	part -> Replace[result, _Missing -> $Failed, {0, 2}]
];

(* Field of more than 1 level, recursively fetch the values from the cache *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][query:_Query, rest__],
	cache_Association
]:=With[
	{firstLevel=lookupCacheValue[object, date, Traversal[query], cache][[2]]},

	part -> getCacheValue[firstLevel, date, Traversal[rest], cache]
];

(* Packet[All] provides an association with each field *)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][PacketTarget[All]],
	cache_Association
]:=Rule[
	part,
	Append[
		<|lookupCacheValue[object, date, Traversal[All], cache][[2]]|>,
		{If[!MatchQ[date, _DateObject], Nothing, DownloadDate -> date]}
	]
];

(* For a Traversal with a PacketTarget wrapper around one or more fields, lookup fields
plus Object, Type, & ID.*)
lookupCacheValue[
	object:objectP | modelP,
	date:optionalDateP,
	part:Verbatim[Traversal][PacketTarget[fields:_Symbol | {_Symbol ...}]],
	cache_Association
]:=Rule[
	part,
	Append[
		AssociationMap[
			lookupCacheValue[object, date, Traversal[#], cache][[2]]&,
			Join[ToList[fields], {Object, ID, Type}]
		],
		{If[!MatchQ[date, _DateObject], Nothing, DownloadDate -> date]}
	]
];

(* Given an empty field, return the provided objects *)
lookupCacheValue[object:objectP | modelP, part:Traversal[], _Association]:=part -> object;

(* Uncaught Traversal is an error*)
lookupCacheValue[_, date:optionalDateP, part_Traversal, _Association]:=part -> $Failed;


(*Given an object, return the values which can be computed locally.
Named objects cannot have their ID/Object keys computed locally.*)
localFields[object:ReferenceWithNameP]:=Set[
	localFields[object],
	Association[
		Traversal[Type] -> Association[
			"Rule" -> Rule[Traversal[Type], objectToType[object]]
		],
		Traversal[Object] -> Association[
			"Rule" -> Rule[Traversal[Object], $Failed]
		],
		Traversal[ID] -> Association[
			"Rule" -> Rule[Traversal[ID], $Failed]
		]
	]
];

localFields[object:objectP | modelP]:=Set[
	localFields[object],
	Association[
		Traversal[Type] -> Association[
			"Rule" -> Rule[Traversal[Type], objectToType[object]]
		],
		Traversal[Object] -> Association[
			"Rule" -> Rule[Traversal[Object], object]
		],
		Traversal[ID] -> Association[
			"Rule" -> Rule[Traversal[ID], Last[object]]
		]
	]
];


sowDebugData[object:objectP | modelP, date:optionalDateP, field:_Symbol, cache:_Association]:=Module[{},
	Sow[
		<|
			"object" -> object,
			"field" -> field,
			"source" -> resolveSource[field, cache[getObjectCacheKey[object, date]]]
		|>,
		"debugData"
	]
];

(** check where a symbol in the cache comes from **)
resolveSource[field:_Symbol, cachedObject:_Association]:=With[
	{
		downloadCount=cachedObject[["Fields", Key[Traversal[field]], "DownloadCount"]],
		session=Lookup[cachedObject, "Session", False]
	},

	Which[
		downloadCount === downloadCounter,
		"Server",

		session,
		"Session",

		MatchQ[downloadCount, _String],
		downloadCount,

		True,
		"Cache"
	]
];

resolveSource[_, downloadCount:_Missing]:="Server";

(* Authors definition for Constellation`Private`getObjectCacheKey *)
Authors[Constellation`Private`getObjectCacheKey]:={"scicomp", "brad"};
