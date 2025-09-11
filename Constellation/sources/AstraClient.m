CallAstra::Error = "`1`";

CallAstra[arg_] := Block[{
    authHeader, httpResponse},

    authHeader = If[
        StringQ[GoLink`Private`stashedJwt],
        StringJoin["Bearer ", GoLink`Private`stashedJwt],
        Message[CallAstra::Error, "Not logged in"]; Return[$Failed, Block]
    ];

    httpResponse = URLRead[HTTPRequest[
        Global`$ConstellationDomain <> "/astra/obj/sll",
        <|
            Method -> "POST",
            "Body" -> BinarySerialize[arg, PerformanceGoal -> "Speed"],
            "ContentType" -> "application/octet-stream",
            "Headers" -> <|
                "Authorization" -> authHeader,
                "User-Agent" -> "SLL"
            |>
        |>
    ]];

    Replace[httpResponse,
        {
            _Failure :> (
                Message[CallAstra::Error, httpResponse["Message"]];
                $Failed
            ),
            _HTTPResponse :> If[httpResponse["StatusCode"] =!= 200,
                (
                    Message[CallAstra::Error, httpResponse["StatusCodeDescription"]];
                    $Failed
                ),
                CompressedData[httpResponse["Body"]]
            ]
        }
    ]
];
