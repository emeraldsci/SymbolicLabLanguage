(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*GenerateExperimentReview*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*GenerateExperimentReview*)

DefineTests[GenerateExperimentReview,
    {
        Example[{Basic, "Generate a review of a particular protocol:"},
            GenerateExperimentReview[Object[Protocol, HPLC, "id:aXRlGn00aznk"]],
            ObjectP[Object[EmeraldCloudFile]],
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects, Force->True];
            ),
            TimeConstraint -> 1800
        ],

        (* Tests *)
        Test["Generates a review of a ManualSamplePreparation protocol:",
            GenerateExperimentReview[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"]];
            Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"][ExperimentReviewNotebook],
            ObjectP[Object[EmeraldCloudFile]],
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects, Force->True];
            ),
            TimeConstraint -> 600
        ],
        
        Test["Generates a review of an NMR protocol:",
            GenerateExperimentReview[Object[Protocol, NMR, "id:8qZ1VWkWr5lP"]];
            Object[Protocol, NMR, "id:8qZ1VWkWr5lP"][ExperimentReviewNotebook],
            ObjectP[Object[EmeraldCloudFile]],
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects, Force->True];
            ),
            TimeConstraint -> 600
        ],

        Test["Generates a review of a MeasurepH protocol:",
            GenerateExperimentReview[Object[Protocol, MeasurepH, "id:KBL5DvPp6l3J"]];
            Object[Protocol, MeasurepH, "id:KBL5DvPp6l3J"][ExperimentReviewNotebook],
            ObjectP[Object[EmeraldCloudFile]],
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects, Force->True];
            ),
            TimeConstraint -> 600
        ],

        Test["Generates a notebook with cells:",
            filePath = GenerateExperimentReview[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"],
                Preview -> False,
                Upload -> False
            ];
            Head/@Cells[NotebookOpen[filePath]],
            {CellObject..},
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects, Force->True];
            ),
            TimeConstraint -> 600,
            Variables :> {filePath}
        ],

        (* Options tests *)
        Example[{Options, Upload, "Notebook cloud file is not uploaded when the option value is False:"},
            GenerateExperimentReview[
                Object[Protocol, HPLC, "id:aXRlGn00aznk"],
                Upload -> False
            ],
            _String,
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects,Force->True];
            ),
            TimeConstraint -> 1800
        ],
        Example[{Options, Preview, "Preview notebook is not shown when option value is False:"},
            GenerateExperimentReview[
                Object[Protocol, HPLC, "id:aXRlGn00aznk"],
                Preview -> False
            ],
            ObjectP[Object[EmeraldCloudFile]],
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects,Force->True];
            ),
            TimeConstraint -> 1800
        ],
        Example[{Options, PrimaryData, "Insert custom data to be shown as the \"Primary Data\":"},
            GenerateExperimentReview[
                Object[Protocol, HPLC, "id:aXRlGn00aznk"],
                PrimaryData -> {EmeraldListLinePlot[Table[{val, val^2}, {val, -10, 10}]]}
            ],
            ObjectP[Object[EmeraldCloudFile]],
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects,Force->True];
            ),
            TimeConstraint -> 600
        ],
        Example[{Options, SecondaryData, "Insert custom data to be shown as the \"Secondary Data\":"},
            GenerateExperimentReview[
                Object[Protocol, HPLC, "id:aXRlGn00aznk"],
                SecondaryData -> {EmeraldListLinePlot[Table[{val, val^2}, {val, -10, 10}]]}
            ],
            ObjectP[Object[EmeraldCloudFile]],
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects,Force->True];
            ),
            TimeConstraint -> 1800
        ],

        (* Error tests *)
        Example[{Messages, "ProtocolNotStarted", "Does not generate a review notebook if the protocol is InCart:"},
            GenerateExperimentReview[
                Object[Protocol, HPLC, "Test Protocol HPLC InCart for GenerateExperimentReview " <> $SessionUUID]
            ],
            $Failed,
            Messages :> {GenerateExperimentReview::ProtocolNotStarted}
        ],
        Example[{Messages, "CanceledProtocol", "Does not generate a review notebook if the protocol is Canceled:"},
            GenerateExperimentReview[
                Object[Protocol, HPLC, "Test Protocol HPLC Canceled for GenerateExperimentReview " <> $SessionUUID]
            ],
            $Failed,
            Messages :> {GenerateExperimentReview::CanceledProtocol}
        ],
        Example[{Messages, "ObjectDoesNotExist", "Input must be an object in the database:"},
            GenerateExperimentReview[
                Object[Protocol, HPLC, "id:123"]
            ],
            $Failed,
            Messages :> {Error::ObjectDoesNotExist}
        ],
        Example[{Messages, "IncompleteProtocol", "Does not generate a review notebook if the protocol is Canceled:"},
            GenerateExperimentReview[
                Object[Protocol, RoboticSamplePreparation, "id:bq9LA0968Dav"]
            ],
            ObjectP[Object[EmeraldCloudFile]],
            Messages :> {Warning::IncompleteProtocol},
            SetUp :> (
                $CreatedObjects = {};
            ),
            TearDown :> (
                EraseObject[$CreatedObjects, Force->True];
            ),
            TimeConstraint -> 600
        ]
    },

    HardwareConfiguration -> HighRAM,

    SymbolSetUp :> {
        Module[
            {allNamedObjects, existingObjects},

            (* All named objects created for these unit tests *)
            allNamedObjects = Cases[
                Flatten[{
                    {
                        Object[Protocol, HPLC, "Test Protocol HPLC InCart for GenerateExperimentReview " <> $SessionUUID],
                        Object[Protocol, HPLC, "Test Protocol HPLC Canceled for GenerateExperimentReview " <> $SessionUUID]
                    }
                }],
                ObjectReferenceP[]
            ];

            existingObjects = PickList[allNamedObjects, DatabaseMemberQ[allNamedObjects]];
            EraseObject[existingObjects, Force -> True, Verbose -> False];

            Upload[{
                <|
                    Type -> Object[Protocol, HPLC],
                    Name -> "Test Protocol HPLC InCart for GenerateExperimentReview " <> $SessionUUID,
                    Status -> InCart,
                    DeveloperObject -> True
                |>,
                <|
                    Type -> Object[Protocol, HPLC],
                    Name -> "Test Protocol HPLC Canceled for GenerateExperimentReview " <> $SessionUUID,
                    Status -> Canceled,
                    DeveloperObject -> True
                |>
            }]
        ]
    },

    SymbolTearDown :> {Module[
        {allNamedObjects, existingObjects},

        (* All named objects created for these unit tests *)
        allNamedObjects = Cases[
            Flatten[{
                {
                    Object[Protocol, HPLC, "Test Protocol HPLC InCart for GenerateExperimentReview " <> $SessionUUID],
                    Object[Protocol, HPLC, "Test Protocol HPLC Canceled for GenerateExperimentReview " <> $SessionUUID]
                }
            }],
            ObjectReferenceP[]
        ];

        existingObjects = PickList[allNamedObjects, DatabaseMemberQ[allNamedObjects]];
        EraseObject[existingObjects, Force -> True, Verbose -> False];

    ]}
];


(* ::Subsection:: *)
(*getEnvironmentalData*)

DefineTests[getEnvironmentalData,
    {
        Example[{Basic, "Generate an output with temperature and humidity data from the input protocol:"},
            getEnvironmentalData[Object[Protocol, HPLC, "Test Protocol HPLC 1 for getEnvironmentalData unit tests 1 " <> $SessionUUID]],
            {
                {_String, "Text"},
                _Grid,
                _Grid
            }
        ],
        Example[{Basic, "Generate an output with partial data from the input protocol when less than the expected number of data objects are present:"},
            getEnvironmentalData[Object[Protocol, HPLC, "Test Protocol HPLC 2 for getEnvironmentalData unit tests 1 " <> $SessionUUID]],
            {
                {_String, "Text"},
                _Grid
            }
        ],
        Test["Output an empty list when there is no data object to be plotted:",
            getEnvironmentalData[Object[Protocol, HPLC, "Test Protocol HPLC 3 for getEnvironmentalData unit tests 1 " <> $SessionUUID]],
            {}
        ],
        Test["Output an empty list when there is no data in the data objects to be plotted:",
            getEnvironmentalData[Object[Protocol, HPLC, "Test Protocol HPLC 4 for getEnvironmentalData unit tests 1 " <> $SessionUUID]],
            {}
        ]
    },

    SymbolSetUp :> {
        Module[
            {
                allNamedObjects,
                existingObjects,
                test1Indices,
                generateGetEnvironmentalDataPackets,
                test1Packets,
                allUploadPackets
            },

            (* Number of test systems of each type to generate *)
            test1Indices = Range[1];

            (* All named objects created for these unit tests *)
            allNamedObjects = Cases[
                Flatten[{
                    {
                        Object[Protocol, HPLC, "Test Protocol HPLC 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Protocol, HPLC, "Test Protocol HPLC 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Protocol, HPLC, "Test Protocol HPLC 3 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Protocol, HPLC, "Test Protocol HPLC 4 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, RelativeHumidity, "Test Data RelativeHumidity 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, RelativeHumidity, "Test Data RelativeHumidity 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, RelativeHumidity, "Test Data RelativeHumidity 3 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, Temperature, "Test Data Temperature 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, Temperature, "Test Data Temperature 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Sensor, RelativeHumidity, "Test Sensor RelativeHumidity 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Sensor, RelativeHumidity, "Test Sensor RelativeHumidity 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Sensor, Temperature, "Test Sensor Temperature 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID]
                    } & /@ test1Indices
                }],
                ObjectReferenceP[]
            ];

            existingObjects = PickList[allNamedObjects, DatabaseMemberQ[allNamedObjects]];
            EraseObject[existingObjects, Force -> True, Verbose -> False];

            generateGetEnvironmentalDataPackets[index_Integer] := Module[
                {
                    stringIndex,
                    protocolHPLC1,
                    protocolHPLC2,
                    protocolHPLC3,
                    protocolHPLC4,
                    dataRelativeHumidity1,
                    dataRelativeHumidity2,
                    dataRelativeHumidity3,
                    dataTemperature1,
                    dataTemperature2,
                    sensorRelativeHumidity1,
                    sensorRelativeHumidity2,
                    sensorTemperature1,
                    temperatureLog,
                    humidityLog,
                    logStartDate,
                    logEndDate,
                    dateRange
                },

                stringIndex = ToString[index];

                {
                    protocolHPLC1, (* protocol with 1 temp data and 1 humidity data *)
                    protocolHPLC2, (* protocol with only 1 humidity data and not temperature *)
                    protocolHPLC3, (* protocol with no environmental data objects *)
                    protocolHPLC4, (* protocol with environmental data objects that have Null log values *)
                    dataRelativeHumidity1,
                    dataRelativeHumidity2,
                    dataRelativeHumidity3,
                    dataTemperature1,
                    dataTemperature2,
                    sensorRelativeHumidity1,
                    sensorRelativeHumidity2,
                    sensorTemperature1
                } = CreateID[
                    {
                        Object[Protocol, HPLC],
                        Object[Protocol, HPLC],
                        Object[Protocol, HPLC],
                        Object[Protocol, HPLC],
                        Object[Data, RelativeHumidity],
                        Object[Data, RelativeHumidity],
                        Object[Data, RelativeHumidity],
                        Object[Data, Temperature],
                        Object[Data, Temperature],
                        Object[Sensor, RelativeHumidity],
                        Object[Sensor, RelativeHumidity],
                        Object[Sensor, Temperature]
                    }
                ];

                (* setup the logs *)
                logStartDate = DateObject[{2024, 8, 21, 23, 37, 10.}, "Instant", "Gregorian", -8.];
                logEndDate = DateObject[{2024, 8, 23, 16, 17, 4.}, "Instant", "Gregorian", -8.];
                dateRange = DeleteDuplicates[Append[DateRange[logStartDate, logEndDate, 30 Minute], logEndDate]];

                temperatureLog = QuantityArray[Transpose[{
                    dateRange,
                    ConstantArray[22, Length[dateRange]]
                }], {"DimensionlessUnit", "DegreesCelsius"}];

                humidityLog = QuantityArray[Transpose[{
                    dateRange,
                    ConstantArray[50, Length[dateRange]]
                }], {"DimensionlessUnit", "Percent"}];


                {
                    <|
                        Object -> protocolHPLC1,
                        Type -> Object[Protocol, HPLC],
                        Name -> "Test Protocol HPLC 1 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        Site -> Link[$Site],
                        Replace[EnvironmentalData] -> {Link[dataTemperature1, Protocol], Link[dataRelativeHumidity1, Protocol]},
                        DeveloperObject -> True
                    |>,
                    <|
                        Object -> protocolHPLC2,
                        Type -> Object[Protocol, HPLC],
                        Name -> "Test Protocol HPLC 2 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        Site -> Link[$Site],
                        Replace[EnvironmentalData] -> {Link[dataRelativeHumidity2, Protocol]},
                        DeveloperObject -> True
                    |>,
                    <|
                        Object -> protocolHPLC3,
                        Type -> Object[Protocol, HPLC],
                        Name -> "Test Protocol HPLC 3 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        Site -> Link[$Site],
                        DeveloperObject -> True
                    |>,
                    <|
                        Object -> protocolHPLC4,
                        Type -> Object[Protocol, HPLC],
                        Name -> "Test Protocol HPLC 4 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        Site -> Link[$Site],
                        Replace[EnvironmentalData] -> {Link[dataTemperature2, Protocol], Link[dataRelativeHumidity3, Protocol]},
                        DeveloperObject -> True
                    |>,

                    <|
                        Object -> dataRelativeHumidity1,
                        Type -> Object[Data, RelativeHumidity],
                        Name -> "Test Data RelativeHumidity 1 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        FirstDataPoint -> DateObject[{2024, 8, 21, 23, 37, 10.}, "Instant", "Gregorian", -8.],
                        LastDataPoint -> DateObject[{2024, 8, 23, 16, 17, 4.}, "Instant", "Gregorian", -8.],
                        Sensor -> Link[sensorRelativeHumidity1, Data],
                        RelativeHumidityLog -> humidityLog,
                        (* ideally we'd have a calibration object here but the tests get by fine without making one *)
                        Replace[RawData] -> {{Null, humidityLog}},
                        DeveloperObject -> True
                    |>,
                    <|
                        Object -> dataRelativeHumidity2,
                        Type -> Object[Data, RelativeHumidity],
                        Name -> "Test Data RelativeHumidity 2 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        FirstDataPoint -> DateObject[{2024, 8, 21, 23, 37, 10.}, "Instant", "Gregorian", -8.],
                        LastDataPoint -> DateObject[{2024, 8, 23, 16, 17, 4.}, "Instant", "Gregorian", -8.],
                        Sensor -> Link[sensorRelativeHumidity2, Data],
                        RelativeHumidityLog -> humidityLog,
                        (* ideally we'd have a calibration object here but the tests get by fine without making one *)
                        Replace[RawData] -> {{Null, humidityLog}},
                        DeveloperObject -> True
                    |>,
                    <|
                        Object -> dataRelativeHumidity3,
                        Type -> Object[Data, RelativeHumidity],
                        Name -> "Test Data RelativeHumidity 3 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        DeveloperObject -> True
                    |>,

                    <|
                        Object -> dataTemperature1,
                        Type -> Object[Data, Temperature],
                        Name -> "Test Data Temperature 1 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        FirstDataPoint -> DateObject[{2024, 8, 21, 23, 37, 10.}, "Instant", "Gregorian", -8.],
                        LastDataPoint -> DateObject[{2024, 8, 23, 16, 17, 4.}, "Instant", "Gregorian", -8.],
                        Sensor -> Link[sensorTemperature1, Data],
                        TemperatureLog -> temperatureLog,
                        (* ideally we'd have a calibration object here but the tests get by fine without making one *)
                        Replace[RawData] -> {{Null, temperatureLog}},
                        DeveloperObject -> True
                    |>,
                    <|
                        Object -> dataTemperature2,
                        Type -> Object[Data, Temperature],
                        Name -> "Test Data Temperature 2 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        DeveloperObject -> True
                    |>,

                    <|
                        Object -> sensorRelativeHumidity1,
                        Type -> Object[Sensor, RelativeHumidity],
                        Name -> "Test Sensor RelativeHumidity 1 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        Model -> Link[Model[Sensor, RelativeHumidity, "id:M8n3rxYE5Lnl"], Objects],
                        Site -> Link[$Site],
                        DeveloperObject -> True
                    |>,
                    <|
                        Object -> sensorRelativeHumidity2,
                        Type -> Object[Sensor, RelativeHumidity],
                        Name -> "Test Sensor RelativeHumidity 2 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        Model -> Link[Model[Sensor, RelativeHumidity, "id:M8n3rxYE5Lnl"], Objects],
                        Site -> Link[$Site],
                        DeveloperObject -> True
                    |>,

                    <|
                        Object -> sensorTemperature1,
                        Type -> Object[Sensor, Temperature],
                        Name -> "Test Sensor Temperature 1 for getEnvironmentalData unit tests " <> stringIndex <> " " <> $SessionUUID,
                        Model -> Link[Model[Sensor, Temperature, "id:WNa4ZjRr58aR"], Objects],
                        Site -> Link[$Site],
                        DeveloperObject -> True
                    |>
                }
            ];

            (* Generate test system packets *)
            test1Packets = generateGetEnvironmentalDataPackets /@ test1Indices;

            (* Combine packets for upload *)
            allUploadPackets = Flatten[{test1Packets}];

            Upload[allUploadPackets]
        ]
    },
    SymbolTearDown :> {
        Module[
            {allNamedObjects, existingObjects, test1Indices},

            (* Number of test systems of each type to generate *)
            test1Indices = Range[1];

            (* All named objects created for these unit tests *)
            allNamedObjects = Cases[
                Flatten[{
                    {
                        Object[Protocol, HPLC, "Test Protocol HPLC 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Protocol, HPLC, "Test Protocol HPLC 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Protocol, HPLC, "Test Protocol HPLC 3 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, RelativeHumidity, "Test Data RelativeHumidity 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, RelativeHumidity, "Test Data RelativeHumidity 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, RelativeHumidity, "Test Data RelativeHumidity 3 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, Temperature, "Test Data Temperature 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, Temperature, "Test Data Temperature 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Data, Temperature, "Test Data Temperature 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Sensor, RelativeHumidity, "Test Sensor RelativeHumidity 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Sensor, RelativeHumidity, "Test Sensor RelativeHumidity 2 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID],
                        Object[Sensor, Temperature, "Test Sensor Temperature 1 for getEnvironmentalData unit tests " <> ToString[#] <> " " <> $SessionUUID]
                    } & /@ test1Indices
                }],
                ObjectReferenceP[]
            ];

            existingObjects = PickList[allNamedObjects, DatabaseMemberQ[allNamedObjects]];
            EraseObject[existingObjects, Force -> True, Verbose -> False];

        ]
    }
];

(* ::Subsection:: *)
(*getInstrumentData*)

DefineTests[getInstrumentData,
    {
        Example[{Basic, "Generate tables for primary and secondary instruments:"},
            getInstrumentData[Object[Protocol, HPLC, "id:aXRlGn00aznk"]],
            {
                {"Primary Instruments", "Subsection", Open},
                _Grid,
                {"Secondary Instruments", "Subsection", Close},
                _SlideView
            }
        ],
        Example[{Basic, "Generate tables for preparatory instruments only for protocols without a primary instrument:"},
            getInstrumentData[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"]],
            {
                {"Preparatory Instruments", "Subsection", Open},
                _SlideView
            }
        ],
        Test["Instrument tables are only generated for parent protocols:",
            getInstrumentData[Object[Protocol, StockSolution, "id:R8e1PjBBxbVJ"]],
            {}
        ]
    }
];

(* ::Subsection:: *)
(*getPricingData*)

DefineTests[getPricingData,
    {
        Example[{Basic, "Generate materials pricing table and instrument costs table for a protocol:"},
            getPricingData[Object[Protocol, HPLC, "id:aXRlGn00aznk"]],
            {
                {"Materials Cost", "Subsection", Open},
                {_String, "Text"},
                _Pane,
                {"Capital Equipment Value", "Subsection", Open},
                {{_String, _StyleBox, _String}, "Text"},
                _Pane
            }
        ],
        Test["Pricing tables are only generated for parent protocols:",
            getPricingData[Object[Protocol, StockSolution, "id:R8e1PjBBxbVJ"]],
            {}
        ]
    }
];

(* ::Subsection:: *)
(*imageSamplePrimaryData*)

(* NOTE: Slides are Columns instead of SlideViews because the slide view is in a column with the *)
(* comment about what date/time that the information in the slide represents. *)
DefineTests[imageSamplePrimaryData,
    {
        Example[{Basic, "Generate SamplesIn and SamplesOut slides for a protocol:"},
            imageSamplePrimaryData[Object[Protocol, ImageSample, "id:54n6evJGa7Ol"]],
            {_SlideView}
        ],
        Example[{Basic, "If a imaging protocol does not have images, a protocol summary is displayed:"},
            imageSamplePrimaryData[Object[Protocol, ImageSample, "id:aXRlGn09NkeX"]],
            {_DynamicModule}
        ]
    }
];

(* ::Subsection:: *)
(*measureWeightPrimaryData*)

DefineTests[measureWeightPrimaryData,
    {
        Example[{Basic, "Display a summary table and slides of individual sample data measurements from a MeasureWeight protocol with an Analytical balance type:"},
            measureWeightPrimaryData[Object[Protocol, MeasureWeight, "id:Vrbp1jvvVnEq"]],
            {_DynamicModule}
        ],
        Example[{Basic, "Display data from a tare weight measurement protocol:"},
            measureWeightPrimaryData[Object[Protocol, MeasureWeight, "id:P5ZnEjxxvzbl"]],
            {_Labeled}
        ],
        Example[{Basic, "Display a summary table and slides of individual sample data measurements from a MeasureWeight protocol with a Bulk balance type:"},
            measureWeightPrimaryData[Object[Protocol, MeasureWeight, "id:1ZA60vzzd3pP"]],
            {_DynamicModule}
        ]
    }
];

(* ::Subsection:: *)
(*getSampleData*)

DefineTests[getSampleData,
    {
        Example[{Basic, "Generate SamplesIn and SamplesOut slides for a protocol:"},
            getSampleData[Object[Protocol, StockSolution, "id:pZx9joO0p634"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Output Samples", "Subsection", Open},
                {"Output Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Example[{Basic, "Generate resource sample slides for a protocol:"},
            getSampleData[Object[Protocol, HPLC, "id:eGakldeODvWo"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Plates", "Subsubsection", Open},
                _Column,
                {"Protocol Samples", "Subsection", Open},
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Example[{Basic, "Generate SamplesIn slides for both vessels and plates:"},
            getSampleData[Object[Protocol, RoboticSamplePreparation, "id:M8n3rxnN0ao9"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Input Samples in Plates", "Subsubsection", Open},
                _Column,
                {"Output Samples", "Subsection", Open},
                {"Output Samples in Plates", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentMeasurepH protocols:",
            getSampleData[Object[Protocol, MeasurepH, "id:mnk9jOkOodVN"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Protocol Samples", "Subsection", Open},
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentMeasureConductivity protocols:",
            getSampleData[Object[Protocol, MeasureConductivity, "id:dORYzZRe7ozb"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Input Samples in Plates", "Subsubsection", Open},
                _Column,
                {"Protocol Samples", "Subsection", Open},
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentMeasureDensity protocols:",
            getSampleData[Object[Protocol, MeasureDensity, "id:mnk9jOkLNbEZ"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentHPLC protocols:",
            getSampleData[Object[Protocol, HPLC, "id:7X104v13RPl9"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Plates", "Subsubsection", Open},
                _Column,
                {"Protocol Samples", "Subsection", Open},
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentGasChromatography protocols:",
            getSampleData[Object[Protocol, GasChromatography, "id:Vrbp1jbPdYJb"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Protocol Samples", "Subsection", Open},
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentDegas protocols:",
            getSampleData[Object[Protocol, Degas, "id:KBL5DvLKBnWa"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Output Samples", "Subsection", Open},
                {"Output Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentMeasureOsmolality protocols:",
            getSampleData[Object[Protocol, MeasureOsmolality, "id:rea9jlajGOJo"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Protocol Samples", "Subsection", Open},
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ],
        Test["Generate slides for ExperimentMeasureRefractiveIndex protocols:",
            getSampleData[Object[Protocol, MeasureRefractiveIndex, "id:o1k9jAkrWXpa"]],
            {
                {"Input Samples", "Subsection", Open},
                {"Input Samples in Vessels", "Subsubsection", Open},
                _Column,
                {"Protocol Samples", "Subsection", Open},
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                _Column
            },
            TimeConstraint -> 600
        ]
    }
];

(* ::Subsection:: *)
(*getPrimaryData*)

DefineTests[getPrimaryData,
    {
        Example[{Basic, "Generates primary data plots using PlotObject when a protocol-specific plotting helper does not exist:"},
            getPrimaryData[Object[Protocol, HPLC, "id:aXRlGn00aznk"]],
            {_SlideView},
            Stubs:>{
                $PrimaryDataPlotter = <||>
            }
        ],
        Example[{Basic, "Generates primary data table using a protocol-specific plotting helper when one exists:"},
            getPrimaryData[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"]],
            {_Labeled}
        ],
        Test["Does not generate an output for preparative protocols that don't have a plotting helper:",
            getPrimaryData[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"]],
            {},
            Stubs:>{
                $PrimaryDataPlotter = <||>
            }
        ]
    }
];

(* ::Subsection:: *)
(*getSecondaryData*)

DefineTests[getSecondaryData,
    {
        Example[{Basic, "Generates secondary data content from the checkpoints:"},
            getSecondaryData[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"]],
            {
                {"Checkpoints & Supporting Protocols", "Subsection"},
                {"Checkpoint 1: Picking Resources", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 2: Sample Preparation", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 3: Returning Materials", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                _OpenerView,
                _OpenerView,
                {_, "Text"},
                {"", "Text"}
            },
            Stubs:>{
                $SecondaryDataPlotter = <||>
            }
        ],

        (* Options test *)
        Example[{Options, CustomData, "Generates secondary data content from the checkpoints:"},
            getSecondaryData[Object[Protocol, HPLC, "id:aXRlGn00aznk"],
                CustomData -> {
                    EmeraldListLinePlot[Table[{val, val^2}, {val, -10, 10}]]
                }
            ],
            {
                _Graphics,
                {"Checkpoints & Supporting Protocols", "Subsection"},
                {"Checkpoint 1: Picking Resources", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                _OpenerView,
                _OpenerView,
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 2: Purging Instrument", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 3: Priming Instrument", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                _OpenerView,
                _OpenerView,
                _OpenerView,
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 4: Preparing Instrument", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                _OpenerView,
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 5: Running Samples", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                _OpenerView,
                _OpenerView,
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 6: Sample Post-Processing", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 7: Flushing Instrument", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                _OpenerView,
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 8: Exporting Data", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 9: Cleaning Up", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                _OpenerView,
                {_, "Text"},
                {"", "Text"},
                {"Checkpoint 10: Returning Materials", "Subsubsection"},
                {_, "Text"},
                {_String, "Text"},
                {_, "Text"},
                {"", "Text"}
            }
        ]
    }
];

(* ::Subsection:: *)
(*measureVolumePrimaryData*)

DefineTests[measureVolumePrimaryData,
    {
        Example[{Basic, "Generates primary data tables for gravimetrically measured samples:"},
            measureVolumePrimaryData[Object[Protocol, MeasureVolume, "id:WNa4ZjMM7vpD"]],
            {_DynamicModule}
        ],
        Example[{Basic, "Generates primary data tables for ultrasonically measured samples:"},
            getPrimaryData[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"]],
            {_Labeled}
        ]
    }
];

(* ::Subsection:: *)
(*spPrimaryData*)

DefineTests[spPrimaryData,
    {
        Example[{Basic, "Generate a TabView figure showing details about the unit operations in a MSP protocol:"},
            spPrimaryData[Object[Protocol, ManualSamplePreparation, "id:aXRlGn06qVBj"]],
            {_Labeled}
        ],
        Example[{Basic, "Generate a TabView figure showing details about the unit operations in a RSP protocol:"},
            spPrimaryData[Object[Protocol, RoboticSamplePreparation, "id:Vrbp1jvvv0Ve"]],
            {_Labeled}
        ]
    }
];

(* ::Subsection:: *)
(*rspPrimaryData*)

DefineTests[rspPrimaryData,
    {
        Example[{Basic, "Display a thumbnail link to the video stream, TADM data, and unit operation data for a RSP protocol:"},
            rspPrimaryData[Object[Protocol, RoboticSamplePreparation, "id:xRO9n3ExYKzO"]],
            {
                List[List[___], _String], (*text description*)
                Button[___], (*link to video*)
                List[List[___], _String], (*text description*)
                Magnify[TabView[___], _], (*TADM data*)
                Magnify[Labeled[___], _] (*unit operation data*)
            }
        ],
        Test["Generate an output even if the protocol has no streams or pressure data:",
            rspPrimaryData[Object[Protocol, RoboticSamplePreparation, "id:Z1lqpMr6RROW"]],
            {Magnify[Labeled[___], _]} (*unit operation data*)
        ]
    }
];

(* ::Subsection:: *)
(*mspPrimaryData*)

DefineTests[mspPrimaryData,
    {
        Example[{Basic, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains LabelContainer, Transfer, Mix, and FluorescenceKinetics unit operations:"},
            mspPrimaryData[Object[Protocol,ManualSamplePreparation,"id:aXRlGn06qVBj"]],
            {_Labeled}
        ],
        Example[{Basic, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains LabelContainer, Transfer, and LabelSample unit operations:"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:pZx9joO38Pbj"]],
            {_Labeled}
        ],
        Example[{Basic, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains Filter unit operations:"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:O81aEB1jDblo"]],
            {_Labeled}
        ],
        Example[{Basic, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains Transfer and FillToVolume unit operations:"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:XnlV5jNELD8Z"]],
            {_Labeled}
        ],
        Example[{Basic, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains Incubate unit operations wherein a stream of an Object[Instrument, OverheadStirrer] was recorded (basic case):"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:dORYzZdZ8brG"]],
            {_Labeled}
        ],
        Example[{Additional, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains Incubate unit operations wherein streams of Object[Instrument, OverheadStirrer]s were recorded (more streams than samples case):"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:Vrbp1jvjzdax"]],
            {_Labeled}
        ],
        Example[{Additional, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains Incubate unit operations wherein streams of Object[Instrument, OverheadStirrer]s were recorded (fewer streams than samples case):"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:xRO9n3E5eL1w"]],
            {_Labeled}
        ],
        Example[{Additional, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains Incubate unit operations wherein streams of Object[Instrument, OverheadStirrer]s were recorded (multiple MixTypes case):"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:wqW9BPzDEDdM"]],
            {_Labeled}
        ],
        Example[{Additional, "Generate a TabView figure showing details about the unit operations in a MSP protocol that contains a Transfer unit operation wherein WeightAppearance images were taken:"},
            mspPrimaryData[Object[Protocol, ManualSamplePreparation, "id:GmzlKjNpXYRE"]],
            {_Labeled}
        ]
    }
];

(* ::Subsection:: *)
(*gasChromatographyPrimaryData*)

DefineTests[gasChromatographyPrimaryData,
    {
        Example[{Basic, "Generate an injection table and figures for sample data from a GCMS protocol:"},
            gasChromatographyPrimaryData[Object[Protocol, GasChromatography, "id:Vrbp1jKPARGq"]],
            {
                {"Condensed Injection Table", "Subsection"},
                _Pane,
                {"Sample Data", "Subsection"},
                _SlideView
            }
        ],
        Example[{Basic, "Generate an injection table and figures for sample and blank data from a GC protocol:"},
            gasChromatographyPrimaryData[Object[Protocol, GasChromatography, "id:WNa4ZjKjalN4"]],
            {
                {"Condensed Injection Table", "Subsection"},
                _Pane,
                {"Sample Data", "Subsection"},
                _SlideView,
                {"Blank Data", "Subsection"},
                _SlideView
            }
        ]
    }
];

(* ::Subsection:: *)
(*ionChromatographyPrimaryData*)

DefineTests[ionChromatographyPrimaryData,
    {
        Example[{Basic, "Generate injection tables and data plot tables for IonChromatography protocols:"},
            ionChromatographyPrimaryData[Object[Protocol, IonChromatography, "id:n0k9mGOOBmO6"]],
            {
                {"Condensed Anion Injection Table", "Subsection"},
                _Pane,
                {"Condensed Cation Injection Table", "Subsection"},
                _Pane,
                {"Anion Detector Sample Data", "Subsection"},
                _SlideView,
                {"Anion Detector Blank Data", "Subsection"},
                _SlideView,
                {"Anion Detector Column Prime Data", "Subsection"},
                _SlideView,
                {"Anion Detector Column Flush Data", "Subsection"},
                _SlideView,
                {"Cation Detector Sample Data", "Subsection"},
                _SlideView,
                {"Cation Detector Blank Data", "Subsection"},
                _SlideView,
                {"Cation Detector Column Prime Data", "Subsection"},
                _SlideView,
                {"Cation Detector Column Flush Data", "Subsection"},
                _SlideView
            }
        ]
    }
];

(* ::Subsection:: *)
(*thermalShiftPrimaryData*)

DefineTests[thermalShiftPrimaryData,
    {
        Example[{Basic, "Generate primary data for a thermal shift protocol with 2D melting curve data:"},
            thermalShiftPrimaryData[Object[Protocol, ThermalShift, "id:R8e1PjexNzmp"]],
            {_SlideView}
        ],

        Example[{Basic, "Generate primary data for a thermal shift protocol with 3D melting curve data:"},
            thermalShiftPrimaryData[Object[Protocol, ThermalShift, "id:Vrbp1jKlkm1x"]],
            {_SlideView}
        ]
    }
];

(* ::Subsection:: *)
(*hplcPrimaryData*)

DefineTests[hplcPrimaryData,
    {
        Example[{Basic, "Generate a dynamic table with chromatographs and corresponding meta-data:"},
            hplcPrimaryData[Object[Protocol, HPLC, "id:aXRlGn00aznk"]],
            {
                {
                    {
                        StyleBox["Chromatography Type: ", FontWeight -> "Bold", FontSize -> 16],
                        StyleBox["ReversePhase", FontSize -> 16]
                    },
                    "Text"
                },
                {
                    {
                        StyleBox["Scale: ", FontWeight -> "Bold", FontSize -> 16],
                        StyleBox["Analytical", FontSize -> 16]
                    },
                    "Text"
                },
                _Manipulate
            }
        ],
        Example[{Basic, "Output a message to indicate when data is not available:"},
            hplcPrimaryData[Object[Protocol, HPLC, "id:01G6nvD87kMm"]],
            {"This protocol was aborted and does not have chromatograms to display.", "Text"}
        ]
    }
];

(* ::Subsection:: *)
(*hplcSecondaryData*)

DefineTests[hplcSecondaryData,
    {
        Example[{Basic, "Assemble secondary information about the column, guard, mobile phases, and system prime and flush:"},
            hplcSecondaryData[Object[Protocol, HPLC, "id:aXRlGn00aznk"]],
            {
                {"Column Information", "Subsection"},
                _Column,
                {"Guard Column Information", "Subsection"},
                _Column,
                {"Mobile Phases", "Subsection"},
                _Grid,
                {"System Prime", "Subsection", Close},
                {"Chromatograms collected during the system prime", "Text"},
                _Grid,
                {"Buffers used during the system prime", "Text"},
                _Grid,
                {"System Flush", "Subsection", Close},
                {"Chromatogram collected during the system flush", "Text"},
                _Grid,
                {"Buffers used during the system flush", "Text"},
                _Grid
            }
        ],
        Example[{Basic, "Assemble partial information available for partially completed protocols:"},
            hplcSecondaryData[Object[Protocol, HPLC, "id:01G6nvD87kMm"]],
            {
                {"Column Information", "Subsection"},
                _Column,
                {"Mobile Phases", "Subsection"},
                _Grid,
                {"System Prime", "Subsection", Close},
                {"Buffers used during the system prime", "Text"},
                _Grid
            }
        ]
    }
];

(* ::Subsection:: *)
(*lcColumnTable*)

DefineTests[lcColumnTable,
    {
        Example[{Basic, "Assemble a table with information about the column used in an HPLC protocol:"},
            lcColumnTable[Object[Protocol, HPLC, "id:aXRlGn00aznk"], Column],
            Column[{_Grid, _Style}]
        ],
        Example[{Basic, "Assemble a table with information about the guard column used in an HPLC protocol:"},
            lcColumnTable[Object[Protocol, HPLC, "id:aXRlGn00aznk"], GuardColumn],
            Column[{_Grid, _Style}]
        ],
        Test["Return a Null output when a GuardColumn is not used:",
            lcColumnTable[Object[Protocol, HPLC, "id:01G6nvD87kMm"], GuardColumn],
            NullP
        ]
    }
];

(* ::Subsection:: *)
(*lcColumnTable*)

DefineTests[lcBufferTable,
    {
        Example[{Basic, "Assemble a table with information about the mobile phase buffers used during the protocol:"},
            lcBufferTable[Object[Protocol, HPLC, "id:aXRlGn00aznk"], Sample],
            _Grid
        ],
        Example[{Basic, "Assemble a table with information about the buffers used during system prime:"},
            lcBufferTable[Object[Protocol, HPLC, "id:aXRlGn00aznk"], SystemPrime],
            _Grid
        ],
        Example[{Basic, "Assemble a table with information about the buffers used during system flush:"},
            lcBufferTable[Object[Protocol, HPLC, "id:aXRlGn00aznk"], SystemFlush],
            _Grid
        ],
        Test["Return a Null output when system flush is not done for a partially complete protocol:",
            lcBufferTable[Object[Protocol, HPLC, "id:01G6nvD87kMm"], SystemFlush],
            NullP
        ]
    }
];

(* ::Subsection:: *)
(*nmrPrimaryData*)

DefineTests[nmrPrimaryData,
    {
        Example[{Basic, "Generate a dynamic table with NMR spectra, sample images, and corresponding meta-data for one sample:"},
            nmrPrimaryData[Object[Protocol, NMR, "id:8qZ1VWkWr5lP"]],
            {_Grid}
        ],
        Example[{Basic, "Generate a dynamic table with NMR spectra, sample images, and corresponding meta-data for multiple samples:"},
            nmrPrimaryData[Object[Protocol, NMR, "id:qdkmxzGB7XZx"]],
            {_Grid}
        ],
        Example[{Basic, "Generate a dynamic table with 2D NMR spectra, sample images, and corresponding meta-data for one sample:"},
            nmrPrimaryData[Object[Protocol, NMR2D, "id:xRO9n3OP1amO"]],
            {_Grid}
        ],
        Example[{Basic, "Generate a dynamic table with 2D NMR spectra, sample images, and corresponding meta-data for multiple samples:"},
            nmrPrimaryData[Object[Protocol, NMR2D, "id:O81aEBZGPlb1"]],
            {_Grid}
        ]
    }
];

(* ::Subsection:: *)
(*measurepHPrimaryData*)

DefineTests[measurepHPrimaryData,
    {
        Example[{Basic, "Generate data tables for an Object[Protocol, MeasurepH] with one sample whose pH value was measured once:"},
            measurepHPrimaryData[Object[Protocol, MeasurepH, "id:KBL5DvPp6l3J"]],
            {_Column}
        ],
        Example[{Basic, "Generate summary and data tables for an Object[Protocol, MeasurepH] with multiple samples whose pH values were measured once:"},
            measurepHPrimaryData[Object[Protocol, MeasurepH, "id:XnlV5jNYxLjZ"]],
            {_Column}
        ],
        Example[{Basic, "Generate data tables for an Object[Protocol, MeasurepH] with one sample whose pH value was measured multiple times:"},
            measurepHPrimaryData[Object[Protocol, MeasurepH, "id:7X104v6ajDKd"]],
            {_Column}
        ],
        Example[{Basic, "Generate summary and data tables for an Object[Protocol, MeasurepH] with multiple samples whose pH values were measured multiple times, where no calibration data is provided:"},
            measurepHPrimaryData[Object[Protocol, MeasurepH, "id:3em6Zvr3Zz9B"]],
            {_Column}
        ],
        Example[{Basic, "Generate summary and data tables for an Object[Protocol, MeasurepH] with multiple samples whose pH values were measured multiple times, and for which multiple calibrations were performed:"},
            measurepHPrimaryData[Object[Protocol, MeasurepH, "id:9RdZXvNjz8X9"]],
            {_Column}
        ]
    }
];