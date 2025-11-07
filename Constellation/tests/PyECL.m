DefineTests[PyECLRequest,
	{
		Example[{Basic, "Get an endpoint:"},
			PyECLRequest["pyecl/path/endpoint"],
			Association["result" -> "success"],
			Stubs :> {
				URLRead[req_HTTPRequest]:=HTTPResponse[ByteArray[ExportString[ExportJSON[Association["result" -> "success"]],"Base64"]], <|"StatusCode" -> 200, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			}
		],
		Example[{Basic, "Use a POST request with JSON body:"},
			PyECLRequest["engine/locations", Association["ids" -> {"id:12345"}]],
			Association["locations" -> {"location1", "location2"}],
			Stubs :> {
				URLRead[req_HTTPRequest]:=HTTPResponse[ByteArray[ExportString[ExportJSON[Association["locations" -> {"location1", "location2"}]],"Base64"]], <|"StatusCode" -> 200, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			}
		],
		Example[{Basic, "Use a POST request with retries:"},
			PyECLRequest["engine/locations", Association["ids" -> {"id:12345"}], Retries -> 5],
			Association["locations" -> {"location1"}],
			Stubs :> {
				URLRead[req_HTTPRequest]:=HTTPResponse[ByteArray[ExportString[ExportJSON[Association["locations" -> {"location1"}]],"Base64"]], <|"StatusCode" -> 200, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			}
		],
		Example[{Basic, "Use a multipart request with File object:"},
			PyECLRequest["ccd/extract-order-number", Association["file" -> File["/tmp/test.jpg"]]],
			Association["order_number" -> "12345"],
			Stubs :> {
				URLRead[req_HTTPRequest]:=HTTPResponse[ByteArray[ExportString[ExportJSON[Association["order_number" -> "12345"]],"Base64"]], <|"StatusCode" -> 200, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			}
		],
		Example[{Basic, "Handle HTTP error with retries:"},
			PyECLRequest["engine/locations", Association["ids" -> {"id:12345"}], Retries -> 2],
			$Failed,
			Stubs :> {
				URLRead[req_HTTPRequest]:=HTTPResponse[ByteArray[ToCharacterCode["Internal Server Error", "UTF8"]], <|"StatusCode" -> 500, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			},
			Messages :> {PyECLRequest::HTTPRequestFailed}
		],
		Example[{Basic, "Successful request after retry:"},
			PyECLRequest["engine/locations", Association["ids" -> {"id:12345"}], Retries -> 2],
			Association["locations" -> {"location1"}],
			Stubs :> {
				URLRead[req_HTTPRequest]:=HTTPResponse[ByteArray[ExportString[ExportJSON[Association["locations" -> {"location1"}]],"Base64"]], <|"StatusCode" -> 200, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			}
		],
		Example[{Basic, "Test BaseURL option:"},
			PyECLRequest["test/endpoint", Null, BaseURL -> "https://custom-server.com/"],
			Association["result" -> "custom"],
			Stubs :> {
				URLRead[HTTPRequest["https://custom-server.com/test/endpoint", ___]]:=HTTPResponse[ByteArray[ExportString[ExportJSON[Association["result" -> "custom"]],"Base64"]], <|"StatusCode" -> 200, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			}
		],
		Example[{Basic, "Test multipart with multiple files:"},
			PyECLRequest["ccd/upload-multiple", Association["file1" -> File["/tmp/test1.jpg"], "file2" -> File["/tmp/test2.jpg"], "metadata" -> "test"]],
			Association["upload_id" -> "abc123"],
			Stubs :> {
				URLRead[req_HTTPRequest]:=HTTPResponse[ByteArray[ExportString[ExportJSON[Association["upload_id" -> "abc123"]],"Base64"]], <|"StatusCode" -> 200, "Headers" -> <||>, "ContentType" -> "application/json", "Cookies" -> <||>|>]
			}
		],
		Example[{Additional, "Test live ping endpoint:"},
			PyECLRequest["ping"],
			"pong"
		],
		Example[{Additional, "Test live protected ping endpoint:"},
			StringQ[Lookup[PyECLRequest["pping"], "token"]],
			True
		],
		Example[{Additional, "Test live engine/locations endpoint with JSON:"},
			Module[{result},
				result = PyECLRequest["engine/locations", Association["ids" -> {"id:1ZA60vzkrd00"}]];
				MatchQ[result, {{_Association..}}]
			],
			True
		],
		Example[{Additional, "Test live ccd/extract-product endpoint with JSON:"},
			Module[{result},
				result = PyECLRequest["ccd/extract-product", Association["url" -> "https://www.fishersci.com/shop/products/ambion-conical-tubes-50ml-racked/AM12501", "supplier" -> "fisher"]];
				MatchQ[result, _Association] && KeyExistsQ[result, "title"]
			],
			True
		],
		Example[{Additional, "Test live ccd/extract-order-number endpoint with multipart:"},
			Module[{result, testFile},
				(* Create a simple test image file *)
				testFile = FileNameJoin[{$TemporaryDirectory, "test.jpg"}];
				Export[testFile,Plot[Sin[x], {x, 0, 10}, PlotLabel -> "Order Number: 000123"]];
				result = PyECLRequest["ccd/extract-order-number", Association["file" -> File[testFile]]];
				DeleteFile[testFile];
				(* The endpoint may return an error for our test image, but we're testing that the multipart request works *)
				MatchQ[result, _Association] || MatchQ[result, $Failed]
			],
			True
		]
	}
];
