DefineTests[PyECLRequest,
	{
		Example[{Basic, "Get an endpoint:"},
			PyECLRequest["pyecl/path/endpoint"],
			True,
			Stubs :> {
				HTTPRequestJSON[___]:=True
			}
		],
		Example[{Basic, "Use a POST request:"},
			PyECLRequest["engine/locations", Association["ids" -> {"id:12345"}]],
			True,
			Stubs :> {
				HTTPRequestJSON[___]:=True
			}
		],
		Example[{Basic, "Use a POST request with retries:"},
			PyECLRequest["engine/locations", Association["ids" -> {"id:12345"}], Retries -> 5],
			True,
			Stubs :> {
				HTTPRequestJSON[___]:=True
			}
		]
	}
];
