(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*Search*)


(* ::Subsubsection:: *)
(*Patterns, Constants, and Flags*)


(* a global variable that allows overriding of DevObject behavior to ONLY
	return DeveloperObject->True objects from Search *)
$DeveloperSearch=False;

(* a global variable that adds StringContainsQ[Name, ___, IgnoreCase -> False] to all Search queries (unless a Name is already specified somehow, in which case it is ignored) *)
(* note that if $RequiredSearchName is Null, then no clause is appended; there is no way with this global variable to indicate that the Name field itself must be Null bc that would probably break everything *)
$RequiredSearchName = Null;

(* a global variable that adds (DateCreated <= $SearchMaxDateCreated || DateCreated == Null) to all Search queries (unless the DateCreated field is already specified, in which case it is ignored). *)
(* note that if $MaxSearchDateCreated is Null, then no clause is appended *)
$SearchMaxDateCreated = Null;

(* a simple pattern for trying to match a set of search clauses *)
clausesP=Except[_List | _Rule];

searchClauseP=KeyValuePattern[{
	(*Constellation type strings (Object.Data.Example)*)
	"Types" -> {___String},
	(*String query generated via searchClauseString*)
	"Query" -> _String
}];

searchQueryP=KeyValuePattern[{
	"Clauses" -> {searchClauseP...},
	"SoftLimit" -> _Integer,
	"SubTypes" -> True | False,
	"IgnoreTime" -> True | False,
	"Notebooks" -> Null | _List,
	"PublicObjects" -> True | False | {(True | False)...}
}];

emptySearchQuery=<|
	"Clauses" -> {<|
		"Types" -> {},
		"Query" -> ""
	|>},
	"SoftLimit" -> 0,
	"SubTypes" -> False,
	"IgnoreTime" -> False,
	"Notebooks" -> Null,
	"PublicObjects" -> True
|>;


(* ::Subsubsection:: *)
(*toSearchQuery*)

(* toSearchQuery -- converts a set of types and a set of search clauses to the correct JSON request for the constellation search endpoint. *)

(* This small function does a large amount of the work in translating MM style search clauses into the expected Constellation endpoint syntax. *)
(* See the function searchClauseString[...] in Client.m *)
expandClausesForTypes[clauses:clausesP, types:{typeP..}, includeSubtypes: (True | False)]:=Module[
	{typesToSearch},
	typesToSearch=If[includeSubtypes,
		Flatten[Map[Types, types]],
		types
	];

	Catch[Map[
		Function[type,
			Check[With[{query=searchClauseString[clauses, Type -> type]},
				<|
					"Types" -> typeToStringForSearch[type, False],
					"Query" -> If[query === None, "", query]
				|>
			],
				Throw[$Failed]
			]],
		typesToSearch
	]]
];

SetAttributes[expandClausesForTypes, HoldFirst];

typeToStringForSearch[type: typeP, includeSubtypes: (True | False)] := If[includeSubtypes,
		typeToString[#] & /@ Types[type],
		List[typeToString[type]]
	];

(* Helper function for toSearchQuery that expands our Search options to be index match with the list of types that we have. *)
expandOption[symbol_Symbol, value_, length_Integer]:=With[
	{
		newValue=If[ListQ[value],
			value,
			Table[value, length]
		]
	},

	If[Length[newValue] == length,
		newValue,
		(
			Message[Search::OptionLength, symbol, Length[newValue], length];
			$Failed
		)
	]
];

(* -- Empty Clauses -- *)
(* These overloads call the main non-empty clause overloads. *)


(* Authors definition for Constellation`Private`toSearchQuery *)
Authors[Constellation`Private`toSearchQuery]:={"xu.yi"};

toSearchQuery[type:typeP, opts:OptionsPattern[Search]]:=toSearchQuery[
	{type},
	None,
	opts
];

toSearchQuery[types:{typeP...}, opts:OptionsPattern[Search]]:=toSearchQuery[
	types,
	None,
	opts
];

toSearchQuery[typeGroups:{{typeP...}...}, opts:OptionsPattern[Search]]:=toSearchQuery[
	typeGroups,
	Evaluate[Table[None, Length[Unevaluated[typeGroups]]]],
	opts
];

(* -- Non-Empty Clauses -- *)
toSearchQuery[type:typeP, clauses:clausesP, opts:OptionsPattern[Search]]:=toSearchQuery[
	{type},
	clauses,
	opts
];

(* -- Empty Type -- *)
toSearchQuery[types:{}, clauses:clausesP, opts:OptionsPattern[Search]]:={};

(* -- List of types and clauses -- *)
toSearchQuery[types:{typeP..}, clauses:clausesP, opts:OptionsPattern[Search]]:=Module[
	{safeOps, maxResults, subTypes, missingTypes, requestClauses, date, ignoreTime, notebooks, publicObjects, notebooksString,uniqueRequestClauses},
	If[!loggedInQ[],
		Message[Search::NotLoggedIn];
		Return[$Failed]
	];
	safeOps=ECL`OptionsHandling`SafeOptions[Search, ToList[opts], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	maxResults=Lookup[safeOps, MaxResults];
	subTypes=Lookup[safeOps, SubTypes];
	date=Lookup[safeOps, Date];
	ignoreTime=Lookup[safeOps, IgnoreTime];
	notebooks=Lookup[safeOps, Notebooks];
	publicObjects=Lookup[safeOps, PublicObjects];

	If[And[Not[publicObjects], NullQ[notebooks]],
		Message[Warning::NotebooksIsNotSet];
	];

	(* If Notebooks and PublicObjects are both lists, then this is really multiple searches and we need to expand it out as such - it sucks we have to do it here, but the pattern matching with options is extremely complex *)
	If[ListQ[notebooks] && ListQ[publicObjects],
		(* note that the Evaluate call is required in order to make the Table call actually convert clauses into a list so that it matches the correct function pattern. *)
		Return[toSearchQuery[List /@ types, Evaluate[Table[Unevaluated[clauses], Length[Unevaluated[publicObjects]]]], opts]]];

	If[ListQ[maxResults],
		(
			Message[Search::OptionLength, MaxResults, Length[maxResults], 0];
			Return[$Failed]
		)
	];

	If[ListQ[subTypes],
		(
			Message[Search::OptionLength, SubTypes, Length[subTypes], 0];
			Return[$Failed]
		)
	];

	(* Find "types" not recognized by TypeQ. *)
	missingTypes=Select[types, !TypeQ[#]&];
	If[Length[missingTypes] > 0,
		Message[Search::MissingType, missingTypes];
		Return[$Failed]
	];

	(* Find top-level Alternatives expressions in the clauses: somebody missed parentheses. *)
	If[MatchQ[Unevaluated[clauses], _Alternatives],
		Message[Search::Alternatives];
		Return[$Failed]
	];


	(* Build the clauses portion of the request. *)
	requestClauses=Check[
		expandClausesForTypes[clauses, types, subTypes],
		$Failed
	];

	If[requestClauses === $Failed,
		(* a search error msg should be printed somewhere off in searchClauseString *)
		Return[$Failed]
	];
	
	uniqueRequestClauses = DeleteDuplicates[requestClauses];

	(* convert list of notebooks to list of ids *)
	(* this should not hit download constellation endpoint, because there is a shortcut for ID *)
	notebooksString=Download[notebooks, ID];
	Map[
		Association[
			"Clauses" -> {#},
			"SoftLimit" -> If[maxResults === Infinity, -1, maxResults],
			"SubTypes" -> False,
			"Date" -> If[!MatchQ[date, None], DateObjectToRFC3339[date]],
			"IgnoreTime" -> ignoreTime,
			"Notebooks" -> notebooksString,
			"PublicObjects" -> publicObjects
		]&, uniqueRequestClauses
	]
];

toSearchQuery[typeGroups:{{typeP...}...}, clauses:clausesP, opts:OptionsPattern[Search]]:=
	If[loggedInQ[],
		Map[toSearchQuery[#, clauses, opts]&, typeGroups],
		(
			Message[Search::NotLoggedIn];
			$Failed
		)
	];

toSearchQuery[typeGroups:{{typeP...}...}, clauseGroups:{clausesP...}, opts:OptionsPattern[Search]]:=Module[
	{safeOps, heldGroups, maxResults, subTypes, notebooks, publicObjects, notebooksList, publicObjectsList},

	safeOps=ECL`OptionsHandling`SafeOptions[Search, ToList[opts], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	If[!loggedInQ[],
		Message[Search::NotLoggedIn];
		Return[$Failed]
	];

	If[Length[typeGroups] =!= Length[Unevaluated[clauseGroups]],
		Message[Search::MapThread, Length[typeGroups], Length[Unevaluated[clauseGroups]]];
		Return[$Failed]
	];

	heldGroups=ReleaseHold[Map[Hold, Hold[clauseGroups], {2}]];

	maxResults=expandOption[
		MaxResults,
		Lookup[safeOps, MaxResults],
		Length[typeGroups]
	];
	If[maxResults === $Failed,
		Return[$Failed]
	];

	subTypes=expandOption[
		SubTypes,
		Lookup[safeOps, SubTypes],
		Length[typeGroups]
	];
	If[subTypes === $Failed,
		Return[$Failed]
	];

	notebooks=Lookup[safeOps, Notebooks];
	publicObjects=Lookup[safeOps, PublicObjects];
	notebooksList=If[NullQ[notebooks],
		Table[Null, Length[typeGroups]],
		notebooks
	];

	publicObjectsList=If[TrueQ[publicObjects],
		Table[True, Length[typeGroups]],
		publicObjects
	];

	If[Length[notebooksList] =!= Length[typeGroups],
		Message[Search::NotebooksLength, Length[typeGroups], Length[notebooksList]];
		Return[$Failed]
	];

	If[Length[publicObjectsList] =!= Length[typeGroups],
		Message[Search::ObjectsLength, Length[typeGroups], Length[publicObjectsList]];
		Return[$Failed]
	];

	MapThread[
		Apply[
			toSearchQuery,
			Join[Hold[#1], #2, Hold[MaxResults -> #3, SubTypes -> #4, Notebooks -> #5, PublicObjects -> #6]]
		]&,
		{typeGroups, heldGroups, maxResults, subTypes, notebooksList, publicObjectsList}
	]
];

SetAttributes[toSearchQuery, HoldRest];


(* Takes our MM style search query and creates a POST request. *)
searchQueryToRequest[assoc:searchQueryP]:=Association[
	"Method" -> "POST",
	"Path" -> apiUrl["Search"],
	"Body" -> ExportJSON[
		<|
			"queries" -> {
				<|
					"clauses" -> Lookup[assoc, "Clauses"],
					"SoftLimit" -> Lookup[assoc, "SoftLimit"],
					"SubTypes" -> Lookup[assoc, "SubTypes"],
					"ignore_time" -> Lookup[assoc, "IgnoreTime"],
					"date" -> Lookup[assoc, "Date", ""],
					"notebooks" -> Lookup[assoc, "Notebooks"],
					"include_public_objects" -> Lookup[assoc, "PublicObjects"],
					getDebugTimeRule[]
				|>
			}
		|>
	],
	"Timeout" -> 600 * 1000 (* milliseconds per HTTP request via Clojure's http-request-async *)
];


(* Convert each individual query into a request and then send them to the server
	in parallel. The server doesn't currently parallelize if you send multiple
	queries in one request.*)
sendSearch[$Failed, opts:OptionsPattern[Search]]:=$Failed;


(* Authors definition for Constellation`Private`sendSearch *)
Authors[Constellation`Private`sendSearch]:={"xu.yi"};

sendSearch[query:searchQueryP, opts:OptionsPattern[Search]]:=With[
	{results=sendSearch[{query}, opts]},

	If[results === $Failed,
		$Failed,
		If[MatchQ[results, {}],
			{},
			First[results]
		]
	]
];
sendSearch[queries:{searchQueryP...}, opts:OptionsPattern[Search]]:=Module[
	{safeOps, maxResults, responses, results},
	safeOps=ECL`OptionsHandling`SafeOptions[Search, ToList[opts], ECL`OptionsHandling`AutoCorrect->False];
	maxResults=Lookup[safeOps, MaxResults];
	printProgressMessage["Searching Constellation for matching objects"];

	(* Make sure to wait for upload replication to complete, if necessary *)
	Constellation`Private`WaitUntilUploadReplicationComplete[];

	(*Make multiple requests in parallel as there is currently no server-side
	parallelism in processing searches so this will be faster*)
	responses=ConstellationRequest[
		searchQueryToRequest /@ queries,
		Concurrency -> 10,
		Retries -> 4,
		RetryMode -> Read
	];

	clearProgressMessage[];

	If[MemberQ[responses, _HTTPError],
		(
			checkSearchError /@ responses;
			$Failed
		),
		(* Re-format the server response to the list of objects the caller wants *)
		results=DeleteDuplicates[Flatten[Map[
			DeleteCases[objectReferenceToObject /@ Lookup[First[Lookup[#, "Results"]], "References"], $Failed]&,
			responses
		]]];
		(*
			Implement Max/Min when SubTypes -> True
			TODO: this should be a temporary measure - once we handle type deprecation and/or have a
		  TOOD: centralized live type system - then the backend should be able to handle this.
		  TODO: therefore I haven't prioritized efficiency
		 *)

		results = consolidateMaxMinResults[results, queries];

		If[MatchQ[maxResults, Infinity],
			results,
			Take[results, Min[maxResults, Length[results]]]
		]
	]
];

sendSearch[queries:{{searchQueryP...}...}, opts:OptionsPattern[Search]]:=Module[
	{safeOps, maxResults, uniqueQueries, uniqueResults,queryToResultRules},
	safeOps=ECL`OptionsHandling`SafeOptions[Search, ToList[opts], ECL`OptionsHandling`AutoCorrect->False];
	maxResults=Lookup[safeOps, MaxResults];

	(* remove calls that are exactly identical *)
	uniqueQueries = DeleteDuplicates[queries];

	uniqueResults = If[MatchQ[Head[maxResults], List],
		MapThread[sendSearch[#1, MaxResults->#2]&, {uniqueQueries, maxResults}],
		Map[sendSearch[#, opts]&, uniqueQueries]
	];

	(*
		Add back results for the duplicate queries that were removed.
		Make a lookup connecting query to result,
		then swap results in to original query list 			
	 *)

	queryToResultRules = MapThread[Rule,{uniqueQueries, uniqueResults}];

	Replace[
		queries,
		queryToResultRules,
		{1}
	]


];
sendSearch[queries_List]:=$Failed;


checkSearchError[HTTPError[__, message_String]]:=(
	Message[Search::Error, message];
	True
);

consolidateMaxMinResults[originalResults_, queries:{searchQueryP...}, opts:OptionsPattern[Search]] := Module[{safeOps},
	safeOps=ECL`OptionsHandling`SafeOptions[Search, ToList[opts], ECL`OptionsHandling`AutoCorrect->False];
	If[Not@TrueQ[Lookup[safeOps, SubTypes]] || MatchQ[Length[queries], 0] ,
		originalResults,
		Module[{queryString, clauses, field, sortedResults},
			clauses = Lookup[First@queries, "Clauses"];
			(* Clauses guaranteed to be non-empty *)
			queryString = Lookup[First@clauses, "Query"];

			If[StringContainsQ[queryString, ".max=0"],
				field = stringToSymbol[First@StringCases[queryString,  (x: WordCharacter..) ~~ ".max=0" -> x]];
				Return[MaximalBy[originalResults, Download[#, field] &]];
			];

			If[StringContainsQ[queryString, ".min=0"],
				field = stringToSymbol[First@StringCases[queryString,  (x: WordCharacter..) ~~ ".min=0" -> x]];
				Return[MinimalBy[originalResults, Download[#, field] &]];
			];

			originalResults
		]
	]
];

DefineOptions[
	Search,
	Options :> {
		{MaxResults -> Infinity, _Integer?Positive | Infinity | {(_Integer?Positive | Infinity)..}, "The maximum number of objects to return that match the search query."},
		{SubTypes -> True, True | False | {(True | False)..}, "When the input type is a super-type, whether to do the query across all sub-types of the type."},
		{Date -> None, None | _?DateObjectQ, "Search for objects at a specific time in Constellations."},
		{IgnoreTime -> False, BooleanP, "If IgnoreTime is True then Date Option is ignored and Temporal Links are ignored. Search through Temporal Links also will not happen, and a regular time-less search through links will occur."},
		{Notebooks -> Null, Null | _List, "Limit search to these notebooks. By default public objects are included in the result, to exclude set PublicObjects to False)"},
		{PublicObjects -> True, True | False | {(True | False)..}, "Include public objects to search. This option is active only if Notebooks is set, ignored otherwise."}
	}
];

Search::InvalidSearchQuery="The query does not have a valid form. Please check that your search conditions are only field names and expressions such as &&, ||, |, ==, !=, <, >, <=, >=, Field, and Part.";
Search::InvalidField="The fields `1` in types `2` are not valid fields for searching.";
Search::InvalidSearchValues="The query has the follow invalid values in its conditions: `1`.";
Search::AmbiguousType="Unable to search using the value `1` due to an ambiguity in the resulting field class after searching through links.";
Search::MapThread="The provided lengths of types `1` and queries `2` are unequal.";
Search::NotebooksLength="The provided lengths of types `1` and Notebooks `2` are unequal.  Please update your request and try again.";
Search::PublicObjectsLength="The provided lengths of types `1` and PublicObjects `2` are unequal.  Please update your request and try again.";
Search::OptionLength="The length of option `1` (`2`) does not match the length of the inputs (`3`).";
Search::MissingType="The following types do not exist: `1`.";
Search::MissingField="The fields `1` in types `2` do not exist.";
Search::Alternatives="When using Alternatives in an equality it must be wrapped in parentheses. For example, Field==(A|B).";
Search::ComputableField="The fields `1` in types `2` cannot be searched on because they are live computed and not stored. Please try restructuring your search to use different fields.";
Search::CloudFileField="The fields `1` in types `2` cannot be searched because searching on EmeraldCloudFiles is not currently supported. Please try restructuring your search to use different fields.";
Search::Error="`1`";
Warning::NotebooksIsNotSet="PublicObjects cannot be set to False if Notebooks is not set and so public objects will be included in the search results. Please update your options and try again if this is not acceptable.";

(*Empty list short-circuits*)
(* kevin is not sure this case should behave this way, but an empty list is better than an erroneous OptionsPattern[] match *)
Search[types:{typeP...}, {}, OptionsPattern[]]:={};

(*Single type*)
Search[type:typeP, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[type, opts], opts
]];

Search[type:typeP, clauses:clausesP, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[type, clauses, opts], opts
]];

(*Lists of types*)
Search[types:{typeP..}, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[types, opts], opts
]];

Search[types:{typeP..}, clauses:clausesP, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[types, clauses, opts], opts
]];

Search[types:{typeP..}, clauseGroups:{clausesP..}, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[List /@ types, clauseGroups, opts], opts
]];

(*Nested lists of types*)
Search[typeGroups:{{typeP...}...}, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[typeGroups, opts], opts
]];

Search[typeGroups:{{typeP...}...}, clauses:clausesP, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[typeGroups, clauses, opts], opts
]];

Search[typeGroups:{{typeP...}...}, clauseGroups:{clausesP...}, opts:OptionsPattern[]]:=TraceExpression["Search", sendSearch[
	toSearchQuery[typeGroups, clauseGroups, opts], opts
]];

SetAttributes[Search, HoldRest];


(* Server-side parallel-search only supports a maximum of 100 parallel searches *)
$ParallelSearchLimit = 100;

DefineOptions[
	parallelSearch,
	SharedOptions :> {
		Search
	}
];

(* parallelSearch is a derivative of Search that has a constellation endpoint which runs all 
search queries in parallel. It was developed for the use in engine,
specifically in storageDestinations searching *)

Authors[Constellation`Private`parallelSearch]:={"robert"};
parallelSearch[type:typeP, clauseGroups:{clausesP..}, opts:OptionsPattern[]]:=parallelSearch[Table[type,Length[clauseGroups]],clauseGroups,opts];
parallelSearch[types:{typeP...}, clauseGroups:{clausesP...}, opts:OptionsPattern[]]:=TraceExpression["parallelSearch",Module[
	{searchQueries},
	
	searchQueries = toSearchQuery[List/@types, clauseGroups, opts];

	sendParallelSearch[searchQueries,opts]
]];

SetAttributes[parallelSearch, HoldRest];

sendParallelSearch[queries:{{searchQueryP...}...}, opts:OptionsPattern[Search]]:=Module[
	{safeOps, maxResults, responses, results, requests,uniqueQueries,uniqueResults,queryToResultRules},
	
	safeOps=ECL`OptionsHandling`SafeOptions[Search, ToList[opts], ECL`OptionsHandling`AutoCorrect->False];
	maxResults=Lookup[safeOps, MaxResults];
	printProgressMessage["Searching Constellation for matching objects"];
	
	(* remove calls that are exactly identical *)
	uniqueQueries = DeleteDuplicates[Flatten[queries]];

	(* Make sure to wait for upload replication to complete, if necessary *)
	Constellation`Private`WaitUntilUploadReplicationComplete[];
	
	requests = Map[
		Association[
			"Method" -> "GET",
			"Path" -> apiUrl["parallelSearch"],
			"Body" -> <|
					"requests" -> Map[
						Function[assoc,
							<|
								"clauses" -> Lookup[assoc, "Clauses"],
								"SoftLimit" -> Lookup[assoc, "SoftLimit"],
								"SubTypes" -> Lookup[assoc, "SubTypes"],
								"ignore_time" -> Lookup[assoc, "IgnoreTime"],
								"date" -> Lookup[assoc, "Date", ""],
								"notebooks" -> Lookup[assoc, "Notebooks"],
								"include_public_objects" -> Lookup[assoc, "PublicObjects"],
								getDebugTimeRule[]
							|>
						],
						#
					]
				|>,
			"Timeout" -> 600 * 1000
		]&,
		PartitionRemainder[uniqueQueries,$ParallelSearchLimit]
	];

	responses=ConstellationRequest[
		requests,
		Concurrency -> 10,
		Retries -> 4,
		RetryMode -> Read
	];

	clearProgressMessage[];

	If[MemberQ[responses, _HTTPError],
		(
			checkSearchError /@ responses;
			$Failed
		),
		(* Re-format the server response to the list of objects the caller wants *)
		uniqueResults = Map[
			DeleteDuplicates@DeleteCases[(objectReferenceToObject/@#),$Failed]&,
			Join@@(responses[[All,Key["results"]]])
		];
		
		queryToResultRules = MapThread[Rule,{uniqueQueries, uniqueResults}];
		
		results = Map[
			DeleteDuplicates[Join@@#]&,
			Replace[
				queries,
				queryToResultRules,
				{2}
			]
		];
		
		results = MapThread[
			consolidateMaxMinResults,
			{results, queries}
		];

		Which[
			MatchQ[maxResults, Infinity],
				results,
			MatchQ[Head[maxResults], List],
				MapThread[Take[#1, Min[#2, Length[#1]]]&,{results,maxResults}],
			True,
				Map[Take[#, Min[maxResults, Length[#]]]&,results]
		]
	]
];