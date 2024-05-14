
(* ::Section::Closed:: *)
(*PlotTimeSlice*)


DefineTests[PlotTimeSlice,
    {
        Example[
            {Basic, "Plotting a time slice for an LCMS object creates a Mass Spectrometry graphics object:"},
            PlotTimeSlice[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], 1 Minute],
            ValidGraphicsP[]
        ],
        Example[
            {Basic, "Plotting a couple time slices for an LCMS object creates a plot with multiple data groups:"},
            PlotTimeSlice[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], {1 Minute, 2 Minute}],
            ValidGraphicsP[]
        ],
        Example[
            {Basic, "Plotting a time slice for multiple LCMS objects creates a plot with multiple data groups:"},
            PlotTimeSlice[{
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID],
                Object[Data, ChromatographyMassSpectra, "Test data 2 - "<>$SessionUUID]
            }, 1 Minute],
            ValidGraphicsP[]
        ],

        (* ---- OPTIONS ---- *)

        Example[
            {Options, ReferenceField, "The IonAbundance3D field can be sliced into plots by using the ReferenceField option:"},
            PlotTimeSlice[
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], 1 Minute, ReferenceField->IonAbundance3D],
            ValidGraphicsP[]
        ],
        Example[
            {Options, BigQuantityArrayByteLimit, "The BigQuantityArrayByteLimit option controls the maximum amount of data that is downloaded at any point in time:"},
            PlotTimeSlice[
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], 1 Minute, BigQuantityArrayByteLimit->Quantity[100000, "Bytes"]],
            ValidGraphicsP[]
        ],
        Example[
            {Options, TimeSliceSpans, "The TimeSliceSpans option allows the user to specify the time slice spans if previously calculated with TimeSliceSpans:"},
            PlotTimeSlice[
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], 1 Minute, TimeSliceSpans-><|(1 Minute) -> {1, 100}|>],
            ValidGraphicsP[]
        ],

    (* ----- MESSAGES ----- *)

        Example[
            {Messages, "InexactTime", "Choosing an input time that does not exactly match any of the data slices will result in a warning that the nearest time slice is used to make the plot:"},
            PlotTimeSlice[
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], 1.4 Minute],
            ValidGraphicsP[],
            Messages :> {Warning::InexactTime}
        ]
        (* TODO: add test to plot abs spec data *)
    },

    (* Symbol set up must create the test data *)
    SymbolSetUp :> (
        $CreatedObjects = {};
        setUpTestObjects[];
    ),
    SymbolTearDown :> (
        tearDownTestObjects[];
    ),
    Stubs :> {
        UploadCloudFile[file_String]:=stubUploadCloudFile[file],
        ImportCloudFile[object_]:=testTimeSliceSpans[object]
    }
];


(* ::Section::Closed:: *)
(*TimeSliceSpans*)


DefineTests[TimeSliceSpans,
    {
        Example[
            {Basic, "Find the index spans defining the time slices for :"},
            TimeSliceSpans[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], IonAbundance3D],
            _Association
        ],
        Example[
            {Basic, "Plotting a couple time slices for an LCMS object creates a plot with multiple data groups:"},
            TimeSliceSpans[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], {IonAbundance3D, Absorbance3D}],
            {_Association, _Association}
        ],
        Example[
            {Basic, "Plotting a time slice for multiple LCMS objects creates a plot with multiple data groups:"},
            TimeSliceSpans[{
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID],
                Object[Data, ChromatographyMassSpectra, "Test data 2 - "<>$SessionUUID]
            }, IonAbundance3D],
            {_Association, _Association}
        ]
    },
    (* Symbol set up must create the test data *)
    SymbolSetUp :> (
        $CreatedObjects = {};
        setUpTestObjects[];
    ),
    SymbolTearDown :> (
        tearDownTestObjects[];
    ),
    Stubs :> {
        UploadCloudFile[file_String]:=stubUploadCloudFile[file],
        ImportCloudFile[object_]:=testTimeSliceSpans[object]
    }
];


(* ::Section::Closed:: *)
(*TimeSlice*)


DefineTests[TimeSlice,
    {
        Example[
            {Basic, "Find a time slice for an LCMS data object at a given time:"},
            TimeSlice[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], 1 Minute],
            QuantityArrayP[]
        ],
        Example[
            {Basic, "Find a time slice for an LCMS data object at two different times yields a list of two data slices:"},
            TimeSlice[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], {1 Minute, 2 Minute}],
            {QuantityArrayP[]..}
        ],
        Example[
            {Basic, "Find a time slice for two LCMS data objects at a time yields a list of two data slices:"},
            TimeSlice[{
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID],
                Object[Data, ChromatographyMassSpectra, "Test data 2 - "<>$SessionUUID]
            }, 1 Minute],
            {QuantityArrayP[]..}
        ]
    },
    (* Symbol set up must create the test data *)
    SymbolSetUp :> (
        $CreatedObjects = {};
        setUpTestObjects[];
    ),
    SymbolTearDown :> (
        tearDownTestObjects[];
    ),
    Stubs :> {
        UploadCloudFile[file_String]:=stubUploadCloudFile[file],
        ImportCloudFile[object_]:=testTimeSliceSpans[object]
    }
];


(* ::Section::Closed:: *)
(*SaveTimeSliceSpans*)


DefineTests[SaveTimeSliceSpans,
    {
        Example[
            {Basic, "Saving a set of time slice spans for a field of an LCMS object creates an Emerald cloud file:"},
            SaveTimeSliceSpans[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], IonAbundance3D],
            ObjectP[Object[EmeraldCloudFile]]
        ],
        Example[
            {Basic, "Saving a set of time slice spans for two fields of an LCMS object creates two Emerald cloud files:"},
            SaveTimeSliceSpans[Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID], {IonAbundance3D, Absorbance3D}],
            {ObjectP[Object[EmeraldCloudFile]]..}
        ],
        Example[
            {Basic, "Saving a set of time slice spans for a field of two LCMS objects creates two Emerald cloud files:"},
            SaveTimeSliceSpans[{
                Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID],
                Object[Data, ChromatographyMassSpectra, "Test data 2 - "<>$SessionUUID]
            }, IonAbundance3D],
            {ObjectP[Object[EmeraldCloudFile]]..}
        ]
    },
    (* Symbol set up must create the test data *)
    SymbolSetUp :> (
        $CreatedObjects = {};
        setUpTestObjects[];
    ),
    SymbolTearDown :> (
        tearDownTestObjects[];
    ),
    Stubs :> {
        UploadCloudFile[file_String]:=stubUploadCloudFile[file],
        ImportCloudFile[object_]:=testTimeSliceSpans[object]
    }
];

(* helper for setting up tests *)
setUpTestObjects[]:=Module[
    {bigQArray1, bigQArray2, bigQArray3, bigQArray4, packet1, packet2},

    (* make the big q arrays *)
    (* NOTE: using random integers here to make MS data which should be fine, but if testing breaks try here first *)
    bigQArray1 = QuantityArray[
        Flatten[
            Table[
                {time, mass, RandomInteger[10]*RandomInteger[1]},
                {time, 1, 3},
                {mass, 100, 1000, 0.1}
            ],
        1],
        {Minute, Gram/Mole, ArbitraryUnit}
    ];
    bigQArray2 = QuantityArray[
        Flatten[
            Table[
                {time, mass, RandomInteger[10]*RandomInteger[1]},
                {time, 1, 3},
                {mass, 100, 1000, 0.1}
            ],
        1],
        {Minute, Gram/Mole, ArbitraryUnit}
    ];

    (* make abs3d arrays *)
    bigQArray3 = QuantityArray[
        Flatten[
            Table[
                {time, wavelength, N[PDF[NormalDistribution[320, 100]][wavelength]]},
                {time, 1, 3, 1.},
                {wavelength, 180, 500, 1.}
            ],
        1],
        {Minute, Nano Meter, Milli AbsorbanceUnit}
    ];
    bigQArray4 = QuantityArray[
        Flatten[
            Table[
                {time, wavelength, N[PDF[NormalDistribution[250, 100]][wavelength]]},
                {time, 1, 3, 1.},
                {wavelength, 180, 500, 1.}
            ],
        1],
        {Minute, Nano Meter, Milli AbsorbanceUnit}
    ];

    (* make the test packets *)
    packet1 = <|
        Type -> Object[Data, ChromatographyMassSpectra],
        Name -> "Test data 1 - "<>$SessionUUID,
        IonAbundance3D -> bigQArray1,
        Absorbance3D -> bigQArray3
    |>;
    packet2 = <|
        Type -> Object[Data, ChromatographyMassSpectra],
        Name -> "Test data 2 - "<>$SessionUUID,
        IonAbundance3D -> bigQArray2,
        Absorbance3D -> bigQArray4
    |>;

    (* upload packets *)
    Upload[{packet1, packet2}];
];

tearDownTestObjects[]:=Module[
    {objects},

    objects = {
        Object[Data, ChromatographyMassSpectra, "Test data 1 - "<>$SessionUUID],
        Object[Data, ChromatographyMassSpectra, "Test data 2 - "<>$SessionUUID]
    };
	EraseObject[
		PickList[objects,DatabaseMemberQ[objects],True],
		Verbose->False,
		Force->True
	]
];

(* helper to stub out upload cloud file *)
stubUploadCloudFile[file_String]:=Module[
    {},
    If[StringContainsQ[file, "IonAbundance3D"],
        Object[EmeraldCloudFile, "id:xxx"],
        Object[EmeraldCloudFile, "id:yyy"]
    ]
];

(* helper to stub out time slice spans to avoid uploading unnecessary testing data to S3 *)
testTimeSliceSpans[Object[EmeraldCloudFile, "id:xxx"]]:=<|
    (1 Minute) -> {1, 9001},
    (2 Minute) -> {9002, 18002},
    (3 Minute) -> {18003, 27003}
|>;
(* stub out the Abs3D time spans *)
testTimeSliceSpans[Object[EmeraldCloudFile, "id:yyy"]]:=<|
    (1 Minute) -> {1, 321},
    (2 Minute) -> {322, 642},
    (3 Minute) -> {643, 963}
|>;
