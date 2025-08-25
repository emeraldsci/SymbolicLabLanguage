DefineOptions[PyECLRequest,
	Options :> {
		{BaseURL -> Automatic, Automatic|_String, "The server's URL to use for the request. This can be set to localhost for development purposes."},
		{Retries -> 3, _Integer, "The number of times to retry the HTTP request if it fails."}
	}
];

PyECLRequest::HTTPRequestFailed = "The server returned an error when attempting to perform the HTTP requests. Request: `1`. Response `2`.";
PyECLRequest[endpoint_String,ops:OptionsPattern[]]:=PyECLRequest[endpoint, Null, ops];
PyECLRequest[endpoint_String, body:(Null|_Association), ops:OptionsPattern[]]:=Module[
	{response, fullEndpoint, baseEndpoint},

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

	(* make the request. the response will be an HTTPError if the request fails *)
	response = HTTPRequestJSON[
		Association[
			"URL" -> fullEndpoint,
			"Headers" -> <|
				"Authorization" -> "Bearer " <> GoLink`Private`stashedJwt,
				"Content-Type" -> "application/json",
				(* If we are not using the default production or test URL, we need to send the X-Constellation-Host header
				such that the python server knows which database to use, otherwise it will use the stage database or prod *)
				If[!MemberQ[Join[productionObjStoreURLs, testObjStoreURLs], Global`$ConstellationDomain],
					"X-Constellation-Host" -> Global`$ConstellationDomain,
					Nothing
				]
			|>,
			"Method" -> If[MatchQ[body, Null], "GET", "POST"],
			If[!MatchQ[body, Null],
				"Body" -> body,
				Nothing
			]
		],
		Retries -> OptionValue[Retries]
	];

	(* Return if there was a global failure *)
	If[MatchQ[response,_HTTPError],
		Message[PyECLRequest::HTTPRequestFailed, fullEndpoint, response];
		$Failed,
		(* Return the response *)
		response
	]
];