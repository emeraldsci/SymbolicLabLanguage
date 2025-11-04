DefineUsage[PyECLRequest,
	{
		BasicDefinitions -> {
			{"PyECLRequest[endpoint]", "response", "Makes a request to the PyECL server at the given 'endpoint' and returns the response."},
			{"PyECLRequest[endpoint, body]", "response", "Makes a request to the PyECL server at the given 'endpoint' with the given 'body' and returns the response."}
		},
		MoreInformation -> {
			"The PyECLRequest function is used to make requests to the PyECL server. It uses Mathematica's built-in URLRead and HTTPRequest functions.",
			"When the body contains File[] objects, the request will be sent as multipart form data. Otherwise, it defaults to JSON content."
		},
		Input :> {
			{"endpoint", "String", "The endpoint to make the request to."},
			{"body", "Association", "The body of the HTTP request. If no body is provided, a GET request will be made, otherwise a POST request will be made. File[] objects in the body will trigger multipart form data."}
		},
		Output :> {
			{"response", "Association", "The response from the server."}
		},
		SeeAlso -> {"HTTPRequestJSON"},
		Author -> {"robert"}
	}
]
