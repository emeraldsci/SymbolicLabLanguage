Options[WriteUpload] = {AllowPublicObjects -> False};

$AsyncUploadRequests = {};

(* Write upload takes the input packets and converts them  *)
WriteUpload[packet_Association, ops:OptionsPattern[]] := WriteUpload[{packet}, ops];

WriteUpload[packets:{__Association}, ops:OptionsPattern[]]:=Module[
    {invalidInputs, errors, messages, withoutComputables, withLists, response, linkContexts,
        groupedLinkContexts, casList, packetsWithDevObjects},

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

    If[Length[messages] > 0,
        Return[Table[$Failed, {Length[packets]}]]
    ];

    withLists=addListsToMultipleFields[withoutComputables];

    casList={};

    AppendTo[$AsyncUploadRequests, Hold[packets]];
    response=With[
        {allowPublicObjects=OptionValue[AllowPublicObjects]},
        writeUploadObjects[withLists, False, casList, None, allowPublicObjects]
    ];
];

ReadUpload[f:GoLink`Private`TelescopeRead|GoLink`Private`TelescopeTryRead] := Module[{responses},

    (*Grab all upload objects from the link.
     This will be a list of list of associations that have been returned from Constellation *)
    responses = readUploadObjects[f];

    Check[
        Map[Function[{response},
            (*checkUploadError will print the appropriate message if any*)
            checkAsyncUploadError[response];
            $AsyncUploadRequests = Rest[$AsyncUploadRequests];
        ], responses],

        Return[$Failed, Module]
    ];

    Map[Function[{response},
        (* If the request was successful but Constellation got a message in its response, *)
        (* display it as a warning. *)
        With[
            {message = Lookup[response, "message", ""]},
            If[message != "",
                Message[Upload::Warning, message];
            ];
        ];
        (* Reset cache of the Main (synchronous) Telescope for asynchronously uploaded objects. *)
        ClearDownload[objectReferenceUnresolvedToObject /@ Lookup[response, "modified_references", {}]];
    ],responses];

    (* Do not want to return any objects, since it is from previous request*)
    True
];

AsynchronousUpload::Failure = "The following AsynchronousUpload call failed: `1`";

checkAsyncUploadError[HTTPError[__, message_String]]:=(
    Message[AsynchronousUpload::Failure, First[$AsyncUploadRequests]];
    Message[Upload::Error, message];
    True
);

checkAsyncUploadError[
    KeyValuePattern[{"status_code" -> status:Except[1, _Integer], "message" -> message_String}]
]:=With[
    {error=Lookup[Constellation`Private`uploadStatus, status]},
    Message[AsynchronousUpload::Failure, First[$AsyncUploadRequests]];
    Message[MessageName[Upload, error], message];
    True
];

checkAsyncUploadError[_]:=False;

(* Run function without ignoring transactions by default *)
writeUploadObjects[
    packets:{__Association},
    emptyObjects:BooleanP,
    casTokens:{___String},
    allowPublicObjects:BooleanP
]:=writeUploadObjects[packets, emptyObjects, casTokens, None, allowPublicObjects];

writeUploadObjects[packets:{__Association},
    emptyObjects:BooleanP,
    casTokens:{___String},
    transaction:(Automatic | None | _String),
    allowPublicObjects:BooleanP
]:=Module[
    {requests, shardedRequests, url, body, bigDataUploadResult, sllTransactions, validateLinks},

    If[!MatchQ[casTokens, {}] && !SameQ[Length[packets], Length[casTokens]],
        Message[Warning::CasLengthMismatch];
        Return[HTTPError[None, "Error uploading packets with provided CAS tokens"]]
    ];

    (* Create the upload requests from the packets provided *)
    If[MatchQ[casTokens, {}],
        requests=<|"requests" -> Map[
            makeUploadRequest[#, emptyObjects, Null]&,
            packets
        ]|>,
        requests=<|"requests" -> MapThread[
            makeUploadRequest[#1, emptyObjects, #2]&,
            {packets, casTokens}
        ]|>
    ];

    (* Next, upload the blob references in the request, if any *)
    bigDataUploadResult=uploadBlobReferences[Cases[requests, jsonBlobReferenceP, Infinity]];
    If[bigDataUploadResult === $Failed,
        Return[HTTPError[None, "Error uploading BigCompressed or BigQuantityArray field(s)"]]
    ];

    (* Fix the pathing information for blob references in the main upload request to match what the server returned *)
    shardedRequests = If[Length[bigDataUploadResult] == 0,
        requests,
        Append[requests, <|"requests"->updateBlobReferenceShardInfo[Lookup[requests, "requests", {}], bigDataUploadResult]|>]
    ];

    (* Now, include the transaction information, if supplied, in the request *)
    sllTransactions=<||>;

    (* Determine the correct url to use *)
    url=apiUrl["Upload"];

    (* Only validate links on stage and in Engine *)
    validateLinks = <|"validate_links"->
        If[
            MatchQ[$ECLApplication, Engine] || !ProductionQ[],
            True,
            False
        ]
    |>;

    (* Convert the request body into unicode JSON *)
    body=Check[
        exportUnicodeJSON[Join[shardedRequests, sllTransactions, validateLinks]],
        $Failed
    ];

    (* If the conversion failed, record the failure somewhere so we can debug *)
    If[body === $Failed,
        With[
            {errorPath=FileNameJoin[{$TemporaryDirectory, ToString[UnixTime[]]<>"_upload_failure.mx"}]},

            Export[errorPath, {packets, shardedRequests}, "MX"];
            Return[HTTPError[None, "Unable to generate JSON request body. See "<>errorPath]]
        ]
    ];

    (* Send the main upload request! *)
    GoLink`Private`writeConstellationRequest[<|
        "Path" -> url,
        "Body" -> body,
        "Method" -> "PUT",
        (*Increase timeout for upload beyond 120000 default as some large uploads make take a long time.*)
        "Timeout" -> 720000,
        "Headers" -> notebookHeaders[allowPublicObjects]
    |>,
        Retries -> 4,
        RetryMode -> Write
    ]
];

readUploadObjects[f:GoLink`Private`TelescopeRead|GoLink`Private`TelescopeTryRead]:=
    GoLink`Private`readConstellationResponse[f];



(* ======== Exported Functions ========= *)

InitializeAsynchronousUpload[] := (
    (*On first call, launch the new Async Telescope process*)
    GoLink`Private`LaunchAsyncTelecope[];

    (*and update definitions to make and wait for asynchronous uploads*)
    Clear[InitializeAsynchronousUpload, AsynchronousUpload, AwaitAsynchronousUpload];

    InitializeAsynchronousUpload[] := Null;
    AsynchronousUpload[arg: _Association | {__Association}, rest___] :=
        Module[{responses},
            (*Read any responses from previous calls to AsyncUpload, and surface any errors that occur.*)
            responses = ReadUpload[GoLink`Private`TelescopeTryRead];
            (*Write the upload request*)
            WriteUpload[arg, rest];
            responses
        ];
    AwaitAsynchronousUpload[] := ReadUpload[GoLink`Private`TelescopeRead];

    True
);


Options[AsynchronousUpload] = {AllowPublicObjects -> False};

AsynchronousUpload[arg: _Association | {__Association}, rest___] := (
    InitializeAsynchronousUpload[];
    AsynchronousUpload[arg, rest]
);

AwaitAsynchronousUpload[] := {};
