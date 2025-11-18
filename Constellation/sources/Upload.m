(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*Patterns, Constants, and Flags*)


(* a global variable that, if set to True, will set all uploaded objects to DeveloperObject -> True (unless DeveloperObject is already specified, in which case it will not be overwritten) *)
(* note that if $DeveloperUpload is set to False (default) then DeveloperObject will just not be added to any packets automatically; it does NOT mean that DeveloperObject -> False will be set *)
$DeveloperUpload=False;


(* ::Subsection::Closed:: *)
(*Upload*)

DefineOptions[
	Upload,
	Options :> {
		{Verbose -> True, BooleanP, "Whether or not to print progress indicators as packets are being uploaded."},
		{ConstellationMessage -> All, All | ListableP[TypeP[]] | {}, "Newly created objects matching these types will be printed after upload."},
		{Transaction -> Automatic, Automatic | None | _String, "The transaction option can be None, Automatic, or a string, defaulting to automatic. These options are shortcuts. You can use BeginUploadTransaction[] function with the following Upload calls for the same results."},
		{CAS -> None, None | _String | {___String}, "If set, the upload will fail if the current Check and Set Token of the object does not match. This is useful for ensuring that the object has not changed since you last downloaded it."},
		{AllowPublicObjects -> False, BooleanP, "Unless set, Constellation will reject requests to create \"public\" objects, that is, objects not linked to a notebook."}
	}
];

Upload::NameStartsWithId="Name in packets starts with id: `1`. Please remove prefix and provide the Name field with a unique name.";
Upload::EmptyName="Empty string provided for Name in packets `1`. Please provide the Name field with a unique name of 1 or more characters in length.";
Upload::NonUniqueName="`1`";
Upload::MissingObject="`1`";
Upload::InvalidOperation="The following operation(s) `1` at indices `2` are not valid. Valid operations are in the form Append[field], Replace[field], Erase[field], EraseCases[field], Transfer[Notebook], or field.";
Upload::FieldStoragePattern="The following field(s) `1` do not match their storage pattern(s) for objects `2` at indices `3`.";
Upload::MultipleField="The following field(s) `1` are multiple fields and must be specified as Replace[Field], Append[Field] or Erase[Field] for objects `2` at indices `3`.";
Upload::SingleEraseField="The following field(s) `1` are single non indexed fields, and can not be operated on by Erase for object(s) `2` at indices `3`.";
Upload::SingleEraseCases="The following field(s) `1` in change packets at indices `2` are single fields and do not support EraseCases.";
Upload::TypeNotSpecified="The packet(s) at indices `1` must have Type or Object specified in order to modify or create new object.";
Upload::NonUniqueLinkID="`1`";
Upload::RepeatLinkID="`1`";
Upload::MissingLinkID=(
	"The link ID `1` specified in field `2` for object `3` at index `4` is missing its backlink. "
		<>"To create this link do not specify a link ID and Upload will generate one automatically."
);
Upload::PartDoesntExist="`1`";
Upload::NoSuchType="Unknown type(s) `1` at indices `2`.";
Upload::NoSuchField="The following fields(s) `1` are not present in the types `2` at indices `3`.";
Upload::ComputableField="The following field(s) `1` in type(s) `2` at indices `3` are computable, and cannot be uploaded.";
Upload::ErasePattern="Part(s) `1` at indices `2` are not valid erase parts. Erase parts must be specified as a row, row-column pair, or nested list of rows.";
Upload::EraseDimension="Erase specification(s) `1` at indices `2` contain rows and columns, but the field(s) `3` are 1 dimensional.";
Upload::NoObject="Fields `1` in change packets at indices `2` are specified as Erase, but did not have Object specified. Cannot erase values from new objects.";
Upload::NamedField="The following named field(s) `1` for objects `2` at indices `3` require associations.";
Upload::NamedMultipleField="The following named field(s) `1` for objects `2` at indices `3` require associations or lists of associations.";
Upload::BadTransfer="Attempted to Transfer to field(s) `1` to `2` in object(s) `3`. Can only Transfer to a Notebook with a link to the Objects field of a LaboratoryNotebook.";
Upload::BigDataField="There was an error with big data field `1`: `2`.";
Upload::NotAllowed="User does not have permission for these changes";
Upload::PublicObjectCreationDenied="Unable to create a public object without explicit permission. You can either create a public object by setting 'AllowPublicObjects->True' as an option to 'Upload' or specify the notebook context to this upload.";
Upload::InvalidPacket="There is an invalid packet at position(s) `1`. Please update your input packet(s) and try again.";
Upload::Error="`1`";
Upload::Warning="Warning: `1`";
Warning::TransactionIsNotSet="Can not close unopened transaction. No open transactions";
Warning::CasLengthMismatch="The number of tokens provided in the CAS option do not match the number of input packets.";
RollbackTransaction::TransactionAlreadyExists="Transaction `1` already exists.";

(* Amount of time to ensure the system has waiting after an upload before allowing a download or search to handle read replication *)
readReplicationWaitTime = 500 Milli Second;

(* Date to wait for replication until download/search can be executed *)
readReplicationCompleteDate = Now;

(* Total amount of time slept waiting for replication to complete *)
readReplicationTotalSleptTime = 0 Second;

(* On Load, set $Pre and $Post for tracking and printing new objects that are created and objects that are deleted *)
setVerboseObjects[x___] := (
	$NewVerboseObjects = {};
	$DeletedVerboseObjects = {};

	(* NOTE: Also reset label stack for ExperimentMSP. *)
	$UniqueLabelLookupStack={};
	$UniqueLabelLookup=<||>;

	Unevaluated[x]
);
SetAttributes[setVerboseObjects, HoldAll];

printVerboseObjects[x___]:=(
	If[!MatchQ[$DeletedVerboseObjects, {}], printCompletionMessage["Object(s) successfully deleted from Constellation.", $DeletedVerboseObjects]];
	If[!MatchQ[$NewVerboseObjects, {}], printCompletionMessage["New objects added to Constellation:", $NewVerboseObjects]];

	(* NOTE: Nothing will mess up Named Object. Sequence[a,b] will also mess up NamedObject. *)
	If[MatchQ[ECL`$OutputNamedObjects, True] && !MatchQ[Head[Unevaluated[x]], Sequence] && !MatchQ[Unevaluated[x], Verbatim[Nothing]],
		(* If there are no more than 1000 Objects in the expression, convert them all to Named objects  *)
		ECL`NamedObject[Unevaluated[x], ECL`ConvertToObjectReference -> False, ECL`MaxNumberOfObjects -> 1000],
		Unevaluated[x]
	]
);
SetAttributes[printVerboseObjects, HoldAll];

OnLoad[
	Unprotect[$Post];
	$Post=printVerboseObjects;
	If[$CloudConnected,
		(
			Unprotect[CloudSystem`$UserPre];
			CloudSystem`$UserPre=setVerboseObjects;
			$SummaryBoxDataSizeLimit=67108864;
			Unprotect[$Pre];
			$Pre=setVerboseObjects;
		),
		(
			Unprotect[$Pre];
			$Pre=setVerboseObjects;
		)]
];

(* used by the Upload Messages to put the right field in the right spot *)
uploadArgumentOrder=<|
	"Timeout" -> {},
	"EmptyName" -> {"position"},
	"NameStartsWithId" -> {"position"},
	"NonUniqueName" -> {"error"},
	"MissingObject" -> {"error"},
	"InvalidOperation" -> {"operation", "position"},
	"FieldStoragePattern" -> {"field", "object", "position"},
	"MultipleField" -> {"field", "object", "position"},
	"SingleEraseField" -> {"field", "object", "position"},
	"TypeNotSpecified" -> {"position"},
	"NonUniqueLinkID" -> {"error"},
	"RepeatLinkID" -> {"linkId"},
	"MissingLinkID" -> {"linkId", "field", "object", "position"},
	"PartDoesntExist" -> {"error"},
	"PartialUpload" -> {"errStart", "errEnd", "successEnd", "end", "logfile"},
	"NoSuchType" -> {"type", "position"},
	"NoSuchField" -> {"field", "type", "position"},
	"ComputableField" -> {"field", "type", "position"},
	"ErasePattern" -> {"value", "position"},
	"EraseDimension" -> {"value", "position", "field"},
	"NoObject" -> {"position", "field"},
	"SingleEraseCases" -> {"field", "position"},
	"NamedField" -> {"field", "object", "position"},
	"NamedMultipleField" -> {"field", "object", "position"},
	"BadTransfer" -> {"field", "value", "object"}
|>;

enableAutomaticBookmarks=True;

Upload[packet_Association, ops:OptionsPattern[]]:=Module[{result},
	result=Upload[{packet}, ops];
	If[MatchQ[result, $Failed],
		result,
		First[result]
	]
];
Upload[{}, OptionsPattern[]]:={};
Upload[packets:{__Association}, ops:OptionsPattern[]]:=TraceExpression["Upload", Module[
	{safeOps, invalidInputs, errors, messages, verbose, withoutComputables, withLists, response, linkContexts,
		groupedLinkContexts, newObjects, transaction, objectsToBookmark, cas, casList,
		packetsWithDevObjects},

	(* Check if the inputs are valid associations *)
	invalidInputs=Position[packets, _Association?(! AssociationQ[#] &)];
	If[Length[invalidInputs]>0,
		Message[Upload::InvalidPacket, invalidInputs];
		Return[$Failed]
	];

	(* If $DeveloperUpload is True, then add DeveloperObject -> True to the newly-created packets *)
	(* note that addDeveloperObjectToPackets does call DatabaseMemberQ so it does give a bit of a performance hit, so only go down this path if $DeveloperUpload is True *)
	packetsWithDevObjects = If[TrueQ[$DeveloperUpload],
		addDeveloperObjectToPackets[packets],
		packets
	];

	safeOps=ECL`OptionsHandling`SafeOptions[Upload, ToList[ops], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	(* Check input packets for errors before uploading*)
	errors=Flatten[MapIndexed[
		uploadPacketErrors[#1, #2]&,
		packetsWithDevObjects
	]];

	(* Group errors from multiple packets by common message type*)
	messages=Map[
		Append[Merge[#, Identity], "error" -> First[Lookup[#, "error"]]] &,
		GatherBy[errors, Key["error"]]
	];

	(* Generate groups of uploads which are likely (but not guaranteed) to complete
	within the request timeout by creating groups of packets to be uploaded.*)
	withoutComputables=removeComputables[packetsWithDevObjects];

	linkContexts=explicitLinkContexts[withoutComputables];
	groupedLinkContexts=splitApplyCombine["linkId", DeleteDuplicates, linkContexts];
	messages=Join[messages,
		splitApplyCombine[
			explicitLinkContextMessage -> "error",
			Identity,
			groupedLinkContexts
		]
	];

	(* Send any accumulated messages *)
	Scan[
		Message[
			MessageName[Upload, #error],
			Sequence @@ KeyTake[#, uploadArgumentOrder[#error]]
		]&,
		messages
	];

	(* If we received an upload error, echo out our packets so that we can debug more easily later. *)
	If[TrueQ[ECL`$ManifoldRuntime] && Length[messages]>0,
		Echo["Upload Packets: "<>ToString[packets, InputForm]];
	];

	If[Length[messages] > 0,
		Return[Table[$Failed, {Length[packets]}]]
	];

	(* If we are in a simulation, merge our upload packets into the $CurrentSimulation instead. *)
	If[MatchQ[$Simulation, True],
		Return@Module[{packetsWithObjectIDs, objectIDs, newObjectIDs},
			(* Add Object IDs to our packets if they don't have them. This is so that we know what new object IDs *)
			(* to return after we merge our simulation. *)

			(* NOTE: UpdateSimulation usually is the one that does this, but if we let UpdateSimulation do it, we don't *)
			(* know how to correlate the packets we passed with the new object IDs in the simulation. *)
			packetsWithObjectIDs=Map[
				Function[changePacket,
					If[KeyExistsQ[changePacket, Type] && !KeyExistsQ[changePacket, Object],
						Append[changePacket, Object -> SimulateCreateID[Lookup[changePacket, Type]]],
						changePacket
					]
				],
				withoutComputables
			];

			(* Populate $SimulatedCreatedObjects *)
			(* First, pull all ObjectIDs out of packets *)
			objectIDs = Cases[Lookup[packetsWithObjectIDs, Object], ObjectP[]];

			(* Now take the ones that don't yet exist in the database, whether simulated or real *)
			newObjectIDs = PickList[objectIDs, Not/@DatabaseMemberQ[objectIDs]];

			$SimulatedCreatedObjects = If[ListQ[$SimulatedCreatedObjects],
				Union[$SimulatedCreatedObjects, newObjectIDs],
				newObjectIDs
			];

			(* Update our simulation. *)
			$CurrentSimulation=UpdateSimulation[$CurrentSimulation, Simulation[packetsWithObjectIDs]];

			(* Return our new object IDs. *)
			Lookup[packetsWithObjectIDs, Object]
		]
	];

	withLists=addListsToMultipleFields[withoutComputables];

	verbose=Lookup[safeOps, Verbose];
	transaction=Lookup[safeOps, Transaction];
	cas=Lookup[safeOps, CAS];

	Which[MatchQ[cas, None],
		casList={},
		MatchQ[cas, _String],
		casList={cas},
		True,
		casList=cas
	];

	If[verbose,
		printProgressMessage["Uploading data to Constellation"];
	];

	response=With[
		{allowPublicObjects=Lookup[safeOps, AllowPublicObjects]},
		sendUploadObjects[withLists, False, casList, transaction, allowPublicObjects]
	];

	(* Update the time for read replication to complete *)
	readReplicationCompleteDate = Now + readReplicationWaitTime;

	(*checkUploadError will print the appropriate message if any*)
	If[checkUploadError[response],
		Return[Table[$Failed, Length[withLists]]]
	];

	(* If the request was successful but Constellation's got a message in its response, *)
	(* display it as a warning. *)
	With[
		{message = Lookup[response, "message", ""]},
		If[message != "",
			Message[Upload::Warning, message];
		];
	];

	(* Pull out the new objects that were uploaded *)
	newObjects=objectReferenceToObject /@ Lookup[response, "new_objects", {}];
	newObjects=DeleteDuplicates[ToList[newObjects]];
	ClearDownload[objectReferenceUnresolvedToObject /@ Lookup[response, "modified_references", {}]];

	(* Add the new objects to the list of objects that were created in this cell evaluation *)
	setCreatedObjects[newObjects];

	(* Maintain backwards compatibility for the moment *)
	If[ListQ[$CreatedObjects],
		$CreatedObjects=Union[$CreatedObjects, newObjects]
	];

	(* Unless printing is turned off, add the new objects to the list of new objects to print from this cell evaluation *)
	If[verbose && !TrueQ[$DisableVerbosePrinting] && ListQ[$NewVerboseObjects],
		Module[{verboseTypes},
			(*( types to print messages for *)
			verboseTypes=Replace[Lookup[safeOps, ConstellationMessage], All -> Types[]];
			(* assign to print variable *)
			$NewVerboseObjects=Union[$NewVerboseObjects, Cases[newObjects, ObjectReferenceP[verboseTypes]]]
		]
	];

	objectsToBookmark = Cases[newObjects, ObjectP[{Object[ECL`Protocol], Object[ECL`Transaction], Object[Notebook, ECL`Script]}]];
	If[ListQ[objectsToBookmark] && Length[objectsToBookmark] > 0,
		If[MatchQ[$Notebook, ObjectP[Object[LaboratoryNotebook]]],
			ECL`BookmarkObject[objectsToBookmark];
		];
	];

	clearProgressMessage[];

	(* Return all of the objects that were Uploaded *)
	parseUploadResponse /@ Lookup[response, "responses", {}]
]];


(* note that this function is only going to get called if we have $DeveloperUpload === True *)
addDeveloperObjectToPackets[packets:{__Association}]:=Module[
	{objIDs, objsExistQ, idsToDevObjectSpecified, mergedDevObjectRules, addDevObjectToPacketRules},

	(* determine whether the packets we're uploading are for new objects or existing objects *)
	objsExistQ = DatabaseMemberQ[packets];

	(* make a list of rules indicating if the DeveloperObject key has been set already *)
	objIDs = Lookup[packets, Object, Null];
	idsToDevObjectSpecified = MapThread[
		#1 -> KeyExistsQ[#2, DeveloperObject]&,
		{objIDs, packets}
	];

	(* merge together the IDs for whether DeveloperObject key is specified; if it is specified in _any_ of them, then this will be False and we don't want to add DeveloperObject *)
	(* if it _is_ specified in any of them, then we are not adding DeveloperObject to any of them *)
	addDevObjectToPacketRules = Merge[idsToDevObjectSpecified, MatchQ[#, {False..}]&];

	(* actually append DeveloperObject -> True to the relevant packets *)
	MapThread[
		Function[{packet, objExistsQ},
			Which[
				(* if there is no Object key, then this is always a new object; if DeveloperObject is set to something, then just append what we have already (i.e., do nothing); if it's not set to something, then do True *)
				Not[KeyExistsQ[packet, Object]], Append[packet, DeveloperObject -> Lookup[packet, DeveloperObject, True]],
				(* if the object does not exist and DeveloperObject was not set for that object, then set it to True *)
				Not[objExistsQ] && Lookup[addDevObjectToPacketRules, Lookup[packet, Object]], Append[packet, DeveloperObject -> True],
				(* if the object does exist, or if DeveloperObject was set for it, then don't do anything *)
				True, packet
			]
		],
		{packets, objsExistQ}
	]
];

removeComputables[packets:{___Association}]:=Map[
	removeComputables,
	packets
];
removeComputables[packet_Association]:=Association[
	DeleteCases[
		Normal[packet],
		_RuleDelayed,
		{1}
	]
];

addListsToMultipleFields[packets:{___Association}]:=Map[
	addListsToMultipleFields,
	packets
];

addListsToMultipleFields[packet_Association]:=With[
	{type=packetToType[packet]},

	Association[
		KeyValueMap[
			singleValueToList[type, #1, #2]&,
			packet
		]
	]
];

(*Multiple field not in a list, and not operated on by Delete or EraseCases*)
singleValueToList[type:typeP, (field:Append | Replace | Prepend)[symbol_Symbol], value:Except[_List | Null]]:=Rule[
	field[symbol],
	{value}
]/;(MultipleFieldQ[type[symbol]] && !IndexedFieldQ[type[symbol]]);

singleValueToList[type:typeP, (field:Append | Replace | Prepend)[symbol_Symbol], value:{Except[_List]..}]:=Rule[
	field[symbol],
	{value}
]/;(MultipleFieldQ[type[symbol]] && IndexedFieldQ[type[symbol]]);

(*All other fields remain untouched*)
singleValueToList[typeP, field:_Symbol | (uploadOperationP)[_Symbol], value_]:=Rule[
	field,
	value
];

namedOrIndexedFieldValueRowP=Null | {Except[_List]..} | _Association;

(* f6n starts transaction. Inputs are string or no parameters*)
BeginUploadTransaction[transactionID_String | PatternSequence[]]:=Module[{UUID},
	(* can't start multiple transactions with the same Id *)
	If[Quiet[Count[$CurrentUploadTransactions, transactionID]] > 0, Message[RollbackTransaction::TransactionAlreadyExists, $CurrentUploadTransactions]; Return[$Failed]];

	(* if no transactionID supplied, generate one from UUID *)
	UUID=CreateUUID[];
	If[transactionID === Null,
		$CurrentUploadTransactions=Append[$CurrentUploadTransactions, UUID]; Return[UUID],
		$CurrentUploadTransactions=Append[$CurrentUploadTransactions, transactionID]; Return[transactionID]
	];
];

(* f6n stops transaction *)
EndUploadTransaction[]:=Module[{},
	If[Not[Length[$CurrentUploadTransactions] > 0],
		Message[Warning::TransactionIsNotSet];
	];
	If[Length[$CurrentUploadTransactions] > 0,
		$CurrentUploadTransactions=Drop[$CurrentUploadTransactions, -1];
	];
];

(* ::Subsection:: *)
(*RollbackTransaction*)

DefineOptions[
	RollbackTransaction,
	Options :> {
		{Force -> False, BooleanP, "If set to false, transactions will only be rolled back if they are the last update to their field, otherwise an error will be generated. If Force is true, then transactions will always be rolled back."}
	}
];

RollbackTransaction::Error="`1`";
RollbackTransaction::InvalidResponse="Got an invalid response from the server. Please try again later.";

RollbackTransaction[transactionId_String, ops:OptionsPattern[]]:=Module[
	{safeOps, force, request, response, rollbackChanges},

	(* Grab the force option *)
	safeOps=ECL`OptionsHandling`SafeOptions[RollbackTransaction, ToList[ops], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	force=Lookup[safeOps, Force];

	(* Create constellation request with properly formatted transaction field *)
	request=<|
		"transaction" -> transactionId,
		"force" -> force
	|>;

	response=ConstellationRequest[<|
		"Path" -> apiUrl["RollbackTransaction"],
		"Body" -> ExportJSON[request],
		"Method" -> "POST"
	|>];

	(* Check for any errors *)
	If[MatchQ[response, $Failed], Return[$Failed]];
	If[checkRollbackError[response], Return[$Failed]];

	(* Parse the response for the rolled back objects and fields and present them to the user *)
	rollbackChanges=Lookup[response, "rolled_back", Nothing];
	If[NullQ[rollbackChanges],
		Return[$Failed];
	];
	rollbackChanges
];

checkRollbackError[HTTPError[__, message_String]]:=(
	Message[RollbackTransaction::Error, message];
	True
);

checkRollbackError[
	KeyValuePattern[{"error" -> message_String}]
]:=(
	Message[RollbackTransaction::Error, message];
	True
);

checkRollbackError[_]:=False;

(* Sleep, if required, until upload replication has completed *)
WaitUntilUploadReplicationComplete[] := Module[
	{sleepTime},

	(* Figure out how much time to sleep, maxing out at the readReplicationWaitTime.  This can seem unnecessary, but can cause problems if daylight savings occurs. *)
	sleepTime = Min[readReplicationCompleteDate - Now, readReplicationWaitTime];

	(* If it is more than zero, sleep for that amount! *)
	If[sleepTime > 0 Second, readReplicationTotalSleptTime = readReplicationTotalSleptTime + sleepTime; Pause[sleepTime]];

	(* And finally, clear the wait date.  Again, this can seem unnecessary, but avoids problems if day light savings occurs *)
	readReplicationCompleteDate = Min[readReplicationCompleteDate, Now];
];


(* ::Subsection:: *)
(*SuperUpload*)


(* SuperUpload *)
(* NOTE::Need to use old DefineOptions format because Widgets aren't loaded at this point.*)
DefineOptions[
	SuperUpload,
	Options :> {
		{Username -> Null, Null | _String, "Username for Login."},
		{Password -> Null, Null | _String, "Password for Login."},
		{IncludeProduction -> False, BooleanP, "Indicates if the production database is included in the list of databases where the input packet(s) will be uploaded. This also requires the  options Username and Password, as different tokens are used to log in to the Stage/Neutrino and Production databases."},
		{OutputAsTable -> True, BooleanP, "Indicates if the results should be returned as a nicely formatted table, or as a list of rules."}
	}
];

SuperUpload::UsernameAndPasswordRequired = "If syncing against Production, you must also provide a valid Username and Password as options.";
SuperUpload::PacketNotValid = "The input packet is not a valid upload packet. You can use the ValidUploadQ function to test your function's validity. Please fix any issues with your upload packets before running SuperUpload.";

SuperUpload[uploadPackets : ListableP[PacketP[]], ops : OptionsPattern[]] := Module[
	{
		safeOps, username, password, includeProduction, outputTableForm, userToken, startingDomain, databases, uploadResponse
	},

	(* Options Resolution. *)
	safeOps = ECL`OptionsHandling`SafeOptions[SuperUpload, {ops}];
	username = Lookup[safeOps, Username];
	password = Lookup[safeOps, Password];
	includeProduction = Lookup[safeOps, IncludeProduction];
	outputTableForm = Lookup[safeOps, OutputAsTable];

	(* Check if IncludeProduction->True without Username and Password. *)
	If[
		And[
			includeProduction,
			Or[
				MatchQ[username, Null],
				MatchQ[password, Null]
			]
		],
		Message[SuperUpload::UsernameAndPasswordRequired];
		Return[$Failed]
	];

	(* Check for packet/upload validity. *)
	If[!ValidUploadQ[uploadPackets],
		Message[SuperUpload::PacketNotValid];
		Return[$Failed]
	];

	(* Save user token and starting domain. *)
	userToken = GoLink`Private`stashedJwt;
	startingDomain = Global`$ConstellationDomain;

	(* List of Databases. *)
	databases = {
		(* Neutrino Databases *)
		"https://constellation-neutrino0.emeraldcloudlab.com",
		"https://constellation-neutrino1.emeraldcloudlab.com",
		"https://constellation-neutrino2.emeraldcloudlab.com",
		"https://constellation-neutrino3.emeraldcloudlab.com",
		"https://constellation-neutrino4.emeraldcloudlab.com",
		"https://constellation-neutrino5.emeraldcloudlab.com",

		(* Stage Database*)
		Stage,

		(* Production Database*)
		If[MatchQ[includeProduction, True],
			Production,
			Nothing
		]
	};

	(* Map Upload over the various inputs / databases. *)
	uploadResponse = Map[
		(* Outer Map / Function which logs into the various databases. *)
		Function[database,

			(* Login Type Determined by Options. If invalid credentials, Return[$Failed] and exit. *)
			Check[
				Which[
					(* Use token to log in.*)
					MatchQ[username, Null] && MatchQ[password, Null],
						Login[Token -> userToken, Database -> database, QuietDomainChange -> True],

					(* Prompt user for password for each login. *)
					!MatchQ[username, Null] && MatchQ[password, Null],
						Login[username, Database -> database, QuietDomainChange -> True],

					(* Use username and password, without prompt. *)
					!MatchQ[username, Null] && !MatchQ[password, Null],
						Login[username, password, Database -> database, QuietDomainChange -> True]
				];,
				(* Using second return argument to ensure we exit the module: https://reference.wolfram.com/language/ref/message/Break/nofunc.html *)
				Return[$Failed, Module],
				{Login::Server}
			];

			(* Upload the input packets. *)
			Upload[uploadPackets]

		],

		databases

	];

	(* Log back in to original DB. *)
	Echo[StringForm["Returning to starting database: ``", startingDomain]]; (* Always on message to avoid confusion from "Your session is not..." messages. *)
	Which[
		(* Use token to log in.*)
		MatchQ[username, Null] && MatchQ[password, Null],
			Login[Token -> userToken, Database -> startingDomain, QuietDomainChange -> True],

		(* Prompt user for password for each login. *)
		!MatchQ[username, Null] && MatchQ[password, Null],
			Login[username, Database -> startingDomain, QuietDomainChange -> True],

		(* Use username and password, without prompt. *)
		!MatchQ[username, Null] && !MatchQ[password, Null],
			Login[username, password, Database -> startingDomain, QuietDomainChange -> True]
	];

	(* Format the Response *)
	If[MatchQ[outputTableForm, True],
		ECL`PlotTable[Transpose@{databases, uploadResponse}, SecondaryTableHeadings -> {None, {"Database", "Changes"}}],
		MapThread[#1 -> #2&, {databases, uploadResponse}]
	]

];

Authors[SuperUpload] := {"taylor.hochuli"};
