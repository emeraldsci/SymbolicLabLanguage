DefineTests[
    CallAstra,
    {
        Test["If Astra responds with a Status 200, then the body which is a Compressed Expression can be read:",
            CallAstra[Astra`Search[Object[Example, Data], #[Notebook]!=Null &, 5]],
            (*Mocked body of the HTTP response*)
            {
                Object[Example, Data, "id:n0k9mGOWXv4w"],
                Object[Example, Data, "id:1ZA60vzxnYbE"],
                Object[Example, Data, "id:bq9LA01KkMGa"],
                Object[Example, Data, "id:L8kPEjOomM44"],
                Object[Example, Data, "id:01G6nvDxxLXA"]
            },

            Stubs :> {
                (* This mocks the response from the Astra server *)
                URLRead[___]:=HTTPResponse[
                    ByteArray["MTplTnFWaTkwS3dpQUFSb1grTG51RzNrQkJSdXRPbUhpUnc2aUxWbmRhRzJ5bUt4U1RuajYzTi9EbWNENzR6azZONTI0RkFIRExCTjQ3M3kybXRVNFFhbWdmM20yUzBpak4rOVhPcDBwNmVka202WjhIQzNWcG1MZzJBWCt6UW5RbkJReS9hRytLWm9YcVUzSUMwVkhYVEdhRmZLOVBkQkNqcVRIT0NpRmloUTFWakx3aGZ3UXRTR3M9"],
                    <|"Headers" -> {
                        {"Content-Type", "text/plain; charset=utf-8"},
                        {"Transfer-Encoding", "chunked"},
                        {"content-encoding", "gzip"},
                        {"vary", "Accept-Encoding"}
                    },
                        "StatusCode" -> 200,
                        "Cookies" -> {}
                    |>,
                    CharacterEncoding -> Automatic]
            }
        ],

        Test["If Astra responds with a non-200 status like 403, the body is ignored, and a brief status code description is issued",
            CallAstra[Astra`Search[Object[User], StringStartsQ[#[Name], "joe"] &]],
            $Failed,
            Messages:>{CallAstra::Error},
            Stubs :> {
                URLRead[___]:=HTTPResponse[
                    ByteArray["PCFET0NUWVBFIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KPGhlYWQ+CiAgICA8bWV0YSBjaGFyc2V0PSJ1dGYtOCI+CiAgICA8bWV0YSBuYW1lPSJjb2xvci1zY2hlbWUiIGNvbnRlbnQ9ImxpZ2h0IGRhcmsiPgogICAgPHRpdGxlPjQwMyBGb3JiaWRkZW48L3RpdGxlPgo8L2hlYWQ+Cjxib2R5IGFsaWduPSJjZW50ZXIiPgogICAgPGRpdiByb2xlPSJtYWluIiBhbGlnbj0iY2VudGVyIj4KICAgICAgICA8aDE+NDAzOiBGb3JiaWRkZW48L2gxPgogICAgICAgIDxwPlRoZSBzZXJ2ZXIgcmVmdXNlZCB0byBhdXRob3JpemUgdGhlIHJlcXVlc3QuPC9wPgogICAgICAgIDxociAvPgogICAgPC9kaXY+CiAgICA8ZGl2IHJvbGU9ImNvbnRlbnRpbmZvIiBhbGlnbj0iY2VudGVyIj4KICAgICAgICA8c21hbGw+Um9ja2V0PC9zbWFsbD4KICAgIDwvZGl2Pgo8L2JvZHk+CjwvaHRtbD4="],
                    <|"Headers" -> {
                        {"Content-Type", "text/html; charset=utf-8"},
                        {"content-encoding", "gzip"},
                        {"vary", "Accept-Encoding"}
                    },
                        "StatusCode" -> 403,
                        "Cookies" -> {}
                    |>,
                    CharacterEncoding -> Automatic]
            }
        ],

        Test["If the JWT stored in the global variable GoLink`Private`stashedJwt is not a String, then issue a message and return $Failed:",
            CallAstra[Astra`Search[Object[Instrument, HPLC], #[Status] == InUse &]],
            $Failed,
            Messages:>{CallAstra::Error},
            Stubs :> {
                GoLink`Private`stashedJwt = 1,
                (* In case the test failed, this should prevent making a call into Astra*)
                URLRead[___]:=Null
            }
        ]
    }
];
