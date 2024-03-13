(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*General Messages*)


OnLoad[
	General::OutOfRange="Positions `1` are not within the range of the values currently in `2`.";
	General::UnknownType="Unknown type `1`.";
	General::UnknownField="Unknown field `1` in type `2`.";
	General::UnknownObject="`1` does not exist.";
	General::FieldType="Field `1` in `2` is not a Multiple field.";
	General::InvalidSpan="Only integer spans (without steps) are supported.";
	General::UnexpectedError="Something unexpected happened: `1`";
];

(*Set the default cache size if not already set to a value*)
If[Not[ValueQ[$CacheSize]],
	$CacheSize=512000000;
];

setDebugTime[date:_?DateObjectQ]:=Block[{},
	ClearDownload[];
	debugTime=date;
];

clearDebugTime[]:=Block[{},
	ClearDownload[];
	debugTime=False;
];

(* ::Subsection:: *)
(*constellationImage*)


constellationImage[16]:=Set[
	constellationImage[16],
	Import[FileNameJoin[{PackageDirectory["Constellation`"], "resources", "ConstellationIcon16x16.png"}], "PNG"]
];

constellationImage[32]:=Set[
	constellationImage[32],
	Import[FileNameJoin[{PackageDirectory["Constellation`"], "resources", "ConstellationIcon32x32.png"}], "PNG"]
];

constellationImage[___]:=Set[
	constellationImage[___],
	Import[FileNameJoin[{PackageDirectory["Constellation`"], "resources", "ConstellationIcon32x32.png"}], "PNG"]
];

bookmarkImage[___]:=Set[
	bookmarkImage[___],
	Import[FileNameJoin[{PackageDirectory["Constellation`"],"resources","BookmarkIcon.png"}],"PNG"]
];

constellationPin[16]:=Set[
	constellationPin[16],
	Import[FileNameJoin[{PackageDirectory["Constellation`"], "resources", "ConstellationPin16x16.png"}], "PNG"]
];

constellationPin[32]:=Set[
	constellationPin[32],
	Import[FileNameJoin[{PackageDirectory["Constellation`"], "resources", "ConstellationPin24x24.png"}], "PNG"]
];

constellationPin[___]:=Set[
	constellationPin[___],
	Import[FileNameJoin[{PackageDirectory["Constellation`"], "resources", "ConstellationPin24x24.png"}], "PNG"]
];

(* set $CurrentUploadTransactions stack *)
OnLoad[If[Not[Length[$CurrentUploadTransactions] > 0],
	(* $CurrentUploadTransactions used to store stack of active upload SLL transactions *)
	$CurrentUploadTransactions={};
]
];

internalMetadata[key_String]:=Module[
	{notebookId},
	notebookId=StringTrim[
		Last[
			StringSplit[
				ToString[InputForm[EvaluationNotebook[]]],
				","
			]
		],
		"]"
	];
	CurrentValue[$FrontEndSession, {TaggingRules, "ECLMetadata", notebookId, key}]
];

$Notebook::InvalidNotebook="$Notebook cannot be set to `1`, as it is not a notebook object";

OnLoad[localNotebook=Null];
(* Set upvalues of Set to instead set localNotebookId/localNotebook *)

$Notebook/:Set[$Notebook, x_]:=If[MatchQ[x, ObjectReferenceP[Object[LaboratoryNotebook]] | Null],
	Set[localNotebook, x],
	Message[$Notebook::InvalidNotebook, x]
];

(** Return previously set value, or PluginParameters notebookid, or Null **)
$Notebook:=Module[
	{id},

	If[localNotebook =!= Null,
		Return[localNotebook]
	];

	(* If not running in a notebook, return Null *)
	If[FailureQ[Quiet[EvaluationNotebook[], {FrontEndObject::notavail}]],
		Return[Null]
	];

	(* internalMetadata returns "Inherited" if the value does not exist *)
	id=internalMetadata["notebookObjectId"];
	If[Not[MatchQ[id, Inherited]],
		Return[Object[LaboratoryNotebook, id]]
	];

	(* "PluginParameters" is not defined in WolframCloud, so handle the case where CurrentValue["PluginParameters"] returns $Failed instead of a list *)
	id=With[{parameters=CurrentValue["PluginParameters"]},
		Lookup[If[MatchQ[parameters, $Failed], {}, parameters],
			"notebookid", $Failed]
	];
	If[FailureQ[id],
		Null,
		Object[LaboratoryNotebook, id]
	]
];

Protect[$Notebook];


$NotebookPage:=Module[
	{id},

	(* If not running in a notebook, return Null *)
	If[FailureQ[Quiet[EvaluationNotebook[], {FrontEndObject::notavail}]],
		Return[Null]
	];
	(* internalMetadata returns "Inherited" if the value does not exist *)
	id=internalMetadata["pageObjectId"];
	If[Not[MatchQ[id, Inherited]],
		Return[Object[id]]
	];

	(* CC CDF gets pageid passed in to the object tag *)
	id=Lookup[CurrentValue["PluginParameters"], "pageid", $Failed];
	If[FailureQ[id],
		Null,
		Object[id]
	]
];


(* ::Subsection:: *)
(*PinObject*)


PinObject[objects:ListableP[objectP | modelP | linkP]]:=printCompletionMessage["New objects added to Constellation:", ToList[Download[objects, Object]]];



(* ::Subsection:: *)
(*printProgressMessage*)

(*This generates a PrintTemporary cell that informs the user about the current status of Constellation function calls*)
printProgressMessage[message_String]:=If[Not[TrueQ[$DisableVerbosePrinting]] && Not[TrueQ[$ProgressPrinting]] && MatchQ[$FrontEnd, _FrontEndObject],
	(
		$ProgressPrintingCell=PrintTemporary[
			Row[{
				constellationImage[$ConstellationIconSize],
				Spacer[10],
				message,
				If[Not[$CloudEvaluation], ProgressIndicator[Appearance -> "Percolate"], Nothing]
			}]
		];
		$ProgressPrinting=True;
		With[
			{
				existingPostFunction=If[MatchQ[$Post, HoldPattern[$Post]],
					None,
					$Post
				]
			},
			$Post=Function[expr,
				$ProgressPrinting=False;
				If[existingPostFunction === None,
					(
						Unset[$Post];
						expr
					),
					(
						$Post=existingPostFunction;
						existingPostFunction[expr]
					)
				]
			]
		];
	)
];

(*This clears the PrintTemporary cell created by printProgressMessage[]*)
clearProgressMessage[]:=NotebookDelete[$ProgressPrintingCell];

(* ::Subsection:: *)
(*printCompletionMessage*)


printCompletionMessage[message_String]:=If[Not[TrueQ[$DisableVerbosePrinting]] && MatchQ[$FrontEnd, _FrontEndObject],
	Print[
		Row[{
			If[StringContainsQ[message, "deleted"],
				constellationImage[$ConstellationIconSize],
				constellationPin[$ConstellationIconSize]
			],
			Spacer[10],
			message
		}]
	]
];

printCompletionMessage[message_String, objects:{(objectP | modelP)..}]:=If[Not[TrueQ[$DisableVerbosePrinting]],
	Print[
		constellationImage[$ConstellationIconSize],
		Spacer[10],
		message,
		Spacer[10],
		Short[objects],
		Spacer[10],
		Button[Mouseover["(Copy IDs)", Style["(Copy IDs)", Bold]], CopyToClipboard[objects], Appearance -> None, BaseStyle -> "Hyperlink"]
	]
];



(* ::Subsection:: *)
(*CreateID*)


CreateID[type:typeP]:=First[CreateID[{type}]];
CreateID[Null]:=Null;
CreateID[{}]:={};
CreateID[types:{(typeP | Null) ..}]:=TraceExpression["CreateID", Module[
	{typePositions, uploads, response, result},

	typePositions=Position[types, typeP];
	If[typePositions === {},
		Return[types]
	];
	uploads=Map[<|Type -> #|> &, Extract[types, typePositions]];
	response=sendUploadObjects[uploads, True, {}, None, True];

	(*checkUploadError will print the appropriate messages if any*)
	result=If[checkUploadError[response],
		Table[$Failed, Length[uploads]],
		parseUploadResponse /@ Lookup[response, "responses", {}]
	];

	ReplacePart[types, MapThread[Rule, {typePositions, result}]]
]];
CreateID[n_Integer?Positive]:=With[
	(* TODO: james: fix this so can take Object[]. for some reason the server dosn't like it. *)
	{result=CreateID[Table[Object[Report], {n}]]},
	If[MemberQ[result, $Failed],
		result,
		result[[All, -1]]
	]
];
CreateID[]:=First[CreateID[1]];


(* ::Subsection:: *)
(*EraseLink*)


EraseLink[link:linkP]:=sendEraseLink[link];
EraseLink::AmbiguousLinkError="Link provided but does not have a link id.";
SetAttributes[EraseLink, Listable];



(* ::Subsection:: *)
(*CreateLinkID*)


currentId=1;
getNextId[]:=ToString[currentId++];
makeClientLinkId[]:=StringJoin["clientId:link", getNextId[]];
CreateLinkID[]:=makeClientLinkId[];
CreateLinkID[count_Integer?Positive]:=Table[makeClientLinkId[], count];



(* ::Subsection:: *)
(*FieldPart*)


cacheableSymbols[Verbatim[Traversal][field_Symbol, ___]]:=field;
cacheableSymbols[Verbatim[Traversal][Verbatim[Length][field:Except[_Repeated]]]]:=
		First[Traversal[field]];
cacheableSymbols[Verbatim[Traversal][PacketTarget[{fields:Except[All | Length, _Symbol] ...}]]]:=
		fields;
cacheableSymbols[Verbatim[Traversal][args:___]]:=Nothing;
fieldSequenceP=HoldPattern[Verbatim[Traversal][(_Symbol | _Integer)..]];


(* ::Subsubsection::Closed:: *)
(*Field*)


Field::Deprecated="The Field syntax `1` is deprecated. Only Field with 1 argument is supported.";

SetAttributes[Field, HoldAll];

validPartP=Alternatives[
	_Integer,
	All,
	Span[_Integer, _Integer | All],
	{__Integer}
];

Traversal[Field[arg_]]:=Traversal[arg];

(*Field of more than 1 argument is deprecated*)
Traversal[Verbatim[Field][first_, rest__]]:=(
	Message[Field::Deprecated, HoldForm[Field[first, rest]]];
	Traversal[first, rest]
);

Traversal[Verbatim[Part][Verbatim[Part][x:_, parts1:___], parts2:___]]:=
		Traversal[Part[x, parts1, parts2]];

Traversal[Verbatim[Part][x_, row:validPartP, column:_Symbol]]:=With[
	{evaluated=Traversal[x]},

	Append[Most[evaluated], Query[Key[Last[evaluated]], row, Key[column]]]
];

Traversal[Verbatim[Part][x_, row:validPartP, column:{___Symbol}]]:=With[
	{
		evaluated=Traversal[x],
		keys=Map[Key, column]
	},

	Append[Most[evaluated], Query[Key[Last[evaluated]], row, keys]]
];

Traversal[Verbatim[Part][x_, row:Except[All, _Symbol]]]:=With[
	{evaluated=Traversal[x]},

	Append[Most[evaluated], Query[Key[Last[evaluated]], Key[row]]]
];

Traversal[Verbatim[Part][x_, row:{___Symbol}]]:=With[
	{
		evaluated=Traversal[x],
		keys=Map[Key, row]
	},

	Append[Most[evaluated], Query[Key[Last[evaluated]], keys]]
];

Traversal[Verbatim[Part][x_, y:Repeated[validPartP, {1, 2}]]]:=With[
	{evaluated=Traversal[x]},

	Append[Most[evaluated], Query[Key[Last[evaluated]], y]]
];

Traversal[Verbatim[Part][x_, y__]]:=With[
	{evaluated=Traversal[x]},

	Traversal[evaluated, InvalidPart[y]]
];

Traversal[(most:Except[List, _])[length:Verbatim[Length][_]]]:=With[
	{evaluated=Traversal[most]},

	Traversal[evaluated, length]
];

(* TODO: eventually remove *)
Traversal[(field:_Symbol)[Length]]:=Traversal[Length[field]];

(* TODO: eventually remove *)
Traversal[(most:___)[field:_][Length]]:=With[
	{evaluated=Traversal[most]},

	Traversal[evaluated, Length[field]]
];

Traversal[Verbatim[Repeated][x:Except[_Traversal], y:Repeated[_Integer, {0, 1}]]]:=With[
	{evaluated=Traversal[x]},

	Traversal[Repeated[evaluated, y]]
];

Traversal[Verbatim[Traversal]]:=Traversal[];

Traversal[Verbatim[Traversal][y_]]:=Traversal[y];

Traversal[(x:Except[List | PacketTarget | Verbatim[Repeated] | Verbatim[Length] | Query])[y_]]:=With[
	{
		first=Traversal[x],
		rest=Traversal[y]
	},

	Traversal[first, rest]
];

(*Flatten sequence of Traversal or non-field expressions*)
Traversal[items__]:=With[
	{
		fields=Replace[
			Hold[items],
			{
				x:Except[_Traversal] :> Hold[x],
				Traversal[x___] :> Hold[x]
			},
			{1}
		]
	},

	Apply[
		Traversal,
		Apply[Join, fields]
	]
]/;MemberQ[Hold[items], _Traversal];

SetAttributes[Traversal, HoldAll];
SetAttributes[InvalidPart, HoldAll];

(*Takes in the Traversal[...] form of field inputs to Download and returns a Deferred version
of the SubValue form of fields. Traversal[Blah,Blah2,All,1] -> Defer[Blah[Blah2][[All,1]]].
This is used for generating Download error messages when referring to fields to make
the fields easily copied out of and manipulated from the messages.*)
deferFields[field_Traversal]:=Apply[
	Defer,
	Replace[
		heldField[field],
		Hold[x_] :> x,
		{1, Infinity},
		Heads -> True
	]
];
SetAttributes[deferFields, Listable];

traversalFieldP=_Symbol | Verbatim[Length][Except[_Repeated]];
partSequenceP=_Integer | All | Span[_Integer, _Integer] | {__Integer};

heldField[prefix_, Verbatim[Traversal][]]:=Hold[prefix];
heldField[Verbatim[Traversal][Query[Key[field:traversalFieldP], parts:___], rest___]]:=Apply[
	heldField,
	Hold[Part[field, parts], Traversal[rest]]
];
heldField[Verbatim[Traversal][field:traversalFieldP, rest___]]:=Apply[
	heldField,
	Hold[field, Traversal[rest]]
];
heldField[prefix_, Verbatim[Traversal][Query[Key[field:traversalFieldP], parts:___], rest___]]:=Apply[
	heldField,
	Hold[Part[prefix[field], parts], Traversal[rest]]
];
heldField[prefix_, Verbatim[Traversal][field:traversalFieldP, rest___]]:=Apply[
	heldField,
	Hold[prefix[field], Traversal[rest]]
];

heldField[Verbatim[Traversal][Verbatim[Length][repeated:Verbatim[Repeated][first:_, ___], rest___]]]:=Apply[
	heldField,
	With[
		{repeatedTraversal=Join[
			Repeated[Traversal[first]],
			Most[repeated]
		]},

		With[{inner=heldField[Traversal[repeatedTraversal]]},
			Hold[Length[inner], Traversal[rest]]
		]
	]
];

heldField[Verbatim[Traversal][Verbatim[Repeated][field_Traversal, max_Integer, ___], rest___]]:=Apply[
	heldField,
	With[{inner=heldField[field]},
		Hold[Repeated[inner, max], Traversal[rest]]
	]
];
heldField[prefix_, Verbatim[Traversal][Verbatim[Repeated][field_Traversal, max_Integer, ___], rest___]]:=Apply[
	heldField,
	With[{inner=heldField[field]},
		Hold[prefix[Repeated[inner, max]], Traversal[rest]]
	]
];
heldField[Verbatim[Traversal][Verbatim[Repeated][field_Traversal, ___], rest___]]:=Apply[
	heldField,
	With[{inner=heldField[field]},
		Hold[Repeated[inner], Traversal[rest]]
	]
];
heldField[prefix_, Verbatim[Traversal][Verbatim[Repeated][field_Traversal, ___], rest___]]:=Apply[
	heldField,
	With[{inner=heldField[field]},
		Hold[prefix[Repeated[inner]], Traversal[rest]]
	]
];

heldField[prefix_, Verbatim[Traversal][InvalidPart[part___], rest___]]:=Apply[
	heldField,
	Hold[Part[prefix, part], Traversal[rest]]
];

heldField[Verbatim[Traversal][unexpected_]]:=Hold[unexpected];
heldField[unexpected_]:=Hold[unexpected];
heldField[prefix_, Verbatim[Traversal][unexpected_]]:=Hold[prefix[unexpected]];
heldField[prefix_, unexpected_]:=Hold[prefix[unexpected]];

SetAttributes[heldField, HoldAll];



(* ::Subsection:: *)
(*Download*)


DefineOptions[Download,
	Options :> {
		{PaginationLength -> 50, _Integer?NonNegative, "The maximum number of elements to download for multiple fields before triggering RuleDelayed key-values."},
		{Verbose -> True, True | False | Cache, "True: prints progress/completion messages. Cache: prints either server or which cache each field in each object came from."},
		{HaltingCondition -> Exclusive, Exclusive | Inclusive, "Inclusive will return the final object which failed the Search condition in a Repeated download (Exclusive will not)."},
		{
			Cache -> Automatic,
			Automatic | Session | Download | {(_Association | Null)...},
			"Download always checks the server for the latest version of the object. Session uses the values in the local cache and does not check the server. Automatic uses the Cache value from the type definition for each object.  List of packets takes precedence over any values in the cache or on the server."
		},
		{
			Simulation -> Null,
			Null | SimulationP,
			"The Simulation that contains any simulated objects that should be used.",
			Category -> Hidden
		},
		{Date -> None, None | _?DateObjectQ | ListableP[None | _?DateObjectQ], "Downloads the version of the object at that specific date. A lists of dates thread with lists of object."},
		{IgnoreTime -> False, False | BooleanP, "If IgnoreTime is True then Date Option is ignored and Temporal Links are ignored. Download through Temporal Links also will not happen, and a regular time-less download through links will occur."},
		{SquashResponses -> True, BooleanP, "If SquashResponses is True, then the traversed objects field is flattened to optimize for object cache insertion."},
		(* Default to 5 GiB limit *)
		{BigQuantityArrayByteLimit -> 5368709120, _Integer | None, "By default, all BigQuantityArray fields are returned as an EmeraldCloudFile.
		Specifying None will explicitly download the file. A custom byte limit limit is also supported."},
		{IncludeCAS -> False, BooleanP, "If IncludeCAS is True, then the object response will include the objects CAS as an additional field. This will only work when downloading an entire object."}
	}
];

Download::ObjectDoesNotExist="The following objects could not be found: `1`. Please check whether these objects exist or if you have access to these objects.";
Download::NetworkError="The specified Download call failed due to a network error: `1`.  Please check your internet connection and try again.";
Download::MapThread="The provided lengths of `1` (`2`) and `3` (`4`) are unequal.  Please correct them and try again.";
Download::InvalidField="Field specifications `1` are invalid.  Please correct them and try again.";
Download::UnusedSearchConditions="Search conditions `1` were provided for downloading fields `2`, but these fields are not Repeated and thus search conditions are irrelevant.";
Download::Length="Cannot download Length of fields `1` from objects `2` because they are not multiple fields.";
Download::PacketLength="Cannot download Length inside Packet fields `1`.  Please update your download request and try again.";
Download::RedundantField="Fields `1` are equivalent to Packet[All].  Please consider updating your download request.";
Download::InvalidSearch="Search conditions `1` were provided for downloading fields `2` but are invalid. Must be an expression of And, Or, Greater, Less, LessEqual, GreaterEqual, NotEqual, or Equal and not contain any quantities.";
Download::FieldDoesntExist="Could not find the field(s) `1` in object(s) `2`.  Please check your spelling and try again.";
Download::UnknownType="Types `1` are not defined.  Please check your spelling and try again.";
Download::Cycle="Cycles detected when downloading the repeated fields `1` for objects `2`.  Please update your download request and try again.";
Download::NotLinkField="Could not Download fields `1` because `2` are not link fields.  Please update your download request and try again.";
Download::MissingField="Could not find the field(s) `1` in the packets for object(s) `2`.  Please check your spelling and try again.";
Download::FieldTooLarge="The field(s) `1` in objects(s) `2` are too large and cannot be downloaded directly into the notebook.  Please update your download and try again.";
Download::MissingCacheField="Could not find the field(s) `1` in the cache packets for object(s) `2`.  Please check your spelling and try again.";
Download::PacketWrapperMultipleObjects="The Packet wrapper is used for more than one through-link traversal with through-links for `1`.  Please separate these into several uses of the Packet wrapper around each traversal separately.";
Download::Part="Parts `1` of fields `2` do not exist for objects `3`.  Please check your syntax and try again.";
Download::BadCache="Packets at positions `1` in the explicit cache do not have object keys, and have been ignored.  Please check your syntax and try again.";
Download::BigDataField="There was an error with big data field `1`: `2`.  Please update your download request and try again.";
Download::MismatchedType="Ids `1` exist in the database, but are not of types `2`.  Please update your download request and try again.";
Download::DateMismatch="The provided dates do not match the given input. Either provide a single date to map across every input, or provide a list of dates that match the number of objects in the input.";
Download::TransientNetworkError="There was a problem communicating with constellation.  Please check your network connection and run your code again.";
Download::UnparsableDownloadError="There was a problem parsing your download request.  Please check the syntax of your request and try again.";
Download::FileSystemsPermissionsError="There was a problem accessing the file system at path `1`.  Please make sure that path is accessible to Command Center and try again.";
Download::InvalidOption="There was an invalid value `1` passed to the option `2`. Please update your request and try again.";
Download::DatePrecedeCreationTime="The provided date is before the object creation date. Please verify timestamp does not precede creation time for object.";
Download::DateTooFarInFuture="The provided date is too far in the future. Please update your download request and try again.";
Download::MissingObjectKeyword="The specified Download is missing Object keyword. Please update your download request and try again.";
Download::CloudFileMetadata="There was a problem downloading the metadata for a cloudfile. Please try again.";
Download::CloudFile="There was a problem downloading a cloudfile. Please try again.";
Download::InvalidBigQuantityArrayByteLimit="The value `1` for BigQuantityArrayByteLimit is invalid.  Please enter an integer and try again.";
Download::FieldDefinitionMismatch="Field definition of field `1` for object `2` in SLL does not match it's definition in constellation. Download response for this field might be incomplete or wrong. Please make sure the relevant field is SyncType'd correctly";
Download::Timeout="The Constellation request did not finish computing in `1` minutes and was aborted due to timeout. Please contact the platform team, and in the meantime try to partition and send your request in smaller chunks";
Download::InternalError="An internal error occurred in the Telescope App. `1`";
Download::SomeMetaDataUnavailable="Meta data is unavailable for the specified date. Meta data on fields with multiple entries were not tracked until after 06/22/2023. Fields for which there are multiple entries: `1` will not return (or be counted in the case of Length[]) entries that were Null or a list of entirely Null. For instance, a field that contained {Value1, Null, Value 2} will compute as {Value1, Value2} and a field that contained {{Value1, Value2}, {Null, Null}, {Null, Value3}} will compute as {{Value1, Value2}, {Null, Value3}}.";
downloadRules::RuleParsingFailure="Download failed to parse the fields given.  Internally, download rules: `1`";

downloadInputP=Alternatives[
	_Association,
	objectP,
	modelP,
	linkP,
	$Failed,
	Null
];

(*Empty list cases*)
Download[in:{{}...}, OptionsPattern[]]:=in;
Download[in:{{}...}, traversals_, OptionsPattern[]]:=in;
Download[in:{{}...}, traversals_, conditions_, OptionsPattern[]]:=in;



(* Null cases *)
Download[Null,OptionsPattern[]] := Null;
Download[Null, traversals_, OptionsPattern[]] := Null;
Download[Null, traversals_, conditions_, OptionsPattern[]] := Null;

Download[downloadInputP, empty:{{}..}, OptionsPattern[]]:=empty;
Download[objects:{downloadInputP...}, empty:{{}..}, OptionsPattern[]]:=With[
	{},
	If[Length[objects] =!= Length[empty],
		Message[Download::MapThread, "Objects", Length[objects], "Fields", Length[empty]],
		Replace[
			objects,
			{Null -> Null, _ -> {}},
			{1}
		]
	]
];

Download[objects:{{downloadInputP...}..}, empty:{{}..}, OptionsPattern[]]:=With[
	{},
	If[Length[objects] =!= Length[empty],
		Message[Download::MapThread, "Objects", Length[objects], "Fields", Length[empty]],
		Replace[
			objects,
			{Null -> Null, _ -> {}},
			{2}
		]
	]
];

Download[objects:{downloadInputP...}, {}, {}, ops:OptionsPattern[]]:=With[
	{},
	Download[objects, {}, ops]
];

Download[objects:{downloadInputP...}, {}, OptionsPattern[]]:=With[
	{},
	Map[
		If[MatchQ[#, Null],
			Null,
			{}
		]&,
		objects
	]
];

timeIgnored=False;

$FastDownload=True;

(*Entire object cases*)
Download[input:downloadInputP, ops:OptionsPattern[]]:=First[Download[{input}, ops]];
Download[input:{downloadInputP...}, ops:OptionsPattern[]]:=Flatten[Download[{input}, ops]];
Download[input:{{downloadInputP...}...}, ops:OptionsPattern[]]:=TraceExpression["Download", Module[
	{originalOptions, options, verbose, objects, cacheOption, explicitCache, cacheMisses,

		fetchedObjects, fullCache, objectsNotFound, limit,
		downloadedObjects, result, debugData, requests, missingObjects, unknownTypes, dateOption, dateOptionIsNow, requestedDates,
		flattenedInputNoLinks, temporalLinkPositions, ignoreTimeOption, squashResponses, qaByteLimitOption, oversizedFields,
		groupedOversizedFields},

	(* Options explicitly specified by the user *)
	originalOptions=ToList[ops];

	(* Options to use, with defaults populated for any options which were not specified *)
	options=OptionDefaults[Download, ToList[ops]];

	(* NOTE: When not given any fields, download defaults to downloading the entire packet. *)
	If[TrueQ[$FastDownload],
		Return[
			GoLink`Private`nativeDownloadWithPagination[input, All, None, ops]
		]
	];

	If[!loggedInQ[],
		Message[Download::NotLoggedIn];
		Return[$Failed]
	];

	verbose=Lookup[options, "Verbose"];
	If[MatchQ[verbose, True | Cache],
		printProgressMessage["Downloading objects from Constellation"];
	];

	(*Find all fields which are not in the cache (multiple fields).
	Use an artificially large limit until pagination is implemented.*)
	cacheOption=Lookup[options, "Cache"];
	limit=realLimitNumber[OptionValue[PaginationLength]];

	(* Check if responses will be squashed for cache optimization *)
	squashResponses=Lookup[options, "SquashResponses"];

	dateOption=Lookup[options, "Date"];
	ignoreTimeOption=Lookup[options, "IgnoreTime"];
	qaByteLimitOption=Lookup[options, "BigQuantityArrayByteLimit"] /. None -> Infinity;

	{timeIgnored, qaByteLimit}=If[IsRootDownload[],
		{ignoreTimeOption, adjustedByteLimit[qaByteLimitOption, originalOptions]},
		{timeIgnored, qaByteLimit}
	];

	dateOptionIsNow=ContainsAny[Cases[HoldForm[ops], (Verbatim[Rule][Date, x_]) :> Hold[x]],
		{Hold[Now]}];

	(* Date Option as Now is treated as No Date Option and no overriding happens on Temporal Links *)
	If[!dateOptionIsNow && MatchQ[ignoreTimeOption, False],
		dateOption=FirstCase[HoldForm[ops], (Verbatim[Rule][Date, x_]) :> Hold[x], None];
		(* Add dates to any potential temporal downloads *)
		dateOption=preProcessDateOption[Flatten@input, dateOption];,
		dateOption=Array[None&, Length[Flatten@input]];
	];
	If[MatchQ[dateOption, $Failed],
		Message[Download::DateMismatch];
		Return[$Failed]
	];

	temporalLinkPositions=MatchQ[temporalLinkP] /@ Flatten@input;
	{objects, requestedDates}=filterObjectRequests[Flatten@input, dateOption];

	messageBadCachePackages[cacheOption];
	explicitCache=makeExplicitCache[cacheOption, Object -> True];

	(* convert names to ids if we have them *)
	objects=Map[cacheObjectID, objects];
	explicitCache=KeyMap[cacheObjectID, explicitCache];
	requests=objectRequestsAssociation[Transpose[{objects, requestedDates}]];
	unknownTypes=Map[objectToType,
		First /@ Keys[Select[requests, MatchQ[KeyValuePattern["Fields" -> $Failed]]]]
	];

	If[unknownTypes =!= {},
		Message[Download::UnknownType, DeleteDuplicates[unknownTypes]]
	];

	(* TODO: Can this be combined with downloadRules? *)
	(*If either the debug global is set or Verbose -> Cache, print cache information via cachePrint*)
	cacheMisses=RightComposition[
		(* NOTE: filterExplicitFields[explicitCache] will return a function that will filter through our list of field traversals *)
		(* and remove the ones that are in the explicit cache already. No idea why this is an iterative FixedPoint though? *)
		filterExplicitFieldsWithDate[#, explicitCache]&,

		(* NOTE: Removes all fields which can be computed locally. For objects with IDs, these are Object/ID/Type. For objects with *)
		(* names, this is only Type. *)
		filterLocalFieldsWithDate,

		(* Do not filter session cached fields if Cache->Download *)
		If[MatchQ[cacheOption, Download],
			Identity,
			(* NOTE: Takes an association of objects to lists of Field expressions indicating the fields that are to be downloaded. *)
			(* Filter out all objects which are already in the session cache.*)
			filterSessionCachedObjectsWithDate[#, objectCache]&
		],

		(* NOTE: Adds the "CAS" token to the request association if we have all of the fields for the type in the cache. *)
		(* If we do not have all of the fields of the type in the cache, we will add "" as the CAS token which will *)
		(* guarantee that we fetch all of the fields from the server again. *)
		addCASTokens[#, objectCache]&
	][requests];

	fetchedObjects=fetchAndCacheObjects[
		KeyValueMap[#1 -> Lookup[#2, "CAS"]&, cacheMisses],
		limit,
		ignoreTimeOption,
		squashResponses
	];

	(*Any elements of the returned list wrapped in Missing are objects which were
	not found on the server. Throw a message for these objects.*)
	objectsNotFound=Cases[
		fetchedObjects,
		Missing[obj_, ___] :> obj,
		{1}
	];

	downloadedObjects=Complement[fetchedObjects, objectsNotFound];
	missingObjects=GroupBy[Cases[downloadedObjects, _Missing], Last -> First];

	If[KeyMemberQ[missingObjects, "NotFound"],
		Message[Download::ObjectDoesNotExist, missingObjects[["NotFound"]]]
	];

	If[KeyMemberQ[missingObjects, "TypeMismatch"],
		Message[Download::MismatchedType,
			Map[objectToId, missingObjects["TypeMismatch"]],
			Map[objectToType, missingObjects["TypeMismatch"]]
		]
	];

	(*Set the Session cache value accordingly for the downloaded objects.
	If Cache->Download, sets Session -> False for all objects. If Cache->Automatic
	sets Session -> True for those objects with Cache->Session in their type definitions.
	For Cache->packets, does the same as Cache -> Automatic.
	*)
	Scan[
		setSessionCache[#, cacheOption]&,
		Cases[
			downloadedObjects,
			ObjectP[],
			{1}
		]
	];

	fullCache=<|objectCache, explicitCache|>;

	flattenedInputNoLinks=Replace[Flatten[input], (link:linkP) :> linkToObject[link], 1];

	TraceExpression["getCacheValue",
		Block[{$DebugDownload=Or[TrueQ[$DebugDownload], verbose === Cache]},
			{result, {debugData, oversizedFields}}=Reap[
				(* If it's a temporal link, prefer whats in the global cache unless it doesn't exist in the global cache. *)
				(* TakeList will allow us "unflatten" and return in the same shape as given in the input *)
				result=TakeList[MapThread[
					If[#3 && cacheKeyExistsQ[#1[[1]], #2, objectCache],
						getCacheValue[#1, #2, objectCache],
						getCacheValue[#1, #2, fullCache]]&,
					{flattenedInputNoLinks, dateOption, temporalLinkPositions}], Length /@ input],
				{"debugData", "too-big"}
			];


			If[$DebugDownload && Length[debugData] > 0,
				KeyValueMap[printCacheRows,
					Map[KeyValueMap[fieldRow],
						Map[GroupBy[#, Key["object"], Lookup["field"]] &,
							GroupBy[First[debugData], Key["source"]]
						]
					]
				]
			]
		]
	];

	(* provide too big field message *)
	If[Length[oversizedFields] > 0,
		groupedOversizedFields=Merge[splitApplyCombine["object", Identity, First[oversizedFields]], Identity];
		If[Not[NullQ[groupedOversizedFields]] && Length[Lookup[groupedOversizedFields, "object", {}]] > 0,
			Message[Download::FieldTooLarge, groupedOversizedFields[["field"]], groupedOversizedFields[["object"]]]
		];
	];

	clearProgressMessage[];

	result
]];

(* patterns for collections of raw field inputs to Download *)

(* components of one atom *)
basicFieldP=Except[_List | _Packet | _Hold] | _Field;
basicPacketP=Packet[basicFieldP...];

(* one atom *)
fieldAtomP=basicFieldP | basicPacketP;
fieldAtomPlusP=fieldAtomP | List[basicFieldP...];
(*
	When there's time to find users of the cases with {{fieldAtomPlusP...}...},
	we should remove that pattern and end support for {{ {A,B} }},
	instead limiting things to {{ Field[{A,B}] }}.
*)

(* a pattern for conditions (list and lists of lists of these are inline) *)
conditionP=Except[_List | _Hold];

(* a pattern for collections of traversals *)
traversalAtomP=_Traversal | Packet[___Traversal];
traversalSequenceP=traversalAtomP | {traversalAtomP...} | {{traversalAtomP...}...};

(*Null input cases*)
Download[Null, traversalSequenceP, OptionsPattern[]]:=Null;
Download[nulls:{Null..}, traversalSequenceP, OptionsPattern[]]:=nulls;

(*Only objects which already have IDs can have all of Type/ID/Object computed locally *)
objectOrModelWithIDP=(Object | Model)[__Symbol, _String?(StringMatchQ[#, "id:"~~__]&)];

(*
	Fast overloads for known local field downloads.
	Replacement functionality for objectToType & LinkToObject
*)
Download[objectOrLink:objectOrModelWithIDP | Link[objectOrModelWithIDP, ___] | Null | $Failed, Object | Field[Object] | Traversal[Object], OptionsPattern[]]:=linkToObject[objectOrLink];
Download[objectsOrLinks:{(objectOrModelWithIDP | Link[objectOrModelWithIDP, ___] | Null | $Failed)...}, Object | Field[Object] | Traversal[Object], OptionsPattern[]]:=linkToObject[objectsOrLinks];

Download[objectOrLink:objectP | modelP | linkP | Null | $Failed, Type | Field[Type] | Traversal[Type], OptionsPattern[]]:=objectToType[
	linkToObject[objectOrLink]
];
Download[objectsOrLinks:{(objectP | modelP | linkP | Null | $Failed)...}, Type | Field[Type] | Traversal[Type], OptionsPattern[]]:=objectToType[
	linkToObject[objectsOrLinks]
];

Download[objectOrLink:objectOrModelWithIDP | Link[objectOrModelWithIDP, ___] | Null | $Failed, ID | Field[ID] | Traversal[ID], OptionsPattern[]]:=If[MatchQ[objectOrLink, Null | $Failed],
	objectOrLink,
	Last[linkToObject[objectOrLink]]
];
Download[objectsOrLinks:{(objectOrModelWithIDP | Link[objectOrModelWithIDP] | Null | $Failed)...}, ID | Field[ID] | Traversal[ID], OptionsPattern[]]:=Map[
	If[MatchQ[#, Null | $Failed],
		#,
		Last[#]
	]&,
	linkToObject[objectsOrLinks]
];

(* packet-specific overloads *)
Download[objectPackets:(KeyValuePattern[Object->_]|{KeyValuePattern[Object->_]..}), Object | Field[Object] | Traversal[Object], OptionsPattern[]]:=Lookup[objectPackets,Object];
Download[objectPackets:(KeyValuePattern[Type->_]|{KeyValuePattern[Type->_]..}), Type | Field[Type] | Traversal[Type], OptionsPattern[]]:=Lookup[objectPackets,Type];
Download[objectPackets:(KeyValuePattern[ID->_]|{KeyValuePattern[ID->_]..}), ID | Field[ID] | Traversal[ID], OptionsPattern[]]:=Lookup[objectPackets,ID];

inputWithIdP=objectOrModelWithIDP | linkP;
inputWithIdOrNullP=inputWithIdP | Null | $Failed;


(* Empty or only-default _Packet(s) *)
defaultPacketHeadP=Packet[Alternatives[
	Object | Type | ID,
	Field[Object | Type | ID],
	Traversal[Object | Type | ID]
]...];

Download[input:inputWithIdP, fields:defaultPacketHeadP, ops:OptionsPattern[]]:=With[
	{resolvedObj=linkToObject[input]},
	(* output is one packet *)
	<|
		Object -> resolvedObj,
		Type -> objectToType[resolvedObj],
		ID -> Last[resolvedObj]
	|>
];

Download[input:inputWithIdP, fields:{defaultPacketHeadP..}, ops:OptionsPattern[]]:=With[
	{},
	(* output is length of fields *)
	Map[Download[input, #, ops]&, fields]
];

Download[input:{inputWithIdOrNullP..} | {{inputWithIdOrNullP..}..}, fields:defaultPacketHeadP, ops:OptionsPattern[]]:=With[
	{},
	(* output is length of inputs *)
	Map[Download[#, fields, ops]&, input]
];

Download[input:{inputWithIdOrNullP..} | {{inputWithIdOrNullP..}..}, fields:{defaultPacketHeadP..}, ops:OptionsPattern[]]:=With[
	{},
	If[Length[input] =!= Length[fields],
		Message[Download::MapThread, "Objects", Length[input], "Fields", Length[fields]];
		Return[$Failed]
	];
	(* output is length of inputs AND of fields *)
	MapThread[Download[#1, #2, ops]&, {input, fields}]
];



(*Evaluated any symbols with values inside the field input expressions if they are not already
proper field expressions. This allows passing variables like myFields to Download without having
to worry about Evaluate.*)
Download[
	inputs:downloadInputP | {downloadInputP...} | {{downloadInputP...}...},
	fields:Except[traversalSequenceP],
	ops:OptionsPattern[]
]:=Module[
	{newFields, conditions},

	newFields=ReplaceAll[
		Hold[fields],
		{
			sym_Symbol?ValueQ :> RuleCondition[sym],
			Packet[(Object | Type | ID)...] :> Packet[Object, Type, ID]
		}
	];
	conditions=emptyConditions @@ newFields;

	Apply[
		Download,
		Join[Hold[inputs], newFields, Hold[Evaluate[conditions]], Hold[ops]]
	]
]/;Length[Position[Hold[fields], _Symbol?ValueQ]] > 0;
Download[
	inputs:downloadInputP | {downloadInputP...} | {{downloadInputP...}...},
	fields:Except[traversalSequenceP],
	conditions:Except[_List] | _List | {___List},
	ops:OptionsPattern[]
]:=With[
	{
		newFields=ReplaceAll[
			Hold[fields],
			{
				sym_Symbol?ValueQ :> RuleCondition[sym],
				Packet[(Object | Type | ID)...] :> Packet[Object, Type, ID]
			}
		]
	},

	Apply[
		Download,
		Join[Hold[inputs], newFields, Hold[conditions], Hold[ops]]
	]
]/;Length[Position[Hold[fields], _Symbol?ValueQ]] > 0;

(*[obj,{{field}},{{condition}}]*)
Download[input:downloadInputP, fields:{{fieldAtomPlusP...}...}, ops:OptionsPattern[]]:=With[
	{},
	downloadPacketDefaults[input, fields, ops]
];
Download[input:downloadInputP, fields:{{fieldAtomPlusP...}...}, conditions:{{conditionP...}...}, ops:OptionsPattern[]]:=With[
	{convertedFields=convertFields[fields, conditions]},

	If[TrueQ[$FastDownload], Return[GoLink`Private`NativeDownload[input, fields, conditions, ops]]];

	If[FailureQ[convertedFields],
		$Failed,
		downloadRules[Map[input -> #&, convertedFields], ops]
	]
];


(*[obj,{field},{condition}]*)
Download[input:downloadInputP, fields:{fieldAtomP...}, ops:OptionsPattern[]]:=With[
	{},
	downloadPacketDefaults[input, fields, ops]
];
Download[input:downloadInputP, fields:{fieldAtomP...}, conditions:{conditionP...}, ops:OptionsPattern[]]:=With[
	{convertedFields=convertFields[fields, conditions]},

	If[TrueQ[$FastDownload], Return[GoLink`Private`NativeDownload[input, fields, conditions, ops]]];

	If[FailureQ[convertedFields],
		$Failed,
		downloadRules[input -> convertedFields, ops]
	]
];


(*[obj,field,condition]*)
Download[input:downloadInputP, field:fieldAtomP, ops:OptionsPattern[]]:=Download[input, field, None, ops];
Download[input:downloadInputP, field:fieldAtomP, condition:conditionP, ops:OptionsPattern[]]:=With[
	{convertedField=convertFields[field, condition]},

	If[TrueQ[$FastDownload], Return[GoLink`Private`NativeDownload[input, field, condition, ops]]];

	If[FailureQ[convertedField],
		$Failed,
		downloadRules[input -> convertedField, ops]
	]
];

(*[{obj},{{field}},{{condition}}]*)
Download[inputs:{downloadInputP...}, fields:{{fieldAtomPlusP...}...}, ops:OptionsPattern[]]:=With[
	{},
	downloadPacketDefaults[inputs, fields, ops]
];
Download[inputs:{downloadInputP...}, fields:{{fieldAtomPlusP...}...}, conditions:{{conditionP...}...}, ops:OptionsPattern[]]:=With[
	{convertedFields=convertFields[fields, conditions]},

	If[Length[inputs] =!= Length[convertedFields],
		Message[Download::MapThread, "Objects", Length[inputs], "Fields", Length[convertedFields]];
		Return[$Failed]
	];

	If[TrueQ[$FastDownload], Return[GoLink`Private`NativeDownload[inputs, fields, conditions, ops]]];

	If[FailureQ[convertedFields],
		$Failed,
		downloadRules[MapThread[Rule, {inputs, convertedFields}], ops]
	]
];

(*[{obj},{field},{condition}]*)
Download[inputs:{downloadInputP...}, fields:{fieldAtomP...}, ops:OptionsPattern[]]:=With[
	{},
	downloadPacketDefaults[inputs, fields, ops]
];
Download[inputs:{downloadInputP...}, fields:{fieldAtomP...}, conditions:{conditionP...}, ops:OptionsPattern[]]:=With[
	{convertedFields=convertFields[fields, conditions]},

	If[TrueQ[$FastDownload], Return[GoLink`Private`NativeDownload[inputs, fields, conditions, ops]]];

	If[FailureQ[convertedFields],
		$Failed,
		downloadRules[Map[# -> convertedFields &, inputs], ops]
	]
];

IncrementPerDownloadIdCasCounter[]:=If[TrueQ[enableIdCasAssoc],
	(* reset cas cache if root download *)
	If[MatchQ[idCasAssociationDownloadCounter, 0], idCasAssociation=<||>];
	idCasAssociationDownloadCounter + 1
];

IsRootDownload[]:=MatchQ[idCasAssociationDownloadCounter, 1];

(*[{obj},field,condition]*)
Download[inputs:{downloadInputP...}, field:fieldAtomP, ops:OptionsPattern[]]:=Download[inputs, field, None, ops];
Download[inputs:{downloadInputP...}, field:fieldAtomP, condition:conditionP, ops:OptionsPattern[]]:=With[
	{convertedField=convertFields[field, condition]},

	If[TrueQ[$FastDownload], Return[GoLink`Private`nativeDownloadWithPagination[inputs, field, condition, ops]]];

	If[FailureQ[convertedField],
		$Failed,
		downloadRules[Map[# -> convertedField &, inputs], ops]
	]
];

(*[{{obj}},{{field}},{{condition}}]*)
Download[inputs:{{downloadInputP...}...}, fields:{{fieldAtomPlusP...}...}, ops:OptionsPattern[]]:=With[
	{},
	downloadPacketDefaults[inputs, fields, ops]
];
Download[inputs:{{downloadInputP...}...}, fields:{{fieldAtomPlusP...}...}, conditions:{{conditionP...}...}, ops:OptionsPattern[]]:=Module[
	{convertedFields, inputRules, result},
	If[TrueQ[$FastDownload], Return[GoLink`Private`nativeDownloadWithPagination[inputs, fields, conditions, ops]]];

	convertedFields=convertFields[fields, conditions];
	If[FailureQ[convertedFields],
		Return[$Failed]
	];

	If[Length[inputs] =!= Length[convertedFields],
		Message[Download::MapThread, "Objects", Length[inputs], "Fields", Length[convertedFields]];
		Return[$Failed]
	];

	inputRules=Apply[
		Join,
		MapThread[
			Function[{inputList, fieldList},
				Map[
					# -> fieldList&,
					inputList
				]
			],
			{inputs, convertedFields}
		]
	];

	result=downloadRules[inputRules, ops];

	If[result =!= $Failed,
		With[
			{
				replacements=MapThread[
					Rule,
					{inputPositions[inputs], result}
				]
			},
			ReplacePart[inputs, replacements]
		],
		$Failed
	]
];

(*[{{obj}},{field},{condition}]*)
Download[inputs:{{downloadInputP...}...}, fields:{fieldAtomP...}, ops:OptionsPattern[]]:=With[
	{},
	downloadPacketDefaults[inputs, fields, ops]
];
Download[inputs:{{downloadInputP...}...}, fields:{fieldAtomP...}, conditions:{conditionP...}, ops:OptionsPattern[]]:=Module[
	{convertedFields, result},

	If[TrueQ[$FastDownload], Return[GoLink`Private`nativeDownloadWithPagination[inputs, fields, conditions, ops]]];

	convertedFields=convertFields[fields, conditions];
	If[FailureQ[convertedFields],
		Return[$Failed]
	];

	result=downloadRules[Map[# -> convertedFields &, Join @@ inputs], ops];

	If[result =!= $Failed,
		With[
			{
				replacements=MapThread[
					Rule,
					{inputPositions[inputs], result}
				]
			},
			ReplacePart[inputs, replacements]
		],
		$Failed
	]
];

(*[{{obj}},field,condition]*)
Download[inputs:{{downloadInputP...}...}, field:fieldAtomP, ops:OptionsPattern[]]:=Download[inputs, field, None, ops];
Download[inputs:{{downloadInputP...}...}, field:fieldAtomP, condition:conditionP, ops:OptionsPattern[]]:=Module[
	{convertedField, result},

	If[TrueQ[$FastDownload], Return[GoLink`Private`nativeDownloadWithPagination[inputs, field, condition, ops]]];

	convertedField=convertFields[field, condition];
	If[FailureQ[convertedField],
		Return[$Failed]
	];

	result=downloadRules[Map[# -> convertedField &, Flatten[inputs]], ops];
	If[result === $Failed,
		$Failed,
		With[
			{
				replacements=MapThread[
					Rule,
					{inputPositions[inputs], result}
				]
			},

			ReplacePart[inputs, replacements]
		]
	]
];

(* counter used to tag repeated traversals *)
(* to later associate them with the server's response *)
OnLoad[repeatedTag=0];

(** Returns Traversals or $Failed and provides messages for bad fields and conditions **)
convertFields[fields:_, conditions:_]:=Module[
	{convertedFields, unmatchedSearches, invalidSearches, redundantFields},

	{convertedFields, {unmatchedSearches, invalidSearches, redundantFields}}=Reap[
		toTraversals[fields, conditions],
		{"search-mismatch", "invalid-search", "RedundantField"}
	];

	If[convertedFields === $Failed,
		Return[$Failed]
	];

	If[Length[redundantFields] > 0,
		Message[Download::RedundantField, DeleteDuplicates[Flatten[redundantFields]]]
	];

	If[Length[unmatchedSearches] > 0,
		With[{withoutDuplicates=DeleteDuplicates[unmatchedSearches[[1]]]},
			If[!TrueQ[$FastDownload],
				Message[
					Download::UnusedSearchConditions,
					withoutDuplicates[[All, 2]],
					deferFields[withoutDuplicates[[All, 1]]]
				]
			];
		]
	];

	(* TODO: remove deferFields *)
	If[Length[invalidSearches] > 0,
		With[
			{withoutDuplicates=DeleteDuplicates[invalidSearches[[1]]]},
			Message[
				Download::InvalidSearch,
				withoutDuplicates[[All, 2]],
				deferFields[withoutDuplicates[[All, 1]]]
			];
			Return[$Failed]
		]
	];

	convertedFields
];

SetAttributes[convertFields, HoldAll];


(*Converts raw inputs to Download to Traversal Sequences (Traversal head expressions). Need to ensure
non-evaluation so none of the search inequalities evaluate or any Part expressions/functions
in the field specifications evaluate. Sows any field/condition pairs where the condition is
not None and the Traversal has no Repeated (so messages can be thrown in Download).*)
Authors[toTraversals]:={"platform"};

toTraversals[fields:{{fieldAtomPlusP...}...}, conditions:{{conditionP...}...}]:=If[
	Length[Unevaluated[fields]] =!= Length[Unevaluated[conditions]],
	If[!TrueQ[$FastDownload],
		(
			Message[
				Download::MapThread,
				"Fields",
				Length[Unevaluated[fields]],
				"Search Conditions",
				Length[Unevaluated[conditions]]
			];
			$Failed
		)
	],
	Module[
		{heldFields, mappableFields},

		heldFields=holdingMap[Hold, fields, {2}];

		(* replace traversal-field-lists with _Field *)
		mappableFields=Replace[
			heldFields,
			Verbatim[Hold][items_List] :> Field[items],
			{2}
		];

		holdingMapThread[toTraversals, {mappableFields, conditions}]
	]
];
toTraversals[fields:{fieldAtomP...}, conditions:{conditionP...}]:=If[
	Length[Unevaluated[fields]] =!= Length[Unevaluated[conditions]],
	If[!TrueQ[$FastDownload],
		(
			Message[
			Download::MapThread,
			"Fields",
			Length[Unevaluated[fields]],
			"Search Conditions",
			Length[Unevaluated[conditions]]
		];
		$Failed
		)
	],
	holdingMapThread[toTraversals, {fields, conditions}]
];
toTraversals[field:basicPacketP, condition:conditionP]:=Module[
	{subfields},

	(* below we'll want to re-apply the Packet head but for now we take it off *)
	subfields=holdingMap[Hold, field];

	If[MemberQ[Unevaluated[field], _Length],
		Missing["PacketLength", Defer[field]],

		(* when there's a packet head, convert things to a traversal with a packet target *)
		addPacketToTraversal[ReleaseHold[Map[
			toTraversals[#, Unevaluated[condition]]&,
			subfields
		]]]
	]
];
(* everything else in toTraversals goes through this case *)
toTraversals[field:basicFieldP, condition:conditionP]:=nestSearchCondition[
	Traversal[field],
	condition
];
SetAttributes[toTraversals, HoldAll];

(*Nest the search condition inside the Repeated expression of the Traversal.
Sow this field/condition pair if there is no repeated so a warning can be thrown
in Download.*)
nestSearchCondition[field_Traversal, None]:=field;
nestSearchCondition[field_Traversal, condition:conditionP]:=With[
	{
		stringCondition=Quiet[
			searchClauseString[condition, DeveloperObject -> True],
			{Search::InvalidSearchQuery, Search::InvalidSearchValues}
		]
	},

	If[stringCondition === $Failed,
		Sow[{field, HoldForm[condition]}, "invalid-search"];
		Return[field]
	];

	If[!MemberQ[field, _Repeated],
		(
			Sow[{field, HoldForm[condition]}, "search-mismatch"];
			field
		),
		Replace[
			field,
			Verbatim[Repeated][x__] :> Repeated[x, stringCondition],
			{1}
		]
	]
];
SetAttributes[nestSearchCondition, HoldRest];

emptyConditions[fields:{{fieldAtomPlusP...}...}]:=With[
	{heldConditions=ReleaseHold[Apply[Hold, Hold[fields], {2}]]},

	Map[
		Table[None, Length[#]]&,
		heldConditions
	]
];
emptyConditions[fields:{fieldAtomP...}]:=Table[None, Length[Unevaluated[fields]]];
emptyConditions[field:fieldAtomP]:=None;
emptyConditions[_]:=None;
SetAttributes[emptyConditions, HoldAll];
(* call download while expending default packet heads (e.g., Packet[]) and default conditions *)
downloadPacketDefaults[inputs_, fields_, ops:OptionsPattern[]]:=Module[
	{newFields, conditions},

	newFields=ReplaceAll[
		Hold[fields],
		Packet[(Object | Type | ID)...] :> Packet[Object, Type, ID]
	];
	conditions=emptyConditions @@ newFields;

	Apply[
		Download,
		Join[Hold[inputs], newFields, Hold[Evaluate[conditions]], Hold[ops]]
	]
];
SetAttributes[downloadPacketDefaults, HoldAll];

SetAttributes[inputPositions, HoldAll];
inputPositions[inputs:{___List}]:=Apply[
	Join,
	MapIndexed[#2&, inputs, {2}]
];

referenceToDownloadRule[
	(head:Object | Model)[
		type:Repeated[_Symbol, {1, 5}],
		id:_String,
		symbol:_Symbol,
		column:_Integer
	]
]:=head[type, id] -> Traversal[Query[Key[symbol], All, column]];

referenceToDownloadRule[
	(head:Object | Model)[
		type:Repeated[_Symbol, {1, 5}],
		id:_String,
		symbol:_Symbol,
		column:_Symbol
	]
]:=head[type, id] -> Traversal[Query[Key[symbol], All, Key[column]]];

referenceToDownloadRule[
	(head:Object | Model)[
		type:Repeated[_Symbol, {1, 5}],
		id:_String,
		symbol:_Symbol
	]
]:=head[type, id] -> Traversal[symbol];

(*Need to hold field inputs for download-through-links syntax*)
SetAttributes[Download, HoldRest];
SetAttributes[downloadRules, HoldRest];

(** how many times have we run a Download **)
OnLoad[downloadCounter=0];

(*Expects a list of rules from download inputs to the fields requested per object. This supports both
the MapThread version of Download[objects,{fields,fields,..}] and the version which Downloads the
same fields from each object.*)
downloadRuleValueP=_Traversal | {___Traversal} | _Missing;

downloadRules[inputs:{(downloadInputP -> downloadRuleValueP)...}, ops:OptionsPattern[Download]]:=TraceExpression["Download", Module[{verbose, cacheMisses, limit, ignoreTimeOption, cacheOption, explicitCache,
	fullCache, squashResponses, downloadedObjects, originalOptions, defaultedOptions, existingMissingCacheFields,

	noSimulationMissingCacheFields, inputsWithIds, returnValue, invalidLengths, doesntExist, missingFields, cycles, notLinks, inclusiveSearch,
	debugData, missingObjects, badPackets, fieldRequestsWithIDs, cacheMissesInitialInput, missingCacheFields,
	partErrors, expandedExplicitCache, initialExplicitCache, groupedMissingFields, cacheMissesAllHaveIDs, dateOption, mergedSimulationAndCache, simulatedObjects,
	flattenedSimulationAndCache, explicitSimulation, dateOptionIsNow, temporalLinkPackets, responseList, temporalLinkPositions, inputsWithIdsNoLinks, fieldRequestDates,
	qaByteLimitOption, oversizedFields, groupedOversizedFields, explicitCacheObjects, missingObjectsWithoutSimulatedObjects
},

	If[!loggedInQ[],
		Message[Download::NotLoggedIn];
		Return[$Failed]
	];

	(* Block automatically decrements idCasAssociationDownloadCounter *)
	Block[{idCasAssociationDownloadCounter=IncrementPerDownloadIdCasCounter[]},
		downloadCounter+=1;

		(* Collect missing traversals, and message on why they are missing *)
		(* TODO: currently used only for PacketLength errors - this is too general for one error *)
		(* Jared is hoping to coerce most field and search related errors into this form *)
		badPackets=GroupBy[
			Cases[inputs, Missing["PacketLength", _], {0, Infinity}],
			First -> Last
		];

		KeyValueMap[Message[MessageName[Download, #1], #2] &, badPackets];

		originalOptions=ToList[ops];
		defaultedOptions=OptionDefaults[Download, ToList[ops]];

		verbose=Lookup[defaultedOptions, "Verbose"];
		inclusiveSearch=Lookup[defaultedOptions, "HaltingCondition"] === Inclusive;
		If[MatchQ[verbose, True | Cache],
			printProgressMessage["Downloading objects from Constellation"];
		];

		(* Use an artificially large limit until pagination is implemented.*)
		cacheOption=Lookup[defaultedOptions, "Cache"];
		squashResponses=Lookup[defaultedOptions, "SquashResponses"];
		limit=Lookup[defaultedOptions, "PaginationLength"];
		ignoreTimeOption=Lookup[defaultedOptions, "IgnoreTime"];
		qaByteLimitOption=Lookup[defaultedOptions, "BigQuantityArrayByteLimit"] /. None -> Infinity;

		(* Only trust these options if the Download wasn't called from within Download*)
		{timeIgnored, qaByteLimit}=If[IsRootDownload[],
			{ignoreTimeOption, adjustedByteLimit[qaByteLimitOption, originalOptions]},
			{timeIgnored, qaByteLimit}
		];

		(*Add repeat session counter to each repeated request*)
		inputsWithIds=ReplaceAll[
			inputs,
			Verbatim[Repeated][x___] :> RuleCondition[Repeated[x, ToString[repeatedTag++]]]
		];

		dateOptionIsNow=ContainsAny[Cases[HoldForm[ops], (Verbatim[Rule][Date, x_]) :> Hold[x]],
			{Hold[Now]}];

		(*In order to keep things in proper order, we create an ordering on the inputs*)
		responseList=Keys@inputsWithIds;

		temporalLinkPackets={};
		temporalLinkPositions={};
		(* Date Option as Now is treated as No Date Option and no overriding happens on Temporal Links *)

		If[!dateOptionIsNow && MatchQ[ignoreTimeOption, False],
			(* Now that we have our field requests, handle date here before dealing with the cache*)
			(* It should be safe not to use defaulted options because we know what the default should be *)
			dateOption=FirstCase[HoldForm[ops], (Verbatim[Rule][Date, x_]) :> Hold[x], None];
			(* Add dates to any potential temporal downloads *)
			dateOption=preProcessDateOption[Keys@inputsWithIds, dateOption];,
			dateOption=Array[None&, Length[inputsWithIds]];
		];

		If[MatchQ[dateOption, $Failed],
			Message[Download::DateMismatch];
			Return[$Failed]
		];

		(* There is a 1-to-1 mapping between dateOptions and inputsWithIds*)
		(* When building fieldRequestWithIDs, make sure to keep the date of them *)
		{fieldRequestsWithIDs, fieldRequestDates}=generateFieldRequests[inputsWithIds, dateOption];


		temporalLinkPositions=MatchQ[temporalLinkP] /@ Keys@inputsWithIds;

		(* Find all fields which are not in the cache (multiple fields).*)
		(* If we have an explicit simulation or global simulation in change packet form, call UpdateSimulation to get rid of the change packets. *)
		explicitSimulation=processExplicitSimulation[defaultedOptions];

		(* Combine our explicit simulation, global simulation, and explicit cache -- in that priority order. *)
		(* Replace Null with a placeholder, because the next bit of simulation/cache merging doesn't handle nulls *)
		flattenedSimulationAndCache=Cases[
			Flatten[{
				If[MatchQ[explicitSimulation, SimulationP],
					Lookup[explicitSimulation[[1]], Packets],
					Nothing
				],
				If[MatchQ[$Simulation, True],
					Lookup[$CurrentSimulation[[1]], Packets],
					Nothing
				],
				If[MatchQ[cacheOption, _List],
					messageBadCachePackages[cacheOption];
					cacheOption,
					Nothing
				]
			}],
			Except[Null]
		];

		(* This merge will enforce the explicit simulation, global simulation, explicit cache order. *)
		mergedSimulationAndCache=Merge[#, First]& /@ GatherBy[flattenedSimulationAndCache, {Lookup[#, Object], Lookup[#, DownloadDate]}&];

		(* Lookup from the SimulatedObjects field of the simulation which objects are in the database and which are not *)
		simulatedObjects=Flatten[{
			If[MatchQ[explicitSimulation, SimulationP],
				Lookup[explicitSimulation[[1]], SimulatedObjects],
				Nothing
			],
			If[MatchQ[$Simulation, True],
				Lookup[$CurrentSimulation[[1]], SimulatedObjects],
				Nothing
			]
		}];

		initialExplicitCache=makeExplicitCache[mergedSimulationAndCache, Object -> False];

		(* Convert names to IDs if we have them *)
		explicitCache=KeyMap[cacheObjectID, initialExplicitCache];

		(* prepare the input to this big RightComposition call *)
		cacheMissesInitialInput=objectRequestsAssociation[fieldRequestsWithIDs, fieldRequestDates];

		(* if we are Downloading from a packet without the Object field populated, then we should add a placeholder ID/Object field to it (and probably drop it later?) *)
		cacheMissesAllHaveIDs=KeyMap[
			If[MatchQ[First[#], _Association] && MissingQ[Lookup[First[#], Object]],
				{Append[First[#], Object -> Append[Lookup[First[#], Type], "id:placeholder "<>ToString[Unique[]]]], Last[#]},
				#
			]&,
			cacheMissesInitialInput
		];

		(* NOTE: The general gist of this RightComposition call is that we start with a list of all of the valid fields *)
		(* that have been requested by the user. We keep applying filters on this list to narrow it down, until we have *)
		(* our final list of fields that we have to fetch from the server. *)
		(* need to sow the missing cache field message here because otherwise we can't do it later *)
		{cacheMisses, missingCacheFields}=Reap[
			RightComposition[
				(* NOTE: Remove the fields that come from an object where we're given a packet directly as input since we don't *)
				(* talk to the database in this case. We will sow "missing-cache-fields" if we can't find a field. *)
				AssociationMap[filterPacketFieldsWithDate],

				(* NOTE: filterExplicitFields[explicitCache] will return a function that will filter through our list of field traversals *)
				(* and remove the ones that are in the explicit cache already. *)
				(* No idea why this is an iterative FixedPoint though -- the whole object overload above doens't have filterExplicitFields *)
				(* in a FixedPoint. *)
				FixedPoint[filterExplicitFieldsWithDate[explicitCache], #] &,

				(* NOTE: Removes all fields which can be computed locally. For objects with IDs, these are Object/ID/Type. For objects with *)
				(* names, this is only Type. *)
				filterLocalFieldsWithDate,

				(* NOTE: Do not filter session cached fields if Cache->Download *)
				If[MatchQ[cacheOption, Download],
					Identity,
					(* NOTE: Filters out all fields for objects which are already in the session cache and are not _RuleDelayed (computable/long multiples).*)
					filterSessionCachedFieldsWithDate[#, objectCache] &
				],

				(* NOTE: fetchCASTokens will append "CAS" and "Limit" keys to all object request associations by contacting the server *)
				(* and asking for the latest CAS tokens for our objects. *)
				fetchCASTokens[#, None]&,

				(* NOTE: filterCachedFields will filter out fields from our request for which we have a value in the objectCache *)
				(* already and the CAS for that entry in the objectCache is up to date with the CAS token that we just got back from *)
				(* fetchCASTokens. *)
				filterCachedFieldsWithDate[#, objectCache] &
			][cacheMissesAllHaveIDs],
			"missing-cache-fields"
		];

		(* Split date and non-date requests *)
		(* Fetch all field values not in the cache *)
		downloadedObjects=fetchAndCacheFields[cacheMisses, limit, inclusiveSearch, ignoreTimeOption, squashResponses];

		missingObjects=GroupBy[Cases[downloadedObjects, _Missing], Last -> First];

		explicitCacheObjects=Keys[explicitCache][[All, 1]];

		missingObjectsWithoutSimulatedObjects=If[KeyMemberQ[missingObjects, "NotFound"],
			Complement[missingObjects[["NotFound"]], Join[simulatedObjects, explicitCacheObjects]],
			{}
		];

		If[Length[missingObjectsWithoutSimulatedObjects] > 0,
			Message[Download::ObjectDoesNotExist, missingObjectsWithoutSimulatedObjects]
		];

		If[KeyMemberQ[missingObjects, "TypeMismatch"],
			Message[Download::MismatchedType,
				Map[objectToId, missingObjects["TypeMismatch"]],
				Map[objectToType, missingObjects["TypeMismatch"]]
			]
		];

		(*Throw a message if there was an error making the web request*)
		If[MatchQ[downloadedObjects, _HTTPError],
			Message[Download::NetworkError, Last[downloadedObjects]];
			Return[$Failed];
		];

		(*TODO: ensure expanded explicit cache does not have names (ids only) *)
		(* expand the explicitCache to include whatever we've got in the objectCache, and then combine it with the rest of the objectCache to get the fullCache*)
		(* also add the $Failed values in here for things we don't have already IF the object doesn't exist or has a type mismatch *)
		(* also since for some reason if the value is Null the server just doesn't return it at all *)
		(* ALSO if obj is a named object, need to use cacheObjectID to convert it to the ID form; need to do this here even though we did it above because this is AFTER we went to the database and we might know some IDs that we didn't before *)
		expandedExplicitCache=<|KeyValueMap[
			Function[{key, value},

				Which[
					(* The object in our explicit cache also exists in the global cache. *)
					KeyExistsQ[objectCache, key],
					(* NOTE: Prefer fields in the explicit cache over fields in the global cache. *)
					<|
						key -> <|
							"Fields" -> <|
								Lookup[Lookup[objectCache, Key[key]], "Fields"],
								Lookup[value, "Fields"]
							|>
						|>
					|>,
					(* If the object doesn't exist or there's a type mismatch, put $Faileds in there -- regardless of whether there *)
					(* is anything in the objectCache *)
					MemberQ[missingObjects[["NotFound"]], key] || MemberQ[missingObjects[["TypeMismatch"]], key],
					<|
						key -> <|
							"Fields" -> <|
								<|Map[
									Traversal[#] -> <|"Rule" -> # -> $Failed, "Limit" -> None, "DownloadCount" -> "ExplicitCache"|>&,
									Fields[objectToType[key], Output -> Short]
								]|>,
								Lookup[Lookup[objectCache, Key[key], <||>], "Fields", <||>],
								Lookup[value, "Fields", <||>]
							|>
						|>
					|>,
					(* Otherwise, just use what we got from our explicit cache. *)
					True,
					<|key -> value|>
				]
			],
			explicitCache
		]|>;

		(*
		   This will overwrite any object entries in the global cache blindly from our combined cache that we just made up above.
		   Remember that things in the object cache are preferred over the global cache.
		   Furthermore, Temporal Objects are not a part of the global cache.
		*)

		fullCache=<|objectCache, expandedExplicitCache|>;

		inputsWithIdsNoLinks=Replace[
			inputsWithIds,
			{
				Rule[link:linkP, fields_] :> Rule[linkToObject[link], fields]
			},
			{0, 1}
		];


		(* If either the debug global is set or Verbose -> Cache, collect cache source information *)
		Block[{$DebugDownload=Or[TrueQ[$DebugDownload], verbose === Cache]},
			{
				returnValue,
				{invalidLengths, doesntExist, missingFields, cycles, partErrors, oversizedFields, debugData}
			}=Reap[
				MapThread[
					(*
						If it's a temporal link, only go to the object cache.
						Iff the historical value does not exist in the DB, then check out the fullcache
					*)
					If[#3 && cacheKeyExistsQ[#1[[1]], #2, objectCache],
						getCacheValue[cacheObjectID[#1[[1]]], #2, #1[[2]], objectCache],
						getCacheValue[cacheObjectID[#1[[1]]], #2, #1[[2]], fullCache]
					]&,
					{inputsWithIdsNoLinks, dateOption, temporalLinkPositions}
				],
				{"length-error", "doesnt-exist", "missing-field", "cycle", "part-error", "too-big", "debugData"}
			];

			If[$DebugDownload && Length[debugData] > 0,
				KeyValueMap[printCacheRows,
					Map[KeyValueMap[fieldRow],
						Map[GroupBy[#, Key["object"], Lookup["field"]] &,
							GroupBy[First[debugData], Key["source"]]
						]
					]
				]
			]
		]
	];

	{returnValue, {notLinks}}=Reap[
		MapThread[
			removeInvalidLinks[#1, #2]&,
			{Values[inputsWithIds], returnValue}
		],
		{"not-link"}
	];

	(* get the missing field messages for real *)
	(* need to do some wacky shit because if the object doesn't actually exist or there's a type mismatch, we are going to cross wires where Download above would have thought we were going to be $Failed when really we're not *)
	groupedMissingFields=If[Length[missingFields] > 0,
		With[
			{grouped=Merge[
				splitApplyCombine["object", Identity, First[missingFields]],
				Identity
			]},
			<|
				"object" -> Cases[Lookup[grouped, "object"], Except[Alternatives @@ Flatten[{missingObjects[["NotFound"]], missingObjects[["TypeMismatch"]]}]]],
				(* since PickList is not visible to the Constellation context, need to use MapThread and implement it *)
				(* also Pick doesn't even work with Except (Pick[{a}, {b}, Except[b]] for some reason returns {a} when it should obviously return {})*)
				"field" -> MapThread[
					If[MatchQ[#2, Except[Alternatives @@ Flatten[{missingObjects[["NotFound"]], missingObjects[["TypeMismatch"]]}]]],
						#1,
						Nothing
					]&,
					{Lookup[grouped, "field"], Lookup[grouped, "object"]}
				]
			|>
		]

	];

	(* provide missing field message *)
	If[Not[NullQ[groupedMissingFields]] && Length[Lookup[groupedMissingFields, "object", {}]] > 0,
		Message[Download::MissingField, groupedMissingFields[["field"]], groupedMissingFields[["object"]]]
	];

	(* provide too big field message *)
	If[Length[oversizedFields] > 0,
		groupedOversizedFields=Merge[splitApplyCombine["object", Identity, First[oversizedFields]], Identity];
		If[Not[NullQ[groupedOversizedFields]] && Length[Lookup[groupedOversizedFields, "object", {}]] > 0,
			Message[Download::FieldTooLarge, groupedOversizedFields[["field"]], groupedOversizedFields[["object"]]]
		];
	];

	If[Length[partErrors] > 0,
		Message[
			Download::Part,
			partErrors[[1, All, "part"]],
			partErrors[[1, All, "field"]],
			partErrors[[1, All, "object"]]
		]
	];

	(* don't throw missing cache field errors for fields that already don't exist at all for the object *)
	(* it's faster to do this here than inside the FixedPoint call when the missing-cache-fields thing gets Sown *)
	existingMissingCacheFields=DeleteCases[missingCacheFields, Alternatives @@ (Join @@ doesntExist), Infinity] /. {{} -> Nothing};

	(* Do not throw missing cache field errors for objects that are coming from our explicit or global simulation. *)
	(* If a field does not exist in one of these simulations, it is intentional because we WANT download to check the database *)
	(* for the latest value. *)
	noSimulationMissingCacheFields=If[Length[missingCacheFields] > 0 && (MatchQ[$Simulation, True] || MatchQ[explicitSimulation, SimulationP]),
		Module[{objectsInSimulations},
			(* Collect all of the objects that are in our simulation. *)
			objectsInSimulations=Flatten[{
				If[MatchQ[explicitSimulation, SimulationP],
					Lookup[Lookup[explicitSimulation[[1]], Packets], Object],
					Nothing
				],
				If[MatchQ[$Simulation, True],
					Lookup[Lookup[$CurrentSimulation[[1]], Packets], Object],
					Nothing
				]
			}];

			(* NOTE: We COULD DeleteCases at level 1 if we flattened here, but I'm afraid to mess things up. *)
			DeleteCases[FirstOrDefault[existingMissingCacheFields, {}], {Alternatives @@ objectsInSimulations, _}, Infinity]
		],
		FirstOrDefault[existingMissingCacheFields, {}]
	];
	(* delete duplicates because it always duplicates things since these objects get Sown within FixedPoint, which runs again on the output until nothing changes (and thus the error gets sown twice) *)
	(* also only throw this message if we are a developer because we don't want users to see this or for it to fuck up protocols in the lab *)
	(* note that this WILL throw errors if a developer is running a protocol.  we are deciding that is ok because if that is happening you're testing anyway and want to find the bugs*)
	If[Length[noSimulationMissingCacheFields] > 0 && MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]],
		Message[Download::MissingCacheField, DeleteDuplicates[noSimulationMissingCacheFields[[All, 2]]], DeleteDuplicates[noSimulationMissingCacheFields[[All, 1]]]];
	];

	If[Length[invalidLengths] > 0,
		Message[Download::Length, invalidLengths[[1, All, 2]], invalidLengths[[1, All, 1]]]
	];

	If[Length[doesntExist] > 0,
		With[
			{
				grouped=Normal@GroupBy[
					doesntExist[[1]],
					First,
					#[[All, 2]]&
				]
			},
			Message[Download::FieldDoesntExist, grouped[[All, 2]], grouped[[All, 1]]]
		]
	];

	If[Length[cycles] > 0,
		With[
			{
				grouped=Normal@GroupBy[
					cycles[[1]],
					Last,
					#[[All, 1]]&
				]
			},
			Message[Download::Cycle, deferFields[grouped[[All, 1]]], grouped[[All, 2]]]
		]
	];

	If[Length[notLinks] > 0,
		With[
			{duplicateFree=DeleteDuplicates[notLinks[[1]]]},
			Message[Download::NotLinkField, deferFields[duplicateFree[[All, 1]]], duplicateFree[[All, 2]]]
		]
	];
	resizeCache[];

	clearProgressMessage[];

	Return[returnValue];

]];

processExplicitSimulation[defaultedOptions_]:=Module[{explicitSimulation},
	(* Find all fields which are not in the cache (multiple fields).*)
	(* If we have an explicit simulation or global simulation in change packet form, call UpdateSimulation to get rid of the change packets. *)
	explicitSimulation=Lookup[defaultedOptions, Simulation];

	If[MatchQ[explicitSimulation, SimulationP] && MatchQ[Lookup[explicitSimulation[[1]], Updated], False],
		explicitSimulation=UpdateSimulation[Simulation[], explicitSimulation];
	];

	(* If we have a global simulation and it is not updated, do the same thing to the global simulation. *)
	If[And[
		MatchQ[$Simulation, True],
		MatchQ[Lookup[$CurrentSimulation[[1]], Updated], False]
	],
		$CurrentSimulation=UpdateSimulation[Simulation[], $CurrentSimulation];
	];

	explicitSimulation
];


downloadRules[input:(downloadInputP -> downloadRuleValueP), ops:OptionsPattern[Download]]:=Module[
	{result},

	result=downloadRules[{input}, ops];

	If[FailureQ[result],
		$Failed,
		First[result]
	]
];

downloadRules[brokenInputs_, ops:OptionsPattern[Download]]:=With[
	{},
	(* TODO: we should probably reap and sow this and nerf it for users, but I want to see deets now. *)
	Message[downloadRules::RuleParsingFailure, HoldForm@brokenInputs];
	$Failed
];

(*Wraps PacketTarget around last element of the traversal specification. This should encompas
any Part expressions or lists of fields as well*)

(*Repeated specification with no following fields adds an empty PacketTarget*)
addPacketToTraversal[Packet[Verbatim[Traversal][first___, repeated_Repeated]]]:=Traversal[first, repeated, PacketTarget[{}]];

(*single field specification*)
addPacketToTraversal[Packet[Verbatim[Traversal][first_]]]:=Traversal[PacketTarget[{first}]];

addPacketToTraversal[Packet[Traversal[All]]]:=
		Traversal[PacketTarget[All]];

(*Packet of a set of fields*)
addPacketToTraversal[Packet[traversals:Verbatim[Traversal][_Symbol]...]]:=With[
	{symbols=Part[{traversals}, All, 1]},

	If[MemberQ[symbols, All],
		Sow[Packet @@ symbols, "RedundantField"]
	];

	Traversal[PacketTarget[symbols]]
];

(*Packet of set of traversals through links (invalid) *)
addPacketToTraversal[Packet[traversals___Traversal]]:=Traversal[PacketTarget[{traversals}]];

(*Traversal ending in all does not need PacketTarget wrapped around it as All returns all fields in a packet*)
addPacketToTraversal[Packet[Verbatim[Traversal][most__, All]]]:=Traversal[most, All];

(*Traversal through links ending in a single symbol or list thereof*)
addPacketToTraversal[Packet[Verbatim[Traversal][most__, last:_Symbol | {___Symbol}]]]:=With[
	{packetSymbols=ToList[last]},

	Traversal[most, PacketTarget[packetSymbols]]
];

(*If no patterns match, return input*)
addPacketToTraversal[fallThrough_]:=fallThrough;

resizeCache[]:=Module[
	{cacheLength, removeDelta, delta, toRemove},
	delta=ByteCount[objectCache] - $CacheSize;
	If[delta < 0,
		Return[Null]
	];
	cacheLength=Length[objectCache];
	toRemove=0;
	removeDelta=0;
	While[toRemove < cacheLength && removeDelta < delta,
		toRemove=toRemove + 1;
		removeDelta=removeDelta + ByteCount[objectCache[[toRemove]]];
	];
	ClearDownload[Take[Keys[objectCache], toRemove]]
];

(*Field Reference Overloads*)

(* Download an ObjectReference.
	 Converts to Object -> Field form and downloads. *)
Download[reference:fieldReferenceP, ops:OptionsPattern[]]:=First[
	downloadRules[{referenceToDownloadRule[reference]}, ops]
];

(* Download a list of ObjectReferences. *)
Download[references:{fieldReferenceP...}, ops:OptionsPattern[]]:=
		downloadRules[Map[referenceToDownloadRule, references], ops];

validFieldElementQ[Verbatim[Packet] | _Packet]:=False;
validFieldElementQ[PacketTarget[_Symbol | {___Symbol}]]:=True;
validFieldElementQ[_Symbol]:=True;
validFieldElementQ[
	Query[
		Key[_Symbol],
		Repeated[Alternatives[
			_Integer,
			Span[_Integer, _Integer],
			Key[_Symbol],
			All,
			{_Key ..},
			{_Integer ..}
		]]
	]
]:=True;
validFieldElementQ[Verbatim[Length][_]]:=True;
validFieldElementQ[list:{_Symbol ...} | {___Integer}]:=And @@ Map[validFieldElementQ, list];
validFieldElementQ[Verbatim[Repeated][
	field:_Traversal,
	_Integer | Infinity | {_Integer} | {_Integer, _Integer | Infinity} | PatternSequence[],
	_ | PatternSequence[],
	_String
]]:=validFieldSequenceQ[field];
validFieldElementQ[___]:=False;
validFieldElementQ[_Traversal]:=False;

(*Returns True if elements of the Traversal are what is to be expected and there is no _InvalidPart
expression at any level.*)
validFieldSequenceQ[field:Verbatim[Traversal][(_Symbol | _Repeated | _List | _PacketTarget | Verbatim[Length][_] | _Query) ..]]:=(
	And[
		And @@ Map[validFieldElementQ,
			(List @@ Map[Unevaluated, field])
		],
		Count[field, _Repeated, {0, Infinity}] < 2
	]
);

validFieldSequenceQ[_Traversal]:=False;


removeInvalidFields[Rule[input:downloadInputP, fields:{___Traversal}], invalidFields:{___Traversal}]:=Rule[
	input,
	Complement[fields, invalidFields]
];
removeInvalidFields[Rule[input:downloadInputP, field_Traversal], invalidFields:{___Traversal}]:=If[MemberQ[invalidFields, Verbatim[field]],
	Nothing,
	input -> field
];

removeInvalidFields[{Rule[input:downloadInputP, fields:{___Traversal}], date_}, invalidFields:{___Traversal}]:={Rule[
	input,
	Complement[fields, invalidFields]
], date};

removeInvalidFields[{Rule[input:downloadInputP, field_Traversal], date_}, invalidFields:{___Traversal}]:=If[MemberQ[invalidFields, Verbatim[field]],
	Nothing,
	{input -> field, date}
];

removeInvalidLinks[_Missing, values:_]:=values;
removeInvalidLinks[traversals:{_Traversal...}, values_List]:=MapThread[
	removeInvalidLinks[#1, #2]&,
	{traversals, values}
];
removeInvalidLinks[traversal:{___Traversal}, Null]:=Null;
removeInvalidLinks[traversal:_Traversal, value:_]:=Replace[
	value,
	{InvalidLinkField[field:_Defer] :> (Sow[{traversal, field}, "not-link"];$Failed)},
	{0, Infinity}
];

(* Create an Association of object -> <|"Fields" -> {list of fields to download}|> *)
objectRequestsAssociation[requests:{Rule[objectP | modelP | _Association, _Traversal | {___Traversal}]...}]:=Merge[
	Map[
		<|First[#] -> <|"Fields" -> ToList[Last[#]]|>|> &,
		requests
	],
	mergeFields
];

objectRequestsAssociation[objects:{(objectP | modelP)...}]:=AssociationMap[
	Association[
		"Fields" -> typeSymbols[objectToType[#]]
	]&,
	objects
];

objectRequestsAssociation[objectsKeys:{{(objectP | modelP), optionalDateP}...}]:=AssociationMap[
	Association[
		"Fields" -> typeSymbols[objectToType[First[#]]]
	]&,
	objectsKeys
];

(* Include the corresponding Date in the Key*)
objectRequestsAssociation[requests:{Rule[objectP | modelP | _Association, _Traversal | {___Traversal}]...}, dates_]:=Merge[
	MapThread[
		<|{First[#1], #2} -> <|"Fields" -> ToList[Last[#1]]|>|> &,
		{requests, dates}
	],
	mergeFields
];

(* Associate the CAS tokens for the given objects with the fields being requested *)
(* NOTE: This will contact the server and ask for the latest CAS tokens for our objects (peekObjects[...]). *)
fetchCASTokens[objectFieldRequests_Association, limit:_Integer | None]:=Module[
	{objects},
	(*Get all the latest CAS tokens from the server*)
	objects=First /@ Keys[objectFieldRequests];
	peekResults=Map[
		Lookup[#, "cas"]&,
		Select[
			peekObjects[objects],
			MatchQ[#, _Association]&
		]
	];

	(*Retun an Association with Fields/CAS/Limit for each object requested.*)
	Association[
		KeyValueMap[
			#1 -> Append[
				#2,
				{
					"CAS" -> Lookup[peekResults, First[#1]],
					"Limit" -> limit
				}
			]&,
			objectFieldRequests
		]
	]
];


(** print field names and where they came from, input generated by fieldRow **)
printCacheRows[title:_, rows:_]:=With[
	{header={{Style[title, FontWeight -> Bold], SpanFromLeft}}},

	Print[Grid[
		Join[header, rows],
		Alignment -> Left
	]];
];


fieldRow[_, {}]:=Nothing;
fieldRow[object:objectP | modelP, symbols:_List]:=Module[
	{fieldString, allTypeFieldsQ},

	fieldString=StringRiffle[
		Map[
			SymbolName,
			DeleteDuplicates[symbols]
		],
		", "
	];

	allTypeFieldsQ=ContainsExactly[
		Complement[Keys[objectToType[object]], {Object, Type, ID}],
		symbols
	];

	If[allTypeFieldsQ,
		{InputForm[object], SpanFromLeft},
		{InputForm[object], fieldString}
	]
];

realLimitNumber[n_Integer]:=n;
realLimitNumber[Infinity]:=50 * 1024;

filterObjectRequests[inputs_, dates_]:=Module[{inputsWithDates, objectsAndDates, filteredObjects, filteredDates},
	inputsWithDates=Transpose[{inputs, dates}];
	objectsAndDates=Replace[
		inputsWithDates,
		{
			{link:linkP, date_} :> {linkToObject[link], date},
			{_Association, _} -> Nothing,
			{$Failed, _} -> Nothing,
			{Null, _} -> Nothing
		},
		{1}
	];
	filteredObjects=objectsAndDates[[All, 1]];
	filteredDates=objectsAndDates[[All, 2]];
	{filteredObjects, filteredDates}
];

generateFieldRequests[inputsWithIds_, dates_]:=Module[{inputsWithIdsAndDates, invalidFields, invalidPacketFields, fieldRequestsNoInvalidFields, invalidTypePositions,
	invalidTypes, fieldRequestsNoInvalidTypes, fieldRequests, fieldRequestsWithIDs, fieldRequestDates},

	inputsWithIdsAndDates=Transpose[{inputsWithIds, dates}];

	(*Filter out all $Failed/Null entries and turn all links to objects*)
	fieldRequests=Replace[
		inputsWithIdsAndDates,
		{
			{Rule[link:linkP, fields_], date_} :> {Rule[linkToObject[link], fields], date},
			{Rule[$Failed, _], _} -> Nothing,
			{Rule[Null, _], _} -> Nothing,
			{Rule[_, _Missing], _} -> Nothing
		},
		{0, 1}
	];

	(*Association of message string to list of fields failing with that message.*)
	invalidFields=Select[
		Apply[
			Union,
			ToList /@ Values[fieldRequests[[All, 1]]]
		],
		Not[validFieldSequenceQ[#]]&
	];


	(*Display specific message for Packet wrapper with multiple through-link traversals*)
	invalidPacketFields=Cases[
		invalidFields,
		Verbatim[Traversal][PacketTarget[_List]],
		{1}
	];

	If[Length[invalidPacketFields] > 0,
		Message[
			Download::PacketWrapperMultipleObjects,
			Map[
				Apply[Packet, deferFields[#[[1, 1]]]]&,
				invalidPacketFields
			]
		]
	];

	(*Display messages for all invalid fields in input*)
	With[
		{nonPacketErrors=Complement[invalidFields, invalidPacketFields]},

		If[Length[nonPacketErrors] > 0,
			Message[Download::InvalidField, deferFields[nonPacketErrors]]
		]
	];

	fieldRequestsNoInvalidFields=Map[
		removeInvalidFields[#, invalidFields]&,
		fieldRequests
	];

	invalidTypePositions=Position[
		fieldRequestsNoInvalidFields,
		{Rule[
			(*objectToType is Listable and behaves incorrectly when given an Association (packet)
			so we need to either call packetToType on Associations or objectToType on everything else*)
			Alternatives[
				PatternTest[_Association, And[KeyExistsQ[#, Type], !TypeQ[packetToType[#]]]&],
				PatternTest[Except[_Association], !TypeQ[objectToType[#]]&]
			],
			_
		], _},
		{1}
	];

	invalidTypes=DeleteDuplicates[Map[objectToType,
		First /@ Extract[fieldRequestsNoInvalidFields, Map[Append[1], invalidTypePositions]]
	]];

	If[invalidTypes =!= {},
		Message[Download::UnknownType, invalidTypes]
	];

	fieldRequestsNoInvalidTypes=ReplacePart[fieldRequestsNoInvalidFields,
		invalidTypePositions -> Nothing
	];

	fieldRequestsWithIDs=fieldRequestsNoInvalidTypes[[All, 1]];
	fieldRequestDates=fieldRequestsNoInvalidTypes[[All, 2]];
	{Map[cacheObjectID[First[#]] -> Last[#] &, fieldRequestsWithIDs], fieldRequestDates}
];

(* ::Subsection:: *)
(*ClearDownload*)


(* TODO: ClearNativeDownload[] supports clearning specific objects *)
ClearDownload[objectOrId:objectP | modelP | _String]:=FirstOrDefault[
	clearCache[{objectOrId}]
];

ClearDownload[objectsOrIds:{(objectP | modelP | _String)...}]:=Module[{},
	GoLink`Private`ClearNativeDownload[];
	clearCache[objectsOrIds]
];

ClearDownload[]:=Module[{},
	GoLink`Private`ClearNativeDownload[];

	(* Reset the DownValues of Object[...] to clear any [Type] [Name] or [Object] dereferencing that is cached. *)
	DownValues[Object]={
		HoldPattern[Object[Constellation`Private`id_String?(StringMatchQ[#1, "id:"~~__]&)]] :> First[Object[{Constellation`Private`id}]],
		HoldPattern[Object[Constellation`Private`ids:{___String?(StringMatchQ[#1, "id:"~~__]&)}]] :> With[{Constellation`Private`objects=Constellation`Private`objectsFromIds[Constellation`Private`ids]}, MapThread[If[MatchQ[#2, $Failed], $Failed, Object[#1]=#2]&, {Constellation`Private`ids, Constellation`Private`objects}]]
	};

	clearCache[]
];

erasePartP=_Integer | _Symbol | {{_Integer}..} | {_Integer | All, _Integer | _Symbol};
erasePart2dP={_Integer | All, _Integer | All};

uploadOperationP=Append | Replace | Erase | EraseCases | Transfer | Prepend;

(* Delayed rules are not uploaded, and so generate no errors *)
validUploadField[_ :> _, _]:=Nothing;

(* Field Does not exist *)
validUploadField[(field:_) -> _, _Missing]:=
		<|"error" -> "NoSuchField", "field" -> field|>;

validUploadField[(uploadOperationP)[field:_] -> _, _Missing]:=
		<|"error" -> "NoSuchField", "field" -> field|>;

(* Unsupported wrappers *)
validUploadField[(operation:Except[(uploadOperationP)[_Symbol] | _Symbol]) -> _, _]:=
		<|"error" -> "InvalidOperation", "operation" -> operation|>;

(*Cannot upload to a computable field*)
validUploadField[field:_Symbol -> _, KeyValuePattern[Format -> Computable]]:=
		<|"error" -> "ComputableField", "field" -> field|>;

(*Cannot upload to a computable field*)
validUploadField[_[field:_Symbol] -> _, KeyValuePattern[Format -> Computable]]:=
		<|"error" -> "ComputableField", "field" -> field|>;

(*Multiple fields MUST be wrapped in Append/Replace*)
validUploadField[field:_Symbol -> _, KeyValuePattern[Format -> Multiple]]:=
		<|"error" -> "MultipleField", "field" -> field|>;

(* Cannot use Erase with a single field (unless it is indexed)*)
validUploadField[Erase[field:_Symbol] -> _, KeyValuePattern[{Format -> Single, Class -> Except[_List]}]]:=
		<|"error" -> "SingleEraseField", "field" -> field|>;

validUploadField[Erase[field:_Symbol] -> value:erasePart2dP, KeyValuePattern[{Format -> Single, Class -> _List}]]:=
		<|"error" -> "EraseDimension", "value" -> value, "field" -> field|>;

validUploadField[Erase[field:_Symbol] -> value:erasePart2dP, KeyValuePattern[{Format -> Multiple, Class -> Except[_List]}]]:=
		<|"error" -> "EraseDimension", "value" -> value, "field" -> field|>;

(* Cannot use EraseCases with a single field*)
validUploadField[EraseCases[field:_Symbol] -> _, KeyValuePattern[{Format -> Single}]]:=
		<|"error" -> "SingleEraseCases", "field" -> field|>;

(* Check the value specified for ErasesCases is a single row and matches the storage pattern of the field*)
validUploadField[EraseCases[field:_Symbol] -> value_, definition:_Association | _List]:=
		If[fieldValueMatchesPatternQ[{value}, definition],
			Nothing,
			<|"error" -> "FieldStoragePattern", "field" -> field|>
		];

(* Erase was specified with an invalid Erase specification*)
validUploadField[_Erase -> value:Except[erasePartP], _]:=
		<|"error" -> "ErasePattern", "value" -> value|>;

(* Fall through for successful Erase*)
validUploadField[_Erase -> _, _]:=
		Nothing;

(*Cannot append Null to a field*)
validUploadField[(Append[field:_Symbol]) -> Null, _]:=
		<|"error" -> "FieldStoragePattern", "field" -> field|>;

validUploadField[
	(field:_Symbol) | (Append | Replace)[field:_Symbol] -> Except[_Association | Null],
	KeyValuePattern[{Class -> {_Rule..}, Format -> Single}]
]:=
		<|"error" -> "NamedField", "field" -> field|>;

validUploadField[
	(field:_Symbol) | (Append | Replace)[field:_Symbol] -> Except[{(_Association | Null)...} | _Association | Null],
	KeyValuePattern[{Class -> {_Rule..}, Format -> Multiple}]
]:=
		<|"error" -> "NamedMultipleField", "field" -> field|>;

validUploadField[
	(field:_Symbol) | (Append | Replace)[field:_Symbol] -> _Association | {_Association ..},
	KeyValuePattern[Class -> {Except[_Rule]...}]
]:=
		<|"error" -> "FieldStoragePattern", "field" -> field|>;

(* Append|Replace on single fields IS allowed *)
validUploadField[((Append | Replace)[field:_Symbol]) -> value:_, definition:_Association | _List]:=
		If[fieldValueMatchesPatternQ[value, definition],
			Nothing,
			<|"error" -> "FieldStoragePattern", "field" -> field|>
		];

validUploadField[field:_Symbol -> value:_, definition:_Association | _List]:=
		If[fieldValueMatchesPatternQ[value, definition],
			Nothing,
			<|"error" -> "FieldStoragePattern", "field" -> field|>
		];


validUploadField[Transfer[field:Except[Notebook]] -> value:_, _]:=
		<|"error" -> "BadTransfer", "field" -> field, "value" -> value|>;


validUploadField[Transfer[Notebook] -> value:_, _]:=
		If[MatchQ[value, LinkP[Object[LaboratoryNotebook], Objects] | Null],
			Nothing,
			<|"error" -> "BadTransfer", "field" -> Notebook, "value" -> value|>
		];


validUploadField[_ -> _, _]:=
		Nothing;

lookupFieldDef[(field:_Symbol) -> _, definition:_Association]:=
		Lookup[definition, field];

lookupFieldDef[(uploadOperationP)[field:_Symbol] -> _, definition:_Association]:=
		Lookup[definition, field];


validUploadType[<||>, _]:={};

validUploadType[packet:_Association, type:typeP]:=Module[
	{definition, errors},

	definition=Quiet[
		<|Lookup[LookupTypeDefinition[type], Fields]|>,
		{Lookup::invrl}
	];

	errors=If[AssociationQ[definition],
		Map[validUploadField[#, lookupFieldDef[#, definition]]&, Normal[packet]],
		{<|"error" -> "NoSuchType"|>}
	];

	Map[
		Append[Merge[#, Identity], "error" -> First[Lookup[#, "error"]]] &,
		GatherBy[errors, Key["error"]]
	]
];

uploadPacketErrors[packet:_Association, {position:_Integer}]:=With[
	{type=packetToType[packet]},

	{
		If[packet[[Key[Name]]] === "",
			<|"error" -> "EmptyName", "position" -> position|>,
			Nothing
		],
		If[!MatchQ[packet[[Key[Name]]], Missing["KeyAbsent", Name | Key[Name]]] && !MatchQ[packet[[Key[Name]]], Null] && StringStartsQ[packet[[Key[Name]]], "id:"],
			<|"error" -> "NameStartsWithId", "position" -> position|>,
			Nothing
		],
		If[!KeyMemberQ[packet, Object] && KeyMemberQ[packet, (Erase | EraseCases)[_Symbol]],
			<|"error" -> "NoObject", "position" -> position, "field" -> First@Keys@KeySelect[packet, MatchQ[#,(Erase | EraseCases)[_Symbol]] &]|>,
			Nothing
		],
		If[type === Object[LaboratoryNotebook] && KeyMemberQ[packet, Objects | (Append | Replace | Erase | EraseCases)[Objects]],
			<|"error" -> "ObjectsField", "position" -> position|>,
			Nothing
		],
		If[KeyMemberQ[packet, Object] && FailureQ[type],
			<|"error" -> "FieldStoragePattern", "field" -> {Object}, "object" -> type, "position" -> position|>,
			Nothing
		],
		If[type === $Failed,
			<|"error" -> "TypeNotSpecified", "position" -> position|>,
			Sequence @@ Map[
				Append[
					#,
					<|
						"position" -> position,
						"type" -> type,
						"object" -> First[DeleteMissing[Lookup[packet, {Object, Type}]]]
					|>
				]&,
				Quiet[validUploadType[packet, type], {LookupTypeDefinition::NoFieldDefError}]
			]
		]
	}
];

(* apply 'function' to each from of associations with distinct 'key' *)
(* return the result as a list of associations. Does not modify 'key' *)
splitApplyCombine[key:_String, function:_, items:{___Association}]:=
		KeyValueMap[
			Append[#2, key -> #1] &,
			Map[
				Merge[function],
				GroupBy[items, Key[key] -> KeyDrop[key]]
			]
		];

splitApplyCombine[(split:_) -> (key:_String), function:_, items:{___Association}]:=
		KeyValueMap[
			Append[#2, key -> #1] &,
			Map[
				Merge[function],
				KeyDrop[
					GroupBy[items, split],
					"NothingWrong"
				]
			]
		];

(* Return linkID, associated object and field, position for each link with explicit ID *)
explicitLinkContexts[packets:{___Association}]:=
		Flatten[MapIndexed[explicitLinkContextFromPacket, packets]];

explicitLinkContextFromPacket[packet:_Association, {position:_Integer}]:=
		Map[Append["position" -> position],
			KeyValueMap[explicitLinkContextFromField, packet]
		];

explicitLinkContextFromField[_Erase | _EraseCases, _]:=
		Nothing;

explicitLinkContextFromField[field:Except[_Erase | _EraseCases], value:_]:=
		Sequence @@ Map[
			Append["field" -> field],
			explicitLinkContextFromValue[value]
		];

explicitLinkContextFromValue[rows:{___List}]:=
		Flatten[Map[explicitLinkContextFromValue, rows, {2}]];

explicitLinkContextFromValue[row:_List]:=
		Flatten[Map[explicitLinkContextFromValue, row]];

explicitLinkContextFromValue[Link[object:_Object | _Model, ___, linkId:_String, ___]]:=
		{<|
			"object" -> object,
			"linkId" -> linkId
		|>};

explicitLinkContextFromValue[row_Association]:=
		Flatten[Map[explicitLinkContextFromValue, Values[row]]];

explicitLinkContextFromValue[_]:=
		{};

explicitLinkContextMessage[input_Association]:=
		Switch[Length[ToList[Lookup[input, "position"]]],
			0 | 1,
			"MissingLinkID",
			2,
			"NothingWrong",
			_,
			"RepeatLinkID"
		];

explicitLinkContextMessage[_]:=
		Nothing;

diskLog[data:_, description:_String]:=Module[
	{rosettaLogPath, logPath},

	rosettaLogPath=FileNameJoin[{$HomeDirectory, "rosettaAppData", "temp", "SLL"}];

	logPath=If[DirectoryQ[rosettaLogPath],
		FileNameJoin[{rosettaLogPath, description<>"_"<>ToString[UnixTime[]]<>".mx"}],
		FileNameJoin[{$TemporaryDirectory, description<>"_"<>ToString[UnixTime[]]<>".mx"}]
	];

	Export[logPath, data, "MX"]
];

(*
	TemporalLinks mean that we can no longer trust the DateOption if the given input has a specified time.
	Rules for the DateOption goes as followed.

	1. Any specified Date overrides a TemporalLink
	2. If the Date is None, any TemporalLink would override that Option.
	3. Create a Date for every input
*)
preProcessDateOption[inputs:{downloadInputP...}, dateInput_]:=Module[{heldDateInput, dateList, newDateOption, targetLength, dateOption, truncatedDateOption},
	heldDateInput=dateInput;
	(* Sometimes the date input comes in as a private variable, so that needs to get dealt with *)
	If[MatchQ[ReleaseHold[dateInput], None], heldDateInput=Hold[None]];

	(* If this is just a singular thing, put in in a list *)
	dateOption=If[!MatchQ[ReleaseHold[heldDateInput], _List], heldDateInput /. Hold[x_] -> Hold[List[x]], heldDateInput];
	(* Hold every inner portion of the list *)
	dateOption=ReleaseHold[Map[Hold, dateOption, {2}]];

	targetLength=Length[inputs];
	(* Create a corresponding list of dates if Date a date is specified*)
	dateList=Which[
		MatchQ[dateOption, None], Array[Hold[None]&, targetLength],
		(* Create the corresponding list of date options (a List of Nones) if DateOption is None or {None} *)
		MatchQ[dateOption, Hold[None]], Array[dateOption&, targetLength],
		MatchQ[dateOption, {Hold[None]}], Array[First[dateOption]&, targetLength],
		(* Create corresponding list of dates if DateOption is a singular date *)
		MatchQ[dateOption, Hold[_?DateObjectQ]], Array[dateOption&, targetLength],
		(* If its a single date inside of a list do the samething as above *)
		MatchQ[dateOption, {Hold[_?DateObjectQ]}], Array[First[dateOption]&, targetLength],
		(* Do nothing if date is already a list*)
		True, dateOption
	];

	If[!MatchQ[Length[dateList], targetLength], Return[$Failed]]; (* Bail if the lengths don't match *)
	(* #1 represents the inputs *)
	(* #2 represents the dates *)
	(* If we have a temporal link, and no date is specified for it, grab the date from the temporal link. *)
	newDateOption=MapThread[If[MatchQ[#1, temporalLinkP] && MatchQ[#2, Hold[None]], Hold[getLinkDate[#1]], #2] &, {inputs, dateList}];
	(* All the dates are in a hold, so convert all things that are still Now into None and then unleash them*)
	newDateOption=newDateOption /. Hold[Now] -> Hold[None];
	newDateOption=ReleaseHold[newDateOption];
	truncatedDateOption=newDateOption /. date_DateObject :> standardizeDateObj[date];
	Return[truncatedDateOption]
];

(* ::Subsection:: *)
(*Object Syntax*)


(* ::Subsubsection::Closed:: *)
(*Dereference*)


(*Object*)
(* NOTE: This should be REMOVED as soon as we have alternative class support in fields and UnitOperation no longer does this. *)
Object/:(object:nonUnitOperationObjectP)[fields:(_Symbol|_Field|{(_Symbol|_Field) ..})]:=Download[object,fields];
Object/:Part[object:nonUnitOperationObjectP,fields:(_Symbol|_Field|{(_Symbol|_Field) ..}),rest___]:=Part[
	Download[object,fields],
	rest
];
Object/:(object:nonUnitOperationObjectP)[field_Symbol, Length]:=Download[object,Length[field]];
Object/:(object:nonUnitOperationObjectP)[fields:{_Symbol..}, Length]:=Download[object,Evaluate[Field[Length[#]]&/@fields]];

Object/:(object:unitOperationObjectP)[field:Alternatives[ID, Object, Type, Model, Objects, Name, Notebook, DateCreated, CreatedBy]]:=Download[object,field];
Object/:(object:unitOperationObjectP)[fields:(_Symbol|_Field|{(_Symbol|_Field) ..})]:=DownloadUnitOperation[object,fields];
Object/:Part[object:unitOperationObjectP,fields:(_Symbol|_Field|{(_Symbol|_Field) ..}),rest___]:=Part[
	DownloadUnitOperation[object,fields],
	rest
];

(*Model*)
Model/:(object:modelP)[fields:(_Symbol | _Field | {(_Symbol | _Field) ..})]:=Download[object, fields];
Model/:Part[object:modelP, fields:(_Symbol | _Field | {(_Symbol | _Field) ..}), rest___]:=Part[
	Download[object, fields],
	rest
];
Model/:(object:modelP)[field_Symbol, Length]:=Download[object, Length[field]];
Model/:(object:modelP)[fields:{_Symbol..}, Length]:=Download[object, Evaluate[Field[Length[#]]& /@ fields]];

(*Link*)
Link/:(link:nonUnitOperationAbbreviatedLinkP)[fields:(_Symbol|_Field|{(_Symbol|_Field) ..})]:=Download[link,fields];
Link/:Part[link:nonUnitOperationAbbreviatedLinkP,fields:(_Symbol|_Field|{(_Symbol|_Field) ..}),rest___]:=Part[
	Download[link,fields],
	rest
];
Link/:(link:nonUnitOperationAbbreviatedLinkP)[field_Symbol, Length]:=Download[link,Length[field]];
Link/:(link:nonUnitOperationAbbreviatedLinkP)[fields:{_Symbol..}, Length]:=Download[link,Evaluate[Field[Length[#]]&/@fields]];

Link/:(link:unitOperationAbbreviatedLinkP)[fields:(_Symbol|_Field|{(_Symbol|_Field) ..})]:=DownloadUnitOperation[link,fields];
Link/:Part[link:unitOperationAbbreviatedLinkP,fields:(_Symbol|_Field|{(_Symbol|_Field) ..}),rest___]:=Part[
	DownloadUnitOperation[link,fields],
	rest
];

(* ::Subsubsection::Closed:: *)
(*Expanding Object Types*)


Object[id_String?(StringMatchQ[#, "id:"~~__] &)]:=First[Object[{id}]];
Object[ids:{___String?(StringMatchQ[#, "id:"~~__] &)}]:=With[
	{objects=objectsFromIds[ids]},

	MapThread[
		If[MatchQ[#2, $Failed],
			$Failed,
			Object[#1]=#2
		]&,
		{ids, objects}
	]
];

objectsFromIds[ids:{___String}]:=Block[{Object, Model},
	Module[
		{cached, nonCached, peekResults, replacements},
		cached=Select[
			Lookup[idCache, ids],
			Not[MissingQ[#]]&
		];
		nonCached=Complement[ids, cached];
		peekResults=peekObjects[nonCached];
		replacements=Map[
			If[MatchQ[#, _Association],
				objectReferenceToObject[Lookup[#, "resolved_object", <||>]],
				$Failed
			]&,
			peekResults
		];

		Replace[
			ids,
			Join[
				idCache,
				replacements,
				<|_ -> $Failed|>
			],
			{1}
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*Part*)


setupPartDownValues[]:=With[{},
	Unprotect[Part];
	With[
		{pattern=(objectP | modelP | linkP)},

		DownValues[Part]=DeleteDuplicates[
			Join[
				DownValues[Part],
				{
					HoldPattern[Part[objects:{pattern..}, field:(_Symbol | {_Symbol..})]] :> Download[objects, field]
				}
			]
		]
	];
	Protect[Part];
];


(* ::Subsubsection::Closed:: *)
(*ReplaceAll*)


setupReplaceAllDownValues[]:=With[{},
	Unprotect[ReplaceAll];
	With[
		{pattern=(objectP | modelP | linkP)},

		DownValues[ReplaceAll]=DeleteDuplicates[
			Join[
				DownValues[ReplaceAll],
				{
					HoldPattern[ReplaceAll[field:(_Symbol | {_Symbol..}), objList:{pattern..}]] :> Download[objList, field]
				}
			]
		]
	];
	Protect[ReplaceAll];
];


(* ::Subsubsection::Closed:: *)
(*Keys*)


(* all field symbols for a type *)
Object/:Keys[type:Object[Repeated[_Symbol, {1, 5}]]]:=Fields[type, Output -> Short];
Model/:Keys[type:Model[Repeated[_Symbol, {1, 5}]]]:=Fields[type, Output -> Short];

(* all non-null field symbols for a given object *)
Link/:Keys[link:abbreviatedLinkP]:=Fields[link, Output -> Short];
Object/:Keys[object:objectP]:=Fields[object, Output -> Short];
Model/:Keys[object:modelP]:=Fields[object, Output -> Short];



(* ::Subsection:: *)
(*EraseObject*)


DefineOptions[EraseObject,
	Options :> {
		{Force -> False, True | False, "When Force is True, do not prompt the user if they wish to delete the object."},
		{Verbose -> True, True | False, "When True, prints progress/completion messages."}
	}
];

EraseObject::Error="`1`";
EraseObject::NotFound="`1`";
EraseObject::NotAllowed="`1`";

EraseObject[{}, ops:OptionsPattern[]]:={};
EraseObject[obj:(objectP | modelP), ops:OptionsPattern[]]:=First[EraseObject[{obj}, ops]];
EraseObject[objects:{(objectP | modelP)..}, ops:OptionsPattern[]]:=Module[
	{verbose, continue, body, response, status, message},

	If[!loggedInQ[],
		Message[EraseObject::NotLoggedIn];
		Return[Table[$Failed, {Length[objects]}]]
	];

	verbose=OptionDefault[OptionValue[EraseObject, Verbose]];
	continue=If[TrueQ[OptionDefault[OptionValue[Force]]],
		True,
		deleteObjectDialog[
			Length[DeleteDuplicates[objects]],
			DeleteDuplicates[
				Quiet[
					Download[objects, Notebook[Name]],
					{
						Download::ObjectDoesNotExist
					}
				]
			]
		]
	];

	If[!TrueQ[continue],
		Return[Table[$Canceled, {Length[objects]}]]
	];

	If[verbose,
		printProgressMessage["Deleting objects from Constellation"];
	];

	(* Add the transaction ids if set *)
	body=<|
		"Objects"->Map[ConstellationObjectReferenceAssoc, objects],
		If[Length[$CurrentUploadTransactions]>0,
			"sll_txs"->$CurrentUploadTransactions,
			Nothing]
	|>;

	response=ConstellationRequest[<|
		"Path"->apiUrl["EraseObject"],
		"Method"->"DELETE",
		"Body"->body
	|>];

	If[MatchQ[response, _HTTPError],
		Message[EraseObject::Error, response];
		Return[Table[$Failed, {Length[objects]}]]
	];

	status=Lookup[response, "Status", -2];
	message=Lookup[response, "Message", "unknown error"];
	If[status != 0,
		Switch[status,
			1, Message[EraseObject::NotFound, message],
			2, Message[EraseObject::NotAllowed, message],
			_, Message[EraseObject::Error, message]];
		Return[Table[$Failed, {Length[objects]}]]
	];

	(* Unless printing is turned off, add the new objects to the list of new objects to print from this cell evaluation *)
	If[verbose && !TrueQ[$DisableVerbosePrinting] && ListQ[$DeletedVerboseObjects],
		$DeletedVerboseObjects=Union[$DeletedVerboseObjects, objects]
	];

	ClearDownload[objectReferenceUnresolvedToObject /@ Lookup[response, "ModifiedReferences", {}]];

	clearProgressMessage[];

	Table[True, {Length[objects]}]
];

deleteObjectDialog[count_Integer, notebooks_List]:=EmeraldChoiceDialog[
	StringForm[
		"Are you sure you want to delete `1` object(s) from the notebook(s) `2`?\n\nThis action cannot be undone and will affect all users of the ECL!",
		count,
		notebooks
	],
	{
		"Delete Permanently" -> True,
		"Cancel" -> False
	}
];

(* ::Subsection:: *)
(* GetNumOwnedObjects *)


DefineOptions[GetNumOwnedObjects,
	Options :> {
		{Date -> None, None | _?DateObjectQ, "Counts the team objects at that specific date."}
	}
];

GetNumOwnedObjects::Error="Constellation returned the following error: `1`.";

GetNumOwnedObjects[{}, ops:OptionsPattern[]]:={};
GetNumOwnedObjects[object:Object[ECL`Team, ECL`Financing, _String], ops:OptionsPattern[]]:=First[GetNumOwnedObjects[{object}, ops]];

GetNumOwnedObjects[financingTeams:{Object[ECL`Team, ECL`Financing, _String]..}, ops:OptionsPattern[]]:=Module[
	{financingTeamObjects, uniqueFinancingTeamObjects, dateOption, response, options},
	financingTeamObjects=ToList[financingTeams];

	uniqueFinancingTeamObjects=DeleteDuplicates[financingTeamObjects];

	options=OptionDefaults[GetNumOwnedObjects, ToList[ops]];
	dateOption=Lookup[options, "Date"];

	dateOption=If[MatchQ[dateOption, None], "",
		DateObjectToRFC3339[dateOption]];

	(* Call constellation API *)
	response=ConstellationRequest[<|
		"Path" -> Constellation`Private`apiUrl["GetNumOwnedObjects"],
		"Method" -> "POST",
		"Body" -> <|"teams" -> Map[ConstellationObjectReferenceAssoc, uniqueFinancingTeamObjects], "date_option" -> dateOption |>
	|>];

	(* In case of HTTP Error *)
	If[MatchQ[response, _HTTPError],
		Message[GetNumOwnedObjects::Error, response];
		Return[$Failed];
	];

	ret=Lookup[response, "team_objects"];
	ret
];


(* ::Subsection:: *)
(*DatabaseMemberQ*)

DefineOptions[DatabaseMemberQ,
	Options :> {
		{
			Simulation -> Null,
			Null | SimulationP,
			"The Simulation that contains any simulated objects that should be used.",
			Category -> Hidden
		},
		{
			IncludeSimulatedObjects -> True,
			BooleanP,
			"Indicates if simulated objects should be considered to be part of the database.",
			Category -> Hidden
		}
	}
];

DatabaseMemberQ[{}, ops:OptionsPattern[]]:={};
DatabaseMemberQ[object:(objectP | modelP | linkP | _Association), ops:OptionsPattern[]]:=First[DatabaseMemberQ[{object}, ops]];
DatabaseMemberQ[objects:{(objectP | modelP | linkP | _Association)..}, ops:OptionsPattern[]]:=Module[
	{includeSimulatedObjects, explicitSimulation, ids, references, peekResult, databaseResult, objectsWithoutNames, explicitSimulationMemberQ, globalSimulationMemberQ},

	(* Lookup option values. *)
	includeSimulatedObjects=OptionDefault[OptionValue[DatabaseMemberQ, IncludeSimulatedObjects]];
	explicitSimulation=OptionDefault[OptionValue[DatabaseMemberQ, Simulation]];

	ids=Map[
		toReference,
		objects
	];

	references=Select[
		ids,
		MatchQ[#, objectP | modelP] && TypeQ[objectToType[#]] &
	];

	(* obj -> True if the result returns *)
	peekResult=KeyValueMap[
		#1 -> And[AssociationQ[#2], Lookup[#2, "status_code"] === 0]&,
		peekObjects[references]
	];

	(* This is the result returned from the server. *)
	databaseResult=Replace[
		ids,
		Append[
			Normal[peekResult],
			_ -> False
		],
		{1}
	];

	(* If we were told to include simulated objects, also look in the explicit simulation and global simulation. *)
	If[MatchQ[includeSimulatedObjects, False] || (!MatchQ[explicitSimulation, SimulationP] && !MatchQ[$Simulation, True]),
		Return[databaseResult];
	];

	(* If our simulation is not updated, we have to update it. *)
	If[MatchQ[explicitSimulation, SimulationP] && MatchQ[Lookup[explicitSimulation[[1]],Updated],False],
		explicitSimulation=UpdateSimulation[Simulation[], explicitSimulation];
	];

	(* If we have a global simulation and it is not updated, do the same thing to the global simulation. *)
	If[And[
		MatchQ[$Simulation, True],
		MatchQ[Lookup[$CurrentSimulation[[1]],Updated],False]
	],
		$CurrentSimulation=UpdateSimulation[Simulation[], $CurrentSimulation];
	];

	(* Convert all objects into ID format. *)
	objectsWithoutNames=Download[objects, Object, Simulation -> explicitSimulation];

	(* Look at our explicit and global simulation as well. *)
	explicitSimulationMemberQ=If[MatchQ[explicitSimulation, SimulationP],
		(MemberQ[Lookup[explicitSimulation[[1]], SimulatedObjects], #]&)/@objectsWithoutNames,
		ConstantArray[False, Length[ids]]
	];

	globalSimulationMemberQ=If[MatchQ[$Simulation, True] && MatchQ[$CurrentSimulation, SimulationP],
		(MemberQ[Lookup[$CurrentSimulation[[1]], SimulatedObjects], #]&)/@objectsWithoutNames,
		ConstantArray[False, Length[ids]]
	];

	MapThread[(#1 || #2 || #3&), {databaseResult, explicitSimulationMemberQ, globalSimulationMemberQ}]
];

toReference[object:objectP]:=object;
toReference[model:modelP]:=model;
toReference[link:linkP]:=linkToObject[link];
toReference[packet_Association]:=With[
	{id=Lookup[packet, Object]},

	If[MatchQ[id, objectP | modelP],
		id,
		$Failed
	]
];

(*
	It's hard to tell how much memory a file will take once its loaded in as a quantity,
	since the file is a compressed form. Choosing something arbitrary
*)

ByteLimit=100000000;

adjustedByteLimit[limit:(_Integer | Infinity), origOps:{(_Rule | _RuleDelayed)...}]:=Switch[ECL`$ECLApplication,
	(* If we are in command center, enforce a hard ByteLimit by default to avoid crashing *)
	ECL`CommandCenter,
	If[MemberQ[origOps, BigQuantityArrayByteLimit -> _],
		(* BigQuantityArrayByteLimit was explicitly specified in the options of the root download call *)
		limit,
		(* BigQuantityArrayByteLimit was not set, so default to the smaller of the reoslved limit or hard ByteLimit *)
		Min[ByteLimit, limit]
	],
	(* Otherwise, use the limit without adjustment *)
	_, limit
];


TraceHistory[]:=Web`Private`traceHistory[];
