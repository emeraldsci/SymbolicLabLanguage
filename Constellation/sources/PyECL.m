DefineOptions[PyECLRequest,
	Options :> {
		{BaseURL -> Automatic, Automatic|_String, "The server's URL to use for the request. This can be set to localhost for development purposes."},
		{Retries -> 3, _Integer, "The number of times to retry the HTTP request if it fails."}
	}
];

PyECLRequest::HTTPRequestFailed = "The server returned an error when attempting to perform the HTTP requests. Request: `1`. Response `2`.";
PyECLRequest[endpoint_String,ops:OptionsPattern[]]:=PyECLRequest[endpoint, Null, ops];
PyECLRequest[endpoint_String, body:(Null|_Association), ops:OptionsPattern[]]:=Module[
	{response, fullEndpoint, baseEndpoint, retryCount, maxRetries, requestAssoc, contentType, requestBody},

	(* resolve the endpoint based on the database *)
	baseEndpoint = Which[
		!MatchQ[OptionValue[BaseURL], Automatic],
			OptionValue[BaseURL],
		ProductionQ[],
			"https://api.emeraldcloudlab.com/",
		True,
			"https://api-stage.emeraldcloudlab.com/"
	];

	(* create the full endpoint *)
	fullEndpoint = StringJoin[baseEndpoint, endpoint];

	(* determine content type and body format based on body content *)
	{contentType, requestBody} = Which[
		MatchQ[body, Null],
			{"application/json", ""},
		(* Check if body contains File[] objects for multipart *)
		!FreeQ[body, _File],
			{"multipart/form-data", body},
		(* Default to JSON *)
		True,
			{"application/json", ExportJSON[body]}
	];

	(* prepare the request association *)
	requestAssoc = Association[
		"Method" -> If[MatchQ[body, Null], "GET", "POST"],
		"Headers" -> <|
			"Authorization" -> "Bearer " <> GoLink`Private`stashedJwt,
			"Content-Type" -> contentType,
			(* If we are not using the default production or test URL, we need to send the X-Constellation-Host header
			such that the python server knows which database to use, otherwise it will use the stage database or prod *)
			If[!MemberQ[Join[productionObjStoreURLs, testObjStoreURLs], Global`$ConstellationDomain],
				"X-Constellation-Host" -> Global`$ConstellationDomain,
				Nothing
			]
		|>,
		If[!MatchQ[requestBody, ""],
			"Body" -> requestBody,
			Nothing
		]
	];

	(* implement retry logic *)
	maxRetries = OptionValue[Retries];
	retryCount = 0;
	
	While[retryCount <= maxRetries,
		response = URLRead[HTTPRequest[fullEndpoint, requestAssoc]];
		(* Check if request was successful *)
		If[MatchQ[response, _HTTPResponse] && response["StatusCode"] < 400,
			(* Success - return the body *)
			(* Weirdly mathematica renames Content-Type to ContentType in the response,
			despite our server using/sending Content-Type *)
			formattedResponse = If[MatchQ[response["ContentType"], "application/json"],
				importJSONToAssociation[response["Body"]],
				response["Body"]
			];
			Return[formattedResponse],
			(* Failure - increment retry count *)
			retryCount++
		];
		
		(* If we've exhausted retries, break *)
		If[retryCount > maxRetries,
			Break[]
		];
		
	];

	(* If we get here, all retries failed *)
	Message[PyECLRequest::HTTPRequestFailed, fullEndpoint, response];
	$Failed
];


importJSONToAssociation[string_String]:=Module[{sanitizedString},
	sanitizedString = StringReplace[
		string,
		Alternatives @@ AppHelpers`Private`$MMSpecialCharacters :> ""
	];
	If[MatchQ[string, ""], Return[$Failed]];
	ImportByteArray[StringToByteArray[sanitizedString], "RawJSON"]
];