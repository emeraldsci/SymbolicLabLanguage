
(* ::Subsection::Closed:: *)
(*BigQuantityArraySpan*)

DefineTests[BigQuantityArraySpan,
	{

		(* ----- Basic examples ----- *)

		Example[{Basic, "Download the first 100 elements of a big quantity array:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 1, 100],
	      	_?(Length[#]===100&)
	    ],
		Example[{Basic, "Download the second 100 elements of a big quantity array:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 101, 200],
	      	_?(Length[#]===100&)
	    ],
		Example[{Basic, "Download the last 100 elements of a big quantity array:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 901, 1000],
	      	_?(Length[#]===100&)
	    ],
        (*TODO: add comma back in above once other tests are added *)

		(* ----- Messages ----- *)

		Example[{Messages, "RequestTooLarge", "If the requested span is larger than the BigQuantityArrayByteLimit option, it won't get downloaded:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 1, 100, BigQuantityArrayByteLimit -> Quantity[1, "Bytes"]],
	      	$Failed,
	      	Messages :> {Message[BigQuantityArraySpan::RequestTooLarge]}
	    ],
		Example[{Messages, "InvalidField", "If the input field is not a BigQuantityArray, then an error will be thrown:"},
	        BigQuantityArraySpan[obj, QuantityArray1D, 1, 100, BigQuantityArrayByteLimit -> Quantity[1, "Bytes"]],
	      	$Failed,
	      	Messages :> {Message[BigQuantityArraySpan::InvalidField]}
	   ],
		Example[{Messages, "InvalidSpan", "If a span is requested that is completely outside the range of the stored file, an InvalidSpan error will be thrown:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 20000, 20100],
	      	$Failed,
	      	Messages :> {Message[BigQuantityArraySpan::InvalidSpan]}
	   	],
		Example[{Messages, "HTTPError", "If an error is encountered during the HTTP request, an error is thrown:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 1, 100, FileLocation->Cloud],
	      	$Failed,
	      	Messages :> {BigQuantityArraySpan::HTTPError},
			Stubs :> {
				Constellation`Private`getS3Span[___]:=Module[{},{
					400,
					"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Error><Code>InvalidRange</Code><Message>The requested range is not satisfiable</Message><RangeRequested>bytes=2400232-2400280</RangeRequested><ActualObjectSize>24256</ActualObjectSize><RequestId>6P8V24V3C31Z8BMM</RequestId><HostId>grJQ+DyYd+P+V642nxctPyv4+VnbcnwtIUWYWNlzGizMH+pKgrmd4Vqf+QFH20wLy2nOrsxqFG4=</HostId></Error>"
				}]
			}
	   	],
		Example[{Messages, "IndexError", "If the starting index is larger than the stopping index, an IndexError will be thrown:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 100, 1],
	      	$Failed,
	      	Messages :> {Message[BigQuantityArraySpan::IndexError]}
	   	],

	   (* ----- OPTIONS ----- *)

		Example[{Options, FileLocation, "The FileLocation option describes where the file is stored for processing; the span can be downloaded from the cloud, or processed from the local disk:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 1, 100, FileLocation -> Cloud],
	      	_?(Length[#]===100&)
	   	],
		Example[{Options, BigQuantityArrayByteLimit, "Setting the BigQuantityArrayByteLimit option prevents the downloading of spans that take up too much memory:"},
	        BigQuantityArraySpan[obj, BigDataQuantityArray, 1, 100, BigQuantityArrayByteLimit -> Quantity[10, "MB"]],
	      	_?(Length[#]===100&)
	   ]
	},
	Variables :> {obj},
	SymbolSetUp :> (
		Module[{bigQA},
	        bigQA=QuantityArray[RandomReal[10000, {1000, 3}], {Minute, Meter Nano, AbsorbanceUnit Milli}];
	        obj=Upload[<|Type -> Object[Example, Data], BigDataQuantityArray -> bigQA|>];
		];
	)
];

(* ::Section::Closed:: *)
(*DownloadBigQuantityArraySpan*)
DefineTests[DownloadBigQuantityArraySpan,
	{

		(* ----- Basic examples ----- *)

		Example[{Basic, "Download the first 100 elements of a big quantity array:"},
	        DownloadBigQuantityArraySpan[obj, BigDataQuantityArray, 1, 100],
	      	_?(Length[#]===100&)
	    ],
		Example[{Basic, "Download the second 100 elements of a big quantity array:"},
	        DownloadBigQuantityArraySpan[obj, BigDataQuantityArray, 101, 200],
	      	_?(Length[#]===100&)
	    ],
		Example[{Basic, "Download the last 100 elements of a big quantity array:"},
	        DownloadBigQuantityArraySpan[obj, BigDataQuantityArray, 901, 1000],
	      	_?(Length[#]===100&)
	    ],

		(* ---- TESTS ---- *)
		Test["If a span is requested that is completely outside the range of the stored file, and HTTP error will be thrown:",
	        DownloadBigQuantityArraySpan[obj, BigDataQuantityArray, 20000, 20100],
	      	$Failed,
	      	Messages :> {Message[BigQuantityArraySpan::InvalidSpan]}
	   	]
	},
	Variables :> {obj},
	SymbolSetUp :> (
		Module[{bigQA},
	        bigQA=QuantityArray[RandomReal[10000, {1000, 3}], {Minute, Meter Nano, AbsorbanceUnit Milli}];
	        obj=Upload[<|Type -> Object[Example, Data], BigDataQuantityArray -> bigQA|>];
		];
	)];
