DefineTests[InitializeAsynchronousUpload,
    {
        (*Flaky Test*)
        (*Test["InitializeAsynchronousUpload launches a telescope process:",
            Module[{linksBefore, linksAfter},
                linksBefore = Length[Links[]];
                InitializeAsynchronousUpload[];
                linksAfter = Length[Links[]];

                linksBefore < linksAfter
            ],
            True
        ],*)

        Test["InitializeAsynchronousUpload does nothing after calling it the first time:",
            Module[{linksBefore, linksAfter},

                InitializeAsynchronousUpload[];

                linksBefore = Length[Links[]];
                InitializeAsynchronousUpload[];
                linksAfter = Length[Links[]];

                linksBefore == linksAfter
            ],
            True
        ]
    }

];

DefineTests[AsynchronousUpload,
    {
        Test["Upload a new object asynchronously:",

            AsynchronousUpload[<|
                Type->Object[Example, Data],
                Number -> 5.0
            |>]

            ,
            True
        ],

        Test["AsynchronousUpload is much faster than normal Upload",
            Module[{asyncTiming, syncTiming},

                InitializeAsynchronousUpload[];

                asyncTiming = AbsoluteTiming[
                    AsynchronousUpload[<|
                        Type->Object[Example, Data],
                        Number -> 5.0
                    |>]][[1]];

                syncTiming = AbsoluteTiming[
                    Upload[<|
                        Type->Object[Example, Data],
                        Number -> 5.0
                    |>]
                ][[1]];

                syncTiming > asyncTiming
            ]
            ,
            True
        ]


    }

];

DefineTests[AwaitAsynchronousUpload,
    {
        Test["AwaitAsynchronousUpload waits until all uploads have been finished.  Its timing is closer to Upload than it is to AsynchronousUpload alone. ",
            Module[{asyncTiming, awaitAsyncTiming, syncTiming},
                InitializeAsynchronousUpload[];
                awaitAsyncTiming = AbsoluteTiming[
                    AsynchronousUpload[<|
                        Type->Object[Example, Data],
                        Number -> 5.0
                    |>];
                    AwaitAsynchronousUpload[];
                ][[1]];

                asyncTiming = AbsoluteTiming[
                    AsynchronousUpload[<|
                        Type->Object[Example, Data],
                        Number -> 5.0
                    |>]][[1]];

                syncTiming = AbsoluteTiming[
                    Upload[<|
                        Type->Object[Example, Data],
                        Number -> 5.0
                    |>]
                ][[1]];

                Abs[awaitAsyncTiming-syncTiming] < Abs[awaitAsyncTiming-asyncTiming]
            ],
            True
        ]
    }

];
